<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
<<<<<<< HEAD
Analys		: Gülşah Tan			Developer	: Gülşah Tan		
Analys Date : 26/05/2016			Dev Date	: 26/05/2016		
Description :
	Bu utility fuseaction bilgisine göre süreçleri getirir liste sayfalarında süreç selectbox'ını doldurmak için kullanılabilir.
----------------------------------------------------------------------->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    
    <!--- get --->
    <cffunction name="get" access="public" returntype="query">
    	<cfargument name="objectFuseaction" type="string" default="" required="yes">
        <cfargument name="companyId" type="numeric" default="#session.ep.company_id#" required="yes">
    	
        <cfquery name="get_process_stage" datasource="#dsn#">
            SELECT
                PTR.STAGE,
                PTR.PROCESS_ROW_ID 
            FROM
                PROCESS_TYPE_ROWS PTR,
                PROCESS_TYPE_OUR_COMPANY PTO,
                PROCESS_TYPE PT
            WHERE
                PT.IS_ACTIVE = 1 AND
                PT.PROCESS_ID = PTR.PROCESS_ID AND
                PT.PROCESS_ID = PTO.PROCESS_ID AND
                PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.companyId#"> AND
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.objectFuseaction#%">
            ORDER BY
                PTR.LINE_NUMBER
        </cfquery>
        
        <cfreturn get_process_stage>
    </cffunction>
</cfcomponent>