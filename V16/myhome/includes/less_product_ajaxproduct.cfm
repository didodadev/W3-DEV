<cfsetting showdebugoutput="no">
<cfset attributes.gt_ =2>
<cfset attributes.maxrows=10>
<cfinclude template="get_product_strategy_with_saleable_stok.cfm">
<cf_flat_list>
	<cfif get_strategy.recordcount>
		<thead>
			<tr>
				<th><cf_get_lang_main no="245.ürün"></th>
				<th style="text-align:right;"><cf_get_lang_main no="223.miktar"></th>
				<th><cf_get_lang_main no="1715.toplam stok"></th>
			</tr>
		</thead>
		<tbody>
			<cfoutput query="get_strategy" maxrows="#attributes.maxrows#">
				<tr>
					<td><a href="#request.self#?fuseaction=product.list_product&event=det&pid=#get_strategy.product_id#" class="tableyazi">#get_strategy.product_name# #get_strategy.property#</a></td>
					<td style="text-align:right;" title="Yeniden Sipariş Noktası">(#TLFormat(get_strategy.REPEAT_STOCK_VALUE)#)</td>
					<td style="color:red;" title="Satılabilir Stok">#TLFormat(get_strategy.product_total_stock)#</td>
				</tr>
			</cfoutput>
		</tbody>
	<cfelse>
		<tbody>
				<tr>
					<td><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
				</tr>
		</tbody>
	</cfif>
</cf_flat_list>


