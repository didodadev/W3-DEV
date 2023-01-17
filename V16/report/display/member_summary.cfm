<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
	<cf_date tarih="attributes.startdate">
</cfif>
<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
</cfif>
<cfif attributes.member_type eq 1>
	<cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
		SELECT DISTINCT	
			COMPANYCAT_ID,
			COMPANYCAT
		FROM
			GET_MY_COMPANYCAT
		WHERE
			EMPLOYEE_ID = #session.ep.userid# AND
			OUR_COMPANY_ID = #session.ep.company_id# AND
			COMPANYCAT_ID IN(SELECT COMPANYCAT_ID FROM COMPANY)
		ORDER BY
			COMPANYCAT		
	</cfquery>
<cfelse>
	<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
		SELECT DISTINCT
			CONSCAT_ID,
			CONSCAT,
			HIERARCHY
		FROM
			GET_MY_CONSUMERCAT
		WHERE
			EMPLOYEE_ID = #session.ep.userid# AND
			OUR_COMPANY_ID = #session.ep.company_id# AND
			CONSCAT_ID IN(SELECT CONSCAT_ID FROM CONSUMER)
		ORDER BY
			CONSCAT	
	</cfquery>
</cfif>

<div class="row">
	<div class="col col-6 col-xs-12"></div>
	<div class="col col-6 col-xs-12" style="text-align:right;">
		<div class="form-group" id="item-member_type">
			<div class="input-group">
				<select name="member_type" id="member_type" onChange="reload_member();">
					<option value="1" <cfif isdefined("attributes.member_type") and attributes.member_type eq 1>selected</cfif>><cfoutput><cf_get_lang dictionary_id='49245.Kurumsal'></cfoutput></option>
					<option value="2" <cfif isdefined("attributes.member_type") and attributes.member_type eq 2>selected</cfif>><cfoutput><cf_get_lang dictionary_id='49246.Bireysel'></cfoutput></option>
				</select>
			</div>
		</div>
	</div>

<cfif attributes.member_type eq 1>
	<div class="col col-12 col-xs-12">
			<cfset my_height = ((get_company_cat.recordcount*8)+90)>
			<cfif get_company_cat.recordcount>		 
						<cfloop from="1" to="#get_company_cat.recordcount#" index="gr2_in">
							<cfquery name="GET_COMP_COUNT" datasource="#DSN#">
								SELECT 
									COUNT(COMPANY_ID) AS COUNT_COMPANY 
								FROM 
									COMPANY 
								WHERE 
									COMPANY_STATUS = 1 
									AND COMPANYCAT_ID = #GET_COMPANY_CAT.COMPANYCAT_ID[gr2_in]# 
									<cfif isdefined ('attributes.finishdate') and len(attributes.finishdate)>
										AND RECORD_DATE <= #attributes.finishdate#
									</cfif>
									<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
										AND RECORD_DATE >= #attributes.startdate#
									</cfif>
							</cfquery>
							<cfset 'item_#gr2_in#' = "#get_company_cat.COMPANYCAT[gr2_in]#">
							<cfset 'value_#gr2_in#' = "#GET_COMP_COUNT.COUNT_COMPANY#">
						</cfloop>
					<canvas id="myChart2" style="height:100%;"></canvas>
					<script>
						var ctx = document.getElementById('myChart2');
						var myChart2 = new Chart(ctx, {
							type: 'bar',
							data: {
									labels: [<cfloop from="1" to="#get_company_cat.recordcount#" index="jj">
										<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
									datasets: [{
									label: "<cfoutput>#getLang('main',45)# #getLang('main',2157)# #getLang('objects',406)#</cfoutput>",
									backgroundColor: [<cfloop from="1" to="#get_company_cat.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
									data: [<cfloop from="1" to="#get_company_cat.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
										}]
									},
							options: {}
						});
					</script> 

			</cfif>
	</div>
<cfelse>
	<div class="col col-12 col-xs-12">
			<cfset my_height = ((get_consumer_cat.recordcount*8)+90)>
			<cfif get_consumer_cat.recordcount>		 
						<cfloop from="1" to="#get_consumer_cat.recordcount#" index="gr2_in">
							<cfquery name="GET_CONS_COUNT" datasource="#DSN#">
								SELECT 
									COUNT(CONSUMER_ID) AS COUNT_CONSUMER 
								FROM 
									CONSUMER 
								WHERE 
									CONSUMER_STATUS = 1 
									AND CONSUMER_CAT_ID = #GET_CONSUMER_CAT.CONSCAT_ID[gr2_in]#
									<cfif isdefined ('attributes.finishdate') and len(attributes.finishdate)>
										AND RECORD_DATE <= #attributes.finishdate#
									</cfif>
									<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
										AND RECORD_DATE >= #attributes.startdate#
									</cfif> 
							</cfquery>
							<cfset 'item_#gr2_in#' = "#get_consumer_cat.CONSCAT[gr2_in]#">
							<cfset 'value_#gr2_in#' = "#GET_CONS_COUNT.COUNT_CONSUMER#">
						</cfloop>
					<canvas id="myChart21" style="height:100%;"></canvas>
					<script>
						var ctx = document.getElementById('myChart21');
						var myChart21 = new Chart(ctx, {
							type: 'bar',
							data: {
									labels: [<cfloop from="1" to="#get_consumer_cat.recordcount#" index="jj">
										<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
									datasets: [{
									label: "<cfoutput>#getLang('main',45)# #getLang('main',2157)# #getLang('objects',406)#</cfoutput>",
									backgroundColor: [<cfloop from="1" to="#get_consumer_cat.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
									data: [<cfloop from="1" to="#get_consumer_cat.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
										}]
									},
							options: {}
						});
					</script>  
			</cfif>
	</div>
</cfif>
</div>
<script type="text/javascript">
	function reload_member()
	{
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report</cfoutput>.popup_member_summary&member_type='+document.all.member_type.value+'&startdate='+document.all.startdate.value+'&finishdate='+document.all.finishdate.value+'','member_summary');
	}
</script>
