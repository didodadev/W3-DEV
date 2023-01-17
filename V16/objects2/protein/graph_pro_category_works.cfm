<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.4.0/Chart.min.js"></script>
<script type="text/javascript" src="jscript/graph.js"></script> 
<cfset getComponent = createObject('component','V16.project.cfc.projectData')>
<cfif isdefined("param_2") and param_2 eq 'wid'>
    <cfset getComponent_Work = createObject('component','V16.project.cfc.get_work')>
    <cfset get_works = getComponent_Work.DET_WORK(work_id:url.id,work_status:1
    )>
    <cfset attributes.id = get_works.project_id>
</cfif>
<cfset get_work = getComponent.get_work_cat(id : attributes.id)>

<div class="row">
	<div class="col col-12 col-xs-12">
		<cfoutput query="get_work">
			<cfset 'item_#currentrow#' = "#get_work.WORK_CAT#">
			<cfset 'value_#currentrow#' = "#get_work.COUNT_WORK#">
		</cfoutput>
		<!--- <script src="JS/Chart.min.js"></script> --->
		<canvas id="myChart" height="250"></canvas>
		<script>
			var ctx = document.getElementById('myChart');
			var myChart = new Chart(ctx, {
				type: 'doughnut',
				data: {
						labels: [<cfloop from="1" to="#get_work.recordcount#" index="jj">
								<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
						datasets: [{
						label: "<cfoutput>#getLang('call',87)#</cfoutput>",
						backgroundColor: [<cfloop from="1" to="#get_work.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
						data: [<cfloop from="1" to="#get_work.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
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
</div>