<?xml version="1.0" encoding="utf-8"?>
<table width="200" cellpadding="0" cellspacing="0" border="0">
	<tr> 
		<td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no ='436.Olasılık Oran Listesi'></td>
	</tr>
	
	<cfif get_probability_rate.recordcount>
		<cfoutput query="get_probability_rate">
		  <tr>
			<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
			<td width="180"><a href="#request.self#?fuseaction=settings.form_upd_probability_rate&probability_rate_id=#probability_rate_id#" class="tableyazi">#PROBABILITY_NAME#</a></td>
					  
			</tr>
		</cfoutput>
	<cfelse>
		 <tr>
			<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
			<td width="180"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
	  </tr>
	</cfif>
</table>
