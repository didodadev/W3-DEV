<cfquery name="get_training_sec" datasource="#dsn#">
	SELECT
		#dsn#.Get_Dynamic_Language(TRAINING_SEC_ID,'#session.ep.language#','TRAINING_SEC','SECTION_NAME',NULL,NULL,SECTION_NAME) AS SECTION_NAME,
		#dsn#.Get_Dynamic_Language(TRAINING_SEC_ID,'#session.ep.language#','TRAINING_SEC','SECTION_DETAIL',NULL,NULL,SECTION_DETAIL) AS SECTION_DETAIL,
		*
	FROM
		TRAINING_SEC
		WHERE
			TRAINING_SEC_ID = #attributes.TRAINING_SEC_ID#
</cfquery>
