<!--- calisan detayli analiz raporu excel alma 
NOT:burada yapilan degisiklikler employee_analyse_report.cfm dosyasinda da yapilmali. GSO 20141017--->
<cfquery name="get_temp_table" datasource="#dsn#">
	IF object_id('tempdb..##Employee_Temp') IS NOT NULL
		BEGIN DROP TABLE ##Employee_Temp END
</cfquery>
<cfquery name="temp_table" datasource="#dsn#">
	CREATE TABLE ##Employee_Temp
	(
		SIRA_NO int,
		EMPLOYEE_NO nvarchar(50),
		EMPLOYEE_NAME nvarchar(50),
		EMPLOYEE_SURNAME nvarchar(50),
		EMPLOYEE_ID int
		<cfif isdefined('attributes.is_mail') and len(attributes.is_mail)>,EMPLOYEE_EMAIL nvarchar(50)</cfif>
		<cfif isdefined('attributes.is_mobiltel') and len(attributes.is_mobiltel)>
			,MOBILCODE nvarchar(43)
			,MOBILTEL nvarchar(43)
		</cfif>
		<cfif isdefined('attributes.is_groupstart') and len(attributes.is_groupstart)>,GROUP_STARTDATE nvarchar(100)</cfif>
		<cfif isdefined('attributes.is_kidem') and len(attributes.is_kidem)>,KIDEM_DATE nvarchar(100)</cfif>
		<cfif isdefined('attributes.is_izin') and len(attributes.is_izin)>,IZIN_DATE nvarchar(100)</cfif>
		<cfif isdefined('attributes.is_hierarchy') and len(attributes.is_hierarchy)>
			,HIERARCHY nvarchar(50)
			,OZEL_KOD nvarchar(50)
			,OZEL_KOD2 nvarchar(50)
		</cfif>
		<cfif isdefined('attributes.is_mobiltel_spc') and len(attributes.is_mobiltel_spc)>
			,MOBILCODE_SPC nvarchar(43)
			,MOBILTEL_SPC nvarchar(43)
		</cfif>
		<cfif isdefined('attributes.is_address')>
			,ADDRESS nvarchar(500)
			,CITY_NAME nvarchar(43)
			,COUNTY_NAME nvarchar(50)
		</cfif>
		<cfif isdefined('attributes.is_hometel') and len(attributes.is_hometel)>
			,HOMETEL_CODE nvarchar(43)
			,HOMETEL nvarchar(43)
		</cfif>
		<cfif isdefined('attributes.is_cinsiyet') and len(attributes.is_cinsiyet)>,SEX bit</cfif>
		<cfif isdefined('attributes.is_identy') and len(attributes.is_identy)>,TC_IDENTY_NO nvarchar(50)</cfif>
		<cfif isdefined('attributes.is_blood') and len(attributes.is_blood)>,BLOOD_TYPE int</cfif>
		<cfif isdefined('attributes.is_birthdate') and len(attributes.is_birthdate)>,BIRTH_DATE nvarchar(100)</cfif>
		<cfif isdefined('attributes.is_married') and len(attributes.is_married)>,MARRIED bit</cfif>
		<cfif isdefined('attributes.is_birthplace') and len(attributes.is_birthplace)>,BIRTH_PLACE nvarchar(100)</cfif>
		<cfif isdefined('attributes.is_age') and len(attributes.is_age)>,AGE int</cfif>
		<cfif isdefined('attributes.is_father_and_mother') and attributes.is_father_and_mother eq 1>
			,FATHER nvarchar(75)
			,MOTHER nvarchar(75)
		</cfif>
        <cfif isdefined('attributes.is_last_surname') and len(attributes.is_last_surname)>
			,LAST_SURNAME nvarchar(100)
		</cfif>
		<cfif isdefined("attributes.is_identity_info") and len(attributes.is_identity_info)>
			,SERIES nvarchar(43)
			,NUMBER nvarchar(50)
			,IDENTY_CITY nvarchar(100)
			,IDENTY_COUNTY nvarchar(100)
			,WARD nvarchar(100)
			,VILLAGE nvarchar(100)
			,BINDING nvarchar(43)
			,FAMILY nvarchar(43)
			,CUE nvarchar(43)
			,GIVEN_PLACE nvarchar(100)
			,GIVEN_REASON nvarchar(300)
			,RECORD_NUMBER nvarchar(50)
			,GIVEN_DATE nvarchar(100)
		</cfif>
		<cfif (isdefined('attributes.in_out') and attributes.in_out eq 1) or (isdefined("attributes.is_pos") and attributes.is_pos eq 1)>
			<cfif isdefined('attributes.is_branch')>,BRANCH_NAME nvarchar(50)</cfif>
			<cfif isdefined('attributes.is_department')>,DEPARTMENT_HEAD nvarchar(100)</cfif>
			<cfif isdefined('attributes.is_hierarchy_dep') and not isdefined('is_dep_level') and up_dep_len gt 0>
				<cfloop from="#up_dep_len#" to="1" index="i" step="-1">
					,UP_DEP_#i# nvarchar(100)
				</cfloop>
			<cfelseif isdefined('attributes.is_hierarchy_dep') and isdefined('is_dep_level') and get_dep_lvl.recordcount>
				<cfloop query="get_dep_lvl">
					,UP_DEP_#level_no# nvarchar(100)
				</cfloop>
			</cfif>
			<cfif isdefined('attributes.is_kidem_bilgisi') and len(attributes.is_kidem_bilgisi)>
				,KIDEM_BILGISI nvarchar(100)
			</cfif>
			,HIERARCHY_DEP_ID int,
			LEVEL_NO int
			<cfif isdefined('attributes.is_comp_branch')>,ZONE_NAME nvarchar(43)</cfif>
			<cfif isdefined('attributes.is_company')>,NICK_NAME nvarchar(50)</cfif>
		</cfif>
		<cfif isdefined('attributes.is_pos') and attributes.is_pos eq 1>
			<cfif isdefined('attributes.is_org_position')>
				,POSITION_CODE int
				,ORGANIZATION_STEP_ID int
			</cfif>
			<cfif isdefined('attributes.is_position_name')>,POSITION_NAME nvarchar(100)</cfif>
			<cfif isdefined('attributes.is_collar_type')>,COLLAR_TYPE int</cfif>
			<cfif isdefined('attributes.is_title')>,TITLE1 nvarchar(50)</cfif>
			<cfif isdefined('attributes.is_poscat')>,POSITION_CAT nvarchar(100)</cfif>
			<cfif isdefined('attributes.is_function')>,UNIT_NAME nvarchar(50)</cfif>
			<cfif isdefined('attributes.is_idariamir')>,IDARIAMIR nvarchar(100)</cfif>
			<cfif isdefined('attributes.is_fonkamir')>,FONKSIYONAMIR nvarchar(100)</cfif>
		</cfif>
		<cfif (isdefined('attributes.in_out') and attributes.in_out eq 1)>
			<cfif isdefined('attributes.in_comp_reason') and attributes.in_comp_reason eq 1>,REASON nvarchar(200)</cfif>
			<cfif isdefined('attributes.fire_detail') and attributes.fire_detail eq 1>,DETAIL nvarchar(300)</cfif>
			<cfif isdefined('attributes.is_duty_type') or (isdefined('attributes.is_salary') and attributes.is_salary eq 1)>,DUTY_TYPE int</cfif>
			<cfif isdefined('attributes.is_first_ssk')>,FIRST_SSK_DATE nvarchar(100)</cfif>
			<cfif isdefined('attributes.is_start_date')>,START_DATE nvarchar(100)</cfif>
			<cfif isdefined('attributes.is_salary_type') and attributes.is_salary_type eq 1>,SALARY_TYPE int</cfif>
			<cfif isdefined('attributes.is_account_code') and attributes.is_account_code eq 1>,EXPENSE_CODE nvarchar(50)</cfif>
			<cfif isdefined('attributes.is_expense') and attributes.is_expense eq 1>
				,EXPENSE_CENTER_ID int
				,EXPENSE nvarchar(50)
			</cfif>
			<cfif isdefined('attributes.is_title')>,TITLE nvarchar(50)</cfif>
			<cfif isdefined('attributes.is_reason_out')>,GEREKCE int</cfif>
			<cfif isdefined('attributes.is_finish_date')>,FINISH_DATE nvarchar(100)</cfif>
			<cfif isdefined('attributes.is_pdks')>
				,PDKS_NUMBER nvarchar(100)
				,USE_PDKS int
				,PDKS_TYPE_ID int
			</cfif>
			<cfif isdefined('attributes.is_reason')>,EX_IN_OUT_ID int</cfif>
			<cfif isdefined('attributes.is_accounting_accounts')>
				,ACCOUNT_BILL_TYPE nvarchar(250)
				<cfloop query="get_acc_types">
		 			,G_#replace(acc_type_id,'-','_','all')# nvarchar(50)
		 		</cfloop>
			</cfif>
			<cfif isdefined('attributes.is_business_code')>
				,BUSINESS_CODE_NAME nvarchar(100)
				,BUSINESS_CODE nvarchar(50)
			</cfif>
			<cfif isdefined('attributes.is_grade_step') and len(attributes.is_grade_step)>
				,STEP int
				,GRADE int
			</cfif>
			<cfif isdefined('attributes.is_salary') and attributes.is_salary eq 1>
				,EXTRA int
				,GRADE_VALUE int
				,SALARY_FACTOR float
				,AY_ADI float
				,MONEY nvarchar(43)
				,GROSS_NET bit
			</cfif>
			<cfif isdefined('attributes.is_kidem_') and len(attributes.is_kidem_)>,KIDEM_STARTDATE nvarchar(100)</cfif>
		</cfif>
		<cfif isdefined('attributes.is_organization_step')>,ORGANIZATION_STEP_NAME nvarchar(150)</cfif>
		<cfif (isdefined('attributes.is_bank_no') and attributes.is_bank_no eq 1)>
			,BANK_BRANCH_CODE nvarchar(75),
			BANK_ACCOUNT_NO nvarchar(150),
			BANK_NAME nvarchar(150),
			BANK_BRANCH_NAME nvarchar(150),
			IBAN_NO nvarchar(50)
		</cfif>
		<cfif isdefined("attributes.is_end_school") and attributes.is_end_school eq 1>,EDUCATION_NAME nvarchar(50)</cfif>
		<cfif isdefined("attributes.is_salary_plan") and attributes.is_salary_plan eq 1>
			,GR_MAAS float,
			MONEY1 nvarchar(43)
		</cfif>
	)
