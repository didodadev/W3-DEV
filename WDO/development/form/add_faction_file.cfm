<cfquery name="get_assets" datasource="#dsn_dev#">
SELECT * FROM FUSEACTION_FILES
</cfquery>
<table cellSpacing="0" cellpadding="0" width="98%" border="0">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
        <tr class="color-header">
          <td height="22" class="form-title"><cf_get_lang no='132.Files'></td>
          <td align="center" width="15"> <a href="#" onclick="windowopen('<cfoutput>#request.self#?fuseaction=dev.popup_add_faction_file&faction_id=#ATTRIBUTES.faction_id#</cfoutput>','small');"><img src="/images/plus_square.gif" alt="<cf_get_lang no='133.File Add'>" border="0" title="<cf_get_lang no='133.File Add'>" style="cursor:pointer"></a></td>
        </tr>
        <cfif get_assets.recordcount>
          <cfoutput query="get_assets">
            <cfset upd_file_id=#file_id#>
            <tr class="color-row">
              <td align="left"><a href="javascript://" onclick="windowopen('#file_web_path#development/#file_name#','medium')" class="tableyazi">#file_name#</a>
              <td align="center"> <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=dev.popup_upd_faction_file&ID2=#upd_file_id#&faction_id=#ATTRIBUTES.faction_id#','small');"><img src="/images/update_list.gif" alt="<cf_get_lang no='134.Update'>" border="0" title="<cf_get_lang no='134.Update'>"></a></td>
            </tr>
          </cfoutput>
          <cfelse>
          <tr class="color-row">
            <td></td>
            <td colspan="2">&nbsp;</td>
          </tr>
        </cfif>
      </table>
    </td>
  </tr>
</table>

