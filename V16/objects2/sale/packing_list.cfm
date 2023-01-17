<cfquery name="GET_PACKING" datasource="#DSN3#">
	SELECT
		SGN.STOCK_ID,
		SGN.SERIAL_NO,
		SGN.SALE_FINISH_DATE,
		ORDERS.ORDER_NUMBER,
		STOCKS.STOCK_CODE,
		STOCKS.PRODUCT_NAME,
		ORDERS_SHIP.SHIP_ID,
		STOCKS.PRODUCT_DETAIL
	FROM
		SERVICE_GUARANTY_NEW SGN,
		ORDERS_SHIP,
		ORDERS,
		STOCKS
	WHERE
		ORDERS.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#"> AND
		SGN.PROCESS_ID = ORDERS_SHIP.SHIP_ID AND
		ORDERS_SHIP.ORDER_ID = ORDERS.ORDER_ID AND
		STOCKS.STOCK_ID = SGN.STOCK_ID AND
		SGN.PERIOD_ID = <cfif isdefined('session.pp.period_id')><cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.period_id#"></cfif>
	ORDER BY
		PURCHASE_FINISH_DATE DESC
</cfquery>
<table cellpadding="2" cellspacing="1" style="width:100%;">
  	<tr style="height:25px;">
		<td class="formbold" colspan="5">Packing List / Seri No İşlemleri: <cfif isdefined("get_order_det.order_number")><cfoutput>#get_order_det.order_number#</cfoutput></cfif></td>
  	</tr>
	<tr class="color-header" style="height:22px;">
		<td class="form-title" style="width:110px;"><cf_get_lang_main no='225.Seri No'></td>
		<td class="form-title" style="width:80px;">Garanti Bitiş.</td>
		<td class="form-title" style="width:125px;"><cf_get_lang_main no='106.Stok Kodu'></td>
		<td class="form-title" style="width:200px;"><cf_get_lang_main no='245.Ürün'></td>
		<td class="form-title"><cf_get_lang_main no='217.Açıklama'></td>
	</tr>
	<cfif get_packing.recordcount>
		<cfoutput query="get_packing">
            <tr class="color-row">
                <td>#serial_no#</td>
                <td>#dateformat(sale_finish_date,'dd/mm/yyyy')#</td>
                <td>#stock_code#</td>
                <td>#product_name#</td>
                <td>#product_detail#</td>
            </tr>
		</cfoutput>
	<cfelse>
		<tr class="color-row"><td colspan="6"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td></tr>
	</cfif>
</table>

