<!---
    File: get_ext_worktime.cfc
    Author: Esma R. UYSAL
    Date: 02/06/2020
    Description:
        Çalışanın fazla mesailerini çeker. Gerektiği durumlarda sorgu genişletilebilir.
--->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="get_ext_worktimes" access="remote"  returntype="any">
        <cfargument name="employee_id" default="" required="true" type="string"> 
       <cfquery name="get_ext_worktimes" datasource="#dsn#">
            SELECT
                EMPLOYEES_EXT_WORKTIMES.*
            FROM
                EMPLOYEES_EXT_WORKTIMES
            WHERE
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#"> 
        </cfquery>
        <cfreturn get_ext_worktimes>
    </cffunction>
</cfcomponent>