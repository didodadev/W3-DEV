<cfinclude template="../query/get_det_correspondence.cfm">
<cfif fuseaction contains "popup">
  <cfset is_popup=1>
<cfelse>
  <cfset is_popup=0>
</cfif>
<table width="590">
  <tr>
    <td align="right" style="text-align:right;">
	<cfoutput>#dateformat(NOW(),dateformat_style)#</cfoutput> <STRONG><cf_get_lang no='57.Tarihli Genel Yazışma'></STRONG></td>
  </tr>
</table>
<table width="590">
  <tr>
    <td width="75" class="txtbold" colspan="2">
	<cf_get_lang_main no='71.Kayıt'> : 
      <cfoutput>#session.ep.name# #session.ep.surname#</cfoutput></td>
  </tr>
  <tr>
    <td class="txtbold"><cf_get_lang_main no='74.Kategori'></td>
    <td>:
      <cfif GET_DET_CORRESPONDENCE.category eq 1>
        <cf_get_lang_main no='67.Bilgi Notu'>
      <cfelseif GET_DET_CORRESPONDENCE.category eq 2>
        <cf_get_lang no='56.Talep'>
      </cfif>
    </td>
  </tr>
  <tr>
    <td class="txtbold"><cf_get_lang_main no='68.Konu'></td>
    <td>: <cfoutput>#GET_DET_CORRESPONDENCE.subject#</cfoutput></td>
  </tr>
</table>
<table width="590">
  <tr>
    <td class="headbold">
      <hr>
    </td>
  </tr>
  <tr>
    <td><cfoutput>#GET_DET_CORRESPONDENCE.message#</cfoutput></td>
  </tr>
</table>
