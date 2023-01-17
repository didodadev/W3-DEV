<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="getComponentFunction">
	    <cfargument name="keyword" default="">
            <cfquery name="GET_CAMPAIGN_TYPES" datasource="#DSN#_#session.ep.company_id#">
                SELECT * FROM CAMPAIGN_TYPES  ORDER BY CAMP_TYPE
            </cfquery>
        <cfreturn GET_CAMPAIGN_TYPES>        
    </cffunction>
</cfcomponent>
