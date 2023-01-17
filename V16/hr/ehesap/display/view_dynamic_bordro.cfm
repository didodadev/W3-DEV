<style>
	.big_list .cls_red td {color:red !important;}
	.big_list .cls_blue td {color:blue !important;}
</style>
<div id="bordro_list_layer">
<cfinclude template="view_dynamic_bordro_groups.cfm">
<cfset day_last = createodbcdatetime(createdate(attributes.sal_year_end,attributes.sal_mon_end,daysinmonth(createdate(attributes.sal_year_end,attributes.sal_mon_end,1))))>
<cfset sayfa_no = 0>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default="#get_puantaj_rows.recordcount#">
<cfif (isdefined("attributes.is_excel") and attributes.is_excel eq 1) or not len(attributes.print_row_count)>
	<cfparam name="attributes.mode" default="#get_puantaj_rows.recordcount#">
<cfelse>
	<cfparam name="attributes.mode" default="#attributes.print_row_count#">
</cfif>
<cfparam name="attributes.totalrecords" default="#get_puantaj_rows.recordcount#">
<cfscript>
	attributes.startrow = ((attributes.page-1) * attributes.maxrows) + 1;

    ssk_isci_hissesi_7252_ = 0;
    ssk_isci_hissesi_7256_ = 0;
    issizlik_isci_hissesi_7252_ = 0;
    issizlik_isci_hissesi_7256_ = 0;
    ISSIZLIK_ISVEREN_HISSESI_7252_ = 0;
    ISSIZLIK_ISVEREN_HISSESI_7256_ = 0;
    ssk_isveren_hissesi_7252_ = 0;
    ssk_isveren_hissesi_7256_ = 0;
    
    d_t_ext_salary_0 = 0;
    d_t_ext_salary_1 = 0;
    d_t_ext_salary_2 = 0;
    d_t_ext_salary_5 = 0;
	t_istisna_odenek = 0;
	t_ssk_matrahi = 0;
	t_gunluk_ucret = 0;
	t_toplam_kazanc = 0;
	t_vergi_indirimi = 0;
	t_sakatlik_indirimi = 0;
	t_kum_gelir_vergisi_matrahi = 0;
	t_gelir_vergisi_matrahi = 0;
	t_gelir_vergisi = 0;
	t_asgari_gecim = 0;
	t_damga_vergisi_matrahi = 0;
	t_damga_vergisi = 0;
    t_damga_vergisi_indirimsiz = 0;
	t_mahsup_g_vergisi = 0;	
	t_h_ici = 0;
	t_h_sonu = 0;
	t_toplam_days = 0;
	t_resmi = 0;	
	t_kesinti = 0;
	t_net_ucret = 0;
	t_vergi_iadesi = 0;
	t_ssk_primi_isci = 0;
	t_ssk_primi_isci_devirsiz = 0;
	t_ssk_primi_isveren_hesaplanan = 0;
	t_ssk_primi_isveren = 0;
	t_ssk_primi_isveren_gov = 0;
	t_ssk_primi_isveren_5510 = 0;
	t_ssk_primi_isveren_5084 = 0;
	t_ssk_primi_isveren_5921 = 0;
	t_ssk_primi_isveren_5746 = 0;
	t_ssk_primi_isveren_4691 = 0;
	t_ssk_primi_isveren_6111 = 0;
	t_ssk_primi_isveren_6486 = 0;
    t_ssk_primi_isveren_46486 = 0;
    t_ssk_primi_isveren_56486 = 0;
    t_ssk_primi_isveren_66486 = 0;
	t_ssk_primi_isveren_6322 = 0;
	t_ssk_primi_isci_6322 = 0;
    t_ssk_primi_isveren_14857 = 0;
    t_ssk_primi_isveren_3294 = 0;
    t_ssk_primi_isveren_6645 = 0;
    t_isci_primi_indirimli = 0;
	t_issizlik_isci_primi_indirimli = 0;
	t_issizlik_isveren_primi_indirimli = 0;
    t_damga_vergisi_indirimsiz = 0;
    t_damga_vergisi_indirimi_5746 = 0;
    t_damga_vergisi_primi_7103 = 0;
    t_stampduty_5746 = 0;
    stampduty_5746_val = 0;
    t_daily_minimum_wage_base_cumulate = 0;
	t_minimum_wage_cumulative  = 0;
	t_daily_minimum_income_tax = 0;
	t_daily_minimum_wage_stamp_tax = 0;
	t_daily_minimum_wage = 0;
    t_income_tax_temp = 0;
    t_stamp_tax_temp = 0;
    d_t_gelir_vergisi_hesaplanan = 0;
    

    d_t_daily_minimum_wage_base_cumulate = 0;
	d_t_minimum_wage_cumulative  = 0;
	d_t_daily_minimum_income_tax = 0;
	d_t_daily_minimum_wage_stamp_tax = 0;
	d_t_daily_minimum_wage = 0;
    d_t_income_tax_temp = 0;
    d_t_stamp_tax_temp = 0;

    //7252
	t_ssk_primi_isveren_7252 = 0;
	t_ssk_primi_isveren_issizlik_7252 = 0;
    t_ssk_isci_hissesi_7252 = 0;
	t_issizlik_isci_hissesi_7252 = 0;
	d_t_ssk_primi_isveren_issizlik_7252 = 0;
    d_t_ssk_primi_isveren_7252 = 0;
	d_t_ssk_isci_hissesi_7252 = 0;
	d_t_issizlik_isci_hissesi_7252 = 0;
    //7256
    t_ssk_primi_isveren_7256 = 0;
	t_ssk_primi_isveren_issizlik_7256 = 0;
    t_ssk_isci_hissesi_7256 = 0;
	t_issizlik_isci_hissesi_7256 = 0;
	d_t_ssk_primi_isveren_issizlik_7256 = 0;
    d_t_ssk_primi_isveren_7256 = 0;
	d_t_ssk_isci_hissesi_7256 = 0;
	d_t_issizlik_isci_hissesi_7256 = 0;

	//687 tesvigi
	t_ssk_isveren_hissesi_687 = 0;
	t_ssk_isci_hissesi_687 = 0;
	t_issizlik_isci_hissesi_687 = 0;
	t_issizlik_isveren_hissesi_687 = 0;
	t_gelir_vergisi_indirimi_687 = 0;
	t_damga_vergisi_indirimi_687 = 0;
	
	//7103 tesvigi
	t_ssk_isveren_hissesi_7103 = 0;
	t_ssk_isci_hissesi_7103 = 0;
	t_issizlik_isci_hissesi_7103 = 0;
	t_issizlik_isveren_hissesi_7103 = 0;
	t_gelir_vergisi_indirimi_7103 = 0;
	t_damga_vergisi_indirimi_7103 = 0;
	
	
	t_toplam_isveren = 0;
	t_toplam_isveren_indirimsiz = 0;
	t_issizlik_isci_hissesi = 0;
	t_issizlik_isveren_hissesi = 0;
	t_kidem_isci_payi = 0;
	t_kidem_isveren_payi = 0;
	t_total_pay_ssk_tax = 0;
	t_total_pay_ssk = 0;
	t_total_pay_tax = 0;
	t_total_pay = 0;
	t_onceki_aydan_devreden_kum_mat = 0;
	t_ozel_kesinti = 0;
    t_ozel_kesinti_2_net = 0;
	t_ozel_kesinti_2_net_fark = 0;
	t_sgk_normal_gun = 0;
	t_ssk_days = 0;
	t_days = 0;
	sayac = (attributes.page - 1) * attributes.maxrows;
	ssk_count = 0;
	t_work_days = 0;
	id_list = '';
	t_ssdf_ssk_days = 0;
	t_izin = 0;
    t_uzaktan_calisma = 0;
	t_izin_paid = 0;
	t_paid_izinli_sunday_count = 0;
	t_sundays = 0;
	t_offdays = 0;
	t_offdays_sundays = 0;
	t_offdays_sundays = 0;
	t_ssdf_sundays = 0;
	t_ssdf_days = 0;
	t_ssdf_izin_days = 0;
	t_ssdf_matrah = 0;
	t_ssdf_isci_hissesi = 0;
	t_ssdf_isveren_hissesi = 0;
	t_aylik_ucret = 0;
	t_aylik = 0;
	t_kanun = 0;
	t_aylik_fazla = 0;
	t_aylik_fazla_mesai_net = 0;
	normal_gun_total = 0;
	haftalik_tatil_total = 0;
	genel_tatil_total = 0;
	izin_total = 0;
	yillik_izin_total = 0;
	mahsup_g_vergisi_ = 0;
	t_maas = 0;
	t_gelir_vergisi_indirimi_5746 = 0;
	t_gelir_vergisi_indirimi_5746_ = 0; //gelir vergisi hesaplanandan dusulmesi icin ayrıldı
	t_gelir_vergisi_indirimi_4691 = 0;
	t_gelir_vergisi_indirimi_4691_ = 0; //gelir vergisi hesaplanandan dusulmesi icin ayrıldı
	t_yillik_izin = 0;
	t_kidem_amount = 0;
	t_ihbar_amount = 0;
	t_vergi_istisna_total = 0;
	t_vergi_istisna_ssk = 0;
	t_vergi_istisna_ssk_net = 0;
	t_vergi_istisna_vergi = 0;
	t_vergi_istisna_vergi_net = 0;
	t_vergi_istisna_damga = 0;
	t_vergi_istisna_damga_net = 0;
	t_devir_fark = 0;
	t_ssk_devir = 0;
	t_ssk_devir_last = 0;
	t_ssk_amount = 0;
	t_onceki_donem_kum_gelir_vergisi_matrahi = 0;
	t_sgk_isci_hissesi_fark = 0;
	t_sgk_issizlik_hissesi_fark = 0;
	t_sgdp_isci_primi_fark = 0;
	gt_hi_saat = 0;
	gt_ht_saat = 0;
	gt_gt_saat = 0;
	gt_paid_izin_saat = 0;
	gt_paid_ht_izin_saat = 0;
	gt_izin_saat = 0;
	gt_toplam_saat = 0;
	gt_gece_mesai_saat = 0;
	dt_izin_saat = 0;
	d_agi_oncesi_net = 0;
	t_agi_oncesi_net = 0;
	t_avans = 0;
	d_t_avans = 0;
	d_t_ssk_matrahi = 0;
	d_t_gunluk_ucret = 0;
	d_t_toplam_kazanc = 0;
	d_t_vergi_indirimi = 0;
	d_t_sakatlik_indirimi = 0;
	d_t_kum_gelir_vergisi_matrahi = 0;
	d_t_gelir_vergisi_matrahi = 0;
	d_t_gelir_vergisi = 0;
	d_t_asgari_gecim = 0;
	d_t_damga_vergisi_matrahi = 0;
	d_t_damga_vergisi = 0;
	d_t_mahsup_g_vergisi = 0;	
	d_t_h_ici = 0;
	d_t_h_sonu = 0;
	d_t_toplam_days = 0;
	d_t_resmi = 0;	
	d_t_kesinti = 0;
	d_t_net_ucret = 0;
	d_t_ssk_primi_isci = 0;
	d_t_bes_isci_hissesi = 0;
	d_t_ssk_primi_isveren_hesaplanan = 0;
	d_t_ssk_primi_isveren = 0;
	d_t_ssk_primi_isveren_gov = 0;
	d_t_ssk_primi_isveren_5510 = 0;
	d_t_ssk_primi_isveren_5084 = 0;
	d_t_ssk_primi_isveren_5921 = 0;
	d_t_ssk_primi_isveren_5746 = 0;
	d_t_ssk_primi_isveren_4691 = 0;
	d_t_ssk_primi_isveren_6111 = 0;
	d_t_ssk_primi_isveren_6486 = 0;
    d_t_ssk_primi_isveren_46486 = 0;
    d_t_ssk_primi_isveren_56486 = 0;
    d_t_ssk_primi_isveren_66486 = 0;
	d_t_ssk_primi_isveren_6322 = 0;
	d_t_ssk_primi_isci_6322 = 0;
    d_t_ssk_primi_isveren_14857 = 0;
    d_t_ssk_primi_isveren_3294 = 0;
    d_t_ssk_primi_isveren_6645 = 0;

	//687 tesvigi
	d_t_ssk_isveren_hissesi_687 = 0;
	d_t_ssk_isci_hissesi_687 = 0;
	d_t_issizlik_isci_hissesi_687 = 0;
	d_t_issizlik_isveren_hissesi_687 = 0;
	d_t_gelir_vergisi_indirimi_687 = 0;
	d_t_damga_vergisi_indirimi_687 = 0;
	
	//7103 tesvigi
	d_t_ssk_isveren_hissesi_7103 = 0;
	d_t_ssk_isci_hissesi_7103 = 0;
	d_t_issizlik_isci_hissesi_7103 = 0;
	d_t_issizlik_isveren_hissesi_7103 = 0;
	d_t_gelir_vergisi_indirimi_7103 = 0;
	d_t_damga_vergisi_indirimi_7103 = 0;
    
	
    d_t_isci_primi_indirimli = 0;
	d_t_issizlik_isci_primi_indirimli = 0;
	d_t_issizlik_isveren_primi_indirimli = 0;
    d_t_damga_vergisi_indirimsiz = 0;
    t_damga_vergisi_indirimi_5746 = 0;
    t_damga_vergisi_primi_7103 = 0;
	d_t_toplam_isveren = 0;
	d_t_toplam_isveren_indirimsiz = 0;
	d_t_issizlik_isci_hissesi = 0;
	d_t_issizlik_isveren_hissesi = 0;
	d_t_kidem_isci_payi = 0;
	d_t_kidem_isveren_payi = 0;
	d_t_total_pay_ssk_tax = 0;
	d_t_total_pay_ssk = 0;
	d_t_total_pay_tax = 0;
	d_t_total_pay = 0;
	d_t_onceki_aydan_devreden_kum_mat = 0;
	d_t_ozel_kesinti = 0;
	d_t_ssk_days = 0;
	d_t_sgk_normal_gun = 0;
	d_t_days = 0;
	d_sayac = 0;
	d_ssk_count = 0;
	d_t_work_days = 0;
	d_id_list = '';
	d_t_ssdf_ssk_days = 0;
	d_t_izin = 0;
    d_t_uzaktan_calisma = 0;
	d_t_izin_paid = 0;
	d_t_paid_izinli_sunday_count = 0;
	d_t_sundays = 0;
	d_t_offdays = 0;
	d_t_offdays_sundays = 0;
	d_t_yillik_izin = 0;
	d_t_offdays_sundays = 0;
	d_t_ssdf_sundays = 0;
	d_t_ssdf_days = 0;
	d_t_ssdf_izin_days = 0;
	d_t_ssdf_matrah = 0;
	d_t_ssdf_isci_hissesi = 0;
	d_t_ssdf_isveren_hissesi = 0;
	d_t_aylik_ucret = 0;
	d_t_aylik = 0;
	d_t_kanun = 0;
	d_t_aylik_fazla = 0;
	d_t_aylik_fazla_mesai_net = 0;
	d_normal_gun_total = 0;
	d_haftalik_tatil_total = 0;
	d_genel_tatil_total = 0;
	d_izin_total = 0;
	d_mahsup_g_vergisi_ = 0;
	d_t_maas = 0;
	d_t_gelir_vergisi_indirimi_5746 = 0;
    d_t_gelir_vergisi_indirimi_5746_ = 0;
    d_t_damga_vergisi_indirimi_5746 = 0;
    d_t_stampduty_5746 = 0;
	d_t_gelir_vergisi_indirimi_4691 = 0;
	d_t_gelir_vergisi_indirimi_4691_ = 0;
	d_yillik_izin_total = 0;
	d_kidem_amount = 0;
	d_ihbar_amount = 0;
	d_vergi_istisna_total = 0;
	d_vergi_istisna_ssk = 0;
	d_vergi_istisna_ssk_net = 0;
	d_vergi_istisna_vergi = 0;
	d_vergi_istisna_vergi_net = 0;
	d_vergi_istisna_damga = 0;
	d_vergi_istisna_damga_net = 0;
	d_t_devir_fark = 0;
	d_t_ssk_devir = 0;
	d_t_ssk_devir_last = 0;
	d_t_ssk_amount = 0;
	d_net_ucret = 0;
	d_vergi_iadesi = 0;
	d_avans = 0;
	d_ozel_kesinti = 0;
	t_hi_saat = 0;
	t_ht_saat = 0;
	t_gt_saat = 0;
	t_paid_izin_saat = 0;
	t_paid_ht_izin_saat = 0;
    t_uzaktan_calisma = 0;
	t_izin = 0;
	t_saat = 0;
	t_gece_mesai_saat = 0;
	d_t_onceki_donem_kum_gelir_vergisi_matrahi = 0;
	d_t_sgk_isci_hissesi_fark = 0;
	d_t_sgk_issizlik_hissesi_fark = 0;
	d_t_sgdp_isci_primi_fark = 0;
	t_sgk_isveren_hissesi=0;
	d_t_sgk_isveren_hissesi=0;
	d_t_ssdf_isveren_hissesi=0;
	aylik_brut_ucret = 0;
	t_aylik_brut_ucret = 0;
	t_bes_isci_hissesi=0;
	maas_=0;
</cfscript>
<cfquery name="GET_EXPENSES" datasource="#iif(fusebox.use_period,"dsn2","dsn")#">
	SELECT 
        EXPENSE, 
        HIERARCHY, 
        EXPENSE_CODE, 
        EXPENSE_ACTIVE 
    FROM 
        EXPENSE_CENTER 
    ORDER BY 
    	EXPENSE_CODE
</cfquery>
<cfset main_expense_list = valuelist(get_expenses.expense_code,';')>
<cfquery name="get_emp_branches" datasource="#DSN#">
	SELECT
		BRANCH_ID
	FROM
		EMPLOYEE_POSITION_BRANCHES
	WHERE
		EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
