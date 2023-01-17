<cfset cfc=createObject("component","V16.training_management.cfc.training_survey")> 
<cf_get_lang_set module_name="settings">
<cfsetting showdebugoutput="no">
<cfset get_process=cfc.GetProcess()> 
<cfset get_language=cfc.GetLanguage()> 
<cfset get_survey=cfc.GetSurvey(survey_id:attributes.survey_id)>
<cfsavecontent variable="img_">
	<cfif fuseaction contains 'objects'>
        <cfset fuseact = 'popup_list_participants'>
    <cfelse>
        <cfset fuseact = 'list_participants'>
    </cfif>
    <cfoutput>
		<a href=""><img src="images/plus.gif" title="<cf_get_lang dictionary_id='57476.Kopyala'>"></a>
		<!--- <a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.#fuseact#&survey_id=#attributes.survey_id#&action_type=#get_survey.type#"><img src="images/quiz.gif" border="0" title="<cf_get_lang_main no='1982.Analiz Sonucu'>" alt="<cf_get_lang_main no='1982.Analiz Sonucu'>"></a> --->
		
		<a href="##" onClick="javascript:"><img src="images/report.gif" title="<cf_get_lang dictionary_id='29838.Tümünü İlişkilendir'>"></a>
	</cfoutput>
</cfsavecontent>
<cfif not isdefined("attributes.related_submit")>
    <cf_catalystHeader>
