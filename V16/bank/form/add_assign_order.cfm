<cf_xml_page_edit fuseact="bank.popup_assign_order">
<cfinclude template="../query/control_bill_no.cfm">
<cfquery name="get_credit_limits" datasource="#dsn3#">
	SELECT 
		CR.CREDIT_LIMIT_ID, 
		CR.LIMIT_HEAD 
	FROM
		CREDIT_LIMIT CR
</cfquery>
<cfset special_definition_id=''>
<cfset pageHead = #getLang('bank',265)# >
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
    <cf_box>
        <cfform name="add_entry" action="#request.self#?fuseaction=bank.emptypopup_add_assign_order" method="post">
            <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
            <input type="hidden" name="money_type_id" id="money_type_id" value="<cfif isdefined("attributes.money_type") and len(attributes.money_type)><cfoutput>#attributes.money_type#</cfoutput></cfif>">
            <input type="hidden" name="order_id" id="order_id" value="<cfif isdefined("attributes.order_id")><cfoutput>#attributes.order_id#</cfoutput></cfif>">
            <input type="hidden" name="order_row_id" id="order_row_id" value="<cfif isdefined("attributes.order_row_id")><cfoutput>#attributes.order_row_id#</cfoutput></cfif>">
            <input type="hidden" name="correspondence_info" id="correspondence_info" value="<cfif isdefined("attributes.correspondence_info")><cfoutput>#attributes.correspondence_info#</cfoutput></cfif>">
                <cf_box_elements>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-process_cat">
                            <label class="col col-4 col-xs-12"><cfoutput>#getLang('main', 388)#</cfoutput> *</label>
                            <div class="col col-8 col-xs-12">
                                <cf_workcube_process_cat slct_width="250" process_type_info="260">
                            </div>
                        </div>
                        <div class="form-group" id="item-wrkBankAccounts">
                            <label class="col col-4 col-xs-12"><cfoutput>#getLang('bank', 45)#</cfoutput> *</label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrkBankAccounts width='250' call_function='kur_ekle_f_hesapla' control_status='1'>
                            </div>
                        </div>
                        <cfif x_select_branch>
                            <div class="form-group" id="item-wrkDepartmentBranch">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('main', 41)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_wrkDepartmentBranch fieldId='branch_id' is_branch='1' width='250' is_default='1' is_deny_control='1'>
                                </div>
                            </div>
                        </cfif>
                        <div class="form-group" id="item-credit_limit">
                            <label class="col col-4 col-xs-12"><cfoutput>#getLang('main', 1551)#</cfoutput></label>
                            <div class="col col-8 col-xs-12">
                                <select name="credit_limit" id="credit_limit" style="width:250px;">
                                    <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                    <cfoutput query="get_credit_limits">
                                        <option value="#credit_limit_id#">#limit_head#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-company_name">
                            <label class="col col-4 col-xs-12"><cfoutput>#getLang('main', 107)#</cfoutput> *</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfset ch_member_type="">
                                    <input type="hidden" name="company_id"   id="company_id" value="<cfif isdefined("attributes.company_id") and len(attributes.company_id)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
                                    <input type="hidden" name="consumer_id" id="consumer_id"  value="<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
                                    <input type="hidden" name="employee_id" id="employee_id"  value="<cfif isdefined("attributes.employee_id") and len(attributes.employee_id)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
                                    <cfif isdefined("attributes.company_id") and len(attributes.company_id)>
                                        <cfset comp_name=get_par_info(attributes.company_id,1,1,0)>
                                    <cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
                                        <cfset comp_name=get_cons_info(attributes.consumer_id,0,0)>
                                    <cfelseif isdefined("attributes.employee_id") and len(attributes.employee_id)>
                                        <cfset comp_name=get_emp_info(attributes.employee_id,0,0,0)>
                                    <cfelse>
                                        <cfset comp_name="">
                                    </cfif>
                                    <cfinput type="text" name="company_name" id="company_name" onfocus="AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'\',\'\',\'\',\'\',\'\',\'\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID','company_id,consumer_id,employee_id','','3','250','account_load()');" value="#comp_name#">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&select_list=1,2,3&field_comp_id=add_entry.company_id&field_member_name=add_entry.company_name&field_name=add_entry.company_name&field_emp_id=add_entry.employee_id&field_consumer=add_entry.consumer_id&call_function=account_load()</cfoutput>','list');" title="<cfoutput>#getLang('bank', 165)#</cfoutput>"></span>
                                </div>
                            </div>
                        </div>
                        <cfif x_bank_account neq 0>
                            <div class="form-group" id="item-list_bank">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('bank',124)#</cfoutput><cfif x_bank_account eq 2> *</cfif></label>
                                <div class="col col-8 col-xs-12" id="bank_list">
                                    <select name="list_bank" id="list_bank" style="width:250px;">
                                        <option value=""><cf_get_lang dictionary_id="48830.Banka Hesabı Seçmelisiniz"></option>
                                    </select>
                                </div>
                            </div>
                        </cfif>                       
                        <cfif x_select_payment_type neq 0><!--- gösterilsin veya zorunlu durumu --->
                            <div class="form-group" id="item-special_definition_id">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('main', 1516)#</cfoutput><cfif x_select_payment_type eq 2> *</cfif></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_wrk_special_definition selected_value='#special_definition_id#' width_info='150' type_info='2' field_id="special_definition_id">
                                </div>
                            </div>
                        </cfif>
                        <div class="form-group" id="item-project_name">
                            <label class="col col-4 col-xs-12"><cfoutput>#getLang('main', 4)#<cfif x_required_project> *</cfif></cfoutput></label>
                            <div class="col col-8 col-xs-12">
                                <cfif not isDefined("attributes.project_id")><cfset attributes.project_id = ""></cfif>
                                <cf_wrkProject project_Id="#attributes.project_id#" fieldName="project_name" AgreementNo="1" Customer="2" Employee="3" Priority="4" Stage="5" width="150" boxwidth="600" boxheight="400" buttontype="2">
                            </div>
                        </div>
                        <cfif session.ep.our_company_info.asset_followup eq 1>
                            <div class="form-group" id="item-asset_id">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('main', 1421)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_wrkAssetp fieldId='asset_id' fieldName='asset_name' form_name='add_entry' boxwidth="150">
                                </div>
                            </div>
                        </cfif>
                        <div class="form-group" id="item-order_amount">
                            <label class="col col-4 col-xs-12"><cfoutput>#getLang('main', 261)#</cfoutput> *</label>
                            <div class="col col-8 col-xs-12">
                                <cfif isdefined("attributes.order_amount") and len(attributes.order_amount)>
                                    <cfinput type="text" name="ORDER_AMOUNT" class="moneybox" required="yes"  readonly="yes" value="#TLFormat(abs(attributes.order_amount))#" onBlur="kur_ekle_f_hesapla('account_id');" onkeyup="return(FormatCurrency(this,event));">
                                <cfelse>
                                    <cfinput type="text" name="ORDER_AMOUNT" class="moneybox" required="yes" onBlur="kur_ekle_f_hesapla('account_id');" onkeyup="return(FormatCurrency(this,event));">
                                </cfif>	
                            </div>
                        </div>
                        <div class="form-group" id="item-other_cash_act_value">
                            <label class="col col-4 col-xs-12"><cfoutput>#getLang('main', 644)#</cfoutput></label>
                            <div class="col col-8 col-xs-12">
                                <cfif isdefined("attributes.order_amount") and len(attributes.order_amount)>
                                    <cfinput type="text" name="OTHER_CASH_ACT_VALUE" readonly="yes" value="" class="moneybox" onBlur="kur_ekle_f_hesapla('account_id',true);" onkeyup="return(FormatCurrency(this,event));">
                                <cfelse>
                                    <cfinput type="text" name="OTHER_CASH_ACT_VALUE" value="" class="moneybox" onBlur="kur_ekle_f_hesapla('account_id',true);" onkeyup="return(FormatCurrency(this,event));">
                                </cfif>
                            </div>
                        </div>
                        <div class="form-group" id="item-payment_date">
                            <cfif isdefined("attributes.date2") and isdate(attributes.date2)>
                                <cfset payment_date=attributes.date2>
                            <cfelse>
                                <cfset payment_date="#dateformat(now(),dateformat_style)#">
                            </cfif>
                            <label class="col col-4 col-xs-12"><cfoutput>#getLang('main', 1439)#</cfoutput> *</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput value="#payment_date#" required="Yes" type="text" name="PAYMENT_DATE" validate="#validate_style#">
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="PAYMENT_DATE" call_function="change_money_info"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-action_date">
                            <cfif isdefined("attributes.date1") and isdate(attributes.date1)>
                                <cfset actiondate=attributes.date1>
                            <cfelse>
                                <cfset actiondate="#dateformat(now(),dateformat_style)#">
                            </cfif>
                            <label class="col col-4 col-xs-12"><cfoutput>#getLang('main', 467)#</cfoutput> *</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput value="#actiondate#" type="text" name="ACTION_DATE" validate="#validate_style#">
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="ACTION_DATE"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-action-detail">
                            <label class="col col-4 col-xs-12"><cfoutput>#getLang('main', 217)#</cfoutput></label>
                            <div class="col col-8 col-xs-12"><textarea name="ACTION_DETAIL" id="ACTION_DETAIL"></textarea></div>
                        </div>
                        <cfif x_multiple_bank_order>
                            <label class="bold"><cfoutput>#getLang('bank',125)#</cfoutput></label>
                            <div class="form-group" id="item-copy_order_count">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('bank',127)#</cfoutput></label>
                                <div class="col col-8 col-xs-12"><input type="text" name="copy_order_count" id="copy_order_count" value="1" maxlength="3" onkeyup="isNumber(this);" class="moneybox"/></div>
                            </div>
                            <div class="form-group" id="item-due_option">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('bank',128)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="due_option" id="due_option" onChange="kontrol_due_option();">
                                        <option value="1"><cfoutput>#getLang('main',1520)#</cfoutput></option>
                                        <option value="2"><cfoutput>#getLang('main',1045)#</cfoutput></option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-due_day_tr">
                                <label class="col col-4 col-xs-12"><cfoutput>#getLang('bank',129)#</cfoutput></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="due_day" id="due_day" style="width:150px;" onKeyUp="isNumber(this);" maxlength="3" class="moneybox">
                                </div>
                            </div>
                        </cfif>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="false">
                        <div class="form-group">
                            <label class="bold">
                                <cfoutput>#getLang('bank', 53)#</cfoutput>
                            </label>
                        </div>
                        <div class="form-group">
                            <div class="col col-12 scrollContent scroll-x3">
                                <cfscript>f_kur_ekle(process_type:0,base_value:'ORDER_AMOUNT',other_money_value:'OTHER_CASH_ACT_VALUE',form_name:'add_entry',select_input:'account_id');</cfscript>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>              
                <cf_box_footer>
                    <div class="col col-12">
                            <cf_workcube_buttons type_format="1" is_upd='0' add_function="kontrol()">
                    </div>
                </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	function kontrol_due_option()
	{
		if(document.add_entry.due_option.value == 2)
			due_day_tr.style.display='';
		else
			due_day_tr.style.display='none';
	}
	function kontrol()
	{	
		//deger1=list_getat(document.add_entry.account_id.value,2,';');
		deger1 = document.getElementById("currency_id").value;
		if(!chk_process_cat('add_entry')) return false;
		if(!check_display_files('add_entry')) return false;
		if(!chk_period(document.add_entry.ACTION_DATE,'İşlem')) return false;
		if(!acc_control()) return false;
		kur_ekle_f_hesapla('account_id');//dövizli tutarı silinenler için
		if(!$("#company_name").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='48826.Cari Hesap Seçmelisiniz'> !</cfoutput>"})    
			return false;
		}
		
		if(!$("#ORDER_AMOUNT").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='29535.Tutar Girmelisiniz'> !</cfoutput>"})    
			return false;
		}
		
		if(!$("#PAYMENT_DATE").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='48833.Ödeme Tarihi Girmelisiniz'> !</cfoutput>"})    
			return false;
		}
		
		if(!$("#ACTION_DATE").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='57906.İşlem Tarihi Girmelisiniz'> !</cfoutput>"})    
			return false;
		}	
						
						
		if ((document.add_entry.money_type_id.value != '')&&(deger1 != document.add_entry.money_type_id.value))
		{
			if (!confirm("<cf_get_lang dictionary_id='49044.Banka para birimi ödeme emrinin para biriminden farklı'>!"))
			return false;
		}
		<cfif x_bank_account eq 2>
			if(document.getElementById('list_bank').value == '')
			{
				alertObject({message: "<cf_get_lang dictionary_id='48791.Carinin Banka Hesaplarından Birini Seçmelisiniz'>"})
				return false;
			}
		</cfif>
		<cfif x_required_project>
			if(document.getElementById('project_name').value =='')
			{
				alertObject({message: "<cf_get_lang dictionary_id='58797.Proje Seçiniz'>"})
				return false;
			}
		</cfif>
		<cfif x_select_payment_type eq 2>
			if(document.getElementById('special_definition_id').value == '')
			{
				alertObject({message: "<cf_get_lang dictionary_id='50236.Tahsilat Tipi Seçiniz'>"});
				return false;
			}
		</cfif>
		
						
		return true;
	}
	function account_load()
	{
		if(document.getElementById('consumer_id').value!='')
		{	
			var id=document.getElementById('consumer_id').value;
			AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=bank.popup_bank_process_ajax&consumer_id='+id,'bank_list',1,'İlişkili Hesaplar');
		}
		else if(document.getElementById('company_id').value!='')
		{
			var id=document.getElementById('company_id').value;
			AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=bank.popup_bank_process_ajax&company_id='+id,'bank_list',1,'İlişkili Hesaplar');
		}
		else if(document.getElementById('employee_id').value!='')
		{
			var id=document.getElementById('employee_id').value;
			AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=bank.popup_bank_process_ajax&employee_id='+id,'bank_list',1,'İlişkili Hesaplar');
		}
	}
	<cfif isdefined('attributes.consumer_id') || isdefined('attributes.company_id')>
		account_load();
	</cfif>	
	kur_ekle_f_hesapla('account_id');
</script>
