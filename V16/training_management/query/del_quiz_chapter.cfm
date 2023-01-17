<!--- <cfinclude template="../query/get_quiz_chapter.cfm"> --->
<cfset cfc= createObject("component","V16.training_management.cfc.TrainingTest")>
<cfset GET_QUIZ_CHAPTER=cfc.GET_QUIZ_CHAPTER_FUNC(CHAPTER_ID:attributes.CHAPTER_ID)>
<cfset GET_QUESTION = cfc.GET_QUESTION_FUNC(CHAPTER_ID:attributes.CHAPTER_ID)>	

<cfloop query="GET_QUESTION">
<cfloop from="1" to="20" index="i">
	<cfif len(evaluate("get_question.ANSWER#i#_photo"))>
		<cftry>
			<cffile action="DELETE" file="#upload_folder#hr#dir_seperator##evaluate("get_question.ANSWER#i#_photo")#">
			<cfcatch type="Any">
				<cfoutput>Dosya bulunamad? ama veritaban?ndan silindi !</cfoutput>
			</cfcatch>
		</cftry>
	</cfif>
</cfloop>
</cfloop>
<cfset DEL_QUESTION=cfc.DEL_QUESTION_FUNC(CHAPTER_ID:attributes.CHAPTER_ID)>
<!--- <cfquery name="DEL_QUESTION" datasource="#dsn#">
	DELETE FROM EMPLOYEE_QUIZ_QUESTION WHERE CHAPTER_ID=#attributes.CHAPTER_ID#
</cfquery> --->	
		
<cfloop from="1" to="20" index="i">
	<cfif len(evaluate("GET_QUIZ_CHAPTER.ANSWER#i#_photo"))>
		<cftry>
			<cffile action="DELETE" file="#upload_folder#hr#dir_seperator##evaluate("GET_QUIZ_CHAPTER.ANSWER#i#_photo")#">
			<cfcatch type="Any">
				<cfoutput>Dosya bulunamad? ama veritaban?ndan silindi !</cfoutput>
			</cfcatch>
		</cftry>
	</cfif>
</cfloop>
<cfset DEL_CHAPTER=cfc.DEL_CHAPTER_FUNC(CHAPTER_ID:attributes.CHAPTER_ID)>
<!--- <cfquery name="DEL_CHAPTER" datasource="#dsn#">
	DELETE FROM 
	 WHERE CHAPTER_ID=#attributes.CHAPTER_ID#
</cfquery> --->	

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>


		
