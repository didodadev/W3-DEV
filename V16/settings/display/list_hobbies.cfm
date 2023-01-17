<cfquery name="GET_HOBBY" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_HOBBY
</cfquery>

<table cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='868.Hobiler'></td>
  </tr>
  <cfif GET_HOBBY.recordcount>
    <cfoutput query="GET_HOBBY">
      <tr>
        <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
        <td><a href="#request.self#?fuseaction=settings.form_upd_hobbies&hobby_id=#HOBBY_ID#" class="tableyazi">#HOBBY_NAME#</a></td>
      </tr>
    </cfoutput>
    <cfelse>
    <tr>
      <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
      <td><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
    </tr>
  </cfif>
</table>

