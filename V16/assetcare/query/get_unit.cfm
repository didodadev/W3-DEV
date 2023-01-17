<cfquery name="GET_UNIT" datasource="#DSN#">
	SELECT UNIT_ID,UNIT FROM SETUP_UNIT ORDER BY UNIT
</cfquery>
