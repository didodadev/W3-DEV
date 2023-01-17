<cfparam name="company_id" default="">
<cfparam name="company_name" default="">
<cfparam name="partner_id" default="">
<cfparam name="company_partner_name" default="">
<cfparam name="company_partner_surname" default="">

<cf_papers paper_type = "BUYING_SECURITIES">
<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1
</cfquery>
<cfquery name="GET_STOCKBOND_TYPES" datasource="#dsn#">
	SELECT * FROM SETUP_STOCKBOND_TYPE
</cfquery>
<cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
	SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE IS_EXPENSE = 1 ORDER BY EXPENSE_ITEM_NAME
</cfquery>
<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
	SELECT EXPENSE_ID, EXPENSE_CODE, EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ACTIVE = 1 ORDER BY EXPENSE
</cfquery>
	
	<cfif isdefined("attributes.stockbond_id") and len(attributes.stockbond_id)>
		<cfquery name="stockbond_copy" datasource="#dsn3#">
			SELECT
				*,
				SS.DETAIL AS SS_DETAIL
			FROM
				STOCKBONDS AS ST
			LEFT JOIN STOCKBONDS_SALEPURCHASE_ROW AS SSP ON ST.STOCKBOND_ID = SSP.STOCKBOND_ID
			LEFT JOIN STOCKBONDS_SALEPURCHASE AS SS ON SS.ACTION_ID = SSP.SALES_PURCHASE_ID
			WHERE 
				ST.STOCKBOND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stockbond_id#">
		</cfquery>

		<cfif len(stockbond_copy.COMPANY_ID)>
			<cfquery name="GET_COMP_NAME" datasource="#dsn#">
				SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID = #stockbond_copy.COMPANY_ID#
			</cfquery>
			<cfset company_name = GET_COMP_NAME.FULLNAME>
		</cfif>
		<cfif len(stockbond_copy.partner_id) and len(stockbond_copy.company_id)>
			<cfquery name="GET_PARTNER" datasource="#dsn#">
				SELECT 
					PARTNER_ID,
					COMPANY_PARTNER_NAME,
					COMPANY_PARTNER_SURNAME
				FROM 
					COMPANY_PARTNER
				WHERE 
					PARTNER_ID= #stockbond_copy.partner_id#
			</cfquery>
			<cfset partner_id = GET_PARTNER.partner_id>
			<cfset company_partner_name = GET_PARTNER.COMPANY_PARTNER_NAME>
			<cfset company_partner_surname = GET_PARTNER.COMPANY_PARTNER_SURNAME>
		</cfif>

		<cfset process_cat = stockbond_copy.PROCESS_CAT>
		<cfset company_id = stockbond_copy.COMPANY_ID>
		<cfset ref_no = stockbond_copy.REF_NO>
		<cfset broker_company = stockbond_copy.BROKER_COMPANY>
		<cfset detail = stockbond_copy.SS_DETAIL>
		<cfset bank_acc_id = stockbond_copy.BANK_ACC_ID>
		<cfset get_stockbond_type = stockbond_copy.STOCKBOND_TYPE>
		<cfset get_stockbond_code = stockbond_copy.STOCKBOND_CODE>
		<cfset row_detail = stockbond_copy.DETAIL>
		<cfset get_nominal_value = stockbond_copy.NOMINAL_VALUE>
		<cfset get_other_nominal_value = stockbond_copy.OTHER_NOMINAL_VALUE>
		<cfset get_purchase_value = stockbond_copy.PURCHASE_VALUE>
		<cfset get_other_purchase_value = stockbond_copy.OTHER_PURCHASE_VALUE>
		<cfset quantity = stockbond_copy.QUANTITY>
		<cfset get_total_purchase = stockbond_copy.TOTAL_PURCHASE>
		<cfset get_other_total_purchase = stockbond_copy.OTHER_TOTAL_PURCHASE>
		<cfset exp_center_id = stockbond_copy.EXP_CENTER_ID>
		<cfset exp_item_id = stockbond_copy.EXP_ITEM_ID>
		<cfset get_acc_code = stockbond_copy.ACCOUNT_CODE> 
		<cfset getiri_type = stockbond_copy.YIELD_TYPE>
		<cfset due_value = stockbond_copy.DUE_VALUE>
		<cfset due_date = stockbond_copy.DUE_DATE>
		<cfset yield_rate = stockbond_copy.YIELD_RATE>
		<cfset yield_payment_period = stockbond_copy.YIELD_PAYMENT_PERIOD>
		<cfset number_yield_collection = stockbond_copy.NUMBER_YIELD_COLLECTION>
		<cfset yield_amount = stockbond_copy.YIELD_AMOUNT>
		<cfset yield_total_amount = stockbond_copy.YIELD_AMOUNT_TOTAL>
		<cfset row_exp_tahakkuk_id = stockbond_copy.ROW_EXP_TAHAKKUK_ITEM_ID>
	<cfelse>
		<cfset process_cat = "">
		<cfset company_id = "">
		<cfset company_name = "">
		<cfset partner_id = "">
		<cfset company_partner_name = "">
		<cfset company_partner_surname = "">
		<cfset ref_no = "">
		<cfset broker_company = "">
		<cfset detail = "">
		<cfset bank_acc_id = "">
		<cfset get_stockbond_type = "">
		<cfset get_stockbond_code = "">
		<cfset row_detail = "">
		<cfset get_nominal_value = 0>
		<cfset get_other_nominal_value = 0>
		<cfset get_purchase_value = 0>
		<cfset get_other_purchase_value = 0>
		<cfset quantity = 1>
		<cfset get_total_purchase = 0>
		<cfset get_other_total_purchase = 0>
		<cfset exp_center_id = "">
		<cfset exp_item_id = "">
		<cfset get_acc_code = "">
		<cfset getiri_type = "">
		<cfset due_value = 0>
		<cfset due_date = now()>
		<cfset yield_rate = "">
		<cfset yield_payment_period = 6>
		<cfset number_yield_collection = 0>
		<cfset yield_amount = 0>
		<cfset yield_total_amount = 0>
		<cfset row_exp_tahakkuk_id = "">
	</cfif>

	<cf_catalystHeader>		
		<cf_box>	
			<cfform name="add_bond" method="post" action="#request.self#?fuseaction=credit.emptypopup_add_stockbond_purchase">
				<cf_box_elements vertical="1">
				<cfsavecontent variable="nowdate"><cfoutput>#dateformat(now(),dateformat_style)#</cfoutput></cfsavecontent>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-islem">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no ='388.İşlem Tipi'>*</label>
							<div class="col col-8 col-xs-12">
								<cf_workcube_process_cat slct_width="125" process_cat="#process_cat#">
							</div>
						</div>
						<div class="form-group" id="item-company_id">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no ='107.Cari Hesap'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#company_id#</cfoutput>">
									<input type="text" name="comp_name" id="comp_name" value="<cfoutput>#company_name#</cfoutput>" onFocus="AutoComplete_Create('comp_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'\',\'\',\'\',\'\',\'\',\'\',\'1\'','COMPANY_ID,PARTNER_ID,MEMBER_PARTNER_NAME','company_id,partner_id,partner_name','','3','250');" autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang_main no='322.Seçiniz'>" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2&field_name=add_bond.partner_name&field_partner=add_bond.partner_id&field_comp_name=add_bond.comp_name&field_comp_id=add_bond.company_id</cfoutput>','list');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-partner_id">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no ='166.Yetkili'></label>
							<div class="col col-8 col-xs-12">
								<input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#partner_id#</cfoutput>">
								<input type="text" name="partner_name" id="partner_name" value="<cfoutput>#company_partner_name# #company_partner_surname#</cfoutput>">
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-paper_no">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no ='468.Belge No'>*</label>
							<div class="col col-8 col-xs-12">
								<cfinput type="text" name="paper_no" id="paper_no" value="#paper_code & '-' & paper_number#" maxlength="50" style="width:80px;" required="yes" message="Belge No Girmelisiniz">
							</div>
						</div>
						<div class="form-group" id="item-action_date">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no ='330.Tarih'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfinput type="text" name="action_date" id="action_date" validate="#validate_style#" onchange="change_paper_duedate('action_date',1);specialVisible('yield_payment_period');FaizHesapla('getiri_tutari1');" onBlur="FaizHesapla('getiri_tutari1');change_money_info('add_bond','action_date');" value="#dateformat(now(),dateformat_style)#" maxlength="10" style="width:80px;" required="yes" message="Tarih Girmelisiniz!">
									<span class="input-group-addon"><cf_wrk_date_image date_field="action_date" call_function="change_money_info"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-ref_no">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='1382.Referans No'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="ref_no" id="ref_no" value="<cfoutput>#ref_no#</cfoutput>" style="width:80px;">
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
						<div class="form-group" id="item-broker_company">
							<label class="col col-4 col-xs-12"><cf_get_lang no ='85.Aracı Kurum'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="broker_company" id="broker_company" value="<cfoutput>#broker_company#</cfoutput>" maxlength="50">
							</div>
						</div>
						<div class="form-group" id="item-employee_id">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no ='1174.İşlem Yapan'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
									<input type="text" name="employee" id="employee" value="<cfoutput>#session.ep.name# #session.ep.surname#</cfoutput>">
									<span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang_main no ='1174.İşlem Yapan'>" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_bond.employee_id&field_name=add_bond.employee&select_list=1</cfoutput>','list');"></span>
								</div>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
						<div class="form-group" id="item-detail">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no ='217.Açıklama'></label>
							<div class="col col-8 col-xs-12">
								<textarea name="detail" id="detail" style="width:285px;height:50px;"><cfoutput>#detail#</cfoutput></textarea>
							</div>
						</div>
						<div class="form-group" id="item-account_id">
							<label class="col col-4 col-xs-12"><cf_get_lang_main no='1652.Banka Hesabı'></label>
							<div class="col col-8 col-xs-12">
								<cfinclude template="../query/get_accounts.cfm">
								<select name="account_id" id="account_id" style="width:285px;">
									<option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
									<cfoutput query="get_accounts">
										<option value="#account_id#;#account_currency_id#" <cfif bank_acc_id eq account_id>selected</cfif>>#account_name#-#account_currency_id#</option>
									</cfoutput>
								</select>
							</div>
						</div>
					</div>
					<div class="ui-card col col-12">
						<input name="record_num" id="record_num" type="hidden" value="1">
						<input  type="hidden"  value="1"  name="row_kontrol1" id="row_kontrol1" >
						<div id="table_list">
							<div class="ui-card-item " id="block_row_1">
								<div class="acc-body">
									<div class="col col-2 col-md-3 col-sm-3 col-xs-12">
										<div class="form-group acc-block-name large">
											<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang_main no ='218.Tip'>* </label>
											<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
												<select name="bond_type1" id="bond_type1">
													<option value=""><cf_get_lang no ='83.Menkul Kıymet Tipi'></option>
													<cfloop query="get_stockbond_types">
														<option value="<cfoutput>#stockbond_type_id#</cfoutput>" <cfif get_stockbond_type eq stockbond_type_id> selected</cfif>><cfoutput>#stockbond_type#</cfoutput></option>
													</cfloop>
												</select>
											</div>
										</div>
										<div class="form-group acc-block-name">
											<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang_main no ='1173.Kod'>* </label>
											<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
												<input type="text" name="bond_code1" id="bond_code1" value="<cfoutput>#get_stockbond_code#</cfoutput>">
											</div>
										</div>
										<div class="form-group acc-block-name">
											<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang_main no ='217.Açıklama'>* </label>
											<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
												<input type="text" name="row_detail1" id="row_detail1" value="<cfoutput>#row_detail#</cfoutput>">
											</div>
										</div>
										<div class="form-group acc-block-name">
											<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang no ='77.Nominal Değer'>* </label>
											<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
												<input type="text" class="moneybox" name="nominal_value1" id="nominal_value1" onBlur="hesapla(1);" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" value="<cfoutput>#TLFormat(get_nominal_value,session.ep.our_company_info.rate_round_num)#</cfoutput>">
											</div>
										</div>
										<div class="form-group acc-block-name">
											<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang no ='78.Nominal Değer Döviz'> </label>
											<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
												<input type="text" class="moneybox" name="other_nominal_value1" id="other_nominal_value1" onBlur="hesapla(1,1);" value="<cfoutput>#TLFormat(get_other_nominal_value,session.ep.our_company_info.rate_round_num)#</cfoutput>">
											</div>
										</div>
									</div>
									<div class="col col-2 col-md-3 col-sm-3 col-xs-12">
										<div class="form-group acc-block-name">
											<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang no ='79.Alış Değer'> *</label>
											<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
												<input type="text" class="moneybox" name="purchase_value1" id="purchase_value1" value="<cfoutput>#TLFormat(get_purchase_value,session.ep.our_company_info.rate_round_num)#</cfoutput>" onBlur="hesapla(1);FaizHesapla('getiri_tutari1');" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));">
											</div>
										</div>
										<div class="form-group acc-block-name">
											<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang no ='80.Alış Değer Döviz'></label>
											<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
												<input type="text" class="moneybox" name="other_purchase_value1" id="other_purchase_value1" onBlur="hesapla(1,1);FaizHesapla('getiri_tutari1');" value="<cfoutput>#TLFormat(get_other_purchase_value,session.ep.our_company_info.rate_round_num)#</cfoutput>">
											</div>
										</div>
										<div class="form-group acc-block-name">
											<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang_main no ='223.Miktar'></label>
											<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
												<input type="text" class="moneybox" name="quantity1" id="quantity1" onBlur="hesapla(1);" value="<cfoutput>#quantity#</cfoutput>" onkeyup="return(FormatCurrency(this,event,4));">
											</div>
										</div>
										<div class="form-group acc-block-name">
											<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang no ='87.Toplam Alış'></label>
											<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
												<input type="text" class="moneybox" name="total_purchase1" id="total_purchase1" onkeyup="return(FormatCurrency(this,event));" onBlur="hesapla(1);" readonly="yes" value="<cfoutput>#TLFormat(get_total_purchase,session.ep.our_company_info.rate_round_num)#</cfoutput>">
											</div>
										</div>
										<div class="form-group acc-block-name">
											<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang no ='88.Toplam Alış Döviz'></label>
											<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
												<input type="text" class="moneybox" name="other_total_purchase1" id="other_total_purchase1" readonly="yes" value="<cfoutput>#TLFormat(get_other_total_purchase,session.ep.our_company_info.rate_round_num)#</cfoutput>">
											</div>
										</div>
									</div>
									<div class="col col-2 col-md-3 col-sm-3 col-xs-12">
										<div class="form-group acc-block-name">
											<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang no ='89.Masraf Gelir Merkezi'>* </label>
											<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
												<cf_wrkExpenseCenter fieldId="expense_center_id1" fieldName="expense_center_name1" form_name="add_bond" img_info="plus_thin" expense_center_id="#exp_center_id#">
											</div>
										</div>
										<div class="form-group acc-block-name">
											<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang_main no='822.Bütçe Kalemi'>*</label>
											<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
												<cf_wrkExpenseItem fieldId="expense_item_id1" fieldName="expense_item_name1" form_name="add_bond" income_type_info="1" img_info="plus_thin" expense_item_id="#exp_item_id#">
											</div>
										</div>
										<div class="form-group acc-block-name" id="item-account_code">
											<label class="col col-12 col-xs-12"><cf_get_lang_main no='1399.Muhasebe Kodu'></label>
											<div class="col col-12 col-xs-12">
												<div class="input-group">
													<cf_wrk_account_codes form_name='add_bond' account_code='acc_id' account_name='acc_name' search_from_name='1'>			
													<input type="hidden" name="acc_id" id="acc_id" value="<cfoutput>#get_acc_code#</cfoutput>">
													<cfinput type="text" name="acc_name" id="acc_name" value="#get_acc_code#" onkeyup="get_wrk_acc_code_1();" onFocus="AutoComplete_Create('acc_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','acc_id','add_bond','3','120');" autocomplete="off">
													<span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang_main no='322.Seçiniz'>" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_name=add_bond.acc_name&field_id=add_bond.acc_id','list');"></span>
												</div>
											</div>
										</div>
										<div class="form-group acc-block-name" id="Th_getiri_tipi">
											<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id ='40995.Getiri Tipi'></label>
											<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
												<select name="getiri_type1" id="getiri_type1" onchange="visiblePeriod(this.value, '1')">
													<option value=""><cf_get_lang dictionary_id='58693.Seç'></option>
													<option value="1" <cfif getiri_type eq 1> selected </cfif>><cf_get_lang dictionary_id='60511.Sabit Getirili'></option>
													<option value="2" <cfif getiri_type eq 2> selected </cfif>><cf_get_lang dictionary_id='60512.Piyasa Değeri ve Temettülü'></option>
													<option value="3" <cfif getiri_type eq 3> selected </cfif>><cf_get_lang dictionary_id='64562.Likit Fon'></option>
												</select>
											</div>
										</div>
										<div class="form-group acc-block-name" id="th_start_date" style="display:none;">
											<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='58053.Baslangıç Tarihi'>*</label>
											<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
												<div class="input-group">
													<cfinput type="text" name="start_date1" id="start_date1" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" maxlength="10" onchange="change_paper_duedate('start_date1',1);specialVisible('yield_payment_period');FaizHesapla('getiri_tutari1');" onBlur="FaizHesapla('getiri_tutari1');">
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
													<input type="text" name="due_value1" id="due_value1" maxlength="50" value="<cfoutput>#due_value#</cfoutput>" onchange="change_paper_duedate('start_date1');specialVisible('yield_payment_period');FaizHesapla('getiri_tutari1');">
													<span class="input-group-addon no-bg"></span>
													<cfinput type="text" name="due_date1" id="due_date1" value="#dateformat(due_date,dateformat_style)#" validate="#validate_style#" maxlength="10" onChange="change_paper_duedate('start_date1',1);specialVisible('yield_payment_period');FaizHesapla('getiri_tutari1');">
													<span class="input-group-addon"><cf_wrk_date_image date_field="due_date1"></span>
												</div>
											</div>
										</div>
										<div class="form-group acc-block-name" id="Th_getiri" style="display:none;">
											<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
												<div class="input-group">
													<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='51373.Getiri Oranı'>*</label>
													<input type="text" class="moneybox" name="getiri_orani1" id="getiri_orani1" value="<cfoutput>#TLFormat(yield_rate)#</cfoutput>" onkeyup="return(FormatCurrency(this,event));" onchange="FaizHesapla(this.value,'1')" onblur="FaizHesapla('getiri_orani1')">
													<span class="input-group-addon no-bg"></span>
													<label class="col col-12 col-md-12 col-sm-12 col-xs-12">YGS *</label>
													<cfinput type="number" name="ygs1" class="moneybox" value="365" onblur="FaizHesapla('getiri_orani1');" onkeyup="FaizHesapla('getiri_orani1');return(FormatCurrency(this,event));">
												</div>
											</div>
										</div>
										<div class="form-group acc-block-name" id="Th_Getiri_tahsil_tutari" style="display:none;">
											<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
												<div class="input-group">
													<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='60103.Tahsil Sayısı'> *</label>
													<input readonly type="text" class="moneybox" name="getiri_tahsil_tutari1" id="getiri_tahsil_tutari1" value="<cfoutput>#TLFormat(yield_amount,session.ep.our_company_info.rate_round_num)#</cfoutput>" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));">
													<span class="input-group-addon no-bg"></span>
													<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='60102.Tahsil Sayısı'> *</label>
													<input readonly type="text" class="moneybox" name="getiri_tahsil_sayisi1" id="getiri_tahsil_sayisi1" value="<cfoutput>#number_yield_collection#</cfoutput>" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));">
												</div>
											</div>
										</div>
										<div class="form-group acc-block-name" id="Th_Getiri_tutari" style="display:none;">
											<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id="51374.Getiri Tutarı">*</label>
											<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
												<input type="text" class="moneybox" name="getiri_tutari1" id="getiri_tutari1" value="<cfoutput>#TLFormat(yield_total_amount,session.ep.our_company_info.rate_round_num)#</cfoutput>" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));">
											</div>
										</div>
										<div class="form-group acc-block-name" id="Th_butce" style="display:none;">
											<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang_main no='822.Bütçe Kalemi'> <cf_get_lang dictionary_id='34760.Tahakkuk'> *</label>
											<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
												<cf_wrkExpenseItem fieldId="expense_item_tahakkuk_id1" fieldName="expense_item_tahakkuk_name1" expense_item_id="#row_exp_tahakkuk_id#" form_name="add_bond" income_type_info="0" img_info="plus_thin">
											</div>
										</div>
										
									</div> 
									<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
										<div class="form-group" id="show-payment-row" style="display:none;">
											<div class="col col-8">
												<button class="btn btn-sm" onclick="CreatePaymentRow();ToggleRow();return false;"><cf_get_lang dictionary_id='34276.Getiri Tablosunu Göster'>/ <cf_get_lang dictionary_id='58628'></button>
											</div>
										</div>
									<cfsavecontent variable="msg"><cf_get_lang dictionary_id='33153.Periyodik'> <cf_get_lang dictionary_id='51378.Getiri Tablosu'></cfsavecontent>
										<div class="div_getiri_tablosu" id="div_getiri_tablosu col col-12 col-md-12 col-sm-12 col-xs-12" style="display:none;">
											<cf_seperator id="getiri_tablosu" header="#msg#">
											<div class="col col-12 col-md-12 col-sm-12 col-xs-12" id="getiri_tablosu" type="column" index="3" sort="true">
												<div class="col col-12">
													<div class="form-group acc-block-name large" id="Th_period" style="display:none;">
														<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id ='51376.Getiri Ödeme Periyodu'> *</label>
														<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
															<select name="getiri_payment_period1" id="getiri_payment_period1" onchange="specialVisible(this.value);CreatePaymentRow();">
																<option value=""><cf_get_lang dictionary_id='58693.Seç'></option>
																<option value="1" <cfif yield_payment_period eq 1> selected </cfif>><cf_get_lang dictionary_id='58724.Ay'></option>
																<option value="2" <cfif yield_payment_period eq 2> selected </cfif>>3 <cf_get_lang dictionary_id='58724.Ay'></option>
																<option value="3" <cfif yield_payment_period eq 3> selected </cfif>>6 <cf_get_lang dictionary_id='58724.Ay'></option>
																<option value="4" <cfif yield_payment_period eq 4> selected </cfif>><cf_get_lang dictionary_id='58455.yıl'></option>
																<option value="6" <cfif yield_payment_period eq 6> selected </cfif>><cf_get_lang dictionary_id='33558.Vade Sonu'></option>
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
													
												</div>
											</div>
										</div>
								</div>
							</div>

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
										<input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#get_money.recordcount#</cfoutput>">
										<input type="hidden" name="money_type" id="money_type" value="<cfoutput>#session.ep.money#</cfoutput>">
										<cfoutput>
											<cfif len(session.ep.money)>
												<cfset selected_money=session.ep.money>
											</cfif>
											<cfif session.ep.rate_valid eq 1>
												<cfset readonly_info = "yes">
											<cfelse>
												<cfset readonly_info = "no">
											</cfif>
											<cfloop query="get_money">
											<tr>
												<td>
													<input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
													<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
												</td>
												<td nowrap="nowrap">
													<input type="radio" name="rd_money" id="rd_money" value="#money#" onClick="doviz_hesapla();" <cfif selected_money eq money>checked</cfif>>#money#
												</td>
												<td>#TLFormat(rate1,0)#/</td>
												<td nowrap="nowrap">
													#TLFormat(rate1,0)#/<input type="text" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" <cfif readonly_info>readonly</cfif> class="box" <cfif money eq session.ep.money>readonly="yes"</cfif> value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="doviz_hesapla();">
												</td>
											</tr>
											</cfloop>
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
										<tr>
											<td width="120"><cf_get_lang no ='87.Toplam Alis'><input type="text" name="other_money_info2" id="other_money_info2" class="box" readonly=""  style="width:35px;" value="<cfoutput>#session.ep.money#</cfoutput>"></td>
											<td><input type="text" name="action_value" id="action_value" class="moneybox" value="0" style="width:120px;" onBlur="doviz_hesapla();" readonly="yes">&nbsp;</td>
										</tr>
										<tr>
											<td><cf_get_lang no ='88.Toplam Alis Doviz'><input type="text" name="other_money_info" id="other_money_info" class="box" readonly="" style="width:35px;" value="<cfoutput>#session.ep.money2#</cfoutput>"></td>
											<td><input type="text" name="purchase_other" id="purchase_other" class="moneybox" style="width:120px;"  value="0" readonly="yes">&nbsp;</td>
										</tr>
										<tr>
											<td><cf_get_lang no ='91.Komisyon Oranı'>%</td>
											<td><input type="text" name="com_rate" id="com_rate" style="width:120px;" class="moneybox" value="0" onBlur="toplam_hesapla();" onkeyup="return(FormatCurrency(this,event));">&nbsp;</td>
										</tr>
										<tr>
											<td nowrap="nowrap"><cf_get_lang no ='93.Komisyon Toplam'><input type="text" name="other_money_info3" id="other_money_info3" class="box" readonly=""  style="width:35px;" value="<cfoutput>#session.ep.money#</cfoutput>"></td>
											<td><input type="text" name="com_ytl" id="com_ytl" class="moneybox" style="width:120px;" value="0" onBlur="total_doviz_hesapla();">&nbsp;</td>
										</tr>
										<tr>
											<td><cf_get_lang no ='93.Komisyon Toplam'><input type="text" name="other_money_info1" id="other_money_info1" class="box" readonly=""  style="width:35px;" value="<cfoutput>#session.ep.money2#</cfoutput>"></td>
											<td><input type="text" name="com_other" id="com_other"  class="moneybox" style="width:120px;" value="0" readonly="yes">&nbsp;</td>
										</tr>
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
								<div class="row">
									<div class="totalBoxBody">
									<div class="form-group" id="item-exp_center_id">
										<label class="col col-4 col-xs-12"><cf_get_lang no ='94.Komisyon Masraf Merkezi'></label>
										<div class="col col-5 col-xs-12">
											<div class="input-group">
												<input name="com_exp_center_id" id="com_exp_center_id" type="hidden" value="">
												<cfinput name="com_exp_center" id="com_exp_center" style="width:120px;" type="text" value="">
												<span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang_main no='322.Seçiniz'>" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_expense_center&field_name=add_bond.com_exp_center&field_id=add_bond.com_exp_center_id&is_invoice=1</cfoutput>','list');"></span>
											</div>
										</div>
									</div>
									<div class="form-group" id="item-exp_item_id">
										<label class="col col-4 col-xs-12"><cf_get_lang no ='95.Komisyon Gider Kalemi'></label>
										<div class="col col-5 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="com_exp_item_id" id="com_exp_item_id" value="">
												<cfinput type="text" name="com_exp_item_name" id="com_exp_item_name" value="" style="width:120px;" onFocus="AutoComplete_Create('com_exp_item_name','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID,ACCOUNT_CODE,ACCOUNT_CODE','com_exp_item_id,com_acc_name,com_acc_id','add_bond',3);" autocomplete="off">
												<span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang_main no='322.Seçiniz'>" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=add_bond.com_exp_item_id&field_name=add_bond.com_exp_item_name&field_account_no=add_bond.com_acc_id&field_account_no2=add_bond.com_acc_name','list');"></span>
											</div>
										</div>
									</div>
									<div class="form-group" id="item-com_acc_code">
										<label class="col col-4 col-xs-12"><cf_get_lang no ='96.Komisyon Muhasebe Kodu'></label>
										<div class="col col-5 col-xs-12">
											<div class="input-group">
												<cf_wrk_account_codes form_name='add_bond' account_code='com_acc_id' account_name='com_acc_name' search_from_name='1' is_multi_no ='2'>
												<input type="hidden" name="com_acc_id" id="com_acc_id" value="" style="width:120px;">
												<cfinput type="text" name="com_acc_name" id="com_acc_name" value="" style="width:120px;" onkeyup="get_wrk_acc_code_2();" onFocus="AutoComplete_Create('com_acc_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','com_acc_id','add_bond','3','120');" autocomplete="off">
												<span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang_main no='322.Seçiniz'>" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_name=add_bond.com_acc_name&field_id=add_bond.com_acc_id','list');"></span>
											</div>
										</div>
									</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</cf_box_elements>
					<div class="row formContentFooter col col-12">
						<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
					</div>
			</cfform>
		</cf_box>

