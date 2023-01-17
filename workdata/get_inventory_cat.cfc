<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="getComponentFunction">
	    <cfargument name="keyword" default="">
            <cfquery name="GET_INVENTORY_CAT" datasource="#DSN#_#session.ep.company_id#">
                SELECT * FROM SETUP_INVENTORY_CAT
            </cfquery>
        <cfreturn GET_INVENTORY_CAT>        
    </cffunction>
</cfcomponent>
