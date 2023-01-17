<cfcomponent>
	<cffunction name="get_property" access="public" returntype="query">
		<cfargument name="our_company_id" default="#session.ep.company_id#">
		<cfargument name="fuseaction_name" default="">
		<cfargument name="property_name" default="">
		<cfquery name="get_property_" datasource="#this.dsn#">
			SELECT 
				PROPERTY_VALUE,
				PROPERTY_NAME
			FROM
				FUSEACTION_PROPERTY
			WHERE
				OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.our_company_id#">
				<cfif len(arguments.fuseaction_name)>
					AND FUSEACTION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fuseaction_name#">
				</cfif>
				<cfif len(arguments.property_name)>
					AND PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.property_name#">
				</cfif>
		</cfquery>
		<cfreturn get_property_>
	</cffunction>
</cfcomponent>
