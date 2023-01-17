<cfquery name="get_setup_salary" datasource="#dsn#">
	SELECT * FROM SALARY_UPDATE WHERE UPDATE_ID = #attributes.UPDATE_ID#
</cfquery>
<cfquery name="get_setup_salary_years" datasource="#dsn#">
	SELECT * FROM SALARY_UPDATE_YEARS WHERE	UPDATE_ID = #attributes.UPDATE_ID#
</cfquery>
<cfquery name="get_setup_salary_companies" datasource="#dsn#">
	SELECT SUC.*,OC.NICK_NAME,OC.COMPANY_NAME,OC.COMP_ID FROM SALARY_UPDATE_COMPANIES SUC,OUR_COMPANY OC WHERE	SUC.UPDATE_ID = #attributes.UPDATE_ID# AND OC.COMP_ID = SUC.OUR_COMPANY_ID
</cfquery>
<cfquery name="get_setup_salary_position_cats" datasource="#dsn#">
	SELECT SUPC.*,SPC.POSITION_CAT FROM SALARY_UPDATE_POSITION_CATS SUPC,SETUP_POSITION_CAT SPC WHERE SUPC.UPDATE_ID = #attributes.UPDATE_ID# AND SPC.POSITION_CAT_ID = SUPC.POSITION_CAT_ID
</cfquery>

<cfset COMPANY_LIST = VALUELIST(get_setup_salary_companies.NICK_NAME,",")>
<cfset COMPANY_ID_LIST = VALUELIST(get_setup_salary_companies.COMP_ID,",")>
<cfset POSITION_CAT_LIST = VALUELIST(get_setup_salary_position_cats.POSITION_CAT,",")>
<cfset POSITION_CAT_ID_LIST = VALUELIST(get_setup_salary_position_cats.POSITION_CAT_ID,",")>
<cfset year_list = get_setup_salary_years.sal_year>

<cfif GET_SETUP_SALARY.METHOD_TYPE eq 0>
	<cfset aktif_date_onceki = date_add("m",-1,now())>
	<cfset attributes.month_ = dateformat(aktif_date_onceki,'m')>
	<cfset attributes.year_ = dateformat(aktif_date_onceki,'yyyy')>
	<cfset attributes.month_ = 'M#attributes.month_#'>
<cfelse>
	<cfset attributes.month_ = 'M#dateformat(now(),'m')#'>
	<cfset attributes.year_ = '#dateformat(now(),'yyyy')#'>
</cfif>
<cfif GET_SETUP_SALARY.salary_type eq 0>
	<cfset tablo_ = "EMPLOYEES_SALARY_PLAN">
<cfelse>
	<cfset tablo_ = "EMPLOYEES_SALARY">
