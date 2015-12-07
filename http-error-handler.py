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
except requests.exceptions.ConnectionError as e: #A Connection error occurred.
    print("ConnectionError")
    rc = e.args[0].args[1].errno
except requests.exceptions.HTTPError as e: #An HTTP error occurred.
    print("HTTPError")
    rc = e.args[0].args[1].errno
except requests.exceptions.URLRequired as e: #A valid URL is required to make a request.
    print("URLRequired")
    rc = e.args[0].args[1].errno
except requests.exceptions.TooManyRedirects as e:
    print("TooManyRedirects") 
    rc = e.args[0].args[1].errno
except requests.exceptions.ConnectionError as e:
    rc = e.args[0].args[1].errno
    #rc = 102
    for a in e.args[0].args:
        print("  args[0].arg[i]=", a)
    #    print("  dir arg=",dir(a))
    #    print("  class arg=",a.__class__)
    #print("arg[1].args=",e.args[0].args[1].args)
    #print("arg[1].errno=",e.args[0].args[1].errno)
    #print("arg[1].strerror=",e.args[0].args[1].strerror)
except requests.exceptions.Timeout as e:
    #rc = e.args[0].args[1].errno
    print("e.message=",e.message)
    #print("e.args.__class__=",e.args.__class__)
    #print("dir(e.args)=",dir(e.args))
    rc = 103
except requests.exceptions.RequestException as e: #There was an ambiguous exception that occurred while handling your request.
    print("RequestException")
    rc = e.args[0].args[1].errno
    #rc = 101
except BaseException as e:
    rc = 101
    print("Unexpected error:", sys.exc_info()[0])

if rc > 0:
    print("================")
    print("rc=",rc)
    # ('Connection aborted.', error(111, 'Connection refused'))
    print(dir(e))
    print(e.__class__)
    print("before exit e=",e)
    sys.exit(rc)
else:
    #print(dir(r))
# apparent_encoding', 'close', 'connection', 'content', 'cookies', 'elapsed', 'encoding', 'headers', 'history', 'is_permanent_redirect', 'is_redirect', 'iter_content', 'iter_lines', 'json', 'links', 'ok', 'raise_for_status', 'raw', 'reason', 'request', 'status_code', 'text', 'url'

    print("reason=",r.reason)
    print("text=",r.text)
    print("status_code=",r.status_code)
    print("elapsed=",r.elapsed)

    #status_code = r.status_code
    #headers = r.headers   #['content-type'] ['vary']
    #text = r.text
