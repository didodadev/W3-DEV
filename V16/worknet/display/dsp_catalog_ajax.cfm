<cfsetting showdebugoutput="no">
<cfset cmp = createObject("component","V16.worknet.query.worknet_product") />
<cfset get_product = cmp.getProduct(recordCount:10,product_status:1,is_catalog:1) />
<table class="ajax_list">
	<cfif get_product.recordcount>
        <thead>
            <tr>
                <th><cf_get_lang_main no="245.Ürün"></th>
                <th><cf_get_lang_main no="1195.Firma">-<cf_get_lang_main no="166.Yetkili"></th>
                <th colspan="2"><cf_get_lang_main no="74.Kategori"></th>
            </tr>
        </thead>
        <tbody>
			<cfoutput query="get_product">
                <tr>
                    <td>
                        <a href="#request.self#?fuseaction=worknet.detail_product&pid=#product_id#" class="tableyazi">#product_name#</a>
                    </td>
                    <td>#fullname#-#partner_name#</td>
                    <td>#product_cat#</td>
                    <td width="15"><a href="#request.self#?fuseaction=worknet.detail_product&pid=#product_id#"><img src="/images/update_list.gif" border="0"></a></td>
                </tr>
            </cfoutput>
            <tr>
                <td colspan="4" style="text-align:right;">
                    <a href="<cfoutput>#request.self#?fuseaction=worknet.list_catalog&form_submitted=1</cfoutput>"><cf_get_lang_main no="296.Tümü"></a>
                </td>
            </tr>
        </tbody>	
	<cfelse>
        <tbody>
            <tr>
                <td><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
            </tr>
        </tbody>
	</cfif>
</table>
