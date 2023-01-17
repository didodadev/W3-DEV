<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Deniz Taşdemir		
Analys Date : 20/05/2016			Dev Date	: 03/06/2016		
Description :
	Bu utility kapamalara   ait bilgileri getirir applicationStart methodunda create edilir.

----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="get" access="public" returntype="query">
        <cfargument name="id" type="numeric" default="0" required="yes" hint="Kapama ID">
        
        <cfquery name="get" datasource="#DSN2#">
            SELECT P_ORDER_DEBT_AMOUNT_VALUE,P_ORDER_CLAIM_AMOUNT_VALUE FROM CARI_CLOSED WHERE CLOSED_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
        </cfquery>
		
        <cfreturn get>
	</cffunction>
</cfcomponent>
