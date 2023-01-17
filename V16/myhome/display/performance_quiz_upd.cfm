<!---bu sayfanın form elemaları oluşturmayan hali print_performance.cfm de var yapılan değişiklik o dosyayada yapılsın--->
<input type="hidden" name="quiz_id" id="quiz_id" value="<cfoutput>#attributes.quiz_id#</cfoutput>">
<cfinclude template="../query/get_quiz_chapters.cfm">
<cfif get_quiz_chapters.recordcount>
	<cfoutput query="get_quiz_chapters">
		<cfset ANSWER_NUMBER_gelen = get_quiz_chapters.ANSWER_NUMBER>
		<cfset attributes.CHAPTER_ID = CHAPTER_ID>
		<cfquery name="chapter_exp_#get_quiz_chapters.currentrow#" datasource="#dsn#">
			SELECT * FROM EMPLOYEE_QUIZ_CHAPTER_EXPL WHERE CHAPTER_ID=#CHAPTER_ID# AND RESULT_ID=<cfif isdefined('GET_PERF_DETAIL.RESULT_ID')and len(GET_PERF_DETAIL.RESULT_ID)>#GET_PERF_DETAIL.RESULT_ID#<cfelse>#GET_APP_PERF_DETAIL.RESULT_ID#</cfif>
		</cfquery>
		<cfscript>
			for (i=1; i lte 20; i = i+1)
			{
				"a#i#" = evaluate("get_quiz_chapters.answer#i#_text");
				"b#i#" = evaluate("get_quiz_chapters.answer#i#_photo");
				"c#i#" = evaluate("get_quiz_chapters.answer#i#_point");
			}
		</cfscript>
		<cfsavecontent variable="message"><cf_get_lang dictionary_id='57995.Bölüm'></cfsavecontent>
        <cf_seperator title="#message# #get_quiz_chapters.currentrow#: #chapter#" id="b_#get_quiz_chapters.currentrow#">
			<cfif len(chapter_info)>
                <table>
                    <tr>
                        <td>#chapter_info#</td>
                    </tr>
                </table>
            </cfif>
			<table id="b_#get_quiz_chapters.currentrow#">
				<cfset counter_ = 7>
				<cfinclude template="../query/get_quiz_questions.cfm">
				<cfif get_quiz_questions.recordcount>
				<cfif get_quiz_chapters.answer_number neq 0><!--- not listfind(chapter_not_gd,attributes.CHAPTER_ID,',') --->
				<tr>
					<td>
					<table>
					<tr> 
						<td style="width:280px;"></td>
						<td class="txtbold" style="width:75px;text-align:center">GD</td>
						 <!--- Eger cevaplar yan yana gelecekse, üst satira cevaplar yaziliyor --->
						<cfloop from="1" to="20" index="i">
							<cfif len(evaluate("answer#i#_photo")) or len(evaluate("answer#i#_text"))>
								<td class="txtbold" style="width:75px;text-align:center">
									#evaluate('answer#i#_text')#
									<cfif len(evaluate("answer"&i&"_photo"))>
										<cf_get_server_file output_file="hr/#evaluate("answer"&i&"_photo")#" output_server="#evaluate("answer"&i&"_photo_server_id")#" output_type="0" image_width="40" image_height="50" image_link="1">
									</cfif>
								</td>
								<cfset counter_ = counter_ + 1>
							</cfif>
						</cfloop>
						<td width="30">&nbsp;</td>
						<cfif get_quiz_info.is_manager_0 eq 1><td class="txtbold"><cf_get_lang dictionary_id='57576.Çalışan'></cfif>
						<cfif get_quiz_info.is_manager_3 eq 1><td class="txtbold"><cf_get_lang dictionary_id ='29908.Görüş Bildiren'></td></cfif>
						<cfif get_quiz_info.is_manager_1 eq 1><td class="txtbold">1.<cf_get_lang dictionary_id='29666.Amir'></td></cfif>
						<cfif get_quiz_info.is_manager_4 eq 1><td class="txtbold"><cf_get_lang dictionary_id ='31740.Ort Değer'></td></cfif>
						<cfif get_quiz_info.is_manager_2 eq 1><td class="txtbold">2.<cf_get_lang dictionary_id='29666.Amir'></td></cfif>
						<!--- 
						<cfif session.ep.userid neq get_perf_detail.manager_3_emp_id and get_quiz_info.form_open_type neq 2><td class="txtbold"><cf_get_lang_main no='164.Çalışan'></td></cfif>
						<cfif session.ep.userid neq attributes.emp_id>
							<td class="txtbold">1.<cf_get_lang_main no='1869.Amir'></td>
							<cfif get_quiz_info.form_open_type neq 2><td class="txtbold"><cf_get_lang no ='982.Ort Değer'>l</td></cfif>
						</cfif>
						 --->
					</tr>
					<!--- Sorular basliyor --->
					<cfloop query="get_quiz_questions">
						<cfset q_id = get_quiz_questions.QUESTION_ID>
						<cfquery name="GET_EMP_QUIZ_ANSWERS_" dbtype="query">
							SELECT QUESTION_EMP_OPENED_ANSWERS,QUESTION_MANAGER1_OPENED_ANSWERS,QUESTION_MANAGER2_OPENED_ANSWERS,QUESTION_MANAGER3_OPENED_ANSWERS FROM GET_EMP_QUIZ_ANSWERS WHERE QUESTION_ID = #q_id#
						</cfquery>
						<tr height="20">
						<td class="txtbold" valign="top"><cfif get_quiz_info.IS_VIEW_QUESTION is 1>#get_quiz_questions.currentrow#-#get_quiz_questions.question#<cfelse>D-#get_quiz_questions.currentrow#</cfif><!--- Sorular form ekleme sayfasina eklenenen Sorular Goruntulensin secenegi ile kontrol ediliyor ---></td>
						<cfif get_quiz_questions.open_ended eq 1>
							<td class="txtbold" colspan="#counter_#">
								<textarea style="width:100%;height:50px" name="gd_opened_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" id="gd_opened_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#">
								<cfif get_perf_detail.emp_id eq session.ep.userid>
									#GET_EMP_QUIZ_ANSWERS_.QUESTION_EMP_OPENED_ANSWERS#
								<cfelseif get_perf_detail.manager_1_emp_id eq session.ep.userid>
									#GET_EMP_QUIZ_ANSWERS_.QUESTION_MANAGER1_OPENED_ANSWERS#
								<cfelseif get_perf_detail.manager_2_emp_id eq session.ep.userid>
									#GET_EMP_QUIZ_ANSWERS_.QUESTION_MANAGER2_OPENED_ANSWERS#
								<cfelseif get_perf_detail.manager_3_emp_id eq session.ep.userid>
									#GET_EMP_QUIZ_ANSWERS_.QUESTION_MANAGER3_OPENED_ANSWERS#
								</cfif>
								</textarea>
							</td>
						<cfelse>
							<cfif ANSWER_NUMBER_gelen NEQ 0> <!--- Cevaplar yan yana gelecekse gecersiz deger sorularin cevaplarin yanina yaziyor --->
								<td class="txtboldblue" style="width:75px;text-align:center">
								<input name="gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" id="gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" type="radio" onFocus="radio_degistir(#get_quiz_chapters.currentrow#,#get_quiz_questions.currentrow#);" value="1"
									<cfloop query="GET_EMP_QUIZ_ANSWERS">
										<cfif isdefined("GET_EMP_QUIZ_ANSWERS") AND 
												isdefined("GET_EMP_QUIZ_ANSWERS.RESULT_ID") AND 
												GET_EMP_QUIZ_ANSWERS.QUESTION_ID IS q_id AND 
												GET_EMP_QUIZ_ANSWERS.GD is 1>
											checked
										</cfif>
									</cfloop> autocomplete="off">
								</td>
							<cfelse><!--- Cevaplar  alt alta secenegi secili ise gecersiz deger üst satira yaziliyor --->
								<tr>
									<td class="txtbold" style="width:75px;text-align:center">
									<input name="gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" id="gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" type="radio" onFocus="radio_degistir(#get_quiz_chapters.currentrow#,#get_quiz_questions.currentrow#);"value="1" 
										<cfloop query="GET_EMP_QUIZ_ANSWERS">
											<cfif 	isdefined("GET_EMP_QUIZ_ANSWERS") AND 
													isdefined("GET_EMP_QUIZ_ANSWERS.RESULT_ID") AND 
													GET_EMP_QUIZ_ANSWERS.QUESTION_ID IS q_id AND 
													GET_EMP_QUIZ_ANSWERS.GD is 1>
												checked
											</cfif>
										</cfloop> autocomplete="off"> 
										GD
									</td>
								</tr>
							</cfif>
							<cfif ANSWER_NUMBER_gelen NEQ 0>
								<cfloop from="1" to="20" index="i">
								<cfif len(evaluate("b#i#")) or len(evaluate("a#i#"))>
									<td style="width:75px;text-align:center">
										<input name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" type="Radio" onFocus="radio_degistir_2(#get_quiz_chapters.currentrow#,#get_quiz_questions.currentrow#)" value="#i#"
											<cfloop query="GET_EMP_QUIZ_ANSWERS">
											<cfif IsDefined("GET_EMP_QUIZ_ANSWERS") AND 
												IsDefined("GET_EMP_QUIZ_ANSWERS.RESULT_ID") AND 
												GET_EMP_QUIZ_ANSWERS.QUESTION_ID IS q_id AND 
												GET_EMP_QUIZ_ANSWERS.QUESTION_USER_ANSWERS IS i>
												checked
											</cfif>
											</cfloop> autocomplete="off">
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
							<cfif session.ep.userid neq get_perf_detail.manager_3_emp_id and get_quiz_info.form_open_type neq 2>
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
							<cfif session.ep.userid neq attributes.emp_id>
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
							</cfif>
							 --->
						  </tr>
						  <cfelse>
						  </tr>
					  <cfloop from="1" to="20" index="i">
					   <tr>
						<td><cfoutput>#evaluate("b#i#")#</cfoutput></td>
					   </tr>
					   <cfif len(evaluate("b#i#")) or len(evaluate("a#i#"))>
						  <tr>
							<td class="txtbold" style="width:75px;text-align:center">
							  <input name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" type="radio"  onFocus="radio_degistir_2(#get_quiz_chapters.currentrow#,#get_quiz_questions.currentrow#)" value="#i#"
															<cfloop query="GET_EMP_QUIZ_ANSWERS">
															<cfif IsDefined("GET_EMP_QUIZ_ANSWERS") AND 
																IsDefined("GET_EMP_QUIZ_ANSWERS.RESULT_ID") AND 
																GET_EMP_QUIZ_ANSWERS.QUESTION_ID IS q_id AND 
																GET_EMP_QUIZ_ANSWERS.QUESTION_USER_ANSWERS IS i>checked</cfif>
															</cfloop> autocomplete="off"
													> 
							  <input type="hidden" name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" value="#evaluate('c#i#')#"><!--- #evaluate('get_quiz_questions.answer'&i&'_point')# --->
							  #evaluate('get_quiz_questions.answer#i#_text')#
							  <cfif len(evaluate("answer"&i&"_photo"))>
								<cf_get_server_file output_file="hr/#evaluate("get_quiz_questions.answer"&i&"_photo")#" output_server="#evaluate("get_quiz_questions.answer"&i&"_photo_server_id")#" output_type="0" image_width="40" image_height="50" image_link="1">
							  </cfif>
							  <br/>
							</td>
						  </tr>
						</cfif>
					  </cfloop>
					  </cfif>
					  	</cfif>
						<cfif len(question_info)>
							<tr height="20">
							  <td colspan="6">#get_quiz_questions.question_info#</td>
							</tr>
						</cfif>
					</cfloop>
				</table>
				</cfif>
				<!---aciklama--->
				<cfset gorus = 0>
				<cfif (get_quiz_chapters.is_emp_exp1 neq 0) or (get_quiz_chapters.is_chief3_exp1 neq 0) or (get_quiz_chapters.is_chief1_exp1 neq 0) or (get_quiz_chapters.is_chief2_exp1 neq 0)>
					<cfif session.ep.userid neq get_perf_detail.manager_3_emp_id and get_quiz_chapters.is_emp_exp1 eq 1 and get_quiz_chapters.is_chief1_exp1 eq 1 and get_quiz_chapters.is_chief2_exp1 eq 1 and get_quiz_chapters.is_chief3_exp1 neq 1>
						<cfset gorus = 1>
					</cfif>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
					<cfif (get_quiz_chapters.is_exp1 eq 1) and len(get_quiz_chapters.exp1_name) and gorus neq 1>
						<tr>
							<td colspan="6" valign="top" nowrap><b>#get_quiz_chapters.exp1_name#</b>&nbsp;</td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id ='31435.Çalışanın Görüş ve Düşünceleri'></td>
						</tr>
						<tr>
							<td colspan="6" valign="top" nowrap>
								<cfif get_perf_detail.emp_id eq session.ep.userid>
									<textarea name="exp1_#get_quiz_chapters.currentrow#" id="exp1_#get_quiz_chapters.currentrow#" value="" cols="70" rows="2" maxlength="1500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>">#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.EXPLANATION1")#</textarea><br/>
								<cfelse>
									#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.EXPLANATION1")#<br/>
								</cfif>
							</td>
						</tr>
						<cfif get_perf_detail.emp_id neq session.ep.userid>
						<tr>
							<td><cf_get_lang dictionary_id ='31436.Birinci Değerlendirme Yöneticisinin Görüş ve Düşünceleri'></td>
						</tr>
						<tr>
							<td><cfif get_perf_detail.manager_1_emp_id eq session.ep.userid>
									<textarea name="manager1_exp1_#get_quiz_chapters.currentrow#" id="manager1_exp1_#get_quiz_chapters.currentrow#" value="" cols="70" rows="2" maxlength="1500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>">#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.MANAGER1_EXPLANATION1")#</textarea><br/>
								<cfelse>
									#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.MANAGER1_EXPLANATION1")#<br />
								</cfif>
							</td>
						</tr>
						</cfif>
						<cfif get_perf_detail.MANAGER_3_EMP_ID eq session.ep.userid>
							<tr>
								<td><cf_get_lang dictionary_id ='31725.Görüş Bildirenin Görüş ve Düşünceleri'></td>
							</tr>
							<tr>
								<td><textarea name="manager3_exp1_#get_quiz_chapters.currentrow#" id="manager3_exp1_#get_quiz_chapters.currentrow#" value="" cols="70" rows="2" maxlength="1500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>">#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.MANAGER3_EXPLANATION1")#</textarea><br/></td>
							</tr>
						</cfif>
						<cfif get_perf_detail.emp_id neq session.ep.userid>
						<tr>
							<td><cf_get_lang dictionary_id ='31437.İkinci Değerlendirme Yöneticisinin Görüş ve Düşünceleri'></td>
						</tr>
						<tr>
							<td><cfif get_perf_detail.manager_2_emp_id eq session.ep.userid>
									<textarea name="manager2_exp1_#get_quiz_chapters.currentrow#" id="manager2_exp1_#get_quiz_chapters.currentrow#" value="" cols="70" rows="2" maxlength="1500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>">#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.MANAGER2_EXPLANATION1")#</textarea><br/>
								<cfelse>
									#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.MANAGER2_EXPLANATION1")#<br />
								</cfif>
							</td>
						</tr>
						</cfif>
					</cfif>
				</cfif>
				<cfif (get_quiz_chapters.is_emp_exp2 neq 0) or (session.ep.userid and get_quiz_chapters.is_chief3_exp2 neq 0) or (get_quiz_chapters.is_chief1_exp2 neq 0) or (get_quiz_chapters.is_chief2_exp2 neq 0)>
					<cfif session.ep.userid neq get_perf_detail.manager_3_emp_id and get_quiz_chapters.is_emp_exp2 eq 1 and get_quiz_chapters.is_chief1_exp2 eq 1 and get_quiz_chapters.is_chief2_exp2 eq 1 and get_quiz_chapters.is_chief3_exp2 neq 1>
						<cfset gorus = 1>
					</cfif>
					<cfif (get_quiz_chapters.is_exp2 eq 1) and len(get_quiz_chapters.exp2_name) and gorus neq 1>
						<tr>
							<td colspan="6" valign="top" nowrap><b>#get_quiz_chapters.exp2_name#</b>&nbsp;</td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id ='31435.Çalışanın Görüş ve Düşünceleri'></td>
						</tr>
						<tr>
							<td colspan="6" valign="top" nowrap>
								<cfif get_perf_detail.emp_id eq session.ep.userid>
									<textarea name="exp2_#get_quiz_chapters.currentrow#" id="exp2_#get_quiz_chapters.currentrow#" value="" cols="70" rows="2" maxlength="1500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>">#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.EXPLANATION2")#</textarea>
								<cfelse>
									#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.EXPLANATION2")#<br />
								</cfif>
							</td>
						</tr>
						<cfif get_perf_detail.emp_id neq session.ep.userid>
						<tr>
							<td><cf_get_lang dictionary_id ='31436.Birinci Değerlendirme Yöneticisinin Görüş ve Düşünceleri'></td>
						</tr>
						<tr>
							<td colspan="6" valign="top" nowrap>
								<cfif get_perf_detail.manager_1_emp_id eq session.ep.userid>
									<textarea name="manager1_exp2_#get_quiz_chapters.currentrow#" id="manager1_exp2_#get_quiz_chapters.currentrow#" value="" cols="70" rows="2" maxlength="1500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>">#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.MANAGER1_EXPLANATION2")#</textarea>
								<cfelse>
									#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.MANAGER1_EXPLANATION2")#<br />
								</cfif>
							</td>
						</tr>
						</cfif>
						<cfif get_perf_detail.MANAGER_3_EMP_ID eq session.ep.userid>
							<tr>
								<td><cf_get_lang dictionary_id ='31725.Görüş Bildirenin Görüş ve Düşünceleri'></td>
							</tr>
							<tr>
								<td><textarea name="manager3_exp2_#get_quiz_chapters.currentrow#" id="manager3_exp2_#get_quiz_chapters.currentrow#" value="" cols="70" rows="2" maxlength="1500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>">#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.MANAGER3_EXPLANATION2")#</textarea><br/></td>
							</tr>
						</cfif>
						<cfif get_perf_detail.emp_id neq session.ep.userid>
						<tr>
							<td><cf_get_lang dictionary_id ='31437.İkinci Değerlendirme Yöneticisinin Görüş ve Düşünceleri'></td>
						</tr>
						<tr>
							<td colspan="6" valign="top" nowrap>
								<cfif get_perf_detail.manager_2_emp_id eq session.ep.userid>
									<textarea name="manager2_exp2_#get_quiz_chapters.currentrow#" id="manager2_exp2_#get_quiz_chapters.currentrow#" value="" cols="70" rows="2" maxlength="1500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>">#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.MANAGER2_EXPLANATION2")#</textarea>
								<cfelse>
									#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.MANAGER2_EXPLANATION2")#<br />
								</cfif>
							</td>
						</tr>
						</cfif>
					</cfif>
				</cfif>
				<cfif (get_quiz_chapters.is_emp_exp3 neq 0) or (get_quiz_chapters.is_chief3_exp3 neq 0) or (get_quiz_chapters.is_chief1_exp3 neq 0) or (get_quiz_chapters.is_chief2_exp3 neq 0)>
					<cfif session.ep.userid neq get_perf_detail.manager_3_emp_id and get_quiz_chapters.is_emp_exp3 eq 1 and get_quiz_chapters.is_chief1_exp3 eq 1 and get_quiz_chapters.is_chief2_exp3 eq 1 and get_quiz_chapters.is_chief3_exp3 neq 1>
						<cfset gorus = 1>
					</cfif>
					<cfif (get_quiz_chapters.is_exp3 eq 1) and len(get_quiz_chapters.exp3_name) and gorus neq 1>
						<tr>
							<td colspan="6" valign="top" nowrap><b>#get_quiz_chapters.exp3_name#</b>&nbsp;</td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id ='31435.Çalışanın Görüş ve Düşünceleri'></td>
						</tr>
						<tr>
							<td colspan="6" valign="top" nowrap>
								<cfif get_perf_detail.emp_id eq session.ep.userid>
									<textarea name="exp3_#get_quiz_chapters.currentrow#" id="exp3_#get_quiz_chapters.currentrow#" value="" cols="70" rows="2" maxlength="1500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>">#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.EXPLANATION3")#</textarea>
								<cfelse>
									#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.EXPLANATION3")#<br />
								</cfif>
							</td>
						</tr>
						<cfif get_perf_detail.emp_id neq session.ep.userid>
						<tr>
							<td><cf_get_lang dictionary_id ='31436.Birinci Değerlendirme Yöneticisinin Görüş ve Düşünceleri'></td>
						</tr>
						<tr>
							<td colspan="6" valign="top" nowrap>
								<cfif get_perf_detail.manager_1_emp_id eq session.ep.userid>
									<textarea name="manager1_exp3_#get_quiz_chapters.currentrow#" id="manager1_exp3_#get_quiz_chapters.currentrow#" value="" cols="70" rows="2" maxlength="1500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>">#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.MANAGER1_EXPLANATION3")#</textarea>
								<cfelse>
									#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.MANAGER1_EXPLANATION3")#<br />
								</cfif>
							</td>
						</tr>
						</cfif>
						<cfif get_perf_detail.MANAGER_3_EMP_ID eq session.ep.userid>
							<tr>
								<td><cf_get_lang dictionary_id ='31725.Görüş Bildirenin Görüş ve Düşünceleri'></td>
							</tr>
							<tr>
								<td><textarea name="manager3_exp3_#get_quiz_chapters.currentrow#" id="manager3_exp3_#get_quiz_chapters.currentrow#" value="" cols="70" rows="2" maxlength="1500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>">#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.MANAGER3_EXPLANATION3")#</textarea><br/></td>
							</tr>
						</cfif>
						<cfif get_perf_detail.emp_id neq session.ep.userid>
						<tr>
							<td><cf_get_lang dictionary_id ='31437.İkinci Değerlendirme Yöneticisinin Görüş ve Düşünceleri'></td>
						</tr>
						<tr>
							<td colspan="6" valign="top" nowrap>
								<cfif get_perf_detail.manager_2_emp_id eq session.ep.userid>
									<textarea name="manager2_exp3_#get_quiz_chapters.currentrow#" id="manager2_exp3_#get_quiz_chapters.currentrow#" value="" cols="70" rows="2" maxlength="1500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>">#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.MANAGER2_EXPLANATION3")#</textarea>
								<cfelse>
									#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.MANAGER2_EXPLANATION3")#<br />
								</cfif>
							</td>
						</tr>
						</cfif>
					</cfif>
				</cfif>
				<cfif (get_quiz_chapters.is_emp_exp4 neq 0) or (get_quiz_chapters.is_chief3_exp4 neq 0) or (get_quiz_chapters.is_chief1_exp4 neq 0) or (get_quiz_chapters.is_chief2_exp4 neq 0)>
					<cfif session.ep.userid neq get_perf_detail.manager_3_emp_id and get_quiz_chapters.is_emp_exp4 eq 1 and get_quiz_chapters.is_chief1_exp4 eq 1 and get_quiz_chapters.is_chief2_exp4 eq 1 and get_quiz_chapters.is_chief3_exp4 neq 1>
						<cfset gorus = 1>
					</cfif>
					<cfif (get_quiz_chapters.is_exp4 eq 1) and len(get_quiz_chapters.exp4_name) and gorus neq 1>
						<tr>
							<td colspan="6" valign="top" nowrap><b>#get_quiz_chapters.exp4_name#</b>&nbsp;</td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id ='31435.Çalışanın Görüş ve Düşünceleri'></td>
						</tr>
						<tr>
							<td colspan="6" valign="top" nowrap>
								<cfif get_perf_detail.emp_id eq session.ep.userid>
									<textarea name="exp4_#get_quiz_chapters.currentrow#" id="exp4_#get_quiz_chapters.currentrow#" value="" cols="70" rows="2" maxlength="1500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>">#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.EXPLANATION4")#</textarea>
								<cfelse>
									#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.EXPLANATION4")#<br />
								</cfif>
							</td>
						</tr>
						<cfif get_perf_detail.emp_id neq session.ep.userid>
						<tr>
							<td><cf_get_lang dictionary_id ='31436.Birinci Değerlendirme Yöneticisinin Görüş ve Düşünceleri'></td>
						</tr>
						<tr>
							<td colspan="6" valign="top" nowrap>
								<cfif get_perf_detail.manager_1_emp_id eq session.ep.userid>
									<textarea name="manager1_exp4_#get_quiz_chapters.currentrow#" id="manager1_exp4_#get_quiz_chapters.currentrow#" value="" cols="70" rows="2" maxlength="1500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>">#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.MANAGER1_EXPLANATION4")#</textarea>
								<cfelse>
									#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.MANAGER1_EXPLANATION4")#<br />
								</cfif>
							</td>
						</tr>
						</cfif>
						<cfif get_perf_detail.MANAGER_3_EMP_ID eq session.ep.userid>
							<tr>
								<td><cf_get_lang dictionary_id ='31725.Görüş Bildirenin Görüş ve Düşünceleri'></td>
							</tr>
							<tr>
								<td><textarea name="manager3_exp4_#get_quiz_chapters.currentrow#" id="manager3_exp4_#get_quiz_chapters.currentrow#" value="" cols="70" rows="2" maxlength="1500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>">#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.MANAGER3_EXPLANATION4")#</textarea><br/></td>
							</tr>
						</cfif>
						<cfif get_perf_detail.emp_id neq session.ep.userid>
						<tr>
							<td><cf_get_lang dictionary_id ='31437.İkinci Değerlendirme Yöneticisinin Görüş ve Düşünceleri'></td>
						</tr>
						<tr>
							<td colspan="6" valign="top" nowrap>
								<cfif get_perf_detail.manager_2_emp_id eq session.ep.userid>
									<textarea name="manager2_exp4_#get_quiz_chapters.currentrow#" id="manager2_exp4_#get_quiz_chapters.currentrow#" value="" cols="70" rows="2" maxlength="1500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>">#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.MANAGER2_EXPLANATION4")#</textarea>
								<cfelse>
									#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.MANAGER2_EXPLANATION4")#<br />
								</cfif>
							</td>
						</tr>
						</cfif>
					</cfif>
				</cfif>
			</table>
	 <cfelse>
     	<table>
            <tr>
                <td><cf_get_lang dictionary_id ='31428.Kayıtlı Soru Bulunamadı'>!</td>
            </tr>
        </table>
	</cfif>
	</cfoutput>
<cfelse>
	<table>
        <tr>
          <td><cf_get_lang dictionary_id ='31429.Kayıtlı Bölüm Bulunamadı'>!</td>
        </tr>
    </table>
</cfif>
<cfquery name="get_quiz_questions_" dbtype="query">
	SELECT * FROM get_quiz_questions WHERE OPEN_ENDED IS NOT NULL
</cfquery>

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
	document.getElementById("gd_" + ilk + "_" + son).checked = false;
}
function check_expl() //* Sürec onay asamasindaysa ve isaretlenmemis soru varsa bu fonksiyon cagrilir..Senay 20061013
{ 
<cfoutput query="get_quiz_chapters">
  <cfset attributes.CHAPTER_ID = CHAPTER_ID>
  <cfinclude template="../query/get_quiz_questions.cfm">
  <cfif get_quiz_questions.RecordCount and get_quiz_chapters.ANSWER_NUMBER>
        <cfloop query="get_quiz_questions_">
		var kontrol_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#=0;
		if(document.getElementById("gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#").checked == false)
		{
			for(var i=0;i<#get_quiz_chapters.answer_number#;i++)
			{
				if(document.add_perform.user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#[i]!=undefined && document.add_perform.user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#[i].checked == true)
				{
					kontrol_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#=1;
					break;
				}
				else  kontrol_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#=0;
			}
		}
		else kontrol_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#=1;
		if(kontrol_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#==0)
		{
			alert("<cf_get_lang dictionary_id ='31739.İşaretlemediğiniz Sorular Var'> !");
			return false;					  
		}
        </cfloop>          
  </cfif>
</cfoutput>
return true;
}
</script>
