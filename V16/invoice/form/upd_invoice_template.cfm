<cfquery name="get_template" datasource="#dsn3#">
	 SELECT FORM_ID,NAME,ACTIVE,RECORD_DATE,RECORD_EMP,TEMPLATE_FILE FROM PRINTFORM_INVOICE WHERE FORM_ID = #ATTRIBUTES.FORM_ID#
</CFQUERY>
<table cellspacing="0" cellpadding="0" border="0" height="100%" width="100%">
  <tr class="color-border">
    <td valign="middle">
      <cfform action="#request.self#?fuseaction=invoice.emptypopup_upd_invoice_template" name="add_invoice_template" method="post" enctype="multipart/form-data">
	  <input type="hidden" name="form_id" id="form_id" value="<cfoutput>#ATTRIBUTES.FORM_ID#</cfoutput>"> 
	  <table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%">
        <tr class="color-list" valign="middle">
          <td height="35" class="headbold">&nbsp;<cf_get_lang dictionary_id='47566.Baskı Formu'></td>
        </tr>
        <tr class="color-row" valign="top">
          <td>
            <table align="center" width="99%" border="0">
              <tr>
                <td><cf_get_lang dictionary_id='57756.Durum'></td>
                <td><input name="active" id="active" type="checkbox" value="1" <cfif get_template.active eq 1>checked</cfif>> Aktif</td>
              </tr>
              <tr>
                <td width="100"><cf_get_lang dictionary_id='58820.Başlık'> *</td>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58059.Başlık Girmelisiniz'></cfsavecontent>
                <td><cfinput type="text" name="template_head" value="#get_template.name#" style="width:150px;" required="yes" message="!"></td>
              </tr>
			<input type="hidden" name="old_template_file" id="old_template_file" value="<cfoutput>#get_template.template_file#</cfoutput>">
			<!---   <tr>
                <td>Eski Dosya</td>
                <td><cfoutput>#get_template.template_file#</cfoutput> </td>                
              </tr> --->
			   <tr>
                <td><cf_get_lang dictionary_id='57691.Dosya'></td>
                <td><input type="file" name="template_file" id="template_file" style="width:150px;"></td>                
              </tr>
              <tr>
                <td></td>
                <td><cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=invoice.emptypopup_del_invoice_template&form_id=#get_template.form_id#&old_template_file=#get_template.template_file#'></td>
              </tr>
            </table>
            </cfform>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
