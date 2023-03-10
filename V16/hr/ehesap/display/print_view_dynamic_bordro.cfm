<!--- dinamik bordro print SG 20140227--->
<cf_xml_page_edit fuseact="ehesap.list_dynamic_bordro">
<style type="text/css" media="print">
  @page { size: landscape; }
</style>
<cfquery name="get_url_list" datasource="#dsn#">
	SELECT * FROM ##url_list_table
</cfquery>
<cfif isdefined("x_page_row") and not len(x_page_row)>
    <cfset x_page_row = 10>
</cfif>
<cfoutput query="get_url_list">
	<cfparam name="attributes.hierarchy" default="#hierarchy#">
	<cfparam name="attributes.sal_year_end" default="#sal_year_end#">
	<cfparam name="attributes.sal_mon_end" default="#sal_mon_end#">
	<cfparam name="attributes.sal_year" default="#sal_year#">
	<cfparam name="attributes.sal_mon" default="#sal_mon#">
	<cfparam name="attributes.keyword" default="#keyword#">
	<cfparam name="attributes.UPPER_POSITION_CODE2" default="#UPPER_POSITION_CODE2#">
	<cfparam name="attributes.UPPER_POSITION2" default="#UPPER_POSITION2#">
	<cfparam name="attributes.UPPER_POSITION" default="#UPPER_POSITION#">
	<cfparam name="attributes.UPPER_POSITION_CODE" default="#UPPER_POSITION_CODE#">
	<cfparam name="attributes.SORT_TYPE" default="#SORT_TYPE#">
	<cfparam name="attributes.PRINT_ROW_COUNT" default="#PRINT_ROW_COUNT#">
	<cfparam name="attributes.PUANTAJ_TYPE" default="#PUANTAJ_TYPE#">
	<cfparam name="attributes.B_OBJ_SIRA_HIDDEN" default="#B_OBJ_SIRA_HIDDEN#">
    <cfparam name="attributes.B_OBJ_HIDDEN" default="#B_OBJ_HIDDEN#">
	<cfparam name="attributes.BRANCH_ID" default="#BRANCH_ID#">
	<cfparam name="attributes.DEPARTMENT" default="#DEPARTMENT#">
</cfoutput>
<cfsetting showdebugoutput="no">
<cfscript>
	puantaj_gun_ = daysinmonth(CREATEDATE(attributes.sal_year,attributes.SAL_MON,1));

	get_puantaj_ = createObject("component", "V16.hr.ehesap.cfc.get_dynamic_bordro");
	get_puantaj_.dsn = dsn;
	get_puantaj_.dsn_alias = dsn_alias;
	get_puantaj_rows = get_puantaj_.get_dynamic_bordro
	(
		sal_year : attributes.sal_year,
		sal_mon : attributes.sal_mon,
		sal_year_end : attributes.sal_year_end,
		sal_mon_end : attributes.sal_mon_end,
		puantaj_type : attributes.puantaj_type,
		keyword:attributes.keyword,
		sort_type: attributes.sort_type,
		upper_position_code:attributes.upper_position_code,
		upper_position :attributes.upper_position,
		upper_position_code2:attributes.upper_position_code2,
		upper_position2:attributes.upper_position2,
		branch_id: '#iif(isdefined("attributes.branch_id"),"attributes.branch_id",DE(""))#' ,
		comp_id: '#iif(isdefined("attributes.comp_id"),"attributes.comp_id",DE(""))#',
		department:'#iif(isdefined("attributes.department"),"attributes.department",DE(""))#',
		position_branch_id:'#iif(isdefined("attributes.position_branch_id"),"attributes.position_branch_id",DE(""))#',
		position_department:'#iif(isdefined("attributes.position_department"),"attributes.position_department",DE(""))#',
		is_all_dep:'#iif(isdefined("attributes.is_all_dep"),"attributes.is_all_dep",DE(""))#',
		is_dep_level:'#iif(isdefined("attributes.is_dep_level"),"attributes.is_dep_level",DE(""))#',
		ssk_statute:'#iif(isdefined("attributes.ssk_statute"),"attributes.ssk_statute",DE(""))#',
		duty_type:'#iif(isdefined("attributes.duty_type"),"attributes.duty_type",DE(""))#',
		main_payment_control:'#iif(isdefined("attributes.main_payment_control"),"attributes.main_payment_control",DE(""))#',
		department_level:'#iif(isdefined("attributes.is_dep_level"),"1","0")#',
		expense_center:'#iif(isdefined("attributes.expense_center"),"attributes.expense_center",DE(""))#'
	);
</cfscript>

<!---<cfinclude template="../query/get_dynamic_bordro.cfm">--->
<style type="text/css">.list_settings {position:fixed;}/*Show list hide alan?? i??in OS??*/</style>
<div id="bordro_list_layer">
<cfinclude template="view_dynamic_bordro_groups.cfm">
<cfset day_last = createodbcdatetime(createdate(attributes.SAL_YEAR_END,attributes.SAL_MON_END,daysinmonth(createdate(attributes.sal_year_end,attributes.SAL_MON_END,1))))>
<cfscript>
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
	t_ssk_primi_isveren_6322 = 0;
	t_ssk_primi_isci_6322 = 0;
	t_ssk_primi_isveren_14857 = 0;
	
	
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
	sayac = 0;
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
	t_gelir_vergisi_indirimi_5746_ = 0; //gelir vergisi hesaplanandan dusulmesi icin ayr??ld??
	t_gelir_vergisi_indirimi_4691 = 0;
	t_gelir_vergisi_indirimi_4691_ = 0; //gelir vergisi hesaplanandan dusulmesi icin ayr??ld??
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
</cfscript>

<cfquery name="GET_EXPENSES" datasource="#dsn2#">
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
<cfset main_expense_list = valuelist(GET_EXPENSES.EXPENSE_CODE,';')>
<cfquery name="get_emp_branches" datasource="#DSN#">
	SELECT
		BRANCH_ID
	FROM
		EMPLOYEE_POSITION_BRANCHES
	WHERE
		EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#
