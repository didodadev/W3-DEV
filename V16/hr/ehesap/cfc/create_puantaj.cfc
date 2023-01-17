<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="get_hr_ssk" returntype="query">
		<cfargument name="sal_mon" default=""/>
		<cfargument name="sal_year" default=""/>
		<cfargument name="employee_id" default=""/>
		<cfargument name="in_out_id" default=""/>
		<cfargument name="ssk_statue" default=""/>
		<cfargument  name="start_date_new" default="" required="no">
        <cfargument  name="finish_date_new" default="" required="no">
		<cfargument  name="arguments" default="0" required="no">
		<cfquery name="get_hr_ssk_query" datasource="#this.DSN#">
			SELECT
				E.EMPLOYEE_ID,
				EI.BIRTH_DATE,
				EIO.IN_OUT_ID,
				E.EMPLOYEE_NO,
				E.TASK,
				ED.SEX,
				EIO.DUTY_TYPE,
				EIO.GROSS_NET,
				EIO.START_DATE,
				EIO.FINISH_DATE,
				EIO.USE_SSK,
				EIO.USE_TAX,
				EIO.IS_TAX_FREE,
				EIO.IS_DAMGA_FREE,
				EIO.IS_KISMI_ISTIHDAM,
				EIO.KISMI_ISTIHDAM_GUN,
				EIO.KISMI_ISTIHDAM_SAAT,
				EIO.SSK_STATUTE,
				<cfif arguments.sal_year gte 2022>
					1 IS_DISCOUNT_OFF,
				<cfelse>
					EIO.IS_DISCOUNT_OFF,
				</cfif>
				EIO.IS_USE_506,
				EIO.DAYS_506,
				EIO.DAYS_5746,
				EIO.DAYS_4691,
				EIO.DEFECTION_LEVEL,
				EIO.SOCIALSECURITY_NO,
				EIO.TRADE_UNION_DEDUCTION,
				EIO.FAZLA_MESAI_SAAT,
				EIO.LAW_NUMBERS,
				EIO.KIDEM_AMOUNT, 
				EIO.IHBAR_AMOUNT, 
				EIO.KULLANILMAYAN_IZIN_AMOUNT,
				EIO.GROSS_COUNT_TYPE,
				EIO.FINISH_DATE,
				EIO.VALID,
				EIO.DEPARTMENT_ID,
				EIO.EX_IN_OUT_ID,
                EIO.WORKING_ABROAD,
				BRANCH.BRANCH_ID,
				BRANCH.DANGER_DEGREE,
				BRANCH.DANGER_DEGREE_NO,
				BRANCH.KANUN_5084_ORAN,
				BRANCH.IS_5615,
				BRANCH.IS_5615_TAX_OFF,
				BRANCH.IS_5510 AS SUBE_IS_5510,
				EIO.IS_5084,
				EIO.IS_5510,
				EIO.DATE_5763,
				EIO.DATE_6111,
				EIO.DATE_6111_SELECT,
				(SELECT TOP 1 EIOP.EXPENSE_CODE FROM EMPLOYEES_IN_OUT_PERIOD EIOP,BRANCH B2,SETUP_PERIOD SP WHERE B2.BRANCH_ID = EIO.BRANCH_ID AND B2.COMPANY_ID = EIOP.PERIOD_COMPANY_ID AND EIOP.IN_OUT_ID = EIO.IN_OUT_ID AND EIOP.PERIOD_ID = SP.PERIOD_ID AND (SP.PERIOD_YEAR = #arguments.sal_year# OR YEAR(SP.FINISH_DATE) = #arguments.sal_year#) AND (SP.FINISH_DATE IS NULL OR (SP.FINISH_DATE IS NOT NULL AND SP.FINISH_DATE >= #createdate(arguments.sal_year,arguments.sal_mon,1)#))) AS EXPENSE_CODE,
				(SELECT TOP 1 EIOP.ACCOUNT_CODE FROM EMPLOYEES_IN_OUT_PERIOD EIOP,BRANCH B2,SETUP_PERIOD SP WHERE B2.BRANCH_ID = EIO.BRANCH_ID AND B2.COMPANY_ID = EIOP.PERIOD_COMPANY_ID AND EIOP.IN_OUT_ID = EIO.IN_OUT_ID AND EIOP.PERIOD_ID = SP.PERIOD_ID AND (SP.PERIOD_YEAR = #arguments.sal_year# OR YEAR(SP.FINISH_DATE) = #arguments.sal_year#) AND (SP.FINISH_DATE IS NULL OR (SP.FINISH_DATE IS NOT NULL AND SP.FINISH_DATE >= #createdate(arguments.sal_year,arguments.sal_mon,1)#))) AS ACCOUNT_CODE,
				(SELECT TOP 1 EIOP.ACCOUNT_BILL_TYPE FROM EMPLOYEES_IN_OUT_PERIOD EIOP,BRANCH B2,SETUP_PERIOD SP WHERE B2.BRANCH_ID = EIO.BRANCH_ID AND B2.COMPANY_ID = EIOP.PERIOD_COMPANY_ID AND EIOP.IN_OUT_ID = EIO.IN_OUT_ID AND EIOP.PERIOD_ID = SP.PERIOD_ID AND (SP.PERIOD_YEAR = #arguments.sal_year# OR YEAR(SP.FINISH_DATE) = #arguments.sal_year#) AND (SP.FINISH_DATE IS NULL OR (SP.FINISH_DATE IS NOT NULL AND SP.FINISH_DATE >= #createdate(arguments.sal_year,arguments.sal_mon,1)#))) AS ACCOUNT_BILL_TYPE,
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME,
				BRANCH.COMPANY_ID,
				DEPARTMENT.DEPARTMENT_HEAD,
				OUR_COMPANY.NICK_NAME COMP_NICK_NAME,
				OUR_COMPANY.COMPANY_NAME COMP_FULL_NAME,
				BRANCH.BRANCH_FULLNAME,
				BRANCH.BRANCH_NAME,
				BRANCH.BRANCH_ID,
				BRANCH.SSK_OFFICE,
				BRANCH.SSK_NO,
				EIO.PUANTAJ_GROUP_IDS,
				ISNULL(E.HIERARCHY,0) HIERARCHY,
				EIO.IS_6486,
				BRANCH.KANUN_6486,
				EIO.IS_6322,
				BRANCH.KANUN_6322,
				OUR_COMPANY.COMP_ID,
				EIO.IS_25510,
                EIO.IS_KIDEM_IHBAR_ALL_TOTAL,
                EIO.IS_14857,
                EIO.IS_6645,
                EIO.START_MON_6645,
                EIO.END_MON_6645,
                EIO.START_YEAR_6645,
                EIO.END_YEAR_6645,
                EIO.IS_46486,
                EIO.IS_56486,
                EIO.IS_66486,
                EIO.IS_TAX_FREE_687,
				ISNULL(EIO.BENEFIT_MONTH_7103,0) AS BENEFIT_MONTH_7103,
				ISNULL((
						SELECT 
							COUNT(EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID) 
						FROM 
							EMPLOYEES_PUANTAJ_ROWS,
							EMPLOYEES_PUANTAJ 
						WHERE 
							EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_6111 > 0 
							AND EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = E.EMPLOYEE_ID
							AND EMPLOYEES_PUANTAJ.PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID
							AND EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_6111 IS NOT NULL
							AND CONVERT(datetime, DATE_6111) < = CONVERT(datetime, CONVERT(VARCHAR, EMPLOYEES_PUANTAJ.SAL_YEAR)+'-'+CONVERT(VARCHAR, EMPLOYEES_PUANTAJ.SAL_MON)+'-01')
							)
						,0)AS SSK_ISVEREN_HISSESI_6111_COUNT,
				ISNULL(EIO.BENEFIT_DAY_7252,0) AS BENEFIT_DAY_7252,
				EIO.STARTDATE_7256,
				EIO.FINISHDATE_7256,
				EIO.GRADE,
				EIO.STEP,
				EIO.ADDITIONAL_SCORE,
                EIO.ADMINISTRATIVE_INDICATOR_SCORE,
                EIO.EXECUTIVE_INDICATOR_SCORE,
                EIO.PRIVATE_SERVICE_SCORE,
                EIO.ADMINISTRATIVE_FUNCTION_ALLOWANCE,
                EIO.LANGUAGE_ALLOWANCE_1,
                EIO.LANGUAGE_ALLOWANCE_2,
                EIO.LANGUAGE_ALLOWANCE_3,
                EIO.LANGUAGE_ALLOWANCE_4,
                EIO.LANGUAGE_ALLOWANCE_5,
                EIO.UNIVERSITY_ALLOWANCE,
                EIO.MINIMUM_COURSE_HOURS,
                EIO.DIRECTOR_SHARE,
                EIO.EMPLOYEE_SHARE,
                EIO.PERQUISITE_SCORE,
                EIO.ACADEMIC_INCENTIVE_ALLOWANCE,
                EIO.HIGH_EDUCATION_COMPENSATION,
                EIO.LANGUAGE_ID_1,
                EIO.LANGUAGE_ID_2,
                EIO.LANGUAGE_ID_3,
                EIO.LANGUAGE_ID_4,
                EIO.LANGUAGE_ID_5,
				E.KIDEM_DATE,
				EIO.SALARY_TYPE,
				EIO.MONEY,
				ADDITIONAL_INDICATOR_COMPENSATION,
				IS_EDUCATION_ALLOWANCE,
				GRADE_NORMAL,
                STEP_NORMAL,
                ADDITIONAL_SCORE_NORMAL,
                WORK_DIFFICULTY,
                BUSINESS_RISK_EMP,
                JUL_DIFFICULTIES,
                FINANCIAL_RESPONSIBILITY,
                SEVERANCE_PENSION_SCORE,
				IS_PENANCE_DEDUCTION,
				ADDITIONAL_COURSE_POSITION,
				IS_AUDIT_COMPENSATION,
                AUDIT_COMPENSATION,
				IS_SUSPENSION,
                SUSPENSION_STARTDATE,
                SUSPENSION_FINISHDATE,
				IS_VETERAN,
				DEFECTION_STARTDATE,
				DEFECTION_FINISHDATE,
				PAST_AGI_DAY,
				LAND_COMPENSATION_SCORE,
                LAND_COMPENSATION_PERIOD,
				ADMINISTRATIVE_ACADEMIC,
				JURY_MEMBERSHIP,
                JURY_MEMBERSHIP_PERIOD,
				JURY_NUMBER,
				USE_MINIMUM_WAGE,
				ISNULL(START_CUMULATIVE_WAGE_TOTAL,0) START_CUMULATIVE_WAGE_TOTAL				
			FROM
				EMPLOYEES_IDENTY EI,
				EMPLOYEES_DETAIL ED,
				EMPLOYEES_IN_OUT EIO,
				BRANCH,
				DEPARTMENT,
				OUR_COMPANY,
				EMPLOYEES E
			WHERE
				EIO.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
				BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID AND
				E.EMPLOYEE_ID = EI.EMPLOYEE_ID AND
				E.EMPLOYEE_ID = ED.EMPLOYEE_ID AND
				E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND
				(EIO.IS_PUANTAJ_OFF = 0 OR EIO.IS_PUANTAJ_OFF IS NULL) AND
				EIO.EMPLOYEE_ID = #arguments.EMPLOYEE_ID#
				<cfif isdefined("arguments.in_out_id") and len(arguments.in_out_id)>
					AND EIO.IN_OUT_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.in_out_id#">
				</cfif>
				<cfif isdefined("arguments.start_date_new") and len(arguments.start_date_new) and isdefined("arguments.finish_date_new") and len(arguments.finish_date_new)>
					AND EIO.START_DATE <= <cfqueryparam CFSQLType = "cf_sql_timestamp" value = "#arguments.finish_date_new#">
					AND
					(
						(EIO.FINISH_DATE >= <cfqueryparam CFSQLType = "cf_sql_timestamp" value = "#arguments.start_date_new#">)
						OR
						EIO.FINISH_DATE IS NULL
					)
				<cfelse>
					AND EIO.START_DATE <= #CreateDate(arguments.sal_year,arguments.sal_mon,daysinmonth(CreateDate(arguments.sal_year,arguments.sal_mon,1)))#
					AND
					(
						(EIO.FINISH_DATE >= #CreateDate(arguments.sal_year,arguments.sal_mon,1)#)
						OR
						EIO.FINISH_DATE IS NULL
					)
				</cfif>
				AND BRANCH.BRANCH_ID = EIO.BRANCH_ID
			<cfif not session.ep.ehesap>
				AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
			</cfif>
			<cfif isdefined("arguments.ssk_statue") and len(arguments.ssk_statue)>
				AND EIO.USE_SSK = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ssk_statue#">
			</cfif>
			ORDER BY
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME,
				EIO.START_DATE
		</cfquery>
		<cfreturn get_hr_ssk_query/>
	</cffunction>
	<cffunction name="get_action_id" returntype="query">
		<cfargument name="puantaj_type" default=""/>
		<cfargument name="sal_mon" default=""/>
		<cfargument name="sal_year" default=""/>
		<cfargument name="branch_id" default=""/>
		<cfargument name="hiearchy" default=""/>
		<cfargument name="ssk_statue" default=""/>
		<cfargument name="statue_type" default=""/>

		<cfquery name="get_action_id_query" datasource="#this.dsn#">
			SELECT
				PUANTAJ_ID,
				IS_ACCOUNT,
				IS_BUDGET,
				IS_LOCKED
			FROM
				EMPLOYEES_PUANTAJ
			WHERE
				<cfif arguments.puantaj_type eq -2>
					PUANTAJ_TYPE IN (-2,-3) AND
				<cfelse>
					PUANTAJ_TYPE = #arguments.puantaj_type# AND
				</cfif>	
				<cfif len(arguments.hiearchy)>
					HIERARCHY = '#arguments.hiearchy#' AND
				</cfif>		
				SAL_MON = #arguments.sal_mon# AND
				SAL_YEAR = #arguments.sal_year# AND
				SSK_BRANCH_ID = #arguments.BRANCH_ID# 
				<cfif isdefined("arguments.ssk_statue") and len(arguments.ssk_statue)>
					AND STATUE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ssk_statue#">
					<cfif isdefined("arguments.ssk_statue") and len(arguments.ssk_statue) and arguments.ssk_statue eq 2 and len(arguments.statue_type)>
						AND STATUE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.statue_type#">
						<cfif isdefined("arguments.statue_type_individual") and arguments.statue_type_individual neq 0>
							AND STATUE_TYPE_INDIVIDUAL = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.statue_type_individual#">
						</cfif>
					</cfif>
				</cfif>
		</cfquery>
		<cfreturn get_action_id_query/>
	</cffunction>
	
	<cffunction name="get_relatives" returntype="query">
		<cfargument name="employee_id" default=""/>
		<cfargument name="sal_mon" default=""/>
		<cfargument name="sal_year" default=""/>
		<cfquery name="get_relatives_query" datasource="#this.dsn#">
			SELECT 
            	* 
            FROM 
            	EMPLOYEES_RELATIVES 
           	WHERE 
        		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#"> AND 
            	(RELATIVE_LEVEL = '3' OR RELATIVE_LEVEL = '4' OR RELATIVE_LEVEL = '5') AND
            	VALIDITY_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(arguments.sal_year,arguments.sal_mon,daysinmonth(CreateDate(arguments.sal_year,arguments.sal_mon,1)))#">
		</cfquery>
		<cfreturn get_relatives_query/>
	</cffunction>
	
	<cffunction name="del_puantaj_rows_ext">
		<cfargument name="puantaj_ids" default=""/>
		<cfargument name="employee_id" default=""/>
		<cfargument name="in_out_id" default=""/>
		<cfquery name="delete_exts" datasource="#this.dsn#">
			DELETE FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE EMPLOYEE_PUANTAJ_ID IN (SELECT EMPLOYEE_PUANTAJ_ID FROM EMPLOYEES_PUANTAJ_ROWS WHERE PUANTAJ_ID IN (#arguments.puantaj_ids#) <cfif len(arguments.EMPLOYEE_ID)>AND EMPLOYEE_ID = #arguments.EMPLOYEE_ID# </cfif><cfif len(arguments.in_out_id)>AND IN_OUT_ID =#arguments.in_out_id# </cfif>)
		</cfquery>
	</cffunction>
	<cffunction name="del_puantaj_rows_add">
		<cfargument name="puantaj_ids" default=""/>
		<cfargument name="employee_id" default=""/>
		<cfargument name="in_out_id" default=""/>
		<cfquery name="delete_rows" datasource="#this.dsn#">
			DELETE FROM EMPLOYEES_PUANTAJ_ROWS_ADD WHERE PUANTAJ_ID IN (#arguments.puantaj_ids#)<cfif len(arguments.EMPLOYEE_ID)> AND EMPLOYEE_ID = #arguments.EMPLOYEE_ID# </cfif><cfif len(arguments.in_out_id)>AND IN_OUT_ID =#arguments.in_out_id# </cfif>
		</cfquery>
	</cffunction>
	<cffunction name="del_puantaj_rows">
		<cfargument name="puantaj_ids" default=""/>
		<cfargument name="employee_id" default=""/>
		<cfargument name="in_out_id" default=""/>
		<cfquery name="delete_rows" datasource="#this.dsn#">
			DELETE FROM EMPLOYEES_PUANTAJ_ROWS WHERE PUANTAJ_ID IN (#arguments.puantaj_ids#)  <cfif len(arguments.EMPLOYEE_ID)>AND EMPLOYEE_ID = #arguments.EMPLOYEE_ID# </cfif><cfif len(arguments.in_out_id)>AND IN_OUT_ID =#arguments.in_out_id# </cfif>
		</cfquery>
	</cffunction>
	<cffunction name="del_puantaj_rows_officer">
		<cfargument name="puantaj_ids" default=""/>
		<cfargument name="employee_id" default=""/>
		<cfargument name="in_out_id" default=""/>
		<cfquery name="del_puantaj_rows_officer" datasource="#dsn#">
			DELETE FROM OFFICER_PAYROLL_ROW WHERE PAYROLL_ID IN (#arguments.puantaj_ids#) 
			<cfif len(arguments.in_out_id)>
				AND  IN_OUT_ID = #arguments.in_out_id# 
			</cfif>
		</cfquery>
	</cffunction>
	<cffunction name="control_devir_matrah" returntype="query">
		<cfargument name="puantaj_ids" default=""/>
		<cfargument name="employee_id" default=""/>
		<cfargument name="in_out_id" default=""/>
		<cfquery name="control_devir_matrah_query" datasource="#this.dsn#">
			SELECT 
				EPR.SSK_DEVIR,
				EPR.SSK_DEVIR_LAST,
				EPR.EMPLOYEE_ID,
				EPR.SUNDAY_COUNT,
				EP.*
			FROM 
				EMPLOYEES_PUANTAJ_ROWS EPR,
				EMPLOYEES_PUANTAJ EP
			WHERE 
				EP.PUANTAJ_ID = EPR.PUANTAJ_ID AND
				(
				(EPR.SSK_DEVIR IS NOT NULL AND EPR.SSK_DEVIR > 0)
				OR
				(EPR.SSK_DEVIR_LAST IS NOT NULL AND EPR.SSK_DEVIR_LAST > 0)
				)
				AND
				EPR.PUANTAJ_ID IN (#arguments.puantaj_ids#)
				<cfif len(arguments.EMPLOYEE_ID)>
					AND EPR.EMPLOYEE_ID = #arguments.EMPLOYEE_ID#
				</cfif>
				<cfif len(arguments.in_out_id)>AND EPR.IN_OUT_ID =#arguments.in_out_id# </cfif>
		</cfquery>
		<cfreturn control_devir_matrah_query/>
	</cffunction>
	<cffunction name="update_puantaj_rows_add_devir">
		<cfargument name="ssk_devir" default=""/>
		<cfargument name="puantaj_type" default=""/>
		<cfargument name="employee_id" default=""/>
		<cfargument name="sal_mon" default=""/>
		<cfargument name="sal_year" default=""/>
		<cfargument name="in_out_id" default=""/>
		<cfargument name="ssk_statue" default=""/>
		<cfargument name="statue_type" default=""/>

		<cfquery name="upd_" datasource="#this.DSN#">
			UPDATE
				EMPLOYEES_PUANTAJ_ROWS_ADD
			SET 
				AMOUNT_USED = (AMOUNT_USED - #ssk_devir#) 
			WHERE
				(
				<cfif puantaj_type eq -1>
				PUANTAJ_ID = 0 OR
				PUANTAJ_ID IS NULL OR
				</cfif>
				PUANTAJ_ID IN (SELECT PUANTAJ_ID FROM EMPLOYEES_PUANTAJ WHERE PUANTAJ_TYPE = #puantaj_type#)
				) AND
				EMPLOYEE_ID = #EMPLOYEE_ID# AND
				<cfif len(arguments.in_out_id)>IN_OUT_ID = #arguments.in_out_id# AND</cfif>
				<cfif sal_mon gt 2>
				(
				SAL_YEAR = #arguments.sal_year# AND
				SAL_MON = #sal_mon - 2#
				)
				<cfelseif sal_mon eq 1>
				(
				SAL_YEAR = #arguments.sal_year-1# AND
				SAL_MON = 11
				)
				<cfelseif sal_mon eq 2>
				(
				(SAL_YEAR = #arguments.sal_year-1# AND SAL_MON = 12)
				)
				</cfif>
		</cfquery>
	</cffunction>
	<cffunction name="update_puantaj_rows_add_devir_last">
		<cfargument name="ssk_devir_last" default=""/>
		<cfargument name="puantaj_type" default=""/>
		<cfargument name="employee_id" default=""/>
		<cfargument name="sal_mon" default=""/>
		<cfargument name="sal_year" default=""/>
		<cfargument name="in_out_id" default=""/>
		<cfargument name="ssk_statue" default=""/>
		<cfargument name="statue_type" default=""/>

		<cfquery name="upd_" datasource="#this.DSN#">
			UPDATE
				EMPLOYEES_PUANTAJ_ROWS_ADD
			SET 
				AMOUNT_USED = (AMOUNT_USED - #ssk_devir_last#) 
			WHERE
				(
				<cfif puantaj_type eq -1>
				PUANTAJ_ID = 0 OR
				PUANTAJ_ID IS NULL OR
				</cfif>
				PUANTAJ_ID IN (SELECT PUANTAJ_ID FROM EMPLOYEES_PUANTAJ WHERE PUANTAJ_TYPE = #puantaj_type#)
				) AND
				EMPLOYEE_ID = #EMPLOYEE_ID# AND
				<cfif len(arguments.in_out_id)>
					IN_OUT_ID = #arguments.in_out_id# AND
				</cfif>
				<cfif sal_mon gt 2>
				(
				SAL_YEAR = #arguments.sal_year# AND
				SAL_MON = #sal_mon - 1# 
				)
				<cfelseif sal_mon eq 1>
				(
				SAL_YEAR = #arguments.sal_year-1# AND
				SAL_MON = 12
				)
				<cfelseif sal_mon eq 2>
				SAL_YEAR = #arguments.sal_year# AND 
				SAL_MON = 1
				</cfif>
		</cfquery>
	</cffunction>
	<cffunction name="get_general_offtimes_all" returntype="query">
		<cfargument name="start_date" default=""/>
		<cfargument name="finish_date" default=""/>
		<cfquery name="get_general_offtimes_all_query" datasource="#this.dsn#">
			SELECT 
				START_DATE,
				FINISH_DATE 
			FROM 
				SETUP_GENERAL_OFFTIMES
			WHERE 
				START_DATE BETWEEN  <cfqueryparam CFSQLType = "cf_sql_timestamp" value = "#start_date#"> AND <cfqueryparam CFSQLType = "cf_sql_timestamp" value = "#finish_date#"> OR 
				FINISH_DATE BETWEEN <cfqueryparam CFSQLType = "cf_sql_timestamp" value = "#start_date#"> AND <cfqueryparam CFSQLType = "cf_sql_timestamp" value = "#finish_date#">
		</cfquery>
		<cfreturn get_general_offtimes_all_query/>
	</cffunction>
	<cffunction name="UPD_PAYROLL" access="remote">
		<cfargument name="payroll_id" default=""/>
		<cfargument name="json" default=""/>
		<cfquery name="UPD_PAYROLL" datasource="#DSN#">
			UPDATE 
				EMPLOYEES_PUANTAJ 
			SET 
				JSON_7256_LIST = <cfqueryparam value = "#arguments.json#" CFSQLType = "cf_sql_varchar"> 
			WHERE 
				PUANTAJ_ID = <cfqueryparam value = "#arguments.payroll_id#" CFSQLType = "cf_sql_integer">
		</cfquery>
		<cfreturn 1/>
	</cffunction>
</cfcomponent>