<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Semih Bozal	
Analys Date : 25/05/2016			Dev Date	: 25/05/2016		
Description :
	Bu utility servis alt aşamalarını getirir applicationStart methodunda create edilir.
	
Patameters : Yok.

Used : getServiceSubStatus.get();
----------------------------------------------------------------------->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cfset dsn3 = '#dsn#_#session.ep.company_id#'>
	<cffunction name="get" access="public" returntype="query">
        <cfquery name="GET_SERVICE_SUBSTATUS" datasource="#DSN3#">
            SELECT SERVICE_SUBSTATUS_ID,SERVICE_SUBSTATUS FROM SERVICE_SUBSTATUS 
        </cfquery>
        <cfreturn get_service_substatus>
 	</cffunction>
</cfcomponent>