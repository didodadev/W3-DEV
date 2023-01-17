<cf_xml_page_edit fuseact="credit.add_credit_contract">
<cfquery name="GET_CREDIT_CONTRACT" datasource="#DSN3#">
	SELECT CC.*, (E.EMPLOYEE_NAME+E.EMPLOYEE_SURNAME) AS SORUMLU FROM CREDIT_CONTRACT CC LEFT JOIN #dsn#.EMPLOYEES AS E ON E.EMPLOYEE_ID=CC.CREDIT_EMP_ID WHERE CREDIT_CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.credit_contract_id#">
</cfquery>
<cfif len(GET_CREDIT_CONTRACT.PROJECT_ID)>
	<cfquery name="GET_PROJECT_HEAD" datasource="#DSN#">
		SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_credit_contract.project_id#">
	</cfquery>
</cfif>
<cfquery name="GET_ROWS_1" datasource="#DSN3#">
	SELECT 
		CREDIT_CONTRACT_ROW_ID,
		CREDIT_CONTRACT_TYPE,
		CREDIT_CONTRACT_ID,
		PROCESS_DATE,
		CAPITAL_PRICE,					
		INTEREST_PRICE,
		TAX_PRICE,
		TOTAL_PRICE,
		OTHER_MONEY,
		EXPENSE_CENTER_ID,
		EXPENSE_ITEM_ID,
		INTEREST_ACCOUNT_ID,
		TOTAL_EXPENSE_ITEM_ID,
		TOTAL_ACCOUNT_ID,	
		DETAIL,
		IS_PAID,
		CAPITAL_EXPENSE_ITEM_ID,
		CAPITAL_ACCOUNT_ID,
        BORROW,
        LEASING 
	FROM 
		CREDIT_CONTRACT_ROW 
	WHERE 
		CREDIT_CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.credit_contract_id#"> 
		AND CREDIT_CONTRACT_TYPE = 1 
		AND IS_PAID = 0
</cfquery>
<cfquery name="GET_ROWS_2" datasource="#DSN3#">
	SELECT 
		CREDIT_CONTRACT_ROW_ID,
		CREDIT_CONTRACT_TYPE,
		CREDIT_CONTRACT_ID,
		PROCESS_DATE,
		CAPITAL_PRICE,					
		INTEREST_PRICE,
		TAX_PRICE,
		TOTAL_PRICE,
		OTHER_MONEY,
		EXPENSE_CENTER_ID,
		EXPENSE_ITEM_ID,
		INTEREST_ACCOUNT_ID,
		TOTAL_EXPENSE_ITEM_ID,
		TOTAL_ACCOUNT_ID,	
		DETAIL,
		IS_PAID,
		CAPITAL_EXPENSE_ITEM_ID,
		CAPITAL_ACCOUNT_ID ,
        BORROW,
        LEASING 
	FROM 
		CREDIT_CONTRACT_ROW 
	WHERE 
		CREDIT_CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.credit_contract_id#"> 
		AND CREDIT_CONTRACT_TYPE = 2 
		AND IS_PAID = 0
</cfquery>
<cfquery name="get_credit_limit" datasource="#dsn3#">
	SELECT * FROM CREDIT_LIMIT ORDER BY LIMIT_HEAD
</cfquery>
<cfquery name="get_expense_center" datasource="#dsn2#">
	SELECT EXPENSE_ID,EXPENSE,EXPENSE_CODE FROM EXPENSE_CENTER WHERE EXPENSE_ACTIVE = 1 ORDER BY EXPENSE
