<!--- form_add_target.cfm --->
<cfinclude template="../query/get_target_cat.cfm">
<cfinclude template="../query/get_partner_det.cfm">
<table cellspacing="0" cellpadding="0" border="0" height="100%" width="100%">
  <tr class="color-border">
    <td valign="middle">
      <table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%">
        <tr class="color-list" valign="middle">
          <td height="35">
            <table width="98%" align="center">
              <tr>
                <td valign="bottom" class="headbold"><cf_get_lang no='198.Hedef Ekle'></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr class="color-row" valign="top">
          <td>
            <table align="center" width="98%" cellpadding="0" cellspacing="0" border="0">
              <tr>
                <td colspan="2">
                  <cfform name="form_upd_target" method="post" action="#request.self#?fuseaction=crm.add_target">
                    <cfoutput>
                      <cfif isdefined("url.pid")>
                        <input type="Hidden" value="#url.pid#" name="partner_id" id="partner_id">
                        <cfelseif isdefined("url.bid")>
                        <input type="Hidden" value="#url.bid#" name="branch_id" id="branch_id">
                        <cfelseif isdefined("url.cid")>
                        <input type="Hidden" value="#url.cid#" name="company_id" id="company_id">
                      </cfif>
                    </cfoutput>
                    <table border="0">
                      <tr>
                        <td width="110"><cf_get_lang_main no='89.Başlama'>*</td>
                        <td>
                          <cfsavecontent variable="message"><cf_get_lang no='48.Başlama Tarihi Girmelisiniz !'></cfsavecontent>
                          <cfinput required="Yes" validate="#validate_style#" message="#message#" type="text" name="startdate" style="width:128px;"  >
                          <cf_wrk_date_image date_field="startdate"></td>
                      </tr>
                      <tr>
                        <td width="110"><cf_get_lang_main no='90.Bitiş'>*</td>
                        <td>
                          <cfsavecontent variable="message"><cf_get_lang no='96.Bitiş Tarihi Girmelisiniz !'></cfsavecontent>
                          <cfinput required="Yes" validate="#validate_style#" message="#message#" type="text" name="finishdate" style="width:128px;"  >
                          <cf_wrk_date_image date_field="finishdate"></td>
                      </tr>
                      <tr>
                        <td width="110"><cf_get_lang no='262.Hedef Kategorisi'></td>
                        <td>
                          <select name="TARGETCAT_ID" id="TARGETCAT_ID" style="width:150px;">
                            <cfoutput query="get_target_cat">
                              <option value="#targetcat_id#">#targetcat_name# 
                            </cfoutput>
                          </select>
                        </td>
                      </tr>
                      <tr>
                        <td width="110"><cf_get_lang no='263.Hedef'>*</td>
                        <td>
                          <cfsavecontent variable="message"><cf_get_lang no='94.Hedef Girmelisiniz !'></cfsavecontent>
                          <cfinput required="Yes" message="#message#" type="text" name="target_head" style="width:150px;" maxlength="100"  >
                        </td>
                      </tr>
                      <tr>
                        <td width="110"><cf_get_lang no='264.Rakam'>*</td>
                        <td>
                          <cfsavecontent variable="message"><cf_get_lang no='93.Rakam Girmelisiniz'></cfsavecontent>
                          <cfinput type="text" name="target_number" validate="integer" required="Yes" message="#message#" style="width:150px;"  >
                        </td>
                      </tr>
                      <tr>
                        <td width="110" valign="top"><cf_get_lang_main no='217.Açıklama'></td>
                        <td>
                          <textarea name="target_detail" id="target_detail" style="width:305px;height:80;"></textarea>
                        </td>
                      </tr>
                      <tr>
                        <td colspan="2" style="text-align:right;" valign="top" style="text-align:right;"> 
						<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
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
	return date_check(form_upd_target.startdate,form_upd_target.finishdate,"<cf_get_lang no ='418.Başlama Tarihi Bitiş Tarihinden Önce Olmalıdır'>!");
}
</script>