</cfif>
<div class="row">
    <div class="col col-12 col-xs-12 uniqueRow">
    <cf_box>
        <cf_box_elements>
    	<div class="row formContent">
    	    <div class="row">
				<cfform name="upd_survey" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_detail_survey">
            	<input type="hidden" name="survey_id" id="survey_id" value="<cfoutput>#attributes.survey_id#</cfoutput>">
				<cfif fuseaction contains 'popup'>
                    <input type="hidden" name="is_popup" id="is_popup" value="1">
                </cfif>
                <div class="row" type="row">
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
                        <div class="form-group" id="item-active">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
                            <label><cf_get_lang dictionary_id='57493.Aktif'><input type="checkbox" name="is_active" id="is_active" <cfif get_survey.is_active eq 1> checked</cfif>></label>
                        </div>
                        <div class="form-group" id="item-head">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58820.Başlık'> *</label>
                            <div class="col col-9 col-xs-12">
                                <input type="text" name="head" id="head" value="<cfoutput>#get_survey.survey_main_head#</cfoutput>" style="width:200px;" maxlength="50">
                            </div>
                        </div>
                        <div class="form-group" id="item-detail">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57771.Detay'></label>
                            <div class="col col-9 col-xs-12">
                                <textarea name="detail" id="detail" style="width:200px;height:80px;" maxlength="4000" onkeyup="return ismaxlength(this);" onblur="return ismaxlength(this);"><cfoutput>#URLDecode(get_survey.survey_main_details)#</cfoutput></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="2">
                        <div class="form-group" id="analysis_average">
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-3">
                                <span class="input-group-addon no-bg"><cf_get_lang dictionary_id='29774.Uygunluk Sınırı'></span>
                            </div>
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                <input type="text" name="analysis_average" id="analysis_average" value="<cfoutput>#get_survey.average_score#</cfoutput>" maxlength="3" onkeyup="isNumber(this);" class="moneybox" style="width:40px;">
                            </div>
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-3">
                                <span class="input-group-addon no-bg"><cf_get_lang dictionary_id='58909.Max'> <cf_get_lang dictionary_id='58984.Puan'></span>
                            </div>
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                <input type="text" name="total_score" id="total_score" value="<cfoutput>#get_survey.total_score#</cfoutput>" maxlength="3" onkeyup="isNumber(this);" class="moneybox" style="width:40px;">
                            </div>
                        </div>
                        <div class="form-group" id="item-type">
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-3"><label><cf_get_lang dictionary_id='57630.Tip'> *</label></div>
                            <div class="col col-9 col-xs-12">
                                <cfset get_survey_result=cfc.GetSurveyResult(survey_id:attributes.survey_id)>
                                <cfif get_survey_result.recordcount><input type="hidden" name="type" id="type" value="<cfoutput>#get_survey.type#</cfoutput>"></cfif>
                                <select name="type" id="type" style="width:160px;" <cfif get_survey_result.recordcount>disabled="disabled"</cfif> onchange="is_perf(this.value);">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <option value="14" <cfif get_survey.type eq 14>selected</cfif>><cf_get_lang dictionary_id='58662.Anket'></option>
                                    <option value="6" <cfif get_survey.type eq 6>selected</cfif>><cf_get_lang dictionary_id='29776.Deneme Süresi'></option>
                                    <option value="9" <cfif get_survey.type eq 9>selected</cfif>><cf_get_lang dictionary_id='57419.Eğitim'></option>
                                    <option value="16" <cfif get_survey.type eq 16>selected</cfif>><cf_get_lang dictionary_id='29465.Etkinlik'></option>
                                    <option value="1" <cfif get_survey.type eq 1>selected</cfif>><cf_get_lang dictionary_id='57612.Fırsat'></option>
                                    <option value="2" <cfif get_survey.type eq 2>selected</cfif>><cf_get_lang dictionary_id='57653.İçerik'></option>
                                    <option value="11" <cfif get_survey.type eq 11>selected</cfif>><cf_get_lang dictionary_id='58445.İş'></option>
                                    <option value="7" <cfif get_survey.type eq 7>selected</cfif>><cf_get_lang dictionary_id='57996.İşe Alım'></option>
                                    <option value="10" <cfif get_survey.type eq 10>selected</cfif>><cf_get_lang dictionary_id='29832.İşten Çıkış'></option>
                                    <option value="3" <cfif get_survey.type eq 3>selected</cfif>><cf_get_lang dictionary_id='57446.Kampanya'></option>
                                    <option value="8" <cfif get_survey.type eq 8>selected</cfif>><cf_get_lang dictionary_id='58003.Performans'></option>
                                    <option value="5" <cfif get_survey.type eq 5>selected</cfif>><cf_get_lang dictionary_id='57416.Proje'></option>
                                    <option value="15" <cfif get_survey.type eq 15>selected</cfif>><cf_get_lang dictionary_id='30048.Satınalma Teklifleri'></option>
                                    <option value="12" <cfif get_survey.type eq 12>selected</cfif>><cf_get_lang dictionary_id='30007.Satış Teklifleri'></option>
                                    <option value="13" <cfif get_survey.type eq 13>selected</cfif>><cf_get_lang dictionary_id='57611.Sipariş'></option>
                                    <option value="4" <cfif get_survey.type eq 4>selected</cfif>><cf_get_lang dictionary_id='57657.Ürün'></option>
                                    <option value="17" <cfif get_survey.type eq 17>selected</cfif>><cf_get_lang dictionary_id='60095.Mal Kabul'></option>
                                    <option value="18" <cfif get_survey.type eq 18>selected</cfif>><cf_get_lang dictionary_id='45452.Sevkiyat'></option>
                                    <option value="19" <cfif get_survey.type eq 19>selected</cfif>><cf_get_lang dictionary_id='57438.Call Center'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-process">
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-3"><label><cf_get_lang dictionary_id="58859.Süreç"></label></div>
                            <div class="col col-9 col-xs-12">
                                <cf_workcube_process is_upd='0' select_value = '#get_survey.process_row_id#' process_cat_width='160' is_detail='1'>
                            </div>
                        </div>
                        <div class="form-group" id="item-process_id">
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-3"><label><cf_get_lang dictionary_id='30013.Form Süreci'></label></div>
                            <div class="col col-9 col-xs-12">
                                <select name="process_id" id="process_id" style="width:160px;">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfloop query="get_process">
                                        <option value="<cfoutput>#process_id#</cfoutput>" <cfif process_id eq get_survey.process_id>selected</cfif>><cfoutput>#process_name#</cfoutput></option>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-employee">
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-3"><label><cf_get_lang dictionary_id='29775.Hazırlayan'></label></div>
                            <div class="col col-9 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="employee_id" id="employee_id" value="<cfif len(get_survey.emp_id)><cfoutput>#get_survey.emp_id#</cfoutput><cfelse><cfoutput>#session.ep.userid#</cfoutput></cfif>">
                                    <input type="text" name="employee" id="employee" value="<cfif len(get_survey.emp_id)><cfoutput>#get_emp_info(get_survey.emp_id,0,0)#</cfoutput><cfelse><cfoutput>#get_emp_info(session.ep.userid,0,0)#</cfoutput></cfif>" style="width:160px;" readonly><!--- onFocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','135');" --->
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=upd_survey.employee_id&field_name=upd_survey.employee&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.upd_survey.employee.value),'list');"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="3">
                        <div class="form-group" id="item-score1">
                            <label class="hide"><cf_get_lang dictionary_id='58135.Sonuçlar'></label>
                            <div class="col col-12">
                                <div class="form-group">
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12 bold">
                                        <cf_get_lang dictionary_id='29772.Skor'>
                                    </div>
                                        <div class="col col-2 col-md-2 col-sm-2 col-xs-2"><span class="input-group-addon no-bg">&nbsp;</span></div>
                                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12 bold">
                                        <cf_get_lang dictionary_id='29805.Yorum'>
                                    </div>
                                </div>
                                <div class="form-group mb-0">
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                        <input type="text" name="score1" id="score1" value="<cfoutput>#get_survey.score1#</cfoutput>" validate="integer" style="width:30px;" maxlength="3" class="moneybox" onKeyUp="isNumber(this);">
                                    </div>
                                        <div class="col col-2 col-md-2 col-sm-2 col-xs-2"><span class="input-group-addon no-bg"><cf_get_lang dictionary_id='29773.üstü'></span></div>
                                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                        <input type="text" name="comment1" id="comment1" value="<cfoutput>#get_survey.comment1#</cfoutput>" style="width:200px;">
                                    </div>
                                </div>
                                <div class="form-group mb-0">
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                        <input type="text" name="score2" id="score2" value="<cfoutput>#get_survey.score2#</cfoutput>" validate="integer" style="width:30px;" maxlength="3" class="moneybox" onKeyUp="isNumber(this);"> 
                                    </div>
                                        <div class="col col-2 col-md-2 col-sm-2 col-xs-2"><span class="input-group-addon no-bg"><cf_get_lang dictionary_id='29773.üstü'></span></div>
                                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                        <input type="text" name="comment2" id="comment2" value="<cfoutput>#get_survey.comment2#</cfoutput>" style="width:200px;">
                                    </div>
                                </div>
                                <div class="form-group mb-0">
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                        <input type="text" name="score3" id="score3" value="<cfoutput>#get_survey.score3#</cfoutput>" validate="integer" style="width:30px;" maxlength="3" class="moneybox" onKeyUp="isNumber(this);">
                                    </div>
                                        <div class="col col-2 col-md-2 col-sm-2 col-xs-2"><span class="input-group-addon no-bg"><cf_get_lang dictionary_id='29773.üstü'></span></div>
                                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                        <input type="text" name="comment3" id="comment3" value="<cfoutput>#get_survey.comment3#</cfoutput>" style="width:200px;">
                                    </div>
                                </div>
                                <div class="form-group mb-0">
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                        <input type="text" name="score4" id="score4" value="<cfoutput>#get_survey.score4#</cfoutput>" validate="integer" style="width:30px;" maxlength="3" class="moneybox" onKeyUp="isNumber(this);">
                                    </div>
                                        <div class="col col-2 col-md-2 col-sm-2 col-xs-2"><span class="input-group-addon no-bg"><cf_get_lang dictionary_id='29773.üstü'></span></div>
                                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                        <input type="text" name="comment4" id="comment4" value="<cfoutput>#get_survey.comment4#</cfoutput>" style="width:200px;">
                                    </div>
                                </div>
                                <div class="form-group mb-0">
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                        <input type="text" name="score5" id="score5" value="<cfoutput>#get_survey.score5#</cfoutput>" validate="integer" style="width:30px;" maxlength="3" class="moneybox" onKeyUp="isNumber(this);">
                                    </div>
                                        <div class="col col-2 col-md-2 col-sm-2 col-xs-2"><span class="input-group-addon no-bg"><cf_get_lang dictionary_id='29773.üstü'></span></div>
                                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                        <input type="text" name="comment5" id="comment5" value="<cfoutput>#get_survey.comment5#</cfoutput>" style="width:200px;">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row" type="row">
                    <cfset i = 4 >
                    <div id="performance_detail" <cfif listfind('8,14',get_survey.type)> class="col col-12 col-xs-12" type="column" sort="true" index="<cfoutput>#i#</cfoutput>"<cfset i = i+1><cfelse> style='display:none' </cfif>>
                        <cf_seperator title="#getLang('','Veri Toplama Aralığı ve Veri Kaynağı',62554)#" id="degerlendiriciler" is_closed="1">
                        <div class="form-group" id="degerlendiriciler">
							<div class="col col-4 col-md-6 col-xs-12" <cfif not listfind('8',get_survey.type)>style="display:none";</cfif>>
                                <table>
                                    <tr>
                                        <td><b><cf_get_lang dictionary_id='29907.Değerlendiriciler'></b></td>
                                        <td><b><cf_get_lang dictionary_id='29784.Ağırlık'></b></td>
                                    </tr>
                                    <tr>
                                        <td><input type="checkbox" name="IS_MANAGER_0" id="IS_MANAGER_0" <cfif get_survey.is_manager_0 eq 1>checked</cfif>><cf_get_lang dictionary_id="57576.Çalışan"></td>
                                        <td><cfinput type="text" name="emp_quiz_weight" id="emp_quiz_weight" value="#tlformat(get_survey.emp_quiz_weight)#" validate="float" style="width:30px" range="0,100" onkeyup="return(FormatCurrency(this,event));"></td>
                                    </tr>
                                    <tr>
                                        <td><input type="checkbox" name="IS_MANAGER_3" id="IS_MANAGER_3" <cfif get_survey.is_manager_3 eq 1>checked</cfif>><cf_get_lang dictionary_id="29908.Görüş Bildiren"></td>
                                        <td><cfinput type="text" name="manager_quiz_weight_3" id="manager_quiz_weight_3" value="#tlformat(get_survey.manager_quiz_weight_3)#" validate="float" style="width:30px" range="0,100" onkeyup="return(FormatCurrency(this,event));"></td>
                                    </tr>
                                    <tr>
                                        <td><input type="checkbox" name="IS_MANAGER_1" id="IS_MANAGER_1" <cfif get_survey.is_manager_1 eq 1>checked</cfif>><cf_get_lang dictionary_id='35927.Birinci Amir'></td>
                                        <td><cfinput type="text" name="manager_quiz_weight_1" id="manager_quiz_weight_1" value="#tlformat(get_survey.manager_quiz_weight_1)#" validate="float" style="width:30px" range="0,100" onkeyup="return(FormatCurrency(this,event));"></td>
                                    </tr>
                                    <tr>
                                        <td><input type="checkbox" name="IS_MANAGER_4" id="IS_MANAGER_4" <cfif get_survey.is_manager_4 eq 1>checked</cfif>><cf_get_lang dictionary_id="29909.Ortak Değerlendirme"></td>
                                        <td><cfinput type="text" name="manager_quiz_weight_4" id="manager_quiz_weight_4" value="#tlformat(get_survey.manager_quiz_weight_4)#" validate="float" style="width:30px" range="0,100" onkeyup="return(FormatCurrency(this,event));"></td>
                                    </tr>
                                    <tr>
                                        <td><input type="checkbox" name="IS_MANAGER_2" id="IS_MANAGER_2" <cfif get_survey.is_manager_2 eq 1>checked</cfif>><cf_get_lang dictionary_id='35921.İkinci Amir'></td>
                                        <td><cfinput type="text" name="manager_quiz_weight_2" id="manager_quiz_weight_2" value="#tlformat(get_survey.manager_quiz_weight_2)#" validate="float" style="width:30px" range="0,100" onkeyup="return(FormatCurrency(this,event));"></td>
                                    </tr>
                                </table>
                            </div>
                            <div class="col col-6 col-md-12 col-xs-12">
                            	<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                        <label class="col col-12 bold"><cf_get_lang dictionary_id="42927.Form 1 Defa Doldurulabilsin"><input type="checkbox" name="is_one_result" id="is_one_result" <cfif get_survey.is_one_result eq 1> checked</cfif>></label>
                                    </div>
                                </div>
                            	<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                            <div class="input-group">
                                                <cfinput type="text" validate="#validate_style#" name="startdate" value="#dateformat(get_survey.start_date,dateformat_style)#" style="width:65px;" maxlength="10">
                                                <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="startdate"></span>
                                            </div>
                                        </div>
                                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                            <div class="input-group">
                                                <cfinput type="text" validate="#validate_style#" name="finishdate" value="#dateformat(get_survey.finish_date,dateformat_style)#" style="width:65px;" maxlength="10">
                                                <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finishdate"></span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                        <label class="col col-12 bold"><cf_get_lang dictionary_id='33154.Tekrar'></label>
                                    </div>
                                </div>
								<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                                    <div class="col col-8 col-md-12 col-xs-12">
                                        <div class="input-group">
											<select name="survey_period" id="survey_period">
											<option value="0"><cf_get_lang dictionary_id='37301.Dönemsel'></option>
                                            <option value="1" <cfif get_survey.survey_period eq 1>selected</cfif>><cf_get_lang dictionary_id='58457.Günlük'></option>
                                            <option value="7" <cfif get_survey.survey_period eq 7>selected</cfif>><cf_get_lang dictionary_id='58458.Haftalık'></option>
                                            <option value="15" <cfif get_survey.survey_period eq 15>selected</cfif>>15 <cf_get_lang dictionary_id='58457.Günlük'></option>
											<option value="30" <cfif get_survey.survey_period eq 30>selected</cfif>><cf_get_lang dictionary_id='58932.Aylık'></option>
											<option value="365" <cfif get_survey.survey_period eq 365>selected</cfif>><cf_get_lang dictionary_id='29400.Yıllık'></option>
										</select>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                        <label class="col col-12 bold"><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></label>
                                    </div>
                                </div>
                                <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                                    <div class="col col-6 col-md-12 col-xs-12">
                                        <cfset get_position_cat=cfc.GetPositionCat()>
                                        <cfset get_position_cats=cfc.GetPositionCats(survey_id:attributes.survey_id)>
                                        <cf_multiselect_check
                                            name="position_cats"
                                            query_name="get_position_cat"
                                            option_name="POSITION_CAT"
                                            option_value="POSITION_CAT_ID"
                                            value="#valuelist(get_position_cats.position_cat_id)#"
                                            >
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="project_detail" <cfif get_survey.type eq 5> class="col col-12 col-xs-12" type="column" sort="true" index="<cfoutput>#i#</cfoutput>"<cfset i = i+1> <cfelse> style='display:none'</cfif>>
                        <div class="form-group" id="item-project_detail">
                            <label class="col col-1 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori '></label>
                            <div class="col col-2 col-xs-12">
                                <cfset get_project_cat=cfc.GetProjectCat()>
                                <cfset get_project_cats=cfc.GetProjectCats(survey_id:attributes.survey_id)>
                                <cf_multiselect_check
                                    name="project_cats"
                                    query_name="get_project_cat"
                                    option_name="MAIN_PROCESS_CAT"
                                    option_value="MAIN_PROCESS_CAT_ID"
                                    value="#valuelist(get_project_cats.project_cat_id)#"
                                    >
                            </div>
                        </div>
                    </div>
                    <div id="trial_detail" <cfif listfind('6,10',get_survey.type)> class="col col-12 col-xs-12" type="column" sort="true" index="<cfoutput>#i#</cfoutput>"<cfset i = i+1><cfelse> style='display:none' </cfif>>
                    <cf_seperator id="trial_detail1" style="display:none;" title="#getLang('','Veri Kaynağı',63070)#" is_closed="1">
                    <div id="trial_detail1">
                        <div class="form-group" id="item-trial_detail1">
                            <div class="col col-6 col-xs-12">
                                <div class="col col-12 col-xs-12">
                                    <div class="form-group" id="item-trial_detail1">
                                        <label class="col col-6"><input type="checkbox" name="is_position_competence_measured" id="is_position_competence_measured" value="1" <cfif get_survey.recordcount and get_survey.is_position_competence_measured eq 1>checked</cfif>><cfoutput><cf_get_lang dictionary_id='63071.Pozisyon Yetkinliği Ölçülsün'></cfoutput></label>
                                        <label class="col col-6"><cfoutput><cf_get_lang dictionary_id='63072.Pozisyonun Hedefleri Ölçülsün'></cfoutput><input type="checkbox" name="is_position_targets_measured" id="is_position_targets_measured" value="1" <cfif get_survey.recordcount and get_survey.is_position_targets_measured eq 1>checked</cfif>></label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                    <div id="work_detail" <cfif get_survey.type eq 11> class="col col-12 col-xs-12" type="column" sort="true" index="<cfoutput>#i#</cfoutput>" <cfset i = i+1> <cfelse>style='display:none'</cfif>>
                        <div class="form-group" id="item-work_detail">
                            <label class="col col-1 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori '></label>
                            <div class="col col-2 col-xs-12">
                                <cfset get_work_cat=cfc.GetWorkCat()>
                                <cfset get_work_cats=cfc.GetWorkCats(survey_id:attributes.survey_id)>
                                <cf_multiselect_check
                                    name="work_cats"
                                    query_name="get_work_cat"
                                    option_name="WORK_CAT"
                                    option_value="WORK_CAT_ID"
                                    value="#valuelist(get_work_cats.work_cat_id)#"
                                    > 
                            </div>
                        </div>
                    </div>
                    <div id="anket_detail" <cfif get_survey.type eq 14> class="col col-4 col-xs-12" type="column" sort="true" index="<cfoutput>#i#</cfoutput>" <cfset i = i+1> <cfelse>style="display:none" </cfif>>
                        <div class="form-group" id="item-anket_detail">
                            <label class="col col-12"><input type="checkbox" name="is_not_show_saved" id="is_not_show_saved" value="1" <cfif get_survey.is_not_show_saved eq 1>checked</cfif>><cf_get_lang dictionary_id='55991.Kaydeden bilgileri gizlensin'></label>
                            <label class="col col-12"><input type="checkbox" name="is_show_myhome" id="is_show_myhome" value="1" <cfif get_survey.is_show_myhome eq 1>checked</cfif>><cf_get_lang dictionary_id='55996.Self-Servis İşlemlerinde gösterilsin'></label>
                        </div>
                    </div>
                    <div id="training_detail" <cfif get_survey.type eq 9> class="col col-4 col-xs-12" type="column" sort="true" index="<cfoutput>#i#</cfoutput>" <cfset i = i+1> <cfelse> style='display:none'</cfif>>
                        <div class="form-group" id="item-training_detail">
                            <label class="col col-12"><input type="checkbox" name="is_selected_attender" id="is_selected_attender" value="1" <cfif get_survey.is_selected_attender eq 1>checked</cfif>><cf_get_lang dictionary_id='55994.Katılımcı Seçimi Zorunlu'></label>
                        </div>
                    </div>
                </div>
                <div class="row formContentFooter">
                    <div class="col col-6 col-xs-12">
						<cf_record_info query_name="get_survey">
                    </div>
                    <div class="col col-6 col-xs-12">
                    <cfif not get_survey_result.recordcount>
						<cfset xfa.del = "#listgetat(attributes.fuseaction,1,'.')#.emptypopup_del_detail_survey">
                        <cf_workcube_buttons is_upd='1' add_function='kontrol()' is_cancel='1' type_format='1' delete_page_url='#request.self#?fuseaction=objects.emptypopup_del_detail_survey&survey_main_id=#attributes.survey_id#&action_type=#get_survey.type#'>
                    <cfelse>
                        <cf_workcube_buttons is_upd='1' add_function='kontrol()' is_cancel='1' type_format='1' is_delete="0">
                    </cfif>
                    </div>
                </div>
            </cfform>
            </div>
        </div>
    </cf_box_elements>
    </cf_box>
        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58139.Bölümler'> - <cf_get_lang dictionary_id='58087.Sorular'></cfsavecontent>
        <cf_box
            copllapsable="0"
            id="div_related_chapter"
            unload_body="0"
            closable="0"
            title="#message#"
        box_page="#request.self#?fuseaction=objects.emptypopupajax_form_upd_detail_survey_chapter&survey_id=#attributes.survey_id#">
        </cf_box>
        <cfif not (isdefined("session.pp") or isdefined("session.ww"))>
			<cfif get_survey.type neq 14>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='29777.İlişkili Alanlar'></cfsavecontent>
                <cf_box
                    id="div_related_parts"
                    unload_body="1"
                    closable="0"
                    title="#message#"
                    box_page="#request.self#?fuseaction=objects.emptypopupajax_form_related_parts&survey_id=#attributes.survey_id#&type=#get_survey.type#">
                </cf_box>
            </cfif>
           <!--- <cfif not workcube_mode>
                <cfsavecontent variable="message"><cf_get_lang_main no='1682.Yayın'></cfsavecontent>
                <cf_box
                    id="div_related_public"
                    unload_body="1"
                    closable="0"
                    title="#message#"
                    box_page="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopupajax_form_publication&survey_id=#attributes.survey_id#">
                </cf_box>
                <cfsavecontent variable="message"><cf_get_lang_main no='178.Katılımcılar'></cfsavecontent>
                <cf_box
                    id="div_related_participants"
                    unload_body="1"
                    closable="0"
                    title="#message#"
                    box_page="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopupajax_form_participants&survey_id=#attributes.survey_id#">
                </cf_box>
                <cfsavecontent variable="message"><cf_get_lang_main no='1981.Form Raporu'></cfsavecontent>
                <cf_box
                    id="div_related_report"
                    unload_body="1"
                    closable="0"
                    title="#message#"
                    box_page="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopupajax_form_survey_report&survey_id=#attributes.survey_id#">
                </cf_box> 
            </cfif>--->
    	</cfif>
    </div>
