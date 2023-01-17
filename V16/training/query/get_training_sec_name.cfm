<cfquery name="get_training_sec_name" datasource="#dsn#">
	SELECT
		SECTION_NAME
	FROM
		TRAINING_SEC
	WHERE
		TRAINING_SEC_ID = #attributes.TRAINING_SEC_ID#
</cfquery>
