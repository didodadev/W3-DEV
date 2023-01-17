<cf_get_lang_set module_name="ehesap">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Viziteler',30943)#: #getLang('','Yeni Kayıt',45697)#">
        <cfform name="ssk_fee"  method="post" action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_add_ssk_fee_self">
            <cf_box_elements>
                <div class="row" type="row">
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-emp_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57576.Çalışan'>*</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="employee_id" id="employee_id" value="">
                                    <input type="hidden" name="in_out_id" id="in_out_id" value="">
                                    <input type="text" name="emp_name" id="emp_name" style="width:150px;" value="" readonly>
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
                                        <cfinput validate="#validate_style#" type="text" name="DATE" id="DATE" value="" style="width:70px;" required="yes" message="#message#">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="DATE"></span>
                                    </div>
                                </div>
                                <div class="col col-2">
                                    <cfoutput>
                                        <cf_wrkTimeFormat name="HOUR" value="0">
                                    </cfoutput>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-DATEOUT">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='53146.Viziteye Çıkış'>*</label>
                            <div class="col col-8 col-xs-12">
                                <div class="col col-10 col-xs-12">
                                    <div class="input-group">
                                        <cfsavecontent variable="alert"><cf_get_lang dictionary_id ='54163.Viziteye Çıkış Tarihi Giriniz'></cfsavecontent>
                                        <cfinput required="yes" message="#alert#" validate="#validate_style#" type="text" name="DATEOUT" id="DATEOUT" value="" style="width:70px;">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="DATEOUT"></span>
                                    </div>
                                </div>
                                <div class="col col-2">
                                    <cfoutput>
                                        <cf_wrkTimeFormat name="HOUROUT" value="0">
                                    </cfoutput>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-detail">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57629.Açıklama'></label>
                            <div class="col col-8 col-xs-12">
                                <textarea name="detail" id="detail" style="width:150px;height:60px;"></textarea>
                            </div>
                        </div>
                        <div class="form-group" id="item-valid_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57500.Onay'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="validator_pos_code" id="validator_pos_code" value="">
                                    <cfinput type="text" name="valid_name" id="valid_name" value="" readonly="yes" style="width:150px;">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=ssk_fee.validator_pos_code&field_emp_name=ssk_fee.valid_name','list');return false"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-workcheck">
                            <label><input name="workcheck" id="workcheck" type="checkbox" onClick="gizle_goster(work);work_kaldir();" ><cf_get_lang dictionary_id ='53147.İş Kazası'></label>
                        </div>
                        <div class="form-group" id="item-illness">
                            <label><input name="illness" id="illness" type="checkbox" value="" onclick="illness_kaldir();"><cf_get_lang dictionary_id ='53462.Meslek Hastalığı'></label>
                        </div>
                        <div class="form-group" id="item-relativecheck">
                            <label><input name="relativecheck" id="relativecheck" type="checkbox" onclick="relative_kaldir();" value="1"/><cf_get_lang dictionary_id ='53920.İş Görememezlik Ödeneği'></label>
                        </div>
                        <div class="form-group" id="item-continuationcheck">
                            <label><input name="continuationcheck" id="continuationcheck" type="checkbox" onclick="continuation_kaldir();" value="1"/><cf_get_lang dictionary_id ='53919.İş Kazasının Devamı'></label>
                        </div>
                        <div class="form-group" id="item-detail_print">
                            <label><input type="checkbox" name="detail_print" id="detail_print" value="1"><cf_get_lang dictionary_id ='53913.Detaysız Print'></label>
                        </div>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true" id="work" style="display:none;">
                        <div class="form-group" id="item-total_emp">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='53463.Olay Tarihi İşçi Sayısı'></label>
                            <div class="col col-9 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id ='54003.İşçi Sayısı Sayısal Olmalıdır'></cfsavecontent>
                                <cfinput type="text" name="total_emp" id="total_emp" style="width:175px;"  value="" message="#message#" validate="integer">
                            </div>
                        </div>
                        <div class="form-group" id="item-label2">
                            <label class="col col-12 bold"><cf_get_lang dictionary_id ='53464.Sigortalının'></label>
                        </div>
                        <div class="form-group" id="item-emp_work">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='53465.İşi ve Mahiyeti'></label>
                            <div class="col col-9 col-xs-12">
                                <input type="text" name="emp_work" id="emp_work" style="width:175px;"  value="">
                            </div>
                        </div>
                        <div class="form-group" id="item-label3">
                            <label class="col col-12 bold"><cf_get_lang dictionary_id ='53466.İş Kazasının'></label>
                        </div>
                        <div class="form-group" id="item-_event_shape">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='53467.Oluş Şekli'></label>
                            <div class="col col-9 col-xs-12">
                                <textarea name="_event_shape" id="_event_shape" style="width:175px; height:60px;"></textarea>
                            </div>
                        </div>
                        <div class="form-group" id="item-accident_security_id">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='53468.Güvenlik Maddesi'></label>
                            <div class="col col-9 col-xs-12">
                                <cfinclude template="../query/get_accident_securities.cfm">
                                <select name="accident_security_id" id="accident_security_id" style="width:175px;">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_accident_securities">
                                        <option value="#accident_security_id#">#accident_security#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-accident_type_id">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='53469.Kaza Çeşidi'></label>
                            <div class="col col-9 col-xs-12">
                                <cfinclude template="../query/get_work_accident_type.cfm">
                                <select name="accident_type_id" id="accident_type_id" style="width:175px;">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="GET_WORK_ACCIDENT_TYPE">
                                        <option value="#ACCIDENT_TYPE_ID#">#accident_type#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-place">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='53470.Olay Yeri'></label>
                            <div class="col col-9 col-xs-12">
                                <input type="text" name="place" id="place" style="width:175px;"  value="" maxlength="50">
                            </div>
                        </div>
                        <div class="form-group" id="item-DATEEVENT">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58463.Tarih ve Saat'></label>
                            <div class="col col-9 col-xs-12">
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfinput validate="#validate_style#" type="text" name="DATEEVENT" id="DATEEVENT" value="" style="width:70px;">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="DATEEVENT"></span>
                                    </div>
                                </div>
                                <div class="col col-2 col-xs-12">
                                    <cfoutput><cf_wrkTimeFormat name="HOUREVENT" value="0"></cfoutput>
                                </div>
                                <div class="col col-2 col-xs-12">
                                    <select name="EVENT_MIN" id="EVENT_MIN">
                                        <option value="00" selected>00</option>
                                        <option value="05">05</option>
                                        <option value="10">10</option>
                                        <option value="15">15</option>
                                        <option value="20">20</option>
                                        <option value="25">25</option>
                                        <option value="30">30</option>
                                        <option value="35">35</option>
                                        <option value="40">40</option>
                                        <option value="45">45</option>
                                        <option value="50">50</option>
                                        <option value="55">55</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-workstart">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='53472.Olay Günündeki İşbaşı Saati'></label>
                            <div class="col col-9 col-xs-12">
                                <input type="text" name="workstart" id="workstart" style="width:175px;"  value="">
                            </div>
                        </div>
                        <div class="form-group" id="item-label1">
                            <label class="col col-12 bold"><cf_get_lang dictionary_id="53421.Kaza Sonucu"></label>
                        </div>
                        <div class="form-group" id="item-accident_result">
                            <div class="col col-12">
                                <div class="input-group">
                                    <span class="input-group-addon no-bg"><cf_get_lang dictionary_id='53423.Ölü'></span><input type="text" name="accident_result_dead" id="accident_result_dead" maxlength="3" onKeyUp="isNumber(this)" style="width:25px;" value="">
                                    <span class="input-group-addon no-bg"><cf_get_lang dictionary_id='53424.Ağır Yaralı'></span><input type="text" name="accident_result_wounded" id="accident_result_wounded" onKeyUp="isNumber(this)" maxlength="3" style="width:25px;" value="">
                                    <span class="input-group-addon no-bg"><cf_get_lang dictionary_id='53425.Uzuv Kaybı'></span><input type="text" name="organ_to_lose" id="organ_to_lose" maxlength="3" onKeyUp="isNumber(this)" style="width:25px;" value="">
                                    <span class="input-group-addon no-bg"><cf_get_lang dictionary_id='53426.Hafif Yaralı'></span><input type="text" name="light_wounded" id="light_wounded" maxlength="3" onKeyUp="isNumber(this)" style="width:25px;" value="">
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-rest_day">
                            <label class="col col-12 bold"><cf_get_lang dictionary_id="59309.İstirahat Günleri"></label>
                        </div>
                        <div class="form-group" id="item-accident_result">
                            <div class="col col-12">
                                <div class="input-group">
                                    <span class="input-group-addon no-bg"><cf_get_lang dictionary_id='53427.1 Gün'></span><input type="text" name="rest_first_day" id="rest_first_day" style="width:25px;" maxlength="3" onKeyUp="isNumber(this)" value="<cfif isdefined('REST_FIRST_DAY')>#REST_FIRST_DAY#</cfif>">
                                    <span class="input-group-addon no-bg"><cf_get_lang dictionary_id='53428.2 Gün'></span><input type="text" name="rest_second_day" id="rest_second_day" style="width:25px;" maxlength="3" onKeyUp="isNumber(this)" value="<cfif isdefined('REST_SECOND_DAY')>#REST_SECOND_DAY#</cfif>">
                                    <span class="input-group-addon no-bg"><cf_get_lang dictionary_id='53429.3 Gün'></span><input type="text" name="rest_third_day" id="rest_third_day" style="width:25px;" maxlength="3" onKeyUp="isNumber(this)"value="<cfif isdefined('REST_THIRD_DAY')>#REST_THIRD_DAY#</cfif>">
                                    <span class="input-group-addon no-bg"><cf_get_lang dictionary_id='53430.3 Günden Fazla'></span><input type="text" name="rest_extra_day" id="rest_extra_day" maxlength="3" style="width:25px;" onKeyUp="isNumber(this)" value="<cfif isdefined('REST_EXTRA_DAY')>#REST_EXTRA_DAY#</cfif>">
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
                                    <input type="text" name="witness1" id="witness1" style="width:175px;"  value="">
                                    <input type="hidden" name="witness1_id" id="witness1_id" value="">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=ssk_fee.witness1_id&field_emp_name=ssk_fee.witness1','list');return false"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-witness2">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='53325.Tanık'>-2</label>
                            <div class="col col-9 col-xs-12">
                                <div class="input-group">
                                    <input type="text" name="witness2" id="witness2" style="width:175px;"  value="">
                                    <input type="hidden" name="witness2_id" id="witness2_id" value="">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=ssk_fee.witness2_id&field_emp_name=ssk_fee.witness2','list');return false"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-DISMEMBERMENT">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='53912.Uzuv Kaybı Bilgisi'></label>
                            <div class="col col-9 col-xs-12">
                                <input type="text" name="DISMEMBERMENT" id="DISMEMBERMENT" style="width:175px;" maxlength="200" value="">
                            </div>
                        </div>
                        <div class="form-group" id="item-WILFUL_ERROR">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='53910.Kasıtlı Eylem Bilgisi'></label>
                            <div class="col col-9 col-xs-12">
                                <input type="text" name="WILFUL_ERROR" id="WILFUL_ERROR" style="width:175px;" maxlength="200" value="">
                            </div>
                        </div>
                        <div class="form-group" id="item-rest_day">
                            <label class="col col-12 bold"><cf_get_lang dictionary_id="59308.İşçinin birinci dereceden yakının"></label>
                        </div>
                        <div class="form-group" id="item-relative_name_surname">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57570.Ad Soyad'></label>
                            <div class="col col-9 col-xs-12">
                                <input type="text" name="relative_name_surname" id="relative_name_surname" value="" style="width:175px;" >
                            </div>
                        </div>
                        <div class="form-group" id="item-relative_name_surname">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="49318.Adresi"></label>
                            <div class="col col-9 col-xs-12">
                                <textarea name="relative_address" id="relative_address" style="width:175px;height:40px;"></textarea>
                            </div>
                        </div>
                        <div class="form-group" id="item-rest_day">
                            <label class="col col-12 bold"><cf_get_lang dictionary_id="53436.Meslek Hastalığı Tanısı veya Şüphesi"></label>
                        </div>
                        <div class="form-group" id="item-profession_ill_diagnosis">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="58593.Tarihi"></label>
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
                                <option value="0"><cf_get_lang dictionary_id='53446.Periyodik Muayene İle'></option>
                                <option value="1"><cf_get_lang dictionary_id='53447.Üst Kurum Sevki İle'></option>
                                <option value="2"><cf_get_lang dictionary_id='53448.Meslek Hast.Hastanesinde'></option>
                                <option value="3"><cf_get_lang dictionary_id='58156.Diğer'></option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-12">
                    <cf_box_footer>
                        <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                    </cf_box_footer>
                </div>
            </cf_box_elements>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
    function kontrol()
    {
        if (ssk_fee.emp_name.value == "")
            {
            alert("<cf_get_lang dictionary_id='53625.Çalışan Seçiniz'>!");
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