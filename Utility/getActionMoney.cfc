<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Cemil Durgan			Developer	: Cemil Durgan		
Analys Date : 06/06/2016			Dev Date	: 06/06/2016		
Description :
	İşlemlerin kur değerlerini çeker. İşlem Id sıfır yollanırsa,
	setup money tablosundakileri getirir ve ekleme sayfalarında
	kullanılabilir.
Patameters :
	tableName,
	actionId
Used : getActionMoney.get('BANK_ACTIONS_MONEY',87);
		(87 id'li banka işleminin kur bilgisi)
----------------------------------------------------------------------->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = dsn & '_' & session.ep.period_year & '_' & session.ep.company_id>
	<cffunction name="get" access="public" returntype="query">
        <cfargument name="tableName" type="string" default="0" required="yes">
        <cfargument name="actionId" type="numeric" default="0" required="no">
        <cfif arguments.actionId neq 0>
            <cfquery name="getMoney" datasource="#dsn2#">
                SELECT 
                    MONEY,
                    RATE2,
                    RATE1,
                    IS_SELECTED
                FROM
                    #arguments.tableName#
                WHERE
                    ACTION_ID = #arguments.actionId#
            </cfquery>
        <cfelse>
            <cfquery name="getMoney" datasource="#dsn2#">
                SELECT 
                    MONEY,
                    RATE2,
                    RATE1,
                    0 AS IS_SELECTED
                FROM
                    SETUP_MONEY
                WHERE
                	PERIOD_ID = #session.ep.period_id#
            </cfquery>
        </cfif>
		<cfreturn getMoney>
	</cffunction>
</cfcomponent>