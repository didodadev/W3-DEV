<cfquery name="get_reasons" datasource="#dsn#">
	SELECT REASON_ID, ALLOCATE_REASON FROM SETUP_ALLOCATE_REASON ORDER BY REASON_ID
</cfquery>
