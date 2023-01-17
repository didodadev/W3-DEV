<cf_ajax_list>
    <cfquery name="get_relation_product_cat" datasource="#dsn3#">
        SELECT
            PQ.ORDER_NO,
            PC.HIERARCHY,
            PC.PRODUCT_CAT,
            PQ.PROCESS_CAT
        FROM
            PRODUCT_QUALITY PQ,
            PRODUCT_CAT PC
        WHERE
            PQ.QUALITY_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.type_id#"> AND
            PQ.PRODUCT_CAT_ID IS NOT NULL AND
            PQ.PRODUCT_CAT_ID = PC.PRODUCT_CATID
        ORDER BY
            PC.HIERARCHY,
            PQ.ORDER_NO
    </cfquery>
    <cf_grid_list>
        <thead>
            <tr>
                <th style="width:35px;"><cf_get_lang dictionary_id='58577.Sıra'></th>
                <th style="width:250px;"><cf_get_lang dictionary_id='58585.Kod'></th>
                <th><cf_get_lang dictionary_id='57486.Kategori'></th>
                <th style="width:110px;"><cf_get_lang dictionary_id='57800.İşlem Tipi'></th>
            </tr>
        </thead>
        <tbody>
        <cfif get_relation_product_cat.recordcount>
            <cfoutput query="get_relation_product_cat">
                <tr>
                    <td>#order_no#</td>
                    <td>#hierarchy#</td>
                    <td>#product_cat#</td>
                    <td><cfif process_cat eq 76>
                            <cf_get_lang dictionary_id="29581.Mal Alım İrsaliyesi">
                        <cfelseif process_cat eq 171>
                            <cf_get_lang dictionary_id="29651.Üretim Sonucu">
                        <cfelseif process_cat eq 811>
                            <cf_get_lang dictionary_id="29588.İthal Mal Girişi">
                        <cfelseif process_cat eq -1>
                            <cf_get_lang dictionary_id='54365.Operasyonlar'>
                        <cfelseif process_cat eq -2>
                            <cf_get_lang dictionary_id='39892.Servisler'>
                        </cfif>
                    </td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
            </tr>
        </cfif>
        </tbody>
    </cf_grid_list>
</cf_ajax_list>
