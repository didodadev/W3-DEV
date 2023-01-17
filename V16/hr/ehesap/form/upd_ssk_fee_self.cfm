<cf_get_lang_set module_name="ehesap">
<cfquery name="get_fee" datasource="#dsn#">
	SELECT 
		ESF.*,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME 
	FROM 
		EMPLOYEES_SSK_FEE ESF,
		EMPLOYEES E 
	WHERE 
		ESF.FEE_ID = #attributes.FEE_ID# AND
		ESF.EMPLOYEE_ID = E.EMPLOYEE_ID
</cfquery>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Viziteler',30943)#: #attributes.fee_id#">
        <cfform name="ssk_fee" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_upd_ssk_fee_self">
            <cfoutput query="GET_FEE">
                <input type="hidden" name="FEE_ID" id="FEE_ID" value="#attributes.FEE_ID#">
                <cf_box_elements>
                    <div class="row" type="row">
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group" id="item-emp_name">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57576.Çalışan'>*</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="employee_id" id="employee_id" value="#employee_id#">
                                        <input type="hidden" name="in_out_id" id="in_out_id" value="<cfif len(in_out_id)>#in_out_id#</cfif>">
                                        <input type="text" name="emp_name" id="emp_name" style="width:150px;" value="#employee_name# #employee_surname#" readonly>
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_emp_in_out&field_in_out_id=ssk_fee.in_out_id&field_emp_name=ssk_fee.emp_name&field_emp_id=ssk_fee.employee_id','list');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-DATE">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='53144.Vizite Tarihi'>*</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="col col-10 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='53144.Vizite Tarihi'></cfsavecontent>
                                            <cfinput validate="#validate_style#" type="text" name="DATE" id="DATE" value="#dateformat(FEE_DATE,dateformat_style)#" style="width:70px;" required="yes" message="#message#">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="DATE"></span>
                                        </div>
                                    </div>
                                    <div class="col col-2">
                                        <cfoutput>
                                            <cf_wrkTimeFormat name="HOUR" value="#FEE_HOUR#">
                                        </cfoutput>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-DATEOUT">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='53146.Viziteye Çıkış'>*</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="col col-10 col-xs-12">
                                        <div class="input-group">
                                            <cfinput validate="#validate_style#" type="text" name="DATEOUT" id="DATEOUT" value="#dateformat(FEE_DATEOUT,dateformat_style)#" style="width:70px;" required="yes" message="Viziteye Çıkış Tarihi!">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="DATEOUT"></span>
                                        </div>
                                    </div>
                                    <div class="col col-2">
                                        <cfoutput>
                                            <cf_wrkTimeFormat name="HOUROUT" value="#FEE_HOUROUT#">
                                        </cfoutput>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-detail">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57629.Açıklama'></label>
                                <div class="col col-8 col-xs-12">
                                    <TEXTAREA name="detail" id="detail" style="width:150px;height:60px;">#detail#</TEXTAREA>
                                </div>
                            </div>
                            <cfif len(validator_pos_code_1) and not len(valid_1)>
                            <div class="form-group" id="item-pos_code">
                                <label class="col col-3 col-xs-12">1.<cf_get_lang dictionary_id ='53938.Amir Onay'></label>
                                <label class="col col-9 col-xs-12">
                                    <cfoutput>#get_emp_info(validator_pos_code_1,1,0)#</cfoutput>
                                    <cf_get_lang dictionary_id ='57615.Onay Bekliyor'>!
                                </label>
                            </div>
                            <cfelseif len(validator_pos_code_1) and len(valid_1)>
                            <div class="form-group" id="item-pos_code">
                                <label class="col col-3 col-xs-12">1.<cf_get_lang dictionary_id ='53938.Amir Onay'></label>
                                <label class="col col-9 col-xs-12">
                                    <cfoutput>#get_emp_info(validator_pos_code_1,1,0)#</cfoutput>
                                    <cf_get_lang dictionary_id='58699.Onaylandı'>.
                                </label>
                            </div>
                            </cfif>
                            <cfif len(validator_pos_code_2) and not len(valid_2)>
                            <div class="form-group" id="item-pos_code2">
                                <label class="col col-3 col-xs-12">2.<cf_get_lang dictionary_id ='53938.Amir Onay'></label>
                                <label class="col col-9 col-xs-12">
                                    <cfoutput>#get_emp_info(validator_pos_code_2,1,0)#</cfoutput>
                                    <cf_get_lang dictionary_id ='57615.Onay Bekliyor'>!
                                </label>
                            </div>
                            <cfelseif len(validator_pos_code_2) and len(valid_2)>
                            <div class="form-group" id="item-pos_code2">
                                <label class="col col-3 col-xs-12">2.<cf_get_lang dictionary_id ='53938.Amir Onay'></label>
                                <label class="col col-9 col-xs-12">
                                    <cfoutput>#get_emp_info(validator_pos_code_2,1,0)#</cfoutput>
                                    <cf_get_lang dictionary_id='58699.Onaylandı'>.
                                </label>
                            </div>
                            </cfif>
                            <div class="form-group" id="item-valid_name">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57500.Onay'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfif LEN(VALID_EMP)>
                                    <div class="input-group">
                                            #get_emp_info(VALID_EMP, 0, 0)#
                                            <cfif valid is 1>
                                                <cf_get_lang dictionary_id='58699.Onayladı'>
                                            <cfelseif valid is 0>
                                                <cf_get_lang dictionary_id='57617.Reddetti'>
                                            <cfelse>
                                                !!! <cf_get_lang dictionary_id='53523.Belirsiz'> !!!
                                            </cfif>
                                    <cfelse>
                                    <div class="input-group" style="width:25px;">
                                            <cfif session.ep.position_code eq validator_pos_code>
                                                <INPUT type="hidden" name="valid" id="valid" value="">
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id ='53999.Onaylamakta Olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir Onaylamak istediğinizden emin misiniz '></cfsavecontent>
                                                <input type="Image" src="/images/valid.gif" alt="<cf_get_lang dictionary_id ='58475.Onayla'>" onclick="if (confirm('#message#')) {ssk_fee.valid.value='1'} else {return false}" border="0">
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id ='54000.Reddetmekte  Olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir. Reddetmek istediğinizden emin misiniz'></cfsavecontent>
                                                <input type="Image" src="/images/refusal.gif" alt="<cf_get_lang dictionary_id='58461.Reddet'>" onclick="if (confirm('#message#')) {ssk_fee.valid.value='0'} else {return false}" border="0">
                                                <cfelse>
                                                <cfsavecontent variable="validator_name">#get_emp_info(validator_pos_code, 1, 0)#</cfsavecontent>								
                                                <INPUT type="hidden" name="validator_pos_code" id="validator_pos_code" value="<cfoutput>#validator_pos_code#</cfoutput>">
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='53524.onaylayacak kişi girmelisiniz'></cfsavecontent>
                                                <cfinput type="text" name="valid_name" id="valid_name" value="#validator_name#" required="yes" message="#message#" readonly="yes" style="width:150px;">
                                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('#request.self#?fuseaction=hr.popup_list_positions&field_code=ssk_fee.validator_pos_code&field_emp_name=ssk_fee.valid_name','list');return false"></span>
                                            </cfif>
                                        </cfif>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-workcheck">
                                <label><input name="workcheck" id="workcheck" type="checkbox" onClick="gizle(work);work_kaldir();" <cfif accident is 1>checked</cfif>><cf_get_lang dictionary_id ='53147.İş Kazası'></label>
                            </div>
                            <div class="form-group" id="item-illness">
                                <label><input type="checkbox" name="illness" id="illness" onclick="illness_kaldir();" <cfif ILLNESS IS 1>CHECKED</cfif>><cf_get_lang dictionary_id ='53462.Meslek Hastalığı'></label>
                            </div>
                            <div class="form-group" id="item-relativecheck">
                                <label><input name="relativecheck" id="relativecheck" type="checkbox" onclick="relative_kaldir();" <cfif RELATIVE_REPORT is 1>checked</cfif>/><cf_get_lang dictionary_id ='53920.İş Görememezlik Ödeneği'></label>
                            </div>
                            <div class="form-group" id="item-continuationcheck">
                                <label><input name="continuationcheck" id="continuationcheck" type="checkbox" onclick="continuation_kaldir();" <cfif ACCIDENT_CONTINUATION is 1>checked</cfif>/><cf_get_lang dictionary_id ='53919.İş Kazasının Devamı'></label>
                            </div>
                            <div class="form-group" id="item-detail_print">
                                <label><input type="checkbox" name="detail_print" id="detail_print" value="1" <cfif GET_FEE.detail_print eq 1>checked</cfif>><cf_get_lang dictionary_id ='53913.Detaysız Print'></label>
                            </div>
                        </div>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true" id="work" style="display:none;">
                            <div class="form-group" id="item-total_emp">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='53463.Olay Tarihi İşçi Sayısı'></label>
                                <div class="col col-9 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='53474.işçi sayısı girmelisiniz'></cfsavecontent>
                                    <cfinput type="text" name="total_emp" id="total_emp" style="width:175px;"  value="#total_emp#" message="#message#" validate="integer">
                                </div>
                            </div>
                            <div class="form-group" id="item-label2">
                                <label class="col col-12 bold"><cf_get_lang dictionary_id ='53464.Sigortalının'></label>
                            </div>
                            <div class="form-group" id="item-emp_work">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='53465.İşi ve Mahiyeti'></label>
                                <div class="col col-9 col-xs-12">
                                    <input type="text" name="emp_work" id="emp_work" style="width:175px;"  value="#emp_work#">
                                </div>
                            </div>
                            <div class="form-group" id="item-label3">
                                <label class="col col-12 bold"><cf_get_lang dictionary_id ='53466.İş Kazasının'></label>
                            </div>
                            <div class="form-group" id="item-_event_shape">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='53467.Oluş Şekli'></label>
                                <div class="col col-9 col-xs-12">
                                    <textarea name="_event_shape" id="_event_shape" style="width:175px;height:60px;">#event#</textarea>
                                </div>
                            </div>
                            <div class="form-group" id="item-accident_security_id">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='53468.Güvenlik Maddesi'></label>
                                <div class="col col-9 col-xs-12">
                                    <cfinclude template="../query/get_accident_securities.cfm">
                                    <select name="accident_security_id" id="accident_security_id" style="width:175px;">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfloop query="get_accident_securities">
                                            <option value="#accident_security_id#"<cfif GET_FEE.accident_security_id eq accident_security_id> selected</cfif>>#accident_security#</option>
                                        </cfloop>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-accident_type_id">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='53469.Kaza Çeşidi'></label>
                                <div class="col col-9 col-xs-12">
                                    <cfinclude template="../query/get_work_accident_type.cfm">
                                    <select name="accident_type_id" id="accident_type_id" style="width:175px;">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfloop query="GET_WORK_ACCIDENT_TYPE">
                                            <option value="#ACCIDENT_TYPE_ID#"<cfif GET_FEE.ACCIDENT_TYPE_ID eq ACCIDENT_TYPE_ID> selected</cfif>>#accident_type#</option>
                                        </cfloop>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-place">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='53470.Olay Yeri'></label>
                                <div class="col col-9 col-xs-12">
                                    <input type="text" name="place" id="place" style="width:175px;" value="#place#" maxlength="50">
                                </div>
                            </div>
                            <div class="form-group" id="item-DATEEVENT">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58463.Tarih ve Saat'></label>
                                <div class="col col-9 col-xs-12">
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <input validate="#validate_style#" type="text" name="DATEEVENT" id="DATEEVENT" value="#dateformat(EVENT_DATE,dateformat_style)#" style="width:70px;">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="DATEEVENT"></span>
                                        </div>
                                    </div>
                                    <div class="col col-2">
                                        <cfoutput>
                                            <cf_wrkTimeFormat name="HOUREVENT" value="#event_hour#">
                                        </cfoutput>
                                    </div>
                                    <div class="col col-2">
                                        <select name="EVENT_MIN" id="EVENT_MIN">
                                            <option value="00"<cfif event_min is '00'> selected</cfif>>00</option>
                                            <option value="05"<cfif event_min is '05'> selected</cfif>>05</option>
                                            <option value="10"<cfif event_min is '10'> selected</cfif>>10</option>
                                            <option value="15"<cfif event_min is '15'> selected</cfif>>15</option>
                                            <option value="20"<cfif event_min is '20'> selected</cfif>>20</option>
                                            <option value="25"<cfif event_min is '25'> selected</cfif>>25</option>
                                            <option value="30"<cfif event_min is '30'> selected</cfif>>30</option>
                                            <option value="35"<cfif event_min is '35'> selected</cfif>>35</option>
                                            <option value="40"<cfif event_min is '40'> selected</cfif>>40</option>
                                            <option value="45"<cfif event_min is '45'> selected</cfif>>45</option>
                                            <option value="50"<cfif event_min is '50'> selected</cfif>>50</option>
                                            <option value="55"<cfif event_min is '55'> selected</cfif>>55</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-workstart">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='53472.Olay Günündeki İşbaşı Saati'></label>
                                <div class="col col-9 col-xs-12">
                                    <input type="text" name="workstart" id="workstart" style="width:175px;"  value="#workstart#">
                                </div>
                            </div>
                            <div class="form-group" id="item-label1">
                                <label class="col col-12 bold"><cf_get_lang dictionary_id="53421.Kaza Sonucu"></label>
                            </div>
                            <div class="form-group" id="item-accident_result">
                                <div class="col col-12">
                                    <div class="input-group">
                                        <span class="input-group-addon no-bg"><cf_get_lang dictionary_id='53423.Ölü'></span><input type="text" name="accident_result_dead" onKeyUp="isNumber(this)" id="accident_result_dead" style="width:25px;" maxlength="3" value="<cfif isdefined('ACCIDENT_RESULT_DEAD')>#ACCIDENT_RESULT_DEAD#</cfif>"> 
                                        <span class="input-group-addon no-bg"><cf_get_lang dictionary_id='53424.Ağır Yaralı'></span><input type="text" name="accident_result_wounded" id="accident_result_wounded" onKeyUp="isNumber(this)" style="width:25px;" maxlength="3" value="<cfif isdefined('ACCIDENT_RESULT_DEAD_WOUNDED')>#ACCIDENT_RESULT_DEAD_WOUNDED#</cfif>"> 
                                        <span class="input-group-addon no-bg"><cf_get_lang dictionary_id='53425.Uzuv Kaybı'></span><input type="text" name="organ_to_lose" id="organ_to_lose" style="width:25px;" onKeyUp="isNumber(this)" maxlength="3" value="<cfif isdefined('ORGAN_TO_LOSE')>#ORGAN_TO_LOSE#</cfif>"> 
                                        <span class="input-group-addon no-bg"><cf_get_lang dictionary_id='53426.Hafif Yaralı'></span><input type="text" name="light_wounded" id="light_wounded" style="width:25px;" onKeyUp="isNumber(this)" maxlength="3" value="<cfif isdefined('LIGHT_WOUNDED')>#LIGHT_WOUNDED#</cfif>"> 
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-rest_day">
                                <label class="col col-12 bold"><cfoutput>#getlang('ehesap',1422)#</cfoutput></label>
                            </div>
                            <div class="form-group" id="item-accident_result">
                                <div class="col col-12">
                                    <div class="input-group">
                                        <span class="input-group-addon no-bg"><cf_get_lang dictionary_id='53427.1 Gün'></span><input type="text" name="rest_first_day" id="rest_first_day" onKeyUp="isNumber(this)" style="width:25px;" maxlength="3" value="<cfif isdefined('REST_FIRST_DAY')>#REST_FIRST_DAY#</cfif>"> 
                                        <span class="input-group-addon no-bg"><cf_get_lang dictionary_id='53428.2 Gün'></span><input type="text" name="rest_second_day" id="rest_second_day" style="width:25px;" onKeyUp="isNumber(this)" maxlength="3" value="<cfif isdefined('REST_SECOND_DAY')>#REST_SECOND_DAY#</cfif>"> 
                                        <span class="input-group-addon no-bg"><cf_get_lang dictionary_id='53429.3 Gün'></span><input type="text" name="rest_third_day" id="rest_third_day" style="width:25px;" onKeyUp="isNumber(this)" maxlength="3" value="<cfif isdefined('REST_THIRD_DAY')>#REST_THIRD_DAY#</cfif>"> 
                                        <span class="input-group-addon no-bg"><cf_get_lang dictionary_id='53430.3 Günden Fazla'></span><input type="text" name="rest_extra_day" id="rest_extra_day" style="width:25px;" onKeyUp="isNumber(this)" maxlength="3" value="<cfif isdefined('REST_EXTRA_DAY')>#REST_EXTRA_DAY#</cfif>"> 
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-rest_day">
                                <label class="col col-12 bold"><cf_get_lang dictionary_id ='53473.Tanıkların Ad ve Soyadları'></label>
                            </div>
                            <div class="form-group" id="item-witness1">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='53325.Tanık'>-1</label>
                                <div class="col col-9 col-xs-12">
                                    <div class="input-group">
                                        <input type="text" name="witness1" id="witness1" style="width:175px;" value="#witness1#">
                                        <input type="hidden" name="witness1_id" id="witness1_id" value="<cfif isdefined('witness1_id') and len(witness1_id)>#witness1_id#</cfif>">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=ssk_fee.witness1_id&field_emp_name=ssk_fee.witness1','list');return false"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-witness2">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='53325.Tanık'>-2</label>
                                <div class="col col-9 col-xs-12">
                                    <div class="input-group">
                                        <input type="text" name="witness2" id="witness2" style="width:175px;" value="#witness2#">
                                        <input type="hidden" name="witness2_id" id="witness2_id" value="<cfif isdefined('witness2_id') and len(witness2_id)>#witness2_id#</cfif>">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=ssk_fee.witness2_id&field_emp_name=ssk_fee.witness2','list');return false"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-DISMEMBERMENT">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='53912.Uzuv Kaybı Bilgisi'></label>
                                <div class="col col-9 col-xs-12">
                                    <input type="text" name="DISMEMBERMENT" id="DISMEMBERMENT" style="width:175px;" maxlength="200" value="<cfoutput>#DISMEMBERMENT#</cfoutput>">
                                </div>
                            </div>
                            <div class="form-group" id="item-WILFUL_ERROR">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='53910.Kasıtlı Eylem Bilgisi'></label>
                                <div class="col col-9 col-xs-12">
                                    <input type="text" name="WILFUL_ERROR" id="WILFUL_ERROR" style="width:175px;" maxlength="200" value="<cfoutput>#WILFUL_ERROR#</cfoutput>">
                                </div>
                            </div>
                            <div class="form-group" id="item-rest_day">
                                <label class="col col-12 bold"><cf_get_lang dictionary_id="59308.İşçinin birinci dereceden yakının"></label>
                            </div>
                            <div class="form-group" id="item-relative_name_surname">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57570.Ad Soyad'></label>
                                <div class="col col-9 col-xs-12">
                                    <input type="text" name="relative_name_surname" id="relative_name_surname" value="<cfif isdefined('RELATIVE_NAME_SURNAME')><cfoutput>#RELATIVE_NAME_SURNAME#</cfoutput></cfif>" style="width:175px;" >
                                </div>
                            </div>
                            <div class="form-group" id="item-relative_name_surname">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58723.Adres'></label>
                                <div class="col col-9 col-xs-12">
                                    <textarea name="relative_address" id="relative_address" style="width:175px;height:40px;"><cfif isdefined('RELATIVE_ADDRESS')><cfoutput>#RELATIVE_ADDRESS#</cfoutput></cfif></textarea>
                                </div>
                            </div>
                            <div class="form-group" id="item-rest_day">
                                <label class="col col-12 bold"><cf_get_lang dictionary_id="53436.Meslek Hastalığı Tanısı veya Şüphesi"></label>
                            </div>
                            <div class="form-group" id="item-profession_ill_diagnosis">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58593.Tarihi'></label>
                                <div class="col col-9 col-xs-12">
                                    <input type="text" name="profession_ill_diagnosis" id="profession_ill_diagnosis" value="<cfif isdefined('PROFESSION_ILL_DIAGNOSIS')><cfoutput>#PROFESSION_ILL_DIAGNOSIS#</cfoutput></cfif>" style="width:175px;">
                                </div>
                            </div>
                            <div class="form-group" id="item-profession_ill_work">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="53459.Sevk Edilenin Bölüm/İş"></label>
                                <div class="col col-9 col-xs-12">
                                    <input type="text" name="profession_ill_work" id="profession_ill_work" value="<cfif isdefined('PROFESSION_ILL_WORK')><cfoutput>#PROFESSION_ILL_WORK#</cfoutput></cfif>" style="width:175px;">
                                </div>
                            </div>
                            <div class="form-group" id="item-profession_ill_doubt">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="58651.Türü"></label>
                                <div class="col col-9 col-xs-12">
                                    <input type="text" name="profession_ill_doubt" id="profession_ill_doubt" value="<cfif isdefined('PROFESSION_ILL_DOUBT')><cfoutput>#PROFESSION_ILL_DOUBT#</cfoutput></cfif>" style="width:175px;">
                                </div>
                            </div>
                            <div class="form-group" id="item-JOB_ILLNESS_TO_FIX">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="53442.Meslek Hastalığının Saptanma Şekli"></label>
                                <div class="col col-9 col-xs-12">
                                    <select name="JOB_ILLNESS_TO_FIX" id="JOB_ILLNESS_TO_FIX" style="width:175px;">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <option value="0"<cfif JOB_ILLNESS_TO_FIX is '0'> selected</cfif>><cf_get_lang dictionary_id='53446.Periyodik Muayene İle'></option>
                                        <option value="1"<cfif JOB_ILLNESS_TO_FIX is '1'> selected</cfif>><cf_get_lang dictionary_id='53447.Üst Kurum Sevki İle'></option>
                                        <option value="2"<cfif JOB_ILLNESS_TO_FIX is '2'> selected</cfif>><cf_get_lang dictionary_id='53448.Meslek Hast.Hastanesinde'></option>
                                        <option value="3"<cfif JOB_ILLNESS_TO_FIX is '3'> selected</cfif>><cf_get_lang dictionary_id='58156.Diğer'></option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row formContentFooter">
                        <div class="col col-6">
                            <cf_record_info query_name="get_fee">
                        </div>
                        <div class="col col-6">
                            <cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=ehesap.emptypopup_del_ssk_fee_self&fee_id=#url.fee_id#'>
                        </div>
                    </div>
                </cf_box_elements>
            </cfoutput>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
    $(document).ready(function(){
        work_kaldir();
    });
    function kontrol()
    {
        if (document.getElementById('in_out_id').value == "")
        {
            alert("<cf_get_lang dictionary_id ='54113.Çalışana Ait Giriş Seçmelisiniz'>!");
            return false;
        }
            
        if (document.getElementById('emp_name').value == "")
        {
            alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='57576.Çalışan'>");
            return false;
        }
        return true;
    }
    function illness_kaldir()
    {
        if(document.getElementById('illness').checked==true)
        {
            document.getElementById('continuationcheck').checked=false;
            document.getElementById('workcheck').checked=false;
            document.getElementById('relativecheck').checked=false;
            gizle(work);
        }
    }
    function work_kaldir()
    {
        if(document.getElementById('workcheck').checked==true)
        {
            document.getElementById('continuationcheck').checked=false;
            document.getElementById('illness').checked=false;
            document.getElementById('relativecheck').checked=false;
            goster(work);
        }
    }
    function relative_kaldir()
    {
        if(document.getElementById('relativecheck').checked==true)
        {
            document.getElementById('continuationcheck').checked=false;
            document.getElementById('illness').checked=false;
            document.getElementById('workcheck').checked=false;
            gizle(work);
        }
    }
    function continuation_kaldir()
    {
        if(document.getElementById('continuationcheck').checked==true)
        {
            document.getElementById('relativecheck').checked=false;
            document.getElementById('illness').checked=false;
            document.getElementById('workcheck').checked=false;
            gizle(work);
        }
    }
</script>