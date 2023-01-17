<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Fatih Ayık		
Analys Date : 26/05/2016			Dev Date	: 26/05/2016		
Description :
	Bu utility kampanya tiplerini getirir applicationStart methodunda create edilir.
	
Patameters :

Used : getCampaignType.get();
----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">
    <cffunction name="get" access="public" returntype="query">
        
		<cfquery name="get" datasource="#DSN3#">
            SELECT CAMP_TYPE_ID,CAMP_TYPE FROM CAMPAIGN_TYPES ORDER BY CAMP_TYPE
        </cfquery>
        
		<cfreturn get>
	</cffunction>
</cfcomponent>