<cfinclude template="../query/get_quiz.cfm">
<cfset attributes.names = 1>
<cfif len(get_quiz.position_cat_id)>
  <cfset attributes.position_cat_id = get_quiz.position_cat_id>
	<cfquery name="GET_POSITION_CAT" datasource="#dsn#">
		SELECT 
			* 
		FROM 
			SETUP_POSITION_CAT 
		WHERE 
			POSITION_CAT_ID IN (#ListSort(attributes.POSITION_CAT_ID,"numeric")#)
	</cfquery>
</cfif>
 <cfif len(get_quiz.RECORD_EMP)>
  <cfset attributes.employee_id = get_quiz.RECORD_EMP>
  <cfinclude template="../query/get_employee.cfm">
</cfif> 
<cfif len(get_quiz.RECORD_par)>
  <cfset attributes.partner_id = get_quiz.RECORD_PAR>
  <cfinclude template="../query/get_partner.cfm">
</cfif>
<cfquery name="GET_QUIZ_CHAPTERS" datasource="#dsn#">
	SELECT 
		*
	FROM 
		EMPLOYEE_QUIZ_CHAPTER
	WHERE
		QUIZ_ID=#attributes.QUIZ_ID#
</cfquery>
<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td class="headbold" height="35"><cf_get_lang_main no='1967.Form'>: <cfoutput>#get_quiz.quiz_head#</cfoutput></td>
    <td style="text-align:right;">
	<cfif not listfindnocase(denied_pages,'training_management.popup_form_add_chapter')>
	  <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=training_management.popup_form_add_chapter&quiz_id=#get_quiz.quiz_id#</cfoutput>', 'list');"><img src="/images/properties.gif" title="<cf_get_lang no='149.Yeni Bölüm Ekle'>" border="0"></a>
	</cfif>  
	<cfif not listfindnocase(denied_pages,'training_management.popup_upd_eval_quiz')>
	  <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=training_management.popup_upd_eval_quiz&quiz_id=#attributes.quiz_id#</cfoutput>', 'small');"><img src="/images/refer.gif" border="0" title="<cf_get_lang no='316.Form Güncelle'>"></a> 
	</cfif> 
	<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=training_management.form_add_eval_quiz"><img border="0" src="images/plus1.gif" align="absmiddle" title="<cf_get_lang_main no='170.Ekle'>"></a>
	 <cfif get_module_user(47)>
	  <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_operate_page&operation=emptypopup_dsp_eval_quiz_print&action=print&id=#url.quiz_id#&module=training_management</cfoutput>','page');return false;"><img src="/images/print.gif" border="0" title="<cf_get_lang_main no='62.Yazdır'>"></a>   
	 </cfif> 
	</td>
  </tr>
</table>
<cfquery name="POSCATS" datasource="#dsn#">
SELECT 
	POSITION_CAT_ID 
FROM 
	EMPLOYEE_QUIZ 
WHERE 
	QUIZ_ID=#attributes.QUIZ_ID#
</cfquery>
<!--- <cfset attributes.employee_id = session.ep.userid> --->
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr class="color-border">
    <td>
      <table width="100%" border="0" cellspacing="1" cellpadding="2">
        <tr class="color-row">
          <td> <cfoutput>
              <table>
                <tr>
                  <td class="txtbold" width="100"><cf_get_lang_main no='344.Durum'><!--- <cf_get_lang_main no='70.Aşama'> ---></td>
                  <td><cfif get_quiz.IS_ACTIVE IS 1>
                      <cf_get_lang_main no='81.Aktif'>
                      <cfelse>
                      <cf_get_lang_main no='82.Pasif'>
                    </cfif>
                  </td>
                </tr>
                <tr>
                  <td class="txtbold"><cf_get_lang_main no='68.Başlık'></td>
                  <td>#get_quiz.QUIZ_HEAD#</td>
                </tr>
                <tr>
                  <td class="txtbold"><cf_get_lang no='32.Amaç'>/<cf_get_lang_main no='217.Açıklama'></td>
                  <td>#get_quiz.QUIZ_OBJECTIVE#</td>
                </tr>
				<Cfif get_quiz.IS_APPLICATION IS 1 OR get_quiz.IS_EDUCATION IS 1 OR get_quiz.IS_TRAINER IS 1>
				<Cfelse>
                <tr>
                  <td class="txtbold"><cf_get_lang_main no='678.İletişim Yöntemi'></td>
                  <td>#get_quiz.COMMETHOD#</td>
                </tr>
                <tr>
                  <td class="txtbold"><cf_get_lang no='243.Uygulama Periyodu'></td>
                  <td>
                    <cfif get_quiz.PERIOD_PART IS 1>
                      <cf_get_lang_main no='1603.Yıllık'>
                      <cfelseif get_quiz.PERIOD_PART IS 2>
                      6 <cf_get_lang_main no='1520.Aylık'>
                      <cfelseif get_quiz.PERIOD_PART IS 3>
                      3 <cf_get_lang_main no='1520.Aylık'>
                      <cfelseif get_quiz.PERIOD_PART IS 4>
                      1 <cf_get_lang_main no='1520.Aylık'>
                    </cfif>
                  </td>
                </tr>
				</Cfif>
				<cfif len(get_quiz.RECORD_EMP)>
                <tr>
                  <td class="txtbold"><cf_get_lang_main no='71.kayıt'></td>
                  <td>#get_emp_info(get_quiz.RECORD_EMP,0,1)# - #DateFormat(get_quiz.RECORD_DATE,dateformat_style)# #TimeFormat(get_quiz.RECORD_DATE,'HH:mm:ss')#</td>
                </tr>
				</cfif>
             	<cfif len(get_quiz.UPDATE_EMP)>
                <tr>
                  <td class="txtbold"><cf_get_lang_main no='479.güncelleyen'></td>
                  <td>#get_emp_info(get_quiz.UPDATE_EMP,0,1)# - #DateFormat(get_quiz.UPDATE_DATE,dateformat_style)# #TimeFormat(get_quiz.UPDATE_DATE,'HH:mm:ss')#</td>
                </tr>
				</cfif>
              </table>
            </cfoutput> </td>
        </tr>
        <cfif get_quiz_chapters.recordcount>
          <cfoutput query="get_quiz_chapters">
          <cfset ANSWER_NUMBER_gelen = get_quiz_chapters.ANSWER_NUMBER>
          <cfscript>
		  	for (i=1; i lte 20; i = i+1)
				{
				"a#i#" = evaluate("get_quiz_chapters.answer#i#_text");
				"b#i#" = evaluate("get_quiz_chapters.answer#i#_photo");
				}
		  </cfscript>
          <cfset attributes.CHAPTER_ID = CHAPTER_ID>
          <tr class="color-list">
            <td>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td class="txtboldblue">#chapter#</td>
                  <td style="text-align:right;"> 
				  	<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_form_add_eval_question&quiz_id=#quiz_id#&chapter_id=#chapter_id#<cfif get_quiz_chapters.ANSWER_NUMBER NEQ 0>&answertype=1</cfif>', 'small');"><img src="/images/plus_thin.gif" title="<cf_get_lang no='96.Yeni Soru Ekle'>" border="0"></a>
                    <cfif not listfindnocase(denied_pages,'training_management.popup_form_upd_chapter')>
                      <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_form_upd_chapter&chapter_id=#chapter_id#&quiz_id=#quiz_id#', 'medium')"><img src="/images/update_list.gif" border="0" title="<cf_get_lang no='314.Bölüm Güncelle'>"></a>
                    </cfif>
                   <cfif not listfindnocase(denied_pages,'training_management.del_quiz_chapter')>
                      <a href="javascript://" onClick="javascript:if (confirm('<cf_get_lang_main no='121.Silmek Istediginizden Emin Misiniz'>')) windowopen('#request.self#?fuseaction=training_management.del_quiz_chapter&chapter_id=#chapter_id#&quiz_id=#quiz_id#','small'); else return;"><img src="/images/delete_list.gif" border="0" title="<cf_get_lang no='315.Bölüm Sil'>"></a>
                    </cfif>
                  </td>
                </tr>
                <cfif len(chapter_info)>
                  <tr height="20" class="color-list">
                    <td colspan="2">#chapter_info#</td>
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
          <tr class="color-row">
            <td>
              <table width="100%" border="0">
                <tr height="22">
                  <td class="formbold"> </td>
                  <!--- Eğer cevaplar yan yana gelecekse, üst satıra cevaplar yazılıyor --->
                  <cfif get_quiz_chapters.ANSWER_NUMBER NEQ 0>
                    <cfloop from="1" to="20" index="i">
                      <cfif len(evaluate("answer#i#_photo")) or len(evaluate("answer#i#_text"))>
                        <td class="txtbold" align="center" width="70">
                          <cfif len(evaluate("answer"&i&"_photo"))>
                           <!---  <img src="#file_web_path#hr/#evaluate("answer"&i&"_photo")#" border="0"> --->
							<cf_get_server_file output_file="hr/#evaluate("answer"&i&"_photo")#" output_server="#evaluate("answer"&i&"_photo_server_id")#" output_type="0" image_link="1" image_width="38" image_height="35">
                          </cfif>
                          #evaluate('answer#i#_text')# &nbsp; </td>
                      </cfif>
                    </cfloop>
                  </cfif>
                  <td class="form-title">&nbsp;</td>
                </tr>
                <!--- Sorular başlıyor --->
                <cfloop query="get_quiz_questions">
                  <tr class="color-list">
                    <td class="txtbold"> #get_quiz_questions.currentrow#- #get_quiz_questions.question# </td>
                    <cfif ANSWER_NUMBER_gelen NEQ 0>
                    <cfloop from="1" to="20" index="i">
                      <cfif len(evaluate("a#i#")) or len(evaluate("b#i#"))>
                        <td  align="center">
                       		<input type="Radio" name="user_answer_#get_quiz_questions.currentrow#" id="user_answer_#get_quiz_questions.currentrow#">
                        </td>
                      </cfif>
                    </cfloop>
                    <td width="50" style="text-align:right;">
                      <cfif not listfindnocase(denied_pages,'training_management.popup_form_upd_eval_question')>
                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_form_upd_eval_question&question_id=#get_quiz_questions.question_id#&quiz_id=#quiz_id#&chapter_id=#CHAPTER_ID#<cfif ANSWER_NUMBER_gelen NEQ 0>&answertype=1</cfif>', 'small')"><img src="/images/update_list.gif" border="0" title="<cf_get_lang no='128.Soru Güncelle'>" ></a>
                      </cfif>
                      <cfif not listfindnocase(denied_pages,'training_management.emptypopup_del_eval_question')>
                        <a href="javascript://" onClick="javascript:if (confirm('<cf_get_lang_main no='121.Silmek Istediginizden Emin Misiniz'>')) windowopen('#request.self#?fuseaction=training_management.emptypopup_del_eval_question&question_id=#question_id#&quiz_id=#quiz_id#','small'); else return;"><img src="/images/delete_list.gif" border="0" title="<cf_get_lang_main no='51.Sil'>" ></a>
                      </cfif>
                    </td>
                  </tr>
                  <cfelse>
                  <td style="text-align:right;">
                      <cfif not listfindnocase(denied_pages,'training_management.popup_form_upd_eval_question')>
                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_form_upd_eval_question&question_id=#get_quiz_questions.question_id#&quiz_id=#quiz_id#&chapter_id=#chapter_id#<cfif ANSWER_NUMBER_gelen NEQ 0>&answertype=1</cfif>', 'small')"><img src="/images/update_list.gif" border="0" title="<cf_get_lang no='128.Soru Güncelle'>" ></a>
                      </cfif>
                      <cfif not listfindnocase(denied_pages,'training_management.emptypopup_del_eval_question')>
                        <a href="javascript://" onClick="javascript:if (confirm('<cf_get_lang_main no='121.Silmek Istediginizden Emin Misiniz'>')) windowopen('#request.self#?fuseaction=training_management.emptypopup_del_eval_question&question_id=#question_id#&quiz_id=#quiz_id#','small'); else return;"><img src="/images/delete_list.gif" border="0" title="<cf_get_lang_main no='51.Sil'>" ></a>
                      </cfif>
                    </td>
                  </tr>
                  <cfloop from="1" to="20" index="i">
                    <cfif len(evaluate("get_quiz_questions.answer#i#_photo")) or len(evaluate("get_quiz_questions.answer#i#_text"))>
                      <tr>
                        <td>
                          <input type="Radio" name="user_answer_#get_quiz_questions.currentrow#" id="user_answer_#get_quiz_questions.currentrow#">
                          <cfif len(evaluate("answer"&i&"_photo"))>
                           <!---  <img src="#file_web_path#hr/#evaluate("get_quiz_questions.answer"&i&"_photo")#" border="0"> --->
						   <cf_get_server_file output_file="hr/#evaluate("get_quiz_questions.answer"&i&"_photo")#" output_server="#evaluate("get_quiz_questions.answer"&i&"_photo_server_id")#" output_type="0"  image_link="1" image_width="38" image_height="35">
                          </cfif>
                          #evaluate('get_quiz_questions.answer#i#_text')# </td>
                      </tr>
                    </cfif>
                  </cfloop>
                  </cfif>
                  <cfif len(question_info)>
                    <tr height="20">
                      <td class="label"> #get_quiz_questions.question_info# </td>
                    </tr>
                  </cfif>
                </cfloop>
              </table>
            </td>
          </tr>
          <cfelse>
			  <tr height="20" class="color-row">
				<td><cf_get_lang no='85.Kayıtlı Soru Bulunamadı'> !</td>
			  </tr>
        </cfif>
        <!--- </table>  --->
        </cfoutput>
        <cfelse>
			<tr height="20" class="color-row">
			  <td><cf_get_lang no='317.Kayıtlı Bölüm Bulunamadı'> !</td>
			</tr>
        </cfif>
      </table>
    </td>
  </tr>
</table>
<br/>
