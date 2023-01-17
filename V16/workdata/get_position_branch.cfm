	<!--- 
      Amaç:Pozisyon Yetkisine Göre Şubeleri Getirmek 
	  Yazan:Mahmut Er
	  Tarih:18.08.2008
	  --->

<cffunction name="get_position_branch" access="public" returnType="query" output="no">
	<cfif (not session.ep.ehesap)>
        <cfquery name="get_emp_branch" datasource="#dsn#">
            SELECT
                BRANCH_ID
            FROM
                EMPLOYEE_POSITION_BRANCHES	
            WHERE
                POSITION_CODE = #SESSION.EP.POSITION_CODE#
        </cfquery>
        <cfset emp_branch_list = valuelist(get_emp_branch.BRANCH_ID)>
        <cfif not len(emp_branch_list)><cfset emp_branch_list = 0></cfif>
    </cfif>
	<cfquery name="get_branch" datasource="#dsn#">
		SELECT 
			BRANCH_ID,BRANCH_NAME
		FROM 
			BRANCH 
        <cfif (not session.ep.ehesap)>
		 WHERE 
			BRANCH_ID IN (#emp_branch_list#) 
        </cfif>    
	</cfquery>
	<cfreturn get_branch >
</cffunction>
	
