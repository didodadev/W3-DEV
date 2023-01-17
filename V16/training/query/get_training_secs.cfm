<cfquery name="GET_TRAINING_SECS" datasource="#dsn#">
	SELECT
		*
	FROM
		TRAINING_SEC
	WHERE
		TRAINING_SEC_ID IS NOT NULL
		<cfif isDefined("attributes.TRAINING_CAT_ID") and len(attributes.TRAINING_CAT_ID) AND (attributes.TRAINING_CAT_ID neq 0)>
	AND
		TRAINING_CAT_ID = #attributes.TRAINING_CAT_ID#
		</cfif>
		<cfif isDefined("attributes.KEYWORD") and len(attributes.KEYWORD)>
	AND
		(
		SECTION_NAME LIKE '%#attributes.KEYWORD#%'
	OR
		SECTION_DETAIL LIKE '%#attributes.KEYWORD#%'
		)
		</cfif>
	ORDER BY
		SECTION_NAME
</cfquery>
