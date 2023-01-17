<cf_get_lang_set module_name="cheque">
<cfset xml_page_control_list = 'is_company_select'>
<cf_xml_page_edit page_control_list="#xml_page_control_list#" default_value="1" fuseact="cheque.form_add_payroll_endor_return">
<cfif not isdefined("is_company_select")>
	<cfset is_company_select = 1>
</cfif>
<cfinclude template="../query/get_control.cfm">
<!---<cfinclude template="../query/get_cashes.cfm">--->
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box>
<cfform name="form_payroll_revenue" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_payroll_endor_return">
	<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
	<input type="hidden" name="rev_date" id="rev_date" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">
	<input type="hidden" name="bordro_type" id="bordro_type" value="4,6,9">
	<input type="hidden" name="x_detail_acc_card" id="x_detail_acc_card" value="<cfoutput>#x_detail_acc_card#</cfoutput>">
    <cf_basket_form id="payroll_endor_return">
                <cf_box_elements>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61806.İşlem Tipi'> *</label>
                            <div class="col col-8 col-xs-12">
                                <cf_workcube_process_cat slct_width="150">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33983.Bordro No'></label>
                            <div class="col col-8 col-xs-12">
                                <cfset belge_no = get_cheque_no(belge_tipi:'payroll')>
                                <cfinput type="text" name="payroll_no" value="#belge_no#" required="yes" maxlength="10" >
                                <cfset belge_no = get_cheque_no(belge_tipi:'payroll',belge_no:belge_no+1)>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'>*</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="text" name="payroll_revenue_date" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" required="Yes" onBlur="change_money_info('form_payroll_revenue','payroll_revenue_date');">
                                    <span class="input-group-addon">
                                        <cf_wrk_date_image date_field="payroll_revenue_date" call_function="change_money_info">
                                    </span>
                                </div>
                            </div>
                        </div>
                        <cfif session.ep.our_company_info.asset_followup eq 1>
                            <div class="form-group" id="item-asset_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58833.Fiziki Varlık'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cf_wrkAssetp fieldId='asset_id' fieldName='asset_name' form_name='form_payroll_revenue'>
                                    </div>
                                </div>
                            </div>
                        </cfif>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.cari Hesap'> *</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="company_id" id="company_id" value="">
                                    <input type="hidden" name="consumer_id" id="consumer_id" value="">
                                    <input type="hidden" name="employee_id" id="employee_id" value="">
                                    <input type="hidden" name="member_type" id="member_type" value="">
                                    <input type="hidden" name="member_code" id="member_code" value="">
                                    <cfinput type="text" name="company_name" value="" required="yes" onFocus="AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3,9\',\'\',\'\',\'\',\'\',\'\',\'\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE,ACCOUNT_CODE','company_id,consumer_id,employee_id,member_type,member_code','','3','150','get_money_info(\'form_payroll_revenue\',\'payroll_revenue_date\')');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='57519.cari Hesap'>" onClick="javascript:windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&field_member_account_code=form_payroll_revenue.member_code&select_list=1,2,3,9&field_comp_id=form_payroll_revenue.company_id&field_member_name=form_payroll_revenue.company_name&field_name=form_payroll_revenue.company_name&field_consumer=form_payroll_revenue.consumer_id&field_emp_id=form_payroll_revenue.employee_id&field_type=form_payroll_revenue.member_type<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>','list','popup_list_pars');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57520.Kasa'> *</label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrk_Cash name="cash_id" currency_branch="1" cash_status="1">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58586.İşlem Yapan'>*</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="pro_employee_id" id="pro_employee_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
                                    <cfinput type="text" name="emp_name" value="#get_emp_info(session.ep.userid,0,0)#" required="yes" readonly>
                                    <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='58586.İşlem Yapan'>" onClick="javascript:windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=form_payroll_revenue.pro_employee_id&field_name=form_payroll_revenue.emp_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9</cfoutput>','list','popup_list_positions');"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58929.Tahsilat Tipi'></label>
                            <div class="col col-8 col-xs-12">
                                <cf_wrk_special_definition width_info='150' type_info='1' field_id="special_definition_id">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="Hidden" name="project_id" id="project_id" value="">
                                    <input name="project_name" type="text" id="project_name" style="width:150px;" onFocus="AutoComplete_Create('project_name','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" value="" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='57416.Proje'>" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=form_payroll_revenue.project_name&project_id=form_payroll_revenue.project_id</cfoutput>');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-action_detail">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
                            <div class="col col-8 col-xs-12">
                                <textarea name="ACTION_DETAIL" id="ACTION_DETAIL" style="width:150px;height:50px;"></textarea>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <input type="button" value="<cf_get_lang dictionary_id='49732.Çek Seç'>" class="ui-wrk-btn ui-wrk-btn-extra " onclick="javascript:cek_sec();">
                    <cf_workcube_buttons is_upd='0' add_function='check()'>
                </cf_box_footer>
	</cf_basket_form>
    <cf_basket id="payroll_endor_return_bask">
		<cfset attributes.rev_date = dateformat(now(),dateformat_style)>
        <cfset attributes.bordro_type = '4,6,9'>
        <cfset attributes.endor_ret = 1>
        <cfset attributes.out_kontrol = 1>
        <cfset attributes.out = 1>
        <cfinclude template="../display/basket_cheque.cfm">
   </cf_basket>
</cfform>
<script type="text/javascript">
	function check()
	{
		if (!chk_process_cat('form_payroll_revenue')) return false;
		if(!check_display_files('form_payroll_revenue')) return false;
		if(!chk_period(form_payroll_revenue.payroll_revenue_date, 'İşlem')) return false;
		if(document.all.cheque_num.value == 0)
		{
			alert("<cf_get_lang dictionary_id='50223.Çek Seçiniz veya Çek Ekleyiniz !'>");
			return false;
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
						alert("<cf_get_lang dictionary_id='50207.İşlem Tarihi Seçilen Çeklerin Son İşlem Tarihinden Önce Olamaz'>!");
						return false;
					}
				}
		}
		process=document.form_payroll_revenue.process_cat.value;
		var get_process_cat = wrk_safe_query('chq_get_process_cat','dsn3',0,process);
		if(get_process_cat.IS_ACCOUNT ==1)
		{
			if (document.form_payroll_revenue.member_code.value=="")
			{ 
				alert ("<cf_get_lang dictionary_id='50049.Seçtiğiniz Üyenin Muhasebe Kodu Secilmemiş !'>");
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
