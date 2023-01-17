<cfinclude template="../query/get_quiz_result_count.cfm">
<cfif get_quiz_result_count.toplam gte 1>
	<script type="text/javascript">
		alert("<cf_get_lang no ='524.Bu teste katılan kullanıcı olduğu için silinemez'> !");
		window.close();
	</script>
	<cfabort>
</cfif>
<cfquery name="get_quiz_record" datasource="#dsn#">
	SELECT CLASS_ID FROM QUIZ WHERE CLASS_ID = #attributes.class_id# AND QUIZ_ID = #attributes.quiz_id#
</cfquery>
<cfquery name="get_quiz_relation_record" datasource="#dsn#">
	SELECT CLASS_ID FROM QUIZ_RELATION WHERE QUIZ_ID = #attributes.quiz_id# AND CLASS_ID = #attributes.class_id#
</cfquery>
<cfif get_quiz_relation_record.recordcount>
	<cfquery name="get_del_quiz_relation" datasource="#DSN#">
		DELETE
		FROM
			QUIZ_RELATION
		WHERE
			QUIZ_ID=#attributes.quiz_id# AND
			CLASS_ID = #attributes.class_id#
	</cfquery>
</cfif>
<cfif get_quiz_record.recordcount>
	<cfquery name="get_del_quiz" datasource="#DSN#">
		UPDATE
			QUIZ
		SET
			CLASS_ID = NULL
		WHERE
			QUIZ_ID=#attributes.quiz_id#
			AND CLASS_ID=#attributes.class_id#
	</cfquery>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
