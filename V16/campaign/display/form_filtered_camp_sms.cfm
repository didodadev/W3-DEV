<table width="100%" height="100%" align="center" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td class="color-border" valign="middle">
      <table width="100%" height="100%" cellpadding="2" cellspacing="1" border="0">
        <tr height="35">
          <td class="color-list" valign="middle">
            <table width="98%" align="center">
              <tr>
                <td valign="bottom" class="headbold"><cf_get_lang no='140.SMS Gir'></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td class="color-row" valign="top">
            <table>
              <form name="send_sms" method="post" action="<cfoutput>#request.self#?fuseaction=#xfa.add_send#</cfoutput>">
                <input type="Hidden" name="camp_id" id="camp_id" value="<cfoutput>#camp_id#</cfoutput>">
                <input type="Hidden" name="list_cons" id="list_cons" value="<cfoutput>#attributes.list_cons#</cfoutput>">
                <input type="Hidden" name="list_pars" id="list_pars" value="<cfoutput>#attributes.list_pars#</cfoutput>">
                <tr>
                  <td width="100" valign="top"><cf_get_lang_main no='131.Mesaj'></td>
				  <cfsavecontent variable="message"><cf_get_lang_main no='1687.Fazla karakter sayısı'></cfsavecontent>
                  <td><textarea name="sms_body" id="sms_body" cols="40" rows="6" maxlength="147" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea>
                  </td>
                </tr>
                <tr>
                  <td><cf_get_lang no='139.Kalan Karakter'></td>
                  <td><input type="text" name="counter" id="counter" style="width:30px;" value="147" disabled>
                  </td>
                </tr>
                <tr>
                  <td colspan="2"  style="text-align:right;"> 
				  <cfsavecontent variable="message"><cf_get_lang no='12.Kaydet ve Gönder'></cfsavecontent>
				  <cf_workcube_buttons is_upd='0' insert_info='#message#'> 
				  </td>
                </tr>
              </form>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
