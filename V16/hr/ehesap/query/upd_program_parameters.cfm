<cf_date tarih="attributes.startdate">
<cf_date tarih="attributes.finishdate">
<cfif len(attributes.EMPLOYMENT_START_DATE)>
	<cf_date tarih='attributes.EMPLOYMENT_START_DATE'>
</cfif>
<cfset finishdate_ = date_add("h",23,attributes.finishdate)>
<cfset finishdate_ = date_add("n",59,finishdate_)>
<cfset finishdate_ = date_add("s",59,finishdate_)>
<cfif isdefined('attributes.relative_health_account_code') and len(attributes.relative_expense_item_name)>
	<cfset health_acc_code = trim(listFirst(attributes.relative_health_account_code,'-'))>
	<cfset health_acc_name = trim(listLast(attributes.relative_health_account_code,'-'))>
</cfif>
<!----Muzaffer Kose Baslama--->
<cfif isDefined("attributes.WEEKEND_DAY_MULTIPLIER")><cfset WEEKEND_DAY_MULTIPLIER= replace("#attributes.WEEKEND_DAY_MULTIPLIER#", ",", ".")></cfif>
<cfif isDefined("attributes.DINI_DAY_MULTIPLIER")><cfset DINI_DAY_MULTIPLIER= replace("#attributes.DINI_DAY_MULTIPLIER#", ",", ".")></cfif>
<cfif isDefined("attributes.AKDI_DAY_MULTIPLIER")><cfset AKDI_DAY_MULTIPLIER= replace("#attributes.AKDI_DAY_MULTIPLIER#", ",", ".")></cfif>
<cfif isDefined("attributes.OFFICIAL_DAY_MULTIPLIER")><cfset OFFICIAL_DAY_MULTIPLIER= replace("#attributes.OFFICIAL_DAY_MULTIPLIER#", ",", ".")></cfif>
<cfif isDefined("attributes.ARAFE_DAY_MULTIPLIER")><cfset ARAFE_DAY_MULTIPLIER= replace("#attributes.ARAFE_DAY_MULTIPLIER#", ",", ".")></cfif> 
<!----Muzaffer Kose Bitis--->
<cfquery name="upd_query" datasource="#dsn#">
	UPDATE 
		SETUP_PROGRAM_PARAMETERS
	SET
		PARAMETER_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.parameter_name#">,
		GROSS_COUNT_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.GROSS_COUNT_TYPE#">,
		TAX_ACCOUNT_STYLE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.TAX_ACCOUNT_STYLE#">,
		CAST_STYLE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cast_style#">,
		EXTRA_TIME_STYLE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.extra_time_style#">,
		STARTDATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">,
		FINISHDATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#finishdate_#">,
		SSK_DAYS_WORK_DAYS = <cfqueryparam cfsqltype="cf_sql_integer" value="#SSK_DAYS_WORK_DAYS#">,
		FULL_DAY = <cfqueryparam cfsqltype="cf_sql_integer" value="#FULL_DAY#">,
		SSK_31_DAYS = <cfqueryparam cfsqltype="cf_sql_integer" value="#SSK_31_DAYS#">,
		STAMP_TAX_BINDE = #STAMP_TAX_BINDE#,
		WEEKEND_MULTIPLIER = <cfif len(attributes.WEEKEND_MULTIPLIER)>#attributes.WEEKEND_MULTIPLIER#<cfelse>NULL</cfif>,
		OFFICIAL_MULTIPLIER = <cfif len(attributes.OFFICIAL_MULTIPLIER)>#attributes.OFFICIAL_MULTIPLIER#<cfelse>NULL</cfif>,
		NIGHT_MULTIPLIER = <cfif len(attributes.NIGHT_MULTIPLIER)>#attributes.NIGHT_MULTIPLIER#<cfelse>NULL</cfif>,		
        <!---İmbat Maden için eklenen ekmesai Gün parametreleri---->
		<cfif isDefined("attributes.WEEKEND_DAY_MULTIPLIER")>WEEKEND_DAY_MULTIPLIER = <cfif len(attributes.WEEKEND_DAY_MULTIPLIER)>#WEEKEND_DAY_MULTIPLIER#<cfelse>NULL</cfif>,</cfif>
		<cfif isDefined("attributes.AKDI_DAY_MULTIPLIER")>AKDI_DAY_MULTIPLIER = <cfif len(attributes.AKDI_DAY_MULTIPLIER)>#AKDI_DAY_MULTIPLIER#<cfelse>NULL</cfif>,</cfif>
		<cfif isDefined("attributes.OFFICIAL_DAY_MULTIPLIER")>OFFICIAL_DAY_MULTIPLIER = <cfif len(attributes.OFFICIAL_DAY_MULTIPLIER)>#OFFICIAL_DAY_MULTIPLIER#<cfelse>NULL</cfif>,</cfif>
		<cfif isDefined("attributes.ARAFE_DAY_MULTIPLIER")>ARAFE_DAY_MULTIPLIER = <cfif len(attributes.ARAFE_DAY_MULTIPLIER)>#ARAFE_DAY_MULTIPLIER#<cfelse>NULL</cfif>,</cfif>
		<cfif isDefined("attributes.DINI_DAY_MULTIPLIER")>DINI_DAY_MULTIPLIER = <cfif len(attributes.DINI_DAY_MULTIPLIER)>#DINI_DAY_MULTIPLIER#<cfelse>NULL</cfif>,</cfif>
        <!---İmbat Maden için eklenen ekmesai Gün parametreleri---->
		DENUNCIATION_1_LOW = #DENUNCIATION_1_LOW#,
		DENUNCIATION_1_HIGH = #DENUNCIATION_1_HIGH#,
		DENUNCIATION_2_LOW = #DENUNCIATION_2_LOW#,
		DENUNCIATION_2_HIGH = #DENUNCIATION_2_HIGH#,
		DENUNCIATION_3_LOW = #DENUNCIATION_3_LOW#,
		DENUNCIATION_3_HIGH = #DENUNCIATION_3_HIGH#,
		DENUNCIATION_4_LOW = #DENUNCIATION_4_LOW#,
		DENUNCIATION_4_HIGH = #DENUNCIATION_4_HIGH#,
		DENUNCIATION_5_LOW = <cfif len(DENUNCIATION_5_LOW)>#DENUNCIATION_5_LOW#<cfelse>NULL</cfif>,
		DENUNCIATION_5_HIGH = <cfif len(DENUNCIATION_5_HIGH)>#DENUNCIATION_5_HIGH#<cfelse>NULL</cfif>,
		DENUNCIATION_6_LOW = <cfif len(DENUNCIATION_6_LOW)>#DENUNCIATION_6_LOW#<cfelse>NULL</cfif>,
		DENUNCIATION_6_HIGH = <cfif len(DENUNCIATION_6_HIGH)>#DENUNCIATION_6_HIGH#<cfelse>NULL</cfif>,
		DENUNCIATION_1 = #DENUNCIATION_1#,
		DENUNCIATION_2 = #DENUNCIATION_2#,
		DENUNCIATION_3 = #DENUNCIATION_3#,
		DENUNCIATION_4 = #DENUNCIATION_4#,
		DENUNCIATION_5 = <cfif len(DENUNCIATION_5)>#DENUNCIATION_5#<cfelse>NULL</cfif>,
		DENUNCIATION_6 = <cfif len(DENUNCIATION_6)>#DENUNCIATION_6#<cfelse>NULL</cfif>,
		OVERTIME_YEARLY_HOURS = #OVERTIME_YEARLY_HOURS#,
		OVERTIME_HOURS = #OVERTIME_HOURS#,
		EX_TIME_PERCENT = #EX_TIME_PERCENT#,
		EX_TIME_LIMIT = #EX_TIME_LIMIT#,
		EX_TIME_PERCENT_HIGH = #EX_TIME_PER_HIGH#,
		SAKAT_ALT = #SAKAT_ALT#,
		SAKAT_PERCENT = #SAKAT_PERCENT#,
		ESKI_HUKUMLU_PERCENT = #ESKI_HUKUMLU_PERCENT#,
		TEROR_MAGDURU_PERCENT = #TEROR_MAGDURU_PERCENT#,
		YEARLY_PAYMENT_REQ_LIMIT = #attributes.yearly_payment_limit#,
		YEARLY_PAYMENT_REQ_COUNT = #attributes.yearly_payment_count#,
		LIMIT_PAYMENT_REQUEST = <cfif len(attributes.limit_payment_request)>#attributes.limit_payment_request#<cfelse>NULL</cfif>,
		IS_AVANS_OFF = <cfif isdefined("attributes.is_avans_off")>1<cfelse>0</cfif>,
		UNPAID_PERMISSION_TODROP_THIRTY = #unpaid_permission_todrop_thirty#,
		EMPLOYMENT_START_DATE = <cfif isdate(attributes.employment_start_date) and len(attributes.employment_start_date)>#attributes.employment_start_date#<cfelse>NULL</cfif>,
		EMPLOYMENT_CONTINUE_TIME = <cfif len(attributes.employment_continue_time)>#attributes.employment_continue_time#<cfelse>NULL</cfif>,
		IS_AGI_PAY = <cfif isdefined('attributes.is_agi_pay')>1<cfelse>0</cfif>,
		IS_SURELI_IS_AKDI_OFF = <cfif isdefined('attributes.is_sureli_is_akdi_off')>1<cfelse>0</cfif>,
		FINISH_DATE_COUNT_TYPE = #attributes.FINISH_DATE_COUNT_TYPE#,
		ACCOUNT_CODE =  <cfif isDefined("attributes.account_code") and len(attributes.account_code)>'#attributes.account_code#'<cfelse>NULL</cfif>,
		ACCOUNT_NAME =  <cfif isDefined("attributes.account_name") and len(attributes.account_name)>'#attributes.account_name#'<cfelse>NULL</cfif>,
		COMPANY_ID = <cfif isDefined("attributes.company_id") and len(attributes.company_id) and len(attributes.member_name)>#attributes.company_id#<cfelse>NULL</cfif>,
		CONSUMER_ID = <cfif isDefined("attributes.consumer_id") and len(attributes.consumer_id) and len(attributes.member_name)>#attributes.consumer_id#<cfelse>NULL</cfif>,
		ACC_TYPE_ID = <cfif isDefined("attributes.acc_type_id") and len(attributes.acc_type_id)>#attributes.acc_type_id#<cfelse>NULL</cfif>,
		UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">,
		IS_ADD_VIRTUAL_ALL = <cfif isdefined('attributes.is_add_virtual_all')>1<cfelse>0</cfif>,
		IS_SGK_KONTROL = <cfif isdefined('attributes.is_sgk_kontrol')>1<cfelse>0</cfif>,
        IS_ADD_5746_CONTROL = <cfif isdefined('attributes.is_add_5746_control')>1<cfelse>0</cfif>,
        IS_ADD_4691_CONTROL = <cfif isdefined('attributes.is_add_4691_control')>1<cfelse>0</cfif>,
        <!---IS_SGK_CONTROL_EXT_SALARY = <cfif isdefined('attributes.is_sgk_control_ext_salary')>1<cfelse>0</cfif>,--->
        IS_NOT_SGK_WORK_DAYS_30 = #IS_NOT_SGK_WORK_DAYS_30#,
		OFFTIME_COUNT_TYPE =#attributes.offtime_count_type#,
		BRANCH_IDS = <cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>'#attributes.branch_id#'<cfelse>NULL</cfif>,
		GROUP_IDS = <cfif isdefined('attributes.group_id') and len(attributes.group_id)>'#attributes.group_id#'<cfelse>NULL</cfif>,
		EXECUTION_ACC_TYPE_ID = <cfif isdefined('attributes.execution_acc_type_id') and len(attributes.execution_acc_type_id)>#attributes.execution_acc_type_id#<cfelse>NULL</cfif>,
		EXECUTION_ACCOUNT_CODE = <cfif isdefined('attributes.execution_account_code') and len(attributes.execution_account_code)>'#attributes.execution_account_code#'<cfelse>NULL</cfif>,
		EXECUTION_ACCOUNT_NAME = <cfif isdefined('attributes.execution_account_name') and len(attributes.execution_account_name)>'#attributes.execution_account_name#'<cfelse>NULL</cfif>,
		EXECUTION_COMPANY_ID = <cfif isdefined('attributes.execution_company_id') and len(attributes.execution_company_id)>#attributes.execution_company_id#<cfelse>NULL</cfif>,
		EXECUTION_CONSUMER_ID = <cfif isdefined('attributes.execution_consumer_id') and len(attributes.execution_consumer_id)>#attributes.execution_consumer_id#<cfelse>NULL</cfif>,
        INTERRUPTION_TYPE = <cfif isdefined('attributes.interruption_type') and len(attributes.interruption_type)>#attributes.interruption_type#<cfelse>NULL</cfif>,
		IS_5746_OVERTIME = <cfif isdefined('attributes.is_add_5746_overtime')>1<cfelse>0</cfif>,
		IS_5746_WORKING_HOURS = <cfif isdefined('attributes.is_5746_working_hours')>1<cfelse>0</cfif>,
		EXPENSE_ITEM_ID = <cfif isdefined('attributes.expense_item_id') and len(attributes.expense_item_id)>#attributes.expense_item_id#<cfelse>NULL</cfif>,
		IS_5746_SALARYPARAM_PAY = <cfif isdefined('attributes.is_5746_salaryparam_pay')>1<cfelse>0</cfif>,
		SALARYPARAM_PAY_ID = <cfif isdefined("attributes.SALARYPARAM_PAY_ID") and len(attributes.SALARYPARAM_PAY_ID) and len(attributes.salaryparam_pay_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SALARYPARAM_PAY_ID#"><cfelse>NULL</cfif>,
		SALARYPARAM_PAY_ID_RELATIVE = <cfif isdefined("attributes.SALARYPARAM_PAY_ID2") and len(attributes.SALARYPARAM_PAY_ID2) and isdefined("attributes.salaryparam_pay_name2") and len(attributes.salaryparam_pay_name2)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SALARYPARAM_PAY_ID2#"><cfelse>NULL</cfif>,
		EXPENSE_CENTER_ID = <cfif isdefined("attributes.EXPENSE_CENTER_ID") and len(attributes.EXPENSE_CENTER_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EXPENSE_CENTER_ID#"><cfelse>NULL</cfif>,
		HEALTH_ACCOUNT_CODE = <cfif isdefined("health_acc_code") and len(health_acc_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#health_acc_code#"><cfelse>NULL</cfif>,
		HEALTH_ACCOUNT_NAME = <cfif isdefined('health_acc_name') and len(health_acc_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#health_acc_name#"><cfelse>NULL</cfif>,
		PAYMENT_ACCOUNT_CODE = <cfif isdefined("payment_account_code") and len(payment_account_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#payment_account_code#"><cfelse>NULL</cfif>,
		PAYMENT_ACCOUNT_NAME = <cfif isdefined('payment_account_code_name') and len(payment_account_code_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#payment_account_code_name#"><cfelse>NULL</cfif>,
		EMPLOYEE_ACCOUNT_CODE = <cfif isdefined("employee_account_code") and len(employee_account_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#employee_account_code#"><cfelse>NULL</cfif>,
		EMPLOYEE_ACCOUNT_NAME = <cfif isdefined('employee_account_code_name') and len(employee_account_code_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#employee_account_code_name#"><cfelse>NULL</cfif>,
		EXPENSE_INCOME_ITEM_ID = <cfif isdefined('attributes.EXPENSE_INCOME_ITEM_ID') and len(attributes.EXPENSE_INCOME_ITEM_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.EXPENSE_INCOME_ITEM_ID#"><cfelse>NULL</cfif>,
		PAYMENT_INTERRUPTION_ID = <cfif isdefined("attributes.payment_interruption_id") and len(attributes.payment_interruption_id) and len(attributes.payment_interruption_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.payment_interruption_id#"><cfelse>NULL</cfif>,
		RELATIVE_EXPENSE_ITEM_ID = <cfif isdefined('attributes.RELATIVE_EXPENSE_ITEM_ID') and len(attributes.RELATIVE_EXPENSE_ITEM_ID) and len(attributes.relative_expense_item_name)>#attributes.RELATIVE_EXPENSE_ITEM_ID#<cfelse>NULL</cfif>,
		EMPLOYEES_BASE_CALC = <cfif isdefined('attributes.EMPLOYEES_BASE_CALC') and len(attributes.EMPLOYEES_BASE_CALC) AND attributes.EMPLOYEES_BASE_CALC EQ 1>1<cfelse>0</cfif>,
		LIMIT_INTERRUPTION_ID = <cfif isdefined("attributes.LIMIT_INTERRUPTION_ID") and len(attributes.LIMIT_INTERRUPTION_ID) and len(attributes.LIMIT_INTERRUPTION_NAME)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.LIMIT_INTERRUPTION_ID#"><cfelse>NULL</cfif>,
		LIMIT_INTERRUPTION_ACCOUNT_CODE = <cfif isdefined("LIMIT_INTERRUPTION_ACCOUNT_CODE") and len(LIMIT_INTERRUPTION_ACCOUNT_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#LIMIT_INTERRUPTION_ACCOUNT_CODE#"><cfelse>NULL</cfif>,
		LIMIT_INTERRUPTION_ACCOUNT_NAME = <cfif isdefined('LIMIT_INTERRUPTION_ACCOUNT_NAME') and len(LIMIT_INTERRUPTION_ACCOUNT_NAME)><cfqueryparam cfsqltype="cf_sql_varchar" value="#LIMIT_INTERRUPTION_ACCOUNT_NAME#"><cfelse>NULL</cfif>,
		PARTIAL_WORK = <cfif isdefined("attributes.partial_work") and len(attributes.partial_work)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partial_work#"><cfelse>NULL</cfif>,
		PARTIAL_WORK_TIME = <cfif isdefined("attributes.partial_worktime") and len(attributes.partial_worktime)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.partial_worktime#"><cfelse>NULL</cfif>,
		IS_5746_STAMPDUTY = <cfif isdefined('attributes.IS_5746_STAMPDUTY')>1<cfelse>0</cfif>,
		IS_5746_WITH_AGI = <cfif isdefined('attributes.is_5746_with_agi')>1<cfelse>0</cfif>,
		FIRST_DAY_MONTH = <cfif isdefined("attributes.FIRST_DAY_MONTH") and len(attributes.FIRST_DAY_MONTH)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.FIRST_DAY_MONTH#"><cfelse>1</cfif>,
		LAST_DAY_MONTH = <cfif isdefined("attributes.LAST_DAY_MONTH") and len(attributes.LAST_DAY_MONTH)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.LAST_DAY_MONTH#"><cfelse>0</cfif>,
		IS_USE_MINIMUM_WAGE = <cfif isdefined("attributes.IS_USE_MINIMUM_WAGE") and len(attributes.IS_USE_MINIMUM_WAGE)><cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.IS_USE_MINIMUM_WAGE#"><cfelse>NULL</cfif>,
		HOURLY_EMPLOYEE_WORK_DAYS_30 = <cfif isdefined("attributes.HOURLY_EMPLOYEE_WORK_DAYS_30") and len(attributes.HOURLY_EMPLOYEE_WORK_DAYS_30)><cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.HOURLY_EMPLOYEE_WORK_DAYS_30#"><cfelse>0</cfif>
	WHERE
		PARAMETER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.parameter_id#">
</cfquery>
<cfset attributes.param_id = attributes.parameter_id>
<cfinclude template="add_parameters_history.cfm">
<cfset attributes.actionId = attributes.parameter_id>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=ehesap.list_program_parameters&event=upd&parameter_id=#attributes.parameter_id#</cfoutput>";
</script>
