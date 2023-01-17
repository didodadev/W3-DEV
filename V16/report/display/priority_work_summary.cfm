<cfquery name="GET_MY_WORKS" datasource="#DSN#">
	SELECT 
		COUNT(PW.WORK_ID) WORK_COUNT,
		SP.PRIORITY  PRIORITY
	FROM 
		PRO_WORKS PW,
		SETUP_PRIORITY SP
	WHERE 
		PW.WORK_PRIORITY_ID = SP.PRIORITY_ID AND
		PW.WORK_STATUS = 1 AND
		PW.PROJECT_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> 
	GROUP BY
		SP.PRIORITY
</cfquery>

<div class="col col-12 col-xs-12 txtbold" style="margin-top:2%;"></div>
	<div class="col col-12 col-xs-12">
				<cfoutput query="get_my_works">
					<cfset 'item_#currentrow#'="#get_my_works.priority#">
					<cfset 'value_#currentrow#'="#get_my_works.work_count#">
				</cfoutput>

			<canvas id="myChart8"></canvas>
			<script>
				var ctx = document.getElementById('myChart8');
				var myChart8 = new Chart(ctx, {
					type: 'bar',
					data: {
							labels: [<cfloop from="1" to="#get_my_works.recordcount#" index="jj">
								<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
							datasets: [{
							label: "<cfoutput><cf_get_lang dictionary_id='48293.Öncekilere Göre İşlem'></cfoutput>",
							backgroundColor: [<cfloop from="1" to="#get_my_works.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
							data: [<cfloop from="1" to="#get_my_works.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
								}]
							},
					options: {}
				});
			</script> 
	</div>
