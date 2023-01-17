<cfparam name="attributes.is_fill" default="0"><!--- yetkinlikten bölüm eklerken bölüme test doldurulmuşmu kontrolü--->
<cfquery name="GET_QUIZ_CHAPTERS" datasource="#dsn#">
	SELECT * FROM EMPLOYEE_QUIZ_CHAPTER WHERE CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.chapter_id#">
</cfquery>
<div class="row">
	<div class="col col-12">
    	<table width="99%" border="0" cellspacing="0" cellpadding="2">
		<cfif get_quiz_chapters.recordcount>
            <cfoutput query="get_quiz_chapters">     
                <cfset answer_number_gelen = get_quiz_chapters.answer_number>
                <cfscript>
                    for (i=1; i lte 20; i = i+1)
                    {
                        "a#i#" = evaluate("get_quiz_chapters.answer#i#_text");
                        "b#i#" = evaluate("get_quiz_chapters.answer#i#_photo");
                    }
                </cfscript>
                <cfset attributes.chapter_id = get_quiz_chapters.chapter_id>
                <tr >
                    <td>
                        <cfif attributes.is_fill eq 0>
                            <cfif not listfindnocase(denied_pages,'hr.popup_form_upd_chapter')>
                                <cfset upd_href = "openBoxDraggable('#request.self#?fuseaction=hr.list_position_req_type&event=updChapter&chapter_id=#GET_QUIZ_CHAPTERS.chapter_id#&req_type_id=#GET_QUIZ_CHAPTERS.req_type_id#','','ui-draggable-box-medium')">
                            <cfelse>
                                <cfset upd_href = "">
                            </cfif>
                            <cfif not listfindnocase(denied_pages,'hr.popup_form_add_question')>
                                <cfif get_quiz_chapters.answer_number NEQ 0>
                                    <cfset add_href = "openBoxDraggable('#request.self#?fuseaction=hr.popup_form_add_question&req_type_id=#get_quiz_chapters.req_type_id#&chapter_id=#get_quiz_chapters.chapter_id#&answertype=1');">
                                <cfelseif  get_quiz_chapters.answer_number eq 0>
                                    <cfset add_href = "openBoxDraggable('#request.self#?fuseaction=hr.popup_form_add_question&req_type_id=#get_quiz_chapters.req_type_id#&chapter_id=#get_quiz_chapters.chapter_id#');">
                                </cfif>
                            <cfelse>
                                <cfset add_href = "">
                            </cfif>
                            <cfif not listfindnocase(denied_pages,'hr.del_quiz_chapter')>
                                <cfsavecontent variable="rec_message"><cf_get_lang dictionary_id='64132.Kayıtlı bölümü ve bu bölüme bağlı soruları siliyorsunuz. Emin misiniz?'></cfsavecontent>
                                <cfset del_href = "if (confirm('#rec_message#')) openBoxDraggable('#request.self#?fuseaction=hr.del_quiz_chapter&chapter_id=#chapter_id#&req_type_id=#req_type_id#'); else return;">
                            <cfelse>
                                <cfset del_href = "">
                        </cfif>
                    </cfif>
                    <cf_seperator title="#getLang('main',675)# #get_quiz_chapters.chapter#<cfif len(get_quiz_chapters.chapter_info)>: #get_quiz_chapters.chapter_info# </cfif>" id="sep1" add_href="javascript:#add_href#" upd_href="javascript:#upd_href#"  del_href="javascript:#del_href#">    
                        <cfquery name="GET_QUIZ_QUESTIONS" datasource="#dsn#">
                            SELECT 
                                *
                            FROM 
                                EMPLOYEE_QUIZ_QUESTION
                            WHERE
                                CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.chapter_id#">
                        </cfquery>
                        <cfif get_quiz_questions.RecordCount>
                            <cf_flat_list id="sep1">
                                <tr height="22">
                                    <!--- Eğer cevaplar yan yana gelecekse, üst satıra cevaplar yazılıyor --->
                                    <cfif get_quiz_chapters.answer_number NEQ 0>
                                        <cfloop from="1" to="20" index="i">
                                            <cfif len(evaluate("answer#i#_photo")) or len(evaluate("answer#i#_text"))>
                                                <td class="txtbold" align="center" width="70">
                                                    <cfif len(evaluate("answer"&i&"_photo"))>
                                                        <!--- <img src="#file_web_path#hr/#evaluate("answer"&i&"_photo")#" border="0"> --->
                                                        <cf_get_server_file output_file="hr/#evaluate("answer"&i&"_photo")#" output_server="#evaluate("answer"&i&"_photo_server_id")#" output_type="0" image_link="1">
                                                    </cfif>
                                                    #evaluate('answer#i#_text')# 
                                                </td>
                                            </cfif>
                                        </cfloop>
                                    </cfif>
                                    
                                </tr>
                                <!--- Sorular başlıyor --->
                                <cfloop query="get_quiz_questions">
                                    <thead>
                                    <tr>
                                        <th> #get_quiz_questions.currentrow#- #get_quiz_questions.question# </th>
                                            <cfif answer_number_gelen NEQ 0>
                                                <cfloop from="1" to="20" index="i">
                                                    <cfif len(evaluate("b#i#")) or len(evaluate("a#i#"))>
                                                        <td align="center">
                                                            <input type="Radio" name="user_answer_#get_quiz_chapters.currentrow#" id="user_answer_#get_quiz_chapters.currentrow#">
                                                        </td>
                                                    </cfif>
                                                </cfloop>
                                                    <cfif attributes.is_fill eq 0>
                                                        <th width="20">
                                                            <cfif not listfindnocase(denied_pages,'hr.popup_form_upd_question')>
                                                                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_form_upd_question&question_id=#get_quiz_questions.question_id#&req_type_id=#req_type_id#&chapter_id=#chapter_id#<cfif ANSWER_NUMBER_gelen NEQ 0>&answertype=1</cfif>', 'small')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='46335.Soru Güncelle'>"></i></a>
                                                            </cfif>
                                                        </th>
                                                        <th width="20">
                                                            <cfif not listfindnocase(denied_pages,'hr.del_question')>
                                                                <a href="javascript://" onClick="javascript:if (confirm('<cf_get_lang dictionary_id='56793.Kayıtlı Soruyu Siliyorsunuz. Emin misiniz'>')) windowopen('#request.self#?fuseaction=hr.del_question&question_id=#question_id#&req_type_id=#req_type_id#','small'); else return;"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='55853.Soru Sil'>"></i></a>
                                                            </cfif>
                                                        </th>
                                                    </cfif>
                                            </tr>
                                            <cfelse>
                                                <cfif attributes.is_fill eq 0>
                                                    <th width="20">
                                                        <cfif not listfindnocase(denied_pages,'hr.popup_form_upd_question')>
                                                            <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=hr.popup_form_upd_question&question_id=#get_quiz_questions.question_id#&req_type_id=#req_type_id#&chapter_id=#chapter_id#<cfif ANSWER_NUMBER_gelen NEQ 0>&answertype=1</cfif>')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='46335.Soru Güncelle'>"></i></a>&nbsp;
                                                        </cfif>
                                                    </th>
                                                    <th width="20">
                                                        <cfif not listfindnocase(denied_pages,'hr.del_question')>
                                                            <a href="javascript://" onClick="javascript:if (confirm('<cf_get_lang dictionary_id='56793.Kayıtlı Soruyu Siliyorsunuz. Emin misiniz'>')) windowopen('#request.self#?fuseaction=hr.del_question&question_id=#question_id#&req_type_id=#req_type_id#','small'); else return;"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='55853.Soru Sil'>"></i></a>
                                                        </cfif>
                                                    </th>
                                                </cfif>
                                            </tr>
                                        
                                    </tr>
                                        
                                            <tr>
                                            
                                            <cfloop from="1" to="20" index="i">
                                                <cfif len(evaluate("get_quiz_questions.answer#i#_photo")) or len(evaluate("get_quiz_questions.answer#i#_text"))>
                                                    <tr>
                                                        <td>
                                                            <input type="radio" name="user_answer_#get_quiz_questions.currentrow#" id="user_answer_#get_quiz_questions.currentrow#">
                                                            <cfif len(evaluate("answer"&i&"_photo"))>
                                                                <!--- <img src="#file_web_path#hr/#evaluate("get_quiz_questions.answer"&i&"_photo")#" border="0"> --->
                                                                <cf_get_server_file output_file="hr/#evaluate("get_quiz_questions.answer"&i&"_photo")#" output_server="#evaluate("get_quiz_questions.answer"&i&"_photo_server_id")#">
                                                            </cfif>
                                                            #evaluate('get_quiz_questions.answer#i#_text')# 
                                                        </td>
                                                    </tr>
                                                </cfif>
                                            </cfloop>
                                        </cfif>
                                    </tr>
                                
                                    <cfif len(question_info)>
                                        
                                        <tr height="20">
                                            <td> #get_quiz_questions.question_info# </td>
                                        </tr>
                                    </cfif>
                                </thead>
                                </cfloop>
                            </cf_flat_list>
                        <cfelse>
                            <tr height="20" class="color-row">
                                <td><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'></td>
                            </tr>
                        </cfif>
                </cfoutput>
        </cfif>
        </table>
    </div>
</div>


