<cfinclude template="../query/get_eval_question.cfm">
<cfinclude template="get_eval_question.cfm">
<cfloop from="1" to="20" index="i">
	<cfif len(evaluate("get_question.ANSWER#i#_photo"))>
		<cftry>
			<cffile action="DELETE" file="#upload_folder#hr#dir_seperator##evaluate("get_question.ANSWER#i#_photo")#">
			<cfcatch type="Any">
				<cfoutput>Dosya bulunamadı ama veritabanından silindi !</cfoutput>
			</cfcatch>
		</cftry>
	</cfif>
</cfloop>

<cfquery name="DEL_QUESTION" datasource="#dsn#">
	DELETE 
	FROM 
		EMPLOYEE_QUIZ_QUESTION 
	WHERE 
		QUESTION_ID=#attributes.QUESTION_ID#
</cfquery>	
	
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

	
