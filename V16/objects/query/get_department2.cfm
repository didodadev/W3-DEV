<cfquery name="GET_DEPARTMENT" datasource="#DSN#">
	SELECT 
		DEPARTMENT_ID,
        DEPARTMENT_HEAD
	FROM 
		DEPARTMENT
	WHERE 
		IS_STORE <> 2
		<cfif isdefined("attributes.is_sale_store")>
            AND BRANCH_ID IN 
                (
                SELECT
                    BRANCH_ID
                FROM
                    EMPLOYEE_POSITION_BRANCHES
                WHERE
                    BRANCH_ID IN (SELECT BRANCH_ID FROM BRANCH WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">) AND
                    POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
                )
        </cfif>
        <cfif isDefined("attributes.branch_id")>
            AND	BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
        </cfif>
	ORDER BY 
		DEPARTMENT_HEAD
</cfquery>
<cfset employee_dept_list_ = valuelist(get_department.department_id)>
