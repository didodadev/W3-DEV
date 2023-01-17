<cfquery name="RESULT_DETAIL" datasource="#DSN#">
	SELECT 
		*
	FROM 
		MEMBER_ANALYSIS_RESULTS
	WHERE 
		RESULT_ID = #attributes.result_id#
</cfquery>

<cfif ((isDefined("url.partner_id") and len(url.partner_id)) or (isDefined("url.partner_id") and len(url.consumer_id)) or (isDefined("url.partner_id") and len(url.rival_id)) )>
    <cfif attributes.member_type eq "partner">
        <cfquery name="GET_PARTNER" datasource="#DSN#">
            SELECT 
                CP.COMPANY_PARTNER_NAME,
                CP.COMPANY_PARTNER_SURNAME,
                C.NICKNAME
            FROM
                COMPANY_PARTNER CP, 
                COMPANY C
            WHERE 
                CP.PARTNER_ID = #url.partner_id# AND
                CP.COMPANY_ID = C.COMPANY_ID
        </cfquery>
    <cfelseif attributes.member_type eq "consumer">
        <cfquery name="GET_CONSUMER" datasource="#DSN#">
            SELECT CONSUMER_NAME, CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID = #url.consumer_id#	
        </cfquery>
    <cfelseif attributes.member_type eq "rival">
        <cfquery name="GET_RIVAL" datasource="#DSN#">
            SELECT R_ID, RIVAL_NAME FROM SETUP_RIVALS WHERE R_ID = #url.rival_id#	
        </cfquery>
    </cfif>
<cfelseif len(RESULT_DETAIL.company_id)>
    <cfquery name="get_company" datasource="#DSN#">
        SELECT 
            FULLNAME
        FROM
            COMPANY C
        WHERE 
            COMPANY_ID= #RESULT_DETAIL.company_id#
    </cfquery>
</cfif>
<cfinclude template="../query/get_analysis.cfm">
<cfinclude template="../query/get_analysis_questions.cfm">
<cfquery name="MEMBER_ANALYSIS_RESULTS_DETAILS_ALL" datasource="#DSN#">
	SELECT 
		RESULT_DETAIL_ID, 
		RESULT_ID,
		QUESTION_ID,
		QUESTION_POINT,
		QUESTION_USER_ANSWERS
	FROM 
		MEMBER_ANALYSIS_RESULTS_DETAILS 
	WHERE 
		RESULT_ID = #attributes.result_id#
</cfquery>
<!---
<cfsavecontent variable="txt">
    <a href="javascript://" onclick=""><img src="/images/print.gif" border="0" title="<cf_get_lang_main no='62.Yazdır'>"></a>
