
<cfquery name="GET_QUESTION" datasource="#dsn#">
SELECT
	EMPLOYEE_QUIZ_QUESTION.*
FROM
	EMPLOYEE_QUIZ_CHAPTER,
	EMPLOYEE_QUIZ_QUESTION
WHERE
	EMPLOYEE_QUIZ_CHAPTER.QUIZ_ID=#ATTRIBUTES.QUIZ_ID# AND
	EMPLOYEE_QUIZ_CHAPTER.CHAPTER_ID=EMPLOYEE_QUIZ_QUESTION.CHAPTER_ID
</cfquery>		
<cfset chapter_list="">
<cfloop query="GET_QUESTION">
<cfif not listfind(chapter_list,get_question.chapter_id,',')>
	<cfset chapter_list=ListAppend(chapter_list,get_question.chapter_id,',')>
</cfif>

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
</cfloop>

<cfif listlen(chapter_list)>
	<cfquery name="DEL_QUESTION" datasource="#dsn#">
		DELETE FROM EMPLOYEE_QUIZ_QUESTION WHERE CHAPTER_ID IN (#chapter_list#)
	</cfquery>
	
	<cfquery name="GET_CHAPTER" datasource="#DSN#">
	SELECT
		* 
	FROM
		EMPLOYEE_QUIZ_CHAPTER
	WHERE
		CHAPTER_ID IN (#chapter_list#)
	</cfquery>
	
	
	<cfloop query="GET_QUESTION">
	<cfloop from="1" to="20" index="i">
		<cfif len(evaluate("GET_CHAPTER.ANSWER#i#_photo"))>
			<cftry>
				<cffile action="DELETE" file="#upload_folder#hr#dir_seperator##evaluate("GET_CHAPTER.ANSWER#i#_photo")#">
				<cfcatch type="Any">
					<cfoutput>Dosya bulunamadı ama veritabanından silindi !</cfoutput>
				</cfcatch>
			</cftry>
		</cfif>
	</cfloop>
	</cfloop>
	
		<cfquery name="DEL_QUESTION" datasource="#dsn#">
		DELETE FROM EMPLOYEE_QUIZ_CHAPTER WHERE CHAPTER_ID IN (#chapter_list#)
		</cfquery>

</cfif>

<cfquery name="DEL_QUIZ" datasource="#dsn#">
DELETE 
FROM
	EMPLOYEE_QUIZ
WHERE
QUIZ_ID = #QUIZ_ID#
</cfquery>

<script type="text/javascript">
	opener.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=training_management.list_training_eval';
	window.close();
</script>

