<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('','Uyumsuz Ürünler',37507)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="add_product_anative" action="#request.self#?fuseaction=product.emptypopup_add_anative_product_except" method="post">
		<cf_grid_list>
			<input type="hidden" name="pid" id="pid" value="<cfoutput>#attributes.pid#</cfoutput>">
			<input type="hidden" name="anative_product_id" id="anative_product_id" value="">
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='57657.product'></th>
				</tr> 
			</thead>
			<tbody>
				<tr>
					<td>
						<div class="form-group">
							<div class="input-group">
								<cfsavecontent variable="set_error"><cf_get_lang dictionary_id='57541.Hata'><cf_get_lang dictionary_id='57657.product'></cfsavecontent>
								<cfinput type="text" name="product_name" value="" required="yes" message="#set_error#">
								<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_products_only&product_id=add_product_anative.anative_product_id&field_name=add_product_anative.product_name');"></span>					
							</div>
						</div>
					</td>
				</tr>
			</tbody>
		</cf_grid_list>
		<cf_box_footer>
			<cf_workcube_buttons is_upd='0' add_function="#iif(isdefined("attributes.draggable"),DE("kontrol() && loadPopupBox('add_product_anative' , #attributes.modal_id#)"),DE(""))#">
		</cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
function kontrol()
{
	if(document.add_product_anative.anative_product_id.value.length==0)
	{
		alert("<cf_get_lang dictionary_id='58227.Ürün Seçmelisiniz'>!");
		return false;
	}
	return true;
}
</script>
