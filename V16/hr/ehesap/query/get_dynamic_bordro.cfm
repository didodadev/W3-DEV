<cfset puantaj_gun_ = daysinmonth(CREATEDATE(attributes.sal_year,attributes.SAL_MON,1))>
<cfset puantaj_finish_gun_ = daysinmonth(CREATEDATE(attributes.sal_year_end,attributes.SAL_MON_END,1))>
<cfset puantaj_start_ = CREATEODBCDATETIME(CREATEDATE(attributes.sal_year,attributes.SAL_MON,1))>
<cfset puantaj_finish_ = CREATEODBCDATETIME(DateAdd("d",1,CREATEDATE(attributes.sal_year_end,attributes.SAL_MON_END,puantaj_finish_gun_)))>
<cfset add_coloums = "EMPLOYEE_ID,SSK_NO,POSITION_BRANCH_ID,POSITION_DEPARTMENT_ID,TITLE_ID,POSITION_CAT_ID,POSITION_NAME,POSITION_CODE,UPPER_POSITION_EMPLOYEE,UPPER_POSITION_EMPLOYEE2,FUNC_ID,EXPENSE_CODE,ACCOUNT_CODE,EMP_BANK_ID">
<cfset total_coloums ="TOTAL_SALARY,TOTAL_PAY_SSK_TAX,TOTAL_PAY_SSK,TOTAL_PAY_TAX,TOTAL_PAY,SALARY,VERGI_INDIRIMI,SAKATLIK_INDIRIMI,KUMULATIF_GELIR_MATRAH,
GELIR_VERGISI_MATRAH,GELIR_VERGISI,VERGI_IADESI,MAHSUP_G_VERGISI,GELIR_VERGISI_INDIRIMI_5746,DAMGA_VERGISI,SSK_ISCI_HISSESI,SSDF_ISCI_HISSESI,ISSIZLIK_ISCI_HISSESI,
NET_UCRET,KIDEM_BOSS,KIDEM_WORKER,OZEL_KESINTI,AVANS,OFFDAYS_COUNT,OFFDAYS_SUNDAY_COUNT,IZIN,IZIN_PAID,PAID_IZINLI_SUNDAY_COUNT,SUNDAY_COUNT,VERGI_INDIRIMI_5084,
TOTAL_DAYS,SSK_DEVIR,SSK_DEVIR_LAST,SSK_AMOUNT,SSK_MATRAH,SSK_ISVEREN_HISSESI_5510,SSK_ISVEREN_HISSESI,SSK_ISVEREN_HISSESI_5084,SSK_ISVEREN_HISSESI_5921,SSK_ISVEREN_HISSESI_5746,
SSK_ISVEREN_HISSESI_6111,SSK_ISVEREN_HISSESI_6486,SSK_ISVEREN_HISSESI_6322,SSK_ISCI_HISSESI_6322,SSK_ISVEREN_HISSESI_GOV,ISSIZLIK_ISVEREN_HISSESI,SSK_ISCI_HISSESI_DUSULECEK,ISSIZLIK_ISCI_HISSESI_DUSULECEK,SSDF_ISVEREN_HISSESI,
VERGI_ISTISNA_VERGI,KIDEM_AMOUNT,IHBAR_AMOUNT,VERGI_ISTISNA_TOTAL,VERGI_ISTISNA_SSK,VERGI_ISTISNA_SSK_NET,VERGI_ISTISNA_VERGI_NET,VERGI_ISTISNA_DAMGA,VERGI_ISTISNA_DAMGA_NET,
IZINLI_SUNDAY_COUNT,YILLIK_IZIN_AMOUNT,EXT_SALARY,EXT_SALARY_NET,WORK_DAY_HOUR,SUNDAY_COUNT_HOUR,OFFDAYS_COUNT_HOUR,IZIN_PAID_COUNT,PAID_IZINLI_SUNDAY_COUNT_HOUR,IZIN_COUNT,EXT_TOTAL_HOURS_0,
EXT_TOTAL_HOURS_1,EXT_TOTAL_HOURS_2,EXT_TOTAL_HOURS_5,SSK_WORK_HOURS,IS_5746_CONTROL,SSK_DAYS,SSK_ISVEREN_HISSESI_25510">
<cfquery name="get_puantaj_rows" datasource="#dsn#">
	SELECT
		<cfloop list="#total_coloums#" index="ccm">
			EMPLOYEES_PUANTAJ_ROWS.#ccm#,
		</cfloop>
		<cfloop list="#add_coloums#" index="ccc">
			EMPLOYEES_PUANTAJ_ROWS.#ccc#,
		</cfloop>
        ISNULL((SELECT SUM(VERGI_ISTISNA_AMOUNT) AS VERGI_ISTISNA_AMOUNT FROM EMPLOYEES_PUANTAJ_ROWS_EXT RE WHERE RE.EXT_TYPE = 2 AND RE.EMPLOYEE_PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID AND RE.VERGI_ISTISNA_AMOUNT IS NOT NULL),0) AS VERGI_ISTISNA_AMOUNT_,       
		ISNULL((SELECT SUM(VERGI_ISTISNA_AMOUNT) FROM EMPLOYEES_PUANTAJ_ROWS_EXT EEP WHERE EEP.EMPLOYEE_PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID AND EEP.EXT_TYPE = 2),0) VERGI_ISTISNA_AMOUNT,
		ISNULL((SELECT COLLAR_TYPE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID AND IS_MASTER = 1),(SELECT COLLAR_TYPE FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = EMPLOYEES_PUANTAJ_ROWS.POSITION_CODE)) AS COLLAR_TYPE,
		EMPLOYEES_PUANTAJ.SAL_MON AS ROW_SAL_MON,
		EMPLOYEES_PUANTAJ.SAL_YEAR AS ROW_SAL_YEAR,
		EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID,
		EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID,
		BRANCH.BRANCH_ID,
		EMPLOYEES.HIERARCHY,
		EMPLOYEES.OZEL_KOD,
		EMPLOYEES.OZEL_KOD2,
		EMPLOYEES.DYNAMIC_HIERARCHY,
		EMPLOYEES.DYNAMIC_HIERARCHY_ADD,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES.EMPLOYEE_NO,
		EMPLOYEES.GROUP_STARTDATE,
		EMPLOYEES.KIDEM_DATE,
		EMPLOYEES_IDENTY.TC_IDENTY_NO,
		ISNULL(EMPLOYEES_IDENTY.BIRTH_DATE,0) AS DTrh,
		EMPLOYEES_IN_OUT.USE_SSK,
		EMPLOYEES_IN_OUT.USE_PDKS,
		<!---EMPLOYEES_IN_OUT.SALARY_TYPE,---><!--- puantaj satırındaki bilgiyi cekmeli SG 20130505--->
        EMPLOYEES_PUANTAJ_ROWS.SALARY_TYPE,
		EMPLOYEES_IN_OUT.FINISH_DATE,
		EMPLOYEES_IN_OUT.START_DATE,
		EMPLOYEES_PUANTAJ_ROWS.SSK_STATUTE,
		EMPLOYEES_IN_OUT.IN_OUT_ID,
		EMPLOYEES_PUANTAJ_ROWS.SABIT_PRIM,
		EMPLOYEES_IN_OUT.PAYMETHOD_ID,
		<!---EMPLOYEES_IN_OUT.GROSS_NET,---><!---puantaj satırındaki bilgiyi çekmeli SG 20130422 --->
		EMPLOYEES_PUANTAJ_ROWS.GROSS_NET,
		EMPLOYEES_IN_OUT.IS_5084 AS KISI_5084,
		EMPLOYEES_IN_OUT.IS_5510 AS KISI_5510,
		EMPLOYEES_IN_OUT.EXPLANATION_ID,
		CASE
			WHEN EMPLOYEES_IN_OUT.EX_IN_OUT_ID IS NOT NULL
			THEN 'Nakil'
			ELSE
				'Yeni Giriş'
			END AS EX_IN,
		BRANCH.IS_5510,
		BRANCH.RELATED_COMPANY,
		BRANCH.BRANCH_ID,
		BRANCH.BRANCH_NAME,
		DEPARTMENT.DEPARTMENT_ID,
		DEPARTMENT.DEPARTMENT_HEAD,
        CASE
        	WHEN DEPARTMENT.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID AND UPDATE_DATE IS NOT NULL)
       	THEN
        	ISNULL ((SELECT TOP 1 HIERARCHY_DEP_ID FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID AND ((YEAR(CHANGE_DATE) = EMPLOYEES_PUANTAJ.SAL_YEAR AND MONTH(CHANGE_DATE) <= EMPLOYEES_PUANTAJ.SAL_MON) OR YEAR(CHANGE_DATE) < EMPLOYEES_PUANTAJ.SAL_YEAR) ORDER BY CHANGE_DATE DESC, DEPT_HIST_ID DESC),(SELECT TOP 1 HIERARCHY_DEP_ID FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID AND CHANGE_DATE IS NULL ORDER BY ISNULL(UPDATE_DATE,RECORD_DATE) DESC, DEPT_HIST_ID DESC))
        ELSE
        	DEPARTMENT.HIERARCHY_DEP_ID
        END AS HIERARCHY_DEP_ID,
        CASE
        	WHEN DEPARTMENT.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID AND UPDATE_DATE IS NOT NULL)
       	THEN
        	ISNULL ((SELECT TOP 1 LEVEL_NO FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID AND ((YEAR(CHANGE_DATE) = EMPLOYEES_PUANTAJ.SAL_YEAR AND MONTH(CHANGE_DATE) <= EMPLOYEES_PUANTAJ.SAL_MON) OR YEAR(CHANGE_DATE) < EMPLOYEES_PUANTAJ.SAL_YEAR) ORDER BY CHANGE_DATE DESC, DEPT_HIST_ID DESC),(SELECT TOP 1 LEVEL_NO FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID AND CHANGE_DATE IS NULL ORDER BY ISNULL(UPDATE_DATE,RECORD_DATE) DESC, DEPT_HIST_ID DESC))
        ELSE
        	DEPARTMENT.LEVEL_NO
        END AS LEVEL_NO,
		<cfif isdefined("attributes.sort_type") and attributes.sort_type eq 1>
			BRANCH.BRANCH_NAME + '-' + DEPARTMENT.DEPARTMENT_HEAD AS TYPE,
		<cfelseif isdefined("attributes.sort_type") and attributes.sort_type eq 2>
			EMPLOYEES_PUANTAJ_ROWS.EXPENSE_CODE AS TYPE,
		<cfelseif isdefined("attributes.sort_type") and attributes.sort_type eq 3>
			EMPLOYEES_PUANTAJ_ROWS.UPPER_POSITION_NAME + '-' + EMPLOYEES_PUANTAJ_ROWS.UPPER_POSITION_EMPLOYEE AS TYPE,
		<cfelseif isdefined("attributes.sort_type") and attributes.sort_type eq 4>
			EMPLOYEES_PUANTAJ_ROWS.UPPER_POSITION_NAME2 + '-' + EMPLOYEES_PUANTAJ_ROWS.UPPER_POSITION_EMPLOYEE2 AS TYPE,
		<cfelseif isdefined("attributes.sort_type") and attributes.sort_type eq 5>
			EMPLOYEES_IDENTY.TC_IDENTY_NO AS TYPE,
		<cfelseif isdefined("attributes.sort_type") and attributes.sort_type eq 6>
			EMPLOYEES_PUANTAJ.SAL_MON + '-' + EMPLOYEES_PUANTAJ.SAL_YEAR AS TYPE,
		</cfif>
		ISNULL((SELECT TOP 1 M#attributes.SAL_MON# FROM EMPLOYEES_SALARY WHERE EMPLOYEES_SALARY.PERIOD_YEAR = #attributes.sal_year# AND EMPLOYEES_SALARY.IN_OUT_ID = EMPLOYEES_IN_OUT.IN_OUT_ID),0) AS MAAS,
		<cfloop from="1" to="12" index="ind">
			(SELECT TOP 1 M#ind# FROM EMPLOYEES_SALARY WHERE EMPLOYEES_SALARY.PERIOD_YEAR = EMPLOYEES_PUANTAJ.SAL_YEAR  AND EMPLOYEES_SALARY.IN_OUT_ID = EMPLOYEES_IN_OUT.IN_OUT_ID) AS M#ind#,		
		</cfloop>		
        ----- ISNULL((SELECT ACCOUNT_BILL_TYPE FROM EMPLOYEES_IN_OUT_PERIOD WHERE IN_OUT_ID = EMPLOYEES_IN_OUT.IN_OUT_ID AND PERIOD_ID = #session.ep.period_id#),0) ACCOUNT_BILL_TYPE,
		EMPLOYEES_PUANTAJ_ROWS.ACCOUNT_BILL_TYPE,
        WEEKLY_DAY,
		WEEKLY_HOUR,
		WEEKEND_DAY,
		WEEKEND_HOUR,
		WEEKLY_AMOUNT,
		WEEKEND_AMOUNT,
		OFFDAYS_AMOUNT,
		IZIN_AMOUNT,
		IZIN_PAID_AMOUNT,
		IZIN_SUNDAY_PAID_AMOUNT,
		EXT_TOTAL_HOURS_0_AMOUNT,
		EXT_TOTAL_HOURS_1_AMOUNT,
		EXT_TOTAL_HOURS_2_AMOUNT,
		EXT_TOTAL_HOURS_5_AMOUNT,
		TOTAL_AMOUNT,
		SETUP_BUSINESS_CODES.BUSINESS_CODE,
		SETUP_BUSINESS_CODES.BUSINESS_CODE_NAME,
		FR.REASON,
		BA.BANK_BRANCH_CODE,
		BA.BANK_ACCOUNT_NO,
		BA.IBAN_NO,
		BA.BANK_NAME,
		BA.EMP_BANK_ID,
        ERANK.GRADE,
        ERANK.STEP
	FROM
		EMPLOYEES_PUANTAJ_ROWS INNER JOIN EMPLOYEES_PUANTAJ ON EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID
		INNER JOIN EMPLOYEES_IN_OUT ON EMPLOYEES_IN_OUT.IN_OUT_ID = EMPLOYEES_PUANTAJ_ROWS.IN_OUT_ID 
		INNER JOIN BRANCH ON EMPLOYEES_PUANTAJ.SSK_BRANCH_ID = BRANCH.BRANCH_ID
		INNER JOIN DEPARTMENT ON EMPLOYEES_PUANTAJ_ROWS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID 
		INNER JOIN EMPLOYEES ON EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID
		INNER JOIN EMPLOYEES_IDENTY ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IDENTY.EMPLOYEE_ID		
		LEFT JOIN SETUP_BUSINESS_CODES ON  EMPLOYEES_IN_OUT.BUSINESS_CODE_ID = SETUP_BUSINESS_CODES.BUSINESS_CODE_ID
		LEFT JOIN SETUP_EMPLOYEE_FIRE_REASONS FR ON FR.REASON_ID = EMPLOYEES_IN_OUT.IN_COMPANY_REASON_ID
        LEFT JOIN EMPLOYEES_RANK_DETAIL ERANK ON ERANK.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND ERANK.ID = (SELECT TOP 1 ID FROM EMPLOYEES_RANK_DETAIL WHERE EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID ORDER BY PROMOTION_START DESC)
		LEFT JOIN 
			(SELECT 
				BANK_BRANCH_CODE,
				BANK_ACCOUNT_NO,
				IBAN_NO,
				SETUP_BANK_TYPES.BANK_NAME,
				EMP_BANK_ID
			FROM
				EMPLOYEES_BANK_ACCOUNTS INNER JOIN SETUP_BANK_TYPES ON EMPLOYEES_BANK_ACCOUNTS.BANK_ID = SETUP_BANK_TYPES.BANK_ID
			) BA ON BA.EMP_BANK_ID = EMPLOYEES_PUANTAJ_ROWS.EMP_BANK_ID		
	WHERE
		EMPLOYEES_PUANTAJ.PUANTAJ_TYPE = #attributes.puantaj_type# AND
		<cfif isdefined("attributes.upper_position_code") and len(attributes.upper_position_code) and len(attributes.upper_position)>
			EMPLOYEES_PUANTAJ_ROWS.UPPER_POSITION_CODE IN (#attributes.upper_position_code#) AND
		</cfif>
		<cfif isdefined("attributes.upper_position_code2") and len(attributes.upper_position_code2) and len(attributes.upper_position2)>
			EMPLOYEES_PUANTAJ_ROWS.UPPER_POSITION_CODE2 IN (#attributes.upper_position_code2#) AND
		</cfif>
		<cfif isdefined("attributes.position_department") and len(attributes.position_department)>
			EMPLOYEES_PUANTAJ_ROWS.POSITION_DEPARTMENT_ID IN (#attributes.position_department#) AND
		</cfif>
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			(
			EMPLOYEES_IN_OUT.PDKS_NUMBER = '#attributes.keyword#' OR
			EMPLOYEES_IN_OUT.RETIRED_SGDP_NUMBER = '#attributes.keyword#' OR
			EMPLOYEES_IN_OUT.SOCIALSECURITY_NO = '#attributes.keyword#' OR
			EMPLOYEES.EMPLOYEE_NAME + ' ' + EMPLOYEES.EMPLOYEE_SURNAME LIKE '%#URLDecode(attributes.keyword)#%' OR
			EMPLOYEES_IDENTY.TC_IDENTY_NO = '#attributes.keyword#' OR
			EMPLOYEES.EMPLOYEE_NO = '#attributes.keyword#'
			)
			AND
		</cfif>
		<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
			BRANCH.BRANCH_ID IN (#attributes.branch_id#) AND	
		</cfif>
        <cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
			BRANCH.COMPANY_ID IN (#attributes.comp_id#) AND	
		</cfif>
		<cfif isdefined("attributes.department") and len(attributes.department)>
       		<cfif isdefined('attributes.is_all_dep')>
            	DEPARTMENT.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM DEPARTMENT WHERE <cfif isdefined('attributes.is_dep_level')> LEVEL_NO IS NOT NULL AND </cfif> 
                	(<cfloop list="#attributes.department#" delimiters="," index="i">'.'+HIERARCHY_DEP_ID+'.' LIKE '%.#i#.%' OR </cfloop>1=0))
         	<cfelse>
            	DEPARTMENT.DEPARTMENT_ID IN (#attributes.department#)
			</cfif> AND	
		</cfif>
		<cfif isdefined("attributes.EXPENSE_CENTER") and listlen(attributes.EXPENSE_CENTER)>
			EMPLOYEES_PUANTAJ_ROWS.EXPENSE_CODE IN ('#replace(URLDecode(attributes.EXPENSE_CENTER),",","','","all")#') AND
		</cfif>
		<!--- EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID AND
		EMPLOYEES_IN_OUT.IN_OUT_ID = EMPLOYEES_PUANTAJ_ROWS.IN_OUT_ID AND
		EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID AND
		EMPLOYEES_IN_OUT.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND --->
		EMPLOYEES_IN_OUT.START_DATE < #puantaj_finish_# AND 
		(EMPLOYEES_IN_OUT.FINISH_DATE >= #puantaj_start_# OR EMPLOYEES_IN_OUT.FINISH_DATE IS NULL) AND
		<!--- EMPLOYEES_PUANTAJ.SSK_BRANCH_ID = BRANCH.BRANCH_ID AND --->
		(
			(EMPLOYEES_PUANTAJ.SAL_YEAR > #ATTRIBUTES.SAL_YEAR# AND EMPLOYEES_PUANTAJ.SAL_YEAR < #ATTRIBUTES.SAL_YEAR_END#)
			OR
			(
				EMPLOYEES_PUANTAJ.SAL_YEAR = #ATTRIBUTES.SAL_YEAR# AND 
				EMPLOYEES_PUANTAJ.SAL_MON >= #ATTRIBUTES.SAL_MON# AND
				(
					EMPLOYEES_PUANTAJ.SAL_YEAR < #ATTRIBUTES.SAL_YEAR_END#
					OR
					(EMPLOYEES_PUANTAJ.SAL_MON <= #ATTRIBUTES.SAL_MON_END# AND EMPLOYEES_PUANTAJ.SAL_YEAR = #ATTRIBUTES.SAL_YEAR_END#)
				)
			)
			OR
			(
				EMPLOYEES_PUANTAJ.SAL_YEAR > #ATTRIBUTES.SAL_YEAR# AND 
				(
					EMPLOYEES_PUANTAJ.SAL_YEAR < #ATTRIBUTES.SAL_YEAR_END#
					OR
					(EMPLOYEES_PUANTAJ.SAL_MON <= #ATTRIBUTES.SAL_MON_END# AND EMPLOYEES_PUANTAJ.SAL_YEAR = #ATTRIBUTES.SAL_YEAR_END#)
				)
			)
			OR
			(
				EMPLOYEES_PUANTAJ.SAL_YEAR = #ATTRIBUTES.SAL_YEAR_END# AND 
				EMPLOYEES_PUANTAJ.SAL_YEAR = #ATTRIBUTES.SAL_YEAR_END# AND
				EMPLOYEES_PUANTAJ.SAL_MON >= #ATTRIBUTES.SAL_MON# AND
				EMPLOYEES_PUANTAJ.SAL_MON <= #ATTRIBUTES.SAL_MON_END#
			)
		)<!--- AND
		 EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID AND
		EMPLOYEES_IDENTY.EMPLOYEE_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID AND --->
		<cfif isdefined("attributes.ssk_statute") and listlen(attributes.ssk_statute)>
			AND EMPLOYEES_IN_OUT.SSK_STATUTE IN (#attributes.ssk_statute#)
		</cfif>
		<!--- EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID --->
		<cfinclude template="../../query/get_emp_codes.cfm">
		<cfif len(emp_code_list)>
			AND 
				(
					<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
						EMPLOYEES.OZEL_KOD LIKE '%#code_i#%' OR
						EMPLOYEES.OZEL_KOD2 LIKE '%#code_i#%' OR
						EMPLOYEES.HIERARCHY LIKE '%#code_i#%' OR
						EMPLOYEES.EMPLOYEE_ID IN(SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE OZEL_KOD LIKE '%#code_i#%')
						<cfif listlen(emp_code_list,'+') gt 1 and listlast(emp_code_list,'+') neq code_i>OR</cfif>	 
					</cfloop>
					<cfif fusebox.dynamic_hierarchy>
					OR(
						<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
							<cfif database_type is "MSSQL">
								('.' + EMPLOYEES.DYNAMIC_HIERARCHY + '.' + EMPLOYEES.DYNAMIC_HIERARCHY_ADD + '.') LIKE '%.#code_i#.%'
								<cfif listlen(emp_code_list,'+') gt 1 and listlast(emp_code_list,'+') neq code_i>AND</cfif>
							<cfelseif database_type is "DB2">
								('.' || EMPLOYEES.DYNAMIC_HIERARCHY || '.' || EMPLOYEES.DYNAMIC_HIERARCHY_ADD || '.') LIKE '%.#code_i#.%'
								<cfif listlen(emp_code_list,'+') gt 1 and listlast(emp_code_list,'+') neq code_i>AND</cfif>
							</cfif>
						</cfloop>
					)
					</cfif>
				)
		</cfif>
		<!--- <cfif fusebox.dynamic_hierarchy>
				<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
					<cfif database_type is "MSSQL">
						AND 
						('.' + EMPLOYEES.DYNAMIC_HIERARCHY + '.' + EMPLOYEES.DYNAMIC_HIERARCHY_ADD + '.') LIKE '%.#code_i#.%'
							
					<cfelseif database_type is "DB2">
						AND 
						('.' || EMPLOYEES.DYNAMIC_HIERARCHY || '.' || EMPLOYEES.DYNAMIC_HIERARCHY_ADD || '.') LIKE '%.#code_i#.%'
							
					</cfif>
				</cfloop>
		<cfelse>
				<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
					<cfif database_type is "MSSQL">
						AND ('.' + EMPLOYEES.HIERARCHY + '.') LIKE '%.#code_i#.%'
					<cfelseif database_type is "DB2">
						AND ('.' || EMPLOYEES.HIERARCHY || '.') LIKE '%.#code_i#.%'
					</cfif>
				</cfloop>
		</cfif> --->

		<cfif not session.ep.ehesap>
			AND BRANCH.BRANCH_ID IN (
										SELECT
											BRANCH_ID
										FROM
											EMPLOYEE_POSITION_BRANCHES
										WHERE
											EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#
									)
		</cfif>
		<cfif isdefined("attributes.main_payment_control") and listlen(attributes.main_payment_control)>
			AND
				(
				<cfif listfindnocase(attributes.main_payment_control,-1)>					
					ROUND(((TOTAL_SALARY - (TOTAL_PAY_SSK_TAX + TOTAL_PAY_SSK + TOTAL_PAY_TAX + TOTAL_PAY)) / #dsn_alias#.IS_ZERO(TOTAL_DAYS,1) * 30),2) < CASE WHEN (EMPLOYEES_IDENTY.BIRTH_DATE IS NOT NULL AND DATEDIFF(year,EMPLOYEES_IDENTY.BIRTH_DATE,#CREATEODBCDATETIME(now())#) < 16) THEN (SELECT MIN_GROSS_PAYMENT_16 FROM INSURANCE_PAYMENT WHERE STARTDATE <= #puantaj_start_# AND FINISHDATE >= #puantaj_start_#) ELSE (SELECT MIN_PAYMENT FROM INSURANCE_PAYMENT WHERE STARTDATE <= #puantaj_start_# AND FINISHDATE >= #puantaj_start_#) END
				</cfif>
				<cfif listfindnocase(attributes.main_payment_control,0)>
					<cfif listfindnocase(attributes.main_payment_control,-1)>OR</cfif>
					ROUND(((TOTAL_SALARY-(TOTAL_PAY_SSK_TAX+TOTAL_PAY_SSK+TOTAL_PAY_TAX+TOTAL_PAY)) / #dsn_alias#.IS_ZERO(TOTAL_DAYS,1) * 30),2) = CASE WHEN (EMPLOYEES_IDENTY.BIRTH_DATE IS NOT NULL AND DATEDIFF(year,EMPLOYEES_IDENTY.BIRTH_DATE,#CREATEODBCDATETIME(now())#) < 16) THEN (SELECT MIN_GROSS_PAYMENT_16 FROM INSURANCE_PAYMENT WHERE STARTDATE <= #puantaj_start_# AND FINISHDATE >= #puantaj_start_#) ELSE (SELECT MIN_PAYMENT FROM INSURANCE_PAYMENT WHERE STARTDATE <= #puantaj_start_# AND FINISHDATE >= #puantaj_start_#) END
				</cfif>
				<cfif listfindnocase(attributes.main_payment_control,1)>
					<cfif listfindnocase(attributes.main_payment_control,-1) or listfindnocase(attributes.main_payment_control,0)>OR</cfif>
					ROUND(((TOTAL_SALARY-(TOTAL_PAY_SSK_TAX+TOTAL_PAY_SSK+TOTAL_PAY_TAX+TOTAL_PAY)) / #dsn_alias#.IS_ZERO(TOTAL_DAYS,1) * 30),2) > CASE WHEN (EMPLOYEES_IDENTY.BIRTH_DATE IS NOT NULL AND DATEDIFF(year,EMPLOYEES_IDENTY.BIRTH_DATE,#CREATEODBCDATETIME(now())#) < 16) THEN (SELECT MIN_GROSS_PAYMENT_16 FROM INSURANCE_PAYMENT WHERE STARTDATE <= #puantaj_start_# AND FINISHDATE >= #puantaj_start_#) ELSE (SELECT MIN_PAYMENT FROM INSURANCE_PAYMENT WHERE STARTDATE <= #puantaj_start_# AND FINISHDATE >= #puantaj_start_#) END
				</cfif>
				) 			
		</cfif>
	ORDER BY
		<cfif isdefined("attributes.sort_type") and attributes.sort_type eq 1>
			BRANCH.BRANCH_NAME,
			BRANCH.BRANCH_ID,
			DEPARTMENT.DEPARTMENT_HEAD,
			DEPARTMENT.DEPARTMENT_ID,
		<cfelseif isdefined("attributes.sort_type") and attributes.sort_type eq 2>
			EMPLOYEES_PUANTAJ_ROWS.EXPENSE_CODE,
		<cfelseif isdefined("attributes.sort_type") and attributes.sort_type eq 3>
			EMPLOYEES_PUANTAJ_ROWS.UPPER_POSITION_CODE,
		<cfelseif isdefined("attributes.sort_type") and attributes.sort_type eq 4>
			EMPLOYEES_PUANTAJ_ROWS.UPPER_POSITION_CODE2,
		<cfelseif isdefined("attributes.sort_type") and attributes.sort_type eq 5>
		<cfelseif isdefined("attributes.sort_type") and attributes.sort_type eq 6>
			EMPLOYEES_PUANTAJ.SAL_YEAR ASC,
			EMPLOYEES_PUANTAJ.SAL_MON ASC,
		</cfif>
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		<cfif not isdefined("attributes.sort_type") or attributes.sort_type neq 6>
			EMPLOYEES_PUANTAJ.SAL_YEAR ASC,
			EMPLOYEES_PUANTAJ.SAL_MON ASC,
		</cfif>
		EMPLOYEES_IN_OUT.IN_OUT_ID DESC
</cfquery>