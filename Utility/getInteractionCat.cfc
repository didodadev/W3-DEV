<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Fatih Ayık		
Analys Date : 19/05/2016			Dev Date	: 19/05/2016		
Description :
	Bu utility etkilesim kategorilerini getirir applicationStart methodunda create edilir.
	
Patameters :
		isServiceHelp : 1/0 destek katekorisi olarak seçilmiş etkileşim kategorilerini getirir değer gönderilmez ise tüm etkileşim kategorilerileri gelir.

Used : getInteractionCat.get(isServiceHelp:1);
----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="get" access="public" returntype="query">
        <cfargument name="isServiceHelp" type="any" default="" required="no">
        
		<cfquery name="get" datasource="#DSN#">
            SELECT 
            	INTERACTIONCAT_ID, 
                INTERACTIONCAT 
            FROM 
            	SETUP_INTERACTION_CAT 
           	<cfif len(arguments.isServiceHelp)>
                WHERE
                    IS_SERVICE_HELP = #arguments.isServiceHelp#
            </cfif>
            ORDER BY 
            	INTERACTIONCAT
        </cfquery>
        
		<cfreturn get>
	</cffunction>
</cfcomponent>