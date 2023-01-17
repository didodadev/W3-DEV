<!--- ürün detay iliskili ürünler --->
<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_related_product.cfm">
<cf_ajax_list>
	<thead>
		<tr>
			<th colspan="2">
				<cf_get_lang dictionary_id='46378.İlişkili Ürünler'>
			</th>
		</tr>
	</thead>
	<tbody>
		<cfif get_related_product.recordcount>
			<cfoutput query="get_related_product">
				<tr>
					<td><a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#PRODUCT_ID#','list');">#PRODUCT_NAME#</a></td>
					<cfsavecontent variable="del_pro"><cf_get_lang dictionary_id='37384.İlişkili Ürün Siliyorsunuz! Emin misiniz?'></cfsavecontent>
					<td width="15"><a href="javascript://" onClick="javascript:if(confirm('#del_pro#')) windowopen('#request.self#?fuseaction=product.emptypopup_del_related_product&related_id=#get_related_product.related_id#','small'); else return false;"><img src="/images/delete_list.gif" border="0" alt="<cf_get_lang dictionary_id='57463.Sil'>" title="<cf_get_lang dictionary_id='57463.Sil'>"></a></td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
			</tr>    
		</cfif>
	</tbody> 
</cf_ajax_list>
<cf_ajax_list>
	<thead>
		<tr>
			<th colspan="2">
				<cf_get_lang dictionary_id='64381.İlişkisi olan ürünler'>
			</th>
		</tr>
	</thead>
	<tbody>
		<cfif get_related_product2.recordcount>
			<cfoutput query="get_related_product2">
				<tr>
					<td><a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#PRODUCT_ID#','list');">#PRODUCT_NAME#</a></td>
					<cfsavecontent variable="del_pro"><cf_get_lang dictionary_id='37384.İlişkili Ürün Siliyorsunuz! Emin misiniz?'></cfsavecontent>
					<td width="15"><a href="javascript://" onClick="javascript:if(confirm('#del_pro#')) windowopen('#request.self#?fuseaction=product.emptypopup_del_related_product&related_id=#get_related_product.related_id#','small'); else return false;"><img src="/images/delete_list.gif" border="0" alt="<cf_get_lang dictionary_id='57463.Sil'>" title="<cf_get_lang dictionary_id='57463.Sil'>"></a></td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
			</tr>    
		</cfif>
	</tbody> 
</cf_ajax_list>

