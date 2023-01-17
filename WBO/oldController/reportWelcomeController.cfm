<cfif fuseaction eq "report.">
	<cfset fuseaction = "report.welcome">
</cfif>
<cf_xml_page_edit>
<br/>
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

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'report.welcome';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'report/standart/report_standart.cfm';

</cfscript>
