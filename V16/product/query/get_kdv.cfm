<cfquery name="GET_KDV" datasource="#DSN2#">
	SELECT TAX_ID, TAX FROM SETUP_TAX ORDER BY TAX
</cfquery>
