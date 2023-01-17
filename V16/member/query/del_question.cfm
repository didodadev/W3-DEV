<!---<cfinclude template="../query/get_question.cfm">
<cfloop from="1" to="50" index="i">
	<cfif len(evaluate("get_question.ANSWER#i#_photo"))>
		<cftry>
			<!--- <cffile action="DELETE" file="#upload_folder#member#dir_seperator##evaluate("get_question.ANSWER#i#_photo")#"> --->
			<cf_del_server_file output_file="member/#evaluate("get_question.ANSWER#i#_photo")#" output_server="#evaluate("get_question.ANSWER#i#_photo_server_id")#"> 
			<cfcatch type="Any">
				<cfoutput><cf_get_lang no='18.Dosya bulunamadı ama veritabanından silindi !'></cfoutput>
			</cfcatch>
		</cftry>
	</cfif>
</cfloop>--->
<cfinclude template="../query/get_question_answers.cfm">
<cfoutput query="get_question_answers">
	<cfif len(evaluate("get_question_answers.ANSWER_photo"))>
		<cftry>
			<!--- <cffile action="DELETE" file="#upload_folder#member#dir_seperator##evaluate("get_question.ANSWER#i#_photo")#"> --->
			<cf_del_server_file output_file="member/#evaluate("get_question_answers.ANSWER_photo")#" output_server="#evaluate("get_question_answers.ANSWER_photo_server_id")#"> 
			<cfcatch type="Any">
				<cfoutput><cf_get_lang no='18.Dosya bulunamadı ama veritabanından silindi !'></cfoutput>
			</cfcatch>
		</cftry>
	</cfif>
</cfoutput>
<cfquery name="DEL_QUESTION" datasource="#dsn#">
	DELETE 
	FROM 
		MEMBER_QUESTION 
	WHERE 
		QUESTION_ID= #attributes.QUESTION_ID#
</cfquery>
<!--- soruya ait şık kayıtlarını da sil--->
<cfquery name="del_question_answers" datasource="#dsn#">
	DELETE 
	FROM 
		MEMBER_QUESTION_ANSWERS
	WHERE 
		QUESTION_ID= #attributes.QUESTION_ID#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

