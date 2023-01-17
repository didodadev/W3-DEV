<cfcomponent>
	<cffunction name="getComponentFunction">
    	<cfargument name="datasource" default="">
            <cfquery name="GET_SERVICE_APP_CATS_SUB" datasource="#this.dsn3#">
                SELECT * FROM SERVICE_APPCAT_SUB
            </cfquery>	
        <cfreturn GET_SERVICE_APP_CATS_SUB>        
    </cffunction>
</cfcomponent>
