<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>

	<cffunction name="listServiceTitle" access="remote" returntype="any">
        <cfquery name="listServiceTitle" datasource="#dsn#">
            SELECT 
                #dsn#.Get_Dynamic_Language(SERVICE_TITLE_ID,'#session.ep.language#','SETUP_SERVICE_TITLE','SERVICE_TITLE',NULL,NULL,SERVICE_TITLE) AS SERVICE_TITLE,
                SERVICE_TITLE_ID 
            FROM 
                SETUP_SERVICE_TITLE
        </cfquery>
        <cfreturn listServiceTitle>
    </cffunction>
    <cffunction name="getServiceTitle" access="remote" returntype="any">
        <cfparam name="title_id" default="">
        <cfquery name="getServiceTitle" datasource="#dsn#">
            SELECT
                #dsn#.Get_Dynamic_Language(SERVICE_TITLE_ID,'#session.ep.language#','SETUP_SERVICE_TITLE','SERVICE_TITLE',NULL,NULL,SERVICE_TITLE) AS SERVICE_TITLE,
                DETAIL,
                SERVICE_TITLE_CODE,
                SERVICE_CLASS_ID,
                RECORD_DATE,
                RECORD_IP,
                RECORD_EMP,
                UPDATE_DATE,
                UPDATE_IP,
                UPDATE_EMP
            FROM 
                SETUP_SERVICE_TITLE
            WHERE SERVICE_TITLE_ID = <cfqueryparam value="#arguments.title_id#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfreturn getServiceTitle>
    </cffunction>
    <cffunction name="add_service_title" access="public" returnType="any">
        <cfset attributes = arguments>
        <cfset responseStruct = structNew()>
      <cftry>
        <cfquery name="add_service_title" datasource="#dsn#" result="r">
                SET NOCOUNT ON
                INSERT 	INTO
                    SETUP_SERVICE_TITLE
                (
                    SERVICE_TITLE,
                    DETAIL,
                    SERVICE_TITLE_CODE,
                    SERVICE_CLASS_ID,
                    RECORD_DATE,
                    RECORD_IP,
                    RECORD_EMP
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.service_title_name#">,
                    <cfif len(arguments.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.special_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.special_code#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.service_class)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_class#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                )
                SELECT @@Identity AS MAX_ID      
                SET NOCOUNT OFF
        </cfquery>
        <cfset responseStruct.message = "İşlem Başarılı">
        <cfset responseStruct.status = true>
        <cfset responseStruct.error = {}>
        <cfset responseStruct.identity = add_service_title.MAX_ID>
        <cfcatch>
            <cfset responseStruct.message = "İşlem Hatalı">
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = cfcatch>
        </cfcatch>
    </cftry>
    <cfreturn responseStruct>
</cffunction>
<cffunction name="upd_service_title"  access="public" returntype="any">
    <cfset attributes = arguments>
    <cfset responseStruct = structNew()>
    <cftry>
        <cfquery name="upd_service_title" datasource="#dsn#">
            UPDATE
                SETUP_SERVICE_TITLE
            SET  
                SERVICE_TITLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.service_title_name#">,
                DETAIL = <cfif len(arguments.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail#"><cfelse>NULL</cfif>,
                SERVICE_TITLE_CODE =  <cfif len(arguments.special_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.special_code#"><cfelse>NULL</cfif>,
                SERVICE_CLASS_ID = <cfif len(arguments.service_class)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_class#"><cfelse>NULL</cfif>,
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
            WHERE
                SERVICE_TITLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.title_id#"> 
        </cfquery>
        <cfset responseStruct.message = "İşlem Başarılı">
        <cfset responseStruct.status = true>
        <cfset responseStruct.error = {}>
        <cfset responseStruct.identity = arguments.title_id>
        <cfcatch>
            <cftransaction action="rollback">
            <cfset responseStruct.message = "İşlem Hatalı">
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = cfcatch>
        </cfcatch>
    </cftry>
    <cfreturn responseStruct>
</cffunction>
<cffunction name="DEL">
    <cfset attributes = arguments>
    <cfset responseStruct = structNew()>
    <cftry>
        <cfquery name="DEL" datasource="#DSN#">
            DELETE FROM SETUP_SERVICE_TITLE WHERE SERVICE_TITLE_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.title_id#">
        </cfquery>
        <cfset responseStruct.message = "İşlem Başarılı">
        <cfset responseStruct.status = true>
        <cfset responseStruct.error = {}>
        <cfset responseStruct.identity = arguments.title_id>
        <cfcatch>
            <cftransaction action="rollback">
            <cfset responseStruct.message = "İşlem Hatalı">
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = cfcatch>
        </cfcatch>
    </cftry>
    <cfreturn responseStruct>
</cffunction>
</cfcomponent>