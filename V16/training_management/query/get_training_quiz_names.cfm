<cfquery name="GET_TRAINING_QUIZ_NAMES" datasource="#dsn#">
	SELECT 
		QUIZ_ID, 
		TRAINING_ID, 
		QUIZ_HEAD,
		CLASS_ID,
		QUIZ_STARTDATE,
		QUIZ_FINISHDATE
	FROM 
		QUIZ
	WHERE
		QUIZ_ID IS NOT NULL 
		<cfif isdefined("attributes.training_id")>
			AND TRAINING_ID = #attributes.TRAINING_ID#
		<cfelseif isdefined("attributes.class_id")>
			AND CLASS_ID = #attributes.class_id#
		</cfif>
</cfquery>		

