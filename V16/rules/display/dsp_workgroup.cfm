<cfquery name="CATEGORY" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		WORK_GROUP 
	WHERE	
		WORKGROUP_ID=#attributes.WORKGROUP_ID#
</cfquery>

<cfquery name="GET_EMPS" datasource="#dsn#">
	SELECT 
		EMPLOYEE_POSITIONS.EMPLOYEE_ID, 
		EMPLOYEE_POSITIONS.POSITION_CODE, 
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME, 
		WORKGROUP_EMP_PAR.ROLE_ID
	FROM 
		EMPLOYEE_POSITIONS,
		WORKGROUP_EMP_PAR
	WHERE 
		EMPLOYEE_POSITIONS.POSITION_STATUS = 1 AND 
		WORKGROUP_EMP_PAR.POSITION_CODE = EMPLOYEE_POSITIONS.POSITION_CODE AND	
		WORKGROUP_EMP_PAR.WORKGROUP_ID = #attributes.WORKGROUP_ID#
</cfquery>

<cfquery name="GET_PARS" datasource="#dsn#">
	SELECT 
		COMPANY_PARTNER.COMPANY_PARTNER_NAME, 
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
		COMPANY_PARTNER.COMPANY_ID, 
		COMPANY_PARTNER.PARTNER_ID, 
		COMPANY.NICKNAME, 
		WORKGROUP_EMP_PAR.ROLE_ID
	FROM 
		COMPANY_PARTNER, 
		COMPANY, 
		WORKGROUP_EMP_PAR 
	WHERE 
		COMPANY_PARTNER.PARTNER_ID = WORKGROUP_EMP_PAR.PARTNER_ID 
	AND 
		COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID
	AND	
		WORKGROUP_EMP_PAR.WORKGROUP_ID=#attributes.WORKGROUP_ID#
</cfquery>
<cf_popup_box title="#lang_array_main.item[728]# #category.workgroup_name#"><!---İş Grubu--->
    <cf_medium_list>
        <thead>
			<cfif len(category.goal)>
                <tr>
                    <td valign="top" class="txtbold"><cf_get_lang no='13.Amaç'></td>
                    <td></td>
                </tr>
                <tr>
                	<td colspan="2"><cfoutput>#category.goal#</cfoutput></td>
                </tr>
                <tr><td colspan="2">&nbsp;</td></tr>
            </cfif>
                <tr>
                    <th colspan="2"><cf_get_lang no='19.Grup Üyeleri'></th>
                </tr>
            <cfif get_emps.recordcount or get_pars.recordcount>
                <tr>
                    <th><cf_get_lang_main no='157.Görevli'></th>
                    <th><cf_get_lang no='22.Rol'></th>
                </tr>
            </cfif>
        </thead>
        <tbody>
			<cfoutput query="GET_EMPS">
                <tr>
                    <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium')" class="tableyazi"> #EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a> </td>
                    <td>
                        <cfif len(ROLE_ID)>
                            <cfquery name="GET_ROL_NAME" datasource="#dsn#">
                                SELECT PROJECT_ROLES FROM SETUP_PROJECT_ROLES WHERE PROJECT_ROLES_ID = #ROLE_ID#
                            </cfquery>
                            #GET_ROL_NAME.PROJECT_ROLES#					
                        </cfif>
                    </td>
                </tr>
            </cfoutput>
            <cfoutput query="get_PARS">
                <tr>
                    <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#PARTNER_ID#','medium')" class="tableyazi">#COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME# - #nickname#</a> </td>
                    <td>
                        <cfif len(ROLE_ID)>
                            <cfquery name="GET_ROL_NAME2" datasource="#dsn#">
                                SELECT PROJECT_ROLES FROM SETUP_PROJECT_ROLES WHERE PROJECT_ROLES_ID = #ROLE_ID#
                            </cfquery>
                            #GET_ROL_NAME2.PROJECT_ROLES#
                        </cfif>
                    </td>
                </tr>
            </cfoutput>
        </tbody>
    </cf_medium_list>
    <cf_popup_box_footer>
        <cf_record_info query_name="category">
    </cf_popup_box_footer>
</cf_popup_box>