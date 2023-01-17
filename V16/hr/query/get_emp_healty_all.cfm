<cfquery name="GET_HEALTY" datasource="#DSN#"> 
	SELECT DISTINCT
		<cfif attributes.report_type neq 1>
			EH.INSPECTION_DATE,
			EH.NEXT_INSPECTION_DATE,
			EH.INSPECTION_RESULT,
			EH.COMPLAINT,
			EH.HEALTY_ID,
			EH.HEALTY_DETAIL,
			EH.DECISION_MEDICINE,
			EH.PROCESS_TYPE,
			EH.CONCLUSION,
			(SELECT ER.NAME +' '+ ER.SURNAME NAME FROM EMPLOYEES_RELATIVES ER WHERE EH.RELATIVE_ID = ER.RELATIVE_ID) RELATIVE_NAME,
			EH.RECORD_DATE,
		<cfelse>
			MAX(HEALTY_ID) HEALTY_ID,
			MAX(EH.INSPECTION_DATE) INSPECTION_DATE,
			MAX(EH.NEXT_INSPECTION_DATE) NEXT_INSPECTION_DATE,
		</cfif>
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		E.EMPLOYEE_ID,
		ED.SEX,
		ED.HOMEADDRESS,
		EP.POSITION_NAME,
		(SELECT TOP 1 D.DEPARTMENT_HEAD FROM DEPARTMENT D,EMPLOYEE_POSITIONS EP WHERE D.DEPARTMENT_ID = EP.DEPARTMENT_ID AND EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND EP.IS_MASTER = 1) DEPARTMENT_HEAD,
		(SELECT TOP 1 B.BRANCH_NAME FROM BRANCH B,DEPARTMENT D,EMPLOYEE_POSITIONS EP WHERE B.BRANCH_ID = D.BRANCH_ID AND D.DEPARTMENT_ID = EP.DEPARTMENT_ID AND EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND EP.IS_MASTER = 1) BRANCH_NAME,
		EIO.START_DATE START_DATE2
	FROM
		EMPLOYEE_HEALTY EH,
		EMPLOYEES_DETAIL ED,
		EMPLOYEES E
		LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND EP.IS_MASTER = 1
		LEFT JOIN EMPLOYEES_IN_OUT EIO ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND EIO.FINISH_DATE IS NULL
	WHERE
		E.EMPLOYEE_ID = EH.EMPLOYEE_ID AND 
		ED.EMPLOYEE_ID = EH.EMPLOYEE_ID
		<cfif len(attributes.keyword)>
		AND
		(
			E.EMPLOYEE_NAME +' '+ E.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR 
            E.EMPLOYEE_NO = '#attributes.keyword#'
		)
		</cfif>
		  <cfif attributes.date_selection eq 1>
		  	<cfif len(attributes.start_date)>
			AND (SELECT TOP 1 EIO.START_DATE FROM EMPLOYEES_IN_OUT EIO WHERE EIO.EMPLOYEE_ID = E.EMPLOYEE_ID AND EIO.START_DATE IS NOT NULL) >= #attributes.start_date#
			</cfif>
			<cfif len(attributes.finish_date)>
			AND (SELECT TOP 1 EIO.START_DATE FROM EMPLOYEES_IN_OUT EIO WHERE EIO.EMPLOYEE_ID = E.EMPLOYEE_ID AND EIO.START_DATE IS NOT NULL) <= #attributes.finish_date#
			</cfif>
		<cfelseif  attributes.date_selection eq 2>
			<cfif len(attributes.start_date)>
			AND INSPECTION_DATE >= #attributes.start_date#
			</cfif>
			<cfif len(attributes.finish_date)>
			AND INSPECTION_DATE <= #attributes.finish_date#
			</cfif>
		<cfelseif  attributes.date_selection eq 3>
			<cfif len(attributes.start_date)>
			AND NEXT_INSPECTION_DATE >= #attributes.start_date#
			</cfif>
			<cfif len(attributes.finish_date)>
			AND NEXT_INSPECTION_DATE <= #attributes.finish_date#
			</cfif>
		</cfif> 
		<cfif len(attributes.status)>
			AND EH.STATUS = #attributes.status#
		</cfif> 
		<cfif attributes.report_type eq 2>
			AND EH.INSPECTION_DATE IS NOT NULL
		</cfif>
		 AND (SELECT TOP 1 EIO.FINISH_DATE FROM EMPLOYEES_IN_OUT EIO WHERE EIO.EMPLOYEE_ID = E.EMPLOYEE_ID ORDER BY IN_OUT_ID DESC) IS NULL
	<cfif attributes.report_type eq 1>
		GROUP BY
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			E.EMPLOYEE_ID,
			ED.SEX,
			ED.HOMEADDRESS,
			EP.POSITION_NAME,
			EIO.START_DATE
	</cfif>
	ORDER BY 
		E.EMPLOYEE_ID
		<cfif attributes.report_type neq 1>
			,EH.RECORD_DATE DESC
		</cfif>
 </cfquery> 
