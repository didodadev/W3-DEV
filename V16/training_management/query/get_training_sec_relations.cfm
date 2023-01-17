<cfquery name="get_training_rel" datasource="#dsn#">
	SELECT 
		TRAIN_ID
	FROM 
		TRAINING
	WHERE
		TRAINING_SEC_ID = #attributes.TRAINING_SEC_ID#
</cfquery>

<cfquery name="get_training_class_rel" datasource="#dsn#">
	SELECT
		CLASS_ID
	FROM
		TRAINING_CLASS
	WHERE
		TRAINING_SEC_ID = #attributes.TRAINING_SEC_ID#
</cfquery>

