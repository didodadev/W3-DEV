<cfquery name="GET_DET_INTERNALDEMAND" datasource="#dsn3#">
	SELECT 
		*
	FROM 
		INTERNALDEMAND
	WHERE
		INTERNAL_ID=#URL.ID#
</cfquery>
