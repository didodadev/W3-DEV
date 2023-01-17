<input type="hidden" name="control_field_value" id="control_field_value" value="">
<cfquery name="get_tax" datasource="#dsn2#">
	SELECT * FROM SETUP_TAX ORDER BY TAX
</cfquery>
<cfquery name="get_otv" datasource="#dsn3#">
	SELECT * FROM SETUP_OTV WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.PERIOD_ID#">
</cfquery>
<cfquery name="get_expense_item" datasource="#dsn2#">
	SELECT IS_ACTIVE,EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE  IS_ACTIVE=1 AND IS_EXPENSE = 1  ORDER BY EXPENSE_ITEM_NAME
</cfquery>
<cfquery name="get_expense_center" datasource="#dsn2#">
	SELECT
		EXPENSE_ID,
		EXPENSE_CODE,
		EXPENSE
	FROM
		EXPENSE_CENTER
	WHERE
		EXPENSE_ID IS NOT NULL
	<cfif listgetat(attributes.fuseaction,1,'.') is 'store'>
		AND EXPENSE_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">
	</cfif>
	<cfif not (isdefined("attributes.budget_plan_id") or isdefined("attributes.credit_contract_id") or isdefined("attributes.expense_id") or isdefined("attributes.request_id"))>
		AND EXPENSE_ACTIVE = 1<!--- kopyalamadan,talepten vs dışında gelen kayıtlarda sadece aktifler gelir--->
	</cfif>
	ORDER BY
		EXPENSE
</cfquery>
<div style="position:absolute;margin-left:35px;margin-top:30px" id="open_process"></div>
<cf_grid_list sort="0">
	<thead>
		<tr>					
			<th>
				<cfif isdefined("get_virman_rows.recordcount")>
					<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_virman_rows.recordcount#</cfoutput>">
				<cfelse>
					<input type="hidden" name="record_num" id="record_num" value="0">
				</cfif>
				<ul class="ui-icon-list">
					<li><a href="javascript:void(0)" onClick="add_row();"><i class="fa fa-plus"></i></a></li>
				</ul>
			</th>
			<th><cf_get_lang dictionary_id='57867.Borç/Alacak'></th>
			<th><cf_get_lang dictionary_id='54021.Hesap Cinsi'></th>
			<th><cf_get_lang dictionary_id='57652.Hesap'></th>
			<th><cf_get_lang dictionary_id='57629.Açıklama'>*</th>
			<th><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th>
			<th><cf_get_lang dictionary_id='58551.Gider Kalemi'></th>
			<th><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></th>
			<th><cf_get_lang dictionary_id='57673.Tutar'></th>
			<!--- <th style="min-width:30px;"><cf_get_lang dictionary_id='57639.KDV'>%</th>
			<th style="min-width:30px;"><cf_get_lang dictionary_id='58021.ÖTV'>%</th>
			<th><cf_get_lang dictionary_id='57639.KDV'></th>
			<th><cf_get_lang dictionary_id='58021.ÖTV'></th> --->
			<th><cf_get_lang dictionary_id='57680.KDV li Toplam'></th>
			<th><cf_get_lang dictionary_id='57489.Para Br'></th>
			<th><cf_get_lang dictionary_id='58056.Dövizli Tutar'></th>
			<th><cf_get_lang dictionary_id='57416.Proje'></th>
		</tr>
	</thead>
	<tbody  name="table1" id="table1">
		<cfif isdefined("get_virman_rows.recordcount") and len(get_virman_rows.recordcount)>
			<cfoutput query="get_virman_rows">
				<tr id="frm_row#currentrow#" name="frm_row#currentrow#">
					<td>
						<input type="hidden" name="quantity#currentrow#" id="quantity#currentrow#" value="1">
						<input type="hidden" value="js_create_unique_id()" name="wrk_row_id#currentrow#" id="wrk_row_id#currentrow#">
						<input type="hidden" value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#">
						<ul class="ui-icon-list">
							<li><a href="javascript://" onclick="sil(#currentrow#);"><i class="fa fa-minus"></i></a></li>
							<li><a style="cursor:pointer" onclick="copy_row(#currentrow#);" title="<cf_get_lang dictionary_id='58972.Satır Kopyala'>"><i class="fa fa-copy"></i></a></li>
						</ul>
					</td>
					<td>
						<div class="form-group">
							<select id="ba#currentrow#" name="ba#currentrow#" onchange="get_ba_status(#currentrow#);hesapla('total',#currentrow#);">
								<option value="0" <cfif BA EQ 0>selected</cfif>><cf_get_lang dictionary_id='57587.Borç'></option>
								<option value="1" <cfif BA EQ 1>selected</cfif>><cF_get_lang dictionary_id='57588.Alacak'></option>
							</select>
						</div>
					</td>
					<td>
						<div class="form-group">
							<select name="action_type#currentrow#" id="action_type#currentrow#" onchange="get_action_type(#currentrow#);">
								<option value="" <cfif LEN(CENTER_ID) AND LEN(ITEM_ID)>selected</cfif>><cf_get_lang dictionary_id='58930.Masraf'>/<cf_get_lang dictionary_id='58677.Gelir'></option>
								<option value="1" <cfif LEN(BANK_ID)>selected</cfif>><cf_get_lang dictionary_id='57521.Banka'></option>
								<option value="2" <cfif LEN(CASH_ID)>selected</cfif>><cf_get_lang dictionary_id='57520.Kasa'></option>
								<option value="3" <cfif LEN(COMPANY_ID) or LEN(CONSUMER_ID) or len(employee_id)>selected</cfif>><cf_get_lang dictionary_id='58061.Cari'></option>
								<option value="4" <cfif LEN(account_code) and not len(item_id) and not (LEN(COMPANY_ID) or LEN(CONSUMER_ID) or len(employee_id) or len(BANK_ID) or len(CASH_ID))>selected</cfif>><cf_get_lang dictionary_id='57447.Muhasebe'></option>
							</select>
						</div>
					</td>
					<cfset ch_partner_type_value = "">
					<cfset member_id = "">
					<cfset member_name = "">
					<cfif len(COMPANY_ID)>
						<cfquery name="get_company_name" datasource="#dsn#">
							SELECT 
								C.MEMBER_CODE + ' - ' + C.FULLNAME AS COMPANYNAME
							FROM 
								COMPANY C
							WHERE 
								C.COMPANY_ID = #COMPANY_ID#
						</cfquery>
						<cfset member_id = len(ACC_TYPE_ID) ? COMPANY_ID&'_'&ACC_TYPE_ID : COMPANY_ID>
						<cfset member_name = get_company_name.COMPANYNAME>
						<cfset ch_partner_type_value = "partner">
					</cfif>
					<cfif len(CONSUMER_ID)>
						<cfquery name="get_consumer_name" datasource="#dsn#">
							SELECT 
								C.CONSUMER_NAME + ' ' + C.CONSUMER_SURNAME AS CONSUMER_NAME
							FROM 
								CONSUMER C
							WHERE 
								C.CONSUMER_ID = #CONSUMER_ID#
						</cfquery>
						<cfset member_id = len(ACC_TYPE_ID) ? CONSUMER_ID&'_'&ACC_TYPE_ID : CONSUMER_ID>
						<cfset member_name = get_consumer_name.CONSUMER_NAME>
						<cfset ch_partner_type_value = "consumer">
					</cfif>
					<cfif len(employee_id)>
						<cfquery name="get_emp" datasource="#dsn#">
							SELECT  CAST(EMPLOYEE_ID AS varchar) + ' - ' + EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS EMP_NAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #employee_id#
						</cfquery>
						<cfset member_id = employee_id&'_'&ACC_TYPE_ID>
						<cfset member_name = get_emp.EMP_NAME>
						<cfset ch_partner_type_value = "employee">
					</cfif>
					<td>
						<div class="form-group">
							<select <cfif not LEN(CASH_ID)>style="display:none;"</cfif> name="kasa#currentrow#" id="kasa#currentrow#" style="<cfif not len(cash_id)>display:none;</cfif>"><option value=""><cf_get_lang dictionary_id='50246.Kasa Seçiniz'></option><cfloop query="kasa"><option value="#cash_id#;#cash_currency_id#;#branch_id#" <cfif get_virman_rows.CASH_ID EQ cash_id>selected</cfif>>#cash_name#-#cash_currency_id#</option></cfloop></select>
							<select <cfif not LEN(BANK_ID)>style="display:none;"</cfif> name="banka#currentrow#" id="banka#currentrow#" style="<cfif not len(bank_id)>display:none;</cfif>"><option value=""><cf_get_lang dictionary_id='58940.Banka Seçiniz'></option><cfloop query="queryResult"><option value="#account_id#" <cfif get_virman_rows.BANK_ID EQ account_id>selected</cfif>>#account_name#&nbsp;#account_currency_id#</option></cfloop></select>
						</div>
						<div class="form-group" id="item-company">
								<input type="hidden" name="ch_member_type#currentrow#" id="ch_member_type#currentrow#" value="#ch_partner_type_value#">
								<input type="hidden" <cfif LEN(COMPANY_ID) or LEN(CONSUMER_ID) or len(employee_id)><cfelse>style="display:none;"</cfif> readonly name="ch_account_code#currentrow#" id="ch_account_code#currentrow#" value="#ch_account_code#">
								<input type="hidden" <cfif LEN(COMPANY_ID) or LEN(CONSUMER_ID) or len(employee_id)><cfelse>style="display:none;"</cfif> name="ch_member_id#currentrow#" id="ch_member_id#currentrow#" value="#member_id#">
								<div class="input-group">
									<input name="ch_member#currentrow#" type="text" id="ch_member#currentrow#" style="<cfif not len(company_id) and not len(employee_id) and not len(consumer_id)>display:none;</cfif>" value="#member_name#" readonly>
									<span class="input-group-addon icon-ellipsis btnPointer" onClick="get_member(#currentrow#);" id="image_ch_company#currentrow#" style="<cfif not len(company_id) and not len(CONSUMER_ID) and not len(employee_id)>display:none;</cfif>"></span>
								</div>
							</div>
					</td>
					<td>
						<div class="form-group">
							<input type="text" name="row_detail#currentrow#" id="row_detail#currentrow#" class="boxtext" value="#ACTION_DETAIL#">
						</div>
					</td>
					<td>
						<div class="form-group">
							<div class="input-group">
								<input type="hidden" name="expense_center_id#currentrow#" id="expense_center_id#currentrow#" value="#CENTER_ID#">
								<input type="text" value="#center_name#" id="expense_center_name#currentrow#" name="expense_center_name#currentrow#" onFocus="AutoComplete_Create('expense_center_name#currentrow#','EXPENSE,EXPENSE_CODE','EXPENSE,EXPENSE_CODE','get_expense_center','0','EXPENSE_ID','expense_center_id#currentrow#','add_costplan',1);" class="boxtext">
								<span class="input-group-addon btnPointer icon-ellipsis" id="image_expense_center_name#currentrow#"  href="javascript://" onClick="pencere_ac_exp(#currentrow#);"></span>							
							</div>
						</div>
					</td>
					<td>
						<div class="form-group">
							<div class="input-group">
								<input type="hidden" name="expense_item_id#currentrow#" id="expense_item_id#currentrow#" value="#ITEM_ID#">
								<input type="text" id="expense_item_name#currentrow#" name="expense_item_name#currentrow#" value="#ITEM_NAME#" onFocus="AutoComplete_Create('expense_item_name#currentrow#','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID,ACCOUNT_CODE','expense_item_id#currentrow#,account_code#currentrow#','add_costplan',1);" class="boxtext">
								<span class="input-group-addon btnPointer icon-ellipsis" id="image_expense_item_name#currentrow#"  href="javascript://" onClick="pencere_ac_item(#currentrow#,0);"></span>
							</div>
						</div>
					</td>							
					<td>
						<div class="form-group">
							<div class="input-group">
							<input type="text" id="account_code#currentrow#" name="account_code#currentrow#" onFocus="AutoComplete_Create('account_code#currentrow#','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','','','','3','225');" class="boxtext"  value="#account_code#">
							<span class="input-group-addon btnPointer icon-ellipsis" id="account_code_image_ch#currentrow#" href="javascript://"  onclick="pencere_ac_acc(#currentrow#);"></span>
							</div>
						</div>
					</td>
					<td>
						<div class="form-group">
							<cfinput type="text" name="total#currentrow#" value="#TLFormat(ACTION_VALUE,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,#xml_satir_number#));" onBlur="hesapla('total',#currentrow#);" class="box">
						</div>
					</td>
					<!--- <td>
						<div class="form-group">
							<select name="tax_rate#currentrow#" id="tax_rate#currentrow#" style="width:100%;" class="box" onChange="hesapla('tax_rate','#currentrow#');">
								<cfif isdefined("kdv_rate")><cfset kdvdeger = kdv_rate><cfelse><cfset kdvdeger = ""></cfif>
								<cfloop query="get_tax">
									<option value="#tax#" <cfif kdvdeger eq tax>selected</cfif>>#tax#</option>
								</cfloop>
							</select>
						</div>
					</td>
					<td><div class="form-group"><cfinput type="text" name="otv_rate#currentrow#" value="0" onKeyUp="return(FormatCurrency(this,event,0));" onBlur="hesapla('otv_rate','#currentrow#');" class="box" ></div></td>
					<td><div class="form-group"><cfinput type="text" name="kdv_total#currentrow#" value="0" onKeyUp="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="hesapla('kdv_total','#currentrow#',1);" class="moneybox"></div></td>
					<td><div class="form-group"><cfinput type="text" name="otv_total#currentrow#" value="0" onKeyUp="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="hesapla('otv_total','#currentrow#',1);" class="moneybox"></div></td> --->
					<td><div class="form-group"><cfinput type="text" name="net_total#currentrow#" value="#TLFormat(ACTION_VALUE,session.ep.our_company_info.rate_round_num)#" onKeyUp="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="hesapla('net_total','#currentrow#',2);" class="moneybox" ></div></td>
					<td><div class="form-group"><select name="money_id#currentrow#" id="money_id#currentrow#" <!--- total_value="#ACTION_VALUE#" ---> class="boxtext money_class" onChange="other_calc('#currentrow#');">
						<cfloop query="get_money">
							<cfif isdefined("money")><cfset money_ = money><cfelse><cfset money_money_type></cfif>
							<option value="#money_#,#rate1#,#rate2#" <cfif get_virman_rows.other_money eq money_>selected</cfif>>#money_#</option>
						</cfloop>
					</select></div></td>
					<td><div class="form-group"><cfinput type="text" name="other_net_total#currentrow#" value="#TLFormat(ACTION_VALUE,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="other_calc('#currentrow#');" style="width:100%;" class="moneybox"></div></td>
					<td>
						<div class="form-group">
							<div class="input-group">
								<input type="hidden" name="project_id#currentrow#" value="<cfif isdefined("project_id") and len(project_id)>#project_id#</cfif>">
								<input type="text" name="project#currentrow#" value="<cfif isdefined("project_id") and len(project_id)>#get_project_name(project_id)#</cfif>" autocomplete="off" class="boxtext" >
								<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_ac_project('#currentrow#');"></span>
							</div>
						</div>	
					</td>
				</tr>
			</cfoutput>
		</cfif>
	</tbody> 
