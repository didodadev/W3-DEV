<cf_xml_page_edit fuseact="hr.emp_test_time">
<cfparam name="attributes.test_time_id" default="">
<cfquery name="get_test_time" datasource="#dsn#">
  SELECT  ETT.TEST_TIME_ID 
      , ETT.EMPLOYEE_ID 
      , ETT.QUIZ_ID 
      , ETT.TEST_TIME_STAGE 
      , ETT.TEST_TIME_TYPE 
      , ETT.TEST_TIME_DAY 
      , ETT.CAUTION_TIME_DAY 
      , ETT.CAUTION_EMP_ID 
      , ETT.TEST_TIME_DETAIL 
      , ETT.RECORD_DATE 
      , ETT.RECORD_EMP 
      , ETT.RECORD_IP 
      , ETT.UPDATE_DATE 
      , ETT.UPDATE_EMP 
      , ETT.UPDATE_IP 
    FROM  EMPLOYEES_TEST_TIME ETT
    WHERE 
        ETT.EMPLOYEE_ID = #attributes.emp_id# AND TEST_TIME_ID = #attributes.test_time_id#
</cfquery>
<cfquery name="get_test_time_type" datasource="#dsn#">
    SELECT EMPLOYEES_TEST_TIME_TYPE_ID
    ,TEST_TIME_TYPE_NAME
    ,RECORD_DATE
    ,RECORD_EMP
    ,RECORD_IP
    ,UPDATE_DATE
    ,UPDATE_EMP
    ,UPDATE_IP
