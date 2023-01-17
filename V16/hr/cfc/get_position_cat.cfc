<cfcomponent>
	<cffunction name="get_position_cat" access="public" returntype="query">
		<cfargument name="position_cat_status" default="1">
		<cfargument name="position_cat" default="">
		<cfargument name="maxrows" default="">
		<cfargument name="startrow" default="">
        <cfquery name="get_position_cats" datasource="#this.dsn#">
        	WITH CTE1 AS (
	            SELECT
	            	POSITION_CAT_ID,
	                #this.dsn#.Get_Dynamic_Language(POSITION_CAT_ID,'#session.ep.language#','SETUP_POSITION_CAT','POSITION_CAT',NULL,NULL,POSITION_CAT) AS POSITION_CAT,
	                HIERARCHY
				FROM
	            	SETUP_POSITION_CAT
				WHERE
                	1=1
                	<cfif len(arguments.position_cat_status)>
	             	AND POSITION_CAT_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.position_cat_status#">
                    </cfif>
	             	<cfif len(arguments.position_cat)>
	             		AND POSITION_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.position_cat#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
	             	</cfif>
			),
			CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (ORDER BY POSITION_CAT
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
  		<cfreturn get_position_cats>
	</cffunction>
</cfcomponent>
