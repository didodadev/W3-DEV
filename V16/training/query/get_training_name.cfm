<cfquery name="GET_TRAINING_NAME" datasource="#DSN#">
	SELECT
		TT.TRAINING_SEC_ID,
		TC.TRAIN_SECTION_ID,
		TT.TRAIN_ID AS TRAINING_ID,
		TRAIN_HEAD
	FROM
		TRAINING_CLASS_SECTIONS TC,
		TRAINING TT
	WHERE
		TT.TRAIN_ID = TC.TRAIN_ID AND
		TC.CLASS_ID=#attributes.CLASS_ID#
</cfquery>
