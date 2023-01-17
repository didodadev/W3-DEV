<cfquery name="GET_CONTRACT_HISTORY" datasource="#DSN3#">
	SELECT 
    RELATED_CONTRACT_HISTORY.UPDATE_DATE,
         (SELECT EMPLOYEE_NAME +' '+EMPLOYEE_SURNAME FROM #DSN_ALIAS#.EMPLOYEES E WHERE  E.EMPLOYEE_ID=RELATED_CONTRACT_HISTORY.UPDATE_EMP) AS UPDATE_NAME,* 
    FROM 
    	RELATED_CONTRACT_HISTORY 
    WHERE 
    	CONTRACT_ID = #attributes.act_id# AND RELATED_CONTRACT_HISTORY.UPDATE_DATE IS NOT NULL
    ORDER BY 
    RELATED_CONTRACT_HISTORY.UPDATE_DATE DESC
</cfquery>
<cfquery name="GET_LOCATION_NAME" datasource="#DSN#">
	SELECT LOCATION_ID,DEPARTMENT_ID,COMMENT FROM STOCKS_LOCATION
</cfquery>
<cfoutput query="get_contract_history">
	<cfset 'id_#contract_history_id#' = 0>
</cfoutput>
    <cfif get_contract_history.recordcount>
       
        <cfset temp_ = 0>
            <cfset process_catid_list = "">
            <cfset project_id_list = "">
            <cfset department_in_list = "">	
            <cfset record_emp_list = "">
            <cfoutput query="get_contract_history">
            
                <cfif len(stage_id) and not listfind(process_catid_list,stage_id)>
                    <cfset process_catid_list=listappend(process_catid_list,stage_id)>
                </cfif>
                <cfif len(project_id) and not listfind(project_id_list,project_id)>
                    <cfset project_id_list=listappend(project_id_list,project_id)>
                </cfif>
                <cfif len(deliver_dept_id) and not listfind(department_in_list,deliver_dept_id)>
                    <cfset department_in_list=listappend(department_in_list,deliver_dept_id)>
                </cfif>
                <cfif len(record_emp) and not listfind(record_emp_list,record_emp)>
                    <cfset record_emp_list=listappend(record_emp_list,record_emp)>
                </cfif>
        
            <cfif len(process_catid_list)>
                <cfquery name="get_process_stage" datasource="#dsn#">
                    SELECT PROCESS_ID,STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ID IN (#process_catid_list#) ORDER BY PROCESS_ID
                </cfquery>
                <cfset process_catid_list = listsort(listdeleteduplicates(valuelist(get_process_stage.process_id,',')),'numeric','ASC',',')>
            </cfif>
            <cfif len(project_id_list)>
                <cfquery name="get_project_name" datasource="#dsn#">
                    SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_id_list#) ORDER BY PROJECT_ID
                </cfquery>
                <cfset project_id_list = listsort(listdeleteduplicates(valuelist(get_project_name.project_id,',')),'numeric','ASC',',')>
            </cfif>
            <cfif len(department_in_list)>
                <cfquery name="get_department_in" datasource="#dsn#">
                    SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID IN (#department_in_list#) ORDER BY DEPARTMENT_ID
                </cfquery>
                <cfset department_in_list = listsort(listdeleteduplicates(valuelist(get_department_in.department_id,',')),'numeric','ASC',',')>
            </cfif>
            <cfif len(record_emp_list)>
                <cfquery name="get_record_name" datasource="#dsn#">
                    SELECT EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#record_emp_list#) ORDER BY EMPLOYEE_ID
                </cfquery>
                <cfset record_emp_list = listsort(listdeleteduplicates(valuelist(get_record_name.employee_id,',')),'numeric','ASC',',')>
            </cfif>           
            <cfset temp_ = temp_ +1>
                <cfquery name="get_loc_out" dbtype="query">
                    SELECT * FROM get_location_name <cfif len(location_id) and len(deliver_dept_id)> WHERE DEPARTMENT_ID = #deliver_dept_id#  AND LOCATION_ID = #location_id# </cfif>
                </cfquery>
            <cf_seperator id="history_#temp_#" header="#dateformat(update_date,dateformat_style)# (#timeformat(dateadd('h',session.ep.time_zone,update_date),timeformat_style)#) - #UPDATE_NAME#" is_closed="1">
            <cf_ajax_list id="history_#temp_#">
                <tbody>	
                    <tr>
                        
                        <td width="100"><b><cf_get_lang dictionary_id ='58859.Süreç'></b></td>
                        <td width="100">#get_process_stage.stage#</td>                        
                        <td width="100"><b><cf_get_lang dictionary_id ='30044.Sözleşme No'></b></td>
                        <td width="100">#contract_no#</td>
                        <td width="100"><b><cf_get_lang dictionary_id ='57416.Proje'></b></td>
                        <td width="100"><cfif len(project_id)>#get_project_name.project_head[listfind(project_id_list,project_id,',')]#</cfif></td>
                        
                    </tr>
                    <tr>
                        <td  width="100"><b><cf_get_lang dictionary_id ='50985.Sözleşme Tutarı'></b></td>
                        <td width="100">#TLFormat(contract_amount)#</td>
                        <td width="100"><b><cf_get_lang dictionary_id ='58053.Başlangıç Tarih'></b></td>
                        <td width="100">#DateFormat(startdate,dateformat_style)#</td>
                        <td width="100"><b><cf_get_lang dictionary_id ='57700.Bitiş Tarih'></b></td>
                        <td width="100">#DateFormat(finishdate,dateformat_style)#</td>      
                    </tr>
                    <tr>
                      
                       <td width="100"><b><cf_get_lang dictionary_id ='58763.Depo'></b></td>
                        <td width="100"><cfif len(department_in_list)>#get_loc_out.comment#</cfif></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr> 
                    <tr>
                        <td width="100"><b><cf_get_lang dictionary_id ='57899.Kaydeden'></b></td>
                        <td width="100">#get_record_name.employee_name[listfind(record_emp_list,record_emp,',')]# #get_record_name.employee_surname[listfind(record_emp_list,record_emp,',')]#</td>
                        <td width="100"><b><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></b></td>
                        <td width="100">#DateFormat(record_date,dateformat_style)#</td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                </tbody>   
        </cf_ajax_list>
    </cfoutput>
        <cfelse>
            <tr>
                <td colspan="13"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td> 
            </tr>
    </cfif>

