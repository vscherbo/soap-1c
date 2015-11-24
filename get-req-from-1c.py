#!/usr/bin/env python2.7
# -*- coding: utf-8 -
from __future__ import print_function

import sys
import requests

conf = {}
execfile("./1c-its.conf", conf) # reading username, password

url_1c_api = 'https://api.orgregister.1c.ru/orgregister/v2?wsdl'
sess = requests.Session()
sess.auth = (conf['username'], conf['password'])
# sess.headers.update({'Content-Type': 'application/json'})
sess.headers.update({'SOAPAction': u'""', 'Content-Type': 'text/xml; charset=utf-8', 'Content-type': 'text/xml; charset=utf-8', 'Soapaction': u'""'})
# sess.verify = False

xml="""<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:ns0="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="http://ws.orgregister.company1c.com/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
   <SOAP-ENV:Header/>
   <ns0:Body>
      <ns1:getCorporationRequisitesByINN>
         <ns1:INN>7804431521</ns1:INN>
      </ns1:getCorporationRequisitesByINN>
   </ns0:Body>
</SOAP-ENV:Envelope>"""

req = requests.Request('POST', url_1c_api, data=xml)
prepped = sess.prepare_request(req)
r = sess.send(prepped,timeout=5)
print(r.text)

#status_code = r.status_code
#headers = r.headers   #['content-type'] ['vary']
#text = r.text

