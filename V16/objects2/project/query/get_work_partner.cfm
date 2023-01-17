<cfquery name="GET_WORK_PARTNER" datasource="#dsn#">
	SELECT
		CP.*,
		C.FULLNAME
	FROM
		COMPANY_PARTNER CP,COMPANY C
	WHERE
		CP.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#task_partner_id#"> AND
		C.COMPANY_ID = CP.COMPANY_ID
</cfquery>
