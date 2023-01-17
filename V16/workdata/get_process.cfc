<!---
    File: get_process.cfc
    Author: Esma R. UYSAL<esmauysal@workcube.com>
    Date: 14/04/2020
    Description:
        Gelen Faction'a göre aktif olan tüm süreçleri getirir.
--->
<cfcomponent displayname="Process"  hint="Process">
    <cfset dsn = application.systemParam.systemParam().dsn>   
    <cffunction name="GET_PROCESS_TYPES" access="public" returntype="any">
        <cfargument name="faction_list" type="string" required="yes">
        <cfargument name="filter_stage" required="no" default="">
        <cfquery name="GET_PROCESS_TYPES" datasource="#dsn#">
            SELECT 
                PTR.PROCESS_ROW_ID,
                #dsn#.Get_Dynamic_Language(PTR.PROCESS_ROW_ID,'#session.ep.language#','PROCESS_TYPE_ROWS','STAGE',NULL,NULL,PTR.STAGE) AS STAGE,
                PTR.STAGE_CODE
            FROM
                PROCESS_TYPE_ROWS PTR,
                PROCESS_TYPE_OUR_COMPANY PTO,
                PROCESS_TYPE PT
            WHERE
                PT.IS_ACTIVE = 1 AND
                PT.PROCESS_ID = PTR.PROCESS_ID AND
                PT.PROCESS_ID = PTO.PROCESS_ID AND
                PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.faction_list#%">
                <cfif isdefined("arguments.filter_stage") and len(arguments.filter_stage)>
                   AND PTR.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filter_stage#">
                </cfif>
            ORDER BY
                PTR.PROCESS_ID DESC,
                PTR.LINE_NUMBER
        </cfquery>
        <cfreturn  GET_PROCESS_TYPES>
    </cffunction> 
</cfcomponent>