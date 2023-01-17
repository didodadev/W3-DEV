<cfquery name="GET_CLASSES" datasource="#DSN#">
SELECT 
	* 
FROM 
	TRAINING_CLASS TC, 
	TRAINING_CLASS_ATTENDER TCA 
WHERE
	TC.CLASS_ID IS NOT NULL AND
	TC.CLASS_ID = TCA.CLASS_ID AND 
	TCA.EMP_ID = #session.ep.userid# 
</cfquery>
<cfset class_list = valuelist(get_classes.CLASS_ID)>
	<cfquery name="get_emp_det" datasource="#dsn#">
		SELECT
			OC.COMP_ID,
			B.BRANCH_ID,
			D.DEPARTMENT_ID,
			EP.FUNC_ID,
			EP.POSITION_CAT_ID,
			EP.ORGANIZATION_STEP_ID
		FROM
			EMPLOYEE_POSITIONS EP,
			OUR_COMPANY OC,
			BRANCH B,
			DEPARTMENT D
		WHERE
	        <cfif attributes.fuseaction contains "popup">
			<!--- Query fuseaction'a gore tanimlanmis. Asagida ise tek tek isdefined kontrolu yapmamak icin degistirdim.. --->
          	  1 = 0 AND
            </cfif>
			OC.COMP_ID = B.COMPANY_ID AND
			B.BRANCH_ID = D.BRANCH_ID AND
			D.DEPARTMENT_ID = EP.DEPARTMENT_ID AND
			EP.EMPLOYEE_ID = #session.ep.userid# AND
			EP.IS_MASTER = 1
	</cfquery>
	<cfquery name="get_train_id" datasource="#DSN#">
        SELECT
            RELATION_FIELD_ID
        FROM
            RELATION_SEGMENT_TRAINING
       <cfif get_emp_det.recordcount>
        WHERE
        	
            <cfif len(get_emp_det.COMP_ID)>
            (
                RELATION_ACTION = 1 AND
                RELATION_ACTION_ID = #get_emp_det.COMP_ID#
            ) OR
            </cfif>
            <cfif len(get_emp_det.DEPARTMENT_ID)>
            (
                RELATION_ACTION = 2 AND
                RELATION_ACTION_ID = #get_emp_det.DEPARTMENT_ID#
            ) OR
            </cfif>
            <cfif len(get_emp_det.POSITION_CAT_ID)>
            (
                RELATION_ACTION = 3 AND
                RELATION_ACTION_ID = #get_emp_det.POSITION_CAT_ID#
            ) OR
            </cfif>
            <cfif len(get_emp_det.FUNC_ID)>
            (
                RELATION_ACTION = 5 AND
                RELATION_ACTION_ID = #get_emp_det.FUNC_ID#
            ) OR
            </cfif>
            <cfif len(get_emp_det.ORGANIZATION_STEP_ID)>
            (
                RELATION_ACTION = 6 AND
                RELATION_ACTION_ID = #get_emp_det.ORGANIZATION_STEP_ID#
            ) OR
            </cfif>
            <cfif len(get_emp_det.BRANCH_ID)>
            (
                RELATION_ACTION = 7 AND
                RELATION_ACTION_ID = #get_emp_det.BRANCH_ID#
            )
            </cfif>
        </cfif>
    </cfquery>