</cfquery>
<cfquery name="Add_Employee_Temp" datasource="#dsn#">
	<cfoutput query="get_employee">
		 INSERT INTO ##Employee_Temp 
		 (
		 	SIRA_NO,
		 	EMPLOYEE_NO,
		 	EMPLOYEE_NAME,
		 	EMPLOYEE_SURNAME,
		 	EMPLOYEE_ID
		 	<cfif isdefined('attributes.is_mail') and len(attributes.is_mail)>,EMPLOYEE_EMAIL</cfif>
		 	<cfif isdefined('attributes.is_mobiltel') and len(attributes.is_mobiltel)>
		 		,MOBILCODE
		 		,MOBILTEL
		 	</cfif>
		 	<cfif isdefined('attributes.is_groupstart') and len(attributes.is_groupstart)>,GROUP_STARTDATE</cfif>
		 	<cfif isdefined('attributes.is_kidem') and len(attributes.is_kidem)>,KIDEM_DATE</cfif>
		 	<cfif isdefined('attributes.is_izin') and len(attributes.is_izin)>,IZIN_DATE</cfif>
		 	<cfif isdefined('attributes.is_hierarchy') and len(attributes.is_hierarchy)>
		 		,HIERARCHY
		 		,OZEL_KOD
		 		,OZEL_KOD2
		 	</cfif>
		 	<cfif isdefined('attributes.is_mobiltel_spc') and len(attributes.is_mobiltel_spc)>
		 		,MOBILCODE_SPC
		 		,MOBILTEL_SPC
		 	</cfif>
		 	<cfif isdefined('attributes.is_address')>
		 		,ADDRESS
		 		,CITY_NAME
		 		,COUNTY_NAME
		 	</cfif>
		 	<cfif isdefined('attributes.is_hometel') and len(attributes.is_hometel)>
		 		,HOMETEL_CODE
		 		,HOMETEL
		 	</cfif>
		 	<cfif isdefined('attributes.is_cinsiyet') and len(attributes.is_cinsiyet)>,SEX</cfif>
		 	<cfif isdefined('attributes.is_identy') and len(attributes.is_identy)>,TC_IDENTY_NO</cfif>
		 	<cfif isdefined('attributes.is_blood') and len(attributes.is_blood)>,BLOOD_TYPE</cfif>
		 	<cfif isdefined('attributes.is_birthdate') and len(attributes.is_birthdate)>,BIRTH_DATE</cfif>
		 	<cfif isdefined('attributes.is_married') and len(attributes.is_married)>,MARRIED</cfif>
		 	<cfif isdefined('attributes.is_birthplace') and len(attributes.is_birthplace)>,BIRTH_PLACE</cfif>
		 	<cfif isdefined('attributes.is_age') and len(attributes.is_age)>,AGE</cfif>
		 	<cfif isdefined('attributes.is_father_and_mother') and attributes.is_father_and_mother eq 1>
		 		,FATHER
		 		,MOTHER
		 	</cfif>
            <cfif isdefined('attributes.is_last_surname') and len(attributes.is_last_surname)>
		 		,LAST_SURNAME
		 	</cfif>
		 	<cfif isdefined("attributes.is_identity_info") and len(attributes.is_identity_info)>
		 		,SERIES
		 		,NUMBER
		 		,IDENTY_CITY
		 		,IDENTY_COUNTY
		 		,WARD
		 		,VILLAGE
		 		,BINDING
		 		,FAMILY
		 		,CUE
		 		,GIVEN_PLACE
		 		,GIVEN_REASON
		 		,RECORD_NUMBER
		 		,GIVEN_DATE
		 	</cfif>
		 	<cfif (isdefined('attributes.in_out') and attributes.in_out eq 1) or (isdefined("attributes.is_pos") and attributes.is_pos eq 1)>
		 		<cfif isdefined('attributes.is_branch')>,BRANCH_NAME</cfif>
		 		<cfif isdefined('attributes.is_department')>,DEPARTMENT_HEAD</cfif>
		 		<cfif isdefined('attributes.is_hierarchy_dep') and not isdefined('is_dep_level') and up_dep_len gt 0>
		 			<cfloop from="#up_dep_len#" to="1" index="i" step="-1">
						,UP_DEP_#i#
					</cfloop>
				<cfelseif isdefined('attributes.is_hierarchy_dep') and isdefined('is_dep_level') and get_dep_lvl.recordcount>
					<cfloop query="get_dep_lvl">
						,UP_DEP_#level_no#
					</cfloop>
		 		</cfif>
		 		<cfif isdefined('attributes.is_kidem_bilgisi') and len(attributes.is_kidem_bilgisi)>
					,KIDEM_BILGISI
				</cfif>
		 		<!---,HIERARCHY_DEP_ID,
		 		LEVEL_NO--->
		 		<cfif isdefined('attributes.is_comp_branch')>,ZONE_NAME</cfif>
		 		<cfif isdefined('attributes.is_company')>,NICK_NAME</cfif>
		 	</cfif>
		 	<cfif isdefined('attributes.is_pos') and attributes.is_pos eq 1>
		 		<cfif isdefined('attributes.is_org_position')>
		 			,POSITION_CODE
		 			,ORGANIZATION_STEP_ID
		 		</cfif>
		 		<cfif isdefined('attributes.is_position_name')>,POSITION_NAME</cfif>
		 		<cfif isdefined('attributes.is_collar_type')>,COLLAR_TYPE</cfif>
		 		<cfif isdefined('attributes.is_title')>,TITLE1</cfif>
		 		<cfif isdefined('attributes.is_poscat')>,POSITION_CAT</cfif>
		 		<cfif isdefined('attributes.is_function')>,UNIT_NAME</cfif>
		 		<cfif isdefined('attributes.is_idariamir')>,IDARIAMIR</cfif>
		 		<cfif isdefined('attributes.is_fonkamir')>,FONKSIYONAMIR</cfif>
		 	</cfif>
		 	<cfif (isdefined('attributes.in_out') and attributes.in_out eq 1)>
		 		<cfif isdefined('attributes.in_comp_reason') and attributes.in_comp_reason eq 1>,REASON</cfif>
		 		<cfif isdefined('attributes.fire_detail') and attributes.fire_detail eq 1>,DETAIL</cfif>
		 		<cfif isdefined('attributes.is_duty_type') or (isdefined('attributes.is_salary') and attributes.is_salary eq 1)>,DUTY_TYPE</cfif>
		 		<cfif isdefined('attributes.is_first_ssk')>,FIRST_SSK_DATE</cfif>
		 		<cfif isdefined('attributes.is_start_date')>,START_DATE</cfif>
		 		<cfif isdefined('attributes.is_salary_type') and attributes.is_salary_type eq 1>,SALARY_TYPE</cfif>
		 		<cfif isdefined('attributes.is_account_code') and attributes.is_account_code eq 1>,EXPENSE_CODE</cfif>
		 		<cfif isdefined('attributes.is_expense') and attributes.is_expense eq 1>
		 			,EXPENSE_CENTER_ID
		 			,EXPENSE
		 		</cfif>
		 		<cfif isdefined('attributes.is_title')>,TITLE</cfif>
		 		<cfif isdefined('attributes.is_reason_out')>,GEREKCE</cfif>
		 		<cfif isdefined('attributes.is_finish_date')>,FINISH_DATE</cfif>
		 		<cfif isdefined('attributes.is_pdks')>
		 			,PDKS_NUMBER
		 			,USE_PDKS
		 			,PDKS_TYPE_ID
		 		</cfif>
		 		<cfif isdefined('attributes.is_reason')>,EX_IN_OUT_ID</cfif>
		 		<cfif isdefined('attributes.is_accounting_accounts')>
		 			,ACCOUNT_BILL_TYPE
		 			<cfloop query="get_acc_types">
		 				,G_#replace(acc_type_id,'-','_','all')#
		 			</cfloop>
		 		</cfif>
		 		<cfif isdefined('attributes.is_business_code')>
		 			,BUSINESS_CODE_NAME
		 			,BUSINESS_CODE
		 		</cfif>
		 		<cfif isdefined('attributes.is_grade_step') and len(attributes.is_grade_step)>
		 			,STEP
		 			,GRADE
		 		</cfif>
		 		<cfif isdefined('attributes.is_salary') and attributes.is_salary eq 1>
		 			,EXTRA
		 			,GRADE_VALUE
		 			,SALARY_FACTOR
		 			,AY_ADI
		 			,MONEY
		 			,GROSS_NET
		 		</cfif>
		 		<cfif isdefined('attributes.is_kidem_') and len(attributes.is_kidem_)>,KIDEM_STARTDATE</cfif>
		 	</cfif>
		 	<cfif isdefined('attributes.is_organization_step')>,ORGANIZATION_STEP_NAME</cfif>
		 	<cfif (isdefined('attributes.is_bank_no') and attributes.is_bank_no eq 1)>
		 		,BANK_BRANCH_CODE,
		 		BANK_ACCOUNT_NO,
		 		BANK_NAME,
		 		BANK_BRANCH_NAME,
		 		IBAN_NO
		 	</cfif>
		 	<cfif isdefined("attributes.is_end_school") and attributes.is_end_school eq 1>,EDUCATION_NAME</cfif>
		 	<cfif isdefined("attributes.is_salary_plan") and attributes.is_salary_plan eq 1>
		 		,GR_MAAS,
		 		MONEY1
		 	</cfif>
		 )
		 VALUES
		 (
		 	#currentrow#,
		 	'#employee_no#',
		 	'#employee_name#',
		 	'#employee_surname#',
		 	#employee_id#
		 	<cfif isdefined('attributes.is_mail') and len(attributes.is_mail)>,<cfif len(employee_email)>'#employee_email#'<cfelse>NULL</cfif></cfif>
		 	<cfif isdefined('attributes.is_mobiltel') and len(attributes.is_mobiltel)>
		 		,<cfif len(mobilcode)>'#mobilcode#'<cfelse>NULL</cfif>
		 		,<cfif len(mobiltel)>'#mobiltel#'<cfelse>NULL</cfif>
		 	</cfif>
		 	<cfif isdefined('attributes.is_groupstart') and len(attributes.is_groupstart)>,<cfif len(group_startdate)>'#dateformat(group_startdate,dateformat_style)#'<cfelse>NULL</cfif></cfif>
		 	<cfif isdefined('attributes.is_kidem') and len(attributes.is_kidem)>,<cfif len(kidem_date)>'#dateformat(kidem_date,dateformat_style)#'<cfelse>NULL</cfif></cfif>
		 	<cfif isdefined('attributes.is_izin') and len(attributes.is_izin)>,<cfif len(izin_date)>'#dateformat(izin_date,dateformat_style)#'<cfelse>NULL</cfif></cfif>
		 	<cfif isdefined('attributes.is_hierarchy') and len(attributes.is_hierarchy)>
		 		,'#hierarchy#'
		 		,'#ozel_kod#'
		 		,'#ozel_kod2#'
		 	</cfif>
		 	<cfif isdefined('attributes.is_mobiltel_spc') and len(attributes.is_mobiltel_spc)>
		 		,'#mobilcode_spc#'
		 		,'#mobiltel_spc#'
		 	</cfif>
		 	<cfif isdefined('attributes.is_address')>
		 		,<cfif len(address)>'#address#'<cfelse>NULL</cfif>
		 		,<cfif len(city_name)>'#city_name#'<cfelse>NULL</cfif>
		 		,<cfif len(county_name)>'#county_name#'<cfelse>NULL</cfif>
		 	</cfif>
		 	<cfif isdefined('attributes.is_hometel') and len(attributes.is_hometel)>
		 		,'#hometel_code#'
		 		,'#hometel#'
		 	</cfif>
		 	<cfif isdefined('attributes.is_cinsiyet') and len(attributes.is_cinsiyet)>,<cfif len(sex)>#sex#<cfelse>NULL</cfif></cfif>
		 	<cfif isdefined('attributes.is_identy') and len(attributes.is_identy)>,<cfif len(tc_identy_no)>'#tc_identy_no#'<cfelse>NULL</cfif></cfif>
		 	<cfif isdefined('attributes.is_blood') and len(attributes.is_blood)>,<cfif len(blood_type)>#blood_type#<cfelse>NULL</cfif></cfif>
		 	<cfif isdefined('attributes.is_birthdate') and len(attributes.is_birthdate)>,<cfif len(birth_date)>'#dateformat(birth_date,dateformat_style)#'<cfelse>NULL</cfif></cfif>
		 	<cfif isdefined('attributes.is_married') and len(attributes.is_married)>,<cfif len(married)>#married#<cfelse>NULL</cfif></cfif>
		 	<cfif isdefined('attributes.is_birthplace') and len(attributes.is_birthplace)>,<cfif len(birth_place)>'#birth_place#'<cfelse>NULL</cfif></cfif>
		 	<cfif isdefined('attributes.is_age') and len(attributes.is_age)>,<cfif len(birth_date)>#datediff('yyyy',birth_date,now())#<cfelse>NULL</cfif></cfif>
		 	<cfif isdefined('attributes.is_father_and_mother') and attributes.is_father_and_mother eq 1>
		 		,<cfif len(father)>'#father#'<cfelse>NULL</cfif>
		 		,<cfif len(mother)>'#mother#'<cfelse>NULL</cfif>
		 	</cfif>
             <cfif isdefined('attributes.is_last_surname') and len(attributes.is_last_surname)>,<cfif len(last_surname)>'#last_surname#'<cfelse>NULL</cfif></cfif>
		 	<cfif isdefined("attributes.is_identity_info") and len(attributes.is_identity_info)>
		 		,'#series#'
		 		,'#number#'
		 		,'#identy_city#'
		 		,'#identy_county#'
		 		,'#ward#'
		 		,'#village#'
		 		,'#binding#'
		 		,'#family#'
		 		,'#cue#'
		 		,'#given_place#'
		 		,'#given_reason#'
		 		,'#record_number#'
		 		,<cfif len(given_date)>'#dateformat(given_date,dateformat_style)#'<cfelse>NULL</cfif>
		 	</cfif>
		 	<cfif (isdefined('attributes.in_out') and attributes.in_out eq 1) or (isdefined("attributes.is_pos") and attributes.is_pos eq 1)>
		 		<cfif isdefined('attributes.is_branch')>,<cfif len(branch_name)>'#branch_name#'<cfelse>NULL</cfif></cfif>
		 		<cfif isdefined('attributes.is_department')>,<cfif len(department_head)>'#department_head#'<cfelse>NULL</cfif></cfif>
		 		<cfif isdefined('attributes.is_hierarchy_dep') and not isdefined('is_dep_level') and up_dep_len gt 0>
		 			<cfset temp = up_dep_len>
					<cfloop from="1" to="#up_dep_len#" index="i" step="1">
						<cfif isdefined("hierarchy_dep_id") and listlen(hierarchy_dep_id,'.') gt temp>
							<cfset up_dep_id = ListGetAt(hierarchy_dep_id, listlen(hierarchy_dep_id,'.')-temp,".")>
							<cfquery name="get_upper_departments" datasource="#dsn#">
								SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#up_dep_id#">
							</cfquery>
							<cfset up_dep_head = get_upper_departments.department_head>
						<cfelse>
							<cfset up_dep_head = ''>
						</cfif>
						,'#up_dep_head#'
						<cfset temp = temp - 1>
					</cfloop>
				<cfelseif isdefined('attributes.is_hierarchy_dep') and isdefined('is_dep_level') and get_dep_lvl.recordcount>
					<cfif isdefined("hierarchy_dep_id") and listlen(hierarchy_dep_id,'.') gt 1>
                    	<cfquery name="get_upper_departments" datasource="#dsn#">
                        	SELECT
                                DEPARTMENT.DEPARTMENT_HEAD, 
                                CASE WHEN DEPARTMENT_HISTORY.DEPARTMENT_ID IS NOT NULL
                                THEN DEPARTMENT_HISTORY.LEVEL_NO
                                ELSE DEPARTMENT.LEVEL_NO
                                END AS LEVEL_NO
                            FROM 
                                DEPARTMENT
                                LEFT JOIN DEPARTMENT_HISTORY ON DEPARTMENT.DEPARTMENT_ID = DEPARTMENT_HISTORY.DEPARTMENT_ID AND DEPT_HIST_ID = (SELECT TOP 1 DEPT_HIST_ID FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND <cfif len(attributes.finishdate) or len(attributes.startdate)>DEPARTMENT_HISTORY.CHANGE_DATE IS NOT NULL <cfif len(attributes.finishdate)>AND CHANGE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"><cfelseif len(attributes.startdate)>AND CHANGE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"></cfif><cfelse>1=0</cfif> ORDER BY CHANGE_DATE DESC)
                            WHERE 
                                DEPARTMENT.DEPARTMENT_ID IN (<cfqueryparam list="true" cfsqltype="cf_sql_integer" value="#replace(hierarchy_dep_id,'.',',','all')#">)
                        </cfquery>
                    </cfif>
                    <cfloop query="get_dep_lvl">
						<cfif listlen(get_employee.hierarchy_dep_id,".") gt 1>
							<cfquery name="get_dep_head" dbtype="query">
								SELECT DEPARTMENT_HEAD FROM get_upper_departments WHERE LEVEL_NO = #get_dep_lvl.level_no#
							</cfquery>
							<cfif get_dep_head.recordcount>
								,'#get_dep_head.department_head#'
							<cfelse>
								,'-'
							</cfif>
						<cfelse>
							<cfif get_dep_lvl.level_no eq get_employee.level_no>,'#get_employee.department_head#'<cfelse>,'-'</cfif>
						</cfif>
                    </cfloop>
		 		</cfif>
		 		<cfif isdefined('attributes.is_kidem_bilgisi') and len(attributes.is_kidem_bilgisi)>
		 			<cfif len(kidem_date)>
						<cfif isdefined('finish_date') and len(finish_date)>
                            <cfset kidem_gun = datediff("d",kidem_date,finish_date)>
                        <cfelse>
                            <cfset kidem_gun = datediff('d',kidem_date,now())>
                        </cfif>
                        <cfif kidem_gun gte 365>
                            <cfset kidem_yil = kidem_gun \ 365>
                        <cfelse>
                            <cfset kidem_yil = 0>
                        </cfif>
                        <cfset kidem_gun = kidem_gun - (kidem_yil * 365)>
                        <cfif kidem_gun gte 30>
                            <cfset kidem_ay = kidem_gun \ 30>
                        <cfelse>
                            <cfset kidem_ay = 0>
                        </cfif>
                        <cfset kidem_gun = kidem_gun - (kidem_ay * 30)>
                    </cfif>
                    ,'<cfif isdefined('kidem_yil') and kidem_yil gt 0>#kidem_yil# yıl </cfif><cfif isdefined('kidem_ay') and kidem_ay gt 0>#kidem_ay# ay </cfif><cfif isdefined('kidem_gun') and kidem_gun gt 0>#kidem_gun# gün</cfif>'
		 		</cfif>
		 		<cfif isdefined('attributes.is_comp_branch')>,<cfif len(zone_name)>'#zone_name#'<cfelse>NULL</cfif></cfif>
		 		<cfif isdefined('attributes.is_company')>,<cfif len(nick_name)>'#nick_name#'<cfelse>NULL</cfif></cfif>
		 	</cfif>
		 	<cfif isdefined('attributes.is_pos') and attributes.is_pos eq 1>
		 		<cfif isdefined('attributes.is_org_position')>
		 			,#position_code#
		 			,#organization_step_id#
		 		</cfif>
		 		<cfif isdefined('attributes.is_position_name')>,<cfif len(position_name)>'#position_name#'<cfelse>NULL</cfif></cfif>
		 		<cfif isdefined('attributes.is_collar_type')>,<cfif len(collar_type)>#collar_type#<cfelse>NULL</cfif></cfif>
		 		<cfif isdefined('attributes.is_title')>,<cfif len(title1)>'#title1#'<cfelse>NULL</cfif></cfif>
		 		<cfif isdefined('attributes.is_poscat')>,<cfif len(position_cat)>'#position_cat#'<cfelse>NULL</cfif></cfif>
		 		<cfif isdefined('attributes.is_function')>,<cfif len(unit_name)>'#unit_name#'<cfelse>NULL</cfif></cfif>
		 		<cfif isdefined('attributes.is_idariamir')>,<cfif len(idariamir)>'#idariamir#'<cfelse>NULL</cfif></cfif>
		 		<cfif isdefined('attributes.is_fonkamir')>,<cfif len(fonksiyonamir)>'#fonksiyonamir#'<cfelse>NULL</cfif></cfif>
		 	</cfif>
		 	<cfif (isdefined('attributes.in_out') and attributes.in_out eq 1)>
		 		<cfif isdefined('attributes.in_comp_reason') and attributes.in_comp_reason eq 1>,<cfif len(reason)>'#reason#'<cfelse>NULL</cfif></cfif>
		 		<cfif isdefined('attributes.fire_detail') and attributes.fire_detail eq 1>,<cfif len(detail)>'#detail#'<cfelse>NULL</cfif></cfif>
		 		<cfif isdefined('attributes.is_duty_type') or (isdefined('attributes.is_salary') and attributes.is_salary eq 1)>,<cfif len(duty_type)>#duty_type#<cfelse>NULL</cfif></cfif>
		 		<cfif isdefined('attributes.is_first_ssk')>,<cfif len(first_ssk_date)>'#dateformat(first_ssk_date,dateformat_style)#'<cfelse>NULL</cfif></cfif>
		 		<cfif isdefined('attributes.is_start_date')>,<cfif len(start_date)>'#dateformat(start_date,dateformat_style)#'<cfelse>NULL</cfif></cfif>
		 		<cfif isdefined('attributes.is_salary_type') and attributes.is_salary_type eq 1>,<cfif len(salary_type)>#salary_type#<cfelse>NULL</cfif></cfif>
		 		<cfif isdefined('attributes.is_account_code') and attributes.is_account_code eq 1>,'#expense_code#'</cfif>
		 		<cfif isdefined('attributes.is_expense') and attributes.is_expense eq 1>
		 			,<cfif len(expense_center_id)>#expense_center_id#<cfelse>NULL</cfif>
		 			,'#expense#'
		 		</cfif>
		 		<cfif isdefined('attributes.is_title')>,<cfif len(title)>'#title#'<cfelse>NULL</cfif></cfif>
		 		<cfif isdefined('attributes.is_reason_out')>,<cfif len(gerekce)>#gerekce#<cfelse>NULL</cfif></cfif>
		 		<cfif isdefined('attributes.is_finish_date')>,<cfif len(finish_date)>'#dateformat(finish_date,dateformat_style)#'<cfelse>NULL</cfif></cfif>
		 		<cfif isdefined('attributes.is_pdks')>
		 			,'#pdks_number#'
		 			,<cfif len(use_pdks)>#use_pdks#<cfelse>NULL</cfif>
		 			,<cfif len(pdks_type_id)>#pdks_type_id#<cfelse>NULL</cfif>
		 		</cfif>
		 		<cfif isdefined('attributes.is_reason')>,<cfif len(ex_in_out_id)>#ex_in_out_id#<cfelse>NULL</cfif></cfif>
		 		<cfif isdefined('attributes.is_accounting_accounts')>
		 			,'#account_bill_type#'
		 			<cfloop query="get_acc_types">
		 				<cfif len(employee_id)>
			 				<cfquery name="get_emp_accounts_" dbtype="query">
								SELECT ACCOUNT_CODE,ACC_TYPE_ID FROM get_emp_accounts WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#employee_id#"> AND ACC_TYPE_ID = #get_acc_types.acc_type_id#
							</cfquery>
						<cfelse>
							<cfset get_emp_accounts_.account_code = ''>
						</cfif>
		 				,'#get_emp_accounts_.account_code#'
		 			</cfloop>
		 		</cfif>
		 		<cfif isdefined('attributes.is_business_code')>
		 			,'#business_code_name#'
		 			,'#business_code#'
		 		</cfif>
		 		<cfif isdefined('attributes.is_grade_step') and len(attributes.is_grade_step)>
		 			,<cfif len(step)>#step#<cfelse>NULL</cfif>
		 			,<cfif len(grade)>#grade#<cfelse>NULL</cfif>
		 		</cfif>
		 		<cfif isdefined('attributes.is_salary') and attributes.is_salary eq 1>
		 			,<cfif len(extra)>#extra#<cfelse>0</cfif>
		 			,<cfif len(grade_value)>#grade_value#<cfelse>0</cfif>
		 			,<cfif len(salary_factor)>#salary_factor#<cfelse>0</cfif>
		 			,<cfif len(ay_adi)>#ay_adi#<cfelse>NULL</cfif>
		 			,<cfif len(money)>'#money#'<cfelse>NULL</cfif>
		 			,<cfif len(gross_net)>#gross_net#<cfelse>NULL</cfif>
		 		</cfif>
		 		<cfif isdefined('attributes.is_kidem_') and len(attributes.is_kidem_)>,<cfif len(kidem_startdate)>'#dateformat(kidem_startdate,dateformat_style)#'<cfelse>NULL</cfif></cfif>
		 	</cfif>
		 	<cfif isdefined('attributes.is_organization_step')>,'#organization_step_name#'</cfif>
		 	<cfif (isdefined('attributes.is_bank_no') and attributes.is_bank_no eq 1)>
		 		,'#bank_branch_code#'
		 		,'#bank_account_no#'
		 		,'#bank_name#'
		 		,'#bank_branch_name#'
		 		,'#iban_no#'
		 	</cfif>
		 	<cfif isdefined('attributes.is_end_school') and len(attributes.is_end_school)>,'#education_name#'</cfif>
		 	<cfif isdefined("attributes.is_salary_plan") and attributes.is_salary_plan eq 1>
				,<cfif len(gr_maas)>#gr_maas#<cfelse>NULL</cfif>
				,'#money1#'
			</cfif>
		 )
	</cfoutput>
