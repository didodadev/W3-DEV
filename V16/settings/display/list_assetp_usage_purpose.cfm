<cfquery name="get_reasons" datasource="#dsn#">
	SELECT 
		REASON_ID,
		ALLOCATE_REASON
	FROM 
		SETUP_ALLOCATE_REASON
	ORDER BY 
		REASON_ID
</cfquery>
<table cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td class="txtbold" height="20" colspan="2"><cf_get_lang no ='925.Tahsis Nedeni'></td>
  </tr>
  <cfif get_reasons.recordcount>
    <cfoutput query="get_reasons">
      <tr>
        <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
        <td><a href="#request.self#?fuseaction=settings.upd_assetp_usage_purpose&purpose_id=#get_purposes.purpose_id#" class="tableyazi">#usage_purpose#</a></td>
      </tr>
    </cfoutput>
    <cfelse>
    <tr>
      <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
      <td><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
    </tr>
  </cfif>
</table>

