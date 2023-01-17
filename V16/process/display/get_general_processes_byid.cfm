<cfsetting showdebugoutput="no">
<cfquery name="get_general_processes" datasource="#dsn#">
    SELECT
        PM.PROCESS_MAIN_ID,
        PM.PROCESS_MAIN_HEADER,
        PM.PROJECT_ID,
        PM.RECORD_EMP
    FROM
        PROCESS_MAIN PM
    WHERE
        PM.PROJECT_ID = #attributes.project_id#
</cfquery>
<cfquery name="PROJECT_DETAIL" datasource="#DSN#">
	SELECT 
		PRO_PROJECTS.*,
		SETUP_PRIORITY.PRIORITY
	FROM 
		PRO_PROJECTS,		
		SETUP_PRIORITY
	WHERE
		PRO_PROJECTS.PROJECT_ID = #attributes.project_id# AND
		PRO_PROJECTS.PRO_PRIORITY_ID = SETUP_PRIORITY.PRIORITY_ID 
</cfquery>
<cf_ajax_list>
	<thead>
	<tr>
		<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
		<th><cf_get_lang dictionary_id='58859.Süreç'></th>
		<th width="200"><cf_get_lang dictionary_id='57899.Kaydeden'></th>
		<th style="width:15px;"></th>
		<th style="width:15px;"></th>
	</tr>
    </thead>
    <tbody>
	<cfif get_general_processes.recordcount>
		<cfset employee_list=''>
		<cfoutput query="get_general_processes">
			<cfif len(record_emp) and not listfind(employee_list,record_emp)>
				<cfset employee_list = listappend(employee_list,record_emp)>
			</cfif>
		</cfoutput>
		<cfif len(employee_list)>
			<cfset employee_list=listsort(employee_list,"numeric","ASC",",")>
			<cfquery name="get_emp" datasource="#dsn#">
				SELECT EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_list#) ORDER BY EMPLOYEE_ID
			</cfquery>
			<cfset employee_list = listsort(listdeleteduplicates(valuelist(get_emp.employee_id,',')),'numeric','ASC',',')>
		</cfif>       
		<cfoutput query="get_general_processes">
			<tr>
				<td>#get_general_processes.PROCESS_MAIN_ID#</td>
				<td>
					<a href="#request.self#?fuseaction=process.gp_visual_designer&main_process_id=#PROCESS_MAIN_ID#" class="tableyazi">#get_general_processes.PROCESS_MAIN_HEADER#</a>
				</td>
				<td>
					<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');" class="tableyazi">
						#get_emp.employee_name[listfind(employee_list,record_emp,',')]# #get_emp.employee_surname[listfind(employee_list,record_emp,',')]#
					</a>
				</td>
				<td>
                     <a style="cursor:pointer;" onclick="window.location = '#request.self#?fuseaction=process.gp_visual_designer&main_process_id=#PROCESS_MAIN_ID#'"><img src="images/WORKFLOW_list.gif" border="0" align="absmiddle" title="<cf_get_lang dictionary_id ='36299.Ana Süreç Tasarım '>"></a>
                </td>
				<td>
					<a style="cursor:pointer;" onclick="window.location = '#request.self#?fuseaction=process.form_upd_main_process&process_id=#PROCESS_MAIN_ID#'"><img src="images/update_list.gif" border="0" align="absmiddle" title="<cf_get_lang dictionary_id ='36301.Süreç Güncelle'>"></a>
				</td>
			</tr>
	   </cfoutput>
	<cfelse>
		<tr>
			<td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
		</tr>
	</cfif>
    </tbody>
</cf_ajax_list>
