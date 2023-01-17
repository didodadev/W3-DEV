<!--- Secilen üye,tarih ve çalışana göre satış tekliflerini sürec ve özel tanım bazında listeler. OZDEN20061013 --->
<cfquery name="GET_TOTAL_OFFERS" datasource="#dsn3#">
	SELECT 
		SUM(PRICE) GENERAL_TOTAL
	FROM
		OFFER WITH (NOLOCK)
	WHERE
		PURCHASE_SALES = 1
	<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
		AND OFFER_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
	<cfelseif isdate(attributes.start_date)>
		AND OFFER_DATE >= #attributes.start_date#
	<cfelseif isdate(attributes.finish_date)>
		AND OFFER_DATE <= #attributes.finish_date#
	</cfif>
</cfquery>
<cfquery name="GET_OFFERS" datasource="#dsn3#">
	SELECT
		PRICE,
	<cfif len(session.ep.money2)>
		(PRICE/(OFM.RATE2/OFM.RATE1)) AS TUTAR2,
	</cfif>
		SALES_ADD_OPTION_ID,
		OFFER_STAGE,
  		PTR.STAGE,
		PTR.PROCESS_ROW_ID
	FROM
		OFFER OFR WITH (NOLOCK),
		#dsn_alias#.PROCESS_TYPE_ROWS PTR WITH (NOLOCK),
		#dsn_alias#.PROCESS_TYPE PT WITH (NOLOCK)
	<cfif len(session.ep.money2)>
		,OFFER_MONEY OFM WITH (NOLOCK)
	</cfif>
	WHERE
		PURCHASE_SALES = 1
		AND PTR.PROCESS_ID = PT.PROCESS_ID
		AND OFR.OFFER_STAGE = PTR.PROCESS_ROW_ID
	<cfif len(session.ep.money2)>
		AND OFFER_ID = OFM.ACTION_ID
		AND OFM.MONEY_TYPE = '#session.ep.money2#'
	</cfif>
	<cfif len(attributes.company_id) and len(attributes.member_name)>
		AND COMPANY_ID = #attributes.company_id#
	<cfelseif len(attributes.consumer_id) and len(attributes.member_name)>
		AND CONSUMER_ID = #attributes.consumer_id#
	</cfif>
	<cfif len(attributes.employee_id) and len(attributes.employee)>
		AND EMPLOYEE_ID = #attributes.employee_id#
	</cfif>
	<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
		AND OFFER_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
	<cfelseif isdate(attributes.start_date)>
		AND OFFER_DATE >= #attributes.start_date#
	<cfelseif isdate(attributes.finish_date)>
		AND OFFER_DATE <= #attributes.finish_date#
	</cfif>
</cfquery>
<cfquery name="GET_OFFER_STAGE" dbtype="query">
	SELECT
		SUM(PRICE) AS STAGE_TOTAL,
		<cfif len(session.ep.money2)>
		SUM(TUTAR2) AS STAGE_TOTAL_2,
		</cfif>
		OFFER_STAGE,
		STAGE
	FROM
		GET_OFFERS
	GROUP BY
		OFFER_STAGE,STAGE
</cfquery>
<cfquery name="GET_OFFER_SALE_OPTION" dbtype="query">
	SELECT
		SUM(PRICE) AS TOTAL,
		<cfif len(session.ep.money2)>
		SUM(TUTAR2) AS TOTAL_2,
		</cfif>
		SALES_ADD_OPTION_ID
	FROM
		GET_OFFERS
	<!--- WHERE
		SALES_ADD_OPTION_ID IS NOT NULL --->
	GROUP BY
		SALES_ADD_OPTION_ID
	ORDER BY 
		SALES_ADD_OPTION_ID
</cfquery>
<cfquery name="GET_SALE_ADD_OPTION" datasource="#DSN3#">
	SELECT
		SALES_ADD_OPTION_ID,
		SALES_ADD_OPTION_NAME
	FROM
		SETUP_SALES_ADD_OPTIONS WITH (NOLOCK)
	ORDER BY 
		SALES_ADD_OPTION_ID
