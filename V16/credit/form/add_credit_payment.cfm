<cf_xml_page_edit fuseact="credit.popup_add_credit_payment">
<cfinclude template="../query/get_accounts.cfm">
<cfinclude template="../query/get_expense_center.cfm">
<cfquery name="GET_CREDIT_CONTRACT" datasource="#DSN3#">
	SELECT
		CC.COMPANY_ID,
		CC.PARTNER_ID,
		CC.MONEY_TYPE
		<cfif isdefined("attributes.credit_contract_row_id")>		
			,CCR.PROCESS_DATE
			,CCR.CAPITAL_PRICE
			,CCR.INTEREST_PRICE
			,CCR.TAX_PRICE
			,CCR.TOTAL_PRICE
			,CCR.EXPENSE_CENTER_ID
			,CCR.EXPENSE_ITEM_ID
			,CCR.INTEREST_ACCOUNT_ID
			,CCR.TOTAL_EXPENSE_ITEM_ID
			,CCR.TOTAL_ACCOUNT_ID
			,CCR.CAPITAL_EXPENSE_ITEM_ID
			,CCR.CAPITAL_ACCOUNT_ID
		<cfelse>
			,0 AS PROCESS_DATE
			,0 AS CAPITAL_PRICE
			,0 AS INTEREST_PRICE
			,0 AS TAX_PRICE
			,0 AS TOTAL_PRICE
			,0 AS EXPENSE_CENTER_ID
			,0 AS EXPENSE_ITEM_ID
			,'' AS INTEREST_ACCOUNT_ID
			,0 AS TOTAL_EXPENSE_ITEM_ID
			,'' AS TOTAL_ACCOUNT_ID
			,0 AS CAPITAL_EXPENSE_ITEM_ID
			,'' AS CAPITAL_ACCOUNT_ID
		</cfif>
	FROM
		<cfif isdefined("attributes.credit_contract_row_id")>
			CREDIT_CONTRACT_ROW CCR,
		</cfif>
		CREDIT_CONTRACT CC
	WHERE
		<cfif isdefined("attributes.credit_contract_row_id")>		
			CCR.CREDIT_CONTRACT_ROW_ID = #attributes.credit_contract_row_id# AND
			CCR.CREDIT_CONTRACT_ID = CC.CREDIT_CONTRACT_ID AND
		</cfif>
		CC.CREDIT_CONTRACT_ID = #attributes.credit_contract_id#
</cfquery>
<cfif IsDefined("GET_CREDIT_CONTRACT") and len(GET_CREDIT_CONTRACT.company_id)>
 <cfquery name="get_partner" datasource="#dsn#">
    SELECT MANAGER_PARTNER_ID FROM COMPANY WHERE COMPANY_ID=#GET_CREDIT_CONTRACT.company_id#
