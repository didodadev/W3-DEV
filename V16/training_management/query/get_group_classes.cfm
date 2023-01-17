<cfquery name="get_tr_name" datasource="#DSN#">
	SELECT
		CLASS_ID
	FROM
		TRAINING_CLASS_GROUP_CLASSES
	WHERE
		TRAIN_GROUP_ID=#attributes.TRAIN_GROUP_ID#
	ORDER BY CLASS_ID 
</cfquery>
