<cfinclude template="get_quiz_chapter.cfm">
<cfquery name="GET_QUESTION" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		EMPLOYEE_QUIZ_QUESTION
	WHERE
		CHAPTER_ID=#attributes.CHAPTER_ID#
</cfquery>		

<cfloop query="GET_QUESTION">
<cfloop from="1" to="20" index="i">
	<cfif len(evaluate("get_question.ANSWER#i#_photo"))>
		<!--- <cftry>
			<cffile action="DELETE" file="#upload_folder#hr#dir_seperator##evaluate("get_question.ANSWER#i#_photo")#">
			<cfcatch type="Any">
				<cfoutput>Dosya bulunamadı ama veritabanından silindi !</cfoutput>
			</cfcatch>
		</cftry> --->
	<cf_del_server_file output_file="hr/#evaluate("get_question.ANSWER#i#_photo")#" output_server="#evaluate("get_question.ANSWER#i#_photo_server_id")#">
	</cfif>
</cfloop>
</cfloop>

<cfquery name="DEL_QUESTION" datasource="#dsn#">
	DELETE FROM EMPLOYEE_QUIZ_QUESTION WHERE CHAPTER_ID=#attributes.CHAPTER_ID#
</cfquery>	
		
<cfloop from="1" to="20" index="i">
	<cfif len(evaluate("GET_QUIZ_CHAPTER.ANSWER#i#_photo"))>
		<!--- <cftry>
			<cffile action="DELETE" file="#upload_folder#hr#dir_seperator##evaluate("GET_QUIZ_CHAPTER.ANSWER#i#_photo")#">
			<cfcatch type="Any">
				<cfoutput>Dosya bulunamadı ama veritabanından silindi !</cfoutput>
			</cfcatch>
		</cftry> --->
	<cf_del_server_file output_file="hr/#evaluate("get_quiz_chapter.ANSWER#i#_photo")#" output_server="#evaluate("get_quiz_chapter.ANSWER#i#_photo_server_id")#">
	</cfif>
</cfloop>

<cfquery name="DEL_CHAPTER" datasource="#dsn#">
	DELETE FROM EMPLOYEE_QUIZ_CHAPTER WHERE CHAPTER_ID=#attributes.CHAPTER_ID#
</cfquery>	

<script type="text/javascript">
	location.href = document.referrer;
</script>

<!--- <cflocation url="#request.self#?fuseaction=hr.quiz&quiz_id=#attributes.quiz_id#" addtoken="no"> --->
		
