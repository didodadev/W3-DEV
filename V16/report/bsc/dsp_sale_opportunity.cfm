<cfquery name="GET_OPPORTUNITIES" datasource="#dsn3#">
	SELECT 
		O.OPP_ID,
		O.OPP_STAGE,
		O.OPPORTUNITY_TYPE_ID,
		O.SALE_ADD_OPTION_ID,
		P.STAGE,
		SO.OPPORTUNITY_TYPE
	FROM
		OPPORTUNITIES O WITH (NOLOCK),
		#dsn_alias#.PROCESS_TYPE_ROWS P WITH (NOLOCK),
		SETUP_OPPORTUNITY_TYPE SO WITH (NOLOCK)
	WHERE
		O.OPP_STAGE = P.PROCESS_ROW_ID AND
		O.OPPORTUNITY_TYPE_ID = SO.OPPORTUNITY_TYPE_ID
	<cfif len(attributes.company_id) and len(attributes.member_name)>
		AND O.COMPANY_ID = #attributes.company_id#
	<cfelseif len(attributes.consumer_id) and len(attributes.member_name)>
		AND O.CONSUMER_ID = #attributes.consumer_id#
	</cfif>		
	<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
		AND O.OPP_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
	<cfelseif isdate(attributes.start_date)>
		AND O.OPP_DATE >= #attributes.start_date#
	<cfelseif isdate(attributes.finish_date)>
		AND O.OPP_DATE <= #attributes.finish_date#
	</cfif>
	<cfif len(attributes.employee_id)>
		AND O.SALES_EMP_ID = #attributes.employee_id#
	</cfif>
</cfquery>

<cfquery name="GET_OPP_STAGE" dbtype="query">
	SELECT
		COUNT(OPP_STAGE) COUNT_STAGE,
		STAGE,
		OPP_STAGE
	FROM
		GET_OPPORTUNITIES
	GROUP BY
		STAGE,
		OPP_STAGE
	ORDER BY
		COUNT_STAGE DESC		
</cfquery>

<cfquery name="GET_OPPORTUNITY_TYPE" dbtype="query">
	SELECT
		COUNT(OPPORTUNITY_TYPE_ID) COUNT_OPPORTUNITY_TYPE,
		OPPORTUNITY_TYPE,
		OPPORTUNITY_TYPE_ID
	FROM
		GET_OPPORTUNITIES
	GROUP BY
		OPPORTUNITY_TYPE,
		OPPORTUNITY_TYPE_ID
	ORDER BY
		COUNT_OPPORTUNITY_TYPE DESC		
</cfquery>

<cfquery name="GET_SALES_OPTION" dbtype="query">
	SELECT
		COUNT(SALE_ADD_OPTION_ID) COUNT_SALE_ADD_OPTION,
		SALE_ADD_OPTION_ID
	FROM
		GET_OPPORTUNITIES
	GROUP BY
		SALE_ADD_OPTION_ID
	ORDER BY
		COUNT_SALE_ADD_OPTION DESC		
</cfquery>

<cfif isdefined("form.graph_type") and len(form.graph_type)>
	<cfset graph_type = form.graph_type>
<cfelse>
	<cfset graph_type = "pie">
