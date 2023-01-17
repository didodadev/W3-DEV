<cfsetting showdebugoutput="no">
<cfset cmp = createObject("component","V16.worknet.query.worknet_product") />
<cfset getProductImages = cmp.getProductImage(product_id:attributes.pid)>
<table class="ajax_list">
	<cfif getProductImages.recordcount>
		<cfoutput query="getProductImages">
			<tr>
				<td><a target="_blank" href="#file_web_path#product/#path#" class="tableyazi">#detail#</a></td>
				<td align="right" nowrap style="text-align:right; float:right;">
					<a href="javascript://" onClick="AjaxPageLoad('#request.self#?fuseaction=worknet.product_image&pimageid=#product_image_id#&pid=#attributes.pid#','body_product_images',1,'Loading..')"><img src="/images/update_list.gif"  border="0" title="<cf_get_lang_main no='52.Güncelle'>"></a>
				</td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr>
			<td colspan="2"><cf_get_lang_main no='72.Kayıt Yok'> !</td>
		</tr>
	</cfif>
</table>
