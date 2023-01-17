<cfsetting showdebugoutput="no">
<cfset month_list=''>
<cfset tarih_farki = (attributes.plan_month2-attributes.plan_month1)>
<cfloop from="#attributes.plan_month1#" to="#attributes.plan_month1+tarih_farki#" index="i">
	<cfset month_list=listappend(month_list,i)>
</cfloop>
<cfset new_dsn2 = '#dsn#_#attributes.plan_year#_#session.ep.company_id#'>
<cfinclude template="../query/get_sales_quota_analyse.cfm">
<cfquery name="get_total_quota" dbtype="query">
	SELECT SUM(NET_TOTAL) NET_TOTAL,SUM(ROW_TOTAL) ROW_TOTAL  FROM get_all_quotas 
</cfquery>
<td valign="top">
			<cfloop list="#month_list#" index="ay_indx">
				<cfquery name="get_quota" dbtype="query">
					SELECT * FROM get_all_quotas WHERE MONTH_VALUE = #ay_indx# 
				</cfquery>
				<cfset item="#listgetat(ay_list(),ay_indx,',')#">
				<cfset value="#NumberFormat(get_quota.row_total,'00.00')#">
			</cfloop>
		
			<cfloop list="#month_list#" index="ay_indx">
				<cfquery name="get_quota" dbtype="query">
					SELECT * FROM get_all_quotas WHERE MONTH_VALUE = #ay_indx# 
				</cfquery>
				<cfset item="#listgetat(ay_list(),ay_indx,',')#">
				<cfset value="#NumberFormat(get_quota.net_total,'00.00')#">
			</cfloop>

				<canvas id="myChart5" style="max-height:400px;max-width:400px;"></canvas>
					<script>
						var ctx = document.getElementById('myChart5');
						var myChart5 = new Chart(ctx, {
							type: '<cfoutput>#attributes.graph_type#</cfoutput>',
							data: {
									labels: [<cfloop list="#month_list#" index="ay_indx">
															<cfoutput>"#listgetat(ay_list(),ay_indx,',')#"</cfoutput>,</cfloop>"Toplam"],
									datasets: [{
												label: "Planlanan",
												backgroundColor: [<cfloop list="#month_list#" index="ay_indx">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>'rgb(255, 99, 132)'],
												data: [<cfloop list="#month_list#" index="ay_indx"><cfoutput>#NumberFormat(get_quota.row_total,'00')#</cfoutput>,</cfloop><cfoutput>#NumberFormat(get_total_quota.row_total,'00.00')#</cfoutput>],
											},
											{
												label: "Gerçekleşen",
												backgroundColor: [<cfloop list="#month_list#" index="ay_indx">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>'rgba(255, 99, 132, 0.2)'],
												data: [<cfloop list="#month_list#" index="ay_indx"><cfoutput>#NumberFormat(get_quota.net_total,'00')#</cfoutput>,</cfloop><cfoutput>#NumberFormat(get_total_quota.net_total,'00.00')#</cfoutput>],
											}
											]
										},
							options: {}
							});
					</script> 
</td>