</cfif>
<cfsavecontent  variable="head"><cf_get_lang dictionary_id ='39512.Satış Fırsatları'>
</cfsavecontent>
<cf_seperator title="#head#" id="satisfirsat1">
<div id="satisfirsat1"  style="padding: 10px; display: block;float: left; width: 100%">
	<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
		<p class="phead"><cf_get_lang no ='1129.Aşama Bazında Fırsatlar'></p>
		<cf_grid_list>
			<thead>
				<tr>
					<th width="125"><cf_get_lang no ='1130.Aşama Adı'></td>
					<th  align="right"  style="text-align:right;"><cf_get_lang no ='1131.Sayısı'></td>
				</tr>
			</thead>
			<cfset total_opp_stage = 0>
			<tbody>
				<cfoutput query="get_opp_stage">
					<tr>		
						<td>#stage#</td>
						<td align="right" style="text-align:right;">
						&nbsp;#TLFormat(count_stage,0)#
						<cfset total_opp_stage = total_opp_stage + count_stage>
						</td>
					</tr>
					</cfoutput>
					<tr>		
						<td class="txtbold"><cf_get_lang_main no ='80.Toplam'></td>
						<td align="right" class="txtbold" style="text-align:right;"><cfoutput>#TLFormat(get_opportunities.recordcount,0)#</cfoutput></td>
					</tr>	
			</tbody>
		</cf_grid_list>
	</div>
	
	
	<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
		<cfif get_opp_stage.recordcount>
			<cfoutput query="get_opp_stage">
					<cfset 'temp_opp_stage_#opp_stage#' = (count_stage*100)/total_opp_stage>
					<cfset 'item_#currentrow#' = "#STAGE#">
					<cfset 'value_#currentrow#' = "#wrk_round(evaluate('temp_opp_stage_#opp_stage#')/100)#">
			</cfoutput>
		</cfif>
				<script src="JS/Chart.min.js"></script> 
				<canvas id="myChart9" style="float:left;max-width:320px;max-height:320px;"></canvas>
				<script>
					var ctx = document.getElementById('myChart9');
						var myChart9 = new Chart(ctx, {
							type: '<cfoutput>#graph_type#</cfoutput>',
							data: {
								labels: [<cfloop from="1" to="#get_opp_stage.recordcount#" index="jj">
												 <cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
								datasets: [{
									label: "Satış Fırsatları",
									backgroundColor: [<cfloop from="1" to="#get_opp_stage.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
									data: [<cfloop from="1" to="#get_opp_stage.recordcount#" index="jj"><cfoutput>#evaluate("value_#jj#")#</cfoutput>,</cfloop>],
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
	<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
		<p class="phead"><cf_get_lang no ='1132.Kategori Bazında Fırsatlar'></p>
		<cf_grid_list>
			<thead>
				<tr>
					<th width="125"><cf_get_lang no ='1133.Kategori Adı'></td>
					<th  align="right"  style="text-align:right;"><cf_get_lang no ='1131.Sayısı'></td>
				</tr>
			</thead>
				<cfset total_opportunity_type = 0>
			<tbody>
				<cfoutput query="get_opportunity_type">
					<tr>		
						<td>#opportunity_type#</td>
						<td align="right" style="text-align:right;">
						&nbsp;#TLFormat(count_opportunity_type,0)#
						<cfset total_opportunity_type = total_opportunity_type + count_opportunity_type>
						</td>
					</tr>
				</cfoutput>
				<tr>		
					<td class="txtbold"><cf_get_lang_main no ='80.Toplam'></td>
					<td align="right" class="txtbold" style="text-align:right;"><cfoutput>#TLFormat(get_opportunities.recordcount,0)#</cfoutput></td>
				</tr>	
			</tbody>
		</cf_grid_list>
	</div>
	<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
	 	<cfif get_opportunity_type.recordcount>
		  <cfoutput query="get_opportunity_type">
			<cfset 'temp_opportunity_type_#opportunity_type_id#' = (count_opportunity_type*100)/total_opportunity_type>
			<cfset 'item_#currentrow#' = "#opportunity_type#">
			<cfset 'value_#currentrow#' ="#wrk_round(evaluate('temp_opportunity_type_#opportunity_type_id#')/100)#">
		  </cfoutput>
			<canvas id="myChart10" style="float:left;max-width:320px;max-height:320px;"></canvas>
				<script>
					var ctx = document.getElementById('myChart10');
						var myChart10 = new Chart(ctx, {
							type: '<cfoutput>#graph_type#</cfoutput>',
							data: {
								labels: [<cfloop from="1" to="#get_opportunity_type.recordcount#" index="jj">
												 <cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
								datasets: [{
									label: "Satış Fırsatları",
									backgroundColor: [<cfloop from="1" to="#get_opportunity_type.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
									data: [<cfloop from="1" to="#get_opportunity_type.recordcount#" index="jj"><cfoutput>#evaluate("value_#jj#")#</cfoutput>,</cfloop>],
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
		<p class="phead"><cf_get_lang no ='1134.Özel Tanım Bazında Fırsatlar'></p>
		<cf_grid_list>
			<thead>
				<tr>
					<th width="125"><cf_get_lang no ='1135.Özel Tanım Adı'></th>
					<th  align="right"  style="text-align:right;"><cf_get_lang no ='1131.Sayısı'></td>
				</tr>
			</thead>
			<tbody>
				<cfif get_sales_option.recordcount>
					<cfset option_id_list=''>
					<cfoutput query="get_sales_option">
						<cfif len(sale_add_option_id) and not listfind(option_id_list,sale_add_option_id)>
							<cfset option_id_list = Listappend(option_id_list,sale_add_option_id)>
						</cfif>
					</cfoutput>	
					
					<cfif len(option_id_list)>
						<cfquery name="GET_OPTION_NAME" datasource="#DSN3#">
							SELECT
								SALES_ADD_OPTION_ID,
								SALES_ADD_OPTION_NAME
							FROM
								SETUP_SALES_ADD_OPTIONS WITH (NOLOCK)
							WHERE
								SALES_ADD_OPTION_ID IN (#option_id_list#)
						</cfquery>
						<cfset option_id_list = listdeleteduplicates(valuelist(get_option_name.sales_add_option_id,','))>
					</cfif>
				</cfif>
				<cfset total_sales_option = 0>
				<cfoutput query="get_sales_option">
				<tr>		
					<td><cfif len(sale_add_option_id)>#get_option_name.sales_add_option_name[listfind(option_id_list,sale_add_option_id,',')]#<cfelse>Tanımsız</cfif></td>
					<td align="right" style="text-align:right;">
					&nbsp;#TLFormat(count_sale_add_option,0)#
					<cfset total_sales_option = total_sales_option + count_sale_add_option>
					</td>
				</tr>
					
				</cfoutput>
				<tr>		
					<td class="txtbold"><cf_get_lang_main no ='80.Toplam'></td>
					<td align="right" class="txtbold" style="text-align:right;"><cfoutput>#TLFormat(get_opportunities.recordcount,0)#</cfoutput></td>
				</tr>	
			</tbody>
		</cf_grid_list>
	</div>
	<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
	 	<cfif get_opp_stage.recordcount>
		  <cfoutput query="get_sales_option">
				<cfset 'temp_sales_option_#sale_add_option_id#' = (count_sale_add_option*100)/total_sales_option>
				<cfif len(sale_add_option_id)>
						<cfset 'item_#currentrow#'="#get_option_name.sales_add_option_name[listfind(option_id_list,sale_add_option_id,',')]#">
						<cfset 'value_#currentrow#'="#wrk_round(evaluate('temp_sales_option_#sale_add_option_id#')/100)#">
				<cfelse>
						<cfsavecontent variable="message"><cf_get_lang_main no='1433.Tanımsız'></cfsavecontent>
						<cfset 'item_#currentrow#'="#message#">
						<cfset 'value_#currentrow#'="#wrk_round(evaluate('temp_sales_option_#sale_add_option_id#')/100)#">
				</cfif>
		  </cfoutput>
				<canvas id="myChart11" style="float:left;max-width:320px;max-height:320px;"></canvas>
				<script>
					var ctx = document.getElementById('myChart11');
						var myChart11 = new Chart(ctx, {
							type: '<cfoutput>#graph_type#</cfoutput>',
							data: {
								labels: [<cfloop from="1" to="#get_sales_option.recordcount#" index="jj">
												 <cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
								datasets: [{
									label: "Satış Fırsatları",
									backgroundColor: [<cfloop from="1" to="#get_sales_option.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
									data: [<cfloop from="1" to="#get_sales_option.recordcount#" index="jj"><cfoutput>#evaluate("value_#jj#")#</cfoutput>,</cfloop>],
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
