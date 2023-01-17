<cfquery name="get_size_type_list" datasource="#dsn_ts#">
	SELECT
		SIZE_TYPE_ID,
		SIZE_TYPE_NAME
	FROM
		SETUP_SIZE_DEFINITION SSD
	
	<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
		AND
		(
		SSD.SIZE_TYPE_NAME LIKE '%#attributes.KEYWORD#%'
		OR
		SSD.SIZE_TYPE_DETAIL LIKE '%#attributes.KEYWORD#%'
		)
	</cfif>
</cfquery>
