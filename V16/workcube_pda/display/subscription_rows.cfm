<cfquery name="GET_SUBSCRIPTION_ROWS" datasource="#DSN3#">
	SELECT 
    	PRODUCT_NAME,
        STOCK_ID,
        AMOUNT,
        UNIT,
        PRODUCT_NAME2
	FROM 
    	SUBSCRIPTION_CONTRACT_ROW
    WHERE 
    	SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
</cfquery>

<table border="0" class="color-border" cellpadding="2" cellspacing="1" style="width:98%">
	<tr class="color-header" style="height:22px;">
		<td class="form-title" colspan="6">Sistem Ürün Planı</td>
	</tr>
    <tr class="color-header">
    	<td class="form-title">No</td>
    	<td class="form-title">Stok Kodu</td>
        <td class="form-title">Ürün</td>
        <td class="form-title">Miktar</td>
        <td class="form-title">Birim</td>
        <td class="form-title">Açıklama 2</td>
    </tr>
	<cfoutput query="get_subscription_rows">
        <tr class="color-list">
        	<td>#currentrow#</td>
			<td>#stock_id#</a></td>
            <td>#product_name#</td>
			<td style="text-align:right;">#amount#</td>
			<td>#unit#</td>
			<td>#product_name2#</td>
        </tr>
    </cfoutput>
</table>



