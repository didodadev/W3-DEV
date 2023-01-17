<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">

    <cffunction name="getData" access="public" returntype="query">
        <cfargument name="getData" default="">
        <cfquery name="getData" datasource="#dsn3#">
			SELECT 
                *
            FROM 
                #dsn3#.SUBSCRIPTION_UPGRADES
		</cfquery>
        <cfreturn getData>
	</cffunction>
</cfcomponent>