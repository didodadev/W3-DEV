<cfcomponent>
    <cffunction name="get_dynamic_bordro" access="public" returntype="query">
        <cfargument name="sal_year" type="numeric" required="yes">
        <cfargument name="sal_mon" type="numeric" required="yes">
        <cfargument name="sal_year_end" type="numeric" required="yes">
        <cfargument name="sal_mon_end" type="numeric" required="yes">
        <cfargument name="puantaj_type" type="numeric" required="no">
        <cfargument name="keyword" type="string" required="no">
        <cfargument name="sort_type" type="string">
        <cfargument name="upper_position_code" type="string">
        <cfargument name="upper_position" type="string">
        <cfargument name="upper_position_code2" type="string" required="no">
        <cfargument name="upper_position2" type="string">
        <cfargument name="position_department" type="string" required="no">
        <cfargument name="position_branch_id" type="string" required="no">
        <cfargument name="branch_id" type="string">
        <cfargument name="comp_id" type="string" >
        <cfargument name="department" type="string">
        <cfargument name="expense_center" type="string">
        <cfargument name="is_all_dep" type="string">
        <cfargument name="is_dep_level" type="string">
        <cfargument name="ssk_statute" type="string">
        <cfargument name="duty_type" type="string">
        <cfargument name="department_level" default="0">
        <cfargument name="main_payment_control" type="string" required="no">
        <cfargument name="position_cat" type="string" required="no">
        <cfargument name="titles" type="string" required="no">
        <cfargument name="list_type" type="numeric" required="no" default="1">
        <cfargument name="emp_no" type="string" required="no" default="">
        <cfargument name="emp_name" type="string" required="no" default="">
		<cfset add_coloums = "EMPLOYEE_ID,SSK_NO,POSITION_BRANCH_ID,POSITION_DEPARTMENT_ID,TITLE_ID,POSITION_CAT_ID,POSITION_NAME,POSITION_CODE,UPPER_POSITION_EMPLOYEE,UPPER_POSITION_EMPLOYEE2,FUNC_ID,EXPENSE_CODE,ACCOUNT_CODE,EMP_BANK_ID,UPPER_POSITION_CODE,UPPER_POSITION_CODE2">
        <cfset total_coloums ="TOTAL_SALARY,TOTAL_PAY_SSK_TAX,TOTAL_PAY_SSK,TOTAL_PAY_TAX,TOTAL_PAY,SALARY,VERGI_INDIRIMI,SAKATLIK_INDIRIMI,KUMULATIF_GELIR_MATRAH,
        GELIR_VERGISI_MATRAH,GELIR_VERGISI,VERGI_IADESI,MAHSUP_G_VERGISI,GELIR_VERGISI_INDIRIMI_5746,GELIR_VERGISI_INDIRIMI_4691,DAMGA_VERGISI_MATRAH,DAMGA_VERGISI,SSK_ISCI_HISSESI,SSDF_ISCI_HISSESI,ISSIZLIK_ISCI_HISSESI,
        NET_UCRET,KIDEM_BOSS,KIDEM_WORKER,OZEL_KESINTI,OFFDAYS_COUNT,OFFDAYS_SUNDAY_COUNT,IZIN,IZIN_PAID,PAID_IZINLI_SUNDAY_COUNT,SUNDAY_COUNT,VERGI_INDIRIMI_5084,
        TOTAL_DAYS,SSK_DEVIR,SSK_DEVIR_LAST,SSK_AMOUNT,SSK_MATRAH,SSK_ISVEREN_HISSESI_5510,SSK_ISVEREN_HISSESI,SSK_ISVEREN_HISSESI_5084,SSK_ISVEREN_HISSESI_5921,SSK_ISVEREN_HISSESI_5746,SSK_ISVEREN_HISSESI_4691,
        SSK_ISVEREN_HISSESI_6111,SSK_ISVEREN_HISSESI_6645,SSK_ISVEREN_HISSESI_7252,ISSIZLIK_ISVEREN_HISSESI_7252,SSK_ISCI_HISSESI_7252,ISSIZLIK_ISCI_HISSESI_7252,SSK_ISVEREN_HISSESI_7256,ISSIZLIK_ISVEREN_HISSESI_7256,SSK_ISCI_HISSESI_7256,ISSIZLIK_ISCI_HISSESI_7256,SSK_ISVEREN_HISSESI_6486,SSK_ISVEREN_HISSESI_46486,SSK_ISVEREN_HISSESI_56486,SSK_ISVEREN_HISSESI_66486,SSK_ISVEREN_HISSESI_6322,SSK_ISCI_HISSESI_6322,SSK_ISVEREN_HISSESI_GOV,ISSIZLIK_ISVEREN_HISSESI,SSK_ISCI_HISSESI_DUSULECEK,ISSIZLIK_ISCI_HISSESI_DUSULECEK,SSDF_ISVEREN_HISSESI,
        VERGI_ISTISNA_VERGI,KIDEM_AMOUNT,IHBAR_AMOUNT,VERGI_ISTISNA_TOTAL,VERGI_ISTISNA_SSK,VERGI_ISTISNA_SSK_NET,VERGI_ISTISNA_VERGI_NET,VERGI_ISTISNA_DAMGA,VERGI_ISTISNA_DAMGA_NET,
        IZINLI_SUNDAY_COUNT,YILLIK_IZIN_AMOUNT,EXT_SALARY,EXT_SALARY_NET,WORK_DAY_HOUR,SUNDAY_COUNT_HOUR,OFFDAYS_COUNT_HOUR,IZIN_PAID_COUNT,PAID_IZINLI_SUNDAY_COUNT_HOUR,IZIN_COUNT,EXT_TOTAL_HOURS_0,
        EXT_TOTAL_HOURS_1,EXT_TOTAL_HOURS_2,EXT_TOTAL_HOURS_5,SSK_WORK_HOURS,SSK_DAYS,SSK_ISVEREN_HISSESI_25510,SSK_ISVEREN_HISSESI_14857,SSK_ISVEREN_HISSESI_3294,
		SSK_ISVEREN_HISSESI_687,SSK_ISCI_HISSESI_687,ISSIZLIK_ISCI_HISSESI_687,ISSIZLIK_ISVEREN_HISSESI_687,GELIR_VERGISI_INDIRIMI_687,DAMGA_VERGISI_INDIRIMI_687,BES_ISCI_HISSESI,
		SSK_ISVEREN_HISSESI_7103,SSK_ISCI_HISSESI_7103,ISSIZLIK_ISCI_HISSESI_7103,ISSIZLIK_ISVEREN_HISSESI_7103,GELIR_VERGISI_INDIRIMI_7103,DAMGA_VERGISI_INDIRIMI_7103,LAW_NUMBER_7103,DAMGA_VERGISI_INDIRIMI_5746,STAMPDUTY_5746,PAST_AGI_DAY_PAYROLL,EXT_TOTAL_HOURS_8,EXT_TOTAL_HOURS_9,EXT_TOTAL_HOURS_10,EXT_TOTAL_HOURS_11,EXT_TOTAL_HOURS_12,AKDI_DAY,AKDI_HOUR,AKDI_AMOUNT,
        DAILY_MINIMUM_WAGE_BASE_CUMULATE,MINIMUM_WAGE_CUMULATIVE,DAILY_MINIMUM_INCOME_TAX, DAILY_MINIMUM_WAGE_STAMP_TAX,DAILY_MINIMUM_WAGE,INCOME_TAX_TEMP,STAMP_TAX_TEMP,OZEL_KESINTI_2_NET_FARK,OZEL_KESINTI_2_NET">
        <cfset employees_info = "IS_5746_CONTROL, IS_4691_CONTROL">
        <cfset puantaj_finish_gun_ = daysinmonth(createdate(arguments.sal_year_end,arguments.sal_mon_end,1))>
        <cfset puantaj_start_ = createodbcdatetime(createdate(arguments.sal_year,arguments.sal_mon,1))>
        <cfset puantaj_finish_ = createodbcdatetime(DateAdd("d",1,createdate(arguments.sal_year_end,arguments.sal_mon_end,puantaj_finish_gun_)))>
        <cfif not session.ep.ehesap>
	        <cfquery name="get_emp_branches" datasource="#this.dsn#">
				SELECT DISTINCT
					BRANCH_ID
				FROM
					EMPLOYEE_POSITION_BRANCHES
				WHERE
					EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
			</cfquery>
			<cfset emp_branch_list = valuelist(get_emp_branches.branch_id)>
        </cfif>
        <cfquery name="get_emp_puantaj_ids" datasource="#this.dsn#">
        	SELECT DISTINCT
				EMPLOYEE_PUANTAJ_ID 
			FROM 
				EMPLOYEES_PUANTAJ_ROWS EPR
				INNER JOIN EMPLOYEES_PUANTAJ EP ON EPR.PUANTAJ_ID = EP.PUANTAJ_ID
				INNER JOIN BRANCH B ON EP.SSK_OFFICE = B.SSK_OFFICE AND EP.SSK_OFFICE_NO = B.SSK_NO
			WHERE 
				(
					(EP.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_year#"> AND EP.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_year_end#">)
					OR
					(
						EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_year#"> AND 
						EP.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_mon#"> AND
						(
							EP.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_year_end#"> OR
							(EP.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_mon_end#"> AND EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_year_end#">)
						)
					)
					OR
					(
						EP.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_year#"> AND 
						(
							EP.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_year_end#"> OR
							(EP.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_mon_end#"> AND EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_year_end#">)
						)
					)
					OR
					(
						EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_year_end#"> AND 
						EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_year_end#"> AND
						EP.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_mon#"> AND
						EP.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_mon_end#">
					)
				) 
				<cfif isdefined("arguments.branch_id") and len(arguments.branch_id)>
					AND B.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#arguments.branch_id#">)	
				</cfif>
                <cfif isdefined("arguments.comp_id") and len(arguments.comp_id)>
					AND B.COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#arguments.comp_id#">)	
				</cfif>
				<cfif not session.ep.ehesap>AND B.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#emp_branch_list#">)</cfif>
        </cfquery>
        <cfset employee_puantaj_ids = valuelist(get_emp_puantaj_ids.employee_puantaj_id)>
        <cfquery name="get_kesintis" datasource="#this.dsn#">
			SELECT DISTINCT
				COMMENT_PAY
			FROM 
				EMPLOYEES_PUANTAJ_ROWS_EXT
			WHERE 
				<cfif listlen(employee_puantaj_ids)>EMPLOYEE_PUANTAJ_ID IN (#employee_puantaj_ids#)<cfelse>1=0</cfif> AND 
				EXT_TYPE IN(1,3) AND
				COMMENT_PAY <> 'Avans'
		</cfquery>
		<cfset kesinti_names = listsort(valuelist(get_kesintis.comment_pay),"text","ASC")>
		<cfquery name="get_odeneks" datasource="#this.dsn#">
			SELECT DISTINCT
				EMPLOYEES_PUANTAJ_ROWS_EXT.COMMENT_PAY
			FROM 
				EMPLOYEES_PUANTAJ_ROWS_EXT 
				LEFT JOIN SETUP_PAYMENT_INTERRUPTION ON EMPLOYEES_PUANTAJ_ROWS_EXT.COMMENT_PAY_ID = SETUP_PAYMENT_INTERRUPTION.ODKES_ID
			WHERE 
				<cfif listlen(employee_puantaj_ids)>EMPLOYEE_PUANTAJ_ID IN (#employee_puantaj_ids#)<cfelse>1=0</cfif> AND 
				EXT_TYPE = 0
		</cfquery>
		<cfset odenek_names = listsort(valuelist(get_odeneks.comment_pay),"text","ASC")>
		<cfquery name="get_vergi_istisna" datasource="#this.dsn#">
			SELECT DISTINCT
				COMMENT_PAY
			FROM 
				EMPLOYEES_PUANTAJ_ROWS_EXT
			WHERE 
				<cfif listlen(employee_puantaj_ids)>EMPLOYEE_PUANTAJ_ID IN (#employee_puantaj_ids#)<cfelse>1=0</cfif> AND 
				EXT_TYPE = 2
		</cfquery>
		<cfset vergi_istisna_names = listsort(valuelist(get_vergi_istisna.comment_pay),"text","ASC")>
		<cfquery name="get_dep_lvl" datasource="#this.dsn#">
		    SELECT DISTINCT LEVEL_NO FROM DEPARTMENT WHERE LEVEL_NO IS NOT NULL ORDER BY LEVEL_NO
		</cfquery>
		<cfset dep_level_list = listsort(valuelist(get_dep_lvl.level_no),"numeric" ,"ASC")>
		<cfset count_kes = 0>
		<cfset count_ode = 0>
		<cfset count_vergi = 0>
        <cfquery name="get_puantaj_rows" datasource="#this.dsn#">
        	SELECT
        		<cfloop list="#total_coloums#" index="ccm">
                    #ccm#,
                </cfloop>
                <cfloop list="#add_coloums#" index="ccc">
                    #ccc#,
                </cfloop>
                <cfloop list="#employees_info#" index="ccd">
                    #ccd#,
                </cfloop>
                VERGI_ISTISNA_AMOUNT_,
                VERGI_ISTISNA_AMOUNT,
                COLLAR_TYPE,
                ROW_SAL_MON,
                ROW_SAL_YEAR,
                EMPLOYEE_PUANTAJ_ID,
                HIERARCHY,
                OZEL_KOD,
                OZEL_KOD2,
                DYNAMIC_HIERARCHY,
                DYNAMIC_HIERARCHY_ADD,
                EMPLOYEE_NAME,
                EMPLOYEE_SURNAME,
                EMPLOYEE_NO,
                GROUP_STARTDATE,
                KIDEM_DATE,
                TC_IDENTY_NO,
                DTrh,
                USE_SSK,
                USE_PDKS,
                SALARY_TYPE,
                PUANTAJ_GROUP_IDS,
                KISMI_ISTIHDAM_GUN,
				KISMI_ISTIHDAM_SAAT,
                FINISH_DATE,
                START_DATE,
                SSK_STATUTE,
                IN_OUT_ID,
                SABIT_PRIM,
                PAYMETHOD_ID,
                GROSS_NET,
                KISI_5084,
                KISI_5510,
                EXPLANATION_ID,
				CUMULATIVE_TAX_TOTAL,
				START_CUMULATIVE_TAX,
                DUTY_TYPE,
                EX_IN,
                IS_5510,
                RELATED_COMPANY,
                BRANCH_ID,
                BRANCH_NAME,
                DEPARTMENT_ID,
                DEPARTMENT_HEAD,
                HIERARCHY_DEP_ID,
                LEVEL_NO,
                <cfif isdefined("arguments.sort_type") and len(arguments.sort_type) and (arguments.sort_type eq 1 or arguments.sort_type eq 2 or arguments.sort_type eq 3 or arguments.sort_type eq 4 or arguments.sort_type eq 5 or arguments.sort_type eq 6)>
                TYPE,
                </cfif>
                MAAS,
                <cfloop from="1" to="12" index="ind">M#ind#,</cfloop>
                ACCOUNT_BILL_TYPE,
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
                EXT_TOTAL_HOURS_8_AMOUNT,
                EXT_TOTAL_HOURS_9_AMOUNT,
                EXT_TOTAL_HOURS_10_AMOUNT,
                EXT_TOTAL_HOURS_11_AMOUNT,
                EXT_TOTAL_HOURS_12_AMOUNT,
                TOTAL_AMOUNT,
                BUSINESS_CODE,
                BUSINESS_CODE_NAME,
                REASON,
                BANK_BRANCH_CODE,
                BANK_ACCOUNT_NO,
                IBAN_NO,
                BANK_NAME,
                GRADE,
                STEP,
                ORGANIZATION_STEP_NAME,
                SEX,
        		SUM(AVANS) AS AVANS
        		<cfif listlen(kesinti_names)>
	        		<cfloop from="1" to="#listlen(kesinti_names,',')#" index="j">
	        			,SUM(KESINTI_#j#) AS KESINTI_#j#
	        		</cfloop>
        		</cfif>
        		<cfif listlen(odenek_names)>
	        		<cfloop from="1" to="#listlen(odenek_names,',')#" index="k">
	        			,SUM(ODENEK_#k#) AS ODENEK_#k#
	        			,SUM(ODENEK_NET_#k#) AS ODENEK_NET_#k#
	        			,CALC_DAYS_#k#
	        			,FROM_SALARY_#k#
	        		</cfloop>
        		</cfif>
        		<cfif listlen(vergi_istisna_names)>
	        		<cfloop from="1" to="#listlen(vergi_istisna_names,',')#" index="x">
	        			,SUM(VERGI_ISTISNA_#x#) AS VERGI_ISTISNA_#x#
	        			,SUM(VERGI_ISTISNA_TOTAL_#x#) AS VERGI_ISTISNA_TOTAL_#x#
	        		</cfloop>
        		</cfif>
        		<cfif arguments.department_level eq '1' and listlen(dep_level_list)>
	        		<cfloop from="1" to="#listlen(dep_level_list,',')#" index="m">
	        			,DEPARTMAN#m#
	        		</cfloop>
        		</cfif>
        	FROM
        	(
            SELECT
                <cfloop list="#total_coloums#" index="ccm">
                    EMPLOYEES_PUANTAJ_ROWS.#ccm#,
                </cfloop>
                <cfloop list="#add_coloums#" index="ccc">
                    EMPLOYEES_PUANTAJ_ROWS.#ccc#,
                </cfloop>
                <cfloop list="#employees_info#" index="ccd">
                    EMPLOYEES_PUANTAJ_ROWS.#ccd#,
                </cfloop>
                ISNULL((SELECT SUM(VERGI_ISTISNA_AMOUNT) AS VERGI_ISTISNA_AMOUNT FROM EMPLOYEES_PUANTAJ_ROWS_EXT RE WHERE RE.EXT_TYPE = 2 AND RE.EMPLOYEE_PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID AND RE.VERGI_ISTISNA_AMOUNT IS NOT NULL),0) AS VERGI_ISTISNA_AMOUNT_,       
                ISNULL((SELECT SUM(VERGI_ISTISNA_AMOUNT) FROM EMPLOYEES_PUANTAJ_ROWS_EXT EEP WHERE EEP.EMPLOYEE_PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID AND EEP.EXT_TYPE = 2),0) VERGI_ISTISNA_AMOUNT,
                ISNULL((SELECT TOP 1 COLLAR_TYPE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID AND IS_MASTER = 1),(SELECT TOP 1 COLLAR_TYPE FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = EMPLOYEES_PUANTAJ_ROWS.POSITION_CODE)) AS COLLAR_TYPE,
                EMPLOYEES_PUANTAJ.SAL_MON AS ROW_SAL_MON,
                EMPLOYEES_PUANTAJ.SAL_YEAR AS ROW_SAL_YEAR,
                EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID,
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
                EMPLOYEES_PUANTAJ_ROWS.SALARY_TYPE,
                EMPLOYEES_IN_OUT.PUANTAJ_GROUP_IDS,
                EMPLOYEES_IN_OUT.FINISH_DATE,
                EMPLOYEES_IN_OUT.START_DATE,
                EMPLOYEES_PUANTAJ_ROWS.SSK_STATUTE,
                EMPLOYEES_IN_OUT.IN_OUT_ID,
                EMPLOYEES_PUANTAJ_ROWS.SABIT_PRIM,
                EMPLOYEES_IN_OUT.PAYMETHOD_ID,
                EMPLOYEES_PUANTAJ_ROWS.GROSS_NET,
                EMPLOYEES_IN_OUT.IS_5084 AS KISI_5084,
                EMPLOYEES_IN_OUT.IS_5510 AS KISI_5510,
                EMPLOYEES_IN_OUT.EXPLANATION_ID,
				EMPLOYEES_IN_OUT.CUMULATIVE_TAX_TOTAL,
				EMPLOYEES_IN_OUT.START_CUMULATIVE_TAX,
                EMPLOYEES_PUANTAJ_ROWS.KISMI_ISTIHDAM_GUN,
                EMPLOYEES_PUANTAJ_ROWS.KISMI_ISTIHDAM_SAAT,
                CASE
                	WHEN EMPLOYEES_IN_OUT.DUTY_TYPE = 0 THEN 'İşveren'
                	WHEN EMPLOYEES_IN_OUT.DUTY_TYPE = 1 THEN 'İşveren Vekili'
                	WHEN EMPLOYEES_IN_OUT.DUTY_TYPE = 2 THEN 'Çalışan'
                	WHEN EMPLOYEES_IN_OUT.DUTY_TYPE = 3 THEN 'Sendikalı'
                	WHEN EMPLOYEES_IN_OUT.DUTY_TYPE = 4 THEN 'Sözleşmeli'
                	WHEN EMPLOYEES_IN_OUT.DUTY_TYPE = 5 THEN 'Kapsam Dışı'
                	WHEN EMPLOYEES_IN_OUT.DUTY_TYPE = 6 THEN 'Kısmi İstihdam'
                	WHEN EMPLOYEES_IN_OUT.DUTY_TYPE = 7 THEN 'Taşeron'
                	WHEN EMPLOYEES_IN_OUT.DUTY_TYPE = 8 THEN 'Derece/Kademe'
               	END AS DUTY_TYPE,
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
                <cfif isdefined("arguments.sort_type") and len(arguments.sort_type) and arguments.sort_type eq 1>
                    BRANCH.BRANCH_NAME + '-' + DEPARTMENT.DEPARTMENT_HEAD AS TYPE,
                <cfelseif isdefined("arguments.sort_type") and len(arguments.sort_type) and arguments.sort_type eq 2>
                    EMPLOYEES_PUANTAJ_ROWS.EXPENSE_CODE AS TYPE,
                <cfelseif isdefined("arguments.sort_type") and len(arguments.sort_type) and arguments.sort_type eq 3>
                    EMPLOYEES_PUANTAJ_ROWS.UPPER_POSITION_NAME + '-' + EMPLOYEES_PUANTAJ_ROWS.UPPER_POSITION_EMPLOYEE AS TYPE,
                <cfelseif isdefined("arguments.sort_type") and len(arguments.sort_type) and arguments.sort_type eq 4>
                    EMPLOYEES_PUANTAJ_ROWS.UPPER_POSITION_NAME2 + '-' + EMPLOYEES_PUANTAJ_ROWS.UPPER_POSITION_EMPLOYEE2 AS TYPE,
                <cfelseif isdefined("arguments.sort_type") and len(arguments.sort_type) and arguments.sort_type eq 5>
                    EMPLOYEES_IDENTY.TC_IDENTY_NO AS TYPE,
                <cfelseif isdefined("arguments.sort_type") and len(arguments.sort_type) and arguments.sort_type eq 6>
                    EMPLOYEES_PUANTAJ.SAL_MON + '-' + EMPLOYEES_PUANTAJ.SAL_YEAR AS TYPE,
                </cfif>
                ISNULL((SELECT TOP 1 M#arguments.SAL_MON# FROM EMPLOYEES_SALARY WHERE EMPLOYEES_SALARY.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_year#"> AND EMPLOYEES_SALARY.IN_OUT_ID = EMPLOYEES_IN_OUT.IN_OUT_ID),0) AS MAAS,
                <cfloop from="1" to="12" index="ind">
                    ISNULL((SELECT TOP 1 M#ind# FROM EMPLOYEES_SALARY WHERE EMPLOYEES_SALARY.PERIOD_YEAR = EMPLOYEES_PUANTAJ.SAL_YEAR AND EMPLOYEES_SALARY.IN_OUT_ID = EMPLOYEES_IN_OUT.IN_OUT_ID),0) AS M#ind#,		
                </cfloop>		
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
                EXT_TOTAL_HOURS_8_AMOUNT,
                EXT_TOTAL_HOURS_9_AMOUNT,
                EXT_TOTAL_HOURS_10_AMOUNT,
                EXT_TOTAL_HOURS_11_AMOUNT,
                EXT_TOTAL_HOURS_12_AMOUNT,
                TOTAL_AMOUNT,
                SETUP_BUSINESS_CODES.BUSINESS_CODE,
                SETUP_BUSINESS_CODES.BUSINESS_CODE_NAME,
                FR.REASON,
                BA.BANK_BRANCH_CODE,
                BA.BANK_ACCOUNT_NO,
                BA.IBAN_NO,
                BA.BANK_NAME,
                ERANK.GRADE,
                ERANK.STEP,
                SETUP_ORGANIZATION_STEPS.ORGANIZATION_STEP_NAME,
                EMPLOYEES_DETAIL.SEX,
                (ISNULL(AVANS_KES.AMOUNT,0) + EMPLOYEES_PUANTAJ_ROWS.AVANS) AS AVANS
                <cfif listlen(kesinti_names)>
	                <cfloop from="1" to="#listlen(kesinti_names,',')#" index="j">
	                	,ISNULL(KESINTI#j#_AMOUNT.AMOUNT,0) AS KESINTI_#j#
	        		</cfloop>
	        	</cfif>
	        	<cfif listlen(odenek_names)>
	                <cfloop list="#odenek_names#" index="aa">
	                	<cfset count_ode = count_ode + 1>
	                	,ISNULL(ODENEK#count_ode#_AMOUNT.AMOUNT,0) AS ODENEK_#count_ode#
	                	,ISNULL(ODENEK#count_ode#_NET.AMOUNT,0) AS ODENEK_NET_#count_ode#
	                	,(SELECT TOP 1 CALC_DAYS FROM SETUP_PAYMENT_INTERRUPTION WHERE COMMENT_PAY = '#aa#') AS CALC_DAYS_#count_ode#
	                	,(SELECT TOP 1 FROM_SALARY FROM SETUP_PAYMENT_INTERRUPTION WHERE COMMENT_PAY = '#aa#') AS FROM_SALARY_#count_ode#
	                </cfloop>
	                <cfset count_ode = 0>
	        	</cfif>
	        	<cfif listlen(vergi_istisna_names)>
	                <cfloop from="1" to="#listlen(vergi_istisna_names,',')#" index="x">
	                	,ISNULL(GET_VERGI_ISTISNA#x#.VERGI_ISTISNA_AMOUNT,0) AS VERGI_ISTISNA_#x#
	                	,ISNULL(GET_VERGI_ISTISNA#x#.VERGI_ISTISNA_TOTAL,0) AS VERGI_ISTISNA_TOTAL_#x#
	                </cfloop>
                </cfif>
                <cfif arguments.department_level eq '1' and listlen(dep_level_list)>
                	<cfset count_dep = 0>
                	<cfloop list="#dep_level_list#" index="mm">
                		<cfset count_dep = count_dep + 1>
                		,(SELECT TOP 1 DEPARTMENT_HEAD FROM 
                		(SELECT
                        	DP.DEPARTMENT_HEAD, 
                            CASE WHEN DEPARTMENT_HISTORY.DEPARTMENT_ID IS NOT NULL
                            THEN DEPARTMENT_HISTORY.LEVEL_NO
                            ELSE (SELECT TOP 1 LEVEL_NO FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID = DP.DEPARTMENT_ID AND CHANGE_DATE IS NULL ORDER BY ISNULL(UPDATE_DATE,RECORD_DATE) DESC)
                           END AS LEVEL_NO
                        FROM 
                            DEPARTMENT DP
                            LEFT JOIN DEPARTMENT_HISTORY ON DP.DEPARTMENT_ID = DEPARTMENT_HISTORY.DEPARTMENT_ID AND DEPT_HIST_ID = (SELECT TOP 1 DEPT_HIST_ID FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID = DP.DEPARTMENT_ID AND DEPARTMENT_HISTORY.CHANGE_DATE IS NOT NULL AND ((YEAR(CHANGE_DATE) = EMPLOYEES_PUANTAJ.SAL_YEAR AND MONTH(CHANGE_DATE) <= EMPLOYEES_PUANTAJ.SAL_MON) OR YEAR(CHANGE_DATE) < EMPLOYEES_PUANTAJ.SAL_YEAR) ORDER BY CHANGE_DATE DESC)
                         WHERE 
                            (CASE
                    WHEN DEPARTMENT.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID AND UPDATE_DATE IS NOT NULL)
                THEN
                    ISNULL ((SELECT TOP 1 '.'+HIERARCHY_DEP_ID+'.' FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID AND ((YEAR(CHANGE_DATE) = EMPLOYEES_PUANTAJ.SAL_YEAR AND MONTH(CHANGE_DATE) <= EMPLOYEES_PUANTAJ.SAL_MON) OR YEAR(CHANGE_DATE) < EMPLOYEES_PUANTAJ.SAL_YEAR) ORDER BY CHANGE_DATE DESC, DEPT_HIST_ID DESC),(SELECT TOP 1 '.'+HIERARCHY_DEP_ID+'.' FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID AND CHANGE_DATE IS NULL ORDER BY ISNULL(UPDATE_DATE,RECORD_DATE) DESC, DEPT_HIST_ID DESC))
                ELSE
                    '.'+DEPARTMENT.HIERARCHY_DEP_ID+'.'
                END) LIKE '%.'+CAST(DP.DEPARTMENT_ID AS nvarchar)+'.%') AS TBL
                		 WHERE LEVEL_NO = #mm#) AS DEPARTMAN#count_dep#
                	</cfloop>
                </cfif>
            FROM
                EMPLOYEES_PUANTAJ_ROWS INNER JOIN EMPLOYEES_PUANTAJ ON EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID
                INNER JOIN EMPLOYEES_IN_OUT ON EMPLOYEES_IN_OUT.IN_OUT_ID = EMPLOYEES_PUANTAJ_ROWS.IN_OUT_ID 
                INNER JOIN BRANCH ON EMPLOYEES_PUANTAJ.SSK_BRANCH_ID = BRANCH.BRANCH_ID
                LEFT JOIN DEPARTMENT ON EMPLOYEES_PUANTAJ_ROWS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID 
                INNER JOIN EMPLOYEES ON EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID
                INNER JOIN EMPLOYEES_IDENTY ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IDENTY.EMPLOYEE_ID	
                LEFT JOIN EMPLOYEES_DETAIL ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_DETAIL.EMPLOYEE_ID	
                LEFT JOIN SETUP_BUSINESS_CODES ON  EMPLOYEES_IN_OUT.BUSINESS_CODE_ID = SETUP_BUSINESS_CODES.BUSINESS_CODE_ID
                LEFT JOIN SETUP_EMPLOYEE_FIRE_REASONS FR ON FR.REASON_ID = EMPLOYEES_IN_OUT.IN_COMPANY_REASON_ID
                LEFT JOIN EMPLOYEES_RANK_DETAIL ERANK ON ERANK.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND ERANK.ID = (SELECT TOP 1 ID FROM EMPLOYEES_RANK_DETAIL WHERE EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID ORDER BY PROMOTION_START DESC)
                LEFT JOIN SETUP_ORGANIZATION_STEPS ON SETUP_ORGANIZATION_STEPS.ORGANIZATION_STEP_ID = EMPLOYEES_PUANTAJ_ROWS.ORGANIZATION_STEP_ID
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
				LEFT JOIN
				(
					SELECT 
						EMPLOYEE_PUANTAJ_ID, 
						SUM(AMOUNT) AS AMOUNT
					FROM 
						EMPLOYEES_PUANTAJ_ROWS_EXT
					WHERE
						EXT_TYPE = 1 AND COMMENT_PAY = 'Avans'
						GROUP BY EMPLOYEE_PUANTAJ_ID
				) AS AVANS_KES ON AVANS_KES.EMPLOYEE_PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID
                <cfloop list="#kesinti_names#" index="cc">
                	<cfset count_kes = count_kes + 1>
					LEFT JOIN
					(
						SELECT
							EMPLOYEE_PUANTAJ_ID,
							SUM(AMOUNT) AS AMOUNT
						FROM
						(
							SELECT
								EMPLOYEE_PUANTAJ_ID,
								AMOUNT AS AMOUNT
							FROM
								EMPLOYEES_PUANTAJ_ROWS_EXT
							WHERE
								(
                                (EXT_TYPE = 1 AND (PAY_METHOD NOT IN (2,3,4,5) OR PAY_METHOD IS NULL))
                                OR 
                                EXT_TYPE = 3 AND PAY_METHOD <> 1
                                )
                                
                                AND COMMENT_PAY = '#cc#'
							UNION ALL
							SELECT
								EMPLOYEE_PUANTAJ_ID,
								AMOUNT_2 AS AMOUNT
							FROM
								EMPLOYEES_PUANTAJ_ROWS_EXT
							WHERE
								( (EXT_TYPE = 1 AND PAY_METHOD IN (2,3,4,5))
                               OR
                               	EXT_TYPE = 3 AND PAY_METHOD = 1
                               	)
                                 
                               	AND COMMENT_PAY = '#cc#'
						) AS T1
						GROUP BY EMPLOYEE_PUANTAJ_ID
					) AS KESINTI#count_kes#_AMOUNT ON KESINTI#count_kes#_AMOUNT.EMPLOYEE_PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID
                </cfloop>
                <cfloop list="#odenek_names#" index="aa">
                	<cfset count_ode = count_ode + 1>
					LEFT JOIN
					(
						SELECT
							EMPLOYEE_PUANTAJ_ID,
							SUM(AMOUNT) AS AMOUNT
						FROM
						(
							SELECT
								EMPLOYEES_PUANTAJ_ROWS_EXT.EMPLOYEE_PUANTAJ_ID,
								EMPLOYEES_PUANTAJ_ROWS_EXT.AMOUNT_2 AS AMOUNT
							FROM
								EMPLOYEES_PUANTAJ_ROWS_EXT 
								LEFT JOIN SETUP_PAYMENT_INTERRUPTION ON EMPLOYEES_PUANTAJ_ROWS_EXT.COMMENT_PAY_ID = SETUP_PAYMENT_INTERRUPTION.ODKES_ID
							WHERE
								EMPLOYEES_PUANTAJ_ROWS_EXT.EXT_TYPE = 0 AND
								EMPLOYEES_PUANTAJ_ROWS_EXT.PAY_METHOD = 2 AND
								EMPLOYEES_PUANTAJ_ROWS_EXT.COMMENT_PAY = '#aa#'
							UNION ALL
							SELECT
								EMPLOYEES_PUANTAJ_ROWS_EXT.EMPLOYEE_PUANTAJ_ID,
								EMPLOYEES_PUANTAJ_ROWS_EXT.AMOUNT
							FROM
								EMPLOYEES_PUANTAJ_ROWS_EXT 
								LEFT JOIN SETUP_PAYMENT_INTERRUPTION ON EMPLOYEES_PUANTAJ_ROWS_EXT.COMMENT_PAY_ID = SETUP_PAYMENT_INTERRUPTION.ODKES_ID
							WHERE
								EMPLOYEES_PUANTAJ_ROWS_EXT.EXT_TYPE = 0 AND
								(EMPLOYEES_PUANTAJ_ROWS_EXT.PAY_METHOD <> 2 OR EMPLOYEES_PUANTAJ_ROWS_EXT.PAY_METHOD IS NULL) AND
								EMPLOYEES_PUANTAJ_ROWS_EXT.COMMENT_PAY = '#aa#'
						) AS T2
						GROUP BY EMPLOYEE_PUANTAJ_ID
					) AS ODENEK#count_ode#_AMOUNT ON ODENEK#count_ode#_AMOUNT.EMPLOYEE_PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID
					LEFT JOIN
					(
						SELECT
							EMPLOYEES_PUANTAJ_ROWS_EXT.EMPLOYEE_PUANTAJ_ID,
							SUM(EMPLOYEES_PUANTAJ_ROWS_EXT.AMOUNT_PAY) AS AMOUNT
						FROM
							EMPLOYEES_PUANTAJ_ROWS_EXT 
							LEFT JOIN SETUP_PAYMENT_INTERRUPTION ON EMPLOYEES_PUANTAJ_ROWS_EXT.COMMENT_PAY_ID = SETUP_PAYMENT_INTERRUPTION.ODKES_ID
						WHERE
							EMPLOYEES_PUANTAJ_ROWS_EXT.EXT_TYPE = 0 AND
							(EMPLOYEES_PUANTAJ_ROWS_EXT.PAY_METHOD <> 2 OR EMPLOYEES_PUANTAJ_ROWS_EXT.PAY_METHOD IS NULL) AND
							EMPLOYEES_PUANTAJ_ROWS_EXT.COMMENT_PAY = '#aa#'
						GROUP BY
							EMPLOYEES_PUANTAJ_ROWS_EXT.EMPLOYEE_PUANTAJ_ID
					) AS ODENEK#count_ode#_NET ON ODENEK#count_ode#_NET.EMPLOYEE_PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID
				</cfloop>
                <cfloop list="#vergi_istisna_names#" index="bb">
                	<cfset count_vergi = count_vergi + 1>
					LEFT JOIN
					(
						SELECT
							EMPLOYEE_PUANTAJ_ID,
							SUM(VERGI_ISTISNA_AMOUNT) VERGI_ISTISNA_AMOUNT,
							SUM(VERGI_ISTISNA_TOTAL) VERGI_ISTISNA_TOTAL
						FROM
							EMPLOYEES_PUANTAJ_ROWS_EXT
						WHERE
							EXT_TYPE = 2 AND
							COMMENT_PAY = '#bb#'
						GROUP BY
							EMPLOYEE_PUANTAJ_ID
					) AS GET_VERGI_ISTISNA#count_vergi# ON GET_VERGI_ISTISNA#count_vergi#.EMPLOYEE_PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID
                </cfloop>
            WHERE
                EMPLOYEES_PUANTAJ.PUANTAJ_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.puantaj_type#"> AND
                <cfif isdefined("arguments.upper_position_code") and len(arguments.upper_position_code) and len(arguments.upper_position)>
                    EMPLOYEES_PUANTAJ_ROWS.UPPER_POSITION_CODE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#arguments.upper_position_code#">) AND
                </cfif>
                <cfif isdefined("arguments.upper_position_code2") and len(arguments.upper_position_code2) and len(arguments.upper_position2)>
                    EMPLOYEES_PUANTAJ_ROWS.UPPER_POSITION_CODE2 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#arguments.upper_position_code2#">) AND
                </cfif>
                <cfif isdefined("arguments.position_department") and len(arguments.position_department)>
                    EMPLOYEES_PUANTAJ_ROWS.POSITION_DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#arguments.position_department#">) AND
                </cfif>
                <cfif isdefined("arguments.position_branch_id") and len(arguments.position_branch_id)>
                    EMPLOYEES_PUANTAJ_ROWS.POSITION_BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#arguments.position_branch_id#">) AND
                </cfif> 
                <cfif isdefined("arguments.position_cat") and len(arguments.position_cat)>
                    EMPLOYEES_PUANTAJ_ROWS.POSITION_CAT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#arguments.position_cat#">) AND
                </cfif>
                 <cfif isdefined("arguments.titles") and len(arguments.titles)>
                    EMPLOYEES_PUANTAJ_ROWS.TITLE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#arguments.titles#">) AND
                </cfif>
                <cfif isdefined("arguments.keyword") and len(arguments.keyword)>
                    (
                    EMPLOYEES_IN_OUT.PDKS_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#"> OR
                    EMPLOYEES_IN_OUT.RETIRED_SGDP_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#"> OR
                    EMPLOYEES_IN_OUT.SOCIALSECURITY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#"> OR
                    EMPLOYEES.EMPLOYEE_NAME + ' ' + EMPLOYEES.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDecode(arguments.keyword)#%"> OR
                    EMPLOYEES_IDENTY.TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#"> OR
                    EMPLOYEES.EMPLOYEE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#">
                    )
                    AND
                </cfif>
                <cfif len(arguments.emp_no)>
                    EMPLOYEES.EMPLOYEE_NO LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#arguments.emp_no#%"> AND
                </cfif>
                <cfif len(arguments.emp_name)>
                    EMPLOYEES.EMPLOYEE_NAME + EMPLOYEES.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#arguments.emp_name#%"> AND
                </cfif>
                <cfif isdefined("arguments.branch_id") and len(arguments.branch_id)>
                    BRANCH.BRANCH_ID IN (#arguments.branch_id#) AND	
                </cfif>
                <cfif isdefined("arguments.comp_id") and len(arguments.comp_id)>
                    BRANCH.COMPANY_ID IN (#arguments.comp_id#) AND	
                </cfif>
                <cfif isdefined("arguments.department") and len(arguments.department)>
                    <cfif isdefined('arguments.is_all_dep') and len(arguments.is_all_dep) >
                        DEPARTMENT.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM DEPARTMENT WHERE <cfif isdefined('arguments.is_dep_level')> LEVEL_NO IS NOT NULL AND </cfif> 
                            (<cfloop list="#arguments.department#" delimiters="," index="i">'.'+HIERARCHY_DEP_ID+'.' LIKE '%.#i#.%' OR </cfloop>1=0))
                    <cfelse>
                        DEPARTMENT.DEPARTMENT_ID IN (#arguments.department#)
                    </cfif> AND	
                </cfif>
                <cfif isdefined("arguments.EXPENSE_CENTER") and listlen(arguments.EXPENSE_CENTER)>
                    EMPLOYEES_PUANTAJ_ROWS.EXPENSE_CODE IN ('#replace(URLDecode(arguments.EXPENSE_CENTER),",","','","all")#') AND
                </cfif>
                EMPLOYEES_IN_OUT.START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_finish_#"> AND 
                (EMPLOYEES_IN_OUT.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_start_#"> 
                	OR 
                 EMPLOYEES_IN_OUT.FINISH_DATE IS NULL) AND
                (
                    (EMPLOYEES_PUANTAJ.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SAL_YEAR#"> AND 
                    EMPLOYEES_PUANTAJ.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SAL_YEAR_END#">)
                    OR
                    (
                        EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SAL_YEAR#"> AND 
                        EMPLOYEES_PUANTAJ.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SAL_MON#"> AND
                        (
                            EMPLOYEES_PUANTAJ.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SAL_YEAR_END#">
                            OR
                            (EMPLOYEES_PUANTAJ.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SAL_MON_END#"> AND 
                            EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SAL_YEAR_END#">)
                        )
                    )
                    OR
                    (
                        EMPLOYEES_PUANTAJ.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SAL_YEAR#"> AND 
                        (
                            EMPLOYEES_PUANTAJ.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SAL_YEAR_END#">
                            OR
                            (EMPLOYEES_PUANTAJ.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SAL_MON_END#"> AND 
                            EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SAL_YEAR_END#">)
                        )
                    )
                    OR
                    (
                        EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SAL_YEAR_END#"> AND 
                        EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SAL_YEAR_END#"> AND
                        EMPLOYEES_PUANTAJ.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SAL_MON#"> AND
                        EMPLOYEES_PUANTAJ.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SAL_MON_END#">
                    )
                )
                <cfif isdefined("arguments.ssk_statute") and listlen(arguments.ssk_statute)>
                   AND EMPLOYEES_IN_OUT.SSK_STATUTE IN (#arguments.ssk_statute#)
                </cfif>
                <cfif isdefined("arguments.duty_type") and listlen(arguments.duty_type)>
                   AND EMPLOYEES_IN_OUT.DUTY_TYPE IN (#arguments.duty_type#)
                </cfif>
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
                <cfif not session.ep.ehesap>
                    AND BRANCH.BRANCH_ID IN (
                                                SELECT
                                                    BRANCH_ID
                                                FROM
                                                    EMPLOYEE_POSITION_BRANCHES
                                                WHERE
                                                    EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
                                            )
                </cfif>
                <cfif isdefined("arguments.main_payment_control") and listlen(arguments.main_payment_control)>
                    AND
                        (
                        <cfif listfindnocase(arguments.main_payment_control,-1)>					
                            ROUND(((TOTAL_SALARY - (TOTAL_PAY_SSK_TAX + TOTAL_PAY_SSK + TOTAL_PAY_TAX + TOTAL_PAY)-EXT_SALARY) / #this.dsn_alias#.IS_ZERO(TOTAL_DAYS,1) * 30),2) < CASE WHEN (EMPLOYEES_IDENTY.BIRTH_DATE IS NOT NULL AND DATEDIFF(year,EMPLOYEES_IDENTY.BIRTH_DATE,#CREATEODBCDATETIME(now())#) < 16) THEN (SELECT MIN_GROSS_PAYMENT_16 FROM INSURANCE_PAYMENT WHERE STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_start_#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_start_#">) ELSE (SELECT MIN_PAYMENT FROM INSURANCE_PAYMENT WHERE STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_start_#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_start_#">) END
                        </cfif>
                        <cfif listfindnocase(arguments.main_payment_control,0)>
                            <cfif listfindnocase(arguments.main_payment_control,-1)>OR</cfif>
                            ROUND(((TOTAL_SALARY-(TOTAL_PAY_SSK_TAX+TOTAL_PAY_SSK+TOTAL_PAY_TAX+TOTAL_PAY)-EXT_SALARY) / #this.dsn_alias#.IS_ZERO(TOTAL_DAYS,1) * 30),2) = CASE WHEN (EMPLOYEES_IDENTY.BIRTH_DATE IS NOT NULL AND DATEDIFF(year,EMPLOYEES_IDENTY.BIRTH_DATE,#CREATEODBCDATETIME(now())#) < 16) THEN (SELECT MIN_GROSS_PAYMENT_16 FROM INSURANCE_PAYMENT WHERE STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_start_#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_start_#">) ELSE (SELECT MIN_PAYMENT FROM INSURANCE_PAYMENT WHERE STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_start_#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_start_#">) END
                        </cfif>
                        <cfif listfindnocase(arguments.main_payment_control,1)>
                            <cfif listfindnocase(arguments.main_payment_control,-1) or listfindnocase(arguments.main_payment_control,0)>OR</cfif>
                            ROUND(((TOTAL_SALARY-(TOTAL_PAY_SSK_TAX+TOTAL_PAY_SSK+TOTAL_PAY_TAX+TOTAL_PAY)-EXT_SALARY) / #this.dsn_alias#.IS_ZERO(TOTAL_DAYS,1) * 30),2) > CASE WHEN (EMPLOYEES_IDENTY.BIRTH_DATE IS NOT NULL AND DATEDIFF(year,EMPLOYEES_IDENTY.BIRTH_DATE,#CREATEODBCDATETIME(now())#) < 16) THEN (SELECT MIN_GROSS_PAYMENT_16 FROM INSURANCE_PAYMENT WHERE STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_start_#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_start_#">) ELSE (SELECT MIN_PAYMENT FROM INSURANCE_PAYMENT WHERE STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_start_#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_start_#">) END
                        </cfif>
                        ) 			
                </cfif>
            ) AS DB
            GROUP BY
            	<cfloop list="#total_coloums#" index="ccm">
                    #ccm#,
                </cfloop>
                <cfloop list="#add_coloums#" index="ccc">
                    #ccc#,
                </cfloop>
                <cfloop list="#employees_info#" index="ccd">
                    #ccd#,
                </cfloop>
                VERGI_ISTISNA_AMOUNT_,
                VERGI_ISTISNA_AMOUNT,
                COLLAR_TYPE,
                ROW_SAL_MON,
                ROW_SAL_YEAR,
                EMPLOYEE_PUANTAJ_ID,
                HIERARCHY,
                OZEL_KOD,
                OZEL_KOD2,
                DYNAMIC_HIERARCHY,
                DYNAMIC_HIERARCHY_ADD,
                EMPLOYEE_NAME,
                EMPLOYEE_SURNAME,
                EMPLOYEE_NO,
                GROUP_STARTDATE,
                KIDEM_DATE,
                TC_IDENTY_NO,
                DTrh,
                USE_SSK,
                USE_PDKS,
                SALARY_TYPE,
                PUANTAJ_GROUP_IDS,
                KISMI_ISTIHDAM_GUN,
                KISMI_ISTIHDAM_SAAT,
                FINISH_DATE,
                START_DATE,
                SSK_STATUTE,
                IN_OUT_ID,
                SABIT_PRIM,
                PAYMETHOD_ID,
                GROSS_NET,
                KISI_5084,
                KISI_5510,
                EXPLANATION_ID,
				CUMULATIVE_TAX_TOTAL,
				START_CUMULATIVE_TAX,
                DUTY_TYPE,
                EX_IN,
                IS_5510,
                RELATED_COMPANY,
                BRANCH_ID,
                BRANCH_NAME,
                DEPARTMENT_ID,
                DEPARTMENT_HEAD,
                HIERARCHY_DEP_ID,
                LEVEL_NO,
                <cfif isdefined("arguments.sort_type") and len(arguments.sort_type) and (arguments.sort_type eq 1 or arguments.sort_type eq 2 or arguments.sort_type eq 3 or arguments.sort_type eq 4 or arguments.sort_type eq 5 or arguments.sort_type eq 6)>
                TYPE,
                </cfif>
                MAAS,
                <cfloop from="1" to="12" index="ind">M#ind#,</cfloop>
                ACCOUNT_BILL_TYPE,
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
                EXT_TOTAL_HOURS_8_AMOUNT,
                EXT_TOTAL_HOURS_9_AMOUNT,
                EXT_TOTAL_HOURS_10_AMOUNT,
                EXT_TOTAL_HOURS_11_AMOUNT,
                EXT_TOTAL_HOURS_12_AMOUNT,
                TOTAL_AMOUNT,
                BUSINESS_CODE,
                BUSINESS_CODE_NAME,
                REASON,
                BANK_BRANCH_CODE,
                BANK_ACCOUNT_NO,
                IBAN_NO,
                BANK_NAME,
                GRADE,
                STEP,
                ORGANIZATION_STEP_NAME,
                SEX
                <cfif listlen(odenek_names)>
	                <cfloop from="1" to="#listlen(odenek_names,',')#" index="k">
	        			,CALC_DAYS_#k#
	        			,FROM_SALARY_#k#
	        		</cfloop>
        		</cfif>
        		<cfif arguments.department_level eq '1' and listlen(dep_level_list)>
	        		<cfloop from="1" to="#listlen(dep_level_list,',')#" index="m">
	        			,DEPARTMAN#m#
	        		</cfloop>
        		</cfif>
            ORDER BY
                <cfif isdefined("arguments.sort_type") and arguments.sort_type eq 1>
                    BRANCH_NAME,
                    BRANCH_ID,
                    DEPARTMENT_HEAD,
                    DEPARTMENT_ID,
                <cfelseif isdefined("arguments.sort_type") and arguments.sort_type eq 2>
                    EXPENSE_CODE,
                <cfelseif isdefined("arguments.sort_type") and arguments.sort_type eq 3>
                    UPPER_POSITION_CODE,
                <cfelseif isdefined("arguments.sort_type") and arguments.sort_type eq 4>
                    UPPER_POSITION_CODE2,
                <cfelseif isdefined("arguments.sort_type") and arguments.sort_type eq 5>
                <cfelseif isdefined("arguments.sort_type") and arguments.sort_type eq 6>
                    ROW_SAL_YEAR ASC,
                    ROW_SAL_MON ASC,
                </cfif>
                EMPLOYEE_NAME,
                EMPLOYEE_SURNAME,
                <cfif not isdefined("arguments.sort_type") or arguments.sort_type neq 6>
                    ROW_SAL_YEAR ASC,
                    ROW_SAL_MON ASC,
                </cfif>
                IN_OUT_ID DESC
        </cfquery>
        <!--- Toplam Göster Esma R. Uysal 28/07/2020--->
        <cfif isdefined("arguments.list_type") and arguments.list_type eq 2>
            <cfquery name="get_total_rows_"  dbtype="query">
                SELECT
                    DISTINCT
                    <cfloop list="#total_coloums#" index="ccm">
                        SUM(#ccm#) #ccm#,
                    </cfloop>
                    <cfloop list="#add_coloums#" index="ccc">
                        #ccc#, 
                    </cfloop>
                    <cfloop list="#employees_info#" index="cei">
                        #cei#, 
                    </cfloop>
                    SUM(VERGI_ISTISNA_AMOUNT_) AS VERGI_ISTISNA_AMOUNT_,
                    SUM(VERGI_ISTISNA_AMOUNT) AS VERGI_ISTISNA_AMOUNT,
                    COLLAR_TYPE,
                    '' AS ROW_SAL_MON,
                    '' AS ROW_SAL_YEAR,
                    '' AS EMPLOYEE_PUANTAJ_ID,
                    HIERARCHY,
                    OZEL_KOD,
                    OZEL_KOD2,
                    DYNAMIC_HIERARCHY,
                    DYNAMIC_HIERARCHY_ADD,
                    EMPLOYEE_NAME,
                    EMPLOYEE_SURNAME,
                    EMPLOYEE_NO,
                    GROUP_STARTDATE,
                    KIDEM_DATE,
                    TC_IDENTY_NO,
                    DTrh,
                    USE_SSK,
                    USE_PDKS,
                    SALARY_TYPE,
                    PUANTAJ_GROUP_IDS,
                    SUM(KISMI_ISTIHDAM_GUN) AS KISMI_ISTIHDAM_GUN,
                    SUM(KISMI_ISTIHDAM_SAAT) AS KISMI_ISTIHDAM_SAAT,
                    FINISH_DATE,
                    START_DATE,
                    SSK_STATUTE,
                    IN_OUT_ID,
                    SUM(SABIT_PRIM) AS SABIT_PRIM,
                    PAYMETHOD_ID,
                    GROSS_NET,
                    KISI_5084,
                    KISI_5510,
                    EXPLANATION_ID,
                    SUM(CUMULATIVE_TAX_TOTAL) AS CUMULATIVE_TAX_TOTAL,
                    SUM(START_CUMULATIVE_TAX) AS START_CUMULATIVE_TAX,
                    DUTY_TYPE,
                    EX_IN,
                    IS_5510,
                    RELATED_COMPANY,
                    BRANCH_ID,
                    BRANCH_NAME,
                    DEPARTMENT_ID,
                    DEPARTMENT_HEAD,
                    HIERARCHY_DEP_ID,
                    LEVEL_NO,
                    <cfif isdefined("arguments.sort_type") and len(arguments.sort_type) and (arguments.sort_type eq 1 or arguments.sort_type eq 2 or arguments.sort_type eq 3 or arguments.sort_type eq 4 or arguments.sort_type eq 5 or arguments.sort_type eq 6)>
                    TYPE,
                    </cfif>
                    <cfloop from="1" to="12" index="ind">M#ind#,</cfloop>
                    SUM(MAAS) AS MAAS,
                    ACCOUNT_BILL_TYPE,
                    SUM(WEEKLY_DAY) AS WEEKLY_DAY,
                    SUM(WEEKLY_HOUR) AS WEEKLY_HOUR,
                    SUM(WEEKEND_DAY) AS WEEKEND_DAY,
                    SUM(WEEKEND_HOUR) AS WEEKEND_HOUR,
                    SUM(WEEKLY_AMOUNT) AS WEEKLY_AMOUNT,
                    SUM(WEEKEND_AMOUNT) AS WEEKEND_AMOUNT,
                    SUM(OFFDAYS_AMOUNT) AS OFFDAYS_AMOUNT,
                    SUM(IZIN_AMOUNT) AS IZIN_AMOUNT,
                    SUM(IZIN_PAID_AMOUNT) AS IZIN_PAID_AMOUNT,
                    SUM(IZIN_SUNDAY_PAID_AMOUNT) AS IZIN_SUNDAY_PAID_AMOUNT,
                    SUM(EXT_TOTAL_HOURS_0_AMOUNT) AS EXT_TOTAL_HOURS_0_AMOUNT,
                    SUM(EXT_TOTAL_HOURS_1_AMOUNT) AS EXT_TOTAL_HOURS_1_AMOUNT,
                    SUM(EXT_TOTAL_HOURS_2_AMOUNT) AS EXT_TOTAL_HOURS_2_AMOUNT,
                    SUM(EXT_TOTAL_HOURS_5_AMOUNT) AS EXT_TOTAL_HOURS_5_AMOUNT,
                    SUM(EXT_TOTAL_HOURS_8_AMOUNT) AS EXT_TOTAL_HOURS_8_AMOUNT,
                    SUM(EXT_TOTAL_HOURS_9_AMOUNT) AS EXT_TOTAL_HOURS_9_AMOUNT,
                    SUM(EXT_TOTAL_HOURS_10_AMOUNT) AS EXT_TOTAL_HOURS_10_AMOUNT,
                    SUM(EXT_TOTAL_HOURS_11_AMOUNT) AS EXT_TOTAL_HOURS_11_AMOUNT,
                    SUM(EXT_TOTAL_HOURS_12_AMOUNT) AS EXT_TOTAL_HOURS_12_AMOUNT,
                    SUM(TOTAL_AMOUNT) AS TOTAL_AMOUNT,
                    BUSINESS_CODE,
                    BUSINESS_CODE_NAME,
                    REASON,
                    BANK_BRANCH_CODE,
                    BANK_ACCOUNT_NO,
                    IBAN_NO,
                    BANK_NAME,
                    GRADE,
                    STEP,
                    ORGANIZATION_STEP_NAME,
                    SEX,
                    SUM(AVANS) AS AVANS
                    <cfif listlen(kesinti_names)>
                        <cfloop from="1" to="#listlen(kesinti_names,',')#" index="j">
                            ,SUM(KESINTI_#j#) AS KESINTI_#j#
                        </cfloop>
                    </cfif>
                    <cfif listlen(odenek_names)>
                        <cfloop from="1" to="#listlen(odenek_names,',')#" index="k">
                            ,SUM(ODENEK_#k#) AS ODENEK_#k#
                            ,SUM(ODENEK_NET_#k#) AS ODENEK_NET_#k#
                            ,CALC_DAYS_#k#
                            ,FROM_SALARY_#k#
                        </cfloop>
                    </cfif>
                    <cfif listlen(vergi_istisna_names)>
                        <cfloop from="1" to="#listlen(vergi_istisna_names,',')#" index="x">
                            ,SUM(VERGI_ISTISNA_#x#) AS VERGI_ISTISNA_#x#
                            ,SUM(VERGI_ISTISNA_TOTAL_#x#) AS VERGI_ISTISNA_TOTAL_#x#
                        </cfloop>
                    </cfif>
                    <cfif arguments.department_level eq '1' and listlen(dep_level_list)>
                        <cfloop from="1" to="#listlen(dep_level_list,',')#" index="m">
                            ,DEPARTMAN#m#
                        </cfloop>
                    </cfif>
                FROM   
                    get_puantaj_rows
                GROUP BY
                    <cfloop list="#add_coloums#" index="ccc">
                        #ccc#, 
                    </cfloop>
                    <cfloop list="#employees_info#" index="cei">
                        #cei#, 
                    </cfloop>
                    COLLAR_TYPE,
                    HIERARCHY,
                    OZEL_KOD,
                    OZEL_KOD2,
                    DYNAMIC_HIERARCHY,
                    DYNAMIC_HIERARCHY_ADD,
                    EMPLOYEE_NAME,
                    EMPLOYEE_SURNAME,
                    EMPLOYEE_NO,
                    GROUP_STARTDATE,
                    KIDEM_DATE,
                    TC_IDENTY_NO,
                    DTrh,
                    USE_SSK,
                    USE_PDKS,
                    SALARY_TYPE,
                    PUANTAJ_GROUP_IDS,
                    FINISH_DATE,
                    START_DATE,
                    SSK_STATUTE,
                    IN_OUT_ID,
                    PAYMETHOD_ID,
                    GROSS_NET,
                    KISI_5084,
                    KISI_5510,
                    EXPLANATION_ID,
                    DUTY_TYPE,
                    EX_IN,
                    IS_5510,
                    RELATED_COMPANY,
                    BRANCH_ID,
                    BRANCH_NAME,
                    DEPARTMENT_ID,
                    DEPARTMENT_HEAD,
                    HIERARCHY_DEP_ID,
                    LEVEL_NO,
                    <cfif isdefined("arguments.sort_type") and len(arguments.sort_type) and (arguments.sort_type eq 1 or arguments.sort_type eq 2 or arguments.sort_type eq 3 or arguments.sort_type eq 4 or arguments.sort_type eq 5 or arguments.sort_type eq 6)>
                    TYPE,
                    </cfif>
                    <cfloop from="1" to="12" index="ind">M#ind#,</cfloop>
                    ACCOUNT_BILL_TYPE,
                    BUSINESS_CODE,
                    BUSINESS_CODE_NAME,
                    REASON,
                    BANK_BRANCH_CODE,
                    BANK_ACCOUNT_NO,
                    IBAN_NO,
                    BANK_NAME,
                    GRADE,
                    STEP,
                    ORGANIZATION_STEP_NAME,
                    SEX
                    <cfif listlen(odenek_names)>
                        <cfloop from="1" to="#listlen(odenek_names,',')#" index="k">
                            ,CALC_DAYS_#k#
                            ,FROM_SALARY_#k#
                        </cfloop>
                    </cfif>
                    <cfif arguments.department_level eq '1' and listlen(dep_level_list)>
                        <cfloop from="1" to="#listlen(dep_level_list,',')#" index="m">
                            ,DEPARTMAN#m#
                        </cfloop>
                    </cfif>
                    ORDER BY
                        <cfif isdefined("arguments.sort_type") and arguments.sort_type eq 1>
                            BRANCH_NAME,
                            BRANCH_ID,
                            DEPARTMENT_HEAD,
                            DEPARTMENT_ID,
                        <cfelseif isdefined("arguments.sort_type") and arguments.sort_type eq 2>
                            EXPENSE_CODE,
                        <cfelseif isdefined("arguments.sort_type") and arguments.sort_type eq 3>
                            UPPER_POSITION_CODE,
                        <cfelseif isdefined("arguments.sort_type") and arguments.sort_type eq 4>
                            UPPER_POSITION_CODE2,
                        <cfelseif isdefined("arguments.sort_type") and arguments.sort_type eq 5>
                        <cfelseif isdefined("arguments.sort_type") and arguments.sort_type eq 6>
                            ROW_SAL_YEAR ASC,
                            ROW_SAL_MON ASC,
                        </cfif>
                        EMPLOYEE_NAME,
                        EMPLOYEE_SURNAME,
                        <cfif not isdefined("arguments.sort_type") or arguments.sort_type neq 6>
                            ROW_SAL_YEAR ASC,
                            ROW_SAL_MON ASC,
                        </cfif>
                        IN_OUT_ID DESC
            </cfquery>
            <cfloop query = "get_total_rows_">
                <cfoutput query = "get_puantaj_rows" >
                    <cfif get_total_rows_.TC_IDENTY_NO eq  get_puantaj_rows.TC_IDENTY_NO>
                        <cfset get_total_rows_.ROW_SAL_MON = ListAppend(get_total_rows_.ROW_SAL_MON,get_puantaj_rows.ROW_SAL_MON[currentRow],',')>
                        <cfset get_total_rows_.EMPLOYEE_PUANTAJ_ID = ListAppend(get_total_rows_.EMPLOYEE_PUANTAJ_ID,get_puantaj_rows.EMPLOYEE_PUANTAJ_ID[currentRow],',')>
                        <cfset get_total_rows_.ROW_SAL_YEAR = ListAppend(get_total_rows_.ROW_SAL_YEAR,get_puantaj_rows.ROW_SAL_YEAR[currentRow],',')>
                    </cfif>
                </cfoutput>
            </cfloop>
            <cfreturn get_total_rows_>
        <cfelse><!--- Dağılım Göster ---->
            <cfreturn get_puantaj_rows>
        </cfif>
  </cffunction>
</cfcomponent>
