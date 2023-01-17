<cfif attributes.type eq 1>
    <cfquery name="get_product" datasource="#dsn3#" maxrows="100">
    SELECT
        (SELECT ROUND(PS_OZEL.PRICE_KDV,2) FROM PRICE_STANDART PS_OZEL WHERE PS_OZEL.PURCHASESALES = 1 AND PS_OZEL.PRODUCT_ID = PRODUCT.PRODUCT_ID AND PS_OZEL.PRICESTANDART_STATUS = 1) AS SATIS_KDV,
        PRODUCT.PRODUCT_ID,
        PRODUCT.PRODUCT_NAME,
        PRODUCT.PRODUCT_CODE,
        PRODUCT.PRODUCT_CODE_2,
        PRODUCT_UNIT.PRODUCT_UNIT_ID,
        PRODUCT_UNIT.MAIN_UNIT,
        (SELECT TOP 1 ROUND(ISNULL(PC.PURCHASE_NET_SYSTEM,0)+ISNULL(PC.PURCHASE_EXTRA_COST_SYSTEM,0),4) FROM PRODUCT_COST PC WHERE PC.PRODUCT_ID = PRODUCT.PRODUCT_ID ORDER BY PC.START_DATE DESC,PC.RECORD_DATE DESC) AS PRODUCT_COST,
        PRODUCT_CAT.PROFIT_MARGIN,
        PRODUCT_CAT.PRODUCT_CATID,
        PRODUCT.PRODUCT_STATUS
    FROM
        PRODUCT_CAT,
        PRODUCT_UNIT,
        PRODUCT
    WHERE
        PRODUCT.PRODUCT_CATID = PRODUCT_CAT.PRODUCT_CATID AND
        PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
        PRODUCT_UNIT.IS_MAIN = 1 AND
        (
        PRODUCT.PRODUCT_NAME IS NOT NULL
        <cfloop from="1" to="#listlen(attributes.keyword,' ')#" index="ccc">
            <cfset kelime_ = listgetat(attributes.keyword,ccc,' ')>
                AND
                (
                PRODUCT.PRODUCT_NAME LIKE '%#kelime_#%' OR
                PRODUCT.PRODUCT_CODE_2 = '#kelime_#' OR
                PRODUCT.PRODUCT_ID IN (SELECT S.PRODUCT_ID FROM STOCKS_BARCODES SB2,STOCKS S WHERE SB2.STOCK_ID = S.STOCK_ID AND SB2.BARCODE = '#kelime_#')
                )
        </cfloop>
        )
    ORDER BY
        PRODUCT.PRODUCT_NAME
    </cfquery>

    <cf_grid_list>
        <thead>
            <tr>
                <th><cf_get_lang dictionary_id='58221.Ürün Adı'></th>
                <th><cf_get_lang dictionary_id='58585.Kod'></th>
                <th><cf_get_lang dictionary_id='57789.Özel Kod'></th>
                <th><cf_get_lang dictionary_id='58084.Fiyat'></th>
                <th><cf_get_lang dictionary_id='57756.Durum'></th>
            </tr>
        </thead>
        <tbody>
            <cfoutput query="get_product">
            <cfset product_name_ = replace(product_name,'"','','all')>
            <cfset product_name_ = replace(product_name_,"'","","all")>
            <tr id="product_row_#product_id#">
                <td><a href="javascript://" onclick="window.opener.copy_product_func('#product_id#');window.close();" class="tableyazi">#product_name#</a></td>
                <td>#product_code#</td>
                <td>#product_code_2#</td>
                <td style="text-align:right;">#TLFORMAT(SATIS_KDV)#</td>
                <td><cfif PRODUCT_STATUS eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
            </tr>
            </cfoutput>
        </tbody>
    </cf_grid_list>
