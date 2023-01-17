<cfquery name="GET_COMPANY_PERIODS" datasource="#DSN#">
	SELECT PERIOD_ID,PERIOD FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> ORDER BY PERIOD_ID DESC
</cfquery>
