<cfscript>
	if (fusebox.use_period)
		bank_dsn = dsn3_alias;
	else
		bank_dsn = dsn_alias;
</cfscript>
<cfquery name="GET_BRANCHES" datasource="#bank_dsn#" cachedwithin="#fusebox.general_cached_time#">
	SELECT DISTINCT
		BANK_BRANCH.*,
		SETUP_BANK_TYPES.BANK_CODE
	FROM
		BANK_BRANCH,
		#dsn_alias#.SETUP_BANK_TYPES SETUP_BANK_TYPES
	WHERE
		BANK_BRANCH.BANK_ID = SETUP_BANK_TYPES.BANK_ID AND
		BANK_BRANCH.BANK_BRANCH_ID IS NOT NULL
	<cfif isDefined("attributes.bank") and len(attributes.bank)>
		AND BANK_BRANCH.BANK_NAME = '#attributes.bank#'
	</cfif>
	<cfif not isdefined("attributes.is_bank_account")>
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND
			(
				BANK_BRANCH.BANK_BRANCH_NAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
				BANK_BRANCH.BRANCH_CODE LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
				BANK_BRANCH.BANK_BRANCH_CITY LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
				BANK_BRANCH.BANK_BRANCH_ADDRESS LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
				BANK_BRANCH.CONTACT_PERSON LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
			)
		</cfif>
	</cfif>
	ORDER BY
		BANK_BRANCH.BANK_BRANCH_NAME
</cfquery>
