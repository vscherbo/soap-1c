-- drop  FUNCTION arc_energo.branch_info(xml);
CREATE OR REPLACE FUNCTION arc_energo.branch_info(chk_result xml)
 RETURNS setof record
 LANGUAGE sql
AS $function$
select
unnest(xpath('//*[local-name()=''СвПодразд'']/@НаимПолн', chk_result))::text -- as "НаимПолн"
,unnest(xpath('//*[local-name()=''СвПодразд'']/*[local-name()=''АдрМНРФ'']/@*', chk_result))::text -- as "Страна"
, unnest(xpath('//*[@ТипАдрЭл="10100000"]/@Значение' , unnest(xpath('//*[local-name()=''СвПодразд'']/*/*[local-name()=''Состав'']', chk_result))))::text -- as "Индекс"
, trim(
regexp_replace(
regexp_replace(
replace(
array_to_string(xpath('descendant::*/text()' , unnest(xpath('//*[local-name()=''СвПодразд'']/*/*[local-name()=''Состав'']', chk_result))), ',')
, ',', ', ')
, ',[ ]+,', ', ', 'g')
, '[ ]{2,}', ' ', 'g')
, ' ,')
-- as "Адрес"
,unnest(xpath('//*[@Тип="1010"]/@Значение' , unnest(xpath('//*[local-name()=''СвПодразд'']/*/*[local-name()=''Состав'']', chk_result))))::text -- as "Дом"
-- ,unnest(xpath('//*[local-name()=''СвПодразд'']/*/*[local-name()=''Состав'']', chk_result)) as "Состав"
-- , xpath('descendant::*/text()' , unnest(xpath('//*[local-name()=''СвПодразд'']/*/*[local-name()=''Состав'']', chk_result))) "Addr"
--, xpath('descendant::*/node()/@*' , unnest(xpath('//*[local-name()=''СвПодразд'']/*/*[local-name()=''Состав'']', chk_result))) "Addr2"
,unnest(xpath('//*[local-name()=''СвПодразд'']/@ГРН', chk_result))::text -- as "ГРН"
,unnest(xpath('//*[local-name()=''СвПодразд'']/@ДатаНачДейств', chk_result))::text; -- as "ДатаНачДейств";
$function$
