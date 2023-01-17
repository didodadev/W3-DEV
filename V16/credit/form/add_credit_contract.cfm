<cf_xml_page_edit fuseact="credit.add_credit_contract">
<cfquery name="get_money" datasource="#dsn#">
	SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# ORDER BY MONEY_ID
</cfquery>
<cfquery name="get_expense_center" datasource="#dsn2#">
	SELECT EXPENSE_ID,EXPENSE,EXPENSE_CODE FROM EXPENSE_CENTER WHERE EXPENSE_ACTIVE = 1 ORDER BY EXPENSE
</cfquery>
<cfquery name="get_credit_limit" datasource="#dsn3#">
	SELECT * FROM CREDIT_LIMIT ORDER BY LIMIT_HEAD
</cfquery>
<cfif isdefined("url.credit_contract_id") and len(url.credit_contract_id)>
	<cfquery name="GET_CREDIT_CONTRACT" datasource="#DSN3#">
		SELECT * FROM CREDIT_CONTRACT WHERE CREDIT_CONTRACT_ID = #url.credit_contract_id#
	</cfquery>
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
			CAPITAL_ACCOUNT_ID ,
            BORROW
		FROM
			CREDIT_CONTRACT_ROW
		WHERE
			CREDIT_CONTRACT_ID = #url.credit_contract_id# AND
			CREDIT_CONTRACT_TYPE = 1 AND
			IS_PAID = 0
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
			CAPITAL_ACCOUNT_ID 
		FROM
			CREDIT_CONTRACT_ROW
		WHERE
			CREDIT_CONTRACT_ID = #url.credit_contract_id# AND
			CREDIT_CONTRACT_TYPE = 2 AND
			IS_PAID = 0
	</cfquery>
	<!---odeme satirlari gider kalemleri listesi--->
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
	<!---tahsilat satirlari gider kalemleri listesi--->
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
	
	<cfif len(get_credit_contract.project_id)> 
		<cfquery name="GET_PROJECT_HEAD" datasource="#DSN#">
			SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #get_credit_contract.project_id#
		</cfquery>
	</cfif>
</cfif>
<cf_papers paper_type="credit">

