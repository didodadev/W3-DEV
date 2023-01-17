<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
    	<cfargument name="keyword" default="">        	
            <cfquery name="GET_PARTNER_RELATION" datasource="#dsn#">
                SELECT * FROM SETUP_PARTNER_RELATION
            </cfquery>
        <cfreturn GET_PARTNER_RELATION>
    </cffunction>
</cfcomponent> 
