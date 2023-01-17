<cfif isdefined("attributes.attributes_json")>
	<cfset deserialize_atributes = DeserializeJSON(URLDecode(attributes.ATTRIBUTES_JSON))>
	<cfset StructAppend(attributes,deserialize_atributes,true)>
</cfif>
<cf_date tarih="attributes.startdate">
<cf_date tarih="attributes.finish_date">
<cf_date tarih="attributes.IHBARDATE">
<cf_date tarih="attributes.entry_date">

<!--- işten çıkarma tablosuna kayıt yapılır --->
<cfquery name="add_out" datasource="#dsn#">
	UPDATE
		EMPLOYEES_IN_OUT
	SET
		IS_EMPTY_POSITION = <cfif isdefined('attributes.IS_EMPTY_POSITION')>#attributes.IS_EMPTY_POSITION#<cfelse>0</cfif>,		
		IS_STATUS_EMPLOYEE = <cfif isdefined('attributes.IS_STATUS_EMPLOYEE')>#attributes.IS_STATUS_EMPLOYEE#<cfelse>0</cfif>,
		<cfif isdefined("attributes.GROSS_COUNT_TYPE")>GROSS_COUNT_TYPE = #attributes.GROSS_COUNT_TYPE#,</cfif><!--- yapi bu sekilde ellemeyin yo --->
		VALIDATOR_POSITION_CODE = #attributes.VALIDATOR_POSITION_CODE#,
		VALID_EMP = NULL,
		VALID = NULL,
		START_DATE = #attributes.startdate#,
		FINISH_DATE = #attributes.finish_date#,
		<cfif isdefined("attributes.IHBARDATE") and len(attributes.IHBARDATE)>
			IHBAR_DATE = #attributes.IHBARDATE#,
		<cfelse>
			IHBAR_DATE = NULL,
		</cfif>
		EXPLANATION_ID = #attributes.EXPLANATION_ID#,
		IN_COMPANY_REASON_ID = <cfif isdefined("attributes.reason_id") and len(attributes.reason_id)>#attributes.REASON_ID#,<cfelse>NULL,</cfif>
		DETAIL = '#attributes.fire_detail#',
		SALARY = <cfif isdefined('attributes.SALARY')>#attributes.SALARY#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.IHBAR_AMOUNT")>
			IHBAR_DAYS = <cfif attributes.IHBAR_AMOUNT NEQ 0>#attributes.IHBAR_DAYS#<cfelse>0</cfif>,
			IHBAR_AMOUNT = #attributes.IHBAR_AMOUNT#,
		</cfif>
		KIDEM_YEARS = <cfif isdefined("attributes.TOTAL_SSK_YEARS")>#attributes.TOTAL_SSK_YEARS#<cfelse>NULL</cfif>,
		KIDEM_AMOUNT = <cfif isdefined("attributes.kidem_amount") and attributes.kidem_amount NEQ 0>#attributes.KIDEM_AMOUNT#<cfelse>0</cfif>,
		TOTAL_DENEME_DAYS = <cfif isdefined("attributes.TOTAL_DENEME_DAYS")>#attributes.TOTAL_DENEME_DAYS#<cfelse>NULL</cfif>,
		TOTAL_SSK_DAYS = <cfif isdefined("attributes.total_ssk_days_2") and len(attributes.total_ssk_days_2) and isnumeric(attributes.total_ssk_days_2)>#attributes.total_ssk_days_2#<cfelse>0</cfif>,
		TOTAL_SSK_MONTHS = <cfif isdefined("attributes.TOTAL_SSK_MONTHS")>#attributes.TOTAL_SSK_MONTHS#<cfelse>NULL</cfif>,
		KULLANILMAYAN_IZIN_AMOUNT = <cfif isdefined("attributes.yillik_izin_amount")>#attributes.yillik_izin_amount#<cfelse>NULL</cfif>,
		KULLANILMAYAN_IZIN_COUNT = <cfif isdefined("attributes.kullanilmayan_yillik_izin")>#attributes.kullanilmayan_yillik_izin#<cfelse>NULL</cfif>,
		HAKEDILEN_YILLIK_IZIN = <cfif isdefined("attributes.hakkedilen_izin")>#attributes.hakkedilen_izin#<cfelse>NULL</cfif>,
		<!---nakil secildiginde gelen giris islemi ve aktarım bilgileri icin eklendi SG20120717 --->
		<cfif isdefined("attributes.entry_date") and len(attributes.entry_date)>ENTRY_DATE = #attributes.entry_date#,</cfif> 
		<cfif isdefined("attributes.branch_id") and len(attributes.branch_)>ENTRY_BRANCH_ID = #attributes.branch_id#,</cfif> 
		<cfif isdefined("attributes.department_id") and len(attributes.department)>ENTRY_DEPARTMENT_ID = #attributes.department_id#,</cfif> 
		<cfif isdefined("attributes.is_salary")>IS_SALARY_TRANSFER = #attributes.is_salary#<cfelse>IS_SALARY_TRANSFER = NULL</cfif>, 
		<cfif isdefined("attributes.is_salary_detail")>IS_SALARY_DETAIL_TRANSFER = #attributes.is_salary_detail#<cfelse>IS_SALARY_DETAIL_TRANSFER =NULL</cfif>, 
		<cfif isdefined("attributes.is_accounting")>IS_ACCOUNTING_TRANSFER = #attributes.is_accounting#<cfelse>IS_ACCOUNTING_TRANSFER =NULL</cfif>, 
		<cfif isdefined("attributes.is_update_position")>IS_UPDATE_POSITION = #attributes.is_update_position#<cfelse>IS_UPDATE_POSITION =NULL</cfif>, 
        <cfif isdefined('attributes.account_bill_type') and len(attributes.account_bill_type)>NEW_CARD_ACCOUNT_BILL_TYPE=#attributes.account_bill_type#<cfelse>NEW_CARD_ACCOUNT_BILL_TYPE=NULL</cfif>,
		<!---// --->
		IS_KIDEM_BAZ = <cfif isdefined("attributes.is_kidem_baz") and len(attributes.finish_date)>#attributes.is_kidem_baz#<cfelse>NULL</cfif>,
		IS_KIDEM_IHBAR_ALL_TOTAL = <cfif isdefined("attributes.is_kidem_ihbar_all_total") and len(attributes.is_kidem_ihbar_all_total)>#attributes.is_kidem_ihbar_all_total#<cfelse>NULL</cfif>,
		UPDATE_DATE = #NOW()#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		UPDATE_EMP = #SESSION.EP.USERID#
	WHERE
		IN_OUT_ID = #attributes.IN_OUT_ID#
