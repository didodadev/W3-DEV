<cf_xml_page_edit fuseact="credit.popup_add_credit_payment">
<cfif not len(url.credit_contract_row_id)>
	<br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
	<cfexit method="exittemplate">
</cfif>
<cfif not isdefined("attributes.period_id")><cfset attributes.period_id = session.ep.period_id></cfif>
<cfif not isdefined("attributes.our_company_id")><cfset attributes.our_company_id = session.ep.company_id></cfif>
<cfquery name="GET_PERIOD" datasource="#DSN#">
	SELECT
		*
	FROM
		SETUP_PERIOD
	WHERE
		PERIOD_ID = #attributes.period_id# AND
		OUR_COMPANY_ID = #attributes.our_company_id#
</cfquery> 
<cfset temp_dsn = '#dsn#_#get_period.period_year#_#get_period.our_company_id#'>
<cfquery name="get_credit_contract_payment" datasource="#temp_dsn#">
	SELECT
		*
	FROM
		CREDIT_CONTRACT_PAYMENT_INCOME
	WHERE
		CREDIT_CONTRACT_PAYMENT_ID = #url.credit_contract_row_id#
</cfquery>
<cfif not isdefined("url.credit_contract_id")><cfset url.credit_contract_id = GET_CREDIT_CONTRACT_PAYMENT.CREDIT_CONTRACT_ID></cfif>
<cfquery name="get_credit_contract_payment_tax" datasource="#temp_dsn#">
	SELECT
		CC.*,
		EX.EXPENSE_ITEM_NAME
	FROM
		CREDIT_CONTRACT_PAYMENT_INCOME_TAX CC
		LEFT JOIN EXPENSE_ITEMS EX ON EX.EXPENSE_ITEM_ID = CC.TAX_EXPENSE_ITEM_ID
	WHERE
		CC.CREDIT_CONTRACT_PAYMENT_ID = #url.credit_contract_row_id#
</cfquery>
<cfquery name="credit_contract_money" datasource="#dsn3#">
	SELECT MONEY_TYPE FROM CREDIT_CONTRACT WHERE CREDIT_CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.credit_contract_id#">
</cfquery>
<cfquery name="get_project_from_bank_actions" datasource="#dsn2#">
	SELECT PROJECT_ID FROM BANK_ACTIONS WHERE ACTION_ID = #GET_CREDIT_CONTRACT_PAYMENT.BANK_ACTION_ID#
</cfquery>
<cfif not GET_CREDIT_CONTRACT_PAYMENT.recordcount>
	<br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
	<cfexit method="exittemplate">
