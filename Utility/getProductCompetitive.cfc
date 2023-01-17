<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Gülşah Tan			Developer	: Gülşah Tan		
Analys Date : 30/05/2016			Dev Date	: 30/05/2016		
Description :
	Bu utility Ürün Fiyat yetkilerini getirir.
----------------------------------------------------------------------->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'>
    <cffunction name="get" access="public" returntype="query">
            <cfquery name="get" datasource="#dsn3#">
                SELECT COMPETITIVE_ID,COMPETITIVE FROM PRODUCT_COMP ORDER BY COMPETITIVE
            </cfquery>
		<cfreturn get>
	</cffunction>
</cfcomponent>