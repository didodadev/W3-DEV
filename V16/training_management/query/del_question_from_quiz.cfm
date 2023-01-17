<cfquery name="DEL_QUESTION" datasource="#dsn#">
	DELETE FROM 
		QUIZ_QUESTIONS 
	WHERE 
		QUESTION_ID=#attributes.QUESTION_ID#
		AND
		QUIZ_ID = #attributes.QUIZ_ID#
</cfquery>
<script>
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelseif isdefined("attributes.draggable")>
		closeBoxDraggable( 'del_question_box');
		$("#list_quiz_questions .catalyst-refresh").click();
	</cfif>
</script>