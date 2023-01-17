<!--- 
	Buradaki ifadelerin #TLFormat(gelir*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')# şeklinde yazılması
	önceki sayfadan gelen döviz ve kur bilgileri ile ilgili.
 --->
<cfinclude template="../query/get_scenario_row.cfm">
<cfset ctotal=get_cash_total.CASH_TOTAL>
<cfset btotal=get_bank_total.BANK_TOTAL>
<cfif not len(btotal)><cfset btotal=0></cfif>
<cfif not len(ctotal)><cfset ctotal=0></cfif>
<cfset gune_devreden=ctotal+btotal>
<cfoutput query="get_scen" startrow="1" maxrows="#attributes.maxrows#">
	<cfset gune_devreden=gune_devreden+(BORC_BUDGET_TOTAL+BORC_BANK_ORDER_TOTAL+BORC_CHEQUE_TOTAL+BORC_VOUCHER_TOTAL+BORC_CC_TOTAL+BORC_CREDIT_CONTRACT_TOTAL+BORC_SCEN_EXPENSE_TOTAL)-(ALACAK_BUDGET_TOTAL+ALACAK_BANK_ORDER_TOTAL+ALACAK_CHEQUE_TOTAL+ALACAK_VOUCHER_TOTAL+ALACAK_CC_TOTAL+ALACAK_CREDIT_CONTRACT_TOTAL+ALACAK_SCEN_EXPENSE_TOTAL)>
</cfoutput>
<cfset gunden_devreden = gune_devreden>
<cfoutput query="get_scen_row">
	<cfif TYPE>
		<cfset gunden_devreden = gunden_devreden + PERIOD_VALUE>
	<cfelse>
		<cfset gunden_devreden = gunden_devreden - PERIOD_VALUE>
	</cfif>
</cfoutput>
<cfoutput query="get_cheques">
	<cfif cheque_status_id eq 1 or cheque_status_id eq 2>
		<cfset gunden_devreden = gunden_devreden + cheque_value>
	<cfelseif cheque_status_id eq 6>
		<cfset gunden_devreden = gunden_devreden - cheque_value>
	</cfif>
</cfoutput>
<cfoutput query="get_vouchers">
	<cfif voucher_status_id eq 1 or voucher_status_id eq 2>
		<cfset gunden_devreden = gunden_devreden + voucher_value>
	<cfelseif voucher_status_id eq 6>
		<cfset gunden_devreden = gunden_devreden - voucher_value>
	</cfif>
</cfoutput>
<cfoutput query="get_credit_card_bank_payment">
	<cfset gunden_devreden = gunden_devreden + borc>
</cfoutput>
<cfoutput query="GET_CREDIT_CONTRACT_ROW">
	<cfset gunden_devreden = gunden_devreden + borc>
</cfoutput>
<cfoutput query="GET_CREDIT_CONTRACT_PAYMENTS">
	<cfset gunden_devreden = gunden_devreden + alacak>
