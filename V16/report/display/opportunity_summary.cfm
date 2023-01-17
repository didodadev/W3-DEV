<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
	<cf_date tarih="attributes.startdate">
</cfif>
<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
</cfif>
<cfif attributes.opp_type eq 1>
	<cfquery name="get_opp_count" datasource="#dsn3#">
		SELECT
			COUNT(OPP.OPP_ID) OPP_COUNT,
			SC.PROBABILITY_NAME REPORT_HEAD
		FROM
			OPPORTUNITIES OPP,
			SETUP_PROBABILITY_RATE SC
		WHERE
			SC.PROBABILITY_RATE_ID = OPP.PROBABILITY
			AND OPP_STATUS = 1
			<cfif isdefined ('attributes.finishdate') and len(attributes.finishdate)>
				AND OPP_DATE <= #attributes.finishdate#
			</cfif>
			<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
				AND OPP_DATE >= #attributes.startdate#
			</cfif>
		GROUP BY
			SC.PROBABILITY_NAME		
	</cfquery>
<cfelseif attributes.opp_type eq 2> <!--- Aşamalara Göre --->
	<cfquery name="get_opp_count" datasource="#dsn3#">
		SELECT
			COUNT(OPP.OPP_ID) OPP_COUNT,
			SC.STAGE REPORT_HEAD
		FROM
			OPPORTUNITIES OPP,
			#dsn_alias#.PROCESS_TYPE_ROWS SC
		WHERE
			SC.PROCESS_ROW_ID = OPP.OPP_STAGE
			AND OPP_STATUS = 1
			<cfif isdefined ('attributes.finishdate') and len(attributes.finishdate)>
				AND OPP_DATE <= #attributes.finishdate#
			</cfif>
			<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
				AND OPP_DATE >= #attributes.startdate#
			</cfif>
		GROUP BY
			SC.STAGE		
	</cfquery>
<cfelseif attributes.opp_type eq 3> <!--- Kategoriye Göre --->
	<cfquery name="get_opp_count" datasource="#dsn3#">
		SELECT
			COUNT(OPP.OPP_ID) OPP_COUNT,
			SOT.OPPORTUNITY_TYPE REPORT_HEAD
		FROM
			OPPORTUNITIES OPP,
			SETUP_OPPORTUNITY_TYPE SOT
		WHERE
			SOT.OPPORTUNITY_TYPE_ID = OPP.OPPORTUNITY_TYPE_ID
			AND OPP_STATUS = 1
			<cfif isdefined ('attributes.finishdate') and len(attributes.finishdate)>
				AND OPP_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
			</cfif>
			<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
				AND OPP_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
			</cfif>
		GROUP BY
			SOT.OPPORTUNITY_TYPE		
	</cfquery>
</cfif>

<div class="row">
	<div class="col col-6 col-xs-12"></div>
	<div class="col col-6 col-xs-12" style="text-align:right;">
		<div class="form-group" id="item-member_type">
			<div class="input-group">
				<select name="opp_type" id="opp_type" onChange="reload_opp();">
					<option value="1" <cfif isdefined("attributes.opp_type") and attributes.opp_type eq 1>selected</cfif>><cf_get_lang dictionary_id='58652.Olasılık'></option>
					<option value="2" <cfif isdefined("attributes.opp_type") and attributes.opp_type eq 2>selected</cfif>><cf_get_lang dictionary_id='40176.Aşamalara Göre'></option>
					<option value="3" <cfif isdefined("attributes.opp_type") and attributes.opp_type eq 3>selected</cfif>><cf_get_lang dictionary_id='40177.Kategorilere Göre'></option>
				</select>
			</div>
		</div>
	</div>
	<div class="col col-12 col-xs-12">
				<cfoutput query="get_opp_count">
					<cfset 'item_#currentrow#' = "#get_opp_count.report_head#">
					<cfset 'value_#currentrow#' = "#get_opp_count.opp_count#">
				</cfoutput>
				<canvas id="myChart4" style="height:100%;"></canvas>
					<script>
						var ctx = document.getElementById('myChart4');
						var myChart4 = new Chart(ctx, {
							type: 'pie',
							data: {
									labels: [<cfloop from="1" to="#get_opp_count.recordcount#" index="jj">
										<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
									datasets: [{
									label: "<cfoutput>#getLang('main',200)#</cfoutput>",
									backgroundColor: [<cfloop from="1" to="#get_opp_count.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
									data: [<cfloop from="1" to="#get_opp_count.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
										}]
									},
							options: {}
						});
					</script>  
	</div>
</div>
<script type="text/javascript">
	function reload_opp()
	{
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=report.popup_opp_summary&opp_type='+document.all.opp_type.value+'&startdate='+document.all.startdate.value+'&finishdate='+document.all.finishdate.value+'','opp_summary');
	}
</script>
