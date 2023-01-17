<cfquery name="get_alternative_products" datasource="#dsn3#">
	SELECT 
		AP.ALTERNATIVE_PRODUCT_ID,
		P.PRODUCT_NAME,
		P.PRODUCT_CODE
	FROM 
		ALTERNATIVE_PRODUCTS AS AP, 
		PRODUCT AS P 
	WHERE 
		AP.PRODUCT_ID=#URL.PID# AND 
		P.PRODUCT_ID = AP.ALTERNATIVE_PRODUCT_ID
UNION ALL
	SELECT 
		AP.PRODUCT_ID AS ALTERNATIVE_PRODUCT_ID,
		P.PRODUCT_NAME,
		P.PRODUCT_CODE
	FROM 
		ALTERNATIVE_PRODUCTS AS AP, 
		PRODUCT AS P 
	WHERE 
		AP.ALTERNATIVE_PRODUCT_ID=#URL.PID# AND 
		P.PRODUCT_ID = AP.PRODUCT_ID
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='32776.Alternatif Ürünler'></cfsavecontent>
<cf_seperator id="alternatif_urunler" header="#message#" is_closed="1">
<cf_flat_list id="alternatif_urunler" style="display:none;">
    <thead>
        <tr>
          <th width="150"><cf_get_lang dictionary_id='58800.Ürün Kodu'></th>
          <th><cf_get_lang dictionary_id='58221.Ürün Adı'></th>
          <th width="150"><cf_get_lang dictionary_id='32544.Kullanılabilir Stok'></th>
        </tr>
    </thead>
    <tbody>
        <cfoutput query="get_alternative_products">
            <cfquery name="PRODUCT_TOTAL_STOCK" datasource="#dsn2#">
                SELECT 
                    GPS.PRODUCT_TOTAL_STOCK,
                    GPS.PRODUCT_ID,
                    PU.MAIN_UNIT
                FROM 
                    GET_PRODUCT_STOCK GPS,
                    #DSN3_ALIAS#.PRODUCT_UNIT AS PU
                WHERE 
                    GPS.PRODUCT_ID = #GET_ALTERNATIVE_PRODUCTS.ALTERNATIVE_PRODUCT_ID#
                AND
                    PU.PRODUCT_ID=GPS.PRODUCT_ID 
            </cfquery>
          <tr>
            <td>#product_code#</td>
            <td>#product_name#</td>
            <td class="moneybox">#TLFormat(product_total_stock.product_total_stock)# #product_total_stock.main_unit#</td>
          </tr>
        </cfoutput>
    </tbody>
</cf_flat_list>
