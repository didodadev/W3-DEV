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
<cfinclude template="../../objects/query/get_acc_types.cfm">
<cfif len(attributes.record_date) and isdate (attributes.record_date)><cf_date tarih ="attributes.record_date"></cfif>
<cfif len(attributes.record_date2) and isdate (attributes.record_date2)><cf_date tarih ="attributes.record_date2"></cfif>
<cfif len(attributes.start_date) and isdate(attributes.start_date)><cf_date tarih = "attributes.start_date"></cfif>
<cfif len(attributes.finish_date) and isdate(attributes.finish_date)><cf_date tarih = "attributes.finish_date"></cfif>
<cfif isDefined("attributes.page_action_type") and len(attributes.page_action_type)>
	<cfset ACT_TYPE = ListFirst(attributes.page_action_type,'-')>
    <cfset PROC_CAT = ListLast(attributes.page_action_type,'-')>
	<cfif ACT_TYPE eq 310>
        <cfset ACT_TYPE = '31'>
    <cfelseif ACT_TYPE eq 320>
    	<cfset ACT_TYPE = '32'>
    </cfif>
</cfif>
<cfquery name="GET_CASH_ACTIONS" datasource="#DSN2#" cachedwithin="#fusebox.general_cached_time#">
	SELECT
		CA.EXPENSE_ID,
		CA.MULTI_ACTION_ID,
		CA.ACTION_TYPE,
		CA.ACTION_TYPE_ID,
		CA.ACTION_ID,
		CA.PAPER_NO,
		CA.BANK_ACTION_ID,
		CA.ACTION_DATE,
		CA.WITH_NEXT_ROW,
		CA.CASH_ACTION_FROM_CASH_ID,
		CA.CASH_ACTION_TO_CASH_ID,
		CA.CASH_ACTION_FROM_COMPANY_ID,
		CA.CASH_ACTION_TO_COMPANY_ID,
		CA.CASH_ACTION_FROM_EMPLOYEE_ID,
		CA.CASH_ACTION_TO_EMPLOYEE_ID,
		CA.CASH_ACTION_FROM_CONSUMER_ID,
		CA.CASH_ACTION_TO_CONSUMER_ID,
		CA.CASH_ACTION_FROM_ACCOUNT_ID,
		CA.CASH_ACTION_TO_ACCOUNT_ID,
		CA.EXPENSE_ITEM_ID,
		CA.CASH_ACTION_CURRENCY_ID,
		CA.CASH_ACTION_VALUE,
		CA.PAYROLL_ID,
		CA.PROCESS_CAT,
		CA.OTHER_MONEY,
		CA.OTHER_CASH_ACT_VALUE,
		CA.ORDER_ID,
		CA.RECORD_EMP,
		CA.RECORD_DATE,
		CA.ACTION_DETAIL,
		CA.VOUCHER_ID,
		CA.ACTION_VALUE SYSTEM_ACTION_VALUE,
        CA.BILL_ID,
		ISNULL(CA.WITH_NEXT_ROW,0) WITH_NEXT_ROW,
        PR.PROJECT_HEAD AS PROJECT,
		BR.BRANCH_NAME BRANCH
	FROM
		CASH_ACTIONS CA
		<cfif isDefined("ACT_TYPE") and  (ACT_TYPE eq 310 or ACT_TYPE eq 320)>
		,CASH_ACTIONS_MULTI CAM
		</cfif>
        LEFT JOIN #dsn_alias#.PRO_PROJECTS PR ON CA.PROJECT_ID=PR.PROJECT_ID
		LEFT JOIN CASH C ON ISNULL(CA.CASH_ACTION_FROM_CASH_ID,CA.CASH_ACTION_TO_CASH_ID)=C.CASH_ID
		LEFT JOIN #dsn_alias#.BRANCH BR ON C.BRANCH_ID=BR.BRANCH_ID
	WHERE
		CA.ACTION_ID IS NOT NULL	
	<cfif isDefined("ACT_TYPE") and  (ACT_TYPE eq 310 or ACT_TYPE eq 320)>
		AND CA.MULTI_ACTION_ID = CAM.MULTI_ACTION_ID
	</cfif>
	<cfif len(hr_type_list) or len(ehesap_type_list) or len(other_type_list)><!--- İk veya ehesap süper kullanıcı yetkisine bakılacak tip varsa --->
		AND #control_acc_type_list#
	</cfif>
	<cfif isDefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.company) and attributes.member_type eq 'employee'>
		AND (CA.CASH_ACTION_FROM_EMPLOYEE_ID = #attributes.emp_id# OR CA.CASH_ACTION_TO_EMPLOYEE_ID = #attributes.emp_id#)
	</cfif>
	<cfif isDefined("attributes.company_id") and len(attributes.company_id) and len(attributes.company) and attributes.member_type eq 'partner'>
		AND (CA.CASH_ACTION_FROM_COMPANY_ID = #attributes.company_id# OR CA.CASH_ACTION_TO_COMPANY_ID = #attributes.company_id#)
	</cfif>		
	<cfif isDefined("attributes.consumer_id") and len(attributes.consumer_id) and len(attributes.company) and attributes.member_type eq 'consumer'>
		AND (CA.CASH_ACTION_FROM_CONSUMER_ID = #attributes.consumer_id# OR CA.CASH_ACTION_TO_CONSUMER_ID = #attributes.consumer_id#)
	</cfif>	
	<cfif isDefined("attributes.record_emp_id") and len(attributes.record_emp_id) and len(attributes.record_emp_name)>
		AND CA.RECORD_EMP = #attributes.record_emp_id#
	</cfif>	
	<cfif isDefined("ACT_TYPE") and len(ACT_TYPE) and isDefined("PROC_CAT") and len(PROC_CAT)>
    	<cfif PROC_CAT eq 0>
            AND CA.ACTION_TYPE_ID IN (#ACT_TYPE#)
        <cfelseif PROC_CAT neq 0>
        	AND CA.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#PROC_CAT#">
        </cfif>
    </cfif>
<!---	<cfif isDefined("attributes.page_action_type") and len(attributes.page_action_type) and (attributes.page_action_type neq 310) and (attributes.page_action_type neq 320)>
		AND CA.ACTION_TYPE_ID = #attributes.page_action_type#
	<cfelseif isDefined("attributes.page_action_type") and attributes.page_action_type eq 310>
		AND CA.ACTION_TYPE_ID = 31
	<cfelseif isDefined("attributes.page_action_type") and attributes.page_action_type eq 320>
		AND CA.ACTION_TYPE_ID = 32
	</cfif>--->
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		<cfif len(attributes.keyword) gt 3>
			AND CA.ACTION_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		<cfelse>
			AND CA.ACTION_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
		</cfif>
	</cfif>
	<cfif isDefined("attributes.paper_number") and len(attributes.paper_number)>
		AND (CA.PAPER_NO LIKE '<cfif len(attributes.paper_number) gt 3>%</cfif>#attributes.paper_number#%')
	</cfif>
	<cfif isDefined("attributes.cash") and len(attributes.cash)>
		AND
		(
		<cfif isdefined("attributes.action") and listfind('32,34,36',attributes.action,',')>
			CA.CASH_ACTION_FROM_CASH_ID=#attributes.cash#
		<cfelseif isdefined("attributes.action") and listfind('31,33,35',attributes.action,',')> 
			CA.CASH_ACTION_TO_CASH_ID=#attributes.cash#
		<cfelse>
			CA.CASH_ACTION_FROM_CASH_ID=#attributes.cash# OR
			CA.CASH_ACTION_TO_CASH_ID=#attributes.cash#
		</cfif>
		)
	</cfif>
	<cfif isDefined("attributes.special_definition_id") and len(attributes.special_definition_id) and attributes.special_definition_id eq '-1'>
		AND CA.SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 1)
	<cfelseif isDefined("attributes.special_definition_id") and len(attributes.special_definition_id) and attributes.special_definition_id eq '-2'>
		AND CA.SPECIAL_DEFINITION_ID IN (SELECT SPECIAL_DEFINITION_ID FROM #dsn_alias#.SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 2)
	<cfelseif isDefined("attributes.special_definition_id") and len(attributes.special_definition_id)>
		AND CA.SPECIAL_DEFINITION_ID = #attributes.special_definition_id#
	</cfif>
	<cfif isdate(attributes.start_date) and not isdate(attributes.finish_date)>
		AND CA.ACTION_DATE >= #attributes.start_date#
	<cfelseif isdate(attributes.finish_date) and not isdate(attributes.start_date)>
		AND CA.ACTION_DATE <= #attributes.finish_date#
	<cfelseif isdate(attributes.start_date) and  isdate(attributes.finish_date)>
		AND CA.ACTION_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
	</cfif>
	<cfif isdate(attributes.record_date) and not isdate(attributes.record_date2)>
		AND CA.RECORD_DATE >= #attributes.record_date#
	<cfelseif isdate(attributes.record_date2) and not isdate(attributes.record_date)>
		AND CA.RECORD_DATE <= #DATEADD("d",1,attributes.record_date2)#
	<cfelseif isdate(attributes.record_date) and  isdate(attributes.record_date2)>
		AND CA.RECORD_DATE >= #attributes.record_date# AND CA.RECORD_DATE <= #DATEADD("d",1,attributes.record_date2)#
	</cfif>
	<cfif (session.ep.isBranchAuthorization) or (isdefined('attributes.branch_id') and len(attributes.branch_id)) >
		AND (
				(CA.CASH_ACTION_FROM_CASH_ID IN (SELECT CASH_ID FROM CASH WHERE BRANCH_ID = <cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>#attributes.branch_id#<cfelse>#ListGetAt(session.ep.user_location,2,"-")#</cfif>) OR
				CA.CASH_ACTION_TO_CASH_ID IN (SELECT CASH_ID FROM CASH WHERE BRANCH_ID = <cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>#attributes.branch_id#<cfelse>#ListGetAt(session.ep.user_location,2,"-")#</cfif>))
			)
	</cfif>
	<cfif (isDefined("attributes.cash_status") and len(attributes.cash_status))>
		AND ((CA.CASH_ACTION_FROM_CASH_ID IN(SELECT CASH_ID FROM CASH WHERE CASH_STATUS = #attributes.cash_status#)) OR (CA.CASH_ACTION_TO_CASH_ID IN(SELECT CASH_ID FROM CASH WHERE CASH_STATUS = #attributes.cash_status#)))
	</cfif>
	<cfif isdefined("attributes.action_cash") and attributes.action_cash eq 1>
		AND CA.CASH_ACTION_TO_CASH_ID IS NOT NULL
	<cfelseif isdefined("attributes.action_cash") and attributes.action_cash eq 0>
		AND CA.CASH_ACTION_FROM_CASH_ID IS NOT NULL
	</cfif>
	<cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
        AND CA.ACC_TYPE_ID = #attributes.acc_type_id#
    </cfif>
	<cfif len(attributes.project_head) and isdefined("attributes.project_id") and len(attributes.project_id)>
		AND CA.PROJECT_ID = #attributes.project_id#
	</cfif>
	ORDER BY 
		<cfif isDefined('attributes.oby') and attributes.oby eq 2>
			ACTION_DATE,
			RECORD_DATE,
		<cfelseif isDefined('attributes.oby') and attributes.oby eq 3>
			PAPER_NO,
		<cfelseif isDefined('attributes.oby') and attributes.oby eq 4>
			PAPER_NO DESC,
		<cfelse>
			ACTION_DATE DESC,
			RECORD_DATE DESC,
		</cfif>
		ACTION_ID DESC
</cfquery>
