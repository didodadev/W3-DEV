<cfquery name="get_attenders_joined_training" datasource="#dsn#">
    SELECT
        TGCA.*,
        TC.*
    FROM
        TRAINING_GROUP_CLASS_ATTENDANCE TGCA
            INNER JOIN TRAINING_CLASS TC ON TC.CLASS_ID = TGCA.CLASS_ID
    WHERE
        EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMP_ID#">
        AND STATUS = 1
        AND (JOINED = 1 OR JOINED = 3)
</cfquery>
<cfquery name="get_emp_finalized_trainings" datasource="#dsn#">
    SELECT
        TGA.*,
        TGCA.*,
        TC.*
    FROM
        TRAINING_GROUP_ATTENDERS TGA
            INNER JOIN TRAINING_GROUP_CLASS_ATTENDANCE TGCA ON TGCA.TRAINING_GROUP_ATTENDERS_ID = TGA.TRAINING_GROUP_ATTENDERS_ID
            INNER JOIN TRAINING_CLASS TC ON TC.CLASS_ID = TGCA.CLASS_ID
    WHERE
        TGA.EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMP_ID#">
        AND TGA.JOIN_STATU = 1
        AND TGCA.JOINED = 0
</cfquery>
<cfquery name="get_position_cat" datasource="#DSN#">
	SELECT
		EP.POSITION_CAT_ID, 
		EP.DEPARTMENT_ID, 
		EP.EMPLOYEE_NAME, 
		EP.EMPLOYEE_SURNAME,
		EP.POSITION_NAME,
        EP.FUNC_ID,
        EP.ORGANIZATION_STEP_ID,
		D.DEPARTMENT_HEAD,
		B.BRANCH_NAME,
        B.COMPANY_ID,
        B.BRANCH_ID
	FROM
		EMPLOYEE_POSITIONS EP,
		DEPARTMENT D,
		BRANCH B
	WHERE
		EP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMP_ID#"> AND
		EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND
		D.BRANCH_ID = B.BRANCH_ID 
</cfquery>
<cfset pos_cat=get_position_cat.POSITION_CAT_ID>
<cfset EMP_DEP_ID=get_position_cat.DEPARTMENT_ID>
<cfset emp_comp_id=get_position_cat.COMPANY_ID>
<cfset emp_func_id=get_position_cat.FUNC_ID>
<cfset emp_org_step_id=get_position_cat.ORGANIZATION_STEP_ID>
<cfset emp_branch_id=get_position_cat.BRANCH_ID>
<cfquery name="get_edus" datasource="#DSN#">
	SELECT
		LUCK_TRAIN_SUBJECT_1,
		LUCK_TRAIN_SUBJECT_2,
		LUCK_TRAIN_SUBJECT_3,
		LUCK_TRAIN_SUBJECT_4
	FROM
		EMPLOYEE_TOTAL_PERFORMANCE
	WHERE
		EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMP_ID#">
</cfquery>
<cfquery name="get_tra_dep" datasource="#DSN#">
	SELECT
	 DISTINCT	
		TC.CLASS_NAME,
		TC.CLASS_PLACE,
		TC.DATE_NO,
		TC.HOUR_NO,
		TC.START_DATE,
		TC.FINISH_DATE,
		TC.CLASS_ID,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#"> AS EMP_ID		
	FROM
		TRAINING_CLASS TC
	WHERE
		TC.CLASS_ID IN 
		(
		SELECT DISTINCT
			CLASS_ID 
		FROM 
			TRAINING_CLASS_ATTENDANCE 
		WHERE 
			CLASS_ATTENDANCE_ID IN 
			(
			SELECT DISTINCT
				CLASS_ATTENDANCE_ID 
			FROM 
				TRAINING_CLASS_ATTENDANCE_DT 
			WHERE 
				EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#"> AND
				IS_TRAINER = 0
			)
		)
</cfquery>
<cfset class_list = valuelist(get_tra_dep.CLASS_ID)>
<cfquery name="get_trains" datasource="#DSN#">
	SELECT DISTINCT
		TC.START_DATE,
		TC.FINISH_DATE,
		2 AS D_TYPE,
		TC.CLASS_NAME,
		TC.CLASS_PLACE,
		TC.DATE_NO,
		TC.HOUR_NO
	FROM
		TRAINING_CLASS_ATTENDER TCA,
		TRAINING_CLASS TC 
	WHERE
		TC.CLASS_ID = TCA.CLASS_ID
	<cfif len(class_list)>
		AND
		TC.CLASS_ID NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#class_list#">)
	</cfif>	    
	AND
		TCA.EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMP_ID#">
</cfquery>
<cfquery name="get_next_trains" datasource="#DSN#">
	SELECT DISTINCT
		TC.START_DATE,
		TC.FINISH_DATE,
		2 AS D_TYPE,
		TC.CLASS_NAME,
		TC.CLASS_PLACE,
		TC.CLASS_ID,
		TC.DATE_NO,
		TC.HOUR_NO
	FROM
		TRAINING_CLASS TC, 
		TRAINING T
	WHERE
		T.TRAIN_POSITION_CATS LIKE '%,#pos_cat#,%'
		AND
	    TC.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">
</cfquery>
<cfset tra_2_list=valuelist(get_next_trains.CLASS_ID)>
<cfquery name="get_tra_pos" datasource="#DSN#">
	SELECT
		DISTINCT
		T.TRAIN_ID,
		T.TRAIN_HEAD,
		TC.START_DATE,
		TC.FINISH_DATE,
		2 AS D_TYPE,
		TC.CLASS_NAME,
		TC.CLASS_PLACE,
		TC.DATE_NO,
		TC.HOUR_NO,
		TCS.TRAINING_SEC_ID	
	FROM
		TRAINING_CLASS TC ,
		TRAINING T,
		TRAINING_CLASS_SECTIONS TCS
	WHERE
		TCS.CLASS_ID = TC.CLASS_ID
		AND TCS.TRAIN_ID = T.TRAIN_ID
		AND T.TRAIN_DEPARTMENTS LIKE '%,#EMP_DEP_ID#,%'
		AND TC.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">
		AND TC.CLASS_NAME <> ''
