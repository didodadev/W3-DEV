<cfquery name="GET_PROCESS_CAT" datasource="#dsn3#">
	SELECT 
		*
	FROM 
		SETUP_PROCESS_CAT
	WHERE
		PROCESS_CAT_ID = #ATTRIBUTES.PROCESS_CAT_ID#		
</cfquery>
