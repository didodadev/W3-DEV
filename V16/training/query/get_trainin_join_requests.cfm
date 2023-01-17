<cfquery name="get_training_join_requests" datasource="#dsn#">
	SELECT 
		TC.CLASS_ID AS TRAIN_ID,
		TC.CLASS_NAME AS TRAIN_NAME,
		'' AS OTHER_TRAIN_NAME,
		TC.START_DATE, 
		TC.FINISH_DATE, 
		TC.MONTH_ID, 
		TRR.TRAIN_REQUEST_ID,
		TRR.EMPLOYEE_ID,
		TRR.REQUEST_ROW_ID,
		TRR.RECORD_DATE,
		TRR.REQUEST_TYPE,
		TRR.ANNOUNCE_ID,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		'Ders Talebi' AS TYPE,
		TRR.HR_VALID AS PROCESS_STAGE
	FROM 
		TRAINING_REQUEST_ROWS AS TRR,
		TRAINING_CLASS AS TC,
		EMPLOYEES AS E
	WHERE
		TRR.TRAIN_REQUEST_ID IS NULL AND
		TRR.ANNOUNCE_ID IS NULL AND
		TRR.CLASS_ID = TC.CLASS_ID AND
		E.EMPLOYEE_ID=TRR.EMPLOYEE_ID AND 
		TRR.EMPLOYEE_ID = #session.ep.userid#
	<cfif isDefined("attributes.KEYWORD") and len(attributes.KEYWORD)>
		AND
		(
		TC.CLASS_NAME LIKE '%#attributes.KEYWORD#%' COLLATE SQL_Latin1_General_CP1_CI_AI
		OR
		E.EMPLOYEE_NAME LIKE '%#attributes.KEYWORD#%' COLLATE SQL_Latin1_General_CP1_CI_AI
		OR
		E.EMPLOYEE_SURNAME LIKE '%#attributes.KEYWORD#%' COLLATE SQL_Latin1_General_CP1_CI_AI
		)
	</cfif>
	UNION ALL
	SELECT 
		TC.CLASS_ID AS TRAIN_ID,
		TC.CLASS_NAME AS TRAIN_NAME,
		'' AS OTHER_TRAIN_NAME,
		TC.START_DATE, 
		TC.FINISH_DATE, 
		TC.MONTH_ID, 
		TRR.TRAIN_REQUEST_ID,
		TRR.EMPLOYEE_ID,
		TRR.REQUEST_ROW_ID,
		TRR.RECORD_DATE,
		TRR.REQUEST_TYPE,
		TRR.ANNOUNCE_ID,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		'Duyuru Talebi' AS TYPE,
		TRR.HR_VALID AS PROCESS_STAGE
	FROM 
		TRAINING_REQUEST_ROWS AS TRR,
		TRAINING_CLASS AS TC,
		EMPLOYEES AS E
	WHERE
		TRR.TRAIN_REQUEST_ID IS NULL AND
		TRR.ANNOUNCE_ID IS NOT NULL AND
		TRR.CLASS_ID = TC.CLASS_ID AND
		E.EMPLOYEE_ID=TRR.EMPLOYEE_ID AND 
		TRR.EMPLOYEE_ID = #session.ep.userid#
	<cfif isDefined("attributes.KEYWORD") and len(attributes.KEYWORD)>
		AND
		(
		TC.CLASS_NAME LIKE '%#attributes.KEYWORD#%' COLLATE SQL_Latin1_General_CP1_CI_AI
		OR
		E.EMPLOYEE_NAME LIKE '%#attributes.KEYWORD#%' COLLATE SQL_Latin1_General_CP1_CI_AI
		OR
		E.EMPLOYEE_SURNAME LIKE '%#attributes.KEYWORD#%' COLLATE SQL_Latin1_General_CP1_CI_AI
		)
	</cfif>
	<!---UNION ALL
	SELECT 
		TRR.TRAINING_ID AS TRAIN_ID,
		(SELECT TRAIN_HEAD FROM TRAINING WHERE TRAIN_ID=TRR.TRAINING_ID) AS TRAIN_NAME,
		TRR.OTHER_TRAIN_NAME, 
		TR.START_DATE,
		TR.FINISH_DATE, 
		'' AS MONTH_ID,
		TRR.TRAIN_REQUEST_ID,
		TRR.EMPLOYEE_ID,
		TRR.REQUEST_ROW_ID,
		TRR.RECORD_DATE,
		TRR.REQUEST_TYPE,
		TRR.ANNOUNCE_ID,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		'Eğitim Talebi' AS TYPE,
		TR.PROCESS_STAGE
	FROM 
		TRAINING_REQUEST AS TR,
		TRAINING_REQUEST_ROWS AS TRR,
		EMPLOYEES AS E
	WHERE
		TR.TRAIN_REQUEST_ID = TRR.TRAIN_REQUEST_ID AND
		E.EMPLOYEE_ID=TRR.EMPLOYEE_ID AND 
		TR.REQUEST_TYPE IN(1,2) AND
		TRR.EMPLOYEE_ID =  #session.ep.userid# 
		<cfif isDefined("attributes.KEYWORD") and len(attributes.KEYWORD)>
			AND
			(
				TRR.OTHER_TRAIN_NAME LIKE '%#attributes.KEYWORD#%' OR 
				TRR.TRAINING_ID IN(SELECT TRAIN_ID FROM TRAINING WHERE TRAIN_ID = TRR.TRAINING_ID AND TRAIN_HEAD LIKE '%#attributes.KEYWORD#%') OR
				E.EMPLOYEE_NAME LIKE '%#attributes.KEYWORD#%' OR
				E.EMPLOYEE_SURNAME LIKE '%#attributes.KEYWORD#%'
			)
		</cfif>
	UNION ALL
	SELECT 
		TRR.TRAINING_ID AS TRAIN_ID,
		(SELECT TRAIN_HEAD FROM TRAINING WHERE TRAIN_ID=TRR.TRAINING_ID) AS TRAIN_NAME,
		TRR.OTHER_TRAIN_NAME, 
		TR.START_DATE,
		TR.FINISH_DATE, 
		'' AS MONTH_ID,
		TRR.TRAIN_REQUEST_ID,
		TRR.EMPLOYEE_ID,
		TRR.REQUEST_ROW_ID,
		TRR.RECORD_DATE,
		TRR.REQUEST_TYPE,
		TRR.ANNOUNCE_ID,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		'Yıllık Eğitim Talebi' AS TYPE,
		TR.PROCESS_STAGE
	FROM 
		TRAINING_REQUEST AS TR,
		TRAINING_REQUEST_ROWS AS TRR,
		EMPLOYEES AS E
	WHERE
		TR.TRAIN_REQUEST_ID = TRR.TRAIN_REQUEST_ID AND
		E.EMPLOYEE_ID=TRR.EMPLOYEE_ID AND 
		TR.REQUEST_TYPE IN(3) AND
		TRR.EMPLOYEE_ID =  #session.ep.userid#
		<cfif isDefined("attributes.KEYWORD") and len(attributes.KEYWORD)>
			AND
			(
				TRR.OTHER_TRAIN_NAME LIKE '%#attributes.KEYWORD#%' OR 
				TRR.TRAINING_ID IN(SELECT TRAIN_ID FROM TRAINING WHERE TRAIN_ID = TRR.TRAINING_ID AND TRAIN_HEAD LIKE '%#attributes.KEYWORD#%') OR
				E.EMPLOYEE_NAME LIKE '%#attributes.KEYWORD#%' OR
				E.EMPLOYEE_SURNAME LIKE '%#attributes.KEYWORD#%'
			)
		</cfif>--->
	ORDER BY
		TRR.RECORD_DATE DESC,E.EMPLOYEE_NAME,E.EMPLOYEE_SURNAME 
</cfquery>