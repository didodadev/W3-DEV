<cf_get_lang_set module_name="hr"><!--- sayfanin en altinda kapanisi var --->
<cfquery name="get_perf" datasource="#dsn#">
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
        ST.TITLE,
        PTR.STAGE AS STAGE_NAME
	FROM
		EMPLOYEE_PERFORMANCE_TARGET EPT,
		EMPLOYEE_PERFORMANCE EP 
		LEFT JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = EP.STAGE
        LEFT JOIN DEPARTMENT D ON EP.DEPARTMENT_ID = D.DEPARTMENT_ID
        LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID
        LEFT JOIN OUR_COMPANY OC ON OC.COMP_ID = EP.COMP_ID
        LEFT JOIN BRANCH B ON B.BRANCH_ID = EP.BRANCH_ID
        LEFT JOIN SETUP_TITLE ST ON ST.TITLE_ID = EP.TITLE_ID
	WHERE 
		EPT.PER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#">
		AND EP.PER_ID = EPT.PER_ID
</cfquery>
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
        <cfif not len(get_perf.update_date)>
            LEFT JOIN DEPARTMENT D ON EP.DEPARTMENT_ID = D.DEPARTMENT_ID 
            LEFT JOIN BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
            LEFT JOIN OUR_COMPANY OC ON OC.COMP_ID=B.COMPANY_ID
            LEFT JOIN SETUP_TITLE ST ON ST.TITLE_ID = EP.TITLE_ID
            LEFT JOIN SETUP_POSITION_CAT SPC ON EP.POSITION_CAT_ID = SPC.POSITION_CAT_ID
        </cfif>
	WHERE 
		EP.POSITION_CODE= <cfqueryparam cfsqltype="cf_sql_integer" value="#get_perf.position_code#">
        AND EP.IS_MASTER = 1
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
<cfif not len(get_perf.update_date)>
	<cfif not len(get_perf.ept_upd)>
        <cfquery name="update_boss" datasource="#dsn#">
            UPDATE 
                EMPLOYEE_PERFORMANCE_TARGET 
            SET
            <cfif len(get_emp.upper_position_code)>
                FIRST_BOSS_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp.upper_position_code#">,
            <cfelse>
                FIRST_BOSS_CODE = NULL,
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
        <cfset first_boss=get_emp.upper_position_code>
    	<cfset second_boss=get_emp.upper_position_code2>
   	<cfelse>
    	<cfset first_boss=get_perf.first_boss_code>
    	<cfset second_boss=get_perf.second_boss_code>
    </cfif>
	<cfset emp_dep_id=get_emp.department_id>
    <cfset pos_cat=get_emp.position_cat_id>
    <cfset emp_comp_id=get_emp.comp_id>
    <cfset emp_branch_id=get_emp.branch_id>
    <cfset emp_title_id=get_emp.title_id>
    <cfset emp_func_id=get_emp.func_id>
<cfelse>
	<cfset emp_dep_id=get_perf.department_id>
    <cfset pos_cat=get_perf.position_cat_id>
    <cfset emp_comp_id=get_perf.comp_id>
    <cfset emp_branch_id=get_perf.branch_id>
    <cfset emp_title_id=get_perf.title_id>
    <cfset emp_func_id=get_perf.func_id>
    <cfset first_boss=get_perf.first_boss_code>
    <cfset second_boss=get_perf.second_boss_code>
</cfif>
<cfset emp_org_step_id=get_emp.organization_step_id>
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
	<cfif get_emp_req.recordcount>
    	<cfset yetkinlik_list=valuelist(get_emp_req.req_type_id,',')>
    <cfelse>
    	<cfset yetkinlik_list=0>
    </cfif>
	<cfset yetkinlik_list_all=yetkinlik_list>
    <cfset kocluk_yetkinlik_list=0>
    <cfset dep_yetkinlik_list=0>
    <cfset std_yetkinlik_list=0>
</cfif>
<cfquery name="get_emp_quiz_answers" datasource="#dsn#">
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
        EMPLOYEE_QUIZ_RESULTS_DETAILS.RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_perf.result_id#">
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
    <cfset emp_perf_weight = get_perf_def.employee_perform_weight>
    <cfset req_weight = 100 - emp_perf_weight>
    <cfset comp_target_weight = get_perf_def.comp_target_weight>
    <cfset emp_perf_res = 100 - comp_target_weight>
    <cfset comp_perform_result = get_perf_def.comp_perform_result>
    <cfif get_perf_def.is_stage eq 1 and (second_boss eq session.ep.position_code or get_emp.chief3_code eq session.ep.position_code) and ((get_perf_def.is_employee eq 1 and get_perf.valid_1 neq 1) 
		or (get_emp.chief3_code eq session.ep.position_code and get_perf_def.is_consultant eq 1 and get_perf.valid_2 eq 1) or (second_boss eq session.ep.position_code and ((get_perf_def.is_upper_position2 eq 1 and get_perf.valid_5 eq 1) 
		or (get_perf_def.is_consultant eq 1 and get_perf.valid_2 neq 1) or (get_perf_def.is_upper_position eq 1 and get_perf.valid_3 neq 1) or (get_perf_def.is_mutual_assessment eq 1 and get_perf.valid_4 neq 1))))>
	</cfif>
