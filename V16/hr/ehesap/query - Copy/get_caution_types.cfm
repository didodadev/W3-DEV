<cfquery name="GET_CAUTION_TYPES" datasource="#dsn#">
	SELECT
		*
	FROM
	  SETUP_CAUTION_TYPE
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
	  WHERE
		CAUTION_TYPE LIKE '%#attributes.KEYWORD#%' COLLATE SQL_Latin1_General_CP1_CI_AI
	</cfif>
	ORDER BY
		CAUTION_TYPE
</cfquery>