</cfquery>
</cfif>
<cfset item_id_list=''>
<cfif get_credit_contract.recordcount>
	<cfoutput query="get_credit_contract">
		<cfif len(expense_item_id) and not listfind(item_id_list,expense_item_id)>
			<cfset item_id_list=listappend(item_id_list,expense_item_id)>
		</cfif>
		<cfif len(total_expense_item_id) and not listfind(item_id_list,total_expense_item_id)>
			<cfset item_id_list=listappend(item_id_list,total_expense_item_id)>
		</cfif>
		<cfif len(capital_expense_item_id) and not listfind(item_id_list,capital_expense_item_id)>
			<cfset item_id_list=listappend(item_id_list,capital_expense_item_id)>
		</cfif>
	</cfoutput>
	<cfif len(item_id_list)>
		<cfset item_id_list=listsort(item_id_list,"numeric","ASC",",")>
		<cfquery name="get_exp_detail" datasource="#dsn2#">
			SELECT EXPENSE_ITEM_NAME,ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID IN (#item_id_list#) ORDER BY EXPENSE_ITEM_ID
		</cfquery>
	</cfif>	
</cfif>
<cfset str_linke_ait="&field_comp_id=add_credit_payment.company_id&field_partner=add_credit_payment.partner_id&field_comp_name=add_credit_payment.company&field_name=add_credit_payment.partner&select_list=2">
<cf_papers paper_type="credit_payment">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfform name="add_credit_payment">
		<cf_box>
			<input type="hidden" name="credit_contract_id" id="credit_contract_id" value="<cfoutput>#url.credit_contract_id#</cfoutput>">
			<input type="hidden" name="is_capital_budget_act" id="is_capital_budget_act" value="<cfoutput>#is_capital_budget_act#</cfoutput>">
			<cfif isdefined("attributes.credit_contract_row_id")>
				<input type="hidden" name="credit_contract_row_id" id="credit_contract_row_id" value="<cfoutput>#url.credit_contract_row_id#</cfoutput>">
			</cfif>
			<cf_box_elements>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-process_cat">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='40683.İşlem Kategorisi'> *</label>
						<div class="col col-8 col-xs-12">
							<cf_workcube_process_cat process_type_info="291">
						</div>
					</div>
					<div class="form-group" id="item-document_no">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57880.Belge No'>*</label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="document_no" id="document_no" maxlength="20" value="<cfoutput>#paper_code & '-' & paper_number#</cfoutput>">
						</div>
					</div>
					<div class="form-group" id="item-company">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51334.Kredi Kurumu'></label>
						<div class="col col-8 col-xs-12">
							<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_credit_contract.company_id#</cfoutput>">
							<input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#get_credit_contract.partner_id#</cfoutput>">
							<div class="input-group">
								<input type="text" name="company" id="company" value="<cfoutput>#get_par_info(get_credit_contract.company_id,1,1,0)#</cfoutput>" readonly>
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_all_pars#str_linke_ait#</cfoutput>');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-partner">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57578.Yetkili'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="partner" id="partner" value="<cfif len(get_credit_contract.partner_id)><cfoutput>#get_par_info(get_partner.MANAGER_PARTNER_ID ,0,-1,0)#</cfoutput></cfif>" readonly>
						</div>
					</div>
					<div class="form-group" id="item-action_from_account_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51343.Banka Hesabına'> *</label>
						<div class="col col-8 col-xs-12">
							<select name="action_from_account_id" id="action_from_account_id" onchange="showDepartment(this.value);write_total_amount(1);kur_ekle_f_hesapla('action_from_account_id');">
								<option value=""><cf_get_lang dictionary_id='58693.Seç'></option>
								<cfoutput query="get_accounts">
									<option value="#account_id#;#account_currency_id#;#ListGetAt(session.ep.user_location,2,"-")#">#account_name#&nbsp;#account_currency_id#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-branch_place"><!--- banka seçildiğinde doluyor --->
					</div>
					<div class="form-group" id="item-expense_center_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58172.Gelir Merkezi'> *</label>
						<div class="col col-8 col-xs-12">
							<select name="expense_center_id" id="expense_center_id">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_expense_center">
									<option value="#expense_id#"<cfif get_credit_contract.expense_center_id eq expense_id>selected</cfif>>#expense#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-project_name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
						<div class="col col-8 col-xs-12">
							<cfif not isDefined("attributes.project_id")><cfset attributes.project_id = ""></cfif>
							<cf_wrkProject project_Id="#attributes.project_id#" fieldName="project_name" AgreementNo="1" Customer="2" Employee="3" Priority="4" Stage="5" boxwidth="600" boxheight="400" buttontype="2">
						</div>
					</div>
					<div class="form-group" id="item-payment_date">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'> *</label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='51377.Kredi Ödeme Tarihini Kontrol Ediniz'>!</cfsavecontent>
							<div class="input-group">
								<cfinput type="text" name="payment_date" id="payment_date" value="#dateformat(now(),dateformat_style)#" required="yes" validate="#validate_style#" message="#message#" maxlength="10" onBlur="change_money_info('add_credit_payment','payment_date');">
								<span class="input-group-addon"><cf_wrk_date_image date_field="payment_date" call_function="change_money_info"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-details">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
						<div class="col col-8 col-xs-12">
							<textarea name="details" id="details" style="height:45px;"></textarea>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="false">
					<div clas="form-group">
						<label class ="bold"><cf_get_lang dictionary_id='30134.İşlem Para Br.'><label>
					</div>
					<div class="form-group" id="item-kur_ekle">
						<div class="col col-12 scrollContent scroll-x2">
							<cfscript>f_kur_ekle(process_type:0,base_value:'cash_action_value',call_function:'write_total_amount',other_money_value:'other_cash_act_value',form_name:'add_credit_payment',select_input:'action_from_account_id',selected_money='#GET_CREDIT_CONTRACT.MONEY_TYPE#',is_disable='1');</cfscript>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_grid_list>
				<thead> 
					<tr>
						<th></td>
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
								<input type="text" name="capital_price" id="capital_price" value="<cfoutput>#Tlformat(get_credit_contract.capital_price,session.ep.our_company_info.rate_round_num)#</cfoutput>" onkeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(1);kur_ekle_f_hesapla('action_from_account_id');" class="moneybox" style="width:120px;">
							</div>
						</td>
						<td>
							<div class="form-group">
								<input type="text" name="capital_price_other" id="capital_price_other" value="" onkeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(2);kur_ekle_f_hesapla('action_from_account_id');" class="moneybox" style="width:120px;">
							</div>
						</td>
						<td>
							<div class="form-group">
								<div class="input-group">
									<input type="hidden" name="debt_account_id" id="debt_account_id" value="<cfif len(get_credit_contract.capital_account_id)><cfoutput>#get_credit_contract.capital_account_id#</cfoutput></cfif>">
									<input type="text" name="debt_account_code" id="debt_account_code" value="<cfif len(get_credit_contract.capital_account_id)><cfoutput>#get_credit_contract.capital_account_id#</cfoutput></cfif>" onfocus="AutoComplete_Create('debt_account_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','debt_account_id','add_credit_payment','3','140');" style="width:120px;">
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_credit_payment.debt_account_id&field_name=add_credit_payment.debt_account_code');"></span>
								</div>	
							</div>
						</td>
						<td>
							<cfif is_capital_budget_act neq 0>
								<div class="form-group">
									<div class="input-group">
										<input type="hidden" name="capital_expense_id" id="capital_expense_id" value="<cfif len(get_credit_contract.capital_expense_item_id)><cfoutput>#get_credit_contract.capital_expense_item_id#</cfoutput></cfif>">
										<input type="text" name="capital_expense" id="capital_expense" value="<cfif len(get_credit_contract.capital_expense_item_id) and len(item_id_list)><cfoutput>#get_exp_detail.expense_item_name[listfind(item_id_list,get_credit_contract.capital_expense_item_id,',')]#</cfoutput></cfif>" onfocus="AutoComplete_Create('capital_expense','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID,ACCOUNT_CODE,ACCOUNT_CODE','capital_expense_id,debt_account_code,debt_account_id','add_credit_payment',3);" autocomplete="off" style="width:140px;">
										<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=add_credit_payment.capital_expense_id&field_name=add_credit_payment.capital_expense&field_account_no=add_credit_payment.debt_account_id&field_account_no2=add_credit_payment.debt_account_code');"></span>
									</div>
								</div>
							</cfif>
						</td>
					
					</tr>
					<tr>
						<td><cf_get_lang dictionary_id='51367.Faiz'></td>
						<td>
							<div class="form-group">
								<input type="text" name="interest_price" id="interest_price" value="<cfoutput>#Tlformat(get_credit_contract.interest_price,session.ep.our_company_info.rate_round_num)#</cfoutput>" onkeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(1);kur_ekle_f_hesapla('action_from_account_id');" class="moneybox" style="width:120px;">
							</div>
						</td>
						<td>
							<div class="form-group">
								<input type="text" name="interest_price_other" id="interest_price_other" value="" onkeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(2);kur_ekle_f_hesapla('action_from_account_id');" class="moneybox" style="width:120px;">
							</div>
						</td>
						<td>
							<div class="form-group">
								<div class="input-group">
									<input type="hidden" name="debt_account_id2" id="debt_account_id2" value="<cfif len(get_credit_contract.interest_account_id)><cfoutput>#get_credit_contract.interest_account_id#</cfoutput></cfif>">
									<input type="text" name="debt_account_code2" id="debt_account_code2" value="<cfif len(get_credit_contract.interest_account_id)><cfoutput>#get_credit_contract.interest_account_id#</cfoutput></cfif>" onfocus="AutoComplete_Create('debt_account_code2','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','debt_account_id2','add_credit_payment','3','140');" autocomplete="off" style="width:140px;">
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_credit_payment.debt_account_id2&field_name=add_credit_payment.debt_account_code2');"></span>
								</div>
							</div>	
						</td>
						<td> 
							<div class="form-group">
								<div class="input-group">
									<input type="hidden" name="interest_expense_id" id="interest_expense_id" value="<cfif len(get_credit_contract.expense_item_id)><cfoutput>#get_credit_contract.expense_item_id#</cfoutput></cfif>">
									<input type="text" name="interest_expense" id="interest_expense" value="<cfif len(get_credit_contract.expense_item_id) and len(item_id_list)><cfoutput>#get_exp_detail.expense_item_name[listfind(item_id_list,get_credit_contract.expense_item_id,',')]#</cfoutput></cfif>" onfocus="AutoComplete_Create('interest_expense','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID,ACCOUNT_CODE,ACCOUNT_CODE','interest_expense_id,debt_account_code2,debt_account_id2','add_credit_payment',3);" autocomplete="off" style="width:140px;">
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=add_credit_payment.interest_expense_id&field_name=add_credit_payment.interest_expense&field_account_no=add_credit_payment.debt_account_id2&field_account_no2=add_credit_payment.debt_account_code2');"></span>
								</div>   
							</div>
						</td>
					</tr>
					<tr>
						<td><cf_get_lang dictionary_id='39657.Gecikme'></td>
						<td>
							<div class="form-group">
								<input type="text" name="delay_price" id="delay_price" value="<cfoutput>#Tlformat(0,session.ep.our_company_info.rate_round_num)#</cfoutput>" onkeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(1);kur_ekle_f_hesapla('action_from_account_id');" class="moneybox" style="width:120px;">
							</div>
						</td>
						<td>
							<div class="form-group">
								<input type="text" name="delay_price_other" id="delay_price_other" value="" onkeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(2);kur_ekle_f_hesapla('action_from_account_id');" class="moneybox" style="width:120px;" />
							</div>
						</td>
						<td>
							<div class="form-group">
								<div class="input-group">
									<input type="hidden" name="debt_account_id4" id="debt_account_id4" value="">
									<cfinput type="text" name="debt_account_code4" id="debt_account_code4" value="" onFocus="AutoComplete_Create('debt_account_code4','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','debt_account_id4','add_credit_payment','3','140');" autocomplete="off" style="width:140px;">	
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_credit_payment.debt_account_id4&field_name=add_credit_payment.debt_account_code4');"></span>
								</div>	
							</div>
						</td>
						<td>
							<div class="form-group">
								<div class="input-group">
									<input type="hidden" name="delay_expense_id" id="delay_expense_id" value="">
									<cfinput type="text" name="delay_expense" id="delay_expense" value="" onFocus="AutoComplete_Create('delay_expense','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID,ACCOUNT_CODE,ACCOUNT_CODE','delay_expense_id,debt_account_code4,debt_account_id4','add_credit_payment',3);" autocomplete="off" style="width:140px;">
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=add_credit_payment.delay_expense_id&field_name=add_credit_payment.delay_expense&field_account_no=add_credit_payment.debt_account_id4&field_account_no2=add_credit_payment.debt_account_code4');"></span>
								</div>
							</div>  
						</td>
					</tr>
				</tbody>
				<tfoot>   
					<tr>
						<td><cf_get_lang dictionary_id='29534.Toplam Tutar'></td>
						<td style="text-align:left;">
							<div class="form-group">
								<input type="text" name="cash_action_value" id="cash_action_value" value="<cfoutput>#Tlformat(get_credit_contract.total_price,session.ep.our_company_info.rate_round_num)#</cfoutput>" onblur="kur_ekle_f_hesapla('action_from_account_id');" onkeyup="return(FormatCurrency(this,event));" class="moneybox" readonly style="width:120px;">
							</div>
						</td>
						<td style="text-align:left;">
							<div class="form-group">
								<input type="text" name="other_cash_act_value" id="other_cash_act_value" value="" onblur="kur_ekle_f_hesapla('action_from_account_id',true);" class="moneybox" style="width:120px;"></td>
								<input type="hidden" name="system_amount_value" id="system_amount_value" value="">
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
						<td><cf_get_lang dictionary_id='62390.Vergi/Masraf'></td>
						<td>
							<div class="form-group">
								<input type="hidden" name="row_kontrol1" id="row_kontrol1" value="1">
								<input type="text" name="tax_price_1" id="tax_price_1" value="<cfoutput>#Tlformat(get_credit_contract.tax_price,session.ep.our_company_info.rate_round_num)#</cfoutput>" onkeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(1);kur_ekle_f_hesapla('action_from_account_id');" class="moneybox" style="width:120px;">
							</div>
						</td>
						<td>
							<div class="form-group">
								<input type="text" name="tax_price_other_1" id="tax_price_other_1" value="" onkeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(2);kur_ekle_f_hesapla('action_from_account_id');" class="moneybox" style="width:120px;">
							</div>
						</td>
						<td>
							<div class="form-group">
								<div class="input-group">
									<input type="hidden" name="debt_account_id3_1" id="debt_account_id3_1" value="<cfif len(get_credit_contract.interest_account_id)><cfoutput>#get_credit_contract.total_account_id#</cfoutput></cfif>">
									<input type="text" name="debt_account_code3_1" id="debt_account_code3_1" value="<cfif len(get_credit_contract.interest_account_id)><cfoutput>#get_credit_contract.total_account_id#</cfoutput></cfif>" onfocus="AutoComplete_Create('debt_account_code3_1','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','debt_account_id3_1','add_credit_payment','3','140');" autocomplete="off" style="width:140px;">
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_credit_payment.debt_account_id3_1&field_name=add_credit_payment.debt_account_code3_1');"></span>
								</div>
							</div>
						</td>
						<td>
							<div class="form-group">
								<div class="input-group">
									<input type="hidden" name="tax_expense_id_1" id="tax_expense_id_1" value="<cfif len(get_credit_contract.total_expense_item_id)><cfoutput>#get_credit_contract.total_expense_item_id#</cfoutput></cfif>"> 
									<input type="text" name="tax_expense_1" id="tax_expense_1" value="<cfif len(get_credit_contract.total_expense_item_id) and len(item_id_list)><cfoutput>#get_exp_detail.expense_item_name[listfind(item_id_list,get_credit_contract.total_expense_item_id,',')]#</cfoutput></cfif>" onfocus="AutoComplete_Create('tax_expense_1','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID,ACCOUNT_CODE,ACCOUNT_CODE','tax_expense_id_1,debt_account_code3_1,debt_account_id3_1','add_credit_payment',3);" autocomplete="off" style="width:140px;">
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=add_credit_payment.tax_expense_id_1&field_name=add_credit_payment.tax_expense_1&field_account_no=add_credit_payment.debt_account_id3_1&field_account_no2=add_credit_payment.debt_account_code3_1');"></span>
								</div>
							</div>
						</td>
						<td width="15" style="text-align:center;"><span class="icon-pluss"  onclick="add_row();"></span></td>
					</tr>
				</tbody>
			</cf_grid_list>
			<cf_box_footer>
				<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
			</cf_box_footer>
		</cf_box>
	</cfform>
</div>

<script type="text/javascript">
	row_count = 1;
	function sil(sy)
	{
		var my_element=eval("add_credit_payment.row_kontrol"+sy);
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
		document.add_credit_payment.record_num.value=row_count;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '&nbsp;';		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="input-group"><input type="text" name="tax_price_'+ row_count +'" id="tax_price_'+ row_count +'" value="'+commaSplit(0,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>)+'" onkeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(1);kur_ekle_f_hesapla(\'action_from_account_id\');" class="moneybox" style="width:120px;"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="input-group"><input type="text" name="tax_price_other_'+ row_count +'" id="tax_price_other_'+ row_count +'" value="'+commaSplit(0,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>)+'" onkeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(2);kur_ekle_f_hesapla(\'action_from_account_id\');" class="moneybox" style="width:120px;"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="input-group"><input type="hidden" name="debt_account_id3_'+ row_count +'" id="debt_account_id3_'+ row_count +'" value=""><input type="text" style="width:140px;" name="debt_account_code3_'+ row_count +'" id="debt_account_code3_'+ row_count +'" value="" onFocus="auto_account('+ row_count +');">   <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac_acc('+ row_count +');"></span></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="input-group"><input type="hidden" name="tax_expense_id_'+ row_count +'" id="tax_expense_id_'+ row_count +'" value=""><input type="text" style="width:140px;" name="tax_expense_'+ row_count +'" id="tax_expense_'+ row_count +'" value="" onFocus="auto_expense('+ row_count +');">   <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac_expense('+ row_count +');"></span><input type="hidden" value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<span class="icon-minus" onclick="sil(' + row_count + ');"></span>';
	}
	function auto_account(no)
	{
		AutoComplete_Create('debt_account_code3_'+no,'ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','debt_account_id3_'+no,'add_credit_payment','3','140');
	}
	function auto_expense(no)
	{
		AutoComplete_Create('tax_expense_'+no,'EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID,ACCOUNT_CODE,ACCOUNT_CODE','tax_expense_id_'+no+',debt_account_code3_'+no+',debt_account_id3_'+no,'add_credit_payment','3');
	}	
	function pencere_ac_acc(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_credit_payment.debt_account_id3_' + no +'&field_name=add_credit_payment.debt_account_code3_' + no +'');
	}
	function pencere_ac_expense(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=add_credit_payment.tax_expense_id_' + no +'&field_name=add_credit_payment.tax_expense_' + no +'&field_account_no=add_credit_payment.debt_account_id3_' + no +'&field_account_no2=add_credit_payment.debt_account_code3_' + no +'');
	}
	function kontrol()
	{
		process=document.add_credit_payment.process_cat.value;
		var get_process_cat = wrk_safe_query('chq_get_process_cat','dsn3',0,process);
		/* tarih kontrolu */
		if(get_process_cat.IS_ACCOUNT == 1 && document.getElementById('payment_date').value != "")
			if(!chk_period(add_credit_payment.payment_date,"İşlem")) return false;
			
		if(!chk_process_cat('add_credit_payment')) return false;
		if(!check_display_files('add_credit_payment')) return false;
		if(add_credit_payment.document_no != "")
			{
				if(!paper_control(add_credit_payment.document_no,'CREDIT_PAYMENT','1','','','','','','<cfoutput>#dsn2#</cfoutput>')) return false;
			}
			if(add_credit_payment.document_no.value == "")
			{
				alert('<cf_get_lang dictionary_id='40958.Belge Numarası Boş Bırakılamaz!'> : <cf_get_lang dictionary_id='57880.Belge No'>');
				return false;
			}
		<cfif is_company_required eq 1>
			if(document.add_credit_payment.company_id.value=='')	
			{
				alert("<cf_get_lang dictionary_id='51348.Lütfen Kredi Kurumu Seçiniz'>! ");
				return false;
			}
		</cfif>
		x = document.add_credit_payment.action_from_account_id.selectedIndex;
		if (document.add_credit_payment.action_from_account_id[x].value == "")
		{
			alert("<cf_get_lang dictionary_id='50020.Banka Hesabı Seçiniz'>!");
			return false;
		}	
		if (document.add_credit_payment.expense_center_id.value == "")
		{
			alert("<cf_get_lang dictionary_id='50369.Masraf Merkezi Seçiniz'>!");
			return false;
		}
		if(document.add_credit_payment.payment_date.value == "")
		{
			alert("<cf_get_lang dictionary_id='51372.Lütfen Ödeme Tarihi Giriniz'>!");
			return false;
		}
		if( document.getElementById('debt_account_code').value=='' )
		{
			alert("<cf_get_lang dictionary_id='54549.Anapara muhasebe kodu giriniz'>!");
			return false;
		}
		
		if(filterNum(document.getElementById('interest_price').value) != 0 && document.getElementById('debt_account_code2').value=='' )
		{
			alert("<cf_get_lang dictionary_id='54551.Faiz muhasebe kodu giriniz'>!");
			return false;
		}
		
		if(filterNum(document.getElementById('delay_price').value) != 0 && document.getElementById('debt_account_code4').value=='' )
		{
			alert("<cf_get_lang dictionary_id='54556.Gecikme muhasebe kodu giriniz'>!");
			return false;
		}
		
		if(filterNum(document.getElementById('tax_price_1').value) != 0 && document.getElementById('debt_account_code3_1').value=='' )
		{
			alert("<cf_get_lang dictionary_id='54561.Vergi muhasebe kodu giriniz'>!");
			return false;
		}
		
		<cfif is_budget_control eq 1>
			if(document.add_credit_payment.is_capital_budget_act.value == 1 && filterNum(document.add_credit_payment.capital_price.value) != 0 && document.add_credit_payment.capital_expense.value == "")
			{
				alert("<cf_get_lang dictionary_id='54562.Lütfen Ana Para Gider Kalemi Seçiniz'>!");
				return false;		
			}
			if(filterNum(document.add_credit_payment.interest_price.value) != 0 && document.add_credit_payment.interest_expense_id.value == "")
			{
				alert("<cf_get_lang dictionary_id='51384.Lütfen Faiz Gider Kalemi Seçiniz'>!");
				return false;
			}
		</cfif>
		if(filterNum(document.add_credit_payment.interest_price.value) != 0 && document.add_credit_payment.debt_account_code2.value == "")
		{
			alert("<cf_get_lang dictionary_id='51405.Lütfen Faiz Muhasebe Kodu Seçiniz'>!");
			return false;
		}
		<cfif is_budget_control eq 1>
			if(filterNum(document.add_credit_payment.delay_price.value) != 0 && document.add_credit_payment.delay_expense_id.value == "")
			{
				alert("<cf_get_lang dictionary_id='51386.Lütfen Gecikme Gider Kalemi Seçiniz'> !");
				return false;
			}
		</cfif>
		if(filterNum(document.add_credit_payment.delay_price.value) != 0 && document.add_credit_payment.debt_account_code4.value == "")
		{
			alert("<cf_get_lang dictionary_id='54539.Lütfen Gecikme Muhasebe Kodu Seçiniz'>!");
			return false;
		}
		for(r=1;r<=document.add_credit_payment.record_num.value;r++)
		{
			if(eval("document.add_credit_payment.row_kontrol"+r).value==1)
			{
				<cfif is_budget_control eq 1>
					if(filterNum(eval('document.add_credit_payment.tax_price_'+r).value) > 0 && eval('document.add_credit_payment.tax_expense_id_'+r).value == "")
					{
						alert("<cf_get_lang dictionary_id='62392.Lütfen Vergi Gider Kalemi Seçiniz'> !");
						return false;
					}
				</cfif>
				if(filterNum(eval('document.add_credit_payment.tax_price_'+r).value) > 0 && eval('document.add_credit_payment.debt_account_id3_'+r).value == "")
				{
					alert("<cf_get_lang dictionary_id='54540.Lütfen Vergi Muhasebe Kodu Seçiniz'>!");
					return false;
				}
			}
		}
		unformat_fields();
		return true;
	}
	function pencere_ac_acc2(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_credit_payment.debt_account_id' + no +'&field_name=add_credit_payment.debt_account_code' + no +'');
	}
	function write_total_amount(type)
	{ 
		if(type == undefined) type = 1;
		bank_currency_type = list_getat(document.getElementById("action_from_account_id").value,2,';');
		if(bank_currency_type == '')
			bank_currency_type = '<cfoutput>#session.ep.money#</cfoutput>'
		for(s=1;s<=document.getElementById("kur_say").value;s++)
		{
			if(document.add_credit_payment.rd_money[s-1].checked == true)
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
					for(r=1;r<=document.add_credit_payment.record_num.value;r++)
					{
						if(eval("document.add_credit_payment.row_kontrol"+r).value==1)
						{
							if(eval('document.add_credit_payment.tax_price_'+r).value != "")
				    			eval('document.add_credit_payment.tax_price_other_'+r).value = commaSplit(parseFloat(filterNum(eval('document.add_credit_payment.tax_price_'+r).value,'#session.ep.our_company_info.rate_round_num#'))*rate_1/rate_2,'#session.ep.our_company_info.rate_round_num#');
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
					for(r=1;r<=document.add_credit_payment.record_num.value;r++)
					{
						if(eval("document.add_credit_payment.row_kontrol"+r).value==1)
						{
							if(eval('document.add_credit_payment.tax_price_other_'+r).value != "")
				    			eval('document.add_credit_payment.tax_price_'+r).value = commaSplit(parseFloat(filterNum(eval('document.add_credit_payment.tax_price_other_'+r).value,'#session.ep.our_company_info.rate_round_num#'))/rate_1*rate_2,'#session.ep.our_company_info.rate_round_num#');
						}
					}
				}
			}
		var total_price = 0;
		var other_total_price = 0;
		var system_amount = 0;
		if(document.add_credit_payment.capital_price.value != "")
			total_price += parseFloat(filterNum(add_credit_payment.capital_price.value));
		if(document.add_credit_payment.interest_price.value != "")
			total_price += parseFloat(filterNum(add_credit_payment.interest_price.value));
		if(document.add_credit_payment.delay_price.value != "")
			total_price += parseFloat(filterNum(add_credit_payment.delay_price.value));
		for(r=1;r<=document.add_credit_payment.record_num.value;r++)
		{
			if(eval("document.add_credit_payment.row_kontrol"+r).value==1)
			{
				if(eval('document.add_credit_payment.tax_price_'+r).value != "")
					total_price += parseFloat(filterNum(eval('document.add_credit_payment.tax_price_'+r).value));
			}
		}
		if(document.add_credit_payment.capital_price_other.value != "")
			other_total_price += parseFloat(filterNum(add_credit_payment.capital_price_other.value));
		if(document.add_credit_payment.interest_price_other.value != "")
			other_total_price += parseFloat(filterNum(add_credit_payment.interest_price_other.value));
		if(document.add_credit_payment.delay_price_other.value != "")
			other_total_price += parseFloat(filterNum(add_credit_payment.delay_price_other.value));
		for(r=1;r<=document.add_credit_payment.record_num.value;r++)
		{
			if(eval("document.add_credit_payment.row_kontrol"+r).value==1)
			{
				if(eval('document.add_credit_payment.tax_price_other_'+r).value != "")
					other_total_price += parseFloat(filterNum(eval('document.add_credit_payment.tax_price_other_'+r).value));
			}
		}
		rate_2 = parseFloat(filterNum(form_txt_rate2_,'#session.ep.our_company_info.rate_round_num#'),'#session.ep.our_company_info.rate_round_num#');
		document.add_credit_payment.cash_action_value.value = commaSplit(total_price,'#session.ep.our_company_info.rate_round_num#');
		document.add_credit_payment.other_cash_act_value.value = commaSplit(other_total_price,'#session.ep.our_company_info.rate_round_num#');
		document.add_credit_payment.system_amount_value.value = commaSplit(parseFloat(total_price)*rate_2,'#session.ep.our_company_info.rate_round_num#');			
		</cfoutput>
	}
	function unformat_fields()
	{
		<cfoutput>
			document.add_credit_payment.capital_price.value = filterNum(document.add_credit_payment.capital_price.value,'#session.ep.our_company_info.rate_round_num#');
			document.add_credit_payment.interest_price.value = filterNum(document.add_credit_payment.interest_price.value,'#session.ep.our_company_info.rate_round_num#');
			document.add_credit_payment.interest_price_other.value = filterNum(document.add_credit_payment.interest_price_other.value,'#session.ep.our_company_info.rate_round_num#');
			document.add_credit_payment.delay_price.value = filterNum(document.add_credit_payment.delay_price.value,'#session.ep.our_company_info.rate_round_num#');
			document.add_credit_payment.delay_price_other.value = filterNum(document.add_credit_payment.delay_price_other.value,'#session.ep.our_company_info.rate_round_num#');
			for(r=1;r<=document.add_credit_payment.record_num.value;r++)
			{
				if(eval("document.add_credit_payment.row_kontrol"+r).value==1)
				{
					if(eval('document.add_credit_payment.tax_price_'+r).value != "")
						eval('document.add_credit_payment.tax_price_'+r).value = filterNum(eval('document.add_credit_payment.tax_price_'+r).value,'#session.ep.our_company_info.rate_round_num#');

					if(eval('document.add_credit_payment.tax_price_other_'+r).value != "")
						eval('document.add_credit_payment.tax_price_other_'+r).value = filterNum(eval('document.add_credit_payment.tax_price_other_'+r).value,'#session.ep.our_company_info.rate_round_num#');
				}
			}
			document.add_credit_payment.cash_action_value.value = filterNum(document.add_credit_payment.cash_action_value.value,'#session.ep.our_company_info.rate_round_num#');
			document.add_credit_payment.other_cash_act_value.value = filterNum(document.add_credit_payment.other_cash_act_value.value,'#session.ep.our_company_info.rate_round_num#');
			add_credit_payment.system_amount.value = filterNum(add_credit_payment.system_amount.value,'#session.ep.our_company_info.rate_round_num#');
			add_credit_payment.system_amount_value.value = filterNum(add_credit_payment.system_amount_value.value,'#session.ep.our_company_info.rate_round_num#');
			for(var i=1;i<=add_credit_payment.kur_say.value;i++)
			{
				eval('add_credit_payment.txt_rate1_' + i).value = filterNum(eval('add_credit_payment.txt_rate1_' + i).value,'#session.ep.our_company_info.rate_round_num#');
				eval('add_credit_payment.txt_rate2_' + i).value = filterNum(eval('add_credit_payment.txt_rate2_' + i).value,'#session.ep.our_company_info.rate_round_num#');
			}
		</cfoutput>
	}
$( document ).ready(function() {
    kur_ekle_f_hesapla('action_from_account_id');
});
	function showDepartment(no)	
	{
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=credit.popup_ajax_list_branch&action_from_account_id="+no;

		AjaxPageLoad(send_address,'item-branch_place',1,'İlişkili Şubeler');
	}
</script>
