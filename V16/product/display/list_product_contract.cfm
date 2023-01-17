<table width="98%" align="center">
	<tr>
		<td height="35">
			<cfoutput>
			<table cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<cfset attributes.product_name = get_product_name(attributes.pid)>
					<td class="headbold"><cf_get_lang dictionary_id='50762.Satınalma Koşulları'> : #attributes.product_name#</td>
					<td align="right" style="text-align:right;"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=product.popup_std_sale&price_type=purc&pid=#attributes.pid#','list');"><img src="/images/history.gif" border="0" title="Ürün Fiyat Tarihçe"></a></td>
				</tr>
			</table>			
		</cfoutput>
		</td>
	</tr>
</table>

<table width="98%" align="center">
	<tr>
		<td><cfinclude template="purchase_prod_discount.cfm"></td>
	</tr>
	<tr><td class="headbold" height="35"><cf_get_lang dictionary_id='58988.Aksiyonlar'></td></tr>
	<tr><td><cfinclude template="product_action_search.cfm"></td></tr>	
</table>
