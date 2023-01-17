<table width="200" cellpadding="0" cellspacing="0" border="0">
	<tr> 
		<td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='138.Fırsat Durum Kategorisi'></td>
	</tr>
	<cfif get_opportunity_currencys.recordcount>
		<cfoutput query="get_opportunity_currencys">
		  <tr>
			<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
			<td width="180"><a href="#request.self#?fuseaction=settings.form_upd_opportunity_currency&opportunity_currency_id=#opp_currency_id#" class="tableyazi">#OPP_CURRENCY#</a></td>
		  </tr>
		</cfoutput>
	<cfelse>
		 <tr>
			<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
			<td width="180"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
	  </tr>
	</cfif>
</table>
