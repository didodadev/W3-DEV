<cfsavecontent variable="ay1"><cf_get_lang dictionary_id ='57592.Ocak'></cfsavecontent>
<cfsavecontent variable="ay2"><cf_get_lang dictionary_id ='57593.Şubat'></cfsavecontent>
<cfsavecontent variable="ay3"><cf_get_lang dictionary_id ='57594.Mart'></cfsavecontent>
<cfsavecontent variable="ay4"><cf_get_lang dictionary_id ='57595.Nisan'></cfsavecontent>
<cfsavecontent variable="ay5"><cf_get_lang dictionary_id ='57596.Mayıs'></cfsavecontent>
<cfsavecontent variable="ay6"><cf_get_lang dictionary_id ='57597.Haziran'></cfsavecontent>
<cfsavecontent variable="ay7"><cf_get_lang dictionary_id ='57598.Temmuz'></cfsavecontent>
<cfsavecontent variable="ay8"><cf_get_lang dictionary_id ='57599.Ağustos'></cfsavecontent>
<cfsavecontent variable="ay9"><cf_get_lang dictionary_id ='57600.Eylül'></cfsavecontent>
<cfsavecontent variable="ay10"><cf_get_lang dictionary_id ='57601.Ekim'></cfsavecontent>
<cfsavecontent variable="ay11"><cf_get_lang dictionary_id ='57602.Kasım'></cfsavecontent>
<cfsavecontent variable="ay12"><cf_get_lang dictionary_id ='57603.Aralık'></cfsavecontent>
<cfset aylar = "#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#">
<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
	<cf_date tarih="attributes.startdate">
</cfif>
<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
</cfif>
<cfif attributes.offer_type eq 1>
	<cfquery name="get_offer_count" datasource="#dsn3#">
		SELECT
			COUNT(O.OFFER_ID) OFFER_COUNT,
			SC.STAGE REPORT_HEAD
		FROM
			OFFER O,
			#dsn_alias#.PROCESS_TYPE_ROWS SC
		WHERE
			SC.PROCESS_ROW_ID = O.OFFER_STAGE
			AND ((O.PURCHASE_SALES = 1 AND O.OFFER_ZONE = 0) OR (O.PURCHASE_SALES = 0 AND O.OFFER_ZONE = 1))
			AND OFFER_STATUS = 1
			<cfif isdefined ('attributes.finishdate') and len(attributes.finishdate)>
				AND OFFER_DATE <= #attributes.finishdate#
			</cfif>
			<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
				AND OFFER_DATE >= #attributes.startdate#
			</cfif>
		GROUP BY
			SC.STAGE		
	</cfquery>
<cfelse>
	<cfquery name="get_offer_count" datasource="#dsn3#">
		SELECT
			SUM(O.PRICE) PRICE,
			MONTH(O.OFFER_DATE) MONTH
		FROM
			OFFER O
		WHERE
			((O.PURCHASE_SALES = 1 AND O.OFFER_ZONE = 0) OR (O.PURCHASE_SALES = 0 AND O.OFFER_ZONE = 1))
			AND OFFER_STATUS = 1
			<cfif isdefined ('attributes.finishdate') and len(attributes.finishdate)>
				AND OFFER_DATE <= #attributes.finishdate#
			</cfif>
			<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
				AND OFFER_DATE >= #attributes.startdate#
			</cfif>
		GROUP BY
			MONTH(O.OFFER_DATE)
	</cfquery>
</cfif>
	<div class="row">
		<div class="col col-6 col-xs-12"></div>
		<div class="col col-6 col-xs-12" style="text-align:right;">
			<div class="form-group" id="item-member_type">
				<div class="input-group">
					<select name="offer_type" id="offer_type" onChange="reload_offer();">
						<option value="1" <cfif isdefined("attributes.offer_type") and attributes.offer_type eq 1>selected</cfif>><cfoutput><cf_get_lang dictionary_id='40176.Aşamalara Göre'></cfoutput></option>
						<option value="2" <cfif isdefined("attributes.offer_type") and attributes.offer_type eq 2>selected</cfif>><cfoutput><cf_get_lang dictionary_id='40698.Ay Bazında'> <cf_get_lang dictionary_id='32840.Teklif Tutarı'></cfoutput></option>
					</select>
				</div>
			</div>
		</div>
	
		<div class="col col-12 col-xs-12">
			<cfif attributes.offer_type eq 1>
						<cfoutput query="get_offer_count">
							<cfset 'item_#currentrow#' = "#get_offer_count.report_head#">
							<cfset 'value_#currentrow#' = "#get_offer_count.offer_count#">
						</cfoutput>
						<canvas id="myChart5" style="height:100%;"></canvas>
						<script>
							var ctx = document.getElementById('myChart5');
							var myChart5 = new Chart(ctx, {
								type: 'line',
								data: {
										labels: [<cfloop from="1" to="#get_offer_count.recordcount#" index="jj">
											<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
										datasets: [{
										label: "<cfoutput>#getLang('main',133)#</cfoutput>",
										backgroundColor: [<cfloop from="1" to="#get_offer_count.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
										data: [<cfloop from="1" to="#get_offer_count.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
											}]
										},
								options: {}
							});
						</script>
			<cfelse>
					<cfoutput query="get_offer_count">
						<cfset 'item_#currentrow#'="#listgetat(aylar,get_offer_count.month,',')#">
						<cfset 'value_#currentrow#'="#get_offer_count.price#">
					</cfoutput>
					<canvas id="myChart5" style="height:100%;"></canvas>
					<script>
						var ctx = document.getElementById('myChart5');
						var myChart5 = new Chart(ctx, {
							type: 'line',
							data: {
									labels: [<cfloop from="1" to="#get_offer_count.recordcount#" index="jj">
										<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
									datasets: [{
									label: "Teklif",
									backgroundColor: [<cfloop from="1" to="#get_offer_count.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
									data: [<cfloop from="1" to="#get_offer_count.recordcount#" index="jj"><cfoutput>"#evaluate("value_#jj#")#"</cfoutput>,</cfloop>],
										}]
									},
							options: {}
						});
					</script>
			</cfif>
		</div>
</div>
<script type="text/javascript">
	function reload_offer()
	{
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=report</cfoutput>.popup_offer_summary&offer_type='+document.all.offer_type.value+'&startdate='+document.all.startdate.value+'&finishdate='+document.all.finishdate.value+'','offer_summary');
	}
</script>
