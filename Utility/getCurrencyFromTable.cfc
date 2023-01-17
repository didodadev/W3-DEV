<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Sevda Kurt			Developer	: Sevda Kurt		
Analys Date : 30/05/2016			Dev Date	: 30/05/2016		
Description :
	Bu utility belirtilen tablodaki kur bilgilerini, yoksa günlük kur bilgilerini döndürür. applicationStart methodunda create edilir.
Patameters :
		dsn,actionId,tableName değerlerini alır.
Used :  get_money = getCurrencyFromTable.get(
			actionId	: attributes.multi_id,
			tableName	: 'BANK_ACTION_MULTI_MONEY',
			dsn			: dsn2
		);
----------------------------------------------------------------------->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = dsn & '_' & session.ep.period_year & '_' & session.ep.company_id>
	<cffunction name="get" access="public" returntype="query">
		<cfargument name="dsn" type="string" required="yes" hint="Datasource">
        <cfargument name="actionId" type="numeric" required="yes" hint="İşlem Id">
        <cfargument name="tableName" type="string" required="yes" hint="Kur Bilgisinin Tutulduğu Tablo">
		<cfquery name="getTableMoney" datasource="#arguments.dsn#">
        	SELECT
            	MONEY_TYPE MONEY,
                RATE2,
                RATE1,
                IS_SELECTED
            FROM
            	#arguments.tableName#
            WHERE
            	ACTION_ID = #arguments.actionId#
        </cfquery>
        <cfif not getTableMoney.recordcount>
            <cfquery name="getTableMoney" datasource="#dsn2#">
                SELECT
                	MONEY,
                	RATE2,
                	RATE1,
                    0 AS IS_SELECTED
                FROM
                	SETUP_MONEY
                WHERE
                	MONEY_STATUS=1
                ORDER BY
                	MONEY_ID
            </cfquery>
        </cfif>
		<cfreturn getTableMoney>
	</cffunction>
</cfcomponent>