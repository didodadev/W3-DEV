<cfquery name="get_test" datasource="#dsn3#">
	SELECT * FROM SERVICE_TEST WHERE SERVICE_TEST_ID = #ATTRIBUTES.SERVICE_TEST_ID# 
</cfquery>
<cfparam name="attributes.modal_id" default="">
<cfform name="form_upd_test" action="#request.self#?fuseaction=service.emptypopup_upd_service_test" method="post">
    <cf_box title="#getLang('service','Test Sonucu Güncelle',41790)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <input type="hidden" name="service_id" value="<cfoutput>#attributes.service_id#</cfoutput>">
        <input type="hidden" name="SERVICE_TEST_ID" value="<cfoutput>#attributes.SERVICE_TEST_ID#</cfoutput>">
        <cf_box_elements>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-service_code">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57756.Durum'></label>
                    <div class="col col-4 col-sm-12">
                        <input type="radio" name="status" value="0" <cfif get_test.WORKING_BROKEN eq 0>checked</cfif>><cf_get_lang dictionary_id='41791.Sağlam'>
                    </div>                
                    <div class="col col-4 col-sm-12">
                        <input type="radio" name="status" value="1" <cfif get_test.WORKING_BROKEN eq 1>checked</cfif>><cf_get_lang dictionary_id='41792.Arızalı'>
                    </div>
                </div>
                <div class="form-group" id="item-test_person_name">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='41662.Görevli Seç'></label>
                    <div class="col col-8 col-sm-12">
                        <div class="input-group">
                            <input type="hidden" name="test_par_id" value="">
                            <input type="hidden" name="test_comp_id" value="">
                            <input type="hidden" name="test_emp_id" value="<cfoutput>#get_test.test_emp_id#</cfoutput>">
                            <cfinput type="text" name="test_person_name" value="#get_emp_info(get_test.test_emp_id,0,0)#">
                            <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_partner=form_upd_test.test_par_id&field_comp_id=form_upd_test.test_comp_id&field_name=form_upd_test.test_person_name&field_emp_id=form_upd_test.test_emp_id&select_list=1','list');"></span>
                        </div>
                    </div>                
                </div> 
                <div class="form-group" id="item-test_person_name">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58934.Arıza Kodu'></label>
                    <div class="col col-8 col-sm-12">
                        <div class="input-group">
                            <input type="hidden" name="service_defect_id" value="<CFOUTPUT>#get_test.SERVICE_DEFECT_ID#</CFOUTPUT>">
                            <input type="hidden" name="service_defect_code" value="<CFOUTPUT>#get_test.SERVICE_DEFECT_CODE#</CFOUTPUT>">
                            <input type="hidden" name="service_code_id" value="">
                            <cfinput type="text" name="SERVICE_CODE" value="#get_test.SERVICE_DEFECT_CODE#">
                            <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=service.popup_service_defect_codes&service_code_id=form_upd_test.service_code_id&service_code=form_upd_test.SERVICE_CODE&service_defect_id=form_upd_test.service_defect_id&service_defect_code=form_upd_test.service_defect_code','list')"></span>
                        </div>
                    </div>                
                </div> 
                <div class="form-group" id="item-test_person_name">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57480.Başlık'></label>
                    <div class="col col-8 col-sm-12">
                        <input type="text" name="test_head" value="<cfoutput>#get_test.TEST_HEAD#</cfoutput>">
                    </div>                
                </div>
                <div class="form-group" id="item-test_person_name">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57771.açıklama'></label>
                    <div class="col col-8 col-sm-12">
                        <textarea name="detail" style="width:280px;height:110px;"><cfoutput>#get_test.detail#</cfoutput></textarea>
                    </div>                
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_workcube_buttons is_upd='1' add_function="#iif(isdefined("attributes.draggable"),DE("kontrol() && loadPopupBox('form_upd_test' , #attributes.modal_id#)"),DE(""))#" delete_page_url='#request.self#?fuseaction=service.del_service_test&SERVICE_TEST_ID=#attributes.SERVICE_TEST_ID#'>
        </cf_box_footer>
    </cf_box>
</cfform>
<script type="text/javascript">
	function kontrol()
	{
		if (!form_upd_test.test_head.value.length)
		{
			alert("<cf_get_lang dictionary_id='58059.Başlık Giriniz'> !");
			return false;
		}
		if (!form_upd_test.service_defect_code.value.length)
		{
			alert("<cf_get_lang dictionary_id='43151.Arıza Kodu girmelisiniz'> !");
			return false;
		}
	}
</script>

