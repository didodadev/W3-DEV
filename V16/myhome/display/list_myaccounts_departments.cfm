<cfsetting showdebugoutput="no">
<cfquery name="get_emp_branches" datasource="#dsn#">
	SELECT BRANCH_ID,DEPARTMENT_ID,LOCATION_ID FROM EMPLOYEE_POSITION_DEPARTMENTS WHERE POSITION_CODE = #session.ep.position_code# AND OUR_COMPANY_ID = (SELECT OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID = #attributes.period_id#)
</cfquery>
<cfif get_emp_branches.recordcount>
	<cfset control_ =  "#get_emp_branches.department_id#-#get_emp_branches.branch_id#">
<cfelseif listlen(session.ep.user_location,'-') eq 3>
	<cfset control_ =  ListDeleteAt(session.ep.user_location,3,'-')>
<cfelse>
	<cfset control_ =  session.ep.user_location>
</cfif>
<cfquery name="ALL_DEPARTMENTS_IC" datasource="#DSN#">
	SELECT DISTINCT
		DEPARTMENT.DEPARTMENT_ID, 
		DEPARTMENT.DEPARTMENT_HEAD, 
		BRANCH.BRANCH_NAME,
		BRANCH.BRANCH_ID 
	FROM 
		DEPARTMENT, 
		BRANCH,
		EMPLOYEE_POSITION_BRANCHES,
		SETUP_PERIOD SP
	WHERE 
		BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID AND
		BRANCH.BRANCH_ID = EMPLOYEE_POSITION_BRANCHES.BRANCH_ID AND
		EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code# AND
		EMPLOYEE_POSITION_BRANCHES.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
		BRANCH.COMPANY_ID = SP.OUR_COMPANY_ID AND
		SP.PERIOD_ID = #attributes.period_id# AND
		BRANCH.BRANCH_STATUS = 1 AND
		DEPARTMENT.DEPARTMENT_STATUS = 1
	ORDER BY 
		BRANCH.BRANCH_NAME,	
		DEPARTMENT.DEPARTMENT_HEAD
</cfquery>

<div class="form-group2">
    <select name="USER_LOCATION_AJAX" id="USER_LOCATION_AJAX" style="width:220px;" class="form-control">
        <cfoutput query="ALL_DEPARTMENTS_IC">
            <option value="#department_id#-#branch_id#" <cfif control_ is '#department_id#-#branch_id#'>selected</cfif>>#branch_name# / #department_head#</option>
        </cfoutput>
    </select>
</div>
