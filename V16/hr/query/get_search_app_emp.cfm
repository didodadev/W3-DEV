<!---burdaki büyük queryle aynı query seçim listesi ekedede dönüyor yapıan değişiklik orayada konsun tek fark öteki sayfa aynıalrını eklemiyor--->
<cfif isdefined("attributes.salary_wanted_money") and len(attributes.salary_wanted_money)>
	<cfquery name="GET_RATE" datasource="#dsn#">
		SELECT
			RATE1,
			RATE2,
			MONEY
		FROM
			SETUP_MONEY
		WHERE
			MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(attributes.salary_wanted_money)#"> AND 
			PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
	</cfquery>
	<cfset RATE_MAIN =GET_RATE.RATE2/GET_RATE.RATE1>
</cfif>
<!--- Ek Bilgiler --->
<cfquery name="get_infoplus" datasource="#dsn#">
	SELECT 
		<cfloop from="1" to="10" index="m">
		PROPERTY#m#_NAME,
		PROPERTY#m#_TYPE,
		</cfloop>
		INFO_ID
	FROM 
		SETUP_INFOPLUS_NAMES 
	WHERE 
		OWNER_TYPE_ID = -23
</cfquery>
<cfset is_ek_bilgi_ara = 0>
<cfif get_infoplus.recordcount>
	<cfloop from="1" to="20" index="x">
		<cfif isdefined('attributes.property_select_value_#x#') and len(evaluate('attributes.property_select_value_#x#'))>
			<cfset is_ek_bilgi_ara = 1>
		</cfif>
	</cfloop>
</cfif>
<!---// Ek Bilgiler --->
<cfif isdefined("attributes.salary_wanted1") and len(attributes.salary_wanted1) and isdefined("RATE_MAIN")>
	<cfset money_min =attributes.salary_wanted1*RATE_MAIN>
</cfif>

<cfif isdefined("attributes.salary_wanted2") and len(attributes.salary_wanted2) and isdefined("RATE_MAIN")>
	<cfset money_max =attributes.salary_wanted2*RATE_MAIN>
</cfif>
 
<cfif isdefined("attributes.birth_date2") and len(attributes.birth_date2)>
	<cfset attributes.date_dogum="01/01/#evaluate(session.ep.period_year-attributes.birth_date2)#">
	<cf_date tarih='attributes.date_dogum'>
</cfif>

<cfif isdefined("attributes.birth_date1") and len(attributes.birth_date1)>
	<cfset attributes.date_dogum_1="01/01/#evaluate(session.ep.period_year-attributes.birth_date1)#">
	<cf_date tarih='attributes.date_dogum_1'>
</cfif>

<cfif isdefined("attributes.app_date1") and len(attributes.app_date1)>
	<cf_date tarih='attributes.app_date1'>
</cfif>

<cfif isdefined("attributes.app_date2") and len(attributes.app_date2)>
	<cf_date tarih='attributes.app_date2'>
</cfif>

<cfif (isdefined("attributes.exp_year_s1") and len(attributes.exp_year_s1)) or (isdefined("attributes.exp_year_s2") and len(attributes.exp_year_s2))>
	<cfquery name="get_work_info" datasource="#dsn#">
		SELECT 
			EMPAPP_ID,
			Sum(EXP_FARK)/365 
		FROM 
			EMPLOYEES_APP_WORK_INFO 
		GROUP BY 
			EMPAPP_ID 
		HAVING 
			<cfif isdefined("attributes.exp_year_s1") and len(attributes.exp_year_s1)>Sum(EXP_FARK)/365 >= #exp_year_s1#<cfif  isdefined("attributes.exp_year_s2") and len(attributes.exp_year_s2)>AND</cfif></cfif>
			<cfif isdefined("attributes.exp_year_s2") and len(attributes.exp_year_s2)>Sum(EXP_FARK)/365 <= #exp_year_s2#</cfif>
	</cfquery>
	<cfif get_work_info.recordcount>
		<cfset exp_app_list = listsort(listdeleteduplicates(valuelist(get_work_info.empapp_id,',')),'numeric','ASC',',')>
	<cfelse>
		<cfset  exp_app_list = 0>
	</cfif>
</cfif>

