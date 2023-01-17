<cfquery name="get_application_location" datasource="#dsn_ts#">
	SELECT
		*
	FROM
		SETUP_APPLICATION_LOCATION
	WHERE
	APPLICATION_LOCATION_ID='#attributes.APPLICATION_LOCATION_ID#'
		
</cfquery>
