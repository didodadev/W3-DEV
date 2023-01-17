<cfquery name="GET_TRAINING_SUBJECT" datasource="#DSN#">
	SELECT 
		*
	FROM 
		TRAINING
	WHERE 
		TRAIN_ID = #attributes.train_id#
</cfquery>