</cfif>
<cfset str_linke_ait="&field_comp_id=upd_credit_payment.company_id&field_partner=upd_credit_payment.partner_id&field_comp_name=upd_credit_payment.company&field_name=upd_credit_payment.partner&select_list=2">
<cfinclude template="../query/get_accounts.cfm">
<cfinclude template="../query/get_expense_center.cfm">
<cf_papers paper_type="credit_payment">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfform name="upd_credit_payment">
		<input type="hidden" name="is_capital_budget_act" id="is_capital_budget_act" value="<cfoutput>#is_capital_budget_act#</cfoutput>">
		<input type="hidden" name="credit_contract_id" id="credit_contract_id" value="<cfoutput>#url.credit_contract_id#</cfoutput>">
		<input type="hidden" name="credit_contract_row_id" id="credit_contract_row_id" value="<cfoutput>#attributes.credit_contract_row_id#</cfoutput>" />
		<input type="hidden" name="credit_contract_payment_id" id="credit_contract_payment_id" value="<cfoutput>#get_credit_contract_payment.credit_contract_payment_id#</cfoutput>">
		<input type="hidden" name="temp_dsn" id="temp_dsn" value="<cfoutput>#dsn#_#get_period.period_year#_#get_period.our_company_id#</cfoutput>">
		<input type="hidden" name="bank_action_id" id="bank_action_id" value="<cfoutput>#GET_CREDIT_CONTRACT_PAYMENT.BANK_ACTION_ID#</cfoutput>">
		<input type="hidden" name="pageDelEvent" id="pageDelEvent" value="delPayment" />
		<cfoutput>
			<input type="hidden" name="period_id" id="period_id" value="#attributes.period_id#" />
			<input type="hidden" name="our_company_id" id="our_company_id" value="#attributes.our_company_id#" />
		</cfoutput>
		<cfsavecontent variable="right_">
			<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=account.popup_list_card_rows&action_id=#get_credit_contract_payment.credit_contract_payment_id#&process_cat=#get_credit_contract_payment.process_type#</cfoutput>','page','upd_gidenh');"><img src="/images/extre.gif" alt="Mahsup Fişi" border="0" title="Mahsup Fişi"></a>
		</cfsavecontent>
		<cf_box>
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-process_cat">
						 <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='40683.İşlem Kategorisi'> *</label>
						 <div class="col col-8 col-xs-12">
							 <cf_workcube_process_cat process_cat=#get_credit_contract_payment.process_cat# process_type_info="291">
						 </div>
					</div>
					<div class="form-group" id="item-document_no">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57880.Belge No'>*</label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="document_no" id="document_no" value="<cfoutput>#get_credit_contract_payment.document_no#</cfoutput>" maxlength="20">
						</div>
					</div>
					<div class="form-group" id="item-company">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51334.Kredi Kurumu'></label>
						<div class="col col-8 col-xs-12">
							<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_credit_contract_payment.company_id#</cfoutput>">
							<div class="input-group">
								<input type="text" name="company" id="company" value="<cfoutput>#get_par_info(get_credit_contract_payment.company_id,1,1,0)#</cfoutput>" readonly>
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars<cfoutput>#str_linke_ait#</cfoutput>','list');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-partner">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57578.Yetkili'></label>
						<div class="col col-8 col-xs-12">
							<input type="hidden" name="partner_id" id="partner_id" value="<cfif len(get_credit_contract_payment.company_id)><cfoutput>#get_credit_contract_payment.partner_id#</cfoutput></cfif>">
							<input type="text" name="partner" id="partner" value="<cfif len(get_credit_contract_payment.company_id) and len(get_credit_contract_payment.partner_id)><cfoutput>#get_par_info(get_credit_contract_payment.partner_id ,0,-1,0)#</cfoutput></cfif>" readonly>
						</div>
					</div>
					<div class="form-group" id="item-action_from_account_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51375.Banka Hesabından'> *</label>
						<div class="col col-8 col-xs-12">
							<select name="action_from_account_id" id="action_from_account_id" onChange="showDepartment(this.value);kur_ekle_f_hesapla('action_from_account_id');">
								<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
								<cfoutput query="get_accounts">
									<option value="#account_id#;#account_currency_id#;#ListGetAt(session.ep.user_location,2,"-")#"<cfif account_id eq get_credit_contract_payment.bank_account_id>selected</cfif>>#account_name#&nbsp;#account_currency_id#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-branch_place"><!--- banka seçildiğinde doluyor --->
					</div>
					<div class="form-group" id="item-expense_center_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></label>
						<div class="col col-8 col-xs-12">
							<select name="expense_center_id" id="expense_center_id">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_expense_center">
									<option value="#expense_id#"<cfif expense_id eq get_credit_contract_payment.expense_center_id>selected</cfif>>#expense#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-project_name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
						<div class="col col-8 col-xs-12">
							<cfif not isDefined("attributes.project_id")><cfset attributes.project_id = get_project_from_bank_actions.project_id></cfif>
							<cf_wrkProject project_Id="#attributes.project_id#" fieldName="project_name" AgreementNo="1" Customer="2" Employee="3" Priority="4" Stage="5" boxwidth="600" boxheight="400" buttontype="2">
						</div>
					</div>
					<div class="form-group" id="item-payment_date">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'> *</label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='51377.Kredi Ödeme Tarihini Kontrol Ediniz'>!</cfsavecontent>
							<div class="input-group">
								<cfinput type="text" name="payment_date" id="payment_date" value="#dateformat(get_credit_contract_payment.process_date,dateformat_style)#" required="yes" validate="#validate_style#" message="#message#" maxlength="10" onblur="change_money_info('upd_credit_payment','payment_date');">
								<span class="input-group-addon"><cf_wrk_date_image date_field="payment_date" call_function="change_money_info"></span>
							 </div>
						</div>
					</div>
					<div class="form-group" id="item-details">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
						<div class="col col-8 col-xs-12">
							<textarea name="details" id="details" style="height:45px;"><cfoutput>#get_credit_contract_payment.detail#</cfoutput></textarea>
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="false">
					<div class="form-group">
						<label class ="bold"><cf_get_lang dictionary_id='30134.İşlem Para Br.'></label>
					</div>
					<div class="form-group" id="item-kur_ekle">
						<div class="col col-12 scrollContent scroll-x2">
							<cfscript>f_kur_ekle(action_id:get_credit_contract_payment.credit_contract_payment_id,call_function:'write_total_amount',process_type:1,base_value:'cash_action_value',other_money_value:'other_cash_act_value',form_name:'upd_credit_payment',action_table_name:'CREDIT_CONTRACT_PAYMENT_INCOME_MONEY',action_table_dsn:'#temp_dsn#',select_input:'action_from_account_id',is_disable='1');</cfscript>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_grid_list>
				<thead> 
					<tr>
						<th></th>
						<th><cf_get_lang dictionary_id='57673.Tutar'></th>
						<th><cf_get_lang dictionary_id='58056.Dövizli Tutar'></th>
						<th><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></th>
						<th><cf_get_lang dictionary_id='58551.Gider Kalemi'><cfif is_budget_control eq 1>*</cfif></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td><cf_get_lang dictionary_id='59179.Ana Para'></td>
						<td>
							<div class="form-group">
								<input type="text" name="capital_price" id="capital_price" value="<cfoutput>#TlFormat(get_credit_contract_payment.capital_price,'#session.ep.our_company_info.rate_round_num#')#</cfoutput>" onKeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(1);kur_ekle_f_hesapla('action_from_account_id');" class="moneybox" style="width:120px;">
							</div>
						</td>
						<td>
							<div class="form-group">
								<input type="text" name="capital_price_other" id="capital_price_other" value="" onKeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(2);kur_ekle_f_hesapla('action_from_account_id');" class="moneybox" style="width:120px;">
							</div>
						</td>
						<td>
							<div class="form-group">
								<div class="input-group">
									<input type="hidden" name="debt_account_id" id="debt_account_id" value="<cfif isdefined ("get_credit_contract_payment.CAPITAL_EXPENSE_ITEM_ID_ACC") and  len(get_credit_contract_payment.CAPITAL_EXPENSE_ITEM_ID_ACC)><cfoutput>#get_credit_contract_payment.CAPITAL_EXPENSE_ITEM_ID_ACC#</cfoutput></cfif>">
									<input type="text" name="debt_account_code" id="debt_account_code" value="<cfif isdefined ("get_credit_contract_payment.CAPITAL_EXPENSE_ITEM_ID_ACC") and  len(get_credit_contract_payment.CAPITAL_EXPENSE_ITEM_ID_ACC)><cfoutput>#get_credit_contract_payment.CAPITAL_EXPENSE_ITEM_ID_ACC#</cfoutput></cfif>" onfocus="AutoComplete_Create('debt_account_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','debt_account_id','upd_credit_payment','3','140');" style="width:120px;">
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=upd_credit_payment.debt_account_id&field_name=upd_credit_payment.debt_account_code','list');"></span>
								</div>
							</div>	
						</td>
						<td>
							<div class="form-group">
								<cfif is_capital_budget_act neq 0>
									<div class="input-group">
										<cfif len(get_credit_contract_payment.capital_expense_item_id)>
											<cfquery name="GET_EXPENSE_CAPITAL" datasource="#dsn2#">
												SELECT EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #get_credit_contract_payment.capital_expense_item_id#
											</cfquery>
											<input type="hidden" name="capital_expense_id" id="capital_expense_id" value="<cfoutput>#get_credit_contract_payment.capital_expense_item_id#</cfoutput>">
											<cfinput type="text" name="capital_expense" id="capital_expense" value="#get_expense_capital.expense_item_name#" onFocus="AutoComplete_Create('capital_expense','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID,ACCOUNT_CODE,ACCOUNT_CODE','capital_expense_id,debt_account_code,debt_account_id','upd_credit_payment',3);" autocomplete="off">
										<cfelse>
											<input type="hidden" name="capital_expense_id" id="capital_expense_id" value="">
											<cfinput type="text" name="capital_expense" id="capital_expense" value="" onFocus="AutoComplete_Create('capital_expense','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID,ACCOUNT_CODE,ACCOUNT_CODE','capital_expense_id,debt_account_code,debt_account_id','upd_credit_payment',3);" autocomplete="off">
										</cfif>
										<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=upd_credit_payment.capital_expense_id&field_name=upd_credit_payment.capital_expense&field_account_no=upd_credit_payment.debt_account_id&field_account_no2=upd_credit_payment.debt_account_code','list');"></span>
									</div>
								</cfif>
							</div>
						</td>
						
					</tr>
					<tr>
						<td><cf_get_lang dictionary_id='51367.Faiz'></td>
						<td>
							<div class="form-group">
								<input type="text" name="interest_price" id="interest_price" value="<cfoutput>#TlFormat(get_credit_contract_payment.interest_price,'#session.ep.our_company_info.rate_round_num#')#</cfoutput>" onKeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(1);" class="moneybox" style="width:120px;">
							</div>
						</td>
						<td>
							<div class="form-group">
								<input type="text" name="interest_price_other" id="interest_price_other" value="" onKeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(2);kur_ekle_f_hesapla('action_from_account_id');" class="moneybox" style="width:120px;">
							</div>
						 </td>
						 <td>
							<div class="form-group">
								<div class="input-group">
									<input type="hidden" name="debt_account_id2" id="debt_account_id2" value="<cfif isdefined("get_credit_contract_payment.INTEREST_EXPENSE_ITEM_ID_ACC") and len(get_credit_contract_payment.INTEREST_EXPENSE_ITEM_ID_ACC)><cfoutput>#get_credit_contract_payment.INTEREST_EXPENSE_ITEM_ID_ACC#</cfoutput></cfif>">
									<input type="text" name="debt_account_code2" id="debt_account_code2" value="<cfif isdefined("get_credit_contract_payment.INTEREST_EXPENSE_ITEM_ID_ACC") and len(get_credit_contract_payment.INTEREST_EXPENSE_ITEM_ID_ACC)><cfoutput>#get_credit_contract_payment.INTEREST_EXPENSE_ITEM_ID_ACC#</cfoutput></cfif>" onfocus="AutoComplete_Create('debt_account_code2','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','debt_account_id2','upd_credit_payment','3','140');" autocomplete="off" style="width:140px;">
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=upd_credit_payment.debt_account_id2&field_name=upd_credit_payment.debt_account_code2','list');"></span>
								</div>	
							</div>
						</td>
						<td> 
							<div class="form-group">
								<div class="input-group">
									<cfif len(get_credit_contract_payment.interest_expense_item_id)>
										<cfquery name="GET_EXPENSE_INTEREST" datasource="#dsn2#">
											SELECT EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #get_credit_contract_payment.interest_expense_item_id#
										</cfquery>
										<input type="hidden" name="interest_expense_id" id="interest_expense_id" value="<cfoutput>#get_credit_contract_payment.interest_expense_item_id#</cfoutput>">
										<cfinput type="text" name="interest_expense" id="interest_expense" value="#get_expense_interest.expense_item_name#" onFocus="AutoComplete_Create('interest_expense','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID,ACCOUNT_CODE,ACCOUNT_CODE','interest_expense_id,debt_account_code2,debt_account_id2','upd_credit_payment',3);" autocomplete="off">
									<cfelse>
										<input type="hidden" name="interest_expense_id" id="interest_expense_id" value="">
										<cfinput type="text" name="interest_expense" id="interest_expense" value="" onFocus="AutoComplete_Create('interest_expense','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID,ACCOUNT_CODE,ACCOUNT_CODE','interest_expense_id,debt_account_code2,debt_account_id2','upd_credit_payment',3);" autocomplete="off">
									</cfif>
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=upd_credit_payment.interest_expense_id&field_name=upd_credit_payment.interest_expense&field_account_no=upd_credit_payment.debt_account_id2&field_account_no2=upd_credit_payment.debt_account_code2','list');"></span>
								</div>   
							</div>
						</td>
						
					</tr>
					<tr>
						<td><cf_get_lang dictionary_id='39657.Gecikme'></td>
						<td>
							<div class="form-group">
								<input type="text" name="delay_price" id="delay_price" value="<cfoutput>#TlFormat(get_credit_contract_payment.delay_price,'#session.ep.our_company_info.rate_round_num#')#</cfoutput>" onKeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(1);kur_ekle_f_hesapla('action_from_account_id');" class="moneybox">
							</div>
						</td>
						<td>
							<div class="form-group">
								<input type="text" name="delay_price_other" id="delay_price_other" value="" onKeyup="return(FormatCurrency(this,event));" onBlur="write_total_amount(2);kur_ekle_f_hesapla('action_from_account_id');" class="moneybox">
							</div>
						</td>
						<td>
							<div class="form-group">
								<div class="input-group">
									<cfif isdefined("get_credit_contract_payment.DELAY_EXPENSE_ITEM_ID_ACC") and len(get_credit_contract_payment.DELAY_EXPENSE_ITEM_ID_ACC)>
										<input type="hidden" name="debt_account_id4" id="debt_account_id4" value="<cfoutput>#get_credit_contract_payment.DELAY_EXPENSE_ITEM_ID_ACC#</cfoutput>">
										<cfinput type="text" name="debt_account_code4" id="debt_account_code4" value="#get_credit_contract_payment.DELAY_EXPENSE_ITEM_ID_ACC#" onFocus="AutoComplete_Create('debt_account_code4','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','debt_account_id4','upd_credit_payment','3','140');" autocomplete="off">
									<cfelse>
										<input type="hidden" name="debt_account_id4" id="debt_account_id4" value="">
										<cfinput type="text" name="debt_account_code4" id="debt_account_code4" value="" onFocus="AutoComplete_Create('debt_account_code4','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','debt_account_id4','upd_credit_payment','3','140');" autocomplete="off">
									</cfif>
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=upd_credit_payment.debt_account_id4&field_name=upd_credit_payment.debt_account_code4','list');"></span>
								</div>	
							</div>
						</td>
						<td>
							<div class="form-group">
								<div class="input-group">
									<cfif len(get_credit_contract_payment.delay_expense_item_id)>
										<cfquery name="GET_EXPENSE_DELAY" datasource="#dsn2#">
											SELECT EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #get_credit_contract_payment.delay_expense_item_id#
										</cfquery>
										<input type="hidden" name="delay_expense_id" id="delay_expense_id" value="<cfoutput>#get_credit_contract_payment.delay_expense_item_id#</cfoutput>">
										<cfinput type="text" name="delay_expense" id="delay_expense" value="#get_expense_delay.expense_item_name#" onFocus="AutoComplete_Create('delay_expense','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID,ACCOUNT_CODE,ACCOUNT_CODE','delay_expense_id,debt_account_code4,debt_account_id4','upd_credit_payment',3);" autocomplete="off">
									<cfelse>
										<input type="hidden" name="delay_expense_id" id="delay_expense_id" value="">
										<cfinput type="text" name="delay_expense" id="delay_expense" value="" onFocus="AutoComplete_Create('delay_expense','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID,ACCOUNT_CODE,ACCOUNT_CODE','delay_expense_id,debt_account_code4,debt_account_id4','upd_credit_payment',3);" autocomplete="off">
									</cfif>
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=upd_credit_payment.delay_expense_id&field_name=upd_credit_payment.delay_expense&field_account_no=upd_credit_payment.debt_account_id4&field_account_no2=upd_credit_payment.debt_account_code4','list');"></span>
								</div>  
							</div>
						</td>
						
					</tr>
				</tbody>
				<tfoot>   
					<tr>
						<td><cf_get_lang dictionary_id='29534.Toplam Tutar'></td>
						<td>
							<div class="form-group">
								<input type="text" name="cash_action_value" id="cash_action_value" value="<cfoutput>#TlFormat(get_credit_contract_payment.total_price,'#session.ep.our_company_info.rate_round_num#')#</cfoutput>" onBlur="kur_ekle_f_hesapla('action_from_account_id');" onkeyup="return(FormatCurrency(this,event));" class="moneybox" readonly>
							</div>
						</td>
						<td>
							<div class="form-group">
								<input type="text" name="other_cash_act_value" id="other_cash_act_value" value="<cfoutput>#TlFormat(get_credit_contract_payment.other_total_price,'#session.ep.our_company_info.rate_round_num#')#</cfoutput>" onBlur="kur_ekle_f_hesapla('action_from_account_id',true);" class="moneybox"></td>
								<input type="hidden" name="system_amount_value" id="system_amount_value" value="">
								<!---<input type="hidden" name="money_type" id="money_type" value="<cfoutput>#get_credit_contract_payment.other_money#</cfoutput>">--->
							</div>
						</td>
						<td colspan="3"></td>
					</tr>	
				</tfoot>
			</cf_grid_list>
			<cf_grid_list id="table1">
				<thead> 
					<tr>
						<th></th>
						<th><cf_get_lang dictionary_id='57673.Tutar'></th>
						<th><cf_get_lang dictionary_id='58056.Dövizli Tutar'></th>
						<th><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></th>
						<th><cf_get_lang dictionary_id='58551.Gider Kalemi'><cfif is_budget_control eq 1>*</cfif></th>
						<th width="15"></th>
					</tr>
				</thead>
				<tbody>
					<input type="hidden" name="record_num" id="record_num" value="1">
					<tr id="frm_row1">
						<cfif get_credit_contract_payment_tax.recordcount>
							<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_credit_contract_payment_tax.recordcount#</cfoutput>">
							<cfoutput query="get_credit_contract_payment_tax">
								<tr id="frm_row#get_credit_contract_payment_tax.currentrow#">
									<td><cf_get_lang dictionary_id='62390.Vergi/Masraf'></td>
									<td>
										<div class="form-group">
											<input type="hidden" name="row_kontrol#get_credit_contract_payment_tax.currentrow#" id="row_kontrol#get_credit_contract_payment_tax.currentrow#" value="1">
											<input type="text" name="tax_price_#get_credit_contract_payment_tax.currentrow#" id="tax_price_#get_credit_contract_payment_tax.currentrow#" value="#Tlformat(get_credit_contract_payment_tax.tax_price,'#session.ep.our_company_info.rate_round_num#')#" onKeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(1);kur_ekle_f_hesapla('action_from_account_id');" class="moneybox">                                                    	
										</div>
									</td>
									<td>
										<div class="form-group">
											<input type="text" name="tax_price_other_#get_credit_contract_payment_tax.currentrow#" id="tax_price_other_#get_credit_contract_payment_tax.currentrow#" value="" onKeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(2);kur_ekle_f_hesapla('action_from_account_id');" class="moneybox">
										</div>
									</td>
									<td>
										<div class="form-group">
											<div class="input-group">
												<input type="hidden" name="debt_account_id3_#get_credit_contract_payment_tax.currentrow#" id="debt_account_id3_#get_credit_contract_payment_tax.currentrow#" value="#get_credit_contract_payment_tax.TAX_EXPENSE_ITEM_ID_ACC#">
												<cfinput type="text" name="debt_account_code3_#get_credit_contract_payment_tax.currentrow#" id="debt_account_code3_#get_credit_contract_payment_tax.currentrow#" value="#get_credit_contract_payment_tax.TAX_EXPENSE_ITEM_ID_ACC#" onFocus="AutoComplete_Create('debt_account_code3_#get_credit_contract_payment_tax.currentrow#','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','debt_account_id3_#get_credit_contract_payment_tax.currentrow#','upd_credit_payment','3','140');" autocomplete="off">
												<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('#request.self#?fuseaction=objects.popup_account_plan&field_id=upd_credit_payment.debt_account_id3_1&field_name=upd_credit_payment.debt_account_code3_1','list');">
											</div>
										</div>
									</td>
									<td>
										<div class="form-group">
											<div class="input-group">
												<input type="hidden" name="tax_expense_id_#get_credit_contract_payment_tax.currentrow#" id="tax_expense_id_#get_credit_contract_payment_tax.currentrow#" value="#get_credit_contract_payment_tax.TAX_EXPENSE_ITEM_ID#">
												<cfinput type="text" name="tax_expense_#get_credit_contract_payment_tax.currentrow#" id="tax_expense_#get_credit_contract_payment_tax.currentrow#" value="#get_credit_contract_payment_tax.EXPENSE_ITEM_NAME#" onFocus="AutoComplete_Create('tax_expense_#get_credit_contract_payment_tax.currentrow#','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID,ACCOUNT_CODE,ACCOUNT_CODE','tax_expense_id_#get_credit_contract_payment_tax.currentrow#,debt_account_code3_#get_credit_contract_payment_tax.currentrow#,debt_account_id3_#get_credit_contract_payment_tax.currentrow#','upd_credit_payment',3);" autocomplete="off" style="width:130px;">
												<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_exp_item&field_id=upd_credit_payment.tax_expense_id_1&field_name=upd_credit_payment.tax_expense_1&field_account_no=upd_credit_payment.debt_account_id3_1&field_account_no2=upd_credit_payment.debt_account_code3_1','list');"></span>
											</div>
										</div>
									</td>
									<td style="text-align:center;">
										<cfif get_credit_contract_payment_tax.currentrow eq 1>
											<span class="icon-pluss" onclick="add_row();"></span>
										<cfelse>
											<span class="icon-minus" onclick="sil(#get_credit_contract_payment_tax.currentrow#);"></span>
										</cfif>
									</td>
								</tr>									
							</cfoutput>
						<cfelse>
							<input type="hidden" name="record_num" id="record_num" value="1">
							<tr id="frm_row1">
								<td><cf_get_lang dictionary_id='62390.Vergi/Masraf'></td>
								<td>
									<div class="form-group">
										<input type="hidden" name="row_kontrol1" id="row_kontrol1" value="1">
										<input type="text" name="tax_price_1" id="tax_price_1" value="<cfoutput>#Tlformat(0,'#session.ep.our_company_info.rate_round_num#')#</cfoutput>" onkeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(1);kur_ekle_f_hesapla('action_from_account_id');" class="moneybox">
									</div>
								</td>
								<td>
									<div class="form-group">
										<input type="text" name="tax_price_other_1" id="tax_price_other_1" value="" onkeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(2);kur_ekle_f_hesapla('action_from_account_id');" class="moneybox">
									</div>
								</td>
								<td>
									<div class="form-group">
										<div class="input-group">
											<input type="hidden" name="debt_account_id3_1" id="debt_account_id3_1" value="">
											<input type="text" name="debt_account_code3_1" id="debt_account_code3_1" value="" onfocus="AutoComplete_Create('debt_account_code3_1','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','debt_account_id3_1','upd_credit_payment','3','140');" autocomplete="off">
											<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=upd_credit_payment.debt_account_id3_1&field_name=upd_credit_payment.debt_account_code3_1','list');"></span>
										</div>
									</div>
								</td>
								<td>
									<div class="form-group">
										<div class="input-group">
											<input type="hidden" name="tax_expense_id_1" id="tax_expense_id_1" value=""> 
											<input type="text" name="tax_expense_1" id="tax_expense_1" value="" onfocus="AutoComplete_Create('tax_expense_1','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID,ACCOUNT_CODE,ACCOUNT_CODE','tax_expense_id_1,debt_account_code3_1,debt_account_id3_1','upd_credit_payment',3);" autocomplete="off">
											<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=upd_credit_payment.tax_expense_id_1&field_name=upd_credit_payment.tax_expense_1&field_account_no=upd_credit_payment.debt_account_id3_1&field_account_no2=upd_credit_payment.debt_account_code3_1','list');"></span>
										</div>
									</div>
								</td>
								<td style="text-align:center;">
									<span class="icon-pluss" onclick="add_row();"></span>
								</td>
							</tr>								
						</cfif>
					</tr>
				</tbody>
			</cf_grid_list>
			<cf_box_footer>
				<cf_record_info query_name="get_credit_contract_payment">
					<cf_workcube_buttons
						is_upd='1'
						update_status='#get_credit_contract_payment.UPD_STATUS#'
						delete_page_url='#request.self#?fuseaction=credit.list_credit_contract&event=delPayment&old_process_type=#get_credit_contract_payment.process_type#&bank_action_id=#get_credit_contract_payment.bank_action_id#&credit_contract_payment_id=#get_credit_contract_payment.credit_contract_payment_id#&temp_dsn=#dsn#_#get_period.period_year#_#get_period.our_company_id#&period_id=#get_period.period_id#&company_id=#get_period.our_company_id#'
						del_function_for_submit="del_kontrol()"
						add_function='kontrol()'>
			</cf_box_footer>
		</cf_box>
	</cfform>
