<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Deniz Taşdemir		
Analys Date : 20/05/2016			Dev Date	: 03/06/2016		
Description :
	Bu utility Banka tablosundaki talimatlara  ait bilgileri getirir applicationStart methodunda create edilir.

----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="get" access="public" returntype="query">
        <cfargument name="id" type="numeric" default="0" required="yes" hint="Talimat ID">
        <cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
        
		<cfquery name="get" datasource="#dsn2#">
            SELECT ACTION_ID FROM BANK_ACTIONS WHERE BANK_ORDER_ID IS NOT NULL AND BANK_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id#">
        </cfquery>
        
		<cfreturn get>
	</cffunction>
</cfcomponent>