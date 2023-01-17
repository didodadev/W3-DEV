<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
	<cf_date tarih="attributes.startdate">
</cfif>
<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
</cfif>
<cfquery name="get_sec_member_count" datasource="#dsn#">
	SELECT
		COUNT(C.COMPANY_ID) MEMBER_COUNT,
		SC.SECTOR_CAT
	FROM
		COMPANY	C,
		SETUP_SECTOR_CATS SC
	WHERE
		C.COMPANY_STATUS = 1
		AND C.SECTOR_CAT_ID = SC.SECTOR_CAT_ID
		<cfif isdefined ('attributes.finishdate') and len(attributes.finishdate)>
			AND C.RECORD_DATE <= #attributes.finishdate#
		</cfif>
		<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
			AND C.RECORD_DATE >= #attributes.startdate#
		</cfif>
	GROUP BY
		SC.SECTOR_CAT
</cfquery>
<div class="row">
<div class="col col-12 col-xs-12">
	<cfoutput query="get_sec_member_count">
		<cfset 'item_#currentrow#' = "#get_sec_member_count.sector_cat#">
		<cfset 'value_#currentrow#'= "#get_sec_member_count.member_count#">
	</cfoutput>
	<canvas id="myChart6" style="height:100%;"></canvas>
	<script>
		var ctx = document.getElementById('myChart6');
		var myChart6 = new Chart(ctx, {
			type: 'bar',
			data: {
					labels: [<cfloop from="1" to="#get_sec_member_count.recordcount#" index="jj">
							<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
					datasets: [{
					label: "<cfoutput><cf_get_lang dictionary_id='33222.Sektörler'> <cf_get_lang dictionary_id='58673.Müşteriler'></cfoutput>",
					backgroundColor: [<cfloop from="1" to="#get_sec_member_count.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
					data: [<cfloop from="1" to="#get_sec_member_count.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
						}]
					},
			options: {}
		});
	</script>
</div>
</div>
