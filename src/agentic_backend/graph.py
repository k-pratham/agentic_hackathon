import os
import operator
from typing import TypedDict, Annotated, List, Dict, Any
from langgraph.graph import StateGraph, END
from langchain_core.messages import HumanMessage, SystemMessage, BaseMessage
from langchain_openai import ChatOpenAI
import sys
import os

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from ingestion.config.settings import get_settings
from ingestion.db.connection import OracleConnectionPool
from .oracle_saver import OracleSaver

from .tools import (
    check_knowledge_scope, data_discovery_tool, search_schema_index, 
    execute_oracle_sql, search_regulatory_vectors, python_data_tool, chart_config_tool
)

def get_llm(model_name: str, temperature: float):
    settings = get_settings()
    base_url = settings.aphrodite.base_url
    api_key = settings.aphrodite.api_key or "EMPTY"
    return ChatOpenAI(model=model_name, base_url=base_url, api_key=api_key, temperature=temperature)

# --- State Definition ---
class GlobalState(TypedDict):
    department_id: int
    messages: Annotated[List[BaseMessage], operator.add]
    original_query: str
    sub_queries: Dict[str, Any]
    execution_plan: List[str]
    discovered_entities: List[str]
    schema_context: str
    sql_query: str
    sql_results: str
    analytical_insights: str
    vector_findings: str
    chart_json: Dict[str, Any]
    error_logs: Annotated[List[str], operator.add]
    requires_clarification: bool
    clarification_question: str
    clarifier_return_node: str

# --- Nodes (Agents) ---

def orchestrator_node(state: GlobalState) -> Dict:
    settings = get_settings()
    llm = get_llm(settings.aphrodite.reasoning.model, settings.aphrodite.reasoning.temperature)
    query = state.get("original_query", state["messages"][-1].content if state["messages"] else "")
    department_id = state.get("department_id")
    
    # Check entities mapped to this department
    entity_check = data_discovery_tool.invoke({"entity_name": query, "department_id": department_id})
    scope_check = check_knowledge_scope.invoke(query)
    
    prompt = f"""You are the Intent Classifier & Router for SAMVAD. You must decide whether to
route the user's query to DAKSH or CIMS/DBIE based on the Data Dictionary below.
The discriminator is the TYPE OF DATA requested, not the surface wording of the
query. You only decide the route; you fetch nothing and answer nothing yourself.

=====================================================================
[DAKSH — Supervisory Data | entity-level | role-gated] (Maps to 'vector')
=====================================================================
Route here if the query concerns the SUPERVISION OF A SPECIFIC ENTITY, or is
framed in supervisory / inspection / risk / compliance terms. Signals:
  - Entity & supervisory master
  - Inspection & assessment
  - Compliance & follow-up
  - Entity-level metrics IN A SUPERVISORY CONTEXT
  - Supervisory workflows & artifacts

=====================================================================
[CIMS / DBIE — Macroeconomic & Banking Statistics | published | system-level] (Maps to 'structured')
=====================================================================
Route here if the query concerns PUBLISHED, AGGREGATE, SYSTEM-LEVEL economic or
banking data, with NO specific supervised entity as the subject. Signals:
  - Real sector, Prices & inflation, Monetary & banking aggregates, Financial markets

=====================================================================
THE DISCRIMINATOR (apply when signals conflict)
=====================================================================
Ask, in order:
  1. Is a SPECIFIC supervised entity the subject of the query?           -> DAKSH
  2. Is the framing supervisory (inspection / risk / compliance / rating)? -> DAKSH
  3. Otherwise, is it a published macro / banking / sector AGGREGATE?     -> CIMS/DBIE

=====================================================================
HYBRID, ACCESS, AND FALL-THROUGH RULES
=====================================================================
  - HYBRID: if the query needs a supervisory figure AND the regulatory text that governs it, route to both DAKSH and CIMS/DBIE.
  - FALL-THROUGH: if the query fits NEITHER dictionary, output "BEYOND_SCOPE".
  - AMBIGUOUS: if you need to ask the user to clarify the year or entity, output "CLARIFY".

User Query: "{query}"

System Context & Tool Checks:
- Knowledge Scope Policy: {scope_check}
- Entity Discovery Check: {entity_check}
(If the entity is NOT FOUND in this department, do not attempt to route to DAKSH. Output "BEYOND_SCOPE" instead due to RBAC restrictions).

Output ONLY a raw JSON dictionary with the following keys:
- "route": "DAKSH", "CIMS_DBIE", "HYBRID", "BEYOND_SCOPE", or "CLARIFY"
- "analysis_required": boolean (true if assessing/ranking)
- "visualization_required": boolean (true if asking for a chart/graph)
"""
    import json
    import re
    import json_repair
    
    try:
        res = llm.invoke([SystemMessage(content=prompt)])
        content = res.content
        # Remove <think> tags completely
        if "</think>" in content:
            content = content.split("</think>")[-1]
            
        content = content.replace("```json", "").replace("```", "").strip()
        
        # Use json-repair to parse malformed or messy JSON
        decision = json_repair.loads(content)
        
        # json_repair might return a list if it finds multiple objects
        if isinstance(decision, list) and len(decision) > 0:
            decision = decision[-1]
            
        if not decision or not isinstance(decision, dict) or "route" not in decision:
            raise ValueError(f"No valid JSON found in output")
            
        route = decision.get("route", "")
    except Exception as e:
        import traceback
        error_msg = str(e)
        raw_out = res.content if 'res' in locals() else 'None'
        import logging
        logging.getLogger(__name__).error(f"Orchestrator LLM Failed: {e} | Raw Output: {raw_out}")
        
        # Fallback to frontend so user can see exactly why it failed
        return {
            "requires_clarification": True,
            "execution_plan": [],
            "clarification_question": f"SYSTEM ERROR: {error_msg}\n\nRAW LLM OUTPUT:\n{raw_out}",
            "clarifier_return_node": "orchestrator",
            "original_query": query
        }
        
    plan = []
    clarify = False
    question = ""
    
    if route == "CLARIFY":
        clarify = True
        question = "Could you please specify the year or entity you are looking for?"
    elif route == "BEYOND_SCOPE":
        return {"messages": [SystemMessage(content="This query is beyond our scope at this moment.")], "clarifier_return_node": "orchestrator", "original_query": query}
    else:
        if route in ["CIMS_DBIE", "HYBRID"]:
            plan.append("structured")
        if route in ["DAKSH", "HYBRID"]:
            plan.append("vector")
        
        if decision.get("analysis_required"):
            plan.append("analyst")
        if decision.get("visualization_required"):
            plan.append("viz")

    return {
        "requires_clarification": clarify,
        "execution_plan": plan,
        "clarification_question": "Could you please specify the year or entity you are looking for?" if clarify else "",
        "clarifier_return_node": "orchestrator",
        "original_query": query
    }

