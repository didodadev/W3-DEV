<!--- Seçilen üye, tarih ve çalışana göre mal alım, alım iade ve fark (alış) faturalarını listeler, oranlarına göre grafikler oluşturur... OZDEN20061013 --->
<cfquery name="get_alis_total" datasource="#dsn2#">
	SELECT
		SUM(NETTOTAL) AS TOTAL
		<cfif len(session.ep.money2)>
		,SUM(NETTOTAL/(INV_M.RATE2/INV_M.RATE1)) AS TOTAL2
		</cfif>
	FROM
		INVOICE WITH (NOLOCK)
		<cfif len(session.ep.money2)>
		,INVOICE_MONEY INV_M WITH (NOLOCK)
		</cfif>
	WHERE
	<cfif len(session.ep.money2)>
		INVOICE_ID = INV_M.ACTION_ID AND
		INV_M.MONEY_TYPE = '#session.ep.money2#' AND
	</cfif>
		PURCHASE_SALES = 0 AND
		IS_IPTAL = 0 AND
		INVOICE_CAT IN (54,55,59,60,61,64,65,68,690,691,591,592,601,49)
	<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
		AND INVOICE_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
	<cfelseif isdate(attributes.start_date)>
		AND INVOICE_DATE >= #attributes.start_date#
	<cfelseif isdate(attributes.finish_date)>
		AND INVOICE_DATE <= #attributes.finish_date#
	</cfif>
</cfquery>
<cfif not len(get_alis_total.TOTAL)>
	<cfset get_alis_total.TOTAL = 0>
</cfif>
<cfquery name="get_alis_iade_total" datasource="#dsn2#">
	SELECT
		SUM(NETTOTAL) AS TOTAL
		<cfif len(session.ep.money2)>
		,SUM(NETTOTAL/(INV_M.RATE2/INV_M.RATE1)) AS TOTAL2
		</cfif>
	FROM
		INVOICE WITH (NOLOCK)
		<cfif len(session.ep.money2)>
		,INVOICE_MONEY INV_M WITH (NOLOCK)
		</cfif>
	WHERE
	<cfif len(session.ep.money2)>
		INVOICE_ID = INV_M.ACTION_ID AND
		INV_M.MONEY_TYPE = '#session.ep.money2#' AND
	</cfif>
		PURCHASE_SALES = 1 AND
		IS_IPTAL = 0 AND
		INVOICE_CAT = 62
	<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
		AND INVOICE_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
	<cfelseif isdate(attributes.start_date)>
		AND INVOICE_DATE >= #attributes.start_date#
	<cfelseif isdate(attributes.finish_date)>
		AND INVOICE_DATE <= #attributes.finish_date#
	</cfif>
</cfquery>
<cfif not len(get_alis_iade_total.TOTAL)>
	<cfset get_alis_iade_total.TOTAL = 0>
</cfif>
<cfquery name="get_alis_fark_total" datasource="#dsn2#">
	SELECT
		SUM(NETTOTAL) AS TOTAL
		<cfif len(session.ep.money2)>
		,SUM(NETTOTAL/(INV_M.RATE2/INV_M.RATE1)) AS TOTAL2
		</cfif>
	FROM
		INVOICE WITH (NOLOCK)
		<cfif len(session.ep.money2)>
		,INVOICE_MONEY INV_M WITH (NOLOCK)
		</cfif>
	WHERE
	<cfif len(session.ep.money2)>
		INVOICE_ID = INV_M.ACTION_ID AND
		INV_M.MONEY_TYPE = '#session.ep.money2#' AND
	</cfif>
		PURCHASE_SALES = 0 AND
		IS_IPTAL = 0 AND
		INVOICE_CAT IN (51,63)
	<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
		AND INVOICE_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
	<cfelseif isdate(attributes.start_date)>
		AND INVOICE_DATE >= #attributes.start_date#
	<cfelseif isdate(attributes.finish_date)>
		AND INVOICE_DATE <= #attributes.finish_date#
	</cfif>
</cfquery>
<cfif not len(get_alis_fark_total.TOTAL)>
	<cfset get_alis_fark_total.TOTAL = 0>
</cfif>

