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
	SELECT MONEY_TYPE AS MONEY, * FROM STOCKBONDS_SALEPURCHASE_MONEY WHERE ACTION_ID=#attributes.action_id#
</cfquery>
<cfif not GET_ACTION_MONEY.recordcount>
	<cfquery name="GET_ACTION_MONEY" datasource="#dsn2#">
		SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY
	</cfquery>
</cfif>
<cfquery name="GET_STOCKBOND_ROWS" datasource="#dsn3#">
	SELECT
		SR.STOCKBOND_ROW_ID,
		SR.NOMINAL_VALUE,
		SR.OTHER_NOMINAL_VALUE,
		SR.PRICE,
		SR.OTHER_PRICE,
		SR.NET_TOTAL,
		SR.OTHER_MONEY_VALUE,
		SR.QUANTITY,
		SR.DESCRIPTION,
		S.STOCKBOND_TYPE,
		S.STOCKBOND_CODE,
		S.ROW_EXP_CENTER_ID,
		S.ROW_EXP_ITEM_ID,
		SR.DUE_DATE,
		S.STOCKBOND_ID
	FROM
		STOCKBONDS S,
		STOCKBONDS_SALEPURCHASE_ROW SR
	WHERE
		SR.SALES_PURCHASE_ID = #attributes.action_id# AND
		S.STOCKBOND_ID = SR.STOCKBOND_ID
</cfquery>
<cfif len(get_bond_action.bank_acc_id)>
	<cfquery name="GET_BANK_ACTIONS" datasource="#dsn2#">
		SELECT ACTION_ID FROM BANK_ACTIONS WHERE PAPER_NO = '#get_bond_action.paper_no#' AND ACTION_TYPE_ID = 294 
	</cfquery>
	<cfset ids = ( len(GET_BANK_ACTIONS.ACTION_ID) ? valueList(GET_BANK_ACTIONS.ACTION_ID) : '' )>
