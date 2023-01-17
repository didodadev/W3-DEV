<table cellspacing="0" cellpadding="0" border="0" height="100%" width="100%">
  <tr class="color-border">
    <td valign="middle">
      <table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%">
        <tr class="color-list" valign="middle">
          <td height="35">
            <table width="98%" align="center">
              <tr>
                <td class="headbold"><cf_get_lang dictionary_id='37191.Özellik Ekle'></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr class="color-row" valign="top">
          <td>
            <table width="98%" align="center">
              <cfform name="form_upd_not" method="post" action="#request.self#?fuseaction=product.popup_add_property">
              <input type="hidden" name="PRODUCT_CODE" id="PRODUCT_CODE" value="<cfoutput>#url.product_code#</cfoutput>">
              <input type="hidden" name="PRODUCT_ID" id="PRODUCT_ID" value="<cfoutput>#url.pid#</cfoutput>">
              <tr>
                <td><cf_get_lang dictionary_id='57632.Özellik'></td>
              </tr>
              <tr>
                <td>
                  <cfsavecontent variable="message"><cf_get_lang dictionary_id='29741.Özellik girmelisiniz'></cfsavecontent>
				  <cfinput type="text" required="Yes" message="#message#" name="PROPERTY" style="width:200px;">
                </td>
              </tr>
              <tr>
                <td height="30" align="right" style="text-align:right;"> <cf_workcube_buttons is_upd='0'> </td>
              </tr>
            </table>
          </td>
        </tr>
        </cfform>
      </table>
    </td>
  </tr>
</table>