</cfquery>
<cfset emp_branch_list = valuelist(get_emp_branches.branch_id)>
<cfquery name="get_emp_puantaj_ids" datasource="#dsn#">
        SELECT DISTINCT
			EMPLOYEE_PUANTAJ_ID 
		FROM 
			EMPLOYEES_PUANTAJ_ROWS EPR
			INNER JOIN EMPLOYEES_PUANTAJ EP ON EPR.PUANTAJ_ID = EP.PUANTAJ_ID
			INNER JOIN BRANCH B ON EP.SSK_OFFICE = B.SSK_OFFICE AND EP.SSK_OFFICE_NO = B.SSK_NO
		WHERE 
			(
				(EP.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND EP.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
				OR
				(
					EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
					EP.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
					(
						EP.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> OR
						(EP.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
					)
				)
				OR
				(
					EP.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
					(
						EP.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> OR
						(EP.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
					)
				)
				OR
				(
					EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> AND 
					EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> AND
					EP.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
					EP.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#">
				)
			) 
			<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
				AND B.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.branch_id#">)	
			</cfif>
            <cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
				AND B.COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.comp_id#">)	
			</cfif>
			<cfif not session.ep.ehesap>AND B.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#emp_branch_list#">)</cfif>
</cfquery>
<cfset employee_puantaj_ids = valuelist(get_emp_puantaj_ids.employee_puantaj_id)>
<cfquery name="get_kesintis" datasource="#dsn#">
	SELECT 
		PUANTAJ_ID, 
		EMPLOYEE_PUANTAJ_ID, 
		COMMENT_PAY, 
		PAY_METHOD, 
		AMOUNT_2, 
		AMOUNT, 
		SSK, 
		TAX, 
		EXT_TYPE, 
		ACCOUNT_CODE, 
		AMOUNT_PAY
	FROM 
		EMPLOYEES_PUANTAJ_ROWS_EXT
	WHERE 
		<cfif listlen(employee_puantaj_ids)>EMPLOYEE_PUANTAJ_ID IN (#employee_puantaj_ids#)<cfelse>1=0</cfif> AND 
		EXT_TYPE = 1 
	ORDER BY 
		COMMENT_PAY
</cfquery>
<cfquery name="get_kesinti_adlar" dbtype="query">
	SELECT DISTINCT COMMENT_PAY FROM get_kesintis WHERE COMMENT_PAY <> 'Avans' ORDER BY COMMENT_PAY
</cfquery>
<cfset kesinti_names = listsort(valuelist(get_kesinti_adlar.comment_pay),"text","ASC")>
<cfset count_ = 0>
<cfloop list="#kesinti_names#" index="cc">
	<cfset count_ = count_ + 1>
	<cfset 't_kesinti_#count_#' = 0>
	<cfset 'd_t_kesinti_#count_#' = 0>
</cfloop>
<cfquery name="get_odeneks" datasource="#dsn#">
	SELECT 
		EMPLOYEES_PUANTAJ_ROWS_EXT.PUANTAJ_ID, 
		EMPLOYEES_PUANTAJ_ROWS_EXT.EMPLOYEE_PUANTAJ_ID, 
		EMPLOYEES_PUANTAJ_ROWS_EXT.COMMENT_PAY, 
		EMPLOYEES_PUANTAJ_ROWS_EXT.PAY_METHOD, 
		EMPLOYEES_PUANTAJ_ROWS_EXT.AMOUNT_2, 
		EMPLOYEES_PUANTAJ_ROWS_EXT.AMOUNT, 
		EMPLOYEES_PUANTAJ_ROWS_EXT.SSK, 
		EMPLOYEES_PUANTAJ_ROWS_EXT.TAX, 
		EMPLOYEES_PUANTAJ_ROWS_EXT.EXT_TYPE, 
		EMPLOYEES_PUANTAJ_ROWS_EXT.ACCOUNT_CODE, 
		EMPLOYEES_PUANTAJ_ROWS_EXT.AMOUNT_PAY,
		SETUP_PAYMENT_INTERRUPTION.FROM_SALARY,
		SETUP_PAYMENT_INTERRUPTION.CALC_DAYS
	FROM 
		EMPLOYEES_PUANTAJ_ROWS_EXT LEFT JOIN SETUP_PAYMENT_INTERRUPTION
		ON EMPLOYEES_PUANTAJ_ROWS_EXT.COMMENT_PAY_ID = SETUP_PAYMENT_INTERRUPTION.ODKES_ID
	WHERE 
		<cfif listlen(employee_puantaj_ids)>EMPLOYEE_PUANTAJ_ID IN (#employee_puantaj_ids#)<cfelse>1=0</cfif> AND 
		EXT_TYPE = 0 
	ORDER BY 
		COMMENT_PAY
</cfquery>
<cfquery name="get_odenek_adlar" dbtype="query">
	SELECT DISTINCT COMMENT_PAY FROM get_odeneks
</cfquery>
<cfset odenek_names = listsort(valuelist(get_odenek_adlar.comment_pay),"text","ASC")>
<cfset count_ = 0>
<cfloop list="#odenek_names#" index="cc">
	<cfset count_ = count_ + 1>
	<cfset 't_odenek_#count_#' = 0>
	<cfset 'd_t_odenek_#count_#' = 0>
	<cfset 't_odenek_net_#count_#' = 0>
	<cfset 'd_t_odenek_net_#count_#' = 0>
</cfloop>
<cfquery name="get_vergi_istisna" datasource="#dsn#">
	SELECT 
        VERGI_ISTISNA_AMOUNT,
		VERGI_ISTISNA_TOTAL,
		COMMENT_PAY,
		EMPLOYEE_PUANTAJ_ID,
        AMOUNT
	FROM 
		EMPLOYEES_PUANTAJ_ROWS_EXT
	WHERE 
		<cfif listlen(employee_puantaj_ids)>EMPLOYEE_PUANTAJ_ID IN (#employee_puantaj_ids#)<cfelse>1=0</cfif> AND 
		EXT_TYPE = 2 
	ORDER BY 
		COMMENT_PAY
</cfquery>
<cfquery name="get_vergi_istisna_adlar" dbtype="query">
	SELECT DISTINCT COMMENT_PAY FROM get_vergi_istisna
</cfquery>
<cfset vergi_istisna_names = valuelist(get_vergi_istisna_adlar.comment_pay)>
<cfset count_ = 0>
<cfloop list="#vergi_istisna_names#" index="cc">
	<cfset count_ = count_ + 1>
	<cfset 't_vergi_#count_#' = 0>
	<cfset 'd_t_vergi_#count_#' = 0>
	<cfset 't_vergi_net_#count_#' = 0>
	<cfset 'd_t_vergi_net_#count_#' = 0>
</cfloop>
<cfquery name="get_definition" datasource="#DSN#">
	SELECT
		DEFINITION,
		PAYROLL_ID
	FROM
		SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF
    ORDER BY 
    	PAYROLL_ID
</cfquery>
<cfset def_list = listsort(listdeleteduplicates(valuelist(get_definition.payroll_id,',')),'numeric','ASC',',')>
<!---<cfquery name="get_bank_" datasource="#dsn#">
	SELECT 
		BA.BANK_BRANCH_CODE,
		BA.BANK_ACCOUNT_NO,
		BA.IBAN_NO,
		B.BANK_NAME,
		BA.EMP_BANK_ID
	FROM
		EMPLOYEES_BANK_ACCOUNTS BA,
		SETUP_BANK_TYPES B
	WHERE
		BA.BANK_ID = B.BANK_ID
</cfquery>
<cfset bank_list = listsort(listdeleteduplicates(valuelist(get_bank_.EMP_BANK_ID,',')),'numeric','ASC',',')>
---><cfquery name="get_pay_methods" datasource="#dsn#">
	SELECT 
		SP.PAYMETHOD_ID, 
        SP.PAYMETHOD
	FROM 
		SETUP_PAYMETHOD SP,
		SETUP_PAYMETHOD_OUR_COMPANY SPOC
	WHERE
		SP.PAYMETHOD_STATUS = 1
		AND SP.PAYMETHOD_ID = SPOC.PAYMETHOD_ID 
		AND SPOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfset pay_list = listsort(listdeleteduplicates(valuelist(get_pay_methods.PAYMETHOD_ID,',')),'numeric','ASC',',')>
<cfquery name="get_units" datasource="#DSN#">
	SELECT 
    	UNIT_ID, 
        UNIT_NAME, 
        HIERARCHY 
    FROM 
	    SETUP_CV_UNIT 
    ORDER BY 
    	UNIT_ID
</cfquery>
<cfset fonsiyonel_list = listsort(listdeleteduplicates(valuelist(get_units.unit_id,',')),'numeric','ASC',',')>
<cfquery name="get_position_cats" datasource="#DSN#">
	SELECT 
    	POSITION_CAT_ID, 
        POSITION_CAT,
        HIERARCHY 
    FROM 
    	SETUP_POSITION_CAT 
    ORDER BY 
	    POSITION_CAT_ID
</cfquery>
<cfset position_cat_list = listsort(listdeleteduplicates(valuelist(get_position_cats.POSITION_CAT_ID,',')),'numeric','ASC',',')>
<cfset cmp = createObject("component","V16.hr.ehesap.cfc.employee_puantaj_group")>
<cfset cmp.dsn = dsn/>
<cfset get_groups = cmp.get_groups()>
<cfset puantaj_group_ids_list = listdeleteduplicates(valuelist(get_groups.GROUP_ID,','))>
<cfquery name="get_titles" datasource="#DSN#">
	SELECT 
    	TITLE_ID, 
        TITLE 
    FROM 
	    SETUP_TITLE 
    ORDER BY 
    	TITLE_ID
</cfquery>
<cfset title_list = listsort(listdeleteduplicates(valuelist(get_titles.TITLE_ID,',')),'numeric','ASC',',')>
<cfquery name="get_branchs" datasource="#DSN#">
	SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH ORDER BY BRANCH_ID
</cfquery>
<cfset branch_list = listsort(listdeleteduplicates(valuelist(get_branchs.BRANCH_ID,',')),'numeric','ASC',',')>
<cfquery name="get_departments" datasource="#DSN#">
	SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT ORDER BY DEPARTMENT_ID
</cfquery>
<cfset department_list = listsort(listdeleteduplicates(valuelist(get_departments.DEPARTMENT_ID,',')),'numeric','ASC',',')>
<cfquery name="get_dep_lvl" datasource="#dsn#">
    SELECT DISTINCT LEVEL_NO FROM DEPARTMENT WHERE LEVEL_NO IS NOT NULL ORDER BY LEVEL_NO
</cfquery>
<cfset dep_level_list = listsort(valuelist(get_dep_lvl.level_no),"numeric" ,"ASC")>
<cfif isdefined("attributes.sort_type") and len(attributes.sort_type)>
	<cfset type_ = "type">
<cfelse>
	<cfset type_ = "employee_puantaj_id">
</cfif>

<cfset list1 = attributes.b_obj_sira_hidden>
<cfset list2 = attributes.b_obj_hidden>
<cfset list = ''>
<cfloop index="ind" from="1" to="#listlen(list1)#">
	<cftry>
		<cfset minElement = listFirst(listSort(list1,'numeric','asc'))>
        <cfset minElementIndex = listFindNoCase(list1,minElement)>
        <cfset list = listAppend(list,listGetAt(list2,minElementIndex))>
        <cfset list2 = listDeleteAt(list2,minElementIndex)>
        <cfset list1 = listDeleteAt(list1,minElementIndex)>
    <cfcatch></cfcatch>
    </cftry>
</cfloop>
<cfset attributes.b_obj_hidden_new = list>

<!--- Aynı numaralar verildiği zaman ilk gelen ezilip ekranda gösterilmiyordu. EY 20170207 --->
<!---
<cfset attributes.b_obj_hidden_new = attributes.b_obj_hidden>
<cfloop list="#attributes.b_obj_hidden#" index="ccn">
	<cfset ccn_sira_ = listfindnocase(attributes.b_obj_hidden,ccn)>
	<cfif ccn_sira_ neq 0>
		<cfset ccn_sira_ = listgetat(attributes.b_obj_sira_hidden,ccn_sira_)>
		<cfif ccn_sira_ eq 0 or listlen(attributes.b_obj_hidden_new) lt ccn_sira_>
			<cfset attributes.b_obj_hidden_new = listappend(attributes.b_obj_hidden_new,ccn,',')>
		<cfelse>
			<cfset attributes.b_obj_hidden_new = listsetat(attributes.b_obj_hidden_new,ccn_sira_,ccn,',')>
		</cfif>
	</cfif>
</cfloop>
<cfset attributes.b_obj_hidden_new = listdeleteduplicates(attributes.b_obj_hidden_new)>
--->
<cfset sayfa_count_ = 0>
<cfparam name="attributes.totalrecords" default="#get_puantaj_rows.recordcount#">
<!---<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
	<cfset attributes.startrow=1>
	<cfset attributes.maxrows = get_puantaj_rows.recordcount>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-8">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</cfif>--->
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1><!--- excel secildi ise temp tablo oluşturup kayıtları direk excel e atacak SG2014--->
	<cfset filename="dynamic_bordro#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-16">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
    <meta http-equiv="content-type" content="text/plain; charset=utf-16">
    <cfset attributes.startrow=1>
    <cfset attributes.maxrows = get_puantaj_rows.recordcount>
</cfif>
    <cf_grid_list id="list_tb">
    <cfset sayfa_count_ = sayfa_count_ + 1>
    <cfif ((sayfa_count_ mod attributes.mode eq 1)) or (sayfa_count_ eq 1)>
        <cfset sayfa_no = sayfa_no + 1>
        <cfset cols_plus = 0>
        <thead>
            <tr class="txtbold" align="left">	 
                <cfloop list="#attributes.b_obj_hidden_new#" index="xlr">
                    <cfswitch expression="#xlr#">
                        <cfcase value="b_baslik"><th></th></cfcase>
                        <cfcase value="b_sira_no"><th><cf_get_lang dictionary_id="53109.Sıra No"></th></cfcase>
                        <cfcase value="b_mon_info"><th><cf_get_lang dictionary_id="58650.Puantaj"> <cf_get_lang dictionary_id="58724.Ay"></th></cfcase>
                        <cfcase value="b_year_info"><th><cf_get_lang dictionary_id="58650.Puantaj"> <cf_get_lang dictionary_id="58455.Yıl"></th></cfcase>
                        <cfcase value="b_sgk_no"><th><cf_get_lang dictionary_id ='53237.SSK No'></th></cfcase>
                        <cfcase value="b_ad_soyad"><th nowrap><cf_get_lang dictionary_id ='57570.Adı Soyadı'></th></cfcase>
                        <cfcase value="b_tc_kimlik"><th><cf_get_lang dictionary_id ='58025.TC Kimlik No'></th></cfcase>
                        <cfcase value="b_employee_no"><th><cf_get_lang dictionary_id ='58487.Calisan No'></th></cfcase>
                        <cfcase value="b_statu"><th nowrap><cf_get_lang dictionary_id ='57894.Statü'></th></cfcase>
                        <cfcase value="b_sex"><th nowrap><cf_get_lang dictionary_id ='57764.Cinsiyet'></th></cfcase>
                        <cfcase value="b_ilgili_sirket"><th nowrap><cf_get_lang dictionary_id ='53701.İlgili Şirket'></th></cfcase>
                        <cfcase value="b_sube"><th nowrap><cf_get_lang dictionary_id ='57453.Şube'></th></cfcase>
                        <cfcase value="b_departman">
                            <cfif isdefined('attributes.is_dep_level')>
                                <cfoutput query="get_dep_lvl">
                                    <th nowrap><cf_get_lang dictionary_id='57572.Departman'>(#level_no#)</th>
                                </cfoutput>
                            </cfif>
                            <th nowrap><cf_get_lang dictionary_id='57572.Departman'></th>
                        </cfcase>
                        <cfcase value="b_pozisyon_sube"><th nowrap><cf_get_lang dictionary_id ='53729.Pozisyon Şube'></th></cfcase>
                        <cfcase value="b_pozisyon_departman"><th nowrap><cf_get_lang dictionary_id ='53728.Pozisyon Departman'></th></cfcase>
                        <cfcase value="b_ise_giris"><th nowrap><cf_get_lang dictionary_id ='53702.İşe Giriş '></th></cfcase>
                        <cfcase value="b_isten_cikis"><th nowrap><cf_get_lang dictionary_id ='29832.İşten Çıkış'></th></cfcase>
                        <cfcase value="b_gruba_giris"><th nowrap><cf_get_lang dictionary_id ='53704.Gruba Girişi'></th></cfcase>
                        <cfcase value="b_kidem_date"><th nowrap><cf_get_lang dictionary_id ='53641.Kıdem Baz Tarihi'></th></cfcase>
                        <cfcase value="b_imza"><th width="200"><cf_get_lang dictionary_id='58957.İmza'></th></cfcase>
                        <cfcase value="b_ozel_kod">
                            <th nowrap><cf_get_lang dictionary_id ='57789.Özel Kod'></th>
                            <th nowrap><cf_get_lang dictionary_id ='57789.Özel Kod'>1</th>
                            <th nowrap><cf_get_lang dictionary_id ='57789.Özel Kod'>2</th>
                            <cfif fusebox.dynamic_hierarchy><th nowrap><cf_get_lang dictionary_id='54354.Dinamik Hiyerarşi'></th></cfif>
                        </cfcase>
                        <cfcase value="b_unvan"><th nowrap><cf_get_lang dictionary_id ='57571.Ünvan'></th></cfcase>
                        <cfcase value="b_pozisyon_tipi"><th nowrap><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th></cfcase>
                        <cfcase value="b_collar_type"><th nowrap><cf_get_lang dictionary_id='54054.Yaka Tipi'></th></cfcase>
                        <cfcase value="b_grade_step"><th><cf_get_lang dictionary_id="54179.Derece"> - <cf_get_lang dictionary_id="58710.Kademe"></th></cfcase>
                        <cfcase value="b_pozisyon"><th nowrap><cf_get_lang dictionary_id='53164.Pozisyon'></th></cfcase>
                        <cfcase value="b_org_step"><th><cf_get_lang dictionary_id="58710.Kademe"></th></cfcase>
                        <cfcase value="b_duty_type"><th><cf_get_lang dictionary_id ='58538.Görev Tipi'></th></cfcase>
                        <cfcase value="b_ucret_yontemi"><th><cf_get_lang dictionary_id ='53714.Ücret Yöntemi'></th></cfcase>
                        <cfcase value="b_calisan_grubu"><th><cf_get_lang dictionary_id ='56857.Çalışan Grubu'></th></cfcase>
                        <cfcase value="b_kg"><th><cf_get_lang dictionary_id ='53804.KG'></th></cfcase>
                        <cfcase value="b_ks"><th>KS</th></cfcase>
                        <cfcase value="b_net_brut"><th><cf_get_lang dictionary_id="58083.Net"> / <cf_get_lang dictionary_id="53131.Brüt"></th></cfcase>
                        <cfcase value="b_maas"><th><cf_get_lang dictionary_id="53127.Ücret"></th></cfcase>
                        <cfcase value="b_ss_gunu"><th><cf_get_lang dictionary_id ='53715.SS Günü'></th></cfcase>
                        <cfcase value="b_hs_gunu"><th><cf_get_lang dictionary_id ='53716.HS Günü'></th></cfcase>
                        <cfcase value="b_genel_tatil_gunu"><th><cf_get_lang dictionary_id ='53706.Genel Tatil Günü'></th></cfcase>
                        <cfcase value="b_ucretli_izin"><th><cf_get_lang dictionary_id ='53686.Ücretli İzin'></th></cfcase>
                        <cfcase value="b_ucretli_izin_pazar"><th><cf_get_lang dictionary_id ='53687.Ücretli İzin Pazar'></th></cfcase>
                        <cfcase value="b_ucretsiz_izin"><th><cf_get_lang dictionary_id ='53688.Ücretsiz İzin'></th></cfcase>
                        <cfcase value="b_uzaktan_calisma_gun"><th><cf_get_lang dictionary_id='63061.Uzaktan Çalışma Gün'></th></cfcase>
                        <cfcase value="b_toplam_gun"><th><cf_get_lang dictionary_id="53745.Toplam Gün"></th></cfcase>
                        <cfcase value="b_toplam_calisma_gunu"><th><cf_get_lang dictionary_id ='53727.Çalışma Günü'></th></cfcase>
                        <cfcase value="b_ssk_gunu"><th><cf_get_lang dictionary_id='53816.Toplam SGK Günü'></th></cfcase>
                        <cfcase value="b_idari_amir"><th><cf_get_lang dictionary_id="53705.Birinci Amir"></th></cfcase>
                        <cfcase value="b_exp"><th><cf_get_lang dictionary_id="53882.İşten Çıkış Nedeni"></th></cfcase>
                        <cfcase value="b_reason"><th><cf_get_lang dictionary_id="53643.Şirket İçi Gerekçe"></th></cfcase>
                        <cfcase value="b_ex_in_out_id"><th><cf_get_lang dictionary_id="57554.Giriş"> <cf_get_lang dictionary_id="52990.Gerekçe"></th></cfcase>
                        <cfcase value="b_fonksiyonel_amir"><th><cf_get_lang dictionary_id="53713.İkinci Amir"></th></cfcase>
                        <cfcase value="b_business_code">
                            <th><cf_get_lang dictionary_id="55494.Meslek"> <cf_get_lang dictionary_id="32646.Kodu"></th>
                            <th><cf_get_lang dictionary_id='53861.Meslek Grubu'></th>
                        </cfcase>
                        <cfcase value="b_hi_saat">
                            <th><cf_get_lang dictionary_id ='53715.SS Günü'> (<cf_get_lang dictionary_id="57491.Saat">)</th>
                            <th><cf_get_lang dictionary_id ='53716.HS Günü'> (<cf_get_lang dictionary_id="57491.Saat">)</th>
                            <th><cf_get_lang dictionary_id ='53706.Genel Tatil Günü'> (<cf_get_lang dictionary_id="57491.Saat">)</th>
                            <th><cf_get_lang dictionary_id ='53686.Ücretli İzin'> (<cf_get_lang dictionary_id="57491.Saat">)</th>
                            <th><cf_get_lang dictionary_id ='53687.Ücretli İzin Pazar'> (<cf_get_lang dictionary_id="57491.Saat">)</th>
                            <th><cf_get_lang dictionary_id ='53688.Ücretsiz İzin'> (<cf_get_lang dictionary_id="57491.Saat">)</th>
                            <th><cf_get_lang dictionary_id ="57492.Toplam"> <cf_get_lang dictionary_id="57491.Saat"></th>
                        </cfcase>
                        <cfcase value="b_hafta_ici_mesai"><th><cf_get_lang dictionary_id ='53744.Hafta İçi Mesai'></th></cfcase>
                        <cfcase value="b_hafta_ici_mesai_ucret"><th><cf_get_lang dictionary_id ='53744.Hafta İçi Mesai'><cf_get_lang dictionary_id='55123.Ücret'></th></cfcase>
                        <cfcase value="b_hafta_sonu_mesai"><th><cf_get_lang dictionary_id ='53743.Hafta Sonu Mesai'></th></cfcase>
                        <cfcase value="b_hafta_sonu_mesai_ucret"><th><cf_get_lang dictionary_id ='53743.Hafta Sonu Mesai'><cf_get_lang dictionary_id='55123.Ücret'></th></cfcase>
                        <cfcase value="b_resmi_tatil_mesai"><th><cf_get_lang dictionary_id ='53742.Resmi Tatil Mesai'></th></cfcase>
                        <cfcase value="b_resmi_tatil_mesai_ucret"><th><cf_get_lang dictionary_id ='53742.Resmi Tatil Mesai'><cf_get_lang dictionary_id='55123.Ücret'></th></cfcase>
                        <cfcase value="b_gece_mesai_saat"><th><cf_get_lang dictionary_id='54329.Gece Mesaisi'></th></cfcase>
                        <cfcase value="b_gece_mesai_ucret"><th><cf_get_lang dictionary_id='54329.Gece Mesaisi'><cf_get_lang dictionary_id='55123.Ücret'></th></cfcase>
                        <cfcase value="b_aylik_mesaisiz"><th><cf_get_lang dictionary_id ='53717.Aylık Mesaisiz'></th></cfcase>
                        <cfcase value="b_fazla_mesai"><th><cf_get_lang dictionary_id ='53718.Fazla Mesai'></th></cfcase>
                        <cfcase value="b_fazla_mesai_net"><th><cf_get_lang dictionary_id ='53718.Fazla Mesai'><cf_get_lang dictionary_id="58083.Net"></th></cfcase>
                        <cfcase value="b_gunluk_ucret"><th><cf_get_lang dictionary_id ='53242.Günlük Ücret'></th></cfcase>
                        <cfcase value="b_aylik_ucret"><th><cf_get_lang dictionary_id ='53243.Aylık Ücret'></th></cfcase>
                        <cfcase value="b_aylik_brut_ucret"><th><cf_get_lang dictionary_id="47803.Aylık Brüt Ücret"></th></cfcase>
                        <cfcase value="b_ek_odenek"><th><cf_get_lang dictionary_id ='53082.Ek Ödenek'></th></cfcase>
                        <cfcase value="b_toplam_kazanc"><th><cf_get_lang dictionary_id ='53244.Toplam Kazanç'></th></cfcase>
                        <cfcase value="b_sgk_matrahi"><th><cf_get_lang dictionary_id ='53245.SSK Matrahı'></th></cfcase>
                        <cfcase value="b_sgk_isci_hissesi">
                            <th><cf_get_lang dictionary_id ='53246.SSK İşçi H'></th>
                            <th><cf_get_lang dictionary_id ='47802.SGDP İşçi Hissesi'></th>
                         </cfcase>
                         <cfcase value="b_isci_primi_indirimli">
                            <th><cf_get_lang dictionary_id = "54271.İndirimli"> <cf_get_lang no='773.SGK İşçi Primi'></th>
                         </cfcase>
                        <cfcase value="b_issizlik_isci_hissesi"><th><cf_get_lang dictionary_id="54330.İşsizlik Sigortası İşçi Primi"></th> </cfcase>
                        <cfcase value="b_issizlik_isci_hissesi_indirimli"><th><cf_get_lang no='1325.İndirimli'> <cf_get_lang no='1329.İşsizlik Sigortası İşçi'></th> </cfcase>
                        <cfcase value="b_gelir_vergisi_indirimi"><th><cf_get_lang dictionary_id ='53248.Gelir Vergisi İndirimi'></th></cfcase>
                        <cfcase value="b_gelir_vergisi_matrahi"><th><cf_get_lang dictionary_id ='53249.Gelir Vergisi Matrahı'></th></cfcase>
                        <cfcase value="b_gelir_vergisi_hesaplanan"><th><cf_get_lang dictionary_id ='53689.Gelir Vergisi Hesaplanan'></th></cfcase>
                        <cfcase value="b_asgari_gecim_indirimi"><th><cf_get_lang dictionary_id ='53659.Asgari Geçim İndirimi'></th></cfcase>
                        <cfcase value="b_gelir_vergisi_indirimi_5746"><th><cf_get_lang dictionary_id ='53250.Gelir Vergisi'> <cf_get_lang dictionary_id="54268.İndirimi"> 5746</th></cfcase>
                        <cfcase value="b_gelir_vergisi_indirimi_4691"><th><cf_get_lang dictionary_id ='53250.Gelir Vergisi'> <cf_get_lang dictionary_id="54268.İndirimi"> 4691</th></cfcase>
                        <cfcase value="b_gelir_vergisi"><th><cf_get_lang dictionary_id ='53250.Gelir Vergisi'></th></cfcase>

                        <cfcase value="b_daily_minimum_wage_base_cumulate"><th><cf_get_lang dictionary_id='64700.Asgari Ücrete Göre Gelir Vergi Matrahı'></th></cfcase>
                        <cfcase value="b_daily_minimum_income_tax"><th><cf_get_lang dictionary_id='64702.Asgari Ücret Gelir Vergisi'></th></cfcase>
                        <cfcase value="b_income_tax_temp"><th><cf_get_lang dictionary_id='64746.Asgari Ücret Faydalanılan'></th></cfcase>
                        <cfcase value="b_daily_minimum_wage"><th><cf_get_lang dictionary_id='64703.Asgari Ücret Damga Vergisi Matrahı'></th></cfcase>
                        <cfcase value="b_daily_minimum_wage_stamp_tax"><th><cf_get_lang dictionary_id='64704.Asgari Ücret Damga Vergisi'></th></cfcase>
                        <cfcase value="b_stamp_tax_temp"><th><cf_get_lang dictionary_id='64769.Asgari Ücret Faydalanılan Damga Vergisi'></th></cfcase>
                        <cfcase value="b_minimum_wage_cumulative"><th><cf_get_lang dictionary_id='64700.Asgari Ücrete Göre Gelir Vergi Matrahı'></th></cfcase>
        
                        <cfcase value="b_vergi_indirimi_5615"><th><cf_get_lang dictionary_id ='53690.Vergi İndirimi '> <cfif (attributes.sal_year eq 2007 and attributes.sal_mon gt 6) or attributes.sal_year gte 2008>5615<cfelse>5084</cfif></th></cfcase>
                        <cfcase value="b_kum_gelir_vergisi_matrahi"><th><cf_get_lang dictionary_id ='53251.Küm Gel Ver Matrah'></th></cfcase>
                        <cfcase value="b_damga_vergisi"><th><cf_get_lang dictionary_id ='53252.Damga Vergisi'></th></cfcase>
                        <cfcase value="b_damga_vergisi_indirimsiz"><th><cf_get_lang dictionary_id='30887.İndirimsiz'> <cf_get_lang dictionary_id ='53252.Damga Vergisi'></th></cfcase>
                        <cfcase value="b_damga_vergisi_matrah"><th><cf_get_lang dictionary_id="59363.Damga Vergisi Matrahı"></th></cfcase>
                        <cfcase value="b_toplam_yasal_kesinti"><th><cf_get_lang dictionary_id ='53722.Toplam Yasal Kesinti'></th></cfcase>
                        <cfcase value="b_onceki_aydan_devreden_kum_mat"><th><cf_get_lang dictionary_id='54297.Önceki Aydan Dev Küm Matrah'></th></cfcase>
                        <cfcase value="b_sgk_devir_isci_hissesi_fark"><th><cf_get_lang dictionary_id="54300.SGK Devir Isci Hissesi Fark"></th></cfcase>
                        <cfcase value="b_sgk_devir_issizlik_hissesi_fark"><th><cf_get_lang dictionary_id="54301.SGK Devir Isci Hissesi Fark"></th></cfcase>
                        <cfcase value="b_sgdp_isci_primi_fark"><th><cf_get_lang dictionary_id="54302.SGDP İşçi Primi Fark"></th></cfcase>
                        <cfcase value="b_muhtelif_kesintiler"><th><cf_get_lang dictionary_id ='53254.Muhtelif Kesintiler'></th></cfcase>
                        <cfcase value="b_net_ucret"><th><cf_get_lang dictionary_id ='53255.Net Ücret'></th></cfcase>
                        <cfcase value="b_toplam_net_odenecek"><th><cf_get_lang dictionary_id ='53691.Toplam Net Ödenecek'></th></cfcase>
                        <cfcase value="b_sgk_isveren_primi_hesaplanan">
                            <th><cf_get_lang dictionary_id='53698.SGK İşveren Primi Hesaplanan'></th>
                            <th><cf_get_lang dictionary_id="59364.SGDP İşveren Primi Hesaplanan"></th>
                        </cfcase>
                        <cfcase value="b_muhasebe_kod_group"><th><cf_get_lang dictionary_id='54117.Muhasebe Kod Grubu'></th></cfcase>
                        <cfcase value="b_sgk_5084"><th><cf_get_lang dictionary_id="54331.SGK İşv Primi"> 5084 <cf_get_lang dictionary_id="54268.İndirimi"></th></cfcase>
                        <cfcase value="b_sgk_5763"><th><cf_get_lang dictionary_id="54331.SGK İşv Primi"> 5763 <cf_get_lang dictionary_id="54268.İndirimi"></th></cfcase>
                        <cfcase value="b_sgk_5510"><th><cf_get_lang dictionary_id="54331.SGK İşv Primi"> 5510 <cf_get_lang dictionary_id="54268.İndirimi"></th></cfcase>
                        <cfcase value="b_sgk_5921"><th><cf_get_lang dictionary_id="54331.SGK İşv Primi"> 5921 <cf_get_lang dictionary_id="54268.İndirimi"></th></cfcase>
                        <cfcase value="b_sgk_5746"><th><cf_get_lang dictionary_id="54331.SGK İşv Primi"> 5746 <cf_get_lang dictionary_id="54268.İndirimi"></th></cfcase>
                        <cfcase value="b_sgk_4691"><th><cf_get_lang dictionary_id="54331.SGK İşv Primi"> 4691 <cf_get_lang dictionary_id="54268.İndirimi"></th></cfcase>
                        <cfcase value="b_sgk_6111"><th><cf_get_lang dictionary_id="54331.SGK İşv Primi"> 6111 <cf_get_lang dictionary_id="54268.İndirimi"></th></cfcase>
                        <cfcase value="b_sgk_6486"><th><cf_get_lang dictionary_id="54331.SGK İşv Primi"> 6486 <cf_get_lang dictionary_id="54268.İndirimi"></th></cfcase>
                        <cfcase value="b_sgk_46486"><th><cf_get_lang dictionary_id="54331.SGK İşv Primi"> 46486 <cf_get_lang dictionary_id="54268.İndirimi"></th></cfcase>
                        <cfcase value="b_sgk_56486"><th><cf_get_lang dictionary_id="54331.SGK İşv Primi"> 56486 <cf_get_lang dictionary_id="54268.İndirimi"></th></cfcase>
                        <cfcase value="b_sgk_66486"><th><cf_get_lang dictionary_id="54331.SGK İşv Primi"> 66486 <cf_get_lang dictionary_id="54268.İndirimi"></th></cfcase>
                        <cfcase value="b_sgk_6322"><th><cf_get_lang dictionary_id="54331.SGK İşv Primi"> 6322 <cf_get_lang dictionary_id="54268.İndirimi"></th></cfcase>
                        <cfcase value="b_sgk_14857"><th><cf_get_lang dictionary_id="54331.SGK İşv Primi"> 14857 <cf_get_lang dictionary_id="54268.İndirimi"></th></cfcase>
                        <cfcase value="b_sgk_3294"><th><cf_get_lang dictionary_id="54331.SGK İşv Primi"> 3294 <cf_get_lang dictionary_id="54268.İndirimi"></th></cfcase>
                        <cfcase value="b_sgk_6645"><th><cf_get_lang dictionary_id="54331.SGK İşv Primi"> 6645 <cf_get_lang dictionary_id="54268.İndirimi"></th></cfcase>
                        <cfcase value="b_sgk_7252"><th><cf_get_lang dictionary_id="54331.SGK İşv Primi"> 7252 <cf_get_lang dictionary_id="54268.İndirimi"></th></cfcase>
                        <cfcase value="b_issizlik_sgk_7252"><th><cf_get_lang dictionary_id='59372.İşsizlik İşveren İndirimi'> 7252</th></cfcase>
                        <cfcase value="b_sgk_7256"><th><cf_get_lang dictionary_id="54331.SGK İşv Primi"> 7256 <cf_get_lang dictionary_id="54268.İndirimi"></th></cfcase>
                        <cfcase value="b_issizlik_sgk_7256"><th><cf_get_lang dictionary_id='59372.İşsizlik İşveren İndirimi'> 7256</th></cfcase>

                        <cfcase value="b_sgk_isci_687"><th><cf_get_lang dictionary_id="59368.SGK İşçi Primi İndirimi"> 687</th></cfcase>
                        <cfcase value="b_issizlik_isci_687"><th><cf_get_lang dictionary_id="59369.İssizlik İşçi Primi İndirimi"> 687</th></cfcase>
                        <cfcase value="b_sgk_isci_7252"><th><cf_get_lang dictionary_id="59368.SGK İşçi Primi İndirimi"> 7252</th></cfcase>
                        <cfcase value="b_issizlik_isci_7252"><th><cf_get_lang dictionary_id="59369.İssizlik İşçi Primi İndirimi"> 7256</th></cfcase>
                        <cfcase value="b_sgk_isci_7256"><th><cf_get_lang dictionary_id="59368.SGK İşçi Primi İndirimi"> 7256</th></cfcase>
                        <cfcase value="b_issizlik_isci_7256"><th><cf_get_lang dictionary_id="59369.İssizlik İşçi Primi İndirimi"> 7256</th></cfcase>
                        <cfcase value="b_gelir_verigisi_687"><th><cf_get_lang dictionary_id="53248.Gelir Vergisi İndirimi"> 687</th></cfcase>
                        <cfcase value="b_damga_vergisi_687"><th><cf_get_lang dictionary_id="59370.Damga Vergisi İndirimi"> 687</th></cfcase>
                        <cfcase value="b_sgk_isveren_687"><th><cf_get_lang dictionary_id="59371.SGK İşveren İndirimi"> 687 </th></cfcase>
                        <cfcase value="b_issizlik_isveren_687"><th><cf_get_lang dictionary_id="59372.İşsizlik İşveren İndirimi"> 687</th></cfcase>
                        
                        <cfcase value="b_sgk_isci_7103"><th><cf_get_lang dictionary_id="59368.SGK İşçi Primi İndirimi"> 7103</th></cfcase>
                        <cfcase value="b_issizlik_isci_7103"><th><cf_get_lang dictionary_id="59369.İssizlik İşçi Primi İndirimi"> 7103</th></cfcase>
                        <cfcase value="b_gelir_verigisi_7103"><th><cf_get_lang dictionary_id="53248.Gelir Vergisi İndirimi"> 7103</th></cfcase>
                        <cfcase value="b_damga_vergisi_7103"><th><cf_get_lang dictionary_id="59370.Damga Vergisi İndirimi"> 7103</th></cfcase>
                        <cfcase value="b_sgk_isveren_7103"><th><cf_get_lang dictionary_id="59371.SGK İşveren İndirimi"> 7103</th></cfcase>
                        <cfcase value="b_issizlik_isveren_7103"><th><cf_get_lang dictionary_id="59372.İşsizlik İşveren İndirimi"> 7103</th></cfcase>
                        
                        <cfcase value="b_sgk_isveren_hissesi">
                            <th><cf_get_lang dictionary_id='53256.SGK İşveren Primi'></th>
                            <th><cf_get_lang dictionary_id="54311.SGDP İşveren Primi"></th>
                        </cfcase>
                        <cfcase value="b_toplam_sgk_prim"><th><cf_get_lang dictionary_id="59373.SGK Primi"></th></cfcase>
                        <cfcase value="b_bes_isci_hissesi"><th><cf_get_lang dictionary_id="59374.BES Katılım Payı"></th></cfcase>
                        <cfcase value="b_issizlik_isveren_hissesi"><th><cf_get_lang dictionary_id ='53257.İşsizlik Sigortası İşveren Primi'></th></cfcase>
                        <cfcase value="b_issizlik_isveren_hissesi_indirimli"><th><cf_get_lang no='1325.İndirimli'> <cf_get_lang no='250.İşsizlik Sigortası'> <cf_get_lang no='604.İşveren'></th></cfcase>
                        <cfcase value="b_yillik_izin_tutari"><th><cf_get_lang dictionary_id ='53393.Yıllık İzin Tutarı'></th></cfcase>
                        <cfcase value="b_kidem_tazminati"><th><cf_get_lang dictionary_id="52991.Kıdem Tazminatı"></th></cfcase>
                        <cfcase value="b_ihbar_tazminati"><th><cf_get_lang dictionary_id="52992.İhbar Tazminatı"></th></cfcase>
                        <cfcase value="b_toplam_isveren_maliyeti"><th><cf_get_lang dictionary_id ='53708.Toplam İşveren Maliyeti'></th></cfcase>
                        <cfcase value="b_toplam_isveren_maliyeti_indirimsiz"><th><cf_get_lang dictionary_id ='59378.Toplam İşveren Maliyeti İndirimsiz'></th></cfcase>
                        <cfcase value="b_ucret_tipi"><th><cf_get_lang dictionary_id ='53238.Ücret Tipi'></th></cfcase>
                        <cfcase value="b_odeme_metodu"><th><cf_get_lang dictionary_id ='53557.Ödeme Metodu'></th></cfcase>
                        <cfcase value="b_fonksiyon"><th><cf_get_lang dictionary_id='58701.Fonksiyon'></th></cfcase>
                        <cfcase value="b_vergi_istisna_toplam"><th><cf_get_lang dictionary_id="53017.Vergi İstisnası"> <cf_get_lang dictionary_id="57492.Toplam"></th></cfcase>
                        <cfcase value="b_vergi_istisna_sgk"><th><cf_get_lang dictionary_id="53017.Vergi İstisnası"> <cf_get_lang dictionary_id="58714.SGK"></th></cfcase>
                        <cfcase value="b_vergi_istisna_sgk_net"><th><cf_get_lang dictionary_id="53017.Vergi İstisnası"> <cf_get_lang dictionary_id="58714.SGK"> <cf_get_lang dictionary_id="58083.Net"></th></cfcase>
                        <cfcase value="b_vergi_istisna_vergi"><th><cf_get_lang dictionary_id="53017.Vergi İstisnası"> <cf_get_lang dictionary_id="53332.Vergi"> </th></cfcase>
                        <cfcase value="b_vergi_istisna_vergi_net"><th><cf_get_lang dictionary_id="53017.Vergi İstisnası"> <cf_get_lang dictionary_id="53332.Vergi"> <cf_get_lang dictionary_id="58083.Net"></th></cfcase>
                        <cfcase value="b_vergi_istisna_damga"><th><cf_get_lang dictionary_id="53017.Vergi İstisnası"> <cf_get_lang dictionary_id="54121.Damga"></th></cfcase>
                        <cfcase value="b_vergi_istisna_damga_net"><th><cf_get_lang dictionary_id="53017.Vergi İstisnası"> <cf_get_lang dictionary_id="54121.Damga"> <cf_get_lang dictionary_id="58083.Net"></th></cfcase>
                        <cfcase value="b_ek_odenekler">
                        <cfloop list="#odenek_names#" index="cca">
                            <th><cfoutput>#cca#</cfoutput></th>
                            <cfif x_payment_type eq 1>
                                <th><cfoutput>#cca#</cfoutput> <cf_get_lang dictionary_id="29981.Tanımlanan"></th>
                            </cfif>
                        </cfloop>
                        </cfcase>
                        <cfcase value="b_kesintiler">
                            <th><cf_get_lang dictionary_id="58204.Avans"></th>
                            <cfloop list="#kesinti_names#" index="cca">
                                <th><cfoutput>#cca#</cfoutput></th>
                            </cfloop>
                        </cfcase>
                        <cfcase value="b_vergi_istisna">
                            <cfloop list="#vergi_istisna_names#" index="cca">
                                <th><cfoutput>#cca#</cfoutput></th>
                                <th><cfoutput>#cca#</cfoutput> <cf_get_lang dictionary_id="58083.Net"></th>
                            </cfloop>
                        </cfcase>
                        <cfcase value="b_masraf_merkezi"><th><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th></cfcase>
                        <cfcase value="b_masraf_merkezi_kodu"><th><cf_get_lang dictionary_id ='53747.Masraf Merkezi Kodu'></th></cfcase>
                        <cfcase value="b_muhasebe_kodu"><th><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></th></cfcase>
                        <cfcase value="b_banka"><th><cf_get_lang dictionary_id="57521.Banka"> <cf_get_lang dictionary_id="57897.Adı"></th></cfcase>
                        <cfcase value="b_hesap_no"><th><cf_get_lang dictionary_id="58178.Hesap No"></th></cfcase>
                        <cfcase value="b_iban_no"><th><cf_get_lang dictionary_id="54332.IBAN No"></th></cfcase>
                        <cfcase value="b_toplam_devreden_sgk_matrahi"><th><cf_get_lang dictionary_id="54333.Toplam Devreden SGK Matrahı"></th></cfcase>
                        <cfcase value="b_2_onceki_aydan_devreden_sgk_matrahi"><th><cf_get_lang dictionary_id="54334.İki Önceki Aydan Devreden SGK Matrahı"></th></cfcase>
                        <cfcase value="b_1_onceki_aydan_devreden_sgk_matrahi"><th><cf_get_lang dictionary_id="54335.Bir Önceki Aydan Devreden SGK Matrahı"></th></cfcase>
                        <cfcase value="b_buaydan_devreden_sgk_matrahi"><th><cf_get_lang dictionary_id="59375.Bu Aydan Devreden SGK Matrahı"></th></cfcase>
                        <cfcase value="b_kesinti_ve_agi_oncesi_net"><th><cf_get_lang dictionary_id="54310.Kesinti ve AGİ Öncesi Net"></th></cfcase>
                    </cfswitch>
                </cfloop>
            </tr>
        </thead>
    </cfif>
    <tbody>
        <cfoutput query="get_puantaj_rows" group="#type_#" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">            
            <cfoutput>
                <cfquery name="get_remote_day" datasource="#dsn#">
                    SELECT RWD.* FROM
                        REMOTE_WORKING_DAY RWD
                    WHERE
                        RWD.PERIOD_YEAR = #ROW_SAL_YEAR# AND
                        RWD.IN_OUT_ID = #IN_OUT_ID#
                </cfquery>
                <cfset attributes.employee_id = get_puantaj_rows.EMPLOYEE_ID>
                <cfquery name="get_this_istisna" dbtype="query">
                    SELECT SUM(VERGI_ISTISNA_AMOUNT) AS VERGI_ISTISNA_AMOUNT FROM get_vergi_istisna WHERE EMPLOYEE_PUANTAJ_ID IN (#EMPLOYEE_PUANTAJ_ID#) AND VERGI_ISTISNA_AMOUNT IS NOT NULL
                </cfquery>
                <cfscript>
                    t_istisna_odenek = 0;
                    if(len(ssk_isveren_hissesi_3294))
                        ssk_isveren_hissesi_3294_ = ssk_isveren_hissesi_3294;
                    else
                        ssk_isveren_hissesi_3294_ = 0;
					if (get_this_istisna.recordcount)
						t_istisna_odenek = get_this_istisna.vergi_istisna_amount;
                    if(isdefined("attributes.list_type") and attributes.list_type eq 1)
                    {
                        if(Len(evaluate("get_puantaj_rows.M#get_puantaj_rows.row_sal_mon#")))
                        {
                            maas_ = evaluate("get_puantaj_rows.M#get_puantaj_rows.row_sal_mon#");
                            //t_istisna_odenek = 0;
                        }
                    }
                    else
                    {
                        if(listlen(get_puantaj_rows.row_sal_mon))
                        {
                            for(ind = 1; ind lte listlen(get_puantaj_rows.row_sal_mon); ind++)
                            {
                                maas_ = maas_ + evaluate("get_puantaj_rows.M#listgetat(get_puantaj_rows.row_sal_mon,ind)#");
                            }
                            //t_istisna_odenek = 0;
                        }
                    }
                    sgk_isci_hissesi_fark = 0;
                    sgk_issizlik_hissesi_fark = 0;
                    sgdp_isci_primi_fark = 0;
                    _issizlik_isci_hissesi_devirsiz = 0;
                    sayac = sayac+1;
                    if (SALARY_TYPE eq 2)
                    {
                        aylik = SALARY;
                        t_aylik_ucret = t_aylik_ucret + SALARY;
                        d_t_aylik_ucret = d_t_aylik_ucret + SALARY;
                    }
                    else if (SALARY_TYPE eq 1)
                    {
                        aylik = (SALARY*30);
                        t_aylik_ucret = t_aylik_ucret + (SALARY*30);
                        d_t_aylik_ucret = d_t_aylik_ucret + (SALARY*30);
                    }
                    else if (SALARY_TYPE eq 0)
                    {
                        aylik = (SALARY*SSK_WORK_HOURS*30);
                        t_aylik_ucret = t_aylik_ucret + (SALARY*SSK_WORK_HOURS*30);
                        d_t_aylik_ucret = d_t_aylik_ucret + (SALARY*SSK_WORK_HOURS*30);
                    } 
                    if(len(weekly_hour))
                        t_hi_saat = t_hi_saat + weekly_hour;
                    if(len(weekend_hour))
                        t_ht_saat = t_ht_saat + weekend_hour;
                    if(len(offdays_count_hour))
                        t_gt_saat = t_gt_saat + offdays_count_hour;					
                    if(len(paid_izinli_sunday_count_hour))
                        t_paid_ht_izin_saat = t_paid_ht_izin_saat + paid_izinli_sunday_count_hour;
                    t_saat = weekly_hour + weekend_hour + offdays_count_hour + izin_paid_count + paid_izinli_sunday_count_hour - paid_izinli_sunday_count_hour;
                    gt_hi_saat = gt_hi_saat + t_hi_saat;								
                    gt_ht_saat = gt_ht_saat + t_ht_saat;								
                    gt_gt_saat = gt_gt_saat + t_gt_saat;								
                    gt_paid_ht_izin_saat = gt_paid_ht_izin_saat + t_paid_ht_izin_saat;	
                    gt_toplam_saat = gt_toplam_saat + t_saat;						
                    gt_gece_mesai_saat = gt_gece_mesai_saat + EXT_TOTAL_HOURS_5;
                    t_gece_mesai_saat = t_gece_mesai_saat + EXT_TOTAL_HOURS_5;
                    t_paid_izin_saat = t_paid_izin_saat + izin_paid_count-paid_izinli_sunday_count_hour;
                    gt_paid_izin_saat = gt_paid_izin_saat + izin_paid_count-paid_izinli_sunday_count_hour;			
                    t_izin = t_izin + izin;

                    if(isdefined("get_remote_day.M#ROW_SAL_MON#") and len(evaluate("get_remote_day.M#ROW_SAL_MON#")))
                    {
                        t_uzaktan_calisma = t_uzaktan_calisma + evaluate("get_remote_day.M#ROW_SAL_MON#");
                        d_t_izin = d_t_izin + izin;
                        d_t_uzaktan_calisma = d_t_uzaktan_calisma + evaluate("get_remote_day.M#ROW_SAL_MON#");
                    }
                    gt_izin_saat = gt_izin_saat + izin_count;	
                    dt_izin_saat = dt_izin_saat + izin_count;			
   			
                    onceki_donem_kum_gelir_vergisi_matrahi = KUMULATIF_GELIR_MATRAH - gelir_vergisi_matrah;
                    if(onceki_donem_kum_gelir_vergisi_matrahi lt 0)
                        onceki_donem_kum_gelir_vergisi_matrahi = 0;
                    
                    /*122431 ID'li iş kaydı için kapatıldı. Doğruluğu teyit edildikten sonra silinecek.
                        if(len(CUMULATIVE_TAX_TOTAL) and isnumeric(START_CUMULATIVE_TAX) and ROW_SAL_YEAR eq year(start_date))
						    onceki_donem_kum_gelir_vergisi_matrahi = onceki_donem_kum_gelir_vergisi_matrahi + CUMULATIVE_TAX_TOTAL;
					*/
            
                    //t_toplam_kazanc = t_toplam_kazanc + total_salary+VERGI_ISTISNA_AMOUNT;
                    //t_toplam_kazanc = t_toplam_kazanc + TOTAL_SALARY -VERGI_ISTISNA_SSK;
                    t_toplam_kazanc = t_toplam_kazanc + (total_salary-VERGI_ISTISNA_SSK-VERGI_ISTISNA_VERGI+VERGI_ISTISNA_AMOUNT_);
                    t_vergi_indirimi = t_vergi_indirimi + vergi_indirimi;
                    t_sakatlik_indirimi = t_sakatlik_indirimi + sakatlik_indirimi;
                    t_kum_gelir_vergisi_matrahi =  t_kum_gelir_vergisi_matrahi + KUMULATIF_GELIR_MATRAH ;
                    
                    /*122431 ID'li iş kaydı için kapatıldı. Doğruluğu teyit edildikten sonra silinecek.
                        if(len(CUMULATIVE_TAX_TOTAL) and isnumeric(START_CUMULATIVE_TAX) and ROW_SAL_YEAR eq year(start_date))
                            t_kum_gelir_vergisi_matrahi = t_kum_gelir_vergisi_matrahi + CUMULATIVE_TAX_TOTAL;
                    */  

                    t_onceki_donem_kum_gelir_vergisi_matrahi = t_onceki_donem_kum_gelir_vergisi_matrahi + onceki_donem_kum_gelir_vergisi_matrahi;
                    t_gelir_vergisi_matrahi = t_gelir_vergisi_matrahi + gelir_vergisi_matrah;
                    t_gelir_vergisi = t_gelir_vergisi + gelir_vergisi;
                    if(len(gelir_vergisi_indirimi_687))
                        t_gelir_vergisi = t_gelir_vergisi - gelir_vergisi_indirimi_687;
                    if(len(gelir_vergisi_indirimi_7103))
                        t_gelir_vergisi = t_gelir_vergisi - gelir_vergisi_indirimi_7103;
                    t_asgari_gecim = t_asgari_gecim + vergi_iadesi;

                    if(len(income_tax_temp))
			            t_income_tax_temp = t_income_tax_temp + income_tax_temp;
                    if(len(stamp_tax_temp))
                        t_stamp_tax_temp = t_stamp_tax_temp + stamp_tax_temp;
                    if(len(daily_minimum_wage_base_cumulate))
                        t_daily_minimum_wage_base_cumulate = t_daily_minimum_wage_base_cumulate + daily_minimum_wage_base_cumulate;
                    if(len(minimum_wage_cumulative ))
                        t_minimum_wage_cumulative  = t_minimum_wage_cumulative  + minimum_wage_cumulative ;
                    if(len(daily_minimum_income_tax))
                        t_daily_minimum_income_tax = t_daily_minimum_income_tax + daily_minimum_income_tax;
                    if(len(daily_minimum_wage_stamp_tax))
                        t_daily_minimum_wage_stamp_tax = t_daily_minimum_wage_stamp_tax + daily_minimum_wage_stamp_tax;
                    if(len(daily_minimum_wage))
                        t_daily_minimum_wage = t_daily_minimum_wage + daily_minimum_wage;

                    if(len(stamp_tax_temp))
			            d_t_stamp_tax_temp = d_t_stamp_tax_temp + stamp_tax_temp;
                    if(len(income_tax_temp))
			            d_t_income_tax_temp = d_t_income_tax_temp + income_tax_temp;
                    if(len(daily_minimum_wage_base_cumulate))
                        d_t_daily_minimum_wage_base_cumulate = d_t_daily_minimum_wage_base_cumulate + daily_minimum_wage_base_cumulate;
                    if(len(minimum_wage_cumulative ))
                        d_t_minimum_wage_cumulative  = d_t_minimum_wage_cumulative  + minimum_wage_cumulative ;
                    if(len(daily_minimum_income_tax))
                        d_t_daily_minimum_income_tax = d_t_daily_minimum_income_tax + daily_minimum_income_tax;
                    if(len(daily_minimum_wage_stamp_tax))
                        d_t_daily_minimum_wage_stamp_tax = d_t_daily_minimum_wage_stamp_tax + daily_minimum_wage_stamp_tax;
                    if(len(daily_minimum_wage))
                        d_t_daily_minimum_wage = d_t_daily_minimum_wage + daily_minimum_wage;
                    
                    d_t_toplam_kazanc = d_t_toplam_kazanc + total_salary+VERGI_ISTISNA_AMOUNT;
                    d_t_vergi_indirimi = d_t_vergi_indirimi + vergi_indirimi;
                    d_t_sakatlik_indirimi = d_t_sakatlik_indirimi + sakatlik_indirimi;
                    d_t_kum_gelir_vergisi_matrahi = d_t_kum_gelir_vergisi_matrahi + KUMULATIF_GELIR_MATRAH;
                    d_t_onceki_donem_kum_gelir_vergisi_matrahi = d_t_onceki_donem_kum_gelir_vergisi_matrahi + onceki_donem_kum_gelir_vergisi_matrahi;
                    d_t_gelir_vergisi_matrahi = d_t_gelir_vergisi_matrahi + gelir_vergisi_matrah;
                    d_t_gelir_vergisi = d_t_gelir_vergisi + gelir_vergisi;
                    if(len(gelir_vergisi_indirimi_687))
                        d_t_gelir_vergisi = d_t_gelir_vergisi - gelir_vergisi_indirimi_687;
                    if(len(gelir_vergisi_indirimi_7103))
                        d_t_gelir_vergisi = d_t_gelir_vergisi - gelir_vergisi_indirimi_7103;
                    d_t_asgari_gecim = d_t_asgari_gecim + vergi_iadesi;
                    
                    if(not len(mahsup_g_vergisi))
                        mahsup_g_vergisi_ = 0;
                    else 
                        mahsup_g_vergisi_ = mahsup_g_vergisi;
                        
                    t_mahsup_g_vergisi = t_mahsup_g_vergisi + mahsup_g_vergisi_;
                    t_gelir_vergisi_indirimi_5746 = t_gelir_vergisi_indirimi_5746 + gelir_vergisi_indirimi_5746;
                    if(is_5746_control eq 0) //arge indiriminin gelir vergisinden düşülmemesi ile ilgili toplam icmal icin eklendi //SG 20140306
                    {                
                        t_gelir_vergisi_indirimi_5746_ = t_gelir_vergisi_indirimi_5746_ + gelir_vergisi_indirimi_5746;
                    }
                    if(len(damga_vergisi_indirimi_5746) and damga_vergisi_indirimi_5746 gt 0)
                    {
                        t_damga_vergisi_indirimi_5746 = t_damga_vergisi_indirimi_5746 + damga_vergisi_indirimi_5746;
                    }
                    if(len(stampduty_5746) and stampduty_5746 gt 0)
                    {
                        t_stampduty_5746 = t_stampduty_5746 + stampduty_5746;
                        stampduty_5746_val = stampduty_5746;
                    }

                    if(len(gelir_vergisi_indirimi_4691))
                        t_gelir_vergisi_indirimi_4691 = t_gelir_vergisi_indirimi_4691 + gelir_vergisi_indirimi_4691;
				    if(is_4691_control eq 0) //arge indiriminin gelir vergisinden düşülmemesi ile ilgili toplam icmal icin eklendi
                    {                
                        t_gelir_vergisi_indirimi_4691_ = t_gelir_vergisi_indirimi_4691_ + gelir_vergisi_indirimi_4691;
                    }
                    t_damga_vergisi_matrahi = t_damga_vergisi_matrahi + damga_vergisi_matrah;
                    
                    if(attributes.sal_year lte 2021)
                    {
                        damga_vergisi_ = damga_vergisi;
                    }
                    else if(damga_vergisi gt 0)
                    {
                        damga_vergisi_ = wrk_round(damga_vergisi + daily_minimum_wage_stamp_tax);
                    }
                    else if(damga_vergisi eq 0 and stamp_tax_temp gt 0)
                    {
                        damga_vergisi_ = stamp_tax_temp;
                    }
                    else
                        damga_vergisi_ = 0;
                    
                      
                    t_damga_vergisi = t_damga_vergisi + damga_vergisi;
                    if(len(damga_vergisi_indirimi_687))
                        t_damga_vergisi = t_damga_vergisi-damga_vergisi_indirimi_687;
                    if(len(damga_vergisi_indirimi_7103))
                        t_damga_vergisi = t_damga_vergisi - damga_vergisi_indirimi_7103;

                    t_damga_vergisi_indirimsiz = t_damga_vergisi_indirimsiz + damga_vergisi_;
                    if(len(damga_vergisi_indirimi_687))
                        t_damga_vergisi_indirimsiz = t_damga_vergisi_indirimsiz - damga_vergisi_indirimi_687;
                    if(len(damga_vergisi_indirimi_7103))
                        t_damga_vergisi_indirimsiz = t_damga_vergisi_indirimsiz - damga_vergisi_indirimi_7103;

                    t_kesinti = t_kesinti + (ssk_isci_hissesi + ssdf_isci_hissesi + gelir_vergisi + damga_vergisi + issizlik_isci_hissesi);
                    t_net_ucret = t_net_ucret + net_ucret;
                    t_vergi_iadesi = t_vergi_iadesi + vergi_iadesi;
                    t_kidem_isveren_payi = t_kidem_isveren_payi + kidem_boss;
                    t_kidem_isci_payi = t_kidem_isci_payi + kidem_worker;
                    t_total_pay_ssk_tax = t_total_pay_ssk_tax + total_pay_ssk_tax;
                    t_total_pay_ssk = t_total_pay_ssk + total_pay_ssk;
                    t_total_pay_tax = t_total_pay_tax + total_pay_tax;
                    t_total_pay = t_total_pay + total_pay;
                    t_ozel_kesinti = t_ozel_kesinti + ozel_kesinti;

                    if(len(ozel_kesinti_2_net))
                        t_ozel_kesinti_2_net = t_ozel_kesinti_2_net + ozel_kesinti_2_net;
                    if(len(OZEL_KESINTI_2_NET_FARK))
                        t_ozel_kesinti_2_net_fark = t_ozel_kesinti_2_net_fark + OZEL_KESINTI_2_NET_FARK;

                    d_t_mahsup_g_vergisi = d_t_mahsup_g_vergisi + mahsup_g_vergisi_;
                    d_t_gelir_vergisi_indirimi_5746 = d_t_gelir_vergisi_indirimi_5746 + gelir_vergisi_indirimi_5746;
                    if(is_5746_control eq 0) //arge indiriminin gelir vergisinden düşülmemesi ile ilgili toplam icmal icin eklendi //SG 20140306
                    {
                        d_t_gelir_vergisi_indirimi_5746_ = d_t_gelir_vergisi_indirimi_5746_ + gelir_vergisi_indirimi_5746;
                    }
                    if(len(damga_vergisi_indirimi_5746) and damga_vergisi_indirimi_5746 gt 0)
                    {
                        d_t_damga_vergisi_indirimi_5746 = d_t_damga_vergisi_indirimi_5746 + damga_vergisi_indirimi_5746;
                    }
                    if(len(stampduty_5746) and stampduty_5746 gt 0)
                    {
                        d_t_stampduty_5746 = d_t_stampduty_5746 + stampduty_5746;
                    }

                    if(len(gelir_vergisi_indirimi_4691))
                        d_t_gelir_vergisi_indirimi_4691 = d_t_gelir_vergisi_indirimi_4691 + gelir_vergisi_indirimi_4691;
                    if(is_4691_control eq 0) //arge indiriminin gelir vergisinden düşülmemesi ile ilgili toplam icmal icin eklendi
                    {
                        d_t_gelir_vergisi_indirimi_4691_ = d_t_gelir_vergisi_indirimi_4691_ + gelir_vergisi_indirimi_4691;
                    }
                    d_t_damga_vergisi_matrahi = d_t_damga_vergisi_matrahi + damga_vergisi_matrah;             	
                    d_t_damga_vergisi = d_t_damga_vergisi + damga_vergisi;
                    if(len(damga_vergisi_indirimi_687))
                        d_t_damga_vergisi = d_t_damga_vergisi - damga_vergisi_indirimi_687;
                    if(len(damga_vergisi_indirimi_7103))
                        d_t_damga_vergisi = d_t_damga_vergisi - damga_vergisi_indirimi_7103;

                    d_t_damga_vergisi_indirimsiz = d_t_damga_vergisi_indirimsiz + damga_vergisi_;
                    if(len(damga_vergisi_indirimi_687))
                        d_t_damga_vergisi_indirimsiz = d_t_damga_vergisi_indirimsiz - damga_vergisi_indirimi_687;
                    if(len(damga_vergisi_indirimi_7103))
                        d_t_damga_vergisi_indirimsiz = d_t_damga_vergisi_indirimsiz - damga_vergisi_indirimi_7103;

                    d_t_kesinti = d_t_kesinti + (ssk_isci_hissesi + ssdf_isci_hissesi + gelir_vergisi + damga_vergisi_ + issizlik_isci_hissesi);
                    d_t_net_ucret = d_t_net_ucret + net_ucret;
                    d_t_kidem_isveren_payi = d_t_kidem_isveren_payi + kidem_boss;
                    d_t_kidem_isci_payi = d_t_kidem_isci_payi + kidem_worker;
                    d_t_total_pay_ssk_tax = d_t_total_pay_ssk_tax + total_pay_ssk_tax;
                    d_t_total_pay_ssk = d_t_total_pay_ssk + total_pay_ssk;
                    d_t_total_pay_tax = d_t_total_pay_tax + total_pay_tax;
                    d_t_total_pay = d_t_total_pay + total_pay;
                    d_t_ozel_kesinti = d_t_ozel_kesinti + ozel_kesinti;
                    
                    if (len(OFFDAYS_COUNT)) 
                        OFFDAYS_COUNT_ = OFFDAYS_COUNT;
                    else
                        OFFDAYS_COUNT_ = 0;
                    if (len(OFFDAYS_SUNDAY_COUNT)) 
                        OFFDAYS_SUNDAY_COUNT_ = OFFDAYS_SUNDAY_COUNT;
                    else
                        OFFDAYS_SUNDAY_COUNT_ = 0;
                    
                    t_offdays = t_offdays + OFFDAYS_COUNT_;
                    t_offdays_sundays = t_offdays_sundays + OFFDAYS_SUNDAY_COUNT_;
                    t_paid_izinli_sunday_count = t_paid_izinli_sunday_count + paid_izinli_sunday_count;
                    t_sundays = t_sundays + sunday_count;
                    t_kanun = t_kanun + VERGI_INDIRIMI_5084;
                    //t_maas = t_maas + maas;
                    t_maas = t_maas + maas_;
                    
                    d_t_offdays = d_t_offdays + OFFDAYS_COUNT_;
                    d_t_offdays_sundays = d_t_offdays_sundays + OFFDAYS_SUNDAY_COUNT_;
                    d_t_paid_izinli_sunday_count = d_t_paid_izinli_sunday_count + paid_izinli_sunday_count;
                    d_t_sundays = d_t_sundays + sunday_count;
                    d_t_kanun = d_t_kanun + VERGI_INDIRIMI_5084;
                    //d_t_maas = d_t_maas + maas;
                    d_t_maas = d_t_maas + maas_;
            
                    ssk_devir_toplam = 0;
            
                    if(len(trim(ssk_devir)))
                    {
                        ssk_devir_ = ssk_devir;
                        ssk_devir_toplam = ssk_devir_toplam + ssk_devir;
                    }
                    else
                       { ssk_devir_ = 0;}
                        
                    if(len(trim(ssk_devir_last)))
                    {
                        ssk_devir_last_ = ssk_devir_last;
                        ssk_devir_toplam = ssk_devir_toplam + ssk_devir_last;
                    }
                    else
                       { ssk_devir_last_ = 0;}
                        
                    if(len(trim(ssk_devir)))
                    { 
                        d_t_ssk_devir = d_t_ssk_devir + ssk_devir;
                        t_ssk_devir = t_ssk_devir + ssk_devir;
                    }
                    if(len(trim(ssk_devir_last)))
                    {
                        d_t_ssk_devir_last = d_t_ssk_devir_last + ssk_devir_last;
                        t_ssk_devir_last = t_ssk_devir_last + ssk_devir_last;
                    }
                    d_t_ssk_amount = d_t_ssk_amount + ssk_amount; 
                    
                    t_ssk_amount =  t_ssk_amount + ssk_amount;
					
					d_t_bes_isci_hissesi = d_t_bes_isci_hissesi + bes_isci_hissesi;
					t_bes_isci_hissesi = t_bes_isci_hissesi + bes_isci_hissesi;
                    
                    if (ssdf_isci_hissesi gt 0)
                    {
                        t_ssdf_ssk_days = t_ssdf_ssk_days + total_days;
                        t_ssdf_days = t_ssdf_days + total_days - sunday_count;
                        t_ssdf_matrah = t_ssdf_matrah + SSK_MATRAH;
                        t_ssdf_isci_hissesi = t_ssdf_isci_hissesi + ssdf_isci_hissesi;
                        t_ssdf_isveren_hissesi = t_ssdf_isveren_hissesi + ssdf_isveren_hissesi;
                        isveren_b_5510_ = 0;
                        ssk_isveren_hissesi_5510_ = 0;
                        
                        d_t_ssdf_ssk_days = d_t_ssdf_ssk_days + total_days;
                        d_t_ssdf_days = d_t_ssdf_days + total_days - sunday_count;
                        d_t_ssdf_matrah = d_t_ssdf_matrah + SSK_MATRAH;
                        d_t_ssdf_isci_hissesi = d_t_ssdf_isci_hissesi + ssdf_isci_hissesi;
                        d_t_ssdf_isveren_hissesi = d_t_ssdf_isveren_hissesi + ssdf_isveren_hissesi;
            
                        if(Len(SSK_ISCI_HISSESI_DUSULECEK))
                            sgdp_isci_primi_fark = SSK_ISCI_HISSESI_DUSULECEK;
            
                        t_sgdp_isci_primi_fark = t_sgdp_isci_primi_fark + sgdp_isci_primi_fark;
                        d_t_sgdp_isci_primi_fark = d_t_sgdp_isci_primi_fark + sgdp_isci_primi_fark;
                        isveren_hesaplanan = 0;
                    }
                    else
                    {
                        t_ssk_days = t_ssk_days + total_days;
                        t_work_days = t_work_days + total_days - sunday_count;
            
                        if (use_ssk eq 1)
                        {
                            t_ssk_primi_isci = t_ssk_primi_isci + ssk_isci_hissesi;
                            if(len(ssk_isci_hissesi_687))
                                t_ssk_primi_isci = t_ssk_primi_isci - ssk_isci_hissesi_687;
            
                            t_ssk_matrahi = t_ssk_matrahi + SSK_MATRAH;
            
                            if(ssk_isci_hissesi gt 0 and ssk_devir_toplam gt 0)
                                t_ssk_primi_isci_devirsiz = wrk_round((SSK_MATRAH - ssk_devir_toplam) * 14 / 100);
                            else
                                t_ssk_primi_isci_devirsiz = ssk_isci_hissesi;
            
                            if(issizlik_isci_hissesi gt 0 and ssk_devir_toplam gt 0)
                                _issizlik_isci_hissesi_devirsiz = (SSK_MATRAH - ssk_devir_toplam) * 1 / 100;
                            else
                                _issizlik_isci_hissesi_devirsiz = issizlik_isci_hissesi;
            
                            sgk_isci_hissesi_fark = ssk_isci_hissesi - t_ssk_primi_isci_devirsiz;
                            sgk_issizlik_hissesi_fark = issizlik_isci_hissesi - _issizlik_isci_hissesi_devirsiz;
            
                            t_sgk_isci_hissesi_fark = t_sgk_isci_hissesi_fark + (ssk_isci_hissesi - t_ssk_primi_isci_devirsiz);
                            t_sgk_issizlik_hissesi_fark = t_sgk_issizlik_hissesi_fark + (issizlik_isci_hissesi - _issizlik_isci_hissesi_devirsiz);
            
                            d_t_sgk_isci_hissesi_fark = d_t_sgk_isci_hissesi_fark + (ssk_isci_hissesi - t_ssk_primi_isci_devirsiz);
                            d_t_sgk_issizlik_hissesi_fark = d_t_sgk_issizlik_hissesi_fark + (issizlik_isci_hissesi - _issizlik_isci_hissesi_devirsiz);
                        }
                        ssk_isveren_hissesi_5510_ = ssk_isveren_hissesi_5510;
                        
                        if(ssk_isveren_hissesi lt 0)
                        {
                            ssk_isveren_hissesi_control = 0;
                        }
                        else
                            ssk_isveren_hissesi_control = ssk_isveren_hissesi;

                        isveren_hesaplanan = ssk_isveren_hissesi_control + ssk_isveren_hissesi_5510 + ssk_isveren_hissesi_5084;

                        if(isveren_hesaplanan eq 0)
                            t_ssk_primi_isveren_hesaplanan = t_ssk_primi_isveren_hesaplanan + ssdf_isveren_hissesi;
                        else 
                            t_ssk_primi_isveren_hesaplanan = t_ssk_primi_isveren_hesaplanan + isveren_hesaplanan;
                        
                        t_ssk_primi_isveren_5510 = t_ssk_primi_isveren_5510 + wrk_round(ssk_isveren_hissesi_5510);
                        t_ssk_primi_isveren_5084 = t_ssk_primi_isveren_5084 + ssk_isveren_hissesi_5084;
                                    
                        t_ssk_primi_isveren_5921 = t_ssk_primi_isveren_5921 + ssk_isveren_hissesi_5921;
                        t_ssk_primi_isveren_5746 = t_ssk_primi_isveren_5746 + ssk_isveren_hissesi_5746;
                        if(len(ssk_isveren_hissesi_4691))
                            t_ssk_primi_isveren_4691 = t_ssk_primi_isveren_4691 + ssk_isveren_hissesi_4691;
                        if(len(ssk_isveren_hissesi_6111))
                            t_ssk_primi_isveren_6111 = t_ssk_primi_isveren_6111 + ssk_isveren_hissesi_6111;
                        else
                            ssk_isveren_hissesi_6111 = 0;

                        if(len(ssk_isveren_hissesi_6645))
                            t_ssk_primi_isveren_6645 = t_ssk_primi_isveren_6645 + ssk_isveren_hissesi_6645;
                        else
                            ssk_isveren_hissesi_6645 = 0;

                        //7252 Esma R. Uysal
                        if(len(ssk_isveren_hissesi_7252))
						{
                            t_ssk_primi_isveren_7252 = t_ssk_primi_isveren_7252 + ssk_isveren_hissesi_7252;
							ssk_isveren_hissesi_7252_ = ssk_isveren_hissesi_7252;
						}
                        else
                            ssk_isveren_hissesi_7252_ = 0;
                        if(len(ISSIZLIK_ISVEREN_HISSESI_7252))
						{
                            t_ssk_primi_isveren_issizlik_7252 = t_ssk_primi_isveren_issizlik_7252 + ISSIZLIK_ISVEREN_HISSESI_7252;
							ISSIZLIK_ISVEREN_HISSESI_7252_ = ISSIZLIK_ISVEREN_HISSESI_7252;
						}
                        else
						{
                            ISSIZLIK_ISVEREN_HISSESI_7252_ = 0;
						}
                        if(len(ssk_isci_hissesi_7252))
						{
						    t_ssk_isci_hissesi_7252 = t_ssk_isci_hissesi_7252 + ssk_isci_hissesi_7252;
							ssk_isci_hissesi_7252_ = ssk_isci_hissesi_7252;
						}
                        else
							ssk_isci_hissesi_7252_ = 0;
                        if(len(issizlik_isci_hissesi_7252))
                        {
						    t_issizlik_isci_hissesi_7252 = t_issizlik_isci_hissesi_7252 + issizlik_isci_hissesi_7252;
                            issizlik_isci_hissesi_7252_ = issizlik_isci_hissesi_7252;
                        }
                        else
                            issizlik_isci_hissesi_7252_ = 0;
                        if(len(ssk_isveren_hissesi_7252))
                            d_t_ssk_primi_isveren_7252 = d_t_ssk_primi_isveren_7252 + ssk_isveren_hissesi_7252;
                        if(len(ISSIZLIK_ISVEREN_HISSESI_7252))
                            d_t_ssk_primi_isveren_issizlik_7252 = d_t_ssk_primi_isveren_issizlik_7252 + ISSIZLIK_ISVEREN_HISSESI_7252;
                        if(len(ssk_isci_hissesi_7252))
						    d_t_ssk_isci_hissesi_7252 = d_t_ssk_isci_hissesi_7252 + ssk_isci_hissesi_7252;
                        if(len(issizlik_isci_hissesi_7252))
						    d_t_issizlik_isci_hissesi_7252 = d_t_issizlik_isci_hissesi_7252 + issizlik_isci_hissesi_7252;
                        
                        //7256 Esma R. Uysal
                        if(len(ssk_isveren_hissesi_7256))
                        {
                            t_ssk_primi_isveren_7256 = t_ssk_primi_isveren_7256 + ssk_isveren_hissesi_7256;
                            ssk_isveren_hissesi_7256_ = ssk_isveren_hissesi_7256;
                        }
                            
                        else{
                            ssk_isveren_hissesi_7256_ = 0;
                        }
                            
                        if(len(ISSIZLIK_ISVEREN_HISSESI_7256))
						{
                            t_ssk_primi_isveren_issizlik_7256 = t_ssk_primi_isveren_issizlik_7256 + ISSIZLIK_ISVEREN_HISSESI_7256;
							ISSIZLIK_ISVEREN_HISSESI_7256_ = ISSIZLIK_ISVEREN_HISSESI_7256;
						}
                        else
                            ISSIZLIK_ISVEREN_HISSESI_7256_ = 0;
                        if(len(ssk_isci_hissesi_7256))
						{
						    t_ssk_isci_hissesi_7256 = t_ssk_isci_hissesi_7256 + ssk_isci_hissesi_7256;
							ssk_isci_hissesi_7256_ = ssk_isci_hissesi_7256;
						}
						else	
                            ssk_isci_hissesi_7256_ = 0;
                        if(len(issizlik_isci_hissesi_7256))
                        {
                            t_issizlik_isci_hissesi_7256 = t_issizlik_isci_hissesi_7256 + issizlik_isci_hissesi_7256;
                            issizlik_isci_hissesi_7256_ = issizlik_isci_hissesi_7256;
                        }
                        else
                            issizlik_isci_hissesi_7256_ = 0;
                        if(len(ssk_isveren_hissesi_7256))
                            d_t_ssk_primi_isveren_7256 = d_t_ssk_primi_isveren_7256 + ssk_isveren_hissesi_7256;
                        if(len(ISSIZLIK_ISVEREN_HISSESI_7256))
                            d_t_ssk_primi_isveren_issizlik_7256 = d_t_ssk_primi_isveren_issizlik_7256 + ISSIZLIK_ISVEREN_HISSESI_7256;
                        if(len(ssk_isci_hissesi_7256))
						    d_t_ssk_isci_hissesi_7256 = d_t_ssk_isci_hissesi_7256 + ssk_isci_hissesi_7256;
                        if(len(issizlik_isci_hissesi_7256))
						    d_t_issizlik_isci_hissesi_7256 = d_t_issizlik_isci_hissesi_7256 + issizlik_isci_hissesi_7256;
                            
                        if(len(ssk_isveren_hissesi_6486))
                            t_ssk_primi_isveren_6486 = t_ssk_primi_isveren_6486 + ssk_isveren_hissesi_6486;
                        else
                            ssk_isveren_hissesi_6486 = 0;

                        if(len(ssk_isveren_hissesi_46486))
                            t_ssk_primi_isveren_46486 = t_ssk_primi_isveren_46486 + ssk_isveren_hissesi_46486;
                        else
                            ssk_isveren_hissesi_46486 = 0;
                        if(len(ssk_isveren_hissesi_56486))
                            t_ssk_primi_isveren_56486 = t_ssk_primi_isveren_56486 + ssk_isveren_hissesi_56486;
                        else
                            ssk_isveren_hissesi_56486 = 0;
                        if(len(ssk_isveren_hissesi_66486))
                            t_ssk_primi_isveren_66486 = t_ssk_primi_isveren_66486 + ssk_isveren_hissesi_66486;
                        else
                            ssk_isveren_hissesi_66486 = 0;

                        if(len(ssk_isveren_hissesi_6322))
                            t_ssk_primi_isveren_6322 = t_ssk_primi_isveren_6322 + ssk_isveren_hissesi_6322;
                        else
                            ssk_isveren_hissesi_6322 = 0;
                        if(len(ssk_isci_hissesi_6322))
                            t_ssk_primi_isci_6322 = t_ssk_primi_isci_6322 + ssk_isci_hissesi_6322;
                        else
                            ssk_isci_hissesi_6322 = 0;
							
						if(len(ssk_isveren_hissesi_14857))
							t_ssk_primi_isveren_14857 = t_ssk_primi_isveren_14857 + ssk_isveren_hissesi_14857;
						else
							t_ssk_primi_isveren_14857 = 0;	
                            
						if(len(ssk_isveren_hissesi_3294_))
							t_ssk_primi_isveren_3294 = t_ssk_primi_isveren_3294 + ssk_isveren_hissesi_3294_;
						else
							t_ssk_primi_isveren_3294 = 0;

                        t_ssk_primi_isveren_gov = t_ssk_primi_isveren_gov + ssk_isveren_hissesi_gov;
                        if(len(ssk_isveren_hissesi_687))
                        {
                            t_ssk_isveren_hissesi_687 = t_ssk_isveren_hissesi_687 + ssk_isveren_hissesi_687;
                            t_ssk_isci_hissesi_687 = t_ssk_isci_hissesi_687 + ssk_isci_hissesi_687;
                            t_issizlik_isci_hissesi_687 = t_issizlik_isci_hissesi_687 + issizlik_isci_hissesi_687;
                            t_issizlik_isveren_hissesi_687 = t_issizlik_isveren_hissesi_687 + issizlik_isveren_hissesi_687;
                            t_gelir_vergisi_indirimi_687 = t_gelir_vergisi_indirimi_687 + gelir_vergisi_indirimi_687;
                            t_damga_vergisi_indirimi_687 = t_damga_vergisi_indirimi_687 + damga_vergisi_indirimi_687;
                        }
						
                        if(len(ssk_isveren_hissesi_7103))
                        {
                            t_ssk_isveren_hissesi_7103 = t_ssk_isveren_hissesi_7103 + ssk_isveren_hissesi_7103;
                            t_ssk_isci_hissesi_7103 = t_ssk_isci_hissesi_7103 + ssk_isci_hissesi_7103;
                            t_issizlik_isci_hissesi_7103 = t_issizlik_isci_hissesi_7103 + issizlik_isci_hissesi_7103;
                            t_issizlik_isveren_hissesi_7103 = t_issizlik_isveren_hissesi_7103 + issizlik_isveren_hissesi_7103;
                            t_gelir_vergisi_indirimi_7103 = t_gelir_vergisi_indirimi_7103 + gelir_vergisi_indirimi_7103;
                            t_damga_vergisi_indirimi_7103 = t_damga_vergisi_indirimi_7103 + damga_vergisi_indirimi_7103;
                        }

                        t_issizlik_isci_hissesi = t_issizlik_isci_hissesi + issizlik_isci_hissesi;
                        if(len(issizlik_isci_hissesi_687)) 
                            t_issizlik_isci_hissesi = t_issizlik_isci_hissesi - issizlik_isci_hissesi_687;
                        t_issizlik_isveren_hissesi = t_issizlik_isveren_hissesi + issizlik_isveren_hissesi;
                        if(len(issizlik_isveren_hissesi_687))
                            t_issizlik_isveren_hissesi = t_issizlik_isveren_hissesi - issizlik_isveren_hissesi_687;
                        
                        d_t_ssk_days = d_t_ssk_days + total_days;
                        d_t_work_days = d_t_work_days + total_days - sunday_count;
                        d_t_ssk_matrahi = d_t_ssk_matrahi + SSK_MATRAH;
                        d_t_ssk_primi_isci = d_t_ssk_primi_isci + ssk_isci_hissesi;
                        
                        if(ssk_isci_hissesi eq 0)d_t_ssk_primi_isveren_hesaplanan = d_t_ssk_primi_isveren_hesaplanan + ssdf_isveren_hissesi;else d_t_ssk_primi_isveren_hesaplanan = d_t_ssk_primi_isveren_hesaplanan + isveren_hesaplanan;
                        
                        d_t_ssk_primi_isveren_5510 = d_t_ssk_primi_isveren_5510 + wrk_round(ssk_isveren_hissesi_5510);
                        d_t_ssk_primi_isveren_5084 = d_t_ssk_primi_isveren_5084 + ssk_isveren_hissesi_5084;
                                    
                        d_t_ssk_primi_isveren_5921 = d_t_ssk_primi_isveren_5921 + ssk_isveren_hissesi_5921;
                        d_t_ssk_primi_isveren_5746 = d_t_ssk_primi_isveren_5746 + ssk_isveren_hissesi_5746;
                        if(len(ssk_isveren_hissesi_4691))
                            d_t_ssk_primi_isveren_4691 = d_t_ssk_primi_isveren_4691 + ssk_isveren_hissesi_4691;
                        
                        if(len(ssk_isveren_hissesi_6111))
                            d_t_ssk_primi_isveren_6111 = d_t_ssk_primi_isveren_6111 + ssk_isveren_hissesi_6111;
                        
                        if(len(ssk_isveren_hissesi_6645))
                            d_t_ssk_primi_isveren_6645 = d_t_ssk_primi_isveren_6645 + ssk_isveren_hissesi_6645;
                        if(len(ssk_isveren_hissesi_46486))
                            d_t_ssk_primi_isveren_46486 = d_t_ssk_primi_isveren_46486 + ssk_isveren_hissesi_46486;
                        if(len(ssk_isveren_hissesi_56486))
                            d_t_ssk_primi_isveren_56486 = d_t_ssk_primi_isveren_56486 + ssk_isveren_hissesi_56486;
                         if(len(ssk_isveren_hissesi_66486))
                            d_t_ssk_primi_isveren_66486 = d_t_ssk_primi_isveren_66486 + ssk_isveren_hissesi_66486;
                        
                        if(len(ssk_isveren_hissesi_6322))
                            d_t_ssk_primi_isveren_6322 = d_t_ssk_primi_isveren_6322 + ssk_isveren_hissesi_6322;
                        if(len(ssk_isci_hissesi_6322))
                            d_t_ssk_primi_isci_6322 = d_t_ssk_primi_isci_6322 + ssk_isci_hissesi_6322;
							
						if(len(ssk_isveren_hissesi_14857))	
							d_t_ssk_primi_isveren_14857 = d_t_ssk_primi_isveren_14857 + ssk_isveren_hissesi_14857;
						else
							d_t_ssk_primi_isveren_14857 = 0;
						
                        if(len(ssk_isveren_hissesi_3294))	
							d_t_ssk_primi_isveren_3294 = d_t_ssk_primi_isveren_3294 + ssk_isveren_hissesi_3294_;
						else
							d_t_ssk_primi_isveren_3294 = 0;

                        d_t_ssk_primi_isveren_gov = d_t_ssk_primi_isveren_gov + ssk_isveren_hissesi_gov;
            
                        if(len(ssk_isveren_hissesi_687))
                        {
                            d_t_ssk_isveren_hissesi_687 = d_t_ssk_isveren_hissesi_687 + ssk_isveren_hissesi_687;
                            d_t_ssk_isci_hissesi_687 = d_t_ssk_isci_hissesi_687 + ssk_isci_hissesi_687;
                            d_t_issizlik_isci_hissesi_687 = d_t_issizlik_isci_hissesi_687 + issizlik_isci_hissesi_687;
                            d_t_issizlik_isveren_hissesi_687 = d_t_issizlik_isveren_hissesi_687 + issizlik_isveren_hissesi_687;
                            d_t_gelir_vergisi_indirimi_687 = d_t_gelir_vergisi_indirimi_687 + gelir_vergisi_indirimi_687;
                            d_t_damga_vergisi_indirimi_687 = d_t_damga_vergisi_indirimi_687 + damga_vergisi_indirimi_687;
                        }
						
                        if(len(ssk_isveren_hissesi_7103))
                        {
                            d_t_ssk_isveren_hissesi_7103 = d_t_ssk_isveren_hissesi_7103 + ssk_isveren_hissesi_7103;
                            d_t_ssk_isci_hissesi_7103 = d_t_ssk_isci_hissesi_7103 + ssk_isci_hissesi_7103;
                            d_t_issizlik_isci_hissesi_7103 = d_t_issizlik_isci_hissesi_7103 + issizlik_isci_hissesi_7103;
                            d_t_issizlik_isveren_hissesi_7103 = d_t_issizlik_isveren_hissesi_7103 + issizlik_isveren_hissesi_7103;
                            d_t_gelir_vergisi_indirimi_7103 = d_t_gelir_vergisi_indirimi_7103 + gelir_vergisi_indirimi_7103;
                            d_t_damga_vergisi_indirimi_7103 = d_t_damga_vergisi_indirimi_7103 + damga_vergisi_indirimi_7103;
                        }
						
						
                        d_t_issizlik_isci_hissesi = d_t_issizlik_isci_hissesi + issizlik_isci_hissesi - issizlik_isci_hissesi_7256_ - issizlik_isci_hissesi_7252_;
                        if(len(issizlik_isci_hissesi_687))d_t_issizlik_isci_hissesi = d_t_issizlik_isci_hissesi - issizlik_isci_hissesi_687;
                        if(len(issizlik_isci_hissesi_7103))d_t_issizlik_isci_hissesi = d_t_issizlik_isci_hissesi - issizlik_isci_hissesi_7103;
                        d_t_issizlik_isveren_hissesi = d_t_issizlik_isveren_hissesi + issizlik_isveren_hissesi;
                        if(len(issizlik_isveren_hissesi_687))  d_t_issizlik_isveren_hissesi = d_t_issizlik_isveren_hissesi - issizlik_isveren_hissesi_687;
            
                        d_t_ssk_primi_isveren = d_t_ssk_primi_isveren + (ssk_isveren_hissesi - ssk_isveren_hissesi_gov - ssk_isveren_hissesi_5921);
            
                        t_ssk_primi_isveren = t_ssk_primi_isveren + (ssk_isveren_hissesi - ssk_isveren_hissesi_gov - ssk_isveren_hissesi_5921);		
                    }
                    devir_tutar_ = 0;
                    if(len(SSK_ISCI_HISSESI_DUSULECEK))
                        devir_tutar_ = devir_tutar_ + SSK_ISCI_HISSESI_DUSULECEK;
                        
                    if(len(ISSIZLIK_ISCI_HISSESI_DUSULECEK))
                        devir_tutar_ = devir_tutar_ + ISSIZLIK_ISCI_HISSESI_DUSULECEK;
                        
                    t_devir_fark = t_devir_fark + devir_tutar_;
                    d_t_devir_fark = d_t_devir_fark + devir_tutar_;
        
                    //toplam_isveren_indirimsiz = devir_tutar_ + total_salary+t_istisna_odenek+issizlik_isveren_hissesi+ssk_isveren_hissesi+ssdf_isveren_hissesi + ssk_isveren_hissesi_5510 - VERGI_ISTISNA_VERGI;
                    toplam_isveren_indirimsiz = total_salary + t_istisna_odenek+issizlik_isveren_hissesi+isveren_hesaplanan+ssdf_isveren_hissesi+t_ozel_kesinti_2_net_fark;
				    //687 tesvikten düsülecekler
                    if(len(ssk_isveren_hissesi_687))
					    toplam_indirim_687 = ssk_isveren_hissesi_687 + ssk_isci_hissesi_687 + issizlik_isci_hissesi_687 + issizlik_isveren_hissesi_687 + gelir_vergisi_indirimi_687 + damga_vergisi_indirimi_687;
                    else toplam_indirim_687 = 0;
					//7103 tesvikten düsülecekler
                    if(len(ssk_isveren_hissesi_7103))
					    toplam_indirim_7103 = ssk_isveren_hissesi_7103 + ssk_isci_hissesi_7103 + issizlik_isci_hissesi_7103 + issizlik_isveren_hissesi_7103 + gelir_vergisi_indirimi_7103 + damga_vergisi_indirimi_7103;
                    else toplam_indirim_7103 = 0;
                    toplam_isveren = (total_salary+t_istisna_odenek+issizlik_isveren_hissesi+isveren_hesaplanan+ssdf_isveren_hissesi+t_ozel_kesinti_2_net_fark)-(ssk_isveren_hissesi_5510+ssk_isveren_hissesi_5084+ssk_isveren_hissesi_5921+ssk_isveren_hissesi_5746+ssk_isveren_hissesi_6111+ssk_isveren_hissesi_6486+ssk_isveren_hissesi_6322+ssk_isci_hissesi_6322+ssk_isveren_hissesi_gov+toplam_indirim_687+toplam_indirim_7103);

                    if(len(ssk_isveren_hissesi_4691))
                        toplam_isveren = toplam_isveren -ssk_isveren_hissesi_4691;
                    if(len(ssk_isveren_hissesi_46486))
                        toplam_isveren = toplam_isveren -ssk_isveren_hissesi_46486;
                    if(len(ssk_isveren_hissesi_56486))
                        toplam_isveren = toplam_isveren -ssk_isveren_hissesi_56486;
                    if(len(ssk_isveren_hissesi_66486))
                        toplam_isveren = toplam_isveren -ssk_isveren_hissesi_66486;
                    if(len(ssk_isveren_hissesi_6645))
                        toplam_isveren = toplam_isveren -ssk_isveren_hissesi_6645;
                    if(len(ssk_isveren_hissesi_14857))
                        toplam_isveren = toplam_isveren -ssk_isveren_hissesi_14857;
                    if(len(ssk_isveren_hissesi_3294_))
                        toplam_isveren = toplam_isveren -ssk_isveren_hissesi_3294_;

					if(len(ssk_isveren_hissesi_7252))
						toplam_isveren = toplam_isveren - ssk_isveren_hissesi_7252;
						
					if(len(issizlik_isveren_hissesi_7252))
						toplam_isveren = toplam_isveren - issizlik_isveren_hissesi_7252;
					
					if(len(ssk_isci_hissesi_7252))
						toplam_isveren = toplam_isveren - ssk_isci_hissesi_7252;
					if(len(issizlik_isci_hissesi_7252))
						toplam_isveren = toplam_isveren - issizlik_isci_hissesi_7252;
                    
                    if(len(ssk_isveren_hissesi_7256))
						toplam_isveren = toplam_isveren - ssk_isveren_hissesi_7256;
						
					if(len(issizlik_isveren_hissesi_7256))
						toplam_isveren = toplam_isveren - issizlik_isveren_hissesi_7256;
					
					if(len(ssk_isci_hissesi_7256))
						toplam_isveren = toplam_isveren - ssk_isci_hissesi_7256;
					if(len(issizlik_isci_hissesi_7256))
						toplam_isveren = toplam_isveren - issizlik_isci_hissesi_7256;
					
					t_toplam_isveren = t_toplam_isveren + toplam_isveren;
                    d_t_toplam_isveren = d_t_toplam_isveren + toplam_isveren;
                    t_toplam_isveren_indirimsiz = t_toplam_isveren_indirimsiz + toplam_isveren_indirimsiz;
                    d_t_toplam_isveren_indirimsiz = d_t_toplam_isveren_indirimsiz + toplam_isveren_indirimsiz;
                    d_kidem_amount = d_kidem_amount + KIDEM_AMOUNT;
                    d_ihbar_amount = d_ihbar_amount + IHBAR_AMOUNT;
                    t_kidem_amount = t_kidem_amount + KIDEM_AMOUNT;
                    t_ihbar_amount = t_ihbar_amount + IHBAR_AMOUNT;
                    d_vergi_istisna_total = d_vergi_istisna_total + vergi_istisna_total;
                    d_vergi_istisna_ssk = d_vergi_istisna_ssk + vergi_istisna_ssk;
                    d_vergi_istisna_ssk_net = d_vergi_istisna_ssk_net + vergi_istisna_ssk_net;
                    d_vergi_istisna_vergi = d_vergi_istisna_vergi + vergi_istisna_vergi;
                    d_vergi_istisna_vergi_net = d_vergi_istisna_vergi_net + vergi_istisna_vergi_net;
                    d_vergi_istisna_damga = d_vergi_istisna_damga + vergi_istisna_damga;
                    d_vergi_istisna_damga_net = d_vergi_istisna_damga_net + vergi_istisna_damga_net;
                    
                    t_vergi_istisna_total = t_vergi_istisna_total + vergi_istisna_total;
                    t_vergi_istisna_ssk = t_vergi_istisna_ssk + vergi_istisna_ssk;
                    t_vergi_istisna_ssk_net = t_vergi_istisna_ssk_net + vergi_istisna_ssk_net;
                    t_vergi_istisna_vergi = t_vergi_istisna_vergi + vergi_istisna_vergi;
                    t_vergi_istisna_vergi_net = t_vergi_istisna_vergi_net + vergi_istisna_vergi_net;
                    t_vergi_istisna_damga = t_vergi_istisna_damga + vergi_istisna_damga;
                    t_vergi_istisna_damga_net = t_vergi_istisna_damga_net + vergi_istisna_damga_net;
                    if(ssk_isci_hissesi gt 0)
                    {
                        t_sgk_isveren_hissesi = t_sgk_isveren_hissesi + ssk_isveren_hissesi - ssk_isveren_hissesi_gov - ssk_isveren_hissesi_5921 - ssk_isveren_hissesi_5746 - ssk_isveren_hissesi_6111 - ssk_isveren_hissesi_6486 - ssk_isveren_hissesi_6322+ssk_isci_hissesi_6322 - ssk_isveren_hissesi_7252_ - ssk_isveren_hissesi_7256_;
                        d_t_sgk_isveren_hissesi = d_t_sgk_isveren_hissesi + ssk_isveren_hissesi - ssk_isveren_hissesi_gov - ssk_isveren_hissesi_5921 - ssk_isveren_hissesi_5746 - ssk_isveren_hissesi_6111 -ssk_isveren_hissesi_6486 - ssk_isveren_hissesi_6322 - ssk_isveren_hissesi_7252_ - ssk_isveren_hissesi_7256_ ;                    
                         if(len(ssk_isveren_hissesi_4691))
                        {
                            t_sgk_isveren_hissesi = t_sgk_isveren_hissesi - ssk_isveren_hissesi_4691;
                            d_t_sgk_isveren_hissesi = d_t_sgk_isveren_hissesi - ssk_isveren_hissesi_4691;;
                        }
                        if(len(ssk_isveren_hissesi_6645))
                        {
                            t_sgk_isveren_hissesi = t_sgk_isveren_hissesi - ssk_isveren_hissesi_6645;
                            d_t_sgk_isveren_hissesi = d_t_sgk_isveren_hissesi - ssk_isveren_hissesi_6645;;
                        }
                        if(len(ssk_isveren_hissesi_46486))
                        {
                            t_sgk_isveren_hissesi = t_sgk_isveren_hissesi - ssk_isveren_hissesi_46486;
                            d_t_sgk_isveren_hissesi = d_t_sgk_isveren_hissesi - ssk_isveren_hissesi_46486;;
                        }
                        if(len(ssk_isveren_hissesi_56486))
                        {
                            t_sgk_isveren_hissesi = t_sgk_isveren_hissesi - ssk_isveren_hissesi_56486;
                            d_t_sgk_isveren_hissesi = d_t_sgk_isveren_hissesi - ssk_isveren_hissesi_56486;;
                        } 
                        if(len(ssk_isveren_hissesi_66486))
                        {
                            t_sgk_isveren_hissesi = t_sgk_isveren_hissesi - ssk_isveren_hissesi_66486;
                            d_t_sgk_isveren_hissesi = d_t_sgk_isveren_hissesi - ssk_isveren_hissesi_66486;;
                        } 
                        if(len(ssk_isveren_hissesi_14857))
                        {
                            t_sgk_isveren_hissesi = t_sgk_isveren_hissesi - ssk_isveren_hissesi_14857;
                            d_t_sgk_isveren_hissesi = d_t_sgk_isveren_hissesi - ssk_isveren_hissesi_14857;;
                        } 
                        if(len(ssk_isveren_hissesi_3294))
                        {
                            t_sgk_isveren_hissesi = t_sgk_isveren_hissesi - ssk_isveren_hissesi_3294_;
                            d_t_sgk_isveren_hissesi = d_t_sgk_isveren_hissesi - ssk_isveren_hissesi_3294_;;
                        } 
                        if(len(ssk_isveren_hissesi_687))
                        {
                            t_sgk_isveren_hissesi = t_sgk_isveren_hissesi - ssk_isveren_hissesi_687;
                            d_t_sgk_isveren_hissesi = d_t_sgk_isveren_hissesi - ssk_isveren_hissesi_687;;
                        }
                        if(len(ssk_isveren_hissesi_7103))
                        {
                            t_sgk_isveren_hissesi = t_sgk_isveren_hissesi - ssk_isveren_hissesi_7103;
                            d_t_sgk_isveren_hissesi = d_t_sgk_isveren_hissesi - ssk_isveren_hissesi_7103;;
                        } 

                        if(t_sgk_isveren_hissesi lt 0)
                            t_sgk_isveren_hissesi = 0;
                        if(d_t_sgk_isveren_hissesi lt 0)
                            d_t_sgk_isveren_hissesi = 0;

                    }
					
					haftalik_tatil = weekend_day;
					normal_gun = ceiling(weekly_day);
					normal_izinli = izin_paid - paid_izinli_sunday_count;
					genel_tatil = OFFDAYS_COUNT;
					yillik_izin = YILLIK_IZIN_AMOUNT;
					if (normal_gun lt 0)
						normal_gun = 0;
					normal_gun_total = normal_gun + normal_gun_total;
					haftalik_tatil_total = haftalik_tatil + haftalik_tatil_total;
					genel_tatil_total = genel_tatil + genel_tatil_total;
					izin_total = izin_total + izin;
					yillik_izin_total = yillik_izin + yillik_izin_total;
					d_normal_gun_total = normal_gun + d_normal_gun_total;
					d_haftalik_tatil_total = haftalik_tatil + d_haftalik_tatil_total;
					d_genel_tatil_total = genel_tatil + d_genel_tatil_total;
					d_izin_total = d_izin_total + izin;
					d_yillik_izin_total = yillik_izin + d_yillik_izin_total;
					if (total_salary)
					{
						if (SALARY_TYPE eq 2)
							ucretim = SALARY/30;
						else if (SALARY_TYPE eq 1)
							ucretim = SALARY;
						else if (SALARY_TYPE eq 0)
							ucretim = SALARY*SSK_WORK_HOURS;
					}
					else
						ucretim = total_salary;
					t_gunluk_ucret = t_gunluk_ucret + ucretim;
					d_t_gunluk_ucret = d_t_gunluk_ucret + ucretim;
					d_t_izin_paid = d_t_izin_paid + normal_izinli;
					t_izin_paid = t_izin_paid + normal_izinli;
					t_aylik = t_aylik + total_amount;
					t_aylik_fazla = t_aylik_fazla + ext_salary;
					t_aylik_fazla_mesai_net = t_aylik_fazla_mesai_net + ext_salary_net;
					d_t_aylik = d_t_aylik + total_amount;
					d_t_aylik_fazla = d_t_aylik_fazla + ext_salary;
					d_t_aylik_fazla_mesai_net = d_t_aylik_fazla_mesai_net + ext_salary_net;
					aylik_brut_ucret = total_amount-ext_salary-YILLIK_IZIN_AMOUNT-KIDEM_AMOUNT-IHBAR_AMOUNT;
					t_aylik_brut_ucret = t_aylik_brut_ucret+aylik_brut_ucret;

                    //ssk işçi primi indirimli
                    isci_primi_indirimli = ssk_isci_hissesi - (ssk_isci_hissesi_6322 + ssk_isci_hissesi_7252_ + ssk_isci_hissesi_7256_ + ssdf_isci_hissesi);
                    t_isci_primi_indirimli = t_ssk_primi_isci - (t_ssk_primi_isci_6322 + t_ssk_isci_hissesi_7252 + t_ssk_isci_hissesi_7256 + t_ssdf_isci_hissesi);
                    d_t_isci_primi_indirimli = d_t_ssk_primi_isci - (d_t_ssk_primi_isci_6322 + d_t_ssk_isci_hissesi_7252 + d_t_ssk_isci_hissesi_7256 + d_t_ssdf_isci_hissesi);  
                    if(len(ssk_isci_hissesi_7103))
                    {
                        isci_primi_indirimli = ssk_isci_hissesi - ssk_isci_hissesi_7103;
                        t_isci_primi_indirimli = t_ssk_primi_isci - t_ssk_isci_hissesi_7103;
                        d_t_isci_primi_indirimli = d_t_ssk_primi_isci - d_t_ssk_isci_hissesi_7103;
                    }
                    //ssk işsizlik işçi pirimi indirimli
                    issizlik_isci_primi_indirimli = issizlik_isci_hissesi - (issizlik_isci_hissesi_7252_ + issizlik_isci_hissesi_7256_);
                    t_issizlik_isci_primi_indirimli = t_issizlik_isci_hissesi - (t_issizlik_isci_hissesi_7252 + t_issizlik_isci_hissesi_7256);
                    if(len(issizlik_isci_hissesi_7103))
                    {
                        issizlik_isci_primi_indirimli = issizlik_isci_hissesi - issizlik_isci_hissesi_7103;
                        t_issizlik_isci_primi_indirimli = t_issizlik_isci_hissesi - t_issizlik_isci_hissesi_7103;
                    }
                    d_t_issizlik_isci_primi_indirimli = t_issizlik_isci_primi_indirimli;
                    
                    //ssk işsizlik işveren primi indirimli
                    issizlik_isveren_primi_indirimli = issizlik_isveren_hissesi - (ISSIZLIK_ISVEREN_HISSESI_7252_ + ISSIZLIK_ISVEREN_HISSESI_7256_);
                    t_issizlik_isveren_primi_indirimli = t_issizlik_isveren_hissesi - (t_ssk_primi_isveren_issizlik_7252 + t_ssk_primi_isveren_issizlik_7256);
                    d_t_issizlik_isveren_primi_indirimli = d_t_issizlik_isveren_hissesi - (d_t_ssk_primi_isveren_issizlik_7252 + d_t_ssk_primi_isveren_issizlik_7256);
                    
                    if(len(issizlik_isveren_hissesi_687))
                    {
                        issizlik_isveren_primi_indirimli = issizlik_isveren_hissesi - issizlik_isveren_hissesi_687;
                        t_issizlik_isveren_primi_indirimli = t_issizlik_isveren_hissesi - t_issizlik_isveren_hissesi_687;
                        d_t_issizlik_isveren_primi_indirimli = d_t_issizlik_isveren_hissesi - d_t_issizlik_isveren_hissesi_687;
                    }
                    if(len(issizlik_isveren_hissesi_7103))
                    {
                        issizlik_isveren_primi_indirimli = issizlik_isveren_hissesi - issizlik_isveren_hissesi_7103;
                        t_issizlik_isveren_primi_indirimli = t_issizlik_isveren_hissesi - t_issizlik_isveren_hissesi_7103;
                        d_t_issizlik_isveren_primi_indirimli = d_t_issizlik_isveren_hissesi - d_t_issizlik_isveren_hissesi_7103;
                    }

                    //tutar toplamları
                    t_ext_salary_0 = 0;
                    t_ext_salary_1 = 0;
                    t_ext_salary_2 = 0;
                    t_ext_salary_5 = 0;


                    //mesai tutar toplamları			
                    t_ext_salary_0 = t_ext_salary_0 + EXT_TOTAL_HOURS_0_AMOUNT;
                    t_ext_salary_1 = t_ext_salary_1 + EXT_TOTAL_HOURS_1_AMOUNT;
                    t_ext_salary_2 = t_ext_salary_2 + EXT_TOTAL_HOURS_2_AMOUNT;
                    t_ext_salary_5 = t_ext_salary_5 + EXT_TOTAL_HOURS_5_AMOUNT;
                    t_ext_Salary = t_ext_salary_0 + t_ext_salary_1 + t_ext_salary_2 + t_ext_salary_5;
                    
                </cfscript>
                <tr height="33" <cfif len(finish_date) and isdate(finish_date) and (month(finish_date) eq row_sal_mon and year(finish_date) eq row_sal_year)>class="cls_red"<cfelseif len(start_date) and (month(start_date) eq row_sal_mon and year(start_date) eq row_sal_year)>class="cls_blue"</cfif>>
                  <cfset ssk_count = ssk_count+1>
                  <cfloop list="#attributes.b_obj_hidden_new#" index="xlr">
                    <cfswitch expression="#xlr#">
                        <cfcase value="b_baslik"><td>&nbsp;</td></cfcase>
                        <cfcase value="b_sira_no"><td>#sayac#</td></cfcase>
                        <cfcase value="b_sgk_no"><td>#ssk_no[ssk_count]#&nbsp;</td></cfcase>
                        <cfcase value="b_ad_soyad"><td nowrap>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td></cfcase>
                        <cfcase value="b_mon_info"><td nowrap>#ROW_SAL_MON#</td></cfcase>
                        <cfcase value="b_year_info"><td nowrap>#ROW_SAL_YEAR#</td></cfcase>
                        <cfcase value="b_tc_kimlik"><td title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='58025.TC Kimlik No'>">#tc_identy_no#</td></cfcase>
                        <cfcase value="b_employee_no"><td title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='58487.calisan No'>">#employee_no#</td></cfcase>
                       <cfcase value="b_statu"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='57894.Statü'>"><cfif ssk_statute eq 1><cf_get_lang dictionary_id ='53043.Normal'><cfelseif ssk_statute eq 2 or ssk_statute eq 18><cf_get_lang dictionary_id='58541.Emekli'><cfelse><cf_get_lang dictionary_id='58156.Diğer'></cfif></td></cfcase>
                        <cfcase value="b_sex"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='57764.Cinsiyet'>"><cfif sex eq 0><cf_get_lang dictionary_id ='58958.Kadın'><cfelseif sex eq 1><cf_get_lang dictionary_id ='58959.Erkek'></cfif></td></cfcase>
                        <cfcase value="b_ilgili_sirket"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53701.İlgili Şirket'>">#RELATED_COMPANY#</td></cfcase>
                        <cfcase value="b_sube"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='57453.Şube'>">#BRANCH_NAME#</td></cfcase>
                        <cfcase value="b_departman">
                            <cfif isdefined('attributes.is_dep_level') and listlen(dep_level_list)>
                            	<cfset count_dep = 0>
                                <cfloop list="#dep_level_list#" index="mm">
                                	<cfset count_dep = count_dep + 1>
                                    <td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='57572.Departman'> (#mm#)">
                                        <cfif len(evaluate('DEPARTMAN#count_dep#'))>#evaluate('DEPARTMAN#count_dep#')#<cfelse>-</cfif>
                                    </td>
                                </cfloop>
                            </cfif>
                            <td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='57572.Departman'>">#DEPARTMENT_HEAD#</td>
                        </cfcase>
                        <cfcase value="b_pozisyon_sube"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53729.Pozisyon Şube'>"><cfif listlen(branch_list) and len(position_branch_id)>#get_branchs.branch_name[listfind(branch_list,position_branch_id,',')]#<cfelse>&nbsp;</cfif></td></cfcase>
                        <cfcase value="b_pozisyon_departman"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53728.Pozisyon Departman'>"><cfif listlen(department_list) and len(position_department_id)>#get_departments.department_head[listfind(department_list,position_department_id,',')]#<cfelse>&nbsp;</cfif></td></cfcase>
                        <cfcase value="b_ise_giris"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53702.İşe Giriş '>" style="mso-number-format:'Short Date'">#dateformat(START_DATE,dateformat_style)#</td></cfcase>
                        <cfcase value="b_isten_cikis"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='29832.İşten Çıkış'>" style="mso-number-format:'Short Date'"><cfif len(FINISH_DATE) and (month(FINISH_DATE) eq ROW_SAL_MON and year(FINISH_DATE) eq ROW_SAL_YEAR)>#dateformat(FINISH_DATE,dateformat_style)#</cfif></td></cfcase>
                        <cfcase value="b_gruba_giris"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53704.Gruba Girişi'>" style="mso-number-format:'Short Date'">#dateformat(group_startdate,dateformat_style)#</td></cfcase>
                        <cfcase value="b_kidem_date"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53641.Kıdem Baz Tarihi'>" style="mso-number-format:'Short Date'">#dateformat(KIDEM_DATE,dateformat_style)#</td></cfcase>
                        <cfcase value="b_imza"><td width="200" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='58957.İmza'>">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td></cfcase>
                        <cfcase value="b_exp"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53882.İşten Çıkış Nedeni'>"><cfif len(finish_date) and (month(finish_date) eq row_sal_mon and year(finish_date) eq row_sal_year)>#get_explanation_name(explanation_id)#</cfif></td></cfcase>
                        <cfcase value="b_reason"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='38957.Şirket İçi Gerekçe'>"><cfif len(finish_date) and (month(finish_date) eq row_sal_mon and year(finish_date) eq row_sal_year)>#reason#</cfif></td></cfcase>
                        <cfcase value="b_ex_in_out_id"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59376.Giriş Gerekçe'>">#EX_IN#</td></cfcase>
                        <cfcase value="b_ozel_kod">
                            <td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='57789.Özel Kod'>">#hierarchy#</td>
                            <td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='57789.Özel Kod'>1">#ozel_kod#</td>
                            <td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='57789.Özel Kod'>2">#ozel_kod2#</td>
                            <cfif fusebox.dynamic_hierarchy><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='39962.Dinamik Hiyerarşi'>">#dynamic_hierarchy#.#dynamic_hierarchy_add#</td></cfif>
                        </cfcase>
                        <cfcase value="b_unvan"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='57571.Ünvan'>"><cfif listlen(title_list) and len(title_id)>#get_titles.title[listfind(title_list,title_id,',')]#<cfelse>&nbsp;</cfif></td></cfcase>
                        <cfcase value="b_pozisyon_tipi"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59004.Pozisyon Tipi'>"><cfif listlen(position_cat_list) and len(position_cat_id)>#get_position_cats.position_cat[listfind(position_cat_list,position_cat_id,',')]#<cfelse>&nbsp;</cfif></td></cfcase>
                        <cfcase value="b_collar_type"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='54054.Yaka Tipi'>"><cfif collar_type eq 1><cf_get_lang dictionary_id='54055.Mavi Yaka'><cfelseif collar_type eq 2><cf_get_lang dictionary_id='54056.Beyaz Yaka'></cfif></td></cfcase>
                        <cfcase value="b_grade_step"><td style="mso-number-format:\@;" nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='54179.Derece'> -<cf_get_lang dictionary_id='58710.Kademe'>"><cfif len(grade) or len(step)>#grade#-#step#<cfelse>&nbsp;</cfif></td></cfcase>
                        <cfcase value="b_pozisyon"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53164.Pozisyon'>">#position_name#</td></cfcase>
                        <cfcase value="b_org_step"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='58710.Kademe'>">#organization_step_name#</td></cfcase>
                        <cfcase value="b_duty_type"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='58538.Görev Tipi'>">#duty_type#</td></cfcase>
                        <cfcase value="b_idari_amir"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# -<cf_get_lang dictionary_id ='56110.Birinci Amir'>">#upper_position_employee#</td></cfcase>
                        <cfcase value="b_fonksiyonel_amir"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='56111.İkinci Amir'>">#upper_position_employee2#</td></cfcase>
                        <cfcase value="b_business_code">
                            <td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='55494.Meslek'> <cf_get_lang dictionary_id='32646.Kodu'>"><cfif len(BUSINESS_CODE_NAME)>#BUSINESS_CODE#</cfif></td>
                            <td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='55900.Meslek Grubu'>"><cfif len(BUSINESS_CODE_NAME)>#BUSINESS_CODE_NAME#</cfif></td>
                        </cfcase>
                        <cfcase value="b_ucret_yontemi">
                            <td align="center" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53714.Ücret Yöntemi'>">
                                <cfif salary_type eq 0>
                                    <cf_get_lang dictionary_id ='53260.Saatlik'> 
                                <cfelseif salary_type eq 1>
                                    <cf_get_lang  dictionary_id='58457.Günlük'>
                                <cfelseif salary_type eq 2>
                                    <cf_get_lang dictionary_id='58932.Aylık'> 
                                </cfif>
                            </td>
                        </cfcase>
                        <cfcase value="b_calisan_grubu">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id="56857.Çalışan Grubu"></cfsavecontent>
                            <td align="center" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - #message#">
								<cfif listlen(puantaj_group_ids_list) and len(puantaj_group_ids)>
									<cfloop list="#puantaj_group_ids#" index="pgi">
										#get_groups.group_name[listfind(puantaj_group_ids_list,pgi,',')]#<cfif listlast(puantaj_group_ids) neq pgi>, </cfif>
									</cfloop>
								<cfelse>&nbsp;</cfif>
                            </td>
                        </cfcase>
                        <cfcase value="b_kg"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="KG">#KISMI_ISTIHDAM_GUN#</td></cfcase>
                        <cfcase value="b_ks"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="KS">#KISMI_ISTIHDAM_SAAT#</td></cfcase>
                        <cfcase value="b_net_brut"><td nowrap><cfif GROSS_NET eq 0><cf_get_lang dictionary_id="53131.Brüt"><cfelse><cf_get_lang dictionary_id="58083.Net"></cfif></td></cfcase>
                        <cfcase value="b_maas"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="Ücret"><cfif isdefined("attributes.list_type") and attributes.list_type eq 2>#tlformat(maas,2)#<cfelse><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(maas_,2)#"></cfif></td></cfcase>  
                        <cfcase value="b_ss_gunu"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53715.SS Günü'>">#normal_gun#</td></cfcase>
                        <cfcase value="b_hs_gunu"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53716.HS Günü'>">#haftalik_tatil#</td></cfcase>
                        <cfcase value="b_genel_tatil_gunu"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53706.Genel Tatil Günü'>">#genel_tatil#</td></cfcase>
                        <cfcase value="b_ucretli_izin"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='53686.Ücretli İzin'>#Chr(10)##EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53686.Ücretli İzin'>">#normal_izinli#</td></cfcase>
                        <cfcase value="b_ucretli_izin_pazar"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='53687.Ücretli İzin Pazar'>#Chr(10)##EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53687.Ücretli İzin Pazar'>">#paid_izinli_sunday_count#</td></cfcase>
                        <cfcase value="b_ucretsiz_izin"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='53688.Ücretsiz İzin'>#Chr(10)##EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53688.Ücretsiz İzin'>">#izin#</td></cfcase>
                        <cfcase value="b_uzaktan_calisma_gun"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='63061.Uzaktan Çalışma Gün'>#Chr(10)##EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='63061.Uzaktan Çalışma Gün'>">#evaluate("get_remote_day.M#ROW_SAL_MON#")#</td></cfcase>
                        <cfcase value="b_toplam_gun"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="Toplam Gün">#total_days#<cfset t_toplam_days = t_toplam_days + total_days><cfset d_t_toplam_days = d_t_toplam_days + total_days></td></cfcase>
                        <cfcase value="b_toplam_calisma_gunu">
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53727.Çalışma Günü'>">
                                <cfif total_days lt puantaj_gun_>#total_days#<cfset t_days = t_days + total_days><cfset d_t_days = d_t_days + total_days><cfelse>#puantaj_gun_#<cfset t_days = t_days + puantaj_gun_><cfset d_t_days = d_t_days + puantaj_gun_></cfif>
                            </td>
                        </cfcase>
                        <cfcase value="b_ssk_gunu">
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53816.Toplam SGK Günü'> ">#ssk_days#<cfset d_t_sgk_normal_gun = d_t_sgk_normal_gun+ssk_days><cfset t_sgk_normal_gun = t_sgk_normal_gun+ssk_days></td>
                        </cfcase>
                        <cfcase value="b_hi_saat">
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"<cfif ListLen(work_day_hour, ".") gt 1></cfif> title="<cf_get_lang dictionary_id ='53715.SS Günü'> (<cf_get_lang dictionary_id='57491.Saat'>)"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(weekly_hour)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"<cfif ListLen(weekend_hour, ".") gt 1></cfif> title="<cf_get_lang dictionary_id ='53716.HS Günü'> (<cf_get_lang dictionary_id='57491.Saat'>)"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(weekend_hour)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"<cfif ListLen(offdays_count_hour, ".") gt 1></cfif> title="<cf_get_lang dictionary_id ='53706.Genel Tatil Günü'> (<cf_get_lang dictionary_id='57491.Saat'>)"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(offdays_count_hour)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"<cfif ListLen(izin_paid_count, ".") gt 1></cfif> title="<cf_get_lang dictionary_id ='53686.Ücretli İzin'> (<cf_get_lang dictionary_id='57491.Saat'>)"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(izin_paid_count-paid_izinli_sunday_count_hour)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"<cfif ListLen(paid_izinli_sunday_count_hour, ".") gt 1></cfif> title="<cf_get_lang dictionary_id ='53687.Ücretli İzin Pazar'> (<cf_get_lang dictionary_id='57491.Saat'>)"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(paid_izinli_sunday_count_hour)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"<cfif ListLen(izin_count, ".") gt 1></cfif> title="<cf_get_lang dictionary_id ='53688.Ücretsiz İzin'> (<cf_get_lang dictionary_id='57491.Saat'>)"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(izin_count)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"<cfif ListLen(t_saat, ".") gt 1></cfif> title="<cf_get_lang dictionary_id="46377.Toplam Saat">"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_saat)#"></td>
                        </cfcase>
                        <cfcase value="b_hafta_ici_mesai"><td nowrap<cfif ListLen(EXT_TOTAL_HOURS_0, ".") gt 1></cfif> title="<cf_get_lang dictionary_id ='53744.Hafta İçi Mesai'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(EXT_TOTAL_HOURS_0)#"><cfset t_h_ici = t_h_ici + EXT_TOTAL_HOURS_0><cfset d_t_h_ici = d_t_h_ici + EXT_TOTAL_HOURS_0></td></cfcase>
                        <cfcase value="b_hafta_ici_mesai_ucret"><td nowrap<cfif ListLen(EXT_TOTAL_HOURS_0_AMOUNT, ".") gt 1></cfif> title="<cf_get_lang dictionary_id ='53744.Hafta İçi Mesai'><cf_get_lang dictionary_id='55123.Ücret'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ext_salary_0)#"><cfset d_t_ext_salary_0 = d_t_ext_salary_0 + EXT_TOTAL_HOURS_0_AMOUNT></td></cfcase>
                        <cfcase value="b_hafta_sonu_mesai"><td nowrap<cfif ListLen(EXT_TOTAL_HOURS_1, ".") gt 1></cfif> title="<cf_get_lang dictionary_id ='53743.Hafta Sonu Mesai'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(EXT_TOTAL_HOURS_1)#"> <cfset t_h_sonu = t_h_sonu + EXT_TOTAL_HOURS_1><cfset d_t_h_sonu = d_t_h_sonu + EXT_TOTAL_HOURS_1></td></cfcase>
                        <cfcase value="b_hafta_sonu_mesai_ucret"><td nowrap<cfif ListLen(EXT_TOTAL_HOURS_1_AMOUNT, ".") gt 1></cfif> title="<cf_get_lang dictionary_id ='53743.Hafta Sonu Mesai'><cf_get_lang dictionary_id='55123.Ücret'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ext_salary_1)#"><cfset d_t_ext_salary_1 = d_t_ext_salary_1 + EXT_TOTAL_HOURS_1_AMOUNT></td></cfcase>
                        <cfcase value="b_resmi_tatil_mesai"><td nowrap<cfif ListLen(EXT_TOTAL_HOURS_2, ".") gt 1></cfif> title="<cf_get_lang dictionary_id ='53742.Resmi Tatil Mesai'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(EXT_TOTAL_HOURS_2)# "><cfset t_resmi = t_resmi + EXT_TOTAL_HOURS_2><cfset d_t_resmi = d_t_resmi + EXT_TOTAL_HOURS_2></td></cfcase>
                        <cfcase value="b_resmi_tatil_mesai_ucret"><td nowrap<cfif ListLen(EXT_TOTAL_HOURS_2_AMOUNT, ".") gt 1></cfif> title="<cf_get_lang dictionary_id ='53742.Resmi Tatil Mesai'><cf_get_lang dictionary_id='55123.Ücret'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ext_salary_2)# "><cfset d_t_ext_salary_2 = d_t_ext_salary_2 + EXT_TOTAL_HOURS_2_AMOUNT></td></cfcase>
                        <cfcase value="b_gece_mesai_saat"><td nowrap<cfif ListLen(EXT_TOTAL_HOURS_5, ".") gt 1></cfif> title="<cf_get_lang dictionary_id='54329.Gece Mesaisi'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(EXT_TOTAL_HOURS_5)#"><cfset d_t_ext_salary_5 = d_t_ext_salary_5 + EXT_TOTAL_HOURS_5_AMOUNT></td></cfcase>
                        <cfcase value="b_gece_mesai_ucret"><td nowrap<cfif ListLen(EXT_TOTAL_HOURS_5_AMOUNT, ".") gt 1></cfif> title="<cf_get_lang dictionary_id='54329.Gece Mesaisi'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ext_salary_5)#"></td></cfcase>
                        <cfcase value="b_aylik_mesaisiz"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53717.Aylık Mesaisiz'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(total_amount - ext_salary,2)#"></td></cfcase>
                        <cfcase value="b_fazla_mesai"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53718.Fazla Mesai'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ext_salary,2)#"></td></cfcase>
                        <cfcase value="b_fazla_mesai_net"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53718.Fazla Mesai'><cf_get_lang dictionary_id='58083.Net'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ext_salary_net,2)#"></td></cfcase>
                        <cfcase value="b_gunluk_ucret"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53242.Günlük Ücret'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ucretim,2)#"></td></cfcase>
                        <cfcase value="b_aylik_ucret"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53243.Aylık Ücret'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(total_amount,2)#"></td></cfcase>
                        <cfcase value="b_aylik_brut_ucret"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='47803.Aylık Brüt Ücret'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(aylik_brut_ucret,2)#"></td></cfcase>
                        <cfcase value="b_ek_odenek"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53082.Ek Ödenek'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(total_pay_ssk_tax+total_pay_ssk+total_pay_tax+total_pay,2)#"></td></cfcase>
                        <cfcase value="b_toplam_kazanc"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53244.Toplam Kazanç'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(TOTAL_SALARY-VERGI_ISTISNA_SSK-VERGI_ISTISNA_VERGI+VERGI_ISTISNA_AMOUNT_,2)#"></td></cfcase>
                        <cfcase value="b_sgk_matrahi"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53245.SGK Matrahı'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(SSK_MATRAH,2)#"></td></cfcase>
                        <cfcase value="b_sgk_isci_hissesi">
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53246.SSK İşçi H'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isci_hissesi-ssk_isci_hissesi_687,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='47802.SGDP İşçi Hissesi'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssdf_isci_hissesi,2)#"></td>
                        </cfcase>
                        <cfcase value="b_isci_primi_indirimli">
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id = '54271.İndirimli'> <cf_get_lang no='773.SGK İşçi Primi'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(isci_primi_indirimli,2)#"></td>
                        </cfcase>
                        <cfcase value="b_issizlik_isci_hissesi"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='54330.İşsizlik Sigortası İşçi Primi'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(issizlik_isci_hissesi-issizlik_isci_hissesi_687,2)#"></td></cfcase>
                        <cfcase value="b_issizlik_isci_hissesi_indirimli"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang no='1325.İndirimli'> <cf_get_lang no='1329.İşsizlik Sigortası İşçi'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(issizlik_isci_primi_indirimli,2)#"></td></cfcase>
                        <cfcase value="b_gelir_vergisi_indirimi"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53248.Gelir Vergisi İndirimi'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(vergi_indirimi+sakatlik_indirimi,2)#"></td></cfcase>
                        <cfcase value="b_gelir_vergisi_matrahi"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53249.Gelir Vergisi Matrahı'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(gelir_vergisi_matrah,2)#"></td></cfcase>
                        <cfcase value="b_gelir_vergisi_hesaplanan">
                        <td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53689.Gelir Vergisi Hesaplanan'>">
                            <cfif attributes.sal_year lte 2021>
                                <cfset gelir_vergisi_hesaplanan_ = vergi_iadesi + gelir_vergisi + VERGI_INDIRIMI_5084>
                                <cfif is_5746_control eq 0>
                                <cfset gelir_vergisi_hesaplanan_ = gelir_vergisi_hesaplanan_ + gelir_vergisi_indirimi_5746>
                                </cfif>
                                <cfif is_4691_control eq 0>
                                <cfset gelir_vergisi_hesaplanan_ = gelir_vergisi_hesaplanan_ + gelir_vergisi_indirimi_4691>
                                </cfif>
                            <cfelseif gelir_vergisi-gelir_vergisi_indirimi_687-gelir_vergisi_indirimi_7103 gt 0>
                                <cfset gelir_vergisi_hesaplanan_ = gelir_vergisi-gelir_vergisi_indirimi_687-gelir_vergisi_indirimi_7103 + daily_minimum_income_tax>
                            <cfelseif gelir_vergisi eq 0 and income_tax_temp gt 0>
                                <cfset gelir_vergisi_hesaplanan_ = income_tax_temp>
                            <cfelse>
                                <cfset gelir_vergisi_hesaplanan_ = 0>
                            </cfif>
                            <cfset d_t_gelir_vergisi_hesaplanan = d_t_gelir_vergisi_hesaplanan + gelir_vergisi_hesaplanan_>
                            <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(gelir_vergisi_hesaplanan_,2)#">
                        </td>
                        </cfcase>
                        <cfcase value="b_asgari_gecim_indirimi"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53659.Asgari Geçim İndirimi'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(vergi_iadesi,2)#"></td></cfcase>
                        <cfcase value="b_gelir_vergisi_indirimi_5746"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53248.Gelir Vergisi İndirimi'> 5746"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(gelir_vergisi_indirimi_5746,2)#"></td></cfcase>
                        <cfcase value="b_gelir_vergisi_indirimi_4691"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53248.Gelir Vergisi İndirimi'> 4691"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(gelir_vergisi_indirimi_4691,2)#"></td></cfcase>

                        <cfcase value="b_daily_minimum_wage_base_cumulate"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='64700.Asgari Ücrete Göre Gelir Vergi Matrahı'> "><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(daily_minimum_wage_base_cumulate)#"></td></cfcase>
                        <cfcase value="b_daily_minimum_income_tax"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='64702.Asgari Ücret Gelir Vergisi'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(daily_minimum_income_tax)#"></td></cfcase>
                        <cfcase value="b_income_tax_temp"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='64746.Asgari Ücret Faydalanılan'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(income_tax_temp)#"></td></cfcase>
                        <cfcase value="b_daily_minimum_wage"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='64703.Asgari Ücret Damga Vergisi Matrahı'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(daily_minimum_wage)#"></td></cfcase>
                        <cfcase value="b_daily_minimum_wage_stamp_tax"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='64704.Asgari Ücret Damga Vergisi'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(daily_minimum_wage_stamp_tax)#"></td></cfcase>
                        <cfcase value="b_stamp_tax_temp"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='64769.Asgari Ücret Faydalanılan Damga Vergisi'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(stamp_tax_temp)#"></td></cfcase>
                        <cfcase value="b_minimum_wage_cumulative"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='64700.Asgari Ücrete Göre Gelir Vergi Matrahı'> "><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(minimum_wage_cumulative)#"></td></cfcase>

                        <cfcase value="b_gelir_vergisi"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='40452.Gelir Vergisi'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(gelir_vergisi-gelir_vergisi_indirimi_687-gelir_vergisi_indirimi_7103,2)#"></td></cfcase>
                        <cfcase value="b_vergi_indirimi_5615"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='38971.Vergi İndirimi '> <cfif (attributes.sal_year eq 2007 and attributes.sal_mon gt 6) or attributes.sal_year gte 2008>5615<cfelse>5084</cfif>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(VERGI_INDIRIMI_5084,2)#"></td></cfcase>
                        <cfcase value="b_kum_gelir_vergisi_matrahi">
							<td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='59515.Küm Gel Ver Matrah'>">
								<!----122431 ID'li iş kaydı için kapatıldı. Doğruluğu teyit edildikten sonra silinecek.
                                    <cfif (len(CUMULATIVE_TAX_TOTAL) and isnumeric(START_CUMULATIVE_TAX)) and ROW_SAL_YEAR eq year(start_date)>
                                    <cfset cumulative_value = KUMULATIF_GELIR_MATRAH + CUMULATIVE_TAX_TOTAL>
								<cfelse>
									<cfset cumulative_value = KUMULATIF_GELIR_MATRAH >
                                </cfif>---->
                                <cfset cumulative_value = KUMULATIF_GELIR_MATRAH >
								<cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(cumulative_value,2)#">
							</td>
						</cfcase>
                        <cfcase value="b_damga_vergisi">
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='41439.Damga Vergisi'>">
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(damga_vergisi-damga_vergisi_indirimi_687-damga_vergisi_indirimi_7103,2)#">
                             </td>
                        </cfcase>
                        <cfcase value="b_damga_vergisi_indirimsiz">
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='41439.Damga Vergisi'>">
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(damga_vergisi_,2)#">
                            </td>
                        </cfcase>
                        <cfcase value="b_damga_vergisi_matrah"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59363.Damga Vergisi Matrahı'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(damga_vergisi_matrah,2)#"></td></cfcase>
                        <cfcase value="b_toplam_yasal_kesinti">
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53722.Toplam Yasal Kesinti'>">
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isci_hissesi + ssdf_isci_hissesi + gelir_vergisi + damga_vergisi + issizlik_isci_hissesi + bes_isci_hissesi,2)#">
                            </td>
                        </cfcase>
                        <cfcase value="b_onceki_aydan_devreden_kum_mat">
                        <td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='54297.Önceki Aydan Dev Küm Matrah'>">&nbsp;
                            <cfif isdefined("onceki_donem_kum_gelir_vergisi_matrahi")>
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(onceki_donem_kum_gelir_vergisi_matrahi,2)#">
                            <cfelse>
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_kum_gelir_vergisi_matrahi,2)#">
                            </cfif>
                        </td>
                        </cfcase>
                        <cfcase value="b_sgk_devir_isci_hissesi_fark"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='54300.SGK Devir Isci Hissesi Fark'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(sgk_isci_hissesi_fark,2)#"></td></cfcase>
                        <cfcase value="b_sgk_devir_issizlik_hissesi_fark"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='54301.SGK Devir Issizlik Hissesi Fark'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(sgk_issizlik_hissesi_fark,2)#"></td></cfcase>
                        <cfcase value="b_sgdp_isci_primi_fark"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='54302.SGDP İşçi Primi Fark'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(sgdp_isci_primi_fark,2)#"></td></cfcase>
                        <cfcase value="b_muhtelif_kesintiler"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53254.Muhtelif Kesintiler'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ozel_kesinti,2)#"></td></cfcase>
                        <cfcase value="b_net_ucret"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53255.Net Ücret'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(net_ucret-vergi_iadesi,2)#"></td></cfcase>
                        <cfcase value="b_toplam_net_odenecek"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53691.Toplam Net Ödenecek'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(net_ucret,2)#"></td></cfcase>
                        <cfcase value="b_sgk_isveren_primi_hesaplanan">
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53698.SGK İşveren Primi Hesaplanan'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(isveren_hesaplanan,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59364.SGDP İşveren Primi Hesaplanan'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssdf_isveren_hissesi,2)#"></td>
                        </cfcase>
                        <cfcase value="b_muhasebe_kod_group"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='54117.Muhasebe Kod Grubu'>"><cfif listlen(def_list) and len(account_bill_type)>#get_definition.DEFINITION[listfind(def_list,account_bill_type)]#</cfif></td></cfcase>
                        <cfcase value="b_sgk_5084"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53699.SGK İşveren Hissesi'> 5615"><cfif ssk_isci_hissesi eq 0><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(0,2)#"><cfelse><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isveren_hissesi_5084,2)#"></cfif></td></cfcase>
                        <cfcase value="b_sgk_5763"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53699.SGK İşveren Hissesi'>"><cfif ssk_isci_hissesi eq 0><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(0,2)#"><cfelse><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isveren_hissesi_gov,2)#"></cfif></td></cfcase>
                        <cfcase value="b_sgk_5510"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 5510 "><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isveren_hissesi_5510_,2)#"></td></cfcase>
                        <cfcase value="b_sgk_5921"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 5921"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isveren_hissesi_5921,2)#"></td></cfcase>
                        <cfcase value="b_sgk_5746"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 5746"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isveren_hissesi_5746,2)#"></td></cfcase>
                        <cfcase value="b_sgk_4691"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 4691"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isveren_hissesi_4691,2)#"></td></cfcase>
                        <cfcase value="b_sgk_6111"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 6111"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isveren_hissesi_6111,2)#"></td></cfcase>
                        <cfcase value="b_sgk_6486"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 6486"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isveren_hissesi_6486,2)#"></td></cfcase>
                        <cfcase value="b_sgk_46486"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 46486"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isveren_hissesi_46486,2)#"></td></cfcase>
                        <cfcase value="b_sgk_56486"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 56486"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isveren_hissesi_56486,2)#"></td></cfcase>
                        <cfcase value="b_sgk_66486"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 66486"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isveren_hissesi_66486,2)#"></td></cfcase>
                        <cfcase value="b_sgk_6322"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 6322"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isveren_hissesi_6322+ssk_isci_hissesi_6322,2)#"></td></cfcase>
                        <cfcase value="b_sgk_14857"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53699.SGK İşveren Hissesi'> 14857"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isveren_hissesi_14857,2)#"></td></cfcase>
                        <cfcase value="b_sgk_3294"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53699.SGK İşveren Hissesi'> 3294"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isveren_hissesi_3294_,2)#"></td></cfcase>
                        <cfcase value="b_sgk_6645"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 6645"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isveren_hissesi_6645,2)#"></td></cfcase>
                        <cfcase value="b_sgk_7252"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 7252"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isveren_hissesi_7252,2)#"></td></cfcase>
                        <cfcase value="b_issizlik_sgk_7252"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 7252"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ISSIZLIK_ISVEREN_HISSESI_7252,2)#"></td></cfcase>
                        <cfcase value="b_sgk_7256"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 7256"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isveren_hissesi_7256_,2)#"></td></cfcase>
                        <cfcase value="b_issizlik_sgk_7256"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 7256"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ISSIZLIK_ISVEREN_HISSESI_7256,2)#"></td></cfcase>

                        <cfcase value="b_sgk_isci_687"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59368.SGK İşçi Primi İndirimi'> 687"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isci_hissesi_687,2)#"></td></cfcase>
                        <cfcase value="b_issizlik_isci_687"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59369.İssizlik İşçi Primi İndirimi'> 687"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(issizlik_isci_hissesi_687,2)#"></td></cfcase>
                        <cfcase value="b_sgk_isci_7252"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59368.SGK İşçi Primi İndirimi'> 7252"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isci_hissesi_7252,2)#"></td></cfcase>
                        <cfcase value="b_issizlik_isci_7252"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59369.İssizlik İşçi Primi İndirimi'> 7252"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(issizlik_isci_hissesi_7252,2)#"></td></cfcase>
                         <cfcase value="b_sgk_isci_7256"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59368.SGK İşçi Primi İndirimi'> 7256"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isci_hissesi_7256,2)#"></td></cfcase>
                        <cfcase value="b_issizlik_isci_7256"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59369.İssizlik İşçi Primi İndirimi'> 7256"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(issizlik_isci_hissesi_7256,2)#"></td></cfcase>
                        <cfcase value="b_gelir_verigisi_687"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53248.Gelir Vergisi İndirimi'> 687"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(gelir_vergisi_indirimi_687,2)#"></td></cfcase>
                        <cfcase value="b_damga_vergisi_687"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59370.Damga Vergisi İndirimi'> 687"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(damga_vergisi_indirimi_687,2)#"></td></cfcase>
                        <cfcase value="b_sgk_isveren_687"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59371.SGK İşveren İndirimi'>687"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isveren_hissesi_687,2)#"></td></cfcase>
                        <cfcase value="b_issizlik_isveren_687"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59372.İşsizlik İşveren İndirimi'>687"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(issizlik_isveren_hissesi_687,2)#"></td></cfcase>
                        
                        <cfcase value="b_sgk_isci_7103"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59368.SGK İşçi Primi İndirimi'> 7103"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isci_hissesi_7103,2)#"></td></cfcase>
                        <cfcase value="b_issizlik_isci_7103"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59369.İssizlik İşçi Primi İndirimi'> 7103"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(issizlik_isci_hissesi_7103,2)#"></td></cfcase>
                        <cfcase value="b_gelir_verigisi_7103"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53248.Gelir Vergisi İndirimi'> 7103"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(gelir_vergisi_indirimi_7103,2)#"></td></cfcase>
                        <cfcase value="b_damga_vergisi_7103"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59370.Damga Vergisi İndirimi'> 7103"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(damga_vergisi_indirimi_7103,2)#"></td></cfcase>
                        <cfcase value="b_sgk_isveren_7103"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59371.SGK İşveren İndirimi'> 7103"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isveren_hissesi_7103,2)#"></td></cfcase>
                        <cfcase value="b_issizlik_isveren_7103"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59372.İşsizlik İşveren İndirimi'> 7103"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(issizlik_isveren_hissesi_7103,2)#"></td></cfcase>                        
                        
                        <cfcase value="b_sgk_isveren_hissesi">

                            <td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53699.SSK İşv H'>">
                                <cfset new_value = ssk_isveren_hissesi - ssk_isveren_hissesi_gov - ssk_isveren_hissesi_5921 - ssk_isveren_hissesi_5746 -ssk_isveren_hissesi_4691 - ssk_isveren_hissesi_6111-ssk_isveren_hissesi_6645-ssk_isveren_hissesi_6486-  ssk_isveren_hissesi_46486 - ssk_isveren_hissesi_56486 - ssk_isveren_hissesi_66486-ssk_isveren_hissesi_6322-ssk_isveren_hissesi_687-ssk_isveren_hissesi_7103 - ssk_isveren_hissesi_14857 - ssk_isveren_hissesi_3294_ - ssk_isveren_hissesi_7252_ - ssk_isveren_hissesi_7256_>
                                <cfif new_value lt 0><cfset new_value = 0></cfif>
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(new_value,2)#">
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59377.SGDP İşveren Hissesi'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssdf_isveren_hissesi,2)#"></td>
                        </cfcase>
                        <cfcase value="b_toplam_sgk_prim">
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59373.SGK Primi'>">
                                <cfset new_sgk_prim = ssk_isveren_hissesi - ssk_isveren_hissesi_gov - ssk_isveren_hissesi_5921 - ssk_isveren_hissesi_5746 -ssk_isveren_hissesi_4691- ssk_isveren_hissesi_6111-ssk_isveren_hissesi_6645-ssk_isveren_hissesi_6486- ssk_isveren_hissesi_46486 - ssk_isveren_hissesi_56486 - ssk_isveren_hissesi_66486-ssk_isveren_hissesi_6322+ssk_isci_hissesi - ssk_isveren_hissesi_687 -ssk_isci_hissesi_687 - ssk_isveren_hissesi_7103 -ssk_isci_hissesi_7103 -ssk_isveren_hissesi_14857 - ssk_isveren_hissesi_3294_ - ssk_isveren_hissesi_7252_ - ssk_isveren_hissesi_7256_>
                                <cfif new_sgk_prim lt 0>
                                    <cfset new_sgk_prim = 0>
                                </cfif>
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(new_sgk_prim,2)#">
                            </td>
                        </cfcase>
                        <cfcase value="b_bes_isci_hissesi"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59374.BES Katılım Payı'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(bes_isci_hissesi,2)#"></td></cfcase>
                        <cfcase value="b_issizlik_isveren_hissesi"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53257.İşsizlik Sigortası İşveren  Primi'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(issizlik_isveren_hissesi-issizlik_isveren_hissesi_687,2)#"></td></cfcase>
                        <cfcase value="b_issizlik_isveren_hissesi_indirimli"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53257.İşsizlik Sigortası İşveren  Primi'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(issizlik_isveren_primi_indirimli,2)#"></td></cfcase>
                        <cfcase value="b_yillik_izin_tutari"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53393.Yıllık İzin T'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(yillik_izin,2)#"></td></cfcase>
                        <cfcase value="b_kidem_tazminati"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='52991.Kıdem Tazminatı'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(kidem_amount,2)#"></td></cfcase>
                        <cfcase value="b_ihbar_tazminati"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='52992.İhbar Tazminatı'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ihbar_amount,2)#"></td></cfcase>
                        <cfcase value="b_toplam_isveren_maliyeti"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53708.Toplam İşveren Maliyeti'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(toplam_isveren,2)#"></td></cfcase>
                        <cfcase value="b_toplam_isveren_maliyeti_indirimsiz">
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='59378.Toplam İşveren Maliyeti İndirimsiz'> ">
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(toplam_isveren_indirimsiz,2)#">
                            </td>
                        </cfcase>
                        <cfcase value="b_ucret_tipi"><td nowrap><cfif sabit_prim eq 0><cf_get_lang dictionary_id='58544.Sabit'><cfelse><cf_get_lang dictionary_id ='53558.Primli'></cfif></td></cfcase>
                        <cfcase value="b_odeme_metodu"><td nowrap><cfif len(paymethod_id)>#GET_PAY_METHODS.paymethod[listfind(pay_list,paymethod_id,',')]#<cfelse>&nbsp;</cfif></td></cfcase>  
                        <cfcase value="b_fonksiyon"><td nowrap><cfif listlen(fonsiyonel_list) and len(FUNC_ID)>#get_units.unit_name[listfind(fonsiyonel_list,func_id,',')]#<cfelse>&nbsp;</cfif></td></cfcase>
                        <cfcase value="b_vergi_istisna_toplam"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53017.Vergi İstisna'> <cf_get_lang dictionary_id='57492.Toplam'> "><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(vergi_istisna_total,2)#"></td></cfcase>
                        <cfcase value="b_vergi_istisna_sgk"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59379.Vergi İstisna SSK'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(vergi_istisna_ssk,2)#"></td></cfcase>
                        <cfcase value="b_vergi_istisna_sgk_net"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59380.Vergi İstisna SSK Net'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(vergi_istisna_ssk_net,2)#"></td></cfcase>
                        <cfcase value="b_vergi_istisna_vergi"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53017.Vergi İstisna'> <cf_get_lang dictionary_id='33304.Vergi'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(vergi_istisna_vergi,2)#"></td></cfcase>
                        <cfcase value="b_vergi_istisna_vergi_net"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53017.Vergi İstisna'> <cf_get_lang dictionary_id='59381.Vergi Net'> "><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(vergi_istisna_vergi_net,2)#"></td></cfcase>
                        <cfcase value="b_vergi_istisna_damga"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53017.Vergi İstisna'> <cf_get_lang dictionary_id='54121.Damga'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(vergi_istisna_damga,2)#"></td></cfcase>
                        <cfcase value="b_vergi_istisna_damga_net"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53017.Vergi İstisna'> <cf_get_lang dictionary_id='59382.Damga Net'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(vergi_istisna_damga_net,2)#"></td></cfcase>
                        <cfcase value="b_ek_odenekler">
                            <cfset count_ = 0>
                            <cfloop list="#odenek_names#" index="cca">
                                <cfset count_ = count_ + 1>
                                <cfif isdefined('ODENEK_#count_#')>
                                    <cfset this_ = evaluate('ODENEK_#count_#')>
                                <cfelse>
                                    <cfset this_ = 0>
                                </cfif>
                                <cfif isdefined('ODENEK_NET_#count_#')>
                                    <cfset this_net_ = evaluate('ODENEK_NET_#count_#')>
                                <cfelse>
                                    <cfset this_net_ = 0>
                                </cfif>
                                <cfif this_net_ eq 0>
                                    <cfset this_net_ = this_>
                                </cfif>				
                                <!---<cfif evaluate('FROM_SALARY_#count_#') eq 0 and evaluate('CALC_DAYS_#count_#') eq 1 and total_days gt 0>
                                    <cfset this_net_ = this_net_/30*#total_days#>
                                </cfif>--->
                                <cfset 't_odenek_#count_#' = evaluate("t_odenek_#count_#") + this_>
                                <cfset 'd_t_odenek_#count_#' = evaluate("d_t_odenek_#count_#") + this_>
                                
                                <cfset 't_odenek_net_#count_#' = evaluate("t_odenek_net_#count_#") + this_net_>
                                <cfset 'd_t_odenek_net_#count_#' = evaluate("d_t_odenek_net_#count_#") + this_net_>
                                <td nowrap title="#employee_name# #employee_surname# - #cca#"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(this_,2)#"></td>
                                <cfif x_payment_type eq 1>
                                    <td nowrap title="#employee_name# #employee_surname# - #cca#"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(this_net_,2)#"></td>
                                </cfif>
                            </cfloop>
                        </cfcase>
                        <cfcase value="b_vergi_istisna">
                            <cfset count_ = 0>
                            <cfloop list="#vergi_istisna_names#" index="cca">
                                <cfset count_ = count_ + 1>
                                <cfquery name="get_this_istisna_amount" dbtype="query">
                                    SELECT SUM(AMOUNT) AS AMOUNT FROM get_vergi_istisna WHERE EMPLOYEE_PUANTAJ_ID IN (#EMPLOYEE_PUANTAJ_ID#) AND AMOUNT IS NOT NULL AND COMMENT_PAY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cca#">
                                </cfquery>
                                <cfif evaluate('VERGI_ISTISNA_#count_#') eq 0 and evaluate('VERGI_ISTISNA_TOTAL_#count_#') eq 0 and get_this_istisna_amount.recordcount neq 0 and get_this_istisna_amount.amount neq 0>
                                    <cfset this_ =  get_this_istisna_amount.amount>
                                    <cfset this_net_ =  get_this_istisna_amount.amount>
                                <cfelse>
                                    <cfset this_ =  evaluate('VERGI_ISTISNA_#count_#')>
                                    <cfset this_net_ =  evaluate('VERGI_ISTISNA_TOTAL_#count_#')>
                                </cfif>
                                <cfset 't_vergi_#count_#' = evaluate("t_vergi_#count_#") + this_>
                                <cfset 'd_t_vergi_#count_#' = evaluate("d_t_vergi_#count_#") + this_>
                                <cfset 't_vergi_net_#count_#' = evaluate("t_vergi_net_#count_#") + this_net_>
                                <cfset 'd_t_vergi_net_#count_#' = evaluate("d_t_vergi_net_#count_#") + this_net_>
                                <td nowrap title="#employee_name# #employee_surname# - #cca#"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(this_,2)#"></td>
                                <td nowrap title="#employee_name# #employee_surname# - #cca#"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(this_net_,2)#"></td>
                            </cfloop>
                        </cfcase>
                        <cfcase value="b_kesintiler">
                            <td nowrap title="Avans">
                                <cfset this_avans_ =  avans>
                                <cfset t_avans = t_avans + this_avans_>
                                <cfset d_t_avans = d_t_avans + this_avans_>
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(this_avans_,2)#">
                            </td>
                            <cfset count_ = 0>
                            <cfloop list="#kesinti_names#" index="cca">
                                <cfset count_ = count_ + 1>
                                <cfif isdefined("KESINTI_#count_#")>
                                    <cfset this_ = evaluate('KESINTI_#count_#')>
                                    <cfset 't_kesinti_#count_#' = evaluate("t_kesinti_#count_#") + this_>
                                    <cfset 'd_t_kesinti_#count_#' = evaluate("d_t_kesinti_#count_#") + this_>
                                <cfelse>
                                    <cfset this_ = 0>
                                </cfif>
                                <td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - #cca#"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(this_,2)#"></td>
                            </cfloop>
                        </cfcase>
                        <cfcase value="b_masraf_merkezi"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='58460.Masraf Merkezi'>"><cfif listlen(main_expense_list) and len(expense_code)>#get_expenses.EXPENSE[listfind(main_expense_list,expense_code,';')]#</cfif></td></cfcase>
                        <cfcase value="b_masraf_merkezi_kodu"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='58460.Masraf Merkezi'> <cf_get_lang dictionary_id='32646.Kodu'>">#expense_code#</td></cfcase>
                        <cfcase value="b_muhasebe_kodu"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='58811.Muhasebe Kodu'>">#account_code#</td></cfcase>
                        <cfcase value="b_banka"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='57521.Banka'>">#BANK_NAME#</td></cfcase>
                        <cfcase value="b_hesap_no"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='43744.Banka Şube Kodu'>">#BANK_BRANCH_CODE#-#BANK_ACCOUNT_NO#</td></cfcase>
                        <cfcase value="b_iban_no"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='54332.Iban No'>">#IBAN_NO#</td></cfcase>
                        <cfcase value="b_toplam_devreden_sgk_matrahi"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='54333.Toplam devreden sgk matrahı'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat((ssk_devir_ + ssk_devir_last_),2)#"></td></cfcase>
                        <cfcase value="b_2_onceki_aydan_devreden_sgk_matrahi"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='54334.İki Önceki aydan devreden sgk matrahı'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_devir_last_,2)#"></td></cfcase>
                        <cfcase value="b_1_onceki_aydan_devreden_sgk_matrahi"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='54335.Bir Önceki aydan devreden sgk matrahı'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_devir_,2)#"></td></cfcase>
                        <cfcase value="b_buaydan_devreden_sgk_matrahi"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59375.Bu aydan devreden sgk matrahı'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_amount,2)#"></td></cfcase>
                        <cfcase value="b_kesinti_ve_agi_oncesi_net">
                        	<td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='54310.Kesinti ve Agi Öncesi Net'>">
                            	<cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(net_ucret-vergi_iadesi-stampduty_5746_val+ozel_kesinti+bes_isci_hissesi)#">
								<cfset d_agi_oncesi_net = d_agi_oncesi_net+net_ucret-vergi_iadesi-stampduty_5746_val+ozel_kesinti+bes_isci_hissesi>
								<cfset t_agi_oncesi_net = t_agi_oncesi_net+net_ucret-vergi_iadesi-stampduty_5746_val+ozel_kesinti+bes_isci_hissesi>
                            </td>
                        </cfcase>
                    </cfswitch>
                  </cfloop>
                </tr>
                <cfif isdefined("attributes.sort_type") and len(attributes.sort_type) and (currentrow eq recordcount or type is not '#type[get_puantaj_rows.currentrow+1]#')>
                    <cfset cols_plus_ilk = cols_plus>
                    <cfset yillik_izin = d_t_yillik_izin>
                    <cfset cols_plus = cols_plus + 5>
                    <tr height="25" class="txtbold">
                        <cfloop list="#attributes.b_obj_hidden_new#" index="xlr">
                            <cfswitch expression="#xlr#">
                                <cfcase value="b_baslik">
                                    <td class="txtbold" nowrap>
                                        <cfif attributes.sort_type eq 1>
                                            #branch_name# - #department_head#
                                        <cfelseif attributes.sort_type eq 2>
                                            <cfif listlen(main_expense_list) and len(type)>
                                                #get_expenses.EXPENSE[listfind(main_expense_list,type,';')]#
                                            </cfif>
                                        <cfelseif attributes.sort_type eq 3>
                                            #UPPER_POSITION_EMPLOYEE#
                                        <cfelseif attributes.sort_type eq 4>
                                            #UPPER_POSITION_EMPLOYEE2#
                                        </cfif> 
                                        <cf_get_lang dictionary_id ='53263.Toplamlar'>
                                    </td>
                                </cfcase>
                                <cfcase value="b_sira_no"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_mon_info"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_year_info"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_sgk_no"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_ad_soyad"><td nowrap>&nbsp;</td></cfcase>
                                <cfcase value="b_employee_no"><td nowrap>&nbsp;</td></cfcase>
                                <cfcase value="b_tc_kimlik"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_statu"><td nowrap>&nbsp;</td></cfcase>
                                <cfcase value="b_sex"><td nowrap>&nbsp;</td></cfcase>
                                <cfcase value="b_ilgili_sirket"><td nowrap>&nbsp;</td></cfcase>
                                <cfcase value="b_sube"><td nowrap>&nbsp;</td></cfcase>
                                <cfcase value="b_departman">
                                    <cfif isdefined('attributes.is_dep_level')>
                                        <cfloop query="#get_dep_lvl#">
                                            <td nowrap>&nbsp;</td>
                                        </cfloop>
                                    </cfif>
                                    <td nowrap>&nbsp;</td>
                                </cfcase>
                                <cfcase value="b_pozisyon_sube"><td nowrap>&nbsp;</td></cfcase>
                                <cfcase value="b_pozisyon_departman"><td nowrap>&nbsp;</td></cfcase>
                                <cfcase value="b_ise_giris"><td nowrap>&nbsp;</td></cfcase>
                                <cfcase value="b_isten_cikis"><td nowrap>&nbsp;</td></cfcase>
                                <cfcase value="b_gruba_giris"><td style="text-align:right;mso-number-format:'0\.00';" nowrap>&nbsp;</td></cfcase>
                                <cfcase value="b_kidem_date"><td style="text-align:right;mso-number-format:'0\.00';" nowrap>&nbsp;</td></cfcase>
                                <cfcase value="b_imza"><td style="text-align:right;mso-number-format:'0\.00';">&nbsp;</td></cfcase>
                                <cfcase value="b_idari_amir"><td style="text-align:right;mso-number-format:'0\.00';" nowrap>&nbsp;</td></cfcase>
                                <cfcase value="b_fonksiyonel_amir"><td style="text-align:right;mso-number-format:'0\.00';" nowrap>&nbsp;</td></cfcase>
                                <cfcase value="b_business_code">
                                	<td style="text-align:right;mso-number-format:'0\.00';" nowrap>&nbsp;</td>
                                	<td style="text-align:right;mso-number-format:'0\.00';" nowrap>&nbsp;</td>
                                </cfcase>
                                <cfcase value="b_ozel_kod"><td nowrap <cfif fusebox.dynamic_hierarchy>colspan="4"<cfelse>colspan="3"</cfif>>&nbsp;</td></cfcase>
                                <cfcase value="b_unvan"><td nowrap>&nbsp;</td></cfcase>
                                <cfcase value="b_pozisyon_tipi"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_collar_type"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_grade_step"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_pozisyon"><td nowrap>&nbsp;</td></cfcase>
                                <cfcase value="b_org_step"><td nowrap>&nbsp;</td></cfcase>
                                <cfcase value="b_duty_type"><td nowrap>&nbsp;</td></cfcase>
                                <cfcase value="b_ucret_yontemi"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_calisan_grubu"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_net_brut"><td style="text-align:right;mso-number-format:'0\.00';">&nbsp;</td></cfcase>
                                <cfcase value="b_maas"><td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_maas,2)#"></td></cfcase>
                                <cfcase value="b_ss_gunu"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='53741.SSK Gün Toplamı'>">#d_normal_gun_total#</td></cfcase>
                                <cfcase value="b_hs_gunu"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='53740.Hafta Sonu Gün Toplamı'>">#d_haftalik_tatil_total#</td></cfcase>
                                <cfcase value="b_genel_tatil_gunu"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='53739.Genel Tatil Gün Toplamı'>">#d_genel_tatil_total#</td></cfcase>
                                <cfcase value="b_ucretli_izin"><td style="text-align:right;mso-number-format:'0\.00';" nowrap title="<cf_get_lang dictionary_id ='53738.Ücretli İzin Gün Toplamı'>">#d_t_izin_paid#</td></cfcase>
                                <cfcase value="b_ucretli_izin_pazar"><td style="text-align:right;mso-number-format:'0\.00';" nowrap title="<cf_get_lang dictionary_id ='53737.Ücretli İzin Pazar  Toplamı'>">#d_t_paid_izinli_sunday_count#</td></cfcase>
                                <cfcase value="b_ucretsiz_izin"><td style="text-align:right;mso-number-format:'0\.00';" nowrap title="<cf_get_lang dictionary_id ='53736.Ücretsiz İzin Gün Toplamı'>">#d_t_izin#</td></cfcase>
                                <cfcase value="b_uzaktan_calisma_gun"><td style="text-align:right;mso-number-format:'0\.00';" nowrap title="<cf_get_lang dictionary_id='63061.Uzaktan Çalışma Gün'>">#d_t_uzaktan_calisma#</td></cfcase>
                                <cfcase value="b_toplam_gun"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='53734.Toplam Çalışma Günü'>">#d_t_toplam_days#</td></cfcase>
                                <cfcase value="b_toplam_calisma_gunu"><td style="text-align:right;mso-number-format:'0\.00';">#d_t_days#</td></cfcase>
                                <cfcase value="b_ssk_gunu"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53816.Toplam SGK Günü'>">#d_t_sgk_normal_gun#</td></cfcase>
                                <cfcase value="b_hi_saat">
                                    <td style="text-align:right;mso-number-format:'0\.00';" <cfif ListLen(t_hi_saat, ".") gt 1></cfif>><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_hi_saat)#"></td>
                                    <td style="text-align:right;mso-number-format:'0\.00';" <cfif ListLen(t_ht_saat, ".") gt 1></cfif>><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ht_saat)#"></td>
                                    <td style="text-align:right;mso-number-format:'0\.00';"<cfif ListLen(t_gt_saat, ".") gt 1></cfif>><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_gt_saat)#"></td>
                                    <td style="text-align:right;mso-number-format:'0\.00';"<cfif ListLen(t_paid_izin_saat, ".") gt 1></cfif>><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_paid_izin_saat)#"></td>
                                    <td style="text-align:right;mso-number-format:'0\.00';"<cfif ListLen(t_paid_ht_izin_saat, ".") gt 1></cfif>><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_paid_ht_izin_saat)#"></td>
                                    <td style="text-align:right;mso-number-format:'0\.00';"<cfif ListLen(t_izin, ".") gt 1></cfif>><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(dt_izin_saat)#"></td>
                                    <td style="text-align:right;mso-number-format:'0\.00';"<cfif ListLen(t_saat, ".") gt 1></cfif>><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_saat)#"></td>
                                </cfcase>
                                <cfcase value="b_hafta_ici_mesai"><td title="<cf_get_lang dictionary_id ='53733.Toplam Hafta İçi Mesai Saati'>"<cfif ListLen(d_t_h_ici, ".") gt 1></cfif>><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_h_ici)#"></td></cfcase>
                                <cfcase value="b_hafta_ici_mesai_ucret"><td title="<cf_get_lang dictionary_id ='53733.Toplam Hafta İçi Mesai Saati'>"<cfif ListLen(d_t_ext_salary_0, ".") gt 1></cfif>><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ext_salary_0)#"></td></cfcase>
                                <cfcase value="b_hafta_sonu_mesai"><td title="<cf_get_lang dictionary_id ='53732.Toplam Hafta Sonu Mesai Saati'>"<cfif ListLen(d_t_h_sonu, ".") gt 1></cfif>><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_h_sonu)#"></td></cfcase>
                                <cfcase value="b_hafta_sonu_mesai_ucret"><td title="<cf_get_lang dictionary_id ='53732.Toplam Hafta Sonu Mesai Saati'>"<cfif ListLen(d_t_ext_salary_1, ".") gt 1></cfif>><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ext_salary_1)#"></td></cfcase>
                                <cfcase value="b_resmi_tatil_mesai"><td title="<cf_get_lang dictionary_id ='53731.Toplam Resmi Tatil Mesai Saati'>"<cfif ListLen(d_t_resmi, ".") gt 1></cfif>><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_resmi)#"></td></cfcase>
                                <cfcase value="b_resmi_tatil_mesai_ucret"><td title="<cf_get_lang dictionary_id ='53731.Toplam Resmi Tatil Mesai Saati'>"<cfif ListLen(d_t_ext_salary_2, ".") gt 1></cfif>><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ext_salary_2)#"></td></cfcase>
                                <cfcase value="b_gece_mesai_saat"><td title="<cf_get_lang dictionary_id ='53731.Toplam Resmi Tatil Mesai Saati'>"<cfif ListLen(t_gece_mesai_saat, ".") gt 1></cfif>><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_gece_mesai_saat)#"></td></cfcase>
                                <cfcase value="b_gece_mesai_ucret"><td title="<cf_get_lang dictionary_id ='53731.Toplam Resmi Tatil Mesai Saati'>"<cfif ListLen(d_t_ext_salary_5, ".") gt 1></cfif>><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ext_salary_5)#"></td></cfcase>
                                <cfcase value="b_aylik_mesaisiz"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59383.Aylık Mesaisiz Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_aylik - d_t_aylik_fazla,2)#"></td></cfcase>
                                <cfcase value="b_fazla_mesai"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59384.Fazla Mesai Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_aylik_fazla,2)#"></td></cfcase>
                                <cfcase value="b_fazla_mesai_net"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59385.Fazla Mesai Net Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_aylik_fazla_mesai_net,2)#"></td></cfcase>
                                <cfcase value="b_gunluk_ucret"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59386.Günlük Ücret Toplamı'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_gunluk_ucret,2)#"></td></cfcase>
                                <cfcase value="b_aylik_ucret"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59387.Aylık Ücret Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_aylik,2)#"></td></cfcase>
                                <cfcase value="b_aylik_brut_ucret"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59388.Aylık Brüt Ücret Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_aylik_brut_ucret,2)#"></td></cfcase>
                                <cfcase value="b_ek_odenek"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='39967.Ek Ödenek Toplamı'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_total_pay_ssk_tax+d_t_total_pay_ssk+d_t_total_pay_tax+d_t_total_pay,2)#"></td></cfcase>
                                <cfcase value="b_toplam_kazanc"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53244.Toplam Kazanç'> <cf_get_lang dictionary_id='58659.Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_toplam_kazanc,2)#"></td></cfcase>
                                <cfcase value="b_sgk_matrahi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59383.Aylık Mesaisiz Toplamları'> <cf_get_lang dictionary_id='59389.SSK Matrah Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ssk_matrahi+d_t_ssdf_matrah,2)#"></td></cfcase>
                                <cfcase value="b_sgk_isci_hissesi">
                                    <td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59390.SSK İşçi Hissesi Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ssk_primi_isci,2)#"></td>
                                    <td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59391.SGDP İşçi Hissesi Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ssdf_isci_hissesi,2)#"></td>
                                </cfcase>
                                <cfcase value="b_isci_primi_indirimli">
                                    <td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id = '54271.İndirimli'> <cf_get_lang no='773.SGK İşçi Primi'>>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_isci_primi_indirimli,2)#"></td>
                                </cfcase>
                                <cfcase value="b_issizlik_isci_hissesi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59392.İşsizlik Sigorta İşveren Prim Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_issizlik_isci_hissesi,2)#"></td> </cfcase>
                                <cfcase value="b_issizlik_isci_hissesi_indirimli"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59392.İşsizlik Sigorta İşveren Prim Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_issizlik_isci_primi_indirimli,2)#"></td> </cfcase>
                                <cfcase value="b_gelir_vergisi_indirimi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53248.Gelir Vergisi İndirim'> <cf_get_lang dictionary_id='58659.Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_vergi_indirimi+d_t_sakatlik_indirimi,2)#"></td></cfcase>
                                <cfcase value="b_gelir_vergisi_matrahi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='40452.Gelir Vergisi'> <cf_get_lang dictionary_id ='59517.Matrah Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_gelir_vergisi_matrahi,2)#"></td></cfcase>
                                <cfcase value="b_gelir_vergisi_hesaplanan">
                                    <td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59518.Gelir Vergisi Hesaplanan Toplamları'>">
                                        <cfif attributes.sal_year lte 2021>
                                            <cfset d_t_gelir_vergisi_hesaplanan = d_t_vergi_iadesi + d_t_gelir_vergisi + d_t_kanun>
                                            <cfif is_5746_control eq 0>
                                            <cfset d_t_gelir_vergisi_hesaplanan = d_t_gelir_vergisi_hesaplanan + d_t_gelir_vergisi_indirimi_5746>
                                            </cfif>
                                            <cfif is_4691_control eq 0>
                                            <cfset d_t_gelir_vergisi_hesaplanan = gelir_vergisi_hesaplanan_ + d_t_gelir_vergisi_indirimi_4691>
                                            </cfif>
                                        </cfif>
                                        
                                        <!----<cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_asgari_gecim + d_t_gelir_vergisi + d_t_kanun + d_t_gelir_vergisi_indirimi_5746_+d_t_gelir_vergisi_indirimi_4691_+d_t_gelir_vergisi_indirimi_687+d_t_gelir_vergisi_indirimi_7103,2)#">--->
                                        <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_gelir_vergisi_hesaplanan,2)#">
                                    </td>
                                </cfcase>
                                <cfcase value="b_asgari_gecim_indirimi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59519.Asgari Geçim İndirim Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_asgari_gecim,2)#"></td></cfcase>
                                <cfcase value="b_gelir_vergisi_indirimi_5746"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53248.Gelir Vergisi İndirimi'> <cf_get_lang dictionary_id='58659.Toplamı'> 5746"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_gelir_vergisi_indirimi_5746,2)#"></td></cfcase>
                                <cfcase value="b_gelir_vergisi_indirimi_4691"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53248.Gelir Vergisi İndirimi'> <cf_get_lang dictionary_id='58659.Toplamı'> 4691"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_gelir_vergisi_indirimi_4691,2)#"></td></cfcase>
                                <cfcase value="b_gelir_vergisi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='40452.Gelir Vergisi'> <cf_get_lang dictionary_id='58659.Toplamı'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_gelir_vergisi,2)#"></td></cfcase>

                                <cfcase value="b_daily_minimum_wage_base_cumulate"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='64700.Asgari Ücrete Göre Gelir Vergi Matrahı'> "><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_daily_minimum_wage_base_cumulate)#"></td></cfcase>
                                <cfcase value="b_daily_minimum_income_tax"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='64702.Asgari Ücret Gelir Vergisi'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_daily_minimum_income_tax)#"></td></cfcase>
                                <cfcase value="b_income_tax_temp"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='64746.Asgari Ücret Faydalanılan'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_income_tax_temp)#"></td></cfcase>
                                <cfcase value="b_daily_minimum_wage"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='64703.Asgari Ücret Damga Vergisi Matrahı'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_daily_minimum_wage)#"></td></cfcase>
                                <cfcase value="b_daily_minimum_wage_stamp_tax"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='64704.Asgari Ücret Damga Vergisi'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_daily_minimum_wage_stamp_tax)#"></td></cfcase>
                                <cfcase value="b_stamp_tax_temp"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='64769.Asgari Ücret Faydalanılan Damga Vergisi'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_stamp_tax_temp)#"></td></cfcase>
                                <cfcase value="b_minimum_wage_cumulative"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='64700.Asgari Ücrete Göre Gelir Vergi Matrahı'> "><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_minimum_wage_cumulative)#"></td></cfcase>
                                
                                <cfcase value="b_vergi_indirimi_5615"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='38971.Vergi İndirimi'> <cf_get_lang dictionary_id='58659.Toplamı'> 5615"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_kanun)#"></td></cfcase>
                                <cfcase value="b_kum_gelir_vergisi_matrahi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59393.Küm.Gelir Verg.Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_kum_gelir_vergisi_matrahi,2)#"></td></cfcase>
                                <cfcase value="b_damga_vergisi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='41439.Damga Vergisi Toplamları'> <cf_get_lang dictionary_id='58659.Toplamı'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_damga_vergisi,2)#"></td></cfcase>
                                <cfcase value="b_damga_vergisi_indirimsiz"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='41439.Damga Vergisi Toplamları'> <cf_get_lang dictionary_id='58659.Toplamı'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_damga_vergisi_indirimsiz+damga_vergisi_indirimi_687+damga_vergisi_indirimi_7103,2)#"></td></cfcase>
                                <cfcase value="b_damga_vergisi_matrah"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59363.Damga Vergisi Matrahı'> <cf_get_lang dictionary_id='58659.Toplamı'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_damga_vergisi_matrahi,2)#"></td></cfcase>
                                <cfcase value="b_toplam_yasal_kesinti"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53722.Top. Yasal Kesinti'> <cf_get_lang dictionary_id='58659.Toplamı'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_kesinti,2)#"></td></cfcase>
                                <cfcase value="b_onceki_aydan_devreden_kum_mat"><td style="text-align:right;mso-number-format:'0\.00';"  title="<cf_get_lang dictionary_id='54297.Önceki Aydan Dev. Küm. Matrah'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_onceki_donem_kum_gelir_vergisi_matrahi,2)#"></td></cfcase>
                                <cfcase value="b_sgk_devir_isci_hissesi_fark"><td style="text-align:right;mso-number-format:'0\.00';"  title="<cf_get_lang dictionary_id='54300.SGK Devir Isci Hissesi Fark'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_sgk_isci_hissesi_fark,2)#"></td></cfcase>
                                <cfcase value="b_sgk_devir_issizlik_hissesi_fark"><td style="text-align:right;mso-number-format:'0\.00';"  title="<cf_get_lang dictionary_id='54301.SGK Devir İşsizlik Hissesi Fark'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_sgk_issizlik_hissesi_fark,2)#"></td></cfcase>
                                <cfcase value="b_sgdp_isci_primi_fark"><td style="text-align:right;mso-number-format:'0\.00';"  title="<cf_get_lang dictionary_id='54302.SGDP İşçi Primi Fark'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_sgdp_isci_primi_fark,2)#"></td></cfcase>
                                <cfcase value="b_muhtelif_kesintiler"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53254.Muhtelif Kesintiler'> <cf_get_lang dictionary_id='58659.Toplamı'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ozel_kesinti,2)#"></td></cfcase>
                                <cfcase value="b_net_ucret"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='38999.Net Ücret'> <cf_get_lang dictionary_id='58659.Toplamı'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_net_ucret-d_t_asgari_gecim,2)#"></td></cfcase>
                                <cfcase value="b_toplam_net_odenecek"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53691.Toplam Net Ödenecek'> <cf_get_lang dictionary_id='58659.Toplamı'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_net_ucret,2)#"></td></cfcase>
                                <cfcase value="b_sgk_isveren_primi_hesaplanan">
                                    <td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53699.SGK İşveren Hissesi'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ssk_primi_isveren_hesaplanan,2)#"></td>
                                    <td style="text-align:right;mso-number-format:'0\.00';" title="SGDP İşveren Hesaplanan"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ssdf_isveren_hissesi,2)#"></td>
                                </cfcase>
                                <cfcase value="b_muhasebe_kod_group"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='54117.Muhasebe Kod Grubu'>"></td></cfcase>
                                <cfcase value="b_sgk_5084"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53699.SGK İşveren Hissesi'> 5084"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ssk_primi_isveren_5084,2)#"></td></cfcase>
                                <cfcase value="b_sgk_5763"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53699.SGK İşveren Hissesi'> 5763"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ssk_primi_isveren_gov,2)#"></td></cfcase>
                                <cfcase value="b_sgk_5510"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 5510"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ssk_primi_isveren_5510,2)#"></td></cfcase>
                                <cfcase value="b_sgk_5921"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 5921"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ssk_primi_isveren_5921,2)#"></td></cfcase>
                                <cfcase value="b_sgk_5746"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 5746"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ssk_primi_isveren_5746,2)#"></td></cfcase>
                                <cfcase value="b_sgk_4691"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 4691"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ssk_primi_isveren_4691,2)#"></td></cfcase>
                                <cfcase value="b_sgk_6111"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 6111"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ssk_primi_isveren_6111,2)#"></td></cfcase>
                                <cfcase value="b_sgk_6486"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 6486"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ssk_primi_isveren_6486,2)#"></td></cfcase>
                                <cfcase value="b_sgk_46486"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 46486"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ssk_primi_isveren_46486,2)#"></td></cfcase>
                                <cfcase value="b_sgk_56486"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 56486"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ssk_primi_isveren_56486,2)#"></td></cfcase>
                                <cfcase value="b_sgk_66486"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 66486"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ssk_primi_isveren_66486,2)#"></td></cfcase>
                                <cfcase value="b_sgk_6322"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 6322"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ssk_primi_isveren_6322+d_t_ssk_primi_isci_6322,2)#"></td></cfcase>
                                <cfcase value="b_sgk_14857"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53699.SGK İşveren Hissesi'> 14857"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ssk_primi_isveren_14857,2)#"></td></cfcase>
                                <cfcase value="b_sgk_3294"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53699.SGK İşveren Hissesi'> 3294"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ssk_primi_isveren_3294,2)#"></td></cfcase>
                                <cfcase value="b_sgk_6645"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 6645"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ssk_primi_isveren_6645,2)#"></td></cfcase>
                                <cfcase value="b_sgk_7252"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 7252"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ssk_primi_isveren_7252,2)#"></td></cfcase>
                                <cfcase value="b_issizlik_sgk_7252"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59372.İşsizlik İşveren İndirimi'> 7252"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ssk_primi_isveren_issizlik_7252,2)#"></td></cfcase>
                                <cfcase value="b_sgk_7256"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 7256"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ssk_primi_isveren_7256,2)#"></td></cfcase>
                                <cfcase value="b_issizlik_sgk_7256"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59372.İşsizlik İşveren İndirimi'> 7256"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ssk_primi_isveren_issizlik_7256,2)#"></td></cfcase>

                                <cfcase value="b_sgk_isci_687"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59368.SGK İşçi Primi İndirimi'> 687"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ssk_isci_hissesi_687,2)#"></td></cfcase>
                                <cfcase value="b_issizlik_isci_687"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59369.İssizlik İşçi Primi İndirimi'> 687"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_issizlik_isci_hissesi_687,2)#"></td></cfcase>
                                <cfcase value="b_sgk_isci_7252"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59368.SGK İşçi Primi İndirimi'> 687"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ssk_isci_hissesi_7252,2)#"></td></cfcase>
                                <cfcase value="b_issizlik_isci_7252"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59369.İssizlik İşçi Primi İndirimi'> 687"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_issizlik_isci_hissesi_7252,2)#"></td></cfcase>
                                <cfcase value="b_sgk_isci_7256"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59368.SGK İşçi Primi İndirimi'> 687"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ssk_isci_hissesi_7256,2)#"></td></cfcase>
                                <cfcase value="b_issizlik_isci_7256"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59369.İssizlik İşçi Primi İndirimi'> 687"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_issizlik_isci_hissesi_7256,2)#"></td></cfcase>

                                <cfcase value="b_gelir_verigisi_687"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53248.Gelir Vergisi İndirimi'> 687"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_gelir_vergisi_indirimi_687,2)#"></td></cfcase>
                                <cfcase value="b_damga_vergisi_687"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59370.Damga Vergisi İndirimi'> 687"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_damga_vergisi_indirimi_687,2)#"></td></cfcase>
                                <cfcase value="b_sgk_isveren_687"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59371.SGK İşveren İndirimi'> 687"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ssk_isveren_hissesi_687,2)#"></td></cfcase>
                                <cfcase value="b_issizlik_isveren_687"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59372.İşsizlik İşveren İndirimi'> 687"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_issizlik_isveren_hissesi_687,2)#"></td></cfcase>
                                
                                <cfcase value="b_sgk_isci_7103"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59368.SGK İşçi Primi İndirimi'> 7103"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ssk_isci_hissesi_7103,2)#"></td></cfcase>
                                <cfcase value="b_issizlik_isci_7103"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59369.İssizlik İşçi Primi İndirimi'> 7103"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_issizlik_isci_hissesi_7103,2)#"></td></cfcase>
                                <cfcase value="b_gelir_verigisi_7103"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53248.Gelir Vergisi İndirimi'> 7103"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_gelir_vergisi_indirimi_7103,2)#"></td></cfcase>
                                <cfcase value="b_damga_vergisi_7103"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59370.Damga Vergisi İndirimi'> 7103"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_damga_vergisi_indirimi_7103,2)#"></td></cfcase>
                                <cfcase value="b_sgk_isveren_7103"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59371.SGK İşveren İndirimi'> 7103"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ssk_isveren_hissesi_7103,2)#"></td></cfcase>
                                <cfcase value="b_issizlik_isveren_7103"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59372.İşsizlik İşveren İndirimi'> 7103"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_issizlik_isveren_hissesi_7103,2)#"></td></cfcase>
                                
                                <cfcase value="b_sgk_isveren_hissesi">
                                    <td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53699.SGK İşveren Hissesi'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_sgk_isveren_hissesi,2)#"></td> 
                                    <td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59377.SGDP İşveren Hissesi'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ssdf_isveren_hissesi,2)#"></td> 
                                </cfcase>
                                <cfcase value="b_toplam_sgk_prim">
                                    <td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59373.SGK Primi'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_sgk_isveren_hissesi+d_t_ssk_primi_isci,2)#"></td> 
                                </cfcase>
                                <cfcase value="b_bes_isci_hissesi">
                                    <td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59374.BES Katılım Payı'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_bes_isci_hissesi,2)#"></td> 
                                </cfcase>
                                <cfcase value="b_issizlik_isveren_hissesi"><td style="text-align:right;mso-number-format:'0\.00';" title="İşsizlik Sig. İşv. P. Toplamları"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_issizlik_isveren_hissesi,2)#"></td></cfcase>
                                <cfcase value="b_issizlik_isveren_hissesi_indirimli"><td style="text-align:right;mso-number-format:'0\.00';" title="İşsizlik Sig. İşv. P. Toplamları"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_issizlik_isveren_primi_indirimli,2)#"></td></cfcase>
                                <cfcase value="b_yillik_izin_tutari"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='53735.Yıllık İzin Tutar Toplamı'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(yillik_izin_total,2)#"></td></cfcase>
                                <cfcase value="b_kidem_tazminati"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='52991.Kıdem Tazminatı'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_kidem_amount,2)#"></td></cfcase>
                                <cfcase value="b_ihbar_tazminati"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='52992.İhbar Tazminatı'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_ihbar_amount,2)#"></td></cfcase>
                                <cfcase value="b_toplam_isveren_maliyeti"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='30888.İşveren Maliyeti'> <cf_get_lang dictionary_id='58659.Toplamı'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_toplam_isveren,2)#"></td></cfcase>
                                <cfcase value="b_toplam_isveren_maliyeti_indirimsiz"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59378.Toplam İşveren Maliyeti İndirimsiz'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_toplam_isveren_indirimsiz,2)#"></td></cfcase>
                                <cfcase value="b_ucret_tipi"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_odeme_metodu"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_fonksiyon"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_exp"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_reason"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_ex_in_out_id"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_vergi_istisna_toplam"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53017.Vergi İstisna'> <cf_get_lang dictionary_id='58659.Toplamı'> #Chr(10)#"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_vergi_istisna_total,2)#"></td></cfcase>
                                <cfcase value="b_vergi_istisna_sgk"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59379.Vergi İstisna SSK'> #Chr(10)#"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_vergi_istisna_ssk,2)#"></td></cfcase>
                                <cfcase value="b_vergi_istisna_sgk_net"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59380.Vergi İstisna SSK Net'> #Chr(10)#"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_vergi_istisna_ssk_net,2)#"></td></cfcase>
                                <cfcase value="b_vergi_istisna_vergi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53017.Vergi İstisna'> <cf_get_lang dictionary_id='53332.Vergi'> #Chr(10)#"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_vergi_istisna_vergi,2)#"></td></cfcase>
                                <cfcase value="b_vergi_istisna_vergi_net"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53017.Vergi İstisna'> <cf_get_lang dictionary_id='59381.Vergi Net'> #Chr(10)#"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_vergi_istisna_vergi_net,2)#"></td></cfcase>
                                <cfcase value="b_vergi_istisna_damga"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53017.Vergi İstisna'> <cf_get_lang dictionary_id='54121.Damga'> #Chr(10)#"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_vergi_istisna_damga,2)#"></td></cfcase>
                                <cfcase value="b_vergi_istisna_damga_net"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53017.Vergi İstisna'> <cf_get_lang dictionary_id='59382.Damga Net'>#Chr(10)#"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_vergi_istisna_damga_net,2)#"></td></cfcase>	
                                <cfcase value="b_ek_odenekler">
                                    <cfset count_ = 0>
                                    <cfloop list="#odenek_names#" index="cca">
                                        <cfset count_ = count_ + 1>
                                        <td title="#odenek_names#"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(evaluate("d_t_odenek_#count_#"),2)#"></td>
                                        <cfif x_payment_type eq 1>
                                            <td title="#odenek_names#"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(evaluate("d_t_odenek_net_#count_#"),2)#"></td>
                                        </cfif>
                                    </cfloop>
                                </cfcase>
                                <cfcase value="b_vergi_istisna">
                                    <cfset count_ = 0>
                                    <cfloop list="#vergi_istisna_names#" index="cca">
                                        <cfset count_ = count_ + 1>
                                        <td title="#vergi_istisna_names#"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(evaluate("d_t_vergi_#count_#"),2)#"></td>
                                        <td title="#vergi_istisna_names#"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(evaluate("d_t_vergi_net_#count_#"),2)#"></td>
                                    </cfloop>
                                </cfcase>
                                <cfcase value="b_kesintiler">
                                    <td title="Avans Toplamları"style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_avans,2)#"></td>
                                    <cfset count_ = 0>
                                    <cfloop list="#kesinti_names#" index="cca">
                                        <cfset count_ = count_ + 1>
                                        <td title="#kesinti_names#"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(evaluate("d_t_kesinti_#count_#"),2)#"></td>
                                    </cfloop>
                                </cfcase>
                                <cfcase value="b_masraf_merkezi"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_masraf_merkezi_kodu"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_muhasebe_kodu"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_banka"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_hesap_no"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_iban_no"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_toplam_devreden_sgk_matrahi"><td title="54333.toplam devreden sgk matrahı"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ssk_devir + d_t_ssk_devir_last,2)#"></td></cfcase>
                                <cfcase value="b_2_onceki_aydan_devreden_sgk_matrahi"><td title="<cf_get_lang dictionary_id='54334.İki önceki aydan devreden sgk matrahı'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ssk_devir_last,2)#"></td></cfcase>
                                <cfcase value="b_1_onceki_aydan_devreden_sgk_matrahi"><td title="<cf_get_lang dictionary_id='54335.Bir önceki aydan devreden sgk matrahı'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ssk_devir,2)#"></td></cfcase>
                                <cfcase value="b_buaydan_devreden_sgk_matrahi"><td title="<cf_get_lang dictionary_id='59375.Bu aydan devreden sgk matrahı'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ssk_amount,2)#"></td></cfcase>
                                <cfcase value="b_kesinti_ve_agi_oncesi_net"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='54310.Kesinti ve Agi Öncesi Net'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_agi_oncesi_net)#"></td></cfcase>
                            </cfswitch>
                        </cfloop>
                    </tr>
                    <cfset cols_plus = cols_plus_ilk>
                </cfif>
                <cfif currentrow eq recordcount>
                    <cfset normal_gun = t_work_days + t_offdays_sundays - t_offdays>
                    <cfset haftalik_tatil = t_sundays - t_offdays_sundays>
                    <cfset genel_tatil = t_offdays>
                    <cfset yillik_izin = t_yillik_izin>
                    <cfset cols_plus = cols_plus + 5>
                    <tr height="25" class="total">
                        <cfloop list="#attributes.b_obj_hidden_new#" index="xlr">
                            <cfswitch expression="#xlr#">
                                <cfcase value="b_baslik"><td class="txtbold"><cf_get_lang dictionary_id ='53263.Toplamlar'></td></cfcase>
                                <cfcase value="b_sira_no"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_mon_info"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_year_info"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_sgk_no"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_ad_soyad"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_employee_no"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_tc_kimlik"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_statu"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_sex"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_ilgili_sirket"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_sube"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_departman">
                                    <cfif isdefined('attributes.is_dep_level')>
                                        <cfloop query="#get_dep_lvl#">
                                            <td nowrap>&nbsp;</td>
                                        </cfloop>                                	
                                    </cfif>
                                    <td>&nbsp;</td>
                                </cfcase>
                                <cfcase value="b_pozisyon_sube"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_pozisyon_departman"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_ise_giris"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_isten_cikis"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_gruba_giris"><td style="text-align:right;mso-number-format:'0\.00';">&nbsp;</td></cfcase>
                                <cfcase value="b_kidem_date"><td style="text-align:right;mso-number-format:'0\.00';">&nbsp;</td></cfcase>
                                <cfcase value="b_imza"><td style="text-align:right;mso-number-format:'0\.00';">&nbsp;</td></cfcase>
                                <cfcase value="b_idari_amir"><td style="text-align:right;mso-number-format:'0\.00';">&nbsp;</td></cfcase>
                                <cfcase value="b_fonksiyonel_amir"><td style="text-align:right;mso-number-format:'0\.00';">&nbsp;</td></cfcase>
                                <cfcase value="b_business_code">
                                	<td style="text-align:right;mso-number-format:'0\.00';">&nbsp;</td>
                                	<td style="text-align:right;mso-number-format:'0\.00';">&nbsp;</td>
                                </cfcase>
                                <cfcase value="b_ozel_kod"><td <cfif fusebox.dynamic_hierarchy>colspan="4"<cfelse>colspan="3"</cfif>>&nbsp;</td></cfcase>
                                <cfcase value="b_unvan"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_pozisyon_tipi"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_collar_type"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_grade_step"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_pozisyon"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_org_step"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_duty_type"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_ucret_yontemi"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_calisan_grubu"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_kg"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_ks"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_net_brut"><td style="text-align:right;mso-number-format:'0\.00';">&nbsp;</td></cfcase>
                                <cfcase value="b_maas"><td style="text-align:right;mso-number-format:'0\.00';" title="Ücret"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_maas,2)#"></td></cfcase>
                                <cfcase value="b_ss_gunu"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='53741.SSK Gün Toplamı'>">#normal_gun_total#</td></cfcase>
                                <cfcase value="b_hs_gunu"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='53740.Hafta Sonu Gün Toplamı'>">#haftalik_tatil_total#</td></cfcase>
                                <cfcase value="b_genel_tatil_gunu"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='53739.Genel Tatil Gün Toplamı'>">#genel_tatil_total#</td></cfcase>
                                <cfcase value="b_ucretli_izin"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='53738.Ücretli İzin Gün Toplamı'>">#t_izin_paid#</td></cfcase>
                                <cfcase value="b_ucretli_izin_pazar"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='53737.Ücretli İzin Pazar  Toplamı'>">#t_paid_izinli_sunday_count#</td></cfcase>
                                <cfcase value="b_ucretsiz_izin"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='53736.Ücretsiz İzin Gün Toplamı'>">#t_izin#</td></cfcase>
                                <cfcase value="b_uzaktan_calisma_gun"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='63061.Uzaktan Çalışma Gün'>">#t_uzaktan_calisma#</td></cfcase>
                                <cfcase value="b_toplam_gun"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='53734.Toplam Çalışma Günü'>">#t_toplam_days#</td></cfcase>
                                <cfcase value="b_toplam_calisma_gunu"><td style="text-align:right;mso-number-format:'0\.00';">#t_days#</td></cfcase>
                                <cfcase value="b_ssk_gunu"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='58714.SGK'> Günü">#t_sgk_normal_gun#</td></cfcase>
                                <cfcase value="b_hi_saat">
                                    <td style="text-align:right;mso-number-format:'0\.00';" <cfif ListLen(gt_hi_saat, ".") gt 1></cfif> title="<cf_get_lang dictionary_id='53715.SS Günü'>(<cf_get_lang dictionary_id='57491.Saat'>)"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(gt_hi_saat)#"></td>
                                    <td style="text-align:right;mso-number-format:'0\.00';" <cfif ListLen(gt_ht_saat, ".") gt 1></cfif> title="<cf_get_lang dictionary_id='53716.HS Günü'>(<cf_get_lang dictionary_id='57491.Saat'>)"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(gt_ht_saat)#"></td>
                                    <td style="text-align:right;mso-number-format:'0\.00';"<cfif ListLen(gt_gt_saat, ".") gt 1></cfif> title="<cf_get_lang dictionary_id='53706.Genel Tatil Günü'>(<cf_get_lang dictionary_id='57491.Saat'>)"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(gt_gt_saat)#"></td>
                                    <td style="text-align:right;mso-number-format:'0\.00';"<cfif ListLen(gt_paid_izin_saat, ".") gt 1></cfif> title="<cf_get_lang dictionary_id='53686.Ücretli İzin'>(<cf_get_lang dictionary_id='57491.Saat'>)"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(gt_paid_izin_saat)#"></td>
                                    <td style="text-align:right;mso-number-format:'0\.00';"<cfif ListLen(gt_paid_ht_izin_saat, ".") gt 1></cfif> title="<cf_get_lang dictionary_id='53687.Ücretli İzin Pazar'>(<cf_get_lang dictionary_id='57491.Saat'>)"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(gt_paid_ht_izin_saat)#"></td>
                                    <td style="text-align:right;mso-number-format:'0\.00';"<cfif ListLen(gt_izin_saat, ".") gt 1></cfif> title="<cf_get_lang dictionary_id='43317.Ücretsiz İzin'>(<cf_get_lang dictionary_id='57491.Saat'>)"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(gt_izin_saat)#"></td>
                                    <td style="text-align:right;mso-number-format:'0\.00';"<cfif ListLen(gt_toplam_saat, ".") gt 1></cfif> title="<cf_get_lang dictionary_id='46377.Toplam Saat'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(gt_toplam_saat)#"></td>
                                </cfcase>
                                <cfcase value="b_hafta_ici_mesai"><td title="<cf_get_lang dictionary_id ='53733.Toplam Hafta İçi Mesai Saati'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_h_ici)#"></td></cfcase>
                                <cfcase value="b_hafta_ici_mesai_ucret"><td title="<cf_get_lang dictionary_id ='53733.Toplam Hafta İçi Mesai Saati'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ext_salary_0)#"></td></cfcase>
                                <cfcase value="b_hafta_sonu_mesai"><td title="<cf_get_lang dictionary_id ='53732.Toplam Hafta Sonu Mesai Saati'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_h_sonu)#"></td></cfcase>
                                <cfcase value="b_hafta_sonu_mesai_ucret"><td title="<cf_get_lang dictionary_id ='53732.Toplam Hafta Sonu Mesai Saati'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ext_salary_1)#"></td></cfcase>
                                <cfcase value="b_resmi_tatil_mesai"><td title="<cf_get_lang dictionary_id ='53731.Toplam Resmi Tatil Mesai Saati'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_resmi)#"></td></cfcase>
                                <cfcase value="b_resmi_tatil_mesai_ucret"><td title="<cf_get_lang dictionary_id ='53731.Toplam Resmi Tatil Mesai Saati'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ext_salary_2)#"></td></cfcase>
                                <cfcase value="b_gece_mesai_saat"><td title="<cf_get_lang dictionary_id ='53731.Toplam Resmi Tatil Mesai Saati'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(gt_gece_mesai_saat)#"></td></cfcase>
                                <cfcase value="b_gece_mesai_ucret"><td title="<cf_get_lang dictionary_id ='53731.Toplam Resmi Tatil Mesai Saati'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_ext_salary_5)#"></td></cfcase>
                                <cfcase value="b_aylik_mesaisiz"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='59383.Aylık Mesaisiz Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_aylik - t_aylik_fazla,2)#"></td></cfcase>
                                <cfcase value="b_fazla_mesai"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='59384.Fazla Mesai Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_aylik_fazla,2)#"></td></cfcase>
                                <cfcase value="b_fazla_mesai_net"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='59385.Fazla Mesai Net Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_aylik_fazla_mesai_net,2)#"></td></cfcase>
                                <cfcase value="b_gunluk_ucret"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='59386.Günlük Ücret Toplamı'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_gunluk_ucret,2)#"></td></cfcase>
                                <cfcase value="b_aylik_ucret"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='59387.Aylık Ücret Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_aylik,2)#"></td></cfcase>
                                <cfcase value="b_aylik_brut_ucret"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='59388.Aylık Brüt Ücret Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_aylik_brut_ucret,2)#"></td></cfcase>
                                <cfcase value="b_ek_odenek"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='39967.Ek Ödenek Toplamı'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_total_pay_ssk_tax+t_total_pay_ssk+t_total_pay_tax+t_total_pay,2)#"></td></cfcase>
                                <cfcase value="b_toplam_kazanc"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='53244.Toplam Kazanç'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_toplam_kazanc,2)#"></td></cfcase>
                                <cfcase value="b_sgk_matrahi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='59389.SSK Matrah Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ssk_matrahi+t_ssdf_matrah,2)#"></td></cfcase>
                                <cfcase value="b_sgk_isci_hissesi">
                                    <td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='59390.SSK İşçi Hissesi Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ssk_primi_isci,2)#"></td>
                                    <td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='59391.SGDP İşçi Hissesi Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ssdf_isci_hissesi,2)#"></td>
                                </cfcase>
                                <cfcase value="b_isci_primi_indirimli">
                                    <td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id = '54271.İndirimli'> <cf_get_lang no='773.SGK İşçi Primi'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_isci_primi_indirimli,2)#"></td>
                                </cfcase>
                                <cfcase value="b_issizlik_isci_hissesi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59392.İşsizlik Sigorta İşveren Prim Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_issizlik_isci_hissesi,2)#"></td></cfcase>
                                <cfcase value="b_issizlik_isci_hissesi_indirimli"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59392.İşsizlik Sigorta İşveren Prim Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_issizlik_isci_primi_indirimli,2)#"></td></cfcase>
                                <cfcase value="b_gelir_vergisi_indirimi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53248.Gelir Vergisi İndirimi'> <cf_get_lang dictionary_id='58659.Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_vergi_indirimi+t_sakatlik_indirimi,2)#"></td></cfcase>
                                <cfcase value="b_gelir_vergisi_matrahi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53249.Gelir Vergisi Matrahı'> <cf_get_lang dictionary_id='58659.Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_gelir_vergisi_matrahi,2)#"></td></cfcase>
                                <cfcase value="b_gelir_vergisi_hesaplanan">
                                    <td style="text-align:right;mso-number-format:'0\.00';" title="Gelir Vergisi Hesaplanan Toplamları">
                                        <cfif attributes.sal_year lte 2021>
                                            <cfset d_t_gelir_vergisi_hesaplanan = t_asgari_gecim + t_gelir_vergisi + t_kanun>
                                            <cfif is_5746_control eq 0>
                                            <cfset d_t_gelir_vergisi_hesaplanan = d_t_gelir_vergisi_hesaplanan + t_gelir_vergisi_indirimi_5746_>
                                            </cfif>
                                            <cfif is_4691_control eq 0>
                                            <cfset d_t_gelir_vergisi_hesaplanan = gelir_vergisi_hesaplanan_ + t_gelir_vergisi_indirimi_4691_>
                                            </cfif>
                                        </cfif>
                                        <!--- <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_asgari_gecim + t_gelir_vergisi + t_kanun + t_gelir_vergisi_indirimi_5746_+t_gelir_vergisi_indirimi_4691_+t_gelir_vergisi_indirimi_687+t_gelir_vergisi_indirimi_7103,2)#">--->
                                        <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_t_gelir_vergisi_hesaplanan,2)#">
                                    </td>
                                </cfcase>
                                <cfcase value="b_asgari_gecim_indirimi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59519.Asgari Geçim İndirim Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_asgari_gecim,2)#"></td></cfcase>
                                <cfcase value="b_gelir_vergisi_indirimi_5746"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53248.Gelir Vergisi İndirimi'> <cf_get_lang dictionary_id='58659.Toplamları'> 5746"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_gelir_vergisi_indirimi_5746,2)#"></td></cfcase>
                                <cfcase value="b_gelir_vergisi_indirimi_4691"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53248.Gelir Vergisi İndirimi'> <cf_get_lang dictionary_id='58659.Toplamları'> 4691"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_gelir_vergisi_indirimi_4691,2)#"></td></cfcase>
                                <cfcase value="b_gelir_vergisi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='40452.Gelir Vergisi'> <cf_get_lang dictionary_id='58659.Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_gelir_vergisi,2)#"></td></cfcase>

                                <cfcase value="b_daily_minimum_wage_base_cumulate"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='64700.Asgari Ücrete Göre Gelir Vergi Matrahı'> "><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_daily_minimum_wage_base_cumulate)#"></td></cfcase>
                                <cfcase value="b_daily_minimum_income_tax"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='64702.Asgari Ücret Gelir Vergisi'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_daily_minimum_income_tax)#"></td></cfcase>
                                <cfcase value="b_income_tax_temp"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='64746.Asgari Ücret Faydalanılan'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_income_tax_temp)#"></td></cfcase>
                                <cfcase value="b_daily_minimum_wage"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='64703.Asgari Ücret Damga Vergisi Matrahı'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_daily_minimum_wage)#"></td></cfcase>
                                <cfcase value="b_daily_minimum_wage_stamp_tax"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='64704.Asgari Ücret Damga Vergisi'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_daily_minimum_wage_stamp_tax)#"></td></cfcase>
                                <cfcase value="b_stamp_tax_temp"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='64769.Asgari Ücret Faydalanılan Damga Vergisi'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_stamp_tax_temp)#"></td></cfcase>
                                <cfcase value="b_minimum_wage_cumulative"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='64700.Asgari Ücrete Göre Gelir Vergi Matrahı'> "><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_minimum_wage_cumulative)#"></td></cfcase>
                                    
                                <cfcase value="b_vergi_indirimi_5615"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='38971.Vergi İndirimi'> <cf_get_lang dictionary_id='58659.Toplamları'> 5615"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_kanun)#"></td></cfcase>
                                <cfcase value="b_kum_gelir_vergisi_matrahi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59393.Küm.Gelir Verg.Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_kum_gelir_vergisi_matrahi,2)#"></td></cfcase>
                                <cfcase value="b_damga_vergisi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='41439.Damga Vergisi'> <cf_get_lang dictionary_id='58659.Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_damga_vergisi,2)#"></td></cfcase>
                                <cfcase value="b_damga_vergisi_indirimsiz"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='41439.Damga Vergisi'> <cf_get_lang dictionary_id='58659.Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_damga_vergisi_indirimsiz + damga_vergisi_indirimi_687 + damga_vergisi_indirimi_7103,2)#"></td></cfcase>
                                <cfcase value="b_damga_vergisi_matrah"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59363.Damga Vergisi Matrah'> <cf_get_lang dictionary_id='58659.Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_damga_vergisi_matrahi,2)#"></td></cfcase>
                                <cfcase value="b_toplam_yasal_kesinti"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53722.Toplam Yasal Kesinti'> <cf_get_lang dictionary_id='58659.Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_kesinti,2)#"></td></cfcase>
                                <cfcase value="b_onceki_aydan_devreden_kum_mat"><td style="text-align:right;mso-number-format:'0\.00';"  title="<cf_get_lang dictionary_id='54297.Önceki Aydan Dev. Küm. Matrah'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_onceki_donem_kum_gelir_vergisi_matrahi,2)#"></td></cfcase>
                                <cfcase value="b_sgk_devir_isci_hissesi_fark"><td style="text-align:right;mso-number-format:'0\.00';"  title="<cf_get_lang dictionary_id='54277.SGK Devir Isci Hissesi Fark'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_sgk_isci_hissesi_fark,2)#"></td></cfcase>
                                <cfcase value="b_sgk_devir_issizlik_hissesi_fark"><td style="text-align:right;mso-number-format:'0\.00';"  title="<cf_get_lang dictionary_id='54301.SGK Devir Issizlik Hissesi Fark'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_sgk_issizlik_hissesi_fark,2)#"></td></cfcase>
                                <cfcase value="b_sgdp_isci_primi_fark"><td style="text-align:right;mso-number-format:'0\.00';"  title="<cf_get_lang dictionary_id='54302.SGDP İşçi Primi Fark'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_sgdp_isci_primi_fark,2)#"></td></cfcase>
                                <cfcase value="b_muhtelif_kesintiler"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53254.Muhtelif Kesintiler'> <cf_get_lang dictionary_id='58659.Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ozel_kesinti,2)#"></td></cfcase>
                                <cfcase value="b_net_ucret"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='38999.Net Ücret'> <cf_get_lang dictionary_id='58659.Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_net_ucret-t_asgari_gecim,2)#"></td></cfcase>
                                <cfcase value="b_toplam_net_odenecek"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53691.Top.Net Ödenecek'> <cf_get_lang dictionary_id='58659.Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_net_ucret,2)#"></td></cfcase>
                                <cfcase value="b_sgk_isveren_primi_hesaplanan">
                                    <td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53698.SSK İşv H Hesaplanan'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ssk_primi_isveren_hesaplanan,2)#"></td>
                                    <td style="text-align:right;mso-number-format:'0\.00';" title="SGDP İşveren Hesaplanan"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ssdf_isveren_hissesi,2)#"></td>
                                </cfcase>
                                <cfcase value="b_muhasebe_kod_group"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='54117.Muhasebe Kod Grubu'>"></td></cfcase>
                                <cfcase value="b_sgk_5084"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK İşv H'> 5084"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ssk_primi_isveren_5084,2)#"></td></cfcase>
                                <cfcase value="b_sgk_5763"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK İşv H'> 5763"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ssk_primi_isveren_gov,2)#"></td></cfcase>
                                <cfcase value="b_sgk_5510"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 5510"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ssk_primi_isveren_5510,2)#"></td></cfcase>
                                <cfcase value="b_sgk_5921"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 5921"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ssk_primi_isveren_5921,2)#"></td></cfcase>
                                <cfcase value="b_sgk_5746"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 5746"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ssk_primi_isveren_5746,2)#"></td></cfcase>
                                <cfcase value="b_sgk_4691"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 4691"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ssk_primi_isveren_4691,2)#"></td></cfcase>
                                <cfcase value="b_sgk_6111"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 6111"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ssk_primi_isveren_6111,2)#"></td></cfcase>
                                <cfcase value="b_sgk_6486"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 6486"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ssk_primi_isveren_6486,2)#"></td></cfcase>
                                <cfcase value="b_sgk_46486"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 46486"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ssk_primi_isveren_46486,2)#"></td></cfcase>
                                <cfcase value="b_sgk_56486"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 56486"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ssk_primi_isveren_56486,2)#"></td></cfcase>
                                <cfcase value="b_sgk_66486"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 66486"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ssk_primi_isveren_66486,2)#"></td></cfcase>
                                <cfcase value="b_sgk_6322"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 6322"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ssk_primi_isveren_6322+t_ssk_primi_isci_6322,2)#"></td></cfcase>
                                <cfcase value="b_sgk_14857"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK İşv H'> 14857"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ssk_primi_isveren_14857,2)#"></td></cfcase>
                                <cfcase value="b_sgk_3294"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK İşv H'> 3294"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ssk_primi_isveren_3294,2)#"></td></cfcase>
                                <cfcase value="b_sgk_6645"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 6645"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ssk_primi_isveren_6645,2)#"></td></cfcase>
                                <cfcase value="b_sgk_7252"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 7252"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ssk_primi_isveren_7252,2)#"></td></cfcase>
                                <cfcase value="b_issizlik_sgk_7252"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59372.İşsizlik İşveren İndirimi'> 7252"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ssk_primi_isveren_issizlik_7252,2)#"></td></cfcase>
                                <cfcase value="b_sgk_7256"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK İşveren Primi'> 7256"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ssk_primi_isveren_7256,2)#"></td></cfcase>
                                <cfcase value="b_issizlik_sgk_7256"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59372.İşsizlik İşveren İndirimi'> 7256"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ssk_primi_isveren_issizlik_7256,2)#"></td></cfcase>

                                <cfcase value="b_sgk_isci_687"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59368.SGK İşçi Primi İndirimi'> 687"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ssk_isci_hissesi_687,2)#"></td></cfcase>
                                <cfcase value="b_issizlik_isci_687"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59369.İssizlik İşçi Primi İndirimi'> 687"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_issizlik_isci_hissesi_687,2)#"></td></cfcase>
                                <cfcase value="b_sgk_isci_7252"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59368.SGK İşçi Primi İndirimi'> 7252"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ssk_isci_hissesi_7252,2)#"></td></cfcase>
                                <cfcase value="b_issizlik_isci_7252"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59369.İssizlik İşçi Primi İndirimi'> 7252"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_issizlik_isci_hissesi_7252,2)#"></td></cfcase>
                                <cfcase value="b_sgk_isci_7256"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59368.SGK İşçi Primi İndirimi'> 7256"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ssk_isci_hissesi_7256,2)#"></td></cfcase>
                                <cfcase value="b_issizlik_isci_7256"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59369.İssizlik İşçi Primi İndirimi'> 7256"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_issizlik_isci_hissesi_7256,2)#"></td></cfcase>

                                <cfcase value="b_gelir_verigisi_687"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53248.Gelir Vergisi İndirimi'> 687"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_gelir_vergisi_indirimi_687,2)#"></td></cfcase>
                                <cfcase value="b_damga_vergisi_687"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59370.Damga Vergisi İndirimi'> 687"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_damga_vergisi_indirimi_687,2)#"></td></cfcase>
                                <cfcase value="b_sgk_isveren_687"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59371.SGK İşveren İndirimi'> 687"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ssk_isveren_hissesi_687,2)#"></td></cfcase>
                                <cfcase value="b_issizlik_isveren_687"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59372.İşsizlik İşveren İndirimi'> 687 "><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_issizlik_isveren_hissesi_687,2)#"></td></cfcase>
                                
                                <cfcase value="b_sgk_isci_7103"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59368.SGK İşçi Primi İndirimi'> 7103"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ssk_isci_hissesi_7103,2)#"></td></cfcase>
                                <cfcase value="b_issizlik_isci_7103"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59369.İssizlik İşçi Primi İndirimi'> 7103"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_issizlik_isci_hissesi_7103,2)#"></td></cfcase>
                                <cfcase value="b_gelir_verigisi_7103"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53248.Gelir Vergisi İndirimi'> 7103"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_gelir_vergisi_indirimi_7103,2)#"></td></cfcase>
                                <cfcase value="b_damga_vergisi_7103"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59370.Damga Vergisi İndirimi'> 7103"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_damga_vergisi_indirimi_7103,2)#"></td></cfcase>
                                <cfcase value="b_sgk_isveren_7103"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59371.SGK İşveren İndirimi'> 7103"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ssk_isveren_hissesi_7103,2)#"></td></cfcase>
                                <cfcase value="b_issizlik_isveren_7103"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59372.İşsizlik İşveren İndirimi'> 7103"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_issizlik_isveren_hissesi_7103,2)#"></td></cfcase>
                                
                                <cfcase value="b_sgk_isveren_hissesi">
                                    <td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53699.SSK İşv H'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_sgk_isveren_hissesi,2)#"></td> 
                                    <td style="text-align:right;mso-number-format:'0\.00';" title="SGDP İşveren Hissesi"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ssdf_isveren_hissesi,2)#"></td> 
                                </cfcase>
                                <cfcase value="b_toplam_sgk_prim"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59373.SGK Primi'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_sgk_isveren_hissesi+t_ssk_primi_isci,2)#"></td></cfcase>
                                <cfcase value="b_bes_isci_hissesi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59374.BES Katılım Payı'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_bes_isci_hissesi,2)#"></td></cfcase>
                                <cfcase value="b_issizlik_isveren_hissesi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59392.İşsizlik Sigorta İşveren Prim Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_issizlik_isveren_hissesi,2)#"></td></cfcase>
                                <cfcase value="b_issizlik_isveren_hissesi_indirimli"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59392.İşsizlik Sigorta İşveren Prim Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_issizlik_isveren_primi_indirimli,2)#"></td></cfcase>
                                <cfcase value="b_yillik_izin_tutari"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='53735.Yıllık İzin Tutar Toplamı'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(d_yillik_izin_total,2)#"></td></cfcase>
                                <cfcase value="b_kidem_tazminati"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53699.SSK İşv H'>Kıdem Tazminatı"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_kidem_amount,2)#"></td></cfcase>
                                <cfcase value="b_ihbar_tazminati"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53699.SSK İşv H'>İhbar Tazminatı"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ihbar_amount,2)#"></td></cfcase>
                                <cfcase value="b_toplam_isveren_maliyeti"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='30888.İşveren Maliyeti'> <cf_get_lang dictionary_id='58659.Toplamları'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_toplam_isveren,2)#"></td></cfcase>
                                <cfcase value="b_toplam_isveren_maliyeti_indirimsiz"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59378.Toplam İşveren Maliyeti İndirimsiz'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_toplam_isveren_indirimsiz,2)#"></td></cfcase>
                                <cfcase value="b_ucret_tipi"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_odeme_metodu"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_fonksiyon"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_exp"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_reason"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_ex_in_out_id"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_vergi_istisna_toplam"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53017.Vergi İstisna'> <cf_get_lang dictionary_id='58659.Toplamları'> #Chr(10)#"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_vergi_istisna_total,2)#"></td></cfcase>
                                <cfcase value="b_vergi_istisna_sgk"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59379.Vergi İstisna SSK'> #Chr(10)#"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_vergi_istisna_ssk,2)#"></td></cfcase>
                                <cfcase value="b_vergi_istisna_sgk_net"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59380.Vergi İstisna SSK Net'> #Chr(10)#"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_vergi_istisna_ssk_net,2)#"></td></cfcase>
                                <cfcase value="b_vergi_istisna_vergi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53017.Vergi İstisna'> <cf_get_lang dictionary_id='33304.Vergi'> #Chr(10)#"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_vergi_istisna_vergi,2)#"></td></cfcase>
                                <cfcase value="b_vergi_istisna_vergi_net"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53017.Vergi İstisna'> <cf_get_lang dictionary_id='59381.Vergi Net'> #Chr(10)#"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_vergi_istisna_vergi_net,2)#"></td></cfcase>
                                <cfcase value="b_vergi_istisna_damga"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53017.Vergi İstisna'> <cf_get_lang dictionary_id='54121.Damga'> #Chr(10)#"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_vergi_istisna_damga,2)#"></td></cfcase>
                                <cfcase value="b_vergi_istisna_damga_net"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53017.Vergi İstisna'> <cf_get_lang dictionary_id='59382.Damga'> #Chr(10)#"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_vergi_istisna_damga_net,2)#"></td></cfcase>
                                <cfcase value="b_ek_odenekler">
                                    <cfset count_ = 0>
                                    <cfloop list="#odenek_names#" index="cca">
                                        <cfset count_ = count_ + 1>
                                        <td title="#cca#"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(evaluate("t_odenek_#count_#"),2)#"></td>
                                        <cfif x_payment_type eq 1>
                                                <td title="#cca#"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(evaluate("t_odenek_net_#count_#"),2)#"></td>
                                        </cfif>
                                    </cfloop>
                                </cfcase>
                                <cfcase value="b_vergi_istisna">
                                    <cfset count_ = 0>
                                    <cfloop list="#vergi_istisna_names#" index="cca">
                                        <cfset count_ = count_ + 1>
                                        <td title="#cca#"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(evaluate("t_vergi_#count_#"),2)#"></td>
                                        <td title="#cca#"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(evaluate("t_vergi_net_#count_#"),2)#"></td>
                                    </cfloop>
                                </cfcase>
                                <cfcase value="b_kesintiler">
                                    <td title="Avans Toplamları"style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_avans,2)#"></td>
                                    <cfset count_ = 0>
                                    <cfloop list="#kesinti_names#" index="cca">
                                        <cfset count_ = count_ + 1>
                                        <td title="#cca#"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(evaluate("t_kesinti_#count_#"),2)#"></td>
                                    </cfloop>
                                </cfcase>
                                <cfcase value="b_masraf_merkezi"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_masraf_merkezi_kodu"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_muhasebe_kodu"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_banka"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_hesap_no"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_iban_no"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_toplam_devreden_sgk_matrahi"><td title="<cf_get_lang dictionary_id='54333.toplam devreden sgk matrahı'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ssk_devir + t_ssk_devir_last,2)#"></td></cfcase>
                                <cfcase value="b_2_onceki_aydan_devreden_sgk_matrahi"><td title="<cf_get_lang dictionary_id='54334.İki önceki aydan devreden sgk matrahı'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ssk_devir_last,2)#"></td></cfcase>
                                <cfcase value="b_1_onceki_aydan_devreden_sgk_matrahi"><td title="<cf_get_lang dictionary_id='54335.Bir önceki aydan devreden sgk matrahı'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ssk_devir,2)#"></td></cfcase>
                                <cfcase value="b_buaydan_devreden_sgk_matrahi"><td title="<cf_get_lang dictionary_id='59375.Bu aydan devreden sgk matrahı'>"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_ssk_amount,2)#"></td></cfcase>
                                <cfcase value="b_kesinti_ve_agi_oncesi_net"><td title="<cf_get_lang dictionary_id='54310.Agi Öncesi Net'>" style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_agi_oncesi_net)#"></td></cfcase>
                            </cfswitch>
                        </cfloop>
                    </tr>
                </cfif>
            </cfoutput>
            <cfscript>
                d_t_ssk_matrahi = 0;
                d_t_gunluk_ucret = 0;
                d_t_toplam_kazanc = 0;
                d_t_vergi_indirimi = 0;
                d_t_sakatlik_indirimi = 0;
                d_t_kum_gelir_vergisi_matrahi = 0;
                d_t_gelir_vergisi_matrahi = 0;
                d_t_gelir_vergisi = 0;
                d_t_asgari_gecim = 0;
                d_t_damga_vergisi_matrahi = 0;
                d_t_damga_vergisi = 0;
                d_t_mahsup_g_vergisi = 0;	
                d_t_h_ici = 0;
                d_t_h_sonu = 0;
                d_t_toplam_days = 0;
                d_t_resmi = 0;	
                d_t_kesinti = 0;
                dt_izin_saat = 0;
                d_t_net_ucret = 0;
                d_t_ssk_primi_isci = 0;
                d_t_ssk_primi_isveren_hesaplanan = 0;
                d_t_ssk_primi_isveren = 0;
                d_t_ssk_primi_isveren_gov = 0;
                d_t_ssk_primi_isveren_5510 = 0;
                d_t_ssk_primi_isveren_5084 = 0;
                d_t_ssk_primi_isveren_5921 = 0;
                d_t_ssk_primi_isveren_5746 = 0;
                d_t_ssk_primi_isveren_4691 = 0;
                d_t_ssk_primi_isveren_6111 = 0;
                d_t_ssk_primi_isveren_6486 = 0; 
                d_t_ssk_primi_isveren_46486 = 0;
                d_t_ssk_primi_isveren_56486 = 0;
                d_t_ssk_primi_isveren_66486 = 0;
                d_t_ssk_primi_isveren_6322 = 0;
                d_t_ssk_primi_isveren_14857 = 0;
                d_t_ssk_primi_isveren_3294 = 0;
                d_t_ssk_primi_isveren_6645 = 0;
				
                d_t_toplam_isveren = 0;
                d_t_issizlik_isci_hissesi = 0;
                d_t_issizlik_isveren_hissesi = 0;
                d_t_kidem_isci_payi = 0;
                d_t_kidem_isveren_payi = 0;
                d_t_total_pay_ssk_tax = 0;
                d_t_total_pay_ssk = 0;
                d_t_total_pay_tax = 0;
                d_t_total_pay = 0;
                d_t_ozel_kesinti = 0;
                d_t_ssk_days = 0;
                d_t_days = 0;
                d_sayac = 0;
                d_ssk_count = 0;
                d_t_work_days = 0;
                d_id_list = '';
                d_t_ssdf_ssk_days = 0;
                d_t_izin = 0;
                d_t_uzaktan_calisma = 0;
                d_t_izin_paid = 0;
                d_t_paid_izinli_sunday_count = 0;
                d_t_sundays = 0;
                d_t_offdays = 0;
                d_t_offdays_sundays = 0;
                d_t_yillik_izin = 0;
                d_t_offdays_sundays = 0;
                d_t_ssdf_sundays = 0;
                d_t_ssdf_days = 0;
                d_t_ssdf_izin_days = 0;
                d_t_ssdf_matrah = 0;
                d_t_ssdf_isci_hissesi = 0;
                d_t_ssdf_isveren_hissesi = 0;
                d_t_ssk_primi_isveren = 0;
                d_t_aylik_ucret = 0;
                d_t_aylik = 0;
                d_t_kanun = 0;
                d_agi_oncesi_net = 0;
                d_t_aylik_fazla = 0;
                d_normal_gun_total = 0;
                d_haftalik_tatil_total = 0;
                d_genel_tatil_total = 0;
                d_izin_total = 0;
                d_mahsup_g_vergisi_ = 0;
                d_t_maas = 0;
                d_t_gelir_vergisi_indirimi_5746 = 0;
                d_t_gelir_vergisi_indirimi_4691 = 0;
                d_kidem_amount = 0;
                d_ihbar_amount = 0;
                d_vergi_istisna_total = 0;
                d_vergi_istisna_ssk = 0;
                d_vergi_istisna_ssk_net = 0;
                d_vergi_istisna_vergi = 0;
                d_vergi_istisna_vergi_net = 0;
                d_vergi_istisna_damga = 0;
                d_vergi_istisna_damga_net = 0;
                yillik_izin_total = 0;
                d_t_ssk_devir = 0;
                d_t_ssk_devir_last = 0;
            
                t_hi_saat = 0;				
                t_ht_saat = 0;				
                t_gt_saat = 0;				
                t_paid_izin_saat = 0;		
                t_paid_ht_izin_saat = 0;	
                t_saat = 0;					
                d_t_onceki_aydan_devreden_kum_mat = 0;
            
                d_t_onceki_donem_kum_gelir_vergisi_matrahi = 0;
                d_t_sgk_isci_hissesi_fark = 0;
                d_t_sgk_issizlik_hissesi_fark = 0;
                d_t_sgdp_isci_primi_fark = 0;
            
                t_gece_mesai_saat = 0;
                d_t_sgk_isveren_hissesi = 0;
                d_t_ssdf_isveren_hissesi = 0;
                d_t_gunluk_ucret = 0;
                d_t_toplam_isveren_indirimsiz = 0;
            </cfscript>
            <cfset count_ = 0>
            <cfloop list="#odenek_names#" index="cc">
                <cfset count_ = count_ + 1>
                <cfset 'd_t_odenek_#count_#' = 0>
                <cfset 'd_t_odenek_net_#count_#' = 0>
            </cfloop>
            <cfset count_ = 0>
            <cfloop list="#kesinti_names#" index="cc">
                <cfset count_ = count_ + 1>
                <cfset 'd_t_kesinti_#count_#' = 0>
            </cfloop>
            <cfset d_t_avans = 0>           
        </cfoutput>
    </tbody>	
    </cf_grid_list>
	<cfif attributes.totalrecords gt attributes.maxrows>
        <cfscript>
                wrkUrlStrings('url_str','hierarchy','sal_year_end','sal_mon_end','sal_year','sal_mon','keyword','b_obj_sira_hidden','b_obj_hidden','upper_position_code2','upper_position2','upper_position','upper_position_code','ssk_statute','main_payment_control','EXPENSE_CENTER','position_department','position_branch_id','department','branch_id','comp_id','is_hepsi','sort_type','print_row_count','puantaj_type','is_dep_level');
        </cfscript>
        <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="ehesap.list_dynamic_bordro#url_str#">
    </cfif>
