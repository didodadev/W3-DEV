<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
	<cf_date tarih="attributes.startdate">
</cfif>
<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
</cfif>
<cfquery name="get_event_count" datasource="#dsn#">
	SELECT
		COUNT(E.EVENT_ID) EVENT_COUNT,
		EC.EVENTCAT
	FROM
		EVENT E,
		EVENT_CAT EC
	WHERE
		E.EVENTCAT_ID = EC.EVENTCAT_ID
		<cfif isdefined ('attributes.finishdate') and len(attributes.finishdate)>
			AND STARTDATE <= #attributes.finishdate#
		</cfif>
		<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
			AND STARTDATE >= #attributes.startdate#
		</cfif>
	GROUP BY
		EC.EVENTCAT
</cfquery>
<div class="row">
		<div class="col col-12 col-xs-12">
					<cfoutput query="get_event_count">
						<cfset 'item_#currentrow#' = "#get_event_count.eventcat#">
						<cfset 'value_#currentrow#' = "#get_event_count.event_count#">
					</cfoutput>
					<canvas id="myChart8" style="height:100%;"></canvas>
					<script>
						var ctx = document.getElementById('myChart8');
						var myChart8 = new Chart(ctx, {
							type: 'radar',
							data: {
									labels: [<cfloop from="1" to="#get_event_count.recordcount#" index="jj">
											<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
									datasets: [{
									label: "<cfoutput>#getLang('main',3)#</cfoutput>",
									backgroundColor: [<cfloop from="1" to="#get_event_count.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
									data: [<cfloop from="1" to="#get_event_count.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
										}]
									},
							options: {}
						});
					</script>
		</div>
</div>