</cfsavecontent>
--->
<cfsavecontent variable="message"><cf_get_lang dictionary_id="57560.Analiz"></cfsavecontent>
<cfset pageHead = "#message# : #get_analysis.analysis_head#">
<cfif not isDefined("attributes.draggable")>
    <cf_catalystHeader>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box
    title="#message#: #get_analysis.analysis_head#"
    closable="0"
    collapsable="0"
    popup_box="#iif(isdefined("attributes.draggable"),1,0)#"
    scroll="1"
    add_href="javascript:openBoxDraggable('#request.self#?fuseaction=member.list_analysis&event=add-result&analysis_id=#attributes.analysis_id#')"
    list_href="#request.self#?fuseaction=member.list_analysis"
    print_href="#request.self#?fuseaction=objects.popup_print_files&action_id=#url.analysis_id#&action=#attributes.fuseaction#&action_row_id=#url.result_id#">
        <form name="upd_member_analysis" method="post" action="<cfoutput>#request.self#?fuseaction=member.emptypopup_upd_member_analysis_result</cfoutput>">
            <input type="hidden" name="analysis_id" id="analysis_id" value="<cfoutput>#attributes.analysis_id#</cfoutput>">
            <input type="hidden" name="result_id" id="result_id" value="<cfoutput>#attributes.result_id#</cfoutput>">
            <input type="hidden" name="draggable" id="draggable" value="<cfif isDefined('attributes.draggable')>1<cfelse>0</cfif>">
            <cf_box_elements vertical="1">
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-">
                        <label class="col col-12 bold">
                            <cfoutput>
                                <cfif not ((isDefined("url.partner_id") and len(url.partner_id)) or (isDefined("url.partner_id") and len(url.consumer_id)) or (isDefined("url.partner_id") and len(url.rival_id)) )>
                                    <cf_get_lang dictionary_id='57574.Şirket'>/<cf_get_lang dictionary_id='57578.Yetkili'>: #RESULT_DETAIL.ATTENDANCE_COMPANY# - #RESULT_DETAIL.ATTENDANCE_NAME#<cfif len(RESULT_DETAIL.company_id)>(#get_company.FULLNAME#)</cfif>
                                <cfelseif attributes.member_type eq "partner">
                                    <cf_get_lang dictionary_id='57574.Şirket'>/<cf_get_lang dictionary_id='57578.Yetkili'>: #get_partner.nickname# - #get_partner.company_partner_name# #get_partner.company_partner_surname#
                                <cfelseif  attributes.member_type eq "consumer">
                                    <cf_get_lang dictionary_id='57586.Bireysel Üye'>: #get_consumer.consumer_name# #get_consumer.consumer_surname#
                                <cfelseif  attributes.member_type eq "rival">
                                    <cf_get_lang dictionary_id='58779.Rakip'>: #get_rival.rival_name#
                                </cfif>
                            </cfoutput>
                        </label>
                    </div> 
                    <div class="ListContent">
                        <cfoutput query="get_analysis_questions">
                            <cfquery name="GET_RESULT_DETAIL" dbtype="query">
                                SELECT * FROM MEMBER_ANALYSIS_RESULTS_DETAILS_ALL WHERE QUESTION_ID = #get_analysis_questions.question_id#
                            </cfquery>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id="58810.Soru"></cfsavecontent>
                            <cf_seperator id="puan#currentrow#" header="#message# #currentrow# : #question#">
                            <div class="row" id="puan#currentrow#">
                                <cfif answer_number neq 0>
                                    <cfset attributes.question_id = get_analysis_questions.question_id>
                                    <cfinclude template="../query/get_question_answers.cfm">
                                    <cfloop query="get_question_answers">	
                                        <cfset temp_answer_photo = evaluate('get_question_answers.answer_photo')>
                                        <cfset temp_answer_photo_server_id = evaluate('get_question_answers.answer_photo_server_id')>
                                        <cfset temp_answer_text = evaluate('get_question_answers.answer_text')>
                                        <cfset temp_answer_point = evaluate('get_question_answers.answer_point')>
                                        <cfif len(temp_answer_photo) or len(temp_answer_text)>
                                            <label class="hoverseperator col col-12"><br/>
                                                <cfswitch expression="#get_analysis_questions.question_type#">
                                                    <cfcase value="1">
                                                        <input type="radio" name="user_answer_#get_analysis_questions.currentrow#" id="user_answer_#get_analysis_questions.currentrow#" value="#get_question_answers.currentrow#" <cfif ListFind(get_result_detail.question_user_answers,get_question_answers.currentrow,",")> checked</cfif>>
                                                    </cfcase>
                                                    <cfcase value="2">
                                                        <input type="checkbox" name="user_answer_#get_analysis_questions.currentrow#" id="user_answer_#get_analysis_questions.currentrow#" value="#get_question_answers.currentrow#" <cfif ListFind(get_result_detail.question_user_answers,get_question_answers.currentrow,",")> checked</cfif>>
                                                    </cfcase>
                                                </cfswitch>
                                                <input type="hidden" name="user_answer_#get_analysis_questions.currentrow#_point" id="user_answer_#get_analysis_questions.currentrow#_point" value="#temp_answer_point#">
                                                <cfif len(temp_answer_photo)>
                                                    <cf_get_server_file output_file="member/#temp_answer_photo#" output_server="#temp_answer_photo_server_id#" output_type="2" small_image="/images/photo.gif" image_link="1">
                                                </cfif>
                                                #temp_answer_text#
                                                <span class="font-red bold">(#temp_answer_point#)</span>
                                            </label>
                                        </cfif>
                                    </cfloop>
                                <cfelseif get_analysis_questions.answer_number eq 0 or get_analysis_questions.question_type eq 3>
                                    <div class="col col-3">
                                        <cfif get_result_detail.recordcount>
                                            <input type="text" name="open_question_#currentrow#" id="open_question_#currentrow#" value="<cfif len(get_result_detail.question_point)>#get_result_detail.question_point#<cfelse>0</cfif>" style="width:25px"> 
                                        <cfelse>
                                            <input type="text" name="open_question_#currentrow#" id="open_question_#currentrow#" value="0" style="width:25px"> 
                                        </cfif>
                                    </div>
                                    <div class="col col-9">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="59890.En Fazla 1500 Karakter Girebilirsiniz"></cfsavecontent>
                                        <textarea name="user_answer_#question_id#_#currentrow#" id="user_answer_#question_id#_#currentrow#" cols="45" rows="4" maxlength="1500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>">#left(get_result_detail.question_user_answers,1000)#</textarea>
                                    </div>                                    
                                </cfif>
                                <cfif len(question_info)>
                                <label class="col col-12">
                                    <cf_get_lang dictionary_id='57556.Bilgi'> :</b> #question_info#
                                    </label>
                                </cfif>
                            </div>
                        </cfoutput> 
                        <cfoutput query="result_detail">
                            <label class="col col-12 bold"><cf_get_lang dictionary_id='58985.Toplam Puan'>: #user_point#</label>
                        </cfoutput>
                    </div>
                </div>
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                    <cf_box_footer>
                            <cf_record_info 
                                query_name="result_detail" 
                                record_emp="RECORD_EMP" 
                                update_emp="UPDATE_EMP" 
                                record_date="RECORD_DATE" 
                                update_date="UPDATE_DATE">
                            <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=member.emptypopup_del_member_analysis_result&result_id=#attributes.result_id#&analysis_id=#attributes.analysis_id#'>
                    </cf_box_footer>
                </div>
            </cf_box_elements>     
        </form>
    </cf_box>
</div>