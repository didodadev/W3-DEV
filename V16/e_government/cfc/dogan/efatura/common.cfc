<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn1 = '#dsn#_product'>
    <cfset dsn2 = '#dsn#_#session.ep.period_year#_#session.ep.company_id#'>
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'>

    <cffunction name="GetEInvoiceIntegrationInfo" access="public" hint="E-fatura entegrasyon bilgileri">
        <cfquery name="query_integrationinfo" datasource="#dsn2#">
            SELECT
                EINVOICE_TEST_SYSTEM,
                'https://efaturatest.doganedonusum.com/' AS EINVOICE_TEST_URL,
                'https://connector.doganedonusum.com/' AS EINVOICE_LIVE_URL
            FROM
                #dsn#.OUR_COMPANY_INFO
            WHERE
                COMP_ID = #session.ep.company_id#
        </cfquery>
        
        <cfreturn query_integrationinfo>
    </cffunction>

    <cffunction name="GetAuthorizationVars" access="public" hint="Fatura entegrasyon doğrulama bilgileri">
        <cfargument type="numeric" name="company_id" default = "#session.ep.company_id#">
        <cfquery name="get_authorizaton" datasource="#dsn2#">
            SELECT
                EINVOICE_COMPANY_CODE AS EFATURA_COMPANY_CODE,
                EINVOICE_USER_NAME AS EFATURA_USER_NAME,
                EINVOICE_PASSWORD AS EFATURA_PASSWORD
            FROM
                #dsn#.OUR_COMPANY_INFO
            WHERE
                COMP_ID = #arguments.company_id#
        </cfquery>
        <cfset authvars = structNew()>
        <cfset authvars.corporateCode = "#get_authorizaton.EFATURA_COMPANY_CODE#">
        <cfset authvars.loginName = "#get_authorizaton.EFATURA_USER_NAME#">
        <cfset authvars.password = "#get_authorizaton.EFATURA_PASSWORD#">

        <cfreturn authvars>
    </cffunction>

    <cffunction name="truncate_efatura_alias" access="public">
        <cfquery name="query_efatura_truncate" datasource="#dsn#">
            TRUNCATE TABLE EINVOICE_COMPANY_IMPORT
        </cfquery>
    </cffunction>

    <cffunction name="add_efatura_alias" access="public">
        <cfargument name="vkntckn">
        <cfargument name="alias">
        <cfargument name="name">
        <cfargument name="type" default="">
        <cfargument name="registertime" default="">
        <cfargument name="aliascreationtime" default="">

        <cfquery name="query_efatura_add" datasource="#dsn#">
            INSERT INTO EINVOICE_COMPANY_IMPORT
           (TAX_NO
           ,ALIAS
           ,COMPANY_FULLNAME
           ,TYPE
           ,REGISTER_DATE
           ,ALIAS_CREATION_DATE)
            VALUES
           (<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.vkntckn#'>
           ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.alias#'>
           ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.name#'>
           ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.type#' null="#len(arguments.type)?'no':'yes'#">
           ,<cfqueryparam cfsqltype='CF_SQL_TIMESTAMP' value='#arguments.registertime#' null="#len(arguments.registertime)?'no':'yes'#">
           ,<cfqueryparam cfsqltype='CF_SQL_TIMESTAMP' value='#arguments.aliascreationtime#' null="#len(arguments.aliascreationtime)?'no':'yes'#">)
        </cfquery>
    </cffunction>

    <cffunction name="fill_efatura_to_company" access="public">

        <cfquery name="query_fill_efatura_to_company" datasource="#dsn#">
            UPDATE COMPANY SET USE_EFATURA = 0, USE_EARCHIVE = 1
        </cfquery>
        <cfquery name="query_fill_efatura_to_company" datasource="#dsn#">
            UPDATE CONSUMER SET USE_EFATURA = 0, USE_EARCHIVE = 1
        </cfquery>

        <cfquery name="query_fill_efatura_to_company" datasource="#dsn#">
            UPDATE CMP
            SET CMP.USE_EFATURA = 1, USE_EARCHIVE = 0
            FROM 
            COMPANY CMP
            INNER JOIN EINVOICE_COMPANY_IMPORT ECI ON CMP.TAXNO = ECI.TAX_NO
        </cfquery>
        <cfquery name="query_fill_efatura_to_company" datasource="#dsn#">
            UPDATE CMP
            SET CMP.USE_EFATURA = 1, USE_EARCHIVE = 0
            FROM 
            CONSUMER CMP
            INNER JOIN EINVOICE_COMPANY_IMPORT ECI ON CMP.TAX_NO = ECI.TAX_NO OR CMP.TC_IDENTY_NO = ECI.TAX_NO
        </cfquery>

    </cffunction>

    <cffunction name="addEinvoiceSendingDetail" access="public">
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
        
    	<cfquery name="INS_EFATURA" datasource="#DSN2#">
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
                '#left(arguments.service_result_description,250)#',
                <cfif isdefined("arguments.status_code")>'#arguments.status_code#',</cfif>
                '#arguments.error_code#',
                #arguments.action_id#,
                '#arguments.action_type#',
                #NOW()#,
                #session.ep.userid#,
                '#cgi.REMOTE_ADDR#',
                <cfif structKeyExists(arguments,"belgeOid") and  len(arguments.belgeOid)>'#arguments.belgeOid#'<cfelse>NULL</cfif>,
               	'#arguments.invoice_type_code#'
            )
    	</cfquery> 
    </cffunction>

    <cffunction name="addEinvoiceRelation" access="public">
        <cfargument type="string" name="uuid" required="no">
        <cfargument type="string" name="integration_id" required="no">
        <cfargument type="string" name="envuuid" required="no">
        <cfargument type="string" name="einvoice_id" required="no">
        <cfargument type="numeric" name="action_id" required="no">
        <cfargument type="string" name="action_type" required="no">
        <cfargument type="string" name="profile_id" required="no">
        <cfargument type="string" name="path" required="no">
        <cfargument type="numeric" name="sender_type" required="no">
    	<cfquery name="INS_EFATURA" datasource="#DSN2#">
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
                #session.ep.userid#,
                '#cgi.REMOTE_ADDR#'
            )
       </cfquery>
    </cffunction>
</cfcomponent>