<cfcomponent>
	<cffunction name="get_position_name" access="public" returntype="query">
		<cfargument name="keyword" default="">
		<cfargument name="pos_name_id" default="">
		<cfargument name="startrow" default="">
		<cfargument name="maxrows" default="">
        <cfquery name="get_position_name_" datasource="#this.dsn#">
        	WITH CTE1 AS (
	            SELECT
					POSITION_NAME,
					POS_NAME_ID
				FROM
					EMPLOYEE_POSITION_NAMES
				WHERE
					POS_NAME_ID IS NOT NULL
					<cfif len(arguments.keyword)>
						AND POSITION_NAME LIKE '<cfif len(arguments.keyword) gt 1>%</cfif>#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
					</cfif>
					<cfif len(arguments.pos_name_id)>
						AND POS_NAME_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pos_name_id#">
					</cfif>
			),
			CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (ORDER BY POSITION_NAME
			) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
				FROM
					CTE1
			)
			SELECT
				CTE2.*
			FROM
				CTE2
			<cfif len(arguments.startrow) and len(arguments.maxrows)>
				WHERE
					RowNum BETWEEN #arguments.startrow# and #arguments.startrow#+(#arguments.maxrows#-1)
			</cfif>
		</cfquery>
		<cfreturn get_position_name_>
	</cffunction>
</cfcomponent>
