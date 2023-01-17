<cfinclude template="../query/get_class_eval_note.cfm">
<!--- <cfinclude template="../query/get_class_attender_for_note.cfm"> --->
<table cellpadding="0" cellspacing="0" style="height:290mm;width:187mm;" align="center" border="0" bordercolor="#CCCCCC">
<!---<tr>
	<td><cfinclude template="../../objects/display/view_company_logo.cfm"></td>
</tr>--->
<tr>
<td valign="top" height="100%">
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <cfif isdefined("attributes.kapak_bas")>
    <tr>
	   <td class="headbold" height="35" align="center"><font color="##CC0099"><cfoutput>#attributes.kapak_bas#</cfoutput></font></td>
	</tr>
  <cfelse>
   <tr>
		<td class="headbold" height="35" align="center"><font color="#CC0000"><cf_get_lang no='308.Katılımcı Görüşleri'></font></td>
   </tr>
  </cfif>
</table>
	<table width="100%" cellpadding="0" cellspacing="0" border="1" bordercolor="CCCCCC">
		  <tr height="25" class="formbold">
			<td><cf_get_lang_main no='158.Ad Soyad'></td>
			<td><cf_get_lang no='249.Görüşleri'></td>
		  </tr>					
		  <cfoutput query="get_note">
			  <tr height="20">
				<td class="txtbold" width="150">#AD#</td>
				<td>#DETAIL#</td>
			  </tr>
		  </cfoutput>
		</table>
		 </td>
	  </tr>
<!---<tr>
	<td align="center"><cfinclude template="../../objects/display/view_company_info.cfm"></td>
	</tr>--->
</table>

