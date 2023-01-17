<cfquery name="GET_SERVICE_TASK" datasource="#DSN#">
	SELECT 
		OUTSRC_PARTNER_ID,
		PROJECT_EMP_ID
	FROM
		PRO_WORKS
	WHERE
		SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#service_id#"> AND
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#">
</cfquery>
