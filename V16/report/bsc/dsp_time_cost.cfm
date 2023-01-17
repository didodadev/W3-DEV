<cfset list_time_type = 'Proje,Toplantı,Sistem,Service,Eğitim,İş,Sistem İş,Diğer'>
<cfset list_time_type2 = 'PROJECT_ID,EVENT_ID,SUBSCRIPTION_ID,SERVICE_ID,CLASS_ID,WORK_ID,BUG_ID'>

<cfif len(attributes.employee_id) and len(attributes.employee)>
	<cfquery name="GET_TIME_COST_EMP" datasource="#dsn#">
		SELECT 
			SUM(EXPENSED_MINUTE) EXPENSED_MINUTE,
			SUM(EXPENSED_MONEY) EXPENSED_MONEY,
			CONSUMER_ID,
			EMPLOYEE_ID,
			COMPANY_ID
		FROM 
			TIME_COST WITH (NOLOCK)
		WHERE 
			 OUR_COMPANY_ID = #session.ep.company_id# AND
			 EMPLOYEE_ID = #attributes.employee_id#
		<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
			AND EVENT_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
		<cfelseif isdate(attributes.start_date)>
			AND EVENT_DATE >= #attributes.start_date#
		<cfelseif isdate(attributes.finish_date)>
			AND EVENT_DATE <= #attributes.finish_date#
		</cfif>
		GROUP BY
			CONSUMER_ID,
			COMPANY_ID,
			EMPLOYEE_ID
	</cfquery>
	
	<cfquery name="get_total_emp" dbtype="query">
		SELECT
			SUM(EXPENSED_MINUTE) EXPENSED_MINUTE_TOTAL,
			SUM(EXPENSED_MONEY) EXPENSED_MONEY_TOTAL
		FROM 
			GET_TIME_COST_EMP
	</cfquery>
	
	<cfquery name="GET_TIME_COST_TYPE" datasource="#dsn#">
		SELECT 
			EXPENSED_MINUTE,
			EXPENSED_MONEY,
			WORK_ID,
			SERVICE_ID,
			EVENT_ID,
			PROJECT_ID,
			SUBSCRIPTION_ID,
			CLASS_ID,
			BUG_ID
		FROM 
			TIME_COST WITH (NOLOCK)
		WHERE 
			OUR_COMPANY_ID = #session.ep.company_id# AND
		<cfif len(attributes.employee_id)>
			EMPLOYEE_ID = #attributes.employee_id#
		</cfif>
		<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
			AND EVENT_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
		<cfelseif isdate(attributes.start_date)>
			AND EVENT_DATE >= #attributes.start_date#
		<cfelseif isdate(attributes.finish_date)>
			AND EVENT_DATE <= #attributes.finish_date#
		</cfif>
	</cfquery>
</cfif>
<cfif len(attributes.company_id) or len(attributes.consumer_id)>
	<cfquery name="GET_TIME_COST" datasource="#dsn#">
		SELECT 
			SUM(EXPENSED_MINUTE) EXPENSED_MINUTE,
			SUM(EXPENSED_MONEY) EXPENSED_MONEY,
			CONSUMER_ID,
			COMPANY_ID,
			EMPLOYEE_ID
		FROM 
			TIME_COST WITH (NOLOCK)
		WHERE 
			OUR_COMPANY_ID = #session.ep.company_id# AND
		<cfif len(attributes.consumer_id)>
			CONSUMER_ID = #attributes.consumer_id#
		<cfelseif len(attributes.company_id)>
			COMPANY_ID = #attributes.company_id#
		</cfif>
		<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
			AND EVENT_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
		<cfelseif isdate(attributes.start_date)>
			AND EVENT_DATE >= #attributes.start_date#
		<cfelseif isdate(attributes.finish_date)>
			AND EVENT_DATE <= #attributes.finish_date#
		</cfif>
		GROUP BY
			CONSUMER_ID,
			COMPANY_ID,
			EMPLOYEE_ID
	</cfquery>

	<cfquery name="get_total_comp" dbtype="query">
		SELECT
			SUM(EXPENSED_MINUTE) EXPENSED_MINUTE_TOTAL,
			SUM(EXPENSED_MONEY) EXPENSED_MONEY_TOTAL
		FROM 
			GET_TIME_COST
	</cfquery>
