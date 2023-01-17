<cfquery name="GET_COMMETHODS" datasource="#dsn#">
	SELECT * FROM SETUP_COMMETHOD ORDER BY COMMETHOD
</cfquery>
