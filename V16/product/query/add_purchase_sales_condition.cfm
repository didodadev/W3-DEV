<cfif attributes.purchase_sales is 1>
	<cfinclude template="add_purchase_prod_discount.cfm">
<cfelseif attributes.purchase_sales is 2>
	<cfinclude template="add_sales_prod_discount.cfm">
</cfif>