<cfif ((isdefined("attributes.edu3") and len(attributes.edu3)) or (isdefined("attributes.edu3_part") and len(attributes.edu3_part))) or ((isdefined("attributes.edu4") and len(attributes.edu4)) or (isdefined("attributes.edu4_id") and len(attributes.edu4_id))) or ((isdefined("attributes.edu4_part") and len(attributes.edu4_part)) or (isdefined("attributes.edu4_part_id") and len(attributes.edu4_part_id))) or (isdefined("attributes.edu_finish") and len(attributes.edu_finish))>
	<cfquery name="get_edu_info" datasource="#dsn#">
		SELECT
			EMPAPP_ID
		FROM
			EMPLOYEES_APP_EDU_INFO
		WHERE
			EMPAPP_ID IS NOT NULL	
		<cfif (isdefined("attributes.edu3") and len(attributes.edu3)) or (isdefined("attributes.edu3_part") and len(attributes.edu3_part))>	
			AND
			(EDU_TYPE = 3
			<cfif isdefined("attributes.edu3") and len(attributes.edu3)>
				AND EDU_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.edu3#%"> 
			</cfif>
			<cfif isdefined("attributes.edu3_part") and len(attributes.edu3_part)>
				AND EDU_PART_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.edu3_part#">)
			</cfif>
			)
		</cfif>
		<cfif ((isdefined("attributes.edu3") and len(attributes.edu3)) or (isdefined("attributes.edu3_part") and len(attributes.edu3_part))) and ((isdefined("attributes.edu4") and len(attributes.edu4)) or (isdefined("attributes.edu4_id") and len(attributes.edu4_id)) or (isdefined("attributes.edu4_part") and len(attributes.edu4_part)) or (isdefined("attributes.edu4_part_id") and len(attributes.edu4_part_id)))>
			OR
		</cfif>
		<cfif (not((isdefined("attributes.edu3") and len(attributes.edu3)) or (isdefined("attributes.edu3_part") and len(attributes.edu3_part)))) and ((isdefined("attributes.edu4") and len(attributes.edu4)) or (isdefined("attributes.edu4_id") and len(attributes.edu4_id)) or (isdefined("attributes.edu4_part") and len(attributes.edu4_part)) or (isdefined("attributes.edu4_part_id") and len(attributes.edu4_part_id)))>
			AND
		</cfif>
		<cfif ((isdefined("attributes.edu4") and len(attributes.edu4)) or (isdefined("attributes.edu4_id") and len(attributes.edu4_id))) or ((isdefined("attributes.edu4_part") and len(attributes.edu4_part)) or (isdefined("attributes.edu4_part_id") and len(attributes.edu4_part_id)))>
		(EDU_TYPE = 4
			<cfif (isdefined("attributes.edu4") and len(attributes.edu4)) or (isdefined("attributes.edu4_id") and len(attributes.edu4_id))>
				AND
				(	
					<cfif isdefined("attributes.edu4") and len(attributes.edu4)>
						<cfset count=0>
						<cfloop list="#attributes.edu4#" delimiters="," index="i">
						<cfset count=count+1>
						<cfif count gt 1> OR </cfif>
						 EDU_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#i#%">
						</cfloop>
					</cfif>
					<cfif isdefined("attributes.edu4_id") and len(attributes.edu4_id)>
						<cfif isdefined('count')>OR</cfif> 
							EDU_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.edu4_id#">)
						</cfif>
				)
			</cfif>
			<cfif (isdefined("attributes.edu4_part") and len(attributes.edu4_part)) or (isdefined("attributes.edu4_part_id") and len(attributes.edu4_part_id))>
				AND
				(	
				<cfif isdefined("attributes.edu4_part") and len(attributes.edu4_part)>
					<cfset count2=0>
					<cfloop list="#attributes.edu4_part#" delimiters="," index="i">
					<cfset count2=count2+1>
					<cfif count2 gt 1> OR </cfif>
					   EDU_PART_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#i#%">
					</cfloop>
				</cfif>
				<cfif isdefined("attributes.edu4_part_id") and len(attributes.edu4_part_id)>
					<cfif isdefined('count2')>OR</cfif> 
					EDU_PART_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.edu4_part_id#">)
				</cfif>
				)
			</cfif>
			)
		</cfif>
		<cfif isdefined("attributes.edu_finish") and len(attributes.edu_finish)>
			AND	EDU_FINISH = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.edu_finish#">
		</cfif>
	</cfquery>
	<cfif get_edu_info.recordcount>
		<cfset edu_app_list = listsort(listdeleteduplicates(valuelist(get_edu_info.EMPAPP_ID,',')),'numeric','ASC',',')>
	<cfelse>
		<cfset  edu_app_list = 0>
	</cfif>
</cfif>

