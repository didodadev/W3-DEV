<cfquery name="del_questions" datasource="#dsn#">
	DELETE FROM SETUP_ALTERNATIVE_QUESTIONS WHERE QUESTION_ID = #attributes.question_id#
</cfquery>
<script type="text/javascript">
	location.href = document.referrer;
</script>
