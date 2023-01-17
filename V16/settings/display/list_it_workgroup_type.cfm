<cfquery name="get_it_workgroup_type" datasource="#dsn#">
	SELECT
		WORKGROUP_TYPE_ID,
		WORKGROUP_TYPE_NAME
	FROM
		SETUP_IT_WORKGROUP_TYPE
	ORDER BY
		WORKGROUP_TYPE_NAME
</cfquery>

<table width="99%" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td class="txtbold" colspan="2" height="20">&nbsp;&nbsp;<cf_get_lang no='3094.IT İş Grubu Tipleri'></td>
  </tr>
  <cfif get_it_workgroup_type.recordcount>
    <cfoutput query="get_it_workgroup_type">
      <tr>
        <td align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
        <td><a href="#request.self#?fuseaction=settings.upd_it_workgroup_type&workgroup_type_id=#workgroup_type_id# " class="tableyazi">#workgroup_type_name#</td>
      </tr>
    </cfoutput>
    <cfelse>
    <tr>
      <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
	  <td><font class="tableyazi"><cf_get_lang_main no='1074.Kayıt Bulunamadı'>!</font></td>
    </tr>
  </cfif>
</table>
