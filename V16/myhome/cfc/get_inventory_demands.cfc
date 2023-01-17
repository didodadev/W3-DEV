<cfcomponent>
<cffunction name="inventory_demands" access="public" returntype="query">
    	<cfargument name="employee_id" required="no" type="numeric"/>
        <cfargument name="inventory_demand_id" required="no" type="numeric">
        <cfargument name="is_manager_valid_control" required="no" type="numeric">
        <cfargument name="keyword" required="no" type="string">
        <cfargument name="branch_id" required="no" type="string">
        <cfargument name="company_id" required="no" type="string">
        <cfargument name="department_id" required="no" type="string">
        <cfargument name="startdate" required="no" type="date">
        <cfargument name="finishdate" required="no" type="date">
        <cfargument name="process_stage" type="string">
		<cfquery name="get_inventory_demand" datasource="#this.dsn#">
			SELECT 
                TBL.*,
                STUFF(
                    (SELECT ',' + CONVERT(VARCHAR,A.INVENTORY_CAT_ID) FROM 
                        (SELECT DISTINCT RS.INVENTORY_CAT_ID,RS.INVENTORY_DEMAND_ID FROM EMPLOYEES_INVENTORY_DEMAND_ROWS RS) A
                    WHERE A.INVENTORY_DEMAND_ID=TBL.INVENTORY_DEMAND_ID FOR XML PATH('')
                ),1,1,'') AS INVENTORY_CAT_ID_LIST,
                STUFF(
                    (SELECT ',' + CONVERT(VARCHAR,A.INVENTORY_VALUE) FROM 
                        (SELECT ISNULL(RS.INVENTORY_VALUE,' ') AS INVENTORY_VALUE,RS.INVENTORY_DEMAND_ID,RS.INVENTORY_CAT_ID FROM EMPLOYEES_INVENTORY_DEMAND_ROWS RS) A
                    WHERE A.INVENTORY_DEMAND_ID=TBL.INVENTORY_DEMAND_ID ORDER BY INVENTORY_CAT_ID FOR XML PATH('')
                ),1,1,'') AS INVENTORY_VALUE_LIST
            FROM
            (SELECT DISTINCT
                        ID.INVENTORY_DEMAND_ID,
                        ID.RECORD_DATE,
                        ID.RECORD_EMP,
                        ID.UPDATE_DATE,
                        ID.UPDATE_EMP,
                        ID.MANAGER_VALID,
                        ID.MANAGER_VALID_DATE,
                        ID.IT_VALID,
                        ID.IT_VALID_DATE,
                        ID.EMPLOYEE_VALID,
                        ID.EMPLOYEE_VALID_DATE,
                        ID.DEMAND_STAGE,
                        ID.FORM_TYPE,
                        ID.EMPLOYEE_ID,
                        ID.COMPANY_ID,
                        EIO.FINISH_DATE,
                        ID.RCD_DEFINITION,
                        ID.MOBILE_CODE,
                        ID.MOBILE_TEL,
                        ID.INTERCOM,
                        ID.EMP_TABLE,
                        E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME AS EMPLOYEE_NAME,
                        E.GROUP_STARTDATE AS STARTDATE,
                        D.DEPARTMENT_HEAD,
                        ID.DEPARTMENT_ID,
                        B.BRANCH_NAME,
                        ID.BRANCH_ID,
                        OC.COMPANY_NAME,
                        PTR.STAGE,
                        EP.POSITION_ID,
                        EP.POSITION_NAME,
                        EP.UPPER_POSITION_CODE,
                        EP2.EMPLOYEE_NAME +' '+ EP2.EMPLOYEE_SURNAME AS MANAGER_NAME_SURNAME,
                        IDR.REASON_TYPE,
                        IDR.REASON_DEFINITION
                    FROM
                        EMPLOYEES_INVENTORY_DEMAND ID INNER JOIN EMPLOYEES E ON ID.EMPLOYEE_ID = E.EMPLOYEE_ID
                        LEFT JOIN EMPLOYEES_IN_OUT EIO ON EIO.EMPLOYEE_ID = E.EMPLOYEE_ID AND EIO.VALID = 1
                        LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID
                        LEFT JOIN EMPLOYEES_INVENTORY_DEMAND_ROWS IDR ON IDR.INVENTORY_DEMAND_ID = ID.INVENTORY_DEMAND_ID
                        INNER JOIN DEPARTMENT D ON D.DEPARTMENT_ID = ID.DEPARTMENT_ID
                        INNER JOIN BRANCH B  ON B.BRANCH_ID = D.BRANCH_ID
                        INNER JOIN OUR_COMPANY OC ON OC.COMP_ID = B.COMPANY_ID
                        INNER JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = ID.DEMAND_STAGE
                        LEFT JOIN EMPLOYEE_POSITIONS EP2 ON EP2.POSITION_CODE = EP.UPPER_POSITION_CODE 
                    WHERE
                        ID.EMPLOYEE_ID IS NOT NULL
                        <cfif isdefined('arguments.employee_id')>
                            AND ID.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                        </cfif>
                        <cfif isdefined('arguments.inventory_demand_id')>
                            AND ID.INVENTORY_DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.inventory_demand_id#">
                        </cfif>
                        <cfif isdefined('arguments.is_manager_valid_control') and arguments.is_manager_valid_control eq 1><!---yönetici onay bekleyen --->
                            AND
                                (
                                    (
                                        EP.UPPER_POSITION_CODE = <cfif isDefined("session.ep.position_code")><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.position_code#"></cfif>
                                        AND ID.MANAGER_VALID IS NULL
                                        AND ID.MANAGER_VALID_DATE IS NULL
                                    )
                                    OR
                                    (
                                        ID.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                                        AND ID.MANAGER_VALID IS NOT NULL
                                        AND ID.MANAGER_VALID_DATE IS NOT NULL
                                        AND ID.IT_VALID IS NOT NULL
                                        AND ID.IT_VALID_DATE IS NOT NULL
                                        AND ID.EMPLOYEE_VALID IS NULL
                                        AND ID.EMPLOYEE_VALID_DATE IS NULL
                                    )
                                )
                        </cfif>
                        <cfif isdefined('arguments.keyword') and len(arguments.keyword)>
                            AND 
                                (
                                    E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                                )
                        </cfif>
                        <cfif isdefined('arguments.company_id') and len(arguments.company_id)>
                            AND OC.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
                        </cfif>
                        <cfif isdefined('arguments.branch_id') and len(arguments.branch_id)>
                            AND B.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">
                        </cfif>
                        <cfif isdefined('arguments.department_id') and len(arguments.department_id)>
                            AND D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#">
                        </cfif>
                        <cfif isdefined('arguments.process_stage') and len(arguments.process_stage)>
                            AND ID.DEMAND_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">
                        </cfif>
                        <cfif isdefined('arguments.startdate') and len(arguments.startdate) and isdefined('arguments.finishdate') and len(arguments.finishdate)>
                        AND 
                        (
                                ID.RECORD_DATE >= #arguments.startdate# AND
                                ID.RECORD_DATE <= #arguments.finishdate#
                        )   
                        </cfif>   
                     ) AS TBL   
            	ORDER BY
            		TBL.RECORD_DATE DESC        
        </cfquery>
  <cfreturn get_inventory_demand>
</cffunction>
</cfcomponent>