</cfquery>
<cfquery name="get_credit_contract_payment_income" datasource="#dsn2#">
	SELECT * FROM CREDIT_CONTRACT_PAYMENT_INCOME WHERE CREDIT_CONTRACT_ROW_ID IN (SELECT CREDIT_CONTRACT_ROW_ID FROM #dsn3_alias#.CREDIT_CONTRACT_ROW WHERE CREDIT_CONTRACT_ID = #url.credit_contract_id#)
</cfquery>
<cfquery name="get_credit_contract_income_control" datasource="#dsn2#"><!--- Gerceklesen satirlar olsumus ise sozlesme silinmemeli --->
	SELECT * FROM CREDIT_CONTRACT_PAYMENT_INCOME WHERE CREDIT_CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.credit_contract_id#">
</cfquery>
<cfquery name="GET_MONEY" datasource="#dsn3#">
	SELECT MONEY_TYPE AS MONEY,* FROM CREDIT_CONTRACT_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.credit_contract_id#">
</cfquery>
<cfif not GET_MONEY.recordcount>
	<cfquery name="GET_MONEY" datasource="#DSN#">
		SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS=1 ORDER BY MONEY_ID
	</cfquery>
</cfif>
<cfset item_id_list=''>
<cfif get_rows_1.recordcount>
	<cfoutput query="get_rows_1">
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
<cfset revenue_item_id_list=''>
<cfif get_rows_2.recordcount>
	<cfoutput query="get_rows_2">
		<cfif len(expense_item_id) and not listfind(revenue_item_id_list,expense_item_id)>
			<cfset revenue_item_id_list=listappend(revenue_item_id_list,expense_item_id)>
		</cfif>
		<cfif len(total_expense_item_id) and not listfind(revenue_item_id_list,total_expense_item_id)>
			<cfset revenue_item_id_list=listappend(revenue_item_id_list,total_expense_item_id)>
		</cfif>
		<cfif len(capital_expense_item_id) and not listfind(revenue_item_id_list,capital_expense_item_id)>
			<cfset revenue_item_id_list=listappend(revenue_item_id_list,capital_expense_item_id)>
		</cfif>
	</cfoutput>
	<cfif len(revenue_item_id_list)>
		<cfset revenue_item_id_list=listsort(revenue_item_id_list,"numeric","ASC",",")>
		<cfquery name="get_exp_detail_2" datasource="#dsn2#">
			SELECT EXPENSE_ITEM_NAME,ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID IN (#revenue_item_id_list#) ORDER BY EXPENSE_ITEM_ID
		</cfquery>
	</cfif>	
</cfif>
<cf_papers paper_type="credit">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="upd_credit_contract" action="" method="post">
			<input type="hidden" name="rowCount" id="rowCount" value="<cfoutput>#get_rows_1.recordcount#</cfoutput>">
			<input type="hidden" name="rowCount_2" id="rowCount_2" value="<cfoutput>#get_rows_2.recordcount#</cfoutput>">
			<input type="hidden" name="credit_contract_id" id="credit_contract_id" value="<cfoutput>#url.credit_contract_id#</cfoutput>">
			<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
			<cf_basket_form id="credit_contract">
				<cf_box_elements>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-is_active">
							<label class="col col-4 col-xs-12"><input type="checkbox" name="is_active" id="is_active" onclick="secim1();" value="" <cfif get_credit_contract.is_active eq 1>checked</cfif>><cf_get_lang dictionary_id='57493.Aktif'></label>
							<label class="col col-4 col-xs-12"><input type="checkbox" name="is_scenario" id="is_scenario" value="" <cfif get_credit_contract.is_scenario eq 1>checked</cfif>><cf_get_lang dictionary_id='51342.Senaryoda Gözüksün'></label>				
						</div>
						<div class="form-group" id="item-survey_head">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.işlem tipi'></label>
							<div class="col col-8 col-xs-12">
								<cf_workcube_process_cat process_cat="#get_credit_contract.process_cat#" process_type_info="#get_credit_contract.process_type#" slct_width="150" onclick_function="gizle_finance()" form_name="upd_credit_contract">
							</div>
						</div>
						<div class="form-group" id="item-credit_date">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'> *</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfinput type="text" name="credit_date" id="credit_date" value="#dateformat(get_credit_contract.credit_date,dateformat_style)#" validate="#validate_style#" required="yes" message="#getLang('','Kredi Tarihini Kontrol Ediniz',51347)#" maxlength="10">
									<span class="input-group-addon"><cf_wrk_date_image date_field="credit_date"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-credit_no">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51338.Kredi No'> *</label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="credit_no" id="credit_no" value="<cfoutput>#get_credit_contract.credit_no#</cfoutput>">
							</div>
						</div>
						<div class="form-group" id="item-agreement_no">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30044.Sözleşme No'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="agreement_no" id="agreement_no" value="<cfoutput>#GET_CREDIT_CONTRACT.AGREEMENT_NO#</cfoutput>" maxlength="20">
							</div>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-credit_employee_id">
							<label class="col col-4"><cf_get_lang dictionary_id='57544.Sorumlu'></label>
							<div class="col col-8 col-xs-12"> 
								<div class="input-group">
									<input type="hidden" name="credit_emp_id" id="credit_emp_id" value="<cfif isdefined("url.credit_contract_id") and len(url.credit_contract_id)><cfoutput>#get_credit_contract.credit_emp_id#</cfoutput></cfif>">
									<input type="text" name="credit_emp_name" id="credit_emp_name" value="<cfif isdefined("url.credit_contract_id") and len(url.credit_contract_id)><cfoutput>#get_credit_contract.SORUMLU#</cfoutput></cfif>" onFocus="AutoComplete_Create('credit_emp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','credit_emp_id','','3','135');" autocomplete="off" required="yes" message="">                         
									<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=upd_credit_contract.credit_emp_id&field_name=upd_credit_contract.credit_emp_name&is_form_submitted=1&select_list=1');" title="<cf_get_lang dictionary_id='30829.Talep Eden'>"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-company_id">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59171.Kredi Kurumu'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("url.credit_contract_id") and len(url.credit_contract_id)><cfoutput>#get_credit_contract.company_id#</cfoutput></cfif>">
									<input type="hidden" name="partner_id" id="partner_id" value="">		
									<input type="text" name="company" id="company" onFocus="AutoComplete_Create('company','NICKNAME,MEMBER_CODE','NICKNAME,MEMBER_CODE','get_company','0','COMPANY_ID,NICKNAME','company_id,company','upd_credit_contract',1);" value="<cfif isdefined("url.credit_contract_id") and len(url.credit_contract_id)><cfoutput>#get_par_info(get_credit_contract.company_id,1,1,0)#</cfoutput></cfif>">	  
									<cfset str_linke_ait="&field_comp_id=upd_credit_contract.company_id&field_partner=upd_credit_contract.partner_id&field_comp_name=upd_credit_contract.company&select_list=2">
									<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars<cfoutput>#str_linke_ait#</cfoutput>');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-account_no">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58178.Hesap No'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="account_no" id="account_no" value="<cfoutput>#get_credit_contract.account_no#</cfoutput>" maxlength="50">
							</div>
						</div>
						<div class="form-group" id="item-reference">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58784.Referans'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="reference" id="reference" value="<cfoutput>#get_credit_contract.reference#</cfoutput>" maxlength="50">
							</div>
						</div>
						<div class="form-group" id="item-related_project_id">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="related_project_id" id="related_project_id" value="<cfoutput>#GET_CREDIT_CONTRACT.PROJECT_ID#</cfoutput>">
									<input  type="text" name="related_project_head" id="related_project_head" onFocus="AutoComplete_Create('related_project_head','PROJECT_HEAD,PROJECT_NUMBER','PROJECT_HEAD,PROJECT_NUMBER','get_project','0','PROJECT_ID,PROJECT_HEAD','related_project_id,related_project_head');" value="<cfif len(GET_CREDIT_CONTRACT.PROJECT_ID)><cfoutput>#GET_PROJECT_HEAD.PROJECT_HEAD#</cfoutput><cfelse>Projesiz</cfif>">
									<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=upd_credit_contract.related_project_head&project_id=upd_credit_contract.related_project_id</cfoutput>');"></span>
								</div>
							</div>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
						<div class="form-group" id="item-interest_rate">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="51354.Faiz Oranı"></label>
							<div class="col col-6 col-xs-12">
								<input type="text" name="interest_rate" id="interest_rate" value="<cfoutput>#TlFormat(get_credit_contract.interest_rate,session.ep.our_company_info.rate_round_num)#</cfoutput>" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));">
							</div>
							<div class="col col-2 col-xs-12">
								<select name="interest_period" id="interest_period">
									<option value="1"><cf_get_lang dictionary_id="29400.Yıllık"></option>
									<option value="2"><cf_get_lang dictionary_id="58932.Aylık"></option>
									<option value="3"><cf_get_lang dictionary_id="58457.Günlük"></option>
								</select>	
							</div>
						</div>
						<div class="form-group" id="item-credit_type">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51358.Kredi Türü'></label>
							<div class="col col-8 col-xs-12">
								<cf_wrk_combo
								name="credit_type"
								query_name="GET_CREDIT_TYPE"
								option_name="credit_type"
								option_value="credit_type_id"
								value="#get_credit_contract.credit_type#"
								width="130">                       
							</div>
						</div>
						<div class="form-group" id="item-credit_limit_id">
							<label class="col col-4 col-xs-12" id="credit_limit" style="display:none;"><cf_get_lang dictionary_id='58963.Kredi Limiti'></label>
							<div class="col col-8 col-xs-12" id="credit_limit_" style="display:none;">
								<select name="credit_limit_id" id="credit_limit_id">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_credit_limit">
										<option value="#credit_limit_id#" <cfif get_credit_contract.credit_limit_id eq credit_limit_id>selected</cfif>>#limit_head#</option>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-detail">
							<label class="col col-4 col-xs-12" rowspan="2" valign="top" width="60"><cf_get_lang dictionary_id='57629.Açıklama'></label>
							<div class="col col-8 col-xs-12" width="140" rowspan="2">
								<textarea name="detail" id="detail" style="width:140px;height:85px;"><cfoutput>#get_credit_contract.detail#</cfoutput></textarea>
							</div>
						</div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<div class="col col-6">
						<cf_record_info query_name='get_credit_contract'>
					</div>
					<div class="col col-6">
						<cfif get_rows_1.recordcount eq 0 and get_rows_2.recordcount eq 0 and get_credit_contract_income_control.recordcount eq 0>
							<cf_workcube_buttons 
								is_upd='1' 
								delete_page_url='#request.self#?fuseaction=credit.emptypopup_del_credit_contract&old_process_type=#get_credit_contract.process_type#&credit_contract_id=#attributes.credit_contract_id#' 
								add_function='kontrol()'>
						<cfelse>
							<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
						</cfif>
					</div>
				</cf_box_footer>
			</cf_basket_form>
			<div class="col col-12">
				<cf_basket id="credit_contract_bask" height="350">
					<!---Ödemeler--->
					<cf_seperator title="#getLang('main','Ödemeler',58658)#" id="paymentsArea">
					<div id="paymentsArea" style="display:none;">
						<div id="kredi_sepet">	
							<cf_grid_list>
								<thead>
									<tr>
										<th width="20"><cf_get_lang dictionary_id='57487.No'></th>
										<th width="20" class="text-center">
											<input type="hidden" name="payment_record_num" id="payment_record_num" value="0">
											<input type="hidden" name="payment_record_num2" id="payment_record_num2" value="0">
											<a onclick="add_row(1);"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57707.Satır Ekle'>" alt="<cf_get_lang dictionary_id='57707.Satır Ekle'>"></i></a>
										</th>
										<th><cf_get_lang dictionary_id='57742.Tarih'>* </th>
										<th class="text-right"><cf_get_lang dictionary_id='51344.Ana Para'> *</th>
										<th class="text-right"><cf_get_lang dictionary_id='51367.Faiz'></th>
										<th id="finance7" <cfif get_credit_contract.process_type neq 296>style="display:none;"</cfif>><cf_get_lang dictionary_id ='51397.KDV siz Kira'></th>
										<th class="text-right"><cf_get_lang dictionary_id='51346.Vergi/Masraf'></th>
										<th id="finance8" <cfif get_credit_contract.process_type neq 296>style="display:none;"</cfif>><cf_get_lang dictionary_id ='51398.KDV li Kira'></th>
										<cfif get_credit_contract.process_type neq 296>
											<th id="credit5" class="text-right"><cf_get_lang dictionary_id='57492.Toplam'></th>
										</cfif>
										<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
										<th><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th>
										<cfif get_credit_contract.process_type neq 296><!--- kredi sozlesmesi --->
											<th><cf_get_lang dictionary_id="51355.Ana Para Gider Kalemi"></th>
											<th><cf_get_lang dictionary_id="51356.Ana Para Muhasebe Kodu"></th>
										</cfif>
										<th><cf_get_lang dictionary_id ='51399.Faiz Gider Kalemi'> *</th>
										<th><cf_get_lang dictionary_id ='51400.Faiz Muhasebe Kodu'></th>
										<th><cfif get_credit_contract.process_type eq 296><cf_get_lang dictionary_id='57323.Finansal Kiralama Gider Kalemi'>*<cfelse><cf_get_lang dictionary_id="51357.Vergi-Masraf Gider Kalemi"></cfif></th>
										<cfif get_credit_contract.process_type neq 296>
											<th><cf_get_lang dictionary_id="51359.Vergi-Masraf Muhasebe Kodu"></th>
										</cfif>			
										<cfif get_credit_contract.process_type eq 296>
											<th id="baslik5"><cf_get_lang dictionary_id ='51396.Finansal Kiralama Muhasebe Kodu'>*</th>
											<th id="baslik6"><cf_get_lang dictionary_id='30135.Leasing Borçlanma Maliyet Kodu'> *</th>
										</cfif>
										<cfif get_credit_contract.process_type eq 296><!--- finansal kiralama sozlesmesi ise --->
											<th class="boxtext" id="credittable"></th>
										</cfif>
									</tr>
								</thead>
								<tbody id="table1">
									<cfif isdefined("url.credit_contract_id") and len(url.credit_contract_id)>
										<cfoutput query="get_rows_1">
											<tr id="payment_frm_row#currentrow#">
												<td class="text-center">#currentrow# </td>
												<td nowrap="nowrap">
													<input type="hidden" name="payment_row_kontrol#currentrow#" id="payment_row_kontrol#currentrow#" value="1">
													<ul class="ui-icon-list">
														<li>
															<a onclick="delete_row('#currentrow#',1);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>
														</li>
														<li>
															<a onclick="open_row_add(1,'#currentrow#');"><i class="icon-branch" title="<cf_get_lang dictionary_id='62455.Satır Çoğalt'>" alt="<cf_get_lang dictionary_id='62455.Satır Çoğalt'>"></i></a>
														</li>
														<li>
															<a onclick="copy_row(1,'#currentrow#');"><i class="fa fa-copy" title="<cf_get_lang dictionary_id='58972.Satır Kopyala'>" alt="<cf_get_lang dictionary_id='58972.Satır Kopyala'>"></i></a>
														</li>
													</ul>	
												</td>
												<td nowrap="nowrap">
													<input type="hidden" name="payment_credit_contract_row_id#currentrow#" id="payment_credit_contract_row_id#currentrow#" value="#credit_contract_row_id#">
													<input type="text" name="payment_date#currentrow#" id="payment_date#currentrow#" value="#dateformat(process_date,dateformat_style)#" style="width:70px;">
													<cf_wrk_date_image date_field="payment_date#currentrow#">
												</td>
												<td><div class="form-group"><input type="text" name="payment_capital_price#currentrow#" onchange="payment_capital_price_amount(#currentrow#);" maxlength="20" id="payment_capital_price#currentrow#" value="#TlFormat(capital_price,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(1);" class="moneybox"></div></td>
												<td><div class="form-group"><input type="text" name="payment_interest_price#currentrow#" onchange="payment_interest_price_amount(#currentrow#);" id="payment_interest_price#currentrow#" value="#TlFormat(interest_price,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(1);" class="moneybox"></div></td>
												<td <cfif get_credit_contract.process_type neq 296>style="display:none;"</cfif>><div class="form-group"><input type="text" name="total_payment_price#currentrow#" id="total_payment_price#currentrow#" value="#TlFormat(interest_price+capital_price,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(1);" class="moneybox"></div></td>
												<td><div class="form-group"><input type="text" name="payment_tax_price#currentrow#" id="payment_tax_price#currentrow#" onchange="payment_tax_price_amount(#currentrow#);" value="#TlFormat(tax_price,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(1);" class="moneybox"></div></td>
												<td><div class="form-group"><input type="text" name="payment_total_price#currentrow#" id="payment_total_price#currentrow#" value="#TlFormat(total_price,session.ep.our_company_info.rate_round_num)#" readonly class="moneybox"></div></td>
												<td><div class="form-group large"><input type="text" name="payment_detail#currentrow#" id="payment_detail#currentrow#" value="#detail#" maxlength="100"></div></td>
												<td nowrap="nowrap">
													<div class="form-group large">
														<select name="expense_center_id#currentrow#" id="expense_center_id#currentrow#" class="text">
															<cfset deger_expense= expense_center_id>
															<option value="">M. Merkezi</option>
															<cfloop query="get_expense_center">
																<option value="#expense_id#" <cfif deger_expense eq get_expense_center.expense_id>selected</cfif>>#expense#</option>
															</cfloop>
														</select>
													</div>
												</td>
												<cfif get_credit_contract.process_type neq 296><!--- kredi sozlesmesi --->
													<td nowrap="nowrap">
														<div class="form-group large">
															<div class="input-group">
																<input type="hidden" name="capital_expense_item_id#currentrow#" id="capital_expense_item_id#currentrow#" value="#capital_expense_item_id#">
																<input type="text" name="capital_expense_item_name#currentrow#" id="capital_expense_item_name#currentrow#"  value="<cfif len(capital_expense_item_id) and len(item_id_list)>#get_exp_detail.expense_item_name[listfind(item_id_list,capital_expense_item_id,',')]#</cfif>" class="text">
																<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac_items('capital_expense_item_id','capital_expense_item_name','capital_account_id','capital_account_code','#currentrow#');"></span>
															</div>
														</div>
													</td>
													<td nowrap="nowrap">
														<div class="form-group large">
															<div class="input-group">
																<input type="hidden" name="capital_account_id#currentrow#" id="capital_account_id#currentrow#" value="<cfif len(capital_account_id)>#capital_account_id#</cfif>">
																<input type="text" name="capital_account_code#currentrow#" id="capital_account_code#currentrow#" class="text" value="<cfif len(capital_account_id)>#capital_account_id#</cfif>">
																<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac_acc('capital_account_id','capital_account_code','#currentrow#');"></span>
															</div>
														</div>
													</td>
												</cfif>
												<td nowrap="nowrap">
													<div class="form-group large">
														<div class="input-group">
															<input type="hidden" name="expense_item_id#currentrow#" id="expense_item_id#currentrow#" value="#expense_item_id#">
															<input type="text" name="expense_item_name#currentrow#" id="expense_item_name#currentrow#"  value="<cfif len(expense_item_id) and len(item_id_list)>#get_exp_detail.expense_item_name[listfind(item_id_list,expense_item_id,',')]#</cfif>" onFocus="AutoComplete_Create('expense_item_name#currentrow#','EXPENSE_ITEM_NAME,ACCOUNT_CODE','EXPENSE_ITEM_NAME,ACCOUNT_CODE','GET_EXPENSE_ITEM','0','EXPENSE_ITEM_ID,EXPENSE_ITEM_NAME,ACCOUNT_CODE,ACCOUNT_CODE','expense_item_id#currentrow#,expense_item_name#currentrow#,interest_account_code#currentrow#,interest_account_id#currentrow#','add_credit_contract',1);" class="text">
															<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac_items('expense_item_id','expense_item_name','interest_account_id','interest_account_code','#currentrow#');"></span>
														</div>
													</div>
												</td>
												<td nowrap="nowrap">
													<div class="form-group large">
														<div class="input-group">
															<input type="hidden" name="interest_account_id#currentrow#" id="interest_account_id#currentrow#" value="<cfif len(interest_account_id)>#interest_account_id#</cfif>">
															<input type="text" name="interest_account_code#currentrow#" id="interest_account_code#currentrow#" class="text" value="<cfif len(interest_account_id)>#interest_account_id#</cfif>">
															<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac_acc('interest_account_id','interest_account_code','#currentrow#');"></span>
														</div>
													</div>
												</td>
												<td nowrap="nowrap">
													<div class="form-group large">
														<div class="input-group">
															<input type="hidden" name="total_expense_item_id#currentrow#" id="total_expense_item_id#currentrow#" value="#total_expense_item_id#">
															<input type="text" name="total_expense_item_name#currentrow#" id="total_expense_item_name#currentrow#" value="<cfif len(total_expense_item_id) and len(item_id_list)>#get_exp_detail.expense_item_name[listfind(item_id_list,total_expense_item_id,',')]#</cfif>" onFocus="AutoComplete_Create('total_expense_item_name#currentrow#','EXPENSE_ITEM_NAME,ACCOUNT_CODE','EXPENSE_ITEM_NAME,ACCOUNT_CODE','GET_EXPENSE_ITEM','0','EXPENSE_ITEM_ID,EXPENSE_ITEM_NAME,ACCOUNT_CODE,ACCOUNT_CODE','total_expense_item_id#currentrow#,total_expense_item_name#currentrow#,total_account_code#currentrow#,total_account_id#currentrow#','add_credit_contract',1);" class="text">
															<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac_items('total_expense_item_id','total_expense_item_name','total_account_id','total_account_code','#currentrow#');"></span>
														</div>
													</div>
												</td>
												<td>
													<div class="form-group large">
														<div class="input-group">
															<input type="hidden" name="total_account_id#currentrow#" id="total_account_id#currentrow#" value="<cfif len(total_account_id)>#total_account_id#</cfif>">
															<input type="text" name="total_account_code#currentrow#" id="total_account_code#currentrow#" class="text" value="<cfif len(total_account_id)>#total_account_id#</cfif>">
															<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac_acc('total_account_id','total_account_code','#currentrow#');"></span>
														</div>
													</div>
												</td>
												<cfif get_credit_contract.process_type eq 296>
													<td>
														<div class="form-group large">
															<div class="input-group">
																<input type="hidden" name="borrow_id#currentrow#" id="borrow_id#currentrow#" value="<cfif len(borrow)>#borrow#</cfif>">
																<input type="text" name="borrow_code#currentrow#" id="borrow_code#currentrow#" class="text" value="<cfif len(borrow)>#borrow#</cfif>" onFocus="AutoComplete_Create('borrow_code#currentrow#','ACCOUNT_CODE,ACCOUNT_NAME','CODE_NAME','get_account_code','0','ACCOUNT_CODE,CODE_NAME','borrow_id#currentrow#,borrow_code#currentrow#','upd_credit_contract',1);">
																<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac_acc('borrow_id','borrow_code','#currentrow#');"></span>
															</div>
														</div>
													</td>
												</cfif>
											</tr>
										</cfoutput>
									</cfif>
								</tbody>
								<tfoot id="table2">
									<tr>
										<td colspan="3" style="text-align:right;" class="txtbold"><cf_get_lang dictionary_id='57492.Toplam'></td>
										<td><input name="payment_total_capital_price" id="payment_total_capital_price" value="" class="box" readonly></td>
										<td><input name="payment_total_interest_price" id="payment_total_interest_price" value="" class="box" readonly></td>
										<td id="finance9"><input name="payment_total_price_kdvsiz" id="payment_total_price_kdvsiz" value="" class="box" readonly></td>
										<td><input name="payment_total_tax_price" id="payment_total_tax_price" value="" class="box" readonly></td>
										<td><input name="payment_total_price" id="payment_total_price" value="" class="box" readonly></td>
										<cfif get_credit_contract.process_type eq 296><td colspan="6"></td><cfelse><td colspan="8"></td></cfif>
									</tr>	  
								</tfoot>
							</cf_grid_list>
						</div>
					</div>   
					<!---Tahsilatlar--->
					<cf_seperator title="#getLang('credit','Tahsilatlar',51361)#" id="collectionsArea">
					<div id="collectionsArea" style="display:none">
						<cf_grid_list>
							<thead>
								<tr>
									<th width="20"><cf_get_lang dictionary_id='57487.No'></th>
									<th width="20" class="text-center">
										<input type="hidden" name="revenue_record_num" id="revenue_record_num" value="0">
										<a onclick="add_row(2);"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57707.Satır Ekle'>" alt="<cf_get_lang dictionary_id='57707.Satır Ekle'>"></i></a>
									</th>
									<th><cf_get_lang dictionary_id='57742.Tarih'> *</th>
									<th class="text-right"><cf_get_lang dictionary_id='51344.Ana Para'> </th>
									<th class="text-right"><cf_get_lang dictionary_id='51367.Faiz'></th>
									<th class="text-right"><cf_get_lang dictionary_id='51346.Vergi/Masraf'></th>
									<th class="text-right"><cf_get_lang dictionary_id='57492.Toplam'></th>
									<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
									<cfif get_credit_contract.process_type neq 296><!--- kredi sozlesmesi --->
										<th><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th>
										<th><cf_get_lang dictionary_id="51355.Ana Para Gider Kalemi"></th>
										<th><cf_get_lang dictionary_id="51356.Ana Para Muhasebe Kodu"></th>
										<th><cf_get_lang dictionary_id='51399.Faiz Gider Kalemi'> </th>
										<th><cf_get_lang dictionary_id='51400.Faiz Muhasebe Kodu'></th>
										<th><cf_get_lang dictionary_id="51357.Vergi-Masraf Gider Kalemi"></th>			
										<th><cf_get_lang dictionary_id="51359.Vergi-Masraf Muhasebe Kodu"></th>	
									</cfif>
								</tr>
							</thead>
							<tbody id="table3">
								<cfoutput query="get_rows_2">
									<tr id="revenue_frm_row#currentrow#">
									<td class="text-center">#currentrow#</td>
										<td nowrap="nowrap" class="text-right">
											<input type="hidden" name="revenue_row_kontrol#currentrow#" id="revenue_row_kontrol#currentrow#" value="1">
											<ul class="ui-icon-list">
												<li>
													<a onclick="delete_row('#currentrow#',2);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>
												</li>
												<li>
													<a onclick="open_row_add(2,'#currentrow#');"><i class="icon-branch" title="<cf_get_lang dictionary_id='62455.Satır Çoğalt'>" alt="<cf_get_lang dictionary_id='62455.Satır Çoğalt'>"></i></a>
												</li>
												<li>
													<a onclick="copy_row(2,'#currentrow#');"><i class="fa fa-copy" title="<cf_get_lang dictionary_id='58972.Satır Kopyala'>" alt="<cf_get_lang dictionary_id='58972.Satır Kopyala'>"></i></a>
												</li>
											</ul>
										</td>
										<td nowrap="nowrap">
											<input type="hidden" name="revenue_credit_contract_row_id#currentrow#" id="revenue_credit_contract_row_id#currentrow#" value="#credit_contract_row_id#">
											<input type="text" name="revenue_date#currentrow#" id="revenue_date#currentrow#" value="#dateformat(process_date,dateformat_style)#" style="width:70px;">
											<cf_wrk_date_image date_field="revenue_date#currentrow#">
										</td>
										<td class="text-right"><div class="form-group"><input type="text" name="revenue_capital_price#currentrow#" id="revenue_capital_price#currentrow#" maxlength="20" value="#TlFormat(capital_price,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(2);" class="moneybox"></div></td>
										<td class="text-right"><div class="form-group"><input type="text" name="revenue_interest_price#currentrow#" id="revenue_interest_price#currentrow#" value="#TlFormat(interest_price,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(2);" class="moneybox"></div></td>
										<td class="text-right"><div class="form-group"><input type="text" name="revenue_tax_price#currentrow#" id="revenue_tax_price#currentrow#" value="#TlFormat(tax_price,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(2);" class="moneybox"></div></td>
										<td class="text-right"><div class="form-group"><input type="text" name="revenue_total_price#currentrow#" id="revenue_total_price#currentrow#" value="#TlFormat(total_price,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event));" class="moneybox" readonly></div></td>
										<td class="text-right"><div class="form-group large"><input type="text" name="revenue_detail#currentrow#" id="revenue_detail#currentrow#" value="#detail#" maxlength="100"></div></td>
										<cfif get_credit_contract.process_type neq 296><!--- kredi sozlesmesi --->
											<td nowrap="nowrap">
												<div class="form-group large">
													<select name="revenue_expense_center_id#currentrow#" id="revenue_expense_center_id#currentrow#" class="text">
														<cfset deger_expense= expense_center_id>
														<option value=""><cf_get_lang dictionary_id="57331.M. Merkezi"></option>
														<cfloop query="get_expense_center">
															<option value="#expense_id#" <cfif deger_expense eq get_expense_center.expense_id>selected</cfif>>#expense#</option>
														</cfloop>
													</select>
												</div>
											</td>
											<td nowrap="nowrap">
												<div class="form-group large">
													<div class="input-group">
														<input type="hidden" name="revenue_capital_expense_item_id#currentrow#" id="revenue_capital_expense_item_id#currentrow#" value="#capital_expense_item_id#">
														<input type="text" name="revenue_capital_expense_item_name#currentrow#" id="revenue_capital_expense_item_name#currentrow#"  value="<cfif len(capital_expense_item_id) and len(revenue_item_id_list)>#get_exp_detail_2.expense_item_name[listfind(revenue_item_id_list,capital_expense_item_id,',')]#</cfif>" class="text">
														<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac_items('revenue_capital_expense_item_id','revenue_capital_expense_item_name','revenue_capital_account_id','revenue_capital_account_code','#currentrow#');"></span>
													</div>
												</div>
											</td>
											<td nowrap="nowrap">
												<div class="form-group large">
													<div class="input-group">
														<input type="hidden" name="revenue_capital_account_id#currentrow#" id="revenue_capital_account_id#currentrow#" value="<cfif len(capital_account_id)>#capital_account_id#</cfif>">
														<input type="text" name="revenue_capital_account_code#currentrow#" id="revenue_capital_account_code#currentrow#" class="text" value="<cfif len(capital_account_id)>#capital_account_id#</cfif>">
														<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac_acc('revenue_capital_account_id','revenue_capital_account_code','#currentrow#');"></span>
													</div>
												</div>
											</td>
											<td nowrap="nowrap">
												<div class="form-group">
													<div class="input-group">
														<input type="hidden" name="revenue_expense_item_id#currentrow#" id="revenue_expense_item_id#currentrow#" value="#expense_item_id#">
														<input type="text" name="revenue_expense_item_name#currentrow#" id="revenue_expense_item_name#currentrow#"  value="<cfif len(expense_item_id) and len(revenue_item_id_list)>#get_exp_detail_2.expense_item_name[listfind(revenue_item_id_list,expense_item_id,',')]#</cfif>" class="text">
														<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac_items('revenue_expense_item_id','revenue_expense_item_name','revenue_interest_account_id','revenue_interest_account_code','#currentrow#');"></span>
													</div>
												</div>
											</td>
											<td nowrap="nowrap">
												<div class="form-group">
													<div class="input-group">
														<input type="hidden" name="revenue_interest_account_id#currentrow#" id="revenue_interest_account_id#currentrow#" value="<cfif len(interest_account_id)>#interest_account_id#</cfif>">
														<input type="text" name="revenue_interest_account_code#currentrow#" id="revenue_interest_account_code#currentrow#" class="text" value="<cfif len(interest_account_id)>#interest_account_id#</cfif>">
														<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac_acc('revenue_interest_account_id','revenue_interest_account_code','#currentrow#');"></span>
													</div>
												</div>
											</td>
											<td nowrap="nowrap">
												<div class="form-group">
													<div class="input-group">
														<input type="hidden" name="revenue_total_expense_item_id#currentrow#" id="revenue_total_expense_item_id#currentrow#" value="#total_expense_item_id#">
														<input type="text" name="revenue_total_expense_item_name#currentrow#" id="revenue_total_expense_item_name#currentrow#" value="<cfif len(total_expense_item_id) and len(revenue_item_id_list)>#get_exp_detail_2.expense_item_name[listfind(revenue_item_id_list,total_expense_item_id,',')]#</cfif>" class="text">
														<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac_items('revenue_total_expense_item_id','revenue_total_expense_item_name','revenue_total_account_id','revenue_total_account_code','#currentrow#');"></span>
													</div>
												</div>
											</td>
											<td nowrap="nowrap">
												<div class="form-group">
													<div class="input-group">
														<input type="hidden" name="revenue_total_account_id#currentrow#" id="revenue_total_account_id#currentrow#" value="<cfif len(total_account_id)>#total_account_id#</cfif>">
														<input type="text" name="revenue_total_account_code#currentrow#" id="revenue_total_account_code#currentrow#" class="text" value="<cfif len(total_account_id)>#total_account_id#</cfif>">
														<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac_acc('revenue_total_account_id','revenue_total_account_code','#currentrow#');"></span>
													</div>
												</div>
											</td>
										</cfif>
									</tr>
								</cfoutput>
							</tbody>
							<tfoot id="table4">
								<tr>
									<td></td>
									<td colspan="2" style="text-align:right;" class="txtbold"><cf_get_lang dictionary_id='57492.Toplam'></td>
									<td class="text-right"><input name="revenue_total_capital_price" id="revenue_total_capital_price" value="" class="box" readonly></td>
									<td class="text-right"><input name="revenue_total_interest_price" id="revenue_total_interest_price" value="" class="box" readonly></td>
									<td class="text-right"><input name="revenue_total_tax_price" id="revenue_total_tax_price" value="" class="box" readonly></td>
									<td class="text-right"><input name="revenue_total_price" id="revenue_total_price" value="" class="box" readonly></td>
									<cfif get_credit_contract.process_type neq 296><td colspan="8">&nbsp;</td><cfelse><td>&nbsp;</td></cfif>
								</tr>	  
							</tfoot>		
						</cf_grid_list>
					</div>
					<cf_basket_footer height="95">
						<div class="ui-row">
							<div id="sepetim_total" class="padding-10">
								<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
									<div class="totalBox">
										<div class="totalBoxHead font-grey-mint">
											<span class="headText"><cf_get_lang dictionary_id='57677.Döviz'></span>
											<div class="collapse">
												<span class="icon-minus"></span>
											</div>
										</div>
										<div class="totalBoxBody"> 
											<table>
												<input type="hidden" name="deger_get_money" id="deger_get_money" value="<cfoutput>#get_money.recordcount#</cfoutput>">
												<cfif session.ep.rate_valid eq 1>
													<cfset readonly_info = "yes">
												<cfelse>
													<cfset readonly_info = "no">
												</cfif>
												<cfif get_credit_contract_payment_income.recordcount>
													<cfset readonly_ = "yes">
												<cfelse>
													<cfset readonly_ = "no">
												</cfif>
												<cfoutput>
													<cfloop query="get_money">
														<tr>
															<td>
																<div class="form-group">
																	<input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
																	<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
																	<input type="radio" name="rd_money" id="rd_money" value="#money#,#currentrow#,#rate1#,#rate2#" onclick="f_kur_hesapla_multi();" <cfif get_credit_contract.money_type eq money>checked</cfif>>#money#
																</div>
															</td>
															<td>
																<div class="form-group">
																	#TLFormat(rate1,0)#/
																</div>
															</td>
															<td>
																<div class="form-group">
																	<input type="text" <cfif readonly_>readonly</cfif> <cfif readonly_info>readonly</cfif> class="box" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" <cfif money eq session.ep.money>readonly="yes"</cfif>value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onblur="f_kur_hesapla_multi();">
																</div>
															</td>
														</tr>
													</cfloop>
												</cfoutput>
											</table>
										</div>
									</div>
								</div>
								<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
									<div class="totalBox">
										<div class="totalBoxHead font-grey-mint">
											<span class="headText"><cf_get_lang dictionary_id='57492.Toplam'></span>
											<div class="collapse">
												<span class="icon-minus"></span>
											</div>
										</div>
										<div class="totalBoxBody"> 
											<table>
												<tr>
													<td class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='51363.Tahsilat Toplam'></td>
													<td class="text-right"><div class="form-group"><input type="text" name="total_revenue" id="total_revenue" class="box" readonly="" value="<cfoutput>#TlFormat(get_credit_contract.total_revenue,session.ep.our_company_info.rate_round_num)#</cfoutput>"></div></td>
													<td width="55"><div class="form-group"><input type="text" name="money_info_rev" id="money_info_rev" value="<cfoutput>#get_credit_contract.money_type#</cfoutput>" class="moneybox" readonly=""></div></td>
												</tr>
												<tr>
													<td class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='51364.Ödeme Toplam'></td>
													<td class="text-right"><div class="form-group"><input type="text" name="total_payment" id="total_payment" class="box" readonly="" value="<cfoutput>#TlFormat(get_credit_contract.total_payment,session.ep.our_company_info.rate_round_num)#</cfoutput>"></div></td>
													<td width="55"><div class="form-group"><input type="text" name="money_info_pay" id="money_info_pay" value="<cfoutput>#get_credit_contract.money_type#</cfoutput>" class="moneybox" readonly=""></div></td>
												</tr>
												<tr>
													<td class="txtbold" style="text-align:right;"><cfoutput>#session.ep.money#</cfoutput> <cf_get_lang dictionary_id='51363.Tahsilat Toplam'></td>
													<td id="rate_value1" class="text-right"><div class="form-group"><input type="text" name="other_total_revenue" id="other_total_revenue" class="box" readonly="" value="<cfoutput>#TlFormat(get_credit_contract.other_total_revenue,session.ep.our_company_info.rate_round_num)#</cfoutput>"></div></td>
												</tr>
												<tr>
													<td class="txtbold" style="text-align:right;"><cfoutput>#session.ep.money#</cfoutput> <cf_get_lang dictionary_id='51364.Ödeme Toplam'></td>
													<td id="rate_value2" class="text-right"><div class="form-group"><input type="text" name="other_total_payment" id="other_total_payment" class="box" readonly="" value="<cfoutput>#TlFormat(get_credit_contract.other_total_payment,session.ep.our_company_info.rate_round_num)#</cfoutput>"></div></td>
												</tr>
											</table>
										</div>
									</div>
								</div>
							</div>
						</div>
					</cf_basket_footer>
				</cf_basket>        
			</div>
		</cfform>
		<div id="add_multi_row" style="position:absolute; margin-top:-400px; margin-left:50px; z-index:99;"></div>
	</cf_box>