</cfquery>
<cfset get_max_in_out.MAX_ID = attributes.IN_OUT_ID>
<!--- son puantajı aktarılır 
<cfset sal_mon = month(attributes.finish_date)>
<cfset attributes.in_out_id = get_max_in_out.MAX_ID>
<cfset attributes.sal_mon = sal_mon>
<cfset attributes.IN_OUT = 1>
<cfset attributes.renew = 1>
<cfset attributes.is_pass_puantaj = 1>
<cfset attributes.action_type = "puantaj_aktarim_personal">
<cfset attributes.just_firing = 1>
<!--- /// son puantajı aktarılır --->
 --->

<!---TolgaS 20051013 işten çıkışta çalışanın hala çalıştığı başka bir pozisyon yoksa ve bu kişi özgeçmişten işe alındı ise 
işten çıkış değeri olan work_finished  0 olarak güncelleniyor --->
<cfquery name="get_emp_id" datasource="#dsn#">
	SELECT
		E.EMPLOYEE_ID,
		EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS EMP_NAME
	FROM
		EMPLOYEES E,
		EMPLOYEES_IN_OUT EIO
	WHERE
		E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND
		EIO.IN_OUT_ID = #get_max_in_out.MAX_ID#
</cfquery>

<cfquery name="get_emp_cv" datasource="#dsn#">
	SELECT
		EMPAPP_ID,
		EMPLOYEE_NAME AS NAME,
		EMPLOYEE_SURNAME SURNAME
	FROM
		EMPLOYEES
	WHERE
		EMPLOYEE_ID = #get_emp_id.employee_id# AND
		EMPAPP_ID IS NOT NULL
</cfquery>

