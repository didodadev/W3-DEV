<cfif fuseaction eq "report.">
	<cfset fuseaction = "report.standart">
</cfif>
<cf_xml_page_edit>

<cfset report_faction_list = "
report.employee_analyse_report,
report.employee_activity_report,
report.report_transfer_work_position,
report.report_transfer_work_in_out,
report.employee_salary_analyse_report,
report.perform_report,
report.report_targets,
report.system_login_logoff_report,
report.partner_public_login_report,
report.puantaj_mail_kontrol,
report.employee_branch_ozel_kod,
branch_ssk_info_report,
report.puantaj_payment_types,
report.list_log_files,
report.puantaj_check_report,
report.employees_bank_accounts_report,
report.employees_bank_payment_control_report,
report.employee_test_out_vekalet_times,
report.purchase_analyse_report,
report.purchase_analyse_report_ship,
report.purchase_analyse_report_orders,
report.stock_analyse,
report.stock_analyse_new,
report.envanter_raporu,
report.stock_profile,
list_negative_stock,
report.ship_dispatch_report,
report.detail_product_report,
report.cost_analyse_report,
report.time_cost_report,
report.bsy_report,
report.ship_report,
report.ship_result_analyse_report,
report.service_analyse_report,
report.sale_analyse_report,
report.sale_analyse_report_ship,
report.sale_analyse_report_orders,
report.detail_sale_offer_report,
report.detail_opportunity_report,
report.detail_visit_report,
report.daily_total_sales,
report.risc_analys,
report.revenue_analysis,
report.training_analyse_report,
report.list_account_plan_report,
report.rapor_yevmiye,
report.borc_alacak_tutmayanlar,
report.company_account_code,
report.rapor_kebir,
report.mizan_raporu,
report.rapor_muavin,
report.product_account_code,
report.ratio_report,
report.production_analyse,
report.project_accounts_report,
report.pro_material_result,
report.project_works_report,
report.detail_report_project,
report.compare_activity_summary,
report.activity_summary,
report.detayli_uye_analizi_raporu,
report.report_target_market,
report.bsc_company,
report.etkilesim_rapor,
report.invoice_list_purchase,
report.invoice_list_purchase_new,
report.invoice_list_sale,
report.system_analyse_report,
report.subscription_payment_plan_report,
report.agenda_rapor,
report.company_ekg,
report.content_report,
report.training_analyse_function_report,
report.training_maliyet,
report.daily_revenue_analyse,
report.company_payment_list,
report.consigment_analyse_report,
report.category_base_sale_analyse_report,
report.family_detail,
report.kdv_report_with_month,
report.cheque_voucher_analyse_report,
report.extra_works_time_report,
report.manage_all_salaries,
report.monthly_debit_claim_report,
report.monthly_total_revenue,
report.detail_inventory_report,
report.report_ba_bs,
report.sales_quota_analyse,
report.detail_product_tree_report,
report.collacted_make_age_report,
report.report_sms,
report.performance_user_report,
report.sale_stock_analyse_orders,
report.nosale_products_report,
report.close_period_inventory_report,
report.serial_report,
report.serial_report_control,
report.hr_offtimes_report,
report.customer_points,
report.related_product_tree_report,
report.report_list_cv,
report.visit_report,
report.production_pause_report,
report.workstations_expense_seller_report,
report.product_expense_seller_report,
report.product_cost_report,
report.improper_product_report,
report.production_program_report,
report.detail_pos_operation_report,
report.detail_credit_report,
report.dbs_report,
report.list_assets,
report.report_transfer_position_history,
report.import_order_analyse,
report.product_action_search,
report.list_complaint,
report.export_product_report,
report.employees_edu_work_info,
report.puantaj_status_report,
report.form_generator_report,
report.muhtasar_beyanname,
report.employee_execution_report,
report.employees_sgk_detail_report
">
<cfset yasak_list = "">
<cfset izin_list = "">
<cfquery name="get_page_lock" datasource="#dsn#">
	SELECT
		*
	FROM
		DENIED_PAGES_LOCK
	WHERE
		(
		<cfset m_id = 0>
		<cfloop list="#report_faction_list#" index="ccc">
			<cfset m_id = m_id + 1>
			DENIED_PAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(ccc)#"> <cfif m_id neq listlen(report_faction_list)>OR</cfif>
		</cfloop>
		)
        AND 
        (
            (
                OUR_COMPANY_ID IS NULL AND
                PERIOD_ID IS NULL
            )
            OR
            ( 
                OUR_COMPANY_ID = '#session.ep.company_id#' OR
                OUR_COMPANY_ID LIKE '%,#session.ep.company_id#,%' OR
                OUR_COMPANY_ID LIKE '#session.ep.company_id#,%' OR
                OUR_COMPANY_ID LIKE '%,#session.ep.company_id#'
            )
            OR
            ( 
                PERIOD_ID = '#session.ep.period_id#' OR
                PERIOD_ID LIKE '%,#session.ep.period_id#,%' OR
                PERIOD_ID LIKE '#session.ep.period_id#,%' OR
                PERIOD_ID LIKE '%,#session.ep.period_id#'
            )
        )
</cfquery>
<cfquery name="get_my_izinliler" dbtype="query">
	SELECT DISTINCT 
    	DENIED_PAGE 
    FROM 
    	get_page_lock 
    WHERE 
    	POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND 
        DENIED_TYPE = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> 
</cfquery>
<cfif get_my_izinliler.recordcount>
	<cfoutput query="get_my_izinliler">
		<cfset izin_list = listappend(izin_list,'#DENIED_PAGE#')>
	</cfoutput>
</cfif>

<cfquery name="get_my_yasaklilar_1" dbtype="query">
	SELECT  
    	DENIED_PAGE 
    FROM 
    	get_page_lock 
    WHERE 
    	DENIED_TYPE = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> 
		<cfif get_my_izinliler.recordcount>AND DENIED_PAGE NOT IN ('#replace(izin_list,",","','","all")#')</cfif> 
</cfquery>
<cfif get_my_yasaklilar_1.recordcount>
	<cfoutput query="get_my_yasaklilar_1">
		<cfset yasak_list = listappend(yasak_list,'#DENIED_PAGE#')>
	</cfoutput>
</cfif>

<cfquery name="get_my_yasaklilar_2" dbtype="query">
	SELECT DISTINCT DENIED_PAGE FROM get_page_lock WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND DENIED_TYPE = <cfqueryparam cfsqltype="cf_sql_smallint" value="0">
</cfquery>
<cfif get_my_yasaklilar_2.recordcount>
	<cfoutput query="get_my_yasaklilar_2">
		<cfset yasak_list = listappend(yasak_list,'#DENIED_PAGE#')>
	</cfoutput>
</cfif>
<cfinclude template="../display/report_menu.cfm">
<div class="row">
	<div class="col col-12">
		<h3><cfoutput><cf_get_lang dictionary_id='58144.Standart Raporlar'></cfoutput></h3>
	</div>
