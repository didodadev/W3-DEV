<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Gülşah Tan			Developer	: Gülşah Tan		
Analys Date : 30/05/2016			Dev Date	: 30/05/2016		
Description :
	Bu utility Birimleri getirir.
----------------------------------------------------------------------->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>    
    <cffunction name="get" access="public" returntype="query">
        <cfquery name="get" datasource="#dsn#">
            SELECT 
                UNIT,
                UNIT_ID 
            FROM 
                SETUP_UNIT 
            ORDER 
                BY UNIT 
        </cfquery>
		<cfreturn get>
	</cffunction>
</cfcomponent>