<cfquery name="GET_OPPORTUNITY_TYPES" datasource="#dsn3#">
	SELECT
		OPPORTUNITY_TYPE_ID,
		OPPORTUNITY_TYPE,
		OPPORTUNITY_TYPE_DETAIL
	FROM
		SETUP_OPPORTUNITY_TYPE
	ORDER BY
		OPPORTUNITY_TYPE
</cfquery>

<table width="200" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang_main no='1282.Fırsatlar'></td>
  </tr>
  <cfif get_opportunity_types.recordcount>
    <cfoutput query="get_opportunity_types">
      <tr>
        <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
        <td width="180"><a href="#request.self#?fuseaction=settings.form_upd_opportunity_type&opportunity_type_id=#opportunity_type_id#" class="tableyazi">#opportunity_type#</a></td>
      </tr>
    </cfoutput>
    <cfelse>
    <tr>
      <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
      <td width="180" align="left"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
    </tr>
  </cfif>
</table>