def clarifier_node(state: GlobalState) -> Dict:
    # This node simply passes the question to the frontend.
    # The frontend will hit the 'interrupt' and display `clarification_question`.
    return {"messages": [SystemMessage(content=state.get("clarification_question", "Please clarify."))]}

def structured_node(state: GlobalState) -> Dict:
    # 1. Discover Schema
    schema = search_schema_index.invoke(state["original_query"])
    department_id = state.get("department_id")
    
    # 2. Build SQL
    settings = get_settings()
    sql_llm = get_llm(settings.aphrodite.sql_coder.model, settings.aphrodite.sql_coder.temperature)
    sql_prompt = f"Schema:\n{schema}\nWrite an Oracle SQL query for: {state['original_query']}. Output ONLY valid SQL. SECURITY REQUIREMENT: You MUST include 'WHERE dept_id = {department_id}' or join on a table with 'dept_id = {department_id}' to ensure data isolation."
    
    try:
        sql_res = sql_llm.invoke([SystemMessage(content=sql_prompt)])
        sql = sql_res.content.replace("```sql", "").replace("```", "").strip()
    except Exception as e:
        error_msg = f"Error communicating with SQL AI coder: {str(e)}"
        return {"schema_context": schema, "sql_query": "N/A", "sql_results": error_msg, "error_logs": [error_msg], "messages": [SystemMessage(content=error_msg)]}
    
    # 3. RBAC Validation Guardrail
    if f"dept_id = {department_id}" not in sql and f"dept_id={department_id}" not in sql and f"dept_id = '{department_id}'" not in sql:
        error_msg = "Access Denied: You do not have permissions to access data outside your department. Query rejected by security policy."
        return {"schema_context": schema, "sql_query": sql, "sql_results": error_msg, "error_logs": [error_msg], "messages": [SystemMessage(content=error_msg)]}
        
    # 4. Execute
    results = execute_oracle_sql.invoke(sql)
    
    errors = [results] if "Error" in results or "denied" in results else []
    return {"schema_context": schema, "sql_query": sql, "sql_results": results, "error_logs": errors}

def unstructured_node(state: GlobalState) -> Dict:
    results = search_regulatory_vectors.invoke({
        "query": state["original_query"], 
        "department_id": state.get("department_id")
    })
    return {"vector_findings": results}

def analyst_node(state: GlobalState) -> Dict:
    settings = get_settings()
    llm = get_llm(settings.aphrodite.reasoning.model, settings.aphrodite.reasoning.temperature).bind_tools([python_data_tool])
    prompt = f"Analyze this data:\n{state.get('sql_results', '')}\nQuery: {state['original_query']}\nUse python_data_tool if needed."
    
    try:
        res = llm.invoke([SystemMessage(content=prompt)])
        analytical_insights = res.content
    except Exception as e:
        analytical_insights = f"Analysis error: {str(e)}"
    
    # Check if we need to ask the user for viz preferences
    plan = state.get("execution_plan", [])
    clarify_viz = False
    question = ""
    if "viz" in plan and "bar" not in state['original_query'].lower() and "line" not in state['original_query'].lower() and "pie" not in state['original_query'].lower():
        clarify_viz = True
        question = "How would you like this data visualized? (Options: Bar Chart, Line Chart, Pie Chart)"
        
    return {
        "analytical_insights": analytical_insights,
        "requires_clarification": clarify_viz,
        "clarification_question": question,
        "clarifier_return_node": "viz"
    }

