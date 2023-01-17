<table cellspacing="0" cellpadding="0" border="0" height="100%" width="100%">
  <tr class="color-border">
    <td valign="middle">
      <cfform action="#request.self#?fuseaction=invoice.emptypopup_add_invoice_template" name="add_invoice_template" method="post" enctype="multipart/form-data">
	  <table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%">
        <tr class="color-list" valign="middle">
          <td height="35" class="headbold">&nbsp;<cf_get_lang dictionary_id="47566.Baskı Formu"> <cf_get_lang dictionary_id='44630.Ekle'></td>
        </tr>
        <tr class="color-row" valign="top">
          <td>
            <table align="center" width="99%" border="0">
              <tr>
                <td><cf_get_lang dictionary_id="57756.Durum"></td>
                <td><input name="active" id="active" type="checkbox" value="1"><cf_get_lang dictionary_id="57493.Aktif"></td>
              </tr>
              <tr>
                <td width="100"><cf_get_lang dictionary_id="58820.Başlık"> *</td>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id="58059.Başlık Girmelisiniz">!</cfsavecontent>
                <td><cfinput type="text" name="template_head" value="" style="width:150px;" required="yes" message="#message#"></td>
              </tr>
              <tr>
                <td><cf_get_lang dictionary_id="57691.Dosya"></td>
                <td><input type="file" name="template_file" id="template_file" style="width:150px;"> </td>                
              </tr>
			  <tr>
                <td></td>
                <td><cf_workcube_buttons is_upd='0'></td>
			</tr>
            </table>
            </cfform>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
