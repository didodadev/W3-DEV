<cfquery name="get_application_location_list" datasource="#dsn_ts#">
	SELECT
		APPLICATION_LOCATION_ID,APPLICATION_LOCATION
	FROM
	   SETUP_APPLICATION_LOCATION
	<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
		AND
		(
		APPLICATION_LOCATIONLIKE '%#attributes.KEYWORD#%'
		OR
		APPLICATION_LOCATION_DETAIL LIKE '%#attributes.KEYWORD#%'
		)
	</cfif>
</cfquery>
