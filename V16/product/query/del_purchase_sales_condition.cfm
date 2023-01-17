<cfif attributes.purchase_sales IS 1>
	<cfinclude template="del_purchase_prod_discount.cfm">
<cfelseif attributes.purchase_sales IS 2>
	<cfinclude template="del_sales_prod_discount.cfm">
</cfif>

