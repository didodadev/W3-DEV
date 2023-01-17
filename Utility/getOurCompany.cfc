<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Meltem Aşkın		
Analys Date : 25/05/2016			Dev Date	: 25/05/2016		
Description :
	Bu utility Şirketleri getirir  applicationStart methodunda create edilir.
	
Patameters :

Used : getOurCompany.get();
----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="get" access="public" returntype="query">
        <cfargument name="getOurCompany" type="numeric" default="0" required="no">
        <cfquery name="get" datasource="#dsn#">
            SELECT COMP_ID,COMPANY_NAME,NICK_NAME FROM OUR_COMPANY ORDER BY COMPANY_NAME
        </cfquery>
		<cfreturn get>
	</cffunction>
</cfcomponent>