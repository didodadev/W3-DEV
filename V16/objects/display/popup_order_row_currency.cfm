<cfsetting showdebugoutput="no">
<cfif not isdefined("GET_STOCK_NAME.recordcount")>
	<cfquery name="GET_STOCK_NAME" datasource="#DSN3#">
		SELECT
			PRODUCT_NAME,
			STOCK_ID 
		FROM 
			STOCKS 
		WHERE 
			<cfif isdefined("attributes.sid") and len(attributes.sid)>
				STOCK_ID = #attributes.sid#
			<cfelseif isdefined("attributes.pid") and len(attributes.pid)>
				PRODUCT_ID = #attributes.pid#
			<cfelse>
				1=0
			</cfif>
	</cfquery>
</cfif>
<cfif GET_STOCK_NAME.RECORDCOUNT eq 0>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id ='58642.Ürün Kaydı Bulunamadı'>");
		window.close;
	</script>
	<cfabort>
</cfif>
<!--- 1305.Acik, 1948.Tedarik, 1949.Kapatıldı, 1950.Kısmi Üretim, 44.Üretim, 1349.Sevk, 1951.Eksik Teslimat, 1952.Fazla Teslimat, 1094.İptal, 1211.Kapatıldı(Manuel) --->
<cfset order_currency_list = "#getLang('main',1305)#,#getLang('main',1948)#,#getLang('main',1949)#,#getLang('main',1950)#,#getLang('main',44)#,#getLang('main',1349)#,#getLang('main',1951)#,#getLang('main',1952)#,#getLang('main',1094)#,#getLang('main',1211)#">
<cfquery name="get_order_rows" datasource="#dsn3#">
	SELECT 
		SUM(ORR.QUANTITY) AS TOPLAM_SIPARIS,
		ORR.ORDER_ROW_CURRENCY
	FROM
		ORDER_ROW ORR,
		ORDERS O
	WHERE 
		ORR.ORDER_ID = O.ORDER_ID AND
		<cfif order_type_ is 'sales'>
			((O.PURCHASE_SALES = 1 AND O.ORDER_ZONE = 0) OR (O.PURCHASE_SALES = 0 AND O.ORDER_ZONE = 1))
		<cfelse>
			O.PURCHASE_SALES = 0 AND
			O.ORDER_ZONE = 0
		</cfif>
		<cfif isdefined("attributes.sid") and len(attributes.sid)>
			AND ORR.STOCK_ID = #attributes.sid#
		<cfelseif isdefined("attributes.pid") and len(attributes.pid)>
			AND ORR.PRODUCT_ID = #attributes.pid#
		<cfelse>
			AND 1=0
		</cfif>
		AND ORR.ORDER_ROW_CURRENCY IN (-1,-2,-4,-5,-6,-7)
	GROUP BY
		ORR.ORDER_ROW_CURRENCY
</cfquery>
<cf_flat_list>
	<tr class="color-header">
		<td height="25" colspan="4" class="form-title"><cfif order_type_ is 'sales'><cf_get_lang dictionary_id='57448.Satış'><cfelse><cf_get_lang dictionary_id='47199.Satınalma'></cfif><cf_get_lang dictionary_id='34616.Sipariş Aşamaları'></td>
	</tr>
	<tr class="color-list">
		<td width="150" class="txtboldblue"><cf_get_lang dictionary_id='57482.Aşama'></td>
		<td class="txtboldblue" nowrap="nowrap"><cf_get_lang dictionary_id='57635.Miktar'></td>
	</tr>
	<cfset total_ = 0>
	<cfoutput query="get_order_rows">
	<tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
		<td width="65">#listgetat(order_currency_list,abs(ORDER_ROW_CURRENCY))#</td>
		<td  style="text-align:right;">#TLFormat(TOPLAM_SIPARIS)#</td>
	</tr>
	<cfset total_ = total_ + TOPLAM_SIPARIS>
	</cfoutput>
	<tr class="color-list">
		<td class="txtboldblue"><cf_get_lang dictionary_id='57492.Toplam'></td>
		<td  class="txtboldblue" style="text-align:right;"><cfoutput>#TLFormat(total_)#</cfoutput></td>
	</tr>
</cf_flat_list>


