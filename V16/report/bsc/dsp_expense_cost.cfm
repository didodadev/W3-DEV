<!---Seçilen harcama yapana göre tarih aralıgındaki harcamaları getirir(gider kalemi ve aktivite tipi bazında)  Ayşenur20061013--->
<!--- Sevkiyat Harcamaları da ayrı bir blok olarak eklendi Sevda20070405 --->
<cfquery name="EXPENSE_TOTAL" datasource="#dsn2#">
	SELECT 
		SUM(TOTAL_AMOUNT) TOTAL_AMOUNT,
		SUM(OTHER_MONEY_VALUE_2) OTHER_MONEY_VALUE_2
	FROM 
		EXPENSE_ITEMS_ROWS WITH (NOLOCK)
	WHERE 
		IS_INCOME = 0
	<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
		AND EXPENSE_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
	<cfelseif isdate(attributes.start_date)>
		AND EXPENSE_DATE >= #attributes.start_date#
	<cfelseif isdate(attributes.finish_date)>
		AND EXPENSE_DATE <= #attributes.finish_date#
	</cfif>
	<cfif len(attributes.branch_id)>
		AND BRANCH_ID IN (#attributes.branch_id#)
	</cfif>
</cfquery>
<cfquery name="GET_EXPENSES" datasource="#dsn2#">
	SELECT 
		SUM(TOTAL_AMOUNT) TOTAL_AMOUNT,
		SUM(OTHER_MONEY_VALUE_2) OTHER_MONEY_VALUE_2
	FROM 
		EXPENSE_ITEMS_ROWS WITH (NOLOCK)
	WHERE 
		IS_INCOME = 0
 	<cfif len(attributes.company_id) and len(attributes.member_name) and len(attributes.member_type)>
		AND EXPENSE_ITEMS_ROWS.MEMBER_TYPE='#attributes.member_type#'
		AND EXPENSE_ITEMS_ROWS.COMPANY_ID=#attributes.company_id#
	<cfelseif len(attributes.consumer_id) and len(attributes.member_name) and len(attributes.member_type)>
		AND EXPENSE_ITEMS_ROWS.MEMBER_TYPE='#attributes.member_type#'
		AND EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID=#attributes.consumer_id#
	<cfelseif len(attributes.employee_id) and len(attributes.employee)>
		AND EXPENSE_ITEMS_ROWS.MEMBER_TYPE='employee'
		AND EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID=#attributes.employee_id#
	</cfif>
	<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
		AND EXPENSE_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
	<cfelseif isdate(attributes.start_date)>
		AND EXPENSE_DATE >= #attributes.start_date#
	<cfelseif isdate(attributes.finish_date)>
		AND EXPENSE_DATE <= #attributes.finish_date#
	</cfif>
	<cfif len(attributes.branch_id)>
		AND BRANCH_ID IN (#attributes.branch_id#)
	</cfif>
</cfquery>
<cfquery name="GET_EXPENSE_ITEMS" datasource="#dsn2#">
	SELECT
		EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
		SUM(TOTAL_AMOUNT) TOTAL_AMOUNT,
		SUM(OTHER_MONEY_VALUE_2) OTHER_MONEY_VALUE_2
	FROM
		EXPENSE_ITEMS_ROWS WITH (NOLOCK),
		EXPENSE_ITEMS WITH (NOLOCK)
	WHERE
		EXPENSE_ITEMS.EXPENSE_ITEM_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID AND
		EXPENSE_ITEMS_ROWS.IS_INCOME = 0
 	<cfif len(attributes.company_id) and len(attributes.member_name) and len(attributes.member_type)>
		AND EXPENSE_ITEMS_ROWS.MEMBER_TYPE='#attributes.member_type#'
		AND EXPENSE_ITEMS_ROWS.COMPANY_ID=#attributes.company_id#
	<cfelseif len(attributes.consumer_id) and len(attributes.member_name) and len(attributes.member_type)>
		AND EXPENSE_ITEMS_ROWS.MEMBER_TYPE='#attributes.member_type#'
		AND EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID=#attributes.consumer_id#
	<cfelseif len(attributes.employee_id) and len(attributes.employee)>
		AND EXPENSE_ITEMS_ROWS.MEMBER_TYPE='employee'
		AND EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID=#attributes.employee_id#
	</cfif>
	<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
		AND EXPENSE_ITEMS_ROWS.EXPENSE_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
	<cfelseif isdate(attributes.start_date)>
		AND EXPENSE_ITEMS_ROWS.EXPENSE_DATE >= #attributes.start_date#
	<cfelseif isdate(attributes.finish_date)>
		AND EXPENSE_ITEMS_ROWS.EXPENSE_DATE <= #attributes.finish_date#
	</cfif>
	<cfif len(attributes.branch_id)>
		AND EXPENSE_ITEMS_ROWS.BRANCH_ID IN (#attributes.branch_id#)
	</cfif>
	GROUP BY
		EXPENSE_ITEMS.EXPENSE_ITEM_NAME
	ORDER BY
		EXPENSE_ITEMS.EXPENSE_ITEM_NAME
</cfquery>
<cfquery name="GET_ACTIVITY_TYPES" datasource="#dsn2#">
	SELECT
		SA.ACTIVITY_NAME,
		SUM(TOTAL_AMOUNT) TOTAL_AMOUNT,
		SUM(OTHER_MONEY_VALUE_2) OTHER_MONEY_VALUE_2
	FROM
		EXPENSE_ITEMS_ROWS WITH (NOLOCK),
		#dsn_alias#.SETUP_ACTIVITY SA WITH (NOLOCK)
	WHERE
		SA.ACTIVITY_ID = EXPENSE_ITEMS_ROWS.ACTIVITY_TYPE AND
		EXPENSE_ITEMS_ROWS.IS_INCOME = 0
 	<cfif len(attributes.company_id) and len(attributes.member_name) and len(attributes.member_type)>
		AND EXPENSE_ITEMS_ROWS.MEMBER_TYPE='#attributes.member_type#'
		AND EXPENSE_ITEMS_ROWS.COMPANY_ID=#attributes.company_id#
	<cfelseif len(attributes.consumer_id) and len(attributes.member_name) and len(attributes.member_type)>
		AND EXPENSE_ITEMS_ROWS.MEMBER_TYPE='#attributes.member_type#'
		AND EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID=#attributes.consumer_id#
	<cfelseif len(attributes.employee_id) and len(attributes.employee)>
		AND EXPENSE_ITEMS_ROWS.MEMBER_TYPE='employee'
		AND EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID=#attributes.employee_id#
	</cfif>
	<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
		AND EXPENSE_ITEMS_ROWS.EXPENSE_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
	<cfelseif isdate(attributes.start_date)>
		AND EXPENSE_ITEMS_ROWS.EXPENSE_DATE >= #attributes.start_date#
	<cfelseif isdate(attributes.finish_date)>
		AND EXPENSE_ITEMS_ROWS.EXPENSE_DATE <= #attributes.finish_date#
	</cfif>
	<cfif len(attributes.branch_id)>
		AND EXPENSE_ITEMS_ROWS.BRANCH_ID IN (#attributes.branch_id#)
	</cfif>
	GROUP BY
		SA.ACTIVITY_NAME
	ORDER BY
		SA.ACTIVITY_NAME
</cfquery>
<cfquery name="GET_ACT_TYP_TOTAL" dbtype="query">
	SELECT
		SUM(TOTAL_AMOUNT) TOTAL_AMOUNT,
		SUM(OTHER_MONEY_VALUE_2) OTHER_MONEY_VALUE_2
	FROM
		GET_ACTIVITY_TYPES
</cfquery>
<cfquery name="GET_EXP_ITEM_TOTAL" dbtype="query">
	SELECT
		SUM(TOTAL_AMOUNT) TOTAL_AMOUNT,
		SUM(OTHER_MONEY_VALUE_2) OTHER_MONEY_VALUE_2
	FROM
		GET_EXPENSE_ITEMS
</cfquery>
<cfquery name="GET_MEMBER_COST" datasource="#dsn2#">
	SELECT
		SR.SHIP_FIS_NO,
		SR.COST_VALUE,
		SR.COST_VALUE2
	FROM
		SHIP_RESULT SR WITH (NOLOCK)
	WHERE
		SR.COST_VALUE > 0
	<cfif len(attributes.company_id) and len(attributes.member_name)><!--- Cari hesaba göre --->
		AND SR.COMPANY_ID = #attributes.company_id#
	<cfelseif len(attributes.consumer_id) and len(attributes.member_name)>
		AND SR.CONSUMER_ID = #attributes.consumer_id#
	</cfif>
	<cfif len(attributes.employee_id) and len(attributes.employee)><!---  Teslim Edene göre--->
		AND SR.DELIVER_POS = #attributes.employee_id#
	</cfif>
</cfquery>
<cfquery name="GET_MEMBER_TOTAL" dbtype="query">
	SELECT
		SUM(COST_VALUE) TOTAL_MEMBER_COST	
	FROM
		GET_MEMBER_COST
</cfquery>
<cfquery name="GET_TOTAL_COST" datasource="#dsn2#">
	SELECT
		SUM(COST_VALUE) TOTAL_COST
	FROM
		SHIP_RESULT  WITH (NOLOCK)
	WHERE
		COST_VALUE > 0
</cfquery>
<cfsavecontent  variable="head"><cf_get_lang dictionary_id ='39528.Harcamalar'></cfsavecontent>
<cf_seperator title="#head#" id="expenses1">
<div id="expenses1" style="padding: 10px; display: block;float: left; width: 100%">
	<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id="57487.No"></th>
					<th><cf_get_lang_main no='1139.Gider Kalemi'></th>
					<th><cf_get_lang_main no ='261.Tutar '><cfoutput>#session.ep.money#</cfoutput></th>
					<th><cf_get_lang_main no ='261.Tutar '><cfoutput>#session.ep.money2#</cfoutput></th>
					<th>%</th>
				</tr>
			</thead>
			<cfset exp_total = 0>
			<cfset exp_total_2 = 0>
			<tbody>
				<cfoutput query="GET_EXPENSE_ITEMS">
					<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
						<cfset exp_total = exp_total + TOTAL_AMOUNT>
						<cfif len(OTHER_MONEY_VALUE_2)>
							<cfset exp_total_2 = exp_total_2 + OTHER_MONEY_VALUE_2>
						</cfif>
						<td>#currentrow#</td>
						<td>#EXPENSE_ITEM_NAME#</td>
						<td align="right" style="text-align:right;">#TLFormat(TOTAL_AMOUNT)# #session.ep.money#</td>
						<td align="right" style="text-align:right;">#TLFormat(OTHER_MONEY_VALUE_2)# #session.ep.money2#</td>
						<td>#Replace(NumberFormat(TOTAL_AMOUNT*100/GET_EXP_ITEM_TOTAL.TOTAL_AMOUNT,"00.00"),".",",")#</td>
					</tr>
				</cfoutput>
				<cfoutput>
					<tr>
						<td colspan="2"><cf_get_lang_main no ='80.Toplam'></td>
						<td align="right" style="text-align:right;">#TLFormat(exp_total)# #session.ep.money#</td>
						<td align="right" style="text-align:right;">#TLFormat(exp_total_2)# #session.ep.money2#</td>
						<td>100</td>
					</tr>
				</cfoutput>
			</tbody>
		</cf_grid_list>
	</div>
	<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<cfif isdefined("form.graph_type") and len(form.graph_type)>
				<cfset graph_type = form.graph_type>
			<cfelse>
				<cfset graph_type = "pie">
			</cfif>
			<cfif GET_EXPENSE_ITEMS.recordcount>
						<cfoutput query="GET_EXPENSE_ITEMS">
							<cfset 'item_#currentrow#'="#Left(GET_EXPENSE_ITEMS.EXPENSE_ITEM_NAME,15)#">
							<cfset 'value_#currentrow#'="#wrk_round(GET_EXPENSE_ITEMS.TOTAL_AMOUNT)#">
						</cfoutput>
				<script src="JS/Chart.min.js"></script> 
				<canvas id="myChart19" style="float:left;max-width:320px;max-height:320px;"></canvas>
				<script>
					var ctx = document.getElementById('myChart19');
						var myChart19 = new Chart(ctx, {
							type: '<cfoutput>#graph_type#</cfoutput>',
							data: {
								labels: [<cfloop from="1" to="#GET_EXPENSE_ITEMS.recordcount#" index="jj">
										 <cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
								datasets: [{
									label: "Harcamalar",
									backgroundColor: [<cfloop from="1" to="#GET_EXPENSE_ITEMS.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
									data: [<cfloop from="1" to="#GET_EXPENSE_ITEMS.recordcount#" index="jj"><cfoutput>#evaluate("value_#jj#")#</cfoutput>,</cfloop>],
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
<cfsavecontent  variable="head"><cf_get_lang dictionary_id ='39528.Harcamalar'></cfsavecontent>
<cf_seperator title="#head#" id="expenses2">
<div id="expenses2"   style="padding: 10px; display: block;float: left; width: 100%">
	<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id="57487.No"></th>
					<th><cf_get_lang no ='452.Aktivite Tipi'></th>
					<th><cf_get_lang_main no ='261.Tutar '><cfoutput>#session.ep.money#</cfoutput></th>
					<th><cf_get_lang_main no ='261.Tutar '><cfoutput>#session.ep.money2#</cfoutput></th>
					<th>%</th>
				</tr>
			</thead>
			<cfset exp_total = 0>
			<cfset exp_total_2 = 0>
			<tbody>
				<cfoutput query="GET_ACTIVITY_TYPES">
				<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
					<cfset exp_total = exp_total + TOTAL_AMOUNT>
					<cfif len(OTHER_MONEY_VALUE_2)>
						<cfset exp_total_2 = exp_total_2 + OTHER_MONEY_VALUE_2>
					</cfif>
					<td>#currentrow#</td>
					<td>#ACTIVITY_NAME#</td>
					<td align="right" style="text-align:right;">#TLFormat(TOTAL_AMOUNT)# #session.ep.money#</td>
					<td align="right" style="text-align:right;">#TLFormat(OTHER_MONEY_VALUE_2)# #session.ep.money2#</td>
					<td>#Replace(NumberFormat(TOTAL_AMOUNT*100/GET_ACT_TYP_TOTAL.TOTAL_AMOUNT,"00.00"),".",",")#</td>
				</tr>
				</cfoutput>
				<cfoutput>
					<tr>
						<td colspan="2"><cf_get_lang_main no ='80.Toplam'></td>
						<td align="right" style="text-align:right;">#TLFormat(exp_total)# #session.ep.money#</td>
						<td align="right" style="text-align:right;">#TLFormat(exp_total_2)# #session.ep.money2#</td>
						<td>100</td>
					</tr>
				</cfoutput>
			</tbody>
		</cf_grid_list>
	</div>
	<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<cfif isdefined("form.graph_type") and len(form.graph_type)>
				<cfset graph_type = form.graph_type>
			<cfelse>
				<cfset graph_type = "pie">
			</cfif>
			<cfif GET_ACTIVITY_TYPES.recordcount>
						<cfoutput query="GET_ACTIVITY_TYPES">
							<cfset 'item_#currentrow#'="#Left(GET_ACTIVITY_TYPES.ACTIVITY_NAME,15)#">
							<cfset 'value_#currentrow#'="#wrk_round(GET_ACTIVITY_TYPES.TOTAL_AMOUNT)#">
						</cfoutput>
				<canvas id="myChart20" style="float:left;max-width:220px;max-height:220px;"></canvas>
				<script>
					var ctx = document.getElementById('myChart20');
						var myChart20 = new Chart(ctx, {
							type: '<cfoutput>#graph_type#</cfoutput>',
							data: {
								labels: [<cfloop from="1" to="#GET_ACTIVITY_TYPES.recordcount#" index="jj">
										 <cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
								datasets: [{
									label: "Harcamalar",
									backgroundColor: [<cfloop from="1" to="#GET_ACTIVITY_TYPES.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
									data: [<cfloop from="1" to="#GET_ACTIVITY_TYPES.recordcount#" index="jj"><cfoutput>#evaluate("value_#jj#")#</cfoutput>,</cfloop>],
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
<cfsavecontent  variable="head"><cf_get_lang no ='1161.Tüm Harcamalara Oranı'></cfsavecontent>
<cf_seperator title="#head#" id="expenses3">
<div id="expenses3"   style="padding: 10px; display: block;float: left; width: 100%">
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<cfif isdefined("form.graph_type") and len(form.graph_type)>
				<cfset graph_type = form.graph_type>
			<cfelse>
				<cfset graph_type = "pie">
			</cfif>
			<cfif len(GET_EXPENSES.TOTAL_AMOUNT)>
						<cfset customer_offer_rate = (GET_EXPENSES.TOTAL_AMOUNT*100)/EXPENSE_TOTAL.TOTAL_AMOUNT>
						<cfsavecontent variable="message"><cf_get_lang no ='1164.Toplam Harcama'></cfsavecontent>
						<cfset item1 = "#message# (#TLFormat(EXPENSE_TOTAL.TOTAL_AMOUNT)#)">
						<cfset value1 = "#(100-customer_offer_rate)/100#">
						<cfsavecontent variable="message"><cf_get_lang no ='1165.Müsteri Harcama'></cfsavecontent>
						<cfset item2 = "#message# (#TLFormat(GET_EXPENSES.TOTAL_AMOUNT)#)">
						<cfset value2 = "#(customer_offer_rate/100)#">

				<canvas id="myChart21" style="float:left;max-width:220px;max-height:220px;"></canvas>
				<script>
					var ctx = document.getElementById('myChart21');
						var myChart21 = new Chart(ctx, {
							type: '<cfoutput>#graph_type#</cfoutput>',
							data: {
								labels: ["<cfoutput>#item1#</cfoutput>","<cfoutput>#item2#</cfoutput>"],
								datasets: [{
									label: "Tüm Harcamalara Oranı",
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
<cfsavecontent  variable="head"><cf_get_lang no ='1162.Sevkiyat Harcamaları'></cfsavecontent>
<cf_seperator title="#head#" id="expenses4">
<div id="expenses4" style="padding: 10px; display: block;float: left; width: 100%">
	<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id="57487.No"></th>
					<th><cf_get_lang no ='1163.Sevkiyat No'></th>
					<th><cf_get_lang_main no ='261.Tutar '><cfoutput>#session.ep.money#</cfoutput></th>
					<th><cf_get_lang_main no ='261.Tutar '><cfoutput>#session.ep.money2#</cfoutput></th>
					<th>%</th>
				</tr>
			</thead>
			<cfset cost_total = 0>
			<cfset cost_total_2 = 0>
			<tbody>
				<cfoutput query="GET_MEMBER_COST">
				<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
					<cfset cost_total = cost_total + COST_VALUE>
					<cfif len(COST_VALUE2)>
						<cfset cost_total_2 = cost_total_2 + COST_VALUE2>
					</cfif>
					<td>#currentrow#</td>
					<td>#ship_fis_no#</td>
					<td align="right" style="text-align:right;">#TLFormat(COST_VALUE)# #session.ep.money#</td>
					<td align="right" style="text-align:right;">#TLFormat(COST_VALUE2)# #session.ep.money2#</td>
					<td>#Replace(NumberFormat(COST_VALUE*100/GET_TOTAL_COST.TOTAL_COST,"00.00"),".",",")#</td>
				</tr>
				</cfoutput>
				<cfoutput>
					<tr>
						<td colspan="2"><cf_get_lang_main no ='80.Toplam'></td>
						<td align="right" style="text-align:right;">#TLFormat(cost_total)# #session.ep.money#</td>
						<td align="right" style="text-align:right;">#TLFormat(cost_total_2)# #session.ep.money2#</td>
						<td>100</td>
					</tr>
				</cfoutput>
			</tbody>
		</cf_grid_list>
	</div>
	<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<cfif isdefined("form.graph_type") and len(form.graph_type)>
				<cfset graph_type = form.graph_type>
			<cfelse>
				<cfset graph_type = "pie">
			</cfif>
			<cfif len(GET_MEMBER_TOTAL.TOTAL_MEMBER_COST)>
						<cfset customer_cost_rate = (GET_MEMBER_TOTAL.TOTAL_MEMBER_COST*100)/GET_TOTAL_COST.TOTAL_COST>
						<cfsavecontent variable="message"><cf_get_lang no ='1164.Toplam Harcama'></cfsavecontent>
						<cfset item1 = "#message# (#TLFormat(GET_TOTAL_COST.TOTAL_COST)#)">
						<cfset value1 = "#(100-customer_cost_rate)/100#">
						<cfsavecontent variable="message"><cf_get_lang no ='1165.Müsteri Harcama'></cfsavecontent>
						<cfset item1 = "#message# (#TLFormat(GET_MEMBER_TOTAL.TOTAL_MEMBER_COST)#)">
						<cfset value1 = "#(customer_cost_rate/100)#">

				<canvas id="myChart22" style="float:left;max-width:220px;max-height:220px;"></canvas>
				<script>
					var ctx = document.getElementById('myChart22');
						var myChart22 = new Chart(ctx, {
							type: '<cfoutput>#graph_type#</cfoutput>',
							data: {
								labels: ["<cfoutput>#item1#</cfoutput>","<cfoutput>#item2#</cfoutput>"],
								datasets: [{
									label: "Sevkiyat Harcamaları",
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
