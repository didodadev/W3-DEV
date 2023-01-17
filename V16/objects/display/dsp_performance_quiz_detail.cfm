<!--- 
	Eski degerlendirme formlarinin detaylarini görüntülemek için düzenlenmistir.
	Egitim degerlendirme formlari özel raporunda kullanilmaktadir.
	SG 20130419
--->
<cfquery name="GET_TRAINING_PERF_DETAIL" datasource="#dsn#">		
	SELECT 
		TRAINING_PERFORMANCE.INTERVIEW_DATE, 
		EMPLOYEE_QUIZ_RESULTS.QUIZ_ID ,
		EMPLOYEE_QUIZ_RESULTS.RESULT_ID,
		TRAINING_PERFORMANCE.PERFORM_POINT,
		TRAINING_PERFORMANCE.USER_POINT
	FROM 
		TRAINING_PERFORMANCE, 
		EMPLOYEE_QUIZ_RESULTS ,
		TRAINING_CLASS 
	WHERE 
		TRAINING_PERFORMANCE.ENTRY_EMP_ID = #attributes.entry_emp_id# AND 
		TRAINING_PERFORMANCE.CLASS_ID = #attributes.class_id# AND
		TRAINING_PERFORMANCE.TRAINING_QUIZ_ID = #attributes.quiz_id# AND 
		TRAINING_PERFORMANCE.RESULT_ID = EMPLOYEE_QUIZ_RESULTS.RESULT_ID 
		AND TRAINING_PERFORMANCE.CLASS_ID = TRAINING_CLASS.CLASS_ID  
</cfquery>
<cfquery name="GET_QUIZ_INFO" datasource="#dsn#">
	SELECT 
		QUIZ_HEAD,
		IS_EXTRA_RECORD,
		IS_EXTRA_RECORD_EMP,
		IS_RECORD_TYPE,
		IS_VIEW_QUESTION,
		IS_EXTRA_QUIZ,
		IS_MANAGER_1,
		IS_MANAGER_2,
		IS_MANAGER_3,
		IS_CAREER,
		IS_TRAINING,
		IS_OPINION,
		FORM_OPEN_TYPE
	FROM 
		EMPLOYEE_QUIZ
	WHERE
		QUIZ_ID=#attributes.QUIZ_ID#
		ORDER BY QUIZ_ID
</cfquery>

<cfquery name="GET_EMP_QUIZ_ANSWERS" datasource="#dsn#">
	SELECT 
		EMPLOYEE_QUIZ_RESULTS_DETAILS.*,
		EMPLOYEE_QUIZ_RESULTS.USER_POINT
	FROM 
		EMPLOYEE_QUIZ_RESULTS_DETAILS,
		EMPLOYEE_QUIZ_RESULTS
	WHERE
		EMPLOYEE_QUIZ_RESULTS_DETAILS.RESULT_ID = EMPLOYEE_QUIZ_RESULTS.RESULT_ID
		AND EMPLOYEE_QUIZ_RESULTS_DETAILS.RESULT_ID = #attributes.result_id#
