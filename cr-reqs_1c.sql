-- DROP FUNCTION arc_energo.reqs_1c(varchar);

CREATE OR REPLACE FUNCTION arc_energo.reqs_1c(
    IN arg_inn varchar,
    OUT ret_flg boolean,
    OUT ret_short_name varchar,
    OUT ret_full_name varchar,
    OUT ret_kpp varchar,
    OUT ret_ogrn varchar,
    OUT ret_emails varchar, 
    OUT ret_phones varchar,
    OUT ret_postal_code varchar,
    OUT ret_address varchar,
    OUT ret_country varchar,
    OUT ret_area varchar,
    OUT ret_region varchar,
    OUT ret_city varchar,
    OUT ret_settlement varchar,
    OUT ret_street varchar,
    OUT ret_house varchar,
    OUT ret_block varchar,
    OUT ret_flat varchar,
    OUT ret_name varchar,
    OUT ret_post varchar
)
  RETURNS record AS
$BODY$
# -*- coding: utf-8 -*-
import json

ret_short_name = ''
ret_full_name = ''
ret_kpp = ''
ret_ogrn = ''
ret_emails = ''
ret_phones = ''
ret_postal_code = ''
ret_address = ''
ret_country = ''
ret_area = ''
ret_region = ''
ret_city = ''
ret_settlement = ''
ret_street = ''
ret_house = ''
ret_block = ''
ret_flat = ''
ret_name = ''
ret_post = ''

res = plpy.execute("select * from gen_req_1c('{0}')".format(arg_inn))
ret_flg = res[0]["ret_flg"]

#inn_in_answ = res[0].get("inn")
#if inn_in_answ is None:
#    ret_flg = False 

if ret_flg:
    reqs = json.loads(res[0].get("ret_jsonb"))
    if reqs is not None:
        if len(arg_inn) == 10:
            reqs_name = reqs.get('name')
            if reqs_name is not None:
                ret_short_name = reqs_name.get('shortNameFromEgrul', "no shortNameFromEgrul")
                ret_full_name = reqs_name.get('fullNameFromEgrul', "no fullNameFromEgrul")
            else:
                ret_short_name = "no NameFromEgrul"
                ret_full_name = "no NameFromEgrul"

            #ret_kpp = reqs['kpp']['value']
            #ret_ogrn = reqs['ogrn']
            ret_kpp = reqs.get('kpp')
            if ret_kpp is not None:
                ret_kpp = ret_kpp.get('value')
            ret_ogrn = reqs.get('ogrn')
            mngr_info = reqs.get('headPersonInfo')
            if mngr_info:
                mngr = mngr_info.get('director')
            else:
                mngr = None
            if mngr:
                fio = []
                fio.append(mngr.get('lastName').encode('utf-8'))
                fio.append(mngr.get('name').encode('utf-8'))
                fio.append(mngr.get('patronymic').encode('utf-8'))
                ret_name = ' '.join(fio)
                ret_post = mngr.get('position', 'должность не известна').encode('utf-8')
            # addr info
            #ret_address = reqs['address'].get('value')
            ret_address = reqs.get('address')
            if ret_address is not None:
                ret_address = ret_address.get('value')
                addr_data = reqs['address']
            else:
                addr_data = None
            if addr_data:
                #ret_address = addr_data.get('source', 'address unknown')
                ret_country = addr_data.get('country', 'country unknown')

                area_list = []
                area_list.append(addr_data.get('areaType'))
                area_list.append(addr_data.get('area'))
                ret_region = ' '.join(filter(None, area_list))  # like dadata

                city_list = []
                city_name = addr_data.get('city')
                if city_name:
                    city_list.append(addr_data.get('cityType'))
                    city_list.append(city_name)
                    ret_city = ' '.join(filter(None, city_list))

                distr_list = []
                distr_name = addr_data.get('district')
                if distr_name:
                    distr_list.append(addr_data.get('districtType'))
                    distr_list.append(distr_name)
                    ret_area = ' '.join(filter(None, distr_list))

                settl_list = []
                settl_name = addr_data.get('locality')
                if settl_name:
                    settl_list.append(addr_data.get('localityType'))
                    settl_list.append(settl_name)
                    ret_settlement = ' '.join(filter(None, settl_list))

                street_list = []
                street_list.append(addr_data.get('streetType'))
                street_list.append(addr_data.get('street'))
                ret_street = ' '.join(filter(None, street_list))

                ret_postal_code = addr_data.get('postalCode', 'postalCode unknown')

                house = []
                house.append(addr_data.get('houseType'))
                house.append(addr_data.get('house'))
                ret_house = ' '.join(filter(None, house))

                buildings = []
                bld = addr_data.get('buildings')
                if bld:
                    buildings.append(bld[0].get('type'))
                    buildings.append(bld[0].get('number'))
                    ret_block = ' '.join(filter(None, buildings))
                

                apartments = []
                apt = addr_data.get('apartments')
                if apt:
                    apartments.append(apt[0].get('type'))
                    apartments.append(apt[0].get('number'))
                    #plpy.info('appartments=%s' % apartments)
                    #plpy.info('appartments[0].enc=%s' % apartments[0].encode('utf-8'))
                    apartments = filter(lambda it: it.encode('utf-8') != 'другое', apartments)
                    #plpy.info('filtered appartments=%s' % apartments)
                    ret_flat = ' '.join(filter(None, apartments))
        elif len(arg_inn) == 12:
            ret_flg = False
            person = reqs.get('person')
            if person is not None:
                ret_short_name = reqs['person'].get('fio', "no fio from EGRIP")
                ret_full_name = reqs['person'].get('fio', "no fio from EGRIP")
            registrationInfo = reqs.get('registrationInfo')
            if registrationInfo is not None:
                ret_ogrn = reqs['registrationInfo'].get('ogrn', "no OGRN from EGRIP")
                ret_flg = True
        else:
            plpy.log('Wrong length (%s)of arg_inn=%s', len(arg_inn), arg_inn)
            ret_flg = False
    else:
        ret_flg = False
else:
    #reqs = json.loads(res[0].get("ret_jsonb").encode('utf-8'))
    reqs = json.loads(res[0].get("ret_jsonb"))
    if reqs is not None:
        plpy.warning('gen_req_1c returns={%s} arg_inn=%s', reqs, arg_inn)


return ret_flg, ret_short_name, ret_full_name, ret_kpp, ret_ogrn,\
ret_emails ,\
        ret_phones ,\
        ret_postal_code ,\
        ret_address ,\
        ret_country ,\
        ret_area ,\
        ret_region ,\
        ret_city ,\
        ret_settlement ,\
        ret_street ,\
        ret_house ,\
        ret_block ,\
        ret_flat ,\
ret_name, ret_post
        
$BODY$
  LANGUAGE plpython2u VOLATILE
  COST 100;
