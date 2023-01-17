<!---
    Author :        İlker Altındal
    Date :          15.02.2021
    Description :   EMustahsil Makbuzu ayar ve genel veriler katmanı  
--->

<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn1 = '#dsn#_product'>
    <cfset dsn2 = '#dsn#_#session.ep.period_year#_#session.ep.company_id#'>
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'>

    <cffunction name="GetAuthorizationVars" access="public" hint="e-Müstahsil makbuzu entegrasyon doğrulama bilgileri">
        <cfquery name="get_authorizaton" datasource="#dsn2#">
            SELECT EPRODUCER_COMPANY_CODE, EPRODUCER_USER_NAME, EPRODUCER_PASSWORD FROM #dsn#.EPRODUCER_RECEIPT_INTEGRATION_INFO WHERE COMP_ID = #session.ep.company_id#
        </cfquery>
        <cfset authvars = structNew()>
        <cfset authvars.corporateCode = "#get_authorizaton.EPRODUCER_COMPANY_CODE#">
        <cfset authvars.loginName = "#get_authorizaton.EPRODUCER_USER_NAME#">
        <cfset authvars.password = "#get_authorizaton.EPRODUCER_PASSWORD#">

        <cfreturn authvars>
    </cffunction>

    <cffunction name="get_our_company_fnc" access="public" returntype="query" hint="Comp ID' ye göre Tanım bilgileri">
    	<cfargument type="string" name="company_id" default="">
    	<cfquery name="GET_OUR_COMPANY" datasource="#dsn#">
            SELECT
                ERI.*,
                C.TAX_NO,
                C.COMPANY_NAME,
                C.MERSIS_NO,
                C.T_NO,
                OCI.EPRODUCER_RECEIPT_DATE,
                OCI.IS_EPRODUCER_RECEIPT
            FROM
                EPRODUCER_RECEIPT_INTEGRATION_INFO AS ERI
                LEFT JOIN OUR_COMPANY AS C ON ERI.COMP_ID = C.COMP_ID
                JOIN OUR_COMPANY_INFO AS OCI ON C.COMP_ID = OCI.COMP_ID
            WHERE
                --IS_EPRODUCER_RECEIPT = 1 
                1=1
                <cfif len(arguments.company_id)>
                    AND C.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
                </cfif>
        </cfquery>
        <cfreturn get_our_company>
    </cffunction>

    <cffunction name="GetEProducerIntegrationInfo" access="public" hint="e-Müstahsil Makbuz entegrasyon bilgileri">
        <cfquery name="query_integrationinfo" datasource="#dsn2#">
            SELECT * FROM #dsn#.EPRODUCER_RECEIPT_INTEGRATION_INFO WHERE COMP_ID = #session.ep.company_id#
        </cfquery>
        
        <cfreturn query_integrationinfo>
    </cffunction>

    <cffunction name="addIntegrationDefinitions" access="public" returntype="any" hint="e-Müstahsil Entegrason bilgileri">
        <cfargument type="numeric" name="eproducer_test_system" default="">
        <cfargument type="string"  name="eproducer_company_code" default="">
        <cfargument type="string"  name="eproducer_username" default="">
        <cfargument type="string"  name="eproducer_password" default="">
        <cfargument type="string"  name="eproducer_template" default="">
        <cfargument type="string"  name="eproducer_live_url" default="">
        <cfargument type="string"  name="eproducer_test_url" default="">
        <!--- özel şablon dosya kontrolü --->
        <cfif isdefined("arguments.del_template") and len(arguments.del_template)>
            <cfif fileExists('#arguments.save_folder#\eproducer_template_#session.ep.company_id#.xslt') and fileExists('#arguments.save_folder#\eproducer_template_base64_#session.ep.company_id#.xslt')>
                <cffile action="delete" file="#arguments.save_folder#\eproducer_template_#session.ep.company_id#.xslt">
                <cffile action="delete" file="#arguments.save_folder#\eproducer_template_base64_#session.ep.company_id#.xslt">
            </cfif>
          <cfquery name="DEL_TEMPLATE_FILENAME" datasource="#dsn#">
              UPDATE EPRODUCER_RECEIPT_INTEGRATION_INFO 
              SET TEMPLATE_FILENAME = NULL,
                  TEMPLATE_FILENAME_BASE64 = NULL
              WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> 
          </cfquery>
        <cfelseif isdefined("arguments.eproducer_template") and len(arguments.eproducer_template)>
          <cftry>            
              <cfif not DirectoryExists(arguments.save_folder)>
                  <cfdirectory action = "create" directory="#arguments.save_folder#"/>
              </cfif>
              <cffile action="read" file="#arguments.eproducer_template#" variable="xslt_output" charset="utf-8">
              <cffile action="write" file="#arguments.save_folder#\eproducer_template_#session.ep.company_id#.xslt" output="#trim(xslt_output)#" charset="utf-8">
              <cfset xslt64_output = ToBase64(xslt_output)>
              <cffile action="write" file="#arguments.save_folder#\eproducer_template_base64_#session.ep.company_id#.xslt" output="#trim(xslt64_output)#" charset="utf-8">
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
                    EPRODUCER_RECEIPT_INTEGRATION_INFO
            (
                    COMP_ID,
                    EPRODUCER_TEST_SYSTEM,
                    EPRODUCER_COMPANY_CODE,
                    EPRODUCER_USER_NAME,
                    EPRODUCER_PASSWORD,
                    TEMPLATE_FILENAME,
                    TEMPLATE_FILENAME_BASE64,
                    EPRODUCER_LIVE_URL,
                    EPRODUCER_TEST_URL
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">,
                    <cfif arguments.eproducer_test_system eq 1>1<cfelse>0</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.eproducer_company_code#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.eproducer_username#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.eproducer_password#">,
                    <cfif len(arguments.eproducer_template)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="eproducer_template_#session.ep.company_id#.xslt"><cfelse>NULL</cfif>,
                    <cfif len(arguments.eproducer_template)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="eproducer_template_base64_#session.ep.company_id#.xslt"><cfelse>NULL</cfif>,     
                    <cfqueryparam cfsqltype='CF_SQL_nvarchar' value='#arguments.eproducer_live_url#'>,
                    <cfqueryparam cfsqltype='CF_SQL_nvarchar' value='#arguments.eproducer_test_url#'>
                )
            </cfquery>
                <cfquery name="upd_our_comp" datasource="#dsn#">
                    UPDATE OUR_COMPANY_INFO 
                        SET IS_EPRODUCER_RECEIPT = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_active#">,
                            EPRODUCER_RECEIPT_DATE = <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.eproducer_date#">
                        WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                </cfquery>
            <cfelse>
                <cfquery name="upd" datasource="#dsn#">
                    UPDATE 
                        EPRODUCER_RECEIPT_INTEGRATION_INFO
                    SET
                        EPRODUCER_TEST_SYSTEM = <cfif arguments.eproducer_test_system eq 1>1<cfelse>0</cfif>,
                        EPRODUCER_COMPANY_CODE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.eproducer_company_code#">,
                        EPRODUCER_USER_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.eproducer_username#">,
                        EPRODUCER_PASSWORD = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.eproducer_password#">,
                        TEMPLATE_FILENAME = <cfif len(arguments.eproducer_template)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="eproducer_template_#session.ep.company_id#.xslt"><cfelse>NULL</cfif>,
                        TEMPLATE_FILENAME_BASE64 = <cfif len(arguments.eproducer_template)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="eproducer_template_base64_#session.ep.company_id#.xslt"><cfelse>NULL</cfif>,
                        EPRODUCER_LIVE_URL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.eproducer_live_url#">,
                        EPRODUCER_TEST_URL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.eproducer_test_url#">
                    WHERE
                        COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                </cfquery>
                 <cfquery name="upd_our_comp" datasource="#dsn#">
                    UPDATE OUR_COMPANY_INFO 
                        SET IS_EPRODUCER_RECEIPT = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_active#">,
                        EPRODUCER_RECEIPT_DATE = <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.eproducer_date#">
                    WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                </cfquery>
            </cfif>
        </cftransaction>
        <cfreturn true />
    </cffunction>

    <cffunction name="getCompanyAdrress" access="public" returntype="query" hint="e-Müstahsil Adres Bilgileri">
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

    <cffunction name="ProducerCancelControl" access="public" hint="Makbuz İptal Bilgisi">
        <cfargument type="numeric" name="action_id"  required="yes">
        <cfquery name="ProducerCancelControl" datasource="#dsn2#">
            SELECT COMPANY_ID, CONSUMER_ID, IS_IPTAL FROM INVOICE WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> 
        </cfquery>
        <cfreturn ProducerCancelControl>
    </cffunction>

    <cffunction name="ProducerMoneyControl" access="public" hint="Makbuz Döviz Bilgisi">
        <cfargument type="numeric" name="action_id"  required="yes">
        <cfquery name="ProducerMoneyControl" datasource="#DSN2#">
            SELECT 
                I.OTHER_MONEY
            FROM 
                INVOICE I 
                    LEFT JOIN INVOICE_ROW IR ON I.INVOICE_ID = IR.INVOICE_ID
            WHERE 
                I.OTHER_MONEY <> IR.OTHER_MONEY AND
                I.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">     
        </cfquery>
        <cfreturn ProducerMoneyControl>
    </cffunction>

    <cffunction name="getProducer" access="public" returntype="query" hint="Makbuz Genel Belge Bilgileri">
        <cfargument type="string" name="action_type">
        <cfargument type="numeric" name="action_id">
        <cfargument type="string" name="company_id" default="">
        <cfargument type="string" name="consumer_id" default="">
        <cfargument type="string" name="temp_currency_code">
            <cfif len(arguments.company_id)>
                <cfquery name="getProducer" datasource="#DSN2#">
                    SELECT 
                        I.INVOICE_ID,
                        I.INVOICE_NUMBER,
                        I.INVOICE_DATE,
                        I.COMPANY_ID,
                        I.CONSUMER_ID,
                        I.DUE_DATE,
                        I.NOTE,
                        I.INVOICE_CAT,
                        '' TOTAL_AMOUNT,
                        I.WRK_ID,
                        I.SHIP_ADDRESS_ID,
                        I.SERIAL_NUMBER,
                        I.PROCESS_CAT,
                        I.IS_CASH,
                        I.CASH_ID,
                        I.BANK_ID,
                    <cfif arguments.temp_currency_code>
                        (SELECT ISNULL(SUM(DISCOUNTTOTAL),0) FROM INVOICE_ROW WHERE INVOICE_ROW.INVOICE_ID = I.INVOICE_ID) ROW_DISCOUNT,        
                        I.GROSSTOTAL GROSSTOTAL,
                        I.NETTOTAL NETTOTAL,
                        ISNULL(ROUND(I.SA_DISCOUNT,2),0) SA_DISCOUNT,  
                        'TRY' CURRENCY_CODE,
                        'TL' MONEY,
                        1 RATE2, 
                        ROUND(I.TAXTOTAL,2) TAXTOTAL,
                        ISNULL(ROUND(I.STOPAJ,2),0) STOPAJ,
                        ISNULL(ROUND(I.OTV_TOTAL,2),0) OTV_TOTAL,
                    <cfelse>
                        (SELECT ISNULL((SUM(DISCOUNTTOTAL)/IM.RATE2),0) FROM INVOICE_ROW WHERE INVOICE_ROW.INVOICE_ID = I.INVOICE_ID) ROW_DISCOUNT,        
                        (I.GROSSTOTAL/IM.RATE2) GROSSTOTAL,
                        (I.NETTOTAL/IM.RATE2) NETTOTAL,
                        ISNULL(ROUND((I.SA_DISCOUNT/IM.RATE2),2),0) SA_DISCOUNT,      
                        SM.CURRENCY_CODE,
                        SM.MONEY,
                        IM.RATE2, 
                        ROUND((I.TAXTOTAL/IM.RATE2),2) TAXTOTAL,
                        ISNULL(ROUND((I.STOPAJ/IM.RATE2),2),0) STOPAJ,
                        ISNULL(ROUND((I.OTV_TOTAL/IM.RATE2),2),0) OTV_TOTAL,
                    </cfif>            
                        CB.COMPBRANCH_CODE,
                        CB.COMPBRANCH_ALIAS,
                        CB.COMPBRANCH__NAME,
                        CP.COMPANY_PARTNER_NAME,
                        CP.COMPANY_PARTNER_SURNAME,
                        CP.TC_IDENTITY, 
                        CB.COMPBRANCH_POSTCODE COMPANY_POSTCODE2,
                        CB.COMPBRANCH_ADDRESS ADDRESS2,
                        COM.FULLNAME,
                        COM.COMPANY_EMAIL,
                        COM.COMPANY_TELCODE,
                        COM.COMPANY_TEL1 COMPANY_TEL,
                        COM.COMPANY_FAX,
                        COM.TAXOFFICE,
                        COM.TAXNO,
                        COM.COMPANY_POSTCODE,
                        COM.OZEL_KOD_2,
                        ISNULL(COM.IS_PERSON,0) AS IS_PERSON,
                        COM.COMPANY_ADDRESS ADDRESS,
                        SC.COUNTY_NAME,
                        SCI.CITY_NAME,
                        SCO.COUNTRY_NAME,
                        SC2.COUNTY_NAME COUNTY_NAME2,
                        SCI2.CITY_NAME CITY_NAME2,
                        SCO2.COUNTRY_NAME COUNTRY_NAME2,      
                        SP.PAYMETHOD,
                        CASE
                            WHEN (I.PAY_METHOD IS NOT NULL)
                               THEN SP.PAYMENT_MEANS_CODE
                            WHEN (I.CARD_PAYMETHOD_ID IS NOT NULL)
                               THEN CPT.PAYMENT_MEANS_CODE
                            ELSE 'ZZZ'
                        END AS PAYMENT_MEANS_CODE
                    FROM 
                        INVOICE I
                        INNER JOIN #dsn#.COMPANY COM ON COM.COMPANY_ID = I.COMPANY_ID
                        LEFT JOIN #dsn#.COMPANY_BRANCH CB ON CB.COMPBRANCH_ID = I.SHIP_ADDRESS_ID
                        LEFT JOIN #dsn#.COMPANY_PARTNER CP ON CP.PARTNER_ID = (CASE WHEN COM.IS_PERSON = 1 THEN COM.MANAGER_PARTNER_ID ELSE I.PARTNER_ID END)
                        LEFT JOIN #dsn#.SETUP_CITY SCI ON SCI.CITY_ID = COM.CITY 
                        LEFT JOIN #dsn#.SETUP_COUNTRY SCO ON SCO.COUNTRY_ID = COM.COUNTRY
                        LEFT JOIN #dsn#.SETUP_COUNTY SC ON SC.COUNTY_ID = COM.COUNTY
                        LEFT JOIN #dsn#.SETUP_CITY SCI2 ON SCI2.CITY_ID = CB.CITY_ID
                        LEFT JOIN #dsn#.SETUP_COUNTRY SCO2 ON SCO2.COUNTRY_ID = CB.COUNTRY_ID
                        LEFT JOIN #dsn#.SETUP_COUNTY SC2 ON SC2.COUNTY_ID = CB.COUNTY_ID
                        LEFT JOIN #dsn#.SETUP_PAYMETHOD SP ON SP.PAYMETHOD_ID = I.PAY_METHOD
                        LEFT JOIN #dsn3#.CREDITCARD_PAYMENT_TYPE CPT ON CPT.PAYMENT_TYPE_ID = I.CARD_PAYMETHOD_ID
                        LEFT JOIN INVOICE_MONEY IM ON IM.ACTION_ID = I.INVOICE_ID AND IM.IS_SELECTED = 1
                        LEFT JOIN SETUP_MONEY SM ON SM.MONEY = IM.MONEY_TYPE
                    WHERE 
                        I.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
                </cfquery>
            <cfelseif len(arguments.consumer_id)>
                <cfquery name="getProducer" datasource="#dsn2#">
                    SELECT 
                        I.INVOICE_ID,
                        I.INVOICE_NUMBER,
                        I.INVOICE_DATE,
                        I.COMPANY_ID,
                        I.CONSUMER_ID,
                        I.DUE_DATE,
                        I.NOTE,
                        I.INVOICE_CAT,
                        '' TOTAL_AMOUNT,
                        I.WRK_ID,
                        '' SHIP_ADDRESS_ID,
                        I.SERIAL_NUMBER,
                        I.PROCESS_CAT,
                        I.IS_CASH,
                        I.CASH_ID,      
                        I.BANK_ID,
                        I.DELIVER_EMP,
                    <cfif arguments.temp_currency_code>
                        (SELECT ISNULL(SUM(DISCOUNTTOTAL),0) FROM INVOICE_ROW WHERE INVOICE_ROW.INVOICE_ID = I.INVOICE_ID) ROW_DISCOUNT,            
                        I.GROSSTOTAL GROSSTOTAL,
                        I.NETTOTAL NETTOTAL,
                        ISNULL(ROUND(I.SA_DISCOUNT,2),0) SA_DISCOUNT,  
                        'TRY' CURRENCY_CODE,
                        'TL' MONEY,
                        1 RATE2, 
                        ROUND(I.TAXTOTAL,2) TAXTOTAL,
                        ISNULL(ROUND(I.STOPAJ,2),0) STOPAJ,
                        ISNULL(ROUND(I.OTV_TOTAL,2),0) OTV_TOTAL,
                    <cfelse>
                        (SELECT ISNULL((SUM(DISCOUNTTOTAL)/IM.RATE2),0) FROM INVOICE_ROW WHERE INVOICE_ROW.INVOICE_ID = I.INVOICE_ID) ROW_DISCOUNT,
                        (I.GROSSTOTAL/IM.RATE2) GROSSTOTAL,
                        (I.NETTOTAL/IM.RATE2) NETTOTAL,
                        SM.CURRENCY_CODE,
                        SM.MONEY,
                        IM.RATE2, 
                        ROUND((I.TAXTOTAL/IM.RATE2),2) TAXTOTAL,
                        ISNULL(ROUND((I.STOPAJ/IM.RATE2),2),0) STOPAJ,
                        ISNULL(ROUND((I.SA_DISCOUNT/IM.RATE2),2),0) SA_DISCOUNT,
                        ISNULL(ROUND((I.OTV_TOTAL/IM.RATE2),2),0) OTV_TOTAL,
                    </cfif>            
                        '' COMPBRANCH_CODE,
                        '' COMPBRANCH_ALIAS,
                        '' COMPBRANCH__NAME,
                        CON.CONSUMER_NAME COMPANY_PARTNER_NAME,
                        CON.CONSUMER_SURNAME COMPANY_PARTNER_SURNAME,
                        CON.TC_IDENTY_NO TC_IDENTITY,
                        CON.CONSUMER_NAME +' ' + CON.CONSUMER_SURNAME FULLNAME,
                        CON.CONSUMER_EMAIL COMPANY_EMAIL,
                        CON.TAX_ADRESS ADDRESS,
                        '' FULLNAME,
                        '' COMPANY_EMAIL,
                        '' COMPANY_TELCODE,
                        '' COMPANY_TEL,
                        '' COMPANY_FAX,
                        '' TAXOFFICE,
                        '' TAXNO,
                        '' COMPANY_POSTCODE,
                        '' OZEL_KOD_2,
                        1 IS_PERSON,
                        SC.COUNTY_NAME,
                        SCI.CITY_NAME,
                        SCO.COUNTRY_NAME,
                        '' COUNTY_NAME2,
                        '' CITY_NAME2,
                        '' COUNTRY_NAME2,            
                        SP.PAYMETHOD,
                        CASE
                            WHEN (I.PAY_METHOD IS NOT NULL)
                               THEN SP.PAYMENT_MEANS_CODE
                            WHEN (I.CARD_PAYMETHOD_ID IS NOT NULL)
                               THEN CPT.PAYMENT_MEANS_CODE
                            ELSE 'ZZZ'
                        END AS PAYMENT_MEANS_CODE
                    FROM 
                        INVOICE I
                        INNER JOIN #dsn#.CONSUMER CON ON CON.CONSUMER_ID = I.CONSUMER_ID
                        LEFT JOIN #dsn#.COMPANY_BRANCH CB ON CB.COMPBRANCH_ID = I.SHIP_ADDRESS_ID
                        LEFT JOIN #dsn#.SETUP_CITY SCI ON CON.TAX_CITY_ID = SCI.CITY_ID
                        LEFT JOIN #dsn#.SETUP_COUNTRY SCO ON  CON.TAX_COUNTRY_ID = SCO.COUNTRY_ID
                        LEFT JOIN #dsn#.SETUP_COUNTY SC ON CON.TAX_COUNTY_ID = SC.COUNTY_ID
                        LEFT JOIN #dsn#.SETUP_PAYMETHOD SP ON SP.PAYMETHOD_ID = I.PAY_METHOD
                        LEFT JOIN #dsn3#.CREDITCARD_PAYMENT_TYPE CPT ON CPT.PAYMENT_TYPE_ID = I.CARD_PAYMETHOD_ID
                        LEFT JOIN INVOICE_MONEY IM ON IM.ACTION_ID = I.INVOICE_ID AND IM.IS_SELECTED = 1
                        LEFT JOIN SETUP_MONEY SM ON SM.MONEY = IM.MONEY_TYPE
                    WHERE 
                        I.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
                </cfquery>
            </cfif>
        <cfreturn getProducer>
    </cffunction>

    <cffunction name="getProducerRow" access="public" hint="Makbuz Satırları">
        <cfargument type="numeric" name="action_id" required="yes">
        <cfargument type="numeric" name="temp_currency_code" required="yes">
        <cfquery name="getProducerRow" datasource="#DSN2#">
            SELECT
			IR.INVOICE_ROW_ID,
			IR.AMOUNT,
            IR.AMOUNT2,
			<cfif arguments.temp_currency_code>
			IR.NETTOTAL,
			IR.DISCOUNTTOTAL,
			IR.TAXTOTAL,
            IR.PRICE,
            <cfelse>
			(IR.NETTOTAL/IM.RATE2) NETTOTAL,
			(IR.DISCOUNTTOTAL/IM.RATE2) DISCOUNTTOTAL,
			(IR.TAXTOTAL/IM.RATE2) TAXTOTAL, 
            IR.PRICE_OTHER PRICE,           
            </cfif>
			IR.TAX,
			CASE WHEN IR.NAME_PRODUCT IS NOT NULL THEN IR.NAME_PRODUCT ELSE DESCRIPTION END AS NAME_PRODUCT,
            IR.PRODUCT_NAME2,
			ST.TAX_CODE,
			CASE 
            	WHEN (SU.UNIT_CODE IS NOT NULL OR (SU.UNIT_CODE IS NULL AND I.INVOICE_CAT <> 66)) THEN SU.UNIT_CODE
                WHEN (SU.UNIT_CODE IS NULL AND I.INVOICE_CAT = 66) THEN 'C62' 
           	END AS UNIT_CODE,       
            S.STOCK_CODE,
            S.BARCOD,
            PR.PRODUCT_CODE,
            PR.PRODUCT_CODE_2,
            IR.OIV_RATE,
            IR.OIV_AMOUNT
		FROM
        	INVOICE I,
			INVOICE_ROW IR 
            LEFT JOIN #dsn#.SETUP_UNIT SU ON IR.UNIT = SU.UNIT
            LEFT JOIN #dsn1#.STOCKS S ON S.STOCK_ID = IR.STOCK_ID
            LEFT OUTER JOIN #dsn3#.PRODUCT_PERIOD PP ON IR.PRODUCT_ID = PP.PRODUCT_ID AND PP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
            LEFT JOIN #dsn3#.PRODUCT PR ON PR.PRODUCT_ID = IR.PRODUCT_ID
            LEFT JOIN INVOICE_MONEY IM ON IM.ACTION_ID = IR.INVOICE_ID AND IM.MONEY_TYPE = IR.OTHER_MONEY
            LEFT JOIN SETUP_TAX ST ON ST.TAX = IR.TAX
		WHERE
			IR.INVOICE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> AND
            I.INVOICE_ID = IR.INVOICE_ID AND
			PP.TAX_CODE IS NULL<!--- icerisinde vergi kodu seçilmemis ürünler geliyor --->
        </cfquery>
        <cfreturn getProducerRow>
    </cffunction>

    <cffunction name="getProducerKDV" access="public" hint="Kdv Tutarları">
        <!--- 1-OTV, 2-KDV, 5-Stopaj --->
        <cfquery name="getProducerKDV" datasource="#dsn2#">
            SELECT
                TYPE,
                SUM(NETTOTAL) NETTOTAL,
                TAX_CODE_NAME,
                TAX_CODE,
                SUM(TAXTOTAL) TAX_AMOUNT,
                TAX
            FROM
            (
                SELECT
                    1 TYPE,
                <cfif arguments.temp_currency_code eq 1 >
                    SUM(IR.NETTOTAL) NETTOTAL,
                    ROUND(SUM(IR.OTVTOTAL),2) TAXTOTAL,
                <cfelse>
                    SUM(IR.NETTOTAL/IM.RATE2) NETTOTAL,
                    ROUND(SUM(IR.OTVTOTAL/IM.RATE2),2) TAXTOTAL,
                </cfif>                
                    SO.TAX_CODE_NAME,
                    SO.TAX_CODE,
                    IR.OTV_ORAN TAX 
                FROM 
                    INVOICE_ROW IR
                        LEFT JOIN INVOICE_MONEY IM ON IM.ACTION_ID = IR.INVOICE_ID AND IM.MONEY_TYPE = IR.OTHER_MONEY,
                    #dsn3#.SETUP_OTV SO
                WHERE
                    SO.TAX = IR.OTV_ORAN AND
                    SO.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
                    IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> AND
                    IR.OTVTOTAL != 0
                GROUP BY
                    IR.OTV_ORAN,
                    SO.TAX_CODE_NAME,
                    SO.TAX_CODE,
                    IR.OTHER_MONEY
            )T1
            GROUP BY
                TYPE,
                TAX,
                TAX_CODE_NAME,
                TAX_CODE,
                TAXTOTAL
        UNION
            SELECT
                TYPE,
                SUM(NETTOTAL) NETTOTAL,
                TAX_CODE_NAME,
                TAX_CODE,
                SUM(TAXTOTAL) TAX_AMOUNT,
                TAX
            FROM
            (
                SELECT 
                    2 TYPE, 
                <cfif arguments.temp_currency_code>
                    IR.NETTOTAL NETTOTAL,
                    CASE WHEN(IR.NETTOTAL = 0) THEN
                        IR.TAXTOTAL
                    ELSE
                        (((I.GROSSTOTAL - ISNULL(IR.DISCOUNTTOTAL,0)) - I.SA_DISCOUNT) / (I.GROSSTOTAL - ISNULL(IR.DISCOUNTTOTAL,0))* IR.TAXTOTAL)
                    END AS TAXTOTAL,                
                <cfelse>
                    (IR.NETTOTAL/IM.RATE2) NETTOTAL,
                    CASE WHEN(IR.NETTOTAL = 0) THEN
                        (IR.TAXTOTAL/IM.RATE2)
                    ELSE
                        (((I.GROSSTOTAL - ISNULL(IR.DISCOUNTTOTAL,0)) - I.SA_DISCOUNT) / (I.GROSSTOTAL - ISNULL(IR.DISCOUNTTOTAL,0))* IR.TAXTOTAL)/IM.RATE2
                    END AS TAXTOTAL,                
                </cfif>               
                    ST.TAX_CODE_NAME,
                    ST.TAX_CODE,
                    IR.TAX 
                FROM 
                    INVOICE_ROW IR 
                        LEFT JOIN #dsn3#.PRODUCT_PERIOD PP ON IR.PRODUCT_ID = PP.PRODUCT_ID AND PP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
                        LEFT JOIN INVOICE_MONEY IM ON IM.ACTION_ID = IR.INVOICE_ID AND IM.MONEY_TYPE = IR.OTHER_MONEY,
                    SETUP_TAX ST,
                    INVOICE I
                WHERE 
                    IR.TAX = ST.TAX AND 
                    IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> AND 
                    I.INVOICE_ID = IR.INVOICE_ID AND 
                    PP.TAX_CODE IS NULL 
            )T1
            GROUP BY 
                TYPE,
                TAX,
                TAX_CODE_NAME,
                TAX_CODE
        UNION      
            SELECT
                TYPE,
                SUM(NETTOTAL) NETTOTAL,
                TAX_CODE_NAME,
                TAX_CODE,
                TAXTOTAL TAX_AMOUNT,
                TAX
            FROM
            (
                SELECT DISTINCT
                    3 TYPE,
                    <cfif temp_currency_code>
                    IR.NETTOTAL,
                    IT.TEVKIFAT_TUTAR TAXTOTAL,
                    <cfelse>                
                    (IR.NETTOTAL/IM.RATE2) NETTOTAL,
                    (IT.TEVKIFAT_TUTAR/IM.RATE2) TAXTOTAL,
                    </cfif>
                    ST.TEVKIFAT_CODE_NAME TAX_CODE_NAME,
                    ST.TAX_CODE TAX_CODE,				
                    ((1-I.TEVKIFAT_ORAN)*100) TAX 
                FROM 
                    INVOICE_ROW IR 
                        LEFT JOIN INVOICE_MONEY IM ON IM.ACTION_ID = IR.INVOICE_ID AND IM.MONEY_TYPE = IR.OTHER_MONEY
                        LEFT JOIN #dsn3#.PRODUCT_PERIOD PP ON IR.PRODUCT_ID = PP.PRODUCT_ID AND PP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">,
                    #dsn3#.SETUP_TEVKIFAT ST,
                    INVOICE I,
                    INVOICE_TAXES IT
                WHERE 
                    ST.TEVKIFAT_ID = I.TEVKIFAT_ID AND 
                    ST.IS_ACTIVE = 1 AND 
                    I.INVOICE_ID = IR.INVOICE_ID AND 
                    I.INVOICE_ID = IT.INVOICE_ID AND 
                    IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> AND 
                    I.TEVKIFAT_ORAN != 0 AND
                    PP.TAX_CODE IS NULL AND 
                    IT.TEVKIFAT_TUTAR <> 0 <!--- Tevkifat icin vergi kodu secilmemis ürünler cekilmeli --->
            )T1
            GROUP BY 
                TYPE,
                TAX,
                TAX_CODE_NAME,
                TAX_CODE,
                TAXTOTAL
        UNION
            SELECT
                TYPE,
                SUM(NETTOTAL) NETTOTAL,
                TAX_CODE_NAME,
                TAX_CODE,
                TAX_AMOUNT,
                TAX
            FROM
            (
                SELECT 
                    5 TYPE,
                <cfif arguments.temp_currency_code>
                    IR.NETTOTAL NETTOTAL,
                <cfelse>
                        (IR.NETTOTAL/IM.RATE2) NETTOTAL,
                </cfif>
                    ST.TAX_CODE_NAME,
                    ST.TAX_CODE,
                    (I.STOPAJ/IM.RATE2) TAX_AMOUNT,
                    I.STOPAJ_ORAN TAX 
                FROM 
                    INVOICE_ROW IR
                    LEFT JOIN INVOICE_MONEY IM ON IM.ACTION_ID = IR.INVOICE_ID AND IM.MONEY_TYPE = IR.OTHER_MONEY,
                    INVOICE I,
                    #dsn2#.SETUP_STOPPAGE_RATES ST 
                WHERE
                    ST.STOPPAGE_RATE = I.STOPAJ_ORAN AND
                    I.STOPAJ_RATE_ID = ST.STOPPAGE_RATE_ID AND
                    I.INVOICE_ID = IR.INVOICE_ID AND
                    ISNULL(I.STOPAJ_ORAN,0) != 0 AND
                    I.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#" />
                ) T1
            GROUP BY
                TYPE,
                TAX_CODE_NAME,
                TAX_CODE,
                TAX_AMOUNT,
                TAX
        </cfquery>
        <cfreturn getProducerKDV>
    </cffunction>

    <cffunction name="getProducerTaxRow" access="public" hint="Satır Kdv Tutarları">
        <cfquery name="getProducerTaxRow" datasource="#DSN2#">
            SELECT
                TYPE,
                INVOICE_ROW_ID,
                TAX_TOTAL,
                TAX,
                REASON_CODE,
                REASON_NAME,
                TAX_CODE,
                TAX_CODE_NAME
            FROM
            (SELECT
                1 TYPE,
                IR.INVOICE_ROW_ID,
            <cfif arguments.temp_currency_code>
                IR.OTVTOTAL TAX_TOTAL,
            <cfelse>
                (IR.OTVTOTAL/IM.RATE2) TAX_TOTAL,
            </cfif>
                IR.OTV_ORAN TAX,
                IR.REASON_CODE,
                IR.REASON_NAME,
                SO.TAX_CODE,
                SO.TAX_CODE_NAME
            FROM
                INVOICE_ROW IR
                    LEFT JOIN #dsn3#.PRODUCT_PERIOD PP ON IR.PRODUCT_ID = PP.PRODUCT_ID AND PP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
                    LEFT JOIN INVOICE_MONEY IM ON IM.ACTION_ID = IR.INVOICE_ID AND IM.MONEY_TYPE = IR.OTHER_MONEY,
                #dsn3#.SETUP_OTV SO
            WHERE
                IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> AND
                SO.TAX = IR.OTV_ORAN AND
                IR.OTV_ORAN != 0 AND
                PP.TAX_CODE IS NULL AND<!--- icerisinde vergi kodu seçilmemis ürünler geliyor --->
                SO.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
            UNION
            SELECT
                2 TYPE,
                IR.INVOICE_ROW_ID,
            <cfif arguments.temp_currency_code>
                CASE WHEN(IR.NETTOTAL = 0) THEN
                    IR.TAXTOTAL
                ELSE
                    (((I.GROSSTOTAL - ISNULL(IR.DISCOUNTTOTAL,0))) / (I.GROSSTOTAL - ISNULL(IR.DISCOUNTTOTAL,0))*IR.TAXTOTAL)
                END AS TAXTOTAL,
            <cfelse>
                CASE WHEN(IR.NETTOTAL = 0) THEN
                    (IR.TAXTOTAL/IM.RATE2)
                ELSE
                    (((I.GROSSTOTAL - ISNULL(IR.DISCOUNTTOTAL,0))) / (I.GROSSTOTAL - ISNULL(IR.DISCOUNTTOTAL,0))*IR.TAXTOTAL)/IM.RATE2
                END AS TAXTOTAL,
            </cfif>
                IR.TAX,
                IR.REASON_CODE,
                IR.REASON_NAME,            
                ST.TAX_CODE,
                ST.TAX_CODE_NAME			
            FROM 
                INVOICE_ROW IR 
                    LEFT JOIN #dsn3#.PRODUCT_PERIOD PP ON IR.PRODUCT_ID = PP.PRODUCT_ID AND PP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
                    LEFT JOIN INVOICE_MONEY IM ON IM.ACTION_ID = IR.INVOICE_ID AND IM.MONEY_TYPE = IR.OTHER_MONEY,
                SETUP_TAX ST,
                INVOICE I
            WHERE 
                IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> AND
                IR.INVOICE_ID = I.INVOICE_ID AND
                ST.TAX = IR.TAX AND
                PP.TAX_CODE IS NULL<!--- İçerisinde vergi kodu seçilmemiş ürünler geliyor --->
            UNION 
            SELECT
                3 TYPE,
                IR.INVOICE_ROW_ID,
                (IR.NETTOTAL/IM.RATE2) TAXTOTAL,
                0 TAX,
                IR.REASON_CODE,
                IR.REASON_NAME,             
                PP.TAX_CODE,
                PP.TAX_CODE_NAME
            FROM 
                INVOICE_ROW IR
                    LEFT JOIN INVOICE_MONEY IM ON IM.ACTION_ID = IR.INVOICE_ID AND IM.MONEY_TYPE = IR.OTHER_MONEY,
                #dsn3#.PRODUCT_PERIOD PP
            WHERE 
                IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> AND
                PP.PRODUCT_ID = IR.PRODUCT_ID AND 
                PP.TAX_CODE IS NOT NULL AND
                PP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
            UNION
            SELECT
                6 TYPE,
                IR.INVOICE_ROW_ID,
            <cfif arguments.temp_currency_code>
                IR.BSMV_AMOUNT TAX_TOTAL,
            <cfelse>
                (IR.BSMV_AMOUNT/IM.RATE2) TAX_TOTAL,
            </cfif>
                IR.BSMV_RATE TAX,
                IR.REASON_CODE,
                IR.REASON_NAME,
                SB.TAX_CODE,
                SB.TAX_CODE_NAME
            FROM
                INVOICE_ROW IR
                    LEFT JOIN #dsn3#.PRODUCT_PERIOD PP ON IR.PRODUCT_ID = PP.PRODUCT_ID AND PP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
                    LEFT JOIN INVOICE_MONEY IM ON IM.ACTION_ID = IR.INVOICE_ID AND IM.MONEY_TYPE = IR.OTHER_MONEY,
                #dsn3#.SETUP_BSMV SB
            WHERE
                IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> AND
                SB.TAX = IR.BSMV_RATE AND
                IR.BSMV_RATE != 0 AND
                PP.TAX_CODE IS NULL AND<!--- icerisinde vergi kodu seçilmemis ürünler geliyor --->
                SB.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
            UNION
            SELECT
                7 TYPE,
                IR.INVOICE_ROW_ID,
            <cfif arguments.temp_currency_code>
                IR.OIV_AMOUNT TAX_TOTAL,
            <cfelse>
                (IR.OIV_AMOUNT/IM.RATE2) TAX_TOTAL,
            </cfif>
                IR.OIV_RATE TAX,
                IR.REASON_CODE,
                IR.REASON_NAME,
                SOI.TAX_CODE,
                SOI.TAX_CODE_NAME
            FROM
                INVOICE_ROW IR
                    LEFT JOIN #dsn3#.PRODUCT_PERIOD PP ON IR.PRODUCT_ID = PP.PRODUCT_ID AND PP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
                    LEFT JOIN INVOICE_MONEY IM ON IM.ACTION_ID = IR.INVOICE_ID AND IM.MONEY_TYPE = IR.OTHER_MONEY,
                #dsn3#.SETUP_OIV SOI
            WHERE
                IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> AND
                SOI.TAX = IR.OIV_RATE AND
                IR.OIV_RATE != 0 AND
                PP.TAX_CODE IS NULL AND<!--- icerisinde vergi kodu seçilmemis ürünler geliyor --->
                SOI.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">) TAX_QUERY
            ORDER BY
                REASON_CODE
        </cfquery>
        <cfreturn getProducerTaxRow>
    </cffunction>

    <cffunction name="eReceiptSendingDetail" access="public" hint="e-Makbuz Gönderim Detayları">
    	<cfargument type="string" name="service_result" required="no">
        <cfargument type="string" name="uuid" required="no">
        <cfargument type="string" name="ereceipt_id" required="no">
        <cfargument type="string" name="status_description" required="no">
        <cfargument type="string" name="service_result_description" required="no">
        <cfargument type="string" name="status_code" required="no">
        <cfargument type="string" name="error_code" required="no">
        <cfargument type="numeric" name="action_id" required="no">
        <cfargument type="string" name="action_type" required="no">
        
    	<cfquery name="ADD_SENDING_DETAIL" datasource="#dsn2#">
            INSERT INTO
                ERECEIPT_SENDING_DETAIL
            (
                SERVICE_RESULT,
                <cfif isdefined("arguments.uuid")>UUID,</cfif>
                ERECEIPT_ID,
                STATUS_DESCRIPTION,
                SERVICE_RESULT_DESCRIPTION,
                <cfif isdefined("arguments.status_code") and len(arguments.status_code)>STATUS_CODE,</cfif>
                <cfif isdefined("arguments.error_code") and len(arguments.error_code)>ERROR_CODE,</cfif>
                ACTION_ID,
                ACTION_TYPE,
                RECORD_DATE,
                RECORD_EMP,
                RECORD_IP
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.service_result#">,
                <cfif isdefined("arguments.uuid")><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.uuid#">,</cfif>
                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.ereceipt_id#">,
                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.status_description#">,
                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#left(arguments.service_result_description,250)#">,
                <cfif isdefined("arguments.status_code") and len(arguments.status_code)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.status_code#">,</cfif>
                <cfif isdefined("arguments.error_code") and len(arguments.error_code)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.error_code#">,</cfif>
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">,
                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.action_type#">,
                #NOW()#,
                #session.ep.userid#,
                '#cgi.REMOTE_ADDR#'
            )
    	</cfquery> 
    </cffunction>

    <cffunction name="eReceiptRelation" access="public" hint="e-Makbuz İlişkileri Kayıt">
        <cfargument type="string" name="uuid" required="no">
        <cfargument type="string" name="integration_id" required="no">
        <cfargument type="string" name="envuuid" required="no">
        <cfargument type="string" name="ereceipt_id" required="no">
        <cfargument type="numeric" name="action_id" required="no">
        <cfargument type="string" name="action_type" required="no">
        <cfargument type="string" name="profile_id" required="no">
        <cfargument type="string" name="path" required="no">
        <cfquery name="ADD_RECEIPT_RELATION" datasource="#DSN2#">
            INSERT INTO
                ERECEIPT_RELATION
            (
                UUID,
                INTEGRATION_ID,
                ERECEIPT_ID,
                PROFILE_ID,
                ACTION_ID,
                ACTION_TYPE,
                PATH,
                RECORD_DATE,
                RECORD_EMP,
                RECORD_IP
            )
            VALUES
            (
                '#arguments.uuid#',       
                '#arguments.integration_id#',
                '#arguments.ereceipt_id#',
                '#arguments.profile_id#',
                #arguments.action_id#,
                '#arguments.action_type#',
                '#arguments.path#',
                #NOW()#,
                #session.ep.userid#,
                '#cgi.REMOTE_ADDR#'
            )
        </cfquery>
    </cffunction>

    <cffunction name="updPaperNoSendReceipt" access="public" hint="e-Makbuz ok dönerse belge no lar güncellenir">
        <cfargument name="action_id" type="numeric" required="yes">
        <cfargument name="receipt_number" type="string" required="yes">
        <cfquery name="UPD_INVOICE_SALE" datasource="#dsn2#">
            UPDATE INVOICE SET INVOICE_NUMBER = '#arguments.receipt_number#',SERIAL_NO = '#arguments.receipt_number#',SERIAL_NUMBER = NULL WHERE INVOICE_ID = #arguments.action_id#
        </cfquery>
        <cfquery name="updReceiptRelationNumber" datasource="#dsn2#">
            UPDATE ERECEIPT_RELATION SET IS_PAPER_UPDATE = 1 WHERE INTEGRATION_ID = '#arguments.receipt_number#'
        </cfquery>
    </cffunction>

    <cffunction name="eReceiptDetail" access="public" hint="e-Makbuz Detay">
        <cfargument name="action_id" type="numeric" required="no">
        <cfargument name="action_type" type="string" required="no">
        <cfquery name="GET_ERECEIPT_DETAIL" datasource="#dsn2#">
            SELECT 
                ER.PROFILE_ID,
                ER.INTEGRATION_ID,
                ER.PATH,
                ESD.ERECEIPT_ID,
                ESD.STATUS_DESCRIPTION,
                ESD.SERVICE_RESULT,
                ESD.SERVICE_RESULT_DESCRIPTION,
                ESD.RECORD_DATE,
                ESD.UUID,
                E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME NAME
            FROM 
                ERECEIPT_SENDING_DETAIL ESD
                LEFT JOIN ERECEIPT_RELATION ER ON ER.ACTION_ID = ESD.ACTION_ID AND ER.ACTION_TYPE = ESD.ACTION_TYPE,
                #dsn#.EMPLOYEES E
            WHERE
                ESD.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> AND
                ESD.ACTION_TYPE =  <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.action_type#"> AND
                E.EMPLOYEE_ID = ESD.RECORD_EMP
            ORDER BY
                SENDING_DETAIL_ID DESC        
        </cfquery>
        <cfreturn GET_ERECEIPT_DETAIL>
    </cffunction>

    <cffunction name="getReceiptRelation" access="public" returntype="query" hint="e-Makbuz İlişki Detay">
    	<cfargument name="action_id" type="numeric" required="true" />
    	<cfargument name="action_type" type="string" required="true" />
        <cfquery name="get_relation" datasource="#DSN2#">
            SELECT
                ER.*,
                ESD.STATUS_CODE
            FROM
                ERECEIPT_RELATION AS ER 
                INNER JOIN ERECEIPT_SENDING_DETAIL AS ESD ON ER.ACTION_ID = ESD.ACTION_ID AND ER.ACTION_TYPE = ESD.ACTION_TYPE
            WHERE
                ER.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> AND
                ER.ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.action_type#">
            ORDER BY
                ER.RECORD_DATE DESC
		</cfquery>
      <cfreturn get_relation />
    </cffunction>

    <cffunction name="updReceiptRelation" returntype="any" access="public" hint="e-Makbuz İlişkileri Güncelleme">
    	<cfargument type="string" name="uuid" required="yes">     
        <cfargument name="StatusCode" type="numeric" required="yes">
        <cfargument type="string" name="CheckInvoiceStateResult" required="yes">
        <cfquery name="UPD_ERECEIPT_RELATION" datasource="#dsn2#">
            UPDATE
                ERECEIPT_RELATION
            SET
                STATUS_CODE = #arguments.StatusCode#,
                STATUS_DESCRIPTION = '#left(arguments.CheckInvoiceStateResult,250)#',
                STATUS_DATE = #now()#                            
            WHERE
                UUID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.uuid#">
        </cfquery>
      <cfreturn>
    </cffunction>

</cfcomponent>