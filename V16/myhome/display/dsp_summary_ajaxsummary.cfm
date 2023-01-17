<cfsetting showdebugoutput="no">
<cfparam name="attributes.our_company_ids" default="#session.ep.company_id#">
<cfinclude template="../query/get_summary.cfm">
<cf_flat_list>
	<tbody>
		<tr> 
			<td class="bold"><cf_get_lang dictionary_id='30815.Satışlar'></td>
			<td class="text-right">
				<cfset attributes.purchase_sales=1> 
				<cfinclude template="../includes/get_money_total.cfm"> 
				<cfoutput>#TLFormat(MONEY_SALES)#&nbsp;#session.ep.money#</cfoutput>
			</td>
		</tr>
		<tr> 
			<td class="bold"><cf_get_lang dictionary_id='30772.Alışlar'></td>
			<td class="text-right">
				<cfset attributes.purchase_sales=0>
				<cfinclude template="../includes/get_money_total.cfm"> 
				<cfoutput>#TLFormat(MONEY_PURCHASE)#&nbsp;#session.ep.money#</cfoutput>
			</td>
		</tr>
		<tr> 
			<td class="bold"><cf_get_lang dictionary_id='58658.Ödemeler'></td>
			<td class="text-right">&nbsp;
				<cfset attributes.BA=32>
				<cfset attributes.BA1=34>
				<cfinclude template="../includes/get_acc_money.cfm"> 
				<cfoutput>#TLFormat(get_acc_money.amount_money)#&nbsp;#session.ep.money#</cfoutput>
			</td>
		</tr>
		<tr> 
			<td class="bold"><cf_get_lang dictionary_id='30771.Tahsilatlar'></td>
			<td class="text-right">&nbsp; <cfset attributes.BA=31> <cfset attributes.BA1=35> 
				<cfinclude template="../includes/get_acc_money.cfm"> 
				<cfoutput>#TLFormat(get_acc_money.amount_money)#&nbsp;#session.ep.money#</cfoutput>	
			</td>
		</tr>
		<tr> 
			<td class="bold"><cf_get_lang dictionary_id='57587.Borç'></td>
			<td class="text-right">
				<cfoutput><cfif total_debt lt 0><span class="font-red-mint">#TLFormat(total_debt)#&nbsp;#session.ep.money#</span><cfelse>#TLFormat(total_debt)#&nbsp;#session.ep.money#</cfif></cfoutput>
			</td>
		</tr>
		<tr> 
			<td class="bold"><cf_get_lang dictionary_id='57588.Alacak'></td>
			<td class="text-right"><cfoutput>#TLFormat(total_claim)#&nbsp;#session.ep.money#</cfoutput></td>
		</tr>
		<tr> 
			<td class="bold"><cf_get_lang dictionary_id='57521.Banka'></td>
			<td class="text-right">
				<cfoutput><cfif account_bakiye lt 0><span class="font-red-mint">#TLFormat(account_bakiye)#&nbsp;#session.ep.money#</span><cfelse>#TLFormat(account_bakiye)#&nbsp;#session.ep.money#</cfif></cfoutput> 
			</td>
		</tr>
		<tr>
			<td class="bold"><cf_get_lang dictionary_id='57520.Kasa'></td>
			<td class="text-right">
				<cfset toplam_kasa_para_tutari=0>
				<cfloop query="get_cash_total">
					<cfif len(cash_total)><cfset toplam_kasa_para_tutari=toplam_kasa_para_tutari+cash_total></cfif>
				</cfloop>
				<cfoutput><cfif toplam_kasa_para_tutari lt 0><span class="font-red-mint">#TLFormat(toplam_kasa_para_tutari)#&nbsp;#session.ep.money#</span><cfelse>#TLFormat(toplam_kasa_para_tutari)#&nbsp;#session.ep.money#</cfif></cfoutput>
			</td>
		</tr>
		<tr>
			<td class="bold"><cf_get_lang dictionary_id='30776.Çekler Kasa'></td>
			<td class="text-right">
			<cfif len(get_cheque_in_cash.bakiye)>
				<cfoutput><cfif get_cheque_in_cash.bakiye lt 0><span class="font-red-mint">#TLFormat(get_cheque_in_cash.bakiye)#&nbsp;#session.ep.money#</span><cfelse>#TLFormat(get_cheque_in_cash.bakiye)#&nbsp;#session.ep.money#</cfif></cfoutput> 
			</cfif>
			</td>
		</tr>
		<tr>
			<td class="bold"><cf_get_lang dictionary_id='30777.Çekler Banka'></td>
			<td class="text-right">
			<cfif len(get_cheque_in_bank.bakiye)>
				<cfoutput>#TLFormat(get_cheque_in_bank.bakiye)#&nbsp;#session.ep.money#</cfoutput> 
			</cfif>
			</td>
		</tr>
		<tr>
			<td class="bold"><cf_get_lang dictionary_id='31246.Çekler Teminat'></td>
			<td class="text-right">
				<cfoutput><cfif len(get_cheque_in_guarantee.teminat_cekler)>#TLFormat(get_cheque_in_guarantee.teminat_cekler)#</cfif>&nbsp;#session.ep.money#</cfoutput> 
			</td>
		</tr>
		<tr> 
			<td class="bold"><cf_get_lang dictionary_id='30778.Verilen Çek'></td>
			<td class="text-right">
			<cfif len(get_cheque_to_pay.bakiye)>
				<cfoutput>#TLFormat(get_cheque_to_pay.bakiye)#&nbsp;#session.ep.money#</cfoutput> 
			</cfif>
			</td>
		</tr>
		<tr> 
			<td class="bold"><cf_get_lang dictionary_id='30967.Ödenecek Senetler'></td>
			<td class="text-right">
				<cfoutput><cfif voucher_pay lt 0><span class="font-red-mint">#TLFormat(voucher_pay)#&nbsp;#session.ep.money#</span><cfelse>#TLFormat(voucher_pay)#&nbsp;#session.ep.money#</cfif></cfoutput> 
			</td>
		</tr>
		<tr> 
			<td class="bold"><cf_get_lang dictionary_id='31042.Senetler Kasa'></td>
			<td class="text-right">
				<cfoutput><cfif voucher_cash lt 0><span class="font-red-mint">-#TLFormat(voucher_cash)#&nbsp;#session.ep.money#</span><cfelse>#TLFormat(voucher_cash)#&nbsp;#session.ep.money#</cfif></cfoutput> 
			</td>
		</tr>
		<tr> 
			<td class="bold"><cf_get_lang dictionary_id='31123.Senetler Banka'></td>
			<td class="text-right"><cfoutput>#TLFormat(voucher_bank)#&nbsp;#session.ep.money#</cfoutput></td>
		</tr>
		<tr>
			<td class="bold" nowrap="nowrap"><cf_get_lang dictionary_id='31248.Senetler Teminat'></td>
			<td class="text-right">
				<cfoutput><cfif len(get_voucher_in_guarantee.teminat_senetler)>#TLFormat(get_voucher_in_guarantee.teminat_senetler)#</cfif>&nbsp;#session.ep.money#</cfoutput> 
			</td>
		</tr>
		<tr>
			<td class="bold" nowrap="nowrap"><cf_get_lang dictionary_id='31250.Kredi Sözleşme Alacakları'></td>
			<td class="text-right">
				<cfif len(GET_SCN_REV.VALUE)>
					<cfoutput>#TLFormat(GET_SCN_REV.VALUE)# &nbsp;#session.ep.money#</cfoutput>
				</cfif>
			</td>
		</tr>
		<tr>
			<td class="bold" nowrap="nowrap"><cf_get_lang dictionary_id='31252.Kredi Sözleşme Borçları'></td>
			<td class="text-right">
				<cfif len(GET_SCN_PAYM.VALUE)>
					<cfoutput>#TLFormat(GET_SCN_PAYM.VALUE)# &nbsp;#session.ep.money#</cfoutput>
				</cfif>
			</td>
		</tr>
	<cfscript>
		CreateCompenent = CreateObject("component","/../workdata/get_open_order_ships");
		get_open_order_ships = CreateCompenent.getCompenentFunction();
		get_open_order_ships_pur = CreateCompenent.getCompenentFunction(is_purchase:1);
		order_total = get_open_order_ships.order_total;
		order_total_purchase = get_open_order_ships_pur.order_total;
		ship_total = get_open_order_ships.ship_total;
		ship_total_purchase = -1*get_open_order_ships_pur.ship_total;
	</cfscript>
		<tr> 
			<td class="bold"><cf_get_lang dictionary_id='30842.Alınan Siparişler'></td>
			<td class="text-right"><cfoutput>#TLFormat(order_total)#&nbsp;#session.ep.money#</cfoutput></td>
		</tr>
		<tr> 
			<td class="bold"><cf_get_lang dictionary_id='30851.Verilen Siparişler'></td>
			<td class="text-right"><cfoutput>#TLFormat(order_total_purchase)#&nbsp;#session.ep.money#</cfoutput></td>
		</tr>
	</tbody>
</cf_flat_list>
