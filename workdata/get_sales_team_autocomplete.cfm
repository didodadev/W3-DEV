<cffunction name="get_sales_team_autocomplete" access="public" returntype="query" output="no">
	<cfargument name="NAME" required="yes">
	<cfargument name="maxrows" required="yes">
	<cfquery name="get_sales_team_autocomplete" datasource="#dsn#">
		SELECT 
			TEAM_ID,
			TEAM_NAME AS NAME
		FROM 
			SALES_ZONES_TEAM
		WHERE 
			TEAM_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.NAME#%">
	</cfquery>
	<cfreturn get_sales_team_autocomplete>
</cffunction>



			
