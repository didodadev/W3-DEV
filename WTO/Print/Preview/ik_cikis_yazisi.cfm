<cfset attributes.ID = attributes.action_id>
<cfquery name="get_in_out" datasource="#DSN#">
	SELECT
		EIO.*,
		E.KIDEM_DATE,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		EI.TC_IDENTY_NO	
	FROM
		EMPLOYEES_IN_OUT EIO,
		EMPLOYEES E,
		EMPLOYEES_IDENTY EI
	WHERE
		IN_OUT_ID = #attributes.ID# AND
		EIO.EMPLOYEE_ID = E.EMPLOYEE_ID AND
		EI.EMPLOYEE_ID = E.EMPLOYEE_ID
</cfquery>
<cfset attributes.branch_id = get_in_out.branch_id>
<cfset attributes.employee_id =  get_in_out.employee_id>
<cfquery name="get_progress_payment_out" datasource="#dsn#">
	SELECT * FROM EMPLOYEE_PROGRESS_PAYMENT_OUT WHERE EMP_ID = #attributes.employee_id#
</cfquery>
<cfquery name="get_progress_time" dbtype="query">
	SELECT SUM(PROGRESS_TIME) AS PROGRESS_TIME FROM get_progress_payment_out WHERE IS_KIDEM = 1
</cfquery>
<cfif get_progress_time.recordcount>
	<cfset attributes.progress_time = get_progress_time.PROGRESS_TIME>
<cfelse>
	<cfset attributes.progress_time = 0>
</cfif>
<cfquery name="GET_BRANCH" datasource="#dsn#">
	SELECT 
		BRANCH.*,
		BRANCH.SSK_M + '' + BRANCH.SSK_JOB + '' + BRANCH.SSK_BRANCH + '' + BRANCH.SSK_BRANCH_OLD + '' + BRANCH.SSK_NO + '' + BRANCH.SSK_CITY + '' + BRANCH.SSK_COUNTRY AS ISYERI_NO,
		OUR_COMPANY.COMPANY_NAME,
		OUR_COMPANY.T_NO,
		OUR_COMPANY.ADDRESS,
		OUR_COMPANY.TEL_CODE,
		OUR_COMPANY.TEL,
		OUR_COMPANY.TAX_NO,
		OUR_COMPANY.TAX_OFFICE
		<cfif isdefined("attributes.department_id")>
		,DEPARTMENT.DEPARTMENT_HEAD
		</cfif>
	FROM 
		<cfif isdefined("attributes.department_id")>
		DEPARTMENT,
		</cfif>
		BRANCH,
		OUR_COMPANY
	WHERE
		OUR_COMPANY.COMP_ID=BRANCH.COMPANY_ID
		AND BRANCH.BRANCH_ID = #attributes.BRANCH_ID#
	ORDER BY BRANCH.BRANCH_NAME
</cfquery>
<cfif not len(get_in_out.FINISH_DATE)>
	<cfabort>
</cfif>	
<cfset attributes.sal_mon = MONTH(get_in_out.FINISH_DATE)>
<cfset attributes.sal_year = YEAR(get_in_out.FINISH_DATE)>
<cfscript>
	parameter_last_month_1 = CreateDateTime(attributes.sal_year,attributes.sal_mon,1,0,0,0);
	parameter_last_month_30 = CreateDateTime(attributes.sal_year,attributes.sal_mon,daysinmonth(createdate(attributes.sal_year,attributes.sal_mon,1)),23,59,59);
	parameter_last_month_30_start = CreateDateTime(attributes.sal_year,attributes.sal_mon,daysinmonth(createdate(attributes.sal_year,attributes.sal_mon,1)),0,0,0);
</cfscript>
<cfset attributes.group_id = "">
<cfif len(get_in_out.puantaj_group_ids)>
	<cfset attributes.group_id = "#get_in_out.PUANTAJ_GROUP_IDS#,">
</cfif>
<cfinclude template="/V16/hr/ehesap/query/get_program_parameter.cfm">
<cfquery name="get_seniority_comp_max" datasource="#dsn#">
	SELECT ISNULL(SENIORITY_COMPANSATION_MAX,0) AS SENIORITY_COMPANSATION_MAX FROM INSURANCE_PAYMENT WHERE STARTDATE <= #parameter_last_month_1#  AND FINISHDATE >= #parameter_last_month_1#
</cfquery>
<cfquery name="get_insurance" datasource="#dsn#">
	SELECT ISNULL(MAX_PAYMENT,0) MAX_PAYMENT FROM INSURANCE_PAYMENT WHERE STARTDATE <= #parameter_last_month_1# AND FINISHDATE >= #parameter_last_month_30_start#
</cfquery>
<cfif not get_insurance.RECORDCOUNT>
	<script type="text/javascript">
		alert("Asgari Ücret Tanımları Eksik!");
	</script>
	<cfabort>
</cfif>

<cfif attributes.fuseaction neq "ehesap.form_upd_program_parameters" and (not isdefined("get_program_parameters.recordcount") or not get_program_parameters.recordcount)>
	<script type="text/javascript">
		alert("<cf_get_lang_main no ='1336.Seçtiğiniz Tarihi Kapsayan Program Akış Parametresi Bulunamamıştır! Lütfen Program Akış Parametrelerini Giriniz'>!");
		parent.location.href = "<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.form_add_program_parameters";
	</script>
	<cfabort>
</cfif>

