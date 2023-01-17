<!--- <cfquery name="GET_QUIZ_RESULTS" datasource="#dsn#"> 90 güne silinsin 2007 29 11 yd
	SELECT 
		QUIZ_RESULTS.*
	FROM 
		QUIZ_RESULTS
	WHERE
		QUIZ_RESULTS.QUIZ_ID = #attributes.QUIZ_ID#
	ORDER BY
		USER_POINT DESC
</cfquery> --->	
<cfquery name="GET_QUIZ_RESULTS" datasource="#dsn#">
	SELECT
		'employee' AS TYPE,
		EP.EMPLOYEE_ID AS USER_ID,
		EP.EMPLOYEE_NAME AS AD, 
		EP.EMPLOYEE_SURNAME AS SOYAD,
		QUIZ_RESULTS.RESULT_ID,
		QUIZ_RESULTS.QUESTION_COUNT,
		QUIZ_RESULTS.USER_RIGHT_COUNT,
		QUIZ_RESULTS.USER_WRONG_COUNT,
		QUIZ_RESULTS.USER_POINT,
		TC.CLASS_NAME
	FROM 
		QUIZ_RESULTS LEFT JOIN TRAINING_CLASS TC ON QUIZ_RESULTS.CLASS_ID = TC.CLASS_ID
		INNER JOIN EMPLOYEE_POSITIONS EP ON QUIZ_RESULTS.EMP_ID = EP.EMPLOYEE_ID
		INNER JOIN DEPARTMENT D ON EP.DEPARTMENT_ID=D.DEPARTMENT_ID
		INNER JOIN BRANCH B ON D.BRANCH_ID=B.BRANCH_ID
		INNER JOIN OUR_COMPANY C ON C.COMP_ID=B.COMPANY_ID
	WHERE
		B.BRANCH_ID IN (
                            SELECT
                                BRANCH_ID
                            FROM
                                EMPLOYEE_POSITION_BRANCHES
                            WHERE
                                POSITION_CODE = #SESSION.EP.POSITION_CODE#
                        ) AND 
		QUIZ_RESULTS.QUIZ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.QUIZ_ID#">
		<cfif isdefined('attributes.class_id') and len(attributes.class_id)>
			AND TC.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
		</cfif>
	UNION
	SELECT
		'partner' AS TYPE,
		CP.PARTNER_ID AS USER_ID,
		CP.COMPANY_PARTNER_NAME AS AD,
		CP.COMPANY_PARTNER_USERNAME AS SOYAD,
		QUIZ_RESULTS.RESULT_ID,
		QUIZ_RESULTS.QUESTION_COUNT,
		QUIZ_RESULTS.USER_RIGHT_COUNT,
		QUIZ_RESULTS.USER_WRONG_COUNT,
		QUIZ_RESULTS.USER_POINT,
		TC.CLASS_NAME
	FROM 
		QUIZ_RESULTS LEFT JOIN TRAINING_CLASS TC ON QUIZ_RESULTS.CLASS_ID = TC.CLASS_ID
		INNER JOIN COMPANY_PARTNER AS CP ON CP.PARTNER_ID = QUIZ_RESULTS.PARTNER_ID
		INNER JOIN COMPANY AS C ON C.COMPANY_ID=CP.COMPANY_ID
	WHERE
		QUIZ_RESULTS.QUIZ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.QUIZ_ID#">
		<cfif isdefined('attributes.class_id') and len(attributes.class_id)>
			AND TC.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
		</cfif>
	UNION
	SELECT
		'consumer' AS TYPE,
		CONSUMER.CONSUMER_ID AS USER_ID,
		CONSUMER.CONSUMER_NAME AS AD,
		CONSUMER.CONSUMER_SURNAME AS SOYAD,
		QUIZ_RESULTS.RESULT_ID,
		QUIZ_RESULTS.QUESTION_COUNT,
		QUIZ_RESULTS.USER_RIGHT_COUNT,
		QUIZ_RESULTS.USER_WRONG_COUNT,
		QUIZ_RESULTS.USER_POINT,
		TC.CLASS_NAME
	FROM 
		QUIZ_RESULTS LEFT JOIN TRAINING_CLASS TC ON QUIZ_RESULTS.CLASS_ID = TC.CLASS_ID
		INNER JOIN CONSUMER ON CONSUMER.CONSUMER_ID = QUIZ_RESULTS.CONSUMER_ID
	WHERE
		QUIZ_RESULTS.QUIZ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.QUIZ_ID#">
		<cfif isdefined('attributes.class_id') and len(attributes.class_id)>
			AND TC.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
		</cfif>
	ORDER BY
		QUIZ_RESULTS.USER_POINT DESC
</cfquery>
<cfquery name="GET_QUIZ_RIGHT_SUM" datasource="#dsn#">
	SELECT 
		AVG(USER_RIGHT_COUNT) AS RIGHT_SUM,
		QUIZ_ID
	FROM 
		QUIZ_RESULTS
	WHERE
		QUIZ_RESULTS.QUIZ_ID = #attributes.QUIZ_ID#
	GROUP BY
		QUIZ_ID
</cfquery>

