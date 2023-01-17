<cfquery name="NOTICE_GROUP" datasource="#dsn#">
	SELECT
       *
	FROM
		SETUP_NOTICE_GROUP
	ORDER BY
		NOTICE
</cfquery>
<table width="200" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='1488.İlan Grupları'></td>
  </tr>
<cfif NOTICE_GROUP.recordcount>
	<cfoutput query="NOTICE_GROUP">
  <tr>
  <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
  <td width="180"><a href="#request.self#?fuseaction=settings.form_upd_notice_type&notice_cat_id=#NOTICE_CAT_ID#" class="tableyazi">#NOTICE#</a></td>
  </tr>
  </cfoutput>
<cfelse>
 <tr>
    <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
    <td width="180" valign="baseline"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
 </tr>
 </cfif>
</table>

