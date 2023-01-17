<!--- <cfset getProductImage = cmp.getProductImage(product_id:attributes.pid,image_type:1)> --->
<cfsavecontent variable="text"><cf_get_lang dictionary_id='51665.Photo'></cfsavecontent>
<cf_box id="box_photo" closable="0" title="#text#">
	<table align="center" width="100%">
		<tr>
			<td style="text-align:center;">
				<cfif len(getProduct.path)>
					<cf_get_server_file output_file="#getProduct.path#" output_server="#getProduct.path_server_id#" output_type="0" image_width="250">
				<cfelse>
					<img src="/images/no_photo.gif" alt="<cf_get_lang no='495.Yok'>" title="<cf_get_lang no='495.Yok'>" width="250">
				</cfif>
			</td>
		</tr>
	</table>
</cf_box>

<!--- <cfsavecontent variable="text"><cf_get_lang_main no='1965.İmaj'></cfsavecontent>
<cf_box id="product_images" title="#text#" closable="0" collapsable="0" style="width:98%;" box_page="#request.self#?fuseaction=worknet.emptypopup_list_product_images&pid=#attributes.pid#"
	add_href="AjaxPageLoad('#request.self#?fuseaction=worknet.product_image&pid=#attributes.pid#&product_name=#getProduct.product_name#','body_product_images',0,'Loading..')">
</cf_box>

<cfsavecontent variable="text"><cf_get_lang_main no='156.Belgeler'></cfsavecontent>
<cfif getProduct.is_catalog eq 1>
	<cf_box id="relation_assets" title="#text#" closable="0" style="width:98%;" box_page="#request.self#?fuseaction=worknet.emptypopup_list_relation_asset&action_id=#attributes.pid#&action_section=WORKNET_PRODUCT_ID&asset_cat_id=-25"
        add_href="AjaxPageLoad('#request.self#?fuseaction=worknet.form_relation_asset&action_id=#attributes.pid#&action_section=WORKNET_PRODUCT_ID&asset_cat_id=-25','body_relation_assets',0,'Loading..')">
    </cf_box>
<cfelse>
    <cf_box id="relation_assets" title="#text#" closable="0" style="width:98%;" box_page="#request.self#?fuseaction=worknet.emptypopup_list_relation_asset&action_id=#attributes.pid#&action_section=WORKNET_PRODUCT_ID&asset_cat_id=-3"
        add_href="AjaxPageLoad('#request.self#?fuseaction=worknet.form_relation_asset&action_id=#attributes.pid#&action_section=WORKNET_PRODUCT_ID&asset_cat_id=-3','body_relation_assets',0,'Loading..')">
    </cf_box>
</cfif> --->
