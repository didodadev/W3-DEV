<cfquery name="GET_POSITION_CATS" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_POSITION_CAT
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		WHERE
			POSITION_CAT LIKE '%#attributes.keyword#%'
	</cfif>
	ORDER BY 
		POSITION_CAT 
</cfquery>
