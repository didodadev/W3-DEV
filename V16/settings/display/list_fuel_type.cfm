<cfquery name="get_fuel" datasource="#dsn#">
	SELECT FUEL_ID,FUEL_NAME,FUEL_DETAIL FROM SETUP_FUEL_TYPE ORDER BY FUEL_ID
</cfquery>
<table cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='1397.Yakıtlar'></td>
  </tr>
  <cfif get_fuel.recordcount>
    <cfoutput query="get_fuel">
      <tr>
        <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
        <td><a href="#request.self#?fuseaction=settings.upd_fuel_type&fuel_id=#fuel_id#" class="tableyazi">#fuel_name#</a></td>
      </tr>
    </cfoutput>
    <cfelse>
    <tr>
      <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
      <td><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
    </tr>
  </cfif>
</table>

