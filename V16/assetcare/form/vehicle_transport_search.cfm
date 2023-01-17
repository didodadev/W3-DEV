<table class="dph">
  	<tr>
    	<td class="detailhead"><a href="javascript:gizle_goster_ikili('transport_search','transport_search_bask');">&raquo;</a><cf_get_lang no='180.Nakliye Arama'></td>
	</tr>
</table>
<cf_basket_form id="transport_search">
  	<cfinclude template="vehicle_transport_search_frame.cfm">
</cf_basket_form>
<cf_basket id="transport_search_bask">
	<iframe name="transport_list" id="transport_list" frameborder="0" style="position:absolute;" src="<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_vehicle_transport_search&&iframe=1" width="100%" height="100%"></iframe>
</cf_basket>
