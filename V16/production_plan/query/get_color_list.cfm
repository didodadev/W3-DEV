<cfquery name="get_color_list" datasource="#dsn_ts#">
	SELECT
		COLOR_ID,COLOR
	FROM
	   SETUP_COLOR	
	<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
		AND
		(
		COLOR LIKE '%#attributes.KEYWORD#%'
		OR
		COLOR_DETAIL LIKE '%#attributes.KEYWORD#%'
		)
	</cfif>
</cfquery>
