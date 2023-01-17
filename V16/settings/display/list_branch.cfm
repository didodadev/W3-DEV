<cfquery name="BRANCHS" datasource="#dsn#">
	SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH
	ORDER BY BRANCH_NAME
</cfquery>		
<table width="100%" cellpadding="0" cellspacing="0" border="0">
  <tr> 
    <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang_main no='1637.Şubeler'></td>
  </tr>
<cfif branchs.recordcount>
	<cfoutput query="branchs">
  <tr>
    <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
    <cfif isdefined("attributes.hr")>
	<td><a href="#request.self#?fuseaction=hr.form_upd_company_branch&ID=#branch_ID#&hr=1" class="tableyazi">#branch_name#</a></td>
	<cfelse>
	<td><a href="#request.self#?fuseaction=settings.form_upd_branch&ID=#branch_ID#" class="tableyazi">#branch_name#</a></td>
	</cfif>
  </tr>
  </cfoutput>
<cfelse>
 <tr>
    <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
    <td><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
  </tr>
 </cfif>
</table>