</cfoutput>
<cf_box title="#getLang('finance',55)#">
<cfset bakiye = gune_devreden>
<cfset gelir = 0>
<cfset gider = 0>
<cfset claim_info = 0>
<cfset debt_info = 0>
<cfset row_number=0>
	<cf_grid_list>
		<thead>
			<tr>
				<th width="20"><cf_get_lang_main  no='75.no'></th>
				<th><cf_get_lang_main no='330.Tarih'></th>
				<th><cf_get_lang_main no='107.Cari Hesap'></th>
				<th><cf_get_lang_main no='217.Açıklama'></th>
				<th style="text-align:right;"><cf_get_lang_main no='1265.Gelir'></th>
				<th style="text-align:right;"><cf_get_lang_main no='1266.Gider'></th>
				<th style="text-align:right;"><cf_get_lang_main no='709.İslem Dovizi'></th>
				<th style="text-align:right;"><cf_get_lang_main no='177.Bakiye'></th>
			</tr>
		</thead>
		<tbody>
			<cfset row_count_info = 0>
			<cfoutput query="get_scen_row"><!--- Gelir Gider --->
				<cfset row_number=row_number+1>
				<tr>
					<td>#row_number#</td>
					<td>#dateformat(START_DATE,dateformat_style)#</td>
					<td></td>
					<td><a class="tableyazi" href="javascript://" onClick="windowopen('#request.self#?fuseaction=finance.popup_form_add_scen_expsense_row&id=#period_row_id#','small');">#period_detail# - #SCENARIO#</a></td>
					  <cfif type eq 0>
						<cfset gelir=0>
						<cfset gider=PERIOD_VALUE>
					  <cfelse>
						<cfset gelir=PERIOD_VALUE>
						<cfset gider=0>
					  </cfif>
					  <cfset bakiye=bakiye+gelir-gider>
					  <cfset claim_info = claim_info + gelir>
					  <cfset debt_info = debt_info + gider>
					<td style="text-align:right;">#TLFormat(gelir*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</td>
					<td style="text-align:right;">#TLFormat(gider*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</td>
					<td style="text-align:right;">#TLFormat(islem_tutar)# #period_currency#</td>
					<td style="text-align:right;"><cfif bakiye lt 0><font color="ff0000"></cfif>#TLFormat(abs(bakiye)*ListLast(attributes.money,','))#  #ListFirst(attributes.money,',')#<cfif bakiye lt 0></font></cfif></td>
				</tr>
				<cfset row_count_info = row_count_info + 1>
			</cfoutput>
			<cfif get_cc_exp_row.recordcount>
				<tr></tr>
				<cfoutput query="get_cc_exp_row"><!--- Kredi Kartiyla Odemeler --->
					<cfif PERIOD_VALUE gt 0>
						<cfset row_number=row_number+1>
						<tr>
							<td>#row_number#</td>
							<td>#dateformat(LAST_PAYMENT_DATE,dateformat_style)#</td>
							<td>#name#</td>
							<td nowrap>
								<cfif len(expense_id)>
									<a class="tableyazi" href="javascript://" onClick="windowopen('#request.self#?fuseaction=cost.form_add_expense_cost&event=upd&expense_id=#expense_id#','wwide');"><cf_get_lang_main no='1756.Kredi Kartıyla Ödeme'></a>
								<cfelse>
									<a class="tableyazi" href="javascript://" onClick="windowopen('#request.self#?fuseaction=bank.list_credit_card_expense&event=upd&id=#CREDITCARD_EXPENSE_ID#','medium');"><cf_get_lang_main no='1756.Kredi Kartıyla Ödeme'></a>
								</cfif>
							</td>
							<cfset gelir=0>
							<cfset gider=PERIOD_VALUE_SYSTEM>
							<cfset bakiye=bakiye+gelir-gider>
							<cfset claim_info = claim_info + gelir>
							<cfset debt_info = debt_info + gider>
							<td style="text-align:right;">#TLFormat(gelir*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</td>
							<td style="text-align:right;">#TLFormat(gider*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</td>
							<td style="text-align:right;">#TLFormat(period_value)# #action_currency_id#</td>
							<td style="text-align:right;"><cfif bakiye lt 0><font color="ff0000"></cfif>#TLFormat(abs(bakiye)*ListLast(attributes.money,','))#  #ListFirst(attributes.money,',')#<cfif bakiye lt 0></font></cfif></td>
						</tr>
						<cfset row_count_info = row_count_info + 1>
					</cfif>
				</cfoutput>
			</cfif>
			<cfif get_cheques.recordcount>
				<tr></tr>
				<cfoutput query="get_cheques"><!--- Cekler --->
					<cfset row_number=row_number+1>
					<tr>
						<td>#row_number#</td>
						<td>#dateformat(CHEQUE_DUEDATE,dateformat_style)#</td>
						<td>#name#</td>
						<td>
							<cfif get_module_user(21)>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=cheque.popup_view_cheque_detail&ID=#get_cheques.cheque_id#','horizantal');" class="tableyazi">#cheque_no# <cf_get_lang_main no='595.Çek'></a>
							<cfelse>
								#cheque_no# <cf_get_lang_main no='595.Çek'>
							</cfif>
						</td>
						<cfif cheque_status_id eq 6><!--- ödenmedi --->
							<cfset gelir=0>
							<cfset gider=cheque_value>
						<cfelseif listfind("1,2,13",cheque_status_id)><!--- bankada veya kasada --->
							<cfset gelir=cheque_value>
							<cfset gider=0>
						</cfif>
						<td style="text-align:right;">#TLFormat(gelir*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</td>
						<td style="text-align:right;">#TLFormat(gider*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</td>
						<cfset bakiye=bakiye+gelir-gider>
						<cfset claim_info = claim_info + gelir>
						<cfset debt_info = debt_info + gider>
						<td style="text-align:right;">#TLFormat(islem_tutar)# #currency_id#</td>
						<td style="text-align:right;"><cfif bakiye lt 0><font color="ff0000"></cfif>#TLFormat(abs(bakiye)*ListLast(attributes.money,','))#  #ListFirst(attributes.money,',')#<cfif bakiye lt 0></font></cfif></td>
					</tr>
					<cfset row_count_info = row_count_info + 1>
				</cfoutput>
			</cfif>
			<cfif get_vouchers.recordcount>
				<tr></tr>
				<cfoutput query="get_vouchers"><!--- Senetler --->
					<cfset row_number=row_number+1>
					<tr>
						<td>#row_number#</td>
						<td>#dateformat(VOUCHER_DUEDATE,dateformat_style)#</td>
						<td>#name#</td>
						<td>
							<cfif get_module_user(21)>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=cheque.popup_view_voucher_detail&ID=#get_vouchers.voucher_id#','horizantal');" class="tableyazi">#voucher_no# <cf_get_lang_main no='596.Senet'></a>
							<cfelse>
								#voucher_no# <cf_get_lang_main no='596.Senet'>
							</cfif>
						</td>
						<cfif voucher_status_id eq 6><!--- ödenmedi --->
							<cfset gelir=0>
							<cfset gider=voucher_value>
						<cfelseif listfind("1,2,13",voucher_status_id)><!--- bankada veya kasada --->
							<cfset gelir=voucher_value>
							<cfset gider=0>
						</cfif>
						<td style="text-align:right;">#TLFormat(gelir*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</td>
						<td style="text-align:right;">#TLFormat(gider*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</td>
						<cfset bakiye=bakiye+gelir-gider>
						<cfset claim_info = claim_info + gelir>
						<cfset debt_info = debt_info + gider>
						<td style="text-align:right;">#TLFormat(islem_tutar)# #currency_id#</td>
						<td style="text-align:right;"><cfif bakiye lt 0><font color="ff0000"></cfif>#TLFormat(abs(bakiye)*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#<cfif bakiye lt 0></font></cfif></td>
					</tr>
					<cfset row_count_info = row_count_info + 1>
				</cfoutput>
			</cfif>
			<cfif get_credit_card_bank_payment.recordcount>
				<tr></tr>
				<cfoutput query="get_credit_card_bank_payment"><!--- Kredi kartı tahsilatları --->
					<cfset row_number=row_number+1>
					<tr>
						<td>#row_number#</td>
						<td>#dateformat(BANK_ACTION_DATE,dateformat_style)#</td>
						<td>#name#</td>
						<td>
							<cfsavecontent variable="islem_tipi">
								<cfif ACTION_TYPE_ID eq 241>
									<cf_get_lang_main no='424.Kredi Kartı Tahsilatı'>
								<cfelse>
									<cf_get_lang_main no='1755.Kredi Kartı Tahsilatı İptal'>
								</cfif>
							</cfsavecontent>
							<cfif get_module_user(51)>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=bank.list_creditcard_revenue&event=upd&id=#creditcard_payment_id#','page');" class="tableyazi">#islem_tipi#</a>
							<cfelse>
								#islem_tipi#
							</cfif>
						</td>
						<cfif ACTION_TYPE_ID eq 241>
							<cfset gelir=borc>
							<cfset gider=0>
						<cfelse>
							<cfset gelir=0>
							<cfset gider=borc>
						</cfif>
						<cfset bakiye=bakiye+gelir-gider>
						<cfset claim_info = claim_info + gelir>
						<cfset debt_info = debt_info + gider>
						<td style="text-align:right;">#TLFormat(gelir*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</td>
						<td style="text-align:right;">#TLFormat(gider*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</td>
						<td style="text-align:right;">#TLFormat(borc)# #action_currency_id#</td>
						<td style="text-align:right;"><cfif bakiye lt 0><font color="ff0000"></cfif>#TLFormat(abs(bakiye)*ListLast(attributes.money,','))#  #ListFirst(attributes.money,',')#<cfif bakiye lt 0></font></cfif></td>
					</tr>
					<cfset row_count_info = row_count_info + 1>
				</cfoutput>
			</cfif>
			<cfif GET_CREDIT_CONTRACT_ROW.recordcount>
				<tr></tr>
				<cfoutput query="GET_CREDIT_CONTRACT_ROW"><!--- Kredi Tahsilatları --->
					<cfset row_number=row_number+1>
					<tr>
						<td>#row_number#</td>
						<td>#dateformat(PROCESS_DATE,dateformat_style)#</td>
						<td>#name#</td>
						<td>
							<cfif get_module_user(51)>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=credit.list_credit_contract&event=det&credit_contract_id=#credit_contract_id#','page');" class="tableyazi"><cf_get_lang_main no='427.Kredi Tahsilatı'></a>
							<cfelse>
								 <cf_get_lang_main no='427.Kredi Tahsilatı'>
							</cfif>
						</td>
						<cfset gelir=borc>
						<cfset gider=0>
						<cfset bakiye=bakiye+gelir-gider>
						<cfset claim_info = claim_info + gelir>
						<cfset debt_info = debt_info + gider>
						<td style="text-align:right;">#TLFormat(gelir*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</td>
						<td style="text-align:right;">#TLFormat(gider*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</td>
						<td style="text-align:right;">#TLFormat(islem_tutar)# #money_type#</td>
						<td style="text-align:right;"><cfif bakiye lt 0><font color="ff0000"></cfif>#TLFormat(abs(bakiye)*ListLast(attributes.money,','))#  #ListFirst(attributes.money,',')#<cfif bakiye lt 0></font></cfif></td>
					</tr>
					<cfset row_count_info = row_count_info + 1>
				</cfoutput>
			</cfif>
			<cfif GET_CREDIT_CONTRACT_PAYMENTS.recordcount>
				<tr></tr>
				<cfoutput query="GET_CREDIT_CONTRACT_PAYMENTS"><!--- Kredi Ödemeleri --->
					<cfset row_number=row_number+1>
					<tr>
						<td>#row_number#</td>
						<td>#dateformat(PROCESS_DATE,dateformat_style)#</td>
						<td>#name#</td>
						<td>
							<cfif get_module_user(51)>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=credit.list_credit_contract&event=det&credit_contract_id=#credit_contract_id#','page');" class="tableyazi"><cf_get_lang_main no='426.Kredi Ödemesi'></a>
							<cfelse>
								 <cf_get_lang_main no='426.Kredi Ödemesi'>
							</cfif>
						</td>
						<cfset gider=alacak>
						<cfset gelir=0>
						<cfset bakiye=bakiye+gelir-gider>
						<cfset claim_info = claim_info + gelir>
						<cfset debt_info = debt_info + gider>
						<td style="text-align:right;">#TLFormat(gelir*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</td>
						<td style="text-align:right;">#TLFormat(gider*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</td>
						<td style="text-align:right;">#TLFormat(islem_tutar)# #money_type#</td>
						<td style="text-align:right;"><cfif bakiye lt 0><font color="ff0000"></cfif>#TLFormat(abs(bakiye)*ListLast(attributes.money,','))#  #ListFirst(attributes.money,',')#<cfif bakiye lt 0></font></cfif></td>
					</tr>
					<cfset row_count_info = row_count_info + 1>
				</cfoutput>
			</cfif>
			<cfif GET_GELEN_BANK_ORDERS.recordcount>
				<tr></tr>
				<cfoutput query="GET_GELEN_BANK_ORDERS"><!--- Gelen Banka Talimatları --->
					<cfset row_number=row_number+1>
					<tr>
						<td>#row_number#</td>
						<td>#dateformat(PAYMENT_DATE,dateformat_style)#</td>
						<td>#name#</td>
						<td>
							<cfif get_module_user(51)>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=bank.list_assign_order&event=upd_incoming&bank_order_id=#bank_order_id#','page');" class="tableyazi"><cf_get_lang no='501.Gelen Banka Talimatı'></a>
							<cfelse>
								<cf_get_lang no='501.Gelen Banka Talimatı'>
							</cfif>
						</td>
						<cfset gelir=alacak>
						<cfset gider=0>
						<cfset bakiye=bakiye+gelir-gider>
						<cfset claim_info = claim_info + gelir>
						<cfset debt_info = debt_info + gider>
						<td style="text-align:right;">#TLFormat(gelir*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</td>
						<td style="text-align:right;">#TLFormat(gider*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</td>
						<td style="text-align:right;">#TLFormat(islem_tutar)# #action_money#</td>
						<td style="text-align:right;"><cfif bakiye lt 0><font color="ff0000"></cfif>#TLFormat(abs(bakiye)*ListLast(attributes.money,','))#  #ListFirst(attributes.money,',')#<cfif bakiye lt 0></font></cfif></td>
					</tr>
					<cfset row_count_info = row_count_info + 1>
				</cfoutput>
			</cfif>
			<cfif GET_GIDEN_BANK_ORDERS.recordcount>
				<tr></tr>
				<cfoutput query="GET_GIDEN_BANK_ORDERS"><!--- Giden Banka Talimatları --->
					<cfset row_number=row_number+1>
					<tr>
						<td>#row_number#</td>
						<td>#dateformat(PAYMENT_DATE,dateformat_style)#</td>
						<td>#name#</td>
						<td>
							<cfif get_module_user(51)>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=bank.list_assign_order&&event=upd_assign&bank_order_id=#bank_order_id#','page');" class="tableyazi"><cf_get_lang no='502.Giden Banka Talimatı'></a>
							<cfelse>
								<cf_get_lang no='502.Giden Banka Talimatı'>
							</cfif>
						</td>
						<cfset gider=borc>
						<cfset gelir=0>
						<cfset bakiye=bakiye+gelir-gider>
						<cfset claim_info = claim_info + gelir>
						<cfset debt_info = debt_info + gider>
						<td style="text-align:right;">#TLFormat(gelir*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</td>
						<td style="text-align:right;">#TLFormat(gider*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</td>
						<td style="text-align:right;">#TLFormat(islem_tutar)# #action_money#</td>
						<td style="text-align:right;"><cfif bakiye lt 0><font color="ff0000"></cfif>#TLFormat(abs(bakiye)*ListLast(attributes.money,','))#  #ListFirst(attributes.money,',')#<cfif bakiye lt 0></font></cfif></td>
					</tr>
					<cfset row_count_info = row_count_info + 1>
				</cfoutput>
			</cfif>
			<cfif GET_BUDGET_INCOME.recordcount>
				<tr></tr>
				<cfoutput query="GET_BUDGET_INCOME"><!--- Bütçe Gelirler --->
					<cfset row_number=row_number+1>
					<tr>
						<td>#row_number#</td>
						<td>#dateformat(PAYMENT_DATE,dateformat_style)#</td>
						<td>#name#</td>
						<td>
							<cfif get_module_user(51)>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=budget.list_plan_rows&event=upd&budget_plan_id=#budget_plan_id#','wide2');" class="tableyazi"><cf_get_lang no='9.Bütçe Gelir Fişi'>- #detail#</a>
							<cfelse>
								<cf_get_lang no='9.Bütçe Gelir Fişi'> - #detail#
							</cfif>
						</td>
						<cfset gelir=alacak>
						<cfset gider=0>
						<cfset bakiye=bakiye+gelir-gider>
						<cfset claim_info = claim_info + gelir>
						<cfset debt_info = debt_info + gider>
						<td style="text-align:right;">#TLFormat(gelir*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</td>
						<td style="text-align:right;">#TLFormat(gider*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</td>
						<td style="text-align:right;">#TLFormat(islem_tutar)# #action_money#</td>
						<td style="text-align:right;"><cfif bakiye lt 0><font color="ff0000"></cfif>#TLFormat(abs(bakiye)*ListLast(attributes.money,','))#  #ListFirst(attributes.money,',')#<cfif bakiye lt 0></font></cfif></td>
					</tr>
					<cfset row_count_info = row_count_info + 1>
				</cfoutput>
			</cfif>
			<cfif GET_BUDGET_EXPENSE.recordcount>
				<tr></tr>
				<cfoutput query="GET_BUDGET_EXPENSE"><!--- Bütçe Giderler --->
					<cfset row_number=row_number+1>
					<tr>
						<td>#row_number#</td>
						<td>#dateformat(PAYMENT_DATE,dateformat_style)#</td>
						<td>#name#</td>
						<td>
							<cfif get_module_user(51)>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=budget.list_plan_rows&event=upd&budget_plan_id=#budget_plan_id#','wide2');" class="tableyazi"><cf_get_lang no='13.Bütçe Gider Fişi'>- #detail#</a>
							<cfelse>
								<cf_get_lang no='13.Bütçe Gider Fişi'>- #detail#
							</cfif>
						</td>
						<cfset gider=borc>
						<cfset gelir=0>
						<cfset bakiye=bakiye+gelir-gider>
						<cfset claim_info = claim_info + gelir>
						<cfset debt_info = debt_info + gider>
						<td style="text-align:right;">#TLFormat(gelir*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</td>
						<td style="text-align:right;">#TLFormat(gider*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</td>
						<td style="text-align:right;">#TLFormat(islem_tutar)# #action_money#</td>
						<td style="text-align:right;"><cfif bakiye lt 0><font color="ff0000"></cfif>#TLFormat(abs(bakiye)*ListLast(attributes.money,','))#  #ListFirst(attributes.money,',')#<cfif bakiye lt 0></font></cfif></td>
					</tr>
					<cfset row_count_info = row_count_info + 1>
				</cfoutput>
			</cfif>
			<cfif session.ep.our_company_info.is_paper_closer eq 1>
				<cfif get_open_acc.recordcount>
					<cfoutput query="get_open_acc"><!--- Acik Hesap Alacaklar ve Borclar --->
						<cfif borc gt 0>
							<cfset row_number=row_number+1>
							<tr>
								<td>#row_number#</td>
								<td>#dateformat(DUE_DATE,dateformat_style)#</td>
								<td>#name#</td>
								<td><cf_get_lang no='371.Açık Hesap Alacaklar'></td>
								<cfset gelir=borc>
								<cfset gider=0>
								<cfset bakiye=bakiye+gelir-gider>
								<cfset claim_info = claim_info + gelir>
								<cfset debt_info = debt_info + gider>
								<td style="text-align:right;">#TLFormat(gelir*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</td>
								<td style="text-align:right;">#TLFormat(gider*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</td>
								<td style="text-align:right;">#TLFormat(borc3)# #other_money#</td>
								<td style="text-align:right;"><cfif bakiye lt 0><font color="ff0000"></cfif>#TLFormat(abs(bakiye)*ListLast(attributes.money,','))#  #ListFirst(attributes.money,',')#<cfif bakiye lt 0></font></cfif></td>
							</tr>
							<cfset row_count_info = row_count_info + 1>
						</cfif>
						<cfif alacak gt 0>
							<cfset row_number=row_number+1>
							<tr>
								<td>#row_number#</td>
								<td>#dateformat(DUE_DATE,dateformat_style)#</td>
								<td>#name#</td>
								<td><cf_get_lang dictionary_id='60390.Açık Hesap Borçlar'></td>
								<cfset gider=alacak>
								<cfset gelir=0>
								<cfset bakiye=bakiye+gelir-gider>
								<cfset claim_info = claim_info + gelir>
								<cfset debt_info = debt_info + gider>
								<td style="text-align:right;">#TLFormat(gelir*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</td>
								<td style="text-align:right;">#TLFormat(gider*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</td>
								<td style="text-align:right;">#TLFormat(alacak3)# #other_money#</td>
								<td style="text-align:right;"><cfif bakiye lt 0><font color="ff0000"></cfif>#TLFormat(abs(bakiye)*ListLast(attributes.money,','))#  #ListFirst(attributes.money,',')#<cfif bakiye lt 0></font></cfif></td>
							</tr>
							<cfset row_count_info = row_count_info + 1>
						</cfif>
					</cfoutput>
				</cfif>
			</cfif>
			<cfif row_count_info eq 0>
				<tr>
					<td colspan="8"><cf_get_lang_main no='72.Kayıt Yok'>!</td>
				</tr>
			<cfelse>
		</tbody>
		<cfoutput>
			<tfoot>
				<tr>
					<td colspan="4" style="text-align:right;" class="txtbold"><cf_get_lang_main no='80.Toplam'></td>
					<td style="text-align:right;" class="txtbold">#TLFormat(claim_info)# #ListFirst(attributes.money,',')#</td>
					<td style="text-align:right;" class="txtbold">#TLFormat(debt_info)# #ListFirst(attributes.money,',')#</td>
					<td colspan="2"></td>
				</tr>
			</tfoot>
		</cfoutput>
		</cfif>
	</cf_grid_list>
</cf_box>
