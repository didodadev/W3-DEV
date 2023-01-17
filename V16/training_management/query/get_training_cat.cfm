<cfquery name="GET_TRAINING_CAT" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		TRAINING_CAT 
	WHERE 
		TRAINING_CAT_ID=#attributes.TRAINING_CAT_ID#
</cfquery>
