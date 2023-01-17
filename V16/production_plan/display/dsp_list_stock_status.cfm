<cfoutput>
	<cfinclude template="../query/get_stock_reserved.cfm">
	<cfset PRODUCT_STOCK=PRODUCT_TOTAL_STOCK.PRODUCT_TOTAL_STOCK>
	<cfif get_stock_reserved_artan.recordcount and len(get_stock_reserved_artan.ARTAN)>
		<cfset PRODUCT_STOCK = PRODUCT_STOCK + get_stock_reserved_artan.ARTAN>
	</cfif>
	<cfif get_stock_reserved_azalan.recordcount and len(get_stock_reserved_azalan.AZALAN)>
		<cfset PRODUCT_STOCK = PRODUCT_STOCK - get_stock_reserved_azalan.AZALAN>
	</cfif>
	<td align="right" style="text-align:right;"><cfif get_stock_reserved_azalan.recordcount>#get_stock_reserved_azalan.AZALAN#</cfif></td>
	<td align="right" style="text-align:right;"><cfif get_stock_reserved_artan.recordcount>#get_stock_reserved_artan.ARTAN#</cfif></td>
	<td align="right" style="text-align:right;">#WRK_ROUND(PRODUCT_STOCK)#</td>
	<td align="right" style="text-align:right;">#PRODUCT_TOTAL_STOCK.PRODUCT_TOTAL_STOCK#</td>
</cfoutput>