</cfquery>
<cfquery name="get_employee_temp" datasource="#dsn#">
	SELECT
		SIRA_NO AS '<cf_get_lang dictionary_id="58577.Sıra">',
		EMPLOYEE_NO AS '<cf_get_lang dictionary_id="57576.calisan"> <cf_get_lang dictionary_id="57487.No">',
		EMPLOYEE_NAME + ' ' +EMPLOYEE_SURNAME AS '<cf_get_lang dictionary_id="57576.calisan">'
		<cfif (isdefined('attributes.in_out') and attributes.in_out eq 1) or (isdefined("attributes.is_pos") and attributes.is_pos eq 1)>
		 	<!---,HIERARCHY_DEP_ID,
		 	LEVEL_NO--->
		 	<cfif isdefined('attributes.is_company')>,NICK_NAME AS '<cf_get_lang dictionary_id="57574.Şirket">'</cfif>
		 	<cfif isdefined('attributes.is_comp_branch')>,ZONE_NAME AS '<cf_get_lang dictionary_id="57992.Bölge">'</cfif>
		 	<cfif isdefined('attributes.is_branch')>,BRANCH_NAME AS '<cf_get_lang dictionary_id="57453.Şube">'</cfif>
		 	<cfif isdefined('attributes.is_hierarchy_dep') and not isdefined('is_dep_level') and up_dep_len gt 0>
		 		<cfloop from="#up_dep_len#" to="1" index="i" step="-1">
					,UP_DEP_#i# AS '<cf_get_lang dictionary_id='39710.Üst Departman'>#i#'
				</cfloop>
			<cfelseif isdefined('attributes.is_hierarchy_dep') and isdefined('is_dep_level') and get_dep_lvl.recordcount>
				<cfloop query="get_dep_lvl">
					,UP_DEP_#level_no# AS '<cf_get_lang dictionary_id='57572.Departman'>(#level_no#)'
				</cfloop>
		 	</cfif>
		 	<cfif isdefined('attributes.is_department')>,DEPARTMENT_HEAD AS '<cf_get_lang dictionary_id="57572.Departman">'</cfif>
		</cfif>
		<cfif isdefined('attributes.is_pos') and attributes.is_pos eq 1>
		 		<cfif isdefined('attributes.is_org_position')>
		 			,POSITION_CODE
		 			,ORGANIZATION_STEP_ID
		 		</cfif>
		 	<cfif isdefined('attributes.is_position_name')>,POSITION_NAME AS '<cf_get_lang dictionary_id="58497.Pozisyon">'</cfif>
		 	<cfif isdefined('attributes.is_poscat')>,POSITION_CAT AS '<cf_get_lang dictionary_id="59004.Pozisyon Tipi">'</cfif>
		 	<cfif isdefined('attributes.is_title')>,TITLE1 AS '<cf_get_lang dictionary_id='57571.Ünvan'>'</cfif>
		</cfif>
		<cfif isdefined('attributes.is_organization_step')>,ORGANIZATION_STEP_NAME AS '<cf_get_lang dictionary_id='58710.Kademe'>'</cfif>
		<cfif isdefined('attributes.is_pos') and attributes.is_pos eq 1>
		 	<cfif isdefined('attributes.is_function')>,UNIT_NAME AS '<cf_get_lang dictionary_id='58701.Fonksiyon'>'</cfif>
		 	<cfif isdefined('attributes.is_collar_type')>,CASE WHEN COLLAR_TYPE = 1 THEN '<cf_get_lang dictionary_id='38910.Mavi Yaka'>' WHEN COLLAR_TYPE = 2 THEN '<cf_get_lang dictionary_id='38911.Beyaz Yaka'>' END AS '<cf_get_lang dictionary_id='38908.Yaka Tipi'>'</cfif>
		 	<cfif isdefined('attributes.is_idariamir')>,IDARIAMIR AS '<cf_get_lang dictionary_id='38934.İdari Amir'>'</cfif>
		 	<cfif isdefined('attributes.is_fonkamir')>,FONKSIYONAMIR AS '<cf_get_lang dictionary_id='38936.Fonksiyonel Amir'>'</cfif>
		<cfelse>
		 	<cfif isdefined('attributes.is_title')>,TITLE AS '<cf_get_lang dictionary_id='57571.Ünvan'>'</cfif>
		</cfif>
		<cfif isdefined('attributes.is_father_and_mother') and attributes.is_father_and_mother eq 1>
		 	,MOTHER + ' - ' + FATHER AS '<cf_get_lang dictionary_id='39703.Anne Baba Adı'>'
		</cfif>
        <cfif isdefined('attributes.is_last_surname') and len(attributes.is_last_surname)>
		 	,LAST_SURNAME AS '<cf_get_lang dictionary_id='39226.Onceki Soyad'>'
		</cfif>
		<cfif isdefined('attributes.is_birthdate') and len(attributes.is_birthdate)>,BIRTH_DATE AS '<cf_get_lang dictionary_id='58727.Dogum Tarihi'>'</cfif>
		<cfif isdefined('attributes.is_birthplace') and len(attributes.is_birthplace)>,BIRTH_PLACE AS '<cf_get_lang dictionary_id='57790.Dogum Yeri'>'</cfif>
		<cfif isdefined('attributes.is_age') and len(attributes.is_age)>,AGE AS '<cf_get_lang dictionary_id='39398.Yaş'>'</cfif>
		<cfif isdefined('attributes.is_identy') and len(attributes.is_identy)>,TC_IDENTY_NO AS '<cf_get_lang dictionary_id='58025.Tc Kimlik No'>'</cfif>
		<cfif isdefined('attributes.is_cinsiyet') and len(attributes.is_cinsiyet)>,CASE WHEN SEX = 1 THEN '<cf_get_lang dictionary_id='58959.Erkek'>' WHEN SEX = 0 THEN '<cf_get_lang dictionary_id='38921.Bayan'>' END AS '<cf_get_lang dictionary_id='57764.Cinsiyet'>'</cfif>
		<cfif isdefined('attributes.is_married') and len(attributes.is_married)>,CASE WHEN MARRIED = 1 THEN '<cf_get_lang dictionary_id='38916.Evli'>' WHEN MARRIED = 0 THEN '<cf_get_lang dictionary_id='38915.Bekar'>' END AS '<cf_get_lang dictionary_id ='38914.Medeni Durum'>'</cfif>
		<cfif isdefined('attributes.is_blood') and len(attributes.is_blood)>,CASE WHEN BLOOD_TYPE=0 THEN '0 Rh+' WHEN BLOOD_TYPE=1 THEN '0 Rh-' WHEN BLOOD_TYPE=2 THEN 'A Rh+' WHEN BLOOD_TYPE=3 THEN 'A Rh-' WHEN BLOOD_TYPE=4 THEN 'B Rh+' WHEN BLOOD_TYPE=5 THEN 'B Rh-' WHEN BLOOD_TYPE=6 THEN 'AB Rh+' WHEN BLOOD_TYPE=7 THEN 'AB Rh-' END AS '<cf_get_lang dictionary_id='58441.Kan Grubu'>'</cfif>
		<cfif isdefined('attributes.is_address')>
		 	,ADDRESS AS '<cf_get_lang dictionary_id='58723.Adres'>'
		 	,COUNTY_NAME AS '<cf_get_lang dictionary_id='58638.İlçe'>'
		 	,CITY_NAME AS '<cf_get_lang dictionary_id='58608.İl'>'
		</cfif>
		<cfif isdefined('attributes.is_mail') and len(attributes.is_mail)>,EMPLOYEE_EMAIL AS '<cf_get_lang dictionary_id='57428.E-mail'>'</cfif>
		<cfif isdefined('attributes.is_mobiltel') and len(attributes.is_mobiltel)>
		 	,MOBILCODE + ' ' + MOBILTEL AS '<cf_get_lang dictionary_id='58482.Mobil Tel'>'
		</cfif>
		<cfif isdefined('attributes.is_mobiltel_spc') and len(attributes.is_mobiltel_spc)>
		 	,MOBILCODE_SPC + ' ' + MOBILTEL_SPC AS '<cf_get_lang dictionary_id='58482.Mobil Tel'>(<cf_get_lang dictionary_id='29688.Kişisel'>)'
		</cfif>
		<cfif isdefined('attributes.is_hometel') and len(attributes.is_hometel)>
		 	,HOMETEL_CODE + ' ' + HOMETEL AS '<cf_get_lang dictionary_id ='39704.Ev Tel'>'
		</cfif>
		<cfif (isdefined('attributes.is_bank_no') and attributes.is_bank_no eq 1)>
		 	,BANK_NAME AS '<cf_get_lang dictionary_id ='57521.Banka'>'
		 	,BANK_BRANCH_NAME AS '<cf_get_lang dictionary_id ='58933.Banka Şubesi'>'
		 	,BANK_BRANCH_CODE AS '<cf_get_lang dictionary_id ='59005.Şube Kodu'>'
		 	,BANK_ACCOUNT_NO AS '<cf_get_lang dictionary_id ='39707.Banka Hesap No'>'
		 	,IBAN_NO AS '<cf_get_lang dictionary_id ='59007.Iban kodu'>'
		</cfif>
		<cfif isdefined('attributes.is_groupstart') and len(attributes.is_groupstart)>,GROUP_STARTDATE AS '<cf_get_lang dictionary_id='39429.Gruba Giriş'>'</cfif>
		<cfif isdefined('attributes.is_kidem') and len(attributes.is_kidem)>,KIDEM_DATE AS '<cf_get_lang dictionary_id='38907.Kıdem Baz'>'</cfif>
		<cfif isdefined('attributes.is_kidem_') and len(attributes.is_kidem_)>,KIDEM_STARTDATE AS '<cf_get_lang dictionary_id='56630.Kıdem'> <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'>'</cfif>
		<cfif isdefined('attributes.is_kidem_bilgisi') and len(attributes.is_kidem_bilgisi)>,KIDEM_BILGISI AS '<cf_get_lang dictionary_id='60695.Kıdem Bilgisi'>'</cfif>
		<cfif isdefined('attributes.is_izin') and len(attributes.is_izin)>,IZIN_DATE AS '<cf_get_lang dictionary_id='39077.İzin Baz'>'</cfif>
		<cfif isdefined("attributes.is_end_school") and attributes.is_end_school eq 1>,EDUCATION_NAME AS '<cf_get_lang dictionary_id ='39708.Eğitim Durumu'>'</cfif>
		<cfif isdefined('attributes.is_hierarchy') and len(attributes.is_hierarchy)>
		 	,HIERARCHY AS '<cf_get_lang dictionary_id='57789.Özel Kod'>(<cf_get_lang dictionary_id='57761.Hiyerarşi'>)'
		 	,OZEL_KOD AS '<cf_get_lang dictionary_id='57789.Özel Kod'>1'
		 	,OZEL_KOD2 '<cf_get_lang dictionary_id='57789.Özel Kod'>2'
		</cfif>
		<cfif isdefined('attributes.is_grade_step') and len(attributes.is_grade_step)>,GRADE + '-' + STEP AS 'Derece-Kademe'</cfif>
		<cfif isdefined("attributes.is_identity_info") and len(attributes.is_identity_info)>
		 	,SERIES + '/' + NUMBER AS 'Cüzdan Seri/No'
		 	,IDENTY_CITY AS '<cf_get_lang dictionary_id='58608.İl'>'
		 	,IDENTY_COUNTY AS '<cf_get_lang dictionary_id='58638.İlçe'>'
		 	,WARD AS '<cf_get_lang dictionary_id='58735.Mahalle'>'
		 	,VILLAGE AS 'Köy'
		 	,BINDING AS '<cf_get_lang dictionary_id='39236.Cilt No'>'
		 	,FAMILY AS 'Aile Sıra No'
		 	,CUE AS 'Sıra No'
		 	,GIVEN_PLACE AS 'Cüzdanın Verildiği Yer'
		 	,GIVEN_REASON AS 'Veriliş Nedeni'
		 	,RECORD_NUMBER AS 'Kayıt No'
		 	,GIVEN_DATE AS 'Veriliş Tarihi'
		 </cfif>
		 <cfif isdefined('attributes.is_pdks')>
		 	,PDKS_NUMBER AS '<cf_get_lang dictionary_id ='39968.PDKS No'>'
		 	,CASE WHEN USE_PDKS=0 THEN '<cf_get_lang dictionary_id='39014.Bağlı'> <cf_get_lang dictionary_id='39011.Değil'>' WHEN USE_PDKS=1 THEN '<cf_get_lang dictionary_id='39014.Bağlı'>' WHEN USE_PDKS=2 THEN '<cf_get_lang dictionary_id='38799.Tam'> <cf_get_lang dictionary_id='39014.Bağlı'> <cf_get_lang dictionary_id='57491.Saat'>' WHEN USE_PDKS=3 THEN '<cf_get_lang dictionary_id='38799.Tam'> <cf_get_lang dictionary_id='39014.Bağlı'> <cf_get_lang dictionary_id='57490.Gün'>' WHEN USE_PDKS=4 THEN '<cf_get_lang dictionary_id='38806.Vardiya Sistemi'>' END AS '<cf_get_lang dictionary_id ='29489.PDKS Tipi'>'
		 	,CASE WHEN PDKS_TYPE_ID=1 THEN '<cf_get_lang dictionary_id='58009.PDKS'> <cf_get_lang dictionary_id='38801.Kullananlar'>' WHEN PDKS_TYPE_ID=2 THEN '<cf_get_lang dictionary_id='58009.PDKS'> <cf_get_lang dictionary_id='38804.Kullanmayanlar'>' END AS '<cf_get_lang dictionary_id ='38797.Bağlılık Türü'>'
		 </cfif>
		 <cfif isdefined('attributes.is_accounting_accounts')>
		 	,ACCOUNT_BILL_TYPE AS '<cf_get_lang dictionary_id ='38817.Muhasebe Kod Grubu'>'
		 	<cfloop query="get_acc_types">
		 		,G_#replace(acc_type_id,'-','_','all')# AS '#acc_type_name#'
		 	</cfloop>
		 </cfif>
		 <cfif isdefined('attributes.is_first_ssk')>,FIRST_SSK_DATE AS '<cf_get_lang dictionary_id='38883.İlk Sigortalı Oluş'>'</cfif>
		 <cfif isdefined('attributes.is_start_date')>,START_DATE AS '<cf_get_lang dictionary_id='38923.İşe Giriş Tarihi'>'</cfif>
		 <cfif isdefined('attributes.is_finish_date')>,FINISH_DATE AS '<cf_get_lang dictionary_id='39464.İşten Çıkış Tarihi'>'</cfif>
		 <cfif isdefined('attributes.is_account_code') and attributes.is_account_code eq 1>,EXPENSE_CODE AS '<cf_get_lang dictionary_id='39706.Masraf Kodu'>'</cfif>
		 <cfif isdefined('attributes.is_expense') and attributes.is_expense eq 1>
		 	,CASE WHEN EXPENSE_CENTER_ID IS NOT NULL THEN EXPENSE END AS '<cf_get_lang dictionary_id='58460.Masraf Merkezi'>'
		 </cfif>
		 <cfif isdefined('attributes.is_reason')>,CASE WHEN EX_IN_OUT_ID IS NOT NULL THEN '<cf_get_lang dictionary_id="40516.Nakil">' ELSE '<cf_get_lang dictionary_id="58674.Yeni"> <cf_get_lang dictionary_id="57554.Giriş">' END AS '<cf_get_lang dictionary_id='57554.Giriş'><cf_get_lang dictionary_id='39081.Gerekçe'>'</cfif>
		 <cfif isdefined('attributes.is_reason_out')>,GEREKCE AS '<cf_get_lang dictionary_id='57431.Çıkış'><cf_get_lang dictionary_id='39081.Gerekçe'>'</cfif>
		 <cfif isdefined('attributes.is_duty_type')>
		 	,CASE WHEN DUTY_TYPE=0 THEN '<cf_get_lang dictionary_id='38968.İşveren'>'
		 	WHEN DUTY_TYPE=1 THEN '<cf_get_lang dictionary_id='38967.İşveren Vekili'>'
		 	WHEN DUTY_TYPE=2 THEN '<cf_get_lang dictionary_id='57576.Çalışan'>'
		 	WHEN DUTY_TYPE=3 THEN '<cf_get_lang dictionary_id='39111.Sendikalı'>'
		 	WHEN DUTY_TYPE=4 THEN '<cf_get_lang dictionary_id='39113.Sözleşmeli'>'
		 	WHEN DUTY_TYPE=5 THEN '<cf_get_lang dictionary_id='39146.Kapsam dışı'>'
		 	WHEN DUTY_TYPE=6 THEN '<cf_get_lang dictionary_id='55896.Kısmi İstihdam'>'
		 	WHEN DUTY_TYPE=7 THEN '<cf_get_lang dictionary_id='39156.Taşeron'>'
		 	WHEN DUTY_TYPE=8 THEN 'Derece/Kademe'
		 	END AS '<cf_get_lang dictionary_id='58538.Görev Tipi'>'
		 </cfif>
		 <cfif isdefined('attributes.is_business_code')>
		 	,BUSINESS_CODE AS 'Meslek Kodu'
		 	,BUSINESS_CODE_NAME AS 'Meslek Grubu'
		 </cfif>
		 <cfif isdefined("attributes.is_salary_plan") and attributes.is_salary_plan eq 1>
		 	,GR_MAAS AS '<cf_get_lang dictionary_id ='40523.Planlanan Maaş'>'
		 	,MONEY1 AS '<cf_get_lang dictionary_id ='57489.Para Br'>'
		 </cfif>
		 <cfif isdefined('attributes.is_salary') and attributes.is_salary eq 1>
		 	,CASE WHEN DUTY_TYPE=8 THEN ((EXTRA+GRADE_VALUE)*SALARY_FACTOR) ELSE AY_ADI END AS '<cf_get_lang dictionary_id='40071.Maaş'>'
		 	,MONEY AS '<cf_get_lang dictionary_id ='57489.Para Br'>'
		 	,CASE WHEN GROSS_NET=1 THEN '<cf_get_lang dictionary_id='58083.Net'>' ELSE '<cf_get_lang dictionary_id='38990.Brüt'>' END AS '<cf_get_lang dictionary_id ='38990.Brüt'>/<cf_get_lang dictionary_id='58083.Net'>'
		 </cfif>
		 <cfif isdefined('attributes.is_salary_type') and attributes.is_salary_type eq 1>,CASE WHEN SALARY_TYPE=0 THEN '<cf_get_lang dictionary_id ='57491.Saat'>' WHEN SALARY_TYPE=1 THEN '<cf_get_lang dictionary_id ='57490.Gün'>' ELSE '<cf_get_lang dictionary_id ='58724.Ay'>' END AS '<cf_get_lang dictionary_id ='38983.Ü Y'>'</cfif>
		 <cfif isdefined('attributes.in_comp_reason') and attributes.in_comp_reason eq 1>,REASON AS '<cf_get_lang dictionary_id ='38957.Şirket içi gerekçe'>'</cfif>
		 <cfif isdefined('attributes.fire_detail') and attributes.fire_detail eq 1>,DETAIL AS '<cf_get_lang dictionary_id ='38884.Çıkış Açıklaması'>'</cfif>
	FROM 
    	##Employee_Temp
    ORDER BY
    	SIRA_NO
</cfquery>
