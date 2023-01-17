<cf_get_lang_set module_name="ch">
<cfquery name="GET_MONEY_RATE" datasource="#dsn2#">
	SELECT MONEY FROM SETUP_MONEY WHERE MONEY_STATUS = 1 ORDER BY MONEY_ID
</cfquery>
<cfparam name="attributes.modal_id" default="">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang(1344,'Açılış Fişi',58756)#"popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="add_ch_open" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_ch_open_row">	
            <input type="hidden" name="modal_id" id="modal_id" value="<cfoutput>#attributes.modal_id#</cfoutput>">
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-detail">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-9 col-xs-12">
                            <input type="text" name="detail" id="detail" value="" >
                        </div>
                    </div>
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57800.işlem tipi'>*</label>
                        <div class="col col-9 col-xs-12">
                            <cf_workcube_process_cat slct_width="200">
                        </div>
                    </div>
                    <div class="form-group" id="item-emp_id">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57519.Hesap'>*</label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="comp_id" id="comp_id" value="">
                                <input type="hidden" name="cons_id" id="cons_id" value="">
                                <input type="hidden" name="emp_id" id="emp_id" value="">
                                <input type="text" name="acc_name" id="acc_name" onFocus="AutoComplete_Create('acc_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'\',\'\',\'\',\'\',\'\',\'\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID','comp_id,cons_id,emp_id','','3','200');" value="" >
                                <span class="input-group-addon icon-ellipsis btnPointer"  onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_multi_act=1&is_cari_action=1&field_name=add_ch_open.acc_name&field_comp_name=add_ch_open.acc_name&field_consumer=add_ch_open.cons_id&field_emp_id=add_ch_open.emp_id&is_form_submitted=1&field_comp_id=add_ch_open.comp_id<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_store_module")>&is_store_module=1</cfif>&select_list=2,3,1,9');"></span>
                            </div> 
                        </div>
                    </div>
                    <cfif session.ep.our_company_info.project_followup eq 1>
                    <div class="form-group" id="item-project_id">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                            <input type="hidden" name="project_id" id="project_id" value="">
                            <cf_wrk_projects form_name='add_ch_open' project_id='project_id' project_name='project_name'>
                            <input type="text" name="project_name" id="project_name" value=""  onFocus="AutoComplete_Create('project_name','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
                            <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=add_ch_open.project_name&project_id=add_ch_open.project_id</cfoutput>&form_varmi=1');" title="<cf_get_lang dictionary_id='57416.Proje'>" alt="<cf_get_lang dictionary_id='57416.Proje'>"></span>
                            </div>
                        </div>
                    </div>
                    </cfif>
                    <div class="form-group" id="item-subscription_id">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='29502.Abone No'></label>
                        <div class="col col-9 col-xs-12">
                            <cf_wrk_subscriptions fieldId='subscription_id' fieldName='subscription_no' form_name='add_ch_open'>
                        </div>
                    </div>
                    <cfif session.ep.our_company_info.asset_followup eq 1>
                        <div class="form-group" id="item-asset_id">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='58833.Fiziki Varlık'></label>
                            <div class="col col-9 col-xs-12">
                                    <cf_wrkAssetp fieldId='asset_id' fieldName='asset_name' form_name='add_ch_open' width='200'>
                            </div>
                        </div>
                    </cfif>
                    <cfif session.ep.isBranchAuthorization eq 0>
                        <div class="form-group" id="item-branch_id">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='57453.Şube'></label>
                            <div class="col col-9 col-xs-12">
                                <cf_wrkDepartmentBranch fieldId='branch_id' is_branch='1' width='200' is_default='0' is_deny_control='1'>
                            </div>
                        </div>
                    </cfif>
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-open_date">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id="50413.İşlem Tarihi Giriniz"> !</cfsavecontent>
                                <cfinput name="open_date" value="01/01/#session.ep.period_year#" validate="#validate_style#" type="text"   required="yes" message="#message#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="open_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-due_date">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58851.Ödeme Tarihi'></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <cfinput name="due_date" value="" validate="#validate_style#" type="text"  >
                                <span class="input-group-addon"><cf_wrk_date_image date_field="due_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-paper_no">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57880.Belge No'></label>
                        <div class="col col-9 col-xs-12">
                            <input type="text" name="paper_no" id="paper_no" value=""  maxlength="50">
                        </div>
                    </div>
                    <div class="form-group" id="item-debt">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57587.Borç'>*</label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <input type="text" name="debt" id="debt" maxlength="20" value="0" class="moneybox"  onBlur="sil(0);" onkeyup="return(FormatCurrency(this,event));"> 
                                <span class="input-group-addon "><cfoutput>#session.ep.money#</cfoutput></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-claim">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57588.Alacak'>*</label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <input type="text" name="claim" id="claim" maxlength="20"  value="0" class="moneybox"  onBlur="sil(1);"onkeyup="return(FormatCurrency(this,event));"> 
                                <span class="input-group-addon"><cfoutput>#session.ep.money#</cfoutput></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-other_money_type">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58121.İşlem Dövizi'></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <input type="text" name="other_money_value" id="other_money_value" maxlength="20"  value="0" class="moneybox"  onkeyup="return(FormatCurrency(this,event));">
                                <span class="input-group-addon width">
                                    <select name="other_money_type" id="other_money_type" style="width:60px;">
                                        <cfoutput query="GET_MONEY_RATE">
                                            <option value="#money#">#money#</option>
                                        </cfoutput>
                                    </select>	
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-action_value_2">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='47485.Sistem 2 Dövizi'></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <input type="text" name="action_value_2" id="action_value_2" maxlength="20" value="0" class="moneybox"  onkeyup="return(FormatCurrency(this,event,2,'float'));">
                                <span class="input-group-addon"><cfif len(session.ep.money2)><cfoutput>#session.ep.money2#</cfoutput></cfif></span>
                            </div>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-12">
                    <cf_workcube_buttons is_upd='0' add_function="kontrol()">
                </div>
            </cf_box_footer>
        </cfform> 
    </cf_box>
