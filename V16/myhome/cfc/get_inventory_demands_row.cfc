<cfcomponent>
    <cffunction name="inventory_demands" access="public" returntype="query">
            <cfargument name="employee_id" required="no" type="numeric"/>
            <cfargument name="inventory_demand_id" required="no" type="numeric">
            <cfargument name="is_valid_control" required="no" type="numeric">
            <cfargument name="keyword" required="no" type="string">
            <cfargument name="branch_id" required="no" type="string">
            <cfargument name="company_id" required="no" type="string">
            <cfargument name="department_id" required="no" type="string">
            <cfargument name="process_stage" type="string">
            <cfquery name="get_inventory_demand" datasource="#this.dsn#">
                SELECT TOP 1
                            ID.*,
                            E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS EMPLOYEE_NAME,
                            E.GROUP_STARTDATE,
                            D.DEPARTMENT_HEAD,
                            B.BRANCH_NAME,
                            OC.COMP_ID,
                            OC.COMPANY_NAME,
                            PTR.STAGE,
                            EP.POSITION_ID,
                            EP.POSITION_NAME,
                            EP2.EMPLOYEE_NAME +' '+ EP2.EMPLOYEE_SURNAME AS MANAGER_NAME_SURNAME,
                            ID.RECORD_DATE,
                            EIO.FINISH_DATE
                        FROM
                            EMPLOYEES_INVENTORY_DEMAND ID INNER JOIN EMPLOYEES E ON ID.EMPLOYEE_ID = E.EMPLOYEE_ID
                            INNER JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID
                            LEFT JOIN EMPLOYEE_POSITIONS EP2 ON EP.UPPER_POSITION_CODE = EP2.POSITION_CODE
                            INNER JOIN DEPARTMENT D ON D.DEPARTMENT_ID = ID.DEPARTMENT_ID
                            INNER JOIN BRANCH B  ON B.BRANCH_ID = D.BRANCH_ID
                            INNER JOIN OUR_COMPANY OC ON OC.COMP_ID = B.COMPANY_ID
                            INNER JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = ID.DEMAND_STAGE
                            LEFT JOIN EMPLOYEES_IN_OUT EIO ON EIO.EMPLOYEE_ID =  ID.EMPLOYEE_ID AND EIO.VALID = 1
                WHERE
                    ID.EMPLOYEE_ID IS NOT NULL
                    <cfif isdefined('arguments.employee_id')>
                        AND ID.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                    </cfif>  
                   ORDER BY
                    ID.RECORD_DATE DESC        
            </cfquery>
      <cfreturn get_inventory_demand>
    </cffunction>
</cfcomponent>