<cfelse>
    <cfset emp_perf_weight = ''>
    <cfset comp_target_weight = ''>
    <cfset req_weight = ''>
    <cfset emp_perf_res = ''>
    <cfset comp_perform_result = ''>
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
<cfif get_perf.is_closed eq 1><cfset is_closed=1><cfelse><cfset is_closed=0></cfif>
<table align="center">
	<tr>
		<td><h4><cf_get_lang no='1482.HEDEF YETKİNLİK DEĞERLENDİRME'><cf_get_lang_main no='577.ve'><cf_get_lang_main no='272.SONUÇ'></h4></td>
	</tr>
</table>
<cfoutput>
<table align="center">
	<tr>
		<td>
			<table>
				<tr>
					<td>
						<table>
							<tr><td bgcolor="CCCCCC" width="800"><b>Çalışan Hakkında Bilgiler</b></td></tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<table>
							<tr>
								<td width="180"><b><cf_get_lang no='672.Adı Soyadı'> : </b></td>
								<td width="250">#get_emp_info(get_perf.emp_id,0,0)#</td>
								<td width="250"><b><cf_get_lang no='69.İşe Başlama Tarihi'> : </b></td>
								<td width="250">#dateformat(get_emp.start_date, dateformat_style)#</td>
							</tr>
							<tr>
								<td><b><cf_get_lang_main no='41.Şube'> : </b></td>
								<td><cfif len(get_perf.update_date)>#get_perf.branch_name#<cfelse>#get_emp.branch_name#</cfif></td>
								<td><b><cf_get_lang_main no='159.Ünvan'> : </b></td>
								<td><cfif len(get_perf.update_date)>#get_perf.title#<cfelse>#get_emp.title#</cfif></td>
							</tr>
							<tr>
								<td><b><cf_get_lang_main no='160.Departman'> / <cf_get_lang_main no='1592.Pozisyon Tipi'> : </b></td>
								<td><cfif len(get_perf.update_date)>#get_perf.department_head# / #get_perf.position_cat#<cfelse>#get_emp.department_head# / #get_emp.position_cat#</cfif></td>
								<td><b>Değerlendirmeyi Yapan Yönetici (1. Amir) : </b></td>
								<td><cfif len(first_boss)>#get_emp_info(first_boss,1,0)#</cfif></td>
							</tr>
							<tr>
								<td><b><cf_get_lang_main no="1447.Süreç"> : </b></td>
								<td>#get_perf.stage_name#</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<table>
							<tr><td colspan="7" bgcolor="CCCCCC" width="800"><b>Disiplin İşlemleri</b></td></tr>
							<tr bgcolor="CCCCCC">
								<td><b><cf_get_lang_main no='1360.İşlem No'></b></td>
								<td><b><cf_get_lang_main no='68.Konu'></b></td>
								<td><b><cf_get_lang_main no='218.Tip'></b></td>
								<td><b>İşlem Yapılan</b></td>
								<td><b><cf_get_lang_main no='1174.İşlem Yapan'></b></td>
								<td><b><cf_get_lang_main no='467.İşlem Tarihi'></b></td>
								<td><b><cf_get_lang_main no='215.Kayıt Tarihi'></b></td>
							</tr>
							<cfif get_caution.recordcount>
								<cfloop query="get_caution">
									<tr>
	        							<td>#decision_no#</td>
	        							<td>#caution_head#</td>
	        							<td>#caution_type#</td>
	        							<td>#caution_to#</td>
	        							<td>#warner#</td>
	        							<td>#dateformat(caution_date,dateformat_style)#</td>
	        							<td>#dateformat(record_date,dateformat_style)#</td>
	        						</tr>
								</cfloop>
							<cfelse>
	                            <tr>
	                                <td colspan="7">Kişiye Eklenmiş Disiplin İşlemi Kaydı Yok</td>
	                            </tr>
							</cfif>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<table>
							<tr><td colspan="6" bgcolor="CCCCCC" width="800"><b>Ödüller</b></td></tr>
							<tr bgcolor="CCCCCC">
								<td><b>Ödül</b></td>
	        					<td><b>Ödül Tipi</b></td>
	        					<td><b>Ödül Alan</b></td>
	        					<td><b>Ödül Veren</b></td>
	        					<td><b>Veriliş Tarihi</b></td>
	        					<td><b><cf_get_lang_main no='215.Kayıt Tarihi'></b></td>
							</tr>
							<cfif get_prize.recordcount>
								<cfloop query="get_prize">
	        						<tr>
	        							<td>#prize_head#</td>
	        							<td>#prize_type#</td>
	        							<td>#prize_to#</td>
	        							<td>#prize_give_person#</td>
	        							<td>#dateformat(prize_date,dateformat_style)#</td>
	        							<td>#dateformat(record_date,dateformat_style)#</td>
	        						</tr>
	        					</cfloop>
	        				<cfelse>
	                            <tr>
	                                <td colspan="6">Kişiye Eklenmiş Ödül Kaydı Yok</td>
	                            </tr>
							</cfif>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<table>
							<tr>
								<td colspan="7" bgcolor="CCCCCC" width="800"><b><cf_get_lang_main no='552.Hedefler'></b></td>
							</tr>
							<tr bgcolor="CCCCCC">
	                            <td><b><cf_get_lang_main no ='539.Hedef'></b></td>
	                            <td><b><cf_get_lang no ='1384.Hedef Ağırlığı'>(%)</b></td>
	                            <td><b><cf_get_lang_main no ='2008.Yorum'></b></td>
	                            <cfif (get_perf.is_closed neq 1 and get_emp.employee_id neq session.ep.userid) or (get_perf.is_closed eq 1)>
	                            	<td><b><cf_get_lang_main no ='1572.Puan'></b></td>
	                            </cfif>
	                            <td <cfif not (len(get_perf_def.is_stage) and get_perf_def.is_stage eq 1 and get_perf_def.is_employee)>style="display:none;"</cfif>><b>Çalışan Puan</b></td>
	                            <cfif get_perf.is_closed eq 1 or (first_boss eq session.ep.position_code and get_perf.is_closed neq 1) or (not len(second_boss) and get_perf.valid_3 eq 1) or (len(second_boss) and get_perf.valid_5 eq 1)>
	                            	<td width="50" <cfif not (len(get_perf_def.is_stage) and get_perf_def.is_stage eq 1 and get_perf_def.is_upper_position)>style="display:none;"</cfif>><b>1.Amir Puan</b></td>
	                            </cfif>
	                            <cfif len(second_boss) and (get_perf.is_closed eq 1 or (second_boss eq session.ep.position_code and get_perf.is_closed neq 1) or get_perf.valid_5 eq 1)>
	                            	<td width="50" <cfif not (len(get_perf_def.is_stage) and get_perf_def.is_stage eq 1 and get_perf_def.is_upper_position2)>style="display:none;"</cfif>><b>2.Amir Puan</b></td>
	                            </cfif>
	                    	</tr>
	                    	<cfif get_target.recordcount>
	                    		<cfloop query="get_target">
	                    			<tr>
	                    				<td>#target_head#</td>
	                    				<td>#target_weight#</td>
	                    				<td>#perform_comment#</td>
	                    				<cfset target_res_val = target_result>
	                    				<cfif (get_perf.is_closed neq 1 and get_emp.employee_id neq session.ep.userid) or (get_perf.is_closed eq 1)>
	                    					<cfif get_perf_def.is_stage eq 1> 
                                                <cfif get_perf_def.is_employee eq 1 and get_emp.employee_id eq session.ep.userid>
                                                    <cfset target_res_val = emp_target_result>
                                                <cfelseif get_perf_def.is_upper_position eq 1 and first_boss eq session.ep.position_code>
                                                    <cfset target_res_val = upper_position_target_result>
                                                <cfelseif get_perf_def.is_upper_position2 eq 1 and second_boss eq session.ep.position_code>
                                                    <cfset target_res_val = upper_position2_target_result>
                                                </cfif>
                                            </cfif>
	                    					<td>#tlformat(target_res_val,2)#</td>
	                    					<td <cfif not (get_perf_def.is_stage eq 1 and get_perf_def.is_employee eq 1)>style="display:none;"</cfif>>#emp_target_result#</td>
	                    					<cfif get_perf.is_closed eq 1 or (first_boss eq session.ep.position_code and get_perf.is_closed neq 1) or (not len(second_boss) and get_perf.valid_3 eq 1) or (len(second_boss) and get_perf.valid_5 eq 1)>
	                    						<td <cfif not (get_perf_def.is_stage eq 1 and get_perf_def.is_upper_position eq 1)>style="display:none;"</cfif>>#upper_position_target_result#</td>
	                    					</cfif>
	                    					<cfif len(second_boss) and (get_perf.is_closed eq 1 or (second_boss eq session.ep.position_code and get_perf.is_closed neq 1) or get_perf.valid_5 eq 1)>
		                            			<td <cfif not (get_perf_def.is_stage eq 1 and get_perf_def.is_upper_position2 eq 1)>style="display:none;"</cfif>>#upper_position2_target_result#</td>
											</cfif>
	                    				</cfif>
	                    			</tr>
	                    		</cfloop>
	                    	<cfelse>
	                    		<tr>
	                    			<td colspan="7"><cf_get_lang no ='1390.Kişiye Eklenmiş Hedef Kaydı Yok'></td>
	                    		</tr>
	                    	</cfif>
	                    	<tr>
	                    		<cfset target_score_val = get_perf.target_score>
	                    		<cfif get_perf_def.is_stage eq 1 and is_closed neq 1>
	                    			<cfif get_perf_def.is_employee eq 1 and get_emp.employee_id eq session.ep.userid>
	                    				<cfquery name="get_target_emp_score" datasource="#dsn#">
	                                        SELECT 
	                                            SUM(CASE WHEN EMP_TARGET_RESULT IS NULL THEN 0 ELSE EMP_TARGET_RESULT END * #get_perf_def.employee_weight# / 100 * TARGET_WEIGHT / 100) AS EMP_SCORE 
	                                        FROM 
	                                            TARGET 
	                                        WHERE
	                                            EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_perf.emp_id#"> 
	                                            AND YEAR(FINISHDATE) = #dateformat(get_perf.finish_date, 'yyyy')# 
	                                            AND YEAR(STARTDATE) = #dateformat(get_perf.start_date, 'yyyy')#
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
	                                            EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_perf.emp_id#"> 
	                                            AND YEAR(FINISHDATE) = #dateformat(get_perf.finish_date, 'yyyy')# 
	                                            AND YEAR(STARTDATE) = #dateformat(get_perf.start_date, 'yyyy')#
	                                    </cfquery>
	                                    <cfif get_target_uppos_score.recordcount><cfset target_score_val = get_target_uppos_score.uppos_score><cfelse><cfset target_score_val = ''></cfif>
	                            	<cfelseif get_perf_def.is_upper_position2 eq 1 and second_boss eq session.ep.position_code>
	                            		<cfquery name="get_target_uppos2_score" datasource="#dsn#">
	                                        SELECT 
	                                            SUM(CASE WHEN UPPER_POSITION2_TARGET_RESULT IS NULL THEN 0 ELSE UPPER_POSITION2_TARGET_RESULT END * #get_perf_def.upper_position2_weight# / 100 * TARGET_WEIGHT / 100) AS UPPOS2_SCORE 
	                                        FROM 
	                                            TARGET 
	                                        WHERE
	                                            EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PERF.EMP_ID#"> 
	                                            AND YEAR(FINISHDATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#dateformat(get_perf.finish_date, 'yyyy')#"> 
	                                            AND YEAR(STARTDATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#dateformat(get_perf.start_date, 'yyyy')#">
	                                    </cfquery>
	                                    <cfif get_target_uppos2_score.recordcount><cfset target_score_val = get_target_uppos2_score.uppos2_score><cfelse><cfset target_score_val = ''></cfif>
	                              	<cfelseif get_perf_def.is_employee neq 1 and get_emp.employee_id eq session.ep.userid and ((len(second_boss) and get_perf.valid_5 neq 1) or get_perf.valid_3 neq 1)>
	                              		<cfset target_score_val = 0>
	                    			</cfif>
	                    		</cfif>
	                    		<td bgcolor="CCCCCC" colspan="7" style="text-align:right; padding-right:10px;"><b>Hedefler Sonuç Değerlendirme Puanı : #tlformat(target_score_val,2)#</b></td>
	                    	</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<table>
							<tr>
								<td colspan="7" bgcolor="CCCCCC" width="800"><b><cf_get_lang_main no='1297.Yetkinlikler'></b></td>
							</tr>
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
			                <cfif get_quiz_chapters.recordcount>
			                	<cfloop query="get_quiz_chapters">
			                		<cfset answer_number_gelen = get_quiz_chapters.answer_number>
			                		<cfset attributes.chapter_id = chapter_id>
			                		<cfquery name="chapter_exp_#get_quiz_chapters.currentrow#" datasource="#dsn#">
			                            SELECT EXPLANATION,MANAGER_EXPLANATION FROM EMPLOYEE_QUIZ_CHAPTER_EXPL WHERE CHAPTER_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#chapter_id#"> AND RESULT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#get_perf.result_id#">
			                        </cfquery>
			                        <cfscript>
			                            for (i=1; i lte answer_number_gelen; i = i+1)
			                            {
			                                "a#i#" = evaluate("get_quiz_chapters.answer#i#_text");
			                                "b#i#" = evaluate("get_quiz_chapters.answer#i#_photo");
			                                "c#i#" = evaluate("get_quiz_chapters.answer#i#_point");
			                            }
			                        </cfscript>
			                        <tr>
			                        	<td colspan="7" bgcolor="CCCCCC" width="800"><b>Yetkinlik #get_quiz_chapters.currentrow#: #chapter#</b></td>
			                        </tr>
			                        <tr>
			                        	<td>
			                        		<table cellpadding="0" cellspacing="0" width="100%">
			                        			<cfif len(chapter_info)>
			                        				<tr><td> #chapter_info# </td></tr>
			                        			</cfif>
			                        			<cfquery name="GET_QUIZ_QUESTIONS" datasource="#dsn#">
					                                SELECT 
					                                   	QUESTION,
									   					QUESTION_ID,
					                                    OPEN_ENDED,
					                                    QUESTION_INFO
					                                FROM 
					                                    EMPLOYEE_QUIZ_QUESTION
					                                WHERE
					                                    CHAPTER_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.chapter_id#">
					                            </cfquery>
					                            <cfif get_quiz_questions.recordcount>
					                            	<tr>
					                            		<td>
					                            			<table cellpadding="5" cellspacing="5" width="100%">
					                            				<tr>
					                            					<td width="500">&nbsp;</td>
					                            					<cfloop from="1" to="20" index="i">
					                            						<cfif len(evaluate("get_quiz_chapters.answer#i#_photo")) or len(evaluate("get_quiz_chapters.answer#i#_text"))>
					                            							<td style="text-align:center;"><b>
					                            								<cfif len(evaluate("get_quiz_chapters.answer"&i&"_photo"))>
					                            									<cf_get_server_file output_file="hr/#evaluate("answer"&i&"_photo")#" output_server="#evaluate("answer"&i&"_photo_server_id")#" output_type="0" image_link="1">
					                            								</cfif>
					                            								#evaluate('get_quiz_chapters.answer#i#_text')#&nbsp;
					                            							</b></td>
					                            						</cfif>
					                            					</cfloop>
					                            					<cfif get_quiz_chapters.currentrow neq temp2>
					                            						<td valign="top" style="padding-top:10px; border-left:1px solid ##ccc; <cfif not (get_perf_def.is_stage eq 1 and get_perf_def.is_employee eq 1)>display:none;</cfif>" width="120">
					                                                        <b>Çalışan Puan</b>
					                                                    </td>
					                                                    <cfif get_perf.is_closed eq 1 or (first_boss eq session.ep.position_code and get_perf.is_closed neq 1) or (not len(second_boss) and get_perf.valid_3 eq 1) or (len(second_boss) and get_perf.valid_5 eq 1)>
																			<td valign="top" style="padding-top:10px; border-left:1px solid ##ccc; <cfif not (get_perf_def.is_stage eq 1 and get_perf_def.is_upper_position eq 1)>display:none;</cfif>" width="120">
						                                                    	<b>1.Amir Puan</b>
						                                                    </td>
																		</cfif>
																		<cfif len(second_boss) and (get_perf.is_closed eq 1 or (second_boss eq session.ep.position_code and get_perf.is_closed neq 1) or fusebox.circuit eq 'hr' or get_perf.valid_5 eq 1)>
						                                                    <td valign="top" style="padding-top:10px; border-left:1px solid ##ccc; <cfif not (get_perf_def.is_stage eq 1 and get_perf_def.is_upper_position2 eq 1)>display:none;</cfif>" width="120">
						                                                    	<b>2.Amir Puan</b>
						                                                    </td>
																		</cfif>
																		<cfset temp2 = get_quiz_chapters.currentrow>
					                            					</cfif>
					                            				</tr>
					                            				<!--- Sorular basliyor --->
					                            				<cfloop query="get_quiz_questions">
					                            					<cfset q_id = get_quiz_questions.question_id>
					                            					<tr>
					                            						<td valign="top">
					                            							#get_quiz_questions.question#
					                            							<cfif open_ended eq 1>
					                            								<table cellpadding="4" cellspacing="4">
					                            									<tr>
					                            										<cfif (len(second_boss) and ((second_boss eq session.ep.position_code and get_perf.is_closed eq 1) or (second_boss neq session.ep.position_code and get_perf.valid_5 eq 1))) or (not len(second_boss) and len(first_boss) and get_perf.valid_3 eq 1) or get_perf.is_closed eq 1 or first_boss eq session.ep.position_code>
					                            											<td valign="top" nowrap><cf_get_lang_main no='217.Acıklama'></td>
					                            											<td>#evaluate("chapter_exp_#get_quiz_chapters.currentrow#.explanation")#</td>
					                            										</cfif>
					                            									</tr>
					                            								</table>
					                            							</cfif>
					                            						</td>
					                            						<cfif answer_number_gelen neq 0>
					                            							<cfloop from="1" to="#answer_number_gelen#" index="i">
					                            								<cfif len(evaluate("b#i#")) or len(evaluate("a#i#"))>
					                            									<td style="text-align:center;" valign="top">
					                            										<input type="radio" disabled="disabled" value="#i#" 
					                            											<cfloop query="get_emp_quiz_answers">
					                            												<cfif isdefined("get_emp_quiz_answers") and isdefined("get_emp_quiz_answers.result_id") and get_emp_quiz_answers.question_id is q_id>
					                            													<cfif get_perf_def.is_stage eq 1>
					                            														<cfif get_perf_def.is_employee eq 1 and get_emp.employee_id eq session.ep.userid and get_emp_quiz_answers.question_employee_answers is i>
					                            															checked
					                            														<cfelseif get_perf_def.is_upper_position eq 1 and first_boss eq session.ep.position_code and get_emp_quiz_answers.question_upper_position_answers is i>
					                            															checked
					                            														<cfelseif get_perf_def.is_upper_position2 eq 1 and second_boss eq session.ep.position_code and get_emp_quiz_answers.question_upper_position2_answers is i>
					                            															checked
					                            														<cfelseif get_emp_quiz_answers.question_user_answers is i>
					                            															checked
					                            														</cfif>
					                            													<cfelseif get_emp_quiz_answers.question_user_answers is i>
					                            														checked
					                            													</cfif>
					                            												</cfif>
					                            												<cfif isdefined("get_emp_quiz_answers") and isdefined("get_emp_quiz_answers.result_id") and get_emp_quiz_answers.question_id is q_id>
					                            													<cfif get_emp_quiz_answers.question_employee_answers is i>
					                            														<cfset "sonuc1_#get_emp_quiz_answers.question_id#" = evaluate('c#i#')>
					                            														<cfset empanswer = get_emp_quiz_answers.question_employee_answers>
					                            													</cfif>
					                            													<cfif get_emp_quiz_answers.question_upper_position_answers is i>
					                            														<cfset 'sonuc2_#get_emp_quiz_answers.question_id#' = evaluate('c#i#')>
					                            														<cfset upposanswer = get_emp_quiz_answers.question_upper_position_answers>
					                            													</cfif>
					                            													<cfif get_emp_quiz_answers.question_upper_position2_answers is i>
					                            														<cfset "sonuc3_#get_emp_quiz_answers.question_id#" = evaluate('c#i#')>
					                            														<cfset uppos2answer = get_emp_quiz_answers.question_upper_position2_answers>
					                            													</cfif>
					                            												</cfif>
					                            											</cfloop>
					                            										>
					                            									</td>
					                            								</cfif>
					                            							</cfloop>
					                            							<td valign="top" style="text-align:center; <cfif not (get_perf_def.is_stage eq 1 and get_perf_def.is_employee eq 1)>display:none;</cfif>" width="60"><cfif isdefined('sonuc1_#get_quiz_questions.question_id#')>#evaluate('sonuc1_#get_quiz_questions.question_id#')#</cfif></td>
					                            							<cfif get_perf.is_closed eq 1 or (first_boss eq session.ep.position_code and get_perf.is_closed neq 1) or (not len(second_boss) and get_perf.valid_3 eq 1) or (len(second_boss) and get_perf.valid_5 eq 1)>
																		    	<td valign="top" style="text-align:center; <cfif not (get_perf_def.is_stage eq 1 and get_perf_def.is_upper_position eq 1)>display:none;</cfif>" width="60"><cfif isdefined('sonuc2_#get_quiz_questions.question_id#')>#evaluate('sonuc2_#get_quiz_questions.question_id#')#</cfif></td>
					                                                      	</cfif>
					                                                      	<cfif len(second_boss) and (get_perf.is_closed eq 1 or (second_boss eq session.ep.position_code and get_perf.is_closed neq 1) or get_perf.valid_5 eq 1)>
																		    	<td valign="top" style="text-align:center; <cfif not (get_perf_def.is_stage eq 1 and get_perf_def.is_upper_position2 eq 1)>display:none;</cfif>" width="60"><cfif isdefined('sonuc3_#get_quiz_questions.question_id#')>#evaluate('sonuc3_#get_quiz_questions.question_id#')#</cfif></td>
					                                                   		</cfif>
					                                                   	</tr>
					                                                   	<cfelse>
						                                                   		<td style="text-align:right;"> </td>
						                                                   		<td style="text-align:right;"> </td>
						                                                   	</tr>
						                                                   	<cfloop from="1" to="#answer_number_gelen#" index="i">
						                                                   		<cfif len(evaluate("get_quiz_questions.answer#i#_photo")) or len(evaluate("get_quiz_questions.answer#i#_text"))>
						                                                   			<tr>
						                                                   				<td></td>
						                                                   				<td>
						                                                   					<input type="radio" value="#i#" disabled="disabled">
						                                                   						<cfif len(evaluate("answer"&i&"_photo"))>
						                                                   							<cf_get_server_file output_file="hr/#evaluate("get_quiz_questions.answer"&i&"_photo")#" output_server="#evaluate("get_quiz_questions.answer"&i&"_photo_server_id")#" output_type="0" image_link="1">
						                                                   						</cfif>
						                                                   						#evaluate('get_quiz_questions.answer#i#_text')#
						                                                   				</td>
						                                                   				<td> </td>
						                                                   				<td> </td>
						                                                   			</tr>
						                                                   		</cfif>
						                                                   	</cfloop>
					                            						</cfif>
					                            						<cfif len(question_info) and ((len(second_boss) and ((second_boss eq session.ep.position_code and get_perf.is_closed eq 1) or (second_boss neq session.ep.position_code and get_perf.valid_5 eq 1))) or (not len(second_boss) and len(first_boss) and get_perf.valid_3 eq 1) or get_perf.is_closed eq 1 or first_boss eq session.ep.position_code)>
					                            							<tr>
					                            								<td> #get_quiz_questions.question_info#</td>
					                            							</tr>
					                            						</cfif>
					                            				</cfloop>
					                            			</table>
					                            		</td>
					                            	</tr>
					                            <cfelse>
					                            	<tr>
					                            		<td><cf_get_lang no='744.Kayıtlı Soru Bulunamadı!'></td>
					                            	</tr>
					                            </cfif>
			                        		</table>
			                        	</td>
			                        </tr>
			                	</cfloop>
			                <cfelse>
			                	<tr>
		                            <td><cf_get_lang no='745.Kayıtlı Bölüm Bulunamadı!'></td>
		                        </tr>
			                </cfif>
			                <tr>
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
									<cfif get_perf_def.is_upper_position2 eq 1 and len(second_boss)><cfset upper_pos_weight = get_perf_def.upper_position_weight>
									<cfelseif get_perf_def.is_upper_position2 eq 1 and not len(second_boss)><cfset upper_pos_weight = get_perf_def.upper_position_weight + get_perf_def.upper_position2_weight>
									<cfelse><cfset upper_pos_weight = 100></cfif>
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
	                            <td bgcolor="CCCCCC" style="text-align:right; padding-right:10px;">
	                            	<b>Yetkinlikler Sonuç Değerlendirme Puanı : #TLFormat(req_type_score_val)#</b>
	                            </td>
			                </tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<table>
							<tr>
								<td colspan="2" bgcolor="CCCCCC" width="800"><b><cf_get_lang_main no='272.Sonuc'></b></td>
							</tr>
							<tr bgcolor="CCCCCC">
								<td></td>
								<td style="text-align:center;"><b>Bireysel Performans Değerlendirme</b></td>
							</tr>
							<tr>
								<td>Bireysel Hedefler Puanı (% #emp_perf_weight#)</td>
								<cfset emp_target_result_val = get_perf.emp_target_result>
								<cfif get_perf_def.is_stage eq 1 and is_closed neq 1 and ((get_perf_def.is_employee eq 1 and get_emp.employee_id eq session.ep.userid) or (get_perf_def.is_upper_position eq 1 and first_boss eq session.ep.position_code) or (get_perf_def.is_upper_position2 eq 1 and second_boss eq session.ep.position_code))> 
									<cfif len(target_score_val) and len(emp_perf_weight)>
										<cfset emp_target_result_val = target_score_val * emp_perf_weight / 100> 
	                               	<cfelse>
	                                	<cfset emp_target_result_val = ''>
	                                </cfif>
								</cfif>
								<cfif get_perf_def.is_stage eq 1 and is_closed neq 1 and get_perf_def.is_employee neq 1 and get_emp.employee_id eq session.ep.userid and ((len(second_boss) and get_perf.valid_5 neq 1) or get_perf.valid_3 neq 1)>
									<cfset emp_target_result_val = 0>
	                            </cfif>
	                            <td style="text-align:center;"><cfif len(emp_target_result_val)>#TLFormat(emp_target_result_val,2)#<cfelse>-</cfif></td>
							</tr>
							<tr>
								<td>Yetkinlik Değerlendirme Puanı (% #req_weight#)</td>
								<cfif len(req_type_score_val) and len(req_weight)>
	                            	<cfset emp_req_type_result_val = req_type_score_val * req_weight / 100>
	                            <cfelse>
	                            	<cfset emp_req_type_result_val = 0>
	                            </cfif>
	                            <td style="text-align:center;"><cfif len(emp_req_type_result_val)>#TLFormat(emp_req_type_result_val,2)#<cfelse>-</cfif></td>
							</tr>
							<tr bgcolor="CCCCCC">
								<cfif len(emp_req_type_result_val) and len(emp_target_result_val)>
									<cfset emp_perf_result_val = emp_req_type_result_val + emp_target_result_val>
								<cfelseif len(emp_req_type_result_val) and not len(emp_target_result_val)>
									<cfset emp_perf_result_val = emp_req_type_result_val + 0>
								<cfelseif not len(emp_req_type_result_val) and len(emp_target_result_val)>
									<cfset emp_perf_result_val = 0 + emp_target_result_val>
								</cfif>
								<td style="text-align:right; padding-right:10px;" colspan="2"><b>Bireysel Performans Sonucu : <cfif len(emp_perf_result_val)>#TLFormat(emp_perf_result_val,2)#<cfelse>-</cfif></b></td>
							</tr>
							<cfif len(comp_perform_result) and len(comp_target_weight)>
								<tr><td>&nbsp;</td></tr>
								<tr bgcolor="CCCCCC">
									<td></td>
									<td style="text-align:center;"><b>Genel Performans Değerlendirme</b></td>
								</tr>
								<tr>
									<td>Bireysel Performans Sonucu (% #emp_perf_res#)</td>
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
	                                <td style="text-align:center;"><cfif len(emp_perf_result2_val)>#TLFormat(emp_perf_result2_val,2)#<cfelse>-</cfif></td>
								</tr>
								<tr>
									<td>Şirket Performans Sonucu (% #comp_target_weight#)</td>
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
                                	<td style="text-align:center;"><cfif len(comp_perf_result_val)>#TLFormat(comp_perf_result_val,2)#<cfelse>-</cfif></td>
								</tr>
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
	                                <td bgcolor="CCCCCC" style="text-align:right; padding-right:10px;" colspan="2"><b>Genel Performans Sonucu : <cfif len(perf_result_val)>#TLFormat(perf_result_val,2)#<cfelse>-</cfif></b></td>
								</tr>
								<tr><td>&nbsp;</td></tr>
							</cfif>
							<cfif get_perf.is_closed eq 1 or first_boss eq session.ep.position_code or (len(second_boss) and ((second_boss eq session.ep.position_code and get_perf.is_closed eq 1) or (second_boss neq session.ep.position_code and get_perf.valid_5 eq 1))) or (not len(second_boss) and len(first_boss) and get_perf.valid_3 eq 1)>
								<tr>
		                            <td valign="top">GENEL PERFORMANS DEĞERLENDİRMESİ – 1. Amir</td>
		                            <td>#get_perf.manager_1_comment#</td>
		                        </tr>
							</cfif>
							<cfif len(second_boss) and (get_perf.is_closed eq 1 or second_boss eq session.ep.position_code or (second_boss neq session.ep.position_code and get_perf.valid_5 eq 1))>
								<tr>
		                            <td valign="top">GENEL PERFORMANS DEĞERLENDİRMESİ – 2. Amir</td>
		                            <td>#get_perf.manager_2_comment#</td>
		                        </tr>
							</cfif>
							<tr>
	                            <td valign="top">ÇALIŞANIN GENEL YORUMU</td>
	                            <td>#get_perf.employee_comment#</td>
	                        </tr>
	                        <tr>
	                            <td valign="top">GÖRÜŞ BİLDİREN YORUMU</td>
	                            <td>#get_perf.consultant_comment#</td>
	                        </tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<table>
							<tr>
								<td colspan="2" bgcolor="CCCCCC" width="800"><b><cf_get_lang no='1374.Gelisim'></b></td>
							</tr>
							<tr bgcolor="CCCCCC">
	                            <td><b>ÇALIŞANIN GÜÇLÜ YÖNLERİ</b></td>
	                            <td><b>GELİŞTİRİLMESİ GEREKEN YÖNLERİ</b></td>
	                        </tr>
	                        <tr>
	                            <td>#get_perf.powerful_aspects#</td>
	                            <td>#get_perf.train_need_aspects#</td>
	                        </tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</cfoutput>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
