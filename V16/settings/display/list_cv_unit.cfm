<cfquery name="get_cv_unit" datasource="#dsn#">
	SELECT
       *
	FROM
		SETUP_CV_UNIT
	ORDER BY
		UNIT_NAME
</cfquery>
<table width="200" border="0" cellpadding="0" cellspacing="0">
<cfif get_cv_unit.recordcount>
	<cfoutput query="get_cv_unit">
  <tr>
  <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
  <td width="180"><a href="#request.self#?fuseaction=settings.form_upd_cv_unit&unit_id=#get_cv_unit.unit_id#" class="tableyazi">#UNIT_NAME#</a></td>
  </tr>
  </cfoutput>
<cfelse>
 <tr>
    <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
    <td width="180" valign="baseline"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
 </tr>
 </cfif>
</table>

