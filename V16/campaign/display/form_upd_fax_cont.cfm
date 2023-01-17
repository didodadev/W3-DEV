<script type="text/javascript">
function open_temp()
{
	temp = 1;
	if (upd_fax_cont.template_id[0].checked) temp = 1
	if (upd_fax_cont.template_id[1].checked) temp = 2
	if (upd_fax_cont.template_id[2].checked) temp = 3
	<cfoutput>
	windowopen('#request.self#?fuseaction=campaign.popup_dsp_fax_temp&fax_cont_id=#fax_cont_id#&temp_id='+temp);
	page.close();
	</cfoutput>
}
</script>
<table width="100%" height="100%" align="center" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td class="color-border" valign="middle">
      <table width="100%" height="100%" cellpadding="2" cellspacing="1" border="0">
        <tr height="35">
          <td class="color-list" valign="middle">
            <table width="98%" align="center">
              <tr>
                <td valign="bottom" class="headbold"><cf_get_lang no='141.Fax İçeriği'></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td class="color-row" valign="top">
            <table>
              <cfform name="upd_fax_cont" method="POST" action="#request.self#?fuseaction=#xfa.upd#">
                <input type="Hidden" name="camp_id" id="camp_id" value="<cfoutput>#fax_cont.camp_id#</cfoutput>">
                <input type="Hidden" name="fax_cont_id" id="fax_cont_id" value="<cfoutput>#fax_cont_id#</cfoutput>">
                <tr>
                  <td>&nbsp;&nbsp;&nbsp;<cf_get_lang_main no='68.Başlık'>*
                    <cfsavecontent variable="message"><cf_get_lang_main no='47.Başlık Girmelisiniz !'></cfsavecontent>
                    <cfinput type="text" name="fax_head" style="width:495px;" value="#fax_cont.fax_head#" maxlength="100" required="yes" message="#message#">
                  </td>
                </tr>
                <tr>
                  <td>
					<cfmodule
						template="/fckeditor/fckeditor.cfm"
						toolbarSet="WRKContent"
						basePath="/fckeditor/"
						instanceName="fax_body"
						value="#fax_cont.fax_body#"
						width="675"
						height="350">
				  </td>
                </tr>
                <tr>
                  <td height="35"  style="text-align:right;"> 
				  <cf_workcube_buttons 
					is_upd='1' 
					delete_page_url='#request.self#?fuseaction=#xfa.del#&fax_cont_id=#attributes.fax_cont_id#'> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </td>
                </tr>
              </cfform>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>

