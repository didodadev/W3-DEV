<cfquery name="GET_STOCK_AMOUNT" datasource="#DSN#">
	SELECT STOCK_NAME,STOCK_ID FROM SETUP_STOCK_AMOUNT ORDER BY STOCK_ID 
</cfquery>
<table width="140" cellpadding="0" cellspacing="0" border="0">
	<tr> 
    	<td class="txtbold" height="25" colspan="2">&nbsp;&nbsp;<cf_get_lang no='1114.Stok veya Raf Durumu'></td>
	</tr>
<cfif get_stock_amount.recordcount>
  <cfoutput query="get_stock_amount">
	<tr>
  	  <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
      <td width="115"><a href="#request.self#?fuseaction=settings.form_upd_stock_amount&stock_id=#stock_id#" class="tableyazi">#stock_name#</a></td>
	</tr>
  </cfoutput>
<cfelse>
 	<tr>
    	<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
	    <td width="115"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
	</tr>
</cfif>
</table>
