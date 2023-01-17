<cfinclude template="../query/get_tra_quiz.cfm">
<cfinclude template="../query/get_quiz_result_count.cfm">
<cfinclude template="../query/get_quiz_questions.cfm">
<cfif get_quiz_result_count.toplam gte 1>
    <div class="form-group">
        <font color="#FF0000"><cf_get_lang no='153.Bu teste katılan kullanıcı olduğu için güncelleme yapılamaz'>!</font>
        <cfabort>
    </div>
</cfif>
<cfset attributes.employee_id = session.ep.userid>
<cfif get_quiz_questions.recordcount>
    <cfoutput query="get_quiz_questions">
    <cfif not (get_quiz_result_count.toplam gte 1)>
        <cfif not listfindnocase(denied_pages,'training_management.emptypopup_del_question_from_quiz')>
            <cfsavecontent variable="rec_message"><cf_get_lang_main no ='121.Silmek istediğinize Emin misiniz'></cfsavecontent>
            <cfset del_href = "if (confirm('#rec_message#')) openBoxDraggable('#request.self#?fuseaction=training_management.emptypopup_del_question_from_quiz&question_id=#question_id#&quiz_id=#url.quiz_id#','del_question_box', 'ui-draggable-box-small'); else return;">
        <cfelse>
            <cfset del_href = "">
        </cfif>
        <cfif not listfindnocase(denied_pages,'training_management.popup_form_upd_question')>
            <cfset upd_href = "openBoxDraggable('#request.self#?fuseaction=training_management.popup_form_upd_question&question_id=#question_id#&quiz_id=#url.quiz_id#','edit_question_box', 'ui-draggable-box-large');">
        <cfelse>
            <cfset upd_href = "">
        </cfif>
    </cfif>
        <cf_box_elements>
            <cf_seperator upd_href="javascript:#upd_href#" del_href="javascript:#del_href#" class="portHeadLight" id="question_#currentrow#" title="#getLang('','Soru',58810)##currentrow#: #question#">
            <div id="question_#currentrow#" class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <div class="col small">
                    <label><font color="red"><cf_get_lang_main no='1572.Puan'>:#question_point#</font></label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12 pull-right">
                    <!--- <b><cf_get_lang_main no='1398.Soru'>#currentrow#:</b> #question# --->
                    <div class="input-group">
                        <cfif ANSWER_NUMBER NEQ 0>
                            <cfset right_number = 0>
                            <cfloop from="1" to="#answer_number#" index="i">
                                <cfif evaluate("answer#i#_true") eq 1>
                                    <cfset right_number = right_number + 1>
                                </cfif>
                            </cfloop>
                            <cfloop from="1" to="20" index="i">
                                <cfif len(evaluate("answer#i#_photo")) or len(evaluate("answer#i#_text"))>
                                        <cfif not (get_quiz_result_count.toplam gte 1)>
                                        </cfif>
                                        <div class="form-group">
                                            <cfif right_number eq 1>
                                                <input type="Radio" name="user_answer_#currentrow#" id="user_answer_#currentrow#">
                                            <cfelse>
                                                <input type="checkbox" name="user_answer_#currentrow#" id="user_answer_#currentrow#">
                                            </cfif>
                                            <cfif len(evaluate("answer"&i&"_photo"))>
                                                <img src="#file_web_path#training/#evaluate("answer"&i&"_photo")#" border="0">
                                            </cfif>
                                            #evaluate('answer#i#_text')#
                                        </div>
                                </cfif>
                            </cfloop>
                        <cfelse>
                            <cfif not (get_quiz_result_count.toplam gte 1)>
                            </cfif>
                            <div class="form-group">
                                <cf_get_lang no='84.Açık Uçlu Soru'>
                            </div>
                        </cfif>
                        <cfif len(question_info)>
                            <div class="form-group">
                                <cf_get_lang_main no='144.Bilgi'> : #question_info# 
                            </div>
                        </cfif>
                    </div>
                </div>
            </div>
        </cf_box_elements>
    </cfoutput>
<cfelse>
    <div class="form-group">
        <cf_get_lang_main no='1074.Kayıt Bulunamadı'>!
    </div>
</cfif>