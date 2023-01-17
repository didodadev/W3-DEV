<cfquery name="kontrol" datasource="#DSN#">
	SELECT
		TCQ.*

	FROM
		TRAINING_CLASS_QUIZES TCQ
	WHERE
		TCQ.CLASS_ID=#attributes.class_id#
	AND
		TCQ.QUIZ_ID=#attributes.quiz_id#
</cfquery>

<cfif not kontrol.recordcount >
	<cfquery name="ins_data" datasource="#DSN#">
		INSERT 	INTO
		TRAINING_CLASS_QUIZES
				(
				CLASS_ID,
				QUIZ_ID
				)
		VALUES
			(
				#attributes.CLASS_ID#,
				#attributes.QUIZ_ID#
			)	
	</cfquery>
</cfif>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
