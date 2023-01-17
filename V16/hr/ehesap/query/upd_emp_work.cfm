<!--- ssk no kontrol  tekrar acildi 08052006 YO--->
<cfif isdefined("attributes.SOCIALSECURITY_NO") and len(attributes.SOCIALSECURITY_NO)>
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

<!--- emeklilik no kontrol --->
<cfif len(attributes.RETIRED_SGDP_NUMBER)>
	<cfquery name="GET_EMP_RETIRED_SGDP_NUMBER" datasource="#DSN#">
		SELECT
			EIO.RETIRED_SGDP_NUMBER,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME
		FROM
			EMPLOYEES_IN_OUT EIO,
			EMPLOYEES E
		WHERE
			EIO.EMPLOYEE_ID = E.EMPLOYEE_ID AND
			EIO.IN_OUT_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> AND 
			EIO.EMPLOYEE_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#"> AND 
			EIO.RETIRED_SGDP_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.RETIRED_SGDP_NUMBER#">
	</cfquery>
	<cfif GET_EMP_RETIRED_SGDP_NUMBER.recordcount>
		<script type="text/javascript">
			alert('<cfoutput>#GET_EMP_RETIRED_SGDP_NUMBER.EMPLOYEE_NAME# #GET_EMP_RETIRED_SGDP_NUMBER.EMPLOYEE_SURNAME# Adlı Çalışan Aynı Emekli Numarası İle Kayıtlı</cfoutput>! Lütfen Düzeltiniz!');
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<!--- emeklilik no kontrol --->

<!--- pdks no kontrol --->
<cfif len(attributes.pdks_number)>
	<cfquery name="get_emp_pdks_number" datasource="#DSN#">
		SELECT
			EIO.PDKS_NUMBER,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME
		FROM
			EMPLOYEES_IN_OUT EIO,
			EMPLOYEES E
		WHERE
			EIO.EMPLOYEE_ID = E.EMPLOYEE_ID AND
			EIO.PDKS_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.pdks_number#">
			AND EIO.EMPLOYEE_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#">
			AND E.EMPLOYEE_STATUS = 1
			AND EIO.FINISH_DATE IS NULL
	</cfquery>
	<cfif get_emp_pdks_number.recordcount>
		<script type="text/javascript">
			alert('<cfoutput>#get_emp_pdks_number.EMPLOYEE_NAME# #get_emp_pdks_number.EMPLOYEE_SURNAME# Adlı Çalışan Aynı PDKS Numarası İle Kayıtlı</cfoutput>! Lütfen Düzeltiniz!');
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<!--- pdks no kontrol --->

