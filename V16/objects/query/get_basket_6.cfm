<cfif isdefined("attributes.ORDER_ID") and isdefined("attributes.basket_sub_id") and len(attributes.basket_sub_id) and not isdefined('attributes.fromSaleOrder')>
	<!--- order copy islemi --->
	<cfinclude template="get_sub_basket_6_3.cfm">
<cfelseif (isdefined("attributes.ORDER_ID") and len(attributes.ORDER_ID) and not isdefined('attributes.fromSaleOrder')) or isdefined('attributes.from_project_material') or isdefined("attributes.is_from_report")><!--- attributes.from_project_material == proje malzeme ihtiyaç listesinden geliyorsa e project_id anlamına geliyor --->
	<!--- order update islemi --->
	<cfinclude template="get_basket_6_2.cfm">
<cfelseif isdefined("attributes.offer_id")>
	<cfinclude template="get_basket_5.cfm">
<cfelse>
	<!--- order add islemi --->
	<cfinclude template="get_basket_6_1.cfm">
</cfif>
