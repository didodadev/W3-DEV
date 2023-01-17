<cfset quiz_point = 0>
<cfquery name="GET_QUIZ_CHAPTERS" datasource="#dsn#">
	SELECT 
		*
	FROM 
		EMPLOYEE_QUIZ_CHAPTER
	WHERE
		QUIZ_ID=#attributes.QUIZ_ID#
</cfquery>
<cfif get_quiz_chapters.recordcount>
	<cfoutput query="get_quiz_chapters">
		<cfset ANSWER_NUMBER_gelen = get_quiz_chapters.ANSWER_NUMBER>
		<cfset attributes.CHAPTER_ID = CHAPTER_ID>
		<cfif len(get_quiz_chapters.CHAPTER_WEIGHT)>
			<cfset chapterweight = get_quiz_chapters.CHAPTER_WEIGHT>
		<cfelse>
			<cfset chapterweight = 1>
		</cfif>
		  <cfscript>
		  	for (i=1; i lte 20; i = i+1)
				{
				"a#i#" = evaluate("get_quiz_chapters.answer#i#_text");
				"b#i#" = evaluate("get_quiz_chapters.answer#i#_photo");
				"c#i#" = evaluate("get_quiz_chapters.answer#i#_point");
				}
		  </cfscript>
		 <cfquery name="GET_QUIZ_QUESTIONS" datasource="#dsn#">
			SELECT 
				*
			FROM 
				EMPLOYEE_QUIZ_QUESTION
			WHERE
				CHAPTER_ID=#attributes.CHAPTER_ID#
		</cfquery>
		  <cfif get_quiz_questions.recordcount>
			<cfloop query="get_quiz_questions">
				<cfset aaa = get_quiz_questions.QUESTION_ID>
				 <cfif ANSWER_NUMBER_gelen neq 0>
					<cfset listem = "">
					  <cfloop from="1" to="#ANSWER_NUMBER_gelen#" index="i">
						  <cfif len(evaluate("b#i#")) or len(evaluate("a#i#"))>
							<cfset listem = listem&evaluate("c#i#")&','>
						  </cfif>
					  </cfloop>
						<!--- /*testte alınabilecek en yüksek puan hesaplanıyor*/ --->
						<cfset hesaplanan = chapterweight / #get_quiz_questions.recordcount# * listlast(listsort(listem,'numeric'))>
						<cfset quiz_point = quiz_point + hesaplanan>
				 <cfelse>
					<cfset listem = "">
					  <cfloop from="1" to="#ANSWER_NUMBER_gelen#" index="i">
						  <cfif len(evaluate("get_quiz_questions.answer#i#_photo")) or len(evaluate("get_quiz_questions.answer#i#_text"))>
								<cfset listem = listem&evaluate('get_quiz_questions.answer'&i&'_point')&','>
						  </cfif>
					  </cfloop>
						<!--- /*testte alınabilecek en yüksek puan hesaplanıyor*/ --->
						<cfif not len(listem)><cfset listem=0></cfif><!---soruya şık girmeyip puna vermezse sorun oluyordu--->						
						<cfset hesaplanan = chapterweight / #get_quiz_questions.recordcount# * listlast(listsort(listem,'numeric'))>
						<cfset quiz_point = quiz_point + hesaplanan>
				 </cfif>	
			</cfloop>	
		</cfif>
	</cfoutput>
</cfif>
