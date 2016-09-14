#!/usr/bin/env python2.7
# -*- coding: utf-8 -

# import xml.etree.ElementTree as ET

from xml.etree import ElementTree as ET
import codecs

def normalize(name):
    if name[0] == "{":
        uri, tag = name[1:].split("}")
        return uri + tag
    else:
        return name

outf=codecs.open('kpp.txt', 'w', 'utf-8')
tree = ET.parse('./soap.xml')
XSI_TYPE = "{http://www.w3.org/2001/XMLSchema-instance}type"
req_firm = "{http://company1c.com/orgregister/corporation}*"


for elem in tree.iter():
    for el in elem.findall(u'{http://company1c.com/orgregister/corporation}СвУчетНО'):
        outf.write(u"el.TAG=[" + el.tag + u"]\n")
        #if el.text is not None:
        #    outf.write("    el.text:" + el.text + u"\n")
        #for k,v in el.attrib.items():
        #    outf.write("  " + k + u"=" + v + "\n")
        kpp = el.attrib.get(u"КПП")
        if kpp is not None:
            outf.write(u"КПП=" +kpp +u"\n")

 
outf.close()

