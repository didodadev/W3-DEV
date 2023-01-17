
<cfquery name="get_training_questions" datasource="#dsn#">
	SELECT 
		QUESTION,
		QUESTION_ID
	FROM 
		QUESTION
 <cfif isdefined("attributes.TRAINING_ID")>
	WHERE
		TRAINING_ID=#attributes.TRAINING_ID#
  <cfelseif isdefined("url.training_id")>
	WHERE
	    TRAINING_ID=#URL.TRAINING_ID#
  </cfif>
		
</cfquery>

