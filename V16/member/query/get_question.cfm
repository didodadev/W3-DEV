<cfquery name="GET_QUESTION" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		MEMBER_QUESTION
	WHERE
		QUESTION_ID = #attributes.QUESTION_ID#
</cfquery>		

