<cfquery name="get_DEFECT_LOCATION" datasource="#dsn_ts#">
	SELECT
		*
	FROM
		SETUP_DEFECT_LOCATION
	WHERE
	DEFECT_LOCATION_ID='#attributes.DEFECT_LOCATION_ID#'
		
</cfquery>
