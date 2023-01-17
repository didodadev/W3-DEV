<!---Urun detay alternatif urun ilisikisi--->
<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_alternate_product.cfm">
<cf_flat_list>
	<tbody>
		<cfif get_alternate_product.recordcount>
			<cfoutput query="get_alternate_product">
				<tr id="__erase__#alternative_id#_#currentrow#">
					<td width="20"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#&paid=#alternative_product_id#');">#alternative_product_no#</a></td>
					<td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_detail_product&pid=#alternative_product_id#');">#product_name#</a></td>
					<div id="erase#alternative_id#" style="display:none;"></div>	
					<td width="20"><a href="javascript://" onClick="javascript:if(confirm('#getLang('','İlişkili Ürün Siliyorsunuz! Emin misiniz?',37384)#')) openBoxDraggable('#request.self#?fuseaction=product.emptypopup_del_anative_product&anative_id=#get_alternate_product.alternative_id#'); else return false;"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
			</tr>   
		</cfif>
	</tbody>    
</cf_flat_list>
