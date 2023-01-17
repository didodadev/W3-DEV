<cfif contact_type is "e">
	<cfinclude template="../query/get_emp_det.cfm">
	<cfif len(detail_emp.imcat_id)>
	  <cfset attributes.imcat_id = detail_emp.imcat_id>
	  <cfinclude template="../query/get_imcat.cfm">
	</cfif>
	<cfif len(detail_emp.title_id)>
	  <cfset attributes.title_id = detail_emp.title_id>
	  <cfinclude template="../query/get_title.cfm">
	</cfif>
	<cfset attributes.department_id = detail_emp.department_id>
	<cfif len(attributes.department_id)><cfinclude template="../query/get_location.cfm"></cfif>
	<table cellSpacing="0" cellpadding="0" width="98%"  border="0">
	  <tr class="color-border">
		<td>
		<table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%">
		  <tr class="color-row" valign="top">
			<td>
			<table width="99%">
			  <cfoutput>
			  <tr>
				<td class="txtbold"><cf_get_lang dictionary_id='57487.No'></td>
				<td>#detail_emp.member_code#</td>
			  </tr>
			  <tr>
				<td class="txtbold" width="75"><cf_get_lang dictionary_id='57570.Ad Soyad'></td>
				<td><a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#attributes.emp_id#','medium');" class="tableyazi">#detail_emp.employee_name# #detail_emp.employee_surname#</a></td>
			  </tr>
			  <tr>
				<td class="txtbold"><cf_get_lang dictionary_id='57571.Ünvan'></td>
				<td><cfif len(detail_emp.title_id)>#get_title.title#</cfif></td>
			  </tr>
			  <tr>
				<td class="txtbold"><cf_get_lang dictionary_id='57453.Şube'></td>
				<td><cfif len(attributes.department_id)>#get_location.branch_name#</cfif></td>
			  </tr>
			  <tr>
				<td class="txtbold"><cf_get_lang dictionary_id='57572.Departman'></td>
				<td><cfif len(attributes.department_id)>#get_location.department_head#</cfif></td>
			  </tr>
			  </cfoutput>
			</table>
		  </td>
		</tr>
		</table>
		</td>
	  </tr>
	</table>
	<br/>
<cfelseif contact_type is "p">
	<cfinclude template="../query/get_par_det.cfm">
	<cfset attributes.company_id = detail_par.company_id>
	<cfinclude template="../query/get_comp_name.cfm">
	<cfif len(detail_par.imcat_id)>
	  <cfset attributes.imcat_id = detail_par.imcat_id>
	  <cfinclude template="../query/get_imcat.cfm">
	</cfif>
	<table cellSpacing="0" cellpadding="0" width="98%"  border="0">
	  <tr class="color-border">
		<td>
		<table cellpadding="2" cellspacing="1" width="100%" height="100%">
		  <tr valign="top" class="color-row">
		  	<td>
			<table cellspacing="1" cellpadding="2" width="100%" border="0">
			  <cfoutput>
			  <tr>
				<td  class="txtbold"><cf_get_lang dictionary_id='57487.No'></td>
				<td>#detail_par.member_code#</td>
			  </tr>
			  <tr>
				<td nowrap class="txtbold"><cf_get_lang dictionary_id='57570.Ad Soyad'></td>
				<td><a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#par_id#','medium');" class="tableyazi">#detail_par.company_partner_name# #detail_par.company_partner_surname#</a></td>
			  </tr>
			  <tr>
				<td class="txtbold"><cf_get_lang dictionary_id='57571.Ünvan'></td>
				<td>#detail_par.title#</td>
			  </tr>
			  <tr>
				<td class="txtbold"><cf_get_lang dictionary_id='57574.Şirket'></td>
				<td><a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#detail_par.company_id#','medium');" class="tableyazi"> #get_comp_name.fullname#</a></td>
			  </tr>
			  </cfoutput>
			</table>
		  </td>
		</tr>
		</table>
		</td>
	  </tr>
	</table>
	<br/>
<cfelseif contact_type is "c">
	<cfinclude template="../query/get_con_det.cfm">
	<cfif len(detail_con.imcat_id)>
      <cfset attributes.imcat_id = detail_con.imcat_id>
      <cfinclude template="../query/get_imcat.cfm">
  	</cfif>
	
	<table cellSpacing="0" cellpadding="0" width="98%"  border="0">
	  <tr class="color-border">
		<td>
		<table cellpadding="2" cellspacing="1" width="100%" height="100%">
		  <tr class="color-row">
			<td valign="top">
			<table width="99%" border="0">
			  <cfoutput>
			  <tr>
				<td width="75" class="txtbold"><cf_get_lang dictionary_id='57487.No'></td>
				<td width="175">#detail_con.member_code#</td>
			  </tr>
			  <tr>
				<td width="75" class="txtbold"><cf_get_lang dictionary_id='57486.Kategori'></td>
				<td width="175">#get_consumer_cat.conscat#</td>
			  </tr>
			  <tr>
				<td class="txtbold"><cf_get_lang dictionary_id='57570.Ad Soyad'></td>
				<td><a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#con_ID#','medium');" class="tableyazi">#detail_con.consumer_name# #detail_con.consumer_surname#</a></td>
			  </tr>
			  <tr>
				<td class="txtbold"><cf_get_lang dictionary_id='57571.Ünvan'></td>
				<td>#detail_con.title#</td>
			  </tr>
			  <tr>
				<td class="txtbold"><cf_get_lang dictionary_id='57574.Şirket'></td>
				<td>#detail_con.company#</td>
			  </tr>
			  </cfoutput>
			</table>
			</td>
		  </tr>
		</table>
	 	</td>
      </tr>
	</table>
	<br/>
</cfif>