</cf_grid_list>
<div class="ui-row">
	<div id="sepetim_total" class="padding-0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
			<div class="totalBox">
				<div class="totalBoxHead font-grey-mint">
					<span class="headText"> <cf_get_lang dictionary_id='57677.Döviz'> </span>
					<div class="collapse">
						<span class="icon-minus"></span>
					</div>
				</div>				
				<div class="totalBoxBody">
					<table cellspacing="0" id="money_rate_table">
						<tbody>
							<cfif session.ep.rate_valid eq 1>
								<cfset readonly_info = "yes">
							<cfelse>
								<cfset readonly_info = "no">
							</cfif>
							<cfif get_money.recordcount>
								<cfquery name="get_standart_process_money" datasource="#dsn#"><!--- muhasebe doneminden standart islem dövizini alıyor --->
									SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
								</cfquery>
								<cfif IsQuery(get_standart_process_money) and len(get_standart_process_money.STANDART_PROCESS_MONEY)><!--- muhasebe doneminden standart islem dövizi işlemleri için --->
									<cfset default_basket_money_=get_standart_process_money.STANDART_PROCESS_MONEY>
								<cfelseif len(session.ep.money2)>
									<cfset default_basket_money_=session.ep.money2>
								<cfelse>
									<cfset default_basket_money_=session.ep.money>
								</cfif>
								<cfoutput><input type="hidden" name="kur_say" id="kur_say" value="#iif(isdefined("attributes.virman_id") and ( isdefined("attributes.event") and attributes.event eq 'upd' ), "GET_VIRMAN_MONEY.recordcount", DE('#get_money.recordcount#'))#"></cfoutput>
								<input type="hidden" name="money_type" id="money_type" value="<cfoutput>#session.ep.money#</cfoutput>">
								<cfset str_money_bskt_found = true>
								<cfset queryname = ( isdefined("attributes.virman_id") and ( isdefined("attributes.event") and attributes.event eq 'upd' ) ? "GET_VIRMAN_MONEY" : "GET_MONEY" ) >
								<cfoutput query="#queryname#">
									<cfif IS_SELECTED>
										<cfset str_money_bskt = money>
										<cfset str_money_bskt_found = false>
									<cfelseif str_money_bskt_found and money eq default_basket_money_>
										<cfset str_money_bskt = money>
										<cfset str_money_bskt_found = false>
									</cfif>
										<tr>
											<cfif session.ep.rate_valid eq 1>
												<cfset readonly_info = "yes">
											<cfelse>
												<cfset readonly_info = "no">
											</cfif>
											<input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
											<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
											<td nowrap="nowrap"><input type="radio" name="rd_money" id="rd_money" value="#money#,#currentrow#,#rate1#,#rate2#" onClick="other_calc();" <cfif isDefined('str_money_bskt') and str_money_bskt eq money>checked</cfif>></td>
											<td nowrap="nowrap">#money#</td>
											<td nowrap="nowrap">#TLFormat(rate1,0)# /</td>
											<td nowrap="nowrap"><input type="text" name="txt_rate2_#currentrow#" money_type="#money#" id="txt_rate2_#currentrow#" <cfif readonly_info>readonly</cfif> class="box" <cfif money eq session.ep.money>readonly="yes"</cfif> value="#TLFormat(rate2,xml_genel_number)#" onkeyup="return(FormatCurrency(this,event,#xml_genel_number#));" onBlur="other_calc();"></td>
										</tr>
								</cfoutput>
							</cfif>
						</tbody>
					</table>
				</div>
			</div>
		</div>
		<div class="col col-5 col-md-5 col-sm-5 col-xs-12">
			<div class="totalBox">
				<div class="totalBoxHead font-grey-mint">
					<span class="headText"> <cf_get_lang dictionary_id='57492.Toplam'> </span>
					<div class="collapse">
						<span class="icon-minus"></span>
					</div>
				</div>
				<div class="totalBoxBody">       
					<table>
						<tbody>
							<cfoutput query="get_money">
								<tr>
									<td>#money#</td>
									<td  style="text-align:right;">
										<div class="form-group mt-0">
											<div class="input-group">
												<input id="deger_artis_#money#" name="deger_artis_#money#" value="0" class="box" readonly>
												<span class="input-group-addon btn-pointer" style="background:none;border:1px solid ##eee;padding:7px 9px;"><strong>0</strong></span>
											</div>
										</div>
									</td>
								</tr>
								
							</cfoutput>
							<tr>
								<td colspan="2"><span class="bold"><cf_get_lang dictionary_id='57492.Toplam'></span></td>
							</tr>
							<tr>
								<td><cfoutput>#session.ep.money#</cfoutput></td>
								<td  style="text-align:right;">
									<div class="form-group mt-0">
										<div class="input-group">
											<input id="deger_artis_system" name="deger_artis_system" value="0" class="box" readonly>
											<span class="input-group-addon btn-pointer" style="background:none;border:1px solid #eee;padding:7px 9px;"><strong>0</strong></span>
										</div>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
		<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
			<div class="totalBox">
				<div class="totalBoxHead font-grey-mint">
					<span class="headText"><cf_get_lang dictionary_id='57492.Toplam'></span>
					<div class="collapse">
						<span class="icon-minus"></span>
					</div>
				</div>
				<div class="totalBoxBody" id="totalAmountList">  
					<table>
						<tbody>
							<tr>
								<td><label><b><cf_get_lang dictionary_id='57587.Borç'></b></label></td>
								<td style="text-align:right;"><input type="text" name="borc_toplam" id="borc_toplam" class="box" readonly="" value="0" onkeyup="return(FormatCurrency(this,event,2));"></td>
								<td><strong><cfoutput>#session.ep.money#</cfoutput></strong></td>
							</tr>
							<tr>
								<td><label><b><cF_get_lang dictionary_id='57588.Alacak'></b></label></td>
								<td style="text-align:right;"><input type="text" name="alacak_toplam" id="alacak_toplam" class="box" readonly="" value="0" onkeyup="return(FormatCurrency(this,event,2));"></td>
								<td><strong><cfoutput>#session.ep.money#</cfoutput></strong></td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>