<cfquery name="get_alis" datasource="#dsn2#">
	SELECT
		SUM(NETTOTAL) AS TOTAL
		<cfif len(session.ep.money2)>
		,SUM(NETTOTAL/(INV_M.RATE2/INV_M.RATE1)) AS TOTAL2
		</cfif>
	FROM
		INVOICE WITH (NOLOCK)
		<cfif len(attributes.branch_id)>
		,#dsn_alias#.DEPARTMENT DEPARTMENT WITH (NOLOCK)
		</cfif>
		<cfif len(session.ep.money2)>
		,INVOICE_MONEY INV_M WITH (NOLOCK)
		</cfif>
	WHERE
	<cfif len(session.ep.money2)>
		INVOICE_ID = INV_M.ACTION_ID AND
		INV_M.MONEY_TYPE = '#session.ep.money2#' AND
	</cfif>
		PURCHASE_SALES = 0 AND
		IS_IPTAL = 0 AND
		INVOICE_CAT IN (54,55,59,60,61,64,65,68,690,691,591,592,601,49)
	<cfif len(attributes.company_id) and len(attributes.member_name)>
		AND COMPANY_ID = #attributes.company_id#
	<cfelseif len(attributes.consumer_id) and len(attributes.member_name)>
		AND CONSUMER_ID = #attributes.consumer_id#
	</cfif>
	<cfif len(attributes.employee_id) and len(attributes.employee)>
		AND SALE_EMP = #attributes.employee_id#
	</cfif>
	<cfif len(attributes.branch_id)>
		AND INVOICE.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID
		AND DEPARTMENT.BRANCH_ID IN(#attributes.branch_id#)	
	</cfif>
	<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
		AND INVOICE_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
	<cfelseif isdate(attributes.start_date)>
		AND INVOICE_DATE >= #attributes.start_date#
	<cfelseif isdate(attributes.finish_date)>
		AND INVOICE_DATE <= #attributes.finish_date#
	</cfif>
</cfquery>
<cfif not len(get_alis.TOTAL)>
	<cfset get_alis.TOTAL = 0>
</cfif>
<cfquery name="get_alis_iade" datasource="#dsn2#">
	SELECT
		SUM(NETTOTAL) AS TOTAL
		<cfif len(session.ep.money2)>
		,SUM(NETTOTAL/(RATE2/RATE1)) AS TOTAL2
		</cfif>
	FROM
		INVOICE WITH (NOLOCK)
		<cfif len(attributes.branch_id)>
		,#dsn_alias#.DEPARTMENT DEPARTMENT WITH (NOLOCK)
		</cfif>
		<cfif len(session.ep.money2)>
		,INVOICE_MONEY INV_M WITH (NOLOCK)
		</cfif>
	WHERE
	<cfif len(session.ep.money2)>
		INVOICE_ID = INV_M.ACTION_ID AND
		INV_M.MONEY_TYPE = '#session.ep.money2#' AND
	</cfif>
		PURCHASE_SALES = 1 AND
		IS_IPTAL = 0 AND
		INVOICE_CAT = 62
	<cfif len(attributes.company_id) and len(attributes.member_name)>
		AND COMPANY_ID = #attributes.company_id#
	<cfelseif len(attributes.consumer_id) and len(attributes.member_name)>
		AND CONSUMER_ID = #attributes.consumer_id#
	</cfif>
	<cfif len(attributes.employee_id) and len(attributes.employee)>
		AND SALE_EMP = #attributes.employee_id#
	</cfif>
	<cfif len(attributes.branch_id)>
		AND INVOICE.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID
		AND DEPARTMENT.BRANCH_ID IN(#attributes.branch_id#)
	</cfif>
	<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
		AND INVOICE_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
	<cfelseif isdate(attributes.start_date)>
		AND INVOICE_DATE >= #attributes.start_date#
	<cfelseif isdate(attributes.finish_date)>
		AND INVOICE_DATE <= #attributes.finish_date#
	</cfif>
</cfquery>
<cfif not len(get_alis_iade.TOTAL)>
	<cfset get_alis_iade.TOTAL = 0>
</cfif>
<cfquery name="get_alis_fark" datasource="#dsn2#">
	SELECT
		SUM(NETTOTAL) AS TOTAL
		<cfif len(session.ep.money2)>
		,SUM(NETTOTAL/(RATE2/RATE1)) AS TOTAL2
		</cfif>
	FROM
		INVOICE WITH (NOLOCK)
		<cfif len(attributes.branch_id)>
		,#dsn_alias#.DEPARTMENT DEPARTMENT WITH (NOLOCK)
		</cfif>
		<cfif len(session.ep.money2)>
		,INVOICE_MONEY INV_M WITH (NOLOCK)
		</cfif>
	WHERE
	<cfif len(session.ep.money2)>
		INVOICE_ID = ACTION_ID AND
		MONEY_TYPE = '#session.ep.money2#' AND
	</cfif>
		PURCHASE_SALES = 0 AND
		IS_IPTAL = 0 AND
		INVOICE_CAT IN (51,63)
	<cfif len(attributes.company_id) and len(attributes.member_name)>
		AND COMPANY_ID = #attributes.company_id#
	<cfelseif len(attributes.consumer_id) and len(attributes.member_name)>
		AND CONSUMER_ID = #attributes.consumer_id#
	</cfif>
	<cfif len(attributes.employee_id) and len(attributes.employee)>
		AND SALE_EMP = #attributes.employee_id#
	</cfif>
	<cfif len(attributes.branch_id)>
		AND INVOICE.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID
		AND DEPARTMENT.BRANCH_ID IN(#attributes.branch_id#)
	</cfif>
	<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
		AND INVOICE_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
	<cfelseif isdate(attributes.start_date)>
		AND INVOICE_DATE >= #attributes.start_date#
	<cfelseif isdate(attributes.finish_date)>
		AND INVOICE_DATE <= #attributes.finish_date#
	</cfif>
</cfquery>
<cfif not len(get_alis_fark.TOTAL)>
	<cfset get_alis_fark.TOTAL = 0>
</cfif>
<cfsavecontent  variable="head"><cf_get_lang dictionary_id ='39503.Alış Faturaları'></cfsavecontent>
<cf_seperator title="#head#" id="purchase1">
<div id="purchase1"   style="padding: 10px; display: block;float: left; width: 100%">
	<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang_main no='1505.Faturalar'></th>
					<th align="right" style="text-align:right;"><cf_get_lang_main no ='80.Toplam'><cfoutput>#session.ep.money#</cfoutput></th>
					<cfif len(session.ep.money2)>
						<th align="right" style="text-align:right;"><cf_get_lang_main no ='80.Toplam'><cfoutput>#session.ep.money2#</cfoutput></th>
					</cfif>
					<th align="right" style="text-align:right;"><cf_get_lang no ='1122.Genele Oran'> (%)</th>
				</tr>
			</thead>
			<tbody>
				<cfoutput>
					<tr>
						<td><cf_get_lang no ='1123.Mal ve Hizmetler'></td>
						<td align="right" style="text-align:right;">#TLFormat(get_alis.TOTAL)# #session.ep.money#</td>
						<cfif len(session.ep.money2)>
							<td align="right" style="text-align:right;">#TLFormat(get_alis.TOTAL2)# #session.ep.money2#</td>
						</cfif>
						<td align="right" style="text-align:right;">
							<cfif get_alis_total.TOTAL gt 0>
								<cfset alis_oran = (get_alis.TOTAL * 100) / get_alis_total.TOTAL>
								#TLFormat(alis_oran)#
							</cfif>
						</td>
					</tr>
					<tr>
						<td><cf_get_lang no ='1147.İadeler'></td>
						<td align="right" style="text-align:right;">#TLFormat(get_alis_iade.TOTAL)# #session.ep.money#</td>
						<cfif len(session.ep.money2)>
							<td align="right" style="text-align:right;">#TLFormat(get_alis_iade.TOTAL2)# #session.ep.money2#</td>
						</cfif>
						<td align="right" style="text-align:right;">
							<cfif get_alis_iade_total.TOTAL gt 0>
								<cfset alis_iade_oran = (get_alis_iade.TOTAL * 100) / get_alis_iade_total.TOTAL>
								#TLFormat(alis_iade_oran)#
							</cfif>
						</td>
					</tr>
					<tr>
						<td><cf_get_lang no ='1148.Farklar'></td>
						<td align="right" style="text-align:right;">#TLFormat(get_alis_fark.TOTAL)# #session.ep.money#</td>
						<cfif len(session.ep.money2)>
							<td align="right" style="text-align:right;">#TLFormat(get_alis_fark.TOTAL2)# #session.ep.money2#</td>
						</cfif>
						<td align="right" style="text-align:right;">
							<cfif get_alis_fark_total.TOTAL gt 0>
								<cfset alis_fark_oran = (get_alis_fark.TOTAL * 100) / get_alis_fark_total.TOTAL>
								#TLFormat(alis_fark_oran)#
							</cfif>
						</td>
					</tr>
					<tr>
						<td class="txtbold"><cf_get_lang no ='1105.Net Alış'></td>
						<td align="right" class="txtbold" style="text-align:right;" >
							<cfset net_total = wrk_round(get_alis.TOTAL + get_alis_fark.TOTAL - get_alis_iade.TOTAL)>
							#TLFormat(net_total)# #session.ep.money#
						</td>
						<cfif len(session.ep.money2)>
							<td align="right" class="txtbold" style="text-align:right;">
								<cfset net_total2 = 0>
								<cfif len(get_alis.TOTAL2)>
									<cfset net_total2 = wrk_round(net_total2 + get_alis.TOTAL2)>
								</cfif>
								<cfif len(get_alis_fark.TOTAL2)>
									<cfset net_total2 = wrk_round(net_total2 + get_alis_fark.TOTAL2)>
								</cfif>
								<cfif len(get_alis_iade.TOTAL2)>
									<cfset net_total2 = wrk_round(net_total2 - get_alis_iade.TOTAL2)>
								</cfif>
								#TLFormat(net_total2)# #session.ep.money2#
							</td>
						</cfif>
						<td align="right" class="txtbold" style="text-align:right;" >
							<cfset net_total_general = wrk_round(get_alis_total.TOTAL + get_alis_fark_total.TOTAL - get_alis_iade_total.TOTAL)>
							<cfif net_total_general gt 0>
								<cfset alis_net_oran = (net_total * 100) / net_total_general>
								#TLFormat(alis_net_oran)#
							</cfif>
						</td>
					</tr>
				</cfoutput>
			</tbody>
		</cf_grid_list>
	</div>
		<cfif isdefined("form.graph_type") and len(form.graph_type)>
			<cfset graph_type = form.graph_type>
		<cfelse>
			<cfset graph_type = "pie">
		</cfif>
	<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
		<script src="JS/Chart.min.js"></script> 
		<cfif len(get_alis_total.TOTAL) and get_alis_total.TOTAL neq 0>
					<cfset customer_invoice_rate = (get_alis.TOTAL*100/get_alis_total.TOTAL)>
					<cfsavecontent variable="message"><cf_get_lang no ='1169.Üye Toplam'></cfsavecontent>
					<cfset item1 = "#message#(% #wrk_round(customer_invoice_rate)#)">
					<cfset value1 = "#customer_invoice_rate/100#">
					<cfsavecontent variable="message"><cf_get_lang_main no ='268.Genel Toplam'></cfsavecontent>
					<cfset item2 = "#message# (% #wrk_round(100-customer_invoice_rate)#)">
					<cfset value2 = "#(100-customer_invoice_rate)/100#">
				<canvas id="myChart23" style="float:left;max-width:220px;max-height:220px;"></canvas>
				<script>
					var ctx = document.getElementById('myChart23');
						var myChart23 = new Chart(ctx, {
							type: '<cfoutput>#graph_type#</cfoutput>',
							data: {
								labels: ["<cfoutput>#item1#</cfoutput>","<cfoutput>#item2#</cfoutput>"],
								datasets: [{
									label: "Alış Faturaları",
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
	<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
		<cfif (get_alis.TOTAL) or (get_alis_fark.TOTAL neq 0) or (get_alis_iade.TOTAL neq 0)>
					<cfset total_ = wrk_round(get_alis.TOTAL+get_alis_fark.TOTAL+get_alis_iade.TOTAL)>
					<cfsavecontent variable="message"><cf_get_lang no ='1123.Mal Ve Hizmet'></cfsavecontent>
					<cfset item1 = "#message#(% #wrk_round((get_alis.TOTAL*100)/total_)#)">
					<cfset value1 = "#((get_alis.TOTAL*100)/total_)/100#">
					<cfsavecontent variable="message"><cf_get_lang_main no ='1171.Fark '></cfsavecontent>
					<cfset item2 = "#message#(% #wrk_round((get_alis_fark.TOTAL*100)/total_)#)">
					<cfset value2 = "#((get_alis_fark.TOTAL*100)/total_)/100#">
					<cfsavecontent variable="message"><cf_get_lang_main no='1621.İade'></cfsavecontent>
					<cfset item3 = "#message# (% #wrk_round((get_alis_iade.TOTAL*100)/total_)#)">
					<cfset value3 = "#((get_alis_iade.TOTAL*100)/total_)/100#">
				<canvas id="myChart24" style="float:left;max-width:220px;max-height:220px;"></canvas>
				<script>
					var ctx = document.getElementById('myChart24');
						var myChart24 = new Chart(ctx, {
							type: '<cfoutput>#graph_type#</cfoutput>',
							data: {
								labels: ["<cfoutput>#item1#</cfoutput>","<cfoutput>#item2#</cfoutput>","<cfoutput>#item3#</cfoutput>"],
								datasets: [{
									label: "Alış Faturaları",
									backgroundColor: ['rgb(255, 99, 132)','rgba(255, 99, 132, 0.2)','rgba(255, 56, 130, 0.2)'],
									data: [<cfoutput>#value1#</cfoutput>,<cfoutput>#value2#</cfoutput>,<cfoutput>#value3#</cfoutput>],
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
