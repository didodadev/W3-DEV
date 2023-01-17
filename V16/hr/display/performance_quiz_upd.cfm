<!---bu sayfanın form elemaları oluşturmayan hali print_performance.cfm de var yapılan değişiklik o dosyayada yapılsın--->
<input type="hidden" name="quiz_id" id="quiz_id" value="<cfoutput>#attributes.quiz_id#</cfoutput>">
<cfinclude template="../query/get_quiz_chapters.cfm">
<cfif get_quiz_chapters.recordcount>
  <cfoutput query="get_quiz_chapters">
	  <cfset ANSWER_NUMBER_gelen = get_quiz_chapters.ANSWER_NUMBER>
	  <cfset attributes.CHAPTER_ID = CHAPTER_ID>
	  <cfquery name="chapter_exp_#get_quiz_chapters.currentrow#" datasource="#dsn#">
		SELECT EXPLANATION,MANAGER_EXPLANATION,EXPLANATION1,EXPLANATION2,EXPLANATION3,EXPLANATION4 FROM EMPLOYEE_QUIZ_CHAPTER_EXPL WHERE CHAPTER_ID=#CHAPTER_ID# AND RESULT_ID=<cfif isdefined('GET_PERF_DETAIL.RESULT_ID')and len(GET_PERF_DETAIL.RESULT_ID)>#GET_PERF_DETAIL.RESULT_ID#<cfelse>#GET_APP_PERF_DETAIL.RESULT_ID#</cfif>
	  </cfquery>
	  <cfscript>
		for (i=1; i lte 20; i = i+1)
			{
			"a#i#" = evaluate("get_quiz_chapters.answer#i#_text");
			"b#i#" = evaluate("get_quiz_chapters.answer#i#_photo");
			"c#i#" = evaluate("get_quiz_chapters.answer#i#_point");
			}
	  </cfscript>
	  <tr class="color-list" onClick="gizle_goster(b_#get_quiz_chapters.currentrow#);" style="cursor:pointer;">
		<td>
		  <table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr height="20">
			  <td class="txtboldblue">
			  <cf_get_lang dictionary_id='57995.Bölüm'>#get_quiz_chapters.currentrow#: #chapter#</td>
			</tr>
			<cfif len(chapter_info)>
			  <tr height="20" class="color-list">
				<td>#chapter_info#</td>
			  </tr>
			</cfif>
		  </table>
		</td>
	  </tr>
	 <tr class="color-row">
 	  <td>
  	  <table width="100%" cellpadding="0" cellspacing="0" id="b_#get_quiz_chapters.currentrow#">
  	  <cfinclude template="../query/get_quiz_questions.cfm">
  <cfif get_quiz_questions.recordcount>
	 <cfif get_quiz_chapters.ANSWER_NUMBER neq 0>
 	 <tr class="color-row">
    	<td>
      	<table border="0">
        <tr class="color-list" align="center">  
		   <td width="230">&nbsp;</td>
		   <td class="txtbold" width="30">GD</td>
          <!--- Eger cevaplar yan yana gelecekse, üst satira cevaplar yaziliyor --->
            <cfloop from="1" to="20" index="i">
              <cfif len(evaluate("answer#i#_photo")) or len(evaluate("answer#i#_text"))>
                <td class="txtbold">
                  <cfif len(evaluate("answer"&i&"_photo"))>
					<cf_get_server_file output_file="hr/#evaluate("answer"&i&"_photo")#" output_server="#evaluate("answer"&i&"_photo_server_id")#" output_type="0"  image_link="1">
                  </cfif>
                  #evaluate('answer#i#_text')#
				</td>
              </cfif>
            </cfloop>
		  	<td width="30">&nbsp;</td>
			<cfif get_quiz_info.is_manager_0 eq 1><td class="txtbold"><cf_get_lang dictionary_id="57576.Çalışan"></cfif>
			<cfif get_quiz_info.is_manager_3 eq 1><td class="txtbold"><cf_get_lang dictionary_id="29908.Görüş Bildiren"></td></cfif>
			<cfif get_quiz_info.is_manager_1 eq 1><td class="txtbold"><cf_get_lang dictionary_id="35927.1.Amir"></td></cfif>
			<cfif get_quiz_info.is_manager_4 eq 1><td class="txtbold"><cf_get_lang dictionary_id="31740.Ort Değer"></td></cfif>
			<cfif get_quiz_info.is_manager_2 eq 1><td class="txtbold"><cf_get_lang dictionary_id="35921.2.Amir"></td></cfif>
			<!--- 
			<cfif session.ep.userid neq get_perf_detail.manager_3_emp_id and get_quiz_info.form_open_type neq 2><td class="txtbold">Çalışan</td></cfif>
			<td class="txtbold">1.Amir</td>
			<cfif get_quiz_info.form_open_type neq 2><td class="txtbold">Ort. Değerl.</td></cfif>
			 --->
        </tr>
        <!--- Sorular basliyor --->
	    <cfloop query="get_quiz_questions">
          <cfset q_id = get_quiz_questions.QUESTION_ID>
		  <tr class="color-list" height="20">
			<td width="230" class="txtbold">
				<cfif get_quiz_info.IS_VIEW_QUESTION is 1>#get_quiz_questions.currentrow#-#get_quiz_questions.question#<cfelse>D-#get_quiz_questions.currentrow#</cfif><!--- Sorular form ekleme sayfasina eklenenen Sorular Goruntulensin secenegi ile kontrol ediliyor --->
			<!-- Sorular güvenlik nedeniyle görüntülenmiyor --->
			</td>
            <cfif ANSWER_NUMBER_gelen NEQ 0> <!--- Cevaplar yan yana gelecekse gecersiz deger sorularin cevaplarin yanina yaziyor --->
			<td class="txtboldblue">
			<input type="radio" name="gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" id="gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" onFocus="radio_degistir(#get_quiz_chapters.currentrow#,#get_quiz_questions.currentrow#);" value="1"
			<cfloop query="GET_EMP_QUIZ_ANSWERS">
					<cfif isdefined("GET_EMP_QUIZ_ANSWERS") AND 
						isdefined("GET_EMP_QUIZ_ANSWERS.RESULT_ID") AND 
						GET_EMP_QUIZ_ANSWERS.QUESTION_ID IS q_id AND 
						GET_EMP_QUIZ_ANSWERS.GD is 1>
					checked
					</cfif>
				</cfloop>
				>  <!--- onClick="calc_user_point();" --->
			</td>
			<cfelse><!--- Cevaplar  alt alta secenegi secili ise gecersiz deger üst satira yaziliyor --->
			<tr class="color-list">
			<td  width="230" class="txtbold">
			<input type="radio" name="gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" id="gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" onFocus="radio_degistir(#get_quiz_chapters.currentrow#,#get_quiz_questions.currentrow#);"value="1" 
			<cfloop query="GET_EMP_QUIZ_ANSWERS">
						<cfif isdefined("GET_EMP_QUIZ_ANSWERS") AND 
								isdefined("GET_EMP_QUIZ_ANSWERS.RESULT_ID") AND 
								GET_EMP_QUIZ_ANSWERS.QUESTION_ID IS q_id AND 
								GET_EMP_QUIZ_ANSWERS.GD is 1>
							checked
							</cfif>
						</cfloop>
					>  <!--- onClick="calc_user_point();" --->GD
			</td>
			</tr>
			</cfif>
            <cfif ANSWER_NUMBER_gelen NEQ 0>
            <cfloop from="1" to="20" index="i">
              <cfif len(evaluate("b#i#")) or len(evaluate("a#i#"))>
                <td  align="center">
                  <input type="Radio" name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" value="#i#" onFocus="radio_degistir_2(#get_quiz_chapters.currentrow#,#get_quiz_questions.currentrow#)"
												<cfloop query="GET_EMP_QUIZ_ANSWERS">
												<cfif IsDefined("GET_EMP_QUIZ_ANSWERS") AND 
													IsDefined("GET_EMP_QUIZ_ANSWERS.RESULT_ID") AND 
													GET_EMP_QUIZ_ANSWERS.QUESTION_ID IS q_id AND 
													GET_EMP_QUIZ_ANSWERS.QUESTION_USER_ANSWERS IS i>checked</cfif>
												</cfloop>
										> <!--- onClick="calc_user_point();" ---> 
                  <input type="Hidden" name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" value="#evaluate('c#i#')#"><!--- value="#evaluate('get_quiz_chapters.answer'&i&'_point')#" --->
                </td>
			  </cfif>
            </cfloop>
			<td width="30">&nbsp;</td>
			<cfif get_quiz_info.is_manager_0 eq 1>
			<td>
				<cfloop query="get_emp_quiz_answers">
					<cfif get_emp_quiz_answers.question_id is q_id and get_emp_quiz_answers.calisan_gd eq 1>
						GD
					</cfif>
					<cfif len(get_emp_quiz_answers.calisan_answers) and get_emp_quiz_answers.calisan_answers neq 0 and get_emp_quiz_answers.question_id is q_id>
					#evaluate("get_quiz_chapters.answer#get_emp_quiz_answers.calisan_answers#_text")#
					</cfif>
				</cfloop>
			</td>
			</cfif>
			<cfif get_quiz_info.is_manager_3 eq 1>
			<td>
				<cfloop query="get_emp_quiz_answers">
					<cfif get_emp_quiz_answers.question_id is q_id and get_emp_quiz_answers.manager3_gd eq 1>
						GD
					</cfif>
					<cfif len(get_emp_quiz_answers.manager3_answers) and get_emp_quiz_answers.manager3_answers neq 0 and get_emp_quiz_answers.question_id is q_id>
					#evaluate("get_quiz_chapters.answer#get_emp_quiz_answers.manager3_answers#_text")#
					</cfif>
				</cfloop>
			</td>
			</cfif>
			<cfif get_quiz_info.is_manager_1 eq 1>
			<td>
				<cfloop query="get_emp_quiz_answers">
					<cfif get_emp_quiz_answers.question_id is q_id and get_emp_quiz_answers.manager1_gd eq 1>
						GD
					</cfif>
					<cfif len(get_emp_quiz_answers.manager1_answers) and get_emp_quiz_answers.manager1_answers neq 0 and get_emp_quiz_answers.question_id is q_id>
					#evaluate("get_quiz_chapters.answer#get_emp_quiz_answers.manager1_answers#_text")#
					</cfif>
				</cfloop>
			</td>
			</cfif>
			<cfif get_quiz_info.is_manager_4 eq 1>
			<td>
				<cfloop query="get_emp_quiz_answers">
					<cfif get_emp_quiz_answers.question_id is q_id and get_emp_quiz_answers.man_emp_gd eq 1>
						GD
					</cfif>
					<cfif len(get_emp_quiz_answers.man_emp_answers) and get_emp_quiz_answers.man_emp_answers neq 0 and get_emp_quiz_answers.question_id is q_id>
					#evaluate("get_quiz_chapters.answer#get_emp_quiz_answers.man_emp_answers#_text")#
					</cfif>
				</cfloop>
			</td>
			</cfif>
			<cfif get_quiz_info.is_manager_2 eq 1>
			<td>
				<cfloop query="get_emp_quiz_answers">
					<cfif get_emp_quiz_answers.question_id is q_id and get_emp_quiz_answers.manager2_gd eq 1>
						GD
					</cfif>
					<cfif len(get_emp_quiz_answers.manager2_answers) and get_emp_quiz_answers.manager2_answers neq 0 and get_emp_quiz_answers.question_id is q_id>
					#evaluate("get_quiz_chapters.answer#get_emp_quiz_answers.manager2_answers#_text")#
					</cfif>
				</cfloop>
			</td>
			</cfif>
			<!--- 
			<cfif session.ep.userid neq get_perf_detail.manager_3_emp_id and get_quiz_info.form_open_type neq 2><!--- session.ep.userid neq get_perf_detail.manager_3_emp_id and  --->
			<td>
				<cfloop query="get_emp_quiz_answers">
					<cfif get_emp_quiz_answers.question_id is q_id and get_emp_quiz_answers.calisan_gd eq 1>
						GD
					</cfif>
					<cfif len(get_emp_quiz_answers.calisan_answers) and get_emp_quiz_answers.calisan_answers neq 0 and get_emp_quiz_answers.question_id is q_id>
					#evaluate("get_quiz_chapters.answer#get_emp_quiz_answers.calisan_answers#_text")#
					</cfif>
				</cfloop>
			</td>
			</cfif>
			<td>
				<cfloop query="get_emp_quiz_answers">
					<cfif get_emp_quiz_answers.question_id is q_id and get_emp_quiz_answers.manager1_gd eq 1>
						GD
					</cfif>
					<cfif len(get_emp_quiz_answers.manager1_answers) and get_emp_quiz_answers.manager1_answers neq 0 and get_emp_quiz_answers.question_id is q_id>
					#evaluate("get_quiz_chapters.answer#get_emp_quiz_answers.manager1_answers#_text")#
					</cfif>
				</cfloop>
			</td>
			<cfif get_quiz_info.form_open_type neq 2>
			<td>
				<cfloop query="get_emp_quiz_answers">
					<cfif get_emp_quiz_answers.question_id is q_id and get_emp_quiz_answers.man_emp_gd eq 1>
						GD
					</cfif>
					<cfif len(get_emp_quiz_answers.man_emp_answers) and get_emp_quiz_answers.man_emp_answers neq 0 and get_emp_quiz_answers.question_id is q_id>
					#evaluate("get_quiz_chapters.answer#get_emp_quiz_answers.man_emp_answers#_text")#
					</cfif>
				</cfloop>
			</td>
			</cfif>
			 --->
          </tr>
          <cfelse>
         <!---  <td></td> --->
          </tr>
          <cfloop from="1" to="20" index="i">
           <tr>
		   	<td><cfoutput>#evaluate("b#i#")#</cfoutput></td>
		   </tr>
		   <cfif len(evaluate("b#i#")) or len(evaluate("a#i#"))>
			  <tr class="color-list">
                <td class="txtbold">
                  <input type="radio" name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" value="#i#"  onFocus="radio_degistir_2(#get_quiz_chapters.currentrow#,#get_quiz_questions.currentrow#)"
							<cfloop query="GET_EMP_QUIZ_ANSWERS">
							<cfif IsDefined("GET_EMP_QUIZ_ANSWERS") AND 
								IsDefined("GET_EMP_QUIZ_ANSWERS.RESULT_ID") AND 
								GET_EMP_QUIZ_ANSWERS.QUESTION_ID IS q_id AND 
								GET_EMP_QUIZ_ANSWERS.QUESTION_USER_ANSWERS IS i>checked</cfif>
							</cfloop>
					> <!--- onClick="calc_user_point();" --->
                  <input type="Hidden" name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" value="#evaluate('c#i#')#"><!--- #evaluate('get_quiz_questions.answer'&i&'_point')# --->
                  <cfif len(evaluate("answer"&i&"_photo"))>
                    <!--- <img src="#file_web_path#hr/#evaluate("get_quiz_questions.answer"&i&"_photo")#" border="0"> --->
					<cf_get_server_file output_file="hr/#evaluate("get_quiz_questions.answer"&i&"_photo")#" output_server="#evaluate("get_quiz_questions.answer"&i&"_photo_server_id")#" output_type="0"  image_link="1">
                  </cfif>
                  #evaluate('get_quiz_questions.answer#i#_text')#<br/>
                </td>
              </tr>
            </cfif>
          </cfloop>
          </cfif>
          <cfif len(question_info)>
            <tr height="20">
              <td colspan="6">#get_quiz_questions.question_info#</td>
            </tr>
          </cfif>
        </cfloop>
		</table>
		</cfif>
		<cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
	   <cfset gorus = 0>
	   <cfif (attributes.emp_id eq session.ep.userid and get_quiz_chapters.is_emp_exp1 neq 1) or (get_perf_detail.manager_3_emp_id eq session.ep.userid and get_quiz_chapters.is_chief3_exp1 neq 1) or (get_perf_detail.manager_1_emp_id eq session.ep.userid and get_quiz_chapters.is_chief1_exp1 neq 1) or (get_perf_detail.manager_2_emp_id eq session.ep.userid and get_quiz_chapters.is_chief2_exp1 neq 1) or (session.ep.userid neq attributes.emp_id and get_perf_detail.manager_1_emp_id neq session.ep.userid and get_perf_detail.manager_3_emp_id neq session.ep.userid and get_perf_detail.manager_2_emp_id neq session.ep.userid)>
		<cfif session.ep.userid neq get_perf_detail.manager_3_emp_id and get_quiz_chapters.is_emp_exp1 eq 1 and get_quiz_chapters.is_chief1_exp1 eq 1 and get_quiz_chapters.is_chief2_exp1 eq 1 and get_quiz_chapters.is_chief3_exp1 neq 1>
			<cfset gorus = 1>
		</cfif>
		<cfif (get_quiz_chapters.is_exp1 eq 1) and len(get_quiz_chapters.exp1_name) and gorus neq 1>
		<tr>
			<td colspan="6" valign="top" nowrap>#get_quiz_chapters.exp1_name#&nbsp;</td>
		</tr>
		<tr>
			<td colspan="6" valign="top" nowrap><textarea name="exp1_#get_quiz_chapters.currentrow#" id="exp1_#get_quiz_chapters.currentrow#" value="" cols="70" rows="2" maxlength="1500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>">#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.EXPLANATION1")#</textarea></td>
		</tr>
		</cfif>
	   </cfif> 
	   <cfif (attributes.emp_id eq session.ep.userid and get_quiz_chapters.is_emp_exp2 neq 1) or (get_perf_detail.manager_3_emp_id eq session.ep.userid and get_quiz_chapters.is_chief3_exp2 neq 1) or (get_perf_detail.manager_1_emp_id eq session.ep.userid and get_quiz_chapters.is_chief1_exp2 neq 1) or (get_perf_detail.manager_2_emp_id eq session.ep.userid and get_quiz_chapters.is_chief2_exp2 neq 1) or (session.ep.userid neq attributes.emp_id and get_perf_detail.manager_1_emp_id neq session.ep.userid and get_perf_detail.manager_3_emp_id neq session.ep.userid and get_perf_detail.manager_2_emp_id neq session.ep.userid)>
		<cfif  session.ep.userid neq get_perf_detail.manager_3_emp_id and get_quiz_chapters.is_emp_exp2 eq 1 and get_quiz_chapters.is_chief1_exp2 eq 1 and get_quiz_chapters.is_chief2_exp2 eq 1 and get_quiz_chapters.is_chief3_exp2 neq 1>
			<cfset gorus = 1>
		</cfif>
		<cfif (get_quiz_chapters.is_exp2 eq 1) and len(get_quiz_chapters.exp2_name) and gorus neq 1>
		<tr>
			<td colspan="6" valign="top" nowrap>#get_quiz_chapters.exp2_name#&nbsp;</td>
		</tr>
		<tr>
			<td colspan="6" valign="top" nowrap><textarea name="exp2_#get_quiz_chapters.currentrow#" id="exp2_#get_quiz_chapters.currentrow#" value="" cols="70" rows="2" maxlength="1500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>">#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.EXPLANATION2")#</textarea></td>
		</tr>
		</cfif>
	   </cfif>
	    <cfif (attributes.emp_id eq session.ep.userid and get_quiz_chapters.is_emp_exp3 neq 1) or (get_perf_detail.manager_3_emp_id eq session.ep.userid and get_quiz_chapters.is_chief3_exp3 neq 1) or (get_perf_detail.manager_1_emp_id eq session.ep.userid and get_quiz_chapters.is_chief1_exp3 neq 1) or (get_perf_detail.manager_2_emp_id eq session.ep.userid and get_quiz_chapters.is_chief2_exp3 neq 1) or (session.ep.userid neq attributes.emp_id and get_perf_detail.manager_1_emp_id neq session.ep.userid and get_perf_detail.manager_3_emp_id neq session.ep.userid and get_perf_detail.manager_2_emp_id neq session.ep.userid)>
		<cfif  session.ep.userid neq get_perf_detail.manager_3_emp_id and get_quiz_chapters.is_emp_exp3 eq 1 and get_quiz_chapters.is_chief1_exp3 eq 1 and get_quiz_chapters.is_chief2_exp3 eq 1 and get_quiz_chapters.is_chief3_exp3 neq 1>
			<cfset gorus = 1>
		</cfif>
		<cfif (get_quiz_chapters.is_exp3 eq 1) and len(get_quiz_chapters.exp3_name) and gorus neq 1>
		<tr>
			<td colspan="6" valign="top" nowrap>#get_quiz_chapters.exp3_name#&nbsp;</td>
		</tr>
		<tr>
			<td colspan="6" valign="top" nowrap><textarea name="exp3_#get_quiz_chapters.currentrow#" id="exp3_#get_quiz_chapters.currentrow#" value="" cols="70" rows="2" maxlength="1500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>">#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.EXPLANATION3")#</textarea></td>
		</tr>
		</cfif>
	   </cfif>
	   <cfif (attributes.emp_id eq session.ep.userid and get_quiz_chapters.is_emp_exp4 neq 1) or (get_perf_detail.manager_3_emp_id eq session.ep.userid and get_quiz_chapters.is_chief3_exp4 neq 1) or (get_perf_detail.manager_1_emp_id eq session.ep.userid and get_quiz_chapters.is_chief1_exp4 neq 1) or (get_perf_detail.manager_2_emp_id eq session.ep.userid and get_quiz_chapters.is_chief2_exp4 neq 1) or (session.ep.userid neq attributes.emp_id and get_perf_detail.manager_1_emp_id neq session.ep.userid and get_perf_detail.manager_3_emp_id neq session.ep.userid and get_perf_detail.manager_2_emp_id neq session.ep.userid)>
		<cfif  session.ep.userid neq get_perf_detail.manager_3_emp_id and get_quiz_chapters.is_emp_exp4 eq 1 and get_quiz_chapters.is_chief1_exp4 eq 1 and get_quiz_chapters.is_chief2_exp4 eq 1 and get_quiz_chapters.is_chief3_exp4 neq 1>
			<cfset gorus = 1>
		</cfif>
		<cfif (get_quiz_chapters.is_exp4 eq 1) and len(get_quiz_chapters.exp4_name) and gorus neq 1>
		<tr>
			<td colspan="6" valign="top" nowrap>#get_quiz_chapters.exp4_name#&nbsp;</td>
		</tr>
		<tr>
			<td colspan="6" valign="top" nowrap><textarea name="exp4_#get_quiz_chapters.currentrow#" id="exp4_#get_quiz_chapters.currentrow#" value="" cols="70" rows="2" maxlength="1500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>">#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.EXPLANATION4")#</textarea></td>
		</tr>
		</cfif>
	   </cfif>
	  </table>
	  </td>
	  </tr>
	 <cfelse>
	  <tr height="20" class="color-row">
		<td><cf_get_lang dictionary_id='55829.Kayıtlı Soru Bulunamadı!'></td>
	  </tr>
	</cfif>
	</cfoutput>