</cfif>
<cfquery name="get_employees" datasource="#dsn#">
	SELECT
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		(SELECT EP.POSITION_NAME FROM EMPLOYEE_POSITIONS EP WHERE EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND EP.IS_MASTER = 1) AS POSITION_NAME,
		B.BRANCH_NAME,
		OC.NICK_NAME,
		ES.#attributes.month_# AS SU_AN,
		ES.*
	FROM
		EMPLOYEES E,
		BRANCH B,
		OUR_COMPANY OC,
		EMPLOYEES_IN_OUT EIO,
		#tablo_# ES
	WHERE
		<cfif listlen(POSITION_CAT_ID_LIST)>
			E.EMPLOYEE_ID IN (SELECT EP2.EMPLOYEE_ID FROM EMPLOYEE_POSITIONS EP2 WHERE POSITION_CAT_ID IN (#POSITION_CAT_ID_LIST#)) AND
		</cfif>
		EIO.EMPLOYEE_ID = E.EMPLOYEE_ID
		AND ES.IN_OUT_ID = EIO.IN_OUT_ID
		AND B.BRANCH_ID = EIO.BRANCH_ID
		AND OC.COMP_ID = B.COMPANY_ID
		AND OC.COMP_ID IN (#COMPANY_ID_LIST#)
	<cfif len(GET_SETUP_SALARY.work_start_date)>
		AND EIO.START_DATE < #createodbcdatetime(GET_SETUP_SALARY.work_start_date)#
	</cfif>
	<cfif len(GET_SETUP_SALARY.work_finish_date)>
		AND EIO.START_DATE > #createodbcdatetime(GET_SETUP_SALARY.work_finish_date)#
	</cfif>
		AND ES.PERIOD_YEAR = #attributes.year_#
	<cfif GET_SETUP_SALARY.change_all eq 1>
		AND EIO.EFFECTED_CORPORATE_CHANGE = 1
	</cfif>	
	<cfif GET_SETUP_SALARY.CONTROL_FINISHDATE eq 1>
		AND EIO.FINISH_DATE IS NULL
	</cfif>	
</cfquery>
<cfoutput query="get_employees">
<cfif len(su_an) and isnumeric(su_an)>
	<cfif GET_SETUP_SALARY.salary_type eq 1>
		<cfquery name="add_history" datasource="#dsn#">
			INSERT INTO
				EMPLOYEES_SALARY_HISTORY
				(
				IN_OUT_ID,
				EMPLOYEE_ID,
				PERIOD_YEAR,
				MONEY,
				M1,
				M2,
				M3,
				M4,
				M5,
				M6,
				M7,
				M8,
				M9,
				M10,
				M11,
				M12,
				SALARY_UPDATE_ID,
				SALARY_CODE,
				RECORD_DATE,
				RECORD_IP,
				RECORD_EMP
				)
			VALUES
				(
				#IN_OUT_ID#,
				#EMPLOYEE_ID#,
				#PERIOD_YEAR#,
				'#MONEY#',
				#M1#,
				#M2#,
				#M3#,
				#M4#,
				#M5#,
				#M6#,
				#M7#,
				#M8#,
				#M9#,
				#M10#,
				#M11#,
				#M12#,
				#attributes.update_id#,
				'#SALARY_CODE#',
				#NOW()#,
				'#CGI.REMOTE_ADDR#',
				#SESSION.EP.USERID#
				)
		</cfquery>
	</cfif>
	<cfloop list="#year_list#" index="mmm">
		<cfset year_ = mmm>
		<cfset in_out_id_ = in_out_id>
		<cfset employee_id_ = employee_id>
		<cfset salary_code_ = get_setup_salary.salary_code>
		<cfset money_ = money>
		<cfset degisim = (SU_AN * (abs(GET_SETUP_SALARY.update_percent-100))) / 100>
		<cfif sgn(GET_SETUP_SALARY.update_percent) eq 1>
			<cfset maas_yeni_ = SU_AN + degisim>
		</cfif>
		<cfif sgn(GET_SETUP_SALARY.update_percent) eq -1>
			<cfset maas_yeni_ = SU_AN - degisim>
		</cfif>
		<cfquery name="cont_" datasource="#dsn#">
			SELECT M1 FROM #tablo_# WHERE IN_OUT_ID = #in_out_id_# AND EMPLOYEE_ID = #employee_id_# AND PERIOD_YEAR = #year_#
		</cfquery>
		<cfif cont_.recordcount eq 1>
			<cfquery name="upd_" datasource="#dsn#">
				UPDATE
					#tablo_#
				SET
					<cfloop from="#get_setup_salary.SAL_MON#" to="12" index="aylarim">
						M#aylarim# = #maas_yeni_#,
					</cfloop>
					SALARY_CODE = '#salary_code_#',
					MONEY = '#MONEY#',
					UPDATE_EMP = #session.ep.userid#,
					UPDATE_DATE = #now()#,
					UPDATE_IP = '#cgi.REMOTE_ADDR#'
				WHERE
					IN_OUT_ID = #in_out_id_# AND 
					EMPLOYEE_ID = #employee_id_# AND 
					PERIOD_YEAR = #year_#
			</cfquery>
		<cfelse>
			<cfquery name="upd_" datasource="#dsn#">
				INSERT INTO
					#tablo_#
					(
					<cfloop from="#get_setup_salary.SAL_MON#" to="12" index="aylarim">
						M#aylarim#,
					</cfloop>
					SALARY_CODE,
					MONEY,
					EMPLOYEE_ID,
					IN_OUT_ID,
					PERIOD_YEAR,
					RECORD_EMP,
					RECORD_DATE,
					RECORD_IP
					)
				VALUES
					(
					<cfloop from="#get_setup_salary.SAL_MON#" to="12" index="aylarim">
						#maas_yeni_#,
					</cfloop>
					'#salary_code_#',
					'#MONEY#',
					#employee_id_#,
					#in_out_id_#,
					#year_#,
					#session.ep.userid#,
					#now()#,
					'#cgi.REMOTE_ADDR#'
					)
			</cfquery>
		</cfif>
	</cfloop>
</cfif>
</cfoutput>

