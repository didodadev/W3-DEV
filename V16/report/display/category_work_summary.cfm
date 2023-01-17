<cfquery name="GET_MY_WORKS" datasource="#DSN#">
	SELECT 
		COUNT(PW.WORK_ID) WORK_COUNT,
		PWC.WORK_CAT  WORK_CAT
	FROM 
		PRO_WORKS PW,
		PRO_WORK_CAT PWC
	WHERE 
		PW.WORK_CAT_ID = PWC.WORK_CAT_ID AND
		PW.PROJECT_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> 
	GROUP BY
		PWC.WORK_CAT		
</cfquery>

<div class="col col-12 col-xs-12 txtbold" style="margin-top:2%;"></div>
<div class="col col-12 col-xs-12">
		<cfoutput query="get_my_works">
			<cfset 'item_#currentrow#' = "#get_my_works.work_cat#">
			<cfset 'value_#currentrow#' = "#get_my_works.work_count#">
		</cfoutput>
		<canvas id="myChart1"></canvas>
			<script>
				var ctx = document.getElementById('myChart1');
				var myChart1 = new Chart(ctx, {
					type: 'bar',
					data: {
							labels: [<cfloop from="1" to="#get_my_works.recordcount#" index="jj">
								<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
							datasets: [{
							label: "<cfoutput>#getLang('assetcare',386)#</cfoutput>",
							backgroundColor: [<cfloop from="1" to="#get_my_works.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
							data: [<cfloop from="1" to="#get_my_works.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
								}]
							},
					options: {}
				});
			</script> 
</div>
