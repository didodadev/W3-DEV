<!--- Genel Sayfa numarasından gelmisse --->
<cfif attributes.type eq 1>
	<!--- Sirket Db deki duzenlemeler --->
	<cfif isdefined("attributes.is_upd") and fusebox.use_period eq 1>	
		<cfquery name="UPD_GENERAL_PAPERS" datasource="#DSN3#">
			UPDATE 
				GENERAL_PAPERS 
			SET  
				CAMPAIGN_NO = <cfif isdefined("attributes.campaign_no") and len(attributes.campaign_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.campaign_no#"><cfelse>NULL</cfif>,                                        
				CAMPAIGN_NUMBER = <cfif len(attributes.campaign_number) and isnumeric(attributes.campaign_number)>#attributes.campaign_number#<cfelse>NULL</cfif>,
				PROMOTION_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.promotion_no#">,                                              
				PROMOTION_NUMBER = <cfif len(attributes.promotion_number) and isnumeric(attributes.promotion_number)>#attributes.promotion_number#<cfelse>NULL</cfif>,
				CATALOG_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.catalog_no#">,                                       
				CATALOG_NUMBER = <cfif len(attributes.catalog_number) and isnumeric(attributes.catalog_number)>#attributes.catalog_number#<cfelse>NULL</cfif>,
				TARGET_MARKET_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.target_market_no#">,
				TARGET_MARKET_NUMBER = <cfif len(attributes.target_market_number) and isnumeric(attributes.target_market_number)>#attributes.target_market_number#<cfelse>NULL</cfif>,
				CAT_PROM_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cat_prom_no#">,
				CAT_PROM_NUMBER = <cfif len(attributes.cat_prom_number) and isnumeric(attributes.cat_prom_number)>#attributes.cat_prom_number#<cfelse>NULL</cfif>,
				PROD_ORDER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.prod_order_no#">,
				PROD_ORDER_NUMBER = <cfif len(attributes.prod_order_number) and isnumeric(attributes.prod_order_number)>#attributes.prod_order_number#<cfelse>NULL</cfif>,
				PRODUCTION_LOT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.production_lot_no#">,
				PRODUCTION_LOT_NUMBER = <cfif len(attributes.production_lot_number) and isnumeric(attributes.production_lot_number)>#attributes.production_lot_number#<cfelse>NULL</cfif>,
				SUPPORT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.support_no#">,
				SUPPORT_NUMBER = <cfif len(attributes.support_number) and isnumeric(attributes.support_number)>#attributes.support_number#<cfelse>NULL</cfif>,
				OPPORTUNITY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.opp_no#">,
				OPPORTUNITY_NUMBER = <cfif len(attributes.opp_number) and isnumeric(attributes.opp_number)>#attributes.opp_number#<cfelse>NULL</cfif>,
				SERVICE_APP_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.service_app_no#">,
				SERVICE_APP_NUMBER = <cfif len(attributes.service_app_number) and isnumeric(attributes.service_app_number)>#attributes.service_app_number#<cfelse>NULL</cfif>,
				STOCK_FIS_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.stock_fis_no#">,
				STOCK_FIS_NUMBER = <cfif len(attributes.stock_fis_number) and isnumeric(attributes.stock_fis_number)>#attributes.stock_fis_number#<cfelse>NULL</cfif>,
				SHIP_FIS_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ship_fis_no#">,
				SHIP_FIS_NUMBER = <cfif len(attributes.ship_fis_number) and isnumeric(attributes.ship_fis_number)>#attributes.ship_fis_number#<cfelse>NULL</cfif>,
				SUBSCRIPTION_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.subscription_no#">,
				SUBSCRIPTION_NUMBER = <cfif len(attributes.subscription_number) and isnumeric(attributes.subscription_number)>#attributes.subscription_number#,<cfelse>NULL,</cfif>
				PRODUCTION_RESULT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.production_result_no#">,
				PRODUCTION_RESULT_NUMBER = <cfif len(attributes.production_result) and isnumeric(attributes.production_result)>#attributes.production_result#<cfelse>NULL</cfif>,
				CREDIT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.credit_no#">,
				CREDIT_NUMBER = <cfif len(attributes.credit_number) and isnumeric(attributes.credit_number)>#attributes.credit_number#<cfelse>NULL</cfif>,
                CREDIT_REVENUE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.credit_revenue_no#">,
				CREDIT_REVENUE_NUMBER = <cfif len(attributes.credit_revenue_number) and isnumeric(attributes.credit_revenue_number)>#attributes.credit_revenue_number#<cfelse>NULL</cfif>,
                CREDIT_PAYMENT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.credit_payment_no#">,
				CREDIT_PAYMENT_NUMBER = <cfif len(attributes.credit_payment_number) and isnumeric(attributes.credit_payment_number)>#attributes.credit_payment_number#<cfelse>NULL</cfif>,
				PRO_MATERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.pro_material_no#">,
				PRO_MATERIAL_NUMBER = <cfif len(attributes.pro_material_number) and isnumeric(attributes.pro_material_number)>#attributes.pro_material_number#,<cfelse>NULL,</cfif>
				INTERNAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#internal_no#">,
				INTERNAL_NUMBER = <cfif len(attributes.internal_number) and isnumeric(attributes.internal_number)>#attributes.internal_number#<cfelse>NULL</cfif>,
				CORRESPONDENCE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#correspondence_no#">,
				CORRESPONDENCE_NUMBER = <cfif len(attributes.correspondence_number) and isnumeric(attributes.correspondence_number)>#attributes.correspondence_number#<cfelse>NULL</cfif>,
				PURCHASEDEMAND_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#purchasedemand_no#">,
				PURCHASEDEMAND_NUMBER = <cfif len(attributes.purchasedemand_number) and isnumeric(attributes.purchasedemand_number)>#attributes.purchasedemand_number#<cfelse>NULL</cfif>,
				QUALITY_CONTROL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#quality_control_no#">,
				QUALITY_CONTROL_NUMBER = <cfif len(attributes.quality_control_number) and isnumeric(attributes.quality_control_number)>#attributes.quality_control_number#<cfelse>NULL</cfif>,
				PRODUCTION_QUALITY_CONTROL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#production_quality_control_no#">,
				PRODUCTION_QUALITY_CONTROL_NUMBER = <cfif len(attributes.production_quality_control_number) and isnumeric(attributes.production_quality_control_number)>#attributes.production_quality_control_number#<cfelse>NULL</cfif>,
				SYSTEM_PAPER_NO  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.system_paper_no#">,
				SYSTEM_PAPER_NUMBER = <cfif len(attributes.system_paper_number) and isnumeric(attributes.system_paper_number)>#attributes.system_paper_number#<cfelse>NULL</cfif>,
				TRAVEL_DEMAND_NO  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.travel_demand_no#">,
				TRAVEL_DEMAND_NUMBER = <cfif len(attributes.travel_demand_number) and isnumeric(attributes.travel_demand_number)>#attributes.travel_demand_number#<cfelse>NULL</cfif>,
				SHIP_INTERNAL_NO = 		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ship_internal_no#">,
				SHIP_INTERNAL_NUMBER =  <cfif len(attributes.ship_internal_number) and isnumeric(attributes.ship_internal_number)>#attributes.ship_internal_number#<cfelse>NULL</cfif>,
				SAMPLE_ANALYSIS_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.lab_report_no#">,
				SAMPLE_ANALYSIS_NUMBER = <cfif len(attributes.lab_report_number) and isnumeric(attributes.lab_report_number)>#attributes.lab_report_number#<cfelse>NULL</cfif>
			WHERE
				GENERAL_PAPERS_ID = #attributes.general_papers_id#
		</cfquery>		
	<cfelseif fusebox.use_period eq 1>
		<cfquery name="ADD_GENERAL_PAPERS" datasource="#DSN3#">
			INSERT INTO 
				GENERAL_PAPERS 
			(  
				CAMPAIGN_NO,                                   
				CAMPAIGN_NUMBER,
				PROMOTION_NO,                                   
				PROMOTION_NUMBER,
				CATALOG_NO,                                  
				CATALOG_NUMBER,
				TARGET_MARKET_NO,
				TARGET_MARKET_NUMBER,
				CAT_PROM_NO,
				CAT_PROM_NUMBER,
				PROD_ORDER_NO,
				PROD_ORDER_NUMBER,
				PRODUCTION_LOT_NO,
				PRODUCTION_LOT_NUMBER,
				SUPPORT_NO,
				SUPPORT_NUMBER,
				OPPORTUNITY_NO,
				OPPORTUNITY_NUMBER,
				SERVICE_APP_NO,
				SERVICE_APP_NUMBER,
				STOCK_FIS_NO,
				STOCK_FIS_NUMBER,
				SHIP_FIS_NO,
				SHIP_FIS_NUMBER,
				SUBSCRIPTION_NO,
				SUBSCRIPTION_NUMBER,
				PRODUCTION_RESULT_NO,
				PRODUCTION_RESULT_NUMBER,
				CREDIT_NO,
				CREDIT_NUMBER,
				CREDIT_REVENUE_NO,
				CREDIT_REVENUE_NUMBER,
				CREDIT_PAYMENT_NO,
				CREDIT_PAYMENT_NUMBER,
				PRO_MATERIAL_NO,
				PRO_MATERIAL_NUMBER,
				INTERNAL_NO,
				INTERNAL_NUMBER,
				CORRESPONDENCE_NO,
				CORRESPONDENCE_NUMBER,
				PURCHASEDEMAND_NO,
				PURCHASEDEMAND_NUMBER,
				QUALITY_CONTROL_NO,
				QUALITY_CONTROL_NUMBER,
				PRODUCTION_QUALITY_CONTROL_NO,
				PRODUCTION_QUALITY_CONTROL_NUMBER,
				SYSTEM_PAPER_NO,
				SYSTEM_PAPER_NUMBER,
				TRAVEL_DEMAND_NO,
				TRAVEL_DEMAND_NUMBER,
				SHIP_INTERNAL_NO,
				SHIP_INTERNAL_NUMBER,
				SAMPLE_ANALYSIS_NO,
				SAMPLE_ANALYSIS_NUMBER
			)		
			VALUES 
			(
				<cfif isdefined("attributes.campaign_no") and len(attributes.campaign_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.campaign_no#"><cfelse>NULL</cfif>,                                     
				<cfif len(attributes.campaign_number) and isnumeric(attributes.campaign_number)>#attributes.campaign_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.promotion_no#">,          
				<cfif len(attributes.promotion_number) and isnumeric(attributes.promotion_number)>#attributes.promotion_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.catalog_no#">,   
				<cfif len(attributes.catalog_number) and isnumeric(attributes.catalog_number)>#attributes.catalog_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.target_market_no#">,
				<cfif len(attributes.target_market_number) and isnumeric(attributes.target_market_number)>#attributes.target_market_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cat_prom_no#">,
				<cfif len(attributes.cat_prom_number) and isnumeric(attributes.cat_prom_number)>#attributes.cat_prom_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.prod_order_no#">,
				<cfif len(attributes.prod_order_number) and  isnumeric(attributes.prod_order_number)>#attributes.prod_order_number#<cfelse>NULL</cfif>,			
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.production_lot_no#">,
				<cfif len(attributes.production_lot_number) and isnumeric(attributes.production_lot_number)>#attributes.production_lot_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.support_no#">,
				<cfif len(attributes.support_number) and isnumeric(attributes.support_number)>#attributes.support_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.opp_no#">,
				<cfif len(attributes.opp_number) and isnumeric(attributes.opp_number)>#attributes.opp_number#<cfelse>NULL</cfif>,							
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.service_app_no#">,
				<cfif len(attributes.service_app_number) and isnumeric(attributes.service_app_number)>#attributes.service_app_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.stock_fis_no#">,
				<cfif len(attributes.stock_fis_number) and  isnumeric(attributes.stock_fis_number)>#attributes.stock_fis_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ship_fis_no#">,
				<cfif len(attributes.ship_fis_number) and  isnumeric(attributes.ship_fis_number)>#attributes.ship_fis_number#<cfelse>NULL</cfif>,			
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.subscription_no#">,
				<cfif len(attributes.subscription_number) and isnumeric(attributes.subscription_number)>#attributes.subscription_number#,<cfelse>NULL,</cfif>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.production_result_no#">,
				<cfif len(attributes.production_result) and isnumeric(attributes.production_result)>#attributes.production_result#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.credit_no#">,
				<cfif len(attributes.credit_number) and isnumeric(attributes.credit_number)>#attributes.credit_number#<cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.credit_revenue_no#">,
				<cfif len(attributes.credit_revenue_number) and isnumeric(attributes.credit_revenue_number)>#attributes.credit_revenue_number#<cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.credit_payment_no#">,
				<cfif len(attributes.credit_payment_number) and isnumeric(attributes.credit_payment_number)>#attributes.credit_payment_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.pro_material_no#">,
				<cfif len(attributes.pro_material_number) and isnumeric(attributes.pro_material_number)>#attributes.pro_material_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.internal_no#">,
				<cfif len(attributes.internal_number) and isnumeric(attributes.internal_number)>#attributes.internal_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.correspondence_no#">,
				<cfif len(attributes.correspondence_number) and isnumeric(attributes.correspondence_number)>#attributes.correspondence_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.purchasedemand_no#">,
				<cfif len(attributes.purchasedemand_number) and isnumeric(attributes.purchasedemand_number)>#attributes.purchasedemand_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.quality_control_no#">,
				<cfif len(attributes.quality_control_number) and isnumeric(attributes.quality_control_number)>#attributes.quality_control_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.production_quality_control_no#">,
				<cfif len(attributes.production_quality_control_number) and isnumeric(attributes.production_quality_control_number)>#attributes.production_quality_control_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.system_paper_no#">,
				<cfif len(attributes.system_paper_number) and isnumeric(attributes.system_paper_number)>#attributes.system_paper_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.travel_demand_no#">,
				<cfif len(attributes.travel_demand_number) and isnumeric(attributes.travel_demand_number)>#attributes.travel_demand_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ship_internal_no#">,
				<cfif len(attributes.ship_internal_number) and isnumeric(attributes.ship_internal_number)>#attributes.ship_internal_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.lab_report_no#">,
				<cfif len(attributes.lab_report_number) and isnumeric(attributes.lab_report_number)>#attributes.lab_report_number#<cfelse>NULL</cfif>
			)
		</cfquery>	
	</cfif>
	<!--- Main Db deki Duzenlemeler --->
	<cfquery name="get_" datasource="#DSN#" maxrows="1">
		SELECT GENERAL_PAPER_ID FROM GENERAL_PAPERS_MAIN
	</cfquery>
	<cfif get_.recordcount>
		<cfquery name="UPD_GENERAL_PAPERS" datasource="#DSN#">
			UPDATE
				GENERAL_PAPERS_MAIN
			SET
				EMPLOYEE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.employee_no#">,
				EMPLOYEE_NUMBER = <cfif len(attributes.employee_number) and isnumeric(attributes.employee_number)>#attributes.employee_number#<cfelse>NULL</cfif>,
				EMP_APP_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.emp_app_no#">,
				EMP_APP_NUMBER = <cfif len(attributes.emp_app_number) and isnumeric(attributes.emp_app_number)>#attributes.emp_app_number#<cfelse>NULL</cfif>,
				ASSET_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.asset_no#">,
				ASSET_NUMBER = <cfif len(attributes.asset_number) and isnumeric(attributes.asset_number)>#attributes.asset_number#<cfelse>NULL</cfif>,
				G_SERVICE_APP_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.g_service_app_no#">,
				G_SERVICE_APP_NUMBER = <cfif len(attributes.g_service_app_number) and isnumeric(attributes.g_service_app_number)>#attributes.g_service_app_number#<cfelse>NULL</cfif>,
				FIXTURES_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.fixtures_no#">,
                FIXTURES_NUMBER = <cfif len(attributes.fixtures_number) and isnumeric(attributes.fixtures_number)>#attributes.fixtures_number#<cfelse>NULL</cfif>,
				EMPLOYEE_HEALTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.employee_healty_no#">,
				EMPLOYEE_HEALTY_NUMBER = <cfif len(attributes.employee_healty_number) and isnumeric(attributes.employee_healty_number)>#attributes.employee_healty_number#<cfelse>NULL</cfif>,
				EMP_NOTICE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.emp_notice_no#">,
				EMP_NOTICE_NUMBER = <cfif len(attributes.emp_notice_number) and isnumeric(attributes.emp_notice_number)>#attributes.emp_notice_number#<cfelse>NULL</cfif>,
                ASSET_FAILURE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.asset_failure_no#">,
                ASSET_FAILURE_NUMBER = <cfif len(attributes.asset_failure_number) and isnumeric(attributes.asset_failure_number)>#attributes.asset_failure_number#<cfelse>NULL</cfif>,
				ALLOWENCE_EXPENSE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.allowence_expense_no#">,
                ALLOWENCE_EXPENSE_NUMBER = <cfif len(attributes.allowence_expense_number) and isnumeric(attributes.allowence_expense_number)>#attributes.allowence_expense_number#<cfelse>NULL</cfif>,
				HEALTH_ALLOWENCE_EXPENSE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.health_allowence_expense_no#">,
                HEALTH_ALLOWENCE_EXPENSE_NUMBER = <cfif len(attributes.health_allowence_expense_number) and isnumeric(attributes.health_allowence_expense_number)>#attributes.health_allowence_expense_number#<cfelse>NULL</cfif>,
				ADDITIONAL_ALLOWANCE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.additional_allowance_no#">,
				ADDITIONAL_ALLOWANCE_NUMBER = <cfif len(attributes.additional_allowance_number) and isnumeric(attributes.additional_allowance_number)>#attributes.additional_allowance_number#<cfelse>NULL</cfif>,
				WORK_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.WORK_NO#">,
				WORK_NUMBER = <cfif len(attributes.WORK_NUMBER) and isnumeric(attributes.WORK_NUMBER)>#attributes.WORK_NUMBER#<cfelse>NULL</cfif>,
				PACKAGE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PACKAGE_NO#">,
				PACKAGE_NUMBER = <cfif len(attributes.PACKAGE_NUMBER) and isnumeric(attributes.PACKAGE_NUMBER)>#attributes.PACKAGE_NUMBER#<cfelse>NULL</cfif>
			WHERE	
				GENERAL_PAPER_ID = #get_.general_paper_id#
		</cfquery>
	<cfelse>
		<cfquery name="ADD_GENERAL_PAPERS" datasource="#DSN#">
			INSERT INTO 
				GENERAL_PAPERS_MAIN
			(  
				EMPLOYEE_NO,
				EMPLOYEE_NUMBER,
				EMP_APP_NO,
				EMP_APP_NUMBER,
				ASSET_NO,
				ASSET_NUMBER,
				G_SERVICE_APP_NO,
				G_SERVICE_APP_NUMBER,
                FIXTURES_NO,
                FIXTURES_NUMBER,
				EMPLOYEE_HEALTY_NO,
				EMPLOYEE_HEALTY_NUMBER,
				EMP_NOTICE_NO,
				EMP_NOTICE_NUMBER,
                ASSET_FAILURE_NO,
                ASSET_FAILURE_NUMBER,
				ALLOWENCE_EXPENSE_NO,
                ALLOWENCE_EXPENSE_NUMBER,
				HEALTH_ALLOWENCE_EXPENSE_NO,
                HEALTH_ALLOWENCE_EXPENSE_NUMBER,
				ADDITIONAL_ALLOWANCE_NO,
				ADDITIONAL_ALLOWANCE_NUMBER,
				WORK_NO,
				WORK_NUMBER,
				PACKAGE_NO,
				PACKAGE_NUMBER
			)		
			VALUES 
			(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.employee_no#">,
				<cfif len(attributes.employee_number) and isnumeric(attributes.employee_number)>#attributes.employee_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.emp_app_no#">,
				<cfif len(attributes.emp_app_number) and isnumeric(attributes.emp_app_number)>#attributes.emp_app_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.asset_no#">,
				<cfif len(attributes.asset_number) and isnumeric(attributes.asset_number)>#attributes.asset_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.g_service_app_no#">,
				<cfif len(attributes.g_service_app_number) and isnumeric(attributes.g_service_app_number)>#attributes.g_service_app_number#<cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.fixtures_no#">,
                <cfif len(attributes.fixtures_number) and isnumeric(attributes.fixtures_number)>#attributes.fixtures_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.employee_healty_no#">,
				<cfif len(attributes.employee_healty_number) and isnumeric(attributes.employee_healty_number)>#attributes.employee_healty_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.emp_notice_no#">,
				<cfif len(attributes.emp_notice_number) and isnumeric(attributes.emp_notice_number)>#attributes.emp_notice_number#<cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.asset_failure_no#">,
				<cfif len(attributes.asset_failure_number) and isnumeric(attributes.asset_failure_number)>#attributes.asset_failure_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.allowence_expense_no#">,
				<cfif len(attributes.allowence_expense_number) and isnumeric(attributes.allowence_expense_number)>#attributes.allowence_expense_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.health_allowence_expense_no#">,
				<cfif len(attributes.health_allowence_expense_number) and isnumeric(attributes.health_allowence_expense_number)>#attributes.health_allowence_expense_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.additional_allowance_no#">,
				<cfif len(attributes.additional_allowance_number) and isnumeric(attributes.additional_allowance_number)>#attributes.additional_allowance_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.WORK_NO#">,
				<cfif len(attributes.WORK_NUMBER) and isnumeric(attributes.WORK_NUMBER)>#attributes.WORK_NUMBER#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.PACKAGE_NO#">,
				<cfif len(attributes.PACKAGE_NUMBER) and isnumeric(attributes.PACKAGE_NUMBER)>#attributes.PACKAGE_NUMBER#<cfelse>NULL</cfif>
			)
		</cfquery>
	</cfif>
   
<!--- Finans Sayfa numarasından gelmisse --->	
<cfelseif attributes.type eq 2>
	<cfif isdefined("attributes.is_upd")>
		<cfquery name="UPD_GENERAL_PAPERS" datasource="#DSN3#">
			UPDATE 
				GENERAL_PAPERS 
			SET  
				VIRMAN_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.virman_no#">,
				VIRMAN_NUMBER = <cfif len(attributes.virman_number) and isnumeric(attributes.virman_number)>#attributes.virman_number#<cfelse>NULL</cfif>,
				INCOMING_TRANSFER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.incoming_transfer_no#">,
				INCOMING_TRANSFER_NUMBER = <cfif len(attributes.incoming_transfer_number) and isnumeric(attributes.incoming_transfer_number)>#attributes.incoming_transfer_number#<cfelse>NULL</cfif>,
				OUTGOING_TRANSFER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.outgoing_transfer_no#">,
				OUTGOING_TRANSFER_NUMBER = <cfif len(attributes.outgoing_transfer_number) and isnumeric(attributes.outgoing_transfer_number)>#attributes.outgoing_transfer_number#<cfelse>NULL</cfif>,
				PURCHASE_DOVIZ_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.purchase_doviz_no#">,
				PURCHASE_DOVIZ_NUMBER = <cfif len(attributes.purchase_doviz_number) and isnumeric(attributes.purchase_doviz_number)>#attributes.purchase_doviz_number#<cfelse>NULL</cfif>,
				SALE_DOVIZ_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.sale_doviz_no#">,
				SALE_DOVIZ_NUMBER = <cfif len(attributes.sale_doviz_number) and isnumeric(attributes.sale_doviz_number)>#attributes.sale_doviz_number#<cfelse>NULL</cfif>,
				CREDITCARD_REVENUE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.creditcard_revenue_no#">,
				CREDITCARD_REVENUE_NUMBER = <cfif len(attributes.creditcard_revenue_number) and isnumeric(attributes.creditcard_revenue_number)>#attributes.creditcard_revenue_number#<cfelse>NULL</cfif>,
				CREDITCARD_PAYMENT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.creditcard_payment_no#">,
				CREDITCARD_PAYMENT_NUMBER = <cfif len(attributes.creditcard_payment_number) and isnumeric(attributes.creditcard_payment_number)>#attributes.creditcard_payment_number#<cfelse>NULL</cfif>,
				CARI_TO_CARI_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cari_to_cari_no#">,
				CARI_TO_CARI_NUMBER = <cfif len(attributes.cari_to_cari_number) and isnumeric(attributes.cari_to_cari_number)>#attributes.cari_to_cari_number#<cfelse>NULL</cfif>,
				DEBIT_CLAIM_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.debit_claim_no#">,
				DEBIT_CLAIM_NUMBER = <cfif len(attributes.debit_claim_number) and isnumeric(attributes.debit_claim_number)>#attributes.debit_claim_number#<cfelse>NULL</cfif>,
				CASH_TO_CASH_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cash_to_cash_no#">,
				CASH_TO_CASH_NUMBER = <cfif len(attributes.cash_to_cash_number) and isnumeric(attributes.cash_to_cash_number)>#attributes.cash_to_cash_number#<cfelse>NULL</cfif>,
				CASH_PAYMENT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cash_payment_no#">,
				CASH_PAYMENT_NUMBER = <cfif len(attributes.cash_payment_number) and isnumeric(attributes.cash_payment_number)>#attributes.cash_payment_number#<cfelse>NULL</cfif>,
				EXPENSE_COST_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.expense_cost_no#">,
				EXPENSE_COST_NUMBER = <cfif len(attributes.expense_cost_number) and isnumeric(attributes.expense_cost_number)>#attributes.expense_cost_number#<cfelse>NULL</cfif>,
				INCOME_COST_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.income_cost_no#">,
				INCOME_COST_NUMBER = <cfif len(attributes.income_cost_number) and isnumeric(attributes.income_cost_number)>#attributes.income_cost_number#<cfelse>NULL</cfif>,
				BUDGET_PLAN_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.budget_plan_no#">,
				BUDGET_PLAN_NUMBER = <cfif len(attributes.budget_plan_number) and isnumeric(attributes.budget_plan_number)>#attributes.budget_plan_number#<cfelse>NULL</cfif>,
				EXPENDITURE_REQUEST_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.expenditure_request_no#">,
				EXPENDITURE_REQUEST_NUMBER = <cfif len(attributes.expenditure_request_number) and isnumeric(attributes.expenditure_request_number)>#attributes.expenditure_request_number#<cfelse>NULL</cfif>,
				CREDITCARD_DEBIT_PAYMENT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.creditcard_debit_payment_no#">,
				CREDITCARD_DEBIT_PAYMENT_NUMBER = <cfif len(attributes.creditcard_debit_payment_number) and isnumeric(attributes.creditcard_debit_payment_number)>#attributes.creditcard_debit_payment_number#<cfelse>NULL</cfif>,
                CREDITCARD_CC_BANK_ACTION_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.creditcard_cc_bank_action_no#">,
				CREDITCARD_CC_BANK_ACTION_NUMBER = <cfif len(attributes.creditcard_cc_bank_action_number) and isnumeric(attributes.creditcard_cc_bank_action_number)>#attributes.creditcard_cc_bank_action_number#<cfelse>NULL</cfif>,
				SECUREFUND_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.securefund_no#">,
				SECUREFUND_NUMBER = <cfif len(attributes.securefund_number) and isnumeric(attributes.securefund_number)>#attributes.securefund_number#<cfelse>NULL</cfif>,
				BUYING_SECURITIES_NO = <cfif isdefined("attributes.BUYING_SECURITIES_NO") and len(attributes.BUYING_SECURITIES_NO)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.BUYING_SECURITIES_NO#"><cfelse>NULL</cfif>, 
				BUYING_SECURITIES_NUMBER = <cfif isdefined("attributes.BUYING_SECURITIES_NUMBER") and len(attributes.BUYING_SECURITIES_NUMBER) and isnumeric(attributes.BUYING_SECURITIES_NUMBER)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.BUYING_SECURITIES_NUMBER#"><cfelse>NULL</cfif>,
				SECURITIES_SALE_NO = <cfif  isdefined("attributes.SECURITIES_SALE_NO") and len(attributes.SECURITIES_SALE_NO)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.SECURITIES_SALE_NO#"><cfelse>NULL</cfif>, 
				SECURITIES_SALE_NUMBER = <cfif isdefined("attributes.SECURITIES_SALE_NUMBER") and len(attributes.SECURITIES_SALE_NUMBER) and isnumeric(attributes.SECURITIES_SALE_NUMBER)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SECURITIES_SALE_NUMBER#"><cfelse>NULL</cfif>,
				RECEIPT_NO = <cfif len(attributes.receipt_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.receipt_no#"><cfelse>NULL</cfif>,
				RECEIPT_NUMBER = <cfif len(attributes.receipt_number) and isnumeric(attributes.receipt_number)>#attributes.receipt_number#<cfelse>NULL</cfif>,
				MKDAD_NO = <cfif len(attributes.mkdad_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.mkdad_no#"><cfelse>NULL</cfif>,
				MKDAD_NUMBER = <cfif len(attributes.mkdad_number) and isnumeric(attributes.mkdad_number)>#attributes.mkdad_number#<cfelse>NULL</cfif>,
				BUDGET_TRANSFER_DEMAND_NO  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.budgettransfer_no#">,
				BUDGET_TRANSFER_DEMAND_NUMBER = <cfif len(attributes.budgettransfer_number) and isnumeric(attributes.budgettransfer_number)>#attributes.budgettransfer_number#<cfelse>NULL</cfif>,
				CASHREGISTER_NO  = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.cashregister_no#">,
				CASHREGISTER_NUMBER = <cfif len(attributes.cashregister_number) and isnumeric(attributes.cashregister_number)>#attributes.cashregister_number#<cfelse>NULL</cfif>
		
			WHERE
				GENERAL_PAPERS_ID = #attributes.general_papers_id#
		</cfquery>		
	<cfelse>
		<cfquery name="ADD_GENERAL_PAPERS" datasource="#DSN3#">
			INSERT INTO 
				GENERAL_PAPERS 
			(  
				VIRMAN_NO,
				VIRMAN_NUMBER,
				INCOMING_TRANSFER_NO,
				INCOMING_TRANSFER_NUMBER,
				OUTGOING_TRANSFER_NO,
				OUTGOING_TRANSFER_NUMBER,
				PURCHASE_DOVIZ_NO,
				PURCHASE_DOVIZ_NUMBER,
				SALE_DOVIZ_NO,
				SALE_DOVIZ_NUMBER,
				CREDITCARD_REVENUE_NO,
				CREDITCARD_REVENUE_NUMBER,
				CREDITCARD_PAYMENT_NO,
				CREDITCARD_PAYMENT_NUMBER,
				CARI_TO_CARI_NO,
				CARI_TO_CARI_NUMBER,
				DEBIT_CLAIM_NO,
				DEBIT_CLAIM_NUMBER,
				CASH_TO_CASH_NO,
				CASH_TO_CASH_NUMBER,
				CASH_PAYMENT_NO,
				CASH_PAYMENT_NUMBER,
				EXPENSE_COST_NO,
				EXPENSE_COST_NUMBER,
				INCOME_COST_NO,
				INCOME_COST_NUMBER,
				BUDGET_PLAN_NO,
				BUDGET_PLAN_NUMBER,
                EXPENDITURE_REQUEST_NO,
                EXPENDITURE_REQUEST_NUMBER,
				CREDITCARD_DEBIT_PAYMENT_NO,
				CREDITCARD_DEBIT_PAYMENT_NUMBER,
                CREDITCARD_CC_BANK_ACTION_NO,
                CREDITCARD_CC_BANK_ACTION_NUMBER,
				SECUREFUND_NO,
				SECUREFUND_NUMBER,
				BUYING_SECURITIES_NO, 
				BUYING_SECURITIES_NUMBER,
				SECURITIES_SALE_NO, 
				SECURITIES_SALE_NUMBER,
				RECEIPT_NO,
				RECEIPT_NUMBER,
				BUDGET_TRANSFER_DEMAND_NO,
				BUDGET_TRANSFER_DEMAND_NUMBER,
				CASHREGISTER_NO,
				CASHREGISTER_NUMBER
			)		
			VALUES 
			(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.virman_no#">,
				<cfif len(attributes.virman_number) and isnumeric(attributes.virman_number)>#attributes.virman_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.incoming_transfer_no#">,
				<cfif len(attributes.incoming_transfer_number) and isnumeric(attributes.incoming_transfer_number)>#attributes.incoming_transfer_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.outgoing_transfer_no#">,
				<cfif len(attributes.outgoing_transfer_number) and isnumeric(attributes.outgoing_transfer_number)>#attributes.outgoing_transfer_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.purchase_doviz_no#">,
				<cfif len(attributes.purchase_doviz_number) and isnumeric(attributes.purchase_doviz_number)>#attributes.purchase_doviz_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.sale_doviz_no#">,
				<cfif len(attributes.sale_doviz_number) and isnumeric(attributes.sale_doviz_number)>#attributes.sale_doviz_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.creditcard_revenue_no#">,
				<cfif len(attributes.creditcard_revenue_number) and isnumeric(attributes.creditcard_revenue_number)>#attributes.creditcard_revenue_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.creditcard_payment_no#">,
				<cfif len(attributes.creditcard_payment_number) and isnumeric(attributes.creditcard_payment_number)>#attributes.creditcard_payment_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cari_to_cari_no#">,
				<cfif len(attributes.cari_to_cari_number) and isnumeric(attributes.cari_to_cari_number)>#attributes.cari_to_cari_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.debit_claim_no#">,
				<cfif len(attributes.debit_claim_number) and isnumeric(attributes.debit_claim_number)>#attributes.debit_claim_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cash_to_cash_no#">,
				<cfif len(attributes.cash_to_cash_number) and isnumeric(attributes.cash_to_cash_number)>#attributes.cash_to_cash_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cash_payment_no#">,
				<cfif len(attributes.cash_payment_number) and isnumeric(attributes.cash_payment_number)>#attributes.cash_payment_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.expense_cost_no#">,
				<cfif len(attributes.expense_cost_number) and isnumeric(attributes.expense_cost_number)>#attributes.expense_cost_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.income_cost_no#">,
				<cfif len(attributes.income_cost_number) and isnumeric(attributes.income_cost_number)>#attributes.income_cost_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.budget_plan_no#">,
				<cfif len(attributes.budget_plan_number) and isnumeric(attributes.budget_plan_number)>#attributes.budget_plan_number#<cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.expenditure_request_no#">,
				<cfif len(attributes.expenditure_request_number) and isnumeric(attributes.expenditure_request_number)>#attributes.expenditure_request_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.creditcard_debit_payment_no#">,
				<cfif len(attributes.creditcard_debit_payment_number) and isnumeric(attributes.creditcard_debit_payment_number)>#attributes.creditcard_debit_payment_number#<cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.creditcard_cc_bank_action_no#">,
				<cfif len(attributes.creditcard_cc_bank_action_number) and isnumeric(attributes.creditcard_cc_bank_action_number)>#attributes.creditcard_cc_bank_action_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.securefund_no#">,
				<cfif len(attributes.securefund_number) and isnumeric(attributes.securefund_number)>#attributes.securefund_number#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.BUYING_SECURITIES_NO") and len(attributes.BUYING_SECURITIES_NO)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.BUYING_SECURITIES_NO#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.BUYING_SECURITIES_NUMBER") and len(attributes.BUYING_SECURITIES_NUMBER) and isnumeric(attributes.BUYING_SECURITIES_NUMBER)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.BUYING_SECURITIES_NUMBER#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.SECURITIES_SALE_NO") and len(attributes.SECURITIES_SALE_NO)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.SECURITIES_SALE_NO#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.SECURITIES_SALE_NUMBER") and len(attributes.SECURITIES_SALE_NUMBER) and isnumeric(attributes.SECURITIES_SALE_NUMBER)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SECURITIES_SALE_NUMBER#"><cfelse>NULL</cfif>,
				<cfif len(attributes.receipt_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.receipt_no#"><cfelse>NULL</cfif>,
				<cfif len(attributes.receipt_number) and isnumeric(attributes.receipt_number)>#attributes.receipt_number#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.budgettransfer_no#">,
				<cfif len(attributes.budgettransfer_number) and isnumeric(attributes.budgettransfer_number)>#attributes.budgettransfer_number#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.cashregister_no") and len(attributes.cashregister_no)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.cashregister_no#"><cfelse>NULL</cfif>,
				<cfif isDefined("attributes.cashregister_number") and len(attributes.cashregister_number) and isnumeric(attributes.cashregister_number)>#attributes.cashregister_number#<cfelse>NULL</cfif>
			)
		</cfquery>	
	</cfif>
<cfelseif attributes.type eq 3>
	<cfquery name="get_" datasource="#DSN1#" maxrows="1">
		SELECT PRODUCT_NO FROM PRODUCT_NO where PRODUCT_NO=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_no#">
	</cfquery>
	<cfif get_.recordcount>
		<cfquery name="UPD_PRODUCT_NO" datasource="#DSN1#">
			UPDATE
				PRODUCT_NO
			SET
			<cfif len(attributes.stock_no)>STOCK_NO=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_no#"><cfelse>NULL</cfif>
			<cfif len(attributes.barcode_no)>,BARCODE=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.barcode_no#"><cfelse>NULL</cfif>
			WHERE	
			PRODUCT_NO = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_no#">
		</cfquery>
	<cfelse>
		<cfquery name="ADD_PRODUCT_NO" datasource="#DSN1#">
		INSERT INTO 
				PRODUCT_NO 
			(  
				PRODUCT_NO,
				STOCK_NO,
				BARCODE
			)		
			VALUES 
			(
				<cfif len(attributes.product_no)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_no#"><cfelse>NULL</cfif>
				<cfif len(attributes.stock_no)>,<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_no#"><cfelse>NULL</cfif>
				<cfif len(attributes.barcode_no)>,<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.barcode_no#"><cfelse>NULL</cfif>

			)
		</cfquery>
	</cfif>
</cfif>
<cflocation addtoken="no" url="#request.self#?fuseaction=settings.form_add_general_paper">
