<cfquery name="SET_ISREAD" datasource="#dsn3#">
	UPDATE
		SERVICE
	SET
		ISREAD = 1
	WHERE
		SERVICE_ID = #URL.ID#
</cfquery>
