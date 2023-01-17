<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfform name="form_process_cat" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_main_process_cat">
        <input type="hidden" name="position_cats" id="position_cats" value="">
        <div class="col col-4 col-md-4 col-sm-4 col-xs-12 scrollbar" type="column" index="1" sort="false">
            <cf_box  title="#getLang('','Ana İşlem Kategorileri','43247')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
                <cfinclude template="../display/list_main_process_cat.cfm">
            </cf_box>
        </div>
        <div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="2" sort="false">
            <cf_box scroll="1" collapsable="1" resize="1">
                <cf_box_elements>
                    <div class="col col-4 col-md-4 col-ms-4 col-xs-12" type="column" index="1" sort="false">
                        <div class="form-group" id="item-process_cat">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="43247.Ana İşlem Kategorileri"> *</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput maxlength="100" required="Yes" type="text" name="process_cat" placeholder="#getLang('','Ana İşlem Kategorileri','43247')#" message="#getLang('','Kategori Girmelisiniz','33281')#">
                                    <span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=settings.popup_list_main_process_types&field_id=form_process_cat.process_type_id&field_name=form_process_cat.process_cat&field_module_id=form_process_cat.module_id&detail=form_process_cat.fuse_names</cfoutput>');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-module_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='38728.Modül'><cf_get_lang dictionary_id='58527.ID'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="module_id" id="module_id" value="" readonly="yes">
                            </div>
                        </div>  
                        <div class="form-group" id="item-process_type_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43246.Process'><cf_get_lang dictionary_id='58527.ID'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="process_type_id" id="process_type_id" value="" readonly="yes">
                            </div>
                        </div> 
                        <div class="form-group" id="item-fuse_names">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36185.Fuseaction'></label>
                            <div class="col col-8 col-xs-12">
                                <textarea name="fuse_names" id="fuse_names" rows="5"></textarea>
                            </div>
                        </div>    
                    </div>	
                    <div class="col col-4 col-md-4 col-ms-4 col-xs-12 scrollContent scroll-x4" type="column" index="2" sort="false">
                        <div class="form-group">
                            <cf_flat_list>
                                <thead>
                                    <tr>
                                        <th width="20">
                                            <a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_position_cats_multiuser&table_row_name=table_row_pcat&field_form_name=form_process_cat&field_poscat_id=position_cats&field_td=td_yetkili2&table_name=pos_cats&row_count=row_count_positon_cat&function_row_name=sil_process_cat');"><i class="icon-pluss"></i></a>
                                        </th>
                                        <th>
                                            <cf_get_lang dictionary_id='38005.Yetkili Pozisyon Tipleri'>  
                                        </th>
                                    </tr>
                                </thead>
                                <tbody id="pos_cats" name="pos_cats">
                                    <tr id="table_row_pcat0" name="table_row_pcat0" style="display:none;">
                                        <input type="hidden" name="row_count_positon_cat" id="row_count_positon_cat" value="0">
                                    </tr>								
                                </tbody>
                            </cf_flat_list>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-ms-4 col-xs-12 scrollContent scroll-x4" type="column" index="3" sort="false">
                        <div class="form-group">
                            <cf_workcube_to_cc is_update="0" to_dsp_name="#getLang('','Yetkili Pozisyonlar','36167')#" form_name="form_process_cat" str_list_param="1" data_type="1"> 
                        </div>
                    </div>	
                </cf_box_elements>
                <cf_box_footer>
                    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                </cf_box_footer>
            </cf_box>
        </div>
    </cfform>
</div>
<script type="text/javascript">
	function sil_process_cat(param_sil)
	{
		var my_element = document.getElementById('table_row_pcat' + param_sil);
		my_element.parentNode.removeChild(my_element);
	<!---	var my_element = eval("document.all.table_row_pcat" + param_sil);
		my_element.disabled=true;
		my_element.style.display = "none";	--->	
	}
	function kontrol()
	{
		if (form_process_cat.process_type_id.value =="")
		{
			alert("<cf_get_lang dictionary_id='43242.İşlem Kategorisi Seçiniz'>");
			return false;
		}
			return true;
	}
</script>
