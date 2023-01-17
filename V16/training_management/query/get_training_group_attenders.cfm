<cfquery name="get_attender_emps" datasource="#dsn#">
    SELECT DISTINCT
        'employee' AS TYPE,
        TGA.EMP_ID AS K_ID,
        EMPLOYEE_POSITIONS.EMPLOYEE_NAME AS AD,
        EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME AS SOYAD,
        EMPLOYEE_POSITIONS.EMPLOYEE_ID AS IDS,
        EMPLOYEE_POSITIONS.POSITION_NAME AS POSITION,
        DEPARTMENT.DEPARTMENT_HEAD AS DEPARTMAN,
        C.NICK_NAME AS NICK_NAME,
        BRANCH.BRANCH_NAME AS BRANCH_NAME,
        E.MEMBER_CODE AS MEMBER_NO,
        EI.TC_IDENTY_NO AS TC_NO,
        TGA.TRAINING_GROUP_ID,
        TGA.TRAINING_GROUP_ATTENDERS_ID AS ATTENDER_ID,
        TGA.STATUS AS STATUS,
        TGA.NOTE_FOR_ATTENDER AS ATTENDER_NOTE,
        TGA.JOIN_STATU AS JOIN_STATU
    FROM
        TRAINING_GROUP_ATTENDERS TGA,
        EMPLOYEE_POSITIONS
            LEFT JOIN EMPLOYEES_IDENTY EI ON EI.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID
            INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID,
        DEPARTMENT,
        BRANCH,
        OUR_COMPANY C
    WHERE
        DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID
        <cfif isDefined("attributes.train_group_id")>
            AND TGA.TRAINING_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_group_id#">
        </cfif>
        AND C.COMP_ID=BRANCH.COMPANY_ID
        AND EMPLOYEE_POSITIONS.EMPLOYEE_ID = TGA.EMP_ID
        AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
        AND EMPLOYEE_POSITIONS.IS_MASTER = 1
        AND TGA.EMP_ID IS NOT NULL
        <cfif isDefined("attributes.statu_filter") and len(attributes.statu_filter)>
            AND TGA.JOIN_STATU = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.statu_filter#">
        </cfif>
        <cfif isDefined("attributes.attender_name") and len(attributes.attender_name)>
            AND EMPLOYEE_POSITIONS.EMPLOYEE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.attender_name#%">
        </cfif>
        <cfif isDefined("attributes.attender_surname") and len(attributes.attender_surname)>
            AND EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.attender_surname#%">
        </cfif>
    ORDER BY AD, SOYAD
</cfquery>
<cfif isDefined("attributes.train_group_id")>
    <cfquery name="get_attenders_new" datasource="#dsn#">
        SELECT *, TGA.TRAINING_GROUP_ATTENDERS_ID AS ATTENDER_ID
        FROM
            TRAINING_GROUP_ATTENDERS TGA
        WHERE
            TRAINING_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_group_id#">      
            AND NAME IS NOT NULL 
    </cfquery>
</cfif>
<cfquery name="get_attender_pars" datasource="#dsn#">
    SELECT DISTINCT
        'partner' AS TYPE,
        TGA.PAR_ID K_ID,
        COMPANY_PARTNER.COMPANY_PARTNER_NAME AS AD,
        COMPANY_PARTNER.COMPANY_PARTNER_SURNAME AS SOYAD,
        COMPANY_PARTNER.PARTNER_ID AS IDS,
        COMPANY_PARTNER.COMPANY_ID,
        COMPANY_PARTNER.TITLE AS POSITION,
        COMPANY.MEMBER_CODE AS MEMBER_NO,
        COMPANY_PARTNER.DEPARTMENT AS DEPARTMAN, 	
        COMPANY.NICKNAME AS NICK_NAME,
        TGA.TRAINING_GROUP_ID,
        ' ' AS BRANCH_NAME,
        COMPANY_PARTNER.TC_IDENTITY AS TC_NO,
        TGA.TRAINING_GROUP_ATTENDERS_ID AS ATTENDER_ID,
        TGA.STATUS AS STATUS,
        TGA.NOTE_FOR_ATTENDER AS ATTENDER_NOTE,
        TGA.JOIN_STATU AS JOIN_STATU
    FROM
        TRAINING_GROUP_ATTENDERS TGA,
        COMPANY_PARTNER,
        COMPANY
    WHERE
        COMPANY_PARTNER.PARTNER_ID = TGA.PAR_ID
        AND COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID
        <cfif isDefined("attributes.train_group_id")>
            AND TGA.TRAINING_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_group_id#">
        </cfif>
        <cfif isDefined("attributes.statu_filter") and len(attributes.statu_filter)>
            AND TGA.JOIN_STATU = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.statu_filter#">
        </cfif>
        <cfif isDefined("attributes.attender_name") and len(attributes.attender_name)>
            AND COMPANY_PARTNER.COMPANY_PARTNER_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.attender_name#%">
        </cfif>
        <cfif isDefined("attributes.attender_surname") and len(attributes.attender_surname)>
            AND COMPANY_PARTNER.COMPANY_PARTNER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.attender_surname#%">
        </cfif>
    ORDER BY AD,SOYAD
