<cfquery name="get_quiz_relation" datasource="#DSN#">
	SELECT
		QUIZ_ID,
		QUIZ_HEAD,
		TRAINING_ID,
		CLASS_ID
	FROM
		QUIZ_RELATION
	WHERE
		QUIZ_ID IS NOT NULL
		<cfif isdefined("attributes.TRAINING_ID")>
		AND TRAINING_ID IN(#attributes.TRAINING_ID#)
		<cfelseif isdefined("attributes.class_id") and Len(attributes.class_id)>
		AND CLASS_ID = #attributes.class_id#
		</cfif>	
</cfquery>

