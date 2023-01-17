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
    <cfset product = 'product'>       
    <cfset dsn1 = dsn & '_' & product>
    <cffunction name="get" access="public" returntype="query">
        <cfquery name="get" datasource="#dsn1#">
            SELECT
                PRODUCT_SEGMENT_ID,
                PRODUCT_SEGMENT
            FROM
                PRODUCT_SEGMENT
            ORDER BY 
                PRODUCT_SEGMENT
        </cfquery>
		<cfreturn get>
	</cffunction>
</cfcomponent>