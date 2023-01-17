<cfset cmp = createObject("component","V16.worknet.cfc.worknet")>
<cfset get_related_product = cmp.get_related_product(catalog_id : attributes.id)>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.totalrecords" default="#get_related_product.recordcount#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >
<div id="w_products">
    <cf_flat_list>
        <tbody>
            <cfif get_related_product.recordcount>
                <cfoutput query="get_related_product" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr id="product_#currentrow#">
                        <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#PRODUCT_ID#','list');">#PRODUCT_NAME#</a></td>
                        <td width="20"><a href="javascript://" onclick="delData(#catalog_id#,#product_id#,#currentrow#)"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
                    </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                </tr>    
            </cfif>
        </tbody> 
    </cf_flat_list>
    <cfif attributes.maxrows lt attributes.totalrecords>
        <cf_paging
            page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="objects.widget_loader&widget_load=catalogProducts&isbox=1&id=#attributes.id#"
            isAjax="1"
            target="w_products">
    </cfif>
    <script>
        function delData(catalog_id, product_id, rowid){
            AjaxControlPostData('V16/worknet/cfc/worknet.cfc?method=delete_related_product&catalog_id='+catalog_id+'&product_id='+product_id, data, function(response){
                $("tr#product_"+rowid).remove();
                jQuery('#list_related_products .catalyst-refresh' ).click();
            });
            return false;
        }
    </script>
</div>
