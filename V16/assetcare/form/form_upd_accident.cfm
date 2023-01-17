<table cellspacing="0" cellpadding="0" width="98%" border="0" align="center" height="100%">
  <tr height="35">
    <td class="headbold"><cf_get_lang no='366.Kazalar'></td>
  </tr>
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0" height="100%">
		<tr class="color-row">
            <td height="150"><iframe name="addform" id="addform" frameborder="0" scrolling="yes" src="<cfoutput>#request.self#?fuseaction=assetcare.popup_upd_kaza&acc_id=#attributes.acc_id#</cfoutput>" width="100%" height="100%"></iframe></td>
		  </tr>
		<tr class="color-row">
          <td><iframe name="kaza_liste" id="kaza_liste" frameborder="0" scrolling="auto" src="<cfoutput>#request.self#?fuseaction=assetcare.popup_list_kaza</cfoutput>" width="100%" height="100%"></iframe></td>
	    </tr>
      </table>
    </td>
  </tr>
</table>
