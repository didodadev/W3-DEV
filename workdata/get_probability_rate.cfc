<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="getComponentFunction">
	    <cfargument name="keyword" default="">
            <cfquery name="GET_PROBABILITY_RATE" datasource="#DSN#_#session.ep.company_id#">
                SELECT * FROM SETUP_PROBABILITY_RATE
            </cfquery>
        <cfreturn GET_PROBABILITY_RATE>        
    </cffunction>
</cfcomponent>