<cfoutput>
<table>
	<tr>
		<!--- <td class="sepetim_total_table_tutar_td" valign="top">
		<table>
				<tr>
					<td colspan="3" class="txtbold"><cf_get_lang dictionary_id='57677.Dövizler'></td>
				</tr>
				<cfquery name="get_standart_process_money" datasource="#dsn#"><!--- muhasebe doneminden standart islem dövizini alıyor --->
					SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
				</cfquery>
				<cfif IsQuery(get_standart_process_money) and len(get_standart_process_money.STANDART_PROCESS_MONEY)><!--- muhasebe doneminden standart islem dövizi işlemleri için --->
					<cfset default_basket_money_=get_standart_process_money.STANDART_PROCESS_MONEY>
				<cfelseif len(session.ep.money2)>
					<cfset default_basket_money_=session.ep.money2>
				<cfelse>
					<cfset default_basket_money_=session.ep.money>
				</cfif>
				<input type="hidden" name="kur_say" id="kur_say" value="#get_money.recordcount#">
				<cfset str_money_bskt_found = true>
				<cfloop query="get_money">
					<cfif IS_SELECTED>
						<cfset str_money_bskt = money>
						<cfset str_money_bskt_found = false>
					<cfelseif str_money_bskt_found and money eq default_basket_money_>
						<cfset str_money_bskt = money>
						<cfset str_money_bskt_found = false>
					</cfif>
					<cfif currentrow mod 2 eq 1>
						<tr>
					</cfif>
							<td>
								<input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
								<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
								<input type="radio" name="rd_money" id="rd_money" value="#money#,#currentrow#,#rate1#,#rate2#" onClick="other_calc();" <cfif isDefined('str_money_bskt') and str_money_bskt eq money>checked</cfif>>#money#
							</td>
							<cfif session.ep.rate_valid eq 1>
								<cfset readonly_info = "yes">
							<cfelse>
								<cfset readonly_info = "no">
							</cfif>
							<td valign="bottom">#TLFormat(rate1,0)#/<input type="text" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" <cfif readonly_info>readonly</cfif> class="box" <cfif money eq session.ep.money>readonly="yes"</cfif> value="#TLFormat(rate2,xml_genel_number)#" onkeyup="return(FormatCurrency(this,event,#xml_genel_number#));" onBlur="other_calc();"></td>
					<cfif currentrow mod 2 eq 0>
						</tr>
					</cfif>
				</cfloop>
			</table>
		</td> 
		<td class="sepetim_total_table_tutar_td" valign="top">
			<table>
				<tr>
					<td height="20" align="right" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></td>
					<td align="right" style="text-align:right;"><input type="text" name="total_amount" id="total_amount" class="box" readonly="" value="0">&nbsp;&nbsp;#session.ep.money#</td>
				</tr>
				<tr>
					<td align="right" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='33213.Toplam KDV'></td>
					<td align="right" style="text-align:right;"><input type="text" name="kdv_total_amount" id="kdv_total_amount" class="box" readonly="" value="0">&nbsp;&nbsp;#session.ep.money#</td>
				</tr>
				<tr>
					<td align="right" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57680.KDV li Toplam'></td>
					<td align="right" style="text-align:right;"><input type="text" name="net_total_amount" id="net_total_amount" class="box" readonly="" value="0">&nbsp;&nbsp;#session.ep.money#</td>
				</tr>
			</table>
		</td>
		<td class="sepetim_total_table_tutar_td" valign="top">
			<table>
				<tr>
					<td align="right" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='58124.Döviz Toplam'></td>
					<td align="right" id="rate_value1" style="text-align:right;"><input type="text" name="other_total_amount" id="other_total_amount" class="box" readonly="" value="0">&nbsp;<input type="text" name="tl_value1" id="tl_value1" class="box" readonly="" value=""></td>
				</tr>
				<tr>
					<td align="right" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='33214.Döviz KDV'></td>
					<td align="right" id="rate_value2" style="text-align:right;"><input type="text" name="other_kdv_total_amount" id="other_kdv_total_amount" class="box" readonly="" value="0">&nbsp;<input type="text" name="tl_value2" id="tl_value2" class="box" readonly="" value=""></td>
				</tr>
				<tr>
					<td align="right" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='33215.Döviz KDV li Toplam'></td>
					<td align="right" id="rate_value3" style="text-align:right;"><input type="text" name="other_net_total_amount" id="other_net_total_amount" class="box" readonly="" value="0">&nbsp;<input type="text" name="tl_value3" id="tl_value3" class="box" readonly="" value=""></td>
				</tr>
			</table>
		</td>--->
		<!--- <td valign="top">
			<table>
				<tr>
					<td align="right" class="txtbold" style="text-align:right;">Borç Toplam</td>
					<td align="right" id="rate_value1" style="text-align:right;"><input type="text" name="borc_toplam" id="borc_toplam" class="box" readonly="" value="0">&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
				</tr>
				<tr>
					<td align="right" class="txtbold" style="text-align:right;">Alacak Toplam</td>
					<td align="right" id="rate_value2" style="text-align:right;"><input type="text" name="alacak_toplam" id="alacak_toplam" class="box" readonly="" value="0">&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
				</tr>
				<tr>
					<td align="right" class="txtbold" style="text-align:right;">Fark Toplam</td>
					<td align="right" id="rate_value3" style="text-align:right;"><input type="text" name="fark_toplam" id="fark_toplam" class="box" readonly="" value="0">&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
				</tr>
			</table>
		</td> --->
	</tr>
