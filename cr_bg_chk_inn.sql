-- Function: bg_chk_inn()

-- DROP FUNCTION bg_chk_inn();

CREATE OR REPLACE FUNCTION bg_chk_inn()
  RETURNS void AS
$BODY$
DECLARE
  tsk RECORD;
  res RECORD;
  loc_txt VARCHAR;
BEGIN
  FOR tsk IN SELECT * FROM chk_inn_task WHERE status < 2 AND attempt < 3 LOOP
      res := public.get_reqs_by_inn(tsk.inn);
      tsk.attempt := tsk.attempt + 1; 
      IF res.ret_flg THEN
         tsk.status := 2;
         loc_txt := res.ret_txt;
      ELSE
         tsk.status := 1;
         loc_txt := tsk.chk_result || '/' || res.ret_txt;
      END IF;
      UPDATE chk_inn_task SET 
                            attempt = tsk.attempt,
                            attempt_dt = clock_timestamp(),
                            chk_result = loc_txt,
                            status = tsk.status
            WHERE inn = tsk.inn;
  END LOOP;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION bg_chk_inn()
  OWNER TO arc_energo;
