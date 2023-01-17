<cfsetting showdebugoutput="no">
<cfparam name="attributes.module_id_control" default="3,48">
<cfinclude template="report_authority_control.cfm">

<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.emp_no" default="">
<cfparam name="attributes.emp_name" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.sal_year" default="#year(now())#">
<cfparam name="attributes.sal_mon" default="#month(now())-1#">
<cfparam name="attributes.sal_year_end" default="#year(now())#">
<cfparam name="attributes.sal_mon_end" default="#month(now())#">
<cfparam name="attributes.list_type" default="1">

<cfset cmp_branch = createObject("component","V16.hr.cfc.get_branch_comp")>
<cfset cmp_branch.dsn = dsn>
<cfset get_branches = cmp_branch.get_branch(branch_status:1,comp_id : session.ep.company_id, ehesap_control : 1)>
<cfset cmp_department = createObject("component","V16.hr.cfc.get_departments")>
<cfset cmp_department.dsn = dsn>
<cfset get_department = cmp_department.get_department(branch_id : attributes.branch_id)>

<cfif isdefined('attributes.is_form_submit')>
    <cfset puantaj_gun_ = daysinmonth(CREATEDATE(attributes.sal_year,attributes.SAL_MON,1))>
    <cfset puantaj_gun_2_ = daysinmonth(CREATEDATE(attributes.sal_year_end,attributes.SAL_MON_END,1))>
    <cfscript>
		get_puantaj_ = createObject("component", "V16.hr.ehesap.cfc.get_dynamic_bordro");
		get_puantaj_.dsn = dsn;
		get_puantaj_.dsn_alias = dsn_alias;
		get_data = get_puantaj_.get_dynamic_bordro
		(
			sal_year : attributes.sal_year,
			sal_mon : attributes.sal_mon,
			sal_year_end : attributes.sal_year,
			sal_mon_end : attributes.sal_mon,
			branch_id : attributes.branch_id,
            department :attributes.department_id,
            emp_no : attributes.emp_no,
            emp_name : attributes.emp_name,
            puantaj_type : -1
        );
        get_data2 = get_puantaj_.get_dynamic_bordro
		(
			sal_year : attributes.sal_year_end,
			sal_mon : attributes.sal_mon_end,
			sal_year_end : attributes.sal_year_end,
			sal_mon_end : attributes.sal_mon_end,
			branch_id : attributes.branch_id,
            department :attributes.department_id,
            emp_no : attributes.emp_no,
            emp_name : attributes.emp_name,
            puantaj_type : -1
		);
    </cfscript>
<cfelse>
    <cfset get_data.recordcount = 0>
    <cfset get_data2.recordcount = 0>
</cfif>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default="#get_data.recordcount#">

<cfquery name="get_kesinti" datasource="#dsn#">
    SELECT 
        *
    FROM 
        SETUP_PAYMENT_INTERRUPTION
    WHERE 
        IS_ODENEK = 0 AND
        ISNULL(IS_BES,0) = 0
</cfquery>

<cfquery name="get_odenek" datasource="#dsn#">
    SELECT 
      *
    FROM 
      SETUP_PAYMENT_INTERRUPTION
    WHERE 
      IS_ODENEK = 1 AND
      ISNULL(IS_BES,0) = 0
</cfquery>

<cfquery name="get_vergi_istisna_" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		TAX_EXCEPTION
</cfquery>

