<table cellspacing="0" cellpadding="0" width="98%" border="0" align="center" height="100%">
  <tr height="35">
    <td class="headbold"><cf_get_lang no='183.Bakım Refarans Arama'></td>
    <td style="text-align:right;"> 
  </tr>
  <tr valign="top" class="color-border">
    <td colspan="2">
      <table cellspacing="1" cellpadding="2" width="100%" border="0" height="100%">
        <tr class="color-row">
          <td height="65"><cfinclude template="search_care_reference.cfm"></td>
        </tr>
        <tr class="color-row">
          <td><iframe name="frame_care_reference_search" id="frame_care_reference_search" frameborder="0" scrolling="auto" src="<cfoutput>#request.self#?fuseaction=assetcare.popup_list_care_ref_search</cfoutput>&iframe=1" width="100%" height="100%"></iframe>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>