</cfquery>
<cfquery name="get_attender_cons" datasource="#dsn#">
    SELECT DISTINCT
        'consumer' AS TYPE,
        TGA.CON_ID AS K_ID,
        CONSUMER.CONSUMER_NAME AS AD,
        CONSUMER.CONSUMER_SURNAME AS SOYAD,
        CONSUMER.CONSUMER_ID AS IDS,
        CONSUMER.TITLE AS POSITION,
        CONSUMER.MEMBER_CODE AS MEMBER_NO,
        CONSUMER.DEPARTMENT AS DEPARTMAN,
        CONSUMER.COMPANY AS NICK_NAME,
        ' ' AS BRANCH_NAME,
        TGA.TRAINING_GROUP_ID,
        CONSUMER.TC_IDENTY_NO AS TC_NO,
        TGA.TRAINING_GROUP_ATTENDERS_ID AS ATTENDER_ID,
        TGA.STATUS AS STATUS,
        TGA.NOTE_FOR_ATTENDER AS ATTENDER_NOTE,
        TGA.JOIN_STATU AS JOIN_STATU
    FROM
        TRAINING_GROUP_ATTENDERS TGA,
        CONSUMER
    WHERE
        CONSUMER.CONSUMER_ID = TGA.CON_ID
        <cfif isDefined("attributes.train_group_id")>
            AND TGA.TRAINING_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_group_id#">
        </cfif>
        <cfif isDefined("attributes.statu_filter") and len(attributes.statu_filter)>
            AND TGA.JOIN_STATU = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.statu_filter#">
        </cfif>
        <cfif isDefined("attributes.attender_name") and len(attributes.attender_name)>
            AND CONSUMER.CONSUMER_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.attender_name#%">
        </cfif>
        <cfif isDefined("attributes.attender_surname") and len(attributes.attender_surname)>
            AND CONSUMER.CONSUMER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.attender_surname#%">
        </cfif>
    ORDER BY AD,SOYAD
</cfquery>
<cfquery name="get_attender_grps" datasource="#dsn#">
SELECT DISTINCT
	'group' AS TYPE,
	TGA.GRP_ID K_ID,
	USERS.GROUP_NAME AS AD,
	' ' AS SOYAD,
	USERS.GROUP_ID AS IDS,
	' ' AS POSITION,
	' ' AS DEPARTMAN,
	' ' AS NICK_NAME,
	' ' AS BRANCH_NAME,
    TGA.TRAINING_GROUP_ID,
	' ' AS TC_NO,
    TGA.TRAINING_GROUP_ATTENDERS_ID AS ATTENDER_ID,
    TGA.STATUS AS STATUS,
    TGA.NOTE_FOR_ATTENDER AS ATTENDER_NOTE,
    TGA.JOIN_STATU AS JOIN_STATU
FROM
	TRAINING_GROUP_ATTENDERS TGA,
	USERS
WHERE
	USERS.GROUP_ID = TGA.GRP_ID
	AND TGA.GRP_ID IS NOT NULL
    <cfif isDefined("attributes.train_group_id")>
        AND TGA.TRAINING_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_group_id#">
    </cfif>
</cfquery>