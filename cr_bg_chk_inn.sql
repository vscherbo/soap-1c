CREATE OR REPLACE FUNCTION bg_chk_inn() RETURNS void AS
$BODY$
DECLARE
  tsk RECORD;
  res VARCHAR;
BEGIN
  FOR tsk IN SELECT inn FROM chk_inn_task WHERE status <> 9 LOOP
      res := public.checkinn(tsk.inn);
 
  END LOOP;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
