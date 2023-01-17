      <table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%" class="color-border" align="center">
        <tr class="color-list" valign="middle">
          <td height="35">
		  	<table width="98%" align="center">
              <tr>
                <td width="48%" valign="bottom" class="headbold"><cf_get_lang no='1391.Özel Sigorta Şirketi Ekle'></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr class="color-row" valign="top">
          <td>
            <table align="center" width="98%" cellpadding="0" cellspacing="0" border="0">
              <tr>
                <td colspan="2">
                  <table>
                    <cfform action="#request.self#?fuseaction=settings.emptypopup_add_insurance_company" method="post">
                      <tr>
                        <td><cf_get_lang no='1123.Kurum Adı'> *</td>
                        <td><cfsavecontent variable="message2"><cf_get_lang no='1371.Kurum Adı Girmelisiniz'>!</cfsavecontent>
                          <cfinput type="Text" name="company_name" style="width:200px;"  maxlength="50" required="Yes" message="#message2#"></td>
                      </tr>
                      <tr>
                        <td><cf_get_lang_main no='359.Detay'></td>
                        <td><textarea name="company_detail" id="company_detail" style="width:200px;height:60"></textarea></td>
                      </tr>
                      <tr height="35">
                        <td>&nbsp;</td>
                        <td><cf_workcube_buttons is_upd='0'></td>
                      </tr>
                    </cfform>
                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
