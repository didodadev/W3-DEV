<cfquery name="get_training_sec_rel" datasource="#dsn#">
	SELECT 
		TRAINING_SEC_ID
	FROM 
		TRAINING_SEC
	WHERE
		TRAINING_CAT_ID = #URL.ID#
</cfquery>

