<!---

    File: V16\hr\display\project_allowance_employee.cfm
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 30.06.2021
    Description: Çalışan ve zaman harcamaları bilgileri 
--->
<cfparam  name="attributes.function_" default="addRow">

<cfset get_component = createObject("component","V16.hr.cfc.project_allowance") />
<cfset get_project_team = get_component.get_project_team(
        project_id: attributes.project_id, 
        ssk_statue : attributes.ssk_statue,
        statue_type : attributes.statue_type,
        sal_mon : attributes.sal_mon,
        sal_year : attributes.sal_year,
        from_draggable : 1
)> 

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Çalışanlar',58875)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='58487.Çalışan No'></th>
					<th><cf_get_lang dictionary_id ='57570.Ad Soyad'></th>
					<th><cf_get_lang dictionary_id='55478.Rol'></th>
					<th><cf_get_lang dictionary_id='53610.Ödenek'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_project_team.recordcount>
					<cfoutput query="get_project_team">
						<tr>
							<td>
                                <a href="javascript://" onClick="#attributes.function_#('#EMPLOYEE_NO#','#IN_OUT_ID#','#EMPLOYEE_ID#','#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#','#COMMENT_PAY#','#ODKES_ID#','#ROLE_HEAD#','#PER_HOUR_SALARY#','#TOTAL_TIME#','#PER_HOUR_SALARY*TOTAL_TIME#',#attributes.modal_id#)">#EMPLOYEE_NO#</a>
							</td>
							<td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
							<td>#ROLE_HEAD#</td>
                            <td>#COMMENT_PAY#</td>
						</tr>
					</cfoutput>
				</cfif>
			</tbody>
		</cf_grid_list>
	</cf_box>
</div>



