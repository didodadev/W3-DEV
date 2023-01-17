<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="getRelatedBrands" access="public" returntype="query">
		<cfargument name="company_id" type="numeric" required="no" default="0">
		<cfargument name="sortdir" type="string" required="no" default="ASC">
		<cfargument name="sortfield" type="string" required="no" default="">
		<cfquery name="get_related_brands" datasource="#dsn#">
			SELECT 
				*
			FROM 
				RELATED_BRANDS
			WHERE
				1 = 1
				<cfif arguments.company_id gt 0>
					AND RELATED_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
				</cfif>
		</cfquery>
		<cfreturn get_related_brands>
	</cffunction> 
</cfcomponent>