</div>
<script type="text/javascript">
	payment_row_count=<cfoutput>#get_rows_1.recordcount#</cfoutput>;
	revenue_row_count=<cfoutput>#get_rows_2.recordcount#</cfoutput>;
	payment_kontrol_row_count=<cfoutput>#get_rows_1.recordcount#</cfoutput>;
	revenue_kontrol_row_count=<cfoutput>#get_rows_2.recordcount#</cfoutput>;
	document.getElementById('payment_record_num').value=payment_row_count;
	document.getElementById('payment_record_num2').value=payment_row_count;
	document.getElementById('revenue_record_num').value=revenue_row_count;
	write_total_amount(1);
	write_total_amount(2);
		function add_row(type,payment_date,payment_capital_price,payment_interest_price,payment_tax_price,payment_total_price,payment_detail,total_payment_price,expense_center_id,expense_item_id,expense_item_name,interest_account_id,interest_account_code,total_expense_item_id,total_expense_item_name,capital_expense_item_id,capital_expense_item_name,capital_account_id,capital_account_code,total_account_id,total_account_code,borrow_id,borrow_code)
	{
		
		//Normal satır eklerken değişkenler olmadığı için boşluk atıyor,kopyalarken değişkenler geliyor
		if (payment_date == undefined)payment_date ="";
		if (payment_capital_price == undefined)payment_capital_price =0;
		if (payment_interest_price == undefined)payment_interest_price =0;
		if (payment_tax_price == undefined)payment_tax_price =0;
		if (payment_total_price == undefined)payment_total_price =0;
		if (payment_detail == undefined)payment_detail ="";
		if (total_payment_price == undefined)total_payment_price =0;
		if (expense_center_id == undefined)expense_center_id ="";
		if (expense_item_id == undefined)expense_item_id ="";
		if (expense_item_name == undefined)expense_item_name ="";
		if (interest_account_id == undefined)interest_account_id ="";
		if (interest_account_code == undefined)interest_account_code ="";
		if (total_expense_item_id == undefined)total_expense_item_id ="";
		if (total_expense_item_name == undefined)total_expense_item_name ="";
		if (capital_expense_item_id == undefined)capital_expense_item_id ="";
		if (capital_expense_item_name == undefined)capital_expense_item_name ="";
		if (capital_account_id == undefined)capital_account_id ="";
		if (capital_account_code == undefined)capital_account_code ="";
		if (total_account_id == undefined)total_account_id ="";
		if (total_account_code == undefined)total_account_code ="";
		if (borrow_id == undefined)borrow_id ="";
		if (borrow_code == undefined)borrow_code ="";
		
		var selected_ptype = document.getElementById('process_cat').options[document.getElementById('process_cat').selectedIndex].value;
		eval('var proc_control = document.upd_credit_contract.ct_process_type_'+selected_ptype+'.value');
		/* odeme */
		if(type == 1)
		{
			if(selected_ptype != '')
			{
				h_ = parseInt(document.getElementById('kredi_sepet').style.height);
				document.getElementById('kredi_sepet').style.height = h_ + 25;
				table2.style.display = '';
				payment_row_count++;	
				payment_kontrol_row_count++;
				var newRow;
				var newCell;
				newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);	
				newRow.setAttribute("name","payment_frm_row" + payment_row_count);
				newRow.setAttribute("id","payment_frm_row" + payment_row_count);		
				newRow.setAttribute("NAME","payment_frm_row" + payment_row_count);
				newRow.setAttribute("ID","payment_frm_row" + payment_row_count);		
				document.getElementById('payment_record_num').value=payment_row_count;
				document.getElementById('payment_record_num2').value=payment_row_count;
				document.getElementById('rowCount').value = parseInt(document.getElementById('rowCount').value) + 1;
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				newCell.setAttribute("style","text-align:center");
				newCell.innerHTML =document.getElementById('rowCount').value;

				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("nowrap","nowrap");
				newCell.innerHTML =  ' <input  type="hidden" name="payment_row_kontrol' + payment_row_count +'" id="payment_row_kontrol' + payment_row_count +'" value="1"><ul class="ui-icon-list"><li><a onclick="delete_row(' + payment_row_count + ',1);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></li><li><a onclick="open_row_add(1,' + payment_row_count + ');"><i class="icon-branch" title="<cf_get_lang dictionary_id='62455.Satır Çoğalt'>" alt="<cf_get_lang dictionary_id='62455.Satır Çoğalt'>"></i></a></li><li><a onclick="copy_row(1,' + payment_row_count + ');"><i class="fa fa-copy" title="<cf_get_lang dictionary_id='58972.Satır Kopyala'>" alt="<cf_get_lang dictionary_id='58972.Satır Kopyala'>"></i></a></li></ul>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("id","payment_date" + payment_row_count + "_td");
				newCell.innerHTML = '<input type="hidden" name="payment_credit_contract_row_id' + payment_row_count +'" id="payment_credit_contract_row_id' + payment_row_count +'" value=""><input type="text" name="payment_date' + payment_row_count +'" id="payment_date' + payment_row_count +'" class="text" style="width:70px;" maxlength="10" value="' + payment_date + '"> ';
				wrk_date_image('payment_date' + payment_row_count);
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="payment_capital_price' + payment_row_count +'" id="payment_capital_price' + payment_row_count +'" maxlength="20" onchange="payment_capital_price_amount('+payment_row_count+');" value="'+payment_capital_price+'" value="" onKeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(1);" class="moneybox"></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="payment_interest_price' + payment_row_count +'" id="payment_interest_price' + payment_row_count +'" value="'+payment_interest_price+'" onchange="payment_interest_price_amount('+payment_row_count+');" onKeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(1);" class="moneybox"></div>';
				if(proc_control == 296)
				{
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<div class="form-group"><input type="text" name="total_payment_price' + payment_row_count +'" id="total_payment_price' + payment_row_count +'" value="'+total_payment_price+'" readonly class="moneybox"></div>';
				}
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="payment_tax_price' + payment_row_count +'" id="payment_tax_price' + payment_row_count +'" onchange="payment_tax_price_amount('+payment_row_count+');" value="'+payment_tax_price+'" onKeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(1);" class="moneybox"></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="payment_total_price' + payment_row_count +'" id="payment_total_price' + payment_row_count +'" value="'+payment_total_price+'" class="moneybox" readonly></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group large"><input type="text" name="payment_detail' + payment_row_count +'" id="payment_detail' + payment_row_count +'" value="'+payment_detail+'" maxlength="100"></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				a = '<div class="form-group large"><select name="expense_center_id' + payment_row_count  +'" id="expense_center_id' + payment_row_count  +'" class="text"><option value="">M. Merkezi</option>';
				<cfoutput query="get_expense_center">
				if('#expense_id#' == expense_center_id)
					a += '<option value="#expense_id#" selected>#expense#</option>';
				else
					a += '<option value="#expense_id#">#expense#</option>';
				</cfoutput>
				newCell.innerHTML =a+ '</select></div>';
				if(proc_control != 296)
				{
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<input  type="hidden" name="capital_expense_item_id' + payment_row_count +'" id="capital_expense_item_id' + payment_row_count +'" value="'+capital_expense_item_id+'"><div class="form-group large"><div class="input-group"><input type="text" name="capital_expense_item_name' + payment_row_count +'" id="capital_expense_item_name' + payment_row_count +'" readonly="yes" value="'+capital_expense_item_name+'" class="text"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_items(\'capital_expense_item_id\',\'capital_expense_item_name\',\'capital_account_id\',\'capital_account_code\',\''+payment_row_count+'\')"></span></div></div>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<input  type="hidden" name="capital_account_id' + payment_row_count +'" id="capital_account_id' + payment_row_count +'" value="'+capital_account_id+'"><div class="form-group large"><div class="input-group"><input type="text" value="'+capital_account_code+'" name="capital_account_code' + payment_row_count +'" id="capital_account_code' + payment_row_count +'" class="text"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_acc(\'capital_account_id\',\'capital_account_code\',\''+payment_row_count+'\')"></span></div></div>';
				}
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				newCell.innerHTML = '<input  type="hidden" name="expense_item_id' + payment_row_count +'" id="expense_item_id' + payment_row_count +'" value="'+expense_item_id+'"><div class="form-group large"><div class="input-group"><input type="text" onFocus="AutoComplete_Create(\'expense_item_name' + payment_row_count +'\',\'EXPENSE_ITEM_NAME,ACCOUNT_CODE\',\'EXPENSE_ITEM_NAME,ACCOUNT_CODE\',\'GET_EXPENSE_ITEM\',\'0\',\'EXPENSE_ITEM_ID,EXPENSE_ITEM_NAME,ACCOUNT_CODE,ACCOUNT_CODE\',\'expense_item_id' + payment_row_count +','+'expense_item_name'+payment_row_count+','+'interest_account_code'+payment_row_count+','+'interest_account_id'+payment_row_count+'\',\'add_credit_contract\',1);" value="'+expense_item_name+'" name="expense_item_name' + payment_row_count +'" id="expense_item_name' + payment_row_count +'" class="text"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_items(\'expense_item_id\',\'expense_item_name\',\'interest_account_id\',\'interest_account_code\',\''+payment_row_count+'\')" id="expense_item_name2' + payment_row_count +'"></span></div></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				newCell.innerHTML = '<input  type="hidden" name="interest_account_id' + payment_row_count +'" id="interest_account_id' + payment_row_count +'" value="'+interest_account_id+'"><div class="form-group large"><div class="input-group"><input type="text" value="'+interest_account_code+'"  name="interest_account_code' + payment_row_count +'"  id="interest_account_code' + payment_row_count +'" class="text"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_acc(\'interest_account_id\',\'interest_account_code\',\''+payment_row_count+'\')"></span></div></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				newCell.innerHTML = '<input  type="hidden" name="total_expense_item_id' + payment_row_count +'" id="total_expense_item_id' + payment_row_count +'" value="'+total_expense_item_id+'"><div class="form-group large"><div class="input-group"><input type="text" name="total_expense_item_name' + payment_row_count +'" onFocus="AutoComplete_Create(\'total_expense_item_name' + payment_row_count +'\',\'EXPENSE_ITEM_NAME,ACCOUNT_CODE\',\'EXPENSE_ITEM_NAME,ACCOUNT_CODE\',\'GET_EXPENSE_ITEM\',\'0\',\'EXPENSE_ITEM_ID,EXPENSE_ITEM_NAME,ACCOUNT_CODE,ACCOUNT_CODE\',\'total_expense_item_id' + payment_row_count +','+'total_expense_item_name'+payment_row_count+','+'total_account_code'+payment_row_count+','+'total_account_id'+payment_row_count+'\',\'add_credit_contract\',1);" id="total_expense_item_name' + payment_row_count +'" id="total_expense_item_name' + payment_row_count +'" value="'+total_expense_item_name+'" class="text"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_items(\'total_expense_item_id\',\'total_expense_item_name\',\'total_account_id\',\'total_account_code\',\''+payment_row_count+'\')" id="expense_item_name2' + payment_row_count +'"></span></div></div>';
				newCell = newRow.insertCell(newRow.cells.length);
						newCell.setAttribute('nowrap','nowrap');
						newCell.innerHTML = '<input  type="hidden" name="total_account_id' + payment_row_count +'" id="total_account_id' + payment_row_count +'" value="'+total_account_id+'"><div class="form-group large"><div class="input-group"><input type="text" value="'+total_account_code+'" name="total_account_code' + payment_row_count +'" id="total_account_code' + payment_row_count +'" class="text"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_acc(\'total_account_id\',\'total_account_code\',\''+payment_row_count+'\')"></span></div></div>';
				
				if(proc_control == 296){
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute('nowrap','nowrap');
					newCell.innerHTML = '<input  type="hidden" name="borrow_id' + payment_row_count +'"  id="borrow_id' + payment_row_count +'" value="'+borrow_id+'"><div class="form-group large"><div class="input-group"><input type="text" value="'+borrow_code+'"  name="borrow_code' + payment_row_count +'" onFocus="AutoComplete_Create(\'borrow_code' + payment_row_count +'\',\'ACCOUNT_CODE,ACCOUNT_NAME\',\'CODE_NAME\',\'get_account_code\',\'0\',\'ACCOUNT_CODE,CODE_NAME\',\'borrow_id' + payment_row_count +','+'borrow_code'+payment_row_count+'\',\'upd_credit_contract\',1);" id="borrow_code' + payment_row_count +'" class="text"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_acc(\'borrow_id\',\'borrow_code\',\''+payment_row_count+'\')"></span></div></div>';
				}
				write_total_amount(1);
			}
			else
				alert("<cf_get_lang dictionary_id='51403.Önce İşlem Tipi Seçmelisiniz'>!");
		}
		else /* tahsilat */
		{
			table4.style.display = '';
			revenue_row_count++;	
			revenue_kontrol_row_count++;
			var newRow;
			var newCell;
			newRow = document.getElementById("table3").insertRow(document.getElementById("table3").rows.length);	
			newRow.setAttribute("name","revenue_frm_row" + revenue_row_count);
			newRow.setAttribute("id","revenue_frm_row" + revenue_row_count);		
			newRow.setAttribute("NAME","revenue_frm_row" + revenue_row_count);
			newRow.setAttribute("ID","revenue_frm_row" + revenue_row_count);		
			document.getElementById('revenue_record_num').value=revenue_row_count;
			document.getElementById('rowCount_2').value = parseInt(document.getElementById('rowCount_2').value) + 1;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.setAttribute("style","text-align:center");
			newCell.innerHTML =document.getElementById('rowCount_2').value;
			
			
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML =  '<input  type="hidden" name="revenue_row_kontrol' + revenue_row_count +'" id="revenue_row_kontrol' + revenue_row_count +'" value="1"><ul class="ui-icon-list"><li><a onclick="delete_row(' + revenue_row_count + ',2);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></li><li><a onclick="open_row_add(2,' + revenue_row_count + ');"><i class="icon-branch" title="<cf_get_lang dictionary_id='62455.Satır Çoğalt'>" alt="<cf_get_lang dictionary_id='62455.Satır Çoğalt'>"></i></a></li><li><a onclick="copy_row(2,' + revenue_row_count + ');"><i class="fa fa-copy" title="<cf_get_lang dictionary_id='58972.Satır Kopyala'>" alt="<cf_get_lang dictionary_id='58972.Satır Kopyala'>"></i></a></li></ul>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.setAttribute("style","text-align:right");
			newCell.setAttribute("id","revenue_date" + revenue_row_count + "_td");
			newCell.innerHTML = '<input type="hidden" name="revenue_credit_contract_row_id' + revenue_row_count +'" id="revenue_credit_contract_row_id' + revenue_row_count +'" value=""><input type="hidden" name="payment_credit_contract_row_id' + revenue_row_count +'" id="payment_credit_contract_row_id' + revenue_row_count +'" value=""><input type="text" name="revenue_date' + revenue_row_count +'" id="revenue_date' + revenue_row_count +'" class="text" style="width:70px;" maxlength="10" value="' + payment_date + '">';
			wrk_date_image('revenue_date' + revenue_row_count);
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><input type="text" name="revenue_capital_price' + revenue_row_count +'" id="revenue_capital_price' + revenue_row_count +'" maxlength="20" value="'+payment_capital_price+'" onKeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(2);" class="moneybox" float:right;"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="revenue_interest_price' + revenue_row_count +'" id="revenue_interest_price' + revenue_row_count +'" value="'+payment_interest_price+'" onKeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(2);" class="moneybox" float:right;"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="revenue_tax_price' + revenue_row_count +'" id="revenue_tax_price' + revenue_row_count +'" value="'+payment_tax_price+'" onKeyup="return(FormatCurrency(this,event));" onblur="write_total_amount(2);" class="moneybox" float:right;"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="revenue_total_price' + revenue_row_count +'" id="revenue_total_price' + revenue_row_count +'" value="'+payment_total_price+'" class="moneybox" readonly float:right;"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group large"><input type="text" name="revenue_detail' + revenue_row_count +'" id="revenue_detail' + revenue_row_count +'" value="'+payment_detail+'"  maxlength="100"></div>';
			if(proc_control != 296)
			{
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("nowrap","nowrap");
				a = '<div class="form-group large"><select name="revenue_expense_center_id' + revenue_row_count  +'" id="revenue_expense_center_id' + revenue_row_count  +'" float:right;" class="text"><option value="">M. Merkezi</option>';
				<cfoutput query="get_expense_center">
				if('#expense_id#' == expense_center_id)
					a += '<option value="#expense_id#" selected>#expense#</option>';
				else
					a += '<option value="#expense_id#">#expense#</option>';
				</cfoutput>
				newCell.innerHTML =a+ '</select></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("nowrap","nowrap");
				newCell.innerHTML = '<input  type="hidden" name="revenue_capital_expense_item_id' + revenue_row_count +'" id="revenue_capital_expense_item_id' + revenue_row_count +'" value="'+capital_expense_item_id+'"><div class="form-group large"><div class="input-group"><input type="text" name="revenue_capital_expense_item_name' + revenue_row_count +'" id="revenue_capital_expense_item_name' + revenue_row_count +'" readonly="yes" value="'+capital_expense_item_name+'" class="text"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_items(\'revenue_capital_expense_item_id\',\'revenue_capital_expense_item_name\',\'revenue_capital_account_id\',\'revenue_capital_account_code\',\''+revenue_row_count+'\')"></span></div></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("nowrap","nowrap");
				newCell.innerHTML = '<input  type="hidden" name="revenue_capital_account_id' + revenue_row_count +'" id="revenue_capital_account_id' + revenue_row_count +'" value="'+capital_account_id+'"><div class="form-group large"><div class="input-group"><input type="text" value="'+capital_account_code+'" name="revenue_capital_account_code' + revenue_row_count +'" id="revenue_capital_account_code' + revenue_row_count +'" class="text"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_acc(\'revenue_capital_account_id\',\'revenue_capital_account_code\',\''+revenue_row_count+'\')"></span></div></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("nowrap","nowrap");
				newCell.innerHTML = '<input  type="hidden" name="revenue_expense_item_id' + revenue_row_count +'" id="revenue_expense_item_id' + revenue_row_count +'" value="'+expense_item_id+'"><div class="form-group large"><div class="input-group"><input type="text" readonly="yes" name="revenue_expense_item_name' + revenue_row_count +'" id="revenue_expense_item_name' + revenue_row_count +'" value="'+expense_item_name+'" class="text"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_items(\'revenue_expense_item_id\',\'revenue_expense_item_name\',\'revenue_interest_account_id\',\'revenue_interest_account_code\',\''+revenue_row_count+'\')" id="expense_item_name2' + revenue_row_count +'"></span></div></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("nowrap","nowrap");
				newCell.innerHTML = '<input  type="hidden" name="revenue_interest_account_id' + revenue_row_count +'" id="revenue_interest_account_id' + revenue_row_count +'" value="'+interest_account_id+'"><div class="form-group large"><div class="input-group"><input type="text" value="'+interest_account_code+'" name="revenue_interest_account_code' + revenue_row_count +'" id="revenue_interest_account_code' + revenue_row_count +'" class="text"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_acc(\'revenue_interest_account_id\',\'revenue_interest_account_code\',\''+revenue_row_count+'\')"></span></div></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("nowrap","nowrap");
				newCell.innerHTML = '<input  type="hidden" name="revenue_total_expense_item_id' + revenue_row_count +'" id="revenue_total_expense_item_id' + revenue_row_count +'" value="'+total_expense_item_id+'"><div class="form-group large"><div class="input-group"><input type="text" name="revenue_total_expense_item_name' + revenue_row_count +'" id="revenue_total_expense_item_name' + revenue_row_count +'" readonly="yes" value="'+total_expense_item_name+'" class="text"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_items(\'revenue_total_expense_item_id\',\'revenue_total_expense_item_name\',\'revenue_total_account_id\',\'revenue_total_account_code\',\''+revenue_row_count+'\')" id="expense_item_name2' + revenue_row_count +'"></span></div></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute("nowrap","nowrap");
				newCell.innerHTML = '<input  type="hidden" name="revenue_total_account_id' + revenue_row_count +'" id="revenue_total_account_id' + revenue_row_count +'" value="'+total_account_id+'"><div class="form-group large"><div class="input-group"><input type="text" value="'+total_account_code+'"  name="revenue_total_account_code' + revenue_row_count +'" id="revenue_total_account_code' + revenue_row_count +'" class="text"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_acc(\'revenue_total_account_id\',\'revenue_total_account_code\',\''+revenue_row_count+'\')"></span></div></div>';
			}
			write_total_amount(2);
		}
	}
	function copy_row(type,no)
	{
		var selected_ptype = document.getElementById('process_cat').options[document.getElementById('process_cat').selectedIndex].value;
		eval('var proc_control = document.upd_credit_contract.ct_process_type_'+selected_ptype+'.value');
		
		if(type == 1)
		{ 
			payment_date = document.getElementById('payment_date' + no).value;
			payment_capital_price = document.getElementById('payment_capital_price' + no).value;
			payment_interest_price = document.getElementById('payment_interest_price' + no).value;
			payment_tax_price = document.getElementById('payment_tax_price' + no).value;
			payment_total_price = document.getElementById('payment_total_price' + no).value;
			payment_detail = document.getElementById('payment_detail' + no).value;
			expense_center_id = document.getElementById('expense_center_id' + no).value;
			expense_item_id = document.getElementById('expense_item_id' + no).value;
			expense_item_name = document.getElementById('expense_item_name' + no).value;
			interest_account_id = document.getElementById('interest_account_id' + no).value;
			interest_account_code = document.getElementById('interest_account_code' + no).value;
			total_expense_item_id = document.getElementById('total_expense_item_id' + no).value;
			total_expense_item_name = document.getElementById('total_expense_item_name' + no).value;
			total_account_id = document.getElementById('total_account_id' + no).value;
			total_account_code = document.getElementById('total_account_code' + no).value;
			if(document.getElementById('borrow_id'+no) != undefined || document.getElementById('borrow_code'+no) != undefined)
			{
			borrow_id = document.getElementById('borrow_id' + no).value;
			borrow_code = document.getElementById('borrow_code' + no).value;
			}
			else
			{
				borrow_id = '';
				borrow_code = '';
			}
			if(proc_control == 296)
			{
				total_payment_price = document.getElementById('total_payment_price' + no).value;				
				capital_expense_item_id = '';
				capital_expense_item_name = '';
				capital_account_id = '';
				capital_account_code = '';
			}
			else
			{
				total_payment_price = '';
				capital_expense_item_id = document.getElementById('capital_expense_item_id' + no).value;
				capital_expense_item_name = document.getElementById('capital_expense_item_name' + no).value;
				capital_account_id = document.getElementById('capital_account_id' + no).value;
				capital_account_code = document.getElementById('capital_account_code' + no).value;
			}
		}
		else
		{
			payment_date = document.getElementById('revenue_date' + no).value;
			payment_capital_price = document.getElementById('revenue_capital_price' + no).value;
			payment_interest_price = document.getElementById('revenue_interest_price' + no).value;
			payment_tax_price = document.getElementById('revenue_tax_price' + no).value;
			payment_total_price = document.getElementById('revenue_total_price' + no).value;
			payment_detail = document.getElementById('revenue_detail' + no).value;
			if(proc_control != 296)
			{	
				total_payment_price = '';
				expense_center_id = document.getElementById('revenue_expense_center_id' + no).value;
				expense_item_id = document.getElementById('revenue_expense_item_id' + no).value;
				expense_item_name = document.getElementById('revenue_expense_item_name' + no).value;
				interest_account_id = document.getElementById('revenue_interest_account_id' + no).value;
				interest_account_code = document.getElementById('revenue_interest_account_code' + no).value;
				total_expense_item_id = document.getElementById('revenue_total_expense_item_id' + no).value;
				total_expense_item_name = document.getElementById('revenue_total_expense_item_name' + no).value;
				total_account_id = document.getElementById('revenue_total_account_id' + no).value;
				total_account_code = document.getElementById('revenue_total_account_code' + no).value;

				capital_expense_item_id = document.getElementById('revenue_capital_expense_item_id' + no).value;
				capital_expense_item_name = document.getElementById('revenue_capital_expense_item_name' + no).value;
				capital_account_id = document.getElementById('revenue_capital_account_id' + no).value;
				capital_account_code = document.getElementById('revenue_capital_account_code' + no).value;	
				
			}
			else
			{
				total_payment_price = '';
				expense_center_id = '';
				expense_item_id = '';
				expense_item_name = '';
				interest_account_id = '';
				interest_account_code = '';
				total_expense_item_id = '';
				total_expense_item_name = '';
				total_account_id = '';
				total_account_code = '';
				capital_expense_item_id = '';
				capital_expense_item_name = '';
				capital_account_id = '';
				capital_account_code = '';
				borrow_id = '';
				borrow_code = '';
			}
		}
		add_row(type,payment_date,payment_capital_price,payment_interest_price,payment_tax_price,payment_total_price,payment_detail,total_payment_price,expense_center_id,expense_item_id,expense_item_name,interest_account_id,interest_account_code,total_expense_item_id,total_expense_item_name,capital_expense_item_id,capital_expense_item_name,capital_account_id,capital_account_code,total_account_id,total_account_code,borrow_id,borrow_code);
	}
	function delete_row(sy,type)
	{
		document.getElementById('rowCount').value  = parseInt(document.getElementById('rowCount').value) - 1;
		if(type == 1)
		{
			document.getElementById('payment_record_num2').value--;		
			var my_element=eval("upd_credit_contract.payment_row_kontrol"+sy);
			my_element.value=0;
			var my_element=eval("payment_frm_row"+sy);
			my_element.style.display="none";
			payment_kontrol_row_count--;
			if(payment_kontrol_row_count <= 0)
				table2.style.display = 'none';
			else
				write_total_amount(1);
		}
		else
		{
			var my_element=eval("upd_credit_contract.revenue_row_kontrol"+sy);
			my_element.value=0;
			var my_element=eval("revenue_frm_row"+sy);
			my_element.style.display="none";
			revenue_kontrol_row_count--;
			if(revenue_kontrol_row_count <= 0)
				table4.style.display = 'none';
			else
				write_total_amount(2);	
		}
	}
	
	$(function(){
        
       	$('.collapse').click(function(){
            
			$(this).parent().parent().find('.totalBoxBody').slideToggle();
			if( $(this).find("span").hasClass("icon-pluss") ) $(this).find("span").removeClass("icon-pluss").addClass("icon-minus");
			else $(this).find("span").removeClass("icon-minus").addClass("icon-pluss");

       });
    })
	function secim1()
	{
		if(document.getElementById('is_active').checked == false)
			document.getElementById('is_scenario').checked = false;
	}
	
	function kontrol()
	{
		control_account_process(<cfoutput>'#attributes.credit_contract_id#','#get_credit_contract.process_type#'</cfoutput>);
		if(upd_credit_contract.credit_no != "")
		{
			if(!paper_control(upd_credit_contract.credit_no,'CREDIT','1',<cfoutput>'#attributes.credit_contract_id#'</cfoutput>,'','','','','<cfoutput>#dsn3#</cfoutput>')) return false;
		}
		if(upd_credit_contract.credit_no.value == "")
		{
			alert('<cf_get_lang dictionary_id='40958.Belge Numarası Boş Bırakılamaz!'> : <cf_get_lang dictionary_id='59178.Kredi No'>');
			return false;
		}
		if (!chk_process_cat('upd_credit_contract')) return false; 
		var get_process_cat_account = wrk_safe_query('crd_get_process_cat','dsn3',0,document.getElementById('process_cat').value);
		if(get_process_cat_account.IS_ACCOUNT == 1 && document.getElementById('credit_date').value != "")
			if(!chk_period(upd_credit_contract.credit_date,"İşlem")) return false;
	
		if(get_process_cat_account.IS_ACCOUNT == 1)
		{
			if(document.getElementById('company_id').value == '' || document.getElementById('company').value == '')
			{
				alert("<cf_get_lang dictionary_id='51348.Lütfen Kredi Kurumu Seçiniz'>! ");
				return false;
			}	
		}
		if(!check_display_files('upd_credit_contract')) return false;
		<cfif is_same_limit_currency eq 1>
			if(document.getElementById('credit_limit_id').value != '')
			{
				var get_credit_all = wrk_safe_query('crd_get_crd_all','dsn3',0,document.getElementById('credit_limit_id').value);
				for(var i=1;i<=<cfoutput>#get_money.recordcount#</cfoutput>;i++)
				{
					if(eval('upd_credit_contract.rd_money['+(i-1)+'].checked'))
					{
						if(get_credit_all.MONEY_TYPE != document.getElementById('hidden_rd_money_'+i).value)
						{
							alert("<cf_get_lang dictionary_id='54536.Kredi Limiti İle Kredi Sözleşmesinin Para Birimi Aynı Olmalı'>!");
							return false;
						}
					}
				}
			}
		</cfif>
		x=(100 - document.getElementById('detail').value.length);
		if(x < 0)
		{ 
			alert ("<cf_get_lang dictionary_id='57629.Açıklama'><cf_get_lang dictionary_id='29509.En Fazla 100 Karakter Giriniz'><cf_get_lang dictionary_id='29484.Fazla Karakter Sayısı'>:"+ ((-1) * x));
			return false;
		}
		var selected_ptype = document.getElementById('process_cat').options[document.getElementById('process_cat').selectedIndex].value;
		eval('var proc_control = document.upd_credit_contract.ct_process_type_'+selected_ptype+'.value');
		
		// Odeme satir kontrolleri
		for(r=1;r<=upd_credit_contract.payment_record_num.value;r++)
		{
			deger_row_kontrol = document.getElementById("payment_row_kontrol"+r);
			deger_date = document.getElementById("payment_date"+r);
			deger_capital_price = document.getElementById("payment_capital_price"+r);
			deger_expense = document.getElementById("expense_item_name"+r);
			deger_total_expense = document.getElementById("total_expense_item_name"+r);
			deger_interest_account_code = document.getElementById("interest_account_code"+r);
			deger_interest_value = document.getElementById("payment_interest_price"+r);
			deger_total_account_code = document.getElementById("total_account_code"+r);
			if(proc_control == 296) {
			deger_borrow_code = document.getElementById("borrow_code"+r);
			}
			if(deger_row_kontrol.value == 1)
			{
				if(deger_date.value == "")
				{
					alert("<cf_get_lang dictionary_id='51372.Lütfen Ödeme Tarihi Giriniz'>! ");
					return false;
				}
				if(deger_capital_price.value == "")
				{
					alert("<cf_get_lang dictionary_id='51352.Ana Para Tutarı Giriniz'> ! ");
					return false;
				}
				if(proc_control == 296)
				{
					if(deger_expense.value=='')
					{
						alert("<cf_get_lang dictionary_id='51384.Lütfen Faiz Gider Kalemi Seçiniz'>");
						return false;
					}
					if(filterNum(deger_interest_value.value) > 0 && deger_interest_account_code.value=='')
					{
						alert("<cf_get_lang dictionary_id='51405.Lütfen Faiz Muhasebe Kodu Seçiniz'>!");
						return false;
					}
					if(deger_total_expense.value=='')
					{
						alert("<cf_get_lang dictionary_id='51406.Lütfen Kira Gider Kalemi Seçiniz'>!");
						return false;
					}
					if(deger_total_account_code.value=='')
					{
						alert("<cf_get_lang dictionary_id='51407.Lütfen Kira Muhasebe Kodu Seçiniz'>!");
						return false;
					}
					if(document.getElementById('total_account_code'+r).value=='')
					{
						alert("<cf_get_lang dictionary_id='51404.Lütfen Finansal Kiralama Muhasebe Kodu Seçiniz'>");
						return false;
					}
					if(deger_borrow_code.value == "")
					{
						alert("<cf_get_lang dictionary_id='54538.Lütfen Borçlanma Maliyet Kodu Giriniz'>!");
						return false;
					}
					if(document.getElementById('payment_interest_price'+r).value=='')
					{
						document.getElementById("payment_interest_price"+r).value=commaSplit(0,'4');
						return false;
					}
				}
			}
		}
		// Tahsilat satir kontrolleri
		for(k=1;k<=upd_credit_contract.revenue_record_num.value;k++)
		{
			deger_row_kontrol = document.getElementById("revenue_row_kontrol"+k);
			deger_date = document.getElementById("revenue_date"+k);
			deger_capital_price = document.getElementById('revenue_capital_price'+k);
			if(deger_row_kontrol.value == 1)
			{
				if(deger_date.value == "")
				{
					alert("<cf_get_lang dictionary_id='51366.Lütfen Tahsilat Tarihi Giriniz'> !");
					return false;
				}
				if(deger_capital_price.value == "")
				{
					alert("<cf_get_lang dictionary_id='51352.Ana Para Tutarı Giriniz'> ! ");
					return false;
				}
			}
		}	
		unformat_fields();
		return true;
	}
	function payment_interest_price_amount(row){
		if(document.getElementById('payment_interest_price'+row).value=='')
				{
					document.getElementById("payment_interest_price"+row).value=commaSplit(0,'4');
					return false;
				}
	}
	
	function payment_capital_price_amount(row){
		if(document.getElementById('payment_capital_price'+row).value=='')
				{
					document.getElementById("payment_capital_price"+row).value=commaSplit(0,'4');
					return false;
				}
	}
	
	function payment_tax_price_amount(row){
		if(document.getElementById('payment_tax_price'+row).value=='')
				{
					document.getElementById("payment_tax_price"+row).value=commaSplit(0,'4');
					return false;
				}
	}
	function write_total_amount(type,type2)
	{
		if(type == 1)
		{
			var payment_total_capital_price = 0;
			var payment_total_interest_price = 0;
			var payment_total_tax_price = 0;
			var payment_total_price = 0;
				
			for (var i=1; i <= upd_credit_contract.payment_record_num.value; i++)
			{
				deger_row_kontrol = document.getElementById("payment_row_kontrol"+i);
				if(deger_row_kontrol.value == 1)
				{
					if(type2 == undefined)
					{
						var payment_row_total_price = 0;
						payment_total_capital_price += parseFloat(filterNum(document.getElementById('payment_capital_price'+i).value),4);
						payment_total_interest_price += parseFloat(filterNum(document.getElementById('payment_interest_price'+i).value,4));
						payment_total_tax_price += parseFloat(filterNum(document.getElementById('payment_tax_price'+i).value,4));
						if(document.getElementById('payment_capital_price'+i).value != "") payment_row_total_price += parseFloat(filterNum(document.getElementById('payment_capital_price'+i).value,4));
						if(document.getElementById('payment_interest_price'+i).value != "") payment_row_total_price += parseFloat(filterNum(document.getElementById('payment_interest_price'+i).value,4));
						if(document.getElementById("total_payment_price"+i) != undefined)
							document.getElementById("total_payment_price"+i).value = commaSplit(payment_row_total_price,4);
						if(document.getElementById('payment_tax_price'+i).value != "") payment_row_total_price += parseFloat(filterNum(document.getElementById('payment_tax_price'+i).value));
						document.getElementById("payment_total_price"+i).value = commaSplit(payment_row_total_price,4);
						payment_total_price += parseFloat(payment_row_total_price);
					}
					else
					{
						var payment_row_total_price = 0;
						payment_total_capital_price += parseFloat(filterNum(document.getElementById('payment_capital_price'+i).value));
						payment_total_interest_price += parseFloat(filterNum(document.getElementById('payment_interest_price'+i).value));
						if(document.getElementById('payment_capital_price'+i).value != "") payment_row_total_price += parseFloat(filterNum(document.getElementById('payment_capital_price'+i).value));
						if(document.getElementById('payment_interest_price'+i).value != "") payment_row_total_price += parseFloat(filterNum(document.getElementById('payment_interest_price'+i).value));
						if(document.getElementById("total_payment_price"+i) != undefined)
							document.getElementById("total_payment_price"+i).value = commaSplit(payment_row_total_price);
						document.getElementById("payment_tax_price"+i).value = parseFloat(filterNum(document.getElementById("payment_total_price"+i).value)-filterNum(document.getElementById("payment_capital_price"+i).value)-filterNum(document.getElementById("payment_interest_price"+i).value));
						payment_total_tax_price += filterNum(document.getElementById('payment_tax_price'+i).value);
						if(document.getElementById('payment_tax_price'+i).value != "") payment_row_total_price += parseFloat(filterNum(document.getElementById('payment_tax_price'+i).value));
						payment_total_price += parseFloat(payment_row_total_price);
					}	
				}
			}
			document.getElementById('payment_total_capital_price').value = commaSplit(payment_total_capital_price,4);
			document.getElementById('payment_total_interest_price').value = commaSplit(payment_total_interest_price,4);
			document.getElementById('payment_total_tax_price').value = commaSplit(payment_total_tax_price,4);
			document.getElementById('payment_total_price').value = commaSplit(payment_total_price,4);
			document.getElementById('total_payment').value = commaSplit(payment_total_price,4);
			document.getElementById('payment_total_price_kdvsiz').value = commaSplit(payment_total_price-payment_total_tax_price);
		}
		else
		{
			var revenue_total_capital_price = 0;
			var revenue_total_interest_price = 0;
			var revenue_total_tax_price = 0;
			var revenue_total_price = 0;
				
			for (var i=1; i <= upd_credit_contract.revenue_record_num.value; i++)
			{
				deger_row_kontrol = document.getElementById("revenue_row_kontrol"+i);
				if(deger_row_kontrol.value == 1)
				{
					var revenue_row_total_price = 0;
					revenue_total_capital_price += parseFloat(filterNum(document.getElementById('revenue_capital_price'+i).value));
					revenue_total_interest_price += parseFloat(filterNum(document.getElementById('revenue_interest_price'+i).value));
					revenue_total_tax_price += parseFloat(filterNum(document.getElementById('revenue_tax_price'+i).value));
					if(document.getElementById('revenue_capital_price'+i).value != "") revenue_row_total_price += parseFloat(filterNum(document.getElementById('revenue_capital_price'+i).value));
					if(document.getElementById('revenue_interest_price'+i).value != "") revenue_row_total_price += parseFloat(filterNum(document.getElementById('revenue_interest_price'+i).value));
					if(document.getElementById('revenue_tax_price'+i).value != "") revenue_row_total_price += parseFloat(filterNum(document.getElementById('revenue_tax_price'+i).value));
					document.getElementById("revenue_total_price"+i).value = commaSplit(revenue_row_total_price);
					revenue_total_price += parseFloat(revenue_row_total_price);
				}
			}
			document.getElementById('revenue_total_capital_price').value = commaSplit(revenue_total_capital_price);
			document.getElementById('revenue_total_interest_price').value = commaSplit(revenue_total_interest_price);
			document.getElementById('revenue_total_tax_price').value = commaSplit(revenue_total_tax_price);
			document.getElementById('revenue_total_price').value = commaSplit(revenue_total_price);
			document.getElementById('total_revenue').value = commaSplit(revenue_total_price);
		}
		f_kur_hesapla_multi();
	}
	function unformat_fields()
	{
		for(r=1;r<=upd_credit_contract.payment_record_num.value;r++)
		{
			if(document.getElementById("payment_row_kontrol"+r).value == 1)
			{
				document.getElementById("payment_capital_price"+r).value = filterNum(document.getElementById("payment_capital_price"+r).value);
				document.getElementById("payment_interest_price"+r).value = filterNum(document.getElementById("payment_interest_price"+r).value);
				document.getElementById("payment_tax_price"+r).value = filterNum(document.getElementById("payment_tax_price"+r).value);
				document.getElementById("payment_total_price"+r).value = filterNum(document.getElementById("payment_total_price"+r).value);
			}
		}
		
		for(k=1;k<=upd_credit_contract.revenue_record_num.value;k++)
		{
			if(document.getElementById("revenue_row_kontrol"+k).value == 1)
			{
				document.getElementById("revenue_capital_price"+k).value = filterNum(document.getElementById("revenue_capital_price"+k).value);
				document.getElementById("revenue_interest_price"+k).value = filterNum(document.getElementById("revenue_interest_price"+k).value);
				document.getElementById("revenue_tax_price"+k).value = filterNum(document.getElementById("revenue_tax_price"+k).value);
				document.getElementById("revenue_total_price"+k).value = filterNum(document.getElementById("revenue_total_price"+k).value);
			}
		}
		
		for(s=1;s<=upd_credit_contract.deger_get_money.value;s++)
		{
			document.getElementById('txt_rate2_' + s).value = filterNum(document.getElementById('txt_rate2_' + s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
		document.getElementById("interest_rate").value = filterNum(document.getElementById("interest_rate").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		upd_credit_contract.total_revenue.value = filterNum(upd_credit_contract.total_revenue.value);
		upd_credit_contract.other_total_revenue.value = filterNum(upd_credit_contract.other_total_revenue.value);
		upd_credit_contract.total_payment.value = filterNum(upd_credit_contract.total_payment.value);
		upd_credit_contract.other_total_payment.value = filterNum(upd_credit_contract.other_total_payment.value);
		//upd_credit_contract.credit_cost.value = filterNum(upd_credit_contract.credit_cost.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		
	}
	function f_kur_hesapla_multi()//sistem para birimi hesaplama
	{
		var system_cur_value;
		for(var i=1;i<=<cfoutput>#get_money.recordcount#</cfoutput>;i++)
		{
			if(document.upd_credit_contract.rd_money[i-1].checked == true)
			{
				rate1_eleman = filterNum(document.getElementById('txt_rate1_'+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				rate2_eleman = filterNum(document.getElementById('txt_rate2_'+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				system_cur_value = filterNum(document.getElementById('revenue_total_price').value)*rate2_eleman/rate1_eleman;
				upd_credit_contract.other_total_revenue.value = commaSplit(system_cur_value);

				system_cur_value = filterNum(document.getElementById('payment_total_price').value,4)*rate2_eleman/rate1_eleman;
				upd_credit_contract.other_total_payment.value = commaSplit(system_cur_value,4);
				
				upd_credit_contract.money_info_rev.value = document.getElementById('hidden_rd_money_'+i).value;
				upd_credit_contract.money_info_pay.value = document.getElementById('hidden_rd_money_'+i).value;
			}
		}
	}
	function gizle_finance()
	{
		var selected_ptype = document.getElementById('process_cat').options[document.getElementById('process_cat').selectedIndex].value;
		if(selected_ptype != '')
		{
			eval('var proc_control = document.upd_credit_contract.ct_process_type_'+selected_ptype+'.value');
			if(proc_control == 296)
			{
				
				
				finance7.style.display = '';
				finance8.style.display = '';
				finance9.style.display = '';
				credit_limit.style.display = 'none';
				credit_limit_.style.display = 'none';
				
				credittable.style.display = 'none';
			}
			else
			{
				
				
				finance7.style.display = 'none';
				finance8.style.display = 'none';
				finance9.style.display = 'none';
				credit_limit.style.display = '';
				credit_limit_.style.display = '';
				
			}
		}
	}
	//satir cogalt
	function open_row_add(type,row_number)
	{
		document.getElementById('add_multi_row').style.display='';
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=credit.popup_add_multi_credit_row&type='+ type +'&row_number='+ row_number,'add_multi_row',1);
	}
	//gider kalemleri popup
	function pencere_ac_items(input_id,input_name,input_acc_id,input_acc_code,row_number)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=upd_credit_contract.'+input_id+row_number+'&field_name=upd_credit_contract.'+input_name+row_number+'&field_account_no=upd_credit_contract.'+input_acc_code+row_number+'&field_account_no2=upd_credit_contract.'+input_acc_id+row_number+'');
	}
	//muhasebe kodlari popup
	function pencere_ac_acc(input_acc_id,input_acc_code,row_number)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=upd_credit_contract.'+input_acc_id+row_number+'&field_name=upd_credit_contract.'+input_acc_code+row_number+'','list');
	}
	
	document.getElementById('kredi_sepet').style.width = screen.width-50;
	document.getElementById('kredi_sepet').style.height = 150;
	h_ = parseInt(document.getElementById('kredi_sepet').style.height);
	if (document.getElementById('kredi_sepet').style.height != '')
		document.getElementById('kredi_sepet').style.height = h_ + <cfoutput>#get_rows_1.recordcount#*</cfoutput>20+25;
	gizle_finance();
</script>
