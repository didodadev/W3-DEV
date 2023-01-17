<cf_get_lang_set module_name='#fusebox.circuit#'>
<cfif not isdefined("attributes.event") or (isdefined("attributes.event") and attributes.event is 'list')>
    <cfparam name="attributes.position_cat_id" default=''>
    <cfparam name="attributes.emp_status" default=1>
    <cfparam name="attributes.eval_date" default="">
    <cfparam name="attributes.period_year" default="#session.ep.period_year#">
    <cfparam name="attributes.department" default="">
    <cfparam name="attributes.branch_id" default="">
    <cfparam name="attributes.title_id" default="">
    <cfparam name="attributes.hierarchy" default="">
    <cfparam name="attributes.is_form_submit" default="0">
    <cfparam name="attributes.keyword" default="">
    <cfif len(attributes.eval_date)>
        <cf_date tarih = "attributes.eval_date">
    </cfif>
    <cfscript>
        if (not len(attributes.period_year) and attributes.is_form_submit)
            attributes.period_year = session.ep.period_year;
        url_str = "";
        if (attributes.is_form_submit)
        {
            url_str = '#url_str#&is_form_submit=#attributes.is_form_submit#';
            if (len(attributes.keyword))
                url_str = "#url_str#&keyword=#attributes.keyword#";
            if (isdefined('attributes.department') and len(attributes.department))
                url_str = "#url_str#&department=#attributes.department#";
            if (isdefined('attributes.branch_id') and len(attributes.branch_id))
                url_str="#url_str#&branch_id=#attributes.branch_id#";
            if (isdefined("attributes.position_cat_id"))
                url_str = "#url_str#&position_cat_id=#attributes.position_cat_id#";
            if (isdefined("attributes.title_id"))
                url_str = "#url_str#&title_id=#attributes.title_id#";
            if (len(attributes.eval_date) gt 9)
                url_str = "#url_str#&eval_date=#dateformat(attributes.eval_date,'dd/mm/yyyy')#";
            if (isdefined("attributes.period_year"))
                url_str = "#url_str#&period_year=#attributes.period_year#";
            if (isdefined("attributes.attenders"))
                url_str = "#url_str#&attenders=#attributes.attenders#";
            if (isdefined('emp_status'))
                url_str = '#url_str#&emp_status=#attributes.emp_status#';
        }
        cmp_branch = createObject("component","hr.cfc.get_branches");
        cmp_branch.dsn = dsn;
        get_branch = cmp_branch.get_branch();
        cmp_department = createObject("component","hr.cfc.get_departments");
        cmp_department.dsn = dsn;
        get_department = cmp_department.get_department(branch_id : '#iif(len(attributes.branch_id),"attributes.branch_id",DE(""))#');
        cmp_title = createObject("component","hr.cfc.get_titles");
        cmp_title.dsn = dsn;
        get_title = cmp_title.get_title();
    </cfscript>
    <cfinclude template="../hr/query/get_position_cats.cfm">
    <cfif attributes.is_form_submit>
        <cfquery name="get_emp_pos" datasource="#dsn#">
            SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
        </cfquery>
        <cfset position_list=valuelist(get_emp_pos.position_code,',')>
        <cfinclude template="../hr/query/get_emp_codes.cfm">
        <cfquery name="GET_PERF_RESULTS" datasource="#dsn#"><!---  cachedwithin="#fusebox.general_cached_time#" --->
            SELECT 
            DISTINCT
                EPERF.PER_ID,
                EPERF.START_DATE,
                EPERF.FINISH_DATE,
                EPERF.EVAL_DATE,
                EPERF.RECORD_DATE,
                EPERF.RECORD_TYPE,
                EPERF.POSITION_CODE,
                EPERF.IS_CLOSED,
                EP.POSITION_NAME,<!--- Eskiye Döneülmek İstenirse EPRF.EMP_POSITION_NAMENIN QUERYDE GELMESİ VE LİSTEYE EKLENMESİ GEREK --->
                EPT.FIRST_BOSS_CODE,
                E.EMPLOYEE_ID,		
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME,
                ST.TITLE
            FROM 
                EMPLOYEE_PERFORMANCE EPERF 
                INNER JOIN EMPLOYEES E ON EPERF.EMP_ID = E.EMPLOYEE_ID
                LEFT JOIN EMPLOYEE_PERFORMANCE_TARGET EPT ON EPERF.PER_ID=EPT.PER_ID
                LEFT JOIN EMPLOYEE_QUIZ_RESULTS EQR ON EPERF.RESULT_ID = EQR.RESULT_ID
                LEFT JOIN EMPLOYEE_POSITIONS EP ON EPERF.EMP_ID = EP.EMPLOYEE_ID AND EP.POSITION_CODE = EPERF.POSITION_CODE
                LEFT JOIN SETUP_TITLE ST ON ST.TITLE_ID = EP.TITLE_ID
                LEFT JOIN EMPLOYEE_POSITIONS_STANDBY EPS ON EP.POSITION_CODE = EPS.POSITION_CODE
                LEFT JOIN EMPLOYEE_PERFORMANCE_DEFINITION EPD ON EPD.YEAR = YEAR(EPERF.START_DATE) AND EPD.IS_ACTIVE = 1
                    AND (EPD.TITLE_ID LIKE '%,'+CONVERT(varchar,EP.TITLE_ID) OR EPD.TITLE_ID LIKE +CONVERT(varchar,EP.TITLE_ID)+',%' OR EPD.TITLE_ID LIKE '%,'+CONVERT(varchar,EP.TITLE_ID)+',%' OR EPD.TITLE_ID LIKE CONVERT(varchar,EP.TITLE_ID))
            WHERE
                1 = 1 
                <cfif not session.ep.ehesap>
                AND( 
                    (EPD.IS_STAGE <> 1 AND (
                        EPT.FIRST_BOSS_CODE IN (#position_list#) OR
                        EPT.SECOND_BOSS_CODE IN (#position_list#) OR
                        EPERF.EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">)
                    )
                    OR
                    (EPD.IS_STAGE = 1 AND 
                        (
                            EPD.IS_EMPLOYEE = 1 
                            AND EPERF.VALID_1 IS NULL 
                            AND EPERF.EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                        )
                        OR  EPS.CHIEF3_CODE IN (#position_list#)
                        OR
                        (
                            EPD.IS_UPPER_POSITION = 1 AND
                            EPERF.VALID_3 IS NULL AND 
                            (
                                ((EPD.IS_EMPLOYEE = 1 AND EPERF.VALID_1 = 1) 
                                OR 
                                (EPD.IS_EMPLOYEE = 0 OR EPD.IS_EMPLOYEE IS NULL))
                                AND
                                ((EPD.IS_CONSULTANT = 1 AND EPERF.VALID_2 = 1) 
                                OR 
                                (EPD.IS_CONSULTANT = 0 OR EPD.IS_CONSULTANT IS NULL))
                            )
                            AND EPT.FIRST_BOSS_CODE IN (#position_list#)
                        )
                        OR
                        (
                            EPD.IS_MUTUAL_ASSESSMENT = 1 AND
                            EPERF.VALID_4 IS NULL AND 
                            (
                                ((EPD.IS_EMPLOYEE = 1 AND EPERF.VALID_1 = 1) 
                                OR 
                                (EPD.IS_EMPLOYEE = 0 OR EPD.IS_EMPLOYEE IS NULL))
                                AND
                                ((EPD.IS_CONSULTANT = 1 AND EPERF.VALID_2 = 1) 
                                OR 
                                (EPD.IS_CONSULTANT = 0 OR EPD.IS_CONSULTANT IS NULL))
                                AND
                                ((EPD.IS_UPPER_POSITION = 1 AND EPERF.VALID_3 = 1) 
                                OR 
                                (EPD.IS_UPPER_POSITION = 0 OR EPD.IS_UPPER_POSITION IS NULL))
                            )
                            AND EPT.FIRST_BOSS_CODE IN (#position_list#)
                        )
                        OR EPT.SECOND_BOSS_CODE IN (#position_list#)
                    )
                )
                </cfif>
                <cfif len(attributes.eval_date)>
                    AND EPERF.EVAL_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.eval_date#">
                <cfelseif not len(attributes.eval_date) and len(attributes.period_year)>
                    AND YEAR(EPERF.START_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_year#">
                <cfelseif len(attributes.eval_date) and len(attributes.period_year)>
                    AND EPERF.EVAL_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.eval_date#">
                <cfelseif not len(attributes.eval_date) and not len(attributes.period_year)>
                    AND YEAR(EPERF.START_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year#">
                </cfif>
                <cfif isdefined("attributes.title_id") and len(attributes.title_id)>
                    AND ST.TITLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.title_id#">
                </cfif>
                <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
                    AND
                    (
                        E.EMPLOYEE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                        E.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                        E.EMPLOYEE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">
                    )
                </cfif>
            <cfif fusebox.dynamic_hierarchy>
                <cfloop list="#emp_code_list#" delimiters="+" index="code_i">
                    <cfif database_type is "MSSQL">
                        AND ('.' + E.DYNAMIC_HIERARCHY + '.' + E.DYNAMIC_HIERARCHY_ADD + '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
                    <cfelseif database_type is "DB2">
                        AND ('.' || E.DYNAMIC_HIERARCHY || '.' || E.DYNAMIC_HIERARCHY_ADD || '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
                    </cfif>
                </cfloop>
            <cfelse>
                <cfloop list="#emp_code_list#" delimiters="+" index="code_i">
                    <cfif database_type is "MSSQL">
                        AND ('.' + E.HIERARCHY + '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
                    <cfelseif database_type is "DB2">
                        AND ('.' || E.HIERARCHY || '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
                    </cfif>
                </cfloop>
            </cfif>
                AND EPERF.POSITION_CODE IN 
                    (SELECT
                        EPOS.POSITION_CODE
                    FROM 
                        EMPLOYEE_POSITIONS EPOS,
                        DEPARTMENT,
                        BRANCH
                    WHERE
                        DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
                        EPOS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
                        EPOS.EMPLOYEE_ID > 0
                        <cfif isdefined('attributes.department') and len(attributes.department)>
                            AND DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#">
                        </cfif> 
                        <cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
                            AND BRANCH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
                        </cfif> 
                        <cfif IsDefined("attributes.position_cat_id") and len(attributes.position_cat_id)>AND EPOS.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#"></cfif>
                    )
                ORDER BY 
                    E.EMPLOYEE_NAME,
                    E.EMPLOYEE_SURNAME,
                    EPERF.EVAL_DATE DESC,
                    EPERF.RECORD_DATE DESC
        </cfquery>
    <cfelse>
        <cfset get_perf_results.recordcount = 0>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfparam name="attributes.totalrecords" default='#get_perf_results.recordcount#'>
    
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cfif isdefined("attributes.module_control")>
        <cfset attributes.per_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.per_id,accountKey:'wrk') />
        <cf_get_lang_set module_name='hr'>
    </cfif>
    <cfquery name="GET_PERF" datasource="#dsn#">
        SELECT
            EPT.REQ_TYPE_LIST,
            EPT.EMP_VALID_FORM,
            EPT.EMP_VALID_DATE_FORM,	
            EPT.DEP_MANAGER_REQ_TYPE,
            EPT.COACH_REQ_TYPE,
            EPT.STD_REQ_TYPE,
            EPT.FIRST_BOSS_ID,
            EPT.FIRST_BOSS_CODE,
            EPT.SECOND_BOSS_ID,
            EPT.SECOND_BOSS_CODE,
            EPT.UPDATE_DATE AS EPT_UPD,
            EP.MANAGER_1_COMMENT,
            EP.EMPLOYEE_COMMENT,
            EP.MANAGER_2_COMMENT,
            EP.CONSULTANT_COMMENT,
            EP.EMP_ID,
            EP.FINISH_DATE,
            EP.START_DATE,
            EP.POSITION_CODE,
            EP.RESULT_ID,
            EP.IS_CLOSED,
            EP.TARGET_SCORE,
            EP.REQ_TYPE_SCORE,
            EP.EMP_TARGET_RESULT,
            EP.EMP_REQ_TYPE_RESULT,
            EP.EMP_PERF_RESULT,
            EP.EMP_PERF_RESULT2,
            EP.COMP_PERF_RESULT,
            EP.PERF_RESULT,
            EP.POWERFUL_ASPECTS,
            EP.TRAIN_NEED_ASPECTS,
            EP.RECORD_KEY,
            EP.RECORD_DATE,
            EP.UPDATE_KEY,
            EP.UPDATE_DATE,
            EP.COMP_ID,
            EP.BRANCH_ID,
            EP.DEPARTMENT_ID,
            EP.POSITION_CAT_ID,
            EP.TITLE_ID,
            EP.FUNC_ID,
            EP.STAGE,
            EP.VALID,
            EP.VALID_1,
            EP.VALID_2,
            EP.VALID_3,
            EP.VALID_4,
            EP.VALID_5,
            D.DEPARTMENT_HEAD,
            SPC.POSITION_CAT,
            OC.COMPANY_NAME,
            B.BRANCH_NAME,
            ST.TITLE
        FROM 
            EMPLOYEE_PERFORMANCE_TARGET EPT,
            EMPLOYEE_PERFORMANCE EP 
            LEFT JOIN DEPARTMENT D ON EP.DEPARTMENT_ID = D.DEPARTMENT_ID
            LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID
            LEFT JOIN OUR_COMPANY OC ON OC.COMP_ID = EP.COMP_ID
            LEFT JOIN BRANCH B ON B.BRANCH_ID = EP.BRANCH_ID
            LEFT JOIN SETUP_TITLE ST ON ST.TITLE_ID = EP.TITLE_ID
        WHERE 
            EPT.PER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.per_id#">
            AND EP.PER_ID=EPT.PER_ID
    </cfquery>
    <cfif not GET_PERF.RECORDCOUNT>
        <script type="text/javascript">
            alert('Görüntülemek İstediğiniz form yok!');
            history.back();
        </script>
        <cfabort>
    </cfif>
    <cfquery name="GET_TARGET" datasource="#dsn#">
        SELECT 
            TARGET_RESULT,
            PER_ID,
            TARGET_ID,
            TARGET_HEAD,
            TARGET_WEIGHT,
            PERFORM_COMMENT,
            EMP_TARGET_RESULT,
            UPPER_POSITION_TARGET_RESULT,
            UPPER_POSITION2_TARGET_RESULT
        FROM 
            TARGET
        WHERE 
            EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_perf.emp_id#"> AND
            YEAR(FINISHDATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(dateformat(get_perf.finish_date,'dd/mm/yyyy'))#"> AND
            YEAR(STARTDATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(dateformat(GET_PERF.start_date,'dd/mm/yyyy'))#">
    </cfquery>
    <cfquery name="get_caution" datasource="#dsn#">
        SELECT
            EC.DECISION_NO,
            EC.CAUTION_HEAD,
            EC.CAUTION_DATE,
            EC.RECORD_DATE,
            SCT.CAUTION_TYPE,
            E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS 'CAUTION_TO',
            E2.EMPLOYEE_NAME + ' ' + E2.EMPLOYEE_SURNAME AS 'WARNER'
        FROM
            EMPLOYEES_CAUTION EC
            LEFT JOIN SETUP_CAUTION_TYPE SCT ON SCT.CAUTION_TYPE_ID = EC.CAUTION_TYPE_ID
            LEFT JOIN EMPLOYEES E ON EC.CAUTION_TO = E.EMPLOYEE_ID
            LEFT JOIN EMPLOYEES E2 ON EC.WARNER = E2.EMPLOYEE_ID
        WHERE
            EC.CAUTION_TO = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_perf.emp_id#">
        ORDER BY
            EC.CAUTION_DATE
    </cfquery>
    <cfquery name="get_prize" datasource="#dsn#">
        SELECT
            EP.PRIZE_HEAD,
            EP.PRIZE_DATE,
            EP.RECORD_DATE,
            SPT.PRIZE_TYPE,
            E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS 'PRIZE_TO',
            E2.EMPLOYEE_NAME + ' ' + E2.EMPLOYEE_SURNAME AS 'PRIZE_GIVE_PERSON'
        FROM
            EMPLOYEES_PRIZE EP
            LEFT JOIN SETUP_PRIZE_TYPE SPT ON SPT.PRIZE_TYPE_ID = EP.PRIZE_TYPE_ID
            LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EP.PRIZE_TO
            LEFT JOIN EMPLOYEES E2 ON E2.EMPLOYEE_ID = EP.PRIZE_GIVE_PERSON
        WHERE
            EP.PRIZE_TO = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_perf.emp_id#">
        ORDER BY
            EP.PRIZE_DATE
    </cfquery>
    <cfinclude template="../hr/query/get_moneys.cfm">
    <cfquery name="GET_EMP" datasource="#dsn#">
        SELECT
            EP.EMPLOYEE_ID,
            EP.POSITION_CODE,
            EP.POSITION_NAME,
            EP.POSITION_CAT_ID,
            EP.ORGANIZATION_STEP_ID,
            EIO.DEPARTMENT_ID,
            EIO.START_DATE,
            EPS.CHIEF3_CODE
            <cfif not len(GET_PERF.UPDATE_DATE)>
                ,D.DEPARTMENT_HEAD,
                B.BRANCH_NAME,
                B.BRANCH_ID,
                OC.COMPANY_NAME,
                OC.COMP_ID,
                SPC.POSITION_CAT,
                ST.TITLE,
                EP.TITLE_ID,
                EP.FUNC_ID,
                EP.UPPER_POSITION_CODE,
                EP.UPPER_POSITION_CODE2
            </cfif>
        FROM
            EMPLOYEES_IN_OUT EIO INNER JOIN EMPLOYEES E ON EIO.EMPLOYEE_ID = E.EMPLOYEE_ID
            LEFT JOIN EMPLOYEE_POSITIONS EP ON EIO.EMPLOYEE_ID = EP.EMPLOYEE_ID
            LEFT JOIN EMPLOYEE_POSITIONS_STANDBY EPS ON EP.POSITION_CODE = EPS.POSITION_CODE
            <cfif not len(GET_PERF.UPDATE_DATE)>
                LEFT JOIN DEPARTMENT D ON EP.DEPARTMENT_ID = D.DEPARTMENT_ID 
                LEFT JOIN BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
                LEFT JOIN OUR_COMPANY OC ON OC.COMP_ID=B.COMPANY_ID
                LEFT JOIN SETUP_TITLE ST ON ST.TITLE_ID = EP.TITLE_ID
                LEFT JOIN SETUP_POSITION_CAT SPC ON EP.POSITION_CAT_ID = SPC.POSITION_CAT_ID
            </cfif>
        WHERE 
            EP.POSITION_CODE= <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PERF.POSITION_CODE#">
            AND EP.IS_MASTER = 1
    </cfquery>
    <cfif not len(GET_PERF.UPDATE_DATE)>
        <cfif not len(GET_PERF.EPT_UPD)>
            <cfquery name="update_boss" datasource="#dsn#">
                UPDATE 
                    EMPLOYEE_PERFORMANCE_TARGET 
                SET
                <cfif len(get_emp.upper_position_code)>
                    FIRST_BOSS_CODE=<cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp.upper_position_code#">,
                <cfelse>
                    FIRST_BOSS_CODE=NULL,
                </cfif>
                <cfif len(get_emp.upper_position_code2)>
                    SECOND_BOSS_CODE=<cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp.upper_position_code2#">,
                <cfelse>
                    SECOND_BOSS_CODE=NULL,
                </cfif>
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                WHERE
                    PER_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.per_id#">
            </cfquery>
            <cfset first_boss=GET_EMP.UPPER_POSITION_CODE>
            <cfset second_boss=GET_EMP.UPPER_POSITION_CODE2>
        <cfelse>
            <cfset first_boss=GET_PERF.FIRST_BOSS_CODE>
            <cfset second_boss=GET_PERF.SECOND_BOSS_CODE>
        </cfif>
        <cfset EMP_DEP_ID=GET_EMP.DEPARTMENT_ID>
        <cfset pos_cat=GET_EMP.POSITION_CAT_ID>
        <cfset emp_comp_id=GET_EMP.COMP_ID>
        <cfset emp_branch_id=GET_EMP.BRANCH_ID>
        <cfset emp_title_id=GET_EMP.TITLE_ID>
        <cfset emp_func_id=GET_EMP.FUNC_ID>
    <cfelse>
        <cfset EMP_DEP_ID=GET_PERF.DEPARTMENT_ID>
        <cfset pos_cat=GET_PERF.POSITION_CAT_ID>
        <cfset emp_comp_id=GET_PERF.COMP_ID>
        <cfset emp_branch_id=GET_PERF.BRANCH_ID>
        <cfset emp_title_id=GET_PERF.TITLE_ID>
        <cfset emp_func_id=GET_PERF.FUNC_ID>
        <cfset first_boss=GET_PERF.FIRST_BOSS_CODE>
        <cfset second_boss=GET_PERF.SECOND_BOSS_CODE>
    </cfif>
    <cfset emp_org_step_id=GET_EMP.ORGANIZATION_STEP_ID>
    <!---eğer form kaydedildi ise yetkinlik idler tabolodan alınıyor değilse querylerle--->
    <cfif listlen(GET_PERF.REQ_TYPE_LIST,',')>
        <cfset yetkinlik_list_all=GET_PERF.REQ_TYPE_LIST&','&GET_PERF.DEP_MANAGER_REQ_TYPE&','&GET_PERF.COACH_REQ_TYPE&','&GET_PERF.STD_REQ_TYPE>
        <cfset yetkinlik_list=GET_PERF.REQ_TYPE_LIST>
        <cfset kocluk_yetkinlik_list=GET_PERF.COACH_REQ_TYPE>
        <cfset dep_yetkinlik_list=GET_PERF.DEP_MANAGER_REQ_TYPE>
        <cfset std_yetkinlik_list=GET_PERF.STD_REQ_TYPE>
    <cfelse>
        <cfquery name="GET_EMP_REQ" datasource="#dsn#">
            SELECT 
                T1.REQ_TYPE_ID,
                T1.REQ_TYPE,
                T1.IS_GROUP
            FROM (
                SELECT 
                    REQ_TYPE_ID,
                    REQ_TYPE,
                    IS_GROUP,
                    IS_ACTIVE,
                    ISNULL((SELECT TOP 1 RELATION_FIELD_ID FROM RELATION_SEGMENT WHERE RELATION_ACTION = 1 AND RELATION_FIELD_ID = POSITION_REQ_TYPE.REQ_TYPE_ID),0) AS IS_COMPANY,
                    (SELECT DISTINCT RELATION_ACTION_ID FROM RELATION_SEGMENT WHERE RELATION_ACTION = 1 AND RELATION_FIELD_ID = POSITION_REQ_TYPE.REQ_TYPE_ID AND RELATION_ACTION_ID = <cfif len(emp_comp_id)>#emp_comp_id#<cfelse>NULL</cfif>) AS COMPANY_ID,
                    ISNULL((SELECT TOP 1 RELATION_FIELD_ID FROM RELATION_SEGMENT WHERE RELATION_ACTION = 2 AND RELATION_FIELD_ID = POSITION_REQ_TYPE.REQ_TYPE_ID),0) AS IS_DEPARTMENT,
                    (SELECT DISTINCT RELATION_ACTION_ID FROM RELATION_SEGMENT WHERE RELATION_ACTION = 2 AND RELATION_FIELD_ID = POSITION_REQ_TYPE.REQ_TYPE_ID AND RELATION_ACTION_ID = <cfif len(EMP_DEP_ID)>#EMP_DEP_ID#<cfelse>NULL</cfif>) AS DEPARTMENT_ID,
                    ISNULL((SELECT TOP 1 RELATION_FIELD_ID FROM RELATION_SEGMENT WHERE RELATION_ACTION = 3 AND RELATION_FIELD_ID = POSITION_REQ_TYPE.REQ_TYPE_ID),0) AS IS_POS_CAT,
                    (SELECT DISTINCT RELATION_ACTION_ID FROM RELATION_SEGMENT WHERE RELATION_ACTION = 3 AND RELATION_FIELD_ID = POSITION_REQ_TYPE.REQ_TYPE_ID AND RELATION_ACTION_ID = <cfif len(pos_cat)>#pos_cat#<cfelse>NULL</cfif>) AS POS_CAT_ID,
                    ISNULL((SELECT TOP 1 RELATION_FIELD_ID FROM RELATION_SEGMENT WHERE RELATION_ACTION = 5 AND RELATION_FIELD_ID = POSITION_REQ_TYPE.REQ_TYPE_ID),0) AS IS_FUNC,
                    (SELECT DISTINCT RELATION_ACTION_ID FROM RELATION_SEGMENT WHERE RELATION_ACTION = 5 AND RELATION_FIELD_ID = POSITION_REQ_TYPE.REQ_TYPE_ID AND RELATION_ACTION_ID = <cfif len(emp_func_id)>#emp_func_id#<cfelse>NULL</cfif>) AS FUNC_ID,
                    ISNULL((SELECT TOP 1 RELATION_FIELD_ID FROM RELATION_SEGMENT WHERE RELATION_ACTION = 6 AND RELATION_FIELD_ID = POSITION_REQ_TYPE.REQ_TYPE_ID),0) AS IS_ORG_STEP,
                    (SELECT DISTINCT RELATION_ACTION_ID FROM RELATION_SEGMENT WHERE RELATION_ACTION = 6 AND RELATION_FIELD_ID = POSITION_REQ_TYPE.REQ_TYPE_ID AND RELATION_ACTION_ID = <cfif len(emp_org_step_id)>#emp_org_step_id#<cfelse>NULL</cfif>) AS ORG_STEP_ID,
                    ISNULL((SELECT TOP 1 RELATION_FIELD_ID FROM RELATION_SEGMENT WHERE RELATION_ACTION = 7 AND RELATION_FIELD_ID = POSITION_REQ_TYPE.REQ_TYPE_ID),0) AS IS_BRANCH,
                    (SELECT DISTINCT RELATION_ACTION_ID FROM RELATION_SEGMENT WHERE RELATION_ACTION = 7 AND RELATION_FIELD_ID = POSITION_REQ_TYPE.REQ_TYPE_ID AND RELATION_ACTION_ID = <cfif len(emp_branch_id)>#emp_branch_id#<cfelse>NULL</cfif>) AS BRANCH_ID,
                    ISNULL((SELECT TOP 1 RELATION_FIELD_ID FROM RELATION_SEGMENT WHERE RELATION_ACTION = 10 AND RELATION_FIELD_ID = POSITION_REQ_TYPE.REQ_TYPE_ID),0) AS IS_TITLE,
                    (SELECT DISTINCT RELATION_ACTION_ID FROM RELATION_SEGMENT WHERE RELATION_ACTION = 10 AND RELATION_FIELD_ID = POSITION_REQ_TYPE.REQ_TYPE_ID AND RELATION_ACTION_ID = <cfif len(emp_title_id)>#emp_title_id#<cfelse>NULL</cfif>) AS TITLE_ID
                FROM 
                    POSITION_REQ_TYPE,
                    RELATION_SEGMENT RS
                WHERE
                    POSITION_REQ_TYPE.REQ_TYPE_ID = RS.RELATION_FIELD_ID AND
                    RS.RELATION_TABLE='POSITION_REQ_TYPE'
                    <cfif len(GET_PERF.START_DATE)>
                        AND PERFECTION_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#dateformat(GET_PERF.START_DATE,'yyyy')#">
                    </cfif>
                ) T1 
            WHERE
                T1.IS_ACTIVE = 1 AND
                (IS_COMPANY > 0 OR IS_BRANCH > 0 OR IS_DEPARTMENT > 0 OR IS_POS_CAT > 0 OR IS_FUNC > 0 OR IS_ORG_STEP > 0 OR IS_TITLE > 0)
                AND
                (
                    ((IS_COMPANY > 0 AND COMPANY_ID = <cfif len(emp_comp_id)>#emp_comp_id#<cfelse>NULL</cfif>) OR (IS_COMPANY = 0 AND COMPANY_ID IS NULL))
                    AND
                    ((IS_DEPARTMENT > 0 AND DEPARTMENT_ID = <cfif len(EMP_DEP_ID)>#EMP_DEP_ID#<cfelse>NULL</cfif>) OR (IS_DEPARTMENT = 0 AND DEPARTMENT_ID IS NULL))
                    AND
                    ((IS_BRANCH > 0 AND BRANCH_ID = <cfif len(emp_branch_id)>#emp_branch_id#<cfelse>NULL</cfif>) OR (IS_BRANCH = 0 AND BRANCH_ID IS NULL))
                    AND
                    ((IS_POS_CAT > 0 AND POS_CAT_ID = <cfif len(pos_cat)>#pos_cat#<cfelse>NULL</cfif>) OR (IS_POS_CAT = 0 AND POS_CAT_ID IS NULL))
                    AND
                    ((IS_FUNC > 0 AND FUNC_ID = <cfif len(emp_func_id)>#emp_func_id#<cfelse>NULL</cfif>) OR (IS_FUNC = 0 AND FUNC_ID IS NULL))
                    AND
                    ((IS_ORG_STEP > 0 AND ORG_STEP_ID = <cfif len(emp_org_step_id)>#emp_org_step_id#<cfelse>NULL</cfif>) OR (IS_ORG_STEP = 0 AND ORG_STEP_ID IS NULL))
                    AND
                    ((IS_TITLE > 0 AND TITLE_ID = <cfif len(emp_title_id)>#emp_title_id#<cfelse>NULL</cfif>) OR (IS_TITLE = 0 AND TITLE_ID IS NULL))
                )
            GROUP BY 
                T1.IS_GROUP,
                T1.REQ_TYPE_ID,
                T1.REQ_TYPE
            ORDER BY 
                T1.IS_GROUP DESC
        </cfquery>
        <cfif GET_EMP_REQ.RECORDCOUNT>
            <cfset yetkinlik_list=valuelist(GET_EMP_REQ.REQ_TYPE_ID,',')>
        <cfelse>
            <cfset yetkinlik_list=0>
        </cfif>
        <cfset yetkinlik_list_all=yetkinlik_list>
        <cfset kocluk_yetkinlik_list=0>
        <cfset dep_yetkinlik_list=0>
        <cfset std_yetkinlik_list=0>
    </cfif>
    <cfquery name="GET_EMP_QUIZ_ANSWERS" datasource="#dsn#">
        SELECT 
            EMPLOYEE_QUIZ_RESULTS_DETAILS.*,
            EMPLOYEE_QUIZ_RESULTS.USER_POINT,
            '' AS RECORD_EMP,
            EMPLOYEE_QUIZ_RESULTS.RECORD_DATE,
            EMPLOYEE_QUIZ_RESULTS.UPDATE_EMP,
            EMPLOYEE_QUIZ_RESULTS.UPDATE_DATE
        FROM 
            EMPLOYEE_QUIZ_RESULTS_DETAILS, 
            EMPLOYEE_QUIZ_RESULTS
        WHERE
            EMPLOYEE_QUIZ_RESULTS_DETAILS.RESULT_ID = EMPLOYEE_QUIZ_RESULTS.RESULT_ID AND
            EMPLOYEE_QUIZ_RESULTS_DETAILS.RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PERF.RESULT_ID#">
    </cfquery>
    <cfquery name="get_perf_def" datasource="#dsn#">
        SELECT 
            EMPLOYEE_PERFORM_WEIGHT,
            COMP_TARGET_WEIGHT,
            COMP_PERFORM_RESULT,
            EMPLOYEE_WEIGHT,
            UPPER_POSITION_WEIGHT,
            UPPER_POSITION2_WEIGHT,
            IS_STAGE,
            IS_EMPLOYEE,
            IS_CONSULTANT,
            IS_UPPER_POSITION,
            IS_MUTUAL_ASSESSMENT,
            IS_UPPER_POSITION2
        FROM
            EMPLOYEE_PERFORMANCE_DEFINITION
        WHERE
            YEAR = #dateformat(GET_PERF.start_date, 'yyyy')#
            AND IS_ACTIVE = 1      
            AND (','+TITLE_ID+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#emp_title_id#,%">
            OR ','+FUNC_ID+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#emp_func_id#,%">)
    </cfquery>
    <cfset cons_uppos2_cont = 0>
    <cfif get_perf_def.recordcount>
        <cfset emp_perf_weight = get_perf_def.EMPLOYEE_PERFORM_WEIGHT>
        <cfset req_weight = 100 - emp_perf_weight>
        <cfset comp_target_weight = get_perf_def.COMP_TARGET_WEIGHT>
        <cfset emp_perf_res = 100 - comp_target_weight>
        <cfset comp_perform_result = get_perf_def.COMP_PERFORM_RESULT>
        <cfif get_perf_def.is_stage eq 1 and (second_boss eq session.ep.position_code or get_emp.chief3_code eq session.ep.position_code) and ((get_perf_def.is_employee eq 1 and get_perf.valid_1 neq 1) 
            or (get_emp.chief3_code eq session.ep.position_code and get_perf_def.is_consultant eq 1 and get_perf.valid_2 eq 1) or (second_boss eq session.ep.position_code and ((get_perf_def.is_upper_position2 eq 1 and get_perf.valid_5 eq 1) 
            or (get_perf_def.is_consultant eq 1 and get_perf.valid_2 neq 1) or (get_perf_def.is_upper_position eq 1 and get_perf.valid_3 neq 1) or (get_perf_def.is_mutual_assessment eq 1 and get_perf.valid_4 neq 1))))>
        </cfif>
        <cfset upper_pos_weight = get_perf_def.upper_position_weight> 
    <cfelse>
        <cfset emp_perf_weight = ''>
        <cfset comp_target_weight = ''>
        <cfset req_weight = ''>
        <cfset emp_perf_res = ''>
        <cfset comp_perform_result = ''>
        <cfset upper_pos_weight = 100> 
    </cfif>
    <cfset emp_name=get_emp_info(GET_PERF.EMP_ID,0,0)>
    <cfif get_perf.is_closed eq 1>
        <cfset is_closed=1>
    <cfelse>
        <cfset is_closed=0>
    </cfif>
    
    <cfset target_score_val = get_perf.target_score>
	<cfif get_perf_def.is_stage eq 1 and is_closed neq 1> 
        <cfif get_perf_def.is_employee eq 1 and get_emp.employee_id eq session.ep.userid>
            <cfquery name="get_target_emp_score" datasource="#dsn#">
                SELECT 
                    SUM(CASE WHEN EMP_TARGET_RESULT IS NULL THEN 0 ELSE EMP_TARGET_RESULT END * #get_perf_def.EMPLOYEE_WEIGHT# / 100 * TARGET_WEIGHT / 100) AS EMP_SCORE 
                FROM 
                    TARGET 
                WHERE
                    EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PERF.EMP_ID#"> 
                    AND YEAR(FINISHDATE) = #dateformat(GET_PERF.finish_date, 'yyyy')# 
                    AND YEAR(STARTDATE) = #dateformat(GET_PERF.start_date, 'yyyy')#
            </cfquery>
            <cfif get_target_emp_score.recordcount><cfset target_score_val = get_target_emp_score.emp_score><cfelse><cfset target_score_val = ''></cfif>
        <cfelseif get_perf_def.is_upper_position eq 1 and first_boss eq session.ep.position_code>
            <cfset upper_pos_weight = get_perf_def.upper_position_weight>
            <cfif get_perf_def.is_upper_position2 eq 1 and not len(second_boss)><cfset upper_pos_weight = get_perf_def.upper_position_weight + get_perf_def.upper_position2_weight></cfif>
            <cfquery name="get_target_uppos_score" datasource="#dsn#">
                SELECT 
                    SUM(CASE WHEN UPPER_POSITION_TARGET_RESULT IS NULL THEN 0 ELSE UPPER_POSITION_TARGET_RESULT END * #upper_pos_weight# / 100 * TARGET_WEIGHT / 100) AS UPPOS_SCORE 
                FROM 
                    TARGET 
                WHERE
                    EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PERF.EMP_ID#"> 
                    AND YEAR(FINISHDATE) = #dateformat(GET_PERF.finish_date, 'yyyy')# 
                    AND YEAR(STARTDATE) = #dateformat(GET_PERF.start_date, 'yyyy')#
            </cfquery>
            <cfif get_target_uppos_score.recordcount><cfset target_score_val = get_target_uppos_score.UPPOS_SCORE><cfelse><cfset target_score_val = ''></cfif>
        <cfelseif get_perf_def.is_upper_position2 eq 1 and second_boss eq session.ep.position_code>
            <cfquery name="get_target_uppos2_score" datasource="#dsn#">
                SELECT 
                    SUM(CASE WHEN UPPER_POSITION2_TARGET_RESULT IS NULL THEN 0 ELSE UPPER_POSITION2_TARGET_RESULT END * #get_perf_def.UPPER_POSITION2_WEIGHT# / 100 * TARGET_WEIGHT / 100) AS UPPOS2_SCORE 
                FROM 
                    TARGET 
                WHERE
                    EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PERF.EMP_ID#"> 
                    AND YEAR(FINISHDATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#dateformat(get_perf.finish_date, 'yyyy')#"> 
                    AND YEAR(STARTDATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#dateformat(get_perf.start_date, 'yyyy')#">
            </cfquery>
            <cfif get_target_uppos2_score.recordcount><cfset target_score_val = get_target_uppos2_score.UPPOS2_SCORE><cfelse><cfset target_score_val = ''></cfif>
        <cfelseif get_perf_def.is_employee neq 1 and get_emp.employee_id eq session.ep.userid and ((len(second_boss) and get_perf.valid_5 neq 1) or get_perf.valid_3 neq 1)>
            <cfset target_score_val = 0>
        </cfif>
    </cfif>
    <cfquery name="GET_QUIZ_CHAPTERS" datasource="#dsn#">
        SELECT 
            CHAPTER_ID,
            ANSWER_NUMBER
            <cfloop from="1" to="20" index="i">
                ,answer#i#_POINT,answer#i#_text,answer#i#_photo
            </cfloop>
            ,CHAPTER
            ,CHAPTER_INFO
        FROM 
            EMPLOYEE_QUIZ_CHAPTER 
        WHERE 
            REQ_TYPE_ID IN (#yetkinlik_list_all#) 
    </cfquery>
    <cfset temp = 0>
    <cfset temp2 = 0>
	
    <cfset req_type_score_val = get_perf.req_type_score>
    <cfquery name="get_quest_points" datasource="#dsn#">
        SELECT DISTINCT
            EC.ANSWER1_POINT,
            EC.ANSWER2_POINT,
            EC.ANSWER3_POINT,
            EC.ANSWER4_POINT,
            EC.ANSWER5_POINT,
            EC.ANSWER6_POINT,
            EC.ANSWER7_POINT,
            EC.ANSWER8_POINT,
            EC.ANSWER9_POINT,
            EC.ANSWER10_POINT,
            EC.ANSWER11_POINT,
            EC.ANSWER12_POINT,
            EC.ANSWER13_POINT,
            EC.ANSWER14_POINT,
            EC.ANSWER15_POINT,
            EC.ANSWER16_POINT,
            EC.ANSWER17_POINT,
            EC.ANSWER18_POINT,
            EC.ANSWER19_POINT,
            EC.ANSWER20_POINT,
            EC.CHAPTER_ID
        FROM
            EMPLOYEE_QUIZ_QUESTION EQ,
            EMPLOYEE_QUIZ_CHAPTER EC,
            EMPLOYEE_QUIZ_RESULTS_DETAILS QR
        WHERE
            QR.RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_perf.result_id#">
            AND EQ.CHAPTER_ID = EC.CHAPTER_ID
            AND QR.QUESTION_ID = EQ.QUESTION_ID
    </cfquery>
    <cfset res_chapter_list = listsort(valuelist(get_quest_points.chapter_id),'numeric','asc')>
    <cfset res_point_list = "">
    <cfset res_mxpoint_list = "">
    <cfset chapter_weight_list = "">
    <cfset emp_req_type_score_val = 0>
    <cfset uppos_req_type_score_val = 0>
    <cfset uppos2_req_type_score_val = 0>
    <cfloop list="#res_chapter_list#" index="i">
        <cfquery name="get_points" dbtype="query">
            SELECT
                *
            FROM get_quest_points WHERE CHAPTER_ID = #i#
        </cfquery>
        <cfset temp_point_list = ''>
        <cfloop from="1" to="20" index="x">
            <cfif len(evaluate('get_points.answer#x#_point'))>
                <cfset temp_point_list = listAppend(temp_point_list,evaluate('get_points.answer#x#_point'))>
            </cfif>
        </cfloop>
        <cfset temp_point_list = listsort(temp_point_list,'numeric','desc')>
        <cfset res_point_list = listAppend(res_point_list,listfirst(temp_point_list))>
        <cfquery name="get_quest_count" datasource="#dsn#">
            SELECT COUNT(QUESTION_ID) AS Q_COUNT FROM EMPLOYEE_QUIZ_QUESTION WHERE CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
        </cfquery>
        <cfset res_mxpoint_list = listAppend(res_mxpoint_list,listfirst(temp_point_list)*get_quest_count.q_count)>
        <cfquery name="get_weights" datasource="#dsn#">
            SELECT
                CHAPTER_WEIGHT
            FROM 
                EMPLOYEE_QUIZ_CHAPTER 
            WHERE 
                CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
        </cfquery>
        <cfset chapter_weight_list = listAppend(chapter_weight_list,get_weights.chapter_weight)>
        <cfquery name="get_req_emp_score" datasource="#dsn#">
            SELECT 
                SUM(CASE WHEN QUESTION_POINT_EMP IS NULL THEN 0 ELSE QUESTION_POINT_EMP END) AS EMP_SCORE
            FROM 
                EMPLOYEE_QUIZ_QUESTION EQ,
                EMPLOYEE_QUIZ_CHAPTER EC,
                EMPLOYEE_QUIZ_RESULTS_DETAILS QR
            WHERE
                QR.RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_perf.result_id#">
                AND EQ.CHAPTER_ID = EC.CHAPTER_ID
                AND QR.QUESTION_ID = EQ.QUESTION_ID
                AND EC.CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
        </cfquery>
        <cfif len(get_perf_def.employee_weight)><cfset employee_weight_ = get_perf_def.employee_weight><cfelse><cfset employee_weight_ = 100></cfif>
        <cfif listgetAt(res_mxpoint_list,listfind(res_chapter_list,i)) gt 0>
        <cfset emp_req_type_score_val = emp_req_type_score_val + (get_req_emp_score.emp_score * listgetat(chapter_weight_list,listfind(res_chapter_list,i)) / listgetAt(res_mxpoint_list,listfind(res_chapter_list,i))*employee_weight_/100)>
        </cfif>
        <cfif get_perf_def.is_upper_position2 eq 1 and not len(second_boss)><cfset upper_pos_weight = get_perf_def.upper_position_weight + get_perf_def.upper_position2_weight></cfif>
        <cfquery name="get_req_uppos_score" datasource="#dsn#">
            SELECT 
                SUM(CASE WHEN QUESTION_POINT_MANAGER1 IS NULL THEN 0 ELSE QUESTION_POINT_MANAGER1 END) AS UPPOS_SCORE
            FROM 
                EMPLOYEE_QUIZ_QUESTION EQ,
                EMPLOYEE_QUIZ_CHAPTER EC,
                EMPLOYEE_QUIZ_RESULTS_DETAILS QR
            WHERE
                QR.RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_perf.result_id#">
                AND EQ.CHAPTER_ID = EC.CHAPTER_ID
                AND QR.QUESTION_ID = EQ.QUESTION_ID
                AND EC.CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
        </cfquery>
        <cfif listgetAt(res_mxpoint_list,listfind(res_chapter_list,i)) gt 0>
            <cfset uppos_req_type_score_val = uppos_req_type_score_val + (get_req_uppos_score.uppos_score * listgetat(chapter_weight_list,listfind(res_chapter_list,i)) / listgetAt(res_mxpoint_list,listfind(res_chapter_list,i))*upper_pos_weight/100)>
        </cfif>
        <cfquery name="get_req_uppos2_score" datasource="#dsn#">
            SELECT 
                SUM(CASE WHEN QUESTION_POINT_MANAGER2 IS NULL THEN 0 ELSE QUESTION_POINT_MANAGER2 END) AS UPPOS2_SCORE
            FROM 
                EMPLOYEE_QUIZ_QUESTION EQ,
                EMPLOYEE_QUIZ_CHAPTER EC,
                EMPLOYEE_QUIZ_RESULTS_DETAILS QR
            WHERE
                QR.RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_perf.result_id#">
                AND EQ.CHAPTER_ID = EC.CHAPTER_ID
                AND QR.QUESTION_ID = EQ.QUESTION_ID
                AND EC.CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
        </cfquery>
        <cfif len(get_perf_def.upper_position2_weight)><cfset upper_position2_weight_ = get_perf_def.upper_position2_weight><cfelse><cfset upper_position2_weight_ = 100></cfif>
        <cfif listgetAt(res_mxpoint_list,listfind(res_chapter_list,i)) gt 0>
            <cfset uppos2_req_type_score_val = uppos2_req_type_score_val + (get_req_uppos2_score.uppos2_score * listgetat(chapter_weight_list,listfind(res_chapter_list,i)) / listgetAt(res_mxpoint_list,listfind(res_chapter_list,i))*upper_position2_weight_/100)>
        </cfif>
    </cfloop>
    <cfset req_type_score_val= emp_req_type_score_val+uppos_req_type_score_val+uppos2_req_type_score_val>
    <cfif get_perf_def.is_stage eq 1 and is_closed neq 1> 
        <cfif get_perf_def.is_employee neq 1 and get_emp.employee_id eq session.ep.userid and ((len(second_boss) and get_perf.valid_5 neq 1) or get_perf.valid_3 neq 1)>
            <cfset req_type_score_val = 0>
        </cfif>
    </cfif>
</cfif>
<script type="text/javascript">
	<cfif not isdefined("attributes.event") or (isdefined("attributes.event") and attributes.event is 'list')> 
		$(document).ready(function(){
			document.getElementById('keyword').focus();
		});
		function showDepartment(branch_id)	
		{
			var branch_id = document.getElementById('branch_id').value;
			if (branch_id != "")
			{
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
				AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
			}
		}
		function kontrol(){
			return true;
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'add'> 
		function kontrol()
		{
			if(document.add_perf_emp_info.employee_id.value.length==0)
			{
				alert("<cf_get_lang_main no='1701.Çalışan seçiniz'>");
				return false;
			}
			return true;
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
		function unformat_fields()
		{
			if (document.upd_perform_form.records){
				for (i=1; i<=document.upd_perform_form.records.value; i++)
					if (document.getElementById('target_result'+i).value)
						document.getElementById('target_result'+i).value=filterNum(document.getElementById('target_result'+i).value);
			}
			var chapter_rcrdcnt = document.getElementById('get_quiz_chapters_rec').value;
			var session_position_code = "<cfoutput>#session.ep.position_code#</cfoutput>";
			var session_userid = "<cfoutput>#session.ep.userid#</cfoutput>";
			for(i=1; i<=chapter_rcrdcnt; i++)
			{
				var k = document.getElementById('get_quiz_questions_rec_'+i).value;
				var sayac = document.getElementById('answer_number_gelen_'+i).value;
				for (m=1; m<=k; m++)
				{	var gecti_ = 0;
					if(document.getElementById("upper_position_code").value == session_position_code || document.getElementById("upper_position_code2").value == session_position_code)
					{
						for (var yy=0; yy<sayac; yy++){
							if(document.getElementsByName('user_answer_'+i+'_'+m)[yy].checked == true)
								{gecti_ = 1; break;}
						}
						if(gecti_ == 0)
						{
							alert('Yetkinlik sorularını eksiksiz doldurunuz!');
							return false;
						}
					}
				}
			}
			document.getElementById('ready').value = 0;
	
			return process_cat_control();
		}
		function unlock_send()
		{
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_to_lock_target_plan_form&per_id=#attributes.per_id#&lock=1</cfoutput>','menu_1','0',"Form Kilidi Kaldırılıyor");
		}
		function lock_send()
		{
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_to_lock_target_plan_form&per_id=#attributes.per_id#&lock=0</cfoutput>','menu_1','0',"Form Kilitleniyor");
		}
		$(document).ready(function(e) {
			$('.area_show .area_head').click(function (e) {
				e.preventDefault();
				$(this).closest('li').find('.area_detail').not(':animated').slideToggle();
			});
			$('.area_show .area_head').click(function (e) {
				e.preventDefault();
				$(this).closest('li').find('area_detail').not(':animated').slideToggle();
			});
			document.getElementById('ready').value = 1;
			return process_cat_control();
		});
	</cfif>
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_target_perf';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/list_target_perf.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.target_plan_forms_info';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/form/target_plan_forms_info.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/query/add_target_plan_forms_info.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_target_perf&event=upd';
	
	WOStruct['#attributes.fuseaction#']['multiAdd'] = structNew();
	WOStruct['#attributes.fuseaction#']['multiAdd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['multiAdd']['fuseaction'] = 'hr.target_plan_forms_info_multiemp';
	WOStruct['#attributes.fuseaction#']['multiAdd']['filePath'] = 'hr/form/target_plan_forms_info_multiemp.cfm';
	WOStruct['#attributes.fuseaction#']['multiAdd']['queryPath'] = 'hr/query/add_target_plan_forms_info_multiemp.cfm';
	WOStruct['#attributes.fuseaction#']['multiAdd']['nextEvent'] = 'hr.list_target_perf';

	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.upd_target_plan_forms';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/form/upd_target_plan_forms.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/query/upd_target_plan_forms.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_target_perf';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'per_id=##attributes.per_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.per_id##';
	
	if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'hr.list_target_perf';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/query/del_target_plan_forms.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/query/del_target_plan_forms.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.list_target_perf';
	}
	if(IsDefined("attributes.event") && attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array.item[405]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_target_plan_boss&per_id=#attributes.per_id#</cfoutput>','small')";
		
		if (not isdefined("attributes.module_control"))
		{
			if (get_perf.is_closed eq 1)
			{
				if ((get_module_user(3) eq 1) or first_boss eq session.ep.position_code)
				{
					
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array.item[863]#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "unlock_send()";
				}else{
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array.item[865]#';
				}
			}else{
				if ((get_module_user(3) eq 1) or first_boss eq session.ep.position_code)
				{	
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array.item[866]#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "lock_send()";
				}
			}
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.per_id#&print_type=176','page')";

		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
