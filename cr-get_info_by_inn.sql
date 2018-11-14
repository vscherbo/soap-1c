CREATE OR REPLACE FUNCTION arc_energo.get_info_by_inn(inn character varying, query_type integer, OUT ret_flg boolean, OUT ret_txt character varying)
 RETURNS record
 LANGUAGE plpython2u
AS $function$
import requests
from datetime import datetime
from os.path import expanduser

if query_type not in (1, 2):
   ret_flg = False
   ret_txt = u"Недопустимый тип запроса query_type={}.".format(query_type)
   return ret_flg, ret_txt

len_inn = len(inn)
if len_inn not in (10, 12):
   ret_flg = False
   ret_txt = u"Недопустимая длина={} ИНН={}. Допустимо 10 или 12 цифр.".format(len_inn, inn)
   return ret_flg, ret_txt


good_status = [ 200, 500 ]

# 1 - реквизиты
q_req = {}
q_req[10] = 'getCorporationRequisitesByINN'
q_req[12] = 'getEntrepreneurRequisitesByINN'

# 2 - филиалы
q_trust = {}
q_trust[10] = 'checkCorporationTrustability'
q_trust[12] = 'checkPersonTrustabilityByInn'

query_namespace = {}
query_namespace[1] = q_req
query_namespace[2] = q_trust

NameSpace = query_namespace[query_type][len_inn]

url_1c_api = u'https://api.orgregister.1c.ru/orgregister/v7?wsdl'
sess = requests.Session()
sess.auth = ('TDEnergoService', 'energ0serv1ce')
sess.headers.update({'SOAPAction': u'""', 'Content-Type': 'text/xml; charset=utf-8', 'Content-type': 'text/xml; charset=utf-8', 'Soapaction': u'""'})

xml_prefix=u'<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:ns0="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="http://ws.orgregister.company1c.com/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"><SOAP-ENV:Header/><ns0:Body><ns1:' + NameSpace + u'><ns1:INN>'
xml_suffix=u'</ns1:INN></ns1:' + NameSpace + u'></ns0:Body></SOAP-ENV:Envelope>'

xml_data = xml_prefix + inn.encode('utf8') +  xml_suffix

req = requests.Request(u'POST', url_1c_api, data=xml_data)
prepped = sess.prepare_request(req)
ret_txt = 'Before send'
try:
    r = sess.send(prepped,timeout=5)
except BaseException as e:
    ret_txt = str(e)
    ret_flg = False
else:
    ret_txt = r.reason if r.text is None else r.text
    ret_flg = True if r.status_code in good_status else False
return ret_flg, ret_txt
$function$
