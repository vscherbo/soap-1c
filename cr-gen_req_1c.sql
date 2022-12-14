-- DROP FUNCTION arc_energo.gen_req_1c(character varying);

CREATE OR REPLACE FUNCTION arc_energo.gen_req_1c(
    IN arg_inn character varying,
    OUT ret_flg boolean,
    OUT ret_jsonb jsonb)
  RETURNS record AS
$BODY$
import requests
from plpy import spiexceptions
#import json

ret_flg = False
ret_jsonb = None
SITE = 'https://api.orgregister.1c.ru'
CORP_URL = 'rest/corporation/v1/find-corporation-by-inn'
PERS_URL = 'rest/person/v1/find-person-by-inn'

# good_status = [ 200, 500 ]
good_status = [ 200 ]

len_inn = len(arg_inn)
loc_url = None
if len_inn == 10:
    loc_url = '%s/%s' % (SITE, CORP_URL)
elif len_inn == 12:
    loc_url = '%s/%s' % (SITE, PERS_URL)
else:
    plpy.warning('Invalid length of INN (%s) INN=%s', len_inn, arg_inn)

if loc_url:
    loc_auth = ('TDEnergoService', 'energ0serv1ce')
    loc_payload = {}
    loc_payload["inn"] = arg_inn

    try:
        plpy.log('>>> TRY section')
        res = requests.get(url=loc_url, auth=loc_auth, params=loc_payload)
    except requests.exceptions:
        plpy.error("requests.exceptions")
    except spiexceptions.ExternalRoutineException:  #, e:
        plpy.error("spiexceptions.ExternalRoutineException")
        ret_flg = False
    except spiexceptions:
        plpy.error("spiexceptions")
        ret_flg = False
    except plpy.SPIError, e:
        plpy.error("SPIError")
        #plpy.error("Query 1C error {0}, err={1}".format(loc_url, e.sqlstate))
        ret_flg = False
    else:
        plpy.log('>>> ELSE section')
        #ret_flg = True if res.status_code in good_status else False
        if res.status_code in good_status:
            ret_flg = True
        else:
            ret_flg = False
            plpy.error("Query 1C returns NOT good_status {0}".format(res.status_code))

        ret_jsonb = res.text
else:
   ret_flg = False

return ret_flg, ret_jsonb
$BODY$
  LANGUAGE plpython2u VOLATILE
  COST 100;
