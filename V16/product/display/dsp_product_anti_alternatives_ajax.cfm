<!---ürün detay alternatif ürün ilişkisi--->
<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_anti_alternate_product.cfm">
<cf_flat_list>
    <tbody>
        <cfif get_alternate_product_except.recordcount>
            <cfoutput query="get_alternate_product_except">
                <tr>
                    <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#PRODUCT_ID#','list');">#product_name#</a></td>
                    <td width="20" class="text-right"><a href="javascript://" onClick="javascript:if(confirm('#getLang('','Alternatif Ürün Siliyorsunuz! Emin misiniz',37383)#')) windowopen('#request.self#?fuseaction=product.emptypopup_del_anative_product_except&anative_id=#GET_ALTERNATE_PRODUCT_EXCEPT.alternative_id#','small'); else return false;"><img src="/images/delete_list.gif" border="0" title="<cf_get_lang dictionary_id='57463.Sil'>"></a></td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
            </tr>    
        </cfif>    
    </tbody>
</cf_flat_list>