</cfif>
<cf_catalystHeader>			
<cfform name="upd_bond" method="post" action="#request.self#?fuseaction=credit.emptypopup_upd_stockbond_sale">
<!--- 	<cf_basket_form id="add_stockbond"> --->
    <input type="hidden" name="action_id" id="action_id" value="<cfoutput>#attributes.action_id#</cfoutput>">
	<cfif len(get_bond_action.bank_acc_id)><input type="hidden" name="ids" id="ids" value="<cfoutput>#ids#</cfoutput>"></cfif>
	
    <div class="row ui-form-list  ui-form-block">
        	<div class="col col-12 uniqueRow">
            	<div class="row formContent">
                	<div class="row" type="row">
                    	<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        	<div class="form-group" id="item-islem">
                            	<label class="col col-4 col-xs-12"><cf_get_lang_main no ='388.İşlem Tipi'> *</label>
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
									<cfif len(get_bond_action.partner_id)>
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
                            	<label class="col col-4 col-xs-12"><cf_get_lang_main no ='468.Belge No'> *</label>
                                <div class="col col-8 col-xs-12">
                                	<cfinput type="text" name="paper_no" id="paper_no" value="#get_bond_action.paper_no#" maxlength="50" style="width:80px;" required="yes">
                            	</div>
                            </div>
                            <div class="form-group" id="item-action_date">
	                            <label class="col col-4 col-xs-12"><cf_get_lang_main no ='330.Tarih'></label>
	                            <div class="col col-8 col-xs-12">
	                                <div class="input-group">
                                    	<cfinput type="text" name="action_date" id="action_date" validate="#validate_style#" value="#dateformat(get_bond_action.action_date,dateformat_style)#" maxlength="10" style="width:80px;" required="yes" onblur="change_money_info('upd_bond','action_date');">
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
                                	<cfinput type="text" name="broker_company" id="broker_company" value="#get_bond_action.broker_company#" style="width:125px;" maxlength="50">
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
									<input type="text" name="employee" id="employee" style="width:125px;" value="<cfif len(get_bond_action.employee_id)><cfoutput>#get_emp.employee_name# #get_emp.employee_surname#</cfoutput></cfif>">
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
					</div>
					<div class="row">
						<div class="ui-card">
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
							<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_stockbond_rows.recordcount#</cfoutput>">
								<div class="ui-card-add-btn"><a href="javascript://" onClick="f_add_bond();"><i class="icon-pluss" alt="<cf_get_lang_main no='295.Satır Ekle'>" title="<cf_get_lang_main no='295.Satır Ekle'>"></i></a></div>
								<div id="table_list">
									<cfoutput query="get_stockbond_rows">
										<div class="ui-card-item" id="block_row_#currentrow#">
											<div class='ui-card-item-hide'><a href='javascript://' onclick='removeItem(#currentrow#)'><i class='icon-minus'></i></a></div>
											<div class="acc-body">
												<input type="hidden" name="stockbond_row_id#currentrow#" id="stockbond_row_id#currentrow#" value="#stockbond_row_id#">
												<input type="hidden" name="stockbond_id#currentrow#" id="stockbond_id#currentrow#" value="#STOCKBOND_ID#">
												<input  type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
												<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
													<div class="form-group acc-block-name">
														<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang_main no ='218.Tip'>* </label>
														<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
															<cfif len(stockbond_type_list)>
																<cfset deger_bond_type = get_bond_types.stockbond_type[listfind(stockbond_type_list,stockbond_type,',')]>
															<cfelse>
																<cfset deger_bond_type=''>
															</cfif>
															<input type="text" name="bond_type#currentrow#" id="bond_type#currentrow#" value="#deger_bond_type#" readonly="yes">
														</div>
													</div>
													<div class="form-group acc-block-name">
														<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang_main no ='1173.Kod'>* </label>
														<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
															<input type="text" name="bond_code#currentrow#" id="bond_code#currentrow#" value="" readonly="yes" value="#stockbond_code#" readonly="yes">
														</div>
													</div>
													<div class="form-group acc-block-name">
														<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang_main no ='217.Açıklama'>* </label>
														<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
															<input type="text" name="row_detail#currentrow#" id="row_detail#currentrow#" value="#description#">
														</div>
													</div>
												</div>
												<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
													<div class="form-group acc-block-name">
														<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang no ='77.Nominal Değer'>* </label>
														<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
															<input type="text" name="nominal_value#currentrow#" id="nominal_value#currentrow#" value="#TLFormat(nominal_value,session.ep.our_company_info.rate_round_num)#" class="moneybox" class="moneybox" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="hesapla(#currentrow#);">
														</div>
													</div>
													<div class="form-group acc-block-name">
														<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang no ='78.Nominal Değer Döviz'>* </label>
														<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
															<input type="text" name="other_nominal_value#currentrow#" id="other_nominal_value#currentrow#" value="#TLFormat(other_nominal_value,session.ep.our_company_info.rate_round_num)#" class="moneybox" class="moneybox" value="" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="hesapla(#currentrow#,1);">
														</div>
													</div>
													<div class="form-group acc-block-name">
														<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang no ='108.Satis Değer'>* </label>
														<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
															<input type="text" name="sale_value#currentrow#" id="sale_value#currentrow#" class="moneybox" value="#TLFormat(price,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="hesapla(#currentrow#);">
														</div>
													</div>
													<div class="form-group acc-block-name">
														<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang no ='109.Satis Değer Döviz'>* </label>
														<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
															<input type="text" name="other_sale_value#currentrow#" id="other_sale_value#currentrow#" class="moneybox" value="#TLFormat(other_price,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="hesapla(#currentrow#,1);">
														</div>
													</div>
												</div>
												<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
													<div class="form-group acc-block-name">
														<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang_main no ='223.Miktar'> </label>
														<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
															<input type="text" name="quantity#currentrow#" id="quantity#currentrow#" value="#ReplaceNoCase(quantity,'.',',','all')#" onBlur="hesapla(#currentrow#);" onkeyup="return(FormatCurrency(this,event,4));">
														</div>
													</div>
													<div class="form-group acc-block-name">
														<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang no ='104.Toplam Satis'> </label>
														<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
															<input type="text" name="total_sale#currentrow#" id="total_sale#currentrow#" class="moneybox" value="#TLFormat(net_total,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="hesapla(#currentrow#);" readonly="yes" >
														</div>
													</div>
													<div class="form-group acc-block-name">
														<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang no ='110.Toplam Satis Döviz'></label>
														<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
															<input type="text" name="other_total_sale#currentrow#" id="other_total_sale#currentrow#" class="moneybox" value="#TLFormat(other_money_value,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" readonly="yes">
														</div>
													</div>
													<div class="form-group acc-block-name">
														<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang no ='89.Masraf / Gelir Merkezi'></label>
														<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
															<cfif len(exp_center_id_list)>
																<cfset deger_exp_center = get_exp_center.expense[listfind(exp_center_id_list,row_exp_center_id,',')]>
															<cfelse>
																<cfset deger_exp_center = ''>
															</cfif>
															<input type="text" name="expense_center_id#currentrow#" id="expense_center_id#currentrow#" value="#deger_exp_center#" readonly="yes">
														</div>
													</div>
												</div>
												<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
													<div class="form-group acc-block-name">
														<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang_main no='822.Bütçe Kalemi'></label>
														<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
															<cfif len(exp_item_id_list)>
																<cfset deger_exp_item = get_exp_detail.expense_item_name[listfind(exp_item_id_list,row_exp_item_id,',')]>
															<cfelse>
																<cfset deger_exp_item =''>
															</cfif>
															<input type="text" name="expense_item_id#currentrow#" id="expense_item_id#currentrow#" value="#deger_exp_item#" readonly="yes">
														</div>
													</div>
													<div class="form-group acc-block-name">
														<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang_main no ='469.Vade Tarihi'></label>
														<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
															<div class="input-group">
																<cfinput type="text" name="due_date#currentrow#" id="due_date#currentrow#" value="#dateformat(due_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
																<span class="input-group-addon"><cf_wrk_date_image date_field="due_date#currentrow#"></span>
															</div>
														</div>
													</div>
												</div>
											</div>
										</div>
									</cfoutput>
								</div>
						</div>
					</div>
					<div class="row formContentFooter" id="sepetim_total">
						<div class="col col-4 col-md-3 col-sm-3 col-xs-12" id="basket_money_totals_table">
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
										<cfoutput>
											<cfif len(session.ep.money)>
												<cfset selected_money=session.ep.money>
											</cfif>
											<cfif session.ep.rate_valid eq 1>
												<cfset readonly_info = "yes">
											<cfelse>
												<cfset readonly_info = "no">
											</cfif>
											<cfloop query="get_action_money">
											<tr>
												<td>
													<input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
													<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
												</td>
												<td nowrap="nowrap">
													<input type="radio" name="rd_money" id="rd_money" value="#money#" onClick="doviz_hesapla();" <cfif get_bond_action.other_money eq money>checked</cfif>>#money#
												</td>
												<td nowrap="nowrap">
													#TLFormat(rate1,0)#/<input type="text" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#"<cfif readonly_info>readonly</cfif> class="box" <cfif money eq session.ep.money>readonly="yes"</cfif> value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="doviz_hesapla();">
												</td>
											</tr>
											</cfloop>
										</cfoutput>
									</table>
								</div>
							</div>
						</div>
						<cfoutput query="get_bond_action">
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
										<!--- Toplam Satis --->
										<tr>
											<td nowrap="nowrap"><cf_get_lang no ='104.Toplam Satis'><cfoutput>#session.ep.money#</cfoutput></td>
											<td><input type="text" name="action_value" id="action_value" style="width:120px;" class="moneybox" value="#TLFormat(net_total,session.ep.our_company_info.rate_round_num)#" onBlur="doviz_hesapla();" readonly="yes">&nbsp;</td>
										</tr>
										<tr>
											<td nowrap="nowrap"><cf_get_lang no ='110.Toplam Satis Doviz '>
												<input type="text" name="other_money_info" id="other_money_info" style="width:35px;" class="box" value="<cfoutput>#get_bond_action.other_money#</cfoutput>" readonly="yes">
											</td>
											<td><input type="text" name="sale_other" id="sale_other" style="width:120px;" class="moneybox" value="#TLFormat(other_money_value,session.ep.our_company_info.rate_round_num)#" readonly="yes">&nbsp;</td>
										</tr>
										<tr>
											<td><cf_get_lang no ='91.Komisyon Oranı'>%</td>
											<td><input type="text" name="com_rate" id="com_rate" class="moneybox" style="width:120px;" value="#TLFormat(com_rate,session.ep.our_company_info.rate_round_num)#" onBlur="toplam_hesapla();" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));">&nbsp;</td>
										</tr>
										<tr>
											<td><cf_get_lang no ='93.Komisyon Toplam'><cfoutput>#session.ep.money#</cfoutput></td>
											<td><input type="text" name="com_ytl" id="com_ytl" class="moneybox" style="width:120px;" value="#TLFormat(com_total,session.ep.our_company_info.rate_round_num)#" onBlur="total_doviz_hesapla();">&nbsp;</td>
										</tr>
										<tr>
											<td><cf_get_lang no ='93.Komisyon Toplam'><cf_get_lang_main no='265.Doviz'>
												<input type="text" name="other_money_info1" id="other_money_info1" class="box" style="width:35px;" readonly="" value="<cfoutput>#session.ep.money2#</cfoutput>">
											</td>
											<td><input type="text" name="com_other" id="com_other"  class="moneybox" style="width:120px;" value="#TLFormat(other_com_total,session.ep.our_company_info.rate_round_num)#" readonly="yes">&nbsp;</td>
										</tr>
										<tr>
											<td><cf_get_lang no='4.Toplam Gelir/Gider'><cfoutput>#session.ep.money#</cfoutput></td>
											<td><input type="text" name="total_income" id="total_income" class="moneybox" style="width:120px;" value="#TLFormat(total_income,session.ep.our_company_info.rate_round_num)#" onBlur="total_doviz_hesapla();" readonly="yes">&nbsp;</td>
										</tr>
										<tr>
											<td><cf_get_lang no ='4.Toplam Gelir/Gider'><cf_get_lang_main no='265.Döviz'><input type="text" style="width:35px;" name="other_money_info2" id="other_money_info2" class="box" value="<cfoutput>#session.ep.money2#</cfoutput>" readonly="yes"></td>
											<td><input type="text" name="total_income_other" id="total_income_other" class="moneybox" style="width:120px;" value="#TLFormat(other_total_income,session.ep.our_company_info.rate_round_num)#">&nbsp;</td>
										</tr>
									</table>
								</div>
							</div>
						</div>
						<div class="col col-4 col-md-9 col-sm-9 col-xs-12" id="basket_money_totals_table">
							<div class="totalBox">
								<div class="totalBoxHead font-grey-mint">
									<span class="headText"><cf_get_lang dictionary_id='54511.Masraflar'></span>
									<div class="collapse">
									<span class="icon-minus"></span>
									</div>
								</div>
								<div class="row">
									<div class="totalBoxBody">
										<div class="form-group" id="item-expense_center_id">
											<label class="col col-4 col-xs-12"><cf_get_lang_main no='760.Gelir Merkezi'>*</label>
											<div class="col col-5 col-xs-12">
												<div class="input-group">	
													<cfif len(exp_center_id)>
														<cfquery name="get_main_center" datasource="#dsn2#">
															SELECT  EXPENSE,EXPENSE_ID FROM EXPENSE_CENTER WHERE EXPENSE_ID=#exp_center_id#
														</cfquery>
													</cfif>
													<input type="hidden" name="expense_center_id" id="expense_center_id" value="<cfoutput><cfif len(exp_center_id)>#get_main_center.expense_id#</cfif></cfoutput>">
													<input type="text" name="expense_center" id="expense_center" value="<cfoutput><cfif len(exp_center_id)>#get_main_center.expense#</cfif></cfoutput>">
													<span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang_main no='322.Seçiniz'>" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_expense_center&field_name=upd_bond.expense_center&field_id=upd_bond.expense_center_id&is_invoice=1</cfoutput>','list');"></span>
												</div>
											</div>
										</div>
										<div class="form-group" id="item-expense_item_id">
											<label class="col col-4 col-xs-12"><cf_get_lang_main no='761.Gelir Kalemi'>*</label>
											<div class="col col-5 col-xs-12">
												<div class="input-group">	
													<cfif len(exp_item_id)>
														<cfquery name="get_main_item" datasource="#dsn2#">
															SELECT EXPENSE_ITEM_NAME,EXPENSE_ITEM_ID FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID=#exp_item_id#
														</cfquery>
													</cfif>	
													<input type="hidden" name="expense_item_id" id="expense_item_id" value="<cfoutput><cfif len(exp_item_id)>#get_main_item.expense_item_id#</cfif></cfoutput>">
													<input type="text" name="expense_item_name" id="expense_item_name" value="<cfoutput><cfif len(exp_item_id)>#get_main_item.expense_item_name#</cfif></cfoutput>" onFocus="AutoComplete_Create('expense_item_name','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID,ACCOUNT_CODE,ACCOUNT_CODE','expense_item_id,acc_name,acc_id','upd_bond',3);" autocomplete="off">
													<span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang_main no='322.Seçiniz'>" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=upd_bond.expense_item_id&field_name=upd_bond.expense_item_name&is_income=1&field_account_no=upd_bond.acc_id&field_account_no2=upd_bond.acc_name','list');"></span>
												</div>
											</div>
										</div>
										<div class="form-group" id="item-acc_id">
											<label class="col col-4 col-xs-12"><cf_get_lang_main no='1399.Muhasebe Kodu'>*</label>
											<div class="col col-5 col-xs-12">
												<div class="input-group">	
													<cf_wrk_account_codes form_name='upd_bond' account_code='acc_id' account_name='acc_name' search_from_name='1'>			
													<input type="hidden" name="acc_id" id="acc_id" value="#account_code#">
													<input type="text" name="acc_name" id="acc_name" value="#account_code#" onkeyup="get_wrk_acc_code_1();" onFocus="AutoComplete_Create('acc_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','acc_id','upd_bond','3','120');" autocomplete="off">
													<span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang_main no='322.Seçiniz'>" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_name=upd_bond.acc_name&field_id=upd_bond.acc_id','list')"></span>
												</div>
											</div>
										</div>
										<div class="form-group" id="item-com_exp_center_id">
											<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58791.Komisyon'><cf_get_lang_main no='1048.Masraf Merkezi'></label>
											<div class="col col-5 col-xs-12">
												<div class="input-group">	
													<cfif len(com_exp_center_id)>
														<cfquery name="get_com_main_center" datasource="#dsn2#">
															SELECT EXPENSE,EXPENSE_ID FROM EXPENSE_CENTER WHERE EXPENSE_ID=#com_exp_center_id#
														</cfquery>
													</cfif>
													<input type="hidden" name="com_exp_center_id" id="com_exp_center_id" value="<cfoutput><cfif len(com_exp_center_id)>#get_com_main_center.expense_id#</cfif></cfoutput>">
													<input type="text" name="com_exp_center" id="com_exp_center" value="<cfoutput><cfif len(com_exp_center_id)>#get_com_main_center.expense#</cfif></cfoutput>">
													<span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang_main no='322.Seçiniz'>" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_expense_center&field_name=upd_bond.com_exp_center&field_id=upd_bond.com_exp_center_id&is_invoice=1</cfoutput>','list')"></span>
												</div>
											</div>
										</div>
										<div class="form-group" id="item-com_exp_item_id">
											<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58791.Komisyon'><cf_get_lang_main no ='1139.Gider Kalemi'></label>
											<div class="col col-5 col-xs-12">
												<div class="input-group">	
													<cfif len(com_exp_item_id)>
														<cfquery name="get_com_main_item" datasource="#dsn2#">
															SELECT EXPENSE_ITEM_NAME,EXPENSE_ITEM_ID FROM EXPENSE_ITEMS WHERE IS_EXPENSE = 1 AND EXPENSE_ITEM_ID=#com_exp_item_id#
														</cfquery>
													</cfif>	
													<input type="hidden" name="com_exp_item_id" id="com_exp_item_id" value="<cfoutput><cfif len(com_exp_item_id)>#get_com_main_item.expense_item_id#</cfif></cfoutput>">
													<input type="text" name="com_exp_item_name" id="com_exp_item_name" value="<cfoutput><cfif len(com_exp_item_id)>#get_com_main_item.expense_item_name#</cfif></cfoutput>" onFocus="AutoComplete_Create('com_exp_item_name','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID,ACCOUNT_CODE,ACCOUNT_CODE','com_exp_item_id,com_acc_name,com_acc_id','upd_bond',3);" autocomplete="off">
													<span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang_main no='322.Seçiniz'>" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=upd_bond.com_exp_item_id&field_name=upd_bond.com_exp_item_name&field_account_no=upd_bond.com_acc_id&field_account_no2=upd_bond.com_acc_name','list');"></span>
												</div>
											</div>
										</div>
										<div class="form-group" id="item-com_acc_id">
											<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58791.Komisyon'><cf_get_lang_main no='1399.Muhasebe Kodu'></label>
											<div class="col col-5 col-xs-12">
												<div class="input-group">	
													<cf_wrk_account_codes form_name='upd_bond' account_code='com_acc_id' account_name='com_acc_name' search_from_name='1' is_multi_no ='2'>
													<input type="hidden" name="com_acc_id" id="com_acc_id" value="#com_account_code#">
													<input type="text" name="com_acc_name" id="com_acc_name" value="#com_account_code#" onkeyup="get_wrk_acc_code_2();" onFocus="AutoComplete_Create('com_acc_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','com_acc_id','upd_bond','3','120');" autocomplete="off">
													<span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang_main no='322.Seçiniz'>" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_name=upd_bond.com_acc_name&field_id=upd_bond.com_acc_id','list')"></span>
												</div>
											</div>
										</div>
										<input type="hidden" name="nominal_total_amount" id="nominal_total_amount" class="moneybox" value="#TLFormat((net_total-total_income),session.ep.our_company_info.rate_round_num)#">&nbsp;
										<input type="hidden" name="other_nominal_total_amount" id="other_nominal_total_amount" class="moneybox" value="#TLFormat((other_money_value-other_total_income),session.ep.our_company_info.rate_round_num)#">&nbsp;
										<div class="form-group" id="item-total_income_exp_center_id">
											<label class="col col-4 col-xs-12"><cf_get_lang no='89.Masraf/Gelir Merkezi'>*</label>
											<div class="col col-5 col-xs-12">
												<div class="input-group">	
													<cfif len(total_income_exp_center_id)>
														<cfquery name="get_total_income_exp_center" datasource="#dsn2#">
															SELECT EXPENSE,EXPENSE_ID FROM EXPENSE_CENTER WHERE EXPENSE_ID=#total_income_exp_center_id#
														</cfquery>
													</cfif>
													<input type="hidden" name="total_income_exp_center_id" id="total_income_exp_center_id" value="<cfoutput><cfif len(total_income_exp_center_id)>#get_total_income_exp_center.expense_id#</cfif></cfoutput>">
													<input type="text" name="total_income_exp_center" id="total_income_exp_center" value="<cfoutput><cfif len(total_income_exp_center_id)>#get_total_income_exp_center.expense#</cfif></cfoutput>">
													<span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang_main no='322.Seçiniz'>" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_expense_center&field_name=upd_bond.total_income_exp_center&field_id=upd_bond.total_income_exp_center_id&is_invoice=1</cfoutput>','list');"></span>
												</div>
											</div>
										</div>
										<div class="form-group" id="item-total_income_exp_item_id">
											<label class="col col-4 col-xs-12"><cf_get_lang no ='3.Gelir/Gider Kalemi'>*</label>
											<div class="col col-5 col-xs-12">
												<div class="input-group">	
													<cfif len(total_income_exp_item_id)>
														<cfquery name="get_total_income_exp_item" datasource="#dsn2#">
															SELECT EXPENSE_ITEM_NAME,EXPENSE_ITEM_ID FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID=#total_income_exp_item_id#
														</cfquery>
													</cfif>	
													<input type="hidden" name="total_income_exp_item_id" id="total_income_exp_item_id" value="<cfoutput><cfif len(total_income_exp_item_id)>#get_total_income_exp_item.expense_item_id#</cfif></cfoutput>">
													<input type="text" name="total_income_exp_item_name" id="total_income_exp_item_name" value="<cfoutput><cfif len(total_income_exp_item_id)>#get_total_income_exp_item.expense_item_name#</cfif></cfoutput>" onFocus="AutoComplete_Create('total_income_exp_item_name','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID,ACCOUNT_CODE,ACCOUNT_CODE','total_income_exp_item_id,total_income_acc_name,total_income_acc_id','upd_bond',3);" autocomplete="off">
													<span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang_main no='322.Seçiniz'>" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=upd_bond.total_income_exp_item_id&field_name=upd_bond.total_income_exp_item_name&field_account_no=upd_bond.total_income_acc_id&field_account_no2=upd_bond.total_income_acc_name','list');"></span>
												</div>
											</div>
										</div>
										<div class="form-group" id="item-total_income_acc_id">
											<label class="col col-4 col-xs-12"><cf_get_lang_main no='1399.Muhasebe Kodu'>*</label>
											<div class="col col-5 col-xs-12">
												<div class="input-group">	
													<cf_wrk_account_codes form_name='upd_bond' account_code='acc_id' account_name='acc_name' search_from_name='1'>			
														<input type="hidden" name="total_income_acc_id" id="total_income_acc_id" value="#total_income_account_code#">
														<input type="text" name="total_income_acc_name" id="total_income_acc_name" value="#total_income_account_code#" onkeyup="get_wrk_acc_code_1();" onFocus="AutoComplete_Create('total_income_acc_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','total_income_acc_id','upd_bond','3','120');" autocomplete="off">
													<span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang_main no='322.Seçiniz'>" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_name=upd_bond.total_income_acc_name&field_id=upd_bond.total_income_acc_id','list')"></span>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						</cfoutput>
					</div>
                    <div class="row formContentFooter">
	                    <div class="col col-12">
							<cf_record_info query_name="get_bond_action">
							<cf_workcube_buttons is_upd='1' add_function='kontrol()' is_delete='1' delete_page_url='#request.self#?fuseaction=credit.emptypopup_del_stockbond_purchase&action_id=#attributes.action_id#&old_process_type=#get_bond_action.process_type#&bank_action_id=#get_bond_action.bank_action_id#&ids=#(len(get_bond_action.bank_acc_id)) ? ids : ""# '>
	                    </div>
                	</div>
                </div>
            </div>
        </div>

</cfform>
<script type="text/javascript">

	var stockBondCounter = <cfoutput>#get_stockbond_rows.recordcount#</cfoutput>;
	var stockBondObject = [{
		"sil" :                 "<a style='cursor:pointer;' onclick='sil(###id###);'><img src='images/delete_list.gif' border='0'></a><input name='productRow' value='###id###' type='hidden'>",
		"row_kontrol":          "<input type='hidden' name='row_kontrol###id###' id='row_kontrol###id###' value='1'>",
		"stockbond_id":         "<input type='hidden' name='stockbond_id###id###' id='stockbond_id###id###' value='###val-stockbond_id###'>",
		"stockbond_row_id":     "<input type='hidden' name='stockbond_row_id###id###' id='stockbond_row_id###id###' value='0'>",
		"bond_type":            "<div class='acc-block-name col col-12 col-md-12 col-sm-12 col-xs-12'><label class='col col-12 col-md-12 col-sm-12 col-xs-12'><cf_get_lang_main no ='218.Tip'>*</label><div class='col col-12 col-md-12 col-sm-12 col-xs-12'><input type='text' name='bond_type###id###' id='bond_type###id###' value='###val-bond_type###'></div></div>",
		"bond_code":            "<div class='acc-block-name col col-12 col-md-12 col-sm-12 col-xs-12'><label class='col col-12 col-md-12 col-sm-12 col-xs-12'><cf_get_lang_main no ='1173.Kod'>*</label><div class='col col-12 col-md-12 col-sm-12 col-xs-12'><input type='text' name='bond_code###id###' id='bond_code###id###' value='###val-bond_code###' readonly></div></div>",
		"row_detail":           "<div class='acc-block-name col col-12 col-md-12 col-sm-12 col-xs-12'><label class='col col-12 col-md-12 col-sm-12 col-xs-12'><cf_get_lang_main no ='217.Açıklama'>*</label><div class='col col-12 col-md-12 col-sm-12 col-xs-12'><input type='text' name='row_detail###id###' id='row_detail###id###' value='###val-row_detail###'></div></div>",
		"nominal_value":        "<div class='acc-block-name col col-12 col-md-12 col-sm-12 col-xs-12'><label class='col col-12 col-md-12 col-sm-12 col-xs-12'><cf_get_lang no ='77.Nominal Değer'>*</label><div class='col col-12 col-md-12 col-sm-12 col-xs-12'><input type='text' name='nominal_value###id###' id='nominal_value###id###' value='###val-nominal_value###' class='moneybox' onkeyup='return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));' onblur='hesapla(###id###);'></div></div>",
		"other_nominal_value":  "<div class='acc-block-name col col-12 col-md-12 col-sm-12 col-xs-12'><label class='col col-12 col-md-12 col-sm-12 col-xs-12'><cf_get_lang no ='78.Nominal Değer Döviz'>*</label><div class='col col-12 col-md-12 col-sm-12 col-xs-12'><input type='text' name='other_nominal_value###id###' id='other_nominal_value###id###' value='###val-other_nominal_value###' class='moneybox' onkeyup='return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));' readonly></div></div>",
		"sale_value":           "<div class='acc-block-name col col-12 col-md-12 col-sm-12 col-xs-12'><label class='col col-12 col-md-12 col-sm-12 col-xs-12'><cf_get_lang no ='108.Satis Değer'>*</label><div class='col col-12 col-md-12 col-sm-12 col-xs-12'><input type='text' name='sale_value###id###' id='sale_value###id###' value='###val-sale_value###' class='moneybox' onkeyup='return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));' onblur='hesapla(###id###);'></div></div>",
		"other_sale_value":     "<div class='acc-block-name col col-12 col-md-12 col-sm-12 col-xs-12'><label class='col col-12 col-md-12 col-sm-12 col-xs-12'><cf_get_lang no ='109.Satis Değer Döviz'>*</label><div class='col col-12 col-md-12 col-sm-12 col-xs-12'><input type='text' name='other_sale_value###id###' id='other_sale_value###id###' value='###val-other_sale_value###' class='moneybox' onkeyup='return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));' readonly></div></div>",
		"quantity":             "<div class='acc-block-name col col-12 col-md-12 col-sm-12 col-xs-12'><label class='col col-12 col-md-12 col-sm-12 col-xs-12'><cf_get_lang_main no ='223.Miktar'></label><div class='col col-12 col-md-12 col-sm-12 col-xs-12'><input type='text' name='quantity###id###' id='quantity###id###' value='###val-quantity###' class='moneybox' onkeyup='return(FormatCurrency(this,event,4));' onblur='hesapla(###id###);'></div></div>",
		"total_sale":           "<div class='acc-block-name col col-12 col-md-12 col-sm-12 col-xs-12'><label class='col col-12 col-md-12 col-sm-12 col-xs-12'><cf_get_lang no ='104.Toplam Satis'></label><div class='col col-12 col-md-12 col-sm-12 col-xs-12'><input type='text' name='total_sale###id###' id='total_sale###id###' value='###val-total_sale###' class='moneybox' onkeyup='return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));' onblur='hesapla(###id###);' readonly></div></div>",
		"other_total_sale":     "<div class='acc-block-name col col-12 col-md-12 col-sm-12 col-xs-12'><label class='col col-12 col-md-12 col-sm-12 col-xs-12'><cf_get_lang no ='110.Toplam Satis Döviz'></label><div class='col col-12 col-md-12 col-sm-12 col-xs-12'><input type='text' name='other_total_sale###id###' id='other_total_sale###id###' value='###val-other_total_sale###' class='moneybox' onkeyup='return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));' readonly></div></div>",
		"expense_center_id":    "<div class='acc-block-name col col-12 col-md-12 col-sm-12 col-xs-12'><label class='col col-12 col-md-12 col-sm-12 col-xs-12'><cf_get_lang no ='89.Masraf / Gelir Merkezi'></label><div class='col col-12 col-md-12 col-sm-12 col-xs-12'><input type='text' name='expense_center_id###id###' id='expense_center_id###id###' value='###val-expense_center_id###' readonly></div></div>",
		"expense_item_id":      "<div class='acc-block-name col col-12 col-md-12 col-sm-12 col-xs-12'><label class='col col-12 col-md-12 col-sm-12 col-xs-12'><cf_get_lang_main no='822.Bütçe Kalemi'></label><div class='col col-12 col-md-12 col-sm-12 col-xs-12'><input type='text' name='expense_item_id###id###' id='expense_item_id###id###' value='###val-expense_item_id###' readonly></div></div>",
		"due_date":             "<div class='acc-block-name col col-12 col-md-12 col-sm-12 col-xs-12'><label class='col col-12 col-md-12 col-sm-12 col-xs-12'><cf_get_lang_main no ='469.Vade Tarihi'>*</label><div class='col col-12 col-md-12 col-sm-12 col-xs-12'><div class='input-group'><input type='text' name='due_date###id###' id='due_date###id###' maxlength='10'><span class='input-group-addon'><span class='date-group' id='due_date###id###_td'></span></span></div></div></div>"
	}];

	var find = ["val-stockbond_id","val-bond_type", "val-bond_code", "val-row_detail", "val-nominal_value", "val-other_nominal_value", "val-sale_value", "val-other_sale_value", "val-quantity", "val-total_sale", "val-other_total_sale", "val-expense_center_id", "val-expense_item_id"];

	String.prototype.replaceArray = function(find, replace) {
	var replaceString = this, regex;
	for (var i = 0; i < find.length; i++) {
		regex = new RegExp("###"+find[i]+"###", "g");
		replaceString = replaceString.replace(regex, replace[i]);
	}
	return replaceString;
	};

	function gonder(stockbond_id,bond_type,bond_code,detail,quantity,nominal_value,other_nominal_value,sale_value,other_sale_value,total_sale,other_total_sale,due_date,expense_center_name,expense_item_name)
	{
		stockBondCounter +=1;
		document.getElementById("record_num").value = parseInt( document.getElementById("record_num").value ) + 1;
		var replace = [stockbond_id, bond_type, bond_code, detail, nominal_value, other_nominal_value, sale_value, other_sale_value, quantity, total_sale, other_total_sale, expense_center_name, expense_center_name  ];
		var template="<div class='ui-card-item' id='block_row_"+stockBondCounter+"'>{row_kontrol}{stockbond_id}{stockbond_row_id}<div class='ui-card-item-hide'><a href='javascript://' onclick='removeItem("+stockBondCounter+")'><i class='icon-minus'></i></a></div><div class='acc-body'><div class='col col-3 col-md-4 col-sm-6 col-xs-12'>{bond_type}{bond_code}{row_detail}</div><div class='col col-3 col-md-4 col-sm-6 col-xs-12'>{nominal_value}{other_nominal_value}{sale_value}{other_sale_value}</div><div class='col col-3 col-md-4 col-sm-6 col-xs-12'>{quantity}{total_sale}{other_total_sale}{expense_center_id}</div><div class='col col-3 col-md-4 col-sm-6 col-xs-12'>{expense_item_id}{due_date}</div></div></div>";
		stockBondObject.filter((el) => { $('#table_list').append(nano( template, el ).replace(/###id###/g,stockBondCounter).replaceArray(find, replace)); });
		wrk_date_image('due_date' + stockBondCounter);
		toplam_hesapla();

		/* var temp_quantity=quantity.replace('.',',');
		$("#stockbond_id1").val(stockbond_id);
		$("#bond_type1").val(bond_type);
		$("#bond_code1").val(bond_code);
		$("#row_detail1").val(detail);
		$("#quantity1").val(temp_quantity);
		$("#nominal_value1").val(nominal_value);
		$("#other_nominal_value1").val(other_nominal_value);
		$("#sale_value1").val(sale_value);
		$("#other_sale_value1").val(other_sale_value);
		$("#total_sale1").val(total_sale);
		$("#other_total_sale1").val(other_total_sale);
		$("#due_date1").val(due_date);
		$("#expense_center_id1").val(expense_center_name);
		$("#expense_item_id1").val(expense_item_name); */
		toplam_hesapla();
	}
	function removeItem(id) {
		document.getElementById("block_row_"+id+"").remove();
		toplam_hesapla();
	}
	function hesapla(row_no, val)
	{
		sale_value = document.getElementById("sale_value"+row_no);
		nominal_value= document.getElementById("nominal_value"+row_no);
		quantity= document.getElementById("quantity"+row_no);
		if(sale_value.value  == " ") sale_value.value  = 0;
		if(nominal_value.value  == " ") nominal_value.value  = 0;
		if(quantity.value  == " ") quantity.value  = 1;
		for (var i=1; i<=document.getElementById("kur_say").value; i++)
		{		
			if(document.upd_bond.rd_money[i-1].checked == true)
			{
				form_txt_rate2_ = filterNum(document.getElementById("txt_rate2_"+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/filterNum(document.getElementById("txt_rate1_"+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				if( val == undefined){
					document.getElementById("other_total_sale"+row_no).value = commaSplit(filterNum(document.getElementById("total_sale"+row_no).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/form_txt_rate2_,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>);
					document.getElementById("other_sale_value"+row_no).value = commaSplit(filterNum(document.getElementById("sale_value"+row_no).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/form_txt_rate2_,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>);
					document.getElementById("other_nominal_value"+row_no).value = commaSplit(filterNum(document.getElementById("nominal_value"+row_no).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/form_txt_rate2_,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>);
				}else{
					document.getElementById("total_sale"+row_no).value = commaSplit(filterNum(document.getElementById("other_total_sale"+row_no).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')*form_txt_rate2_,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>);
					document.getElementById("sale_value"+row_no).value = commaSplit(filterNum(document.getElementById("other_sale_value"+row_no).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')*form_txt_rate2_,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>);
					document.getElementById("nominal_value"+row_no).value = commaSplit(filterNum(document.getElementById("other_nominal_value"+row_no).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')*form_txt_rate2_,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>);
				}
			}
		}
		toplam_hesapla();
	}
	function toplam_hesapla()
	{
		var total_amount = 0;
		var other_total_amount = 0;
		var nominal_total_amount = 0;
		var other_nominal_total_amount = 0;
		if(document.getElementById("record_num").value > 0){
			for(j=1;j<=document.getElementById("record_num").value;j++)
			{		
				if( typeof( document.getElementById("row_kontrol"+j) ) != 'undefined' && document.getElementById("row_kontrol"+j) != null && document.getElementById("row_kontrol"+j).value == 1 )
				{
					document.getElementById("total_sale"+j).value = commaSplit(parseFloat(filterNum(document.getElementById("sale_value"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'))*parseFloat(filterNum(document.getElementById("quantity"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
					document.getElementById("other_total_sale"+j).value = commaSplit(parseFloat(filterNum(document.getElementById("other_sale_value"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'))*parseFloat(filterNum(document.getElementById("quantity"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
					total_amount += parseFloat(filterNum(document.getElementById("total_sale"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'));
					other_total_amount += parseFloat(filterNum(document.getElementById("other_total_sale"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'));
					nominal_total_amount += parseFloat(filterNum(document.getElementById("nominal_value"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'))*parseFloat(filterNum(document.getElementById("quantity"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'));
					other_nominal_total_amount += parseFloat(filterNum(document.getElementById("other_nominal_value"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'))*parseFloat(filterNum(document.getElementById("quantity"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'));
				}
			}
		}else{
			total_amount = 0;
			other_total_amount = 0;
			nominal_total_amount = 0;
			other_nominal_total_amount = 0;
		}
		com_rate = filterNum(document.getElementById("com_rate").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("action_value").value = commaSplit(total_amount,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("sale_other").value = commaSplit(other_total_amount,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("com_ytl").value =commaSplit(filterNum(document.getElementById("action_value").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')*com_rate/100,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("com_other").value =commaSplit(filterNum(document.getElementById("sale_other").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')*com_rate/100,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("total_income").value =commaSplit(total_amount-nominal_total_amount,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("total_income_other").value =commaSplit(other_total_amount-other_nominal_total_amount,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("nominal_total_amount").value =commaSplit(nominal_total_amount,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("other_nominal_total_amount").value =commaSplit(other_nominal_total_amount,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
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
					document.getElementById("other_sale_value"+k).value = commaSplit(filterNum(document.getElementById("sale_value"+k).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/rate2_value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
					document.getElementById("other_total_sale"+k).value = commaSplit(filterNum(document.getElementById("total_sale"+k).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/rate2_value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
					document.getElementById("sale_other").value = commaSplit(filterNum(document.getElementById("action_value").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/rate2_value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				}
				document.getElementById("other_money_info").value = document.upd_bond.rd_money[t-1].value;
				document.getElementById("other_money_info1").value = document.upd_bond.rd_money[t-1].value;
				document.getElementById("other_money_info2").value = document.upd_bond.rd_money[t-1].value;
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
				document.getElementById("total_income_other").value = commaSplit(filterNum(document.getElementById("total_income").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/rate2_value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				document.getElementById("total_income").value = commaSplit(filterNum(document.getElementById("total_income").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			}
		}
	}
	function kontrol()
	{	
		if(!$("#paper_no").val().length)
		{
			alertObject({message: "<cfoutput>#getLang('finance',482)#​</cfoutput>"})    
			return false;
		}
		if(!$("#action_date").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang_main no ='1091.Tarih Girmelisiniz '>​</cfoutput>"})    
			return false;
		}
		var record_exist=0;
		if (!chk_process_cat('upd_bond')) return false;
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
			alert("<cf_get_lang_main no ='1144.Belge No Girmelisiniz'>!");
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
		if(document.getElementById("expense_center_id").value=="")
		{
			alert("<cf_get_lang dictionary_id='48225.Masraf Merkezi Girmelisiniz'>!");
			return false;
		}
		if(document.getElementById("expense_item_id").value=="")
		{
			alert("<cf_get_lang dictionary_id='49131.Bütçe Kalemi Girmelisiniz'>");
			return false;
		}
		if(document.getElementById("acc_id").value=="")
		{
			alert("Muhasebe Kodu Giriniz!");
			return false;
		}
		if(document.getElementById("total_income_exp_center_id").value=="")
		{
			alert("<cf_get_lang dictionary_id='48225.Masraf Merkezi Girmelisiniz'>!");
			return false;
		}
		if(document.getElementById("total_income_exp_item_id").value=="")
		{
			alert("<cf_get_lang dictionary_id='49131.Bütçe Kalemi Girmelisiniz'>");
			return false;
		}
		if(document.getElementById("total_income_acc_id").value=="")
		{
			alert("Muhasebe Kodu Giriniz!");
			return false;
		}
		var list = "";
		for(r=1;r<=document.getElementById("record_num").value;r++)
		{
			if( typeof( document.getElementById("row_kontrol"+r) ) != "undefined" && document.getElementById("row_kontrol"+r) != null && document.getElementById("row_kontrol"+r).value == 1 )
			{
				record_exist = 1;
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
				if ((document.getElementById("sale_value"+r).value == "")||(document.getElementById("sale_value"+r).value ==0))
				{ 
					alert ("<cf_get_lang no ='107.Lütfen Satış Değeri Giriniz'>!");
					return false;
				}
				if (document.getElementById("quantity"+r).value != '')
				{
					var listParam =document.getElementById("stockbond_id"+r).value+"*"+document.getElementById("stockbond_row_id"+r).value;
					var get_quantity = wrk_safe_query('get_stockbond_quantity','dsn3',0,listParam); 
					
					if(document.getElementById("quantity"+r).value > parseFloat(get_quantity.NET_QUANTITY))
					{
						var list = list+'\n'+document.getElementById("bond_code"+r).value+'-'+document.getElementById("row_detail"+r).value;
					}	
				}
			}
		}
		if(list != '')
		{
			alert("Aşağıdaki Menkul Kıymetlerin Satış Miktarları Alış Miktarlarından Fazladır. Lütfen Kontrol Ediniz!\n"+list)				
			return false;
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
			if( typeof( document.getElementById("row_kontrol"+rm) ) != "undefined" && document.getElementById("row_kontrol"+rm) != null && document.getElementById("row_kontrol"+rm).value == 1){
				document.getElementById("nominal_value"+rm).value =  filterNum(document.getElementById("nominal_value"+rm).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				document.getElementById("sale_value"+rm).value =  filterNum(document.getElementById("sale_value"+rm).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				document.getElementById("total_sale"+rm).value =  filterNum(document.getElementById("total_sale"+rm).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				document.getElementById("other_nominal_value"+rm).value =  filterNum(document.getElementById("other_nominal_value"+rm).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				document.getElementById("other_sale_value"+rm).value =  filterNum(document.getElementById("other_sale_value"+rm).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				document.getElementById("quantity"+rm).value =  filterNum(document.getElementById("quantity"+rm).value,'4');
				document.getElementById("other_total_sale"+rm).value =  filterNum(document.getElementById("other_total_sale"+rm).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			}
		}
		document.getElementById("action_value").value = filterNum(document.getElementById("action_value").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("sale_other").value = filterNum(document.getElementById("sale_other").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("com_rate").value = filterNum(document.getElementById("com_rate").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("com_ytl").value = filterNum(document.getElementById("com_ytl").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("com_other").value = filterNum(document.getElementById("com_other").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("total_income").value = filterNum(document.getElementById("total_income").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("total_income_other").value = filterNum(document.getElementById("total_income_other").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("nominal_total_amount").value = filterNum(document.getElementById("nominal_total_amount").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("other_nominal_total_amount").value = filterNum(document.getElementById("other_nominal_total_amount").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		for(st=1;st<=document.getElementById("kur_say").value;st++)
		{
			document.getElementById("txt_rate2_"+ st).value = filterNum(document.getElementById("txt_rate2_" + st).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			document.getElementById("txt_rate1_"+st).value = filterNum(document.getElementById("txt_rate1_"+ st).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
	}
	function f_add_bond()
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_stockbonds&field_id=add_bond.stockbond_id','wide');
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