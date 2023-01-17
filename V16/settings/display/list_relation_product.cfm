<cf_ajax_list>
<cfquery name="get_relation_product" datasource="#dsn3#">
    SELECT
        PQ.ORDER_NO,
        P.PRODUCT_CODE,
        P.PRODUCT_CODE_2,
        P.BARCOD,
        P.PRODUCT_NAME,
        PC.PRODUCT_CAT,
        PQ.PROCESS_CAT
    FROM
        PRODUCT_QUALITY PQ,
        PRODUCT P
        LEFT JOIN PRODUCT_CAT PC ON PC.PRODUCT_CATID = P.PRODUCT_CATID
    WHERE
        PQ.QUALITY_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.type_id#"> AND
        PQ.PRODUCT_ID IS NOT NULL AND
        PQ.PRODUCT_ID = P.PRODUCT_ID
    ORDER BY
        P.PRODUCT_CODE,
        PQ.ORDER_NO
</cfquery>
<cf_grid_list>
    <thead>
        <tr>
            <th style="width:25px;"><cf_get_lang dictionary_id='58577.Sıra'></th>
            <th style="width:250px;"><cf_get_lang dictionary_id='58800.Ürün Kodu'></th>
            <th><cf_get_lang dictionary_id='57789.Özel Kod'></th>
            <th style="width:90px;"><cf_get_lang dictionary_id='57633.Barkod'></th>
            <th><cf_get_lang dictionary_id='57657.Ürün'></th>
            <th><cf_get_lang dictionary_id='57486.Kategori'></th>
            <th style="width:110px;"><cf_get_lang dictionary_id='57800.İşlem Tipi'></th>
        </tr>
    </thead>
    <tbody>
        <cfif get_relation_product.recordcount>
            <cfoutput query="get_relation_product">
            <tr>
                <td>#order_no#</td>
                <td>#product_code#</td>
                <td>#product_code_2#</td>
                <td>#barcod#</td>
                <td>#product_name#</td>
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
                <td colspan="7"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
            </tr>
        </cfif>
    </tbody>
</cf_grid_list>
</cf_ajax_list>
