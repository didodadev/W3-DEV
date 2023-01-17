<cfoutput>
	<cfif kalan_stok_sevk>
	  <tr class="color-row">
		<td>#ORDER_NUMBER#</td>
		<td>#dateformat(ORDER_DATE,dateformat_style)#</td>
		<td>#NICKNAME#</td>
		<td align="right" style="text-align:right;">#tlformat(PRICE,4)#</td>
		<td>
			#tlformat(DISCOUNT_1)# + #tlformat(DISCOUNT_2)# + #tlformat(DISCOUNT_3)# + 
			#tlformat(DISCOUNT_4)# + #tlformat(DISCOUNT_5)# + #tlformat(DISCOUNT_6)# + 
			#tlformat(DISCOUNT_7)# + #tlformat(DISCOUNT_8)# + 
			#tlformat(DISCOUNT_9)# + #tlformat(DISCOUNT_10)#
		</td>
		<cfset net_fiyat = wrk_round((PRICE/100000000000000000000) * ( (100-discount_1) * (100-discount_2) * (100-discount_3) * (100-discount_4) * (100-discount_5) * (100-discount_6) * (100-discount_7) * (100-discount_8) * (100-discount_9) * (100-discount_10)),4)>
		<td align="right" style="text-align:right;">#tlformat(net_fiyat,4)#</td>
		<td align="right" style="text-align:right;">#tlformat(COST_PRICE,4)#</td>
		<td align="right" style="text-align:right;">#tlformat(QUANTITY)#</td>
	  </tr>
	</cfif>
	<cfif kalan_stok_sevk gte QUANTITY>
		<cfset kalan_stok_sevk = kalan_stok_sevk - QUANTITY>
	<cfelse>
		<cfset kalan_stok_sevk = 0>
	</cfif>
</cfoutput>
