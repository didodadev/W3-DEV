<!--- ssk no kontrol--->
<cfif isdefined('attributes.SOCIALSECURITY_NO') and len(attributes.SOCIALSECURITY_NO)>
	<cfquery name="GET_EMP_SOCIALSECURITY_NO" datasource="#DSN#">
		SELECT
			EIO.SOCIALSECURITY_NO,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME
		FROM
			EMPLOYEES_IN_OUT EIO,
			EMPLOYEES E
		WHERE
			EIO.SOCIALSECURITY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.SOCIALSECURITY_NO#"> AND 
			EIO.EMPLOYEE_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#"> AND
			EIO.EMPLOYEE_ID = E.EMPLOYEE_ID
	</cfquery>
	<cfif GET_EMP_SOCIALSECURITY_NO.recordcount>
		<script type="text/javascript">
			alert('<cfoutput>#GET_EMP_SOCIALSECURITY_NO.EMPLOYEE_NAME# #GET_EMP_SOCIALSECURITY_NO.EMPLOYEE_SURNAME# Adlı Çalışan Aynı SSK Numarası İle Kayıtlı</cfoutput>! Lütfen Düzeltiniz!');
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<!--- ssk no kontrol --->
<cf_date tarih="attributes.start_date">
	<cfscript>
		cmp = createobject("component","V16.hr.ehesap.cfc.get_emp_last_in_out");
		cmp.dsn = dsn;
		get_old_in_out = cmp.get_emp_last_in_out(dsn: dsn, employee_id : attributes.employee_id, date_ : now());
    </cfscript>
