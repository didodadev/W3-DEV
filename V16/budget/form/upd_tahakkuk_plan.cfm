<cf_get_lang_set module_name="budget">
<!--- Sevim Çelik : Tahakkuk işlemleri güncelleme sayfası --->
<cfquery name="get_tahakkuk_plan" datasource="#dsn3#">
	SELECT
		*
	FROM
		TAHAKKUK_PLAN
	WHERE
		TAHAKKUK_PLAN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.tplan_id#">
</cfquery>
<cfif not get_tahakkuk_plan.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='62940.Tahakkuk Kaydı Bulunamadı'> !");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfquery name="get_tahakkuk_plan_row" datasource="#dsn3#">
	SELECT
		*,
		ISNULL(IS_PROCESS,0) IS_PROCESS_INFO
	FROM
		TAHAKKUK_PLAN_ROW
	WHERE
		TAHAKKUK_PLAN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.tplan_id#">
	ORDER BY
		TAHAKKUK_PLAN_ROW_ID
</cfquery>
<cfset is_processed = 0>
<cfif get_tahakkuk_plan_row.recordcount>
	<cfquery name="get_tahakkuk_plan_row_kontrol" dbtype="query">
		SELECT * FROM get_tahakkuk_plan_row WHERE IS_PROCESS_INFO = 1 AND WRK_ROW_RELATION_ID IS NOT NULL
	</cfquery>
	<cfif get_tahakkuk_plan_row_kontrol.recordcount>
		<cfset is_processed = 1>
	</cfif>
</cfif>
<cfquery name="get_money" datasource="#dsn3#">
	SELECT MONEY_TYPE AS MONEY,* FROM TAHAKKUK_PLAN_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.tplan_id#">
</cfquery>
<cfif not get_money.recordcount>
	<cfquery name="get_money" datasource="#dsn2#">
		SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY ORDER BY MONEY_ID
	</cfquery>
</cfif>
<cfquery name="get_expense_center" datasource="#dsn2#">
	SELECT EXPENSE_ID,EXPENSE FROM EXPENSE_CENTER ORDER BY EXPENSE
</cfquery>
<cfquery name="get_tax" datasource="#dsn2#">
	SELECT * FROM SETUP_TAX ORDER BY TAX
