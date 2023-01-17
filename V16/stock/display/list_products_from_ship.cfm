<cfquery name="GET_PRODUCTS_FROM_SHIP" datasource="#dsn2#">
    SELECT
        SR.PRODUCT_ID,
        SR.NAME_PRODUCT,
        SR.AMOUNT,
        SR.PRODUCT_MANUFACT_CODE
    FROM 
        SHIP_ROW AS SR
    WHERE 
        SR.SHIP_ID = #attributes.ship_id#
</cfquery>
<cf_ajax_list>
	<thead>
    	<th>Sıra</th>
		<th>Ürün Adı</th>
		<th>Ürün Kodu</th>
        <th>Miktarı</th>
    </thead>
    <tbody>
		<cfoutput query="GET_PRODUCTS_FROM_SHIP">
            <tr>
            	<td width="25">#currentrow#</td>
                <td>#NAME_PRODUCT#</td>
                <td width="100">#PRODUCT_MANUFACT_CODE#</td>
                <td width="50">#AMOUNT#</td>
            </tr>
        </cfoutput>
    </tbody>
</cf_ajax_list>
