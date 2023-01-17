<cf_catalystHeader>
<cf_get_lang_set module_name="cheque">
<cfinclude template="../query/get_control.cfm">
<!---<cfinclude template="../query/get_cashes.cfm">--->
<cf_box>
<cfform name="form_payroll_revenue" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_voucher_payroll_endor_return">
    <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
    <input type="hidden" name="rev_date" id="rev_date" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">
    <input type="hidden" name="bordro_type" id="bordro_type" value="4,6,9,1">
			<cf_box_elements>
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index = "1" sort="true">
						<div class="form-group" id="item-process_cat">
							<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='61806.İşlem'> *</label>
							<div class="col col-9 col-xs-12">
								<cf_workcube_process_cat slct_width="150">
							</div>
						</div>
						<div class="form-group" id="item-payroll_no">
							<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='50202.Bordro No'></label>
							<div class="col col-9 col-xs-12">
								<cfset belge_no = get_cheque_no(belge_tipi:'voucher_payroll')>
			                    <cfinput type="text" name="payroll_no" value="#belge_no#" required="yes" maxlength="10" >
			                    <cfset belge_no = get_cheque_no(belge_tipi:'voucher_payroll',belge_no:belge_no+1)>
							</div>
						</div>
						<div class="form-group" id="item-payroll_revenue_date">
							<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'> *</label>
							<div class="col col-9 col-xs-12">
								<div class="input-group">
									<cfinput value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" required="Yes" type="text" name="payroll_revenue_date" style="width:150px;" onBlur="change_money_info('form_payroll_revenue','payroll_revenue_date');">
									<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="payroll_revenue_date" call_function="change_money_info"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-pro_employee_id">
							<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58586.İşlem Yapan'> *</label>
							<div class="col col-9 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="pro_employee_id" id="pro_employee_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
					                <cfinput type="text" name="emp_name" value="#get_emp_info(session.ep.userid,0,0)#" required="yes" style="width:150px;" readonly>
									<span class="input-group-addon icon-ellipsis btnPointer"  onclick="javascript:windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=form_payroll_revenue.pro_employee_id&field_name=form_payroll_revenue.emp_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9</cfoutput>','list','popup_list_positions');"></span>
								</div>
							</div>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index = "2" sort="true">
						<div class="form-group" id="item-company_id">
							<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57519.cari Hesap'> *</label>
							<div class="col col-9 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="company_id" id="company_id" value="">
				                    <input type="hidden" name="consumer_id" id="consumer_id" value="">
				                    <input type="hidden" name="employee_id" id="employee_id" value="">
				                    <input type="hidden" name="member_type" id="member_type" value="">
				                    <input type="hidden" name="member_code" id="member_code" value="">
				                    <cfinput type="text" name="company_name" id="company_name" value="" required="yes" style="width:150px;" onFocus="AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3,9\',\'\',\'\',\'\',\'\',\'\',\'\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE,ACCOUNT_CODE','company_id,consumer_id,employee_id,member_type,member_code','','3','150','get_money_info(\'form_payroll_revenue\',\'payroll_revenue_date\')');" autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="javascript:windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&field_member_account_code=form_payroll_revenue.member_code&select_list=1,2,3,9&field_comp_id=form_payroll_revenue.company_id&field_member_name=form_payroll_revenue.company_name&field_name=form_payroll_revenue.company_name&field_consumer=form_payroll_revenue.consumer_id&field_emp_id=form_payroll_revenue.employee_id&field_type=form_payroll_revenue.member_type<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>','list','popup_list_pars');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-cash_id">
							<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57520.Kasa'>*</label>
							<div class="col col-9 col-xs-12">
								<cf_wrk_Cash name="cash_id" currency_branch="1">
							</div>
						</div>
						<div class="form-group" id="item-project_id">
							<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
							<div class="col col-9 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="project_id" id="project_id" value="">
					                <input name="project_name" type="text" id="project_name" style="width:150px;" onFocus="AutoComplete_Create('project_name','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" value="" autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=form_payroll_revenue.project_name&project_id=form_payroll_revenue.project_id</cfoutput>');"></span>
								</div>
							</div>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index = "3" sort = "true">
						<div class="form-group" id="item-ACTION_DETAIL">
							<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
							<div class="col col-9 col-xs-12">
								<textarea name="ACTION_DETAIL" id="ACTION_DETAIL" style="width:150px;height:50px;"></textarea>
							</div>
						</div>
                        <div class="form-group" id="item-special_definition_id">
							<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58929.Tahsilat Tipi'></label>
							<div class="col col-9 col-xs-12">
								<cf_wrk_special_definition width_info='150' type_info='1' field_id="special_definition_id">
							</div>
						</div>
					</div>
				</cf_box_elements>
			<cf_box_footer>
				<input type="button" class="ui-wrk-btn ui-wrk-btn-extra" value="<cf_get_lang dictionary_id='50386.Senet Seç'>" onclick="javascript:senet_sec();">
				<cf_workcube_buttons is_upd='0' add_function='check()'>
			</cf_box_footer>
   <cf_basket id="voucher_payroll_endor_return_bask">
        <cfset attributes.rev_date = dateformat(now(),dateformat_style)>
        <cfset attributes.bordro_type = "4,6,9,1,10">
        <cfset attributes.out = "1">
        <cfset attributes.endor_ret = "1">
        <cfset attributes.out_kontrol = "1">
        <cfinclude template="../display/basket_voucher.cfm">
    </cf_basket>
