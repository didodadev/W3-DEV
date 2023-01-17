<cfquery name="GET_REL_WORK" datasource="#DSN#">
	SELECT
		WORK_ID,WORK_HEAD
	FROM
		PRO_WORKS
	WHERE
		WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#upd_work.related_work_id#">
</cfquery>
