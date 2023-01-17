<cfquery name="get_hobby" datasource="#dsn#">
	SELECT * FROM SETUP_HOBBY
</cfquery>
<cfquery name="get_emp_hobbies" datasource="#dsn#"> 
	SELECT HOBBY_ID FROM EMPLOYEES_HOBBY WHERE EMPLOYEE_ID = #attributes.employee_id#
</cfquery>
<cfset liste = valuelist(get_emp_hobbies.hobby_id)>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="56599.Hobiler"></cfsavecontent>
<cf_box title="#message#" scroll="1" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform action="#request.self#?fuseaction=hr.emptypopup_emp_hobbies_upd&employee_id=#attributes.employee_id#" method="post" name="hobby_form">
		<cf_grid_list>
			<thead>
				<tr>
					<th height="22"><cf_get_lang dictionary_id ='56399.Hobi'></th>
					<th><cf_get_lang dictionary_id ='58693.Seç'></th>
				</tr>
			</thead>
			<tbody>
				<cfoutput query="get_hobby">
				<tr>
					<td>#get_hobby.hobby_name#</td>
					<td width="20"><input type="checkbox" name="hobby" id="hobby" value="#get_hobby.hobby_id#"<cfif listfind(liste,hobby_id)>checked</cfif>></td>
				</tr>
				</cfoutput>
			</tbody>
		</cf_grid_list>	
	<cf_box_footer>
		<cf_workcube_buttons type_format="1" is_upd='0' add_function='#iif(isdefined("attributes.draggable"),DE("loadPopupBox('hobby_form' , #attributes.modal_id#)"),DE(""))#'>
	</cf_box_footer>
	</cfform>
</cf_box>
