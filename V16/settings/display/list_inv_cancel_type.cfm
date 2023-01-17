<cfquery name="GET_INVOICE_CANCEL_TYPES" datasource="#DSN3#">
	SELECT
		*
	FROM
		SETUP_INVOICE_CANCEL_TYPE
	ORDER BY 
		INV_CANCEL_TYPE
</cfquery>
<table cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='1355.Iptal Kategorileri'></td>
	</tr>
	<cfif get_invoice_cancel_types.recordcount>
		<cfoutput query="get_invoice_cancel_types">
			<tr>
				<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
				<td><a href="#request.self#?fuseaction=settings.form_upd_inv_cancel_type&inv_cancel_type_id=#get_invoice_cancel_types.inv_cancel_type_id#" class="tableyazi">#inv_cancel_type#</a></td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr>
			<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
			<td><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
		</tr>
	</cfif>
</table>