<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="add_credit_contract">
			<input type="hidden" name="rowCount" id="rowCount" value="0">
			<input type="hidden" name="rowCount_2" id="rowCount_2" value="0">
			<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
			<cfif isdefined('attributes.order_no')><!--- Siparişten gelen kredi eklemeleri için,ilgili siparişin sipariş nosunu tutar. --->
				<input type="hidden" name="order_no" id="order_no" value="<cfoutput>#attributes.order_no#</cfoutput>">
			</cfif>
				<div class="col col-12 uniqueRow">
					<cf_basket_form id="credit_contract">
						<cf_box_elements>
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
								<div class="form-group" id="item-is_active">
									<label class="col col-4 col-xs-12">
										<input name="is_active" id="is_active" type="checkbox" value="" checked><cf_get_lang dictionary_id='57493.Aktif'>
									</label>
									<label class="col col-4 col-xs-12">
										<input name="is_scenario" id="is_scenario" type="checkbox" value=""<cfif isdefined("url.credit_contract_id") and len(url.credit_contract_id) and get_credit_contract.is_scenario eq 1>checked</cfif>><cf_get_lang dictionary_id='51342.Senaryoda Gözüksün'>
									</label>
								</div>
								<div class="form-group" id="item-survey_head">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.işlem tipi'> </label>
									<div class="col col-8 col-xs-12">
										<cfif isdefined("url.credit_contract_id") and len(url.credit_contract_id)>
											<cf_workcube_process_cat slct_width="150" onclick_function="gizle_finance()" process_cat="#get_credit_contract.process_cat#"  kontrol_parameter="payment_record_num2" form_name="add_credit_contract" alert_message="#getLang('','Satırda Ödeme Planı Varken İşlem Tipini Değiştiremezsiniz',51444)#">
										<cfelse>
											<cf_workcube_process_cat slct_width="150" onclick_function="gizle_finance()" kontrol_parameter="payment_record_num2" form_name="add_credit_contract">
										</cfif>
									</div>
								</div>
								<div class="form-group" id="item-credit_date">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'>*</label>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id='51347.Kredi Tarihini Kontrol Ediniz'> !</cfsavecontent>
											<cfif isdefined("url.credit_contract_id") and len(url.credit_contract_id)>
												<cfinput type="text" name="credit_date" id="credit_date" value="#dateformat(get_credit_contract.credit_date,dateformat_style)#" validate="#validate_style#" required="yes" maxlength="20" message="#message#">
											<cfelse>
												<cfinput type="text" name="credit_date" id="credit_date" value="" validate="#validate_style#" required="yes"  maxlength="20" message="#message#">
											</cfif>
											<span class="input-group-addon "><cf_wrk_date_image date_field="credit_date"></span>
										</div>
									</div>
								</div>
								<div class="form-group" id="item-credit_no">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51338.Kredi No'>*</label>
									<div class="col col-8 col-xs-12">
										<input type="text" name="credit_no" id="credit_no" value="<cfoutput>#paper_code & '-' & paper_number#</cfoutput>">
									</div>
								</div>
								<div class="form-group" id="item-agreement_no">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='30044.Sözleşme No'></label>
									<div class="col col-8 col-xs-12">
										<input type="text" name="agreement_no" id="agreement_no" value="<cfif isdefined("url.credit_contract_id") and len(url.credit_contract_id)><cfoutput>#get_credit_contract.agreement_no#</cfoutput></cfif>" maxlength="20">
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
								<div class="form-group" id="item-credit_employee_id">
									<label class="col col-4"><cf_get_lang dictionary_id='57544.Sorumlu'></label>
									<div class="col col-8 col-xs-12"> 
										<div class="input-group">
											<input type="hidden" name="credit_emp_id" id="credit_emp_id" value="">
											<input type="text" name="credit_emp_name" id="credit_emp_name" value="" onFocus="AutoComplete_Create('credit_emp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','credit_emp_id','','3','135');" autocomplete="off" required="yes" message="">                         
											<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_credit_contract.credit_emp_id&field_name=add_credit_contract.credit_emp_name&is_form_submitted=1&select_list=1');" title="<cf_get_lang dictionary_id='30829.Talep Eden'>"></span>
										</div>
									</div>
								</div>
								<div class="form-group" id="item-company_id">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59171.Kredi Kurumu'>*</label>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("url.credit_contract_id") and len(url.credit_contract_id)><cfoutput>#get_credit_contract.company_id#</cfoutput></cfif>">
											<input type="hidden" name="partner_id" id="partner_id" value="">		
											<input type="text" name="company" id="company" onFocus="AutoComplete_Create('company','NICKNAME,MEMBER_CODE','NICKNAME,MEMBER_CODE','get_company','0','COMPANY_ID,NICKNAME','company_id,company','add_credit_contract',1);"  value="<cfif isdefined("url.credit_contract_id") and len(url.credit_contract_id)><cfoutput>#get_par_info(get_credit_contract.company_id,1,1,0)#</cfoutput></cfif>" >	  
											<cfset str_linke_ait="&field_comp_id=add_credit_contract.company_id&field_partner=add_credit_contract.partner_id&field_comp_name=add_credit_contract.company&select_list=2">
											<span class="input-group-addon icon-ellipsis " onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars<cfoutput>#str_linke_ait#</cfoutput>');"></span>                                 
										</div>
									</div>
								</div>
								<div class="form-group" id="item-account_no">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58178.Hesap No'></label>
									<div class="col col-8 col-xs-12">
										<input type="text" name="account_no" id="account_no" value="<cfif isdefined("url.credit_contract_id") and len(url.credit_contract_id)><cfoutput>#get_credit_contract.account_no#</cfoutput></cfif>" maxlength="50">
									</div>
								</div>
								<div class="form-group" id="item-reference">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58784.Referans'></label>
									<div class="col col-8 col-xs-12">
										<input type="text" name="reference" id="reference" maxlength="50" value="<cfif isdefined("url.credit_contract_id") and len(url.credit_contract_id)><cfoutput>#get_credit_contract.reference#</cfoutput><cfelseif isdefined('attributes.order_no')><cfoutput>#attributes.order_no#</cfoutput></cfif>">
									</div>
								</div>
								<div class="form-group" id="item-related_project_id">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57416.Proje'></label>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
											<input type="Hidden" name="related_project_id" id="related_project_id" value="<cfif isdefined("url.credit_contract_id") and len(url.credit_contract_id)><cfoutput>#get_credit_contract.project_id#</cfoutput></cfif>">
											<input type="text" name="related_project_head" id="related_project_head"  onFocus="AutoComplete_Create('related_project_head','PROJECT_HEAD,PROJECT_NUMBER','PROJECT_HEAD,PROJECT_NUMBER','get_project','0','PROJECT_ID,PROJECT_HEAD','related_project_id,related_project_head');"  value="<cfif isdefined("url.credit_contract_id") and len(url.credit_contract_id) and len(get_credit_contract.project_id)><cfoutput>#GET_PROJECT_HEAD.PROJECT_HEAD#</cfoutput></cfif>" >
											<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=add_credit_contract.related_project_head&project_id=add_credit_contract.related_project_id</cfoutput>');"></span>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
								<div class="form-group" id="item-interest_rate">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="51354.Faiz Oranı"></label>
									<div class="col col-6 col-xs-12">
										<input type="text" name="interest_rate" id="interest_rate" value="" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));">
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
											value="#iif(isdefined("url.credit_contract_id"),'get_credit_contract.credit_type',DE(''))#"
											width="130">                          
									</div>
								</div>
								<div class="form-group" id="item-credit_limit_id">
									<label class="col col-4 col-xs-12" id="credit_limit" style="display:none;"><cf_get_lang dictionary_id='58963.Kredi Limiti'></label>
									<div class="col col-8 col-xs-12" id="credit_limit_" style="display:none;">
										<select name="credit_limit_id" id="credit_limit_id">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfoutput query="get_credit_limit">
										<option value="#credit_limit_id#" <cfif isdefined("url.credit_contract_id") and len(url.credit_contract_id) and get_credit_contract.credit_limit_id eq credit_limit_id>selected</cfif>>#limit_head#</option>
										</cfoutput>
										</select>
									</div>
								</div>
								<div class="form-group" id="item-detail">
									<label class="col col-4 col-xs-12" rowspan="2" valign="top" width="60"><cf_get_lang dictionary_id='57629.Açıklama'></label>
									<div class="col col-8 col-xs-12" width="140" rowspan="2">
										<textarea name="detail" id="detail" style="width:140px;height:85px;"><cfif isdefined("url.credit_contract_id") and len(url.credit_contract_id)><cfoutput>#get_credit_contract.detail#</cfoutput></cfif></textarea>
									</div>
								</div>
							</div>
							<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="4" sort="true">
								<cf_seperator id="creditPlan" header="#getLang('','Ödeme Planı Oluştur',41279)#" is_closed="1">
								<div id="creditPlan" style="display:none">
									<cf_box_elements>
										<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
											<div class="form-group" id="item-calc_total_amount">
												<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57408.Anapara Tutarı"></label>
												<div class="col col-8 col-xs-12">
													<input name="calc_total_amount" id="calc_total_amount" type="text" value="" onkeyup="return(FormatCurrency(this,event,4));" maxlength="20" />
												</div>
											</div>
											<div class="form-group" id="item-calc_kkdf">
												<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="34009.KKDF"> (%)</label>
												<div class="col col-8 col-xs-12">
													<input name="calc_kkdf" id="calc_kkdf" type="text" value="" onkeyup="return(FormatCurrency(this,event,4));" maxlength="10" />
												</div>
											</div>
										</div>
										<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
											<div class="form-group" id="item-calc_monthly_interest_rate">
												<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57396.Aylık Faiz">(%)</label>
												<div class="col col-8 col-xs-12">
													<input name="calc_monthly_interest_rate" id="calc_monthly_interest_rate" type="text" value="" onkeyup="return(FormatCurrency(this,event,4));" maxlength="10" />
												</div>
											</div>
											<div class="form-group" id="item-calc_bsmv">
												<label class="col col-4 col-xs-12"> <cf_get_lang dictionary_id="50923.BSMV"> (%)</label>
												<div class="col col-8 col-xs-12">
													<input name="calc_bsmv" id="calc_bsmv" type="text" value="" onkeyup="return(FormatCurrency(this,event,4));"  maxlength="10"/>
												</div>
											</div>
										</div>
										<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
											<div class="form-group" id="item-calc_installment">
												<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="54816.Taksit Sayısı"></label>
												<div class="col col-8 col-xs-12">
													<input name="calc_installment" id="calc_installment" type="text" value="" onkeyup="return(FormatCurrency(this,event,0));" maxlength="10"/>
												</div>
											</div>
											<div class="form-group" id="item-calc_first_due_date">
												<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57366.İlk Taksit Tarihi"></label>
												<div class="col col-8 col-xs-12">
													<div class="input-group">
														<input type="text" name="calc_first_due_date" id="calc_first_due_date" value="" maxlength="10">
														<span class="input-group-addon"><cf_wrk_date_image date_field="calc_first_due_date"></span>
													</div>
												</div>
											</div>
										</div>
									
									<cf_grid_list>
										<thead>
											<th></th>
											<th><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th>
											<th><cf_get_lang dictionary_id="51355.Ana Para Gider Kalemi"></th>
											<th><cf_get_lang dictionary_id="51356.AnaPara Muhasebe Kodu"></th>
											<th><cf_get_lang dictionary_id='51399.Faiz Gider Kalemi'> *</th>
											<th><cf_get_lang dictionary_id='51400.Faiz Muhasebe Kodu'></th>
											<th><cf_get_lang dictionary_id="51357.Vergi-Masraf Gider Kalemi"></th>
											<th><cf_get_lang dictionary_id="51359.Vergi-Masraf Muhasebe Kodu"></th>
										</thead>
										<tbody>
											<tr>
												<td>
													<cf_get_lang dictionary_id="57331.Aktif Dönem">:
												</td>
												<td nowrap="nowrap">
													<div class="form-group">
														<select name="expense_center_id_main" id="expense_center_id_main" class="text">
															<option value=""><cf_get_lang dictionary_id="57331.M Merkezi"></option>
															<cfoutput query="get_expense_center">
																<option value="#expense_id#">#expense#</option>
															</cfoutput>
														</select>
													</div>
												</td>
												<td nowrap="nowrap">
													<div class="form-group">
														<div class="input-group">
															<input type="hidden" name="capital_expense_item_id_main" id="capital_expense_item_id_main" value="">
															<input type="text" name="capital_expense_item_name_main" id="capital_expense_item_name_main"  value="" class="text">
															<span class="input-group-addon icon-ellipsis" onclick="pencere_ac_items('capital_expense_item_id','capital_expense_item_name','capital_account_id','capital_account_code','_main');"></span>
														</div>
													</div>
												</td>
												<td nowrap="nowrap">
													<div class="form-group">
														<div class="input-group">
															<input type="hidden" name="capital_account_id_main" id="capital_account_id_main" value="">
															<input type="text" name="capital_account_code_main" id="capital_account_code_main" class="text" value="">
															<span class="input-group-addon icon-ellipsis" onclick="pencere_ac_acc('capital_account_id','capital_account_code','_main');"></span>
														</div>
													</div>
												</td>
												<td nowrap="nowrap">
													<div class="form-group">
														<div class="input-group">
															<input type="hidden" name="expense_item_id_main" id="expense_item_id_main" value="">
															<input type="text" name="expense_item_name_main" id="expense_item_name_main"  value="" onFocus="AutoComplete_Create('expense_item_name_main','EXPENSE_ITEM_NAME,ACCOUNT_CODE','EXPENSE_ITEM_NAME,ACCOUNT_CODE','GET_EXPENSE_ITEM','0','EXPENSE_ITEM_ID,EXPENSE_ITEM_NAME,ACCOUNT_CODE,ACCOUNT_CODE','expense_item_id_main,expense_item_name_main,interest_account_code_main,interest_account_id_main','add_credit_contract',1);" class="text">
															<span class="input-group-addon icon-ellipsis" onclick="pencere_ac_items('expense_item_id','expense_item_name','interest_account_id','interest_account_code','_main');"></span>
														</div>
													</div>
												</td>
												<td nowrap="nowrap">
													<div class="form-group">
														<div class="input-group">
															<input type="hidden" name="interest_account_id_main" id="interest_account_id_main" value="">
															<input type="text" name="interest_account_code_main" id="interest_account_code_main" class="text" value="">
															<span class="input-group-addon icon-ellipsis" onclick="pencere_ac_acc('interest_account_id','interest_account_code','_main');"></span>
														</div>
													</div>
												</td>
												<td nowrap="nowrap">
													<div class="form-group">
														<div class="input-group">
															<input type="hidden" name="total_expense_item_id_main" id="total_expense_item_id_main" value="">
															<input type="text" name="total_expense_item_name_main" id="total_expense_item_name_main" value="" onFocus="AutoComplete_Create('total_expense_item_name_main','EXPENSE_ITEM_NAME,ACCOUNT_CODE','EXPENSE_ITEM_NAME,ACCOUNT_CODE','GET_EXPENSE_ITEM','0','EXPENSE_ITEM_ID,EXPENSE_ITEM_NAME,ACCOUNT_CODE,ACCOUNT_CODE','total_expense_item_id_main,total_expense_item_name_main,total_account_code_main,total_account_id_main','add_credit_contract',1);" class="text">
															<span class="input-group-addon icon-ellipsis" onclick="pencere_ac_items('total_expense_item_id','total_expense_item_name','total_account_id','total_account_code','_main');"></span>
														</div>
													</div>
												</td>
												<td>
													<div class="form-group">
														<div class="input-group">
															<input type="hidden" name="total_account_id_main" id="total_account_id_main" value="">
															<input type="text" name="total_account_code_main" id="total_account_code_main" class="text" value="">
															<span class="input-group-addon icon-ellipsis" onclick="pencere_ac_acc('total_account_id','total_account_code','_main');"></span>
														</div>
													</div>
												</td>
											</tr>
											<tr>
												<td>
													<cf_get_lang dictionary_id="57330.Sonraki Dönem">:
												</td>
												<td nowrap="nowrap">
													<div class="form-group">
														<select name="expense_center_id_next" id="expense_center_id_next" class="text">
															<option value=""><cf_get_lang dictionary_id="57331.M Merkezi"></option>
															<cfoutput query="get_expense_center">
																<option value="#expense_id#">#expense#</option>
															</cfoutput>
														</select>
													</div>
												</td>
												<td nowrap="nowrap">
													<div class="form-group">
														<div class="input-group">
															<input type="hidden" name="capital_expense_item_id_next" id="capital_expense_item_id_next" value="">
															<input type="text" name="capital_expense_item_name_next" id="capital_expense_item_name_next"  value="" class="text">
															<span class="input-group-addon icon-ellipsis" onclick="pencere_ac_items('capital_expense_item_id','capital_expense_item_name','capital_account_id','capital_account_code','_next');"></span>
														</div>
													</div>
												</td>
												<td nowrap="nowrap">
													<div class="form-group">
														<div class="input-group">
															<input type="hidden" name="capital_account_id_next" id="capital_account_id_next" value="">
															<input type="text" name="capital_account_code_next" id="capital_account_code_next" class="text" value="">
															<span class="input-group-addon icon-ellipsis" onclick="pencere_ac_acc('capital_account_id','capital_account_code','_next');"></span>
														</div>
													</div>
												</td>
												<td nowrap="nowrap">
													<div class="form-group">
														<div class="input-group">
															<input type="hidden" name="expense_item_id_next" id="expense_item_id_next" value="">
															<input type="text" name="expense_item_name_next" id="expense_item_name_next"  value="" onFocus="AutoComplete_Create('expense_item_name_next','EXPENSE_ITEM_NAME,ACCOUNT_CODE','EXPENSE_ITEM_NAME,ACCOUNT_CODE','GET_EXPENSE_ITEM','0','EXPENSE_ITEM_ID,EXPENSE_ITEM_NAME,ACCOUNT_CODE,ACCOUNT_CODE','expense_item_id_next,expense_item_name_next,interest_account_code_next,interest_account_id_next','add_credit_contract',1);" class="text">
															<span class="input-group-addon icon-ellipsis" onclick="pencere_ac_items('expense_item_id','expense_item_name','interest_account_id','interest_account_code','_next');"></span>
														</div>
													</div>
												</td>
												<td nowrap="nowrap">
													<div class="form-group">
														<div class="input-group">
															<input type="hidden" name="interest_account_id_next" id="interest_account_id_next" value="">
															<input type="text" name="interest_account_code_next" id="interest_account_code_next" class="text" value="">
															<span class="input-group-addon icon-ellipsis" onclick="pencere_ac_acc('interest_account_id','interest_account_code','_next');"></span>
														</div>
													</div>
												</td>
												<td nowrap="nowrap">
													<div class="form-group">
														<div class="input-group">
															<input type="hidden" name="total_expense_item_id_next" id="total_expense_item_id_next" value="">
															<input type="text" name="total_expense_item_name_next" id="total_expense_item_name_next" value="" onFocus="AutoComplete_Create('total_expense_item_name_next','EXPENSE_ITEM_NAME,ACCOUNT_CODE','EXPENSE_ITEM_NAME,ACCOUNT_CODE','GET_EXPENSE_ITEM','0','EXPENSE_ITEM_ID,EXPENSE_ITEM_NAME,ACCOUNT_CODE,ACCOUNT_CODE','total_expense_item_id_next,total_expense_item_name_next,total_account_code_next,total_account_id_next','add_credit_contract',1);" class="text">
															<span class="input-group-addon icon-ellipsis" onclick="pencere_ac_items('total_expense_item_id','total_expense_item_name','total_account_id','total_account_code','_next');"></span>
														</div>
													</div>
												</td>
												<td>
													<div class="form-group">
														<div class="input-group">
															<input type="hidden" name="total_account_id_next" id="total_account_id_next" value="">
															<input type="text" name="total_account_code_next" id="total_account_code_next" class="text" value="">
															<span class="input-group-addon icon-ellipsis" onclick="pencere_ac_acc('total_account_id','total_account_code','_next');"></span>
														</div>
													</div>
												</td>
											</tr>
										</tbody>
										<script type="text/javascript">
											function isNumeric(n) {
											return !isNaN(parseFloat(n)) && isFinite(n);
											}
											
											function calc_installment_plan() {
												if(add_credit_contract.process_cat.value == ""){
														alert("<cf_get_lang dictionary_id ='51403.Önce İşlem Tipi Seçmelisiniz'> !");
													}
												
												for(i=1;i<= document.getElementById('payment_record_num').value;i++) {
													if(document.getElementById('payment_row_kontrol' + i).value == 1)
														delete_row(i,1);
												}
												for(i=1;i<= document.getElementById('revenue_record_num').value;i++) {
													if(document.getElementById('revenue_row_kontrol' + i).value == 1)
														delete_row(i,2);
												}
												
												var calc_total_amount = filterNum(document.getElementById('calc_total_amount').value);
												var calc_monthly_interest_rate = parseFloat(filterNum(document.getElementById("calc_monthly_interest_rate").value,4))/100;
												var calc_kkdf = parseFloat(document.getElementById('calc_kkdf').value)/100;
												var calc_bsmv = parseFloat(document.getElementById('calc_bsmv').value)/100;
												var calc_installment = parseInt(document.getElementById('calc_installment').value);
												var calc_first_due_date = document.getElementById('calc_first_due_date').value;
												var net_interest = (calc_kkdf + calc_bsmv + 1) * calc_monthly_interest_rate;
							
												if(calc_total_amount == 0 || calc_installment == 0) {
													alert("<cf_get_lang dictionary_id='57328.Anapara tutarı veya taksit sayısı sıfır olamaz'>");
													return false;
												}
												
												if(document.getElementById('calc_first_due_date').value.split("/").length != 3 || !isNumeric(document.getElementById('calc_first_due_date').value.split("/")[0]) || !isNumeric(document.getElementById('calc_first_due_date').value.split("/")[1]) || !isNumeric(document.getElementById('calc_first_due_date').value.split("/")[2])) {
													alert("<cf_get_lang dictionary_id='57782.Tarih değerini kontrol ediniz'>");
													return false;
												}
												
												if(net_interest == 0)
													var taksit_tutari = calc_total_amount / calc_installment;
												else
													var taksit_tutari = calc_total_amount * ((net_interest * Math.pow(1+net_interest,calc_installment))/(Math.pow(1+net_interest,calc_installment) - 1));
												var first_month_interest = parseFloat(calc_total_amount * calc_monthly_interest_rate);
												var first_month_kkdf = first_month_interest * calc_kkdf;
												var first_month_bsmv = first_month_interest * calc_bsmv;
												var first_month_capital = taksit_tutari - (first_month_interest + first_month_kkdf + first_month_bsmv);
												
												var remaining_capital = calc_total_amount - first_month_capital;
												
												var next_due_date = calc_first_due_date;
												add_row(1,next_due_date,commaSplit(first_month_capital,4),commaSplit(first_month_interest,4),commaSplit(first_month_kkdf + first_month_bsmv),0,document.getElementById('credit_no').value + ' nolu Kredi 1. Taksit',0,$('#expense_center_id_main').val(),$('#expense_item_id_main').val(),$('#expense_item_name_main').val(),$('#interest_account_id_main').val(),$('#interest_account_code_main').val(),$('#total_expense_item_id_main').val(),$('#total_expense_item_name_main').val(),$('#capital_expense_item_id_main').val(),$('#capital_expense_item_name_main').val(),$('#capital_account_id_main').val(),$('#capital_account_code_main').val(),$('#total_account_id_main').val(),$('#total_account_code_main').val());
												for(i=2;i<=calc_installment;i++) {
													var next_month_interest = remaining_capital * calc_monthly_interest_rate;
													var next_month_kkdf = next_month_interest * calc_kkdf;
													var next_month_bsmv = next_month_interest * calc_bsmv;
													var next_month_capital = taksit_tutari - (next_month_interest + next_month_kkdf + next_month_bsmv);
													
													var next_due_date = next_due_date.split("/");
													
													next_due_date[0] = parseInt(next_due_date[0]);
													next_due_date[1] = parseInt(next_due_date[1]) + 1;
													
													if(next_due_date[1] > 12) {
														next_due_date[2] = parseInt(next_due_date[2]) + Math.floor(next_due_date[1]/12);
														next_due_date[1] = next_due_date[1] % 12;
													}
													
													if([4,6,9,11].indexOf(next_due_date[1]) != -1 && next_due_date[0] == 31)
														next_due_date[0] = 30;
													else if(next_due_date[1] == 2 && next_due_date[2]%4 == 0 && next_due_date[0] > 29)
														next_due_date[0] = 29;
													else if(next_due_date[1] == 2 && next_due_date[2]%4 != 0 && next_due_date[0] > 28)
														next_due_date[0] = 28;
													
													if(next_due_date[0] < 10)
														next_due_date[0] = '0' + next_due_date[0];
													
													if(next_due_date[1] < 10)
														next_due_date[1] = '0' + next_due_date[1];
													
													this_due_date = next_due_date[0] + "/" + next_due_date[1] + "/" + next_due_date[2];
													
													next_due_date = document.getElementById('calc_first_due_date').value.split("/")[0] + "/" + next_due_date[1] + "/" + next_due_date[2];
													
													var remaining_capital = remaining_capital - next_month_capital;
													
													if(new Date(parseInt(this_due_date.split('/')[2], 10),parseInt(this_due_date.split('/')[1], 10) - 1,parseInt(this_due_date.split('/')[0], 10)) <= new Date(parseInt('<cfoutput>#dateformat(session.ep.period_finish_date,dateformat_style)#</cfoutput>'.split('/')[2], 10),parseInt('<cfoutput>#dateformat(session.ep.period_finish_date,dateformat_style)#</cfoutput>'.split('/')[1], 10) - 1,parseInt('<cfoutput>#dateformat(session.ep.period_finish_date,dateformat_style)#</cfoutput>'.split('/')[0], 10)))
														add_row(1,this_due_date,commaSplit(next_month_capital),commaSplit(next_month_interest),commaSplit(next_month_kkdf + next_month_bsmv),0,document.getElementById('credit_no').value + ' nolu Kredi ' + i + '. Taksit',0,$('#expense_center_id_main').val(),$('#expense_item_id_main').val(),$('#expense_item_name_main').val(),$('#interest_account_id_main').val(),$('#interest_account_code_main').val(),$('#total_expense_item_id_main').val(),$('#total_expense_item_name_main').val(),$('#capital_expense_item_id_main').val(),$('#capital_expense_item_name_main').val(),$('#capital_account_id_main').val(),$('#capital_account_code_main').val(),$('#total_account_id_main').val(),$('#total_account_code_main').val());
													else
														add_row(1,this_due_date,commaSplit(next_month_capital),commaSplit(next_month_interest),commaSplit(next_month_kkdf + next_month_bsmv),0,document.getElementById('credit_no').value + ' nolu Kredi ' + i + '. Taksit',0,$('#expense_center_id_next').val(),$('#expense_item_id_next').val(),$('#expense_item_name_next').val(),$('#interest_account_id_next').val(),$('#interest_account_code_next').val(),$('#total_expense_item_id_next').val(),$('#total_expense_item_name_next').val(),$('#capital_expense_item_id_next').val(),$('#capital_expense_item_name_next').val(),$('#capital_account_id_next').val(),$('#capital_account_code_next').val(),$('#total_account_id_next').val(),$('#total_account_code_next').val());
												}
												add_row(2,document.getElementById('credit_date').value,document.getElementById('calc_total_amount').value);
											}
										</script>
									</cf_grid_list>
								</cf_box_elements>
									<cf_box_footer>
										<input class="ui-wrk-btn ui-wrk-btn-success" name="calc_button" id="calc_button" type="button" value="<cf_get_lang dictionary_id='57348.Tahsilat ve Ödeme Planı Oluştur'>" onclick="calc_installment_plan()" />
									</cf_box_footer>
								</div>
							</div>
						</cf_box_elements>
						
						<cf_box_footer>
						
							<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
						</cf_box_footer>
					</cf_basket_form>  
					<div class="ui-row">
						<div class="col col-12">
							<cf_basket id="credit_contract_bask" height="350">
								<!---Ödemeler--->
								<cf_seperator title="#getLang('main','Ödemeler',58658)#" id="paymentsArea" height="350">
								<div id="paymentsArea" style="display:none;">
									<cf_grid_list>
										<thead>
											<tr>
												<th width="20"><cf_get_lang dictionary_id='57487.No'></th>
												<th width="20">
													<input type="hidden" name="payment_record_num" id="payment_record_num" value="0">
													<input type="hidden" name="payment_record_num2" id="payment_record_num2" value="0">
													<a onclick="add_row(1);"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='57707.Satır Ekle'>" alt="<cf_get_lang dictionary_id ='57707.Satır Ekle'>"></i></a>
												</th>
												<th id="credit1"><cf_get_lang dictionary_id='57742.Tarih'>*</th>
												<th id="credit2"><cf_get_lang dictionary_id='51344.Ana Para'> *</th>
												<th id="credit3"><cf_get_lang dictionary_id='51367.Faiz'></th>
												<th id="finance7" style="display:none;"><cf_get_lang dictionary_id ='51397.KDV siz Kira'></th>
												<th id="credit4"><cf_get_lang dictionary_id='51346.Vergi/Masraf'></th>
												<th id="finance8" style="display:none;"><cf_get_lang dictionary_id ='51398.KDV li Kira'></th>
												<th id="credit5"><cf_get_lang dictionary_id='57492.Toplam'></th>
												<th id="credit6"><cf_get_lang dictionary_id='57629.Açıklama'></th>
												<th><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th>
												<th id="finance3"><cf_get_lang dictionary_id="51355.Ana Para Gider Kalemi"></th>
												<th id="finance4"><cf_get_lang dictionary_id="51356.Ana Para Muhasebe Kodu"></th>
												<th><cf_get_lang dictionary_id ='51399.Faiz Gider Kalemi'> *</th>
												<th><cf_get_lang dictionary_id ='51400.Faiz Muhasebe Kodu'>*</th>
												<th id="baslik1"><cf_get_lang dictionary_id='51346.Vergi/Masraf'><cf_get_lang dictionary_id="58551.Gider Kalemi"></th>			
												<th id="baslik2"><cf_get_lang dictionary_id='51346.Vergi/Masraf'><cf_get_lang dictionary_id="58811.Muhasebe Kodu"></th>
												<th id="baslik3" style="display:none;"><cf_get_lang dictionary_id="57323.Finansal Kiralama Gider Kalemi">*</th>	
												<th id="baslik5" style="display:none;"><cf_get_lang dictionary_id='51396.Finansal Kiralama Muhasebe Kodu'>*</th>
												<th id="baslik6" style="display:none;"><cf_get_lang dictionary_id="30135.Leasing Borçlanma Maliyet Kodu">*</th>
												<th id="credittable">1</th>
											</tr>
										</thead>
										<tbody id="table1">
											<cfif isdefined("url.credit_contract_id") and len(url.credit_contract_id)>
												<cfoutput query="get_rows_1">
													<tr id="payment_frm_row#currentrow#">
														<td nowrap="nowrap">
															<input type="hidden" name="payment_row_kontrol#currentrow#" id="payment_row_kontrol#currentrow#" value="1">
															<a onclick="delete_row('#currentrow#',1);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>
															<a onclick="open_row_add(1,'#currentrow#');"><i class="icon-branch" title="<cf_get_lang dictionary_id='62455.Satır Çoğalt'>" alt="<cf_get_lang dictionary_id='62455.Satır Çoğalt'>"></i></a>
															<a onclick="copy_row(1,'#currentrow#');"><i class="fa fa-copy" title="<cf_get_lang dictionary_id='58972.Satır Kopyala'>" alt="<cf_get_lang dictionary_id='58972.Satır Kopyala'>"></i></a>
														</td>
														<td></td>
														<td>
															<div class="form-group">
																<div class="input-group">
																	<input type="hidden" name="payment_credit_contract_row_id#currentrow#" id="payment_credit_contract_row_id#currentrow#" value="#credit_contract_row_id#">
																	<input type="text" name="payment_date#currentrow#" id="payment_date#currentrow#" value="#dateformat(process_date,dateformat_style)#">
																	<span class="input-group-addon"><cf_wrk_date_image date_field="payment_date#currentrow#"></span>
																</div>
															</div>
														</td>
														<td><div class="form-group"><input type="text" name="payment_capital_price#currentrow#" id="payment_capital_price#currentrow#" maxlength="20" onchange="payment_capital_price_amount(#currentrow#);" value="#TlFormat(capital_price,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onblur="write_total_amount(1);" class="moneybox"></div></td>
														<td><div class="form-group"><input type="text" name="payment_interest_price#currentrow#" id="payment_interest_price#currentrow#" onchange="payment_interest_price_amount(#currentrow#);" value="#TlFormat(interest_price,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onblur="write_total_amount(1);" class="moneybox"></div></td>
														<td <cfif get_credit_contract.process_type neq 296>style="display:none;"</cfif>><input type="text" name="total_payment_price#currentrow#" id="total_payment_price#currentrow#" value="#TlFormat(interest_price+capital_price,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onblur="write_total_amount(1);" class="moneybox"></td>
														<td><div class="form-group"><input type="text" name="payment_tax_price#currentrow#" id="payment_tax_price#currentrow#" onchange="payment_tax_price_amount(#currentrow#);" value="#TlFormat(tax_price,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onblur="write_total_amount(1);" class="moneybox"></div></td>
														<td><div class="form-group"><input type="text" name="payment_total_price#currentrow#" id="payment_total_price#currentrow#" value="#TlFormat(total_price,session.ep.our_company_info.rate_round_num)#" readonly class="moneybox"></div></td>
														<td><div class="form-group"><input type="text" name="payment_detail#currentrow#" id="payment_detail#currentrow#" value="#detail#" maxlength="100"></div></td>
														<td>
															<div class="form-group">
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
															<td>
																<div class="form-group">
																	<div class="input-group">
																		<input type="hidden" name="capital_expense_item_id#currentrow#" id="capital_expense_item_id#currentrow#" value="#capital_expense_item_id#">
																		<input type="text" name="capital_expense_item_name#currentrow#" id="capital_expense_item_name#currentrow#"  value="<cfif len(capital_expense_item_id) and len(item_id_list)>#get_exp_detail.expense_item_name[listfind(item_id_list,capital_expense_item_id,',')]#</cfif>" class="text">
																		<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac_items('capital_expense_item_id','capital_expense_item_name','capital_account_id','capital_account_code','#currentrow#');"></span>
																	</div>
																</div>	
															</td>
															<td>
																<div class="form-group">
																	<div class="input-group">
																		<input type="hidden" name="capital_account_id#currentrow#" id="capital_account_id#currentrow#" value="<cfif len(capital_account_id)>#capital_account_id#</cfif>">
																		<input type="text" name="capital_account_code#currentrow#" id="capital_account_code#currentrow#" class="text" value="<cfif len(capital_account_id)>#capital_account_id#</cfif>">
																		<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac_acc('capital_account_id','capital_account_code','#currentrow#');"></span>
																	</div>
																</div>
															</td>
														</cfif>
														<td>
															<div class="form-group">
																<div class="input-group">
																	<input type="hidden" name="expense_item_id#currentrow#" id="expense_item_id#currentrow#" value="#expense_item_id#">
																	<input type="text" name="expense_item_name#currentrow#" id="expense_item_name#currentrow#"  value="<cfif len(expense_item_id) and len(item_id_list)>#get_exp_detail.expense_item_name[listfind(item_id_list,expense_item_id,',')]#</cfif>" onFocus="AutoComplete_Create('expense_item_name#currentrow#','EXPENSE_ITEM_NAME,ACCOUNT_CODE','EXPENSE_ITEM_NAME,ACCOUNT_CODE','GET_EXPENSE_ITEM','0','EXPENSE_ITEM_ID,EXPENSE_ITEM_NAME,ACCOUNT_CODE,ACCOUNT_CODE','expense_item_id#currentrow#,expense_item_name#currentrow#,interest_account_code#currentrow#,interest_account_id#currentrow#','add_credit_contract',1);" class="text">
																	<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac_items('expense_item_id','expense_item_name','interest_account_id','interest_account_code','#currentrow#');"></span>
																</div>
															</div>
														</td>
														<td>
															<div class="form-group">
																<div class="input-group">
																	<input type="hidden" name="interest_account_id#currentrow#" id="interest_account_id#currentrow#" value="<cfif len(interest_account_id)>#interest_account_id#</cfif>">
																	<input type="text" name="interest_account_code#currentrow#" id="interest_account_code#currentrow#" class="text" value="<cfif len(interest_account_id)>#interest_account_id#</cfif>">
																	<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac_acc('interest_account_id','interest_account_code','#currentrow#');"></span>
																</div>
															</div>
														</td>
														<td>
															<div class="form-group">
																<div class="input-group">
																	<input type="hidden" name="total_expense_item_id#currentrow#" id="total_expense_item_id#currentrow#" value="#total_expense_item_id#">
																	<input type="text" name="total_expense_item_name#currentrow#" id="total_expense_item_name#currentrow#" value="<cfif len(total_expense_item_id) and len(item_id_list)>#get_exp_detail.expense_item_name[listfind(item_id_list,total_expense_item_id,',')]#</cfif>" onFocus="AutoComplete_Create('total_expense_item_name#currentrow#','EXPENSE_ITEM_NAME,ACCOUNT_CODE','EXPENSE_ITEM_NAME,ACCOUNT_CODE','GET_EXPENSE_ITEM','0','EXPENSE_ITEM_ID,EXPENSE_ITEM_NAME,ACCOUNT_CODE,ACCOUNT_CODE','total_expense_item_id#currentrow#,total_expense_item_name#currentrow#,total_account_code#currentrow#,total_account_id#currentrow#','add_credit_contract',1);" class="text">
																	<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac_items('total_expense_item_id','total_expense_item_name','total_account_id','total_account_code','#currentrow#');"></span>
																</div>
															</div>
														</td>
														<td>
															<div class="form-group">
																<div class="input-group">
																	<input type="hidden" name="total_account_id#currentrow#" id="total_account_id#currentrow#" value="<cfif len(total_account_id)>#total_account_id#</cfif>">
																	<input type="text" name="total_account_code#currentrow#" id="total_account_code#currentrow#" class="text" value="<cfif len(total_account_id)>#total_account_id#</cfif>">
																	<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac_acc('total_account_id','total_account_code','#currentrow#');"></span>
																</div>
															</div>
														</td>
													<cfif get_credit_contract.process_type eq 296>
															<td>
																<div class="form-group">
																	<div class="input-group">
																		<input type="hidden" name="borrow_id#currentrow#" id="borrow_id#currentrow#" value="#BORROW#">
																		<input type="text" name="borrow_code#currentrow#" id="borrow_code#currentrow#" class="text" value="#BORROW#" onFocus="AutoComplete_Create('borrow_code#currentrow#','ACCOUNT_CODE,ACCOUNT_NAME','CODE_NAME','get_account_code','0','ACCOUNT_CODE,CODE_NAME','borrow_id#currentrow#,borrow_code#currentrow#','add_credit_contract',1);">
																		<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac_acc('borrow_id','borrow_code','#currentrow#');"></span>
																	</div>
																</div>
															</td>
														</cfif>
													</tr>
												</cfoutput>
											</cfif>
										</tbody>
										<tfoot id="table2" <cfif not isdefined ("url.credit_contract_id")>style="display:none"</cfif>>
											<tr>
											<td></td>
												<td colspan="2" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></td>
												<td class="text-right"><input name="payment_total_capital_price" id="payment_total_capital_price" value="<cfif not isdefined("url.credit_contract_id")><cfoutput>#TlFormat(0,session.ep.our_company_info.rate_round_num)#</cfoutput></cfif>" class="box" readonly></td>
												<td class="text-right"><input name="payment_total_interest_price" id="payment_total_interest_price" value="<cfif not isdefined("url.credit_contract_id")><cfoutput>#TlFormat(0,session.ep.our_company_info.rate_round_num)#</cfoutput></cfif>" class="box" readonly></td>
												<td class="text-right" id="finance9"><input name="payment_total_price_kdvsiz" id="payment_total_price_kdvsiz" value="<cfif not isdefined("url.credit_contract_id")><cfoutput>#TlFormat(0,session.ep.our_company_info.rate_round_num)#</cfoutput></cfif>" class="box" readonly></td>
												<td class="text-right"><input name="payment_total_tax_price" id="payment_total_tax_price" value="<cfif not isdefined("url.credit_contract_id")><cfoutput>#TlFormat(0,session.ep.our_company_info.rate_round_num)#</cfoutput></cfif>" class="box" readonly></td>
												<td class="text-right"><input name="payment_total_price" id="payment_total_price" value="<cfif not isdefined("url.credit_contract_id")><cfoutput>#TlFormat(0,session.ep.our_company_info.rate_round_num)#</cfoutput></cfif>" class="box" readonly></td>	
												<td colspan="13"></td>
											</tr>
										</tfoot>
									</cf_grid_list>
								</div>
								<!---Tahsilatlar--->
								<cf_seperator title="#getLang('credit','Tahsilatlar',30771)#" id="collectionsArea">
								<div id="collectionsArea" style="display:none">
									<cf_grid_list>
										<thead>
											<tr>
												<th width="20"><cf_get_lang dictionary_id='57487.No'></th>
												<th width="20">
													<input type="hidden" name="revenue_record_num" id="revenue_record_num" value="0">
													<a onclick="add_row(2);"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='57707.Satır Ekle'>" alt="<cf_get_lang dictionary_id ='57707.Satır Ekle'>"></i></a>
												</th>
												<th><cf_get_lang dictionary_id='57742.Tarih'>*</th>
												<th><cf_get_lang dictionary_id='51344.Ana Para'> </th>
												<th><cf_get_lang dictionary_id='51367.Faiz'></th>
												<th><cf_get_lang dictionary_id='51346.Vergi/Masraf'></th>
												<th><cf_get_lang dictionary_id='57492.Toplam'></th>
												<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
												<th id="finance5"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th>
												<th id="finance6"><cf_get_lang dictionary_id="51355.Ana Para Gider Kalemi"></th>
												<th id="finance10"><cf_get_lang dictionary_id="51356.Ana Para Muhasebe Kodu"></th>
												<th id="finance11"><cf_get_lang dictionary_id='51399.Faiz Gider Kalemi'></th>
												<th id="finance12"><cf_get_lang dictionary_id='51400.Faiz Muhasebe Kodu'></th>
												<th id="finance13"><cf_get_lang dictionary_id="51357.Vergi-Masraf Gider Kalemi"></th>			
												<th id="finance14"><cf_get_lang dictionary_id="51359.Vergi-Masraf Muhasebe Kodu"></th>	
											</tr>
										</thead>
										<tbody id="table3">
											<cfif isdefined("url.credit_contract_id") and len(url.credit_contract_id)>
												<cfoutput query="get_rows_2">
													<tr id="revenue_frm_row#currentrow#">
														<td nowrap="nowrap" class="text-right">
															<input type="hidden" name="revenue_row_kontrol#currentrow#" id="revenue_row_kontrol#currentrow#" value="1">
															<a onclick="delete_row('#currentrow#',2);"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>
															<a onclick="open_row_add(2,'#currentrow#');"><i class="icon-branch" title="<cf_get_lang dictionary_id='62455.Satır Çoğalt'>" alt="<cf_get_lang dictionary_id='62455.Satır Çoğalt'>"></i></a>
															<a onclick="copy_row(2,'#currentrow#');"><i class="fa fa-copy" title="<cf_get_lang dictionary_id='58972.Satır Kopyala'>" alt="<cf_get_lang dictionary_id='58972.Satır Kopyala'>"></i></a>
														</td>
														<td></td>
														<td>
															<div class="form-group">
																<div class="input-group">
																	<input type="hidden" name="revenue_credit_contract_row_id#currentrow#" id="revenue_credit_contract_row_id#currentrow#" value="#credit_contract_row_id#">
																	<input type="text" name="revenue_date#currentrow#" id="revenue_date#currentrow#" value="#dateformat(process_date,dateformat_style)#">
																	<span class="input-group-addon"><cf_wrk_date_image date_field="revenue_date#currentrow#"></span>
																</div>
															</div>
														</td>
														<td><div class="form-group"><input type="text" name="revenue_capital_price#currentrow#" id="revenue_capital_price#currentrow#" maxlength="20" value="#TlFormat(capital_price,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onblur="write_total_amount(2);" class="moneybox"></div></td>
														<td><div class="form-group"><input type="text" name="revenue_interest_price#currentrow#" id="revenue_interest_price#currentrow#" value="#TlFormat(interest_price,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onblur="write_total_amount(2);" class="moneybox"></div></td>
														<td><div class="form-group"><input type="text" name="revenue_tax_price#currentrow#" id="revenue_tax_price#currentrow#" value="#TlFormat(tax_price,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onblur="write_total_amount(2);" class="moneybox"></div></td>
														<td><div class="form-group"><input type="text" name="revenue_total_price#currentrow#" id="revenue_total_price#currentrow#" value="#TlFormat(total_price,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" class="moneybox" readonly></div></td>
														<td><div class="form-group"><input type="text" name="revenue_detail#currentrow#" id="revenue_detail#currentrow#" value="#detail#" maxlength="100"></div></td>
														<cfif get_credit_contract.process_type neq 296><!--- kredi sozlesmesi --->
															<td>
																<div class="form-group">
																	<select name="revenue_expense_center_id#currentrow#" id="revenue_expense_center_id#currentrow#" class="text">
																		<cfset deger_expense= expense_center_id>
																		<option value="">M. Merkezi</option>
																		<cfloop query="get_expense_center">
																			<option value="#expense_id#" <cfif deger_expense eq get_expense_center.expense_id>selected</cfif>>#expense#</option>
																		</cfloop>
																	</select>
																</div>
															</td>
															<td>
																<div class="form-group">
																	<div class="input-group">
																		<input type="hidden" name="revenue_capital_expense_item_id#currentrow#" id="revenue_capital_expense_item_id#currentrow#" value="#capital_expense_item_id#">
																		<input type="text" name="revenue_capital_expense_item_name#currentrow#" id="revenue_capital_expense_item_name#currentrow#"  value="<cfif len(capital_expense_item_id) and len(revenue_item_id_list)>#get_exp_detail_2.expense_item_name[listfind(revenue_item_id_list,capital_expense_item_id,',')]#</cfif>" class="text">
																		<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac_items('revenue_capital_expense_item_id','revenue_capital_expense_item_name','revenue_capital_account_id','revenue_capital_account_code','#currentrow#');"></span>
																	</div>
																</div>
															</td>
															<td>
																<div class="form-group">
																	<div class="input-group">
																		<input type="hidden" name="revenue_capital_account_id#currentrow#" id="revenue_capital_account_id#currentrow#" value="<cfif len(capital_account_id)>#capital_account_id#</cfif>">
																		<input type="text" name="revenue_capital_account_code#currentrow#" id="revenue_capital_account_code#currentrow#" class="text" value="<cfif len(capital_account_id)>#capital_account_id#</cfif>">
																		<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac_acc('revenue_capital_account_id','revenue_capital_account_code','#currentrow#');"></span>
																	</div>
																</div>
															</td>
															<td>
																<div class="form-group">
																	<div class="input-group">
																		<input type="hidden" name="revenue_expense_item_id#currentrow#" id="revenue_expense_item_id#currentrow#" value="#expense_item_id#">
																		<input type="text" name="revenue_expense_item_name#currentrow#" id="revenue_expense_item_name#currentrow#"  value="<cfif len(expense_item_id) and len(revenue_item_id_list)>#get_exp_detail_2.expense_item_name[listfind(revenue_item_id_list,expense_item_id,',')]#</cfif>" class="text">
																		<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac_items('revenue_expense_item_id','revenue_expense_item_name','revenue_interest_account_id','revenue_interest_account_code','#currentrow#');"></span>
																	</div>
																</div>
															</td>
															<td>
																<div class="form-group">
																	<div class="input-group">
																		<input type="hidden" name="revenue_interest_account_id#currentrow#" id="revenue_interest_account_id#currentrow#" value="<cfif len(interest_account_id)>#interest_account_id#</cfif>">
																		<input type="text" name="revenue_interest_account_code#currentrow#" id="revenue_interest_account_code#currentrow#" class="text" value="<cfif len(interest_account_id)>#interest_account_id#</cfif>">
																		<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac_acc('revenue_interest_account_id','revenue_interest_account_code','#currentrow#');"></span>
																	</div>
																</div>
															</td>
															<td>
																<div class="form-group">
																	<div class="input-group">
																		<input type="hidden" name="revenue_total_expense_item_id#currentrow#" id="revenue_total_expense_item_id#currentrow#" value="#total_expense_item_id#">
																		<input type="text" name="revenue_total_expense_item_name#currentrow#" id="revenue_total_expense_item_name#currentrow#" value="<cfif len(total_expense_item_id) and len(revenue_item_id_list)>#get_exp_detail_2.expense_item_name[listfind(revenue_item_id_list,total_expense_item_id,',')]#</cfif>" class="text">
																		<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac_items('revenue_total_expense_item_id','revenue_total_expense_item_name','revenue_total_account_id','revenue_total_account_code','#currentrow#');"></span>
																	</div>
																</div>
															</td>
															<td>
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
											</cfif>
										</tbody>
										<tfoot id="table4" <cfif not isdefined ("url.credit_contract_id")>style="display:none"</cfif>>
											<tr>
											<td></td>
												<td colspan="2" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></td>
												<td class="text-right"><input name="revenue_total_capital_price" id="revenue_total_capital_price" value="<cfif not isdefined("url.credit_contract_id")><cfoutput>#TlFormat(0,session.ep.our_company_info.rate_round_num)#</cfoutput></cfif>" class="box" readonly></td>
												<td class="text-right"><input name="revenue_total_interest_price" id="revenue_total_interest_price" value="<cfif not isdefined("url.credit_contract_id")><cfoutput>#TlFormat(0,session.ep.our_company_info.rate_round_num)#</cfoutput></cfif>" class="box" readonly></td>
												<td class="text-right"><input name="revenue_total_tax_price" id="revenue_total_tax_price" value="<cfif not isdefined("url.credit_contract_id")><cfoutput>#TlFormat(0,session.ep.our_company_info.rate_round_num)#</cfoutput></cfif>" class="box" readonly ></td>
												<td class="text-right"><input name="revenue_total_price" id="revenue_total_price" value="<cfif not isdefined("url.credit_contract_id")><cfoutput>#TlFormat(0,session.ep.our_company_info.rate_round_num)#</cfoutput></cfif>" class="box" readonly></td>	
												<td colspan="8"></td>
											</tr>
										</tfoot>
									</cf_grid_list>
								</div>
								<cf_basket_footer height="95">
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
														<cfoutput>
															<cfset selected_money=session.ep.money>
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
																		<div class="form-group">
																			<input type="radio" name="rd_money" id="rd_money" value="#money#,#currentrow#,#rate1#,#rate2#" onclick="f_kur_hesapla_multi();" <cfif selected_money eq money>checked</cfif>>#money#
																		</div>
																	</td>
																	<td>
																	<td>
																		<div class="form-group">
																			#TLFormat(rate1,0)#/
																		</div>
																	</td>
																	<td>
																		<div class="form-group">
																			<input type="text" <cfif readonly_info>readonly</cfif> class="box" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" <cfif money eq session.ep.money>readonly="yes"</cfif> value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onblur="f_kur_hesapla_multi();">
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
															<td height="20" class="txtbold"><cf_get_lang dictionary_id='51363.Tahsilat Toplam'></td>
															<td class="text-right"><div class="form-group"><input type="text" name="total_revenue" id="total_revenue" class="box" readonly="" value="<cfoutput>#TlFormat(0,session.ep.our_company_info.rate_round_num)#</cfoutput>"></div></td>
															<td width="55"><div class="form-group"><input type="text" name="money_info_rev" id="money_info_rev" value="" class="box" readonly=""></div></td>
														</tr>
														<tr>
															<td class="txtbold"><cf_get_lang dictionary_id='51364.Ödeme Toplam'></td>
															<td class="text-right"><div class="form-group"><input type="text" name="total_payment" id="total_payment" class="box" readonly="" value="<cfoutput>#TlFormat(0,session.ep.our_company_info.rate_round_num)#</cfoutput>"></div></td>
															<td width="55"><div class="form-group"><input type="text" name="money_info_pay" id="money_info_pay" value="" class="box" readonly=""></div></td>
														</tr>
														<tr>
															<td class="txtbold"><cfoutput>#session.ep.money#</cfoutput><cf_get_lang dictionary_id='51363.Tahsilat Toplam'></td>
															<td id="rate_value1" class="text-right">
																<div class="form-group"><input type="text" name="other_total_revenue" id="other_total_revenue" class="box" readonly="" value="<cfoutput>#TlFormat(0,session.ep.our_company_info.rate_round_num)#</cfoutput>"></div>
															</td>
														</tr>
														<tr>
															<td class="txtbold"><cfoutput>#session.ep.money#</cfoutput> <cf_get_lang dictionary_id='51364.Ödeme Toplam'></td>
															<td id="rate_value2" class="text-right">
																<div class="form-group"><input type="text" name="other_total_payment" id="other_total_payment" class="box" readonly="" value="<cfoutput>#TlFormat(0,session.ep.our_company_info.rate_round_num)#</cfoutput>"></div>
															</td>
														</tr>  
													</table>
												</div>
											</div>
										</div>
									</div>
								</cf_basket_footer>
							</cf_basket>
						</div>
					</div>
				</div>
		</cfform>
	</cf_box>
