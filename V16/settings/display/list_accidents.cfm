<cfquery name="get_accidents" datasource="#dsn#">
	SELECT 
				* 
	FROM 
			SETUP_ACCIDENT_TYPE
</cfquery>

<table cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='988.Tipler'></td>
  </tr>
  <cfif get_accidents.recordcount>
    <cfoutput query="get_accidents">
      <tr>
        <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
        <td><a href="#request.self#?fuseaction=settings.form_upd_accidents&accident_type_id=#accident_type_id#" class="tableyazi">#ACCIDENT_TYPE_NAME#</a></td>
      </tr>
    </cfoutput>
    <cfelse>
    <tr>
      <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
      <td><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
    </tr>
  </cfif>
</table>

