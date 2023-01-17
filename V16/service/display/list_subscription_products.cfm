<cfquery name="GET_SUBSCRIPTION_ROW" datasource="#DSN3#">
	SELECT
		SCR.STOCK_ID,
		SCR.PRODUCT_NAME,
		SCR.AMOUNT,
		SCR.UNIT,
		SCR.NETTOTAL,
		SCR.OTHER_MONEY,
		P.PRODUCT_CODE
	FROM
		SUBSCRIPTION_CONTRACT_ROW SCR,
		PRODUCT P
	WHERE
		SCR.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#"> AND
		SCR.PRODUCT_ID = P.PRODUCT_ID	
	ORDER BY
		SCR.SUBSCRIPTION_ROW_ID ASC
</cfquery>
<cf_ajax_list>
    <thead>
        <tr>
            <th><cf_get_lang_main no='106.Stok Kodu'></th>
            <th><cf_get_lang_main no='245.Urun'></th>
            <th><cf_get_lang_main no='223.Miktar'></th>
            <th><cf_get_lang_main no='224.Birim'></th>
            <th><cf_get_lang_main no='672.Fiyat'></th> 
        </tr>
    </thead>
    <tbody>
        <cfoutput query="get_subscription_row">
        <tr>
            <td>#product_code#</td>
            <td>#product_name#</td>
            <td>#tlformat(amount)#</td>
            <td>#unit#</td>
            <td>#tlformat(nettotal)# #other_money#</td>		  
        </tr>
        </cfoutput>
    </tbody>
</cf_ajax_list>

