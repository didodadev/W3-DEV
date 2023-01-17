<cfquery name="GET_MY_WORKS" datasource="#DSN#">
	SELECT 
		COUNT(PW.WORK_ID) WORK_COUNT,
		PWC.WORK_CAT  WORK_CAT
	FROM 
		PRO_WORKS PW,
		PRO_WORK_CAT PWC
	WHERE 
		PW.WORK_STATUS = 1 AND
		PW.TARGET_FINISH < #now()# AND
		PW.WORK_CAT_ID = PWC.WORK_CAT_ID
		<cfif isdefined('attributes.type') and attributes.type eq 1>	
			AND PW.PROJECT_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> 
		</cfif>
	GROUP BY
		PWC.WORK_CAT	
</cfquery>
<div class="col col-12 col-xs-12 txtbold" style="margin-top:2%;"></div>
	<div class="col col-12 col-xs-12">

				<cfoutput query="get_my_works">
					<cfset 'item_#currentrow#' = "#get_my_works.work_cat#">
					<cfset 'value_#currentrow#' = "#get_my_works.work_count#">
				</cfoutput>
			<cfif attributes.type eq 1>
			<canvas id="myChart7"></canvas>
			<script>
				var ctx = document.getElementById('myChart7');
				var myChart7 = new Chart(ctx, {
					type: 'bar',
					data: {
							labels: [<cfloop from="1" to="#get_my_works.recordcount#" index="jj">
								<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
							datasets: [{
							label: "<cfoutput><cf_get_lang dictionary_id='48292.Termini Geçmiş İş Sayısı'></cfoutput>",
							backgroundColor: [<cfloop from="1" to="#get_my_works.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
							data: [<cfloop from="1" to="#get_my_works.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
								}]
							},
					options: {}
				});
			</script> 
			</cfif> 
			<cfif attributes.type eq 2>
				<canvas id="myChart71"></canvas>
				<script>
					var ctx = document.getElementById('myChart71');
					var myChart71 = new Chart(ctx, {
						type: 'bar',
						data: {
								labels: [<cfloop from="1" to="#get_my_works.recordcount#" index="jj">
									<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
								datasets: [{
								label: "<cfoutput><cf_get_lang dictionary_id='48292.Termini Geçmiş İş Sayısı'></cfoutput>",
								backgroundColor: [<cfloop from="1" to="#get_my_works.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
								data: [<cfloop from="1" to="#get_my_works.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
									}]
								},
						options: {}
					});
				</script> 
				</cfif> 
	</div>