</table>
</cfoutput>
<cfif isdefined("url.virman_id") and not(cgi.referer contains 'event=upd')>
	<div class="ui-form-list-btn">
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<cf_record_info query_name="get_data">
		</div>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<cf_workcube_buttons is_upd='1' delete_page_url='V16/finance/cfc/genel_virman.cfc?method=dlt_genel_virman&virman_id=#url.virman_id#' add_function='kontrol()'>
		</div>
	</div>
<cfelse>
	<div class="ui-form-list-btn">
		<cf_workcube_buttons is_upd='0' add_function="kontrol()">
	</div>
</cfif>	
<script type="text/javascript">
var row_count=0;
var row_count_ilk=0;

<cfif isdefined("get_virman_rows.recordcount") and len(get_virman_rows.recordcount)>
	<cfoutput query="get_virman_rows">
		get_action_type('#currentrow#');
	</cfoutput>
</cfif>

function get_ba_status(no)
{
	document.getElementById("expense_item_id"+no).value='';
	document.getElementById("expense_item_name"+no).value='';	
}

function get_action_type(no)
{
	type_ = document.getElementById("action_type"+no).value;
	document.getElementById('banka'+no).style.display='none';
	document.getElementById('kasa'+no).style.display='none';
	document.getElementById('ch_member'+no).style.display='none';
	document.getElementById('image_ch_company'+no).style.display='none';
	document.getElementById('account_code'+no).style.display='';<!--- muhasebe kodu --->
	document.getElementById('account_code_image_ch'+no).style.display='';<!--- muhasebe kodu --->
	document.getElementById('expense_center_name'+no).style.display='';<!--- masraf merkezi --->
	document.getElementById('image_expense_center_name'+no).style.display='';<!--- masraf merkezi --->
	document.getElementById('expense_item_name'+no).style.display='';<!--- gider kalemi --->
	document.getElementById('image_expense_item_name'+no).style.display='';<!--- gider merkezi --->

	if(type_==1)
	{
		document.getElementById('banka'+no).style.display='';
		document.getElementById('account_code'+no).style.display='none';<!--- muhasebe kodu --->
		document.getElementById('account_code_image_ch'+no).style.display='none';<!--- muhasebe kodu --->
		document.getElementById('expense_center_name'+no).style.display='none';<!--- masraf merkezi --->
		document.getElementById('image_expense_center_name'+no).style.display='none';<!--- masraf merkezi --->
		document.getElementById('expense_item_name'+no).style.display='none';<!--- gider kalemi --->
		document.getElementById('image_expense_item_name'+no).style.display='none';<!--- gider merkezi --->
	}
	else if(type_==2)
	{
		document.getElementById('kasa'+no).style.display='';
		document.getElementById('account_code'+no).style.display='none';<!--- muhasebe kodu --->
		document.getElementById('account_code_image_ch'+no).style.display='none';<!--- muhasebe kodu --->
		document.getElementById('expense_center_name'+no).style.display='none';<!--- masraf merkezi --->
		document.getElementById('image_expense_center_name'+no).style.display='none';<!--- masraf merkezi --->
		document.getElementById('expense_item_name'+no).style.display='none';<!--- gider kalemi --->
		document.getElementById('image_expense_item_name'+no).style.display='none';<!--- gider merkezi --->
	}
	else if(type_==3)
	{
		document.getElementById('ch_member'+no).style.display='';
		document.getElementById('image_ch_company'+no).style.display='';
		///Cari hesap türünde muhasebe kodu zorunlu alan haline getirildi.
	/* 	document.getElementById('account_code'+no).style.display='none';<!--- muhasebe kodu ---> 
		document.getElementById('account_code_image_ch'+no).style.display='none';<!--- muhasebe kodu ---> */
		document.getElementById('expense_center_name'+no).style.display='none';<!--- masraf merkezi --->
		document.getElementById('image_expense_center_name'+no).style.display='none';<!--- masraf merkezi --->
		document.getElementById('expense_item_name'+no).style.display='none';<!--- gider kalemi --->
		document.getElementById('image_expense_item_name'+no).style.display='none';<!--- gider merkezi --->
	}else if(type_==4){
		document.getElementById('expense_center_name'+no).style.display='none';<!--- masraf merkezi --->
		document.getElementById('image_expense_center_name'+no).style.display='none';<!--- masraf merkezi --->
		document.getElementById('expense_item_name'+no).style.display='none';<!--- gider kalemi --->
		document.getElementById('image_expense_item_name'+no).style.display='none';<!--- gider merkezi --->

	}
}

function get_member(no)
{
	adres_ = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_cari_action=1&is_multi_act=1';
	adres_ += '&field_comp_id=add_costplan.ch_member_id'+no;
	adres_ += '&field_comp_name=add_costplan.ch_member'+no;	
	adres_ += '&field_consumer=add_costplan.ch_member_id'+no;
	adres_ += '&field_member_name=add_costplan.ch_member'+no;
	adres_ += '&field_emp_id=add_costplan.ch_member_id'+no;
	adres_ += '&field_name=add_costplan.ch_member'+no;
	adres_ += '&field_type=add_costplan.ch_member_type'+no;
	adres_ += '&field_member_account_code=add_costplan.ch_account_code'+no;
	//adres_ += '&field_basket_due_value_rev=add_costplan.basket_due_value';
	//adres_ += '&call_function=change_due_date()';
	adres_ += '&select_list=1,2,3';
	windowopen(adres_,'list');
}
function sil(sy)
{
	document.getElementById("row_kontrol"+sy).value=0;
	var my_element=eval("frm_row"+sy);
	my_element.style.display="none";
	toplam_hesapla();
	MoneyClass();
	//satir_say--;
}