FROM EMPLOYEES_TEST_TIME_TYPE
</cfquery>
<cfquery name="get_work_startdate" datasource="#dsn#" maxrows="1">
    SELECT 
        START_DATE,
        IN_OUT_ID
    FROM
        EMPLOYEES_IN_OUT
    WHERE
        EMPLOYEE_ID = #attributes.emp_id#
    ORDER BY IN_OUT_ID DESC
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="61213.Deneme Süresi Güncelle"></cfsavecontent>
<div class="col col-12">
    <cf_box title="#message#" closable="1" draggable="1" scroll="1" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform action="#request.self#?fuseaction=hr.emptypopup_upd_emp_test_time&test_time_id=#attributes.test_time_id#&emp_id=#attributes.emp_id#" name="upd_test_time" method="post">
            <input type="hidden" name="control_upd" id="control_upd" value="<cfif not len(get_test_time.test_time_day)>1</cfif>">
            <cf_box_elements>
                <cfoutput query="get_test_time">
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
                                <cfif get_work_startdate.recordcount>
                                    <cfoutput>#dateformat(dateadd('d',get_test_time.test_time_day,get_work_startdate.start_date),dateformat_style)#</cfoutput>
                                </cfif>
                            </label>
                        </div>        
                        <div class="form-group" id="test_time_stage">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-4"><cf_get_lang dictionary_id='58859.Süreç'></label>
                            <label class="col col-8 col-md-8 col-sm-8 col-xs-8">
                                <cf_workcube_process is_upd="0" is_detail="1" select_value="#TEST_TIME_STAGE#">
                            </label>
                        </div>     
                        <div class="form-group" id="item-test_time">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-4"><cf_get_lang dictionary_id='29776.Deneme Süresi'>*</label>
                            <div class="col col-2 col-md-2 col-sm-2 col-xs-2">
                                <cfinput onChange="control_warning();" type="text" name="test_time" maxlength="3" value="#get_test_time.test_time_day#" validate="integer" message="Deneme Süresi Giriniz!" required="yes">
                            </div>
                            <label class="col col-2 col-md-2 col-sm-2 col-xs-2"><cf_get_lang dictionary_id='57490.gün'></label>
                            <div class="col col-2 col-md-2 col-sm-2 col-xs-2">
                                <cfinput onChange="control_warning();" type="text" name="caution_time" maxlength="3" value="#get_test_time.caution_time_day#" validate="integer" message="Uyarı Süresi Giriniz!">
                            </div>
                            <label class="col col-2 col-md-2 col-sm-2 col-xs-2"><cf_get_lang dictionary_id='55321.gün önce uyar'></label>
                        </div>  
                        <div class="form-group" id="item-test_time_type">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-4"><cf_get_lang dictionary_id='29776.Deneme Süresi'><cf_get_lang dictionary_id='30152.Tipi'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-8">
                                <select id="test_time_type" name="test_time_type" onChange="control_warning();">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfloop query="get_test_time_type">
                                    <option value="#EMPLOYEES_TEST_TIME_TYPE_ID#"<cfif EMPLOYEES_TEST_TIME_TYPE_ID eq get_test_time.TEST_TIME_TYPE>selected</cfif>>#TEST_TIME_TYPE_NAME#</option>
                                    </cfloop>
                                </select>
                            </div>
                        </div>    
                        <div class="form-group" id="item-caution_emp">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-4"><cf_get_lang dictionary_id='55907.Değerlendirme Formu'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-8">
                                <div class="input-group">
                                    <cfquery name="GET_QUIZ" datasource="#DSN#">
                                        SELECT SURVEY_MAIN_HEAD,PROCESS_ID FROM SURVEY_MAIN WHERE SURVEY_MAIN_ID IN (#get_test_time.QUIZ_ID#)
                                    </cfquery>
                                    <input type="hidden" name="quiz_id_old" id="quiz_id_old" value="<cfoutput>#get_test_time.QUIZ_ID#</cfoutput>">
                                    <input type="hidden" name="quiz_id" id="quiz_id" value="<cfoutput>#get_test_time.QUIZ_ID#</cfoutput>">
                                    <input type="text" name="quiz_head" id="quiz_head" onChange="control_warning();" value="<cfoutput>#GET_QUIZ.SURVEY_MAIN_HEAD#</cfoutput>">			    
                                    <span class="input-group-addon btnPointer icon-ellipsis"  href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_form_generators&type=6&is_form_generators=1&field_id=upd_test_time.quiz_id&field_name=upd_test_time.quiz_head<cfif isdefined('attributes.empapp_id')>&empapp_id=#attributes.empapp_id#</cfif></cfoutput>','list');"></span>
                                </div>
                            </div>
                        </div>      
                        <div class="form-group" id="item-caution_emp">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-4"><cf_get_lang dictionary_id='55323.Uyarılacak Kişi'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-8">
                                <div class="input-group">
                                    <input type="hidden" name="caution_emp_old_id" id="caution_emp_old_id" value="<cfoutput>#caution_emp_id#</cfoutput>">
                                    <input type="hidden" name="caution_emp_id" id="caution_emp_id" value="<cfoutput>#caution_emp_id#</cfoutput>">
                                    <input type="text" name="caution_emp" id="caution_emp" onChange="control_warning();"  value="<cfoutput>#get_emp_info(caution_emp_id,0,0)#</cfoutput>" readonly>
                                    <span class="input-group-addon btnPointer icon-ellipsis" href="javascript://"onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=upd_test_time.caution_emp_id&field_emp_name=upd_test_time.caution_emp','list');return false"></span>
                                </div>
                            </div>
                        </div>
                    
                        <div class="form-group" id="item-test_detail">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-4"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-8">
                                <textarea onChange="control_warning();" name="test_detail" id="test_detail"><cfoutput>#test_time_detail#</cfoutput></textarea>
                            </div>
                        </div>
                    </div>
                </cfoutput>  
            </cf_box_elements>  
            <cf_box_footer>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-6">
                    <cf_record_info query_name="get_test_time">
                </div> 
                <div class="col col-6 col-md-6 col-sm-6 col-xs-6">
                    <cf_workcube_buttons is_upd='1' add_function='control_warning2()' is_delete='1' delete_page_url='#request.self#?fuseaction=hr.emptypopup_upd_emp_test_time&test_time_id=#attributes.test_time_id#&is_sil=1'>
                </div> 
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
    function control_warning()//herhangibir alan değiştiğinde hidden alanı 1 set eder ve uyarı ozaman eklenir
    {
        document.upd_test_time.control_upd.value = '1';
    }
    function control_warning2()
    {
        if((document.upd_test_time.test_time.value == "" || document.upd_test_time.caution_time.value == ""))
        {
            alert("<cf_get_lang dictionary_id='37578.Deneme Süresi giriniz'>");
            return false;
        }

        if((document.upd_test_time.quiz_id.value == "" || document.upd_test_time.quiz_head.value == ""))
        {
            alert("<cf_get_lang dictionary_id='55907.Değerlendirme Formu'>");
            return false;
        }
        if((document.upd_test_time.caution_emp_id.value == "" || document.upd_test_time.caution_emp.value == ""))
        {
            alert("<cf_get_lang dictionary_id='53498.Lütfen uyarılacak kişi seçiniz.'>");
            return false;
        }
        if(document.upd_test_time.quiz_id_old.value != document.upd_test_time.quiz_id.value)
        {
            document.upd_test_time.control_upd.value = '1';
        }
        if(document.upd_test_time.caution_emp_old_id.value != document.upd_test_time.caution_emp_id.value)
        {
            document.upd_test_time.control_upd.value = '1';
        }
        if(document.upd_test_time.test_time_type.value == "")
        {
            alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='29776.Deneme Süresi'><cf_get_lang dictionary_id='30152.Tipi'>");
            return false;
        }
        <cfif isdefined("attributes.draggable")>
			<cfoutput>
				loadPopupBox('upd_test_time' , '#attributes.modal_id#');
			</cfoutput>
		</cfif>
    }
</script>