<cfif isdefined("attributes.search_app_pos") and attributes.search_app_pos eq 1>
	<cfquery name="GET_APP_POS" datasource="#dsn#">
		SELECT
			EMPLOYEES_APP.EMPAPP_ID,
			EMPLOYEES_APP.EMPLOYEE_ID,
			EMPLOYEES_APP_POS.APP_POS_ID,
			EMPLOYEES_APP_POS.POSITION_ID,
			EMPLOYEES_APP_POS.POSITION_CAT_ID,
			EMPLOYEES_APP_POS.APP_DATE AS APP_DATE,
			EMPLOYEES_APP.NAME AS NAME,
			EMPLOYEES_APP.SURNAME,
			EMPLOYEES_APP.STEP_NO,
			EMPLOYEES_APP.CV_STAGE,
			EMPLOYEES_APP_POS.NOTICE_ID,
			EMPLOYEES_APP.APP_COLOR_STATUS,
			EMPLOYEES_APP.COMMETHOD_ID,
			EMPLOYEES_APP_POS.APP_POS_STATUS,
			<!--- EMPLOYEES_APP.VALIDATOR_POSITION_CODE, --->
			EMPLOYEES_APP.VALID_DATE,
			EMPLOYEES_APP.DRIVER_LICENCE,
			EMPLOYEES_APP.RECORD_DATE AS RECORD_DATE,
			EMPLOYEES_APP.TRAINING_LEVEL,
			EMPLOYEES_APP.HOMECOUNTY,
			EMPLOYEES_APP.HOMETELCODE,
			EMPLOYEES_APP.HOMETEL,
			EMPLOYEES_APP.MOBILCODE,
			EMPLOYEES_APP.MOBIL,
			EMPLOYEES_APP.SEX,
			EMPLOYEES_IDENTY.MARRIED,
			EMPLOYEES_IDENTY.BIRTH_DATE
		
		FROM
			EMPLOYEES_APP
			LEFT JOIN EMPLOYEES_APP_LANGUAGE EAL ON EAL.EMPAPP_ID = EMPLOYEES_APP.EMPAPP_ID,	
			EMPLOYEES_APP_POS,
			EMPLOYEES_IDENTY
		
		WHERE
			EMPLOYEES_APP.EMPAPP_ID=EMPLOYEES_APP_POS.EMPAPP_ID
			AND EMPLOYEES_IDENTY.EMPAPP_ID=EMPLOYEES_APP.EMPAPP_ID
			AND EMPLOYEES_IDENTY.EMPAPP_ID=EMPLOYEES_APP_POS.EMPAPP_ID
			<cfif isdefined('attributes.work_started') and len(attributes.work_started)>
				AND (EMPLOYEES_APP.WORK_STARTED=<cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.work_started#">)
			</cfif>
			<cfif isdefined('attributes.work_finished') and len(attributes.work_finished)>
				AND (EMPLOYEES_APP.WORK_FINISHED=<cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.work_finishted#">)
			</cfif>
			<cfif isdefined("attributes.app_name") and len(attributes.app_name)>
				AND EMPLOYEES_APP.NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.app_name#%">
			</cfif>
			<cfif isdefined("attributes.app_surname") and len(attributes.app_surname)>
				AND EMPLOYEES_APP.SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.app_surname#%">
			</cfif>
			<cfif (isdefined("attributes.salary_wanted1") and len(attributes.salary_wanted1)) or (isdefined("attributes.salary_wanted2") and len(attributes.salary_wanted2))>
				AND (EMPLOYEES_APP_POS.SALARY_WANTED*#RATE_MAIN#) BETWEEN #money_min# AND #money_max#
			<cfelseif (isdefined("attributes.salary_wanted1") and len(attributes.salary_wanted1)) and not (isdefined("attributes.salary_wanted2")and len(attributes.salary_wanted2)) >
				AND (EMPLOYEES_APP_POS.SALARY_WANTED*#RATE_MAIN#) >= #money_min# 
			<cfelseif (isdefined("attributes.salary_wanted2") and len(attributes.salary_wanted2)) and not (isDefined("attributes.salary_wanted1") and len(attributes.salary_wanted1))>
				AND (EMPLOYEES_APP_POS.SALARY_WANTED*#RATE_MAIN#) <= #money_max#
			</cfif>		
			<cfif isdefined("attributes.app_date1") and len(attributes.app_date1) and not (isdefined("attributes.app_date2") and len(attributes.app_date2))>
				AND EMPLOYEES_APP_POS.APP_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.app_date1#">
			</cfif>
			<cfif isdefined("attributes.app_date2") and len(attributes.app_date2) and not (isdefined("attributes.app_date1") and len(attributes.app_date1))>
				AND EMPLOYEES_APP_POS.APP_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.app_date2#">
			</cfif>
			<cfif (isdefined("attributes.app_date1") and len(attributes.app_date1)) and (isdefined("attributes.app_date2") and len(attributes.app_date2))>
				AND (EMPLOYEES_APP_POS.APP_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.app_date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.app_date2#">)
			</cfif>	
			<cfset city_count=0>	
			<cfif isdefined("attributes.prefered_city") and len(attributes.prefered_city)>
				AND
				(
					<cfloop list="#attributes.prefered_city#" index="i" delimiters=",">
						PREFERED_CITY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#i#,%">
						<cfset city_count=city_count+1>
						<cfif listlen(attributes.prefered_city) neq city_count>
							OR
						</cfif>
					</cfloop>
				)
			</cfif>
			<cfif isdefined("attributes.notice_id") and len(attributes.notice_id)>
				AND EMPLOYEES_APP_POS.NOTICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.notice_id#">
			</cfif>
			<cfif (isdefined("attributes.position_id") and len(attributes.position_id)) and (isdefined("attributes.app_position") and len(attributes.app_position))>
				AND EMPLOYEES_APP_POS.POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_id#">
			</cfif>
			<cfif (isdefined("attributes.position_cat_id") and len(attributes.position_cat_id)) and (isdefined("attributes.position_cat") and len(attributes.position_cat))>
				AND EMPLOYEES_APP_POS.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">
			</cfif>
			<cfif isdefined('attributes.status') and len(attributes.status)>
				AND EMPLOYEES_APP.APP_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.status#"> 
			<cfelseif isdefined('attributes.status_app_pos') and len(attributes.status_app_pos)>
				AND EMPLOYEES_APP_POS.APP_POS_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.status_app_pos#">
			</cfif>
			<cfif isdefined("attributes.cv_status_id") and len(attributes.cv_status_id)>
				AND EMPLOYEES_APP.APP_COLOR_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cv_status_id#">
			</cfif>
			<cfif isdefined("attributes.company_id") and len(attributes.company_id) and len(attributes.company)>
				AND EMPLOYEES_APP_POS.COMPANY_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
			</cfif>
			<cfif isdefined("attributes.department") and len(attributes.department) and isdefined('attributes.department_id') and len(attributes.department_id)>
				AND EMPLOYEES_APP_POS.DEPARTMENT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
			</cfif>
			<cfif isdefined("attributes.branch") and len(attributes.branch) and isdefined('attributes.branch_id') and len(attributes.branch_id)>
				AND EMPLOYEES_APP_POS.BRANCH_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
				<cfif isdefined('attributes.our_company_id') and len(attributes.our_company_id)>
					AND EMPLOYEES_APP_POS.OUR_COMPANY_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
				</cfif>	
			</cfif>
			<cfif (isdefined("attributes.sex") and listlen(attributes.sex))>
				AND EMPLOYEES_APP.SEX IN (<cfqueryparam cfsqltype="cf_sql_bit" list="true" value="#listsort(attributes.sex,'numeric')#">) 
			</cfif>
			<cfif (isdefined("attributes.married") and listlen(attributes.married))>
				AND EMPLOYEES_IDENTY.MARRIED IN (<cfqueryparam cfsqltype="cf_sql_bit" list="true" value="#listsort(attributes.married,'numeric')#">)  
			</cfif>
			<cfif (isdefined("attributes.military_status") and listlen(attributes.military_status))>
				AND EMPLOYEES_APP.MILITARY_STATUS IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#listsort(attributes.military_status,'numeric')#">) 
			</cfif>
			<cfif isdefined("attributes.birth_place") and len(attributes.birth_place)>
				AND EMPLOYEES_IDENTY.BIRTH_PLACE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.birth_place#%">
			</cfif>
			<cfif isdefined("attributes.city") and len(attributes.city)>
				AND EMPLOYEES_IDENTY.CITY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.city#%">
			</cfif>
			<cfif isdefined("attributes.in_status") and len(attributes.in_status)>
				AND EMPLOYEES_APP_POS.IS_INTERNAL = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.in_status#">
			</cfif>
			<cfif ((isdefined("attributes.edu3") and len(attributes.edu3)) or (isdefined("attributes.edu3_part") and len(attributes.edu3_part))) or ((isdefined("attributes.edu4") and len(attributes.edu4)) or (isdefined("attributes.edu4_id") and len(attributes.edu4_id))) or ((isdefined("attributes.edu4_part") and len(attributes.edu4_part)) or (isdefined("attributes.edu4_part_id") and len(attributes.edu4_part_id))) or (isdefined("attributes.edu_finish") and len(attributes.edu_finish))>
				AND EMPLOYEES_APP.EMPAPP_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#edu_app_list#">)
			</cfif>
			<cfif isdefined("attributes.lang") and len(attributes.lang)>
				<cfif attributes.lang_par eq 'OR' or listlen(attributes.lang) eq 1>
					AND EAL.LANG_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.lang#">)
				<cfelse>
					<cfloop list="#attributes.lang#" index="lng">
						AND EMPLOYEES_APP.EMPAPP_ID IN (SELECT EMPAPP_ID FROM EMPLOYEES_APP_LANGUAGE WHERE LANG_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#lng#">)
					</cfloop>
				</cfif>
			</cfif>
			<cfif isdefined("attributes.lang_level") and len(attributes.lang_level)>
				AND (EAL.LANG_SPEAK IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.lang_level#">) OR EAL.LANG_MEAN IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.lang_level#">) OR EAL.LANG_WRITE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.lang_level#">))
			</cfif>
			<cfif (isdefined("attributes.exp_year_s1") and len(attributes.exp_year_s1)) or (isdefined("attributes.exp_year_s2") and len(attributes.exp_year_s2))>
				AND EMPLOYEES_APP.EMPAPP_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#exp_app_list#">)
			</cfif>
			<cfif isdefined('attributes.cv_stage') and len(attributes.cv_stage)>
				AND EMPLOYEES_APP.CV_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cv_stage#">
			</cfif>
			<cfif isdefined("attributes.driver_licence_type") and len(attributes.driver_licence_type)>
				AND EMPLOYEES_APP.LICENCECAT_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.driver_licence_type#">
			</cfif>
			<cfif isdefined("attributes.driver_licence") and len(attributes.driver_licence)>
				AND (DRIVER_LICENCE <> '' OR LICENCECAT_ID <> '')
			</cfif>
			<cfif isdefined("attributes.sentenced") and len(attributes.sentenced)>
				AND EMPLOYEES_APP.SENTENCED = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.sentenced#">
			</cfif>
			<cfif isdefined("attributes.defected") and len(attributes.defected)>
				AND EMPLOYEES_APP.DEFECTED = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.defected#">
			</cfif>
			<cfif isdefined("attributes.defected_level") and attributes.defected_level gt 0>
				AND EMPLOYEES_APP.DEFECTED_LEVEL = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.defected_level#">
			</cfif>
			<cfif isdefined("attributes.is_trip") and len(attributes.is_trip)>
				AND IS_TRIP = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_trip#">
			</cfif>
			<cfif isdefined("attributes.referance") and len(attributes.referance)>
				AND
				(
					REF1 LIKE '%#attributes.referance#%' OR
					REF2 LIKE '%#attributes.referance#%' OR
					REF1_EMP LIKE '%#attributes.referance#%' OR
					REF2_EMP LIKE '%#attributes.referance#%'
				)
			</cfif>
			<cfif isdefined("attributes.homecity") and len(attributes.homecity)>
				AND EMPLOYEES_APP.HOMECITY IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.homecity#">)
			</cfif>
			<cfif isdefined("attributes.home_county") and len(attributes.home_county)>
				AND EMPLOYEES_APP.HOMECOUNTY IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.home_county#">)
			</cfif>
			<cfif isdefined("attributes.computer_education") and len(attributes.computer_education)>
				AND (
						<cfloop list="#attributes.computer_education#" index="comp_edu">
							EMPLOYEES_APP.EMPAPP_ID IN(SELECT EMPAPP_ID FROM EMPLOYEES_APP_TEACHER_INFO WHERE COMPUTER_EDUCATION <cfif attributes.other_if eq 1>NOT</cfif> LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#comp_edu#,%">)
							<cfif comp_edu neq listlast(attributes.computer_education,',') and listlen(attributes.computer_education,',') gte 1> OR</cfif>
						</cfloop>
					)
			</cfif> 
			<cfif isdefined('attributes.other') and len(attributes.other)>
				AND
				( 
					(EMPLOYEES_APP.EMPAPP_ID IN
					(SELECT DISTINCT EMPAPP_ID FROM EMPLOYEES_APP_WORK_INFO
					WHERE
					(EXP <cfif attributes.other_if eq 1>NOT</cfif> LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.other#%">) OR
					(EXP_POSITION <cfif attributes.other_if eq 1>NOT</cfif> LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.other#%">) OR
					(EXP_EXTRA <cfif attributes.other_if eq 1>NOT</cfif> LIKE '%#attributes.other#%')
					)
				)
				OR
				( 
					(EMPLOYEES_APP.EMPAPP_ID IN
					(SELECT DISTINCT EMPAPP_ID FROM EMPLOYEES_APP_INFO
					WHERE
					(BRANCHES_ROW_OTHER <cfif attributes.other_if eq 1>NOT</cfif> LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.other#%">))
					)
				)
				OR
				CLUB <cfif attributes.other_if eq 1>NOT</cfif> LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.other#%"> OR
				APPLICANT_NOTES <cfif attributes.other_if eq 1>NOT</cfif> LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.other#%">
				)
			</cfif>
			<cfif isdefined("attributes.is_student") and len(attributes.is_student)>
				AND EMPLOYEES_APP.EMPAPP_ID IN (SELECT EMPAPP_ID FROM EMPLOYEES_APP_EDU_INFO WHERE IS_EDU_CONTINUE = 1)
			</cfif>
			<cfif isdefined("attributes.is_cont_work") and len(attributes.is_cont_work) and attributes.is_cont_work eq 1>
				AND EMPLOYEES_APP.EMPAPP_ID IN (SELECT EMPAPP_ID FROM EMPLOYEES_APP_WORK_INFO WHERE IS_CONT_WORK = 1)
			<cfelseif  isdefined("attributes.is_cont_work") and len(attributes.is_cont_work) and attributes.is_cont_work eq 0>
				AND EMPLOYEES_APP.EMPAPP_ID IN (SELECT EMPAPP_ID FROM EMPLOYEES_APP_WORK_INFO WHERE (IS_CONT_WORK = 0 OR IS_CONT_WORK IS NULL))
			</cfif>
			<cfif isdefined("attributes.is_formation") and len(attributes.is_formation) and attributes.is_formation eq 1>
				AND EMPLOYEES_APP.EMPAPP_ID IN (SELECT EMPAPP_ID FROM EMPLOYEES_APP_TEACHER_INFO WHERE IS_FORMATION = 1)
			<cfelseif isdefined("attributes.is_formation") and len(attributes.is_formation) and attributes.is_formation eq 0>
				AND EMPLOYEES_APP.EMPAPP_ID IN (SELECT EMPAPP_ID FROM EMPLOYEES_APP_TEACHER_INFO WHERE IS_FORMATION = 0 OR IS_FORMATION IS NULL)
			</cfif>
			<cfif isdefined("attributes.branches_id") and len(attributes.branches_id)>
				AND EMPLOYEES_APP.EMPAPP_ID IN (SELECT EMPAPP_ID FROM EMPLOYEES_APP_INFO WHERE BRANCHES_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branches_id#">)
			</cfif>
			<cfif isdefined("attributes.emp_app_info") and len(attributes.emp_app_info)>
				AND EMPLOYEES_APP.EMPAPP_ID IN (SELECT EMPAPP_ID FROM EMPLOYEES_APP_INFO WHERE BRANCHES_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branches_id#"> AND BRANCHES_ROW_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.emp_app_info#">))
			</cfif>
			<cfif isdefined("attributes.formation_typee") and len(attributes.formation_typee)>
				AND (
						<cfloop list="#attributes.formation_typee#" index="form_type">
							EMPLOYEES_APP.EMPAPP_ID IN(SELECT EMPAPP_ID FROM EMPLOYEES_APP_TEACHER_INFO WHERE FORMATION_TYPE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#form_type#,%">)
							<cfif form_type neq listlast(attributes.formation_typee,',') and listlen(attributes.formation_typee,',') gte 1> OR</cfif>
						</cfloop>
					)
			</cfif> 
			<cfif isdefined("attributes.preference_branch") and len(attributes.preference_branch)>
				AND (
						<cfloop list="#attributes.preference_branch#" index="brh">
							',' + EMPLOYEES_APP.PREFERENCE_BRANCH + ',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#brh#,%">
							<cfif brh neq listlast(attributes.preference_branch,',') and listlen(attributes.preference_branch,',') gte 1> OR</cfif>
						</cfloop>
					)
			</cfif>
			<cfif isdefined("attributes.internship") and len(attributes.internship) and attributes.internship neq 0>
				AND EMPLOYEES_APP.EMPAPP_ID IN (SELECT EMPAPP_ID FROM EMPLOYEES_APP_TEACHER_INFO WHERE INTERNSHIP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.internship#">)
			</cfif>
			<cfif isdefined("attributes.unit_id") and len(attributes.unit_id) and len(attributes.unit_row)>
				AND EMPLOYEES_APP.EMPAPP_ID IN(SELECT DISTINCT EAU.EMPAPP_ID FROM EMPLOYEES_APP_UNIT EAU
												WHERE 
													EAU.UNIT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.unit_id#">) 
													AND EAU.UNIT_ROW<= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.unit_row#">
												)
			</cfif>
			<cfif isdefined('attributes.position_cat_id1') and len(attributes.position_cat_id1)>
				AND
				(
					EMPLOYEES_APP.POSITION_CAT_ID1 = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id1#"> OR
					EMPLOYEES_APP.POSITION_CAT_ID2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id1#"> OR
					EMPLOYEES_APP.POSITION_CAT_ID3 = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id1#">
				)
			</cfif>
			<cfif is_ek_bilgi_ara eq 1>
				AND EMPLOYEES_APP.EMPAPP_ID IN(
					SELECT 
						OWNER_ID 
					FROM 
						INFO_PLUS 
					WHERE 
						INFO_OWNER_TYPE = -23
						<cfloop from="1" to="20" index="y">
							<cfif isdefined('attributes.property_select_value_#y#') and len(evaluate('attributes.property_select_value_#y#'))>
							AND PROPERTY#y# LIKE '#evaluate('attributes.property_select_value_#y#')#'
							</cfif>
						</cfloop>
					)
			</cfif>
	</cfquery>
	<cfset basvuru_list=ValueList(GET_APP_POS.EMPAPP_ID,',')>
</cfif>

<cfif isdefined('attributes.search_app') and attributes.search_app eq 1>
	<cfquery name="GET_EMPAPP" datasource="#dsn#">
		SELECT DISTINCT
			EMPLOYEES_APP.EMPAPP_ID,
			EMPLOYEES_APP.EMPLOYEE_ID,
			0 AS APP_POS_ID,
			0 AS POSITION_ID,
			0 AS POSITION_CAT_ID,
			EMPLOYEES_APP.RECORD_DATE AS APP_DATE,
			EMPLOYEES_APP.NAME AS NAME,
			EMPLOYEES_APP.SURNAME,
			EMPLOYEES_APP.EMAIL,
			EMPLOYEES_APP.STEP_NO,
			0 AS NOTICE_ID,
			EMPLOYEES_APP.APP_COLOR_STATUS,
			EMPLOYEES_APP.COMMETHOD_ID,
			EMPLOYEES_APP.APP_STATUS AS APP_POS_STATUS,
			<!--- EMPLOYEES_APP.VALIDATOR_POSITION_CODE, --->
			EMPLOYEES_APP.VALID_DATE,
			EMPLOYEES_APP.DRIVER_LICENCE,
			EMPLOYEES_APP.RECORD_DATE AS RECORD_DATE,
			EMPLOYEES_APP.TRAINING_LEVEL,
			EMPLOYEES_APP.HOMECOUNTY,
			EMPLOYEES_APP.HOMETELCODE,
			EMPLOYEES_APP.HOMETEL,
			EMPLOYEES_APP.MOBILCODE,
			EMPLOYEES_APP.MOBIL,
			EMPLOYEES_APP.SEX,
			EMPLOYEES_APP.CV_STAGE,
			EMPLOYEES_IDENTY.MARRIED,
			EMPLOYEES_IDENTY.BIRTH_DATE
		FROM
			EMPLOYEES_APP
			LEFT JOIN EMPLOYEES_APP_LANGUAGE EAL ON EAL.EMPAPP_ID = EMPLOYEES_APP.EMPAPP_ID,
			EMPLOYEES_IDENTY
		WHERE
			EMPLOYEES_IDENTY.EMPAPP_ID=EMPLOYEES_APP.EMPAPP_ID
			AND EMPLOYEES_IDENTY.EMPAPP_ID IS NOT NULL
			<cfif isdefined('attributes.work_started') and len(attributes.work_started)>
				AND EMPLOYEES_APP.WORK_STARTED = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.work_started#">
			</cfif>
			<cfif isdefined('attributes.work_finished') and len(attributes.work_finished)>
				AND EMPLOYEES_APP.WORK_FINISHED = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.work_finishted#">
			</cfif>
			<cfif isdefined('attributes.status') and len(attributes.status)>
				AND EMPLOYEES_APP.APP_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.status#">
			<cfelseif isdefined("attributes.status_app") and len(attributes.status_app)>
				AND EMPLOYEES_APP.APP_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.status_app#">
			</cfif>
			<cfif isdefined('attributes.cv_stage') and len(attributes.cv_stage)>
                    AND EMPLOYEES_APP.CV_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
					</cfif>
			<cfif isdefined("attributes.cv_status_id") and len(attributes.cv_status_id)>
				AND EMPLOYEES_APP.APP_COLOR_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cv_status_id#">
			</cfif>
			<cfif isdefined("attributes.app_name") and len(attributes.app_name)>
				AND EMPLOYEES_APP.NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.app_name#%">
			</cfif>
			<cfif isdefined("attributes.app_surname") and len(attributes.app_surname)>
				AND EMPLOYEES_APP.SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.app_surname#%">
			</cfif>
			<cfif isdefined("attributes.email") and len(attributes.email)>
				AND EMPLOYEES_APP.EMAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.email#">
			</cfif>
			<cfif isdefined("attributes.birth_date1") and len(attributes.birth_date1)>
				AND EMPLOYEES_IDENTY.BIRTH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date_dogum_1#">
			</cfif>
			<cfif isdefined("attributes.birth_date2") and len(attributes.birth_date2)>
				AND EMPLOYEES_IDENTY.BIRTH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date_dogum#">
			</cfif> 
			<cfif (isdefined("attributes.sex") and listlen(attributes.sex))>
				AND EMPLOYEES_APP.SEX IN (<cfqueryparam cfsqltype="cf_sql_bit" list="true" value="#listsort(attributes.sex,'numeric')#">) 
			</cfif>
			<cfif (isdefined("attributes.MARRIED") and listlen(attributes.MARRIED))>
				AND EMPLOYEES_IDENTY.MARRIED IN (<cfqueryparam cfsqltype="cf_sql_bit" list="true" value="#listsort(attributes.married,'numeric')#">)  
			</cfif>
			<cfif (isdefined("attributes.military_status") and listlen(attributes.military_status))>
				AND EMPLOYEES_APP.MILITARY_STATUS IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#listsort(attributes.military_status,'numeric')#">) 
			</cfif>
			<cfif isdefined("attributes.birth_place") and len(attributes.birth_place)>
				AND EMPLOYEES_IDENTY.BIRTH_PLACE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.birth_place#%">
			</cfif>
			<cfif isdefined("attributes.city") and len(attributes.city)>
				AND EMPLOYEES_IDENTY.CITY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.city#%">
			</cfif>
			<cfif isdefined("attributes.app_reply_date1") and len(attributes.app_reply_date1)>
			   	AND EMPLOYEES_APP.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.app_reply_date1#"> 
			</cfif>
			<cfif isdefined("attributes.app_reply_date2") and len(attributes.app_reply_date2)>
			  	AND EMPLOYEES_APP.RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.app_reply_date2#"> 
			</cfif>
			<cfif isdefined("attributes.training_level") and len(attributes.training_level)>
				AND EMPLOYEES_APP.TRAINING_LEVEL IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.training_level#">)
			</cfif>
			 <cfif ((isdefined("attributes.edu3") and len(attributes.edu3)) or (isdefined("attributes.edu3_part") and len(attributes.edu3_part))) or ((isdefined("attributes.edu4") and len(attributes.edu4)) or (isdefined("attributes.edu4_id") and len(attributes.edu4_id))) or ((isdefined("attributes.edu4_part") and len(attributes.edu4_part)) or (isdefined("attributes.edu4_part_id") and len(attributes.edu4_part_id))) or (isdefined("attributes.edu_finish") and len(attributes.edu_finish))>
				AND EMPLOYEES_APP.EMPAPP_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#edu_app_list#">)
			</cfif> 
			<cfif isdefined("attributes.driver_licence_type") and len(attributes.driver_licence_type)>
				AND EMPLOYEES_APP.LICENCECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.driver_licence_type#">
			</cfif>
			<cfif isdefined("attributes.driver_licence") and len(attributes.driver_licence)>
				AND (DRIVER_LICENCE <> '' OR LICENCECAT_ID <> '')
			</cfif>
			<cfif isdefined("attributes.sentenced") and len(attributes.sentenced)>
				AND EMPLOYEES_APP.SENTENCED = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.sentenced#">
			</cfif>
			<cfif isdefined("attributes.defected") and len(attributes.defected)>
			   	AND EMPLOYEES_APP.DEFECTED = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.defected#">
			</cfif>
			<cfif isdefined("attributes.defected_level") and attributes.defected_level gt 0>
			   	AND EMPLOYEES_APP.DEFECTED_LEVEL = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.defected_level#">
			</cfif>
			<cfif isdefined("attributes.is_trip") and len(attributes.is_trip)>
			   	AND EMPLOYEES_APP.IS_TRIP = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_trip#">
			</cfif>
			<cfif isdefined("attributes.referance") and len(attributes.referance)>
			  	AND
				 (
				   REF1 LIKE '%#attributes.referance#%' OR
				   REF2 LIKE '%#attributes.referance#%' OR
				   REF1_EMP LIKE '%#attributes.referance#%' OR
				   REF2_EMP LIKE '%#attributes.referance#%'
				 )
			</cfif>
			<cfif isdefined("attributes.homecity") and len(attributes.homecity)>
				AND EMPLOYEES_APP.HOMECITY IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.homecity#">)
			</cfif>
			<cfif isdefined("attributes.home_county") and len(attributes.home_county)>
				AND	EMPLOYEES_APP.HOMECOUNTY IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.home_county#">)
			</cfif>
			<cfif isdefined("attributes.computer_education") and len(attributes.computer_education)>
				AND (
					<cfloop list="#attributes.computer_education#" index="comp_edu">
						EMPLOYEES_APP.EMPAPP_ID IN(SELECT EMPAPP_ID FROM EMPLOYEES_APP_TEACHER_INFO WHERE COMPUTER_EDUCATION <cfif attributes.other_if eq 1>NOT</cfif> LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#comp_edu#,%">)
						<cfif comp_edu neq listlast(attributes.computer_education,',') and listlen(attributes.computer_education,',') gte 1> OR</cfif>
					</cfloop>
					)
			</cfif>
			<cfif isdefined("attributes.is_student") and len(attributes.is_student)>
				AND EMPLOYEES_APP.EMPAPP_ID IN (SELECT EMPAPP_ID FROM EMPLOYEES_APP_EDU_INFO WHERE IS_EDU_CONTINUE = 1)
			</cfif>
			<cfif isdefined("attributes.is_cont_work") and len(attributes.is_cont_work) and attributes.is_cont_work eq 1>
				AND EMPLOYEES_APP.EMPAPP_ID IN (SELECT EMPAPP_ID FROM EMPLOYEES_APP_WORK_INFO WHERE IS_CONT_WORK = 1)
			<cfelseif  isdefined("attributes.is_cont_work") and len(attributes.is_cont_work) and attributes.is_cont_work eq 0>
				AND EMPLOYEES_APP.EMPAPP_ID IN (SELECT EMPAPP_ID FROM EMPLOYEES_APP_WORK_INFO WHERE (IS_CONT_WORK = 0 OR IS_CONT_WORK IS NULL))
			</cfif>
			<cfif isdefined("attributes.internship") and len(attributes.internship) and attributes.internship neq 0>
				AND EMPLOYEES_APP.EMPAPP_ID IN (SELECT EMPAPP_ID FROM EMPLOYEES_APP_TEACHER_INFO WHERE INTERNSHIP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.internship#">)
			</cfif>
			<cfset city_count=0>
			<cfif isdefined("attributes.prefered_city") and len(attributes.prefered_city)>
				AND (
					<cfloop list="#attributes.prefered_city#" index="i" delimiters=",">
						 PREFERED_CITY LIKE '%,#i#,%'
						<cfset city_count=city_count+1>
						<cfif listlen(attributes.prefered_city) neq city_count>
						OR
						</cfif>
					</cfloop>
					)
			</cfif>
			<cfif isdefined("attributes.kurs") and len(attributes.kurs)>
			   <cfloop list="#attributes.kurs#" index="i">
				 AND
				 ( KURS1 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#i#,%"> OR
				   KURS2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#i#,%"> OR
				   KURS3 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#i#,%"> )
			   </cfloop>
			</cfif>
			<cfif (isdefined("attributes.exp_year_s1") and len(attributes.exp_year_s1)) or (isdefined("attributes.exp_year_s2") and len(attributes.exp_year_s2))>
				AND EMPLOYEES_APP.EMPAPP_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#exp_app_list#">)
			</cfif>
			<cfif isdefined("attributes.tool") and listlen(attributes.tool)>
				AND 
				(
				<cfloop list="#listsort(attributes.tool,'textnocase')#" index="tool_index">
					COMP_EXP LIKE '%#tool_index#%' <cfif ListLast(ListSort(attributes.tool,'textnocase')) neq "#Trim(tool_index)#">OR</cfif>
				</cfloop>
				)
			</cfif> 
			<cfif isdefined("attributes.is_formation") and len(attributes.is_formation) and attributes.is_formation eq 1>
				AND EMPLOYEES_APP.EMPAPP_ID IN (SELECT EMPAPP_ID FROM EMPLOYEES_APP_TEACHER_INFO WHERE IS_FORMATION = 1)
			<cfelseif isdefined("attributes.is_formation") and len(attributes.is_formation) and attributes.is_formation eq 0>
				AND EMPLOYEES_APP.EMPAPP_ID IN (SELECT EMPAPP_ID FROM EMPLOYEES_APP_TEACHER_INFO WHERE IS_FORMATION = 0 OR IS_FORMATION IS NULL)
			</cfif>
			<cfif isdefined("attributes.branches_id") and len(attributes.branches_id)>
				AND EMPLOYEES_APP.EMPAPP_ID IN (SELECT EMPAPP_ID FROM EMPLOYEES_APP_INFO WHERE BRANCHES_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branches_id#">)
			</cfif>
			<cfif isdefined("attributes.emp_app_info") and len(attributes.emp_app_info)>
				AND EMPLOYEES_APP.EMPAPP_ID IN (SELECT EMPAPP_ID FROM EMPLOYEES_APP_INFO WHERE BRANCHES_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branches_id#"> AND BRANCHES_ROW_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.emp_app_info#">))
			</cfif>
			<cfif isdefined("attributes.formation_typee") and len(attributes.formation_typee)>
				AND (
					<cfloop list="#attributes.formation_typee#" index="form_type">
						EMPLOYEES_APP.EMPAPP_ID IN(SELECT EMPAPP_ID FROM EMPLOYEES_APP_TEACHER_INFO WHERE FORMATION_TYPE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#form_type#,%">)
						<cfif form_type neq listlast(attributes.formation_typee,',') and listlen(attributes.formation_typee,',') gte 1> OR</cfif>
					</cfloop>
					)
			</cfif>
			<cfif isdefined("attributes.preference_branch") and len(attributes.preference_branch)>
				AND (
					<cfloop list="#attributes.preference_branch#" index="brh">
						EMPLOYEES_APP.PREFERENCE_BRANCH LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#brh#,%">
						<cfif brh neq listlast(attributes.preference_branch,',') and listlen(attributes.preference_branch,',') gte 1> OR</cfif>
					</cfloop>
					)
			</cfif>
			<cfif isdefined("attributes.lang") and len(attributes.lang)>
				<cfif attributes.lang_par eq 'OR' or listlen(attributes.lang) eq 1>
					AND EAL.LANG_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.lang#">)
				<cfelse>
					<cfloop list="#attributes.lang#" index="lng">
						AND EMPLOYEES_APP.EMPAPP_ID IN (SELECT EMPAPP_ID FROM EMPLOYEES_APP_LANGUAGE WHERE LANG_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#lng#">)
					</cfloop>
				</cfif>
			</cfif>
			<cfif isdefined("attributes.lang_level") and len(attributes.lang_level)>
				AND (EAL.LANG_SPEAK IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.lang_level#">) OR EAL.LANG_MEAN IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.lang_level#">) OR EAL.LANG_WRITE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.lang_level#">))
			</cfif>
			<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
				AND
				(
					EMPLOYEES_APP.NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
					OR
					EMPLOYEES_APP.SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				)	
			</cfif>
			<cfif isdefined("attributes.commethod_id") and (attributes.commethod_id neq 0)>
				AND EMPLOYEES_APP.COMMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.commethod_id#">
			</cfif>	   
			<cfif isdefined("attributes.app_currency_id") and len(attributes.app_currency_id)>
				AND EMPLOYEES_APP.APP_CURRENCY_ID = #attributes.app_currency_id#
			</cfif>
			<cfif isdefined('attributes.martyr_relative') and len(attributes.martyr_relative)>AND EMPLOYEES_APP.MARTYR_RELATIVE =1</cfif>
			<cfif isdefined('attributes.other') and len(attributes.other)>
				AND
				( 
					(EMPLOYEES_APP.EMPAPP_ID IN
					(SELECT DISTINCT EMPAPP_ID FROM EMPLOYEES_APP_WORK_INFO
					WHERE
					(EXP <cfif attributes.other_if eq 1>NOT</cfif> LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.other#%">) OR
					(EXP_POSITION <cfif attributes.other_if eq 1>NOT</cfif> LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.other#%">) OR
					(EXP_EXTRA <cfif attributes.other_if eq 1>NOT</cfif> LIKE '%#attributes.other#%')
					)
				)
				OR
				( 
					(EMPLOYEES_APP.EMPAPP_ID IN
					(SELECT DISTINCT EMPAPP_ID FROM EMPLOYEES_APP_INFO
					WHERE
					(BRANCHES_ROW_OTHER <cfif attributes.other_if eq 1>NOT</cfif> LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.other#%">))
					)
				)
				OR
				CLUB <cfif attributes.other_if eq 1>NOT</cfif> LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.other#%"> OR
				APPLICANT_NOTES <cfif attributes.other_if eq 1>NOT</cfif> LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.other#%">
				)
			</cfif>
			<cfif isdefined("attributes.unit_id") and len(attributes.unit_id) and len(attributes.unit_row)>
				AND EMPLOYEES_APP.EMPAPP_ID IN(SELECT DISTINCT EAU.EMPAPP_ID FROM EMPLOYEES_APP_UNIT EAU
											WHERE 
												EAU.UNIT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.unit_id#">) 
												AND EAU.UNIT_ROW<=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.unit_row#">
												)
			</cfif>
			<cfif isdefined('attributes.position_cat_id1') and len(attributes.position_cat_id1)>
				AND
				(
					EMPLOYEES_APP.POSITION_CAT_ID1 = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id1#"> OR
					EMPLOYEES_APP.POSITION_CAT_ID2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id1#"> OR
					EMPLOYEES_APP.POSITION_CAT_ID3 = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id1#">
				)
			</cfif>
			<cfif is_ek_bilgi_ara eq 1>
				AND EMPLOYEES_APP.EMPAPP_ID IN(
					SELECT 
						OWNER_ID 
					FROM 
						INFO_PLUS 
					WHERE 
						INFO_OWNER_TYPE = -23
						<cfloop from="1" to="20" index="y">
							<cfif isdefined('attributes.property_select_value_#y#') and len(evaluate('attributes.property_select_value_#y#'))>
							AND PROPERTY#y# LIKE '#evaluate('attributes.property_select_value_#y#')#'
							</cfif>
						</cfloop>
					)
			</cfif>
	
	</cfquery>	</cfif>
		
		<cfif isdefined("attributes.search_app") or isdefined("attributes.search_app_pos")>
	<cfquery name="get_apps" dbtype="query">
		<cfif isdefined("attributes.search_app") and attributes.search_app eq 1>
			SELECT
				EMPAPP_ID,
				EMPLOYEE_ID,
				APP_POS_ID,
				POSITION_ID,
				POSITION_CAT_ID,
				APP_DATE,
				CV_STAGE,
				NAME,
				SURNAME,
				STEP_NO,
				NOTICE_ID,
				APP_COLOR_STATUS,
				COMMETHOD_ID,
				APP_POS_STATUS,
				<!--- VALIDATOR_POSITION_CODE, --->
				VALID_DATE,
				DRIVER_LICENCE,
				RECORD_DATE,
				TRAINING_LEVEL,
				HOMECOUNTY,
				HOMETELCODE,
				HOMETEL,
				MOBILCODE,
				MOBIL,
				SEX,
				MARRIED,
				BIRTH_DATE
			FROM
				GET_EMPAPP
			<cfif isdefined("attributes.search_app_pos") and attributes.search_app_pos eq 1 and  listlen(basvuru_list) and  isdefined("attributes.APP_POS_ID") >
				<cfif isDefined("attributes.action_list_id") and Listlen(attributes.action_list_id) gt 0  >
					WHERE 
						EMPAPP_ID IN(#attributes.action_list_id#)
				<cfelse>	
					WHERE 
						EMPAPP_ID NOT IN(#basvuru_list#)
				</cfif>
			</cfif>
		</cfif>

		<cfif isdefined("attributes.search_app") and attributes.search_app eq 1 and isdefined("attributes.search_app_pos")  and attributes.search_app_pos eq 1 >
		UNION
		</cfif>

		<cfif isdefined("attributes.search_app_pos") and attributes.search_app_pos eq 1 >
			SELECT
			EMPAPP_ID,
				EMPLOYEE_ID,
				APP_POS_ID,
				POSITION_ID,
				POSITION_CAT_ID,
				APP_DATE,
				CV_STAGE,
				NAME,
				SURNAME,
				STEP_NO,
				NOTICE_ID,
				APP_COLOR_STATUS,
				COMMETHOD_ID,
				APP_POS_STATUS,
				<!--- VALIDATOR_POSITION_CODE, --->
				VALID_DATE,
				DRIVER_LICENCE,
				RECORD_DATE,
				TRAINING_LEVEL,
				HOMECOUNTY,
				HOMETELCODE,
				HOMETEL,
				MOBILCODE,
				MOBIL,
				SEX,
				MARRIED,
				BIRTH_DATE
			FROM
				GET_APP_POS
				
			
				<cfif isdefined("attributes.search_app_pos") and attributes.search_app_pos eq 1 and  listlen(basvuru_list) and  isdefined("attributes.APP_POS_ID")>
				<cfif isDefined("attributes.action_list_id") and Listlen(attributes.action_list_id) gt 0  >
					WHERE 
						EMPAPP_ID IN(#attributes.action_list_id#)
				<cfelse>	
					WHERE 
						EMPAPP_ID NOT IN(#basvuru_list#)
				</cfif>
			</cfif>
	
			
				
				
		</cfif>

		<cfif isdefined("attributes.date_status") and attributes.date_status eq 1>ORDER BY APP_DATE DESC
			<cfelseif isdefined("attributes.date_status") and attributes.date_status eq 2>ORDER BY APP_DATE ASC
			<cfelseif isdefined("attributes.date_status") and attributes.date_status eq 3>ORDER BY RECORD_DATE DESC
			<cfelseif isdefined("attributes.date_status") and attributes.date_status eq 4>ORDER BY RECORD_DATE ASC
			<cfelseif isdefined("attributes.date_status") and attributes.date_status eq 5>ORDER BY NAME DESC
			<cfelseif isdefined("attributes.date_status") and attributes.date_status eq 6>ORDER BY NAME ASC
		</cfif>
	</cfquery>
<cfelse>
	<cfset get_apps.recordcount = 0>
</cfif>
