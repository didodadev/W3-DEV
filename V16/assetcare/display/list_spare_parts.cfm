<cfset list_parts = createObject("component","V16.assetcare.cfc.assetp_spare_parts")>
<cfset list_parts.dsn = dsn>
<cfset get_parts = list_parts.list_parts(ASSET_P_ID : attributes.asset_id)>
<div id="list_part">
    <cf_grid_list>
        <thead>
            <tr>
                <th width="25"><cf_get_lang dictionary_id='57487.No'></th>
                <th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
                <th><cf_get_lang dictionary_id='57657.Ürün'>- <cf_get_lang dictionary_id='57452.Stok'></th>
                <th><cf_get_lang dictionary_id='36199.Açıklama'></th>
                <th class="text-right"><cf_get_lang dictionary_id='57635.Miktar'></th>
                <th class="text-center"><cf_get_lang dictionary_id='57636.Birim'></th>
                <th><cf_get_lang dictionary_id='63951.Değişim Periyodu'></th>
                <th><cf_get_lang dictionary_id='64002.Değişim Değeri'></th>
                <th><cf_get_lang dictionary_id='52224.Risk Puanı'></th>
                <th width="25"><a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=assetcare.list_spare_parts&event=add&asset_p_id=#attributes.asset_id#</cfoutput>','','ui-draggable-box-medium')"><i class="fa fa-plus"></i></a></th>
            </tr>
        </thead>
        <tbody>
            <cfif get_parts.recordcount>
                <cfoutput query="get_parts">
                    <tr>
                        <td>#currentrow#</td>
                        <td>#STOCK_CODE#</td>
                        <td>#PRODUCT_NAME#</td>
                        <td>#DETAIL#</td>
                        <td class="text-right">#QUANTIY#</td>
                        <td class="text-center">#MAIN_UNIT#</td>
                        <td>
                            <cfif CHANGE_PERIOD eq 1>
                                <cf_get_lang dictionary_id='63972.Çalışma Saatine Göre'>
                            <cfelseif CHANGE_PERIOD eq 2>
                                <option value="2"><cf_get_lang dictionary_id='63973.Güne Göre'>
                            <cfelseif CHANGE_PERIOD eq 3>
                                <option value="3"><cf_get_lang dictionary_id='63976.Sayaç'>
                            <cfelse>&nbsp
                            </cfif>
                        </td>
                        <td>#CHANGE_AMOUNT#</td>
                        <td>#RISK_POINT#</td>
                        <td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=assetcare.list_spare_parts&event=upd&asset_p_id=#attributes.asset_id#&asset_parts_id=#ASSET_P_PARTS_ID#','','ui-draggable-box-medium')"><i class="fa fa-pencil"></i></a></td>
                    </tr>
                </cfoutput>
            </cfif>
        </tbody>
    </cf_grid_list>
    <cfif get_parts.recordcount eq 0>
        <div class="ui-info-bottom">
            <p><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</p>
        </div>
    </cfif>
</div>
<script>
    $(document).attr("title", "<cf_get_lang dictionary_id='47149.Makine-Ekipman ve Binalar'>");
</script>