<cfquery name="DEL_QUESTION" datasource="#DSN#">
  DELETE FROM 
    QUESTION
  WHERE
   QUESTION_ID = #url.question_id#
  <cfif isdefined("attributes.TRAINING_ID")>
     AND
		TRAINING_ID=#attributes.TRAINING_ID#
  <cfelseif isdefined("url.training_id")>
     AND
	    TRAINING_ID=#URL.TRAINING_ID#
  </cfif>
     
</cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

