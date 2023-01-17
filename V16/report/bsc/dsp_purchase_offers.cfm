<!--- Secilen tarih ve çalışana göre satınalma tekliflerini sürec ve özel tanım bazında listeler. OZDEN20061013 --->
<cfquery name="GET_TOTAL_OFFERS" datasource="#dsn3#">
	SELECT 
		SUM(PRICE) GENERAL_TOTAL
	FROM
		OFFER WITH (NOLOCK)
	WHERE
		PURCHASE_SALES = 0
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
		PURCHASE_SALES = 0
		AND PTR.PROCESS_ID = PT.PROCESS_ID
		AND OFR.OFFER_STAGE = PTR.PROCESS_ROW_ID
	<cfif len(session.ep.money2)>
		AND OFFER_ID = OFM.ACTION_ID
		AND OFM.MONEY_TYPE = '#session.ep.money2#'
	</cfif>
	<cfif len(attributes.company_id) and len(attributes.member_name)>
		AND OFR.OFFER_TO LIKE '%,#attributes.company_id#,%'
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
	WHERE
		SALES_ADD_OPTION_ID IS NOT NULL
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
<cfsavecontent  variable="head"><cf_get_lang dictionary_id ='39529.Alış Teklifleri'></cfsavecontent>
<cf_seperator title="#head#" id="poffers1">
<div id="poffers1"   style="padding: 10px; display: block;float: left; width: 100%">
	<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
		<p class="phead"><cf_get_lang no ='1127.Aşama Bazında Teklifler'></p> 
		<cf_grid_list>
			<cfset customer_total_offer = 0>
			<cfset customer_total_offer2 = 0>
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
				<tbody>
					<cfoutput query="GET_OFFER_STAGE">
					<tr>		
						<td>#STAGE#</td>
						<td align="right" style="text-align:right;">&nbsp;#TLFormat(STAGE_TOTAL)# #session.ep.money#
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
	<!--- grafik degerleri (<chartdata value) 100 e bolunmediginde 10% üzerinden hesaplıyor,degistirmeyin... --->
 	<cfif isdefined("form.graph_type") and len(form.graph_type)>
		<cfset graph_type = form.graph_type>
	<cfelse>
		<cfset graph_type = "pie">
	</cfif>
	<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
		<script src="JS/Chart.min.js"></script> 
        <cfif isdefined("attributes.OFFER_STAGE") and len(attributes.OFFER_STAGE)>
		<cfif GET_OFFER_STAGE.recordcount>
				<cfoutput query="GET_OFFER_STAGE">
					<cfset 'temp_stage_rate_#OFFER_STAGE#' = (STAGE_TOTAL*100)/customer_total_offer>
					<cfset 'item_#currentrow#' = "#STAGE# (%#wrk_round(evaluate('temp_stage_rate_#OFFER_STAGE#'))#)">
					<cfset 'value_#currentrow#' = "#evaluate('temp_stage_rate_#OFFER_STAGE#')/100#">
				</cfoutput>
				<canvas id="myCharttss25" style="float:left;max-width:220px;max-height:220px;"></canvas>
				<script>
					var ctx = document.getElementById('myCharttss25');
						var myCharttss25 = new Chart(ctx, {
							type: '<cfoutput>#graph_type#</cfoutput>',
							data: {
								labels: [<cfloop from="1" to="#GET_OFFER_STAGE.recordcount#" index="jj">
										 <cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
								datasets: [{
									label: "Alış Teklifleri",
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
        </cfif>
	</div>
	<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
        <cfif isdefined("attributes.GENERAL_TOTAL") and len(attributes.GENERAL_TOTAL)>
		<cfif len(GET_TOTAL_OFFERS.GENERAL_TOTAL)>
					<cfset customer_offer_rate = (customer_total_offer*100)/GET_TOTAL_OFFERS.GENERAL_TOTAL>
					<cfsavecontent variable="message"><cf_get_lang no ='1177.Toplam Teklif'></cfsavecontent>
					<cfset item1 = "#message# (%#wrk_round(100-customer_offer_rate)#)">
					<cfset value1 = "#(100-customer_offer_rate)/100#">
					<cfsavecontent variable="message"><cf_get_lang no ='1178.Müsteri Teklifi'></cfsavecontent>
					<cfset item2 = "#message# (%#wrk_round(customer_offer_rate)#)">
					<cfset value2 = "#(customer_offer_rate/100)#">
				<canvas id="myCharts26" style="float:left;max-width:220px;max-height:220px;"></canvas>
				<script>
					var ctx = document.getElementById('myCharts26');
						var myCharts26 = new Chart(ctx, {
							type: '<cfoutput>#graph_type#</cfoutput>',
							data: {
								labels: ["<cfoutput>#item1#</cfoutput>","<cfoutput>#item2#</cfoutput>"],
								datasets: [{
									label: "Alış Teklifleri",
									backgroundColor: ['rgb(255, 99, 132)','rgba(255, 99, 132, 0.2)','rgba(255, 56, 130, 0.2)'],
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
        </cfif>
	</div>
</div>