function add_row(row_detail,exp_center,exp_center_id,exp_item,exp_item_id,exp_project_id,exp_project,exp_product_id,exp_spect_var_id,exp_spect_name,exp_stock_id,exp_product_name,exp_stock_unit,exp_stock_unit_id,exp_member_type,exp_member_id,exp_company_id,exp_company,exp_authorized,exp_net_total,exp_tax_total,exp_otv_total,exp_tax_rate,exp_money_type,exp_act_id,exp_work_id,exp_subs_id,exp_subs_name,exp_asset_id,exp_asset_name,account_code,expense_date,row_work_id,row_work_head,exp_opp_id,exp_opp_head,otv_rate)
{
	row_count=parseInt(document.getElementById("record_num").value);
	
	if (row_detail == undefined) row_detail ="";
	if (exp_center == undefined) exp_center ="";
	if (exp_item == undefined) exp_item ="";
	if (exp_center_id == undefined) exp_center_id ="";
	if (exp_item_id == undefined) exp_item_id ="";
	
	if (exp_project_id == undefined) exp_project_id ="";
	if (exp_project == undefined) exp_project ="";
	if (exp_product_id == undefined) exp_product_id ="";
	if (exp_stock_id == undefined) exp_stock_id ="";
	if (exp_product_name == undefined) exp_product_name ="";
	if (exp_spect_var_id == undefined) exp_spect_var_id ="";
	if (exp_spect_name == undefined) exp_spect_name ="";
	
	if (exp_stock_unit == undefined) exp_stock_unit ="";
	if (exp_stock_unit_id == undefined) exp_stock_unit_id ="";
	
	if (exp_member_id == undefined) exp_member_id ="";
	if (exp_member_type == undefined) exp_member_type ="";
	if (exp_company_id == undefined) exp_company_id ="";
	if (exp_authorized == undefined) exp_authorized ="";
	if (exp_company == undefined) exp_company ="";
	
	if (exp_money_type == undefined) exp_money_type ="";
	if (exp_act_id == undefined) exp_act_id ="";
	if (exp_work_id == undefined) exp_work_id ="";
	if (exp_subs_id == undefined) exp_subs_id ="";
	if (exp_subs_name == undefined) exp_subs_name ="";
	if (exp_asset_id == undefined) exp_asset_id ="";
	if (exp_asset_name == undefined) exp_asset_name ="";
	if (account_code == undefined) account_code ="";
	if (expense_date == undefined) expense_date ="";
	if (row_work_id == undefined) row_work_id ="";
	if (row_work_head == undefined) row_work_head ="";
	if (exp_opp_id == undefined) exp_opp_id ="";
	if (exp_opp_head == undefined) exp_opp_head ="";
	/* if (exp_net_total == undefined) */ exp_net_total ="0";
	/*if (exp_tax_total == undefined) */ exp_tax_total ="0";
	/*if (exp_otv_total == undefined) */exp_otv_total ="0";
	/*if (otv_rate == undefined || otv_rate == '') */ otv_rate ="0";
	/*if (exp_tax_rate == undefined || exp_tax_rate == '') */ exp_tax_rate ="0";
	<cfif len(session.ep.other_money)>
		if(exp_money_type == '')
		{
			<cfoutput query="get_money">
				if('#money#' == '#session.ep.other_money#')
					exp_money_type = "#money#,#rate1#,#rate2#";
			</cfoutput>			
		}
	</cfif>
	rate_round_num_ = "<cfoutput>#xml_satir_number#</cfoutput>";
	if(rate_round_num_ == "") rate_round_num_ = "2";
	
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
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("nowrap","nowrap");
	newCell.innerHTML = '<input type="hidden" name="quantity' + row_count +'" id="quantity' + row_count +'" value="1">';
	newCell.innerHTML += '<input  type="hidden" value="'+js_create_unique_id()+'" name="wrk_row_id' + row_count +'" id="wrk_row_id' + row_count +'"><input type="hidden" value="1" name="row_kontrol'+row_count+'" id="row_kontrol'+row_count+'"><ul class="ui-icon-list"><li><a href="javascript://" onclick="sil(' + row_count + ');"><i class="fa fa-minus"></i></li></a><li><a href="javascript://" onclick="copy_row('+row_count+');"><i class="fa fa-copy"></i></li></ul></a>';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("nowrap","nowrap");
	newCell.innerHTML = '<div class="form-group"><select id="ba'+ row_count +'" name="ba'+ row_count +'" onchange="get_ba_status('+row_count+');hesapla(\'total\','+row_count+');"><option value="0"><cf_get_lang dictionary_id='57587.Borç'></option><option value="1"><cF_get_lang dictionary_id='57588.Alacak'></option></select></div>';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("nowrap","nowrap");
	newCell.innerHTML = '<div class="form-group"><select name="action_type'+ row_count +'" id="action_type'+ row_count +'" onchange="get_action_type('+row_count+');"><option value=""><cf_get_lang dictionary_id='58930.Masraf'>/<cf_get_lang dictionary_id='58677.Gelir'></option><option value="1"><cf_get_lang dictionary_id='57521.Banka'></option><option value="2"><cf_get_lang dictionary_id='57520.Kasa'></option><option value="3"><cf_get_lang dictionary_id='58061.Cari'></option><option value="4"><cf_get_lang dictionary_id='57447.Muhasebe'></option></select></div>';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("nowrap","nowrap");
	newCell.innerHTML = '';
	newCell.innerHTML += '<div class="form-group"><select name="kasa'+ row_count +'" id="kasa'+ row_count +'" style="width:270px;display:none;"><option value=""><cf_get_lang dictionary_id='50246.Kasa Seçiniz'></option><cfoutput query="kasa"><option value="#cash_id#;#cash_currency_id#;#branch_id#">#cash_name#-#cash_currency_id#</option></cfoutput></select><select name="banka'+ row_count +'" id="banka'+ row_count +'" style="width:270px;display:none;"><option value=""><cf_get_lang dictionary_id='58940.Banka Seçiniz'></option><cfoutput query="queryResult"><option value="#account_id#">#account_name#&nbsp;#account_currency_id#</option></cfoutput></select></div>';

	newCell.innerHTML += '<div class="form-group"><input type="hidden" name="ch_member_type'+ row_count +'" id="ch_member_type'+ row_count +'"><input type="hidden" name="ch_account_code'+ row_count +'" id="ch_account_code'+ row_count +'"><input type="hidden" name="ch_member_id'+ row_count +'" id="ch_member_id'+ row_count +'"></div>';
	newCell.innerHTML += '<div class="input-group"><input name="ch_member'+ row_count +'" type="text" id="ch_member'+ row_count +'" style="display:none;" readonly><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="get_member('+row_count+');" id="image_ch_company'+row_count+'" style="display:none;"></span></div>';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("nowrap","nowrap");
	newCell.innerHTML = '<div class="form-group"><input type="text" name="row_detail' + row_count +'" id="row_detail' + row_count +'" style="width:150px;" class="boxtext" value="'+row_detail+'"></div>';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("nowrap","nowrap");
	newCell.innerHTML ='<div class="form-group"><div class="input-group"><input type="hidden" name="expense_center_id' + row_count +'" id="expense_center_id' + row_count +'" value="'+exp_center_id+'"><input type="text" id="expense_center_name' + row_count +'" name="expense_center_name' + row_count +'" onFocus="AutoComplete_Create(\'expense_center_name' + row_count +'\',\'EXPENSE,EXPENSE_CODE\',\'EXPENSE,EXPENSE_CODE\',\'get_expense_center\',\'0\',\'EXPENSE_ID\',\'expense_center_id' + row_count +'\',\'add_costplan\',1);" value="'+exp_center+'"><span class="input-group-addon btnPointer icon-ellipsis" id="image_expense_center_name'+row_count+'" href="javascript://" onClick="pencere_ac_exp('+ row_count +');"></span></div></div>';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("nowrap","nowrap");
	newCell.innerHTML ='<div class="form-group"><div class="input-group"><input type="hidden" name="expense_item_id' + row_count +'" id="expense_item_id' + row_count +'" value="'+exp_item_id+'"><input type="text" id="expense_item_name' + row_count +'" name="expense_item_name' + row_count +'" value="'+exp_item+'" onFocus="AutoComplete_Create(\'expense_item_name' + row_count +'\',\'EXPENSE_ITEM_NAME\',\'EXPENSE_ITEM_NAME\',\'get_expense_item\',\'\',\'EXPENSE_ITEM_ID,ACCOUNT_CODE\',\'expense_item_id' + row_count +',account_code' + row_count +'\',\'add_costplan\',1);"><span class="input-group-addon btnPointer icon-ellipsis" id="image_expense_item_name'+row_count+'" href="javascript://" onClick="pencere_ac_item('+ row_count +',0);"></span></div></div>';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("nowrap","nowrap");
	newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" style="width:150px;" id="account_code' + row_count +'" name="account_code' + row_count +'" onFocus="AutoComplete_Create(\'account_code' + row_count +'\',\'ACCOUNT_CODE,ACCOUNT_NAME\',\'ACCOUNT_CODE,ACCOUNT_NAME\',\'get_account_code\',\'0\',\'\',\'\',\'\',\'3\',\'225\');" class="boxtext"  value="'+account_code+'"><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" id="account_code_image_ch'+row_count+'" onclick="pencere_ac_acc('+ row_count +');"></span></div></div>';																												

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("nowrap","nowrap");
	newCell.innerHTML = '<div class="form-group"><input type="text" name="total' + row_count +'" id="total' + row_count +'" value="'+commaSplit(exp_net_total,rate_round_num_)+'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#xml_satir_number#</cfoutput>));" onBlur="hesapla(\'total\',' + row_count +');" class="moneybox"></div>';

	/* newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("nowrap","nowrap");
	c = '<div class="form-group"><select name="tax_rate' + row_count  +'" id="tax_rate' + row_count  +'" class="box" onChange="hesapla(\'tax_rate\','+ row_count +');">';
	<cfoutput query="get_tax">
	if('#tax#' == <cfif isdefined("xml_tax_rate") and len(xml_tax_rate)>#xml_tax_rate#<cfelse>exp_tax_rate</cfif>)
		c += '<option value="#tax#" selected>#tax#</option>';
	else
		c += '<option value="#tax#">#tax#</option>';
	</cfoutput>
	newCell.innerHTML =c+ '</select></div>';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("nowrap","nowrap");
	newCell.innerHTML = '<div class="form-group"><input type="text" name="otv_rate'+ row_count +'" id="otv_rate'+ row_count +'" value="'+otv_rate+'" onkeyup="return(FormatCurrency(this,event,0));" style="width:50px;" onBlur="hesapla(\'otv_rate\',' + row_count +');" class="box"></div>';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("nowrap","nowrap");
	newCell.innerHTML = '<div class="form-group"><input type="text" name="kdv_total' + row_count +'" id="kdv_total' + row_count +'" value="'+commaSplit(exp_tax_total,rate_round_num_)+'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#xml_satir_number#</cfoutput>));" onBlur="hesapla(\'kdv_total\',' + row_count +',1);" class="moneybox"></div>';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("nowrap","nowrap");
	newCell.innerHTML = '<div class="form-group"><input type="text" name="otv_total' + row_count +'" id="otv_total' + row_count +'" value="'+commaSplit(exp_otv_total,rate_round_num_)+'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#xml_satir_number#</cfoutput>));" onBlur="hesapla(\'otv_total\',' + row_count +',1);" class="moneybox"></div>';
 */
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("nowrap","nowrap");
	newCell.innerHTML = '<div class="form-group"><input type="text" name="net_total' + row_count +'" id="net_total' + row_count +'" value="'+commaSplit(0,rate_round_num_)+'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#xml_satir_number#</cfoutput>));" style="width:60px" onBlur="hesapla(\'net_total\',' + row_count +',2);" style="width:90px;" class="moneybox"></div>';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("nowrap","nowrap");
	a = '<div class="form-group"><select name="money_id' + row_count  +'" id="money_id' + row_count  +'" style="width:60px" class="boxtext money_class" onChange="other_calc('+ row_count +');MoneyClass();">';
	<cfoutput query="get_money">
	if('#money#,#rate1#,#rate2#' == exp_money_type)
		a += '<option value="#money#,#rate1#,#rate2#" selected>#money#</option>';
	else
		a += '<option value="#money#,#rate1#,#rate2#">#money#</option>';
	</cfoutput>
	newCell.innerHTML =a+ '</select></div>';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("nowrap","nowrap");
	newCell.innerHTML = '<div class="form-group"><input type="text" name="other_net_total' + row_count +'" id="other_net_total' + row_count +'" value="'+commaSplit(0,rate_round_num_)+'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#xml_satir_number#</cfoutput>));" onBlur="other_calc('+row_count+');" style="width:90px;" class="box"></div>';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("nowrap","nowrap");
	newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="project_id'+ row_count +'" id="project_id'+ row_count +'" value="'+exp_project_id+'"><input type="text" name="project'+ row_count +'" id="project'+ row_count +'" value="'+exp_project+'" onFocus="AutoComplete_Create(\'project'+ row_count +'\',\'PROJECT_HEAD\',\'PROJECT_HEAD\',\'get_project\',\'\',\'PROJECT_ID\',\'project_id'+ row_count +'\',\'\',3,200,\'change_workgroup('+row_count+')\');" class="boxtext"><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_ac_project('+ row_count +');"></span></div></div>';

	<cfif isdefined("attributes.is_from_file")>
		hesapla('',row_count);
	</cfif>
	MoneyClass();
}
<cfoutput>
function pencere_ac_oppotunity(no)
{
	windowopen('#request.self#?fuseaction=objects.popup_list_opportunities&field_opp_id=all.opp_id' + no +'&field_opp_head=all.opp_head' + no ,'list');
}
function pencere_ac_work(no)
{
	p_id_ = document.getElementById("project_id" + no).value;
	p_name_ = document.getElementById("project" + no).value;
	windowopen('#request.self#?fuseaction=objects.popup_add_work&field_id=all.work_id' + no +'&field_name=all.work_head' + no +'&project_id=' + p_id_ + '&project_head=' + p_name_ +'&field_pro_id=all.project_id' +no + '&field_pro_name=all.project' +no ,'list');
}
function pencere_detail_work(no)
{	
	windowopen('#request.self#?fuseaction=project.popup_updwork&id='+document.getElementById("work_id"+no).value,'list');
}
function pencere_ac_acc(no)
{
	windowopen('#request.self#?fuseaction=objects.popup_account_plan&field_id=all.account_code' + no +'','list');
}
function auto_company(no)
{
	AutoComplete_Create('company'+no,'MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2,3\'','MEMBER_TYPE,PARTNER_ID2,COMPANY_ID,MEMBER_PARTNER_NAME2','member_type'+no+',member_id'+no+',company_id'+no+',authorized'+no+'','','3','250');
}
function auto_subscription(no)
{
	AutoComplete_Create('subscription_name'+no,'SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','get_subscription','2','SUBSCRIPTION_ID','subscription_id'+no,'','3','150');
}
function pencere_ac_company(no)
{
	windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_id=all.member_id' + no +'&field_emp_id=all.member_id' + no +'&field_comp_name=all.company' + no +'&field_name=all.authorized' + no +'&field_comp_id=all.company_id' + no + '&field_type=all.member_type' + no + '&select_list=1,2,3,9','list');
}
function pencere_ac_product(no)
{	
	project_url_ = "";
	unit_url_ = "";
	tax_purchase_ = "";
	if(document.getElementById("project_id"+no) != undefined)
		project_url_ = '&project_id='+ document.getElementById("project_id"+no).value;
	if(document.getElementById("stock_unit"+ no) != undefined)
		unit_url_ = '&field_unit_name= all.stock_unit' + no+'&field_main_unit=all.stock_unit_id' + no;
	<!--- <cfif not(fuseaction contains "assetcare")>
		if(document.getElementById("tax_rate"+ no) != undefined)
			tax_purchase_ = '&field_tax_purchase=all.tax_rate' + no;
	</cfif> --->
	<cfif x_row_project_priority_from_product eq 1>
		if(document.getElementById("project_id"+no) != undefined && document.getElementById("project_id"+no).value == "")
		{
			alert("<cf_get_lang dictionary_id='34263.Önce Proje Seçmelisiniz'>!");
			return false;
		}
	</cfif>
	date_value = document.getElementById("expense_date").value;
	satir_info='product_name';
	windowopen('#request.self#?fuseaction=objects.popup_product_names'+project_url_+tax_purchase_+'&product_id=all.product_id' + no + '&field_id=all.stock_id' + no + unit_url_ + '&field_product_cost=all.total'+no+'&run_function=hesapla&run_function_param='+no+'&run_function_param1='+satir_info+'&expense_date='+date_value+'&field_name=all.product_name'+no,'list');
}
function pencere_ac_asset(no)
{
	adres = '#request.self#?fuseaction=assetcare.popup_list_assetps';
	adres += '&field_id=all.asset_id' + no +'&field_name=all.asset' + no +'&event_id=0&motorized_vehicle=0';
	<cfif x_is_add_position_to_asset_list eq 1>
		adres += '&member_type=all.member_type' + no;
		adres += '&employee_id=all.member_id' + no;
		adres += '&position_employee_name=all.authorized' + no;	
	</cfif>
	windowopen(adres,'list');
}
function change_workgroup(no)
{
	<cfif x_row_workgroup_project eq 1>
		var get_workgroup = wrk_safe_query('obj_get_workgroup','dsn',0, document.getElementById("project_id" + no).value);		
		if(get_workgroup.WORKGROUP_ID != '' && document.getElementById("workgroup_id" + no) != undefined)
			document.getElementById("workgroup_id" + no).value = get_workgroup.WORKGROUP_ID;
	</cfif>			
}
function autocomp_project(no)
{
	<cfif x_is_project_select eq 0>
	if(document.getElementById("product_id"+no) != undefined && document.getElementById("product_id"+no).value != '' && document.getElementById("product_name"+no).value != '')	
	{
		alert("Satırda Ürün Seçiliyken Proje Değiştirilemez");	
		return false;
	}
	<cfelse>
		AutoComplete_Create('project'+ row_count +'','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id'+ row_count +'','',3,200,'change_workgroup('+row_count+')');
	</cfif>
}
function pencere_ac_project(no)
{
	<cfif x_is_project_select eq 0>
	if(document.getElementById("product_id"+no) != undefined && document.getElementById("product_id"+no).value != '' && document.getElementById("product_name"+no).value != '')	
	{
		alert("Satırda Ürün Seçiliyken Proje Değiştirilemez");	
		return false;
	}
	</cfif>
	<cfif x_row_workgroup_project eq 1>
		openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&function_name=change_workgroup&function_param='+no+'&project_id=add_costplan.project_id' + no +'&project_head=add_costplan.project' + no);
	<cfelse>
		openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=add_costplan.project_id' + no +'&project_head=add_costplan.project' + no);
	</cfif>
}
function pencere_ac_subs(no)
{
	windowopen('#request.self#?fuseaction=objects.popup_list_subscription&field_id=all.subscription_id' + no +'&field_no=all.subscription_name' + no,'list');
}
function pencere_ac_campaign(no)
{
	windowopen('#request.self#?fuseaction=objects.popup_list_campaigns&field_id=all.campaign_id' + no +'&field_name=all.campaign' + no,'list');
}
function pencere_ac_exp(no)
{
	windowopen('#request.self#?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=all.expense_center_id' + no +'&field_name=all.expense_center_name' + no,'list');
}
function pencere_ac_item(no)
{
	inc = document.getElementById('ba' + no).value;
	if(inc == 1) inc_ = "&is_income=1"; else inc_ = "";
	windowopen('#request.self#?fuseaction=objects.popup_list_exp_item&field_id=all.expense_item_id' + no +'&field_account_no=all.account_code' + no +'&field_name=all.expense_item_name' + no + inc_,'list');
}
</cfoutput>
record_exist=0;//Row_kontrol değeri 1 olan yani silinmemiş satırların varlığını kontrol ediyor
function return_company()
{
if(document.getElementById("ch_member_type").value=='employee')
	{
		var emp_id=document.getElementById("emp_id").value;
		var GET_COMPANY=wrk_safe_query('obj_get_company','dsn',0,emp_id);
		document.getElementById("ch_member_id").value=GET_COMPANY.COMP_ID;
	}
  else 
	return false;
}
function zero_stock_control(dep_id,loc_id,is_update,process_type,stock_type)//orjinal sıfırstok kontrolu functionı,geneldekini kullanamıyoruz,duruma göre değişiklik yapılabilir
{
	var hata = '';
	var stock_id_list='0';
	var stock_amount_list='0';
	if(row_count>1)
	{
		for (var counter_=1; counter_ <= row_count; counter_++)
		{
			if(document.getElementById("row_kontrol" + counter_).value == 1 && document.getElementById("stock_id" + counter_).value != '')
			{
				var yer=list_find(stock_id_list,document.getElementById("stock_id" + counter_).value,',');
				if(yer)
				{
					top_stock_miktar=parseFloat(list_getat(stock_amount_list,yer,','))+parseFloat(filterNum(document.getElementById("quantity" + counter_).value));
					stock_amount_list=list_setat(stock_amount_list,yer,top_stock_miktar,',');
				}
				else
				{
					stock_id_list=stock_id_list+','+ document.getElementById("stock_id " + counter_).value;
					stock_amount_list=stock_amount_list+','+filterNum(document.getElementById("quantity" + counter_).value);
				}
			}
		}
	}
	else
	{
		if(document.getElementById("stock_id1").value != '')
		{
			stock_id_list=stock_id_list+','+document.getElementById("stock_id1").value;
			stock_amount_list=stock_amount_list+','+filterNum(document.getElementById("quantity1").value);
		}
	}
	var stock_id_count=list_len(stock_id_list,',');
	//stock kontrolleri
	if(stock_id_count >1)
	{
		if(dep_id=='' || dep_id==undefined || loc_id=='' || loc_id==undefined)
		{
			if(stock_type==undefined || stock_type==0)
			{
				if(is_update != 0)
					var new_sql = 'obj_get_total_stock_29';
				else
					var new_sql = 'obj_get_total_stock_30';			
			}
			else
			{
				if(is_update != 0)
					var new_sql= 'obj_get_total_stock_31';						
				else
					var new_sql= 'obj_get_total_stock_32';
			}
		}
		else
		{
			if(is_update != 0)
				var new_sql = 'obj_get_total_stock_33';
			else
				var new_sql = 'obj_get_total_stock_34';
		}
		var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + stock_id_list + "*" + is_update + "*" + loc_id + "*" + dep_id;
		var get_total_stock = wrk_safe_query(new_sql,'dsn2',0,listParam);
		if(get_total_stock.recordcount)
		{
			var query_stock_id_list='0';
			for(var cnt=0; cnt < get_total_stock.recordcount; cnt++)
			{
				query_stock_id_list=query_stock_id_list+','+get_total_stock.STOCK_ID[cnt];//queryden gelen kayıtları tutuyruz gelmeyenlerde stokta yoktur cunku
				var yer=list_find(stock_id_list,get_total_stock.STOCK_ID[cnt],',');
				if(parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt]) < parseFloat(list_getat(stock_amount_list,yer,',')))
					hata = hata+ 'Ürün:'+get_total_stock.PRODUCT_NAME[cnt]+'(Stok Kodu:'+get_total_stock.STOCK_CODE[cnt]+')\n';
			}
		}
		var diff_stock_id='0';
		for(var lst_cnt=1;lst_cnt <= list_len(stock_id_list);lst_cnt++)
		{
			var stk_id=list_getat(stock_id_list,lst_cnt,',')
			if(query_stock_id_list==undefined || query_stock_id_list=='0' || list_find(query_stock_id_list,stk_id,',') == '0')
				diff_stock_id=diff_stock_id+','+stk_id;//kayıt gelmeyen urunler
		}
		if(list_len(diff_stock_id,',')>1)
		{//bu lokasyona hiç giriş veya çıkış olmadı ise kayıt gelemyecektir o yüzden yazıldı
			var get_stock = wrk_safe_query('obj_get_stock','dsn3',0,diff_stock_id);
			for(var cnt=0; cnt < get_stock.recordcount; cnt++)
				hata = hata+ 'Ürün:'+get_stock.PRODUCT_NAME[cnt]+'(Stok Kodu:'+get_stock.STOCK_CODE[cnt]+')\n';
		}
		get_total_stock='';
	}
	if(hata!='')
	{
		if(stock_type==undefined || stock_type==0)
			alert(hata+"\n\n<cf_get_lang dictionary_id ='33757.Yukarıdaki ürünlerde stok miktarı yeterli değildir Lütfen seçtiğiniz depo lokasyonundaki miktarları kontrol ediniz '>");
		else
			alert(hata+"\n\n<cf_get_lang dictionary_id ='33758.Yukarıdaki ürünlerde satılabilir stok miktarı yeterli değildir Lütfen miktarları kontrol ediniz '>");
		hata='';
		return false;
	}
	else
		return true;
}
function ayarla_gizle_goster(id)
{
	if(id==1)
	{
		if(document.getElementById("cash").checked == true)
		{
			if (document.getElementById("bank")) 
			{
				document.getElementById("bank").checked = false;
				document.getElementById("banka1").style.display='none';
				document.getElementById("banka2").style.display='none';
			}
			if (document.getElementById("credit")) 
			{
				document.getElementById("credit").checked = false;
				document.getElementById("credit1").style.display='none';
				document.getElementById("credit2").style.display='none';
				document.getElementById("credit3").style.display='none';
			}
			document.getElementById("kasa1").style.display='';
			document.getElementById("kasa2").style.display='';
		}
		else
		{
			document.getElementById("kasa1").style.display='none';
			document.getElementById("kasa2").style.display='none';
		}
	}
	else if(id==3)
	{
		if(document.getElementById("credit").checked == true)
		{
			if (document.getElementById("bank")) 
			{
				document.getElementById("bank").checked = false;
				document.getElementById("banka1").style.display='none';
				document.getElementById("banka2").style.display='none';
			}
			if (document.getElementById("cash")) 
			{
				document.getElementById("cash").checked = false;
				document.getElementById("kasa1").style.display='none';
				document.getElementById("kasa2").style.display='none';
			}
			document.getElementById("credit1").style.display='';
			document.getElementById("credit2").style.display='';
			document.getElementById("credit3").style.display='';
		}
		else
		{
			document.getElementById("credit1").style.display='none';
			document.getElementById("credit2").style.display='none';
			document.getElementById("credit3").style.display='none';
		}
	}
	else
	{
		if(document.getElementById("bank").checked == true)
		{
			if (document.getElementById("cash")) 
			{
				document.getElementById("cash").checked = false;
				document.getElementById("kasa1").style.display='none';
				document.getElementById("kasa2").style.display='none';
			}
			if (document.getElementById("credit")) 
			{
				document.getElementById("credit").checked = false;
				document.getElementById("credit1").style.display='none';
				document.getElementById("credit2").style.display='none';
				document.getElementById("credit3").style.display='none';
			}
			document.getElementById("banka1").style.display='';
			document.getElementById("banka2").style.display='';
		}
		else
		{
			document.getElementById("banka1").style.display='none';
			document.getElementById("banka2").style.display='none';
		}
	}
}
function view_product_info(row_info)//ürün detay popup ının gözükmesi için
{
	if(document.getElementById("product_name" + row_info) != undefined && document.getElementById("product_name" + row_info).value == '')
		document.getElementById("product_info" + row_info).style.display='none';
	else
		document.getElementById("product_info" + row_info).style.display='';
}
function copy_row(no_info)
{
	if (document.getElementById("row_detail" + no_info) == undefined) row_detail =""; else row_detail = document.getElementById("row_detail" + no_info).value;
	if (document.getElementById("expense_center_id" + no_info) == undefined) exp_center_id =""; else exp_center_id = document.getElementById("expense_center_id" + no_info).value;
	if (document.getElementById("expense_center_name" + no_info) == undefined) exp_center =""; else exp_center = document.getElementById("expense_center_name" + no_info).value;
	if (document.getElementById("expense_item_id" + no_info) == undefined) exp_item_id =""; else exp_item_id = document.getElementById("expense_item_id" + no_info).value;
	if (document.getElementById("expense_item_name" + no_info) == undefined) exp_item =""; else exp_item = document.getElementById("expense_item_name" + no_info).value;
	if (document.getElementById("account_code" + no_info) == undefined) account_code =""; else account_code = document.getElementById("account_code" + no_info).value;
	if (document.getElementById("expense_date" + no_info) == undefined) exp_date =""; else exp_date = document.getElementById("expense_date" + no_info).value;
	if (document.getElementById("project_id" + no_info) == undefined) exp_project_id =""; else exp_project_id = document.getElementById("project_id" + no_info).value;
	if (document.getElementById("project" + no_info) == undefined) exp_project =""; else exp_project =  document.getElementById("project" + no_info).value;
	<cfif x_row_copy_product_info eq 1>//Satir Kopyalanirken Urun Bilgileri Tasinsin
		if (document.getElementById("product_id" + no_info) == undefined) exp_product_id =""; else exp_product_id = document.getElementById("product_id" + no_info).value;
		if (document.getElementById("stock_id" + no_info) == undefined) exp_stock_id =""; else exp_stock_id = document.getElementById("stock_id" + no_info).value;
		if (document.getElementById("product_name" + no_info) == undefined) exp_product_name =""; else exp_product_name = document.getElementById("product_name" + no_info).value;
		if (document.getElementById("stock_unit" + no_info) == undefined) exp_stock_unit =""; else exp_stock_unit = document.getElementById("stock_unit" + no_info).value;
		if (document.getElementById("stock_unit_id" + no_info) == undefined) exp_stock_unit_id =""; else exp_stock_unit_id = document.getElementById("stock_unit_id" + no_info).value;
		if (document.getElementById("spect_var_id" + no_info) == undefined) exp_spect_var_id =""; else exp_spect_var_id = document.getElementById("spect_var_id" + no_info).value;
		if (document.getElementById("spect_name" + no_info) == undefined) exp_spect_name =""; else exp_spect_name =  document.getElementById("spect_name" + no_info).value;
	<cfelse>
		exp_product_id = "";
		exp_stock_id = "";
		exp_product_name = "";
		exp_stock_unit = "";
		exp_stock_unit_id = "";
		exp_spect_var_id = "";
		exp_spect_name = "";
	</cfif>
	if (document.getElementById("member_type" + no_info) == undefined) exp_member_type =""; else exp_member_type = document.getElementById("member_type" + no_info).value;
	if (document.getElementById("member_id" + no_info) == undefined) exp_member_id =""; else exp_member_id = document.getElementById("member_id" + no_info).value;
	if (document.getElementById("company_id" + no_info) == undefined) exp_company_id =""; else exp_company_id = document.getElementById("company_id" + no_info).value;
	if (document.getElementById("company" + no_info) == undefined) exp_company =""; else exp_company = document.getElementById("company" + no_info).value;
	if (document.getElementById("authorized" + no_info) == undefined) exp_authorized =""; else exp_authorized = document.getElementById("authorized" + no_info).value;
	
	if (document.getElementById("money_id" + no_info) == undefined) exp_money_type =""; else exp_money_type = document.getElementById("money_id" + no_info).value;
	if (document.getElementById("activity_type" + no_info) == undefined) exp_act_id =""; else exp_act_id = document.getElementById("activity_type" + no_info).value;
	if (document.getElementById("workgroup_id" + no_info) == undefined) exp_work_id =""; else exp_work_id = document.getElementById("workgroup_id" + no_info).value;
	if (document.getElementById("subscription_id" + no_info) == undefined) exp_subs_id =""; else exp_subs_id = document.getElementById("subscription_id" + no_info).value;
	if (document.getElementById("subscription_name" + no_info) == undefined) exp_subs_name =""; else exp_subs_name = document.getElementById("subscription_name" + no_info).value;
	<cfif x_row_copy_asset_info eq 1>//Satir Kopyalanirken Fiziki Varlik Bilgileri Tasinsin
		if (document.getElementById("asset_id" + no_info) == undefined) exp_asset_id =""; else exp_asset_id = document.getElementById("asset_id" + no_info).value;
		if (document.getElementById("asset" + no_info) == undefined) exp_asset_name =""; else exp_asset_name = document.getElementById("asset" + no_info).value;
	<cfelse>
		exp_asset_id ="";
		exp_asset_name ="";
	</cfif>
	if (document.getElementById("work_id" + no_info) == undefined) row_work_id =""; else row_work_id = document.getElementById("work_id" + no_info).value;
	if (document.getElementById("work_head" + no_info) == undefined) row_work_head =""; else row_work_head = document.getElementById("work_head" + no_info).value;
	if (document.getElementById("opp_id" + no_info) == undefined) exp_opp_id =""; else exp_opp_id = document.getElementById("opp_id" + no_info).value;
	if (document.getElementById("opp_head" + no_info) == undefined) exp_opp_head =""; else exp_opp_head = document.getElementById("opp_head" + no_info).value;
	
	/* if (document.getElementById("tax_rate" + no_info) == undefined) exp_tax_rate ="0"; else exp_tax_rate = document.getElementById("tax_rate" + no_info).value; */
	/* if (document.getElementById("otv_rate" + no_info) == undefined) otv_rate ="0"; else otv_rate = document.getElementById("otv_rate" + no_info).value; */
	//Satir Kopyalamada tutarlar tasinmasin
	exp_tax_rate ="0";
	otv_rate ="0";
	exp_net_total = "0";
	exp_tax_total = "0";
	exp_otv_total = "0";
	
	add_row(row_detail,exp_center,exp_center_id,exp_item,exp_item_id,exp_project_id,exp_project,exp_product_id,exp_spect_var_id,exp_spect_name,exp_stock_id,exp_product_name,exp_stock_unit,exp_stock_unit_id,exp_member_type,exp_member_id,exp_company_id,exp_company,exp_authorized,exp_net_total,exp_tax_total,exp_otv_total,exp_tax_rate,exp_money_type,exp_act_id,exp_work_id,exp_subs_id,exp_subs_name,exp_asset_id,exp_asset_name,account_code,exp_date,row_work_id,row_work_head,exp_opp_id,exp_opp_head,otv_rate);
	hesapla('',row_count);	
	MoneyClass();
}
function change_product_cost()//seçilen tarihteki maliyeti atar, fiziki varliklardan, bakimlardan olusan islemler icin
{
	<cfif ListFind("assetcare",fusebox.circuit,',')>
		if(document.getElementById("expense_date").value != '')
		{
			var expense_date = js_date(document.getElementById("expense_date").value.toString());
			for(tt=1;tt<=document.getElementById("record_num").value;tt++)
			{
				var product_cost_total = 0;
				if(document.getElementById("product_id" + tt)!= undefined && document.getElementById("product_id" + tt).value != '' && document.getElementById("product_name" + tt).value  != '')
				{
					var listParam = expense_date + "*" + document.getElementById("product_id"+tt).value ;
					var PRODUCT_COST_INFO = wrk_safe_query("obj_PRODUCT_COST_INFO",'dsn3',0,listParam);
					if(PRODUCT_COST_INFO.recordcount && PRODUCT_COST_INFO.PURCHASE_NET_SYSTEM != 0)
						product_cost_total = product_cost_total + parseFloat(PRODUCT_COST_INFO.PURCHASE_NET_SYSTEM);
					if(PRODUCT_COST_INFO.recordcount && PRODUCT_COST_INFO.PURCHASE_EXTRA_COST_SYSTEM != 0)
						product_cost_total = product_cost_total + parseFloat(PRODUCT_COST_INFO.PURCHASE_EXTRA_COST_SYSTEM);
					document.getElementById("total" + tt).value = commaSplit(product_cost_total);
					hesapla('',tt);
				}
			}
		}
	</cfif>
}
function open_process_row()
{
	document.getElementById("open_process").style.display ='';
	<cfif isdefined("is_income") and is_income eq 1>type = 2;<cfelse>type=1;</cfif>
	AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=cost.emptypopup_form_add_cost_rows&type='+type,'open_process',1);
}
function change_date_info()
{
	if(document.getElementById("temp_date").value != '')
		for(tt=1;tt<=document.getElementById("record_num").value;tt++)
			if(document.getElementById("row_kontrol"+tt).value==1)
				document.getElementById("expense_date"+tt).value = document.getElementById("temp_date").value;
}
function product_control(no_info) /*Satirdaki urunu secmeden spec secimine izin verilmesin.*/
{ 
	if(document.getElementById("product_id"+ no_info).value=='' || document.getElementById("product_name" + no_info).value=='')
	{
		alert("<cf_get_lang dictionary_id='59595.Spec Seçmek İçin Öncelikle Ürün Seçmeniz Gerekmektedir'>.");
		return false;
	}
	else
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_var_id=all.spect_var_id' + no_info +'&field_name=all.spect_name' + no_info +'&is_display=1&stock_id='+document.getElementById('stock_id'+ no_info).value ,'list');
	}
}
function format_total_value(no_info)
{
	document.getElementById("total"+ no_info).value = commaSplit(document.getElementById("total"+ no_info).value);
	hesapla('',no_info);
}
function delete_spec(no_info)
{
	document.getElementById("spect_var_id"+no_info).value = '';
	document.getElementById("spect_name"+no_info).value = '';
}
	
</script>
