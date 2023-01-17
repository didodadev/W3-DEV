<cfquery name="GET_TRAIN_EVAL" datasource="#DSN#">
	SELECT
		*
	FROM
		TRAINING_CLASS_TRAINER_EVAL
	WHERE
		CLASS_ID=#attributes.class_id#
</cfquery>
