<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn1 = '#dsn#_product'>
    <cfset dsn2 = '#dsn#_#session.ep.period_year#_#session.ep.company_id#'>
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'>

    <cffunction name="GetAuthorizationVars" access="public" hint="İrsaliye entegrasyon doğrulama bilgileri">
        <cfquery name="get_authorizaton" datasource="#dsn2#">
            SELECT ESHIPMENT_COMPANY_CODE, ESHIPMENT_USER_NAME, ESHIPMENT_PASSWORD, OC.TAX_NO 
            FROM #dsn#.ESHIPMENT_INTEGRATION_INFO 
            JOIN #dsn#.OUR_COMPANY AS OC ON OC.COMP_ID = ESHIPMENT_INTEGRATION_INFO.COMP_ID
            WHERE ESHIPMENT_INTEGRATION_INFO.COMP_ID = #session.ep.company_id#
        </cfquery>
        <cfset authvars = structNew()>
        <cfset authvars.corporateCode = "#get_authorizaton.ESHIPMENT_COMPANY_CODE#">
        <cfset authvars.loginName = "#get_authorizaton.ESHIPMENT_USER_NAME#">
        <cfset authvars.password = "#get_authorizaton.ESHIPMENT_PASSWORD#">
        <cfset authvars.tax_no = get_authorizaton.TAX_NO>

        <cfreturn authvars>
    </cffunction>

    <cffunction name="GetEShipmentIntegrationInfo" access="public" hint="İrsaliye entegrasyon bilgileri">
        <cfquery name="query_integrationinfo" datasource="#dsn2#">
            SELECT 
                ESHIPMENT_TEST_SYSTEM, 
                'https://authsoapapitest.superentegrator.com/' AS ESHIPMENT_TEST_URL,
                'https://authsoapapi.superentegrator.com/' AS ESHIPMENT_TEST_URL
            FROM 
                #dsn#.ESHIPMENT_INTEGRATION_INFO 
            WHERE COMP_ID = #session.ep.company_id#
        </cfquery>
        
        <cfreturn query_integrationinfo>
    </cffunction>

    <cffunction name="GetShipNumber" access="public" hint="e-İrsaliye Numara">
        <cfquery name="GET_SHIPMENT_NUM" datasource="#DSN2#">
            SELECT
                ESHIPMENT_PREFIX,
                ESHIPMENT_NUMBER
            FROM
                ESHIPMENT_NUMBER
        </cfquery>
        <cfreturn GET_SHIPMENT_NUM>
    </cffunction>

    <cffunction name="get_our_company_fnc" access="public" returntype="query" hint="Comp ID' ye göre Tanım bilgileri">
    	<cfargument type="string" name="company_id" default="">
    	<cfquery name="GET_OUR_COMPANY" datasource="#dsn#">
            SELECT
                EII.*,
                C.TAX_NO,
                C.COMPANY_NAME,
                OCI.ESHIPMENT_DATE,
                OCI.IS_ESHIPMENT,
                EII.ESHIPMENT_TYPE_ALIAS
            FROM
                ESHIPMENT_INTEGRATION_INFO AS EII
            LEFT JOIN OUR_COMPANY AS C ON EII.COMP_ID = C.COMP_ID
            JOIN OUR_COMPANY_INFO AS OCI ON C.COMP_ID = OCI.COMP_ID
            WHERE
                IS_ESHIPMENT = 1 
                <cfif len(arguments.company_id)>
                    AND C.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
                </cfif>
        </cfquery>
        <cfreturn get_our_company>
    </cffunction>

    <cffunction name="getCompanyAdrress" access="public" returntype="query" hint="İrsaliye Adres Bilgileri">
        <cfargument type="numeric" name="company_id" required="yes">
        <cfquery name="getCompanyAdrress" datasource="#dsn#">
            SELECT
                SCI.CITY_NAME,
                SCO.COUNTRY_NAME,
                OC.CITY_SUBDIVISION_NAME,
                OC.POSTAL_CODE,
                OC.TAX_OFFICE,
                OC.TEL_CODE,
                OC.TEL,
                OC.FAX,
                OC.EMAIL,
                OC.TAX_NO,
                OC.COMP_ID,
                OC.BUILDING_NUMBER,
                OC.STREET_NAME,
                OC.DISTRICT_NAME,
                OC.COMPANY_NAME,
                OC.WEB,
                OC.T_NO,
                OC.MERSIS_NO,
                OC.ADDRESS,
                OCI.EINVOICE_SENDER_ALIAS,
                SC.COUNTY_NAME
            FROM 
                OUR_COMPANY OC,
                OUR_COMPANY_INFO OCI, 
                SETUP_CITY SCI,
                SETUP_COUNTRY SCO,
                SETUP_COUNTY SC
            WHERE 
                OCI.COMP_ID = OC.COMP_ID AND
                OC.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"> AND
                SCI.CITY_ID = OC.CITY_ID AND
                SCO.COUNTRY_ID = OC.COUNTRY_ID AND 
                SC.COUNTY_ID = OC.COUNTY_ID
        </cfquery>
        <cfreturn getCompanyAdrress>
    </cffunction>

    <cffunction name="ShipmentCancelControl" access="public" hint="İrsaliye İptal Bilgisi">
        <cfargument type="numeric" name="action_id"  required="yes">
        <cfquery name="ShipmentCancelControl" datasource="#dsn2#">
            SELECT IS_SHIP_IPTAL, COMPANY_ID, CONSUMER_ID FROM SHIP WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> 
        </cfquery>
        <cfreturn ShipmentCancelControl>
    </cffunction>

    <cffunction name="ShipmentMoneyControl" access="public" hint="İrsaliye Döviz Bilgisi">
        <cfargument type="numeric" name="action_id"  required="yes">
        <cfquery name="ShipmentMoneyControl" datasource="#DSN2#">
            SELECT 
                S.OTHER_MONEY
            FROM 
                SHIP S 
                LEFT JOIN SHIP_ROW SR ON S.SHIP_ID = SR.SHIP_ID
            WHERE 
                S.OTHER_MONEY <> SR.OTHER_MONEY AND
                S.SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">     
        </cfquery>
        <cfreturn ShipmentMoneyControl>
    </cffunction>

    <cffunction name="getShipResult" access="public" hint="irsaliye nakliye bilgisi">
        <cfargument type="numeric" name="ship_id" required="yes">

        <cfquery name="query_shipresult" datasource="#dsn2#">
            SELECT sr.SHIP_RESULT_ID
                ,SERVICE_COMPANY_ID
                ,SERVICE_MEMBER_ID
                ,sr.ASSETP_ID
                ,sr.SENDING_ADDRESS
                ,sr.SENDING_POSTCODE
                ,DELIVER_EMP
                ,DELIVER_EMP_NAME
                ,sr.DELIVER_EMP_TC
                ,PLATE
                ,PLATE2
                ,co.FULLNAME CARRIER_NAME
                ,co.TAXNO CARIER_TAXNO
                ,co.COMPANY_POSTCODE CARIER_POSTCODE
                ,co.COMPANY_ADDRESS CARIER_ADDRESS
                ,CONS.CONSUMER_NAME + ' ' + CONS.CONSUMER_SURNAME AS CONS_NAME
                ,CONS.TC_IDENTY_NO AS CONS_TC
                ,CONS.TAX_NO AS CONS_TAX
                ,scu.COUNTY_NAME CARIER_COUNTY
                ,sct.CITY_NAME CARIER_CITY
                ,scr.COUNTRY_NAME CARIER_COUNTRY
                ,scu2.COUNTY_NAME DELIVERY_COUNTY
                ,sct2.CITY_NAME DELIVERY_CITY
                ,scr2.COUNTRY_NAME DELIVERY_COUNTRY
                ,emp.EMPLOYEE_NAME
                ,emp.EMPLOYEE_SURNAME
                ,ems.POSITION_NAME
                ,emi.TC_IDENTY_NO
                ,asp.ASSETP
                ,cop.TC_IDENTITY TCKN
            FROM SHIP_RESULT sr
            INNER JOIN SHIP_RESULT_ROW srr ON sr.SHIP_RESULT_ID = srr.SHIP_RESULT_ID
            LEFT OUTER JOIN #dsn#.COMPANY co ON sr.SERVICE_COMPANY_ID = co.COMPANY_ID
            LEFT OUTER JOIN #dsn#.CONSUMER CONS ON sr.SERVICE_CONSUMER_ID = CONS.CONSUMER_ID
            LEFT JOIN #dsn#.COMPANY_PARTNER COP on co.COMPANY_ID = COP.COMPANY_ID
            LEFT OUTER JOIN #dsn#.SETUP_COUNTY scu ON ( co.COUNTY = scu.COUNTY_ID or cons.HOME_COUNTY_ID = scu.COUNTY_ID )
            LEFT OUTER JOIN #dsn#.SETUP_COUNTRY scr ON ( co.COUNTRY = scr.COUNTRY_ID or cons.HOME_COUNTRY_ID = scr.COUNTRY_ID )
            LEFT OUTER JOIN #dsn#.SETUP_CITY sct ON ( co.CITY = sct.CITY_ID or cons.HOME_CITY_ID = sct.CITY_ID )
            LEFT OUTER JOIN #dsn#.SETUP_COUNTY scu2 ON sr.SENDING_COUNTY_ID = scu2.COUNTY_ID
            LEFT OUTER JOIN #dsn#.SETUP_COUNTRY scr2 ON sr.SENDING_COUNTRY_ID = scr2.COUNTRY_ID
            LEFT OUTER JOIN #dsn#.SETUP_CITY sct2 ON sr.SENDING_CITY_ID = sct2.CITY_ID
            LEFT OUTER JOIN #dsn#.EMPLOYEES emp ON sr.DELIVER_EMP = emp.EMPLOYEE_ID
            LEFT OUTER JOIN #dsn#.EMPLOYEE_POSITIONS ems ON sr.DELIVER_EMP = ems.EMPLOYEE_ID
            LEFT OUTER JOIN #dsn#.EMPLOYEES_IDENTY emi ON sr.DELIVER_EMP = emi.EMPLOYEE_ID
            LEFT OUTER JOIN #dsn#.ASSET_P asp ON sr.ASSETP_ID = asp.ASSETP_ID
            WHERE srr.SHIP_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.ship_id#'>
        </cfquery>

        <cfreturn query_shipresult>
    </cffunction>

    <cffunction name="getShipment" access="public" hint="İrsaliye Bilgisi">
        <cfargument type="numeric" name="action_id" required="yes">
        <cfargument type="string" name="company_id" default="">
        <cfargument type="string" name="consumer_id" default="">
        <cfargument type="numeric" name="temp_currency_code" required="yes">
        <cfquery name="getShipment" datasource="#dsn2#">
            SELECT 
                S.SHIP_ID,
                S.SHIP_NUMBER,
                S.SHIP_DATE,
                S.DELIVER_DATE,
                S.COMPANY_ID,
                S.CONSUMER_ID,
                S.DUE_DATE,
                '' TOTAL_AMOUNT,
                S.WRK_ID,
                S.SERIAL_NUMBER,
                S.PROCESS_CAT,
                S.DELIVER_STORE_ID,
                S.DEPARTMENT_IN,
                S.SHIP_DETAIL,
                <cfif temp_currency_code>
                    (SELECT ISNULL(SUM(DISCOUNTTOTAL),0) FROM SHIP_ROW WHERE SHIP_ROW.SHIP_ID = S.SHIP_ID) ROW_DISCOUNT,        
                    S.GROSSTOTAL GROSSTOTAL,
                    S.NETTOTAL NETTOTAL,
                    ISNULL(ROUND(S.SA_DISCOUNT,2),0) SA_DISCOUNT,  
                    'TRY' CURRENCY_CODE,
                    'TL' MONEY,
                    1 RATE2, 
                    ROUND(S.TAXTOTAL,2) TAXTOTAL,
                    ISNULL(ROUND(S.OTV_TOTAL,2),0) OTV_TOTAL,
                <cfelse>
                    (SELECT ISNULL((SUM(DISCOUNTTOTAL)/SM.RATE2),0) FROM SHIP_ROW WHERE SHIP_ROW.SHIP_ID = S.SHIP_ID) ROW_DISCOUNT,        
                    (S.GROSSTOTAL/SM.RATE2) GROSSTOTAL,
                    (S.NETTOTAL/SM.RATE2) NETTOTAL,
                    ISNULL(ROUND((S.SA_DISCOUNT/SM.RATE2),2),0) SA_DISCOUNT,      
                    SEM.CURRENCY_CODE,
                    SEM.MONEY,
                    SM.RATE2, 
                    ROUND((S.TAXTOTAL/SM.RATE2),2) TAXTOTAL,
                    ISNULL(ROUND((S.OTV_TOTAL/SM.RATE2),2),0) OTV_TOTAL,
                </cfif>
                <cfif len(arguments.company_id)>
                    S.SHIP_ADDRESS_ID,
                <cfelse>
                    '' SHIP_ADDRESS_ID,
                </cfif>
                <cfif len(arguments.company_id)>
                    CB.COMPBRANCH_CODE,
                    CB.COMPBRANCH_ALIAS,
                    CB.COMPBRANCH__NAME,
                    CASE WHEN ISNULL(S.SHIP_ADDRESS_ID,0) > 0 THEN CB.COMPBRANCH_POSTCODE ELSE COMP.COMPANY_POSTCODE END AS COMPANY_POSTCODE2,
                    CASE WHEN ISNULL(S.SHIP_ADDRESS_ID,0) > 0 THEN CB.COMPBRANCH_ADDRESS ELSE COMP.COMPANY_ADDRESS END AS ADDRESS2,
                    CB.COMPBRANCH_ID CBID,
                    CASE WHEN ISNULL(S.SHIP_ADDRESS_ID,0) > 0 THEN CBC.COUNTY_NAME ELSE SC.COUNTY_NAME END AS COUNTY_NAME2,
                    CASE WHEN ISNULL(S.SHIP_ADDRESS_ID,0) > 0 THEN CBCI.CITY_NAME ELSE SCI.CITY_NAME END AS CITY_NAME2,
                    CASE WHEN ISNULL(S.SHIP_ADDRESS_ID,0) > 0 THEN CBCO.COUNTRY_NAME ELSE SCO.COUNTRY_NAME END AS COUNTRY_NAME2,
                    CASE WHEN ISNULL(S.SHIP_ADDRESS_ID,0) > 0 THEN CB.COMPBRANCH_TELCODE ELSE COMP.COMPANY_TELCODE END AS TEL_CODE_2,
                    CASE WHEN ISNULL(S.SHIP_ADDRESS_ID,0) > 0 THEN CB.COMPBRANCH_TEL1 ELSE COMP.COMPANY_TEL1 END AS TEL_2,
                    CASE WHEN ISNULL(S.SHIP_ADDRESS_ID,0) > 0 THEN CB.COMPBRANCH_EMAIL ELSE COMP.COMPANY_EMAIL END AS EMAIL_2,
                    CASE WHEN ISNULL(S.SHIP_ADDRESS_ID,0) > 0 THEN CB.COMPBRANCH_FAX ELSE COMP.COMPANY_FAX END AS FAX_2,
                    CP.COMPANY_PARTNER_NAME,
                    CP.COMPANY_PARTNER_SURNAME,
                    CP.TC_IDENTITY,
                    COMP.FULLNAME,
                    COMP.COMPANY_EMAIL,
                    COMP.COMPANY_TELCODE,
                    COMP.COMPANY_TEL1 COMPANY_TEL,
                    COMP.COMPANY_FAX,
                    COMP.TAXOFFICE,
                    COMP.TAXNO,
                    COMP.COMPANY_POSTCODE,
                    COMP.OZEL_KOD_2,
                    COMP.COMPANY_ADDRESS ADDRESS,
                    ISNULL(COMP.IS_PERSON,0) AS IS_PERSON,
                <cfelseif len(arguments.consumer_id)>
                    '' COMPBRANCH_CODE,
                    '' COMPBRANCH_ALIAS,
                    '' COMPBRANCH__NAME,
                    '' COMPANY_POSTCODE2,
                    '' ADDRESS2,
                    '' CBID,
                    '' COUNTY_NAME2,
                    '' CITY_NAME2,
                    '' COUNTRY_NAME2,
                    '' TEL_CODE_2,
                    '' TEL_2,
                    '' EMAIL_2,
                    '' FAX_2,
                    CONS.CONSUMER_NAME COMPANY_PARTNER_NAME,
                    CONS.CONSUMER_SURNAME COMPANY_PARTNER_SURNAME,
                    CONS.TC_IDENTY_NO TC_IDENTITY,
                    CONS.CONSUMER_NAME +' ' + CONS.CONSUMER_SURNAME FULLNAME,
                    CONS.CONSUMER_EMAIL COMPANY_EMAIL,
                    CONS.TAX_ADRESS ADDRESS,
                    '' COMPANY_TELCODE,
                    '' COMPANY_TEL,
                    '' COMPANY_FAX,
                    '' TAXOFFICE,
                    '' TAXNO,
                    '' COMPANY_POSTCODE,
                    '' OZEL_KOD_2,
                    1 IS_PERSON,
                </cfif>
                SPC.INVOICE_TYPE_CODE,  
                <cfif len(arguments.company_id) or len(arguments.consumer_id)>
                    SC.COUNTY_NAME,
                    SCI.CITY_NAME,
                    SCO.COUNTRY_NAME,
                </cfif>
                OBR.BRANCH_ADDRESS DEPO_ADRES,
                OBR.BRANCH_POSTCODE DEPO_POSTCODE,
                OBR.BRANCH_COUNTY DEPO_COUNTY,
                OBR.BRANCH_CITY DEPO_CITY,
                OBR.BRANCH_COUNTRY DEPO_COUNTRY,
                OBR.BRANCH_ID DEPO_ID,
                OBR.BRANCH_NAME DEPO_NAME,
                SPC.IS_EXPORT_REGISTERED
                FROM SHIP AS S
                LEFT OUTER JOIN #dsn#.DEPARTMENT ODP ON S.DELIVER_STORE_ID = ODP.DEPARTMENT_ID
                LEFT OUTER JOIN #dsn#.BRANCH OBR ON ODP.BRANCH_ID = OBR.BRANCH_ID
                <cfif len(arguments.company_id)> 
                    INNER JOIN #dsn#.COMPANY AS COMP ON COMP.COMPANY_ID = S.COMPANY_ID
                    LEFT JOIN #dsn#.COMPANY_PARTNER CP ON CP.PARTNER_ID = (CASE WHEN COMP.IS_PERSON = 1 THEN COMP.MANAGER_PARTNER_ID ELSE S.PARTNER_ID END)
                <cfelseif len(arguments.consumer_id)>
                    INNER JOIN #dsn#.CONSUMER AS CONS ON CONS.CONSUMER_ID = S.CONSUMER_ID
                </cfif>
                LEFT JOIN #dsn#.COMPANY_BRANCH AS CB ON CB.COMPBRANCH_ID = S.SHIP_ADDRESS_ID
                <cfif len(arguments.company_id)>LEFT JOIN #dsn#.SETUP_CITY AS SCI ON SCI.CITY_ID = COMP.CITY <cfelseif len(arguments.consumer_id)>LEFT JOIN #dsn#.SETUP_CITY AS SCI ON SCI.CITY_ID = CONS.TAX_CITY_ID </cfif>
                <cfif len(arguments.company_id)>LEFT JOIN #dsn#.SETUP_COUNTRY SCO ON SCO.COUNTRY_ID = COMP.COUNTRY <cfelseif len(arguments.consumer_id)>LEFT JOIN #dsn#.SETUP_COUNTRY SCO ON SCO.COUNTRY_ID = CONS.TAX_COUNTRY_ID </cfif>
                <cfif len(arguments.company_id)>LEFT JOIN #dsn#.SETUP_COUNTY SC ON SC.COUNTY_ID = COMP.COUNTY <cfelseif len(arguments.consumer_id)>LEFT JOIN #dsn#.SETUP_COUNTY SC ON SC.COUNTY_ID = CONS.TAX_COUNTY_ID </cfif>
                <cfif len(arguments.company_id)>LEFT OUTER JOIN #dsn#.SETUP_COUNTY CBC ON CB.COUNTY_ID = CBC.COUNTY_ID</cfif>
                <cfif len(arguments.company_id)>LEFT OUTER JOIN #dsn#.SETUP_CITY CBCI ON CB.CITY_ID = CBCI.CITY_ID</cfif>
                <cfif len(arguments.company_id)>LEFT OUTER JOIN #dsn#.SETUP_COUNTRY CBCO ON CB.COUNTRY_ID = CBCO.COUNTRY_ID</cfif>
                LEFT JOIN SHIP_MONEY SM ON SM.ACTION_ID = S.SHIP_ID AND SM.IS_SELECTED = 1
                LEFT JOIN SETUP_MONEY SEM ON SEM.MONEY = SM.MONEY_TYPE
                JOIN #dsn3#.SETUP_PROCESS_CAT AS SPC ON SPC.PROCESS_CAT_ID = S.PROCESS_CAT
            WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
        </cfquery>
        <cfreturn getShipment>
    </cffunction>

    <cffunction name="getShipmentRow" access="public" hint="İrsaliye Satırları">
        <cfargument type="numeric" name="ship_id" required="yes">
        <cfargument type="numeric" name="temp_currency_code" required="yes">
        <cfquery name="GET_SHIP_ROW" datasource="#DSN2#">
            SELECT
                SR.SHIP_ROW_ID,
                SR.AMOUNT,
                SR.AMOUNT2,
                <cfif arguments.temp_currency_code>
                SR.NETTOTAL,
                SR.DISCOUNTTOTAL,
                SR.TAXTOTAL,
                SR.PRICE,
                <cfelse>
                (SR.NETTOTAL/SM.RATE2) NETTOTAL,
                (SR.DISCOUNTTOTAL/SM.RATE2) DISCOUNTTOTAL,
                (SR.TAXTOTAL/SM.RATE2) TAXTOTAL, 
                SR.PRICE_OTHER PRICE,           
                </cfif>
                SR.TAX,
                SR.NAME_PRODUCT,
                SR.PRODUCT_NAME2,
                ST.TAX_CODE,
                CASE 
                    WHEN (UNIT_CODE IS NOT NULL AND UNIT_CODE <> 'PA') THEN UNIT_CODE
                    WHEN (UNIT_CODE IS NOT NULL AND UNIT_CODE = 'PA') THEN 'BX' 
                END AS UNIT_CODE, 
                S.STOCK_CODE,
                S.BARCOD,
                PR.PRODUCT_CODE,
                PR.PRODUCT_CODE_2,
                SR.DISCOUNT,
                SR.DISCOUNT2,
                SR.DISCOUNT3,
                SR.DISCOUNT4,
                SR.DISCOUNT5,
                SR.REASON_CODE,
                SR.REASON_NAME,
                <cfif isdefined('is_company_stock_code')>(SELECT COMPANY_STOCK_CODE FROM #dsn1#.SETUP_COMPANY_STOCK_CODE WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice.company_id#"> AND STOCK_ID = SR.STOCK_ID) COMPANY_STOCK_CODE,</cfif>
                SR.BSMV_RATE,
                SR.BSMV_AMOUNT,
                SR.BSMV_CURRENCY,
                SR.OIV_RATE,
                SR.OIV_AMOUNT,
                SR.LOT_NO
            FROM
                SHIP
                LEFT JOIN SHIP_ROW SR ON SHIP.SHIP_ID = SR.SHIP_ID
                LEFT JOIN #dsn#.SETUP_UNIT SU ON SR.UNIT = SU.UNIT
                LEFT JOIN #dsn1#.STOCKS S ON S.STOCK_ID = SR.STOCK_ID
                LEFT OUTER JOIN #dsn3#.PRODUCT_PERIOD PP ON SR.PRODUCT_ID = PP.PRODUCT_ID AND PP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
                LEFT JOIN #dsn3#.PRODUCT PR ON PR.PRODUCT_ID = SR.PRODUCT_ID
                LEFT JOIN SHIP_MONEY SM ON SM.ACTION_ID = SR.SHIP_ID AND SM.MONEY_TYPE = SR.OTHER_MONEY
                LEFT JOIN SETUP_TAX ST ON ST.TAX = SR.TAX
            WHERE
                SR.SHIP_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ship_id#"> AND
                PP.TAX_CODE IS NULL<!--- icerisinde vergi kodu seçilmemis ürünler geliyor --->
            ORDER BY
			    SR.SHIP_ROW_ID
        </cfquery>
        <cfreturn GET_SHIP_ROW>
    </cffunction>

    <cffunction name="getBranch" access="public" hint="Depoların bağlı olduğu şubeler">
        <cfargument name="department_id" required="yes">
        <cfquery name="getBranch" datasource="#dsn#">
            SELECT 
                B.* 
                FROM DEPARTMENT D
                JOIN BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
            WHERE
                DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#">
        </cfquery>
        <cfreturn getBranch>
    </cffunction>

    <cffunction name="getRelatedOrder" access="public" returntype="query" hint="İlişkili Sipariş">
        <cfargument type="numeric" name="ship_id" required="yes">
        <cfquery name="GET_RELATED_ORDER" datasource="#DSN2#">
            SELECT DISTINCT
                O.ORDER_NUMBER,
                O.ORDER_DATE,
                O.ORDER_ID,
                O.REF_NO
            FROM
                #dsn3#.ORDERS O,
                #dsn3#.ORDERS_SHIP OS
            WHERE
                O.ORDER_ID = OS.ORDER_ID AND 
                OS.SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ship_id#"> AND 
                OS.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
            ORDER BY
                ORDER_DATE
        </cfquery>
        <cfreturn GET_RELATED_ORDER>
    </cffunction>

    <cffunction name="eShipmentSendingDetail" access="public" hint="e-İrsaliye Gönderim Detayları">
    	<cfargument type="string" name="service_result" required="no">
        <cfargument type="string" name="uuid" required="no">
        <cfargument type="string" name="eshipment_id" required="no">
        <cfargument type="string" name="status_description" required="no">
        <cfargument type="string" name="service_result_description" required="no">
        <cfargument type="string" name="status_code" required="no">
        <cfargument type="string" name="error_code" required="no">
        <cfargument type="numeric" name="action_id" required="no">
        <cfargument type="string" name="action_type" required="no">
        <cfargument type="string" name="belgeOid" required="no">
        <cfargument type="string" name="shipment_type_code" required="no">
        
    	<cfquery name="ADD_SENDING_DETAIL" datasource="#dsn2#">
            INSERT INTO
                ESHIPMENT_SENDING_DETAIL
            (
                SERVICE_RESULT,
                <cfif isdefined("arguments.uuid")>UUID,</cfif>
                ESHIPMENT_ID,
                STATUS_DESCRIPTION,
                <cfif isdefined("arguments.service_result_description") and len(arguments.service_result_description)>SERVICE_RESULT_DESCRIPTION,</cfif>
                <cfif isdefined("arguments.status_code") and len(arguments.status_code)>STATUS_CODE,</cfif>
                <cfif isdefined("arguments.error_code") and len(arguments.error_code)>ERROR_CODE,</cfif>
                ACTION_ID,
                ACTION_TYPE,
                RECORD_DATE,
                RECORD_EMP,
                RECORD_IP,
                BELGE_OID
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.service_result#">,
                <cfif isdefined("arguments.uuid")><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.uuid#">,</cfif>
                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.eshipment_id#">,
                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.status_description#">,
                <cfif isdefined("arguments.service_result_description") and len(arguments.service_result_description)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#left(arguments.service_result_description,250)#">,</cfif>
                <cfif isdefined("arguments.status_code") and len(arguments.status_code)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.status_code#">,</cfif>
                <cfif isdefined("arguments.error_code") and len(arguments.error_code)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.error_code#">,</cfif>
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">,
                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.action_type#">,
                #NOW()#,
                #session.ep.userid#,
                '#cgi.REMOTE_ADDR#',
                <cfif structKeyExists(arguments,"belgeOid") and  len(arguments.belgeOid)>'#arguments.belgeOid#'<cfelse>NULL</cfif>
            )
    	</cfquery> 
    </cffunction>

    <cffunction name="eShipmentRelation" access="public" hint="e-İrsaliye İlişkileri Kayıt">
        <cfargument type="string" name="uuid" required="no">
        <cfargument type="string" name="integration_id" required="no">
        <cfargument type="string" name="envuuid" required="no">
        <cfargument type="string" name="eshipment_id" required="no">
        <cfargument type="numeric" name="action_id" required="no">
        <cfargument type="string" name="action_type" required="no">
        <cfargument type="string" name="profile_id" required="no">
        <cfargument type="string" name="path" required="no">
        <cfargument type="string" name="sender_type" required="no" default="">
        <cfquery name="ADD_SHIPMENT_RELATION" datasource="#DSN2#">
            INSERT INTO
                ESHIPMENT_RELATION
            (
                UUID,
                ENVUUID,
                INTEGRATION_ID,
                ESHIPMENT_ID,
                PROFILE_ID,
                ACTION_ID,
                ACTION_TYPE,
                PATH,
                SENDER_TYPE,
                RECORD_DATE,
                RECORD_EMP,
                RECORD_IP
            )
            VALUES
            (
                '#arguments.uuid#',
                <cfif structKeyExists(arguments,"envuuid") and  len(arguments.envuuid)>'#arguments.envuuid#'<cfelse>NULL</cfif>,               
                '#arguments.integration_id#',
                '#arguments.eshipment_id#',
                '#arguments.profile_id#',
                #arguments.action_id#,
                '#arguments.action_type#',
                '#arguments.path#',
                <cfif len(arguments.sender_type)>#arguments.sender_type#<cfelse>NULL</cfif>,
                #NOW()#,
                #session.ep.userid#,
                '#cgi.REMOTE_ADDR#'
            )
        </cfquery>
    </cffunction>

    <cffunction name="getShipmentRelation" access="public" returntype="query" hint="e-İrsaliye İlişki Detay">
    	<cfargument name="action_id" type="numeric" required="true" />
    	<cfargument name="action_type" type="string" required="true" />
        <cfquery name="get_relation" datasource="#DSN2#">
            SELECT
                ER.*,
                ESD.STATUS_CODE
            FROM
                ESHIPMENT_RELATION AS ER 
                INNER JOIN ESHIPMENT_SENDING_DETAIL AS ESD ON ER.ACTION_ID = ESD.ACTION_ID AND ER.ACTION_TYPE = ESD.ACTION_TYPE
            WHERE
                ER.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> AND
                ER.ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.action_type#">
            ORDER BY
                ER.RECORD_DATE DESC
		</cfquery>
      <cfreturn get_relation />
    </cffunction>

    <cffunction name="updShipmentRelation" returntype="any" access="public" hint="e-İrsaliye İlişkileri Güncelleme">
    	<cfargument type="string" name="uuid" required="yes">     
        <cfargument name="StatusCode" type="numeric" required="yes">
        <cfargument type="string" name="CheckInvoiceStateResult" required="yes">
        <cfquery name="UPD_ESHIPMENT_RELATION" datasource="#dsn2#">
            UPDATE
                ESHIPMENT_RELATION
            SET
                STATUS_CODE = #arguments.StatusCode#,
                STATUS_DESCRIPTION = '#left(arguments.CheckInvoiceStateResult,250)#',
                STATUS_DATE = #now()#                            
            WHERE
                UUID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.uuid#">
        </cfquery>
      <cfreturn>
    </cffunction>

    <cffunction name="updShipmentRelationReceipment" returntype="any" access="public" hint="e-İrsaliye İlişkileri Yanıt Güncelleme">
    	<cfargument type="string" name="receipment_uuid" required="yes">     
        <cfargument type="string" name="receipment_id" required="yes">
        <cfargument type="string" name="uuid" required="yes">
        <cfquery name="UPD_ESHIPMENT_RELATION" datasource="#dsn2#">
            UPDATE
                ESHIPMENT_RELATION
            SET
                RECEIPMENT_UUID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.receipment_uuid#">,
                RECEIPMENT_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.receipment_id#">                           
            WHERE
                UUID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.uuid#">
        </cfquery>
      <cfreturn>
    </cffunction>

    <cffunction name="eShipmentDetail" access="public" hint="e-İrsaliye Detay">
        <cfargument name="action_id" type="numeric" required="no">
        <cfargument name="action_type" type="string" required="no">
        <cfquery name="GET_ESHIPMENT_DETAIL" datasource="#dsn2#">
            SELECT 
                ER.STATUS,
                ER.PROFILE_ID,
                ER.INTEGRATION_ID,
                ER.PATH,
                ESD.ESHIPMENT_ID,
                ESD.STATUS_DESCRIPTION,
                ESD.SERVICE_RESULT,
                ESD.SERVICE_RESULT_DESCRIPTION,
                ESD.RECORD_DATE,
                ESD.UUID,
                ESD.SHIPMENT_TYPE_CODE,
                E.EMPLOYEE_NAME +' ' +E.EMPLOYEE_SURNAME NAME
            FROM 
                ESHIPMENT_SENDING_DETAIL ESD
                    LEFT JOIN ESHIPMENT_RELATION ER ON ER.ACTION_ID = ESD.ACTION_ID AND ER.ACTION_TYPE = ESD.ACTION_TYPE,
                #dsn#.EMPLOYEES E
            WHERE
                ESD.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> AND
                ESD.ACTION_TYPE =  <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.action_type#"> AND
                E.EMPLOYEE_ID = ESD.RECORD_EMP
            ORDER BY
                SENDING_DETAIL_ID DESC        
        </cfquery>
        <cfreturn GET_ESHIPMENT_DETAIL>
    </cffunction>

    <cffunction name="updPaperNoSendShipment" access="public" hint="e-İrsaliye status 1 dönerse belge no lar güncellenir">
        <cfargument name="action_id" type="numeric" required="yes">
        <cfargument name="ship_number" type="string" required="yes">
        <cfquery name="updShipNumber" datasource="#dsn2#">
            UPDATE SHIP SET SHIP_NUMBER = '#arguments.ship_number#',
                            SERIAL_NUMBER = NULL 
            WHERE SHIP_ID = #arguments.action_id#
        </cfquery>
        <cfquery name="updShipRelationNumber" datasource="#dsn2#">
            UPDATE ESHIPMENT_RELATION SET IS_PAPER_UPDATE = 1 WHERE INTEGRATION_ID = '#arguments.ship_number#'
        </cfquery>
        <cfquery name="get_ship_info" datasource="#dsn2#">
            SELECT
                SHIP_TYPE,
                COMPANY_ID
            FROM
                SHIP
            WHERE 
                SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
        </cfquery>
        <cfquery name="upd_serial_no" datasource="#dsn2#">
            UPDATE #dsn3#.SERVICE_GUARANTY_NEW 
                SET PROCESS_NO = '#arguments.ship_number#' 
            WHERE PROCESS_CAT = #get_ship_info.SHIP_TYPE# 
            <cfif len(get_ship_info.COMPANY_ID)>
              AND SALE_COMPANY_ID = #get_ship_info.COMPANY_ID# 
            </cfif>
              AND PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
        </cfquery>
    </cffunction>

    <cffunction name="addIntegrationDefinitions" access="public" returntype="any">
        <cfargument type="numeric" name="eshipment_test_system" default="">
        <cfargument type="string" name="eshipment_type_alias" default="">
        <cfargument type="string"  name="eshipment_company_code" default="">
        <cfargument type="string"  name="eshipment_username" default="">
        <cfargument type="string"  name="eshipment_password" default="">
        <cfargument type="string"  name="eshipment_prefix" default="">
        <cfargument type="string"  name="eshipment_template" default="">
        <cfargument type="string"  name="eshipment_live_url" default="">
        <cfargument type="string"  name="eshipment_test_url" default="">
        <cfargument type="boolean" name="multiple_prefix" required="false" default="false">
        <!--- özel şablon dosya kontrolü --->
        <cfif isdefined("arguments.del_template") and len(arguments.del_template)>
            <cfif fileExists('#arguments.save_folder#\eshipment_template_#session.ep.company_id#.xslt') and fileExists('#arguments.save_folder#\eshipment_template_base64_#session.ep.company_id#.xslt')>
                <cffile action="delete" file="#arguments.save_folder#\eshipment_template_#session.ep.company_id#.xslt">
                <cffile action="delete" file="#arguments.save_folder#\eshipment_template_base64_#session.ep.company_id#.xslt">
            </cfif>
          <cfquery name="DEL_TEMPLATE_FILENAME" datasource="#dsn#">
              UPDATE ESHIPMENT_INTEGRATION_INFO 
              SET TEMPLATE_FILENAME = NULL,
                  TEMPLATE_FILENAME_BASE64 = NULL
              WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> 
          </cfquery>
        <cfelseif isdefined("arguments.eshipment_template") and len(arguments.eshipment_template)>
          <cftry>            
              <cfif not DirectoryExists(arguments.save_folder)>
                  <cfdirectory action = "create" directory="#arguments.save_folder#"/>
              </cfif>
              <cffile action="read" file="#arguments.eshipment_template#" variable="xslt_output" charset="utf-8">
              <cffile action="write" file="#arguments.save_folder#\eshipment_template_#session.ep.company_id#.xslt" output="#trim(xslt_output)#" charset="utf-8">
              <cfset xslt64_output = ToBase64(xslt_output)>
              <cffile action="write" file="#arguments.save_folder#\eshipment_template_base64_#session.ep.company_id#.xslt" output="#trim(xslt64_output)#" charset="utf-8">
              <cfcatch type="Any">
              <cfset error=1>
              <script>
                  alert("Dosya Upload Edilemedi!");
                  history.back();
              </script>
              </cfcatch>
          </cftry>
        </cfif>
        <!--- tablo kayıtları --->
        <cftransaction>
            <cfif arguments.record eq 0>
                <cfquery name="ADD" datasource="#dsn#">
                INSERT INTO
                    ESHIPMENT_INTEGRATION_INFO
            (
                    COMP_ID,
                    ESHIPMENT_TEST_SYSTEM,
                    ESHIPMENT_SIGNATURE_URL,
                    ESHIPMENT_COMPANY_CODE,
                    ESHIPMENT_USER_NAME,
                    ESHIPMENT_PASSWORD,
                    TEMPLATE_FILENAME,
                    TEMPLATE_FILENAME_BASE64,
                    UBLVERSIONID,
                    CUSTOMIZATIONID,
                    IS_RECEIVING_PROCESS,
                    SPECIAL_PERIOD,
                    IS_MULTIPLE_PREFIX,
                    ESHIPMENT_LIVE_URL,
                    ESHIPMENT_TEST_URL,
                    ESHIPMENT_TYPE_ALIAS
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">,
                    <cfif arguments.eshipment_test_system eq 1>1<cfelse>0</cfif>,
                    <cfif len(arguments.eshipment_signature_url)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.eshipment_signature_url#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.eshipment_company_code#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.eshipment_username#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.eshipment_password#">,
                    <cfif len(arguments.eshipment_template)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="eshipment_template_#session.ep.company_id#.xslt"><cfelse>NULL</cfif>,
                    <cfif len(arguments.eshipment_template)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="eshipment_template_base64_#session.ep.company_id#.xslt"><cfelse>NULL</cfif>,     
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.ubl_version#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.customization_id#">,                  
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_receiving_process#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.special_period#">,
                    <cfif arguments.multiple_prefix><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.multiple_prefix#" /><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype='CF_SQL_nvarchar' value='#arguments.eshipment_live_url#'>,
                    <cfqueryparam cfsqltype='CF_SQL_nvarchar' value='#arguments.eshipment_test_url#'>,
                    <cfqueryparam cfsqltype='cf_sql_nvarchar' value='#arguments.eshipment_type_alias#'>
                )
            </cfquery>
                <cfquery name="add_ship_number" datasource="#dsn#">
                    INSERT INTO #dsn2#.ESHIPMENT_NUMBER (ESHIPMENT_PREFIX,ESHIPMENT_NUMBER) VALUES ('#arguments.eshipment_prefix#','#arguments.eshipment_number#')
                </cfquery>
                <cfquery name="upd_our_comp" datasource="#dsn#">
                    UPDATE OUR_COMPANY_INFO 
                        SET IS_ESHIPMENT = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_active#">,
                            ESHIPMENT_DATE = <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.eshipment_date#">
                        WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                </cfquery>
            <cfelse>
                <cfquery name="upd" datasource="#dsn#">
                    UPDATE 
                        ESHIPMENT_INTEGRATION_INFO
                    SET
                        ESHIPMENT_TEST_SYSTEM = <cfif arguments.eshipment_test_system eq 1>1<cfelse>0</cfif>,
                        ESHIPMENT_SIGNATURE_URL =  <cfif len(arguments.eshipment_signature_url)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.eshipment_signature_url#"><cfelse>NULL</cfif>,
                        ESHIPMENT_COMPANY_CODE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.eshipment_company_code#">,
                        ESHIPMENT_USER_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.eshipment_username#">,
                        ESHIPMENT_PASSWORD = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.eshipment_password#">,
                        TEMPLATE_FILENAME = <cfif len(arguments.eshipment_template)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="eshipment_template_#session.ep.company_id#.xslt"><cfelse>NULL</cfif>,
                        TEMPLATE_FILENAME_BASE64 = <cfif len(arguments.eshipment_template)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="eshipment_template_base64_#session.ep.company_id#.xslt"><cfelse>NULL</cfif>,
                        UBLVERSIONID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.ubl_version#">,
                        CUSTOMIZATIONID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.customization_id#">,  
                        IS_RECEIVING_PROCESS = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_receiving_process#">,
                        SPECIAL_PERIOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.special_period#">,
                        IS_MULTIPLE_PREFIX = <cfif arguments.multiple_prefix><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.multiple_prefix#" /><cfelse>NULL</cfif>,
                        ESHIPMENT_LIVE_URL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.eshipment_live_url#">,
                        ESHIPMENT_TEST_URL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.eshipment_test_url#">,
                        ESHIPMENT_TYPE_ALIAS = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.eshipment_type_alias#">
                    WHERE
                        COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                </cfquery>
                 <cfquery name="upd_our_comp" datasource="#dsn#">
                    UPDATE OUR_COMPANY_INFO 
                        SET IS_ESHIPMENT = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_active#">,
                            ESHIPMENT_DATE = <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.eshipment_date#">
                    WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                </cfquery>
                <cfquery name="upd_ship_number" datasource="#dsn#">
                    IF EXISTS (SELECT 1 FROM #dsn2#.ESHIPMENT_NUMBER)
                        BEGIN
                            UPDATE
                                #dsn2#.ESHIPMENT_NUMBER
                            SET
                                ESHIPMENT_PREFIX = '#arguments.eshipment_prefix#',
                                ESHIPMENT_NUMBER = '#arguments.eshipment_number#'
                        END
                    ELSE
                        INSERT INTO #dsn2#.ESHIPMENT_NUMBER (ESHIPMENT_PREFIX,ESHIPMENT_NUMBER) VALUES ('#arguments.eshipment_prefix#','#arguments.eshipment_number#')
                </cfquery>
            </cfif>
        </cftransaction>
        <cfreturn true />
    </cffunction>

    <cffunction name="addReceivedEshipment" access="public" returntype="any">
        <cfargument name="serviceresult" default="">
        <cfargument name="serviceresultdescription" default="">
        <cfargument name="uuid" default="">
        <cfargument name="despatchid" default="">
        <cfargument name="statuscode" default="">
        <cfargument name="statusdescription" default="">
        <cfargument name="errorcode" default="">
        <cfargument name="despatchadvicetypecode" default="">
        <cfargument name="sendertaxid" default="">
        <cfargument name="receivertaxid" default="">
        <cfargument name="profileid" default="">
        <cfargument name="issuedate" default="">
        <cfargument name="issuetime" default="">
        <cfargument name="partyname" default="">
        <cfargument name="receiverpostboxname" default="">
        <cfargument name="senderpostboxname" default="">
        <cfargument name="totalamount" default="">
        <cfargument name="createdate" default="">
        <cfargument name="direction" default="">

        <cfset helper = new V16.e_government.cfc.helper()>
 
        <cfif len(arguments.issuedate)> 
            <cfset arguments.issuedate = helper.webtime2date(arguments.issuedate)>
        </cfif>
        <cfif len(arguments.issuetime)>
            <cfset arguments.issuetime = helper.webtime2date(arguments.issuetime)>
        </cfif>
        <cfif len(arguments.createdate)>
            <cfset arguments.createdate = helper.webtime2date(arguments.createdate)>
        </cfif>
        
        <cfquery name="query_receivedshipment" datasource="#dsn2#">
            INSERT INTO
                ESHIPMENT_RECEIVING_DETAIL
            (
                SERVICE_RESULT,
                SERVICE_RESULT_DESCRIPTION,
                UUID,
                ESHIPMENT_ID,
                STATUS_DESCRIPTION,
                STATUS_CODE,
                ERROR_CODE,
                DESPATCH_ADVICE_TYPE_CODE,
                SENDER_TAX_ID,
                RECEIVER_TAX_ID,
                PROFILE_ID,
                TOTAL_AMOUNT,
                ISSUE_DATE,
                ISSUE_TIME,
                PARTY_NAME,
                RECEIVER_POSTBOX_NAME,
                SENDER_POSTBOX_NAME,
                DIRECTION,
                CREATE_DATE,
                RECORD_DATE,
                RECORD_EMP,
                RECORD_IP
            )
            VALUES
            (
                <cfif len(arguments.serviceresult)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.serviceresult#"><cfelse>NULL</cfif>,
                <cfif len(arguments.serviceresultdescription)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.serviceresultdescription#"><cfelse>NULL</cfif>,
                <cfif len(arguments.uuid)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.uuid#"><cfelse>NULL</cfif>,
                <cfif len(arguments.despatchid)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.despatchid#"><cfelse>NULL</cfif>,
                <cfif len(arguments.statusdescription)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.statusdescription#"><cfelse>NULL</cfif>,
                <cfif len(arguments.statuscode)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.statuscode#"><cfelse>NULL</cfif>,
                <cfif len(arguments.errorcode)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.errorcode#"><cfelse>NULL</cfif>,
                <cfif len(arguments.despatchadvicetypecode)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.despatchadvicetypecode#"><cfelse>NULL</cfif>,
                <cfif len(arguments.sendertaxid)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.sendertaxid#"><cfelse>NULL</cfif>,
                <cfif len(arguments.receivertaxid)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.receivertaxid#"><cfelse>NULL</cfif>,
                <cfif len(arguments.profileid)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.profileid#"><cfelse>NULL</cfif>,
                <cfif len(arguments.totalamount)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.totalamount#"><cfelse>NULL</cfif>,
                <cfif len(arguments.issuedate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.issuedate#"><cfelse>NULL</cfif>,
                <cfif len(arguments.issuetime)><cfqueryparam cfsqltype="cf_sql_time" value="#arguments.issuetime#"><cfelse>NULL</cfif>,
                <cfif len(arguments.partyname)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.partyname#"><cfelse>NULL</cfif>,
                <cfif len(arguments.receiverpostboxname)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.receiverpostboxname#"><cfelse>NULL</cfif>,
                <cfif len(arguments.senderpostboxname)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.senderpostboxname#"><cfelse>NULL</cfif>,
                <cfif len(arguments.direction)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.direction#"><cfelse>NULL</cfif>,
                <cfif len(arguments.createdate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.createdate#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                <cfif isdefined("session.ep.userid")><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"><cfelse>NULL</cfif>,
                <cfif isdefined("cgi.remote_addr")><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#"><cfelse>NULL</cfif>
            )
        </cfquery>
    </cffunction>

    <cffunction name="updReceivedEshipment" access="public" returntype="any">
        <cfargument name="uuid" default="">
        <cfargument name="path" default="">
        <cfquery name="query_receivedshipment" datasource="#dsn2#">
            UPDATE
                ESHIPMENT_RECEIVING_DETAIL
            SET
                PATH = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.path#">
            WHERE
                UUID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.uuid#">
        </cfquery>
    </cffunction>

    <cffunction name="getReceivedEshipment" access="public" returntype="any">
        <cfargument name="startrow" default="">
        <cfargument name="maxrows" default="">
        <cfargument name="keyword" default="">
        <cfargument name="createdate_start" default="">
        <cfargument name="createdate_finish" default="">
        <cfargument name="issuedate_start" default="">
        <cfargument name="issuedate_finish" default="">
        <cfargument name="company" default="">
        <cfargument name="is_processed" default="">
        <cfargument name="status" default="">

        <cfquery name="getReceivedEshipment" datasource="#dsn2#">
            WITH CTE1 AS (
                SELECT
                    *
                FROM
                    ESHIPMENT_RECEIVING_DETAIL
                WHERE
                    1 = 1
                    AND SERVICE_RESULT <> 'Error'
                    <cfif len(arguments.keyword)>
                    AND (
						ESHIPMENT_ID LIKE <cfqueryparam cfsqltype='cf_sql_varchar' value='%#arguments.keyword#%'> OR
						PARTY_NAME LIKE <cfqueryparam cfsqltype='cf_sql_varchar' value='%#arguments.keyword#%'> OR 
                        SENDER_TAX_ID LIKE <cfqueryparam cfsqltype='cf_sql_varchar' value='%#arguments.keyword#%'>
						)
                    </cfif>
                    <cfif len(arguments.createdate_start)>
                    AND CREATE_DATE >= <cfqueryparam cfsqltype='CF_SQL_DATE' value='#arguments.createdate_start#'>
                    </cfif>
                    <cfif len(arguments.createdate_finish)>
                    AND CREATE_DATE <= <cfqueryparam cfsqltype='CF_SQL_DATE' value='#arguments.createdate_finish#'>
                    </cfif>
                    <cfif len(arguments.issuedate_start)>
                    AND ISSUE_DATE >= <cfqueryparam cfsqltype='CF_SQL_DATE' value='#arguments.issuedate_start#'>
                    </cfif>
                    <cfif len(arguments.issuedate_finish)>
                    AND ISSUE_DATE <= <cfqueryparam cfsqltype='CF_SQL_DATE' value='#arguments.issuedate_finish#'>
                    </cfif>
                    <cfif len(arguments.company)>
                        AND PARTY_NAME LIKE	<cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.company#%">
                    </cfif>
                    <cfif arguments.is_processed eq 1>
                        AND ISSUE_DATE IS NOT NULL
                    <cfelseif arguments.is_processed eq 2>
                        AND ISSUE_DATE IS NULL
                    </cfif>
                    <cfif len(arguments.status)>
                        <cfif arguments.status eq 2>
                            AND STATUS IS NULL                           
                        <cfelse>
                            AND STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.status#">
                        </cfif>
                    </cfif>
                     
            ),
            CTE2 AS (
                SELECT
                    CTE1.*,
                    ROW_NUMBER() OVER ( ORDER BY RECEIVING_DETAIL_ID ) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                FROM
                    CTE1
            )
            SELECT
                CTE2.*
            FROM
                CTE2
            WHERE
                RowNum BETWEEN #arguments.startrow# and #arguments.startrow#+(#arguments.maxrows#-1)
        </cfquery>
        <cfreturn getReceivedEshipment>
    </cffunction>

    <cffunction name="GET_ESHIPMENT_DETAIL" access="public" returntype="any">
        <cfargument name="receiving_detail_id" default="">
        <cfargument name="print_id" default="">
        <cfargument name="uuid" default="">
        <cfquery name="GET_ESHIPMENT_DETAIL" datasource="#DSN2#">
            SELECT
                ERD.RECEIVING_DETAIL_ID,
                ERD.SERVICE_RESULT,
                ERD.SERVICE_RESULT_DESCRIPTION,
                ERD.UUID,
                ERD.ESHIPMENT_ID,
                ERD.STATUS_DESCRIPTION,
                ERD.STATUS_CODE,
                ERD.ERROR_CODE,
                ERD.DESPATCH_ADVICE_TYPE_CODE,
                ERD.SENDER_TAX_ID,
                ERD.RECEIVER_TAX_ID,
                ERD.PROFILE_ID,
                ERD.TOTAL_AMOUNT,
                ERD.ISSUE_DATE,
                ERD.ISSUE_TIME,
                ERD.PARTY_NAME,
                ERD.PATH,
                ERD.STATUS,
                ERD.IS_APPROVE,
                ERD.PRINT_COUNT,
                ERD.RECORD_DATE,
                ERD.RECORD_EMP,
                ERD.UPDATE_DATE,
                ERD.UPDATE_EMP,
                ERD.CREATE_DATE,
                ERD.PROCESS_STAGE,
                ERD.IS_PROCESS,
                ERD.SHIP_ID
            FROM
                ESHIPMENT_RECEIVING_DETAIL ERD
            WHERE
                1 = 1
                <cfif len(arguments.receiving_detail_id)>
                    AND ERD.RECEIVING_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.receiving_detail_id#">
                <cfelseif len(arguments.print_id)>
                    AND ERD.RECEIVING_DETAIL_ID IN (#arguments.print_id#)
                </cfif>
                <cfif len(arguments.uuid)>
                    AND ERD.UUID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.uuid#">
                </cfif>
        </cfquery>
        <cfreturn GET_ESHIPMENT_DETAIL>
    </cffunction>

    <cffunction name="CONTROL_MEMBER" access="public" returntype="any">
        <cfargument name="temp_VKN" default="">
        <cfquery name="CONTROL_MEMBER" datasource="#DSN#">
            SELECT 
                1 AS TYPE,
                C.COMPANY_ID AS MEMBER_ID,
				CP.PARTNER_ID PARTNER_ID,
                CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME PARTNER_NAME
            FROM 
                COMPANY C,
                COMPANY_PARTNER CP, 
                COMPANY_CAT CC, 
                COMPANY_CAT_OUR_COMPANY CCO 
            WHERE                                                               
                (C.TAXNO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.temp_VKN#"> OR 
                CP.TC_IDENTITY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.temp_VKN#">) AND
                CCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                C.COMPANY_ID = CP.COMPANY_ID AND
                C.MANAGER_PARTNER_ID = CP.PARTNER_ID AND
                C.COMPANYCAT_ID = CC.COMPANYCAT_ID AND
                CC.COMPANYCAT_ID = CCO.COMPANYCAT_ID
            UNION ALL
            SELECT 
                2 AS TYPE,
                C.CONSUMER_ID AS MEMBER_ID,
				'' AS PARTNER_ID,
                '' AS PARTNER_NAME
            FROM 
                CONSUMER C, 
                CONSUMER_CAT CC, 
                CONSUMER_CAT_OUR_COMPANY CCO 
            WHERE                                                               
                C.TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.temp_VKN#"> AND
                CCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                C.CONSUMER_CAT_ID = CC.CONSCAT_ID AND
                CC.CONSCAT_ID = CCO.CONSCAT_ID
        </cfquery>
        <cfreturn CONTROL_MEMBER>
    </cffunction>

    <cffunction name="truncate_eshipment_alias" access="public">
        <cfquery name="query_eshipment_truncate" datasource="#dsn#">
            TRUNCATE TABLE ESHIPMENT_ALIAS
        </cfquery>
    </cffunction>

    <cffunction name="add_eshipment_alias" access="public">
        <cfargument name="vkntckn">
        <cfargument name="alias">
        <cfargument name="name">
        <cfargument name="type" default="">
        <cfargument name="registertime" default="">
        <cfargument name="firstcreationtime" default="">
        <cfargument name="aliascreationtime" default="">

        <cfquery name="query_eshipment_add" datasource="#dsn#">
            INSERT INTO ESHIPMENT_ALIAS
           (VKNTCKN
           ,ALIAS
           ,NAME
           ,TYPE
           ,REGISTERTIME
           ,FIRSTCREATIONTIME
           ,ALIASCREATIONTIME)
            VALUES
           (<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.vkntckn#'>
           ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.alias#'>
           ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.name#'>
           ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.type#' null="#len(arguments.type)?'no':'yes'#">
           ,<cfqueryparam cfsqltype='CF_SQL_TIMESTAMP' value='#arguments.registertime#' null="#len(arguments.registertime)?'no':'yes'#">
           ,<cfqueryparam cfsqltype='CF_SQL_TIMESTAMP' value='#arguments.firstcreationtime#' null="#len(arguments.firstcreationtime)?'no':'yes'#">
           ,<cfqueryparam cfsqltype='CF_SQL_TIMESTAMP' value='#arguments.aliascreationtime#' null="#len(arguments.aliascreationtime)?'no':'yes'#">)
        </cfquery>
    </cffunction>

    <cffunction name="fill_eshipment_to_company" access="public">

        <cfquery name="query_fill_eshipment_to_company" datasource="#dsn#">
            UPDATE CMP
            SET CMP.USE_ESHIPMENT = 1, CMP.ESHIPMENT_ALIAS = ESA.ALIAS
            FROM 
            COMPANY CMP
            INNER JOIN ESHIPMENT_ALIAS ESA ON CMP.TAXNO = ESA.VKNTCKN
        </cfquery>
        <cfquery name="query_fill_eshipment_to_company" datasource="#dsn#">
            UPDATE CMP
            SET CMP.USE_ESHIPMENT = 1, CMP.ESHIPMENT_ALIAS = ESA.ALIAS
            FROM 
            CONSUMER CMP
            INNER JOIN ESHIPMENT_ALIAS ESA ON CMP.TAX_NO = ESA.VKNTCKN OR CMP.TC_IDENTY_NO = ESA.VKNTCKN
        </cfquery>

    </cffunction>

    <cffunction name="UPD_ESHIPMENT_STATUS" access="public">
        <cfargument name="receiving_detail_id" default="">
        <cfargument name="status" default="">
        <cfargument name="ship_id" default="">
        <cfquery name="UPD_ESHIPMENT_STATUS" datasource="#DSN2#">
            UPDATE 
                ESHIPMENT_RECEIVING_DETAIL
            SET
                IS_PROCESS = 1,
                STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.status#">,
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">
                <cfif len(arguments.ship_id)>
                    ,SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ship_id#">
                </cfif>
            WHERE
                RECEIVING_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.receiving_detail_id#">
        </cfquery>
    </cffunction>

    <cffunction name="SHIPMENT_CONTROL" access="public">
        <cfquery name="SHIPMENT_CONTROL" datasource="#dsn2#">
            SELECT SHIP_ID, SHIP_NUMBER FROM SHIP WHERE SHIP_NUMBER = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.ship_id#"> AND SHIP_TYPE = 81
        </cfquery>
        <cfreturn SHIPMENT_CONTROL>
    </cffunction>


    
</cfcomponent>