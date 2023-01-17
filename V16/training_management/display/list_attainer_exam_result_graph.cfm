<cfinclude template="../query/get_class_ang_groups.cfm">
<cfset tr_attainer_points=ArrayNew(2)>
<cfset tr_trainer_points=ArrayNew(2)>				
<cfset max_class_num=get_trainings.recordcount>
<cfif not (isdefined('attributes.class_id') and len(attributes.class_id))>
	<cfset is_class_id = 1>
</cfif>
<cfoutput query="get_trainings">
	<cfif isdefined('is_class_id') and is_class_id eq 1>
    	<cfset attributes.class_id = get_trainings.class_id>
    </cfif>
    <cfquery name="GET_TRAININGS_INFO" datasource="#DSN#">
        SELECT
            AVG(FINALTEST_POINT) AS AVG_TOTAL,
            SUM(FINALTEST_POINT) AS SUM_TOTAL,
            COUNT(FINALTEST_POINT) AS COUNT_TOTAL
        FROM
            TRAINING_CLASS_RESULTS
        WHERE
        	CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
    </cfquery>
	<cfset tr_attainer_points[currentrow][4]=class_name>
    <cfif len(get_trainings_info.avg_total)>
        <cfset tr_attainer_points[currentrow][1]=get_trainings_info.avg_total>
    <cfelse>
        <cfset tr_attainer_points[currentrow][1]=0>
    </cfif>
    <cfinclude template="../query/get_trainer_eval_info.cfm">	
    <cfset tr_trainer_points[currentrow][4]=class_name>
    <cfif len(get_trainer.avg_total)>
        <cfset tr_trainer_points[currentrow][1]=get_trainer.avg_total>
    <cfelse>
        <cfset tr_trainer_points[currentrow][1]=0>
    </cfif>			
</cfoutput>
<cfparam name="attributes.chart_type" default="bar">
<!--- <cfquery name="get_trainings" datasource="#DSN#">
	SELECT
		AVG(FINAL_TEST_POINT) AS AVG_TOTAL,
		SUM(FINAL_TEST_POINT) AS SUM_TOTAL,
		COUNT(FINAL_TEST_POINT) AS COUNT_TOTAL
	FROM
		TRAINING_CLASS_RESULTS
	WHERE
		CLASS_ID=#attributes.CLASS_ID#
</cfquery> --->
<cf_ajax_list>
	<cfif get_trainings.recordcount>
        <tbody>
            <tr>
                <td>
					<cfif isdefined("tr_attainer_points") and arraylen(tr_attainer_points)>
                        
                        
                         <script src="JS/Chart.min.js"></script>
					
					   <canvas id="myChart" style="float:left;max-height:450px;max-width:450px;"></canvas>
				<script>
					var ctx = document.getElementById('myChart');
						var myChart = new Chart(ctx, {
							type: '<cfoutput>#attributes.chart_type#</cfoutput>',
							data: {
								labels: [<cfloop from="1" to="#arraylen(tr_trainer_points)#" index="i">
                                <cfif len(tr_trainer_points[i][4]) >
												 <cfoutput>"#LEFT(tr_trainer_points[i][4],25)#"</cfoutput> , </cfif> </cfloop>],
								datasets: [{
									label: "Series 1",
									backgroundColor: [<cfloop from="1" to="#arraylen(tr_trainer_points)#" index="i">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
									data: [<cfloop from="1" to="#arraylen(tr_trainer_points)#" index="i"><cfif len(tr_trainer_points[i][1]) ><cfoutput>"#tr_trainer_points[i][1]#"</cfoutput>,</cfif></cfloop>],
								}]
							},
							options: {}
					});
				</script>		
                	</cfif>
                </td>
            </tr>
        </tbody>
    <cfelse>
        <tbody>
            <tr>
            	<td style="font-size: 12px;"><cf_get_lang_main no="72.Kayıt Yok">!</td>
            </tr>
        </tbody>
    </cfif>
</cf_ajax_list>
