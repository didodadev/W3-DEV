<cfquery name="get_class_attender" datasource="#DSN#">
	SELECT
		'employee' AS TYPE,
		TRAINING_CLASS_ATTENDER.CLASS_ID,
		TRAINING_CLASS_ATTENDER.IS_SELFSERVICE SELF_SERVICE,
		TRAINING_CLASS_ATTENDER.EMP_ID AS K_ID,
        TRAINING_CLASS_ATTENDER.STATUS,
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME AS AD,
		EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME AS SOYAD,
		EMPLOYEE_POSITIONS.EMPLOYEE_ID AS IDS,
		EMPLOYEE_POSITIONS.POSITION_NAME  AS POSITION,
		DEPARTMENT.DEPARTMENT_HEAD AS DEPARTMAN,
		C.NICK_NAME AS NICK_NAME,
		BRANCH.BRANCH_NAME AS BRANCH_NAME
	FROM
		TRAINING_CLASS_ATTENDER,
		EMPLOYEE_POSITIONS,
		DEPARTMENT,
		BRANCH,
		OUR_COMPANY C
	WHERE
		DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID
		AND C.COMP_ID=BRANCH.COMPANY_ID
		AND EMPLOYEE_POSITIONS.EMPLOYEE_ID = TRAINING_CLASS_ATTENDER.EMP_ID
		AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
		AND EMPLOYEE_POSITIONS.IS_MASTER = 1
		AND TRAINING_CLASS_ATTENDER.EMP_ID IS NOT NULL
		AND TRAINING_CLASS_ATTENDER.CLASS_ID=#attributes.class_id#
UNION
	SELECT 
		'partner' AS TYPE,
		TRAINING_CLASS_ATTENDER.CLASS_ID,
		TRAINING_CLASS_ATTENDER.IS_SELFSERVICE SELF_SERVICE,
		TRAINING_CLASS_ATTENDER.PAR_ID K_ID,
        TRAINING_CLASS_ATTENDER.STATUS,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME AS AD,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME AS SOYAD,
		COMPANY_PARTNER.PARTNER_ID AS IDS,
		COMPANY_PARTNER.TITLE AS POSITION,
		' ' AS DEPARTMAN, 	
		COMPANY.NICKNAME AS NICK_NAME,
		' ' AS BRANCH_NAME
	FROM
		TRAINING_CLASS_ATTENDER,
		COMPANY_PARTNER,
		COMPANY
	WHERE
		TRAINING_CLASS_ATTENDER.CLASS_ID = #attributes.CLASS_ID#
		AND COMPANY_PARTNER.PARTNER_ID = TRAINING_CLASS_ATTENDER.PAR_ID
		AND COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID
UNION
	SELECT
		'consumer' AS TYPE,
		TRAINING_CLASS_ATTENDER.CLASS_ID,
		TRAINING_CLASS_ATTENDER.IS_SELFSERVICE SELF_SERVICE,
		TRAINING_CLASS_ATTENDER.CON_ID AS K_ID,
        TRAINING_CLASS_ATTENDER.STATUS,
		CONSUMER.CONSUMER_NAME AS AD,
		CONSUMER.CONSUMER_SURNAME AS SOYAD,
		CONSUMER.CONSUMER_ID AS IDS,
		CONSUMER.TITLE AS POSITION,
		' ' AS DEPARTMAN,
		CONSUMER.COMPANY AS NICK_NAME,
		' ' AS BRANCH_NAME
	FROM
		TRAINING_CLASS_ATTENDER,
		CONSUMER
	WHERE
		TRAINING_CLASS_ATTENDER.CLASS_ID = #attributes.CLASS_ID#
		AND CONSUMER.CONSUMER_ID = TRAINING_CLASS_ATTENDER.CON_ID
		AND TRAINING_CLASS_ATTENDER.CON_ID IS NOT NULL
UNION 
	SELECT
			'group' AS TYPE,
			TRAINING_CLASS_ATTENDER.CLASS_ID,
			TRAINING_CLASS_ATTENDER.IS_SELFSERVICE SELF_SERVICE,
			TRAINING_CLASS_ATTENDER.GRP_ID K_ID,
            TRAINING_CLASS_ATTENDER.STATUS,
			USERS.GROUP_NAME AS AD,
			' ' AS SOYAD,
			USERS.GROUP_ID AS IDS,
			' ' AS POSITION,
			' ' AS DEPARTMAN,
			' ' AS NICK_NAME,
			' ' AS BRANCH_NAME
		FROM
			TRAINING_CLASS_ATTENDER,
			USERS
		WHERE
			TRAINING_CLASS_ATTENDER.CLASS_ID = #attributes.CLASS_ID#
			AND USERS.GROUP_ID = TRAINING_CLASS_ATTENDER.GRP_ID
			AND TRAINING_CLASS_ATTENDER.GRP_ID IS NOT NULL
		ORDER BY AD,SOYAD
</cfquery>
