<cfquery name="GET_SERVICE" datasource="#DSN3#">
	SELECT
		SERVICE.*,
		SERVICE_APPCAT.SERVICECAT,
		SP.PRIORITY,
		SP.COLOR,
		PROCESS_TYPE_ROWS.STAGE
	FROM
		SERVICE WITH (NOLOCK),
		SERVICE_APPCAT WITH (NOLOCK),
		#dsn_alias#.SETUP_PRIORITY AS SP WITH (NOLOCK),
		#dsn_alias#.PROCESS_TYPE_ROWS AS PROCESS_TYPE_ROWS WITH (NOLOCK)
	WHERE 		
		(
		SERVICE_BRANCH_ID IN (
							SELECT
								BRANCH_ID
							FROM
								#dsn_alias#.EMPLOYEE_POSITION_BRANCHES AS EMPLOYEE_POSITION_BRANCHES 
							WHERE
								POSITION_CODE = #session.ep.position_code#
							) 
		OR
		SERVICE_BRANCH_ID IS NULL
		)
							
		AND SERVICE.SERVICECAT_ID=SERVICE_APPCAT.SERVICECAT_ID
		AND SP.PRIORITY_ID = SERVICE.PRIORITY_ID
		AND SERVICE.SERVICE_STATUS_ID = PROCESS_TYPE_ROWS.PROCESS_ROW_ID
	<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
		AND SERVICE.APPLY_DATE >= #attributes.start_date#
	</cfif>
	<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
		AND SERVICE.APPLY_DATE < #DATEADD("d",1,attributes.finish_date)#
	</cfif>
	<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
		AND SERVICE_BRANCH_ID IN(#attributes.branch_id#)
	</cfif>
	<cfif isdefined("attributes.company_id") and len(attributes.company_id)> 
		AND SERVICE.SERVICE_COMPANY_ID = #attributes.company_id#
	</cfif>
	<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
		AND SERVICE.SERVICE_CONSUMER_ID = #attributes.consumer_id#
	</cfif>
	<cfif len(attributes.employee_id) and len(attributes.employee)>
		AND SERVICE.SERVICE_EMPLOYEE_ID = #attributes.employee_id#
	</cfif>
	ORDER BY
		SERVICE.RECORD_DATE DESC
</cfquery>
<cfquery name="get_cats" datasource="#dsn3#">
	SELECT * FROM SERVICE_APPCAT ORDER BY SERVICECAT DESC
</cfquery>
<cfquery name="get_process" datasource="#dsn#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR WITH (NOLOCK),
		PROCESS_TYPE_OUR_COMPANY PTO WITH (NOLOCK),
		PROCESS_TYPE PT WITH (NOLOCK)
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%service.add_service%">
	ORDER BY
		PTR.STAGE DESC
</cfquery>
<cfsavecontent  variable="head"><cf_get_lang dictionary_id="30039.Servis Başvuruları">
</cfsavecontent>
<cf_seperator title="#head#" id="servis1">
<div  id="servis1"   style="padding: 10px; display: block;float: left; width: 100%">
	<cfif GET_SERVICE.recordcount>
		<cfquery name="get_ships" datasource="#dsn2#">
			SELECT SUM(SR.COST_PRICE+SR.EXTRA_COST) AS MALIYETLER FROM SHIP S,SHIP_ROW SR WHERE SR.SERVICE_ID IN (#valuelist(GET_SERVICE.SERVICE_ID)#) AND S.SHIP_TYPE = 141 AND S.SHIP_ID = SR.SHIP_ID
		</cfquery>
		<cfquery name="get_shipler" datasource="#dsn2#">
			SELECT S.SHIP_ID FROM SHIP S,SHIP_ROW SR WHERE S.SHIP_ID = SR.SHIP_ID AND SR.SERVICE_ID IN (#valuelist(GET_SERVICE.service_id)#) AND SHIP_TYPE = 141 
			<!--- FS 20081022 service_id ler ship_row a tasindigindan sayfa cakiyordu gecici duzelttim
			SELECT SHIP_ID FROM SHIP WHERE SERVICE_ID IN (#valuelist(GET_SERVICE.service_id)#) AND SHIP_TYPE = 141 --->
		</cfquery>
		<cfset ship_list_ = valuelist(get_shipler.SHIP_ID)>
				<!---kategorilere göre --->
			<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
				<p class="phead"><cf_get_lang no ='1136.Kategorilere Göre Başvurular'></p>
			
				<cf_grid_list>
					<thead>
						<tr>
							<th><cf_get_lang_main no ='74.Kategori'></th>
							<th width="30"><cf_get_lang no ='82.Sayı'></th>
						</tr>
					</thead>
					<tbody>
						<cfoutput query="get_cats">
							<cfquery name="get_1" dbtype="query">
								SELECT SERVICE_ID FROM GET_SERVICE WHERE SERVICECAT_ID = #SERVICECAT_ID#
							</cfquery>
							<tr>
								<td>#SERVICECAT#</td>
								<td>#get_1.recordcount#</td>
							</tr>
						</cfoutput>
					</tbody>
				</cf_grid_list>
			</div>
			<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
					<cfoutput query="get_cats">
						<cfquery name="get_1" dbtype="query">
							SELECT SERVICE_ID FROM GET_SERVICE WHERE SERVICECAT_ID = #SERVICECAT_ID#
						</cfquery>
						<cfset 'item_#currentrow#'="#SERVICECAT#...(%#wrk_round(get_1.recordcount*100/GET_SERVICE.recordcount)#)">
						<cfset 'value_#currentrow#'="#(get_1.recordcount*100/GET_SERVICE.recordcount)/100#">
					</cfoutput>
					<script src="JS/Chart.min.js"></script> 
					<canvas id="myChart12" style="float:left;max-width:320px;max-height:320px;"></canvas>
					<script>
						var ctx = document.getElementById('myChart12');
							var myChart12 = new Chart(ctx, {
								type: '<cfoutput>#graph_type#</cfoutput>',
								data: {
									labels: [<cfloop from="1" to="#get_cats.recordcount#" index="jj">
											<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
									datasets: [{
										label: "Servis Başvuruları",
										backgroundColor: [<cfloop from="1" to="#get_cats.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
										data: [<cfloop from="1" to="#get_cats.recordcount#" index="jj"><cfoutput>#evaluate("value_#jj#")#</cfoutput>,</cfloop>],
									}]
								},
								options: {
									legend: {
										display: false
									}
								}
						});
					</script>
			</div>
			<!---kategorilere göre --->
			<!---sürece göre --->
			<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
				<p class="phead"><cf_get_lang no ='1137.Aşamalara Göre Başvurular'></p>
				
				<cf_grid_list>
					<thead>
						<tr>
							<th><cf_get_lang_main no ='70.Aşama'></th>
							<th width="30"><cf_get_lang no ='82.Sayı'></th>
						</tr>
					</thead>
					<tbody>
						<cfoutput query="get_process">
							<cfquery name="get_1" dbtype="query">
								SELECT SERVICE_ID FROM GET_SERVICE WHERE SERVICE_STATUS_ID = #PROCESS_ROW_ID#
							</cfquery>
							<tr>
								<td>#STAGE#</td>
								<td>#get_1.recordcount#</td>
							</tr>
						</cfoutput>
					</tbody>
				</cf_grid_list>
			</div>
			<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
					<cfoutput query="get_process">
						<cfquery name="get_1" dbtype="query">
							SELECT SERVICE_ID FROM GET_SERVICE WHERE SERVICE_STATUS_ID = #PROCESS_ROW_ID#
						</cfquery>
						<cfset 'item_#currentrow#'="#STAGE#...(%#wrk_round(get_1.recordcount*100/GET_SERVICE.recordcount)#)">
						<cfset 'value_#currentrow#'="#(get_1.recordcount*100/GET_SERVICE.recordcount)/100#">
					</cfoutput>
				<canvas id="myChart13" style="float:left;max-width:320px;max-height:320px;"></canvas>
					<script>
						var ctx = document.getElementById('myChart13');
							var myChart13 = new Chart(ctx, {
								type: '<cfoutput>#graph_type#</cfoutput>',
								data: {
									labels: [<cfloop from="1" to="#get_process.recordcount#" index="jj">
											<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
									datasets: [{
										label: "Servis Başvuruları",
										backgroundColor: [<cfloop from="1" to="#get_process.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
										data: [<cfloop from="1" to="#get_process.recordcount#" index="jj"><cfoutput>#evaluate("value_#jj#")#</cfoutput>,</cfloop>],
									}]
								},
								options: {
									legend: {
										display: false
									}
								}
						});
					</script>
				<!---sürece göre --->
			</div>
	<cfelse>
		<cf_get_lang dictionary_id ='58486.Servis Kaydı Bulunamadı'>!
	</cfif>
</div>