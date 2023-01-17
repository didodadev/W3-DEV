<!--- Secilen üye,tarih ve çalışana göre sistem kayıtlarını ve bütün sistemlere oranını getirir Ayşenur20061013--->
<cfquery name="GET_SC_CONTRACT_TOTAL" datasource="#dsn3#">
	SELECT 
		COUNT(SUBSCRIPTION_ID) SC_CONTRACT_TOTAL
	FROM 
		SUBSCRIPTION_CONTRACT WITH (NOLOCK)
	WHERE 
		SUBSCRIPTION_ID IS NOT NULL
	<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
		AND START_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
	<cfelseif isdate(attributes.start_date)>
		AND START_DATE >= #attributes.start_date#
	<cfelseif isdate(attributes.finish_date)>
		AND START_DATE <= #attributes.finish_date#
	</cfif>
</cfquery>
<cfquery name="GET_SUBSCRIPTION_CONTRACT" datasource="#dsn3#">
	SELECT 
		SC.SUBSCRIPTION_ID,
		SC.START_DATE,
		SC.SUBSCRIPTION_NO,
		SC.SUBSCRIPTION_ADD_OPTION_ID,
		SC.SUBSCRIPTION_STAGE,
		SST.SUBSCRIPTION_TYPE
	FROM 
		SUBSCRIPTION_CONTRACT SC WITH (NOLOCK),
		SETUP_SUBSCRIPTION_TYPE SST WITH (NOLOCK)
	WHERE 
		SST.SUBSCRIPTION_TYPE_ID = SC.SUBSCRIPTION_TYPE_ID
 	<cfif len(attributes.company_id)>
		AND SC.SALES_COMPANY_ID = #attributes.company_id#
	<cfelseif len(attributes.consumer_id)>
		AND SC.SALES_CONSUMER_ID = #attributes.consumer_id#
	</cfif>
	<cfif len(attributes.employee_id) and len(attributes.employee)>
		AND SC.SALES_EMP_ID = #attributes.employee_id#
	</cfif>
	<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
		AND SC.START_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
	<cfelseif isdate(attributes.start_date)>
		AND SC.START_DATE >= #attributes.start_date#
	<cfelseif isdate(attributes.finish_date)>
		AND SC.START_DATE <= #attributes.finish_date#
	</cfif>
	ORDER BY
		SC.SUBSCRIPTION_ID
</cfquery>
<cfquery name="GET_SC_CONTRACTS" dbtype="query">
	SELECT
		COUNT(SUBSCRIPTION_ID) SUBS_TOTAL
	FROM
		GET_SUBSCRIPTION_CONTRACT
</cfquery>
<cfsavecontent  variable="head"><cf_get_lang dictionary_id ='39861.Sistemler/Abonelikler'></cfsavecontent>
<cf_seperator title="#head#" id="sistem1">
<div id="sistem1"   style="padding: 10px; display: block;float: left; width: 100%">
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id="57487.No"></td>
					<th><cf_get_lang_main no='1705.Sistem No'></td>
					<th><cf_get_lang_main no ='74.Kategori'></td>
					<th><cf_get_lang no ='557.Sistem Özel Tanım'></td>
					<th><cf_get_lang_main no ='70.Aşama'></td>
					<th><cf_get_lang_main no='335.Sözleşme Tarihi'></th>
				</tr>
			</thead>
			<cfset subs_add_option_list="">
			<cfset s_stage_id_list=''>
			<cfoutput query="GET_SUBSCRIPTION_CONTRACT" maxrows="20">
				<cfif len(SUBSCRIPTION_ADD_OPTION_ID) and not listfind(subs_add_option_list,SUBSCRIPTION_ADD_OPTION_ID)>
					<cfset subs_add_option_list=listappend(subs_add_option_list,SUBSCRIPTION_ADD_OPTION_ID)>
				</cfif>
				<cfif len(SUBSCRIPTION_STAGE) and not listfind(s_stage_id_list,SUBSCRIPTION_STAGE)>
					<cfset s_stage_id_list=listappend(s_stage_id_list,SUBSCRIPTION_STAGE)>
				</cfif>
			</cfoutput>
			<cfif len(subs_add_option_list)>
				<cfset subs_add_option_list=listsort(subs_add_option_list,"numeric","ASC",",")>
				<cfquery name="GET_SUBS_ADD_OPTION" datasource="#DSN3#">
					SELECT SUBSCRIPTION_ADD_OPTION_NAME FROM SETUP_SUBSCRIPTION_ADD_OPTIONS WHERE SUBSCRIPTION_ADD_OPTION_ID IN (#subs_add_option_list#) ORDER BY SUBSCRIPTION_ADD_OPTION_ID
				</cfquery>				
			</cfif>
			<cfif len(s_stage_id_list)>
				<cfset s_stage_id_list=listsort(s_stage_id_list,"numeric","ASC",",")>
				<cfquery name="GET_STAGE_TYPES" datasource="#dsn#">
					SELECT STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#s_stage_id_list#) ORDER BY PROCESS_ROW_ID
				</cfquery>
			</cfif>
			<tbody>
				<cfif GET_SUBSCRIPTION_CONTRACT.recordcount>
					<cfoutput query="GET_SUBSCRIPTION_CONTRACT" maxrows="20">
						<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
							<td>#currentrow#</td>
							<td>#SUBSCRIPTION_NO#</td>
							<td>#SUBSCRIPTION_TYPE#</td>
							<td><cfif len(subs_add_option_list)>#GET_SUBS_ADD_OPTION.SUBSCRIPTION_ADD_OPTION_NAME[listfind(subs_add_option_list,SUBSCRIPTION_ADD_OPTION_ID,',')]#</cfif></td>
							<td><cfif len(s_stage_id_list)>#GET_STAGE_TYPES.STAGE[listfind(s_stage_id_list,SUBSCRIPTION_STAGE,',')]#</cfif></td>
							<td>#dateformat(START_DATE,dateformat_style)#</td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="6"><cf_get_lang dictionary_id="57484.Kayıt Yok">!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
	</div>
	<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<cfif isdefined("form.graph_type") and len(form.graph_type)>
				<cfset graph_type = form.graph_type>
			<cfelse>
				<cfset graph_type = "pie">
			</cfif>
			<cfif len(GET_SC_CONTRACTS.SUBS_TOTAL)>
					<cfsavecontent variable="message"><cf_get_lang no ='1179.Toplam Sistem'></cfsavecontent>
					<cfset  item1 = "#message#">
					<cfset 	value1 = "#GET_SC_CONTRACT_TOTAL.SC_CONTRACT_TOTAL#">
					<cfsavecontent variable="message"><cf_get_lang_main no='1420.Abone'></cfsavecontent>
					<cfset  item2 = "#message#">
					<cfset 	value2 = "#GET_SC_CONTRACTS.SUBS_TOTAL#">
				<script src="JS/Chart.min.js"></script> 
				<canvas id="myChart14" style="float:left;max-width:320px;max-height:320px;"></canvas>
				<script>
					var ctx = document.getElementById('myChart14');
						var myChart14 = new Chart(ctx, {
							type: '<cfoutput>#graph_type#</cfoutput>',
							data: {
								labels: ["<cfoutput>#item1#</cfoutput>","<cfoutput>#item2#</cfoutput>"],
								datasets: [{
									label: "Sistemler / Abonelikler",
									backgroundColor: ['rgb(255, 99, 132)','rgba(255, 99, 132, 0.2)'],
									data: [<cfoutput>#value1#,#value2#</cfoutput>],
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
