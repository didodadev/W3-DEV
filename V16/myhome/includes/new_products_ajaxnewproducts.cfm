<cfsetting showdebugoutput="no">
<cfset attributes.purchase=1>
<cfparam name="attributes.page" default=1>
<cfset attributes.maxrows=5><!--- query de bu kadar aliyor yeri degismesin --->
<cfinclude template="../query/get_product.cfm">
<cfparam name="attributes.totalrecords" default="#get_product.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_flat_list>
	<thead>
		<cfif get_product.recordcount>
		<tr>
			<th width="170"><cf_get_lang_main no='245.Ürün'></th>
			<th width="80"><cf_get_lang_main no='106.Stok Kodu'></th>
			<th><cf_get_lang_main no='221.Barkod'></th>
			<th width="65"><cf_get_lang no='146.Ana Birim'></th>
		</tr>
	</thead>
	<tbody>
			<cfoutput query="get_product" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td width="170"><a href="#request.self#?fuseaction=product.list_product&event=det&pid=#get_product.product_id[currentrow]#" class="tableyazi">#get_product.product_name[currentrow]#</a></td>
					<td width="80"><a href="#request.self#?fuseaction=product.list_product&event=det&pid=#get_product.product_id[currentrow]#" class="tableyazi">#get_product.product_code[currentrow]#</a></td>
					<td><a href="#request.self#?fuseaction=product.list_product&event=det&pid=#get_product.product_id[currentrow]#" class="tableyazi">#get_product.barcod[currentrow]#</a></td>
					<td width="65">#get_product.main_unit[currentrow]#</td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_flat_list>