def viz_node(state: GlobalState) -> Dict:
    settings = get_settings()
    llm = get_llm(settings.aphrodite.reasoning.model, settings.aphrodite.reasoning.temperature).bind_tools([chart_config_tool])
    prompt = f"Based on this data:\n{state.get('sql_results', '')}\nGenerate a chart config using chart_config_tool."
    
    try:
        res = llm.invoke([SystemMessage(content=prompt)])
        chart_json = {}
        if hasattr(res, "tool_calls") and res.tool_calls:
            args = res.tool_calls[0]["args"]
            chart_json = {
                "action": "RENDER_CHART",
                "chart_type": args.get("chart_type", "bar"),
                "x_axis": args.get("x_axis", ""),
                "y_axis": args.get("y_axis", ""),
                "title": args.get("title", "")
            }
        else:
            chart_json = {"status": "failed_to_generate", "raw_output": getattr(res, "content", "N/A")}
    except Exception as e:
        chart_json = {"status": "error", "error": str(e)}
        
    return {"chart_json": chart_json}

def synthesizer_node(state: GlobalState) -> Dict:
    settings = get_settings()
    llm = get_llm(settings.aphrodite.reasoning.model, settings.aphrodite.reasoning.temperature)
    prompt = f"""Synthesize a final markdown answer for: "{state['original_query']}"
SQL Data: {state.get('sql_results', 'N/A')}
Vector Data: {state.get('vector_findings', 'N/A')}
Analysis: {state.get('analytical_insights', 'N/A')}"""
    
    try:
        res = llm.invoke([SystemMessage(content=prompt)])
        content = res.content
        
        # Strip reasoning tags before sending to the frontend
        if "</think>" in content:
            content = content.split("</think>")[-1].strip()
            
        # Strip markdown formatting blocks if the LLM wrapped its answer
        content = content.replace("```markdown", "").replace("```", "").strip()
            
    except Exception as e:
        content = f"Sorry, I encountered an internal error while synthesizing the response: {str(e)}"
        
    return {"messages": [SystemMessage(content=content)]}

# --- Routing Logic ---
def route_from_orchestrator(state: GlobalState):
    if state.get("requires_clarification"):
        return "clarifier"
    plan = state.get("execution_plan", [])
    if "structured" in plan:
        return "structured"
    if "vector" in plan:
        return "unstructured"
    return "synthesizer"

def route_from_clarifier(state: GlobalState):
    # After human provides input, resume at the node that requested clarification
    return state.get("clarifier_return_node", "orchestrator")

def route_from_structured(state: GlobalState):
    plan = state.get("execution_plan", [])
    if "analyst" in plan:
        return "analyst"
    if "viz" in plan:
        return "viz"
    if "vector" in plan:
        return "unstructured"
    return "synthesizer"

def route_from_analyst(state: GlobalState):
    if state.get("requires_clarification"):
        return "clarifier"
    plan = state.get("execution_plan", [])
    if "viz" in plan:
        return "viz"
    if "vector" in plan:
        return "unstructured"
    return "synthesizer"

def route_from_viz(state: GlobalState):
    plan = state.get("execution_plan", [])
    if "vector" in plan:
        return "unstructured"
    return "synthesizer"

def route_from_unstructured(state: GlobalState):
    return "synthesizer"

# --- Build Graph ---
def build_graph():
    workflow = StateGraph(GlobalState)
    
    workflow.add_node("orchestrator", orchestrator_node)
    workflow.add_node("clarifier", clarifier_node)
    workflow.add_node("structured", structured_node)
    workflow.add_node("unstructured", unstructured_node)
    workflow.add_node("analyst", analyst_node)
    workflow.add_node("viz", viz_node)
    workflow.add_node("synthesizer", synthesizer_node)
    
    workflow.set_entry_point("orchestrator")
    
    workflow.add_conditional_edges("orchestrator", route_from_orchestrator)
    workflow.add_conditional_edges("clarifier", route_from_clarifier)
    workflow.add_conditional_edges("structured", route_from_structured)
    workflow.add_conditional_edges("analyst", route_from_analyst)
    workflow.add_conditional_edges("viz", route_from_viz)
    workflow.add_conditional_edges("unstructured", route_from_unstructured)
    workflow.add_edge("synthesizer", END)
    
    settings = get_settings()
    
    # Initialize Oracle Persistent Checkpointer
    pool = OracleConnectionPool(settings.app_oracle)
    pool.initialize()
    memory = OracleSaver(pool)
    
    return workflow.compile(checkpointer=memory, interrupt_before=["clarifier"])
