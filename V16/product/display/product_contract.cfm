<cf_box title="#get_product_name(attributes.pid)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_seperator title="#getLang('','Satın alma Koşulları',37278)#" id="item_1">
	<cf_grid_list id="item_1"><cfinclude template="../display/purchase_prod_discount.cfm"></cf_grid_list>

	<cf_seperator title="#getLang('','Satış Koşulları',37044)#" id="item_2">
	<cf_grid_list id="item_2"><cfinclude template="../display/sales_prod_discount.cfm"></cf_grid_list>

	<cf_seperator title="#getLang('','Aksiyonlar',58988)#" id="item_3">
	<cf_grid_list id="item_3"><cfinclude template="../display/product_actions.cfm"></cf_grid_list>

</cf_box>