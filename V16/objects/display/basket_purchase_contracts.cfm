<!--- 
		Sayfa: Kim tarafindan ahzirlandi bilinmiyor.
		Update: Arzu BT 18022004
		Neden:	Bu sayfa session dan calisiyordu.Artik sessiondan degil veritabanindan gelicek.
		Update gunu icinde workcube_cf icinde arama yaptim 2 sayfada cikti:
		detail_order.cfm ve detail_order_sa.cfm 
 --->

<!--- Satınalma Koşulları --->
<cfinclude template="../query/get_paymethods.cfm">
<cfinclude template="../query/get_sale_contract_detail.cfm">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='32994.Satın Alma Koşulları'></cfsavecontent>
<cf_seperator title="#message#" id='satinalma_kosullari'>
<cf_flat_list id='satinalma_kosullari'>
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id='57657.Ürün'></th>
			<th><cf_get_lang dictionary_id='29533.Tedarikçi'></th>
			<th><cf_get_lang dictionary_id='33134.Geçerlilik'></th>
			<th><cf_get_lang dictionary_id='57641.isk'></th>
			<th><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></th>
			<th><cf_get_lang dictionary_id='33133.Teslim'><cf_get_lang dictionary_id='57490.Gün'></th>
			<th></th>
			<!--- <td class="txtbold">İndirimli Fiyat</td> --->
		</tr>
	</thead>
	<tbody>
		<cfloop from="1" to="#ArrayLen(sepet.satir)#" index="i">
			<cfset attributes.pid = sepet.satir[i].product_id>
			<cfinclude template="../../product/query/get_purchase_prod_discount_detail.cfm">
			<cfoutput query="GET_PURCHASE_PROD_DISCOUNT_DETAIL">
				<tr>
					<td>#sepet.satir[i].product_name#</td>
					<td>
						<cfif isdefined('COMPANY') and ListLen(ListSort(COMPANY,'numeric'))>
							<cfset attributes.COMP_ID = ListFirst(ListSort(COMPANY,'numeric','Asc',','))>
							<cfinclude template="../query/get_company_name.cfm">
							<cfif get_company_name.recordcount>
								#get_company_name.NICK_NAME#
							</cfif>
							<cfelseif len(COMPANY_ID)>
								<cfset attributes.COMP_ID = COMPANY_ID>
							<cfinclude template="../query/get_company_name.cfm">
							<cfif get_company_name.recordcount>#get_company_name.NICK_NAME#</cfif>
						</cfif>
					</td>
					<td>
						<cfif len(start_date)>
							#dateformat(start_date,dateformat_style)#
						<cfelseif DateFormat(STARTDATE,dateformat_style) neq '01/01/1900'>
							#DateFormat(STARTDATE,dateformat_style)# - #DateFormat(FINISHDATE,dateformat_style)#
						</cfif>
					</td>
					<td class="moneybox"><cfif len(DISCOUNT1) and DISCOUNT1 gt 0>#TLFormat(DISCOUNT1)#</cfif></td>
					<td class="moneybox"><cfif len(DISCOUNT2) and DISCOUNT2 gt 0>#TLFormat(DISCOUNT2)#</cfif></td>
					<td class="moneybox"><cfif len(DISCOUNT3) and DISCOUNT3 gt 0>#TLFormat(DISCOUNT3)#</cfif></td>
					<td class="moneybox"><cfif len(DISCOUNT4) and DISCOUNT4 gt 0>#TLFormat(DISCOUNT4)#</cfif></td>
					<td class="moneybox"><cfif len(DISCOUNT5) and DISCOUNT5 gt 0>#TLFormat(DISCOUNT5)#</cfif></td>
					<td>
						<cfset paymethod_idpaymethod_id = paymethod_id>
						<cfloop query="PAYMETHODS">
							<cfif paymethod_idpaymethod_id IS PAYMETHODS.paymethod_id>
								#PAYMETHODS.paymethod#
							</cfif>
						</cfloop>
					</td>
					<td align="center">#delivery_dateno#</td>
					<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=product.popup_upd_purchase_sales_condition&discount_id=#C_P_PROD_DISCOUNT_ID#&pid=#attributes.pid#&type=1','page');"><img src="/images/update_list.gif" border="0"></a></td>
				</tr>
			</cfoutput> 			  
		</cfloop>
	</tbody>
</cf_flat_list>
