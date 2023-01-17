<!--- bos olan calisan sayisini getirir  --->
<cfquery name="get_emp_positions_det_" datasource="#dsn#">
	SELECT DISTINCT
		EP.EMPLOYEE_ID,
		EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME AS EMP_NAME,
		EP.POSITION_NAME,
		EP.POSITION_CAT_ID,
		EP.COLLAR_TYPE ,
		B.COMPANY_ID,
		B.BRANCH_ID,
		D.DEPARTMENT_ID,
		EP.IS_MASTER,
		EP.FUNC_ID
	FROM  
		EMPLOYEE_POSITIONS EP,
		DEPARTMENT D,
		BRANCH B,
		OUR_COMPANY OC,
		ZONE Z
	WHERE 
		EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND
		D.BRANCH_ID = B.BRANCH_ID AND
		B.ZONE_ID = Z.ZONE_ID AND
		B.COMPANY_ID = OC.COMP_ID AND
		EP.POSITION_STATUS = 1  
</cfquery>

<cfquery name="get_emp_positions_det" datasource="#dsn#">
	SELECT DISTINCT
		EIO.EMPLOYEE_ID,
		EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME AS EMP_NAME,
		EP.POSITION_NAME,
		EP.POSITION_CAT_ID,
		EP.COLLAR_TYPE ,
		EP.IS_MASTER,
		E.EMPLOYEE_STATUS,
		EP.FUNC_ID,
		B.COMPANY_ID
	FROM  
		EMPLOYEES_IN_OUT EIO INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID
		LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID,
		DEPARTMENT D,
		BRANCH B,
		OUR_COMPANY OC,
		ZONE Z
	WHERE 
		EIO.DEPARTMENT_ID = D.DEPARTMENT_ID AND
		EIO.BRANCH_ID = B.BRANCH_ID AND
		B.ZONE_ID = Z.ZONE_ID AND
		B.COMPANY_ID = OC.COMP_ID AND
		EP.POSITION_STATUS = 1   AND  
		EP.IS_MASTER = 1  AND
		EP.EMPLOYEE_ID <> 0 AND 
		E.EMPLOYEE_STATUS = 1 AND
		EP.EMPLOYEE_ID IS NOT NULL AND
        ((
        EIO.START_DATE <= #NOW()# AND
        EIO.FINISH_DATE >= #NOW()#
        )
        OR
        (
        EIO.START_DATE <= #NOW()# AND
        EIO.FINISH_DATE IS NULL
        ))
	GROUP BY
		EIO.EMPLOYEE_ID,
		EP.EMPLOYEE_NAME ,EP.EMPLOYEE_SURNAME,
		EP.POSITION_NAME,
		EP.POSITION_CAT_ID,
		EP.COLLAR_TYPE ,
		EP.IS_MASTER,
		E.EMPLOYEE_STATUS,
		EP.FUNC_ID,
		B.COMPANY_ID
</cfquery>

<cfquery name="get_emp_edu_det" datasource="#dsn#">
	SELECT DISTINCT
		<cfif isdefined("attributes.search_type") or isdefined("attributes.comp_id") or isdefined("attributes.branch_id") or isdefined("attributes.department_id")>
			B.COMPANY_ID,
			B.BRANCH_ID,
			D.DEPARTMENT_ID,
		</cfif>
			ED.SEX,
			ED.LAST_SCHOOL,
			E.EMPLOYEE_ID,
			EP.FUNC_ID,
            (SELECT OS.ORGANIZATION_STEP_NO FROM SETUP_ORGANIZATION_STEPS OS WHERE OS.ORGANIZATION_STEP_ID = EP.ORGANIZATION_STEP_ID) AS STEP_NO
	FROM
    	EMPLOYEES_IN_OUT EIO INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID,
		<cfif isdefined("attributes.search_type") or isdefined("attributes.comp_id") or isdefined("attributes.branch_id") or isdefined("attributes.department_id")>
			OUR_COMPANY OC,
			ZONE Z,
			BRANCH B,
			DEPARTMENT D,
		</cfif>
			EMPLOYEE_POSITIONS EP,
			EMPLOYEES_DETAIL ED
	WHERE 
		<cfif isdefined("attributes.search_type") or isdefined("attributes.comp_id") or isdefined("attributes.branch_id") or isdefined("attributes.department_id")>
			EIO.DEPARTMENT_ID = D.DEPARTMENT_ID AND
			EIO.BRANCH_ID = B.BRANCH_ID AND
			B.ZONE_ID = Z.ZONE_ID AND
			B.COMPANY_ID = OC.COMP_ID AND
		</cfif>
			EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND
			EP.POSITION_STATUS = 1 AND
			EP.IS_MASTER = 1 AND
			E.EMPLOYEE_ID = ED.EMPLOYEE_ID AND
		 	E.EMPLOYEE_STATUS = 1 AND
			((
            EIO.START_DATE <= #NOW()# AND
            EIO.FINISH_DATE >= #NOW()#
            )
            OR
            (
            EIO.START_DATE <= #NOW()# AND
            EIO.FINISH_DATE IS NULL
            ))
