<cfquery name="STORES" datasource="#DSN#">
	SELECT
		D.DEPARTMENT_ID,
        D.DEPARTMENT_HEAD
        <cfif attributes.fuseaction eq 'purchase.add_order_product_all_criteria'>        
            ,SL.LOCATION_ID
            ,SL.STATUS
            ,SL.COMMENT
        </cfif>
	FROM
		DEPARTMENT D
        <cfif attributes.fuseaction eq 'purchase.add_order_product_all_criteria'>
       		,STOCKS_LOCATION SL
        </cfif>
	WHERE 
		D.IS_STORE <> 2 AND	
		D.DEPARTMENT_STATUS = 1 AND
		D.BRANCH_ID IN (SELECT BRANCH_ID FROM BRANCH WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">)
        <cfif attributes.fuseaction eq 'purchase.add_order_product_all_criteria'>
        	AND SL.DEPARTMENT_ID = D.DEPARTMENT_ID
        </cfif>
		<cfif session.ep.isBranchAuthorization>
			AND D.BRANCH_ID IN(SELECT 
                    BRANCH.BRANCH_ID
                FROM 
                    BRANCH, 
                    EMPLOYEE_POSITION_BRANCHES
                WHERE 
                    EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
                    EMPLOYEE_POSITION_BRANCHES.BRANCH_ID = BRANCH.BRANCH_ID )
        </cfif>
	ORDER BY
		D.DEPARTMENT_HEAD
</cfquery>
