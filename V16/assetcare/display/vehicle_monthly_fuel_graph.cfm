<!---BU SAYFA HEM BASKET, HEM POPUP SAYFA OLARAK KULLANILDIĞI İÇİN BASKETE GÖRE DÜZENLENMİŞTİR.--->
<cfparam name="attributes.graph_type" default="">
<cf_flat_list>
	<thead>
		<cfform action="#request.self#?fuseaction=assetcare.popup_vehicle_monthly_fuel_graph" method="post" name="form_usage_purpose">
			<tr>
				<th><cfoutput><cf_get_lang no='383.Aylara Göre Yakıt Dağılımı'> (#dateformat(now(),dateformat_style)# #timeformat(now(),timeformat_style)#)</cfoutput></th>
			</tr>
		</cfform>
	</thead>
	<tbody>
		<tr>
		<td bgcolor="#FFFFFF">
			<cfif isDefined("attributes.graph_type") and len(attributes.graph_type)>
				<cfset graph_type = attributes.graph_type>
			<cfelse>
				<cfset graph_type = "line">
			</cfif>
			<cfquery name="get_monthly_fuel" datasource="#dsn#" maxrows="12">
				SELECT
					SUM(FUEL_AMOUNT) AS YAKIT,
					<cfif database_type is 'MSSQL'>
						DATEPART(yy,ASSET_P_FUEL.FUEL_DATE) AS YIL,
						DATEPART(mm,ASSET_P_FUEL.FUEL_DATE) AS AY_ID
					<cfelseif database_type is 'DB2'>
						YEAR(ASSET_P_FUEL.FUEL_DATE) AS YIL,
						MONTH(ASSET_P_FUEL.FUEL_DATE) AS AY_ID
					</cfif>
				FROM
					ASSET_P_FUEL
				WHERE 
					FUEL_DATE < #now()#
				GROUP BY
					<cfif database_type is 'MSSQL'>
						DATEPART(yy,FUEL_DATE),
						DATEPART(mm,FUEL_DATE)
					<cfelseif database_type is 'DB2'>
						YEAR(FUEL_DATE),
						MONTH(FUEL_DATE)
					</cfif>
				ORDER BY
					YIL DESC,
					AY_ID DESC
			</cfquery>
		
  			<cfoutput query="get_monthly_fuel">
			<cfset value = #yakit#>
			<cfset item = #ay_id#>
			<cfset 'item_#currentrow#'="#value#">
			<cfset 'value_#currentrow#'="#item#"> 
			</cfoutput>
			<script src="JS/Chart.min.js"></script>
				<canvas id="myChart" style="float:left;max-height:350px;max-width:350px;"></canvas>
				<script>
					var ctx = document.getElementById('myChart');
						var myChart = new Chart(ctx, {
							type: '<cfoutput>#graph_type#</cfoutput>',
							data: {
								labels: [<cfloop from="1" to="#get_monthly_fuel.recordcount#" index="jj">
												 <cfoutput>#evaluate("value_#jj#")#</cfoutput>,</cfloop>],
								datasets: [{
									label: '#getLang('finance',297)#',
									backgroundColor: [<cfloop from="1" to="#get_monthly_fuel.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
									data: [<cfloop from="1" to="#get_monthly_fuel.recordcount#" index="jj"><cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
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
  
