<!---
    File: einvoice.cfc
    Folder: V16\e_government\cfc
    Author:
    Date:
    Description:
        E-fatura metodlarını içeren sınıf
    History:
        12.10.2019 Gramoni-Mahmut Çifçi - E-Government standart modüle taşındı
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

    <cffunction name="chk_send_inv_all_fnc" access="public" returntype="query" hint="Gönderilmiş faturaları getiririr">
        <cfargument type="numeric" name="action_id" >
        <cfargument type="string" name="action_type">
        <cfargument type="string" name="uuid">
        <cfquery name="CHK_SEND_INV_ALL" datasource="#this.DSN2#">
			SELECT
                EINVOICE_ID,
                STATUS_CODE,
                UUID,
                BELGE_OID
            FROM
                EINVOICE_SENDING_DETAIL
            WHERE 
            	<cfif isdefined('arguments.action_id')and isdefined('arguments.action_type')>
                ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">AND 
                ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_type#"></cfif>
                <cfif isdefined('arguments.uuid')>UUID =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.uuid#"></cfif>
    	</cfquery>
        <cfreturn chk_send_inv_all />
 	</cffunction>

    <cffunction name="get_our_company_fnc" access="public" returntype="query" hint="e-fatura tanimlarını getirir">
   		<cfargument type="numeric" name="company_id" required="no">
        <cfargument type="numeric" name="einvoice_type" required="no">
        <cfargument type="numeric" name="einvoice_type_alias" required="no">
        <cfargument type="numeric" name="first_company" required="no">
		<cfif structKeyExists(arguments,"einvoice_type") and len(arguments.einvoice_type)>
            <cfquery name="GET_EINV_COMP" datasource="#this.DSN#">
                SELECT 
                   <cfif structKeyExists(arguments,"first_company")>TOP 1</cfif> COMP_ID
                FROM 
                    OUR_COMPANY_INFO 
                WHERE 
                    IS_EFATURA = 1 AND
                    EINVOICE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.einvoice_type#">        
            </cfquery>
            <cfset arguments.company_id=valuelist(get_einv_comp.comp_id)>
        </cfif>     
        <cfquery name="GET_OUR_COMPANY" datasource="#this.dsn#">
            SELECT
                OC.EINVOICE_COMPANY_CODE,
                OC.EINVOICE_TYPE,
                OC.EINVOICE_TYPE_ALIAS,
                OC.EINVOICE_TEST_SYSTEM,
                OC.EINVOICE_SIGNATURE_URL,
                OC.EINVOICE_USER_NAME,
                OC.EINVOICE_PASSWORD,
                OC.EINVOICE_SENDER_ALIAS,
                OC.EINVOICE_RECEIVER_ALIAS,
        		OC.COMP_ID,
                OC.IS_EFATURA,
                OC.EFATURA_DATE,
        		O.TAX_NO,
 		        O.COMPANY_NAME,
                ED.UBLVERSIONID,
                ED.CUSTOMIZATIONID,
                ED.TEMPLATE_FILENAME,
                ED.TEMPLATE_FILENAME_BASE64,
                ED.IS_TEMPLATE_CODE,
                ED.IS_RECEIVING_PROCESS,
                ED.SPECIAL_PERIOD,
                ED.IS_MULTIPLE_PREFIX,
                ED.RECORD_EMP,
			    ED.RECORD_IP,
			    ED.RECORD_DATE,
                ED.UPDATE_EMP,
                ED.UPDATE_IP,
                ED.UPDATE_DATE
            FROM
                OUR_COMPANY_INFO OC,
                OUR_COMPANY O
                LEFT JOIN EINVOICE_DEFINITION ED ON ED.COMP_ID = O.COMP_ID
            WHERE
                OC.IS_EFATURA = 1 AND
                OC.COMP_ID = O.COMP_ID AND
                OC.COMP_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#arguments.company_id#">)
    	</cfquery>
  		<cfreturn get_our_company>
    </cffunction>

    <cffunction name="get_prefix_fnc" access="public" returntype="query" hint="ön ek bilgileri">
   		<cfargument type="numeric" name="company_id" required="no">
        <cfargument type="numeric" name="type" required="no">
        <cfargument name="prefix_order" type="numeric" required="false" default="0" />
        <cfquery name="GET_PREFIX" datasource="#this.dsn#">
        	SELECT
            	PREFIX,
                PREFIX_ORDER
            FROM
            	ETRANSFORMATION_PREFIX
            WHERE
            	COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#"> AND
				TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.type#">
				<cfif arguments.prefix_order Gt 0>AND PREFIX_ORDER = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.prefix_order#" /></cfif>
            ORDER BY
				PREFIX_ORDER
        </cfquery>
        <cfreturn get_prefix>
	</cffunction>

    <cffunction name="get_einvoice_fnc" access="public" returntype="query" hint="Firma e-fatura kullanıyor mu?">
    	<cfquery name="GET_EINVOICE" datasource="#this.DSN#" maxrows="1">
        	SELECT COMP_ID FROM OUR_COMPANY_INFO WHERE IS_EFATURA = 1
        </cfquery>
        <cfreturn get_einvoice>
    </cffunction>

	<cffunction name="get_comp_info_fnc" access="public" returntype="query" hint="Fatura adres bilgisini getirir">
        <cfargument type="numeric" name="company_id">
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
        <cfreturn get_comp_info>
    </cffunction>

	<cffunction name="get_efatura_control_fnc" access="public" returntype="query" hint="fatura bilgileri güncellenir">
        <cfargument type="numeric" name="company_id">
        <cfquery name="GET_EFATURA_CONTROL" datasource="#this.dsn#">
            SELECT
                IS_EFATURA,
                EINVOICE_TYPE
            FROM
                OUR_COMPANY_INFO
            WHERE
                COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">        
    	</cfquery>
        <cfreturn get_efatura_control>
	</cffunction>

    <cffunction name="upd_our_company_info" access="public" hint="Sirket Entegrasyon Tanım Parametreleri Güncelleniyor">
    	<cfargument type="string" name="einvoice_type">
        <cfargument type="string" name="einvoice_type_alias" default = "dp">
        <cfargument type="string" name="einvoice_test_system" default="0">
        <cfargument type="string" name="einvoice_signature_url" required="yes">
        <cfargument type="string" name="einvoice_company_code" required="yes">
        <cfargument type="string" name="einvoice_user_name" required="yes">
        <cfargument type="string" name="einvoice_password" required="yes">
        <cfargument type="string" name="einvoice_sender_alias" required="yes">
        <cfargument type="string" name="einvoice_receiver_alias" required="yes">
        <cfargument type="string" name="einvoice_prefix" required="yes">
        <cfargument type="string" name="einvoice_number" required="yes">
        <cfargument type="string" name="einvoice_ublversion" required="yes">
        <cfargument type="string" name="einvoice_template">
        <cfargument type="string" name="is_receiving_process" default="0">
        <cfargument type="string" name="save_folder">
        <cfargument type="string" name="del_template">
        <cfargument type="string" name="special_period">
        <cfargument type="boolean" name="multiple_prefix" required="false" default="false" />
        <cfquery name="UPD_OUR_COMPANY_INFO" datasource="#this.DSN#">
            UPDATE 
                OUR_COMPANY_INFO 
            SET
                EINVOICE_TEST_SYSTEM = #arguments.einvoice_test_system#,
                EINVOICE_TYPE_ALIAS = '#arguments.einvoice_type_alias#',
                EINVOICE_SIGNATURE_URL = <cfif len(arguments.einvoice_signature_url)>'#arguments.einvoice_signature_url#'<cfelse>NULL</cfif>,
                EINVOICE_COMPANY_CODE = <cfif len(arguments.einvoice_company_code)>'#arguments.einvoice_company_code#'<cfelse>NULL</cfif>,
                EINVOICE_USER_NAME = <cfif len(arguments.einvoice_user_name)>'#arguments.einvoice_user_name#'<cfelse>NULL</cfif>,
                EINVOICE_PASSWORD = <cfif len(arguments.einvoice_password)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.einvoice_password#"><cfelse>NULL</cfif>,
                EINVOICE_SENDER_ALIAS = <cfif len(arguments.einvoice_sender_alias)>'#arguments.einvoice_sender_alias#'<cfelse>NULL</cfif>,
                EINVOICE_RECEIVER_ALIAS = <cfif len(arguments.einvoice_receiver_alias)>'#arguments.einvoice_receiver_alias#'<cfelse>NULL</cfif>,
                UPDATE_EMP = '#session_base.userid#',
                UPDATE_DATE = #now()#,
                UPDATE_IP = '#cgi.remote_addr#'
           WHERE
               COMP_ID = #session_base.company_id#
        </cfquery>
        <cfquery name="UPD_EINVOICE_NO" datasource="#this.DSN2#">
            IF EXISTS (SELECT 1 FROM EINVOICE_NUMBER)
                BEGIN
                    UPDATE
                        EINVOICE_NUMBER
                    SET
                        EINVOICE_PREFIX = '#arguments.einvoice_prefix#',
                        EINVOICE_NUMBER = '#arguments.einvoice_number#'
                END
            ELSE
                INSERT INTO EINVOICE_NUMBER (EINVOICE_PREFIX,EINVOICE_NUMBER) VALUES ('#arguments.einvoice_prefix#','#arguments.einvoice_number#')
        </cfquery>
        <!--- özel şablon seçilirse xslt güncellenir --->
		<cfif isdefined("arguments.del_template") and len(arguments.del_template)>
          	<cftry>
                <cffile action="delete" file="#arguments.save_folder#\einvoice_template_#session_base.company_id#.xslt">
				<cffile action="delete" file="#arguments.save_folder#\einvoice_template_base64_#session_base.company_id#.xslt">
                <cfcatch type="Any">
                    <script>
                    	alert("Dosya Bulunamadığı İçin Silinemedi");
                    </script>
                </cfcatch>  
          	</cftry>
            <cfquery name="DEL_TEMPLATE_FILENAME" datasource="#this.DSN#">
                UPDATE
                    EINVOICE_DEFINITION 
                SET
                    TEMPLATE_FILENAME = NULL,
                	TEMPLATE_FILENAME_BASE64 = NULL,
                    UPDATE_DATE = #Now()#,
                    UPDATE_EMP = <cfif isDefined('session_base.userid')>#session_base.userid#<cfelse>1</cfif>,
                    UPDATE_IP = '#CGI.REMOTE_ADDR#'
                WHERE
                    COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#"> 
            </cfquery>
        <cfelseif isdefined("arguments.einvoice_template") and len(arguments.einvoice_template)>
            <cftry>            
				<cfif not DirectoryExists(arguments.save_folder)>
                    <cfdirectory action = "create" directory="#arguments.save_folder#"/>
                </cfif>
                <cffile action="read" file="#arguments.einvoice_template#" variable="xslt_output" charset="utf-8">
                <cffile action="write" file="#arguments.save_folder#\einvoice_template_#session_base.company_id#.xslt" output="#trim(xslt_output)#" charset="utf-8">
                <cfset xslt64_output = ToBase64(xslt_output)>
                <cffile action="write" file="#arguments.save_folder#\einvoice_template_base64_#session_base.company_id#.xslt" output="#trim(xslt64_output)#" charset="utf-8">
            	<cfcatch type="Any">
                <cfset error=1>
                <script>
                    alert("Dosya Upload Edilemedi!");
                    history.back();
                </script>
                </cfcatch>
            </cftry>
    	</cfif>
        <cfquery name="UPD_EINVOICE_INTEGRATION" datasource="#this.DSN#">
            IF EXISTS (SELECT 1 FROM EINVOICE_DEFINITION WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#">)
                BEGIN
                    UPDATE 
                        EINVOICE_DEFINITION
                    SET
                        UBLVERSIONID = '#listfirst(arguments.einvoice_ublversion,';')#',
                        CUSTOMIZATIONID = '#listlast(arguments.einvoice_ublversion,';')#',
                        <cfif isdefined("arguments.is_receiving_process") and len(arguments.is_receiving_process)>
                        IS_RECEIVING_PROCESS = #arguments.is_receiving_process#,
                        </cfif>
                        <cfif isdefined("arguments.einvoice_template") and len(arguments.einvoice_template)>
                    	TEMPLATE_FILENAME = 'einvoice_template_#session_base.company_id#.xslt',
                        TEMPLATE_FILENAME_BASE64 = 'einvoice_template_base64_#session_base.company_id#.xslt',
                        </cfif>
                        SPECIAL_PERIOD = #arguments.special_period#,
                        IS_MULTIPLE_PREFIX  = <cfif arguments.multiple_prefix><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.multiple_prefix#" /><cfelse>NULL</cfif>,
						UPDATE_DATE = #Now()#,
                    	UPDATE_EMP = <cfif isDefined('session_base.userid')>#session_base.userid#<cfelse>1</cfif>,
                    	UPDATE_IP = '#CGI.REMOTE_ADDR#'
                    WHERE
                        COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#">
                END
            ELSE
                INSERT INTO
					EINVOICE_DEFINITION
				(
					COMP_ID,
					UBLVERSIONID,
					CUSTOMIZATIONID,
					TEMPLATE_FILENAME,
					RECORD_DATE,
                	RECORD_EMP,
                	RECORD_IP
				)
					VALUES
				(
					'#session_base.company_id#',
					'#listfirst(arguments.einvoice_ublversion,';')#',
					'#listlast(arguments.einvoice_ublversion,';')#',
					<cfif isdefined("arguments.einvoice_template")and len(arguments.einvoice_template)>'einvoice_template_#session_base.company_id#.xslt'<cfelse>NULL</cfif>,
					#Now()#,
					<cfif isDefined('session_base.userid')>#session_base.userid#<cfelse>1</cfif>,
					'#CGI.REMOTE_ADDR#'
				)
        </cfquery>
    </cffunction>

    <cffunction name="add_received_invoices" access="public" returntype="any" hint="Gelen E-Faturayı Sisteme Kaydeder">
        <cfargument type="string" name="service_result" required="no">
        <cfargument type="string" name="service_result_description" required="no">
        <cfargument type="string" name="uuid" required="no">
        <cfargument type="string" name="einvoice_id" required="no">
        <cfargument type="string" name="status_description" required="no">
        <cfargument type="numeric" name="status_code" required="no">
        <cfargument type="numeric" name="error_code" required="no">
        <cfargument type="string" name="invoice_type_code" required="no">
        <cfargument type="string" name="sender_tax_id" required="no">
        <cfargument type="string" name="receiver_tax_id" required="no">
        <cfargument type="string" name="profile_id" required="no">
        <cfargument type="numeric" name="payable_amount" required="no">
        <cfargument type="string" name="payable_amount_currency" required="no">
        <cfargument type="date" name="issue_date" required="no">
        <cfargument type="date" name="create_date" required="no">
        <cfargument type="string" name="party_name" required="no">
        <cfargument type="string" name="order_number" required="no">
        <cfargument type="numeric" name="is_process" required="no">
        <cfargument type="numeric" name="process_stage" required="no">
        <cfargument type="numeric" name="is_manuel" required="no">
        <cfargument type="numeric" name="einvoice_type" required="no">
        <cfargument type="numeric" name="is_approve" required="no">
        <cfargument type="date" name="last_date" required="no">
        <cfargument type="numeric" name="company_id" required="no">
        <cfargument type="string" name="branch_id" required="no">
         <cfargument type="string" name="department_id" required="no">
		<cfquery datasource="#this.DSN2#" result="max_id">
        	INSERT INTO
                EINVOICE_RECEIVING_DETAIL
           	(
                SERVICE_RESULT,
                SERVICE_RESULT_DESCRIPTION,
                UUID,
                EINVOICE_ID,
                STATUS_DESCRIPTION,
                STATUS_CODE,
                ERROR_CODE,
                INVOICE_TYPE_CODE,
                SENDER_TAX_ID,
                RECEIVER_TAX_ID,
                PROFILE_ID,
                PAYABLE_AMOUNT,
                PAYABLE_AMOUNT_CURRENCY,
                ISSUE_DATE,
                CREATE_DATE,
                PARTY_NAME,
                PATH,
                ORDER_NUMBER,
                IS_PROCESS,
                PROCESS_STAGE,
                IS_APPROVE,
                IS_MANUEL,
                EINVOICE_TYPE,
                LAST_DATE,
                BRANCH_ID,
				DEPARTMENT_ID,
                RECORD_DATE,
                RECORD_EMP,
                RECORD_IP
            )
            VALUES
            (
                '#arguments.service_result#',
                <cfif isdefined("arguments.service_result_description") and len(arguments.service_result_description)>'#arguments.service_result_description#'<cfelse>NULL</cfif>,
                '#arguments.uuid#',
                '#arguments.einvoice_id#',
                <cfif isdefined("arguments.status_description") and len(arguments.status_description)>'#arguments.status_description#'<cfelse>NULL</cfif>,
                <cfif isdefined("arguments.status_code") and len(arguments.status_code)>#arguments.status_code#<cfelse>NULL</cfif>,
                #arguments.error_code#,
                '#arguments.invoice_type_code#',
                '#arguments.sender_tax_id#',
                '#arguments.receiver_tax_id#',
                '#arguments.profile_id#',
                '#arguments.payable_amount#',
                '#arguments.payable_amount_currency#',
                '#arguments.issue_date#',
				<cfif isdefined("arguments.create_date") and len(arguments.create_date)>'#arguments.create_date#'<cfelse>NULL</cfif>,
                <cfif isdefined("arguments.party_name")>'#arguments.party_name#'<cfelse>'#arguments.sender_tax_id#'</cfif>,
                'einvoice_received/#arguments.company_id#/#year(now())#/#numberformat(month(now()),00)#/#arguments.uuid#.xml',
                <cfif isdefined("arguments.order_number") and len(arguments.order_number)>'#arguments.order_number#'<cfelse>NULL</cfif>,
                <cfif isdefined("arguments.is_process")>#arguments.is_process#<cfelse>NULL</cfif>,
                #arguments.process_stage#,
                <cfif isdefined("arguments.is_approve")>#arguments.is_approve#<cfelse>NULL</cfif>,
                <cfif isdefined("arguments.is_manuel")>#arguments.is_manuel#<cfelse>NULL</cfif>,
                #arguments.einvoice_type#,
                <cfif isdefined("arguments.last_date") and len(arguments.last_date)>'#arguments.last_date#'<cfelse>NULL</cfif>,
                <cfif isdefined("arguments.branch_id") and len(arguments.branch_id)>#arguments.branch_id#<cfelse>NULL</cfif>,
                <cfif isdefined("arguments.department_id") and len(arguments.department_id)>#arguments.department_id#<cfelse>NULL</cfif>,
                #now()#,
                <cfif isdefined("session_base.userid")>#session_base.userid#<cfelse>NULL</cfif>,
                <cfif isdefined("cgi.remote_addr")>'#cgi.remote_addr#'<cfelse>NULL</cfif>
             )
        </cfquery>
        <cfreturn max_id />
    </cffunction> 

    <cffunction name="get_invoice_fnc" access="public" returntype="query" hint="E-Fatura Genel Belge Bilgileri">
        <cfargument type="string" name="action_type">
        <cfargument type="numeric" name="action_id">
        <cfargument type="string" name="company_id" default="">
        <cfargument type="string" name="consumer_id" default="">
        <cfargument type="string" name="temp_currency_code">
        <cfif arguments.action_type is 'INVOICE'>
            <cfif len(arguments.company_id)>
                <cfquery name="GET_INVOICE" datasource="#this.DSN2#">
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
                    <cfif temp_currency_code>
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
                        ER.EINVOICE_ID,
                        SPC.INVOICE_TYPE_CODE,
                        ISNULL(SPC.PROFILE_ID,I.PROFILE_ID) PROFILE_ID,         
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
                        COM.IS_CIVIL_COMPANY AS IS_CIVIL,
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
                        END AS PAYMENT_MEANS_CODE,
                        SPC.IS_EXPORT_REGISTERED,
                        SPC.IS_EXPORT_PRODUCT,
                        CR.BAKIYE,
						I.REF_NO,
                        I.PAYMENT_COMPANY_ID
                    FROM 
                        INVOICE I
                            INNER JOIN #this.dsn_alias#.COMPANY COM ON COM.COMPANY_ID = I.COMPANY_ID
                            LEFT JOIN EINVOICE_RELATION ER ON I.INVOICE_ID = ER.ACTION_ID AND ER.ACTION_TYPE = 'INVOICE'
                            LEFT JOIN #this.dsn_alias#.COMPANY_BRANCH CB ON CB.COMPBRANCH_ID = I.SHIP_ADDRESS_ID
                            LEFT JOIN #this.dsn_alias#.COMPANY_PARTNER CP ON CP.PARTNER_ID = (CASE WHEN COM.IS_PERSON = 1 THEN COM.MANAGER_PARTNER_ID ELSE I.PARTNER_ID END)
                            LEFT JOIN #this.dsn_alias#.SETUP_CITY SCI ON SCI.CITY_ID = COM.CITY 
                            LEFT JOIN #this.dsn_alias#.SETUP_COUNTRY SCO ON SCO.COUNTRY_ID = COM.COUNTRY
                            LEFT JOIN #this.dsn_alias#.SETUP_COUNTY SC ON SC.COUNTY_ID = COM.COUNTY
                            LEFT JOIN #this.dsn_alias#.SETUP_CITY SCI2 ON SCI2.CITY_ID = CB.CITY_ID
                            LEFT JOIN #this.dsn_alias#.SETUP_COUNTRY SCO2 ON SCO2.COUNTRY_ID = CB.COUNTRY_ID
                            LEFT JOIN #this.dsn_alias#.SETUP_COUNTY SC2 ON SC2.COUNTY_ID = CB.COUNTY_ID
                            LEFT JOIN #this.dsn_alias#.SETUP_PAYMETHOD SP ON SP.PAYMETHOD_ID = I.PAY_METHOD
                            LEFT JOIN #this.dsn3_alias#.CREDITCARD_PAYMENT_TYPE CPT ON CPT.PAYMENT_TYPE_ID = I.CARD_PAYMETHOD_ID
                            LEFT JOIN INVOICE_MONEY IM ON IM.ACTION_ID = I.INVOICE_ID AND IM.IS_SELECTED = 1
                            LEFT JOIN COMPANY_REMAINDER CR ON CR.COMPANY_ID = I.COMPANY_ID
                            LEFT JOIN SETUP_MONEY SM ON SM.MONEY = IM.MONEY_TYPE,
                        #this.dsn3_alias#.SETUP_PROCESS_CAT SPC 
                    WHERE 
                        I.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> AND 
                        SPC.PROCESS_CAT_ID = I.PROCESS_CAT
                </cfquery>
            <cfelseif len(arguments.consumer_id)>
                <cfquery name="GET_INVOICE" datasource="#this.dsn2#">
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
                    <cfif temp_currency_code>
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
                        ER.EINVOICE_ID,
                        SPC.INVOICE_TYPE_CODE,
                        ISNULL(I.PROFILE_ID,SPC.PROFILE_ID) PROFILE_ID,
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
                        '' AS IS_CIVIL,
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
                        END AS PAYMENT_MEANS_CODE,
                        SPC.IS_EXPORT_REGISTERED,
                        CR.BAKIYE,
						I.REF_NO,
                        I.PAYMENT_COMPANY_ID
                    FROM 
                        INVOICE I
                            INNER JOIN #this.dsn_alias#.CONSUMER CON ON CON.CONSUMER_ID = I.CONSUMER_ID
                            LEFT JOIN EINVOICE_RELATION ER ON I.INVOICE_ID = ER.ACTION_ID AND ER.ACTION_TYPE = 'INVOICE'
                            LEFT JOIN #this.dsn_alias#.COMPANY_BRANCH CB ON CB.COMPBRANCH_ID = I.SHIP_ADDRESS_ID
                            LEFT JOIN #this.dsn_alias#.SETUP_CITY SCI ON CON.TAX_CITY_ID = SCI.CITY_ID
                            LEFT JOIN #this.dsn_alias#.SETUP_COUNTRY SCO ON  CON.TAX_COUNTRY_ID = SCO.COUNTRY_ID
                            LEFT JOIN #this.dsn_alias#.SETUP_COUNTY SC ON CON.TAX_COUNTY_ID = SC.COUNTY_ID
                            LEFT JOIN #this.dsn_alias#.SETUP_PAYMETHOD SP ON SP.PAYMETHOD_ID = I.PAY_METHOD
                            LEFT JOIN #this.dsn3_alias#.CREDITCARD_PAYMENT_TYPE CPT ON CPT.PAYMENT_TYPE_ID = I.CARD_PAYMETHOD_ID
                            LEFT JOIN INVOICE_MONEY IM ON IM.ACTION_ID = I.INVOICE_ID AND IM.IS_SELECTED = 1
                            LEFT JOIN COMPANY_REMAINDER CR ON CR.COMPANY_ID = I.COMPANY_ID
                            LEFT JOIN SETUP_MONEY SM ON SM.MONEY = IM.MONEY_TYPE,
                        #this.dsn3_alias#.SETUP_PROCESS_CAT SPC 
                    WHERE 
                        I.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> AND 
                        SPC.PROCESS_CAT_ID = I.PROCESS_CAT
                </cfquery>
            </cfif>
        <cfelse>
            <cfif len(arguments.company_id)>
                <cfquery name="GET_INVOICE" datasource="#this.dsn2#">
                    SELECT 
                        I.EXPENSE_ID INVOICE_ID, 
                        I.PAPER_NO INVOICE_NUMBER,
                        I.EXPENSE_DATE INVOICE_DATE,
                        I.CH_COMPANY_ID COMPANY_ID,
                        I.CH_CONSUMER_ID CONSUMER_ID,
                        I.EXPENSE_DATE DUE_DATE,
                        I.DETAIL NOTE,
                        '' INVOICE_CAT,
                        I.TOTAL_AMOUNT,
                        I.ACTION_TYPE,
                        I.SHIP_ADDRESS_ID,
                        I.SERIAL_NUMBER,
                         I.PROCESS_CAT,
                         I.IS_CASH AS IS_CASH,
                         (SELECT ACTION_ID FROM CASH_ACTIONS WHERE EXPENSE_ID = I.EXPENSE_ID) AS CASH_ID,
						CASE
							WHEN I.IS_BANK = 1
							THEN I.EXPENSE_CASH_ID
							ELSE 0
						END AS BANK_ID,
                    <cfif temp_currency_code>
                        I.TOTAL_AMOUNT GROSSTOTAL,
                        I.TOTAL_AMOUNT_KDVLI NETTOTAL,
                        0 SA_DISCOUNT,  
                        'TRY' CURRENCY_CODE,
                        'TL' MONEY,
                        1 RATE2, 
                        ROUND(I.KDV_TOTAL,2) TAXTOTAL,
                        ISNULL(ROUND(I.STOPAJ,2),0) STOPAJ,
                        ISNULL(ROUND(I.OTV_TOTAL,2),0) OTV_TOTAL,
                    <cfelse>
                        (I.TOTAL_AMOUNT/IM.RATE2) GROSSTOTAL,
                        (I.TOTAL_AMOUNT_KDVLI/IM.RATE2) NETTOTAL,
                        0 SA_DISCOUNT,      
                        SM.CURRENCY_CODE,
                        SM.MONEY,
                        IM.RATE2, 
                        ROUND((I.KDV_TOTAL/IM.RATE2),2) TAXTOTAL,
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
                        ER.EINVOICE_ID,
                        SPC.INVOICE_TYPE_CODE,
                        ISNULL(I.PROFILE_ID,SPC.PROFILE_ID) PROFILE_ID,
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
                        COM.IS_CIVIL_COMPANY AS IS_CIVIL,
                        SC.COUNTY_NAME,
                        SCI.CITY_NAME,
                        SCO.COUNTRY_NAME,
                        SC2.COUNTY_NAME COUNTY_NAME2,
                        SCI2.CITY_NAME CITY_NAME2,
                        SCO2.COUNTRY_NAME COUNTRY_NAME2,              
                        SP.PAYMETHOD,
                        0 ROW_DISCOUNT,
                        CASE
                            WHEN (I.PAYMETHOD_ID IS NOT NULL)
                            THEN SP.PAYMENT_MEANS_CODE
                            ELSE 'ZZZ'
                        END AS PAYMENT_MEANS_CODE,
                        SPC.IS_EXPORT_REGISTERED,
                        '' BAKIYE,
						SYSTEM_RELATION AS REF_NO,
                        '' PAYMENT_COMPANY_ID
                    FROM 
                        EXPENSE_ITEM_PLANS I
                            INNER JOIN #this.dsn_alias#.COMPANY COM ON COM.COMPANY_ID = I.CH_COMPANY_ID
                            LEFT JOIN EINVOICE_RELATION ER ON I.EXPENSE_ID = ER.ACTION_ID AND ER.ACTION_TYPE = 'EXPENSE_ITEM_PLANS'
                            LEFT JOIN #this.dsn_alias#.COMPANY_BRANCH CB ON CB.COMPBRANCH_ID = I.SHIP_ADDRESS_ID
                            LEFT JOIN #this.dsn_alias#.COMPANY_PARTNER CP ON CP.PARTNER_ID = (CASE WHEN COM.IS_PERSON = 1 THEN COM.MANAGER_PARTNER_ID ELSE I.CH_PARTNER_ID END)
                            LEFT JOIN #this.dsn_alias#.SETUP_CITY SCI ON SCI.CITY_ID = COM.CITY
                            LEFT JOIN #this.dsn_alias#.SETUP_COUNTRY SCO ON SCO.COUNTRY_ID = COM.COUNTRY
                            LEFT JOIN #this.dsn_alias#.SETUP_COUNTY SC ON SC.COUNTY_ID = COM.COUNTY
                            LEFT JOIN #this.dsn_alias#.SETUP_CITY SCI2 ON SCI2.CITY_ID = CB.CITY_ID
                            LEFT JOIN #this.dsn_alias#.SETUP_COUNTRY SCO2 ON SCO2.COUNTRY_ID = CB.COUNTRY_ID
                            LEFT JOIN #this.dsn_alias#.SETUP_COUNTY SC2 ON SC2.COUNTY_ID = CB.COUNTY_ID
                            LEFT JOIN #this.dsn_alias#.SETUP_PAYMETHOD SP ON SP.PAYMETHOD_ID = I.PAYMETHOD_ID
                            LEFT JOIN EXPENSE_ITEM_PLANS_MONEY IM ON IM.ACTION_ID = I.EXPENSE_ID AND IM.IS_SELECTED = 1
                            LEFT JOIN SETUP_MONEY SM ON SM.MONEY = IM.MONEY_TYPE,
                        #this.dsn3_alias#.SETUP_PROCESS_CAT SPC 
                    WHERE 
                        I.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> AND 
                        SPC.PROCESS_CAT_ID = I.PROCESS_CAT
                </cfquery>
            <cfelseif len(arguments.consumer_id)>
                    <cfquery name="GET_INVOICE" datasource="#this.dsn2#">
                        SELECT 
                            I.EXPENSE_ID INVOICE_ID, 
                            I.PAPER_NO INVOICE_NUMBER,
                            I.EXPENSE_DATE INVOICE_DATE,
                            I.CH_COMPANY_ID COMPANY_ID,
                            I.CH_CONSUMER_ID CONSUMER_ID,
                            I.EXPENSE_DATE DUE_DATE,
                            I.DETAIL NOTE,
                            I.TOTAL_AMOUNT,
                            I.ACTION_TYPE,
                            '' SHIP_ADDRESS_ID,
                            I.SERIAL_NUMBER,    
                             I.PROCESS_CAT,      
                            I.IS_CASH AS IS_CASH,
                            (SELECT ACTION_ID FROM CASH_ACTIONS WHERE EXPENSE_ID = I.EXPENSE_ID) AS CASH_ID,
							CASE
								WHEN I.IS_BANK = 1
								THEN I.EXPENSE_CASH_ID
								ELSE 0
							END AS BANK_ID,
                            <cfif temp_currency_code> 
                                I.TOTAL_AMOUNT GROSSTOTAL,
                                I.TOTAL_AMOUNT_KDVLI NETTOTAL,
                                0 SA_DISCOUNT,
                                'TRY' CURRENCY_CODE,
                                'TL' MONEY,
                                1 RATE2,
                                ROUND(I.KDV_TOTAL,2) TAXTOTAL,
	                            ISNULL(ROUND(I.STOPAJ,2),0) STOPAJ,
                                ISNULL(ROUND(I.OTV_TOTAL,2),0) OTV_TOTAL,
                            <cfelse>
                                (I.TOTAL_AMOUNT/IM.RATE2) GROSSTOTAL,
                                (I.TOTAL_AMOUNT_KDVLI/IM.RATE2) NETTOTAL,
                                0 SA_DISCOUNT,      
                                SM.CURRENCY_CODE,
                                SM.MONEY,
                                IM.RATE2,
                                ROUND(I.KDV_TOTAL/IM.RATE2,2) TAXTOTAL,
	                            ISNULL(ROUND(I.STOPAJ/IM.RATE2,2),0) STOPAJ,
                                ISNULL(ROUND((I.OTV_TOTAL/IM.RATE2),2),0) OTV_TOTAL,
                            </cfif>
                            '' COMPBRANCH_CODE,
                            '' COMPBRANCH_ALIAS,
                            '' COMPBRANCH__NAME,
                            CON.CONSUMER_NAME COMPANY_PARTNER_NAME,
                            CON.CONSUMER_SURNAME COMPANY_PARTNER_SURNAME,
                            CON.TC_IDENTY_NO TC_IDENTITY,
                            ER.EINVOICE_ID,
                            SPC.INVOICE_TYPE_CODE,
                            ISNULL(I.PROFILE_ID,SPC.PROFILE_ID) PROFILE_ID,
                            '' COMPANY_POSTCODE2,
                            '' ADDRESS2,
                            CON.CONSUMER_NAME +' ' +CON.CONSUMER_SURNAME FULLNAME,
                            CON.CONSUMER_EMAIL COMPANY_EMAIL,
                            '' COMPANY_TELCODE,
                            '' COMPANY_TEL,
                            '' COMPANY_FAX,
                            '' TAXOFFICE,
                            '' TAXNO,
                            '' AS IS_CIVIL,
                            CON.TAX_POSTCODE COMPANY_POSTCODE,
                            '' OZEL_KOD_2,
                            1 IS_PERSON,
                            SCI.CITY_NAME,
                            SCO.COUNTRY_NAME,
                            SC.COUNTY_NAME,
                            '' COUNTY_NAME2,
                            '' CITY_NAME2,
                            '' COUNTRY_NAME2,            
                            0 ROW_DISCOUNT,
                            CON.TAX_ADRESS ADDRESS,
                            SP.PAYMETHOD,
                            CASE
                                WHEN (I.PAYMETHOD_ID IS NOT NULL)
                                   THEN SP.PAYMENT_MEANS_CODE
                                ELSE 'ZZZ'
                            END AS PAYMENT_MEANS_CODE,
                            SPC.IS_EXPORT_REGISTERED,
                        	'' BAKIYE,
							SYSTEM_RELATION AS REF_NO,
                            '' PAYMENT_COMPANY_ID
                        FROM 
                            EXPENSE_ITEM_PLANS I
                                INNER JOIN #this.dsn_alias#.CONSUMER CON ON CON.CONSUMER_ID = I.CH_CONSUMER_ID
                                LEFT JOIN EINVOICE_RELATION ER ON I.EXPENSE_ID = ER.ACTION_ID AND ER.ACTION_TYPE = 'EXPENSE_ITEM_PLANS'
                                LEFT JOIN #this.dsn_alias#.SETUP_CITY SCI ON SCI.CITY_ID = CON.TAX_CITY_ID
                                LEFT JOIN #this.dsn_alias#.SETUP_COUNTRY SCO ON SCO.COUNTRY_ID = CON.TAX_COUNTRY_ID
                                LEFT JOIN #this.dsn_alias#.SETUP_COUNTY SC ON SC.COUNTY_ID = CON.TAX_COUNTY_ID
                                LEFT JOIN #this.dsn_alias#.SETUP_PAYMETHOD SP ON SP.PAYMETHOD_ID = I.PAYMETHOD_ID
                                LEFT JOIN EXPENSE_ITEM_PLANS_MONEY IM ON IM.ACTION_ID = I.EXPENSE_ID AND IM.IS_SELECTED = 1
                                LEFT JOIN SETUP_MONEY SM ON SM.MONEY = IM.MONEY_TYPE,
                            #this.dsn3_alias#.SETUP_PROCESS_CAT SPC 
                        WHERE 
                            I.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> AND 
                            SPC.PROCESS_CAT_ID = I.PROCESS_CAT
                    </cfquery>
            </cfif>
        </cfif>
        <cfreturn get_invoice>
    </cffunction>

    <cffunction name="get_invoice_relation" access="public" returntype="query" hint="E-fatura ilişki tablosundan kayda ait değerleri getirir.">
    	<cfargument name="action_id" type="numeric" required="true" />
    	<cfargument name="action_type" type="string" required="true" />
    	<cfargument name="invoice_type" type="string" required="true" />
        <cfquery name="get_relation" datasource="#this.DSN2#">
            SELECT
                *
            FROM
                <cfif arguments.invoice_type is 'einvoice'>EINVOICE_RELATION<cfelseif arguments.invoice_type is 'earchive'>EARCHIVE_RELATION</cfif>
            WHERE
                ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> AND
                ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_type#">
            ORDER BY
                RECORD_DATE DESC
		</cfquery>
      <cfreturn get_relation />
    </cffunction>

    <cffunction name="get_invoice_relation_uuid" access="public" returntype="query" hint="E-fatura ilişki tablosundan kayda ait değerleri UUID ile getirir.">
    	<cfargument name="uuid" type="string" required="true" />
    	<cfargument name="invoice_type" type="string" required="true" />
        <cfquery name="get_relation_uuid" datasource="#this.dsn2#">
            SELECT
                UUID
            FROM
                <cfif arguments.invoice_type is 'einvoice'>EINVOICE_RELATION<cfelseif arguments.invoice_type is 'earchive'>EARCHIVE_RELATION</cfif>
            WHERE
                UUID = '#arguments.uuid#'
		</cfquery>
      <cfreturn get_relation_uuid />
    </cffunction>

    <cffunction name="upd_einvoice_relation_fnc" returntype="any" access="public">
    	<cfargument type="string" name="uuid" required="yes">
    	<cfargument type="string" name="profile_id" required="yes">
    	<cfargument type="numeric" name="einvoice_type" required="yes">       
        <cfargument name="StatusCode" type="numeric" required="yes">
        <cfargument type="string" name="CheckInvoiceStateResult" required="yes">
        
		<cfif arguments.einvoice_type eq 3><!--- DP --->
			<cfif arguments.profile_id eq 'TICARIFATURA' or arguments.profile_id eq 'IHRACAT'>
				<!---Ticari fatura sorgulaması --->
                <cfquery name="UPD_EINVOICE_RELATION" datasource="#this.DSN2#">
                        UPDATE
                            EINVOICE_RELATION
                        SET
                            STATUS = <cfif arguments.StatusCode eq 9987 or arguments.StatusCode eq 54>1<cfelseif arguments.StatusCode eq 9988>0<cfelse>NULL</cfif>,
                            STATUS_CODE = #arguments.StatusCode#,
                            STATUS_DESCRIPTION = '#left(arguments.CheckInvoiceStateResult,250)#',
                            STATUS_DATE = #now()#                            
                        WHERE
                            UUID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.uuid#">
                    </cfquery>
                <cfelse>
                <!---Temel Fatura Sorgulaması --->
                <cfquery name="UPD_EINVOICE_RELATION" datasource="#this.DSN2#">
                    UPDATE
                        EINVOICE_RELATION
                    SET
                        <cfif arguments.StatusCode eq 54>STATUS = 1,</cfif>
                        STATUS_CODE = #arguments.StatusCode#,
                        STATUS_DESCRIPTION = '#left(arguments.CheckInvoiceStateResult,250)#',
                        STATUS_DATE = #now()#                            
                    WHERE
                        UUID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.uuid#">
                </cfquery>
            </cfif>
		</cfif>
      <cfreturn>
    </cffunction>

    <cffunction name="add_einvoice_sending_detail" access="public">
    	<cfargument type="string" name="service_result" required="no">
        <cfargument type="string" name="uuid" required="no">
        <cfargument type="string" name="einvoice_id" required="no">
        <cfargument type="string" name="status_description" required="no">
        <cfargument type="string" name="service_result_description" required="no">
        <cfargument type="numeric" name="status_code" required="no">
        <cfargument type="numeric" name="error_code" required="no">
        <cfargument type="numeric" name="action_id" required="no">
        <cfargument type="string" name="action_type" required="no">
        <cfargument type="string" name="belgeOid" required="no">
        <cfargument type="string" name="invoice_type_code" required="no">
        
    	<cfquery name="INS_EFATURA" datasource="#this.DSN2#">
            INSERT INTO
                EINVOICE_SENDING_DETAIL
            (
                SERVICE_RESULT,
                <cfif isdefined("arguments.uuid")>UUID,</cfif>
                EINVOICE_ID,
                STATUS_DESCRIPTION,
                SERVICE_RESULT_DESCRIPTION,
                <cfif isdefined("arguments.status_code")>STATUS_CODE,</cfif>
                ERROR_CODE,
                ACTION_ID,
                ACTION_TYPE,
                RECORD_DATE,
                RECORD_EMP,
                RECORD_IP,
                BELGE_OID,
                INVOICE_TYPE_CODE
            )
            VALUES
            (
                '#arguments.service_result#',
                <cfif isdefined("arguments.uuid")>'#arguments.uuid#',</cfif>
                '#arguments.einvoice_id#',
                '#arguments.status_description#',
                '#arguments.service_result_description#',
                <cfif isdefined("arguments.status_code")>'#arguments.status_code#',</cfif>
                '#arguments.error_code#',
                #arguments.action_id#,
                '#arguments.action_type#',
                #NOW()#,
                #session_base.userid#,
                '#cgi.REMOTE_ADDR#',
                <cfif structKeyExists(arguments,"belgeOid") and  len(arguments.belgeOid)>'#arguments.belgeOid#'<cfelse>NULL</cfif>,
               	'#arguments.invoice_type_code#'
            )
    	</cfquery> 
    </cffunction>

    <cffunction name="add_einvoice_relation" access="public">
        <cfargument type="string" name="uuid" required="no">
        <cfargument type="string" name="integration_id" required="no">
        <cfargument type="string" name="envuuid" required="no">
        <cfargument type="string" name="einvoice_id" required="no">
        <cfargument type="numeric" name="action_id" required="no">
        <cfargument type="string" name="action_type" required="no">
        <cfargument type="string" name="profile_id" required="no">
        <cfargument type="string" name="path" required="no">
        <cfargument type="numeric" name="sender_type" required="no">
    	<cfquery name="INS_EFATURA" datasource="#this.DSN2#">
            INSERT INTO
                EINVOICE_RELATION
            (
                UUID,
                ENVUUID,
				INTEGRATION_ID,
                EINVOICE_ID,
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
				'#arguments.einvoice_id#',
                '#arguments.profile_id#',
                #arguments.action_id#,
                '#arguments.action_type#',
                '#arguments.path#',
                #arguments.sender_type#,
                #NOW()#,
                #session_base.userid#,
                '#cgi.REMOTE_ADDR#'
            )
       </cfquery>
    </cffunction>

    <cffunction name="upd_einvoice_relation" access="public">
        <cfargument type="string" name="uuid" required="no">
        <cfargument type="string" name="envuuid" required="no">
        <cfargument type="string" name="integration_id" required="no">
        <cfargument type="string" name="einvoice_id" required="no">
        <cfargument type="string" name="profile_id" required="no">
        <cfargument type="numeric" name="action_id" required="no">
        <cfargument type="string" name="action_type" required="no">
        <cfargument type="string" name="path" required="no">
        <cfargument type="numeric" name="sender_type" required="no">
    	<cfquery name="UPD_EFATURA" datasource="#this.dsn2#">
                UPDATE 
                    EINVOICE_RELATION 
                SET    
                    UUID = '#arguments.uuid#',
                    ENVUUID = <cfif structKeyExists(arguments,"envuuid")>'#arguments.envuuid#'<cfelse>NULL</cfif>,
                    INTEGRATION_ID = '#arguments.integration_id#',
                    EINVOICE_ID = '#arguments.einvoice_id#',
                    PROFILE_ID = '#arguments.profile_id#',
                    ACTION_ID =  #arguments.action_id#,
                    ACTION_TYPE = '#arguments.action_type#',
                    PATH = '#arguments.path#',
                    SENDER_TYPE = #arguments.sender_type#,
                    RECORD_DATE = #NOW()#,
                    RECORD_EMP = #session_base.userid#,
                    RECORD_IP =  '#cgi.remote_addr#',
                    STATUS = NULL,
                    STATUS_CODE = NULL,
                    STATUS_DESCRIPTION = NULL,
                    STATUS_DATE = NULL                                                     
                WHERE 
                    ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> AND
                    ACTION_TYPE = '#arguments.action_type#'
         </cfquery>
    </cffunction>

    <cffunction name="get_einvoice_detail_fnc" access="public" returntype="query">
        <cfargument name="action_id" type="numeric" required="no">
        <cfargument name="action_type" type="string" required="no">
        <cfquery name="GET_EINVOICE_DETAIL" datasource="#this.dsn2#">
            SELECT 
                ER.STATUS,
                ER.PROFILE_ID,
                ER.INTEGRATION_ID,
                ER.PATH,
                ESD.EINVOICE_ID,
                ESD.STATUS_DESCRIPTION,
                ESD.SERVICE_RESULT,
                ESD.SERVICE_RESULT_DESCRIPTION,
                ESD.RECORD_DATE,
                ESD.UUID,
                ESD.INVOICE_TYPE_CODE,
                E.EMPLOYEE_NAME +' ' +E.EMPLOYEE_SURNAME NAME
            FROM 
                EINVOICE_SENDING_DETAIL ESD
                    LEFT JOIN EINVOICE_RELATION ER ON ER.ACTION_ID = ESD.ACTION_ID AND ER.ACTION_TYPE = ESD.ACTION_TYPE,
                #this.dsn_alias#.EMPLOYEES E
            WHERE
                ESD.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> AND
                ESD.ACTION_TYPE =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_type#"> AND
                E.EMPLOYEE_ID = ESD.RECORD_EMP
            ORDER BY
                SENDING_DETAIL_ID DESC        
        </cfquery>
        <cfreturn get_einvoice_detail>
    </cffunction>

    <cffunction name="get_last_invoice_date" access="public" returntype="any" hint="Çoklu seri kullanılan durumlar için son gönderilen fatura tarihini verir.">
        <cfargument name="ip_prefix" type="string" required="true" />

        <cfquery name="get_last_invoice" datasource="#this.dsn2#">
            SELECT TOP 1 INVOICE_DATE
            FROM   (
                    SELECT TOP 1 i.INVOICE_DATE
                    FROM INVOICE AS i
                            INNER JOIN EINVOICE_SENDING_DETAIL AS ESD
                                ON  ESD.ACTION_ID = i.INVOICE_ID
                    WHERE  ESD.ACTION_TYPE = 'INVOICE'
                            AND ESD.STATUS_CODE = 1
                            AND LEFT(ESD.EINVOICE_ID, 3) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ip_prefix#" />
                    ORDER BY
                            i.INVOICE_DATE DESC
                    UNION
                    ALL
                    SELECT TOP 1 i.EXPENSE_DATE AS INVOICE_DATE
                    FROM EXPENSE_ITEM_PLANS AS i
                            INNER JOIN EINVOICE_SENDING_DETAIL AS ESD
                                ON  ESD.ACTION_ID = i.EXPENSE_ID
                    WHERE  ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS'
                            AND ESD.STATUS_CODE = 1
                            AND LEFT(ESD.EINVOICE_ID, 3) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ip_prefix#" />
                    ORDER BY
                            i.EXPENSE_DATE DESC
                ) INVOICES
            ORDER BY
                INVOICE_DATE DESC
        </cfquery>

        <cfreturn get_last_invoice.INVOICE_DATE />
	</cffunction>
	
	<cffunction name="get_last_earchive_date" access="public" returntype="any" hint="Çoklu seri kullanılan durumlar için son gönderilen fatura tarihini verir.">
        <cfargument name="ip_prefix" type="string" required="true" />

        <cfquery name="get_last_earchive" datasource="#this.dsn2#">
            SELECT TOP 1 INVOICE_DATE
            FROM   (
                    SELECT TOP 1 i.INVOICE_DATE
                    FROM INVOICE AS i
                            INNER JOIN EARCHIVE_SENDING_DETAIL AS ESD
                                ON  ESD.ACTION_ID = i.INVOICE_ID
                    WHERE  ESD.ACTION_TYPE = 'INVOICE'
                            AND ESD.STATUS_CODE = 1
                            AND LEFT(ESD.EARCHIVE_ID, 3) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ip_prefix#" />
                    ORDER BY
                            i.INVOICE_DATE DESC
                    UNION
                    ALL
                    SELECT TOP 1 i.EXPENSE_DATE AS INVOICE_DATE
                    FROM EXPENSE_ITEM_PLANS AS i
                            INNER JOIN EARCHIVE_SENDING_DETAIL AS ESD
                                ON  ESD.ACTION_ID = i.EXPENSE_ID
                    WHERE  ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS'
                            AND ESD.STATUS_CODE = 1
                            AND LEFT(ESD.EARCHIVE_ID, 3) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ip_prefix#" />
                    ORDER BY
                            i.EXPENSE_DATE DESC
                ) INVOICES
            ORDER BY
                INVOICE_DATE DESC
        </cfquery>

        <cfreturn get_last_earchive.INVOICE_DATE />
    </cffunction>

    <cffunction name="get_received_invoice_company" access="public" returntype="query" hint="Gelen e-faturaların dağıtımı aşamasında e-fatura gönderen firmanın tespiti için kullanılır">
        <cfargument name="VKN" type="numeric" required="true" />
        
        <cfquery name="get_company" datasource="#this.dsn#">
            SELECT COMPANY_ID, FIRM_TYPE FROM COMPANY WHERE TAXNO = <cfqueryparam cfsqltype="numeric" value="#arguments.VKN#" />
            UNION ALL
            SELECT C.COMPANY_ID, FIRM_TYPE FROM COMPANY C INNER JOIN COMPANY_PARTNER CP ON C.MANAGER_PARTNER_ID = CP.PARTNER_ID WHERE CP.TC_IDENTITY = <cfqueryparam cfsqltype="numeric" value="#arguments.VKN#" />
        </cfquery>

        <cfreturn get_company />
    </cffunction>

    <cffunction name="upd_received_invoice" access="public" returntype="void" hint="Gelen e-faturanını güncellenmesi için kullanılır">
        <cfargument name="dsn2_name" type="string" required="true" />
        <cfargument name="receiving_id" type="numeric" required="true" />
        <cfargument name="process_stage" type="numeric" required="false" default="" />
        <cfargument name="department_id" type="numeric" required="true" />
        <cfargument name="position_ids" type="string" required="false" default="" />

        <cfquery datasource="#arguments.dsn2_name#">
            UPDATE
                EINVOICE_RECEIVING_DETAIL
            SET
                <cfif Len(arguments.process_stage)>
                PROCESS_STAGE   = <cfqueryparam cfsqltype="integer" value="#arguments.process_stage#" />,
                </cfif>
                DEPARTMENT_ID   = <cfif arguments.department_id Neq 0><cfqueryparam cfsqltype="integer" value="#arguments.department_id#" /><cfelse>NULL</cfif>,
                <cfif Len(arguments.position_ids)>
                POSITION_IDS    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.position_ids#" />,
                </cfif>
                UPDATE_EMP      = <cfif isDefined('session_base.userid')>#session_base.userid#<cfelse>1</cfif>,
                UPDATE_IP       = '#CGI.REMOTE_ADDR#',
                UPDATE_DATE     = #Now()#
            WHERE
                RECEIVING_DETAIL_ID = <cfqueryparam cfsqltype="integer" value="#arguments.receiving_id#" />
        </cfquery>
    </cffunction>

    <cffunction name="get_pdf" access="remote">
        <cfset upload_folder = application.systemParam.systemParam().upload_folder>   
        <cfset dir_seperator = application.systemParam.systemParam().dir_seperator />

        <cfquery name="GET_INV_DET" datasource="#arguments.dsn2_name#">
            SELECT PATH FROM EINVOICE_RELATION WHERE UUID = '#arguments.uuid#'
        </cfquery>

        <cffile action="read" file="#upload_folder##dir_seperator##get_inv_det.path#" variable="inv_xml_data" charset="utf-8">
        <cfset xml_doc = XmlParse(inv_xml_data)>
        <cfset xslt = toString(tobinary(xml_doc.Invoice.AdditionalDocumentReference[1].Attachment.EmbeddedDocumentBinaryObject.XmlText))>

        <cfoutput>#XmlTransform(xml_doc, xslt)#</cfoutput>

    </cffunction>

</cfcomponent>