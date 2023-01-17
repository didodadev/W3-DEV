<cfquery name="ins_data" datasource="#DSN#">
	DELETE
	FROM
		TRAINING_CLASS_QUIZES
	WHERE
		TRAINING_QUIZ_ID=#attributes.training_quiz_id#
</cfquery>
<cfquery name="get_ce" datasource="#DSN#">
	SELECT
		TRAINING_PERFORMANCE_ID
	FROM
		TRAINING_PERFORMANCE
	WHERE
		CLASS_ID = #attributes.class_id#
	AND
		TRAINING_QUIZ_ID = #attributes.quiz_id#
</cfquery>

<cfset sil_id=get_ce.TRAINING_PERFORMANCE_ID>
<cfif len(sil_id)>
	<cfquery name="sil_1" datasource="#DSN#">
		DELETE 
		FROM
			TRAINING_PERFORMANCE
		WHERE
			TRAINING_PERFORMANCE_ID=#sil_id#
	</cfquery>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

