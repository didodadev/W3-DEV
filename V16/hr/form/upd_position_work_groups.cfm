<cfquery name="GET_WORKGROUPS" datasource="#DSN#">
	SELECT 
		WG.WORKGROUP_NAME,
		WG.HIERARCHY AS GROUP_HIERARCHY,
		WEP.*
	FROM 
		WORK_GROUP WG,
		WORKGROUP_EMP_PAR WEP
	WHERE 
		WG.WORKGROUP_ID = WEP.WORKGROUP_ID AND
		WEP.EMPLOYEE_ID = #attributes.employee_id#
</cfquery>
<cf_ajax_list>
    <thead>
        <tr>
            <th><cf_get_lang dictionary_id='55478.Rol'></th>
            <th><cf_get_lang dictionary_id='58140.İş Grubu'></th>
            <th><cf_get_lang dictionary_id='56319.Organizasyon Unitesi'></th>
        </tr>
    </thead>
    <cfif get_workgroups.recordcount>
        <tbody>
        <cfoutput query="get_workgroups">
            <tr>
                <td>
                    #role_head#
                    <cfif not len(role_head) and len(role_id)>	
                        <cfquery name="GET_ROL_NAME" datasource="#DSN#">
                            SELECT PROJECT_ROLES FROM SETUP_PROJECT_ROLES WHERE PROJECT_ROLES_ID = #role_id#
                        </cfquery>
                        #get_rol_name.project_roles#
                    </cfif>
                    <cfif is_real eq 0>(V.)</cfif>
                </td>
                <td>#workgroup_name#</td>
                <td></td>
            </tr>
        </cfoutput>
        </tbody>
    <cfelse>
        <tbody>
            <tr>
                <td colspan="3"><cf_get_lang dictionary_id ='57484.Kayıt Yok '>!</td>
            </tr>
        </tbody>
    </cfif>
</cf_ajax_list>
