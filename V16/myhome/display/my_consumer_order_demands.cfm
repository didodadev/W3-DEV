<cfsetting showdebugoutput="no">
<cfquery name="GET_DEMAND_LIST" datasource="#DSN3#">
	SELECT
		STOCK_ACTION_TYPE,
		DEMAND_STATUS,
		RECORD_DATE,
		STOCK_ID,
		DEMAND_AMOUNT,
		GIVEN_AMOUNT,
		PRICE_KDV,
		DEMAND_ID,
		'' AS ORDER_NUMBER
	FROM
		ORDER_DEMANDS
	WHERE
		ORDER_ID IS NULL AND
		RECORD_CON = #attributes.cid# AND
		DEMAND_AMOUNT > ISNULL(GIVEN_AMOUNT,0)
	UNION ALL
	SELECT
		ORDER_DEMANDS.STOCK_ACTION_TYPE,
		ORDER_DEMANDS.DEMAND_STATUS,
		ORDER_DEMANDS.RECORD_DATE,
		ORDER_DEMANDS.STOCK_ID,
		ORDER_DEMANDS.DEMAND_AMOUNT,
		ORDER_DEMANDS.GIVEN_AMOUNT,
		ORDER_DEMANDS.PRICE_KDV,
		ORDER_DEMANDS.DEMAND_ID,
		ORDERS.ORDER_NUMBER
	FROM
		ORDER_DEMANDS,
		ORDERS
	WHERE
		ORDER_DEMANDS.ORDER_ID = ORDERS.ORDER_ID AND
		ORDER_DEMANDS.RECORD_CON = #attributes.cid# AND
		ORDER_DEMANDS.DEMAND_AMOUNT > ISNULL(ORDER_DEMANDS.GIVEN_AMOUNT,0)
	ORDER BY
		ORDER_DEMANDS.RECORD_DATE
</cfquery>
<table class="ajax_list">
  <thead>
		<tr>
			<th><cf_get_lang dictionary_id='57487.No'></th>
			<th><cf_get_lang dictionary_id='58211.Siparis No'></th>
			<th><cf_get_lang dictionary_id='29501.Sipariş Tarihi'></th>
			<th><cf_get_lang dictionary_id='58800.Ürün Kodu'></th>
			<th><cf_get_lang dictionary_id='57657.Ürün'></th>
			<th><cf_get_lang dictionary_id='57635.Miktar'></th>
			<th><cf_get_lang dictionary_id='57638.Birim Fiyat'></th>
			<th><cf_get_lang dictionary_id='29534.Toplam_Tutar'></th>
			<th width="40"><cf_get_lang dictionary_id='57756.Durum'></th>
			<th align="center"><cf_get_lang dictionary_id='58506.İptal'></th>
		</tr>
  </thead>	
	<div id="demand_div" style="display:none;"></div>
<cfif get_demand_list.recordcount>
	<cfset stock_list = ''>
	<cfoutput query="get_demand_list" startrow="1" maxrows="#attributes.maxrows#">
		<cfif len(stock_id) and not listfind(stock_list,stock_id,',')>
			<cfset stock_list = listappend(stock_list,stock_id)>
		</cfif>
	</cfoutput>
	<cfif listlen(stock_list)>
		<cfset stock_list=listsort(stock_list,"numeric","ASC",",")>
		<cfquery name="GET_STOCKS" datasource="#DSN3#">
			SELECT PRODUCT_NAME,PROPERTY,STOCK_ID,PRODUCT_ID,PRODUCT_CODE_2 FROM STOCKS WHERE STOCK_ID IN (#stock_list#) ORDER BY STOCK_ID
		</cfquery>
		<cfset stock_list = listsort(listdeleteduplicates(valuelist(get_stocks.stock_id,',')),'numeric','ASC',',')>
	</cfif>
		<tbody>
	<cfoutput query="get_demand_list" startrow="1" maxrows="#attributes.maxrows#">
	<tr>
		<td width="55">#currentrow#</td>
		<td width="110">#order_number#</td>
		<td width="90">#dateformat(record_date,dateformat_style)#</td>
		<td>#get_stocks.product_code_2[listfind(stock_list,get_demand_list.stock_id,',')]#</td>
		<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&sid=#stock_id#','medium');" class="tableyazi">#get_stocks.product_name[listfind(stock_list,get_demand_list.stock_id,',')]#</a></td>
		<td  style="text-align:right;">
			<cfif len(given_amount)>
				#demand_amount-given_amount#
				<cfset kalan_amount = demand_amount-given_amount>
			<cfelse>
				#demand_amount#
				<cfset kalan_amount = demand_amount>
			</cfif>
		</td>
		<td  style="text-align:right;">#tlformat(price_kdv)# #session.ep.money#</td>
		<td  style="text-align:right;">#tlformat(price_kdv*kalan_amount)# #session.ep.money#</td>
		<td id="refuse_3#demand_id#" <cfif demand_status eq 1>style=""<cfelse>style="display:none;"</cfif>>
			<cfif demand_status eq 1>
				<cf_get_lang dictionary_id='30984.Beklemede'>
			<cfelse>
				<cf_get_lang dictionary_id='35966.İptal Edildi'>
			</cfif>
		</td>
		<td id="refuse_4#demand_id#" <cfif demand_status eq 1>style="display:none;"</cfif>>
			 	<cf_get_lang dictionary_id='35966 Edildi'>
		</td>
		<td align="center" id="refuse#demand_id#" <cfif demand_status eq 1>style=""<cfelse>style="display:none;"</cfif>>
			<cfif demand_status eq 1 and stock_action_type neq 2>
				<a href="javascript://" onclick="if (confirm('Ürün Talebi İptal Edilecek Emin misiniz ?')) connectAjax_demand('demand_div',#demand_id#);"><img src="/images/refusal.gif" border="0" title="Talebi İptal Et"></a>
			</cfif>
		</td>
		<td id="refuse_2#demand_id#" <cfif demand_status eq 1>style="display:none;"</cfif>></td>
	</tr>
	</cfoutput>
</tbody>
<cfelse>
<tbody>
	<tr>
		<td colspan="10"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
	</tr>
</tbody>
</cfif>	
</table>
<script type="text/javascript">
	function connectAjax_demand(div_id,demand_id)
	{
		AjaxPageLoad(<cfoutput>'#request.self#?fuseaction=myhome.emptypopup_ajax_upd_order_demand&demand_id='+demand_id+''</cfoutput>,div_id);
		eval("document.getElementById('refuse" + demand_id + "')").style.display='none';
		eval("document.getElementById('refuse_2" + demand_id + "')").style.display='';
		eval("document.getElementById('refuse_3" + demand_id + "')").style.display='none';
		eval("document.getElementById('refuse_4" + demand_id + "')").style.display='';
	}
</script>

