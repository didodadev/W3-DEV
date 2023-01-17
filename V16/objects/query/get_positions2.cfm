<cfinclude template="../../objects/query/get_acc_types.cfm">
<cfparam name="attributes.field_name" type="string" default="">
<cfif isdefined('attributes.show_rel_pos') and attributes.show_rel_pos eq 1>
<cfquery name="get_control_val" datasource="#dsn#">
    SELECT 
         PROPERTY_VALUE,
         PROPERTY_NAME
   FROM
         FUSEACTION_PROPERTY
    WHERE
         OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
         FUSEACTION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="myhome.welcome"> AND
         PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="xml_rel_pos">
</cfquery>
</cfif>
<cfquery name="GET_POSITIONS" datasource="#DSN#">
	SELECT
        DISTINCT
		*
	FROM
	(
		<cfif isdefined("attributes.is_display_self") and isdefined("x_add_multi_acc") and x_add_multi_acc eq 1 and isdefined("attributes.is_cari_action") and attributes.is_cari_action eq 1>
					
            SELECT
                <cfif not isDefined("attributes.show_empty_pos")>EMPLOYEES.GROUP_STARTDATE,</cfif>
                EMPLOYEE_POSITIONS.EMPLOYEE_ID,
                EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
                EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
                EMPLOYEE_POSITIONS.EMPLOYEE_EMAIL,
                EMPLOYEE_POSITIONS.POSITION_CODE,
                EMPLOYEE_POSITIONS.POSITION_NAME,
                EMPLOYEE_POSITIONS.POSITION_ID,
                EMPLOYEE_POSITIONS.POSITION_CAT_ID,
                EMPLOYEE_POSITIONS.TITLE_ID,
                EMPLOYEE_POSITIONS.FUNC_ID,
                EMPLOYEE_POSITIONS.COLLAR_TYPE,
                EMPLOYEE_POSITIONS.ORGANIZATION_STEP_ID,
                SETUP_POSITION_CAT.POSITION_CAT,
                EMPLOYEE_POSITIONS.IS_MASTER,
                BRANCH.BRANCH_NAME,
                BRANCH.BRANCH_ID,
                DEPARTMENT.DEPARTMENT_HEAD,
                DEPARTMENT.DEPARTMENT_ID,
                OUR_COMPANY.COMP_ID,
                OUR_COMPANY.NICK_NAME,
                <cfif isdefined("attributes.field_member_account_code")>
                    <cfif isdefined("x_add_multi_acc") and x_add_multi_acc eq 1 and isdefined("attributes.is_cari_action") and attributes.is_cari_action eq 1>
                        EA.ACCOUNT_CODE,
                    <cfelse>
                        (SELECT TOP 1 EIOP.ACCOUNT_CODE FROM EMPLOYEES_IN_OUT_PERIOD EIOP,EMPLOYEES_IN_OUT EIO WHERE EIOP.IN_OUT_ID = EIO.IN_OUT_ID AND EIO.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND (EIOP.ACCOUNT_CODE IS NOT NULL OR EIOP.ACCOUNT_CODE <> '') ORDER BY EIO.IN_OUT_ID DESC) AS ACCOUNT_CODE,			
                    </cfif>
                </cfif>
                OUR_COMPANY.HEADQUARTERS_ID
                <cfif isdefined("x_add_multi_acc") and x_add_multi_acc eq 1 and isdefined("attributes.is_cari_action") and attributes.is_cari_action eq 1>
                    ,EA.ACC_TYPE_ID
                    ,EIO.FINISH_DATE
                    ,(SELECT SAT.ACC_TYPE_NAME FROM SETUP_ACC_TYPE SAT WHERE SAT.ACC_TYPE_ID=EA.ACC_TYPE_ID) ACC_TYPE_NAME
                </cfif>
                <cfif not isDefined("attributes.show_empty_pos") OR isDefined("attributes.field_emp_no")>,EMPLOYEES.EMPLOYEE_NO</cfif>
            FROM
                EMPLOYEE_POSITIONS
                <cfif isdefined("x_add_multi_acc") and x_add_multi_acc eq 1 and isdefined("attributes.is_cari_action") and attributes.is_cari_action eq 1>
                    LEFT JOIN EMPLOYEES_ACCOUNTS EA ON EA.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID AND EA.PERIOD_ID = #session.ep.period_id# 
	                LEFT JOIN EMPLOYEES_IN_OUT EIO ON EIO.IN_OUT_ID = EA.IN_OUT_ID
                </cfif>
                <cfif not isDefined("attributes.show_empty_pos") OR isDefined("attributes.field_emp_no")>,EMPLOYEES</cfif>
                ,DEPARTMENT
                ,BRANCH
                ,OUR_COMPANY
                ,SETUP_POSITION_CAT
            WHERE
                EMPLOYEE_POSITIONS.EMPLOYEE_ID = #session.ep.userid# AND
                EMPLOYEE_POSITIONS.POSITION_CAT_ID = SETUP_POSITION_CAT.POSITION_CAT_ID AND
                EMPLOYEE_POSITIONS.POSITION_STATUS=1 AND
                DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND 
                OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID AND
                EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
            
            <cfif isdefined("xml_filtre_by_dept_id") and xml_filtre_by_dept_id eq 1 and isdefined("xml_department_id") and len(xml_department_id) and attributes.filtre_by_dept_id eq 1>
                <!--- modified : MA 20120718 xml den gelen dept idlere gore filtreleme yapilir --->
                AND EMPLOYEE_POSITIONS.DEPARTMENT_ID IN (#xml_department_id#)
            </cfif>
            <cfif isdefined("attributes.upper_pos_code")>
                AND (EMPLOYEE_POSITIONS.UPPER_POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upper_pos_code#"> 
                <cfif isdefined("attributes.is_position_assistant") and is_position_assistant eq 1>
                    OR EMPLOYEE_POSITIONS.POSITION_ID IN (SELECT POSITION_ID FROM POSITION_ASSISTANT_MODULES WHERE POSITION_ASSISTANT_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"><cfif isDefined('attributes.module_id')> AND POSITION_ASSISTANT_MODULES LIKE '%#attributes.module_id#%' </cfif>)
                </cfif>
                OR EMPLOYEE_POSITIONS.UPPER_POSITION_CODE2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upper_pos_code#"> OR EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
            </cfif>
            <cfif isdefined("attributes.control_pos")>
                AND EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
            </cfif>
            <cfif not isDefined("attributes.show_empty_pos")>
                AND EMPLOYEES.EMPLOYEE_STATUS = 1
                AND EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID 
            <cfelseif isDefined("attributes.show_empty_pos") and isDefined("attributes.from_add_rapid")>
                AND (EMPLOYEE_POSITIONS.POSITION_NAME = '' OR EMPLOYEE_POSITIONS.POSITION_NAME IS NULL OR EMPLOYEE_POSITIONS.EMPLOYEE_ID = '' OR ISNULL(EMPLOYEE_POSITIONS.EMPLOYEE_ID,0) = 0) AND (EMPLOYEE_POSITIONS.EMPLOYEE_NAME = '' OR EMPLOYEE_POSITIONS.EMPLOYEE_NAME IS NULL)
            </cfif>
            <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
                <cfif len(attributes.keyword) eq 1>
                    AND EMPLOYEE_POSITIONS.EMPLOYEE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
                <cfelse>
                    <cfif database_type is 'MSSQL'>
                        AND EMPLOYEE_POSITIONS.EMPLOYEE_NAME + ' ' + EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                    <cfelseif database_type is 'DB2'>
                        AND EMPLOYEE_POSITIONS.EMPLOYEE_NAME || ' ' || EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                    </cfif>
                </cfif>
            </cfif>
            <cfif isDefined("attributes.branch_id") and len(attributes.branch_id)>
                AND BRANCH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
            </cfif>
            <cfif isDefined("attributes.department_id") and len(attributes.department_id)>
                AND DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
            </cfif>
            <!--- session.ep.company_id' ye göre branchler getirilmek istenirse ---> 
            <cfif isDefined("attributes.our_cid")>
                AND BRANCH.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_cid#">
            </cfif>
            <!--- Yetkili olunan şubeler getirilmek istenirse  --->
            <cfif isdefined("attributes.branch_related") or isdefined("xml_branch_control") and xml_branch_control eq 1>
                AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
            </cfif>
            <cfif (isdefined("attributes.employee_list") and attributes.employee_list neq "") or isdefined("attributes.is_store_module")>
                AND EMPLOYEE_POSITIONS.EMPLOYEE_ID IN (
                    SELECT
                        EMPLOYEE_POSITIONS.EMPLOYEE_ID
                    FROM 
                        BRANCH,
                        EMPLOYEE_POSITIONS,
                        DEPARTMENT
                    WHERE
                        BRANCH.BRANCH_ID IN ( SELECT EMPLOYEE_POSITION_BRANCHES.BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> )
                        AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
                        DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
                )
            </cfif>
            <!--- süreç satır idsi yollanırsa sürecde yetkili olan dışında kimse görüntülenmez --->
            <cfif isdefined('attributes.process_row_id') and len(attributes.process_row_id) and (not isdefined('attributes.emp_process_row_id') or attributes.emp_process_row_id eq 1)>
                AND EMPLOYEE_POSITIONS.POSITION_CODE IN 
                (
                    SELECT PRO_POSITION_ID FROM PROCESS_TYPE_ROWS_POSID WHERE PROCESS_TYPE_ROWS_POSID.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_row_id#">
                    UNION
                    SELECT PROCESS_TYPE_ROWS_POSID.PRO_POSITION_ID FROM PROCESS_TYPE_ROWS_WORKGRUOP PROCESS_TYPE_ROWS_WORKGRUOP,PROCESS_TYPE_ROWS_POSID PROCESS_TYPE_ROWS_POSID WHERE PROCESS_TYPE_ROWS_WORKGRUOP.PROCESS_ROW_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_row_id#"> AND PROCESS_TYPE_ROWS_WORKGRUOP.MAINWORKGROUP_ID IS NOT NULL AND PROCESS_TYPE_ROWS_WORKGRUOP.MAINWORKGROUP_ID = PROCESS_TYPE_ROWS_POSID.WORKGROUP_ID
                )
            </cfif>
            <!--- Alt tree kategorisindeki yetkililer disinda kimse gorunmesin PRNet --->
            <cfif isdefined("attributes.tree_category_id") and len(attributes.tree_category_id) and (not isdefined("attributes.sub_tree_category_id") or attributes.sub_tree_category_id eq 1)>
                AND EMPLOYEE_POSITIONS.POSITION_CODE IN
                (
                    SELECT POSITION_CODE FROM G_SERVICE_APPCAT_SUB_STATUS_POST WHERE SERVICE_SUB_STATUS_ID IN (#listsort(listdeleteduplicates(attributes.tree_category_id),"numeric","ASC",",")#)
                UNION
                    SELECT POSITION_CODE_INFO FROM G_SERVICE_APPCAT_SUB_STATUS_INFO WHERE SERVICE_SUB_STATUS_ID IN (#listsort(listdeleteduplicates(attributes.tree_category_id),"numeric","ASC",",")#)
                UNION
                    SELECT
                        EP.POSITION_CODE POSITION_CODE
                    FROM
                        G_SERVICE_APPCAT_SUB_STATUS_POST G_POST,
                        EMPLOYEE_POSITIONS EP
                    WHERE
                        G_POST.POSITION_CAT_ID = EP.POSITION_CAT_ID AND
                        G_POST.SERVICE_SUB_STATUS_ID IN (#listsort(listdeleteduplicates(attributes.tree_category_id),"numeric","ASC",",")#)
                )
            </cfif>
            <cfif isdefined("attributes.filter_by_hierarchy") and len(attributes.filter_by_hierarchy)>
                AND SETUP_POSITION_CAT.HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.filter_by_hierarchy#">
            </cfif>     
        	
			UNION	
		
		</cfif>
        <cfif fusebox.fuseaction is "popup_list_all_positions" AND isdefined("x_add_multi_acc") and x_add_multi_acc eq 1 and isdefined("attributes.is_cari_action") and attributes.is_cari_action eq 1>
            SELECT
                <cfif not isDefined("attributes.show_empty_pos")>EMPLOYEES.GROUP_STARTDATE,</cfif>
                EMPLOYEE_POSITIONS.EMPLOYEE_ID,
                EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
                EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
                EMPLOYEE_POSITIONS.EMPLOYEE_EMAIL,
                EMPLOYEE_POSITIONS.POSITION_CODE,
                EMPLOYEE_POSITIONS.POSITION_NAME,
                EMPLOYEE_POSITIONS.POSITION_ID,
                EMPLOYEE_POSITIONS.POSITION_CAT_ID,
                EMPLOYEE_POSITIONS.TITLE_ID,
                EMPLOYEE_POSITIONS.FUNC_ID,
                EMPLOYEE_POSITIONS.COLLAR_TYPE,
                EMPLOYEE_POSITIONS.ORGANIZATION_STEP_ID,
                SETUP_POSITION_CAT.POSITION_CAT,
                EMPLOYEE_POSITIONS.IS_MASTER,
                BRANCH.BRANCH_NAME,
                BRANCH.BRANCH_ID,
                DEPARTMENT.DEPARTMENT_HEAD,
                DEPARTMENT.DEPARTMENT_ID,
                OUR_COMPANY.COMP_ID,
                OUR_COMPANY.NICK_NAME,
                <cfif isdefined("attributes.field_member_account_code")>
                    <cfif isdefined("x_add_multi_acc") and x_add_multi_acc eq 1 and isdefined("attributes.is_cari_action") and attributes.is_cari_action eq 1>
                        EA.ACCOUNT_CODE,
                    <cfelse>
                        (SELECT TOP 1 EIOP.ACCOUNT_CODE FROM EMPLOYEES_IN_OUT_PERIOD EIOP,EMPLOYEES_IN_OUT EIO WHERE EIOP.IN_OUT_ID = EIO.IN_OUT_ID AND EIO.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND (EIOP.ACCOUNT_CODE IS NOT NULL OR EIOP.ACCOUNT_CODE <> '') ORDER BY EIO.IN_OUT_ID DESC) AS ACCOUNT_CODE,			
                    </cfif>
                </cfif>
                OUR_COMPANY.HEADQUARTERS_ID
                <cfif isdefined("x_add_multi_acc") and x_add_multi_acc eq 1 and isdefined("attributes.is_cari_action") and attributes.is_cari_action eq 1>
                    ,EA.ACC_TYPE_ID
                    ,EIO.FINISH_DATE
                    ,(SELECT SAT.ACC_TYPE_NAME FROM SETUP_ACC_TYPE SAT WHERE SAT.ACC_TYPE_ID=EA.ACC_TYPE_ID) ACC_TYPE_NAME
                </cfif>
                <cfif not isDefined("attributes.show_empty_pos") OR isDefined("attributes.field_emp_no")>,EMPLOYEES.EMPLOYEE_NO</cfif>
            FROM
                EMPLOYEE_POSITIONS
                LEFT JOIN DEPARTMENT ON  EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID 
                <cfif isdefined("x_add_multi_acc") and x_add_multi_acc eq 1 and isdefined("attributes.is_cari_action") and attributes.is_cari_action eq 1>
                    LEFT JOIN EMPLOYEES_ACCOUNTS EA ON EA.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID AND EA.PERIOD_ID = #session.ep.period_id# 
                    LEFT JOIN EMPLOYEES_IN_OUT EIO ON EIO.IN_OUT_ID = EA.IN_OUT_ID AND  EIO.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID 
                </cfif>
                <cfif not isDefined("attributes.show_empty_pos") or isDefined('attributes.field_emp_no')>,EMPLOYEES</cfif>
                ,BRANCH
                ,OUR_COMPANY
                ,SETUP_POSITION_CAT
            WHERE
                EMPLOYEE_POSITIONS.POSITION_CAT_ID = SETUP_POSITION_CAT.POSITION_CAT_ID AND
                EMPLOYEE_POSITIONS.POSITION_STATUS=1 AND
                DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND 
                OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID
            <cfif "#attributes.field_name#" eq "add_visit.visit_emps"> <!---Detaylı ziyaretçi raporundan geliyorsa şubeye göre listele--->
                AND BRANCH.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# )	
            </cfif>
            <cfif not isdefined("attributes.is_deny_control") and isdefined("x_add_multi_acc") and x_add_multi_acc eq 1 and isdefined("attributes.is_cari_action") and attributes.is_cari_action eq 1 and (len(hr_type_list) or len(ehesap_type_list) or len(other_type_list))>
                AND #control_acc_type_list#
            </cfif>
            <cfif isdefined("xml_filtre_by_dept_id") and xml_filtre_by_dept_id eq 1 and isdefined("xml_department_id") and len(xml_department_id) and attributes.filtre_by_dept_id eq 1>
                <!--- modified : MA 20120718 xml den gelen dept idlere gore filtreleme yapilir --->
                AND EMPLOYEE_POSITIONS.DEPARTMENT_ID IN (#xml_department_id#)
            </cfif>
            <cfif isdefined("attributes.upper_pos_code")>
                AND (EMPLOYEE_POSITIONS.UPPER_POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upper_pos_code#"> 
                <cfif isdefined("attributes.is_position_assistant") and is_position_assistant eq 1>
                    OR EMPLOYEE_POSITIONS.POSITION_ID IN (SELECT POSITION_ID FROM POSITION_ASSISTANT_MODULES WHERE POSITION_ASSISTANT_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"><cfif isDefined('attributes.module_id')> AND POSITION_ASSISTANT_MODULES LIKE '%#attributes.module_id#%' </cfif>)
                </cfif>
                OR EMPLOYEE_POSITIONS.UPPER_POSITION_CODE2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upper_pos_code#"> OR EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
            </cfif>
            <cfif isdefined("attributes.control_pos")>
                AND EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
            </cfif>
            <cfif not isDefined("attributes.show_empty_pos")>
                AND EMPLOYEES.EMPLOYEE_STATUS = 1
                AND EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID 
            <cfelseif isDefined("attributes.show_empty_pos") and isDefined("attributes.from_add_rapid")>
                AND (EMPLOYEE_POSITIONS.POSITION_NAME = '' OR EMPLOYEE_POSITIONS.POSITION_NAME IS NULL OR EMPLOYEE_POSITIONS.EMPLOYEE_ID = '' OR ISNULL(EMPLOYEE_POSITIONS.EMPLOYEE_ID,0) = 0) AND (EMPLOYEE_POSITIONS.EMPLOYEE_NAME = '' OR EMPLOYEE_POSITIONS.EMPLOYEE_NAME IS NULL)
            </cfif>
            <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
                <cfif len(attributes.keyword) eq 1>
                    AND EMPLOYEE_POSITIONS.EMPLOYEE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
                <cfelse>
                    <cfif database_type is 'MSSQL'>
                        AND EMPLOYEE_POSITIONS.EMPLOYEE_NAME + ' ' + EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                    <cfelseif database_type is 'DB2'>
                        AND EMPLOYEE_POSITIONS.EMPLOYEE_NAME || ' ' || EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                    </cfif>
                </cfif>
            </cfif>
            <cfif isDefined("attributes.branch_id") and len(attributes.branch_id)>
                AND BRANCH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
            </cfif>
            <cfif isDefined("attributes.department_id") and len(attributes.department_id)>
                AND DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
            </cfif>
            <!--- session.ep.company_id' ye göre branchler getirilmek istenirse ---> 
            <cfif isDefined("attributes.our_cid")>
                AND BRANCH.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_cid#">
            </cfif>
            <!--- Yetkili olunan şubeler getirilmek istenirse  --->
            <cfif isdefined("attributes.branch_related") or isdefined("xml_branch_control") and xml_branch_control eq 1>
                AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
            </cfif>
            <cfif (isdefined("attributes.employee_list") and attributes.employee_list neq "") or isdefined("attributes.is_store_module")>
                AND EMPLOYEE_POSITIONS.EMPLOYEE_ID IN (
                    SELECT
                        EMPLOYEE_POSITIONS.EMPLOYEE_ID
                    FROM 
                        BRANCH,
                        EMPLOYEE_POSITIONS,
                        DEPARTMENT
                    WHERE
                        BRANCH.BRANCH_ID IN ( SELECT EMPLOYEE_POSITION_BRANCHES.BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> )
                        AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
                        DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
                )
            </cfif>
            <!--- süreç satır idsi yollanırsa sürecde yetkili olan dışında kimse görüntülenmez --->
            <cfif isdefined('attributes.process_row_id') and len(attributes.process_row_id) and (not isdefined('attributes.emp_process_row_id') or attributes.emp_process_row_id eq 1)>
                AND EMPLOYEE_POSITIONS.POSITION_CODE IN 
                (
                    SELECT PRO_POSITION_ID FROM PROCESS_TYPE_ROWS_POSID WHERE PROCESS_TYPE_ROWS_POSID.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_row_id#">
                    UNION
                    SELECT PROCESS_TYPE_ROWS_POSID.PRO_POSITION_ID FROM PROCESS_TYPE_ROWS_WORKGRUOP PROCESS_TYPE_ROWS_WORKGRUOP,PROCESS_TYPE_ROWS_POSID PROCESS_TYPE_ROWS_POSID WHERE PROCESS_TYPE_ROWS_WORKGRUOP.PROCESS_ROW_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_row_id#"> AND PROCESS_TYPE_ROWS_WORKGRUOP.MAINWORKGROUP_ID IS NOT NULL AND PROCESS_TYPE_ROWS_WORKGRUOP.MAINWORKGROUP_ID = PROCESS_TYPE_ROWS_POSID.WORKGROUP_ID
                )
            </cfif>
            <!--- Alt tree kategorisindeki yetkililer disinda kimse gorunmesin PRNet --->
            <cfif isdefined("attributes.tree_category_id") and len(attributes.tree_category_id) and (not isdefined("attributes.sub_tree_category_id") or attributes.sub_tree_category_id eq 1)>
                AND EMPLOYEE_POSITIONS.POSITION_CODE IN
                (
                    SELECT POSITION_CODE FROM G_SERVICE_APPCAT_SUB_STATUS_POST WHERE SERVICE_SUB_STATUS_ID IN (#listsort(listdeleteduplicates(attributes.tree_category_id),"numeric","ASC",",")#)
                UNION
                    SELECT POSITION_CODE_INFO FROM G_SERVICE_APPCAT_SUB_STATUS_INFO WHERE SERVICE_SUB_STATUS_ID IN (#listsort(listdeleteduplicates(attributes.tree_category_id),"numeric","ASC",",")#)
                UNION
                    SELECT
                        EP.POSITION_CODE POSITION_CODE
                    FROM
                        G_SERVICE_APPCAT_SUB_STATUS_POST G_POST,
                        EMPLOYEE_POSITIONS EP
                    WHERE
                        G_POST.POSITION_CAT_ID = EP.POSITION_CAT_ID AND
                        G_POST.SERVICE_SUB_STATUS_ID IN (#listsort(listdeleteduplicates(attributes.tree_category_id),"numeric","ASC",",")#)
                )
            </cfif>
            <cfif isdefined("attributes.filter_by_hierarchy") and len(attributes.filter_by_hierarchy)>
                AND SETUP_POSITION_CAT.HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.filter_by_hierarchy#">
            </cfif>  
            UNION ALL
            SELECT
                <cfif not isDefined("attributes.show_empty_pos")>EMPLOYEES.GROUP_STARTDATE,</cfif>
                EMPLOYEE_POSITIONS.EMPLOYEE_ID,
                EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
                EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
                EMPLOYEE_POSITIONS.EMPLOYEE_EMAIL,
                EMPLOYEE_POSITIONS.POSITION_CODE,
                EMPLOYEE_POSITIONS.POSITION_NAME,
                EMPLOYEE_POSITIONS.POSITION_ID,
                EMPLOYEE_POSITIONS.POSITION_CAT_ID,
                EMPLOYEE_POSITIONS.TITLE_ID,
                EMPLOYEE_POSITIONS.FUNC_ID,
                EMPLOYEE_POSITIONS.COLLAR_TYPE,
                EMPLOYEE_POSITIONS.ORGANIZATION_STEP_ID,
                SETUP_POSITION_CAT.POSITION_CAT,
                EMPLOYEE_POSITIONS.IS_MASTER,
                BRANCH.BRANCH_NAME,
                BRANCH.BRANCH_ID,
                DEPARTMENT.DEPARTMENT_HEAD,
                DEPARTMENT.DEPARTMENT_ID,
                OUR_COMPANY.COMP_ID,
                OUR_COMPANY.NICK_NAME,
                <cfif isdefined("attributes.field_member_account_code")>
                    <cfif isdefined("x_add_multi_acc") and x_add_multi_acc eq 1 and isdefined("attributes.is_cari_action") and attributes.is_cari_action eq 1>
                        EA.ACCOUNT_CODE,
                    <cfelse>
                        (SELECT TOP 1 EIOP.ACCOUNT_CODE FROM EMPLOYEES_IN_OUT_PERIOD EIOP,EMPLOYEES_IN_OUT EIO WHERE EIOP.IN_OUT_ID = EIO.IN_OUT_ID AND EIO.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND (EIOP.ACCOUNT_CODE IS NOT NULL OR EIOP.ACCOUNT_CODE <> '') ORDER BY EIO.IN_OUT_ID DESC) AS ACCOUNT_CODE,			
                    </cfif>
                </cfif>
                OUR_COMPANY.HEADQUARTERS_ID
                <cfif isdefined("x_add_multi_acc") and x_add_multi_acc eq 1 and isdefined("attributes.is_cari_action") and attributes.is_cari_action eq 1>
                    ,EA.ACC_TYPE_ID
                    ,EIO.FINISH_DATE
                    ,(SELECT SAT.ACC_TYPE_NAME FROM SETUP_ACC_TYPE SAT WHERE SAT.ACC_TYPE_ID=EA.ACC_TYPE_ID) ACC_TYPE_NAME
                </cfif>
                <cfif not isDefined("attributes.show_empty_pos") OR isDefined("attributes.field_emp_no")>,EMPLOYEES.EMPLOYEE_NO</cfif>
            FROM
                EMPLOYEE_POSITIONS
                <cfif isdefined("x_add_multi_acc") and x_add_multi_acc eq 1 and isdefined("attributes.is_cari_action") and attributes.is_cari_action eq 1>
                    LEFT JOIN EMPLOYEES_ACCOUNTS EA ON EA.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID AND EA.PERIOD_ID = #session.ep.period_id# 
                    LEFT JOIN EMPLOYEES_IN_OUT EIO ON EIO.IN_OUT_ID = EA.IN_OUT_ID
                </cfif>
                <cfif not isDefined("attributes.show_empty_pos") or isDefined('attributes.field_emp_no')>,EMPLOYEES</cfif>
                ,DEPARTMENT
                ,BRANCH
                ,OUR_COMPANY
                ,SETUP_POSITION_CAT
            WHERE
                EMPLOYEE_POSITIONS.POSITION_CAT_ID = SETUP_POSITION_CAT.POSITION_CAT_ID AND
                EMPLOYEE_POSITIONS.POSITION_STATUS=1 AND
                DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND 
                OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID AND
                EIO.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID 
            <cfif "#attributes.field_name#" eq "add_visit.visit_emps"> <!---Detaylı ziyaretçi raporundan geliyorsa şubeye göre listele--->
                AND BRANCH.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# )	
            </cfif>
            <cfif not isdefined("attributes.is_deny_control") and isdefined("x_add_multi_acc") and x_add_multi_acc eq 1 and isdefined("attributes.is_cari_action") and attributes.is_cari_action eq 1 and (len(hr_type_list) or len(ehesap_type_list) or len(other_type_list))>
                AND #control_acc_type_list#
            </cfif>
            <cfif isdefined("xml_filtre_by_dept_id") and xml_filtre_by_dept_id eq 1 and isdefined("xml_department_id") and len(xml_department_id) and attributes.filtre_by_dept_id eq 1>
                <!--- modified : MA 20120718 xml den gelen dept idlere gore filtreleme yapilir --->
                AND EIO.DEPARTMENT_ID IN (#xml_department_id#)
            </cfif>
            <cfif isdefined("attributes.upper_pos_code")>
                AND (EMPLOYEE_POSITIONS.UPPER_POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upper_pos_code#"> 
                <cfif isdefined("attributes.is_position_assistant") and is_position_assistant eq 1>
                    OR EMPLOYEE_POSITIONS.POSITION_ID IN (SELECT POSITION_ID FROM POSITION_ASSISTANT_MODULES WHERE POSITION_ASSISTANT_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"><cfif isDefined('attributes.module_id')> AND POSITION_ASSISTANT_MODULES LIKE '%#attributes.module_id#%' </cfif>)
                </cfif>
                OR EMPLOYEE_POSITIONS.UPPER_POSITION_CODE2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upper_pos_code#"> OR EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
            </cfif>
            <cfif isdefined("attributes.control_pos")>
                AND EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
            </cfif>
            <cfif not isDefined("attributes.show_empty_pos")>
                AND EMPLOYEES.EMPLOYEE_STATUS = 1
                AND EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID 
            </cfif>
            <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
                <cfif len(attributes.keyword) eq 1>
                    AND EMPLOYEE_POSITIONS.EMPLOYEE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
                <cfelse>
                    <cfif database_type is 'MSSQL'>
                        AND EMPLOYEE_POSITIONS.EMPLOYEE_NAME + ' ' + EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                    <cfelseif database_type is 'DB2'>
                        AND EMPLOYEE_POSITIONS.EMPLOYEE_NAME || ' ' || EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                    </cfif>
                </cfif>
            </cfif>
            <cfif isDefined("attributes.branch_id") and len(attributes.branch_id)>
                AND BRANCH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
            </cfif>
            <cfif isDefined("attributes.department_id") and len(attributes.department_id)>
                AND DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
            </cfif>
            <!--- session.ep.company_id' ye göre branchler getirilmek istenirse ---> 
            <cfif isDefined("attributes.our_cid")>
                AND BRANCH.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_cid#">
            </cfif>
            <!--- Yetkili olunan şubeler getirilmek istenirse  --->
            <cfif isdefined("attributes.branch_related") or isdefined("xml_branch_control") and xml_branch_control eq 1>
                AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
            </cfif>
            <cfif (isdefined("attributes.employee_list") and attributes.employee_list neq "") or isdefined("attributes.is_store_module")>
                AND EMPLOYEE_POSITIONS.EMPLOYEE_ID IN (
                    SELECT
                        EMPLOYEE_POSITIONS.EMPLOYEE_ID
                    FROM 
                        BRANCH,
                        EMPLOYEE_POSITIONS,
                        DEPARTMENT
                    WHERE
                        BRANCH.BRANCH_ID IN ( SELECT EMPLOYEE_POSITION_BRANCHES.BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> )
                        AND EIO.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
                        DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
                )
            </cfif>
            <!--- süreç satır idsi yollanırsa sürecde yetkili olan dışında kimse görüntülenmez --->
            <cfif isdefined('attributes.process_row_id') and len(attributes.process_row_id) and (not isdefined('attributes.emp_process_row_id') or attributes.emp_process_row_id eq 1)>
                AND EMPLOYEE_POSITIONS.POSITION_CODE IN 
                (
                    SELECT PRO_POSITION_ID FROM PROCESS_TYPE_ROWS_POSID WHERE PROCESS_TYPE_ROWS_POSID.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_row_id#">
                    UNION
                    SELECT PROCESS_TYPE_ROWS_POSID.PRO_POSITION_ID FROM PROCESS_TYPE_ROWS_WORKGRUOP PROCESS_TYPE_ROWS_WORKGRUOP,PROCESS_TYPE_ROWS_POSID PROCESS_TYPE_ROWS_POSID WHERE PROCESS_TYPE_ROWS_WORKGRUOP.PROCESS_ROW_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_row_id#"> AND PROCESS_TYPE_ROWS_WORKGRUOP.MAINWORKGROUP_ID IS NOT NULL AND PROCESS_TYPE_ROWS_WORKGRUOP.MAINWORKGROUP_ID = PROCESS_TYPE_ROWS_POSID.WORKGROUP_ID
                )
            </cfif>
            <!--- Alt tree kategorisindeki yetkililer disinda kimse gorunmesin PRNet --->
            <cfif isdefined("attributes.tree_category_id") and len(attributes.tree_category_id) and (not isdefined("attributes.sub_tree_category_id") or attributes.sub_tree_category_id eq 1)>
                AND EMPLOYEE_POSITIONS.POSITION_CODE IN
                (
                    SELECT POSITION_CODE FROM G_SERVICE_APPCAT_SUB_STATUS_POST WHERE SERVICE_SUB_STATUS_ID IN (#listsort(listdeleteduplicates(attributes.tree_category_id),"numeric","ASC",",")#)
                UNION
                    SELECT POSITION_CODE_INFO FROM G_SERVICE_APPCAT_SUB_STATUS_INFO WHERE SERVICE_SUB_STATUS_ID IN (#listsort(listdeleteduplicates(attributes.tree_category_id),"numeric","ASC",",")#)
                UNION
                    SELECT
                        EP.POSITION_CODE POSITION_CODE
                    FROM
                        G_SERVICE_APPCAT_SUB_STATUS_POST G_POST,
                        EMPLOYEE_POSITIONS EP
                    WHERE
                        G_POST.POSITION_CAT_ID = EP.POSITION_CAT_ID AND
                        G_POST.SERVICE_SUB_STATUS_ID IN (#listsort(listdeleteduplicates(attributes.tree_category_id),"numeric","ASC",",")#)
                )
            </cfif>
            <cfif isdefined("attributes.filter_by_hierarchy") and len(attributes.filter_by_hierarchy)>
                AND SETUP_POSITION_CAT.HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.filter_by_hierarchy#">
            </cfif>  
        <cfelse>
            SELECT
                <cfif not isDefined("attributes.show_empty_pos")>EMPLOYEES.GROUP_STARTDATE,</cfif>
                EMPLOYEE_POSITIONS.EMPLOYEE_ID,
                EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
                EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
                EMPLOYEE_POSITIONS.EMPLOYEE_EMAIL,
                EMPLOYEE_POSITIONS.POSITION_CODE,
                EMPLOYEE_POSITIONS.POSITION_NAME,
                EMPLOYEE_POSITIONS.POSITION_ID,
                EMPLOYEE_POSITIONS.POSITION_CAT_ID,
                EMPLOYEE_POSITIONS.TITLE_ID,
                EMPLOYEE_POSITIONS.FUNC_ID,
                EMPLOYEE_POSITIONS.COLLAR_TYPE,
                EMPLOYEE_POSITIONS.ORGANIZATION_STEP_ID,
                SETUP_POSITION_CAT.POSITION_CAT,
                EMPLOYEE_POSITIONS.IS_MASTER,
                BRANCH.BRANCH_NAME,
                BRANCH.BRANCH_ID,
                DEPARTMENT.DEPARTMENT_HEAD,
                DEPARTMENT.DEPARTMENT_ID,
                OUR_COMPANY.COMP_ID,
                OUR_COMPANY.NICK_NAME,
                <cfif isdefined("attributes.field_member_account_code")>
                    <cfif isdefined("x_add_multi_acc") and x_add_multi_acc eq 1 and isdefined("attributes.is_cari_action") and attributes.is_cari_action eq 1>
                        EA.ACCOUNT_CODE,
                    <cfelse>
                        (SELECT TOP 1 EIOP.ACCOUNT_CODE FROM EMPLOYEES_IN_OUT_PERIOD EIOP,EMPLOYEES_IN_OUT EIO WHERE EIOP.IN_OUT_ID = EIO.IN_OUT_ID AND EIO.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND (EIOP.ACCOUNT_CODE IS NOT NULL OR EIOP.ACCOUNT_CODE <> '') ORDER BY EIO.IN_OUT_ID DESC) AS ACCOUNT_CODE,			
                    </cfif>
                </cfif>
                OUR_COMPANY.HEADQUARTERS_ID
                <cfif isdefined("x_add_multi_acc") and x_add_multi_acc eq 1 and isdefined("attributes.is_cari_action") and attributes.is_cari_action eq 1>
                    ,EA.ACC_TYPE_ID
                    ,EIO.FINISH_DATE
                    ,(SELECT SAT.ACC_TYPE_NAME FROM SETUP_ACC_TYPE SAT WHERE SAT.ACC_TYPE_ID=EA.ACC_TYPE_ID) ACC_TYPE_NAME
                </cfif>
                <cfif not isDefined("attributes.show_empty_pos") OR isDefined("attributes.field_emp_no")>,EMPLOYEES.EMPLOYEE_NO</cfif>
            FROM
                EMPLOYEE_POSITIONS
                <cfif isdefined("x_add_multi_acc") and x_add_multi_acc eq 1 and isdefined("attributes.is_cari_action") and attributes.is_cari_action eq 1>
                    LEFT JOIN EMPLOYEES_ACCOUNTS EA ON EA.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID AND EA.PERIOD_ID = #session.ep.period_id# 
                    LEFT JOIN EMPLOYEES_IN_OUT EIO ON EIO.IN_OUT_ID = EA.IN_OUT_ID
                </cfif>
                <cfif not isDefined("attributes.show_empty_pos") or isDefined('attributes.field_emp_no')>,EMPLOYEES</cfif>
                ,DEPARTMENT
                ,BRANCH
                ,OUR_COMPANY
                ,SETUP_POSITION_CAT
            WHERE
                EMPLOYEE_POSITIONS.POSITION_CAT_ID = SETUP_POSITION_CAT.POSITION_CAT_ID AND
                EMPLOYEE_POSITIONS.POSITION_STATUS=1 AND
                DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND 
                OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID AND
                EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID 
            <cfif "#attributes.field_name#" eq "add_visit.visit_emps"> <!---Detaylı ziyaretçi raporundan geliyorsa şubeye göre listele--->
                AND BRANCH.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# )	
            </cfif>
            <cfif not isdefined("attributes.is_deny_control") and isdefined("x_add_multi_acc") and x_add_multi_acc eq 1 and isdefined("attributes.is_cari_action") and attributes.is_cari_action eq 1 and (len(hr_type_list) or len(ehesap_type_list) or len(other_type_list))>
                AND #control_acc_type_list#
            </cfif>
            <cfif isdefined("xml_filtre_by_dept_id") and xml_filtre_by_dept_id eq 1 and isdefined("xml_department_id") and len(xml_department_id) and attributes.filtre_by_dept_id eq 1>
                <!--- modified : MA 20120718 xml den gelen dept idlere gore filtreleme yapilir --->
                AND EMPLOYEE_POSITIONS.DEPARTMENT_ID IN (#xml_department_id#)
            </cfif>
            <cfif isdefined("attributes.upper_pos_code")>
                AND (EMPLOYEE_POSITIONS.UPPER_POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upper_pos_code#"> 
                <cfif isdefined("attributes.is_position_assistant") and is_position_assistant eq 1>
                    OR EMPLOYEE_POSITIONS.POSITION_ID IN (SELECT POSITION_ID FROM POSITION_ASSISTANT_MODULES WHERE POSITION_ASSISTANT_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"><cfif isDefined('attributes.module_id')> AND POSITION_ASSISTANT_MODULES LIKE '%#attributes.module_id#%' </cfif>)
                </cfif>
                OR EMPLOYEE_POSITIONS.UPPER_POSITION_CODE2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upper_pos_code#"> OR EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
            </cfif>
            <cfif isdefined("attributes.control_pos")>
                AND EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
            </cfif>
            <cfif not isDefined("attributes.show_empty_pos")>
                AND EMPLOYEES.EMPLOYEE_STATUS = 1
                AND EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID 
            <cfelseif isDefined("attributes.show_empty_pos") and isDefined("attributes.from_add_rapid")>
                AND (EMPLOYEE_POSITIONS.POSITION_NAME = '' OR EMPLOYEE_POSITIONS.POSITION_NAME IS NULL OR EMPLOYEE_POSITIONS.EMPLOYEE_ID = '' OR ISNULL(EMPLOYEE_POSITIONS.EMPLOYEE_ID,0) = 0) AND (EMPLOYEE_POSITIONS.EMPLOYEE_NAME = '' OR EMPLOYEE_POSITIONS.EMPLOYEE_NAME IS NULL)
            </cfif>
            <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
                <cfif len(attributes.keyword) eq 1>
                    AND EMPLOYEE_POSITIONS.EMPLOYEE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
                <cfelse>
                    <cfif database_type is 'MSSQL'>
                        AND EMPLOYEE_POSITIONS.EMPLOYEE_NAME + ' ' + EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                    <cfelseif database_type is 'DB2'>
                        AND EMPLOYEE_POSITIONS.EMPLOYEE_NAME || ' ' || EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                    </cfif>
                </cfif>
            </cfif>
            <cfif isDefined("attributes.branch_id") and len(attributes.branch_id)>
                AND BRANCH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
            </cfif>
            <cfif isDefined("attributes.department_id") and len(attributes.department_id)>
                AND DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
            </cfif>
            <!--- session.ep.company_id' ye göre branchler getirilmek istenirse ---> 
            <cfif isDefined("attributes.our_cid")>
                AND BRANCH.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_cid#">
            </cfif>
            <!--- Yetkili olunan şubeler getirilmek istenirse  --->
            <cfif isdefined("attributes.branch_related") or isdefined("xml_branch_control") and xml_branch_control eq 1>
                AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
            </cfif>
            <cfif (isdefined("attributes.employee_list") and attributes.employee_list neq "") or isdefined("attributes.is_store_module")>
                AND EMPLOYEE_POSITIONS.EMPLOYEE_ID IN (
                    SELECT
                        EMPLOYEE_POSITIONS.EMPLOYEE_ID
                    FROM 
                        BRANCH,
                        EMPLOYEE_POSITIONS,
                        DEPARTMENT
                    WHERE
                        BRANCH.BRANCH_ID IN ( SELECT EMPLOYEE_POSITION_BRANCHES.BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> )
                        AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
                        DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
                )
            </cfif>
            <!--- süreç satır idsi yollanırsa sürecde yetkili olan dışında kimse görüntülenmez --->
            <cfif isdefined('attributes.process_row_id') and len(attributes.process_row_id) and (not isdefined('attributes.emp_process_row_id') or attributes.emp_process_row_id eq 1)>
                AND EMPLOYEE_POSITIONS.POSITION_CODE IN 
                (
                    SELECT PRO_POSITION_ID FROM PROCESS_TYPE_ROWS_POSID WHERE PROCESS_TYPE_ROWS_POSID.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_row_id#">
                    UNION
                    SELECT PROCESS_TYPE_ROWS_POSID.PRO_POSITION_ID FROM PROCESS_TYPE_ROWS_WORKGRUOP PROCESS_TYPE_ROWS_WORKGRUOP,PROCESS_TYPE_ROWS_POSID PROCESS_TYPE_ROWS_POSID WHERE PROCESS_TYPE_ROWS_WORKGRUOP.PROCESS_ROW_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_row_id#"> AND PROCESS_TYPE_ROWS_WORKGRUOP.MAINWORKGROUP_ID IS NOT NULL AND PROCESS_TYPE_ROWS_WORKGRUOP.MAINWORKGROUP_ID = PROCESS_TYPE_ROWS_POSID.WORKGROUP_ID
                )
            </cfif>
            <!--- Alt tree kategorisindeki yetkililer disinda kimse gorunmesin PRNet --->
            <cfif isdefined("attributes.tree_category_id") and len(attributes.tree_category_id) and (not isdefined("attributes.sub_tree_category_id") or attributes.sub_tree_category_id eq 1)>
                AND EMPLOYEE_POSITIONS.POSITION_CODE IN
                (
                    SELECT POSITION_CODE FROM G_SERVICE_APPCAT_SUB_STATUS_POST WHERE SERVICE_SUB_STATUS_ID IN (#listsort(listdeleteduplicates(attributes.tree_category_id),"numeric","ASC",",")#)
                UNION
                    SELECT POSITION_CODE_INFO FROM G_SERVICE_APPCAT_SUB_STATUS_INFO WHERE SERVICE_SUB_STATUS_ID IN (#listsort(listdeleteduplicates(attributes.tree_category_id),"numeric","ASC",",")#)
                UNION
                    SELECT
                        EP.POSITION_CODE POSITION_CODE
                    FROM
                        G_SERVICE_APPCAT_SUB_STATUS_POST G_POST,
                        EMPLOYEE_POSITIONS EP
                    WHERE
                        G_POST.POSITION_CAT_ID = EP.POSITION_CAT_ID AND
                        G_POST.SERVICE_SUB_STATUS_ID IN (#listsort(listdeleteduplicates(attributes.tree_category_id),"numeric","ASC",",")#)
                )
            </cfif>
            <cfif isdefined("attributes.filter_by_hierarchy") and len(attributes.filter_by_hierarchy)>
                AND SETUP_POSITION_CAT.HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.filter_by_hierarchy#">
            </cfif>  
        </cfif>
        
		<cfif fusebox.fuseaction is "popup_list_all_positions">
		UNION ALL
			SELECT
				EMPLOYEES.GROUP_STARTDATE,
				EMPLOYEES.EMPLOYEE_ID,
				EMPLOYEES.EMPLOYEE_NAME,
				EMPLOYEES.EMPLOYEE_SURNAME,
				EMPLOYEES.EMPLOYEE_EMAIL,
				'' AS POSITION_CODE,
				'' AS POSITION_NAME,
				'' AS POSITION_ID,
				'' AS POSITION_CAT_ID,
				'' AS TITLE_ID,
				'' AS FUNC_ID,
				'' AS COLLAR_TYPE,
				'' AS ORGANIZATION_STEP_ID,
				'' AS POSITION_CAT,
				1 AS IS_MASTER,
				'' AS BRANCH_NAME,
				'' AS BRANCH_ID,
				'' AS DEPARTMENT_HEAD,
				'' AS DEPARTMENT_ID,
				'' AS COMP_ID,
				'' AS NICK_NAME,
				<cfif isdefined("attributes.field_member_account_code")>
					<cfif isdefined("x_add_multi_acc") and x_add_multi_acc eq 1 and isdefined("attributes.is_cari_action") and attributes.is_cari_action eq 1>
                        EA.ACCOUNT_CODE,
                    <cfelse>
                        (SELECT TOP 1 EIOP.ACCOUNT_CODE FROM EMPLOYEES_IN_OUT_PERIOD EIOP,EMPLOYEES_IN_OUT EIO WHERE EIOP.IN_OUT_ID = EIO.IN_OUT_ID AND EIO.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND (EIOP.ACCOUNT_CODE IS NOT NULL OR EIOP.ACCOUNT_CODE <> '') ORDER BY EIO.IN_OUT_ID DESC) AS ACCOUNT_CODE,			
                    </cfif>
                </cfif>
                '' as HEADQUARTERS_ID
                <cfif isdefined("x_add_multi_acc") and x_add_multi_acc eq 1 and isdefined("attributes.is_cari_action") and attributes.is_cari_action eq 1>
                    ,EA.ACC_TYPE_ID
                    ,EIO.FINISH_DATE
                    ,(SELECT SAT.ACC_TYPE_NAME FROM SETUP_ACC_TYPE SAT WHERE SAT.ACC_TYPE_ID=EA.ACC_TYPE_ID) ACC_TYPE_NAME
                </cfif>
                ,EMPLOYEES.EMPLOYEE_NO
			FROM
				EMPLOYEES
                <cfif isdefined("x_add_multi_acc") and x_add_multi_acc eq 1 and isdefined("attributes.is_cari_action") and attributes.is_cari_action eq 1>
                    LEFT JOIN EMPLOYEES_ACCOUNTS EA ON EA.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND EA.PERIOD_ID = #session.ep.period_id# 
	                LEFT JOIN EMPLOYEES_IN_OUT EIO ON EIO.IN_OUT_ID = EA.IN_OUT_ID
                </cfif>
			WHERE
				(EMPLOYEES.EMPLOYEE_ID NOT IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID IS NOT NULL AND POSITION_STATUS = 1) OR EMPLOYEES.EMPLOYEE_STATUS = 0)
				<cfif isdefined("attributes.control_pos")>
					AND EMPLOYEES.EMPLOYEE_ID = #session.ep.userid#
				</cfif>
				<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
					<cfif len(attributes.keyword) eq 1>
						AND EMPLOYEES.EMPLOYEE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
					<cfelse>
						<cfif database_type is 'MSSQL'>
						AND EMPLOYEES.EMPLOYEE_NAME + ' ' + EMPLOYEES.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
						<cfelseif database_type is 'DB2'>
						AND EMPLOYEES.EMPLOYEE_NAME || ' ' || EMPLOYEES.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
						</cfif>
					</cfif>
				</cfif>
		</cfif>
        <cfif isdefined('attributes.show_rel_pos') and attributes.show_rel_pos eq 1 and isdefined('get_control_val') and get_control_val.property_value eq 1>
        UNION ALL
        	SELECT
				<cfif not isDefined("attributes.show_empty_pos")>EMPLOYEES.GROUP_STARTDATE,</cfif>
                EMPLOYEE_POSITIONS.EMPLOYEE_ID,
                EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
                EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
                EMPLOYEE_POSITIONS.EMPLOYEE_EMAIL,
                EMPLOYEE_POSITIONS.POSITION_CODE,
                EMPLOYEE_POSITIONS.POSITION_NAME,
                EMPLOYEE_POSITIONS.POSITION_ID,
                EMPLOYEE_POSITIONS.POSITION_CAT_ID,
                EMPLOYEE_POSITIONS.TITLE_ID,
                EMPLOYEE_POSITIONS.FUNC_ID,
                EMPLOYEE_POSITIONS.COLLAR_TYPE,
                EMPLOYEE_POSITIONS.ORGANIZATION_STEP_ID,
                SETUP_POSITION_CAT.POSITION_CAT,
                EMPLOYEE_POSITIONS.IS_MASTER,
                BRANCH.BRANCH_NAME,
                BRANCH.BRANCH_ID,
                DEPARTMENT.DEPARTMENT_HEAD,
                DEPARTMENT.DEPARTMENT_ID,
                OUR_COMPANY.COMP_ID,
                OUR_COMPANY.NICK_NAME,
                <cfif isdefined("attributes.field_member_account_code")>
                    <cfif isdefined("x_add_multi_acc") and x_add_multi_acc eq 1 and isdefined("attributes.is_cari_action") and attributes.is_cari_action eq 1>
                        EA.ACCOUNT_CODE,
                    <cfelse>
                        (SELECT TOP 1 EIOP.ACCOUNT_CODE FROM EMPLOYEES_IN_OUT_PERIOD EIOP,EMPLOYEES_IN_OUT EIO WHERE EIOP.IN_OUT_ID = EIO.IN_OUT_ID AND EIO.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND (EIOP.ACCOUNT_CODE IS NOT NULL OR EIOP.ACCOUNT_CODE <> '') ORDER BY EIO.IN_OUT_ID DESC) AS ACCOUNT_CODE,			
                    </cfif>
                </cfif>
                OUR_COMPANY.HEADQUARTERS_ID
                <cfif isdefined("x_add_multi_acc") and x_add_multi_acc eq 1 and isdefined("attributes.is_cari_action") and attributes.is_cari_action eq 1>
                    ,EA.ACC_TYPE_ID
                    ,EIO.FINISH_DATE
                    ,(SELECT SAT.ACC_TYPE_NAME FROM SETUP_ACC_TYPE SAT WHERE SAT.ACC_TYPE_ID=EA.ACC_TYPE_ID) ACC_TYPE_NAME
                </cfif>
                ,EMPLOYEES.EMPLOYEE_NO
     		FROM
            	EMPLOYEE_POSITIONS
                INNER JOIN EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID
                INNER JOIN WORKGROUP_EMP_PAR ON WORKGROUP_EMP_PAR.MAIN_EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID
                LEFT JOIN SETUP_POSITION_CAT ON EMPLOYEE_POSITIONS.POSITION_CAT_ID = SETUP_POSITION_CAT.POSITION_CAT_ID
                LEFT JOIN DEPARTMENT ON EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
                LEFT JOIN BRANCH ON DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID 
                LEFT JOIN OUR_COMPANY ON OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID
                <cfif isdefined("x_add_multi_acc") and x_add_multi_acc eq 1 and isdefined("attributes.is_cari_action") and attributes.is_cari_action eq 1>
                    LEFT JOIN EMPLOYEES_ACCOUNTS EA ON EA.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND EA.PERIOD_ID = #session.ep.period_id# 
	                LEFT JOIN EMPLOYEES_IN_OUT EIO ON EIO.IN_OUT_ID = EA.IN_OUT_ID
                </cfif>
              WHERE
            	WORKGROUP_EMP_PAR.EMPLOYEE_ID = #session.ep.userid# AND
				WORKGROUP_EMP_PAR.MAIN_EMPLOYEE_ID IS NOT NULL AND
                EMPLOYEE_POSITIONS.POSITION_STATUS=1
                <cfif not isdefined("attributes.is_deny_control") and isdefined("x_add_multi_acc") and x_add_multi_acc eq 1 and isdefined("attributes.is_cari_action") and attributes.is_cari_action eq 1 and (len(hr_type_list) or len(ehesap_type_list) or len(other_type_list))>
                    AND #control_acc_type_list#
                </cfif>
                <cfif isdefined("attributes.upper_pos_code")>
                	AND ((EMPLOYEE_POSITIONS.UPPER_POSITION_CODE <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upper_pos_code#"> AND EMPLOYEE_POSITIONS.UPPER_POSITION_CODE IS NOT NULL) OR EMPLOYEE_POSITIONS.UPPER_POSITION_CODE IS NULL) 
                    <cfif isdefined("attributes.is_position_assistant") and is_position_assistant eq 1>
                        OR EMPLOYEE_POSITIONS.POSITION_ID IN (SELECT POSITION_ID FROM POSITION_ASSISTANT_MODULES WHERE POSITION_ASSISTANT_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"><cfif isDefined('attributes.module_id')> AND POSITION_ASSISTANT_MODULES LIKE '%#attributes.module_id#%' </cfif>)
                    </cfif>
                    AND ((EMPLOYEE_POSITIONS.UPPER_POSITION_CODE2 <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upper_pos_code#"> AND EMPLOYEE_POSITIONS.UPPER_POSITION_CODE2 IS NOT NULL) OR EMPLOYEE_POSITIONS.UPPER_POSITION_CODE2 IS NULL) AND 
					((EMPLOYEE_POSITIONS.POSITION_CODE <> <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND EMPLOYEE_POSITIONS.POSITION_CODE IS NOT NULL) OR EMPLOYEE_POSITIONS.POSITION_CODE IS NULL)
                </cfif>
                <cfif isdefined("attributes.control_pos")>
                    AND ((EMPLOYEE_POSITIONS.POSITION_CODE <> <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND EMPLOYEE_POSITIONS.POSITION_CODE IS NOT NULL) OR EMPLOYEE_POSITIONS.POSITION_CODE IS NULL)
                </cfif>
                <cfif isdefined("xml_filtre_by_dept_id") and xml_filtre_by_dept_id eq 1 and isdefined("xml_department_id") and len(xml_department_id) and attributes.filtre_by_dept_id eq 1>
                    AND EMPLOYEE_POSITIONS.DEPARTMENT_ID IN (#xml_department_id#)
                </cfif>
                <cfif not isDefined("attributes.show_empty_pos")>
                    AND EMPLOYEES.EMPLOYEE_STATUS = 1
                    AND EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID 
                <cfelseif isDefined("attributes.show_empty_pos") and isDefined("attributes.from_add_rapid")>
                    AND (EMPLOYEE_POSITIONS.POSITION_NAME = '' OR EMPLOYEE_POSITIONS.POSITION_NAME IS NULL OR EMPLOYEE_POSITIONS.EMPLOYEE_ID = '' OR ISNULL(EMPLOYEE_POSITIONS.EMPLOYEE_ID,0) = 0) AND (EMPLOYEE_POSITIONS.EMPLOYEE_NAME = '' OR EMPLOYEE_POSITIONS.EMPLOYEE_NAME IS NULL)
                </cfif>
                <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
					<cfif len(attributes.keyword) eq 1>
                        AND EMPLOYEE_POSITIONS.EMPLOYEE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
                    <cfelse>
                        <cfif database_type is 'MSSQL'>
                            AND EMPLOYEE_POSITIONS.EMPLOYEE_NAME + ' ' + EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                        <cfelseif database_type is 'DB2'>
                            AND EMPLOYEE_POSITIONS.EMPLOYEE_NAME || ' ' || EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                        </cfif>
                    </cfif>
                </cfif>
                <cfif isDefined("attributes.branch_id") and len(attributes.branch_id)>
                    AND BRANCH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
                </cfif>
                <cfif isDefined("attributes.department_id") and len(attributes.department_id)>
                    AND DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
                </cfif>
                <cfif isDefined("attributes.our_cid")>
                    AND BRANCH.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_cid#">
                </cfif>
                <cfif isdefined("attributes.branch_related") or isdefined("xml_branch_control") and xml_branch_control eq 1>
                    AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
                </cfif>
                <cfif (isdefined("attributes.employee_list") and attributes.employee_list neq "") or isdefined("attributes.is_store_module")>
                    AND EMPLOYEE_POSITIONS.EMPLOYEE_ID IN (
                        SELECT
                            EMPLOYEE_POSITIONS.EMPLOYEE_ID
                        FROM 
                            BRANCH,
                            EMPLOYEE_POSITIONS,
                            DEPARTMENT
                        WHERE
                            BRANCH.BRANCH_ID IN ( SELECT EMPLOYEE_POSITION_BRANCHES.BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> )
                            AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
                            DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
                    )
                </cfif>
                <!--- süreç satır idsi yollanırsa sürecde yetkili olan dışında kimse görüntülenmez --->
				<cfif isdefined('attributes.process_row_id') and len(attributes.process_row_id) and (not isdefined('attributes.emp_process_row_id') or attributes.emp_process_row_id eq 1)>
                    AND EMPLOYEE_POSITIONS.POSITION_CODE IN 
                    (
                        SELECT PRO_POSITION_ID FROM PROCESS_TYPE_ROWS_POSID WHERE PROCESS_TYPE_ROWS_POSID.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_row_id#">
                        UNION
                        SELECT PROCESS_TYPE_ROWS_POSID.PRO_POSITION_ID FROM PROCESS_TYPE_ROWS_WORKGRUOP PROCESS_TYPE_ROWS_WORKGRUOP,PROCESS_TYPE_ROWS_POSID PROCESS_TYPE_ROWS_POSID WHERE PROCESS_TYPE_ROWS_WORKGRUOP.PROCESS_ROW_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_row_id#"> AND PROCESS_TYPE_ROWS_WORKGRUOP.MAINWORKGROUP_ID IS NOT NULL AND PROCESS_TYPE_ROWS_WORKGRUOP.MAINWORKGROUP_ID = PROCESS_TYPE_ROWS_POSID.WORKGROUP_ID
                    )
                </cfif>
                <!--- Alt tree kategorisindeki yetkililer disinda kimse gorunmesin PRNet --->
                <cfif isdefined("attributes.tree_category_id") and len(attributes.tree_category_id) and (not isdefined("attributes.sub_tree_category_id") or attributes.sub_tree_category_id eq 1)>
                    AND EMPLOYEE_POSITIONS.POSITION_CODE IN
                    (
                        SELECT POSITION_CODE FROM G_SERVICE_APPCAT_SUB_STATUS_POST WHERE SERVICE_SUB_STATUS_ID IN (#listsort(listdeleteduplicates(attributes.tree_category_id),"numeric","ASC",",")#)
                    UNION
                        SELECT POSITION_CODE_INFO FROM G_SERVICE_APPCAT_SUB_STATUS_INFO WHERE SERVICE_SUB_STATUS_ID IN (#listsort(listdeleteduplicates(attributes.tree_category_id),"numeric","ASC",",")#)
                    UNION
                        SELECT
                            EP.POSITION_CODE POSITION_CODE
                        FROM
                            G_SERVICE_APPCAT_SUB_STATUS_POST G_POST,
                            EMPLOYEE_POSITIONS EP
                        WHERE
                            G_POST.POSITION_CAT_ID = EP.POSITION_CAT_ID AND
                            G_POST.SERVICE_SUB_STATUS_ID IN (#listsort(listdeleteduplicates(attributes.tree_category_id),"numeric","ASC",",")#)
                    )
                </cfif>
            <cfif isdefined("attributes.filter_by_hierarchy") and len(attributes.filter_by_hierarchy)>
                AND SETUP_POSITION_CAT.HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.filter_by_hierarchy#">
            </cfif>  
        </cfif>
	) T1
	ORDER BY
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME
</cfquery>

