<!---<cfinclude template="../query/get_consumer_cat.cfm">--->
<cfsetting showdebugoutput="no">
<cfform action="" method="post" name="form_stock">	
	<div>
	<!--- <cf_ajax_list>
		<thead>
            <tr>
                <th style="text-align:right;"> 
                    <select name="graph_type" id="graph_type" style="width:100px;">
                        <option value="pie" <cfif isdefined("attributes.graph_type") and attributes.graph_type is 'pie'>selected</cfif>><cf_get_lang dictionary_id='58728.Pasta'></option>
                        <option value="line" <cfif isdefined("attributes.graph_type") and attributes.graph_type is 'line'>selected</cfif>><cf_get_lang dictionary_id='57665.Eğri'></option>
                        <option value="bar" <cfif isdefined("attributes.graph_type") and attributes.graph_type is 'bar'>selected</cfif>><cf_get_lang dictionary_id='57663.Bar'></option>
                    </select>
                </th>
				<th tyle="text-align:right;"><cf_wrk_search_button></th>
            </tr>
		</thead>	
		<tbody>
			<tr class="nohover">
				<td colspan="2"> --->
				<!--- 	<cfif isDefined("form.graph_type") and len(form.graph_type)>
						<cfset graph_type = '#form.graph_type#'>
					<cfelse>
						<cfset graph_type = "pie">
					</cfif> --->
					
					<cfquery name="GET_CONSUMER_COUNT" datasource="#DSN#">
						SELECT 
							1 AS TYPE,
							COUNT(CON.CONSUMER_CAT_ID) COUNT_,
							GMC.CONSCAT
						FROM 
							CONSUMER CON
							LEFT JOIN GET_MY_CONSUMERCAT GMC ON CON.CONSUMER_CAT_ID = GMC.CONSCAT_ID AND GMC.EMPLOYEE_ID = #session.ep.userid# AND GMC.OUR_COMPANY_ID = 1
						GROUP BY 
							CON.CONSUMER_CAT_ID,
							GMC.CONSCAT
						HAVING
							COUNT(CON.CONSUMER_CAT_ID) >= (SELECT TOP 1 COUNT(CONSUMER_CAT_ID) FROM CONSUMER GROUP BY CONSUMER_CAT_ID ORDER BY COUNT(CONSUMER_CAT_ID) DESC) * 0.05
						
					UNION ALL
						
						SELECT 0 AS TYPE,SUM(COUNT_),'Diğer' COMPANYCAT  FROM 
							(SELECT 
								COUNT(CON.CONSUMER_CAT_ID) COUNT_
							FROM 
								CONSUMER CON
							GROUP BY 
								CON.CONSUMER_CAT_ID
							HAVING
								COUNT(CON.CONSUMER_CAT_ID) < (SELECT TOP 1 COUNT(C.CONSUMER_CAT_ID) FROM CONSUMER C GROUP BY C.CONSUMER_CAT_ID ORDER BY COUNT(C.CONSUMER_CAT_ID) DESC) * 0.05
							)
						T1
					</cfquery>
					<cfif get_consumer_count.recordcount>
						
						<script src="JS/Chart.min.js"></script>
						<canvas id="myChart1" style="width:100%!important;"></canvas>
				<script>
					var ctx = document.getElementById('myChart1');
						var myChart = new Chart(ctx, {
							type: 'pie',
							data: {
								labels: [<cfloop  query="GET_CONSUMER_COUNT"><cfif len(get_consumer_count.CONSCAT) and len(get_consumer_count.count_) >
												 <cfoutput>"#get_consumer_count.CONSCAT#"</cfoutput>,</cfif></cfloop>],
								datasets: [{
									label: "grafik yuzdesi",
									backgroundColor: [<cfloop  query="GET_CONSUMER_COUNT"><cfif len(get_consumer_count.CONSCAT) and len(get_consumer_count.count_) >'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfif></cfloop>],
									data: [<cfloop  query="GET_CONSUMER_COUNT"><cfif len(get_consumer_count.CONSCAT) and len(get_consumer_count.count_) ><cfoutput>"#get_consumer_count.count_#"</cfoutput>,</cfif></cfloop>],
								}]
							},
							options: {
								legend: {
									display: false
								}
							
							}
					});
				</script>	
				 
				

					<cfelse>
					<cf_get_lang dictionary_id='30249.Eklenmiş Üye Kategorisi Bulunamadı'>
					</cfif>
				<!--- </td>
			 </tr>
        </tbody>
	</cf_ajax_list> --->
</div>
</cfform>
