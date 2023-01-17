<cfcomponent>
<cffunction name="get_main_query" returntype="query">
	<cfargument name="query_name" default="">
	<cfargument name="datasource" default="">
	<cfargument name="sql_str" default="">
	<cfargument name="order_by" default="">
	<cfargument name="startrow" default="">
	<cfargument name="maxrows" default="">
<!---	<cfset sql_str = REPLACE(sql_str,",')",",'')","ALL")>
---><cfquery datasource="#datasource#" name="get_q">

		 WITH CTE1 AS (
				#REREPLACE(sql_str,"''","'","ALL")#
			),
			CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (ORDER BY #order_by# DESC) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
				FROM
					CTE1
			)
			SELECT
				CTE2.*
			FROM
				CTE2
			WHERE
				RowNum BETWEEN #startrow# and #startrow#+(#maxrows#-1)
	</cfquery>
<!---<cfstoredproc procedure="workcube_page" datasource="#datasource#">
			<cfprocparam TYPE="IN" cfsqltype="cf_sql_text" value="#sql_str#">
			<cfprocparam TYPE="IN" cfsqltype="cf_sql_text" value="#order_by#">
			<cfprocparam TYPE="IN" cfsqltype="cf_sql_integer" value="#startrow#">
			<cfprocparam TYPE="IN" cfsqltype="cf_sql_integer" value="#maxrows#">
			<cfprocresult name="get_q">
</cfstoredproc>--->
	<cfreturn #get_q#>
</cffunction>
</cfcomponent>
