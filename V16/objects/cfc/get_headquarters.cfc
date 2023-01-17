<cfcomponent>
	<cffunction name="get_headquarter" access="public" returntype="query">
		<cfargument name="keyword" default="">
		<cfargument name="maxrows" default="">
		<cfargument name="startrow" default="">
        <cfquery name="get_headquarters" datasource="#this.dsn#">
        	WITH CTE1 AS (
				SELECT 
					NAME,
					HEADQUARTERS_ID
				FROM 
					SETUP_HEADQUARTERS
				<cfif len(arguments.keyword)>
					WHERE
						NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
				</cfif>
			),
			CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (ORDER BY NAME
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
  		<cfreturn get_headquarters>
	</cffunction>
</cfcomponent>
