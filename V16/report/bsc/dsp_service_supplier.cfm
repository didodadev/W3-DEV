<!--- Seçilen Üyenin tedarikçisi veya sorunlusu olduğu(çalışan için) ürünlerin servis kayıtlarına göre çalışır 20070315 Sevda--->
<cfquery name="get_all_stock" datasource="#dsn2#">
	SELECT 
		S.PRODUCT_ID,
		SUM(STOCK_IN-STOCK_OUT) AS STOCK_AMOUNT,
		S.PRODUCT_NAME
	FROM        
		STOCKS_ROW AS SR WITH (NOLOCK),
		#dsn3_alias#.STOCKS S WITH (NOLOCK)
	WHERE
		SR.STOCK_ID=S.STOCK_ID
	<cfif isdate(attributes.finish_date)>
		AND SR.PROCESS_DATE < = #attributes.finish_date#
	</cfif>
	GROUP BY 
		S.PRODUCT_ID,S.PRODUCT_NAME
	ORDER BY 
		STOCK_AMOUNT DESC
</cfquery>
<cfquery name="get_member_stock" datasource="#dsn2#">
	SELECT
		SUM(STOCK_IN-STOCK_OUT) AS STOCK_AMOUNT,
		S.PRODUCT_NAME,
		S.PRODUCT_ID
	FROM        
		STOCKS_ROW AS SR WITH (NOLOCK),
		#dsn3_alias#.STOCKS S WITH (NOLOCK)
	<cfif len(attributes.branch_id)>
		,#dsn_alias#.DEPARTMENT D WITH (NOLOCK)
	</cfif>
	WHERE
		SR.STOCK_ID=S.STOCK_ID
	<cfif len(attributes.company_id) and len(attributes.member_name)>
		AND S.COMPANY_ID = #attributes.company_id#
	</cfif>
	<cfif len(attributes.employee_id) and len(attributes.employee)>
		AND S.PRODUCT_MANAGER = #attributes.employee_id#
	</cfif>
	<cfif isdate(attributes.finish_date)>
		AND SR.PROCESS_DATE < = #attributes.finish_date#
	</cfif>
		<cfif isdate(attributes.start_date)>
		AND SR.PROCESS_DATE > #attributes.start_date#
	</cfif>
	<cfif len(attributes.branch_id)>
		AND SR.STORE = D.DEPARTMENT_ID
		AND D.BRANCH_ID IN(#attributes.branch_id#)
	</cfif>
	GROUP BY 
		S.PRODUCT_ID,S.PRODUCT_NAME
	ORDER BY 
		STOCK_AMOUNT DESC
</cfquery>
<cfquery name="get_all_service" datasource="#dsn3#">
	SELECT 
		SERVICE_ID
	FROM 
		SERVICE WITH (NOLOCK)
	WHERE
		SERVICE_ACTIVE = 1
		<cfif isdate(attributes.finish_date)>
			AND START_DATE < = #attributes.finish_date#
		</cfif>
		<cfif isdate(attributes.start_date)>
			AND START_DATE > #attributes.start_date#
		</cfif>
</cfquery>
<cfquery name="get_member_service" datasource="#dsn3#">
	SELECT 
		SR.SERVICE_ID,
		SR.SERVICE_SUBSTATUS_ID
	FROM 
		SERVICE SR WITH (NOLOCK),
		STOCKS S WITH (NOLOCK)
	WHERE
		SR.STOCK_ID=S.STOCK_ID
		AND SR.SERVICE_ACTIVE = 1
		<cfif len(attributes.company_id) and len(attributes.member_name)>
			AND S.COMPANY_ID = #attributes.company_id#
		</cfif>
		<cfif len(attributes.employee_id) and len(attributes.employee)>
			AND S.PRODUCT_MANAGER = #attributes.employee_id#
		</cfif>
		<cfif isdate(attributes.finish_date)>
			AND SR.START_DATE < = #attributes.finish_date#
		</cfif>
		<cfif isdate(attributes.start_date)>
			AND SR.START_DATE > #attributes.start_date#
		</cfif>
</cfquery>
<cfset servis_list =''>
<cfoutput query="get_member_service">
	<cfif len(SERVICE_SUBSTATUS_ID)>
		<cfset servis_list = listappend(servis_list,SERVICE_SUBSTATUS_ID,',')>
	</cfif>
</cfoutput>
<cfif len(servis_list)>
	<cfset servis_list = listsort(listdeleteduplicates(servis_list),'numeric','ASC',',')>
	<cfquery name="get_service_sta" datasource="#dsn3#">
		SELECT * FROM SERVICE_SUBSTATUS WHERE SERVICE_SUBSTATUS_ID IN(#servis_list#)
	</cfquery>
<cfelse>
	<cfset get_service_sta.recordcount = 0>
</cfif>
<script src="JS/Chart.min.js"></script>
<cfsavecontent  variable="head"><cf_get_lang_main no='506.Tedarikçi Servisleri'></cfsavecontent>
<cf_seperator title="#head#" id="tedarik1">
<div id="tedarik1" style="padding: 10px; display: block;float: left; width: 100%">
	<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
		<p class="phead" height="20"><cf_get_lang_main no ='152.Ürünler'></p>
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
			<cfif get_member_stock.recordcount>
				<cfset customer_product_rate = (get_member_stock.recordcount*100/get_all_stock.recordcount)>
				<cfsavecontent variable="message"><cf_get_lang no ='1169.Üye Toplam'></cfsavecontent>
				<cfset item1="#message# (%#wrk_round(customer_product_rate)#)"> 
				<cfset value1="#customer_product_rate/100#">
				<cfsavecontent variable="message"><cf_get_lang_main no ='268.Genel Toplam'></cfsavecontent>
				<cfset item2="#message# (%#wrk_round(100-customer_product_rate)#)">
				<cfset value2="#(100-customer_product_rate)/100#">
				<canvas id="myChart32" style="float:left;max-width:350px;max-height:350px;"></canvas>
				<script>
					var ctx = document.getElementById('myChart32');
					var myChart32 = new Chart(ctx, {
						type: '<cfoutput>#graph_type#</cfoutput>',
						data: {
							labels: ["<cfoutput>#item1#</cfoutput>","<cfoutput>#item2#</cfoutput>"],
							datasets: [{
								label: "Ürünler",
								backgroundColor: ['rgb(255, 99, 132)','rgba(255, 99, 132, 0.2)'],
								data: [<cfoutput>#value1#</cfoutput>,<cfoutput>#value2#</cfoutput>],
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
	<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
			
		<p class="phead" height="20"><cf_get_lang no ='1171.Servisler'></p>
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
			<cfif get_member_service.recordcount>
				<cfset customer_service_rate = (get_member_service.recordcount*100/get_all_service.recordcount)>
				<cfsavecontent variable="message"><cf_get_lang no ='1169.Üye Toplam'></cfsavecontent>
				<cfset item="#message# (%#wrk_round(customer_service_rate)#)">
				<cfset value="#customer_service_rate/100#">
				<cfsavecontent variable="message"><cf_get_lang_main no ='268.Genel Toplam'></cfsavecontent>
				<cfset item2="#message# (%#wrk_round(100-customer_service_rate)#)">
				<cfset value2="#(100-customer_service_rate)/100#">
				<canvas id="myChart33" style="float:left;max-width:350px;max-height:350px;"></canvas>
				<script>
					var ctx = document.getElementById('myChart33');
					var myChart33 = new Chart(ctx, {
						type: '<cfoutput>#graph_type#</cfoutput>',
						data: {
							labels: ["<cfoutput>#item1#</cfoutput>","<cfoutput>#item2#</cfoutput>"],
							datasets: [{
								label: "Servisler",
								backgroundColor: ['rgb(255, 99, 132)','rgba(255, 99, 132, 0.2)'],
								data: [<cfoutput>#value1#</cfoutput>,<cfoutput>#value2#</cfoutput>],
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

	<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
		<p class="phead" colspan="2" height="20"><cf_get_lang no ='1170.Servis Aşamaları'></p>
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
			<cfif get_service_sta.recordcount>
				<cfloop from="1" to="#get_service_sta.recordcount#" index="cat_index">
					<cfquery name="get_member_sta" dbtype="query">
						SELECT COUNT(SERVICE_ID) COUNT_SERVICE FROM get_member_service WHERE service_substatus_id = #get_service_sta.service_substatus_id[cat_index]# 
					</cfquery>
					<cfif get_member_sta.recordcount>
						<cfset 'item_#cat_index#'="#get_service_sta.service_substatus[cat_index]#">
						<cfset 'value_#cat_index#'="#get_member_sta.count_service#">
					</cfif>
				</cfloop>				
				<canvas id="myChart34" style="float:left;max-width:350px;max-height:350px;"></canvas>
				<script>
					var ctx = document.getElementById('myChart34');
					var myChart34 = new Chart(ctx, {
						type: '<cfoutput>#graph_type#</cfoutput>',
						data: {
							labels: [<cfloop from="1" to="#get_service_sta.recordcount#" index="jj">
								<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
							datasets: [{
								label: "Servis Aşamaları",
								backgroundColor: [<cfloop from="1" to="#get_service_sta.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
								data: [<cfloop from="1" to="#get_service_sta.recordcount#" index="jj"><cfoutput>#evaluate("value_#jj#")#</cfoutput>,</cfloop>],
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
</div>
