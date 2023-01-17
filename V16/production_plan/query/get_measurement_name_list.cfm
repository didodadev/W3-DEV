<cfquery name="get_measurement_name_list" datasource="#dsn_ts#">
	SELECT
		MEASUREMENT_ID,MEASUREMENT_NAME
	FROM
	   SETUP_MEASUREMENT_NAME 	
	<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
		AND
		(
		MEASUREMENT_NAME LIKE '%#attributes.KEYWORD#%'
		OR
		MEASUREMENT_DETAIL LIKE '%#attributes.KEYWORD#%'
		)
	</cfif>
</cfquery>
