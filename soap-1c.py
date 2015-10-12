# -*- coding: utf-8 -

from suds.client import Client
from suds.transport.https import HttpAuthenticated
from suds.plugin import *
import logging
from pprint import pprint

class utf_doc_plugin(DocumentPlugin):
    def loaded(self, context):
        context.url = context.url.decode('utf8')
        context.document = context.document.decode('utf8')

class UTFPlugin(MessagePlugin):
    def received(self, context):
        print '####### last_sent ###############'
        print client.last_sent()
        print '####### last_received ###############'
        print client.last_received().decode('utf8')
        context.reply = context.reply.decode('UTF-8', errors='ignore')
        context.reply = context.reply.decode('utf8')
#        context.reply = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><ns1:getCorporationRequisitesByINNResponse xmlns:ns1="http://ws.orgregister.company1c.com/"><Rekvizity xmlns="http://company1c.com/orgregister/corporation" xmlns:ns2="http://company1c.com/orgregister/entrepreneur" ОГРН="1107847032028" ИНН="7804431521" КПП="780401001"></Rekvizity></ns1:getCorporationRequisitesByINNResponse></soap:Body></soap:Envelope>'

logging.basicConfig(level=logging.INFO)

wsdl_url='https://api.orgregister.1c.ru/orgregister/v2?wsdl'

conf = {}
execfile("./soap-1c.conf", conf) # reading username, password

transport = HttpAuthenticated(username=conf['username'],
                              password=conf['password'])
headers = {'Content-Type': 'text/xml; charset=utf-8'}
#client = Client(url=wsdl_url, transport=transport, headers=headers, plugins=[utf_doc_plugin(), UTFPlugin()])
client = Client(url=wsdl_url, transport=transport, headers=headers, plugins=[UTFPlugin()])

# It works!
print '----- client -----'
cli_str=client.__str__()
print cli_str.encode('utf8')
print '----- End of client -----'

# Service ( RequisitesWebServiceEndpointImpl2Service ) tns="http://ws.orgregister.company1c.com/"
#   Prefixes (3)
#      ns0 = "http://company1c.com/orgregister/corporation"
#      ns2 = "http://company1c.com/orgregister/entrepreneur"
#      ns3 = "http://ws.orgregister.company1c.com/"
#   Ports (1):
#      (RequisitesWebServiceEndpointImpl2Port)
#         Methods (3):
#            getCorporationRequisitesByINN(xs:string INN, xs:string configurationName, )
#            getCorporationRequisitesByNameAndAddress(xs:string name, xs:string regionCode, xs:string address, xs:string configurationName, )
#            getEntrepreneurRequisitesByINN(xs:string INN, xs:string configurationName, )
#         Types (30):
#            getCorporationRequisitesByINN
#            getCorporationRequisitesByINNResponse
#            getCorporationRequisitesByNameAndAddress
#            getCorporationRequisitesByNameAndAddressResponse
#            getEntrepreneurRequisitesByINN
#            getEntrepreneurRequisitesByINNResponse
#            ns0:Адрес
#            ns0:АдресРФ
#            ns2:ВидЗапТип
#            ns2:ИННФЛТип
#            ns0:ИННФЛТип
#            ns0:ИННЮЛТип
#            ns0:КППТип
#            ns0:ОГРНИПТип
#            ns2:ОГРНИПТип
#            ns0:ОГРНТип
#            ns2:ОГРНТип
#            ns0:ОКВЭДТип
#            ns2:ОКВЭДТип
#            ns0:ОКСМТип
#            ns2:ОКСМТип
#            ns0:ОПФВыпТип
#            ns0:СОНОТип
#            ns2:СОНОТип
#            ns0:СПДУЛТип
#            ns0:СвРегИнТип
#            ns0:СвРегОргТип
#            ns2:СвРегОргТип
#            ns2:ФИОТип
#            ns0:ФИОТип
# End

#logging.getLogger('suds.client').setLevel(logging.DEBUG)
#logging.getLogger('suds.transport').setLevel(logging.DEBUG)

#confName='Базовая конфигурация'.decode("utf-8")
result = client.service.getCorporationRequisitesByINN('7804431521')
#result = client.service.getCorporationRequisitesByINN('7804431521', 'Базовая конфигурация')
#result = client.service.getCorporationRequisitesByINN(u'7804431521', u'Базовая конфигурация').__str__()
#result = client.service.getCorporationRequisitesByINN(u'7804431521'.encode('utf8'), u'Базовая конфигурация'.encode('utf8'))
#client.service.getCorporationRequisitesByINN(INN, confName)
# result = client.service.getCorporationRequisitesByINN(INN)
print str(result) #.encode('utf8')

