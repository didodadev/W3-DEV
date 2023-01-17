<table cellpadding="0" cellspacing="0" style="height:290mm;width:187mm;" align="center" border="0" bordercolor="#CCCCCC">
	<!---<tr><td align="center"><cfinclude template="../../objects/display/view_company_logo.cfm"></td></tr>--->
<tr>
<td valign="top" height="100%" style="width:187mm;">
<cfoutput>
<table border="0" cellspacing="0" cellpadding="0" align="center">
   
  <cfif isdefined("attributes.kapak_bas")>
    <tr>
	   <td class="headbold" height="35" align="center"><font color="##CC0099">#attributes.kapak_bas#</font></td>
	</tr>
  <cfelse>
   <tr>
		<td class="headbold" height="35" align="center"><font color="##CC0000"><cf_get_lang no='296.Program Kimliği'></font></td>
  </tr>
  </cfif>
</table>
<table>
	<tr>
		<td class="txtbold" height="20" width="125"><cf_get_lang_main no='219.Ad'></td>
		<td>: #get_class.class_name#</td>
 	</tr>
	<tr>
		<td class="txtbold" height="20" valign="top"><cf_get_lang no='36.Eğitim İçeriği'></td>
		<td>: #get_class.class_objective#</td>
 	</tr>
	<tr>
		<td class="txtbold" height="20" valign="top"><cf_get_lang no='117.Eğitmen'></td>
		<td>: <!--- <cfif len(get_class.trainer_emp)>#get_emp_info(get_class.trainer_emp,0,0)#<cfelseif len(get_class.trainer_par)>#get_par_info(get_class.trainer_par,0,-1,0)#<cfelseif len(get_class.trainer_cons)>#get_cons_info(get_class.trainer_cons,0,0)#</cfif> ---></td>
 	</tr>
	<tr>
		<td class="txtbold" height="20"><cf_get_lang no='187.Eğitim Yeri'></td>
		<td>: #get_class.CLASS_PLACE#</td>
 	</tr>
	<tr>
		<td class="txtbold" height="20" valign="top"><cf_get_lang no='30.Eğitim Yeri Adres'></td>
		<td>: #get_class.CLASS_PLACE_ADDRESS#</td>
 	</tr>
	<tr>
		<td class="txtbold" height="20"><cf_get_lang_main no='87.Tel No'></td>
		<td>: #get_class.CLASS_PLACE_TEL#</td>
 	</tr>
	<tr>
		<td class="txtbold" height="20"><cf_get_lang no='35.Eğitim Yeri Sorumlusu'></td>
		<td>: #get_class.CLASS_PLACE_MANAGER#</td>
 	</tr>					
</table>
</cfoutput>
</td>
</tr>
<!---<tr><td align="center"><cfinclude template="../../objects/display/view_company_info.cfm"></td></tr>--->
</table>
