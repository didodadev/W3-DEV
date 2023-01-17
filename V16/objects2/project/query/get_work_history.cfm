<cfquery name="GET_WORK_HISTORY" datasource="#DSN#">
	SELECT
		PRO_WORKS_HISTORY.*,
		PRO_WORK_CAT.WORK_CAT,
		SETUP_PRIORITY.*,		
		PRO_WORKS.WORK_HEAD
	FROM
		PRO_WORKS_HISTORY,
		PRO_WORK_CAT,
		SETUP_PRIORITY,	
		PRO_WORKS
	WHERE
		PRO_WORK_CAT.WORK_CAT_ID = PRO_WORKS_HISTORY.WORK_CAT_ID AND
		PRO_WORKS_HISTORY.WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_id#"> AND
		PRO_WORKS_HISTORY.WORK_PRIORITY_ID=SETUP_PRIORITY.PRIORITY_ID AND
		PRO_WORKS.WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_id#">
	ORDER BY
		PRO_WORKS_HISTORY.HISTORY_ID DESC
</cfquery>