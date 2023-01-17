<cfsetting showdebugoutput="no">
<cfquery name="GET_PRODUCT" datasource="#DSN3#">
	SELECT 
    	PR.*,
        S.PRODUCT_NAME + ' ' + ISNULL(S.PROPERTY,'') AS PRODUCT_NAME,
        S.STOCK_CODE,
        P.PRODUCT_CODE_2 AS SPECIAL_CODE
    FROM 
    	PRODUCT_PLACE_ROWS PR,
        STOCKS S
		LEFT JOIN PRODUCT AS P ON P.PRODUCT_ID = S.PRODUCT_ID
    WHERE
		PR.STOCK_ID = S.STOCK_ID AND
	    PR.PRODUCT_PLACE_ID = #attributes.shelf_id# 
</cfquery>
    <cf_flat_list>
        <thead>
            <tr>
            	<th colspan="5"><cf_get_lang dictionary_id='57564.Ürünler'></th>
            </tr>
            <tr>
                <th width="35"><cf_get_lang dictionary_id='57487.no'></th>
                <th><cf_get_lang dictionary_id='57657.Ürün'></th>
                <th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
                <th><cf_get_lang dictionary_id='57789.Özel Kod'></th>
                <th width="60"><cf_get_lang dictionary_id='57635.Miktar'></th>
            </tr>
		</thead>
		<tbody>
            <cfoutput query="GET_PRODUCT">
                <tr class="color-row" height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';">
                    <td>#get_product.currentrow#</td>
                    <td>#product_name#</td>
                    <td>#STOCK_CODE#</td>
                    <td>#SPECIAL_CODE#</td>
                    <td>#TLFormat(amount,2)#</td>
                </tr>
            </cfoutput>
        </tbody>
    </cf_flat_list>
