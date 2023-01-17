<cf_xml_page_edit>
<cf_catalystHeader>
<cfif #lcase(listgetat(attributes.fuseaction,1,'.'))# eq 'myhome'>
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
		alert("<cf_get_lang dictionary_id='31613.Görüntülemek İstediğiniz form yok'>!");
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
        YEAR(FINISHDATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(dateformat(get_perf.finish_date,dateformat_style))#"> AND
        YEAR(STARTDATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(dateformat(GET_PERF.start_date,dateformat_style))#">
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
<cfinclude template="../query/get_moneys.cfm">
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
<cfif get_perf.is_closed eq 1><cfset is_closed=1><cfelse><cfset is_closed=0></cfif>
<cfsavecontent variable="right">
<table align="right">
	<tr>
        <td><cfif session.ep.ehesap>
        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_target_plan_boss&per_id=#attributes.per_id#</cfoutput>','small');"><i class="icon-SUBO" title="Amirler" align="absmiddle" border="0"></i></a>
        </cfif></td>
        <td id="menu_1" <cfif #lcase(listgetat(attributes.fuseaction,1,'.'))# eq 'myhome'>style="display:none;"</cfif>>
    <!--- Kilitle, Kilidi Kaldır. --->
		<cfif get_perf.is_closed eq 1>
            <cfif (get_module_user(3) eq 1) or first_boss eq session.ep.position_code>
            	<!--- ik süper kullanıcı ve 1.amir kilit açabilir --->
                <a href="javascript://" onClick="unlock_send();"><i class="fa fa-lock" title="Form Kilidini Kaldır"></a>
          	<cfelse>
            	<!--- ik süper kullanıcı ve 1.amir olmayan kilidi görür --->
				<i class="fa fa-lock" title="Form Kilitli">
            </cfif>
      	<cfelse>
        	<cfif (get_module_user(3) eq 1) or first_boss eq session.ep.position_code><!--- ik süper kullanıcı ve 1.amir olan kişi kilitleyebilir--->
            	<!--- kilitlenebilir --->
				<a href="javascript://" onClick="lock_send();"><i class="fa fa-unlock" title="Formu Kilitle"></a>
          	</cfif>
        </cfif>
    </td>
	<!--- <td><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.per_id#&print_type=176</cfoutput>','page');"><i class="icon-print" title="<cf_get_lang_main no='62.Yazdır'>"></a></td> --->
	</tr>
</table>
</cfsavecontent>
<div class="col col-12">
<cfsavecontent variable="message"><cf_get_lang dictionary_id="29764.Form"></cfsavecontent>
<cf_box title="#message# :<cfoutput>#emp_name#</cfoutput>" right_images="#right#" print_href="#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.per_id#&print_type=176">
    
    <cf_seperator id="info" title="#getLang('','Çalışan Hakkında Bilgiler',41512)#">
    <input type="hidden" name="ready" id="ready" value="0">
    <cfform name="upd_perform_form" method="post" action="#request.self#?fuseaction=#lcase(listgetat(attributes.fuseaction,1,'.'))#.emptypopup_upd_target_plan_forms&pos_code=#attributes.pos_code#">
    <cfinput type="hidden" name="employee_id" id="employee_id" value="#get_emp.employee_id#">
    <div class="col col-12" id="info">
        <cf_box_elements>
            <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                    <label><cf_get_lang dictionary_id='55757.Adı Soyadı'></label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <cfoutput>:&nbsp;#emp_name#</cfoutput>
                </div>
            </div>
            <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                    <label><cf_get_lang dictionary_id='55154.İşe Başlama Tarihi'></label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <cfoutput>:&nbsp;#dateformat(get_emp.start_date, dateformat_style)#</cfoutput>
                </div>
            </div>
            <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                    <label><cf_get_lang dictionary_id='57453.Şube'></label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <cfoutput>:&nbsp;<cfif len(get_perf.update_date)>#get_perf.branch_name#<cfelse>#get_emp.branch_name#</cfif></cfoutput>
                </div>
            </div>
            <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                    <label><cf_get_lang dictionary_id='57571.Ünvan'></label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <cfoutput>:&nbsp;<cfif len(get_perf.update_date)>#get_perf.title#<cfelse>#get_emp.title#</cfif></cfoutput>
                </div>
            </div>
            <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                    <label><cf_get_lang dictionary_id='57572.Departman'> / <cf_get_lang dictionary_id='59004.Pozisyon Tipi'></label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <cfoutput>:&nbsp;<cfif len(get_perf.update_date)>#get_perf.department_head# / #get_perf.position_cat#<cfelse>#get_emp.department_head# / #get_emp.position_cat#</cfif></cfoutput>
                </div>
            </div>
            <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                    <label><cf_get_lang dictionary_id="41511.Değerlendirmeyi Yapan Yönetici">(<cf_get_lang dictionary_id="35927.Birinci Amir">)</label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <cfoutput>:&nbsp;<cfif len(first_boss)>#get_emp_info(first_boss,1,0)#</cfif></cfoutput>
                </div>
            </div>
            <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                    <label><cf_get_lang dictionary_id='58472.Dönem'></label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <cfoutput>:&nbsp;#dateformat(GET_PERF.start_date,dateformat_style)# - #dateformat(GET_PERF.finish_date,dateformat_style)#</cfoutput>
                </div>
            </div>
            <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                    <label><cf_get_lang dictionary_id="35921.İkinci Amir"></label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <cfoutput>:&nbsp;<cfif len(second_boss)>#get_emp_info(second_boss,1,0)#</cfif></cfoutput>
                </div>
            </div>
            <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                    <label><cf_get_lang dictionary_id="58859.Süreç"></label>
                </div>
                <div class="col col-4 col-md-9 col-sm-9 col-xs-12">
                    <cf_workcube_process is_upd='0' select_value='#GET_PERF.stage#' process_cat_width='120' is_detail='1'>
                </div>
            </div>
        </cf_box_elements>
    </div>

    <cf_seperator title="#getLang('','Disiplin İşlemleri',32161)#" id="disipline" >
    <div class="col col-12" id="disipline">
        <cf_box_elements>
            <cf_flat_list name="caution_table" id="caution_table" is_sort="1">
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='58772.İşlem No'></th>
                        <th><cf_get_lang dictionary_id='57480.Konu'></th>
                        <th><cf_get_lang dictionary_id='57630.Tip'></th>
                        <th><cf_get_lang dictionary_id="53515.İşlem Yapılan"></th>
                        <th><cf_get_lang dictionary_id='58586.İşlem Yapan'></th>
                        <th><cf_get_lang dictionary_id='57879.İşlem Tarihi'></th>
                        <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
                    </tr>
                </thead>
                <tbody>
                    <cfif get_caution.recordcount>
                        <cfoutput query="get_caution">
                            <tr>
                                <td>#decision_no#</td>
                                <td>#caution_head#</td>
                                <td>#caution_type#</td>
                                <td>#caution_to#</td>
                                <td>#warner#</td>
                                <td>#dateformat(caution_date,dateformat_style)#</td>
                                <td>#dateformat(record_date,dateformat_style)#</td>
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="7"><cf_get_lang dictionary_id="41510.Kişiye Eklenmiş Disiplin İşlemi Kaydı Yok"></td>
                        </tr>
                    </cfif>
                </tbody>
            </cf_flat_list>
        </cf_box_elements>
    </div>
    <cf_seperator id="price" title="#getLang('','Ödüller',55462)#">
    <div class="col col-12" id="price">
        <cf_box_elements>
            <cf_flat_list name="prize_table" id="prize_table" is_sort="1">
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id="31164.Ödül"></th>
                        <th><cf_get_lang dictionary_id="55553.Ödül Tipi"></th>
                        <th><cf_get_lang dictionary_id="53123.Ödül Alan"></th>
                        <th><cf_get_lang dictionary_id="31856.Ödül Veren"></th>
                        <th><cf_get_lang dictionary_id="31165.Veriliş Tarihi"></th>
                        <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
                    </tr>
                </thead>
                <tbody>
                    <cfif get_prize.recordcount>
                        <cfoutput query="get_prize">
                            <tr>
                                <td>#prize_head#</td>
                                <td>#prize_type#</td>
                                <td>#prize_to#</td>
                                <td>#prize_give_person#</td>
                                <td>#dateformat(prize_date,dateformat_style)#</td>
                                <td>#dateformat(record_date,dateformat_style)#</td>
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="6"><cf_get_lang dictionary_id="41509.Kişiye Eklenmiş Ödül Kaydı Yok"></td>
                        </tr>
                    </cfif>
                </tbody>
            </cf_flat_list>
        </cf_box_elements>
    </div>

    <cf_seperator id="aim" title="#getLang('','Hedefler',57964)#">
    <div class="col col-12" id="aim">
        <cf_box_elements>
            <cf_flat_list name="target_table" id="target_table" is_sort="1">
                <thead>
                    <tr> 
                        <th><cf_get_lang dictionary_id ='57951.Hedef'></th>
                        <th><cf_get_lang dictionary_id ='56469.Hedef Ağırlığı'>(%)</th>
                        <th><cf_get_lang dictionary_id ='29805.Yorum'></th>
                        <!---<th width="100"><cf_get_lang no ='1386.Hedef için Çalışmadı /Çaba Gösterilmedi'></th>
                        <th width="100"><cf_get_lang no ='1387.Çaba Gösterildi Ama Beklenin Altında'></th>
                        <th width="100"><cf_get_lang no ='1388.Hedefe Ulaşıldı / İstenen Sonuç Elde Edildi'></th>
                        <th width="100"><cf_get_lang no ='1389.Hedef Aşıldı'></th>--->
                        <cfif (get_perf.is_closed neq 1 and get_emp.employee_id neq session.ep.userid) or (get_perf.is_closed eq 1) or #lcase(listgetat(attributes.fuseaction,1,'.'))# eq 'hr'>
                            <th id="target_point_hdr"><cf_get_lang dictionary_id ='58984.Puan'></th>
                        </cfif>
                        <th id="emp_puan_hdr" <cfif not (len(get_perf_def.is_stage) and get_perf_def.is_stage eq 1 and get_perf_def.is_employee)>style="display:none;"</cfif>>Çalışan Puan</th>
                        <cfif get_perf.is_closed eq 1 or (first_boss eq session.ep.position_code and get_perf.is_closed neq 1) or #lcase(listgetat(attributes.fuseaction,1,'.'))# eq 'hr' or (not len(second_boss) and get_perf.valid_3 eq 1) or (len(second_boss) and get_perf.valid_5 eq 1)>
                            <th id="uppos_puan_hdr" <cfif not (len(get_perf_def.is_stage) and get_perf_def.is_stage eq 1 and get_perf_def.is_upper_position)>style="display:none;"</cfif>>1.Amir Puan</th>
                        </cfif>
                        <cfif len(second_boss) and (get_perf.is_closed eq 1 or (second_boss eq session.ep.position_code and get_perf.is_closed neq 1) or #lcase(listgetat(attributes.fuseaction,1,'.'))# eq 'hr' or get_perf.valid_5 eq 1)>
                            <th id="uppos2_puan_hdr" <cfif not (len(get_perf_def.is_stage) and get_perf_def.is_stage eq 1 and get_perf_def.is_upper_position2)>style="display:none;"</cfif>>2.Amir Puan</th>
                        </cfif>
                        <cfif GET_PERF.EMP_VALID_FORM neq 1 and is_closed neq 1 and (#lcase(listgetat(attributes.fuseaction,1,'.'))# eq 'hr' or first_boss eq session.ep.position_code or get_emp.EMPLOYEE_ID eq session.ep.userid)><th width="15" class="header_icn_none"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=hr.targets&event=add</cfoutput>','list');" title="Hedef Ekle"><i class="fa fa-plus"></i></a></th></cfif>
                    </tr>
                </thead>
                <tbody>
                    <cfif GET_TARGET.recordcount>
                        <input type="hidden" id="records" name="records" value="<cfoutput>#GET_TARGET.recordcount#</cfoutput>" />
                        <input type="hidden" id="targetperid" name="targetperid" value="<cfoutput>#GET_TARGET.PER_ID#</cfoutput>" />
                        <cfoutput query="GET_TARGET">
                            <input type="hidden" name="targetid#currentrow#" id="targetid#currentrow#" value="#TARGET_ID#" />
                            <tr id="frm_target_row#currentrow#">
                                <td><cfif is_closed neq 1 and (get_module_user(3) or first_boss eq session.ep.position_code or get_emp.EMPLOYEE_ID eq session.ep.userid)><a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_form_add_target&event=upd&target_id=#TARGET_ID#&position_code=#GET_PERF.POSITION_CODE#<cfif GET_PERF.EMP_VALID_FORM eq 1>&per_id=#attributes.per_id#</cfif>','page')">#TARGET_HEAD#</a><cfelse>#TARGET_HEAD#</cfif></td>
                                <td>#TARGET_WEIGHT#</td>
                                <cfif (len(second_boss) and get_perf.valid_5 eq 1) or (not len(second_boss) and get_perf.valid_3 eq 1) or #lcase(listgetat(attributes.fuseaction,1,'.'))# eq 'hr' or get_perf.is_closed eq 1 or first_boss eq session.ep.position_code>
                                    <td><textarea name="target_comment#currentrow#" id="target_comment#currentrow#" style="width:100%;" <cfif not (#lcase(listgetat(attributes.fuseaction,1,'.'))# eq 'hr' or first_boss eq session.ep.position_code) or cons_uppos2_cont eq 1 or get_emp.EMPLOYEE_ID eq session.ep.userid>readonly="readonly"</cfif>>#PERFORM_COMMENT#</textarea></td>
                                <cfelse>
                                    <td><textarea name="target_comment#currentrow#" id="target_comment#currentrow#" style="width:100%;display:none;" <cfif not (#lcase(listgetat(attributes.fuseaction,1,'.'))# eq 'hr' or first_boss eq session.ep.position_code) or cons_uppos2_cont eq 1 or get_emp.EMPLOYEE_ID eq session.ep.userid>readonly="readonly"</cfif>>#PERFORM_COMMENT#</textarea></td>  
                                </cfif>
                                <cfset target_res_val = target_result>
                                <cfif (get_perf.is_closed neq 1 and get_emp.employee_id neq session.ep.userid) or (get_perf.is_closed eq 1) or #lcase(listgetat(attributes.fuseaction,1,'.'))# eq 'hr'>
                                    <td id="target_point_td#currentrow#">
                                        <cfif get_perf_def.is_stage eq 1> 
                                            <cfif get_perf_def.is_employee eq 1 and get_emp.employee_id eq session.ep.userid>
                                                <cfset target_res_val = emp_target_result>
                                            <cfelseif get_perf_def.is_upper_position eq 1 and first_boss eq session.ep.position_code>
                                                <cfset target_res_val = upper_position_target_result>
                                            <cfelseif get_perf_def.is_upper_position2 eq 1 and second_boss eq session.ep.position_code>
                                                <cfset target_res_val = upper_position2_target_result>
                                            </cfif>
                                        </cfif>
                                        <cfif #lcase(listgetat(attributes.fuseaction,1,'.'))# eq 'hr' or session.ep.ehesap or first_boss eq session.ep.position_code or get_emp.employee_id eq session.ep.userid or cons_uppos2_cont eq 0>
                                            <cfinput type="text" onkeyup="return(formatcurrency(this,event));" name="target_result#currentrow#" id="target_result#currentrow#" value="#target_res_val#" message="hedeflerin sonucu 0-100 arasında olmalıdır!" maxlength="6" validate="integer" range="0,100">
                                        <cfelse>
                                            <cfinput type="text" name="target_result#currentrow#" id="target_result#currentrow#" value="#target_res_val#" message="hedeflerin sonucu 0-100 arasında olmalıdır!" maxlength="6" validate="integer" readonly="readonly" range="0,100">
                                        </cfif>
                                    </td>
                                <cfelse>
                                    <input type="hidden" name="target_result#currentrow#" id="target_result#currentrow#" value="#target_res_val#" maxlength="6" validate="integer">
                                </cfif>
                                <td id="emp_puan_td#currentrow#" <cfif not (get_perf_def.is_stage eq 1 and get_perf_def.is_employee eq 1)>style="display:none;"</cfif>>#emp_target_result#</td>
                                <cfif get_perf.is_closed eq 1 or (first_boss eq session.ep.position_code and get_perf.is_closed neq 1) or #lcase(listgetat(attributes.fuseaction,1,'.'))# eq 'hr' or (not len(second_boss) and get_perf.valid_3 eq 1) or (len(second_boss) and get_perf.valid_5 eq 1)>
                                    <td id="uppos_puan_td#currentrow#" <cfif not (get_perf_def.is_stage eq 1 and get_perf_def.is_upper_position eq 1)>style="display:none;"</cfif>>#upper_position_target_result#</td>
                                </cfif>
                                <cfif len(second_boss) and (get_perf.is_closed eq 1 or (second_boss eq session.ep.position_code and get_perf.is_closed neq 1) or #lcase(listgetat(attributes.fuseaction,1,'.'))# eq 'hr' or get_perf.valid_5 eq 1)>
                                    <td name="uppos2_puan_td" id="uppos2_puan_td#currentrow#" <cfif not (get_perf_def.is_stage eq 1 and get_perf_def.is_upper_position2 eq 1)>style="display:none;"</cfif>>#upper_position2_target_result#</td>
                                </cfif>
                                <cfif GET_PERF.EMP_VALID_FORM neq 1 and is_closed neq 1 and (#lcase(listgetat(attributes.fuseaction,1,'.'))# eq 'hr' or first_boss eq session.ep.position_code or get_emp.EMPLOYEE_ID eq session.ep.userid)><td style="text-align:center;"><!---<a style="cursor:pointer" onclick="windowopen('#request.self#?fuseaction=objects.del_target&target_id=#TARGET_ID#&per_id=#attributes.per_id#&head=#TARGET_HEAD#&cat=#TARGETCAT_ID#','small');"><img  src="/images/delete_list.gif" border="0"></a>---></td></cfif>
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr id="frm_target_row0">
                            <td colspan="8"><cf_get_lang dictionary_id ='56475.Kişiye Eklenmiş Hedef Kaydı Yok'></td>
                        </tr>
                    </cfif>
                </tbody>
                <tfoot>
                    <tr>
                        <cfset target_score_val = iIf(get_perf.target_score neq '', get_perf.target_score, 0)>
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
                                <cfif get_target_emp_score.recordcount><cfset target_score_val = get_target_emp_score.emp_score><cfelse><cfset target_score_val = 0></cfif>
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
                        <td colspan="8" style="text-align:right; padding-right:10px;" class="txtbold"><cf_get_lang dictionary_id="41508.Hedefler Sonuç Değerlendirme Puanı"> : <cfoutput>#TLFormat(target_score_val,2)#</cfoutput></td>
                    </tr>
                </tfoot>
            </cf_flat_list>
                <cfoutput>
                <input type="hidden" name="ses_user_id" id="ses_user_id" value="#session.ep.userid#">
                <input type="hidden" name="ses_pos_code" id="ses_pos_code" value="#session.ep.position_code#">
                <input type="hidden" name="per_id" id="per_id" value="#attributes.per_id#">
                <input type="hidden" name="emp_id" id="emp_id" value="#GET_PERF.EMP_ID#">
                <input type="hidden" name="position_code" id="position_code" value="#GET_PERF.POSITION_CODE#">
                <input type="hidden" name="upper_position_code" id="upper_position_code" value="#first_boss#" />
                <input type="hidden" name="upper_position_code2" id="upper_position_code2" value="#second_boss#" />
                <input type="hidden" name="result_id" id="result_id" value="#GET_PERF.RESULT_ID#">
                <input type="hidden" name="all_req_type_id" id="all_req_type_id" value="#yetkinlik_list_all#">
                <input type="hidden" name="req_type_list" id="req_type_list" value="#yetkinlik_list#">
                <input type="hidden" name="coach_req_type_list" id="coach_req_type_list" value="#kocluk_yetkinlik_list#">
                <input type="hidden" name="dep_req_type_list" id="dep_req_type_list" value="#dep_yetkinlik_list#">
                <input type="hidden" name="std_req_type_list" id="std_req_type_list" value="#std_yetkinlik_list#">
                <input type="hidden" name="finishdate_year" id="finishdate_year" value="#year(dateformat(get_perf.finish_date,dateformat_style))#">
                <input type="hidden" name="startdate_year" id="startdate_year" value="#year(dateformat(get_perf.start_date,dateformat_style))#">
                <input type="hidden" name="emp_performance_weight" id="emp_performance_weight" value="#emp_perf_weight#">
                <input type="hidden" name="emp_req_weight" id="emp_req_weight" value="#req_weight#">
                <input type="hidden" name="emp_performance_weight2" id="emp_performance_weight2" value="#emp_perf_res#">
                <input type="hidden" name="comp_performance_result" id="comp_performance_result" value="#comp_perform_result#">
                <input type="hidden" name="comp_target_wght" id="comp_target_wght" value="#comp_target_weight#">
                <input type="hidden" name="emp_dep_id" id="emp_dep_id" value="#emp_dep_id#">
                <input type="hidden" name="pos_cat" id="pos_cat" value="#pos_cat#">
                <input type="hidden" name="emp_comp_id" id="emp_comp_id" value="#emp_comp_id#">
                <input type="hidden" name="emp_branch_id" id="emp_branch_id" value="#emp_branch_id#">
                <input type="hidden" name="emp_title_id" id="emp_title_id" value="#emp_title_id#">
                <input type="hidden" name="emp_func_id" id="emp_func_id" value="#emp_func_id#">
                <input type="hidden" name="is_stage" id="is_stage" value="<cfif isdefined('get_perf_def.is_stage') and len(get_perf_def.is_stage)>#get_perf_def.is_stage#<cfelse>0</cfif>">
                <input type="hidden" name="is_employee" id="is_employee" value="<cfif isdefined('get_perf_def.is_employee') and len(get_perf_def.is_employee)>#get_perf_def.is_employee#<cfelse>0</cfif>">
                <input type="hidden" name="is_consultant" id="is_consultant" value="<cfif isdefined('get_perf_def.is_consultant') and len(get_perf_def.is_consultant)>#get_perf_def.is_consultant#<cfelse>0</cfif>">
                <input type="hidden" name="is_upper_position" id="is_upper_position" value="<cfif isdefined('get_perf_def.is_upper_position') and len(get_perf_def.is_upper_position)>#get_perf_def.is_upper_position#<cfelse>0</cfif>">
                <input type="hidden" name="is_mutual_assessment" id="is_mutual_assessment" value="<cfif isdefined('get_perf_def.is_mutual_assessment') and len(get_perf_def.is_mutual_assessment)>#get_perf_def.is_mutual_assessment#<cfelse>0</cfif>">
                <input type="hidden" name="is_upper_position2" id="is_upper_position2" value="<cfif isdefined('get_perf_def.is_upper_position2') and len(get_perf_def.is_upper_position2)>#get_perf_def.is_upper_position2#<cfelse>0</cfif>">
                <input type="hidden" name="valid" id="valid" value="#get_perf.valid#">
                <input type="hidden" name="valid_1" id="valid_1" value="#get_perf.valid_1#">
                <input type="hidden" name="valid_2" id="valid_2" value="#get_perf.valid_2#">
                <input type="hidden" name="valid_3" id="valid_3" value="#get_perf.valid_3#">
                <input type="hidden" name="valid_4" id="valid_4" value="#get_perf.valid_4#">
                <input type="hidden" name="valid_5" id="valid_5" value="#get_perf.valid_5#">
                <input type="hidden" name="chief3_code" id="chief3_code" value="<cfif isdefined('get_emp.chief3_code') and len(get_emp.chief3_code)>#get_emp.chief3_code#</cfif>">
                <input type="hidden" name="cons_uppos2_cont" id="cons_uppos2_cont" value="#cons_uppos2_cont#" />
                <input type="hidden" name="is_closed" id="is_closed" value="#is_closed#" />
            </cfoutput>
        </cf_box_elements>
    </div>

    <cf_seperator id="chapter" title="#getLang('','Yetkinlikler',58709)#">
    <div class="col col-12" id="chapter">
        <cfset cfc = createObject("component","V16.hr.cfc.competencies")>
        <cfset attributes.employee_id = get_emp.employee_id>
        <cfset getReqTypeForEmp = cfc.getReqTypeForEmp(employee_id: attributes.employee_id)>
        <cf_box_elements>
            <cf_flat_list>
                <thead>
                    <tr>
                        <th width="15%"><cf_get_lang dictionary_id='57907.Yetkinlik'></th>
                        <th width="10%"><cf_get_lang dictionary_id='31599.Hedef Ağırlığı'>(%)</th>
                        <th width="35%"><cf_get_lang dictionary_id ='29805.Yorum'></th>
                        <th width="30px"><cf_get_lang dictionary_id='58984.Puan'></th>
                    </tr>
                </thead>
                <tbody>
                    <cfset COMPETENCIES_TOTAL_VALUE = 0>
                    <cfif getReqTypeForEmp.recordcount>
                        <cfoutput query="getReqTypeForEmp">
                            <cfset COMPETENCIES_TOTAL_VALUE += len(COMPETENCIES_TOTAL) ? COMPETENCIES_TOTAL: 0>
                            <tr>
                                <cfinput type="hidden" name="employee_id" value="#attributes.employee_id#">
                                <input type="hidden" name="competenciesid#currentrow#" id="competenciesid#currentrow#" value="#COMPETENCIES_ID#" />
                                <td><a class="tableyazi">#REQ_NAME#</a></td>
                                <td>
                                    <cfif len(competencies_weight)>
                                        <cfinput name="competencies_weight#currentrow#" id="competencies_weight#currentrow#" value="#competencies_weight#" message="#getLang('','Ağırlık için 0 ile 100 arasında bir sayı giriniz',38677)#">
                                    <cfelse>
                                        <cfinput name="competencies_weight#currentrow#" id="competencies_weight#currentrow#" value="" message="#getLang('','Ağırlık için 0 ile 100 arasında bir sayı giriniz',38677)#">
                                    </cfif>
                                </td>
                                <cfif (len(second_boss) and get_perf.valid_5 eq 1) or (not len(second_boss) and get_perf.valid_3 eq 1) or #lcase(listgetat(attributes.fuseaction,1,'.'))# eq 'hr' or get_perf.is_closed eq 1 or first_boss eq session.ep.position_code>
                                    <td><textarea name="competencies_comment#currentrow#" id="competencies_comment#currentrow#" style="width:100%;" <cfif not (#lcase(listgetat(attributes.fuseaction,1,'.'))# eq 'hr' or first_boss eq session.ep.position_code) or cons_uppos2_cont eq 1 or get_emp.EMPLOYEE_ID eq session.ep.userid>readonly="readonly"</cfif>>#COMPETENCIES_COMMENT#</textarea></td>
                                <cfelse>
                                    <td><textarea name="competencies_comment#currentrow#" id="competencies_comment#currentrow#" style="width:100%;display:none;" <cfif not (#lcase(listgetat(attributes.fuseaction,1,'.'))# eq 'hr' or first_boss eq session.ep.position_code) or cons_uppos2_cont eq 1 or get_emp.EMPLOYEE_ID eq session.ep.userid>readonly="readonly"</cfif>>#COMPETENCIES_COMMENT#</textarea></td>
                                </cfif>
                                <td>
                                    <cfinput type="text" name="competencies_score#currentrow#" id="competencies_score#currentrow#" value="#competencies_score#" message="#getLang('','0-100 arası bir değer giriniz',65268)#" maxlength="6" validate="integer" range="0,100">
                                </td>
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                        </tr>
                    </cfif>
                </tbody>
            </cf_flat_list>
        </cf_box_elements>

        <cf_flat_list style="width:99%">
            <tfoot>
                <tr class="nohover">
                    <td style="text-align:right; padding-right:10px;" class="txtbold">
                        <cf_get_lang dictionary_id="41634.Yetkinlikler Sonuç Değerlendirme Puanı"> : <cfoutput>#tlformat(COMPETENCIES_TOTAL_VALUE)#</cfoutput>
                    </td>
                </tr>
            </tfoot>
        </cf_flat_list>
    </div>

    <cf_seperator id="result" title="#getLang('','Sonuc',57684)#">
    <div class="col col-12" id="result">
        <cf_box_elements>
            <cf_flat_list>
                    <thead>
                        <tr>
                            <th width="50%"></th>
                            <th style="text-align:center;"><cf_get_lang dictionary_id="41633.Bireysel Performans Değerlendirme"></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <cfset target_score_total = target_score_val*x_target_perf_rate/100>
                            <td><cf_get_lang dictionary_id="41632.Bireysel Hedefler Puanı"> (%<cfoutput>#x_target_perf_rate#</cfoutput>)</td>
                            <td style="text-align:center;"><cfoutput><cfif len(target_score_val)>#TLFormat(target_score_total,2)#<cfelse>-</cfif></cfoutput></td>
                        </tr>
                        <tr>
                            <cfset competencies_score_total = COMPETENCIES_TOTAL_VALUE*x_competencies_rate/100>
                            <td><cf_get_lang dictionary_id="41605.Yetkinlik Değerlendirme Puanı"> (%<cfoutput>#x_competencies_rate#</cfoutput>)</td>
                            <td style="text-align:center;">
                                <cfoutput>
                                    <cfif len(COMPETENCIES_TOTAL_VALUE)>#TLFormat(competencies_score_total,2)#<cfelse>-</cfif>
                                </cfoutput>
                            </td>
                        </tr>
                    </tbody>
                    <tfoot>
                        <tr>
                            <td style="text-align:right; padding-right:10px;" class="txtbold" colspan="2"><cf_get_lang dictionary_id="41604.Bireysel Performans Sonucu"> : <cfoutput><cfif len(competencies_score_total) or len(target_score_total)>#TLFormat(competencies_score_total+target_score_total,2)#<cfelse>-</cfif></cfoutput></td>
                        </tr>
                    </tfoot>
                </cf_flat_list><br />
                <cfif len(comp_perform_result) and len(comp_target_weight)>
                    <cf_flat_list>
                        <thead>
                            <tr>
                                <th width="50%"></th>
                                <th style="text-align:center;"><cf_get_lang dictionary_id="41601.Genel Performans Değerlendirme"></th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><cf_get_lang dictionary_id="41604.Bireysel Performans Sonucu"> (% <cfoutput>#emp_perf_res#</cfoutput>)</td>
                                <cfset emp_perf_result2_val = get_perf.emp_perf_result2>
                                <cfif get_perf_def.is_stage eq 1 and is_closed neq 1 and ((get_perf_def.is_employee eq 1 and get_emp.employee_id eq session.ep.userid) 
                                    or (get_perf_def.is_upper_position eq 1 and first_boss eq session.ep.position_code) or (get_perf_def.is_upper_position2 eq 1 and second_boss eq session.ep.position_code))> 
                                    <cfif len(emp_perf_result_val) and len(emp_perf_res)>
                                        <cfset emp_perf_result2_val = emp_perf_result_val * emp_perf_res / 100> 
                                    <cfelse>
                                        <cfset emp_perf_result2_val = ''>
                                    </cfif>
                                </cfif>
                                <cfif get_perf_def.is_stage eq 1 and is_closed neq 1 and get_perf_def.is_employee neq 1 and get_emp.employee_id eq session.ep.userid and ((len(second_boss) and get_perf.valid_5 neq 1) or get_perf.valid_3 neq 1)>
                                    <cfset emp_perf_result2_val = 0>
                                </cfif>
                                <td style="text-align:center;"><cfoutput><cfif len(emp_perf_result2_val)>#TLFormat(emp_perf_result2_val,2)#<cfelse>-</cfif></cfoutput></td>
                            </tr>
                            <tr>
                                <td><cf_get_lang dictionary_id="33724.Şirket Performans Sonucu"> (% <cfoutput>#comp_target_weight#</cfoutput>)</td>
                                <cfset comp_perf_result_val = get_perf.comp_perf_result>
                                <cfif get_perf_def.is_stage eq 1 and is_closed neq 1 and ((get_perf_def.is_employee eq 1 and get_emp.employee_id eq session.ep.userid) 
                                    or (get_perf_def.is_upper_position eq 1 and first_boss eq session.ep.position_code) or (get_perf_def.is_upper_position2 eq 1 and second_boss eq session.ep.position_code))> 
                                    <cfif len(comp_target_weight) and len(comp_perform_result)>
                                        <cfset comp_perf_result_val = comp_target_weight * comp_perform_result /100> 
                                    <cfelse>
                                        <cfset comp_perf_result_val = ''>
                                    </cfif>
                                </cfif>
                                <cfif get_perf_def.is_stage eq 1 and is_closed neq 1 and get_perf_def.is_employee neq 1 and get_emp.employee_id eq session.ep.userid and ((len(second_boss) and get_perf.valid_5 neq 1) or get_perf.valid_3 neq 1)>
                                    <cfset comp_perf_result_val = 0>
                                </cfif>
                                <td style="text-align:center;"><cfoutput><cfif len(comp_perf_result_val)>#TLFormat(comp_perf_result_val,2)#<cfelse>-</cfif></cfoutput></td>
                            </tr>
                        </tbody>
                        <tfoot>
                            <tr>
                                <cfset perf_result_val = get_perf.perf_result>
                                <cfif get_perf_def.is_stage eq 1 and is_closed neq 1 and ((get_perf_def.is_employee eq 1 and get_emp.employee_id eq session.ep.userid) 
                                    or (get_perf_def.is_upper_position eq 1 and first_boss eq session.ep.position_code) or (get_perf_def.is_upper_position2 eq 1 and second_boss eq session.ep.position_code))> 
                                    <cfif len(comp_perf_result_val) and len(emp_perf_result2_val)>
                                        <cfset perf_result_val = comp_perf_result_val + emp_perf_result2_val> 
                                    <cfelse>
                                        <cfset perf_result_val = ''>
                                    </cfif>
                                </cfif>
                                <cfif get_perf_def.is_stage eq 1 and is_closed neq 1 and get_perf_def.is_employee neq 1 and get_emp.employee_id eq session.ep.userid and ((len(second_boss) and get_perf.valid_5 neq 1) or get_perf.valid_3 neq 1)>
                                    <cfset perf_result_val = 0>
                                </cfif>
                                <td style="text-align:right; padding-right:10px;" class="txtbold" colspan="2">Genel Performans Sonucu : <cfoutput><cfif len(perf_result_val)>#TLFormat(perf_result_val,2)#<cfelse>-</cfif></cfoutput></td>
                            </tr>
                        </tfoot>
                    </cf_flat_list><br />
                </cfif>
                <cf_flat_list>
                    <tbody>
                        <cfif get_perf.is_closed eq 1 or first_boss eq session.ep.position_code or #lcase(listgetat(attributes.fuseaction,1,'.'))# eq 'hr' or (len(second_boss) and ((second_boss eq session.ep.position_code and get_perf.is_closed eq 1) or (second_boss neq session.ep.position_code and get_perf.valid_5 eq 1))) or (not len(second_boss) and len(first_boss) and get_perf.valid_3 eq 1)>
                        
                        <cf_box_elements>
                            <div id="per_uppos_td" class="form-group col col-12 col-md-6 col-sm-6 col-xs-12">
                                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                    <label><cf_get_lang dictionary_id="41591.Genel Performans Değerlendirmesi"> – <cf_get_lang dictionary_id="35927.Birinci Amir"></label>
                                </div>
                                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                    <textarea name="manager1_comment" id="manager1_comment" style="width:100%;" rows="4" <cfif first_boss neq session.ep.position_code>readonly="readonly"</cfif>><cfoutput>#GET_PERF.MANAGER_1_COMMENT#</cfoutput></textarea>
                                </div>
                            </div>
                        </cf_box_elements>
                        <cfelse>
                            <input type="hidden" name="manager1_comment" id="manager1_comment" value="<cfoutput>#get_perf.manager_1_comment#</cfoutput>">
                        </cfif>
                        <cfif len(second_boss) and (get_perf.is_closed eq 1 or second_boss eq session.ep.position_code or #lcase(listgetat(attributes.fuseaction,1,'.'))# eq 'hr' or (second_boss neq session.ep.position_code and get_perf.valid_5 eq 1))>
                        <cf_box_elements>
                            <div id="per_uppos2_td" class="form-group col col-12 col-md-6 col-sm-6 col-xs-12">
                                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                    <label><cf_get_lang dictionary_id="41591.Genel Performans Değerlendirmesi"> – <cf_get_lang dictionary_id="35921.ikinci Amir"></label>
                                </div>
                                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                    <textarea name="manager2_comment" id="manager2_comment" style="width:100%;" rows="4" <cfif second_boss neq session.ep.position_code>readonly="readonly"</cfif>><cfoutput>#GET_PERF.MANAGER_2_COMMENT#</cfoutput></textarea>
                                </div>
                            </div>
                        </cf_box_elements>
                        <cfelse>
                        <input type="hidden" name="manager2_comment" id="manager2_comment" value="<cfoutput>#GET_PERF.MANAGER_2_COMMENT#</cfoutput>">
                        </cfif>
                        <cf_box_elements>
                            <div id="per_uppos2_td" class="form-group col col-12 col-md-6 col-sm-6 col-xs-12">
                                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                    <label><cf_get_lang dictionary_id="41589.ÇALIŞANIN GENEL YORUMU"></label>
                                </div>
                                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                    <textarea name="emp_comment" id="emp_comment" style="width:100%;" rows="4" <cfif get_emp.POSITION_CODE neq session.ep.position_code>readonly="readonly"</cfif>><cfoutput>#GET_PERF.EMPLOYEE_COMMENT#</cfoutput></textarea>
                                </div>
                            </div>
                            <div id="per_uppos2_td" class="form-group col col-12 col-md-6 col-sm-6 col-xs-12">
                                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                    <label><cf_get_lang dictionary_id="41584.GÖRÜŞ BİLDİREN YORUMU"></label>
                                </div>
                                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                    <textarea name="consultant_comment" id="consultant_comment" style="width:100%;" rows="4" <cfif get_emp.chief3_code neq session.ep.position_code>readonly="readonly"</cfif>><cfoutput>#GET_PERF.CONSULTANT_COMMENT#</cfoutput></textarea>
                                </div>
                            </div>
                        </cf_box_elements>
                    </tbody>
                </cf_flat_list>
        </cf_box_elements>
    </div>
    <cf_seperator id="development" title="#getLang('','Gelisim',56459)#">
    <div class="col col-12" id="development">
        <cf_box_elements>
            <cf_flat_list>
                <thead>
                    <tr>
                        <th width="50%"><cf_get_lang dictionary_id="41583.ÇALIŞANIN GÜÇLÜ YÖNLERİ"></th>
                        <th><cf_get_lang dictionary_id="41582.GELİŞTİRİLMESİ GEREKEN YÖNLERİ"></th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><textarea name="powerful_aspects" id="powerful_aspects" style="width:100%;" rows="4" <cfif (second_boss neq session.ep.position_code and first_boss neq session.ep.position_code) or get_emp.POSITION_CODE eq session.ep.position_code>readonly="readonly"</cfif>><cfoutput>#GET_PERF.POWERFUL_ASPECTS#</cfoutput></textarea></td>
                        <td><textarea name="train_need_aspects" id="train_need_aspects" style="width:100%;" rows="4" <cfif (second_boss neq session.ep.position_code and first_boss neq session.ep.position_code) or get_emp.POSITION_CODE eq session.ep.position_code>readonly="readonly"</cfif>><cfoutput>#GET_PERF.TRAIN_NEED_ASPECTS#</cfoutput></textarea></td>
                    </tr>
                </tbody>
            </cf_flat_list>
        </cf_box_elements>
    </div>
    <cf_form_box_footer>
        <cf_get_lang dictionary_id='57483.Kayıt'>:<cfoutput>#get_emp_info(ListLast(GET_PERF.RECORD_KEY,'-'),0,0)# #DateFormat(date_add('h',session.ep.time_zone,GET_PERF.RECORD_DATE),dateformat_style)# #TimeFormat(date_add('h',session.ep.time_zone,GET_PERF.RECORD_DATE),'HH:mm:ss')#</cfoutput>
        <cfif len(GET_PERF.UPDATE_KEY)>
            <cf_get_lang dictionary_id='57703.Güncelleme'>:
            <cfoutput>#get_emp_info(ListLast(GET_PERF.UPDATE_KEY,'-'),0,0)# #DateFormat(date_add('h',session.ep.time_zone,GET_PERF.UPDATE_DATE),dateformat_style)# #TimeFormat(date_add('h',session.ep.time_zone,GET_PERF.UPDATE_DATE),'HH:mm:ss')#</cfoutput>
        </cfif>
        <cfif not (IsDefined('is_closed') and is_closed eq 1)>
            <cfif #lcase(listgetat(attributes.fuseaction,1,'.'))# eq 'myhome'>
                <cf_workcube_buttons type_format="1" is_upd='0' add_function="unformat_fields()">
            <cfelse>
                <cf_workcube_buttons type_format="1" is_upd='1' delete_page_url='#request.self#?fuseaction=hr.emptypopup_del_target_plan&result_id=#get_perf.result_id#&emp_id=#get_perf.emp_id#&all_req_type_id=#yetkinlik_list_all#&finishdate=#dateformat(get_perf.finish_date,dateformat_style)#&startdate=#dateformat(get_perf.start_date,dateformat_style)#&per_id=#attributes.per_id#' add_function="unformat_fields()">
            </cfif>
        </cfif>
    </cf_form_box_footer>
    </cfform>
</cf_box>