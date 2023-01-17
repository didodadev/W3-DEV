<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
	<cf_date tarih="attributes.startdate">
</cfif>
<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
</cfif>
<cfquery name="get_help" datasource="#dsn#">
	SELECT
		COUNT(CH.CUS_HELP_ID) HELP_COUNT,
		SC.INTERACTIONCAT
	FROM
		CUSTOMER_HELP CH,
		SETUP_INTERACTION_CAT SC
	WHERE
		SC.INTERACTIONCAT_ID = CH.INTERACTION_CAT
		<cfif isdefined ('attributes.finishdate') and len(attributes.finishdate)>
			AND INTERACTION_DATE <= #attributes.finishdate#
		</cfif>
		<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
			AND INTERACTION_DATE >= #attributes.startdate#
		</cfif>
	GROUP BY
		SC.INTERACTIONCAT
</cfquery>
<div class="row"></div>
		<div class="col col-12 col-xs-12">
	
				<cfoutput query="get_help">
					<cfset 'item_#currentrow#' = "#get_help.interactioncat#">
					<cfset 'value_#currentrow#' = "#get_help.help_count#">
				</cfoutput>
				<canvas id="myChart3" style="height:100%;"></canvas></canvas>
					<script>
						var ctx = document.getElementById('myChart3');
						var myChart3 = new Chart(ctx, {
							type: 'polarArea',
							data: {
									labels: [<cfloop from="1" to="#get_help.recordcount#" index="jj">
										<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
									datasets: [{
									label: "<cfoutput>#getLang('call',80)#</cfoutput>",
									backgroundColor: [<cfloop from="1" to="#get_help.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
									data: [<cfloop from="1" to="#get_help.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
										}]
									},
							options: {}
						});
					</script> 
		</div>
	</div>

