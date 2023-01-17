<cfcomponent>   
       <!--- TALEP Listeleme --->
      <cffunction name="GET_DEMANDS_FNC" returntype="query"> 
            <cfargument name="keyword" default="">
            <cfargument name="assetp_sub_catid" default="">
            <cfargument name="assetp_catid" default="">
            <cfargument name="req_emp_id" default="">
            <cfargument name="comp_id" default="">
            <cfargument name="branch_id" default="">
            <cfargument name="department" default="">
            <cfargument name="brand_type_id" default="">
            <cfargument name="make_year" default="">
            <cfargument name="process_stage" default="">            
            <cfargument name="startdate" default="">
            <cfargument name="finishdate" default="">
            <cfargument name="asset_p_status" default="">
            <cfquery name="get_assetp_demands" datasource="#this.dsn#">
                SELECT 
                    E.EMPLOYEE_NAME,
                    E.EMPLOYEE_SURNAME,
                    APD.REQUEST_DATE,
                    APD.DEMAND_ID,
                    APD.RESULT_ID,
                    APD.RECORD_DATE,
                    APD.ASSETP_CATID,
                    APD.RECORD_EMP,
                    APD.DEMAND_ID,
                    APD.EMPLOYEE_ID,
                    APD.BRAND_TYPE_ID,
                    APD.ASSETP_SUB_CATID,
                    APC.ASSETP_CAT,
                    SUP.USAGE_PURPOSE,
                    APSC.ASSETP_SUB_CAT,
                    PTR.STAGE,
                    APD.ASSET_P_STATUS
                FROM 
                    ASSET_P_DEMAND APD INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = APD.EMPLOYEE_ID
                    LEFT JOIN ASSET_P_CAT APC ON APD.ASSETP_CATID = APC.ASSETP_CATID
                    LEFT JOIN SETUP_USAGE_PURPOSE SUP ON APD.USAGE_PURPOSE_ID = SUP.USAGE_PURPOSE_ID
                    LEFT JOIN ASSET_P_SUB_CAT APSC ON APSC.ASSETP_CATID=APD.ASSETP_CATID AND APSC.ASSETP_SUB_CATID=APD.ASSETP_SUB_CATID
                    LEFT JOIN EMPLOYEE_POSITIONS EP ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID
                    LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = EP.DEPARTMENT_ID
                    LEFT JOIN BRANCH B ON B.BRANCH_ID = D.BRANCH_ID
                    LEFT JOIN OUR_COMPANY OC ON OC.COMP_ID = B.COMPANY_ID
                    LEFT JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = APD.STAGE
                WHERE
                    EP.IS_MASTER = 1
                    <cfif isDefined("arguments.keyword") and len(arguments.keyword)>
                        AND
                        (
                            APC.ASSETP_CAT LIKE '<cfif len(arguments.keyword) gt 1>%</cfif>#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
                            E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME LIKE '<cfif len(arguments.keyword) gt 1>%</cfif>#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
                        
                        )
                    </cfif>
                    <cfif len(arguments.assetp_sub_catid)>
                        AND APD.ASSETP_SUB_CATID = #arguments.assetp_sub_catid#
                    </cfif>
                    <cfif len(arguments.assetp_catid)>
                        AND APD.ASSETP_CATID = #arguments.assetp_catid#
                    </cfif>
                    <cfif len(arguments.asset_p_status)>
                	AND ASSET_P_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.asset_p_status#">
                </cfif>
                    <cfif isdefined('arguments.req_emp_id') and len(arguments.req_emp_id)>
                        AND APD.EMPLOYEE_ID = #arguments.req_emp_id#
                    </cfif>
                    <cfif isdefined('arguments.comp_id') and len(arguments.comp_id)>
                        AND OC.COMP_ID = #arguments.comp_id#
                    </cfif>
                    <cfif isdefined('arguments.branch_id') and len(arguments.branch_id)>
                        AND B.BRANCH_ID = #arguments.branch_id#
                    </cfif>
                    <cfif isdefined('arguments.department') and len(arguments.department)>
                        AND D.DEPARTMENT_ID = #arguments.department#
                    </cfif>
                    <cfif isdefined('arguments.brand_type_id') and len(arguments.brand_type_id)>
                        AND APD.BRAND_TYPE_ID = #arguments.brand_type_id#
                    </cfif>
                    <cfif isdefined('arguments.make_year') and len(arguments.make_year)>
                        AND APD.MAKE_YEAR = #arguments.make_year#
                    </cfif>
                    <cfif isdefined('arguments.process_stage') and len(arguments.process_stage)>
                        AND APD.STAGE = #arguments.process_stage#
                    </cfif>
                    <cfif isdefined('arguments.startdate') and isdate(arguments.startdate)>
                        AND APD.REQUEST_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.startdate#">
                    </cfif>
                    <cfif isdefined('arguments.finishdate') and isdate(arguments.finishdate)>
                        AND APD.REQUEST_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.finishdate#">
                    </cfif>
                ORDER BY 
                    APD.REQUEST_DATE DESC,
                    APD.RESULT_ID
            </cfquery>
            <cfreturn get_assetp_demands>
          </cffunction> 
</cfcomponent> 
