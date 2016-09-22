-- Function: parse_kpp(character varying)

-- DROP FUNCTION parse_kpp(character varying);

CREATE OR REPLACE FUNCTION parse_kpp(
    IN in_xml character varying,
    OUT ret_kpp_flg boolean,
    OUT ret_kpp character varying)
  RETURNS record AS
$BODY$
from xml.etree import ElementTree as ET

root = ET.fromstring(in_xml)

ret_kpp_flg = False
ret_kpp = 'not found'
# python 2.7 for elem in root.iter():
for elem in root.getiterator(): #python 2.6
    if 'СвУчетНО' in elem.tag.encode('utf-8'):
        for el in elem.findall('.'):
            #for a1 in el.attrib:
            #    plpy.notice(a1.encode('utf-8'));
            kpp = el.attrib.get('КПП'.decode('utf-8'))
            if kpp is not None:
                ret_kpp_flg = True
                ret_kpp = kpp

return ret_kpp_flg, ret_kpp
$BODY$
  LANGUAGE plpython2u VOLATILE
  COST 100;
ALTER FUNCTION parse_kpp(character varying)
  OWNER TO postgres;
