<cfquery name="get_defect_location_list" datasource="#dsn_ts#">
	SELECT
		DEFECT_LOCATION_ID,
		DEFECT_LOCATION
	FROM
		SETUP_DEFECT_LOCATION SDL
	
	<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
		AND
		(
		SDL.DEFECT_LOCATION LIKE '%#attributes.KEYWORD#%'
		OR
		SDL.DEFECT_LOCATION_DETAIL LIKE '%#attributes.KEYWORD#%'
		)
	</cfif>
</cfquery>
