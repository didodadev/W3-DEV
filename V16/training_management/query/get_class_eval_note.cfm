<cfquery  name="get_note" datasource="#DSN#">
	SELECT 
		TC.EMPLOYEE_ID,
		TC.CLASS_ID,
		0 CON_ID,
		0 PAR_ID,
		CAST(TC.DETAIL AS NVARCHAR(1000)) AS DETAIL,
		E.EMPLOYEE_NAME+ ' '+ E.EMPLOYEE_SURNAME AS AD
	FROM
		TRAINING_CLASS_EVAL_NOTE TC,
		EMPLOYEES E,
		EMPLOYEE_POSITIONS,
		DEPARTMENT,
		BRANCH,
		OUR_COMPANY C
	WHERE
		EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
		DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID AND 
		BRANCH.BRANCH_ID IN (
                                SELECT
                                    BRANCH_ID
                                FROM
                                    EMPLOYEE_POSITION_BRANCHES
                                WHERE
                                    POSITION_CODE = #SESSION.EP.POSITION_CODE#	
                            ) AND 
		C.COMP_ID=BRANCH.COMPANY_ID AND 
		EMPLOYEE_POSITIONS.EMPLOYEE_ID = TC.EMPLOYEE_ID AND
		TC.EMPLOYEE_ID = E.EMPLOYEE_ID AND
		TC.CLASS_ID = #attributes.CLASS_ID#
		
	UNION
	SELECT 
		0 EMPLOYEE_ID,
		TC.CLASS_ID,
		TC.CON_ID,
		0 PAR_ID,
		CAST(TC.DETAIL AS NVARCHAR(1000)) AS DETAIL,
		CON.CONSUMER_NAME+ ' '+ CON.CONSUMER_SURNAME AS AD
	FROM
		TRAINING_CLASS_EVAL_NOTE TC,
		CONSUMER CON
	WHERE		
		TC.CLASS_ID = #attributes.CLASS_ID# AND
		TC.CON_ID = CON.CONSUMER_ID
	UNION
	SELECT 
		0 EMPLOYEE_ID,
		TC.CLASS_ID,
		0 CON_ID,
		TC.PAR_ID,
		CAST(TC.DETAIL AS NVARCHAR(1000)) AS DETAIL,
		COMP.COMPANY_PARTNER_NAME+ ' '+ COMP.COMPANY_PARTNER_SURNAME AS AD
	FROM
		TRAINING_CLASS_EVAL_NOTE TC,
		COMPANY_PARTNER COMP
	WHERE		
		TC.CLASS_ID = #attributes.CLASS_ID# AND
		TC.PAR_ID = COMP.PARTNER_ID
	
</cfquery>