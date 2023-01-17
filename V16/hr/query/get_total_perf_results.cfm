<cfquery name="GET_TOTAL_PERF_RESULTS" datasource="#dsn#">
	SELECT 
		ETP.PERFORMANCE_ID,
		ETP.START_DATE,
		ETP.FINISH_DATE,
		EPOS.POSITION_ID,
		EPOS.POSITION_NAME,
		EPOS.EMPLOYEE_ID,
		EPOS.EMPLOYEE_NAME,
		EPOS.EMPLOYEE_SURNAME		
	FROM 
		EMPLOYEE_TOTAL_PERFORMANCE ETP,
		EMPLOYEE_POSITIONS EPOS
	WHERE
		ETP.EMP_ID = EPOS.EMPLOYEE_ID AND
		(
			YEAR(START_DATE) = #attributes.search_tarih#
			OR
			YEAR(FINISH_DATE) = #attributes.search_tarih#
		)
        <cfif len(attributes.position_cat_id) and attributes.position_cat_id neq 0>
        AND EPOS.POSITION_CAT_ID = #attributes.position_cat_id# 
        </cfif>
        <cfif len(attributes.department_id) and attributes.department_id neq 0>
        AND EPOS.DEPARTMENT_ID = #attributes.department_id# 
        </cfif>
        <cfif len(attributes.keyword)>
        AND
        	(
            	EPOS.EMPLOYEE_NAME+' '+EPOS.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
                EPOS.EMPLOYEE_ID IN(SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_NO = '#attributes.keyword#' COLLATE SQL_Latin1_General_CP1_CI_AI)
            )
        </cfif>
</cfquery>
