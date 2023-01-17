<cfquery name="GET_MY_FIN_RATE_WORKS" datasource="#DSN#" maxrows="6">
	SELECT 
		COUNT(PW.WORK_ID) WORK_COUNT, 
		PW.TO_COMPLETE AS COMP_RATE
	FROM 
		PRO_WORKS PW 
	WHERE
		PW.WORK_STATUS = 1
		<cfif isdefined('attributes.type') and attributes.type eq 1>		
			AND PW.PROJECT_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
		</cfif>
	GROUP BY
		PW.TO_COMPLETE
	ORDER BY
		WORK_COUNT DESC
</cfquery>

<div class="col col-12 col-xs-12 txtbold" style="margin-top:2%;"></div>
		<cfoutput query="get_my_fin_rate_works">
			<cfset 'item_#currentrow#' = "#get_my_fin_rate_works.comp_rate#">
			<cfset 'value_#currentrow#' = "#get_my_fin_rate_works.work_count#">
		</cfoutput>
		<!---
		<cfif attributes.type eq 1>
		<canvas id="myChart4" style="max-width:300px;max-height:300px;"></canvas>
			<script>
				var ctx = document.getElementById('myChart4');
				var myChart4 = new Chart(ctx, {
					type: 'doughnut',
					data: {
							labels: [<cfloop from="1" to="#get_my_fin_rate_works.recordcount#" index="jj">
								<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
							datasets: [{
							label: "Bitirme Oranlarına Göre İşlerim",
							backgroundColor: [<cfloop from="1" to="#get_my_fin_rate_works.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
							data: [<cfloop from="1" to="#get_my_fin_rate_works.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
								}]
							},
					options: {}
				});
			</script>
		</cfif>
		<cfif attributes.type eq 2>
			<canvas id="myChart41" style="max-width:300px;max-height:300px;"></canvas>
				<script>
					var ctx = document.getElementById('myChart41');
					var myChart41 = new Chart(ctx, {
						type: 'doughnut',
						data: {
								labels: [<cfloop from="1" to="#get_my_fin_rate_works.recordcount#" index="jj">
									<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
								datasets: [{
								label: "Bitirme Oranlarına Göre İşlerim",
								backgroundColor: [<cfloop from="1" to="#get_my_fin_rate_works.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
								data: [<cfloop from="1" to="#get_my_fin_rate_works.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
									}]
								},
						options: {}
					});
				</script>
			</cfif> --->

	<div class="col col-12 col-xs-12">

		<cfoutput query="get_my_fin_rate_works">
			<cfset 'item_#currentrow#' = "#get_my_fin_rate_works.comp_rate#">
			<cfset 'value_#currentrow#' = "#get_my_fin_rate_works.work_count#">
		</cfoutput>
		<cfif attributes.type eq 1>
		<canvas id="myChart5"></canvas>
			<script>
				var ctx = document.getElementById('myChart5');
				var myChart5 = new Chart(ctx, {
					type: 'bar',
					data: {
							labels: [<cfloop from="1" to="#get_my_fin_rate_works.recordcount#" index="jj">
								<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
							datasets: [{
							label: "<cfoutput>#getLang('assetcare',392)#</cfoutput>",
							backgroundColor: [<cfloop from="1" to="#get_my_fin_rate_works.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
							data: [<cfloop from="1" to="#get_my_fin_rate_works.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
								}]
							},
					options: {}
				});
			</script> 
		</cfif>
		<cfif attributes.type eq 2>
			<canvas id="myChart51"></canvas>
				<script>
					var ctx = document.getElementById('myChart51');
					var myChart51 = new Chart(ctx, {
						type: 'bar',
						data: {
								labels: [<cfloop from="1" to="#get_my_fin_rate_works.recordcount#" index="jj">
									<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
								datasets: [{
								label: "<cfoutput>#getLang('assetcare',392)#</cfoutput>",
								backgroundColor: [<cfloop from="1" to="#get_my_fin_rate_works.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
								data: [<cfloop from="1" to="#get_my_fin_rate_works.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
									}]
								},
						options: {}
					});
				</script> 
			</cfif>
	</div>