</cfquery>
<cfset tra_3_list=valuelist(get_tra_pos.TRAIN_ID)>
<cfquery name="get_tra_subjects" datasource="#DSN#">
	SELECT 
    	T1.TRAIN_ID, 
        T1.TRAIN_HEAD, 
        TC.TRAINING_CAT, 
        TS.SECTION_NAME, 
        STS.TRAINING_STYLE 
 	FROM(
		SELECT 
       		*,
       		ISNULL((SELECT TOP 1 RELATION_FIELD_ID FROM RELATION_SEGMENT_TRAINING WHERE RELATION_ACTION = 1 AND RELATION_FIELD_ID = TRAINING.TRAIN_ID),0) AS IS_COMPANY,
       		(SELECT DISTINCT RELATION_ACTION_ID FROM RELATION_SEGMENT_TRAINING WHERE RELATION_ACTION = 1 AND RELATION_FIELD_ID = TRAINING.TRAIN_ID AND RELATION_ACTION_ID = <cfif len(emp_comp_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#emp_comp_id#"><cfelse>NULL</cfif>) AS COMPANY_ID,
      	 	ISNULL((SELECT TOP 1 RELATION_FIELD_ID FROM RELATION_SEGMENT_TRAINING WHERE RELATION_ACTION = 2 AND RELATION_FIELD_ID = TRAINING.TRAIN_ID),0) AS IS_DEPARTMENT,
       		(SELECT DISTINCT RELATION_ACTION_ID FROM RELATION_SEGMENT_TRAINING WHERE RELATION_ACTION = 2 AND RELATION_FIELD_ID = TRAINING.TRAIN_ID AND RELATION_ACTION_ID = <cfif len(EMP_DEP_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#emp_dep_id#"><cfelse>NULL</cfif>) AS DEPARTMENT_ID,
	   		ISNULL((SELECT TOP 1 RELATION_FIELD_ID FROM RELATION_SEGMENT_TRAINING WHERE RELATION_ACTION = 3 AND RELATION_FIELD_ID = TRAINING.TRAIN_ID),0) AS IS_POS_CAT,
       		(SELECT DISTINCT RELATION_ACTION_ID FROM RELATION_SEGMENT_TRAINING WHERE RELATION_ACTION = 3 AND RELATION_FIELD_ID = TRAINING.TRAIN_ID AND RELATION_ACTION_ID = <cfif len(pos_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#pos_cat#"><cfelse>NULL</cfif>) AS POS_CAT_ID,
	   		ISNULL((SELECT TOP 1 RELATION_FIELD_ID FROM RELATION_SEGMENT_TRAINING WHERE RELATION_ACTION = 5 AND RELATION_FIELD_ID = TRAINING.TRAIN_ID),0) AS IS_FUNC,
       		(SELECT DISTINCT RELATION_ACTION_ID FROM RELATION_SEGMENT_TRAINING WHERE RELATION_ACTION = 5 AND RELATION_FIELD_ID = TRAINING.TRAIN_ID AND RELATION_ACTION_ID = <cfif len(emp_func_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#emp_func_id#"><cfelse>NULL</cfif>) AS FUNC_ID,
	   		ISNULL((SELECT TOP 1 RELATION_FIELD_ID FROM RELATION_SEGMENT_TRAINING WHERE RELATION_ACTION = 6 AND RELATION_FIELD_ID = TRAINING.TRAIN_ID),0) AS IS_ORG_STEP,
       		(SELECT DISTINCT RELATION_ACTION_ID FROM RELATION_SEGMENT_TRAINING WHERE RELATION_ACTION = 6 AND RELATION_FIELD_ID = TRAINING.TRAIN_ID AND RELATION_ACTION_ID = <cfif len(emp_org_step_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#emp_org_step_id#"><cfelse>NULL</cfif>) AS ORG_STEP_ID,
       		ISNULL((SELECT TOP 1 RELATION_FIELD_ID FROM RELATION_SEGMENT_TRAINING WHERE RELATION_ACTION = 7 AND RELATION_FIELD_ID = TRAINING.TRAIN_ID),0) AS IS_BRANCH,
       		(SELECT DISTINCT RELATION_ACTION_ID FROM RELATION_SEGMENT_TRAINING WHERE RELATION_ACTION = 7 AND RELATION_FIELD_ID = TRAINING.TRAIN_ID AND RELATION_ACTION_ID = <cfif len(emp_branch_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#emp_branch_id#"><cfelse>NULL</cfif>) AS BRANCH_ID
		FROM 
       		TRAINING
	) T1 
    	LEFT JOIN TRAINING_CAT AS TC ON T1.TRAINING_CAT_ID = TC.TRAINING_CAT_ID 
        LEFT JOIN TRAINING_SEC AS TS ON T1.TRAINING_SEC_ID = TS.TRAINING_SEC_ID 
        LEFT JOIN SETUP_TRAINING_STYLE AS STS ON T1.TRAINING_STYLE = STS.TRAINING_STYLE_ID
	WHERE		
       	(IS_COMPANY > 0 OR IS_BRANCH > 0 OR IS_DEPARTMENT > 0 OR IS_POS_CAT > 0 OR IS_FUNC > 0  OR IS_ORG_STEP > 0)
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
       )
   	ORDER BY TRAIN_HEAD
</cfquery>

