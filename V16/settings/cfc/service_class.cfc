<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>

	<cffunction name="listServiceClass" access="remote" returntype="any">
        <cfquery name="listServiceClass" datasource="#dsn#">
            SELECT 
                #dsn#.Get_Dynamic_Language(SERVICE_CLASS_ID,'#session.ep.language#','SETUP_SERVICE_CLASS','SERVICE_CLASS',NULL,NULL,SERVICE_CLASS) AS SERVICE_CLASS,
                SERVICE_CLASS_ID 
            FROM 
                SETUP_SERVICE_CLASS 
        </cfquery>
        <cfreturn listServiceClass>
    </cffunction>
    <cffunction name="getServiceClass" access="remote" returntype="any">
        <cfparam name="class_id" default="">
        <cfquery name="getServiceClass" datasource="#dsn#">
            SELECT
                #dsn#.Get_Dynamic_Language(SERVICE_CLASS_ID,'#session.ep.language#','SETUP_SERVICE_CLASS','SERVICE_CLASS',NULL,NULL,SERVICE_CLASS) AS SERVICE_CLASS,
                DETAIL,
                SPECIAL_CODE,
                RECORD_DATE,
                RECORD_IP,
                RECORD_EMP,
                UPDATE_DATE,
                UPDATE_IP,
                UPDATE_EMP
            FROM 
                SETUP_SERVICE_CLASS
            WHERE SERVICE_CLASS_ID = <cfqueryparam value="#arguments.class_id#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfreturn getServiceClass>
    </cffunction>
    <cffunction name="add_service_class" access="public" returnType="any">
        <cfset attributes = arguments>
        <cfset responseStruct = structNew()>
      <cftry>
        <cfquery name="add_service_class" datasource="#dsn#" result="r">
                SET NOCOUNT ON
                INSERT 	INTO
                    SETUP_SERVICE_CLASS
                (
                    SERVICE_CLASS,
                    DETAIL,
                    SPECIAL_CODE,
                    RECORD_DATE,
                    RECORD_IP,
                    RECORD_EMP
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.service_class_name#">,
                    <cfif len(arguments.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.special_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.special_code#"><cfelse>NULL</cfif>,
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
        <cfset responseStruct.identity = add_service_class.MAX_ID>
        <cfcatch>
            <cfset responseStruct.message = "İşlem Hatalı">
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = cfcatch>
        </cfcatch>
    </cftry>
    <cfreturn responseStruct>
</cffunction>
<cffunction name="upd_service_class"  access="public" returntype="any">
    <cfset attributes = arguments>
    <cfset responseStruct = structNew()>
    <cftry>
        <cfquery name="upd_service_class" datasource="#dsn#">
            UPDATE
                SETUP_SERVICE_CLASS
            SET  
                SERVICE_CLASS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.service_class_name#">,
                DETAIL = <cfif len(arguments.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail#"><cfelse>NULL</cfif>,
                SPECIAL_CODE =  <cfif len(arguments.special_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.special_code#"><cfelse>NULL</cfif>,
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
            WHERE
                SERVICE_CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#"> 
        </cfquery>
        <cfset responseStruct.message = "İşlem Başarılı">
        <cfset responseStruct.status = true>
        <cfset responseStruct.error = {}>
        <cfset responseStruct.identity = arguments.class_id>
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
            DELETE FROM SETUP_SERVICE_CLASS WHERE SERVICE_CLASS_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#">
        </cfquery>
        <cfset responseStruct.message = "İşlem Başarılı">
        <cfset responseStruct.status = true>
        <cfset responseStruct.error = {}>
        <cfset responseStruct.identity = arguments.class_id>
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