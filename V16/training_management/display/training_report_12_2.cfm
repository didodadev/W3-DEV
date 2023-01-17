
<table cellpadding="0" cellspacing="0" style="height:290mm;width:187mm;" align="center" border="0" bordercolor="#CCCCCC">
	<tr>
	<td align="center"><cfinclude template="../../objects/display/view_company_logo.cfm"></td>
	</tr>
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
                        <td>Eğitim</td>
					    <td><cf_get_lang_main no='158.Ad Soyad'></td>
                        <td><cf_get_lang no='249.Görüşleri'></td>
                      </tr>					
				 <cfloop list="#attributes.class_id_list#" index="i">
	              <cfset attributes.class_id= i>
	              <cfinclude template="../query/get_report_queries.cfm">
	              <cfinclude template="../query/get_upd_class_queries.cfm">	
				   <cfinclude template="../query/get_class_eval_note.cfm">
                   <cfset my_class_list=valuelist(get_note.EMPLOYEE_ID)>
                   <cfinclude template="../query/get_class_attender_for_note.cfm"> 
					  <cfoutput query="get_emp_att">
						  <tr height="20">
							 <td>&nbsp;#get_class.class_name#</td>
							<td class="txtbold" width="150">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
							<td>&nbsp;
								<cfset counter = listfindnocase(my_class_list,EMP_ID)>
								#get_note.DETAIL[counter]#
							</td>
						  </tr>
					  </cfoutput>
				</cfloop>
                    </table>
		 </td>
	  </tr>
	 <tr>
	<td align="center"><cfinclude template="../../objects/display/view_company_info.cfm"></td>
	</tr>
</table>

