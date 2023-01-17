<cfsavecontent  variable="head"><cf_get_lang no='166.Aylık KM Raporu'></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cf_basket_form id="km_report">
			<cfinclude template="../form/vehicle_monthly_km_report_frame.cfm">
			
			<!--- <iframe frameborder="0" scrolling="yes" src="<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_vehicle_monthly_km_graph&iframe=1" width="340" height="350" name="fuel_graph" id="fuel_graph"></iframe> --->
		</cf_basket_form>
	</cf_box>
<cf_box title="#head#" uidrop="1">
	<cf_basket id="km_report_bask">
		<!--- <cfinclude  template="list_vehicle_monthly_km.cfm"> --->
		<div id="km_per_month"></div>
		<!--- <iframe frameborder="0" scrolling="no" src="<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_vehicle_monthly_km" width="100%" height="100%" name="km_per_month" id="km_per_month"></iframe> --->
	</cf_basket>
</cf_box>
</div>
<script>
  $(window).load(function(){
	AjaxPageLoad("<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_vehicle_monthly_km_graph","fuel_graph");
	AjaxPageLoad("<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_vehicle_monthly_km","km_per_month");
	});
</script>