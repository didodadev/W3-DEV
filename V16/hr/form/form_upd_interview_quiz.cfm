<cfquery name="GET_EMP_QUIZ_ANSWERS" datasource="#dsn#">
	SELECT 
		EID.*, 
		EI.*
	FROM 
		EMPLOYEES_INTERVIEW_DETAIL EID,
		EMPLOYEES_INTERVIEW EI
	WHERE
		EID.INTERVIEW_ID = EI.INTERVIEW_ID AND
		EID.INTERVIEW_ID IN (	SELECT 
									INTERVIEW_ID 
								FROM 
									EMPLOYEES_INTERVIEW 
								WHERE 
									QUIZ_ID=#attributes.QUIZ_ID# AND 
									EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND
									INTERVIEW_ID = #attributes.INTERVIEW_ID# )
</cfquery>
<cfif isDefined("attributes.quiz_id")>
  <input type="hidden" name="c_quiz_id" id="c_quiz_id" value="<cfoutput>#attributes.quiz_id#</cfoutput>">
</cfif>

<cfsavecontent variable="message"><cf_get_lang dictionary_id="55212.Mülakatlar"></cfsavecontent>
<cf_form_box title="#message#">
    <cfform name="form_interview" action="#request.self#?fuseaction=hr.emptypopup_upd_emp_interview_quiz" method="post">
        <input type="hidden" name="quiz_id" id="quiz_id" value="<cfoutput>#attributes.quiz_id#</cfoutput>">
        <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
        <input type="hidden" name="interview_id" id="interview_id" value="<cfoutput>#attributes.interview_id#</cfoutput>">
        <input type="hidden" name="period_id" id="period_id" value="0">
        <input type="hidden" name="PERIOD_PART_ID" id="PERIOD_PART_ID" value="0">
		<cfif isDefined("attributes.quiz_id")>
          <input type="hidden" name="c_quiz_id" id="c_quiz_id" value="<cfoutput>#attributes.quiz_id#</cfoutput>">
        </cfif>
        <cfquery name="get_fire_detail" datasource="#dsn#" maxrows="1">
            SELECT 
                EIO.*,
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME 
            FROM 
                EMPLOYEES_IN_OUT EIO,
                EMPLOYEES E 
            WHERE 
                E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND
                EIO.EMPLOYEE_ID = #attributes.employee_id#
             ORDER BY EIO.FINISH_DATE DESC
        </cfquery>
        <table>
            <tr>	
                <td>
                    <table width="100%" border="0">
                        <tr>
                            <td class="txtbold" width="120" height="20"><cf_get_lang dictionary_id='57576.Çalışan'> : </td>
                            <td align="left" width="160"><cfoutput>#get_emp_info(attributes.employee_id,0,1)#</cfoutput></td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td class="txtbold" width="120" height="20"><cf_get_lang dictionary_id ='56543.İşe Giriş Tarihi'> : </td>
                            <td align="left" width="160"><cfoutput>#dateformat(get_fire_detail.START_DATE,dateformat_style)#</cfoutput></td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td class="txtbold" width="120" height="20"><cf_get_lang dictionary_id ='55931.İşten Çıkış Tarih'> : </td>
                            <td align="left" width="160"><cfoutput>#dateformat(get_fire_detail.FINISH_DATE,dateformat_style)#</cfoutput></td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td class="txtbold" width="120" height="20"><cf_get_lang dictionary_id ='56701.Görüşmeyi Yapan'> : </td>
                            <td align="left" width="160">
                                <cfif len(GET_EMP_QUIZ_ANSWERS.INTERVIEW_EMP_ID)>
                                    <cfquery name="get_interview_emp_name" datasource="#dsn#">
                                        SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #GET_EMP_QUIZ_ANSWERS.INTERVIEW_EMP_ID#
                                    </cfquery>
                                </cfif>
                                <input type="hidden" name="interview_emp_id" id="interview_emp_id" value="<cfif len(GET_EMP_QUIZ_ANSWERS.INTERVIEW_EMP_ID)><cfoutput>#GET_EMP_QUIZ_ANSWERS.INTERVIEW_EMP_ID#</cfoutput><cfelse><cfoutput>#session.ep.userid#</cfoutput></cfif>">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id ='56702.Görüşmeyi Yapan Kişi Seçmelisiniz'> !</cfsavecontent>
                                <cfif len(GET_EMP_QUIZ_ANSWERS.INTERVIEW_EMP_ID)>
                                    <cfinput type="text" name="interview_emp_name" value="#get_interview_emp_name.EMPLOYEE_NAME# #get_interview_emp_name.EMPLOYEE_SURNAME#" style="width:130;"  message="#message#">&nbsp;
                                <cfelse>
                                    <cfinput type="text" name="interview_emp_name" value="#get_emp_info(session.ep.userid,0,0)#" style="width:130;"  message="#message#">&nbsp;
                                </cfif>
                                <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form_interview.interview_emp_id&field_name=form_interview.interview_emp_name&select_list=1','list');"><img src="/images/plus_thin.gif"  border="0" align="absmiddle"></a>
                            </td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td class="txtbold" width="120" height="20"><cf_get_lang dictionary_id ='56677.Görüşme Tarihi'> : </td>
                            <td align="left" width="160">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id ='56678.Görüşme tarihi girilmelidir'>!</cfsavecontent>
                                <cfif isdate(GET_EMP_QUIZ_ANSWERS.INTERVIEW_DATE) and len(GET_EMP_QUIZ_ANSWERS.INTERVIEW_DATE)>
                                    <cfinput type="text" name="INTERVIEW_DATE" style="width:70px;" value="#dateformat(GET_EMP_QUIZ_ANSWERS.INTERVIEW_DATE,dateformat_style)#" validate="#validate_style#"  message="#message#">
                                <cfelse>
                                    <cfinput type="text" name="INTERVIEW_DATE" style="width:70px;" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#"  message="#message#">
                                </cfif>
                                <cf_wrk_date_image date_field="INTERVIEW_DATE"> &nbsp;
                            </td>
                            <td>&nbsp;</td>
                        </tr>
                    </table>
                </td>
            </tr>
            <cfinclude template="../query/get_quiz_chapters.cfm">
            <cfif get_quiz_chapters.recordcount>
                <cfoutput query="get_quiz_chapters">
                    <cfset ANSWER_NUMBER_gelen = get_quiz_chapters.ANSWER_NUMBER>
                    <cfset attributes.CHAPTER_ID = CHAPTER_ID>
                    <cfquery name="chapter_exp_#get_quiz_chapters.currentrow#" datasource="#dsn#">
                        SELECT EXPLANATION,MANAGER_EXPLANATION,EXPLANATION1,EXPLANATION2,EXPLANATION3,EXPLANATION4 FROM EMPLOYEE_QUIZ_CHAPTER_EXPL WHERE CHAPTER_ID=#CHAPTER_ID# AND RESULT_ID=#attributes.interview_id#
                    </cfquery>
                    <cfscript>
                        for (i=1; i lte 20; i = i+1)
                        {
                            "a#i#" = evaluate("get_quiz_chapters.answer#i#_text");
                            "b#i#" = evaluate("get_quiz_chapters.answer#i#_photo");
                            "c#i#" = evaluate("get_quiz_chapters.answer#i#_point");
                        }
                    </cfscript>
                    <tr>	
						<td>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id="57995.Bölüm"></cfsavecontent>
                            <cf_seperator id="bolum" title="#message#: #chapter#">
                            <table id="bolum" width="100%">
                                <cfif len(chapter_info)>
                                    <tr>
                                        <td><cf_get_lang dictionary_id='57629.Açıklama'> : #chapter_info#</td>
                                    </tr>
                                </cfif>
                            </table>
                        </td>
                    </tr>
                    <cfinclude template="../query/get_quiz_questions.cfm">
                    <cfif get_quiz_questions.RecordCount>
                        <!--- sorular başlıyor --->
                        <tr>
                            <td>
                                <table width="100%" border="0">
                                <cfif get_quiz_chapters.ANSWER_NUMBER NEQ 0>
                                    <tr>
                                        <td width="200">&nbsp;</td>
                                             <td class="formbold" width="25">GD</td>
                                            <!--- Eger cevaplar yan yana gelecekse, üst satira cevaplar yaziliyor --->          
                                            <cfloop from="1" to="20" index="i">
                                                <cfif len(evaluate("answer#i#_photo")) or len(evaluate("answer#i#_text"))>
                                                    <td class="txtbold" align="center">
                                                        <cfif len(evaluate("answer"&i&"_photo"))>
                                                            <cf_get_server_file output_file="hr/#evaluate("answer"&i&"_photo")#" output_server="#evaluate("answer"&i&"_photo_server_id")#" output_type="0"><br/>
                                                        </cfif>
                                                        #evaluate('answer#i#_text')# &nbsp;
                                                    </td>
                                                </cfif>
                                            </cfloop>
                                        </td>                    
                                    </tr>
                                </cfif>
                                <!--- Sorular basliyor --->
                                <cfloop query="get_quiz_questions">
                                    <cfset aaa = get_quiz_questions.QUESTION_ID>
                                    <tr>
                                        <td width="380" class="txtbold"> #get_quiz_questions.currentrow#- #get_quiz_questions.question# </td>
                                         <cfif ANSWER_NUMBER_gelen NEQ 0> <!--- Cevaplar yan yana gelecekse gecersiz deger sorularin cevaplarin yanina yaziyor --->
                                                <td class="txtboldblue">
                                                <input name="gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" id="gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" type="radio" onFocus="radio_degistir(#get_quiz_chapters.currentrow#,#get_quiz_questions.currentrow#);" value="1"
                                                    <cfloop query="GET_EMP_QUIZ_ANSWERS">
                                                            <cfif isdefined("GET_EMP_QUIZ_ANSWERS") AND 
                                                                isdefined("GET_EMP_QUIZ_ANSWERS.INTERVIEW_ID") AND 
                                                                GET_EMP_QUIZ_ANSWERS.QUESTION_ID IS aaa AND 
                                                                GET_EMP_QUIZ_ANSWERS.GD is 1>
                                                            checked
                                                            </cfif>
                                                        </cfloop> autocomplete="off"
                                                        > 
                                                </td>
                                                <cfelse><!--- Cevaplar  alt alta secenegi secili ise gecersiz deger üst satira yaziliyor --->
                                                <tr>
                                                    <td class="txtbold">
                                                        <input name="gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" id="gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" type="radio" onFocus="radio_degistir(#get_quiz_chapters.currentrow#,#get_quiz_questions.currentrow#);"value="1" 
                                                        <cfloop query="GET_EMP_QUIZ_ANSWERS">
                                                                    <cfif isdefined("GET_EMP_QUIZ_ANSWERS") AND 
                                                                            isdefined("GET_EMP_QUIZ_ANSWERS.INTERVIEW_ID") AND 
                                                                            GET_EMP_QUIZ_ANSWERS.QUESTION_ID IS aaa AND 
                                                                            GET_EMP_QUIZ_ANSWERS.GD is 1>
                                                                        checked
                                                                        </cfif>
                                                                    </cfloop> autocomplete="off"
                                                                >  <!--- onClick="calc_user_point();" --->GD
                                                    </td>
                                                </tr>
                                            </cfif>
                                            <cfif ANSWER_NUMBER_gelen NEQ 0>
                                                <cfloop from="1" to="20" index="i">
                                                    <cfif len(evaluate("b#i#")) or len(evaluate("a#i#"))>
                                                        <td align="center">	
                                                            <input name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" type="Radio" onFocus="radio_degistir_2(#get_quiz_chapters.currentrow#,#get_quiz_questions.currentrow#)" value="#i#"
                                                            <cfloop query="GET_EMP_QUIZ_ANSWERS">
                                                                <cfif isdefined("GET_EMP_QUIZ_ANSWERS") and isdefined("GET_EMP_QUIZ_ANSWERS.INTERVIEW_ID") and 
                                                                    GET_EMP_QUIZ_ANSWERS.QUESTION_ID is aaa and
                                                                    GET_EMP_QUIZ_ANSWERS.QUESTION_USER_ANSWER is i>checked</cfif>
                                                            </cfloop> autocomplete="off"
                                                            >
                                                            <input type="Hidden" name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" value="#evaluate('c#i#')#"><!--- value="#evaluate('get_quiz_chapters.answer'&i&'_point')#" --->
                                                        </td>
                                                     <cfelse>
                                                     <td></td>
                                                    </cfif>
                                                </cfloop>         
                                            </tr>		 
                                            <cfelse>
                                                <td  style="text-align:right;"></td>
                                            </tr>
                                            <cfloop from="1" to="20" index="i">
                                                <cfif len(evaluate("get_quiz_questions.answer#i#_photo")) or len(evaluate("get_quiz_questions.answer#i#_text"))>
                                                    <tr>
                                                        <td>
                                                            <input name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" type="Radio" onFocus="radio_degistir_2(#get_quiz_chapters.currentrow#,#get_quiz_questions.currentrow#)" value="#i#"
                                                            <cfloop query="GET_EMP_QUIZ_ANSWERS">
                                                                <cfif IsDefined("GET_EMP_QUIZ_ANSWERS") AND 
                                                                    IsDefined("GET_EMP_QUIZ_ANSWERS.INTERVIEW_ID") AND 
                                                                    GET_EMP_QUIZ_ANSWERS.QUESTION_ID IS aaa AND 
                                                                    GET_EMP_QUIZ_ANSWERS.QUESTION_USER_ANSWER IS i>checked</cfif>
                                                            </cfloop> autocomplete="off" >
                                                            <input type="Hidden" name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" value="#evaluate('get_quiz_questions.answer'&i&'_point')#">
                                                            <cfif len(evaluate("answer"&i&"_photo"))>
                                                                <cf_get_server_file output_file="hr/#evaluate("get_quiz_questions.answer"&i&"_photo")#" output_server="#evaluate("get_quiz_questions.answer"&i&"_photo_server_id")#" output_type="0"><br/>
                                                            </cfif>
                                                            #evaluate('get_quiz_questions.answer#i#_text')#<br/>
                                                        </td>
                                                    </tr>
                                                </cfif>
                                            </cfloop>
                                            </cfif>
                                            <cfif len(question_info)>
                                                <tr height="20">
                                                    <td class="txtbold"><cf_get_lang dictionary_id='55129.Ek Bilgi'> : #get_quiz_questions.question_info# </td>
                                                </tr>
                                            </cfif>
                                            <tr>
                                                <td height="10">&nbsp;</td>
                                            </tr>
                                        </cfloop>
                                    </table>
                            </td>
                        </tr>
                        <tr>
                            <td>
                            <table width="100%" border="0">
                                <cfloop from="1" to="4" index="j">
                                    <cfif len(evaluate('exp#j#_name')) and evaluate('is_exp#j#') eq 1>
                                        <tr>
                                            <td class="txtboldblue" width="120">#evaluate('exp#j#_name')# &nbsp;</td>
                                            <td class="txtboldblue"><textarea name="exp#j#_#get_quiz_chapters.currentrow#" id="exp#j#_#get_quiz_chapters.currentrow#" value="" cols="70" rows="2">#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.EXPLANATION#j#")#</textarea></td>
                                        </tr>
                                    </cfif>
                                </cfloop> 
                            </table>
                            </td>
                        </tr>
                        <cfelse>
                            <tr>
                                <td><cf_get_lang dictionary_id='55829.Kayıtlı Soru Bulunamadı!'></td>
                            </tr>
                        </cfif>
                        <!--- Soru Bölümü --->
                    </cfoutput>
                    <tr>
                        <td>
                        <table>
                            <tr>
                                <td valign="top"><cf_get_lang dictionary_id ='56680.Önemli Notlar'></td>
                            </tr>
                            <tr>
                                <td>
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
                                    <textarea name="notes" id="notes" style="width:400px;height:40px;" maxlength="2000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"><cfif len(GET_EMP_QUIZ_ANSWERS.NOTES)><cfoutput>#GET_EMP_QUIZ_ANSWERS.NOTES#</cfoutput></cfif></textarea></td>
                            </tr>
                        </table>
                        </td>
                    </tr>
                <cfelse>
                    <tr>
                        <td valign="top" class="txtbold">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cf_get_lang dictionary_id='55830.Kayıtlı Bölüm Bulunamadı!'></td>
                    </tr>
                </cfif>
        </table>
        <cf_form_box_footer>
            <cfif get_module_power_user(48)>
                <cf_workcube_buttons is_upd='1'
                    add_function='check_expl_mulakat()' 
                    delete_page_url='#request.self#?fuseaction=hr.emptypopup_del_emp_int&quiz_id=#attributes.quiz_id#&employee_id=#attributes.employee_id#' 
                    delete_alert='Kaydı Siliyorsunuz.Emin misiniz?'>
            <cfelse>
                <cf_workcube_buttons is_upd='1' is_delete='0' add_function='check_expl_mulakat()'>
            </cfif>
        </cf_form_box_footer>
	</cfform>
</cf_form_box>
<!---
<cfform name="form_interview" action="#request.self#?fuseaction=hr.emptypopup_upd_emp_interview_quiz" method="post">
	<input type="hidden" name="quiz_id" value="<cfoutput>#attributes.quiz_id#</cfoutput>">
	<input type="hidden" name="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
	<input type="hidden" name="interview_id" value="<cfoutput>#attributes.interview_id#</cfoutput>">
	<input type="hidden" name="period_id" value="0">
	<input type="hidden" name="PERIOD_PART_ID" value="0">
	<cfquery name="get_fire_detail" datasource="#dsn#" maxrows="1">
		SELECT 
			EIO.*,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME 
		FROM 
			EMPLOYEES_IN_OUT EIO,
			EMPLOYEES E 
		WHERE 
			E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND
			EIO.EMPLOYEE_ID = #attributes.employee_id#
		 ORDER BY EIO.FINISH_DATE DESC
	</cfquery>
	<table width="98%" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td class="headbold" height="35">&nbsp;<cf_get_lang no='127.Mülakat'></td>
		</tr>
	</table>
	<table width="98%" align="center" cellpadding="0" cellspacing="0">
		<tr>
			<td valign="top">
				<table width="98%" cellspacing="0" cellpadding="0">
					<tr class="color-border">
						<td>
						<!--- Soru Bölümü --->
							<table width="100%" cellspacing="1" cellpadding="2">
								<tr class="color-row">	
									<td>
										<table width="100%" border="0">
											<tr class="color-row">
												<td class="txtbold" width="120" height="20"><cf_get_lang_main no='164.Çalışan'> : </td>
												<td align="left" width="160"><cfoutput>#get_emp_info(attributes.employee_id,0,1)#</cfoutput></td>
												<td>&nbsp;</td>
											</tr>
											<tr class="color-row">
												<td class="txtbold" width="120" height="20"><cf_get_lang no ='1458.İşe Giriş Tarihi'> : </td>
												<td align="left" width="160"><cfoutput>#dateformat(get_fire_detail.START_DATE,dateformat_style)#</cfoutput></td>
												<td>&nbsp;</td>
											</tr>
											<tr class="color-row">
												<td class="txtbold" width="120" height="20"><cf_get_lang no ='846.İşten Çıkış Tarih'>i : </td>
												<td align="left" width="160"><cfoutput>#dateformat(get_fire_detail.FINISH_DATE,dateformat_style)#</cfoutput></td>
												<td>&nbsp;</td>
											</tr>
											<tr class="color-row">
												<td class="txtbold" width="120" height="20"><cf_get_lang no ='1616.Görüşmeyi Yapan'> : </td>
												<td align="left" width="160">
													<cfif len(GET_EMP_QUIZ_ANSWERS.INTERVIEW_EMP_ID)>
														<cfquery name="get_interview_emp_name" datasource="#dsn#">
															SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #GET_EMP_QUIZ_ANSWERS.INTERVIEW_EMP_ID#
														</cfquery>
													</cfif>
													<input type="hidden" name="interview_emp_id" value="<cfif len(GET_EMP_QUIZ_ANSWERS.INTERVIEW_EMP_ID)><cfoutput>#GET_EMP_QUIZ_ANSWERS.INTERVIEW_EMP_ID#</cfoutput><cfelse><cfoutput>#session.ep.userid#</cfoutput></cfif>">
													<cfsavecontent variable="message"><cf_get_lang no ='1617.Görüşmeyi Yapan Kişi Seçmelisiniz'> !</cfsavecontent>
													<cfif len(GET_EMP_QUIZ_ANSWERS.INTERVIEW_EMP_ID)>
														<cfinput type="text" name="interview_emp_name" value="#get_interview_emp_name.EMPLOYEE_NAME# #get_interview_emp_name.EMPLOYEE_SURNAME#" style="width:130;"  message="#message#">&nbsp;
													<cfelse>
														<cfinput type="text" name="interview_emp_name" value="#get_emp_info(session.ep.userid,0,0)#" style="width:130;"  message="#message#">&nbsp;
													</cfif>
													<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form_interview.interview_emp_id&field_name=form_interview.interview_emp_name&select_list=1','list');"><img src="/images/plus_thin.gif"  border="0" align="absmiddle"></a>
												</td>
												<td>&nbsp;</td>
											</tr>
											<tr class="color-row">
												<td class="txtbold" width="120" height="20"><cf_get_lang no ='1592.Görüşme Tarihi'> : </td>
												<td align="left" width="160">
													<cfsavecontent variable="message"><cf_get_lang no ='1593.Görüşme tarihi girilmelidir'>!</cfsavecontent>
													<cfif isdate(GET_EMP_QUIZ_ANSWERS.INTERVIEW_DATE) and len(GET_EMP_QUIZ_ANSWERS.INTERVIEW_DATE)>
														<cfinput type="text" name="INTERVIEW_DATE" style="width:70px;" value="#dateformat(GET_EMP_QUIZ_ANSWERS.INTERVIEW_DATE,dateformat_style)#" validate="#validate_style#"  message="#message#">
													<cfelse>
														<cfinput type="text" name="INTERVIEW_DATE" style="width:70px;" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#"  message="#message#">
													</cfif>
													<cf_wrk_date_image date_field="INTERVIEW_DATE"> &nbsp;
												</td>
												<td>&nbsp;</td>
											</tr>
										</table>
									</td>
								</tr>
								<cfinclude template="../query/get_quiz_chapters.cfm">
								<cfif get_quiz_chapters.recordcount>
									<cfoutput query="get_quiz_chapters">
										<cfset ANSWER_NUMBER_gelen = get_quiz_chapters.ANSWER_NUMBER>
										<cfset attributes.CHAPTER_ID = CHAPTER_ID>
										<cfquery name="chapter_exp_#get_quiz_chapters.currentrow#" datasource="#dsn#">
											SELECT EXPLANATION,MANAGER_EXPLANATION,EXPLANATION1,EXPLANATION2,EXPLANATION3,EXPLANATION4 FROM EMPLOYEE_QUIZ_CHAPTER_EXPL WHERE CHAPTER_ID=#CHAPTER_ID# AND RESULT_ID=#attributes.interview_id#
										</cfquery>
										<cfscript>
											for (i=1; i lte 20; i = i+1)
											{
												"a#i#" = evaluate("get_quiz_chapters.answer#i#_text");
												"b#i#" = evaluate("get_quiz_chapters.answer#i#_photo");
												"c#i#" = evaluate("get_quiz_chapters.answer#i#_point");
											}
										</cfscript>
										<tr class="color-row">	
											<td>
												<table width="100%">
													<tr class="color-list">
														<td class="formbold" height="25"><cf_get_lang_main no='583.Bölüm'> : #chapter# </td>
													</tr>
													<cfif len(chapter_info)>
														<tr height="20" class="color-list">
															<td class="color-list"><cf_get_lang_main no='217.Açıklama'> : #chapter_info#</td>
														</tr>
													</cfif>
												</table>
											</td>
										</tr>
										<cfinclude template="../query/get_quiz_questions.cfm">
										<cfif get_quiz_questions.RecordCount>
											<!--- sorular başlıyor --->
											<tr class="color-row">
												<td>
													<table width="100%" border="0">
													<cfif get_quiz_chapters.ANSWER_NUMBER NEQ 0>
														<tr class="color-row">
															<td width="200">&nbsp;</td>
																 <td class="formbold" width="25">GD</td>
																<!--- Eger cevaplar yan yana gelecekse, üst satira cevaplar yaziliyor --->          
																<cfloop from="1" to="20" index="i">
																	<cfif len(evaluate("answer#i#_photo")) or len(evaluate("answer#i#_text"))>
																		<td class="txtbold" align="center">
																			<cfif len(evaluate("answer"&i&"_photo"))>
																				<cf_get_server_file output_file="hr/#evaluate("answer"&i&"_photo")#" output_server="#evaluate("answer"&i&"_photo_server_id")#" output_type="0"><br/>
																			</cfif>
																			#evaluate('answer#i#_text')# &nbsp;
																		</td>
																	</cfif>
																</cfloop>
															</td>                    
														</tr>
													</cfif>
													<!--- Sorular basliyor --->
													<cfloop query="get_quiz_questions">
														<cfset aaa = get_quiz_questions.QUESTION_ID>
														<tr class="color-row">
															<td width="380" class="txtbold" height="20"> #get_quiz_questions.currentrow#- #get_quiz_questions.question# </td>
															 <cfif ANSWER_NUMBER_gelen NEQ 0> <!--- Cevaplar yan yana gelecekse gecersiz deger sorularin cevaplarin yanina yaziyor --->
																	<td class="txtboldblue">
																	<input name="gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" type="radio" onFocus="radio_degistir(#get_quiz_chapters.currentrow#,#get_quiz_questions.currentrow#);" value="1"
																		<cfloop query="GET_EMP_QUIZ_ANSWERS">
																				<cfif isdefined("GET_EMP_QUIZ_ANSWERS") AND 
																					isdefined("GET_EMP_QUIZ_ANSWERS.INTERVIEW_ID") AND 
																					GET_EMP_QUIZ_ANSWERS.QUESTION_ID IS aaa AND 
																					GET_EMP_QUIZ_ANSWERS.GD is 1>
																				checked
																				</cfif>
																			</cfloop> autocomplete="off"
																			> 
																	</td>
																	<cfelse><!--- Cevaplar  alt alta secenegi secili ise gecersiz deger üst satira yaziliyor --->
																	<tr class="color-list">
																	<td class="txtbold">
																		<input name="gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" type="radio" onFocus="radio_degistir(#get_quiz_chapters.currentrow#,#get_quiz_questions.currentrow#);"value="1" 
																		<cfloop query="GET_EMP_QUIZ_ANSWERS">
																					<cfif isdefined("GET_EMP_QUIZ_ANSWERS") AND 
																							isdefined("GET_EMP_QUIZ_ANSWERS.INTERVIEW_ID") AND 
																							GET_EMP_QUIZ_ANSWERS.QUESTION_ID IS aaa AND 
																							GET_EMP_QUIZ_ANSWERS.GD is 1>
																						checked
																						</cfif>
																					</cfloop> autocomplete="off"
																				>  <!--- onClick="calc_user_point();" --->GD
																	</td>
																	</tr>
																</cfif>
																<cfif ANSWER_NUMBER_gelen NEQ 0>
																	<cfloop from="1" to="20" index="i">
																		<cfif len(evaluate("b#i#")) or len(evaluate("a#i#"))>
																			<td align="center">	
																				<input name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" type="Radio" onFocus="radio_degistir_2(#get_quiz_chapters.currentrow#,#get_quiz_questions.currentrow#)" value="#i#"
																				<cfloop query="GET_EMP_QUIZ_ANSWERS">
																					<cfif isdefined("GET_EMP_QUIZ_ANSWERS") and isdefined("GET_EMP_QUIZ_ANSWERS.INTERVIEW_ID") and 
																						GET_EMP_QUIZ_ANSWERS.QUESTION_ID is aaa and
																						GET_EMP_QUIZ_ANSWERS.QUESTION_USER_ANSWER is i>checked</cfif>
																				</cfloop> autocomplete="off"
																				>
																				<input type="Hidden" name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" value="#evaluate('c#i#')#"><!--- value="#evaluate('get_quiz_chapters.answer'&i&'_point')#" --->
																			</td>
																		 <cfelse>
																		 <td></td>
																		</cfif>
																	</cfloop>         
																</tr>		 
																<cfelse>
																	<td  style="text-align:right;"></td>
																</tr>
																<cfloop from="1" to="20" index="i">
																	<cfif len(evaluate("get_quiz_questions.answer#i#_photo")) or len(evaluate("get_quiz_questions.answer#i#_text"))>
																		<tr>
																			<td>
																				<input name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" type="Radio" onFocus="radio_degistir_2(#get_quiz_chapters.currentrow#,#get_quiz_questions.currentrow#)" value="#i#"
																				<cfloop query="GET_EMP_QUIZ_ANSWERS">
																					<cfif IsDefined("GET_EMP_QUIZ_ANSWERS") AND 
																						IsDefined("GET_EMP_QUIZ_ANSWERS.INTERVIEW_ID") AND 
																						GET_EMP_QUIZ_ANSWERS.QUESTION_ID IS aaa AND 
																						GET_EMP_QUIZ_ANSWERS.QUESTION_USER_ANSWER IS i>checked</cfif>
																				</cfloop> autocomplete="off" >
																				<input type="Hidden" name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" value="#evaluate('get_quiz_questions.answer'&i&'_point')#">
																				<cfif len(evaluate("answer"&i&"_photo"))>
																					<cf_get_server_file output_file="hr/#evaluate("get_quiz_questions.answer"&i&"_photo")#" output_server="#evaluate("get_quiz_questions.answer"&i&"_photo_server_id")#" output_type="0"><br/>
																				</cfif>
																				#evaluate('get_quiz_questions.answer#i#_text')#<br/>
																			</td>
																		</tr>
																	</cfif>
																</cfloop>
																</cfif>
																<cfif len(question_info)>
																	<tr height="20">
																		<td class="txtbold"><cf_get_lang no='44.Ek Bilgi'> : #get_quiz_questions.question_info# </td>
																	</tr>
																</cfif>
																<tr>
																	<td height="10">&nbsp;</td>
																</tr>
															</cfloop>
														</table>
												</td>
											</tr>
											<tr class="color-list">
												<td>
												<table width="100%" border="0">
													<cfloop from="1" to="4" index="j">
														<cfif len(evaluate('exp#j#_name')) and evaluate('is_exp#j#') eq 1>
															<tr>
																<td class="txtboldblue" width="120">#evaluate('exp#j#_name')# &nbsp;</td>
																<td class="txtboldblue"><textarea name="exp#j#_#get_quiz_chapters.currentrow#" value="" cols="70" rows="2">#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.EXPLANATION#j#")#</textarea></td>
															</tr>
														</cfif>
													</cfloop> 
												</table>
												</td>
											</tr>
											<cfelse>
												<tr height="20" class="color-row">
													<td><cf_get_lang no='744.Kayıtlı Soru Bulunamadı!'></td>
												</tr>
											</cfif>
											<!--- Soru Bölümü --->
										</cfoutput>
										<tr>
											<td class="color-row">
											<table>
												<tr>
													<td valign="top"><cf_get_lang no ='1595.Önemli Notlar'></td>
												</tr>
												<tr>
													<td>
														<cfsavecontent variable="message"><cf_get_lang_main no='1687.Fazla karakter sayısı'></cfsavecontent>
														<textarea name="notes" id="notes" style="width:400px;height:40px;" maxlength="2000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"><cfif len(GET_EMP_QUIZ_ANSWERS.NOTES)><cfoutput>#GET_EMP_QUIZ_ANSWERS.NOTES#</cfoutput></cfif></textarea></td>
												</tr>
											</table>
											</td>
										</tr>
										<tr>
											<td height="35" align="center" class="color-row">
												<cfif get_module_power_user()>
													<cf_workcube_buttons is_upd='1'
														add_function='check_expl_mulakat()' 
														delete_page_url='#request.self#?fuseaction=hr.emptypopup_del_emp_int&quiz_id=#attributes.quiz_id#&employee_id=#attributes.employee_id#' 
														delete_alert='Kaydı Siliyorsunuz.Emin misiniz?'>
												<cfelse>
													<cf_workcube_buttons is_upd='1' is_delete='0' add_function='check_expl_mulakat()'>
												</cfif>
											</td>
										</tr>
									<cfelse>
										<tr height="800" class="color-row">
											<td valign="top" class="txtbold">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cf_get_lang no='745.Kayıtlı Bölüm Bulunamadı!'></td>
										</tr>
									</table>
							</cfif>	
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</cfform>
--->
<script type="text/javascript">
function radio_degistir(ilk,son)
{
	x = eval("document.form_interview.user_answer_" + ilk + "_" + son + ".length");
			for (i=0; i < x; i++)
				{
				eval("document.form_interview.user_answer_" + ilk + "_" + son)[i].checked = false;
				}
}
function radio_degistir_2(ilk,son)
{
	eval("document.form_interview.gd_" + ilk + "_" + son).checked = false;
}
/*calc_user_point();*/

function check_expl_mulakat()
{ 
<cfoutput query="get_quiz_chapters">
  <cfset attributes.CHAPTER_ID = CHAPTER_ID>
  <cfset attributes.ANSWER_NUMBER = ANSWER_NUMBER>
	<cfquery name="GET_QUIZ_QUESTIONSS" datasource="#dsn#">
		SELECT 
			*
		FROM 
			EMPLOYEE_QUIZ_QUESTION
		WHERE
			CHAPTER_ID=#attributes.CHAPTER_ID#
	</cfquery>
  <cfif get_quiz_questionss.RecordCount and attributes.ANSWER_NUMBER>
        <cfloop query="get_quiz_questionss">
			var kontrol_#get_quiz_chapters.currentrow#_#get_quiz_questionss.currentrow#=0;
			if(document.form_interview.gd_#get_quiz_chapters.currentrow#_#get_quiz_questionss.currentrow#.checked == false)
			{
				for(var i=0;i<#attributes.ANSWER_NUMBER#;i++)
				{
					if(document.form_interview.user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questionss.currentrow#[i]!=undefined && document.form_interview.user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questionss.currentrow#[i].checked == true)
					{
						kontrol_#get_quiz_chapters.currentrow#_#get_quiz_questionss.currentrow#=1;
						break;
					}else  kontrol_#get_quiz_chapters.currentrow#_#get_quiz_questionss.currentrow#=0;
				}
			}else kontrol_#get_quiz_chapters.currentrow#_#get_quiz_questionss.currentrow#=1;
			
			if(kontrol_#get_quiz_chapters.currentrow#_#get_quiz_questionss.currentrow#==0)
				{
					alert("<cf_get_lang dictionary_id ='56703.İşaretlemediğiniz Sorular Var'> !");
					return false;					  
				}
		</cfloop>          
  </cfif>
</cfoutput>
return true;
}
</script>
