<cfscript>
	CreateCompenent = createObject("component", "/workdata/get_control_branch_project_info");
	is_control_branch_project = CreateCompenent.get_control_branch_project_info_fnc();
</cfscript>
<cfquery name="get_projects" datasource="#dsn#">
	SELECT 
		DISTINCT(PRO_PROJECTS.PROJECT_ID),
		PRO_PROJECTS.PROJECT_HEAD,
		PRO_PROJECTS.COMPANY_ID,
		PRO_PROJECTS.CONSUMER_ID,
		PRO_PROJECTS.PARTNER_ID,
		PRO_PROJECTS.PROJECT_EMP_ID,
		(SELECT EMPLOYEE_NAME +' '+ EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = PROJECT_EMP_ID) PRO_EMPLOYEE,
		PRO_PROJECTS.OUTSRC_PARTNER_ID,
		PRO_PROJECTS.TARGET_FINISH,
		PRO_PROJECTS.TARGET_START,
		PRO_PROJECTS.PRO_PRIORITY_ID,
		PRO_PROJECTS.PRO_CURRENCY_ID,
		PRO_PROJECTS.PROCESS_CAT,
		PRO_PROJECTS.WORKGROUP_ID,
		PRO_PROJECTS.PROJECT_NUMBER,
		SETUP_PRIORITY.COLOR,
        EX.EXPENSE_ID,
        EX.EXPENSE,
        <!---baglanti kullanildiginda baglanti ile iliskili odeme yontemi var ise bilgilerini atıyor FA31012013 --->
        PROJECT_DISCOUNTS.PAYMETHOD_ID,
        PROJECT_DISCOUNTS.CARD_PAYMETHOD_ID,
        (CASE WHEN PROJECT_DISCOUNTS.PAYMETHOD_ID IS NOT NULL THEN 
        	(SELECT PAYMETHOD FROM SETUP_PAYMETHOD SP WHERE SP.PAYMETHOD_ID = PROJECT_DISCOUNTS.PAYMETHOD_ID)
        WHEN PROJECT_DISCOUNTS.CARD_PAYMETHOD_ID IS NOT NULL THEN
       		(SELECT CARD_NO FROM #dsn3_alias#.CREDITCARD_PAYMENT_TYPE CPT WHERE CPT.PAYMENT_TYPE_ID = PROJECT_DISCOUNTS.CARD_PAYMETHOD_ID)
        ELSE NULL END) AS PAYMETHOD_NAME,
        (CASE WHEN PROJECT_DISCOUNTS.PAYMETHOD_ID IS NOT NULL THEN 
        	(SELECT DUE_DAY FROM SETUP_PAYMETHOD SP WHERE SP.PAYMETHOD_ID = PROJECT_DISCOUNTS.PAYMETHOD_ID)
        ELSE NULL END) AS PAYMENT_DUEDAY,
        (CASE WHEN PROJECT_DISCOUNTS.PAYMETHOD_ID IS NOT NULL THEN 
        	(SELECT PAYMENT_VEHICLE FROM SETUP_PAYMETHOD SP WHERE SP.PAYMETHOD_ID = PROJECT_DISCOUNTS.PAYMETHOD_ID)
        ELSE NULL END) AS PAYMENT_VEHICLE,
        (CASE WHEN PROJECT_DISCOUNTS.CARD_PAYMETHOD_ID IS NOT NULL THEN
       		(SELECT COMMISSION_MULTIPLIER FROM #dsn3_alias#.CREDITCARD_PAYMENT_TYPE CPT WHERE CPT.PAYMENT_TYPE_ID = PROJECT_DISCOUNTS.CARD_PAYMETHOD_ID)
        ELSE NULL END) AS COMMISSION_RATE
        <!---baglanti kullanildiginda baglanti ile iliskili odeme yontemi var ise bilgilerini atıyor FA31012013 --->
	FROM 
		PRO_PROJECTS
		LEFT JOIN SETUP_PRIORITY ON PRO_PROJECTS.PRO_PRIORITY_ID = SETUP_PRIORITY.PRIORITY_ID
        LEFT JOIN #dsn3_alias#.PROJECT_DISCOUNTS ON PROJECT_DISCOUNTS.PROJECT_ID = PRO_PROJECTS.PROJECT_ID
        LEFT JOIN #dsn2_alias#.EXPENSE_CENTER EX ON EX.EXPENSE_CODE = PRO_PROJECTS.EXPENSE_CODE
	WHERE 
		1 = 1
		<cfif isDefined('session.pp.userid')>
			AND
			(
				PRO_PROJECTS.OUTSRC_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> OR
				PRO_PROJECTS.OUTSRC_CMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> OR
				PRO_PROJECTS.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> OR
				PRO_PROJECTS.UPDATE_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> OR
				PRO_PROJECTS.RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
			)
		</cfif>
		<cfif isDefined("attributes.project_cat") and len(attributes.project_cat)>
			AND PRO_PROJECTS.PROCESS_CAT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_cat#" list="yes">)
		<cfelse>
			AND PRO_PROJECTS.PROCESS_CAT IN
			(
				SELECT  
					SMC.MAIN_PROCESS_CAT_ID
				FROM 
					SETUP_MAIN_PROCESS_CAT SMC,
					SETUP_MAIN_PROCESS_CAT_ROWS SMR,
					EMPLOYEE_POSITIONS
				WHERE
					SMC.MAIN_PROCESS_CAT_ID=SMR.MAIN_PROCESS_CAT_ID AND
                    <cfif isDefined('session.ep.userid')>
						EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND 
					</cfif>
                    ( EMPLOYEE_POSITIONS.POSITION_CAT_ID = SMR.MAIN_POSITION_CAT_ID OR EMPLOYEE_POSITIONS.POSITION_CODE=SMR.MAIN_POSITION_CODE )
			)
	    </cfif>
		<cfif len(attributes.keyword) gt 1>
			AND (
					PRO_PROJECTS.PROJECT_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					PRO_PROJECTS.AGREEMENT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR
					PRO_PROJECTS.PROJECT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					PRO_PROJECTS.PROJECT_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_longvarchar" value="%#attributes.keyword#%">
				)
		<cfelseif len(attributes.keyword) eq 1>
			AND (
					PRO_PROJECTS.PROJECT_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR
					PRO_PROJECTS.PROJECT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
				)
		</cfif>
		<cfif len(attributes.currency)>
			AND PRO_PROJECTS.PRO_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.currency#">
		</cfif>
		<cfif len(attributes.priority_cat)>
			AND PRO_PROJECTS.PRO_PRIORITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.priority_cat#">
		</cfif>
		<cfif isdefined("attributes.project_status") and attributes.project_status is "1">
			AND PRO_PROJECTS.PROJECT_STATUS = 1
		<cfelseif isdefined("attributes.project_status") and attributes.project_status is "-1">
			AND PRO_PROJECTS.PROJECT_STATUS = 0 
		<cfelseif isdefined("attributes.project_status") and attributes.project_status is "0">
			AND (PRO_PROJECTS.PROJECT_STATUS = 0 OR PRO_PROJECTS.PROJECT_STATUS = 1)
		<cfelse><!--- default secim --->
			AND PRO_PROJECTS.PROJECT_STATUS = 1
		</cfif>
		<cfif isdefined("attributes.member_type_") and (attributes.member_type_ is 'PARTNER') and len(attributes.member_name_) and len(attributes.company_id_)>
			AND PRO_PROJECTS.COMPANY_ID = #attributes.company_id_#
		</cfif>
		<cfif isdefined("attributes.member_type_") and (attributes.member_type_ is 'CONSUMER') and len(attributes.member_name_) and len(attributes.consumer_id_)>
			AND PRO_PROJECTS.CONSUMER_ID = #attributes.consumer_id_#
		</cfif>
		<cfif isDefined("is_control_branch_project") and is_control_branch_project eq 1>
			<cfif isDefined('session.ep.position_code')>
				AND PRO_PROJECTS.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
			</cfif>
		</cfif>
	ORDER BY
		PROJECT_HEAD
</cfquery>