<cfquery name="VIEW_QUESTION" datasource="#dsn#">
		SELECT 
			*
		FROM 
			QUESTION
		WHERE
			QUESTION_ID= #attributes.QUESTION_ID#
</cfquery>
