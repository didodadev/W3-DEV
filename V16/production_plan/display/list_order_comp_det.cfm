<cfsetting showdebugoutput="no">
<cfquery name="ORDER_DETAIL" datasource="#dsn3#">
	SELECT ORDER_ID,ORDER_HEAD,ORDER_NUMBER,ORDER_DATE,COMPANY_ID,CONSUMER_ID,DELIVERDATE FROM ORDERS WHERE ORDER_ID IN(#attributes.order_ids#)
</cfquery>
<cfquery name="kalan_siparis" datasource="#dsn3#">
	 SELECT
	 	SUM(QUANTITY) QUANTITY,
		ORDER_ID
	FROM
	(
		SELECT
			CASE WHEN (QUANTITY-ISNULL((SELECT SUM(QUANTITY) FROM PRODUCTION_ORDERS WHERE P_ORDER_ID IN(SELECT PRODUCTION_ORDER_ID FROM PRODUCTION_ORDERS_ROW WHERE PRODUCTION_ORDERS_ROW.ORDER_ROW_ID = ORDER_ROW.ORDER_ROW_ID)),0))<0
			THEN 
				QUANTITY 
			ELSE 
				(QUANTITY-ISNULL((SELECT SUM(QUANTITY) FROM PRODUCTION_ORDERS WHERE P_ORDER_ID IN(SELECT PRODUCTION_ORDER_ID FROM PRODUCTION_ORDERS_ROW WHERE PRODUCTION_ORDERS_ROW.ORDER_ROW_ID = ORDER_ROW.ORDER_ROW_ID)),0)) END
			QUANTITY,
			ORDERS.ORDER_ID
		FROM
			ORDER_ROW,
			ORDERS
		WHERE 
			ORDER_ROW.ORDER_ROW_ID IN(#attributes.ORDER_ROW_ID#)AND
			ORDER_ROW.ORDER_ID = ORDERS.ORDER_ID
	)T1
	GROUP BY
		ORDER_ID
</cfquery>
<cfoutput query="kalan_siparis">
	<cfset "kalan_#order_id#" = QUANTITY>
</cfoutput>
<cfsavecontent variable="alert"><cf_get_lang dictionary_id ='36364.Sipariş Detay'></cfsavecontent>
<cf_box id="list_order_comp_det#attributes.row_id#" title="#alert#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_flat_list>
		<thead>
			<tr class="txtbold">
				<th width="20"></th>
				<th width="110" nowrap><cf_get_lang dictionary_id ='57611.Sipariş'></th>
				<th width="50"><cf_get_lang dictionary_id='57487.No'></th>
				<th width="100" class="text-center"><cf_get_lang dictionary_id='29501.Sipariş Tarihi'></th>
				<th width="100" class="text-center"><cf_get_lang dictionary_id='57645.Teslim Tarihi'></th>
				<th width="120" nowrap><cf_get_lang dictionary_id ='57519.Cari Hesap'></th>
				<th><cf_get_lang dictionary_id ='60533.Kalan Sipariş'></th>
			</tr>
		</thead>
		<tbody>
			<cfoutput query="ORDER_DETAIL">
			<tr>
				<td class="txtbold">#currentrow#-</td>
				<td>#ORDER_HEAD#</td>
				<td nowrap><a href="#request.self#?fuseaction=sales.list_order&event=upd&order_id=#ORDER_ID#" class="tableyazi" target="_blank">#ORDER_NUMBER#</a></td>
				<td class="text-center">#DateFormat(ORDER_DATE,dateformat_style)#</td>
				<td class="text-center">#DateFormat(DELIVERDATE,dateformat_style)#</td>
				<td><cfif len(COMPANY_ID)>#get_par_info(COMPANY_ID,1,1,1)#<cfelseif len(CONSUMER_ID)>#get_cons_info(CONSUMER_ID,0,1,1)#</cfif></td>
				<td>
					<cfif isdefined("kalan_#order_id#")>
						#evaluate("kalan_#order_id#")#
					<cfelse>
						0
					</cfif>
				</td>
			</tr>
			</cfoutput>
		</tbody>
	</cf_flat_list>
</cf_box>
