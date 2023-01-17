<cfquery name="GET_SHIP_PACKAGE_LIST" datasource="#DSN2#">
    SELECT 
        P.PRODUCT_CODE,
        P.PRODUCT_NAME,
        P.PRODUCT_CODE_2,
        SUM(SP.AMOUNT) AMOUNT,
        SUM(SP.CONTAINER_AMOUNT) CONTAINER_AMOUNT,
        SUM(SP.NET_WEIGHT) NET_WEIGHT,
        SUM(SP.GROSS_WEIGHT) GROSS_WEIGHT
    FROM 
    	SHIP_RESULT_PACKAGE SR,
        SHIP_RESULT_PACKAGE_PRODUCT SP,
        #dsn1_alias#.STOCKS S,
        #dsn1_alias#.PRODUCT P
    WHERE 
    	SR.SHIP_RESULT_PACKAGE_ID = SP.SHIP_RESULT_PACKAGE_ID
        AND SR.SHIP_ID =#attributes.action_id#
        AND S.STOCK_ID = SP.STOCK_ID
        AND S.PRODUCT_ID = P.PRODUCT_ID
    GROUP BY 
        P.PRODUCT_CODE,
        P.PRODUCT_NAME,
        P.PRODUCT_CODE_2,
        SP.STOCK_ID
    ORDER BY 
        SP.STOCK_ID	
</cfquery>	
	<table width="100%" cellpadding="2" cellspacing="0" border="1" bordercolor="000000">
		<tr style="height:5mm;text-align:right;font-weight:bold;">
            <td><cf_get_lang_main no='1165.Sıra'></td>
            <td><cf_get_lang_main no="106.Stok Kodu"></td>
            <td><cf_get_lang_main no="377.Özel Kod"></td>
            <td style="text-align:left"><cf_get_lang no='1512.Stok Adı'></td>
            <td><cf_get_lang no="927.Kap Sayısı"></td>
            <td><cf_get_lang no="928.Net Ağırlık"></td>
            <td><cf_get_lang no="929.Brüt Ağırlık"></td>
            <td><cf_get_lang_main no='223.Miktar'></td>
		</tr>
		<tbody>
		<cfif get_ship_package_list.recordcount>
			<cfoutput query="GET_SHIP_PACKAGE_LIST">
			<tr>
				<td style="text-align:right">#currentrow#</td>
                <td style="text-align:right">#PRODUCT_CODE#</td>
                <td style="text-align:right">#PRODUCT_CODE_2#</td>
				<td>#PRODUCT_NAME#</td>
                <td style="text-align:right">#CONTAINER_AMOUNT#</td>
                <td style="text-align:right">#NET_WEIGHT#</td>
                <td style="text-align:right">#GROSS_WEIGHT#</td>
				<td style="text-align:right">#Tlformat(amount,2)#</td>
			</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="8"><cf_get_lang_main no='72.Kayıt Yok'></td>
			</tr>
		</cfif>
		</tbody>
    </table>