</div>
<div id="add_multi_row" style="position:absolute; margin-top:-400px; margin-left:50px; z-index:99;"></div>
<script type="text/javascript">
	<cfif isdefined("url.credit_contract_id") and len(url.credit_contract_id)>
		payment_row_count=<cfoutput>#get_rows_1.recordcount#</cfoutput>;
		revenue_row_count=<cfoutput>#get_rows_2.recordcount#</cfoutput>;
		payment_kontrol_row_count=<cfoutput>#get_rows_1.recordcount#</cfoutput>;
		revenue_kontrol_row_count=<cfoutput>#get_rows_2.recordcount#</cfoutput>;
		document.getElementById("payment_record_num").value = payment_row_count;
		document.getElementById("payment_record_num2").value = payment_row_count;
		document.getElementById("revenue_record_num").value = revenue_row_count;
	<cfelse>
		payment_row_count=0;
		revenue_row_count=0;
		payment_kontrol_row_count=0;
		revenue_kontrol_row_count=0;
	</cfif>
	write_total_amount(1);
	write_total_amount(2);
	function pencere_ac_date(no,type)
	{
		if(type == 1)
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_calender&alan=add_credit_contract.payment_date' + no ,'date');
		else
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_calender&alan=add_credit_contract.revenue_date' + no ,'date');
	}
	function add_row(type,payment_date,payment_capital_price,payment_interest_price,payment_tax_price,payment_total_price,payment_detail,total_payment_price,expense_center_id,expense_item_id,expense_item_name,interest_account_id,interest_account_code,total_expense_item_id,total_expense_item_name,capital_expense_item_id,capital_expense_item_name,capital_account_id,capital_account_code,total_account_id,total_account_code,borrow_id,borrow_code)
	{

		
		//Normal rken değişkenler olmadığı için boşluk atıyor,kopyalarken değişkenler geliyor
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
		if (total_account_id == undefined)total_account_id ="";
		if (total_account_code == undefined)total_account_code ="";
		if (borrow_id == undefined)borrow_id ="";
		if (borrow_code == undefined)borrow_code ="";
		if (capital_expense_item_id == undefined)capital_expense_item_id ="";
		if (capital_expense_item_name == undefined)capital_expense_item_name ="";
		if (capital_account_id == undefined)capital_account_id ="";
		if (capital_account_code == undefined)capital_account_code ="";
		/* odeme */
		if(type == 1)
		{
			
			var selected_ptype = document.getElementById("process_cat").options[document.getElementById('process_cat').selectedIndex].value;
			if(selected_ptype != '')
			{
				eval('var proc_control = document.add_credit_contract.ct_process_type_'+selected_ptype+'.value');
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
				document.getElementById("payment_record_num").value=payment_row_count;
				document.getElementById('payment_record_num2').value=payment_row_count;
				
				document.getElementById('rowCount').value = parseInt(document.getElementById('rowCount').value) + 1;
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				newCell.innerHTML =document.getElementById('rowCount').value;
				
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				newCell.innerHTML =  ' <input  type="hidden" name="payment_row_kontrol' + payment_row_count +'" id="payment_row_kontrol' + payment_row_count +'" value="1"><ul class="ui-icon-list"><li><a onclick="delete_row(' + payment_row_count + ',1);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></li><li><a onclick="open_row_add(1,' + payment_row_count + ');"><i class="icon-branch" title="<cf_get_lang dictionary_id='62455.Satır Çoğalt'>" alt="<cf_get_lang dictionary_id='62455.Satır Çoğalt'>"></i></a></li><li><a onclick="copy_row(1,' + payment_row_count + ');"><i class="fa fa-copy" title="<cf_get_lang dictionary_id='58972.Satır Kopyala'>" alt="<cf_get_lang dictionary_id='58972.Satır Kopyala'>"></i></a></li></ul>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				newCell.setAttribute("id","payment_date" + payment_row_count + "_td");
				newCell.innerHTML = '<input type="hidden" name="payment_credit_contract_row_id' + payment_row_count +'" id="payment_credit_contract_row_id' + payment_row_count +'" value=""><input type="text" name="payment_date' + payment_row_count +'" id="payment_date' + payment_row_count +'" class="text" maxlength="20" value="' + payment_date + '"> ';
				wrk_date_image('payment_date' + payment_row_count);
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="payment_capital_price' + payment_row_count +'" id="payment_capital_price' + payment_row_count +'" maxlength="20" onchange="payment_capital_price_amount('+payment_row_count+');" value="'+payment_capital_price+'" value="" onKeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" onblur="write_total_amount(1);" class="moneybox"></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="payment_interest_price' + payment_row_count +'" id="payment_interest_price' + payment_row_count +'" onchange="payment_interest_price_amount('+payment_row_count+');" value="'+payment_interest_price+'" onKeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" onblur="write_total_amount(1);" class="moneybox"></div>';
				if(proc_control == 296)
				{
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<div class="form-group"><input type="text" name="total_payment_price' + payment_row_count +'" id="total_payment_price' + payment_row_count +'" value="'+total_payment_price+'" readonly class="moneybox"></div>';
				}
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="payment_tax_price' + payment_row_count +'" id="payment_tax_price' + payment_row_count +'" onchange="payment_tax_price_amount('+payment_row_count+');" value="'+payment_tax_price+'" onKeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" onblur="write_total_amount(1);" class="moneybox"></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				newCell.innerHTML = '<div class="form-group"><input type="text" name="payment_total_price' + payment_row_count +'" id="payment_total_price' + payment_row_count +'" value="'+payment_total_price+'" class="moneybox" readonly></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="payment_detail' + payment_row_count +'" id="payment_detail' + payment_row_count +'" value="'+payment_detail+'" maxlength="100"></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				a = '<select name="expense_center_id' + payment_row_count  +'" id="expense_center_id' + payment_row_count  +'" class="text"><option value="">M. Merkezi</option>';
				<cfoutput query="get_expense_center">
				if('#expense_id#' == expense_center_id)
					a += '<option value="#expense_id#" selected>#expense#</option>';
				else
					a += '<option value="#expense_id#">#expense#</option>';
				</cfoutput>
				newCell.innerHTML =a+ '</select>';
				if(proc_control != 296)
				{
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute('nowrap','nowrap');
					newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden" name="capital_expense_item_id' + payment_row_count +'" id="capital_expense_item_id' + payment_row_count +'" value="'+capital_expense_item_id+'"><input type="text" name="capital_expense_item_name' + payment_row_count +'" id="capital_expense_item_name' + payment_row_count +'" readonly="yes" value="'+capital_expense_item_name+'" class="text"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_items(\'capital_expense_item_id\',\'capital_expense_item_name\',\'capital_account_id\',\'capital_account_code\',\''+payment_row_count+'\')"></span></div></div>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute('nowrap','nowrap');
					newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden" name="capital_account_id' + payment_row_count +'" id="capital_account_id' + payment_row_count +'" value="'+capital_account_id+'"><input type="text" value="'+capital_account_code+'"  name="capital_account_code' + payment_row_count +'" id="capital_account_code' + payment_row_count +'" class="text"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_acc(\'capital_account_id\',\'capital_account_code\',\''+payment_row_count+'\')"></span></div></div>';
				}
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden" name="expense_item_id' + payment_row_count +'" id="expense_item_id' + payment_row_count +'" value="'+expense_item_id+'"><input type="text" onFocus="AutoComplete_Create(\'expense_item_name' + payment_row_count +'\',\'EXPENSE_ITEM_NAME,ACCOUNT_CODE\',\'EXPENSE_ITEM_NAME,ACCOUNT_CODE\',\'GET_EXPENSE_ITEM\',\'0\',\'EXPENSE_ITEM_ID,EXPENSE_ITEM_NAME,ACCOUNT_CODE,ACCOUNT_CODE\',\'expense_item_id' + payment_row_count +','+'expense_item_name'+payment_row_count+','+'interest_account_code'+payment_row_count+','+'interest_account_id'+payment_row_count+'\',\'add_credit_contract\',1);" value="'+expense_item_name+'" name="expense_item_name' + payment_row_count +'" id="expense_item_name' + payment_row_count +'" class="text"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_items(\'expense_item_id\',\'expense_item_name\',\'interest_account_id\',\'interest_account_code\',\''+payment_row_count+'\')" id="expense_item_name2' + payment_row_count +'"></span></div></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden" name="interest_account_id' + payment_row_count +'" id="interest_account_id' + payment_row_count +'" value="'+interest_account_id+'"><input type="text" value="'+interest_account_code+'"  name="interest_account_code' + payment_row_count +'"  id="interest_account_code' + payment_row_count +'" class="text"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_acc(\'interest_account_id\',\'interest_account_code\',\''+payment_row_count+'\')"></span></div></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden" name="total_expense_item_id' + payment_row_count +'" id="total_expense_item_id' + payment_row_count +'" value="'+total_expense_item_id+'"><input type="text" name="total_expense_item_name' + payment_row_count +'" onFocus="AutoComplete_Create(\'total_expense_item_name' + payment_row_count +'\',\'EXPENSE_ITEM_NAME,ACCOUNT_CODE\',\'EXPENSE_ITEM_NAME,ACCOUNT_CODE\',\'GET_EXPENSE_ITEM\',\'0\',\'EXPENSE_ITEM_ID,EXPENSE_ITEM_NAME,ACCOUNT_CODE,ACCOUNT_CODE\',\'total_expense_item_id' + payment_row_count +','+'total_expense_item_name'+payment_row_count+','+'total_account_code'+payment_row_count+','+'total_account_id'+payment_row_count+'\',\'add_credit_contract\',1);" id="total_expense_item_name' + payment_row_count +'" value="'+total_expense_item_name+'" class="text"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_items(\'total_expense_item_id\',\'total_expense_item_name\',\'total_account_id\',\'total_account_code\',\''+payment_row_count+'\')" id="expense_item_name2' + payment_row_count +'"></span></div></div>';
				
				
				newCell = newRow.insertCell(newRow.cells.length);
						newCell.setAttribute('nowrap','nowrap');
						newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden" name="total_account_id' + payment_row_count +'" id="total_account_id' + payment_row_count +'" value="'+total_account_id+'"><input type="text" value="'+total_account_code+'"  name="total_account_code' + payment_row_count +'" id="total_account_code' + payment_row_count +'" class="text"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_acc(\'total_account_id\',\'total_account_code\',\''+payment_row_count+'\')"></span></div></div>';
				if(proc_control == 296){
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute('nowrap','nowrap');
					newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden" name="borrow_id' + payment_row_count +'" id="borrow_id' + payment_row_count +'" value="'+borrow_id+'"><input type="text" value="'+borrow_code+'"  name="borrow_code' + payment_row_count +'" onFocus="AutoComplete_Create(\'borrow_code' + payment_row_count +'\',\'ACCOUNT_CODE,ACCOUNT_NAME\',\'CODE_NAME\',\'get_account_code\',\'0\',\'ACCOUNT_CODE,CODE_NAME\',\'borrow_id' + payment_row_count +','+'borrow_code'+payment_row_count+'\',\'add_credit_contract\',1);" id="borrow_code' + payment_row_count +'" class="text"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_acc(\'borrow_id\',\'borrow_code\',\''+payment_row_count+'\')"></span></div></div>';
				}
				write_total_amount(1);
			}
		
				
		}
		else /* tahsilat */
		{
			
			var selected_ptype = document.getElementById("process_cat").options[document.getElementById('process_cat').selectedIndex].value;
			if(selected_ptype != '')
			{
				eval('var proc_control = document.add_credit_contract.ct_process_type_'+selected_ptype+'.value');
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
				newCell.innerHTML =document.getElementById('rowCount_2').value;
				
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				//document.getElementById('rowCount_2').value = parseInt(document.getElementById('rowCount_2').value) + 1;
				newCell.innerHTML ='<input  type="hidden" name="revenue_row_kontrol' + revenue_row_count +'" id="revenue_row_kontrol' + revenue_row_count +'" value="1"><ul class="ui-icon-list"><li><a onclick="delete_row(' + revenue_row_count + ',2);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></li><li><a onclick="open_row_add(2,' + revenue_row_count + ');"><i class="icon-branch" title="<cf_get_lang dictionary_id='62455.Satır Çoğalt'>" alt="<cf_get_lang dictionary_id='62455.Satır Çoğalt'>"></i></a></li><li><a onclick="copy_row(2,' + revenue_row_count + ');"><i class="fa fa-copy" title="<cf_get_lang dictionary_id='58972.Satır Kopyala'>" alt="<cf_get_lang dictionary_id='58972.Satır Kopyala'>"></i></a></li></ul>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				newCell.setAttribute("id","revenue_date" + revenue_row_count + "_td");
				newCell.innerHTML = '<input type="hidden" name="revenue_credit_contract_row_id' + revenue_row_count +'" id="revenue_credit_contract_row_id' + revenue_row_count +'" value=""><input type="hidden" name="payment_credit_contract_row_id' + revenue_row_count +'" id="payment_credit_contract_row_id' + revenue_row_count +'" value=""><input type="text" name="revenue_date' + revenue_row_count +'" id="revenue_date' + revenue_row_count +'" class="text" maxlength="10" value="' + payment_date + '">';
				wrk_date_image('revenue_date' + revenue_row_count);
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML ='<div class="form-group"><input type="text" name="revenue_capital_price' + revenue_row_count +'" id="revenue_capital_price' + revenue_row_count +'" maxlength="20" value="'+payment_capital_price+'" onKeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" onblur="write_total_amount(2);" class="moneybox"></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML ='<div class="form-group"><input type="text" name="revenue_interest_price' + revenue_row_count +'" id="revenue_interest_price' + revenue_row_count +'"  value="'+payment_interest_price+'" onKeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" onblur="write_total_amount(2);" class="moneybox"></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML ='<div class="form-group"><input type="text" name="revenue_tax_price' + revenue_row_count +'" id="revenue_tax_price' + revenue_row_count +'" value="'+payment_tax_price+'" onKeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" onblur="write_total_amount(2);" class="moneybox"></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML ='<div class="form-group"><input type="text" name="revenue_total_price' + revenue_row_count +'" id="revenue_total_price' + revenue_row_count +'"  value="'+payment_total_price+'" class="moneybox" readonly></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="revenue_detail' + revenue_row_count +'" id="revenue_detail' + revenue_row_count +'"  value="'+payment_detail+'"  maxlength="100"></div>';
				if(proc_control != 296)
				{
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					a = '<select name="revenue_expense_center_id' + revenue_row_count  +'" id="revenue_expense_center_id' + revenue_row_count  +'" class="text"><option value="">M. Merkezi</option>';
					<cfoutput query="get_expense_center">
					if('#expense_id#' == expense_center_id)
						a += '<option value="#expense_id#" selected>#expense#</option>';
					else
						a += '<option value="#expense_id#">#expense#</option>';
					</cfoutput>
					newCell.innerHTML =a+ '</select>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input  type="hidden" name="revenue_capital_expense_item_id' + revenue_row_count +'" id="revenue_capital_expense_item_id' + revenue_row_count +'" value="'+capital_expense_item_id+'"><div class="form-group"><div class="input-group"><input type="text" name="revenue_capital_expense_item_name' + revenue_row_count +'" id="revenue_capital_expense_item_name' + revenue_row_count +'" readonly="yes" value="'+capital_expense_item_name+'" class="text"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_items(\'revenue_capital_expense_item_id\',\'revenue_capital_expense_item_name\',\'revenue_capital_account_id\',\'revenue_capital_account_code\',\''+revenue_row_count+'\')"></span></div></div>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input  type="hidden" name="revenue_capital_account_id' + revenue_row_count +'" id="revenue_capital_account_id' + revenue_row_count +'" value="'+capital_account_id+'"><div class="form-group"><div class="input-group"><input type="text" value="'+capital_account_code+'" name="revenue_capital_account_code' + revenue_row_count +'" id="revenue_capital_account_code' + revenue_row_count +'" class="text"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_acc(\'revenue_capital_account_id\',\'revenue_capital_account_code\',\''+revenue_row_count+'\')"></span></div></div>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input  type="hidden" name="revenue_expense_item_id' + revenue_row_count +'" id="revenue_expense_item_id' + revenue_row_count +'" value="'+expense_item_id+'"><div class="form-group"><div class="input-group"><input type="text" readonly="yes" name="revenue_expense_item_name' + revenue_row_count +'" id="revenue_expense_item_name' + revenue_row_count +'" value="'+expense_item_name+'" class="text"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_items(\'revenue_expense_item_id\',\'revenue_expense_item_name\',\'revenue_interest_account_id\',\'revenue_interest_account_code\',\''+revenue_row_count+'\')" id="expense_item_name2' + revenue_row_count +'"></span></div></div>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input  type="hidden" name="revenue_interest_account_id' + revenue_row_count +'" id="revenue_interest_account_id' + revenue_row_count +'" value="'+interest_account_id+'"><div class="form-group"><div class="input-group"><input type="text" value="'+interest_account_code+'" name="revenue_interest_account_code' + revenue_row_count +'" id="revenue_interest_account_code' + revenue_row_count +'" class="text"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_acc(\'revenue_interest_account_id\',\'revenue_interest_account_code\',\''+revenue_row_count+'\')"></span></div></div>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input  type="hidden" name="revenue_total_expense_item_id' + revenue_row_count +'" id="revenue_total_expense_item_id' + revenue_row_count +'" value="'+total_expense_item_id+'"><div class="form-group"><div class="input-group"><input type="text" name="revenue_total_expense_item_name' + revenue_row_count +'" id="revenue_total_expense_item_name' + revenue_row_count +'" readonly="yes" value="'+total_expense_item_name+'" class="text"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_items(\'revenue_total_expense_item_id\',\'revenue_total_expense_item_name\',\'revenue_total_account_id\',\'revenue_total_account_code\',\''+revenue_row_count+'\')" id="expense_item_name2' + revenue_row_count +'"></span></div></div>';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input  type="hidden" name="revenue_total_account_id' + revenue_row_count +'" id="revenue_total_account_id' + revenue_row_count +'" value="'+total_account_id+'"><div class="form-group"><div class="input-group"><input type="text" value="'+total_account_code+'" name="revenue_total_account_code' + revenue_row_count +'" id="revenue_total_account_code' + revenue_row_count +'" class="text"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_acc(\'revenue_total_account_id\',\'revenue_total_account_code\',\''+revenue_row_count+'\')"></span></div></div>';
				}
				write_total_amount(2);
			}
			
		}
	}
	function copy_row(type,no)
	{
		var selected_ptype = document.getElementById('process_cat').options[document.getElementById('process_cat').selectedIndex].value;
		eval('var proc_control = document.add_credit_contract.ct_process_type_'+selected_ptype+'.value');
		
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
			
			if(proc_control == 296)
			{
				total_payment_price = document.getElementById('total_payment_price' + no).value;				
				capital_expense_item_id = '';
				capital_expense_item_name = '';
				capital_account_id = '';
				capital_account_code = '';
				total_account_id = document.getElementById('total_account_id' + no).value;
				total_account_code = document.getElementById('total_account_code' + no).value;
				borrow_id = document.getElementById('borrow_id' + no).value;
				borrow_code = document.getElementById('borrow_code' + no).value;
			}
			else
			{	
				total_payment_price = '';
				capital_expense_item_id = document.getElementById('capital_expense_item_id' + no).value;
				capital_expense_item_name = document.getElementById('capital_expense_item_name' + no).value;
				capital_account_id = document.getElementById('capital_account_id' + no).value;
				capital_account_code = document.getElementById('capital_account_code' + no).value;
				total_account_id = document.getElementById('total_account_id' + no).value;
				total_account_code = document.getElementById('total_account_code' + no).value;
				borrow_id = '';
				borrow_code = '';
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
				capital_expense_item_id = '';
				capital_expense_item_name = '';
				capital_account_id = '';
				capital_account_code = '';
				total_account_id = '';
				total_account_code = '';
				borrow_id = '';
				borrow_code = '';
			}
		}
		add_row(type,payment_date,payment_capital_price,payment_interest_price,payment_tax_price,payment_total_price,payment_detail,total_payment_price,expense_center_id,expense_item_id,expense_item_name,interest_account_id,interest_account_code,total_expense_item_id,total_expense_item_name,capital_expense_item_id,capital_expense_item_name,capital_account_id,capital_account_code,total_account_id,total_account_code,borrow_id,borrow_code);
	}
	function delete_row(sy,type)
	{
		
		if(type == 1)
		{
			document.getElementById('rowCount').value  = parseInt(document.getElementById('rowCount').value) - 1;
			document.getElementById('payment_record_num2').value--;		
			var my_element=eval("add_credit_contract.payment_row_kontrol"+sy);
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
			document.getElementById('rowCount_2').value  = parseInt(document.getElementById('rowCount_2').value) - 1;
			var my_element=eval("add_credit_contract.revenue_row_kontrol"+sy);
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
	function kontrol()
	{
		if(add_credit_contract.credit_no != "")
		{
			if(!paper_control(add_credit_contract.credit_no,'CREDIT','1','','','','','','<cfoutput>#dsn3#</cfoutput>')) return false;
		}
		if(add_credit_contract.credit_no.value == "")
		{
			alert('<cf_get_lang dictionary_id='40958.Belge Numarası Boş Bırakılamaz!'> : <cf_get_lang dictionary_id='59178.Kredi No'>');
			return false;
		}
		if(add_credit_contract.process_cat.value == ""){
			alert("<cf_get_lang dictionary_id ='51403.Önce İşlem Tipi Seçmelisiniz'> !");
		}
		if (!chk_process_cat('add_credit_contract')) return false;
		var get_process_cat_account = wrk_safe_query('crd_get_process_cat','dsn3',0,document.getElementById('process_cat').value);

		if(get_process_cat_account.IS_ACCOUNT == 1 && document.getElementById('credit_date').value != "")
			if(!chk_period(add_credit_contract.credit_date,"İşlem")) return false;
			
		if(get_process_cat_account.IS_ACCOUNT == 1)
		{
			if(document.getElementById('company_id').value == '' || document.getElementById('company').value == '')
			{
				alert("<cf_get_lang dictionary_id='51348.Lütfen Kredi Kurumu Seçiniz'>! ");
				return false;
			}	
		}
		if(!check_display_files('add_credit_contract')) return false;
		<cfif is_same_limit_currency eq 1>
			if(document.getElementById('credit_limit_id').value != '')
			{
				var get_credit_all = wrk_safe_query('crd_get_crd_all','dsn3',0,document.getElementById('credit_limit_id').value);
				for(var i=1;i<=<cfoutput>#get_money.recordcount#</cfoutput>;i++)
				{
					if(eval('add_credit_contract.rd_money['+(i-1)+'].checked'))
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
		eval('var proc_control = document.add_credit_contract.ct_process_type_'+selected_ptype+'.value');
		
		
		// Satir kontrolleri odeme
		for(r=1;r<=add_credit_contract.payment_record_num.value;r++)
		{   
			
			deger_row_kontrol = document.getElementById("payment_row_kontrol"+r);
			deger_date = document.getElementById("payment_date"+r);
			deger_capital_price = document.getElementById("payment_capital_price"+r);
			deger_expense = document.getElementById("expense_item_name"+r);
			deger_total_expense = document.getElementById("total_expense_item_name"+r);
			deger_interest_account_code = document.getElementById("interest_account_code"+r);
			deger_interest_value = document.getElementById("payment_interest_price"+r).value;
			deger_total_account_code = document.getElementById("total_account_code"+r);
			deger_action_account = document.getElementById("total_account_code"+r);
			if(proc_control == 296) {
			deger_borrow_code = document.getElementById("borrow_code"+r);
			}
			if(deger_row_kontrol.value == 1)
			{
				if(deger_date.value == "")
				{
					alert("<cf_get_lang dictionary_id='51372.Lütfen Ödeme Tarihi Giriniz'> ! ");
					return false;
				}
				if(deger_capital_price.value == "")
				{
					alert("<cf_get_lang dictionary_id='51352.Ana Para Tutarı Giriniz'> ! ");
					return false;
				}
				if(deger_expense.value=='')
				{
					alert("<cf_get_lang dictionary_id ='51384.Lütfen Faiz Gider Kalemi Seçiniz'> !");
					return false;
				}
				if( deger_interest_account_code.value=='')
				{
					alert("<cf_get_lang dictionary_id ='51405.Lütfen Faiz Muhasebe Kodu Seçiniz'> !");
					return false;
				}
				if(proc_control == 296)
				{
								
					
					
					if(deger_total_expense.value == '')
					{
						alert("<cf_get_lang dictionary_id ='51406.Lütfen Kira Gider Kalemi Seçiniz '>!");
						return false;
					}
					
					if(deger_action_account.value == "")
					{
						alert("<cf_get_lang dictionary_id='62454.Lütfen Finansal Kiralama Muhasebe Kodu Giriniz'> ! ");
						return false;
					}
				
					if(deger_borrow_code.value == "")
					{
						alert("<cf_get_lang dictionary_id='54538.Lütfen Borçlanma Maliyet Kodu Giriniz'> ! ");
						return false;
					}
					
					if(deger_interest_value == '')
					{
						document.getElementById("payment_interest_price"+r).value=commaSplit(0,'4');
						return false;
					}
				
					
				}
			}
		}
		// Satir kontrolleri tahsilat
		for(k=1;k<=add_credit_contract.revenue_record_num.value;k++)
		{
			deger_row_kontrol = document.getElementById("revenue_row_kontrol"+k);
			deger_date = document.getElementById("revenue_date"+k);
			deger_capital_price = document.getElementById("revenue_capital_price"+k);
			if(deger_row_kontrol.value == 1)
			{
				if(deger_date.value == "")
				{
					alert("<cf_get_lang dictionary_id='51366.Lütfen Tahsilat Tarihi Giriniz'>!");
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

			for (var i=1; i <= add_credit_contract.payment_record_num.value; i++)
			{
				var payment_row_total_price = 0;
				deger_row_kontrol = document.getElementById("payment_row_kontrol"+i);
				if(deger_row_kontrol.value == 1)
				{
					if(type2 == undefined)
					{
						payment_total_capital_price += parseFloat(filterNum(document.getElementById('payment_capital_price'+i).value),4);
						payment_total_interest_price += parseFloat(filterNum(document.getElementById('payment_interest_price'+i).value,4));
						payment_total_tax_price += parseFloat(filterNum(document.getElementById('payment_tax_price'+i).value,4));
						if(document.getElementById('payment_capital_price'+i).value != "") payment_row_total_price += parseFloat(filterNum(document.getElementById('payment_capital_price'+i).value,4));
						if(document.getElementById('payment_interest_price'+i).value != "") payment_row_total_price += parseFloat(filterNum(document.getElementById('payment_interest_price'+i).value,4));
						if(document.getElementById("total_payment_price"+i) != undefined)
							document.getElementById("total_payment_price"+i).value = commaSplit(payment_row_total_price,4);
						if(document.getElementById('payment_tax_price'+i).value != "") payment_row_total_price += parseFloat(filterNum(document.getElementById('payment_tax_price'+i).value,4));
						document.getElementById("payment_total_price"+i).value = commaSplit(payment_row_total_price,4);
						payment_total_price += parseFloat(payment_row_total_price,4);
					}
					else
					{
						payment_total_capital_price += parseFloat(filterNum(document.getElementById('payment_capital_price'+i).value),4);
						payment_total_interest_price += parseFloat(filterNum(document.getElementById('payment_interest_price'+i).value,4));
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
			for (var i=1; i <= add_credit_contract.revenue_record_num.value; i++)
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
		for(r=1; r<=document.getElementById('payment_record_num').value; r++)
		{
			if(document.getElementById("payment_row_kontrol"+r).value == 1)
			{
				document.getElementById("payment_capital_price"+r).value = filterNum(document.getElementById("payment_capital_price"+r).value,4);
				document.getElementById("payment_interest_price"+r).value = filterNum(document.getElementById("payment_interest_price"+r).value,4);
				document.getElementById("payment_tax_price"+r).value = filterNum(document.getElementById("payment_tax_price"+r).value,4);
				document.getElementById("payment_total_price"+r).value = filterNum(document.getElementById("payment_total_price"+r).value,4);
			}
		}
		for(r=1; r<=document.getElementById('revenue_record_num').value; r++)
		{
			if(document.getElementById("revenue_row_kontrol"+r).value == 1)
			{
				document.getElementById("revenue_capital_price"+r).value = filterNum(document.getElementById("revenue_capital_price"+r).value);
				document.getElementById("revenue_interest_price"+r).value = filterNum(document.getElementById("revenue_interest_price"+r).value);
				document.getElementById("revenue_tax_price"+r).value = filterNum(document.getElementById("revenue_tax_price"+r).value);
				document.getElementById("revenue_total_price"+r).value = filterNum(document.getElementById("revenue_total_price"+r).value);
			}
		}
		for(s=1; s<=document.getElementById('deger_get_money').value; s++)
		{
			document.getElementById('txt_rate2_' + s).value = filterNum(document.getElementById('txt_rate2_' + s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
		document.getElementById("interest_rate").value = filterNum(document.getElementById("interest_rate").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById('total_revenue').value = filterNum(document.getElementById('total_revenue').value,4);
		document.getElementById('other_total_revenue').value = filterNum(document.getElementById('other_total_revenue').value,4);
		document.getElementById('total_payment').value = filterNum(document.getElementById('total_payment').value,4);
		document.getElementById('other_total_payment').value = filterNum(document.getElementById('other_total_payment').value,4);
		//document.getElementById('credit_cost').value = filterNum(document.getElementById('credit_cost').value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');

		
		
	}
	function f_kur_hesapla_multi()//sistem para birimi hesaplama
	{
		var system_cur_value;
		for(var i=1;i<=<cfoutput>#get_money.recordcount#</cfoutput>;i++)
		{
			if(document.add_credit_contract.rd_money[i-1].checked == true)
			{
				rate1_eleman = filterNum(document.getElementById('txt_rate1_' + i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				rate2_eleman = filterNum(document.getElementById('txt_rate2_' + i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				system_cur_value = filterNum(document.getElementById('revenue_total_price').value)*rate2_eleman/rate1_eleman;
				add_credit_contract.other_total_revenue.value = commaSplit(system_cur_value);

				system_cur_value = filterNum(document.getElementById('payment_total_price').value,4)*rate2_eleman/rate1_eleman;
				add_credit_contract.other_total_payment.value = commaSplit(system_cur_value,4);
				
				add_credit_contract.money_info_rev.value = eval('add_credit_contract.hidden_rd_money_'+i).value;
				add_credit_contract.money_info_pay.value = eval('add_credit_contract.hidden_rd_money_'+i).value;
			}
		}
	}
	function gizle_finance()
	{
		var selected_ptype = document.getElementById('process_cat').options[document.getElementById('process_cat').selectedIndex].value;
		if(selected_ptype != '')
		{
			eval('var proc_control = document.add_credit_contract.ct_process_type_'+selected_ptype+'.value');
			if(proc_control == 296)
			{
				
				finance3.style.display = 'none';
				finance4.style.display = 'none';
				finance5.style.display = 'none';
				finance6.style.display = 'none';
				finance7.style.display = '';
				finance8.style.display = '';
				finance9.style.display = '';
				finance10.style.display = 'none';
				finance11.style.display = 'none';
				finance12.style.display = 'none';
				finance13.style.display = 'none';
				finance14.style.display = 'none';
				credit_limit.style.display = 'none';
				credit_limit_.style.display = 'none';
				credit5.style.display = 'none';
				credittable.style.display = 'none';
				baslik1.style.display = 'none';
				baslik2.style.display = 'none';
				baslik3.style.display = '';
				baslik5.style.display = '';
				baslik6.style.display = '';
			}
			else
			{
				
				finance3.style.display = '';
				finance4.style.display = '';
				finance5.style.display = '';
				finance6.style.display = '';
				finance7.style.display = 'none';
				finance8.style.display = 'none';
				finance9.style.display = 'none';
				finance10.style.display = '';
				finance11.style.display = '';
				finance12.style.display = '';
				finance13.style.display = '';
				finance14.style.display = '';
				credit_limit.style.display = '';
				credit_limit_.style.display = '';
				credit5.style.display = '';
				credittable.style.display = 'none';
				baslik1.style.display = '';
				baslik2.style.display = '';
				baslik3.style.display = 'none';
				baslik5.style.display = 'none';
				baslik6.style.display = 'none';
			}
		}
		else
		{
			credittable.style.display = 'none';			
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
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=add_credit_contract.'+input_id+row_number+'&field_name=add_credit_contract.'+input_name+row_number+'&field_account_no=add_credit_contract.'+input_acc_code+row_number+'&field_account_no2=add_credit_contract.'+input_acc_id+row_number+'');
	}
	//muhasebe kodlari popup
	function pencere_ac_acc(input_acc_id,input_acc_code,row_number)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_credit_contract.'+input_acc_id+row_number+'&field_name=add_credit_contract.'+input_acc_code+row_number+'','list');
	}
	gizle_finance();
</script>   
