<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>

	<cffunction name="listDepartmentType" access="remote" returntype="any">
        <cfquery name="listDepartmentType" datasource="#dsn#">
            SELECT
                #dsn#.Get_Dynamic_Language(DEPARTMENT_TYPE_ID,'#session.ep.language#','SETUP_DEPARTMENT_TYPE','DEPARTMENT_TYPE',NULL,NULL,DEPARTMENT_TYPE) AS DEPARTMENT_TYPE,
                DEPARTMENT_TYPE_ID
            FROM 
                SETUP_DEPARTMENT_TYPE 
        </cfquery>
        <cfreturn listDepartmentType>
    </cffunction>
    <cffunction name="getDepartmentType" access="remote" returntype="any">
        <cfparam name="type_id" default="">
        <cfquery name="getDepartmentType" datasource="#dsn#">
            SELECT
                #dsn#.Get_Dynamic_Language(DEPARTMENT_TYPE_ID,'#session.ep.language#','SETUP_DEPARTMENT_TYPE','DEPARTMENT_TYPE',NULL,NULL,DEPARTMENT_TYPE) AS DEPARTMENT_TYPE,
                DETAIL,
                RECORD_DATE,
                RECORD_IP,
                RECORD_EMP,
                UPDATE_DATE,
                UPDATE_IP,
                UPDATE_EMP
            FROM 
                SETUP_DEPARTMENT_TYPE
            WHERE DEPARTMENT_TYPE_ID = <cfqueryparam value="#arguments.type_id#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfreturn getDepartmentType>
    </cffunction>
    <cffunction name="add_dep_type" access="public" returnType="any">
        <cfset attributes = arguments>
        <cfset responseStruct = structNew()>
      <cftry>
        <cfquery name="add_dep_type" datasource="#dsn#" result="r">
                SET NOCOUNT ON
                INSERT 	INTO
                    SETUP_DEPARTMENT_TYPE
                (
                    DEPARTMENT_TYPE,
                    DETAIL,
                    RECORD_DATE,
                    RECORD_IP,
                    RECORD_EMP
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.dep_type_name#">,
                    <cfif len(arguments.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail#"><cfelse>NULL</cfif>,
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
        <cfset responseStruct.identity = add_dep_type.MAX_ID>
        <cfcatch>
            <cfset responseStruct.message = "İşlem Hatalı">
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = cfcatch>
        </cfcatch>
    </cftry>
    <cfreturn responseStruct>
</cffunction>
<cffunction name="upd_dep_type"  access="public" returntype="any">
    <cfset attributes = arguments>
    <cfset responseStruct = structNew()>
    <cftry>
        <cfquery name="upd_dep_type" datasource="#dsn#">
            UPDATE
                SETUP_DEPARTMENT_TYPE
            SET  
                DEPARTMENT_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.dep_type_name#">,
                DETAIL = <cfif len(arguments.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail#"><cfelse>NULL</cfif>,
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
            WHERE
                DEPARTMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.type_id#"> 
        </cfquery>
        <cfset responseStruct.message = "İşlem Başarılı">
        <cfset responseStruct.status = true>
        <cfset responseStruct.error = {}>
        <cfset responseStruct.identity = arguments.type_id>
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
            DELETE FROM SETUP_DEPARTMENT_TYPE WHERE DEPARTMENT_TYPE_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.type_id#">
        </cfquery>
        <cfset responseStruct.message = "İşlem Başarılı">
        <cfset responseStruct.status = true>
        <cfset responseStruct.error = {}>
        <cfset responseStruct.identity = arguments.type_id>
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