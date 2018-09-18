-- Function: checkinn(character varying)

-- DROP FUNCTION checkinn(character varying);

CREATE OR REPLACE FUNCTION checkinn(inn character varying)
  RETURNS character varying AS
$BODY$import requests
from datetime import datetime
#import codecs
#flog=codecs.open('/tmp/checkinn.log', 'a', 'utf-8')
#flog.write("Start at " + str(datetime.now()) +'\n')
good_status = [ 200, 500 ]

url_1c_api = u'https://api.orgregister.1c.ru/orgregister/v7?wsdl'
sess = requests.Session()
sess.auth = ('TDEnergoService', 'energ0serv1ce')
sess.headers.update({'SOAPAction': u'""', 'Content-Type': 'text/xml; charset=utf-8', 'Content-type': 'text/xml; charset=utf-8', 'Soapaction': u'""'})

xml_prefix=u'<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:ns0="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="http://ws.orgregister.company1c.com/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"><SOAP-ENV:Header/><ns0:Body><ns1:getCorporationRequisitesByINN><ns1:INN>'
xml_suffix=u'</ns1:INN></ns1:getCorporationRequisitesByINN></ns0:Body></SOAP-ENV:Envelope>'

xml_data = xml_prefix + inn.encode('utf8') +  xml_suffix
#flog.write("xml_data=" + xml_data +'\n')

req = requests.Request(u'POST', url_1c_api, data=xml_data)
prepped = sess.prepare_request(req)
ret_txt = 'Before send'
try:
    r = sess.send(prepped,timeout=5)
except BaseException as e:
    ret_txt = str(e)
else:
    if r.status_code in good_status:
        ret_txt = r.reason if r.text is None else r.text
    else
        
    #flog.write("r.text=" + r.text +'\n')
    #r.elapsed
return ret_txt
$BODY$
  LANGUAGE plpython2u VOLATILE
  COST 100;
ALTER FUNCTION checkinn(character varying)
  OWNER TO postgres;
