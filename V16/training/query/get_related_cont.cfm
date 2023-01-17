<cfquery name="GET_RELATED_TRAIN" datasource="#dsn#">
	SELECT
		T.TRAIN_HEAD,
		T.TRAIN_ID,
		TR.RELATED_ID,
		T.TRAIN_OBJECTIVE
	FROM
		TRAINING_RELATED TR,
		TRAINING T
	WHERE
		TR.RELATED_TRAINING_ID = T.TRAIN_ID 
		AND
		TR.TRAINING_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.training_id#">
</cfquery>
