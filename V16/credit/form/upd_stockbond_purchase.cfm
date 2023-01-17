<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.comp_name" default="">
<cfparam name="attributes.partner_name" default="">
<cfquery name="GET_STOCKBOND_TYPES" datasource="#dsn#">
	SELECT * FROM SETUP_STOCKBOND_TYPE
</cfquery>
<cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
    SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE IS_EXPENSE = 1 ORDER BY EXPENSE_ITEM_NAME
</cfquery>	
<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
	SELECT EXPENSE_ID, EXPENSE_CODE, EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ACTIVE = 1 ORDER BY EXPENSE
</cfquery>
<cfquery name="GET_BOND_ACTION" datasource="#dsn3#">
	SELECT * FROM STOCKBONDS_SALEPURCHASE WHERE ACTION_ID=#attributes.action_id#
</cfquery>
<cfquery name="GET_ACTION_MONEY" datasource="#dsn3#">
	SELECT MONEY_TYPE AS MONEY, * FROM STOCKBONDS_SALEPURCHASE_MONEY WHERE ACTION_ID = #attributes.action_id#
</cfquery>
<cfif not GET_ACTION_MONEY.recordcount>
	<cfquery name="GET_ACTION_MONEY" datasource="#dsn2#">
		SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY
	</cfquery>
</cfif>
<cfquery name="GET_STOCKBOND_ROWS" datasource="#dsn3#">
	SELECT
		* 
	FROM
		STOCKBONDS,
		STOCKBONDS_SALEPURCHASE_ROW
	WHERE
		STOCKBONDS_SALEPURCHASE_ROW.SALES_PURCHASE_ID = #attributes.action_id# AND
		STOCKBONDS.STOCKBOND_ID = STOCKBONDS_SALEPURCHASE_ROW.STOCKBOND_ID
</cfquery>

<cfquery name="GET_STOCKBOND" datasource="#DSN3#">
	SELECT
		*
	FROM
        STOCKBONDS AS ST
        LEFT JOIN STOCKBONDS_YIELD_PLAN_ROWS SPR ON SPR.STOCKBOND_ID = ST.STOCKBOND_ID 
 	WHERE
        ST.STOCKBOND_ID = #GET_STOCKBOND_ROWS.stockbond_id#
</cfquery>

