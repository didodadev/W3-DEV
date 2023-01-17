<cfquery name="GET_TRAININGS" datasource="#DSN#">
	SELECT
		TC.CLASS_ID,
		TC.CLASS_NAME,
		TC.START_DATE,
		TC.FINISH_DATE,
		TCG.CLASS_GROUP_ID,
		TCG.TRAIN_GROUP_ID
	FROM
		TRAINING_CLASS_GROUP_CLASSES TCG,
		TRAINING_CLASS TC
	WHERE
		TC.CLASS_ID=TCG.CLASS_ID
	AND
		TCG.TRAIN_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_group_id#">
</cfquery>
