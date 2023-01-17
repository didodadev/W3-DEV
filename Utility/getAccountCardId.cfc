<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Sevda Kurt			Developer	: Sevda Kurt		
Analys Date : 26/05/2016			Dev Date	: 26/05/2016		
Description :
	Bu utility işlem id ve işlem tipine göre muhasebe fişi id döndürür. Bu id ile ilgili tab menüden muhasebe fişi görüntülenir. applicationStart methodunda create edilir.
Patameters :
		actionId : İşlem Id
		actionTypeId : İşlem Tipi Id
		değerlerini alır.
Used : getAccountCardId.get(actionId,actionTypeId);
----------------------------------------------------------------------->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = dsn & '_' & session.ep.period_year & '_' & session.ep.company_id>
	<cffunction name="get" access="public" returntype="query">
		<cfargument name="actionId" type="numeric" required="yes" hint="İşlem Id">
        <cfargument name="actionTypeId" type="numeric" required="yes" hint="İşlem Tipi">
        <cfquery name="getCardId" datasource="#dsn2#">
        	SELECT
            	CARD_ID
            FROM
            	ACCOUNT_CARD
            WHERE
            	ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.actionId#">
                AND ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.actionTypeId#">
        </cfquery>
		<cfreturn getCardId>
	</cffunction>
</cfcomponent>