<cfelseif attributes.type eq 2>
	<cfquery name="get_product" datasource="#dsn3#" maxrows="100">
    SELECT
        (SELECT ROUND(PS_OZEL.PRICE_KDV,2) FROM PRICE_STANDART PS_OZEL WHERE PS_OZEL.PURCHASESALES = 1 AND PS_OZEL.PRODUCT_ID = PRODUCT.PRODUCT_ID AND PS_OZEL.PRICESTANDART_STATUS = 1) AS SATIS_KDV,
        PRODUCT.PRODUCT_ID,
        PRODUCT.PRODUCT_NAME,
        PRODUCT.PRODUCT_CODE,
        PRODUCT.PRODUCT_CODE_2,
        PRODUCT_UNIT.PRODUCT_UNIT_ID,
        PRODUCT_UNIT.MAIN_UNIT,
        PRODUCT_CAT.PROFIT_MARGIN,
        PRODUCT_CAT.PRODUCT_CATID,
        PRODUCT.PRODUCT_STATUS,
        STOCKS.STOCK_CODE PROPERTY,
        STOCKS.STOCK_CODE_2,
        STOCKS.STOCK_ID,
        (SELECT TOP 1 SB3.BARCODE FROM STOCKS_BARCODES SB3 WHERE SB3.STOCK_ID = STOCKS.STOCK_ID) AS SON_BARCODE
    FROM
        PRODUCT_CAT,
        PRODUCT_UNIT,
        PRODUCT,
        STOCKS
    WHERE
        PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
        PRODUCT.PRODUCT_CATID = PRODUCT_CAT.PRODUCT_CATID AND
        PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
        PRODUCT_UNIT.IS_MAIN = 1 AND
        (
        PRODUCT.PRODUCT_NAME IS NOT NULL
        <cfloop from="1" to="#listlen(attributes.keyword,' ')#" index="ccc">
            <cfset kelime_ = listgetat(attributes.keyword,ccc,' ')>
                AND
                (
                PRODUCT.PRODUCT_NAME LIKE '%#kelime_#%' OR
                STOCKS.PROPERTY LIKE '%#kelime_#%' OR
                STOCKS.STOCK_CODE_2 = '#kelime_#' OR
                STOCKS.STOCK_ID IN (SELECT SB2.STOCK_ID FROM STOCKS_BARCODES SB2 WHERE SB2.BARCODE = '#kelime_#')
                )
        </cfloop>
        )
    ORDER BY
        PRODUCT.PRODUCT_NAME
    </cfquery>
    <cfset stock_id_list = ''>
    <cfif get_product.recordcount>
    	<cfset stock_id_list = valuelist(get_product.STOCK_ID)>
    </cfif>
	<input type="hidden" name="stock_id_list" value="<cfoutput>#stock_id_list#</cfoutput>">
    <cf_grid_list>
        <thead>
            <tr>
                <th><cf_get_lang dictionary_id='33902.Stok Adı'></th>
                <th><cf_get_lang dictionary_id='57789.Özel Kod'></th>
                <th><cf_get_lang dictionary_id='57633.Barkod'></th>
                <th><cf_get_lang dictionary_id='57635.Miktar'></th>
            </tr>
        </thead>
        <tbody>
            <cfoutput query="get_product">
            <cfset property_ = replace(property,'"','','all')>
            <cfset property_ = replace(property_,"'","","all")>
            <input type="hidden" name="stock_name_#stock_id#" value="#property_#"/>
            <input type="hidden" name="stock_barcode_#stock_id#" value="#SON_BARCODE#"/>
            <tr id="product_row_#stock_id#">
                <td>#property_#</td>
                <td>#STOCK_CODE_2#</td>
                <td>#SON_BARCODE#</td>
                <td style="text-align:right;"><input type="text" name="amount_#stock_id#" value="" style="width:100px;" class="moneybox" onkeyup="return(FormatCurrency(this,event,2));"/></td>
            </tr>
            </cfoutput>
        </tbody>
    </cf_grid_list>
</cfif>