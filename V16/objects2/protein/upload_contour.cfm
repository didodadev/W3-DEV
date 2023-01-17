<cfquery name="GET_STOCK" datasource="#DSN3#">
	SELECT 
		S.PRODUCT_ID,
        S.STOCK_ID,
        S.STOCK_CODE,
        S.PROPERTY,
        S.MANUFACT_CODE,
        S.PRODUCT_UNIT_ID,
        PU.MAIN_UNIT
	FROM 
		STOCKS AS S
        JOIN #dsn#_product.PRODUCT_UNIT AS PU ON S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID
	WHERE 
        S.STOCK_STATUS = 1
		AND S.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
</cfquery>


<form name="upload_countour" method="post">
    <div class="row">
        <div class="col-md-12">
            <table class="table">
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='60.Paketler'></th>
                        <th class="text-right"><cf_get_lang dictionary_id='57635.Miktar'></th>
                        <th><cf_get_lang dictionary_id='57636.Birim'></th>
                        <th class="text-right"><cf_get_lang dictionary_id='58084.Fiyat'></th>
                        <th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <cfif GET_STOCK.recordcount>
                        <cfoutput query = "GET_STOCK">
                            <tr>
                                <td>#PROPERTY#</td>
                                <td class="text-right">1</td>
                                <td>#MAIN_UNIT#</td>
                                <td class="text-right">#TLFormat(1000)#</td>
                                <td>TL</td>
                                <td><input type="radio" name="contour" value="#PRODUCT_ID#"></td>
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr><td colspan = "5"><cf_get_lang dictionary_id='57484.Kayıt Yok'></td></tr>
                    </cfif>
                </tbody>
            </table>
        </div>
    </div>
</form>