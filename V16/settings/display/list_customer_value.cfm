<cfquery name="CUSTOMER_VALUES" datasource="#dsn#">
	SELECT
       *
	FROM
		SETUP_CUSTOMER_VALUE
	ORDER BY
		CUSTOMER_VALUE
</cfquery>
<table width="200" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang_main no='1140.Müşteri Değeri'></td>
  </tr>
<cfif CUSTOMER_VALUES.recordcount>
	<cfoutput query="CUSTOMER_VALUES">
	  <tr>
		  <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
		  <td width="180"><a href="#request.self#?fuseaction=settings.form_upd_customer_value&ID=#CUSTOMER_VALUES.CUSTOMER_VALUE_ID#" class="tableyazi">#CUSTOMER_VALUE#</a></td>
	  </tr>
  </cfoutput>
<cfelse>
	<tr>
		<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
		<td width="180" valign="baseline"><font class="tableyazi"><cf_get_lang_main no='1074.Kayıt Bulunamadı'>!</font></td>
	</tr>
 </cfif>
</table>

