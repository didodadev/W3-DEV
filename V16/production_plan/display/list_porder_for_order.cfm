<cfquery name="GET_PROD_ORDERS" datasource="#dsn3#">
	SELECT
		PO.P_ORDER_ID,
		PO.P_ORDER_NO,
		P.PRODUCT_NAME,
		S.PROPERTY,
		S.STOCK_ID,
		P.PRODUCT_ID,
		PO.QUANTITY,
		PO.START_DATE
	FROM
		PRODUCTION_ORDERS PO,
		PRODUCTION_ORDERS_ROW PRO,
		ORDERS ORDERS,
		ORDER_ROW ORR,
		PRODUCT P,
		STOCKS S
	WHERE
		PRO.PRODUCTION_ORDER_ID = PO.P_ORDER_ID AND
		S.STOCK_ID = PO.STOCK_ID AND
		S.PRODUCT_ID = P.PRODUCT_ID AND	
		PRO.ORDER_ROW_ID = ORR.ORDER_ROW_ID AND
		ORR.ORDER_ID = ORDERS.ORDER_ID AND 
		ORDERS.ORDER_ID = #attributes.order_id#
</cfquery>
<cf_grid_list>
	<thead>
        <tr>
            <th width="80"><cf_get_lang dictionary_id='29474.Emir No'></th>
            <th><cf_get_lang dictionary_id='57657.Ürün'></th>
            <th width="60"><cf_get_lang dictionary_id='57635.Miktar'></th>
            <th width="60"><cf_get_lang dictionary_id='57742.Tarih'></th>
            <th width="15"><a href="<cfoutput>#request.self#?fuseaction=prod.order&event=add&order_id=#attributes.order_id#&order_row_id=#order_row_id#</cfoutput>" title="<cf_get_lang dictionary_id='36378.Üretim Emri Ekle'>"> <i class="fa fa-plus"></i> </a> </th>
        </tr>
    </thead>
    <tbody>
		<cfif get_prod_orders.recordcount>
            <cfoutput query="get_prod_orders">
                <tr>
                    <td>#P_ORDER_NO#</td>
                    <td> <a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#PRODUCT_ID#&sid=#STOCK_ID#','list');"> #PRODUCT_NAME# #PROPERTY# </a> </td>
                    <td>#QUANTITY#</td>
                    <td>#dateformat(START_DATE,dateformat_style)#</td>
                    <td width="15"><a href="#request.self#?fuseaction=prod.order&event=upd&upd=#p_order_id#" title="<cf_get_lang dictionary_id='36436.Üretim Emri Düzenle'>"><i class="fa fa-pencil"></i></td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
            </tr>
        </cfif>
    </tbody>
</cf_grid_list>

