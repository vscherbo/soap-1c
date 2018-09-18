#!/usr/bin/env python2.7
# -*- coding: utf-8 -
from __future__ import print_function

import sys
import requests
import argparse

conf = {}
execfile("./1c-its.conf", conf) # reading username, password

parser = argparse.ArgumentParser(description='Get requisites by INN.')
parser.add_argument('--inn', type=str, default=u'7804431521', help='ИНН')
args = parser.parse_args()

url_1c_api = 'https://api.orgregister.1c.ru/orgregister/v7?wsdl'
sess = requests.Session()
sess.auth = (conf['username'], conf['password'])
# sess.headers.update({'Content-Type': 'application/json'})
sess.headers.update({'SOAPAction': u'""', 'Content-Type': 'text/xml; charset=utf-8', 'Content-type': 'text/xml; charset=utf-8', 'Soapaction': u'""'})
# sess.verify = False

if len(args.inn) == 10: # Corporation
   NameSpace = u"getCorporationRequisitesByINN"
elif len(args.inn) == 12: # Entrepreneur
   NameSpace = u"getEntrepreneurRequisitesByINN"
else:
    print("Допустимая длина ИНН 10 или 12 цифр. Выход.")
    sys.exit(1)

xml=u"""<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:ns0="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="http://ws.orgregister.company1c.com/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
   <SOAP-ENV:Header/>
   <ns0:Body>
      <ns1:""" + NameSpace + u""">
         <ns1:INN>7804431521</ns1:INN>
      </ns1:getCorporationRequisitesByINN>
   </ns0:Body>
</SOAP-ENV:Envelope>"""

xml_pre=u"""<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:ns0="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="http://ws.orgregister.company1c.com/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
   <SOAP-ENV:Header/>
   <ns0:Body>
      <ns1:""" + NameSpace + u""">
         <ns1:INN>"""

xml_post=u"""</ns1:INN>
      </ns1:""" + NameSpace + u""">
   </ns0:Body>
</SOAP-ENV:Envelope>"""

xml=xml_pre + args.inn + xml_post

req = requests.Request('POST', url_1c_api, data=xml)
prepped = sess.prepare_request(req)
try:
    r = sess.send(prepped,timeout=5)
except BaseException as e:
    #print("Unexpected error:", sys.exc_info()[0])
    err_msg = str(e)
    print(err_msg)
else:
    #print("reason=",r.reason)
    # print("text=",r.text.encode('utf8'))
    print(r.text.encode('utf8'))
    #print("status_code=",r.status_code)
    #print("elapsed=",r.elapsed)


