<cfquery name="get_size_name_list" datasource="#dsn_ts#">
	SELECT
		SSN.SIZE_TYPE_ID, SSD.SIZE_TYPE_NAME,
		SSN.SIZE_NAME
	FROM
		SETUP_SIZE_NAME SSN, SETUP_SIZE_DEFINITION SSD
	WHERE
	SSN.SIZE_TYPE_ID = SSD.SIZE_TYPE_ID
	
	<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
		AND
		(
		SSN.SIZE_NAME LIKE '%#attributes.KEYWORD#%'
		OR
		SSN.SIZE_DETAIL LIKE '%#attributes.KEYWORD#%'
		)
	</cfif>
</cfquery>
