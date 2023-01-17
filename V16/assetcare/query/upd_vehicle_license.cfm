<cfif len(attributes.trafik_cikis_tarih)><cf_date tarih='attributes.trafik_cikis_tarih'></cfif>
<cfif len(attributes.tescil_tarihi)><cf_date tarih='attributes.tescil_tarihi'></cfif>
<cfif len(attributes.ilk_muayene_tarihi)><cf_date tarih='attributes.ilk_muayene_tarihi'></cfif>
<cfquery name="GET_INFO" datasource="#DSN#">
    SELECT ASSETP_ID FROM ASSET_P_INFO_PLUS WHERE ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#">
</cfquery>
<cfif get_info.recordCount>
    <cfquery name="UPD_INFO" datasource="#DSN#">
        UPDATE 
            ASSET_P_INFO_PLUS 
        SET
            TESCIL_PLAKA_NO = <cfif len(attributes.tescil_plaka_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tescil_plaka_no#"><cfelse>NULL</cfif>,
            TRAFIK_CIKIS_TARIH  = <cfif len(attributes.trafik_cikis_tarih)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.trafik_cikis_tarih#"><cfelse>NULL</cfif>,
            CINS = <cfif len(attributes.cins)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cins#"><cfelse>NULL</cfif>,
            TIP = <cfif len(attributes.tip)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tip#"><cfelse>NULL</cfif>,
            RENK = <cfif len(attributes.renk)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.renk#"><cfelse>NULL</cfif>,
            MOTOR = <cfif len(attributes.motor)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.motor#"><cfelse>NULL</cfif>,
            ISTIHAP_HADDI_KISI = <cfif len(attributes.istihap_haddi_kisi)>#filternum(attributes.istihap_haddi_kisi)#<cfelse>NULL</cfif>,
            ISTIHAP_HADDI_KG = <cfif len(attributes.istihap_haddi_kg)><cfqueryparam cfsqltype="cf_sql_float" value="#filternum(attributes.istihap_haddi_kg)#"><cfelse>NULL</cfif>,
            ILK_MUAYENE_TARIHI = <cfif len(attributes.ilk_muayene_tarihi)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.ilk_muayene_tarihi#"><cfelse>NULL</cfif>,
            TESCIL_SIRA_NO = <cfif len(attributes.tescil_sira_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tescil_sira_no#"><cfelse>NULL</cfif>,
            TESCIL_TARIHI = <cfif len(attributes.tescil_tarihi)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.tescil_tarihi#"><cfelse>NULL</cfif>,
            MOTOR_GUCU = <cfif len(attributes.motor_gucu)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.motor_gucu#"><cfelse>NULL</cfif>,
            TRANSPORT_TYPE = <cfif len(attributes.transport_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.transport_type#"><cfelse>NULL</cfif>,
            ARAC_SAHIBI = <cfif len(attributes.arac_sahibi)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.arac_sahibi#"><cfelse>NULL</cfif>,
            IKAMETGAH_ADRES = <cfif len(attributes.ikametgah_adres)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ikametgah_adres#"><cfelse>NULL</cfif>,
            IL = <cfif len(attributes.il)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.il#"><cfelse>NULL</cfif>,
            ILCE = <cfif len(attributes.ilce)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ilce#"><cfelse>NULL</cfif>,
            NET_AGIRLIK = <cfif len(attributes.net_agirlik)><cfqueryparam cfsqltype="cf_sql_float" value="#filternum(attributes.net_agirlik)#"><cfelse>NULL</cfif>,
            USAGE_TYPE = <cfif len(attributes.usage_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.usage_type#"><cfelse>NULL</cfif>,
            ENGINE_NUMBER = <cfif len(attributes.engine_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.engine_number#"><cfelse>NULL</cfif>,
            IDENTIFICATION_NUMBER = <cfif len(attributes.identification_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.identification_number#"><cfelse>NULL</cfif>,
            
            TRANSPORT_CAPACITY = <cfif len(attributes.transport_capacity)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.transport_capacity#"><cfelse>NULL</cfif>,
            UNIT_ID = <cfif len(attributes.unit_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.unit_id#"><cfelse>NULL</cfif>,
            EN = <cfif len(attributes.en)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.en#"><cfelse>NULL</cfif>,
            BOY = <cfif len(attributes.boy)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.boy#"><cfelse>NULL</cfif>,
            YUKSEKLIK = <cfif len(attributes.yukseklik)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.yukseklik#"><cfelse>NULL</cfif>,
            BASLANGIC_KM = <cfif len(attributes.baslangic_km)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.baslangic_km#"><cfelse>NULL</cfif>,
            KM_YAKIT_GIDERI = <cfif len(attributes.km_yakit_gideri)><cfqueryparam cfsqltype="cf_sql_float" value="#filternum(attributes.km_yakit_gideri)#"><cfelse>NULL</cfif>,
            PROPERTY1 = <cfif len(attributes.property1)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.property1#"><cfelse>NULL</cfif>,
            PROPERTY2 = <cfif len(attributes.property2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.property2#"><cfelse>NULL</cfif>,
            PROPERTY3 = <cfif len(attributes.property3)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.property3#"><cfelse>NULL</cfif>,
            PROPERTY4 = <cfif len(attributes.property4)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.property4#"><cfelse>NULL</cfif>,
            PROPERTY5 = <cfif len(attributes.property5)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.property5#"><cfelse>NULL</cfif>,
                    
            UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
            UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
            UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">		
        WHERE
            ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#">	
    </cfquery>
<cfelse>
    <cfquery name="ADD_INFO" datasource="#DSN#">
        INSERT INTO
            ASSET_P_INFO_PLUS 
        (
            ASSETP_ID,
            TESCIL_PLAKA_NO ,
            TRAFIK_CIKIS_TARIH,
            CINS,
            TIP,
            RENK,
            MOTOR,
            ISTIHAP_HADDI_KG,
            ISTIHAP_HADDI_KISI,
            ILK_MUAYENE_TARIHI,
            TESCIL_SIRA_NO,
            TESCIL_TARIHI,
            MOTOR_GUCU,
            TRANSPORT_TYPE,
            ARAC_SAHIBI,
            IKAMETGAH_ADRES,
            IL,
            ILCE,
            NET_AGIRLIK,
            USAGE_TYPE,
            ENGINE_NUMBER,
            IDENTIFICATION_NUMBER,
            
            TRANSPORT_CAPACITY,
            UNIT_ID,
            EN,
            BOY, 
            YUKSEKLIK,
            BASLANGIC_KM, 
            KM_YAKIT_GIDERI, 
            PROPERTY1, 
            PROPERTY2, 
            PROPERTY3,
            PROPERTY4, 
            PROPERTY5,             
        
            RECORD_DATE,
            RECORD_EMP,
            RECORD_IP
        ) 
        VALUES 
        (
            #attributes.assetp_id#,
            <cfif len(attributes.tescil_plaka_no)>'#attributes.tescil_plaka_no#'<cfelse>NULL</cfif>,
            <cfif len(attributes.trafik_cikis_tarih)>#attributes.trafik_cikis_tarih#<cfelse>NULL</cfif>,
            <cfif len(attributes.cins)>'#attributes.cins#'<cfelse>NULL</cfif>,
            <cfif len(attributes.tip)>'#attributes.tip#'<cfelse>NULL</cfif>,
            <cfif len(attributes.renk)>'#attributes.renk#'<cfelse>NULL</cfif>,
            <cfif len(attributes.motor)>'#attributes.motor#'<cfelse>NULL</cfif>,
            <cfif len(attributes.istihap_haddi_kg)>#attributes.istihap_haddi_kg#<cfelse>NULL</cfif>,
            <cfif len(attributes.istihap_haddi_kisi)>#attributes.istihap_haddi_kisi#<cfelse>NULL</cfif>,
            <cfif len(attributes.ilk_muayene_tarihi)>#attributes.ilk_muayene_tarihi#<cfelse>NULL</cfif>,
            <cfif len(attributes.tescil_sira_no)>'#attributes.tescil_sira_no#'<cfelse>NULL</cfif>,
            <cfif len(attributes.tescil_tarihi)>#attributes.tescil_tarihi#<cfelse>NULL</cfif>,
            <cfif len(attributes.motor_gucu)>'#attributes.motor_gucu#'<cfelse>NULL</cfif>,
            <cfif len(attributes.transport_type)>#attributes.transport_type#<cfelse>NULL</cfif>,
            <cfif len(attributes.arac_sahibi)>'#attributes.arac_sahibi#'<cfelse>NULL</cfif>,
            <cfif len(attributes.ikametgah_adres)>'#attributes.ikametgah_adres#'<cfelse>NULL</cfif>,
            <cfif len(attributes.il)>'#attributes.il#'<cfelse>NULL</cfif>,
            <cfif len(attributes.ilce)>'#attributes.ilce#'<cfelse>NULL</cfif>,
            <cfif len(attributes.net_agirlik)>#attributes.net_agirlik#<cfelse>NULL</cfif>,
            <cfif len(attributes.usage_type)>'#attributes.usage_type#'<cfelse>NULL</cfif>,
            <cfif len(attributes.engine_number)>'#attributes.engine_number#'<cfelse>NULL</cfif>,
            <cfif len(attributes.identification_number)>'#attributes.identification_number#'<cfelse>NULL</cfif>,
            
            <cfif len(attributes.transport_capacity)>#attributes.transport_capacity#<cfelse>NULL</cfif>,
            <cfif len(attributes.unit_id)>#attributes.unit_id#<cfelse>NULL</cfif>,
            <cfif len(attributes.en)>#attributes.en#<cfelse>NULL</cfif>,   
            <cfif len(attributes.boy)>#attributes.boy#<cfelse>NULL</cfif>,
            <cfif len(attributes.yukseklik)>#attributes.yukseklik#<cfelse>NULL</cfif>,
            <cfif len(attributes.baslangic_km)>#attributes.baslangic_km#<cfelse>NULL</cfif>, 
            <cfif len(attributes.km_yakit_gideri)>#attributes.km_yakit_gideri#<cfelse>NULL</cfif>,
            <cfif len(attributes.property1)>'#attributes.property1#'<cfelse>NULL</cfif>,
            <cfif len(attributes.property2)>'#attributes.property2#'<cfelse>NULL</cfif>,
            <cfif len(attributes.property3)>'#attributes.property3#'<cfelse>NULL</cfif>,
            <cfif len(attributes.property4)>'#attributes.property4#'<cfelse>NULL</cfif>,
            <cfif len(attributes.property5)>'#attributes.property5#'<cfelse>NULL</cfif>,  
        
            #now()#,
            #session.ep.userid#,
            '#cgi.remote_addr#'
        )
    </cfquery>
</cfif>
<script type="text/javascript">
    window.location.href='<cfoutput>#request.self#?fuseaction=assetcare.list_vehicles&event=lic_info&assetp_id=#attributes.assetp_id#</cfoutput>';
</script>
