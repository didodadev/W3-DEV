<cfquery name="GET_WORK_CAT" datasource="#DSN#">
	SELECT 
		WORK_CAT_ID,
		WORK_CAT
	FROM 
		PRO_WORK_CAT
		<cfif isdefined("attributes.work_cat_id")>
			WHERE
				WORK_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_cat_id#">
		</cfif>
</cfquery>