</cfquery>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="upd_tahakkuk_plan" method="post" action="#request.self#?fuseaction=budget.emptypopup_upd_tahakkuk_plan" enctype="multipart/form-data">
			<cf_basket_form id="budget_plan">
				<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
				<input type="hidden" name="wrk_id" id="wrk_id" value="<cfoutput>#get_tahakkuk_plan.wrk_id#</cfoutput>">
				<input type="hidden" name="tplan_id" id="tplan_id" value="<cfoutput>#attributes.tplan_id#</cfoutput>">
				<input type="hidden" name="old_pay_method" id="old_pay_method" value="<cfoutput>#get_tahakkuk_plan.PAYMETHOD_ID#</cfoutput>">
				<input type="hidden" name="invoice_cari_action_type" id="invoice_cari_action_type" value="<cfif len(get_tahakkuk_plan.CARI_ACTION_TYPE)><cfoutput>#get_tahakkuk_plan.CARI_ACTION_TYPE#</cfoutput></cfif>">
				<input type="hidden" name="invoice_payment_plan" id="invoice_payment_plan" value="1">
				<cf_box_elements>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-process_cat">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.Islem Tipi'> *</label>
							<div class="col col-8 col-xs-12">
								<cf_workcube_process_cat slct_width="150" form_name="upd_tahakkuk_plan" process_cat='#get_tahakkuk_plan.process_cat#' process_type_info='#get_tahakkuk_plan.process_type#'>					
							</div>
						</div>
						<div class="form-group" id="item-ch_member_type">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfoutput>
										<cfset emp_id = get_tahakkuk_plan.employee_id>
										<cfif len(get_tahakkuk_plan.company_id)>
											<cfset ch_member_type="partner">
										<cfelseif len(get_tahakkuk_plan.consumer_id)>
											<cfset ch_member_type="consumer">
										<cfelseif len(get_tahakkuk_plan.employee_id)>
											<cfset ch_member_type="employee">
										<cfelse>
											<cfset ch_member_type="">
										</cfif>
										<input type="hidden" name="ch_member_type" id="ch_member_type" value="#ch_member_type#">
										<input type="hidden" name="ch_company_id" id="ch_company_id" value="#get_tahakkuk_plan.company_id#">
										<input type="hidden" name="ch_partner_id" id="ch_partner_id" value="<cfif ch_member_type eq "partner">#get_tahakkuk_plan.partner_id#<cfelseif ch_member_type eq "consumer">#get_tahakkuk_plan.consumer_id#</cfif>">
										<input type="hidden" name="emp_id" id="emp_id" value="#emp_id#">
										<input type="hidden" name="ch_partner" id="ch_partner" value="<cfif ch_member_type eq 'partner'>#get_par_info(get_tahakkuk_plan.partner_id,0,-1,0)#<cfelseif ch_member_type eq 'consumer'>#get_cons_info(get_tahakkuk_plan.consumer_id,0,0)#<cfelseif ch_member_type eq 'employee'>#get_emp_info(get_tahakkuk_plan.employee_id,0,0,0)#</cfif>">
										<input type="text" name="ch_company" id="ch_company" onfocus="AutoComplete_Create('ch_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'\',\'\',\'\',\'\',\'\',\'\',\'1\'','MEMBER_TYPE,COMPANY_ID,PARTNER_CODE,EMPLOYEE_ID,MEMBER_PARTNER_NAME','ch_member_type,ch_company_id,ch_partner_id,emp_id,ch_partner','','3','250','get_money_info(\'upd_tahakkuk_plan\',\'expense_date\');');" autocomplete="off" value="<cfif ch_member_type eq 'partner'>#get_par_info(get_tahakkuk_plan.company_id,1,1,0)#<cfelseif ch_member_type eq 'consumer'>#get_cons_info(get_tahakkuk_plan.consumer_id,2,0)#</cfif>">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_pars&field_id=upd_tahakkuk_plan.ch_partner_id&field_comp_name=upd_tahakkuk_plan.ch_company&field_name=upd_tahakkuk_plan.ch_partner&field_comp_id=upd_tahakkuk_plan.ch_company_id&field_type=upd_tahakkuk_plan.ch_member_type&field_emp_id=upd_tahakkuk_plan.emp_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,2,3,9');"></span>
									</cfoutput>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-start_date">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57655.Başlama Tarihi'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfinput name="start_date" id="start_date" type="text" validate="#validate_style#" required="no" value="#dateformat(get_tahakkuk_plan.start_date,dateformat_style)#" onblur="change_money_info('upd_tahakkuk_plan','start_date');">
									<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="start_date" call_function="change_money_info"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-finish_date">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfinput name="finish_date" id="finish_date" type="text" validate="#validate_style#" required="no" value="#dateformat(get_tahakkuk_plan.finish_date,dateformat_style)#">
									<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finish_date"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-total">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29534.Toplam Tutar'></label>
							<div class="col col-8 col-xs-12">
								<input type="hidden" name="net_total_system" id="net_total_system" value="">
								<input type="text" name="net_total" id="net_total" value="<cfoutput>#tlformat(get_tahakkuk_plan.EXPENSE_TOTAL)#</cfoutput>" onkeyup="return(FormatCurrency(this,event,2));">
							</div>
						</div>
						<div class="form-group" id="item-paymethod">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58516.Ödeme Yöntem'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfif len(get_tahakkuk_plan.paymethod_id)>
										<cfquery name="GET_PAYMETHOD" datasource="#DSN#">
											SELECT PAYMETHOD,PAYMETHOD_ID,PAYMENT_VEHICLE,DUE_DAY FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_tahakkuk_plan.paymethod_id#">
										</cfquery>
										<input type="hidden" name="paymethod_id" id="paymethod_id" value="<cfoutput>#get_tahakkuk_plan.paymethod_id#</cfoutput>">
										<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
										<input type="hidden" name="commission_rate" id="commission_rate" value="">
										<input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="<cfoutput>#get_paymethod.payment_vehicle#</cfoutput>"> <!--- Ödeme aracını tutuyor --->
										<input type="text" name="paymethod" id="paymethod"  value="<cfoutput>#get_paymethod.paymethod#</cfoutput>">
									<cfelseif len(get_tahakkuk_plan.card_paymethod_id)>
										<cfquery name="get_card_paymethod" datasource="#dsn3#">
											SELECT 
												CARD_NO
												,COMMISSION_MULTIPLIER
											FROM 
												CREDITCARD_PAYMENT_TYPE 
											WHERE 
												PAYMENT_TYPE_ID=#get_tahakkuk_plan.card_paymethod_id#
										</cfquery>
										<cfoutput>
											<input type="hidden" name="paymethod_id" id="paymethod_id" value="">
											<input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="-1"> 
											<input type="text" name="paymethod" id="paymethod" value="#get_card_paymethod.card_no#" style="width:135px;">
											<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="#get_tahakkuk_plan.card_paymethod_id#">
											<input type="hidden" name="commission_rate" id="commission_rate" value="#get_card_paymethod.commission_multiplier#">
										</cfoutput>
									<cfelse>
										<input type="hidden" name="paymethod_id" id="paymethod_id" value="">
										<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
										<input type="hidden" name="commission_rate" id="commission_rate" value="">
										<input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="">
										<input type="text" name="paymethod" id="paymethod" value="">
									</cfif>
									<cfset card_link="&field_card_payment_id=upd_tahakkuk_plan.card_paymethod_id&field_card_payment_name=upd_tahakkuk_plan.paymethod&field_commission_rate=upd_tahakkuk_plan.commission_rate&field_paymethod_vehicle=upd_tahakkuk_plan.paymethod_vehicle">
									<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&function_name=change_paper_duedate&function_parameter=start_date&field_dueday=upd_tahakkuk_plan.due_value&field_id=upd_tahakkuk_plan.paymethod_id&field_name=upd_tahakkuk_plan.paymethod#card_link#</cfoutput>','list');"></span>
								</div>	
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-paper_number">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57880.Belge No'> *</label>
							<div class="col col-8 col-xs-12">
								<cfinput type="text" name="paper_number" id="paper_number" value="#get_tahakkuk_plan.paper_no#" maxlength="40" style="width:80px;" readonly>
							</div>
						</div>                        
						<div class="form-group" id="item-project_head">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfoutput>
									<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('get_tahakkuk_plan.project_id')>#get_tahakkuk_plan.project_id#</cfif>">
									<input type="text" name="project_head" id="project_head" value="<cfif isdefined('get_tahakkuk_plan.project_id') and len(get_tahakkuk_plan.project_id)>#GET_PROJECT_NAME(get_tahakkuk_plan.project_id)#</cfif>" 
									onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','upd_tahakkuk_plan','3','135')" autocomplete="off">
									<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=upd_tahakkuk_plan.project_id&project_head=upd_tahakkuk_plan.project_head');"></span>
									</cfoutput>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-asset_id">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58833.Fiziki Varlık'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfoutput>
									<cfset assetp_id_ = "">
									<cfset assetp_name_ = "">
									<cfif len(get_tahakkuk_plan.assetp_id)>
										<cfset assetp_id_ = get_tahakkuk_plan.assetp_id>
										<cfquery name="get_pyschical_asset" datasource="#dsn#">
											SELECT ASSETP_ID, ASSETP FROM ASSET_P WHERE ASSETP_ID IN (#assetp_id_#) ORDER BY ASSETP_ID
										</cfquery>
										<cfif get_pyschical_asset.recordcount>
											<cfset assetp_name_ = get_pyschical_asset.ASSETP>
										</cfif>
									</cfif>
									<input type="hidden" name="assetp_id" id="assetp_id" value="#assetp_id_#">
									<input type="text" name="assetp_name" id="assetp_name" style="width:105px;" onFocus="autocomp_assetp();" value="#assetp_name_#" class="boxtext" autocomplete="off">
									<span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac_assetp();"></span>
									<!--- <cf_wrkAssetp fieldId='asset_id' fieldName='asset_name' form_name='upd_tahakkuk_plan'> --->
									</cfoutput>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-detail">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
							<div class="col col-8 col-xs-12">
								<textarea name="detail" id="detail"><cfif isdefined("get_tahakkuk_plan.detail")><cfoutput>#get_tahakkuk_plan.detail#</cfoutput></cfif></textarea>
							</div>
						</div>
						<div class="form-group" id="item-due_date">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57640.Vade'> / <cf_get_lang dictionary_id='57742.Tarih'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input name="due_value" id="due_value" type="text" value="<cfif len(get_tahakkuk_plan.due_date) and len(get_tahakkuk_plan.start_date)><cfoutput>#datediff('d',get_tahakkuk_plan.start_date,get_tahakkuk_plan.due_date)#</cfoutput></cfif>"onchange="change_paper_duedate('start_date');" style="width:43px;">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57338.Vade Tarihi İçin Geçerli Bir Format Giriniz'> !</cfsavecontent>
									<span class="input-group-addon no-bg"></span>
									<cfinput type="text" name="due_date" id="due_date" value="#dateformat(get_tahakkuk_plan.due_date,dateformat_style)#" onChange="change_paper_duedate('start_date',1);" validate="#validate_style#" message="#message#" maxlength="10" style="width:90px;" readonly>
									<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="due_date" id="due_date_image"></span>
								</div>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
						<div class="form-group" id="item-expense_center">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfoutput>
									<cfset expense_center_id_ = "">
									<cfset expense_center_ = "">
									<cfif len(get_tahakkuk_plan.expense_center_id)>
										<cfset expense_center_id_ = get_tahakkuk_plan.expense_center_id>
										<cfquery name="get_expense_center" datasource="#dsn2#">
											SELECT EXPENSE_ID, EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID IN (#expense_center_id_#) ORDER BY EXPENSE_ID
										</cfquery>
										<cfif get_expense_center.recordcount>
											<cfset expense_center_ = get_expense_center.EXPENSE>
										</cfif>
									</cfif>
									<input type="hidden" name="expense_center_id" id="expense_center_id" value="#expense_center_id_#">
									<cfinput type="text" name="expense_center" value="#expense_center_#" style="width:175px;">
									<span class="input-group-addon icon-ellipsis" onClick="open_exp_center();"></span>
									</cfoutput>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-expense_item_id">
							<cfoutput>
								<cfset month_expense_item_id_ = "">
								<cfset month_expense_item_name_ = "">
								<cfset month_account_code_ = get_tahakkuk_plan.month_account_code>
								<cfif len(get_tahakkuk_plan.month_expense_item_id)>
									<cfset month_expense_item_id_ = get_tahakkuk_plan.month_expense_item_id>
									<cfquery name="get_expense_item" datasource="#dsn2#">
										SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME,ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID IN (#month_expense_item_id_#) ORDER BY EXPENSE_ITEM_ID
									</cfquery>
									<cfif get_expense_item.recordcount>
										<cfset month_expense_item_name_ = get_expense_item.EXPENSE_ITEM_NAME>
										<cfif not len(month_account_code_)>
											<cfset month_account_code_ = get_expense_item.ACCOUNT_CODE>
										</cfif>
									</cfif>
								</cfif>
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='62917.Gelecek Aylara Ait Gider Kalemi'></label>
								<div class="col col-4 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="month_expense_item_id" id="month_expense_item_id" value="#month_expense_item_id_#">
										<cfinput type="text" name="month_expense_item_name" value="#month_expense_item_name_#" style="width:175px;">
										<span class="input-group-addon icon-ellipsis" onClick="open_exp_item('1');" title=""></span>							
									</div>
								</div>
								<div class="col col-4 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="month_account_id" id="month_account_id" value="#month_account_code_#">
										<input type="text" name="month_account_code" id="month_account_code" onFocus="AutoComplete_Create('month_account_code','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','','ACCOUNT_CODE','month_account_id','','3','225');" value="#month_account_code_#">
										<span class="input-group-addon icon-ellipsis" onClick="open_acc_code('1');" title=""></span>
									</div>
								</div>
							</cfoutput>
							<!--- "AutoComplete_Create('month_account_code','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','','','','3','225');" --->
						</div>
						<div class="form-group" id="item-expense_item_id2">
							<cfoutput>
								<cfset year_expense_item_id_ = "">
								<cfset year_expense_item_name_ = "">
								<cfset year_account_code_ = get_tahakkuk_plan.year_account_code>
								<cfif len(get_tahakkuk_plan.month_expense_item_id)>
									<cfset year_expense_item_id_ = get_tahakkuk_plan.month_expense_item_id>
									<cfquery name="get_expense_item" datasource="#dsn2#">
										SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME,ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID IN (#year_expense_item_id_#) ORDER BY EXPENSE_ITEM_ID
									</cfquery>
									<cfif get_expense_item.recordcount>
										<cfset year_expense_item_name_ = get_expense_item.EXPENSE_ITEM_NAME>
										<cfif not len(year_account_code_)>
											<cfset year_account_code_ = get_expense_item.ACCOUNT_CODE>
										</cfif>
									</cfif>
								</cfif>
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='62918.Gelecek Yıllara Ait Gider Kalemi'></label>
								<div class="col col-4 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="year_expense_item_id" id="year_expense_item_id" value="#year_expense_item_id_#">
										<cfinput type="text" name="year_expense_item_name" value="#year_expense_item_name_#" style="width:175px;">
										<span class="input-group-addon icon-ellipsis" onClick="open_exp_item('2');" title=""></span>							
									</div>
								</div>
								<div class="col col-4 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="year_account_id" id="year_account_id" value="#year_account_code_#">
										<input type="text" name="year_account_code" id="year_account_code" onFocus="AutoComplete_Create('year_account_code','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','','ACCOUNT_CODE','year_account_id','','3','225');" value="#year_account_code_#">
										<span class="input-group-addon icon-ellipsis" onClick="open_acc_code('2');" title=""></span>
									</div>
								</div>
							</cfoutput>
							<!--- "AutoComplete_Create('year_account_code','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','','','','3','225');" --->
						</div>	
					</div>					
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
						<div class="form-group" id="item-account_code">
							<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='61352.Aktarılacak Muhasebe Kodu'></label>
							<div class="col col-12 col-xs-12">
								<div class="input-group">
									<cfoutput>
									<input type="hidden" name="account_id" id="account_id" value="#get_tahakkuk_plan.account_code#">
									<input type="text" name="account_code" id="account_code" onFocus="AutoComplete_Create('account_code','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','','ACCOUNT_CODE','account_id','','3','225');" value="#get_tahakkuk_plan.account_code#">
									<span class="input-group-addon icon-ellipsis" onClick="open_acc_code('0');" title=""></span>
									</cfoutput>
									<!--- "AutoComplete_Create('account_code','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','','ACCOUNT_CODE','account_id','','3','225');" --->
								</div>
							</div>
						</div>
						<div class="form-group" id="item-checkboxes">
							<div class="col col-12 col-xs-12">
								<div class="input-group">
									<label><input type="checkbox" name="proje_muh_kod" id="proje_muh_kod" onclick="get_proje_muh_kod();" <cfif get_tahakkuk_plan.IS_PROJECT_ACCOUNT eq 1>checked</cfif>>
									<b><cf_get_lang dictionary_id='62919.Projenin Gider Muhasebe Kodu'></b></label>
								</div>
							</div>
						</div>								
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<cfoutput>
						<cfif get_tahakkuk_plan.recordcount>
							<cf_record_info query_name="get_tahakkuk_plan" record_emp="RECORD_EMP">
						</cfif>
					</cfoutput>
					<cfif is_processed eq 0>
						<input type="button" class="ui-wrk-btn ui-wrk-btn-success" name="satir_tanimla" id="satir_tanimla" value="Tahakkuk Satırı Oluştur" onClick="satir_olustur();">
					</cfif>
					<cfif is_processed eq 0>
						<cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=budget.emptypopup_del_tahakkuk_plan&tplan_id=#attributes.tplan_id#&old_process_type=#get_tahakkuk_plan.process_type#&wrk_id=#get_tahakkuk_plan.wrk_id#'> <!--- del_function_for_submit='del_kontrol()' --->
					<cfelse>
						<cf_get_lang dictionary_id='62924.Belge İşlenmiştir.'>
					</cfif>
				</cf_box_footer>
			</cf_basket_form>
			<cf_basket id="budget_plan_bask">
				<cf_grid_list>
					<thead>
						<cfoutput>
							<tr>
								<th width="35"><cf_get_lang dictionary_id='57487.No'></th>
								<th width="20">
									<input type="hidden" name="record_num_kontrol" id="record_num_kontrol" value="<cfif isdefined('get_tahakkuk_plan_row') and get_tahakkuk_plan_row.recordcount><cfoutput>#get_tahakkuk_plan_row.recordcount#</cfoutput><cfelse>0</cfif>">
									<input type="hidden" name="record_num" id="record_num" value="<cfif isdefined('get_tahakkuk_plan_row') and get_tahakkuk_plan_row.recordcount><cfoutput>#get_tahakkuk_plan_row.recordcount#</cfoutput><cfelse>0</cfif>">
									<a onclick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57707.Satır Ekle'>"></i></a>
								</th>				
								<th width="150" nowrap="nowrap">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lütfen Tarih Giriniz'>!</cfsavecontent>
									<cf_get_lang dictionary_id='57742.Tarih'>&nbsp;
									<cfinput type="text" name="temp_date" id="temp_date" value="#dateformat(now(),dateformat_style)#" style="width:70px;" class="box" onBlur="change_date_info();" validate="#validate_style#" message="#message#">
								</th>
								<!--- <th width="190" nowrap><cf_get_lang dictionary_id='823.Masraf/Gelir Merkezi'> *</th>  --->
								<th nowrap width="250"><cf_get_lang dictionary_id='58551.Gider Kalemi'></th>
								<th nowrap width="250"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></th>
								<!--- <th width="120" nowrap><cf_get_lang dictionary_id='217.Açıklama'></th> --->
								<th width="100" nowrap style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'> #session.ep.money#</th>
								<th width="100" nowrap style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'> <input type="text" name="other_money_info3" id="other_money_info3" class="box" readonly="" style="width:35px;" value="#session.ep.money2#"></th>				
							</tr>
						</cfoutput>
					</thead>
					<tbody name="table1" id="table1"> 
						<cfif isdefined("get_tahakkuk_plan_row") and get_tahakkuk_plan_row.recordcount>
							<cfoutput query="get_tahakkuk_plan_row">
								<tr id="frm_row#currentrow#" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
									<td style="width:20px;" nowrap="nowrap">#currentrow#</td>
									<td nowrap="nowrap">
										<ul class="ui-icon-list">
											<input type="hidden" value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#">
											<input type="hidden" value="#wrk_row_id#" name="wrk_row_id#currentrow#" id="wrk_row_id#currentrow#">
											<li><a href="javascript://" onClick="sil('#currentrow#');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></li>
											<li><a onclick="copy_row('#currentrow#');"><i class="fa fa-copy" title="<cf_get_lang dictionary_id='58972.Satır Kopyala'>"></i></a></li>
											<input type="hidden" value="#tahakkuk_plan_row_id#" name="tahakkuk_plan_row_id#currentrow#" id="tahakkuk_plan_row_id#currentrow#">
										</ul>
									</td>
									<td nowrap="nowrap">
										<input type="text" name="expense_date#currentrow#" id="expense_date#currentrow#" style="width:150px;" value="#dateformat(ROW_PLAN_DATE,dateformat_style)#">
										<cf_wrk_date_image date_field="expense_date#currentrow#">
									</td>
									<td nowrap="nowrap">
										<cfset row_expense_center_id_ = ROW_EXPENSE_CENTER_ID>
										<cfif not len(row_expense_center_id_)><cfset row_expense_center_id_ = expense_center_id_></cfif>
										<cfset expense_item_id_ = "">
										<cfset expense_item_name_ = "">
										<cfif len(ROW_EXPENSE_ITEM_ID)>
											<cfset expense_item_id_ = ROW_EXPENSE_ITEM_ID>
											<cfquery name="get_expense_item" datasource="#dsn2#">
												SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME,ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID IN (#expense_item_id_#) ORDER BY EXPENSE_ITEM_ID
											</cfquery>
											<cfif get_expense_item.recordcount>
												<cfset expense_item_name_ = get_expense_item.EXPENSE_ITEM_NAME>
											</cfif>
										</cfif>
										<div class="form-group">
											<div class="input-group">
												<input type="hidden" name="expense_center_id#currentrow#" id="expense_center_id#currentrow#" value="#row_expense_center_id_#">
												<input type="hidden" name="expense_item_id#currentrow#" id="expense_item_id#currentrow#" value="#expense_item_id_#">
												<input type="text" name="expense_item_name#currentrow#" id="expense_item_name#currentrow#" value="#expense_item_name_#" style="width:117px;" class="boxtext" onFocus="AutoComplete_Create('expense_item_name#currentrow#','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID,ACCOUNT_CODE,ACCOUNT_CODE,EXPENSE_CAT_ID,EXPENSE_CAT_NAME','expense_item_id#currentrow#,account_code#currentrow#,account_id#currentrow#,expense_cat_id#currentrow#,expense_cat_name#currentrow#','upd_tahakkuk_plan',1);" autocomplete="off">
												<span class="input-group-addon icon-ellipsis" onclick="pencere_ac_exp('#currentrow#');"></span>
											</div>
										</div>
									</td>						
									<td nowrap="nowrap">
										<div class="form-group">
											<div class="input-group">
												<input type="hidden" name="account_id#currentrow#" id="account_id#currentrow#" value="#ROW_ACCOUNT_CODE#">
												<input type="text" name="account_code#currentrow#" id="account_code#currentrow#" value="#ROW_ACCOUNT_CODE#" style="width:117px;" class="boxtext" onFocus="autocomp_acc_code('#currentrow#');" autocomplete="off">
												<span class="input-group-addon icon-ellipsis" onclick="pencere_ac_acc('#currentrow#');"></span>
											</div>
										</div>
									</td>
									<td style="text-align:right;">
										<input type="text" name="expense_total#currentrow#" id="expense_total#currentrow#" value="#TLFormat(row_total_expense)#" onkeyup="FormatCurrency(this,event);" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('#currentrow#');" class="box">
									</td>
									<td style="text-align:right;">
										<input type="text" name="other_expense_total#currentrow#" id="other_expense_total#currentrow#" value="#TLFormat(ROW_OTHER_TOTAL_EXPENSE)#" class="box" readonly="yes">
									</td>
								</tr>
							</cfoutput>
						</cfif>
					</tbody>
				</cf_grid_list>
				<cf_basket_footer height="95">
					<div class="ui-row">
						<div id="sepetim_total" class="padding-0">
							<div class="col col-2 col-md-4 col-sm-6 col-xs-12">
								<div class="totalBox">
									<div class="totalBoxHead font-grey-mint">
										<span class="headText"> <cf_get_lang dictionary_id='57677.Dövizler'> </span>
										<div class="collapse">
											<span class="icon-minus"></span>
										</div>
									</div>
									<div class="totalBoxBody">
										<table cellspacing="0">
											<input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#get_money.recordcount#</cfoutput>">
											<cfoutput>
												<cfloop query="get_money">
													<tr>
														<td height="17">
															<input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
															<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
															<input type="radio" name="rd_money" id="rd_money" value="#money#" onClick="toplam_doviz_hesapla();" <cfif is_selected eq 1>checked</cfif>>#money#
														</td>
														<cfif session.ep.rate_valid eq 1>
															<cfset readonly_info = "yes">
														<cfelse>
															<cfset readonly_info = "no">
														</cfif>
														<td valign="bottom" style="text-align:right;">#TLFormat(rate1,0)#/<input type="text"  name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#"<cfif readonly_info>readonly</cfif> class="box" value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#" <cfif money eq session.ep.money>readonly="yes"</cfif> style="width:120px;" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="toplam_doviz_hesapla();"></td>
													</tr>
												</cfloop>
											</cfoutput>
										</table>
									</div>
								</div>
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="totalBox">
									<div class="totalBoxHead font-grey-mint">
										<span class="headText"><cf_get_lang dictionary_id='57492.Toplam'></span>
										<div class="collapse">
											<span class="icon-minus"></span>
										</div>
									</div>
									<div class="totalBoxBody">
										<table cellspacing="0">
											<tr>
												<td width="150" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'> </td>
												<td style="text-align:right;"><input type="text" name="expense_total_amount" id="expense_total_amount" class="box" readonly="" value="<cfif isdefined("get_tahakkuk_plan.EXPENSE_TOTAL") and len(get_tahakkuk_plan.EXPENSE_TOTAL)><cfoutput>#TLFormat(get_tahakkuk_plan.EXPENSE_TOTAL)#</cfoutput><cfelse>0</cfif>" style="width:120px;"><cfoutput>#session.ep.money#</cfoutput></td>
											</tr>
											<tr>
												<td width="150" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57643.KDV Toplam'></td>
												<td width="150" style="text-align:right;"><input type="text" name="tax_total" id="tax_total" class="box" readonly="" value="" style="width:120px;"><cfoutput>#session.ep.money#</cfoutput></td>
											</tr>
											<tr>
												<td width="150" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57680.Genel Toplam'></td>
												<td style="text-align:right;"><input type="text" name="expense_total_amount_tax" id="expense_total_amount_tax" class="box" readonly="" value="" style="width:120px;"><cfoutput>#session.ep.money#</cfoutput></td>
											</tr>
										</table>
									</div>
								</div>
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="totalBox">
									<div class="totalBoxHead font-grey-mint">
										<span class="headText"><cf_get_lang dictionary_id='40163.Toplam Miktar'></span>
										<div class="collapse">
											<span class="icon-minus"></span>
										</div>
									</div>
									<div class="totalBoxBody"> 
										<table>
											<tr>
												<td width="150" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'> </td>
												<td width="150" class="txtbold" style="text-align:right;"><input type="text" name="other_expense_total_amount" id="other_expense_total_amount" class="box" readonly="" value="0" style="width:85px;"><input type="text" name="other_money_info" id="other_money_info" class="box" readonly="" style="width:30px;" value="<cfoutput>#session.ep.money2#</cfoutput>"></td>
											</tr>
											<tr>
												<td width="150" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57643.KDV Toplam'></td>
												<td style="text-align:right;"><input type="text" name="other_tax_total" id="other_tax_total" class="box" readonly="" value="" style="width:120px;"></td>
											</tr>
											<tr>
												<td width="150" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57680.Genel Toplam'></td>
												<td style="text-align:right;"><input type="text" name="other_expense_total_amount_tax" id="other_expense_total_amount_tax" class="box" readonly="" value="" style="width:120px;"></td>
											</tr>
										</table>
									</div>
								</div>
							</div>
							<div class="col col-2 col-md-2 col-sm-2 col-xs-12">
								<div class="totalBox">
									<div class="totalBoxHead font-grey-mint">
										<span class="headText"><cf_get_lang dictionary_id='40163.Toplam Miktar'></span>
										<div class="collapse">
											<span class="icon-minus"></span>
										</div>
									</div>
									<div class="totalBoxBody">
										<table>
											<tr>
												<td width="150" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57639.KDV'></td>
												<cfif isdefined("kdv_rate")><cfset kdvdeger = kdv_rate><cfelse><cfset kdvdeger = ""></cfif>
												<cfif len(get_tahakkuk_plan.TAX)><cfset kdvdeger = get_tahakkuk_plan.TAX><cfelse><cfset kdvdeger = ""></cfif>	
												<td style="text-align:right;">
													<select name="tax_rate" id="tax_rate" style="width:120px;" class="box" onChange="kdv_hesapla(this.value);">								
														<cfoutput query="get_tax">
															<option value="#tax#" <cfif kdvdeger eq tax>selected</cfif>>#tax#</option>
														</cfoutput>
													</select>
												</td>
											</tr>					
										</table>
									</div>
								</div>
							</div>
						</div>
					</div>
				</cf_basket_footer>
			</cf_basket>
		</cfform>
	</cf_box>
</div>
<script>
	function tarih_fark_hesap(date1,date2)
	{
		date1 = date1.split('/');
		var date1 = new Date(date1[2],date1[1]-1,date1[0]);
		date2 = date2.split('/');
		var date2 = new Date(date2[2],date2[1]-1,date2[0]);

		var diffYears = date2.getFullYear()-date1.getFullYear();
		var diffMonths = (date2.getMonth()+1)-(date1.getMonth()+1);
		var diffDays = date2.getDate()-date1.getDate();
		
		var months = (diffYears*12 + diffMonths);
		if(diffDays>0) {
			months += '.'+diffDays;
		} else if(diffDays<0) {
			months--;
			months += '.'+(new Date(date2.getFullYear(),(date2.getMonth()+1),0).getDate()+diffDays);
		}
		if(months < 1)
			months = 1;
			
		return months;
	}
</script>
<script type="text/javascript">
	function satir_olustur()
	{
		if(document.getElementById("month_expense_item_id").value == '' && document.getElementById("month_expense_item_name").value == '')
		{
			alert("<cf_get_lang dictionary_id='62917.Gelecek Aylara Ait Gider Kalemi'> <cf_get_lang dictionary_id='57734.Seçiniz'> !");
			return false;
		}
		if(document.getElementById("year_expense_item_id").value == '' && document.getElementById("year_expense_item_name").value == '')
		{
			alert("<cf_get_lang dictionary_id='62918.Gelecek Yıllara Ait Gider Kalemi'> <cf_get_lang dictionary_id='57734.Seçiniz'> !");
			return false;
		}
		if(document.getElementById("start_date").value == '' || document.getElementById("finish_date").value == '')
		{
			alert("<cf_get_lang dictionary_id='635.Lütfen Başlangıç ve Bitiş Tarihi Giriniz'> !");
			return false;
		}
		var tutar_ = document.getElementById("net_total").value; 
		
		if(tutar_ == '' || tutar_ == 0)
		{
			alert("<cf_get_lang dictionary_id='29535.Lütfen Tutar Giriniz'> ");
			return false;
		}
		
		add_new_row();
	}
	function add_new_row()
	{
		if (document.getElementById("record_num").value > 0)
		{
			for(var tt=1;tt<=document.getElementById("record_num").value;tt++)
			{
				if(document.getElementById("row_kontrol"+tt).value==1)
				{
					sil(tt,0);
				}
			}
		}
		
		var guncel_yil = new Date();
		var deger_toplam = document.getElementById("net_total").value;
		deger_toplam = filterNum(deger_toplam);
		var date1 = document.getElementById("start_date").value;
		var date2 = document.getElementById("finish_date").value;
		date2 = date_add('d',-1,date2);
		if(date1 == date2)
			var tarih_fark = 0;
		else
			var tarih_fark = tarih_fark_hesap(date1,date2);
			
		var gunFarki = datediff(date1,date2,0);
		gunFarki = gunFarki+1;
		if(gunFarki == 0) gunFarki = 1;
		var gunlukTutar = deger_toplam / gunFarki;
		gunlukTutar = parseFloat(gunlukTutar);
		var deger_due_value = parseFloat(tarih_fark);
		deger_due_value = Math.ceil(deger_due_value);

		var deger_vade_tarih = document.getElementById("start_date").value;	
		var ilkTarih = document.getElementById("start_date").value;
		
		expense_center_id = '';
		row_detail = '';
		if (document.getElementById("expense_center_id") == undefined) expense_center_id =""; else expense_center_id = document.getElementById("expense_center_id").value;
		if (document.getElementById("month_expense_item_id") == undefined) expense_item_id =""; else expense_item_id = document.getElementById("month_expense_item_id").value;
		if (document.getElementById("month_expense_item_name") == undefined) expense_item_name =""; else expense_item_name = document.getElementById("month_expense_item_name").value;
		if (document.getElementById("month_account_id") == undefined) account_id =""; else account_id = document.getElementById("month_account_id").value;
		if (document.getElementById("month_account_code") == undefined) account_code =""; else account_code = document.getElementById("month_account_code").value;
			
		trh = deger_vade_tarih.split('/');
		var trh = new Date(trh[2],trh[1]-1,trh[0]);
		var ay_son_gun = daysInMonth((trh.getMonth()+1),trh.getFullYear()); 
		deger_vade_tarih = ay_son_gun+'/'+(trh.getMonth()+1)+'/'+trh.getFullYear();

		var tarihListesi = "";
		for(tar=1;tar<=deger_due_value;tar++)
		{
			if(tar == list_first(deger_due_value,'.'))
			{
				deger_vade_tarih = date2;
			}
		
			var trh_yil_kontrol = deger_vade_tarih.split('/');
			trh_yil_kontrol = new Date(trh_yil_kontrol[2],trh_yil_kontrol[1]-1,trh_yil_kontrol[0]);
			
			if(list_len(tarihListesi) == 0)
				tarihListesi = deger_vade_tarih;
			else
				tarihListesi = tarihListesi+','+deger_vade_tarih;
			if(tar == 1)
			{
				var gunFarkiYeni = datediff(ilkTarih,deger_vade_tarih,0);
				gunFarkiYeni = gunFarkiYeni+1;
			}
			else
			{
				var yeniGun = list_getat(tarihListesi,tar-1,',');
				var gunFarkiYeni = datediff(deger_vade_tarih,yeniGun,0);
				gunFarkiYeni = Math.abs(gunFarkiYeni);
			}
			if(gunFarkiYeni == 0) gunFarkiYeni = 1;
			expense_total = gunlukTutar*gunFarkiYeni;
			expense_total = commaSplit(expense_total,2);
			other_expense_total = expense_total;
			
			if(trh_yil_kontrol.getFullYear() != guncel_yil.getFullYear())
			{
				if (document.getElementById("year_account_id") == undefined) account_id =""; else account_id = document.getElementById("year_account_id").value;
				if (document.getElementById("year_account_code") == undefined) account_code =""; else account_code = document.getElementById("year_account_code").value;
			}
			if(account_id == '')
				account_id = account_code;
			add_row(deger_vade_tarih,expense_center_id,expense_item_id,expense_item_name,account_id,account_code,expense_total,other_expense_total,row_detail);
			deger_vade_tarih = date_add('m',+1,deger_vade_tarih,deger_vade_tarih,1);			
		}
	}
	function add_new_row_bas_trh()
	{
		if (document.getElementById("record_num").value > 0)
		{
			for(var tt=1;tt<=document.getElementById("record_num").value;tt++)
			{
				if(document.getElementById("row_kontrol"+tt).value==1)
				{
					sil(tt,0);
				}
			}
		}
		
		expense_center_id = '';
		row_detail = '';
		if (document.getElementById("expense_center_id") == undefined) expense_center_id =""; else expense_center_id = document.getElementById("expense_center_id").value;
		if (document.getElementById("month_expense_item_id") == undefined) expense_item_id =""; else expense_item_id = document.getElementById("month_expense_item_id").value;
		if (document.getElementById("month_expense_item_name") == undefined) expense_item_name =""; else expense_item_name = document.getElementById("month_expense_item_name").value;
		if (document.getElementById("month_account_id") == undefined) account_id =""; else account_id = document.getElementById("month_account_id").value;
		if (document.getElementById("month_account_code") == undefined) account_code =""; else account_code = document.getElementById("month_account_code").value;
		
		var guncel_yil = new Date();
		var deger_toplam = document.getElementById("net_total").value;
		deger_toplam = filterNum(deger_toplam);
		
		var date1 = document.getElementById("start_date").value;
		var date2 = document.getElementById("finish_date").value;
		var deger_vade_tarih = document.getElementById("start_date").value;	
		var ilkTarih = document.getElementById("start_date").value;
		var tarihListesi = "";
		
		trh = deger_vade_tarih.split('/');
		var trh = new Date(trh[2],trh[1]-1,trh[0]);
		var ay_son_gun = daysInMonth((trh.getMonth()+1),trh.getFullYear()); 
		deger_vade_tarih = ay_son_gun+'/'+(trh.getMonth()+1)+'/'+trh.getFullYear();
		
		ilkTarihDeger = ilkTarih.split('/');
		var ilkTarihDeger = new Date(ilkTarihDeger[2],ilkTarihDeger[1]-1,ilkTarihDeger[0]);
		var ilkTarihGun = ilkTarihDeger.getDate();
		deger_vade_tarih_ilk = date_add('d',-ilkTarihGun,deger_vade_tarih);
		
		date2 = date_add('d',-1,date2);
		if(date1 == date2)
			var tarih_fark = 0;
		else
			var tarih_fark = tarih_fark_hesap(date1,date2);
			
		 var gunFarki1 = datediff(date1,date2,0);
		var gunFarki = datediff(date1,date2,0);
		if(gunFarki == 0) gunFarki = 1;
		var gunlukTutar = deger_toplam / gunFarki;
		gunlukTutar = parseFloat(gunlukTutar);
		var deger_due_value = parseFloat(tarih_fark);
		deger_due_value = Math.ceil(deger_due_value); 
		
		for(tar=1;tar<=deger_due_value;tar++)
		{
			if(tar == list_first(deger_due_value,'.'))
			{
				deger_vade_tarih = date2;
			}
			var trh_yil_kontrol = deger_vade_tarih.split('/');
			trh_yil_kontrol = new Date(trh_yil_kontrol[2],trh_yil_kontrol[1]-1,trh_yil_kontrol[0]);
			
			if(tar == 1)
			{
				tarihListesi = deger_vade_tarih_ilk;
			}
			else
			{
				if(list_len(tarihListesi) == 0)
					tarihListesi = deger_vade_tarih;
				else
					tarihListesi = tarihListesi+','+deger_vade_tarih;
			}
			if(tar == 1)
			{
				var gunFarkiYeni = datediff(ilkTarih,deger_vade_tarih_ilk,0);
			}
			else
			{
				var yeniGun = list_getat(tarihListesi,tar-1,',');
				var gunFarkiYeni = datediff(deger_vade_tarih,yeniGun,0);
				gunFarkiYeni = Math.abs(gunFarkiYeni);
			}
			if(gunFarkiYeni == 0) gunFarkiYeni = 1;
			expense_total = gunlukTutar*gunFarkiYeni;
			expense_total = commaSplit(expense_total,2);
			other_expense_total = expense_total;
			
			if(trh_yil_kontrol.getFullYear() != guncel_yil.getFullYear())
			{
				if (document.getElementById("year_account_id") == undefined) account_id =""; else account_id = document.getElementById("year_account_id").value;
				if (document.getElementById("year_account_code") == undefined) account_code =""; else account_code = document.getElementById("year_account_code").value;
			}
			if(account_id == '')
				account_id = account_code;
			if(tar == 1)
				add_row(deger_vade_tarih_ilk,expense_center_id,expense_item_id,expense_item_name,account_id,account_code,expense_total,other_expense_total,row_detail);
			else
				add_row(deger_vade_tarih,expense_center_id,expense_item_id,expense_item_name,account_id,account_code,expense_total,other_expense_total,row_detail);
			deger_vade_tarih = date_add('m',+1,deger_vade_tarih,deger_vade_tarih,1);			
		}
	}
	function add_new_row_rv1()
	{
		if (document.getElementById("record_num").value > 0)
		{
			for(var tt=1;tt<=document.getElementById("record_num").value;tt++)
			{
				if(document.getElementById("row_kontrol"+tt).value==1)
				{
					sil(tt,0);
				}
			}
		}
		
		var guncel_yil = new Date();
		var deger_toplam = document.getElementById("net_total").value;
		deger_toplam = filterNum(deger_toplam);
		var date1 = document.getElementById("start_date").value;
		var date2 = document.getElementById("finish_date").value;
		if(date1 == date2)
			var tarih_fark = 0;
		else
			var tarih_fark = tarih_fark_hesap(date1,date2);
			
		var gunFarki = datediff(date1,date2,0);
		if(gunFarki == 0) gunFarki = 1;
		var gunlukTutar = deger_toplam / gunFarki;
		gunlukTutar = parseFloat(gunlukTutar);
		var deger_due_value = parseFloat(tarih_fark)+1;
		deger_due_value = Math.ceil(deger_due_value);
		var deger_vade_tarih = document.getElementById("start_date").value;	
		var ilkTarih = document.getElementById("start_date").value;
		
		expense_center_id = '';
		row_detail = '';
		if (document.getElementById("expense_center_id") == undefined) expense_center_id =""; else expense_center_id = document.getElementById("expense_center_id").value;
		if (document.getElementById("month_expense_item_id") == undefined) expense_item_id =""; else expense_item_id = document.getElementById("month_expense_item_id").value;
		if (document.getElementById("month_expense_item_name") == undefined) expense_item_name =""; else expense_item_name = document.getElementById("month_expense_item_name").value;
		if (document.getElementById("month_account_id") == undefined) account_id =""; else account_id = document.getElementById("month_account_id").value;
		if (document.getElementById("month_account_code") == undefined) account_code =""; else account_code = document.getElementById("month_account_code").value;
			
		trh = deger_vade_tarih.split('/');
		var trh = new Date(trh[2],trh[1]-1,trh[0]);
		var ay_son_gun = daysInMonth((trh.getMonth()+1),trh.getFullYear()); 
		deger_vade_tarih = ay_son_gun+'/'+(trh.getMonth()+1)+'/'+trh.getFullYear();
		var tarihListesi = "";
		for(tar=1;tar<=deger_due_value;tar++)
		{
			if(tar == list_first(deger_due_value,'.'))
			{
				deger_vade_tarih = document.getElementById("finish_date").value;
			}
		
			var trh_yil_kontrol = deger_vade_tarih.split('/');
			trh_yil_kontrol = new Date(trh_yil_kontrol[2],trh_yil_kontrol[1]-1,trh_yil_kontrol[0]);
			
			if(list_len(tarihListesi) == 0)
				tarihListesi = deger_vade_tarih;
			else
				tarihListesi = tarihListesi+','+deger_vade_tarih;

			if(tar == 1)
				var gunFarkiYeni = datediff(ilkTarih,deger_vade_tarih,0);
			else
			{
				var yeniGun = list_getat(tarihListesi,tar-1,',');
				var gunFarkiYeni = datediff(deger_vade_tarih,yeniGun,0);
				gunFarkiYeni = Math.abs(gunFarkiYeni);
			}
			if(gunFarkiYeni == 0) gunFarkiYeni = 1;

			expense_total = gunlukTutar*gunFarkiYeni;
			expense_total = commaSplit(expense_total,2);
			other_expense_total = expense_total;
			
			if(trh_yil_kontrol.getFullYear() != guncel_yil.getFullYear())
			{
				if (document.getElementById("year_account_id") == undefined) account_id =""; else account_id = document.getElementById("year_account_id").value;
				if (document.getElementById("year_account_code") == undefined) account_code =""; else account_code = document.getElementById("year_account_code").value;
			} 
			add_row(deger_vade_tarih,expense_center_id,expense_item_id,expense_item_name,account_id,account_code,expense_total,other_expense_total,row_detail);
			deger_vade_tarih = date_add('m',+1,deger_vade_tarih,deger_vade_tarih,1);			
		}
	}
	function get_proje_muh_kod()
	{
		var object_1 = document.getElementById("proje_muh_kod");
		if(document.getElementById("project_id").value == '' && document.getElementById("project_head").value == '')
		{
			alert("Lütfen Proje​ Seçiniz !");			
			object_1.checked = false;
		}
		else
		{
			if (object_1.checked == true)
			{
				var sql_ = "SELECT EXPENSE_PROGRESS_CODE,PROJECT_ID FROM PROJECT_PERIOD WHERE PERIOD_ID = "+'<cfoutput>#session.ep.period_id#</cfoutput>'+" AND PROJECT_ID ="+document.getElementById("project_id").value;
				var get_proje_muh = wrk_query(sql_,'dsn3'); 		
				
				if (document.getElementById("account_code") != undefined)
				{
					document.getElementById("account_code").value = get_proje_muh.EXPENSE_PROGRESS_CODE;
					document.getElementById("account_id").value = get_proje_muh.EXPENSE_PROGRESS_CODE;
				}	
			}
			else
			{
				if (document.getElementById("account_code") != undefined)
				{
					document.getElementById("account_code").value = null;
					document.getElementById("account_id").value = null;
				}
			}
		}		
	}
	function open_exp_center()
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&field_id=upd_tahakkuk_plan.expense_center_id&field_name=upd_tahakkuk_plan.expense_center');
	}
	function open_exp_item(sira)
	{
		if(sira == 1)
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=upd_tahakkuk_plan.month_expense_item_id&field_name=upd_tahakkuk_plan.month_expense_item_name&field_account_no=upd_tahakkuk_plan.month_account_code&field_account_id=upd_tahakkuk_plan.month_account_id','list');
		else if(sira == 2)
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=upd_tahakkuk_plan.year_expense_item_id&field_name=upd_tahakkuk_plan.year_expense_item_name&field_account_no=upd_tahakkuk_plan.year_account_code&field_account_id=upd_tahakkuk_plan.year_account_id','list');
	}
	function open_acc_code(sira)
	{
		if(sira == 0)
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_new&field_id=upd_tahakkuk_plan.account_id&field_id_2=upd_tahakkuk_plan.account_code','list');
		else if(sira == 1)
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_new&field_id=upd_tahakkuk_plan.month_account_id&field_id_2=upd_tahakkuk_plan.month_account_code','list');
		else if(sira == 2)
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_new&field_id=upd_tahakkuk_plan.year_account_id&field_id_2=upd_tahakkuk_plan.year_account_code','list');
	}
	function pencere_ac_assetp(no)
	{
		adres = '<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps';
		adres += '&field_id=all.assetp_id&field_name=all.assetp_name&event_id=0&motorized_vehicle=0';
		openBoxDraggable(adres);
	}
	function autocomp_assetp(no)
	{
		AutoComplete_Create("assetp_name","ASSETP","ASSETP","get_assetp_autocomplete","","ASSETP_ID","assetp_id","",3,200);
	}

	row_count = document.getElementById("record_num").value;
	
	function sil(sy)
	{
		var my_element=document.getElementById("row_kontrol"+sy);
		my_element.value=0;
		var my_element=document.getElementById("frm_row"+sy);
		my_element.style.display="none";
		toplam_hesapla();
		document.getElementById("record_num_kontrol").value = document.getElementById("record_num_kontrol").value-1;
	}

	function copy_row(no)
	{
		if (document.getElementById("expense_date" + no) == undefined) expense_date =""; else expense_date = document.getElementById("expense_date" + no).value;
		if (document.getElementById("row_detail" + no) == undefined) row_detail =""; else row_detail = document.getElementById("row_detail" + no).value;
		if (document.getElementById("expense_center_id" + no) == undefined) expense_center_id =""; else expense_center_id = document.getElementById("expense_center_id" + no).value;
		expense_center_id = '';
		if (document.getElementById("expense_item_id" + no) == undefined) expense_item_id =""; else expense_item_id = document.getElementById("expense_item_id" + no).value;
		if (document.getElementById("expense_item_id" + no) == undefined) expense_item_id =""; else expense_item_name = document.getElementById("expense_item_name" + no).value;
		if (document.getElementById("account_id" + no) == undefined) account_id =""; else account_id = document.getElementById("account_id" + no).value;
		if (document.getElementById("account_code" + no) == undefined) account_code =""; else account_code = document.getElementById("account_code" + no).value;
		if (document.getElementById("expense_total" + no) == undefined) expense_total =""; else expense_total = document.getElementById("expense_total" + no).value;
		if (document.getElementById("other_expense_total" + no) == undefined) other_expense_total =""; else other_expense_total = document.getElementById("other_expense_total" + no).value;
		add_row(expense_date,expense_center_id,expense_item_id,expense_item_name,account_id,account_code,expense_total,other_expense_total,row_detail);
	}
	
	function pencere_ac_acc(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_new&field_id=upd_tahakkuk_plan.account_id' + no +'&field_id_2=upd_tahakkuk_plan.account_code' + no +'','list');
	}
	function pencere_ac_exp(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=upd_tahakkuk_plan.expense_item_id' + no +'&field_name=upd_tahakkuk_plan.expense_item_name' + no +'&field_account_no=upd_tahakkuk_plan.account_code' + no +'&field_account_no2=upd_tahakkuk_plan.account_id' + no,'list');
	}
	
	function hesapla(row_no)
	{
		if(document.getElementById("kur_say").value == 1)
			for (var i=1; i<=document.getElementById("kur_say").value; i++)
			{
				if(document.getElementById("rd_money").checked == true)
				{
					form_txt_rate2_ = filterNum(document.getElementById("txt_rate2_"+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
					if(document.getElementById("expense_total"+row_no) != undefined && document.getElementById("other_expense_total"+row_no) != undefined)
						document.getElementById("other_expense_total"+row_no).value = commaSplit(filterNum(document.getElementById("expense_total"+row_no).value)/form_txt_rate2_);
				}
			}
		else
			for (var i=1; i<=document.getElementById("kur_say").value; i++)
			{
				if(document.upd_tahakkuk_plan.rd_money[i-1].checked == true)
				{
					form_txt_rate2_ = filterNum(document.getElementById("txt_rate2_"+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
					if(document.getElementById("expense_total"+row_no) != undefined && document.getElementById("other_expense_total"+row_no) != undefined)
						document.getElementById("other_expense_total"+row_no).value = commaSplit(filterNum(document.getElementById("expense_total"+row_no).value)/form_txt_rate2_);
				}
			}
		toplam_hesapla();
	}
	
	function toplam_hesapla()
	{
		var expense_total = 0;
		var other_expense_total = 0;
		
		for(j=1;j<=document.getElementById("record_num").value;j++)
		{
			if(document.getElementById("row_kontrol"+j).value==1)
			{
				expense_total = parseFloat(expense_total + parseFloat(filterNum(document.getElementById("expense_total"+j).value)));
				if(document.getElementById("other_expense_total"+j) != undefined)
					other_expense_total = parseFloat(other_expense_total + parseFloat(filterNum(document.getElementById("other_expense_total"+j).value)));
			}
		}
		document.getElementById("expense_total_amount").value = commaSplit(expense_total);
		document.getElementById("other_expense_total_amount").value = commaSplit(other_expense_total);
		
		kdv_hesapla();
	}
	
	function toplam_doviz_hesapla()
	{
		if(document.getElementById("kur_say").value == 1)
			for (var t=1; t<=document.getElementById("kur_say").value; t++)
			{
				if(document.document.getElementById("rd_money").checked == true)
				{
					for(k=1;k<=document.getElementById("record_num").value;k++)
					{
						rate2_value = filterNum(document.getElementById("txt_rate2_"+t).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');

						if(document.getElementById("other_expense_total"+k) != undefined)
							document.getElementById("other_expense_total"+k).value = commaSplit(filterNum(document.getElementById("expense_total"+k).value)/rate2_value);
					}
					document.getElementById("other_money_info").value = document.getElementById("rd_money").value;
					if(document.getElementById("other_money_info2") != undefined)
						document.getElementById("other_money_info2").value = document.getElementById("rd_money").value;
					if(document.getElementById("other_money_info3") != undefined)
						document.getElementById("other_money_info3").value = document.getElementById("rd_money").value;
					if(document.getElementById("other_money_info4") != undefined)
						document.getElementById("other_money_info4").value = document.getElementById("rd_money").value;
				}
			}
		else
			for (var t=1; t<=document.getElementById("kur_say").value; t++)
			{
				if(document.upd_tahakkuk_plan.rd_money[t-1].checked == true)
				{
					for(k=1;k<=document.getElementById("record_num").value;k++)
					{
						rate2_value = filterNum(document.getElementById("txt_rate2_"+t).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');

						if(document.getElementById("other_expense_total"+k) != undefined)
							document.getElementById("other_expense_total"+k).value = commaSplit(filterNum(document.getElementById("expense_total"+k).value)/rate2_value);
					}
					document.getElementById("other_money_info").value = document.upd_tahakkuk_plan.rd_money[t-1].value;
					if(document.getElementById("other_money_info2") != undefined)
						document.getElementById("other_money_info2").value = document.upd_tahakkuk_plan.rd_money[t-1].value;
					if(document.getElementById("other_money_info3") != undefined)
						document.getElementById("other_money_info3").value = document.upd_tahakkuk_plan.rd_money[t-1].value;
					if(document.getElementById("other_money_info4") != undefined)
						document.getElementById("other_money_info4").value = document.upd_tahakkuk_plan.rd_money[t-1].value;
				}
			}
		toplam_hesapla();
	}
	
	function kdv_hesapla(kdv)
	{
		//alert(kdv);
		if(kdv == undefined && document.getElementById("tax_rate") != undefined && document.getElementById("tax_rate").value != '')
			var kdv = document.getElementById("tax_rate").value;
			
		if(document.getElementById("expense_total_amount") != undefined && document.getElementById("expense_total_amount").value != '')
		{
			var deger_total = document.getElementById("expense_total_amount").value;			
			deger_total = filterNum(deger_total,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			if(kdv == undefined)
				deger_kdv_total = (parseFloat(deger_total) * 0)/100;
			else
				deger_kdv_total = (parseFloat(deger_total) * kdv)/100;
			deger_total = parseFloat(deger_total) + parseFloat(deger_kdv_total);
			document.getElementById("tax_total").value = commaSplit(deger_kdv_total);
			document.getElementById("expense_total_amount_tax").value = commaSplit(deger_total);
			
			var deger_total_other = document.getElementById("other_expense_total_amount").value;
			deger_total_other = filterNum(deger_total_other,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			if(kdv == undefined)
				deger_kdv_total_other = (parseFloat(deger_total_other) * 0)/100;
			else
				deger_kdv_total_other = (parseFloat(deger_total_other) * kdv)/100;
			deger_total_other = parseFloat(deger_total_other) + parseFloat(deger_kdv_total_other);
			document.getElementById("other_tax_total").value = commaSplit(deger_kdv_total_other);
			document.getElementById("other_expense_total_amount_tax").value = commaSplit(deger_total_other);
		}
	}
	
	function kontrol()
	{
		//if(!chk_process_cat('upd_tahakkuk_plan')) return false;
		//if(!check_display_files('upd_tahakkuk_plan')) return false;

		var record_exist = 0;
		process = document.getElementById("process_cat").value;
		var selected_ptype = document.getElementById("process_cat").options[document.getElementById("process_cat").selectedIndex].value;
		eval('var proc_control = document.upd_tahakkuk_plan.ct_process_type_'+selected_ptype+'.value');
		var get_process_cat = wrk_safe_query('bdg_get_process_cat','dsn3',0,process);
		if (!chk_period(upd_tahakkuk_plan.start_date)) return false;
		
		var income_total_ = 0;
		var expense_total_ = 0;
		
		//Odeme Plani Guncelleme Kontrolleri
		if (document.all.invoice_cari_action_type.value == 5 && document.all.old_pay_method.value != "")
		{
			if (confirm("<cf_get_lang dictionary_id='62923.Güncellediğiniz Belge İçin Ödeme Planı Girilmiştir. Ödeme Planı Silinecektir'> !"))
				document.all.invoice_payment_plan.value = 1;
			else
			{
				document.all.invoice_payment_plan.value = 0;
				return false;
			}
		}
		
		for(r=1;r<=document.getElementById("record_num").value;r++)
		{
			if(document.getElementById("row_kontrol"+r).value==1)
			{
				<!---Muhasebe hesabı alt hesaplar gelirken üst hesapların yazılamaması kontrolü--->
				var account_code_value = list_getat(document.getElementById("account_code"+r).value,1,'-');
				if(account_code_value != "")
				{
					if(WrkAccountControl(account_code_value,r+'. Satır: Muhasebe Hesabı Hesap Planında Tanımlı Değildir!') == 0)
					return false;
				}
				<!---Muhasebe hesabı alt hesaplar gelirken üst hesapların yazılamaması kontrolü--->
				record_exist=1;
				if (document.getElementById("expense_date"+r) != undefined && document.getElementById("expense_date"+r).value == "")
				{
					alert ("<cf_get_lang dictionary_id='49126.Satıra Lütfen Tarih Giriniz'>!");
					return false;
				}
				/*if (document.getElementById("row_detail"+r).value == "")
				{
					alert ("<cf_get_lang no='62.Lütfen Açıklama Giriniz'>!");
					return false;
				}*/
				if(proc_control != 161)
				{
					if (get_process_cat.IS_ACCOUNT == 0)
					{
						if (document.getElementById("expense_item_id"+r).value == "")
						{
							alert ("<cf_get_lang dictionary_id='62921.Satıra Lütfen Gider Kalemi Seçiniz'>!");
							return false;
						}
					}
					
					if (get_process_cat.IS_ACCOUNT == 1)
					{
						if (document.getElementById("account_code"+r).value == "")
						{
							alert ("<cf_get_lang dictionary_id='49133.Lütfen Muhasebe Kodu Seçiniz'>!");
							return false;
						}
					}
				}
				else
				{
					if ((document.getElementById("expense_item_name"+r).value == "") && document.getElementById("account_code"+r).value == '')
					{
						alert ("<cf_get_lang dictionary_id='62922.Gider Kalemi veya Muhasebe Kodu Seçmelisiniz'>!");
						return false;
					}
					if(document.getElementById("account_code"+r).value != '')
					{
						expense_total_ = parseFloat(expense_total_ + parseFloat(filterNum(document.getElementById("expense_total"+r).value)));
					}
				}
			}
		}
		if(document.getElementById("paper_number").value == "")
		{
			alert("<cf_get_lang dictionary_id='49122.Lütfen Belge No Giriniz'> !");
			return false;
		}
		/* else eklerken control ediliyor.Bu sebepten readonly özelliği verildi.Kapatıldı.
		{
			var sql_paper = "SELECT PAPER_NO,TAHAKKUK_PLAN_ID FROM TAHAKKUK_PLAN WHERE PAPER_NO = '"+document.getElementById("paper_number").value+"' AND TAHAKKUK_PLAN_ID <> "+document.getElementById("tplan_id").value;
		    var get_paper_kontrol = wrk_query(sql_paper,'dsn3'); 
			if(get_paper_kontrol.recordcount)
			{
				alert("Girdiğiniz Belge No Kullanılmaktadır !");
				return false;
			}
		} */
		if (record_exist == 0)
		{
			alert("<cf_get_lang dictionary_id='53376.Lütfen Satır Giriniz'> !");
			return false;
		}
		
		unformat_fields();
		return true;
	}
	function unformat_fields()
	{
		for(rm=1;rm<=document.getElementById("record_num").value;rm++)
		{
			document.getElementById("expense_total"+rm).value =  filterNum(document.getElementById("expense_total"+rm).value);
			if(document.getElementById("other_expense_total"+rm) != undefined)
				document.getElementById("other_expense_total"+rm).value =  filterNum(document.getElementById("other_expense_total"+rm).value);
		}

		document.getElementById("expense_total_amount").value = filterNum(document.getElementById("expense_total_amount").value);
		document.getElementById("other_expense_total_amount").value = filterNum(document.getElementById("other_expense_total_amount").value);
		for(st=1;st<=document.getElementById("kur_say").value;st++)
		{
			document.getElementById("txt_rate2_"+ st).value = filterNum(document.getElementById("txt_rate2_" + st).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			document.getElementById("txt_rate1_"+ st).value = filterNum(document.getElementById("txt_rate1_"+ st).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
		
		document.getElementById("tax_total").value = filterNum(document.getElementById("tax_total").value);
		document.getElementById("other_tax_total").value = filterNum(document.getElementById("other_tax_total").value);
		document.getElementById("expense_total_amount_tax").value = filterNum(document.getElementById("expense_total_amount_tax").value);
		document.getElementById("other_expense_total_amount_tax").value = filterNum(document.getElementById("other_expense_total_amount_tax").value);		
	}
	function change_date_info()
	{
		if(document.getElementById("temp_date").value != '')
			for(tt=1;tt<=document.getElementById("record_num").value;tt++)
				if(document.getElementById("row_kontrol"+tt).value==1)
					document.getElementById("expense_date"+tt).value = document.getElementById("temp_date").value;
	}
	
	function autocomp_acc_code(no)
	{
		AutoComplete_Create("account_code"+no,"ACCOUNT_CODE,ACCOUNT_NAME","ACCOUNT_CODE,ACCOUNT_NAME","get_account_code","","ACCOUNT_CODE","account_id"+no,"",3,225);
	}
	function autocomp_budget(no)
	{
		AutoComplete_Create("expense_item_name"+no,"EXPENSE_ITEM_NAME","EXPENSE_ITEM_NAME","get_expense_item","","EXPENSE_ITEM_ID,ACCOUNT_CODE,ACCOUNT_CODE,EXPENSE_CAT_ID,EXPENSE_CAT_NAME","expense_item_id"+no+",account_code"+no+",account_id"+no+",expense_cat_id"+no+",expense_cat_name"+no,3,200);
	}
	toplam_hesapla();
	toplam_doviz_hesapla();
	
	function add_row(expense_date,expense_center_id,expense_item_id,expense_item_name,account_id,account_code,expense_total,other_expense_total,row_detail)
	{
		//Normal satır eklerken değişkenler olmadığı için boşluk atıyor,kopyalarken değişkenler geliyor
		if(expense_date == undefined)expense_date = '';		
		if(expense_center_id == undefined)expense_center_id = '';
		if(expense_item_id == undefined)expense_item_id = '';
		if(expense_item_name == undefined)expense_item_name = '';
		if(account_id == undefined)account_id = '';
		if(account_code == undefined)account_code = '';
		if(expense_total == undefined)expense_total = 0;
		if(other_expense_total == undefined)other_expense_total = 0;
		if(row_detail == undefined)row_detail = '';

		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);
		newRow.className = 'color-row';
		document.getElementById("record_num").value=row_count;
		document.getElementById("record_num_kontrol").value=document.getElementById("record_num_kontrol").value+1;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="satir_no' + row_count +'" id="satir_no' + row_count +'" value=' +row_count+' class="boxtext" style="width:20px;" readonly="yes">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" value="0" name="tahakkuk_plan_row_id' + row_count +'" id="tahakkuk_plan_row_id' + row_count +'"><input type="hidden" value="'+js_create_unique_id()+'" name="wrk_row_id' + row_count +'" id="wrk_row_id' + row_count +'"><input type="hidden" value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" ><ul class="ui-icon-list"><li><a onclick="sil(' + row_count + ');"><i class="fa fa-minus" title="Sil"></i></a></li><li><a onclick="copy_row(' + row_count + ');"><i class="fa fa-copy" title="Satır Kopyala"></i></a></li></ul>';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.setAttribute("id","expense_date" + row_count + "_td");
		newCell.innerHTML = '<input type="text" name="expense_date' + row_count +'"id="expense_date'+ row_count +'"class="text" maxlength="10" style="width:150px;" value="' + expense_date +'"> ';
		wrk_date_image('expense_date' + row_count);

		/*newCell = newRow.insertCell(newRow.cells.length);
		a = '<select name="expense_center_id' + row_count  +'" id="expense_center_id' + row_count  +'" class="boxtext"><option value="">Masraf/Gelir Merkezi</option>';
		<cfoutput query="get_expense_center">
			if('#expense_id#' == expense_center_id)
				a += '<option value="#expense_id#" selected>#expense#</option>';
			else
				a += '<option value="#expense_id#">#expense#</option>';
		</cfoutput>
		newCell.innerHTML =a+ '</select>';*/
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="expense_center_id' + row_count +'" id="expense_center_id' + row_count +'" value="'+expense_center_id+'"><input type="hidden" name="expense_item_id' + row_count +'" id="expense_item_id' + row_count +'" value="'+expense_item_id+'"><input type="text" name="expense_item_name' + row_count +'" id="expense_item_name' + row_count +'" class="boxtext" value="'+expense_item_name+'" onFocus="autocomp_budget('+row_count+');"><span class="input-group-addon icon-ellipsis" onclick="pencere_ac_exp('+ row_count +');"></span></div></div>';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden" name="account_id' + row_count +'" id="account_id' + row_count +'" value="'+account_id+'"><input type="text" name="account_code' + row_count +'" id="account_code' + row_count +'" class="boxtext"  value="'+account_code+'" onFocus="autocomp_acc_code('+row_count+');" ><span class="input-group-addon icon-ellipsis" onclick="pencere_ac_acc('+ row_count +');"></span></div></div>';
		
		/*newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="row_detail' + row_count +'" id="row_detail' + row_count +'" style="width:120px;" class="boxtext" maxlength="300" value="' + row_detail +'">';*/

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('class','text-right');
		newCell.innerHTML = '<input type="text" name="expense_total' + row_count +'" id="expense_total' + row_count +'" value="'+expense_total+'" onkeyup="return(FormatCurrency(this,event));" class="box" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(0);hesapla('+row_count+');">';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('class','text-right');
		newCell.innerHTML = '<input type="text" name="other_expense_total' + row_count +'" id="other_expense_total' + row_count +'" value="'+other_expense_total+'" onkeyup="return(FormatCurrency(this,event));" class="box" readonly="yes">';
		
		hesapla(row_count);
		toplam_hesapla();
	}
	function change_paper_duedate(field_name,type,is_row_parse)
	{
		if(field_name == undefined || field_name=='')
		field_name = document.all.search_process_date.value;
		
		paper_date_ = document.getElementById(field_name).value;
		
		if(type!=undefined && type==1)
		{
			document.all.due_value.value = datediff(paper_date_,document.all.due_date.value,0);
		}
		else
		{
			if(isNumber(document.all.due_value)!= false && (document.all.due_value.value != 0))
			{
				document.all.due_date.value = date_add('d',+document.all.due_value.value,paper_date_);
			}
			else
			{
				document.all.due_date.value =paper_date_;
				if(document.all.due_value.value == '')
				{
					document.all.due_value.value = datediff(paper_date_,document.all.due_date.value,0);
				}
			}
		}
	}
	function openVoucher()
	{
		windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_payment_with_voucher_tahakkuk&payment_process_id=#attributes.tplan_id#&str_table=TAHAKKUK_PLAN&is_purchase_=1</cfoutput>','medium');		
	}
</script>