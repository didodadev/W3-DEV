<cfset attributes.lazimtarih = dateformat(now(),dateformat_style)>
<cf_date tarih="attributes.lazimtarih">
<cfquery name="get_position_cat" datasource="#DSN#">
	SELECT
		POSITION_CAT_ID,DEPARTMENT_ID
	FROM
		EMPLOYEE_POSITIONS
	WHERE
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
</cfquery>
<cfset pos_cat=get_position_cat.POSITION_CAT_ID>
<cfset EMP_DEP_ID=get_position_cat.DEPARTMENT_ID>
<cfset attributes.EMP_ID=SESSION.EP.USERID>
<cfquery name="get_edus" datasource="#DSN#">
	SELECT
		LUCK_TRAIN_SUBJECT_1,
		LUCK_TRAIN_SUBJECT_2,
		LUCK_TRAIN_SUBJECT_3,
		LUCK_TRAIN_SUBJECT_4
	FROM
		EMPLOYEE_TOTAL_PERFORMANCE
	WHERE
		EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
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
			#attributes.emp_id# AS EMP_ID		
	FROM
		TRAINING_CLASS TC
	WHERE
		TC.CLASS_ID IN 
			(
			SELECT 
				DISTINCT
				CLASS_ID 
			FROM 
				TRAINING_CLASS_ATTENDANCE 
			WHERE 
				CLASS_ATTENDANCE_ID IN 
				(
					SELECT 
						DISTINCT
						CLASS_ATTENDANCE_ID 
					FROM 
						TRAINING_CLASS_ATTENDANCE_DT 
					WHERE 
						EMP_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
                        AND IS_TRAINER = 0
				)
		)
</cfquery>
<cfset class_list = valuelist(get_tra_dep.CLASS_ID)>
<cfquery name="get_trains" datasource="#DSN#">
	SELECT
		DISTINCT
		TC.START_DATE,
		TC.FINISH_DATE,
		2 AS D_TYPE,
		TC.CLASS_NAME,
		TC.CLASS_ID,
		TC.CLASS_PLACE,
		TC.DATE_NO,
		TC.HOUR_NO
	FROM
		TRAINING_CLASS_ATTENDER TCA,
		TRAINING_CLASS TC 
	WHERE
		TC.CLASS_ID=TCA.CLASS_ID
   <cfif len(class_list)>
	AND
	 TC.CLASS_ID NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#class_list#">)
   </cfif>	    
	AND
		TCA.EMP_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
</cfquery>
<cfquery name="get_next_trains" datasource="#DSN#">
	SELECT
		DISTINCT
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
		TRAINING_CLASS_SECTIONS TCS,
		TRAINING T
	WHERE		
		T.TRAIN_POSITION_CATS LIKE '%,#pos_cat#,%' AND
	    TC.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
		TCS.TRAIN_ID = T.TRAIN_ID AND
		TCS.CLASS_ID = TC.CLASS_ID
</cfquery>
<cfset tra_2_list=valuelist(get_next_trains.CLASS_ID)>
<cfquery name="get_tra_pos" datasource="#DSN#">
	SELECT
		DISTINCT
		T.TRAIN_ID,
		T.TRAIN_HEAD,
		TC.CLASS_ID,
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
		TCS.CLASS_ID = TC.CLASS_ID AND
	   	TCS.TRAIN_ID = T.TRAIN_ID AND
		T.TRAIN_DEPARTMENTS LIKE '%,#EMP_DEP_ID#,%' AND
	    TC.START_DATE >= <cfqueryparam cfsqltype="cf_sql_integer" value="#now()#"> AND
	    TC.CLASS_NAME<>''
</cfquery>
<cfset tra_3_list=valuelist(get_tra_pos.TRAIN_ID)>

