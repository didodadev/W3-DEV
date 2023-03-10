<cfquery name="GET_TRAINING_SEC_NAMES" datasource="#dsn#">
	SELECT
		TRAINING_CAT.TRAINING_CAT_ID,
		TRAINING_SEC.TRAINING_SEC_ID,
		TRAINING_SEC.SECTION_NAME,
		TRAINING_CAT.TRAINING_CAT
	FROM
		TRAINING_SEC,
		TRAINING_CAT
	WHERE
		TRAINING_SEC.TRAINING_CAT_ID = TRAINING_CAT.TRAINING_CAT_ID
	<cfif isdefined("attributes.D_TRAINING_SEC_ID") and len(attributes.D_TRAINING_SEC_ID)>
		AND TRAINING_SEC.TRAINING_SEC_ID = #attributes.D_TRAINING_SEC_ID#
	</cfif>
	ORDER BY
		TRAINING_CAT.TRAINING_CAT,
		TRAINING_SEC.SECTION_NAME
</cfquery>
