<cfset get_payroll_job = createObject("component","V16.hr.ehesap.cfc.payroll_job")>

<cf_date tarih="attributes.START_DATE">
<cfif isdefined("attributes.FINISH_DATE") and len(attributes.FINISH_DATE)>
	<cf_date tarih="attributes.FINISH_DATE">
</cfif>
<cfif isdefined("attributes.IHBAR_DATE") and len(attributes.IHBAR_DATE)>
	<cf_date tarih="attributes.IHBAR_DATE">
</cfif>
<cfif isdefined("attributes.entry_date") and len(attributes.entry_date)>
	<cf_date tarih="attributes.entry_date">
</cfif>
<cflock name="#createUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="upd_out" datasource="#dsn#">
			UPDATE 
				EMPLOYEES_IN_OUT 
			SET	
				IS_EMPTY_POSITION = <cfif isdefined('attributes.is_empty_position') and len(attributes.is_empty_position)><cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_empty_position#"><cfelse>0</cfif>,
				BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">,
				DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">,
				START_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">,
				IS_5084=<cfif isdefined("attributes.IS_5084")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.GROSS_COUNT_TYPE")>GROSS_COUNT_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.gross_count_type#">,</cfif><!--- yapi bu sekilde ellemeyin yo --->
				FINISH_DATE = <cfif len(attributes.FINISH_DATE)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"><cfelse>NULL</cfif>,
				IHBAR_AMOUNT = <cfif len(attributes.IHBAR_AMOUNT) and len(attributes.FINISH_DATE)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.ihbar_amount#"><cfelse>0</cfif>,
				IHBAR_DATE = <cfif len(attributes.IHBAR_DATE) and len(attributes.FINISH_DATE)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.ihbar_date#"><cfelse>NULL</cfif>,
				IHBAR_DAYS=<cfif len(attributes.IHBAR_DAYS) and len(attributes.FINISH_DATE)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ihbar_days#"><cfelse>0</cfif>,
				KIDEM_AMOUNT=<cfif len(attributes.KIDEM_AMOUNT) and len(attributes.FINISH_DATE)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.kidem_amount#"><cfelse>0</cfif>,
				KIDEM_YEARS=<cfif len(attributes.KIDEM_YEARS) and len(attributes.FINISH_DATE)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.kidem_years#"><cfelse>0</cfif>,
				SALARY=<cfif len(attributes.SALARY) and len(attributes.FINISH_DATE)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.salary#"><cfelse>0</cfif>,
				TOTAL_DENEME_DAYS=<cfif len(attributes.TOTAL_DENEME_DAYS)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.total_deneme_days#"><cfelse>0</cfif>,
				TOTAL_SSK_DAYS=<cfif len(attributes.TOTAL_SSK_DAYS)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.total_ssk_days#"><cfelse>0</cfif>,
				TOTAL_SSK_MONTHS=<cfif len(attributes.TOTAL_SSK_MONTHS)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.total_ssk_months#"><cfelse>0</cfif>,
				KULLANILMAYAN_IZIN_AMOUNT = <cfif len(attributes.KULLANILMAYAN_IZIN_AMOUNT) and len(attributes.FINISH_DATE)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.kullanilmayan_izin_amount#"><cfelse>0</cfif>,
				KULLANILMAYAN_IZIN_COUNT = <cfif len(attributes.KULLANILMAYAN_IZIN_COUNT) and len(attributes.FINISH_DATE)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.kullanilmayan_izin_count#"><cfelse>0</cfif>,
				HAKEDILEN_YILLIK_IZIN = <cfif len(attributes.HAKEDILEN_YILLIK_IZIN)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.hakedilen_yillik_izin#"><cfelse>0</cfif>,
				EXPLANATION_ID = <cfif len(attributes.FINISH_DATE)><cfif len(attributes.explanation_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.explanation_id#"><cfelse>0</cfif><cfelse>NULL</cfif>,
				IN_COMPANY_REASON_ID = <cfif len(attributes.finish_date) and isdefined("attributes.reason_id") and len(attributes.reason_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.reason_id#"><cfelse>NULL</cfif>,
				DETAIL = <cfif isdefined("attributes.fire_detail") and len(attributes.fire_detail) and len(attributes.FINISH_DATE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.fire_detail#"><cfelse>NULL</cfif>,
				<!---nakil secildiginde gelen giris islemi ve aktarım bilgileri icin eklendi SG20120717 --->
				<cfif isdefined("attributes.entry_date") and len(attributes.entry_date)>ENTRY_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.entry_date#">,</cfif> 
				<cfif isdefined("attributes.entry_branch_id") and len(attributes.branch_)>ENTRY_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.entry_branch_id#">,</cfif> 
				<cfif isdefined("attributes.entry_department_id") and len(attributes.entry_department)>ENTRY_DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.entry_department_id#">,</cfif> 
				<cfif isdefined("attributes.is_salary")>IS_SALARY_TRANSFER = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_salary#">,</cfif> 
				<cfif isdefined("attributes.is_salary_detail")>IS_SALARY_DETAIL_TRANSFER = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_salary_detail#">,</cfif> 
				<cfif isdefined("attributes.is_accounting")>IS_ACCOUNTING_TRANSFER = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_accounting#">,</cfif> 
				<!---// --->
				IS_KIDEM_BAZ = <cfif isdefined("attributes.is_kidem_baz") and len(attributes.is_kidem_baz) and len(attributes.finish_date)><cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_kidem_baz#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.valid") and len(attributes.valid)>
					VALID = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.valid#">,
					VALID_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					VALID_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfelseif not len(attributes.FINISH_DATE)>
					VALID = NULL,
					VALID_EMP = NULL,
					VALID_DATE = NULL,
				</cfif>
				UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
			WHERE 
				IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
		</cfquery>
		<!--- Uyarı - UYARILACAK KİŞİ ************* --->
		<!--- çıkış formu seçili ise,çıkış tarihi dolu ise ve form onaylandı ise uyarı gonderilsin--->
		<cfif isdefined('attributes.warning_employee_id') and len(attributes.warning_employee_id) and isdefined("attributes.warning_employee") and len(attributes.warning_employee) and len(attributes.quiz_id) and len(attributes.quiz_name) and len(attributes.finish_date) and isdefined("attributes.valid") and attributes.valid eq 1>
			<cfquery name="get_pos_code" datasource="#DSN#">
			SELECT 
				POSITION_CODE
			FROM 
				EMPLOYEE_POSITIONS
			WHERE 
				EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.warning_employee_id#"> 
			</cfquery>

			<cfquery name="get_app_warning" datasource="#dsn#">
				SELECT
					EMPLOYEE_NAME AS NAME,
					EMPLOYEE_SURNAME AS SURNAME
				FROM
					EMPLOYEES
				WHERE
					EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
			</cfquery>
			<cfif len(attributes.quiz_id) and len(attributes.quiz_name)>
			<!--- işten çıkış formu için kayıt oluşturuluyor--->
				<cfquery name="add_survey_result" datasource="#dsn#">
					INSERT INTO
						SURVEY_MAIN_RESULT
					(
						SURVEY_MAIN_ID,
						ACTION_TYPE,
						ACTION_ID,
						EMP_ID,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP
					)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.quiz_id#">,
						10,<!--- işten çıkış tipi--->
						<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.warning_employee_id#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
					)
				</cfquery>
			</cfif>
			<cfset caution_date = CreateDate(year(now()),month(now()), day(now()))>
			<!---<cfset url_link ='#request.self#?fuseaction=objects.popup_form_add_detailed_survey_main_result&survey_id=#attributes.quiz_id#&action_type=10&action_type_id=#attributes.employee_id#'>--->
			<cfset url_link ='#request.self#?fuseaction=myhome.list_employee_detail_survey_form'>
			<cfset pos_code = get_pos_code.position_code>
			<cfset title = 'İşten Çıkarma işlemi yapılmış olan '&'#get_app_warning.name# #get_app_warning.surname#'&' için işten çıkış mülakatı işlemi yapmanız beklenmektedir.'>
			<cfset description = 'Çıkış mülakatı ile ilgili olarak form doldurunuz.<br/><br/><a href="#url_link#">Değerlendirme formunu doldurmak için tıklayınız</a>'>
			<cfquery name="add_warning" datasource="#DSN#"> <!--- Onay Ve Uyarılar Listesine ekleme yapılıyor --->
				INSERT INTO
					PAGE_WARNINGS
					(
						URL_LINK,
						WARNING_HEAD,
						WARNING_DESCRIPTION,
						EMAIL_WARNING_DATE,
						LAST_RESPONSE_DATE,
						RECORD_DATE,
						RECORD_IP,
						RECORD_EMP,
						POSITION_CODE,
						IS_ACTIVE,
						IS_PARENT,
						IS_CAUTION_ACTION,
						RESPONSE_ID
					)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#url_link#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#title#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#description#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#caution_date#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#caution_date#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
						<cfif len(pos_code)><cfqueryparam cfsqltype="cf_sql_integer" value="#pos_code#"><cfelse>NULL,</cfif>,
						1,
						1,
						0,
						0
					)
			</cfquery>
			
			<cfquery name="GET_WARNINGS" datasource="#dsn#"><!--- şuanda eklenen uyarının id sini alıyor --->
				SELECT Max(W_ID) AS max FROM PAGE_WARNINGS
			</cfquery>
			
			<cfquery name="GET_WARNINGS" datasource="#dsn#">
				UPDATE PAGE_WARNINGS SET PARENT_ID = #GET_WARNINGS.max# WHERE W_ID = #GET_WARNINGS.max#			
			</cfquery>
			
			<cfquery name="get_warning_mail" datasource="#dsn#">
				SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.warning_employee_id#">
			</cfquery>
			
			<cfif len(get_warning_mail.EMPLOYEE_EMAIL)>
				<cfmail from="#session.ep.company#<#session.ep.company_email#>" to="#get_warning_mail.EMPLOYEE_EMAIL#" subject="İşten Çıkış Mülakatı Bilgisi" type="HTML">
					Sayın #get_warning_mail.EMPLOYEE_NAME# #get_warning_mail.EMPLOYEE_SURNAME#,
					<br/><br/>
					#title#<br/><br/>
					<a href='#employee_domain##url_link#' target="_blank">Değerlendirme formunu doldurmak için tıklayınız</a>
				</cfmail>
			</cfif>
		</cfif>
		<!--- UYARI FINISH--->

		<cfset attributes.ex_in_out_id = attributes.IN_OUT_ID>
		<cfinclude template="../query/add_in_out_history.cfm">
		<cfif isdefined("attributes.valid") and attributes.valid eq 1>
			
			<cfset attributes.sal_mon = month(attributes.FINISH_DATE)>
			<cfset attributes.sal_year = year(attributes.FINISH_DATE)>
			<cfquery name="get_hr_ssk_1" datasource="#DSN#">
				SELECT 
					USE_SSK
				FROM 
					EMPLOYEES_IN_OUT
				WHERE 
					IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> 
			</cfquery>
			<cfif get_hr_ssk_1.USE_SSK eq 2>
				<cfinclude template="get_program_parameter.cfm">
				<cfif (isdefined("get_program_parameters.FIRST_DAY_MONTH") and len(get_program_parameters.FIRST_DAY_MONTH) and not(get_program_parameters.FIRST_DAY_MONTH eq 1 and get_program_parameters.LAST_DAY_MONTH eq 0))>
					<cfset last_month_1 = CreateDateTime(attributes.sal_year, attributes.sal_mon,get_program_parameters.FIRST_DAY_MONTH,0,0,0)>      
					<cfif attributes.finish_date lt last_month_1>
						<cfset attributes.sal_mon = month(dateadd("m",-1,last_month_1))>
					</cfif>
				</cfif>
				<cfset get_payroll_job_ = get_payroll_job.create_payroll(
					sal_mon :  attributes.sal_mon,
					sal_year : attributes.sal_year,
					in_out_id : attributes.in_out_id,
					from_fire_action : 1,
					puantaj_type : -1,
					ssk_office : attributes.branch_id,
					ssk_statue : 2,
					statue_type : 1)>
			<cfelse>
				<cfinclude template="../query/add_personal_puantaj_ajax.cfm">
			</cfif>
			

			<cfif attributes.explanation_id eq 18><!---nakil işlemi ise --->
			<!---onaylandıgında şube aktarım ve ucret aktarım isemlleri yapilacak --->
			<!--- yeni subeye giris--->
			<cfif isdefined("attributes.entry_branch_id") and isdefined("attributes.entry_department_id")>
			<cfquery name="add_employee_ın_out_work_entry" datasource="#dsn#"><!--- yeni subeye giris yapar --->
				INSERT INTO
					EMPLOYEES_IN_OUT
					(
					BRANCH_ID,
					DEPARTMENT_ID,
					EMPLOYEE_ID,
					START_DATE,
					SALARY,
					IS_5084,
					SOCIALSECURITY_NO,
					DUTY_TYPE,
					EFFECTED_CORPORATE_CHANGE,
					PAYMETHOD_ID,
					ALLOCATION_DEDUCTION,
					ALLOCATION_DEDUCTION_MONEY,
					GROSS_NET,
					SALARY_TYPE,
					SABIT_PRIM,
					SALARY1,
					MONEY,
					CUMULATIVE_TAX_TOTAL,
					RETIRED_SGDP_NUMBER,
					USE_SSK,
					USE_TAX,
					TRADE_UNION,
					TRADE_UNION_NO,
					TRADE_UNION_DEDUCTION,
					TRADE_UNION_DEDUCTION_MONEY,
					SSK_STATUTE,
					DEFECTION_LEVEL,
					SALARY_VISIBLE,
					FIRST_SSK_DATE,
					OLD_COMPANY_START_DATE,
					START_CUMULATIVE_TAX,
					SURELI_IS_AKDI,
					SURELI_IS_FINISHDATE,
					IS_VARDIYA,
					USE_PDKS,
					PDKS_NUMBER,
					IS_SSK_ISVEREN,
					OZEL_GIDER_INDIRIM,
					OZEL_GIDER_VERGI,
					MAHSUP_IADE,
					FAZLA_MESAI_SAAT,
					POSITION_CODE,
					IS_TAX_FREE,
					SHIFT_ID,
					IS_DISCOUNT_OFF,
					IS_USE_506,
					IS_PUANTAJ_OFF,
					DAYS_506,
					DOC_REPEAT,
					IS_5510,
					IS_DAMGA_FREE,
					BUSINESS_CODE_ID,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP,
					TRANSPORT_TYPE_ID,
					PUANTAJ_GROUP_IDS,
					EX_IN_OUT_ID,<!---nakil hangi giris/cikis kaydi uzerinden yapildigini tutmak icin eklenmistir SG20120727 --->
					IN_OUT_STAGE			
					)
						SELECT
							#attributes.entry_branch_id#,
							#attributes.entry_department_id#,
							EMPLOYEE_ID,
							#attributes.entry_date#,
							SALARY,
							IS_5084,
							SOCIALSECURITY_NO,
							DUTY_TYPE,
							EFFECTED_CORPORATE_CHANGE,
							PAYMETHOD_ID,
							ALLOCATION_DEDUCTION,
							ALLOCATION_DEDUCTION_MONEY,
							GROSS_NET,
							SALARY_TYPE,
							SABIT_PRIM,
							SALARY1,
							MONEY,
							CUMULATIVE_TAX_TOTAL,
							RETIRED_SGDP_NUMBER,
							USE_SSK,
							USE_TAX,
							TRADE_UNION,
							TRADE_UNION_NO,
							TRADE_UNION_DEDUCTION,
							TRADE_UNION_DEDUCTION_MONEY,
							SSK_STATUTE,
							DEFECTION_LEVEL,
							SALARY_VISIBLE,
							FIRST_SSK_DATE,
							OLD_COMPANY_START_DATE,
							START_CUMULATIVE_TAX,
							SURELI_IS_AKDI,
							SURELI_IS_FINISHDATE,
							IS_VARDIYA,
							USE_PDKS,
							PDKS_NUMBER,
							IS_SSK_ISVEREN,
							OZEL_GIDER_INDIRIM,
							OZEL_GIDER_VERGI,
							MAHSUP_IADE,
							FAZLA_MESAI_SAAT,
							POSITION_CODE,
							IS_TAX_FREE,
							SHIFT_ID,
							IS_DISCOUNT_OFF,
							IS_USE_506,
							IS_PUANTAJ_OFF,
							DAYS_506,
							DOC_REPEAT,
							IS_5510,
							IS_DAMGA_FREE,
							BUSINESS_CODE_ID,
							#now()#,
							#session.ep.userid#,
							'#cgi.REMOTE_ADDR#',
							TRANSPORT_TYPE_ID,
							PUANTAJ_GROUP_IDS,
							#attributes.ex_in_out_id#,
							<cfif isdefined('attributes.process_stage') and len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>
						FROM
							EMPLOYEES_IN_OUT
						WHERE
							IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ex_in_out_id#">
			</cfquery>
			<cfquery name="get_last_id" datasource="#dsn#">
				SELECT MAX(IN_OUT_ID) AS LAST_ID FROM EMPLOYEES_IN_OUT
			</cfquery>
			<cfset attributes.NEW_IN_OUT_ID = get_last_id.LAST_ID>
			<cfif isdefined('attributes.is_salary')><!--- ücret bilgileri--->
				<cfquery name="add_" datasource="#dsn#">
					INSERT INTO
						EMPLOYEES_SALARY
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
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP
						)
						SELECT
							#attributes.NEW_IN_OUT_ID#,
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
							#now()#,
							#session.ep.userid#,
							'#cgi.REMOTE_ADDR#'
						FROM
							EMPLOYEES_SALARY
						WHERE
							IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ex_in_out_id#"> AND
							PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(attributes.entry_date)#">
				</cfquery>
				<cfquery name="add_salary_plan" datasource="#dsn#">
					INSERT INTO
						EMPLOYEES_SALARY_PLAN
						(
							EMPLOYEE_ID,
							PERIOD_YEAR,
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
							MONEY,
							RECORD_DATE,
							RECORD_EMP,
							RECORD_IP,
							IN_OUT_ID
						)
						SELECT 
							EMPLOYEE_ID,
							PERIOD_YEAR,
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
							MONEY,
							#now()#,
							#session.ep.userid#,
							'#cgi.REMOTE_ADDR#',
							#attributes.NEW_IN_OUT_ID#
						FROM
							EMPLOYEES_SALARY_PLAN
						WHERE
							IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ex_in_out_id#"> AND
							PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(attributes.entry_date)#">
				</cfquery>
			</cfif>	
			<cfif isdefined('attributes.is_salary_detail')>	<!--- ödenek/kesinti bilgileri--->
				<cfquery name="add_" datasource="#dsn#">
					INSERT INTO
						SALARYPARAM_PAY
						(
						IN_OUT_ID,
						COMMENT_PAY,
						PERIOD_PAY,
						METHOD_PAY,
						AMOUNT_PAY,
						SSK,
						TAX,
						SHOW,
						START_SAL_MON,
						END_SAL_MON,
						EMPLOYEE_ID,
						TERM,
						CALC_DAYS,
						IS_KIDEM,
						FROM_SALARY,	
						IS_EHESAP,
						IS_DAMGA,
						IS_ISSIZLIK,
						FILE_NAME,
						IS_INCOME,
						FACTOR_TYPE,
						COMMENT_TYPE,
						COMMENT_PAY_ID,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP,
						SSK_STATUE,
						STATUE_TYPE,
						PROJECT_ID
						)
						SELECT
							#attributes.NEW_IN_OUT_ID#,
							COMMENT_PAY,
							PERIOD_PAY,
							METHOD_PAY,
							AMOUNT_PAY,
							SSK,
							TAX,
							SHOW,
							START_SAL_MON,
							END_SAL_MON,
							EMPLOYEE_ID,
							TERM,
							CALC_DAYS,
							IS_KIDEM,
							FROM_SALARY,	
							IS_EHESAP,
							IS_DAMGA,
							IS_ISSIZLIK,
							FILE_NAME,
							IS_INCOME,
							FACTOR_TYPE,
							COMMENT_TYPE,
							COMMENT_PAY_ID,
							#now()#,
							#session.ep.userid#,
							'#cgi.REMOTE_ADDR#',
							SSK_STATUE,
							STATUE_TYPE,
							PROJECT_ID
						FROM
							SALARYPARAM_PAY
						WHERE
							IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ex_in_out_id#"> AND
							TERM >= <cfqueryparam cfsqltype="cf_sql_integer" value="#year(attributes.entry_date)#">
				</cfquery>
				<cfquery name="add_" datasource="#dsn#">
					INSERT INTO
						SALARYPARAM_GET
						(
						IN_OUT_ID,
						COMMENT_GET,
						PERIOD_GET,
						METHOD_GET,
						AMOUNT_GET,
						SHOW,
						START_SAL_MON,
						END_SAL_MON,
						EMPLOYEE_ID,
						ACCOUNT_NAME,
						ACCOUNT_CODE,
						ACC_TYPE_ID,
						CONSUMER_ID,
						COMPANY_ID,
						MONEY,
						TAX,
						TERM,
						CALC_DAYS,
						FROM_SALARY,
						IS_INST_AVANS,
						DETAIL,	
						IS_EHESAP,
						FILE_NAME,
						TOTAL_GET,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP,
						IS_NET_TO_GROSS
						)
						SELECT
							#attributes.NEW_IN_OUT_ID#,
							COMMENT_GET,
							PERIOD_GET,
							METHOD_GET,
							AMOUNT_GET,
							SHOW,
							START_SAL_MON,
							END_SAL_MON,
							EMPLOYEE_ID,
							ACCOUNT_NAME,
							ACCOUNT_CODE,
							ACC_TYPE_ID,
							CONSUMER_ID,
							COMPANY_ID,
							MONEY,
							TAX,
							TERM,
							CALC_DAYS,
							FROM_SALARY,
							IS_INST_AVANS,
							DETAIL,	
							IS_EHESAP,
							FILE_NAME,
							TOTAL_GET,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
							IS_NET_TO_GROSS
						FROM
							SALARYPARAM_GET
						WHERE
							IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ex_in_out_id#"> AND
							TERM >= <cfqueryparam cfsqltype="cf_sql_integer" value="#year(attributes.entry_date)#">
				</cfquery>
				<cfquery name="add_" datasource="#dsn#">
					INSERT INTO
						SALARYPARAM_EXCEPT_TAX
						(
						IN_OUT_ID,
						TAX_EXCEPTION,
						START_MONTH,
						FINISH_MONTH,
						AMOUNT,
						EMPLOYEE_ID,
						TERM,
						CALC_DAYS,
						YUZDE_SINIR,
						IS_ALL_PAY,
						IS_ISVEREN,
						FILE_NAME,
						IS_SSK,
						EXCEPTION_TYPE,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP
						)
						SELECT
							#attributes.new_in_out_id#,
							TAX_EXCEPTION,
							START_MONTH,
							FINISH_MONTH,
							AMOUNT,
							EMPLOYEE_ID,
							TERM,
							CALC_DAYS,
							YUZDE_SINIR,
							IS_ALL_PAY,
							IS_ISVEREN,
							FILE_NAME,
							IS_SSK,
							EXCEPTION_TYPE,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
						FROM
							SALARYPARAM_EXCEPT_TAX
						WHERE
							IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ex_in_out_id#"> AND
							TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(attributes.entry_date)#">
				</cfquery>
				<cfquery name="add_bes" datasource="#dsn#">
					INSERT INTO 
						SALARYPARAM_BES
						(
							IN_OUT_ID,
							COMMENT_BES_ID,
							COMMENT_BES,
							RATE_BES,
							START_SAL_MON,
							END_SAL_MON,
							EMPLOYEE_ID,
							TERM,
							UPDATE_DATE,
							UPDATE_EMP,
							UPDATE_IP
						)
						SELECT 
							#attributes.new_in_out_id#,
							COMMENT_BES_ID,
							COMMENT_BES,
							RATE_BES,
							START_SAL_MON,
							END_SAL_MON,
							EMPLOYEE_ID,
							TERM,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
						FROM  
							SALARYPARAM_BES
						WHERE
							IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ex_in_out_id#"> AND
							TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(attributes.entry_date)#">
						
				</cfquery>
			</cfif>	
			<cfif isdefined("attributes.is_accounting")> <!--- muhasebe bilgileri aktar seçili ise --->
			<!--- muhasebe bilgileri --->
			<!--- eğer şubeye ve departmana tanımlı muhasebe tanımları var ise nakil olan kişinin kartında bu bilgileri aktarma SG 20141227--->
				<!--- sube veya departmana baglı muhasebe tanımları var ise   --->
				<cfquery name="get_period" datasource="#dsn#">
					SELECT 
						SP.PERIOD_ID 
					FROM 
						SETUP_PERIOD SP INNER JOIN OUR_COMPANY OC ON SP.OUR_COMPANY_ID = OC.COMP_ID
						INNER JOIN BRANCH B ON OC.COMP_ID = B.COMPANY_ID
					WHERE
						B.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.entry_branch_id#"> AND
						SP.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(attributes.entry_date)#">
				</cfquery>
				<cfscript>
					cmp = createObject("component","V16.hr.cfc.create_account_period");
					cmp.dsn = dsn;
					cmp.dsn2_alias = dsn2_alias;
					get_acc_def = cmp.get_account_definition(period_id : get_period.period_id,branch_id:attributes.entry_branch_id,department_id:attributes.entry_department_id);
					if(not get_acc_def.recordcount)
					{
						get_acc_def = cmp.get_account_definition(period_id : get_period.period_id,branch_id:attributes.entry_branch_id);
					}
					
					get_account_code_def = cmp.get_account_code_definition(period_id:get_period.period_id,branch_id:attributes.entry_branch_id,department_id:attributes.entry_department_id);
					if(not get_account_code_def.recordcount)
					{
						get_account_code_def = cmp.get_account_code_definition(period_id:get_period.period_id,branch_id:attributes.entry_branch_id);
					}
					
					get_expense_ = cmp.get_account_expense(period_id:get_period.period_id,branch_id:attributes.entry_branch_id,department_id:attributes.entry_department_id);
					if(not get_expense_.recordcount)
					{
						get_expense_ = cmp.get_account_expense(period_id:get_period.period_id,branch_id:attributes.entry_branch_id);
					}
				</cfscript>
				<cfset cmp_ = createObject("component","V16.hr.ehesap.cfc.periods_to_in_out") />		
				<cfif get_acc_def.recordcount>
					<cfloop query="get_acc_def">
					<cfif isdefined('attributes.account_bill_type') and len(attributes.account_bill_type)>
						<cfset account_bill_type_ = attributes.account_bill_type>
					<cfelse>
						<cfset account_bill_type_ = get_acc_def.account_bill_type>
					</cfif>
					<cfset cmp_.add_inout_period(
						period_code_cat:account_bill_type_,
						expense_item_id:get_acc_def.expense_item_id,
						expense_item_name:get_acc_def.expense_item_name,
						expense_center_id:get_acc_def.expense_center_id,
						expense_code:get_acc_def.expense_code,
						expense_code_name:get_acc_def.expense_code_name,
						in_out_id:attributes.NEW_IN_OUT_ID,
						period_id:get_period.period_id,
						account_code:get_acc_def.account_code,
						account_name:get_acc_def.account_name
					)>	
					</cfloop>
				</cfif>
				<cfif get_account_code_def.recordcount>
					<cfloop query="get_account_code_def">
					<cfset cmp_.add_emp_accounts(
									acc_type_id:get_account_code_def.acc_type_id,
									account_code:get_account_code_def.account_code,
									period_id:get_period.period_id,
									in_out_id:attributes.NEW_IN_OUT_ID,
									employee_id:attributes.employee_id
								)>	
								</cfloop>
				</cfif>
			
				<cfif get_expense_.recordcount>
					<cfloop query="get_expense_">
					<cfset cmp_.add_employees_period_row(
									period_id:get_period.period_id,
									in_out_id:attributes.NEW_IN_OUT_ID,
									employee_id:attributes.employee_id,
									rate:get_expense_.rate,
									expense_center_id:get_expense_.expense_center_id
								)>	
					</cfloop>
				</cfif>
				<!--- şube veya departmana bağlı parametrik tanım yok ise calisanın nakil yapılan ücret kartından almalı--->
				<cfif not get_acc_def.recordcount>
					<cfquery name="add_period" datasource="#dsn#">
						INSERT INTO
							EMPLOYEES_IN_OUT_PERIOD
							(
								IN_OUT_ID,
								PERIOD_ID,
								ACCOUNT_BILL_TYPE,
								ACCOUNT_CODE,
								EXPENSE_CODE,
								EXPENSE_ITEM_ID,
								ACCOUNT_NAME,
								EXPENSE_CODE_NAME,
								EXPENSE_ITEM_NAME,
								RECORD_PERIOD_ID,
								PERIOD_YEAR,
								PERIOD_COMPANY_ID,
								EXPENSE_CENTER_ID,
								RECORD_DATE,
								RECORD_EMP,
								RECORD_IP
							)
							SELECT
								#attributes.new_in_out_id#,
								PERIOD_ID,
								<cfif isdefined('attributes.account_bill_type') and len(attributes.account_bill_type)>#attributes.account_bill_type#<cfelse>ACCOUNT_BILL_TYPE</cfif>,
								ACCOUNT_CODE,
								EXPENSE_CODE,
								EXPENSE_ITEM_ID,
								ACCOUNT_NAME,
								EXPENSE_CODE_NAME,
								EXPENSE_ITEM_NAME,
								RECORD_PERIOD_ID,
								PERIOD_YEAR,
								PERIOD_COMPANY_ID,
								EXPENSE_CENTER_ID,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
							FROM
								EMPLOYEES_IN_OUT_PERIOD
							WHERE
								IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ex_in_out_id#">
					</cfquery>
					</cfif>
					<cfif not get_account_code_def.recordcount>          
					<cfquery name="add_account" datasource="#dsn#">
						INSERT INTO
							EMPLOYEES_ACCOUNTS
							(
								IN_OUT_ID,
								EMPLOYEE_ID,
								PERIOD_ID,
								ACCOUNT_CODE,
								ACC_TYPE_ID
							)
						SELECT
							#attributes.new_in_out_id#,
							EMPLOYEE_ID,
							PERIOD_ID,
							ACCOUNT_CODE,
							ACC_TYPE_ID
						FROM
							EMPLOYEES_ACCOUNTS
						WHERE
							IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ex_in_out_id#">
					</cfquery>
				</cfif>
			</cfif>
			<cfif isdefined("attributes.is_update_position")><!--- pozisyon bilgileri guncellensin secili ise--->
				<!--- master pozisyondaki departman bilgisi guncelleniyor---->
				<cfquery name="upd_pos_dept" datasource="#dsn#">
					UPDATE EMPLOYEE_POSITIONS SET DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.entry_department_id#"> WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND IS_MASTER = 1
				</cfquery>
				<!--- gorev degisikligi kartina kayit at--->
				<cfquery name="get_history" datasource="#dsn#" maxrows="1">
					SELECT ID FROM EMPLOYEE_POSITIONS_CHANGE_HISTORY WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND FINISH_DATE IS NULL ORDER BY START_DATE DESC
				</cfquery>
				<cfif get_history.recordcount>
				<cfquery name="upd_change_history" datasource="#dsn#" maxrows="1">
					UPDATE 
						EMPLOYEE_POSITIONS_CHANGE_HISTORY 
					SET 
						FINISH_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">,
						UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
						UPDATE_DATE=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
					WHERE 
						ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_history.id#"> 
				</cfquery>
				</cfif>
				<cfquery name="get_master_position" datasource="#dsn#" maxrows="1">
					SELECT POSITION_ID,POSITION_NAME,POSITION_CAT_ID,TITLE_ID,FUNC_ID,ORGANIZATION_STEP_ID,COLLAR_TYPE,UPPER_POSITION_CODE,UPPER_POSITION_CODE2 FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND IS_MASTER = 1
				</cfquery>
				<cfif get_master_position.recordcount>
				<cfquery name="add_new" datasource="#dsn#">
					INSERT INTO
						EMPLOYEE_POSITIONS_CHANGE_HISTORY
						(
							EMPLOYEE_ID,
							DEPARTMENT_ID,
							POSITION_ID,
							POSITION_NAME,
							POSITION_CAT_ID,
							TITLE_ID,
							FUNC_ID,
							ORGANIZATION_STEP_ID,
							COLLAR_TYPE,
							UPPER_POSITION_CODE,
							UPPER_POSITION_CODE2,
							START_DATE,
							RECORD_EMP,
							RECORD_DATE,
							RECORD_IP,
							REASON_ID 
						)
						VALUES
						(
							<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.entry_department_id#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#get_master_position.position_id#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_master_position.position_name#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#get_master_position.position_cat_id#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#get_master_position.title_id#">,
							<cfif len(get_master_position.func_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_master_position.func_id#"><cfelse>NULL</cfif>,
							<cfif len(get_master_position.organization_step_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_master_position.organization_step_id#"><cfelse>NULL</cfif>,
							<cfif len(get_master_position.collar_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_master_position.collar_type#"><cfelse>NULL</cfif>,
							<cfif len(get_master_position.upper_position_code)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_master_position.upper_position_code#"><cfelse>NULL</cfif>,
							<cfif len(get_master_position.upper_position_code2)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_master_position.upper_position_code2#"><cfelse>NULL</cfif>,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.entry_date#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
							<cfif isdefined("attributes.reason_id") and len(attributes.reason_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.reason_id#"><cfelse>NULL</cfif> 				
						)
				</cfquery>
				</cfif>
			</cfif>
			<!--- //--->
			</cfif>
			<cfquery name="getEmpName" datasource="#dsn#">
				SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME AS EMPLOYEE FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
			</cfquery>
			<!---// nakil islemi finish--->
				<cf_workcube_process 
					is_upd='1' 
					data_source='#dsn#' 
					old_process_line='0'
					process_stage='#attributes.process_stage#' 
					record_member='#session.ep.userid#'
					record_date='#now()#' 
					action_table='EMPLOYEES_IN_OUT'
					action_column='IN_OUT_ID'
					action_id='#get_last_id.last_id#' 
					action_page='#request.self#?fuseaction=#fusebox.circuit#.list_salary&event=upd&in_out_id=#get_last_id.last_id#&empName=#UrlEncodedFormat("#getEmpName.EMPLOYEE#")#' 
					warning_description='Ücret Bilgileri'>
			</cfif>
			<cfif isdefined('attributes.IS_EMPTY_POSITION') and attributes.IS_EMPTY_POSITION eq 1>
				<cfquery name="get_pos" datasource="#dsn#">
					SELECT
						POSITION_CODE,
						POSITION_ID
					FROM	
						EMPLOYEE_POSITIONS
					WHERE
						EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
				</cfquery>
				<cfoutput query="get_pos">
					<cfset position_code_ = position_code>
					<cfset position_id_ = position_id>
					<cfset attributes.id = position_id_>
					<cfset url.id = position_id_>
					<cfinclude template="../../query/add_pos_his_info.cfm">
					<cfset history_position_id = ATTRIBUTES.ID>
					<cfinclude template="../../query/add_position_history.cfm">
					<cfquery name="upd_" datasource="#dsn#">
						UPDATE
							EMPLOYEE_POSITIONS
						SET
							EMPLOYEE_ID = NULL,
							EMPLOYEE_NAME = NULL,
							EMPLOYEE_SURNAME = NULL,
							EMPLOYEE_EMAIL = NULL,
							UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
							UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
							UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							IS_ORG_VIEW = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
						WHERE
							POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#position_code_#">
					</cfquery>
				</cfoutput>
			</cfif>
			<cfif isDefined("attributes.IS_STATUS_EMPLOYEE") and attributes.IS_STATUS_EMPLOYEE eq 1 and attributes.valid eq 1>
				<cfquery name="get_pos" datasource="#dsn#">
					UPDATE EMPLOYEES SET EMPLOYEE_STATUS = 0 WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#">
				</cfquery>
			</cfif>
		</cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">
	<cfif not isDefined('attributes.draggable')>
		wrk_opener_reload();
		window.close();
	<cfelse>
		location.href = document.referrer;
	</cfif>
</script>
