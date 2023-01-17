<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Gülşah Tan			Developer	: Gülşah Tan		
Analys Date : 26/05/2016			Dev Date	: 26/05/2016		
Description :
	Bu utility stock bilgisine göre ürün ağacını getirmek için kullanılabilir.
Used : getProductTree.get();
----------------------------------------------------------------------->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'>
    <cffunction name="get" access="public" returntype="query">
        <cfargument name="pid" type="numeric" required="yes" hint="Ürün Id">
            <cfquery name="get" datasource="#dsn3#">
                SELECT 
                    PT.PRODUCT_ID
                FROM 
                    PRODUCT_TREE PT,
                    STOCKS S
                WHERE 
                    S.STOCK_ID = PT.STOCK_ID AND
                    S.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pid#">
            </cfquery>
		<cfreturn get>
	</cffunction>
</cfcomponent>