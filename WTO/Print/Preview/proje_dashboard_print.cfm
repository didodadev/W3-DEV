<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.4.0/Chart.min.js"></script>
<script type="text/javascript" src="jscript/graph.js"></script> 
<cfif isNumeric(attributes.action_id)>
    <cfset attributes.project_id = attributes.action_id>
  <cfelse>
    <cfset attributes.project_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.action_id,accountKey:'wrk')>
</cfif>
<cfset get_component_ = createObject("component", "V16.myhome.cfc.time_cost")>
<cfset getComponent = createObject('component','V16.project.cfc.projectData')>
<cfset get_component__ = createObject("component","V16.hr.cfc.project_allowance") />
<cfset get_component = createObject("component","V16.report.standart.cfc.project_accounts_graph_report") />
<cfset project_detail = getComponent.PROJECT_DETAIL(id : attributes.project_id)>
<cfset project_works = getComponent.project_time_cost(project_id : attributes.project_id,start_date:project_detail.target_start,finish_date:project_detail.target_finish)>
<cfset  works_detail = getComponent.project_time_cost(is_emp:0,project_id : attributes.project_id,start_date:project_detail.target_start,finish_date:project_detail.target_finish)>
<cfset get_project_actions = get_component__.get_project_actions(project_id: attributes.project_id)>
<cfset get_invoice = get_component__.get_income_expense(
    project_id: attributes.project_id, 
    start_date: project_detail.target_start, 
	finish_date: project_detail.target_finish,
	is_type : 0
)>

<cfset workTotal=0>
<cfset workActTotal=0>
<cfset workPasTotal=0>
<cfset personhourestTotal=0>
<cfset personhourexpTotal=0>
<cfset expensedMoneyTotal=0>
<cfset expectedBudgetTotal=0>
<cfset expenseTotal=0>
<cfset total_=0>

<cfif not project_detail.recordcount>
    <cfset hata=10>
    <cfsavecontent variable="message"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'>!</cfsavecontent>
    <cfset hata_mesaj  = message>
    <cfinclude template="../../dsp_hata.cfm">
