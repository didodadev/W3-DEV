<cfquery name="GET_MY_WORKS" datasource="#DSN#">
	SELECT 
		PW.WORK_ID,
		PW.WORK_CURRENCY_ID 
	FROM 
		PRO_WORKS PW
	WHERE  
		PW.PROJECT_EMP_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> <!---AND 
		PW.WORK_STATUS = 1	--->
</cfquery>
<cfset works_list = ''>
<cfloop query="get_my_works">
	<cfif len(work_currency_id) and not listfind(works_list,work_currency_id)>
		<cfset works_list = Listappend(works_list,work_currency_id)>
	</cfif>
</cfloop>
<cfif len(works_list)>
	<cfquery name="GET_MY_STAGE_WORKS" datasource="#DSN#">
		SELECT 
			COUNT(PW.WORK_ID) WORK_COUNT, 
			PTR.STAGE AS STAGE
		FROM 
			PROCESS_TYPE_ROWS PTR,
			PRO_WORKS PW 
		WHERE
			PW.WORK_CURRENCY_ID = PTR.PROCESS_ROW_ID AND
			PW.PROJECT_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
			PTR.PROCESS_ROW_ID IN (#works_list#)
		GROUP BY
			PTR.STAGE		
	</cfquery>
<cfelse>
	<cfset GET_MY_STAGE_WORKS.recordcount = 0>
</cfif>
<div class="col col-12 col-xs-12 txtbold" style="margin-top:2%;"></div>
	<div class="col col-12 col-xs-12">
		<cfif GET_MY_STAGE_WORKS.recordcount>
			<cfoutput query="get_my_stage_works">
				<cfset 'item_#currentrow#' = "#get_my_stage_works.stage#">
				<cfset 'value_#currentrow#' = "#get_my_stage_works.work_count#">
			</cfoutput>
		</cfif>
		<canvas id="myChart2"></canvas>
			<script>
				var ctx = document.getElementById('myChart2');
				var myChart2 = new Chart(ctx, {
					type: 'bar',
					data: {
							labels: [<cfloop from="1" to="#get_my_stage_works.recordcount#" index="jj">
								<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
							datasets: [{
							label: "<cfoutput>#getLang('assetcare',387)#</cfoutput>",
							backgroundColor: [<cfloop from="1" to="#get_my_stage_works.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
							data: [<cfloop from="1" to="#get_my_stage_works.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
								}]
							},
					options: {}
				});
			</script> 
			
	</div><!---
	<div class="col col-6 col-xs-12">
			<cfoutput query="get_my_stage_works">
				<cfset 'item_#currentrow#' = "#get_my_stage_works.stage#">
				<cfset 'value_#currentrow#' = "#get_my_stage_works.work_count#">
			</cfoutput>
		<canvas id="myChart3" style="max-height:300px;max-width:300px;"></canvas>
			<script>
				var ctx = document.getElementById('myChart3');
				var myChart3 = new Chart(ctx, {
					type: 'doughnut',
					data: {
							labels: [<cfloop from="1" to="#get_my_stage_works.recordcount#" index="jj">
								<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
							datasets: [{
							label: "Aşamalara Göre İşlerim",
							backgroundColor: [<cfloop from="1" to="#get_my_stage_works.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
							data: [<cfloop from="1" to="#get_my_stage_works.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
								}]
							},
					options: {}
				});
			</script> 
	</div>--->
