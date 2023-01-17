<cfset cfc=createObject("component","V16.training_management.cfc.training_survey")> 
<cf_get_lang_set module_name="settings">
<cfsetting showdebugoutput="no">
<cfset GET_PROCESS=cfc.GetProcess()> 
<cfset GET_LANGUAGE=cfc.GetLanguage()> 
<cfif isDefined('attributes.survey_id') and len(attributes.survey_id)>
    <cfset get_survey = cfc.GetSurvey(survey_id:attributes.survey_id)>
<cfelse>
    <cfset get_survey.recordcount = 0>
</cfif>
<cfif isdefined("attributes.action_type") and attributes.action_type eq 9 and isdefined("attributes.action_type_id") and len(attributes.action_type_id)><!--- eğitimden geliyorsa bu kontrole girsin SG20120718---->
    <cfset get_control=cfc.GetControl(action_type_id:attributes.action_type_id)>  
<cfif isdefined("attributes.xml_is_survey_add") and attributes.xml_is_survey_add eq 1 and get_control.recordcount><!--- eğitimden geliyorsa ve eğitim detayındaki xml de sadece 1 adet eklenebilsin seçili ise bu kontrole girer SG20120717--->
	<script type="text/javascript">
		{
			alert("<cf_get_lang dictionary_id='29769.Eğitime bağlı 1 tane değerlendirme formu ekleyebilirsiniz.'>");
			window.close();
		}
	</script>	
