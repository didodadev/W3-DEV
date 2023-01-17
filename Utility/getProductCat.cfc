<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Gülşah Tan			Developer	: Gülşah Tan	
Analys Date : 30/05/2016			Dev Date	: 30/05/2016		
Description :
	Bu utility Ürün Kategori Bilgilerini getirir.

----------------------------------------------------------------------->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>    
	<cfset dsn3 = '#dsn#_#session.ep.company_id#'>
    <cffunction name="get" access="public" returntype="query">
    <cfargument name="product_catid" type="numeric" default="0" required="yes">
    <cfargument name="hierarachy" type="string" default="" required="no">
		<cfquery name="getProductCat" datasource="#dsn3#">
            SELECT 
                PRODUCT_CATID, 
                HIERARCHY, 
                PRODUCT_CAT
            FROM
                PRODUCT_CAT
            WHERE
                PRODUCT_CATID IS NOT NULL
                <cfif arguments.product_catid neq 0>
                    AND PRODUCT_CATID = #arguments.product_catid#
                <cfelseif isDefined("arguments.hierarachy") and len(arguments.hierarachy)>
                    AND HIERARCHY = '#arguments.hierarachy#'
                </cfif>
            ORDER BY
                HIERARCHY
        </cfquery>
		<cfreturn getProductCat>
	</cffunction>
</cfcomponent>