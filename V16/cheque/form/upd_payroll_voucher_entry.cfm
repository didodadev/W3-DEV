<cf_get_lang_set module_name="cheque">
<cfif isnumeric(url.id)>
	<cfquery name="GET_ACTION_DETAIL" datasource="#DSN2#">
		SELECT
			VP.*,
			SC.IS_UPD_CARI_ROW
		FROM
			VOUCHER_PAYROLL VP,
			#dsn3_alias#.SETUP_PROCESS_CAT SC
		WHERE
			VP.ACTION_ID = #url.id# AND
			VP.PAYROLL_TYPE = 97 AND
			SC.PROCESS_CAT_ID = VP.PROCESS_CAT
		<cfif session.ep.isBranchAuthorization>
			AND VP.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">
		</cfif>
	</cfquery>
	<cfquery name="get_pay_vouchers" datasource="#dsn2#">
		SELECT VOUCHER_ID FROM VOUCHER WHERE VOUCHER_PAYROLL_ID = #url.id# AND VOUCHER_STATUS_ID = 3
	</cfquery>
<cfelse>
	<cfset get_action_detail.recordcount = 0>
</cfif>
<cfquery name="CONTROL_VOUCHER_STATUS" datasource="#dsn2#">
	SELECT
		V.VOUCHER_ID
    FROM
        VOUCHER V
        LEFT JOIN VOUCHER_HISTORY VH ON VH.VOUCHER_ID = V.VOUCHER_ID
    WHERE
        VH.PAYROLL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
        AND ISNULL((SELECT TOP 1 PAYROLL_ID FROM VOUCHER_HISTORY VH2 WHERE VH2.VOUCHER_ID = V.VOUCHER_ID ORDER BY HISTORY_ID DESC),0) <> <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
</cfquery>
<cf_box>
<cfif not get_action_detail.recordcount>
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'> <cf_get_lang_main no='592.Böyle Bir Senet Bulunamadı'> !</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
	<cfinclude template="../query/get_voucher_cashes.cfm">
	<cf_catalystHeader>

 	<cfform name="form_payroll_basket" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_payroll_voucher_entry">
    <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
    <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
    <input type="hidden" name="payroll_acc_cari_voucher_based" id="payroll_acc_cari_voucher_based" value="<cfoutput>#GET_ACTION_DETAIL.VOUCHER_BASED_ACC_CARI#</cfoutput>">
    <input type="hidden" name="rev_date" id="rev_date" value="<cfoutput>#dateformat(get_action_detail.payroll_revenue_date,dateformat_style)#</cfoutput>">
	<input type="hidden" name="bordro_type" id="bordro_type" value="1">