<!--- son 6 altı ay içinde giriş,çıkış  kontrolü , ortalama çalışan sayısı belirlenilerek yeni istihdam yasasına uygunluğu kontrol ediliyor..--->
<cfif isdefined('attributes.is_5510')><!---zaten checkbox chekli ise isdefined olur   --->
	<cfquery name="employment_control" datasource="#dsn#" maxrows="1">
		SELECT 
			E.EMPLOYEE_NAME,
			EIO.FINISH_DATE,
			EIO.START_DATE
		FROM 
			EMPLOYEES E,
			EMPLOYEES_IN_OUT EIO,
			BRANCH B
		WHERE
			EIO.BRANCH_ID = B.BRANCH_ID AND
			B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
			EIO.EMPLOYEE_ID = E.EMPLOYEE_ID AND
			E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
			(
			(EIO.START_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.START_DATE#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('m',-6,attributes.START_DATE)#">)
			OR
			(EIO.FINISH_DATE IS NOT NULL AND EIO.FINISH_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.START_DATE#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('m',-6,attributes.START_DATE)#">)
			OR
			EIO.FINISH_DATE IS NULL
			)
	</cfquery>
	<cfif employment_control.recordcount>
		<script type="text/javascript">
			alert('Çalışanın 6 Ay İçersinde Giriş - Çıkış İşlemi Bulundu!\nÇalışanın Yeni İstihdam Yasasından Yararlanması Kanunen Uygun Değildir!');
		</script>
	</cfif>
	<cfquery name="get_employment_puantaj" datasource="#dsn#" maxrows="12">
			 SELECT
			 	COUNT(EPR.EMPLOYEE_ID) AS calisan_sayisi,
				COUNT(DISTINCT EP.SAL_MON) AS ay_sayısı
			FROM 
				EMPLOYEES_PUANTAJ_ROWS EPR,
				EMPLOYEES_PUANTAJ EP,
				BRANCH B,
				DEPARTMENT D,
				EMPLOYEES_IN_OUT EIO
			WHERE
				EPR.PUANTAJ_ID = EP.PUANTAJ_ID AND
				EIO.IN_OUT_ID=EPR.IN_OUT_ID AND
				EIO.DEPARTMENT_ID = D.DEPARTMENT_ID AND
				D.BRANCH_ID = B.BRANCH_ID AND
				B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
				<cfif DATABASE_TYPE IS "MSSQL">
				AND
				(
					(EP.SAL_MON >= DATEPART(m,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.START_DATE#">)  AND DATEPART(yy,DATEADD(m,-12,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.START_DATE#">)) = EP.SAL_YEAR)
				OR 
					(EP.SAL_MON < DATEPART(m,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.START_DATE#">) AND DATEPART(yy,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.START_DATE#">) = EP.SAL_YEAR)
				)
				<cfelseif DATABASE_TYPE IS "DB2"><!--- DB2 için --->
				AND
				(
					(EP.SAL_MON >= MONTH(<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.START_DATE#">)  AND YEAR(DATE(<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.START_DATE#">) - 12 MONTHS) = EP.SAL_YEAR)
				OR 
					(EP.SAL_MON < YEAR(<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.START_DATE#">) AND YEAR(<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.START_DATE#">) = EP.SAL_YEAR)
				)
			</cfif>
	</cfquery>
		<cfif get_employment_puantaj.calisan_sayisi gt 0 and get_employment_puantaj.ay_sayısı gt 0>
			<cfset ortalama_calisan = (get_employment_puantaj.calisan_sayisi/get_employment_puantaj.ay_sayısı)>
			<cfif ortalama_calisan gte get_employment_puantaj.calisan_sayisi>
				<script type="text/javascript">
					alert('Ortalamanın Üzerinde Çalışan Olduğundan Yeni İstihdam Yasasından Yararlanması Kanunen Uygun Değildir!');
				</script>
			</cfif>
		</cfif>
</cfif>
<!---son 6 altı ay içinde giriş,çıkış  kontrolü , ortalama çalışan sayısı belirlenilerek yeni istihdam yasasına uygunluğu kontrol ediliyor..--->

<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
</cfif>
<cfif isdefined("attributes.date_5763") and len(attributes.date_5763)>
	<cf_date tarih="attributes.date_5763">
</cfif>
<cfif isdefined("attributes.date_6111") and len(attributes.date_6111)>
	<cf_date tarih="attributes.date_6111">
</cfif>
<cfif isdefined("attributes.STARTDATE_7256") and len(attributes.STARTDATE_7256)>
	<cf_date tarih="attributes.STARTDATE_7256">
</cfif>
<cfif isdefined("attributes.FINISHDATE_7256") and len(attributes.FINISHDATE_7256)>
	<cf_date tarih="attributes.FINISHDATE_7256">
</cfif>
<cfif isDefined("first_ssk_date") and len(first_ssk_date)>
	<cf_date tarih="first_ssk_date">
</cfif>
<cfif len(sureli_is_FINISHDATE)>
	<cf_date tarih="sureli_is_FINISHDATE">
</cfif>
<cfif isdefined("attributes.startdate_shift") and len(attributes.startdate_shift)>
	<cf_date tarih="attributes.startdate_shift">
</cfif>
<cfif isdefined("attributes.finishdate_shift") and len(attributes.finishdate_shift)>
	<cf_date tarih="attributes.finishdate_shift">
</cfif>
<cfif isdefined("attributes.suspension_startdate") and len(attributes.suspension_startdate)>
	<cf_date tarih="attributes.suspension_startdate">
</cfif>
<cfif isdefined("attributes.suspension_finishdate") and len(attributes.suspension_finishdate)>
	<cf_date tarih="attributes.suspension_finishdate">
</cfif>
<cfif isdefined("attributes.defection_startdate") and len(attributes.defection_startdate)>
	<cf_date tarih="attributes.defection_startdate">
</cfif>
<cfif isdefined("attributes.defection_finishdate") and len(attributes.defection_finishdate)>
	<cf_date tarih="attributes.defection_finishdate">
</cfif>
<cfquery name="upd_ssk" datasource="#dsn#">
	UPDATE
		EMPLOYEES_IN_OUT
	SET
		SHIFT_ID = <cfif isdefined("attributes.shift_id") and len(attributes.shift_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.shift_id#"><cfelse>NULL</cfif>,
		SOCIALSECURITY_NO = <cfif isdefined("attributes.SOCIALSECURITY_NO") and len(attributes.SOCIALSECURITY_NO)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.SOCIALSECURITY_NO#"><cfelse>NULL</cfif>,
		DUTY_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.DUTY_TYPE#">,
	<cfif isdefined("attributes.EFFECTED_CORPORATE_CHANGE")>
		EFFECTED_CORPORATE_CHANGE = 1, 
	<cfelse> 
		EFFECTED_CORPORATE_CHANGE = 0,
	</cfif>
	<cfif isdefined("attributes.PAYMETHOD_ID") and len(attributes.PAYMETHOD_ID) and len(attributes.PAYMETHOD)>
		PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PAYMETHOD_ID#">, 
	<cfelse> 
		PAYMETHOD_ID = NULL,
	</cfif>
		ALLOCATION_DEDUCTION = 0,
		ALLOCATION_DEDUCTION_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
		GROSS_NET = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.GROSS_NET#">,
		SALARY_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SALARY_TYPE#">,
	<cfif isdefined("attributes.START_CUMULATIVE_TAX_TOTAL") and len(attributes.START_CUMULATIVE_TAX_TOTAL)>
		CUMULATIVE_TAX_TOTAL = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.START_CUMULATIVE_TAX_TOTAL#">,
	<cfelse> 
		CUMULATIVE_TAX_TOTAL = 0, 
	</cfif>
		START_CUMULATIVE_TAX = <cfif isdefined("attributes.START_CUMULATIVE_TAX") and len(attributes.START_CUMULATIVE_TAX)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.START_CUMULATIVE_TAX#">,<cfelse>0,</cfif>
		START_CUMULATIVE_WAGE_TOTAL = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.START_CUMULATIVE_WAGE_TOTAL#">,
		START_DATE = <cfif isdefined("attributes.START_DATE") and len(attributes.START_DATE)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.START_DATE#">,<cfelse>NULL,</cfif>
		RETIRED_SGDP_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.RETIRED_SGDP_NUMBER#">,
		USE_SSK = <cfif isdefined("attributes.USE_SSK")><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.USE_SSK#"><cfelse>0</cfif>,
		USE_TAX = <cfif isdefined("attributes.USE_TAX")>1<cfelse>0</cfif>,
        WORKING_ABROAD = <cfif isdefined("attributes.working_abroad")>1<cfelse>0</cfif>,
		IS_TAX_FREE = <cfif isdefined("attributes.is_tax_free")>1<cfelse>0</cfif>,
		IS_DISCOUNT_OFF = <cfif isdefined("attributes.is_discount_off")>1<cfelse>0</cfif>,
		IS_USE_506 = <cfif isdefined("attributes.is_use_506")>1<cfelse>0</cfif>,
		IS_5510 = <cfif isdefined("attributes.LAW_NUMBERS") and listFind(attributes.LAW_NUMBERS,'5763')>1<cfelse>0</cfif>,
		IS_5084 = <cfif isdefined("attributes.LAW_NUMBERS") and listFind(attributes.LAW_NUMBERS,'5084')>1<cfelse>0</cfif>,
		LAW_NUMBERS = <cfif isdefined("attributes.LAW_NUMBERS")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.LAW_NUMBERS#"><cfelse>NULL</cfif>,
		USE_PDKS = #attributes.USE_PDKS#,
		IS_START_CUMULATIVE_TAX = <cfif isdefined("attributes.IS_START_CUMULATIVE_TAX")>1<cfelse>0</cfif>,
		PDKS_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.pdks_number#">,
		PDKS_TYPE_ID = <cfif len(attributes.pdks_type_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pdks_type_id#"><cfelse>NULL</cfif>,
		TRANSPORT_TYPE_ID = <cfif len(attributes.transport_type_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.transport_type_id#"><cfelse>NULL</cfif>,
		TRADE_UNION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.TRADE_UNION#">,
		TRADE_UNION_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.TRADE_UNION_NO#">,
		SSK_STATUTE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SSK_STATUTE#">,
		<cfif isdefined("attributes.DEFECTION_LEVEL") and len(attributes.DEFECTION_LEVEL)>
			DEFECTION_LEVEL = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.DEFECTION_LEVEL#">,
		</cfif>		
		SALARY_VISIBLE = <cfif isdefined("salary_visible")>1<cfelse>0</cfif>,
		FIRST_SSK_DATE = <cfif len(first_ssk_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#first_ssk_date#"><cfelse>NULL</cfif>,
		SURELI_IS_AKDI = <cfif isdefined("attributes.sureli_is_akdi")>1<cfelse>0</cfif>,
		SURELI_IS_FINISHDATE = <cfif isdefined("attributes.sureli_is_akdi") and len(sureli_is_finishdate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#sureli_is_finishdate#"><cfelse>NULL</cfif>,
		SABIT_PRIM = #SABIT_PRIM#,
		IS_VARDIYA = #IS_VARDIYA#,
		OZEL_GIDER_INDIRIM = <cfif isdefined("attributes.ozel_gider_indirim") and len(ozel_gider_indirim)><cfqueryparam cfsqltype="cf_sql_float" value="#ozel_gider_indirim#"><cfelse>NULL</cfif>,
		OZEL_GIDER_VERGI = <cfif isdefined("attributes.ozel_gider_vergi") and len(ozel_gider_vergi)><cfqueryparam cfsqltype="cf_sql_float" value="#ozel_gider_vergi#"><cfelse>NULL</cfif>,
		MAHSUP_IADE = <cfif isdefined("attributes.mahsup_iade") and len(mahsup_iade)><cfqueryparam cfsqltype="cf_sql_float" value="#mahsup_iade#"><cfelse>NULL</cfif>,
		FIS_TOPLAM = <cfif isdefined("attributes.fis_toplam") and len(fis_toplam)><cfqueryparam cfsqltype="cf_sql_float" value="#fis_toplam#"><cfelse>NULL</cfif>,
		FAZLA_MESAI_SAAT = <cfif isdefined("attributes.fazla_mesai_saat") and len(fazla_mesai_saat)><cfqueryparam cfsqltype="cf_sql_integer" value="#fazla_mesai_saat#"><cfelse>NULL</cfif>,
		<cfif len(attributes.department_id)>DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">,</cfif>
		<cfif len(attributes.branch_id)>BRANCH_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">,</cfif>
		IS_PUANTAJ_OFF = <cfif attributes.duty_type eq 7>1<cfelse><cfif isdefined("attributes.is_puantaj_off")>1<cfelse>0</cfif></cfif>,
		KISMI_ISTIHDAM_GUN = <cfif Len(attributes.kismi_istihdam_gun) and attributes.DUTY_TYPE eq 6><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.kismi_istihdam_gun#"><cfelse>NULL</cfif>,
		KISMI_ISTIHDAM_SAAT = <cfif Len(attributes.kismi_istihdam_saat) and attributes.DUTY_TYPE eq 6><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.kismi_istihdam_saat#"><cfelse>NULL</cfif>,
		IS_DAMGA_FREE = <cfif isdefined("attributes.is_damga_free")>1<cfelse>0</cfif>,
		DATE_5763 = <cfif isdefined("attributes.LAW_NUMBERS") and listFind(attributes.LAW_NUMBERS,'5763') and len(attributes.DATE_5763)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.DATE_5763#">,<cfelse>NULL,</cfif>
		DUTY_TYPE_COMPANY_ID = <cfif attributes.duty_type eq 7 and len(attributes.duty_type_company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.duty_type_company_id#"><cfelse>NULL</cfif>,
		BUSINESS_CODE_ID = <cfif len(attributes.business_code_id) and len(attributes.business_code)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.business_code_id#"><cfelse>NULL</cfif>,
		UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
        DAYS_5746 = <cfif isdefined("attributes.days_5746") and len(attributes.days_5746)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.days_5746#"><cfelse>NULL</cfif>,
        DAYS_4691 = <cfif isdefined("attributes.days_4691") and len(attributes.days_4691)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.days_4691#"><cfelse>NULL</cfif>,
        DATE_6111 = <cfif isdefined("attributes.date_6111") and len(attributes.date_6111)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date_6111#"><cfelse>NULL</cfif>,
        DATE_6111_SELECT = <cfif isdefined("attributes.date_6111_select") and len(attributes.date_6111_select)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.date_6111_select#"><cfelse>NULL</cfif>,
		PUANTAJ_GROUP_IDS = <cfif isdefined('attributes.group_id') and len(attributes.group_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.group_id#"><cfelse>NULL</cfif>,
		IS_6486 = <cfif isdefined("attributes.LAW_NUMBERS") and listFind(attributes.LAW_NUMBERS,'6486')>1<cfelse>0</cfif>,	
		IS_6322 = <cfif isdefined("attributes.LAW_NUMBERS") and listFind(attributes.LAW_NUMBERS,'6322')>1<cfelse>0</cfif>,	
		IS_25510 = <cfif isdefined("attributes.LAW_NUMBERS") and listFind(attributes.LAW_NUMBERS,'25510')>1<cfelse>0</cfif>,
        IS_14857 = <cfif isdefined("attributes.LAW_NUMBERS") and listFind(attributes.LAW_NUMBERS,'14857')>1<cfelse>0</cfif>,
        IS_6645 = <cfif isdefined("attributes.LAW_NUMBERS") and listFind(attributes.LAW_NUMBERS,'6645')>1<cfelse>0</cfif>,
        START_MON_6645 = <cfif isdefined("attributes.start_mon_6645") and len(attributes.start_mon_6645)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.start_mon_6645#"><cfelse>NULL</cfif>,
        START_YEAR_6645 = <cfif isdefined("attributes.start_year_6645") and len(attributes.start_year_6645)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.start_year_6645#"><cfelse>NULL</cfif>,
        END_MON_6645 = <cfif isdefined("attributes.end_mon_6645") and len(attributes.end_mon_6645)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.end_mon_6645#"><cfelse>NULL</cfif>,
        END_YEAR_6645 = <cfif isdefined("attributes.end_year_6645") and len(attributes.end_year_6645)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.end_year_6645#"><cfelse>NULL</cfif>,
        IS_46486 = <cfif isdefined("attributes.LAW_NUMBERS") and listFind(attributes.LAW_NUMBERS,'46486')>1<cfelse>0</cfif>,
        IS_56486 = <cfif isdefined("attributes.LAW_NUMBERS") and listFind(attributes.LAW_NUMBERS,'56486')>1<cfelse>0</cfif>,
        IS_66486 = <cfif isdefined("attributes.LAW_NUMBERS") and listFind(attributes.LAW_NUMBERS,'66486')>1<cfelse>0</cfif>,
        IS_TAX_FREE_687 = <cfif isdefined("attributes.is_tax_free_687")>1<cfelse>0</cfif>,
		BENEFIT_MONTH_7103 = <cfif isdefined("attributes.benefit_month_7103") and len(attributes.benefit_month_7103)>#attributes.benefit_month_7103#<cfelse>NULL</cfif>,
		BENEFIT_DAY_7252 = <cfif isdefined("attributes.BENEFIT_DAY_7252") and len(attributes.BENEFIT_DAY_7252)>#attributes.BENEFIT_DAY_7252#<cfelse>NULL</cfif>,
		IN_OUT_STAGE = <cfif isdefined("attributes.process_stage") and len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>,
		DEFECTION_RATE = <cfif isdefined("attributes.defection_rate") and len(attributes.defection_rate)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.defection_rate#"><cfelse>NULL</cfif>,
		STARTDATE_7256 = <cfif isdefined("attributes.STARTDATE_7256") and len(attributes.STARTDATE_7256)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.STARTDATE_7256#"><cfelse>NULL</cfif>,
		FINISHDATE_7256 = <cfif isdefined("attributes.FINISHDATE_7256") and len(attributes.FINISHDATE_7256)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.FINISHDATE_7256#"><cfelse>NULL</cfif>,
		MONTHLY_AVERAGE_NET = <cfif isdefined("attributes.monthly_average_net_") and len(attributes.monthly_average_net_)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.monthly_average_net_#"><cfelse>0</cfif>,
		GRADE = <cfif isdefined("attributes.GRADE") and len(attributes.GRADE)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.GRADE#"><cfelse>NULL</cfif>,
		STEP = <cfif isdefined("attributes.STEP") and len(attributes.STEP)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.STEP#"><cfelse>NULL</cfif>,
		ADDITIONAL_SCORE = <cfif isdefined("attributes.ADDITIONAL_SCORE") and len(attributes.ADDITIONAL_SCORE)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.ADDITIONAL_SCORE#"><cfelse>NULL</cfif>,
		ADDITIONAL_SCORE_NORMAL = <cfif isdefined("attributes.ADDITIONAL_SCORE_NORMAL") and len(attributes.ADDITIONAL_SCORE_NORMAL)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.ADDITIONAL_SCORE_NORMAL#"><cfelse>NULL</cfif>,
		PERQUISITE_SCORE = <cfif isdefined("attributes.PERQUISITE_SCORE") and len(attributes.PERQUISITE_SCORE)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.PERQUISITE_SCORE#"><cfelse>NULL</cfif>,
		ADMINISTRATIVE_INDICATOR_SCORE = <cfif isdefined("attributes.administrative_compensation_indicator_score") and len(attributes.administrative_compensation_indicator_score)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.administrative_compensation_indicator_score#"><cfelse>NULL</cfif>,
		EXECUTIVE_INDICATOR_SCORE = <cfif isdefined("attributes.executive_compensation_indicator_score") and len(attributes.executive_compensation_indicator_score)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.executive_compensation_indicator_score#"><cfelse>NULL</cfif>,
		PRIVATE_SERVICE_SCORE = <cfif isdefined("attributes.PRIVATE_SERVICE_SCORE") and len(attributes.PRIVATE_SERVICE_SCORE)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.PRIVATE_SERVICE_SCORE#"><cfelse>NULL</cfif>,
		ADMINISTRATIVE_FUNCTION_ALLOWANCE = <cfif isdefined("attributes.ADMINISTRATIVE_FUNCTION_ALLOWANCE") and len(attributes.ADMINISTRATIVE_FUNCTION_ALLOWANCE)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.ADMINISTRATIVE_FUNCTION_ALLOWANCE#"><cfelse>NULL</cfif>,
		LANGUAGE_ALLOWANCE_1 = <cfif isdefined("attributes.LANGUAGE_ALLOWANCE_1") and len(attributes.LANGUAGE_ALLOWANCE_1)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.LANGUAGE_ALLOWANCE_1#"><cfelse>NULL</cfif>,
		LANGUAGE_ALLOWANCE_2 = <cfif isdefined("attributes.LANGUAGE_ALLOWANCE_2") and len(attributes.LANGUAGE_ALLOWANCE_2)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.LANGUAGE_ALLOWANCE_2#"><cfelse>NULL</cfif>,
		LANGUAGE_ALLOWANCE_3 = <cfif isdefined("attributes.LANGUAGE_ALLOWANCE_3") and len(attributes.LANGUAGE_ALLOWANCE_3)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.LANGUAGE_ALLOWANCE_3#"><cfelse>NULL</cfif>,
		LANGUAGE_ALLOWANCE_4 = <cfif isdefined("attributes.LANGUAGE_ALLOWANCE_4") and len(attributes.LANGUAGE_ALLOWANCE_4)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.LANGUAGE_ALLOWANCE_4#"><cfelse>NULL</cfif>,
		LANGUAGE_ALLOWANCE_5 = <cfif isdefined("attributes.LANGUAGE_ALLOWANCE_5") and len(attributes.LANGUAGE_ALLOWANCE_5)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.LANGUAGE_ALLOWANCE_5#"><cfelse>NULL</cfif>,
		LANGUAGE_ID_1 = <cfif isdefined("attributes.LANGUAGE_ID_1") and len(attributes.LANGUAGE_ID_1)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.LANGUAGE_ID_1#"><cfelse>NULL</cfif>,
		LANGUAGE_ID_2 = <cfif isdefined("attributes.LANGUAGE_ID_2") and len(attributes.LANGUAGE_ID_2)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.LANGUAGE_ID_2#"><cfelse>NULL</cfif>,
		LANGUAGE_ID_3 = <cfif isdefined("attributes.LANGUAGE_ID_3") and len(attributes.LANGUAGE_ID_3)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.LANGUAGE_ID_3#"><cfelse>NULL</cfif>,
		LANGUAGE_ID_4 = <cfif isdefined("attributes.LANGUAGE_ID_4") and len(attributes.LANGUAGE_ID_4)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.LANGUAGE_ID_4#"><cfelse>NULL</cfif>,
		LANGUAGE_ID_5 = <cfif isdefined("attributes.LANGUAGE_ID_5") and len(attributes.LANGUAGE_ID_5)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.LANGUAGE_ID_5#"><cfelse>NULL</cfif>,
		UNIVERSITY_ALLOWANCE = <cfif isdefined("attributes.UNIVERSITY_ALLOWANCE") and len(attributes.UNIVERSITY_ALLOWANCE)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.UNIVERSITY_ALLOWANCE#"><cfelse>NULL</cfif>,
		MINIMUM_COURSE_HOURS = <cfif isdefined("attributes.MINIMUM_COURSE_HOURS") and len(attributes.MINIMUM_COURSE_HOURS)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.MINIMUM_COURSE_HOURS#"><cfelse>NULL</cfif>,
		DIRECTOR_SHARE = <cfif isdefined("attributes.DIRECTOR_SHARE") and len(attributes.DIRECTOR_SHARE)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.DIRECTOR_SHARE#"><cfelse>NULL</cfif>,
		EMPLOYEE_SHARE = <cfif isdefined("attributes.EMPLOYEE_SHARE") and len(attributes.EMPLOYEE_SHARE)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.EMPLOYEE_SHARE#"><cfelse>NULL</cfif>,
		ACADEMIC_INCENTIVE_ALLOWANCE = <cfif isdefined("attributes.ACADEMIC_INCENTIVE_ALLOWANCE") and len(attributes.ACADEMIC_INCENTIVE_ALLOWANCE)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.ACADEMIC_INCENTIVE_ALLOWANCE#"><cfelse>NULL</cfif>,
		HIGH_EDUCATION_COMPENSATION = <cfif isdefined("attributes.HIGH_EDUCATION_COMPENSATION") and len(attributes.HIGH_EDUCATION_COMPENSATION)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.HIGH_EDUCATION_COMPENSATION#"><cfelse>NULL</cfif>,
		ADDITIONAL_COURSE_POSITION = <cfif isdefined("attributes.ADDITIONAL_COURSE_POSITION") and len(attributes.ADDITIONAL_COURSE_POSITION)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ADDITIONAL_COURSE_POSITION#"><cfelse>NULL</cfif>,
		STARTDATE_SHIFT = <cfif isdefined("attributes.STARTDATE_SHIFT") and len(attributes.STARTDATE_SHIFT)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.STARTDATE_SHIFT#"><cfelse>NULL</cfif>,
        FINISHDATE_SHIFT = <cfif isdefined("attributes.FINISHDATE_SHIFT") and len(attributes.FINISHDATE_SHIFT)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.FINISHDATE_SHIFT#"><cfelse>NULL</cfif>,
		REGISTRY_NO = <cfif isdefined("attributes.REGISTRY_NO") and len(attributes.REGISTRY_NO)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.REGISTRY_NO#"><cfelse>NULL</cfif>,
		RETIRED_REGISTRY_NO = <cfif isdefined("attributes.RETIRED_REGISTRY_NO") and len(attributes.RETIRED_REGISTRY_NO)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.RETIRED_REGISTRY_NO#"><cfelse>NULL</cfif>,
		ADDITIONAL_INDICATOR_COMPENSATION = <cfif isdefined("attributes.additional_indicator_compensation") and len(attributes.additional_indicator_compensation)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.additional_indicator_compensation#"><cfelse>NULL</cfif>,
		IS_EDUCATION_ALLOWANCE = <cfif isdefined("attributes.is_education_allowance") and len(attributes.is_education_allowance)><cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_education_allowance#"><cfelse>NULL</cfif>,
		GRADE_NORMAL = <cfif isdefined("attributes.GRADE_NORMAL") and len(attributes.GRADE_NORMAL)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.GRADE_NORMAL#"><cfelse>NULL</cfif>,
		STEP_NORMAL = <cfif isdefined("attributes.STEP_NORMAL") and len(attributes.STEP_NORMAL)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.STEP_NORMAL#"><cfelse>NULL</cfif>,
		WORK_DIFFICULTY = <cfif isdefined("attributes.work_difficulty") and len(attributes.work_difficulty)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.work_difficulty#"><cfelse>NULL</cfif>,
		BUSINESS_RISK_EMP = <cfif isdefined("attributes.business_risk_emp") and len(attributes.business_risk_emp)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.business_risk_emp#"><cfelse>NULL</cfif>,
		JUL_DIFFICULTIES = <cfif isdefined("attributes.jul_difficulties") and len(attributes.jul_difficulties)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.jul_difficulties#"><cfelse>NULL</cfif>,
		FINANCIAL_RESPONSIBILITY = <cfif isdefined("attributes.financial_responsibility") and len(attributes.financial_responsibility)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.financial_responsibility#"><cfelse>NULL</cfif>,
		SEVERANCE_PENSION_SCORE =  <cfif isdefined("attributes.severance_pension_score") and len(attributes.severance_pension_score)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.severance_pension_score#"><cfelse>NULL</cfif>,
		ADMINISTRATIVE_ACADEMIC = <cfif isdefined("attributes.administrative_academic") and len(attributes.administrative_academic)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.administrative_academic#"><cfelse>NULL</cfif>,
		IS_PENANCE_DEDUCTION = <cfif isdefined("attributes.is_penance_deduction") and len(attributes.is_penance_deduction)><cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_penance_deduction#"><cfelse>NULL</cfif>,
		IS_AUDIT_COMPENSATION = <cfif isdefined("attributes.is_audit_compensation") and len(attributes.is_audit_compensation)><cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_audit_compensation#"><cfelse>NULL</cfif>,
		AUDIT_COMPENSATION = <cfif isdefined("attributes.is_penance_deduction") and len(attributes.audit_compensation)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.audit_compensation#"><cfelse>NULL</cfif>,
		IS_SUSPENSION = <cfif isdefined("attributes.is_suspension") and len(attributes.is_suspension)><cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_suspension#"><cfelse>NULL</cfif>,
		SUSPENSION_STARTDATE = <cfif isdefined("attributes.suspension_startdate") and len(attributes.suspension_startdate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.suspension_startdate#"><cfelse>NULL</cfif>,
		SUSPENSION_FINISHDATE = <cfif isdefined("attributes.suspension_finishdate") and len(attributes.suspension_finishdate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.suspension_finishdate#"><cfelse>NULL</cfif>,
		IS_VETERAN = <cfif isdefined("attributes.is_veteran") and len(attributes.is_veteran)><cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_veteran#"><cfelse>NULL</cfif>,
		DEFECTION_STARTDATE = <cfif isdefined("attributes.defection_startdate") and len(attributes.defection_startdate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.defection_startdate#"><cfelse>NULL</cfif>,
		DEFECTION_FINISHDATE = <cfif isdefined("attributes.defection_finishdate") and len(attributes.defection_finishdate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.defection_finishdate#"><cfelse>NULL</cfif>,
		PAST_AGI_DAY = <cfif isdefined("attributes.PAST_AGI_DAY") and len(attributes.PAST_AGI_DAY)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.PAST_AGI_DAY#"><cfelse>NULL</cfif>,
		LAND_COMPENSATION_SCORE = <cfif isdefined("attributes.LAND_COMPENSATION_SCORE") and len(attributes.LAND_COMPENSATION_SCORE)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.LAND_COMPENSATION_SCORE#"><cfelse>NULL</cfif>,
		LAND_COMPENSATION_PERIOD = <cfif isdefined("attributes.LAND_COMPENSATION_PERIOD") and len(attributes.LAND_COMPENSATION_PERIOD)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.LAND_COMPENSATION_PERIOD#"><cfelse>NULL</cfif>,
		SERVICE_CLASS = <cfif isdefined("attributes.service_class") and len(attributes.service_class)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_class#"><cfelse>NULL</cfif>,
		SERVICE_TITLE = <cfif isdefined("attributes.service_title_id") and len(attributes.service_title_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_title_id#"><cfelse>NULL</cfif>,
		JURY_MEMBERSHIP = <cfif isdefined("attributes.JURY_MEMBERSHIP") and len(attributes.JURY_MEMBERSHIP)><cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.JURY_MEMBERSHIP#"><cfelse>NULL</cfif>,
        JURY_MEMBERSHIP_PERIOD = <cfif isdefined("attributes.JURY_MEMBERSHIP_PERIOD") and len(attributes.JURY_MEMBERSHIP_PERIOD)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.JURY_MEMBERSHIP_PERIOD#"><cfelse>NULL</cfif>,
		JURY_NUMBER = <cfif isdefined("attributes.JURY_NUMBER") and len(attributes.JURY_NUMBER)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.JURY_NUMBER#"><cfelse>NULL</cfif>,
		USE_MINIMUM_WAGE = <cfif isdefined("attributes.USE_MINIMUM_WAGE") and len(attributes.USE_MINIMUM_WAGE)><cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.USE_MINIMUM_WAGE#"><cfelse>NULL</cfif>
	WHERE
		IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
</cfquery>

<cfquery name="getEmpName" datasource="#dsn#">
	SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME AS EMPLOYEE FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
</cfquery>

<cfinclude template="../query/add_in_out_history.cfm">
<cf_workcube_process 
	is_upd='1' 
	data_source='#dsn#' 
	old_process_line='0'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#'
	record_date='#now()#' 
	action_table='EMPLOYEES_IN_OUT'
	action_column='IN_OUT_ID'
	action_id='#attributes.in_out_id#' 
	action_page='#request.self#?fuseaction=#fusebox.circuit#.list_salary&event=upd&in_out_id=#attributes.in_out_id#&empName=#UrlEncodedFormat("#getEmpName.EMPLOYEE#")#' 
	warning_description='Ücret Bilgileri : #getEmpName.EMPLOYEE#'>


<cfif isdefined("popup")>
	<script type="text/javascript">
		wrk_opener_reload();
		self.close();
	</script>
<cfelse>
	<cflocation url="#request.self#?fuseaction=ehesap.list_salary&event=upd&in_out_id=#attributes.in_out_id#&empName=#UrlEncodedFormat('#getEmpName.EMPLOYEE#')#" addtoken="No">
</cfif>