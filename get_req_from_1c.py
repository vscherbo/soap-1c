#!/usr/bin/env python3
"""
Сервис 1С:Контрагент
Вызов методов API:
Реквизиты юр. лиц по ИНН:
    https://api.orgregister.1c.ru/rest/corporation/v1/find-corporation-by-inn?inn=
Реквизиты ИП по ИНН:
    https://api.orgregister.1c.ru/rest/person/v1/find-person-by-inn?inn=
"""

import os
#import json
import requests
from requests.auth import HTTPBasicAuth
from log_app import LogApp
from log_app import logging
from log_app import PARSER

SITE = 'https://api.orgregister.1c.ru'
CORP_URL = 'rest/corporation/v1/find-corporation-by-inn'
PERS_URL = 'rest/person/v1/find-person-by-inn'

class Req1C(LogApp):
    """ Class for requests to site 1C """

    def __init__(self, args, description):
        super(Req1C, self).__init__(args, description)
        script_name = os.path.splitext(os.path.basename(__file__))[0]
        self.get_config('{}.conf'.format(script_name))
        self.login = self.config['auth']['login']
        self.password = self.config['auth']['password']

    def get_requisites(self, inn):
        """ Do request """
        len_inn = len(inn)
        if len_inn == 10:
            loc_url = '{}/{}'.format(SITE, CORP_URL)
        elif len_inn == 12:
            loc_url = '{}/{}'.format(SITE, CORP_URL)
        else:
            logging.error('Недопустимая длина (%s) ИНН=%s', len_inn, inn)

        loc_auth = HTTPBasicAuth(self.login, self.password)
        loc_payload = {}
        loc_payload["inn"] = inn

        res = requests.get(url=loc_url, auth=loc_auth, params=loc_payload)
        logging.info('res.url=%s', res.url)
        logging.info('res.text=%s', res.text)

if __name__ == '__main__':
    PARSER.add_argument('--inn', type=str, help='ИНН: 10 или 12 цифр')
    ARGS = PARSER.parse_args()
    REQ = Req1C(args=ARGS, description='запрос реквизитов по ИНН')
    REQ.get_requisites(ARGS.inn)
