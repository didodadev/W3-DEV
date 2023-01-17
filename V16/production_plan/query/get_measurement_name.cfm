<cfquery name="get_measurement_name" datasource="#dsn_ts#">
	SELECT
		*
	FROM
		SETUP_MEASUREMENT_NAME
	WHERE
	MEASUREMENT_ID='#attributes.MEASUREMENT_ID#'
		
</cfquery>
