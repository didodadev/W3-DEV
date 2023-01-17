<cfquery name="get_prod_stocks" datasource="#dsn3#">
	SELECT
		S.STOCK_ID,
		#dsn#.Get_Dynamic_Language(P.PRODUCT_ID,'#session.ep.language#','PRODUCT','PRODUCT_NAME',NULL,NULL,P.PRODUCT_NAME) AS PRODUCT_NAME,
		S.PROPERTY,
		S.STOCK_CODE
	FROM
		STOCKS S,
		PRODUCT P
	WHERE
		S.PRODUCT_ID = P.PRODUCT_ID AND
		P.PRODUCT_ID = #attributes.pid#
</cfquery>
<cfquery name="GET_UNITS" datasource="#dsn3#">
	SELECT ADD_UNIT,PRODUCT_UNIT_ID FROM PRODUCT_UNIT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> AND PRODUCT_UNIT_STATUS = 1
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='58635.Stok Stratejileri'></cfsavecontent>
<cf_seperator id="stok_stratejisi" header="#message#" is_closed="1">
<cf_flat_list id="stok_stratejisi"  style="display:none;">
    <thead>
        <tr>
            <th><cf_get_lang dictionary_id ='57518.Stok Kodu'></th>
            <th width="120px;"><cf_get_lang dictionary_id ='57657.Ürün'></th>
            <th width="70px;"><cf_get_lang dictionary_id='37667.Strateji Türü'></th>
            <th><cfoutput>#getLang('stock',26)#</cfoutput></th>
            <th><cfoutput>#getLang('stock',29)#</cfoutput></th>
            <th><cf_get_lang dictionary_id='37673.Yeniden Sipariş Noktası'></th>
            <th><cf_get_lang dictionary_id='37675.Minimum Sipariş Miktarı'></th>
            <th><cfoutput>#getLang('settings',2974)#</cfoutput></th>
            <th><cfoutput>#getLang('stock',27)#</cfoutput></th>
        </tr>
    </thead>
    <tbody>
        <cfoutput query="get_prod_stocks">
            <cfquery name="get_stock_strategy" datasource="#dsn3#">
                SELECT  
                    STRATEGY_TYPE,
                    MAXIMUM_STOCK,
                    MINIMUM_STOCK,
                    REPEAT_STOCK_VALUE,
                    MINIMUM_ORDER_STOCK_VALUE,
                    MAXIMUM_ORDER_STOCK_VALUE,
                    PROVISION_TIME,
                    MINIMUM_ORDER_UNIT_ID,
                    MAXIMUM_ORDER_UNIT_ID
                FROM 
                    STOCK_STRATEGY 
                WHERE 
                    STOCK_ID = #get_prod_stocks.stock_id#
            </cfquery>
            <tr>
                <td>#STOCK_CODE#</td>
                <td>#PRODUCT_NAME# #PROPERTY#</td>
                <td><cfif get_stock_strategy.STRATEGY_TYPE eq 1><cf_get_lang dictionary_id='57490.Gün'><cfelseif get_stock_strategy.STRATEGY_TYPE eq 0><cf_get_lang dictionary_id='57636.Birim'></cfif></td>
                <td>#Tlformat(get_stock_strategy.MAXIMUM_STOCK)#</td>
                <td>#Tlformat(get_stock_strategy.MINIMUM_STOCK)#</td>
                <td>#Tlformat(get_stock_strategy.REPEAT_STOCK_VALUE)#</td>
                <td>#Tlformat(get_stock_strategy.MINIMUM_ORDER_STOCK_VALUE)# <cfif get_stock_strategy.MINIMUM_ORDER_UNIT_ID eq GET_UNITS.PRODUCT_UNIT_ID>#GET_UNITS.add_unit#</cfif></td>
                <td>#Tlformat(get_stock_strategy.MAXIMUM_ORDER_STOCK_VALUE)# <cfif get_stock_strategy.MAXIMUM_ORDER_UNIT_ID eq GET_UNITS.PRODUCT_UNIT_ID>#GET_UNITS.add_unit#</cfif></td>
                <td>#get_stock_strategy.PROVISION_TIME#</td>
            </tr>
        </cfoutput>
    </tbody>
</cf_flat_list>


