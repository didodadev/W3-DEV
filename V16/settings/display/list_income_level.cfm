<cfquery name="income_levels" datasource="#dsn#">
	SELECT
       *
	FROM
		SETUP_INCOME_LEVEL
	ORDER BY
		INCOME_LEVEL
</cfquery>
<table width="200" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='1198.Gelir Düzeyleri'></td>
  </tr>
<cfif income_levels.recordcount>
	<cfoutput query="income_levels">
	  <tr>
		  <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
		  <td width="180"><a href="#request.self#?fuseaction=settings.form_upd_income_level&ID=#income_levels.INCOME_LEVEL_ID#" class="tableyazi">#INCOME_LEVEL#</a></td>
	  </tr>
  </cfoutput>
<cfelse>
	<tr>
		<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
		<td width="180" valign="baseline"><font class="tableyazi"><cf_get_lang_main no='1074.Kayıt Bulunamadı'>!</font></td>
	</tr>
 </cfif>
</table>

