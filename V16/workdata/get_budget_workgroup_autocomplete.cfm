<cffunction name="get_budget_workgroup_autocomplete" access="public" returntype="query" output="no">
	<cfargument name="NAME" required="yes">
	<cfargument name="maxrows" required="yes">
	<cfquery name="get_budget_workgroup_autocomplete" datasource="#dsn#">
		SELECT 
			WORKGROUP_ID,
			WORKGROUP_NAME AS NAME
		FROM 
			WORK_GROUP
		WHERE 
			WORKGROUP_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.NAME#%">
	</cfquery>
	<cfreturn get_budget_workgroup_autocomplete>
</cffunction>



			
