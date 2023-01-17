<cfquery name="get_hr_ssk" datasource="#dsn#">
	SELECT
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES_IN_OUT.GROSS_NET,
		EMPLOYEES_IN_OUT.START_DATE,
		EMPLOYEES_IN_OUT.FINISH_DATE,
		EMPLOYEES_IN_OUT.USE_SSK,
		EMPLOYEES_IN_OUT.USE_TAX,
		EMPLOYEES_IN_OUT.IS_TAX_FREE,
		EMPLOYEES_IN_OUT.SSK_STATUTE,
		EMPLOYEES_IN_OUT.IS_DISCOUNT_OFF,
		EMPLOYEES_IN_OUT.IS_USE_506,
		EMPLOYEES_IN_OUT.DAYS_506,
		EMPLOYEES_IN_OUT.DEFECTION_LEVEL,
		EMPLOYEES_IN_OUT.SOCIALSECURITY_NO,
		EMPLOYEES_IN_OUT.TRADE_UNION_DEDUCTION,
		EMPLOYEES_IN_OUT.FAZLA_MESAI_SAAT,
		EMPLOYEES_IN_OUT.LAW_NUMBERS,
		EMPLOYEES_IN_OUT.KULLANILMAYAN_IZIN_AMOUNT,
		EMPLOYEES_IN_OUT.GROSS_COUNT_TYPE,
		EMPLOYEES_IN_OUT.FINISH_DATE,
		EMPLOYEES_IN_OUT.VALID,
		EMPLOYEES_IN_OUT.IS_5084,
		EMPLOYEES_IN_OUT.IS_5510,
		EMPLOYEES_PUANTAJ_ROWS.*,
		EMPLOYEES_PUANTAJ.*,
		BRANCH.BRANCH_ID,
		BRANCH.DANGER_DEGREE,
		BRANCH.DANGER_DEGREE_NO,
		BRANCH.KANUN_5084_ORAN,
		BRANCH.IS_5615,
		BRANCH.IS_5615_TAX_OFF,
		BRANCH.IS_5510 AS SUBE_IS_5510,
		BRANCH.BRANCH_FULLNAME,
		BRANCH.BRANCH_NAME,
		BRANCH.SSK_OFFICE,
		BRANCH.SSK_NO,
		EMPLOYEES_IN_OUT.IS_6486,
		BRANCH.KANUN_6486,
		EMPLOYEES_IN_OUT.GRADE,
		EMPLOYEES_IN_OUT.STEP,
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
        AUDIT_COMPENSATION
	FROM
		EMPLOYEES_IN_OUT,
		EMPLOYEES_PUANTAJ_ROWS,
		EMPLOYEES_PUANTAJ,
		EMPLOYEES,
		BRANCH
	WHERE
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID AND
		EMPLOYEES_PUANTAJ_ROWS.IN_OUT_ID = EMPLOYEES_IN_OUT.IN_OUT_ID AND
	<cfif isdefined("attributes.EMPLOYEE_PUANTAJ_ID")>
		EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID = #attributes.EMPLOYEE_PUANTAJ_ID# AND
	<cfelseif isdefined("attributes.EMPLOYEE_ID")>
		EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND
		EMPLOYEES_PUANTAJ.SAL_YEAR = #attributes.SAL_YEAR# AND
		EMPLOYEES_PUANTAJ.SAL_MON = #attributes.SAL_MON# AND
	</cfif>
		EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID AND
		EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
		BRANCH.SSK_OFFICE = EMPLOYEES_PUANTAJ.SSK_OFFICE AND
		BRANCH.SSK_NO = EMPLOYEES_PUANTAJ.SSK_OFFICE_NO
	<cfif not session.ep.ehesap>
		AND
		BRANCH.BRANCH_ID IN (
							SELECT
								BRANCH_ID
							FROM
								EMPLOYEE_POSITION_BRANCHES
							WHERE
								POSITION_CODE = #session.ep.position_code#
							)
	</cfif>
</cfquery>
<cfif not get_hr_ssk.recordcount>
	<script type="text/javascript">
		alert("Puantaj <cfif not session.ep.ehesap>veya Yetkiniz </cfif> Yok !");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfquery name="get_hr_ssk_rows_ext" datasource="#dsn#">
	SELECT
		*
	FROM
		EMPLOYEES_PUANTAJ_ROWS_EXT
	WHERE
		EMPLOYEE_PUANTAJ_ID = #attributes.EMPLOYEE_PUANTAJ_ID#
</cfquery>

<cfset ek_odenek_array = arrayNew(2)>
<cfset ek_odenek_array_index = 0>
<cfset ozel_kesinti_2 = 0>

<cfloop query="get_hr_ssk_rows_ext">
	<cfscript>
	ek_odenek_array_index = ek_odenek_array_index + 1;
	ek_odenek_array[ek_odenek_array_index][1] = COMMENT_PAY;
	ek_odenek_array[ek_odenek_array_index][2] = PAY_METHOD;
	ek_odenek_array[ek_odenek_array_index][3] = AMOUNT;
	ek_odenek_array[ek_odenek_array_index][4] = SSK;
	ek_odenek_array[ek_odenek_array_index][5] = TAX;
	ek_odenek_array[ek_odenek_array_index][6] = EXT_TYPE;
	ek_odenek_array[ek_odenek_array_index][7] = CALC_DAYS;
	ek_odenek_array[ek_odenek_array_index][8] = AMOUNT_2;
	ek_odenek_array[ek_odenek_array_index][9] = FROM_SALARY;
	if(len(IS_KIDEM))
		ek_odenek_array[ek_odenek_array_index][10] = IS_KIDEM;
	else
		ek_odenek_array[ek_odenek_array_index][10] = '';
	if(len(YUZDE_SINIR))
		ek_odenek_array[ek_odenek_array_index][11] = YUZDE_SINIR;
	else
		ek_odenek_array[ek_odenek_array_index][11] = '';
	if ( (EXT_TYPE eq 1) and (FROM_SALARY eq 1) ) // brütden ek kesinti
		{
		if (PAY_METHOD eq 1) // 1
			ozel_kesinti_2 = ozel_kesinti_2 + AMOUNT_2;
		else if (PAY_METHOD eq 2) // %
			ozel_kesinti_2 = ozel_kesinti_2 + ( (get_hr_ssk.TOTAL_SALARY * AMOUNT_2) / 100 );
		}
	</cfscript>
</cfloop>

