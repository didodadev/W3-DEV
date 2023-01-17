<table cellspacing="0" cellpadding="0" border="0" height="100%" width="100%">
  <tr class="color-border">
    <td valign="middle">
      <table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%">
        <tr class="color-list" valign="middle">
          <td height="35">
            <table width="98%" align="center">
              <tr>
                <td class="headbold"><cf_get_lang dictionary_id='57515.Dosya Ekle'></td>
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
                    <cfoutput>
                    <form name="upload_image" id="upload_image" method="post" action="#request.self#?fuseaction=objects.emptypopup_add_file_toeditor" enctype="multipart/form-data">
                      <input type="hidden" name="module" id="module" value="#attributes.module#">
                      <input type="hidden" name="folder" id="folder" value="#attributes.folder#">
                      </cfoutput>
                      <tr>
                        <td width="100"><cf_get_lang dictionary_id='57691.Dosya'></td>
                        <td>
                          <input type="File" name="dosya" id="dosya" style="width:200px;">
                        </td>
                      </tr>
                      <tr>
                        <td valign="top"><cf_get_lang dictionary_id='32828.Anahtar Kelime'></td>
                        <td>
                          <textarea name="detay" id="detay" style="width:200px;height:60px;"></textarea>
                        </td>
                      </tr>
                      <tr height="35">
                        <td style="text-align:right;" colspan="2">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57582.Ekle'></cfsavecontent>
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
    </td>
  </tr>
</table>