</div>
<script type="text/javascript">
	function sil(gelen)
	{
		if( (gelen==0) && (add_ch_open.debt.value.length) && (add_ch_open.claim.value.length) )
		add_ch_open.claim.value = '';
		else if ( (gelen==1) && (add_ch_open.debt.value.length) && (add_ch_open.claim.value.length) )
		add_ch_open.debt.value = '';
	}
	function pencere_ac(r_row)
	{
		hesap_sec();
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_multi_act=1&is_cari_action=1&field_name=add_ch_open.acc_name&field_comp_name=add_ch_open.acc_name&field_consumer=add_ch_open.cons_id&field_emp_id=add_ch_open.emp_id&field_comp_id=add_ch_open.comp_id<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_store_module")>&is_store_module=1</cfif>&select_list=2,3,1,9');
	}
	function kontrol()
	{
		if(!chk_process_cat('add_ch_open')) return false;
		if(!chk_period(document.add_ch_open.open_date,'İşlem')) return false;
		if(!check_display_files('add_ch_open')) return false;
		if((add_ch_open.acc_name.value=='') || (add_ch_open.comp_id.value=='' && add_ch_open.cons_id.value=='' && add_ch_open.emp_id.value==''))
		{
			alert("<cf_get_lang dictionary_id='50081.Lütfen Cari Hesap Seçiniz'> !");
			return false;
		}	
		if((add_ch_open.debt.value=='') && (add_ch_open.claim.value==''))
		{
			alert("<cf_get_lang dictionary_id='57587.Borç'>/<cf_get_lang dictionary_id='57588.Alacak'> <cf_get_lang dictionary_id='58589.Değer Girmelisiniz'>!");
			return false;
		}
		if(((add_ch_open.debt.value=='') || (add_ch_open.debt.value=='0')) && ((add_ch_open.claim.value=='') || (add_ch_open.claim.value=='0')))
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='57587.Borç'>/<cf_get_lang dictionary_id='57588.Alacak'> <cf_get_lang dictionary_id='57989.Ve'> <cf_get_lang dictionary_id='30012.Değer 0 Sıfır Olamaz'>");
			return false;
		}
		if((add_ch_open.other_money_value.value==''))
		{
			alert("<cf_get_lang dictionary_id='50063.İşlem Dövizi Değeri Girmelisiniz'>!");
			return false;
		}	
		if((add_ch_open.action_value_2.value==''))
		{
			alert("<cf_get_lang dictionary_id='50062.Sistem Dövizi Değeri Girmelisiniz'>!");
			return false;
		}	
		add_ch_open.debt.value = filterNum(add_ch_open.debt.value);
		add_ch_open.claim.value = filterNum(add_ch_open.claim.value);
		add_ch_open.other_money_value.value = filterNum(add_ch_open.other_money_value.value);
		add_ch_open.action_value_2.value = filterNum(add_ch_open.action_value_2.value);
		return true;
	}
	function hesap_sec()
	{
		document.add_ch_open.comp_id.value='';
		document.add_ch_open.acc_name.value='';
		document.add_ch_open.emp_id.value='';
		document.add_ch_open.cons_id.value='';
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
