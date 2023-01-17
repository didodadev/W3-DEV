<cfquery name="GET_BRANCH_CATS" datasource="#DSN#">
	SELECT BRANCH_CAT_ID,BRANCH_CAT FROM SETUP_BRANCH_CAT ORDER BY BRANCH_CAT
</cfquery>
<table cellpadding="0" cellspacing="0" border="0">
	<tr> 
    	<td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no ='988.Tipler'></td>
	</tr>
<cfif get_branch_cats.recordcount>
	<cfoutput query="get_branch_cats">
  	<tr>
    	<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
		<td width="200"><a href="#request.self#?fuseaction=settings.upd_branch_cat&id=#branch_cat_id#" class="tableyazi">#branch_cat#</a></td>
	</tr>
	</cfoutput>
<cfelse>
	<tr>
    	<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
	    <td width="115"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</font></td>
	</tr>
</cfif>
</table>
