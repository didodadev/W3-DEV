<cfquery name="GET_APP_PERF_DETAIL" datasource="#dsn#">
	SELECT 
		EMPLOYEE_PERFORMANCE_APP.*,
		EMPLOYEE_QUIZ_RESULTS.QUIZ_ID,
		EMPLOYEES_APP.NAME,
		EMPLOYEES_APP.SURNAME
	FROM 
		EMPLOYEE_PERFORMANCE_APP,
		EMPLOYEE_QUIZ_RESULTS,
		EMPLOYEES_APP
	WHERE
		EMPLOYEE_PERFORMANCE_APP.APP_PER_ID = #attributes.APP_PER_ID# AND
		EMPLOYEE_PERFORMANCE_APP.RESULT_ID = EMPLOYEE_QUIZ_RESULTS.RESULT_ID AND
		EMPLOYEE_PERFORMANCE_APP.EMP_APP_ID = EMPLOYEES_APP.EMPAPP_ID
</cfquery>

<cfif len(GET_APP_PERF_DETAIL.ENTRY_EMP_ID)>
	<cfquery name="GET_ENTRY_EMP" datasource="#dsn#">
		SELECT 
			EMPLOYEE_NAME, EMPLOYEE_SURNAME
		FROM 
			EMPLOYEES
		WHERE
			EMPLOYEE_ID = #GET_APP_PERF_DETAIL.ENTRY_EMP_ID# 
	</cfquery>
</cfif>
<cfif len(GET_APP_PERF_DETAIL.MEET_POS_CODE)>
	<cfquery name="GET_MEET_POS" datasource="#dsn#">
		SELECT 
			POSITION_NAME
		FROM 
			EMPLOYEE_POSITIONS
		WHERE
			POSITION_CODE = #GET_APP_PERF_DETAIL.MEET_POS_CODE# 
	</cfquery>
</cfif>
<cfscript>
	attributes.app_emp_id = GET_APP_PERF_DETAIL.EMP_APP_ID;
	attributes.quiz_id = GET_APP_PERF_DETAIL.quiz_id;
	attributes.app_employee_name = GET_APP_PERF_DETAIL.NAME;
	attributes.app_employee_surname = GET_APP_PERF_DETAIL.SURNAME;
