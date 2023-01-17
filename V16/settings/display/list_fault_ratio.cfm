<cfquery name="GET_FAULT_RATIOS" datasource="#DSN#">
	SELECT
		*
	FROM
		SETUP_FAULT_RATIO
</cfquery>

<table cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td class="txtbold" height="20" colspan="2"><cf_get_lang_main no='1256.Oranlar'></td>
  </tr>
  <cfif get_fault_ratios.recordcount>
    <cfoutput query="get_fault_ratios">
      <tr>
        <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
        <td><a href="#request.self#?fuseaction=settings.form_upd_fault_ratio&fault_ratio_id=#fault_ratio_id#" class="tableyazi">#fault_ratio_name#</a></td>
      </tr>
    </cfoutput>
    <cfelse>
    <tr>
      <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
      <td><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
    </tr>
  </cfif>
</table>
