<!---
    File: earchieve.cfc
    Folder: V16\e_government\cfc
    Author:
    Date:
    Description:
        E-arşiv fatura metodlarını içeren sınıf
    History:
        12.10.2019 Gramoni-Mahmut Çifçi - E-Government standart modüle taşındı
        13.04.21 farklı session değerleriyle kayıt atılacağız için tüm ep değerleri session base e çevirildi
    To Do:

--->

<cfcomponent>
    
    <cfif isdefined("session.pp")>
        <cfset session_base = evaluate('session.pp')>
    <cfelseif isdefined("session.ep")>
        <cfset session_base = evaluate('session.ep')>
    <cfelseif isdefined("session.ww")>
        <cfset session_base = evaluate('session.ww')>
    <cfelseif isdefined("session.wp")>
        <cfset session_base = evaluate('session.wp')>
    </cfif>

    <cfset variables.dir_seperator = application.systemParam.systemParam().dir_seperator />

    <cffunction name="addIntegrationDefinitions" access="public" returntype="any">
        <cfargument type="numeric" name="earchive_integration_type" default="">
        <cfargument type="string" name="earchive_type_alias" default="">
        <cfargument type="numeric" name="earchive_test_system" default="">
        <cfargument type="string" name="earchive_company_code" default="">
        <cfargument type="string" name="earchive_username" default="">
        <cfargument type="string" name="earchive_password" default="">
        <cfargument type="string" name="earchive_prefix" default="">
        <cfargument type="string" name="earchive_prefix_internet" default="">
        <cfargument type="string" name="earchive_template" default="">
        <cfargument type="string" name="earchive_internet_template" default="">
        <cfargument type="boolean" name="multiple_prefix" required="false" default="false" />
        
        <cfquery name="ADD" datasource="#this.dsn#">
            INSERT INTO
                EARCHIVE_INTEGRATION_INFO
           (
                COMP_ID,
                EARCHIVE_INTEGRATION_TYPE,
                EARCHIVE_TYPE_ALIAS,
                EARCHIVE_TEST_SYSTEM,
                EARCHIVE_COMPANY_CODE,
                EARCHIVE_USERNAME,
                EARCHIVE_PASSWORD,
                EARCHIVE_PREFIX,
                EARCHIVE_PREFIX_INTERNET,
                TEMPLATE_FILENAME,
                TEMPLATE_FILENAME_INTERNET,
                IS_MULTIPLE_PREFIX,
                RECORD_DATE,
                RECORD_EMP,
                RECORD_IP
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.earchive_integration_type#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.earchive_type_alias#">,
                <cfif arguments.earchive_test_system eq 1>1<cfelse>0</cfif>,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.earchive_company_code#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.earchive_username#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.earchive_password#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.earchive_prefix#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.earchive_prefix_internet#">,
                <cfif isdefined("arguments.template_filename") and len(arguments.template_filename)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.template_filename#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.template_filename_internet") and len(arguments.template_filename_internet)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.template_filename_internet#"><cfelse>NULL</cfif>,
                <cfif arguments.multiple_prefix><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.multiple_prefix#" /><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.userid#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
             )
         </cfquery>
    </cffunction>

    <cffunction name="updIntegrationDefinitions" access="public" returntype="any">
        <cfargument type="numeric" name="earchive_integration_type" default="">
        <cfargument type="string" name="earchive_type_alias" default="">
        <cfargument type="numeric" name="earchive_test_system" default="">
        <cfargument type="string" name="earchive_company_code" default="">
        <cfargument type="string" name="earchive_username" default="">
        <cfargument type="string" name="earchive_password" default="">
        <cfargument type="string" name="earchive_prefix" default="">
        <cfargument type="string" name="earchive_prefix_internet" default="">
        <cfargument type="string" name="earchive_template" default="">
        <cfargument type="string" name="earchive_internet_template" default="">
        <cfargument type="string" name="earchive_del_template" default="">
        <cfargument type="string" name="earchive_internet_del_template" default="">
        <cfargument type="string" name="attachment_file" default="">
        <cfargument type="string" name="attachment_file_del" default="">
        <cfargument type="string" name="save_folder" default="">
        <cfargument type="string" name="earchive_ublversion" required="yes">
        <cfargument type="boolean" name="multiple_prefix" required="false" default="false" />
        
        <cfquery name="upd" datasource="#this.dsn#">
            UPDATE
                EARCHIVE_INTEGRATION_INFO
            SET
                EARCHIVE_INTEGRATION_TYPE = <cfif len(arguments.earchive_integration_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.earchive_integration_type#"></cfif>,
                EARCHIVE_TYPE_ALIAS = <cfif len(arguments.earchive_type_alias)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.earchive_type_alias#"></cfif>,
                EARCHIVE_TEST_SYSTEM = <cfif arguments.earchive_test_system eq 1>1<cfelse>0</cfif>,
                EARCHIVE_COMPANY_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.earchive_company_code#">,
                EARCHIVE_USERNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.earchive_username#">,
                EARCHIVE_PASSWORD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.earchive_password#">,
                EARCHIVE_PREFIX = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.earchive_prefix#">,
                EARCHIVE_PREFIX_INTERNET = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.earchive_prefix_internet#">,
                <cfif len(arguments.earchive_template)>
                	TEMPLATE_FILENAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="earchive_template_#session_base.company_id#.xslt">,
                	TEMPLATE_FILENAME_BASE64 = <cfqueryparam cfsqltype="cf_sql_varchar" value="earchive_template_base64_#session_base.company_id#.xslt">,
                </cfif>
				<cfif len(arguments.earchive_internet_template)>
                	TEMPLATE_FILENAME_INTERNET = <cfqueryparam cfsqltype="cf_sql_varchar" value="earchive_internet_template_#session_base.company_id#.xslt">,
                    TEMPLATE_FILENAME_INTERNET_BASE64 = <cfqueryparam cfsqltype="cf_sql_varchar" value="earchive_internet_template_base64_#session_base.company_id#.xslt">,
                </cfif>
                UBLVERSIONID = '#listfirst(arguments.earchive_ublversion,';')#',
                CUSTOMIZATIONID = '#listlast(arguments.earchive_ublversion,';')#',
                IS_MULTIPLE_PREFIX  = <cfif arguments.multiple_prefix><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.multiple_prefix#" /><cfelse>NULL</cfif>,
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.userid#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
            WHERE
                COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#">
        </cfquery>
        
		<cfif isdefined("arguments.earchive_del_template") and isdefined("arguments.earchive_internet_del_template")>
            <cfif len(arguments.earchive_del_template)>
                <cfquery datasource="#this.DSN#">
                    UPDATE
                        EARCHIVE_INTEGRATION_INFO 
                    SET
                        TEMPLATE_FILENAME = NULL,
                        TEMPLATE_FILENAME_BASE64 = NULL
                    WHERE
                        COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#" />
                </cfquery>
                <cftry>
                    <cffile action="delete" file="#arguments.save_folder##variables.dir_seperator#earchive_template_#session_base.company_id#.xslt" />
                    <cffile action="delete" file="#arguments.save_folder##variables.dir_seperator#earchive_template_base64_#session_base.company_id#.xslt" />
                <cfcatch type="any">
                    <script>
                    	alert("Dosya bulunamadı ancak veritabanından silindi!");
                    </script>
                </cfcatch>
                </cftry>
            </cfif>
            <cfif len(arguments.earchive_internet_del_template)>
                <cfquery datasource="#this.DSN#">
                    UPDATE
                        EARCHIVE_INTEGRATION_INFO 
                    SET
                        TEMPLATE_FILENAME_INTERNET = NULL,
                        TEMPLATE_FILENAME_INTERNET_BASE64 = NULL
                    WHERE
                        COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#" />
                </cfquery>
                <cftry>
                    <cffile action="delete" file="#arguments.save_folder##variables.dir_seperator#earchive_internet_template_#session_base.company_id#.xslt" />
                    <cffile action="delete" file="#arguments.save_folder##variables.dir_seperator#earchive_internet_template_base64_#session_base.company_id#.xslt" />
                <cfcatch type="any">
                    <script>
                    	alert("Dosya bulunamadı ancak veritabanından silindi!");
                    </script>
                </cfcatch>
                </cftry>
            </cfif>
        </cfif>
        <cfif isdefined("arguments.earchive_template") and isdefined("arguments.earchive_internet_template")>
            <cftry>
            	<cfif not DirectoryExists(arguments.save_folder)>
                    <cfdirectory action = "create" directory="#arguments.save_folder#"/>
                </cfif>
            	<cfif len(arguments.earchive_template)>
                	<cffile action="read" file="#arguments.earchive_template#" variable="xslt_output" charset="utf-8">
                	<cffile action="write" file="#arguments.save_folder##variables.dir_seperator#earchive_template_#session_base.company_id#.xslt" output="#trim(xslt_output)#" charset="utf-8">
					<cfset xslt_output64 = ToBase64(xslt_output)>
                    <cffile action="write" file="#arguments.save_folder##variables.dir_seperator#earchive_template_base64_#session_base.company_id#.xslt" output="#trim(xslt_output64)#" charset="utf-8">
                </cfif>
                <cfif len(arguments.earchive_internet_template)>
                	<cffile action="read" file="#arguments.earchive_internet_template#" variable="xslt_internet_output" charset="utf-8">
                	<cffile action="write" file="#arguments.save_folder##variables.dir_seperator#earchive_internet_template_#session_base.company_id#.xslt" output="#trim(xslt_internet_output)#" charset="utf-8">
                    <cfset xslt_internet_output64 = ToBase64(xslt_internet_output)>
                    <cffile action="write" file="#arguments.save_folder##variables.dir_seperator#earchive_internet_template_base64_#session_base.company_id#.xslt" output="#trim(xslt_internet_output64)#" charset="utf-8">
                </cfif>
                <cfcatch type="Any">
                <cfset error=1>
                <script>
                    alert("Dosya Upload Edilemedi!");
                    history.back();
                </script>
                </cfcatch>
            </cftry>
        </cfif>
        
        <!--- ek belge --->
        <cfset getEarchive = get_our_company_fnc(session_base.company_id)>
        <cfif len(arguments.attachment_file_del) or (len(arguments.attachment_file) and len(getEarchive.attachment_file))>
        	<cffile action="delete" file="#arguments.save_folder#\#getEarchive.attachment_file#">
            
            <cfquery name="DEL_ATTACHMENT_FILE" datasource="#this.DSN#">
                UPDATE EARCHIVE_INTEGRATION_INFO 
                SET 
                    ATTACHMENT_FILE = NULL,
                    ATTACHMENT_FILE_NAME = NULL
                WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#"> 
            </cfquery>
        </cfif>
        
        <cfif len(arguments.attachment_file)>
            <cftry>
				<cffile action="upload" filefield="attachment_file" destination="#save_folder#" mode="777" nameconflict="MAKEUNIQUE" />

				<cfset file_name = createUUID()>
                <cffile action="rename" source="#save_folder##variables.dir_seperator##cffile.serverfile#" destination="#save_folder##variables.dir_seperator##file_name#.#cffile.serverfileext#">
                <cfset attachmentFile = '#file_name#.#cffile.serverfileext#'>
                <cfset attachmentFileName = '#cffile.serverfile#'>
            	
                <cfquery name="UPD_ATTACHMENT_FILE" datasource="#this.DSN#">
                    UPDATE EARCHIVE_INTEGRATION_INFO 
                    SET 
                        ATTACHMENT_FILE = '#attachmentFile#',
                        ATTACHMENT_FILE_NAME = '#attachmentFileName#'
                    WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#"> 
                </cfquery>
                
                <cfcatch type="Any">
					<script type="text/javascript">
						alert("Dosyanız upload edilemedi!");
                    </script>
                    <cfabort>
                </cfcatch>
            </cftry>
        </cfif>
        <!--- ek belge --->
	</cffunction>
    
    <cffunction name="get_detail_fnc" access="public" returntype="query" hint="Gönderilmiş e-arşiv faturaları getiririr">
    	<cfargument name="action_id" type="numeric" required="no">
        <cfargument name="action_type" type="string" required="no">
    	<cfquery name="GET_DETAIL" datasource="#this.dsn2#">
            SELECT
                ESD.ZIP_FILE_NAME,
                ESD.OUTPUT_TYPE,
                ER.STATUS_CODE,
                ER.INTEGRATION_ID,
                ESD.EARCHIVE_ID,
                ESD.STATUS_DESCRIPTION,
                ESD.SERVICE_RESULT,
                ESD.SERVICE_RESULT_DESCRIPTION,
                ESD.RECORD_DATE,
                E.EMPLOYEE_NAME +' ' +E.EMPLOYEE_SURNAME NAME,
                ER.STATUS,
                ER.STATUS_DESCRIPTION RELATION_DETAIL,
                ESD.RECORD_DATE,
                ESD.INVOICE_TYPE_CODE,
                ER.CANCEL_DATE,
                ISNULL(ER.IS_CANCEL,0) IS_CANCEL,
                ER.CANCEL_DESCRIPTION,
                (SELECT E2.EMPLOYEE_NAME +' ' +E2.EMPLOYEE_SURNAME FROM #this.dsn_alias#.EMPLOYEES E2 WHERE E2.EMPLOYEE_ID = ER.CANCEL_EMP) NAME2
            FROM 
                EARCHIVE_SENDING_DETAIL ESD
                    LEFT JOIN EARCHIVE_RELATION ER ON ER.ACTION_ID = ESD.ACTION_ID AND ER.ACTION_TYPE = ESD.ACTION_TYPE,
                #this.dsn_alias#.EMPLOYEES E
            WHERE
                ESD.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> AND
                ESD.ACTION_TYPE =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_type#"> AND
                E.EMPLOYEE_ID = ESD.RECORD_EMP
            ORDER BY
                SENDING_DETAIL_ID DESC        
        </cfquery>
        <cfreturn get_detail>
    </cffunction>
    
    <cffunction name="get_our_company_fnc" access="public" returntype="query" hint="e-Arşiv şirket tanımlamalarını getirir">
    	<cfargument type="numeric" name="company_id"  required="yes">
    	<cfquery name="GET_OUR_COMPANY" datasource="#this.dsn#">
            SELECT
                EARCHIVE_INTEGRATION_TYPE,
                EARCHIVE_TYPE_ALIAS,
                EARCHIVE_TEST_SYSTEM,
                EARCHIVE_COMPANY_CODE,
                EARCHIVE_USERNAME,
                EARCHIVE_PASSWORD,
                UBLVERSIONID,
                CUSTOMIZATIONID,
                TEMPLATE_FILENAME_BASE64,
                TEMPLATE_FILENAME_INTERNET_BASE64,
                IS_TEMPLATE_CODE,
                EARCHIVE_PREFIX,
                EARCHIVE_PREFIX_INTERNET,
                TEMPLATE_FILENAME,
                TEMPLATE_FILENAME_INTERNET,
                ATTACHMENT_FILE,
                ATTACHMENT_FILE_NAME,
                IS_MULTIPLE_PREFIX
            FROM
                EARCHIVE_INTEGRATION_INFO
            WHERE
                COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
        </cfquery>
        <cfreturn get_our_company>
    </cffunction>
    
    <cffunction name="get_comp_info_fnc" access="public" returntype="query">
    	<cfargument type="numeric" name="company_id"  required="yes">
        <cfquery name="GET_COMP_INFO" datasource="#this.dsn#">
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
                SC.COUNTY_NAME
            FROM 
                OUR_COMPANY OC 
                LEFT JOIN SETUP_COUNTY SC ON SC.COUNTY_ID = OC.COUNTY_ID,
                SETUP_CITY SCI,
                SETUP_COUNTRY SCO
            WHERE 
                COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"> AND
                SCI.CITY_ID = OC.CITY_ID AND
                SCO.COUNTRY_ID = OC.COUNTRY_ID
        </cfquery>
        <cfreturn get_comp_info>
    </cffunction>
    
    <cffunction name="get_invoice_fnc" access="public" returntype="query" hint="E-Arşiv Fatura Genel Belge Bilgileri">
        <cfargument name="invoice_id" type="numeric" required="no">
        <cfargument name="company_id" type="numeric" required="no" default="0">
        <cfargument name="consumer_id" type="numeric" required="no" default="0">
        <cfargument name="employee_id" type="numeric" required="no" default="0">
        <cfargument name="action_type" type="string" required="no">
        <cfargument name="temp_currency_code" type="numeric" required="no">
        <cfif arguments.action_type is 'INVOICE'>
        	<cfquery name="GET_INVOICE" datasource="#this.dsn2#">
            <cfif arguments.company_id gt 0>
                SELECT
                    I.PAY_METHOD,
                    I.OTHER_MONEY,
                    I.OTHER_MONEY_VALUE,
                    I.CARD_PAYMETHOD_ID,
                    I.INVOICE_ID,
                    I.INVOICE_NUMBER,
                    I.INVOICE_DATE,
                    I.COMPANY_ID,
                    I.CONSUMER_ID,
                    I.DUE_DATE,
                    ROUND(I.GROSSTOTAL+I.TAXTOTAL,2) TAXINCLUSIVEAMOUNT,
                    I.INVOICE_NUMBER,
                    I.NOTE,
                    I.INVOICE_CAT,
                    I.SHIP_METHOD,
                    I.SERIAL_NUMBER,
                    I.SHIP_ADDRESS_ID,
                    I.BANK_ID,
                    CB.COMPBRANCH__NAME,
                    CB.COMPBRANCH_CODE COMPBRANCH_CODE,
                    CB.COMPBRANCH_ALIAS COMPBRANCH_ALIAS,
                    CB.COMPBRANCH_POSTCODE COMPANY_POSTCODE2,
                    COM.FULLNAME,
                    COM.COMPANY_TELCODE,
                    COM.COMPANY_TEL1 COMPANY_TEL,
                    COM.COMPANY_FAX,
                    COM.TAXOFFICE,
                    CASE WHEN COM.IS_PERSON = 1 THEN CP.TC_IDENTITY ELSE COM.TAXNO END AS TAXNO,
                    COM.EARCHIVE_SENDING_TYPE,
                    CP.COMPANY_PARTNER_NAME,
                    CP.COMPANY_PARTNER_SURNAME,
                    COM.MEMBER_CODE MEMBER_CODE,
                    SP.PAYMETHOD,
                    CASE WHEN USE_EARCHIVE = 1 THEN COM.COMPANY_EMAIL ELSE '' END COMPANY_EMAIL,
                    CASE WHEN SPC.IS_PARTNER = 1 OR SPC.IS_PUBLIC = 1 THEN 1 ELSE 0 END IS_INTERNET,
                    CR.BAKIYE,
                    ER.EARCHIVE_ID,
                    SPC.INVOICE_TYPE_CODE,
                    SPC.PROCESS_CAT_ID,
                    SC.COUNTY_NAME,
                    COM.COMPANY_POSTCODE,
                    SCI.CITY_NAME,
                    SCO.COUNTRY_NAME,
                    SC2.COUNTY_NAME COUNTY_NAME2,
                    SCI2.CITY_NAME CITY_NAME2,
                    SCO2.COUNTRY_NAME COUNTRY_NAME2,
                    ISNULL(IMM.IS_GROUP_INVOICE,1) IS_GROUP_INVOICE,
               <cfif arguments.temp_currency_code>
                    (SELECT ISNULL(SUM(DISCOUNTTOTAL),0) FROM INVOICE_ROW WHERE INVOICE_ROW.INVOICE_ID = I.INVOICE_ID) ROW_DISCOUNT,
                    ISNULL(I.GROSSTOTAL,0) GROSSTOTAL,
                    I.NETTOTAL,
                    ISNULL(ROUND(I.SA_DISCOUNT,2),0) SA_DISCOUNT,
                    'TRY' CURRENCY_CODE,
                    'TL' MONEY,
                    1 RATE2,
                    ISNULL(ROUND(I.STOPAJ,2),0) STOPAJ,
                    ROUND(I.TAXTOTAL,2) TAXTOTAL,
               <cfelse>
                    (SELECT ISNULL((SUM(DISCOUNTTOTAL)/IM.RATE2),0) FROM INVOICE_ROW WHERE INVOICE_ROW.INVOICE_ID = I.INVOICE_ID) ROW_DISCOUNT,        
                    (I.GROSSTOTAL/IM.RATE2) GROSSTOTAL,
                    (I.NETTOTAL/IM.RATE2) NETTOTAL,
                    ISNULL(ROUND((I.SA_DISCOUNT/IM.RATE2),2),0) SA_DISCOUNT,      
                    SM.CURRENCY_CODE,
                    SM.MONEY,
                    IM.RATE2,
                    ISNULL(ROUND(I.STOPAJ/IM.RATE2,2),0) STOPAJ,
                    ROUND(I.TAXTOTAL/IM.RATE2,2) TAXTOTAL,
               </cfif>
                    CASE WHEN COM.IS_PERSON = 1 THEN 1 ELSE 0 END AS IS_PERSON,
                    COM.COMPANY_ADDRESS,
                    CB.COMPBRANCH_ADDRESS ADDRESS2,
                    IS_IPTAL,
                    CASE
                        WHEN (I.PAY_METHOD IS NOT NULL)
                           THEN SP.PAYMENT_MEANS_CODE
                        WHEN (I.CARD_PAYMETHOD_ID IS NOT NULL)
                           THEN CPT.PAYMENT_MEANS_CODE
                        ELSE 'ZZZ'
                    END AS PAYMENT_MEANS_CODE,
                    SPC.IS_EXPORT_REGISTERED,
                    SPC.IS_EXPORT_PRODUCT
                FROM 
                  	INVOICE I
                        LEFT JOIN #this.dsn2_alias#.INVOICE_MULTI IMM ON IMM.INVOICE_MULTI_ID = I.INVOICE_MULTI_ID
                        LEFT JOIN #this.dsn2_alias#.COMPANY_REMAINDER CR ON CR.COMPANY_ID = I.COMPANY_ID
                        LEFT JOIN #this.dsn2_alias#.INVOICE_MONEY IM ON IM.ACTION_ID = I.INVOICE_ID AND IM.MONEY_TYPE = I.OTHER_MONEY
                        LEFT JOIN #this.dsn_alias#.SETUP_PAYMETHOD SP ON SP.PAYMETHOD_ID = I.PAY_METHOD
                        LEFT JOIN #this.dsn3_alias#.CREDITCARD_PAYMENT_TYPE CPT ON CPT.PAYMENT_TYPE_ID = I.CARD_PAYMETHOD_ID
                        LEFT JOIN EARCHIVE_RELATION ER ON I.INVOICE_ID = ER.ACTION_ID AND ER.ACTION_TYPE = 'INVOICE'				
                        INNER JOIN #this.dsn_alias#.COMPANY COM ON COM.COMPANY_ID = I.COMPANY_ID
                        LEFT JOIN #this.dsn_alias#.COMPANY_PARTNER CP ON CP.PARTNER_ID = COM.MANAGER_PARTNER_ID
                        LEFT JOIN #this.dsn_alias#.COMPANY_BRANCH CB ON CB.COMPBRANCH_ID = I.SHIP_ADDRESS_ID            			
                        LEFT JOIN #this.dsn_alias#.SETUP_CITY SCI ON SCI.CITY_ID = COM.CITY
                        LEFT JOIN #this.dsn_alias#.SETUP_COUNTRY SCO ON SCO.COUNTRY_ID = COM.COUNTRY
                        LEFT JOIN #this.dsn_alias#.SETUP_COUNTY SC ON SC.COUNTY_ID = COM.COUNTY
                        LEFT JOIN #this.dsn_alias#.SETUP_CITY SCI2 ON SCI2.CITY_ID = CB.CITY_ID
                        LEFT JOIN #this.dsn_alias#.SETUP_COUNTRY SCO2 ON SCO2.COUNTRY_ID = CB.COUNTRY_ID
                        LEFT JOIN #this.dsn_alias#.SETUP_COUNTY SC2 ON SC2.COUNTY_ID = CB.COUNTY_ID
                        LEFT JOIN SETUP_MONEY SM ON SM.MONEY = IM.MONEY_TYPE,
                    #this.dsn3_alias#.SETUP_PROCESS_CAT SPC 
                WHERE 
                    I.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.invoice_id#"> AND 
                    SPC.PROCESS_CAT_ID = I.PROCESS_CAT
            <cfelseif arguments.consumer_id gt 0>
                SELECT
                    I.INVOICE_ID,
                    I.INVOICE_NUMBER,
                    I.INVOICE_DATE,
                    I.COMPANY_ID,
                    I.CONSUMER_ID,
                    I.DUE_DATE,
                    I.NOTE,
                    I.INVOICE_CAT,
                    I.SHIP_METHOD,
                    I.OTHER_MONEY,
                    I.OTHER_MONEY_VALUE,
                    I.CARD_PAYMETHOD_ID,
                    I.PAY_METHOD,
                    I.SERIAL_NUMBER,
                    I.SHIP_ADDRESS_ID,
                    I.BANK_ID,
                <cfif arguments.temp_currency_code>
                    ISNULL((SELECT ISNULL(SUM(DISCOUNTTOTAL),0) FROM INVOICE_ROW WHERE INVOICE_ROW.INVOICE_ID = I.INVOICE_ID),0) ROW_DISCOUNT,
                    ISNULL(I.GROSSTOTAL,0) GROSSTOTAL,
                    I.NETTOTAL,
                    ISNULL(ROUND(I.SA_DISCOUNT,2),0) SA_DISCOUNT,
                    'TRY' CURRENCY_CODE,
                    'TL' MONEY,
                    1 RATE2,
                    ISNULL(ROUND(I.STOPAJ,2),0) STOPAJ,
                    ROUND(I.TAXTOTAL,2) TAXTOTAL,
                <cfelse>
                    ISNULL((SELECT ISNULL((SUM(DISCOUNTTOTAL)/IM.RATE2),0) FROM INVOICE_ROW WHERE INVOICE_ROW.INVOICE_ID = I.INVOICE_ID),0) ROW_DISCOUNT,
                    ISNULL((I.GROSSTOTAL/IM.RATE2),0) GROSSTOTAL,
                    (I.NETTOTAL/IM.RATE2) NETTOTAL,
                    ISNULL(ROUND((I.SA_DISCOUNT/IM.RATE2),2),0) SA_DISCOUNT,
                    SM.CURRENCY_CODE,
                    SM.MONEY,
                    IM.RATE2,
                    ISNULL(ROUND(I.STOPAJ/IM.RATE2,2),0) STOPAJ,
                    ROUND(I.TAXTOTAL/IM.RATE2,2) TAXTOTAL,
                </cfif> 
                    COM.MEMBER_CODE MEMBER_CODE, 
                    COM.CONSUMER_NAME+' '+COM.CONSUMER_SURNAME FULLNAME, 
                    CASE WHEN USE_EARCHIVE = 1 THEN COM.CONSUMER_EMAIL ELSE '' END COMPANY_EMAIL,
                    COM.CONSUMER_HOMETELCODE COMPANY_TELCODE,
                    COM.CONSUMER_HOMETEL COMPANY_TEL,
                    COM.CONSUMER_FAX COMPANY_FAX,
                    COM.TC_IDENTY_NO TAXNO,
                    COM.TAX_POSTCODE COMPANY_POSTCODE,
                    COM.TAX_ADRESS COMPANY_ADDRESS,
                    COM.CONSUMER_NAME COMPANY_PARTNER_NAME,
                    COM.CONSUMER_SURNAME COMPANY_PARTNER_SURNAME,
                    COM.EARCHIVE_SENDING_TYPE,
                    SP.PAYMETHOD,
                    CR.BAKIYE,
                    '' COMPBRANCH_CODE,
                    '' COMPBRANCH_ALIAS,
                    CB.CONTACT_NAME COMPBRANCH__NAME,
                    CB.CONTACT_ADDRESS ADDRESS2,
                    CB.CONTACT_POSTCODE COMPANY_POSTCODE2,
                    ER.EARCHIVE_ID,
                    SPC.INVOICE_TYPE_CODE,
                    SPC.PROCESS_CAT_ID,
                    CASE WHEN SPC.IS_PARTNER = 1 OR SPC.IS_PUBLIC = 1 THEN 1 ELSE 0 END IS_INTERNET,
                    ROUND(I.GROSSTOTAL+I.TAXTOTAL,2) TAXINCLUSIVEAMOUNT,
                    SC.COUNTY_NAME,
                    '' TAXOFFICE,
                    SCI.CITY_NAME,
                    SCO.COUNTRY_NAME,
                    SC2.COUNTY_NAME COUNTY_NAME2,
                    SCI2.CITY_NAME CITY_NAME2,
                    SCO2.COUNTRY_NAME COUNTRY_NAME2,
                    ISNULL(IMM.IS_GROUP_INVOICE,1) IS_GROUP_INVOICE,
                    1 IS_PERSON,
                    '' BUILDING_NUMBER,
                    IS_IPTAL,
                    CASE
                        WHEN (I.PAY_METHOD IS NOT NULL)
                           THEN SP.PAYMENT_MEANS_CODE
                        WHEN (I.CARD_PAYMETHOD_ID IS NOT NULL)
                           THEN CPT.PAYMENT_MEANS_CODE
                        ELSE 'ZZZ'
                    END AS PAYMENT_MEANS_CODE,
                    SPC.IS_EXPORT_REGISTERED
                FROM 
                    INVOICE I
                        LEFT JOIN #this.dsn2_alias#.INVOICE_MULTI IMM ON IMM.INVOICE_MULTI_ID = I.INVOICE_MULTI_ID
                        LEFT JOIN #this.dsn2_alias#.CONSUMER_REMAINDER CR ON CR.CONSUMER_ID = I.CONSUMER_ID
                        LEFT JOIN #this.dsn2_alias#.INVOICE_MONEY IM ON IM.ACTION_ID = I.INVOICE_ID AND IM.MONEY_TYPE = I.OTHER_MONEY
                        LEFT JOIN #this.dsn_alias#.SETUP_PAYMETHOD SP ON SP.PAYMETHOD_ID = I.PAY_METHOD
                        LEFT JOIN #this.dsn3_alias#.CREDITCARD_PAYMENT_TYPE CPT ON CPT.PAYMENT_TYPE_ID = I.CARD_PAYMETHOD_ID
                        LEFT JOIN EARCHIVE_RELATION ER ON I.INVOICE_ID = ER.ACTION_ID AND ER.ACTION_TYPE = 'INVOICE'				
                        INNER JOIN #this.dsn_alias#.CONSUMER COM ON COM.CONSUMER_ID = I.CONSUMER_ID
                        LEFT JOIN #this.dsn_alias#.CONSUMER_BRANCH CB ON CB.CONTACT_ID = I.SHIP_ADDRESS_ID
                        LEFT JOIN #this.dsn_alias#.SETUP_CITY SCI ON COM.TAX_CITY_ID = SCI.CITY_ID
                        LEFT JOIN #this.dsn_alias#.SETUP_COUNTRY SCO ON  COM.TAX_COUNTRY_ID = SCO.COUNTRY_ID
                        LEFT JOIN #this.dsn_alias#.SETUP_COUNTY SC ON COM.TAX_COUNTY_ID = SC.COUNTY_ID
                        LEFT JOIN #this.dsn_alias#.SETUP_CITY SCI2 ON SCI2.CITY_ID = CB.CONTACT_CITY_ID
                        LEFT JOIN #this.dsn_alias#.SETUP_COUNTRY SCO2 ON SCO2.COUNTRY_ID = CB.CONTACT_COUNTRY_ID
                        LEFT JOIN #this.dsn_alias#.SETUP_COUNTY SC2 ON SC2.COUNTY_ID = CB.CONTACT_COUNTY_ID
                        LEFT JOIN SETUP_MONEY SM ON SM.MONEY = IM.MONEY_TYPE,
                    #this.dsn3_alias#.SETUP_PROCESS_CAT SPC 
                WHERE 
                    I.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.invoice_id#"> AND 
                    SPC.PROCESS_CAT_ID = I.PROCESS_CAT
           	<cfelseif arguments.employee_id gt 0>
                SELECT 
                    I.INVOICE_ID,
                    I.INVOICE_NUMBER,
                    I.INVOICE_DATE,
                    I.COMPANY_ID,
                    I.CONSUMER_ID,
                    I.DUE_DATE,
                    I.OTHER_MONEY,
                    I.OTHER_MONEY_VALUE,
                    I.PAY_METHOD,
                    I.NOTE,
                    I.INVOICE_CAT,
                    I.SHIP_METHOD,
                    I.SERIAL_NUMBER,
                    I.BANK_ID,
               <cfif arguments.temp_currency_code>
                    ISNULL((SELECT ISNULL(SUM(DISCOUNTTOTAL),0) FROM INVOICE_ROW WHERE INVOICE_ROW.INVOICE_ID = I.INVOICE_ID),0) ROW_DISCOUNT,
                    ISNULL(I.GROSSTOTAL,0) GROSSTOTAL,
                    I.NETTOTAL,
                    ISNULL(ROUND(I.SA_DISCOUNT,2),0) SA_DISCOUNT,
                    'TRY' CURRENCY_CODE,
                    'TL' MONEY,
                    1 RATE2,
                    ISNULL(ROUND(I.STOPAJ,2),0) STOPAJ,
                    ROUND(I.TAXTOTAL,2) TAXTOTAL,
               <cfelse>
                    ISNULL((SELECT ISNULL((SUM(DISCOUNTTOTAL)/IM.RATE2),0) FROM INVOICE_ROW WHERE INVOICE_ROW.INVOICE_ID = I.INVOICE_ID),0) ROW_DISCOUNT,
                    ISNULL((I.GROSSTOTAL/IM.RATE2),0) GROSSTOTAL,
                    (I.NETTOTAL/IM.RATE2) NETTOTAL,
                    ISNULL(ROUND((I.SA_DISCOUNT/IM.RATE2),2),0) SA_DISCOUNT,
                    SM.CURRENCY_CODE,
                    SM.MONEY,
                    IM.RATE2,
                    ISNULL(ROUND(I.STOPAJ/IM.RATE2,2),0) STOPAJ,
                    ROUND(I.TAXTOTAL/IM.RATE2,2) TAXTOTAL,
               </cfif>
                    COM.MEMBER_CODE MEMBER_CODE,
                    COM.EMPLOYEE_NAME+' '+COM.EMPLOYEE_SURNAME FULLNAME,
                    COM.EMPLOYEE_EMAIL COMPANY_EMAIL,
                    COM.EMPLOYEE_NAME COMPANY_PARTNER_NAME,
                    COM.EMPLOYEE_SURNAME COMPANY_PARTNER_SURNAME,
                    COM.EARCHIVE_SENDING_TYPE,
                    '' COMPBRANCH_CODE,
                    '' COMPBRANCH_ALIAS,
                    '' TAXOFFICE,
                    SP.PAYMETHOD,
                    ROUND(I.GROSSTOTAL+I.TAXTOTAL,2) TAXINCLUSIVEAMOUNT,
                    CR.BAKIYE,
                    ER.EARCHIVE_ID,
                    SPC.INVOICE_TYPE_CODE,
                    SPC.PROCESS_CAT_ID,
                    CASE WHEN SPC.IS_PARTNER = 1 OR SPC.IS_PUBLIC = 1 THEN 1 ELSE 0 END IS_INTERNET,
                    '#GET_COMP_INFO.TEL_CODE#' COMPANY_TELCODE,
                    '#GET_COMP_INFO.TEL#' COMPANY_TEL,
                    '#GET_COMP_INFO.FAX#' COMPANY_FAX,
                    '#GET_COMP_INFO.COUNTY_NAME#' COUNTY_NAME,
                    EI.TC_IDENTY_NO TAXNO,
                    '#GET_COMP_INFO.POSTAL_CODE#' COMPANY_POSTCODE,
                    '#GET_COMP_INFO.CITY_NAME#' CITY_NAME,
                    '#GET_COMP_INFO.COUNTRY_NAME#' COUNTRY_NAME,
                    1 IS_GROUP_INVOICE,
                    1 IS_PERSON,
                    '#GET_COMP_INFO.ADDRESS#' COMPANY_ADDRESS,
                    '#GET_COMP_INFO.BUILDING_NUMBER#' BUILDING_NUMBER,
                    IS_IPTAL,
                    CASE
                        WHEN (I.PAY_METHOD IS NOT NULL)
                           THEN SP.PAYMENT_MEANS_CODE
                        WHEN (I.CARD_PAYMETHOD_ID IS NOT NULL)
                           THEN CPT.PAYMENT_MEANS_CODE
                        ELSE 'ZZZ'
                    END AS PAYMENT_MEANS_CODE,
                    SPC.IS_EXPORT_REGISTERED
                FROM 
                    INVOICE I
                        LEFT JOIN #this.dsn2_alias#.INVOICE_MULTI IMM ON IMM.INVOICE_MULTI_ID = I.INVOICE_MULTI_ID
                        LEFT JOIN #this.dsn2_alias#.EMPLOYEE_REMAINDER CR ON CR.EMPLOYEE_ID = I.EMPLOYEE_ID
                        LEFT JOIN #this.dsn2_alias#.INVOICE_MONEY IM ON IM.ACTION_ID = I.INVOICE_ID AND IM.MONEY_TYPE = I.OTHER_MONEY
                        LEFT JOIN #this.dsn_alias#.SETUP_PAYMETHOD SP ON SP.PAYMETHOD_ID = I.PAY_METHOD
                        LEFT JOIN #this.dsn3_alias#.CREDITCARD_PAYMENT_TYPE CPT ON CPT.PAYMENT_TYPE_ID = I.CARD_PAYMETHOD_ID
                        LEFT JOIN EARCHIVE_RELATION ER ON I.INVOICE_ID = ER.ACTION_ID AND ER.ACTION_TYPE = 'INVOICE'				
                        INNER JOIN #this.dsn_alias#.EMPLOYEES COM ON COM.EMPLOYEE_ID = I.EMPLOYEE_ID
                        LEFT JOIN #this.dsn_alias#.EMPLOYEES_IDENTY EI ON EI.EMPLOYEE_ID = COM.EMPLOYEE_ID
                        LEFT JOIN SETUP_MONEY SM ON SM.MONEY = IM.MONEY_TYPE,
                    #this.dsn3_alias#.SETUP_PROCESS_CAT SPC 
                WHERE 
                    I.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.invoice_id#"> AND 
                    SPC.PROCESS_CAT_ID = I.PROCESS_CAT
            	</cfif>
            </cfquery>
        <cfelse>
            <cfquery name="GET_INVOICE" datasource="#this.dsn2#">
                <cfif arguments.company_id gt 0>
                    SELECT
                        I.EXPENSE_ID INVOICE_ID,
                        I.PAPER_NO INVOICE_NUMBER,
                        I.EXPENSE_DATE INVOICE_DATE,
                        I.CH_COMPANY_ID COMPANY_ID,
                        I.CH_CONSUMER_ID CONSUMER_ID,
                        I.EXPENSE_DATE DUE_DATE,
                        I.DETAIL NOTE,
                        I.TOTAL_AMOUNT,
                        '' SHIP_METHOD,
                        I.SERIAL_NUMBER,
                        I.SHIP_ADDRESS_ID,
                        '' BANK_ID,
                        '' INVOICE_CAT,
                        I.IS_IPTAL,
                    <cfif temp_currency_code>
                        I.TOTAL_AMOUNT GROSSTOTAL,
                        I.TOTAL_AMOUNT_KDVLI NETTOTAL,
                        0 SA_DISCOUNT,
                        'TRY' CURRENCY_CODE,
                        'TL' MONEY,
                        1 RATE2,
                        ROUND(I.KDV_TOTAL,2) TAXTOTAL,
                        ISNULL(ROUND(I.STOPAJ,2),0) STOPAJ,
                    <cfelse>
                        (I.TOTAL_AMOUNT/IM.RATE2) GROSSTOTAL,
                        (I.TOTAL_AMOUNT_KDVLI/IM.RATE2) NETTOTAL,
                        0 SA_DISCOUNT,
                        SM.CURRENCY_CODE,
                        SM.MONEY,
                        IM.RATE2,
                        ROUND(I.KDV_TOTAL/IM.RATE2,2) TAXTOTAL,
                        ISNULL(ROUND(I.STOPAJ/IM.RATE2,2),0) STOPAJ,
                    </cfif>
                        ROUND(I.TOTAL_AMOUNT+I.KDV_TOTAL,2) TAXINCLUSIVEAMOUNT,
                        CB.COMPBRANCH__NAME,
                        CB.COMPBRANCH_CODE,
                        CB.COMPBRANCH_ALIAS,
                        CB.COMPBRANCH_POSTCODE COMPANY_POSTCODE2,
                        CB.COMPBRANCH_ADDRESS ADDRESS2,
                        CP.COMPANY_PARTNER_NAME,
                        CP.COMPANY_PARTNER_SURNAME,
                        ER.EARCHIVE_ID,
                        SPC.INVOICE_TYPE_CODE,
                        SPC.PROCESS_CAT_ID,
                        CASE WHEN SPC.IS_PARTNER = 1 OR SPC.IS_PUBLIC = 1 THEN 1 ELSE 0 END IS_INTERNET,
                        COM.MEMBER_CODE,
                        COM.FULLNAME,
                        COM.COMPANY_TELCODE,
                        COM.COMPANY_TEL1 COMPANY_TEL,
                        COM.COMPANY_FAX,
                        COM.TAXOFFICE,
                        CASE WHEN COM.IS_PERSON = 1 THEN CP.TC_IDENTITY ELSE COM.TAXNO END AS TAXNO,
                        COM.COMPANY_POSTCODE,
                        COM.EARCHIVE_SENDING_TYPE,
                        SP.PAYMETHOD,
                        '' CARD_PAYMETHOD_ID,
                        0 ROW_DISCOUNT,
                         CR.BAKIYE,
                        CASE WHEN USE_EARCHIVE = 1 THEN COM.COMPANY_EMAIL ELSE '' END AS COMPANY_EMAIL,
                        SCI.CITY_NAME,
                        SCO.COUNTRY_NAME,
                        SC.COUNTY_NAME,
                        SC2.COUNTY_NAME COUNTY_NAME2,
                        SCI2.CITY_NAME CITY_NAME2,
                        SCO2.COUNTRY_NAME COUNTRY_NAME2,
                        '' BUILDING_NUMBER,
                        CASE WHEN CB.COMPBRANCH_ID IS NULL THEN COM.COMPANY_ADDRESS ELSE CB.COMPBRANCH_ADDRESS END COMPANY_ADDRESS,
                        CASE WHEN COM.IS_PERSON = 1 THEN 1 ELSE 0 END AS IS_PERSON,
                        CASE
                            WHEN (I.PAYMETHOD_ID IS NOT NULL)
                            THEN SP.PAYMENT_MEANS_CODE
                            ELSE 'ZZZ'
                        END AS PAYMENT_MEANS_CODE,
                        SPC.IS_EXPORT_REGISTERED
                    FROM 
                        EXPENSE_ITEM_PLANS I
                            LEFT JOIN #this.dsn2_alias#.COMPANY_REMAINDER CR ON CR.COMPANY_ID = I.CH_COMPANY_ID
                            LEFT JOIN EARCHIVE_RELATION ER ON I.EXPENSE_ID = ER.ACTION_ID AND ER.ACTION_TYPE = 'EXPENSE_ITEM_PLANS'
                            INNER JOIN #this.dsn_alias#.COMPANY COM ON COM.COMPANY_ID = I.CH_COMPANY_ID
                            LEFT JOIN #this.dsn_alias#.COMPANY_PARTNER CP ON CP.PARTNER_ID = COM.MANAGER_PARTNER_ID
                            LEFT JOIN #this.dsn_alias#.COMPANY_BRANCH CB ON CB.COMPBRANCH_ID = I.SHIP_ADDRESS_ID                
                            LEFT JOIN #this.dsn_alias#.SETUP_CITY SCI ON SCI.CITY_ID = (CASE WHEN CB.COMPBRANCH_ID IS NULL THEN COM.CITY ELSE CB.CITY_ID END)
                            LEFT JOIN #this.dsn_alias#.SETUP_COUNTRY SCO ON SCO.COUNTRY_ID = (CASE WHEN CB.COMPBRANCH_ID IS NULL THEN COM.COUNTRY ELSE CB.COUNTRY_ID END) 
                            LEFT JOIN #this.dsn_alias#.SETUP_COUNTY SC ON SC.COUNTY_ID = (CASE WHEN CB.COMPBRANCH_ID IS NULL THEN COM.COUNTY ELSE CB.COUNTY_ID END)
                            LEFT JOIN #this.dsn_alias#.SETUP_CITY SCI2 ON SCI2.CITY_ID = CB.CITY_ID
                            LEFT JOIN #this.dsn_alias#.SETUP_COUNTRY SCO2 ON SCO2.COUNTRY_ID = CB.COUNTRY_ID
                            LEFT JOIN #this.dsn_alias#.SETUP_COUNTY SC2 ON SC2.COUNTY_ID = CB.COUNTY_ID
                            LEFT JOIN #this.dsn_alias#.SETUP_PAYMETHOD SP ON SP.PAYMETHOD_ID = I.PAYMETHOD_ID
                            LEFT JOIN EXPENSE_ITEM_PLANS_MONEY IM ON IM.ACTION_ID = I.EXPENSE_ID AND IM.IS_SELECTED = 1
                            LEFT JOIN SETUP_MONEY SM ON SM.MONEY = IM.MONEY_TYPE,
                        #this.dsn3_alias#.SETUP_PROCESS_CAT SPC 
                    WHERE 
                        I.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.invoice_id#"> AND 
                        SPC.PROCESS_CAT_ID = I.PROCESS_CAT
                <cfelseif arguments.consumer_id gt 0>
                    SELECT
                        I.EXPENSE_ID INVOICE_ID,
                        I.PAPER_NO INVOICE_NUMBER,
                        I.EXPENSE_DATE INVOICE_DATE,
                        I.CH_COMPANY_ID COMPANY_ID,
                        I.CH_CONSUMER_ID CONSUMER_ID,
                        I.EXPENSE_DATE DUE_DATE,
                        I.DETAIL NOTE,
                        I.TOTAL_AMOUNT,
                        I.SERIAL_NUMBER,
                        I.SHIP_ADDRESS_ID,
                        '' BANK_ID,
                        '' INVOICE_CAT,
                        I.IS_IPTAL,
                    <cfif temp_currency_code>
                        I.TOTAL_AMOUNT GROSSTOTAL,
                        I.TOTAL_AMOUNT_KDVLI NETTOTAL,
                        0 SA_DISCOUNT,
                        'TRY' CURRENCY_CODE,
                        'TL' MONEY,
                        1 RATE2,
                        ROUND(I.KDV_TOTAL,2) TAXTOTAL,
                        ISNULL(ROUND(I.STOPAJ,2),0) STOPAJ,
                    <cfelse>
                        (I.TOTAL_AMOUNT/IM.RATE2) GROSSTOTAL,
                        (I.TOTAL_AMOUNT_KDVLI/IM.RATE2) NETTOTAL,
                        0 SA_DISCOUNT,
                        SM.CURRENCY_CODE,
                        SM.MONEY,
                        IM.RATE2,
                        ROUND(I.KDV_TOTAL/IM.RATE2,2) TAXTOTAL,
                        ISNULL(ROUND(I.STOPAJ/IM.RATE2,2),0) STOPAJ,
                    </cfif> 	
                        '' COMPBRANCH_CODE,
                        '' COMPBRANCH_ALIAS,
                        CB.CONTACT_NAME COMPBRANCH__NAME,
                        CB.CONTACT_ADDRESS ADDRESS2,
                        CB.CONTACT_POSTCODE COMPANY_POSTCODE2,
                        COM.MEMBER_CODE,
                        COM.CONSUMER_NAME+' '+COM.CONSUMER_SURNAME FULLNAME,
                        COM.CONSUMER_HOMETELCODE COMPANY_TELCODE,
                        COM.CONSUMER_HOMETEL COMPANY_TEL,
                        COM.CONSUMER_FAX COMPANY_FAX,
                        COM.TC_IDENTY_NO TAXNO,
                        COM.TAX_POSTCODE COMPANY_POSTCODE,
                        COM.CONSUMER_NAME COMPANY_PARTNER_NAME,
                        COM.CONSUMER_SURNAME COMPANY_PARTNER_SURNAME,
                        COM.TAX_ADRESS COMPANY_ADDRESS,
                        COM.EARCHIVE_SENDING_TYPE,
                        '' TAXOFFICE,
                        SP.PAYMETHOD,
                        '' BUILDING_NUMBER,
                        CR.BAKIYE,
                        '' CARD_PAYMETHOD_ID,
                        SPC.INVOICE_TYPE_CODE,
                        SPC.PROCESS_CAT_ID,
                        CASE WHEN SPC.IS_PARTNER = 1 OR SPC.IS_PUBLIC = 1 THEN 1 ELSE 0 END IS_INTERNET,
                        ROUND(I.TOTAL_AMOUNT+I.KDV_TOTAL,2) TAXINCLUSIVEAMOUNT,
                        CASE WHEN USE_EARCHIVE = 1 THEN COM.CONSUMER_EMAIL ELSE '' END AS COMPANY_EMAIL,
                        SCI.CITY_NAME,
                        SCO.COUNTRY_NAME,
                        SC.COUNTY_NAME,
                        SC2.COUNTY_NAME COUNTY_NAME2,
                        SCI2.CITY_NAME CITY_NAME2,
                        SCO2.COUNTRY_NAME COUNTRY_NAME2,
                        0 ROW_DISCOUNT,
                        ER.EARCHIVE_ID,
                        1 IS_PERSON,
                        CASE
                            WHEN (I.PAYMETHOD_ID IS NOT NULL)
                               THEN SP.PAYMENT_MEANS_CODE
                            ELSE 'ZZZ'
                        END AS PAYMENT_MEANS_CODE,
                        SPC.IS_EXPORT_REGISTERED
                    FROM 
                        EXPENSE_ITEM_PLANS I
                            LEFT JOIN #this.dsn2_alias#.CONSUMER_REMAINDER CR ON CR.CONSUMER_ID = I.CH_CONSUMER_ID
                            LEFT JOIN EARCHIVE_RELATION ER ON I.EXPENSE_ID = ER.ACTION_ID AND ER.ACTION_TYPE = 'EXPENSE_ITEM_PLANS'				
                            INNER JOIN #this.dsn_alias#.CONSUMER COM ON COM.CONSUMER_ID = I.CH_CONSUMER_ID
                            LEFT JOIN #this.dsn_alias#.CONSUMER_BRANCH CB ON CB.CONTACT_ID = I.SHIP_ADDRESS_ID
                            LEFT JOIN #this.dsn_alias#.SETUP_CITY SCI ON SCI.CITY_ID = TAX_CITY_ID
                            LEFT JOIN #this.dsn_alias#.SETUP_COUNTRY SCO ON SCO.COUNTRY_ID = COM.TAX_COUNTRY_ID
                            LEFT JOIN #this.dsn_alias#.SETUP_COUNTY SC ON SC.COUNTY_ID = COM.TAX_COUNTY_ID
                            LEFT JOIN #this.dsn_alias#.SETUP_CITY SCI2 ON SCI2.CITY_ID = CB.CONTACT_CITY_ID
                            LEFT JOIN #this.dsn_alias#.SETUP_COUNTRY SCO2 ON SCO2.COUNTRY_ID = CB.CONTACT_COUNTRY_ID
                            LEFT JOIN #this.dsn_alias#.SETUP_COUNTY SC2 ON SC2.COUNTY_ID = CB.CONTACT_COUNTY_ID
                            LEFT JOIN #this.dsn_alias#.SETUP_PAYMETHOD SP ON SP.PAYMETHOD_ID = I.PAYMETHOD_ID
                            LEFT JOIN EXPENSE_ITEM_PLANS_MONEY IM ON IM.ACTION_ID = I.EXPENSE_ID AND IM.IS_SELECTED = 1
                            LEFT JOIN SETUP_MONEY SM ON SM.MONEY = IM.MONEY_TYPE,
                        #this.dsn3_alias#.SETUP_PROCESS_CAT SPC 
                    WHERE 
                        I.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.invoice_id#"> AND 
                        SPC.PROCESS_CAT_ID = I.PROCESS_CAT
              	<cfelseif arguments.employee_id gt 0>
                    SELECT
                        I.EXPENSE_ID INVOICE_ID,
                        I.PAPER_NO INVOICE_NUMBER,
                        I.EXPENSE_DATE INVOICE_DATE,
                        I.CH_COMPANY_ID COMPANY_ID,
                        I.CH_CONSUMER_ID CONSUMER_ID,
                        I.EXPENSE_DATE DUE_DATE,
                        I.DETAIL NOTE,
                        I.TOTAL_AMOUNT,
                        I.SERIAL_NUMBER,
                        I.IS_IPTAL,
                        '' BANK_ID,
                        '' INVOICE_CAT,
                   <cfif temp_currency_code>
                        I.TOTAL_AMOUNT GROSSTOTAL,
                        I.TOTAL_AMOUNT_KDVLI NETTOTAL,
                        0 SA_DISCOUNT,
                        'TRY' CURRENCY_CODE,
                        'TL' MONEY,
                        1 RATE2,
                        ROUND(I.KDV_TOTAL,2) TAXTOTAL, 
                        ISNULL(ROUND(I.STOPAJ,2),0) STOPAJ,
                   <cfelse>
                        (I.TOTAL_AMOUNT/IM.RATE2) GROSSTOTAL,
                        (I.TOTAL_AMOUNT_KDVLI/IM.RATE2) NETTOTAL,
                        0 SA_DISCOUNT,
                        SM.CURRENCY_CODE,
                        SM.MONEY,
                        IM.RATE2,
                        ROUND(I.KDV_TOTAL/IM.RATE2,2) TAXTOTAL, 
                        ISNULL(ROUND(I.STOPAJ/IM.RATE2,2),0) STOPAJ,
                   </cfif>
                        '' COMPBRANCH_CODE,
                        '' COMPBRANCH_ALIAS,
                        COM.MEMBER_CODE,
                        COM.EMPLOYEE_NAME+' '+COM.EMPLOYEE_SURNAME FULLNAME,
                        COM.EMPLOYEE_EMAIL COMPANY_EMAIL,
                        COM.EMPLOYEE_NAME COMPANY_PARTNER_NAME,
                        COM.EMPLOYEE_SURNAME COMPANY_PARTNER_SURNAME,
                        COM.EARCHIVE_SENDING_TYPE,
                        '' PAYMETHOD,
                        '' PAY_METHOD,
                        CR.BAKIYE,
                        '' CARD_PAYMETHOD_ID,
                        SPC.INVOICE_TYPE_CODE,
                        SPC.PROCESS_CAT_ID,
                        ROUND(I.TOTAL_AMOUNT+I.KDV_TOTAL,2) TAXINCLUSIVEAMOUNT,
                        '#GET_COMP_INFO.TEL_CODE#' COMPANY_TELCODE,
                        '#GET_COMP_INFO.TEL#' COMPANY_TEL,
                        '#GET_COMP_INFO.FAX#' COMPANY_FAX,
                        '' TAXOFFICE,
                        EI.TC_IDENTY_NO TAXNO,
                        '#GET_COMP_INFO.POSTAL_CODE#' COMPANY_POSTCODE,
                        '#GET_COMP_INFO.CITY_NAME#' CITY_NAME,
                        '#GET_COMP_INFO.COUNTRY_NAME#' COUNTRY_NAME,
                        '#GET_COMP_INFO.COUNTY_NAME#' COUNTY_NAME,
                        0 ROW_DISCOUNT,
                        CASE WHEN SPC.IS_PARTNER = 1 OR SPC.IS_PUBLIC = 1 THEN 1 ELSE 0 END IS_INTERNET,
                        ER.EARCHIVE_ID,
                        '#GET_COMP_INFO.BUILDING_NUMBER#' BUILDING_NUMBER,
                        '#GET_COMP_INFO.ADDRESS#' COMPANY_ADDRESS,
                        1 IS_PERSON,
                        CASE
                            WHEN (I.PAYMETHOD_ID IS NOT NULL)
                               THEN SP.PAYMENT_MEANS_CODE
                            ELSE 'ZZZ'
                        END AS PAYMENT_MEANS_CODE,
                        SPC.IS_EXPORT_REGISTERED
                    FROM 
                        EXPENSE_ITEM_PLANS I
                            LEFT JOIN #this.dsn2_alias#.EMPLOYEE_REMAINDER CR ON CR.EMPLOYEE_ID = I.CH_EMPLOYEE_ID AND CR.ACC_TYPE_ID = I.ACC_TYPE_ID
                            LEFT JOIN EARCHIVE_RELATION ER ON I.EXPENSE_ID = ER.ACTION_ID AND ER.ACTION_TYPE = 'EXPENSE_ITEM_PLANS'				
                            INNER JOIN #this.dsn_alias#.EMPLOYEES COM ON COM.EMPLOYEE_ID = I.CH_EMPLOYEE_ID
                            LEFT JOIN #this.dsn_alias#.EMPLOYEES_IDENTY EI ON EI.EMPLOYEE_ID = COM.EMPLOYEE_ID
                            LEFT JOIN #this.dsn_alias#.SETUP_PAYMETHOD SP ON SP.PAYMETHOD_ID = I.PAYMETHOD_ID
                            LEFT JOIN EXPENSE_ITEM_PLANS_MONEY IM ON IM.ACTION_ID = I.EXPENSE_ID AND IM.IS_SELECTED = 1
                            LEFT JOIN SETUP_MONEY SM ON SM.MONEY = IM.MONEY_TYPE,
                        #this.dsn3_alias#.SETUP_PROCESS_CAT SPC 
                    WHERE 
                        I.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.invoice_id#"> AND 
                        SPC.PROCESS_CAT_ID = I.PROCESS_CAT
                </cfif>
            </cfquery>
        </cfif>
        <cfreturn get_invoice>
    </cffunction>
    
    <cffunction name="add_earchive_sending_detail" access="public" returntype="any">
    	<cfargument name="zip_file_name" type="string" required="no">
        <cfargument name="service_result" type="string" required="no">
        <cfargument name="uuid" type="string" required="no">
        <cfargument name="earchive_id" type="string" required="no">
        <cfargument name="status_description" type="string" required="no">
        <cfargument name="service_result_description" type="string" required="no">
        <cfargument name="status_code" type="string" required="no">
        <cfargument name="error_code" type="string" required="no">
        <cfargument name="output_type" type="string" required="no">
        <cfargument name="action_id" type="numeric" required="no">
        <cfargument name="action_type" type="string" required="no">
        <cfargument name="earchive_sending_type" type="string" required="no">
        <cfargument name="invoice_type_code" type="string" required="no">
        
    	<cfquery name="INS_EARCHIVE" datasource="#this.dsn2#">
                INSERT INTO
                    EARCHIVE_SENDING_DETAIL
                (
                    <cfif isdefined("arguments.zip_file_name")>ZIP_FILE_NAME,</cfif>
                    SERVICE_RESULT,
                    <cfif isdefined("arguments.uuid")>UUID,</cfif>
                    EARCHIVE_ID,
                    STATUS_DESCRIPTION,
                    SERVICE_RESULT_DESCRIPTION,
                    <cfif isdefined("arguments.status_code")>STATUS_CODE,</cfif>
                    ERROR_CODE,
                    ACTION_ID,
                    ACTION_TYPE,
                    <cfif isDefined("arguments.output_type")>OUTPUT_TYPE,</cfif>
                    EARCHIVE_SENDING_TYPE,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP,
                    INVOICE_TYPE_CODE
                )
                VALUES
                (
                    <cfif isdefined("arguments.zip_file_name")><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.zip_file_name#">,</cfif>
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.service_result#">,
                    <cfif isdefined("arguments.uuid")><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.uuid#">,</cfif>
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.earchive_id#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.status_description#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.service_result_description#">,
                    <cfif isdefined("arguments.status_code")><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.status_code#">,</cfif>
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.error_code#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_type#">,
                    <cfif isdefined("arguments.output_type")><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.output_type#">,</cfif>
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.earchive_sending_type#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.invoice_type_code#">
                )
           </cfquery> 
    </cffunction>
    
    <cffunction name="add_earchive_relation" access="public" returntype="any">
    	<cfargument name="status_description" type="string" required="no">
        <cfargument name="uuid" type="string" required="no">
        <cfargument name="integration_id" type="string" required="no">
        <cfargument name="earchive_id" type="string" required="no">
        <cfargument name="action_id" type="numeric" required="no">
        <cfargument name="action_type" type="string" required="no">
    	<cfargument name="path" type="string" required="no">
        <cfargument name="sender_type" type="string" required="no">
        <cfargument name="earchive_sending_type" type="numeric" required="no">
        <cfargument name="is_internet" type="numeric" required="no">
        
        <cfquery name="INS_EARCHIVE" datasource="#this.dsn2#">
            INSERT INTO
                EARCHIVE_RELATION
            (
                STATUS_DESCRIPTION,
                UUID,
                INTEGRATION_ID,
                EARCHIVE_ID,
                ACTION_ID,
                ACTION_TYPE,
                PATH,
                SENDER_TYPE,
                EARCHIVE_SENDING_TYPE,
                IS_INTERNET,
                STATUS,
                RECORD_DATE,
                RECORD_EMP,
                RECORD_IP
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.status_description#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.uuid#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.integration_id#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.earchive_id#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_type#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.path#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sender_type#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.earchive_sending_type#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_internet#">,
                <cfif arguments.sender_type eq 3>NULL,<cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="1">,</cfif>
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.userid#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
            )
        </cfquery>
    </cffunction>
    
    <cffunction name="upd_earchive_relation" access="public" returntype="any">
        <cfargument name="uuid" type="string" required="no">
        <cfargument name="integration_id" type="string" required="no">
        <cfargument name="earchive_id" type="string" required="no">
        <cfargument name="action_id" type="numeric" required="no">
        <cfargument name="action_type" type="string" required="no">
    	<cfargument name="path" type="string" required="no">
        <cfargument name="sender_type" type="string" required="no">
        <cfargument name="is_internet" type="numeric" required="no">
        
    	<cfquery name="UPD_EARCHIVE" datasource="#this.dsn2#">
            UPDATE 
                EARCHIVE_RELATION 
            SET    
                UUID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.uuid#">,
                INTEGRATION_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.integration_id#">,
                EARCHIVE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.earchive_id#">,
                ACTION_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">,
                ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_type#">,
                PATH = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.path#">,
                SENDER_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sender_type#">,
                RECORD_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.userid#">,
                RECORD_IP =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                IS_INTERNET = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_invoice.is_internet#">,
                STATUS = NULL,
                STATUS_CODE = NULL,
                STATUS_DESCRIPTION = NULL                                                   
            WHERE 
                RELATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_earchive_relation.relation_id#">
        </cfquery>
    </cffunction>

    <cffunction name="get_earchive_relation" access="public" returntype="any">
        <cfquery name="get_earchive_relation" datasource="#this.dsn2#">
            SELECT UUID,EARCHIVE_ID,STATUS,STATUS_CODE,STATUS_DESCRIPTION,INTEGRATION_ID
                FROM EARCHIVE_RELATION 
                WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> AND 
                    ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_type#"> 
                ORDER BY RECORD_DATE DESC
        </cfquery>
        <cfreturn get_earchive_relation>
    </cffunction>

    <cffunction name="get_pdf" access="remote">
        <cfset upload_folder = application.systemParam.systemParam().upload_folder>   
        <cfset dir_seperator = application.systemParam.systemParam().dir_seperator />

        <cffile action="read" file="#arguments.path#/#arguments.earchive_id#.xml" variable="inv_xml_data" charset="utf-8" mode="777">
        <cfset xml_doc = XmlParse(inv_xml_data)>
        <cfset xslt = toString(tobinary(xml_doc.Invoice.AdditionalDocumentReference[2].Attachment.EmbeddedDocumentBinaryObject.XmlText))>

        <cfoutput>#XmlTransform(xml_doc, xslt)#</cfoutput>

    </cffunction>
</cfcomponent>