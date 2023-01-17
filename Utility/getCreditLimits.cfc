<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Gülşah Tan			Developer	: Gülşah Tan		
Analys Date : 30/05/2016			Dev Date	: 02/06/2016		
Description :
	Bu utility Kredi Limit bilgilerini getirir.
----------------------------------------------------------------------->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>    
    <cfset dsn3 = dsn & '_' & session.ep.company_id>
    <cffunction name="get" access="public" returntype="query">
        <cfquery name="get" datasource="#dsn3#">
            SELECT 
                CR.CREDIT_LIMIT_ID, 
                CR.LIMIT_HEAD 
            FROM
                CREDIT_LIMIT CR
        </cfquery>
		<cfreturn get>
	</cffunction>
</cfcomponent>