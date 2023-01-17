<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Gülşah Tan			Developer	: Gülşah Tan		
Analys Date : 30/05/2016			Dev Date	: 30/05/2016		
Description :
	Bu utility KDV bilgilerini getirir.
----------------------------------------------------------------------->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>    
    <cfset dsn2 = dsn & '_' & session.ep.period_year & '_' & session.ep.company_id>
    <cffunction name="get" access="public" returntype="query">
        <cfquery name="get" datasource="#dsn2#">
            SELECT TAX_ID, TAX FROM SETUP_TAX ORDER BY TAX
        </cfquery>
		<cfreturn get>
	</cffunction>
</cfcomponent>