<cfelse>
	<cfoutput query="project_works">
		<cfset workCount = get_component.get_works(project_id: attributes.project_id,emp_id:employee_id)>
		<cfset worksAct_count = get_component.get_works(project_id: attributes.project_id,emp_id:employee_id,active_passive:"1")>
		<cfset worksPas_count = get_component.get_works(project_id: attributes.project_id,emp_id:employee_id,active_passive:"0")>
		<cfset Workactive = listlen(valuelist(worksAct_count.WORK_COUNT))>
		<cfset Workpassive = listlen(valuelist(worksPas_count.WORK_COUNT))>
		<cfset Work = listlen(valuelist(workCount.WORK_COUNT))>

		<cfset person_hour_est = len(estimated_time) ? estimated_time/60 : 0>
		<cfset person_hour_exp = len(expensed_minute) ? expensed_minute/60 : 0>
		<cfset expense = person_hour_exp * expensed_money>
		<cfset total = (expected_budget gt 0) ? (( expected_budget* 100)/expense) : 0>

		<cfset workTotal += Work>
		<cfset workActTotal += Workactive>
		<cfset workPasTotal += Workpassive>
		<cfset personhourestTotal += person_hour_est>
		<cfset personhourexpTotal += person_hour_exp>
		<cfset expensedMoneyTotal += expensed_money>
		<cfset expectedBudgetTotal += expected_budget>
		<cfset expenseTotal += expense>
		<cfset total_ += total>
	</cfoutput>
	<cfset hesaplama = (personhourexpTotal* 100)/personhourestTotal>
	<cfset hesaplama_ = (get_invoice.PRICE* 100)/get_project_actions.value>
	<cfset week=abs(datediff("ww",project_detail.target_start,project_detail.target_finish)+1)>
	<cf_woc_header title="Proje Faaliyet Özeti: #project_detail.PROJECT_NUMBER#">
	<cf_woc_elements>
		<cfif len(project_detail.company_id)>
			<cf_wuxi id="customer_id" data="#project_detail.fullname#" label="57457" type="cell">
			<cf_wuxi id="authorized_id" data="#project_detail.company_partner#" label="57578" type="cell">
			<cf_wuxi id="project_manager_id" data="#project_detail.company_partner#" label="63760" type="cell">
		<cfelseif len(project_detail.consumer_id)>
			<cf_wuxi id="custome_id" data="#project_detail.consumer#" label="57457" type="cell">
			<cf_wuxi id="authorized_id" data="#project_detail.consumer#" label="57578" type="cell">
			<cf_wuxi id="project_manager_id" data="#project_detail.consumer#" label="63760" type="cell">
		<cfelse>
			<cf_wuxi id="customer_id" data="" label="57457" type="text">
			<cf_wuxi id="authorized_id" data="" label="57578" type="text">
			<cf_wuxi id="project_manager_id" data="" label="63760" type="text">
			</cfif>
			<cf_wuxi id="project_id" data="#get_project_name(project_id:attributes.project_id,project_no:0)#" label="57416" type="cell">
		<cf_wuxi id="project_leader_id" data="#get_emp_info(project_detail.PROJECT_EMP_ID,0,0)#" label="33285" type="cell">
		<cf_wuxi id="date_id" data="#Dateformat(project_detail.target_start,'dd.mm.yyyy')# - #Dateformat(project_detail.target_finish,'dd.mm.yyyy')# / #week# #getLang('','',58734)#" label="30913" type="cell">
	</cf_woc_elements>
	<cf_woc_header title="Görünüm">
	<cf_woc_elements>
		<div class="col col-3 col-xs-12" align="center">					
			<cfset worksAct_count = get_component.get_works(project_id: attributes.project_id,active_passive:"1")>
			<cfset worksPas_count = get_component.get_works(project_id: attributes.project_id,active_passive:"0")>
			<cfset active = listlen(valuelist(worksAct_count.WORK_COUNT))>
			<cfset passive = listlen(valuelist(worksPas_count.WORK_COUNT))>
			<canvas id="myChart9" style="height:100%;"></canvas>
			<script>
				var ctx = document.getElementById('myChart9');
				var myChart9 = new Chart(ctx, {
					type: 'pie',
					data: {
							labels: ["<cf_get_lang dictionary_id ='57493.Aktif'>","<cf_get_lang dictionary_id ='57494.Pasif'>"],
							datasets: [{
							label: "<cfoutput>#getLang('call',87)#</cfoutput>",
							backgroundColor: [<cfloop from="1" to="2" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
							data: [<cfoutput>#active#,#passive#</cfoutput>],
								}]
							},
					options: {
						legend: {
							display: false
						}
					}
				});
			</script>	
			<p><cf_get_lang dictionary_id ='58515.Aktif/Pasif'> <cf_get_lang dictionary_id ='58020.İşler'></p>							
		</div>
		<div class="col col-3 col-xs-12" align="center">					
				<cfset workCat_count = get_component.get_works(project_id: attributes.project_id,cat_works:"1")>
				<cfloop query="workCat_count">
					<cfset 'item_#currentrow#' = "#WORK_CAT#">
					<cfset 'value_#currentrow#' = "#WORK_COUNT#">
				</cfloop>
				<canvas id="myChart7" style="height:100%;"></canvas>
				<script>
					var ctx = document.getElementById('myChart7');
					var myChart7 = new Chart(ctx, {
						type: 'pie',
						data: {
								labels: [<cfloop from="1" to="#workCat_count.recordcount#" index="jj">
										<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
								datasets: [{
								label: "<cfoutput>#getLang('call',87)#</cfoutput>",
								backgroundColor: [<cfloop from="1" to="#workCat_count.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
								data: [<cfloop from="1" to="#workCat_count.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
									}]
								},
						options: {
							legend: {
								display: false
							}
						}
					});
				</script>
				<p><cf_get_lang dictionary_id ='40177.Kategorilere'> <cf_get_lang dictionary_id ='58020.İşler'></p>
		</div>
		<div class="col col-3 col-xs-12" align="center">
			<cfset worksStage_count = get_component.get_works(project_id: attributes.project_id,stage_works:"1")>
			<cfloop query="worksStage_count">
				<cfset 'item_#currentrow#' = "#STAGE#">
				<cfset 'value_#currentrow#' = "#WORK_COUNT#">
			</cfloop>
			<canvas id="myChart8" style="height:100%;"></canvas>
			<script>
				var ctx = document.getElementById('myChart8');
				var myChart8 = new Chart(ctx, {
					type: 'pie',
					data: {
							labels: [<cfloop from="1" to="#worksStage_count.recordcount#" index="jj">
									<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
							datasets: [{
							label: "<cfoutput>#getLang('call',87)#</cfoutput>",
							backgroundColor: [<cfloop from="1" to="#worksStage_count.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
							data: [<cfloop from="1" to="#worksStage_count.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
								}]
							},
					options: {
						legend: {
							display: false
						}
					}
				});
			</script>
			<p><cf_get_lang dictionary_id ='40176.Aşamalara Göre'> <cf_get_lang dictionary_id ='58020.İşler'></p>
		</div> 
		<div class="col col-3 col-xs-12" align="center">
			<cf_wuxi id="1_id" label="63917" type="cell">			
			<cf_wuxi id="4_id" data="#wrk_round(hesaplama,2)#" type="progress" style="width: 167%">
			<cf_wuxi id="2_id" data="#tlformat(personhourestTotal)# h" label="38143" type="cell">
			<cf_wuxi id="3_id" data="#tlformat(personhourexpTotal)# h" label="38128" type="cell">

			<cf_wuxi id="15_id" data="#wrk_round(hesaplama,1)#%" type="cell" style="font-size: 24px;font-family: Roboto">

			<cf_wuxi id="11_id" label="60899" type="cell">			
			<cf_wuxi id="41_id" data="#wrk_round(total_,2)#" type="progress" style="background: ##E0B27C;width: 167%" style_pbar="background: ##FC6A18;">
			<cf_wuxi id="21_id" data="#tlformat(expectedBudgetTotal)# #session.ep.money#" label="38143" type="cell">
			<cf_wuxi id="31_id" data="#tlformat(expenseTotal)# #session.ep.money#" label="38128" type="cell">

			<cf_wuxi id="16_id" data="#wrk_round(total_,1)#%" type="cell" style="font-size: 24px;font-family: Roboto">

			<cf_wuxi id="311_id" data="#TLFORMAT(get_invoice.PRICE)# #session.ep.money#" label="63919" type="cell" border="position: absolute;width: 196.5px;height: 0px;border-top: 2px solid ##d1d1d1">
			<cf_wuxi id="310_id" data="#TLFORMAT(get_project_actions.value)# #get_project_actions.CURRENCY#" label="57845" type="cell">
			<cf_wuxi id="166_id" data="#wrk_round(hesaplama_,1)#%" type="cell" style="font-size: 24px;font-family: Roboto">	
					
		</div>
	</cf_woc_elements>
	<cf_woc_header title="Kişiler Göre İşler ve Zaman Harcamaları">
	<cf_woc_elements>
		<cf_woc_list id="employee">
			<thead>
				<tr>
					<cf_wuxi label="57487" type="cell" is_row="0" id="wuxi_57487"> 
					<cf_wuxi label="57569" type="cell" is_row="0" id="wuxi_57569"> 
					<cf_wuxi label="57492+58445" type="cell" is_row="0" id="wuxi_57492">
					<cf_wuxi label="57493+58445" type="cell" is_row="0" id="wuxi_57493"> 
					<cf_wuxi label="302+58445" type="cell" is_row="0" id="wuxi_302"> 
					<cf_wuxi label="63797" type="cell" is_row="0" id="wuxi_63797"> 
					<cf_wuxi label="63798" type="cell" is_row="0" id="wuxi_63798"> 
					<cf_wuxi label="63799" type="cell" is_row="0" id="wuxi_63799"> 
					<cf_wuxi label="57673+57559" type="cell" is_row="0" id="wuxi_57673">
					<cf_wuxi label="51532" type="cell" is_row="0" id="wuxi_51532">
					<cf_wuxi label="53135" type="cell" is_row="0" id="wuxi_57467">
				</tr>
			</thead>
			<tbody>
				<cfoutput query="project_works">
					<tr>
						<cf_wuxi data="#currentrow#" type="cell" is_row="0"> 
						<cf_wuxi data="#get_emp_info(employee_id,0,0)#" type="cell" is_row="0"> 
						<cf_wuxi data="#Work#" type="cell" is_row="0"> 
						<cf_wuxi data="#Workactive#" type="cell" is_row="0"> 
						<cf_wuxi data="#Workpassive#" type="cell" is_row="0">
						<cf_wuxi data="#tlformat(person_hour_est)#" type="cell" is_row="0"> 
						<cf_wuxi data="#tlformat(person_hour_exp)#" type="cell" is_row="0"> 
						<cf_wuxi data="#tlformat(expensed_money)# #session.ep.money#" type="cell" is_row="0" class="text-right"> 
						<cf_wuxi data="#tlformat(expected_budget)# #session.ep.money#" type="cell" is_row="0" class="text-right">
						<cf_wuxi data="#tlformat(expense)# #session.ep.money#" type="cell" is_row="0" class="text-right">
						<cf_wuxi data="#wrk_round(total,1)# %" type="cell" is_row="0">
					</tr>					
				</cfoutput>
				<tr>
					<cf_wuxi style_th="----" type="cell" is_row="0"> 
					<cf_wuxi data="toplam" type="cell" is_row="0"> 
					<cf_wuxi data="#workTotal#" type="cell" is_row="0">
					<cf_wuxi data="#workActTotal#" type="cell" is_row="0"> 
					<cf_wuxi data="#workPasTotal#" type="cell" is_row="0"> 
					<cf_wuxi data="#tlformat(personhourestTotal)#" type="cell" is_row="0"> 
					<cf_wuxi data="#tlformat(personhourexpTotal)#" type="cell" is_row="0"> 
					<cf_wuxi data="#tlformat(expensedMoneyTotal)# #session.ep.money#" type="cell" is_row="0" class="text-right"> 
					<cf_wuxi data="#tlformat(expectedBudgetTotal)# #session.ep.money#" type="cell" is_row="0" class="text-right">
					<cf_wuxi data="#tlformat(expenseTotal)# #session.ep.money#" type="cell" is_row="0" class="text-right">
					<cf_wuxi data="#wrk_round(total_,1)# %" type="cell" is_row="0">
				</tr>
			</tbody>
		</cf_woc_list>
	</cf_woc_elements>
	<cf_woc_header title="Eforlar ve Açıklamalar">
		<cf_woc_elements>
			<cf_woc_list>
				<tbody>
					<cfoutput query="works_detail">
						<cfset totaltime = expensed_minute mod 60>
						<cfset get_process_stage = get_component_.get_process_stage(
							upd_myweek : "myhome.upd_myweek",
							process_stage : works_detail.time_cost_stage
						)>
						<tr>
							<cf_wuxi data="#currentrow#" type="cell" is_row="0">
							<cf_wuxi data="#comment#" type="cell" is_row="0">
							<cf_wuxi data="#get_process_stage.stage#" type="cell" is_row="0">
							<cf_wuxi data="#((expensed_minute-totaltime)/60)# s:#totaltime# dk" type="cell" is_row="0">
							<cf_wuxi data="#get_emp_info(employee_id,0,0)#" type="cell" is_row="0">
						</tr>
					</cfoutput>
				</tbody>
			</cf_woc_list>
		</cf_woc_elements>
	<cf_woc_footer>
 </cfif>