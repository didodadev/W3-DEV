<cfset session_base = session.ep>
<cfif not(isdefined('attributes.employee_id') and len(attributes.employee_id) and len(attributes.employee)) and not len(attributes.branch_id)>
	<cfsavecontent  variable="head"><cf_get_lang dictionary_id='58085.Finansal Özet'>
	</cfsavecontent>
	<cf_seperator title="#head#" id="finance1">
	<cfset attributes.company = attributes.member_name>
	<div id="finance1" style="padding: 10px; display: block;float: left; width: 100%">
	<cfinclude template="../../objects/display/dsp_extre_summary.cfm">
	<cfif isdefined('attributes.company_id') and len(attributes.company_id) and len(attributes.company) and member_type is 'partner' and get_company_risk.recordcount >
		
						<cfif isdefined("form.graph_type") and len(form.graph_type)>
							<cfset graph_type = form.graph_type>
						<cfelse>
							<cfset graph_type = "pie">
						</cfif>
						<cfset total_risk = 0>
						<cfif len(GET_COMPANY_RISK.CEK_ODENMEDI)><cfset total_risk = total_risk + GET_COMPANY_RISK.CEK_ODENMEDI></cfif>
						<cfif len(GET_COMPANY_RISK.SENET_ODENMEDI)><cfset total_risk = total_risk + GET_COMPANY_RISK.SENET_ODENMEDI></cfif>
						<cfif len(GET_COMPANY_RISK.CEK_KARSILIKSIZ)><cfset total_risk = total_risk + GET_COMPANY_RISK.CEK_KARSILIKSIZ></cfif>
						<cfif len(GET_COMPANY_RISK.SENET_KARSILIKSIZ)><cfset total_risk = total_risk + GET_COMPANY_RISK.SENET_KARSILIKSIZ></cfif>
							<cfsavecontent variable="message"><cf_get_lang_main no ='460.Toplam Risk'></cfsavecontent>
								<cfset item1="#message#">
								<cfset value1="#(GET_COMPANY_RISK.BAKIYE - (total_risk))#">
							<cfsavecontent variable="message"><cf_get_lang_main no ='466.Kullanılabilir Limit'></cfsavecontent>
								<cfset item2="#message#">
								<cfset value2="#(GET_COMPANY_RISK.TOTAL_RISK_LIMIT - (GET_COMPANY_RISK.BAKIYE  + (total_risk)))#">
								
								<script src="JS/Chart.min.js"></script> 
								<canvas id="myChart998" style="float:left;max-width:320px;max-height:320px;"></canvas>
								<script>
									var ctx = document.getElementById('myChart998');
										var myChart998 = new Chart(ctx, {
											type: '<cfoutput>#graph_type#</cfoutput>',
											data: {
												labels: ["<cfoutput>#item1#</cfoutput>","<cfoutput>#item2#</cfoutput>"],
												datasets: [{
													label: "Finansal Özet",
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
</cfif>
