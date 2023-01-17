<cfquery name="GET_WORKGROUPS" datasource="#DSN3#">
    SELECT 
        SE.SERVICE_ID,
        SE.EMPLOYEE_ID,
        W.WORKGROUP_NAME
    FROM 
        SERVICE_EMPLOYEES SE,
        SERVICE S,
        #DSN_ALIAS#.WORK_GROUP W
    WHERE
    	S.SERVICE_ID = SE.SERVICE_ID AND
        S.WORKGROUP_ID = W.WORKGROUP_ID AND
        SE.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
</cfquery>
<cf_ajax_list>
    <tbody>
    <cfif GET_WORKGROUPS.recordcount>
        <tr>
            <th colspan="2" class="txtbold"><cfoutput>#GET_WORKGROUPS.WORKGROUP_NAME#</cfoutput></th>
        </tr>
        <cfoutput query="GET_WORKGROUPS">
            <tr>
                <td>#get_emp_info(employee_id,0,1)#</td>
                <td width="15">
                	<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=service.emptypopup_del_workgroup_emps&emp_id=#employee_id#&service_id=#service_id#','small');"><img src="../images/delete_list.gif" border="0" title="Çalışan Sil" /></a>
                </td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td colspan="2"><cf_get_lang_main no="72.Kayıt Bulunamadı">!</td>
        </tr>
    </cfif>
    </tbody>
</cf_ajax_list>


