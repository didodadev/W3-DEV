<cfset attributes.product_name = get_product_name(attributes.pid)>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='32994.Satın Alma Koşulları'></cfsavecontent>
<cf_seperator header="#message#: #attributes.product_name#" id="satinalma_kosullari">
<cf_grid_list id="satinalma_kosullari"><cfinclude template="../display/purchase_prod_discount.cfm"></cf_grid_list>

<cfsavecontent variable="message"><cf_get_lang dictionary_id='33065.Satış Koşulları'></cfsavecontent>
<cf_seperator header="#message#" id="satis_kosullari">
<cf_grid_list id="satis_kosullari"><cfinclude template="sale_prod_discount.cfm"></cf_grid_list>

<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.branch_id") and len(attributes.branch_id)>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='33938.Genel İskontolar'></cfsavecontent>
	<cf_seperator header="#message#" id="genel_iskonto">
	<cf_grid_list id="genel_iskonto"><cfinclude template="../display/purchase_prod_general_discount.cfm"></cf_grid_list>
</cfif>

<cfsavecontent variable="message"><cf_get_lang dictionary_id='58988.Aksiyonlar'></cfsavecontent>
<cf_seperator header="#message#" id="aksiyonlar">
<cf_grid_list id="aksiyonlar"><cfinclude template="../display/product_action_search.cfm"></cf_grid_list>

