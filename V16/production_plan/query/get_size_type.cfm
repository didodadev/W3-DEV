<cfquery name="get_size_type" datasource="#dsn_ts#">
	SELECT
		*
	FROM
		SETUP_SIZE_DEFINITION
	WHERE
	SIZE_TYPE_ID='#attributes.SIZE_TYPE_ID#'
		
</cfquery>
