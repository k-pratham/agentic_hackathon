import logging
from fastapi import FastAPI, HTTPException
from fastapi.responses import JSONResponse
from pydantic import BaseModel
from langchain_core.messages import HumanMessage
from .graph import build_graph

# Configure logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(name)s - %(levelname)s - %(message)s")
logger = logging.getLogger(__name__)

app = FastAPI(title="Agentic Banking RAG API")

# Compile the graph
agent_workflow = build_graph()

class ChatRequest(BaseModel):
    thread_id: str
    message: str
    department_id: int
    action: str = "chat" # 'chat' or 'resume'

@app.post("/api/v1/chat")
async def chat_endpoint(req: ChatRequest):
    config = {"configurable": {"thread_id": req.thread_id}}
    
    try:
        if req.action == "resume":
            # Resume from an interruption (e.g. human answered the Clarifier)
            state = agent_workflow.get_state(config)
            if not state.next:
                raise HTTPException(status_code=400, detail="No active interruption to resume from.")
                
            # Update state with the human's response
            agent_workflow.update_state(config, {"messages": [HumanMessage(content=req.message)]})
            
            # Resume execution (passing None means just continue)
            result = agent_workflow.invoke(None, config)
            
        else:
            # Start a new chat
            initial_state = {
                "original_query": req.message,
                "department_id": req.department_id,
                "messages": [HumanMessage(content=req.message)]
            }
            result = agent_workflow.invoke(initial_state, config)
            
        # Check if the graph paused at the Clarifier
        current_state = agent_workflow.get_state(config)
        if current_state.next and "clarifier" in current_state.next:
            return {
                "status": "requires_clarification",
                "message": current_state.values.get("clarification_question", "Please clarify.")
            }
            
        # If it finished normally, return the final response
        final_message = current_state.values["messages"][-1].content
        chart = current_state.values.get("chart_json", {})
        
        return {
            "status": "complete",
            "message": final_message,
            "chart_metadata": chart
        }
        
    except Exception as e:
        logger.error(f"Unhandled server error: {str(e)}", exc_info=True)
        return JSONResponse(
            status_code=500,
            content={"status": "error", "message": "An unexpected server error occurred.", "details": str(e)}
        )

@app.get("/api/v1/chat/history/{thread_id}")
async def get_chat_history(thread_id: str):
    """
    Retrieve the entire persistent chat history for a given thread_id.
    Rehydrates from the Oracle Database Checkpointer.
    """
    config = {"configurable": {"thread_id": thread_id}}
    try:
        state = agent_workflow.get_state(config)
        if not state or not state.values:
            return {"status": "success", "messages": []}
            
        messages = []
        for msg in state.values.get("messages", []):
            role = "user" if isinstance(msg, HumanMessage) else "assistant"
            messages.append({"role": role, "content": msg.content})
            
        return {"status": "success", "messages": messages}
    except Exception as e:
        logger.error(f"Error retrieving history: {str(e)}", exc_info=True)
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