<cfif get_emp_cv.recordcount>
	<cfquery name="get_emp" datasource="#dsn#">
		SELECT
			EMPLOYEE_ID
		FROM
			EMPLOYEES_IN_OUT
		WHERE
			EMPLOYEE_ID = #get_emp_id.employee_id# AND
			FINISH_DATE IS NULL
	</cfquery>
	
	<cfif not get_emp.recordcount>
		<cfquery name="upd_empapp" datasource="#DSN#">
			UPDATE
				EMPLOYEES_APP
			SET
				WORK_FINISHED=1
			WHERE
				EMPLOYEE_ID=#get_emp_id.employee_id#
		</cfquery>
		<cfquery name="get_app" datasource="#dsn#">
			SELECT
				EMPLOYEE_ID,
				EMPAPP_ID,
				NAME,
				SURNAME,
				APP_STATUS
			FROM
				EMPLOYEES_APP
			WHERE
				EMPLOYEE_ID = #get_emp_id.employee_id#
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
                #get_app.empapp_id#,
                NULL,
                <cfif len(get_app.app_status)>#get_app.app_status#<cfelse>NULL</cfif>,
                '#get_app.name#',
                '#get_app.surname#',
                0,
                'İşten Çıkış',
                #NOW()#,
                #SESSION.EP.USERID#,
                '#CGI.REMOTE_ADDR#'
            )
		</cfquery>
	</cfif>
</cfif>

<!--- Uyarı - ONAYLIYACAK KİŞİ ************* --->
<cfif isdefined('attributes.VALIDATOR_POSITION_CODE') and len(attributes.VALIDATOR_POSITION_CODE) and isdefined("attributes.VALIDATOR_POSITION_CODE") and len(attributes.VALIDATOR_POSITION_CODE)>
	<cfquery name="get_pos_code" datasource="#DSN#">
		SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #attributes.VALIDATOR_POSITION_CODE#
	</cfquery>
	<cfquery name="get_app_warning" datasource="#dsn#">
		SELECT EMPLOYEE_NAME AS NAME, EMPLOYEE_SURNAME AS SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #get_pos_code.EMPLOYEE_ID#
	</cfquery>

	<cfset caution_date = CreateDate(year(now()),month(now()), day(now()))>
	<cfset url_link ='#request.self#?fuseaction=ehesap.list_fire'>
	<cfset pos_code = attributes.VALIDATOR_POSITION_CODE>
	<cfset title = 'İşten Çıkarma işlemi yapılmış olan #get_emp_id.EMP_NAME# için onay vermeniz bekleniyor.'>
    <cfif session.ep.userid neq get_pos_code.EMPLOYEE_ID>
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
                    OUR_COMPANY_ID,
                    PERIOD_ID,
                    POSITION_CODE,
                    IS_ACTIVE,
                    IS_PARENT,
                    IS_CAUTION_ACTION,
                    RESPONSE_ID
                )
                VALUES
                (
                    '#url_link#',
                    '#title#',
                    NULL,
                    #caution_date#,
                    #caution_date#,
                    #now()#,
                    '#CGI.REMOTE_ADDR#',
                    #SESSION.EP.USERID#,
                    #session.ep.company_id#,
                    #session.ep.period_id#,
                    <cfif len(pos_code)>#pos_code#<cfelse>NULL,</cfif>,
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
            SELECT EMPLOYEE_EMAIL,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #get_pos_code.EMPLOYEE_ID#
        </cfquery>
        <cfif len(get_warning_mail.EMPLOYEE_EMAIL)>
            <cfmail from="#session.ep.company#<#session.ep.company_email#>" to="#get_warning_mail.EMPLOYEE_EMAIL#" subject="İşten Çıkış Mülakatı Bilgisi" type="HTML">
                Sayın #get_warning_mail.EMPLOYEE_NAME# #get_warning_mail.EMPLOYEE_SURNAME#,
                <br/><br/>
                #title#<br/><br/>
            </cfmail>
        </cfif>
   	</cfif>
</cfif>
<script>
	closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');
	openBoxDraggable('index.cfm?fuseaction=ehesap.list_fire&event=updOut&in_out_id=<cfoutput>#get_max_in_out.MAX_ID#</cfoutput>','','ui-draggable-box-large');
</script>
