<!---
    Author :        İlker Altındal
    Date :          15.02.2021
    Description :   ESerbest Meslek Makbuzu ayar ve genel veriler katmanı  
--->

<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn1 = '#dsn#_product'>
    <cfset dsn2 = '#dsn#_#session.ep.period_year#_#session.ep.company_id#'>
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'>

    <cffunction name="GetAuthorizationVars" access="public" hint="e-Serbest Meslek makbuzu entegrasyon doğrulama bilgileri">
        <cfquery name="get_authorizaton" datasource="#dsn2#">
            SELECT EVOUCHER_COMPANY_CODE, EVOUCHER_USER_NAME, EVOUCHER_PASSWORD FROM #dsn#.EVOUCHER_INTEGRATION_INFO WHERE COMP_ID = #session.ep.company_id#
        </cfquery>
        <cfset authvars = structNew()>
        <cfset authvars.corporateCode = "#get_authorizaton.EVOUCHER_COMPANY_CODE#">
        <cfset authvars.loginName = "#get_authorizaton.EVOUCHER_USER_NAME#">
        <cfset authvars.password = "#get_authorizaton.EVOUCHER_PASSWORD#">

        <cfreturn authvars>
    </cffunction>

    <cffunction name="GetEVoucherIntegrationInfo" access="public" hint="e-Serbest Meslek Makbuz entegrasyon bilgileri">
        <cfquery name="query_integrationinfo" datasource="#dsn2#">
            SELECT * FROM #dsn#.EVOUCHER_INTEGRATION_INFO WHERE COMP_ID = #session.ep.company_id#
        </cfquery>
        
        <cfreturn query_integrationinfo>
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
                OCI.EVOUCHER_DATE,
                OCI.IS_EVOUCHER
            FROM
                EVOUCHER_INTEGRATION_INFO AS ERI
                LEFT JOIN OUR_COMPANY AS C ON ERI.COMP_ID = C.COMP_ID
                JOIN OUR_COMPANY_INFO AS OCI ON C.COMP_ID = OCI.COMP_ID
            WHERE
                1=1
                <cfif len(arguments.company_id)>
                    AND C.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
                </cfif>
        </cfquery>
        <cfreturn get_our_company>
    </cffunction>

    <cffunction name="addIntegrationDefinitions" access="public" returntype="any" hint="e-Serbest Meslek Makbuzu Entegrason bilgileri">
        <cfargument type="numeric" name="evoucher_test_system" default="">
        <cfargument type="string"  name="evoucher_company_code" default="">
        <cfargument type="string"  name="evoucher_username" default="">
        <cfargument type="string"  name="evoucher_password" default="">
        <cfargument type="string"  name="evoucher_template" default="">
        <cfargument type="string"  name="evoucher_live_url" default="">
        <cfargument type="string"  name="evoucher_test_url" default="">
        <!--- özel şablon dosya kontrolü --->
        <cfif isdefined("arguments.del_template") and len(arguments.del_template)>
            <cfif fileExists('#arguments.save_folder#\evoucher_template_#session.ep.company_id#.xslt') and fileExists('#arguments.save_folder#\evoucher_template_base64_#session.ep.company_id#.xslt')>
                <cffile action="delete" file="#arguments.save_folder#\evoucher_template_#session.ep.company_id#.xslt">
                <cffile action="delete" file="#arguments.save_folder#\evoucher_template_base64_#session.ep.company_id#.xslt">
            </cfif>
          <cfquery name="DEL_TEMPLATE_FILENAME" datasource="#dsn#">
              UPDATE EVOUCHER_INTEGRATION_INFO 
              SET TEMPLATE_FILENAME = NULL,
                  TEMPLATE_FILENAME_BASE64 = NULL
              WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> 
          </cfquery>
        <cfelseif isdefined("arguments.evoucher_template") and len(arguments.evoucher_template)>
          <cftry>            
              <cfif not DirectoryExists(arguments.save_folder)>
                  <cfdirectory action = "create" directory="#arguments.save_folder#"/>
              </cfif>
              <cffile action="read" file="#arguments.evoucher_template#" variable="xslt_output" charset="utf-8">
              <cffile action="write" file="#arguments.save_folder#\evoucher_template_#session.ep.company_id#.xslt" output="#trim(xslt_output)#" charset="utf-8">
              <cfset xslt64_output = ToBase64(xslt_output)>
              <cffile action="write" file="#arguments.save_folder#\evoucher_template_base64_#session.ep.company_id#.xslt" output="#trim(xslt64_output)#" charset="utf-8">
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
                    EVOUCHER_INTEGRATION_INFO
            (
                    COMP_ID,
                    EVOUCHER_TEST_SYSTEM,
                    EVOUCHER_COMPANY_CODE,
                    EVOUCHER_USER_NAME,
                    EVOUCHER_PASSWORD,
                    TEMPLATE_FILENAME,
                    TEMPLATE_FILENAME_BASE64,
                    EVOUCHER_LIVE_URL,
                    EVOUCHER_TEST_URL
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">,
                    <cfif arguments.evoucher_test_system eq 1>1<cfelse>0</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.evoucher_company_code#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.evoucher_username#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.evoucher_password#">,
                    <cfif len(arguments.evoucher_template)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="evoucher_template_#session.ep.company_id#.xslt"><cfelse>NULL</cfif>,
                    <cfif len(arguments.evoucher_template)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="evoucher_template_base64_#session.ep.company_id#.xslt"><cfelse>NULL</cfif>,     
                    <cfqueryparam cfsqltype='CF_SQL_nvarchar' value='#arguments.evoucher_live_url#'>,
                    <cfqueryparam cfsqltype='CF_SQL_nvarchar' value='#arguments.evoucher_test_url#'>
                )
            </cfquery>
                <cfquery name="upd_our_comp" datasource="#dsn#">
                    UPDATE OUR_COMPANY_INFO 
                        SET IS_EVOUCHER = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_active#">,
                            EVOUCHER_DATE = <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.evoucher_date#">
                        WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                </cfquery>
            <cfelse>
                <cfquery name="upd" datasource="#dsn#">
                    UPDATE 
                        EVOUCHER_INTEGRATION_INFO
                    SET
                        EVOUCHER_TEST_SYSTEM = <cfif arguments.evoucher_test_system eq 1>1<cfelse>0</cfif>,
                        EVOUCHER_COMPANY_CODE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.evoucher_company_code#">,
                        EVOUCHER_USER_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.evoucher_username#">,
                        EVOUCHER_PASSWORD = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.evoucher_password#">,
                        TEMPLATE_FILENAME = <cfif len(arguments.evoucher_template)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="evoucher_template_#session.ep.company_id#.xslt"><cfelse>NULL</cfif>,
                        TEMPLATE_FILENAME_BASE64 = <cfif len(arguments.evoucher_template)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="evoucher_template_base64_#session.ep.company_id#.xslt"><cfelse>NULL</cfif>,
                        EVOUCHER_LIVE_URL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.evoucher_live_url#">,
                        EVOUCHER_TEST_URL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.evoucher_test_url#">
                    WHERE
                        COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                </cfquery>
                 <cfquery name="upd_our_comp" datasource="#dsn#">
                    UPDATE OUR_COMPANY_INFO 
                        SET IS_EVOUCHER = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_active#">,
                            EVOUCHER_DATE = <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.evoucher_date#">
                    WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                </cfquery>
            </cfif>
        </cftransaction>
        <cfreturn true />
    </cffunction>
    

</cfcomponent>