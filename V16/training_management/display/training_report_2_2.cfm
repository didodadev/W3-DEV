<table cellpadding="0" cellspacing="0" style="height:290mm;width:187mm;" align="center" border="0" bordercolor="#CCCCCC">
	<tr>
	<td align="center"><cfinclude template="../../objects/display/view_company_logo.cfm"></td>
	</tr>
<tr>
<td valign="top" height="100%">
<cfoutput>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  
  <cfif isdefined("attributes.kapak_bas")>
    <tr>
	   <td class="headbold" height="35" align="center"><font color="##CC0099"><cfoutput>#attributes.kapak_bas#</cfoutput></font></td>
	</tr>
   <cfelse>
    <tr>
      <td class="headbold" height="35" align="center"><font color="##CC0000"><cf_get_lang no='296.Program Kimliği'></font></td>
    </tr>
  </cfif>
</table>
<table width="99%" cellpadding="0" cellspacing="0" border="1" bordercolor="CCCCCC">
	<!---********--->
	  <tr height="22" class="formbold">
	    <td><cf_get_lang_main no='219.Ad'></td>
		<td><cf_get_lang no='36.Eğitim İçeriği'></td>
		<td>Eğitmen Adı</td>
		<td><cf_get_lang no='187.Eğitim Yeri'></td>
		<td><cf_get_lang no='30.Eğitim Yeri Adres'></td>
		<td><cf_get_lang_main no='87.Tel No'></td>
		<td><cf_get_lang no='35.Eğitim Yeri Sorumlusu'></td>
	  </tr>
	
	<!---********--->
	<cfloop list="#attributes.class_id_list#" index="i">
	  <cfset attributes.class_id= i>
	  <cfinclude template="../query/get_report_queries.cfm">
	  <cfinclude template="../query/get_upd_class_queries.cfm">
   <cfif get_class.recordcount>
	<tr>
		<td>&nbsp;#get_class.class_name#</td>
		<td>&nbsp;#get_class.class_objective#</td>
		<td>&nbsp;<!--- <cfif len(get_class.trainer_emp)>#get_emp_info(get_class.trainer_emp,0,0)#<cfelseif len(get_class.trainer_par)>#get_par_info(get_class.trainer_par,0,-1,0)#<cfelseif len(get_class.trainer_cons)>#get_cons_info(get_class.trainer_cons,0,0)#</cfif> ---></td>
		<td>&nbsp;#get_class.CLASS_PLACE#</td>
		<td>&nbsp;#get_class.CLASS_PLACE_ADDRESS#</td>
		<td>&nbsp;#get_class.CLASS_PLACE_TEL#</td>
		<td>&nbsp;#get_class.CLASS_PLACE_MANAGER#</td>
 	</tr>		
  </cfif>
 </cfloop>			
</table>
</cfoutput>
</td>
</tr>
	<tr>
	<td align="center"><cfinclude template="../../objects/display/view_company_info.cfm"></td>
	</tr>
</table>
