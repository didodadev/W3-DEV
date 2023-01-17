<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Fatih Ayık		
Analys Date : 24/05/2016			Dev Date	: 24/05/2016		
Description :
	Bu utility bakım planı kategorilerini getirir applicationStart methodunda create edilir.
	
Patameters : Yok.

Used : getServiceCarePlanCat.get();
----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'>
    <cffunction name="get" access="public" returntype="query">
        
		<cfquery name="get" datasource="#DSN3#">
            SELECT SERVICE_CARECAT_ID, SERVICE_CARE FROM SERVICE_CARE_CAT ORDER BY SERVICE_CARE
        </cfquery>
        
		<cfreturn get>
	</cffunction>
</cfcomponent>