<cfquery name="GET_CHEQUES" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
	SELECT PAYROLL.ACTION_ID,
        PAYROLL.PAYROLL_NO,
		PAYROLL.PROCESS_CAT,
        PAYROLL.PAYROLL_CASH_ID,
        PAYROLL.PAYROLL_TYPE,
        CHEQUE.CHEQUE_PAYROLL_ID,
        CHEQUE.CHEQUE_ID,
        CHEQUE.CHEQUE_CODE,
        CHEQUE.CHEQUE_DUEDATE,
        CHEQUE.CHEQUE_NO,
        CHEQUE.CHEQUE_STATUS_ID,
        CHEQUE.CHEQUE_PURSE_NO,
        CHEQUE.BANK_NAME,
        CHEQUE.BANK_BRANCH_NAME,
		AC.ACCOUNT_CURRENCY_ID,
        ISNULL(CO.FULLNAME,ISNULL(CON.CONSUMER_NAME + ' ' + CON.CONSUMER_SURNAME,EMP.EMPLOYEE_NAME + ' ' + EMP.EMPLOYEE_SURNAME)) AS FULLNAME,
        ISNULL(CO.COMPANY_ID,ISNULL(CON.CONSUMER_ID,EMP.EMPLOYEE_ID)) AS ID,
        CASE WHEN CO.COMPANY_ID IS NOT NULL THEN 'com'
              WHEN CON.CONSUMER_ID IS NOT NULL THEN 'con'
              WHEN EMP.EMPLOYEE_ID IS NOT NULL THEN 'emp'
        END AS LINK,
        CASE WHEN CO.COMPANY_ID IS NOT NULL THEN 'company_id'
              WHEN CON.CONSUMER_ID IS NOT NULL THEN 'consumer_id'
              WHEN EMP.EMPLOYEE_ID IS NOT NULL THEN 'employee_id'
        END AS LINK2,
        CASE WHEN CO.COMPANY_ID IS NOT NULL THEN 'company'
              WHEN CON.CONSUMER_ID IS NOT NULL THEN 'consumer'
              WHEN EMP.EMPLOYEE_ID IS NOT NULL THEN 'employee'
        END AS MEMBER_TYPE,
        CHEQUE.DEBTOR_NAME,
        NOTES.NOTE_BODY,
        NOTES.NOTE_ID,
        CHEQUE.CHEQUE_VALUE,
        CHEQUE.CURRENCY_ID,
        CHEQUE.OTHER_MONEY_VALUE,
        CHEQUE.OTHER_MONEY,
        CHEQUE.OTHER_MONEY_VALUE2,
        CHEQUE.OTHER_MONEY2,
        CHEQUE.RECORD_DATE,
		(
			SELECT
				MAX(ISNULL(CH.ACT_DATE,CH.RECORD_DATE))
			FROM
				CHEQUE_HISTORY CH
			WHERE
				CH.CHEQUE_ID = CHEQUE.CHEQUE_ID
		) MAX_ACT_DATE,
		AC.ACCOUNT_NAME,
        ISNULL
			(
				(SELECT TOP 1
					PAYROLL_ACCOUNT_ID
				FROM
					PAYROLL P,
					CHEQUE_HISTORY CH
				WHERE
					P.ACTION_ID = CH.PAYROLL_ID AND
					CH.CHEQUE_ID = CHEQUE.CHEQUE_ID AND
					P.PAYROLL_TYPE IN (93,105,106,133) AND
					P.PAYROLL_ACCOUNT_ID IS NOT NULL
				ORDER BY
					P.ACTION_ID DESC
					),CHEQUE.ACCOUNT_ID
			)AS CHEQUE_ACCOUNT_ID
	FROM
		PAYROLL,
		CHEQUE
        LEFT JOIN #dsn_alias#.NOTES ON CHEQUE.CHEQUE_ID = NOTES.ACTION_ID AND ACTION_SECTION = 'CHEQUE_ID' AND NOTES.COMPANY_ID = #session.ep.company_id#
        LEFT JOIN #dsn_alias#.COMPANY AS CO ON CO.COMPANY_ID = ISNULL(CHEQUE.OWNER_COMPANY_ID, CHEQUE.COMPANY_ID)
        LEFT JOIN #dsn_alias#.CONSUMER AS CON ON CON.CONSUMER_ID = ISNULL(CHEQUE.OWNER_CONSUMER_ID, CHEQUE.CONSUMER_ID)
        LEFT JOIN #dsn_alias#.EMPLOYEES AS EMP ON EMP.EMPLOYEE_ID = ISNULL(CHEQUE.OWNER_EMPLOYEE_ID, CHEQUE.EMPLOYEE_ID)
        LEFT JOIN #dsn3_alias#.ACCOUNTS AS AC ON AC.ACCOUNT_ID=ISNULL(
        		(SELECT TOP 1
					PAYROLL_ACCOUNT_ID
				FROM
					PAYROLL P,
					CHEQUE_HISTORY CH
				WHERE
					P.ACTION_ID = CH.PAYROLL_ID AND
					CH.CHEQUE_ID = CHEQUE.CHEQUE_ID AND
					P.PAYROLL_TYPE IN (93,105,106,133) AND
					P.PAYROLL_ACCOUNT_ID IS NOT NULL
				ORDER BY
					P.ACTION_ID DESC
					),CHEQUE.ACCOUNT_ID)
         
		<cfif (isDefined("attributes.account_id") and len(attributes.account_id)) or (session.ep.isBranchAuthorization and not (isdefined("attributes.cash") and len(attributes.cash)) and not len(attributes.account_id))>
			,CHEQUE_HISTORY
		</cfif>
	WHERE
		CHEQUE.CHEQUE_ID IS NOT NULL
	<cfif not((isDefined("attributes.account_id") and len(attributes.account_id)) or (session.ep.isBranchAuthorization and not (isdefined("attributes.cash") and len(attributes.cash)) and not len(attributes.account_id)))>
		AND CHEQUE.CHEQUE_PAYROLL_ID = PAYROLL.ACTION_ID
	</cfif>
	<cfif len(attributes.company) and len(attributes.company_id) and attributes.member_type eq 'partner'>
		AND 
		(
			CHEQUE.CHEQUE_ID IN
			(
				SELECT
					C.CHEQUE_ID
				FROM
					CHEQUE C,
					CHEQUE_HISTORY CH,
					PAYROLL P
				WHERE
					C.CHEQUE_ID = CH.CHEQUE_ID
					AND CH.PAYROLL_ID = P.ACTION_ID
					AND P.COMPANY_ID = #attributes.company_id#
					AND P.PAYROLL_TYPE = 91
			)
			OR CHEQUE.COMPANY_ID = #attributes.company_id#
		)
	<cfelseif len(attributes.company) and len(attributes.consumer_id) and attributes.member_type eq 'consumer'>
		AND 
		(
			CHEQUE.CHEQUE_ID IN
			(
				SELECT
					C.CHEQUE_ID
				FROM
					CHEQUE C,
					CHEQUE_HISTORY CH,
					PAYROLL P
				WHERE
					C.CHEQUE_ID = CH.CHEQUE_ID
					AND CH.PAYROLL_ID = P.ACTION_ID
					AND P.CONSUMER_ID = #attributes.consumer_id#
					AND P.PAYROLL_TYPE = 91
			)
			OR CHEQUE.CONSUMER_ID = #attributes.consumer_id#
		)
	<cfelseif len(attributes.company) and len(attributes.employee_id) and attributes.member_type eq 'employee'>
		AND 
		(
			CHEQUE.CHEQUE_ID IN
			(
				SELECT
					C.CHEQUE_ID
				FROM
					CHEQUE C,
					CHEQUE_HISTORY CH,
					PAYROLL P
				WHERE
					C.CHEQUE_ID = CH.CHEQUE_ID
					AND CH.PAYROLL_ID = P.ACTION_ID
					AND P.EMPLOYEE_ID = #attributes.employee_id#
					AND P.PAYROLL_TYPE = 91
			)
			OR CHEQUE.EMPLOYEE_ID = #attributes.employee_id#
		)
	</cfif>
    <cfif len(attributes.owner_company) and len(attributes.owner_company_id) and attributes.owner_member_type eq 'partner'>
		AND CHEQUE.OWNER_COMPANY_ID = #attributes.owner_company_id#
	<cfelseif len(attributes.owner_company) and len(attributes.owner_consumer_id) and attributes.owner_member_type eq 'consumer'>
		AND CHEQUE.OWNER_CONSUMER_ID = #attributes.owner_consumer_id#
	<cfelseif len(attributes.owner_company) and len(attributes.owner_employee_id) and attributes.owner_member_type eq 'employee'>
		AND CHEQUE.OWNER_EMPLOYEE_ID = #attributes.owner_employee_id#
	</cfif>
	<cfif isdefined("attributes.cash") and len(attributes.cash)>
		AND CHEQUE.CHEQUE_PAYROLL_ID = PAYROLL.ACTION_ID
		AND CHEQUE.CASH_ID = #attributes.cash#
	</cfif>
	<cfif isDefined("attributes.account_id") and len(attributes.account_id)>
		AND CHEQUE_HISTORY.HISTORY_ID = (SELECT MAX(HISTORY_ID) HISTORY_ID FROM CHEQUE_HISTORY WHERE CHEQUE_HISTORY.CHEQUE_ID = CHEQUE.CHEQUE_ID AND CHEQUE_HISTORY.PAYROLL_ID IS NOT NULL)
		AND CHEQUE_HISTORY.PAYROLL_ID = PAYROLL.ACTION_ID
		AND CHEQUE_HISTORY.CHEQUE_ID = CHEQUE.CHEQUE_ID
		AND (
			(
				PAYROLL.PAYROLL_ACCOUNT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account_id#" list="yes">)
				AND PAYROLL.PAYROLL_TYPE IN (93,105,106,133)
			)
			OR
			(
				CHEQUE.ACCOUNT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account_id#" list="yes">)
				AND PAYROLL.PAYROLL_TYPE IN (91,106)
			)	
		)
	</cfif>
	<cfif len(attributes.debt_company)>
		AND DEBTOR_NAME LIKE '%#attributes.debt_company#%'
	</cfif>
	<cfif isdefined("attributes.status") and len(attributes.status)>
		AND CHEQUE_STATUS_ID IN (#attributes.STATUS#)
	</cfif>
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND	( CHEQUE_PURSE_NO LIKE '#attributes.keyword#' OR CHEQUE_NO LIKE '#attributes.keyword#' OR CHEQUE_CODE LIKE '#attributes.keyword#%')
	</cfif>
	<cfif isDefined("attributes.list_bank_name") and len(attributes.list_bank_name)>
		AND	BANK_NAME LIKE '%#attributes.list_bank_name#%'
	</cfif>
	<cfif isDefined("attributes.list_bank_branch_name") and len(attributes.list_bank_branch_name)>
		AND	BANK_BRANCH_NAME LIKE '%#attributes.list_bank_branch_name#%'
	</cfif>
	<cfif isdefined("attributes.money_type") and len(attributes.money_type)>
		AND CHEQUE.CURRENCY_ID = '#attributes.money_type#'
	</cfif>
	<cfif isdate(attributes.start_date)>
		AND CHEQUE.CHEQUE_DUEDATE >=#attributes.start_date#
	</cfif>
	<cfif isdate(attributes.finish_date)>
		AND CHEQUE.CHEQUE_DUEDATE <=#attributes.finish_date#
	</cfif>
	<cfif isdate(attributes.record_date1)>
		AND CHEQUE.RECORD_DATE >=#attributes.record_date1#
	</cfif>
	<cfif isdate(attributes.record_date2)>
		AND CHEQUE.RECORD_DATE < #dateadd("d",1,attributes.record_date2)#
	</cfif>
	<cfif isdate(attributes.payroll_date1)>
		AND PAYROLL.PAYROLL_REVENUE_DATE >=#attributes.payroll_date1#
	</cfif>
	<cfif isdate(attributes.payroll_date2)>
		AND PAYROLL.PAYROLL_REVENUE_DATE < #dateadd("d",1,attributes.payroll_date2)#
	</cfif>
	<cfif len(attributes.project_head) and isdefined("attributes.project_id") and len(attributes.project_id)>
		AND PAYROLL.PROJECT_ID = #attributes.project_id# 
	</cfif>
	<!---  Şube tarafındaki düzenlemeler sonrasında eklendi Sadece şubeye ait bankalardaki veya kasalardaki çekleri getiriyor. --->
	<cfif session.ep.isBranchAuthorization and not (isdefined("attributes.cash") and len(attributes.cash)) and not len(attributes.account_id)>
		AND CHEQUE_HISTORY.HISTORY_ID = (SELECT MAX(HISTORY_ID) HISTORY_ID FROM CHEQUE_HISTORY WHERE CHEQUE_HISTORY.CHEQUE_ID = CHEQUE.CHEQUE_ID AND CHEQUE_HISTORY.PAYROLL_ID IS NOT NULL)
		AND CHEQUE_HISTORY.PAYROLL_ID = PAYROLL.ACTION_ID
		AND PAYROLL.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">
	</cfif>	
	<cfif attributes.oby eq 2>
		ORDER BY CHEQUE.CHEQUE_DUEDATE
	<cfelseif attributes.oby eq 3>
		ORDER BY CHEQUE_PURSE_NO
	<cfelseif attributes.oby eq 4>
		ORDER BY CHEQUE_PURSE_NO DESC
	<cfelse>
		ORDER BY CHEQUE.CHEQUE_DUEDATE DESC
	</cfif>
</cfquery>