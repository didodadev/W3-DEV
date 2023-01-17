<cfoutput>
	<cfif kalan_stok>
	  <tr class="color-row" height="20">
		<td>#INVOICE_NUMBER#</td>
		<td>#dateformat(INVOICE_DATE,dateformat_style)#</td>
		<td>#NICKNAME#</td>
		<td align="right" style="text-align:right;">#tlformat(PRICE,4)#</td>
		<td align="right" style="text-align:right;">#tlformat(PRICE_OTHER,4)#&nbsp;#session.ep.money2#</td>
		<td>
			#tlformat(DISCOUNT1)# + #tlformat(DISCOUNT2)# + #tlformat(DISCOUNT3)# + #tlformat(DISCOUNT4)# + #tlformat(DISCOUNT5)# + #tlformat(DISCOUNT6)# + #tlformat(DISCOUNT7)# + #tlformat(DISCOUNT8)# + #tlformat(DISCOUNT9)# + #tlformat(DISCOUNT10)#</td>
		</td>
		<cfset net_fiyat = wrk_round((PRICE/100000000000000000000) * ( (100-discount1) * (100-discount2) * (100-discount3) * (100-discount4) * (100-discount5) * (100-discount6) * (100-discount7) * (100-discount8) * (100-discount9) * (100-discount10)),4)>
		<td align="right" style="text-align:right;">#tlformat(net_fiyat,4)#</td>
		<td align="right" style="text-align:right;">#tlformat(EXTRA_COST,4)#</td>
		<td align="right" style="text-align:right;">#tlformat(AMOUNT)#</td>
	  </tr>
	</cfif>
	<cfif kalan_stok gte AMOUNT>
		<cfset kalan_stok = kalan_stok - AMOUNT>
	<cfelse>
		<cfset kalan_stok = 0>
	</cfif>
</cfoutput>
