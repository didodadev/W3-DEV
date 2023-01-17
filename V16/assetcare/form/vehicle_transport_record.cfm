<table cellspacing="0" cellpadding="0" width="98%" border="0" align="center" height="100%">
  <tr height="35">
    <td class="headbold"><cf_get_lang no='157.Nakliye Kayıt'></td>
  </tr>
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0" height="100%">
        <tr class="color-row">
          <td height="160"><iframe name="addform" id="addform" frameborder="0" scrolling="auto" src="<cfoutput>#request.self#?fuseaction=assetcare.popup_add_vehicle_transport_record</cfoutput>&iframe=1" width="100%" height="100%"></iframe></td>
        </tr>
        <tr class="color-row">
          <td><iframe name="transport_list" id="transport_list" frameborder="0" scrolling="auto" src="<cfoutput>#request.self#?fuseaction=assetcare.popup_list_vehicle_transport_record</cfoutput>&iframe=1" width="100%" height="100%"></iframe>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
