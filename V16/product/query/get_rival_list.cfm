<cfquery name="get_rival_list" datasource="#dsn#">
	SELECT
		R_ID,
		RIVAL_NAME,
		RIVAL_DETAIL
	FROM
		SETUP_RIVALS
	
	<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
	WHERE
		(
			SETUP_RIVALS.RIVAL_NAME LIKE '%#attributes.KEYWORD#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
			SETUP_RIVALS.RIVAL_DETAIL LIKE '%#attributes.KEYWORD#%' COLLATE SQL_Latin1_General_CP1_CI_AI
		)
	</cfif>
	ORDER BY RIVAL_NAME
</cfquery>