</cfquery>
<cfset emp_branch_list = valuelist(get_emp_branches.BRANCH_ID)>
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
		EMPLOYEE_PUANTAJ_ID IN (
								SELECT 
									EMPLOYEE_PUANTAJ_ID 
								FROM 
									EMPLOYEES_PUANTAJ_ROWS EPR,
									EMPLOYEES_PUANTAJ EP,
									BRANCH B 
								WHERE 
									EP.SSK_OFFICE = B.SSK_OFFICE AND 
									EP.SSK_OFFICE_NO = B.SSK_NO AND 
									(
										(EP.SAL_YEAR > #ATTRIBUTES.SAL_YEAR# AND EP.SAL_YEAR < #ATTRIBUTES.SAL_YEAR_END#)
										OR
										(
											EP.SAL_YEAR = #ATTRIBUTES.SAL_YEAR# AND 
											EP.SAL_MON >= #ATTRIBUTES.SAL_MON# AND
											(
												EP.SAL_YEAR < #ATTRIBUTES.SAL_YEAR_END#
												OR
												(EP.SAL_MON <= #ATTRIBUTES.SAL_MON_END# AND EP.SAL_YEAR = #ATTRIBUTES.SAL_YEAR_END#)
											)
										)
										OR
										(
											EP.SAL_YEAR > #ATTRIBUTES.SAL_YEAR# AND 
											(
												EP.SAL_YEAR < #ATTRIBUTES.SAL_YEAR_END#
												OR
												(EP.SAL_MON <= #ATTRIBUTES.SAL_MON_END# AND EP.SAL_YEAR = #ATTRIBUTES.SAL_YEAR_END#)
											)
										)
										OR
										(
											EP.SAL_YEAR = #ATTRIBUTES.SAL_YEAR_END# AND 
											EP.SAL_YEAR = #ATTRIBUTES.SAL_YEAR_END# AND
											EP.SAL_MON >= #ATTRIBUTES.SAL_MON# AND
											EP.SAL_MON <= #ATTRIBUTES.SAL_MON_END#
										)
									) AND 
									EPR.PUANTAJ_ID = EP.PUANTAJ_ID 
									<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
										AND B.BRANCH_ID IN (#attributes.branch_id#)	
									</cfif>
									<cfif not session.ep.ehesap>AND B.BRANCH_ID IN (#emp_branch_list#)</cfif>
								) AND 
		EXT_TYPE = 1 
	ORDER BY 
		COMMENT_PAY
</cfquery>
<cfquery name="get_kesinti_adlar" dbtype="query">
	SELECT DISTINCT COMMENT_PAY FROM get_kesintis WHERE COMMENT_PAY <> 'Avans'
</cfquery>
<cfset kesinti_names = valuelist(get_kesinti_adlar.COMMENT_PAY)>
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
		EMPLOYEE_PUANTAJ_ID IN (
								SELECT 
									EMPLOYEE_PUANTAJ_ID 
								FROM 
									EMPLOYEES_PUANTAJ_ROWS EPR,
									EMPLOYEES_PUANTAJ EP,
									BRANCH B 
								WHERE 
									EP.SSK_OFFICE = B.SSK_OFFICE AND 
									EP.SSK_OFFICE_NO = B.SSK_NO AND 
									(
										(EP.SAL_YEAR > #ATTRIBUTES.SAL_YEAR# AND EP.SAL_YEAR < #ATTRIBUTES.SAL_YEAR_END#)
										OR
										(
											EP.SAL_YEAR = #ATTRIBUTES.SAL_YEAR# AND 
											EP.SAL_MON >= #ATTRIBUTES.SAL_MON# AND
											(
												EP.SAL_YEAR < #ATTRIBUTES.SAL_YEAR_END#
												OR
												(EP.SAL_MON <= #ATTRIBUTES.SAL_MON_END# AND EP.SAL_YEAR = #ATTRIBUTES.SAL_YEAR_END#)
											)
										)
										OR
										(
											EP.SAL_YEAR > #ATTRIBUTES.SAL_YEAR# AND 
											(
												EP.SAL_YEAR < #ATTRIBUTES.SAL_YEAR_END#
												OR
												(EP.SAL_MON <= #ATTRIBUTES.SAL_MON_END# AND EP.SAL_YEAR = #ATTRIBUTES.SAL_YEAR_END#)
											)
										)
										OR
										(
											EP.SAL_YEAR = #ATTRIBUTES.SAL_YEAR_END# AND 
											EP.SAL_YEAR = #ATTRIBUTES.SAL_YEAR_END# AND
											EP.SAL_MON >= #ATTRIBUTES.SAL_MON# AND
											EP.SAL_MON <= #ATTRIBUTES.SAL_MON_END#
										)
									) AND
									EPR.PUANTAJ_ID = EP.PUANTAJ_ID 
									<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
										AND B.BRANCH_ID IN (#attributes.branch_id#)	
									</cfif>
									<cfif not session.ep.ehesap>AND B.BRANCH_ID IN (#emp_branch_list#)</cfif>
								) AND 
		EXT_TYPE = 0 
	ORDER BY 
		COMMENT_PAY
</cfquery>
<cfquery name="get_odenek_adlar" dbtype="query">
	SELECT DISTINCT COMMENT_PAY FROM get_odeneks
</cfquery>
<cfset odenek_names = valuelist(get_odenek_adlar.COMMENT_PAY)>
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
		EMPLOYEES_PUANTAJ_ROWS_EXT.VERGI_ISTISNA_AMOUNT,
		EMPLOYEES_PUANTAJ_ROWS_EXT.VERGI_ISTISNA_TOTAL,
		EMPLOYEES_PUANTAJ_ROWS_EXT.COMMENT_PAY,

		EMPLOYEES_PUANTAJ_ROWS_EXT.EMPLOYEE_PUANTAJ_ID
	FROM 
		EMPLOYEES_PUANTAJ_ROWS_EXT
	WHERE 
		EMPLOYEE_PUANTAJ_ID IN (
								SELECT 
									EMPLOYEE_PUANTAJ_ID 
								FROM 
									EMPLOYEES_PUANTAJ_ROWS EPR,
									EMPLOYEES_PUANTAJ EP,
									BRANCH B 
								WHERE 
									EP.SSK_OFFICE = B.SSK_OFFICE AND 
									EP.SSK_OFFICE_NO = B.SSK_NO AND 
									(
										(EP.SAL_YEAR > #ATTRIBUTES.SAL_YEAR# AND EP.SAL_YEAR < #ATTRIBUTES.SAL_YEAR_END#)
										OR
										(
											EP.SAL_YEAR = #ATTRIBUTES.SAL_YEAR# AND 
											EP.SAL_MON >= #ATTRIBUTES.SAL_MON# AND
											(
												EP.SAL_YEAR < #ATTRIBUTES.SAL_YEAR_END#
												OR
												(EP.SAL_MON <= #ATTRIBUTES.SAL_MON_END# AND EP.SAL_YEAR = #ATTRIBUTES.SAL_YEAR_END#)
											)
										)
										OR
										(
											EP.SAL_YEAR > #ATTRIBUTES.SAL_YEAR# AND 
											(
												EP.SAL_YEAR < #ATTRIBUTES.SAL_YEAR_END#
												OR
												(EP.SAL_MON <= #ATTRIBUTES.SAL_MON_END# AND EP.SAL_YEAR = #ATTRIBUTES.SAL_YEAR_END#)
											)
										)
										OR
										(
											EP.SAL_YEAR = #ATTRIBUTES.SAL_YEAR_END# AND 
											EP.SAL_YEAR = #ATTRIBUTES.SAL_YEAR_END# AND
											EP.SAL_MON >= #ATTRIBUTES.SAL_MON# AND
											EP.SAL_MON <= #ATTRIBUTES.SAL_MON_END#
										)
									) AND
									EPR.PUANTAJ_ID = EP.PUANTAJ_ID 
									<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
										AND B.BRANCH_ID IN (#attributes.branch_id#)	
									</cfif>
									<cfif not session.ep.ehesap>AND B.BRANCH_ID IN (#emp_branch_list#)</cfif>
								) AND 
		EXT_TYPE = 2 
	ORDER BY 
		COMMENT_PAY
</cfquery>

<cfquery name="get_vergi_istisna_adlar" dbtype="query">
	SELECT DISTINCT COMMENT_PAY FROM get_vergi_istisna
</cfquery>
<cfset vergi_istisna_names = valuelist(get_vergi_istisna_adlar.COMMENT_PAY)>
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
</cfquery>
<cfset def_list = listsort(listdeleteduplicates(valuelist(get_definition.PAYROLL_ID,',')),'numeric','ASC',',')>
<cfquery name="get_bank_" datasource="#dsn#">
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
<cfif isdefined("attributes.sort_type") and len(attributes.sort_type)>
	<cfset type_ = "type">
<cfelse>
	<cfset type_ = "employee_puantaj_id">
</cfif>
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
<cfset attributes.b_obj_hidden_new  = listdeleteduplicates(attributes.b_obj_hidden_new)>
<cfparam name="attributes.totalrecords" default="#get_puantaj_rows.recordcount#">
<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
<cfinclude template="../query/get_branch.cfm"> 
<cfquery name="get_comp_id" dbtype="query">
	SELECT COMPANY_ID FROM GET_BRANCH
</cfquery>
</cfif>
<table style="width:100%; border-collapse:collapse; border-color:000000;" border="1" height="99%">
	<cfset cols_ = listlen(attributes.b_obj_hidden)>
	<cfset cols_ = cols_ + 4>
    <cfset pageCount = 1>
<cfoutput query="get_puantaj_rows" group="#type_#">
	<cfset cols_plus = 0>
	<cfif currentrow eq 1 or (currentrow mod x_page_row) eq 1><!--- sayfada ka?? sat??r bilgi bast??r??lacak ise o belirtiliyor--->
    <cfif currentrow neq 1>
    	<cfset pageCount = pageCount + 1>
    <tr>
        <td colspan="#cols_#"><div style="page-break-after: always"></div></td>
    </tr>
    </cfif>
    <tr>
		<td colspan="#cols_#">
            <cfif isdefined('attributes.branch_id') and listlen(attributes.branch_id) eq 1 or (isdefined("get_comp_id.comp_id") and listlen(valuelist(get_comp_id.comp_id,',')) and listlen(valuelist(get_comp_id.comp_id,',')) eq 1)>
                <table style="float:left;" width="100%">
                    <cfoutput>
                    	<tr>
                            <td colspan="2"><cf_get_lang dictionary_id="53236.??cret Bordrosu"></td>
                        </tr>
                        <tr>
                            <td class="txtbold"><cf_get_lang dictionary_id='53266.Puantaj Listesi'></td>
                            <td>: #listgetat(ay_list(),attributes.sal_mon,',')# - #attributes.sal_year# <cfif isdefined("attributes.sal_year_end") and not (attributes.sal_mon eq attributes.sal_mon_end and attributes.sal_year eq attributes.sal_year_end)>#listgetat(ay_list(),attributes.sal_mon_end,',')# - #attributes.sal_year_end#</cfif></td>
                        </tr>
                        <cfif isdefined("get_comp_id.COMPANY_ID") and listlen(valuelist(get_comp_id.COMPANY_ID,',')) and listlen(valuelist(get_comp_id.COMPANY_ID,',')) eq 1>
                            <tr>
                                <td  class="txtbold"width="125"><cf_get_lang dictionary_id='57571.??nvan'></td>
                                <td>: #GET_BRANCH.COMPANY_NAME#</td>
                            </tr>
                            <tr>
                                <td class="txtbold"><cf_get_lang dictionary_id='58723.Adres'></td>
                                <td>: #GET_BRANCH.ADDRESS#</td>
                            </tr>
                        </cfif>
                        <cfif listlen(attributes.branch_id) eq 1>
                            <tr>
                                <td class="txtbold"><cf_get_lang dictionary_id='53591.SSK Ofis'> / <cf_get_lang dictionary_id='57487.No'></td>
                                <td>: #GET_BRANCH.SSK_OFFICE# - #GET_BRANCH.SSK_M# #GET_BRANCH.SSK_JOB# #GET_BRANCH.SSK_BRANCH# #GET_BRANCH.SSK_BRANCH_OLD# #GET_BRANCH.SSK_NO# #GET_BRANCH.SSK_CITY# #GET_BRANCH.SSK_COUNTRY# #GET_BRANCH.SSK_CD#</td>
                            </tr>
                            <tr>
                                <td class="txtbold"><cf_get_lang dictionary_id='58762.Vergi Dairesi'> / <cf_get_lang dictionary_id='57487.No'></td>
                                <td> 
                                    <cfif len(GET_BRANCH.BRANCH_TAX_NO)>
                                        : #GET_BRANCH.BRANCH_TAX_OFFICE# / #GET_BRANCH.BRANCH_TAX_NO#
                                    <cfelseif len(GET_BRANCH.TAX_NO)>
                                        : #GET_BRANCH.TAX_OFFICE# / #GET_BRANCH.TAX_NO#
                                    </cfif>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cfif len(get_branch.mersis_no)><cf_get_lang dictionary_id="43035.Mersis No">: #get_branch.mersis_no#<cfelse><cf_get_lang dictionary_id='53495.Ticaret Sicil No'>: #GET_BRANCH.T_NO#</cfif>
                                </td>
                            </tr>
                       	<cfelseif isdefined("get_comp_id.COMPANY_ID") and listlen(valuelist(get_comp_id.COMPANY_ID,',')) and listlen(valuelist(get_comp_id.COMPANY_ID,',')) eq 1>
                        	<tr>
                                <td class="txtbold"><cfif len(get_branch.mersis_no)><cf_get_lang dictionary_id="43035.Mersis No"><cfelse><cf_get_lang dictionary_id='53495.Ticaret Sicil No'></cfif></td>
                                <td>: <cfif len(get_branch.mersis_no)>#get_branch.mersis_no#<cfelse>#GET_BRANCH.T_NO#</cfif></td>
                            </tr>
                        </cfif>
                        <tr>
                        	<td colspan="2" style="text-align:right;"><cf_get_lang dictionary_id="57581.Sayfa">: #pageCount#</td>
                        </tr>
                    </cfoutput>
                </table>
            </cfif>
		</td>
	</tr>
		<tr class="txtbold" align="left"> 
			<cfloop list="#attributes.b_obj_hidden_new#" index="xlr">
                    <cfswitch expression="#xlr#">
                        <cfcase value="b_baslik"><th></th></cfcase>
                        <cfcase value="b_sira_no"><th class="txtbold"><cf_get_lang dictionary_id="53109.S??ra No"></th></cfcase>
                        <cfcase value="b_mon_info"><th class="txtbold"><cf_get_lang dictionary_id="58650.Puantaj"> <cf_get_lang dictionary_id="58724.Ay"></th></cfcase>
                        <cfcase value="b_year_info"><th class="txtbold"><cf_get_lang dictionary_id="58650.Puantaj"> <cf_get_lang dictionary_id="58455.Y??l"></th></cfcase>
                        <cfcase value="b_sgk_no"><th class="txtbold"><cf_get_lang dictionary_id ='53237.SSK No'></th></cfcase>
                        <cfcase value="b_ad_soyad"><th nowrap class="txtbold"><cf_get_lang dictionary_id ='57570.Ad?? Soyad??'></th></cfcase>
                        <cfcase value="b_tc_kimlik"><th class="txtbold"><cf_get_lang dictionary_id ='58025.TC Kimlik No'></th></cfcase>
                        <cfcase value="b_employee_no"><th class="txtbold"><cf_get_lang dictionary_id ='58487.Calisan No'></th></cfcase>
                        <cfcase value="b_statu"><th nowrap class="txtbold"><cf_get_lang dictionary_id ='57894.Stat??'></th></cfcase>
                        <cfcase value="b_sex"><th nowrap class="txtbold"><cf_get_lang dictionary_id ='57764.Cinsiyet'></th></cfcase>
                        <cfcase value="b_ilgili_sirket"><th nowrap class="txtbold"><cf_get_lang dictionary_id ='53701.??lgili ??irket'></th></cfcase>
                        <cfcase value="b_sube"><th nowrap class="txtbold"><cf_get_lang dictionary_id ='57453.??ube'></th></cfcase>
                        <cfcase value="b_departman">
                            <cfif isdefined('attributes.is_dep_level')>
                                <cfoutput query="get_dep_lvl">
                                    <th nowrap class="txtbold"><cf_get_lang dictionary_id='57572.Departman'>(#level_no#)</th>
                                </cfoutput>
                            </cfif>
                            <th nowrap class="txtbold"><cf_get_lang dictionary_id ='57572.Departman'></th>
                        </cfcase>
                        <cfcase value="b_pozisyon_sube"><th nowrap class="txtbold"><cf_get_lang dictionary_id ='53729.Pozisyon ??ube'></th></cfcase>
                        <cfcase value="b_pozisyon_departman"><th nowrap class="txtbold"><cf_get_lang dictionary_id ='53728.Pozisyon Departman'></th></cfcase>
                        <cfcase value="b_ise_giris"><th nowrap class="txtbold"><cf_get_lang dictionary_id ='53702.????e Giri?? '></th></cfcase>
                        <cfcase value="b_isten_cikis"><th nowrap class="txtbold"><cf_get_lang dictionary_id ='29832.????ten ????k????'></th></cfcase>
                        <cfcase value="b_gruba_giris"><th nowrap class="txtbold"><cf_get_lang dictionary_id ='53704.Gruba Giri??i'></th></cfcase>
                        <cfcase value="b_kidem_date"><th nowrap class="txtbold"><cf_get_lang dictionary_id ='53641.K??dem Baz Tarihi'></th></cfcase>
                        <cfcase value="b_imza"><th width="200" class="txtbold"><cf_get_lang dictionary_id='58957.??mza'></th></cfcase>
                        <cfcase value="b_ozel_kod">
                            <th nowrap class="txtbold"><cf_get_lang dictionary_id ='57789.??zel Kod'></th>
                            <th nowrap class="txtbold"><cf_get_lang dictionary_id ='57789.??zel Kod'>1</th>
                            <th nowrap class="txtbold"><cf_get_lang dictionary_id ='57789.??zel Kod'>2</th>
                            <cfif fusebox.dynamic_hierarchy><th nowrap class="txtbold"><cf_get_lang dictionary_id='54354.Dinamik Hiyerar??i'></th></cfif>
                        </cfcase>
                        <cfcase value="b_unvan"><th nowrap class="txtbold"><cf_get_lang dictionary_id ='57571.??nvan'></th></cfcase>
                        <cfcase value="b_pozisyon_tipi"><th nowrap class="txtbold"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th></cfcase>
                        <cfcase value="b_collar_type"><th nowrap class="txtbold"><cf_get_lang dictionary_id='54054.Yaka Tipi'></th></cfcase>
                        <cfcase value="b_grade_step"><th class="txtbold"><cf_get_lang dictionary_id="54179.Derece"> - <cf_get_lang dictionary_id="58710.Kademe"></th></cfcase>
                        <cfcase value="b_pozisyon"><th nowrap class="txtbold"><cf_get_lang dictionary_id ='53164.Pozisyon'></th></cfcase>
                        <cfcase value="b_org_step"><th class="txtbold"><cf_get_lang dictionary_id ='58710.Kademe'></th></cfcase>
                        <cfcase value="b_duty_type"><th class="txtbold"><cf_get_lang dictionary_id ='58538.G??rev Tipi'></th></cfcase>
                        <cfcase value="b_ucret_yontemi"><th class="txtbold"><cf_get_lang dictionary_id ='53714.??cret Y??ntemi'></th></cfcase>
                        <cfcase value="b_kg"><th class="txtbold"><cf_get_lang dictionary_id ='53804.KG'></th></cfcase>
                        <cfcase value="b_ks"><th class="txtbold"><cf_get_lang no ='1410.KS'></th></cfcase>
                        <cfcase value="b_net_brut"><th class="txtbold"><cf_get_lang dictionary_id="58083.Net"> / <cf_get_lang dictionary_id="41440.Br??t"></th></cfcase>
                        <cfcase value="b_maas"><th class="txtbold"><cf_get_lang dictionary_id="53127.??cret"></th></cfcase>
                        <cfcase value="b_ss_gunu"><th class="txtbold"><cf_get_lang dictionary_id ='53715.SS G??n??'></th></cfcase>
                        <cfcase value="b_hs_gunu"><th class="txtbold"><cf_get_lang dictionary_id ='53716.HS G??n??'></th></cfcase>
                        <cfcase value="b_genel_tatil_gunu"><th class="txtbold"><cf_get_lang dictionary_id ='53706.Genel Tatil G??n??'></th></cfcase>
                        <cfcase value="b_ucretli_izin"><th class="txtbold"><cf_get_lang dictionary_id ='53686.??cretli ??zin'></th></cfcase>
                        <cfcase value="b_ucretli_izin_pazar"><th class="txtbold"><cf_get_lang dictionary_id ='53687.??cretli ??zin Pazar'></th></cfcase>
                        <cfcase value="b_ucretsiz_izin"><th class="txtbold"><cf_get_lang dictionary_id ='53688.??cretsiz ??zin'></th></cfcase>
                        <cfcase value="b_toplam_gun"><th class="txtbold"><cf_get_lang dictionary_id="53745.Toplam G??n"></th></cfcase>
                        <cfcase value="b_toplam_calisma_gunu"><th class="txtbold"><cf_get_lang dictionary_id ='53727.??al????ma G??n??'></th></cfcase>
                        <cfcase value="b_ssk_gunu"><th class="txtbold"><cf_get_lang dictionary_id='53741.SGK G??n?? Toplam??'> </th></cfcase>
                        <cfcase value="b_idari_amir"><th class="txtbold"><cf_get_lang dictionary_id="53705.Birinci Amir"></th></cfcase>
                        <cfcase value="b_exp"><th class="txtbold"><cf_get_lang dictionary_id="53882.????ten ????k???? Nedeni"></th></cfcase>
                        <cfcase value="b_reason"><th class="txtbold"><cf_get_lang dictionary_id="53643.??irket ????i Gerek??e"></th></cfcase>
                        <cfcase value="b_ex_in_out_id"><th class="txtbold"><cf_get_lang dictionary_id="57554.Giri??"> <cf_get_lang dictionary_id="52990.Gerek??e"></th></cfcase>
                        <cfcase value="b_fonksiyonel_amir"><th class="txtbold"><cf_get_lang dictionary_id="53713.??kinci Amir"></th></cfcase>
                        <cfcase value="b_business_code">
                            <th class="txtbold"><cf_get_lang dictionary_id="30495.Meslek Kodu"> <cf_get_lang dictionary_id="32646.Kodu"></th>
                            <th class="txtbold"><cf_get_lang dictionary_id='53861.Meslek Grubu'></th>
                        </cfcase>
                        <cfcase value="b_hi_saat">
                            <th class="txtbold"><cf_get_lang dictionary_id ='53715.SS G??n??'> (<cf_get_lang dictionary_id="57491.Saat">)</th>
                            <th class="txtbold"><cf_get_lang dictionary_id ='53716.HS G??n??'> (<cf_get_lang dictionary_id="57491.Saat">)</th>
                            <th class="txtbold"><cf_get_lang dictionary_id ='53706.Genel Tatil G??n??'> (<cf_get_lang dictionary_id="57491.Saat">)</th>
                            <th class="txtbold"><cf_get_lang dictionary_id ='53686.??cretli ??zin'> (<cf_get_lang dictionary_id="57491.Saat">)</th>
                            <th class="txtbold"><cf_get_lang dictionary_id ='53687.??cretli ??zin Pazar'> (<cf_get_lang dictionary_id="57491.Saat">)</th>
                            <th class="txtbold"><cf_get_lang dictionary_id ='53688.??cretsiz ??zin'> (<cf_get_lang dictionary_id="57491.Saat">)</th>
                            <th class="txtbold"><cf_get_lang dictionary_id ="57492.Toplam"> <cf_get_lang dictionary_id="57491.Saat"></th>
                        </cfcase>
                        <cfcase value="b_hafta_ici_mesai"><th class="txtbold"><cf_get_lang dictionary_id ='53744.Hafta ????i Mesai'></th></cfcase>
                        <cfcase value="b_hafta_sonu_mesai"><th class="txtbold"><cf_get_lang dictionary_id ='53743.Hafta Sonu Mesai'></th></cfcase>
                        <cfcase value="b_resmi_tatil_mesai"><th class="txtbold"><cf_get_lang dictionary_id ='53742.Resmi Tatil Mesai'></th></cfcase>
                        <cfcase value="b_gece_mesai_saat"><th class="txtbold"><cf_get_lang dictionary_id='54329.Gece Mesaisi'></th></cfcase>
                        <cfcase value="b_aylik_mesaisiz"><th class="txtbold"><cf_get_lang dictionary_id ='53717.Ayl??k Mesaisiz'></th></cfcase>
                        <cfcase value="b_fazla_mesai"><th class="txtbold"><cf_get_lang dictionary_id ='53718.Fazla Mesai Tutar??'></th></cfcase>
                        <cfcase value="b_fazla_mesai_net"><th class="txtbold"><cf_get_lang dictionary_id ='53718.Fazla Mesai'><cf_get_lang dictionary_id="58083.Net"></th></cfcase>
                        <cfcase value="b_gunluk_ucret"><th class="txtbold"><cf_get_lang dictionary_id ='53242.G??nl??k ??cret'></th></cfcase>
                        <cfcase value="b_aylik_ucret"><th class="txtbold"><cf_get_lang dictionary_id ='53243.Ayl??k ??cret'></th></cfcase>
                        <cfcase value="b_aylik_brut_ucret"><th class="txtbold"><cf_get_lang dictionary_id="47803.Ayl??k Br??t ??cret"></th></cfcase>
                        <cfcase value="b_ek_odenek"><th class="txtbold"><cf_get_lang dictionary_id ='53082.Ek ??denek'></th></cfcase>
                        <cfcase value="b_toplam_kazanc"><th class="txtbold"><cf_get_lang dictionary_id ='53244.Toplam Kazan??'></th></cfcase>
                        <cfcase value="b_sgk_matrahi"><th class="txtbold"><cf_get_lang dictionary_id ='53245.SSK Matrah??'></th></cfcase>
                        <cfcase value="b_sgk_isci_hissesi">
                            <th class="txtbold"><cf_get_lang dictionary_id ='53719.SSK ??????i Primi'></th>
                            <th class="txtbold"><cf_get_lang dictionary_id="47802.SGDP ??????i Hissesi"></th>
                         </cfcase>
                        <cfcase value="b_issizlik_isci_hissesi"><th class="txtbold"><cf_get_lang dictionary_id="54330.????sizlik Sigortas?? ??????i Primi"></th> </cfcase>
    
                        <cfcase value="b_gelir_vergisi_indirimi"><th class="txtbold"><cf_get_lang dictionary_id ='53248.Gelir Vergisi ??ndirimi'></th></cfcase>
                        <cfcase value="b_gelir_vergisi_matrahi"><th class="txtbold"><cf_get_lang dictionary_id ='53249.Gelir Vergisi Matrah??'></th></cfcase>
                        <cfcase value="b_gelir_vergisi_hesaplanan"><th class="txtbold"><cf_get_lang dictionary_id ='53689.Gelir Vergisi Hesaplanan'></th></cfcase>
                        <cfcase value="b_asgari_gecim_indirimi"><th class="txtbold"><cf_get_lang dictionary_id ='53659.Asgari Ge??im ??ndirimi'></th></cfcase>
                        <cfcase value="b_gelir_vergisi_indirimi_5746"><th class="txtbold"><cf_get_lang dictionary_id ='53250.Gelir Vergisi'> <cf_get_lang dictionary_id="54268.??ndirimi"> 5746</th></cfcase>
                        <cfcase value="b_gelir_vergisi_indirimi_4691"><th class="txtbold"><cf_get_lang dictionary_id ='53250.Gelir Vergisi'> <cf_get_lang dictionary_id="54268.??ndirimi"> 4691</th></cfcase>
                        <cfcase value="b_gelir_vergisi"><th class="txtbold"><cf_get_lang dictionary_id ='53250.Gelir Vergisi'></th></cfcase>
                        <cfcase value="b_vergi_indirimi_5615"><th class="txtbold"><cf_get_lang dictionary_id ='53690.Vergi ??ndirimi '> <cfif (attributes.sal_year eq 2007 and attributes.sal_mon gt 6) or attributes.sal_year gte 2008>5615<cfelse>5084</cfif></th></cfcase>
                        <cfcase value="b_kum_gelir_vergisi_matrahi"><th class="txtbold"><cf_get_lang dictionary_id ='53251.K??m Gel Ver Matrah'></th></cfcase>
                        <cfcase value="b_damga_vergisi"><th class="txtbold"><cf_get_lang dictionary_id ='53252.Damga Vergisi'></th></cfcase>
                        <cfcase value="b_damga_vergisi_matrah"><th class="txtbold"><cf_get_lang dictionary_id="59363.Damga Vergisi Matrah??"></th></cfcase>
                        <cfcase value="b_toplam_yasal_kesinti"><th class="txtbold"><cf_get_lang dictionary_id ='53722.Toplam Yasal Kesinti'></th></cfcase>
                        <cfcase value="b_onceki_aydan_devreden_kum_mat"><th class="txtbold"><cf_get_lang dictionary_id='54297.??nceki Aydan Dev K??m Matrah'></th></cfcase>
                        <cfcase value="b_sgk_devir_isci_hissesi_fark"><th class="txtbold"><cf_get_lang dictionary_id="54300.SGK Devir Isci Hissesi Fark"></th></cfcase>
                        <cfcase value="b_sgk_devir_issizlik_hissesi_fark"><th class="txtbold"><cf_get_lang dictionary_id="54301.SGK Devir Isci Hissesi Fark"></th></cfcase>
                        <cfcase value="b_sgdp_isci_primi_fark"><th class="txtbold"><cf_get_lang dictionary_id="54302.SGDP ??????i Primi Fark"></th></cfcase>
                        <cfcase value="b_muhtelif_kesintiler"><th class="txtbold"><cf_get_lang dictionary_id ='53254.Muhtelif Kesintiler'></th></cfcase>
                        <cfcase value="b_net_ucret"><th class="txtbold"><cf_get_lang dictionary_id ='53255.Net ??cret'></th></cfcase>
                        <cfcase value="b_toplam_net_odenecek"><th class="txtbold"><cf_get_lang dictionary_id ='53691.Toplam Net ??denecek'></th></cfcase>
                        <cfcase value="b_sgk_isveren_primi_hesaplanan">
                            <th class="txtbold"><cf_get_lang dictionary_id='53698.SGK ????veren Primi Hesaplanan'></th>
                            <th class="txtbold"><cf_get_lang dictionary_id="59364.SGDP ????veren Primi Hesaplanan"></th>
                        </cfcase>
                        <cfcase value="b_muhasebe_kod_group"><th class="txtbold"><cf_get_lang dictionary_id='54117.Muhasebe Kod Grubu'></th></cfcase>
                        <cfcase value="b_sgk_5084"><th class="txtbold"><cf_get_lang dictionary_id="54331.SGK ????v Primi"> 5084 <cf_get_lang dictionary_id="54268.??ndirimi"></th></cfcase>
                        <cfcase value="b_sgk_5763"><th class="txtbold"><cf_get_lang dictionary_id="54331.SGK ????v Primi"> 5763 <cf_get_lang dictionary_id="54268.??ndirimi"></th></cfcase>
                        <cfcase value="b_sgk_5510"><th class="txtbold"><cf_get_lang dictionary_id="54331.SGK ????v Primi"> 5510 <cf_get_lang dictionary_id="54268.??ndirimi"></th></cfcase>
                        <cfcase value="b_sgk_5921"><th class="txtbold"><cf_get_lang dictionary_id="54331.SGK ????v Primi"> 5921 <cf_get_lang dictionary_id="54268.??ndirimi"></th></cfcase>
                        <cfcase value="b_sgk_5746"><th class="txtbold"><cf_get_lang dictionary_id="54331.SGK ????v Primi"> 5746 <cf_get_lang dictionary_id="54268.??ndirimi"></th></cfcase>
                        <cfcase value="b_sgk_4691"><th class="txtbold"><cf_get_lang dictionary_id="54331.SGK ????v Primi"> 4691 <cf_get_lang dictionary_id="54268.??ndirimi"></th></cfcase>
                        <cfcase value="b_sgk_6111"><th class="txtbold"><cf_get_lang dictionary_id="54331.SGK ????v Primi"> 6111 <cf_get_lang dictionary_id="54268.??ndirimi"></th></cfcase>
                        <cfcase value="b_sgk_6486"><th class="txtbold"><cf_get_lang dictionary_id="54331.SGK ????v Primi"> 6486 <cf_get_lang dictionary_id="54268.??ndirimi"></th></cfcase>
                        <cfcase value="b_sgk_6322"><th class="txtbold"><cf_get_lang dictionary_id="54331.SGK ????v Primi"> 6322 <cf_get_lang dictionary_id="54268.??ndirimi"></th></cfcase>
                        <cfcase value="b_sgk_14857"><th class="txtbold"><cf_get_lang dictionary_id="54331.SGK ????v Primi"> 14857 <cf_get_lang dictionary_id="54268.??ndirimi"></th></cfcase>
                        
                        
                        <cfcase value="b_sgk_isci_687"><th class="txtbold"><cf_get_lang dictionary_id="59368.SGK ??????i Primi ??ndirimi"> 687</th></cfcase>
                        <cfcase value="b_issizlik_isci_687"><th class="txtbold"><cf_get_lang dictionary_id="59369.??ssizlik ??????i Primi ??ndirimi"> 687</th></cfcase>
                        <cfcase value="b_gelir_verigisi_687"><th class="txtbold"><cf_get_lang dictionary_id="53248.Gelir Vergisi ??ndirimi"> 687</th></cfcase>
                        <cfcase value="b_damga_vergisi_687"><th class="txtbold"><cf_get_lang dictionary_id="59370.Damga Vergisi ??ndirimi"> 687</th></cfcase>
                        <cfcase value="b_sgk_isveren_687"><th class="txtbold"><cf_get_lang dictionary_id="59371.SGK ????veren ??ndirimi"> 687</th></cfcase>
                        <cfcase value="b_issizlik_isveren_687"><th class="txtbold"><cf_get_lang dictionary_id="59372.????sizlik ????veren ??ndirimi"> 687</th></cfcase>
                        
                        <cfcase value="b_sgk_isci_7103"><th class="txtbold"><cf_get_lang dictionary_id="59368.SGK ??????i Primi ??ndirimi"> 7103</th></cfcase>
                        <cfcase value="b_issizlik_isci_7103"><th class="txtbold"><cf_get_lang dictionary_id="59369.??ssizlik ??????i Primi ??ndirimi"> 7103</th></cfcase>
                        <cfcase value="b_gelir_verigisi_7103"><th class="txtbold"><cf_get_lang dictionary_id="53248.Gelir Vergisi ??ndirimi"> 7103</th></cfcase>
                        <cfcase value="b_damga_vergisi_7103"><th class="txtbold"><cf_get_lang dictionary_id="59370.Damga Vergisi ??ndirimi"> 7103</th></cfcase>
                        <cfcase value="b_sgk_isveren_7103"><th class="txtbold"><cf_get_lang dictionary_id="59371.SGK ????veren ??ndirimi"> 7103</th></cfcase>
                        <cfcase value="b_issizlik_isveren_7103"><th class="txtbold"><cf_get_lang dictionary_id="59372.????sizlik ????veren ??ndirimi"> 7103</th></cfcase>
                        
                        <cfcase value="b_sgk_isveren_hissesi">
                            <th class="txtbold"><cf_get_lang dictionary_id='53256.SGK ????veren Primi'></th>
                            <th class="txtbold"><cf_get_lang dictionary_id='54311.SGDP ????veren Primi'></th>
                        </cfcase>
                        <cfcase value="b_toplam_sgk_prim"><th class="txtbold"><cf_get_lang dictionary_id="59373.SGK Primi"></th></cfcase>
                        <cfcase value="b_bes_isci_hissesi"><th class="txtbold"><cf_get_lang dictionary_id="59374.BES Kat??l??m Pay??"></th></cfcase>
                        <cfcase value="b_issizlik_isveren_hissesi"><th class="txtbold"><cf_get_lang dictionary_id ='53257.????sizlik Sigortas?? ????veren Primi'></th></cfcase>
                        <cfcase value="b_yillik_izin_tutari"><th class="txtbold"><cf_get_lang dictionary_id ='53393.Y??ll??k ??zin Tutar??'></th></cfcase>
                        <cfcase value="b_kidem_tazminati"><th class="txtbold"><cf_get_lang dictionary_id="52991.K??dem Tazminat??"></th></cfcase>
                        <cfcase value="b_ihbar_tazminati"><th class="txtbold"><cf_get_lang dictionary_id="52992.??hbar Tazminat??"></th></cfcase>
                        <cfcase value="b_toplam_isveren_maliyeti"><th class="txtbold"><cf_get_lang dictionary_id ='53708.Toplam ????veren Maliyeti'></th></cfcase>
                        <cfcase value="b_toplam_isveren_maliyeti_indirimsiz"><th class="txtbold"><cf_get_lang dictionary_id ='54320.Toplam ????veren Maliyeti ??ndirimsiz'> </th></cfcase>
                        <cfcase value="b_ucret_tipi"><th class="txtbold"><cf_get_lang dictionary_id ='53238.??cret Tipi'></th></cfcase>
                        <cfcase value="b_odeme_metodu"><th class="txtbold"><cf_get_lang dictionary_id ='53557.??deme Metodu'></th></cfcase>
                        <cfcase value="b_fonksiyon"><th class="txtbold"><cf_get_lang dictionary_id='58701.Fonksiyon'></th></cfcase>
                        <cfcase value="b_vergi_istisna_toplam"><th class="txtbold"><cf_get_lang dictionary_id="53017.Vergi ??stisnas??"> <cf_get_lang dictionary_id="57492.Toplam"></th></cfcase>
                        <cfcase value="b_vergi_istisna_sgk"><th class="txtbold"><cf_get_lang dictionary_id="53017.Vergi ??stisnas??"> <cf_get_lang dictionary_id="58714.SGK"></th></cfcase>
                        <cfcase value="b_vergi_istisna_sgk_net"><th class="txtbold"><cf_get_lang dictionary_id="53017.Vergi ??stisnas??"> <cf_get_lang dictionary_id="58714.SGK"> <cf_get_lang dictionary_id="58083.Net"></th></cfcase>
                        <cfcase value="b_vergi_istisna_vergi"><th class="txtbold"><cf_get_lang dictionary_id="53017.Vergi ??stisnas??"> <cf_get_lang dictionary_id="53332.Vergi"> </th></cfcase>
                        <cfcase value="b_vergi_istisna_vergi_net"><th class="txtbold"><cf_get_lang dictionary_id="53017.Vergi ??stisnas??"> <cf_get_lang dictionary_id="53332.Vergi"> <cf_get_lang dictionary_id="58083.Net"></th></cfcase>
                        <cfcase value="b_vergi_istisna_damga"><th class="txtbold"><cf_get_lang dictionary_id="53017.Vergi ??stisnas??"> <cf_get_lang dictionary_id="54121.Damga"></th></cfcase>
                        <cfcase value="b_vergi_istisna_damga_net"><th class="txtbold"><cf_get_lang dictionary_id="53017.Vergi ??stisnas??"> <cf_get_lang dictionary_id="54121.Damga"> <cf_get_lang dictionary_id="58083.Net"></th></cfcase>
                        <cfcase value="b_ek_odenekler">
                        <cfloop list="#odenek_names#" index="cca">
                            <th class="txtbold"><cfoutput>#cca#</cfoutput></th>
                            <cfif x_payment_type eq 1>
                                <th class="txtbold"><cfoutput>#cca#</cfoutput> <cf_get_lang dictionary_id="29981.Tan??mlanan"></th>
                            </cfif>
                        </cfloop>
                        </cfcase>
                        <cfcase value="b_kesintiler">
                            <th class="txtbold">Avans</th>
                            <cfloop list="#kesinti_names#" index="cca">
                                <th class="txtbold"><cfoutput>#cca#</cfoutput></th>
                            </cfloop>
                        </cfcase>
                        <cfcase value="b_vergi_istisna">
                            <cfloop list="#vergi_istisna_names#" index="cca">
                                <th class="txtbold"><cfoutput>#cca#</cfoutput></th>
                                <th class="txtbold"><cfoutput>#cca#</cfoutput> <cf_get_lang dictionary_id="58083.Net"></th>
                            </cfloop>
                        </cfcase>
                        <cfcase value="b_masraf_merkezi"><th class="txtbold"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th></cfcase>
                        <cfcase value="b_masraf_merkezi_kodu"><th class="txtbold"><cf_get_lang dictionary_id ='53747.Masraf Merkezi Kodu'></th></cfcase>
                        <cfcase value="b_muhasebe_kodu"><th class="txtbold"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></th></cfcase>
                        <cfcase value="b_banka"><th class="txtbold"><cf_get_lang dictionary_id="30349.Banka Ad??"></th></cfcase>
                        <cfcase value="b_hesap_no"><th class="txtbold"><cf_get_lang dictionary_id="58178.Hesap No"></th></cfcase>
                        <cfcase value="b_iban_no"><th class="txtbold"><cf_get_lang dictionary_id="54332.IBAN No"></th></cfcase>
                        <cfcase value="b_toplam_devreden_sgk_matrahi"><th class="txtbold"><cf_get_lang dictionary_id="54333.Toplam Devreden SGK Matrah??"></th></cfcase>
                        <cfcase value="b_2_onceki_aydan_devreden_sgk_matrahi"><th class="txtbold"><cf_get_lang dictionary_id="54334.??ki ??nceki Aydan Devreden SGK Matrah??"></th></cfcase>
                        <cfcase value="b_1_onceki_aydan_devreden_sgk_matrahi"><th class="txtbold"><cf_get_lang dictionary_id="54335.Bir ??nceki Aydan Devreden SGK Matrah??"></th></cfcase>
                        <cfcase value="b_buaydan_devreden_sgk_matrahi"><th class="txtbold"><cf_get_lang dictionary_id="59375.Bu Aydan Devreden SGK Matrah??"></th></cfcase>
                        <cfcase value="b_kesinti_ve_agi_oncesi_net"><th class="txtbold"><cf_get_lang dictionary_id="54310.Kesinti ve AG?? ??ncesi Net"></th></cfcase>
                    </cfswitch>
                </cfloop>
		</tr>
    </cfif>
		<cfoutput>
			<cfset attributes.employee_id = get_puantaj_rows.EMPLOYEE_ID>
			<cfquery name="get_this_istisna" dbtype="query">
				SELECT SUM(VERGI_ISTISNA_AMOUNT) AS VERGI_ISTISNA_AMOUNT FROM get_vergi_istisna WHERE EMPLOYEE_PUANTAJ_ID = #EMPLOYEE_PUANTAJ_ID# AND VERGI_ISTISNA_AMOUNT IS NOT NULL
			</cfquery>
			<cfscript>
				if (get_this_istisna.recordcount)
					t_istisna_odenek = get_this_istisna.vergi_istisna_amount;
				maas_ = evaluate("get_puantaj_rows.M#get_puantaj_rows.row_sal_mon#");
			
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
				d_t_izin = d_t_izin + izin;
				gt_izin_saat = gt_izin_saat + izin_count;	
				dt_izin_saat = dt_izin_saat + izin_count;							
				onceki_donem_kum_gelir_vergisi_matrahi = KUMULATIF_GELIR_MATRAH - gelir_vergisi_matrah;
				if(onceki_donem_kum_gelir_vergisi_matrahi lt 0)
					onceki_donem_kum_gelir_vergisi_matrahi = 0;
		
				//t_toplam_kazanc = t_toplam_kazanc + total_salary+VERGI_ISTISNA_AMOUNT;
				//t_toplam_kazanc = t_toplam_kazanc + TOTAL_SALARY -VERGI_ISTISNA_SSK;
				t_toplam_kazanc = t_toplam_kazanc + (total_salary-VERGI_ISTISNA_SSK-VERGI_ISTISNA_VERGI+VERGI_ISTISNA_AMOUNT_);
				t_vergi_indirimi = t_vergi_indirimi + vergi_indirimi;
				t_sakatlik_indirimi = t_sakatlik_indirimi + sakatlik_indirimi;
				t_kum_gelir_vergisi_matrahi =  t_kum_gelir_vergisi_matrahi + KUMULATIF_GELIR_MATRAH ;
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
				if(is_5746_control eq 0) //arge indiriminin gelir vergisinden d??????lmemesi ile ilgili toplam icmal icin eklendi //SG 20140306
				{                
					t_gelir_vergisi_indirimi_5746_ = t_gelir_vergisi_indirimi_5746_ + gelir_vergisi_indirimi_5746;
				}
				t_gelir_vergisi_indirimi_4691 = t_gelir_vergisi_indirimi_4691 + gelir_vergisi_indirimi_4691;
				if(is_4691_control eq 0) //arge indiriminin gelir vergisinden d??????lmemesi ile ilgili toplam icmal icin eklendi
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
				if(is_5746_control eq 0) //arge indiriminin gelir vergisinden d??????lmemesi ile ilgili toplam icmal icin eklendi //SG 20140306
				{
					d_t_gelir_vergisi_indirimi_5746_ = d_t_gelir_vergisi_indirimi_5746_ + gelir_vergisi_indirimi_5746;
				}
				d_t_gelir_vergisi_indirimi_4691 = d_t_gelir_vergisi_indirimi_4691 + gelir_vergisi_indirimi_4691;
				if(is_4691_control eq 0) //arge indiriminin gelir vergisinden d??????lmemesi ile ilgili toplam icmal icin eklendi
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
						t_ssk_primi_isci = t_ssk_primi_isci + ssk_isci_hissesi - ssk_isci_hissesi_687- ssk_isci_hissesi_7103;
		
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
					
					isveren_hesaplanan = ssk_isveren_hissesi + ssk_isveren_hissesi_5510 + ssk_isveren_hissesi_5084;
					if(ssk_isci_hissesi eq 0)t_ssk_primi_isveren_hesaplanan = t_ssk_primi_isveren_hesaplanan + ssdf_isveren_hissesi;else t_ssk_primi_isveren_hesaplanan = t_ssk_primi_isveren_hesaplanan + isveren_hesaplanan;
					
					
					t_ssk_primi_isveren_5510 = t_ssk_primi_isveren_5510 + wrk_round(ssk_isveren_hissesi_5510);
					t_ssk_primi_isveren_5084 = t_ssk_primi_isveren_5084 + ssk_isveren_hissesi_5084;
								
					t_ssk_primi_isveren_5921 = t_ssk_primi_isveren_5921 + ssk_isveren_hissesi_5921;
					t_ssk_primi_isveren_5746 = t_ssk_primi_isveren_5746 + ssk_isveren_hissesi_5746;
					t_ssk_primi_isveren_4691 = t_ssk_primi_isveren_4691 + ssk_isveren_hissesi_4691;
					if(len(ssk_isveren_hissesi_6111))
						t_ssk_primi_isveren_6111 = t_ssk_primi_isveren_6111 + ssk_isveren_hissesi_6111;
					else
						ssk_isveren_hissesi_6111 = 0;
						
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
					
					
					t_issizlik_isci_hissesi = t_issizlik_isci_hissesi + issizlik_isci_hissesi - issizlik_isci_hissesi_687- issizlik_isci_hissesi_7103;
					t_issizlik_isveren_hissesi = t_issizlik_isveren_hissesi + issizlik_isveren_hissesi - issizlik_isveren_hissesi_687- issizlik_isveren_hissesi_7103;
					
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
					d_t_issizlik_isveren_hissesi = d_t_issizlik_isveren_hissesi + issizlik_isveren_hissesi - issizlik_isveren_hissesi_687- issizlik_isveren_hissesi_7103;
		
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
			   
				//687 tesvikten d??s??lecekler
				toplam_indirim_687 = ssk_isveren_hissesi_687 + ssk_isci_hissesi_687 + issizlik_isci_hissesi_687 + issizlik_isveren_hissesi_687 + gelir_vergisi_indirimi_687 + damga_vergisi_indirimi_687;
			   
				//7103 tesvikten d??s??lecekler
				toplam_indirim_7103 = ssk_isveren_hissesi_7103 + ssk_isci_hissesi_7103 + issizlik_isci_hissesi_7103 + issizlik_isveren_hissesi_7103 + gelir_vergisi_indirimi_7103 + damga_vergisi_indirimi_7103;
			   
				toplam_isveren = (total_salary+t_istisna_odenek+issizlik_isveren_hissesi+isveren_hesaplanan+ssdf_isveren_hissesi)-(ssk_isveren_hissesi_5510+ssk_isveren_hissesi_5084+ssk_isveren_hissesi_5921+ssk_isveren_hissesi_5746 +ssk_isveren_hissesi_4691+ssk_isveren_hissesi_6111+ssk_isveren_hissesi_6486+ssk_isveren_hissesi_6322+ssk_isci_hissesi_6322+ssk_isveren_hissesi_gov+toplam_indirim_687+toplam_indirim_7103+ssk_isveren_hissesi_14857);
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
					t_sgk_isveren_hissesi = t_sgk_isveren_hissesi + ssk_isveren_hissesi - ssk_isveren_hissesi_gov - ssk_isveren_hissesi_5921 - ssk_isveren_hissesi_5746 -ssk_isveren_hissesi_4691- ssk_isveren_hissesi_6111- ssk_isveren_hissesi_6486-ssk_isveren_hissesi_6322+ssk_isci_hissesi_6322-ssk_isveren_hissesi_687-ssk_isveren_hissesi_7103-ssk_isveren_hissesi_14857;
					d_t_sgk_isveren_hissesi = d_t_sgk_isveren_hissesi + ssk_isveren_hissesi - ssk_isveren_hissesi_gov - ssk_isveren_hissesi_5921 - ssk_isveren_hissesi_5746 -ssk_isveren_hissesi_4691- ssk_isveren_hissesi_6111 - ssk_isveren_hissesi_6486- ssk_isveren_hissesi_6322-ssk_isveren_hissesi_687-ssk_isveren_hissesi_7103-ssk_isveren_hissesi_14857;
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
			</cfscript>
            <tr <cfif len(FINISH_DATE) and isdate(FINISH_DATE) and (month(FINISH_DATE) eq attributes.sal_mon and year(FINISH_DATE) eq attributes.sal_year)>style="color:red;"<cfelseif len(START_DATE) and (month(START_DATE) eq attributes.sal_mon and year(START_DATE) eq attributes.sal_year)>style="color:blue;"</cfif>>
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
                        <cfcase value="b_statu"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='57894.Stat??'>"><cfif ssk_statute eq 1><cf_get_lang dictionary_id ='53043.Normal'><cfelseif ssk_statute eq 2 or ssk_statute eq 18><cf_get_lang dictionary_id='58541.Emekli'><cfelse><cf_get_lang dictionary_id='58156.Di??er'></cfif></td></cfcase>
                       <cfcase value="b_sex"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='57764.Cinsiyet'>"><cfif sex eq 0><cf_get_lang dictionary_id ='58958.Kad??n'><cfelseif sex eq 1><cf_get_lang dictionary_id ='58959.Erkek'></cfif></td></cfcase>
                        <cfcase value="b_ilgili_sirket"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53701.??lgili ??irket'>">#RELATED_COMPANY#</td></cfcase>
                        <cfcase value="b_sube"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='57453.??ube'>">#BRANCH_NAME#</td></cfcase>
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
                            <td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='57572.Departman'>">#DEPARTMENT_HEAD#</td>
                        </cfcase>
                        <cfcase value="b_pozisyon_sube"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53729.Pozisyon ??ube'>"><cfif listlen(branch_list) and len(position_branch_id)>#get_branchs.branch_name[listfind(branch_list,position_branch_id,',')]#<cfelse>&nbsp;</cfif></td></cfcase>
                        <cfcase value="b_pozisyon_departman"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53728.Pozisyon Departman'>"><cfif listlen(department_list) and len(position_department_id)>#get_departments.department_head[listfind(department_list,position_department_id,',')]#<cfelse>&nbsp;</cfif></td></cfcase>
                        <cfcase value="b_ise_giris"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53702.????e Giri?? '>" style="mso-number-format:'Short Date'">#dateformat(START_DATE,dateformat_style)#</td></cfcase>
                        <cfcase value="b_isten_cikis"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='29832.????ten ????k????'>" style="mso-number-format:'Short Date'"><cfif len(FINISH_DATE) and (month(FINISH_DATE) eq ROW_SAL_MON and year(FINISH_DATE) eq ROW_SAL_YEAR)>#dateformat(FINISH_DATE,dateformat_style)#</cfif></td></cfcase>
                        <cfcase value="b_gruba_giris"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53704.Gruba Giri??i'>" style="mso-number-format:'Short Date'">#dateformat(group_startdate,dateformat_style)#</td></cfcase>
                        <cfcase value="b_kidem_date"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53641.K??dem Baz Tarihi'>" style="mso-number-format:'Short Date'">#dateformat(KIDEM_DATE,dateformat_style)#</td></cfcase>
                        <cfcase value="b_imza"><td width="200" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='58957.??mza'>">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td></cfcase>
                        <cfcase value="b_exp"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53882.????ten ????k???? Nedeni'>"><cfif len(finish_date) and (month(finish_date) eq row_sal_mon and year(finish_date) eq row_sal_year)>#get_explanation_name(explanation_id)#</cfif></td></cfcase>
                        <cfcase value="b_reason"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='38957.??irket ????i Gerek??e'>"><cfif len(finish_date) and (month(finish_date) eq row_sal_mon and year(finish_date) eq row_sal_year)>#reason#</cfif></td></cfcase>
                        <cfcase value="b_ex_in_out_id"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59376.Giri?? Gerek??e'>">#EX_IN#</td></cfcase>
                        <cfcase value="b_ozel_kod">
                            <td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='57789.??zel Kod'>">#hierarchy#</td>
                            <td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='57789.??zel Kod'>1">#ozel_kod#</td>
                            <td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='57789.??zel Kod'>2">#ozel_kod2#</td>
                            <cfif fusebox.dynamic_hierarchy><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='54354.Dinamik Hiyerar??i'>">#dynamic_hierarchy#.#dynamic_hierarchy_add#</td></cfif>
                        </cfcase>
                        <cfcase value="b_unvan"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='57571.??nvan'>"><cfif listlen(title_list) and len(title_id)>#get_titles.title[listfind(title_list,title_id,',')]#<cfelse>&nbsp;</cfif></td></cfcase>
                        <cfcase value="b_pozisyon_tipi"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59004.Pozisyon Tipi'>"><cfif listlen(position_cat_list) and len(position_cat_id)>#get_position_cats.position_cat[listfind(position_cat_list,position_cat_id,',')]#<cfelse>&nbsp;</cfif></td></cfcase>
                        <cfcase value="b_collar_type"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='54054.Yaka Tipi'>"><cfif collar_type eq 1><cf_get_lang dictionary_id='54055.Mavi Yaka'><cfelseif collar_type eq 2><cf_get_lang dictionary_id='54056.Beyaz Yaka'></cfif></td></cfcase>
                        <cfcase value="b_grade_step"><td style="mso-number-format:\@;" nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id="54179.Derece">-<cf_get_lang dictionary_id="58710.Kademe">"><cfif len(grade) or len(step)>#grade#-#step#<cfelse>&nbsp;</cfif></td></cfcase>
                        <cfcase value="b_pozisyon"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53164.Pozisyon'>">#position_name#</td></cfcase>
                        <cfcase value="b_org_step"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='58710.Kademe'>">#organization_step_name#</td></cfcase>
                        <cfcase value="b_duty_type"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='58538.G??rev Tipi'>">#duty_type#</td></cfcase>
                        <cfcase value="b_idari_amir"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - Birinci Amir">#upper_position_employee#</td></cfcase>
                        <cfcase value="b_fonksiyonel_amir"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - ??kinci Amir">#upper_position_employee2#</td></cfcase>
                        <cfcase value="b_business_code">
                            <td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - Meslek Kodu"><cfif len(BUSINESS_CODE_NAME)>#BUSINESS_CODE#</cfif></td>
                            <td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - Meslek Grubu"><cfif len(BUSINESS_CODE_NAME)>#BUSINESS_CODE_NAME#</cfif></td>
                        </cfcase>
                        <cfcase value="b_ucret_yontemi">
                            <td align="center" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53714.??cret Y??ntemi'>">
                                <cfif salary_type eq 0>
                                    <cf_get_lang dictionary_id ='53260.Saatlik'> 
                                <cfelseif salary_type eq 1>
                                    <cf_get_lang dictionary_id='58457.G??nl??k'>
                                <cfelseif salary_type eq 2>
                                    <cf_get_lang dictionary_id='58932.Ayl??k'> 
                                </cfif>
                            </td>
                        </cfcase>
                        <cfcase value="b_kg"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="KG">#KISMI_ISTIHDAM_GUN#</td></cfcase>
                        <cfcase value="b_ks"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="KS">#KISMI_ISTIHDAM_SAAT#</td></cfcase>
                        <cfcase value="b_net_brut"><td nowrap><cfif GROSS_NET eq 0><cf_get_lang dictionary_id="53131.Br??t"><cfelse><cf_get_lang dictionary_id="58083.Net"></cfif></td></cfcase>
                        <cfcase value="b_maas"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="??cret">#tlformat(maas_,2)#</td></cfcase>  
                        <cfcase value="b_ss_gunu"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53715.SS G??n??'>">#normal_gun#</td></cfcase>
                        <cfcase value="b_hs_gunu"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53716.HS G??n??'>">#haftalik_tatil#</td></cfcase>
                        <cfcase value="b_genel_tatil_gunu"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53706.Genel Tatil G??n??'>">#genel_tatil#</td></cfcase>
                        <cfcase value="b_ucretli_izin"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='53686.??cretli ??zin'>#Chr(10)##EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53686.??cretli ??zin'>">#normal_izinli#</td></cfcase>
                        <cfcase value="b_ucretli_izin_pazar"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='53687.??cretli ??zin Pazar'>#Chr(10)##EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53687.??cretli ??zin Pazar'>">#paid_izinli_sunday_count#</td></cfcase>
                        <cfcase value="b_ucretsiz_izin"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='53688.??cretsiz ??zin'>#Chr(10)##EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53688.??cretsiz ??zin'>">#izin#</td></cfcase>
                        <cfcase value="b_toplam_gun"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="Toplam G??n">#total_days#<cfset t_toplam_days = t_toplam_days + total_days><cfset d_t_toplam_days = d_t_toplam_days + total_days></td></cfcase>
                        <cfcase value="b_toplam_calisma_gunu">
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53727.??al????ma G??n??'>">
                                <cfif total_days lt puantaj_gun_>#total_days#<cfset t_days = t_days + total_days><cfset d_t_days = d_t_days + total_days><cfelse>#puantaj_gun_#<cfset t_days = t_days + puantaj_gun_><cfset d_t_days = d_t_days + puantaj_gun_></cfif>
                            </td>
                        </cfcase>
                        <cfcase value="b_ssk_gunu">
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53741.SGK G??n?? Toplam??'> ">#ssk_days#<cfset d_t_sgk_normal_gun = d_t_sgk_normal_gun+ssk_days><cfset t_sgk_normal_gun = t_sgk_normal_gun+ssk_days></td>
                        </cfcase>
                        <cfcase value="b_hi_saat">
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"<cfif ListLen(work_day_hour, ".") gt 1></cfif> title="<cf_get_lang dictionary_id ='53715.SS G??n??'> (Saat)">#tlformat(weekly_hour)#</td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"<cfif ListLen(weekend_hour, ".") gt 1></cfif> title="<cf_get_lang dictionary_id ='53716.HS G??n??'> (Saat)">#tlformat(weekend_hour)#</td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"<cfif ListLen(offdays_count_hour, ".") gt 1></cfif> title="<cf_get_lang dictionary_id ='53706.Genel Tatil G??n??'> (Saat)">#tlformat(offdays_count_hour)#</td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"<cfif ListLen(izin_paid_count, ".") gt 1></cfif> title="<cf_get_lang dictionary_id ='53686.??cretli ??zin'> (Saat)">#tlformat(izin_paid_count-paid_izinli_sunday_count_hour)#</td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"<cfif ListLen(paid_izinli_sunday_count_hour, ".") gt 1></cfif> title="<cf_get_lang dictionary_id ='53687.??cretli ??zin Pazar'> (Saat)">#tlformat(paid_izinli_sunday_count_hour)#</td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"<cfif ListLen(izin_count, ".") gt 1></cfif> title="<cf_get_lang dictionary_id ='53688.??cretsiz ??zin'> (Saat)">#tlformat(izin_count)#</td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';"<cfif ListLen(t_saat, ".") gt 1></cfif> title="<cf_get_lang dictionary_id="57492.Toplam"> <cf_get_lang dictionary_id="57491.Saat">">#tlformat(t_saat)#</td>
                        </cfcase>
                        <cfcase value="b_hafta_ici_mesai"><td nowrap<cfif ListLen(EXT_TOTAL_HOURS_0, ".") gt 1></cfif> title="<cf_get_lang dictionary_id ='53744.Hafta ????i Mesai'>">#tlformat(EXT_TOTAL_HOURS_0)# <cfset t_h_ici = t_h_ici + EXT_TOTAL_HOURS_0><cfset d_t_h_ici = d_t_h_ici + EXT_TOTAL_HOURS_0></td></cfcase>
                        <cfcase value="b_hafta_sonu_mesai"><td nowrap<cfif ListLen(EXT_TOTAL_HOURS_1, ".") gt 1></cfif> title="<cf_get_lang dictionary_id ='53743.Hafta Sonu Mesai'>">#tlformat(EXT_TOTAL_HOURS_1)# <cfset t_h_sonu = t_h_sonu + EXT_TOTAL_HOURS_1><cfset d_t_h_sonu = d_t_h_sonu + EXT_TOTAL_HOURS_1></td></cfcase>
                        <cfcase value="b_resmi_tatil_mesai"><td nowrap<cfif ListLen(EXT_TOTAL_HOURS_2, ".") gt 1></cfif> title="<cf_get_lang dictionary_id ='53742.Resmi Tatil Mesai'>">#tlformat(EXT_TOTAL_HOURS_2)# <cfset t_resmi = t_resmi + EXT_TOTAL_HOURS_2><cfset d_t_resmi = d_t_resmi + EXT_TOTAL_HOURS_2></td></cfcase>
                        <cfcase value="b_gece_mesai_saat"><td nowrap<cfif ListLen(EXT_TOTAL_HOURS_5, ".") gt 1></cfif> title="<cf_get_lang dictionary_id="54329.Gece Mesaisi">">#tlformat(EXT_TOTAL_HOURS_5)#</td></cfcase>
                        <cfcase value="b_aylik_mesaisiz"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53717.Ayl??k Mesaisiz'>">#tlformat(total_amount - ext_salary,2)#</td></cfcase>
                        <cfcase value="b_fazla_mesai"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53718.Fazla Mesai Tutar??'>">#tlformat(ext_salary,2)#</td></cfcase>
                        <cfcase value="b_fazla_mesai_net"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53718.Fazla Mesai Tutar??'><cf_get_lang dictionary_id='58083.Net'>">#tlformat(ext_salary_net,2)#</td></cfcase>
                        <cfcase value="b_gunluk_ucret"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53242.G??nl??k ??cret'>">#tlformat(ucretim,2)#</td></cfcase>
                        <cfcase value="b_aylik_ucret"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53243.Ayl??k ??cret'>">#tlformat(total_amount,2)#</td></cfcase>
                        <cfcase value="b_aylik_brut_ucret"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - Ayl??k Br??t ??cret">#tlformat(aylik_brut_ucret,2)#</td></cfcase>
                        <cfcase value="b_ek_odenek"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53082.Ek ??denek'>">#tlformat(total_pay_ssk_tax+total_pay_ssk+total_pay_tax+total_pay,2)#</td></cfcase>
                        <cfcase value="b_toplam_kazanc"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53244.Toplam Kazan??'>">#tlformat(TOTAL_SALARY-VERGI_ISTISNA_SSK-VERGI_ISTISNA_VERGI+VERGI_ISTISNA_AMOUNT_,2)#</td></cfcase>
                        <cfcase value="b_sgk_matrahi"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53245.SGK Matrah??'>">#tlformat(SSK_MATRAH,2)#</td></cfcase>
                        <cfcase value="b_sgk_isci_hissesi">
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53719.SGK ??????i H'>">#tlformat(ssk_isci_hissesi-ssk_isci_hissesi_687-ssk_isci_hissesi_7103,2)#</td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='47802.SGDP ??????i Hissesi'>">#tlformat(ssdf_isci_hissesi,2)#</td>
                        </cfcase>
                        <cfcase value="b_issizlik_isci_hissesi"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - ????sizlik Sigortas?? ??????i Primi">#tlformat(issizlik_isci_hissesi-issizlik_isci_hissesi_687-issizlik_isci_hissesi_7103,2)#</td></cfcase>
                        <cfcase value="b_gelir_vergisi_indirimi"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53248.Gelir Vergisi ??ndirimi'>">#tlformat(vergi_indirimi+sakatlik_indirimi,2)#</td></cfcase>
                        <cfcase value="b_gelir_vergisi_matrahi"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53249.Gelir Vergisi Matrah??'>">#tlformat(gelir_vergisi_matrah,2)#</td></cfcase>
                        <cfcase value="b_gelir_vergisi_hesaplanan">
                        <td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53689.Gelir Vergisi Hesaplanan'>">
                           <cfset gelir_vergisi_hesaplanan_ = vergi_iadesi + gelir_vergisi + VERGI_INDIRIMI_5084>
							<cfif is_5746_control eq 0>
                               <cfset gelir_vergisi_hesaplanan_ = gelir_vergisi_hesaplanan_ + gelir_vergisi_indirimi_5746>
							   <!--- #tlformat(vergi_iadesi + gelir_vergisi + VERGI_INDIRIMI_5084 + gelir_vergisi_indirimi_5746,2)#
                            <cfelse>
                                #tlformat(vergi_iadesi + gelir_vergisi + VERGI_INDIRIMI_5084,2)#--->
                            </cfif>
                            <cfif is_4691_control eq 0>
                               <cfset gelir_vergisi_hesaplanan_ = gelir_vergisi_hesaplanan_ + gelir_vergisi_indirimi_4691>
                            </cfif>
                            #tlformat(gelir_vergisi_hesaplanan_,2)#
                        </td>
                        </cfcase>
                        <cfcase value="b_asgari_gecim_indirimi"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53659.Asgari Ge??im ??ndirimi'>">#tlformat(vergi_iadesi,2)#</td></cfcase>
                        <cfcase value="b_gelir_vergisi_indirimi_5746"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53248.Gelir Vergisi ??ndirimi'> 5746">#tlformat(gelir_vergisi_indirimi_5746,2)#</td></cfcase>
                        <cfcase value="b_gelir_vergisi_indirimi_4691"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53248.Gelir Vergisi ??ndirimi'> 4691">#tlformat(gelir_vergisi_indirimi_4691,2)#</td></cfcase>
                        <cfcase value="b_gelir_vergisi"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53250.Gelir Vergisi'>">#tlformat(gelir_vergisi-gelir_vergisi_indirimi_687-gelir_vergisi_indirimi_7103,2)#</td></cfcase>
                        <cfcase value="b_vergi_indirimi_5615"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53690.Vergi ??ndirimi '> <cfif (attributes.sal_year eq 2007 and attributes.sal_mon gt 6) or attributes.sal_year gte 2008>5615<cfelse>5084</cfif>">#tlformat(VERGI_INDIRIMI_5084,2)#</td></cfcase>
                        <cfcase value="b_kum_gelir_vergisi_matrahi"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53251.K??m. Gelir Vergisi Matrah??'>">#tlformat(KUMULATIF_GELIR_MATRAH,2)#</td></cfcase>
                        <cfcase value="b_damga_vergisi"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53252.Damga Vergisi'>">#tlformat(damga_vergisi-damga_vergisi_indirimi_687-damga_vergisi_indirimi_7103,2)#</td></cfcase>
                        <cfcase value="b_damga_vergisi_matrah"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='59363.Damga Vergisi Matrah??'>">#tlformat(damga_vergisi_matrah,2)#</td></cfcase>
                        <cfcase value="b_toplam_yasal_kesinti"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53722.Toplam Yasal Kesinti'>">#tlformat(ssk_isci_hissesi + ssdf_isci_hissesi + gelir_vergisi + damga_vergisi + issizlik_isci_hissesi,2)#</td></cfcase>
                        <cfcase value="b_onceki_aydan_devreden_kum_mat">
                        <td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='54297.??nceki Aydan Dev K??m Matrah'>">&nbsp;
                            <cfif isdefined("onceki_donem_kum_gelir_vergisi_matrahi")>
                                #TLFormat(onceki_donem_kum_gelir_vergisi_matrahi,2)#
                            <cfelse>
                                #TLFormat(t_kum_gelir_vergisi_matrahi,2)#
                            </cfif>
                        </td>
                        </cfcase>
                        <cfcase value="b_sgk_devir_isci_hissesi_fark"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='54300.SGK Devir Isci Hissesi Fark'>">#tlformat(sgk_isci_hissesi_fark,2)#</td></cfcase>
                        <cfcase value="b_sgk_devir_issizlik_hissesi_fark"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='54301.SGK Devir Issizlik Hissesi Fark'>">#tlformat(sgk_issizlik_hissesi_fark,2)#</td></cfcase>
                        <cfcase value="b_sgdp_isci_primi_fark"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='54302.SGDP ??????i Primi Fark'>">#tlformat(sgdp_isci_primi_fark,2)#</td></cfcase>
                        <cfcase value="b_muhtelif_kesintiler"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53254.Muhtelif Kesintiler'>">#tlformat(ozel_kesinti,2)#</td></cfcase>
                        <cfcase value="b_net_ucret"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53255.Net ??cret'>">#tlformat(net_ucret-vergi_iadesi,2)#</td></cfcase>
                        <cfcase value="b_toplam_net_odenecek"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53691.Toplam Net ??denecek'>">#tlformat(net_ucret,2)#</td></cfcase>
                        <cfcase value="b_sgk_isveren_primi_hesaplanan">
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53698.SGK ????veren Primi Hesaplanan'>">#tlformat(isveren_hesaplanan,2)#</td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59364.SGDP ????veren Primi Hesaplanan'>">#tlformat(ssdf_isveren_hissesi,2)#</td>
                        </cfcase>
                        <cfcase value="b_muhasebe_kod_group"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='54117.Muhasebe Kod Grubu'>"><cfif listlen(def_list) and len(account_bill_type)>#get_definition.DEFINITION[listfind(def_list,account_bill_type)]#</cfif></td></cfcase>
                        <cfcase value="b_sgk_5084"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53256.SGK ????veren Primi'> 5615"><cfif ssk_isci_hissesi eq 0>#tlformat(0,2)#<cfelse>#tlformat(ssk_isveren_hissesi_5084,2)#</cfif></td></cfcase>
                        <cfcase value="b_sgk_5763"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53256.SGK ????veren Primi'>"><cfif ssk_isci_hissesi eq 0>#tlformat(0,2)#<cfelse>#tlformat(ssk_isveren_hissesi_gov,2)#</cfif></td></cfcase>
                        <cfcase value="b_sgk_5510"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53256.SGK ????veren Primi'> 5510 ">#tlformat(ssk_isveren_hissesi_5510_,2)#</td></cfcase>
                        <cfcase value="b_sgk_5921"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53256.SGK ????veren Primi'> 5921">#tlformat(ssk_isveren_hissesi_5921,2)#</td></cfcase>
                        <cfcase value="b_sgk_5746"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53256.SGK ????veren Primi'> 5746">#tlformat(ssk_isveren_hissesi_5746,2)#</td></cfcase>
                        <cfcase value="b_sgk_4691"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53256.SGK ????veren Primi'> 4691">#tlformat(ssk_isveren_hissesi_4691,2)#</td></cfcase>
                        <cfcase value="b_sgk_6111"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53256.SGK ????veren Primi'> 6111">#tlformat(ssk_isveren_hissesi_6111,2)#</td></cfcase>
                        <cfcase value="b_sgk_6486"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53256.SGK ????veren Primi'> 6486">#tlformat(ssk_isveren_hissesi_6486,2)#</td></cfcase>
                        <cfcase value="b_sgk_6322"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53256.SGK ????veren Primi'> 6322">#tlformat(ssk_isveren_hissesi_6322+ssk_isci_hissesi_6322,2)#</td></cfcase>
                        <cfcase value="b_sgk_14857"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53256.SGK ????veren Primi'> 14857">#tlformat(ssk_isveren_hissesi_14857,2)#</td></cfcase>
                        
                        <cfcase value="b_sgk_isci_687"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59368.SGK ??????i Primi ??ndirimi'> 687">#tlformat(ssk_isci_hissesi_687,2)#</td></cfcase>
                        <cfcase value="b_issizlik_isci_687"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59369.??ssizlik ??????i Primi ??ndirimi'> 687">#tlformat(issizlik_isci_hissesi_687,2)#</td></cfcase>
                        <cfcase value="b_gelir_verigisi_687"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53248.Gelir Vergisi ??ndirimi'> 687">#tlformat(gelir_vergisi_indirimi_687,2)#</td></cfcase>
                        <cfcase value="b_damga_vergisi_687"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59370.Damga Vergisi ??ndirimi'> 687">#tlformat(damga_vergisi_indirimi_687,2)#</td></cfcase>
                        <cfcase value="b_sgk_isveren_687"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59371.SGK ????veren ??ndirimi'> 687">#tlformat(ssk_isveren_hissesi_687,2)#</td></cfcase>
                        <cfcase value="b_issizlik_isveren_687"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59372.????sizlik ????veren ??ndirimi'> 687">#tlformat(issizlik_isveren_hissesi_687,2)#</td></cfcase>
                        
                        <cfcase value="b_sgk_isci_7103"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59368.SGK ??????i Primi ??ndirimi'> 7103">#tlformat(ssk_isci_hissesi_7103,2)#</td></cfcase>
                        <cfcase value="b_issizlik_isci_7103"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59369.??ssizlik ??????i Primi ??ndirimi'> 7103">#tlformat(issizlik_isci_hissesi_7103,2)#</td></cfcase>
                        <cfcase value="b_gelir_verigisi_7103"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53248.Gelir Vergisi ??ndirimi'> 7103">#tlformat(gelir_vergisi_indirimi_7103,2)#</td></cfcase>
                        <cfcase value="b_damga_vergisi_7103"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59370.Damga Vergisi ??ndirimi'> 7103">#tlformat(damga_vergisi_indirimi_7103,2)#</td></cfcase>
                        <cfcase value="b_sgk_isveren_7103"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59371.SGK ????veren ??ndirimi'> 7103">#tlformat(ssk_isveren_hissesi_7103,2)#</td></cfcase>
                        <cfcase value="b_issizlik_isveren_7103"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59372.????sizlik ????veren ??ndirimi'> 7103">#tlformat(issizlik_isveren_hissesi_7103,2)#</td></cfcase>                        
                        
                        <cfcase value="b_sgk_isveren_hissesi">
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53699.SGK ????veren Hissesi'>">#tlformat(ssk_isveren_hissesi - ssk_isveren_hissesi_gov - ssk_isveren_hissesi_5921 - ssk_isveren_hissesi_5746 -ssk_isveren_hissesi_4691 - ssk_isveren_hissesi_6111-ssk_isveren_hissesi_6486-ssk_isveren_hissesi_6322-ssk_isveren_hissesi_687-ssk_isveren_hissesi_7103 - ssk_isveren_hissesi_14857,2)#</td>
                            <td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59377.SGDP ????veren Hissesi'>">#tlformat(ssdf_isveren_hissesi,2)#</td>
                        </cfcase>
                        <cfcase value="b_toplam_sgk_prim"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59373.SGK Primi'>">#tlformat(ssk_isveren_hissesi - ssk_isveren_hissesi_gov - ssk_isveren_hissesi_5921 - ssk_isveren_hissesi_5746 -ssk_isveren_hissesi_4691- ssk_isveren_hissesi_6111-ssk_isveren_hissesi_6486-ssk_isveren_hissesi_6322+ssk_isci_hissesi - ssk_isveren_hissesi_687 -ssk_isci_hissesi_687 - ssk_isveren_hissesi_7103 -ssk_isci_hissesi_7103 -ssk_isveren_hissesi_14857,2)#</td></cfcase>
                        <cfcase value="b_bes_isci_hissesi"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# -<cf_get_lang dictionary_id='59374.BES Kat??l??m Pay??'>">#tlformat(bes_isci_hissesi,2)#</td></cfcase>
                        <cfcase value="b_issizlik_isveren_hissesi"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53257.????sizlik Sigortas?? ????veren  Primi'>">#tlformat(issizlik_isveren_hissesi-issizlik_isveren_hissesi_687-issizlik_isveren_hissesi_7103,2)#</td></cfcase>
                        <cfcase value="b_yillik_izin_tutari"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53393.Y??ll??k ??zin Tutar??'>">#tlformat(yillik_izin,2)#</td></cfcase>
                        <cfcase value="b_kidem_tazminati"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='52991.K??dem Tazminat??'>">#tlformat(kidem_amount,2)#</td></cfcase>
                        <cfcase value="b_ihbar_tazminati"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='52992.??hbar Tazminat??'>">#tlformat(ihbar_amount,2)#</td></cfcase>
                        <cfcase value="b_toplam_isveren_maliyeti"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='53708.Toplam ????veren Maliyeti'>">#tlformat(toplam_isveren,2)#</td></cfcase>
                        <cfcase value="b_toplam_isveren_maliyeti_indirimsiz"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id ='59378.Toplam ????veren Maliyeti ??ndirimsiz'> ">#tlformat(toplam_isveren_indirimsiz,2)#</td></cfcase>
                        <cfcase value="b_ucret_tipi"><td nowrap><cfif sabit_prim eq 0><cf_get_lang dictionary_id='1132.Sabit'><cfelse><cf_get_lang dictionary_id ='53558.Primli'></cfif></td></cfcase>
                        <cfcase value="b_odeme_metodu"><td nowrap><cfif len(paymethod_id)>#GET_PAY_METHODS.paymethod[listfind(pay_list,paymethod_id,',')]#<cfelse>&nbsp;</cfif></td></cfcase>  
                        <cfcase value="b_fonksiyon"><td nowrap><cfif listlen(fonsiyonel_list) and len(FUNC_ID)>#get_units.unit_name[listfind(fonsiyonel_list,func_id,',')]#<cfelse>&nbsp;</cfif></td></cfcase>
                        <cfcase value="b_vergi_istisna_toplam"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53085.Vergi ??stisnalar??'>">#tlformat(vergi_istisna_total,2)#</td></cfcase>
                        <cfcase value="b_vergi_istisna_sgk"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# -  <cf_get_lang dictionary_id='59379.Vergi ??stisna SSK'>">#tlformat(vergi_istisna_ssk,2)#</td></cfcase>
                        <cfcase value="b_vergi_istisna_sgk_net"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59380.Vergi ??stisna SSK Net'>">#tlformat(vergi_istisna_ssk_net,2)#</td></cfcase>
                        <cfcase value="b_vergi_istisna_vergi"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53017.Vergi ??stisna'> <cf_get_lang dictionary_id='33304.Vergi'>">#tlformat(vergi_istisna_vergi,2)#</td></cfcase>
                        <cfcase value="b_vergi_istisna_vergi_net"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53017.Vergi ??stisna'> <cf_get_lang dictionary_id='59381.Vergi Net'>">#tlformat(vergi_istisna_vergi_net,2)#</td></cfcase>
                        <cfcase value="b_vergi_istisna_damga"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53017.Vergi ??stisna'> <cf_get_lang dictionary_id='54121.Damga'>">#tlformat(vergi_istisna_damga,2)#</td></cfcase>
                        <cfcase value="b_vergi_istisna_damga_net"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53017.Vergi ??stisna'> <cf_get_lang dictionary_id='59382.Damga Net'>">#tlformat(vergi_istisna_damga_net,2)#</td></cfcase>
                        <cfcase value="b_ek_odenekler">
                            <cfset count_ = 0>
                            <cfloop list="#odenek_names#" index="cca">
                                <cfset count_ = count_ + 1>
                                <cfset this_ = evaluate('ODENEK_#count_#')>
                                <cfset this_net_ = evaluate('ODENEK_NET_#count_#')>
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
                                <td nowrap title="#employee_name# #employee_surname# - #cca#">#tlformat(this_,2)#</td>
                                <cfif x_payment_type eq 1>
                                    <td nowrap title="#employee_name# #employee_surname# - #cca#">#tlformat(this_net_,2)#</td>
                                </cfif>
                            </cfloop>
                        </cfcase>
                        <cfcase value="b_vergi_istisna">
                            <cfset count_ = 0>
                            <cfloop list="#vergi_istisna_names#" index="cca">
                                <cfset count_ = count_ + 1>
                                <cfset this_ =  evaluate('VERGI_ISTISNA_#count_#')>
                                <cfset this_net_ =  evaluate('VERGI_ISTISNA_TOTAL_#count_#')>
                                <cfset 't_vergi_#count_#' = evaluate("t_vergi_#count_#") + this_>
                                <cfset 'd_t_vergi_#count_#' = evaluate("d_t_vergi_#count_#") + this_>
                                <cfset 't_vergi_net_#count_#' = evaluate("t_vergi_net_#count_#") + this_net_>
                                <cfset 'd_t_vergi_net_#count_#' = evaluate("d_t_vergi_net_#count_#") + this_net_>
                                <td nowrap title="#employee_name# #employee_surname# - #cca#">#tlformat(this_,2)#</td>
                                <td nowrap title="#employee_name# #employee_surname# - #cca#">#tlformat(this_net_,2)#</td>
                            </cfloop>
                        </cfcase>
                        <cfcase value="b_kesintiler">
                            <td nowrap title="Avans">
                                <cfset this_avans_ =  avans>
                                <cfset t_avans = t_avans + this_avans_>
                                <cfset d_t_avans = d_t_avans + this_avans_>
                                #tlformat(this_avans_,2)#
                            </td>
                            <cfset count_ = 0>
                            <cfloop list="#kesinti_names#" index="cca">
                                <cfset count_ = count_ + 1>
                                <cfset this_ = evaluate('KESINTI_#count_#')>
                                <cfset 't_kesinti_#count_#' = evaluate("t_kesinti_#count_#") + this_>
                                <cfset 'd_t_kesinti_#count_#' = evaluate("d_t_kesinti_#count_#") + this_>
                                <td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - #cca#">#tlformat(this_,2)#</td>
                            </cfloop>
                        </cfcase>
                        <cfcase value="b_masraf_merkezi"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='58460.Masraf Merkezi'>"><cfif listlen(main_expense_list) and len(expense_code)>#get_expenses.EXPENSE[listfind(main_expense_list,expense_code,';')]#</cfif></td></cfcase>
                        <cfcase value="b_masraf_merkezi_kodu"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='53747.Masraf Merkezi Kodu'>">#expense_code#</td></cfcase>
                        <cfcase value="b_muhasebe_kodu"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='58811.Muhasebe Kodu'>">#account_code#</td></cfcase>
                        <cfcase value="b_banka"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='57521.Banka'>">#BANK_NAME#</td></cfcase>
                        <cfcase value="b_hesap_no"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='43744.Banka ??ube Kodu'>">#BANK_BRANCH_CODE#-#BANK_ACCOUNT_NO#</td></cfcase>
                        <cfcase value="b_iban_no"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='50195.Iban No'>">#IBAN_NO#</td></cfcase>
                        <cfcase value="b_toplam_devreden_sgk_matrahi"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='54333.Toplam devreden sgk matrah??'>">#TlFormat((ssk_devir_ + ssk_devir_last_),2)#</td></cfcase>
                        <cfcase value="b_2_onceki_aydan_devreden_sgk_matrahi"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='54334.??ki ??nceki aydan devreden sgk matrah??'>">#TlFormat(ssk_devir_last_,2)#</td></cfcase>
                        <cfcase value="b_1_onceki_aydan_devreden_sgk_matrahi"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='54335.Bir ??nceki aydan devreden sgk matrah??'>">#TlFormat(ssk_devir_,2)#</td></cfcase>
                        <cfcase value="b_buaydan_devreden_sgk_matrahi"><td nowrap title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - <cf_get_lang dictionary_id='59375.Bu aydan devreden sgk matrah??'>">#TlFormat(ssk_amount,2)#</td></cfcase>
                        <cfcase value="b_kesinti_ve_agi_oncesi_net">
                        	<td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='54310.Kesinti ve Agi ??ncesi Net'>">
                            	#TLFormat(net_ucret-vergi_iadesi+ozel_kesinti+bes_isci_hissesi)#
								<cfset d_agi_oncesi_net = d_agi_oncesi_net+net_ucret-vergi_iadesi+ozel_kesinti+bes_isci_hissesi>
								<cfset t_agi_oncesi_net = t_agi_oncesi_net+net_ucret-vergi_iadesi+ozel_kesinti+bes_isci_hissesi>
                            </td>
                        </cfcase>
                    </cfswitch>
                  </cfloop>
            </tr>
            <cfif isdefined("attributes.sort_type") and len(attributes.sort_type) and (currentrow eq recordcount or type is not '#type[get_puantaj_rows.currentrow+1]#')>
                <cfset cols_plus_ilk = cols_plus>
                <cfset yillik_izin = d_t_yillik_izin>
                <cfset cols_plus = cols_plus + 5>
                <tr class="txtbold">
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
                                <cfcase value="b_net_brut"><td style="text-align:right;mso-number-format:'0\.00';">&nbsp;</td></cfcase>
                                <cfcase value="b_maas"><td nowrap style="text-align:right;mso-number-format:'0\.00';">#tlformat(d_t_maas,2)#</td></cfcase>
                                <cfcase value="b_ss_gunu"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='53741.SSK G??n Toplam??'>">#d_normal_gun_total#</td></cfcase>
                                <cfcase value="b_hs_gunu"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='53740.Hafta Sonu G??n Toplam??'>">#d_haftalik_tatil_total#</td></cfcase>
                                <cfcase value="b_genel_tatil_gunu"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='53739.Genel Tatil G??n Toplam??'>">#d_genel_tatil_total#</td></cfcase>
                                <cfcase value="b_ucretli_izin"><td style="text-align:right;mso-number-format:'0\.00';" nowrap title="<cf_get_lang dictionary_id ='53738.??cretli ??zin G??n Toplam??'>">#d_t_izin_paid#</td></cfcase>
                                <cfcase value="b_ucretli_izin_pazar"><td style="text-align:right;mso-number-format:'0\.00';" nowrap title="<cf_get_lang dictionary_id ='53737.??cretli ??zin Pazar Toplam??'>">#d_t_paid_izinli_sunday_count#</td></cfcase>
                                <cfcase value="b_ucretsiz_izin"><td style="text-align:right;mso-number-format:'0\.00';" nowrap title="<cf_get_lang dictionary_id ='53736.??cretsiz ??zin G??n Toplam??'>">#d_t_izin#</td></cfcase>
                                <cfcase value="b_toplam_gun"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='53734.Toplam ??al????ma G??n??'>">#d_t_toplam_days#</td></cfcase>
                                <cfcase value="b_toplam_calisma_gunu"><td style="text-align:right;mso-number-format:'0\.00';">#d_t_days#</td></cfcase>
                                <cfcase value="b_ssk_gunu"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53741.SGK G??n Toplam??'>">#d_t_sgk_normal_gun#</td></cfcase>
                                <cfcase value="b_hi_saat">
                                    <td style="text-align:right;mso-number-format:'0\.00';" <cfif ListLen(t_hi_saat, ".") gt 1></cfif>>#tlformat(t_hi_saat)#</td>
                                    <td style="text-align:right;mso-number-format:'0\.00';" <cfif ListLen(t_ht_saat, ".") gt 1></cfif>>#tlformat(t_ht_saat)#</td>
                                    <td style="text-align:right;mso-number-format:'0\.00';"<cfif ListLen(t_gt_saat, ".") gt 1></cfif>>#tlformat(t_gt_saat)#</td>
                                    <td style="text-align:right;mso-number-format:'0\.00';"<cfif ListLen(t_paid_izin_saat, ".") gt 1></cfif>>#tlformat(t_paid_izin_saat)#</td>
                                    <td style="text-align:right;mso-number-format:'0\.00';"<cfif ListLen(t_paid_ht_izin_saat, ".") gt 1></cfif>>#tlformat(t_paid_ht_izin_saat)#</td>
                                    <td style="text-align:right;mso-number-format:'0\.00';"<cfif ListLen(t_izin, ".") gt 1></cfif>>#tlformat(dt_izin_saat)#</td>
                                    <td style="text-align:right;mso-number-format:'0\.00';"<cfif ListLen(t_saat, ".") gt 1></cfif>>#tlformat(t_saat)#</td>
                                </cfcase>
                                <cfcase value="b_hafta_ici_mesai"><td title="<cf_get_lang dictionary_id ='53733.Toplam Hafta ????i Mesai Saati'>"<cfif ListLen(d_t_h_ici, ".") gt 1></cfif>>#tlformat(d_t_h_ici)#</td></cfcase>
                                <cfcase value="b_hafta_sonu_mesai"><td title="<cf_get_lang dictionary_id ='53732.Toplam Hafta Sonu Mesai Saati'>"<cfif ListLen(d_t_h_sonu, ".") gt 1></cfif>>#tlformat(d_t_h_sonu)#</td></cfcase>
                                <cfcase value="b_resmi_tatil_mesai"><td title="<cf_get_lang dictionary_id ='53731.Toplam Resmi Tatil Mesai Saati'>"<cfif ListLen(d_t_resmi, ".") gt 1></cfif>>#tlformat(d_t_resmi)#</td></cfcase>
                                <cfcase value="b_gece_mesai_saat"><td title="<cf_get_lang dictionary_id ='53731.Toplam Resmi Tatil Mesai Saati'>"<cfif ListLen(t_gece_mesai_saat, ".") gt 1></cfif>>#tlformat(t_gece_mesai_saat)#</td></cfcase>
                                <cfcase value="b_aylik_mesaisiz"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59383.Ayl??k Mesaisiz Toplamlar??'>">#tlformat(d_t_aylik - d_t_aylik_fazla,2)#</td></cfcase>
                                <cfcase value="b_fazla_mesai"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59384.Fazla Mesai Toplamlar??'>">#tlformat(d_t_aylik_fazla,2)#</td></cfcase>
                                <cfcase value="b_fazla_mesai_net"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59385.Fazla Mesai Net Toplamlar??'>">#tlformat(d_t_aylik_fazla_mesai_net,2)#</td></cfcase>
                                <cfcase value="b_gunluk_ucret"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59386.G??nl??k ??cret Toplam??'>">#tlformat(d_t_gunluk_ucret,2)#</td></cfcase>
                                <cfcase value="b_aylik_ucret"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59387.Ayl??k ??cret Toplamlar??'>">#tlformat(d_t_aylik,2)#</td></cfcase>
                                <cfcase value="b_aylik_brut_ucret"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59388.Ayl??k Br??t ??cret Toplamlar??'>">#tlformat(t_aylik_brut_ucret,2)#</td></cfcase>
                                <cfcase value="b_ek_odenek"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='39967.Ek ??denek Toplam??'>">#tlformat(d_t_total_pay_ssk_tax+d_t_total_pay_ssk+d_t_total_pay_tax+d_t_total_pay,2)#</td></cfcase>
                                <cfcase value="b_toplam_kazanc"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='30871.Toplam Kazan??'>">#tlformat(d_t_toplam_kazanc,2)#</td></cfcase>
                                <cfcase value="b_sgk_matrahi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59389.SSK Matrah Toplamlar??'>">#tlformat(d_t_ssk_matrahi+d_t_ssdf_matrah,2)#</td></cfcase>
                                <cfcase value="b_sgk_isci_hissesi">
                                    <td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59390.SSK ??????i Hissesi Toplamlar??'>">#tlformat(d_t_ssk_primi_isci,2)#</td>
                                    <td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59391.SGDP ??????i Hissesi Toplamlar??'>">#tlformat(d_t_ssdf_isci_hissesi,2)#</td>
                                </cfcase>
                                <cfcase value="b_issizlik_isci_hissesi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59392.????sizlik Sigorta ????veren Prim Toplamlar??'>">#tlformat(d_t_issizlik_isci_hissesi,2)#</td> </cfcase>
                                <cfcase value="b_gelir_vergisi_indirimi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53248.Gelir Vergisi ??ndirimi'>">#tlformat(d_t_vergi_indirimi+d_t_sakatlik_indirimi,2)#</td></cfcase>
                                <cfcase value="b_gelir_vergisi_matrahi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53249.Gelir Vergisi Matrah??'>">#tlformat(d_t_gelir_vergisi_matrahi,2)#</td></cfcase>
                                <cfcase value="b_gelir_vergisi_hesaplanan">
                                <td style="text-align:right;mso-number-format:'0\.00';" title="Gelir Vergisi Hesaplanan Toplamlar??">
                                    #tlformat(d_t_asgari_gecim + d_t_gelir_vergisi + d_t_kanun + d_t_gelir_vergisi_indirimi_5746_+d_t_gelir_vergisi_indirimi_4691_+d_t_gelir_vergisi_indirimi_687+d_t_gelir_vergisi_indirimi_7103,2)#
                                </td>
                                </cfcase>
                                <cfcase value="b_asgari_gecim_indirimi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53659.Asgari Ge??im ??ndirimi'>">#tlformat(d_t_asgari_gecim,2)#</td></cfcase>
                                <cfcase value="b_gelir_vergisi_indirimi_5746"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53248.Gelir Vergisi ??ndirimi'> 5746">#tlformat(d_t_gelir_vergisi_indirimi_5746,2)#</td></cfcase>
                                <cfcase value="b_gelir_vergisi_indirimi_4691"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53248.Gelir Vergisi ??ndirimi'> 4691">#tlformat(d_t_gelir_vergisi_indirimi_4691,2)#</td></cfcase>
                                <cfcase value="b_gelir_vergisi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53250.Gelir Vergisi'>">#tlformat(d_t_gelir_vergisi,2)#</td></cfcase>
                                <cfcase value="b_vergi_indirimi_5615"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='38971.Vergi ??ndirimi'> 5615">#tlformat(d_t_kanun)#</td></cfcase>
                                <cfcase value="b_kum_gelir_vergisi_matrahi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59393.K??m.Gelir Verg.Toplamlar??'>">#tlformat(d_t_kum_gelir_vergisi_matrahi,2)#</td></cfcase>
                                <cfcase value="b_damga_vergisi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53252.Damga Vergisi'>">#tlformat(d_t_damga_vergisi,2)#</td></cfcase>
                                <cfcase value="b_damga_vergisi_matrah"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59363.Damga Vergisi Matrah??'>">#tlformat(d_t_damga_vergisi_matrahi,2)#</td></cfcase>
                                <cfcase value="b_toplam_yasal_kesinti"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53253.Toplam Yasal Kesinti'>">#tlformat(d_t_kesinti,2)#</td></cfcase>
                                <cfcase value="b_onceki_aydan_devreden_kum_mat"><td style="text-align:right;mso-number-format:'0\.00';"  title="<cf_get_lang dictionary_id='54297.??nceki Aydan Dev. K??m. Matrah'>">#tlformat(d_t_onceki_donem_kum_gelir_vergisi_matrahi,2)#</td></cfcase>
                                <cfcase value="b_sgk_devir_isci_hissesi_fark"><td style="text-align:right;mso-number-format:'0\.00';"  title="<cf_get_lang dictionary_id='54300.SGK Devir Isci Hissesi Fark'>">#tlformat(d_t_sgk_isci_hissesi_fark,2)#</td></cfcase>
                                <cfcase value="b_sgk_devir_issizlik_hissesi_fark"><td style="text-align:right;mso-number-format:'0\.00';"  title="<cf_get_lang dictionary_id='54301.SGK Devir Issizlik Hissesi Fark'>">#tlformat(d_t_sgk_issizlik_hissesi_fark,2)#</td></cfcase>
                                <cfcase value="b_sgdp_isci_primi_fark"><td style="text-align:right;mso-number-format:'0\.00';"  title="<cf_get_lang dictionary_id='54302.SGDP ??????i Primi Fark'>">#tlformat(d_t_sgdp_isci_primi_fark,2)#</td></cfcase>
                                <cfcase value="b_muhtelif_kesintiler"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53254.Muhtelif Kesintiler'>">#tlformat(d_t_ozel_kesinti,2)#</td></cfcase>
                                <cfcase value="b_net_ucret"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='38999.Net ??cret'>">#tlformat(d_t_net_ucret-d_t_asgari_gecim,2)#</td></cfcase>
                                <cfcase value="b_toplam_net_odenecek"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53691.Toplam Net ??denecek'>">#tlformat(d_t_net_ucret,2)#</td></cfcase>
                                <cfcase value="b_sgk_isveren_primi_hesaplanan">
                                    <td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53699.SGK ????veren Hissesi'>">#tlformat(d_t_ssk_primi_isveren_hesaplanan,2)#</td>
                                    <td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59394.SGDP ????veren Hesaplanan'>">#tlformat(d_t_ssdf_isveren_hissesi,2)#</td>
                                </cfcase>
                                <cfcase value="b_muhasebe_kod_group"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='54117.Muhasebe Kod Grubu'>"></td></cfcase>
                                <cfcase value="b_sgk_5084"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SGK ????veren Primi'> 5084">#tlformat(d_t_ssk_primi_isveren_5084,2)#</td></cfcase>
                                <cfcase value="b_sgk_5763"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SGK ????veren Primi'> 5763">#tlformat(d_t_ssk_primi_isveren_gov,2)#</td></cfcase>
                                <cfcase value="b_sgk_5510"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SGK ????veren Primi'> 5510">#tlformat(d_t_ssk_primi_isveren_5510,2)#</td></cfcase>
                                <cfcase value="b_sgk_5921"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SGK ????veren Primi'> 5921">#tlformat(d_t_ssk_primi_isveren_5921,2)#</td></cfcase>
                                <cfcase value="b_sgk_5746"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SGK ????veren Primi'> 5746">#tlformat(d_t_ssk_primi_isveren_5746,2)#</td></cfcase>
                                <cfcase value="b_sgk_4691"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SGK ????veren Primi'> 4691">#tlformat(d_t_ssk_primi_isveren_4691,2)#</td></cfcase>
                                <cfcase value="b_sgk_6111"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SGK ????veren Primi'> 6111">#tlformat(d_t_ssk_primi_isveren_6111,2)#</td></cfcase>
                                <cfcase value="b_sgk_6486"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SGK ????veren Primi'> 6486">#tlformat(d_t_ssk_primi_isveren_6486,2)#</td></cfcase>
                                <cfcase value="b_sgk_6322"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SGK ????veren Primi'> 6322">#tlformat(d_t_ssk_primi_isveren_6322+d_t_ssk_primi_isci_6322,2)#</td></cfcase>
                                <cfcase value="b_sgk_14857"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SGK ????veren Primi'> 14857">#tlformat(d_t_ssk_primi_isveren_14857,2)#</td></cfcase>
                                
                                <cfcase value="b_sgk_isci_687"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59368.SGK ??????i Primi ??ndirimi'> 687">#tlformat(d_t_ssk_isci_hissesi_687,2)#</td></cfcase>
                                <cfcase value="b_issizlik_isci_687"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59369.??ssizlik ??????i Primi ??ndirimi'> 687">#tlformat(d_t_issizlik_isci_hissesi_687,2)#</td></cfcase>
                                <cfcase value="b_gelir_verigisi_687"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53248.Gelir Vergisi ??ndirimi'> 687">#tlformat(d_t_gelir_vergisi_indirimi_687,2)#</td></cfcase>
                                <cfcase value="b_damga_vergisi_687"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59370.Damga Vergisi ??ndirimi'> 687">#tlformat(d_t_damga_vergisi_indirimi_687,2)#</td></cfcase>
                                <cfcase value="b_sgk_isveren_687"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59371.SGK ????veren ??ndirimi'> 687">#tlformat(d_t_ssk_isveren_hissesi_687,2)#</td></cfcase>
                                <cfcase value="b_issizlik_isveren_687"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='????sizlik ????veren ??ndirimi'> 687">#tlformat(d_t_issizlik_isveren_hissesi_687,2)#</td></cfcase>
                                
                                <cfcase value="b_sgk_isci_7103"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59368.SGK ??????i Primi ??ndirimi'> 7103">#tlformat(d_t_ssk_isci_hissesi_7103,2)#</td></cfcase>
                                <cfcase value="b_issizlik_isci_7103"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59369.??ssizlik ??????i Primi ??ndirimi'> 7103">#tlformat(d_t_issizlik_isci_hissesi_7103,2)#</td></cfcase>
                                <cfcase value="b_gelir_verigisi_7103"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53248.Gelir Vergisi ??ndirimi'> 7103">#tlformat(d_t_gelir_vergisi_indirimi_7103,2)#</td></cfcase>
                                <cfcase value="b_damga_vergisi_7103"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59370.Damga Vergisi ??ndirimi'> 7103">#tlformat(d_t_damga_vergisi_indirimi_7103,2)#</td></cfcase>
                                <cfcase value="b_sgk_isveren_7103"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59371.SGK ????veren ??ndirimi'> 7103">#tlformat(d_t_ssk_isveren_hissesi_7103,2)#</td></cfcase>
                                <cfcase value="b_issizlik_isveren_7103"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='????sizlik ????veren ??ndirimi'> 7103">#tlformat(d_t_issizlik_isveren_hissesi_7103,2)#</td></cfcase>
                                
                                <cfcase value="b_sgk_isveren_hissesi">
                                    <td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SGK ????veren Primi'>">#tlformat(d_t_sgk_isveren_hissesi,2)#</td> 
                                    <td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59377.SGDP ????veren Hissesi'>">#tlformat(d_t_ssdf_isveren_hissesi,2)#</td> 
                                </cfcase>
                                <cfcase value="b_toplam_sgk_prim">
                                    <td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59373.SGK Primi'>">#tlformat(d_t_sgk_isveren_hissesi+d_t_ssk_primi_isci,2)#</td> 
                                </cfcase>
                                <cfcase value="b_bes_isci_hissesi">
                                    <td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59374.BES Kat??l??m Pay??'>">#tlformat(d_t_bes_isci_hissesi,2)#</td> 
                                </cfcase>
                                <cfcase value="b_issizlik_isveren_hissesi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59392.????sizlik Sigorta ????veren Prim Toplamlar??'>">#tlformat(d_t_issizlik_isveren_hissesi,2)#</td></cfcase>
                                <cfcase value="b_yillik_izin_tutari"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='53735.Y??ll??k ??zin Tutar Toplam??'>">#tlformat(yillik_izin_total,2)#</td></cfcase>
                                <cfcase value="b_kidem_tazminati"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='52991.K??dem Tazminat??'>">#tlformat(d_kidem_amount,2)#</td></cfcase>
                                <cfcase value="b_ihbar_tazminati"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='52992.??hbar Tazminat??'>">#tlformat(d_ihbar_amount,2)#</td></cfcase>
                                <cfcase value="b_toplam_isveren_maliyeti"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='31846.Toplam ????veren Maliyeti'>">#tlformat(d_t_toplam_isveren,2)#</td></cfcase>
                                <cfcase value="b_toplam_isveren_maliyeti_indirimsiz"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59378.Toplam ????veren Maliyeti ??ndirimsiz'>">#tlformat(d_t_toplam_isveren_indirimsiz,2)#</td></cfcase>
                                <cfcase value="b_ucret_tipi"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_odeme_metodu"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_fonksiyon"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_exp"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_reason"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_ex_in_out_id"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_vergi_istisna_toplam"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53017.Vergi ??stisnas??'> #Chr(10)#">#tlformat(d_vergi_istisna_total,2)#</td></cfcase>
                                <cfcase value="b_vergi_istisna_sgk"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59379.Vergi ??stisna SSK'> #Chr(10)#">#tlformat(d_vergi_istisna_ssk,2)#</td></cfcase>
                                <cfcase value="b_vergi_istisna_sgk_net"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59380.Vergi ??stisna SSK Net'> #Chr(10)#">#tlformat(d_vergi_istisna_ssk_net,2)#</td></cfcase>
                                <cfcase value="b_vergi_istisna_vergi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53017.Vergi ??stisna'> #Chr(10)#">#tlformat(d_vergi_istisna_vergi,2)#</td></cfcase>
                                <cfcase value="b_vergi_istisna_vergi_net"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53017.Vergi ??stisna'> <cf_get_lang dictionary_id='59381.Vergi Net'> #Chr(10)#">#tlformat(d_vergi_istisna_vergi_net,2)#</td></cfcase>
                                <cfcase value="b_vergi_istisna_damga"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53017.Vergi ??stisna'> <cf_get_lang dictionary_id='54121.Damga'> #Chr(10)#">#tlformat(d_vergi_istisna_damga,2)#</td></cfcase>
                                <cfcase value="b_vergi_istisna_damga_net"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53017.Vergi ??stisna'> <cf_get_lang dictionary_id='59382.Damga Net'> #Chr(10)#">#tlformat(d_vergi_istisna_damga_net,2)#</td></cfcase>	
                                <cfcase value="b_ek_odenekler">
                                    <cfset count_ = 0>
                                    <cfloop list="#odenek_names#" index="cca">
                                        <cfset count_ = count_ + 1>
                                        <td title="#odenek_names#">#tlformat(evaluate("d_t_odenek_#count_#"),2)#</td>
                                        <cfif x_payment_type eq 1>
                                            <td title="#odenek_names#">#tlformat(evaluate("d_t_odenek_net_#count_#"),2)#</td>
                                        </cfif>
                                    </cfloop>
                                </cfcase>
                                <cfcase value="b_vergi_istisna">
                                    <cfset count_ = 0>
                                    <cfloop list="#vergi_istisna_names#" index="cca">
                                        <cfset count_ = count_ + 1>
                                        <td title="#vergi_istisna_names#">#tlformat(evaluate("d_t_vergi_#count_#"),2)#</td>
                                        <td title="#vergi_istisna_names#">#tlformat(evaluate("d_t_vergi_net_#count_#"),2)#</td>
                                    </cfloop>
                                </cfcase>
                                <cfcase value="b_kesintiler">
                                    <td title="<cf_get_lang dictionary_id='58204.Avans'>"style="text-align:right;mso-number-format:'0\.00';">#tlformat(d_t_avans,2)#</td>
                                    <cfset count_ = 0>
                                    <cfloop list="#kesinti_names#" index="cca">
                                        <cfset count_ = count_ + 1>
                                        <td title="#kesinti_names#">#tlformat(evaluate("d_t_kesinti_#count_#"),2)#</td>
                                    </cfloop>
                                </cfcase>
                                <cfcase value="b_masraf_merkezi"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_masraf_merkezi_kodu"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_muhasebe_kodu"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_banka"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_hesap_no"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_iban_no"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_toplam_devreden_sgk_matrahi"><td title="<cf_get_lang dictionary_id='54333.toplam devreden sgk matrah??'>">#TlFormat(d_t_ssk_devir + d_t_ssk_devir_last,2)#</td></cfcase>
                                <cfcase value="b_2_onceki_aydan_devreden_sgk_matrahi"><td title="<cf_get_lang dictionary_id='54334.??ki ??nceki aydan devreden sgk matrah??'>">#TlFormat(d_t_ssk_devir_last,2)#</td></cfcase>
                                <cfcase value="b_1_onceki_aydan_devreden_sgk_matrahi"><td title="<cf_get_lang dictionary_id='54335.Bir ??nceki aydan devreden sgk matrah??'>">#TlFormat(d_t_ssk_devir,2)#</td></cfcase>
                                <cfcase value="b_buaydan_devreden_sgk_matrahi"><td title="<cf_get_lang dictionary_id='59375.Bu aydan devreden sgk matrah??'>">#TlFormat(d_t_ssk_amount,2)#</td></cfcase>
                                <cfcase value="b_kesinti_ve_agi_oncesi_net"><td style="text-align:right;mso-number-format:'0\.00';" title="Kesinti ve Agi ??ncesi Net">#TLFormat(d_agi_oncesi_net)#</td></cfcase>
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
                <tr class="total">
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
                                <cfcase value="b_kg"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_ks"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_net_brut"><td style="text-align:right;mso-number-format:'0\.00';">&nbsp;</td></cfcase>
                                <cfcase value="b_maas"><td style="text-align:right;mso-number-format:'0\.00';" title="??cret">#tlformat(t_maas,2)#</td></cfcase>
                                <cfcase value="b_ss_gunu"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='53741.SSK G??n Toplam??'>">#normal_gun_total#</td></cfcase>
                                <cfcase value="b_hs_gunu"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='53740.Hafta Sonu G??n Toplam??'>">#haftalik_tatil_total#</td></cfcase>
                                <cfcase value="b_genel_tatil_gunu"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='53739.Genel Tatil G??n Toplam??'>">#genel_tatil_total#</td></cfcase>
                                <cfcase value="b_ucretli_izin"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='53738.??cretli ??zin G??n Toplam??'>">#t_izin_paid#</td></cfcase>
                                <cfcase value="b_ucretli_izin_pazar"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='53737.??cretli ??zin Pazar  Toplam??'>">#t_paid_izinli_sunday_count#</td></cfcase>
                                <cfcase value="b_ucretsiz_izin"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='53736.??cretsiz ??zin G??n Toplam??'>">#t_izin#</td></cfcase>
                                <cfcase value="b_toplam_gun"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='53734.Toplam ??al????ma G??n??'>">#t_toplam_days#</td></cfcase>
                                <cfcase value="b_toplam_calisma_gunu"><td style="text-align:right;mso-number-format:'0\.00';">#t_days#</td></cfcase>
                                <cfcase value="b_ssk_gunu"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53816.Toplam SGK G??n??'> ">#t_sgk_normal_gun#</td></cfcase>
                                <cfcase value="b_hi_saat">
                                    <td style="text-align:right;mso-number-format:'0\.00';" <cfif ListLen(gt_hi_saat, ".") gt 1></cfif> title="<cf_get_lang dictionary_id='53715.SS G??n??'>(<cf_get_lang dictionary_id='57491.Saat'>)">#tlformat(gt_hi_saat)#</td>
                                    <td style="text-align:right;mso-number-format:'0\.00';" <cfif ListLen(gt_ht_saat, ".") gt 1></cfif> title="<cf_get_lang dictionary_id='53716.HS G??n??'>(<cf_get_lang dictionary_id='57491.Saat'>)">#tlformat(gt_ht_saat)#</td>
                                    <td style="text-align:right;mso-number-format:'0\.00';"<cfif ListLen(gt_gt_saat, ".") gt 1></cfif> title="<cf_get_lang dictionary_id='53706.Genel Tatil G??n??'>(<cf_get_lang dictionary_id='57491.Saat'>)">#tlformat(gt_gt_saat)#</td>
                                    <td style="text-align:right;mso-number-format:'0\.00';"<cfif ListLen(gt_paid_izin_saat, ".") gt 1></cfif> title="<cf_get_lang dictionary_id='53686.??cretli ??zin'>(<cf_get_lang dictionary_id='57491.Saat'>)">#tlformat(gt_paid_izin_saat)#</td>
                                    <td style="text-align:right;mso-number-format:'0\.00';"<cfif ListLen(gt_paid_ht_izin_saat, ".") gt 1></cfif> title="<cf_get_lang dictionary_id='53687.??cretli ??zin Pazar'>(<cf_get_lang dictionary_id='57491.Saat'>)">#tlformat(gt_paid_ht_izin_saat)#</td>
                                    <td style="text-align:right;mso-number-format:'0\.00';"<cfif ListLen(gt_izin_saat, ".") gt 1></cfif> title="<cf_get_lang dictionary_id='43317.??cretsiz ??zin'>(<cf_get_lang dictionary_id='57491.Saat'>)">#tlformat(gt_izin_saat)#</td>
                                    <td style="text-align:right;mso-number-format:'0\.00';"<cfif ListLen(gt_toplam_saat, ".") gt 1></cfif> title="<cf_get_lang dictionary_id='46377.Toplam Saat'>">#tlformat(gt_toplam_saat)#</td>
                                </cfcase>
                                <cfcase value="b_hafta_ici_mesai"><td title="<cf_get_lang dictionary_id ='53733.Toplam Hafta ????i Mesai Saati'>">#tlformat(t_h_ici)#</td></cfcase>
                                <cfcase value="b_hafta_sonu_mesai"><td title="<cf_get_lang dictionary_id ='53732.Toplam Hafta Sonu Mesai Saati'>">#tlformat(t_h_sonu)#</td></cfcase>
                                <cfcase value="b_resmi_tatil_mesai"><td title="<cf_get_lang dictionary_id ='53731.Toplam Resmi Tatil Mesai Saati'>">#tlformat(t_resmi)#</td></cfcase>
                                <cfcase value="b_gece_mesai_saat"><td title="<cf_get_lang dictionary_id ='53731.Toplam Resmi Tatil Mesai Saati'>">#tlformat(gt_gece_mesai_saat)#</td></cfcase>
                                <cfcase value="b_aylik_mesaisiz"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59383.Ayl??k Mesaisiz Toplamlar??'>">#tlformat(t_aylik - t_aylik_fazla,2)#</td></cfcase>
                                <cfcase value="b_fazla_mesai"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59384.Fazla Mesai Toplamlar??'>">#tlformat(t_aylik_fazla,2)#</td></cfcase>
                                <cfcase value="b_fazla_mesai_net"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59385.Fazla Mesai Net Toplamlar??'>">#tlformat(t_aylik_fazla_mesai_net,2)#</td></cfcase>
                                <cfcase value="b_gunluk_ucret"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59386.G??nl??k ??cret Toplam??'>">#tlformat(t_gunluk_ucret,2)#</td></cfcase>
                                <cfcase value="b_aylik_ucret"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59387.Ayl??k ??cret Toplamlar??'>">#tlformat(t_aylik,2)#</td></cfcase>
                                <cfcase value="b_aylik_brut_ucret"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59388.Ayl??k Br??t ??cret Toplamlar??'>">#tlformat(t_aylik_brut_ucret,2)#</td></cfcase>
                                <cfcase value="b_ek_odenek"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='39967.Ek ??denek Toplam??'>">#tlformat(t_total_pay_ssk_tax+t_total_pay_ssk+t_total_pay_tax+t_total_pay,2)#</td></cfcase>
                                <cfcase value="b_toplam_kazanc"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='30871.Toplam Kazan??'>">#tlformat(t_toplam_kazanc,2)#</td></cfcase>
                                <cfcase value="b_sgk_matrahi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59389.SSK Matrah Toplamlar??'>">#tlformat(t_ssk_matrahi+t_ssdf_matrah,2)#</td></cfcase>
                                <cfcase value="b_sgk_isci_hissesi">
                                    <td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59390.SSK ??????i Hissesi Toplamlar??'>">#tlformat(t_ssk_primi_isci,2)#</td>
                                    <td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59391.SGDP ??????i Hissesi Toplamlar??'>">#tlformat(t_ssdf_isci_hissesi,2)#</td>
                                </cfcase>
                                <cfcase value="b_issizlik_isci_hissesi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59392.????sizlik Sigorta ????veren Prim Toplamlar??'>">#tlformat(t_issizlik_isci_hissesi,2)#</td></cfcase>
                                <cfcase value="b_gelir_vergisi_indirimi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53248.Gelir Vergisi ??ndirimi'>">#tlformat(t_vergi_indirimi+t_sakatlik_indirimi,2)#</td></cfcase>
                                <cfcase value="b_gelir_vergisi_matrahi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53249.Gelir Vergisi Matrah'>"#tlformat(t_gelir_vergisi_matrahi,2)#</td></cfcase>
                                <cfcase value="b_gelir_vergisi_hesaplanan">
                                    <td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53689.Gelir Vergisi Hesaplanan'>">
                                        #tlformat(t_asgari_gecim + t_gelir_vergisi + t_kanun + t_gelir_vergisi_indirimi_5746_+t_gelir_vergisi_indirimi_4691_+t_gelir_vergisi_indirimi_687+t_gelir_vergisi_indirimi_7103,2)#
                                    </td>
                                </cfcase>
                                <cfcase value="b_asgari_gecim_indirimi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53659.Asgari Ge??im ??ndirimi'>">#tlformat(t_asgari_gecim,2)#</td></cfcase>
                                <cfcase value="b_gelir_vergisi_indirimi_5746"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53248.Gelir Vergisi ??ndirimi'> 5746">#tlformat(t_gelir_vergisi_indirimi_5746,2)#</td></cfcase>
                                <cfcase value="b_gelir_vergisi_indirimi_4691"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53248.Gelir Vergisi ??ndirimi'> 4691">#tlformat(t_gelir_vergisi_indirimi_4691,2)#</td></cfcase>
                                <cfcase value="b_gelir_vergisi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53248.Gelir Vergisi ??ndirimi'>"#tlformat(t_gelir_vergisi,2)#</td></cfcase>
                                <cfcase value="b_vergi_indirimi_5615"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='38971.Vergi ??ndirimi'> 5615">#tlformat(t_kanun)#</td></cfcase>
                                <cfcase value="b_kum_gelir_vergisi_matrahi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59393.K??m.Gelir Verg.Toplamlar??'>">#tlformat(t_kum_gelir_vergisi_matrahi,2)#</td></cfcase>
                                <cfcase value="b_damga_vergisi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53252.Damga Vergisi'>">#tlformat(t_damga_vergisi,2)#</td></cfcase>
                                <cfcase value="b_damga_vergisi_matrah"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59363.Damga Vergisi Matrah'>">#tlformat(t_damga_vergisi_matrahi,2)#</td></cfcase>
                                <cfcase value="b_toplam_yasal_kesinti"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53253.Toplam Yasal Kesinti'>">#tlformat(t_kesinti,2)#</td></cfcase>
                                <cfcase value="b_onceki_aydan_devreden_kum_mat"><td style="text-align:right;mso-number-format:'0\.00';"  title="<cf_get_lang dictionary_id='54297.??nceki Aydan Dev. K??m. Matrah'>">#tlformat(t_onceki_donem_kum_gelir_vergisi_matrahi,2)#</td></cfcase>
                                <cfcase value="b_sgk_devir_isci_hissesi_fark"><td style="text-align:right;mso-number-format:'0\.00';"  title="<cf_get_lang dictionary_id='54300.SGK Devir Isci Hissesi Fark'>">#tlformat(t_sgk_isci_hissesi_fark,2)#</td></cfcase>
                                <cfcase value="b_sgk_devir_issizlik_hissesi_fark"><td style="text-align:right;mso-number-format:'0\.00';"  title="<cf_get_lang dictionary_id='54301.SGK Devir Issizlik Hissesi Fark'>">#tlformat(t_sgk_issizlik_hissesi_fark,2)#</td></cfcase>
                                <cfcase value="b_sgdp_isci_primi_fark"><td style="text-align:right;mso-number-format:'0\.00';"  title="SGDP ??????i Primi Fark">#tlformat(t_sgdp_isci_primi_fark,2)#</td></cfcase>
                                <cfcase value="b_muhtelif_kesintiler"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53254.Muhtelif Kesintiler'>">#tlformat(t_ozel_kesinti,2)#</td></cfcase>
                                <cfcase value="b_net_ucret"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='38999.Net ??cret'>">#tlformat(t_net_ucret-t_asgari_gecim,2)#</td></cfcase>
                                <cfcase value="b_toplam_net_odenecek"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53691.Toplam Net ??denecek'>">#tlformat(t_net_ucret,2)#</td></cfcase>
                                <cfcase value="b_sgk_isveren_primi_hesaplanan">
                                    <td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53698.SSK ????v H Hesaplanan'>">#tlformat(t_ssk_primi_isveren_hesaplanan,2)#</td>
                                    <td style="text-align:right;mso-number-format:'0\.00';" title="SGDP ????veren Hesaplanan">#tlformat(t_ssdf_isveren_hissesi,2)#</td>
                                </cfcase>
                                <cfcase value="b_muhasebe_kod_group"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='54117.Muhasebe Kod Grubu'>"></td></cfcase>
                                <cfcase value="b_sgk_5084"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK ????veren Primi'> 5084">#tlformat(t_ssk_primi_isveren_5084,2)#</td></cfcase>
                                <cfcase value="b_sgk_5763"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK ????veren Primi'> 5763">#tlformat(t_ssk_primi_isveren_gov,2)#</td></cfcase>
                                <cfcase value="b_sgk_5510"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK ????veren Primi'> 5510">#tlformat(t_ssk_primi_isveren_5510,2)#</td></cfcase>
                                <cfcase value="b_sgk_5921"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK ????veren Primi'> 5921">#tlformat(t_ssk_primi_isveren_5921,2)#</td></cfcase>
                                <cfcase value="b_sgk_5746"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK ????veren Primi'> 5746">#tlformat(t_ssk_primi_isveren_5746,2)#</td></cfcase>
                                <cfcase value="b_sgk_4691"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK ????veren Primi'> 4691">#tlformat(t_ssk_primi_isveren_4691,2)#</td></cfcase>
                                <cfcase value="b_sgk_6111"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK ????veren Primi'> 6111">#tlformat(t_ssk_primi_isveren_6111,2)#</td></cfcase>
                                <cfcase value="b_sgk_6486"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK ????veren Primi'> 6486">#tlformat(t_ssk_primi_isveren_6486,2)#</td></cfcase>
                                <cfcase value="b_sgk_6322"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK ????veren Primi'> 6322">#tlformat(t_ssk_primi_isveren_6322+t_ssk_primi_isci_6322,2)#</td></cfcase>
                                <cfcase value="b_sgk_14857"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SSK ????veren Primi'> 14857">#tlformat(t_ssk_primi_isveren_14857,2)#</td></cfcase>
                                
                                <cfcase value="b_sgk_isci_687"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59368.SGK ??????i Primi ??ndirimi'> 687">#tlformat(t_ssk_isci_hissesi_687,2)#</td></cfcase>
                                <cfcase value="b_issizlik_isci_687"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59369.??ssizlik ??????i Primi ??ndirimi'> 687">#tlformat(t_issizlik_isci_hissesi_687,2)#</td></cfcase>
                                <cfcase value="b_gelir_verigisi_687"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53248.Gelir Vergisi ??ndirimi'> 687">#tlformat(t_gelir_vergisi_indirimi_687,2)#</td></cfcase>
                                <cfcase value="b_damga_vergisi_687"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59370.Damga Vergisi ??ndirimi'> 687">#tlformat(t_damga_vergisi_indirimi_687,2)#</td></cfcase>
                                <cfcase value="b_sgk_isveren_687"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59371.SGK ????veren ??ndirimi'>687">#tlformat(t_ssk_isveren_hissesi_687,2)#</td></cfcase>
                                <cfcase value="b_issizlik_isveren_687"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59372.????sizlik ????veren ??ndirimi'> 687">#tlformat(t_issizlik_isveren_hissesi_687,2)#</td></cfcase>
                                
                                <cfcase value="b_sgk_isci_7103"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59368.SGK ??????i Primi ??ndirimi'> 7103">#tlformat(t_ssk_isci_hissesi_7103,2)#</td></cfcase>
                                <cfcase value="b_issizlik_isci_7103"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59369.??ssizlik ??????i Primi ??ndirimi'> 7103">#tlformat(t_issizlik_isci_hissesi_7103,2)#</td></cfcase>
                                <cfcase value="b_gelir_verigisi_7103"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53248.Gelir Vergisi ??ndirimi'> 7103">#tlformat(t_gelir_vergisi_indirimi_7103,2)#</td></cfcase>
                                <cfcase value="b_damga_vergisi_7103"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59370.Damga Vergisi ??ndirimi'> 7103">#tlformat(t_damga_vergisi_indirimi_7103,2)#</td></cfcase>
                                <cfcase value="b_sgk_isveren_7103"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59371.SGK ????veren ??ndirimi'> 7103">#tlformat(t_ssk_isveren_hissesi_7103,2)#</td></cfcase>
                                <cfcase value="b_issizlik_isveren_7103"><td nowrap style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59372.????sizlik ????veren ??ndirimi'> 7103">#tlformat(t_issizlik_isveren_hissesi_7103,2)#</td></cfcase>
                                
                                <cfcase value="b_sgk_isveren_hissesi">
                                    <td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53256.SGK ????veren Primi'>">#tlformat(t_sgk_isveren_hissesi,2)#</td> 
                                    <td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59377.SGDP ????veren Hissesi'>">#tlformat(t_ssdf_isveren_hissesi,2)#</td> 
                                </cfcase>
                                <cfcase value="b_toplam_sgk_prim"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59373.SGK Primi'>">#tlformat(t_sgk_isveren_hissesi+t_ssk_primi_isci,2)#</td></cfcase>
                                <cfcase value="b_bes_isci_hissesi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59374.BES Kat??l??m Pay??'>">#tlformat(t_bes_isci_hissesi,2)#</td></cfcase>
                                <cfcase value="b_issizlik_isveren_hissesi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59392.????sizlik Sigorta ????veren Prim Toplamlar??'>">#tlformat(t_issizlik_isveren_hissesi,2)#</td></cfcase>
                                <cfcase value="b_yillik_izin_tutari"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id ='53735.Y??ll??k ??zin Tutar Toplam??'>">#tlformat(d_yillik_izin_total,2)#</td></cfcase>
                                <cfcase value="b_kidem_tazminati"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='52991.K??dem Tazminat??'>">#tlformat(t_kidem_amount,2)#</td></cfcase>
                                <cfcase value="b_ihbar_tazminati"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='52992.??hbar Tazminat??'>">#tlformat(t_ihbar_amount,2)#</td></cfcase>
                                <cfcase value="b_toplam_isveren_maliyeti"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='31846.Toplam ????veren Maliyeti'>">#tlformat(t_toplam_isveren,2)#</td></cfcase>
                                <cfcase value="b_toplam_isveren_maliyeti_indirimsiz"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59378.Toplam ????veren Maliyeti ??ndirimsiz'>">#tlformat(t_toplam_isveren_indirimsiz,2)#</td></cfcase>
                                <cfcase value="b_ucret_tipi"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_odeme_metodu"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_fonksiyon"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_exp"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_reason"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_ex_in_out_id"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_vergi_istisna_toplam"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53017.Vergi ??stisna'> #Chr(10)#">#tlformat(t_vergi_istisna_total,2)#</td></cfcase>
                                <cfcase value="b_vergi_istisna_sgk"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59379.Vergi ??stisna SSK'> #Chr(10)#">#tlformat(t_vergi_istisna_ssk,2)#</td></cfcase>
                                <cfcase value="b_vergi_istisna_sgk_net"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='59380.Vergi ??stisna SSK Net'> #Chr(10)#">#tlformat(t_vergi_istisna_ssk_net,2)#</td></cfcase>
                                <cfcase value="b_vergi_istisna_vergi"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53017.Vergi ??stisna'> #Chr(10)#">#tlformat(t_vergi_istisna_vergi,2)#</td></cfcase>
                                <cfcase value="b_vergi_istisna_vergi_net"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53017.Vergi ??stisna'> <cf_get_lang dictionary_id='59381.Vergi Net'> #Chr(10)#">#tlformat(t_vergi_istisna_vergi_net,2)#</td></cfcase>
                                <cfcase value="b_vergi_istisna_damga"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53017.Vergi ??stisna'> <cf_get_lang dictionary_id='54121.Damga'> #Chr(10)#">#tlformat(t_vergi_istisna_damga,2)#</td></cfcase>
                                <cfcase value="b_vergi_istisna_damga_net"><td style="text-align:right;mso-number-format:'0\.00';" title="<cf_get_lang dictionary_id='53017.Vergi ??stisna'> <cf_get_lang dictionary_id='59382.Damga Net'> #Chr(10)#">#tlformat(t_vergi_istisna_damga_net,2)#</td></cfcase>
                                <cfcase value="b_ek_odenekler">
                                    <cfset count_ = 0>
                                    <cfloop list="#odenek_names#" index="cca">
                                        <cfset count_ = count_ + 1>
                                        <td title="#cca#">#tlformat(evaluate("t_odenek_#count_#"),2)#</td>
                                        <cfif x_payment_type eq 1>
                                                <td title="#cca#">#tlformat(evaluate("t_odenek_net_#count_#"),2)#</td>
                                        </cfif>
                                    </cfloop>
                                </cfcase>
                                <cfcase value="b_vergi_istisna">
                                    <cfset count_ = 0>
                                    <cfloop list="#vergi_istisna_names#" index="cca">
                                        <cfset count_ = count_ + 1>
                                        <td title="#cca#">#tlformat(evaluate("t_vergi_#count_#"),2)#</td>
                                        <td title="#cca#">#tlformat(evaluate("t_vergi_net_#count_#"),2)#</td>
                                    </cfloop>
                                </cfcase>
                                <cfcase value="b_kesintiler">
                                    <td title="Avans Toplamlar??"style="text-align:right;mso-number-format:'0\.00';">#tlformat(t_avans,2)#</td>
                                    <cfset count_ = 0>
                                    <cfloop list="#kesinti_names#" index="cca">
                                        <cfset count_ = count_ + 1>
                                        <td title="#cca#">#tlformat(evaluate("t_kesinti_#count_#"),2)#</td>
                                    </cfloop>
                                </cfcase>
                                <cfcase value="b_masraf_merkezi"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_masraf_merkezi_kodu"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_muhasebe_kodu"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_banka"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_hesap_no"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_iban_no"><td>&nbsp;</td></cfcase>
                                <cfcase value="b_toplam_devreden_sgk_matrahi"><td title="<cf_get_lang dictionary_id='54333.toplam devreden sgk matrah??'>">#TlFormat(t_ssk_devir + t_ssk_devir_last,2)#</td></cfcase>
                                <cfcase value="b_2_onceki_aydan_devreden_sgk_matrahi"><td title="<cf_get_lang dictionary_id='54334.??ki ??nceki aydan devreden sgk matrah??'>">#TlFormat(t_ssk_devir_last,2)#</td></cfcase>
                                <cfcase value="b_1_onceki_aydan_devreden_sgk_matrahi"><td title="<cf_get_lang dictionary_id='54335.Bir ??nceki aydan devreden sgk matrah??'>">#TlFormat(t_ssk_devir,2)#</td></cfcase>
                                <cfcase value="b_buaydan_devreden_sgk_matrahi"><td title="<cf_get_lang dictionary_id='59375.Bu aydan devreden sgk matrah??'>">#TlFormat(t_ssk_amount,2)#</td></cfcase>
                                <cfcase value="b_kesinti_ve_agi_oncesi_net"><td title="<cf_get_lang dictionary_id='54310.Agi ??ncesi Net'>" style="text-align:right;mso-number-format:'0\.00';">#TLFormat(t_agi_oncesi_net)#</td></cfcase>
                            </cfswitch>
                        </cfloop>
                </tr>
            </cfif>
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
                d_t_ssk_primi_isveren_6322 = 0;
				d_t_ssk_primi_isveren_14857 = 0;
				
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
</cfoutput>
</table>
<script type="text/javascript">
	window.print();
</script>

