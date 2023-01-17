<cfquery name="GET_MY_WORKS" datasource="#DSN#" maxrows="6">
	SELECT 
		COUNT(PW.WORK_ID) WORK_COUNT,
		E.EMPLOYEE_ID,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
	FROM 
		PRO_WORKS PW,
		EMPLOYEES E
	WHERE 
		PW.PROJECT_EMP_ID = E.EMPLOYEE_ID AND
		E.EMPLOYEE_STATUS = 1 AND
		PW.WORK_STATUS = 1
	GROUP BY
		E.EMPLOYEE_ID,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
	ORDER BY
		WORK_COUNT DESC
</cfquery>

<div class="col col-12 col-xs-12 txtbold" style="margin-top:2%;"></div>	

	<div class="col col-12 col-xs-12">
			<cfoutput query="get_my_works">
				<cfset 'item_#currentrow#' = "#get_my_works.employee_name# #get_my_works.employee_surname#">
				<cfset 'value_#currentrow#' = "#get_my_works.work_count#">
			</cfoutput>
			<canvas id="myChart11"></canvas>
			<script>
				var ctx = document.getElementById('myChart11');
				var myChart11 = new Chart(ctx, {
					type: 'bar',
					data: {
							labels: [<cfloop from="1" to="#get_my_works.recordcount#" index="jj">
								<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
							datasets: [{
							label: "<cfoutput><cf_get_lang dictionary_id='48298.Kişilere Göre Toplam Görev Sayısı'></cfoutput>",
							backgroundColor: [<cfloop from="1" to="#get_my_works.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
							data: [<cfloop from="1" to="#get_my_works.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
								}]
							},
					options: {}
				});
			</script>  
	</div>
		<!---
			<cfoutput query="get_my_works">
				<cfset 'item_#currentrow#' = "#get_my_works.employee_name# #get_my_works.employee_surname#">
				<cfset 'value_#currentrow#' = "#get_my_works.work_count#">
			</cfoutput>
		<canvas id="myChart12" style="max-width:400px;max-height:400px;"></canvas>
			<script>
				var ctx = document.getElementById('myChart12');
				var myChart12 = new Chart(ctx, {
					type: 'doughnut',
					data: {
							labels: [<cfloop from="1" to="#get_my_works.recordcount#" index="jj">
								<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
							datasets: [{
							label: "Kişilere Göre Toplam İş Sayısı",
							backgroundColor: [<cfloop from="1" to="#get_my_works.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
							data: [<cfloop from="1" to="#get_my_works.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
								}]
							},
					options: {}
				});
			</script>  
			---->