</div>
<cfoutput> 
    <div class="pagemenus_container">
        <div style="float:left;">
            <cfif (is_module_authority eq 1 and get_module_user(3) or is_module_authority eq 0) or (is_module_authority eq 1 and get_module_user(48) or is_module_authority eq 0)>
                <ul class="pagemenus">
                    <li><strong><cf_get_lang dictionary_id='57444.İnsan Kaynakları'></strong>
                        <ul>
                            <cfif (not listfindnocase(denied_pages,'report.employee_analyse_report') and not listfindnocase(yasak_list,'report.employee_analyse_report'))><li><a href="#request.self#?fuseaction=report.employee_analyse_report"><cf_get_lang dictionary_id='39930.Çalışan Detaylı Analiz Raporu'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.employee_activity_report') and not listfindnocase(yasak_list,'report.employee_activity_report'))><li><a href="#request.self#?fuseaction=report.employee_activity_report"><cf_get_lang dictionary_id='39574.Çalışan Faaliyet Raporu'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.report_email_list') and not listfindnocase(yasak_list,'report.report_email_list'))><li><a href="#request.self#?fuseaction=report.report_email_list"><cf_get_lang dictionary_id='40701.Calisan Email Raporu'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.report_email_list') and not listfindnocase(yasak_list,'report.employees_edu_work_info'))><li><a href="#request.self#?fuseaction=report.employees_edu_work_info"><cf_get_lang dictionary_id='40432.Eğitim ve Deneyim Bilgileri Raporu'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.report_list_cv') and not listfindnocase(yasak_list,'report.report_list_cv'))><li><a href="#request.self#?fuseaction=report.report_list_cv"><cf_get_lang dictionary_id='40711.CV Raporu'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.report_transfer_work_position') and not listfindnocase(yasak_list,'report.report_transfer_work_position'))><li><a href="#request.self#?fuseaction=report.report_transfer_work_position"><cf_get_lang dictionary_id='39034.Görev Değişiklileri Pozisyon'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.report_transfer_work_in_out') and not listfindnocase(yasak_list,'report.report_transfer_work_in_out'))><li><a href="#request.self#?fuseaction=report.report_transfer_work_in_out"><cf_get_lang dictionary_id='39042.Görev Değişiklikleri Giriş-Çıkış'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.report_transfer_position_history') and not listfindnocase(yasak_list,'report.report_transfer_position_history'))><li><a href="#request.self#?fuseaction=report.report_transfer_position_history"><cf_get_lang dictionary_id='39149.Görev Değişiklikleri'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.perform_report') and not listfindnocase(yasak_list,'report.perform_report'))><li><a href="#request.self#?fuseaction=report.perform_report"><cf_get_lang dictionary_id='39172.Performans Degerlendirme Bölüm Bazlı'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.perform_report_results') and not listfindnocase(yasak_list,'report.perform_report_results'))><li><a href="#request.self#?fuseaction=report.perform_report_results"><cf_get_lang dictionary_id='39237.Performans Sonuc Raporu'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.report_targets') and not listfindnocase(yasak_list,'report.report_targets'))><li><a href="#request.self#?fuseaction=report.report_targets"><cf_get_lang dictionary_id='39043.Hedefler Raporu'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.puantaj_mail_kontrol') and not listfindnocase(yasak_list,'report.puantaj_mail_kontrol'))><li><a href="#request.self#?fuseaction=report.puantaj_mail_kontrol"><cf_get_lang dictionary_id='39575.Puantaj Mail Kontrol Raporu'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.employee_branch_ozel_kod') and not listfindnocase(yasak_list,'report.report.employee_branch_ozel_kod'))><li><a href="#request.self#?fuseaction=report.employee_branch_ozel_kod"><cf_get_lang dictionary_id='39576.Özel Kod Kullananlar'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.branch_ssk_info_report') and not listfindnocase(yasak_list,'report.report.branch_ssk_info_report'))><li><a href="#request.self#?fuseaction=report.branch_ssk_info_report"><cf_get_lang dictionary_id='39577.Şube SSK Bilgileri Raporu'></a></li></cfif>
                            <!---<cfif (not listfindnocase(denied_pages,'report.puantaj_payment_types') and not listfindnocase(yasak_list,'report.puantaj_payment_types'))><li><a href="#request.self#?fuseaction=report.puantaj_payment_types"><cf_get_lang dictionary_id='857.Ödenek ve Kesinti Tipleri Raporu'></a></li></cfif>--->
                            <cfif (not listfindnocase(denied_pages,'report.id_report') and not listfindnocase(yasak_list,'report.id_report'))><li><a href="#request.self#?fuseaction=report.id_report">İd Raporu</a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.puantaj_check_report') and session.ep.ehesap eq 1 and not listfindnocase(yasak_list,'report.puantaj_check_report'))><li><a href="#request.self#?fuseaction=report.puantaj_check_report"><cf_get_lang dictionary_id='39580.Puantaj Karşılaştırma'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.employees_bank_accounts_report') and not listfindnocase(yasak_list,'report.employees_bank_accounts_report'))><li><a href="#request.self#?fuseaction=report.employees_bank_accounts_report"><cf_get_lang dictionary_id='39581.Çalışan Banka Hesapları'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.employees_bank_payment_control_report') and not listfindnocase(yasak_list,'report.employees_bank_payment_control_report'))><li><a href="#request.self#?fuseaction=report.employees_bank_payment_control_report"><cf_get_lang dictionary_id='39701.Çalışan Banka Maaş Kontrol Raporu'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.employee_test_out_vekalet_times') and not listfindnocase(yasak_list,'report.employee_test_out_vekalet_times'))><li><a href="#request.self#?fuseaction=report.employee_test_out_vekalet_times"><cf_get_lang dictionary_id='39582.Çalışan Görev Bitiş Tarihleri'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.report_empapp_evaluation') and not listfindnocase(yasak_list,'report.report_empapp_evaluation'))><li> <a href="#request.self#?fuseaction=report.report_empapp_evaluation"><cf_get_lang dictionary_id ='39921.Aday Değerlendirme Raporu'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.family_detail') and not listfindnocase(yasak_list,'report.family_detail'))><li> <a href="#request.self#?fuseaction=report.family_detail"><cf_get_lang dictionary_id ='39922.Aile Durum Bildirimi Raporu'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.extra_works_time_report') and not listfindnocase(yasak_list,'report.extra_works_time_report'))><li> <a href="#request.self#?fuseaction=report.extra_works_time_report"><cf_get_lang dictionary_id ='39923.Fazla Çalışma Saat Raporu'></a></li></cfif>
                            <cfif get_module_user(48)><cfif (not listfindnocase(denied_pages,'report.hr_offtimes_report') and not listfindnocase(yasak_list,'report.hr_offtimes_report'))><li> <a href="#request.self#?fuseaction=report.hr_offtimes_report"><cf_get_lang dictionary_id='39254.İzin - Kıdem - İhbar Yükü Raporu'></a></li></cfif></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.worker_puantaj_report') and not listfindnocase(yasak_list,'report.worker_puantaj_report'))><li> <a href="#request.self#?fuseaction=report.worker_puantaj_report"><cf_get_lang dictionary_id ='40436.İşcilik Puantaj Cetveli'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.blood_group_report') and not listfindnocase(yasak_list,'report.blood_group_report'))><li> <a href="#request.self#?fuseaction=report.blood_group_report"><cf_get_lang dictionary_id='40719.Kan Grubu Raporu'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.extra_worktimes') and not listfindnocase(yasak_list,'report.extra_worktimes'))><li> <a href="#request.self#?fuseaction=report.extra_worktimes"><cf_get_lang dictionary_id='60810.Toplu Fazla Mesai Raporu'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.employement_assets_report') and not listfindnocase(yasak_list,'report.employement_assets_report'))><li> <a href="#request.self#?fuseaction=report.employement_assets_report"><cf_get_lang dictionary_id='47812.Özlük Belgeleri Raporu'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.employee_turnover_report') and not listfindnocase(yasak_list,'report.employee_turnover_report'))><li> <a href="#request.self#?fuseaction=report.employee_turnover_report"><cf_get_lang dictionary_id='60811.Turnover Raporu'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.puantaj_status_report') and not listfindnocase(yasak_list,'report.puantaj_status_report'))><li> <a href="#request.self#?fuseaction=report.puantaj_status_report"><cf_get_lang dictionary_id='59147.Puantaj Durum Raporu'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.employee_performance_report') and not listfindnocase(yasak_list,'report.employee_performance_report'))><li> <a href="#request.self#?fuseaction=report.employee_performance_report"><cf_get_lang dictionary_id='47813.Çalışan Performans Raporu'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.handicapped_count_report') and not listfindnocase(yasak_list,'report.handicapped_count_report'))><li> <a href="#request.self#?fuseaction=report.handicapped_count_report"><cf_get_lang dictionary_id='47814.Özürlü Çalışan Sayıları Raporu'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.caution_prize_report') and not listfindnocase(yasak_list,'report.caution_prize_report'))><li> <a href="#request.self#?fuseaction=report.caution_prize_report"><cf_get_lang dictionary_id='47815.Disiplin ve Ödül İşlemleri Raporu'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.emp_ext_worktimes') and not listfindnocase(yasak_list,'report.emp_ext_worktimes'))><li> <a href="#request.self#?fuseaction=report.emp_ext_worktimes"><cf_get_lang dictionary_id='47816.Fazla Mesai Raporu'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.survey_report') and not listfindnocase(yasak_list,'report.survey_report'))><li> <a href="#request.self#?fuseaction=report.survey_report"><cf_get_lang dictionary_id='40251.Anket Raporu'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.employee_count_report') and not listfindnocase(yasak_list,'report.employee_count_report'))><li> <a href="#request.self#?fuseaction=report.employee_count_report"><cf_get_lang dictionary_id='40398.Çalışan Sayıları Raporu'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.employee_execution_report') and not listfindnocase(yasak_list,'report.employee_execution_report'))><li> <a href="#request.self#?fuseaction=report.employee_execution_report"><cf_get_lang dictionary_id='39940.İcra Raporu'></a></li></cfif>
                            <cfif get_module_power_user(67) and get_module_power_user(48)>
                            	<cfif (not listfindnocase(denied_pages,'report.employee_salary_analyse_report') and not listfindnocase(yasak_list,'report.employee_salary_analyse_report'))><li><a href="#request.self#?fuseaction=report.employee_salary_analyse_report"><cf_get_lang dictionary_id='39171.Detaylı Ücret Analiz'></a></li></cfif>
                            	<cfif (not listfindnocase(denied_pages,'report.manage_all_salaries') and not listfindnocase(yasak_list,'report.manage_all_salaries'))><li> <a href="#request.self#?fuseaction=report.manage_all_salaries"><cf_get_lang dictionary_id ='39924.Ücret Yönetim Raporu'></a></li></cfif>
                            	<cfif (not listfindnocase(denied_pages,'report.employees_sgk_detail_report') and not listfindnocase(yasak_list,'report.employees_sgk_detail_report'))><li><a href="#request.self#?fuseaction=report.employees_sgk_detail_report"><cf_get_lang dictionary_id='59319.İş Yeri Çalışan SGK Bilgileri'></a></li></cfif>
                            </cfif>
                            <cfif (not listfindnocase(denied_pages,'report.minimum_wage_encourage_report') and not listfindnocase(yasak_list,'report.minimum_wage_encourage_report'))><li><a href="#request.self#?fuseaction=report.minimum_wage_encourage_report"><cf_get_lang dictionary_id='47817.Asgari Ücret Teşviği'></a></li></cfif>
                        </ul>
                    </li>
                </ul>
            </cfif>
            <cfif fusebox.use_period eq 1>
				<cfif (is_module_authority eq 1 and get_module_user(20) or is_module_authority eq 0) or (is_module_authority eq 1 and get_module_user(12) or is_module_authority eq 0)>
                    <div class="pagemenus_clear"></div>
                    <ul class="pagemenus">
                        <li><strong><cf_get_lang dictionary_id='57449.Satın alma'></strong>
                            <ul>
                                <cfif (not listfindnocase(denied_pages,'report.purchase_analyse_report') and not listfindnocase(yasak_list,'report.purchase_analyse_report'))><li><a href="#request.self#?fuseaction=report.purchase_analyse_report"><cf_get_lang dictionary_id='30103.Alış Analizi Fatura'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.purchase_analyse_report_ship') and not listfindnocase(yasak_list,'report.purchase_analyse_report_ship') and fusebox.use_period)><li><a href="#request.self#?fuseaction=report.purchase_analyse_report_ship"><cf_get_lang dictionary_id='30079.Alış Analizi İrsaliye'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.purchase_analyse_report_orders') and not listfindnocase(yasak_list,'report.purchase_analyse_report_orders'))><li><a href="#request.self#?fuseaction=report.purchase_analyse_report_orders"><cf_get_lang dictionary_id='38900.Alış Analizi Sipariş'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.import_order_analyse') and fusebox.use_period and not listfindnocase(yasak_list,'report.import_order_analyse'))><li> <a href="#request.self#?fuseaction=report.import_order_analyse"><cf_get_lang dictionary_id='39181.İthalat Sipariş Takip Raporu'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.import_order_analyse') and fusebox.use_period and not listfindnocase(yasak_list,'report.import_product_report'))><li> <a href="#request.self#?fuseaction=report.import_product_report"><cf_get_lang dictionary_id='39184.İthal Edilen Ürün Takip Raporu'></a></li></cfif>
                            </ul>
                        </li>
                    </ul>
                </cfif>
                <cfif (is_module_authority eq 1 and get_module_user(13) or is_module_authority eq 0)>
                    <div class="pagemenus_clear"></div>
                    <ul class="pagemenus">
                        <li><strong><cf_get_lang dictionary_id='57452.Stok'>-<cf_get_lang dictionary_id='57657.Ürün'></strong>
                            <ul>
                                <cfif (not listfindnocase(denied_pages,'report.stock_analyse') and not listfindnocase(yasak_list,'report.stock_analyse') and fusebox.use_period)><li><a href="#request.self#?fuseaction=report.stock_analyse"><cf_get_lang dictionary_id='58018.Stok Analiz'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.stock_analyse_new') and not listfindnocase(yasak_list,'report.stock_analyse_new') and fusebox.use_period)><li><a href="#request.self#?fuseaction=report.stock_analyse_new"><cf_get_lang dictionary_id='58018.Stok Analiz'> <cf_get_lang dictionary_id='29731.Yeni Excel'></a></li></cfif>
                                <!--- <cfif (not listfindnocase(denied_pages,'report.stock_analyse2') and not listfindnocase(yasak_list,'report.stock_analyse2') and fusebox.use_period)><li><a href="#request.self#?fuseaction=report.stock_analyse2"><cf_get_lang dictionary_id='606.Stok Analiz'>2</a></li></cfif> --->
                                <cfif (not listfindnocase(denied_pages,'report.stock_profile') and not listfindnocase(yasak_list,'report.stock_profile') and fusebox.use_period)><li><a href="#request.self#?fuseaction=report.stock_profile"><cf_get_lang dictionary_id='39583.Stok Profil Raporu'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.list_negative_stock') and not listfindnocase(yasak_list,'report.list_negative_stock') and fusebox.use_period)><li><a href="#request.self#?fuseaction=report.list_negative_stock"><cf_get_lang dictionary_id='39768.Negatif stok raporu'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.ship_dispatch_report') and not listfindnocase(yasak_list,'report.ship_dispatch_report') and fusebox.use_period)><li><a href="#request.self#?fuseaction=report.ship_dispatch_report"><cf_get_lang dictionary_id='39431.Depo Sevk Ürün Bazlı'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.detail_product_report') and not listfindnocase(yasak_list,'report.detail_product_report'))><li><a href="#request.self#?fuseaction=report.detail_product_report"><cf_get_lang dictionary_id='39584.Detaylı Ürün Raporu'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.consigment_analyse_report') and not listfindnocase(yasak_list,'report.consigment_analyse_report') and fusebox.use_period)><li><a href="#request.self#?fuseaction=report.consigment_analyse_report"><cf_get_lang dictionary_id ='58453.Konsinye Raporu'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.product_catalog') and not listfindnocase(yasak_list,'report.product_catalog'))><li><a href="#request.self#?fuseaction=report.product_catalog"><cf_get_lang dictionary_id='38946.Ürün Kataloğu'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.nosale_products_report') and not listfindnocase(yasak_list,'report.nosale_products_report'))><li><a href="#request.self#?fuseaction=report.nosale_products_report"><cf_get_lang dictionary_id='38947.Hareket Görmeyen Ürün Raporu'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.close_period_inventory_report') and not listfindnocase(yasak_list,'report.close_period_inventory_report'))><li><a href="#request.self#?fuseaction=report.close_period_inventory_report"><cf_get_lang dictionary_id='40756.Dönem Kapama Envanteri Raporu'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.product_action_search') and not listfindnocase(yasak_list,'report.product_action_search'))><li><a href="#request.self#?fuseaction=report.product_action_search"><cf_get_lang dictionary_id='39063.Ürün Aksiyon Rapaoru'></a></li></cfif>
                            </ul>
                        </li>
                    </ul>		
                </cfif>
            </cfif>
        </div>
        <div style="float:left;">
        	<cfif fusebox.use_period eq 1>
				<cfif is_module_authority eq 1 and get_module_user(13) or is_module_authority eq 0>
                    <ul class="pagemenus">
                        <li><cfif (not listfindnocase(denied_pages,'report.sale_analyse_report') and  fusebox.use_period and not listfindnocase(yasak_list,'report.sale_analyse_report'))><strong><cf_get_lang dictionary_id='38896.Sevkiyat'></strong></cfif>
                            <ul>
                                <cfif (not listfindnocase(denied_pages,'report.ship_result_analyse_report') and not listfindnocase(yasak_list,'report.ship_result_analyse_report') and fusebox.use_period)><li><a href="#request.self#?fuseaction=report.ship_result_analyse_report"><cf_get_lang dictionary_id='39027.Detaylı Sevkiyat Analizi'></a></li></cfif>
                                <!---
                                <cfif is_ship_result_analyse2>
                                    <cfif (not listfindnocase(denied_pages,'report.ship_result_analyse2_report') and not listfindnocase(yasak_list,'report.ship_result_analyse2_report') and fusebox.use_period)><li><a href="#request.self#?fuseaction=report.ship_result_analyse2_report"><cf_get_lang dictionary_id='306.Detaylı Sevkiyat Analizi'> 2</a><li></cfif>
                                </cfif>
                                --->
                            </ul>
                         </li>
                    </ul>
                </cfif>
                <cfif (is_module_authority eq 1 and get_module_user(20)  or is_module_authority eq 0) or (is_module_authority eq 1 and get_module_user(11) or is_module_authority eq 0)>
                    <div class="pagemenus_clear"></div>
                    <ul class="pagemenus">
                        <li><strong><cf_get_lang dictionary_id='57448.Satış'></strong>
                            <ul>
                                <cfif (not listfindnocase(denied_pages,'report.sale_analyse_report') and  fusebox.use_period and not listfindnocase(yasak_list,'report.sale_analyse_report'))><li><a href="#request.self#?fuseaction=report.sale_analyse_report"><cf_get_lang dictionary_id='39029.Satış Analiz Fatura'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.sale_analyse_report_ship') and  fusebox.use_period and not listfindnocase(yasak_list,'report.sale_analyse_report_ship'))><li><a href="#request.self#?fuseaction=report.sale_analyse_report_ship"><cf_get_lang dictionary_id='39030.Satış Analiz İrsaliye'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.sale_analyse_report_orders') and  fusebox.use_period and not listfindnocase(yasak_list,'report.sale_analyse_report_orders'))><li><a href="#request.self#?fuseaction=report.sale_analyse_report_orders"><cf_get_lang dictionary_id='30072.Satış Analiz Sipariş'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.detail_sale_offer_report') and  fusebox.use_period and not listfindnocase(yasak_list,'report.detail_sale_offer_report'))><li><a href="#request.self#?fuseaction=report.detail_sale_offer_report"><cf_get_lang dictionary_id='38978.Teklif Raporu'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.detail_opportunity_report') and not listfindnocase(yasak_list,'report.detail_opportunity_report') and fusebox.use_period)><li><a href="#request.self#?fuseaction=report.detail_opportunity_report"><cf_get_lang dictionary_id='39586.Fırsat Raporu'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.sale_stock_analyse_orders') and  fusebox.use_period and not listfindnocase(yasak_list,'report.sale_stock_analyse_orders'))><li><a href="#request.self#?fuseaction=report.sale_stock_analyse_orders"><cf_get_lang dictionary_id='38995.Sipariş ve Karlılık Analizi'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.detail_visit_report') and not listfindnocase(yasak_list,'report.detail_visit_report'))><li><a href="#request.self#?fuseaction=report.detail_visit_report"><cf_get_lang dictionary_id='39587.Detaylı Ziyaret Raporu'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.detail_income_analyse_report') and not listfindnocase(yasak_list,'report.detail_income_analyse_report'))><li><a href="#request.self#?fuseaction=report.detail_income_analyse_report"><cf_get_lang dictionary_id='40713.Detaylı Gelir Analiz Raporu'></a></li></cfif> 
                                <cfif (not listfindnocase(denied_pages,'report.daily_total_sales') and fusebox.use_period and not listfindnocase(yasak_list,'report.daily_total_sales'))><li><a href="#request.self#?fuseaction=report.daily_total_sales"><cf_get_lang dictionary_id='39588.Günlere Göre Satış Özeti'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.category_base_sale_analyse_report') and fusebox.use_period and not listfindnocase(yasak_list,'report.category_base_sale_analyse_report'))><li><a href="#request.self#?fuseaction=report.category_base_sale_analyse_report"><cf_get_lang dictionary_id='39636.Kategori Bazında Satış Analiz Raporu'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.sales_quota_analyse') and fusebox.use_period and not listfindnocase(yasak_list,'report.category_base_sale_analyse_report'))><li><a href="#request.self#?fuseaction=report.sales_quota_analyse"><cf_get_lang dictionary_id='39004.Kota ve Satış Analizi'></a></li></cfif>
                            </ul>
                       </li>
                   </ul>
                </cfif>
                <cfif (is_module_authority eq 1 and get_module_user(16) or is_module_authority eq 0)>
                    <div class="pagemenus_clear"></div>
                    <ul class="pagemenus">
                        <li><strong><cf_get_lang dictionary_id='57689.Risk'><cf_get_lang dictionary_id='57989.ve'><cf_get_lang dictionary_id='57845.Tahsilat'></strong>
                            <ul>
                                <cfif (not listfindnocase(denied_pages,'report.risc_analys') and not listfindnocase(yasak_list,'report.risc_analys') and fusebox.use_period)><li><a href="#request.self#?fuseaction=report.risc_analys"><cf_get_lang dictionary_id='39435.Risk Analizi'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.revenue_analysis') and not listfindnocase(yasak_list,'report.revenue_analysis') and fusebox.use_period)><li><a href="#request.self#?fuseaction=report.revenue_analysis"><cf_get_lang dictionary_id='39589.Tahsilat ve Ödeme Analizi'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.daily_revenue_analyse') and not listfindnocase(yasak_list,'report.daily_revenue_analyse') and fusebox.use_period)><li><a href="#request.self#?fuseaction=report.daily_revenue_analyse"> <cf_get_lang dictionary_id='39638.Tahsilat Tahmin Analizi'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.cheque_currency_control') and not listfindnocase(yasak_list,'report.cheque_currency_control') and fusebox.use_period)><li><a href="#request.self#?fuseaction=report.cheque_currency_control"> <cf_get_lang dictionary_id='39640.Çek Tahsil ve Ciro Kur Farkları'></a></li></cfif>
                                <cfif session.ep.our_company_info.is_paper_closer eq 1>
                                <cfif (not listfindnocase(denied_pages,'report.company_payment_list') and not listfindnocase(yasak_list,'report.company_payment_list') and fusebox.use_period)><li><a href="#request.self#?fuseaction=report.company_payment_list"> <cf_get_lang dictionary_id='39639.Müşteri Ödeme Listesi'></a></li></cfif>
                                </cfif>
                                <cfif (not listfindnocase(denied_pages,'report.cheque_voucher_analyse') and not listfindnocase(yasak_list,'report.cheque_voucher_analyse') and fusebox.use_period)><li><a href="#request.self#?fuseaction=report.cheque_voucher_analyse"> <cf_get_lang dictionary_id='39637.Çek Senet Analizi'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.monthly_total_revenue') and not listfindnocase(yasak_list,'report.monthly_total_revenue') and fusebox.use_period)><li><a href="#request.self#?fuseaction=report.monthly_total_revenue"><cf_get_lang dictionary_id='39009.Aylara Göre Tahsilat Analizi'></a></li></cfif>
                                <cfif not listfindnocase(denied_pages,'report.detail_pos_operation_report') and not listfindnocase(yasak_list,'report.detail_pos_operation_report') and fusebox.use_period><li><a href="#request.self#?fuseaction=report.detail_pos_operation_report"> <cf_get_lang dictionary_id='39610.Otomatik Sanal Pos Analizi'></a></li></cfif>
                                <cfif not listfindnocase(denied_pages,'report.detail_credit_report') and not listfindnocase(yasak_list,'report.detail_credit_report') and fusebox.use_period><li><a href="#request.self#?fuseaction=report.detail_credit_report"> <cf_get_lang dictionary_id='40433.Detaylı Kredi Analizi'></a></li></cfif>
                                <cfif not listfindnocase(denied_pages,'report.dbs_report') and not listfindnocase(yasak_list,'report.dbs_report') and fusebox.use_period><li><a href="#request.self#?fuseaction=report.dbs_report"> <cf_get_lang dictionary_id='59170.DBS Analizi'></a></li></cfif>
                            </ul>
                        </li>
                    </ul>
                </cfif>
            </cfif>
			<cfif (is_module_authority eq 1 and get_module_user(34) or is_module_authority eq 0)>
                <div class="pagemenus_clear"></div>
                <ul class="pagemenus">
                    <li><strong><cf_get_lang dictionary_id='57419.Eğitim'></strong>
                        <ul>
                            <cfif (not listfindnocase(denied_pages,'report.training_analyse_report') and not listfindnocase(yasak_list,'report.training_analyse_report'))><li><a href="#request.self#?fuseaction=report.training_analyse_report"><cf_get_lang dictionary_id='39032.Eğitim Analiz'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.training_analyse_function_report') and not listfindnocase(yasak_list,'report.training_analyse_function_report'))><li><a href="#request.self#?fuseaction=report.training_analyse_function_report"><cf_get_lang dictionary_id='39590.Fonksiyon Ve Eğitim Bazlı Analiz'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.training_maliyet') and not listfindnocase(yasak_list,'report.training_maliyet'))><li><a href="#request.self#?fuseaction=report.training_maliyet"><cf_get_lang dictionary_id='39591.Şube Bazlı Eğitim Maliyetleri'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.training_type_maliyet') and not listfindnocase(yasak_list,'report.training_type_maliyet'))><li><a href="#request.self#?fuseaction=report.training_type_maliyet"><cf_get_lang dictionary_id='39592.Eğitim Şekline Göre Eğitim Maliyetleri'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.scorm_content_analyse_report') and not listfindnocase(yasak_list,'report.scorm_content_analyse_report'))><li><a href="#request.self#?fuseaction=report.scorm_content_analyse_report"><cf_get_lang dictionary_id='39078.Scorm Raporu'></a></li></cfif>
                        	<cfif (not listfindnocase(denied_pages,'report.training_orientation_report') and not listfindnocase(yasak_list,'report.training_orientation_report'))><li><a href="#request.self#?fuseaction=report.training_orientation_report"><cf_get_lang dictionary_id='47826.Oryantasyon Eğitimleri Raporu'></a></li></cfif>
                        </ul>
                   </li>
                </ul>
            </cfif>	
			<cfif fusebox.use_period eq 1 and (is_module_authority eq 1 and get_module_user(22) or is_module_authority eq 0)>
                <div class="pagemenus_clear"></div>
                <ul class="pagemenus">
                    <li><strong><cf_get_lang dictionary_id='57447.Muhasebe'></strong>
                        <ul>
                            <cfif (not listfindnocase(denied_pages,'report.list_account_plan_report') and not listfindnocase(yasak_list,'report.list_account_plan_report') and fusebox.use_period)><li><a href="#request.self#?fuseaction=report.list_account_plan_report"><cf_get_lang dictionary_id='40684.Hesap Planı Raporu'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.rapor_yevmiye') and not listfindnocase(yasak_list,'report.rapor_yevmiye') and fusebox.use_period)><li><a href="#request.self#?fuseaction=report.rapor_yevmiye"><cf_get_lang dictionary_id='39033.Yevmiye Raporu'></a></li></cfif>
                            <!--- <cfif (not listfindnocase(denied_pages,'report.borc_alacak_tutmayanlar') and not listfindnocase(yasak_list,'report.borc_alacak_tutmayanlar') and fusebox.use_period)><li><a href="#request.self#?fuseaction=report.borc_alacak_tutmayanlar"><cf_get_lang dictionary_id='440.Borç Alacak Tutmayan Muhasebe Fişleri'></a></li></cfif> --->
                            <cfif (not listfindnocase(denied_pages,'report.company_account_code')  and not listfindnocase(yasak_list,'report.company_account_code') and fusebox.use_period)><li><a href="#request.self#?fuseaction=report.company_account_code"><cf_get_lang dictionary_id='39162.Cari ve Muhasebe Kodları'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.rapor_kebir') and not listfindnocase(yasak_list,'report.rapor_kebir') and fusebox.use_period)><li><a href="#request.self#?fuseaction=report.rapor_kebir"><cf_get_lang dictionary_id='39163.Defter-i Kebir'>(<cf_get_lang dictionary_id='39164.Hesap Seçimli'>)</a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.mizan_raporu') and not listfindnocase(yasak_list,'report.mizan_raporu') and fusebox.use_period)><li><a href="#request.self#?fuseaction=report.mizan_raporu"><cf_get_lang dictionary_id='39165.Mizan Raporu'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.rapor_muavin') and not listfindnocase(yasak_list,'report.rapor_muavin') and fusebox.use_period)><li><a href="#request.self#?fuseaction=report.rapor_muavin"><cf_get_lang dictionary_id='39166.Muavin Defter Raporu'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.product_account_code') and not listfindnocase(yasak_list,'report.product_account_code') and fusebox.use_period)><li><a href="#request.self#?fuseaction=report.product_account_code"><cf_get_lang dictionary_id='39167.Ürün Muhasebe Kodları'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.ratio_report') and not listfindnocase(yasak_list,'report.ratio_report') and fusebox.use_period)><li><a href="#request.self#?fuseaction=report.ratio_report"><cf_get_lang dictionary_id='39585.Rasyo'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.detail_inventory_report') and not listfindnocase(yasak_list,'report.detail_inventory_report') and fusebox.use_period)><li><a href="#request.self#?fuseaction=report.detail_inventory_report"><cf_get_lang dictionary_id='58478.Sabit Kıymet'> <cf_get_lang dictionary_id='39666.Analizi'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.report_ba_bs') and not listfindnocase(yasak_list,'report.report_ba_bs'))><li><a href="#request.self#?fuseaction=report.report_ba_bs"><cf_get_lang dictionary_id='39028.BA-BS Raporları'></a></li></cfif>
                            <cfif (not listfindnocase(denied_pages,'report.muhtasar_beyanname') and not listfindnocase(yasak_list,'report.muhtasar_beyanname'))><li><a href="#request.self#?fuseaction=report.muhtasar_beyanname"><cf_get_lang dictionary_id='47453.Muhtasar Beyannamesi'></a></li></cfif>
                        </ul>
                    </li>
                </ul>
            </cfif>	
        </div>
        <cfif fusebox.use_period eq 1>	
            <div style="float:left;">   
                <cfif (is_module_authority eq 1 and get_module_user(11) or is_module_authority eq 0)>
                    <div class="pagemenus_clear"></div>
                    <ul class="pagemenus">
                        <li><strong><cf_get_lang dictionary_id='58832.Abone'></strong>
                            <ul>
                                <cfif (not listfindnocase(denied_pages,'report.system_analyse_report') and not listfindnocase(yasak_list,'report.system_analyse_report'))><li><a href="#request.self#?fuseaction=report.system_analyse_report"><cf_get_lang dictionary_id='39571.Abone Analizi Raporu'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.subscription_payment_plan_report') and not listfindnocase(yasak_list,'report.subscription_payment_plan_report'))><li><a href="#request.self#?fuseaction=report.subscription_payment_plan_report"><cf_get_lang dictionary_id='40076.Abone Ödeme Planı Raporu'></a></li></cfif>
                            </ul>
                        </li>
                    </ul>
                </cfif>
                <cfif (is_module_authority eq 1 and get_module_user(6) or is_module_authority eq 0)>
                    <div class="pagemenus_clear"></div>
                    <ul class="pagemenus">
                        <li><strong><cf_get_lang dictionary_id='57415.Ajanda'></strong>
                            <ul>
                                <cfif (not listfindnocase(denied_pages,'report.agenda_rapor') and not listfindnocase(yasak_list,'report.agenda_rapor'))><li><a href="#request.self#?fuseaction=report.agenda_rapor"><cf_get_lang dictionary_id='39071.Olay Analiz Raporu'></a></li></cfif>
                            </ul>
                        </li>
                    </ul>
                </cfif>
                <cfif (is_module_authority eq 1 and get_module_user(20) or is_module_authority eq 0)>
                    <div class="pagemenus_clear"></div>
                    <ul class="pagemenus">
                        <li><strong><cf_get_lang dictionary_id='57441.Fatura'></strong>
                            <ul>
                                <cfif (not listfindnocase(denied_pages,'report.invoice_list_sale') and fusebox.use_period and not listfindnocase(yasak_list,'report.invoice_list_sale'))><li><a href="#request.self#?fuseaction=report.invoice_list_sale"><cf_get_lang dictionary_id='39169.Fatura Listesi Satışlar'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.invoice_list_purchase') and fusebox.use_period and not listfindnocase(yasak_list,'report.invoice_list_purchase'))><li><a href="#request.self#?fuseaction=report.invoice_list_purchase"><cf_get_lang dictionary_id='39405.Fatura Listesi Alışlar'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.invoice_list_purchase_new') and fusebox.use_period and not listfindnocase(yasak_list,'report.invoice_list_purchase_new'))><li><a href="#request.self#?fuseaction=report.invoice_list_purchase_new"><cf_get_lang dictionary_id='39405.Fatura Listesi Alışlar Yeni'></a></li></cfif>                     
				<cfif (not listfindnocase(denied_pages,'report.kdv_report_with_month') and fusebox.use_period and not listfindnocase(yasak_list,'report.kdv_report_with_month'))><li><a href="#request.self#?fuseaction=report.kdv_report_with_month"><cf_get_lang dictionary_id='29675.Aylara Göre'> <cf_get_lang dictionary_id ='57639.KDV'> <cf_get_lang dictionary_id ='56858.Raporu'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.create_hobby_document') and fusebox.use_period and not listfindnocase(yasak_list,'report.create_hobby_document'))><li><a href="#request.self#?fuseaction=report.create_hobby_document"><cf_get_lang dictionary_id='39013.Hobim Dosyasi Olusturma'></a></li></cfif>
                            </ul>
                        </li>
                    </ul>
                </cfif>	
                <cfif (is_module_authority eq 1 and get_module_user(4) or is_module_authority eq 0)>
                    <div class="pagemenus_clear"></div>
                    <ul class="pagemenus">
                        <li><strong><cf_get_lang dictionary_id='57658.Üye'></strong>
                            <ul>
                                <cfif (not listfindnocase(denied_pages,'report.etkilesim_rapor') and not listfindnocase(yasak_list,'report.etkilesim_rapor'))><li><a href="#request.self#?fuseaction=report.etkilesim_rapor"><cf_get_lang dictionary_id='39436.Etkileşim Raporu'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.interaction_content_report') and not listfindnocase(yasak_list,'report.interaction_content_report'))><li><a href="#request.self#?fuseaction=report.interaction_content_report"><cf_get_lang dictionary_id ='40702.Etkileşim İçerik Raporu'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.bsc_company') and fusebox.use_period and not listfindnocase(yasak_list,'report.bsc_company'))><li><a href="#request.self#?fuseaction=report.bsc_company"><cf_get_lang dictionary_id='39437.BSC Raporu'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.report_target_market') and not listfindnocase(yasak_list,'report.report_target_market'))><li><a href="#request.self#?fuseaction=report.report_target_market"><cf_get_lang dictionary_id='39438.Detaylı Hedef Kitle Raporu'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.detayli_uye_analizi_raporu') and not listfindnocase(yasak_list,'report.detayli_uye_analizi_raporu'))><li><a href="#request.self#?fuseaction=report.detayli_uye_analizi_raporu"><cf_get_lang dictionary_id='39540.Detaylı Üye Analizi Raporu'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.activity_summary') and fusebox.use_period and not listfindnocase(yasak_list,'report.activity_summary'))><li><a href="#request.self#?fuseaction=report.activity_summary"><cf_get_lang dictionary_id='57921.Cari Faaliyet Özeti'></a></li></cfif>				
                                <cfif (not listfindnocase(denied_pages,'report.compare_activity_summary') and fusebox.use_period and not listfindnocase(yasak_list,'report.compare_activity_summary'))><li><a href="#request.self#?fuseaction=report.compare_activity_summary"><cf_get_lang dictionary_id='39593.Karşılaştırmalı Cari Faaliyet Özeti'></a></li></cfif>				
                                <cfif (not listfindnocase(denied_pages,'report.monthly_debit_claim_report') and fusebox.use_period and not listfindnocase(yasak_list,'report.monthly_debit_claim_report'))><li><a href="#request.self#?fuseaction=report.monthly_debit_claim_report"><cf_get_lang dictionary_id='39661.Borç/Alacak Aylara Göre Adatlandırılmış Rapor'></a></li></cfif>				
                                <cfif (not listfindnocase(denied_pages,'report.collacted_make_age_report') and fusebox.use_period and not listfindnocase(yasak_list,'report.collacted_make_age_report'))><li><a href="#request.self#?fuseaction=report.collacted_make_age_report"><cf_get_lang dictionary_id='39777.Toplu Ödeme Performansı'></a></li></cfif>				
                            </ul>
                        </li>
                    </ul>
                </cfif>
                <cfif (is_module_authority eq 1 and get_module_user(1) or is_module_authority eq 0)>
                    <div class="pagemenus_clear"></div>
                    <ul class="pagemenus">
                        <li><strong><cf_get_lang dictionary_id='57416.Proje'></strong>
                            <ul>
                                <cfif (not listfindnocase(denied_pages,'report.pro_material_result') and not listfindnocase(yasak_list,'report.pro_material_result'))><li><a href="#request.self#?fuseaction=report.pro_material_result"><cf_get_lang dictionary_id='39439.Proje Malzeme Raporu'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.project_accounts_report') and not listfindnocase(yasak_list,'report.project_accounts_report') and fusebox.use_period)><li><a href="#request.self#?fuseaction=report.project_accounts_report"><cf_get_lang dictionary_id='39568.Proje İcmal Raporu'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.project_works_report') and not listfindnocase(yasak_list,'report.project_works_report') and fusebox.use_period)><li><a href="#request.self#?fuseaction=report.project_works_report"><cf_get_lang dictionary_id ='39925.Proje İş Raporu'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.detail_report_project') and not listfindnocase(yasak_list,'report.detail_report_project') and fusebox.use_period)><li><a href="#request.self#?fuseaction=report.detail_report_project"><cf_get_lang dictionary_id ='39428.Proje Raporu'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.detail_project_account_report') and not listfindnocase(yasak_list,'report.detail_project_account_report') and fusebox.use_period)><li> <a href="#request.self#?fuseaction=report.detail_project_account_report"><cf_get_lang dictionary_id ='40052.Proje Muhasebe Kodları Raporu'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.kanban_board') and not listfindnocase(yasak_list,'report.kanban_board') and fusebox.use_period)><li> <a href="#request.self#?fuseaction=report.kanban_board"><cf_get_lang dictionary_id ='38272.Kanban'></a></li></cfif>
                            </ul>
                        </li>
                    </ul>
                </cfif>					
                <cfif (is_module_authority eq 1 and get_module_user(35) or is_module_authority eq 0)>
                    <div class="pagemenus_clear"></div>
                    <ul class="pagemenus">
                        <li><strong><cf_get_lang dictionary_id='58464.Üretim Planlama'>/<cf_get_lang dictionary_id='57456.Üretim'></strong>
                            <ul>
                                <cfif (not listfindnocase(denied_pages,'report.detail_product_tree_report') and not listfindnocase(yasak_list,'report.detail_product_tree_report'))><li><a href="#request.self#?fuseaction=report.detail_product_tree_report"><cf_get_lang dictionary_id ='39926.Ürün Ağacı Raporu'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.related_product_tree_report') and not listfindnocase(yasak_list,'report.related_product_tree_report'))><li><a href="#request.self#?fuseaction=report.related_product_tree_report"><cf_get_lang dictionary_id ='39182.ilişkili Ürün Ağacı Raporu'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.production_program_report') and not listfindnocase(yasak_list,'report.production_program_report'))><li><a href="#request.self#?fuseaction=report.production_program_report"><cf_get_lang dictionary_id='40720.Üretim Programı'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.production_analyse') and not listfindnocase(yasak_list,'report.production_analyse'))><li><a href="#request.self#?fuseaction=report.production_analyse"><cf_get_lang dictionary_id='39594.Üretim Sonuç Analizi'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.production_pause_report') and not listfindnocase(yasak_list,'report.production_pause_report'))><li><a href="#request.self#?fuseaction=report.production_pause_report"><cf_get_lang dictionary_id='40721.Duraklama Raporu'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.workstations_expense_seller_report') and not listfindnocase(yasak_list,'report.workstations_expense_seller_report'))><li><a href="#request.self#?fuseaction=report.workstations_expense_seller_report"><cf_get_lang dictionary_id='40759.İş İstasyonları Gider Dağıtım Raporu'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.product_expense_seller_report') and not listfindnocase(yasak_list,'report.product_expense_seller_report'))><li><a href="#request.self#?fuseaction=report.product_expense_seller_report"><cf_get_lang dictionary_id='40758.Ürün Gider Dağıtım Raporu'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.product_cost_report') and not listfindnocase(yasak_list,'report.product_cost_report'))><li><a href="#request.self#?fuseaction=report.product_cost_report"><cf_get_lang dictionary_id='40757.Ürün Maliyet Raporu'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.improper_product_report') and not listfindnocase(yasak_list,'report.improper_product_report') and fusebox.use_period)><li><a href="#request.self#?fuseaction=report.improper_product_report"><cf_get_lang dictionary_id ='39185.Uygun Olmayan Ürün Raporu'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.quality_control_report') and not listfindnocase(yasak_list,'report.quality_control_report') and fusebox.use_period)><li><a href="#request.self#?fuseaction=report.quality_control_report">&nbsp;<cf_get_lang dictionary_id ='40589.Kalite Kontrol Raporu'></a></li></cfif>
                            </ul>
                        </li>
                    </ul>
                </cfif>
                <cfif (is_module_authority eq 1 and get_module_user(49) or is_module_authority eq 0) or (is_module_authority eq 1 and get_module_user(1) or is_module_authority eq 0)>
                    <div class="pagemenus_clear"></div>
                    <ul class="pagemenus">
                        <li><strong><cf_get_lang dictionary_id='58930.Masraf'></strong>
                            <ul>
                                <cfif (not listfindnocase(denied_pages,'report.cost_analyse_report') and fusebox.use_period and not listfindnocase(yasak_list,'report.cost_analyse_report'))><li><a href="#request.self#?fuseaction=report.cost_analyse_report"><cf_get_lang dictionary_id='38902.Detaylı Harcama Analiz'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.time_cost_report') and not listfindnocase(yasak_list,'report.time_cost_report'))><li><a href="#request.self#?fuseaction=report.time_cost_report"><cf_get_lang dictionary_id='39433.Zaman Harcamaları Raporu'></a></li></cfif>
                            </ul>
                        </li>
                    </ul>
                </cfif>
                <cfif (is_module_authority eq 1 and get_module_user(32) or is_module_authority eq 0)>
                    <cfif fusebox.use_period>
                        <div class="pagemenus_clear"></div>
                        <ul class="pagemenus">
                            <li><strong><cf_get_lang dictionary_id='57453.Şube'></strong>
                                <ul>
                                    <cfif (not listfindnocase(denied_pages,'report.ship_report') and not listfindnocase(yasak_list,'report.ship_report'))><li><a href="#request.self#?fuseaction=report.ship_report"><cf_get_lang dictionary_id='39026.İrsaliye Raporu'></a></li></cfif>
                                </ul>
                            </li>
                        </ul>      
                    </cfif>
                </cfif>
                <cfif (is_module_authority eq 1 and get_module_user(46) or is_module_authority eq 0)>
                    <div class="pagemenus_clear"></div>
                    <ul class="pagemenus">
                        <li><strong><cf_get_lang dictionary_id='57559.Bütçe'></strong>
                            <ul>
                                <cfif (not listfindnocase(denied_pages,'report.detail_budget_report') and not listfindnocase(yasak_list,'report.detail_budget_report'))><li><a href="#request.self#?fuseaction=report.detail_budget_report"><cf_get_lang dictionary_id='29445.Bütçe Raporu'></a></li></cfif>
                            </ul>
                        </li>
                    </ul>
                </cfif>
        	</div>
       	</cfif>
        <div style="float:left;"> 
        	<cfif fusebox.use_period eq 1>   
				<cfif (is_module_authority eq 1 and get_module_user(14) or is_module_authority eq 0)>
                    <ul class="pagemenus">
                        <li><strong><cf_get_lang dictionary_id='57656.Servis'></strong>
                            <ul>
                                <cfif (not listfindnocase(denied_pages,'report.service_analyse_report') and not listfindnocase(yasak_list,'report.service_analyse_report'))><li><a href="#request.self#?fuseaction=report.service_analyse_report"><cf_get_lang dictionary_id='38903.Detaylı Servis Analizi'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.serial_report') and not listfindnocase(yasak_list,'report.serial_report'))><li><a href="#request.self#?fuseaction=report.serial_report"><cf_get_lang dictionary_id='39037.Detaylı Seri Raporu'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.serial_control_report') and not listfindnocase(yasak_list,'report.serial_control_report'))><li><a href="#request.self#?fuseaction=report.serial_control_report"><cf_get_lang dictionary_id='39038.Seri Kontrol Raporu'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.customer_points') and not listfindnocase(yasak_list,'report.customer_points'))><li><a href="#request.self#?fuseaction=report.customer_points"><cf_get_lang dictionary_id='58223.Puan Raporu'></a></li></cfif>
                            </ul>
                        </li>
                    </ul>
                </cfif>
                <cfif (is_module_authority eq 1 and get_module_user(2) or is_module_authority eq 0)>
                    <div class="pagemenus_clear"></div>
                    <ul class="pagemenus">
                        <li><strong><cf_get_lang dictionary_id='57653.İçerik'></strong>
                            <ul>
                                <cfif (not listfindnocase(denied_pages,'report.content_report') and not listfindnocase(yasak_list,'report.content_report'))><li><a href="#request.self#?fuseaction=report.content_report"><cf_get_lang dictionary_id='39595.İçerik Raporu'></a></li></cfif>
                                <cfif session.ep.our_company_info.sms eq 1 and (not listfindnocase(denied_pages,'report.report_sms') and not listfindnocase(yasak_list,'report.report_sms'))><li><a href="#request.self#?fuseaction=report.report_sms"><cf_get_lang dictionary_id ='39920.SMS Raporu'></a></li></cfif>
                            </ul>
                        </li>
                    </ul>
                </cfif>
                <cfif (is_module_authority eq 1 and get_module_user(7) or is_module_authority eq 0)>
                    <div class="pagemenus_clear"></div>
                    <ul class="pagemenus">
                        <li><strong><cf_get_lang dictionary_id='58151.Güvenlik'></strong>
                            <ul>
                                <cfif (not listfindnocase(denied_pages,'report.security_report') and not listfindnocase(yasak_list,'report.security_report'))><li><a href="#request.self#?fuseaction=report.security_report"><cf_get_lang dictionary_id='58044.Yetki Raporu'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.security_report_module_based') and not listfindnocase(yasak_list,'report.security_report_module_based'))><li><a href="#request.self#?fuseaction=report.security_report_module_based"><cf_get_lang dictionary_id='40680.Yetki Raporu Modül Bazında'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.security_report_process_based') and not listfindnocase(yasak_list,'report.security_report_process_based'))><li><a href="#request.self#?fuseaction=report.security_report_process_based"><cf_get_lang dictionary_id ='40681.Yetki Raporu Süreç Bazında'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.security_report_process_cat') and not listfindnocase(yasak_list,'report.security_report_process_cat'))><li><a href="#request.self#?fuseaction=report.security_report_process_cat"><cf_get_lang dictionary_id ='40682.Yetki Raporu İşlem Kategorisi Bazında'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.secure_get_bans') and not listfindnocase(yasak_list,'report.secure_get_bans'))><li><a href="#request.self#?fuseaction=report.secure_get_bans"><cf_get_lang dictionary_id='40714.Banned IP'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.failed_logins_report') and not listfindnocase(yasak_list,'report.failed_logins_report')) and isdefined("error_login_system") and error_login_system eq 1><li><a href="#request.self#?fuseaction=report.failed_logins_report"><cf_get_lang dictionary_id='54686.Hatalı'> <cf_get_lang dictionary_id='58535.Girişler'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.secure_get_attacks') and not listfindnocase(yasak_list,'report.secure_get_attacks'))><li><a href="#request.self#?fuseaction=report.secure_get_attacks"><cf_get_lang dictionary_id='40715.Attack Logs'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.visit_report') and not listfindnocase(yasak_list,'report.visit_report'))><li><a href="#request.self#?fuseaction=report.visit_report"><cf_get_lang dictionary_id='40716.Ziyaret Takip Raporu'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.visit_report_detail') and not listfindnocase(yasak_list,'report.visit_report_detail'))><li><a href="#request.self#?fuseaction=report.visit_report_detail"><cf_get_lang dictionary_id='40716.Ziyaret Takip Raporu'>(<cf_get_lang dictionary_id='29954.Genel'>)</a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.list_visit_page_count') and not listfindnocase(yasak_list,'report.list_visit_page_count'))><li><a href="#request.self#?fuseaction=report.list_visit_page_count"> <cf_get_lang dictionary_id='59162.Sayfa Ziyaret Sayısı Raporu'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.list_log_files') and not listfindnocase(yasak_list,'report.list_log_files'))><li><a href="#request.self#?fuseaction=report.list_log_files"><cf_get_lang dictionary_id='39579.Kayıt Tarihçe Raporu'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.system_login_logoff_report') and not listfindnocase(yasak_list,'report.system_login_logoff_report'))><li><a href="#request.self#?fuseaction=report.system_login_logoff_report"><cf_get_lang dictionary_id='39430.Sisteme Giriş Çıkış Takip Raporu'></a></li></cfif>
                                <cfif (not listfindnocase(denied_pages,'report.partner_public_login_report') and not listfindnocase(yasak_list,'report.partner_public_login_report'))><li><a href="#request.self#?fuseaction=report.partner_public_login_report"><cf_get_lang dictionary_id='39563.Partner Public Giriş Çıkış Raporu'></a></li></cfif>
                            </ul>
                        </li>
                    </ul>
                </cfif>
                <cfif (is_module_authority eq 1 and get_module_user(52) or is_module_authority eq 0)>
                    <div class="pagemenus_clear"></div>
                    <ul class="pagemenus">
                        <li><strong><cf_get_lang dictionary_id='57786.CRM'></strong>
                            <ul>
                                <cfif (not listfindnocase(denied_pages,'report.list_complaint') and not listfindnocase(yasak_list,'report.list_complaint'))><li><a href="#request.self#?fuseaction=report.list_complaint"><cf_get_lang dictionary_id='38722.Şikayet Raporu'></a></li></cfif>
                            </ul>
                        </li>
                    </ul>
                </cfif>
                <cfif (is_module_authority eq 1 and get_module_user(40) or is_module_authority eq 0)>
                    <div class="pagemenus_clear"></div>
                    <ul class="pagemenus">
                        <li><strong><cf_get_lang dictionary_id='57420.Varlıklar'></strong>
                            <ul>
                                <cfif (not listfindnocase(denied_pages,'report.list_assets') and not listfindnocase(yasak_list,'report.list_assets'))><li><a href="#request.self#?fuseaction=report.list_assets"><cf_get_lang dictionary_id='38984.Varlık Raporu'></a></li></cfif>
                            </ul>
                        </li>
                    </ul>
                </cfif>
          	</cfif>
            <div class="pagemenus_clear"></div>
                <ul class="pagemenus">
                    <li><strong><cf_get_lang dictionary_id='38881.Form Generator'></strong>
                        <ul>
                            <cfif (not listfindnocase(denied_pages,'report.form_generator_report') and not listfindnocase(yasak_list,'report.form_generator_report'))><li><a href="#request.self#?fuseaction=report.form_generator_report"><cf_get_lang dictionary_id='29778.Form Raporu'></a></li></cfif>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
</cfoutput>
<script src="../design/SpryAssets/left_menus/jquery.treeview.js" type="text/javascript"></script>
