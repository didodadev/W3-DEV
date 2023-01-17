<table cellspacing="0" cellpadding="0" width="98%" border="0" align="center" height="100%">
  <tr height="35">
    <td class="headbold"><cf_get_lang no='180.Nakliye Arama'></td>
  </tr>
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0" height="100%">
		<tr class="color-row">
          <td height="125"><cfinclude template="vehicle_count_search_frame.cfm"></td>
	    </tr>
		<tr class="color-row">
           <td><iframe frameborder="0" scrolling="auto" src="<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_vehicle_transport_search&&iframe=1" width="100%" height="100%" name="transport_list" id="transport_list"></iframe>
	    </tr>
      </table>
    </td>
  </tr>
</table>