<cfelse>
	<tr height="20" class="color-row">
	  <td><cf_get_lang dictionary_id='55830.Kayıtlı Bölüm Bulunamadı!'></td>
	</tr>
</cfif>

<script type="text/javascript">
function radio_degistir(ilk,son)
{
	x = eval("document.add_perform.user_answer_" + ilk + "_" + son + ".length");
			for (i=0; i < x; i++)
				{
				eval("document.add_perform.user_answer_" + ilk + "_" + son)[i].checked = false;
				}
}
function radio_degistir_2(ilk,son)
{
	eval("document.add_perform.gd_" + ilk + "_" + son).checked = false;
}
/*calc_user_point();*/

function check_expl()
{ 
<cfoutput query="get_quiz_chapters">
  <cfset attributes.CHAPTER_ID = CHAPTER_ID>
  <cfinclude template="../query/get_quiz_questions.cfm">
  <cfif get_quiz_questions.RecordCount and get_quiz_chapters.ANSWER_NUMBER>
        <cfloop query="get_quiz_questions">
		var kontrol_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#=0;
		if(document.add_perform.gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#.checked == false)
		{
			for(var i=0;i<#get_quiz_chapters.answer_number#;i++)
			{
				if(document.add_perform.user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#[i]!=undefined && document.add_perform.user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#[i].checked == true)
				{
					kontrol_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#=1;
					break;
				}else  kontrol_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#=0;
			}
		}else kontrol_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#=1;
		if(kontrol_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#==0)
			{
				alert('İşaretlemediğiniz Sorular Var !');
				return false;					  
			}
		</cfloop>          
  </cfif>
</cfoutput>
return true;
}
</script>
