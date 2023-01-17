<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Gülşah Tan			Developer	: Gülşah Tan		
Analys Date : 30/05/2016			Dev Date	: 30/05/2016		
Description :
	Bu utility Ürünün Fiyat bilgilerini getirir.
----------------------------------------------------------------------->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>    
	<cfset dsn3 = '#dsn#_#session.ep.company_id#'>
    <cffunction name="get" access="public" returntype="query">
        <cfargument name="product_id" type="numeric" default="" required="no">
        <cfargument name="type" type="numeric" default="1" required="yes">
            <cfquery name="get" datasource="#dsn3#">
                SELECT
                PRICE,
                PRICE_KDV,
                IS_KDV,
                MONEY 
            FROM 
                PRICE_STANDART,
                PRODUCT_UNIT
            WHERE
            	<cfif type eq 0>
                PRICE_STANDART.PURCHASESALES = 0 AND
                <cfelse>
                PRICE_STANDART.PURCHASESALES = 1 AND
                </cfif>
                PRODUCT_UNIT.IS_MAIN = 1 AND 
                PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
                PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND 
                PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID AND	
                PRICE_STANDART.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
            </cfquery>
		<cfreturn get>
	</cffunction>
</cfcomponent>