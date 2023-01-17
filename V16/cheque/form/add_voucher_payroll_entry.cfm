<cf_get_lang_set module_name="cheque">
<cfinclude template="../query/get_control.cfm">
<!---<cfinclude template="../query/get_voucher_cashes.cfm">--->
<div id="voucher_payroll_entry_file" style="margin-left:850px; margin-top:15px; position:absolute;display:none;z-index:9999;"></div>
<cf_catalystHeader>
	<cf_box>
<cfform name="form_payroll_basket" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_voucher_payroll_entry">
	<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
	<input type="hidden" name="rev_date" id="rev_date" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">
	<input type="hidden" name="bordro_type" id="bordro_type" value="1">
	<cf_basket_form id="voucher_payroll_entry">
		      <cf_box_elements>
						<div class="col col-4 col-xs-12" sort ="true" type ="column" index="1">
							<div class="form-group" id = "item-process_cat">
				              <label class="col col-4 col-xs-12"><cf_get_lang_main no='388.İşlem'> *</label>
				              <div class="col col-8 col-xs-12">
				                  <cf_workcube_process_cat slxt_width="150">
				              </div>
				            </div>
							<div class="form-group" id = "item-payroll_no">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49747.Bordro No'></label>
								<div class="col col-8 col-xs-12">
									<cfset belge_no = get_cheque_no(belge_tipi:'voucher_payroll')>
									<cfinput type="text" name="payroll_no" value="#belge_no#" required="yes" maxlength="10">
									<cfset belge_no = get_cheque_no(belge_tipi:'voucher_payroll',belge_no:belge_no+1)>
								</div>
							  </div>
							  <div class="form-group" id = "item-payroll_revenue_date">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='330.Tarih'> *</label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfinput value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" required="Yes" type="text" name="payroll_revenue_date" onBlur="change_money_info('form_payroll_basket','payroll_revenue_date');">
										<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="payroll_revenue_date" call_function="change_money_info"></span>
									</div>
								</div>
							  </div>
							  <div class="form-group" id = "item-special_definition">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='1517.Tahsilat Tipi'></label>
								<div class="col col-8 col-xs-12">
									<cf_wrk_special_definition type_info='1' field_id="special_definition_id">
								</div>
							  </div>
						</div>
						<div class="col col-4 col-xs-12" sort ="true" type ="column" index="2">
							<div class="form-group" id = "item-company_id">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='107.cari hesap'> *</label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="company_id" id="company_id" value="">
										<input type="hidden" name="consumer_id" id="consumer_id" value="">
										<input type="hidden" name="employee_id" id="employee_id" value="">
										<input type="hidden" name="member_type" id="member_type" value="">
										<input type="hidden" name="member_code" id="member_code" value="">
										<cfinput type="text" name="company_name" value="" required="yes" onFocus="AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3,9\',\'\',\'\',\'\',\'\',\'\',\'\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE,ACCOUNT_CODE','company_id,consumer_id,employee_id,member_type,member_code','','3','150','get_money_info(\'form_payroll_basket\',\'payroll_revenue_date\')');" autocomplete="off">
										<span class="input-group-addon icon-ellipsis btnPointer" onclick="javascript:windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&field_member_account_code=form_payroll_basket.member_code&select_list=1,2,3,9&field_comp_id=form_payroll_basket.company_id&field_member_name=form_payroll_basket.company_name&field_name=form_payroll_basket.company_name&field_consumer=form_payroll_basket.consumer_id&field_emp_id=form_payroll_basket.employee_id&field_type=form_payroll_basket.member_type<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>','list','popup_list_pars');"></span>
									</div>
								</div>
							  </div>
							  <div class="form-group" id = "item-cash_id">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='108.Kasa'></label>
								<div class="col col-8 col-xs-12">
									  <cf_wrk_Cash name="cash_id" acc_code="1" currency_branch="1" cash_status="1">
								</div>
							  </div>
							<div class="form-group" id = "item-revenue_collector_id">
				              <label class="col col-4 col-xs-12"><cf_get_lang no='38.Tahsil Eden'> *</label>
				              <div class="col col-8 col-xs-12">
								  <div class="input-group">
									  <input type="hidden" name="revenue_collector_id" id="revenue_collector_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
				                      <cfinput type="Text" name="revenue_collector" value="#get_emp_info(session.ep.userid,0,0)#" required="yes" onFocus="AutoComplete_Create('revenue_collector','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','revenue_collector_id','','3','150');">
									  <span class="input-group-addon icon-ellipsis btnPointer"onclick="javascript:windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form_payroll_basket.revenue_collector_id&field_name=form_payroll_basket.revenue_collector<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9','list','popup_list_positions');"></span>
								  </div>
				              </div>
				            </div>
							<div class="form-group" id = "item-project_id">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='4.Proje'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="project_id" id="project_id" value="">
										<input type="text" name="project_name" id="project_name" style="width:150px;" onFocus="AutoComplete_Create('project_name','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" value="" autocomplete="off">
										<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=form_payroll_basket.project_name&project_id=form_payroll_basket.project_id</cfoutput>');"></span>
									</div>
								</div>
							  </div>
						</div>
						<div class="col col-4 col-xs-12" sort ="true" type ="column" index="3">
							<div class="form-group" id = "item-ACTION_DETAIL">
				              <label class="col col-4 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
				              <div class="col col-8 col-xs-12">
								  <textarea name="ACTION_DETAIL" id="ACTION_DETAIL" style="width:150px;height:50px;"></textarea>
				              </div>
				            </div>
							<div class="form-group" id = "item-paymethod_id">
				              <label class="col col-4 col-xs-12"><cf_get_lang_main no='1104.Ödeme Yöntemi'></label>
				              <div class="col col-8 col-xs-12">
								  <div class="input-group">
									  <input type="hidden" name="paymethod_id" id="paymethod_id" value="">
			                          <input type="text" name="paymethod_name" id="paymethod_name" style="width:150px;" value="">
									  <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&is_paymethods=1&field_id=form_payroll_basket.paymethod_id&field_name=form_payroll_basket.paymethod_name</cfoutput>','list');"></span>
								  </div>
				              </div>
				            </div>
                            <div class="form-group" id = "item-contract_id">
				              <label class="col col-4 col-xs-12"><cf_get_lang_main no='1725.Sozlesme'></label>
				              <div class="col col-8 col-xs-12">
								  <div class="input-group">
									  <input type="hidden" name="contract_id" id="contract_id" value="">
				                      <input type="text" name="contract_head" id="contract_head" value="">
									  <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_contract&field_id=form_payroll_basket.contract_id&field_name=form_payroll_basket.contract_head'</cfoutput>,'large');"></span>
								  </div>
				              </div>
				            </div>
                            <cfif session.ep.our_company_info.asset_followup eq 1>
                                <div class="form-group" id = "item-">
                                  <label class="col col-4 col-xs-12"><cf_get_lang_main no ='1421.Fiziki Varlık'></label>
                                  <div class="col col-8 col-xs-12">
                                      <cf_wrkAssetp fieldId='asset_id' fieldName='asset_name' form_name='form_payroll_basket'>
                                  </div>
                                </div>
                            </cfif>
						</div>
					</cf_box_elements>
					<cf_box_footer>
						<cfoutput>
						<input type="button" class="ui-wrk-btn ui-wrk-btn-extra" value="<cf_get_lang no ='134.Senet Ekle'>" onclick="javascript:openBoxDraggable('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_add_voucher');">
						</cfoutput>
						<cf_workcube_buttons is_upd='0' add_function='kontrol_add_voucher()'>
				 </cf_box_footer>
    </cf_basket_form>
    <cf_basket id="voucher_payroll_entry_bask">
			<cfset attributes.rev_date = dateformat(now(),dateformat_style)>
            <cfset attributes.bordro_type = "1">
            <cfinclude template="../display/basket_voucher.cfm">
    </cf_basket>
