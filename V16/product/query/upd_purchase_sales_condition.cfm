<cfif attributes.purchase_sales is 1>
	<cfinclude template="upd_purchase_prod_discount.cfm">
<cfelseif attributes.purchase_sales is 2>
	<cfinclude template="upd_sales_prod_discount.cfm">
</cfif>

