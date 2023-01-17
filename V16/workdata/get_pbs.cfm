<cffunction name="get_pbs" access="public" returnType="query" output="no">
	<cfargument name="pbs_code" required="yes" type="string">
	<cfargument name="maxrows" required="yes" type="string" default="-1">
	<cfargument name="product_id" required="no" type="numeric" default="0">
	<cfargument name="project_id" required="no" type="numeric" default="0">
		<cfquery name="get_pbs_" datasource="#dsn3#" maxrows="-1">
			SELECT
				SPC.PBS_ID,
				SPC.PBS_CODE
			FROM 
				SETUP_PBS_CODE SPC
				<cfif arguments.project_id neq 0 or arguments.product_id neq 0>
					,RELATION_PBS_CODE RPC
				</cfif>
			WHERE
				SPC.PBS_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pbs_code#%">
				<cfif arguments.project_id neq 0>
					AND RPC.PBS_ID = SPC.PBS_ID
					AND RPC.PROJECT_ID = #arguments.project_id#
				<cfelseif arguments.product_id neq 0>
					AND RPC.PBS_ID = SPC.PBS_ID
					AND RPC.PRODUCT_ID = #arguments.product_id#
				</cfif>
			ORDER BY PBS_ID
		</cfquery>
	<cfreturn get_pbs_>
</cffunction>