</cfquery>
<cfset sale_option_list=valuelist(GET_SALE_ADD_OPTION.SALES_ADD_OPTION_ID)>
<cfsavecontent  variable="head"><cf_get_lang dictionary_id='30007.Satış Teklifleri'>
</cfsavecontent>
<cf_seperator title="#head#" id="satisteklif1">
  <div id="satisteklif1" style="padding: 10px; display: block;float: left; width: 100%">
		
		
	<!--- grafik degerleri (<chartdata value) 100 e bolunmediginde 10% üzerinden hesaplıyor,degistirmeyin... --->
 	<cfif isdefined("form.graph_type") and len(form.graph_type)>
		<cfset graph_type = form.graph_type>
	<cfelse>
		<cfset graph_type = "pie">
	</cfif>
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
			<p class="phead"><cf_get_lang no ='1127.Aşama Bazında Teklifler'></p>
				<cf_grid_list>
					<cfset customer_total_offer = 0>
					<cfif GET_OFFER_STAGE.recordcount>
						<thead>
							<tr>
								<th><cf_get_lang_main no ='70.Aşama'></th>
								<th align="right" style="text-align:right;"><cf_get_lang_main no ='261.Tutar'><cfoutput>#session.ep.money#</cfoutput></th>
								<cfif len(session.ep.money2)>
								<th align="right" style="text-align:right;"><cf_get_lang_main no ='261.Tutar'><cfoutput>#session.ep.money2#</cfoutput></th>
								</cfif>
							</tr>
						</thead>
						<cfset customer_total_offer2 = 0>
						<tbody>
							<cfoutput query="GET_OFFER_STAGE">
							<tr>		
								<td>#STAGE#</td>
								<td align="right" style="text-align:right;">
								&nbsp;#TLFormat(STAGE_TOTAL)# #session.ep.money#
								<cfif len(STAGE_TOTAL)>
									<cfset customer_total_offer = wrk_round(customer_total_offer + STAGE_TOTAL)>
								</cfif>
								</td>
								<cfif len(session.ep.money2)>
									<td align="right" style="text-align:right;">&nbsp;#TLFormat(STAGE_TOTAL_2)# #session.ep.money2#
										<cfif len(STAGE_TOTAL_2)>
											<cfset customer_total_offer2 = wrk_round(customer_total_offer2 + STAGE_TOTAL_2)>
										</cfif>
									</td>
								</cfif>
							</tr>
							</cfoutput>
							<cfoutput>
							<tr>
								<td class="txtbold"><cf_get_lang_main no ='80.Toplam'></td>
								<td align="right" class="txtbold" style="text-align:right;">&nbsp;#TLFormat(customer_total_offer)# #session.ep.money#</td>
								<cfif len(session.ep.money2)>
								<td align="right" class="txtbold" style="text-align:right;">&nbsp;#TLFormat(customer_total_offer2)# #session.ep.money2#</td>
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
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
			<cfif GET_OFFER_STAGE.recordcount and GET_OFFER_STAGE.STAGE_TOTAL gt 0>

						<cfoutput query="GET_OFFER_STAGE">
							<cfset 'temp_stage_rate_#currentrow#' = (STAGE_TOTAL*100)/customer_total_offer>
							<cfset 'item_#currentrow#'="#STAGE# (%#wrk_round(evaluate('temp_stage_rate_#currentrow#'))#)">
							<cfset 'value_#currentrow#'="#wrk_round(evaluate('temp_stage_rate_#currentrow#')/100)#">
						</cfoutput>
					<script src="JS/Chart.min.js"></script> 
					<canvas id="myChart6" style="float:left;max-width:320px;max-height:320px;"></canvas>
					<script>
						var ctx = document.getElementById('myChart6');
							var myChart6 = new Chart(ctx, {
								type: '<cfoutput>#graph_type#</cfoutput>',
								data: {
									labels: [<cfloop from="1" to="#GET_OFFER_STAGE.recordcount#" index="jj">
											<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
									datasets: [{
										label: "Satış Teklifleri",
										backgroundColor: [<cfloop from="1" to="#GET_OFFER_STAGE.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
										data: [<cfloop from="1" to="#GET_OFFER_STAGE.recordcount#" index="jj"><cfoutput>#evaluate("value_#jj#")#</cfoutput>,</cfloop>],
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
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
			<p class="phead"><cf_get_lang no ='1128.Özel Tanım Bazında Teklifler'></p>
 			<cf_grid_list>
			<cfset offer_sale_option_total = 0>
			<cfset offer_sale_option_total2 = 0>
			<cfif GET_OFFER_SALE_OPTION.recordcount>
				<thead>
					<tr>
						<th><cf_get_lang no ='561.Özel Tanım'></th>
						<th align="right" style="text-align:right;"><cf_get_lang_main no ='261.Tutar'><cfoutput>#session.ep.money#</cfoutput></th>
						<cfif len(session.ep.money2)>
						<th align="right" style="text-align:right;"><cf_get_lang_main no ='261.Tutar'><cfoutput>#session.ep.money2#</cfoutput></th>
						</cfif>
					</tr>
				</thead>
				<tbody>
					<cfoutput query="GET_OFFER_SALE_OPTION">
					<tr>		
						<td><cfif len(GET_OFFER_SALE_OPTION.SALES_ADD_OPTION_ID)>
						#GET_SALE_ADD_OPTION.SALES_ADD_OPTION_NAME[listfind(sale_option_list,GET_OFFER_SALE_OPTION.SALES_ADD_OPTION_ID)]#
						<cfelse>
							<cf_get_lang_main no='1433.Tanımsız'>
						</cfif></td>
						<td align="right" style="text-align:right;">&nbsp;#TLFormat(TOTAL)# #session.ep.money#
							<cfif len(TOTAL)>
								<cfset offer_sale_option_total = wrk_round(offer_sale_option_total + TOTAL)>
							</cfif>
						</td>
						<cfif len(session.ep.money2)>
						<td align="right" style="text-align:right;">&nbsp;#TLFormat(TOTAL_2)# #session.ep.money2#
							<cfif len(TOTAL_2)>
								<cfset offer_sale_option_total2 = wrk_round(offer_sale_option_total2 + TOTAL_2)>
							</cfif>
						</td>
						</cfif>
					</tr>
					</cfoutput>
					<cfoutput>
					<tr>
						<td class="txtbold"><cf_get_lang_main no ='80.Toplam'></td>
						<td align="right" class="txtbold" style="text-align:right;">&nbsp;#TLFormat(offer_sale_option_total)# #session.ep.money#</td>
						<cfif len(session.ep.money2)>
						<td align="right" class="txtbold" style="text-align:right;">&nbsp;#TLFormat(offer_sale_option_total2)# #session.ep.money2#</td>
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
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
			<cfif GET_OFFER_SALE_OPTION.recordcount and GET_OFFER_SALE_OPTION.TOTAL gt 0>
						<cfoutput query="GET_OFFER_SALE_OPTION">
							<cfset 'temp_rate_#SALES_ADD_OPTION_ID#' = (TOTAL*100)/offer_sale_option_total>
							<cfset temp_stage = GET_SALE_ADD_OPTION.SALES_ADD_OPTION_NAME[listfind(sale_option_list,GET_OFFER_SALE_OPTION.SALES_ADD_OPTION_ID)]>
							<cfset 'item_#currentrow#'="#temp_stage# (%#wrk_round(evaluate('temp_rate_#SALES_ADD_OPTION_ID#'))#)">
							<cfset 'value_#currentrow#'="#wrk_round(evaluate('temp_rate_#SALES_ADD_OPTION_ID#')/100)#">
						</cfoutput>
					<canvas id="myChart7" style="float:left;max-width:320px;max-height:320px;"></canvas>
					<script>
						var ctx = document.getElementById('myChart7');
							var myChart7 = new Chart(ctx, {
								type: '<cfoutput>#graph_type#</cfoutput>',
								data: {
									labels: [<cfloop from="1" to="#GET_OFFER_SALE_OPTION.recordcount#" index="jj">
											<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
									datasets: [{
										label: "Satış Teklifleri",
										backgroundColor: [<cfloop from="1" to="#GET_OFFER_SALE_OPTION.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
										data: [<cfloop from="1" to="#GET_OFFER_SALE_OPTION.recordcount#" index="jj"><cfoutput>#evaluate("value_#jj#")#</cfoutput>,</cfloop>],
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
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
			<cfif GET_TOTAL_OFFERS.recordcount and GET_TOTAL_OFFERS.GENERAL_TOTAL gt 0>

						<cfset customer_offer_rate = (customer_total_offer*100)/GET_TOTAL_OFFERS.GENERAL_TOTAL>
						<cfsavecontent variable="message"><cf_get_lang no ='1177.Toplam Teklif'></cfsavecontent>
						<cfset item1=" #message# (%#wrk_round(100-customer_offer_rate)#)">
						<cfset value1="#wrk_round((100-customer_offer_rate)/100)#">
						<cfsavecontent variable="message"><cf_get_lang no ='1178.Müsteri Teklifi'></cfsavecontent>
						<cfset item2=" #message# (%#wrk_round(customer_offer_rate)#)">
						<cfset value2= "#wrk_round((customer_offer_rate/100))#">

					<canvas id="myChart8" style="float:left;max-width:320px;max-height:320px;"></canvas>
					<script>
						var ctx = document.getElementById('myChart8');
							var myChart8 = new Chart(ctx, {
								type: '<cfoutput>#graph_type#</cfoutput>',
								data: {
									labels: ["<cfoutput>#item1#</cfoutput>","<cfoutput>#item2#</cfoutput>"],
									datasets: [{
										label: "Satış Teklifleri",
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
