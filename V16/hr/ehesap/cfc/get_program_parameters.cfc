<cfcomponent>
	<cffunction name="get_stamp_tax_rate" access="public" returntype="query">
		<cfargument name="start_" type="date" default="">
		<cfargument name="finish_" type="date" default="">
		<cfquery name="get_stamp_tax_rate_query" datasource="#this.dsn#">
			SELECT TOP 1
				STAMP_TAX_BINDE
			FROM
				SETUP_PROGRAM_PARAMETERS
			WHERE
				PARAMETER_ID IS NOT NULL
				<cfif isdefined('arguments.start_') and len(arguments.start_)>
					AND STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_#">  
				</cfif>
				<cfif isdefined('arguments.finish_') and len(arguments.finish_)>
					AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_#"> 			
				</cfif>
			ORDER BY
				PARAMETER_ID DESC
		</cfquery>
		<cfreturn get_stamp_tax_rate_query>
	</cffunction>
	<cffunction name="get_program_parameter" access="public" returntype="query">
		<cfargument name="start_" type="date" default="">
		<cfargument name="finish_" type="date" default="">
		<cfargument name="group_id" type="string">
		<cfargument name="branch_id" type="string">
		<cfquery name="get_setup_parameter" datasource="#this.dsn#">
			SELECT
				PARAMETER_ID,
				PARAMETER_NAME,
				STARTDATE,
				FINISHDATE,
				SSK_DAYS_WORK_DAYS,
				FULL_DAY,
				SSK_31_DAYS,
				STAMP_TAX_BINDE,
				<cfloop from="1" to="6" index="i">
				DENUNCIATION_#i#_LOW,
				DENUNCIATION_#i#_HIGH,
				DENUNCIATION_#i#,
				</cfloop>
				OVERTIME_YEARLY_HOURS,
				OVERTIME_HOURS,
				EX_TIME_PERCENT,
				EX_TIME_LIMIT,
				EX_TIME_PERCENT_HIGH,
				USE_WORKTIMES,
				SAKAT_ALT,
				SAKAT_PERCENT,
				ESKI_HUKUMLU_PERCENT,
				TEROR_MAGDURU_PERCENT,
				YEARLY_PAYMENT_REQ_LIMIT,
				YEARLY_PAYMENT_REQ_COUNT,
				CAST_STYLE,
				WEEKEND_MULTIPLIER,
				OFFICIAL_MULTIPLIER,
				EXTRA_TIME_STYLE,
				IS_AVANS_OFF,
				UNPAID_PERMISSION_TODROP_THIRTY,
				EMPLOYMENT_CONTINUE_TIME,
				EMPLOYMENT_START_DATE,
				IS_AGI_PAY,
				GROSS_COUNT_TYPE,
				IS_SURELI_IS_AKDI_OFF,
				FINISH_DATE_COUNT_TYPE,
				IS_ADD_VIRTUAL_ALL,
				COMPANY_ID,
				ACCOUNT_CODE,
				ACCOUNT_NAME,
				CONSUMER_ID,
				ACC_TYPE_ID,
				LIMIT_PAYMENT_REQUEST,
				NIGHT_MULTIPLIER,
				TAX_ACCOUNT_STYLE,
				OFFTIME_COUNT_TYPE,
				BRANCH_IDS,
				GROUP_IDS,
				WEEKEND_MULTIPLIER,
				IS_SGK_KONTROL,
				ISNULL(IS_ADD_5746_CONTROL,0) AS IS_ADD_5746_CONTROL,
				ISNULL(IS_ADD_4691_CONTROL,0) AS IS_ADD_4691_CONTROL,
                <!---IS_SGK_CONTROL_EXT_SALARY,--->
				IS_5746_OVERTIME,
				IS_5746_SALARYPARAM_PAY,
                IS_NOT_SGK_WORK_DAYS_30,
                INTERRUPTION_TYPE,
				SALARYPARAM_PAY_ID,
				EXPENSE_ITEM_ID,
				EXPENSE_CENTER_ID,
				HEALTH_ACCOUNT_CODE,
				EXPENSE_INCOME_ITEM_ID,
				PAYMENT_INTERRUPTION_ID,
				PAYMENT_ACCOUNT_CODE,
				PAYMENT_ACCOUNT_NAME,
				EMPLOYEE_ACCOUNT_CODE,
				EMPLOYEE_ACCOUNT_NAME,
				SALARYPARAM_PAY_ID_RELATIVE,
				ISNULL(EMPLOYEES_BASE_CALC,0) EMPLOYEES_BASE_CALC,
				LIMIT_INTERRUPTION_ID,
				LIMIT_INTERRUPTION_ACCOUNT_CODE,
				PARTIAL_WORK,
				PARTIAL_WORK_TIME,
				IS_5746_STAMPDUTY,
				IS_5746_WITH_AGI,
				FIRST_DAY_MONTH,
				LAST_DAY_MONTH,
				IS_USE_MINIMUM_WAGE,
				<!---Muzaffer Bas İmbat Fazla Mesai Tipleri--->
				WEEKEND_DAY_MULTIPLIER,
				AKDI_DAY_MULTIPLIER,
				OFFICIAL_DAY_MULTIPLIER,
				ARAFE_DAY_MULTIPLIER,
				DINI_DAY_MULTIPLIER,
				<!---Muzaffer Bas İmbat Fazla Mesai Tipleri--->
				ISNULL(HOURLY_EMPLOYEE_WORK_DAYS_30,0) AS HOURLY_EMPLOYEE_WORK_DAYS_30
			FROM
				SETUP_PROGRAM_PARAMETERS
			WHERE
				PARAMETER_ID IS NOT NULL
				<cfif isdefined('arguments.start_') and len(arguments.start_)>
					AND STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_#">  
				</cfif>
				<cfif isdefined('arguments.finish_') and len(arguments.finish_)>
					AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_#"> 			
				</cfif>
				<cfif isdefined('arguments.branch_id') and len(arguments.branch_id)>
					AND (','+BRANCH_IDS+',' LIKE '%,#arguments.branch_id#,%')
				</cfif>
				<cfif isdefined('arguments.group_id') and len(arguments.group_id)>
					AND
					 (
						<cfloop from="1" to="#listlen(arguments.group_id)#" index="i">
							','+GROUP_IDS+',' LIKE '%,#listgetat(arguments.group_id,i,',')#,%' <cfif listlen(arguments.group_id) neq i>OR</cfif> 
						</cfloop>
					)
				<!--- 14042021 BK - Çalışan grubu belirtilmemiş personellerin ücret kartı görüntülenemediğinden kaldırıldı. Farklı bir sorun yaratırsa kaldırılacak.
				<cfelse>
					AND GROUP_IDS IS NULL
				--->
				</cfif>
			ORDER BY
				PARAMETER_ID DESC
		</cfquery>
		<cfreturn get_setup_parameter>
	</cffunction>
</cfcomponent>
