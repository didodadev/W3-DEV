<cfcomponent extends = "V16.settings.cfc.workcube_license">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="GET_RELEASE_VERSION" access="remote" returntype="any">
        <cfquery name="GET_RELEASE_VERSION" datasource="#dsn#">
            SELECT TOP 1 * FROM WRK_LICENSE ORDER BY LICENSE_ID DESC
        </cfquery>
        <cfreturn GET_RELEASE_VERSION>
    </cffunction>
    <cffunction name="GET_ONLINE_COUNT" access="remote" returntype="any">
        <cfquery name="GET_ONLINE_COUNT" datasource="#dsn#">
            select COUNT(USERID) from wrk_SESSION  GROUP BY USERID
        </cfquery>
        <cfreturn GET_ONLINE_COUNT>
    </cffunction>
    <cffunction name="DELETE_SESSION" access="remote" returntype="any">
        <cfquery name="DELETE_SESSION" datasource="#dsn#">
            delete from WRK_SESSION  where USERID <> <cfqueryparam value="#session.ep.userid#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfreturn 1>        
    </cffunction>
    <cffunction name="ADD_NEW_LICENSE" access="remote" returntype="boolean" hint="update license info on WRK_LICENSE TABLE">
        <cfargument name="upgradeMode" type="string" required="no" default="upgrade">
        <cfargument name="release_no" type="string" required="yes">
        <cfargument name="release_date" type="string" required="yes">
        <cfargument name="git_url" type="string" required="yes">
        <cfargument name="git_dir" type="string" required="yes">
        <cfargument name="git_branch" type="string" required="yes">
        <cfargument name="patch_no" type="string" required="no" default="">
        <cfargument name="patch_date" type="string" required="no" default="">

        <cfset GET_RELEASE_INFO = this.GET_RELEASE_VERSION()>
        <cfset get_license_information =  this.get_license_information() />
        
        <cfif arguments.upgradeMode eq 'upgrade'>

            <cfquery name = "INSERT_LICENSE" datasource="#dsn#" result = "result">
                INSERT INTO WRK_LICENSE(
                    WORKCUBE_ID,
                    OWNER_COMPANY_ID,
                    IMPLEMENTATION_PROJECT_ID,
                    TECHNICAL_PERSON_ID,
                    TECHNICAL_PERSON_EMPLOYEE_ID,
                    TECHNICAL_PERSON_EMPLOYEE_TITLE,
                    IMPLEMENTATION_POWER_USER_ID,
                    IMPLEMENTATION_POWER_USER_EMPLOYEE_ID,
                    IMPLEMENTATION_POWER_USER_EMPLOYEE_TITLE,
                    WORKCUBE_PARTNER_COMPANY_ID,
                    COMPANY_PARTNER,
                    WORKCUBE_PARTNER_COMPANY_TEAM_ID,
                    WORKCUBE_PARTNER_COMPANY_TEAM,
                    WORKCUBE_SUPPORT_TEAM_ID,
                    OWNER_COMPANY_EMAIL,
                    TEL,
                    EMAIL,
                    WORKCUBE_ID1,
                    LICENSE_TYPE,
                    PROJECT_ID,
                    COMPANY,
                    GOOGLE_ANALYTICS_ID,
                    PARAMS,
                    MONO,
                    PROD,
                    IS_APPROVE,
                    APPROVED_DATE,
                    APPROVED_NAME_SURNAME,
                    FAX,
                    RECORD_EMP,
                    RECORD_DATE,
                    RECORD_IP
                )VALUES(
                    <cfif len( GET_RELEASE_INFO.WORKCUBE_ID )><cfqueryparam cfsqltype = "cf_sql_nvarchar" value = "#GET_RELEASE_INFO.WORKCUBE_ID#"><cfelse>NULL</cfif>,
                    <cfif len( GET_RELEASE_INFO.OWNER_COMPANY_ID )><cfqueryparam cfsqltype = "cf_sql_integer" value = "#GET_RELEASE_INFO.OWNER_COMPANY_ID#"><cfelse>NULL</cfif>,
                    <cfif len( GET_RELEASE_INFO.IMPLEMENTATION_PROJECT_ID )><cfqueryparam cfsqltype = "cf_sql_integer" value = "#GET_RELEASE_INFO.IMPLEMENTATION_PROJECT_ID#"><cfelse>NULL</cfif>,
                    <cfif len( GET_RELEASE_INFO.TECHNICAL_PERSON_ID )><cfqueryparam cfsqltype = "cf_sql_nvarchar" value = "#GET_RELEASE_INFO.TECHNICAL_PERSON_ID#"><cfelse>NULL</cfif>,
                    <cfif len( GET_RELEASE_INFO.TECHNICAL_PERSON_EMPLOYEE_ID )><cfqueryparam cfsqltype = "cf_sql_nvarchar" value = "#GET_RELEASE_INFO.TECHNICAL_PERSON_EMPLOYEE_ID#"><cfelse>NULL</cfif>,
                    <cfif len( GET_RELEASE_INFO.TECHNICAL_PERSON_EMPLOYEE_TITLE )><cfqueryparam cfsqltype = "cf_sql_nvarchar" value = "#GET_RELEASE_INFO.TECHNICAL_PERSON_EMPLOYEE_TITLE#"><cfelse>NULL</cfif>,
                    <cfif len( GET_RELEASE_INFO.IMPLEMENTATION_POWER_USER_ID )><cfqueryparam cfsqltype = "cf_sql_nvarchar" value = "#GET_RELEASE_INFO.IMPLEMENTATION_POWER_USER_ID#"><cfelse>NULL</cfif>,
                    <cfif len( GET_RELEASE_INFO.IMPLEMENTATION_POWER_USER_EMPLOYEE_ID )><cfqueryparam cfsqltype = "cf_sql_nvarchar" value = "#GET_RELEASE_INFO.IMPLEMENTATION_POWER_USER_EMPLOYEE_ID#"><cfelse>NULL</cfif>,
                    <cfif len( GET_RELEASE_INFO.IMPLEMENTATION_POWER_USER_EMPLOYEE_TITLE )><cfqueryparam cfsqltype = "cf_sql_nvarchar" value = "#GET_RELEASE_INFO.IMPLEMENTATION_POWER_USER_EMPLOYEE_TITLE#"><cfelse>NULL</cfif>,
                    <cfif len( GET_RELEASE_INFO.WORKCUBE_PARTNER_COMPANY_ID )><cfqueryparam cfsqltype = "cf_sql_nvarchar" value = "#GET_RELEASE_INFO.WORKCUBE_PARTNER_COMPANY_ID#"><cfelse>NULL</cfif>,
                    <cfif len( GET_RELEASE_INFO.COMPANY_PARTNER )><cfqueryparam cfsqltype = "cf_sql_nvarchar" value = "#GET_RELEASE_INFO.COMPANY_PARTNER#"><cfelse>NULL</cfif>,
                    <cfif len( GET_RELEASE_INFO.WORKCUBE_PARTNER_COMPANY_TEAM_ID )><cfqueryparam cfsqltype = "cf_sql_nvarchar" value = "#GET_RELEASE_INFO.WORKCUBE_PARTNER_COMPANY_TEAM_ID#"><cfelse>NULL</cfif>,
                    <cfif len( GET_RELEASE_INFO.WORKCUBE_PARTNER_COMPANY_TEAM )><cfqueryparam cfsqltype = "cf_sql_nvarchar" value = "#GET_RELEASE_INFO.WORKCUBE_PARTNER_COMPANY_TEAM#"><cfelse>NULL</cfif>,
                    <cfif len( GET_RELEASE_INFO.WORKCUBE_SUPPORT_TEAM_ID )><cfqueryparam cfsqltype = "cf_sql_nvarchar" value = "#GET_RELEASE_INFO.WORKCUBE_SUPPORT_TEAM_ID#"><cfelse>NULL</cfif>,
                    <cfif len( GET_RELEASE_INFO.OWNER_COMPANY_EMAIL )><cfqueryparam cfsqltype = "cf_sql_nvarchar" value = "#GET_RELEASE_INFO.OWNER_COMPANY_EMAIL#"><cfelse>NULL</cfif>,
                    <cfif len( GET_RELEASE_INFO.TEL )><cfqueryparam cfsqltype = "cf_sql_nvarchar" value = "#GET_RELEASE_INFO.TEL#"><cfelse>NULL</cfif>,
                    <cfif len( GET_RELEASE_INFO.EMAIL )><cfqueryparam cfsqltype = "cf_sql_nvarchar" value = "#GET_RELEASE_INFO.EMAIL#"><cfelse>NULL</cfif>,
                    <cfif len( GET_RELEASE_INFO.WORKCUBE_ID1 )><cfqueryparam cfsqltype = "cf_sql_nvarchar" value = "#GET_RELEASE_INFO.WORKCUBE_ID1#"><cfelse>NULL</cfif>,
                    <cfif len( GET_RELEASE_INFO.LICENSE_TYPE )><cfqueryparam cfsqltype = "cf_sql_nvarchar" value = "#GET_RELEASE_INFO.LICENSE_TYPE#"><cfelse>NULL</cfif>,
                    <cfif len( GET_RELEASE_INFO.PROJECT_ID )><cfqueryparam cfsqltype = "cf_sql_nvarchar" value = "#GET_RELEASE_INFO.PROJECT_ID#"><cfelse>NULL</cfif>,
                    <cfif len( GET_RELEASE_INFO.COMPANY )><cfqueryparam cfsqltype = "cf_sql_nvarchar" value = "#GET_RELEASE_INFO.COMPANY#"><cfelse>NULL</cfif>,
                    <cfif len( GET_RELEASE_INFO.GOOGLE_ANALYTICS_ID )><cfqueryparam cfsqltype = "cf_sql_nvarchar" value = "#GET_RELEASE_INFO.GOOGLE_ANALYTICS_ID#"><cfelse>NULL</cfif>,
                    <cfif len( GET_RELEASE_INFO.PARAMS )><cfqueryparam cfsqltype = "cf_sql_nvarchar" value = "#GET_RELEASE_INFO.PARAMS#"><cfelse>NULL</cfif>,
                    <cfif len( GET_RELEASE_INFO.MONO )><cfqueryparam cfsqltype = "cf_sql_nvarchar" value = "#GET_RELEASE_INFO.MONO#"><cfelse>NULL</cfif>,
                    <cfif len( GET_RELEASE_INFO.PROD )><cfqueryparam cfsqltype = "cf_sql_nvarchar" value = "#GET_RELEASE_INFO.PROD#"><cfelse>NULL</cfif>,
                    <cfif len( GET_RELEASE_INFO.IS_APPROVE )><cfqueryparam cfsqltype = "cf_sql_nvarchar" value = "#GET_RELEASE_INFO.IS_APPROVE#"><cfelse>NULL</cfif>,
                    <cfif len( GET_RELEASE_INFO.APPROVED_DATE )><cfqueryparam cfsqltype = "cf_sql_nvarchar" value = "#GET_RELEASE_INFO.APPROVED_DATE#"><cfelse>NULL</cfif>,
                    <cfif len( GET_RELEASE_INFO.APPROVED_NAME_SURNAME )><cfqueryparam cfsqltype = "cf_sql_nvarchar" value = "#GET_RELEASE_INFO.APPROVED_NAME_SURNAME#"><cfelse>NULL</cfif>,
                    <cfif len( GET_RELEASE_INFO.FAX )><cfqueryparam cfsqltype = "cf_sql_nvarchar" value = "#GET_RELEASE_INFO.FAX#"><cfelse>NULL</cfif>,
                    #session.ep.userid#,
                    #now()#,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                )
            </cfquery>

            <cfquery name = "UPDATE_LICENSE" datasource = "#dsn#">
                UPDATE WRK_LICENSE SET
                    RELEASE_NO = <cfqueryparam value="#arguments.release_no#" cfsqltype="cf_sql_varchar">,
                    RELEASE_DATE = <cfqueryparam value="#arguments.release_date#" cfsqltype="cf_sql_varchar">,
                    GIT_URL = <cfqueryparam value="#arguments.git_url#" cfsqltype="cf_sql_varchar">,
                    GIT_DIR = <cfqueryparam value="#arguments.git_dir#" cfsqltype="cf_sql_varchar">,
                    GIT_BRANCH = <cfqueryparam value="#arguments.git_branch#" cfsqltype="cf_sql_varchar">,
                    UPDATE_EMP = #session.ep.userid#,
                    UPDATE_DATE = #now()#,
                    UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                WHERE LICENSE_ID = #result.identitycol#
            </cfquery>

            <cfquery name="UPDATE_PARAMS_COL" datasource="#dsn#">
                UPDATE WRK_SYSTEM_PARAMS 
                SET RELEASE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.release_no#">
                WHERE WSP_DOMAIN = <cfqueryparam value="#cgi.server_name#">
            </cfquery>
        
        <cfelse>

            <cfquery name = "UPDATE_LICENSE" datasource = "#dsn#">
                UPDATE WRK_LICENSE SET
                    PATCH_NO = <cfqueryparam value="#arguments.patch_no#" cfsqltype="cf_sql_varchar">,
                    PATCH_DATE = <cfqueryparam value="#arguments.patch_date#" cfsqltype="cf_sql_varchar">,
                    UPDATE_EMP = #session.ep.userid#,
                    UPDATE_DATE = #now()#,
                    UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                WHERE LICENSE_ID = #GET_RELEASE_INFO.LICENSE_ID#
            </cfquery>

        </cfif>

        <cfscript>
            httpReq = createObject("component", "http");
            httpReq.setMethod( "post" );
            httpReq.setCharset( "utf-8" );
            httpReq.setResult( "objPost" );
            httpReq.setUrl("https://networg.workcube.com/wex.cfm/subUpgradeInfo/setUpgradeInfo");
            httpReq.addParam( type="formfield", name="subscription_no", value="#get_license_information.WORKCUBE_ID#" );
            httpReq.addParam( type="formfield", name="domain", value="#cgi.HTTP_HOST#" );
            httpReq.addParam( type="formfield", name="release", value="#arguments.release_no#" );
            httpReq.addParam( type="formfield", name="branch", value="releases/#arguments.release_no#");
            httpReq.addParam( type="formfield", name="upgrade_date", value="#arguments.release_date#");
            httpReq.addParam( type="formfield", name="upgrade_type", value="#arguments.upgradeMode#");
            httpReq.addParam( type="formfield", name="upgrade_emp_id", value="#session.ep.userid#" );
            httpReq.addParam( type="formfield", name="upgrade_user_name_surname", value="#session.ep.name# #session.ep.surname#" );
            httpReq.addParam( type="formfield", name="upgrade_user_email", value="#session.ep.company_email#" );
        </cfscript>

        
        <cfreturn true> 
        
    </cffunction>
</cfcomponent>