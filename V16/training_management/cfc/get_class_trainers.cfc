<cfset dsn = application.SystemParam.SystemParam().dsn>
<cffunction name="get_class_trainers" returntype="query">
   	<cfargument name="class_id" default="" type="numeric"/>
	<cfquery name="get_class_trainer" datasource="#dsn#">
		SELECT
			TCT.ID,
			TCT.EMP_ID,
			SETUP_POSITION_CAT.POSITION_CAT,
			E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME AS TRAINER,
            TC.CLASS_NAME,
			'Çalışan' AS TRAINER_DETAIL
		FROM
			TRAINING_CLASS_TRAINERS TCT
                INNER JOIN TRAINING_CLASS TC ON TC.CLASS_ID = TCT.CLASS_ID
                INNER JOIN EMPLOYEES E ON TCT.EMP_ID = E.EMPLOYEE_ID,
			SETUP_POSITION_CAT,
			EMPLOYEE_POSITIONS AS EP
		WHERE
			TCT.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#">
			AND EP.EMPLOYEE_ID = TCT.EMP_ID
			AND EP.POSITION_CAT_ID = SETUP_POSITION_CAT.POSITION_CAT_ID
		UNION ALL
		SELECT
			TCT.ID,
			TCT.EMP_ID,
			SETUP_POSITION_CAT.POSITION_CAT,
			CP.COMPANY_PARTNER_NAME+' '+ CP.COMPANY_PARTNER_SURNAME AS TRAINER,
            TC.CLASS_NAME,
			'Kurumsal' AS TRAINER_DETAIL
		FROM
			TRAINING_CLASS_TRAINERS TCT
                INNER JOIN TRAINING_CLASS TC ON TC.CLASS_ID = TCT.CLASS_ID
                INNER JOIN COMPANY_PARTNER CP ON TCT.PAR_ID =CP.PARTNER_ID,
			SETUP_POSITION_CAT,
			EMPLOYEE_POSITIONS AS EP
		WHERE
			TCT.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#">
			AND EP.EMPLOYEE_ID = TCT.EMP_ID
			AND EP.POSITION_CAT_ID = SETUP_POSITION_CAT.POSITION_CAT_ID
		UNION ALL
		SELECT
			TCT.ID,
			TCT.EMP_ID,
			SETUP_POSITION_CAT.POSITION_CAT,
			C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME AS TRAINER,
            TC.CLASS_NAME,
			'Bireysel' AS TRAINER_DETAIL
		FROM
			TRAINING_CLASS_TRAINERS TCT
                INNER JOIN TRAINING_CLASS TC ON TC.CLASS_ID = TCT.CLASS_ID
                INNER JOIN CONSUMER C ON TCT.CONS_ID =C.CONSUMER_ID,
			SETUP_POSITION_CAT,
			EMPLOYEE_POSITIONS AS EP
		WHERE
			TCT.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#">
			AND EP.EMPLOYEE_ID = TCT.EMP_ID
			AND EP.POSITION_CAT_ID = SETUP_POSITION_CAT.POSITION_CAT_ID
	</cfquery>
	<cfreturn get_class_trainer/>
</cffunction>
<cffunction name="get_classes" returntype="query">
	<cfargument name="class_id" default="" type="numeric"/>	
	<cfquery name="get_classes" datasource="#dsn#">
		SELECT
			TCT.ID,
			TCT.EMP_ID AS T_ID,
			E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME AS TRAINER,
			'Çalışan' AS TRAINER_DETAIL
		FROM
			TRAINING_CLASS_TRAINERS TCT INNER JOIN EMPLOYEES E
			ON TCT.EMP_ID = E.EMPLOYEE_ID,
			EMPLOYEE_POSITIONS AS EP
		WHERE
			TCT.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#">
			AND EP.EMPLOYEE_ID = TCT.EMP_ID
		UNION ALL
		SELECT
			TCT.ID,
			TCT.PAR_ID AS T_ID,
			CP.COMPANY_PARTNER_NAME+' '+ CP.COMPANY_PARTNER_SURNAME AS TRAINER,
			'Kurumsal' AS TRAINER_DETAIL
		FROM
			TRAINING_CLASS_TRAINERS TCT INNER JOIN COMPANY_PARTNER CP
			ON TCT.PAR_ID =CP.PARTNER_ID
		WHERE
			TCT.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#">
		UNION ALL
		SELECT
			TCT.ID,
			TCT.CONS_ID AS T_ID,
			C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME AS TRAINER,
			'Bireysel' AS TRAINER_DETAIL
		FROM
			TRAINING_CLASS_TRAINERS TCT INNER JOIN CONSUMER C
			ON TCT.CONS_ID =C.CONSUMER_ID
		WHERE
			TCT.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#">
	</cfquery>
	<cfreturn get_classes/>
</cffunction>
<cffunction name="get_pos_cat" returntype="string">	
	<cfargument name="emp_id" default="" type="numeric"/>
	<cfquery name="get_pos_cat" datasource="#dsn#">
		SELECT SETUP_POSITION_CAT.POSITION_CAT FROM SETUP_POSITION_CAT LEFT JOIN EMPLOYEE_POSITIONS ON EMPLOYEE_POSITIONS.POSITION_CAT_ID = SETUP_POSITION_CAT.POSITION_CAT_ID WHERE EMPLOYEE_POSITIONS.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.emp_id#">
	</cfquery>
	<cfreturn get_pos_cat.position_cat/>
</cffunction>