<!--- Seçilen üyeye verilen satış kotalarına göre çalışır 20070315 Sevda --->
<cfquery name="get_member_quota" datasource="#dsn3#">
	SELECT
		SUM(TOTAL_QUANTITY) AS MIKTAR,
		SUM(TOTAL_AMOUNT) AS TUTAR
		<cfif len(attributes.company_id) and len(attributes.member_name)>
			,COMPANY_ID
		</cfif>
		<cfif len(attributes.employee_id) and len(attributes.employee)>
			,EMPLOYEE_ID
		</cfif>
		<cfif len(attributes.consumer_id) and len(attributes.member_name)>
			,CONSUMER_ID
		</cfif>
		<cfif len(attributes.branch_id)>
			,BRANCH_ID
		</cfif>
	FROM        
		SALES_QUOTAS WITH (NOLOCK)
	WHERE
		SALES_QUOTA_ID IS NOT NULL
		<cfif len(attributes.company_id) and len(attributes.member_name)>
			AND COMPANY_ID = #attributes.company_id#
		</cfif>
		<cfif len(attributes.employee_id) and len(attributes.employee)>
			AND EMPLOYEE_ID = #attributes.employee_id#
		</cfif>
		<cfif len(attributes.consumer_id) and len(attributes.member_name)>
			AND CONSUMER_ID = #attributes.consumer_id#
		</cfif>
		<cfif len(attributes.branch_id)>
			AND BRANCH_ID IN(#attributes.branch_id#)
		</cfif>
		<cfif isdate(attributes.finish_date)>
			AND PLAN_DATE < = #attributes.finish_date#
		</cfif>
		<cfif isdate(attributes.start_date)>
			AND PLAN_DATE >= #attributes.start_date#
		</cfif>
	GROUP BY
		<cfif len(attributes.company_id) and len(attributes.member_name)>COMPANY_ID</cfif>
		<cfif len(attributes.employee_id) and len(attributes.employee)>
			<cfif len(attributes.company_id) and len(attributes.member_name)>,</cfif>EMPLOYEE_ID
		</cfif>
		<cfif len(attributes.consumer_id) and len(attributes.member_name)>
			<cfif (len(attributes.company_id) and len(attributes.member_name)) or (len(attributes.employee_id) and len(attributes.employee))>,</cfif>CONSUMER_ID
		</cfif>
		<cfif len(attributes.branch_id)>
			<cfif (len(attributes.company_id) and len(attributes.member_name)) or (len(attributes.employee_id) and len(attributes.employee)) or (len(attributes.consumer_id) and len(attributes.member_name))>,</cfif>BRANCH_ID
		</cfif>
</cfquery>
<cfquery name="get_all_quota" datasource="#dsn3#">
	SELECT
		SUM(TOTAL_QUANTITY) AS MIKTAR,
		SUM(TOTAL_AMOUNT) AS TUTAR
	FROM        
		SALES_QUOTAS WITH (NOLOCK)
	WHERE
		<cfif isdate(attributes.finish_date)>
			PLAN_DATE < = #attributes.finish_date#
		</cfif>
		<cfif isdate(attributes.start_date)>
			AND PLAN_DATE >= #attributes.start_date#
		</cfif>
</cfquery>
<script src="JS/Chart.min.js"></script> 
<cfsavecontent  variable="head"><cf_get_lang dictionary_id ='39570.Satış Hedefleri'></cfsavecontent>
<cf_seperator title="#head#" id="targets1">
<div id="targets1"   style="padding: 10px; display: block;float: left; width: 100%">

	<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
		
		<p class="phead"><cf_get_lang no ='1145.Toplam Ciro Hedefi'> :
		<cfif len(get_member_quota.recordcount)><cfoutput>#get_member_quota.TUTAR# #session.ep.money#</cfoutput></cfif></p>
	
			<cfif get_member_quota.recordcount>
					<cfset customer_quota_rate = (get_member_quota.TUTAR*100/get_all_quota.TUTAR)>
					<cfsavecontent variable="message"><cf_get_lang no ='1169.Üye Toplam'></cfsavecontent>
						<cfset item1="#message# (%#wrk_round(customer_quota_rate)#)">
						<cfset value1="#customer_quota_rate/100#">
					<cfsavecontent variable="message"><cf_get_lang_main no ='268.Genel Toplam'></cfsavecontent>
						<cfset item2="#message# (%#wrk_round(100-customer_quota_rate)#)">
						<cfset value2="#(100-customer_quota_rate)/100#">

					<canvas id="satishedef" style="float:left;max-width:320px;max-height:320px;"></canvas>
					<script>
						var ctx = document.getElementById('satishedef');
							var satishedef = new Chart(ctx, {
								type: '<cfoutput>#graph_type#</cfoutput>',
								data: {
									labels: ["<cfoutput>#item1#</cfoutput>","<cfoutput>#item2#</cfoutput>"],
									datasets: [{
										label: "Satış Hedefleri",
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
	<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
		<p class="phead"><cf_get_lang no ='1146.Toplam Miktar Hedefi'> :
		<cfif len(get_member_quota.recordcount)><cfoutput>#get_member_quota.MIKTAR# Adet</cfoutput></cfif></p>
	
			<cfif get_member_quota.recordcount>

				<cfsavecontent variable="message"><cf_get_lang no ='1169.Üye Toplam'></cfsavecontent>
					<cfset item1="#message# (#get_member_quota.MIKTAR#)">
					<cfset value1="#get_member_quota.MIKTAR#">
				<cfsavecontent variable="message"><cf_get_lang_main no ='268.Genel Toplam'></cfsavecontent>
					<cfset item1="#message# (#get_all_quota.MIKTAR#)">
					<cfset value1="#get_all_quota.MIKTAR#">

				<canvas id="satishedef2" style="float:left;max-width:320px;max-height:320px;"></canvas>
					<script>
						var ctx = document.getElementById('satishedef2');
							var satishedef2 = new Chart(ctx, {
								type: '<cfoutput>#graph_type#</cfoutput>',
								data: {
									labels: ["<cfoutput>#item1#</cfoutput>","<cfoutput>#item2#</cfoutput>"],
									datasets: [{
										label: "<cf_get_lang no ='1146.Toplam Miktar Hedefi'>",
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
