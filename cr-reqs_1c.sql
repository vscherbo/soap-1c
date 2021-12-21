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
ret_name = ''
ret_post = ''
ret_emails = ''
ret_phones = ''
ret_area = ''
ret_region = ''
ret_city = ''
ret_settlement = ''
ret_block = ''
ret_flat = ''
res = plpy.execute("select * from gen_req_1c('{0}')".format(arg_inn))
ret_flg = res[0]["ret_flg"]
if ret_flg:
    reqs = json.loads(res[0]["ret_jsonb"])
    if reqs:
        
        ret_short_name = reqs['name']['shortNameFromEgrul']
        ret_full_name = reqs['name']['fullNameFromEgrul']
        #ret_short_name = reqs['name']['shortName']
        #ret_full_name = reqs['name']['fullName']
        ret_kpp = reqs['kpp']['value']
        ret_ogrn = reqs['ogrn']
        mngr = reqs['headPersonInfo']['director']
        if mngr:
                fio = []
                fio.append(mngr.get('lastName').encode('utf-8'))
                fio.append(mngr.get('name').encode('utf-8'))
                fio.append(mngr.get('patronymic').encode('utf-8'))
                ret_name = ' '.join(fio)
                ret_post = mngr.get('position', 'должность не известна').encode('utf-8')
        # addr info
        ret_address = reqs['address'].get('value')
        addr_data = reqs['address']
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
    else:
        ret_flg = False
        
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
