<cfquery name="get_size_name" datasource="#dsn_ts#">
	SELECT
		SSN.SIZE_TYPE_ID, 
		SSN.SIZE_NAME,
		SSD.SIZE_TYPE_NAME,
		SSN.SIZE_NAME_DETAIL,
		SSN.STATUS
	FROM
		SETUP_SIZE_NAME SSN, SETUP_SIZE_DEFINITION SSD
	WHERE
	SSN.SIZE_TYPE_ID='#attributes.SIZE_TYPE_ID#' 
	AND
	SSN.SIZE_NAME='#attributes.SIZE_NAME#' 
	
</cfquery>
