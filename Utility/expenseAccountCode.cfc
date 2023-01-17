<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Sevda Kurt			Developer	: Sevda Kurt		
Analys Date : 25/05/2016			Dev Date	: 25/05/2016		
Description :
	Bu utility bütçe kategorisi muhasebe hesap kodu getirir. applicationStart methodunda create edilir.
Patameters :
		expenseItemId : Bütçe Kategorisi Id
		değerlerini alır.
Used : expenseAccountCode.get(expenseItemId);
----------------------------------------------------------------------->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = dsn & '_' & session.ep.period_year & '_' & session.ep.company_id>
    <cfset dsn3 = dsn & '_' & session.ep.company_id>
	<cffunction name="get" access="public" returntype="query">
		<cfargument name="expenseItemId" type="numeric" required="yes">
		<cfquery name="getAccountCode" datasource="#dsn2#">
        	SELECT
            	ACCOUNT_CODE
            FROM
            	EXPENSE_ITEMS
            WHERE
            	EXPENSE_ITEM_ID = #arguments.expenseItemId#
        </cfquery>
		<cfreturn getAccountCode>
	</cffunction>
</cfcomponent>