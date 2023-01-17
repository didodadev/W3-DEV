<table width="100%" height="100%" align="center" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td class="color-border" valign="middle">
      <table width="100%" height="100%" cellpadding="2" cellspacing="1" border="0">
        <tr height="35">
          <td class="color-list" valign="middle">
            <table width="98%" align="center">
              <tr>
                <td valign="bottom" class="headbold"><cf_get_lang no='208.Faks İçeriği Ekle'></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td class="color-row" valign="top">
            <table>
              <cfform name="add_fax_cont" method="POST" action="#request.self#?fuseaction=#xfa.add#">
              <input type="Hidden" name="camp_id" id="camp_id" value="<cfoutput>#camp_id#</cfoutput>">
              <tr>
                <td>&nbsp;&nbsp;&nbsp;<cf_get_lang_main no='68.Başlık'>*
                  <cfsavecontent variable="message"><cf_get_lang_main no='47.Başlık Girmelisiniz !'></cfsavecontent>
                  <cfinput type="text" name="fax_head" style="width:495px;" value="" maxlength="100"  required="yes" message="#message#">
                </td>
              </tr>
              <tr>
                <td>
                    <cfmodule template="/fckeditor/fckeditor.cfm"
                        toolbarSet="WRKContent"
                        basePath="/fckeditor/"
                        instanceName="fax_body"
                        value=""
                        width="535"
                        height="350">
				</td>
              </tr>
              <tr align="center">
                <td  style="text-align:right;"> 
				<cf_workcube_buttons is_upd='0'> 
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  </cfform>
  
</table>

