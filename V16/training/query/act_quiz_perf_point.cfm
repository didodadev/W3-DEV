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
<script type="text/javascript">
function calc_user_point(){
user_point = 0;
	<cfoutput query="get_quiz_chapters">
		<cfset ANSWER_NUMBER_gelen = get_quiz_chapters.ANSWER_NUMBER>
		<cfset attributes.CHAPTER_ID = CHAPTER_ID>
		  <cfscript>
		  	for (i=1; i lte 20; i = i+1)
				{
				"a#i#" = evaluate("get_quiz_chapters.answer#i#_text");
				"b#i#" = evaluate("get_quiz_chapters.answer#i#_photo");
				"c#i#" = evaluate("get_quiz_chapters.answer#i#_point");
				}
		  </cfscript>
		  <cfinclude template="../query/get_quiz_questions.cfm">
		  <cfif isdefined("attributes.limit")>
			<cfquery name="GET_QUIZ_QUESTIONS" DATASOURCE="#DSN#" MAXROWS="#attributes.LIMIT#">
				SELECT 
					QUESTION.*
				FROM 
					QUIZ_QUESTIONS,
					QUESTION
				WHERE
					QUIZ_QUESTIONS.QUIZ_ID = #attributes.QUIZ_ID#
					AND
					QUIZ_QUESTIONS.QUESTION_ID = QUESTION.QUESTION_ID
			</cfquery>
		<cfelse>
			<cfquery name="GET_QUIZ_QUESTIONS" datasource="#dsn#">
				SELECT 
					QUESTION.*
				FROM 
					QUIZ_QUESTIONS,
					QUESTION
				WHERE
					QUIZ_QUESTIONS.QUIZ_ID = #attributes.QUIZ_ID#
					AND
					QUIZ_QUESTIONS.QUESTION_ID = QUESTION.QUESTION_ID
			</cfquery>
		</cfif>
		  <cfif get_quiz_questions.RecordCount>
			<cfloop query="get_quiz_questions">
				<cfset aaa = get_quiz_questions.QUESTION_ID>
				<cfif ANSWER_NUMBER_gelen NEQ 0>
					<cfset listem = "">
					<cfloop from="1" to="20" index="i">
						<cfif len(evaluate("b#i#")) or len(evaluate("a#i#"))>
							<cfset listem = listem&evaluate("c#i#")&','>
							if (document.add_perform.user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#[#i-1#].checked==true){
							user_point = user_point + Number(document.add_perform.user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point[#i-1#].value);
							}
						</cfif>
					</cfloop>
					/*testte alınabilecek en yüksek puan hesaplanıyor*/
					<cfset hesaplanan = ListLast(ListSort(listem,'numeric'))>
					<cfset quiz_point = quiz_point + hesaplanan>
				<cfelse>
					<cfset listem = "">
					<cfloop from="1" to="20" index="i">
						<cfif len(evaluate("get_quiz_questions.answer#i#_photo")) or len(evaluate("get_quiz_questions.answer#i#_text"))>
							<cfset listem = listem&evaluate('get_quiz_questions.answer'&i&'_point')&','>
							if (document.add_perform.user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#[#i-1#].checked==true){
							user_point = user_point + Number(document.add_perform.user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point[#i-1#].value);
							}
						</cfif>
					</cfloop>
					/*testte alınabilecek en yüksek puan hesaplanıyor*/
					<cfset hesaplanan = ListLast(ListSort(listem,'numeric'))>
					<cfset quiz_point = quiz_point + hesaplanan>
				</cfif>	
			</cfloop>	
		</cfif>
	</cfoutput>

document.add_perform.USER_POINT.value=user_point;
sonuc = 100*user_point/Number(document.add_perform.PERFORM_POINT.value);
if ((0 <= sonuc) && (sonuc < 12.5))
	document.add_perform.PERFORM_POINT_ID[7].checked=true;
else if ((12.5 <= sonuc) && (sonuc < 25))
	document.add_perform.PERFORM_POINT_ID[6].checked=true;
else if ((25 <= sonuc) && (sonuc < 37.5))
	document.add_perform.PERFORM_POINT_ID[5].checked=true;
else if ((37.5 <= sonuc) && (sonuc < 50))
	document.add_perform.PERFORM_POINT_ID[4].checked=true;
else if ((50 <= sonuc) && (sonuc < 62.5))
	document.add_perform.PERFORM_POINT_ID[3].checked=true;
else if ((62.5 <= sonuc) && (sonuc < 75))
	document.add_perform.PERFORM_POINT_ID[2].checked=true;
else if ((75 <= sonuc) && (sonuc < 87.5))
	document.add_perform.PERFORM_POINT_ID[1].checked=true;
else if ((87.5 <= sonuc) && (sonuc <= 100))
	document.add_perform.PERFORM_POINT_ID[0].checked=true;
}
</script>
</cfif>
