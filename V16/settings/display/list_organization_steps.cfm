<cfquery name="ORGANIZATION_STEPS" datasource="#dsn#">
	SELECT
       *
	FROM
		SETUP_ORGANIZATION_STEPS
	ORDER BY
		ORGANIZATION_STEP_NO
</cfquery>
<table width="200" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='1351.Kademeler'></td>
  </tr>
<cfif ORGANIZATION_STEPS.recordcount>
	<cfoutput query="ORGANIZATION_STEPS">
  <tr>
  <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
  <td width="180"><a href="#request.self#?fuseaction=settings.form_upd_organization_step&organization_step_id=#ORGANIZATION_STEP_ID#" class="tableyazi">#ORGANIZATION_STEP_NAME#</a></td>
  </tr>
  </cfoutput>
<cfelse>
 <tr>
    <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
    <td width="180" valign="baseline"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
 </tr>
 </cfif>
</table>