</cfif>

<cfif isdefined("form.graph_type") and len(form.graph_type)>
	<cfset graph_type = form.graph_type>
<cfelse>
	<cfset graph_type = "pie">
</cfif>
<cfsavecontent  variable="head"><cf_get_lang dictionary_id ='57561.Zaman Harcamaları'></cfsavecontent>
<cf_seperator title="#head#" id="timespending1">
<div id="timespending1" style="padding: 10px; display: block;float: left; width: 100%">
	<cfif (len(attributes.company_id) and len(attributes.member_name)) or (len(attributes.consumer_id) and len(attributes.member_name))>
		<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
			<cf_grid_list>
				<thead>
					<tr>
						<th><cf_get_lang_main no ='164.Çalışan'></th>
						<th><cf_get_lang_main no='1716.Süre'></th>
						<th><cf_get_lang no ='261.Tutar'> <cfoutput>#session.ep.money#</cfoutput></th>
					</tr>
				</thead>
				<tbody>
					<cfoutput query="get_time_cost">  
						<tr>
							<td>#currentrow#- 
								<cfif len(get_time_cost.employee_id)>
									#GET_EMP_INFO(employee_id,0,0,0)#
								</cfif>
							</td>
							<td>
								<cfif len(expensed_minute)>
									<cfset totaltime = expensed_minute mod 60>
									#((expensed_minute-totaltime)/60)#:#totaltime# Sa
								</cfif>
							</td>
							<td class="text-right">#TLFormat(expensed_money)# #session.ep.money#</td>
						</tr>
					</cfoutput>
					<cfoutput query="get_total_comp">
						<tr>
							<td><cf_get_lang dictionary_id='57492.Toplam'></td>
							<td>
								<cfif len(expensed_minute_total)>
								<cfset totaltime = expensed_minute_total mod 60>
									#((expensed_minute_total-totaltime)/60)#:#totaltime# Sa
								</cfif>
							</td>
							<td class="text-right">#expensed_money_total# #session.ep.money#</td>
						</tr>	
					</cfoutput>
				</tbody>
			</cf_grid_list>
		</div>
	</cfif>
	<script src="JS/Chart.min.js"></script> 
	<cfif (len(attributes.company_id) and len(attributes.member_name)) or (len(attributes.consumer_id) and len(attributes.member_name))>
		<cfif get_time_cost.recordcount>
			<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
				<cfoutput query="get_time_cost">
						<cfset totaltime = EXPENSED_MINUTE mod 60>
						<cfset saat = ((EXPENSED_MINUTE-totaltime)/60)&'.'&totaltime>
						<cfset 'item_#currentrow#'="#GET_EMP_INFO(employee_id,0,0,0)# (#saat#)">
						<cfset 'value_#currentrow#'="#((EXPENSED_MINUTE*100)/get_total_comp.EXPENSED_MINUTE_TOTAL)/100#">
					</cfoutput>
					<canvas id="zamanh1" style="float:left;max-width:320px;max-height:320px;"></canvas>
					<script>
						var ctx = document.getElementById('zamanh1');
							var zamanh1 = new Chart(ctx, {
								type: '<cfoutput>#graph_type#</cfoutput>',
								data: {
									labels: [<cfloop from="1" to="#get_time_cost.recordcount#" index="jj">
													<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
									datasets: [{
										label: "Zaman Harcamaları",
										backgroundColor: [<cfloop from="1" to="#get_time_cost.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
										data: [<cfloop from="1" to="#get_time_cost.recordcount#" index="jj"><cfoutput>#evaluate("value_#jj#")#</cfoutput>,</cfloop>],
									}]
								},
								options: {
									legend: {
										display: false
									}
								}
						});
						</script>
			</div>
		</cfif>
	</cfif>
	
	<cfif len(attributes.employee_id) and len(attributes.employee)>
		<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
			<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang_main no ='246.Üye'></th>
					<th><cf_get_lang_main no='1716.Süre'></th>
					<th class="moneybox" width="75"><cf_get_lang no ='261.Tutar'> <cfoutput>#session.ep.money#</cfoutput></th>
				</tr>
			</thead>
			<tbody>
				<cfoutput query="get_time_cost_emp">  
					<tr>		
					<td>#currentrow#- 
						<cfif len(get_time_cost_emp.company_id)>
							#GET_PAR_INFO(company_id,1,1,0)#
						<cfelseif len(get_time_cost_emp.consumer_id)>
							#GET_CONS_INFO(consumer_id,0,0,0)#
						<cfelseif len(get_time_cost_emp.employee_id)>
							#GET_EMP_INFO(get_time_cost_emp.employee_id,0,0,0)#
						</cfif>
					</td>
					<td><cfif len(expensed_minute)>
						<cfset totaltime = expensed_minute mod 60>
							#((expensed_minute-totaltime)/60)#:#totaltime# Sa
						</cfif>
					</td>
					<td class="text-right">#TLFormat(expensed_money)# #session.ep.money#</td>
					</tr>
				</cfoutput>
				<cfoutput query="get_total_emp">
					<tr>
					<td><cf_get_lang dictionary_id='57492.Toplam'></td>
					<td>
						<cfif len(expensed_minute_total)>
						<cfset totaltime = expensed_minute_total mod 60>
							#((expensed_minute_total-totaltime)/60)#:#totaltime# Sa
						</cfif>
					</td>
					<td class="text-right">#expensed_money_total# #session.ep.money#</td>
					</tr>
				</cfoutput>
			</tbody>
			</cf_grid_list>
		</div>
		<cfif get_time_cost_emp.recordcount>
			<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
				<cfoutput query="get_time_cost_emp">
						<cfset totaltime = EXPENSED_MINUTE mod 60>
						<cfset saat = ((EXPENSED_MINUTE-totaltime)/60)&'.'&totaltime>
						<cfif len(get_time_cost_emp.company_id)>
								<cfset 'item_#currentrow#'="#GET_PAR_INFO(company_id,1,1,0)# (#saat# Sa)">
								<cfset 'value_#currentrow#'="#((EXPENSED_MINUTE*100)/get_total_emp.EXPENSED_MINUTE_TOTAL)/100#">
						<cfelseif len(get_time_cost_emp.consumer_id)>
								<cfset 'item_#currentrow#'="#GET_CONS_INFO(consumer_id,0,0,0)# (#saat# Sa)">
								<cfset 'value_#currentrow#'="#((EXPENSED_MINUTE*100)/get_total_emp.EXPENSED_MINUTE_TOTAL)/100#">
						<cfelseif len(get_time_cost_emp.employee_id)>
							<cfsavecontent variable="message"><cf_get_lang_main no='744.Diğer'></cfsavecontent>
								<cfset 'item_#currentrow#'="#GET_EMP_INFO(get_time_cost_emp.employee_id,0,0,0)# (#saat# Sa)">
								<cfset 'value_#currentrow#'="#((EXPENSED_MINUTE*100)/get_total_emp.EXPENSED_MINUTE_TOTAL)/100#">
						</cfif>
				</cfoutput>
				<canvas id="zamanh2" style="float:left;max-width:320px;max-height:320px;"></canvas>
				<script>
					var ctx = document.getElementById('zamanh2');
						var zamanh2 = new Chart(ctx, {
							type: '<cfoutput>#graph_type#</cfoutput>',
							data: {
								labels: [<cfloop from="1" to="#get_time_cost_emp.recordcount#" index="jj">
												<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
								datasets: [{
									label: "Zaman Harcamaları",
									backgroundColor: [<cfloop from="1" to="#get_time_cost_emp.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
									data: [<cfloop from="1" to="#get_time_cost_emp.recordcount#" index="jj"><cfoutput>#evaluate("value_#jj#")#</cfoutput>,</cfloop>],
								}]
							},
							options: {
								legend: {
									display: false
								}
							}
					});
				</script>
			</div>		
		</cfif>
		<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
			<cf_grid_list>
				<thead>
					<tr>
						<th><cf_get_lang no ='1166.Zaman Harcama Tipi'></th>
						<th><cf_get_lang_main no='1716.Süre'></th>
						<th class="moneybox"><cf_get_lang no ='261.Tutar'> <cfoutput>#session.ep.money#</cfoutput></th>
					</tr>
				</thead>
				<cfset toplam_minute = 0>
				<cfset toplam_money = 0>
				<tbody>
					<cfif get_time_cost_type.recordcount>
						<cfset zaman_list = "">
						<cfset name_list = "">
						<cfloop from="1" to="#listlen(list_time_type)#" index="i">
							<cfquery name="GET_TYPE_" dbtype="query">
								SELECT
									SUM(EXPENSED_MINUTE) TOTAL_EXPENSED_MINUTE,
									SUM(EXPENSED_MONEY) TOTAL_EXPENSED_MONEY
								FROM 
									get_time_cost_type
								WHERE
									<cfif i neq listlen(list_time_type)>
										#listgetat(list_time_type2,i)# IS NOT NULL
									<cfelse>
										<cfloop from="1" to="#listlen(list_time_type2)#" index="k">
											#listgetat(list_time_type2,k)# IS NULL 
											<cfif k neq listlen(list_time_type2)>AND</cfif>
										</cfloop>
									</cfif>
							</cfquery> 
							
							<cfoutput> 
							<tr>
								<td><cfset my_name = "#listgetat(list_time_type,i)#">#my_name#</td>
								<td>
								<cfif len(GET_TYPE_.TOTAL_EXPENSED_MINUTE)>
									<cfset toplam_minute = toplam_minute+get_type_.total_expensed_minute>
									<cfset totaltime = GET_TYPE_.total_expensed_minute mod 60>
										#((GET_TYPE_.total_expensed_minute-totaltime)/60)#:#totaltime# Sa
									<cfset my_zaman = GET_TYPE_.TOTAL_EXPENSED_MINUTE>
								<cfelse>
									<cfset my_zaman = 0>00:00
								</cfif>
								</td>
								<td class="text-right">
									<cfif len(GET_TYPE_.TOTAL_EXPENSED_MONEY)>
										<cfset my_tutar = GET_TYPE_.TOTAL_EXPENSED_MONEY>
										<cfset toplam_money = toplam_money+get_type_.total_expensed_money>
									<cfelse>
										<cfset my_tutar = 0>
									</cfif>
									#my_tutar# #session.ep.money#
								</td>
							</tr>
							</cfoutput>
							<cfset zaman_list = listappend(zaman_list,my_zaman)>
							<cfset name_list = listappend(name_list,my_name)>
						</cfloop>
					</cfif>
					<cfoutput>
						<tr>
							<td><cf_get_lang dictionary_id='57492.Toplam'></td>
							<td>
								<cfset totaltime = toplam_minute mod 60>
								#((toplam_minute-totaltime)/60)#:#totaltime# Sa
							</td>
							<td class="text-right" style="text-align:right;">#toplam_money# #session.ep.money#</td>
						</tr>
					</cfoutput>
				</tbody>
			</cf_grid_list>
		</div>
		<cfif get_time_cost_type.recordcount>
			<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
				<cfset dongu_ = 0>
				<cfloop list="#name_list#" index="i">
					<cfset dongu_ = dongu_ + 1>
					<cfset this_zaman_ = listgetat(zaman_list,dongu_)>
					<cfset totaltime_ = listgetat(zaman_list,dongu_) mod 60>
					<cfset saat = ((listgetat(zaman_list,dongu_)-totaltime_)/60)&'.'&totaltime_>
					<cfset 'item_#dongu_#'="#i# #saat#">
					<cfset 'value_#dongu_#'="#((100*this_zaman_)/toplam_minute)/100#">
				</cfloop>
				<canvas id="zamanh3" style="float:left;max-width:320px;max-height:320px;"></canvas>
				<script>
					var ctx = document.getElementById('zamanh3');
						var zamanh3 = new Chart(ctx, {
							type: '<cfoutput>#graph_type#</cfoutput>',
							data: {
								labels: [<cfloop from="1" to="#listlen(name_list)#" index="jj">
												<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
								datasets: [{
									label: "Zaman Harcamaları",
									backgroundColor: [<cfloop from="1" to="#listlen(name_list)#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
									data: [<cfloop from="1" to="#listlen(name_list)#" index="jj"><cfoutput>#evaluate("value_#jj#")#</cfoutput>,</cfloop>],
								}]
							},
							options: {
								legend: {
									display: false
								}
							}
					});
				</script>
			</div>
		</cfif>
	</cfif>	
</div>