<cf_box_elements>
    <cf_basket_form id="payroll_voucher_entry">
		<div class="row">
			<div class="col col-12">
				<div class="row formContent">
					<div class="row" type="row">
						<div class="col col-4 col-xs-12" sort ="true" type ="column" index="1">
							<div class="form-group" id = "item-process_cat">
				              <label class="col col-3 col-xs-12"><cf_get_lang_main no='388.İşlem'> *</label>
				              <div class="col col-9 col-xs-12">
				                  <cf_workcube_process_cat slct_width="150" process_cat=#get_action_detail.process_cat#>
				              </div>
				            </div>
							<div class="form-group" id = "item-payroll_no">
				              <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='49747.Bordro No'></label>
				              <div class="col col-9 col-xs-12">
			                      <cfinput type="text" name="payroll_no" value="#get_action_detail.PAYROLL_NO#" required="yes" maxlength="10">
				              </div>
				            </div>
							<div class="form-group" id = "item-payroll_revenue_date">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no='330.Tarih'> *</label>
								<div class="col col-9 col-xs-12">
									<cfif control_voucher_status.recordcount eq 0>
											<cfif not(get_action_detail.is_upd_cari_row eq 1 and get_pay_vouchers.recordcount)>
											  <div class="input-group">
												  <cfinput value="#dateformat(GET_ACTION_DETAIL.payroll_revenue_date,dateformat_style)#" required="Yes" readonly type="text" name="payroll_revenue_date" validate="#validate_style#" onBlur="change_money_info('form_payroll_basket','payroll_revenue_date');">
												  <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="payroll_revenue_date" call_function="change_money_info" control_date="#dateformat(GET_ACTION_DETAIL.payroll_revenue_date,dateformat_style)#"></span>
											  </div>
										  </cfif>
									  <cfelse>
										  <cfinput value="#dateformat(GET_ACTION_DETAIL.payroll_revenue_date,dateformat_style)#" required="Yes" readonly type="text" name="payroll_revenue_date" validate="#validate_style#" onBlur="change_money_info('form_payroll_basket','payroll_revenue_date');">
									  </cfif>
								</div>
							  </div>
							  <div class="form-group" id = "item-special_definition">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no='1517.Tahsilat Tipi'></label>
								<div class="col col-9 col-xs-12">
									<cf_wrk_special_definition type_info='1' field_id="special_definition_id" selected_value='#get_action_detail.special_definition_id#'>
								</div>
							  </div>
						</div>
						<div class="col col-4 col-xs-12" sort ="true" type ="column" index="2">
							<div class="form-group" id = "item-company_id">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no='107.Cari Hesap'> *</label>
								<div class="col col-9 col-xs-12">
										<cfif control_voucher_status.recordcount eq 0>
											<div class="input-group">
										</cfif >
										<cfset emp_id = get_action_detail.employee_id>
										<cfif len(get_action_detail.acc_type_id)>
											<cfset emp_id = "#emp_id#_#get_action_detail.acc_type_id#">
										</cfif>
										<cfif len(get_action_detail.company_id)>
											<cfset member_name=get_par_info(get_action_detail.company_id,1,1,0)>
											<cfset member_type="partner">
										<cfelseif len(get_action_detail.consumer_id)>
											<cfset member_name=get_cons_info(get_action_detail.consumer_id,0,0)>
											<cfset member_type="consumer">
										<cfelseif len(get_action_detail.employee_id)>
											<cfset member_name=get_emp_info(get_action_detail.employee_id,0,0,0,get_action_detail.acc_type_id)>
											<cfset member_type="employee">
										</cfif>
										<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_action_detail.company_id#</cfoutput>">
										  <input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#get_action_detail.consumer_id#</cfoutput>">
										<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#emp_id#</cfoutput>">
										  <input type="hidden" name="member_type" id="member_type" value="<cfoutput>#member_type#</cfoutput>">
										<cfinput type="text" name="company_name" value="#member_name#" style="width:150px;" readonly required="yes" autocomplete="off">
										<cfif control_voucher_status.recordcount eq 0>
										  <span class="input-group-addon icon-ellipsis btnPointer" onclick="javascript:windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_cari_action=1&select_list=1,2,3,9&field_comp_id=form_payroll_basket.company_id&field_member_name=form_payroll_basket.company_name&field_name=form_payroll_basket.company_name&field_consumer=form_payroll_basket.consumer_id&field_emp_id=form_payroll_basket.employee_id&field_type=form_payroll_basket.member_type<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','list','popup_list_pars');"></span>
										</cfif>
										<cfif control_voucher_status.recordcount eq 0>
									</div>
									</cfif>
								</div>
							  </div>
							  <div class="form-group" id = "item-cash_id">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no='108.Kasa'></label>
								<div class="col col-9 col-xs-12">
									<cfif control_voucher_status.recordcount> <!--- İşlem görmüş senet varsa kasa değiştirilemez --->
										<cf_wrk_Cash name="cash_id" cash_id="#get_action_detail.payroll_cash_id#" currency_branch="1">
									<cfelse>
										<cf_wrk_Cash name="cash_id" value="#get_action_detail.payroll_cash_id#" cash_id="#get_action_detail.payroll_cash_id#" currency_branch="1">
									</cfif>
								</div>
							  </div>
							  <div class="form-group" id = "item-revenue_collector_id">
								<label class="col col-3 col-xs-12"><cf_get_lang no='38.Tahsil Eden'>*</label>
								<div class="col col-9 col-xs-12">
									<div class="input-group">
										  <input type="Hidden" name="revenue_collector_id" id="revenue_collector_id" value="<cfoutput>#get_action_detail.revenue_collector_id#</cfoutput>">
										<cfsavecontent variable="message"><cf_get_lang no='62.Tahsil Edeni Girmelisiniz !'></cfsavecontent>
										<cfinput type="Text" name="revenue_collector" message="#message#" value="#get_emp_info(get_action_detail.revenue_collector_id,0,0)#" required="yes" style="width:150px;">
										<span class="input-group-addon icon-ellipsis btnPointer" onclick="javascript:windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form_payroll_basket.revenue_collector_id&field_name=form_payroll_basket.revenue_collector<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9','list','popup_list_positions');"></span>
									</div>
								</div>
							  </div>
							<div class="form-group" id = "item-project_id">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no='4.Proje'></label>
								<div class="col col-9 col-xs-12">
									<div class="input-group">
										<cfif len(get_action_detail.project_id)>
											<cfquery name="get_project_name" datasource="#dsn#">
												SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #get_action_detail.project_id#
											</cfquery>
										</cfif>
										  <input type="hidden" name="project_id" id="project_id" value="<cfoutput>#get_action_detail.project_id#</cfoutput>">
										  <input type="text" name="project_name" id="project_name" value="<cfif len(get_action_detail.project_id)><cfoutput>#get_project_name.project_head#</cfoutput></cfif>" style="width:150px;" onFocus="AutoComplete_Create('project_name','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
										  <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=form_payroll_basket.project_name&project_id=form_payroll_basket.project_id</cfoutput>');"></span>
									</div>
								</div>
							  </div>
						</div>
						<div class="col col-4 col-xs-12" sort ="true" type ="column" index="3">
							<div class="form-group" id = "item-ACTION_DETAIL">
				              <label class="col col-3 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
				              <div class="col col-9 col-xs-12">
								  <textarea name="ACTION_DETAIL" id="ACTION_DETAIL" style="width:150px;height:50px;"><cfoutput>#get_action_detail.action_detail#</cfoutput></textarea>
				              </div>
				            </div>
							<div class="form-group" id = "item-paymethod_id">
                            	<cfif len(get_action_detail.paymethod_id)>
                                    <cfquery name="GET_PAY_METHOD" datasource="#DSN#">
                                        SELECT PAYMETHOD FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = #get_action_detail.paymethod_id#
                                    </cfquery>
                                    <cfset paymethod_name_ = get_pay_method.paymethod>
                                <cfelse>
                                    <cfset paymethod_name_= ''>
                                </cfif>
							  <label class="col col-3 col-xs-12"><cf_get_lang_main no='1104.Ödeme Yöntemi'></label>
							  <div class="col col-9 col-xs-12">
								  <div class="input-group">
									  <input type="hidden" name="paymethod_id" id="paymethod_id" value="<cfif len(get_action_detail.paymethod_id)><cfoutput>#get_action_detail.paymethod_id#</cfoutput></cfif>">
									  <input type="text" name="paymethod_name" id="paymethod_name" style="width:150px;" value="<cfoutput>#paymethod_name_#</cfoutput>">
									  <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&is_paymethods=1&field_id=form_payroll_basket.paymethod_id&field_name=form_payroll_basket.paymethod_name</cfoutput>','list');"></span>
								  </div>
							  </div>
							</div>
							<div class="form-group" id = "item-contract_id">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no='1725.Sozlesme'></label>
								<div class="col col-9 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="contract_id" id="contract_id" value="<cfoutput>#get_action_detail.contract_id#</cfoutput>">
										<cfif len(get_action_detail.contract_id)>
											  <cfquery name="get_contract_head" datasource="#dsn3#">
												  SELECT CONTRACT_ID,CONTRACT_HEAD FROM RELATED_CONTRACT WHERE CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_action_detail.contract_id#">
											  </cfquery>
										  </cfif>
										  <input type="text" name="contract_head" id="contract_head" value="<cfif len(get_action_detail.contract_id)><cfoutput>#get_contract_head.contract_head#</cfoutput></cfif>" style="width:150px;">
											<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_contract&field_id=form_payroll_basket.contract_id&field_name=form_payroll_basket.contract_head'</cfoutput>,'large');"></span>
									</div>
								</div>
							  </div>
                            <cfif session.ep.our_company_info.asset_followup eq 1>
								<div class="form-group" id="item-asset_id">
									<label class="col col-3 col-xs-12"><cf_get_lang_main no ='1421.Fiziki Varlık'></label>
									<div class="col col-9 col-xs-12">
										<cf_wrkAssetp asset_id='#get_action_detail.assetp_id#' fieldId='asset_id' fieldName='asset_name' form_name='form_payroll_basket'>
									</div>
								</div>
			                </cfif>
						</div>
					</div>
                     <cf_box_footer>
                            <cf_record_info query_name="get_action_detail">
							<cfoutput>
								<input type="button" class="ui-wrk-btn ui-wrk-btn-extra" value="<cf_get_lang no ='134.Senet Ekle'>" onclick="javascript:openBoxDraggable('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_add_voucher');">
								</cfoutput>
                            <cf_workcube_buttons is_upd='1'
                                del_function_for_submit='delete_action()'
                                update_status='#get_action_detail.UPD_STATUS#'
                                delete_page_url='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.del_voucher_payroll&id=#url.id#&head=#get_action_detail.PAYROLL_NO#'
                                add_function='check()'>
								<cfif control_voucher_status.recordcount>
									<div class="col col-12 col-xs-12">
										<font color="##FF0000" style=" padding: 3px; line-height: 20px;"><cf_get_lang dictionary_id="56603.İşlem Görmüş Senetler Var. Cari Hesap, Kasa, Tutar ve Tarih Güncellenemez">!</font>
									</div>
								</cfif>
					</cf_box_footer>
				</div>
			</div>
		</div>
    </cf_basket_form>