</cfif>
</cfif>
<cf_catalystHeader>
 <cfform name="add_survey" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_detail_survey">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <div class="row">
        <cf_box_elements>
            <!---action_type_id:ilişkili alan id si gonderiliyor customtag den eklemeye tıklanıldıysa bu alan dolu gelir 
            relation_type:ilişkili alan tipi
            SG 20120704--->
            <cfif isdefined("attributes.action_type") and len(attributes.action_type)>
                <cfset attributes.action_type = attributes.action_type>
            <cfelse>
                <cfset attributes.action_type = "">
            </cfif>
            <input type="hidden" name="action_type_id" id="action_type_id" value="<cfif isdefined("attributes.action_type_id") and len(attributes.action_type_id)><cfoutput>#attributes.action_type_id#</cfoutput></cfif>">
            <input type="hidden" name="relation_type" id="relation_type" value="<cfif isdefined("attributes.relation_type") and len(attributes.relation_type)><cfoutput>#attributes.relation_type#</cfoutput></cfif>">
            <cfif fuseaction contains 'popup'>
                <input type="hidden" name="is_popup" id="is_popup" value="1">
            </cfif>
            <div class="row" type="row">
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
                    <div class="form-group" id="item-active">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
                        <!--- <label class="col col-3 col-xs-12">&nbsp;</label> --->
                        <label class="col col-2 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'><input type="checkbox" name="is_active" id="is_active" value="0" <cfif get_survey.recordcount and get_survey.is_active eq 1> checked</cfif>></label>
                    </div>
                    <div class="form-group" id="item-head">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58820.Başlık'> *</label>
                        <div class="col col-9 col-xs-12">
                            <input type="text" name="head" id="head" value="<cfif get_survey.recordcount><cfoutput>#get_survey.survey_main_head#</cfoutput></cfif>" style="width:200px;" maxlength="50">
                        </div>
                    </div>
                    <div class="form-group" id="item-detail">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57771.Detay'></label>
                        <div class="col col-9 col-xs-12">
                            <textarea name="detail" id="detail" style="width:200px;height:80px;" maxlength="4000" onkeyup="return ismaxlength(this);" onblur="return ismaxlength(this);"><cfif get_survey.recordcount and len(get_survey.survey_main_details)><cfoutput>#URLDecode(get_survey.survey_main_details)#</cfoutput></cfif></textarea>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="2">
                    <div class="form-group" id="item-type">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57630.Tip'> *</label>
                        <div class="col col-9 col-xs-12">
                            <select name="type" id="type" style="width:180px;" onchange="is_perf(this.value);">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfif listfind(attributes.action_type,14,',') or not len(attributes.action_type)>
                                    <option value="14" <cfif (isdefined("attributes.action_type") and attributes.action_type eq 14) or (get_survey.recordcount and get_survey.type eq 14)>selected</cfif>><cf_get_lang dictionary_id='58662.Anket'></option>
                                </cfif>
                                <cfif listfind(attributes.action_type,6,',') or not len(attributes.action_type)>
                                    <option value="6" <cfif (isdefined("attributes.action_type") and attributes.action_type eq 6) or (get_survey.recordcount and get_survey.type eq 6)>selected</cfif>><cf_get_lang dictionary_id='29776.Deneme Süresi'></option>
                                </cfif>
                                <cfif listfind(attributes.action_type,9,',') or not len(attributes.action_type)>
                                    <option value="9" <cfif (isdefined("attributes.action_type") and attributes.action_type eq 9) or (get_survey.recordcount and get_survey.type eq 9)>selected</cfif>><cf_get_lang dictionary_id='57419.Eğitim'></option>
                                </cfif>
                                <cfif listfind(attributes.action_type,16,',') or not len(attributes.action_type)>
                                    <option value="16" <cfif (isdefined("attributes.action_type") and attributes.action_type eq 16) or (get_survey.recordcount and get_survey.type eq 16)>selected</cfif>><cf_get_lang dictionary_id='29465.Etkinlik'></option>
                                </cfif>
                                <cfif listfind(attributes.action_type,1,',') or not len(attributes.action_type)>
                                    <option value="1" <cfif (isdefined("attributes.action_type") and attributes.action_type eq 1) or (get_survey.recordcount and get_survey.type eq 1)>selected</cfif>><cf_get_lang dictionary_id='57612.Fırsat'></option>
                                </cfif>
                                <cfif listfind(attributes.action_type,2,',') or not len(attributes.action_type)>
                                    <option value="2" <cfif (isdefined("attributes.action_type") and attributes.action_type eq 2) or (get_survey.recordcount and get_survey.type eq 2)>selected</cfif>><cf_get_lang dictionary_id='57653.İçerik'></option>
                                </cfif>
                                <cfif listfind(attributes.action_type,11,',') or not len(attributes.action_type)>
                                    <option value="11" <cfif (isdefined("attributes.action_type") and attributes.action_type eq 11) or (get_survey.recordcount and get_survey.type eq 11)>selected</cfif>><cf_get_lang dictionary_id='58445.İş'></option>
                                </cfif>
                                <cfif listfind(attributes.action_type,7,',') or not len(attributes.action_type)>
                                    <option value="7" <cfif (isdefined("attributes.action_type") and attributes.action_type eq 7) or (get_survey.recordcount and get_survey.type eq 7)>selected</cfif>><cf_get_lang dictionary_id='57996.İşe Alım'></option>
                                </cfif>
                                <cfif listfind(attributes.action_type,10,',') or not len(attributes.action_type)>
                                    <option value="10" <cfif (isdefined("attributes.action_type") and attributes.action_type eq 10) or (get_survey.recordcount and get_survey.type eq 10)>selected</cfif>><cf_get_lang dictionary_id='29832.İşten Çıkış'></option>
                                </cfif>
                                <cfif listfind(attributes.action_type,3,',') or not len(attributes.action_type)>
                                    <option value="3" <cfif (isdefined("attributes.action_type") and attributes.action_type eq 3) or (get_survey.recordcount and get_survey.type eq 3)>selected</cfif>><cf_get_lang dictionary_id='57446.Kampanya'></option>
                                </cfif>
                                <cfif listfind(attributes.action_type,8,',') or not len(attributes.action_type)>
                                    <option value="8" <cfif (isdefined("attributes.action_type") and attributes.action_type eq 8) or (get_survey.recordcount and get_survey.type eq 8)>selected</cfif>><cf_get_lang dictionary_id='58003.Performans'></option>
                                </cfif>
                                <cfif listfind(attributes.action_type,5,',') or not len(attributes.action_type)>
                                    <option value="5" <cfif (isdefined("attributes.action_type") and attributes.action_type eq 5) or (get_survey.recordcount and get_survey.type eq 5)>selected</cfif>><cf_get_lang dictionary_id='57416.Proje'></option>
                                </cfif>
                                <cfif listfind(attributes.action_type,15,',') or not len(attributes.action_type)>
                                    <option value="15" <cfif (isdefined("attributes.action_type") and attributes.action_type eq 15) or (get_survey.recordcount and get_survey.type eq 15)>selected</cfif>><cf_get_lang dictionary_id='30048.Satınalma Teklifleri'></option>
                                </cfif>
                                <cfif listfind(attributes.action_type,12,',') or not len(attributes.action_type)>
                                    <option value="12" <cfif (isdefined("attributes.action_type") and attributes.action_type eq 12) or (get_survey.recordcount and get_survey.type eq 12)>selected</cfif>><cf_get_lang dictionary_id='30007.Satış Teklifleri'></option>
                                </cfif>
                                <cfif listfind(attributes.action_type,13,',') or not len(attributes.action_type)>
                                    <option value="13" <cfif (isdefined("attributes.action_type") and attributes.action_type eq 13) or (get_survey.recordcount and get_survey.type eq 13)>selected</cfif>><cf_get_lang dictionary_id='57611.Sipariş'></option>
                                </cfif>
                                <cfif listfind(attributes.action_type,4,',') or not len(attributes.action_type)>
                                    <option value="4" <cfif (isdefined("attributes.action_type") and attributes.action_type eq 4) or (get_survey.recordcount and get_survey.type eq 4)>selected</cfif>><cf_get_lang dictionary_id='57657.Ürün'></option>
                                </cfif>
                                <cfif listfind(attributes.action_type,17,',') or not len(attributes.action_type)>
                                    <option value="17" <cfif (isdefined("attributes.action_type") and attributes.action_type eq 17) or (get_survey.recordcount and get_survey.type eq 17)>selected</cfif>><cf_get_lang dictionary_id='60095.Mal Kabül'></option>
                                </cfif>
                                <cfif listfind(attributes.action_type,18,',') or not len(attributes.action_type)>
                                    <option value="18" <cfif (isdefined("attributes.action_type") and attributes.action_type eq 18) or (get_survey.recordcount and get_survey.type eq 18)>selected</cfif>><cf_get_lang dictionary_id='45452.Sevkiyat'></option>
                                </cfif>
                                <cfif listfind(attributes.action_type,19,',') or not len(attributes.action_type)>
                                    <option value="19" <cfif (isdefined("attributes.action_type") and attributes.action_type eq 19) or (get_survey.recordcount and get_survey.type eq 19)>selected</cfif>><cf_get_lang dictionary_id='57438.Call Center'></option>
                                </cfif>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-process">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                        <div class="col col-9 col-xs-12">
                            <cf_workcube_process is_upd='0' process_cat_width='180' is_detail='0'>
                        </div>
                    </div>
                    <div class="form-group" id="item-process_id">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='62553.Form Akışı'></label>
                        <div class="col col-9 col-xs-12">
                            <select name="process_id" id="process_id" style="width:180px;">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_process">
                                    <option value="#process_id#" <cfif get_survey.recordcount and process_id eq get_survey.process_id>selected</cfif>>#process_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-employee">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='29775.Hazırlayan'></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="employee_id" id="employee_id" value="<cfif get_survey.recordcount and len(get_survey.emp_id)><cfoutput>#get_survey.emp_id#</cfoutput><cfelse><cfoutput>#session.ep.userid#</cfoutput></cfif>">
                                <input type="text" name="employee" id="employee" value="<cfif get_survey.recordcount and len(get_survey.emp_id)><cfoutput>#get_emp_info(get_survey.emp_id,0,0)#</cfoutput><cfelse><cfoutput>#get_emp_info(session.ep.userid,0,0)#</cfoutput></cfif>" style="width:180px;" readonly><!--- onFocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','135');" --->
                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_survey.employee_id&field_name=add_survey.employee&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.add_survey.employee.value),'list');"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="3">
                    <div class="form-group" id="analysis_average">
                        <div class="col col-2 col-xs-12">
                            <label><cf_get_lang dictionary_id='29774.Uygunluk Sınırı'></label>
                        </div>
                        <div class="col col-10 col-xs-12">
                            <div class="form-group">
                                <div class="col col-4 col-md-4 col-sm-4 col-xs-12 bold">
                                    <input type="text" name="analysis_average" id="analysis_average" value="<cfif get_survey.recordcount><cfoutput>#get_survey.average_score#</cfoutput></cfif>" maxlength="3" onkeyup="isNumber(this);" class="moneybox" style="width:50px;">
                                </div>
                                <div class="col col-2 col-md-2 col-sm-2 col-xs-2"><label class="input-group-addon no-bg"><cf_get_lang dictionary_id='58909.Max'><br><cf_get_lang dictionary_id='58984.Puan'></label></div>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12 bold">
                                    <input type="text" name="total_score" id="total_score" value="<cfif get_survey.recordcount><cfoutput>#get_survey.total_score#</cfoutput></cfif>" maxlength="3" onkeyup="isNumber(this);" class="moneybox" style="width:50px;">
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--- <div class="form-group" id="item-comments">
                        <div class="col col-2"></div>
                        <div class="col col-10">
                            <label class="bold"><cf_get_lang dictionary_id='29772.Skor'><cf_get_lang dictionary_id='57989.ve'><cf_get_lang dictionary_id='58185.Yorumlar'></label>
                        </div>
                    </div> --->
                    <div class="form-group" id="item-score1">
                        <div class="col col-2">
                            <label class="hide"><cf_get_lang dictionary_id='58135.Sonuçlar'></label>
                        </div>
                        <div class="col col-10">
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
                                    <div class="input-group">
                                        <input class="moneybox" type="text" name="score1" id="score1" value="<cfif get_survey.recordcount><cfoutput>#get_survey.score1#</cfoutput></cfif>" validate="integer" maxlength="3" class="moneybox" onKeyUp="isNumber(this);"> 
                                    </div>
                                </div>
                                    <div class="col col-2 col-md-2 col-sm-2 col-xs-2"><span class="input-group-addon no-bg"><cf_get_lang dictionary_id='29773.üstü'></span></div>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <input type="text" name="comment1" id="comment1" value="<cfif get_survey.recordcount><cfoutput>#get_survey.comment1#</cfoutput></cfif>" style="width:200px;">
                                </div>
                            </div>
                            <div class="form-group mb-0">
                                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                    <div class="input-group">
                                        <input class="moneybox" type="text" name="score2" id="score2" value="<cfif get_survey.recordcount><cfoutput>#get_survey.score2#</cfoutput></cfif>" validate="integer" style="width:30px;" maxlength="3" class="moneybox" onKeyUp="isNumber(this);">
                                    </div>
                                </div>
                                    <div class="col col-2 col-md-2 col-sm-2 col-xs-2"><span class="input-group-addon no-bg"><cf_get_lang dictionary_id='29773.üstü'></span></div>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <input type="text" name="comment2" id="comment2" value="<cfif get_survey.recordcount><cfoutput>#get_survey.comment2#</cfoutput></cfif>" style="width:200px;">
                                </div>
                            </div>
                            <div class="form-group mb-0">
                                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                    <div class="input-group">
                                        <input class="moneybox" type="text" name="score3" id="score3" value="<cfif get_survey.recordcount><cfoutput>#get_survey.score3#</cfoutput></cfif>" validate="integer" style="width:30px;" maxlength="3" class="moneybox" onKeyUp="isNumber(this);"> 
                                    </div>
                                </div>
                                    <div class="col col-2 col-md-2 col-sm-2 col-xs-2"><span class="input-group-addon no-bg"><cf_get_lang dictionary_id='29773.üstü'></span></div>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <input type="text" name="comment3" id="comment3" value="<cfif get_survey.recordcount><cfoutput>#get_survey.comment3#</cfoutput></cfif>" style="width:200px;">
                                </div>
                            </div>
                            <div class="form-group mb-0">
                                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                    <div class="input-group">
                                        <input class="moneybox" type="text" name="score4" id="score4" value="<cfif get_survey.recordcount><cfoutput>#get_survey.score4#</cfoutput></cfif>" validate="integer" style="width:30px;" maxlength="3" class="moneybox" onKeyUp="isNumber(this);">
                                    </div>
                                </div>
                                    <div class="col col-2 col-md-2 col-sm-2 col-xs-2"><span class="input-group-addon no-bg"><cf_get_lang dictionary_id='29773.üstü'></span></div>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <input type="text" name="comment4" id="comment4" value="<cfif get_survey.recordcount><cfoutput>#get_survey.comment4#</cfoutput></cfif>" style="width:200px;">
                                </div>
                            </div>
                            <div class="form-group mb-0">
                                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                    <div class="input-group">
                                        <input class="moneybox" type="text" name="score5" id="score5" value="<cfif get_survey.recordcount><cfoutput>#get_survey.score5#</cfoutput></cfif>" validate="integer" style="width:30px;" maxlength="3" class="moneybox" onKeyUp="isNumber(this);">
                                    </div>
                                </div>
                                    <div class="col col-2 col-md-2 col-sm-2 col-xs-2"><span class="input-group-addon no-bg"><cf_get_lang dictionary_id='29773.üstü'></span></div>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <input type="text" name="comment5" id="comment5" value="<cfif get_survey.recordcount><cfoutput>#get_survey.comment5#</cfoutput></cfif>" style="width:200px;">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div <cfif isdefined('attributes.action_type') and (listfind(attributes.action_type,8,',') or listfind(attributes.action_type,5,',') or listfind(attributes.action_type,1,',') or listfind(attributes.action_type,1,',') or listfind(attributes.action_type,9,','))> class="row" type="row"<cfelse>display:none; class="col col-12"</cfif>>
                <cfset i = 4>
                <div id="performance_detail" <cfif isdefined('attributes.action_type') and listfind(attributes.action_type,8,',')><cfif listLen(attributes.action_type,',') gt 6> class="col col-4 col-md-4 col-sm-6 col-xs-12" <cfelse> class="col col-6 col-xs-12" </cfif>type="column" sort="true" index="<cfoutput>#i#</cfoutput>" <cfset i = i + 1><cfelse> style='display:none' class="col col-12"</cfif>>
                    
                    <div class="form-group" id="item-degerlendiriciler">
                        <label class="hide col col-2"><cf_get_lang dictionary_id='29907.Değerlendiriciler'></label>
                        <div class="col col-6 col-md-6 col-xs-12">
                            <table border="0" class="col col-12">
                                <tr>
                                    <td><b><cf_get_lang dictionary_id='29907.Değerlendiriciler'></b></td>
                                    <td><b><cf_get_lang dictionary_id='29784.Ağırlık'></b></td>
                                    
                                </tr>
                                <tr>
                                    <td><label><input type="checkbox" name="IS_MANAGER_0" id="IS_MANAGER_0" <cfif get_survey.recordcount and get_survey.is_manager_0 eq 1>checked</cfif>><cf_get_lang dictionary_id="57576.Çalışan"></label></td>
                                    <td><input type="text" name="emp_quiz_weight" id="emp_quiz_weight" value="<cfif get_survey.recordcount and len(get_survey.emp_quiz_weight)><cfoutput>#tlformat(get_survey.emp_quiz_weight)#</cfoutput></cfif>" validate="float" style="width:30px" range="0,100"></td>
                                    
                                </tr>
                                <tr>
                                    <td><label><input type="checkbox" name="IS_MANAGER_3" id="IS_MANAGER_3" <cfif get_survey.recordcount and get_survey.is_manager_3 eq 1>checked</cfif>><cf_get_lang dictionary_id="29908.Görüş Bildiren"></label></td>
                                    <td><input type="text" name="manager_quiz_weight_3" id="manager_quiz_weight_3" value="<cfif get_survey.recordcount and len(get_survey.manager_quiz_weight_3)><cfoutput>#tlformat(get_survey.manager_quiz_weight_3)#</cfoutput></cfif>" validate="float" style="width:30px" range="0,100" onkeyup="return(FormatCurrency(this,event));"></td>
                                    
                                </tr>
                                <tr>
                                    <td><label><input type="checkbox" name="IS_MANAGER_1" id="IS_MANAGER_1" <cfif get_survey.recordcount and get_survey.is_manager_1 eq 1>checked</cfif>><cf_get_lang dictionary_id='35927.Birinci Amir'></label></td>
                                    <td><input type="text" name="manager_quiz_weight_1" id="manager_quiz_weight_1" value="<cfif get_survey.recordcount and len(get_survey.manager_quiz_weight_1)><cfoutput>#tlformat(get_survey.manager_quiz_weight_1)#</cfoutput></cfif>" validate="float" style="width:30px" range="0,100" onkeyup="return(FormatCurrency(this,event));"></td>
                                
                                </tr>
                                <tr>
                                    <td><label><input type="checkbox" name="IS_MANAGER_4" id="IS_MANAGER_4" <cfif get_survey.recordcount and get_survey.is_manager_4 eq 1>checked</cfif>><cf_get_lang dictionary_id="29909.Ortak Değerlendirme"></label></td>
                                    <td><input type="text" name="manager_quiz_weight_4" id="manager_quiz_weight_4" value="<cfif get_survey.recordcount and len(get_survey.manager_quiz_weight_4)><cfoutput>#tlformat(get_survey.manager_quiz_weight_4)#</cfoutput></cfif>" validate="float" style="width:30px" range="0,100" onkeyup="return(FormatCurrency(this,event));"></td>
                                </tr>
                                <tr>
                                    <td><label><input type="checkbox" name="IS_MANAGER_2" id="IS_MANAGER_2" <cfif get_survey.recordcount and get_survey.is_manager_2 eq 1>checked</cfif>><cf_get_lang dictionary_id='35921.İkinci Amir'></label></td>
                                    <td><input type="text" name="manager_quiz_weight_2" id="manager_quiz_weight_2" value="<cfif get_survey.recordcount and len(get_survey.manager_quiz_weight_2)><cfoutput>#tlformat(get_survey.manager_quiz_weight_2)#</cfoutput></cfif>" validate="float" style="width:30px" range="0,100" onkeyup="return(FormatCurrency(this,event));"></td>
                                </tr>
                            </table>
                        </div>
                        <div class="col col-6 col-md-6 col-xs-12">
                            <div class="row">
                                <div class="col col-12">
                                    <label class="col col-12 bold"><cf_get_lang dictionary_id='58472.Dönem'></label>
                                    <div class="col col-12">
                                        <div class="input-group x-2">
                                            <cfif get_survey.recordcount and len(get_survey.start_date)>
                                                <cfset start_date = dateformat(get_survey.start_date,dateformat_style)>
                                            <cfelse>
                                                <cfset start_date = ''>
                                            </cfif>
                                            <cfif get_survey.recordcount and len(get_survey.finish_date)>
                                                <cfset finish_date = dateformat(get_survey.finish_date,dateformat_style)>
                                            <cfelse>
                                                <cfset finish_date = ''>
                                            </cfif>
                                            <cfinput type="text" validate="#validate_style#" name="startdate" value="#start_date#" style="width:65px;"  maxlength="10">
                                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="startdate"></span>
                                            <span class="input-group-addon no-bg"></span>
                                            <cfinput type="text" validate="#validate_style#" name="finishdate" value="#finish_date#" style="width:65px;" maxlength="10">
                                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finishdate"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col col-12">
                                    <label class="col col-12 bold"><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></label>
                                    <div class="col col-12">
                                        <cfset get_position_cat=cfc.GetPositionCat()>
                                        <cfset pos_cat_list = ''>
                                        <cfif isDefined('attributes.survey_id') and len(attributes.survey_id)>
                                            <cfset get_position_cats=cfc.GetPositionCats(survey_id:attributes.survey_id)>
                                            <cfif get_position_cats.recordcount>
                                                <cfset pos_cat_list = valuelist(get_position_cats.position_cat_id)>
                                            </cfif>
                                        </cfif>
                                        <cf_multiselect_check
                                            name="position_cats"
                                            query_name="get_position_cat"
                                            option_name="POSITION_CAT"
                                            option_value="POSITION_CAT_ID"
                                            value="#pos_cat_list#">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="project_detail" <cfif isdefined('attributes.action_type') and listfind(attributes.action_type,5,',')> class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="<cfoutput>#i#</cfoutput>" <cfset i = i + 1><cfelse> style='display:none'</cfif>>
                    <div class="form-group" id="item-project_detail">
                        <div class="col col-6 col-xs-12">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori '></label>
                            <div class="col col-8 col-xs-12">
                                <cfset get_project_cat=cfc.GetProjectCat()>
                                <cfset pro_cat_list = ''>
                                <cfif isDefined('attributes.survey_id') and len(attributes.survey_id)>
                                    <cfset get_project_cats=cfc.GetProjectCats(survey_id:attributes.survey_id)>
                                    <cfif get_project_cats.recordcount>
                                        <cfset pro_cat_list = valuelist(get_project_cats.project_cat_id)>
                                    </cfif>
                                </cfif>
                                <cf_multiselect_check
                                    name="project_cats"
                                    query_name="get_project_cat"
                                    option_name="MAIN_PROCESS_CAT"
                                    option_value="MAIN_PROCESS_CAT_ID"
                                    value="#pro_cat_list#">
                            </div>
                        </div>
                    </div>
                </div>

                <div id="trial_detail" <cfif isdefined('attributes.action_type') and listfind(attributes.action_type,6,',')> class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="<cfoutput>#i#</cfoutput>" <cfset i = i + 1><cfelse> style='display:none'</cfif>>
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

                <div id="work_detail" <cfif isdefined('attributes.action_type') and listfind(attributes.action_type,11,',')> class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="<cfoutput>#i#</cfoutput>" <cfset i = i + 1><cfelse> style='display:none'</cfif>>
                    <div class="form-group" id="item-work_detail">
                        <div class="col col-6  col-xs-12">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori '></label>
                            <div class="col col-8 col-xs-12">
                                <cfset get_work_cat=cfc.GetWorkCat()>
                                <cfset work_cat_list = ''>
                                <cfif isDefined('attributes.survey_id') and len(attributes.survey_id)>
                                    <cfset get_work_cats=cfc.GetWorkCats(survey_id:attributes.survey_id)>
                                    <cfif get_work_cats.recordcount>
                                        <cfset work_cat_list = valuelist(get_work_cats.work_cat_id)>
                                    </cfif>
                                </cfif>
                                <cf_multiselect_check
                                    name="work_cats"
                                    query_name="get_work_cat"
                                    option_name="WORK_CAT"
                                    option_value="WORK_CAT_ID"
                                    value="#work_cat_list#">
                            </div>
                        </div>
                    </div>
                </div>
                <div id="anket_detail" <cfif isdefined('attributes.action_type') and listfind(attributes.action_type,14,',')> class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="<cfoutput>#i#</cfoutput>" <cfset i = i + 1><cfelse> style='display:none'</cfif>>
                    <div class="form-group" id="item-anket_detail">
                        <label class="col col-6"><input type="checkbox" name="is_not_show_saved" id="is_not_show_saved" value="1" <cfif get_survey.recordcount and get_survey.is_not_show_saved eq 1>checked</cfif>><cfoutput>#getLang('hr',906)#</cfoutput></label>
                        <label class="col col-12"><cfoutput>#getLang('','',62008)#</cfoutput><input type="checkbox" name="is_show_myhome" id="is_show_myhome" value="1" <cfif get_survey.recordcount and get_survey.is_show_myhome eq 1>checked</cfif>></label>
                    </div>
                </div>
                <div id="survey_detail" <cfif isdefined('attributes.action_type') and listfind(attributes.action_type,6,',')> class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="<cfoutput>#i#</cfoutput>" <cfset i = i + 1><cfelse> style='display:none'</cfif>>
                    <div class="form-group" id="item-survey_detail">
                        <label class="col col-12"><cfoutput>#getLang('hr',911)#</cfoutput><input type="checkbox" name="is_show_employee" id="is_show_employee" value="1"></label>
                    </div>
                </div>
                <div id="training_detail" <cfif isdefined('attributes.action_type') and listfind(attributes.action_type,9,',')> class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="<cfoutput>#i#</cfoutput>" <cfset i = i + 1><cfelse> style='display:none'</cfif>>
                    <div class="form-group" id="item-training_detail">
                        <label class="col col-6"><input type="checkbox" name="is_selected_attender" id="is_selected_attender" value="1" <cfif get_survey.recordcount and get_survey.is_selected_attender eq 1>checked</cfif>><cfoutput>#getLang('hr',909)#</cfoutput></label>
                    </div>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
        </cf_box_footer>
    </div>
    </cf_box>
