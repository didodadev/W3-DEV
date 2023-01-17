<cfinclude template="../query/get_quiz.cfm">
<cfset position_cat_id_list = ListSort(get_quiz.position_cat_id,'numeric')>
<cfif len(position_cat_id_list)>
  <cfset attributes.position_cat_id = position_cat_id_list>
  <cfinclude template="../query/get_position_cat.cfm">
</cfif>
<cfif len(get_quiz.RECORD_EMP)>
  <cfset attributes.employee_id = get_quiz.RECORD_EMP>
  <cfinclude template="../query/get_employee.cfm">
</cfif>
<cfif len(get_quiz.RECORD_par)>
  <cfset attributes.partner_id = get_quiz.RECORD_PAR>
  <cfinclude template="../query/get_partner.cfm">
</cfif>
<cfinclude template="../query/get_quiz_chapters.cfm">
<cfquery name="get_segment" datasource="#dsn#">
	SELECT RELATION_FIELD_ID,RELATION_ACTION_ID FROM RELATION_SEGMENT_QUIZ WHERE RELATION_FIELD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.quiz_id#">
</cfquery>
<cfset position_name_list = "">
<cfset display_employee_id = "">
<cfif get_segment.recordcount>
	<cfquery name="get_pos_cat" datasource="#dsn#">
		SELECT POSITION_CAT FROM SETUP_POSITION_CAT WHERE POSITION_CAT_ID IN (#ValueList(get_segment.relation_action_id)#)
	</cfquery>
	<cfset position_name_list = ValueList(get_pos_cat.position_cat,", ")>
	<cfquery name="get_display_employee" datasource="#dsn#">
		SELECT TOP 1 EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID IS NOT NULL AND POSITION_STATUS = 1 AND POSITION_CAT_ID IN (#ValueList(get_segment.relation_action_id)#)
	</cfquery>
	<cfset display_employee_id = get_display_employee.employee_id>
</cfif>
<cfsavecontent variable="txt">
	<cfif not listfindnocase(denied_pages,'hr.popup_form_add_chapter')>
    <cfif get_quiz.IS_APPLICATION is not 1>
        <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_form_list_quiz_emp&quiz_id=#attributes.quiz_id#&maxrows=#session.ep.maxrows#</cfoutput>&form_varmi=1', 'page', 'popup_form_list_quiz_emp');"><img src="/images/partner_plus.gif" title="<cf_get_lang no ='1711.Kişi Seç ve Gönder'>" border="0" align="absmiddle"></a> 
    </cfif>
    <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_form_add_chapter&quiz_id=#get_quiz.quiz_id#</cfoutput>', 'medium', 'popup_form_add_chapter');"><img src="/images/properties.gif" title="<cf_get_lang no='763.Yeni Bölüm Ekle'>" border="0" align='absmiddle'></a> 
    <cfif get_quiz.IS_APPLICATION is 1>
        <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_form_upd_app_quiz&quiz_id=#attributes.quiz_id#</cfoutput>', 'wide', 'popup_form_upd_app_quiz');"><img src="/images/refer.gif" title="<cf_get_lang no ='1710.Performans Formu Güncelle'>" border="0" align='absmiddle'></a>
    <cfelse>
        <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_form_upd_quiz&quiz_id=#attributes.quiz_id#</cfoutput>', 'wide', 'popup_form_upd_quiz');"><img src="/images/refer.gif" title="<cf_get_lang no ='1710.Performans Formu Güncelle'>" border="0" align='absmiddle'></a>
    </cfif>
    <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=myhome.popup_add_perf_emp&EMPLOYEE_ID=#display_employee_id#&quiz_id=#attributes.quiz_id#&display=1</cfoutput>', 'wide', 'popup_add_perf_emp');"><img src="/images/clinick.gif" title="<cf_get_lang no ='18.Performans Formu'>" border="0" align='absmiddle'></a>
    </cfif>
    <cfsavecontent variable="copy_form"><cf_get_lang dictionary_id ='56792.Değerlendirme Formunu Kopyalamak İstediğinize Emin misiniz'></cfsavecontent> 
    <cfif session.ep.ehesap>
    <a href="##" onClick="if (confirm('<cfoutput>#copy_form#</cfoutput>')) window.location.href='<cfoutput>#request.self#?fuseaction=hr.form_copy_quiz&quiz_id=#attributes.quiz_id#</cfoutput>'; else return false;"><img src="/images/plus.gif" border="0" title="<cf_get_lang_main no ='64.Kopyala'>" align="absmiddle"></a>
    </cfif>
</cfsavecontent>
<cfsavecontent variable="txt1">
<cf_get_lang dictionary_id='29764.Form'>: <cfoutput>#get_quiz.quiz_head#</cfoutput>
</cfsavecontent>
<cf_form_box title="#txt1#" right_images="#txt#">
<cfset attributes.employee_id = session.ep.userid>
	<cfoutput>
    <table>
        <tr height="20">
            <td class="txtbold" width="100"><cf_get_lang dictionary_id='57756.Durum'></td>
            <td>
            <cfif get_quiz.IS_ACTIVE IS 1>
                <cf_get_lang dictionary_id='57493.Aktif'>
            <cfelse>
                <cf_get_lang dictionary_id='57494.Pasif'>
            </cfif>
            </td>
        </tr>
        <tr height="20">
            <td class="txtbold"><cf_get_lang dictionary_id='58820.Başlık'></td>
            <td>#get_quiz.QUIZ_HEAD#</td>
        </tr>
        <tr height="20">
            <td class="txtbold"><cf_get_lang dictionary_id='55299.Amaç / Açıklama'></td>
            <td>#get_quiz.QUIZ_OBJECTIVE#</td>
        </tr>
        <cfif get_quiz.IS_INTERVIEW eq 1 OR get_quiz.IS_TEST_TIME eq 1>
        <cfelse>
			<cfif len(get_quiz.COMMETHOD_ID)>
            <tr height="20">
                <td class="txtbold"><cf_get_lang dictionary_id='58090.İletişim Yöntemi'></td>
                <cfquery name="get_method" datasource="#dsn#">
                	SELECT COMMETHOD FROM SETUP_COMMETHOD WHERE COMMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_quiz.COMMETHOD_ID#">
                </cfquery>
                <td>#get_method.COMMETHOD#</td>
            </tr>
            </cfif>
        </cfif>
        <tr height="20">
            <td class="txtbold"><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></td>
            <td>#position_name_list#</td>
        </tr>
    </table>
    </cfoutput>
    <cf_form_box_footer><cf_record_info query_name="get_quiz"></cf_form_box_footer>
</cf_form_box>
<br />
<cf_form_box title="#getLang('main',675)#">
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
            <cf_seperator title="Bölüm : #chapter#" id="bolum_#CHAPTER_ID#">
			<table id="bolum_#CHAPTER_ID#">
				<cfif len(chapter_info)>
                    <tr>
                        <td>
                        	<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_form_add_question&quiz_id=#quiz_id#&chapter_id=#chapter_id#<cfif get_quiz_chapters.ANSWER_NUMBER NEQ 0>&answertype=1</cfif>', 'small', 'popup_form_add_question');"><img src="/images/plus_list.gif" title="<cf_get_lang no='764.Yeni Soru Ekle'>" border="0"></a>
							<cfif not listfindnocase(denied_pages,'hr.popup_form_upd_chapter')>
                                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_form_upd_chapter&chapter_id=#chapter_id#&quiz_id=#quiz_id#', 'medium', 'popup_form_upd_chapter')"><img src="/images/update_list.gif" border="0" title="<cf_get_lang no='765.Bölüm Güncelle'>" ></a>
                            </cfif>
                            <cfsavecontent variable="del_dep"><cf_get_lang no ='1709.Kayıtlı bölümü ve bu bölüme bağlı soruları siliyorsunuz Emin misiniz'></cfsavecontent>
                            <cfif not listfindnocase(denied_pages,'hr.del_quiz_chapter')>
                                <a href="javascript://" onClick="javascript:if (confirm('#del_dep#')) windowopen('#request.self#?fuseaction=hr.del_quiz_chapter&chapter_id=#chapter_id#&quiz_id=#quiz_id#','small'); else return;"><img src="/images/delete_list.gif" border="0" title="<cf_get_lang no='766.Bölüm Sil'>"></a>
                            </cfif>
                            #chapter_info#
						</td>
                    </tr>
                </cfif>
				<cfinclude template="../query/get_quiz_questions.cfm">
				<cfif get_quiz_questions.RecordCount>
				<tr>
				<td>
				<cf_form_list>
					<thead>
					<tr>
						<th colspan="2"></th>
						<!--- Eğer cevaplar yan yana gelecekse, üst satıra cevaplar yazılıyor --->
						<cfif get_quiz_chapters.ANSWER_NUMBER NEQ 0>
						<cfloop from="1" to="20" index="i">
							<cfif len(evaluate("answer#i#_photo")) or len(evaluate("answer#i#_text"))>
								<th width="70" style="text-align:center;">
								<cfif len(evaluate("answer"&i&"_photo"))>
									<cf_get_server_file output_file="hr/#evaluate("answer"&i&"_photo")#" output_server="#evaluate("answer"&i&"_photo_server_id")#" output_type="0" image_link="1" image_width="38" image_height="35">
								</cfif>
								#evaluate('answer#i#_text')#</th>
							</cfif>
						</cfloop>
						</cfif>
					</tr>
					</thead>
					<tbody>
					<!--- Sorular başlıyor --->
					<cfloop query="get_quiz_questions">
					<tr>
						<td>
						<cfif not listfindnocase(denied_pages,'hr.popup_form_upd_question')>
							<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_form_upd_question&question_id=#get_quiz_questions.question_id#&quiz_id=#quiz_id#&chapter_id=#chapter_id#<cfif ANSWER_NUMBER_gelen NEQ 0>&answertype=1</cfif>', 'small', 'popup_form_upd_question')"><img src="/images/update_list.gif" border="0" title="<cf_get_lang no='767.Soru Güncelle'>"></a>
						</cfif>
						<cfsavecontent variable="del_que"><cf_get_lang no ='1708.Kayıtlı Soruyu Siliyorsunuz Emin misiniz'></cfsavecontent>
						<cfif not listfindnocase(denied_pages,'hr.del_question')>
							<a href="javascript://" onClick="javascript:if (confirm('#del_que#')) windowopen('#request.self#?fuseaction=hr.del_question&question_id=#question_id#&quiz_id=#quiz_id#','small'); else return;"><img src="/images/delete_list.gif" border="0" title="<cf_get_lang no='768.Soru Sil'>"></a>
						</cfif>
						</td>
						<td>
					 	<b>#get_quiz_questions.currentrow#- #get_quiz_questions.question#</b>
						</td>
						<cfif ANSWER_NUMBER_gelen NEQ 0>
							<cfloop from="1" to="20" index="i">
								<cfif len(evaluate("b#i#")) or len(evaluate("a#i#"))>
									<td style="text-align:center;">
										<input type="Radio" name="user_answer_#get_quiz_chapters.currentrow#" id="user_answer_#get_quiz_chapters.currentrow#">
									</td>
								</cfif>
							</cfloop>
							</td>
						</tr>
						<cfelse>
							</td>
						</tr>
						<cfloop from="1" to="20" index="i">
							<cfif len(evaluate("get_quiz_questions.answer#i#_photo")) or len(evaluate("get_quiz_questions.answer#i#_text"))>
							<tr>
								<td>
									<input type="Radio" name="user_answer_#get_quiz_questions.currentrow#" id="user_answer_#get_quiz_questions.currentrow#">
									<cfif len(evaluate("answer"&i&"_photo"))>
										<cf_get_server_file output_file="hr/#evaluate("get_quiz_questions.answer"&i&"_photo")#" output_server="#evaluate("get_quiz_questions.answer"&i&"_photo_server_id")#" output_type="0"  image_link="1" image_width="38" image_height="35">
									</cfif>
									#evaluate('get_quiz_questions.answer#i#_text')# 
								</td>
							</tr>
							</cfif>
						</cfloop>
					</cfif>
					<cfif len(question_info)>
						<tr>
							<td>#get_quiz_questions.question_info# </td>
						</tr>
					</cfif>
				</cfloop>
				</cf_form_list>
				</td>
				</tr>
				<cfelse>
					<tr>
						<td><cf_get_lang dictionary_id='55829.Kayıtlı Soru Bulunamadı'></td>
					</tr>
				</cfif>
			</tbody>
            </table>
			<br />
            </cfoutput>
        <cfelse>
        <table>
            <tr>
                <td><cf_get_lang dictionary_id='55830.Kayıtlı Bölüm Bulunamadı'></td>
            </tr>
        </table>
        </cfif>
</cf_form_box>
