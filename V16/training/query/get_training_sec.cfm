<cfquery name="get_training_sec" datasource="#dsn#">
	SELECT
		*
	FROM
		TRAINING_SEC
	WHERE
		TRAINING_SEC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.training_sec_id#">
</cfquery>
