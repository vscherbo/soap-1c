CREATE OR REPLACE FUNCTION checkinn1(inn character varying)
  RETURNS character varying AS
$BODY$DECLARE
    r RECORD;
    txt varchar;
    loc_RETURNED_SQLSTATE varchar;
    loc_MESSAGE_TEXT varchar;
    loc_PG_EXCEPTION_DETAIL varchar;
    loc_PG_EXCEPTION_HINT varchar;
    loc_PG_EXCEPTION_CONTEXT varchar;
    loc_insert_problem varchar;
BEGIN
  r := get_reqs_by_inn(inn);
  IF r.ret_flg THEN
     RETURN r.ret_txt;
  ELSE BEGIN
     INSERT INTO chk_inn_task(inn) VALUES(inn); 
     exception WHEN OTHERS THEN 
         GET STACKED DIAGNOSTICS 
             loc_RETURNED_SQLSTATE = RETURNED_SQLSTATE,
             loc_MESSAGE_TEXT = MESSAGE_TEXT,
             loc_PG_EXCEPTION_DETAIL = PG_EXCEPTION_DETAIL,
             loc_PG_EXCEPTION_HINT = PG_EXCEPTION_HINT,
             loc_PG_EXCEPTION_CONTEXT = PG_EXCEPTION_CONTEXT ;
             loc_insert_problem = format(
                                         'RETURNED_SQLSTATE=%s, 
                                         MESSAGE_TEXT=%s, 
                                         PG_EXCEPTION_DETAIL=%s, 
                                         PG_EXCEPTION_HINT=%s, 
                                         PG_EXCEPTION_CONTEXT=%s', 
                                         loc_RETURNED_SQLSTATE, 
                                         loc_MESSAGE_TEXT,
                                         loc_PG_EXCEPTION_DETAIL,
                                         loc_PG_EXCEPTION_HINT,
                                         loc_PG_EXCEPTION_CONTEXT );
             RETURN e'Ошибка при создании фоновой задачи:' || loc_insert_problem;
     END;
     RETURN e'Создана фоновая задача';
  END IF;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
