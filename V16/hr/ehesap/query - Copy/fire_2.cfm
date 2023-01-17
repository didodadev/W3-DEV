<cf_date tarih="attributes.finishdate">

<cfif isdefined("attributes.ihbardate") and len(attributes.ihbardate)>
	<cf_date tarih="attributes.ihbardate">
</cfif>

<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
	<cf_date tarih="attributes.startdate">
</cfif>

<cfif isdefined("attributes.kidem_baz") and len(attributes.kidem_baz)>
	<cf_date tarih="attributes.kidem_baz">
</cfif>

<cfset total_ssk_days = 0>
<cfset total_deneme_days = 0>
<cfset kidem_dahil_odenek = 0>

<cfif isdefined("attributes.ihbardate") and len(attributes.ihbardate)>
	<cfset attributes.sal_mon = month(attributes.ihbardate)>
<cfelse>
	<cfset attributes.sal_mon = month(attributes.finishdate)>
</cfif>

<cfquery name="get_hr_ssk_1" datasource="#dsn#">
	SELECT
		B.SSK_NO,
		B.SSK_OFFICE,
		EMPLOYEES.KIDEM_DATE,
		EMPLOYEES.EMPLOYEE_NO,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES.TASK,
		EMPLOYEES_IN_OUT.USE_SSK,
		EMPLOYEES_IN_OUT.USE_TAX,
		EMPLOYEES_IN_OUT.SALARY_TYPE,
		EMPLOYEES_IN_OUT.SURELI_IS_AKDI,
		EMPLOYEES_IN_OUT.SURELI_IS_FINISHDATE,
		EMPLOYEES_IN_OUT.SABIT_PRIM,
		EMPLOYEES_IN_OUT.SSK_STATUTE,
		EMPLOYEES_IN_OUT.START_DATE AS STARTDATE,
		EMPLOYEES_IN_OUT.FINISH_DATE AS FINISHDATE,
		EMPLOYEES_IN_OUT.DEFECTION_LEVEL,
		EMPLOYEES_IN_OUT.SOCIALSECURITY_NO,
		EMPLOYEES_IN_OUT.TRADE_UNION_DEDUCTION,
		EMPLOYEES_IN_OUT.PUANTAJ_GROUP_IDS,
		EMPLOYEES_IN_OUT.BRANCH_ID
	FROM
		EMPLOYEES,
		EMPLOYEES_IN_OUT,
		BRANCH B
	WHERE
		B.BRANCH_ID = EMPLOYEES_IN_OUT.BRANCH_ID AND
		EMPLOYEES_IN_OUT.IN_OUT_ID = #attributes.IN_OUT_ID#
		AND EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID
		AND EMPLOYEES_IN_OUT.FINISH_DATE IS NULL
</cfquery>

<cfset this_ssk_no_ = get_hr_ssk_1.SSK_NO>
<cfset this_ssk_office_ = get_hr_ssk_1.SSK_OFFICE>

<cfif isdefined("attributes.is_kidem_baz")>
	<cfset cikis_start_date = attributes.kidem_baz>
<cfelse>
	<cfset cikis_start_date = attributes.STARTDATE>
</cfif>



<!--- silmeyin EK 20030815 --->
<cfquery name="GET_SUM_LAST_12_MONTHS" datasource="#dsn#" maxrows="12">
	SELECT
		AVG((EMPLOYEES_PUANTAJ_ROWS.TOTAL_SALARY/EMPLOYEES_PUANTAJ_ROWS.TOTAL_DAYS)*30) AS TOPLAM_KAZANC,
		COUNT(EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID) AS TOPLAM_AY,
		AVG(EMPLOYEES_PUANTAJ_ROWS.DAMGA_VERGISI) AS TOPLAM_DAMGA,
		AVG(EMPLOYEES_PUANTAJ_ROWS.GELIR_VERGISI) AS TOPLAM_GELIR
	FROM
		EMPLOYEES_PUANTAJ_ROWS,
		EMPLOYEES_PUANTAJ
	WHERE
		EMPLOYEES_PUANTAJ.SSK_OFFICE = '#this_ssk_office_#' AND
		EMPLOYEES_PUANTAJ.SSK_OFFICE_NO = '#this_ssk_no_#' AND
		EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND
		EMPLOYEES_PUANTAJ_ROWS.TOTAL_DAYS > 0 AND		
		EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID AND
		(
			(
		<cfif isdefined("attributes.ihbardate") and len(attributes.ihbardate)>
			EMPLOYEES_PUANTAJ.SAL_YEAR = #YEAR(attributes.ihbardate)#
			AND
			EMPLOYEES_PUANTAJ.SAL_MON <= #MONTH(attributes.ihbardate)#
		<cfelse>
			EMPLOYEES_PUANTAJ.SAL_YEAR = #YEAR(attributes.FINISHDATE)#
			AND
			EMPLOYEES_PUANTAJ.SAL_MON <= #MONTH(attributes.FINISHDATE)#
		</cfif>
			)
			OR
			(
			EMPLOYEES_PUANTAJ.SAL_YEAR = #YEAR(cikis_start_date)#
			AND
			EMPLOYEES_PUANTAJ.SAL_MON >= #MONTH(cikis_start_date)#
			)
		)
	GROUP BY EMPLOYEES_PUANTAJ.SAL_YEAR,EMPLOYEES_PUANTAJ.SAL_MON
	ORDER BY EMPLOYEES_PUANTAJ.SAL_YEAR DESC,EMPLOYEES_PUANTAJ.SAL_MON DESC
