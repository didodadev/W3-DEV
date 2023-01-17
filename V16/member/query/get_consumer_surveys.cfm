<cfquery name="GET_SURVEYS" datasource="#dsn#">
	SELECT
		SURVEY.SURVEY_ID,
		SURVEY.SURVEY,
		SURVEY.SURVEY_HEAD,
		SURVEY.RECORD_DATE,
		SURVEY.STAGE_ID,
		SURVEY.RECORD_EMP
	FROM
		SURVEY
	WHERE
		SURVEY_CONSUMERS  LIKE  '%,#attributes.CONSUMER_CAT_ID#,%'
	<cfif isDefined("attributes.KEYWORD")>
		AND
		(
		SURVEY.SURVEY LIKE '%#attributes.KEYWORD#%'
		OR
		SURVEY.SURVEY_HEAD LIKE '%#attributes.KEYWORD#%'
		)
	</cfif>
</cfquery>
