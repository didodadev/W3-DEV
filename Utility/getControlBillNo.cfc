<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Deniz Taşdemir		
Analys Date : 19/05/2016			Dev Date	: 26/05/2016		
Description :
	Bu utility Muhasebe Fiş numaralarını çeker applicationStart methodunda create edilir.
	
Patameters :

Used : getControlBillNo.get();
----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cfset dsn2 = '#dsn#_#session.ep.period_year#_#session.ep.company_id#'>
	<cffunction name="get" access="public" returntype="query">
    
    	<cfquery name="get" datasource="#DSN2#">
            SELECT
                *
            FROM
                BILLS
        </cfquery>
        
        <cfreturn get>
    </cffunction>
</cfcomponent>
    