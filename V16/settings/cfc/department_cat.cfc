<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>

	<cffunction name="listDepartmentCat" access="remote" returntype="any">
        <cfquery name="listDepartmentCat" datasource="#dsn#">
            SELECT 
                DEPARTMENT_CAT,
                DEPARTMENT_CAT_ID 
            FROM 
            SETUP_DEPARTMENT_CAT 
        </cfquery>
        <cfreturn listDepartmentCat>
    </cffunction>
    <cffunction name="getDepartmentCat" access="remote" returntype="any">
        <cfparam name="cat_id" default="">
        <cfquery name="getDepartmentCat" datasource="#dsn#">
            SELECT 
                DEPARTMENT_CAT,
                DETAIL,
                RECORD_DATE,
                RECORD_IP,
                RECORD_EMP,
                UPDATE_DATE,
                UPDATE_IP,
                UPDATE_EMP
            FROM 
                SETUP_DEPARTMENT_CAT
            WHERE DEPARTMENT_CAT_ID = <cfqueryparam value="#arguments.cat_id#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfreturn getDepartmentCat>
    </cffunction>
    <cffunction name="add_dep_cat" access="public" returnType="any">
        <cfset attributes = arguments>
        <cfset responseStruct = structNew()>
      <cftry>
        <cfquery name="add_dep_cat" datasource="#dsn#" result="r">
                SET NOCOUNT ON
                INSERT 	INTO
                    SETUP_DEPARTMENT_CAT
                (
                    DEPARTMENT_CAT,
                    DETAIL,
                    RECORD_DATE,
                    RECORD_IP,
                    RECORD_EMP
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.dep_cat_name#">,
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
        <cfset responseStruct.identity = add_dep_cat.MAX_ID>
        <cfcatch>
            <cfset responseStruct.message = "İşlem Hatalı">
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = cfcatch>
        </cfcatch>
    </cftry>
    <cfreturn responseStruct>
</cffunction>
<cffunction name="upd_dep_cat"  access="public" returntype="any">
    <cfset attributes = arguments>
    <cfset responseStruct = structNew()>
    <cftry>
        <cfquery name="upd_dep_cat" datasource="#dsn#">
            UPDATE
                SETUP_DEPARTMENT_CAT
            SET  
                DEPARTMENT_CAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.dep_cat_name#">,
                DETAIL = <cfif len(arguments.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail#"><cfelse>NULL</cfif>,
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
            WHERE
                DEPARTMENT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cat_id#"> 
        </cfquery>
        <cfset responseStruct.message = "İşlem Başarılı">
        <cfset responseStruct.status = true>
        <cfset responseStruct.error = {}>
        <cfset responseStruct.identity = arguments.cat_id>
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
            DELETE FROM SETUP_DEPARTMENT_CAT WHERE DEPARTMENT_CAT_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cat_id#">
        </cfquery>
        <cfset responseStruct.message = "İşlem Başarılı">
        <cfset responseStruct.status = true>
        <cfset responseStruct.error = {}>
        <cfset responseStruct.identity = arguments.cat_id>
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