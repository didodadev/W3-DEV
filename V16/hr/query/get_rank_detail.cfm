<cfquery name="get_rank_detail" datasource="#dsn#">
	SELECT
		ID,
		EMPLOYEE_ID,
		GRADE,
		STEP,
		PROMOTION_START,
		PROMOTION_FINISH,
		PROMOTION_REASON,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP,
		UPDATE_EMP,
		UPDATE_DATE,
		UPDATE_IP
	FROM
		EMPLOYEES_RANK_DETAIL
	WHERE
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
</cfquery>
