<cfinclude template="../query/get_class_attenders.cfm">
<cfinclude template="../query/get_class_information.cfm">
<cf_ajax_list>
   <tbody>
    <input type="Hidden" name="attenders" id="attenders2" value="<cfoutput>#all_attender_ids#</cfoutput>">
    <input type="Hidden" name="inform" id="inform2" value="<cfoutput>#all_inform_ids#</cfoutput>">
	  <tr>
		<td height="20">
		<cfoutput query="get_class_attender_emps">
			<cfif get_class_attender_emps.status eq 1><img src="/images/happy.gif" align="absmiddle"><cfelse><img src="/images/unhappy.gif" align="absmiddle"></cfif>
			<cfif isdefined('session.ep')>
				<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_class_attender_emps.employee_id#','medium');" class="tableyazi">#employee_name# #employee_surname#</a><br/>
			<cfelse>
				<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_emp_det&emp_id=#encrypt(get_class_attender_emps.employee_id,"WORKCUBE","BLOWFISH","Hex")#','medium');" class="tableyazi">#employee_name# #employee_surname#</a><br/>
			</cfif>
		</cfoutput> 
		<cfoutput query="get_class_attender_pars">
			<cfif len(get_class_attender_pars.status)><img src="/images/happy.gif" align="absmiddle"><cfelse><img src="/images/unhappy.gif" align="absmiddle"></cfif>
			<cfif isdefined('session.ep')>
				<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_class_attender_pars.company_id#','medium');" class="tableyazi">#nickname#</a>
			<cfelse>
				#nickname#
			</cfif>
			- 
			<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#get_class_attender_pars.partner_id#','medium');" class="tableyazi">#company_partner_name# #company_partner_surname#</a><br/>
		</cfoutput>
		<cfoutput query="get_class_attender_cons">
			<cfif len(get_class_attender_cons.status)><img src="/images/happy.gif" align="absmiddle"><cfelse><img src="/images/unhappy.gif" align="absmiddle"></cfif>
			<cfif len(get_class_attender_cons.company)>#company# - </cfif>
			<cfif isdefined('session.ep')>
				<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_class_attender_cons.consumer_id#','medium');" class="tableyazi">#consumer_name# #consumer_surname#</a><br/>
			<cfelse>
				#consumer_name# #consumer_surname#
			</cfif>
		</cfoutput>
		<cfoutput query="get_class_attender_grps"> *
			#group_name#<br/>
		</cfoutput>	
		</td>
	  </tr>
  </tbody>
</cf_ajax_list>

