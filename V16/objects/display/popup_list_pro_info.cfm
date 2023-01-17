<cfinclude template="../query/get_info_plus_product.cfm">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='33116.Ürün Ek Bilgileri'></cfsavecontent>
<cf_seperator id="urun_ek_bilgiler" header="#message#" is_closed="1">
    <cf_flat_list id="urun_ek_bilgiler" style="display:none;">
        <tbody>
            <cfif GET_VALUES.RECORDCOUNT>
                <cfloop index="i" from="1" to="20">				  	
                    <cfif len(Evaluate("GET_VALUES.PROPERTY#i#_NAME"))>
                    <tr>
                        <td class="bold" width="100"><cfoutput>#Evaluate("GET_VALUES.PROPERTY#i#_NAME")#</cfoutput></td>
                        <td><cfoutput>#Evaluate("GET_VALUES.PROPERTY#i#")#</cfoutput></td>
                    </tr>
                    </cfif>                    
                </cfloop>
            <cfelse>
                <tr>
                    <td><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                </tr>
            </cfif>
        </tbody>
    </cf_flat_list>

