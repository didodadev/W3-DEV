<cfquery name="GET_PERF_RESULTS" datasource="#dsn#"> 
	<!--- Formdan Sonuc Girilmisse --->
	SELECT
		EPERF.PER_ID,
		EPERF.START_DATE,
		EPERF.FINISH_DATE,
		EPERF.EVAL_DATE,
		EPERF.RECORD_DATE,
		EPERF.RECORD_TYPE,
		EQ.QUIZ_ID,
		EQ.QUIZ_HEAD,
		EPERF.EMP_ID EMP_ID,
		EPERF.PER_STAGE,
		'eski form' AS Tip ,
		0 AS SURVEY_MAIN_ID,
		0 AS TYPE
	FROM 
		EMPLOYEE_PERFORMANCE EPERF,
		EMPLOYEE_QUIZ EQ,
		EMPLOYEE_QUIZ_RESULTS EQR
	WHERE
		<!--- Form Sonucu ve Degerlendirme Sonucu iliskileri --->
		EQR.QUIZ_ID = EQ.QUIZ_ID AND
		EPERF.RESULT_ID = EQR.RESULT_ID
        <cfif isDefined("attributes.my_form") and len(attributes.my_form)>
         AND EQ.QUIZ_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.my_form#%">
        </cfif>
		<cfif len(attributes.period_year)>
			AND YEAR(EPERF.START_DATE) = #attributes.period_year#
		<cfelseif not len(attributes.period_year)>
			AND YEAR(EPERF.START_DATE) = #session.ep.period_year#
		</cfif>
		AND
		(
			(	<!--- Calisan --->
				EQ.IS_MANAGER_0 = 1 AND EPERF.VALID IS NULL AND
				EPERF.EMP_ID = #session.ep.userid#
			) OR
			(	<!--- Gorus Bildiren --->
				(	(EQ.IS_MANAGER_0 = 1 AND (EPERF.VALID = 1 OR EPERF.EMP_ID IS NULL)) OR EQ.IS_MANAGER_0 = 0 ) AND
				EPERF.VALID_1 IS NULL AND
				EQ.IS_MANAGER_3 = 1 AND EPERF.VALID_3 IS NULL AND
				EPERF.MANAGER_3_EMP_ID = #session.ep.userid#
			) OR
			(	<!--- 1.Amir --->
				(	(EQ.IS_MANAGER_0 = 1 AND (EPERF.VALID = 1 OR EPERF.EMP_ID IS NULL)) OR EQ.IS_MANAGER_0 = 0 ) AND
				(	(EQ.IS_MANAGER_3 = 1 AND (EPERF.VALID_3 = 1 OR EPERF.MANAGER_3_EMP_ID IS NULL)) OR EQ.IS_MANAGER_3 = 0 ) AND
				EPERF.VALID_4 IS NULL AND
				EQ.IS_MANAGER_1 = 1 AND EPERF.VALID_1 IS NULL AND
				EPERF.MANAGER_1_EMP_ID = #session.ep.userid#
			) OR
			(	<!--- Ortak Degerlendirme --->
				(	(EQ.IS_MANAGER_0 = 1 AND (EPERF.VALID = 1 OR EPERF.EMP_ID IS NULL)) OR EQ.IS_MANAGER_0 = 0 ) AND
				(	(EQ.IS_MANAGER_1 = 1 AND (EPERF.VALID_1 = 1 OR EPERF.MANAGER_1_EMP_ID IS NULL)) OR EQ.IS_MANAGER_1 = 0 ) AND
				EPERF.VALID_2 IS NULL AND
				EQ.IS_MANAGER_4 = 1 AND EPERF.VALID_4 IS NULL AND
				EPERF.MANAGER_1_EMP_ID = #session.ep.userid#
			) OR
			(	<!--- 2.Amir --->
				(	(EQ.IS_MANAGER_0 = 1 AND (EPERF.VALID = 1 OR EPERF.EMP_ID IS NULL)) OR EQ.IS_MANAGER_0 = 0 ) AND
				(	(EQ.IS_MANAGER_3 = 1 AND (EPERF.VALID_3 = 1 OR EPERF.MANAGER_3_EMP_ID IS NULL)) OR EQ.IS_MANAGER_3 = 0 ) AND
				(	(EQ.IS_MANAGER_4 = 1 AND (EPERF.VALID_4 = 1 OR EPERF.MANAGER_1_EMP_ID IS NULL)) OR EQ.IS_MANAGER_4 = 0 ) AND
				EQ.IS_MANAGER_2 = 1 AND EPERF.VALID_2 IS NULL AND
				EPERF.MANAGER_2_EMP_ID = #session.ep.userid#
			)
		)
		<cfif isdefined('attributes.per_stage') and len(attributes.per_stage)>
			AND PER_STAGE = #attributes.per_stage#
		</cfif>
	UNION
 	<!--- Formdan Sonuc Girilmemisse --->
	SELECT
		-1 AS PER_ID, 
		'1950-01-01 00:00:00' AS START_DATE, 
		'1950-01-01 00:00:00' AS FINISH_DATE, 
		NULL AS EVAL_DATE, 
		'1950-01-01 00:00:00' AS RECORD_DATE, 
		-1 AS RECORD_TYPE, 
		EMPLOYEE_QUIZ.QUIZ_ID,
		EMPLOYEE_QUIZ.QUIZ_HEAD,
		EMPLOYEE_POSITIONS.EMPLOYEE_ID EMP_ID,
		-1 AS PER_STAGE,
		'eski form' AS Tip,
		0 AS SURVEY_MAIN_ID,
		0 AS TYPE 
	FROM 
		EMPLOYEE_QUIZ,
		EMPLOYEE_POSITIONS,
		RELATION_SEGMENT_QUIZ,
		EMPLOYEE_POSITIONS_STANDBY
	WHERE
		
		EMPLOYEE_POSITIONS_STANDBY.POSITION_CODE = EMPLOYEE_POSITIONS.POSITION_CODE
		AND EMPLOYEE_POSITIONS.IS_MASTER = 1
		<!--- Ilgili Formdaki Pozisyon tipleri  --->
		AND RELATION_SEGMENT_QUIZ.RELATION_FIELD_ID = EMPLOYEE_QUIZ.QUIZ_ID
		AND EMPLOYEE_POSITIONS.POSITION_CAT_ID = RELATION_SEGMENT_QUIZ.RELATION_ACTION_ID
		AND RELATION_SEGMENT_QUIZ.RELATION_ACTION = 3
		<cfif isDefined("attributes.my_form") and len(attributes.my_form)>
         AND EMPLOYEE_QUIZ.QUIZ_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.my_form#%">
        </cfif>
		<!--- Formun Gorulebilecegi Kisiler (Benim Pozisyonum veya Amiri Oldugum Pozisyonlar) --->
		AND EMPLOYEE_POSITIONS.EMPLOYEE_ID IN (#under_emp_list#)
		<!--- Formdaki Donem Tanimina Gore Ilgili Yil Filtresi Yapiliyor, Burada Yil Kismindan Alinmasi Daha Dogru veya Bu Bilgi Formdan Kaldirilmali --->
		<cfif len(attributes.period_year)>
			AND YEAR(EMPLOYEE_QUIZ.START_DATE) = #attributes.period_year#
		<cfelseif not len(attributes.period_year)>
			AND YEAR(EMPLOYEE_QUIZ.START_DATE) = #session.ep.period_year# 
		</cfif>
		<!--- Gundemden Yapilan Kayitlarin --->
		<!--- Eger 7. Ay ve oncesinde kontrol ediyorsak  Kayit Tipi 4: Ara Degerlendirme Olanlari; 7. aydan Sonrasi icin 1: Asil Kontrol Ediliyor --->
		AND EMPLOYEE_POSITIONS.EMPLOYEE_ID NOT IN (	SELECT
														EMP_ID
													FROM
														EMPLOYEE_PERFORMANCE
													WHERE
														<!--- Formun Gorulebilecegi Kisiler (Benim Pozisyonum veya Amiri Oldugum Pozisyonlar) --->
														EMP_ID IN (#under_emp_list#) AND
														<!--- Formdaki Donem Tanimina Gore Ilgili Yil Filtresi Yapiliyor --->
														YEAR(EMPLOYEE_PERFORMANCE.START_DATE) = <cfif len(attributes.period_year)>#attributes.period_year#<cfelse>#session.ep.period_year#</cfif> AND
														PER_TYPE=1 <!--- Default 1 Verilmis Myhome da Sonuc Degismiyor --->
												 )
		AND (
				(EMPLOYEE_QUIZ.IS_MANAGER_0 = 1 AND EMPLOYEE_POSITIONS.POSITION_CODE IN(#pos_code_list#)) OR
				(EMPLOYEE_QUIZ.IS_MANAGER_0 = 0 AND EMPLOYEE_QUIZ.IS_MANAGER_1 = 1 AND EMPLOYEE_POSITIONS_STANDBY.CHIEF1_CODE IN(#pos_code_list#)) OR
				(EMPLOYEE_QUIZ.IS_MANAGER_1 = 0 AND EMPLOYEE_QUIZ.IS_MANAGER_2 = 1 AND EMPLOYEE_POSITIONS_STANDBY.CHIEF2_CODE IN(#pos_code_list#)) OR
				(EMPLOYEE_QUIZ.IS_MANAGER_2 = 0 AND EMPLOYEE_QUIZ.IS_MANAGER_3 = 1 AND EMPLOYEE_POSITIONS_STANDBY.CHIEF3_CODE IN(#pos_code_list#))
			)
	<!--- form generator dan gelen formlar icin eklendi ust bolum daha sonra kapatılacak SG 20121001 --->
	<cfif isdefined('attributes.per_stage') and len(attributes.per_stage)>
		AND -1 = #attributes.per_stage#
	</cfif>
	UNION
	SELECT
		SMR.SURVEY_MAIN_RESULT_ID AS PER_ID,
		SMR.START_DATE,
		SMR.FINISH_DATE,
		NULL AS EVAL_DATE,
		SMR.RECORD_DATE,
		'' AS RECORD_TYPE,
		SM.SURVEY_MAIN_ID AS QUIZ_ID,
		SM.SURVEY_MAIN_HEAD AS QUIZ_HEAD,
		SMR.ACTION_ID EMP_ID,
		SMR.PROCESS_ROW_ID AS PER_STAGE,
		'form_generator' AS Tip ,
		SM.SURVEY_MAIN_ID,
		SM.TYPE
	FROM
		SURVEY_MAIN_RESULT SMR,
		SURVEY_MAIN SM
	WHERE
		SM.SURVEY_MAIN_ID = SMR.SURVEY_MAIN_ID AND
		SM.IS_ACTIVE = 1
		AND SMR.ACTION_ID IN(#under_emp_list#)
        <cfif isDefined("attributes.my_form") and len(attributes.my_form)>
         AND SM.SURVEY_MAIN_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.my_form#%">
        </cfif>
		<cfif len(attributes.period_year)>
			AND YEAR(SMR.START_DATE) = #attributes.period_year#
		<cfelseif not len(attributes.period_year)>
			AND YEAR(SMR.START_DATE) = #session.ep.period_year#
		</cfif>
		AND
		(
			<!--- Çalışan--->
			(	
				SM.IS_MANAGER_0 = 1 AND SMR.VALID IS NULL AND
				SMR.ACTION_ID = #session.ep.userid#
			) OR
			<!--- görüş bildiren--->
			(	
				((SM.IS_MANAGER_0 = 1 AND (SMR.VALID = 1 OR SMR.ACTION_ID IS NULL)) OR SM.IS_MANAGER_0 = 0 ) AND
				SMR.VALID1 IS NULL AND
				SM.IS_MANAGER_3 = 1 AND SMR.VALID3 IS NULL AND
				SMR.MANAGER3_EMP_ID = #session.ep.userid#
			) OR
			<!--- 1.amir--->
			(	
				((SM.IS_MANAGER_0 = 1 AND (SMR.VALID = 1 OR SMR.ACTION_ID IS NULL)) OR SM.IS_MANAGER_0 = 0 ) AND
				((SM.IS_MANAGER_3 = 1 AND (SMR.VALID3 = 1 OR SMR.MANAGER3_EMP_ID IS NULL)) OR SM.IS_MANAGER_3 = 0 ) AND
				SMR.VALID4 IS NULL AND
				SM.IS_MANAGER_1 = 1 AND SMR.VALID1 IS NULL AND
				SMR.MANAGER1_EMP_ID = #session.ep.userid#
			) OR
			<!--- Ortak değerlendirme --->
			(	
				((SM.IS_MANAGER_0 = 1 AND (SMR.VALID = 1 OR SMR.ACTION_ID IS NULL)) OR SM.IS_MANAGER_0 = 0 ) AND
				((SM.IS_MANAGER_1 = 1 AND (SMR.VALID1 = 1 OR SMR.MANAGER1_EMP_ID IS NULL)) OR SM.IS_MANAGER_1 = 0 ) AND
				((SM.IS_MANAGER_3 = 1 AND (SMR.VALID3 = 1 OR SMR.MANAGER3_EMP_ID IS NULL)) OR SM.IS_MANAGER_3 = 0 ) AND
				SMR.VALID2 IS NULL AND
				SM.IS_MANAGER_4 = 1 AND SMR.VALID4 IS NULL AND
				SMR.MANAGER1_EMP_ID = #session.ep.userid#
			) OR
			<!--- 2.amir--->
			(	
				((SM.IS_MANAGER_0 = 1 AND (SMR.VALID = 1 OR SMR.ACTION_ID IS NULL)) OR SM.IS_MANAGER_0 = 0 ) AND
				((SM.IS_MANAGER_1 = 1 AND (SMR.VALID1 = 1 OR SMR.MANAGER1_EMP_ID IS NULL)) OR SM.IS_MANAGER_1 = 0 ) AND
				((SM.IS_MANAGER_3 = 1 AND (SMR.VALID3 = 1 OR SMR.MANAGER3_EMP_ID IS NULL)) OR SM.IS_MANAGER_3 = 0 ) AND
				((SM.IS_MANAGER_4 = 1 AND (SMR.VALID4 = 1 OR SMR.MANAGER1_EMP_ID IS NULL)) OR SM.IS_MANAGER_4 = 0 ) AND
				SM.IS_MANAGER_2 = 1 AND SMR.VALID2 IS NULL AND
				SMR.MANAGER2_EMP_ID = #session.ep.userid#
			)
		)
		<cfif isdefined('attributes.per_stage') and len(attributes.per_stage)>
			AND SMR.PROCESS_ROW_ID = #attributes.per_stage#
		</cfif>
	UNION 
	SELECT
		-1 AS PER_ID, 
		'1950-01-01 00:00:00' AS START_DATE, 
		'1950-01-01 00:00:00' AS FINISH_DATE, 
		NULL AS EVAL_DATE, 
		'1950-01-01 00:00:00' AS RECORD_DATE, 
		'' AS RECORD_TYPE, 
		SM.SURVEY_MAIN_ID AS QUIZ_ID,
		SM.SURVEY_MAIN_HEAD AS QUIZ_HEAD,
		EMPLOYEE_POSITIONS.EMPLOYEE_ID EMP_ID,
		-1 AS PER_STAGE,
		'form_generator' AS Tip,
		SM.SURVEY_MAIN_ID,
		SM.TYPE
	FROM 
		SURVEY_MAIN SM,
		EMPLOYEE_POSITIONS,
		EMPLOYEE_POSITIONS_STANDBY
	WHERE
		SM.IS_ACTIVE = 1 AND
		EMPLOYEE_POSITIONS_STANDBY.POSITION_CODE = EMPLOYEE_POSITIONS.POSITION_CODE
		AND EMPLOYEE_POSITIONS.IS_MASTER = 1
        <cfif isDefined("attributes.my_form") and len(attributes.my_form)>
         AND SM.SURVEY_MAIN_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.my_form#%">
        </cfif>
		<cfif len(attributes.period_year)>
			AND YEAR(SM.START_DATE) = #attributes.period_year#
		<cfelseif not len(attributes.period_year)>
			AND YEAR(SM.START_DATE) = #session.ep.period_year#
		</cfif>
		AND EMPLOYEE_POSITIONS.POSITION_CAT_ID IN(SELECT POSITION_CAT_ID FROM SURVEY_MAIN_POSITION_CATS WHERE SURVEY_MAIN_ID = SM.SURVEY_MAIN_ID)
		AND EMPLOYEE_POSITIONS.EMPLOYEE_ID IN (#under_emp_list#)
		AND EMPLOYEE_POSITIONS.EMPLOYEE_ID NOT IN (	SELECT
														ACTION_ID
													FROM
														SURVEY_MAIN_RESULT
													WHERE
														SURVEY_MAIN_RESULT.ACTION_TYPE = 8 AND 
														ACTION_ID IN (#under_emp_list#) AND
														YEAR(RECORD_DATE) = #session.ep.period_year# AND
                                                        SURVEY_MAIN_RESULT.SURVEY_MAIN_ID = SM.SURVEY_MAIN_ID
												 )
		AND (
				(SM.IS_MANAGER_0 = 1 AND EMPLOYEE_POSITIONS.POSITION_CODE IN(#pos_code_list#)) OR
				(SM.IS_MANAGER_3 = 1 AND SM.IS_MANAGER_0 = 0 AND EMPLOYEE_POSITIONS_STANDBY.CHIEF3_CODE IN(#pos_code_list#)) OR
				(SM.IS_MANAGER_0 = 0 AND SM.IS_MANAGER_1 = 1 AND EMPLOYEE_POSITIONS_STANDBY.CHIEF1_CODE IN(#pos_code_list#)) OR
				(SM.IS_MANAGER_1 = 0 AND SM.IS_MANAGER_2 = 1 AND EMPLOYEE_POSITIONS_STANDBY.CHIEF2_CODE IN(#pos_code_list#)) OR
				(SM.IS_MANAGER_2 = 0 AND SM.IS_MANAGER_3 = 1 AND EMPLOYEE_POSITIONS_STANDBY.CHIEF3_CODE IN(#pos_code_list#))
			)
		<cfif isdefined('attributes.per_stage') and len(attributes.per_stage)>
			AND -1 = #attributes.per_stage#
		</cfif>
	UNION
	SELECT
		-1 AS PER_ID, 
		'1950-01-01 00:00:00' AS START_DATE, 
		'1950-01-01 00:00:00' AS FINISH_DATE, 
		NULL AS EVAL_DATE, 
		'1950-01-01 00:00:00' AS RECORD_DATE, 
		'' AS RECORD_TYPE, 
		SM.SURVEY_MAIN_ID AS QUIZ_ID,
		SM.SURVEY_MAIN_HEAD AS QUIZ_HEAD,
		EMPLOYEE_POSITIONS.EMPLOYEE_ID EMP_ID,
		-1 AS PER_STAGE,
		'form_generator' AS Tip,
		SM.SURVEY_MAIN_ID,
		SM.TYPE
	FROM 
		CONTENT_RELATION CR,
		SURVEY_MAIN SM,
		EMPLOYEE_POSITIONS,
		EMPLOYEE_POSITIONS_STANDBY
	WHERE
		SM.IS_ACTIVE = 1 AND
		SM.SURVEY_MAIN_ID =CR.SURVEY_MAIN_ID AND
		CR.RELATION_TYPE = 8 AND 
		CR.RELATION_CAT =  EMPLOYEE_POSITIONS.EMPLOYEE_ID AND
		EMPLOYEE_POSITIONS_STANDBY.POSITION_CODE = EMPLOYEE_POSITIONS.POSITION_CODE
		AND EMPLOYEE_POSITIONS.IS_MASTER = 1
        <cfif isDefined("attributes.my_form") and len(attributes.my_form)>
         AND SM.SURVEY_MAIN_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.my_form#%">
        </cfif>
		<cfif len(attributes.period_year)>
			AND YEAR(SM.START_DATE) = #attributes.period_year#
		<cfelseif not len(attributes.period_year)>
			AND YEAR(SM.START_DATE) = #session.ep.period_year#
		</cfif>
		AND EMPLOYEE_POSITIONS.EMPLOYEE_ID IN (#under_emp_list#)
		AND EMPLOYEE_POSITIONS.EMPLOYEE_ID NOT IN (	SELECT
														ACTION_ID
													FROM
														SURVEY_MAIN_RESULT
													WHERE
														SURVEY_MAIN_RESULT.ACTION_TYPE = 8 AND 
														ACTION_ID IN (#under_emp_list#) AND
														YEAR(RECORD_DATE) = #session.ep.period_year# 
												 )
		AND (
				(SM.IS_MANAGER_0 = 1 AND EMPLOYEE_POSITIONS.POSITION_CODE IN(#pos_code_list#)) OR
				(SM.IS_MANAGER_0 = 0 AND SM.IS_MANAGER_1 = 1 AND EMPLOYEE_POSITIONS_STANDBY.CHIEF1_CODE IN(#pos_code_list#)) OR
				(SM.IS_MANAGER_1 = 0 AND SM.IS_MANAGER_2 = 1 AND EMPLOYEE_POSITIONS_STANDBY.CHIEF2_CODE IN(#pos_code_list#)) OR
				(SM.IS_MANAGER_2 = 0 AND SM.IS_MANAGER_3 = 1 AND EMPLOYEE_POSITIONS_STANDBY.CHIEF3_CODE IN(#pos_code_list#))
			)
		<cfif isdefined('attributes.per_stage') and len(attributes.per_stage)>
			AND -1 = #attributes.per_stage#
		</cfif>
</cfquery>
