<cfquery name="get_data" datasource="#dsn#">
	SELECT	
		DISTINCT
		SCO.SCO_ID,
		SCO.NAME,
		SCO.VERSION,
		SCO_DATA.USER_ID AS USERID,
		SCO_DATA.USER_TYPE,
		E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME AS ADSOYAD,
		C.NICK_NAME AS NICK_NAME,
		'' AS TOTAL_TIME,
		'' AS SCORE,
		'' AS COMPLETION_STATUS,
		'' AS SUCCESS_STATUS,
		'' AS PROGRESS,
		'' AS DATA_ID
	FROM 
		TRAINING_CLASS_SCO SCO,
		TRAINING_CLASS_SCO_DATA SCO_DATA,
		EMPLOYEES E,
		EMPLOYEE_POSITIONS EP,
		DEPARTMENT D,
		BRANCH B,
		OUR_COMPANY C
	WHERE
		SCO.SCO_ID = SCO_DATA.SCO_ID AND
		SCO_DATA.USER_TYPE = 0 AND
		SCO_DATA.USER_ID = E.EMPLOYEE_ID AND
		E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND
		EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND
		D.BRANCH_ID = B.BRANCH_ID AND
		B.COMPANY_ID = C.COMP_ID AND
		SCO.CLASS_ID = #attributes.class_id#
		<cfif len(attributes.keyword)>
		AND (
			SCO.NAME LIKE '%#attributes.keyword#%' OR
			E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%' OR
			C.NICK_NAME LIKE '%#attributes.keyword#%'
			)
		</cfif>
		<cfif len(attributes.emp_id) and len(emp_par_name)>
			AND E.EMPLOYEE_ID = #attributes.emp_id#
		<cfelseif len(attributes.par_id) and len(emp_par_name)>
			AND 1=0
		<cfelseif len(attributes.cons_id) and len(emp_par_name)>
			AND 1=0
		</cfif>
		<cfif len(attributes.is_completed) and attributes.is_completed eq 1>
			AND (VAR_NAME LIKE 'cmi.completion_status' OR VAR_NAME LIKE 'cmi.core.lesson_status')
			AND CAST(VAR_VALUE AS varchar(50)) = 'completed'
		<cfelseif len(attributes.is_completed) and attributes.is_completed eq 0>
			AND (VAR_NAME LIKE 'cmi.completion_status' OR VAR_NAME LIKE 'cmi.core.lesson_status')
			AND CAST(VAR_VALUE AS varchar(50)) <> 'completed'
		</cfif>
	UNION
		SELECT 
		DISTINCT
			SCO.SCO_ID,
			SCO.NAME,
			SCO.VERSION,
			SCO_DATA.USER_ID AS USERID,
			SCO_DATA.USER_TYPE,
			CP.COMPANY_PARTNER_NAME+' '+CP.COMPANY_PARTNER_SURNAME AS ADSOYAD,
			C.NICKNAME AS NICK_NAME,
			'' AS TOTAL_TIME,
			'' AS SCORE,
			'' AS COMPLETION_STATUS,
			'' AS SUCCESS_STATUS,
			'' AS PROGRESS,
			'' AS DATA_ID
		FROM 
			TRAINING_CLASS_SCO SCO,
			TRAINING_CLASS_SCO_DATA SCO_DATA,
			COMPANY_PARTNER CP,
			COMPANY C
		WHERE
			SCO.SCO_ID = SCO_DATA.SCO_ID AND
			SCO_DATA.USER_TYPE = 1 AND
			SCO_DATA.USER_ID = CP.PARTNER_ID AND
			CP.COMPANY_ID = C.COMPANY_ID AND
			SCO.CLASS_ID = #attributes.class_id#
			<cfif len(attributes.keyword)>
			AND (
				SCO.NAME LIKE '%#attributes.keyword#%' OR
				CP.COMPANY_PARTNER_NAME+' '+CP.COMPANY_PARTNER_SURNAME LIKE '%#attributes.keyword#%' OR
				C.NICKNAME LIKE '%#attributes.keyword#%'
				)
			</cfif>
			<cfif len(attributes.par_id) and len(emp_par_name)>
				AND CP.PARTNER_ID = #attributes.par_id#
			<cfelseif len(attributes.emp_id) and len(emp_par_name)>
				AND 1=0
			<cfelseif len(attributes.cons_id) and len(emp_par_name)>
				AND 1=0
			</cfif>
			<cfif len(attributes.is_completed) and attributes.is_completed eq 1>
				AND (VAR_NAME LIKE 'cmi.completion_status' OR VAR_NAME LIKE 'cmi.core.lesson_status')
				AND CAST(VAR_VALUE AS varchar(50)) = 'completed'
			<cfelseif len(attributes.is_completed) and attributes.is_completed eq 0>
				AND (VAR_NAME LIKE 'cmi.completion_status' OR VAR_NAME LIKE 'cmi.core.lesson_status')
				AND CAST(VAR_VALUE AS varchar(50)) <> 'completed'
			</cfif>
		UNION 
	SELECT 
		DISTINCT
			SCO.SCO_ID,
			SCO.NAME,
			SCO.VERSION,
			SCO_DATA.USER_ID AS USERID,
			SCO_DATA.USER_TYPE,
			C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME AS ADSOYAD,
			'' AS NICK_NAME
			,
			'' AS TOTAL_TIME,
			'' AS SCORE,
			'' AS COMPLETION_STATUS,
			'' AS SUCCESS_STATUS,
			'' AS PROGRESS,
			'' AS DATA_ID
		FROM 
			TRAINING_CLASS_SCO SCO,
			TRAINING_CLASS_SCO_DATA SCO_DATA,
			CONSUMER C
		WHERE
			SCO.SCO_ID = SCO_DATA.SCO_ID AND
			SCO_DATA.USER_TYPE = 2 AND
			SCO_DATA.USER_ID = C.CONSUMER_ID AND
			SCO.CLASS_ID = #attributes.class_id#
			<cfif len(attributes.keyword)>
			AND (
				SCO.NAME LIKE '%#attributes.keyword#%' OR
				CONSUMER_NAME+' '+C.CONSUMER_SURNAME LIKE '%#attributes.keyword#%'
				)
			</cfif>
			<cfif len(attributes.cons_id) and len(emp_par_name)>
				AND C.CONSUMER_ID = #attributes.cons_id#
			<cfelseif len(attributes.par_id) and len(emp_par_name)>
				AND 1=0
			<cfelseif len(attributes.emp_id) and len(emp_par_name)>
				AND 1=0
			</cfif>
			<cfif len(attributes.is_completed) and attributes.is_completed eq 1>
				AND (VAR_NAME LIKE 'cmi.completion_status' OR VAR_NAME LIKE 'cmi.core.lesson_status')
				AND CAST(VAR_VALUE AS varchar(50)) = 'completed'
			<cfelseif len(attributes.is_completed) and attributes.is_completed eq 0>
				AND (VAR_NAME LIKE 'cmi.completion_status' OR VAR_NAME LIKE 'cmi.core.lesson_status')
				AND CAST(VAR_VALUE AS varchar(50)) <> 'completed'
			</cfif>
</cfquery>

