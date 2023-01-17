<cf_xml_page_edit fuseact="hr.emp_test_time">
<cfquery name="get_test_time_type" datasource="#dsn#">
    SELECT EMPLOYEES_TEST_TIME_TYPE_ID,TEST_TIME_TYPE_NAME FROM EMPLOYEES_TEST_TIME_TYPE
</cfquery>
<cfquery name="get_work_startdate" datasource="#dsn#" maxrows="1">
    SELECT 
        START_DATE,
        IN_OUT_ID
    FROM
        EMPLOYEES_IN_OUT
    WHERE
        EMPLOYEE_ID = #url.emp_id#
    ORDER BY IN_OUT_ID DESC
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="61212.Deneme Süresi Ekle"></cfsavecontent>
<cf_box title="#message#" closable="1" scroll="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform action="#request.self#?fuseaction=hr.emptypopup_add_emp_test_time" name="add_test_time" method="post">
        <input type="hidden" name="control_upd" id="control_upd" value="1">
        <input type="hidden" name="emp_id" id="emp_id" value="<cfoutput>#url.emp_id#</cfoutput>">
        <cf_box_elements>
            <div class="col col-12 col-xs-12" type="column">
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-4"><cf_get_lang dictionary_id='55154.İşe Başlama Tarihi'></label>
                    <label class="col col-8 col-md-8 col-sm-8 col-xs-8">
                        <cfif get_work_startdate.recordcount>
                            <cfoutput>#dateformat(get_work_startdate.start_date,dateformat_style)#
                                <cfinput type="hidden" name="work_start_date" value="#dateformat(get_work_startdate.start_date,dateformat_style)#">
                            </cfoutput>
                        </cfif>
                    </label>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-4"><cf_get_lang dictionary_id='56888.Deneme Süresi Bitimi'></label>
                    <label class="col col-8 col-md-8 col-sm-8 col-xs-8">
                        
                    </label>
                </div>
                <div class="form-group" id="test_time_stage">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-4"><cf_get_lang dictionary_id='58859.Süreç'></label>
                    <label class="col col-8 col-md-8 col-sm-8 col-xs-8">
                        <cf_workcube_process is_upd="0" is_detail="0">
                    </label>
                </div>
                <div class="form-group" id="item-test_time">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-4"><cf_get_lang dictionary_id='29776.Deneme Süresi'>*</label>
                    <div class="col col-2 col-md-2 col-sm-2 col-xs-2">
                        <cfinput type="text" name="test_time" maxlength="3" value="" validate="integer" message="Deneme Süresi Giriniz!" required="yes">
                    </div>
                    <label class="col col-2 col-md-2 col-sm-2 col-xs-2"><cf_get_lang dictionary_id='57490.gün'></label>
                    <div class="col col-2 col-md-2 col-sm-2 col-xs-2">
                        <cfinput type="text" name="caution_time" maxlength="3" value="" validate="integer" message="Uyarı Süresi Giriniz!">
                    </div>
                    <label class="col col-2 col-md-2 col-sm-2 col-xs-2"><cf_get_lang dictionary_id='55321.gün önce uyar'></label>
                </div>  
                <div class="form-group" id="item-test_time_type">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-4"><cf_get_lang dictionary_id='29776.Deneme Süresi'><cf_get_lang dictionary_id='30152.Tipi'>*</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-8">
                        <select id="test_time_type" name="test_time_type">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfoutput query="get_test_time_type">
                            <option value="#EMPLOYEES_TEST_TIME_TYPE_ID#">#TEST_TIME_TYPE_NAME#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-test_time">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-4"><cf_get_lang dictionary_id='55907.Değerlendirme Formu'>*</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-8">
                        <div class="input-group">
                            <input type="hidden" name="quiz_id" id="quiz_id" value="">
                            <input type="text" name="quiz_head" id="quiz_head" value="" readonly>
                            <span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_form_generators&type=6&is_form_generators=1&field_id=add_test_time.quiz_id&field_name=add_test_time.quiz_head</cfoutput>','list');"></span>
                        </div>
                    </div>
                </div> 
                <div class="form-group" id="item-caution_emp">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-4"><cf_get_lang dictionary_id='55323.Uyarılacak Kişi'>*</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-8">
                        <div class="input-group">
                                <input type="hidden" name="caution_emp_id" id="caution_emp_id" value="">
                                <input type="text" name="caution_emp" id="caution_emp" value="" readonly>
                                <span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=add_test_time.caution_emp_id&field_emp_name=add_test_time.caution_emp','list');return false"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-test_detail">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-4"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-8"> 
                            <textarea  name="test_detail" id="test_detail"></textarea>
                    </div>
                </div>
            </div>
            </cf_box_elements>   
        <cf_box_footer>
            <cf_workcube_buttons is_upd='0' add_function='control_warning2()'>
        </cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
    function control_warning()//herhangibir alan değiştiğinde hidden alanı 1 set eder ve uyarı ozaman eklenir
    {
        document.add_test_time.control_upd.value = '1';
    }
    function control_warning2()
    {
        if((document.add_test_time.test_time.value == "" || document.add_test_time.caution_time.value == ""))
        {
            alert("<cf_get_lang dictionary_id='37578.Deneme Süresi giriniz'>");
            return false;
        }

        if((document.add_test_time.quiz_id.value == "" || document.add_test_time.quiz_head.value == ""))
        {
            alert("<cf_get_lang dictionary_id='55907.Değerlendirme Formu'>");
            return false;
        }
        
        if((document.add_test_time.caution_emp_id.value == "" || document.add_test_time.caution_emp.value == ""))
        {
            alert("<cf_get_lang dictionary_id='53498.Lütfen uyarılacak kişi seçiniz.'>");
            return false;
        }
        if(document.add_test_time.test_time_type.value == "")
        {
            alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='29776.Deneme Süresi'><cf_get_lang dictionary_id='30152.Tipi'>");
            return false;
        }
    }
</script>