</div>
<script type="text/javascript">
function tumunu_iliskilendir(){
		if(confirm('<cf_get_lang dictionary_id="60901.Seçilmiş olan tipteki tüm kayıtlara eklenecektir.Devam etmek istiyor musunuz?">')) 
			windowopen('<cfoutput>#request.self#?fuseaction=objects.emptypopup_add_all_relation_content&action_type=#get_survey.type#&survey_main_id=#attributes.survey_id#</cfoutput>');
		
		return false;
	}
function kontrol()
{
	if(document.getElementById("head").value == '')
	{
		alertObject({message: "<cf_get_lang dictionary_id='58059.Başlık Girmelisiniz'> !" })
		return false;
	}
	if(document.getElementById("type").value == '')
	{
		alertObject({message: "<cf_get_lang dictionary_id='43738.Tip Seçmelisiniz'> !" })
		return false;
	}
	if(document.getElementById('type').value == 8 & (document.getElementById('startdate').value == '' || document.getElementById('finishdate').value == ''))
	{
		alertObject({message: "<cf_get_lang dictionary_id='49186.Dönem Girmelisiniz'>" })
		return false;
	}
	for (var counter=1; counter<= 5; counter++)
	{
		if(eval("document.upd_survey.score"+counter).value != '')
		{
			for (var counter_= counter+1; counter_ <= 5; counter_++)
			{	
				if(eval("document.upd_survey.score"+counter_).value == eval("document.upd_survey.score"+counter).value)
				{
					alertObject({message: "<cf_get_lang dictionary_id='29771.Lütfen Uygun Skor Değerleri Giriniz'> !" })
					return false;
				}
			}
		}
	}
	fld = document.getElementById("emp_quiz_weight");
	fld.value=filterNum(fld.value);
	fld1 = document.getElementById("manager_quiz_weight_1");
	fld1.value=filterNum(fld1.value);
	fld2 = document.getElementById("manager_quiz_weight_2");
	fld2.value=filterNum(fld2.value);
	fld3 = document.getElementById("manager_quiz_weight_3");
	fld3.value=filterNum(fld3.value);
	fld4 = document.getElementById("manager_quiz_weight_4");
	fld4.value=filterNum(fld4.value);
	return process_cat_control();
}
function is_perf(deger)
{
	if(deger == 8)
	{
		if($('#performance_detail'))performance_detail.style.display='';
		if($('#project_detail'))project_detail.style.display='none';
		if($('#work_detail'))work_detail.style.display='none';
		if($('#training_detail'))training_detail.style.display='none';
		if($('#anket_detail'))anket_detail.style.display='none';
        if($('#trial_detail'))trial_detail.style.display='none';
	}
	else if(deger == 5)
	{
		if($('#performance_detail'))performance_detail.style.display='none';
		if($('#project_detail'))project_detail.style.display='';
		if($('#work_detail'))work_detail.style.display='none';
		if($('#training_detail'))training_detail.style.display='none';
		if($('#anket_detail'))anket_detail.style.display='none';
        if($('#trial_detail'))trial_detail.style.display='none';
	}
	else if(deger == 6)
	{
		if($('#performance_detail'))performance_detail.style.display='none';
		if($('#project_detail'))project_detail.style.display='none';
		if($('#work_detail'))work_detail.style.display='none';
		if($('#training_detail'))training_detail.style.display='none';
		if($('#anket_detail'))anket_detail.style.display='none';
		if($('#trial_detail'))trial_detail.style.display='';
	}
	else if(deger == 10)
	{
		if($('#performance_detail'))performance_detail.style.display='none';
		if($('#project_detail'))project_detail.style.display='none';
		if($('#work_detail'))work_detail.style.display='none';
		if($('#training_detail'))training_detail.style.display='none';
		if($('#anket_detail'))anket_detail.style.display='none';
		if($('#trial_detail'))trial_detail.style.display='';
	}
	else if(deger == 11)
	{
		if($('#performance_detail'))performance_detail.style.display='none';
		if($('#project_detail'))project_detail.style.display='none';
		if($('#work_detail'))work_detail.style.display='';
		if($('#training_detail'))training_detail.style.display='none';
		if($('#anket_detail'))anket_detail.style.display='none';
        if($('#trial_detail'))trial_detail.style.display='none';	
	}
	else if(deger == 9)
	{
		if($('#performance_detail'))performance_detail.style.display='none';
		if($('#project_detail'))project_detail.style.display='none';
		if($('#work_detail'))work_detail.style.display='none';
		if($('#training_detail'))training_detail.style.display='';
		if($('#anket_detail'))anket_detail.style.display='none';	
        if($('#trial_detail'))trial_detail.style.display='none';
	}
	else if(deger == 14)
	{
		if($('#performance_detail'))performance_detail.style.display='none';
		if($('#project_detail'))project_detail.style.display='none';
		if($('#work_detail'))work_detail.style.display='none';
		if($('#training_detail'))training_detail.style.display='none';
		if($('#anket_detail'))anket_detail.style.display='';
        if($('#trial_detail'))trial_detail.style.display='none';	
	}
	else
	{
		if($('#performance_detail'))performance_detail.style.display='none';
		if($('#project_detail'))project_detail.style.display='none';
		if($('#work_detail'))work_detail.style.display='none';
		if($('#training_detail'))training_detail.style.display='none';
		if($('#anket_detail'))anket_detail.style.display='none';
        if($('#trial_detail'))trial_detail.style.display='none';
	}
}
</script>
<cf_get_lang_set module_name="#fusebox.circuit#">