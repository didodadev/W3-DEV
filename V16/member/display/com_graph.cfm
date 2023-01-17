<!---<cfinclude template="../query/get_company_cat.cfm">---> 
<cfsetting showdebugoutput="no">
<cfform action="" method="post" name="form_stock">
    <div>
 <!--- 
    <thead>
        <tr>
            <th style="text-align:right;"> 
                <select name="graph_type" id="graph_type" style="width:100px;">
                    <option value="pie"<cfif isdefined("attributes.graph_type") and attributes.graph_type is 'pie'>selected</cfif>><cf_get_lang dictionary_id='58728.Pasta'></option>
                    <option value="line"<cfif isdefined("attributes.graph_type") and attributes.graph_type is 'line'>selected</cfif>><cf_get_lang dictionary_id='57665.Eğri'></option>
                    <option value="bar"<cfif isdefined("attributes.graph_type") and attributes.graph_type is 'bar'>selected</cfif>><cf_get_lang dictionary_id='57663.Bar'></option>
                </select>
            </th>
			<th tyle="text-align:right;"><cf_wrk_search_button></th>
        </tr>
    </thead>
    <tbody>
		<tr class="nohover">
			<td colspan="2"> --->
			<!--- <cfif isdefined("form.graph_type") and len(form.graph_type)>
                <cfset graph_type = form.graph_type>
            <cfelse>
                <cfset graph_type = "pie">
            </cfif> --->
           
                <cfquery  name="GET_COMP_COUNT" datasource="#DSN#">
                 SELECT 
                        1 AS TYPE,
                        ISNULL(COUNT(COM.COMPANYCAT_ID),0) COUNT_,
                        GMC.COMPANYCAT
                    FROM 
                        COMPANY COM
                        LEFT JOIN 
                                    GET_MY_COMPANYCAT GMC ON COM.COMPANYCAT_ID = GMC.COMPANYCAT_ID AND
                                    GMC.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND 
                                    GMC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                    GROUP BY 
                        COM.COMPANYCAT_ID,
                        GMC.COMPANYCAT
                    HAVING
                        COUNT(COM.COMPANYCAT_ID) >= (SELECT TOP 1 COUNT(COMPANYCAT_ID) FROM COMPANY GROUP BY COMPANYCAT_ID ORDER BY COUNT(COMPANYCAT_ID) DESC) * 0.03
                    
                UNION ALL
                    
                    SELECT 0 AS TYPE,SUM(COUNT_),'<cf_get_lang dictionary_id="58156.diger">' COMPANYCAT  FROM 
                    (SELECT 
                        ISNULL(COUNT(COM.COMPANYCAT_ID),0) COUNT_
                    FROM 
                        COMPANY COM
                    GROUP BY 
                        COM.COMPANYCAT_ID
                    HAVING
                        COUNT(COM.COMPANYCAT_ID) < (SELECT TOP 1 COUNT(C.COMPANYCAT_ID) FROM COMPANY C GROUP BY C.COMPANYCAT_ID ORDER BY COUNT(C.COMPANYCAT_ID) DESC) * 0.03
                    )T1
                    
                ORDER BY 
                    TYPE DESC,
                    COUNT_ DESC
                </cfquery>
            <cfset my_height = ((get_comp_count.recordcount*20)+90)>	
            <cfif get_comp_count.recordcount>
             
                <script src="JS/Chart.min.js"></script>
					<canvas id="myChart" style="width:100%!important;"></canvas>
				<script>
					var ctx = document.getElementById('myChart');
						var myChart = new Chart(ctx, {
							type: 'pie',
							data: {
								labels: [<cfloop  query="GET_COMP_COUNT"><cfif len(get_comp_count.companycat) and len(get_comp_count.count_) >
												 <cfoutput>"#get_comp_count.companycat#"</cfoutput>,</cfif></cfloop>],
								datasets: [{
									label: "grafik yuzdesi",
									backgroundColor: [<cfloop  query="GET_COMP_COUNT"><cfif len(get_comp_count.companycat) and len(get_comp_count.count_) >'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfif></cfloop>],
									data: [<cfloop  query="GET_COMP_COUNT"><cfif len(get_comp_count.companycat) and len(get_comp_count.count_) ><cfoutput>"#get_comp_count.count_#"</cfoutput>,</cfif></cfloop>],
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
