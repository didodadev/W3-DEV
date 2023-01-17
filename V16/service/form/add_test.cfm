<cfparam name="attributes.modal_id" default="">
<cfform name="form_add_test" action="#request.self#?fuseaction=service.emptypopup_add_service_test" method="post">
    <cf_box title="#getLang('service','Test sonucu ekle',41923)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cf_box_elements>
            <input type="hidden" name="service_id" id="service_id" value="<cfoutput>#attributes.service_id#</cfoutput>">
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-status">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='41662.Görevli Seç'></label>
                    <div class="col col-4 col-sm-12">
                        <input type="radio" name="status" id="status" value="0" checked><cf_get_lang dictionary_id='41791.Sağlam'>
                    </div>
                    <div class="col col-4 col-sm-12">
                        <input type="radio" name="status" id="status" value="1"><cf_get_lang dictionary_id='41792.Arızalı'>
                    </div>                
                </div> 
                <div class="form-group" id="item-test_person_name">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57756.Durum'></label>
                    <div class="col col-8 col-sm-12">
                        <div class="input-group">
                            <input type="hidden" name="test_par_id" id="test_par_id" value="">
                            <input type="hidden" name="test_comp_id" id="test_comp_id" value="">
                            <input type="hidden" name="test_emp_id" id="test_emp_id" value="">
                            <cfinput type="text" name="test_person_name" id="test_person_name" value="">
                            <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_partner=form_add_test.test_par_id&field_comp_id=form_add_test.test_comp_id&field_name=form_add_test.test_person_name&field_emp_id=form_add_test.test_emp_id&select_list=1');"></span>
                        </div>
                    </div>                
                </div> 
                <div class="form-group" id="item-service_code">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58934.Arıza Kodu'></label>
                    <div class="col col-8 col-sm-12">
                        <div class="input-group">
                            <input type="hidden" name="service_defect_id" id="service_defect_id" value="">
                            <input type="hidden" name="service_defect_code" id="service_defect_code" value="">
                            <input type="hidden" name="service_code_id" id="service_code_id" value="">
                            <cfinput type="text" name="service_code" id="service_code" value="">
                            <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=service.popup_service_defect_codes&service_code_id=form_add_test.service_code_id&service_code=form_add_test.service_code&service_defect_id=form_add_test.service_defect_id&service_defect_code=form_add_test.service_defect_code')"></span>
                        </div>
                    </div>                
                </div> 
                <div class="form-group" id="item-service_code">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57480.Başlık'></label>
                    <div class="col col-8 col-sm-12">
                        <input type="text" name="test_head" id="test_head" value="">
                    </div>                
                </div> 
                <div class="form-group" id="item-service_code">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57771.Detay'></label>
                    <div class="col col-8 col-sm-12">
                        <textarea name="detail" id="detail" style="width:280px;height:110px;"></textarea>
                    </div>                
                </div> 
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_workcube_buttons is_upd='0' add_function="#iif(isdefined("attributes.draggable"),DE("kontrol() && loadPopupBox('form_add_test' , #attributes.modal_id#)"),DE(""))#">
        </cf_box_footer>
    </cf_box>
</cfform>
<script type="text/javascript">
	function kontrol()
	{
		if (!form_add_test.test_head.value.length)
		{
			alert("<cf_get_lang dictionary_id='58059.Başlık Giriniz'> !");
			return false;
		}
		return true;
	}
</script>
