<cfquery name="GET_TRAINING_SUBJECT" datasource="#dsn#">
	SELECT 
		*
	FROM 
		TRAINING
	WHERE 
		TRAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_id#">
</cfquery>
