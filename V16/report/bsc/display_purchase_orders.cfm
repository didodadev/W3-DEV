<!--- Secilen üye,tarih ve çalışana göre satınalma siparişlerini, sürec ve sipariş satır aşamalarına göre listeler. OZDEN20061013 --->
<cfquery name="GET_TOTAL_ORDERS" datasource="#dsn3#">
	SELECT 
		SUM(NETTOTAL) GENERAL_TOTAL
	FROM
		ORDERS WITH (NOLOCK)
	WHERE
		ORDERS.PURCHASE_SALES = 0
		AND ORDERS.ORDER_ZONE = 0
	<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
		AND ORDER_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
	<cfelseif isdate(attributes.start_date)>
		AND ORDER_DATE >= #attributes.start_date#
	<cfelseif isdate(attributes.finish_date)>
		AND ORDER_DATE <= #attributes.finish_date#
	</cfif>
</cfquery>
<cfquery name="GET_ORDERS" datasource="#dsn3#">
	SELECT
		(((ORR.QUANTITY*ORR.PRICE*(100-ORR.DISCOUNT_1)*(100-ORR.DISCOUNT_2)*(100-ORR.DISCOUNT_3)*(100-ORR.DISCOUNT_4)*(100-ORR.DISCOUNT_5))/10000000000)+((ORR.QUANTITY*ORR.PRICE*(100-ORR.DISCOUNT_1)*(100-ORR.DISCOUNT_2)*(100-ORR.DISCOUNT_3)*(100-ORR.DISCOUNT_4)*(100-ORR.DISCOUNT_5))/10000000000)*ORR.TAX/100) ROW_TOTAL,
		<cfif len(session.ep.money2)>
		((((ORR.QUANTITY*ORR.PRICE*(100-ORR.DISCOUNT_1)*(100-ORR.DISCOUNT_2)*(100-ORR.DISCOUNT_3)*(100-ORR.DISCOUNT_4)*(100-ORR.DISCOUNT_5))/10000000000)+((ORR.QUANTITY*ORR.PRICE*(100-ORR.DISCOUNT_1)*(100-ORR.DISCOUNT_2)*(100-ORR.DISCOUNT_3)*(100-ORR.DISCOUNT_4)*(100-ORR.DISCOUNT_5))/10000000000)*ORR.TAX/100)/(ORD_M.RATE2/ORD_M.RATE1)) ROW_TOTAL_2,
		</cfif>
		ORR.QUANTITY,
		ORR.ORDER_ROW_CURRENCY
	FROM
		ORDERS ORD WITH (NOLOCK),
		ORDER_ROW ORR WITH (NOLOCK)
	<cfif len(session.ep.money2)>
		,ORDER_MONEY ORD_M
	</cfif>
	<cfif len(attributes.branch_id)>
		,#dsn_alias#.DEPARTMENT D
	</cfif>
	WHERE
		ORD.PURCHASE_SALES = 0
		AND ORD.ORDER_ZONE = 0
		AND ORR.ORDER_ID = ORD.ORDER_ID
		AND ORD.ORDER_STATUS = 1
	<cfif len(session.ep.money2)>
		AND ORR.ORDER_ID = ORD_M.ACTION_ID
		AND ORD_M.MONEY_TYPE = '#session.ep.money2#'
	</cfif>
	<cfif len(attributes.company_id) and len(attributes.member_name)>
		AND ORD.COMPANY_ID = #attributes.company_id#
	<cfelseif len(attributes.consumer_id) and len(attributes.member_name)>
		AND ORD.CONSUMER_ID = #attributes.consumer_id#
	</cfif>
	<cfif len(attributes.employee_id) and len(attributes.employee)>
		AND ORD.ORDER_EMPLOYEE_ID = #attributes.employee_id#
	</cfif>
	<cfif len(attributes.branch_id)>
		AND ORD.DELIVER_DEPT_ID = D.DEPARTMENT_ID
		AND D.BRANCH_ID IN(#attributes.branch_id#)
	</cfif>
	<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
		AND ORD.ORDER_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
	<cfelseif isdate(attributes.start_date)>
		AND ORD.ORDER_DATE >= #attributes.start_date#
	<cfelseif isdate(attributes.finish_date)>
		AND ORD.ORDER_DATE <= #attributes.finish_date#
	</cfif>
</cfquery>
<cfquery name="GET_ORDER_CURRENCY" dbtype="query">
	SELECT
		SUM(ROW_TOTAL) AS CURRENCY_ROW_TOTAL,
		<cfif len(session.ep.money2)>
		SUM(ROW_TOTAL_2) AS CURRENCY_ROW_TOTAL_2,
		</cfif>
		SUM(QUANTITY) AS CURRENCY_QUANTITY,
		ORDER_ROW_CURRENCY
	FROM
		GET_ORDERS
	WHERE 
		ORDER_ROW_CURRENCY IS NOT NULL
	GROUP BY
		ORDER_ROW_CURRENCY
</cfquery>
<cfquery name="GET_ORDER_STAGE" datasource="#dsn3#">
	SELECT
		SUM(ORD.NETTOTAL) AS STAGE_TOTAL,
		<cfif len(session.ep.money2)>
		SUM(ORD.NETTOTAL/(ORD_M.RATE2/ORD_M.RATE1)) AS STAGE_TOTAL_2,
		</cfif>
		ORD.ORDER_STAGE,
  		PTR.STAGE,
		PTR.PROCESS_ROW_ID
	FROM
		ORDERS ORD WITH (NOLOCK),
		#dsn_alias#.PROCESS_TYPE_ROWS PTR WITH (NOLOCK),
		#dsn_alias#.PROCESS_TYPE PT WITH (NOLOCK)
	<cfif len(session.ep.money2)>
		,ORDER_MONEY ORD_M WITH (NOLOCK)
	</cfif>
	<cfif len(attributes.branch_id)>
		,#dsn_alias#.DEPARTMENT D WITH (NOLOCK)
	</cfif>
	WHERE
		ORD.PURCHASE_SALES = 0
		AND ORD.ORDER_ZONE = 0
		AND ORD.ORDER_STATUS = 1
		AND PTR.PROCESS_ID = PT.PROCESS_ID
		AND ORD.ORDER_STAGE = PTR.PROCESS_ROW_ID
	<cfif len(session.ep.money2)>
		AND ORD.ORDER_ID = ORD_M.ACTION_ID
		AND ORD_M.MONEY_TYPE = '#session.ep.money2#'
	</cfif>
	<cfif len(attributes.company_id) and len(attributes.member_name)>
		AND ORD.COMPANY_ID = #attributes.company_id#
	<cfelseif len(attributes.consumer_id) and len(attributes.member_name)>
		AND ORD.CONSUMER_ID = #attributes.consumer_id#
	</cfif>
	<cfif len(attributes.employee_id) and len(attributes.employee)>
		AND ORD.ORDER_EMPLOYEE_ID = #attributes.employee_id#
	</cfif>
	<cfif len(attributes.branch_id)>
		AND ORD.DELIVER_DEPT_ID = D.DEPARTMENT_ID
		AND D.BRANCH_ID IN(#attributes.branch_id#)
	</cfif>
	<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
		AND ORD.ORDER_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
	<cfelseif isdate(attributes.start_date)>
		AND ORD.ORDER_DATE >= #attributes.start_date#
	<cfelseif isdate(attributes.finish_date)>
		AND ORD.ORDER_DATE <= #attributes.finish_date#
	</cfif>
	GROUP BY
		ORD.ORDER_STAGE,
  		PTR.STAGE,
		PTR.PROCESS_ROW_ID
</cfquery>
<cfsavecontent  variable="head"><cf_get_lang dictionary_id ='39499.Alış Siparişler'></cfsavecontent>
<cf_seperator title="#head#" id="purchaseorders1">
<div id="purchaseorders1"   style="padding: 10px; display: block;float: left; width: 100%">
	
	
		<cfif isdefined("form.graph_type") and len(form.graph_type)>
			<cfset graph_type = form.graph_type>
		<cfelse>
			<cfset graph_type = "pie">
		</cfif>
		<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
			<p class="phead"><cf_get_lang no ='1125.Satır Bazında Siparişler'></p>
			<cf_grid_list>
				<cfset orders_total = 0 >
				<cfif GET_ORDER_CURRENCY.recordcount>
					<thead>
						<tr>
							<th><cf_get_lang_main no ='70.Aşama'></th>
							<th><cf_get_lang_main no ='223.Miktar'></th>
							<th align="right" style="text-align:right;"><cf_get_lang_main no ='261.Tutar '><cfoutput>#session.ep.money#</cfoutput></th>
							<cfif len(session.ep.money2)>
							<th align="right" style="text-align:right;"><cf_get_lang_main no ='261.Tutar '><cfoutput>#session.ep.money2#</cfoutput></th>
							</cfif>
						</tr>
					</thead>
					<cfset orders_total_quantity = 0>
					<cfset order_other_total = 0>
						<tbody>
							<cfoutput query="GET_ORDER_CURRENCY">
							<tr>
								<td>
									<cfif order_row_currency eq -1><cf_get_lang_main no='1305.Açık'>
										<cfelseif order_row_currency eq -2><cf_get_lang_main no ='1948.Tedarik'>
										<cfelseif order_row_currency eq -3><cf_get_lang_main no ='1949.Kapatıldı'>
										<cfelseif order_row_currency eq -4><cf_get_lang_main no ='1950.Kısmi Üretim'>
										<cfelseif order_row_currency eq -5><cf_get_lang_main no ='44.Üretim'>
										<cfelseif order_row_currency eq -6><cf_get_lang_main no='1349.Sevk'>
										<cfelseif order_row_currency eq -7><cf_get_lang_main no ='1951.Eksik Teslimat'>
										<cfelseif order_row_currency eq -8><cf_get_lang_main no ='1952.Fazla Teslimat'>
									</cfif>
								</td>
								<td align="right" style="text-align:right;">&nbsp;#CURRENCY_QUANTITY#
								<cfif len(CURRENCY_QUANTITY)>
									<cfset orders_total_quantity = orders_total_quantity + CURRENCY_QUANTITY>
								</cfif>
								</td>
								<td align="right" style="text-align:right;">&nbsp;#TLFormat(CURRENCY_ROW_TOTAL)# #session.ep.money#
								<cfif len(CURRENCY_ROW_TOTAL)>
									<cfset orders_total = wrk_round(orders_total + CURRENCY_ROW_TOTAL)>
								</cfif>
								</td>
								<cfif len(session.ep.money2)>
								<td align="right" style="text-align:right;">&nbsp;#TLFormat(CURRENCY_ROW_TOTAL_2)# #session.ep.money2#
									<cfif len(CURRENCY_ROW_TOTAL_2)>
										<cfset order_other_total = wrk_round(order_other_total + CURRENCY_ROW_TOTAL_2)>
									</cfif>
								</td>
								</cfif>
							</tr>
							</cfoutput>
							<cfoutput>
							<tr>
								<td class="txtbold"><cf_get_lang_main no ='80.Toplam'></td>
								<td align="right" class="txtbold" style="text-align:right;">&nbsp;#orders_total_quantity#</td>
								<td align="right" class="txtbold" style="text-align:right;">&nbsp;#TLFormat(orders_total)# #session.ep.money#</td>
								<cfif len(session.ep.money2)>
								<td align="right" class="txtbold" style="text-align:right;">&nbsp;#TLFormat(order_other_total)# #session.ep.money2#</td>
								</cfif>
							</tr>
							</cfoutput>
						</tbody>
					<cfelse>
						<tbody>
							<tr>
								<td colspan="2"><cf_get_lang_main no ='72.Kayıt Yok'></td>
							</tr>
						</tbody>
					</cfif>
			</cf_grid_list>
		
		</div>
		<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
			<script src="JS/Chart.min.js"></script> 
			<cfif GET_ORDER_CURRENCY.recordcount and orders_total neq 0>
						<cfoutput query="GET_ORDER_CURRENCY">
							<cfset item_name = ''>
							<cfif ORDER_ROW_CURRENCY eq -1>
								<cfset item_name = "Açık">
							</cfif>
							<cfif ORDER_ROW_CURRENCY eq -2>
								<cfset item_name = "Tedarik">
							</cfif>
							<cfif ORDER_ROW_CURRENCY eq -3>
								<cfset item_name = "Kapatıldı">
							</cfif>
							<cfif ORDER_ROW_CURRENCY eq -4>
								<cfset item_name = "Kısmi Ü.">
							</cfif>
							<cfif ORDER_ROW_CURRENCY eq -5>
								<cfset item_name = "Üretim">
							</cfif>
							<cfif ORDER_ROW_CURRENCY eq -6>
								<cfset item_name = "Sevk">
							</cfif>
							<cfif ORDER_ROW_CURRENCY eq -7>
								<cfset item_name = "Eksik Teslimat">
							</cfif>
							<cfif ORDER_ROW_CURRENCY eq -8>
								<cfset item_name = "Fazla Teslimat">
							</cfif>
							<cfset 'item_#currentrow#' = "#item_name# (%#wrk_round((CURRENCY_ROW_TOTAL*100)/orders_total)#)">
							<cfset 'value_#currentrow#'= "#((CURRENCY_ROW_TOTAL*100)/orders_total)/100#">
						</cfoutput>
					<canvas id="myChart25" style="float:left;max-width:320px;max-height:320px;"></canvas>
					<script>
						var ctx = document.getElementById('myChart25');
							var myChart25 = new Chart(ctx, {
								type: '<cfoutput>#graph_type#</cfoutput>',
								data: {
									labels: [<cfloop from="1" to="#GET_ORDER_CURRENCY.recordcount#" index="jj">
											<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
									datasets: [{
										label: "Satır Bazında siparişler",
										backgroundColor: [<cfloop from="1" to="#GET_ORDER_CURRENCY.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
										data: [<cfloop from="1" to="#GET_ORDER_CURRENCY.recordcount#" index="jj"><cfoutput>#evaluate("value_#jj#")#</cfoutput>,</cfloop>],
									}]
								},
								options: {
									legend: {
										display: false
									}
								}
						});
					</script>
			</cfif>
		</div>
		<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
			<p class="phead"><cf_get_lang no ='1126.Toplam Bazda Siparişler'></p>
				<cf_grid_list>
				<cfif GET_ORDER_STAGE.recordcount>
					<thead>
						<tr>
							<th><cf_get_lang_main no ='344.Süreç'></th>
							<th align="right" style="text-align:right;"><cf_get_lang_main no ='261.Tutar '><cfoutput>#session.ep.money#</cfoutput></th>
							<cfif len(session.ep.money2)>
							<th align="right" style="text-align:right;"><cf_get_lang_main no ='261.Tutar '><cfoutput>#session.ep.money2#</cfoutput></th>
							</cfif>
						</tr>
					</thead>
					<cfset order_stage_total = 0>
					<cfset order_stage_total2 = 0>
					<tbody>
						<cfoutput query="GET_ORDER_STAGE">
							<tr>
								<td>#STAGE#</td>
								<td align="right" style="text-align:right;">&nbsp;#TLFormat(STAGE_TOTAL)# #session.ep.money#
									<cfif len(STAGE_TOTAL)>
										<cfset order_stage_total = order_stage_total + STAGE_TOTAL>
									</cfif>
								</td>
								<cfif len(session.ep.money2)>
									<td align="right" style="text-align:right;">&nbsp;#TLFormat(STAGE_TOTAL_2)# #session.ep.money2#
										<cfif len(STAGE_TOTAL_2)>
											<cfset order_stage_total2 = order_stage_total2 + STAGE_TOTAL_2>
										</cfif>
									</td>
								</cfif>
							</tr>
						</cfoutput>
						<cfoutput>
							<tr>
								<td class="txtbold"><cf_get_lang_main no ='80.Toplam'></td>
								<td align="right" class="txtbold" style="text-align:right;">&nbsp;#TLFormat(order_stage_total)# #session.ep.money#</td>
								<cfif len(session.ep.money2)>
								<td align="right" class="txtbold" style="text-align:right;">&nbsp;#TLFormat(order_stage_total2)# #session.ep.money2#</td>
								</cfif>
							</tr>
						</cfoutput>
					</tbody>
				<cfelse>
					<tbody>
						<tr>
							<td colspan="2"><cf_get_lang_main no ='72.Kayıt Yok'></td>
						</tr>
					</tbody>
				</cfif>
				</cf_grid_list>
		</div>
		<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
			<cfif GET_ORDER_STAGE.recordcount and orders_total neq 0>
					<cfoutput query="GET_ORDER_STAGE">
						<cfset 'item_#currentrow#' = "#STAGE# (%#wrk_round((STAGE_TOTAL*100)/orders_total)#)">
						<cfset 'value_#currentrow#'= "#((STAGE_TOTAL*100)/orders_total)/100#">
					</cfoutput>
					<canvas id="myChart26" style="float:left;max-width:320px;max-height:320px;"></canvas>
					<script>
						var ctx = document.getElementById('myChart26');
							var myChart26 = new Chart(ctx, {
								type: '<cfoutput>#graph_type#</cfoutput>',
								data: {
									labels: [<cfloop from="1" to="#GET_ORDER_STAGE.recordcount#" index="jj">
											<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
									datasets: [{
										label: "Toplam Bazda Siparişler",
										backgroundColor: [<cfloop from="1" to="#GET_ORDER_STAGE.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
										data: [<cfloop from="1" to="#GET_ORDER_STAGE.recordcount#" index="jj"><cfoutput>#evaluate("value_#jj#")#</cfoutput>,</cfloop>],
									}]
								},
								options: {
									legend: {
										display: false
									}
								}
						});
					</script>
			</cfif>
		</div>
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
			<cfif len(GET_TOTAL_ORDERS.GENERAL_TOTAL) and GET_TOTAL_ORDERS.GENERAL_TOTAL neq 0>
						<cfset customer_order_rate = (orders_total*100)/GET_TOTAL_ORDERS.GENERAL_TOTAL>
						<cfsavecontent variable="message"><cf_get_lang no ='1175.Toplam Sipariş'></cfsavecontent>
						<cfset item1="#message# (%#wrk_round(100-customer_order_rate)#)"> 
						<cfset value1="#wrk_round((100-customer_order_rate)/100)#">
						<cfsavecontent variable="message"><cf_get_lang no ='1176.Müşteri Siparişi'></cfsavecontent>
						<cfset item2=" #message#(%#wrk_round(customer_order_rate)#)"> 
						<cfset value2="#wrk_round(customer_order_rate/100)#">
				<canvas id="myChart27" style="float:left;max-width:320px;max-height:320px;"></canvas>
					<script>
						var ctx = document.getElementById('myChart27');
							var myChart27 = new Chart(ctx, {
								type: '<cfoutput>#graph_type#</cfoutput>',
								data: {
									labels: ["<cfoutput>#item1#</cfoutput>","<cfoutput>#item2#</cfoutput>"],
									datasets: [{
										label: "Toplam",
										backgroundColor: ['rgb(255, 99, 132)','rgba(255, 99, 132, 0.2)'],
										data: [<cfoutput>#value1#</cfoutput>,<cfoutput>#value2#</cfoutput>],
									}]
								},
								options: {
									legend: {
										display: false
									}
								}
						});
					</script>
			</cfif>
		</div>
</div>


