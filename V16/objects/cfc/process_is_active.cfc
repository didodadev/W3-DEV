<!---
    File: process_is_active.cfc
    Author: Esma R. UYSAL
    Date: 02/06/2020
    Description:
        Süreci aktif / pasif hale getirir.
--->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="PROCESS_IS_ACTIVE" access="remote"  returntype="any">
        <cfargument name="action_table" default="" required="true" type="string"> 
        <cfargument name="action_id" default="" required="true" type="numeric"> 
        <cfargument name="is_active" default="" required="true" type="numeric"> 
        <cfquery name="PROCESS_IS_ACTIVE" datasource="#dsn#">
			UPDATE PAGE_WARNINGS SET IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_active#"> WHERE ACTION_TABLE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.action_table#"> AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
        </cfquery>
        <cfreturn 1>
    </cffunction>
</cfcomponent>