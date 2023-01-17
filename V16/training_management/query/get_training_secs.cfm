<cfquery name="GET_TRAINING_SECS" datasource="#dsn#">
	SELECT
		#dsn#.Get_Dynamic_Language(TRAINING_SEC_ID,'#session.ep.language#','TRAINING_SEC','SECTION_NAME',NULL,NULL,SECTION_NAME) AS SECTION_NAME,
		TRAINING_SEC_ID,
		TRAINING_CAT_ID,
		SECTION_DETAIL,
		RECORD_DATE
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
		SECTION_NAME LIKE '%#attributes.KEYWORD#%' COLLATE SQL_Latin1_General_CP1_CI_AI
	OR
		SECTION_DETAIL LIKE '%#attributes.KEYWORD#%' COLLATE SQL_Latin1_General_CP1_CI_AI
		)
		</cfif>
	ORDER BY
		SECTION_NAME
</cfquery>
