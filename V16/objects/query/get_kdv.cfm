<!--- get_kdv.cfm --->
<cfquery name="GET_KDV" datasource="#dsn2#">
	SELECT TAX_ID, TAX FROM SETUP_TAX
</cfquery>
