<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Gülşah Tan			Developer	: Gülşah Tan		
Analys Date : 30/05/2016			Dev Date	: 30/05/2016		
Description :
	Bu utility Hedef Pazar bilgilerini getirir.
----------------------------------------------------------------------->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn> 
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'>
    <cffunction name="get" access="public" returntype="query">
        <cfargument name="product_id" type="numeric" default="0" required="yes">
        <cfquery name="get" datasource="#dsn3#">
            SELECT 
                TOP 1
                MAXIMUM_STOCK,
                PROVISION_TIME,
                REPEAT_STOCK_VALUE,
                MINIMUM_STOCK,
                MINIMUM_ORDER_STOCK_VALUE,
                MINIMUM_ORDER_UNIT_ID,
                IS_LIVE_ORDER,
                STRATEGY_TYPE,
                STRATEGY_ORDER_TYPE,
                BLOCK_STOCK_VALUE,
                STOCK_ACTION_ID
            FROM
                STOCK_STRATEGY
            WHERE PRODUCT_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
		</cfquery>
		<cfreturn get>
	</cffunction>
</cfcomponent>