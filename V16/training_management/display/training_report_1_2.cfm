<table cellpadding="0" cellspacing="0" style="height:260mm;width:187mm;" align="center" border="0" bordercolor="#CCCCCC">
	<tr>
	<td align="center"><cfinclude template="../../objects/display/view_company_logo.cfm"></td>
	</tr>
	<tr>
		<td align="center"  class="headbold" height="100%">
			<cfoutput>
				<h2>#attributes.proje_adi#</h2>
				<p><p></p><p></p><p><font color="##CC0000"><cf_get_lang_main no='330.Tarih'></font></p>
				#attributes.tarih#
			<br/>
			  <cfif isdefined("attributes.kapak_bas")>
			     #attributes.kapak_bas#
			  </cfif>
			</cfoutput>
		</td>
	</tr>
	<tr>
	<td align="center"><cfinclude template="../../objects/display/view_company_info.cfm"></td>
	</tr>
</table>
