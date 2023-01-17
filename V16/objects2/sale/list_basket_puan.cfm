<cfquery name="GET_VALUES" datasource="#DSN3#">
	SELECT
		*
	FROM
		ORDER_INFO_PLUS
	WHERE
		RECORD_GUEST = 1 AND 
		RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#"> AND
		COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#">
</cfquery>
<cfif not GET_VALUES.recordcount>
	<script type="text/javascript">
		alert('<cf_get_lang no ='.'>Detay Bilgileri Doldurulmadığı İçin Sepete Giremezsiniz!');
		history.back();
	</script>
	<cfabort>
</cfif>

<cfquery name="get_sepet" datasource="#DSN3#">
	SELECT
		*
	FROM
		ORDER_PRE_ROWS_SPECIAL
	WHERE
		RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND 
		RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#"> AND
		COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#">
</cfquery>
<table width="100%" align="center" cellpadding="2" cellspacing="1" class="color-border">
<tr height="22" class="color-header">
  <td class="form-title"><cf_get_lang_main no='75.No'></td>
  <td class="form-title"><cf_get_lang_main no='245.Ürün'></td>
  <td width="40" class="form-title"><cf_get_lang_main no='223.Miktar'></td>
  <td width="70" class="form-title"><cf_get_lang_main no='1572.Puan'></td>
  <td width="15"></td>
</tr>
<cfif get_sepet.recordcount>
<cfoutput query="get_sepet">
<tr height="22" class="color-row">
	<td>#currentrow#</td>
	<td>#product_name#</td>
	<td>#quantity#</td>
	<td>#PROM_POINT#</td>
	<cfsavecontent variable="alert"><cf_get_lang_main no='271.Sepetteki Ürünü Silmek İstediğinizden Emin misiniz'></cfsavecontent>
	<td><a href="javascript://" onClick="if (confirm('#alert#')) windowopen('#request.self#?fuseaction=objects2.emptypopup_del_row_puan&ORDER_ROW_ID=#ORDER_ROW_ID#','small'); else return false;"><img src="/images/delete_list.gif" border="0"></a></td>
</tr>	
</cfoutput>
<tr class="color-row">
	<td height="30" colspan="5" align="right" style="text-align:right;">
	<cfsavecontent variable="message"><cf_get_lang no ='1466.Siparişi Kaydetmek İstediğinize Emin misiniz'></cfsavecontent>
	<cfsavecontent variable="message2"><cf_get_lang no ='146.Sepeti Boşaltmak İstediğinize Emin misiniz'></cfsavecontent>
		<a href="javascript://" onClick="if (confirm('<cfoutput>#message#</cfoutput>')) window.location='<cfoutput>#request.self#?fuseaction=objects2.form_add_orderww</cfoutput>'"><img src="../objects2/image/basket_sa.gif" border="0" title="<cf_get_lang no ='145.Sipariş Kaydet'>" align="absmiddle" style="cursor:pointer"></a>
		<a href="javascript://" onClick="if (confirm('<cfoutput>#message2#</cfoutput>')) window.location='<cfoutput>#request.self#?fuseaction=objects2.emptypopup_del_basket_puan</cfoutput>'"><img src="../objects2/image/basket_del.gif" border="0" title="<cf_get_lang no='147.Sepeti Boşalt'>" align="absmiddle" style="cursor:pointer"></a>
	</td>
</tr>
<cfelse>
<tr height="20" class="color-row">
	<td colspan="5"><cf_get_lang no='134.Sepette ürün yok'>!</td>
</tr>
</cfif>
</table>
