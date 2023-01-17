<cfcomponent>
	<cffunction name="get_groups" access="public" returntype="query">
		<cfargument name="group_id" type="numeric">
		<cfargument name="keyword" type="string">
		<cfquery name="get_employee_group" datasource="#this.dsn#">
			SELECT
				GROUP_ID,
				GROUP_NAME,
				RECORD_EMP,
				RECORD_DATE,
				UPDATE_EMP,
				UPDATE_DATE
			FROM
				EMPLOYEES_PUANTAJ_GROUP
			WHERE
				GROUP_NAME IS NOT NULL
				<cfif isdefined('arguments.group_id') and len(arguments.group_id)>
					AND GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.group_id#">
				</cfif>
				<cfif isdefined('arguments.keyword') and len(arguments.keyword)>
					AND GROUP_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
				</cfif>
           ORDER BY
           		GROUP_NAME
		</cfquery>
		<cfreturn get_employee_group>
	</cffunction>
</cfcomponent>
