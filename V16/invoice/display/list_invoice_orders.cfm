<cf_get_lang_set module_name="invoice"><!--- sayfanin en altinda kapanisi var --->
<cfquery name="get_orders" datasource="#dsn2#">
	SELECT 
		INV_S.SHIP_NUMBER,
		INV_S.SHIP_ID,
		O.ORDER_ID,
		O.ORDER_HEAD,
		O.ORDER_NUMBER,
		O.DELIVERDATE,
		O.RECORD_DATE,
		O.RECORD_EMP,
		O.IS_INSTALMENT
	FROM 
		INVOICE I,
		#dsn3#.ORDERS O,
		#dsn3#.ORDERS_SHIP OS,
		INVOICE_SHIPS INV_S
	WHERE
		I.INVOICE_ID = #attributes.INVOICE_ID#
		<cfif isdefined("attributes.is_sale")>
		AND	(
				(	O.PURCHASE_SALES = 1 AND O.ORDER_ZONE = 0	)  OR 
				(	O.PURCHASE_SALES = 0 AND O.ORDER_ZONE = 1	)
			)
		<cfelseif isdefined("attributes.is_purchase")>
		AND (	O.PURCHASE_SALES = 0 AND O.ORDER_ZONE = 0	)
		</cfif>
		AND INV_S.INVOICE_ID = I.INVOICE_ID
		AND OS.SHIP_ID = INV_S.SHIP_ID
		AND OS.PERIOD_ID = #session.ep.period_id#
		AND O.ORDER_ID = OS.ORDER_ID
</cfquery>
<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('','İlişkili Siparişler',57260)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_seperator title="#getLang('','Fatura İrsaliyelerine Bağlı Siparişler',57230)#" id="invoice_stock">
	<cf_grid_list id="invoice_stock">
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='58138.İrsaliye No'></th>
				<th><cf_get_lang dictionary_id='58211.Sipariş No'></th>
				<th><cf_get_lang dictionary_id='57611.Sipariş'></th>
				<th><cf_get_lang dictionary_id='57231.Teslim'></th>
				<th><cf_get_lang dictionary_id='57483.Kayıt'></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_orders.recordcount>
				<cfoutput query="get_orders">
				<tr>
					<td>
						<cfif isdefined("attributes.is_sale")>
							<a href="#request.self#?fuseaction=stock.form_add_sale&event=upd&ship_id=#SHIP_ID#" target="_blank">#SHIP_NUMBER#</a>
						<cfelseif isdefined("attributes.is_purchase")>
							<a href="#request.self#?fuseaction=stock.form_add_purchase&event=upd&ship_id=#SHIP_ID#" target="_blank">#SHIP_NUMBER#</a>
						</cfif>
					</td>
					<td>
						<cfif isdefined("attributes.is_sale")>
							<cfif is_instalment eq 1>
								<a href="#request.self#?fuseaction=sales.upd_fast_sale&order_id=#ORDER_ID#" target="_blank">#ORDER_NUMBER#</a></td>
							<cfelse>
								<a href="#request.self#?fuseaction=sales.list_order&event=upd&order_id=#ORDER_ID#" target="_blank">#ORDER_NUMBER#</a></td>
							</cfif>
						<cfelseif isdefined("attributes.is_purchase")>
							<a href="#request.self#?fuseaction=purchase.list_order&event=upd&order_id=#ORDER_ID#" target="_blank">#ORDER_NUMBER#</a></td>
						</cfif>
					<td>#order_head#</td>
					<td>#dateformat(DELIVERDATE,dateformat_style)#</td>
					<td>#get_emp_info(RECORD_EMP,0,1)# - #dateformat(RECORD_DATE,dateformat_style)#</td>
				</tr>
				</cfoutput> 
			<cfelse>
				<tr>
					<td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>			
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
	<cfquery name="get_orders_invoice" datasource="#dsn2#">
		SELECT 
			I.INVOICE_NUMBER,
			OI.INVOICE_ID,
			O.ORDER_ID,
			O.ORDER_NUMBER,
			O.ORDER_HEAD,
			O.DELIVERDATE,
			O.RECORD_DATE,
			O.RECORD_EMP
		FROM
			INVOICE I,
			#dsn3_alias#.ORDERS O,
			#dsn3_alias#.ORDERS_INVOICE OI
		WHERE
			O.ORDER_ID = OI.ORDER_ID AND
			OI.INVOICE_ID = I.INVOICE_ID AND
			I.INVOICE_ID = #attributes.invoice_id# AND
			OI.PERIOD_ID = #session.ep.period_id#
			<cfif len(get_orders.order_id)>
				AND OI.ORDER_ID NOT IN (#valuelist(get_orders.order_id,',')#)
			</cfif>
	</cfquery>
	<cf_seperator title="#getLang('','Faturalara Bağlı Siparişler',57003)#" id="invoice_order">
	<cf_grid_list id="invoice_order">
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='58133.Fatura No'></th>
				<th><cf_get_lang dictionary_id='58211.Sipariş No'> </th>
				<th><cf_get_lang dictionary_id='57611.Sipariş'></th>
				<th><cf_get_lang dictionary_id='57231.Teslim'></th>
				<th><cf_get_lang dictionary_id='57483.Kayıt'></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_orders_invoice.recordcount>
				<cfoutput query="get_orders_invoice">
				<tr>
					<td>#invoice_number#</td>
					<td>
						<cfif isdefined("attributes.is_sale")>
							<a href="#request.self#?fuseaction=sales.list_order&event=upd&order_id=#order_id#" target="_blank">#ORDER_NUMBER#</a>
						<cfelseif isdefined("attributes.is_purchase")>
							<a href="#request.self#?fuseaction=purchase.list_order&event=upd&order_id=#order_id#" target="_blank">#ORDER_NUMBER#</a>
						</cfif>
					</td>
					<td>#order_head#</td>
					<td>#dateformat(deliverdate,dateformat_style)#</td>
					<td>#get_emp_info(record_emp,0,1)# - #dateformat(record_date,dateformat_style)#</td>
				</tr>
				</cfoutput> 
			<cfelse>
				<tr>
					<td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>			
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
</cf_box>

<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
