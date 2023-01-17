<cfif isDefined("attributes.DATE") AND len(attributes.DATE)>
	<cf_date tarih="attributes.DATE">
</cfif>
<cfinclude template="../../query/get_position_branches.cfm">
<cfquery name="GET_PRIZE" datasource="#dsn#">
	SELECT
		EP.*,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		E.EMPLOYEE_ID,
		E.EMPLOYEE_NO,
		EPOS.POSITION_NAME,
		EPOS.POSITION_CAT_ID,
		SETUP_POSITION_CAT.POSITION_CAT
 	FROM
		EMPLOYEES_PRIZE EP
			LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EP.PRIZE_TO
			LEFT JOIN EMPLOYEE_POSITIONS EPOS ON EPOS.EMPLOYEE_ID = EP.PRIZE_TO
			LEFT JOIN SETUP_POSITION_CAT ON SETUP_POSITION_CAT.POSITION_CAT_ID = EPOS.POSITION_CAT_ID
	WHERE
		1=1
		AND EPOS.POSITION_STATUS = 1
		AND EPOS.IS_MASTER = 1
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		AND 
			(
			PRIZE_HEAD LIKE '%#attributes.KEYWORD#%' COLLATE SQL_Latin1_General_CP1_CI_AI
			OR E.EMPLOYEE_NAME LIKE '%#attributes.KEYWORD#%' COLLATE SQL_Latin1_General_CP1_CI_AI
			OR E.EMPLOYEE_SURNAME LIKE '%#attributes.KEYWORD#%' COLLATE SQL_Latin1_General_CP1_CI_AI
			)
	</cfif>
	<cfif isDefined("attributes.PRIZE_TYPE") and len(attributes.PRIZE_TYPE)>
	   AND PRIZE_TYPE_ID = #attributes.PRIZE_TYPE#
	</cfif>
	<cfif isDefined("attributes.DATE") and len(attributes.DATE)>
	  AND PRIZE_DATE = #attributes.DATE#
	</cfif>
	<cfif not session.ep.ehesap>
		AND E.EMPLOYEE_ID IN	
		(	
		SELECT EMPLOYEE_ID 
		FROM EMPLOYEE_POSITIONS,DEPARTMENT
		WHERE EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND DEPARTMENT.BRANCH_ID IN (#my_branch_list#) 
		)
	</cfif>
</cfquery>