<cfscript>
    t_istisna_odenek = 0;
    t_istisna_odenek_2 = 0;
	t_ssk_matrahi = 0;
	t_gunluk_ucret = 0;
	t_toplam_kazanc = 0;
	t_vergi_indirimi = 0;
	t_sakatlik_indirimi = 0;
    t_kum_gelir_vergisi_matrahi = 0;
    t_kum_gelir_vergisi_matrahi_2 = 0;
	t_gelir_vergisi_matrahi = 0;
	t_gelir_vergisi = 0;
	t_asgari_gecim = 0;
	t_damga_vergisi_matrahi = 0;
	t_damga_vergisi = 0;
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
    t_ssk_primi_isci_devirsiz_2 = 0;
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
	t_ssk_primi_isveren_6322 = 0;
	t_ssk_primi_isci_6322 = 0;
    t_ssk_primi_isveren_14857 = 0;
    t_ssk_primi_isveren_6645 = 0;

    //7252
	t_ssk_primi_isveren_7252 = 0;
	t_ssk_primi_isveren_issizlik_7252 = 0;
    t_ssk_isci_hissesi_7252 = 0;
	t_issizlik_isci_hissesi_7252 = 0;
	d_t_ssk_primi_isveren_issizlik_7252 = 0;
    d_t_ssk_primi_isveren_7252 = 0;
	d_t_ssk_isci_hissesi_7252 = 0;
	d_t_issizlik_isci_hissesi_7252 = 0;

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
	t_sgk_normal_gun = 0;
	t_ssk_days = 0;
	t_days = 0;
	sayac = (attributes.page - 1) * attributes.maxrows;
	ssk_count = 0;
	t_work_days = 0;
	id_list = '';
	t_ssdf_ssk_days = 0;
	t_izin = 0;
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
	d_t_ssk_primi_isveren_6322 = 0;
	d_t_ssk_primi_isci_6322 = 0;
    d_t_ssk_primi_isveren_14857 = 0;
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
	t_izin = 0;
    t_saat = 0;
    t_saat_2 = 0;
	t_gece_mesai_saat = 0;
	d_t_onceki_donem_kum_gelir_vergisi_matrahi = 0;
	d_t_sgk_isci_hissesi_fark = 0;
	d_t_sgk_issizlik_hissesi_fark = 0;
	d_t_sgdp_isci_primi_fark = 0;
	t_sgk_isveren_hissesi=0;
	d_t_sgk_isveren_hissesi=0;
	d_t_ssdf_isveren_hissesi=0;
    aylik_brut_ucret = 0;
    aylik_brut_ucret_2 = 0;
	t_aylik_brut_ucret = 0;
	t_bes_isci_hissesi=0;
    maas_=0;
    maas_2_=0;
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
				(EP.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND EP.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">)
				OR
				(
					EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
					EP.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
					(
						EP.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> OR
						(EP.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">)
					)
				)
				OR
				(
					EP.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
					(
						EP.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> OR
						(EP.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">)
					)
				)
				OR
				(
					EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
					EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
					EP.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
					EP.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
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
<cfquery name="get_emp_puantaj_ids_2" datasource="#dsn#">
    SELECT DISTINCT
        EMPLOYEE_PUANTAJ_ID 
    FROM 
        EMPLOYEES_PUANTAJ_ROWS EPR
        INNER JOIN EMPLOYEES_PUANTAJ EP ON EPR.PUANTAJ_ID = EP.PUANTAJ_ID
        INNER JOIN BRANCH B ON EP.SSK_OFFICE = B.SSK_OFFICE AND EP.SSK_OFFICE_NO = B.SSK_NO
    WHERE 
        (
            (EP.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> AND EP.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
            OR
            (
                EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> AND 
                EP.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND
                (
                    EP.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> OR
                    (EP.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
                )
            )
            OR
            (
                EP.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> AND 
                (
                    EP.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> OR
                    (EP.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
                )
            )
            OR
            (
                EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> AND 
                EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> AND
                EP.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND
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
<cfset employee_puantaj_ids_2 = valuelist(get_emp_puantaj_ids_2.employee_puantaj_id)>
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
<cfquery name="get_kesintis_2" datasource="#dsn#">
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
		<cfif listlen(employee_puantaj_ids_2)>EMPLOYEE_PUANTAJ_ID IN (#employee_puantaj_ids_2#)<cfelse>1=0</cfif> AND 
		EXT_TYPE = 1 
	ORDER BY 
		COMMENT_PAY
</cfquery>
<cfquery name="get_kesinti_adlar" dbtype="query">
	SELECT DISTINCT COMMENT_PAY FROM get_kesintis WHERE COMMENT_PAY <> 'Avans' ORDER BY COMMENT_PAY
</cfquery>
<cfquery name="get_kesinti_adlar_2" dbtype="query">
	SELECT DISTINCT COMMENT_PAY FROM get_kesintis_2 WHERE COMMENT_PAY <> 'Avans' ORDER BY COMMENT_PAY
</cfquery>
<cfset kesinti_names = listsort(valuelist(get_kesinti_adlar.comment_pay),"text","ASC")>
<cfset kesinti_names_2 = listsort(valuelist(get_kesinti_adlar_2.comment_pay),"text","ASC")>
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
<cfquery name="get_odeneks_2" datasource="#dsn#">
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
		<cfif listlen(employee_puantaj_ids_2)>EMPLOYEE_PUANTAJ_ID IN (#employee_puantaj_ids_2#)<cfelse>1=0</cfif> AND 
		EXT_TYPE = 0 
	ORDER BY 
		COMMENT_PAY
</cfquery>
<cfquery name="get_odenek_adlar" dbtype="query">
	SELECT DISTINCT COMMENT_PAY FROM get_odeneks
</cfquery>
<cfquery name="get_odenek_adlar_2" dbtype="query">
	SELECT DISTINCT COMMENT_PAY FROM get_odeneks_2
</cfquery>
<cfset odenek_names = listsort(valuelist(get_odenek_adlar.comment_pay),"text","ASC")>
<cfset odenek_names2_ = listsort(valuelist(get_odenek_adlar_2.comment_pay),"text","ASC")>
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
		EMPLOYEE_PUANTAJ_ID
	FROM 
		EMPLOYEES_PUANTAJ_ROWS_EXT
	WHERE 
		<cfif listlen(employee_puantaj_ids)>EMPLOYEE_PUANTAJ_ID IN (#employee_puantaj_ids#)<cfelse>1=0</cfif> AND 
		EXT_TYPE = 2 
	ORDER BY 
		COMMENT_PAY
</cfquery>
<cfquery name="get_vergi_istisna_2" datasource="#dsn#">
	SELECT 
		VERGI_ISTISNA_AMOUNT,
		VERGI_ISTISNA_TOTAL,
		COMMENT_PAY,
		EMPLOYEE_PUANTAJ_ID
	FROM 
		EMPLOYEES_PUANTAJ_ROWS_EXT
	WHERE 
		<cfif listlen(employee_puantaj_ids_2)>EMPLOYEE_PUANTAJ_ID IN (#employee_puantaj_ids_2#)<cfelse>1=0</cfif> AND 
		EXT_TYPE = 2 
	ORDER BY 
		COMMENT_PAY
</cfquery>
<cfquery name="get_vergi_istisna_adlar" dbtype="query">
	SELECT DISTINCT COMMENT_PAY FROM get_vergi_istisna
</cfquery>
<cfquery name="get_vergi_istisna_adlar_2" dbtype="query">
	SELECT DISTINCT COMMENT_PAY FROM get_vergi_istisna_2
</cfquery>
<cfset vergi_istisna_names = valuelist(get_vergi_istisna_adlar.comment_pay)>
<cfset vergi_istisna_names_2 = valuelist(get_vergi_istisna_adlar_2.comment_pay)>
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
<cfquery name="get_pay_methods" datasource="#dsn#">
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

<cfsavecontent variable="head"><cf_get_lang dictionary_id='61204.İcmal Fark Raporu'></cfsavecontent>
<cfform name="search_form" method="post" action="#request.self#?fuseaction=report.diff_summary_sheet">
    <cf_report_list_search title="#head#">
        <cf_report_list_search_area>
            <div class="row">
                <div class="col col-12 col-xs-12">
                    <div class="row formContent">
                        <div class="col col-4 col-xs-12">
                            <div class="form-group" id="item-emp_no">
                                <label class="col col-12"><cf_get_lang dictionary_id="56542.Sicil No"></label>
                                <div class="col col-12">
                                    <input type="text" name="emp_no" id="emp_no" value="<cfif len(attributes.emp_no)><cfoutput>#attributes.emp_no#</cfoutput></cfif>">
                                </div>
                            </div>
                            <div class="form-group" id="item-emp_nane">
                                <label class="col col-12"><cf_get_lang dictionary_id="57570.Ad Soyad"></label>
                                <div class="col col-12">
                                    <input type="text" name="emp_name" id="emp_name" value="<cfif len(attributes.emp_name)><cfoutput>#attributes.emp_name#</cfoutput></cfif>">
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-xs-12">
                            <div class="form-group" id="item-branch">
                                <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                                <div class="col col-12 col-xs-12">
                                    <select name="branch_id" id="branch_id" onChange="showDepartment(this.value)">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfoutput query="get_branches" group="NICK_NAME">
                                            <optgroup label="#NICK_NAME#"></optgroup>
                                            <cfoutput>
                                                <option value="#BRANCH_ID#"<cfif attributes.branch_id eq branch_id>selected</cfif>>#BRANCH_NAME#</option>
                                            </cfoutput>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-department">
                                <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                                <div class="col col-12 col-xs-12" id="department_div">
                                    <select name="DEPARTMENT_ID" id="DEPARTMENT_ID"> 
                                        <option value=""><cf_get_lang dictionary_id='30126.Şube Seçiniz'></option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-xs-12">
                            <div class="form-group" id="item-sal_date">
                                <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57501.Başlangıç'></label>			
                                <div class="col col-6">
                                    <select name="sal_mon" id="sal_mon" onchange="change_mon(this.value);">
                                        <cfloop from="1" to="12" index="i">
                                            <cfoutput>
                                                <option value="#i#" <cfif len(attributes.sal_mon) and attributes.sal_mon eq i>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
                                            </cfoutput>
                                        </cfloop>
                                    </select>	
                                </div>
                                <div class="col col-6">
                                    <select name="sal_year" id="sal_year">
                                        <cfloop from="#year(now())-3#" to="#year(now())+3#" index="i">
                                            <cfoutput>
                                                <option value="#i#" <cfif len(attributes.sal_year) and attributes.sal_year eq i>selected</cfif>>#i#</option>
                                            </cfoutput>
                                        </cfloop>
                                    </select>	
                                </div>
                            </div>
                            <div class="form-group" id="item-sal_end_date">	
                                <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57502.Bitiş'></label>				
                                <div class="col col-6">
                                    <select name="sal_mon_end" id="sal_mon_end">
                                        <cfloop from="1" to="12" index="i">
                                            <cfoutput>
                                                <option value="#i#" <cfif len(attributes.sal_mon_end) and attributes.sal_mon_end eq i>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
                                            </cfoutput>
                                        </cfloop>
                                    </select>
                                </div>
                                <div class="col col-6">
                                    <select name="sal_year_end" id="sal_year_end">
                                        <cfloop from="#year(now())-3#" to="#year(now())+3#" index="i">
                                            <cfoutput>
                                                <option value="#i#" <cfif len(attributes.sal_year_end) and attributes.sal_year_end eq i>selected</cfif>>#i#</option>
                                            </cfoutput>
                                        </cfloop>
                                    </select>	
                                </div>					
                            </div>
                        </div>
                    </div>
                    <div class="row ReportContentBorder">
                        <div class="ReportContentFooter">
                            <label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
                                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" message="#message#" maxlength="3" style="width:25px;">
                            <cfelse>
                                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
                            </cfif>
                            <input type="hidden" name="is_form_submit" id="is_form_submit" value="1">
                            <cf_wrk_report_search_button button_type='1' is_excel='1' search_function="control()">
                        </div>
                    </div>
                </div>
            </div>
        </cf_report_list_search_area>
    </cf_report_list_search>
</cfform>
<cfif attributes.is_excel eq 1>
	<cfset type_ = 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-16">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-16">
<cfelse>
	<cfset type_ = 0>
</cfif>
<cfif isdefined("attributes.is_form_submit")>
    <cf_report_list>
        <cfif attributes.is_excel eq 1>
            <cfset type_ = 1>
            <cfset attributes.startrow = 1>
            <cfset attributes.maxrows = get_data.recordcount>
        <cfelse>
            <cfset type_ = 0>
        </cfif>
        <thead>
            <tr class="txtbold" align="left">
                <th><cf_get_lang dictionary_id="53109.Sıra No"></th>
                <th><cf_get_lang dictionary_id="58650.Puantaj"> <cf_get_lang dictionary_id="58724.Ay"> - <cf_get_lang dictionary_id="58455.Yıl"></th>
                <th><cf_get_lang dictionary_id ='53237.SSK No'></th>
                <th><cf_get_lang dictionary_id ='57570.Adı Soyadı'></th>
                <th><cf_get_lang dictionary_id ='58025.TC Kimlik No'></th>
                <th><cf_get_lang dictionary_id ='58487.Calisan No'></th>
                <th><cf_get_lang dictionary_id ='57894.Statü'></th>
                <th><cf_get_lang dictionary_id ='57764.Cinsiyet'></th>
                <th><cf_get_lang dictionary_id ='53701.İlgili Şirket'></th>
                <th><cf_get_lang dictionary_id ='57453.Şube'></th>
                <cfif isdefined('attributes.is_dep_level')>
                    <cfoutput query="get_dep_lvl">
                        <th><cf_get_lang dictionary_id='57572.Departman'>(#level_no#)</th>
                    </cfoutput>
                </cfif>
                <th><cf_get_lang dictionary_id='57572.Departman'></th>
                <th><cf_get_lang dictionary_id ='53729.Pozisyon Şube'></th>
                <th><cf_get_lang dictionary_id ='53728.Pozisyon Departman'></th>
                <th><cf_get_lang dictionary_id ='53702.İşe Giriş '></th>
                <th><cf_get_lang dictionary_id ='29832.İşten Çıkış'></th>
                <th><cf_get_lang dictionary_id ='53704.Gruba Girişi'></th>
                <th><cf_get_lang dictionary_id ='53641.Kıdem Baz Tarihi'></th>
                <th><cf_get_lang dictionary_id ='57789.Özel Kod'></th>
                <th><cf_get_lang dictionary_id ='57789.Özel Kod'>1</th>
                <th><cf_get_lang dictionary_id ='57789.Özel Kod'>2</th>
                <cfif fusebox.dynamic_hierarchy><th><cf_get_lang dictionary_id='54354.Dinamik Hiyerarşi'></th></cfif>
                <th><cf_get_lang dictionary_id ='57571.Ünvan'></th>
                <th><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th>
                <th><cf_get_lang dictionary_id='54054.Yaka Tipi'></th>
                <th><cf_get_lang dictionary_id="54179.Derece"> - <cf_get_lang dictionary_id="58710.Kademe"></th>
                <th><cf_get_lang dictionary_id='53164.Pozisyon'></th>
                <th><cf_get_lang dictionary_id="58710.Kademe"></th>
                <th><cf_get_lang dictionary_id ='58538.Görev Tipi'></th>
                <th><cf_get_lang dictionary_id ='53714.Ücret Yöntemi'></th>
                <th><cf_get_lang dictionary_id ='56857.Çalışan Grubu'></th>
                <th colspan="3"><cf_get_lang dictionary_id ='53804.KG'></th>
                <th colspan="3">KS</th>
                <th><cf_get_lang dictionary_id="58083.Net"> / <cf_get_lang dictionary_id="53131.Brüt"></th>
                <th colspan="3"><cf_get_lang dictionary_id="53127.Ücret"></th>
                <th colspan="3"><cf_get_lang dictionary_id ='53715.SS Günü'></th>
                <th colspan="3"><cf_get_lang dictionary_id ='53716.HS Günü'></th>
                <th colspan="3"><cf_get_lang dictionary_id ='53706.Genel Tatil Günü'></th>
                <th colspan="3"><cf_get_lang dictionary_id ='53686.Ücretli İzin'></th>
                <th colspan="3"><cf_get_lang dictionary_id ='53687.Ücretli İzin Pazar'></th>
                <th colspan="3"><cf_get_lang dictionary_id ='53688.Ücretsiz İzin'></th>
                <th colspan="3"><cf_get_lang dictionary_id="53745.Toplam Gün"></th>
                <th colspan="3"><cf_get_lang dictionary_id ='53727.Çalışma Günü'></th>
                <th colspan="3"><cf_get_lang dictionary_id='53816.Toplam SGK Günü'></th>
                <th><cf_get_lang dictionary_id="53705.Birinci Amir"></th>
                <th><cf_get_lang dictionary_id="53882.İşten Çıkış Nedeni"></th>
                <th><cf_get_lang dictionary_id="53643.Şirket İçi Gerekçe"></th>
                <th><cf_get_lang dictionary_id="57554.Giriş"> <cf_get_lang dictionary_id="52990.Gerekçe"></th>
                <th><cf_get_lang dictionary_id="53713.İkinci Amir"></th>
                <th><cf_get_lang dictionary_id="55494.Meslek"> <cf_get_lang dictionary_id="32646.Kodu"></th>
                <th><cf_get_lang dictionary_id='53861.Meslek Grubu'></th>
                <th colspan="3"><cf_get_lang dictionary_id ='53715.SS Günü'> (<cf_get_lang dictionary_id="57491.Saat">)</th>
                <th colspan="3"><cf_get_lang dictionary_id ='53716.HS Günü'> (<cf_get_lang dictionary_id="57491.Saat">)</th>
                <th colspan="3"><cf_get_lang dictionary_id ='53706.Genel Tatil Günü'> (<cf_get_lang dictionary_id="57491.Saat">)</th>
                <th colspan="3"><cf_get_lang dictionary_id ='53686.Ücretli İzin'> (<cf_get_lang dictionary_id="57491.Saat">)</th>
                <th colspan="3"><cf_get_lang dictionary_id ='53687.Ücretli İzin Pazar'> (<cf_get_lang dictionary_id="57491.Saat">)</th>
                <th colspan="3"><cf_get_lang dictionary_id ='53688.Ücretsiz İzin'> (<cf_get_lang dictionary_id="57491.Saat">)</th>
                <th colspan="3"><cf_get_lang dictionary_id ="57492.Toplam"> <cf_get_lang dictionary_id="57491.Saat"></th>
                <th colspan="3"><cf_get_lang dictionary_id ='53744.Hafta İçi Mesai'></th>
                <th colspan="3"><cf_get_lang dictionary_id ='53743.Hafta Sonu Mesai'></th>
                <th colspan="3"><cf_get_lang dictionary_id ='53742.Resmi Tatil Mesai'></th>
                <th colspan="3"><cf_get_lang dictionary_id='54329.Gece Mesaisi'></th>
                <th colspan="3"><cf_get_lang dictionary_id ='53717.Aylık Mesaisiz'></th>
                <th colspan="3"><cf_get_lang dictionary_id ='53718.Fazla Mesai'></th>
                <th colspan="3"><cf_get_lang dictionary_id ='53718.Fazla Mesai'><cf_get_lang dictionary_id="58083.Net"></th>
                <th colspan="3"><cf_get_lang dictionary_id ='53242.Günlük Ücret'></th>
                <th colspan="3"><cf_get_lang dictionary_id ='53243.Aylık Ücret'></th>
                <th colspan="3"><cf_get_lang dictionary_id="47803.Aylık Brüt Ücret"></th>
                <th colspan="3"><cf_get_lang dictionary_id ='53082.Ek Ödenek'></th>
                <th colspan="3"><cf_get_lang dictionary_id ='53244.Toplam Kazanç'></th>
                <th colspan="3"><cf_get_lang dictionary_id ='53245.SSK Matrahı'></th>
                <th colspan="3"><cf_get_lang dictionary_id ='53246.SSK İşçi H'></th>
                <th colspan="3"><cf_get_lang dictionary_id ='47802.SGDP İşçi Hissesi'></th>
                <th colspan="3"><cf_get_lang dictionary_id="54330.İşsizlik Sigortası İşçi Primi"></th>
                <th colspan="3"><cf_get_lang dictionary_id ='53248.Gelir Vergisi İndirimi'></th>
                <th colspan="3"><cf_get_lang dictionary_id ='53249.Gelir Vergisi Matrahı'></th>
                <th colspan="3"><cf_get_lang dictionary_id ='53689.Gelir Vergisi Hesaplanan'></th>
                <th colspan="3"><cf_get_lang dictionary_id ='53659.Asgari Geçim İndirimi'></th>
                <th colspan="3"><cf_get_lang dictionary_id ='53250.Gelir Vergisi'> <cf_get_lang dictionary_id="54268.İndirimi"> 5746</th>
                <th colspan="3"><cf_get_lang dictionary_id ='53250.Gelir Vergisi'> <cf_get_lang dictionary_id="54268.İndirimi"> 4691</th>
                <th colspan="3"><cf_get_lang dictionary_id ='53250.Gelir Vergisi'></th>
                <th colspan="3"><cf_get_lang dictionary_id ='53690.Vergi İndirimi '> <cfif (attributes.sal_year eq 2007 and attributes.sal_mon gt 6) or attributes.sal_year gte 2008>5615<cfelse>5084</cfif></th>
                <th colspan="3"><cf_get_lang dictionary_id ='53251.Küm Gel Ver Matrah'></th>
                <th colspan="3"><cf_get_lang dictionary_id ='53252.Damga Vergisi'></th>
                <th colspan="3"><cf_get_lang dictionary_id="59363.Damga Vergisi Matrahı"></th>
                <th colspan="3"><cf_get_lang dictionary_id ='53722.Toplam Yasal Kesinti'></th>
                <th colspan="3"><cf_get_lang dictionary_id='54297.Önceki Aydan Dev Küm Matrah'></th>
                <th colspan="3"><cf_get_lang dictionary_id="54300.SGK Devir Isci Hissesi Fark"></th>
                <th colspan="3"><cf_get_lang dictionary_id="54301.SGK Devir Isci Hissesi Fark"></th>
                <th colspan="3"><cf_get_lang dictionary_id="54302.SGDP İşçi Primi Fark"></th>
                <th colspan="3"><cf_get_lang dictionary_id ='53254.Muhtelif Kesintiler'></th>
                <th colspan="3"><cf_get_lang dictionary_id ='53255.Net Ücret'></th>
                <th colspan="3"><cf_get_lang dictionary_id ='53691.Toplam Net Ödenecek'></th>
                <th colspan="3"><cf_get_lang dictionary_id='53698.SGK İşveren Primi Hesaplanan'></th>
                <th colspan="3"><cf_get_lang dictionary_id="59364.SGDP İşveren Primi Hesaplanan"></th>
                <th><cf_get_lang dictionary_id='54117.Muhasebe Kod Grubu'></th>
                <th colspan="3"><cf_get_lang dictionary_id="54331.SGK İşv Primi"> 5084 <cf_get_lang dictionary_id="54268.İndirimi"></th>
                <th colspan="3"><cf_get_lang dictionary_id="54331.SGK İşv Primi"> 5763 <cf_get_lang dictionary_id="54268.İndirimi"></th>
                <th colspan="3"><cf_get_lang dictionary_id="54331.SGK İşv Primi"> 5510 <cf_get_lang dictionary_id="54268.İndirimi"></th>
                <th colspan="3"><cf_get_lang dictionary_id="54331.SGK İşv Primi"> 5921 <cf_get_lang dictionary_id="54268.İndirimi"></th>
                <th colspan="3"><cf_get_lang dictionary_id="54331.SGK İşv Primi"> 5746 <cf_get_lang dictionary_id="54268.İndirimi"></th>
                <th colspan="3"><cf_get_lang dictionary_id="54331.SGK İşv Primi"> 4691 <cf_get_lang dictionary_id="54268.İndirimi"></th>
                <th colspan="3"><cf_get_lang dictionary_id="54331.SGK İşv Primi"> 6111 <cf_get_lang dictionary_id="54268.İndirimi"></th>
                <th colspan="3"><cf_get_lang dictionary_id="54331.SGK İşv Primi"> 6486 <cf_get_lang dictionary_id="54268.İndirimi"></th>
                <th colspan="3"><cf_get_lang dictionary_id="54331.SGK İşv Primi"> 6322 <cf_get_lang dictionary_id="54268.İndirimi"></th>
                <th colspan="3"><cf_get_lang dictionary_id="54331.SGK İşv Primi"> 14857 <cf_get_lang dictionary_id="54268.İndirimi"></th>
                <th colspan="3"><cf_get_lang dictionary_id="54331.SGK İşv Primi"> 6645 <cf_get_lang dictionary_id="54268.İndirimi"></th>
                <th colspan="3"><cf_get_lang dictionary_id="54331.SGK İşv Primi"> 7252 <cf_get_lang dictionary_id="54268.İndirimi"></th>
                <th colspan="3"><cf_get_lang dictionary_id='59372.İşsizlik İşveren İndirimi'> 7252</th>
                <th colspan="3"><cf_get_lang dictionary_id="59368.SGK İşçi Primi İndirimi"> 687</th>
                <th colspan="3"><cf_get_lang dictionary_id="59369.İssizlik İşçi Primi İndirimi"> 687</th>
                <th colspan="3"><cf_get_lang dictionary_id="59368.SGK İşçi Primi İndirimi"> 7252</th>
                <th colspan="3"><cf_get_lang dictionary_id="59369.İssizlik İşçi Primi İndirimi"> 7252</th>
                <th colspan="3"><cf_get_lang dictionary_id="53248.Gelir Vergisi İndirimi"> 687</th>
                <th colspan="3"><cf_get_lang dictionary_id="59370.Damga Vergisi İndirimi"> 687</th>
                <th colspan="3"><cf_get_lang dictionary_id="59371.SGK İşveren İndirimi"> 687 </th>
                <th colspan="3"><cf_get_lang dictionary_id="59372.İşsizlik İşveren İndirimi"> 687</th>
                <th colspan="3"><cf_get_lang dictionary_id="59368.SGK İşçi Primi İndirimi"> 7103</th>
                <th colspan="3"><cf_get_lang dictionary_id="59369.İssizlik İşçi Primi İndirimi"> 7103</th>
                <th colspan="3"><cf_get_lang dictionary_id="53248.Gelir Vergisi İndirimi"> 7103</th>
                <th colspan="3"><cf_get_lang dictionary_id="59370.Damga Vergisi İndirimi"> 7103</th>
                <th colspan="3"><cf_get_lang dictionary_id="59371.SGK İşveren İndirimi"> 7103</th>
                <th colspan="3"><cf_get_lang dictionary_id="59372.İşsizlik İşveren İndirimi"> 7103</th>
                <th colspan="3"><cf_get_lang dictionary_id='53256.SGK İşveren Primi'></th>
                <th colspan="3"><cf_get_lang dictionary_id="54311.SGDP İşveren Primi"></th>
                <th colspan="3"><cf_get_lang dictionary_id="59373.SGK Primi"></th>
                <th colspan="3"><cf_get_lang dictionary_id="59374.BES Katılım Payı"></th>
                <th colspan="3"><cf_get_lang dictionary_id ='53257.İşsizlik Sigortası İşveren Primi'></th>
                <th colspan="3"><cf_get_lang dictionary_id ='53393.Yıllık İzin Tutarı'></th>
                <th colspan="3"><cf_get_lang dictionary_id="52991.Kıdem Tazminatı"></th>
                <th colspan="3"><cf_get_lang dictionary_id="52992.İhbar Tazminatı"></th>
                <th colspan="3"><cf_get_lang dictionary_id ='53708.Toplam İşveren Maliyeti'></th>
                <th colspan="3"><cf_get_lang dictionary_id ='59378.Toplam İşveren Maliyeti İndirimsiz'></th>
                <th><cf_get_lang dictionary_id ='53238.Ücret Tipi'></th>
                <th><cf_get_lang dictionary_id ='53557.Ödeme Metodu'></th>
                <th><cf_get_lang dictionary_id='58701.Fonksiyon'></th>
                <th colspan="3"><cf_get_lang dictionary_id="53017.Vergi İstisnası"> <cf_get_lang dictionary_id="57492.Toplam"></th>
                <th colspan="3"><cf_get_lang dictionary_id="53017.Vergi İstisnası"> <cf_get_lang dictionary_id="58714.SGK"></th>
                <th colspan="3"><cf_get_lang dictionary_id="53017.Vergi İstisnası"> <cf_get_lang dictionary_id="58714.SGK"> <cf_get_lang dictionary_id="58083.Net"></th>
                <th colspan="3"><cf_get_lang dictionary_id="53017.Vergi İstisnası"> <cf_get_lang dictionary_id="53332.Vergi"> </th>
                <th colspan="3"><cf_get_lang dictionary_id="53017.Vergi İstisnası"> <cf_get_lang dictionary_id="53332.Vergi"> <cf_get_lang dictionary_id="58083.Net"></th>
                <th colspan="3"><cf_get_lang dictionary_id="53017.Vergi İstisnası"> <cf_get_lang dictionary_id="54121.Damga"></th>
                <th colspan="3"><cf_get_lang dictionary_id="53017.Vergi İstisnası"> <cf_get_lang dictionary_id="54121.Damga"> <cf_get_lang dictionary_id="58083.Net"></th>

                <cfoutput query="get_odenek">
                    <th colspan="3">#COMMENT_PAY#</th>
                </cfoutput>

                <th colspan="3"><cf_get_lang dictionary_id="58204.Avans"></th>
                
                <cfoutput query="get_kesinti">
                    <th colspan="3">#COMMENT_PAY#</th>
                </cfoutput>

                <cfoutput query="get_vergi_istisna_">
                    <th colspan="3">#tax_exception#</th>
                </cfoutput>

                <th><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th>
                <th><cf_get_lang dictionary_id ='53747.Masraf Merkezi Kodu'></th>
                <th><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></th>
                <th><cf_get_lang dictionary_id="57521.Banka"> <cf_get_lang dictionary_id="57897.Adı"></th>
                <th><cf_get_lang dictionary_id="58178.Hesap No"></th>
                <th><cf_get_lang dictionary_id="54332.IBAN No"></th>
                <th colspan="3"><cf_get_lang dictionary_id="54333.Toplam Devreden SGK Matrahı"></th>
                <th colspan="3"><cf_get_lang dictionary_id="54334.İki Önceki Aydan Devreden SGK Matrahı"></th>
                <th colspan="3"><cf_get_lang dictionary_id="54335.Bir Önceki Aydan Devreden SGK Matrahı"></th>
                <th colspan="3"><cf_get_lang dictionary_id="59375.Bu Aydan Devreden SGK Matrahı"></th>
                <th colspan="3"><cf_get_lang dictionary_id="54310.Kesinti ve AGİ Öncesi Net"></th>
            </tr>
            <cfif get_data.recordcount>
                <tr class="txtbold" align="left">
                    <td nowrap></td>
                    <td nowrap></td>
                    <td nowrap></td>
                    <td nowrap></td>
                    <td nowrap></td>
                    <td nowrap></td>
                    <td nowrap></td>
                    <td nowrap></td>
                    <td nowrap></td>
                    <td nowrap></td>
                    <cfif isdefined('attributes.is_dep_level')>
                        <cfoutput query="get_dep_lvl">
                            <td nowrap></td>
                        </cfoutput>
                    </cfif>
                    <td nowrap></td>
                    <td nowrap></td>
                    <td nowrap></td>
                    <td nowrap></td>
                    <td nowrap></td>
                    <td nowrap></td>
                    <td nowrap></td>
                    <td nowrap></td>
                    <td nowrap></td>
                    <td nowrap></td>
                    <cfif fusebox.dynamic_hierarchy><td nowrap></td></cfif>
                    <td nowrap></td>
                    <td nowrap></td>
                    <td nowrap></td>
                    <td nowrap></td>
                    <td nowrap></td>
                    <td nowrap></td>
                    <td nowrap></td>
                    <td nowrap></td>
                    <td nowrap></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap></td>
                    <td nowrap></td>
                    <td nowrap></td>
                    <td nowrap></td>
                    <td nowrap></td>
                    <td nowrap></td>
                    <td nowrap></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>

                    <cfoutput query="get_odenek">
                        <td nowrap>#attributes.sal_mon#-#attributes.sal_year#</td>
                        <td nowrap>#attributes.sal_mon_end#-#attributes.sal_year_end#</td>
                        <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    </cfoutput>

                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>

                    <cfoutput query="get_kesinti">
                        <td nowrap>#attributes.sal_mon#-#attributes.sal_year#</td>
                        <td nowrap>#attributes.sal_mon_end#-#attributes.sal_year_end#</td>
                        <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    </cfoutput>

                    <cfoutput query="get_vergi_istisna_">
                        <td nowrap>#attributes.sal_mon#-#attributes.sal_year#</td>
                        <td nowrap>#attributes.sal_mon_end#-#attributes.sal_year_end#</td>
                        <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    </cfoutput>

                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                    <td nowrap><cfoutput>#attributes.sal_mon#-#attributes.sal_year#</cfoutput></td>
                    <td nowrap><cfoutput>#attributes.sal_mon_end#-#attributes.sal_year_end#</cfoutput></td>
                    <td nowrap><cf_get_lang dictionary_id="58583.Fark"></td>
                </tr>
            </cfif>
        </thead>
        <tbody>
            <cfif get_data.recordcount>
                <cfoutput query="get_data" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">            
                    <cfoutput>
                        <cfquery name="get_puantaj_rows_end" dbtype="query">
                            SELECT * FROM get_data2 WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#EMPLOYEE_ID#">
                        </cfquery>
                        <cfquery name="get_this_istisna" dbtype="query">
                            SELECT SUM(VERGI_ISTISNA_AMOUNT) AS VERGI_ISTISNA_AMOUNT FROM get_vergi_istisna WHERE EMPLOYEE_PUANTAJ_ID IN (#EMPLOYEE_PUANTAJ_ID#) AND VERGI_ISTISNA_AMOUNT IS NOT NULL
                        </cfquery>
                        <cfif get_puantaj_rows_end.recordCount>
                            <cfquery name="get_this_istisna_2" dbtype="query">
                                SELECT SUM(VERGI_ISTISNA_AMOUNT) AS VERGI_ISTISNA_AMOUNT FROM get_vergi_istisna_2 WHERE EMPLOYEE_PUANTAJ_ID IN (#get_puantaj_rows_end.EMPLOYEE_PUANTAJ_ID#) AND VERGI_ISTISNA_AMOUNT IS NOT NULL
                            </cfquery>
                        <cfelse>
                            <cfset get_this_istisna_2.recordcount = 0>
                        </cfif>
                        <cfscript>
                            if (get_this_istisna.recordcount)
                                t_istisna_odenek = get_this_istisna.vergi_istisna_amount;
                            if (get_this_istisna_2.recordcount)
                                t_istisna_odenek_2 = get_this_istisna_2.vergi_istisna_amount;
                            if(isdefined("attributes.list_type") and attributes.list_type eq 1)
                            {
                                if(Len(evaluate("get_data.M#get_data.row_sal_mon#")))
                                {
                                    maas_ = evaluate("get_data.M#get_data.row_sal_mon#");
                                    t_istisna_odenek = 0;
                                }
                            }
                            else
                            {
                                if(listlen(get_data.row_sal_mon))
                                {
                                    for(ind = 1; ind lte listlen(get_data.row_sal_mon); ind++)
                                    {
                                        maas_ = maas_ + evaluate("get_data.M#listgetat(get_data.row_sal_mon,ind)#");
                                    }
                                    t_istisna_odenek = 0;
                                }
                            }

                            if(get_puantaj_rows_end.recordcount){
                                if(isdefined("attributes.list_type") and attributes.list_type eq 1)
                                {
                                    if(Len(evaluate("get_puantaj_rows_end.M#get_puantaj_rows_end.row_sal_mon#")))
                                    {
                                        maas_2_ = evaluate("get_puantaj_rows_end.M#get_puantaj_rows_end.row_sal_mon#");
                                        t_istisna_odenek_2 = 0;
                                    }
                                }
                                else
                                {
                                    if(listlen(get_puantaj_rows_end.row_sal_mon))
                                    {
                                        for(ind = 1; ind lte listlen(get_puantaj_rows_end.row_sal_mon); ind++)
                                        {
                                            maas_2_ = maas_2_ + evaluate("get_puantaj_rows_end.M#listgetat(get_puantaj_rows_end.row_sal_mon,ind)#");
                                        }
                                        t_istisna_odenek_2 = 0;
                                    }
                                }
                            }
                            
                            t_saat_2 = 0;
                            onceki_donem_kum_gelir_vergisi_matrahi_2 = 0;
                            t_kum_gelir_vergisi_matrahi_2 = 0;
                            toplam_isveren_indirimsiz_2 = 0;
                            toplam_indirim_687_2 = 0;
                            toplam_indirim_7103_2 = 0;
                            toplam_isveren_2 = 0;
                            haftalik_tatil_2 = 0;
                            normal_gun_2 = 0;
                            normal_izinli_2 = 0;
                            genel_tatil_2 = 0;
                            yillik_izin_2 = 0;
                            ucretim_2 = 0;
                            aylik_brut_ucret_2 = 0;
                            isveren_hesaplanan_2 = 0;
                            ssk_isveren_hissesi_5510_2_ = 0;

                            sgk_isci_hissesi_fark = 0;
                            sgk_isci_hissesi_fark_2 = 0;
                            sgk_issizlik_hissesi_fark = 0;
                            sgk_issizlik_hissesi_fark_2 = 0;
                            sgdp_isci_primi_fark = 0;
                            sgdp_isci_primi_fark_2 = 0;
                            _issizlik_isci_hissesi_devirsiz = 0;
                            _issizlik_isci_hissesi_devirsiz_2 = 0;
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
                            if(get_puantaj_rows_end.recordcount)
                                t_saat_2 = get_puantaj_rows_end.weekly_hour + get_puantaj_rows_end.weekend_hour + get_puantaj_rows_end.offdays_count_hour + get_puantaj_rows_end.izin_paid_count + get_puantaj_rows_end.paid_izinli_sunday_count_hour - get_puantaj_rows_end.paid_izinli_sunday_count_hour;
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
                            d_t_izin = d_t_izin + izin;
                            gt_izin_saat = gt_izin_saat + izin_count;	
                            dt_izin_saat = dt_izin_saat + izin_count;			
                       
                            onceki_donem_kum_gelir_vergisi_matrahi = KUMULATIF_GELIR_MATRAH - gelir_vergisi_matrah;
                            if(onceki_donem_kum_gelir_vergisi_matrahi lt 0)
                                onceki_donem_kum_gelir_vergisi_matrahi = 0;
                            if(len(CUMULATIVE_TAX_TOTAL) and isnumeric(START_CUMULATIVE_TAX))
                                onceki_donem_kum_gelir_vergisi_matrahi = onceki_donem_kum_gelir_vergisi_matrahi + CUMULATIVE_TAX_TOTAL;
                            if(len(get_puantaj_rows_end.CUMULATIVE_TAX_TOTAL) and isnumeric(get_puantaj_rows_end.START_CUMULATIVE_TAX))
                                onceki_donem_kum_gelir_vergisi_matrahi_2 = get_puantaj_rows_end.KUMULATIF_GELIR_MATRAH - get_puantaj_rows_end.gelir_vergisi_matrah;
                            if(onceki_donem_kum_gelir_vergisi_matrahi_2 lt 0)
                            onceki_donem_kum_gelir_vergisi_matrahi_2 = 0;
                            if(len(get_puantaj_rows_end.CUMULATIVE_TAX_TOTAL) and isnumeric(get_puantaj_rows_end.START_CUMULATIVE_TAX))
                            onceki_donem_kum_gelir_vergisi_matrahi_2 = onceki_donem_kum_gelir_vergisi_matrahi_2 + get_puantaj_rows_end.CUMULATIVE_TAX_TOTAL;
                                
                    
                            //t_toplam_kazanc = t_toplam_kazanc + total_salary+VERGI_ISTISNA_AMOUNT;
                            //t_toplam_kazanc = t_toplam_kazanc + TOTAL_SALARY -VERGI_ISTISNA_SSK;
                            t_toplam_kazanc = t_toplam_kazanc + (total_salary-VERGI_ISTISNA_SSK-VERGI_ISTISNA_VERGI+VERGI_ISTISNA_AMOUNT_);
                            t_vergi_indirimi = t_vergi_indirimi + vergi_indirimi;
                            t_sakatlik_indirimi = t_sakatlik_indirimi + sakatlik_indirimi;
                            t_kum_gelir_vergisi_matrahi =  t_kum_gelir_vergisi_matrahi + KUMULATIF_GELIR_MATRAH ;
                            if(len(CUMULATIVE_TAX_TOTAL) and isnumeric(START_CUMULATIVE_TAX))
                                t_kum_gelir_vergisi_matrahi = t_kum_gelir_vergisi_matrahi + CUMULATIVE_TAX_TOTAL;

                            if(get_puantaj_rows_end.recordcount)
                                t_kum_gelir_vergisi_matrahi_2 =  t_kum_gelir_vergisi_matrahi_2 + get_puantaj_rows_end.KUMULATIF_GELIR_MATRAH;
                            if(len(get_puantaj_rows_end.CUMULATIVE_TAX_TOTAL) and isnumeric(get_puantaj_rows_end.START_CUMULATIVE_TAX))
                                t_kum_gelir_vergisi_matrahi_2 = t_kum_gelir_vergisi_matrahi_2 + get_puantaj_rows_end.CUMULATIVE_TAX_TOTAL;

                            t_onceki_donem_kum_gelir_vergisi_matrahi = t_onceki_donem_kum_gelir_vergisi_matrahi + onceki_donem_kum_gelir_vergisi_matrahi;
                            t_gelir_vergisi_matrahi = t_gelir_vergisi_matrahi + gelir_vergisi_matrah;
                            t_gelir_vergisi = t_gelir_vergisi + gelir_vergisi - gelir_vergisi_indirimi_687-gelir_vergisi_indirimi_7103;
                            t_asgari_gecim = t_asgari_gecim + vergi_iadesi;
                            
                            d_t_toplam_kazanc = d_t_toplam_kazanc + total_salary+VERGI_ISTISNA_AMOUNT;
                            d_t_vergi_indirimi = d_t_vergi_indirimi + vergi_indirimi;
                            d_t_sakatlik_indirimi = d_t_sakatlik_indirimi + sakatlik_indirimi;
                            d_t_kum_gelir_vergisi_matrahi = d_t_kum_gelir_vergisi_matrahi + KUMULATIF_GELIR_MATRAH;
                            d_t_onceki_donem_kum_gelir_vergisi_matrahi = d_t_onceki_donem_kum_gelir_vergisi_matrahi + onceki_donem_kum_gelir_vergisi_matrahi;
                            d_t_gelir_vergisi_matrahi = d_t_gelir_vergisi_matrahi + gelir_vergisi_matrah;
                            d_t_gelir_vergisi = d_t_gelir_vergisi + gelir_vergisi - gelir_vergisi_indirimi_687- gelir_vergisi_indirimi_7103;
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
                            t_gelir_vergisi_indirimi_4691 = t_gelir_vergisi_indirimi_4691 + gelir_vergisi_indirimi_4691;
                            if(is_4691_control eq 0) //arge indiriminin gelir vergisinden düşülmemesi ile ilgili toplam icmal icin eklendi
                            {                
                                t_gelir_vergisi_indirimi_4691_ = t_gelir_vergisi_indirimi_4691_ + gelir_vergisi_indirimi_4691;
                            }
                            t_damga_vergisi_matrahi = t_damga_vergisi_matrahi + damga_vergisi_matrah;
                            t_damga_vergisi = t_damga_vergisi + damga_vergisi - damga_vergisi_indirimi_687- damga_vergisi_indirimi_7103;
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
                            
                            d_t_mahsup_g_vergisi = d_t_mahsup_g_vergisi + mahsup_g_vergisi_;
                            d_t_gelir_vergisi_indirimi_5746 = d_t_gelir_vergisi_indirimi_5746 + gelir_vergisi_indirimi_5746;
                            if(is_5746_control eq 0) //arge indiriminin gelir vergisinden düşülmemesi ile ilgili toplam icmal icin eklendi //SG 20140306
                            {
                                d_t_gelir_vergisi_indirimi_5746_ = d_t_gelir_vergisi_indirimi_5746_ + gelir_vergisi_indirimi_5746;
                            }
                            d_t_gelir_vergisi_indirimi_4691 = d_t_gelir_vergisi_indirimi_4691 + gelir_vergisi_indirimi_4691;
                            if(is_4691_control eq 0) //arge indiriminin gelir vergisinden düşülmemesi ile ilgili toplam icmal icin eklendi
                            {
                                d_t_gelir_vergisi_indirimi_4691_ = d_t_gelir_vergisi_indirimi_4691_ + gelir_vergisi_indirimi_4691;
                            }
                            d_t_damga_vergisi_matrahi = d_t_damga_vergisi_matrahi + damga_vergisi_matrah;             	
                            d_t_damga_vergisi = d_t_damga_vergisi + damga_vergisi - damga_vergisi_indirimi_687- damga_vergisi_indirimi_7103;
                            d_t_kesinti = d_t_kesinti + (ssk_isci_hissesi + ssdf_isci_hissesi + gelir_vergisi + damga_vergisi + issizlik_isci_hissesi);
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

                            ssk_devir_toplam_2 = 0;
                    
                            if(len(trim(get_puantaj_rows_end.ssk_devir)))
                            {
                                ssk_devir_2_ = get_puantaj_rows_end.ssk_devir;
                                ssk_devir_toplam_2 = ssk_devir_toplam_2 + get_puantaj_rows_end.ssk_devir;
                            }
                            else
                               { ssk_devir_2_ = 0;}
                                
                            if(len(trim(get_puantaj_rows_end.ssk_devir_last)))
                            {
                                ssk_devir_last_2_ = get_puantaj_rows_end.ssk_devir_last;
                                ssk_devir_toplam_2 = ssk_devir_toplam_2 + get_puantaj_rows_end.ssk_devir_last;
                            }
                            else
                               { ssk_devir_last_2_ = 0;}
                                
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

                                if(Len(get_puantaj_rows_end.SSK_ISCI_HISSESI_DUSULECEK))
                                    sgdp_isci_primi_fark_2 = get_puantaj_rows_end.SSK_ISCI_HISSESI_DUSULECEK;
                    
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
                                    t_ssk_primi_isci = t_ssk_primi_isci + ssk_isci_hissesi - ssk_isci_hissesi_687;
                    
                                    t_ssk_matrahi = t_ssk_matrahi + SSK_MATRAH;
                    
                                    if(ssk_isci_hissesi gt 0 and ssk_devir_toplam gt 0)
                                        t_ssk_primi_isci_devirsiz = wrk_round((SSK_MATRAH - ssk_devir_toplam) * 14 / 100);
                                    else
                                        t_ssk_primi_isci_devirsiz = ssk_isci_hissesi;

                                    if(get_puantaj_rows_end.ssk_isci_hissesi gt 0 and ssk_devir_toplam_2 gt 0)
                                        t_ssk_primi_isci_devirsiz_2 = wrk_round((get_puantaj_rows_end.SSK_MATRAH - ssk_devir_toplam_2) * 14 / 100);
                                    else
                                        t_ssk_primi_isci_devirsiz_2 = get_puantaj_rows_end.ssk_isci_hissesi;
                    
                                    if(issizlik_isci_hissesi gt 0 and ssk_devir_toplam gt 0)
                                        _issizlik_isci_hissesi_devirsiz = (SSK_MATRAH - ssk_devir_toplam) * 1 / 100;
                                    else
                                        _issizlik_isci_hissesi_devirsiz = issizlik_isci_hissesi;

                                    if(get_puantaj_rows_end.issizlik_isci_hissesi gt 0 and ssk_devir_toplam_2 gt 0)
                                        _issizlik_isci_hissesi_devirsiz_2 = (get_puantaj_rows_end.SSK_MATRAH - ssk_devir_toplam_2) * 1 / 100;
                                    else
                                        _issizlik_isci_hissesi_devirsiz_2 = get_puantaj_rows_end.issizlik_isci_hissesi;
                    
                                    sgk_isci_hissesi_fark = ssk_isci_hissesi - t_ssk_primi_isci_devirsiz;
                                    sgk_issizlik_hissesi_fark = issizlik_isci_hissesi - _issizlik_isci_hissesi_devirsiz;

                                    if(get_puantaj_rows_end.recordcount){
                                        sgk_isci_hissesi_fark_2 = get_puantaj_rows_end.ssk_isci_hissesi - t_ssk_primi_isci_devirsiz_2;
                                        sgk_issizlik_hissesi_fark_2 = get_puantaj_rows_end.issizlik_isci_hissesi - _issizlik_isci_hissesi_devirsiz_2;
                                    }

                                    t_sgk_isci_hissesi_fark = t_sgk_isci_hissesi_fark + (ssk_isci_hissesi - t_ssk_primi_isci_devirsiz);
                                    t_sgk_issizlik_hissesi_fark = t_sgk_issizlik_hissesi_fark + (issizlik_isci_hissesi - _issizlik_isci_hissesi_devirsiz);
                    
                                    d_t_sgk_isci_hissesi_fark = d_t_sgk_isci_hissesi_fark + (ssk_isci_hissesi - t_ssk_primi_isci_devirsiz);
                                    d_t_sgk_issizlik_hissesi_fark = d_t_sgk_issizlik_hissesi_fark + (issizlik_isci_hissesi - _issizlik_isci_hissesi_devirsiz);
                                }
                                ssk_isveren_hissesi_5510_ = ssk_isveren_hissesi_5510;
                                if(len(get_puantaj_rows_end.ssk_isveren_hissesi_5510))
                                    ssk_isveren_hissesi_5510_2_ = get_puantaj_rows_end.ssk_isveren_hissesi_5510;
                                
                                isveren_hesaplanan = ssk_isveren_hissesi + ssk_isveren_hissesi_5510 + ssk_isveren_hissesi_5084;
                                if(ssk_isci_hissesi eq 0)t_ssk_primi_isveren_hesaplanan = t_ssk_primi_isveren_hesaplanan + ssdf_isveren_hissesi;else t_ssk_primi_isveren_hesaplanan = t_ssk_primi_isveren_hesaplanan + isveren_hesaplanan;
                                
                                if(get_puantaj_rows_end.recordcount)
                                    isveren_hesaplanan_2 = get_puantaj_rows_end.ssk_isveren_hissesi + get_puantaj_rows_end.ssk_isveren_hissesi_5510 + get_puantaj_rows_end.ssk_isveren_hissesi_5084;

                                t_ssk_primi_isveren_5510 = t_ssk_primi_isveren_5510 + wrk_round(ssk_isveren_hissesi_5510);
                                t_ssk_primi_isveren_5084 = t_ssk_primi_isveren_5084 + ssk_isveren_hissesi_5084;
                                            
                                t_ssk_primi_isveren_5921 = t_ssk_primi_isveren_5921 + ssk_isveren_hissesi_5921;
                                t_ssk_primi_isveren_5746 = t_ssk_primi_isveren_5746 + ssk_isveren_hissesi_5746;
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
                                    t_ssk_primi_isveren_7252 = t_ssk_primi_isveren_7252 + ssk_isveren_hissesi_7252;
                                else
                                    ssk_isveren_hissesi_7252 = 0;
                                if(len(ISSIZLIK_ISVEREN_HISSESI_7252))
                                    t_ssk_primi_isveren_issizlik_7252 = t_ssk_primi_isveren_issizlik_7252 + ISSIZLIK_ISVEREN_HISSESI_7252;
                                else
                                    ISSIZLIK_ISVEREN_HISSESI_7252 = 0;
                                if(len(ssk_isci_hissesi_7252))
                                    t_ssk_isci_hissesi_7252 = t_ssk_isci_hissesi_7252 + ssk_isci_hissesi_7252;
                                if(len(issizlik_isci_hissesi_7252))
                                    t_issizlik_isci_hissesi_7252 = t_issizlik_isci_hissesi_7252 + issizlik_isci_hissesi_7252;
                                if(len(ssk_isveren_hissesi_7252))
                                    d_t_ssk_primi_isveren_7252 = d_t_ssk_primi_isveren_7252 + ssk_isveren_hissesi_7252;
                                if(len(ISSIZLIK_ISVEREN_HISSESI_7252))
                                    d_t_ssk_primi_isveren_issizlik_7252 = d_t_ssk_primi_isveren_issizlik_7252 + ISSIZLIK_ISVEREN_HISSESI_7252;
                                if(len(ssk_isci_hissesi_7252))
                                    d_t_ssk_isci_hissesi_7252 = d_t_ssk_isci_hissesi_7252 + ssk_isci_hissesi_7252;
                                if(len(issizlik_isci_hissesi_7252))
                                    d_t_issizlik_isci_hissesi_7252 = d_t_issizlik_isci_hissesi_7252 + issizlik_isci_hissesi_7252;
                                    
                                if(len(ssk_isveren_hissesi_6486))
                                    t_ssk_primi_isveren_6486 = t_ssk_primi_isveren_6486 + ssk_isveren_hissesi_6486;
                                else
                                    ssk_isveren_hissesi_6486 = 0;
                                
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
                                
                                t_ssk_primi_isveren_gov = t_ssk_primi_isveren_gov + ssk_isveren_hissesi_gov;
                                
                                t_ssk_isveren_hissesi_687 = t_ssk_isveren_hissesi_687 + ssk_isveren_hissesi_687;
                                t_ssk_isci_hissesi_687 = t_ssk_isci_hissesi_687 + ssk_isci_hissesi_687;
                                t_issizlik_isci_hissesi_687 = t_issizlik_isci_hissesi_687 + issizlik_isci_hissesi_687;
                                t_issizlik_isveren_hissesi_687 = t_issizlik_isveren_hissesi_687 + issizlik_isveren_hissesi_687;
                                t_gelir_vergisi_indirimi_687 = t_gelir_vergisi_indirimi_687 + gelir_vergisi_indirimi_687;
                                t_damga_vergisi_indirimi_687 = t_damga_vergisi_indirimi_687 + damga_vergisi_indirimi_687;
                                
                                t_ssk_isveren_hissesi_7103 = t_ssk_isveren_hissesi_7103 + ssk_isveren_hissesi_7103;
                                t_ssk_isci_hissesi_7103 = t_ssk_isci_hissesi_7103 + ssk_isci_hissesi_7103;
                                t_issizlik_isci_hissesi_7103 = t_issizlik_isci_hissesi_7103 + issizlik_isci_hissesi_7103;
                                t_issizlik_isveren_hissesi_7103 = t_issizlik_isveren_hissesi_7103 + issizlik_isveren_hissesi_7103;
                                t_gelir_vergisi_indirimi_7103 = t_gelir_vergisi_indirimi_7103 + gelir_vergisi_indirimi_7103;
                                t_damga_vergisi_indirimi_7103 = t_damga_vergisi_indirimi_7103 + damga_vergisi_indirimi_7103;
                                
                                
                                t_issizlik_isci_hissesi = t_issizlik_isci_hissesi + issizlik_isci_hissesi - issizlik_isci_hissesi_687;
                                t_issizlik_isveren_hissesi = t_issizlik_isveren_hissesi + issizlik_isveren_hissesi - issizlik_isveren_hissesi_687;
                                
                                d_t_ssk_days = d_t_ssk_days + total_days;
                                d_t_work_days = d_t_work_days + total_days - sunday_count;
                                d_t_ssk_matrahi = d_t_ssk_matrahi + SSK_MATRAH;
                                d_t_ssk_primi_isci = d_t_ssk_primi_isci + ssk_isci_hissesi;
                                
                                if(ssk_isci_hissesi eq 0)d_t_ssk_primi_isveren_hesaplanan = d_t_ssk_primi_isveren_hesaplanan + ssdf_isveren_hissesi;else d_t_ssk_primi_isveren_hesaplanan = d_t_ssk_primi_isveren_hesaplanan + isveren_hesaplanan;
                                
                                d_t_ssk_primi_isveren_5510 = d_t_ssk_primi_isveren_5510 + wrk_round(ssk_isveren_hissesi_5510);
                                d_t_ssk_primi_isveren_5084 = d_t_ssk_primi_isveren_5084 + ssk_isveren_hissesi_5084;
                                            
                                d_t_ssk_primi_isveren_5921 = d_t_ssk_primi_isveren_5921 + ssk_isveren_hissesi_5921;
                                d_t_ssk_primi_isveren_5746 = d_t_ssk_primi_isveren_5746 + ssk_isveren_hissesi_5746;
                                d_t_ssk_primi_isveren_4691 = d_t_ssk_primi_isveren_4691 + ssk_isveren_hissesi_4691;
                                
                                if(len(ssk_isveren_hissesi_6111))
                                    d_t_ssk_primi_isveren_6111 = d_t_ssk_primi_isveren_6111 + ssk_isveren_hissesi_6111;
                                
                                if(len(ssk_isveren_hissesi_6645))
                                    d_t_ssk_primi_isveren_6645 = d_t_ssk_primi_isveren_6645 + ssk_isveren_hissesi_6645;
        
                                if(len(ssk_isveren_hissesi_6486))
                                    d_t_ssk_primi_isveren_6486 = d_t_ssk_primi_isveren_6486 + ssk_isveren_hissesi_6486;
                                
                                if(len(ssk_isveren_hissesi_6322))
                                    d_t_ssk_primi_isveren_6322 = d_t_ssk_primi_isveren_6322 + ssk_isveren_hissesi_6322;
                                if(len(ssk_isci_hissesi_6322))
                                    d_t_ssk_primi_isci_6322 = d_t_ssk_primi_isci_6322 + ssk_isci_hissesi_6322;
                                    
                                if(len(ssk_isveren_hissesi_14857))	
                                    d_t_ssk_primi_isveren_14857 = d_t_ssk_primi_isveren_14857 + ssk_isveren_hissesi_14857;
                                else
                                    d_t_ssk_primi_isveren_14857 = 0;
                                    
                                d_t_ssk_primi_isveren_gov = d_t_ssk_primi_isveren_gov + ssk_isveren_hissesi_gov;
                    
                    
                                d_t_ssk_isveren_hissesi_687 = d_t_ssk_isveren_hissesi_687 + ssk_isveren_hissesi_687;
                                d_t_ssk_isci_hissesi_687 = d_t_ssk_isci_hissesi_687 + ssk_isci_hissesi_687;
                                d_t_issizlik_isci_hissesi_687 = d_t_issizlik_isci_hissesi_687 + issizlik_isci_hissesi_687;
                                d_t_issizlik_isveren_hissesi_687 = d_t_issizlik_isveren_hissesi_687 + issizlik_isveren_hissesi_687;
                                d_t_gelir_vergisi_indirimi_687 = d_t_gelir_vergisi_indirimi_687 + gelir_vergisi_indirimi_687;
                                d_t_damga_vergisi_indirimi_687 = d_t_damga_vergisi_indirimi_687 + damga_vergisi_indirimi_687;
                                
                                d_t_ssk_isveren_hissesi_7103 = d_t_ssk_isveren_hissesi_7103 + ssk_isveren_hissesi_7103;
                                d_t_ssk_isci_hissesi_7103 = d_t_ssk_isci_hissesi_7103 + ssk_isci_hissesi_7103;
                                d_t_issizlik_isci_hissesi_7103 = d_t_issizlik_isci_hissesi_7103 + issizlik_isci_hissesi_7103;
                                d_t_issizlik_isveren_hissesi_7103 = d_t_issizlik_isveren_hissesi_7103 + issizlik_isveren_hissesi_7103;
                                d_t_gelir_vergisi_indirimi_7103 = d_t_gelir_vergisi_indirimi_7103 + gelir_vergisi_indirimi_7103;
                                d_t_damga_vergisi_indirimi_7103 = d_t_damga_vergisi_indirimi_7103 + damga_vergisi_indirimi_7103;
                                
                                d_t_issizlik_isci_hissesi = d_t_issizlik_isci_hissesi + issizlik_isci_hissesi - issizlik_isci_hissesi_687- issizlik_isci_hissesi_7103;
                                d_t_issizlik_isveren_hissesi = d_t_issizlik_isveren_hissesi + issizlik_isveren_hissesi - issizlik_isveren_hissesi_687;
                    
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
                            toplam_isveren_indirimsiz = total_salary+t_istisna_odenek+issizlik_isveren_hissesi+isveren_hesaplanan+ssdf_isveren_hissesi;
                            if(get_puantaj_rows_end.recordcount)
                                toplam_isveren_indirimsiz_2 = get_puantaj_rows_end.total_salary+t_istisna_odenek_2+get_puantaj_rows_end.issizlik_isveren_hissesi+isveren_hesaplanan_2+get_puantaj_rows_end.ssdf_isveren_hissesi;
                           
                            //687 tesvikten düsülecekler
                            toplam_indirim_687 = ssk_isveren_hissesi_687 + ssk_isci_hissesi_687 + issizlik_isci_hissesi_687 + issizlik_isveren_hissesi_687 + gelir_vergisi_indirimi_687 + damga_vergisi_indirimi_687;
                            if(get_puantaj_rows_end.recordcount)
                                toplam_indirim_687_2 = get_puantaj_rows_end.ssk_isveren_hissesi_687 + get_puantaj_rows_end.ssk_isci_hissesi_687 + get_puantaj_rows_end.issizlik_isci_hissesi_687 + get_puantaj_rows_end.issizlik_isveren_hissesi_687 + get_puantaj_rows_end.gelir_vergisi_indirimi_687 + get_puantaj_rows_end.damga_vergisi_indirimi_687;
                           
                            //7103 tesvikten düsülecekler
                            toplam_indirim_7103 = ssk_isveren_hissesi_7103 + ssk_isci_hissesi_7103 + issizlik_isci_hissesi_7103 + issizlik_isveren_hissesi_7103 + gelir_vergisi_indirimi_7103 + damga_vergisi_indirimi_7103;
                            if(get_puantaj_rows_end.recordcount)
                                toplam_indirim_7103_2 = get_puantaj_rows_end.ssk_isveren_hissesi_7103 + get_puantaj_rows_end.ssk_isci_hissesi_7103 + get_puantaj_rows_end.issizlik_isci_hissesi_7103 + get_puantaj_rows_end.issizlik_isveren_hissesi_7103 + get_puantaj_rows_end.gelir_vergisi_indirimi_7103 + get_puantaj_rows_end.damga_vergisi_indirimi_7103;
                            
                            toplam_isveren = (total_salary+t_istisna_odenek+issizlik_isveren_hissesi+isveren_hesaplanan+ssdf_isveren_hissesi)-(ssk_isveren_hissesi_5510+ssk_isveren_hissesi_5084+ssk_isveren_hissesi_5921+ssk_isveren_hissesi_5746 +ssk_isveren_hissesi_4691+ssk_isveren_hissesi_6111+ssk_isveren_hissesi_6645+ssk_isveren_hissesi_6486+ssk_isveren_hissesi_6322+ssk_isci_hissesi_6322+ssk_isveren_hissesi_gov+toplam_indirim_687+toplam_indirim_7103+ssk_isveren_hissesi_14857);
                            if(get_puantaj_rows_end.recordcount)
                                toplam_isveren_2 = (get_puantaj_rows_end.total_salary+t_istisna_odenek_2+get_puantaj_rows_end.issizlik_isveren_hissesi+isveren_hesaplanan_2+get_puantaj_rows_end.ssdf_isveren_hissesi)-(get_puantaj_rows_end.ssk_isveren_hissesi_5510+get_puantaj_rows_end.ssk_isveren_hissesi_5084+get_puantaj_rows_end.ssk_isveren_hissesi_5921+get_puantaj_rows_end.ssk_isveren_hissesi_5746 +get_puantaj_rows_end.ssk_isveren_hissesi_4691+get_puantaj_rows_end.ssk_isveren_hissesi_6111+get_puantaj_rows_end.ssk_isveren_hissesi_6645+get_puantaj_rows_end.ssk_isveren_hissesi_6486+get_puantaj_rows_end.ssk_isveren_hissesi_6322+get_puantaj_rows_end.ssk_isci_hissesi_6322+get_puantaj_rows_end.ssk_isveren_hissesi_gov+toplam_indirim_687_2+toplam_indirim_7103_2+get_puantaj_rows_end.ssk_isveren_hissesi_14857);
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
                                t_sgk_isveren_hissesi = t_sgk_isveren_hissesi + ssk_isveren_hissesi - ssk_isveren_hissesi_gov - ssk_isveren_hissesi_5921 - ssk_isveren_hissesi_5746 -ssk_isveren_hissesi_4691- ssk_isveren_hissesi_6111- ssk_isveren_hissesi_6645 - ssk_isveren_hissesi_6486-ssk_isveren_hissesi_6322+ssk_isci_hissesi_6322-ssk_isveren_hissesi_687-ssk_isveren_hissesi_7103-ssk_isveren_hissesi_14857;
                                d_t_sgk_isveren_hissesi = d_t_sgk_isveren_hissesi + ssk_isveren_hissesi - ssk_isveren_hissesi_gov - ssk_isveren_hissesi_5921 - ssk_isveren_hissesi_5746 -ssk_isveren_hissesi_4691- ssk_isveren_hissesi_6111 - ssk_isveren_hissesi_6645 -ssk_isveren_hissesi_6486- ssk_isveren_hissesi_6322-ssk_isveren_hissesi_687-ssk_isveren_hissesi_7103-ssk_isveren_hissesi_14857;
                            }
                            
                            haftalik_tatil = weekend_day;
                            normal_gun = ceiling(weekly_day);
                            normal_izinli = izin_paid - paid_izinli_sunday_count;
                            genel_tatil = OFFDAYS_COUNT;
                            yillik_izin = YILLIK_IZIN_AMOUNT;
                            if(get_puantaj_rows_end.recordcount){
                                haftalik_tatil_2 = get_puantaj_rows_end.weekend_day;
                                normal_gun_2 = ceiling(get_puantaj_rows_end.weekly_day);
                                normal_izinli_2 = get_puantaj_rows_end.izin_paid - get_puantaj_rows_end.paid_izinli_sunday_count;
                                genel_tatil_2 = get_puantaj_rows_end.OFFDAYS_COUNT;
                                yillik_izin_2 = get_puantaj_rows_end.YILLIK_IZIN_AMOUNT;
                            }
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
                            if(get_puantaj_rows_end.recordcount){
                                if (get_puantaj_rows_end.total_salary)
                                {
                                    if (get_puantaj_rows_end.SALARY_TYPE eq 2)
                                        ucretim_2 = get_puantaj_rows_end.SALARY/30;
                                    else if (get_puantaj_rows_end.SALARY_TYPE eq 1)
                                        ucretim_2 = get_puantaj_rows_end.SALARY;
                                    else if (get_puantaj_rows_end.SALARY_TYPE eq 0)
                                        ucretim_2 = get_puantaj_rows_end.SALARY*get_puantaj_rows_end.SSK_WORK_HOURS;
                                }
                                else
                                    ucretim_2 = get_puantaj_rows_end.total_salary;
                            }

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
                            if(get_puantaj_rows_end.recordcount)
                                aylik_brut_ucret_2 = get_puantaj_rows_end.total_amount-get_puantaj_rows_end.ext_salary-get_puantaj_rows_end.YILLIK_IZIN_AMOUNT-get_puantaj_rows_end.KIDEM_AMOUNT-get_puantaj_rows_end.IHBAR_AMOUNT;
                            t_aylik_brut_ucret = t_aylik_brut_ucret+aylik_brut_ucret;
                        </cfscript>
                        <tr height="33">
                            <cfset ssk_count = ssk_count+1>
                            <td nowrap>#sayac#</td>
                            <td nowrap>#ROW_SAL_MON#-#ROW_SAL_YEAR# / #attributes.sal_mon_end#-#attributes.sal_year_end#</td>
                            <td nowrap>#ssk_no[ssk_count]#&nbsp;</td>
                            <td nowrap>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
                            <td nowrap>#tc_identy_no#</td>
                            <td nowrap>#employee_no#</td>
                            <td nowrap><cfif ssk_statute eq 1><cf_get_lang dictionary_id ='53043.Normal'><cfelseif ssk_statute eq 2><cf_get_lang dictionary_id='58541.Emekli'><cfelse><cf_get_lang dictionary_id='58156.Diğer'></cfif></td>
                            <td nowrap><cfif sex eq 0><cf_get_lang dictionary_id ='58958.Kadın'><cfelseif sex eq 1><cf_get_lang dictionary_id ='58959.Erkek'></cfif></td>
                            <td nowrap>#RELATED_COMPANY#</td>
                            <td nowrap>#BRANCH_NAME#</td>
                            <cfif isdefined('attributes.is_dep_level') and listlen(dep_level_list)>
                                <cfset count_dep = 0>
                                <cfloop list="#dep_level_list#" index="mm">
                                    <cfset count_dep = count_dep + 1>
                                    <td nowrap>
                                        <cfif len(evaluate('DEPARTMAN#count_dep#'))>#evaluate('DEPARTMAN#count_dep#')#<cfelse>-</cfif>
                                    </td>
                                </cfloop>
                            </cfif>
                            <td nowrap>#DEPARTMENT_HEAD#</td>
                            <td nowrap><cfif listlen(branch_list) and len(position_branch_id)>#get_branchs.branch_name[listfind(branch_list,position_branch_id,',')]#<cfelse>&nbsp;</cfif></td>
                            <td nowrap><cfif listlen(department_list) and len(position_department_id)>#get_departments.department_head[listfind(department_list,position_department_id,',')]#<cfelse>&nbsp;</cfif></td>
                            <td nowrap style="mso-number-format:'Short Date'">#dateformat(START_DATE,dateformat_style)#</td>
                            <td nowrap style="mso-number-format:'Short Date'"><cfif len(FINISH_DATE) and (month(FINISH_DATE) eq ROW_SAL_MON and year(FINISH_DATE) eq ROW_SAL_YEAR)>#dateformat(FINISH_DATE,dateformat_style)#</cfif></td>
                            <td nowrap style="mso-number-format:'Short Date'">#dateformat(group_startdate,dateformat_style)#</td>
                            <td nowrap style="mso-number-format:'Short Date'">#dateformat(KIDEM_DATE,dateformat_style)#</td>
                            <td nowrap>#hierarchy#</td>
                            <td nowrap>#ozel_kod#</td>
                            <td nowrap>#ozel_kod2#</td>
                            <cfif fusebox.dynamic_hierarchy><td nowrap>#dynamic_hierarchy#.#dynamic_hierarchy_add#</td></cfif>
                            <td nowrap><cfif listlen(title_list) and len(title_id)>#get_titles.title[listfind(title_list,title_id,',')]#<cfelse>&nbsp;</cfif></td>
                            <td nowrap><cfif listlen(position_cat_list) and len(position_cat_id)>#get_position_cats.position_cat[listfind(position_cat_list,position_cat_id,',')]#<cfelse>&nbsp;</cfif></td>
                            <td nowrap><cfif collar_type eq 1><cf_get_lang dictionary_id='54055.Mavi Yaka'><cfelseif collar_type eq 2><cf_get_lang dictionary_id='54056.Beyaz Yaka'></cfif></td>
                            <td nowrap style="mso-number-format:\@;"><cfif len(grade) or len(step)>#grade#-#step#<cfelse>&nbsp;</cfif></td>
                            <td nowrap>#position_name#</td>
                            <td nowrap>#organization_step_name#</td>
                            <td nowrap>#duty_type#</td>
                            <td nowrap>
                                <cfif salary_type eq 0>
                                    <cf_get_lang dictionary_id ='53260.Saatlik'> 
                                <cfelseif salary_type eq 1>
                                    <cf_get_lang  dictionary_id='58457.Günlük'>
                                <cfelseif salary_type eq 2>
                                    <cf_get_lang dictionary_id='58932.Aylık'> 
                                </cfif>
                            </td>
                            <td nowrap>
                                <cfif listlen(puantaj_group_ids_list) and len(puantaj_group_ids)>
                                    <cfloop list="#puantaj_group_ids#" index="pgi">
                                        #get_groups.group_name[listfind(puantaj_group_ids_list,pgi,',')]#<cfif listlast(puantaj_group_ids) neq pgi>, </cfif>
                                    </cfloop>
                                <cfelse>&nbsp;</cfif>
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">#KISMI_ISTIHDAM_GUN#</td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">#get_puantaj_rows_end.KISMI_ISTIHDAM_GUN#</td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(KISMI_ISTIHDAM_GUN) and len(get_puantaj_rows_end.KISMI_ISTIHDAM_GUN)>#Abs(KISMI_ISTIHDAM_GUN-get_puantaj_rows_end.KISMI_ISTIHDAM_GUN)#</cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">#KISMI_ISTIHDAM_SAAT#</td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">#get_puantaj_rows_end.KISMI_ISTIHDAM_SAAT#</td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(KISMI_ISTIHDAM_SAAT) and len(get_puantaj_rows_end.KISMI_ISTIHDAM_SAAT)>#Abs(KISMI_ISTIHDAM_SAAT-get_puantaj_rows_end.KISMI_ISTIHDAM_SAAT)#</cfif></td>
                            <td nowrap><cfif GROSS_NET eq 0><cf_get_lang dictionary_id="53131.Brüt"><cfelse><cf_get_lang dictionary_id="58083.Net"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif isdefined("attributes.list_type") and attributes.list_type eq 2>#tlformat(maas,2)#<cfelse><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(maas_,2)#"></cfif></td>  
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif isdefined("attributes.list_type") and attributes.list_type eq 2>#tlformat(get_puantaj_rows_end.maas,2)#<cfelse><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(maas_2_,2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif isdefined("attributes.list_type") and attributes.list_type eq 2>#tlformat(Abs(maas-get_puantaj_rows_end.maas),2)#<cfelse><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(maas_-maas_2_),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">#normal_gun#</td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">#normal_gun_2#</td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">#Abs(normal_gun-normal_gun_2)#</td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">#haftalik_tatil_2#</td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">#haftalik_tatil_2#</td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">#Abs(haftalik_tatil-haftalik_tatil_2)#</td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">#genel_tatil#</td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">#genel_tatil_2#</td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">#Abs(genel_tatil-genel_tatil_2)#</td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">#normal_izinli#</td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">#normal_izinli_2#</td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">#Abs(normal_izinli-normal_izinli_2)#</td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">#paid_izinli_sunday_count#</td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">#get_puantaj_rows_end.paid_izinli_sunday_count#</td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(paid_izinli_sunday_count) and len(get_puantaj_rows_end.paid_izinli_sunday_count)>#Abs(paid_izinli_sunday_count-get_puantaj_rows_end.paid_izinli_sunday_count)#</cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">#izin#</td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">#get_puantaj_rows_end.izin#</td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(izin) and len(get_puantaj_rows_end.izin)>#Abs(izin-get_puantaj_rows_end.izin)#</cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">#total_days#</td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">#get_puantaj_rows_end.total_days#</td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(total_days) and len(get_puantaj_rows_end.total_days)>#Abs(total_days-get_puantaj_rows_end.total_days)#</cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cfif total_days lt puantaj_gun_>
                                    #total_days#
                                    <cfset total_days_gecici = total_days>
                                <cfelse>
                                    #puantaj_gun_#
                                    <cfset total_days_gecici = puantaj_gun_>
                                </cfif>
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cfif get_puantaj_rows_end.total_days lt puantaj_gun_2_>
                                    #get_puantaj_rows_end.total_days#
                                    <cfset total_days_gecici_2 = get_puantaj_rows_end.total_days>
                                <cfelse>
                                    #puantaj_gun_2_#
                                    <cfset total_days_gecici_2 = puantaj_gun_2_>
                                </cfif>
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(total_days_gecici) and len(total_days_gecici_2)>#Abs(total_days_gecici-total_days_gecici_2)#</cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">#ssk_days#</td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">#get_puantaj_rows_end.ssk_days#</td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(ssk_days) and len(get_puantaj_rows_end.ssk_days)>#Abs(ssk_days-get_puantaj_rows_end.ssk_days)#</cfif></td>
                            <td nowrap>#upper_position_employee#</td>
                            <td nowrap><cfif len(finish_date) and (month(finish_date) eq row_sal_mon and year(finish_date) eq row_sal_year)>#get_explanation_name(explanation_id)#</cfif></td>
                            <td nowrap><cfif len(finish_date) and (month(finish_date) eq row_sal_mon and year(finish_date) eq row_sal_year)>#reason#</cfif></td>
                            <td nowrap>#EX_IN#</td>
                            <td nowrap>#upper_position_employee2#</td>
                            <td nowrap><cfif len(BUSINESS_CODE_NAME)>#BUSINESS_CODE#</cfif></td>
                            <td nowrap><cfif len(BUSINESS_CODE_NAME)>#BUSINESS_CODE_NAME#</cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(weekly_hour)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.weekly_hour)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(weekly_hour) and len(get_puantaj_rows_end.weekly_hour)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(weekly_hour-get_puantaj_rows_end.weekly_hour))#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(weekend_hour)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.weekend_hour)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(weekend_hour) and len(get_puantaj_rows_end.weekend_hour)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(weekend_hour-get_puantaj_rows_end.weekend_hour))#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(offdays_count_hour)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.offdays_count_hour)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(offdays_count_hour) and len(get_puantaj_rows_end.offdays_count_hour)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(offdays_count_hour-get_puantaj_rows_end.offdays_count_hour))#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(izin_paid_count-paid_izinli_sunday_count_hour)#">
                                <cfset izin_paid_gecici = izin_paid_count-paid_izinli_sunday_count_hour>
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cfset izin_paid_gecici_2 = 0>
                                <cfif get_puantaj_rows_end.recordcount>
                                    <cfset izin_paid_gecici_2 = get_puantaj_rows_end.izin_paid_count-get_puantaj_rows_end.paid_izinli_sunday_count_hour>
                                </cfif>
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(izin_paid_gecici_2)#">
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cfif len(izin_paid_gecici) and len(izin_paid_gecici_2)>
                                    <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(izin_paid_gecici-izin_paid_gecici_2))#">
                                </cfif>
                            </td> 
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(paid_izinli_sunday_count_hour)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.paid_izinli_sunday_count_hour)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cfif len(get_puantaj_rows_end.paid_izinli_sunday_count_hour) and len(paid_izinli_sunday_count_hour)>
                                    <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(paid_izinli_sunday_count_hour-get_puantaj_rows_end.paid_izinli_sunday_count_hour))#">
                                </cfif>
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(izin_count)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.izin_count)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cfif len(get_puantaj_rows_end.izin_count) and len(izin_count)>
                                    <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(izin_count-get_puantaj_rows_end.izin_count))#">
                                </cfif>
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_saat)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_saat_2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(t_saat-t_saat_2))#"></td>
                            <td nowrap><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(EXT_TOTAL_HOURS_0)#"></td>
                            <td nowrap><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.EXT_TOTAL_HOURS_0)#"></td>
                            <td nowrap><cfif len(get_puantaj_rows_end.EXT_TOTAL_HOURS_0) and len(EXT_TOTAL_HOURS_0)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(EXT_TOTAL_HOURS_0-get_puantaj_rows_end.EXT_TOTAL_HOURS_0))#"></cfif></td>
                            <td nowrap><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(EXT_TOTAL_HOURS_1)#"></td>
                            <td nowrap><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.EXT_TOTAL_HOURS_1)#"></td>
                            <td nowrap><cfif len(get_puantaj_rows_end.EXT_TOTAL_HOURS_1) and len(EXT_TOTAL_HOURS_1)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(EXT_TOTAL_HOURS_1-get_puantaj_rows_end.EXT_TOTAL_HOURS_1))#"></cfif></td>
                            <td nowrap><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(EXT_TOTAL_HOURS_2)# "></td>
                            <td nowrap><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.EXT_TOTAL_HOURS_2)# "></td>
                            <td nowrap><cfif len(get_puantaj_rows_end.EXT_TOTAL_HOURS_2) and len(EXT_TOTAL_HOURS_2)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(EXT_TOTAL_HOURS_2-get_puantaj_rows_end.EXT_TOTAL_HOURS_2))# "></cfif></td>
                            <td nowrap><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(EXT_TOTAL_HOURS_5)#"></td>
                            <td nowrap><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.EXT_TOTAL_HOURS_5)#"></td>
                            <td nowrap><cfif len(get_puantaj_rows_end.EXT_TOTAL_HOURS_5) and len(EXT_TOTAL_HOURS_5)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(EXT_TOTAL_HOURS_5-get_puantaj_rows_end.EXT_TOTAL_HOURS_5))#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(total_amount - ext_salary,2)#">
                                <cfset total_amount_gecici = total_amount - ext_salary>
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cfset total_amount_gecici_2 = 0>
                                <cfif get_puantaj_rows_end.recordcount>
                                    <cfset total_amount_gecici_2 = get_puantaj_rows_end.total_amount - get_puantaj_rows_end.ext_salary>
                                </cfif>
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(total_amount_gecici_2,2)#">
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(total_amount_gecici-total_amount_gecici_2),2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ext_salary,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.ext_salary,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(get_puantaj_rows_end.ext_salary) and len(ext_salary)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(ext_salary-get_puantaj_rows_end.ext_salary),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ext_salary_net,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.ext_salary_net,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(get_puantaj_rows_end.ext_salary_net) and len(ext_salary_net)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(ext_salary_net-get_puantaj_rows_end.ext_salary_net),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ucretim,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ucretim_2,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(ucretim-ucretim_2),2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(total_amount,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.total_amount,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(get_puantaj_rows_end.total_amount) and len(total_amount)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(total_amount-get_puantaj_rows_end.total_amount),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(aylik_brut_ucret,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(aylik_brut_ucret_2,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(aylik_brut_ucret-aylik_brut_ucret_2),2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(total_pay_ssk_tax+total_pay_ssk+total_pay_tax+total_pay,2)#">
                                <cfset total_pay_ssk_tax_gecici = total_pay_ssk_tax+total_pay_ssk+total_pay_tax+total_pay>
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cfset total_pay_ssk_tax_gecici_2 = 0>
                                <cfif get_puantaj_rows_end.recordcount>
                                    <cfset total_pay_ssk_tax_gecici_2 = get_puantaj_rows_end.total_pay_ssk_tax+get_puantaj_rows_end.total_pay_ssk+get_puantaj_rows_end.total_pay_tax+get_puantaj_rows_end.total_pay>
                                </cfif>
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(total_pay_ssk_tax_gecici_2,2)#">
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(total_pay_ssk_tax_gecici-total_pay_ssk_tax_gecici_2),2)#">
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(TOTAL_SALARY-VERGI_ISTISNA_SSK-VERGI_ISTISNA_VERGI+VERGI_ISTISNA_AMOUNT_,2)#">
                                <cfset vergi_istisna_gecici = TOTAL_SALARY-VERGI_ISTISNA_SSK-VERGI_ISTISNA_VERGI+VERGI_ISTISNA_AMOUNT_>
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cfset vergi_istisna_gecici_2 = 0>
                                <cfif get_puantaj_rows_end.recordcount>
                                    <cfset vergi_istisna_gecici_2 = get_puantaj_rows_end.TOTAL_SALARY-get_puantaj_rows_end.VERGI_ISTISNA_SSK-get_puantaj_rows_end.VERGI_ISTISNA_VERGI+get_puantaj_rows_end.VERGI_ISTISNA_AMOUNT_>
                                </cfif>
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(vergi_istisna_gecici_2,2)#">
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(vergi_istisna_gecici-vergi_istisna_gecici_2),2)#">
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(SSK_MATRAH,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.SSK_MATRAH,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(SSK_MATRAH) and len(get_puantaj_rows_end.SSK_MATRAH)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(SSK_MATRAH-get_puantaj_rows_end.SSK_MATRAH),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isci_hissesi-ssk_isci_hissesi_687,2)#"><cfset ssk_isci_hissesi_gecici = ssk_isci_hissesi-ssk_isci_hissesi_687></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cfset ssk_isci_hissesi_gecici_2 = 0>
                                <cfif get_puantaj_rows_end.recordcount>
                                    <cfset ssk_isci_hissesi_gecici_2 = get_puantaj_rows_end.ssk_isci_hissesi-get_puantaj_rows_end.ssk_isci_hissesi_687>
                                </cfif>
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isci_hissesi_gecici_2,2)#">
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(ssk_isci_hissesi_gecici-ssk_isci_hissesi_gecici_2),2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssdf_isci_hissesi,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.ssdf_isci_hissesi,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cfif len(get_puantaj_rows_end.ssdf_isci_hissesi) and len(ssdf_isci_hissesi)>
                                    <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(ssdf_isci_hissesi-get_puantaj_rows_end.ssdf_isci_hissesi),2)#">
                                </cfif>
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(issizlik_isci_hissesi-issizlik_isci_hissesi_687,2)#"><cfset issizlik_isci_gecici = issizlik_isci_hissesi-issizlik_isci_hissesi_687></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cfset issizlik_isci_gecici_2 = 0>
                                <cfif get_puantaj_rows_end.recordcount>
                                    <cfset issizlik_isci_gecici_2 = get_puantaj_rows_end.issizlik_isci_hissesi-get_puantaj_rows_end.issizlik_isci_hissesi_687>
                                </cfif>
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(issizlik_isci_gecici_2,2)#">
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(issizlik_isci_gecici-issizlik_isci_gecici_2),2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(vergi_indirimi+sakatlik_indirimi,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cfset vergi_indirim_gecici = 0>
                                <cfif get_puantaj_rows_end.recordcount>
                                    <cfset vergi_indirim_gecici = get_puantaj_rows_end.vergi_indirimi+get_puantaj_rows_end.sakatlik_indirimi>
                                </cfif>
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(vergi_indirim_gecici,2)#">
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(vergi_indirimi+sakatlik_indirimi-(vergi_indirim_gecici)),2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(gelir_vergisi_matrah,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.gelir_vergisi_matrah,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><
                                <cfset gelir_vergisi_matrah_gecici = 0>
                                <cfif get_puantaj_rows_end.recordcount>
                                    <cfset gelir_vergisi_matrah_gecici = get_puantaj_rows_end.gelir_vergisi_matrah>
                                </cfif>
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(gelir_vergisi_matrah-gelir_vergisi_matrah_gecici),2)#">
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cfset gelir_vergisi_hesaplanan_ = vergi_iadesi + gelir_vergisi + VERGI_INDIRIMI_5084>
                                <cfif is_5746_control eq 0>
                                    <cfset gelir_vergisi_hesaplanan_ = gelir_vergisi_hesaplanan_ + gelir_vergisi_indirimi_5746>
                                </cfif>
                                <cfif is_4691_control eq 0>
                                    <cfset gelir_vergisi_hesaplanan_ = gelir_vergisi_hesaplanan_ + gelir_vergisi_indirimi_4691>
                                </cfif>
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(gelir_vergisi_hesaplanan_,2)#">
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cfset gelir_vergisi_hesaplanan_2_ = 0>
                                <cfif get_puantaj_rows_end.recordcount>
                                    <cfset gelir_vergisi_hesaplanan_2_ = get_puantaj_rows_end.vergi_iadesi + get_puantaj_rows_end.gelir_vergisi + get_puantaj_rows_end.VERGI_INDIRIMI_5084>
                                    <cfif is_5746_control eq 0>
                                        <cfset gelir_vergisi_hesaplanan_2_ = gelir_vergisi_hesaplanan_2_ + get_puantaj_rows_end.gelir_vergisi_indirimi_5746>
                                    </cfif>
                                    <cfif is_4691_control eq 0>
                                        <cfset gelir_vergisi_hesaplanan_2_ = gelir_vergisi_hesaplanan_2_ + get_puantaj_rows_end.gelir_vergisi_indirimi_4691>
                                    </cfif>
                                </cfif>
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(gelir_vergisi_hesaplanan_2_,2)#">
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(gelir_vergisi_hesaplanan_-gelir_vergisi_hesaplanan_2_),2)#">
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(vergi_iadesi,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.vergi_iadesi,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(vergi_iadesi) and len(get_puantaj_rows_end.vergi_iadesi)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(vergi_iadesi-get_puantaj_rows_end.vergi_iadesi),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(gelir_vergisi_indirimi_5746,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.gelir_vergisi_indirimi_5746,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(get_puantaj_rows_end.gelir_vergisi_indirimi_5746) and len(gelir_vergisi_indirimi_5746)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(gelir_vergisi_indirimi_5746-get_puantaj_rows_end.gelir_vergisi_indirimi_5746),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(gelir_vergisi_indirimi_4691,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.gelir_vergisi_indirimi_4691,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(get_puantaj_rows_end.gelir_vergisi_indirimi_4691) and len(gelir_vergisi_indirimi_4691)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(gelir_vergisi_indirimi_4691-get_puantaj_rows_end.gelir_vergisi_indirimi_4691),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(gelir_vergisi-gelir_vergisi_indirimi_687-gelir_vergisi_indirimi_7103,2)#"><cfset get_vergisi_gecici = gelir_vergisi-gelir_vergisi_indirimi_687-gelir_vergisi_indirimi_7103></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cfset get_vergisi_gecici_2 = 0>
                                <cfif get_puantaj_rows_end.recordcount>
                                    <cfset get_vergisi_gecici_2 = get_puantaj_rows_end.gelir_vergisi-get_puantaj_rows_end.gelir_vergisi_indirimi_687-get_puantaj_rows_end.gelir_vergisi_indirimi_7103>
                                </cfif>
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_vergisi_gecici_2,2)#">
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(get_vergisi_gecici-get_vergisi_gecici_2),2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(VERGI_INDIRIMI_5084,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.VERGI_INDIRIMI_5084,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(VERGI_INDIRIMI_5084) and len(get_puantaj_rows_end.VERGI_INDIRIMI_5084)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(VERGI_INDIRIMI_5084-get_puantaj_rows_end.VERGI_INDIRIMI_5084),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cfif (len(CUMULATIVE_TAX_TOTAL) and isnumeric(START_CUMULATIVE_TAX))>
                                    <cfset cumulative_value = KUMULATIF_GELIR_MATRAH + CUMULATIVE_TAX_TOTAL>
                                <cfelse>
                                    <cfset cumulative_value = KUMULATIF_GELIR_MATRAH >
                                </cfif>
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(cumulative_value,2)#">
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cfset cumulative_value_2 = 0>
                                <cfif get_puantaj_rows_end.recordcount>
                                    <cfif (len(get_puantaj_rows_end.CUMULATIVE_TAX_TOTAL) and isnumeric(get_puantaj_rows_end.START_CUMULATIVE_TAX))>
                                        <cfset cumulative_value_2 = get_puantaj_rows_end.KUMULATIF_GELIR_MATRAH + get_puantaj_rows_end.CUMULATIVE_TAX_TOTAL>
                                    <cfelse>
                                        <cfset cumulative_value_2 = get_puantaj_rows_end.KUMULATIF_GELIR_MATRAH >
                                    </cfif>
                                </cfif>
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(cumulative_value_2,2)#">
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(cumulative_value-cumulative_value_2),2)#">
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(damga_vergisi-damga_vergisi_indirimi_687-damga_vergisi_indirimi_7103,2)#"><cfset damga_vergisi_gecici = damga_vergisi-damga_vergisi_indirimi_687-damga_vergisi_indirimi_7103></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cfset damga_vergisi_gecici_2 = 0>
                                <cfif get_puantaj_rows_end.recordcount>
                                    <cfset damga_vergisi_gecici_2 = get_puantaj_rows_end.damga_vergisi-get_puantaj_rows_end.damga_vergisi_indirimi_687-get_puantaj_rows_end.damga_vergisi_indirimi_7103>
                                </cfif>
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(damga_vergisi_gecici_2,2)#">
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(damga_vergisi_gecici-damga_vergisi_gecici_2),2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(damga_vergisi_matrah,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.damga_vergisi_matrah,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(get_puantaj_rows_end.damga_vergisi_matrah) and len(damga_vergisi_matrah)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(damga_vergisi_matrah-get_puantaj_rows_end.damga_vergisi_matrah),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isci_hissesi + ssdf_isci_hissesi + gelir_vergisi + damga_vergisi + issizlik_isci_hissesi,2)#"><cfset ssk_isci_hissesi_gecici = ssk_isci_hissesi + ssdf_isci_hissesi + gelir_vergisi + damga_vergisi + issizlik_isci_hissesi></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cfset ssk_isci_hissesi_gecici_2 = 0>
                                <cfif get_puantaj_rows_end.recordcount>
                                    <cfset ssk_isci_hissesi_gecici_2 = get_puantaj_rows_end.ssk_isci_hissesi + get_puantaj_rows_end.ssdf_isci_hissesi + get_puantaj_rows_end.gelir_vergisi + get_puantaj_rows_end.damga_vergisi + get_puantaj_rows_end.issizlik_isci_hissesi>
                                </cfif>
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isci_hissesi_gecici_2,2)#">
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(ssk_isci_hissesi_gecici-ssk_isci_hissesi_gecici_2),2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cfif isdefined("onceki_donem_kum_gelir_vergisi_matrahi")>
                                    <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(onceki_donem_kum_gelir_vergisi_matrahi,2)#">
                                        <cfset onceki_donem_kum_gecici = onceki_donem_kum_gelir_vergisi_matrahi>
                                <cfelse>
                                    <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_kum_gelir_vergisi_matrahi,2)#">
                                    <cfset onceki_donem_kum_gecici = t_kum_gelir_vergisi_matrahi>
                                </cfif>
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cfif isdefined("onceki_donem_kum_gelir_vergisi_matrahi_2")>
                                    <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(onceki_donem_kum_gelir_vergisi_matrahi_2,2)#">
                                    <cfset onceki_donem_kum_gecici_2 = onceki_donem_kum_gelir_vergisi_matrahi_2>
                                <cfelse>
                                    <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(t_kum_gelir_vergisi_matrahi_2,2)#">
                                    <cfset onceki_donem_kum_gecici_2 = t_kum_gelir_vergisi_matrahi_2>
                                </cfif>
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(onceki_donem_kum_gecici-onceki_donem_kum_gecici_2),2)#">
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(sgk_isci_hissesi_fark,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(sgk_isci_hissesi_fark_2,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(sgk_isci_hissesi_fark-sgk_isci_hissesi_fark_2),2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(sgk_issizlik_hissesi_fark,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(sgk_issizlik_hissesi_fark_2,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(sgk_issizlik_hissesi_fark-sgk_issizlik_hissesi_fark_2),2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(sgdp_isci_primi_fark,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(sgdp_isci_primi_fark_2,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(sgdp_isci_primi_fark-sgdp_isci_primi_fark_2),2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ozel_kesinti,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.ozel_kesinti,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(get_puantaj_rows_end.ozel_kesinti) and len(ozel_kesinti)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(ozel_kesinti-get_puantaj_rows_end.ozel_kesinti),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(net_ucret-vergi_iadesi,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cfset net_ucret_gecici = 0>
                                <cfif get_puantaj_rows_end.recordcount>
                                    <cfset net_ucret_gecici = get_puantaj_rows_end.net_ucret-get_puantaj_rows_end.vergi_iadesi>
                                </cfif>
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(net_ucret_gecici,2)#">
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs((net_ucret-vergi_iadesi)-(net_ucret_gecici)),2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(net_ucret,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.net_ucret,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(get_puantaj_rows_end.net_ucret) and len(net_ucret)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(net_ucret-get_puantaj_rows_end.net_ucret),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(isveren_hesaplanan,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(isveren_hesaplanan_2,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(isveren_hesaplanan-isveren_hesaplanan_2),2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssdf_isveren_hissesi,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.ssdf_isveren_hissesi,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(get_puantaj_rows_end.ssdf_isveren_hissesi) and len(ssdf_isveren_hissesi)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(ssdf_isveren_hissesi-get_puantaj_rows_end.ssdf_isveren_hissesi),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif listlen(def_list) and len(account_bill_type)>#get_definition.DEFINITION[listfind(def_list,account_bill_type)]#</cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif ssk_isci_hissesi eq 0><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(0,2)#"><cfset ssk_isci_gecici = 0><cfelse><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isveren_hissesi_5084,2)#"><cfset ssk_isci_gecici = ssk_isveren_hissesi_5084></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cfset ssk_isci_gecici_2 = 0>
                                <cfif get_puantaj_rows_end.ssk_isci_hissesi eq 0>
                                    <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(0,2)#">
                                <cfelse>
                                    <cfif get_puantaj_rows_end.recordcount>
                                        <cfset ssk_isci_gecici_2 = get_puantaj_rows_end.ssk_isveren_hissesi_5084>
                                    </cfif>
                                    <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isci_gecici_2,2)#">
                                </cfif>
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(ssk_isci_gecici-ssk_isci_gecici_2),2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif ssk_isci_hissesi eq 0><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(0,2)#"><cfset ssk_isci_gov_gecici = 0><cfelse><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isveren_hissesi_gov,2)#"><cfset ssk_isci_gov_gecici = ssk_isveren_hissesi_gov></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cfset ssk_isci_gov_gecici_2 = 0>
                                <cfif get_puantaj_rows_end.ssk_isci_hissesi eq 0>
                                    <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(0,2)#">
                                <cfelse>
                                    <cfif get_puantaj_rows_end.recordcount>
                                        <cfset ssk_isci_gov_gecici_2 = get_puantaj_rows_end.ssk_isveren_hissesi_gov>
                                    </cfif>
                                    <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isci_gov_gecici_2,2)#">
                                </cfif>
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(ssk_isci_gov_gecici-ssk_isci_gov_gecici_2),2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isveren_hissesi_5510_,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isveren_hissesi_5510_2_,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(ssk_isveren_hissesi_5510_-ssk_isveren_hissesi_5510_2_),2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isveren_hissesi_5921,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.ssk_isveren_hissesi_5921,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(get_puantaj_rows_end.ssk_isveren_hissesi_5921) and len(ssk_isveren_hissesi_5921)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(ssk_isveren_hissesi_5921-get_puantaj_rows_end.ssk_isveren_hissesi_5921),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isveren_hissesi_5746,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.ssk_isveren_hissesi_5746,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(get_puantaj_rows_end.ssk_isveren_hissesi_5746) and len(ssk_isveren_hissesi_5746)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(ssk_isveren_hissesi_5746-get_puantaj_rows_end.ssk_isveren_hissesi_5746),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isveren_hissesi_4691,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.ssk_isveren_hissesi_4691,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(get_puantaj_rows_end.ssk_isveren_hissesi_4691) and len(ssk_isveren_hissesi_4691)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(ssk_isveren_hissesi_4691-get_puantaj_rows_end.ssk_isveren_hissesi_4691),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isveren_hissesi_6111,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.ssk_isveren_hissesi_6111,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(get_puantaj_rows_end.ssk_isveren_hissesi_6111) and len(ssk_isveren_hissesi_6111)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(ssk_isveren_hissesi_6111-get_puantaj_rows_end.ssk_isveren_hissesi_6111),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isveren_hissesi_6486,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.ssk_isveren_hissesi_6486,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(get_puantaj_rows_end.ssk_isveren_hissesi_6486) and len(get_puantaj_rows_end.ssk_isveren_hissesi_6486)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(ssk_isveren_hissesi_6486-get_puantaj_rows_end.ssk_isveren_hissesi_6486),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isveren_hissesi_6322+ssk_isci_hissesi_6322,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cfset ssk_isveren_hisse_6322_gecici = 0>
                                <cfif get_puantaj_rows_end.recordcount>
                                    <cfset ssk_isveren_hisse_6322_gecici = get_puantaj_rows_end.ssk_isveren_hissesi_6322+get_puantaj_rows_end.ssk_isci_hissesi_6322>
                                </cfif>
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isveren_hisse_6322_gecici,2)#">
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs((ssk_isveren_hissesi_6322+ssk_isci_hissesi_6322)-(ssk_isveren_hisse_6322_gecici)),2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isveren_hissesi_14857,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.ssk_isveren_hissesi_14857,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(get_puantaj_rows_end.ssk_isveren_hissesi_14857) and len(ssk_isveren_hissesi_14857)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(ssk_isveren_hissesi_14857-get_puantaj_rows_end.ssk_isveren_hissesi_14857),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isveren_hissesi_6645,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.ssk_isveren_hissesi_6645,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(get_puantaj_rows_end.ssk_isveren_hissesi_6645) and len(ssk_isveren_hissesi_6645)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(ssk_isveren_hissesi_6645-get_puantaj_rows_end.ssk_isveren_hissesi_6645),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isveren_hissesi_7252,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.ssk_isveren_hissesi_7252,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(ssk_isveren_hissesi_7252) and len(get_puantaj_rows_end.ssk_isveren_hissesi_7252)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(ssk_isveren_hissesi_7252-get_puantaj_rows_end.ssk_isveren_hissesi_7252),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ISSIZLIK_ISVEREN_HISSESI_7252,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.ISSIZLIK_ISVEREN_HISSESI_7252,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(ISSIZLIK_ISVEREN_HISSESI_7252) and len(get_puantaj_rows_end.ISSIZLIK_ISVEREN_HISSESI_7252)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(ISSIZLIK_ISVEREN_HISSESI_7252-get_puantaj_rows_end.ISSIZLIK_ISVEREN_HISSESI_7252),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isci_hissesi_687,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.ssk_isci_hissesi_687,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(get_puantaj_rows_end.ssk_isci_hissesi_687) and len(ssk_isci_hissesi_687)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(ssk_isci_hissesi_687-get_puantaj_rows_end.ssk_isci_hissesi_687),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(issizlik_isci_hissesi_687,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.issizlik_isci_hissesi_687,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(get_puantaj_rows_end.issizlik_isci_hissesi_687) and len(issizlik_isci_hissesi_687)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(issizlik_isci_hissesi_687-get_puantaj_rows_end.issizlik_isci_hissesi_687),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isci_hissesi_7252,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.ssk_isci_hissesi_7252,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(ssk_isci_hissesi_7252) and len(get_puantaj_rows_end.ssk_isci_hissesi_7252)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(ssk_isci_hissesi_7252-get_puantaj_rows_end.ssk_isci_hissesi_7252),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(issizlik_isci_hissesi_7252,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.issizlik_isci_hissesi_7252,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(issizlik_isci_hissesi_7252) and len(get_puantaj_rows_end.issizlik_isci_hissesi_7252)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(issizlik_isci_hissesi_7252-get_puantaj_rows_end.issizlik_isci_hissesi_7252),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(gelir_vergisi_indirimi_687,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.gelir_vergisi_indirimi_687,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(get_puantaj_rows_end.gelir_vergisi_indirimi_687) and len(gelir_vergisi_indirimi_687)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(gelir_vergisi_indirimi_687-get_puantaj_rows_end.gelir_vergisi_indirimi_687),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(damga_vergisi_indirimi_687,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.damga_vergisi_indirimi_687,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(get_puantaj_rows_end.damga_vergisi_indirimi_687) and len(damga_vergisi_indirimi_687)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(damga_vergisi_indirimi_687-get_puantaj_rows_end.damga_vergisi_indirimi_687),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isveren_hissesi_687,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.ssk_isveren_hissesi_687,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(get_puantaj_rows_end.ssk_isveren_hissesi_687) and len(ssk_isveren_hissesi_687)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(ssk_isveren_hissesi_687-get_puantaj_rows_end.ssk_isveren_hissesi_687),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(issizlik_isveren_hissesi_687,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.issizlik_isveren_hissesi_687,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(get_puantaj_rows_end.issizlik_isveren_hissesi_687) and len(issizlik_isveren_hissesi_687)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(issizlik_isveren_hissesi_687-get_puantaj_rows_end.issizlik_isveren_hissesi_687),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isci_hissesi_7103,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.ssk_isci_hissesi_7103,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(get_puantaj_rows_end.ssk_isci_hissesi_7103) and len(ssk_isci_hissesi_7103)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(ssk_isci_hissesi_7103-get_puantaj_rows_end.ssk_isci_hissesi_7103),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(issizlik_isci_hissesi_7103,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.issizlik_isci_hissesi_7103,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(get_puantaj_rows_end.issizlik_isci_hissesi_7103) and len(issizlik_isci_hissesi_7103)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(issizlik_isci_hissesi_7103-get_puantaj_rows_end.issizlik_isci_hissesi_7103),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(gelir_vergisi_indirimi_7103,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.gelir_vergisi_indirimi_7103,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(get_puantaj_rows_end.gelir_vergisi_indirimi_7103) and len(gelir_vergisi_indirimi_7103)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(gelir_vergisi_indirimi_7103-get_puantaj_rows_end.gelir_vergisi_indirimi_7103,2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(damga_vergisi_indirimi_7103,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.damga_vergisi_indirimi_7103,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(get_puantaj_rows_end.damga_vergisi_indirimi_7103) and len(damga_vergisi_indirimi_7103)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(damga_vergisi_indirimi_7103-get_puantaj_rows_end.damga_vergisi_indirimi_7103),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isveren_hissesi_7103,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.ssk_isveren_hissesi_7103,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(get_puantaj_rows_end.ssk_isveren_hissesi_7103) and len(ssk_isveren_hissesi_7103)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(ssk_isveren_hissesi_7103-get_puantaj_rows_end.ssk_isveren_hissesi_7103),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(issizlik_isveren_hissesi_7103,2)#"></td>     
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.issizlik_isveren_hissesi_7103,2)#"></td>     
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(get_puantaj_rows_end.issizlik_isveren_hissesi_7103) and len(issizlik_isveren_hissesi_7103)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(issizlik_isveren_hissesi_7103-get_puantaj_rows_end.issizlik_isveren_hissesi_7103),2)#"></cfif></td>                        
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isveren_hissesi - ssk_isveren_hissesi_gov - ssk_isveren_hissesi_5921 - ssk_isveren_hissesi_5746 -ssk_isveren_hissesi_4691 - ssk_isveren_hissesi_6111-ssk_isveren_hissesi_6645-ssk_isveren_hissesi_6486-ssk_isveren_hissesi_6322-ssk_isveren_hissesi_687-ssk_isveren_hissesi_7103 - ssk_isveren_hissesi_14857,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cfset ssk_isveren_hissesi_temp = 0>
                                <cfif get_puantaj_rows_end.recordcount>
                                    <cfset ssk_isveren_hissesi_temp = get_puantaj_rows_end.ssk_isveren_hissesi - get_puantaj_rows_end.ssk_isveren_hissesi_gov - get_puantaj_rows_end.ssk_isveren_hissesi_5921 - get_puantaj_rows_end.ssk_isveren_hissesi_5746 -get_puantaj_rows_end.ssk_isveren_hissesi_4691 - get_puantaj_rows_end.ssk_isveren_hissesi_6111-get_puantaj_rows_end.ssk_isveren_hissesi_6645-get_puantaj_rows_end.ssk_isveren_hissesi_6486-get_puantaj_rows_end.ssk_isveren_hissesi_6322-get_puantaj_rows_end.ssk_isveren_hissesi_687-get_puantaj_rows_end.ssk_isveren_hissesi_7103 - get_puantaj_rows_end.ssk_isveren_hissesi_14857>
                                </cfif>
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isveren_hissesi_temp,2)#">
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs((ssk_isveren_hissesi - ssk_isveren_hissesi_gov - ssk_isveren_hissesi_5921 - ssk_isveren_hissesi_5746 -ssk_isveren_hissesi_4691 - ssk_isveren_hissesi_6111-ssk_isveren_hissesi_6645-ssk_isveren_hissesi_6486-ssk_isveren_hissesi_6322-ssk_isveren_hissesi_687-ssk_isveren_hissesi_7103 - ssk_isveren_hissesi_14857)-(ssk_isveren_hissesi_temp)),2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssdf_isveren_hissesi,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.ssdf_isveren_hissesi,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(get_puantaj_rows_end.ssdf_isveren_hissesi) and len(ssdf_isveren_hissesi)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(ssdf_isveren_hissesi-get_puantaj_rows_end.ssdf_isveren_hissesi),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isveren_hissesi - ssk_isveren_hissesi_gov - ssk_isveren_hissesi_5921 - ssk_isveren_hissesi_5746 -ssk_isveren_hissesi_4691- ssk_isveren_hissesi_6111-ssk_isveren_hissesi_6645-ssk_isveren_hissesi_6486-ssk_isveren_hissesi_6322+ssk_isci_hissesi - ssk_isveren_hissesi_687 -ssk_isci_hissesi_687 - ssk_isveren_hissesi_7103 -ssk_isci_hissesi_7103 -ssk_isveren_hissesi_14857,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cfset ssk_isveren_hissesi_gov_temp = 0>
                                <cfif get_puantaj_rows_end.recordcount>
                                    <cfset ssk_isveren_hissesi_gov_temp = get_puantaj_rows_end.ssk_isveren_hissesi - get_puantaj_rows_end.ssk_isveren_hissesi_gov - get_puantaj_rows_end.ssk_isveren_hissesi_5921 - get_puantaj_rows_end.ssk_isveren_hissesi_5746 -get_puantaj_rows_end.ssk_isveren_hissesi_4691- get_puantaj_rows_end.ssk_isveren_hissesi_6111-get_puantaj_rows_end.ssk_isveren_hissesi_6645-get_puantaj_rows_end.ssk_isveren_hissesi_6486-get_puantaj_rows_end.ssk_isveren_hissesi_6322+get_puantaj_rows_end.ssk_isci_hissesi - get_puantaj_rows_end.ssk_isveren_hissesi_687 -get_puantaj_rows_end.ssk_isci_hissesi_687 - get_puantaj_rows_end.ssk_isveren_hissesi_7103 -get_puantaj_rows_end.ssk_isci_hissesi_7103 -get_puantaj_rows_end.ssk_isveren_hissesi_14857>
                                </cfif>
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_isveren_hissesi_gov_temp,2)#">
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs((ssk_isveren_hissesi - ssk_isveren_hissesi_gov - ssk_isveren_hissesi_5921 - ssk_isveren_hissesi_5746 -ssk_isveren_hissesi_4691- ssk_isveren_hissesi_6111-ssk_isveren_hissesi_6645-ssk_isveren_hissesi_6486-ssk_isveren_hissesi_6322+ssk_isci_hissesi - ssk_isveren_hissesi_687 -ssk_isci_hissesi_687 - ssk_isveren_hissesi_7103 -ssk_isci_hissesi_7103 -ssk_isveren_hissesi_14857)-(ssk_isveren_hissesi_gov_temp)),2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(bes_isci_hissesi,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.bes_isci_hissesi,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(get_puantaj_rows_end.bes_isci_hissesi) and len(bes_isci_hissesi)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(bes_isci_hissesi-get_puantaj_rows_end.bes_isci_hissesi),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(issizlik_isveren_hissesi-issizlik_isveren_hissesi_687,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cfset issizlik_isveren_temp = 0>
                                <cfif get_puantaj_rows_end.recordcount>
                                    <cfset issizlik_isveren_temp = get_puantaj_rows_end.issizlik_isveren_hissesi-get_puantaj_rows_end.issizlik_isveren_hissesi_687>
                                </cfif>
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(issizlik_isveren_temp,2)#">
                            </td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs((issizlik_isveren_hissesi-issizlik_isveren_hissesi_687)-(issizlik_isveren_temp)),2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(yillik_izin,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(yillik_izin_2,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(yillik_izin-yillik_izin_2),2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(kidem_amount,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.kidem_amount,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(get_puantaj_rows_end.kidem_amount) and len(kidem_amount)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(kidem_amount-get_puantaj_rows_end.kidem_amount),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ihbar_amount,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.ihbar_amount,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(get_puantaj_rows_end.ihbar_amount) and len(ihbar_amount)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(ihbar_amount-get_puantaj_rows_end.ihbar_amount),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(toplam_isveren,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(toplam_isveren_2,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(toplam_isveren-toplam_isveren_2),2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(toplam_isveren_indirimsiz,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(toplam_isveren_indirimsiz_2,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(toplam_isveren_indirimsiz-toplam_isveren_indirimsiz_2),2)#"></td>
                            <td nowrap><cfif sabit_prim eq 0><cf_get_lang dictionary_id='58544.Sabit'><cfelse><cf_get_lang dictionary_id ='53558.Primli'></cfif></td>
                            <td nowrap><cfif len(paymethod_id)>#GET_PAY_METHODS.paymethod[listfind(pay_list,paymethod_id,',')]#<cfelse>&nbsp;</cfif></td>  
                            <td nowrap><cfif listlen(fonsiyonel_list) and len(FUNC_ID)>#get_units.unit_name[listfind(fonsiyonel_list,func_id,',')]#<cfelse>&nbsp;</cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(vergi_istisna_total,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.vergi_istisna_total,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(get_puantaj_rows_end.vergi_istisna_total) and len(vergi_istisna_total)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(vergi_istisna_total-get_puantaj_rows_end.vergi_istisna_total),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(vergi_istisna_ssk,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.vergi_istisna_ssk,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(get_puantaj_rows_end.vergi_istisna_ssk) and len(vergi_istisna_ssk)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(vergi_istisna_ssk-get_puantaj_rows_end.vergi_istisna_ssk),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(vergi_istisna_ssk_net,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.vergi_istisna_ssk_net,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(get_puantaj_rows_end.vergi_istisna_ssk_net) and len(vergi_istisna_ssk_net)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(vergi_istisna_ssk_net-get_puantaj_rows_end.vergi_istisna_ssk_net),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(vergi_istisna_vergi,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.vergi_istisna_vergi,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(get_puantaj_rows_end.vergi_istisna_vergi) and len(vergi_istisna_vergi)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(vergi_istisna_vergi-get_puantaj_rows_end.vergi_istisna_vergi),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(vergi_istisna_vergi_net,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.vergi_istisna_vergi_net,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(get_puantaj_rows_end.vergi_istisna_vergi_net) and len(vergi_istisna_vergi_net)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(vergi_istisna_vergi_net-get_puantaj_rows_end.vergi_istisna_vergi_net),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(vergi_istisna_damga,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.vergi_istisna_damga,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(get_puantaj_rows_end.vergi_istisna_damga) and len(vergi_istisna_damga)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(vergi_istisna_damga-get_puantaj_rows_end.vergi_istisna_damga),2)#"></cfif></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(vergi_istisna_damga_net,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.vergi_istisna_damga_net,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cfif len(get_puantaj_rows_end.vergi_istisna_damga_net) and len(vergi_istisna_damga_net)><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(Abs(vergi_istisna_damga_net-get_puantaj_rows_end.vergi_istisna_damga_net),2)#"></cfif></td>
                            <cfset count_ = 0>

                            <cfloop query="get_odenek">
                                <cfif len(get_data.EMPLOYEE_PUANTAJ_ID)>
                                    <cfquery name="get_odenek_amount" datasource="#dsn#">
                                        SELECT
                                            ISNULL(SUM(AMOUNT),0) AS AMOUNT
                                        FROM
                                        (
                                            SELECT
                                                EMPLOYEES_PUANTAJ_ROWS_EXT.AMOUNT_2 AS AMOUNT
                                            FROM
                                                EMPLOYEES_PUANTAJ_ROWS_EXT 
                                                LEFT JOIN SETUP_PAYMENT_INTERRUPTION ON EMPLOYEES_PUANTAJ_ROWS_EXT.COMMENT_PAY_ID = SETUP_PAYMENT_INTERRUPTION.ODKES_ID
                                            WHERE
                                                EMPLOYEES_PUANTAJ_ROWS_EXT.EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_data.EMPLOYEE_PUANTAJ_ID#"> 
                                                AND
                                                EMPLOYEES_PUANTAJ_ROWS_EXT.EXT_TYPE = 0 AND
                                                EMPLOYEES_PUANTAJ_ROWS_EXT.PAY_METHOD = 2 AND
                                                EMPLOYEES_PUANTAJ_ROWS_EXT.COMMENT_PAY = '#COMMENT_PAY#'
                                            UNION ALL
                                            SELECT
                                                EMPLOYEES_PUANTAJ_ROWS_EXT.AMOUNT
                                            FROM
                                                EMPLOYEES_PUANTAJ_ROWS_EXT 
                                                LEFT JOIN SETUP_PAYMENT_INTERRUPTION ON EMPLOYEES_PUANTAJ_ROWS_EXT.COMMENT_PAY_ID = SETUP_PAYMENT_INTERRUPTION.ODKES_ID
                                            WHERE
                                                EMPLOYEES_PUANTAJ_ROWS_EXT.EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_data.EMPLOYEE_PUANTAJ_ID#"> 
                                                AND
                                                EMPLOYEES_PUANTAJ_ROWS_EXT.EXT_TYPE = 0 AND
                                                (EMPLOYEES_PUANTAJ_ROWS_EXT.PAY_METHOD <> 2 OR EMPLOYEES_PUANTAJ_ROWS_EXT.PAY_METHOD IS NULL) AND
                                                EMPLOYEES_PUANTAJ_ROWS_EXT.COMMENT_PAY = '#COMMENT_PAY#'
                                        ) AS T2
                                    </cfquery>
                                <cfelse>
                                    <cfset get_odenek_amount.AMOUNT = 0>
                                </cfif>
                                <cfif len(get_puantaj_rows_end.EMPLOYEE_PUANTAJ_ID)>
                                    <cfquery name="get_odenek_amount_end" datasource="#dsn#">
                                        SELECT
                                            ISNULL(SUM(AMOUNT),0) AS AMOUNT
                                        FROM
                                        (
                                            SELECT
                                                EMPLOYEES_PUANTAJ_ROWS_EXT.AMOUNT_2 AS AMOUNT
                                            FROM
                                                EMPLOYEES_PUANTAJ_ROWS_EXT 
                                                LEFT JOIN SETUP_PAYMENT_INTERRUPTION ON EMPLOYEES_PUANTAJ_ROWS_EXT.COMMENT_PAY_ID = SETUP_PAYMENT_INTERRUPTION.ODKES_ID
                                            WHERE
                                                EMPLOYEES_PUANTAJ_ROWS_EXT.EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_rows_end.EMPLOYEE_PUANTAJ_ID#"> 
                                                AND
                                                EMPLOYEES_PUANTAJ_ROWS_EXT.EXT_TYPE = 0 AND
                                                EMPLOYEES_PUANTAJ_ROWS_EXT.PAY_METHOD = 2 AND
                                                EMPLOYEES_PUANTAJ_ROWS_EXT.COMMENT_PAY = '#COMMENT_PAY#'
                                            UNION ALL
                                            SELECT
                                                EMPLOYEES_PUANTAJ_ROWS_EXT.AMOUNT
                                            FROM
                                                EMPLOYEES_PUANTAJ_ROWS_EXT 
                                                LEFT JOIN SETUP_PAYMENT_INTERRUPTION ON EMPLOYEES_PUANTAJ_ROWS_EXT.COMMENT_PAY_ID = SETUP_PAYMENT_INTERRUPTION.ODKES_ID
                                            WHERE
                                                EMPLOYEES_PUANTAJ_ROWS_EXT.EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_rows_end.EMPLOYEE_PUANTAJ_ID#"> 
                                                AND
                                                EMPLOYEES_PUANTAJ_ROWS_EXT.EXT_TYPE = 0 AND
                                                (EMPLOYEES_PUANTAJ_ROWS_EXT.PAY_METHOD <> 2 OR EMPLOYEES_PUANTAJ_ROWS_EXT.PAY_METHOD IS NULL) AND
                                                EMPLOYEES_PUANTAJ_ROWS_EXT.COMMENT_PAY = '#COMMENT_PAY#'
                                        ) AS T2
                                    </cfquery>
                                <cfelse>
                                    <cfset get_odenek_amount_end.AMOUNT = 0>
                                </cfif>
                                <td nowrap><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_odenek_amount.AMOUNT,2)#"></td>
                                <td nowrap><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_odenek_amount_end.AMOUNT,2)#"></td>
                                <td nowrap>
                                    <cfif len(get_odenek_amount.AMOUNT) and len(get_odenek_amount_end.AMOUNT)>
                                        <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(abs(get_odenek_amount.AMOUNT-get_odenek_amount_end.AMOUNT),2)#">
                                    </cfif>
                                </td>
                            </cfloop>

                            <td nowrap>
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(avans,2)#">
                            </td>
                            <td nowrap>
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.avans,2)#">
                            </td>
                            <td nowrap>
                                <cfif len(get_puantaj_rows_end.avans) and len(avans)>
                                    <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(abs(avans-get_puantaj_rows_end.avans),2)#">
                                </cfif>
                            </td>

                            <cfloop query="get_kesinti">
                                <cfif len(get_data.EMPLOYEE_PUANTAJ_ID)>
                                    <cfquery name="get_kesinti_amount" datasource="#dsn#">
                                        SELECT
                                            ISNULL(SUM(AMOUNT),0) AS AMOUNT
                                        FROM
                                        (
                                            SELECT
                                                AMOUNT AS AMOUNT
                                            FROM
                                                EMPLOYEES_PUANTAJ_ROWS_EXT
                                            WHERE
                                                EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_data.EMPLOYEE_PUANTAJ_ID#"> 
                                                AND (
                                                        (EXT_TYPE = 1 AND (PAY_METHOD NOT IN (2,3,4,5) OR PAY_METHOD IS NULL))
                                                        OR 
                                                        EXT_TYPE = 3 AND PAY_METHOD <> 1
                                                    )
                                                AND COMMENT_PAY = '#COMMENT_PAY#'
                                            UNION ALL
                                            SELECT
                                                AMOUNT_2 AS AMOUNT
                                            FROM
                                                EMPLOYEES_PUANTAJ_ROWS_EXT
                                            WHERE
                                                EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_data.EMPLOYEE_PUANTAJ_ID#"> 
                                                AND (
                                                        (EXT_TYPE = 1 AND PAY_METHOD IN (2,3,4,5))
                                                        OR
                                                        EXT_TYPE = 3 AND PAY_METHOD = 1
                                                    )
                                                AND COMMENT_PAY = '#COMMENT_PAY#' 
                                        ) as T1
                                    </cfquery>
                                <cfelse>
                                    <cfset get_kesinti_amount.AMOUNT = 0>
                                </cfif>
                                <cfif len(get_puantaj_rows_end.EMPLOYEE_PUANTAJ_ID)>
                                    <cfquery name="get_kesinti_amount_end" datasource="#dsn#">
                                        SELECT
                                            ISNULL(SUM(AMOUNT),0) AS AMOUNT
                                        FROM
                                        (
                                            SELECT
                                                AMOUNT AS AMOUNT
                                            FROM
                                                EMPLOYEES_PUANTAJ_ROWS_EXT
                                            WHERE
                                                EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_rows_end.EMPLOYEE_PUANTAJ_ID#"> 
                                                AND (
                                                        (EXT_TYPE = 1 AND (PAY_METHOD NOT IN (2,3,4,5) OR PAY_METHOD IS NULL))
                                                        OR 
                                                        EXT_TYPE = 3 AND PAY_METHOD <> 1
                                                    )
                                                AND COMMENT_PAY = '#COMMENT_PAY#'
                                            UNION ALL
                                            SELECT
                                                AMOUNT_2 AS AMOUNT
                                            FROM
                                                EMPLOYEES_PUANTAJ_ROWS_EXT
                                            WHERE
                                                EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_rows_end.EMPLOYEE_PUANTAJ_ID#"> 
                                                AND (
                                                        (EXT_TYPE = 1 AND PAY_METHOD IN (2,3,4,5))
                                                        OR
                                                        EXT_TYPE = 3 AND PAY_METHOD = 1
                                                    )
                                                AND COMMENT_PAY = '#COMMENT_PAY#' 
                                        ) as T1
                                    </cfquery>
                                <cfelse>
                                    <cfset get_kesinti_amount_end.AMOUNT = 0>
                                </cfif>
                                <td nowrap><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_kesinti_amount.AMOUNT,2)#"></td>
                                <td nowrap><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_kesinti_amount_end.AMOUNT,2)#"></td>
                                <td nowrap>
                                    <cfif len(get_kesinti_amount.AMOUNT) and len(get_kesinti_amount_end.AMOUNT)>
                                        <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(abs(get_kesinti_amount.AMOUNT-get_kesinti_amount_end.AMOUNT),2)#">
                                    </cfif>
                                </td>
                            </cfloop>

                            <cfloop query="get_vergi_istisna_">
                                <cfif len(get_data.EMPLOYEE_PUANTAJ_ID)>
                                    <cfquery name="get_vergi_istisna_amount" datasource="#dsn#">
                                        SELECT
                                            ISNULL(SUM(VERGI_ISTISNA_AMOUNT),0) VERGI_ISTISNA_AMOUNT,
                                            ISNULL(SUM(VERGI_ISTISNA_TOTAL),0) VERGI_ISTISNA_TOTAL
                                        FROM
                                            EMPLOYEES_PUANTAJ_ROWS_EXT
                                        WHERE
                                            EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_data.EMPLOYEE_PUANTAJ_ID#"> 
                                            AND EXT_TYPE = 2
                                            AND COMMENT_PAY = '#tax_exception#'
                                    </cfquery>
                                <cfelse>
                                    <cfset get_vergi_istisna_amount.VERGI_ISTISNA_AMOUNT = 0>
                                </cfif>
                                <cfif len(get_puantaj_rows_end.EMPLOYEE_PUANTAJ_ID)>
                                    <cfquery name="get_vergi_istisna_amount_end" datasource="#dsn#">
                                        SELECT
                                            ISNULL(SUM(VERGI_ISTISNA_AMOUNT),0) VERGI_ISTISNA_AMOUNT,
                                            ISNULL(SUM(VERGI_ISTISNA_TOTAL),0) VERGI_ISTISNA_TOTAL
                                        FROM
                                            EMPLOYEES_PUANTAJ_ROWS_EXT
                                        WHERE
                                            EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_rows_end.EMPLOYEE_PUANTAJ_ID#"> 
                                            AND EXT_TYPE = 2
                                            AND COMMENT_PAY = '#tax_exception#'
                                    </cfquery>
                                <cfelse>
                                    <cfset get_vergi_istisna_amount_end.VERGI_ISTISNA_AMOUNT = 0>
                                </cfif>
                                <td nowrap><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_vergi_istisna_amount.VERGI_ISTISNA_AMOUNT,2)#"></td>
                                <td nowrap><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_vergi_istisna_amount_end.VERGI_ISTISNA_AMOUNT,2)#"></td>
                                <td nowrap>
                                    <cfif len(get_vergi_istisna_amount.VERGI_ISTISNA_AMOUNT) and len(get_vergi_istisna_amount_end.VERGI_ISTISNA_AMOUNT)>
                                        <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(abs(get_vergi_istisna_amount.VERGI_ISTISNA_AMOUNT-get_vergi_istisna_amount_end.VERGI_ISTISNA_AMOUNT),2)#">
                                    </cfif>
                                </td>
                            </cfloop>

                            <td nowrap><cfif listlen(main_expense_list) and len(expense_code)>#get_expenses.EXPENSE[listfind(main_expense_list,expense_code,';')]#</cfif></td>
                            <td nowrap>#expense_code#</td>
                            <td nowrap>#account_code#</td>
                            <td nowrap>#BANK_NAME#</td>
                            <td nowrap>#BANK_BRANCH_CODE#-#BANK_ACCOUNT_NO#</td>
                            <td nowrap>#IBAN_NO#</td>

                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat((ssk_devir_ + ssk_devir_last_),2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat((ssk_devir_2_ + ssk_devir_last_2_),2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(abs((ssk_devir_ + ssk_devir_last_)-(ssk_devir_2_ + ssk_devir_last_2_)),2)#"></td>

                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_devir_last_,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_devir_last_2_,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(abs(ssk_devir_last_ - ssk_devir_last_2_),2)#"></td>

                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_devir_,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_devir_2_,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(abs(ssk_devir_-ssk_devir_2_),2)#"></td>

                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ssk_amount,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_puantaj_rows_end.ssk_amount,2)#"></td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cfif len(ssk_amount) and len(get_puantaj_rows_end.ssk_amount)>
                                    <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(abs(ssk_amount-get_puantaj_rows_end.ssk_amount),2)#">
                                </cfif>
                            </td>

                            <td nowrap style="text-align:right;mso-number-format:'0\.00';">
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(net_ucret-vergi_iadesi+ozel_kesinti+bes_isci_hissesi)#">
                            </td>
                            <td>
                                <cfset agi_oncesi_net_temp = 0>
                                <cfif get_puantaj_rows_end.recordcount>
                                    <cfset agi_oncesi_net_temp = get_puantaj_rows_end.net_ucret - get_puantaj_rows_end.vergi_iadesi + get_puantaj_rows_end.ozel_kesinti + get_puantaj_rows_end.bes_isci_hissesi>
                                </cfif>
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(agi_oncesi_net_temp)#">
                            </td>
                            <td>
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(abs((net_ucret-vergi_iadesi+ozel_kesinti+bes_isci_hissesi) - agi_oncesi_net_temp))#">
                            </td>
                        </tr>
                    </cfoutput>
                </cfoutput>
            <cfelse>
                <tr>
                    <td nowrap colspan="8"><cf_get_lang dictionary_id='57484.kayıt yok'>!</td>
                </tr>
            </cfif>
        </tbody>
        <cfif attributes.totalrecords gt attributes.maxrows>
            <cfset url_str = "report.diff_summary_sheet">
            <cfif isdefined('attributes.is_form_submit')>
                <cfset url_str = '#url_str#&is_form_submit=1'>
            </cfif>
            <cfif len(attributes.emp_no)>
                <cfset url_str = '#url_str#&emp_no=#attributes.emp_no#'>
            </cfif>
            <cfif len(attributes.emp_name)>
                <cfset url_str = '#url_str#&emp_name=#attributes.emp_name#'>
            </cfif>
            <cfif len(attributes.branch_id)>
                <cfset url_str = '#url_str#&branch_id=#attributes.branch_id#'>
            </cfif>
            <cfif len(attributes.department_id)>
                <cfset url_str = '#url_str#&department_id=#attributes.department_id#'>
            </cfif>
            <cfif len(attributes.sal_mon)>
                <cfset url_str = '#url_str#&sal_mon=#attributes.sal_mon#'>
            </cfif>
            <cfif len(attributes.sal_year)>
                <cfset url_str = '#url_str#&sal_year=#attributes.sal_year#'>
            </cfif>
            <cfif len(attributes.sal_mon_end)>
                <cfset url_str = '#url_str#&sal_mon_end=#attributes.sal_mon_end#'>
            </cfif>
            <cfif len(attributes.sal_year_end)>
                <cfset url_str = '#url_str#&sal_year_end=#attributes.sal_year_end#'>
            </cfif>
            <cf_paging 
                page="#attributes.page#" 
                maxrows="#attributes.maxrows#" 
                totalrecords="#attributes.totalrecords#" 
                startrow="#attributes.startrow#" 
                adres="#url_str#">
        </cfif>
    </cf_report_list>
</cfif>
<script type="text/javascript">
    function control(){
        if(parseInt(search_form.sal_mon.value) < parseInt(search_form.sal_mon_end.value)){	
            if(parseInt(search_form.sal_year.value) > parseInt(search_form.sal_year_end.value))
            {
                alert("<cf_get_lang dictionary_id='58492.Tarih Kontrol'>");
                return false;
            }
        }
        else if(parseInt(search_form.sal_mon.value) > parseInt(search_form.sal_mon_end.value)){
            if(parseInt(search_form.sal_year.value) >= parseInt(search_form.sal_year_end.value))
            {
                alert("<cf_get_lang dictionary_id='58492.Tarih Kontrol'>");
                return false;
            }
        }
        else if(parseInt(search_form.sal_mon.value) == parseInt(search_form.sal_mon_end.value)){
            if(parseInt(search_form.sal_year.value) > parseInt(search_form.sal_year_end.value))
            {
                alert("<cf_get_lang dictionary_id='58492.Tarih Kontrol'>");
                return false;
            }
        }
        
        if(document.search_form.is_excel.checked==false){
            document.search_form.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>";
            return true;
        }
        else
            document.search_form.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_diff_summary_sheet</cfoutput>";
    }

    function showDepartment(branch_id){
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&show_div=0&branch_id="+branch_id;
			AjaxPageLoad(send_address,'department_div',1,'İlişkili Departmanlar');
		}
    }

    function change_mon(i){
		$('#sal_mon_end').val(i);
	}
</script>