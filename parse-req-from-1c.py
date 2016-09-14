#!/usr/bin/env python2.7
# -*- coding: utf-8 -

# import xml.etree.ElementTree as ET

from xml.etree import ElementTree as ET
import codecs

def elem2str(aLabel, aTag, aText):
    if None != aText and u'\n' != aText:
       rstr = aLabel + aTag + u'=' + aText +u'\n'
    else:
       rstr = u'None or CR\n'
    return rstr

def parse_map(file):

    events = "start", "start-ns", "end-ns"

    root = None
    ns_map = []

    for event, elem in ET.iterparse(file, events):
        if event == "start-ns":
            ns_map.append(elem)
        elif event == "end-ns":
            ns_map.pop()
        elif event == "start":
            if root is None:
                root = elem
            elem.ns_map = dict(ns_map)

    return ET.ElementTree(root)

NS_MAP = "xmlns:xsi"
XSI_TYPE = "{http://www.w3.org/2001/XMLSchema-instance}type"
outf=codecs.open('soap.tmp', 'w', 'utf-8')
tree = ET.parse('./soap.xml')

tree1 = parse_map('./soap.xml')
for elem in tree1.getiterator():
    value = elem.get(XSI_TYPE)
    if value:
        #outf.write("value=" + value.encode('UTF-8') + "\n")
        #prefix, tag = value.split(":")
        #nsmap = elem.get(NS_MAP)
        nsmap = elem.findall('*')
        for i in nsmap:
           if i.text is not None:
               print str(i.text.encode('utf8'))
        #print "%s has type {%s}%s" % (
        #    elem.tag, nsmap[prefix], tag
        #)

ns = {"company": "http://ws.orgregister.company1c.com/",
      "envelope": "http://schemas.xmlsoap.org/soap/envelope/",
      "corp": "http://company1c.com/orgregister/corporation",
      "enterp": "http://company1c.com/orgregister/entrepreneur",
      "xsi": "http://www.w3.org/2001/XMLSchema-instance"
      }

root = tree.getroot()
#root = ET.fromstring(xml_test)
#print "fromstring\n"


#print u"root TAG=" + root.tag
#for k,v in root.items():
#    print k + u"=" + v #+ u"\n"

#for el in root:
for el in tree.getiterator():
    outf.write(el.tag + u"/" + str(el.attrib) + u"\n")
    outf.write(el.tag + u"\n")
    outf.write(u"el.TAG=" + el.tag + u"\n")
    for k,v in el.attrib.items():
        outf.write("el:" + k + u"=" + v + "\n")

    """
    result = el.find(u'*', ns)
    print "=== result\n"
    #print result
    for props in el.findall(u'*', ns):
        outf.write("len(props)=" + str(len(props)) + "\n")
        for item in props.findall(u'*', ns):
            outf.write("len(item)=" + str(len(item)) + "\n")
            for elm in item.iter():
                outf.write("len(elm)=" + str(len(elm)) + "\n")
                #print u"elm TAG=" + elm.tag
                for k,v in elm.attrib.items():
                    outf.write("   elm:" + k + u"=" + v + "\n")
    """

 
outf.close()