</cfscript>
<cfquery name="GET_QUIZ_INFO" datasource="#dsn#">
	SELECT 
		QUIZ_HEAD,
		IS_EXTRA_RECORD,
		IS_EXTRA_RECORD_EMP,
		IS_RECORD_TYPE
	FROM 
		EMPLOYEE_QUIZ
	WHERE
		QUIZ_ID=#attributes.QUIZ_ID#
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
		AND EMPLOYEE_QUIZ_RESULTS_DETAILS.RESULT_ID IN ( #GET_APP_PERF_DETAIL.RESULT_ID# )
</cfquery>
  <table width="100%" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
    <tr>
      <td class="headbold" align="center"><cfoutput>#GET_QUIZ_INFO.QUIZ_HEAD#</cfoutput></td>
    	<!-- sil --> <td><cf_workcube_file_action pdf="0" print="1" mail="0"></td><!-- sil --> 
		<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
	</tr>
  </table>
  <table width="98%" align="center" cellpadding="0" cellspacing="0" border="1">
    <tr>
    <td valign="top">
    <table width="98%" cellspacing="0" cellpadding="0">
      <tr>
	  <td>
	  <table width="100%" cellspacing="1" cellpadding="2">
	  	<tr >
			<td width="10" class="headbold"><cf_get_lang dictionary_id='35915.DEĞERLENDİRİLECEK - FAKTÖRLER'>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;&nbsp; &nbsp;&nbsp;</td>
		<td valign="top" align="center">
      <table width="100%" cellspacing="0" cellpadding="0" border="1">
        <tr>
			<td>
      		 <table width="100%" border="0">
        <tr>
			<td class="txtbold"><cf_get_lang dictionary_id='32289.Adayın Adı Soyadı'></td>
			<td>&nbsp;<cfoutput>#attributes.app_employee_name# #attributes.app_employee_surname#</cfoutput></td>
			<td class="txtbold">&nbsp;<cf_get_lang dictionary_id='31938.Görüşülen Pozisyon'></td>
			<td>&nbsp;<cfoutput>#GET_MEET_POS.POSITION_NAME#</cfoutput></td>
        	</tr>
			</table>
			</td>
		</tr>
        <tr>
	 <td>
	  <table style="text-align:right;">
		<tr>
			<td class="txtbold"><cf_get_lang dictionary_id='31940.Görüşme Tarihi'> : </td>
			<td>
				<cfoutput>#DateFormat(GET_APP_PERF_DETAIL.INTERVIEW_DATE,dateformat_style)#</cfoutput>
			</td>
		</tr>
          </table>
        </td>
        </tr>
		<input type="hidden" name="quiz_id" id="quiz_id" value="<cfoutput>#attributes.quiz_id#</cfoutput>">
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
					AND RESULT_ID = #GET_APP_PERF_DETAIL.RESULT_ID#
			</cfquery>
		  <cfscript>
			for (i=1; i lte 20; i = i+1)
				{
				"a#i#" = evaluate("get_quiz_chapters.answer#i#_text");
				"b#i#" = evaluate("get_quiz_chapters.answer#i#_photo");
				"c#i#" = evaluate("get_quiz_chapters.answer#i#_point");
				}
		  </cfscript>
		  <tr >
			<td>
			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr height="20">
				  <td class="txtboldblue"><cf_get_lang dictionary_id='57995.Bölüm'>#get_quiz_chapters.currentrow#: #chapter#</td>
				</tr>
				<cfif len(chapter_info)>
				  <tr height="20">
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
			</cfquery>
		  <cfif get_quiz_questions.RecordCount>
		  <tr>
			<td>
			  <table width="100%" border="0">
				<tr>
				  <td width="40"></td>
				   <td class="formbold" width="25">GD</td>
				  <!--- Eger cevaplar yan yana gelecekse, üst satira cevaplar yaziliyor --->
				  <cfif get_quiz_chapters.ANSWER_NUMBER NEQ 0>
					<cfloop from="1" to="20" index="i">
					  <cfif len(evaluate("answer#i#_photo")) or len(evaluate("answer#i#_text"))>
						<td class="txtbold" align="center" width="75">
						  <cfif len(evaluate("answer"&i&"_photo"))>
						  #evaluate('answer#i#_text')#
							<!--- <img src="#file_web_path#hr/#evaluate("answer"&i&"_photo")#" border="0"> --->
							 <cf_get_server_file output_file="hr/#evaluate("answer"&i&"_photo")#" output_server="#evaluate("answer"&i&"_photo_server_id")#" output_type="0" image_width="40" image_height="50" image_link="1">
						  </cfif>
						  &nbsp;</td>
					  </cfif>
					</cfloop>
				 	<cfelse>
					<td>&nbsp;</td>
				  </cfif>
					<!--- <td class="formbold"><cf_get_lang_main no='217.AÇIKLAMA'></td> --->
				</tr>
				<!--- Sorular basliyor --->
				<cfloop query="get_quiz_questions">
				  <cfset q_id = get_quiz_questions.QUESTION_ID>
				  <tr height="20">
					<td class="txtboldblue">#get_quiz_questions.currentrow#-#get_quiz_questions.question#</td>
					<td class="txtboldblue">
						<cfloop query="GET_EMP_QUIZ_ANSWERS">
							<cfif isdefined("GET_EMP_QUIZ_ANSWERS") and 
							isdefined("GET_EMP_QUIZ_ANSWERS.RESULT_ID") and 
							GET_EMP_QUIZ_ANSWERS.QUESTION_ID is q_id and 
							GET_EMP_QUIZ_ANSWERS.GD is 1> *
							</cfif>
						</cfloop>
					</td>
					<cfif ANSWER_NUMBER_gelen neq 0>
					<cfloop from="1" to="20" index="i">
					  <cfif len(evaluate("b#i#")) or len(evaluate("a#i#"))>
						<td align="center">
							<cfloop query="GET_EMP_QUIZ_ANSWERS">
							<cfif isdefined("GET_EMP_QUIZ_ANSWERS") and 
								isdefined("GET_EMP_QUIZ_ANSWERS.RESULT_ID") and 
								GET_EMP_QUIZ_ANSWERS.QUESTION_ID is q_id and 
								GET_EMP_QUIZ_ANSWERS.QUESTION_USER_ANSWERS is i>*</cfif>
							</cfloop>
						  <input type="hidden" name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" value="#evaluate('c#i#')#"><!--- value="#evaluate('get_quiz_chapters.answer'&i&'_point')#" --->
						</td>
					  </cfif>
					</cfloop>
				  </tr>
				  <cfelse>
				  <td></td>
				  </tr>
				  <cfloop from="1" to="20" index="i">
					<cfif len(evaluate("get_quiz_questions.answer#i#_photo")) or len(evaluate("get_quiz_questions.answer#i#_text"))>
					  <tr>
						<td></td>
						<td align="center"><!--- <input type="checkbox" name="gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" value="1" > ---></td>
						<td>
							<cfloop query="GET_EMP_QUIZ_ANSWERS">
							<cfif IsDefined("GET_EMP_QUIZ_ANSWERS") AND 
								IsDefined("GET_EMP_QUIZ_ANSWERS.RESULT_ID") AND 
								GET_EMP_QUIZ_ANSWERS.QUESTION_ID IS q_id AND 
								GET_EMP_QUIZ_ANSWERS.QUESTION_USER_ANSWERS IS i>*</cfif>
							</cfloop>
						  <input type="Hidden" name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" value="#evaluate('get_quiz_questions.answer'&i&'_point')#">
						  #evaluate('get_quiz_questions.answer#i#_text')#
						  <cfif len(evaluate("answer"&i&"_photo"))>
							<!--- <img src="#file_web_path#hr/#evaluate("get_quiz_questions.answer"&i&"_photo")#" border="0"> --->
							 <cf_get_server_file output_file="hr/#evaluate("get_quiz_questions.answer"&i&"_photo")#" output_server="#evaluate("get_quiz_questions.answer"&i&"_photo_server_id")#" output_type="0" image_width="40" image_height="50" image_link="1">
						  </cfif>
						  <br/>
						</td>
					  </tr>
					</cfif>
				  </cfloop>
				  </cfif>
				  <cfif len(question_info)>
					<tr height="20">
					  <td colspan="7">&nbsp;#get_quiz_questions.question_info# </td>
					</tr>
				  </cfif>
				</cfloop>
			  </table>
			</td>
		  </tr>
		  <tr>
			<td>
			  <table width="100%" border="0">
				<tr>
					<td class="txtboldblue" width="40"><cf_get_lang dictionary_id='57629.Açıklama'></td>
					<td>#chapter_expl.EXPLANATION#</td>
				  </tr>
			  </table>
			</td>
		  </tr> 
		  <cfelse>
		  <tr height="20" >
			<td><cf_get_lang dictionary_id='31428.Kayıtlı Soru Bulunamadı'>!</td>
		  </tr>
		</cfif>
		</cfoutput>
		<cfelse>
		<tr height="20">
		  <td><cf_get_lang dictionary_id='31429.Kayıtlı Bölüm Bulunamadı'>!</td>
		</tr>
		</cfif>	   
	   <cfinclude template="../query/act_quiz_perf_point.cfm">
		<tr height="22">
		  <td height="22" class="txtboldblue"><cf_get_lang dictionary_id='31943.İlgililerin Görüşleri'></td>
		</tr>
		<tr>
		<td>
			<table width="550">
				<tr>
					<td class="txtbold"><cf_get_lang dictionary_id='31946.İngilizce Sınav Sonucu'>: <cfoutput>#get_app_perf_detail.eng_test_result#</cfoutput>
					<td class="txtbold"><cf_get_lang dictionary_id='31947.Yetenek Testi Sonucu'>: <cfoutput>#get_app_perf_detail.ability_test_result#</cfoutput></td>
				</tr>
			</table>
		</td>
	  </tr>
		<tr>
		  <td>
			<table>
			  <tr>
				<td valign="top" class="txtbold"><cf_get_lang dictionary_id='31945.Referans Kontrolü Sonucu'></td>
			  </tr>
			  <tr>
				<td><cfoutput>#GET_APP_PERF_DETAIL.REF_CONTROL#</cfoutput></td>
			  </tr>
			  <tr>
				<td valign="top" class="txtbold"><cf_get_lang dictionary_id='31944.Önemli Notlar'></td>
			  </tr>
			  <tr>
				<td><cfoutput>#GET_APP_PERF_DETAIL.NOTES#</cfoutput></td>
			  </tr>
			</table>
		  </td>
		</tr>
	  <tr>
		<td>
			<table>
				<tr>
					<td class="txtbold"><cf_get_lang dictionary_id='31948.Değerlendirilebileceği Diğer Pozisyonlar'>:</td>
					<td>
						<cfif len(get_app_perf_detail.other_position_code)>
							<cfquery name="get_other_pos" datasource="#dsn#">
								SELECT POSITION_CAT FROM SETUP_POSITION_CAT WHERE POSITION_CAT_ID=#get_app_perf_detail.other_position_code#
							</cfquery>
							<cfoutput>#get_other_pos.position_cat#</cfoutput>	
						</cfif>				
					</td>
				</tr>
			</table>
		</td>
	  </tr>
        <tr height="22">
          <td height="22" class="form-title"><cf_get_lang dictionary_id='30995.Genel Değerlendirme (İK Departmanı)'></td>
        </tr>
        <tr height="22">
          <td valign="top">
			<table width="320">
			<tr>
				<td colspan="2"><b><cf_get_lang dictionary_id='57684.Sonuç'></b></td>
			</tr>
			<input name="USER_POINT" id="USER_POINT" value="" type="hidden">
			<input name="PERFORM_POINT" id="PERFORM_POINT" value="<cfoutput>#Round(quiz_point)#</cfoutput>" type="hidden">
			  <tr>
				<td><cf_get_lang dictionary_id='57776.Kişinin Aldığı Puan / Toplam Puan'></td>
				<td>
					<cfif get_app_perf_detail.perform_point gt 0>
						<cfset last_point = ((GET_APP_PERF_DETAIL.USER_POINT / GET_APP_PERF_DETAIL.PERFORM_POINT) * 100)>					
						<cfoutput>#Round(last_point)# / 100</cfoutput>
					<cfelse>0
					</cfif>
				</td> 
			  </tr> 
				<tr>
					<td><input name="PERFORM_POINT_ID" id="PERFORM_POINT_ID" type="radio" value="1" <cfif GET_APP_PERF_DETAIL.PERFORM_POINT_ID IS 1>checked</cfif>><cf_get_lang dictionary_id='31950.Pozisyona Uygundur'></td>
					<td><input name="PERFORM_POINT_ID" id="PERFORM_POINT_ID" type="radio" value="2" <cfif GET_APP_PERF_DETAIL.PERFORM_POINT_ID IS 2>checked</cfif>><cf_get_lang dictionary_id='31951.Pozisyona Uygun Değildir'></td>
				</tr>
			</table>
          </td>
        </tr>
        <tr height="22">
          <td>
			<table>
			   <tr>
				 <td>&nbsp;<b><cf_get_lang dictionary_id='31937.Değerlendiren'>:</b>&nbsp;<cfoutput>#GET_ENTRY_EMP.EMPLOYEE_NAME# #GET_ENTRY_EMP.EMPLOYEE_SURNAME#</cfoutput></td>
			   </tr> 
				<tr>
				<td>&nbsp;<b><cf_get_lang dictionary_id='30980.Onay ve Tarih'>:</b>&nbsp;
				<cfif GET_APP_PERF_DETAIL.IS_VALID eq 1>
					<cfoutput>#DateFormat(GET_APP_PERF_DETAIL.VALID_DATE,dateformat_style)# #TimeFORMAT(GET_APP_PERF_DETAIL.VALID_DATE,timeformat_style)# </cfoutput>
					<cf_get_lang dictionary_id='30982.Onaylayan'>:
				<cfelseif GET_APP_PERF_DETAIL.IS_VALID eq 0>
					<cfoutput>#DateFormat(GET_APP_PERF_DETAIL.VALID_DATE,dateformat_style)# #TimeFORMAT(GET_APP_PERF_DETAIL.VALID_DATE,timeformat_style)# </cfoutput>
					<cf_get_lang dictionary_id='31898.Reddeden'>:
				</cfif>
				<cfoutput>#get_emp_info(GET_APP_PERF_DETAIL.VALID_EMP_ID,0,0)#</cfoutput>
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
    </td>
    </tr>
  </table>
<br/>