</cfquery>
<table width="100%" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
    <tr>
      <td class="headbold">Form : <cfoutput>#GET_QUIZ_INFO.QUIZ_HEAD#</cfoutput></td>
	  <td>
	  </td>
	</tr>
  </table>
  <table width="98%" align="center" cellpadding="0" cellspacing="0">
    <tr>
    <td valign="top">
    <table width="98%" cellspacing="0" cellpadding="0">
      <tr class="color-border">
      <td>
      <table width="100%" cellspacing="1" cellpadding="2">
	<tr>
	 <td class="color-row">
	  <table>
		<tr>
			<td width="100" class="txtbold"><cf_get_lang dictionary_id='35270.Eğitim Adı'></td>
			<td width="185"><cfoutput>#attributes.training_name#</cfoutput></td>
        </tr>
        <tr>
			<td width="100" class="txtbold"><cf_get_lang dictionary_id='55316.Değerlendiren'> *</td>
			<td width="185">
				<cfoutput>#get_emp_info(attributes.entry_emp_id,0,0)#</cfoutput> 
			</td>
        </tr>
		<tr>
			<td class="txtbold"><cf_get_lang dictionary_id='31940.Görüşme Tarihi'> *</td>
			<td><cfoutput>
				#DateFormat(GET_TRAINING_PERF_DETAIL.INTERVIEW_DATE,dateformat_style)#</cfoutput>
			</td>
		</tr>
       </table>
        </td>
        </tr>
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
				<cfquery datasource="#dsn#" name="chapter_expl">
					SELECT
						EXPLANATION 
					FROM
						EMPLOYEE_QUIZ_CHAPTER_EXPL
					WHERE
						CHAPTER_ID = #CHAPTER_ID#
						AND RESULT_ID = #GET_TRAINING_PERF_DETAIL.RESULT_ID#
				</cfquery>
			  <cfscript>
				for (i=1; i lte 20; i = i+1)
					{
					"a#i#" = evaluate("get_quiz_chapters.answer#i#_text");
					"b#i#" = evaluate("get_quiz_chapters.answer#i#_photo");
					"c#i#" = evaluate("get_quiz_chapters.answer#i#_point");
					}
			  </cfscript>
			  <tr class="color-list">
				<td>
				  <table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr height="20">
					  <td class="txtboldblue"><cf_get_lang dictionary_id='57995.Bölüm'> #get_quiz_chapters.currentrow#: #chapter#</td>
					</tr>
					<cfif len(chapter_info)>
					  <tr height="20" class="color-list">
						<td>#chapter_info#</td>
					  </tr>
					</cfif>
				  </table>
				</td>
			  </tr>
			  <cfquery name="GET_QUIZ_QUESTIONS" datasource="#dsn#">
					SELECT 
						*
					FROM 
						EMPLOYEE_QUIZ_QUESTION
					WHERE
						CHAPTER_ID=#attributes.CHAPTER_ID#
					ORDER BY QUESTION_ID
				</cfquery>
			  <cfif get_quiz_questions.RecordCount>
			  <tr class="color-row">
				<td>
				  <table width="100%" border="0">
					<tr class="color-list">
					  <td width="40"></td>
					   <td class="formbold" width="25">GD</td>
					  <!--- Eger cevaplar yan yana gelecekse, üst satira cevaplar yaziliyor --->
					  <cfif get_quiz_chapters.ANSWER_NUMBER NEQ 0>
						<cfloop from="1" to="20" index="i">
						  <cfif len(evaluate("answer#i#_photo")) or len(evaluate("answer#i#_text"))>
							<td class="txtbold" width="75">
							  #evaluate('answer#i#_text')#&nbsp;</td>
						  </cfif>
						</cfloop>
						<cfelse>
							<td>&nbsp;</td>
					  </cfif>
					</tr>
					<!--- Sorular basliyor --->
					<cfloop query="get_quiz_questions">
					  <cfset q_id = get_quiz_questions.QUESTION_ID>
					  <tr class="color-list" height="20">
						<td class="txtboldblue">#get_quiz_questions.currentrow#-#get_quiz_questions.question#</td>
						<td class="txtboldblue">
								<cfloop query="GET_EMP_QUIZ_ANSWERS">
									<cfif isdefined("GET_EMP_QUIZ_ANSWERS") and 
									isdefined("GET_EMP_QUIZ_ANSWERS.RESULT_ID") and 
									GET_EMP_QUIZ_ANSWERS.QUESTION_ID is q_id and 
									GET_EMP_QUIZ_ANSWERS.GD is 1> GD
									</cfif>
								</cfloop>
						</td>
						<cfif ANSWER_NUMBER_gelen neq 0>
						<cfloop from="1" to="20" index="i">
						  <cfif len(evaluate("b#i#")) or len(evaluate("a#i#"))>
							<td>
								<cfloop query="GET_EMP_QUIZ_ANSWERS">
								<cfif isdefined("GET_EMP_QUIZ_ANSWERS") and 
									isdefined("GET_EMP_QUIZ_ANSWERS.RESULT_ID") and 
									GET_EMP_QUIZ_ANSWERS.QUESTION_ID is q_id and 
									GET_EMP_QUIZ_ANSWERS.QUESTION_USER_ANSWERS is i><img src="/images/c_ok.gif"></cfif>
								</cfloop>
							</td>
						  </cfif>
						</cfloop>
					  </tr>
					  <cfelse>
					  <td></td>
					  </tr>
					  <cfloop from="1" to="20" index="i">
						<cfif len(evaluate("get_quiz_questions.answer#i#_photo")) or len(evaluate("get_quiz_questions.answer#i#_text"))>
						  <tr class="color-list">
							<td></td>
							<td><!--- <input type="checkbox" name="gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" value="1" > ---></td>
							<td>
								<cfloop query="GET_EMP_QUIZ_ANSWERS">
								<cfif IsDefined("GET_EMP_QUIZ_ANSWERS") AND 
									IsDefined("GET_EMP_QUIZ_ANSWERS.RESULT_ID") AND 
									GET_EMP_QUIZ_ANSWERS.QUESTION_ID IS q_id AND 
									GET_EMP_QUIZ_ANSWERS.QUESTION_USER_ANSWERS IS i><img src="/images/c_ok.gif"></cfif>
								</cfloop>
							  #evaluate('get_quiz_questions.answer#i#_text')#<br/>
							</td>
						  </tr>
						</cfif>
					  </cfloop>
					  </cfif>
					  <cfif len(question_info)>
						<tr height="20" class="color-list">
						  <td colspan="7"> #get_quiz_questions.question_info# </td>
						</tr>
					  </cfif>
					</cfloop>
				  </table>
				</td>
			  </tr>
			  <tr class="color-list">
				<td>
				  <table width="100%" border="0">
					<tr>
						<td class="txtboldblue" width="40"><cf_get_lang dictionary_id='57629.Açiklama'></td>
						<td>#chapter_expl.EXPLANATION#</td>
					  </tr>
				  </table>
				</td>
			  </tr>
			  <cfelse>
			  <tr height="20" class="color-row">
				<td><cf_get_lang dictionary_id='55829.Kayıtlı Soru Bulunamadı'>!</td>
			  </tr>
			</cfif>
			</cfoutput>
			<cfelse>
			<tr height="20" class="color-row">
			  <td><cf_get_lang dictionary_id='55830.Kayıtlı Bölüm Bulunamadı'>!</td>
			</tr>
			</cfif>
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
								/*testte alinabilecek en yüksek puan hesaplaniyor*/
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
								/*testte alinabilecek en yüksek puan hesaplaniyor*/
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
        <tr class="color-header" height="22">
          <td height="22" class="form-title"><cf_get_lang dictionary_id='55532.Genel Değerlendirme (İK Departmanı)'></td>
        </tr>
        <tr class="color-header" height="22">
          <td valign="top" class="color-row">
			<table width="320">
			<tr>
				<td colspan="2"><strong><cf_get_lang dictionary_id='59085.Sonuç'></strong></td>
			</tr>
			  <tr>
				<td><cf_get_lang dictionary_id='58985.Toplam Puan'></td>
				<td>
					<cfif GET_TRAINING_PERF_DETAIL.perform_point gt 0>
					<cfif GET_TRAINING_PERF_DETAIL.USER_POINT gt 0 >
						<cfset last_point = ((GET_TRAINING_PERF_DETAIL.USER_POINT / GET_TRAINING_PERF_DETAIL.PERFORM_POINT) * 100)>					
						<cfoutput>#Round(last_point)# / 100</cfoutput>
					<cfelse>
						<cfset last_point =0>
						0
					</cfif>
					<cfelse>
						<cfset last_point =0>
						0
					</cfif>
				</td> 
			  </tr> 
			</table>
          </td>
        </tr>
      </table>
      </td>
      </tr>
    </table>
    </td>
    </tr>
  </table>
<br/>
