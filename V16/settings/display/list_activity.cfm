<cfquery name="GET_ACTIVITY" datasource="#DSN#">
	SELECT
		*
	FROM
		SETUP_ACTIVITY
</cfquery>

<table cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td class="txtbold" height="20" colspan="2"><cf_get_lang no='937.Aktiviteler'></td>
  </tr>
  <cfif get_activity.recordcount>
    <cfoutput query="get_activity">
      <tr>
        <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
        <td><a href="#request.self#?fuseaction=settings.form_upd_activity&activity_id=#activity_id#" class="tableyazi">#activity_name#</a></td>
      </tr>
    </cfoutput>
    <cfelse>
    <tr>
      <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
      <td><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
    </tr>
  </cfif>
</table>
