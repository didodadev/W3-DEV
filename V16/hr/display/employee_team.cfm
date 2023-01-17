<!--- Kurumsal Uye Ekibi --->
<cfinclude template="../query/get_all_emps.cfm">
<cfset role_id_list = ''>
<cfoutput query="get_all_emps">
	<cfif len(role) and not listfind(role_id_list,role)>
		<cfset role_id_list=listappend(role_id_list,role)>
	</cfif>
</cfoutput>
<cfoutput query="get_all_emps_related">
	<cfif len(role) and not listfind(role_id_list,role)>
		<cfset role_id_list=listappend(role_id_list,role)>
	</cfif>
</cfoutput>
<cfif len(role_id_list)>
	<cfquery name="get_rol_name" datasource="#dsn#">
		SELECT PROJECT_ROLES_ID,PROJECT_ROLES FROM SETUP_PROJECT_ROLES WHERE PROJECT_ROLES_ID IN (#role_id_list#)
	</cfquery>
	<cfset role_id_list = listsort(listdeleteduplicates(valuelist(get_rol_name.project_roles_id,',')),'numeric','ASC',',')>
</cfif>
<cf_ajax_list>	
    <thead>
        <tr>
            <th><cf_get_lang dictionary_id='56347.İlişkili Çalışanlar'></th>
        </tr>
    </thead>
    <tbody>
		<cfif get_all_emps.recordcount>
            <cfoutput query="get_all_emps">
                <tr>
                    <td>
                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#member_id#','medium','popup_emp_det');" class="tableyazi">#member_name# #member_surname#</a>
                        <cfif len(role)> - #get_rol_name.project_roles[listfind(role_id_list,role,',')]#</cfif>
                    </td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</td>
            </tr>
        </cfif>
    </tbody>
    <thead>
        <tr>
            <th><cf_get_lang dictionary_id='56348.İlişkili Olduğu Çalışanlar'></th>
        </tr>
    </thead>
    <tbody>
        <cfif get_all_emps_related.recordcount>
            <cfoutput query="get_all_emps_related">
                <tr>
                    <td>
                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#member_id#','medium','popup_emp_det');" class="tableyazi">#member_name# #member_surname#</a>
                        <cfif len(role)> - #get_rol_name.project_roles[listfind(role_id_list,role,',')]#</cfif>
                    </td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</td>
            </tr>
        </cfif>
    </tbody>
</cf_ajax_list>
