<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
	<cf_date tarih="attributes.startdate">
</cfif>
<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
</cfif>
<cfif attributes.service_type eq 1>
	<cfquery name="get_service_count" datasource="#dsn3#">
		SELECT
			COUNT(S.SERVICE_ID) SERVICE_COUNT,
			SC.SERVICECAT REPORT_HEAD
		FROM
			SERVICE S,
			SERVICE_APPCAT SC
		WHERE
			S.SERVICECAT_ID = SC.SERVICECAT_ID
			AND SERVICE_ACTIVE = 1
			<cfif isdefined ('attributes.finishdate') and len(attributes.finishdate)>
				AND S.APPLY_DATE <= #attributes.finishdate#
			</cfif>
			<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
				AND S.APPLY_DATE >= #attributes.startdate#
			</cfif>
		GROUP BY
			SC.SERVICECAT		
	</cfquery>
<cfelse>
	<cfquery name="get_service_count" datasource="#dsn3#">
		SELECT
			COUNT(S.SERVICE_ID) SERVICE_COUNT,
			SC.STAGE REPORT_HEAD
		FROM
			SERVICE S,
			#dsn_alias#.PROCESS_TYPE_ROWS SC
		WHERE
			S.SERVICE_STATUS_ID = SC.PROCESS_ROW_ID
			AND SERVICE_ACTIVE = 1
			<cfif isdefined ('attributes.finishdate') and len(attributes.finishdate)>
				AND S.APPLY_DATE <= #attributes.finishdate#
			</cfif>
			<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
				AND S.APPLY_DATE >= #attributes.startdate#
			</cfif>
		GROUP BY
			SC.STAGE		
	</cfquery>
</cfif>
<div class="row">
<div class="col col-6 col-xs-12"></div>
<div class="col col-6 col-xs-12" style="text-align:right;">
	<div class="form-group" id="item-member_type">
		<div class="input-group">
			<select name="service_type" id="service_type" onChange="reload_service();">
				<option value="1" <cfif isdefined("attributes.service_type") and attributes.service_type eq 1>selected</cfif>><cfoutput><cf_get_lang dictionary_id='40177.Kategorilere Göre'></cfoutput></option>
				<option value="2" <cfif isdefined("attributes.service_type") and attributes.service_type eq 2>selected</cfif>><cfoutput><cf_get_lang dictionary_id='40176.Aşamalara Göre'></cfoutput></option>
			</select>
		</div>
	</div>
</div>


<div class="col col-12 col-xs-12">
	<cfoutput query="get_service_count">
		<cfset 'item_#currentrow#' = "#get_service_count.report_head#">
		<cfset 'value_#currentrow#' = "#get_service_count.service_count#">
	</cfoutput>
	<canvas id="myChart7" style="height:100%;"></canvas>
	<script>
		var ctx = document.getElementById('myChart7');
		var myChart7 = new Chart(ctx, {
			type: 'doughnut',
			data: {
					labels: [<cfloop from="1" to="#get_service_count.recordcount#" index="jj">
							<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
					datasets: [{
					label: "<cfoutput>#getLang('call',87)#</cfoutput>",
					backgroundColor: [<cfloop from="1" to="#get_service_count.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
					data: [<cfloop from="1" to="#get_service_count.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
						}]
					},
			options: {}
		});
	</script>
			</div>
</div>
<script type="text/javascript">
	function reload_service()
	{
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report</cfoutput>.popup_service_summary&service_type='+document.all.service_type.value+'&startdate='+document.all.startdate.value+'&finishdate='+document.all.finishdate.value+'','service_summary');
	}
</script>
