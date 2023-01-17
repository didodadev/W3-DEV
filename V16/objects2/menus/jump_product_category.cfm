<cfinclude template="../query/get_product_cats.cfm">
<select name="url" id="url" style="width:100%" onchange="if (this.options[this.selectedIndex].value != 'null') { window.open(this.options[this.selectedIndex].value,'_self') }">
	<option><cf_get_lang_main no='155.Ürün Kat'></option>
	<cfoutput query="get_product_cat">
		<option value="#request.self#?fuseaction=objects2.view_product_list&product_catid=#product_catid#">#product_cat#</option>
	</cfoutput>
</select>
