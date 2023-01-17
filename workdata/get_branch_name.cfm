<!--- Amaç :POSITION_CODE'a bağlı olarak şubelere ulaşılmakta.
 --->
<cffunction name="get_branch_name" access="public" returnType="query" output="no">
	<cfargument name="branch_name" required="yes" type="string">
    <cfquery name="get_emp_branch" datasource="#DSN#">
            SELECT
                *
            FROM
                EMPLOYEE_POSITION_BRANCHES	
            WHERE
                POSITION_CODE = #SESSION.EP.POSITION_CODE#
    </cfquery>
	<cfset emp_branch_list=valuelist(get_emp_branch.BRANCH_ID)>
<cfif len(emp_branch_list)>
	<cfset emp_branch_list=ListSort(listdeleteduplicates("#emp_branch_list#,#ListGetAt(session.ep.user_location,2,"-")#"),"Numeric")>
<cfelse>
	<cfset emp_branch_list=ListGetAt(session.ep.user_location,2,"-")>
</cfif>
<cfif not listlen(listsort(emp_branch_list,'numeric'))>
	<cfset emp_branch_list = 0>
</cfif>
	<cfquery name="get_branch" datasource="#dsn#">
             SELECT 
                ZONE.ZONE_NAME,
                BRANCH.BRANCH_NAME,
                BRANCH.BRANCH_ID,
                OUR_COMPANY.NICK_NAME
            FROM 
                BRANCH,
                ZONE,
                OUR_COMPANY
            WHERE 
                BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID AND 
                ZONE.ZONE_ID = BRANCH.ZONE_ID AND
                ZONE_STATUS = 1 AND
                BRANCH_STATUS = 1 AND
                BRANCH.BRANCH_ID IN (#emp_branch_list#) AND 
                BRANCH.BRANCH_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.branch_name#%">
            ORDER BY
                BRANCH.HIERARCHY,
                ZONE.ZONE_NAME,
                BRANCH.BRANCH_NAME
        </cfquery>
    <cfreturn get_branch>
</cffunction>