<cf_catalystHeader>
	<cf_box>	
		<cfform name="upd_bond" method="post" action="#request.self#?fuseaction=credit.emptypopup_upd_stockbond_purchase">
			<cf_box_elements vertical="1">
				<input type="hidden" name="action_id" id="action_id" value="<cfoutput>#attributes.action_id#</cfoutput>">
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-islem">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no ='388.İşlem Tipi'>*</label>
							<div class="col col-8 col-xs-12">
								<cf_workcube_process_cat process_cat='#get_bond_action.process_cat#' slct_width="125">
							</div>
						</div>
						<div class="form-group" id="item-company_id">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no ='107.Cari Hesap'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfif len(get_bond_action.company_id)>
										<cfquery name="GET_COMP" datasource="#dsn#">
											SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID=#get_bond_action.company_id#
										</cfquery>
									</cfif>
									<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_bond_action.company_id#</cfoutput>">
									<input type="text" name="comp_name" id="comp_name" value="<cfif len(get_bond_action.company_id)><cfoutput>#get_comp.fullname#</cfoutput></cfif>" style="width:125px;" onFocus="AutoComplete_Create('comp_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'\',\'\',\'\',\'\',\'\',\'\',\'1\'','COMPANY_ID,PARTNER_ID,MEMBER_PARTNER_NAME','company_id,partner_id,partner_name','','3','250');" autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang_main no='322.Seçiniz'>" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2&field_name=upd_bond.partner_name&field_partner=upd_bond.partner_id&field_comp_name=upd_bond.comp_name&field_comp_id=upd_bond.company_id</cfoutput>','list');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-partner_id">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no ='166.Yetkili'></label>
							<div class="col col-8 col-xs-12">
								<cfif len(get_bond_action.partner_id) and len(get_bond_action.company_id)>
									<cfquery name="GET_PARTNER" datasource="#dsn#">
										SELECT 
											PARTNER_ID,
											COMPANY_PARTNER_NAME,
											COMPANY_PARTNER_SURNAME
										FROM 
											COMPANY_PARTNER
										WHERE 
											PARTNER_ID= #get_bond_action.partner_id#
									</cfquery>
								</cfif>
								<input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#get_bond_action.partner_id#</cfoutput>">
								<input type="text" name="partner_name" id="partner_name" value="<cfif len(get_bond_action.partner_id) and len(get_bond_action.company_id)><cfoutput>#get_partner.company_partner_name# #get_partner.company_partner_surname#</cfoutput></cfif>" style="width:125px;">
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-paper_no">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no ='468.Belge No'>*</label>
							<div class="col col-8 col-xs-12">
								<cfinput type="text" name="paper_no" id="paper_no" value="#get_bond_action.paper_no#" maxlength="50" style="width:80px;" required="yes" message="Belge No Girmelisiniz">
							</div>
						</div>
						<div class="form-group" id="item-action_date">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no ='330.Tarih'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">								 
									<cfinput type="text" name="action_date" id="action_date" validate="#validate_style#" value="#dateformat(get_bond_action.action_date,dateformat_style)#" maxlength="10" onBlur="FaizHesapla('getiri_tutari1');change_money_info('add_bond','action_date');" required="yes" message="Tarih Girmelisiniz !">
									<span class="input-group-addon"><cf_wrk_date_image date_field="action_date" call_function="change_money_info"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-ref_no">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='1382.Referans No'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="ref_no" id="ref_no" value="<cfoutput>#get_bond_action.ref_no#</cfoutput>"  style="width:80px;">
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
						<div class="form-group" id="item-broker_company">
							<label class="col col-4 col-xs-12"><cf_get_lang no ='85.Aracı Kurum'></label>
							<div class="col col-8 col-xs-12">
								<cfinput type="text" name="broker_company" id="broker_company" value="#get_bond_action.broker_company#" style="width:120px;" maxlength="50">
							</div>
						</div>
						<div class="form-group" id="item-employee_id">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no ='1174.İşlem Yapan'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfif len(get_bond_action.employee_id)>
										<cfquery name="GET_EMP" datasource="#dsn#">
											SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID=#get_bond_action.employee_id#
										</cfquery>
									</cfif>
									<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_bond_action.employee_id#</cfoutput>">
									<cf_wrk_employee_positions form_name='upd_bond' emp_id='employee_id' emp_name='employee'>
									<input type="text" name="employee" id="employee" style="width:120px;" onkeyup="get_emp_pos_1();" value="<cfif len(get_bond_action.employee_id)><cfoutput>#get_emp.employee_name# #get_emp.employee_surname#</cfoutput></cfif>">
									<span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang_main no ='1174.İşlem Yapan'>" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=upd_bond.employee_id&field_name=upd_bond.employee&select_list=1</cfoutput>','list');"></span>
								</div>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
						<div class="form-group" id="item-detail">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no ='217.Açıklama'></label>
							<div class="col col-8 col-xs-12">
								<textarea name="detail" id="detail" style="width:285px;height:50px;"><cfoutput>#get_bond_action.detail#</cfoutput></textarea>
							</div>
						</div>
						<div class="form-group" id="item-account_id">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='1652.Banka Hesabı'></label>
							<div class="col col-8 col-xs-12">
								<cfinclude template="../query/get_accounts.cfm">
								<select name="account_id" id="account_id" style="width:285px;" onChange="">
									<option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
									<cfoutput query="get_accounts">
										<option value="#account_id#;#account_currency_id#" <cfif get_bond_action.bank_acc_id eq account_id>selected</cfif>>#account_name#-#account_currency_id#</option>
									</cfoutput>
								</select>
							</div>
						</div>
					</div>
					<div class="ui-card col col-12">
						<input name="record_num" id="record_num" type="hidden" value="<cfoutput>#get_stockbond_rows.recordCount#</cfoutput>">
						<div id="table_list">
							<cfset exp_item_id_list=''>
							<cfset exp_center_id_list=''>
							<cfset stockbond_type_list=''>
							<cfoutput query="get_stockbond_rows">
								<cfif len(row_exp_center_id) and not listfind(exp_center_id_list,row_exp_center_id)>
								<cfset exp_center_id_list=listappend(exp_center_id_list,row_exp_center_id)>
								</cfif>
								<cfif len(row_exp_item_id) and not listfind(exp_item_id_list,row_exp_item_id)>
								<cfset exp_item_id_list=listappend(exp_item_id_list,row_exp_item_id)>
								</cfif>
								<cfif len(stockbond_type) and not listfind(stockbond_type_list,stockbond_type)>
								<cfset stockbond_type_list=listappend(stockbond_type_list,stockbond_type)>
								</cfif>
							</cfoutput>
							<cfif len(exp_center_id_list)>
								<cfset exp_center_id_list=listsort(exp_center_id_list,"numeric","ASC",",")>
								<cfquery name="get_exp_center" datasource="#dsn2#">
									SELECT EXPENSE_ID, EXPENSE_CODE, EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID IN (#exp_center_id_list#) ORDER BY EXPENSE
								</cfquery>
							</cfif>
							<cfif len(exp_item_id_list)>
								<cfset exp_item_id_list=listsort(exp_item_id_list,"numeric","ASC",",")>
								<cfquery name="get_exp_detail" datasource="#dsn2#">
									SELECT EXPENSE_ITEM_NAME,EXPENSE_ITEM_ID FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID IN (#exp_item_id_list#) ORDER BY EXPENSE_ITEM_ID
								</cfquery>
							</cfif>
							<cfif len(stockbond_type_list)>
								<cfset stockbond_type_list=listsort(stockbond_type_list,"numeric","ASC",",")>
								<cfquery name="get_bond_types" datasource="#dsn#">
									SELECT * FROM SETUP_STOCKBOND_TYPE WHERE STOCKBOND_TYPE_ID IN (#stockbond_type_list#) ORDER BY STOCKBOND_TYPE_ID
								</cfquery>
							</cfif>
							<cfoutput query="get_stockbond_rows">
								<input type="hidden" value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#">
								<input type="hidden" name="stockbond_id#currentrow#" id="stockbond_id#currentrow#" value="#STOCKBOND_ID#">
								<div class="ui-card-item" id="block_row_#currentrow#">
									<div class="acc-body">
										<div class="col col-2 col-md-3 col-sm-3 col-xs-12">
											<div class="form-group acc-block-name">
												<cfif len(stockbond_type_list)>
													<cfset deger_bond_type = get_bond_types.stockbond_type_id[listfind(stockbond_type_list,stockbond_type,',')]>
												<cfelse>
													<cfset deger_bond_type=''>
												</cfif>
												<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang_main no ='218.Tip'>* </label>
												<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
													<select name="bond_type#currentrow#" id="bond_type#currentrow#">
														<option value=""><cf_get_lang no ='83.Menkul Kıymet Tipi'></option>
														<cfloop query="get_stockbond_types">
															<option value="#stockbond_type_id#" <cfif deger_bond_type eq get_stockbond_types.stockbond_type_id>selected</cfif>>#stockbond_type#</option>
														</cfloop>
													</select>
												</div>
											</div>
											<div class="form-group acc-block-name">
												<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang_main no ='1173.Kod'>* </label>
												<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
													<input type="text" name="bond_code#currentrow#" id="bond_code#currentrow#" value="#stockbond_code#">
												</div>
											</div>
											<div class="form-group acc-block-name">
												<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang_main no ='217.Açıklama'>* </label>
												<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
													<input type="text" name="row_detail#currentrow#" id="row_detail#currentrow#" value="#detail#">
												</div>
											</div>
											<div class="form-group acc-block-name">
												<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang no ='77.Nominal Değer'>* </label>
												<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
													<input type="text" class="moneybox" name="nominal_value#currentrow#" id="nominal_value#currentrow#" value="#TLFormat(nominal_value,session.ep.our_company_info.rate_round_num)#" onBlur="hesapla('#currentrow#');" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" >
												</div>
											</div>
											<div class="form-group acc-block-name">
												<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang no ='78.Nominal Değer Döviz'> </label>
												<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
													<input type="text" class="moneybox" name="other_nominal_value#currentrow#" id="other_nominal_value#currentrow#" value="#TLFormat(other_nominal_value,session.ep.our_company_info.rate_round_num)#" onBlur="hesapla('#currentrow#',1);">
												</div>
											</div>
										</div>
										<div class="col col-2 col-md-3 col-sm-3 col-xs-12">
											<div class="form-group acc-block-name">
												<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang no ='79.Alış Değer'> *</label>
												<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
													<input type="text" class="moneybox" name="purchase_value#currentrow#" id="purchase_value#currentrow#" value="#TLFormat(purchase_value,session.ep.our_company_info.rate_round_num)#" onBlur="hesapla('#currentrow#');FaizHesapla('getiri_tutari1');" onkeyup="specialVisible('yield_payment_period');return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));">
												</div>
											</div>
											<div class="form-group acc-block-name">
												<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang no ='80.Alış Değer Döviz'></label>
												<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
													<input type="text" class="moneybox" name="other_purchase_value#currentrow#" id="other_purchase_value#currentrow#" value="#TLFormat(other_purchase_value,session.ep.our_company_info.rate_round_num)#" onBlur="hesapla('#currentrow#',1);FaizHesapla('getiri_tutari1');">
												</div>
											</div>
											<div class="form-group acc-block-name">
												<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang_main no ='223.Miktar'></label>
												<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
													<cfset temp_quantity = ReplaceNoCase(quantity,'.',',','all')>
													<input type="text" class="moneybox" name="quantity#currentrow#" id="quantity#currentrow#" value="#temp_quantity#" onBlur="hesapla('#currentrow#');" onkeyup="return(FormatCurrency(this,event,4));">
												</div>
											</div>
											<div class="form-group acc-block-name">
												<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang no ='87.Toplam Alış'></label>
												<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
													<input type="text" class="moneybox" name="total_purchase#currentrow#" id="total_purchase#currentrow#" onkeyup="return(FormatCurrency(this,event));" onBlur="hesapla('#currentrow#');" value="#TLFormat(total_purchase,session.ep.our_company_info.rate_round_num)#" readonly="yes">
												</div>
											</div>
											<div class="form-group acc-block-name">
												<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang no ='88.Toplam Alış Döviz'></label>
												<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
													<input type="text" class="moneybox" name="other_total_purchase#currentrow#" id="other_total_purchase#currentrow#" value="#TLFormat(other_total_purchase,session.ep.our_company_info.rate_round_num)#" readonly="yes">
												</div>
											</div>
										</div>
										<div class="col col-2 col-md-3 col-sm-3 col-xs-12">
											<div class="form-group acc-block-name">
												<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang no ='89.Masraf Gelir Merkezi'>*</label>
												<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
													<cfif len(exp_center_id_list)>
														<cfset deger_exp_center = get_exp_center.expense_id[listfind(exp_center_id_list,row_exp_center_id,',')]>
														<cfelse>
														<cfset deger_exp_center = ''>
													</cfif>
													<cf_wrkExpenseCenter fieldId="expense_center_id#currentrow#" fieldName="expense_center_name#currentrow#" form_name="upd_bond" expense_center_id="#deger_exp_center#" img_info="plus_thin">
												</div>
											</div>
											<div class="form-group acc-block-name">
												<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang_main no='822.Bütçe Kalemi'>*</label>
												<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
													<cfif len(exp_item_id_list)>
														<cfset deger_exp_item = get_exp_detail.expense_item_id[listfind(exp_item_id_list,row_exp_item_id,',')]>
														<cfelse>
														<cfset deger_exp_item =''>
													</cfif>
													<cf_wrkExpenseItem fieldId="expense_item_id#currentrow#" fieldName="expense_item_name#currentrow#" form_name="upd_bond" income_type_info="1" expense_item_id="#deger_exp_item#" img_info="plus_thin">
												</div>
											</div>
											<div class="form-group acc-block-name" id="item-account_code">
												<label class="col col-12 col-xs-12"><cf_get_lang_main no='1399.Muhasebe Kodu'></label>
												<div class="col col-12 col-xs-12">
													<div class="input-group">
														<cf_wrk_account_codes form_name='upd_bond' account_code='acc_id' account_name='acc_name' search_from_name='1'>			
														<input type="hidden" name="acc_id" id="acc_id" value="#get_bond_action.account_code#" style="width:120px;">
														<input type="text" name="acc_name" id="acc_name" value="#get_bond_action.account_code#" onkeyup="get_wrk_acc_code_1();" onFocus="AutoComplete_Create('acc_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','acc_id','upd_bond','3','120');" autocomplete="off">
														<span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang_main no='322.Seçiniz'>" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_name=upd_bond.acc_name&field_id=upd_bond.acc_id','list');"></span>
													</div>
												</div>
											</div>
											<div class="form-group acc-block-name" id="Th_getiri_tipi">
												<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id ='40995.Getiri Tipi'></label>
												<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
													<select name="getiri_type#currentrow#" id="getiri_type#currentrow#" onchange="visiblePeriod(this.value, '#currentrow#')">
														<option value=""><cf_get_lang dictionary_id='58693.Seç'></option>
														<option value="1" <cfif YIELD_TYPE EQ 1>SELECTED</cfif>><cf_get_lang dictionary_id='60511.Sabit Getirili'></option>
														<option value="2" <cfif YIELD_TYPE EQ 2>SELECTED</cfif>><cf_get_lang dictionary_id='60512.Piyasa Değeri ve Temettülü'></option>
														<option value="3" <cfif YIELD_TYPE EQ 3>SELECTED</cfif>>Likit Fon</option>
													</select>
												</div>
											</div>
											<div class="form-group acc-block-name" id="th_start_date" style="display:none;">
												<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='58053.Baslangıç Tarihi'>*</label>
												<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
													<div class="input-group">
														<cfinput type="text" name="start_date#currentrow#" id="start_date#currentrow#" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" maxlength="10" onclick="change_paper_duedate('start_date#currentrow#',#currentrow#);specialVisible('yield_payment_period');FaizHesapla('getiri_tutari#currentrow#');" onBlur="FaizHesapla('getiri_tutari#currentrow#');">
														<span class="input-group-addon"><cf_wrk_date_image date_field="start_date1"></span>
													</div>
												</div>
											</div>
										</div>
										<div class="col col-2 col-md-3 col-sm-3 col-xs-12">
											<div class="form-group acc-block-name" id="Th_vade" style="display:none;">
												<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang_main no='228.Vade'>*</label>
												<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
													<div class="input-group">
														<input type="text" name="due_value#currentrow#" id="due_value#currentrow#" value="#due_value#" maxlength="50"  onchange="change_paper_duedate('start_date1');specialVisible('yield_payment_period');FaizHesapla('getiri_tutari1');">
														<span class="input-group-addon no-bg"></span>
														<cfinput type="text" name="due_date#currentrow#" id="due_date#currentrow#" validate="#validate_style#" value="#dateformat(due_date,dateformat_style)#" maxlength="10" onChange="change_paper_duedate('start_date1',1);specialVisible('yield_payment_period');FaizHesapla('getiri_tutari1');">
														<span class="input-group-addon"><cf_wrk_date_image date_field="due_date#currentrow#"></span>
													</div>
												</div>
											</div>
											<div class="form-group acc-block-name" id="Th_getiri" style="display:none;">
												<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
													<div class="input-group">
														<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='51373.Getiri Oranı'>*</label>
														<input type="text" class="moneybox" name="getiri_orani#currentrow#" id="getiri_orani#currentrow#" value="#TLFormat(YIELD_RATE)#" onkeyup="return(FormatCurrency(this,event));" onblur="FaizHesapla('getiri_orani1')">
														<span class="input-group-addon no-bg"></span>
														<label class="col col-12 col-md-12 col-sm-12 col-xs-12">YGS *</label>
														<cfinput type="number" name="ygs#currentrow#" class="moneybox" value="#iif( len(YGS), 'YGS',DE(365))#" onblur="FaizHesapla('getiri_orani1');" onkeyup="FaizHesapla('getiri_orani1');return(FormatCurrency(this,event));">
													</div>
												</div>
											</div>
											<div class="form-group acc-block-name" id="Th_Getiri_tahsil_tutari" style="display:none;">
												<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
													<div class="input-group">
														<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id="60103.Tahsil Sayısı">*</label>
														<input readonly type="text" class="moneybox" name="getiri_tahsil_tutari#currentrow#" id="getiri_tahsil_tutari#currentrow#" value="#TLFormat(YIELD_AMOUNT,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));">
														<span class="input-group-addon no-bg"></span>
														<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='60102.Tahsil Sayısı'> *</label>
														<input readonly type="text" class="moneybox" name="getiri_tahsil_sayisi#currentrow#" id="getiri_tahsil_sayisi#currentrow#" value="#NUMBER_YIELD_COLLECTION#" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));">
													</div>
												</div>
											</div>
											<div class="form-group acc-block-name" id="Th_Getiri_tutari" style="display:none;">
												<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id="51374.Getiri Tutarı">*</label>
												<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
													<input type="text" class="moneybox" name="getiri_tutari#currentrow#" id="getiri_tutari#currentrow#" value="#TLFormat(YIELD_AMOUNT_TOTAL,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));">
												</div>
											</div>
											<div class="form-group acc-block-name" id="Th_butce" style="display:none;">
												<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang_main no='822.Bütçe Kalemi'> <cf_get_lang dictionary_id='34760.Tahakkuk'> *</label>
												<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
													<cf_wrkExpenseItem fieldId="expense_item_tahakkuk_id1" fieldName="expense_item_tahakkuk_name1" form_name="upd_bond" income_type_info="0" expense_item_id="#get_stockbond_rows.ROW_EXP_TAHAKKUK_ITEM_ID#" img_info="plus_thin">
												</div>
											</div>
										</div> 
										<div class="col col-3 col-md-3 col-sm-3 col-xs-12" id="show-payment-row" style="display:none;">
											<div class="form-group" >
												<div class="col col-8">
													<button class="btn btn-sm" onclick="CreatePaymentRow();ToggleRow();return false;"><cf_get_lang dictionary_id='34276.Getiri Tablosunu Göster'>/ <cf_get_lang dictionary_id='58628'></button>
												</div>
											</div>
										<cfsavecontent variable="msg"><cf_get_lang dictionary_id='33153.Periyodik'> <cf_get_lang dictionary_id='51378.Getiri Tablosu'></cfsavecontent>
											<div class="div_getiri_tablosu" id="div_getiri_tablosu col col-12 col-md-12 col-sm-12 col-xs-12">
												<cf_seperator id="getiri_tablosu" header="#msg#">
												<div class="col col-12 col-md-12 col-sm-12 col-xs-12" id="getiri_tablosu" type="column" index="3" sort="true">
													<div class="col col-12">
														<div class="form-group acc-block-name" id="Th_period" style="display:none;">
															<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id ='51376.Getiri Ödeme Periyodu'> *</label>
															<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
																<select name="getiri_payment_period#currentrow#" id="getiri_payment_period#currentrow#" onchange="specialVisible(this.value);CreatePaymentRow()">
																	<option value=""><cf_get_lang dictionary_id='58693.Seç'></option>
																	<option value="1" <cfif YIELD_PAYMENT_PERIOD EQ 1>SELECTED</cfif>><cf_get_lang dictionary_id='58724.Ay'></option>
																	<option value="2" <cfif YIELD_PAYMENT_PERIOD EQ 2>SELECTED</cfif>>3 <cf_get_lang dictionary_id='58724.Ay'></option>
																	<option value="3" <cfif YIELD_PAYMENT_PERIOD EQ 3>SELECTED</cfif>>6 <cf_get_lang dictionary_id='58724.Ay'></option>
																	<option value="4" <cfif YIELD_PAYMENT_PERIOD EQ 4>SELECTED</cfif>><cf_get_lang dictionary_id='58455.yıl'></option>
																	<option value="6" <cfif YIELD_PAYMENT_PERIOD EQ 6>SELECTED</cfif>><cf_get_lang dictionary_id='33558.Vade Sonu'></option>
																</select>
															</div>
														</div>
													</div>
													<div class="row">
														<div class="col col-12 col-md-12 col-sm-12 col-xs-12" id="getiri_tablosu_head">
															<label class="col col-2 bold"><cf_get_lang dictionary_id='58577.Sıra'></label>
															<label class="col col-6 bold"><cf_get_lang dictionary_id='48897.Hesaba Geçiş Tarihi'></label>
															<label class="col col-4 bold"><cf_get_lang dictionary_id='51374.Getiri Tutarı'></label>
														</div>
													</div>
													<div id="createRow">
														<cfif len(NUMBER_YIELD_COLLECTION)>
															<cfloop from="1" to="#NUMBER_YIELD_COLLECTION#" index="i">
																<div class="col col-12 col-xs-12" id="getiri_tablosu_row<cfoutput>#i#</cfoutput>">
																	<label class="bold col col-2"><cfoutput>#i#</cfoutput></label>
																	<div class="col col-6 col-xs-12">
																		<div class="form-group">
																			<div class="input-group">
																				<cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz !'></cfsavecontent>
																				<cfinput name="bnk_action_date#i#" type="text" value="#dateformat(GET_STOCKBOND.BANK_ACTION_DATE[i],dateformat_style)#" validate="#validate_style#" required="Yes" message="#message#"> 
																				<span class="input-group-addon"><cf_wrk_date_image date_field="bnk_action_date#i#"></span>
																			</div>
																		</div>
																	</div> 
																	<div class="col col-4 col-xs-12">
																		<div class="form-group">
																			<cfsavecontent variable="message1"><cf_get_lang no='83.Miktar Giriniz!'></cfsavecontent>
																			<cfinput type="text" name="getiri_tutari_row#i#" value="#TLFormat(GET_STOCKBOND.AMOUNT[i],2)#" required="yes" message="#message1#" class="moneybox" onkeyup="return(FormatCurrency(this,event));">
																		</div>
																	</div> 
																</div>    
															</cfloop>
														</cfif>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</cfoutput>
						</div>
					</div>
					<div class="row formContentFooter col col-12" id="sepetim_total">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12" id="basket_money_totals_table">
							<div class="totalBox">
								<div class="totalBoxHead font-grey-mint">
									<span class="headText"><cf_get_lang_main no='265.Dövizler'></span>
									<div class="collapse">
									<span class="icon-minus"></span>
									</div>
								</div>
								<div class="totalBoxBody">
									<table>
										<input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#get_action_money.recordcount#</cfoutput>">
										<input type="hidden" name="money_type" id="money_type" value="<cfoutput>#session.ep.money#</cfoutput>">
										<cfif session.ep.rate_valid eq 1>
											<cfset readonly_info = "yes">
										<cfelse>
											<cfset readonly_info = "no">
										</cfif>
										<cfoutput query="get_action_money">
										<tr>
											<td height="17">
												<input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
												<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
												<input type="radio" name="rd_money" id="rd_money" value="#money#" onClick="doviz_hesapla();" <cfif get_bond_action.other_money eq money>checked</cfif>>
											</td>
											<td>#money#</td>
											<td>#TLFormat(rate1,0)#/</td>
											<td>
												<input type="text" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#"<cfif readonly_info>readonly</cfif> class="box" <cfif money eq session.ep.money>readonly="yes"</cfif> value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="doviz_hesapla();">
											</td>
										</tr>
										</cfoutput>
									</table>
								</div>
							</div>
						</div>
						<div class="col col-4 col-md-9 col-sm-9 col-xs-12" id="basket_money_totals_table">
							<div class="totalBox">
								<div class="totalBoxHead font-grey-mint">
									<span class="headText"><cf_get_lang_main no="80.Toplam"></span>
									<div class="collapse">
									<span class="icon-minus"></span>
									</div>
								</div>
								<div class="totalBoxBody">
									<table>
										<cfoutput query="get_bond_action">
											<tr>
												<td width="120"><cf_get_lang no ='87.Alış Toplam'><cfoutput>#session.ep.money#</cfoutput></td>
												<td><input type="text" name="action_value" id="action_value" class="moneybox" value="#TLFormat(net_total,session.ep.our_company_info.rate_round_num)#" style="width:120px;" onBlur="doviz_hesapla();" readonly="yes">&nbsp;</td>
											</tr>
											<tr>
												<td nowrap><cf_get_lang no ='88.Toplam Alis Doviz'><input type="text" name="other_money_info" id="other_money_info" class="box" readonly="readonly" style="width:35px;" value="<cfoutput>#get_bond_action.other_money#</cfoutput>"></td>
												<td><input type="text" name="purchase_other" id="purchase_other" class="moneybox" style="width:120px;"  value="#TLFormat(other_money_value,session.ep.our_company_info.rate_round_num)#" readonly="yes">&nbsp;</td>
											</tr>
											<tr>
												<td><cf_get_lang no ='91.Komisyon Oranı'> %</td>
												<td><input type="text" name="com_rate" id="com_rate" style="width:120px;" class="moneybox" value="#TLFormat(com_rate,session.ep.our_company_info.rate_round_num)#" onBlur="toplam_hesapla();" onkeyup="return(FormatCurrency(this,event));">&nbsp;</td>
											</tr>
											<tr>
												<td nowrap><cf_get_lang no ='93.Komisyon Toplam'><cfoutput>#session.ep.money#</cfoutput></td>
												<td><input type="text" name="com_ytl" id="com_ytl" class="moneybox" style="width:120px;" value="#TLFormat(com_total,session.ep.our_company_info.rate_round_num)#" onBlur="total_doviz_hesapla();">&nbsp;</td>
											</tr>
											<tr>
												<td nowrap><cf_get_lang no ='93.Komisyon Toplam'><input type="text" name="other_money_info1" id="other_money_info1" class="box" readonly=""  style="width:35px;" value="<cfoutput>#get_bond_action.other_money#</cfoutput>"></td>
												<td><input type="text" name="com_other" id="com_other" class="moneybox" style="width:120px;" value="#TLFormat(other_com_total,session.ep.our_company_info.rate_round_num)#" readonly="yes">&nbsp;</td>
											</tr>
										</cfoutput>
									</table>
								</div>
							</div>
						</div>
						<div class="col col-5 col-md-9 col-sm-9 col-xs-12" id="basket_money_totals_table">
							<div class="totalBox">
								<div class="totalBoxHead font-grey-mint">
									<span class="headText"><cf_get_lang dictionary_id='54511.Masraflar'></span>
									<div class="collapse">
									<span class="icon-minus"></span>
									</div>
								</div>
								<div class="totalBoxBody">
									<div class="row">
										<cfoutput query="get_bond_action">
											<div class="form-group" id="item-exp_center_id">
												<label class="col col-4 col-xs-12"><cf_get_lang no ='94.Komisyon Masraf Merkezi'></label>
												<div class="col col-5 col-xs-12">
													<div class="input-group">
														<cfif len(com_exp_center_id)>
															<cfquery name="get_com_main_center" datasource="#dsn2#">
																SELECT EXPENSE,EXPENSE_ID FROM EXPENSE_CENTER WHERE EXPENSE_ID=#com_exp_center_id#
															</cfquery>
														</cfif>
														<input name="com_exp_center_id" id="com_exp_center_id" type="hidden" value="<cfoutput><cfif len(com_exp_center_id)>#get_com_main_center.expense_id#</cfif></cfoutput>">
														<input name="com_exp_center" id="com_exp_center"  style="width:120px;" type="text" value="<cfoutput><cfif len(com_exp_center_id)>#get_com_main_center.expense#</cfif></cfoutput>">
														<span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang_main no='322.Seçiniz'>" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_expense_center&field_name=upd_bond.com_exp_center&field_id=upd_bond.com_exp_center_id&is_invoice=1</cfoutput>','list');"></span>
													</div>
												</div>
											</div>
											<div class="form-group" id="item-exp_item_id">
												<label class="col col-4 col-xs-12"><cf_get_lang no ='95.Komisyon Gider Kalemi'></label>
												<div class="col col-5 col-xs-12">
													<div class="input-group">
														<cfif len(com_exp_item_id)>
															<cfquery name="get_com_main_item" datasource="#dsn2#">
																SELECT EXPENSE_ITEM_NAME,EXPENSE_ITEM_ID FROM EXPENSE_ITEMS WHERE IS_EXPENSE = 1 AND EXPENSE_ITEM_ID=#com_exp_item_id#
															</cfquery>
														</cfif>	
														<input type="hidden" name="com_exp_item_id" id="com_exp_item_id" value="<cfoutput><cfif len(com_exp_item_id)>#get_com_main_item.expense_item_id#</cfif></cfoutput>">
														<input type="text" name="com_exp_item_name" id="com_exp_item_name" value="<cfoutput><cfif len(com_exp_item_id)>#get_com_main_item.expense_item_name#</cfif></cfoutput>"  style="width:120px;" onFocus="AutoComplete_Create('com_exp_item_name','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID,ACCOUNT_CODE,ACCOUNT_CODE','com_exp_item_id,com_acc_name,com_acc_id','upd_bond',3);" autocomplete="off">
														<span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang_main no='322.Seçiniz'>" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=upd_bond.com_exp_item_id&field_name=upd_bond.com_exp_item_name','list');"></span>
													</div>
												</div>
											</div>
											<div class="form-group" id="item-com_acc_code">
												<label class="col col-4 col-xs-12"><cf_get_lang no ='96.Komisyon Muhasebe Kodu'></label>
												<div class="col col-5 col-xs-12">
													<div class="input-group">
														<cf_wrk_account_codes form_name='upd_bond' account_code='com_acc_id' account_name='com_acc_name' search_from_name='1' is_multi_no ='2'>
														<input type="hidden" name="com_acc_id" id="com_acc_id" value="#com_account_code#" style="width:120px;">
														<input type="text" name="com_acc_name" id="com_acc_name" value="#com_account_code#" style="width:120px;" onkeyup="get_wrk_acc_code_2();" onFocus="AutoComplete_Create('com_acc_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','com_acc_id','upd_bond','3','120');" autocomplete="off">
														<span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang_main no='322.Seçiniz'>" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_name=upd_bond.com_acc_name&field_id=upd_bond.com_acc_id','list');"></span>
													</div>
												</div>
											</div>
										</cfoutput>
									</div>
								</div>
							</div>
						</div>
					</div>
					</cf_box_elements>
					<div class="row formContentFooter">
	                    <cf_record_info query_name="get_bond_action">
						<cf_workcube_buttons is_upd='1' add_function='kontrol()' is_delete='1' delete_page_url='#request.self#?fuseaction=credit.emptypopup_del_stockbond_purchase&action_id=#attributes.action_id#&old_process_type=#get_bond_action.process_type#&bank_action_id=#get_bond_action.bank_action_id#'>
                	</div>
	</cfform>
</cf_box>
<script type="text/javascript">

	row_count=<cfoutput>#get_stockbond_rows.recordcount#</cfoutput>;

	for(row=0; row <= row_count; row++){
		if($("select[name=getiri_type"+row+"]").val() == 1 || $("select[name=getiri_type"+row+"]").val() == 3)
		{
			$("div#Th_getiri, div#Th_period, div#show-payment-row, div#th_start_date, div#div_getiri_tablosu, div#Th_odeme_tarihi, div#Th_Getiri_tutari, div#Th_Tahsil_sayisi, div#Th_Getiri_tahsil_tutari, div#Th_butce, div#Th_vade, div#getiri_payment_period_td"+row+", div#getiri_tutari_td"+row+", div#getiri_tahsil_sayisi_td"+row+", div#getiri_tahsil_tutari_td"+row+", div#expense_item_tahakkuk_id_td"+row+", div#getiri_orani_td"+row+", div#getiri_type_td"+row+", div#due_value_td"+row+"").show();
		}
	}

	function ToggleRow(){
			$("div.div_getiri_tablosu").toggle();
		}

function change_paper_duedate(field_name,type,row) 
	{
		paper_date_=eval('document.upd_bond.start_date1.value');
		console.log(paper_date_);
		if(type!=undefined && type==1)
			document.getElementById('due_value1').value = datediff(paper_date_,document.getElementById('due_date1').value,0);
		else
		{
			if(isNumber(document.getElementById('due_value1'))!= false && (document.getElementById('due_value1').value != 0))
				document.getElementById('due_date1').value = date_add('d',+document.getElementById('due_value1').value,paper_date_);
			else
			{
				document.getElementById('due_date1').value = paper_date_;
				if(document.getElementById('due_value1').value == '')
					document.getElementById('due_value1').value = datediff(paper_date_,document.getElementById('due_date1').value,0);
			}
		}

	}
	
function specialVisible(val){

	if(val == 'yield_payment_period') val = $("select[name=yield_payment_period1]").val();
	
	var due_value = $("input[name=due_value1]").val(); // vade günü
	var tutar = filterNum($("input[name=total_purchase1]").val()); // tutar

	if(due_value > 0 ){

		var getiri_orani = filterNum($("input[name=getiri_orani1]").val()); // getiri oranı 
		var getiri_orani_gunluk =  ( ( getiri_orani / 100 ) / $("input[name=ygs1]").val() )  * due_value * tutar ;
		$("input[name=getiri_tutari1]").val( commaSplit( getiri_orani_gunluk ,'2'));		
		var getiri_tutari = filterNum($("input[name=getiri_tutari1]").val()); // getiri tutarı

		var day = 0;
		if(val == 1) day = 30;
		else if(val == 2) day = 90;
		else if(val == 3) day = 180;
		else if(val == 4) day = $("input[name=ygs1]").val();
		else if(val == 6) day = $("input[name=due_value1]").val();
		
		var getiri_odeme_sayisi = Math.floor(due_value / day);
		$("input[name=getiri_tahsil_sayisi1]").val(getiri_odeme_sayisi); // getiri ödeme sayısı

		var getiri_tahsil_tutari = getiri_tutari / getiri_odeme_sayisi;
		$("input[name=getiri_tahsil_tutari1]").val( commaSplit( getiri_tahsil_tutari, '<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')); // getiri tahsil tutarı

	}else{
		alert("<cf_get_lang dictionary_id='50454.Vade Tarihi Girmelisiniz'>"); 
	}

}

	function visiblePeriod(val, row){
		if(val == 1 || val == 3){
			$("div#Th_getiri, div#Th_period, div#Th_odeme_tarihi, div#Th_Getiri_tutari, div#Th_Tahsil_sayisi, div#Th_Getiri_tahsil_tutari, div#Th_butce, div#show-payment-row, div#Th_vade, div#getiri_payment_period_td"+row+", div#getiri_tutari_td"+row+", div#getiri_tahsil_sayisi_td"+row+", div#getiri_tahsil_tutari_td"+row+", div#expense_item_tahakkuk_id_td"+row+", div#getiri_orani_td"+row+", div#getiri_type_td"+row+", div#due_value_td"+row+"").show();
		}
		else{
			$("div#Th_getiri, div#Th_period, div#Th_odeme_tarihi, div#Th_Getiri_tutari, div#Th_Tahsil_sayisi, div#Th_Getiri_tahsil_tutari, div#Th_butce, div#show-payment-row, div#Th_vade, div#getiri_payment_period_td"+row+", div#getiri_tutari_td"+row+", div#getiri_tahsil_sayisi_td"+row+", div#getiri_tahsil_tutari_td"+row+", div#expense_item_tahakkuk_id_td"+row+", div#getiri_orani_td"+row+", div#getiri_type_td"+row+", div#due_value_td"+row+"").hide();
		}
	}

	function CreatePaymentRow(){
           
           var getiri_tahsil_sayisi = $("#getiri_tahsil_sayisi1").val();
           var getiri_tahsil_tutari = filterNum($("#getiri_tahsil_tutari1").val());
           var yield_payment_period = $("select#getiri_payment_period1").val();
           var due_value = parseInt($("#due_value1").val());
		   var action_date = $("input#start_date1").val();

           if(yield_payment_period == 1){
               bank_action_date = date_add("m",1,action_date);               
           }else if(yield_payment_period == 2){
               bank_action_date = date_add("m",3,action_date)
           }else if(yield_payment_period == 3){
               bank_action_date = date_add("m",6,action_date)
           }else if(yield_payment_period == 4){
               bank_action_date = date_add("y",1,action_date)
           }else if(yield_payment_period == 6){
               bank_action_date = date_add("d", due_value ,action_date);
           }
           $("#createRow").html("");
           for(i=1; i <= getiri_tahsil_sayisi; i++){
               $("<div>").addClass("col col-12 col-xs-12").attr({
                   id : "getiri_tablosu_row"
               }).append(
                   $("<label>").addClass("bold col col-2").text(i),
                       $("<div>").addClass("col col-6 col-xs-12").append(
							$("<div>").addClass("form-group").append(
								$("<div>").addClass("input-group").attr({ id : "bnk_action_date"+i+"_td" }).append(
									$("<input>").attr({
										name : "bnk_action_date"+i,
										id : "bnk_action_date"+i,
										value : bank_action_date
									})
								)
						)
                       ),
                       $("<div>").addClass("col col-4 col-xs-12").append(
							$("<div>").addClass("form-group").append(
								$("<input>").attr({
									name : "getiri_tutari_row"+i,
									id : "getiri_tutari_row"+i,
									onkeyup : "LastTotal();return(FormatCurrency(this,event))",
									value : commaSplit(getiri_tahsil_tutari,2)
								}).addClass("moneybox")
						)
                       )
               ).appendTo($("#createRow"));
               wrk_date_image('bnk_action_date'+i+'','',1);

               if(yield_payment_period == 1){
                   bank_action_date = date_add("m",1,bank_action_date)
               }else if(yield_payment_period == 2){
                   bank_action_date = date_add("m",3,bank_action_date)
               }else if(yield_payment_period == 3){
                   bank_action_date = date_add("m",6,bank_action_date)
               }else if(yield_payment_period == 4){
                   bank_action_date = date_add("y",1,bank_action_date)
               }else if(yield_payment_period == 5){
                   bank_action_date = date_add("d",special_day,bank_action_date)
               }else if(yield_payment_period == 6){
                   bank_action_date = date_add("d", due_value ,bank_action_date)
               }
           }
           LastTotal();
	   }
	   
	   function LastTotal(){
		var getiri_tahsil_sayisi = $("#getiri_tahsil_sayisi1").val();
           var lastTotal = 0;

           for(i=1; i <= getiri_tahsil_sayisi; i++){
               lastTotal += parseFloat(filterNum($("#getiri_tutari_row"+i).val()))
           }
           var rowTotal = lastTotal;
            var paymentTotal = filterNum($("#getiri_tutari1").val());
            var ret = paymentTotal - rowTotal;
            console.log(paymentTotal + " " +ret);
            (ret < 0) ? $("#getiri_tutari_row"+getiri_tahsil_sayisi).val( commaSplit(filterNum($("#getiri_tutari_row"+getiri_tahsil_sayisi).val()) - Math.abs(ret)) ) : $("#getiri_tutari_row"+getiri_tahsil_sayisi).val( commaSplit(filterNum($("#getiri_tutari_row"+getiri_tahsil_sayisi).val()) + Math.abs(ret)) );


	   }

function FaizHesapla(fieldName){
	var tutar = filterNum($("input[name=total_purchase1]").val()); // tutar
	var due_value = $("input[name=due_value1]").val(); // vade günü
	var getiri_tutari = filterNum($("input[name=getiri_tutari1]").val()); // getiri tutarı

	if( tutar > 0 && tutar != '' ){
		var getiri_orani = filterNum($("input[name=getiri_orani1]").val()); // getiri oranı 
		var getiri_orani_gunluk =  ( ( getiri_orani / 100 ) / $("input[name=ygs1]").val() )  * due_value * tutar ;

		if(fieldName == 'getiri_orani1') {
			$("input[name=getiri_tutari1]").val( commaSplit( getiri_orani_gunluk ,'2'));
		}else if(fieldName == 'getiri_tutari1'){
			var getiri_orani_currently = ( ( getiri_tutari * $("input[name=ygs1]").val() ) / due_value / ( tutar / 100 ) );
			$("input[name=getiri_orani1]").val( commaSplit( getiri_orani_currently ,'4'));
		}
		
		var day = 0;
		var val = $("select#getiri_payment_period1").val();
		if(val == 1) day = 30;
		else if(val == 2) day = 90;
		else if(val == 3) day = 180;
		else if(val == 4) day = $("input[name=ygs1]").val();
		else if(val == 6) day = $("input[name=due_value1]").val();
		
		due_value = $("input[name=due_value1]").val(); // vade günü
		tutar = filterNum($("input[name=total_purchase1]").val()); // tutar
		getiri_tutari = filterNum($("input[name=getiri_tutari1]").val()); // getiri tutarı

		var getiri_odeme_sayisi = Math.floor(due_value / day);
		$("input[name=getiri_tahsil_sayisi1]").val(getiri_odeme_sayisi); // getiri ödeme sayısı

		var getiri_tahsil_tutari = getiri_tutari / getiri_odeme_sayisi;
		$("input[name=getiri_tahsil_tutari1]").val( commaSplit( getiri_tahsil_tutari,'2') ); // getiri tahsil tutarı
	
	}  
	
}

function hesapla(row_no, val)
{
	purchase_value = document.getElementById("purchase_value"+row_no);
	nominal_value= document.getElementById("nominal_value"+row_no);
	quantity= document.getElementById("quantity"+row_no);
	if(purchase_value.value  == " ") purchase_value.value  = 0;
	if(nominal_value.value  == " ") nominal_value.value  = 0;
	if(quantity.value  == " ") quantity.value  = 1;
	for (var i=1; i<=document.getElementById("kur_say").value; i++)
	{		
		if(document.upd_bond.rd_money[i-1].checked == true)
		{
			form_txt_rate2_ = filterNum(document.getElementById("txt_rate2_"+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/filterNum(document.getElementById("txt_rate1_"+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			if( val == undefined) {
				document.getElementById("other_total_purchase"+row_no).value = commaSplit(filterNum(document.getElementById("total_purchase"+row_no).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/(parseFloat(form_txt_rate2_)),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				document.getElementById("other_purchase_value"+row_no).value = commaSplit(filterNum(document.getElementById("purchase_value"+row_no).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/(parseFloat(form_txt_rate2_)),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				document.getElementById("other_nominal_value"+row_no).value = commaSplit(filterNum(document.getElementById("nominal_value"+row_no).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/(parseFloat(form_txt_rate2_)),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			}else{
				document.getElementById("total_purchase"+row_no).value = commaSplit(filterNum(document.getElementById("other_total_purchase"+row_no).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')*(parseFloat(form_txt_rate2_)),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				document.getElementById("purchase_value"+row_no).value = commaSplit(filterNum(document.getElementById("other_purchase_value"+row_no).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')*(parseFloat(form_txt_rate2_)),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				document.getElementById("nominal_value"+row_no).value = commaSplit(filterNum(document.getElementById("other_nominal_value"+row_no).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')*(parseFloat(form_txt_rate2_)),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			}
		}
	}
	toplam_hesapla();
}
function toplam_hesapla()
{
    var total_amount = 0;
	var other_total_amount = 0;
	for(j=1;j<=document.getElementById("record_num").value;j++)
	{		
		if(document.getElementById("row_kontrol"+j).value==1)
		{
			document.getElementById("total_purchase"+j).value = commaSplit(parseFloat(filterNum(document.getElementById("purchase_value"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'))*parseFloat(filterNum(document.getElementById("quantity"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			document.getElementById("other_total_purchase"+j).value = commaSplit(parseFloat(filterNum(document.getElementById("other_purchase_value"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'))*parseFloat(filterNum(document.getElementById("quantity"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			total_amount += parseFloat(filterNum(document.getElementById("total_purchase"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'));
			other_total_amount += parseFloat(filterNum(document.getElementById("other_total_purchase"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'));
		}
	}
	com_rate = filterNum(document.getElementById("com_rate").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	document.getElementById("action_value").value = commaSplit(total_amount,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	document.getElementById("purchase_other").value = commaSplit(other_total_amount,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	document.getElementById("com_ytl").value =commaSplit(filterNum(document.getElementById("action_value").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')*com_rate/100,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	document.getElementById("com_other").value =commaSplit(filterNum(document.getElementById("purchase_other").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')*com_rate/100,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
}
function doviz_hesapla()
{
	for (var t=1; t<=document.getElementById("kur_say").value; t++)
	{		
		if(document.upd_bond.rd_money[t-1].checked == true)
		{
			for(k=1;k<=document.getElementById("record_num").value;k++)
			{		
				rate2_value = filterNum(document.getElementById("txt_rate2_"+t).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/filterNum(document.getElementById("txt_rate1_"+t).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				document.getElementById("other_nominal_value"+k).value = commaSplit(filterNum(document.getElementById("nominal_value"+k).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/rate2_value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				document.getElementById("other_purchase_value"+k).value = commaSplit(filterNum(document.getElementById("purchase_value"+k).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/rate2_value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				document.getElementById("other_total_purchase"+k).value = commaSplit(filterNum(document.getElementById("total_purchase"+k).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/rate2_value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				document.getElementById("purchase_other").value = commaSplit(filterNum(document.getElementById("action_value").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/rate2_value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			}
			document.getElementById("other_money_info").value = document.upd_bond.rd_money[t-1].value;
			document.getElementById("other_money_info1").value = document.upd_bond.rd_money[t-1].value;
		}
	}
	toplam_hesapla();
}
function total_doviz_hesapla()
{
	for (var t=1; t<=document.getElementById("kur_say").value; t++)
	{		
		if(document.upd_bond.rd_money[t-1].checked == true)
		{
			rate2_value = filterNum(document.getElementById("txt_rate2_"+t).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/filterNum(document.getElementById("txt_rate1_"+t).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			document.getElementById("com_other").value = commaSplit(filterNum(document.getElementById("com_ytl").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/rate2_value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			document.getElementById("com_ytl").value = commaSplit(filterNum(document.getElementById("com_ytl").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
	}
}
function connectAjax(stockbond_id)
	{
		cfmodal('<cfoutput>#request.self#?fuseaction=credit.ajax_stockbond_value_currently</cfoutput>&stockbond_id='+stockbond_id, 'warning_modal');
	}

function kontrol()
{	
	var record_exist=0;
	if(!chk_process_cat('upd_bond')) return false;
	if(!check_display_files('upd_bond')) return false;
	if(document.getElementById("comp_name").value == "" && document.getElementById("account_id").value == "")			
	{
		alert("Cari ya da Banka Seçeneklerinden En Az Birini Seçmelisiniz");
		return false;
	}
	if(document.getElementById("comp_name").value != "" && document.getElementById("account_id").value != "")			
	{
		alert("Cari ve Banka Birlikte Seçilemez");
		return false;
	}
	if(document.getElementById("paper_no").value=="")
	{
		alert("<cf_get_lang_main no ='1144.Belge No Girmelisiniz'> !");
		return false;
	}
	if(document.getElementById("paper_no").value != "")
	{
		var get_paper_record = wrk_safe_query('get_paper_record','dsn3',0,document.getElementById("paper_no").value); 
		if(get_paper_record.recordcount > 1)
		{ 
			alert("Girdiğiniz Belge No Kullanılıyor!");
			return false;
		}
	}
	process=document.upd_bond.process_cat.value;
	var get_process_cat = wrk_safe_query('ch_get_process_cat','dsn3',0,process);
	if(get_process_cat.IS_ACCOUNT ==1)
	{			
		if (document.getElementById("acc_id").value=="" || document.getElementById("acc_name").value=="")
		{ 
			alert("Muhasebe Kodu Giriniz!");
			return false;
		}
	}
		
	for(r=1;r<=document.getElementById("record_num").value;r++)
	{
		if(document.getElementById("row_kontrol"+r).value==1)
			{
				record_exist=1;
				if (document.getElementById("bond_type"+r).value == "")
				{ 
					alert ("<cf_get_lang no ='98.Lütfen Menkul Kıymet Tipi Seçiniz'>!");
					return false;
				}
				if (document.getElementById("bond_code"+r).value == "")
				{ 
					alert ("<cf_get_lang no ='99.Lütfen Menkul Kıymet Kodu Giriniz'>!");
					return false;
				}
				if (document.getElementById("getiri_type"+r).value == 1)
				{ 
					if (document.getElementById("expense_item_tahakkuk_id"+r).value == "")
					{ 
						alert("<cf_get_lang dictionary_id='49131.Bütçe Kalemi Girmelisiniz'>!");
						return false;
					}
					if (document.getElementById("getiri_orani"+r).value == "")
					{ 
						alert("<cf_get_lang dictionary_id='33550.Getiri Oranı Girmelisiniz'>!");
						return false;
					}
					if (document.getElementById("getiri_payment_period"+r).value == "")
					{ 
						alert("<cf_get_lang dictionary_id='33551.Getiri Ödeme Periyodu'>!");
						return false;
					}
					if (document.getElementById("due_value"+r).value == "")
					{ 
						alert("<cf_get_lang dictionary_id='48828.Vade Girmelisiniz'>!");
						return false;
					}
					if (document.getElementById("getiri_tutari"+r).value == "")
					{ 
						alert("<cf_get_lang dictionary_id='33553.Getiri Tutarı Girmelisiniz'>!");
						return false;
					}
					if (document.getElementById("getiri_tahsil_sayisi"+r).value == "")
					{ 
						alert("<cf_get_lang dictionary_id='33554.Getiri Tahsil Sayısı Girmelisiniz'>!");
						return false;
					}
					if (document.getElementById("getiri_tahsil_tutari"+r).value == "")
					{ 
						alert("<cf_get_lang dictionary_id='33555.Getiri Tahsil Tutarı Girmelisiniz'>!");
						return false;
					}
					if (document.getElementById("expense_item_id"+r).value == "")
					{ 
						alert("<cf_get_lang dictionary_id='49131.Bütçe Kalemi Girmelisiniz'>");
						return false;
					}
					if (document.getElementById("expense_center_id"+r).value == "")
					{ 
						alert("<cf_get_lang dictionary_id='48225.Masraf Merkezi Girmelisiniz'>!");
						return false;
					}

				}
				if (document.getElementById("row_detail"+r).value == "")
				{ 
					alert ("<cf_get_lang no ='100.Lütfen Açıklama Giriniz'>!");
					return false;
				}
				if ((document.getElementById("nominal_value"+r).value == "")||(document.getElementById("nominal_value"+r).value ==0))
				{ 
					alert ("<cf_get_lang no ='101.Lütfen Nominal Değer Giriniz'>!");
					return false;
				}
				if ((document.getElementById("purchase_value"+r).value == "")||(document.getElementById("purchase_value"+r).value ==0))
				{ 
					alert ("<cf_get_lang no ='102.Lütfen Alış Değeri Giriniz'>!");
					return false;
				}
			}
	}
	if (record_exist == 0) 
	{
		alert("<cf_get_lang no ='103.Lütfen Satır Giriniz'>!");
		return false;
	}
	return unformat_fields();
}
function unformat_fields()
{
	for(rm=1;rm<=document.getElementById("record_num").value;rm++)
	{
		document.getElementById("nominal_value"+rm).value =  filterNum(document.getElementById("nominal_value"+rm).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("purchase_value"+rm).value =  filterNum(document.getElementById("purchase_value"+rm).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("total_purchase"+rm).value =  filterNum(document.getElementById("total_purchase"+rm).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("other_nominal_value"+rm).value =  filterNum(document.getElementById("other_nominal_value"+rm).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("other_purchase_value"+rm).value =  filterNum(document.getElementById("other_purchase_value"+rm).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("quantity"+rm).value =  filterNum(document.getElementById("quantity"+rm).value,'4'); <!--- miktar alanı yeniden formatlanıyor.  --->
		document.getElementById("other_total_purchase"+rm).value =  filterNum(document.getElementById("other_total_purchase"+rm).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');

		document.getElementById("getiri_orani"+rm).value =  filterNum(document.getElementById("getiri_orani"+rm).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("getiri_tutari"+rm).value =  filterNum(document.getElementById("getiri_tutari"+rm).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("getiri_tahsil_tutari"+rm).value =  filterNum(document.getElementById("getiri_tahsil_tutari"+rm).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	}
	for(var i=1;i<=document.getElementById("getiri_tahsil_sayisi1").value;i++)
		{
			inp_getiri_tahsil_tutari = $("input[name=getiri_tutari_row"+i+"]");
			inp_getiri_tahsil_tutari.val( filterNum( inp_getiri_tahsil_tutari.val(),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'));
		}

	document.getElementById("action_value").value = filterNum(document.getElementById("action_value").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	document.getElementById("purchase_other").value = filterNum(document.getElementById("purchase_other").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	document.getElementById("com_rate").value = filterNum(document.getElementById("com_rate").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	document.getElementById("com_ytl").value = filterNum(document.getElementById("com_ytl").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	document.getElementById("com_other").value = filterNum(document.getElementById("com_other").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	for(st=1;st<=document.getElementById("kur_say").value;st++)
	{
		document.getElementById("txt_rate2_"+ st).value = filterNum(document.getElementById("txt_rate2_"+ st).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("txt_rate1_"+ st).value = filterNum(document.getElementById("txt_rate1_"+ st).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	}
}

	$(function(){
        var count = 0;
       	$('.collapse').click(function(){
            
            if(count == 0){
                $(this).parent().parent().find('.totalBoxBody').slideUp();
                $(this).find("span").removeClass().addClass("icon-pluss");
                count++;
            }
            else{
                $(this).parent().parent().find('.totalBoxBody').slideDown();
                $(this).find("span").removeClass().addClass("icon-minus");
                count = 0;
            }
       });
    })
</script>
	
