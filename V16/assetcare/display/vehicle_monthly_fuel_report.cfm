<cfsavecontent  variable="head"><cf_get_lang no='165.Aylık Yakıt Raporu'></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cf_basket_form id="fuel_report">
			<cfinclude template="../form/vehicle_monthly_fuel_report_frame.cfm">
			<!---  <iframe frameborder="0" scrolling="no" src="<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_vehicle_monthly_fuel_graph&iframe=1" width="340" height="350" name="fuel_graph" id="fuel_graph"></iframe> --->
		</cf_basket_form>
	</cf_box>
	<cf_box title="#head#" uidrop="1">
		<cf_basket id="fuel_report_bask">
			<div id="vehicle_count"></div>
		<!---  <iframe frameborder="0" scrolling="no" src="<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_vehicle_monthly_fuel&iframe=1" width="100%" height="100%" name="vehicle_count" id="vehicle_count"></iframe> --->
		</cf_basket>
	</cf_box>
</div>
<script>
	$(window).load(function(){
	AjaxPageLoad("<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_vehicle_monthly_fuel_graph","fuel_graph");
	AjaxPageLoad("<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_vehicle_monthly_fuel","vehicle_count");
	});
</script>
