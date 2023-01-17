<cfif isdefined("attributes.employee_id")>
	<cfscript>
    	attributes.acc_type_id = '';
		if(listlen(attributes.employee_id,'_') eq 2)
		{
			attributes.acc_type_id = listlast(attributes.employee_id,'_');
			attributes.emp_id = listfirst(attributes.employee_id,'_');
		}
		else
			attributes.emp_id = attributes.employee_id;
    </cfscript>
</cfif>
<cfif len(attributes.start_date) and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
</cfif>
<cfif len(attributes.finish_date) and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
</cfif>
<cfquery name="GET_CHEQUE_ACTIONS" datasource="#dsn2#">
	SELECT
        P.ACTION_ID,
        P.PAYROLL_NO,
        P.PAYROLL_TYPE,
        P.PAYROLL_REVENUE_DATE,
        ISNULL(COM.FULLNAME, ISNULL(CON.CONSUMER_NAME + ' ' + CON.CONSUMER_SURNAME, EMP.EMPLOYEE_NAME + ' ' + EMP.EMPLOYEE_SURNAME)) AS FULLNAME,
        CASH.CASH_NAME,
        AC.ACCOUNT_NAME,
        P.PAYROLL_AVG_DUEDATE,
        P.PAYROLL_TOTAL_VALUE,
        P.CURRENCY_ID,
        IIF(P.PAYROLL_TYPE = 135,P.TRANSFER_CASH_ID,P.PAYROLL_CASH_ID) PAYROLL_CASH_ID,
        P.PAYROLL_ACCOUNT_ID,
        P.PROCESS_CAT,
        P.PAYMENT_ORDER_ID,
		P.PAYROLL_OTHER_MONEY_VALUE,
		P.PAYROLL_OTHER_MONEY,
		(P.PAYROLL_TOTAL_VALUE/PM.RATE2) PAYROLL_OTHER_MONEY_VALUE2
	FROM
		PAYROLL P
        LEFT JOIN #dsn3_alias#.ACCOUNTS AC ON P.PAYROLL_ACCOUNT_ID=AC.ACCOUNT_ID
        LEFT JOIN CASH ON CASH.CASH_ID=IIF(P.PAYROLL_TYPE = 135,P.TRANSFER_CASH_ID,P.PAYROLL_CASH_ID)
        LEFT JOIN #dsn_alias#.COMPANY AS COM ON P.COMPANY_ID=COM.COMPANY_ID
        LEFT JOIN #dsn_alias#.CONSUMER AS CON ON P.CONSUMER_ID=CON.CONSUMER_ID
        LEFT JOIN #dsn_alias#.EMPLOYEES AS EMP ON P.EMPLOYEE_ID=EMP.EMPLOYEE_ID
        LEFT JOIN PAYROLL_MONEY AS PM ON PM.ACTION_ID = P.ACTION_ID AND PM.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
	WHERE
		P.ACTION_ID IS NOT NULL AND P.PAYROLL_TYPE <> 106
	<cfif isdefined("attributes.account_id") and len(attributes.account_id)>
		AND 
		(P.ACTION_ID IN 
		(SELECT
			CHEQUE_HISTORY.PAYROLL_ID
		FROM
			CHEQUE_HISTORY,
			CHEQUE
		WHERE
			CHEQUE.CHEQUE_ID = CHEQUE_HISTORY.CHEQUE_ID AND
			CHEQUE_HISTORY.PAYROLL_ID IS NOT NULL AND
			CHEQUE.ACCOUNT_ID = #attributes.account_id#)
		OR P.PAYROLL_ACCOUNT_ID = #attributes.account_id#
		)
	</cfif>
	<cfif isdefined('attributes.project_head') and len(attributes.project_head) and len(attributes.project_id)>
    	<cfif attributes.project_id eq -1>
        	AND P.PROJECT_ID IS NULL
		<cfelse>
			AND P.PROJECT_ID = #attributes.project_id#
        </cfif>	
	</cfif>
	<cfif len(attributes.page_action_type) and listlast(attributes.page_action_type,'-') eq 0>
		AND P.PAYROLL_TYPE = #listfirst(attributes.page_action_type,'-')#
	<cfelseif len(attributes.page_action_type) and listlast(attributes.page_action_type,'-') neq 0>
		AND P.PROCESS_CAT = #listlast(attributes.page_action_type,'-')#
	<cfelse>
		AND P.PAYROLL_TYPE IS NOT NULL
	</cfif>
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND P.PAYROLL_NO LIKE '#attributes.keyword#%' 
	</cfif>
	<cfif isDefined("attributes.cheque_number") and len(attributes.cheque_number)>
		AND P.ACTION_ID IN 
		(SELECT
			CHEQUE_HISTORY.PAYROLL_ID
		FROM
			CHEQUE_HISTORY,
			CHEQUE
		WHERE
			CHEQUE.CHEQUE_ID = CHEQUE_HISTORY.CHEQUE_ID AND
			CHEQUE_HISTORY.PAYROLL_ID IS NOT NULL AND
			(CHEQUE.CHEQUE_NO = '#attributes.cheque_number#' OR CHEQUE.CHEQUE_CODE = '#attributes.cheque_number#'))
	</cfif>
	<cfif isdate(attributes.start_date) and not isdate(attributes.finish_date)>
		AND PAYROLL_REVENUE_DATE >= #attributes.start_date#
	<cfelseif isdate(attributes.finish_date) and not isdate(attributes.start_date)>
		AND PAYROLL_REVENUE_DATE <= #attributes.finish_date#
	<cfelseif isdate(attributes.start_date) and  isdate(attributes.finish_date)>
		AND PAYROLL_REVENUE_DATE >= #attributes.start_date#
		AND PAYROLL_REVENUE_DATE <= #attributes.finish_date#
	</cfif>
	<cfif len(attributes.company) and len(attributes.company_id) and attributes.member_type eq 'partner'>
		AND P.COMPANY_ID = #attributes.company_id#
	<cfelseif len(attributes.company) and len(attributes.consumer_id) and attributes.member_type eq 'consumer'>
		AND P.CONSUMER_ID = #attributes.consumer_id#
	<cfelseif len(attributes.company) and len(attributes.employee_id) and attributes.member_type eq 'employee'>
		AND P.EMPLOYEE_ID = #attributes.emp_id#
	</cfif>
	<cfif isdefined("attributes.record_emp_id") and len(attributes.record_emp_id) and len(attributes.record_emp_name)>
		AND P.RECORD_EMP = #attributes.record_emp_id#
	</cfif>
    <cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
        AND P.ACC_TYPE_ID = #attributes.acc_type_id#
    </cfif>
	<cfif isDefined("attributes.special_definition_id") and len(attributes.special_definition_id) and attributes.special_definition_id eq '-1'>
		AND SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 1)
	<cfelseif isDefined("attributes.special_definition_id") and len(attributes.special_definition_id) and attributes.special_definition_id eq '-2'>
		AND SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 2)
	<cfelseif isDefined("attributes.special_definition_id") and len(attributes.special_definition_id)>
		AND SPECIAL_DEFINITION_ID = #attributes.special_definition_id#
	</cfif>
	<cfif session.ep.isBranchAuthorization>
		AND P.BRANCH_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">
	<cfelseif isdefined("attributes.branch_id") and len(attributes.branch_id)>
		AND P.BRANCH_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
	</cfif>
	<cfif isDefined('attributes.oby') and attributes.oby eq 2>
		ORDER BY P.RECORD_DATE
	<cfelseif isDefined('attributes.oby') and attributes.oby eq 3>
		ORDER BY P.PAYROLL_NO
	<cfelseif isDefined('attributes.oby') and attributes.oby eq 4>
		ORDER BY P.PAYROLL_NO DESC
	<cfelse>
		ORDER BY P.RECORD_DATE DESC
	</cfif>
</cfquery>

