<!--- Seçilen üyenin katılımcı olduğu olaylara göre çalışır 20070315 Sevda --->
<!--- 20141119 FBS Ajandada Uyenin calisani bazli kayit tutuldugundan, raporda da uye secildiginden, o uyeye ait tum calisanlar dondurulup buna gore arama yapiyoruz --->
<cfif isDefined("attributes.company_id") and len(attributes.company_id) and isDefined("attributes.member_name") and len(attributes.member_name)>
	<cfquery name="get_partners" datasource="#dsn#">
		SELECT PARTNER_ID FROM COMPANY_PARTNER WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
	</cfquery>
</cfif>
<cfquery name="get_member_event" datasource="#dsn#">
	SELECT
		EVENT.EVENT_ID,
		EVENT.EVENTCAT_ID,
		EC.EVENTCAT
	FROM        
		EVENT WITH (NOLOCK)
		LEFT JOIN EVENT_CAT EC ON EVENT.EVENTCAT_ID = EC.EVENTCAT_ID 
	WHERE
		EVENT_ID IS NOT NULL
		<cfif isDefined("attributes.company_id") and len(attributes.company_id) and isDefined("attributes.member_name") and len(attributes.member_name) and get_partners.recordcount>
			AND 
			(
			<cfloop query="get_partners">
				EVENT_TO_PAR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#attributes.partner_id#,%"> <cfif get_partners.currentrow neq get_partners.recordcount>OR</cfif>
			</cfloop>
			)
		</cfif>
		<cfif isDefined("attributes.employee_id") and len(attributes.employee_id) and isDefined("attributes.employee") and len(attributes.employee)>
			AND EVENT_TO_POS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#attributes.employee_id#,%">
		</cfif>
		<cfif isDefined("attributes.consumer_id") and len(attributes.consumer_id) and isDefined("attributes.member_name") and len(attributes.member_name)>
			AND EVENT_TO_CON LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#attributes.consumer_id#,%">
		</cfif>
		<cfif isdate(attributes.finish_date)>
			AND STARTDATE < = <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finish_date#">
		</cfif>
		<cfif isdate(attributes.start_date)>
			AND STARTDATE > <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.start_date#">
		</cfif>
</cfquery>
<cfquery name="get_all_event" datasource="#dsn#">
	SELECT
		EVENT_ID,
		EVENTCAT_ID
	FROM        
		EVENT WITH (NOLOCK)
	WHERE
		EVENT_ID IS NOT NULL
		<cfif isdate(attributes.finish_date)>
			AND STARTDATE < = <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finish_date#">
		</cfif>
		<cfif isdate(attributes.start_date)>
			AND STARTDATE > <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.start_date#">
		</cfif>
</cfquery>
<cfquery name="get_member_event_plan" datasource="#dsn#">
	SELECT
		EPR.EVENT_PLAN_ROW_ID,
		EPR.WARNING_ID,
		SVT.VISIT_TYPE
	FROM	
		EVENT_PLAN_ROW EPR
		LEFT JOIN SETUP_VISIT_TYPES SVT ON SVT.VISIT_TYPE_ID = EPR.WARNING_ID
	WHERE
		EPR.EVENT_PLAN_ROW_ID IS NOT NULL
		<cfif isDefined("attributes.company_id") and len(attributes.company_id) and isDefined("attributes.member_name") and len(attributes.member_name) and get_partners.recordcount>
			AND 
			(
			<cfloop query="get_partners">
				EPR.PARTNER_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.partner_id#%"> <cfif get_partners.currentrow neq get_partners.recordcount>OR</cfif>
			</cfloop>
			)
		</cfif>
		<cfif isDefined("attributes.consumer_id") and len(attributes.consumer_id) and isDefined("attributes.member_name") and len(attributes.member_name)>
			AND EPR.CONSUMER_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.consumer_id#%">
		</cfif>
		<cfif isdate(attributes.finish_date)>
			AND EPR.START_DATE < = <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finish_date#">
		</cfif>
		<cfif isdate(attributes.start_date)>
			AND EPR.START_DATE > <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.start_date#">
		</cfif>
</cfquery>
<cfquery name="get_member_event_plan_row" datasource="#dsn#">
	SELECT
		EPR.EVENT_PLAN_ROW_ID,
		EPR.WARNING_ID
	FROM	
		EVENT_PLAN_ROW EPR
	WHERE
		EPR.EVENT_PLAN_ROW_ID IS NOT NULL
		<cfif isdate(attributes.finish_date)>
			AND EPR.START_DATE < = <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finish_date#">
		</cfif>
		<cfif isdate(attributes.start_date)>
			AND EPR.START_DATE > <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.start_date#">
		</cfif>
