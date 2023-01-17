<cfparam name="attributes.sms_code" default="0">
<cfparam name="attributes.sms_tel" default="0">
<table width="100%" height="100%" align="center" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td class="color-border" valign="middle">
      <table width="100%" height="100%" cellpadding="2" cellspacing="1" border="0">
        <tr height="35">
          <td class="color-list" valign="middle">
            <table width="98%" align="center">
              <tr>
                <td valign="bottom" class="headbold"><cf_get_lang_main no='75.Devam'><cf_get_lang_main no='1178.SMS Gönder'></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td class="color-row" valign="top"> <br/>
            <table>
              <form name="send_sms" method="post" action="<cfoutput>#request.self#?fuseaction=#xfa.send#</cfoutput>">
                <input type="Hidden" name="sms_cont_id"  id="sms_cont_id" value="<cfoutput>#attributes.sms_cont_id#</cfoutput>">
                <cfif isdefined("attributes.consumer_id")>
                  <input type="Hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
                </cfif>
                <cfif isdefined("attributes.partner_id")>
                  <input type="Hidden" name="partner_id" id="partner_id" value="<cfoutput>#attributes.partner_id#</cfoutput>">
                </cfif>
                <tr>
                  <td><cf_get_lang no='52.Telefon Numarası'></td>
                  <td>
                    <input type="text" name="sms_code" id="sms_code" maxlength="3" style="width:30px;" value="<cfoutput>#attributes.sms_code#</cfoutput>">
                    <input type="text" name="sms_tel" id="sms_tel" maxlength="7	" style="width:70px;" value="<cfoutput>#attributes.sms_tel#</cfoutput>">
                  </td>
                </tr>
                <tr>
                  <td width="100" valign="top"><cf_get_lang_main no='131.Mesaj'></td>
                  <td>
					<cfsavecontent variable="message"><cf_get_lang_main no='1687.Fazla karakter sayısı'></cfsavecontent>
				  	<textarea name="sms_body" id="sms_body" cols="40" rows="6" maxlength="147" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"><cfoutput>#sms_cont.sms_body#</cfoutput></textarea>
                  </td>
                </tr>
                <tr>
                  <td><cf_get_lang no='139.Kalan Karakter'></td>
                  <td><input type="text" name="counter" id="counter" style="width:30px;" value="147" disabled>
                  </td>
                </tr>
                <tr>
                  <td colspan="2"  style="text-align:right;"> 
				  <cfsavecontent variable="message"><cf_get_lang_main no='1331.Gönder'></cfsavecontent>
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
