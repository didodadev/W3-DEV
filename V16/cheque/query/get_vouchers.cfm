<cfsetting showdebugoutput="yes">
<cfif len(attributes.due_start_date) and isdate(attributes.due_start_date)>
	<cf_date tarih = "attributes.due_start_date">
</cfif>
<cfif len(attributes.due_finish_date) and isdate(attributes.due_finish_date)>
	<cf_date tarih = "attributes.due_finish_date">
</cfif>
<cfif len(attributes.record_date1) and isdate(attributes.record_date1)>
	<cf_date tarih = "attributes.record_date1">
</cfif>
<cfif len(attributes.record_date2) and isdate(attributes.record_date2)>
	<cf_date tarih = "attributes.record_date2">
</cfif>
<cfif len(attributes.payroll_date1) and isdate(attributes.payroll_date1)>
	<cf_date tarih = "attributes.payroll_date1">
</cfif>
<cfif len(attributes.payroll_date2) and isdate(attributes.payroll_date2)>
	<cf_date tarih = "attributes.payroll_date2">
</cfif>
<cfquery name="GET_VOUCHERS" datasource="#DSN2#">
	SELECT
        VOUCHER.VOUCHER_ID,
        VOUCHER.VOUCHER_PAYROLL_ID,
        VOUCHER.VOUCHER_CODE,
        VOUCHER.VOUCHER_DUEDATE,
        VOUCHER.VOUCHER_NO,
        VOUCHER.VOUCHER_VALUE,
        VOUCHER.CURRENCY_ID,
        ISNULL(CO.FULLNAME, ISNULL(CON.CONSUMER_NAME + ' ' + CON.CONSUMER_SURNAME, EMP.EMPLOYEE_NAME + ' ' + EMP.EMPLOYEE_SURNAME)) AS FULLNAME,
        ISNULL(CO.COMPANY_ID, ISNULL(CON.CONSUMER_ID, EMP.EMPLOYEE_ID)) AS ID,
        CASE 
            WHEN CO.COMPANY_ID IS NOT NULL
                THEN 'com'
            WHEN CON.CONSUMER_ID IS NOT NULL
                THEN 'con'
            WHEN EMP.EMPLOYEE_ID IS NOT NULL
                THEN 'emp'
            END AS LINK,
        CASE 
            WHEN CO.COMPANY_ID IS NOT NULL
                THEN 'company_id'
            WHEN CON.CONSUMER_ID IS NOT NULL
                THEN 'con_id'
            WHEN EMP.EMPLOYEE_ID IS NOT NULL
                THEN 'emp_id'
            END AS LINK2,
        CASE 
            WHEN CO.COMPANY_ID IS NOT NULL
                THEN 'company'
            WHEN CON.CONSUMER_ID IS NOT NULL
                THEN 'consumer'
            WHEN EMP.EMPLOYEE_ID IS NOT NULL
                THEN 'employee'
            END AS MEMBER_TYPE,
        VOUCHER.DEBTOR_NAME,
        VOUCHER.VOUCHER_STATUS_ID,
        VOUCHER.ACCOUNT_NO,
        VOUCHER.VOUCHER_PURSE_NO,
        VOUCHER.ACCOUNT_CODE,
        VOUCHER.OTHER_MONEY,
        VOUCHER.OTHER_MONEY_VALUE,
        VOUCHER.OTHER_MONEY2,
        VOUCHER.OTHER_MONEY_VALUE2,
        VOUCHER.IS_PAY_TERM,
        VOUCHER.CASH_ID,
        VOUCHER.CH_OTHER_MONEY_VALUE,
        VOUCHER.CH_OTHER_MONEY,
        VOUCHER.RECORD_DATE,
        VOUCHER_PAYROLL.PAYROLL_NO,
        VOUCHER_PAYROLL.COMPANY_ID,
        VOUCHER_PAYROLL.PAYROLL_CASH_ID,
        AC.ACCOUNT_ID AS VOUCHER_ACCOUNT_ID,
        NOTES.NOTE_BODY,
        NOTES.NOTE_ID,
        VOUCHER_REMAINING_AMOUNT.VOUCHER_ID,
        VOUCHER_REMAINING_AMOUNT.REMAINING_VALUE,                      
        VOUCHER_REMAINING_AMOUNT.OTHER_REMAINING_VALUE,
        VOUCHER_REMAINING_AMOUNT.OTHER_REMAINING_VALUE2,
        AC.ACCOUNT_NAME,
		(
			SELECT
				MAX(ISNULL(CH.ACT_DATE,CH.RECORD_DATE))
			FROM
				VOUCHER_HISTORY CH
			WHERE
				CH.VOUCHER_ID = VOUCHER.VOUCHER_ID
		) MAX_ACT_DATE,
		(SELECT TOP 1 VH.ACT_DATE FROM VOUCHER_HISTORY VH WHERE VH.VOUCHER_ID=VOUCHER.VOUCHER_ID AND VH.STATUS=3 ORDER BY VH.RECORD_DATE DESC) TAHSILAT_TARIHI,
		(SELECT COUNT(VH.VOUCHER_ID) FROM VOUCHER_HISTORY VH WHERE VH.VOUCHER_ID=VOUCHER.VOUCHER_ID) VOUCHER_HIST
	FROM
		VOUCHER
        <cfif session.ep.isBranchAuthorization and not (isdefined("attributes.cash") and len(attributes.cash)) and not len(attributes.account_id)>
        	LEFT JOIN #dsn2_alias#.CASH C ON VOUCHER.CASH_ID = C.CASH_ID
		</cfif>
	LEFT JOIN VOUCHER_PAYROLL ON VOUCHER_PAYROLL.ACTION_ID = <cfif isDefined("attributes.account_id") and len(attributes.account_id)>(SELECT MAX(PAYROLL_ID) PAYROLL_ID FROM VOUCHER_HISTORY WHERE VOUCHER_HISTORY.VOUCHER_ID = VOUCHER.VOUCHER_ID AND VOUCHER_HISTORY.PAYROLL_ID IS NOT NULL)<cfelse>VOUCHER.VOUCHER_PAYROLL_ID</cfif>
        LEFT JOIN #dsn_alias#.NOTES ON VOUCHER.VOUCHER_ID = NOTES.ACTION_ID AND NOTES.ACTION_SECTION='VOUCHER.VOUCHER_ID'
        LEFT JOIN #dsn_alias#.COMPANY AS CO ON CO.COMPANY_ID = ISNULL(VOUCHER.OWNER_COMPANY_ID, VOUCHER.COMPANY_ID)
        LEFT JOIN #dsn_alias#.CONSUMER AS CON ON CON.CONSUMER_ID = ISNULL(VOUCHER.OWNER_CONSUMER_ID, VOUCHER.CONSUMER_ID)
        LEFT JOIN #dsn_alias#.EMPLOYEES AS EMP ON EMP.EMPLOYEE_ID = ISNULL(VOUCHER.OWNER_EMPLOYEE_ID, VOUCHER.EMPLOYEE_ID)
        LEFT JOIN VOUCHER_REMAINING_AMOUNT ON VOUCHER_REMAINING_AMOUNT.VOUCHER_ID=VOUCHER.VOUCHER_ID
         LEFT JOIN #dsn3_alias#.ACCOUNTS AS AC ON AC.ACCOUNT_ID=  
             
            (SELECT TOP 1
                PAYROLL_ACCOUNT_ID
            FROM
                VOUCHER_PAYROLL P,
                VOUCHER_HISTORY CH
            WHERE
                P.ACTION_ID = CH.PAYROLL_ID AND
                CH.VOUCHER_ID = VOUCHER.VOUCHER_ID AND
                P.PAYROLL_TYPE IN (99,100,109,107) AND
                P.PAYROLL_ACCOUNT_ID IS NOT NULL
            ORDER BY
                P.ACTION_ID DESC
            ) 
		<cfif (isDefined("attributes.account_id") and len(attributes.account_id)) or (session.ep.isBranchAuthorization and not (isdefined("attributes.cash") and len(attributes.cash)) and not len(attributes.account_id))>
		,VOUCHER_HISTORY
		</cfif>
	WHERE
		VOUCHER.VOUCHER_ID IS NOT NULL
		<cfif not((isDefined("attributes.account_id") and len(attributes.account_id)) or (session.ep.isBranchAuthorization and not (isdefined("attributes.cash") and len(attributes.cash)) and not len(attributes.account_id)))>
			AND VOUCHER.VOUCHER_PAYROLL_ID = VOUCHER_PAYROLL.ACTION_ID
		</cfif>
		<cfif isDefined("attributes.status") and len(attributes.status)>
			AND VOUCHER_STATUS_ID IN (#attributes.status#)
		</cfif>
		<cfif len(attributes.company) and len(attributes.company_id) and attributes.member_type eq 'partner'>
			AND (VOUCHER_PAYROLL.COMPANY_ID = #attributes.company_id# OR VOUCHER.COMPANY_ID = #attributes.company_id# OR VOUCHER.OWNER_COMPANY_ID = #attributes.company_id#)
		<cfelseif len(attributes.company) and len(attributes.consumer_id) and attributes.member_type eq 'consumer'>
			AND (VOUCHER_PAYROLL.CONSUMER_ID = #attributes.consumer_id# OR VOUCHER.CONSUMER_ID = #attributes.consumer_id# OR VOUCHER.OWNER_CONSUMER_ID = #attributes.consumer_id#)	
		<cfelseif len(attributes.company) and len(attributes.employee_id) and attributes.member_type eq 'employee'>
			AND (VOUCHER_PAYROLL.EMPLOYEE_ID = #attributes.employee_id# OR VOUCHER.EMPLOYEE_ID = #attributes.employee_id# OR VOUCHER.OWNER_EMPLOYEE_ID = #attributes.employee_id#)	
		</cfif>
		<cfif len(attributes.owner_company) and len(attributes.owner_company_id) and attributes.owner_member_type eq 'partner'>
			AND VOUCHER.OWNER_COMPANY_ID = #attributes.owner_company_id#
		<cfelseif len(attributes.owner_company) and len(attributes.owner_consumer_id) and attributes.owner_member_type eq 'consumer'>
			AND VOUCHER.OWNER_CONSUMER_ID = #attributes.owner_consumer_id#
		<cfelseif len(attributes.owner_company) and len(attributes.owner_employee_id) and attributes.owner_member_type eq 'employee'>
			AND VOUCHER.OWNER_EMPLOYEE_ID = #attributes.owner_employee_id#
		</cfif>
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND ( VOUCHER_PURSE_NO = '#attributes.keyword#' OR VOUCHER_NO = '#attributes.keyword#' OR VOUCHER_CODE = '#attributes.keyword#')
		</cfif>
		<cfif isdate(attributes.due_start_date)>
			AND VOUCHER.VOUCHER_DUEDATE >=#attributes.due_start_date#
		</cfif>
		<cfif isdate(attributes.due_finish_date)>
			AND VOUCHER.VOUCHER_DUEDATE <=#attributes.due_finish_date#
		</cfif>
		<cfif isdate(attributes.record_date1)>
			AND VOUCHER.RECORD_DATE >=#attributes.record_date1#
		</cfif>
		<cfif isdate(attributes.record_date2)>
			AND VOUCHER.RECORD_DATE < #dateadd("d",1,attributes.record_date2)#
		</cfif>
		<cfif len(attributes.debt_company)>
			AND DEBTOR_NAME LIKE '%#attributes.debt_company#%'
		</cfif>
		<cfif isdefined("attributes.money_type") and len(attributes.money_type)>
			AND VOUCHER.CURRENCY_ID = '#attributes.money_type#'
		</cfif>
		<cfif isdefined("attributes.cash") and len(attributes.cash)>
			AND VOUCHER.VOUCHER_PAYROLL_ID = VOUCHER_PAYROLL.ACTION_ID
			AND VOUCHER.CASH_ID = #attributes.cash#
		</cfif>
		<cfif isDefined("attributes.account_id") and len(attributes.account_id)>
			AND VOUCHER_HISTORY.HISTORY_ID = (SELECT MAX(HISTORY_ID) HISTORY_ID FROM VOUCHER_HISTORY WHERE VOUCHER_HISTORY.VOUCHER_ID = VOUCHER.VOUCHER_ID AND VOUCHER_HISTORY.PAYROLL_ID IS NOT NULL)
			AND VOUCHER_HISTORY.PAYROLL_ID = VOUCHER_PAYROLL.ACTION_ID
			AND VOUCHER_HISTORY.VOUCHER_ID = VOUCHER.VOUCHER_ID
			AND
				(
					VOUCHER_PAYROLL.PAYROLL_ACCOUNT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account_id#" list="yes">)
					AND VOUCHER_PAYROLL.PAYROLL_TYPE IN (99,100,109,107)
				)
		</cfif>
		<cfif session.ep.isBranchAuthorization and not (isdefined("attributes.cash") and len(attributes.cash)) and not len(attributes.account_id)>
			AND VOUCHER.VOUCHER_ID = VOUCHER_HISTORY.VOUCHER_ID
			AND VOUCHER_HISTORY.HISTORY_ID = (SELECT MAX(HISTORY_ID) HISTORY_ID FROM VOUCHER_HISTORY WHERE VOUCHER_HISTORY.VOUCHER_ID = VOUCHER.VOUCHER_ID AND VOUCHER_HISTORY.PAYROLL_ID IS NOT NULL)
			AND C.BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
		</cfif>
		<cfif isdate(attributes.payroll_date1)>
			AND VOUCHER_PAYROLL.PAYROLL_REVENUE_DATE >=#attributes.payroll_date1#
		</cfif>
		<cfif isdate(attributes.payroll_date2)>
			AND VOUCHER_PAYROLL.PAYROLL_REVENUE_DATE < #dateadd("d",1,attributes.payroll_date2)#
		</cfif>
		<cfif isdefined("attributes.paper_type") and len(attributes.paper_type)>
			AND VOUCHER.IS_PAY_TERM = #attributes.paper_type#
		</cfif>
		<cfif len(attributes.project_head) and isdefined("attributes.project_id") and len(attributes.project_id)>
			AND VOUCHER_PAYROLL.PROJECT_ID = #attributes.project_id# 
		</cfif>
	<cfif isDefined('attributes.oby') and attributes.oby eq 2>
		ORDER BY VOUCHER_DUEDATE
	<cfelseif isDefined('attributes.oby') and attributes.oby eq 3>
		ORDER BY VOUCHER_PURSE_NO
	<cfelseif isDefined('attributes.oby') and attributes.oby eq 4>
		ORDER BY VOUCHER_PURSE_NO DESC
	<cfelse>
		ORDER BY VOUCHER_DUEDATE DESC
	</cfif>
</cfquery>