</cfform>
</cf_box>
<script type="text/javascript">
function open_file()
	{
		document.getElementById("voucher_payroll_entry_file").style.display='';
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=cheque.popup_add_voucher_payroll_entry_file&cash_currency='+ document.getElementById("cash_id").value +'</cfoutput>','voucher_payroll_entry_file',1);
		return false;
	}
function kontrol_add_voucher()
{
	if (!chk_process_cat('form_payroll_basket')) return false;
	if(!check_display_files('form_payroll_basket')) return false;
	if(!chk_period(form_payroll_basket.payroll_revenue_date, 'İşlem')) return false;
	if(document.form_payroll_basket.company_id.value=="" && document.form_payroll_basket.consumer_id.value=="" && document.form_payroll_basket.employee_id.value=="" && document.getElementById('company_name').value!='')
	{
		alert("<cf_get_lang_main no ='2570.Geçerli cari hesap giriniz'>!");
		return false;
	}
	if (document.form_payroll_basket.cash_id[document.form_payroll_basket.cash_id.selectedIndex].value == "")
	{
		alert ("<cf_get_lang no='51.Kasa Seçiniz !'>");
		return false;
	}
	if(document.all.voucher_num.value == 0)
	{
		alert("<cf_get_lang no='134.Senet Ekle!'>");
		return false;
	}
	process=document.form_payroll_basket.process_cat.value;
	var get_process_cat = wrk_safe_query('chq_get_process_cat','dsn3',0,process);
	if(get_process_cat.IS_CHEQUE_BASED_ACTION == 0)
	{
		kontrol_payterm = 0;
		for(ttt=1;ttt<=document.getElementById('record_num').value;ttt++)
			if(eval("document.getElementById('row_kontrol"+ttt+"')").value==1 && eval("document.getElementById('is_pay_term"+ttt+"')").value==1)
			{
				kontrol_payterm = 1;
				break;
			}
		if(kontrol_payterm == 1)
		{
			alert("<cf_get_lang dictionary_id='56487.Ödeme Sözü Ekleyebilmeniz İçin İşlem Tipinde Senet Bazında Carileştirme Seçili Olmalıdır'>!");
			return false;
		}
	}
	if(get_process_cat.IS_ACCOUNT ==1)
	{
		if (document.form_payroll_basket.member_code.value=="")
		{
			alert ("<cf_get_lang no='126.Seçtiğiniz Üyenin Muhasebe Kodu Secilmemiş !'>");
			return false;
		}
	}
	for(kk=1;kk<=document.all.kur_say.value;kk++)
	{
		cheque_rate_change(kk);
	}
	if(toplam(1,0,1)==false)return false;
	return true;
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
