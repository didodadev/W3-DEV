<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Gülşah Tan			Developer	: Gülşah Tan	
Analys Date : 30/05/2016			Dev Date	: 30/05/2016		
Description :
	Bu utility Ürünün stoklarını getirir.
	
Patameters :

----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'>
    <cffunction name="get" access="public" returntype="query">
        <cfargument name="product_id" type="numeric" default="0" required="yes">
        <cfargument name="barcod" type="string" default="NULL" required="no">
		<cfquery name="get" datasource="#dsn3#">
            SELECT
                STOCK_ID
            FROM
                STOCKS
            WHERE
                PRODUCT_ID = #arguments.product_id#
                <cfif isdefined("arguments.barcod") and len(arguments.BARCOD)>
                    AND	barcod = '#arguments.barcod#'
                </cfif>
        </cfquery>        
		<cfreturn get>
	</cffunction>
</cfcomponent>