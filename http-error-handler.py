#!/usr/bin/env python2.7
# -*- coding: utf-8 -
from __future__ import print_function

import sys
import requests
import argparse

parser = argparse.ArgumentParser(description='HTTPE error handler.')
parser.add_argument('--url', type=str, default='http://httpbin.org/', help='url')
args = parser.parse_args()

test_url = args.url
sess = requests.Session()
# 1c_url sess.headers.update({'SOAPAction': u'""', 'Content-Type': 'text/xml; charset=utf-8', 'Content-type': 'text/xml; charset=utf-8', 'Soapaction': u'""'})

req = requests.Request('GET', test_url)
prepped = sess.prepare_request(req)
rc = 0
try:
    r = sess.send(prepped,timeout=2)
except BaseException as e:
    #print("Unexpected error:", sys.exc_info()[0])
    err_msg = str(e)
else:
    #print(dir(r))
# apparent_encoding', 'close', 'connection', 'content', 'cookies', 'elapsed', 'encoding', 'headers', 'history', 'is_permanent_redirect', 'is_redirect', 'iter_content', 'iter_lines', 'json', 'links', 'ok', 'raise_for_status', 'raw', 'reason', 'request', 'status_code', 'text', 'url'

    print("reason=",r.reason)
    print("text=",r.text)
    print("status_code=",r.status_code)
    print("elapsed=",r.elapsed)
