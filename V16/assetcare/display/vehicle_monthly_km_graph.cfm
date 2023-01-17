<!---BU SAYFA HEM BASKET, HEM POPUP SAYFA OLARAK KULLANILDIĞI İÇİN BASKETE GÖRE DÜZENLENMİŞTİR.--->
<script src="JS/Chart.min.js"></script>

<cfsetting showdebugoutput="no">
<cfparam name="attributes.graph_type" default="">
<cf_flat_list>
		<thead>
			<cfform action="#request.self#?fuseaction=assetcare.popup_vehicle_monthly_km_graph" method="post" name="form_usage_purpose">
				<tr>
					<th><cfoutput><cf_get_lang no='382.Aylara Göre KM Dağılımı'> (#dateformat(now(),dateformat_style)# #timeformat(now(),timeformat_style)#)</cfoutput>
					</th>
					
				</tr>
			</cfform>
		</thead>
		<tbody>
	<tr>
		<td>
			<cfif isDefined("attributes.graph_type") and len(attributes.graph_type)>
				<cfset graph_type = attributes.graph_type>
			<cfelse>
				<cfset graph_type = "pie">
			</cfif>	
			<cfquery name="get_monthly_km" datasource="#dsn#" maxrows="12">
				SELECT
					SUM(KM_FINISH - KM_START) AS KM,
					<cfif database_type is 'MSSQL'>
						DATEPART(yy,ASSET_P_KM_CONTROL.FINISH_DATE) AS YIL,
						DATEPART(mm,ASSET_P_KM_CONTROL.FINISH_DATE) AS AY_ID
					<cfelseif database_type is 'DB2'>
						YEAR(ASSET_P_KM_CONTROL.FINISH_DATE) AS YIL,
						MONTH(ASSET_P_KM_CONTROL.FINISH_DATE) AS AY_ID
					</cfif>
				FROM
					ASSET_P_KM_CONTROL
				WHERE 
					FINISH_DATE <  #now()#
				GROUP BY
					<cfif database_type is 'MSSQL'>
						DATEPART(yy,FINISH_DATE),
						DATEPART(mm,FINISH_DATE)
					<cfelseif database_type is 'DB2'>
						YEAR(FINISH_DATE),
						MONTH(FINISH_DATE)
					</cfif>
				ORDER BY
					YIL DESC,
					AY_ID DESC
			</cfquery>


			<cfoutput query="get_monthly_km">
			<cfset value = #km#>
			<cfset item = #ay_id#>
			<cfset 'item_#currentrow#'="#value#">
			<cfset 'value_#currentrow#'="#item#"> 
			</cfoutput>
			
				<canvas id="myChart" style="float:left;max-height:450px;max-width:450px;"></canvas>
				<script>
					var ctx = document.getElementById('myChart');
						var myChart = new Chart(ctx, {
							type: 'line',
							data: {
								labels: [<cfloop from="1" to="#get_monthly_km.recordcount#" index="jj">
												 <cfoutput>#evaluate("value_#jj#")#</cfoutput>,</cfloop>],
								datasets: [{
									label: '#getLang('finance',298)#',
									backgroundColor: [<cfloop from="1" to="#get_monthly_km.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
									data: [<cfloop from="1" to="#get_monthly_km.recordcount#" index="jj"><cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
								}]
							},
							options: {
										legend: {
											display: false
										}
									}
					});
				</script>		
		</td>
	</tr>
</tbody>
</cf_flat_list>

