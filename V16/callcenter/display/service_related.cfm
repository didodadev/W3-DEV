<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_branch.cfm">
<cfset branch_id_list = ValueList(get_branch.branch_id)>
<!---<cfset branch_id_list=listsort(valuelist(get_branch.branch_id),"numeric","ASC",",")>--->
<cfquery name="GET_PROCESS_LIST_1" datasource="#DSN#">
	SELECT
  		PTR.STAGE,
		PTR.PROCESS_ROW_ID,
		PTRP.PRO_POSITION_ID PRO_POSITION_ID
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT,
		PROCESS_TYPE_ROWS_POSID PTRP
	WHERE
		PT.IS_ACTIVE = 1 AND
		PTR.PROCESS_ID = PT.PROCESS_ID AND
		PTRP.PROCESS_ROW_ID = PTR.PROCESS_ROW_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%call.list_service,%"> AND
		PTRP.PRO_POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
</cfquery>
<cfset process_type_list = ValueList(get_process_list_1.process_row_id)>
<!--- 10 kayıt gelmesi daha makul--->
<cfquery name="GET_SERVICE" datasource="#DSN#" maxrows="10">
	SELECT
		S.SERVICE_DETAIL,
		S.SERVICE_NO,
		S.UPDATE_MEMBER,
		S.RECORD_MEMBER,
		S.APPLY_DATE,
		S.SERVICE_BRANCH_ID,
		S.SERVICE_ID,
		SA.SERVICECAT,
		SP.PRIORITY,
		SP.COLOR,
		PROCESS_TYPE_ROWS.STAGE
	FROM
		G_SERVICE S,
		G_SERVICE_APPCAT SA,
		SETUP_PRIORITY AS SP,
		PROCESS_TYPE_ROWS
	WHERE 
		(
            S.SERVICE_BRANCH_ID IS NULL
            <cfif listlen(branch_id_list)>
                OR
                SERVICE_BRANCH_ID IN (#branch_id_list#)
            </cfif>
		) AND
		S.SERVICECAT_ID = SA.SERVICECAT_ID AND
		SP.PRIORITY_ID = S.PRIORITY_ID AND
		<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
        	S.SERVICE_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
        <cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
        	S.SERVICE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
		<cfelseif isdefined("attributes.employee_id") and len(attributes.employee_id)>
	        S.SERVICE_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
        </cfif>
        S.SERVICE_STATUS_ID = PROCESS_TYPE_ROWS.PROCESS_ROW_ID
        <cfif isdefined("attributes.service_id")>
        	AND S.SERVICE_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
        </cfif>
	ORDER BY
		S.RECORD_DATE DESC
</cfquery>

<cf_ajax_list>
	<thead>
		<tr>
		  <th width="50"><cf_get_lang_main no='75.No'></th>	
		  <th width="110"><cf_get_lang_main no='330.Tarih'></th>
		  <th width="110"><cf_get_lang_main no='41.Şube'></th>
          <th><cf_get_lang_main no='74.Kategori'></th>
		  <th width="75"><cf_get_lang_main no='70.Aşama'></th>
		  <th width="125"><cf_get_lang_main no='1174.İşlem Yapan'></th>
          <th><cf_get_lang_main no='217.Açıklama'></th> 
		  <th width="1%"></th>         
		</tr>
	</thead>
	<tbody>
		<cfset record_list = ""> 
		<cfset update_list = "">
		<cfoutput query="get_service">
			<cfif len(record_member) and not listfind(record_list,record_member)>
            	<cfset record_list=listappend(record_list,record_member)>
            </cfif>
            <cfif len(update_member) and not listfind(update_list,update_member)>
            	<cfset update_list=listappend(update_list,update_member)>
            </cfif>
        </cfoutput>
        <cfif len(record_list)>
            <cfset record_list=listsort(record_list,"numeric","ASC",",")>
            <cfquery name="GET_RECORD_EMP" datasource="#DSN#">
            	SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN(#record_list#)
            </cfquery>
            <cfset record_list = valuelist(get_record_emp.employee_id,',')>
        </cfif>
        <cfif len(update_list)>
            <cfset update_list=listsort(update_list,"numeric","ASC",",")>
            <cfquery name="GET_UPDATE_EMP" datasource="#DSN#">
            	SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN(#update_list#)
            </cfquery>
            <cfset update_list = valuelist(get_update_emp.employee_id,',')>
        </cfif>
        <cfoutput query="get_service">
            <tr>
                <td><a href="#request.self#?fuseaction=call.list_service&event=upd&service_id=#service_id#" class="tableyazi">#service_no#</a></td>
                <td><cfif len(apply_date)>#dateformat(apply_date,dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,apply_date),timeformat_style)#)</cfif>&nbsp;</td>
                <td><cfif len(service_branch_id)>#get_branch.branch_name[listfind(branch_id_list,service_branch_id,',')]#</cfif>&nbsp;</td>
                <td>#servicecat#</td>
                <td>#stage#</td> 
                <td>
					<cfif len(update_list) and len(update_member)>
                    	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#update_member#','medium');" class="tableyazi">#get_update_emp.employee_name[listfind(update_list,update_member,',')]# #get_update_emp.employee_surname[listfind(update_list,update_member,',')]#</a>
                    <cfelseif len(record_list) and len(record_member)>
                    	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_member#','medium');" class="tableyazi">#get_record_emp.employee_name[listfind(record_list,record_member,',')]# #get_record_emp.employee_surname[listfind(record_list,record_member,',')]#</a>
                    </cfif>&nbsp;
                </td>    
                <td title="#service_detail#">#left(service_detail,25)#</td>
                <td><a href="#request.self#?fuseaction=call.list_service&event=upd&service_id=#service_id#" class="tableyazi"><img src="/images/update_list.gif" alt="Güncelle" border="0"></a></td>       
            </tr>
        </cfoutput>
	</tbody>
</cf_ajax_list>
