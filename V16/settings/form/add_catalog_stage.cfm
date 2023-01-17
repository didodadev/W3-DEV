<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td height="35" class="headbold"><cf_get_lang no='294.Katalog Aşaması Ekle'></td>
  </tr>
</table>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr class="color-border">
    <td>
      <table width="100%" border="0" cellspacing="1" cellpadding="2">
        <tr class="color-row">
          <td width="200" valign="top"><cfinclude template="../display/list_catalog_stage.cfm">
          </td>
          <td valign="top">
            <table border="0">
              <cfform action="#request.self#?fuseaction=settings.emptypopup_add_catalog_stage" method="post" name="position">
                <tr>
                  <td width="100"><cf_get_lang_main no='68.Başlık'><font color=red>*</font> </td>
                  <td>
                    <cfsavecontent variable="message"><cf_get_lang_main no='647.Başlık girmelisiniz'></cfsavecontent>
					<cfinput type="Text" name="stage_name" style="width:200px;" value="" maxlength="50" required="Yes" message="#message#">
                  </td>
                </tr>
                <tr>
                  <td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
                  <td>
                    <textarea name="detail" id="detail" style="width:200px;height:60px;"></textarea>
                  </td>
                </tr>
                <tr>
                  <td height="35" colspan="2" align="right" style="text-align:right;">
				  <cf_workcube_buttons is_upd='0'>
                  </td>
                </tr>
              </cfform>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>

