<table width="135" cellpadding="0" cellspacing="0" border="0">
	<tr> 
		<td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='171.SSD Oranları'></td>
	</tr>
	<cfif SSD_RATES.recordcount>
		<cfoutput query="SSD_RATES">
			<tr>
			  <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
			  <td width="115"><font class="tableyazi">#SSD_RATE#</font></td>
			</tr>
	  </cfoutput>
	<cfelse>
	 <tr>
		<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
		<td width="115"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
	  </tr>
	 </cfif>
</table>


