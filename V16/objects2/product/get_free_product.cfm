<cfparam name="attributes.price_catid" default="-2">
<cfparam name="attributes.price_catid_2" default="-2">
<cfinclude template="../query/get_price_cats_moneys.cfm">
	<cfset attributes.price_catid_2 = 0>
	<cfset attributes.istenen_miktar = 0>
	<cfset attributes.pid = 0>
	<cfset attributes.product_id = 0>
	<cfset attributes.sid = 0>
	<cfset attributes.price = 0>
	<cfset attributes.price_old = 0>
	<cfset attributes.price_kdv = 0>
	<cfset attributes.price_money = 0>
	<cfset attributes.prom_id = 0>
	<cfset attributes.prom_discount = 0>
	<cfset attributes.prom_amount_discount = 0>
	<cfset attributes.prom_cost = 0>
	<cfset attributes.prom_free_stock_id = 0>
	<cfset attributes.prom_stock_amount = 0>
	<cfset attributes.prom_free_stock_amount = 0>
	<cfset attributes.prom_free_stock_price = 0>
	<cfset attributes.prom_free_stock_money = 0>	
	<cfset attributes.price_standard = 0>
	<cfset attributes.price_standard_kdv = 0>
	<cfset attributes.price_standard_money = 0>