</cfquery>

<cfif attributes.emp_pro_selection neq 1>
	<cfquery name="get_emp_age_blood" datasource="#dsn#">
		SELECT 
			<cfif attributes.emp_pro_selection eq 2>
				COUNT(E.EMPLOYEE_ID) COUNT_BLOOD_TYPE,
				EI.BLOOD_TYPE
			<cfelseif attributes.emp_pro_selection eq 3>
				COUNT(DATEDIFF(YEAR,EI.BIRTH_DATE,GETDATE())) COUNT_AGE,
				DATEDIFF(YEAR,EI.BIRTH_DATE,GETDATE()) AGE,
				E.EMPLOYEE_ID	
			<cfelseif attributes.emp_pro_selection eq 4>
				COUNT(DATEDIFF(YEAR,E.KIDEM_DATE,GETDATE())) COUNT_KIDEM,
				DATEDIFF(YEAR,E.KIDEM_DATE,GETDATE()) KIDEM,
				E.EMPLOYEE_ID	
			<cfelseif attributes.emp_pro_selection eq 5>
				COUNT(E.EMPLOYEE_ID) AS COUNT_EDU_TYPE,
				ED.LAST_SCHOOL	
            <cfelseif attributes.emp_pro_selection eq 6>
            	COUNT(E.EMPLOYEE_ID) AS COUNT_STEP_ID,
                EP.ORGANIZATION_STEP_ID
			</cfif>
			<cfif isdefined("attributes.comp_id")>
				,B.COMPANY_ID
			</cfif>
			<cfif isdefined("attributes.branch_id")>
				,B.BRANCH_ID
			</cfif>
			<cfif isdefined("attributes.department_id")>
				,D.DEPARTMENT_ID
			</cfif>
			<cfif isdefined("attributes.employee_id")>
				,E.EMPLOYEE_ID
			</cfif>
			<cfif isdefined("attributes.func_id")>
				,EP.FUNC_ID
			</cfif>
		FROM
			EMPLOYEE_POSITIONS EP,
			EMPLOYEES_IN_OUT EIO INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID
			<cfif attributes.emp_pro_selection eq 2 or attributes.emp_pro_selection eq 3>
				,EMPLOYEES_IDENTY EI
			</cfif>
			<cfif isdefined("attributes.comp_id")>
				,OUR_COMPANY OC,
				ZONE Z,
				BRANCH B,
				DEPARTMENT D
			</cfif>
			<cfif attributes.emp_pro_selection eq 5>
				,EMPLOYEES_DETAIL ED
			</cfif>
		WHERE 
				EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND
				EP.POSITION_STATUS = 1 AND
				EP.IS_MASTER = 1 AND
			<cfif isdefined("attributes.comp_id") or isdefined("attributes.branch_id") or isdefined("attributes.department_id")>
				EIO.DEPARTMENT_ID = D.DEPARTMENT_ID AND
				EIO.BRANCH_ID = B.BRANCH_ID AND
				B.ZONE_ID = Z.ZONE_ID AND
				B.COMPANY_ID = OC.COMP_ID AND
			</cfif>
			<cfif attributes.emp_pro_selection eq 2 or attributes.emp_pro_selection eq 3>
				 E.EMPLOYEE_ID = EI.EMPLOYEE_ID AND
				 <cfif attributes.emp_pro_selection eq 2>
				 	EI.BLOOD_TYPE IS NOT NULL AND
				 <cfelseif attributes.emp_pro_selection eq 3>
					 EI.BIRTH_DATE IS NOT NULL AND
				</cfif>
			 <cfelseif attributes.emp_pro_selection eq 4>
				 E.KIDEM_DATE IS NOT NULL AND
			<cfelseif attributes.emp_pro_selection eq 5>
				E.EMPLOYEE_ID = ED.EMPLOYEE_ID AND
			</cfif>
			E.EMPLOYEE_STATUS = 1 AND
			EP.EMPLOYEE_ID <> 0 AND 
			EP.EMPLOYEE_ID IS NOT NULL AND
			((
            EIO.START_DATE <= #NOW()# AND
            EIO.FINISH_DATE >= #NOW()#
            )
            OR
            (
            EIO.START_DATE <= #NOW()# AND
            EIO.FINISH_DATE IS NULL
            ))
		GROUP BY 
			<cfif isdefined("attributes.employee_id")>
				E.EMPLOYEE_ID,
			</cfif>
			<cfif isdefined("attributes.comp_id")>
				B.COMPANY_ID,
			</cfif>
			<cfif isdefined("attributes.branch_id")>
				B.BRANCH_ID,
			</cfif>
			<cfif isdefined("attributes.department_id")>
				D.DEPARTMENT_ID,
			</cfif>
			<cfif isdefined("attributes.func_id")>
				EP.FUNC_ID,
			</cfif>
			<cfif attributes.emp_pro_selection eq 2>
				BLOOD_TYPE
			<cfelseif attributes.emp_pro_selection eq 3>
				DATEDIFF(YEAR,EI.BIRTH_DATE,GETDATE()),
				E.EMPLOYEE_ID	
			<cfelseif attributes.emp_pro_selection eq 4>
				DATEDIFF(YEAR,E.KIDEM_DATE,GETDATE()),
				E.EMPLOYEE_ID	
			<cfelseif attributes.emp_pro_selection eq 5>
				ED.LAST_SCHOOL
			<cfelseif attributes.emp_pro_selection eq 6>
				EP.ORGANIZATION_STEP_ID
			</cfif>
	</cfquery>
	<cfif attributes.emp_pro_selection eq 3>
		<cfquery name="get_emp_age_18" dbtype="query">
			SELECT * FROM get_emp_age_blood WHERE AGE < 18
		</cfquery>
		<cfquery name="get_emp_age_25" dbtype="query">
			SELECT * FROM get_emp_age_blood WHERE AGE >= 18 AND AGE < 25
		</cfquery>
		<cfquery name="get_emp_age_35" dbtype="query">
			SELECT * FROM get_emp_age_blood WHERE AGE >= 25 AND AGE < 35
		</cfquery>
		<cfquery name="get_emp_age_50" dbtype="query">
			SELECT * FROM get_emp_age_blood WHERE AGE >= 35 AND AGE < 50
		</cfquery>
		<cfquery name="get_emp_age_50_ustu" dbtype="query">
			SELECT * FROM get_emp_age_blood WHERE AGE >= 50
		</cfquery>
		
		<cfquery name="get_all_age" dbtype="query">
			SELECT 1 TYPE,COUNT(COUNT_AGE) COUNT_AGE FROM get_emp_age_18
			UNION ALL
			SELECT 2 TYPE,COUNT(COUNT_AGE) COUNT_AGE FROM get_emp_age_25
			UNION ALL
			SELECT 3 TYPE,COUNT(COUNT_AGE) COUNT_AGE FROM get_emp_age_35
			UNION ALL
			SELECT 4 TYPE,COUNT(COUNT_AGE) COUNT_AGE FROM get_emp_age_50
			UNION ALL
			SELECT 5 TYPE,COUNT(COUNT_AGE) COUNT_AGE FROM get_emp_age_50_ustu
		</cfquery>
	<cfelseif attributes.emp_pro_selection eq 4>
		<cfquery name="get_emp_kidem_1" dbtype="query">
			SELECT * FROM get_emp_age_blood WHERE KIDEM < 1
		</cfquery>
		<cfquery name="get_emp_kidem_3" dbtype="query">
			SELECT * FROM get_emp_age_blood WHERE KIDEM >= 1 AND KIDEM < 3
		</cfquery>
		<cfquery name="get_emp_kidem_5" dbtype="query">
			SELECT * FROM get_emp_age_blood WHERE KIDEM >= 3 AND KIDEM < 5
		</cfquery>
		<cfquery name="get_emp_kidem_9" dbtype="query">
			SELECT * FROM get_emp_age_blood WHERE KIDEM >= 5 AND KIDEM < 9
		</cfquery>
		<cfquery name="get_emp_kidem_9_ustu" dbtype="query">
			SELECT * FROM get_emp_age_blood WHERE KIDEM >= 9
		</cfquery>
		<cfquery name="get_all_kidem" dbtype="query">
			SELECT 1 TYPE,COUNT(COUNT_KIDEM) COUNT_KIDEM  FROM get_emp_kidem_1
			UNION ALL
			SELECT 2 TYPE,COUNT(COUNT_KIDEM) COUNT_KIDEM FROM get_emp_kidem_3
			UNION ALL
			SELECT 3 TYPE,COUNT(COUNT_KIDEM) COUNT_KIDEM FROM get_emp_kidem_5
			UNION ALL
			SELECT 4 TYPE,COUNT(COUNT_KIDEM) COUNT_KIDEM FROM get_emp_kidem_9
			UNION ALL
			SELECT 5 TYPE,COUNT(COUNT_KIDEM) COUNT_KIDEM FROM get_emp_kidem_9_ustu
		</cfquery>
	</cfif>
</cfif>
