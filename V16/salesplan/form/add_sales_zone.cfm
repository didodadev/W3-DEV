<cfinclude template="../query/get_sales_zone_hierarchy.cfm">
<cfinclude template="../query/get_branchs.cfm">
<cfinclude template="../query/get_sales_zone_hierarchy.cfm">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent variable="head"><cf_get_lang dictionary_id='47074.Bölge Planlama'></cfsavecontent>
    <cf_box title="#head#" closable="0">
<cfform name="add_sales_zone" method="post" action="#request.self#?fuseaction=salesplan.emptypopup_add_sales_zone">
    <cf_box_elements>
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
            <div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-is_active">
                <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'> 
                    <input name="is_active" id="is_active" type="checkbox" value="1" checked="checked">
                </label>
            </div>
        </div>
        <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
            <div class="form-group" id="item-sz_name">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42529.Bölge Adı'> *</label>
                <div class="col col-8 col-xs-12">
                    <cfinput type="text" name="sz_name" value="" maxlength="100" required="Yes">
                </div>
            </div>
            <div class="form-group" id="item-ozel_kod">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'></label>
                <div class="col col-8 col-xs-12">
                    <input type="text" name="ozel_kod" id="ozel_kod" value="" maxlength="50">
                </div>
            </div>
            <div class="form-group" id="item-responsible_branch_id">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41457.İlgili Şube'> *</label>
                <div class="col col-8 col-xs-12">
                    <div class="input-group">
                        <input type="hidden" name="responsible_branch_id"  id="responsible_branch_id" value="">
                        <input name="responsible_branch" type="text" id="responsible_branch" onFocus="AutoComplete_Create('responsible_branch','BRANCH_NAME','BRANCH_NAME','get_branch_name','','BRANCH_ID','responsible_branch_id','','3','150');" autocomplete="off"> 
                            <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_id=add_sales_zone.responsible_branch_id&field_branch_name=add_sales_zone.responsible_branch&select_list=2,6');"></span>
                        
                    </div>
                </div>
            </div>
        </div>
        <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="3" sort="true">
            <div class="form-group" id="item-sz_hierarchy">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57761.Hiyerarşi'></label>
                <div class="col col-8 col-xs-12">
                    <select name="sz_hierarchy" id="sz_hierarchy">
                        <option value="0,0" selected><cf_get_lang dictionary_id='41448.Üst Bölge'></option>
                        <cfoutput query="get_sales_zone_hierarchy">
                            <option value="#sz_hierarchy#,#sz_id#">#sz_name#</option>
                        </cfoutput>
                    </select>
                </div>
            </div>
            <div class="form-group" id="item-key_account_id">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41455.Key Account'></label>
                <div class="col col-8 col-xs-12">
                    <div class="input-group">
                        <input type="hidden" name="key_account_id" id="key_account_id" value="">
                        <input name="key_account" type="text" id="key_account" onFocus="AutoComplete_Create('key_account','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','1','MEMBER_ID','key_account_id','','3','250');" value="" autocomplete="off">
                        <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&&is_period_kontrol=0&field_comp_name=add_sales_zone.key_account&field_comp_id=add_sales_zone.key_account_id&select_list=2,6');"></span>
                        
                    </div>
                </div>
            </div>
            <div class="form-group" id="item-responsible_position_code">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41458.Bölge Yöneticisi'></label>
                <div class="col col-8 col-xs-12">
                    <div class="input-group">
                        <input type="hidden" name="responsible_consumer_id" id="responsible_consumer_id" />
                        <input type="hidden" name="responsible_cmp_id" id="responsible_cmp_id" value="" />
                        <input type="hidden" name="responsible_position_code" id="responsible_position_code" value="">
                        <input type="text" name="responsible_position" id="responsible_position" onFocus="AutoComplete_Create('responsible_position','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID','responsible_cmp_id,responsible_consumer_id,responsible_position_code','','3','150');"  value="" autocomplete="off">
                        <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_sales_zone.responsible_position_code&field_name=add_sales_zone.responsible_position');"></span>
                        
                    </div>
                </div>
            </div>
        </div>
        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
            <div class="form-group" id="item-member_type">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41456.İş Ortağı'></label>
                <div class="col col-8 col-xs-12">
                    <div class="input-group">
                        <input type="hidden" name="member_type" id="member_type" value="">
                        <input type="hidden" name="responsible_company_id" id="responsible_company_id" value="">
                        <input name="responsible_company" type="text" id="responsible_company" onFocus="AutoComplete_Create('responsible_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2,3\'','COMPANY_ID,MEMBER_PARTNER_NAME2,PARTNER_CODE,MEMBER_TYPE','responsible_company_id,responsible_par,responsible_par_id,member_type','','3','250','return_company()');"  value="" autocomplete="off">
                        <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&&is_period_kontrol=0&field_id=add_sales_zone.responsible_par_id&field_name=add_sales_zone.responsible_par&field_comp_name=add_sales_zone.responsible_company&field_comp_id=add_sales_zone.responsible_company_id');"></span>
                        
                    </div>
                </div>
            </div>
            <div class="form-group" id="item-responsible_par_id">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41459.İş Ortağı Çalışan'></label>
                <div class="col col-8 col-xs-12">
                    <input type="hidden" name="responsible_par_id" id="responsible_par_id" value="">
                    <input type="text" name="responsible_par" id="responsible_par" readonly="true"  value="">
                </div>
            </div>
            <div class="form-group" id="item-sz_detail">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.açıklam'></label>
                <div class="col col-8 col-xs-12">
                    <textarea name="sz_detail" id="sz_detail"></textarea>
                </div>
            </div>
        </div>
    </cf_box_elements>
    <cf_box_footer>
            <cf_workcube_buttons type_format='1' is_upd='0' add_function='check()'>
    </cf_box_footer>
</cfform>
</cf_box>
<script type="text/javascript">
function check()
{
	if ( add_sales_zone.responsible_position.value == "" || (add_sales_zone.responsible_position_code.value == "" && add_sales_zone.responsible_cmp_id.value=="" && add_sales_zone.responsible_consumer_id.value==""))
	{
		alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='41458.Bölge Yöneticisi'>");
		return false;
	}
	if((add_sales_zone.responsible_branch.value=="") || (add_sales_zone.responsible_branch_id.value==""))
	{
		alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='41457.İlgili Şube'>");
		return false;
	}
	return true;		
}
function return_company()
{	
	if(document.getElementById('member_type').value=='employee')
	{	
	    var pos_id=document.getElementById('responsible_par_id').value;
		var GET_COMPANY = wrk_safe_query('slsp_get_compny','dsn',0,pos_id);
		document.getElementById('responsible_company_id').value=GET_COMPANY.COMP_ID;
	}
	 if(document.getElementById('member_type').value=='consumer')
	{
		var responsible_name=document.getElementById('responsible_par_id').value;
		var GET_COMPANY_NAME=wrk_safe_query('slsp_get_cmp_name','dsn',0,responsible_name);
		if(GET_COMPANY_NAME.COMPANY!=undefined)
			document.getElementById('responsible_company').value=GET_COMPANY_NAME.COMPANY;
	}
	else
		return false;
}
</script>
