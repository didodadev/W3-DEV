<cfinclude template="../query/get_target.cfm">
<cfinclude template="../query/get_target_cat.cfm">
<table cellspacing="0" cellpadding="0" border="0" height="100%" width="100%">
  <tr class="color-border">
    <td valign="middle">
      <table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%">
        <tr class="color-list" valign="middle">
          <td height="35">
            <table width="98%" align="center">
              <tr>
                <td valign="bottom" class="headbold"><cf_get_lang no='217.Hedef Düzenle'></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr class="color-row" valign="top">
          <td>
            <table align="center" width="98%" cellpadding="0" cellspacing="0" border="0">
              <tr>
                <td colspan="2">
                  <cfform name="form_upd_target" method="post" action="#request.self#?fuseaction=crm.upd_target">
                    <cfoutput>
                      <input type="Hidden" value="#url.tid#" name="target_id" id="target_id">
                    </cfoutput>
                    <table border="0">
                      <tr>
                        <td width="110"><cf_get_lang_main no='89.Başlama'>*</td>
                        <td>
                          <cfsavecontent variable="message"><cf_get_lang no='48.Başlama Tarihi Girmelisiniz !'></cfsavecontent>
						  <cfinput required="Yes" message="#message#" validate="#validate_style#" type="text" name="startdate" style="width:128px;"   value="#dateformat(get_target.startdate,dateformat_style)#">
						 <cf_wrk_date_image date_field="startdate"></td>
                      </tr>
                      <tr>
                        <td><cf_get_lang_main no='90.Bitiş'>*</td>
                        <td>
                          <cfsavecontent variable="message"><cf_get_lang no='96.Bitiş Tarihi Girmelisiniz !'></cfsavecontent>
						  <cfinput required="Yes" message="#message#" validate="#validate_style#" type="text" name="finishdate" style="width:128px;"   value="#dateformat(get_target.finishdate,dateformat_style)#">
						  <cf_wrk_date_image date_field="finishdate"></td>
                      </tr>
                      <tr>
                        <td><cf_get_lang_main no='74.Kategori'></td>
                        <td>
                          <select name="TARGETCAT_ID" id="TARGETCAT_ID" style="width:150px;">
                            <cfoutput query="get_target_cat">
                              <cfif get_target_cat.TARGETCAT_ID is targetcat_id>
                                <option value="#targetcat_id#" selected>#targetcat_name#
                                <cfelse>
                                <option value="#targetcat_id#">#targetcat_name#
                              </cfif>
                            </cfoutput>
                          </select>
                        </td>
                      </tr>
                      <tr>
                        <td><cf_get_lang no='263.Hedef'>*</td>
                        <td>
                          <input type="text" name="target_head" id="target_head" style="width:150px;" maxlength="100" value="<cfoutput>#get_target.target_head#</cfoutput>">
                        </td>
                      </tr>
                      <tr>
                        <td><cf_get_lang no='264.Rakam'>*</td>
                        <td>
                          <cfsavecontent variable="message"><cf_get_lang no='93.Rakam Girmelisiniz !'></cfsavecontent>
						  <cfinput validate="integer" required="Yes" message="#message#" type="text" name="target_number" style="width:150px;"   value="#get_target.target_number#">
                        </td>
                      </tr>
                      <tr>
                        <td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
                        <td>
                          <textarea name="target_detail" id="target_detail" style="width:305px;height:80;"><cfoutput>#get_target.target_detail#</cfoutput></textarea>
                        </td>
                      </tr>
                      <tr>
                        <td style="text-align:right;" colspan="2">
						<cf_workcube_buttons 
							is_upd='1'  
							delete_page_url='#request.self#?fuseaction=crm.del_popup_target&target_id=#url.tid#' 
							add_function='kontrol()'>
						</td>
                      </tr>
                    </table>
                  </cfform>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<script type="text/javascript">
function kontrol()
{
	return date_check(form_upd_target.startdate,form_upd_target.finishdate,"<cf_get_lang no='270.Başlama Tarihi Bitiş Tarihinden Önce Olmalıdır!'>");
}
</script>
