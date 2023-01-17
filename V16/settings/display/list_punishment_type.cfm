<cfquery name="GET_PUNISHMENT_TYPES" datasource="#DSN#">
	SELECT
		*
	FROM
		SETUP_PUNISHMENT_TYPE
</cfquery>

<table cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td class="txtbold" height="20" colspan="2"><cf_get_lang dictionary_id='42971.Tipler'></td>
  </tr>
  <cfif get_punishment_types.recordcount>
    <cfoutput query="get_punishment_types">
      <tr>
        <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
        <td><a href="#request.self#?fuseaction=settings.form_upd_punishment_type&punishment_type_id=#punishment_type_id#" class="tableyazi">#punishment_type_name#</a></td>
      </tr>
    </cfoutput>
    <cfelse>
    <tr>
      <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
      <td><font class="tableyazi"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</font></td>
    </tr>
  </cfif>
</table>
