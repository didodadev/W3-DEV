<cfinclude template="../query/get_main_process_cat.cfm">
<cfinclude template="../query/get_main_process_cat_rows.cfm">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfform name="upd_process_cat" id="upd_process_cat" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_main_process_cat"> 
        <div class="col col-4 col-md-4 col-sm-4 col-xs-12 scrollbar" type="column" index="1" sort="false">
            <cf_box title="#getLang('','Ana İşlem Kategorileri','43247')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
                <cfinclude template="../display/list_main_process_cat.cfm">
            </cf_box>
        </div>    
        <div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="2" sort="false">
            <cf_box scroll="1" collapsable="1" resize="1" title="#get_main_process_cat.main_process_cat#" add_href="#request.self#?fuseaction=settings.form_add_main_process_cat" is_blank="0">
                <cf_box_elements>
                    <input type="hidden" name="process_cat_id" id="process_cat_id" value="<cfoutput>#process_cat_id#</cfoutput>">
                        <div class="col col-4 col-md-4 col-ms-4 col-xs-12" type="column" index="1" sort="false">
                            <div class="form-group" id="item-process_cat">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="43247.Ana İşlem Kategorileri"> *</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfinput maxlength="100" value="#get_main_process_cat.main_process_cat#" required="Yes" type="text" name="process_cat" id="process_cat" message="#getLang('','Kategori Girmelisiniz','33281')#">
                                        <span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" title="<cf_get_lang dictionary_id='43242.İşlem Kategorisi Seçiniz'>!"	onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_list_main_process_types&field_id=upd_process_cat.process_type&field_name=upd_process_cat.process_cat&field_module_id=upd_process_cat.module_id&detail=upd_process_cat.fuse_names');"></span>
                                        <span class="input-group-addon">
                                            <cf_language_info
                                            table_name="SETUP_MAIN_PROCESS_CAT"
                                            column_name="MAIN_PROCESS_CAT"
                                            column_id_value="#ATTRIBUTES.PROCESS_CAT_ID#"
                                            maxlength="500"
                                            datasource="#dsn#" 
                                            column_id="MAIN_PROCESS_CAT_ID" 
                                            control_type="0">
                                        </span>
                                    </div>
                                </div>
                            </div> 
                            <div class="form-group" id="item-module_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='38728.Modül'><cf_get_lang dictionary_id='58527.ID'></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text"  name="module_id" id="module_id" value="<cfoutput>#get_main_process_cat.main_process_module#</cfoutput>" readonly="yes">
                                </div>
                            </div>
                            <div class="form-group" id="item-process_type">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43246.Process'><cf_get_lang dictionary_id='58527.ID'></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text"  name="process_type" id="process_type" value="<cfoutput>#get_main_process_cat.main_process_type#</cfoutput>" readonly="yes">
                                </div>
                            </div>	
                            <div class="form-group" id="item-fuse_names">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36185.Fuseaction'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfquery name="get_fu_names" datasource="#DSN#">
                                        SELECT 
                                            MAIN_PROCESS_CAT_ID, 
                                            FUSE_NAME 
                                        FROM 
                                            SETUP_MAIN_PROCESS_CAT_FUSENAME 
                                        WHERE 
                                            MAIN_PROCESS_CAT_ID = #process_cat_id#
                                    </cfquery>
                                    <textarea  rows="5" name="fuse_names" id="fuse_names"><cfoutput>#ValueList(get_fu_names.FUSE_NAME)#</cfoutput></textarea>
                                </div>
                            </div>                        
                        </div>
                        <div class="col col-4 col-md-4 col-ms-4 col-xs-12 scrollContent scroll-x4" type="column" index="2" sort="false">
                            <div class="form-group">
                                <cf_flat_list>
                                    <thead>
                                        <tr>
                                            <th width="20">
                                                <a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_position_cats_multiuser&table_row_name=table_row_pcat&field_form_name=upd_process_cat&field_poscat_id=position_cats&field_td=td_yetkili2&table_name=pos_cats&row_count=row_count_positon_cat&function_row_name=sil_process_cat</cfoutput>');"><i class="icon-pluss"></i></a>
                                            </th>
                                            <th>
                                                <cf_get_lang dictionary_id='43395.Yetkili Pozisyon Kategorileri'>
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody id="pos_cats" name="pos_cats">
                                        <tr id="table_row_pcat0" name="table_row_pcat0" style="display:none;">
                                            <td>
                                                <input type="hidden" name="row_count_positon_cat" id="row_count_positon_cat" value="<cfoutput>#get_main_process_cat_rows_position_cats.recordcount#</cfoutput>">
                                                <input type="hidden" name="position_cats" id="position_cats" value="">
                                            </td>
                                        </tr>
                                        <cfoutput query="get_main_process_cat_rows_position_cats">
                                            <tr id="table_row_pcat#currentrow#" name="table_row_pcat#currentrow#">
                                                <td>
                                                    <input type="hidden" name="position_cats" id="position_cats" value="#position_cat_id#">
                                                    <a href="javascript://" onClick="sil_process_cat('#currentrow#');"><i class="icon-minus"></i>&nbsp;#position_cat#
                                                </td>
                                            </tr>
                                        </cfoutput>				
                                    </tbody>
                                </cf_flat_list>
                            </div>
                        </div>
                        <div class="col col-4 col-md-4 col-ms-4 col-xs-12 scrollContent scroll-x4" type="column" index="3" sort="false">
                            <div class="form-group">
                                <cf_workcube_to_cc
                                is_update="1"
                                to_dsp_name="#getLang('','Katılımcılar','57590')#"
                                form_name="upd_process_cat"
                                str_list_param="1"
                                action_dsn="#DSN#"
                                str_action_names = "MAIN_POSITION_CODE AS TO_POS_CODE"
                                str_alias_names = "TO_PAR,TO_POS_CODE"
                                action_table="SETUP_MAIN_PROCESS_CAT_ROWS"
                                action_id_name="MAIN_PROCESS_CAT_ID"
                                data_type="2"
                                action_id="#attributes.process_cat_id#">
                            </div>
                        </div>
                </cf_box_elements>
                <cf_box_footer>
                    <cf_record_info query_name="get_main_process_cat">
                    <cf_workcube_buttons is_upd='1' is_delete='0'>
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
	<!--- Bu işlem crome da çalışmıyor.... bunun yerine removeChild kullanalım
		my_element.style.display = "none";
		my_element.disabled = true;--->
	} 
</script>
