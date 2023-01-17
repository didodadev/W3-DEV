<!--- Seçilen üye, tarih ve çalışana göre mal satış, satış iade ve satış fark faturalarını listeler, oranlarına göre grafikler oluşturur... OZDEN20061013 --->
<cfquery name="get_satis_total" datasource="#dsn2#">
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
		INVOICE_CAT IN (52,53,56,66,67,531)
	<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
		AND INVOICE_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
	<cfelseif isdate(attributes.start_date)>
		AND INVOICE_DATE >= #attributes.start_date#
	<cfelseif isdate(attributes.finish_date)>
		AND INVOICE_DATE <= #attributes.finish_date#
	</cfif>
</cfquery>
<cfif not len(get_satis_total.TOTAL)>
	<cfset get_satis_total.TOTAL = 0>
</cfif>
<cfquery name="get_satis_iade_total" datasource="#dsn2#">
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
		INVOICE_CAT IN (54,55)
	<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
		AND INVOICE_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
	<cfelseif isdate(attributes.start_date)>
		AND INVOICE_DATE >= #attributes.start_date#
	<cfelseif isdate(attributes.finish_date)>
		AND INVOICE_DATE <= #attributes.finish_date#
	</cfif>
</cfquery>
<cfif not len(get_satis_iade_total.TOTAL)>
	<cfset get_satis_iade_total.TOTAL = 0>
</cfif>
<cfquery name="get_satis_fark_total" datasource="#dsn2#">
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
		INVOICE_CAT IN (50,58)
	<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
		AND INVOICE_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
	<cfelseif isdate(attributes.start_date)>
		AND INVOICE_DATE >= #attributes.start_date#
	<cfelseif isdate(attributes.finish_date)>
		AND INVOICE_DATE <= #attributes.finish_date#
	</cfif>
</cfquery>
<cfif not len(get_satis_fark_total.TOTAL)>
	<cfset get_satis_fark_total.TOTAL = 0>
</cfif>

<cfquery name="get_satis" datasource="#dsn2#">
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
		PURCHASE_SALES = 1 AND
		IS_IPTAL = 0 AND
		INVOICE_CAT IN (52,53,56,66,67,531)
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
<cfif not len(get_satis.TOTAL)>
	<cfset get_satis.TOTAL = 0>
</cfif>
<cfquery name="get_satis_iade" datasource="#dsn2#">
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
		PURCHASE_SALES = 0 AND
		IS_IPTAL = 0 AND
		INVOICE_CAT IN (54,55)
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
<cfif not len(get_satis_iade.TOTAL)>
	<cfset get_satis_iade.TOTAL = 0>
</cfif>
<cfquery name="get_satis_fark" datasource="#dsn2#">
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
		PURCHASE_SALES = 1 AND
		IS_IPTAL = 0 AND
		INVOICE_CAT IN (50,58)
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
<cfif not len(get_satis_fark.TOTAL)>
	<cfset get_satis_fark.TOTAL = 0>
