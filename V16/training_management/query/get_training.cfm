<cfquery name="GET_TRAININGS" datasource="#dsn#">
	SELECT
		*
	FROM 
		TRAINING
	WHERE
		TRAIN_DEPARTMENTS IS NOT NULL
		AND
		TRAIN_ID = #attributes.TRAIN_ID#
</cfquery>