</cfform>
</cf_box>
<script type="text/javascript">
function check()
{
	if (!chk_process_cat('form_payroll_revenue')) return false;
	if(!check_display_files('form_payroll_revenue')) return false;
	if(!chk_period(form_payroll_revenue.payroll_revenue_date, 'İşlem')) return false;
	if(document.all.voucher_num.value == 0)
	{
		alert("<cf_get_lang dictionary_id='50322.Senet Seçiniz veya Senet Ekleyiniz !'>");
		return false;
	}
	process=document.form_payroll_revenue.process_cat.value;
	var get_process_cat = wrk_safe_query('chq_get_process_cat','dsn3',0,process);
	if(get_process_cat.IS_ACCOUNT ==1)
	{
		if (document.form_payroll_revenue.member_code.value=="")
		{
			alert ("<cf_get_lang dictionary_id='56912.Seçtiğiniz Üyenin Muhasebe Kodu Secilmemiş !'>");
			return false;
		}
	}
	var kontrol_process_date = document.all.kontrol_process_date.value;
	if(kontrol_process_date != '')
	{
		var liste_uzunlugu = list_len(kontrol_process_date);
		for(var str_i_row=1; str_i_row <= liste_uzunlugu; str_i_row++)
			{
				var tarih_ = list_getat(kontrol_process_date,str_i_row,',');
				var sonuc_ = datediff(document.all.payroll_revenue_date.value,tarih_,0);
				if(sonuc_ > 0)
					{
						alert("<cf_get_lang dictionary_id='50208.İşlem Tarihi Seçilen Senetlerin Son İşlem Tarihinden Önce Olamaz'>!");
						return false;
					}
			}
	}
	if(get_process_cat.IS_CHEQUE_BASED_ACTION == 0)
	{
		kontrol_payterm = 0;
		for(ttt=1;ttt<=document.getElementById('record_num').value;ttt++)
			if(document.getElementById('row_kontrol'+ttt).value==1 && document.getElementById('is_pay_term'+ttt).value==1)
			{
				kontrol_payterm = 1;
				break;
			}
		if(kontrol_payterm == 1)
		{
			alert("<cf_get_lang dictionary_id='56457.Ödeme Sözü Seçebilmeniz İçin İşlem Tipinde Senet Bazında Carileştirme Seçili Olmalıdır'>!");
			return false;
		}
		kontrol_status = 0;
		for(ttt=1;ttt<=document.getElementById('record_num').value;ttt++)
			if(document.getElementById('row_kontrol'+ttt).value==1 && document.getElementById('status'+ttt).value==1)
			{
				kontrol_status = 1;
				break;
			}
		if(kontrol_status == 1)
		{
			alert("<cf_get_lang dictionary_id='56462.Kısmi Tahsil Senet Seçebilmeniz İçin İşlem Tipinde Senet Bazında Carileştirme Seçili Olmalıdır'>!");
			return false;
		}
	}
	for(kk=1;kk<=document.all.kur_say.value;kk++)
	{
		cheque_rate_change(kk);
	}
	if(toplam(1,0,1)==false)return false;;
	return true;
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