</div>
	

    

<script type="text/javascript">
	<cfif get_credit_contract_payment_tax.recordcount>
		row_count = <cfoutput>#get_credit_contract_payment_tax.recordcount#</cfoutput>;
	<cfelse>
		row_count = 1;
	</cfif>
	function sil(sy)
	{
		var my_element=eval("upd_credit_payment.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
		write_total_amount();
	}
	function add_row()
	{
		row_count++;
		var newRow;
		var newCell;	
		document.upd_credit_payment.record_num.value=row_count;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="input-group x-13"><input type="text" name="tax_price_'+ row_count +'" id="tax_price_'+ row_count +'" value="'+commaSplit(0,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>)+'" onkeyup="return(FormatCurrency(this,event));" onblur="write_total_amount();kur_ekle_f_hesapla(\'action_from_account_id\');" class="moneybox"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="input-group x-13"><input type="text" name="tax_price_other_'+ row_count +'" id="tax_price_other_'+ row_count +'" value="'+commaSplit(0,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>)+'" onkeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(2);kur_ekle_f_hesapla(\'action_from_account_id\');" class="moneybox"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="input-group x-14"><input type="hidden" name="debt_account_id3_'+ row_count +'" id="debt_account_id3_'+ row_count +'" value=""><input type="text" style="width:130px;" name="debt_account_code3_'+ row_count +'" id="debt_account_code3_'+ row_count +'" value="" onFocus="auto_account('+ row_count +');">   <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac_acc('+ row_count +');"></span></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="input-group x-14"><input type="hidden" name="tax_expense_id_'+ row_count +'" id="tax_expense_id_'+ row_count +'" value=""><input type="text" style="width:130px;" name="tax_expense_'+ row_count +'" id="tax_expense_'+ row_count +'" value="" onFocus="auto_expense('+ row_count +');">   <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac_expense('+ row_count +');"></span><input type="hidden" value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<span class="icon-minus" onclick="sil(' + row_count + ');"></span>';
	}
	function auto_account(no)
	{
		AutoComplete_Create('debt_account_code3_'+no,'ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','debt_account_id3_'+no,'upd_credit_payment','3','140');
	}
	function auto_expense(no)
	{
		AutoComplete_Create('tax_expense_'+no,'EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID,ACCOUNT_CODE,ACCOUNT_CODE','tax_expense_id_'+no+',debt_account_code3_'+no+',debt_account_id3_'+no,'upd_credit_payment','3');
	}	
	function pencere_ac_acc(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=upd_credit_payment.debt_account_id3_' + no +'&field_name=upd_credit_payment.debt_account_code3_' + no +'','list');
	}
	function pencere_ac_expense(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=upd_credit_payment.tax_expense_id_' + no +'&field_name=upd_credit_payment.tax_expense_' + no +'&field_account_no=upd_credit_payment.debt_account_id3_' + no +'&field_account_no2=upd_credit_payment.debt_account_code3_' + no +'','list');
	}
	function del_kontrol() 
	{
		control_account_process(<cfoutput>'#get_credit_contract_payment.credit_contract_payment_id#','#get_credit_contract_payment.process_type#'</cfoutput>);
		return true;
	}
	function kontrol()
	{		
		control_account_process(<cfoutput>'#get_credit_contract_payment.credit_contract_payment_id#','#get_credit_contract_payment.process_type#'</cfoutput>);
		if(upd_credit_payment.document_no != "")
		{
			if(!paper_control(upd_credit_payment.document_no,'CREDIT_PAYMENT','1',<cfoutput>'#get_credit_contract_payment.credit_contract_payment_id#'</cfoutput>,'','','','','<cfoutput>#dsn2#</cfoutput>')) return false;
		}
		if(upd_credit_payment.document_no.value == "")
		{
			alert('<cf_get_lang dictionary_id='40958.Belge Numarası Boş Bırakılamaz!'> : <cf_get_lang dictionary_id='57880.Belge No'>');
			return false;
		}
		process=document.upd_credit_payment.process_cat.value;
		var get_process_cat = wrk_safe_query('chq_get_process_cat','dsn3',0,process);
		/* tarih kontrolu */
		if(get_process_cat.IS_ACCOUNT == 1 && document.getElementById('payment_date').value != "")
			if(!chk_period(upd_credit_payment.payment_date,"İşlem")) return false;
		
		if(!chk_process_cat('upd_credit_payment')) return false;
		if(!check_display_files('upd_credit_payment')) return false;
		
		<cfif is_company_required eq 1>
			if(document.upd_credit_payment.company_id.value=='')	
			{
				alert("<cf_get_lang no='16.Lütfen Kredi Kurumu Seçiniz'>!");
				return false;
			}
		</cfif>	
		x = document.upd_credit_payment.action_from_account_id.selectedIndex;
		if (document.upd_credit_payment.action_from_account_id[x].value == "")
		{
			alert("<cf_get_lang no='49.Banka Hesabı Seçiniz'> !");
			return false;
		}	
		
		if (document.upd_credit_payment.expense_center_id.value == "")
		{
			alert("<cf_get_lang no='50.Masraf Merkezi Seçiniz'> !");
			return false;
		}
	
		if(document.upd_credit_payment.payment_date.value == "")
		{
			alert("<cf_get_lang no='40.Lütfen Ödeme Tarihi Giriniz'> !");
			return false;
		}
		<cfif is_budget_control eq 1>
		if(document.upd_credit_payment.is_capital_budget_act.value == 1 && filterNum(document.upd_credit_payment.capital_price.value) != 0 && document.upd_credit_payment.capital_expense.value == "")
		{
			alert("<cf_get_lang no='51.Lütfen Ana Para Gider Kalemi Seçiniz'>!");
			return false;		
		}
		</cfif>
		if(filterNum(document.upd_credit_payment.capital_price.value) != 0 && document.upd_credit_payment.debt_account_code.value == "")
		{
			alert("<cf_get_lang dictionary_id='54541.Lütfen Ana Para Muhasebe Kodu Seçiniz'>!");
			return false;
		}
		<cfif is_budget_control eq 1>
			if(filterNum(document.upd_credit_payment.capital_price.value) != 0 && document.upd_credit_payment.capital_expense_id.value == "")
			{
				alert("<cf_get_lang dictionary_id='54562.Lütfen Ana Para Gider Kalemi Seçiniz'>!");
				return false;
			}
		</cfif>
		if(filterNum(document.upd_credit_payment.interest_price.value) != 0 && document.upd_credit_payment.debt_account_code2.value == "")
		{
			alert("<cf_get_lang dictionary_id='51405.Lütfen Faiz Muhasebe Kodu Seçiniz'>!");
			return false;
		}	
		<cfif is_budget_control eq 1>
			if(filterNum(document.upd_credit_payment.interest_price.value) != 0 && document.upd_credit_payment.interest_expense_id.value == "")
			{
				alert('<cf_get_lang no='52.Lütfen Faiz Gider Kalemi Seçiniz'>!');
				return false;
			}
		</cfif>
		if(filterNum(document.upd_credit_payment.delay_price.value) != 0 && document.upd_credit_payment.debt_account_code4.value == "")
		{
			alert("<cf_get_lang dictionary_id='54539.Lütfen Gecikme Muhasebe Kodu Seçiniz'>!");
			return false;
		}
		<cfif is_budget_control eq 1>
			if(filterNum(document.upd_credit_payment.delay_price.value) != 0 && document.upd_credit_payment.delay_expense_id.value == "")
			{
				alert('<cf_get_lang no='54.Lütfen Gecikme Gider Kalemi Seçiniz'> !');
				return false;
			}
		</cfif>
		for(r=1;r<=document.upd_credit_payment.record_num.value;r++)
		{
			if(eval("document.upd_credit_payment.row_kontrol"+r).value==1)
			{
				if(filterNum(eval('document.upd_credit_payment.tax_price_'+r).value) > 0 && eval('document.upd_credit_payment.debt_account_id3_'+r).value == "")
				{
					alert("<cf_get_lang dictionary_id='54540.Lütfen Vergi Muhasebe Kodu Seçiniz'>!");
					return false;
				}
				<cfif is_budget_control eq 1>
					if(filterNum(eval('document.upd_credit_payment.tax_price_'+r).value) > 0 && eval('document.upd_credit_payment.tax_expense_id_'+r).value == "")
					{
						alert('<cf_get_lang no='53.Lütfen Vergi Gider Kalemi Seçiniz'> !');
						return false;
					}
				</cfif>
			}
		}
		unformat_fields();
		return true;
	}
	
	function write_total_amount(type)
	{
		if(type == undefined) type = 1;
		bank_currency_type = list_getat(document.getElementById("action_from_account_id").value,2,';');
		for(s=1;s<=document.getElementById("kur_say").value;s++)
		{
			if(document.upd_credit_payment.rd_money[s-1].checked == true)
				form_txt_rate2_ = document.getElementById("txt_rate2_"+s).value;
			if(bank_currency_type != '' &&  document.getElementById("hidden_rd_money_"+s).value == bank_currency_type)
				form_txt_rate2_2 = document.getElementById("txt_rate2_"+s).value;
		}
		<cfoutput>
			if(type == 1)
			{
				if(form_txt_rate2_2 != undefined && form_txt_rate2_2 != '')
				{
					rate_1 = parseFloat(filterNum(form_txt_rate2_,'#session.ep.our_company_info.rate_round_num#'),'#session.ep.our_company_info.rate_round_num#');
					rate_2 = parseFloat(filterNum(form_txt_rate2_2,'#session.ep.our_company_info.rate_round_num#'),'#session.ep.our_company_info.rate_round_num#');
				    document.getElementById("capital_price_other").value = commaSplit(parseFloat(filterNum(document.getElementById("capital_price").value,'#session.ep.our_company_info.rate_round_num#'))*rate_1/rate_2,'#session.ep.our_company_info.rate_round_num#');
				    document.getElementById("interest_price_other").value = commaSplit(parseFloat(filterNum(document.getElementById("interest_price").value,'#session.ep.our_company_info.rate_round_num#'))*rate_1/rate_2,'#session.ep.our_company_info.rate_round_num#');
				    document.getElementById("delay_price_other").value = commaSplit(parseFloat(filterNum(document.getElementById("delay_price").value,'#session.ep.our_company_info.rate_round_num#'))*rate_1/rate_2,'#session.ep.our_company_info.rate_round_num#');
					for(r=1;r<=document.upd_credit_payment.record_num.value;r++)
					{
						if(eval("document.upd_credit_payment.row_kontrol"+r).value==1)
						{
							if(eval('document.upd_credit_payment.tax_price_'+r).value != "")
				    			eval('document.upd_credit_payment.tax_price_other_'+r).value = commaSplit(parseFloat(filterNum(eval('document.upd_credit_payment.tax_price_'+r).value,'#session.ep.our_company_info.rate_round_num#'))*rate_1/rate_2,'#session.ep.our_company_info.rate_round_num#');
						}
					}
				}
			}
			else
			{
				if(form_txt_rate2_2 != undefined && form_txt_rate2_2 != '')
				{
					rate_1 = parseFloat(filterNum(form_txt_rate2_,'#session.ep.our_company_info.rate_round_num#'),'#session.ep.our_company_info.rate_round_num#');
					rate_2 = parseFloat(filterNum(form_txt_rate2_2,'#session.ep.our_company_info.rate_round_num#'),'#session.ep.our_company_info.rate_round_num#');
				    document.getElementById("capital_price").value = commaSplit(parseFloat(filterNum(document.getElementById("capital_price_other").value,'#session.ep.our_company_info.rate_round_num#'))/rate_1*rate_2,'#session.ep.our_company_info.rate_round_num#');
				    document.getElementById("interest_price").value = commaSplit(parseFloat(filterNum(document.getElementById("interest_price_other").value,'#session.ep.our_company_info.rate_round_num#'))/rate_1*rate_2,'#session.ep.our_company_info.rate_round_num#');
				    document.getElementById("delay_price").value = commaSplit(parseFloat(filterNum(document.getElementById("delay_price_other").value,'#session.ep.our_company_info.rate_round_num#'))/rate_1*rate_2,'#session.ep.our_company_info.rate_round_num#');
					for(r=1;r<=document.upd_credit_payment.record_num.value;r++)
					{
						if(eval("document.upd_credit_payment.row_kontrol"+r).value==1)
						{
							if(eval('document.upd_credit_payment.tax_price_other_'+r).value != "")
				    			eval('document.upd_credit_payment.tax_price_'+r).value = commaSplit(parseFloat(filterNum(eval('document.upd_credit_payment.tax_price_other_'+r).value,'#session.ep.our_company_info.rate_round_num#'))/rate_1*rate_2,'#session.ep.our_company_info.rate_round_num#');
						}
					}
				}
			}
		var total_price = 0;
		var other_total_price = 0;
		var system_amount = 0;
		if(document.upd_credit_payment.capital_price.value != "")
			total_price += parseFloat(filterNum(upd_credit_payment.capital_price.value,'#session.ep.our_company_info.rate_round_num#'));
		if(document.upd_credit_payment.interest_price.value != "")
			total_price += parseFloat(filterNum(upd_credit_payment.interest_price.value,'#session.ep.our_company_info.rate_round_num#'));
		if(document.upd_credit_payment.delay_price.value != "")
			total_price += parseFloat(filterNum(upd_credit_payment.delay_price.value,'#session.ep.our_company_info.rate_round_num#'));
		for(r=1;r<=document.upd_credit_payment.record_num.value;r++)
		{
			if(eval("document.upd_credit_payment.row_kontrol"+r).value==1)
			{
				if(eval('document.upd_credit_payment.tax_price_'+r).value != "")
					total_price += parseFloat(filterNum(eval('document.upd_credit_payment.tax_price_'+r).value,'#session.ep.our_company_info.rate_round_num#'),'#session.ep.our_company_info.rate_round_num#');
			}
		}
		if(document.upd_credit_payment.capital_price_other.value != "")
			other_total_price += parseFloat(filterNum(upd_credit_payment.capital_price_other.value));
		if(document.upd_credit_payment.interest_price_other.value != "")
			other_total_price += parseFloat(filterNum(upd_credit_payment.interest_price_other.value));
		if(document.upd_credit_payment.delay_price_other.value != "")
			other_total_price += parseFloat(filterNum(upd_credit_payment.delay_price_other.value));
		for(r=1;r<=document.upd_credit_payment.record_num.value;r++)
		{
			if(eval("document.upd_credit_payment.row_kontrol"+r).value==1)
			{
				if(eval('document.upd_credit_payment.tax_price_other_'+r).value != "")
					other_total_price += parseFloat(filterNum(eval('document.upd_credit_payment.tax_price_other_'+r).value));
			}
		}
		rate_2 = parseFloat(filterNum(form_txt_rate2_,'#session.ep.our_company_info.rate_round_num#'),'#session.ep.our_company_info.rate_round_num#');
		document.upd_credit_payment.cash_action_value.value = commaSplit(total_price,'#session.ep.our_company_info.rate_round_num#');
		document.upd_credit_payment.other_cash_act_value.value = commaSplit(other_total_price,'#session.ep.our_company_info.rate_round_num#');
		document.upd_credit_payment.system_amount_value.value = commaSplit(parseFloat(total_price)*rate_2,'#session.ep.our_company_info.rate_round_num#');
		</cfoutput>
	}
	
	function unformat_fields()
	{
		<cfoutput>
			document.upd_credit_payment.capital_price.value = filterNum(document.upd_credit_payment.capital_price.value,'#session.ep.our_company_info.rate_round_num#');
			document.upd_credit_payment.interest_price.value = filterNum(document.upd_credit_payment.interest_price.value,'#session.ep.our_company_info.rate_round_num#');
			document.upd_credit_payment.delay_price.value = filterNum(document.upd_credit_payment.delay_price.value,'#session.ep.our_company_info.rate_round_num#');
			document.upd_credit_payment.delay_price_other.value = filterNum(document.upd_credit_payment.delay_price_other.value,'#session.ep.our_company_info.rate_round_num#');
			document.upd_credit_payment.interest_price_other.value = filterNum(document.upd_credit_payment.interest_price_other.value,'#session.ep.our_company_info.rate_round_num#');
			for(r=1;r<=document.upd_credit_payment.record_num.value;r++)
			{
				if(eval("document.upd_credit_payment.row_kontrol"+r).value==1)
				{
					if(eval('document.upd_credit_payment.tax_price_'+r).value != "")
						eval('document.upd_credit_payment.tax_price_'+r).value = filterNum(eval('document.upd_credit_payment.tax_price_'+r).value,'#session.ep.our_company_info.rate_round_num#');
					
					if(eval('document.upd_credit_payment.tax_price_other_'+r).value != "")
						eval('document.upd_credit_payment.tax_price_other_'+r).value = filterNum(eval('document.upd_credit_payment.tax_price_other_'+r).value,'#session.ep.our_company_info.rate_round_num#');
				}
			}
			document.upd_credit_payment.cash_action_value.value = filterNum(document.upd_credit_payment.cash_action_value.value,'#session.ep.our_company_info.rate_round_num#');
			document.upd_credit_payment.other_cash_act_value.value = filterNum(document.upd_credit_payment.other_cash_act_value.value,'#session.ep.our_company_info.rate_round_num#');
			upd_credit_payment.system_amount.value = filterNum(upd_credit_payment.system_amount.value,'#session.ep.our_company_info.rate_round_num#');
			upd_credit_payment.system_amount_value.value = filterNum(upd_credit_payment.system_amount_value.value,'#session.ep.our_company_info.rate_round_num#');
			for(var i=1;i<=upd_credit_payment.kur_say.value;i++)
			{
				eval('upd_credit_payment.txt_rate1_' + i).value = filterNum(eval('upd_credit_payment.txt_rate1_' + i).value,'#session.ep.our_company_info.rate_round_num#');
				eval('upd_credit_payment.txt_rate2_' + i).value = filterNum(eval('upd_credit_payment.txt_rate2_' + i).value,'#session.ep.our_company_info.rate_round_num#');
			}
		</cfoutput>
	}
	kur_ekle_f_hesapla('action_from_account_id');
	write_total_amount();
	var deneme = document.getElementById('action_from_account_id').value.split(";",1);
	showDepartment(deneme);	
	function showDepartment(no)	
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=credit.popup_ajax_list_branch&action_from_account_id="+no+"&credit_contract_row_id="+<cfoutput>#url.credit_contract_row_id#</cfoutput>;
	
			AjaxPageLoad(send_address,'item-branch_place',1,'İlişkili Şubeler');
		}
</script>
