<cfquery name="GET_EMP_WORKGROUP" datasource="#DSN#">
	SELECT 
	    WORK_GROUP.WORKGROUP_ID,
		WORK_GROUP.WORKGROUP_NAME,
		WORKGROUP_EMP_PAR.*
	FROM
    	WORKGROUP_EMP_PAR,
		WORK_GROUP 
	WHERE
    	WORKGROUP_EMP_PAR.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#detail_emp.employee_id#"> AND 
		WORKGROUP_EMP_PAR.WORKGROUP_ID = WORK_GROUP.WORKGROUP_ID
</cfquery>
<tr>
    <td class="txtbold" ><cf_get_lang no='443.Workgroup'></td>
	<td colspan="3" height="22">
	  	<cfif get_emp_workgroup.recordcount>
	  		<cfoutput query="get_emp_workgroup">
	   	  		#workgroup_name# - #role_head#,
			</cfoutput>
		</cfif>
	</td>
</tr>
