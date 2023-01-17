<cfquery name="get_related_products" datasource="#dsn3#">
	SELECT 
		RP.RELATED_PRODUCT_ID,
		P.PRODUCT_NAME,
		P.PRODUCT_CODE
	FROM 
		RELATED_PRODUCT AS RP, 
		PRODUCT AS P 
	WHERE 
		RP.PRODUCT_ID=#URL.PID# AND 
		P.PRODUCT_ID = RP.RELATED_PRODUCT_ID
	UNION ALL
	SELECT 
		RP.PRODUCT_ID AS RELATED_PRODUCT_ID,
		P.PRODUCT_NAME,
		P.PRODUCT_CODE
	FROM 
		RELATED_PRODUCT AS RP, 
		PRODUCT AS P 
	WHERE 
		RP.RELATED_PRODUCT_ID=#URL.PID# AND 
		P.PRODUCT_ID = RP.PRODUCT_ID
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='33223.İlişkili Ürünler'></cfsavecontent>
<cf_seperator id="iliskili_urunler" header="#message#" is_closed="1">
<cf_flat_list id="iliskili_urunler" style="display:none;">
     <thead>
        <tr>
          <th width="150"><cf_get_lang dictionary_id='58800.Ürün Kodu'></th>
          <th><cf_get_lang dictionary_id='58221.Ürün Adı'></th>
          <th width="150"><cf_get_lang dictionary_id='32544.Kullanılabilir Stok'></th>
        </tr>
     </thead>
     <tbody>
        <cfoutput query="get_related_products">
            <cfquery name="PRODUCT_TOTAL_STOCK" datasource="#dsn2#">
                SELECT 
                    GPS.PRODUCT_TOTAL_STOCK,
                    GPS.PRODUCT_ID,
                    PU.MAIN_UNIT
                FROM 
                    GET_PRODUCT_STOCK GPS,
                    #DSN3_ALIAS#.PRODUCT_UNIT AS PU
                WHERE 
                    GPS.PRODUCT_ID = #GET_RELATED_PRODUCTS.RELATED_PRODUCT_ID#
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