</cfif>
<cfsavecontent  variable="head"><cf_get_lang dictionary_id ='39504.Satış Faturaları'></cfsavecontent>
<cf_seperator title="#head#" id="sales1">
<div id="sales1" style="padding: 10px; display: block;float: left; width: 100%">
	<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
		<cf_grid_list>
			<thead>
				<tr>
					<th class="txtboldblue"><cf_get_lang_main no='1505.Faturalar'></th>
					<th align="right" class="txtboldblue" style="text-align:right;"><cf_get_lang_main no ='80.Toplam'> <cfoutput>#session.ep.money#</cfoutput></th>
					<cfif len(session.ep.money2)>
						<th align="right" class="txtboldblue" style="text-align:right;"><cf_get_lang_main no ='80.Toplam'><cfoutput>#session.ep.money2#</cfoutput></th>
					</cfif>
					<th align="right" class="txtboldblue" style="text-align:right;"><cf_get_lang no ='1122.Genele Oran'> (%)</th>
					
				</tr>
			</thead>
			<tbody>
				<cfoutput>
					<tr>
						<td><cf_get_lang no ='1123.Mal ve Hizmetler'></td>
						<td align="right" style="text-align:right;">#TLFormat(get_satis.TOTAL)# #session.ep.money#</td>
						<cfif len(session.ep.money2)>
							<td align="right" style="text-align:right;">#TLFormat(get_satis.TOTAL2)# #session.ep.money2#</td>
						</cfif>
						<td align="right" style="text-align:right;">
							<cfif get_satis_total.TOTAL gt 0>
								<cfset satis_oran = (get_satis.TOTAL * 100) / get_satis_total.TOTAL>
								#TLFormat(satis_oran)#
							</cfif>
						</td>
					</tr>
					<tr>
						<td><cf_get_lang_main no='902.Satıştan İadeler'></td>
						<td align="right" style="text-align:right;">#TLFormat(get_satis_iade.TOTAL)# #session.ep.money#</td>
						<cfif len(session.ep.money2)>
							<td align="right" style="text-align:right;">#TLFormat(get_satis_iade.TOTAL2)# #session.ep.money2#</td>
						</cfif>
						<td align="right" style="text-align:right;">
							<cfif get_satis_iade_total.TOTAL gt 0>
								<cfset satis_iade_oran = (get_satis_iade.TOTAL * 100) / get_satis_iade_total.TOTAL>
								#TLFormat(satis_iade_oran)#
							</cfif>
						</td>
					</tr>
					<tr>
						<td><cf_get_lang no ='1124.Kesilen Farklar'></td>
						<td align="right" style="text-align:right;">#TLFormat(get_satis_fark.TOTAL)# #session.ep.money#</td>
						<cfif len(session.ep.money2)>
							<td align="right" style="text-align:right;">#TLFormat(get_satis_fark.TOTAL2)# #session.ep.money2#</td>
						</cfif>
						<td align="right" style="text-align:right;">
							<cfif get_satis_fark_total.TOTAL gt 0>
								<cfset satis_fark_oran = (get_satis_fark.TOTAL * 100) / get_satis_fark_total.TOTAL>
								#TLFormat(satis_fark_oran)#
							</cfif>
						</td>
					</tr>
					<tr>
						<td class="txtbold"><cf_get_lang no ='1107.Net Satış'></td>
						<td align="right" class="txtbold" style="text-align:right;" >
							<cfset net_total = wrk_round(get_satis.TOTAL + get_satis_fark.TOTAL - get_satis_iade.TOTAL)>
							#TLFormat(net_total)# #session.ep.money#
						</td>
						<cfif len(session.ep.money2)>
							<td align="right" class="txtbold" style="text-align:right;" >
								<cfset net_total2 = 0>
								<cfif len(get_satis.TOTAL2)>
									<cfset net_total2 = wrk_round(net_total2 + get_satis.TOTAL2)>
								</cfif>
								<cfif len(get_satis_fark.TOTAL2)>
									<cfset net_total2 = wrk_round(net_total2 + get_satis_fark.TOTAL2)>
								</cfif>
								<cfif len(get_satis_iade.TOTAL2)>
									<cfset net_total2 = wrk_round(net_total2 - get_satis_iade.TOTAL2)>
								</cfif>
								#TLFormat(net_total2)# #session.ep.money2#
							</td>
						</cfif>
						<td align="right" class="txtbold" style="text-align:right;" >
							<cfset net_total_general =  wrk_round(get_satis_total.TOTAL + get_satis_fark_total.TOTAL - get_satis_iade_total.TOTAL)>
							<cfif net_total_general gt 0>
								<cfset satis_net_oran = (net_total * 100) / net_total_general>
								#TLFormat(satis_net_oran)#
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
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
		<cfif len(get_satis_total.TOTAL) and get_satis_total.TOTAL neq 0>
			<cfset customer_invoice_rate = (get_satis.TOTAL*100/get_satis_total.TOTAL)>
			<script src="JS/Chart.min.js"></script>
			<canvas id="myChartsss" style="float:left;max-width:320px;max-height:320px;"></canvas>
			<script>
				var ctx = document.getElementById('myChartsss');
					var myChartsss = new Chart(ctx, {
						type: '<cfoutput>#graph_type#</cfoutput>',
						data: {
							labels: ["<cf_get_lang no ='1169.Üye Toplam'> (%)", "<cf_get_lang_main no ='268.Genel Toplam'> (%)"],
							datasets: [{
								label: "Satış Faturaları",
								backgroundColor: ['rgb(255, 99, 132)','rgba(255, 99, 132, 0.2)'],
								borderColor: ['rgb(255, 99, 132)','rgba(255, 99, 132, 0.2)'],
								data: [<cfoutput>#wrk_round(customer_invoice_rate)#</cfoutput>, <cfoutput>#wrk_round(100-customer_invoice_rate)#</cfoutput>],
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
		<cfif (get_satis.TOTAL) or (get_satis_fark.TOTAL neq 0) or (get_satis_iade.TOTAL neq 0)>
			<cfset total_ = wrk_round(get_satis.TOTAL+get_satis_fark.TOTAL+get_satis_iade.TOTAL)>
			<canvas id="myChart1" style="float:left;max-width:320px;max-height:320px;"></canvas>
			<script>
				var ctx = document.getElementById('myChart1').getContext('2d');
					var myChart1 = new Chart(ctx, {
						type: '<cfoutput>#graph_type#</cfoutput>',
						data: {
							labels: ["<cf_get_lang no ='1123.Mal Ve Hizmet'> (%)", "<cf_get_lang_main no ='1171.Fark'> (%)","<cf_get_lang_main no='1621.İade'> (%)"],
							datasets: [{
								label: "Satış Faturaları",
								backgroundColor: ['rgb(255, 99, 132)','rgba(255, 99, 132, 0.2)','rgba(255, 206, 86, 0.2)'],
								borderColor: ['rgb(255, 99, 132)','rgba(255, 99, 132, 0.2)','rgba(255, 206, 86, 0.2)'],
								data: [<cfoutput>#wrk_round((get_satis.TOTAL*100)/total_)#</cfoutput>, <cfoutput>#wrk_round((get_satis_fark.TOTAL*100)/total_)#</cfoutput>,<cfoutput>#wrk_round((get_satis_iade.TOTAL*100)/total_)#</cfoutput>],
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

