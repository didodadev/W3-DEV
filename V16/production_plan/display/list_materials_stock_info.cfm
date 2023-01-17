<cfsetting showdebugoutput="no">
<cfoutput>
	<cfif listlen(stock_id_list_info1)>
		<table width="40%" cellpadding="2" cellspacing="1" class="color-border">
			<tr class="color-list">
				<td colspan="4" height="22" class="txtboldblue">
					<cf_get_lang dictionary_id='60531.Ağacı Olmayan Ürünler'>
				</td>
			</tr>
			<tr class="color-header" height="22">
				<td class="form-title"><cf_get_lang dictionary_id='57518.Stok Kodu'></td>
				<td class="form-title"><cf_get_lang dictionary_id='58221.Ürün Adı'></td>
				<td class="form-title"><cf_get_lang dictionary_id='34299.Spec'></td>
				<td class="form-title"><cf_get_lang dictionary_id='57635.Miktar'></td>
			</tr>
			<cfloop list="#stock_id_list_info1#" index="kk">
				<tr class="color-row" height="22">
					<td>#listgetat(kk,1,';')#</td>
					<td><cfif listlen(kk,';') gt 3>#listgetat(kk,4,';')#</cfif></td>
					<td><cfif listlen(kk,';') gt 2>#listgetat(kk,3,';')#</cfif></td>
					<td><cfif listlen(kk,';') gt 1>#listgetat(kk,2,';')#</cfif></td>
				</tr>
			</cfloop>
		</table>
	</cfif>
	<cfif listlen(stock_id_list_info2)><br/>
		<table width="40%" cellpadding="2" cellspacing="1" class="color-border">
				<tr class="color-list">
					<td colspan="4" height="22" class="txtboldblue">
						<cf_get_lang dictionary_id='60532.Bulunamayan Ürünler'>
					</td>
				</tr>
				<tr class="color-header" height="22">
					<td class="form-title"><cf_get_lang dictionary_id='57518.Stok Kodu'></td>
					<td class="form-title"><cf_get_lang dictionary_id='58221.Ürün Adı'></td>
					<td class="form-title"><cf_get_lang dictionary_id='34299.Spec'></td>
					<td class="form-title"><cf_get_lang dictionary_id='57635.Miktar'></td>
				</tr>
				<cfloop list="#stock_id_list_info2#" index="kk">
					<tr class="color-row" height="22">
						<td>#listgetat(kk,1,';')#</td>
						<td></td>
						<td><cfif listlen(kk,';') gt 2>#listgetat(kk,3,';')#</cfif></td>
						<td><cfif listlen(kk,';') gt 1>#listgetat(kk,2,';')#</cfif></td>
					</tr>
				</cfloop>
		</table>
	</cfif>
</cfoutput>

