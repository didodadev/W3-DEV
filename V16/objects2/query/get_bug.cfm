<cfquery name="GET_BUG" datasource="#dsn_dev#">
	SELECT 
		B.*,
		BS.BUG_STATUS_NAME,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
	FROM
		BUG_REPORT B,
		BUG_STATUS BS,
		#dsn_alias#.EMPLOYEES E
	WHERE
		BUG_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bug_id#">
		AND
		BS.BUG_STATUS_ID = B.BUG_STATUS_ID
		AND
		E.EMPLOYEE_ID = B.UPDATE_EMP
</cfquery>
