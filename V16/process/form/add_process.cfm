<cfquery name="Get_Our_Company" datasource="#dsn#">
	SELECT COMP_ID, NICK_NAME FROM OUR_COMPANY ORDER BY NICK_NAME
</cfquery>
<cfquery name="get_general_processes" datasource="#dsn#">
	SELECT
		PM.PROCESS_MAIN_ID,
		PM.PROCESS_MAIN_HEADER,
		PM.PROJECT_ID
	FROM
		PROCESS_MAIN PM

</cfquery>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent  variable="head"><cf_get_lang dictionary_id='36203.Süreç Tasarım'> </cfsavecontent>
    <cf_box title="#head#">
        <cfform name="add_process" method="post" action="#request.self#?fuseaction=process.emptypopup_add_process">
            <input type="hidden" name="process_id" id="process_id"  value="<cfif isdefined('attributes.process_id') and len(process_id)><cfoutput>#attributes.process_id#</cfoutput></cfif>"/>
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-is_active">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
                        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                            <input type="checkbox" name="is_active" id="is_active" value="1" checked> 
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id="36294.Ana süreç"></label>
                        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                            <select id="item_process_main_id" name="item_process_main_id">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_general_processes">
                                    <option value="#PROCESS_MAIN_ID#">#PROCESS_MAIN_HEADER#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-process_name">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'>*</label>
                        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Girilmesi Zorunlu Alan'> :<cf_get_lang dictionary_id='58859.Süreç'>!</cfsavecontent>
                            <cfinput type="text" name="process_name" value="" maxlength="200" required="Yes" message="#message#">
                        </div>
                    </div>
                    <div class="form-group" id="item-detail">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
                            <textarea name="detail" id="detail"></textarea>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">    
                    <div class="form-group" id="item-process_our_company_id">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='58017.İlişkili Şirketler'></label>
                        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">     
                            <select name="process_our_company_id" id="process_our_company_id" multiple>
                                <cfoutput query="Get_Our_Company">
                                    <option value="#comp_id#">#nick_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-module_field_name">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='36185.Fuseaction'><a href="javascript://"onclick="gonder();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='36185.Fuseaction'> <cf_get_lang dictionary_id='57582.Ekle'>"></i></a></label>
                        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">    
                            <textarea name="module_field_name" id="module_field_name" rows="3"></textarea>
                        </div>
                    </div>
                    <div class="form-group" id="item-module_page_name">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='65451.B2B-B2C Pages'></label>
                        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">    
                            <textarea name="module_page_name" id="module_page_name" rows="3"></textarea>
                        </div>
                    </div>
                    <div class="form-group" id="item-widget_friendly_url">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='61176.Widget'><a href="javascript://"onclick="send_widget();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='29812.Add Widget'>"></i></a></label>
                        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">    
                            <textarea name="widget_friendly_url" id="widget_friendly_url" rows="3"></textarea>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">   
                    <div class="form-group" id="item-is_stage_back">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_stage_back" id="is_stage_back" value="1"><cf_get_lang dictionary_id='36226.Aşamalar Geriye Dönebilir'></label>
                    </div>
                    <div class="form-group" id="item-is_stage_manuel_change">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_stage_manuel_change" id="is_stage_manuel_change" value="1"><cf_get_lang dictionary_id='60363.Aşamalar manuel değiştirilebilir'></label>
                    </div>
                    <div class="form-group" id="item-up_department">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='42335.Üst Departman'></label>
                        <div class="col col-9 col-xs-12"> 
                            <div class="input-group">
                                <input type="hidden" name="oldhierarchy" id="oldhierarchy" value="">
                                <input type="hidden" name="old_up_department_id" id="old_up_department_id" value="">
                                <input type="hidden" name="up_department_id" id="up_department_id" value="">
                                <input type="text" name="up_department" id="up_department" value="" style="">
                                <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_departments&field_id=add_process.up_department_id&is_form_submitted=1&field_name=add_process.up_department</cfoutput>');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-department">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57572.Department'></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="department_id" id="department_id" value="<cfif isdefined("get_dep_bra.recordcount") and get_dep_bra.recordcount><cfoutput>#get_dep_bra.department_id#</cfoutput></cfif>">
                                <input type="text" name="department" id="department" value="<cfif isdefined("get_dep_bra.recordcount") and get_dep_bra.recordcount><cfoutput>#get_dep_bra.department_head#</cfoutput></cfif>" style="width:230px;">
                                <span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_departments&field_id=add_process.department_id&is_form_submitted=1&field_name=add_process.department</cfoutput>');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-employee_name">
                        <label class="col col-3 col-xs-12"><cf_get_lang_main no='132.Sorumlu'> </label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="emp_id" id="emp_id" value="">
                                <input type="text" name="employee_name" id="employee_name" value="" onFocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE,EMPLOYEE_ID','position_code,emp_id','','3','135','fill_department()');">
                                <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_name=add_process.employee_name&is_form_submitted=1&field_emp_id=add_process.emp_id&function_name=fill_department</cfoutput>&select_list=1')"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </cf_box_elements>             
            <div class="ui-form-list-btn">
                <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
            </div>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
function gonder()
{
	if(add_process.module_field_name.value=="")
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=process.popup_dsp_faction_list&field_name=add_process.module_field_name&is_upd=0</cfoutput>');
	else
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=process.popup_dsp_faction_list&field_name=add_process.module_field_name&is_upd=1</cfoutput>');
}
function send_widget()
{
	if(add_process.widget_friendly_url.value=="")
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=dev.popup_widget&field_name=add_process.widget_friendly_url&widget_type=4&draggable=1&is_upd=0&only_choice=0&is_friendly=1</cfoutput>');
	else
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=dev.popup_widget&field_name=add_process.widget_friendly_url&widget_type=4&draggable=1&is_upd=1&only_choice=0&is_friendly=1</cfoutput>');
}

function kontrol()
{
	if(document.add_process.process_our_company_id.value == '')
	{
		alert("<cf_get_lang dictionary_id='58194.Girilmesi Zorunlu Alan'> : <cf_get_lang dictionary_id='58017.İlişkili Şirketler'> !");
		return false;
    }
    if(document.add_process.item_process_main_id.value == '')
	{
		alert("<cf_get_lang dictionary_id='58194.Girilmesi Zorunlu Alan'> : <cf_get_lang dictionary_id='36294.Ana süreç'> !");
		return false;
	}
}
</script>