<cfset train_id_list = valuelist(get_train_id.RELATION_FIELD_ID)>
<cfquery name="GET_TRAININGS" datasource="#dsn#">
	SELECT 
		TRAINING.TRAIN_ID, 
		<cfif database_type is 'MSSQL'>
			CAST(TRAINING.TRAIN_OBJECTIVE AS NVARCHAR(100)) AS TRAIN_OBJECTIVE,
		<cfelse>
			CAST(TRAINING.TRAIN_OBJECTIVE AS VARGRAPHIC(100)) AS TRAIN_OBJECTIVE,
		</cfif>
		TRAINING.TRAIN_HEAD,
		<cfif database_type is 'MSSQL'>
			CAST(TRAINING.TRAIN_DEPARTMENTS AS NVARCHAR(100)) AS TRAIN_DEPARTMENTS,
		<cfelse>
			CAST(TRAINING.TRAIN_DEPARTMENTS AS VARGRAPHIC(100)) AS TRAIN_DEPARTMENTS,
		</cfif>
		TRAINING.RECORD_DATE,
		TRAINING.RECORD_EMP,
		TRAINING.RECORD_PAR
	FROM 
		TRAINING
	<cfif isDefined("attributes.TRAINING_CAT_ID") AND attributes.TRAINING_CAT_ID NEQ 0>
		,TRAINING_SEC
		,TRAINING_CAT
	</cfif>
	WHERE
	<cfif isDefined("attributes.TRAINING_CAT_ID") AND attributes.TRAINING_CAT_ID NEQ 0>
		TRAINING.TRAINING_SEC_ID=TRAINING_SEC.TRAINING_SEC_ID AND
		TRAINING_SEC.TRAINING_CAT_ID=TRAINING_CAT.TRAINING_CAT_ID AND
		TRAINING_CAT.TRAINING_CAT_ID = #attributes.TRAINING_CAT_ID# AND
	</cfif>
	<!--- PARTNER DA UYARLA --->
		TRAINING.SUBJECT_STATUS = 1
	<cfif isDefined("attributes.KEYWORD") AND Len(attributes.KEYWORD)>
		AND
		(
		TRAINING.TRAIN_OBJECTIVE LIKE '%#attributes.KEYWORD#%' COLLATE SQL_Latin1_General_CP1_CI_AI
		OR
		TRAINING.TRAIN_HEAD LIKE '%#attributes.KEYWORD#%' COLLATE SQL_Latin1_General_CP1_CI_AI
		)
	</cfif>
	<cfif (not attributes.fuseaction contains "popup") and get_emp_det.recordcount and listlen(train_id_list)>
		AND TRAINING.TRAIN_ID IN (#train_id_list#)
	</cfif>
	<cfif isDefined("attributes.TRAINING_CAT_ID") and (attributes.TRAINING_CAT_ID NEQ 0)>
		AND TRAINING.TRAINING_CAT_ID = #attributes.TRAINING_CAT_ID#
	</cfif>
	<cfif isDefined("attributes.TRAINING_SEC_ID") and (attributes.TRAINING_SEC_ID NEQ 0)>
		AND TRAINING.TRAINING_SEC_ID = #attributes.TRAINING_SEC_ID#
	</cfif>
  UNION
	SELECT
		TT.TRAIN_ID,
		<!--- TT.TRAIN_OBJECTIVE, --->
		<cfif database_type is 'MSSQL'>
			CAST(TT.TRAIN_OBJECTIVE AS NVARCHAR(100)) AS TRAIN_OBJECTIVE,
		<cfelse>
			CAST(TT.TRAIN_OBJECTIVE AS VARGRAPHIC(100)) AS TRAIN_OBJECTIVE,
		</cfif>
		TT.TRAIN_HEAD,
		<!--- TT.TRAIN_DEPARTMENTS, --->
		<cfif database_type is 'MSSQL'>
			CAST(TT.TRAIN_DEPARTMENTS AS NVARCHAR(100)) AS TRAIN_DEPARTMENTS,
		<cfelse>
			CAST(TT.TRAIN_DEPARTMENTS AS VARGRAPHIC(100)) AS TRAIN_DEPARTMENTS,
		</cfif>
		TT.RECORD_DATE,
		TT.RECORD_EMP,
		TT.RECORD_PAR
	FROM
		TRAINING_CLASS_SECTIONS TC,
		TRAINING TT
	WHERE
		TT.TRAIN_ID = TC.TRAIN_ID AND
		TT.TRAINING_SEC_ID = TC.TRAINING_SEC_ID 
		<cfif isDefined("attributes.TRAINING_CAT_ID") and (attributes.TRAINING_CAT_ID NEQ 0)>
			AND TT.TRAINING_CAT_ID = #attributes.TRAINING_CAT_ID#
		</cfif>
		<cfif isDefined("attributes.TRAINING_SEC_ID") and (attributes.TRAINING_SEC_ID NEQ 0)>
			AND TT.TRAINING_SEC_ID = #attributes.TRAINING_SEC_ID#
		</cfif>
		<cfif listlen(class_list)>AND TC.CLASS_ID IN (#class_list#)</cfif>
		<cfif (not attributes.fuseaction contains "popup") and get_emp_det.recordcount and listlen(train_id_list)>
			AND TT.TRAIN_ID IN (#train_id_list#)
		</cfif>
</cfquery>