</cfquery>



<cfif not get_hr_ssk_1.recordcount>
	<cfoutput>
		<script type="text/javascript">
			alert("#attributes.employee_id# <cf_get_lang no ='1210.numaralı çalışan için Maaş ve/veya SSK ve/veya İşe Giriş Bilgileri Eksik'>  !");
			history.back();
		</script>
	</cfoutput>
	<cfabort>
</cfif>
 
<cfif datediff("d",attributes.finishdate,cikis_start_date) gt 0>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1211.Çıkış Tarihi Giriş Tarihinden Önce Olamaz'> !");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfif isdefined("attributes.is_kidem_baz")>
	<cfif isdefined("attributes.ihbardate") and len(attributes.ihbardate) and datediff("d",attributes.ihbardate,attributes.kidem_baz) gt 0>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1214.İhbar Tarihi Kıdem Baz Tarihinden Önce Olamaz'> !");
			history.back();
		</script>
		<cfabort>
	</cfif>
<cfelse>
	<cfif isdefined("attributes.ihbardate") and len(attributes.ihbardate) and datediff("d",attributes.ihbardate,get_hr_ssk_1.STARTDATE) gt 0>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1212.İhbar Tarihi Giriş Tarihinden Önce Olamaz'> !");
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>

<cfif isdefined("attributes.ihbardate") and len(attributes.ihbardate) and datediff("d",attributes.finishdate,attributes.ihbardate) gt 0>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1213.Çıkış Tarihi İhbar Tarihinden Önce Olamaz'> !");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfquery name="get_emp_offtimes" datasource="#dsn#">
	SELECT
		<cfif database_type is "MSSQL">
		SUM(DATEDIFF(DAY, OFFTIME.STARTDATE, OFFTIME.FINISHDATE)) AS TOPLAM_GUN
		<cfelseif database_type is "DB2">
		SUM(DAY(OFFTIME.FINISHDATE) - DAY(OFFTIME.STARTDATE)) AS TOPLAM_GUN
		</cfif>
	FROM
		OFFTIME,
		SETUP_OFFTIME
	WHERE
	(
	(OFFTIME.STARTDATE >= #CREATEODBCDATETIME(cikis_start_date)# AND OFFTIME.STARTDATE <= #CREATEODBCDATETIME(attributes.finishdate)#) OR
	(OFFTIME.FINISHDATE >= #CREATEODBCDATETIME(cikis_start_date)# AND OFFTIME.STARTDATE <= #CREATEODBCDATETIME(attributes.finishdate)#)
	) AND	
	OFFTIME.EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND
	OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID AND
	OFFTIME.VALID = 1 AND
	OFFTIME.IS_PUANTAJ_OFF = 0 AND
	SETUP_OFFTIME.IS_PAID = 0
</cfquery>

<cfquery name="get_days" datasource="#dsn#">
	SELECT 
		SUM(TOTAL_DAYS) AS TOPLAM_GUN
	FROM
		EMPLOYEES_PUANTAJ_ROWS
	WHERE 
		EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
</cfquery>



<cfscript>
if (isdefined("attributes.ihbardate") and len(attributes.ihbardate))
	total_ssk_days = datediff("d",cikis_start_date,attributes.ihbardate);
else
	total_ssk_days = datediff("d",cikis_start_date,attributes.finishdate);
	
if(total_ssk_days eq 0 and datediff("d",attributes.finishdate,cikis_start_date) eq 0)
	total_ssk_days = 1;

if (isnumeric(get_emp_offtimes.TOPLAM_GUN))
	toplam_izin = get_emp_offtimes.TOPLAM_GUN;
else
	toplam_izin = 0;
	
total_ssk_days = total_ssk_days - toplam_izin;
total_ssk_years = fix(total_ssk_days / 365);
total_ssk_months = fix((total_ssk_days - (total_ssk_years * 365)) / 30);
total_ssk_days_2 = total_ssk_days - (total_ssk_years * 365) - (total_ssk_months * 30);

if ((total_ssk_years lt 1) OR (get_hr_ssk_1.SALARY_TYPE NEQ 2) or (not isdefined("kidem_hesap")) )
	no_kidem = 1; // kıdem yok
else
	no_kidem = 0; // kidem hesaplanacak

//writeoutput('<br/><br/>#no_kidem#');

if (not isdefined("ihbar_hesap") or get_hr_ssk_1.SURELI_IS_AKDI EQ 1 or not len(attributes.ihbardate))
	no_ihbar = 1;
else
	no_ihbar = 0;
</cfscript>
<cfquery name="get_emp_yillik_izins" datasource="#dsn#">
	SELECT
		<cfif database_type is "MSSQL">
		SUM(DATEDIFF(DAY, OFFTIME.STARTDATE, OFFTIME.FINISHDATE)) AS TOPLAM_GUN
		<cfelseif database_type is "DB2">
		SUM(DAYS(OFFTIME.FINISHDATE) - DAYS(OFFTIME.STARTDATE)) AS TOPLAM_GUN
		</cfif>
	FROM
		OFFTIME,
		SETUP_OFFTIME
	WHERE
		OFFTIME.EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND
		OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID AND
		OFFTIME.VALID = 1 AND
		OFFTIME.IS_PUANTAJ_OFF = 0 AND
		SETUP_OFFTIME.IS_PAID = 1 AND
		SETUP_OFFTIME.IS_YEARLY = 1
</cfquery>
<cfquery name="get_offtime_limits" datasource="#dsn#">
	SELECT 
        LIMIT_1, 
        LIMIT_1_DAYS, 
        LIMIT_2, 
        LIMIT_2_DAYS, 
        LIMIT_3, 
        LIMIT_3_DAYS, 
        LIMIT_4, 
        LIMIT_4_DAYS, 
		LIMIT_5, 
        LIMIT_5_DAYS,
        MIN_YEARS, 
        MAX_YEARS, 
        MIN_MAX_DAYS, 
        STARTDATE, 
        FINISHDATE, 
        SATURDAY_ON 
    FROM 
    	SETUP_OFFTIME_LIMIT 
    WHERE 
	    STARTDATE <= #now()# 
    AND 
    	FINISHDATE >= #ATTRIBUTES.FINISHDATE#
</cfquery>
<cfif not get_offtime_limits.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1215.Girilen Tarihlerde İzin Limitleri Girilmemiş'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfquery name="get_emp_in_outs" datasource="#dsn#">
	SELECT
		IN_OUT_ID, 
        BRANCH_ID, 
        EMPLOYEE_ID, 
        START_DATE, 
        FINISH_DATE, 
        IHBAR_DATE, 
        VALIDATOR_POSITION_CODE, 
        VALID, 
        DETAIL, 
        SALARY, 
        IHBAR_DAYS, 
        IHBAR_AMOUNT, 
        KIDEM_AMOUNT, 
        TOTAL_DENEME_DAYS, 
        TOTAL_SSK_DAYS, 
        TOTAL_SSK_MONTHS, 
        EXPLANATION_ID, 
        SOCIALSECURITY_NO, 
        GROSS_NET, 
        SALARY_TYPE, 
        SABIT_PRIM, 
        USE_TAX, 
        TRADE_UNION, 
        TRADE_UNION_DEDUCTION, 
        SSK_STATUTE,
        DEFECTION_LEVEL, 
        SURELI_IS_AKDI, 
        SURELI_IS_FINISHDATE, 
        POSITION_CODE, 
        IS_PUANTAJ_OFF, 
        GROSS_COUNT_TYPE, 
        IS_EMPTY_POSITION
	FROM
		EMPLOYEES_IN_OUT
	WHERE
		EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
		AND
		TOTAL_SSK_DAYS <> 0
		AND
		TOTAL_SSK_DAYS IS NOT NULL
</cfquery>

<cfquery name="get_emp_birth" datasource="#dsn#">
	SELECT
		BIRTH_DATE
	FROM
		EMPLOYEES_IDENTY
	WHERE
		EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
</cfquery>

<cfif not no_kidem>
	<cfquery name="get_emp_kidem_dahil_odeneks" datasource="#dsn#">
		SELECT
			EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID,
			EMPLOYEES_PUANTAJ_ROWS.SALARY,
			EMPLOYEES_PUANTAJ_ROWS_EXT.AMOUNT,
			EMPLOYEES_PUANTAJ_ROWS_EXT.AMOUNT_2,
			EMPLOYEES_PUANTAJ.SAL_MON,
			EMPLOYEES_PUANTAJ.SAL_YEAR,
			EMPLOYEES_PUANTAJ.SSK_OFFICE,
			EMPLOYEES_PUANTAJ.SSK_OFFICE_NO,
			EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID,
			EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID
		FROM
			EMPLOYEES_PUANTAJ_ROWS_EXT,
			EMPLOYEES_PUANTAJ_ROWS,
			EMPLOYEES_PUANTAJ
		WHERE
			EMPLOYEES_PUANTAJ.SSK_OFFICE = '#this_ssk_office_#' AND
			EMPLOYEES_PUANTAJ.SSK_OFFICE_NO = '#this_ssk_no_#' AND
			EMPLOYEES_PUANTAJ.PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID
			AND EMPLOYEES_PUANTAJ.PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS_EXT.PUANTAJ_ID
			AND EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
			AND EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS_EXT.EMPLOYEE_PUANTAJ_ID
			AND EMPLOYEES_PUANTAJ_ROWS_EXT.IS_KIDEM = 1
			AND EMPLOYEES_PUANTAJ_ROWS_EXT.EXT_TYPE = 0
			AND ISNULL(EMPLOYEES_PUANTAJ_ROWS_EXT.IS_INCOME,0) = 0
			AND
			(
				(
			<cfif isdefined("attributes.ihbardate") and len(attributes.ihbardate)>
				EMPLOYEES_PUANTAJ.SAL_YEAR = #YEAR(attributes.ihbardate)#
				AND EMPLOYEES_PUANTAJ.SAL_MON <= #MONTH(attributes.ihbardate)#
			<cfelse>
				EMPLOYEES_PUANTAJ.SAL_YEAR = #YEAR(attributes.FINISHDATE)#
				AND EMPLOYEES_PUANTAJ.SAL_MON <= #MONTH(attributes.FINISHDATE)#
			</cfif>
				)
				OR
				(
				EMPLOYEES_PUANTAJ.SAL_YEAR = #YEAR(cikis_start_date)#
				AND EMPLOYEES_PUANTAJ.SAL_MON >= #MONTH(cikis_start_date)#
				)
			)
		ORDER BY
			EMPLOYEES_PUANTAJ.SAL_YEAR DESC,
			EMPLOYEES_PUANTAJ.SAL_MON DESC
	</cfquery>

	<!--- kıdem toplamı gün yüzde dikkate alınarak toplanacak ortalaması alınacak --->
	<cfset TEMP_AVG = 0>
	<cfoutput query="get_emp_kidem_dahil_odeneks">
		<cfif AMOUNT_2 EQ 0><!--- ARTI --->
			<cfset TEMP_AVG = TEMP_AVG + AMOUNT>
		<cfelse><!--- YÜZDE --->
			<cfset TEMP_AVG = TEMP_AVG + AMOUNT_2>
		</cfif>
	</cfoutput>
	<cfset kidem_dahil_odenek = TEMP_AVG / 12>
</cfif>
<cfset attributes.sal_year = session.ep.period_year>
<cfset attributes.group_id = "">
<cfif len(get_hr_ssk_1.puantaj_group_ids)>
	<cfset attributes.group_id = "#get_hr_ssk_1.PUANTAJ_GROUP_IDS#,">
</cfif>
<cfset attributes.branch_id = get_hr_ssk_1.branch_id>
<cfset not_kontrol_parameter = 1>
<cfinclude template="../query/get_program_parameter.cfm">
<cfquery name="get_seniority_comp_max" datasource="#dsn#">
	SELECT ISNULL(SENIORITY_COMPANSATION_MAX,0) AS SENIORITY_COMPANSATION_MAX FROM INSURANCE_PAYMENT WHERE STARTDATE <= #parameter_last_month_1#  AND FINISHDATE >= #parameter_last_month_30#
</cfquery>


<cfscript>
paid_kidem_days = 0;
paid_ihbar_days = 0;
ihbar_days = 0;
baz_ucret = 0;
hakkedilen_izin = 0;
last_limit_days = 0;
ihbar_amount = 0;
kidem_amount = 0;
kidem_max = get_seniority_comp_max.seniority_compansation_max;
kullanilan_yillik_izin = 0;
yillik_izin_amount = 0;

		
if(GET_SUM_LAST_12_MONTHS.RECORDCOUNT and len(GET_SUM_LAST_12_MONTHS.TOPLAM_KAZANC))
	{
	salary = GET_SUM_LAST_12_MONTHS.TOPLAM_KAZANC;
	daily_salary = GET_SUM_LAST_12_MONTHS.TOPLAM_KAZANC / 30;
	}
else
	{
	salary = 0;
	daily_salary = 0;
	}
if(GET_SUM_LAST_12_MONTHS.RECORDCOUNT)
	{
		toplam_damga_12_aylik = GET_SUM_LAST_12_MONTHS.TOPLAM_DAMGA;
		toplam_gelir_12_aylik = GET_SUM_LAST_12_MONTHS.TOPLAM_GELIR;
	}
else
	{
		toplam_damga_12_aylik = 0;
		toplam_gelir_12_aylik = 0;
	}


//if (get_hr_ssk_1.sabit_prim eq 1) // primli çalışan
	//{
	//if ( isnumeric(GET_SUM_LAST_12_MONTHS.TOPLAM_KAZANC) )
	//	baz_ucret = GET_SUM_LAST_12_MONTHS.TOPLAM_KAZANC;
	//}
//else // sabit ücretli çalışan   
	//{
	baz_ucret = salary + kidem_dahil_odenek;
	//}


daily_baz = baz_ucret / 30;

for (k=1; k lte get_emp_in_outs.recordcount;k = k+1)
	{
	if (get_emp_in_outs.ihbar_amount[k] gt 0) paid_ihbar_days = paid_ihbar_days + get_emp_in_outs.TOTAL_SSK_DAYS[k];
	if (get_emp_in_outs.KIDEM_AMOUNT[k] gt 0) paid_kidem_days = paid_kidem_days + get_emp_in_outs.TOTAL_SSK_DAYS[k];
	}

if (not no_ihbar)
	{
	ihbar_fark_ = datediff("d",attributes.ihbardate,attributes.finishdate);	

	if (((total_ssk_days-paid_ihbar_days) gt get_program_parameters.DENUNCIATION_1_LOW) AND ((total_ssk_days-paid_ihbar_days) lte get_program_parameters.DENUNCIATION_1_HIGH))
		ihbar_days = get_program_parameters.DENUNCIATION_1;
	else if (((total_ssk_days-paid_ihbar_days) gt get_program_parameters.DENUNCIATION_2_LOW) AND ((total_ssk_days-paid_ihbar_days) lte get_program_parameters.DENUNCIATION_2_HIGH))
		ihbar_days = get_program_parameters.DENUNCIATION_2;
	else if (((total_ssk_days-paid_ihbar_days) gt get_program_parameters.DENUNCIATION_3_LOW) AND ((total_ssk_days-paid_ihbar_days) lte get_program_parameters.DENUNCIATION_3_HIGH))
		ihbar_days = get_program_parameters.DENUNCIATION_3;
	else if (((total_ssk_days-paid_ihbar_days) gt get_program_parameters.DENUNCIATION_4_LOW) AND ((total_ssk_days-paid_ihbar_days) lte get_program_parameters.DENUNCIATION_4_HIGH))
		ihbar_days = get_program_parameters.DENUNCIATION_4;
	if(ihbar_fark_ gte ihbar_days)
		{
		ihbar_amount = 0;
		}
	else
		{
		ihbar_amount = daily_baz * ihbar_days;
		}
	//ihbar_amount = ihbar_amount - (toplam_gelir_12_aylik + toplam_damga_12_aylik);
	}

if ( not no_kidem )
	{
	if (kidem_max lte baz_ucret)
		{
		kidem_amount = (kidem_max * (total_ssk_days-paid_kidem_days)) / 365;
		}
	else
		kidem_amount = (baz_ucret * (total_ssk_days-paid_kidem_days)) / 365;
	}
//damga vergisi cikartilmaz kidem_amount = kidem_amount - toplam_damga_12_aylik;

// hakedilen yıllık izin gün
for (i = 1; i lte total_ssk_years;i = i +1)
	{
	if (i lt get_offtime_limits.LIMIT_1)
		hakkedilen_izin = hakkedilen_izin + get_offtime_limits.LIMIT_1_days;
	else if (i lt get_offtime_limits.LIMIT_2)
		hakkedilen_izin = hakkedilen_izin + get_offtime_limits.LIMIT_2_days;
	else if (i lt get_offtime_limits.LIMIT_3)
		hakkedilen_izin = hakkedilen_izin + get_offtime_limits.LIMIT_3_days;
	else if (i lt get_offtime_limits.LIMIT_4)
		hakkedilen_izin = hakkedilen_izin + get_offtime_limits.LIMIT_4_days;
	else if (i lt get_offtime_limits.LIMIT_5)
		hakkedilen_izin = hakkedilen_izin + get_offtime_limits.LIMIT_5_days;
	// 2003 yılı öncesinde izin hakları 2 gün az
	if ((year(now())-i+1 ) lt 2003) hakkedilen_izin = hakkedilen_izin - 2;
	}

if (get_emp_birth.recordcount and (len(get_emp_birth.birth_date)))
	{
	yas = datediff("yyyy", get_emp_birth.birth_date, attributes.finishdate);
	if (yas lt get_offtime_limits.MIN_YEARS) // 18 yaşından küçükse
		{
		hakkedilen_izin = total_ssk_years * get_offtime_limits.MIN_MAX_DAYS;
		}
	else if (yas gte get_offtime_limits.MAX_YEARS) // 50 yaşından büyükse
		{
		// 50 yaş üstü için sabit 20 gün hakkı
		hakkedilen_izin = (yas - get_offtime_limits.MAX_YEARS) * get_offtime_limits.MIN_MAX_DAYS;
		// 2003 öncesi farkları çıkarılır
		if ( (year(now()) - yas + get_offtime_limits.MAX_YEARS) lt 2003 )
			hakkedilen_izin = hakkedilen_izin - ( (2003 - (year(now()) - yas + get_offtime_limits.MAX_YEARS)) * 2);
		// 50 yaş altı hesabı
		first_izin_years = total_ssk_years - (yas - get_offtime_limits.MAX_YEARS);
		if (get_offtime_limits.MIN_MAX_DAYS gt last_limit_days) 
			// 50 {get_offtime_limits.MAX_YEARS} yaşdan dolayı fazla olacaklar eklenir erk 20030904
			for (i = 1; i lte first_izin_years;i = i +1)
				{
				if (i lt get_offtime_limits.LIMIT_1)
					hakkedilen_izin = hakkedilen_izin + get_offtime_limits.LIMIT_1_days;
				else if (i lt get_offtime_limits.LIMIT_2)
					hakkedilen_izin = hakkedilen_izin + get_offtime_limits.LIMIT_2_days;
				else if (i lt get_offtime_limits.LIMIT_3)
					hakkedilen_izin = hakkedilen_izin + get_offtime_limits.LIMIT_3_days;
				else if (i lt get_offtime_limits.LIMIT_4)
					hakkedilen_izin = hakkedilen_izin + get_offtime_limits.LIMIT_4_days;
				else if (i lt get_offtime_limits.LIMIT_5)
					hakkedilen_izin = hakkedilen_izin + get_offtime_limits.LIMIT_5_days;
				// 2003 yılı öncesinde izin hakları 2 gün az
				if (year(now()-i) lt 2003) hakkedilen_izin = hakkedilen_izin - 2;
				}
		}
	}

if (len(get_emp_yillik_izins.toplam_gun))
	kullanilan_yillik_izin = get_emp_yillik_izins.toplam_gun;

yillik_izin_amount = daily_salary * (hakkedilen_izin - kullanilan_yillik_izin);
</cfscript>


<cfform name="fire_2" action="#request.self#?fuseaction=ehesap.emptypopup_fire" method="post"  onsubmit="return (UnformatFields());">
<input type="hidden" name="in_out_id" id="in_out_id" value="<cfoutput>#attributes.in_out_id#</cfoutput>">
<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
<input type="hidden" name="startdate" id="startdate" value="<cfoutput>#dateformat(attributes.startdate,dateformat_style)#</cfoutput>">
<input type="hidden" name="kidem_baz" id="kidem_baz" value="<cfoutput>#dateformat(attributes.kidem_baz,dateformat_style)#</cfoutput>">
<input type="hidden" name="finishdate" id="finishdate" value="<cfoutput>#dateformat(attributes.finishdate,dateformat_style)#</cfoutput>">
<input type="hidden" name="fire_detail" id="fire_detail" value="<cfoutput>#fire_detail#</cfoutput>">
<input type="hidden" name="ihbardate" id="ihbardate" value="<cfoutput>#ihbardate#</cfoutput>">
<input type="hidden" name="explanation_id" id="explanation_id" value="<cfoutput>#attributes.explanation_id#</cfoutput>">
<input type="hidden" name="reason_id" id="reason_id" value="<cfoutput>#attributes.reason_id#</cfoutput>">
        <table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%" class="color-border">
          <tr class="color-list">
            <td class="headbold" height="35">&nbsp;&nbsp;<cf_get_lang no='47.İşten Çıkarma'></td>
          </tr>
          <tr class="color-row">
            <td valign="top">
              <table border="0">
                <tr>
                  <td width="6"></td>
                  <td><cf_get_lang no='50.Toplam Çalıştığı Gün'></td>
                  <td>
                    <cfinput type="text" name="total_ssk_days" value="#total_ssk_days#" validate="integer" onchange="re_calc();">
                  </td>
                  <td><cf_get_lang_main no='164.Çalışan'></td>
                  <td><cfoutput>#form.employee#</cfoutput></td>
                </tr>
                <tr>
                  <td height="23"></td>
                  <td width="259"><cf_get_lang_main no='1043.Yıl'></td>
                  <td width="237">
                    <cfinput type="text" name="total_ssk_years" value="#total_ssk_years#" validate="integer" readonly="yes">
                  </td>
                  <td><cf_get_lang_main no='216.Giriş Tarihi'></td>
                  <td><cfoutput>#dateformat(cikis_start_date,dateformat_style)#</cfoutput></td>
                </tr>
                <tr>
                  <td></td>
                  <td width="259"><cf_get_lang_main no='1312.Ay'></td>
                  <td width="237">
                    <cfinput type="text" name="total_ssk_months" value="#total_ssk_months#" validate="integer" readonly="yes">
                  </td>
                  <td width="180"><cf_get_lang no ='696.İhbar Edilen Çıkış T'></td>
                  <td><cfoutput>#form.finishdate#</cfoutput></td>
                </tr>
                <tr>
                  <td></td>
                  <td width="259"><cf_get_lang_main no='78.Gün'></td>
                  <td width="237"><cfinput type="text" name="total_ssk_days_2" value="#total_ssk_days_2#" validate="integer" readonly="yes">
                  </td>
                  <td><cf_get_lang no ='698.İhbar Bildirim T'></td>
                  <td><cfoutput>#form.ihbardate#</cfoutput></td>
                </tr>
                <tr>
                  <td></td>
                  <td><cf_get_lang no='55.Deneme Süresi Gün'></td>
                  <td>
                    <cfsavecontent variable="message"><cf_get_lang no='440.Deneme Süresi gün girmelisiniz'></cfsavecontent>
                    <cfinput type="text" name="total_deneme_days" value="#total_deneme_days#" required="yes" message="#message#" validate="integer" onchange="re_calc();">
                  </td>
                  <td><cf_get_lang no='439.Tazminat Matrahı'></td>
                  <td>
                    <cfinput value="#TLFormat(baz_ucret)#" type="text" name="baz_ucret" style="width:150px;" onchange="re_calc();">
                  </td>
                </tr>
                <tr>
                  <td></td>
                  <td><cf_get_lang no='441.Toplam Yıllık İzin Hakkı'></td>
                  <td><cfinput type="text" name="hakkedilen_izin" value="#hakkedilen_izin#" required="yes" message="Toplam Yıllık İzin Hakkı !" validate="integer" readonly="yes">&nbsp;</td>
                  <td><cf_get_lang no='48.Aylık Maaş'></td>
                  <td><cfsavecontent variable="message"><cf_get_lang no='289.Aylık Maaş girmelisiniz'></cfsavecontent>
                      <cfinput value="#TLFormat(salary)#" message="#message#" type="text" name="salary" style="width:150px;" readonly="yes">
                  </td>
                </tr>
                <tr>
                  <td></td>
                  <td><cf_get_lang no='442.Kullanmadığı Yıllık İzinler'></td>
                  <td><cfinput type="text" name="kullanilmayan_yillik_izin" value="#hakkedilen_izin-kullanilan_yillik_izin#" required="yes" message="Kullanmadığı Yıllık İzinler" validate="integer" onchange="re_calc();">&nbsp;</td>
                  <td><cf_get_lang no='45.Kıdem Tazminatı'></td>
                  <td>
                    <cfif isdefined("kidem_hesap")>
                      <cfsavecontent variable="message"><cf_get_lang no='443.Kıdem Tazminatı girmelisiniz'></cfsavecontent>
                      <cfinput value="#wrk_round(kidem_amount)#" required="Yes" message="#message#" type="text" name="kidem_amount" style="width:150px;">
                      <cfelse>
                      <input type="hidden" name="kidem_amount" id="kidem_amount" value="0">
    					0
                    </cfif>
                  </td>
                </tr>
                <tr>
                  <td></td>
                  <td><cf_get_lang no='51.Toplam İhbar Gün'></td>
                  <td>
                    <cfif isdefined("attributes.ihbar_hesap") and (not no_ihbar)>
                      <cfsavecontent variable="message"><cf_get_lang no='444.Toplam İhbar gün girmelisiniz'></cfsavecontent>
                      <cfinput type="text" name="ihbar_days" value="#ihbar_days#" required="yes" message="#message#" validate="integer" onchange="re_calc();">
                      <cfelse>
                      <input type="hidden" name="ihbar_days" id="ihbar_days" value="0">0
                    </cfif>
                  </td>
                  <td><cf_get_lang no='46.İhbar Tazminatı'></td>
                  <td>
                    <cfif isdefined("ihbar_hesap") and (not no_ihbar)>
                      <cfsavecontent variable="message"><cf_get_lang no='446.İhbar Tazminatı girmelisiniz'></cfsavecontent>
                      <cfinput value="#wrk_round(ihbar_amount)#" required="Yes" message="#message#" type="text" name="ihbar_amount" style="width:150px;">
                      <cfelse>
                      <input type="hidden" name="ihbar_amount" id="ihbar_amount" value="0">
    					0
                    </cfif>
                  </td>
                </tr>
                <tr>
                  <td></td>
                  <td><cf_get_lang no='445.Ödenmiş İhbar Gün'></td>
                  <td><cfoutput>#paid_ihbar_days#</cfoutput>&nbsp;</td>
                  <td><cf_get_lang no='447.Yıllık İzin Tutarı'></td>
                  <td><cfinput type="text" name="yillik_izin_amount" value="#wrk_round(yillik_izin_amount)#" required="yes" message="Yıllık İzin Tutarı !" onchange="re_calc();"  style="width:150px;">
                  </td>
                </tr>
                <tr>
                  <td></td>
                  <td><cf_get_lang no='448.Ödenmiş Kıdem Gün'></td>
                  <td><cfoutput>#paid_kidem_days#</cfoutput>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td></td>
                  <td width="259">&nbsp;</td>
                  <td width="237">&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td></td>
                  <td><cf_get_lang_main no='88.Onay'></td>
                  <td>
                    <input type="hidden" name="VALIDATOR_POSITION_CODE" id="VALIDATOR_POSITION_CODE" value="">
					<cfsavecontent variable="message"><cf_get_lang no='449.onay verecek kişi girmelisiniz'></cfsavecontent>
                    <cfinput type="text" name="employee" value="" style="width:125px;" required="yes" message="#message#" readonly="yes">
                    <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_positions&field_code=fire_2.VALIDATOR_POSITION_CODE&field_emp_name=fire_2.employee</cfoutput>','list');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a> 
				  </td>
				  <td><cf_get_lang no ='701.Uyarılacak Kişi'></td>
				  <td>
                    <input type="hidden" name="warning_employee_id" id="warning_employee_id" value="">
                    <cfinput type="text" name="warning_employee" value="" style="width:125px;" readonly="yes">
                    <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_positions&field_emp_id=fire_2.warning_employee_id&field_emp_name=fire_2.warning_employee</cfoutput>&select_list=1','list');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a> 
				  </td>
                </tr>
                <tr>
					<cfsavecontent variable="employee"><cf_get_lang_main no ='123.Çalışan İşten Çıkarıyorsunuz! Bu işlemi geri alamazsınız'></cfsavecontent>
					<td style="text-align:right;" height="35" colspan="5"> <cf_workcube_buttons is_upd="0"> </td>
			    </tr>
              </table>
            </td>
          </tr>
        </table>
</cfform>
<script type="text/javascript">
/* sabitler*/
ihbar_alt_sinir_1 = <cfoutput>#get_program_parameters.DENUNCIATION_1_LOW#</cfoutput>;
ihbar_alt_sinir_2 = <cfoutput>#get_program_parameters.DENUNCIATION_2_LOW#</cfoutput>;
ihbar_alt_sinir_3 = <cfoutput>#get_program_parameters.DENUNCIATION_3_LOW#</cfoutput>;
ihbar_alt_sinir_4 = <cfoutput>#get_program_parameters.DENUNCIATION_4_LOW#</cfoutput>;
ihbar_ust_sinir_1 = <cfoutput>#get_program_parameters.DENUNCIATION_1_HIGH#</cfoutput>;
ihbar_ust_sinir_2 = <cfoutput>#get_program_parameters.DENUNCIATION_2_HIGH#</cfoutput>;
ihbar_ust_sinir_3 = <cfoutput>#get_program_parameters.DENUNCIATION_3_HIGH#</cfoutput>;
ihbar_ust_sinir_4 = <cfoutput>#get_program_parameters.DENUNCIATION_4_HIGH#</cfoutput>;
ihbar_gun_1 = <cfoutput>#get_program_parameters.DENUNCIATION_1#</cfoutput>;
ihbar_gun_2 = <cfoutput>#get_program_parameters.DENUNCIATION_2#</cfoutput>;
ihbar_gun_3 = <cfoutput>#get_program_parameters.DENUNCIATION_3#</cfoutput>;
ihbar_gun_4 = <cfoutput>#get_program_parameters.DENUNCIATION_4#</cfoutput>;
paid_kidem_days = <cfoutput>#paid_kidem_days#</cfoutput>;
paid_ihbar_days = <cfoutput>#paid_ihbar_days#</cfoutput>;
izin_limit_1 = <cfoutput>#get_offtime_limits.LIMIT_1#</cfoutput>;
izin_limit_2 = <cfoutput>#get_offtime_limits.LIMIT_2#</cfoutput>;
izin_limit_3 = <cfoutput>#get_offtime_limits.LIMIT_3#</cfoutput>;
izin_limit_4 = <cfoutput>#get_offtime_limits.LIMIT_4#</cfoutput>;
izin_limit_1_days = <cfoutput>#get_offtime_limits.LIMIT_1_days#</cfoutput>;
izin_limit_2_days = <cfoutput>#get_offtime_limits.LIMIT_2_days#</cfoutput>;
izin_limit_3_days = <cfoutput>#get_offtime_limits.LIMIT_3_days#</cfoutput>;
izin_limit_4_days = <cfoutput>#get_offtime_limits.LIMIT_4_days#</cfoutput>;
izin_limit_5_days = <cfoutput>#get_offtime_limits.LIMIT_5_days#</cfoutput>;
daily_salary = <cfoutput>#daily_salary#</cfoutput>;
salary = <cfoutput>#salary#</cfoutput>;
daily_baz = <cfoutput>#daily_baz#</cfoutput>;
kidem_max = <cfoutput>#kidem_max#</cfoutput>;

function UnformatFields()
{
	fire_2.ihbar_amount.value = filterNum(fire_2.ihbar_amount.value);
	fire_2.salary.value = filterNum(fire_2.salary.value);
	fire_2.kidem_amount.value = filterNum(fire_2.kidem_amount.value);
	fire_2.yillik_izin_amount.value = filterNum(fire_2.yillik_izin_amount.value);
	fire_2.baz_ucret.value = filterNum(fire_2.baz_ucret.value);
}

function re_calc()
{
/*öncelikle virgülleri at*/
baz_ucret = filterNum(fire_2.baz_ucret.value);
total_deneme_days = fire_2.total_deneme_days.value;
total_ssk_days = fire_2.total_ssk_days.value;
yil_ = Math.floor(total_ssk_days / 365);
ay_ = Math.floor((total_ssk_days - (yil_ * 365))  / 30);
gun_ = Math.floor((total_ssk_days - (yil_ * 365) - (ay_ * 30)));

toplam_damga_12_aylik = <cfoutput>#toplam_damga_12_aylik#</cfoutput>;
toplam_gelir_12_aylik = <cfoutput>#toplam_gelir_12_aylik#</cfoutput>;


<cfif (not no_ihbar)>
if (((total_ssk_days-total_deneme_days-paid_ihbar_days) > ihbar_alt_sinir_1) && ((total_ssk_days-total_deneme_days-paid_ihbar_days) <= ihbar_ust_sinir_1))
	fire_2.ihbar_days.value = ihbar_gun_1;
else if (((total_ssk_days-total_deneme_days-paid_ihbar_days) > ihbar_alt_sinir_2) && ((total_ssk_days-total_deneme_days-paid_ihbar_days) <= ihbar_ust_sinir_2))
	fire_2.ihbar_days.value = ihbar_gun_2;
else if (((total_ssk_days-total_deneme_days-paid_ihbar_days) > ihbar_alt_sinir_3) && ((total_ssk_days-total_deneme_days-paid_ihbar_days) <= ihbar_ust_sinir_3))
	fire_2.ihbar_days.value = ihbar_gun_3;
else if (((total_ssk_days-total_deneme_days-paid_ihbar_days) > ihbar_alt_sinir_4) && ((total_ssk_days-total_deneme_days-paid_ihbar_days) <= ihbar_ust_sinir_4))
	fire_2.ihbar_days.value = ihbar_gun_4;
</cfif>

<cfif isdefined("kidem_hesap")>
/*kıdem tazminatı hesaplanır*/
	if (kidem_max <= baz_ucret)
		kidem_amount = (kidem_max * (total_ssk_days-paid_kidem_days)) / 365;
	else
		kidem_amount = (baz_ucret * (total_ssk_days-paid_kidem_days)) / 365;
	kidem_amount = kidem_amount - toplam_damga_12_aylik;
	fire_2.kidem_amount.value = commaSplit(kidem_amount);
</cfif>

<cfif isdefined("ihbar_hesap") and (not no_ihbar)>
/* ihbar tazminatı hesaplanır*/
	ihbar_amount = Math.round(fire_2.ihbar_days.value * daily_salary);
	fire_2.ihbar_amount.value = commaSplit(ihbar_amount);
</cfif>

fire_2.total_ssk_years.value = yil_;
fire_2.total_ssk_months.value = ay_;
fire_2.total_ssk_days_2.value = gun_;

hakkedilen_izin = 0;
/* hakedilen yıllık izin gün*/
for (i = 1; i <= fire_2.total_ssk_years.value;i++)
	{
	if (i < izin_limit_1)
		hakkedilen_izin += izin_limit_1_days;
	else if (i < izin_limit_2)
		hakkedilen_izin += izin_limit_2_days;
	else if (i < izin_limit_3)
		hakkedilen_izin += izin_limit_3_days;
	else if (i < izin_limit_4)
		hakkedilen_izin += izin_limit_4_days;
	else if (i < izin_limit_5)
		hakkedilen_izin += izin_limit_5_days;
	}
fire_2.hakkedilen_izin.value = hakkedilen_izin;
fire_2.yillik_izin_amount.value = Math.round(daily_salary * fire_2.kullanilmayan_yillik_izin.value);

/*virgülleri koy*/
fire_2.yillik_izin_amount.value = commaSplit(fire_2.yillik_izin_amount.value);
}
fire_2.ihbar_amount.value = commaSplit(fire_2.ihbar_amount.value);
fire_2.kidem_amount.value = commaSplit(fire_2.kidem_amount.value);
fire_2.yillik_izin_amount.value = commaSplit(fire_2.yillik_izin_amount.value);
</script>
