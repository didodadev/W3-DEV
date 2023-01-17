<cfquery name="GET_TRAINING_SUBJECTS" datasource="#dsn#">
	SELECT 
		TRAIN_HEAD,
		TRAIN_ID
	FROM 
		TRAINING
</cfquery>
