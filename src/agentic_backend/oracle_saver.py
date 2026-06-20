import json
import logging
from typing import Optional, Any, Dict, Iterator, Tuple
from contextlib import contextmanager

from langchain_core.runnables import RunnableConfig
from langgraph.checkpoint.base import (
    BaseCheckpointSaver,
    Checkpoint,
    CheckpointMetadata,
    CheckpointTuple,
)

logger = logging.getLogger(__name__)

class OracleSaver(BaseCheckpointSaver):
    """
    A custom LangGraph checkpointer that stores graph state in an Oracle database.
    This allows session history and human-in-the-loop pauses to persist across server restarts.
    """

    def __init__(self, pool, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._pool = pool
        # Table creation is now handled manually by the database administrator.

    def get_tuple(self, config: RunnableConfig) -> Optional[CheckpointTuple]:
        thread_id = config["configurable"]["thread_id"]
        checkpoint_id = config["configurable"].get("checkpoint_id")
        
        sql = """
            SELECT checkpoint_id, parent_checkpoint_id, checkpoint_data, metadata_data, type
            FROM agent_checkpoints 
            WHERE thread_id = :thread_id
        """
        params = {"thread_id": thread_id}
        
        if checkpoint_id:
            sql += " AND checkpoint_id = :checkpoint_id"
            params["checkpoint_id"] = checkpoint_id
        else:
            sql += " ORDER BY created_at DESC FETCH FIRST 1 ROWS ONLY"
            
        with self._pool.connection() as conn:
            with conn.cursor() as cur:
                cur.execute(sql, params)
                row = cur.fetchone()
                
        if not row:
            return None
            
        cid, parent_id, cp_data, meta_data, cp_type = row
        
        cp_bytes = cp_data.read() if hasattr(cp_data, 'read') else cp_data
        meta_bytes = meta_data.read() if hasattr(meta_data, 'read') else meta_data
        
        try:
            import pickle
            if cp_type == "pickle":
                checkpoint = pickle.loads(cp_bytes)
                metadata = pickle.loads(meta_bytes)
            elif hasattr(self.serde, 'loads'):
                checkpoint = self.serde.loads(cp_bytes)
                metadata = self.serde.loads(meta_bytes)
            else:
                checkpoint = self.serde.loads_typed((cp_type or "json", cp_bytes))
                metadata = self.serde.loads_typed(("json", meta_bytes))
        except Exception as e:
            logger.error(f"Failed to deserialize checkpoint: {e}")
            return None
                
        return CheckpointTuple(
            config={"configurable": {"thread_id": thread_id, "checkpoint_id": cid}},
            checkpoint=checkpoint,
            metadata=metadata,
            parent_config={"configurable": {"thread_id": thread_id, "checkpoint_id": parent_id}} if parent_id else None
        )

    def put(
        self,
        config: RunnableConfig,
        checkpoint: Checkpoint,
        metadata: CheckpointMetadata,
        new_versions: Any = None,
    ) -> RunnableConfig:
        thread_id = config["configurable"]["thread_id"]
        checkpoint_id = checkpoint["id"]
        
        # In LangGraph, parent_checkpoint_id is stored in config, not checkpoint
        parent_checkpoint_id = config["configurable"].get("checkpoint_id")
        
        import pickle
        type_val = "pickle"
        cp_bytes = pickle.dumps(checkpoint)
        meta_bytes = pickle.dumps(metadata)

        sql = """
            INSERT INTO agent_checkpoints (
                thread_id, checkpoint_id, parent_checkpoint_id, type, checkpoint_data, metadata_data
            ) VALUES (
                :1, :2, :3, :4, :5, :6
            )
        """
        with self._pool.connection() as conn:
            with conn.cursor() as cur:
                # Use insert, if it exists, it fails (which is fine for immutable checkpoints)
                try:
                    cur.execute(sql, (thread_id, checkpoint_id, parent_checkpoint_id, type_val, cp_bytes, meta_bytes))
                    conn.commit()
                except Exception as e:
                    if "ORA-00001" not in str(e): # ignore unique constraint violations
                        logger.error(f"Failed to put checkpoint: {e}")

        return {
            "configurable": {
                "thread_id": thread_id,
                "checkpoint_id": checkpoint_id,
            }
        }

    def list(
        self,
        config: Optional[RunnableConfig],
        *,
        filter: Optional[Dict[str, Any]] = None,
        before: Optional[RunnableConfig] = None,
        limit: Optional[int] = None,
    ) -> Iterator[CheckpointTuple]:
        thread_id = config["configurable"]["thread_id"]
        sql = """
            SELECT checkpoint_id, parent_checkpoint_id, checkpoint_data, metadata_data, type
            FROM agent_checkpoints 
            WHERE thread_id = :thread_id
        """
        params = {"thread_id": thread_id}
        
        if before:
            sql += " AND checkpoint_id < :before_id"
            params["before_id"] = before["configurable"]["checkpoint_id"]
            
        sql += " ORDER BY created_at DESC"
        
        if limit:
            sql += f" FETCH FIRST {limit} ROWS ONLY"

        with self._pool.connection() as conn:
            with conn.cursor() as cur:
                cur.execute(sql, params)
                rows = cur.fetchall()
                
        for row in rows:
            cid, parent_id, cp_data, meta_data, cp_type = row
            cp_bytes = cp_data.read() if hasattr(cp_data, 'read') else cp_data
            meta_bytes = meta_data.read() if hasattr(meta_data, 'read') else meta_data
            
            try:
                import pickle
                if cp_type == "pickle":
                    checkpoint = pickle.loads(cp_bytes)
                    metadata = pickle.loads(meta_bytes)
                elif hasattr(self.serde, 'loads'):
                    checkpoint = self.serde.loads(cp_bytes)
                    metadata = self.serde.loads(meta_bytes)
                else:
                    checkpoint = self.serde.loads_typed((cp_type or "json", cp_bytes))
                    metadata = self.serde.loads_typed(("json", meta_bytes))
            except Exception as e:
                logger.error(f"Failed to deserialize checkpoint in list: {e}")
                continue
            
            yield CheckpointTuple(
                config={"configurable": {"thread_id": thread_id, "checkpoint_id": cid}},
                checkpoint=checkpoint,
                metadata=metadata,
                parent_config={"configurable": {"thread_id": thread_id, "checkpoint_id": parent_id}} if parent_id else None
            )

    def put_writes(self, config: RunnableConfig, writes: Any, task_id: str) -> None:
        """
        Required by newer versions of LangGraph to save intermediate node writes.
        A simple pass is usually sufficient if intermediate resumption is not needed.
        """
        pass