</cf_box_elements>	
    <cf_basket id="payroll_voucher_entry_bask">
		<cfset attributes.rev_date = dateformat(get_action_detail.payroll_revenue_date,dateformat_style)>
        <cfset attributes.bordro_type = "1">
        <cfif get_action_detail.is_upd_cari_row eq 1 and get_pay_vouchers.recordcount gt 0>
            <cfset rate_readonly_info = 1>
        </cfif>
        <cfinclude template="../display/basket_voucher.cfm">
    </cf_basket>
 </cfform>
</cfif>
</cf_box>
<script type="text/javascript">
	function delete_action()
	{
		if (!chk_period(form_payroll_basket.payroll_revenue_date, 'İşlem')) return false;
		if (document.all.del_flag.value != 0)
		{
			alert("<cf_get_lang no='61.İşlem Görmüş Senetler Var, Bordroyu Silemezsiniz !'>");
			return false;
		}
		return control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.payroll_type#'</cfoutput>);
	}
	function check()
	{
		if (!chk_process_cat('form_payroll_basket')) return false;
		if(!check_display_files('form_payroll_basket')) return false;
		if (!chk_period(form_payroll_basket.payroll_revenue_date, 'İşlem')) return false;
		if (document.form_payroll_basket.cash_id[document.form_payroll_basket.cash_id.selectedIndex].value == "")
		{
			alert ("<cf_get_lang no='51.Kasa Seçiniz !'>");
			return false;
		}
		if(document.all.voucher_num.value == 0)
		{
			alert("<cf_get_lang no='127.Senet Seçiniz veya Senet Ekleyiniz !'>");
			return false;
		}
		process=document.form_payroll_basket.process_cat.value;
		var get_process_cat = wrk_safe_query('chq_get_process_cat','dsn3',0,process);
		if(get_process_cat.IS_CHEQUE_BASED_ACTION == 0)
		{
			kontrol_payterm = 0;
			for(ttt=1;ttt<=document.getElementById('record_num').value;ttt++)
				if(document.getElementById('row_kontrol'+ttt).value==1 &&  document.getElementById('is_pay_term'+ttt) != undefined && document.getElementById('is_pay_term'+ttt).value==1)
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
		for(kk=1;kk<=document.all.kur_say.value;kk++)
		{
			cheque_rate_change(kk);
		}
		if(toplam(1,0,1)==false)return false;;
		return control_account_process(<cfoutput>'#attributes.id#','#get_action_detail.payroll_type#'</cfoutput>);
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