</div>
</cfform>
<script type="text/javascript">
if($('#performance_detail'))performance_detail.style.display='none';
if($('#project_detail'))project_detail.style.display='none';
if($('#work_detail'))work_detail.style.display='none';
if($('#training_detail'))training_detail.style.display='none';
if($('#anket_detail'))anket_detail.style.display='none';
if($('#trial_detail'))anket_detail.style.display='none';
function kontrol()
{
	if(document.getElementById('head').value == '')
	{
		alertObject({message: "<cf_get_lang dictionary_id='58820.Başlık'> !" })
		return false;
	}
	if(document.getElementById("type").value == '')
	{
		alertObject({message: "<cf_get_lang dictionary_id='43738.Tip Seçmelisiniz'> !" })
		return false;
	}
	if(document.getElementById('type').value == 8 & (document.getElementById('startdate').value == '' || document.getElementById('finishdate').value == ''))
	{
		alertObject({message: "<cf_get_lang dictionary_id='58472.Dönem'>" })
		return false;
	}
	for(var counter=1; counter<= 5; counter++)
	{
		if(eval("document.add_survey.score"+counter).value != '')
		{
			for (var counter_= counter+1; counter_ <= 5; counter_++)
			{	
				if(eval("document.add_survey.score"+counter_).value == eval("document.add_survey.score"+counter).value)
				{
					alertObject({message: "<cf_get_lang dictionary_id='29771.Lütfen Uygun Skor Değerleri Giriniz'> !" })
					return false;
				}
			}
		}
	}
	fld = document.getElementById("emp_quiz_weight");
	fld.value=filterNum(fld.value);
	fld = document.getElementById("manager_quiz_weight_1");
	fld.value=filterNum(fld.value);
	fld = document.getElementById("manager_quiz_weight_2");
	fld.value=filterNum(fld.value);
	fld = document.getElementById("manager_quiz_weight_3");
	fld.value=filterNum(fld.value);
	fld = document.getElementById("manager_quiz_weight_4");
	fld.value=filterNum(fld.value);
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