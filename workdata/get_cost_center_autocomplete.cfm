<cffunction name="get_cost_center_autocomplete" access="public" returntype="query" output="no">
	<cfargument name="NAME" required="yes">
	<cfargument name="maxrows" required="yes">
	<cfquery name="get_cost_center_autocomplete" datasource="#dsn2#">
		SELECT
			EXPENSE_ID,
			EXPENSE,
			EXPENSE AS NAME
		FROM
			EXPENSE_CENTER	
		WHERE 
			EXPENSE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.NAME#%">
	</cfquery>
	<cfreturn get_cost_center_autocomplete>
</cffunction>



			
