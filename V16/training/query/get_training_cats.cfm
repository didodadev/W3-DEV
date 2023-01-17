<cfquery name="GET_TRAINING_CATS" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		TRAINING_CAT
	ORDER BY
		TRAINING_CAT
</cfquery>