<cfquery name="get_emp_offtimes" datasource="#dsn#">
	SELECT
		SUM(DATEDIFF(DAY,OFFTIME.STARTDATE,OFFTIME.FINISHDATE)) + 1 AS TOPLAM_GUN
	FROM
		OFFTIME,
		SETUP_OFFTIME
	WHERE
	(
	(OFFTIME.STARTDATE >= #CREATEODBCDATETIME(get_in_out.START_DATE)# AND OFFTIME.STARTDATE <= #CREATEODBCDATETIME(get_in_out.FINISH_DATE)#) OR
	(OFFTIME.FINISHDATE >= #CREATEODBCDATETIME(get_in_out.START_DATE)# AND OFFTIME.STARTDATE <= #CREATEODBCDATETIME(get_in_out.FINISH_DATE)#)
	) AND	
	OFFTIME.EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND
	OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID AND
	OFFTIME.VALID = 1 AND
	OFFTIME.IS_PUANTAJ_OFF = 0 AND
	(SETUP_OFFTIME.IS_KIDEM = 0 OR SETUP_OFFTIME.IS_KIDEM IS NULL)
</cfquery>
<cfscript>
if (isnumeric(get_emp_offtimes.TOPLAM_GUN))
	toplam_izin = get_emp_offtimes.TOPLAM_GUN;
else
	toplam_izin = 0;
</cfscript>

<cfquery name="get_puantaj_row" datasource="#dsn#">
	SELECT
		EMPLOYEES_PUANTAJ_ROWS.*
	FROM
		BRANCH,
		EMPLOYEES_PUANTAJ,
		EMPLOYEES_PUANTAJ_ROWS
	WHERE
		EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID
		AND EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = #get_in_out.EMPLOYEE_ID#
		AND EMPLOYEES_PUANTAJ.SAL_YEAR = #attributes.sal_year#
		AND EMPLOYEES_PUANTAJ.SAL_MON = #attributes.sal_mon#
		AND BRANCH.BRANCH_ID = #get_in_out.BRANCH_ID#
		AND EMPLOYEES_PUANTAJ.PUANTAJ_TYPE = -1 AND
	<cfif database_type is "MSSQL">
		BRANCH.SSK_OFFICE = EMPLOYEES_PUANTAJ.SSK_OFFICE
		AND BRANCH.SSK_NO = EMPLOYEES_PUANTAJ.SSK_OFFICE_NO
	<cfelseif database_type is "DB2">
		BRANCH.SSK_OFFICE = EMPLOYEES_PUANTAJ.SSK_OFFICE
		AND BRANCH.SSK_NO = EMPLOYEES_PUANTAJ.SSK_OFFICE_NO
	</cfif>
</cfquery>
<cfif not get_puantaj_row.RECORDCOUNT>
	<script type="text/javascript">
		alert("Puantaj Kaydı Bulunamadı !");
	</script>
	<cfabort>
</cfif>
<cfscript>
	ssk_matrah_tavan = (get_insurance.MAX_PAYMENT * get_puantaj_row.total_days) / 30;
</cfscript>
<cfquery name="get_active_tax_slice" datasource="#dsn#">
	SELECT 
		MIN_PAYMENT_1,
		MIN_PAYMENT_2,
		MIN_PAYMENT_3,
		MIN_PAYMENT_4,
		MIN_PAYMENT_5,
		MIN_PAYMENT_6,
		MAX_PAYMENT_1,
		MAX_PAYMENT_2,
		MAX_PAYMENT_3,
		MAX_PAYMENT_4,
		MAX_PAYMENT_5,
		MAX_PAYMENT_6,
		RATIO_1,
		RATIO_2,
		RATIO_3,
		RATIO_4,
		RATIO_5,
		RATIO_6
	FROM 
		SETUP_TAX_SLICES 
	WHERE 
		#CreateODBCDateTime(get_in_out.FINISH_DATE)# BETWEEN STARTDATE AND FINISHDATE
</cfquery>

<cfif not get_active_tax_slice.recordcount>
	<cfoutput>
		<script type="text/javascript">
			alert('#dateformat(last_month_1,dateformat_style)# - #dateformat(last_month_30,dateformat_style)# aralığında geçerli Vergi Dilimleri Tanımlı Değil !');
			history.back();
		</script>
	</cfoutput>
	<CFABORT>
</cfif>
<cfset ayni_yardim_total = 0>
<cfquery name="get_ayni_yardims" datasource="#dsn#">
	SELECT
		AMOUNT_PAY,
		COMMENT_PAY
	FROM
		SALARYPARAM_PAY
	WHERE
		IS_AYNI_YARDIM = 1 AND
		START_SAL_MON <= #attributes.sal_mon# AND
		END_SAL_MON >= #attributes.sal_mon# AND
		TERM = #attributes.sal_year# AND
		IN_OUT_ID = #attributes.ID#
</cfquery>
<cfif get_ayni_yardims.recordcount>
	<cfoutput query="get_ayni_yardims">
		<cfset ayni_yardim_total = ayni_yardim_total + AMOUNT_PAY>
	</cfoutput>
</cfif>
<cfquery name="get_emp_kidem_dahil_odeneks" datasource="#dsn#">
	SELECT
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
		EMPLOYEES_PUANTAJ.PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID
		AND EMPLOYEES_PUANTAJ.PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS_EXT.PUANTAJ_ID
		AND EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = #get_in_out.EMPLOYEE_ID#
		AND EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS_EXT.EMPLOYEE_PUANTAJ_ID
		AND EMPLOYEES_PUANTAJ_ROWS_EXT.IS_KIDEM = 1
		AND EMPLOYEES_PUANTAJ_ROWS_EXT.EXT_TYPE = 0
		AND EMPLOYEES_PUANTAJ.PUANTAJ_TYPE = -1
		AND
		(
			(
			EMPLOYEES_PUANTAJ.SAL_YEAR = #attributes.sal_year# AND
			EMPLOYEES_PUANTAJ.SAL_MON <= #attributes.sal_mon#
			)
			OR
			(
			EMPLOYEES_PUANTAJ.SAL_YEAR < #attributes.sal_year# AND
			EMPLOYEES_PUANTAJ.SAL_YEAR > #attributes.sal_year-2# AND
			EMPLOYEES_PUANTAJ.SAL_MON > #attributes.sal_mon#
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
<cfset datediff_ = datediff('d',get_in_out.START_DATE,get_in_out.FINISH_DATE)/30>
<cfif datediff_ eq 0><cfset datediff_ = 1></cfif>
<cfif datediff_ mod 30 neq 0>
	<cfset datediff_ = Int(datediff_)+1>
</cfif>
<cfif datediff_ gt 12><cfset datediff_ = 12></cfif>
<cfset kidem_dahil_odenek = TEMP_AVG / datediff_>
<cfscript>
	ihbar_net = 0;
	gvm_izin = get_puantaj_row.gvm_izin;
	gvm_ihbar = get_puantaj_row.gvm_ihbar;
	gelir_vergisi_matrah = get_puantaj_row.gelir_vergisi_matrah;
	kumulatif_gelir = get_puantaj_row.kumulatif_gelir_matrah;
	
	if (not len(get_in_out.KULLANILMAYAN_IZIN_AMOUNT) or get_in_out.KULLANILMAYAN_IZIN_AMOUNT eq 0) // kullanmadığı yıllık izin yoksa
		{
		C_B = 0;
		gelir_vergisi_izin = 0;
		C_N = 0;
		DAMGA_VERGISI_IZIN = 0;
		}
	else
		{
		C_B = get_in_out.KULLANILMAYAN_IZIN_AMOUNT;
		// veritabanında kümülatif e bu ayın matrahı da dahil erk 20030923
		ssk_matrah_salary = get_puantaj_row.ssk_matrah_salary;
		ssk_matrah = get_puantaj_row.ssk_matrah;
		kumulatif_gelir = get_puantaj_row.kumulatif_gelir_matrah;
		gelir_vergisi_matrah = get_puantaj_row.gelir_vergisi_matrah;
		gvm_izin = get_puantaj_row.gvm_izin;
		gvm_ihbar = get_puantaj_row.gvm_ihbar;
	
		if(get_in_out.GROSS_COUNT_TYPE eq 1)// standart izin hesap sistemi
			{
			if(get_puantaj_row.yillik_izin_amount gt 0)
				C_N = get_puantaj_row.yillik_izin_amount_net;
			else
				C_N = 0;		
			DAMGA_VERGISI_IZIN = (gvm_izin * get_program_parameters.stamp_tax_binde / 1000);
			GELIR_VERGISI_IZIN = gvm_izin - DAMGA_VERGISI_IZIN - C_N;
			}
		else // yeni sistem
			{
			// izinden ssk hesaplanıp çıkarılır
			if (ssk_matrah_salary neq 0)
				{
				if (get_puantaj_row.SSDF_ISCI_HISSESI neq 0) // emekli ise
					C_N = get_in_out.KULLANILMAYAN_IZIN_AMOUNT - (get_puantaj_row.SSDF_ISCI_HISSESI * (ssk_matrah_salary / ssk_matrah));
				else if (get_puantaj_row.SSK_ISCI_HISSESI neq 0)
					{
					C_N = get_in_out.KULLANILMAYAN_IZIN_AMOUNT - (get_puantaj_row.SSK_ISCI_HISSESI * (ssk_matrah_salary / ssk_matrah));
					C_N = C_N - (get_puantaj_row.ISSIZLIK_ISCI_HISSESI * (ssk_matrah_salary / ssk_matrah));
					}
				else
					C_N = get_in_out.KULLANILMAYAN_IZIN_AMOUNT;
				}
			else
				C_N = get_in_out.KULLANILMAYAN_IZIN_AMOUNT;
			
		
			// izinden damga vergisi çıkarılır
			DAMGA_VERGISI_IZIN = (C_B * get_program_parameters.stamp_tax_binde / 1000);
			GELIR_VERGISI_IZIN = (C_N * get_puantaj_row.tax_ratio);
			C_N = C_N - GELIR_VERGISI_IZIN - DAMGA_VERGISI_IZIN;
			}
		}
	
	if (not len(get_in_out.KIDEM_AMOUNT)) // kıdem yoksa
		{
		A_B = 0;
		A_N = 0;
		}
	else
		{
		A_B = get_in_out.KIDEM_AMOUNT;
		A_N = ( get_in_out.KIDEM_AMOUNT * (1000-get_program_parameters.stamp_tax_binde) ) / 1000;
		}
	
	if (not len(get_in_out.IHBAR_AMOUNT) or get_in_out.IHBAR_AMOUNT eq 0) // ihbar yoksa
		{
		B_B = 0;
		B_N = 0;
		gelir_vergisi_ihbar = 0;
		}
	else
		{
		B_B = get_in_out.IHBAR_AMOUNT;
	
		//writeoutput('kumulatif_gelir:#kumulatif_gelir#-tax_ratio:#gvm_ihbar# // ');
		
		// veritabanında kümülatif e bu ayın matrahı da dahil erk 20030923
		kumulatif_gelir = get_puantaj_row.kumulatif_gelir_matrah;
		gelir_vergisi_matrah = get_puantaj_row.gelir_vergisi_matrah;
		gvm_izin = get_puantaj_row.gvm_izin;
		gvm_ihbar = get_puantaj_row.gvm_ihbar;
	
		//writeoutput('kumulatif_gelir:#kumulatif_gelir#-tax_ratio:#gvm_ihbar# // ');
	
		// iHBARDAN gelir vergisi hesaplanıp çıkarılır
		// gelir vergisi hesaplanır	
		gelir_vergisi = 0;
		tax_ratio = get_active_tax_slice.RATIO_1;
		s1 = get_active_tax_slice.MAX_PAYMENT_1;	v1 = get_active_tax_slice.RATIO_1 / 100;
		s2 = get_active_tax_slice.MAX_PAYMENT_2;	v2 = get_active_tax_slice.RATIO_2 / 100;
		s3 = get_active_tax_slice.MAX_PAYMENT_3;	v3 = get_active_tax_slice.RATIO_3 / 100;
		s4 = get_active_tax_slice.MAX_PAYMENT_4;	v4 = get_active_tax_slice.RATIO_4 / 100;
		s5 = get_active_tax_slice.MAX_PAYMENT_5;	v5 = get_active_tax_slice.RATIO_5 / 100;
		s6 = get_active_tax_slice.MAX_PAYMENT_6;	v6 = get_active_tax_slice.RATIO_6 / 100;
		
		all_ = kumulatif_gelir - gvm_izin - gvm_ihbar;	
		
		
		
		if (kumulatif_gelir gte s5)
			{
			gelir_vergisi = gelir_vergisi + ((gelir_vergisi_matrah - gvm_izin - gvm_ihbar) * v6);
			}
		else if (kumulatif_gelir gte s4)
			{		
			if (all_ gte s5)
				{
				gelir_vergisi = gelir_vergisi + ((all_ - s5) * v6);
				gelir_vergisi = gelir_vergisi + ((s5 - kumulatif_gelir) * v5);
				}
			else
				gelir_vergisi = gelir_vergisi + ((gelir_vergisi_matrah - gvm_izin - gvm_ihbar) * v5);
			}
		else if (kumulatif_gelir gte s3)
			{
			if (all_ gte s5)
				{
				gelir_vergisi = gelir_vergisi + ((all_ - s5) * v6);
				gelir_vergisi = gelir_vergisi + ((s5 - s4) * v5);
				gelir_vergisi = gelir_vergisi + ((s4 - kumulatif_gelir) * v4);
				}
			else if (all_ gte s4)
				{
				gelir_vergisi = gelir_vergisi + ((all_ - s4) * v5);
				gelir_vergisi = gelir_vergisi + ((s4 - kumulatif_gelir) * v4);
				}
			else
				gelir_vergisi = gelir_vergisi + ((gelir_vergisi_matrah - gvm_izin - gvm_ihbar) * v3);
			}
		else if (kumulatif_gelir gte s2)
			{
			if (all_ gte s5)
				{
				gelir_vergisi = gelir_vergisi + ((all_ - s5) * v6);
				gelir_vergisi = gelir_vergisi + ((s5 - s4) * v5);
				gelir_vergisi = gelir_vergisi + ((s4 - s3) * v4);
				gelir_vergisi = gelir_vergisi + ((s3 - kumulatif_gelir) * v3);
				}
			else if (all_ gte s4)
				{
				gelir_vergisi = gelir_vergisi + ((all_ - s4) * v5);
				gelir_vergisi = gelir_vergisi + ((s4 - s3) * v4);
				gelir_vergisi = gelir_vergisi + ((s3 - kumulatif_gelir) * v3);
				}
			else if (all_ gte s3)
				{
				gelir_vergisi = gelir_vergisi + ((all_ - s3) * v4);
				gelir_vergisi = gelir_vergisi + ((s3 - kumulatif_gelir) * v3);
				}
			else
				gelir_vergisi = gelir_vergisi + ((gelir_vergisi_matrah - gvm_izin - gvm_ihbar) * v2);
			
			//writeoutput('(gelir_vergisi_matrah - gvm_izin - gvm_ihbar) : #(gelir_vergisi_matrah - gvm_izin - gvm_ihbar)# gelir_vergisi_matrah:#gelir_vergisi_matrah# gelir_vergisi:#gelir_vergisi# - gvm_izin:#gvm_izin# gvm_ihbar:#gvm_ihbar#');
			}
		else if (kumulatif_gelir gte s1)
			{
			if (all_ gte s5)
				{
				gelir_vergisi = gelir_vergisi + ((all_ - s5) * v6);
				gelir_vergisi = gelir_vergisi + ((s5 - s4) * v5);
				gelir_vergisi = gelir_vergisi + ((s4 - s3) * v4);
				gelir_vergisi = gelir_vergisi + ((s3 - s2) * v3);
				gelir_vergisi = gelir_vergisi + ((s2 - kumulatif_gelir) * v2);
				}
			else if (all_ gte s4)
				{
				gelir_vergisi = gelir_vergisi + ((all_ - s4) * v5);
				gelir_vergisi = gelir_vergisi + ((s4 - s3) * v4);
				gelir_vergisi = gelir_vergisi + ((s3 - s2) * v3);
				gelir_vergisi = gelir_vergisi + ((s2 - kumulatif_gelir) * v2);
				}
			else if (all_ gte s3)
				{
				gelir_vergisi = gelir_vergisi + ((all_ - s3) * v4);
				gelir_vergisi = gelir_vergisi + ((s3 - s2) * v3);
				gelir_vergisi = gelir_vergisi + ((s2 - kumulatif_gelir) * v2);
				}
			else if (all_ gte s2)
				{
				gelir_vergisi = gelir_vergisi + ((all_ - s2) * v3);
				gelir_vergisi = gelir_vergisi + ((s2 - kumulatif_gelir) * v2);
				}
			else
				gelir_vergisi = gelir_vergisi + ((gelir_vergisi_matrah - gvm_izin - gvm_ihbar) * v1);
			}
		else
			{
			if (all_ gte s5)
				{
				gelir_vergisi = gelir_vergisi + ((all_ - s5) * v6);
				gelir_vergisi = gelir_vergisi + ((s5 - s4) * v5);
				gelir_vergisi = gelir_vergisi + ((s4 - s3) * v4);
				gelir_vergisi = gelir_vergisi + ((s3 - s2) * v3);
				gelir_vergisi = gelir_vergisi + ((s2 - s1) * v2);
				gelir_vergisi = gelir_vergisi + ((s1 - kumulatif_gelir) * v1);
				}
			else if (all_ gte s4)
				{
				gelir_vergisi = gelir_vergisi + ((all_ - s4) * v5);
				gelir_vergisi = gelir_vergisi + ((s4 - s3) * v4);
				gelir_vergisi = gelir_vergisi + ((s3 - s2) * v3);
				gelir_vergisi = gelir_vergisi + ((s2 - s1) * v2);
				gelir_vergisi = gelir_vergisi + ((s1 - kumulatif_gelir) * v1);
				}
			else if (all_ gte s3)
				{
				gelir_vergisi = gelir_vergisi + ((all_ - s3) * v4);
				gelir_vergisi = gelir_vergisi + ((s3 - s2) * v3);
				gelir_vergisi = gelir_vergisi + ((s2 - s1) * v2);
				gelir_vergisi = gelir_vergisi + ((s1 - kumulatif_gelir) * v1);
				}
			else if (all_ gte s2)
				{
				gelir_vergisi = gelir_vergisi + ((all_ - s2) * v3);
				gelir_vergisi = gelir_vergisi + ((s2 - s1) * v2);
				gelir_vergisi = gelir_vergisi + ((s1 - kumulatif_gelir) * v1);
				}
			else if (all_ gte s1)
				{
				gelir_vergisi = gelir_vergisi + ((all_ - s1) * v2);
				gelir_vergisi = gelir_vergisi + ((s1 - kumulatif_gelir) * v1);
				}
			else
				gelir_vergisi = gelir_vergisi + ((gelir_vergisi_matrah - gvm_izin - gvm_ihbar) * v1);
			}
			
			//writeoutput("gelir:#gelir_vergisi#");
			/*TLFormat(t_gelir_vergisi+t_vergi_indirimi_5084+t_vergi_iadesi-t_mahsup_g_vergisi)#*/
		
		gelir_vergisi_ihbar = get_puantaj_row.gelir_vergisi + get_puantaj_row.VERGI_IADESI - gelir_vergisi - gelir_vergisi_izin;
		//writeoutput("ihbar:#gelir_vergisi_ihbar#");
		//writeoutput('gelir_vergisi:#get_puantaj_row.gelir_vergisi# VERGI_IADESI:#VERGI_IADESI# gelir_vergisi:#gelir_vergisi# gelir_vergisi_izin:#gelir_vergisi_izin#');
	
		B_N = B_B - gelir_vergisi_ihbar;
		// ihbardan damga vergisi çıkarılır
		B_N = B_N - (get_in_out.IHBAR_AMOUNT * (get_program_parameters.stamp_tax_binde / 1000));
	
		
		if(len(get_puantaj_row.ihbar_amount_net) and get_puantaj_row.ihbar_amount_net gt 0)
			{
				IHBAR_DAMGASI = (get_in_out.IHBAR_AMOUNT * (get_program_parameters.stamp_tax_binde / 1000));
				//B_N = get_puantaj_row.NET_UCRET - get_puantaj_row.ihbar_amount_net;
				B_N = get_puantaj_row.ihbar_amount_net;
				gelir_vergisi_ihbar = get_in_out.IHBAR_AMOUNT - B_N - IHBAR_DAMGASI;
			}
		else
			{
			if(get_in_out.GROSS_COUNT_TYPE eq 1)// standart izin hesap sistemi
				{
				IHBAR_DAMGASI = (get_in_out.IHBAR_AMOUNT * (get_program_parameters.stamp_tax_binde / 1000));
				B_N = get_puantaj_row.NET_UCRET - C_N - A_N - get_puantaj_row.vergi_iadesi - get_puantaj_row.salary;
				gelir_vergisi_ihbar = get_in_out.IHBAR_AMOUNT - B_N - IHBAR_DAMGASI;
				}
			}
		}
	BRUT_KIDEM_IHBAR_YILLIK = A_B + B_B + C_B;
	NET_KIDEM_IHBAR_YILLIK = A_N + B_N + C_N;
</cfscript>
<cfquery name="get_last_position_name" datasource="#DSN#">
	SELECT TOP 1
		EPH.POSITION_NAME,
		D.DEPARTMENT_HEAD,
		EPH.UPPER_POSITION_CODE,
		EPH.UPPER_POSITION_CODE2
	FROM 
		EMPLOYEE_POSITIONS_HISTORY EPH,
		DEPARTMENT D
	WHERE 
		EPH.EMPLOYEE_ID = #attributes.employee_id#
		AND D.DEPARTMENT_ID = EPH.DEPARTMENT_ID
	ORDER BY 
		HISTORY_ID DESC
</cfquery>
<cfquery name="get_emp_in_outs" datasource="#dsn#">
	SELECT
		*
	FROM
		EMPLOYEES_IN_OUT
	WHERE
		EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
		AND TOTAL_SSK_DAYS <> 0
		AND TOTAL_SSK_DAYS IS NOT NULL
		AND IN_OUT_ID <> #get_in_out.in_out_id#
</cfquery>
<cfquery name="get_insurance_ratio" datasource="#dsn#">
	SELECT
		*
	FROM
		INSURANCE_RATIO
	WHERE
		FINISHDATE >= #CREATEODBCDATETIME(get_in_out.FINISH_DATE)#
</cfquery>
<cfset sgk_isci_payi = ((get_insurance_ratio.PAT_INS_PREMIUM_WORKER+get_insurance_ratio.death_insurance_premium_worker+get_insurance_ratio.death_insurance_worker)/100)>
<cfscript>
	paid_kidem_days = 0;
	paid_ihbar_days = 0;
	for (k=1; k lte get_emp_in_outs.recordcount;k = k+1)
	{
	if (get_emp_in_outs.ihbar_amount[k] gt 0) paid_ihbar_days = paid_ihbar_days + get_emp_in_outs.TOTAL_SSK_DAYS[k];
	if (get_emp_in_outs.KIDEM_AMOUNT[k] gt 0) paid_kidem_days = paid_kidem_days + get_emp_in_outs.TOTAL_SSK_DAYS[k];
	}
	kidem_max = get_seniority_comp_max.seniority_compansation_max;
</cfscript>

<cfquery name="GET_SIGORTA" datasource="#dsn#" maxrows="1">
	SELECT
		(VERGI_ISTISNA_SSK + VERGI_ISTISNA_VERGI + VERGI_ISTISNA_DAMGA) AS TOPLAM_SIGORTA
	FROM
		EMPLOYEES_PUANTAJ_ROWS EPR,
		EMPLOYEES_PUANTAJ EP
	WHERE
		EPR.EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND
		EPR.TOTAL_DAYS > 0 AND		
		EP.PUANTAJ_TYPE = -1 AND
		EPR.PUANTAJ_ID = EP.PUANTAJ_ID AND
		(
			(
			EP.SAL_YEAR = #attributes.sal_year#
			AND
			EP.SAL_MON <= #attributes.sal_mon#
			)
			OR
			(
			EP.SAL_YEAR = #YEAR(get_in_out.FINISH_DATE)#
			AND
			EP.SAL_MON >= #MONTH(get_in_out.FINISH_DATE)#
			)
			OR
			(
			EP.SAL_YEAR < #attributes.sal_year#
			)
		)
	ORDER BY 
		EP.SAL_YEAR DESC,
		EP.SAL_MON DESC
</cfquery>
<cfquery name="get_fire_xml" datasource="#dsn#">
	SELECT 
		PROPERTY_VALUE,
		PROPERTY_NAME
	FROM
		FUSEACTION_PROPERTY
	WHERE
		OUR_COMPANY_ID = #session.ep.company_id# AND
		FUSEACTION_NAME = 'ehesap.popup_form_fire' AND
		PROPERTY_NAME = 'x_tax_acc'
</cfquery>
<cfif (get_fire_xml.recordcount and get_fire_xml.property_value eq 1) or get_fire_xml.recordcount eq 0><cfset x_tax_acc = 1><cfelse><cfset x_tax_acc = 0></cfif>
<cfset sigorta_ = 0>
<cfif GET_SIGORTA.recordcount and GET_SIGORTA.TOPLAM_SIGORTA gt 0 and x_tax_acc eq 1>
	<cfset sigorta_ = GET_SIGORTA.TOPLAM_SIGORTA>
</cfif>

<cfinclude template="/V16/objects/display/view_company_logo.cfm">
<br/><br/>

<cfoutput>
<table width="700" align="center">
	<tr>
		<td width="150" class="txtbold">Adı Soyadı</td>
		<td>#get_in_out.EMPLOYEE_NAME# #get_in_out.EMPLOYEE_SURNAME#</td>
		<td width="150" class="txtbold">Şirket</td>
		<td>#get_branch.company_name#</td>
	</tr>
	<tr>
		<td class="txtbold">TC Kimlik No</td>
		<td>#get_in_out.TC_IDENTY_NO#</td>
		<td class="txtbold">Şube</td>
		<td>#get_branch.branch_fullname#</td>
	</tr>
	<tr>
		<td class="txtbold">Departman / Pozisyon</td>
		<td>#get_last_position_name.DEPARTMENT_HEAD# / #get_last_position_name.position_name#</td>
		<td class="txtbold">İşyeri Sicil No</td>
		<td>#get_branch.ISYERI_NO#</td>
	</tr>
	<tr>
		<td colspan="4">&nbsp;</td>
	</tr>
	<tr>
		<td class="txtbold">İşten Çıkış Nedeni</td>
		<td colspan="3">#get_explanation_name(get_in_out.explanation_id)#</td>
	</tr>
	<tr>
		<td colspan="4">&nbsp;</td>
	</tr>
	<tr>
		<td class="txtbold">Kıdem Baz Tarihi</td>
		<td><cfif len(get_in_out.KIDEM_DATE)>#dateformat(get_in_out.KIDEM_DATE,dateformat_style)#</cfif></td>
		<td class="txtbold"></td>
		<td></td>
	</tr>
	<tr>
		<td class="txtbold">İşe Giriş Tarihi</td>
		<td>#dateformat(get_in_out.START_DATE,dateformat_style)#</td>
		<td class="txtbold">Hizmet Süresi</td>
		<cfif len(get_in_out.total_ssk_days)>
			<cfset toplam_days = (get_in_out.kidem_years * 365) + (get_in_out.total_ssk_months * 30) + get_in_out.total_ssk_days + toplam_izin>
		<cfelse>
			<cfset toplam_days = 0>
		</cfif>
		
		<cfset total_ssk_years = fix(toplam_days / 365)>
		<cfset total_ssk_months = fix((toplam_days - (total_ssk_years * 365)) / 30)>
		<cfset total_ssk_days_2 = toplam_days - (total_ssk_years * 365) - (total_ssk_months * 30)>
		
		<td>#total_ssk_years# yıl / #total_ssk_months# ay / #total_ssk_days_2# gün</td>
	</tr>
	<tr>
		<td class="txtbold">İşten Çıkış Tarihi</td>
		<td>#dateformat(get_in_out.FINISH_DATE,dateformat_style)#</td>
		<td class="txtbold">Hizmet Süresi (gün)</td>
		<cfif len(get_in_out.total_ssk_days)>
			<td>#(get_in_out.kidem_years * 365) + (get_in_out.total_ssk_months * 30) + get_in_out.total_ssk_days + toplam_izin#</td>
		<cfelse>
			<td>0</td>
		</cfif>
	</tr>
	<tr>
		<td class="txtbold">Kıdeme Dahil Edilmeyecek Günler</td>
		<td>#toplam_izin+paid_kidem_days+attributes.progress_time#</td>
	</tr>
	<tr>
		<td class="txtbold">&nbsp;</td>
		<td>&nbsp;</td>
		<td class="txtbold">&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td class="txtbold">Brüt Ücret</td>
		<td>
		<cfif get_in_out.gross_net eq 1>
			<cfif get_in_out.salary_type eq 2>
				<cfset carpan = 1>
			<cfelseif get_in_out.salary_type eq 1>
				<cfset carpan = 30>
			<cfelse>
				<cfset carpan = 225>
			</cfif>
 			<cfset ucret_ = get_in_out.salary * carpan>
 		<cfelse>
			<cfif get_in_out.salary_type eq 2>
				<cfset carpan = 1>

			<cfelseif get_in_out.salary_type eq 1>
				<cfset carpan = 30>
			<cfelse>
				<cfset carpan = 225>
			</cfif>
			<cfset ucret_ = get_puantaj_row.salary * carpan>
		</cfif>	
		#tlformat(ucret_)#</td>
		<td class="txtbold">Kıdem Tazminatı Tavanı</td>
		<td>#tlformat(kidem_max)#</td>
	</tr>	
		<tr>
		<td class="txtbold">Ek Ödenek Ortalaması</td>
		<td>#tlformat(kidem_dahil_odenek)#</td>
		<td class="txtbold" nowrap>Kıdem Hesabına Esas Ücret</td>
		<td>
		<cfif (kidem_dahil_odenek + ayni_yardim_total + ucret_) gt kidem_max>
		#tlformat(kidem_max)#
		<cfelse>
		#tlformat(kidem_dahil_odenek + ayni_yardim_total + ucret_)#
		</cfif>
		</td>
	</tr>
	<tr>
		<td class="txtbold"><cfif get_ayni_yardims.recordcount>Ayni Yardım (#get_ayni_yardims.comment_pay[1]#)</cfif></td>
		<td><cfif get_ayni_yardims.recordcount>#tlformat(get_ayni_yardims.amount_pay[1])#</cfif></td>
		<td class="txtbold">Kıdeme Esas Süre (Gün)</td>
		<td>#(get_in_out.kidem_years * 365) + (get_in_out.total_ssk_months * 30) + get_in_out.total_ssk_days - paid_kidem_days#</td>
	</tr>
	<tr>
		<td class="txtbold"><cfif get_ayni_yardims.recordcount gt 1>Ayni Yardım (#get_ayni_yardims.comment_pay[2]#)</cfif></td>
		<td><cfif get_ayni_yardims.recordcount gt 1>#tlformat(get_ayni_yardims.amount_pay[2])#</cfif></td>
		<td class="txtbold">İhbar Tazminatı Matrahı</td>
		<td>#tlformat(kidem_dahil_odenek + ayni_yardim_total + ucret_ + sigorta_)#</td>
	</tr>
	<tr>
		<td class="txtbold"><cfif get_ayni_yardims.recordcount gt 2>Ayni Yardım (#get_ayni_yardims.comment_pay[3]#)</cfif></td>
		<td><cfif get_ayni_yardims.recordcount gt 2>#tlformat(get_ayni_yardims.amount_pay[3])#</cfif></td>
		<td class="txtbold">İhbar Süresi (hafta/gün)</td>
		<td>#get_in_out.ihbar_days# gün</td>
	</tr>
	<tr>
		<td class="txtbold">Özel Sigorta</td>
		<td>#tlformat(sigorta_)#</td>
		<td class="txtbold">Kullanılmayan Yıllık İzin</td>
		<td>#get_in_out.KULLANILMAYAN_IZIN_COUNT# gün</td>
	</tr>
	<tr>
		<td class="txtbold">Toplam</td>
		<td>#tlformat(kidem_dahil_odenek + ayni_yardim_total + ucret_ + sigorta_)#</td>
		<td class="txtbold">SSK Tavanı</td>
		<td>#tlformat(ssk_matrah_tavan)#</td>
	</tr>
</table>
<br/><br/>
<table width="700" align="center" cellpadding="1" cellspacing="1">
	<tr bgcolor="f5f5f5" class="formbold" height="25">
		<td></td>
		<td align="center">BRÜT</td>
		<td align="center">SSK İŞÇİ</td>
		<td align="center">GV MATRAH</td>
		<td align="center">KGV</td>
		<td align="center">GV HESAPLANAN</td>
		<td align="center">GV</td>
		<td align="center">DV</td>
		<td align="center">NET</td>
	</tr>
    <cfif year(get_in_out.finish_date) lt 2003>
	<tr bgcolor="f5f5f5" height="25">
		<td style="text-align:right;" class="formbold">KIDEM TAZMİNATI</td>
		<td style="text-align:right;">#tlformat(get_in_out.kidem_amount)#</td>
		<td style="text-align:right;">MUAF</td>
		<td style="text-align:right;">MUAF</td>
		<td style="text-align:right;">-</td>
		<td style="text-align:right;">MUAF</td>
		<td style="text-align:right;">MUAF</td>
		<td style="text-align:right;">#tlformat(get_in_out.kidem_amount * get_program_parameters.stamp_tax_binde / 1000)#</td>
		<td style="text-align:right;">#tlformat(get_in_out.kidem_amount - (get_in_out.kidem_amount * get_program_parameters.stamp_tax_binde / 1000))#</td>
	</tr>
	<tr bgcolor="f5f5f5" height="25">
		<td style="text-align:right;" class="formbold">İZİN ÜCRETİ</td>
		<td style="text-align:right;">#tlformat(get_puantaj_row.yillik_izin_amount)#</td>
		<td style="text-align:right;">(#get_puantaj_row.yillik_izin_amount# #gvm_izin#)<cfif get_puantaj_row.yillik_izin_amount gt 0>#tlformat(get_puantaj_row.yillik_izin_amount - gvm_izin)#<cfelse>-</cfif></td>
		<td style="text-align:right;">#gvm_izin#<cfif get_puantaj_row.yillik_izin_amount gt 0>#tlformat(gvm_izin)#<cfelse>-</cfif></td>
		<td style="text-align:right;"><cfif get_puantaj_row.yillik_izin_amount gt 0>#tlformat(kumulatif_gelir)#<cfelse>-</cfif></td>
		<td style="text-align:right;"><cfif get_puantaj_row.yillik_izin_amount gt 0>#tlformat(gelir_vergisi_izin)#<cfelse>-</cfif></td>
		<td style="text-align:right;"><cfif get_puantaj_row.yillik_izin_amount gt 0>#tlformat(gelir_vergisi_izin)#<cfelse>-</cfif></td>
		<td style="text-align:right;"><cfif get_puantaj_row.yillik_izin_amount gt 0>#tlformat(DAMGA_VERGISI_IZIN)#<cfelse>-</cfif></td>
		<td style="text-align:right;">#TLFormat(C_N)#</td>
	</tr>
	<tr bgcolor="f5f5f5" height="25">
		<td style="text-align:right;" class="formbold">İHBAR TAZMİNATI</td>
		<td style="text-align:right;">#tlformat(get_in_out.ihbar_amount)#</td>
		<td style="text-align:right;">MUAF</td>
		<td style="text-align:right;">#tlformat(gvm_ihbar)#</td>
		<td style="text-align:right;"><cfif get_in_out.ihbar_amount gt 0>#tlformat(kumulatif_gelir)#<cfelse>-</cfif></td>
		<td style="text-align:right;">#TLFormat(get_in_out.ihbar_amount * get_puantaj_row.TAX_RATIO)#</td>
		<td style="text-align:right;">#TLFormat(gelir_vergisi_ihbar)#</td>
		<td style="text-align:right;">#tlformat(get_in_out.IHBAR_AMOUNT * (get_program_parameters.stamp_tax_binde / 1000))#</td>
		<td style="text-align:right;">#TLFormat(B_N)#</td>
	</tr>
	<tr bgcolor="cccccc" height="25" class="formbold">
		<td style="text-align:right;">TOPLAM</td>
		<td style="text-align:right;">#tlformat(get_in_out.kidem_amount + get_in_out.ihbar_amount + get_puantaj_row.yillik_izin_amount)#</td>
		<td style="text-align:right;"><cfif get_puantaj_row.yillik_izin_amount gt 0>#tlformat(get_puantaj_row.yillik_izin_amount - gvm_izin)#<cfelse>-</cfif></td>
		<td style="text-align:right;"><cfif gvm_izin gt 0 or gvm_ihbar gt 0>#tlformat((gelir_vergisi_matrah - gvm_izin - gvm_ihbar) + (gelir_vergisi_matrah - gvm_izin))#<cfelse>0</cfif></td>
		<td style="text-align:right;"><cfif get_in_out.ihbar_amount + get_puantaj_row.yillik_izin_amount gt 0>#tlformat(kumulatif_gelir)#<cfelse>0</cfif></td>
		<td style="text-align:right;">#tlformat(gelir_vergisi_ihbar + gelir_vergisi_izin)#</td>
		<td style="text-align:right;">#tlformat(DAMGA_VERGISI_IZIN + (get_in_out.IHBAR_AMOUNT * (get_program_parameters.stamp_tax_binde / 1000)) + (get_in_out.kidem_amount * get_program_parameters.stamp_tax_binde / 1000))#</td>
		<td style="text-align:right;">#tlformat(NET_KIDEM_IHBAR_YILLIK)#</td>
	</tr>
    <cfelse>
	<tr bgcolor="f5f5f5" height="25" style="text-align:right;">
		<td class="formbold">KIDEM TAZMİNATI</td>
		<td>#tlformat(get_puantaj_row.kidem_amount)#</td>
		<td>MUAF</td>
		<td>MUAF</td>
		<td>-</td>
		<td>MUAF</td>
		<td>MUAF</td>
		<td>#tlformat(get_puantaj_row.kidem_amount_damga_vergisi)#</td>
		<td>#tlformat(get_puantaj_row.kidem_amount_net)#</td>
	</tr>
	<tr bgcolor="f5f5f5" height="25" style="text-align:right;">
        <cfif get_puantaj_row.ssk_days eq 0>
            <cfset ssk_isci_izin_ucreti = 0>
        <cfelse>
            <cfif get_puantaj_row.ssk_statute eq 2>
                <cfset ssk_isci_izin_ucreti = get_puantaj_row.yillik_izin_amount-(gvm_izin-get_puantaj_row.yillik_izin_amount_ssk_isci_issizlik)>
            <cfelse>
                <cfset ssk_isci_izin_ucreti = get_puantaj_row.yillik_izin_amount*sgk_isci_payi>
            </cfif>
        </cfif>
		<td class="formbold">İZİN ÜCRETİ</td>
		<td>#tlformat(get_puantaj_row.yillik_izin_amount)#</td>
		<td>#tlformat(ssk_isci_izin_ucreti)#</td>
        <td><cfif get_puantaj_row.yillik_izin_amount gt 0>#tlformat(get_puantaj_row.yillik_izin_amount-ssk_isci_izin_ucreti)#<cfelse>-</cfif></td>
		<td><cfif get_puantaj_row.yillik_izin_amount gt 0>#tlformat(kumulatif_gelir)#<cfelse>-</cfif></td>
		<td>#tlformat((get_puantaj_row.yillik_izin_amount-ssk_isci_izin_ucreti)*sgk_isci_payi)#</td>
		<td><cfif get_puantaj_row.ssk_days eq 0>#tlformat(get_puantaj_row.gelir_vergisi)#<cfelse>#tlformat(get_puantaj_row.yillik_izin_amount_gelir_vergisi)#</cfif></td> 
		<td><cfif get_puantaj_row.ssk_days eq 0>#tlformat(get_puantaj_row.damga_vergisi)#<cfelse>#tlformat(get_puantaj_row.yillik_izin_amount*get_program_parameters.stamp_tax_binde / 1000)#</cfif></td>
        <cfif get_puantaj_row.ssk_statute eq 2>
            <cfif get_puantaj_row.ssk_days eq 0>
        	    <cfset yillik_izin_amount_net_ = (get_puantaj_row.yillik_izin_amount-(get_puantaj_row.yillik_izin_amount-(gvm_izin-get_puantaj_row.yillik_izin_amount_ssk_isci_issizlik))-get_puantaj_row.gelir_vergisi-get_puantaj_row.damga_vergisi)>
            <cfelse>
        	    <cfset yillik_izin_amount_net_ = (get_puantaj_row.yillik_izin_amount-(get_puantaj_row.yillik_izin_amount-(gvm_izin-get_puantaj_row.yillik_izin_amount_ssk_isci_issizlik))-get_puantaj_row.yillik_izin_amount_gelir_vergisi-get_puantaj_row.yillik_izin_amount_damga_vergisi)>
            </cfif>
        <cfelse>
            <cfif get_puantaj_row.ssk_days eq 0>
			    <cfset yillik_izin_amount_net_ = (get_puantaj_row.yillik_izin_amount-(get_puantaj_row.yillik_izin_amount_ssk_isci_hissesi + get_puantaj_row.yillik_izin_amount_ssk_isci_issizlik)-get_puantaj_row.gelir_vergisi-get_puantaj_row.damga_vergisi)>
            <cfelse>
			    <cfset yillik_izin_amount_net_ = (get_puantaj_row.yillik_izin_amount-(get_puantaj_row.yillik_izin_amount_ssk_isci_hissesi + get_puantaj_row.yillik_izin_amount_ssk_isci_issizlik)-get_puantaj_row.yillik_izin_amount_gelir_vergisi-get_puantaj_row.yillik_izin_amount_damga_vergisi)>
            </cfif>
        </cfif>
		<td>
            <cfif get_puantaj_row.ssk_days eq 0>
                #tlformat((get_puantaj_row.yillik_izin_amount-ssk_isci_izin_ucreti) - get_puantaj_row.gelir_vergisi - get_puantaj_row.damga_vergisi - ssk_isci_izin_ucreti)#
            <cfelse>
                #tlformat(get_puantaj_row.yillik_izin_amount-(get_puantaj_row.yillik_izin_amount*sgk_isci_payi)-((get_puantaj_row.yillik_izin_amount-ssk_isci_izin_ucreti)*sgk_isci_payi)-(get_puantaj_row.yillik_izin_amount*get_program_parameters.stamp_tax_binde / 1000))#
            </cfif>
        </td>
	</tr>
	<tr bgcolor="f5f5f5" height="25" style="text-align:right;">
		<td class="formbold">İHBAR TAZMİNATI</td>
		<td>#tlformat(get_puantaj_row.ihbar_amount)#</td>
		<td>MUAF</td>
		<td>#tlformat(gvm_ihbar)#</td>
		<td><cfif get_in_out.ihbar_amount gt 0>#tlformat(kumulatif_gelir)#<cfelse>-</cfif></td>
		<td ><cfif get_in_out.ihbar_amount gt 0>#TLFormat(get_in_out.ihbar_amount * get_puantaj_row.TAX_RATIO)#<cfelse>-</cfif></td>
		<td>#TLFormat(get_puantaj_row.ihbar_amount_gelir_vergisi)#</td>
		<td>#tlformat(get_puantaj_row.ihbar_amount_damga_vergisi)#</td>
		<td>
			<cfset ihbar_net = get_puantaj_row.ihbar_amount - get_puantaj_row.ihbar_amount_gelir_vergisi - get_puantaj_row.ihbar_amount_damga_vergisi>
			#TLFormat(ihbar_net)#
		</td>
	</tr>
	<tr bgcolor="cccccc" height="25" style="text-align:right;" class="formbold">
		<td>TOPLAM</td>
		<td>#tlformat(get_puantaj_row.ihbar_amount + get_puantaj_row.yillik_izin_amount + get_puantaj_row.kidem_amount)#</td>
		<td>#tlformat(ssk_isci_izin_ucreti)#</td>
		<td>#tlformat(gvm_izin + gvm_ihbar)#</td>
		<td><cfif get_in_out.kidem_amount + get_in_out.ihbar_amount + get_puantaj_row.yillik_izin_amount gt 0>#tlformat(kumulatif_gelir)#<cfelse>0</cfif></td>
		<td>
            <cfif get_puantaj_row.ssk_days eq 0>
                #TLFormat((get_in_out.ihbar_amount * get_puantaj_row.TAX_RATIO)+get_puantaj_row.gelir_vergisi)#
            <cfelse>
                #TLFormat((get_in_out.ihbar_amount * get_puantaj_row.TAX_RATIO)+get_puantaj_row.yillik_izin_amount_gelir_vergisi)#
            </cfif>
        </td>
		<td>
            <cfif get_puantaj_row.ssk_days eq 0>
                #tlformat(get_puantaj_row.gelir_vergisi + get_puantaj_row.ihbar_amount_gelir_vergisi)#
            <cfelse>
                #tlformat(get_puantaj_row.yillik_izin_amount_gelir_vergisi + get_puantaj_row.ihbar_amount_gelir_vergisi)#
            </cfif>
        </td>
		<td>
            <cfif get_puantaj_row.ssk_days eq 0>
                #tlformat(get_puantaj_row.damga_vergisi + get_puantaj_row.ihbar_amount_damga_vergisi + get_puantaj_row.kidem_amount_damga_vergisi)#
            <cfelse>
                #tlformat(get_puantaj_row.yillik_izin_amount_damga_vergisi + get_puantaj_row.ihbar_amount_damga_vergisi + get_puantaj_row.kidem_amount_damga_vergisi)#
            </cfif>
        </td>
		<td>
            <cfif get_puantaj_row.ssk_days eq 0>
                #tlformat((get_puantaj_row.yillik_izin_amount-ssk_isci_izin_ucreti) - get_puantaj_row.gelir_vergisi - get_puantaj_row.damga_vergisi - ssk_isci_izin_ucreti)#
            <cfelse>
                #tlformat(get_puantaj_row.kidem_amount_net + (get_puantaj_row.yillik_izin_amount-(get_puantaj_row.yillik_izin_amount*sgk_isci_payi)-((get_puantaj_row.yillik_izin_amount-ssk_isci_izin_ucreti)*sgk_isci_payi)-(get_puantaj_row.yillik_izin_amount*get_program_parameters.stamp_tax_binde / 1000)) + ihbar_net)#
            </cfif>
        </td>
	</tr>
	<tr>
		<td><font color="red">Not: AGİ Dahil Tutar yansıtılmıştır</font></td>
	</tr>
    </cfif>
</table>
<br/><br/>
<cfif get_last_position_name.recordcount and len(get_last_position_name.upper_position_code)>
	<cfquery name="get_" datasource="#dsn#">
		SELECT
			EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS ISIM,
			POSITION_NAME
		FROM
			EMPLOYEE_POSITIONS
		WHERE
			POSITION_CODE = #get_last_position_name.upper_position_code#
	</cfquery>
	<cfif get_.recordcount>
		<cfset birinci_amir = get_.ISIM>
		<cfset birinci_amir_position = get_.POSITION_NAME>
	<cfelse>
		<cfset birinci_amir = "">
		<cfset birinci_amir_position = "">
	</cfif>
<cfelse>
	<cfset birinci_amir = "">
	<cfset birinci_amir_position = "">
</cfif>

<cfif get_last_position_name.recordcount and len(get_last_position_name.upper_position_code2)>
	<cfquery name="get_2" datasource="#dsn#">
		SELECT
			EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS ISIM,
			POSITION_NAME
		FROM
			EMPLOYEE_POSITIONS
		WHERE
			POSITION_CODE = #get_last_position_name.upper_position_code2#
	</cfquery>
	<cfif get_2.recordcount>
		<cfset ikinci_amir = get_2.ISIM>
		<cfset ikinci_amir_position = get_2.POSITION_NAME>
	<cfelse>
		<cfset ikinci_amir = "">
		<cfset ikinci_amir_position = "">
	</cfif>
<cfelse>
	<cfset ikinci_amir = "">
	<cfset ikinci_amir_position = "">
</cfif>
<table width="700" align="center">
	<tr>
		<td width="150" class="txtbold">Birinci Amir</td>
		<td>#birinci_amir#</td>
		<td width="150" class="txtbold">İkinci Amir</td>
		<td>#ikinci_amir#</td>
	</tr>
	<tr>
		<td width="150" class="txtbold">Pozisyon</td>
		<td>#birinci_amir_position#</td>
		<td width="150" class="txtbold">Pozisyon</td>
		<td>#ikinci_amir_position#</td>
	</tr>
	<tr>
		<td width="150" class="txtbold">Onay</td>
		<td></td>
		<td width="150" class="txtbold">Onay</td>
		<td></td>
	</tr>
</table>
<br/><br/>
<table width="700" align="center">
	<tr>
    	<cfset deger = filterNum(tlFormat(get_puantaj_row.kidem_amount_net + (get_puantaj_row.yillik_izin_amount-(get_puantaj_row.yillik_izin_amount*sgk_isci_payi)-((get_puantaj_row.yillik_izin_amount-ssk_isci_izin_ucreti)*sgk_isci_payi)-(get_puantaj_row.yillik_izin_amount*get_program_parameters.stamp_tax_binde / 1000)) + ihbar_net))>
		<td>Yukarıda Ayrıntıları verilen #deger# TL (<cf_n2txt number="deger"> #deger#) ücretlerimi tamamen teslim aldım.</td>
	</tr>
</table>
<br/>
<br/>
<table width="700" align="center">
	<tr>
		<td width="125" class="txtbold">Adı Soyadı</td>
		<td width="250">#get_in_out.employee_name# #get_in_out.employee_surname#</td>
		<td style="text-align:right;" class="txtbold">İŞVEREN / İŞVEREN VEKİLİ ONAYI</td>
	</tr>
	<tr>
		<td class="txtbold">Tarih</td>
		<td>#dateformat(now(),dateformat_style)#</td>
		<td></td>
	</tr>
	<tr>
		<td class="txtbold">İmza</td>
		<td></td>
		<td></td>
	</tr>
</table>
</cfoutput>