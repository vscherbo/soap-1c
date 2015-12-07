-- Table: chk_inn_task

-- 
DROP TABLE chk_inn_task;

CREATE TABLE chk_inn_task
(
  inn character varying NOT NULL,
  create_dt timestamp without time zone DEFAULT now(),
  attempt integer DEFAULT 0,
  attempt_dt timestamp without time zone,
  status integer DEFAULT 0, -- 0 - задача создана...
  chk_result character varying,
  CONSTRAINT chk_inn_task_pk PRIMARY KEY (inn)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE chk_inn_task
  OWNER TO arc_energo;
COMMENT ON COLUMN chk_inn_task.status IS '0 - задача создана
1 - задача НЕ завершена
2 - задача завершена
8 - задача приостановлена
9 - данные использованы';