<cftransaction>
	<cfif get_old_in_out.recordCount and len(get_old_in_out.in_out_id)>
		<cfquery name="add_in_" datasource="#dsn#">
			INSERT INTO 
				EMPLOYEES_IN_OUT
					(
					BRANCH_ID,
					DEPARTMENT_ID,
					EMPLOYEE_ID,
					START_DATE,
					SALARY_TYPE,
					GROSS_NET,
					USE_PDKS,
					IS_5084,
					USE_SSK,
					SSK_STATUTE,
					SABIT_PRIM,
					IS_KISMI_ISTIHDAM,
					DEFECTION_LEVEL,
					BUSINESS_CODE_ID,
					SOCIALSECURITY_NO,
					RECORD_IP,
					RECORD_EMP,
					RECORD_DATE,
					RETIRED_SGDP_NUMBER,
					IS_VARDIYA,
					SHIFT_ID,
					PUANTAJ_GROUP_IDS,
					TRADE_UNION,
					TRADE_UNION_NO,
					DUTY_TYPE,
					FIRST_SSK_DATE,
					TRANSPORT_TYPE_ID,
					PDKS_NUMBER,
					PDKS_TYPE_ID,
					LAW_NUMBERS,
					IS_5510,
					IS_6486,
					IS_6322,
					IS_25510,
                    IS_14857,
                    IS_6645,
                    IS_46486,
                    IS_56486,
                    IS_66486,
					IS_TAX_FREE,
					IS_DAMGA_FREE,
					USE_TAX,
					EFFECTED_CORPORATE_CHANGE,
					IS_DISCOUNT_OFF,
					IS_PUANTAJ_OFF,
					IN_OUT_STAGE,
					GRADE,
					STEP,
					ADDITIONAL_SCORE,
					ADMINISTRATIVE_INDICATOR_SCORE,
					EXECUTIVE_INDICATOR_SCORE,
					PRIVATE_SERVICE_SCORE,
					ADMINISTRATIVE_FUNCTION_ALLOWANCE,
					LANGUAGE_ALLOWANCE_1,
					LANGUAGE_ALLOWANCE_2,
					LANGUAGE_ALLOWANCE_3,
					LANGUAGE_ALLOWANCE_4,
					LANGUAGE_ALLOWANCE_5,
					UNIVERSITY_ALLOWANCE,
					MINIMUM_COURSE_HOURS,
					DIRECTOR_SHARE,
					EMPLOYEE_SHARE,
					PERQUISITE_SCORE,
					ACADEMIC_INCENTIVE_ALLOWANCE,
					HIGH_EDUCATION_COMPENSATION,
					LANGUAGE_ID_1,
					LANGUAGE_ID_2,
					LANGUAGE_ID_3,
					LANGUAGE_ID_4,
					LANGUAGE_ID_5,
					ADMINISTRATIVE_ACADEMIC,
					SERVICE_CLASS,
					SERVICE_TITLE
					)
					SELECT
						#attributes.branch_id#,
						#attributes.department_id#,
						#attributes.employee_id#,
						#attributes.start_date#,
						#attributes.salary_type#,
						#attributes.gross_net#,
						USE_PDKS,
						IS_5084,
						<cfif isdefined("attributes.USE_SSK")><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.USE_SSK#"><cfelse>0</cfif>,
						SSK_STATUTE,
						SABIT_PRIM,
						IS_KISMI_ISTIHDAM,
						DEFECTION_LEVEL,
						<cfif len(attributes.business_code_id)>#attributes.business_code_id#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.socialsecurity_no') and len(attributes.socialsecurity_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.socialsecurity_no#"><cfelse>NULL</cfif>,
						'#cgi.remote_addr#',
						#session.ep.userid#,
						#now()#,
						RETIRED_SGDP_NUMBER,
						IS_VARDIYA,
						SHIFT_ID,
						PUANTAJ_GROUP_IDS,
						TRADE_UNION,
						TRADE_UNION_NO,
						DUTY_TYPE,
						FIRST_SSK_DATE,
						TRANSPORT_TYPE_ID,
						PDKS_NUMBER,
						PDKS_TYPE_ID,
						LAW_NUMBERS,
						IS_5510,
						IS_6486,
						IS_6322,
						IS_25510,
                        IS_14857,
                        IS_6645,
                        IS_46486,
                        IS_56486,
                        IS_66486,
						IS_TAX_FREE,
						IS_DAMGA_FREE,
						USE_TAX,
						EFFECTED_CORPORATE_CHANGE,
						IS_DISCOUNT_OFF,
						IS_PUANTAJ_OFF,
						<cfif isdefined('attributes.process_stage') and len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>,
						GRADE,
						STEP,
						ADDITIONAL_SCORE,
						ADMINISTRATIVE_INDICATOR_SCORE,
						EXECUTIVE_INDICATOR_SCORE,
						PRIVATE_SERVICE_SCORE,
						ADMINISTRATIVE_FUNCTION_ALLOWANCE,
						LANGUAGE_ALLOWANCE_1,
						LANGUAGE_ALLOWANCE_2,
						LANGUAGE_ALLOWANCE_3,
						LANGUAGE_ALLOWANCE_4,
						LANGUAGE_ALLOWANCE_5,
						UNIVERSITY_ALLOWANCE,
						MINIMUM_COURSE_HOURS,
						DIRECTOR_SHARE,
						EMPLOYEE_SHARE,
						PERQUISITE_SCORE,
						ACADEMIC_INCENTIVE_ALLOWANCE,
						HIGH_EDUCATION_COMPENSATION,
						LANGUAGE_ID_1,
						LANGUAGE_ID_2,
						LANGUAGE_ID_3,
						LANGUAGE_ID_4,
						LANGUAGE_ID_5,
						ADMINISTRATIVE_ACADEMIC,
						<cfif len(attributes.service_class)>#attributes.service_class#<cfelse>NULL</cfif>,
						<cfif len(attributes.service_title_id)>#attributes.service_title_id#<cfelse>NULL</cfif>
					FROM
						EMPLOYEES_IN_OUT
					WHERE
						IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_old_in_out.in_out_id#">
		</cfquery>
	<cfelse>
		<cfquery name="add_in_" datasource="#dsn#">
			INSERT INTO 
				EMPLOYEES_IN_OUT
					(
					BRANCH_ID,
					DEPARTMENT_ID,
					EMPLOYEE_ID,
					START_DATE,
					SALARY_TYPE,
					GROSS_NET,
					USE_PDKS,
					IS_5084,
					USE_SSK,
					SSK_STATUTE,
					SABIT_PRIM,
					IS_KISMI_ISTIHDAM,
					DEFECTION_LEVEL,
					BUSINESS_CODE_ID,
					SOCIALSECURITY_NO,
					IN_OUT_STAGE,
					RECORD_IP,
					RECORD_EMP,
					RECORD_DATE,
					ADMINISTRATIVE_ACADEMIC,
					SERVICE_CLASS,
					SERVICE_TITLE
					)
				VALUES
					(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.salary_type#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.gross_net#">,
					0,
					0,
					<cfif isdefined("attributes.USE_SSK")><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.USE_SSK#"><cfelse>0</cfif>,
					1,
					0,
					0,
					0,
					<cfif len(attributes.business_code_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.business_code_id#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.socialsecurity_no') and len(attributes.socialsecurity_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.socialsecurity_no#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.process_stage') and len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfif isdefined('attributes.administrative_academic') and len(attributes.administrative_academic)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.administrative_academic#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.service_class') and len(attributes.service_class)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_class#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.service_title_id') and len(attributes.service_title_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_title_id#"><cfelse>NULL</cfif>
					)
		</cfquery>
	</cfif>
	<cfquery name="upd_" datasource="#dsn#">
		UPDATE 
			EMPLOYEES_IDENTY 
		SET 
			TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tc_identy_no#">,
			UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
			UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
		WHERE 
			EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
	</cfquery>
	<cfquery name="get_last_id" datasource="#dsn#">
		SELECT MAX(IN_OUT_ID) AS LAST_ID FROM EMPLOYEES_IN_OUT
	</cfquery>
	<cfset attributes.IN_OUT_ID = get_last_id.LAST_ID>    <!--- History kayıt atıyor..--->
    <cfinclude template="../query/add_in_out_history.cfm">
	<!--- sube veya departmana baglı muhasebe tanımları var ise   --->
	<cfquery name="get_period" datasource="#dsn#">
        SELECT 
            SP.PERIOD_ID 
        FROM 
            SETUP_PERIOD SP INNER JOIN OUR_COMPANY OC ON SP.OUR_COMPANY_ID = OC.COMP_ID
            INNER JOIN BRANCH B ON OC.COMP_ID = B.COMPANY_ID
        WHERE
        	B.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> AND
            SP.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(attributes.START_DATE)#">
    </cfquery>
    <cfif get_period.recordcount>
		<cfscript>
            cmp = createObject("component","V16.hr.cfc.create_account_period");
            cmp.dsn = dsn;
			if(fusebox.use_period eq true)
				cmp.dsn2_alias = dsn2_alias;
			else
				cmp.dsn2_alias = dsn;
            get_acc_def = cmp.get_account_definition(period_id : get_period.period_id,branch_id:attributes.branch_id,department_id:attributes.department_id);
            if(not get_acc_def.recordcount)
            {
                get_acc_def = cmp.get_account_definition(period_id : get_period.period_id,branch_id:attributes.branch_id);
            }
            
            get_account_code_def = cmp.get_account_code_definition(period_id:get_period.period_id,branch_id:attributes.branch_id,department_id:attributes.department_id);
            if(not get_account_code_def.recordcount)
            {
                get_account_code_def = cmp.get_account_code_definition(period_id:get_period.period_id,branch_id:attributes.branch_id);
            }
            
            get_expense_ = cmp.get_account_expense(period_id:get_period.period_id,branch_id:attributes.branch_id,department_id:attributes.department_id);
            if(not get_expense_.recordcount)
            {
                get_expense_ = cmp.get_account_expense(period_id:get_period.period_id,branch_id:attributes.branch_id);
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
                in_out_id:attributes.IN_OUT_ID,
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
                            in_out_id:attributes.in_out_id,
                            employee_id:attributes.employee_id
                        )>	
                         </cfloop>
        </cfif>
        <cfif get_expense_.recordcount>
            <cfloop query="get_expense_">
            <cfset cmp_.add_employees_period_row(
                            period_id:get_period.period_id,
                            in_out_id:attributes.in_out_id,
                            employee_id:attributes.employee_id,
                            rate:get_expense_.rate,
                            expense_center_id:get_expense_.expense_center_id
                        )>	
            </cfloop>
        </cfif>
    </cfif>
	<cfif IsDefined("attributes.salaryparam_pay_id") and len(attributes.salaryparam_pay_id)>
		<cfset get_payments_cmp = createObject("component","V16.hr.ehesap.cfc.get_payments") /><!--- Ödenek Tanımları --->
		<cfset allowance_expense_cmp = createObject("component","V16.myhome.cfc.allowance_expense") /><!--- Ek Ödenek --->
		<cfloop list="#attributes.salaryparam_pay_id#" item="item">
			<cfset get_payments = get_payments_cmp.SETUP_PAYMENT_INTERRUPTION(odkes_id : item)><!--- Ödenek Bilgileri --->
			<cfset set_payments = allowance_expense_cmp.ADD_SALARYPARAM_PAY(
				comment_pay :  get_payments.comment_pay,<!--- Ödenek İsmi --->
				comment_pay_id : get_payments.odkes_id,<!---Ödenek Id --->
				amount_pay : get_payments.AMOUNT_PAY,<!--- Ödenek (Kurum Payı) --->
				ssk : get_payments.ssk,<!--- ssk 1 : muaf, 2: muaf değil ---> 
				tax : get_payments.tax,<!--- vergi 1 : muaf, 2: muaf değil---> 
				is_damga : get_payments.is_damga,<!--- damga vergisi --->
				is_issizlik : get_payments.is_issizlik,<!--- işsizlik ---> 
				show : get_payments.show,<!--- bordroda görünsün ---> 
				method_pay : get_payments.method_pay,<!--- 1: artı, 2 : ay , 3 : gün, 4 : saat---> 
				period_pay : get_payments.period_pay,<!--- 1: ayda 1, 2 : 3 ayda 1 , 3 : 6 ayda 1, 4 : yılda 1---> 
				start_sal_mon : get_payments.START_SAL_MON,<!--- Başlangıç Ayı --->
				end_sal_mon : get_payments.END_SAL_MON,<!--- Bitiş Ayı --->
				employee_id : attributes.employee_id,<!--- çalışan id --->
				term : year(attributes.START_DATE),<!--- yıl --->
				calc_days : get_payments.calc_days,<!---tutar günü 0 : tümü, 1: gün,2 : fiili gün --->
				is_kidem : get_payments.is_kidem,<!--- kıdeme dahil 1:kıdeme ahil,0 kıdeme dahil değil ??? sorulacak--->
				in_out_id : attributes.IN_OUT_ID,<!--- Giriş çıkış id --->
				from_salary : get_payments.from_salary, <!--- 0 :net,1 : brüt --->
				is_ehesap : get_payments.is_ehesap,<!--- üst düzey ik yetkisi 1 : dahi, 0 :dahil değil--->
				is_ayni_yardim : get_payments.is_ayni_yardim,<!--- ayni yardım --->
				tax_exemption_value : get_payments.tax_exemption_value,<!--- Gelir Vergisi Muafiyet Tutarı --->
				tax_exemption_rate : get_payments.tax_exemption_rate,<!--- Gelir Vergisi Muafiyet Oranı--->
				money : get_payments.MONEY,<!--- Para birimi--->
				is_income : get_payments.is_income,<!--- kazançlara dahil--->
				is_not_execution : get_payments.is_not_execution,<!--- İcraya Dahil Değil --->
				comment_type : get_payments.comment_type,<!--- 1: ek ödenek, 2: kazanc --->
				amount_multiplier : get_payments.amount_multiplier<!--- ÇARPAN --->,
				process_stage : attributes.salaryparam_pay_process
				) />
		</cfloop>
	</cfif>
</cftransaction>

<!---20051013 işe girişte çalışanın hala çalıştığı başka bir pozisyon yoksa ve bu kişi özgeçmişten işe alındı ise 
işte giriş ve çıkış değerleri güncelleniyor --->
<cfquery name="get_emp" datasource="#dsn#">
	SELECT
		EMPLOYEES.EMPLOYEE_ID,
		EMPLOYEES.EMPAPP_ID
	FROM
		EMPLOYEES_IN_OUT,
		EMPLOYEES
	WHERE
		EMPLOYEES.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
		EMPLOYEES_IN_OUT.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
		EMPLOYEES.EMPAPP_ID IS NOT NULL AND
		EMPLOYEES_IN_OUT.FINISH_DATE IS NULL
</cfquery>

<cfquery name="get_first_in_out" datasource="#dsn#" maxrows="1">
	SELECT 
		EI.START_DATE
	FROM
		EMPLOYEES_IN_OUT EI
	WHERE
		EI.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
	ORDER BY EI.START_DATE DESC
</cfquery>
<cfquery name="get_employee" datasource="#dsn#">
	SELECT GROUP_STARTDATE,KIDEM_DATE,IZIN_DATE FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
</cfquery>
<cfif not len(get_employee.GROUP_STARTDATE) and not len(get_employee.KIDEM_DATE) and not len(get_employee.IZIN_DATE)>
	<cfquery name="upd_" datasource="#dsn#">
		UPDATE 
			EMPLOYEES 
		SET
			GROUP_STARTDATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(get_first_in_out.start_date)#">,
			KIDEM_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(get_first_in_out.start_date)#">,
			IZIN_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(get_first_in_out.start_date)#">,
			UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
			UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
		WHERE
			EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
	</cfquery>
</cfif>


<cfif isdefined("attributes.test_process")>
	<cfquery name="get_test_time_xml" datasource="#dsn#">
		SELECT 
			FP.PROPERTY_VALUE AS TEST_TIME,
			FP2.PROPERTY_VALUE AS CAUTION_TIME
		FROM
			FUSEACTION_PROPERTY FP
			INNER JOIN FUSEACTION_PROPERTY FP2 ON FP.OUR_COMPANY_ID = FP2.OUR_COMPANY_ID AND FP.FUSEACTION_NAME = FP2.FUSEACTION_NAME
		WHERE
			FP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
			FP.FUSEACTION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="hr.emp_test_time"> AND
			FP.PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="xml_test_time"> AND
			FP2.PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="xml_caution_time">
	</cfquery>
	<cfset attributes.emp_id = attributes.employee_id>
	<!---<cfset caution_emp_id = session.ep.userid>--->
	<cfif get_test_time_xml.recordcount>
		<cfset caution_time = get_test_time_xml.caution_time>
		<cfset test_time = get_test_time_xml.test_time>
	<cfelse>
		<cfset caution_time = "">
		<cfset test_time = "">
	</cfif>
	<cfset test_detail = 'Deneme Süresi İşlemi'>
	<cfset attributes.control_upd = 1>
	<cfset attributes.work_start_date = dateformat(attributes.START_DATE,dateformat_style)>
	<cfquery name="UPD_EMP_TEST_TIME" datasource="#DSN#">
		UPDATE
			EMPLOYEES_DETAIL
		SET
			TEST_TIME = <cfif len(test_time)><cfqueryparam cfsqltype="cf_sql_integer" value="#test_time#"><cfelse>NULL</cfif>,
			TEST_DETAIL = <cfif len(test_detail)>'#test_detail#'<cfelse>NULL</cfif>,
			CAUTION_TIME = <cfif len(caution_time)><cfqueryparam cfsqltype="cf_sql_integer" value="#caution_time#"><cfelse>NULL</cfif>,
			CAUTION_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.caution_emp_id#">,
			QUIZ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.quiz_id#">,
			UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
			UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
		WHERE
			EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
	</cfquery>
	<cfquery name="get_employee" datasource="#dsn#">
		SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
	</cfquery>
	<cfinclude template="../../query/upd_emp_test_time_warning.cfm">
</cfif>
<cfif get_emp.recordcount eq 1>
	<cfquery name="upd_empapp" datasource="#DSN#">
		UPDATE
			EMPLOYEES_APP
		SET
			WORK_FINISHED=0,
			WORK_STARTED=1
		WHERE
			EMPLOYEE_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
	</cfquery>
	<cfquery name="get_app" datasource="#dsn#">
		SELECT
			EMPLOYEE_ID,
			EMPAPP_ID,
			NAME,
			SURNAME
		FROM
			EMPLOYEES_APP
		WHERE
			EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
	</cfquery>
	<cfquery name="add_app_history" datasource="#DSN#">
		INSERT INTO
			EMPLOYEES_APP_HISTORY
        (
            EMPAPP_ID,
            APP_POS_ID,
            APP_STATUS,
            NAME,
            SURNAME,
            STARTED,
            STEP_NAME,
            RECORD_DATE,
            RECORD_EMP,
            RECORD_IP
        )
		VALUES
        (
            <cfqueryparam cfsqltype="cf_sql_integer" value="#get_app.empapp_id#">,
            NULL,
            1,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_app.name#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_app.surname#">,
            1,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="İşe Giriş">,
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
        )
	</cfquery>
</cfif>
<cfquery name="getEmpName" datasource="#dsn#">
	SELECT 'Ücret Bilgileri : '+EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME EMPLOYEE,EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME AS EMPLOYEE2 FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
</cfquery>
<!---//--->
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
	action_page='#request.self#?fuseaction=#fusebox.circuit#.list_salary&event=upd&in_out_id=#get_last_id.last_id#&empName=#UrlEncodedFormat("#getEmpName.EMPLOYEE2#")#' 
	warning_description='#getEmpName.EMPLOYEE#'>
<script type="text/javascript">
  <cfif not isDefined('attributes.draggable')>
		opener.location.href='<cfoutput>#request.self#?fuseaction=ehesap.list_salary&event=upd&in_out_id=#get_last_id.last_id#&empName=#UrlEncodedFormat("#getEmpName.EMPLOYEE2#")#</cfoutput>';
		window.close();
	<cfelse>
		window.location.href = '<cfoutput>#request.self#?fuseaction=ehesap.list_salary&event=upd&in_out_id=#get_last_id.last_id#&empName=#UrlEncodedFormat("#getEmpName.EMPLOYEE2#")#</cfoutput>';
	</cfif>
</script>