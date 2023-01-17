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
<cfquery name="GET_VOUCHER_ACTIONS" datasource="#dsn2#">
	SELECT
		VP.ACTION_ID,
        VP.PAYROLL_NO,
        VP.PAYROLL_TYPE,
        VP.PAYROLL_REVENUE_DATE,
        ISNULL(COM.FULLNAME, ISNULL(CON.CONSUMER_NAME + ' ' + CON.CONSUMER_SURNAME, EMP.EMPLOYEE_NAME + ' ' + EMP.EMPLOYEE_SURNAME)) AS FULLNAME,
        CASH.CASH_NAME,
        AC.ACCOUNT_NAME,
        VP.PAYROLL_AVG_DUEDATE,
        VP.PAYROLL_TOTAL_VALUE,
        VP.CURRENCY_ID,
        VP.PAYROLL_CASH_ID,
        VP.PAYROLL_ACCOUNT_ID,
        VP.PROCESS_CAT,
        VP.PAYMENT_ORDER_ID,
		BR.BRANCH_NAME BRANCH
	FROM
		VOUCHER_PAYROLL VP
        LEFT JOIN #dsn3#.ACCOUNTS AC ON VP.PAYROLL_ACCOUNT_ID=AC.ACCOUNT_ID
        LEFT JOIN CASH ON CASH.CASH_ID=VP.PAYROLL_CASH_ID
        LEFT JOIN #dsn#.COMPANY AS COM ON VP.COMPANY_ID=COM.COMPANY_ID
        LEFT JOIN #dsn#.CONSUMER AS CON ON VP.CONSUMER_ID=CON.CONSUMER_ID
        LEFT JOIN #dsn#.EMPLOYEES AS EMP ON VP.EMPLOYEE_ID=EMP.EMPLOYEE_ID
		LEFT JOIN #dsn_alias#.BRANCH BR ON VP.BRANCH_ID=BR.BRANCH_ID
 	WHERE
		VP.ACTION_ID IS NOT NULL AND ISNULL(VP.PAYROLL_NO,0) <> '-1' AND ISNULL(VP.PAYROLL_NO,0) <> '-2' AND VP.PAYROLL_TYPE <> 1057
	<cfif isdefined("attributes.account_id") and len(attributes.account_id)>
		AND VP.PAYROLL_ACCOUNT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account_id#" list="yes">)
	</cfif>    
	<cfif isdefined('attributes.project_head') and len(attributes.project_head) and len(attributes.project_id)>
		AND VP.PROJECT_ID = #attributes.project_id#	
	</cfif>
	<cfif len(attributes.company) and len(attributes.company_id) and attributes.member_type eq 'partner'>
		AND (VP.COMPANY_ID = #attributes.company_id#)
	<cfelseif len(attributes.company) and len(attributes.consumer_id) and attributes.member_type eq 'consumer'>
		AND (VP.CONSUMER_ID = #attributes.consumer_id#)	
	<cfelseif len(attributes.company) and len(attributes.employee_id) and attributes.member_type eq 'employee'>
		AND (VP.EMPLOYEE_ID = #attributes.emp_id#)	
	</cfif>
	<cfif isdefined("attributes.record_emp_id") and len(attributes.record_emp_id) and len(attributes.record_emp_name)>
		AND VP.RECORD_EMP = #attributes.record_emp_id#
	</cfif>
	<cfif len(attributes.page_action_type) and listlast(attributes.page_action_type,'-') eq 0>
		AND VP.PAYROLL_TYPE = #listfirst(attributes.page_action_type,'-')#
	<cfelseif len(attributes.page_action_type) and listlast(attributes.page_action_type,'-') neq 0>
		AND VP.PROCESS_CAT = #listlast(attributes.page_action_type,'-')#
	<cfelse>
		AND VP.PAYROLL_TYPE IS NOT NULL
	</cfif>
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND VP.PAYROLL_NO LIKE '%#attributes.keyword#%'
	</cfif>
	<cfif isDefined("attributes.voucher_number") and len(attributes.voucher_number)>
		AND VP.ACTION_ID IN 
		(SELECT
			VOUCHER_HISTORY.PAYROLL_ID
		FROM
			VOUCHER_HISTORY,
			VOUCHER
		WHERE
			VOUCHER.VOUCHER_ID = VOUCHER_HISTORY.VOUCHER_ID AND
			VOUCHER_HISTORY.PAYROLL_ID IS NOT NULL AND
			VOUCHER.VOUCHER_NO = '#attributes.voucher_number#')
	</cfif>
	<cfif isdate(attributes.start_date) and not isdate(attributes.finish_date)>
		AND VP.PAYROLL_REVENUE_DATE >= #attributes.start_date#
	<cfelseif isdate(attributes.finish_date) and not isdate(attributes.start_date)>
		AND VP.PAYROLL_REVENUE_DATE <= #attributes.finish_date#
	<cfelseif isdate(attributes.start_date) and  isdate(attributes.finish_date)>
		AND VP.PAYROLL_REVENUE_DATE >= #attributes.start_date#
		AND VP.PAYROLL_REVENUE_DATE <= #attributes.finish_date#
	</cfif>
	<cfif isDefined("attributes.special_definition_id") and len(attributes.special_definition_id) and attributes.special_definition_id eq '-1'>
		AND SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 1)
	<cfelseif isDefined("attributes.special_definition_id") and len(attributes.special_definition_id) and attributes.special_definition_id eq '-2'>
		AND SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 2)
	<cfelseif isDefined("attributes.special_definition_id") and len(attributes.special_definition_id)>
		AND SPECIAL_DEFINITION_ID = #attributes.special_definition_id#
	</cfif>
	<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
		AND VP.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
	<cfelseif session.ep.isBranchAuthorization>
	    AND VP.BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
	</cfif>
    <cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
        AND VP.ACC_TYPE_ID = #attributes.acc_type_id#
    </cfif>
	<cfif isDefined('attributes.oby') and attributes.oby eq 2>
		ORDER BY PAYROLL_REVENUE_DATE
	<cfelseif isDefined('attributes.oby') and attributes.oby eq 3>
		ORDER BY PAYROLL_NO
	<cfelseif isDefined('attributes.oby') and attributes.oby eq 4>
		ORDER BY PAYROLL_NO DESC
	<cfelse>
		ORDER BY PAYROLL_REVENUE_DATE DESC
	</cfif>
</cfquery>