</cfquery>
<cfsavecontent  variable="head"><cf_get_lang dictionary_id ='39518.Toplantı ve Ziyaretler'></cfsavecontent>
<cf_seperator title="#head#" id="toplanti1">
<div id="toplanti1"   style="padding: 10px; display: block;float: left; width: 100%">
	<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
		<p class="phead"><cf_get_lang no ='1141.Olaylar'></p>
		<script src="JS/Chart.min.js"></script> 
		<cfif get_member_event.recordcount>
			<cfset customer_event_rate = (get_member_event.recordcount*100/get_all_event.recordcount)>

			<canvas id="myCharts14" style="float:left;max-width:320px;max-height:320px;"></canvas>
			<script>
				var ctx = document.getElementById('myCharts14');
					var myCharts14 = new Chart(ctx, {
						type: '<cfoutput>#graph_type#</cfoutput>',
						data: {
							labels: ["<cf_get_lang no ='1169.Üye Toplam'>", "<cf_get_lang_main no ='268.Genel Toplam'>"],
							datasets: [{
								label: ["Olaylar"],
								backgroundColor: ['rgb(255, 153, 0)','rgb(102, 217, 255)'],
								borderColor: ['rgb(255, 153, 0)','rgb(102, 217, 255)'],
								data: [<cfoutput>#wrk_round(customer_event_rate)#</cfoutput>, <cfoutput>#wrk_round(100-customer_event_rate)#</cfoutput>],
							}]
						},
						options: {
							legend: {
								display: false
							}
						}
				});
			</script>

		</cfif>
	</div>
	<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
		<p class="phead"><cf_get_lang no ='1142.Olay Kategorileri'></p>
		<cfif get_member_event.recordcount>
				<cfloop from="1" to="#get_member_event.recordcount#" index="cat_index">
					<cfquery name="get_event_sta" dbtype="query">
						SELECT COUNT(EVENT_ID) COUNT_EVENT FROM get_member_event WHERE eventcat_id = #get_member_event.eventcat_id[cat_index]# 
					</cfquery>
					<cfif get_event_sta.recordcount>
						<cfset 'item_#cat_index#' = "#get_member_event.eventcat[cat_index]#">
						<cfset 'value_#cat_index#' = "#get_event_sta.count_event#">
					</cfif>
				</cfloop>	
		<canvas id="myChart13" style="float:left;max-width:320px;max-height:320px;"></canvas>
		<script>
			var ctx = document.getElementById('myChart13');
				var myChart13 = new Chart(ctx, {
					type: '<cfoutput>#graph_type#</cfoutput>',
					data: {
						labels: [<cfloop from="1" to="#get_member_event.recordcount#" index="cat_index">
								<cfoutput>"#evaluate("item_#cat_index#")#"</cfoutput>,</cfloop>],
						datasets: [{
							label: "Olay Kategorileri",
							backgroundColor: [<cfloop from="1" to="#get_member_event.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
							data: [<cfloop from="1" to="#get_member_event.recordcount#" index="cat_index"><cfoutput>"#evaluate("value_#cat_index#")#"</cfoutput>,</cfloop>],
						}]
					},
					options: {
						legend: {
							display: false
						}
					}
			});
		</script>
		</cfif>
	</div>	
	<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
		<p class="phead"><cf_get_lang_main no="558.Ziyaretler"></p>
		<cfif get_member_event_plan.recordcount>
			<cfset customer_event_rate_row = (get_member_event_plan.recordcount*100/get_member_event_plan_row.recordcount)>
			<cfsavecontent variable="message"><cf_get_lang no ='1169.Üye Toplam'></cfsavecontent>
			<cfset item1="#message# (%#wrk_round(customer_event_rate_row)#)">
			<cfset value1="#customer_event_rate_row/100#">
			<cfsavecontent variable="message"><cf_get_lang_main no ='268.Genel Toplam'></cfsavecontent>
			<cfset item2="#message# (%#wrk_round(100-customer_event_rate_row)#)">
			<cfset value2="#(100-customer_event_rate_row)/100#">
			<canvas id="myChart15" style="float:left;max-width:320px;max-height:320px;"></canvas>
			<script>
				var ctx = document.getElementById('myChart15');
					var myChart15 = new Chart(ctx, {
						type: '<cfoutput>#graph_type#</cfoutput>',
						data: {
							labels: ["<cfoutput>#item1#</cfoutput>", "<cfoutput>#item2#</cfoutput>"],
							datasets: [{
								label: ["Ziyaretler"],
								backgroundColor: ['rgb(255, 153, 0)','rgb(102, 217, 255)'],
								borderColor: ['rgb(255, 153, 0)','rgb(102, 217, 255)'],
								data: [<cfoutput>#value1#</cfoutput>, <cfoutput>#value2#</cfoutput>],
							}]
						},
						options: {
							legend: {
								display: false
							}
						}
				});
			</script>
		</cfif>
	</div>
	<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
		<p class="phead"><cf_get_lang dictionary_id="873.Ziyaret Kategorileri"></p>
		<cfif get_member_event_plan.recordcount>
					<cfloop from="1" to="#get_member_event_plan.recordcount#" index="cat_index">
						<cfquery name="get_event_sta_row" dbtype="query">
							SELECT COUNT(EVENT_PLAN_ROW_ID) COUNT_EVENT_ROW FROM get_member_event_plan WHERE WARNING_ID = #get_member_event_plan.WARNING_ID[cat_index]# 
						</cfquery>
						<cfif get_event_sta_row.recordcount>
							<cfset 'item_#cat_index#'="#get_member_event_plan.VISIT_TYPE[cat_index]#">
							<cfset 'value_#cat_index#'="#get_event_sta_row.COUNT_EVENT_ROW#">
						</cfif>
					</cfloop>				
			<canvas id="myChart16" style="float:left;max-width:320px;max-height:320px;"></canvas>
			<script>
				var ctx = document.getElementById('myChart16');
					var myChart16 = new Chart(ctx, {
						type: '<cfoutput>#graph_type#</cfoutput>',
						data: {
							labels: [<cfloop from="1" to="#get_member_event_plan.recordcount#" index="cat_index">
									<cfoutput>"#evaluate("item_#cat_index#")#"</cfoutput>,</cfloop>],
							datasets: [{
								label: "Ziyaret Kategorileri",
								backgroundColor: [<cfloop from="1" to="#get_member_event.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
								data: [<cfloop from="1" to="#get_member_event_plan.recordcount#" index="cat_index"><cfoutput>"#evaluate("value_#cat_index#")#"</cfoutput>,</cfloop>],
							}]
						},
						options: {
							legend: {
								display: false
							}
						}
				});
			</script>
		</cfif>
	</div>
</div>