<script type="text/javascript">

		<cfif isdefined("attributes.stockbond_id") and len(attributes.stockbond_id)>
			visiblePeriod(<cfoutput>#getiri_type#</cfoutput>, '1');
			hesapla(1);
			FaizHesapla('getiri_tutari1');
			CreatePaymentRow();
		</cfif>

		function ToggleRow(){
			$("div.div_getiri_tablosu").toggle();
		}

		function visiblePeriod(val, row){
			if(val == 1 || val == 3){
				$("div#Th_getiri, div#Th_period, div#Th_odeme_tarihi, div#Th_Getiri_tutari, div#Th_Tahsil_sayisi, div#Th_Getiri_tahsil_tutari, div#Th_butce, div#show-payment-row, div#Th_vade, div#th_start_date, div#getiri_payment_period_td"+row+", div#getiri_tutari_td"+row+", div#getiri_tahsil_sayisi_td"+row+", div#getiri_tahsil_tutari_td"+row+", div#expense_item_tahakkuk_id_td"+row+", div#getiri_orani_td"+row+", div#getiri_type_td"+row+", div#due_value_td"+row+"").show();
			}else{
				$("div#Th_getiri, div#Th_period, div#Th_odeme_tarihi, div#Th_Getiri_tutari, div#Th_Tahsil_sayisi, div#Th_Getiri_tahsil_tutari, div#Th_butce, div#show-payment-row, div#Th_vade, div#th_start_date, div#getiri_payment_period_td"+row+", div#getiri_tutari_td"+row+", div#getiri_tahsil_sayisi_td"+row+", div#getiri_tahsil_tutari_td"+row+", div#expense_item_tahakkuk_id_td"+row+", div#getiri_orani_td"+row+", div#getiri_type_td"+row+", div#due_value_td"+row+"").hide();
			}
		}
		function change_paper_duedate(field_name,type,row) 
		{
			paper_date_=eval('document.add_bond.start_date1.value');
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
	
		function specialVisible(val){

			if(val == 'yield_payment_period') val = $("select[name=getiri_payment_period1]").val();

			var due_value = $("input[name=due_value1]").val(); // vade günü
    		var tutar = filterNum($("input[name=total_purchase1]").val()); // tutar

			if(due_value > 0 && action_value ){

				var getiri_orani = filterNum($("input[name=getiri_orani1]").val()); // getiri oranı 
        		var getiri_orani_gunluk = ( ( getiri_orani / 100 ) / $("input[name=ygs1]").val() )  * due_value * tutar ;
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
	
			}
	
		}
		function FaizHesapla(fieldName)
		{
			var due_value = $("input[name=due_value1]").val(); // vade günü
			var tutar = filterNum($("input[name=total_purchase1]").val()); // tutar
			var getiri_tutari = filterNum($("input[name=getiri_tutari1]").val()); // getiri tutarı

			if(due_value > 0) {
				if( tutar > 0 && tutar != '' ){
					var getiri_orani = filterNum($("input[name=getiri_orani1]").val()); // getiri oranı 
					var getiri_orani_gunluk =  ( ( getiri_orani / 100 ) / $("input[name=ygs1]").val() )  * due_value * tutar ;

					if(fieldName == 'getiri_orani1') {
						$("input[name=getiri_tutari1]").val( commaSplit( getiri_orani_gunluk ,'2'));
					}else if(fieldName == 'getiri_tutari1'){
						var getiri_orani_currently = ( ( getiri_tutari * $("input[name=ygs1]").val() ) / due_value / ( tutar / 100 ) );
						$("input[name=getiri_orani1]").val( commaSplit( getiri_orani_currently ,'4'));
					}
					
						var val = $("select#getiri_payment_period1").val();
						var day = 0;

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
					CreatePaymentRow();
			}
			else{
				$("input[name=getiri_orani1]").val(0);
				$("input[name=getiri_tahsil_sayisi1]").val(0);
				$("input[name=getiri_tahsil_tutari1]").val(0);


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
			for (var i=1; i<= document.getElementById("kur_say").value; i++)
			{	
				if(document.add_bond.rd_money[i-1].checked == true)
				{	
					form_txt_rate2_ = filterNum(document.getElementById("txt_rate2_"+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/filterNum(document.getElementById("txt_rate1_"+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
					if( val == undefined) {
						document.getElementById("other_total_purchase"+row_no).value = commaSplit(filterNum(document.getElementById("total_purchase"+row_no).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/ (parseFloat(form_txt_rate2_)),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
						document.getElementById("purchase_value"+row_no).value = commaSplit(filterNum(document.getElementById("purchase_value"+row_no).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
						document.getElementById("other_purchase_value"+row_no).value = commaSplit(filterNum(document.getElementById("purchase_value"+row_no).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/(parseFloat(form_txt_rate2_)),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
						document.getElementById("nominal_value"+row_no).value = commaSplit(filterNum(document.getElementById("nominal_value"+row_no).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
						document.getElementById("other_nominal_value"+row_no).value = commaSplit(filterNum(document.getElementById("nominal_value"+row_no).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/(parseFloat(form_txt_rate2_)),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
					}else{
						document.getElementById("other_total_purchase"+row_no).value = commaSplit(filterNum(document.getElementById("total_purchase"+row_no).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/ (parseFloat(form_txt_rate2_)),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
						document.getElementById("purchase_value"+row_no).value = commaSplit(filterNum(document.getElementById("other_purchase_value"+row_no).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')*(parseFloat(form_txt_rate2_)),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
						document.getElementById("other_purchase_value"+row_no).value = commaSplit(filterNum(document.getElementById("other_purchase_value"+row_no).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
						document.getElementById("nominal_value"+row_no).value = commaSplit(filterNum(document.getElementById("other_nominal_value"+row_no).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')*(parseFloat(form_txt_rate2_)),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
						document.getElementById("other_nominal_value"+row_no).value = commaSplit(filterNum(document.getElementById("other_nominal_value"+row_no).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
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
				if(document.add_bond.rd_money[t-1].checked == true)
				{
					for(k=1;k<=document.getElementById("record_num").value;k++)
					{	
						rate2_value = filterNum(document.getElementById("txt_rate2_"+t).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/filterNum(document.getElementById("txt_rate1_"+t).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
						document.getElementById("other_nominal_value"+k).value = commaSplit(filterNum(document.getElementById("nominal_value"+k).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/rate2_value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
						document.getElementById("other_purchase_value"+k).value = commaSplit(filterNum(document.getElementById("purchase_value"+k).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/rate2_value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
						document.getElementById("other_total_purchase"+k).value = commaSplit(filterNum(document.getElementById("total_purchase"+k).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/rate2_value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
						document.getElementById("purchase_other").value = commaSplit(filterNum(document.getElementById("action_value").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/rate2_value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
					}
					document.getElementById("other_money_info").value = document.add_bond.rd_money[t-1].value;
					document.getElementById("other_money_info1").value = document.add_bond.rd_money[t-1].value;
				}
			}
			toplam_hesapla();
		}
		function total_doviz_hesapla()
		{
			for (var t=1; t<=document.getElementById("kur_say").value; t++)
			{		
				if(document.add_bond.rd_money[t-1].checked == true)
				{
					rate2_value = filterNum(document.getElementById("txt_rate2_"+t).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/filterNum(document.getElementById("txt_rate1_"+t).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
					document.getElementById("com_other").value = commaSplit(filterNum(document.getElementById("com_ytl").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/rate2_value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
					document.getElementById("com_ytl").value = commaSplit(filterNum(document.getElementById("com_ytl").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				}
			}
		}
		function kontrol()
		{	
			if(!paper_control(add_bond.paper_no,'BUYING_SECURITIES','','','','','','','<cfoutput>#dsn3#</cfoutput>')) return false;
			if (!chk_process_cat('add_bond')) return false;
			if(!check_display_files('add_bond')) return false;
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

			process=document.add_bond.process_cat.value;
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
				document.getElementById("txt_rate2_" + st).value = filterNum(document.getElementById("txt_rate2_" + st).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				document.getElementById("txt_rate1_" + st).value = filterNum(document.getElementById("txt_rate1_" + st).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			}
			return true;
		}
		
		function clickduedate(dueDate){
			document.getElementById(dueDate).onchange();
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
	