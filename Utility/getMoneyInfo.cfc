<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Sevda Kurt			Developer	: Sevda Kurt		
Analys Date : 24/05/2016			Dev Date	: 24/05/2016		
Description :
	Bu utility kur bilgisi döndürür. İhtiyaçlara göre parametreler eklenebilir. applicationStart methodunda create edilir.
Patameters :
		money,moneyStatus,dsn
		değerlerini alır.
Used : getMoneyInfo.get(
		money	: 'TL',
		moneyStatus	: 1,
		dsn	:	dsn2
);
----------------------------------------------------------------------->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = dsn & '_' & session.ep.period_year & '_' & session.ep.company_id>
	<cffunction name="get" access="public" returntype="query">
    	<cfargument name="moneyStatus" required="no" default="1" type="numeric" hint="Aktir/Pasif Durumu">
        <cfargument name="money" required="no" default="" type="string" hint="Para Birimi">
        <cfargument name="dsn" type="string" required="no" default="#dsn2#" hint="Datasource">
		<cfquery name="getMoney" datasource="#arguments.dsn#">
            SELECT
                MONEY,
                RATE2,
                RATE1,
                0 AS IS_SELECTED
            FROM
                SETUP_MONEY
            WHERE
                PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
                <cfif len(arguments.moneyStatus)>
                    AND MONEY_STATUS = #arguments.moneyStatus#
                </cfif>
                <cfif len(arguments.money)>
                    AND MONEY_ID = #arguments.money#
                </cfif>
            ORDER BY 
                MONEY_ID
        </cfquery>
		<cfreturn getMoney>
	</cffunction>
</cfcomponent>