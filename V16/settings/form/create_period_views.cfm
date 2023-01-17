
<!---Yeni Versiyona Kadar Çalıştırılmaması Gerekiyor . Sevda..
<cfabort>--->
<cfform name="create_view" action="#request.self#?fuseaction=settings.create_period_views" method="post">
	<table width="98%" align="center">
		<tr>
			<td height="35"><font color="red"><cf_get_lang no='2957.Sistemde Dönem Database inde Bulunan Tüm View ler Silinip Tekrar Oluşturulacaktır'><br></font></td>
		</tr>
		<tr>
			<td>
				<input type="submit" value="<cf_get_lang_main no='1554.Oluştur'>">
				<input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
			</td>
		</tr>
	</table>
</cfform>
<cfif isDefined("attributes.is_form_submitted")>
	<cfquery name="get_periods" datasource="#dsn#">
		SELECT * FROM SETUP_PERIOD ORDER BY PERIOD_YEAR
	</cfquery>
	<cfset new_prod_db='#dsn#_product'>
	<cfset new_dsn = '#dsn#'>
	<cfloop query="get_periods">
		<cfset new_dsn2 = '#dsn#_#get_periods.PERIOD_YEAR#_#get_periods.OUR_COMPANY_ID#'>
		<cfset new_dsn3 = '#dsn#_#get_periods.OUR_COMPANY_ID#'>
		<cfoutput>new_dsn2:#new_dsn2#,new_dsn3:#new_dsn3# new_dsn:#new_dsn#<br></cfoutput>
		<cftry>  
			<cfquery name="drop_view" datasource="#new_dsn2#">
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CONSUMER_GROUP_SALE]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CONSUMER_GROUP_SALE
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[ACCOUNT_ACCOUNT_REMAINDER]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW ACCOUNT_ACCOUNT_REMAINDER
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[INVOICE_DAILY_SALES]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW INVOICE_DAILY_SALES
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_CONSIGMENT_PRODUCT_SALE]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_CONSIGMENT_PRODUCT_SALE
				end
				
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_PRE_PERIOD_CONSIGMENT_DETAIL]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_PRE_PERIOD_CONSIGMENT_DETAIL
				end
				
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_CONSIGMENT_DETAIL]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_CONSIGMENT_DETAIL
				end
	
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[ACCOUNT_ACCOUNT_REMAINDER_MONEY]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW ACCOUNT_ACCOUNT_REMAINDER_MONEY 
				end
				
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[ACCOUNT_ACCOUNT_REMAINDER_LAST]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW ACCOUNT_ACCOUNT_REMAINDER_LAST
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[ACCOUNT_ACCOUNT_REMAINDER_NOPROCESS]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW ACCOUNT_ACCOUNT_REMAINDER_NOPROCESS
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[ACCOUNT_ACCOUNT_REMAINDER_TOTAL]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW ACCOUNT_ACCOUNT_REMAINDER_TOTAL
				end
				
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[ACCOUNT_ACCOUNT_REMAINDER_TOTAL_MONEY]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW ACCOUNT_ACCOUNT_REMAINDER_TOTAL_MONEY
				end
				
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[ACCOUNT_REMAINDER]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW ACCOUNT_REMAINDER
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[ACCOUNT_REMAINDER_LAST]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW ACCOUNT_REMAINDER_LAST
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CARI_ROWS_CONSUMER]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CARI_ROWS_CONSUMER
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CARI_ROWS_EMPLOYEE]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CARI_ROWS_EMPLOYEE
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CARI_ROWS_TOPLAM]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CARI_ROWS_TOPLAM
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CASH_REMAINDER]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CASH_REMAINDER
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CASH_REMAINDER_LAST]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CASH_REMAINDER_LAST
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CHEQUE_IN_BANK]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CHEQUE_IN_BANK
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CHEQUE_IN_CASH]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CHEQUE_IN_CASH
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CHEQUE_IN_CASH_TOTAL]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CHEQUE_IN_CASH_TOTAL
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CHEQUE_TO_PAY]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CHEQUE_TO_PAY
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[COMPANY_REMAINDER]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW COMPANY_REMAINDER
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[COMPANY_RISK]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW COMPANY_RISK
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[COMPANY_RISK_MONEY]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW COMPANY_RISK_MONEY
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[DAILY_CREDIT]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW DAILY_CREDIT
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[DAILY_EFFECTIVE_MONEY]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW DAILY_EFFECTIVE_MONEY
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[DAILY_STOCKS]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW DAILY_STOCKS
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[DAILY_TOTAL_STOCKS]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW DAILY_TOTAL_STOCKS
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[DAILY_CARI_REMAINDER]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW DAILY_CARI_REMAINDER
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[DAILY_DUE_REMAINDER]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW DAILY_DUE_REMAINDER
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[DAILY_TOTAL_CARI_REMAINDER]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW DAILY_TOTAL_CARI_REMAINDER
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[DAILY_TOTAL_CREDIT]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW DAILY_TOTAL_CREDIT
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[DAILY_CASH_REMAINDER]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW DAILY_CASH_REMAINDER
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[DAILY_ACCOUNT_REMAINDER]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW DAILY_ACCOUNT_REMAINDER
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[DAILY_TOTAL_EFFECTIVE_MONEY]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW DAILY_TOTAL_EFFECTIVE_MONEY
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CONSUMER_RISK]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CONSUMER_RISK
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CONSUMER_RISK_MONEY]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CONSUMER_RISK_MONEY
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_ACC_CODE_TOTAL_DAILY]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_ACC_CODE_TOTAL_DAILY
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_ACCOUNT_CARD]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_ACCOUNT_CARD
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_ACCOUNT_CARD_DETAIL]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_ACCOUNT_CARD_DETAIL
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_ACCOUNT_CARD_GROUP]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_ACCOUNT_CARD_GROUP
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_ACCOUNT_CARD_TOTAL_DAILY]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_ACCOUNT_CARD_TOTAL_DAILY
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_ACTION_PROJECT_PRODUCTS]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_ACTION_PROJECT_PRODUCTS
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_ALL_ACC_CODE_DAILY_TOTAL]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_ALL_ACC_CODE_DAILY_TOTAL
				end 
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_ALL_STOCK_ACTION_DETAIL]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_ALL_STOCK_ACTION_DETAIL
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_ALL_STOCKS_ROW_COST]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_ALL_STOCKS_ROW_COST
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_PRODUCT_COST_PERIOD]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_PRODUCT_COST_PERIOD
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_PRODUCT_STOCK]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_PRODUCT_STOCK
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_PRODUCT_STOCK_BRANCH]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_PRODUCT_STOCK_BRANCH
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_SCEN_EXPENSE]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_SCEN_EXPENSE 
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_SCEN_INCOME]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_SCEN_INCOME
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_SCEN_LAST]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_SCEN_LAST
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_STOCK]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_STOCK
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_STOCK_LAST]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_STOCK_LAST
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_STOCK_LAST_SHELF]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_STOCK_LAST_SHELF
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_STOCK_LAST_PROFILE]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_STOCK_LAST_PROFILE
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_STOCK_LAST_LOCATION]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_STOCK_LAST_LOCATION
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_STOCK_LAST_SPECT]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_STOCK_LAST_SPECT
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_STOCK_LOCATION]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_STOCK_LOCATION
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_STOCK_LOCATION_SPECT]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_STOCK_LOCATION_SPECT
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_STOCK_LOCATION_SPECT_TOTAL]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_STOCK_LOCATION_SPECT_TOTAL
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_STOCK_LOCATION_TOTAL]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_STOCK_LOCATION_TOTAL
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_STOCK_PRODUCT]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_STOCK_PRODUCT
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_STOCK_PRODUCT_BRANCH]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_STOCK_PRODUCT_BRANCH
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_STOCK_PRODUCT_BRANCH_SPECT]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_STOCK_PRODUCT_BRANCH_SPECT
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_STOCK_PRODUCT_SPECT]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_STOCK_PRODUCT_SPECT
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_STOCK_SPECT]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_STOCK_SPECT
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_STOCK_SHELF]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_STOCK_SHELF
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_STOCK_SHELF_ONLY]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_STOCK_SHELF_ONLY
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_STOCK_STRATEGY]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_STOCK_STRATEGY 
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_STOCKS_ROW_COST]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_STOCKS_ROW_COST
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_TAX]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_TAX
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_TAX_LAST]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_TAX_LAST
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[INVOICE_ROW_POS_SALES]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW INVOICE_ROW_POS_SALES
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[INVOICE_ROW_SALES]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW INVOICE_ROW_SALES
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[SETUP_MONEY]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW SETUP_MONEY			
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[STOCK_IN_OUT]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW STOCK_IN_OUT
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[STOCKS_SALES]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin


					DROP VIEW STOCKS_SALES
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[VOUCHER_IN_BANK]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW VOUCHER_IN_BANK
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[VOUCHER_IN_CASH]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW VOUCHER_IN_CASH
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[VOUCHER_IN_CASH_TOTAL]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW VOUCHER_IN_CASH_TOTAL
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[VOUCHER_TO_GET]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW VOUCHER_TO_GET
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[VOUCHER_TO_PAY]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW VOUCHER_TO_PAY
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[ACTIVITY_SUMMARY_DAILY]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW ACTIVITY_SUMMARY_DAILY
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[ACTIVITY_SUMMARY_DAILY_FOR_COMPANY]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW ACTIVITY_SUMMARY_DAILY_FOR_COMPANY
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[ACTIVITY_SUMMARY_DAILY_FOR_CONSUMER]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW ACTIVITY_SUMMARY_DAILY_FOR_CONSUMER
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[COMPANY_REMAINDER_MONEY]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW COMPANY_REMAINDER_MONEY
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CONSUMER_REMAINDER_MONEY]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CONSUMER_REMAINDER_MONEY
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[COMPANY_REMAINDER_PROJECT]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW COMPANY_REMAINDER_PROJECT
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[COMPANY_REMAINDER_MONEY_PROJECT]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW COMPANY_REMAINDER_MONEY_PROJECT
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CONSUMER_REMAINDER]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CONSUMER_REMAINDER
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CONSUMER_REMAINDER_MONEY]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CONSUMER_REMAINDER_MONEY
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CONSUMER_REMAINDER_PROJECT]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CONSUMER_REMAINDER_PROJECT
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CONSUMER_REMAINDER_MONEY_PROJECT]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CONSUMER_REMAINDER_MONEY_PROJECT
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[EMPLOYEE_REMAINDER]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW EMPLOYEE_REMAINDER
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[EMPLOYEE_REMAINDER_PROJECT]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW EMPLOYEE_REMAINDER_PROJECT
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[EMPLOYEE_REMAINDER_MONEY]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW EMPLOYEE_REMAINDER_MONEY
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[EMPLOYEE_REMAINDER_MONEY_PROJECT]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW EMPLOYEE_REMAINDER_MONEY_PROJECT
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[EMPLOYEE_REMAINDER_BRANCH]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW EMPLOYEE_REMAINDER_BRANCH
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[EMPLOYEE_REMAINDER_MONEY_BRANCH]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW EMPLOYEE_REMAINDER_MONEY_BRANCH
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[EMPLOYEE_REMAINDER_MONEY_PROJECT_BRANCH]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW EMPLOYEE_REMAINDER_MONEY_PROJECT_BRANCH
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[EMPLOYEE_REMAINDER_PROJECT_BRANCH]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW EMPLOYEE_REMAINDER_PROJECT_BRANCH
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[INVOICE_ROW_SALES_DETAIL]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW INVOICE_ROW_SALES_DETAIL
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[INVOICE_ROW_POS_SALES_DETAIL]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW INVOICE_ROW_POS_SALES_DETAIL
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[DAILY_TOTAL_SALES]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW DAILY_TOTAL_SALES
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_RELATION_PAPERS]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_RELATION_PAPERS
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_RELATION_PAPERS_1]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_RELATION_PAPERS_1
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_RELATION_PAPERS_2]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_RELATION_PAPERS_2
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_SHIP_RESULT]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_SHIP_RESULT
				end  
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_SHIP_ROW_RELATION]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_SHIP_ROW_RELATION
				end  
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_END_SERIES_PROCESSES]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_END_SERIES_PROCESSES
				end  
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[DAILY_PRODUCT_SALES]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW DAILY_PRODUCT_SALES
				end  
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[DAILY_BRANCH_SALES]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW DAILY_BRANCH_SALES
				end  			
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[DAILY_PRODUCT_CAT_SALES]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW DAILY_PRODUCT_CAT_SALES
				end  			
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[DAILY_PRODUCT_BRAND_SALES]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW DAILY_PRODUCT_BRAND_SALES
				end  	
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[DAILY_PRODUCT_COMPANY_SALES]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW DAILY_PRODUCT_COMPANY_SALES
				end  
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[DAILY_PRODUCT_MANAGER_SALES]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW DAILY_PRODUCT_MANAGER_SALES
				end  
				
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[DAILY_WORKGROUP_PAR_SALES]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW DAILY_WORKGROUP_PAR_SALES
				end
				
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_ALL_STOCKS_ROW_COST_LOCATION]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_ALL_STOCKS_ROW_COST_LOCATION
				end
				
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_STOCKS_ROW_COST_LOCATION]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_STOCKS_ROW_COST_LOCATION
				end

				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_STOCKS_ROW_COST_LOT]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_STOCKS_ROW_COST_LOT
				end
				
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_STOCKS_ROW_COST_SPECT]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_STOCKS_ROW_COST_SPECT
				end
				
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_STOCKS_ROW_COST_SPECT_LOCATION]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_STOCKS_ROW_COST_SPECT_LOCATION
				end

				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_STOCKS_ROW_COST_LOT_LOCATION]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_STOCKS_ROW_COST_LOT_LOCATION
				end
				
				 if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CHEQUE_VOUCHER_TOTAL]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CHEQUE_VOUCHER_TOTAL
				end
				
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CHEQUE_VOUCHER_TOTAL_CONSUMER]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CHEQUE_VOUCHER_TOTAL_CONSUMER
				end
				
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CHEQUE_VOUCHER_TOTAL_CONSUMER_PROJECT]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CHEQUE_VOUCHER_TOTAL_CONSUMER_PROJECT
				end
				
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CHEQUE_VOUCHER_TOTAL_EMPLOYEE]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CHEQUE_VOUCHER_TOTAL_EMPLOYEE
				end
				
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CHEQUE_VOUCHER_TOTAL_EMPLOYEE_PROJECT]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CHEQUE_VOUCHER_TOTAL_EMPLOYEE_PROJECT
				end
				
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CHEQUE_VOUCHER_TOTAL_PROJECT]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CHEQUE_VOUCHER_TOTAL_PROJECT
				end
				
				 if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CONSUMER_SALE]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CONSUMER_SALE
				end
				 if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CHEQUE_VOUCHER_TOTAL_BRANCH]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CHEQUE_VOUCHER_TOTAL_BRANCH
				end
				 if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CHEQUE_VOUCHER_TOTAL_CONSUMER_BRANCH]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CHEQUE_VOUCHER_TOTAL_CONSUMER_BRANCH
				end	
				 if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CHEQUE_VOUCHER_TOTAL_CONSUMER_PROJECT_BRANCH]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CHEQUE_VOUCHER_TOTAL_CONSUMER_PROJECT_BRANCH
				end	
				 if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CHEQUE_VOUCHER_TOTAL_EMPLOYEE_BRANCH]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CHEQUE_VOUCHER_TOTAL_EMPLOYEE_BRANCH
				end	
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[COMPANY_REMAINDER_MONEY_BRANCH]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW COMPANY_REMAINDER_MONEY_BRANCH
				end	
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CONSUMER_REMAINDER_PROJECT_BRANCH]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CONSUMER_REMAINDER_PROJECT_BRANCH
				end	
				 if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CHEQUE_VOUCHER_TOTAL_EMPLOYEE_PROJECT_BRANCH]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CHEQUE_VOUCHER_TOTAL_EMPLOYEE_PROJECT_BRANCH
				end
				 if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CHEQUE_VOUCHER_TOTAL_PROJECT_BRANCH]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CHEQUE_VOUCHER_TOTAL_PROJECT_BRANCH
				end																													
				 if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[COMPANY_REMAINDER_BRANCH]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW COMPANY_REMAINDER_BRANCH
				end																													
				 if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CHEQUE_VOUCHER_TOTAL_PROJECT_BRANCH]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CHEQUE_VOUCHER_TOTAL_PROJECT_BRANCH
				end																													
				 if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[COMPANY_REMAINDER_MONEY_PROJECT_BRANCH]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW COMPANY_REMAINDER_MONEY_PROJECT_BRANCH
				end																													
				 if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[COMPANY_REMAINDER_PROJECT_BRANCH]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW COMPANY_REMAINDER_PROJECT_BRANCH
				end																													
				 if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CONSUMER_REMAINDER_BRANCH]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CONSUMER_REMAINDER_BRANCH
				end																													
				 if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CONSUMER_REMAINDER_MONEY_BRANCH]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CONSUMER_REMAINDER_MONEY_BRANCH
				end																													
				 if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CONSUMER_REMAINDER_MONEY_PROJECT_BRANCH]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CONSUMER_REMAINDER_MONEY_PROJECT_BRANCH
				end	
				 if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_LOCATION_STOCK_FOR_REPORT]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_LOCATION_STOCK_FOR_REPORT
				end	
				 if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_STOCK_LAST_SPECT_LOCATION_REPORT]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_STOCK_LAST_SPECT_LOCATION_REPORT
				end																																													
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[VOUCHER_REMAINING_AMOUNT]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW VOUCHER_REMAINING_AMOUNT
				end		
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[VOUCHER_IN_GUARANTEE]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW VOUCHER_IN_GUARANTEE
				end		
                if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CHEQUE_IN_GUARANTEE]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CHEQUE_IN_GUARANTEE
				end
                if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[COMPANY_REMAINDER_MONEY_PROJECT_NEW]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW COMPANY_REMAINDER_MONEY_PROJECT_NEW
				end
                 if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[GET_STOCK_PRODUCT_LOT_NO]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW GET_STOCK_PRODUCT_LOT_NO
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[COMPANY_REMAINDER_SUBSCRIPTION]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW COMPANY_REMAINDER_SUBSCRIPTION
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[COMPANY_REMAINDER_MONEY_SUBSCRIPTION]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW COMPANY_REMAINDER_MONEY_SUBSCRIPTION
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[COMPANY_REMAINDER_ACC_TYPE]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW COMPANY_REMAINDER_ACC_TYPE
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[COMPANY_REMAINDER_MONEY_ACC_TYPE]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW COMPANY_REMAINDER_MONEY_ACC_TYPE
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CONSUMER_REMAINDER_SUBSCRIPTION]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CONSUMER_REMAINDER_SUBSCRIPTION
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CONSUMER_REMAINDER_MONEY_SUBSCRIPTION]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CONSUMER_REMAINDER_MONEY_SUBSCRIPTION
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CONSUMER_REMAINDER_ACC_TYPE]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CONSUMER_REMAINDER_ACC_TYPE
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[CONSUMER_REMAINDER_MONEY_ACC_TYPE]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW CONSUMER_REMAINDER_MONEY_ACC_TYPE
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[EMPLOYEE_REMAINDER_SUBSCRIPTION]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW EMPLOYEE_REMAINDER_SUBSCRIPTION
				end
				if exists (SELECT * FROM sysobjects WHERE id = object_id(N'[EMPLOYEE_REMAINDER_MONEY_SUBSCRIPTION]') and OBJECTPROPERTY(id, N'IsView') = 1)
				begin
					DROP VIEW EMPLOYEE_REMAINDER_MONEY_SUBSCRIPTION
				end

			</cfquery>
			<cfquery name="drop_PROC" datasource="#new_dsn2#">
				IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GET_ACCOUNT_PLAN]') AND type in (N'P', N'PC'))
					DROP PROCEDURE [GET_ACCOUNT_PLAN]
				IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DEL_COST_PRODUCT]') AND type in (N'P', N'PC'))
					DROP PROCEDURE [DEL_COST_PRODUCT]
				IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DEL_COST_SHIP]') AND type in (N'P', N'PC'))
					DROP PROCEDURE [DEL_COST_SHIP]
                IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GET_ACCOUNT_PLAN]') AND type in (N'P', N'PC'))
					DROP PROCEDURE [GET_ACCOUNT_PLAN]
				IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GET_ACTION]') AND type in (N'P', N'PC'))
					DROP PROCEDURE [GET_ACTION]
				IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GET_ACTION_PRODUCT]') AND type in (N'P', N'PC'))
					DROP PROCEDURE [GET_ACTION_PRODUCT]
				IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GET_SHIP_TYPE]') AND type in (N'P', N'PC'))
					DROP PROCEDURE [GET_SHIP_TYPE]
				IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UPD_SHIP_COST]') AND type in (N'P', N'PC'))
					DROP PROCEDURE [UPD_SHIP_COST]
                IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[get_stock_last_function]') AND type in (N'P', N'PC'))
					DROP PROCEDURE [get_stock_last_function]
                IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[get_stock_last_function_with_product]') AND type in (N'P', N'PC'))
					DROP PROCEDURE [get_stock_last_function_with_product]
                IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[get_stock_last_location_function]') AND type in (N'P', N'PC'))
					DROP PROCEDURE [get_stock_last_location_function] 
                IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[get_stock_last_spect_location_function]') AND type in (N'P', N'PC'))
					DROP PROCEDURE [get_stock_last_spect_location_function]
                IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[get_stock_last_spect_location_function_with_spect_main_id]') AND type in (N'P', N'PC'))   
                    DROP PROCEDURE [get_stock_last_spect_location_function_with_spect_main_id]
                IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[fnSplit]')  and type = 'TF')
					DROP FUNCTION [fnSplit]
                IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_GET_STOCK_ALL]') AND type in (N'P', N'PC'))
					DROP PROCEDURE [SP_GET_STOCK_ALL]
                IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SpGetStockLastStrategy]') AND type in (N'P', N'PC'))
                	DROP PROCEDURE [SpGetStockLastStrategy] 
                IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SpGetStoctProfile]') AND type in (N'P', N'PC'))
                	DROP PROCEDURE [SpGetStoctProfile]
                IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SpGetStockStrategy]') AND type in (N'P', N'PC'))
                	DROP PROCEDURE [SpGetStockStrategy]
                IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GET_NETBOOK]') AND type in (N'P', N'PC'))
                	DROP PROCEDURE [GET_NETBOOK]
                IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[add_multilevel_premium]') AND type in (N'P', N'PC'))
                	DROP PROCEDURE [add_multilevel_premium]
                IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[add_multilevel_sales]') AND type in (N'P', N'PC'))
                	DROP PROCEDURE [add_multilevel_sales]
                IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[get_mizan]') AND type in (N'P', N'PC'))
                	DROP PROCEDURE [get_mizan]
                <!---IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GET_STOCK_ANALYSE_STOCK]') AND type in (N'P', N'PC'))
                	DROP PROCEDURE [GET_STOCK_ANALYSE_STOCK]--->
            </cfquery> 
		<cfcatch type="any">
		</cfcatch>
	</cftry>

<cfquery name="CREATE_PERIOD_DB_SP" datasource="#new_dsn2#">
    	CREATE FUNCTION [fnSplit](
        @sInputList VARCHAR(8000) -- List of delimited items
        , @sDelimiter VARCHAR(8000) = ',' -- delimiter that separates items
        ) RETURNS @List TABLE (item VARCHAR(8000))
        
        BEGIN
        DECLARE @sItem VARCHAR(8000)
        WHILE CHARINDEX(@sDelimiter,@sInputList,0) <> 0
        BEGIN
        SELECT
        @sItem=RTRIM(LTRIM(SUBSTRING(@sInputList,1,CHARINDEX(@sDelimiter,@sInputList,0)-1))),
        @sInputList=RTRIM(LTRIM(SUBSTRING(@sInputList,CHARINDEX(@sDelimiter,@sInputList,0)+LEN(@sDelimiter),LEN(@sInputList))))
        
        IF LEN(@sItem) > 0
        INSERT INTO @List SELECT @sItem
        END
        
        IF LEN(@sInputList) > 0
        INSERT INTO @List SELECT @sInputList -- Put the last item in
        RETURN
        END
</cfquery>    
    
<cfquery name="ADD_SP" datasource="#new_dsn2#">
CREATE PROCEDURE [add_multilevel_premium]
			@invoice_id int
		AS
		DECLARE @LEN_REF int;
		DECLARE @LEN_REF2 int;
		DECLARE @REF_POS_CODE int;
		DECLARE @CONSCAT_ID int;
		DECLARE @CONSCAT_ID_2 int;
		DECLARE @PREMIUM_RATE float;
		DECLARE @REF_CODE nvarchar(250);
		DECLARE @REF_CODE_2 nvarchar(250);
		DECLARE @CONS_REF_CODE nvarchar(250);
		DECLARE @MONEY_TYPE nvarchar(20);
		DECLARE @REF_CONS_ID int;
		DECLARE @INV_INDX int;
		DECLARE @INV_CAT int;
		DECLARE @INV_DATE datetime;
		DECLARE @INV_IPTAL bit;
		DECLARE @GROSS_TOTAL float;
		DECLARE @CAMP_ID int;
		SET @INV_INDX = 1;
	
		DELETE FROM 
			INVOICE_MULTILEVEL_PREMIUM 
		WHERE 
			INVOICE_ID = @invoice_id
		SELECT 
			@REF_CONS_ID = CONSUMER_ID,
			@INV_IPTAL = ISNULL(IS_IPTAL,0),
			@INV_CAT = INVOICE_CAT,
			@INV_DATE = INVOICE_DATE,
			@REF_CODE = CONSUMER_REFERENCE_CODE,
			@CONS_REF_CODE = CONSUMER_REFERENCE_CODE
		FROM 
			INVOICE 
		WHERE 
			INVOICE_ID = @invoice_id
	
		SELECT @GROSS_TOTAL= (  SELECT 
									ISNULL(SUM(IR.GROSSTOTAL),0)
								FROM 
									INVOICE_ROW IR,
									#NEW_DSN3#.PRODUCT P
								WHERE 
									IR.INVOICE_ID = @invoice_id AND 
									IR.PRODUCT_ID = P.PRODUCT_ID AND 
									P.IS_INVENTORY = 1);
		SELECT @REF_POS_CODE =( SELECT 
									REF_POS_CODE 
								FROM 
									#new_dsn#.CONSUMER 
								WHERE 
									CONSUMER_ID = @REF_CONS_ID);
		SELECT @CONSCAT_ID   =( SELECT 
									CONSUMER_CAT_ID 
								FROM 
									#new_dsn#.CONSUMER 
								WHERE 
									CONSUMER_ID = @REF_POS_CODE);
		SELECT @MONEY_TYPE= (SELECT 
								MONEY
							FROM 
								SETUP_MONEY
							WHERE 
								RATE1=RATE2);
		SELECT @CAMP_ID = (SELECT TOP 1
							CAMP_ID
						FROM 
							#NEW_DSN3#.CAMPAIGNS 
						WHERE 
							CAMP_STARTDATE < @INV_DATE AND 
							CAMP_FINISHDATE > @INV_DATE);
	
		SET @LEN_REF = (LEN(REPLACE(@REF_CODE,'.','..'))-LEN(@REF_CODE)+1);
		SET @LEN_REF2 = LEN(@REF_CODE);
		IF (@INV_IPTAL <>1)
		BEGIN
			WHILE @INV_INDX <= @LEN_REF
				BEGIN  
	
					IF(CHARINDEX('.',@REF_CODE) <> 0)
						SET @REF_CODE_2 = LEFT(@REF_CODE,CHARINDEX('.',@REF_CODE)-1);
					ELSE
						SET @REF_CODE_2 = @REF_CODE;
					
					SELECT @CONSCAT_ID_2 = (SELECT 
												CONSUMER_CAT_ID 
											FROM 
												#new_dsn#.CONSUMER
											WHERE 
												CONSUMER_ID = @REF_CODE_2);
						
	
					SELECT @PREMIUM_RATE = (SELECT 
												PREMIUM_RATIO
											FROM
												#NEW_DSN3#.SETUP_CONSCAT_PREMIUM  
											WHERE 
												CAMPAIGN_ID = @CAMP_ID AND 
												CONSCAT_ID = @CONSCAT_ID_2 	AND 
												PREMIUM_LEVEL = @LEN_REF - @INV_INDX + 1 AND 
												(REF_MEMBER_CAT = @CONSCAT_ID OR REF_MEMBER_CAT IS NULL));
	
					IF(@PREMIUM_RATE IS NOT NULL)
					BEGIN 
						INSERT INTO	
							INVOICE_MULTILEVEL_PREMIUM
							(					
								CAMPAIGN_ID,
								INVOICE_ID,
								PREMIUM_DATE,
								REF_CONSUMER_ID,
								CONSUMER_ID,
								PREMIUM_LINE,
								PREMIUM_RATE,
								INVOICE_TOTAL,
								PREMIUM_SYSTEM_TOTAL,
								PREMIUM_SYSTEM_MONEY,
								CONSUMER_REFERENCE_CODE,
								PREMIUM_STATUS
							)
						VALUES
							(
								@CAMP_ID,
								@invoice_id,
								@INV_DATE,
								@REF_CONS_ID,
								@REF_CODE_2,
								@LEN_REF - @INV_INDX + 1,
								@PREMIUM_RATE,
								@GROSS_TOTAL,
								@GROSS_TOTAL*@PREMIUM_RATE/100,
								@MONEY_TYPE,
								@CONS_REF_CODE,
								1											
							)
					END;
	
					SET @REF_CODE = SUBSTRING(@REF_CODE,(CHARINDEX('.',@REF_CODE)+1),(@LEN_REF2-CHARINDEX('.',@REF_CODE))); 
					SET @INV_INDX = @INV_INDX+1;
			END;
		END;
</cfquery>

<cfquery name="ADD_SP" datasource="#new_dsn2#">
CREATE PROCEDURE [add_multilevel_sales]
			@invoice_id int
		AS
	DECLARE @LEN_REF int;
		DECLARE @LEN_REF2 int;
		DECLARE @REF_CODE nvarchar(250);
		DECLARE @REF_CODE_2 nvarchar(250);
		DECLARE @REF_CONS_ID int;
		DECLARE @INV_INDX int;
		DECLARE @INV_CAT int;
		DECLARE @INV_DATE datetime;
		DECLARE @INV_IPTAL bit;
		DECLARE @NET_TOTAL float;
		DECLARE @GROSS_TOTAL float;
		DECLARE @INV_NET_TOTAL float;
		DECLARE @INV_GROSS_TOTAL float;
		SET @INV_INDX = 1;
	
		DELETE FROM 
			INVOICE_MULTILEVEL_SALES 
		WHERE 
			INVOICE_ID = @invoice_id
	
		SELECT 
			@INV_IPTAL = ISNULL(IS_IPTAL,0),
			@INV_CAT = INVOICE_CAT,
			@INV_DATE = INVOICE_DATE,
			@REF_CODE = CONSUMER_REFERENCE_CODE,
			@REF_CONS_ID = CONSUMER_ID		
		FROM 
			INVOICE 
		WHERE 
			INVOICE_ID = @invoice_id
	
		SELECT @NET_TOTAL= (SELECT 
					ISNULL(SUM(IR.NETTOTAL),0)
				FROM 
					INVOICE_ROW IR,
					#NEW_DSN3#.PRODUCT P 
				WHERE 
					IR.INVOICE_ID = @invoice_id AND 
					IR.PRODUCT_ID = P.PRODUCT_ID AND 
					(P.IS_INVENTORY = 1 OR P.IS_KARMA = 1));
		SELECT @GROSS_TOTAL= (SELECT 
					ISNULL(SUM(IR.GROSSTOTAL),0)
				FROM 
					INVOICE_ROW IR,
					#NEW_DSN3#.PRODUCT P 
				WHERE 
					IR.INVOICE_ID = @invoice_id AND 
					IR.PRODUCT_ID = P.PRODUCT_ID AND 
					(P.IS_INVENTORY = 1 OR P.IS_KARMA = 1));
		SELECT @INV_NET_TOTAL= (SELECT 
					ISNULL(SUM(IR.NETTOTAL),0)
				FROM 
					INVOICE_ROW IR
				WHERE 
					IR.INVOICE_ID = @invoice_id);
		SELECT @INV_GROSS_TOTAL= (SELECT 
					ISNULL(SUM(IR.GROSSTOTAL),0)
				FROM 
					INVOICE_ROW IR
				WHERE 
					IR.INVOICE_ID = @invoice_id);
		SET @LEN_REF = (LEN(REPLACE(@REF_CODE,'.','..'))-LEN(@REF_CODE)+1);
		SET @LEN_REF2 = LEN(@REF_CODE);
		IF (@INV_IPTAL <>1)
		BEGIN
			WHILE @INV_INDX <= @LEN_REF
				BEGIN  
					IF(CHARINDEX('.',@REF_CODE) <> 0)
						SET @REF_CODE_2 = LEFT(@REF_CODE,CHARINDEX('.',@REF_CODE)-1);
					ELSE
						SET @REF_CODE_2 = @REF_CODE;
					INSERT INTO	
						INVOICE_MULTILEVEL_SALES
						(					
							INVOICE_ID,
							INVOICE_CAT,
							INVOICE_DATE,
							REF_CONSUMER_ID,
							CONSUMER_ID,
							GROSSTOTAL,
							NETTOTAL,
							INV_GROSSTOTAL,
							INV_NETTOTAL,
							SALE_STAGE
						)
					VALUES
						(
							@invoice_id,
							@INV_CAT,
							@INV_DATE,
							@REF_CONS_ID,
							@REF_CODE_2,
							@GROSS_TOTAL,
							@NET_TOTAL,
							@INV_GROSS_TOTAL,
							@INV_NET_TOTAL,
							@LEN_REF - @INV_INDX + 1					
						)
					SET @REF_CODE = SUBSTRING(@REF_CODE,(CHARINDEX('.',@REF_CODE)+1),(@LEN_REF2-CHARINDEX('.',@REF_CODE))); 
					SET @INV_INDX = @INV_INDX+1;
			END;
		END;
</cfquery>

<cfquery name="ADD_SP" datasource="#new_dsn2#">
CREATE PROCEDURE [DEL_COST_PRODUCT]
		@del_product_cost_id int
        AS
        BEGIN
            SET NOCOUNT ON;
            DELETE FROM #dsn1#.PRODUCT_COST WHERE PRODUCT_COST_ID = @del_product_cost_id
            DELETE FROM PRODUCT_COST_REFERENCE WHERE PRODUCT_COST_ID = @del_product_cost_id
        END
</cfquery>

<cfquery name="ADD_SP" datasource="#new_dsn2#">
CREATE PROCEDURE [DEL_COST_SHIP]
            @del_ship_id_list nvarchar(max),
            @del_cost_period_id INT,
            @paper_product_id_ INT
        AS
        BEGIN
            SET NOCOUNT ON;
            IF @paper_product_id_<> 0
                BEGIN
                    exec('DELETE FROM #dsn1#.PRODUCT_COST WHERE ACTION_ID  IN ('+@del_ship_id_list+') AND ACTION_TYPE = 2 AND ACTION_PERIOD_ID ='+ @del_cost_period_id+' AND PRODUCT_ID ='+ @paper_product_id_+'');
                END
            ELSE
                BEGIN
                    exec('DELETE FROM #dsn1#.PRODUCT_COST WHERE ACTION_ID IN ('+@del_ship_id_list+') AND ACTION_TYPE = 2 AND ACTION_PERIOD_ID ='+ @del_cost_period_id+''); 		
                END
                    exec('DELETE FROM PRODUCT_COST_REFERENCE WHERE ACTION_ID IN ('+@del_ship_id_list+') AND ACTION_TYPE = 2');
        END
</cfquery>

<cfquery name="ADD_SP" datasource="#new_dsn2#">
CREATE PROCEDURE [GET_ACCOUNT_PLAN]
				@is_xml bit,
				@account_code NVARCHAR(50),
				@startrow int,
				@maxrows int
			AS
			BEGIN
				
				SET NOCOUNT ON;
			
			   IF @is_xml = 1
					BEGIN
						IF LEN (@account_code) > 0 
							BEGIN
								IF isnumeric(left(@account_code,3)) = 1 
									BEGIN
										WITH CTE1 AS (
												SELECT
													SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC - ACCOUNT_ACCOUNT_REMAINDER.ALACAK) AS BAKIYE,
													ACCOUNT_PLAN.ACCOUNT_CODE, 
													ACCOUNT_PLAN.ACCOUNT_CODE2, 
													ACCOUNT_PLAN.ACCOUNT_NAME,
													ACCOUNT_PLAN.ACCOUNT_ID,
													ACCOUNT_PLAN.SUB_ACCOUNT,
													ACCOUNT_PLAN.IFRS_CODE, 
													ACCOUNT_PLAN.IFRS_NAME
												FROM
													ACCOUNT_PLAN
													LEFT JOIN ACCOUNT_ACCOUNT_REMAINDER ON 
													(
														(ACCOUNT_PLAN.SUB_ACCOUNT =1  AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID LIKE ACCOUNT_PLAN.ACCOUNT_CODE +'.%') 
														OR
														(ACCOUNT_PLAN.SUB_ACCOUNT=0 AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID = ACCOUNT_PLAN.ACCOUNT_CODE)
													)
												WHERE
													ACCOUNT_PLAN.ACCOUNT_ID IS NOT NULL
													AND ACCOUNT_PLAN.ACCOUNT_CODE LIKE ''+@account_code+'%'
												GROUP BY
													ACCOUNT_PLAN.ACCOUNT_CODE, 
													ACCOUNT_PLAN.ACCOUNT_CODE2, 
													ACCOUNT_PLAN.ACCOUNT_NAME,
													ACCOUNT_PLAN.SUB_ACCOUNT,
													ACCOUNT_PLAN.IFRS_CODE, 
													ACCOUNT_PLAN.IFRS_NAME,
													ACCOUNT_PLAN.ACCOUNT_ID
												),
				
											CTE2 AS (
													SELECT
														CTE1.*,
														ROW_NUMBER() OVER (ORDER BY ACCOUNT_CODE asc) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
													FROM
														CTE1
												)
												SELECT
													CTE2.*
												FROM
													CTE2
												WHERE
													RowNum BETWEEN @startrow and @startrow+(@maxrows-1)
									END
								ELSE
									BEGIN
										WITH CTE1 AS (
												SELECT
													SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC - ACCOUNT_ACCOUNT_REMAINDER.ALACAK) AS BAKIYE,
													ACCOUNT_PLAN.ACCOUNT_CODE, 
													ACCOUNT_PLAN.ACCOUNT_CODE2, 
													ACCOUNT_PLAN.ACCOUNT_NAME,
													ACCOUNT_PLAN.ACCOUNT_ID,
													ACCOUNT_PLAN.SUB_ACCOUNT,
													ACCOUNT_PLAN.IFRS_CODE, 
													ACCOUNT_PLAN.IFRS_NAME
												FROM
													ACCOUNT_PLAN
													LEFT JOIN ACCOUNT_ACCOUNT_REMAINDER ON 
													(
														(ACCOUNT_PLAN.SUB_ACCOUNT =  1 AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID LIKE ACCOUNT_PLAN.ACCOUNT_CODE +'.%') OR
														(ACCOUNT_PLAN.SUB_ACCOUNT=0 AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID = ACCOUNT_PLAN.ACCOUNT_CODE)
													)
												WHERE
													ACCOUNT_PLAN.ACCOUNT_ID IS NOT NULL
													AND ACCOUNT_PLAN.ACCOUNT_NAME LIKE '%'+@account_code+'%'
												GROUP BY
													ACCOUNT_PLAN.ACCOUNT_CODE, 
													ACCOUNT_PLAN.ACCOUNT_CODE2, 
													ACCOUNT_PLAN.ACCOUNT_NAME,
													ACCOUNT_PLAN.SUB_ACCOUNT,
													ACCOUNT_PLAN.IFRS_CODE, 
													ACCOUNT_PLAN.IFRS_NAME,
													ACCOUNT_PLAN.ACCOUNT_ID
												),
				
											CTE2 AS (
													SELECT
														CTE1.*,
														ROW_NUMBER() OVER (ORDER BY ACCOUNT_CODE asc) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
													FROM
														CTE1
												)
												SELECT
													CTE2.*
												FROM
													CTE2
												WHERE
													RowNum BETWEEN @startrow and @startrow+(@maxrows-1)
									END
							END
						ELSE
							BEGIN
								WITH CTE1 AS (
												SELECT
													SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC - ACCOUNT_ACCOUNT_REMAINDER.ALACAK) AS BAKIYE,
													ACCOUNT_PLAN.ACCOUNT_CODE, 
													ACCOUNT_PLAN.ACCOUNT_CODE2, 
													ACCOUNT_PLAN.ACCOUNT_NAME,
													ACCOUNT_PLAN.ACCOUNT_ID,
													ACCOUNT_PLAN.SUB_ACCOUNT,
													ACCOUNT_PLAN.IFRS_CODE, 
													ACCOUNT_PLAN.IFRS_NAME
												FROM
													ACCOUNT_PLAN
													LEFT JOIN ACCOUNT_ACCOUNT_REMAINDER ON 
													(
														(ACCOUNT_PLAN.SUB_ACCOUNT = 1 AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID LIKE ACCOUNT_PLAN.ACCOUNT_CODE +'.%') OR
														(ACCOUNT_PLAN.SUB_ACCOUNT=0 AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID = ACCOUNT_PLAN.ACCOUNT_CODE)
													)
												WHERE
													ACCOUNT_PLAN.ACCOUNT_ID IS NOT NULL
												GROUP BY
													ACCOUNT_PLAN.ACCOUNT_CODE, 
													ACCOUNT_PLAN.ACCOUNT_CODE2, 
													ACCOUNT_PLAN.ACCOUNT_NAME,
													ACCOUNT_PLAN.SUB_ACCOUNT,
													ACCOUNT_PLAN.IFRS_CODE, 
													ACCOUNT_PLAN.IFRS_NAME,
													ACCOUNT_PLAN.ACCOUNT_ID
												),
				
										CTE2 AS (
													SELECT
														CTE1.*,
														ROW_NUMBER() OVER (ORDER BY ACCOUNT_CODE asc) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
													FROM
														CTE1
												)
												SELECT
													CTE2.*
												FROM
													CTE2
												WHERE
													RowNum BETWEEN @startrow and @startrow+(@maxrows-1)
							END
					END
			
				ELSE
					BEGIN
						IF LEN (@account_code) > 0 
							BEGIN
								IF isnumeric(left(@account_code,3)) = 1 
									BEGIN
										WITH CTE1 AS (
												SELECT
													ACCOUNT_PLAN.ACCOUNT_CODE, 
													ACCOUNT_PLAN.ACCOUNT_CODE2, 
													ACCOUNT_PLAN.ACCOUNT_NAME,
													ACCOUNT_PLAN.ACCOUNT_ID,
													ACCOUNT_PLAN.SUB_ACCOUNT,
													ACCOUNT_PLAN.IFRS_CODE, 
													ACCOUNT_PLAN.IFRS_NAME
												FROM
													ACCOUNT_PLAN
												WHERE
													ACCOUNT_PLAN.ACCOUNT_ID IS NOT NULL
													AND ACCOUNT_PLAN.ACCOUNT_CODE LIKE ''+@account_code+'%'
												GROUP BY
													ACCOUNT_PLAN.ACCOUNT_CODE, 
													ACCOUNT_PLAN.ACCOUNT_CODE2, 
													ACCOUNT_PLAN.ACCOUNT_NAME,
													ACCOUNT_PLAN.SUB_ACCOUNT,
													ACCOUNT_PLAN.IFRS_CODE, 
													ACCOUNT_PLAN.IFRS_NAME,
													ACCOUNT_PLAN.ACCOUNT_ID
												),
				
											CTE2 AS (
													SELECT
														CTE1.*,
														ROW_NUMBER() OVER (ORDER BY ACCOUNT_CODE asc) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
													FROM
														CTE1
												)
												SELECT
													CTE2.*
												FROM
													CTE2
												WHERE
													RowNum BETWEEN @startrow and @startrow+(@maxrows-1)
									END
								ELSE
									BEGIN
										WITH CTE1 AS (
												SELECT
													ACCOUNT_PLAN.ACCOUNT_CODE, 
													ACCOUNT_PLAN.ACCOUNT_CODE2, 
													ACCOUNT_PLAN.ACCOUNT_NAME,
													ACCOUNT_PLAN.ACCOUNT_ID,
													ACCOUNT_PLAN.SUB_ACCOUNT,
													ACCOUNT_PLAN.IFRS_CODE, 
													ACCOUNT_PLAN.IFRS_NAME
												FROM
													ACCOUNT_PLAN
												WHERE
													ACCOUNT_PLAN.ACCOUNT_ID IS NOT NULL
													AND ACCOUNT_PLAN.ACCOUNT_NAME LIKE '%'+@account_code+'%'
												GROUP BY
													ACCOUNT_PLAN.ACCOUNT_CODE, 
													ACCOUNT_PLAN.ACCOUNT_CODE2, 
													ACCOUNT_PLAN.ACCOUNT_NAME,
													ACCOUNT_PLAN.SUB_ACCOUNT,
													ACCOUNT_PLAN.IFRS_CODE, 
													ACCOUNT_PLAN.IFRS_NAME,
													ACCOUNT_PLAN.ACCOUNT_ID
												),
				
											CTE2 AS (
													SELECT
														CTE1.*,
														ROW_NUMBER() OVER (ORDER BY ACCOUNT_CODE asc) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
													FROM
														CTE1
												)
												SELECT
													CTE2.*
												FROM
													CTE2
												WHERE
													RowNum BETWEEN @startrow and @startrow+(@maxrows-1)
									END
							END
						ELSE
							BEGIN
								WITH CTE1 AS (
												SELECT
													ACCOUNT_PLAN.ACCOUNT_CODE, 
													ACCOUNT_PLAN.ACCOUNT_CODE2, 
													ACCOUNT_PLAN.ACCOUNT_NAME,
													ACCOUNT_PLAN.ACCOUNT_ID,
													ACCOUNT_PLAN.SUB_ACCOUNT,
													ACCOUNT_PLAN.IFRS_CODE, 
													ACCOUNT_PLAN.IFRS_NAME
												FROM
													ACCOUNT_PLAN
												WHERE
													ACCOUNT_PLAN.ACCOUNT_ID IS NOT NULL
												GROUP BY
													ACCOUNT_PLAN.ACCOUNT_CODE, 
													ACCOUNT_PLAN.ACCOUNT_CODE2, 
													ACCOUNT_PLAN.ACCOUNT_NAME,
													ACCOUNT_PLAN.SUB_ACCOUNT,
													ACCOUNT_PLAN.IFRS_CODE, 
													ACCOUNT_PLAN.IFRS_NAME,
													ACCOUNT_PLAN.ACCOUNT_ID
												),
				
										CTE2 AS (
													SELECT
														CTE1.*,
														ROW_NUMBER() OVER (ORDER BY ACCOUNT_CODE asc) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
													FROM
														CTE1
												)
												SELECT
													CTE2.*
												FROM
													CTE2
												WHERE
													RowNum BETWEEN @startrow and @startrow+(@maxrows-1)
							END
					END
			END
</cfquery>

<cfquery name="ADD_SP" datasource="#new_dsn2#">
CREATE PROCEDURE [GET_ACTION] 
            @recordcount int ,
            @IS_WITH_SHIP BIT,
            @paper_product_id int, 
            @paper_action_id int,
            @paper_action_type int,
            @cost_money_system_2 NVARCHAR(50) 
        AS
        BEGIN
            
            SET NOCOUNT ON;
                        
                    IF @paper_action_type = 1
                        BEGIN 
                            IF (@recordcount = 1 )
                                BEGIN
                                    IF @IS_WITH_SHIP = 0
                                        BEGIN
                                                SELECT
                                                    SHIP.SHIP_ID,
                                                    INVOICE_ROW.INVOICE_ROW_ID ACTION_ROW_ID,
                                                    INVOICE.RECORD_DATE INSERT_DATE,
                                                    INVOICE.INVOICE_DATE PAPER_DATE,
                                                    ISNULL(SHIP.DELIVER_DATE,SHIP.SHIP_DATE) ACTION_DATE,
                                                    INVOICE_ROW.AMOUNT AMOUNT,
                                                    INVOICE_ROW.SPECT_VAR_ID SPEC_ID,
                                                    STOCKS.STOCK_ID,
                                                    STOCKS.PRODUCT_ID,
                                                    INVOICE.PROCESS_CAT,
                                                    INVOICE.DEPARTMENT_ID ACTION_DEPARTMENT_ID,
                                                    INVOICE.DEPARTMENT_LOCATION ACTION_LOCATION_ID,
                                                    INVOICE_ROW.DUE_DATE,
                                                    INVOICE.INVOICE_DATE
                                                FROM
                                                    SHIP,
                                                    INVOICE,
                                                    INVOICE_ROW,
                                                    #dsn1#.STOCKS STOCKS,
                                                    #dsn1#.PRODUCT PRODUCT
                                                WHERE
                                                    INVOICE.INVOICE_ID =@paper_action_id AND
                                                    INVOICE.INVOICE_ID=INVOICE_ROW.INVOICE_ID AND
                                                    INVOICE_ROW.SHIP_ID=SHIP.SHIP_ID AND
                                                    STOCKS.STOCK_ID=INVOICE_ROW.STOCK_ID AND
                                                    STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID AND
                                                    PRODUCT.IS_COST=1
                                                ORDER BY
                                                    ISNULL(SHIP.DELIVER_DATE,SHIP.SHIP_DATE),
                                                    STOCKS.PRODUCT_ID,
                                                    INVOICE_ROW.INVOICE_ROW_ID
                                        END
        
                                    ELSE
                                        BEGIN
                                            SELECT
                                                SHIP.SHIP_ID,
                                                INVOICE_ROW.INVOICE_ROW_ID ACTION_ROW_ID,
                                                INVOICE.RECORD_DATE INSERT_DATE,
                                                INVOICE.INVOICE_DATE PAPER_DATE,
                                                ISNULL(SHIP.DELIVER_DATE,SHIP.SHIP_DATE) ACTION_DATE,
                                                INVOICE_ROW.AMOUNT AMOUNT,
                                                INVOICE_ROW.SPECT_VAR_ID SPEC_ID,
                                                STOCKS.STOCK_ID,
                                                STOCKS.PRODUCT_ID,
                                                INVOICE.PROCESS_CAT,
                                                INVOICE.DEPARTMENT_ID ACTION_DEPARTMENT_ID,
                                                INVOICE.DEPARTMENT_LOCATION ACTION_LOCATION_ID,
                                                INVOICE_ROW.DUE_DATE,
                                                INVOICE.INVOICE_DATE
                                            FROM
                                                SHIP,
                                                INVOICE,
                                                INVOICE_ROW,
                                                INVOICE_SHIPS,
                                                #dsn1#.STOCKS STOCKS,
                                                #dsn1#.PRODUCT PRODUCT
                                            WHERE
                                                INVOICE.INVOICE_ID = @paper_action_id AND
                                                INVOICE.INVOICE_ID=INVOICE_ROW.INVOICE_ID AND
                                                INVOICE_SHIPS.SHIP_ID=SHIP.SHIP_ID AND
                                                INVOICE_SHIPS.INVOICE_ID=INVOICE.INVOICE_ID AND
                                                STOCKS.STOCK_ID=INVOICE_ROW.STOCK_ID AND
                                                STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID AND
                                                PRODUCT.IS_COST=1 
                                            ORDER BY
                                                ISNULL(SHIP.DELIVER_DATE,SHIP.SHIP_DATE),
                                                STOCKS.PRODUCT_ID,
                                                INVOICE_ROW.INVOICE_ROW_ID
                                        END
                                END
                            ELSE
                                BEGIN
                                        SELECT DISTINCT
                                            1 INV_CONT_COMP,
                                            SHIP.SHIP_ID,
                                            INVOICE.INVOICE_ID,
                                            INVOICE_ROW.INVOICE_ROW_ID ACTION_ROW_ID,
                                            INVOICE.RECORD_DATE INSERT_DATE,
                                            INVOICE.INVOICE_DATE PAPER_DATE,
                                            ISNULL(SHIP.DELIVER_DATE,SHIP.SHIP_DATE) ACTION_DATE,
                                            INVOICE_ROW.AMOUNT AMOUNT,
                                            INVOICE_ROW.SPECT_VAR_ID SPEC_ID,
                                            STOCKS.STOCK_ID,
                                            STOCKS.PRODUCT_ID,
                                            INVOICE.PROCESS_CAT,
                                            INVOICE.DEPARTMENT_ID ACTION_DEPARTMENT_ID,
                                            INVOICE.DEPARTMENT_LOCATION ACTION_LOCATION_ID,
                                            INVOICE_ROW.DUE_DATE,
                                            INVOICE.INVOICE_DATE
                                        FROM
                                            SHIP,
                                            INVOICE,
                                            INVOICE_ROW,
                                            INVOICE_SHIPS,
                                            INVOICE_CONTRACT_COMPARISON,
                                            #dsn1#.STOCKS STOCKS,
                                            #dsn1#.PRODUCT PRODUCT
                                        WHERE
                                            INVOICE_CONTRACT_COMPARISON.DIFF_INVOICE_ID =@paper_action_id AND
                                            INVOICE.INVOICE_ID=INVOICE_CONTRACT_COMPARISON.MAIN_INVOICE_ID AND
                                            INVOICE.INVOICE_ID=INVOICE_ROW.INVOICE_ID AND
                                            INVOICE_SHIPS.SHIP_ID=SHIP.SHIP_ID AND
                                            INVOICE_SHIPS.INVOICE_ID=INVOICE.INVOICE_ID AND
                                            STOCKS.STOCK_ID=INVOICE_ROW.STOCK_ID AND
                                            STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID AND
                                            PRODUCT.IS_COST=1
        
                                        ORDER BY
                                            ISNULL(SHIP.DELIVER_DATE,SHIP.SHIP_DATE),
                                            STOCKS.PRODUCT_ID,
                                            INVOICE_ROW.INVOICE_ROW_ID
                                END
                        END
                    ELSE
                        IF  @paper_action_type = 2
                            BEGIN
                                SELECT
                                    SHIP.SHIP_ID,
                                    SHIP_ROW.SHIP_ROW_ID ACTION_ROW_ID,
                                    SHIP.RECORD_DATE INSERT_DATE,
                                    SHIP.SHIP_DATE PAPER_DATE,
                                    SHIP.DELIVER_DATE ACTION_DATE,
                                    SHIP_ROW.AMOUNT AMOUNT,
                                    SHIP_ROW.SPECT_VAR_ID SPEC_ID,
                                    STOCKS.STOCK_ID,
                                    STOCKS.PRODUCT_ID,
                                    SHIP.PROCESS_CAT,
                                    ISNULL(SHIP.DEPARTMENT_IN,SHIP.DELIVER_STORE_ID) ACTION_DEPARTMENT_ID,
                                    ISNULL(SHIP.LOCATION_IN,SHIP.LOCATION) ACTION_LOCATION_ID
                                FROM 
                                    SHIP,
                                    SHIP_ROW,
                                    #dsn1#.STOCKS STOCKS,
                                    #dsn1#.PRODUCT PRODUCT
                                WHERE
                                    SHIP.SHIP_ID = @paper_action_id AND
                                    SHIP.SHIP_ID = SHIP_ROW.SHIP_ID AND
                                    STOCKS.STOCK_ID = SHIP_ROW.STOCK_ID AND
                                    STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
                                    PRODUCT.IS_COST = 1
                                ORDER BY
                                    STOCKS.PRODUCT_ID,
                                    SHIP_ROW.SHIP_ROW_ID
                            END
                        ELSE
                            IF @paper_action_type = 3
                                BEGIN
                                    SELECT
                                        STOCK_FIS_ROW.STOCK_FIS_ROW_ID ACTION_ROW_ID,
                                        STOCK_FIS.RECORD_DATE INSERT_DATE,
                                        STOCK_FIS.FIS_DATE PAPER_DATE,
                                        STOCK_FIS.FIS_DATE ACTION_DATE,
                                        STOCK_FIS_ROW.AMOUNT AMOUNT,
                                        STOCK_FIS_ROW.SPECT_VAR_ID SPEC_ID,
                                        STOCKS.STOCK_ID,
                                        STOCKS.PRODUCT_ID,
                                        STOCK_FIS.PROCESS_CAT,
                                        STOCK_FIS.DEPARTMENT_IN ACTION_DEPARTMENT_ID,
                                        STOCK_FIS.LOCATION_IN ACTION_LOCATION_ID,
                                        ISNULL(STOCK_FIS_ROW.DUE_DATE,0) DUE_DATE,
                                        STOCK_FIS_ROW.RESERVE_DATE
                                    FROM 
                                        STOCK_FIS,
                                        STOCK_FIS_ROW,
                                        #dsn1#.STOCKS STOCKS,
                                        #dsn1#.PRODUCT PRODUCT
                                    WHERE
                                        STOCK_FIS.FIS_ID = @paper_action_id AND
                                        STOCK_FIS.FIS_ID = STOCK_FIS_ROW.FIS_ID AND
                                        STOCKS.STOCK_ID = STOCK_FIS_ROW.STOCK_ID AND
                                        STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
                                        PRODUCT.IS_COST=1 
                                    ORDER BY
                                        STOCKS.PRODUCT_ID,STOCK_FIS_ROW.STOCK_FIS_ROW_ID	
                                END
                            ELSE
                                IF @paper_action_type = 4
                                    BEGIN
                                            SELECT
                                                PORR.PR_ORDER_ROW_ID ACTION_ROW_ID,
                                                ISNULL(POR.UPDATE_DATE,POR.RECORD_DATE) INSERT_DATE,
                                                POR.FINISH_DATE PAPER_DATE,
                                                POR.FINISH_DATE ACTION_DATE,
                                                PORR.AMOUNT,
                                                PORR.SPECT_ID SPEC_ID,
                                                PORR.SPEC_MAIN_ID EXCHANGE_SPECT_MAIN_ID,
                                                (PORR.PURCHASE_NET_SYSTEM++ISNULL(PORR.PURCHASE_EXTRA_COST_SYSTEM,0)) PURCHASE_NET_SYSTEM,
                                                PORR.PURCHASE_NET_SYSTEM_MONEY,
                                                (ISNULL(PORR.LABOR_COST_SYSTEM,0)+ISNULL(PORR.STATION_REFLECTION_COST_SYSTEM,0)) AS PURCHASE_EXTRA_COST_SYSTEM,
                                                STOCKS.STOCK_ID,
                                                STOCKS.PRODUCT_ID,
                                                POR.PROCESS_ID PROCESS_CAT,
                                                POR.PRODUCTION_DEP_ID ACTION_DEPARTMENT_ID,
                                                POR.PRODUCTION_LOC_ID ACTION_LOCATION_ID
                                            FROM 
                                                PRODUCTION_ORDERS PO,
                                                PRODUCTION_ORDER_RESULTS POR,
                                                PRODUCTION_ORDER_RESULTS_ROW PORR,
                                                #dsn1#.STOCKS STOCKS,
                                                #dsn1#.PRODUCT PRODUCT
                                            WHERE
                                                POR.PR_ORDER_ID = @paper_action_id AND
                                                PO.P_ORDER_ID = POR.P_ORDER_ID AND
                                                POR.PR_ORDER_ID = PORR.PR_ORDER_ID AND
                                                STOCKS.STOCK_ID = PORR.STOCK_ID AND
                                                STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
                                                PRODUCT.IS_COST = 1 AND
                                                PORR.TYPE = 1 AND
                                                ISNULL(PORR.IS_FREE_AMOUNT,0) <> 1 AND
                                                PO.IS_DEMONTAJ <> 1
                                            ORDER BY
                                                STOCKS.PRODUCT_ID,PORR.PR_ORDER_ROW_ID
                                    END
                                ELSE
                                    IF @paper_action_type = 5 OR @paper_action_type = 7
                                        BEGIN
                                            IF @paper_action_type <> 5 
                                                BEGIN
                                                    SELECT
                                                        STOCK_EXCHANGE.EXCHANGE_NUMBER ACTION_NUMBER,
                                                        STOCK_EXCHANGE.STOCK_EXCHANGE_ID ACTION_ROW_ID,
                                                        STOCK_EXCHANGE.PROCESS_DATE INSERT_DATE,
                                                        STOCK_EXCHANGE.PROCESS_DATE PAPER_DATE,
                                                        STOCK_EXCHANGE.PROCESS_DATE ACTION_DATE,
                                                        STOCK_EXCHANGE.AMOUNT,
                                                        STOCK_EXCHANGE.SPECT_ID SPEC_ID,
                                                        STOCK_EXCHANGE.SPECT_MAIN_ID EXCHANGE_SPECT_MAIN_ID,
                                                        STOCK_EXCHANGE.STOCK_ID,
                                                        STOCK_EXCHANGE.PRODUCT_ID,
                                                        PRODUCT.PRODUCT_ID,
                                                        STOCK_EXCHANGE.PROCESS_CAT PROCESS_CAT,
                                                        STOCK_EXCHANGE.DEPARTMENT_ID ACTION_DEPARTMENT_ID,
                                                        STOCK_EXCHANGE.LOCATION_ID ACTION_LOCATION_ID
                                                    FROM
                                                        STOCK_EXCHANGE,
                                                        #dsn1#.PRODUCT PRODUCT
                                                    WHERE
                                                        PRODUCT.PRODUCT_ID=STOCK_EXCHANGE.PRODUCT_ID AND
                                                            STOCK_EXCHANGE.EXCHANGE_NUMBER = (SELECT EXCHANGE_NUMBER FROM STOCK_EXCHANGE WHERE STOCK_EXCHANGE_ID = @paper_action_id)
                                                    ORDER BY
                                                        PRODUCT.PRODUCT_ID,STOCK_EXCHANGE.STOCK_EXCHANGE_ID
                                                END
                                            ELSE
                                                BEGIN
                                                    SELECT
                                                        STOCK_EXCHANGE.EXCHANGE_NUMBER ACTION_NUMBER,
                                                        STOCK_EXCHANGE.STOCK_EXCHANGE_ID ACTION_ROW_ID,
                                                        STOCK_EXCHANGE.PROCESS_DATE INSERT_DATE,
                                                        STOCK_EXCHANGE.PROCESS_DATE PAPER_DATE,
                                                        STOCK_EXCHANGE.PROCESS_DATE ACTION_DATE,
                                                        STOCK_EXCHANGE.AMOUNT,
                                                        STOCK_EXCHANGE.SPECT_ID SPEC_ID,
                                                        STOCK_EXCHANGE.SPECT_MAIN_ID EXCHANGE_SPECT_MAIN_ID,
                                                        STOCK_EXCHANGE.STOCK_ID,
                                                        STOCK_EXCHANGE.PRODUCT_ID,
                                                        PRODUCT.PRODUCT_ID,
                                                        STOCK_EXCHANGE.PROCESS_CAT PROCESS_CAT,
                                                        STOCK_EXCHANGE.DEPARTMENT_ID ACTION_DEPARTMENT_ID,
                                                        STOCK_EXCHANGE.LOCATION_ID ACTION_LOCATION_ID
                                                    FROM
                                                        STOCK_EXCHANGE,
                                                        #dsn1#.PRODUCT PRODUCT
                                                    WHERE
                                                        PRODUCT.PRODUCT_ID=STOCK_EXCHANGE.PRODUCT_ID AND
                                                            STOCK_EXCHANGE.STOCK_EXCHANGE_ID =@paper_action_id
                                                    ORDER BY
                                                        PRODUCT.PRODUCT_ID,STOCK_EXCHANGE.STOCK_EXCHANGE_ID
                                                END	
                                        END
        
                                    ELSE
                                        IF @paper_action_type = 6 
                                            BEGIN
                                                    SELECT
                                                        EXPENSE_ITEMS_ROWS.EXP_ITEM_ROWS_ID ACTION_ROW_ID,
                                                        EXPENSE_ITEM_PLANS.RECORD_DATE INSERT_DATE,
                                                        EXPENSE_ITEM_PLANS.EXPENSE_DATE PAPER_DATE,
                                                        EXPENSE_ITEM_PLANS.EXPENSE_DATE ACTION_DATE,
                                                        EXPENSE_ITEMS_ROWS.QUANTITY AMOUNT,
                                                        NULL SPEC_ID,
                                                        NULL EXCHANGE_SPECT_MAIN_ID,
                                                        EXPENSE_ITEMS_ROWS.STOCK_ID,
                                                        EXPENSE_ITEMS_ROWS.PRODUCT_ID,
                                                        EXPENSE_ITEM_PLANS.PROCESS_CAT PROCESS_CAT,
                                                        EXPENSE_ITEM_PLANS.DEPARTMENT_ID ACTION_DEPARTMENT_ID,
                                                        EXPENSE_ITEM_PLANS.LOCATION_ID ACTION_LOCATION_ID
                                                    FROM
                                                        EXPENSE_ITEM_PLANS,
                                                        EXPENSE_ITEMS_ROWS,
                                                        #dsn1#.PRODUCT PRODUCT
                                                    WHERE
                                                        EXPENSE_ITEM_PLANS.EXPENSE_ID = @paper_action_id AND
                                                        EXPENSE_ITEM_PLANS.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID AND
                                                        PRODUCT.PRODUCT_ID = EXPENSE_ITEMS_ROWS.PRODUCT_ID 
                                                    ORDER BY
                                                        PRODUCT.PRODUCT_ID,EXPENSE_ITEMS_ROWS.EXP_ITEM_ROWS_ID
                                            END
                                        ELSE
                                            IF @paper_action_type = 8
                                            BEGIN
                                                    SELECT		
                                                        PRODUCT_COST_INVOICE.PRODUCT_COST_INVOICE_ID ACTION_ROW_ID,
                                                        PRODUCT_COST_INVOICE.RECORD_DATE INSERT_DATE,
                                                        PRODUCT_COST_INVOICE.COST_DATE PAPER_DATE,
                                                        PRODUCT_COST_INVOICE.COST_DATE ACTION_DATE,
                                                        PRODUCT_COST_INVOICE.AMOUNT,
                                                        NULL SPEC_ID,
                                                        PRODUCT_COST_INVOICE.SPECT_MAIN_ID EXCHANGE_SPECT_MAIN_ID,
                                                        PRODUCT_COST_INVOICE.PRODUCT_ID,
                                                        PRODUCT_COST_INVOICE.STOCK_ID,
                                                        INVOICE.PROCESS_CAT,
                                                        INVOICE.DEPARTMENT_ID ACTION_DEPARTMENT_ID,
                                                        INVOICE.DEPARTMENT_LOCATION ACTION_LOCATION_ID,
                                                        INVOICE.INVOICE_ID,
                                                        PRODUCT.PRODUCT_ID,
                                                        PRODUCT_COST_INVOICE.COST_TYPE_ID,
                                                        PRODUCT_COST_INVOICE.PRICE_PROTECTION_TYPE,
                                                        PRODUCT_COST_INVOICE.PRICE_PROTECTION,
                                                        PRODUCT_COST_INVOICE.PRICE_PROTECTION_MONEY,		
                                                        PRODUCT_COST_INVOICE.TOTAL_PRICE_PROTECTION,
                                                        ISNULL((
                                                            SELECT TOP 1 MONEY FROM #NEW_DSN3#.PRODUCT_COST 
                                                            WHERE
                                                                PRODUCT_ID = PRODUCT_COST_INVOICE.PRODUCT_ID AND
                                                                START_DATE <= PRODUCT_COST_INVOICE.COST_DATE
                                                                AND	ISNULL(SPECT_MAIN_ID,0) = ISNULL(PRODUCT_COST_INVOICE.SPECT_MAIN_ID,0)
                                                            ORDER BY
                                                                START_DATE DESC,
                                                                RECORD_DATE DESC,
                                                                PRODUCT_COST_ID DESC
                                                        ),@cost_money_system_2) MONEY
                                                    FROM
                                                        PRODUCT_COST_INVOICE,
                                                        INVOICE,
                                                        #dsn1#.PRODUCT PRODUCT
                                                    WHERE
                                                        PRODUCT_COST_INVOICE.INVOICE_ID = @paper_action_id AND
                                                        PRODUCT_COST_INVOICE.INVOICE_ID = INVOICE.INVOICE_ID AND
                                                        PRODUCT.PRODUCT_ID = PRODUCT_COST_INVOICE.PRODUCT_ID
                                                    ORDER BY
                                                        PRODUCT_COST_INVOICE.COST_DATE,
                                                        PRODUCT.PRODUCT_ID,PRODUCT_COST_INVOICE.PRODUCT_COST_INVOICE_ID
                                            END
        END
</cfquery>

<cfquery name="ADD_SP" datasource="#new_dsn2#">
CREATE PROCEDURE [GET_ACTION_PRODUCT] 
            @recordcount int ,
            @IS_WITH_SHIP BIT,
            @paper_product_id int, 
            @paper_action_id int,
            @paper_action_type int,
            @cost_money_system_2 NVARCHAR(50) 
            AS
            BEGIN
            
            SET NOCOUNT ON;
                        
                    IF @paper_action_type = 1
                        BEGIN 
                            IF (@recordcount = 1 )
                                BEGIN
                                    IF @IS_WITH_SHIP = 0
                                        BEGIN
                                                SELECT
                                                    SHIP.SHIP_ID,
                                                    INVOICE_ROW.INVOICE_ROW_ID ACTION_ROW_ID,
                                                    INVOICE.RECORD_DATE INSERT_DATE,
                                                    INVOICE.INVOICE_DATE PAPER_DATE,
                                                    ISNULL(SHIP.DELIVER_DATE,SHIP.SHIP_DATE) ACTION_DATE,
                                                    INVOICE_ROW.AMOUNT AMOUNT,
                                                    INVOICE_ROW.SPECT_VAR_ID SPEC_ID,
                                                    STOCKS.STOCK_ID,
                                                    STOCKS.PRODUCT_ID,
                                                    INVOICE.PROCESS_CAT,
                                                    INVOICE.DEPARTMENT_ID ACTION_DEPARTMENT_ID,
                                                    INVOICE.DEPARTMENT_LOCATION ACTION_LOCATION_ID,
                                                    INVOICE_ROW.DUE_DATE,
                                                    INVOICE.INVOICE_DATE
                                                FROM
                                                    SHIP,
                                                    INVOICE,
                                                    INVOICE_ROW,
                                                    #dsn1#.STOCKS STOCKS,
                                                    #dsn1#.PRODUCT PRODUCT
                                                WHERE
                                                    INVOICE.INVOICE_ID =@paper_action_id AND
                                                    INVOICE.INVOICE_ID=INVOICE_ROW.INVOICE_ID AND
                                                    INVOICE_ROW.SHIP_ID=SHIP.SHIP_ID AND
                                                    STOCKS.STOCK_ID=INVOICE_ROW.STOCK_ID AND
                                                    STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID AND
                                                    PRODUCT.IS_COST=1
                                                    AND PRODUCT.PRODUCT_ID =@paper_product_id
                                                ORDER BY
                                                    ISNULL(SHIP.DELIVER_DATE,SHIP.SHIP_DATE),
                                                    STOCKS.PRODUCT_ID,
                                                    INVOICE_ROW.INVOICE_ROW_ID
                                        END
            
                                    ELSE
                                        BEGIN
                                            SELECT
                                                SHIP.SHIP_ID,
                                                INVOICE_ROW.INVOICE_ROW_ID ACTION_ROW_ID,
                                                INVOICE.RECORD_DATE INSERT_DATE,
                                                INVOICE.INVOICE_DATE PAPER_DATE,
                                                ISNULL(SHIP.DELIVER_DATE,SHIP.SHIP_DATE) ACTION_DATE,
                                                INVOICE_ROW.AMOUNT AMOUNT,
                                                INVOICE_ROW.SPECT_VAR_ID SPEC_ID,
                                                STOCKS.STOCK_ID,
                                                STOCKS.PRODUCT_ID,
                                                INVOICE.PROCESS_CAT,
                                                INVOICE.DEPARTMENT_ID ACTION_DEPARTMENT_ID,
                                                INVOICE.DEPARTMENT_LOCATION ACTION_LOCATION_ID,
                                                INVOICE_ROW.DUE_DATE,
                                                INVOICE.INVOICE_DATE
                                            FROM
                                                SHIP,
                                                INVOICE,
                                                INVOICE_ROW,
                                                INVOICE_SHIPS,
                                                #dsn1#.STOCKS STOCKS,
                                                #dsn1#.PRODUCT PRODUCT
                                            WHERE
                                                INVOICE.INVOICE_ID = @paper_action_id AND
                                                INVOICE.INVOICE_ID=INVOICE_ROW.INVOICE_ID AND
                                                INVOICE_SHIPS.SHIP_ID=SHIP.SHIP_ID AND
                                                INVOICE_SHIPS.INVOICE_ID=INVOICE.INVOICE_ID AND
                                                STOCKS.STOCK_ID=INVOICE_ROW.STOCK_ID AND
                                                STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID AND
                                                PRODUCT.IS_COST=1 AND 
                                                PRODUCT.PRODUCT_ID = @paper_product_id
                                            ORDER BY
                                                ISNULL(SHIP.DELIVER_DATE,SHIP.SHIP_DATE),
                                                STOCKS.PRODUCT_ID,
                                                INVOICE_ROW.INVOICE_ROW_ID
                                        END
                                END
                            ELSE
                                BEGIN
                                        SELECT DISTINCT
                                            1 INV_CONT_COMP,
                                            SHIP.SHIP_ID,
                                            INVOICE.INVOICE_ID,
                                            INVOICE_ROW.INVOICE_ROW_ID ACTION_ROW_ID,
                                            INVOICE.RECORD_DATE INSERT_DATE,
                                            INVOICE.INVOICE_DATE PAPER_DATE,
                                            ISNULL(SHIP.DELIVER_DATE,SHIP.SHIP_DATE) ACTION_DATE,
                                            INVOICE_ROW.AMOUNT AMOUNT,
                                            INVOICE_ROW.SPECT_VAR_ID SPEC_ID,
                                            STOCKS.STOCK_ID,
                                            STOCKS.PRODUCT_ID,
                                            INVOICE.PROCESS_CAT,
                                            INVOICE.DEPARTMENT_ID ACTION_DEPARTMENT_ID,
                                            INVOICE.DEPARTMENT_LOCATION ACTION_LOCATION_ID,
                                            INVOICE_ROW.DUE_DATE,
                                            INVOICE.INVOICE_DATE
                                        FROM
                                            SHIP,
                                            INVOICE,
                                            INVOICE_ROW,
                                            INVOICE_SHIPS,
                                            INVOICE_CONTRACT_COMPARISON,
                                            #dsn1#.STOCKS STOCKS,
                                            #dsn1#.PRODUCT PRODUCT
                                        WHERE
                                            INVOICE_CONTRACT_COMPARISON.DIFF_INVOICE_ID =@paper_action_id AND
                                            INVOICE.INVOICE_ID=INVOICE_CONTRACT_COMPARISON.MAIN_INVOICE_ID AND
                                            INVOICE.INVOICE_ID=INVOICE_ROW.INVOICE_ID AND
                                            INVOICE_SHIPS.SHIP_ID=SHIP.SHIP_ID AND
                                            INVOICE_SHIPS.INVOICE_ID=INVOICE.INVOICE_ID AND
                                            STOCKS.STOCK_ID=INVOICE_ROW.STOCK_ID AND
                                            STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID AND
                                            PRODUCT.IS_COST=1 AND 
                                            PRODUCT.PRODUCT_ID =@paper_product_id
            
                                        ORDER BY
                                            ISNULL(SHIP.DELIVER_DATE,SHIP.SHIP_DATE),
                                            STOCKS.PRODUCT_ID,
                                            INVOICE_ROW.INVOICE_ROW_ID
                                END
                        END
                    ELSE
                        IF  @paper_action_type = 2
                            BEGIN
                                SELECT
                                    SHIP.SHIP_ID,
                                    SHIP_ROW.SHIP_ROW_ID ACTION_ROW_ID,
                                    SHIP.RECORD_DATE INSERT_DATE,
                                    SHIP.SHIP_DATE PAPER_DATE,
                                    SHIP.DELIVER_DATE ACTION_DATE,
                                    SHIP_ROW.AMOUNT AMOUNT,
                                    SHIP_ROW.SPECT_VAR_ID SPEC_ID,
                                    STOCKS.STOCK_ID,
                                    STOCKS.PRODUCT_ID,
                                    SHIP.PROCESS_CAT,
                                    ISNULL(SHIP.DEPARTMENT_IN,SHIP.DELIVER_STORE_ID) ACTION_DEPARTMENT_ID,
                                    ISNULL(SHIP.LOCATION_IN,SHIP.LOCATION) ACTION_LOCATION_ID
                                FROM 
                                    SHIP,
                                    SHIP_ROW,
                                    #dsn1#.STOCKS STOCKS,
                                    #dsn1#.PRODUCT PRODUCT
                                WHERE
                                    SHIP.SHIP_ID = @paper_action_id AND
                                    SHIP.SHIP_ID = SHIP_ROW.SHIP_ID AND
                                    STOCKS.STOCK_ID = SHIP_ROW.STOCK_ID AND
                                    STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
                                    PRODUCT.IS_COST = 1 AND 
                                    PRODUCT.PRODUCT_ID = @paper_product_id
                                ORDER BY
                                    STOCKS.PRODUCT_ID,
                                    SHIP_ROW.SHIP_ROW_ID
                            END
                        ELSE
                            IF @paper_action_type = 3
                                BEGIN
                                    SELECT
                                        STOCK_FIS_ROW.STOCK_FIS_ROW_ID ACTION_ROW_ID,
                                        STOCK_FIS.RECORD_DATE INSERT_DATE,
                                        STOCK_FIS.FIS_DATE PAPER_DATE,
                                        STOCK_FIS.FIS_DATE ACTION_DATE,
                                        STOCK_FIS_ROW.AMOUNT AMOUNT,
                                        STOCK_FIS_ROW.SPECT_VAR_ID SPEC_ID,
                                        STOCKS.STOCK_ID,
                                        STOCKS.PRODUCT_ID,
                                        STOCK_FIS.PROCESS_CAT,
                                        STOCK_FIS.DEPARTMENT_IN ACTION_DEPARTMENT_ID,
                                        STOCK_FIS.LOCATION_IN ACTION_LOCATION_ID,
                                        ISNULL(STOCK_FIS_ROW.DUE_DATE,0) DUE_DATE,
                                        STOCK_FIS_ROW.RESERVE_DATE
                                    FROM 
                                        STOCK_FIS,
                                        STOCK_FIS_ROW,
                                        #dsn1#.STOCKS STOCKS,
                                        #dsn1#.PRODUCT PRODUCT
                                    WHERE
                                        STOCK_FIS.FIS_ID = @paper_action_id AND
                                        STOCK_FIS.FIS_ID = STOCK_FIS_ROW.FIS_ID AND
                                        STOCKS.STOCK_ID = STOCK_FIS_ROW.STOCK_ID AND
                                        STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
                                        PRODUCT.IS_COST=1 
                                        AND PRODUCT.PRODUCT_ID = @paper_product_id
                                    ORDER BY
                                        STOCKS.PRODUCT_ID,STOCK_FIS_ROW.STOCK_FIS_ROW_ID	
                                END
                            ELSE
                                IF @paper_action_type = 4
                                    BEGIN
                                            SELECT
                                                PORR.PR_ORDER_ROW_ID ACTION_ROW_ID,
                                                ISNULL(POR.UPDATE_DATE,POR.RECORD_DATE) INSERT_DATE,
                                                POR.FINISH_DATE PAPER_DATE,
                                                POR.FINISH_DATE ACTION_DATE,
                                                PORR.AMOUNT,
                                                PORR.SPECT_ID SPEC_ID,
                                                PORR.SPEC_MAIN_ID EXCHANGE_SPECT_MAIN_ID,
                                                (PORR.PURCHASE_NET_SYSTEM++ISNULL(PORR.PURCHASE_EXTRA_COST_SYSTEM,0)) PURCHASE_NET_SYSTEM,
                                                PORR.PURCHASE_NET_SYSTEM_MONEY,
                                                (ISNULL(PORR.LABOR_COST_SYSTEM,0)+ISNULL(PORR.STATION_REFLECTION_COST_SYSTEM,0)) AS PURCHASE_EXTRA_COST_SYSTEM,
                                                STOCKS.STOCK_ID,
                                                STOCKS.PRODUCT_ID,
                                                POR.PROCESS_ID PROCESS_CAT,
                                                POR.PRODUCTION_DEP_ID ACTION_DEPARTMENT_ID,
                                                POR.PRODUCTION_LOC_ID ACTION_LOCATION_ID
                                            FROM 
                                                PRODUCTION_ORDERS PO,
                                                PRODUCTION_ORDER_RESULTS POR,
                                                PRODUCTION_ORDER_RESULTS_ROW PORR,
                                                #dsn1#.STOCKS STOCKS,
                                                #dsn1#.PRODUCT PRODUCT
                                            WHERE
                                                POR.PR_ORDER_ID = @paper_action_id AND
                                                PO.P_ORDER_ID = POR.P_ORDER_ID AND
                                                POR.PR_ORDER_ID = PORR.PR_ORDER_ID AND
                                                STOCKS.STOCK_ID = PORR.STOCK_ID AND
                                                STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
                                                PRODUCT.IS_COST = 1 AND
                                                PORR.TYPE = 1 AND
                                                ISNULL(PORR.IS_FREE_AMOUNT,0) <> 1 AND
                                                PO.IS_DEMONTAJ <> 1
                                                AND PRODUCT.PRODUCT_ID = @paper_product_id
                                            ORDER BY
                                                STOCKS.PRODUCT_ID,PORR.PR_ORDER_ROW_ID
                                    END
                                ELSE
                                    IF @paper_action_type = 5 OR @paper_action_type = 7
                                        BEGIN
                                            IF @paper_action_type <> 5 
                                                BEGIN
                                                    SELECT
                                                        STOCK_EXCHANGE.EXCHANGE_NUMBER ACTION_NUMBER,
                                                        STOCK_EXCHANGE.STOCK_EXCHANGE_ID ACTION_ROW_ID,
                                                        STOCK_EXCHANGE.PROCESS_DATE INSERT_DATE,
                                                        STOCK_EXCHANGE.PROCESS_DATE PAPER_DATE,
                                                        STOCK_EXCHANGE.PROCESS_DATE ACTION_DATE,
                                                        STOCK_EXCHANGE.AMOUNT,
                                                        STOCK_EXCHANGE.SPECT_ID SPEC_ID,
                                                        STOCK_EXCHANGE.SPECT_MAIN_ID EXCHANGE_SPECT_MAIN_ID,
                                                        STOCK_EXCHANGE.STOCK_ID,
                                                        STOCK_EXCHANGE.PRODUCT_ID,
                                                        PRODUCT.PRODUCT_ID,
                                                        STOCK_EXCHANGE.PROCESS_CAT PROCESS_CAT,
                                                        STOCK_EXCHANGE.DEPARTMENT_ID ACTION_DEPARTMENT_ID,
                                                        STOCK_EXCHANGE.LOCATION_ID ACTION_LOCATION_ID
                                                    FROM
                                                        STOCK_EXCHANGE,
                                                        #dsn1#.PRODUCT PRODUCT
                                                    WHERE
                                                        PRODUCT.PRODUCT_ID=STOCK_EXCHANGE.PRODUCT_ID AND
                                                            STOCK_EXCHANGE.EXCHANGE_NUMBER = (SELECT EXCHANGE_NUMBER FROM STOCK_EXCHANGE WHERE STOCK_EXCHANGE_ID = @paper_action_id)
                                                            AND PRODUCT.PRODUCT_ID = @paper_product_id
                                                    ORDER BY
                                                        PRODUCT.PRODUCT_ID,STOCK_EXCHANGE.STOCK_EXCHANGE_ID
                                                END
                                            ELSE
                                                BEGIN
                                                    SELECT
                                                        STOCK_EXCHANGE.EXCHANGE_NUMBER ACTION_NUMBER,
                                                        STOCK_EXCHANGE.STOCK_EXCHANGE_ID ACTION_ROW_ID,
                                                        STOCK_EXCHANGE.PROCESS_DATE INSERT_DATE,
                                                        STOCK_EXCHANGE.PROCESS_DATE PAPER_DATE,
                                                        STOCK_EXCHANGE.PROCESS_DATE ACTION_DATE,
                                                        STOCK_EXCHANGE.AMOUNT,
                                                        STOCK_EXCHANGE.SPECT_ID SPEC_ID,
                                                        STOCK_EXCHANGE.SPECT_MAIN_ID EXCHANGE_SPECT_MAIN_ID,
                                                        STOCK_EXCHANGE.STOCK_ID,
                                                        STOCK_EXCHANGE.PRODUCT_ID,
                                                        PRODUCT.PRODUCT_ID,
                                                        STOCK_EXCHANGE.PROCESS_CAT PROCESS_CAT,
                                                        STOCK_EXCHANGE.DEPARTMENT_ID ACTION_DEPARTMENT_ID,
                                                        STOCK_EXCHANGE.LOCATION_ID ACTION_LOCATION_ID
                                                    FROM
                                                        STOCK_EXCHANGE,
                                                        #dsn1#.PRODUCT PRODUCT
                                                    WHERE
                                                        PRODUCT.PRODUCT_ID=STOCK_EXCHANGE.PRODUCT_ID AND
                                                            STOCK_EXCHANGE.STOCK_EXCHANGE_ID =@paper_action_id
                                                        
                                                            AND PRODUCT.PRODUCT_ID = @paper_product_id
                                                    ORDER BY
                                                        PRODUCT.PRODUCT_ID,STOCK_EXCHANGE.STOCK_EXCHANGE_ID
                                                END	
                                        END
            
                                    ELSE
                                        IF @paper_action_type = 6 
                                            BEGIN
                                                    SELECT
                                                        EXPENSE_ITEMS_ROWS.EXP_ITEM_ROWS_ID ACTION_ROW_ID,
                                                        EXPENSE_ITEM_PLANS.RECORD_DATE INSERT_DATE,
                                                        EXPENSE_ITEM_PLANS.EXPENSE_DATE PAPER_DATE,
                                                        EXPENSE_ITEM_PLANS.EXPENSE_DATE ACTION_DATE,
                                                        EXPENSE_ITEMS_ROWS.QUANTITY AMOUNT,
                                                        NULL SPEC_ID,
                                                        NULL EXCHANGE_SPECT_MAIN_ID,
                                                        EXPENSE_ITEMS_ROWS.STOCK_ID,
                                                        EXPENSE_ITEMS_ROWS.PRODUCT_ID,
                                                        EXPENSE_ITEM_PLANS.PROCESS_CAT PROCESS_CAT,
                                                        EXPENSE_ITEM_PLANS.DEPARTMENT_ID ACTION_DEPARTMENT_ID,
                                                        EXPENSE_ITEM_PLANS.LOCATION_ID ACTION_LOCATION_ID
                                                    FROM
                                                        EXPENSE_ITEM_PLANS,
                                                        EXPENSE_ITEMS_ROWS,
                                                        #dsn1#.PRODUCT PRODUCT
                                                    WHERE
                                                        EXPENSE_ITEM_PLANS.EXPENSE_ID = @paper_action_id AND
                                                        EXPENSE_ITEM_PLANS.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID AND
                                                        PRODUCT.PRODUCT_ID = EXPENSE_ITEMS_ROWS.PRODUCT_ID 
                                                        AND PRODUCT.PRODUCT_ID = @paper_product_id
                                                    ORDER BY
                                                        PRODUCT.PRODUCT_ID,EXPENSE_ITEMS_ROWS.EXP_ITEM_ROWS_ID
                                            END
                                        ELSE
                                            IF @paper_action_type = 8
                                            BEGIN
                                                    SELECT		
                                                        PRODUCT_COST_INVOICE.PRODUCT_COST_INVOICE_ID ACTION_ROW_ID,
                                                        PRODUCT_COST_INVOICE.RECORD_DATE INSERT_DATE,
                                                        PRODUCT_COST_INVOICE.COST_DATE PAPER_DATE,
                                                        PRODUCT_COST_INVOICE.COST_DATE ACTION_DATE,
                                                        PRODUCT_COST_INVOICE.AMOUNT,
                                                        NULL SPEC_ID,
                                                        PRODUCT_COST_INVOICE.SPECT_MAIN_ID EXCHANGE_SPECT_MAIN_ID,
                                                        PRODUCT_COST_INVOICE.PRODUCT_ID,
                                                        PRODUCT_COST_INVOICE.STOCK_ID,
                                                        INVOICE.PROCESS_CAT,
                                                        INVOICE.DEPARTMENT_ID ACTION_DEPARTMENT_ID,
                                                        INVOICE.DEPARTMENT_LOCATION ACTION_LOCATION_ID,
                                                        INVOICE.INVOICE_ID,
                                                        PRODUCT.PRODUCT_ID,
                                                        PRODUCT_COST_INVOICE.COST_TYPE_ID,
                                                        PRODUCT_COST_INVOICE.PRICE_PROTECTION_TYPE,
                                                        PRODUCT_COST_INVOICE.PRICE_PROTECTION,
                                                        PRODUCT_COST_INVOICE.PRICE_PROTECTION_MONEY,		
                                                        PRODUCT_COST_INVOICE.TOTAL_PRICE_PROTECTION,
                                                        ISNULL((
                                                            SELECT TOP 1 MONEY FROM #NEW_DSN3#.PRODUCT_COST 
                                                            WHERE
                                                                PRODUCT_ID = PRODUCT_COST_INVOICE.PRODUCT_ID AND
                                                                START_DATE <= PRODUCT_COST_INVOICE.COST_DATE
                                                                AND	ISNULL(SPECT_MAIN_ID,0) = ISNULL(PRODUCT_COST_INVOICE.SPECT_MAIN_ID,0)
                                                            ORDER BY
                                                                START_DATE DESC,
                                                                RECORD_DATE DESC,
                                                                PRODUCT_COST_ID DESC
                                                        ),@cost_money_system_2) MONEY
                                                    FROM
                                                        PRODUCT_COST_INVOICE,
                                                        INVOICE,
                                                        #dsn1#.PRODUCT PRODUCT
                                                    WHERE
                                                        PRODUCT_COST_INVOICE.INVOICE_ID = @paper_action_id AND
                                                        PRODUCT_COST_INVOICE.INVOICE_ID = INVOICE.INVOICE_ID AND
                                                        PRODUCT.PRODUCT_ID = PRODUCT_COST_INVOICE.PRODUCT_ID
                                                        AND PRODUCT.PRODUCT_ID = @paper_product_id
                                                    ORDER BY
                                                        PRODUCT_COST_INVOICE.COST_DATE,
                                                        PRODUCT.PRODUCT_ID,PRODUCT_COST_INVOICE.PRODUCT_COST_INVOICE_ID
                                            END
            END
</cfquery>

<cfquery name="ADD_SP" datasource="#new_dsn2#">
CREATE PROCEDURE [get_mizan]
AS BEGIN
   	
   SELECT AC.CARD_TYPE_NO
      ,AC.BILL_NO
      ,'Yevmiye No:' + cast (BILL_NO AS NVARCHAR(50)) +'_____'+ cast(AC.ACTION_DATE  AS NVARCHAR(50)) AS Yevmiye
      ,AP.ACCOUNT_NAME
      ,'Mahsup Fiş No:'+ CAST (AC.CARD_TYPE_NO AS NVARCHAR(50)) AS Mahsup
      ,AC.ACTION_DATE
      ,ACR.ACCOUNT_ID
      ,B.BRANCH_NAME
      ,D.DEPARTMENT_HEAD
      ,PP.PROJECT_HEAD
      ,ACR.DETAIL
      ,CASE WHEN ACR.BA = 0 THEN AMOUNT END AS BORC
      ,CASE WHEN ACR.BA = 1 THEN AMOUNT END AS ALACAK
FROM   ACCOUNT_CARD AC
       JOIN ACCOUNT_CARD_ROWS ACR
            ON  ACR.CARD_ID = AC.CARD_ID
        LEFT JOIN #new_dsn#.BRANCH AS b
			ON	B.BRANCH_ID = ACR.ACC_BRANCH_ID
		LEFT JOIN #new_dsn#.DEPARTMENT AS d
			ON d.DEPARTMENT_ID = acr.ACC_DEPARTMENT_ID
		LEFT JOIN #new_dsn#.PRO_PROJECTS AS pp
			ON PP.PROJECT_ID = ACR.ACC_PROJECT_ID
		LEFT JOIN ACCOUNT_PLAN AS ap ON AP.ACCOUNT_CODE = ACR.ACCOUNT_ID

	END
</cfquery>

<cfquery name="ADD_SP" datasource="#new_dsn2#">
CREATE PROCEDURE [GET_NETBOOK]
                @action_date datetime,			
                @process_date datetime,			
                @db_alias nvarchar(50)
            AS
            BEGIN
                            
                SET NOCOUNT ON;
                DECLARE @SQL_TEXT NVARCHAR(500);
                            
                IF LEN(@db_alias) > 0
                    BEGIN
                        IF @action_date IS NOT NULL
                            BEGIN
                                SET @SQL_TEXT = 'SELECT TOP 1 NETBOOK_ID FROM '+ @db_alias +'NETBOOKS WHERE STATUS = 1 AND (' + ''''+CONVERT(nvarchar(50),@action_date)+'''' + ' BETWEEN START_DATE AND FINISH_DATE OR ' + ''''+CONVERT(nvarchar(50),@process_date)+'''' + ' BETWEEN START_DATE AND FINISH_DATE)';
                            END
                        ELSE
                            BEGIN
                                SET @SQL_TEXT = 'SELECT TOP 1 NETBOOK_ID FROM '+ @db_alias +'NETBOOKS WHERE STATUS = 1 AND ' + ''''+CONVERT(nvarchar(50),@process_date)+'''' + ' BETWEEN START_DATE AND FINISH_DATE';
                            END
                    END
                            
                ELSE
                    BEGIN
                        IF @action_date IS NOT NULL
                            BEGIN
                                SET @SQL_TEXT = 'SELECT TOP 1 NETBOOK_ID FROM NETBOOKS WHERE STATUS = 1 AND (' + ''''+CONVERT(nvarchar(50),@action_date)+'''' + ' BETWEEN START_DATE AND FINISH_DATE OR ' + ''''+CONVERT(nvarchar(50),@process_date)+'''' + ' BETWEEN START_DATE AND FINISH_DATE)';
                            END
                        ELSE
                            BEGIN
                                SET @SQL_TEXT = 'SELECT TOP 1 NETBOOK_ID FROM NETBOOKS WHERE STATUS = 1 AND ' + ''''+CONVERT(nvarchar(50),@process_date)+'''' + ' BETWEEN START_DATE AND FINISH_DATE';
                            END
                    END
                            
                exec (@SQL_TEXT); 
            END
</cfquery>

<cfquery name="ADD_SP" datasource="#new_dsn2#">
CREATE PROCEDURE [GET_SHIP_TYPE]
            @action_id int
        AS
        BEGIN
        SET NOCOUNT ON;
                SELECT SHIP_TYPE FROM SHIP WHERE SHIP_ID = @action_id
        END
</cfquery>

<!---<cfquery name="ADD_SP" datasource="#new_dsn2#">
<!---CREATE PROCEDURE [GET_STOCK_ANALYSE_STOCK]
	@START_DATE DATETIME,
	@FINISH_DATE DATETIME
AS
	SELECT DISTINCT
	       S.STOCK_CODE,
	       S.STOCK_ID                     AS PRODUCT_GROUPBY_ID,
	       (S.PRODUCT_NAME + ' ' + ISNULL(S.PROPERTY, '')) ACIKLAMA,
	       S.MANUFACT_CODE,
	       S.PRODUCT_UNIT_ID,
	       PU.MAIN_UNIT,
	       (
	           SELECT PUNIT.ADD_UNIT
	           FROM   #NEW_DSN3#.PRODUCT_UNIT PUNIT
	           WHERE  PUNIT.IS_ADD_UNIT = 1
	                  AND PUNIT.PRODUCT_ID = S.PRODUCT_ID
	       )                                 UNIT2,
	       (
	           SELECT PT.MULTIPLIER
	           FROM   #NEW_DSN3#.PRODUCT_UNIT PT
	           WHERE  PT.IS_ADD_UNIT = 1
	                  AND PT.PRODUCT_ID = S.PRODUCT_ID
	       )                                 MULTIPLIER,
	       PU.DIMENTION,
	       S.BARCOD,
	       S.PRODUCT_CODE,
	       S.STOCK_CODE_2,
	       S.PRODUCT_STATUS,
	       S.PRODUCT_ID,
	       S.IS_PRODUCTION,
	       P.ALL_START_COST,
	       ISNULL(P.ALL_START_COST_2, 0)     ALL_START_COST_2,
	       ISNULL(P1.ALL_FINISH_COST, 0)  AS ALL_FINISH_COST,
	       P1.ALL_FINISH_COST_2
	       INTO                              #GET_ALL_STOCK
	FROM   #NEW_DSN3#.STOCKS S WITH (NOLOCK) 
	                                       OUTER APPLY
	                                       (
	                                           SELECT TOP 1(PURCHASE_NET_SYSTEM_ALL + PURCHASE_EXTRA_COST_SYSTEM) AS 
	                                                  ALL_START_COST,
	                                                  ISNULL((PURCHASE_NET_ALL + PURCHASE_EXTRA_COST), 0) AS 
	                                                  ALL_START_COST_2
	                                           FROM   #NEW_DSN3#.PRODUCT_COST WITH (NOLOCK)
	                                           WHERE  START_DATE <= @START_DATE
	                                                  AND PRODUCT_ID = S.PRODUCT_ID
	                                                  AND PRODUCT_COST.STOCK_ID = 
	                                                      S.STOCK_ID
	                                           ORDER BY
	                                                  START_DATE DESC,
	                                                  RECORD_DATE DESC,
	                                                  PRODUCT_COST_ID DESC
	                                       ) AS P
	       OUTER APPLY 
	(
	    SELECT TOP 1(PURCHASE_NET_SYSTEM_ALL + PURCHASE_EXTRA_COST_SYSTEM) AS 
	           ALL_FINISH_COST,
	           (PURCHASE_NET_SYSTEM_2_ALL + PURCHASE_EXTRA_COST_SYSTEM_2) AS 
	           ALL_FINISH_COST_2
	    FROM   #NEW_DSN3#.PRODUCT_COST WITH (NOLOCK)
	    WHERE  START_DATE <= @FINISH_DATE
	           AND PRODUCT_ID = S.PRODUCT_ID
	           AND PRODUCT_COST.STOCK_ID = S.STOCK_ID
	    ORDER BY
	           START_DATE          DESC,
	           RECORD_DATE         DESC,
	           PRODUCT_COST_ID     DESC
	)                                     AS P1,
	       #NEW_DSN3#.PRODUCT_UNIT PU WITH (NOLOCK)
	WHERE  S.PRODUCT_ID = PU.PRODUCT_ID
	       AND S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID
	ORDER BY
	       STOCK_CODE
	
	
	SELECT SR.UPD_ID,
	       S.STOCK_ID,
	       S.PRODUCT_ID,
	       SR.SPECT_VAR_ID     SPECT_VAR_ID,
	       S.PRODUCT_MANAGER,
	       S.PRODUCT_CATID,
	       S.BRAND_ID,
	       SUM(SR.STOCK_IN -SR.STOCK_OUT) AMOUNT,
	       SR.PROCESS_DATE     ISLEM_TARIHI,
	       SR.PROCESS_TYPE
	       INTO                #GET_STOCK_ROWS
	FROM   WORKCUBE_CF_2014_1.STOCKS_ROW SR WITH (NOLOCK),
	                                                 #NEW_DSN3#.STOCKS S WITH (NOLOCK),
	                                                                                 #new_dsn#.STOCKS_LOCATION 
	                                                                                 SL WITH (NOLOCK)
	WHERE  SR.STOCK_ID = S.STOCK_ID
	       AND SR.STORE = SL.DEPARTMENT_ID
	       AND SR.STORE_LOCATION = SL.LOCATION_ID
	       AND SL.BELONGTO_INSTITUTION = 0
	       AND SR.PROCESS_DATE <= @START_DATE
	GROUP BY
	       SR.UPD_ID,
	       S.STOCK_ID,
	       S.PRODUCT_ID,
	       SR.SPECT_VAR_ID,
	       S.PRODUCT_MANAGER,
	       S.PRODUCT_CATID,
	       S.BRAND_ID,
	       SR.PROCESS_DATE,
	       SR.PROCESS_TYPE
	
	--DONEM BASI
	IF (MONTH(@START_DATE) = 1 AND DAY(@START_DATE) = 1)
	BEGIN
	    SELECT SUM(AMOUNT)            AS DB_STOK_MIKTAR,
	           SUM(AMOUNT * MALIYET)  AS DB_STOK_MALIYET,
	           STOCK_ID               AS GROUPBY_ALANI
	    INTO #ACILIS_STOCK
	    FROM   #GET_STOCK_ROWS
	    WHERE  ISLEM_TARIHI = @START_DATE
	           AND PROCESS_TYPE = 114
	    GROUP BY
	           STOCK_ID
	END
	ELSE
	BEGIN
	    SELECT SUM(AMOUNT)            AS DB_STOK_MIKTAR,
	           SUM(AMOUNT * MALIYET)  AS DB_STOK_MALIYET,
	           STOCK_ID               AS GROUPBY_ALANI
	    INTO #ACILIS_STOCK1
	    FROM   #GET_STOCK_ROWS
	    WHERE  (
	               (
	                   ISLEM_TARIHI <= @START_DATE
	                   AND PROCESS_TYPE NOT IN (81, 811)
	               )
	               OR (ISLEM_TARIHI = @START_DATE AND PROCESS_TYPE = 114)
	           )
	    GROUP BY
	           STOCK_ID
	END 
	

	--DONEM SONU   
	
		SELECT 
			SUM(AMOUNT) AS TOTAL_STOCK,
			SUM(AMOUNT*MALIYET) AS TOTAL_PRODUCT_COST,
			STOCK_ID AS GROUPBY_ALANI
		INTO #GET_TOTAL_STOCK
		FROM
			#GET_STOCK_ROWS
		WHERE
			ISLEM_TARIHI <= @FINISH_DATE 
			AND PROCESS_TYPE NOT IN (81,811)
		GROUP BY
			STOCK_ID 

	--DONEM SONU   	
	
	
	
	IF (MONTH(@START_DATE) = 1 AND DAY(@START_DATE) = 1)
	BEGIN
	SELECT 
		GAS.STOCK_CODE,
		GAS.STOCK_CODE_2,
		GAS.ACIKLAMA,
		GAS.BARCOD,
		GAS.PRODUCT_CODE,
		GAS.MANUFACT_CODE,
		GAS.MAIN_UNIT,
		AS1.DB_STOK_MIKTAR,
		GTS.TOTAL_STOCK
	FROM 
	    #GET_ALL_STOCK GAS  LEFT JOIN  #ACILIS_STOCK AS1  ON AS1.GROUPBY_ALANI = GAS.PRODUCT_GROUPBY_ID LEFT JOIN #GET_TOTAL_STOCK GTS ON GTS.GROUPBY_ALANI = GAS.PRODUCT_GROUPBY_ID
	    
	END	
	ELSE
		BEGIN
			SELECT 
				GAS.STOCK_CODE,
				GAS.STOCK_CODE_2,
				GAS.ACIKLAMA,
				GAS.BARCOD,
				GAS.PRODUCT_CODE,
				GAS.MANUFACT_CODE,
				GAS.MAIN_UNIT,
				AS1.DB_STOK_MIKTAR,
				GTS.TOTAL_STOCK
			FROM 
				#GET_ALL_STOCK GAS  LEFT JOIN  #ACILIS_STOCK1 AS1  ON AS1.GROUPBY_ALANI = GAS.PRODUCT_GROUPBY_ID LEFT JOIN #GET_TOTAL_STOCK GTS ON GTS.GROUPBY_ALANI = GAS.PRODUCT_GROUPBY_ID
	    
		END--->
</cfquery>--->

<cfquery name="ADD_SP" datasource="#new_dsn2#">
CREATE PROCEDURE [get_stock_last_function]
                (
                    @stock_id_list nvarchar (max)
                )
            AS
            BEGIN 
        
                SELECT 
                    ROUND(SUM(REAL_STOCK),4) REAL_STOCK,
                    ROUND(SUM(PRODUCT_STOCK),4) PRODUCT_STOCK,
                    ROUND(SUM(PRODUCT_STOCK+RESERVED_STOCK),4) SALEABLE_STOCK,
                    ROUND(SUM(PURCHASE_ORDER_STOCK),4) PURCHASE_ORDER_STOCK,
                    PRODUCT_ID, 
                    STOCK_ID
                FROM
                (
                    SELECT
                        (SR.STOCK_IN - SR.STOCK_OUT) AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,
                        0 AS RESERVED_STOCK,
                        0 AS PURCHASE_ORDER_STOCK,
                        SR.STOCK_ID,
                        SR.PRODUCT_ID
                    FROM
                        STOCKS_ROW SR
                    JOIN
                        fnSplit(@stock_id_list,',') AS TB1
                    ON 
                        TB1.item = SR.STOCK_ID
                UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        (SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,
                        0 AS RESERVED_STOCK,
                        0 AS PURCHASE_ORDER_STOCK,
                        SR.STOCK_ID,
                        SR.PRODUCT_ID
                    FROM
                        #new_dsn#.STOCKS_LOCATION SL,
                        STOCKS_ROW SR
                    JOIN
                        fnSplit(@stock_id_list,',') AS TB1
                    ON 
                        TB1.item = SR.STOCK_ID
                    WHERE
                        SR.STORE =SL.DEPARTMENT_ID
                        AND SR.STORE_LOCATION=SL.LOCATION_ID
                        AND SL.NO_SALE = 0
                UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,
                        ((RESERVE_STOCK_OUT-STOCK_OUT)*-1) AS RESERVED_STOCK,
                        RESERVE_STOCK_IN AS PURCHASE_ORDER_STOCK,
                        ORR.STOCK_ID,
                        ORR.PRODUCT_ID
                    FROM
                        #NEW_DSN3#.GET_ORDER_ROW_RESERVED ORR
                    JOIN
                        fnSplit(@stock_id_list,',') AS TB1
                    ON 
                        TB1.item = ORR.STOCK_ID
                        , 
                        #NEW_DSN3#.ORDERS ORDS
                    WHERE
                        ORDS.RESERVED = 1 AND 
                        ORDS.ORDER_STATUS = 1 AND	
                        ORR.ORDER_ID=ORDS.ORDER_ID AND 
                        ((RESERVE_STOCK_IN-STOCK_IN)>0 OR (RESERVE_STOCK_OUT-STOCK_OUT)>0)
                UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,
                        (RESERVE_STOCK_IN-STOCK_IN) AS RESERVED_STOCK,
                        0 AS PURCHASE_ORDER_STOCK,
                        ORR.STOCK_ID,
                        ORR.PRODUCT_ID
                    FROM
                        #NEW_DSN3#.GET_ORDER_ROW_RESERVED ORR
                    JOIN
                        fnSplit(@stock_id_list,',') AS TB1
                    ON 
                        TB1.item = ORR.STOCK_ID
                        , 
                        #NEW_DSN3#.ORDERS ORDS,
                        #new_dsn#.STOCKS_LOCATION SL
                    WHERE
                        ORDS.RESERVED = 1 AND 
                        ORDS.ORDER_STATUS = 1 AND	
                        ORDS.DELIVER_DEPT_ID =SL.DEPARTMENT_ID AND 
                        ORDS.LOCATION_ID=SL.LOCATION_ID AND 
                        SL.NO_SALE = 0	 AND 
                        ORR.ORDER_ID=ORDS.ORDER_ID AND 
                        (RESERVE_STOCK_IN-STOCK_IN)>0
                UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,
                        ((RESERVE_STOCK_IN-STOCK_IN) + ((RESERVE_STOCK_OUT-STOCK_OUT)*-1)) AS RESERVED_STOCK,
                        0 AS PURCHASE_ORDER_STOCK,
                        ORR.STOCK_ID,
                        ORR.PRODUCT_ID
                    FROM
                        #NEW_DSN3#.ORDER_ROW_RESERVED  ORR
                    JOIN
                        fnSplit(@stock_id_list,',') AS TB1
                    ON 
                        TB1.item = ORR.STOCK_ID
                    WHERE
                        ORDER_ID IS NULL
                        AND SHIP_ID IS NULL
                        AND INVOICE_ID IS NULL
                UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,
                        (STOCK_ARTIR-STOCK_AZALT) AS RESERVED_STOCK,
                        0  AS PURCHASE_ORDER_STOCK,
                        STOCK_ID,
                        PRODUCT_ID
                    FROM
                        #NEW_DSN3#.GET_PRODUCTION_RESERVED
                    JOIN
                        fnSplit(@stock_id_list,',') AS TB1
                    ON 
                        TB1.item = GET_PRODUCTION_RESERVED.STOCK_ID
                ) T1
                GROUP BY
                    PRODUCT_ID, 
                    STOCK_ID
            END;
</cfquery>

<cfquery name="ADD_SP" datasource="#new_dsn2#">
CREATE PROCEDURE [get_stock_last_function_with_product]
                (
                    @product_id_list nvarchar (max)
                )
            AS
            BEGIN 
                SELECT 
                    ROUND(SUM(REAL_STOCK),4) REAL_STOCK,
                    ROUND(SUM(PRODUCT_STOCK),4) PRODUCT_STOCK,
                    ROUND(SUM(PRODUCT_STOCK+RESERVED_STOCK),4) SALEABLE_STOCK,
                    ROUND(SUM(PURCHASE_ORDER_STOCK),4) PURCHASE_ORDER_STOCK,
                    PRODUCT_ID, 
                    STOCK_ID
                FROM
                (
                    SELECT
                        (STOCK_IN - STOCK_OUT) AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,
                        0 AS RESERVED_STOCK,
                        0 AS PURCHASE_ORDER_STOCK,
                        STOCK_ID,
                        PRODUCT_ID
                    FROM
                        STOCKS_ROW
                    JOIN
                        fnSplit(@product_id_list,',') AS TB1
                    ON 
                        STOCKS_ROW.PRODUCT_ID =TB1.item
                UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        (SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,
                        0 AS RESERVED_STOCK,
                        0 AS PURCHASE_ORDER_STOCK,
                        SR.STOCK_ID,
                        SR.PRODUCT_ID
                    FROM
                        #new_dsn#.STOCKS_LOCATION SL,
                        STOCKS_ROW SR
                    JOIN
                        fnSplit(@product_id_list,',') AS TB1
                    ON 
                        SR.PRODUCT_ID =TB1.item
                    WHERE
                        SR.STORE =SL.DEPARTMENT_ID AND 
                        SR.STORE_LOCATION=SL.LOCATION_ID AND 
                        SL.NO_SALE = 0 
                        
                    UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,

                        ((ORR.RESERVE_STOCK_OUT - ORR.STOCK_OUT)*-1) AS RESERVED_STOCK,
                        ORR.RESERVE_STOCK_IN AS PURCHASE_ORDER_STOCK,
                        ORR.STOCK_ID,
                        ORR.PRODUCT_ID
                    FROM
                        #NEW_DSN3#.GET_ORDER_ROW_RESERVED ORR
                    JOIN
                        fnSplit(@product_id_list,',') AS TB1
                    ON 
                        ORR.PRODUCT_ID =TB1.item
                        , 
                        #NEW_DSN3#.ORDERS ORDS
                    WHERE
                        ORDS.RESERVED = 1 AND 
                        ORDS.ORDER_STATUS = 1 AND	
                        ORR.ORDER_ID = ORDS.ORDER_ID AND 
                        ((ORR.RESERVE_STOCK_IN - ORR.STOCK_IN)>0 OR (ORR.RESERVE_STOCK_OUT - ORR.STOCK_OUT)>0) 
                    UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,
                        (ORR.RESERVE_STOCK_IN - ORR.STOCK_IN) AS RESERVED_STOCK,
                        0 AS PURCHASE_ORDER_STOCK,
                        ORR.STOCK_ID,
                        ORR.PRODUCT_ID
                    FROM
                        #NEW_DSN3#.GET_ORDER_ROW_RESERVED ORR
                    JOIN
                        fnSplit(@product_id_list,',') AS TB1
                    ON 
                        ORR.PRODUCT_ID =TB1.item
                        , 
                        #NEW_DSN3#.ORDERS ORDS,
                        #new_dsn#.STOCKS_LOCATION SL
                    WHERE
                        ORDS.RESERVED = 1 AND 
                        ORDS.ORDER_STATUS = 1 AND	
                        ORDS.DELIVER_DEPT_ID =SL.DEPARTMENT_ID AND 
                        ORDS.LOCATION_ID = SL.LOCATION_ID AND 
                        SL.NO_SALE = 0	 AND 
                        ORR.ORDER_ID = ORDS.ORDER_ID AND 
                        (RESERVE_STOCK_IN-STOCK_IN)>0 
                    UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,
                        ((RESERVE_STOCK_IN-STOCK_IN) + ((RESERVE_STOCK_OUT-STOCK_OUT)*-1)) AS RESERVED_STOCK,
                        0 AS PURCHASE_ORDER_STOCK,
                        STOCK_ID,
                        PRODUCT_ID
                    FROM
                        #NEW_DSN3#.ORDER_ROW_RESERVED
                    JOIN
                        fnSplit(@product_id_list,',') AS TB1
                    ON 
                        ORDER_ROW_RESERVED.PRODUCT_ID =TB1.item
                    WHERE
                        ORDER_ID IS NULL AND 
                        SHIP_ID IS NULL AND 
                        INVOICE_ID IS NULL
                    UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,
                        (STOCK_ARTIR-STOCK_AZALT) AS RESERVED_STOCK,
                        0 AS PURCHASE_ORDER_STOCK,
                        STOCK_ID,
                        PRODUCT_ID
                    FROM
                        #NEW_DSN3#.GET_PRODUCTION_RESERVED
                    JOIN
                        fnSplit(@product_id_list,',') AS TB1
                    ON 
                        GET_PRODUCTION_RESERVED.PRODUCT_ID =TB1.item 
                    UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,
                        -1*(STOCK_IN - SR.STOCK_OUT) AS RESERVED_STOCK,
                        0  AS PURCHASE_ORDER_STOCK,
                        SR.STOCK_ID,
                        SR.PRODUCT_ID
                    FROM
                        STOCKS_ROW SR
                    JOIN
                        fnSplit(@product_id_list,',') AS TB1
                    ON 
                        SR.PRODUCT_ID =TB1.item 
                        ,
                        #new_dsn#.STOCKS_LOCATION SL 
                    WHERE	
                        SR.STORE = SL.DEPARTMENT_ID AND
                        SR.STORE_LOCATION = SL.LOCATION_ID AND
                        ISNULL(SL.IS_SCRAP,0)=1
                ) T1
                GROUP BY
                    PRODUCT_ID, 
                    STOCK_ID
            END;
</cfquery>

<cfquery name="ADD_SP" datasource="#new_dsn2#">
CREATE PROCEDURE [get_stock_last_location_function]
                (
                    @stock_id_list nvarchar (max)
                )
            AS
            BEGIN 
            SELECT 
                SUM(REAL_STOCK) REAL_STOCK,
                SUM(PRODUCT_STOCK) PRODUCT_STOCK,
                SUM(RESERVED_STOCK) RESERVED_STOCK,
                SUM(PURCHASE_PROD_STOCK) PURCHASE_PROD_STOCK,
                SUM(RESERVED_PROD_STOCK) RESERVED_PROD_STOCK,
                SUM(PRODUCT_STOCK+RESERVED_STOCK) SALEABLE_STOCK,
                SUM(RESERVE_SALE_ORDER_STOCK) RESERVE_SALE_ORDER_STOCK,
                SUM(NOSALE_STOCK) NOSALE_STOCK,
                SUM(BELONGTO_INSTITUTION_STOCK) BELONGTO_INSTITUTION_STOCK,
                SUM(RESERVE_PURCHASE_ORDER_STOCK) PURCHASE_ORDER_STOCK,
                SUM(PRODUCTION_ORDER_STOCK) PRODUCTION_ORDER_STOCK,
                SUM(NOSALE_RESERVED_STOCK) AS NOSALE_RESERVED_STOCK,
                PRODUCT_ID, 
                STOCK_ID,
                DEPARTMENT_ID,
                LOCATION_ID
            FROM
            (
                SELECT
                    (SR.STOCK_IN - SR.STOCK_OUT) AS REAL_STOCK,
                    0 AS PRODUCT_STOCK,
                    0 AS RESERVED_STOCK,
                    0 AS PURCHASE_PROD_STOCK,
                    0 AS RESERVED_PROD_STOCK,
                    0 AS RESERVE_SALE_ORDER_STOCK,
                    0 AS NOSALE_STOCK, 
                    0 AS BELONGTO_INSTITUTION_STOCK,
                    0 AS RESERVE_PURCHASE_ORDER_STOCK,
                    0 AS PRODUCTION_ORDER_STOCK,
                    0 AS NOSALE_RESERVED_STOCK,
                    SR.STOCK_ID,
                    SR.PRODUCT_ID,
                    SR.STORE AS DEPARTMENT_ID,
                    SR.STORE_LOCATION AS LOCATION_ID
                FROM
                    STOCKS_ROW SR WITH (NOLOCK)
                JOIN
                    fnSplit(@stock_id_list,',') AS TB1
                ON 
                    TB1.item = SR.STOCK_ID
                UNION ALL
                SELECT
                    (SR.STOCK_IN - SR.STOCK_OUT) AS REAL_STOCK,
                    0 AS PRODUCT_STOCK,
                    0 AS RESERVED_STOCK,
                    0 AS PURCHASE_PROD_STOCK,
                    0 AS RESERVED_PROD_STOCK,
                    0 AS RESERVE_SALE_ORDER_STOCK,
                    0 AS NOSALE_STOCK, 
                    0 AS BELONGTO_INSTITUTION_STOCK,
                    0 AS RESERVE_PURCHASE_ORDER_STOCK,
                    0 AS PRODUCTION_ORDER_STOCK,
                    0 AS NOSALE_RESERVED_STOCK,
                    SR.STOCK_ID,
                    SR.PRODUCT_ID,
                    -1 AS DEPARTMENT_ID,
                    -1 AS LOCATION_ID
                FROM
                    STOCKS_ROW SR WITH (NOLOCK)
                JOIN
                    fnSplit(@stock_id_list,',') AS TB1
                ON 
                    TB1.item = SR.STOCK_ID
                WHERE
                    UPD_ID IS NULL 
                UNION ALL
                SELECT
                    0 AS REAL_STOCK,
                    (SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,
                    0 AS RESERVED_STOCK,
                    0 AS PURCHASE_PROD_STOCK,
                    0 AS RESERVED_PROD_STOCK,
                    0 AS RESERVE_SALE_ORDER_STOCK,
                    0 AS NOSALE_STOCK, 
                    0 AS BELONGTO_INSTITUTION_STOCK,
                    0 AS RESERVE_PURCHASE_ORDER_STOCK,
                    0 AS PRODUCTION_ORDER_STOCK,
                    0 AS NOSALE_RESERVED_STOCK,
                    SR.STOCK_ID,
                    SR.PRODUCT_ID,
                    SR.STORE AS DEPARTMENT_ID,
                    SR.STORE_LOCATION AS LOCATION_ID
                FROM
                    #new_dsn#.STOCKS_LOCATION SL WITH (NOLOCK),
                    STOCKS_ROW SR WITH (NOLOCK)
                JOIN
                    fnSplit(@stock_id_list,',') AS TB1
                ON 
                    TB1.item = SR.STOCK_ID
                WHERE
                    SR.STORE =SL.DEPARTMENT_ID AND 
                    SR.STORE_LOCATION=SL.LOCATION_ID AND 
                    SL.NO_SALE = 0 
                UNION ALL
                SELECT
                    0 AS REAL_STOCK,
                    -1*(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,
                    0 AS RESERVED_STOCK,
                    0 AS PURCHASE_PROD_STOCK,
                    0 AS RESERVED_PROD_STOCK,
                    0 AS RESERVE_SALE_ORDER_STOCK,
                    0 AS NOSALE_STOCK, 
                    0 AS BELONGTO_INSTITUTION_STOCK,
                    0 AS RESERVE_PURCHASE_ORDER_STOCK,
                    0 AS PRODUCTION_ORDER_STOCK,
                    0 AS NOSALE_RESERVED_STOCK,
                    SR.STOCK_ID,
                    SR.PRODUCT_ID,
                    SR.STORE AS DEPARTMENT_ID,
                    SR.STORE_LOCATION AS LOCATION_ID
                FROM
                    STOCKS_ROW SR WITH (NOLOCK)
                JOIN
                    fnSplit(@stock_id_list,',') AS TB1
                ON 
                    TB1.item = SR.STOCK_ID	
                    ,
                    #new_dsn#.STOCKS_LOCATION SL WITH (NOLOCK) 
                WHERE	
                    SR.STORE = SL.DEPARTMENT_ID AND
                    SR.STORE_LOCATION = SL.LOCATION_ID AND
                    ISNULL(SL.IS_SCRAP,0)=1 
                UNION ALL
                SELECT
                    0 AS REAL_STOCK,
                    0 AS PRODUCT_STOCK,
                    0 AS RESERVED_STOCK,
                    0 AS PURCHASE_PROD_STOCK,
                    0 AS RESERVED_PROD_STOCK,
                    0 AS RESERVE_SALE_ORDER_STOCK,
                    (SR.STOCK_IN - SR.STOCK_OUT) AS NOSALE_STOCK,
                    0 AS BELONGTO_INSTITUTION_STOCK,
                    0 AS RESERVE_PURCHASE_ORDER_STOCK,
                    0 AS PRODUCTION_ORDER_STOCK,
                    0 AS NOSALE_RESERVED_STOCK,
                    SR.STOCK_ID,
                    SR.PRODUCT_ID,
                    SR.STORE AS DEPARTMENT_ID,
                    SR.STORE_LOCATION AS LOCATION_ID
                FROM
                    #new_dsn#.STOCKS_LOCATION SL WITH (NOLOCK),
                    STOCKS_ROW SR WITH (NOLOCK)
                JOIN
                    fnSplit(@stock_id_list,',') AS TB1
                ON 
                    TB1.item = SR.STOCK_ID	
                WHERE
                    SR.STORE =SL.DEPARTMENT_ID AND 
                    SR.STORE_LOCATION=SL.LOCATION_ID AND 
                    SL.NO_SALE =1
                UNION ALL
                SELECT
                    0 AS REAL_STOCK,
                    0 AS PRODUCT_STOCK,
                    0 AS RESERVED_STOCK,
                    0 AS PURCHASE_PROD_STOCK,
                    0 AS RESERVED_PROD_STOCK,
                    0 AS RESERVE_SALE_ORDER_STOCK,
                    0 AS NOSALE_STOCK, 
                    (SR.STOCK_IN - SR.STOCK_OUT) AS BELONGTO_INSTITUTION_STOCK,
                    0 AS RESERVE_PURCHASE_ORDER_STOCK,
                    0 AS PRODUCTION_ORDER_STOCK,
                    0 AS NOSALE_RESERVED_STOCK,
                    SR.STOCK_ID,
                    SR.PRODUCT_ID,
                    SR.STORE AS DEPARTMENT_ID,
                    SR.STORE_LOCATION AS LOCATION_ID
                FROM
                    #new_dsn#.STOCKS_LOCATION SL WITH (NOLOCK),
                    STOCKS_ROW SR WITH (NOLOCK)
                JOIN
                    fnSplit(@stock_id_list,',') AS TB1
                ON 
                    TB1.item = SR.STOCK_ID
                WHERE
                    SR.STORE =SL.DEPARTMENT_ID AND 
                    SR.STORE_LOCATION=SL.LOCATION_ID AND 
                    SL.BELONGTO_INSTITUTION =1
                UNION ALL
                SELECT
                    0 AS REAL_STOCK,
                    0 AS PRODUCT_STOCK,
                    ((RESERVE_STOCK_OUT-STOCK_OUT)*-1) AS RESERVED_STOCK,
                    0 AS PURCHASE_PROD_STOCK,
                    0 AS RESERVED_PROD_STOCK,
                    (RESERVE_STOCK_OUT-STOCK_OUT) AS RESERVE_SALE_ORDER_STOCK,
                    0 AS NOSALE_STOCK,
                    0 AS BELONGTO_INSTITUTION_STOCK,
                    (RESERVE_STOCK_IN-STOCK_IN) AS RESERVE_PURCHASE_ORDER_STOCK,
                    0 AS PRODUCTION_ORDER_STOCK,
                    0 AS NOSALE_RESERVED_STOCK,
                    ORR.STOCK_ID,
                    ORR.PRODUCT_ID,
                    ORDS.DELIVER_DEPT_ID AS DEPARTMENT_ID,
                    ORDS.LOCATION_ID AS LOCATION_ID
                FROM
                    #NEW_DSN3#.GET_ORDER_ROW_RESERVED ORR WITH (NOLOCK)
                JOIN
                    fnSplit(@stock_id_list,',') AS TB1
                ON 
                    TB1.item = ORR.STOCK_ID
                    , 
                    #NEW_DSN3#.ORDERS ORDS WITH (NOLOCK)
                WHERE
                    ORDS.RESERVED = 1 AND 
                    ORDS.ORDER_STATUS = 1 AND	
                    ORDS.DELIVER_DEPT_ID IS NOT NULL AND
                    ORDS.LOCATION_ID IS NOT NULL AND
                    ORR.ORDER_ID = ORDS.ORDER_ID AND 
                    ((RESERVE_STOCK_IN-STOCK_IN)>0 OR (RESERVE_STOCK_OUT-STOCK_OUT)>0) 
                UNION ALL
                SELECT
                    0 AS REAL_STOCK,
                    0 AS PRODUCT_STOCK,
                    (RESERVE_STOCK_IN-STOCK_IN) AS RESERVED_STOCK,
                    0 AS PURCHASE_PROD_STOCK,
                    0 AS RESERVED_PROD_STOCK,
                    0 AS RESERVE_SALE_ORDER_STOCK,
                    0 AS NOSALE_STOCK,
                    0 AS BELONGTO_INSTITUTION_STOCK,
                    0 AS RESERVE_PURCHASE_ORDER_STOCK,
                    0 AS PRODUCTION_ORDER_STOCK,
                    0 AS NOSALE_RESERVED_STOCK,
                    ORR.STOCK_ID,
                    ORR.PRODUCT_ID,
                    ORDS.DELIVER_DEPT_ID AS DEPARTMENT_ID,
                    ORDS.LOCATION_ID AS LOCATION_ID
                FROM
                    #NEW_DSN3#.GET_ORDER_ROW_RESERVED ORR WITH (NOLOCK)
                JOIN
                    fnSplit(@stock_id_list,',') AS TB1
                ON 
                    TB1.item = ORR.STOCK_ID	
                    , 
                    #NEW_DSN3#.ORDERS ORDS WITH (NOLOCK),
                    #new_dsn#.STOCKS_LOCATION SL WITH (NOLOCK)
                WHERE
                    ORDS.RESERVED = 1 AND 
                    ORDS.ORDER_STATUS = 1 AND
                    ORDS.DELIVER_DEPT_ID = SL.DEPARTMENT_ID AND
                    ORDS.LOCATION_ID = SL.LOCATION_ID AND
                    SL.NO_SALE=0 AND
                    ORDS.PURCHASE_SALES=0 AND
                    ORDS.ORDER_ZONE=0 AND
                    ORR.ORDER_ID = ORDS.ORDER_ID AND 
                    (RESERVE_STOCK_IN-STOCK_IN)>0 
                UNION ALL
                SELECT
                    0 AS REAL_STOCK,
                    0 AS PRODUCT_STOCK,
                    0 AS RESERVED_STOCK,
                    0 AS PURCHASE_PROD_STOCK,
                    0 AS RESERVED_PROD_STOCK,
                    0 AS RESERVE_SALE_ORDER_STOCK,
                    0 AS NOSALE_STOCK,
                    0 AS BELONGTO_INSTITUTION_STOCK,
                    0 AS RESERVE_PURCHASE_ORDER_STOCK,
                    0 AS PRODUCTION_ORDER_STOCK,
                    (RESERVE_STOCK_IN-STOCK_IN) AS NOSALE_RESERVED_STOCK,
                    ORR.STOCK_ID,
                    ORR.PRODUCT_ID,
                    ORDS.DELIVER_DEPT_ID AS DEPARTMENT_ID,
                    ORDS.LOCATION_ID AS LOCATION_ID
                FROM
                    #NEW_DSN3#.GET_ORDER_ROW_RESERVED ORR WITH (NOLOCK)
                JOIN
                    fnSplit(@stock_id_list,',') AS TB1
                ON 
                    TB1.item = ORR.STOCK_ID
                    , 
                    #NEW_DSN3#.ORDERS ORDS WITH (NOLOCK),
                    #new_dsn#.STOCKS_LOCATION SL WITH (NOLOCK)
                WHERE
                    ORDS.RESERVED = 1 AND 
                    ORDS.ORDER_STATUS = 1 AND	
                    ORDS.DELIVER_DEPT_ID IS NOT NULL AND
                    ORDS.LOCATION_ID IS NOT NULL AND
                    ORDS.DELIVER_DEPT_ID = SL.DEPARTMENT_ID AND
                    ORDS.LOCATION_ID = SL.LOCATION_ID AND
                    SL.NO_SALE = 1 AND
                    ORDS.PURCHASE_SALES = 0 AND
                    ORDS.ORDER_ZONE = 0 AND
                    ORR.ORDER_ID = ORDS.ORDER_ID AND 
                    (RESERVE_STOCK_IN-STOCK_IN)>0 
                UNION ALL
                SELECT
                        0 AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,
                        (STOCK_ARTIR-STOCK_AZALT) AS RESERVED_STOCK,
                        STOCK_ARTIR AS PURCHASE_PROD_STOCK,
                        STOCK_AZALT AS RESERVED_PROD_STOCK,
                        0 AS RESERVE_SALE_ORDER_STOCK,
                        0 AS NOSALE_STOCK,
                        0 AS BELONGTO_INSTITUTION_STOCK,
                        0 AS RESERVE_PURCHASE_ORDER_STOCK,
                        (STOCK_ARTIR-STOCK_AZALT) AS PRODUCTION_ORDER_STOCK,
                        0 AS NOSALE_RESERVED_STOCK,
                        STOCK_ID,
                        PRODUCT_ID,
                        DEPARTMENT_ID,
                        LOCATION_ID
                    FROM
                        #NEW_DSN3#.GET_PRODUCTION_RESERVED_LOCATION WITH (NOLOCK)
                    JOIN
                        fnSplit(@stock_id_list,',') AS TB1
                    ON 
                        TB1.item = GET_PRODUCTION_RESERVED_LOCATION.STOCK_ID
            ) T1
            GROUP BY
                PRODUCT_ID, 
                STOCK_ID,
                DEPARTMENT_ID,
                LOCATION_ID
            
            END;
</cfquery>

<cfquery name="ADD_SP" datasource="#new_dsn2#">
CREATE PROCEDURE [get_stock_last_spect_location_function]
                (
                    @stock_id_list nvarchar (max)
                )
            AS
            BEGIN 
        
                SELECT
                    SUM(REAL_STOCK) REAL_STOCK,
                    SUM(PRODUCT_STOCK) PRODUCT_STOCK,
                    SUM(PRODUCT_STOCK+RESERVED_STOCK) SALEABLE_STOCK,
                    SUM(PURCHASE_ORDER_STOCK) PURCHASE_ORDER_STOCK,
                    PRODUCT_ID,
                    STOCK_ID,
                    SPECT_MAIN_ID,
                    (SELECT SM.SPECT_MAIN_NAME FROM #NEW_DSN3#.SPECT_MAIN SM WITH (NOLOCK) WHERE SM.SPECT_MAIN_ID = T1.SPECT_MAIN_ID) SPECT_MAIN_NAME,
                    DEPARTMENT_ID,
                    LOCATION_ID
                FROM
                (
                    SELECT
                        (STOCK_IN - STOCK_OUT) AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,
                        0 AS RESERVED_STOCK,
                        0 AS SALE_ORDER_STOCK,
                        0 AS PURCHASE_ORDER_STOCK,
                        SR.PRODUCT_ID, 
                        SR.STOCK_ID,
                        SR.SPECT_VAR_ID SPECT_MAIN_ID,
                        SR.STORE AS DEPARTMENT_ID,
                        SR.STORE_LOCATION AS LOCATION_ID
                    FROM			
                        STOCKS_ROW SR WITH (NOLOCK)
                    JOIN
                        fnSplit(@stock_id_list,',') AS TB1
                    ON 
                        TB1.item = SR.STOCK_ID
                    UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        (STOCK_IN - STOCK_OUT) AS PRODUCT_STOCK,
                        0 AS RESERVED_STOCK,
                        0 AS SALE_ORDER_STOCK,
                        0 AS PURCHASE_ORDER_STOCK,
                        SR.PRODUCT_ID, 
                        SR.STOCK_ID,
                        SR.SPECT_VAR_ID SPECT_MAIN_ID,
                        SR.STORE AS DEPARTMENT_ID,
                        SR.STORE_LOCATION AS LOCATION_ID
                    FROM			
                        #new_dsn#.STOCKS_LOCATION SL WITH (NOLOCK),
                        STOCKS_ROW SR WITH (NOLOCK)
                    JOIN
                        fnSplit(@stock_id_list,',') AS TB1
                    ON 
                        TB1.item = SR.STOCK_ID
                    WHERE			
                        SR.STORE =SL.DEPARTMENT_ID AND 
                        SR.STORE_LOCATION=SL.LOCATION_ID AND 
                        SL.NO_SALE = 0 
                    UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        -1*(STOCK_IN - STOCK_OUT) AS PRODUCT_STOCK,
                        0 AS RESERVED_STOCK,
                        0 AS SALE_ORDER_STOCK,
                        0 AS PURCHASE_ORDER_STOCK,
                        SR.PRODUCT_ID, 
                        SR.STOCK_ID,
                        SR.SPECT_VAR_ID SPECT_MAIN_ID,
                        SR.STORE AS DEPARTMENT_ID,
                        SR.STORE_LOCATION AS LOCATION_ID
                    FROM
                        STOCKS_ROW SR WITH (NOLOCK)
                    JOIN
                        fnSplit(@stock_id_list,',') AS TB1
                    ON 
                        TB1.item = SR.STOCK_ID	
                        ,
                        #new_dsn#.STOCKS_LOCATION SL WITH (NOLOCK)
                    WHERE	
                        SR.STORE = SL.DEPARTMENT_ID AND
                        SR.STORE_LOCATION = SL.LOCATION_ID AND
                        ISNULL(SL.IS_SCRAP,0)=1	
                    UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,
                        ((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)*-1) AS RESERVED_STOCK,
                        0 AS SALE_ORDER_STOCK,
                        ORR.RESERVE_STOCK_IN AS PURCHASE_ORDER_STOCK,
                        ORR.PRODUCT_ID, 
                        ORR.STOCK_ID,
                        (SELECT SPECT_MAIN_ID FROM #NEW_DSN3#.SPECTS WITH (NOLOCK) WHERE SPECT_VAR_ID = ORR.SPECT_VAR_ID) SPECT_MAIN_ID,
                        ORDS.DELIVER_DEPT_ID AS DEPARTMENT_ID,
                        ORDS.LOCATION_ID AS LOCATION_ID
                    FROM
                        #NEW_DSN3#.GET_ORDER_ROW_RESERVED  ORR WITH (NOLOCK)
                    JOIN
                        fnSplit(@stock_id_list,',') AS TB1
                    ON 
                        TB1.item = ORR.STOCK_ID	
                        , 
                        #NEW_DSN3#.ORDERS ORDS WITH (NOLOCK)
                    WHERE
                        ORDS.RESERVED = 1 AND 
                        ORDS.ORDER_STATUS = 1 AND	
                        ORR.ORDER_ID = ORDS.ORDER_ID AND
                        ((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0 OR (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0)
                    UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,
                        (ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) AS RESERVED_STOCK,
                        0 AS SALE_ORDER_STOCK,
                        0 AS PURCHASE_ORDER_STOCK,
                        ORR.PRODUCT_ID, 
                        ORR.STOCK_ID,
                        (SELECT SPECT_MAIN_ID FROM #NEW_DSN3#.SPECTS WITH (NOLOCK) WHERE SPECT_VAR_ID = ORR.SPECT_VAR_ID) SPECT_MAIN_ID,
                        ORDS.DELIVER_DEPT_ID AS DEPARTMENT_ID,
                        ORDS.LOCATION_ID AS LOCATION_ID
                    FROM
                        #new_dsn#.STOCKS_LOCATION SL WITH (NOLOCK),
                        #NEW_DSN3#.GET_ORDER_ROW_RESERVED ORR WITH (NOLOCK)
                    JOIN
                        fnSplit(@stock_id_list,',') AS TB1
                    ON 
                        TB1.item = ORR.STOCK_ID		
                        , 
                        #NEW_DSN3#.ORDERS ORDS WITH (NOLOCK)
                    WHERE
                        ORDS.DELIVER_DEPT_ID = SL.DEPARTMENT_ID AND
                        ORDS.LOCATION_ID = SL.LOCATION_ID AND
                        SL.NO_SALE = 0 AND
                        ORDS.PURCHASE_SALES = 0 AND
                        ORDS.ORDER_ZONE = 0 AND	
                        ORDS.RESERVED = 1 AND 
                        ORDS.ORDER_STATUS = 1 AND	
                        ORR.ORDER_ID = ORDS.ORDER_ID AND
                        (ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0 
                    UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,
                        (STOCK_ARTIR-STOCK_AZALT) AS RESERVED_STOCK,
                        0 AS SALE_ORDER_STOCK,
                        0 AS PURCHASE_ORDER_STOCK,
                        GRS.PRODUCT_ID, 
                        GRS.STOCK_ID,
                        GRS.SPECT_MAIN_ID SPECT_MAIN_ID,
                        DEPARTMENT_ID,
                        LOCATION_ID
                    FROM
                        #NEW_DSN3#.GET_PRODUCTION_RESERVED_SPECT_LOCATION GRS WITH (NOLOCK)
                    JOIN
                        fnSplit(@stock_id_list,',') AS TB1
                    ON 
                        TB1.item = GRS.STOCK_ID	
                ) T1
                GROUP BY
                    PRODUCT_ID, 
                    STOCK_ID,
                    SPECT_MAIN_ID,
                    DEPARTMENT_ID,
                    LOCATION_ID
            END;
</cfquery>

<cfquery name="ADD_SP" datasource="#new_dsn2#">
CREATE PROCEDURE [get_stock_last_spect_location_function_with_spect_main_id]
                (
                    @spect_main_id_list nvarchar (max)
                )
            AS
            BEGIN 
        
                SELECT
                    SUM(REAL_STOCK) REAL_STOCK,
                    SUM(PRODUCT_STOCK) PRODUCT_STOCK,
                    SUM(PRODUCT_STOCK+RESERVED_STOCK) SALEABLE_STOCK,
                    SUM(PURCHASE_ORDER_STOCK) PURCHASE_ORDER_STOCK,
                    PRODUCT_ID,
                    STOCK_ID,
                    SPECT_MAIN_ID,
                    (SELECT SM.SPECT_MAIN_NAME FROM #NEW_DSN3#.SPECT_MAIN SM WITH (NOLOCK) WHERE SM.SPECT_MAIN_ID = T1.SPECT_MAIN_ID) SPECT_MAIN_NAME,
                    DEPARTMENT_ID,
                    LOCATION_ID
                FROM
                (
                    SELECT
                        (STOCK_IN - STOCK_OUT) AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,
                        0 AS RESERVED_STOCK,
                        0 AS SALE_ORDER_STOCK,
                        0 AS PURCHASE_ORDER_STOCK,
                        SR.PRODUCT_ID, 
                        SR.STOCK_ID,
                        SR.SPECT_VAR_ID SPECT_MAIN_ID,
                        SR.STORE AS DEPARTMENT_ID,
                        SR.STORE_LOCATION AS LOCATION_ID
                    FROM			
                        STOCKS_ROW SR WITH (NOLOCK)
                    JOIN
                    	fnSplit(@spect_main_id_list,',') AS TB1
                	ON 
                    	TB1.item = SR.SPECT_VAR_ID
                    UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        (STOCK_IN - STOCK_OUT) AS PRODUCT_STOCK,
                        0 AS RESERVED_STOCK,

                        0 AS SALE_ORDER_STOCK,
                        0 AS PURCHASE_ORDER_STOCK,
                        SR.PRODUCT_ID, 
                        SR.STOCK_ID,
                        SR.SPECT_VAR_ID SPECT_MAIN_ID,
                        SR.STORE AS DEPARTMENT_ID,
                        SR.STORE_LOCATION AS LOCATION_ID
                    FROM			
                        #new_dsn#.STOCKS_LOCATION SL WITH (NOLOCK),
                        STOCKS_ROW SR WITH (NOLOCK)
                    JOIN
                    	fnSplit(@spect_main_id_list,',') AS TB1
                	ON 
                    	TB1.item = SR.SPECT_VAR_ID
                    WHERE			
                        SR.STORE =SL.DEPARTMENT_ID AND 
                        SR.STORE_LOCATION=SL.LOCATION_ID AND 
                        SL.NO_SALE = 0 
                    UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        -1*(STOCK_IN - STOCK_OUT) AS PRODUCT_STOCK,
                        0 AS RESERVED_STOCK,
                        0 AS SALE_ORDER_STOCK,
                        0 AS PURCHASE_ORDER_STOCK,
                        SR.PRODUCT_ID, 
                        SR.STOCK_ID,
                        SR.SPECT_VAR_ID SPECT_MAIN_ID,
                        SR.STORE AS DEPARTMENT_ID,
                        SR.STORE_LOCATION AS LOCATION_ID
                    FROM
                        STOCKS_ROW SR WITH (NOLOCK)
                    JOIN
                    	fnSplit(@spect_main_id_list,',') AS TB1
                    ON 
                    	TB1.item = SR.SPECT_VAR_ID	
                    	,#new_dsn#.STOCKS_LOCATION SL WITH (NOLOCK)
                    WHERE	
                        SR.STORE = SL.DEPARTMENT_ID AND
                        SR.STORE_LOCATION = SL.LOCATION_ID AND
                        ISNULL(SL.IS_SCRAP,0)=1	
                    UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,
                        ((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)*-1) AS RESERVED_STOCK,
                        0 AS SALE_ORDER_STOCK,
                        ORR.RESERVE_STOCK_IN AS PURCHASE_ORDER_STOCK,
                        ORR.PRODUCT_ID, 
                        ORR.STOCK_ID,
                        S.SPECT_MAIN_ID,
                        ORDS.DELIVER_DEPT_ID AS DEPARTMENT_ID,
                        ORDS.LOCATION_ID AS LOCATION_ID
                    FROM
                        #NEW_DSN3#.GET_ORDER_ROW_RESERVED  ORR WITH (NOLOCK)
                    LEFT JOIN
						 #NEW_DSN3#.SPECTS S
					ON	
						S.SPECT_VAR_ID = ORR.SPECT_VAR_ID
					JOIN
                     	fnSplit(@spect_main_id_list,',') AS TB1
                	ON 
                     	TB1.item = S.SPECT_MAIN_ID	
                        ,#NEW_DSN3#.ORDERS ORDS WITH (NOLOCK)
                    WHERE
                        ORDS.RESERVED = 1 AND 
                        ORDS.ORDER_STATUS = 1 AND	
                        ORR.ORDER_ID = ORDS.ORDER_ID AND
                        ((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0 OR (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0)
                    UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,
                        (ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) AS RESERVED_STOCK,
                        0 AS SALE_ORDER_STOCK,
                        0 AS PURCHASE_ORDER_STOCK,
                        ORR.PRODUCT_ID, 
                        ORR.STOCK_ID,
                        S.SPECT_MAIN_ID,
                        ORDS.DELIVER_DEPT_ID AS DEPARTMENT_ID,
                        ORDS.LOCATION_ID AS LOCATION_ID
                    FROM
                        #new_dsn#.STOCKS_LOCATION SL WITH (NOLOCK),
                        #NEW_DSN3#.GET_ORDER_ROW_RESERVED ORR WITH (NOLOCK)
                    
                    LEFT JOIN
						 #NEW_DSN3#.SPECTS S
					ON	
						S.SPECT_VAR_ID = ORR.SPECT_VAR_ID
					JOIN
                     	fnSplit(@spect_main_id_list,',') AS TB1
                	ON 
                     	TB1.item = S.SPECT_MAIN_ID	
                    ,#NEW_DSN3#.ORDERS ORDS WITH (NOLOCK)
                    WHERE
                        ORDS.DELIVER_DEPT_ID = SL.DEPARTMENT_ID AND
                        ORDS.LOCATION_ID = SL.LOCATION_ID AND
                        SL.NO_SALE = 0 AND
                        ORDS.PURCHASE_SALES = 0 AND
                        ORDS.ORDER_ZONE = 0 AND	
                        ORDS.RESERVED = 1 AND 
                        ORDS.ORDER_STATUS = 1 AND	
                        ORR.ORDER_ID = ORDS.ORDER_ID AND
                        (ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0 
                    UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,
                        (STOCK_ARTIR-STOCK_AZALT) AS RESERVED_STOCK,
                        0 AS SALE_ORDER_STOCK,
                        0 AS PURCHASE_ORDER_STOCK,
                        GRS.PRODUCT_ID, 
                        GRS.STOCK_ID,
                        GRS.SPECT_MAIN_ID SPECT_MAIN_ID,
                        DEPARTMENT_ID,
                        LOCATION_ID
                    FROM
                        #NEW_DSN3#.GET_PRODUCTION_RESERVED_SPECT_LOCATION GRS WITH (NOLOCK)
                   JOIN
                     	fnSplit(@spect_main_id_list,',') AS TB1
                	ON 
                     	TB1.item = GRS.SPECT_MAIN_ID	
                ) T1
                GROUP BY
                    PRODUCT_ID, 
                    STOCK_ID,
                    SPECT_MAIN_ID,
                    DEPARTMENT_ID,
                    LOCATION_ID
            END;
</cfquery>

<cfquery name="ADD_SP" datasource="#new_dsn2#">
CREATE PROCEDURE [SP_GET_STOCK_ALL]
            @stock_id_list NVARCHAR(850),
            @type int,
            @p_order_id int 
        AS
        BEGIN
            SET NOCOUNT ON;
            IF @p_order_id <> -1
            BEGIN
                IF @type =1
                BEGIN
                
                    SELECT																																																																																																																																																																																																																																	 
                        ISNULL(PRODUCT_STOCK,0) AS PRODUCT_STOCK,
                        ISNULL(SALEABLE_STOCK,0) AS SALEABLE_STOCK,
                        STOCK_ID,
                        SPEC_MAIN_ID
                    FROM 
                        (
                        SELECT 
                            ROUND(SUM(REAL_STOCK),4) REAL_STOCK,
                            ROUND(SUM(PRODUCT_STOCK),4) PRODUCT_STOCK,
                            ROUND(SUM(PRODUCT_STOCK+RESERVED_STOCK),4) SALEABLE_STOCK,
                            ROUND(SUM(PURCHASE_ORDER_STOCK),4) PURCHASE_ORDER_STOCK,
                            STOCK_ID,
                            T1.SPEC_MAIN_ID
                        FROM
                        (
                            SELECT
                                (SR.STOCK_IN - SR.STOCK_OUT) AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                0 AS RESERVED_STOCK,
                                0 AS PURCHASE_ORDER_STOCK,
                                SR.STOCK_ID,
                                ISNULL(SR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                STOCKS_ROW SR
                            JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = SR.STOCK_ID
                            WHERE
                                1=1
                        UNION ALL			
                            SELECT
                                0 AS REAL_STOCK,
                                (SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,
                                0 AS RESERVED_STOCK,
                                0 AS PURCHASE_ORDER_STOCK,
                                SR.STOCK_ID,
                                ISNULL(SR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                #new_dsn#.STOCKS_LOCATION SL,
                                STOCKS_ROW SR
                                JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = SR.STOCK_ID
                            WHERE
                                SR.STORE =SL.DEPARTMENT_ID
                                AND SR.STORE_LOCATION=SL.LOCATION_ID
                                AND SL.NO_SALE = 0
                        UNION ALL
                            SELECT
                                0 AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                ((RESERVE_STOCK_OUT-STOCK_OUT)*-1) AS RESERVED_STOCK,
                                RESERVE_STOCK_IN AS PURCHASE_ORDER_STOCK,
                                ORR.STOCK_ID,
                                ISNULL(ORR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                #NEW_DSN3#.GET_ORDER_ROW_RESERVED ORR
                                JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = ORR.STOCK_ID, 
                                #NEW_DSN3#.ORDERS ORDS
                            WHERE
                                ORDS.RESERVED = 1 AND 
                                ORDS.ORDER_STATUS = 1 AND	
                                ORR.ORDER_ID=ORDS.ORDER_ID AND 
                                ((RESERVE_STOCK_IN-STOCK_IN)>0 OR (RESERVE_STOCK_OUT-STOCK_OUT)>0)
                        UNION ALL
                            SELECT
                                0 AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                (RESERVE_STOCK_IN-STOCK_IN) AS RESERVED_STOCK,
                                0 AS PURCHASE_ORDER_STOCK,
                                ORR.STOCK_ID,
                                ISNULL(ORR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                #NEW_DSN3#.GET_ORDER_ROW_RESERVED ORR
                                JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = ORR.STOCK_ID, 
                                #NEW_DSN3#.ORDERS ORDS,
                                #new_dsn#.STOCKS_LOCATION SL
                            WHERE
                                ORDS.RESERVED = 1 AND 
                                ORDS.ORDER_STATUS = 1 AND	
                                ORDS.DELIVER_DEPT_ID =SL.DEPARTMENT_ID AND 
                                ORDS.LOCATION_ID=SL.LOCATION_ID AND 
                                SL.NO_SALE = 0	 AND 
                                ORR.ORDER_ID=ORDS.ORDER_ID AND 
                                (RESERVE_STOCK_IN-STOCK_IN)>0
                        UNION ALL			
                            SELECT
                                0 AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                ((RESERVE_STOCK_IN-STOCK_IN) + ((RESERVE_STOCK_OUT-STOCK_OUT)*-1)) AS RESERVED_STOCK,
                                0 AS PURCHASE_ORDER_STOCK,
                                ORR.STOCK_ID,
                                ISNULL(ORR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                #NEW_DSN3#.ORDER_ROW_RESERVED  ORR
                            	JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = ORR.STOCK_ID
                            WHERE
                                ORDER_ID IS NULL
                                AND SHIP_ID IS NULL
                                AND INVOICE_ID IS NULL
                        UNION ALL
                            SELECT
                                0 AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,

                                (STOCK_ARTIR-STOCK_AZALT) AS RESERVED_STOCK,
                                0  AS PURCHASE_ORDER_STOCK,
                                STOCK_ID,
                                SPEC_MAIN_ID
                            FROM
                                (
                                    SELECT
                                        SUM(STOCK_ARTIR) STOCK_ARTIR,
                                        SUM(STOCK_AZALT) STOCK_AZALT,
                                        STOCK_ID,
                                        SPEC_MAIN_ID
                                    FROM
                                        (
                                            SELECT
                                                (QUANTITY) AS STOCK_ARTIR,
                                                0 AS STOCK_AZALT,
                                                STOCK_ID,
                                                ISNULL(SPEC_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                #NEW_DSN3#.PRODUCTION_ORDERS
                                                JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = PRODUCTION_ORDERS.STOCK_ID
                                            WHERE
                                                IS_STOCK_RESERVED = 1 AND
                                                IS_DEMONTAJ=0 AND
                                                SPEC_MAIN_ID IS NOT NULL
                                        UNION ALL
                                            SELECT
                                                0 AS STOCK_ARTIR,
                                                (QUANTITY) AS STOCK_AZALT,
                                                STOCK_ID,
                                                ISNULL(SPEC_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                #NEW_DSN3#.PRODUCTION_ORDERS
                                                JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = PRODUCTION_ORDERS.STOCK_ID
                                            WHERE
                                                IS_STOCK_RESERVED = 1 AND
                                                IS_DEMONTAJ=1 AND
                                                SPEC_MAIN_ID IS NOT NULL
                                        UNION ALL
                                            SELECT
                                                0 AS STOCK_ARTIR,
                                                POS.AMOUNT AS STOCK_AZALT,
                                                POS.STOCK_ID,
                                                ISNULL(POS.SPECT_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                #NEW_DSN3#.PRODUCTION_ORDERS PO,
                                                #NEW_DSN3#.PRODUCTION_ORDERS_STOCKS POS
                                                JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = POS.STOCK_ID
                                            WHERE
                                                PO.IS_STOCK_RESERVED = 1 AND
                                                PO.P_ORDER_ID = POS.P_ORDER_ID AND
                                                PO.IS_DEMONTAJ=0 AND
                                                ISNULL(POS.STOCK_ID,0)>0 AND
                                                POS.IS_SEVK <> 1 AND
                                                ISNULL(IS_FREE_AMOUNT,0) = 0
                                                AND PO.P_ORDER_ID <> @p_order_id
                                        UNION ALL
                                            SELECT
                                                POS.AMOUNT AS STOCK_ARTIR,
                                                0 AS STOCK_AZALT,
                                                POS.STOCK_ID,
                                                ISNULL(POS.SPECT_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                #NEW_DSN3#.PRODUCTION_ORDERS PO,
                                                #NEW_DSN3#.PRODUCTION_ORDERS_STOCKS POS
                                                JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = POS.STOCK_ID
                                            WHERE
                                                PO.IS_STOCK_RESERVED = 1 AND
                                                PO.P_ORDER_ID = POS.P_ORDER_ID AND
                                                PO.IS_DEMONTAJ=1 AND
                                                ISNULL(POS.STOCK_ID,0)>0 AND
                                                POS.IS_SEVK <> 1 AND
                                                ISNULL(IS_FREE_AMOUNT,0) = 0
                                                AND PO.P_ORDER_ID <> @p_order_id
                                        UNION ALL
                                            SELECT 
                                                (P_ORD_R_R.AMOUNT)*-1 AS  STOCK_ARTIR,
                                                0 AS STOCK_AZALT,
                                                P_ORD_R_R.STOCK_ID,
                                                ISNULL(P_ORD.SPEC_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                #NEW_DSN3#.PRODUCTION_ORDER_RESULTS P_ORD_R,
                                                #NEW_DSN3#.PRODUCTION_ORDER_RESULTS_ROW P_ORD_R_R
                                                JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = P_ORD_R_R.STOCK_ID,
                                                #NEW_DSN3#.PRODUCTION_ORDERS P_ORD
                                            WHERE
                                                P_ORD.IS_STOCK_RESERVED=1 AND
                                                P_ORD.SPEC_MAIN_ID IS NOT NULL AND
                                                P_ORD.P_ORDER_ID = P_ORD_R.P_ORDER_ID AND
                                                P_ORD_R_R.PR_ORDER_ID=P_ORD_R.PR_ORDER_ID AND
                                                P_ORD_R_R.TYPE=1 AND
                                                P_ORD_R.IS_STOCK_FIS=1 AND
                                                P_ORD_R_R.IS_SEVKIYAT IS NULL
                                        UNION ALL
                                            SELECT 
                                                0 AS STOCK_ARTIR,
                                                (P_ORD_R_R.AMOUNT)*-1 AS STOCK_AZALT,
                                                P_ORD_R_R.STOCK_ID,
                                                ISNULL(P_ORD.SPEC_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM 
                                                #NEW_DSN3#.PRODUCTION_ORDER_RESULTS P_ORD_R,
                                                #NEW_DSN3#.PRODUCTION_ORDER_RESULTS_ROW P_ORD_R_R
                                                JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = P_ORD_R_R.STOCK_ID,
                                                #NEW_DSN3#.PRODUCTION_ORDERS P_ORD
                                            WHERE
                                                P_ORD.IS_STOCK_RESERVED=1 AND
                                                P_ORD.SPEC_MAIN_ID IS NOT NULL AND
                                                P_ORD.P_ORDER_ID = P_ORD_R.P_ORDER_ID AND
                                                P_ORD_R_R.PR_ORDER_ID=P_ORD_R.PR_ORDER_ID AND
                                                P_ORD_R_R.TYPE=2 AND
                                                P_ORD_R.IS_STOCK_FIS=1 AND
                                                P_ORD_R_R.IS_SEVKIYAT <> 1
                                ) T1
                            GROUP BY 
                                STOCK_ID,
                                T1.SPEC_MAIN_ID
                            )A1
                        ) T1
                    GROUP BY
                            STOCK_ID,
                            SPEC_MAIN_ID
                        ) AS GET_STOCK_LAST
                END
                ELSE
                BEGIN
                    SELECT 
                        ISNULL(PRODUCT_STOCK,0) AS PRODUCT_STOCK,
                        ISNULL(SALEABLE_STOCK,0) AS SALEABLE_STOCK,
                        STOCK_ID,
                        SPEC_MAIN_ID
                    FROM 
                        (
                        SELECT 
                            ROUND(SUM(REAL_STOCK),4) REAL_STOCK,
                            ROUND(SUM(PRODUCT_STOCK),4) PRODUCT_STOCK,
                            ROUND(SUM(PRODUCT_STOCK+RESERVED_STOCK),4) SALEABLE_STOCK,
                            ROUND(SUM(PURCHASE_ORDER_STOCK),4) PURCHASE_ORDER_STOCK,
                            STOCK_ID,
                            T1.SPEC_MAIN_ID
                        FROM
                        (
                            SELECT
                                (SR.STOCK_IN - SR.STOCK_OUT) AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                0 AS RESERVED_STOCK,
                                0 AS PURCHASE_ORDER_STOCK,
                                SR.STOCK_ID,
                                ISNULL(SR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                STOCKS_ROW SR
                            JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = SR.STOCK_ID
                             JOIN
                            (
                                    SELECT
                                        CONVERT(NVARCHAR(10),SL.LOCATION_ID)+'_'+CONVERT(NVARCHAR(10),SL.DEPARTMENT_ID) AS ID 
                                    FROM 
                                        #new_dsn#.STOCKS_LOCATION SL,
                                        #new_dsn#.DEPARTMENT D
                                    WHERE
                                        SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND SL.IS_SCRAP = 1
                            ) as SCARP ON  SCARP.ID <> CONVERT(NVARCHAR(10),SR.STORE_LOCATION)+'_'+CONVERT(NVARCHAR(10),SR.STORE)
        
                                
                
                
                        UNION ALL			
                            SELECT
                                0 AS REAL_STOCK,
                                (SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,
                                0 AS RESERVED_STOCK,
                                0 AS PURCHASE_ORDER_STOCK,
                                SR.STOCK_ID,
                                ISNULL(SR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                #new_dsn#.STOCKS_LOCATION SL,
                                STOCKS_ROW SR
                                JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = SR.STOCK_ID
                             JOIN
                            (
                                    SELECT
                                        CONVERT(NVARCHAR(10),SL.LOCATION_ID)+'_'+CONVERT(NVARCHAR(10),SL.DEPARTMENT_ID) AS ID 
                                    FROM 
                                        #new_dsn#.STOCKS_LOCATION SL,
                                        #new_dsn#.DEPARTMENT D
                                    WHERE
                                        SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND SL.IS_SCRAP = 1
                            ) as SCARP ON  SCARP.ID <> CONVERT(NVARCHAR(10),SR.STORE_LOCATION)+'_'+CONVERT(NVARCHAR(10),SR.STORE)
                            
                                
                            WHERE
                                
                                SR.STORE =SL.DEPARTMENT_ID
                                AND SR.STORE_LOCATION=SL.LOCATION_ID
                                AND SL.NO_SALE = 0
                        UNION ALL
                            SELECT
                                0 AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                ((RESERVE_STOCK_OUT-STOCK_OUT)*-1) AS RESERVED_STOCK,
                                RESERVE_STOCK_IN AS PURCHASE_ORDER_STOCK,
                                ORR.STOCK_ID,
                                ISNULL(ORR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                #NEW_DSN3#.GET_ORDER_ROW_RESERVED ORR
                                JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = ORR.STOCK_ID, 
                                #NEW_DSN3#.ORDERS ORDS
                            WHERE
                                ORDS.RESERVED = 1 AND 
                                ORDS.ORDER_STATUS = 1 AND	
                                ORR.ORDER_ID=ORDS.ORDER_ID AND 
                                ((RESERVE_STOCK_IN-STOCK_IN)>0 OR (RESERVE_STOCK_OUT-STOCK_OUT)>0)
                        UNION ALL
                            SELECT
                                0 AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                (RESERVE_STOCK_IN-STOCK_IN) AS RESERVED_STOCK,
                                0 AS PURCHASE_ORDER_STOCK,
                                ORR.STOCK_ID,
                                ISNULL(ORR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                #NEW_DSN3#.GET_ORDER_ROW_RESERVED ORR
                                JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = ORR.STOCK_ID, 
                                #NEW_DSN3#.ORDERS ORDS,
                                #new_dsn#.STOCKS_LOCATION SL
                            WHERE
                                ORDS.RESERVED = 1 AND 
                                ORDS.ORDER_STATUS = 1 AND	
                                ORDS.DELIVER_DEPT_ID =SL.DEPARTMENT_ID AND 
                                ORDS.LOCATION_ID=SL.LOCATION_ID AND 
                                SL.NO_SALE = 0	 AND 
                                ORR.ORDER_ID=ORDS.ORDER_ID AND 
                                (RESERVE_STOCK_IN-STOCK_IN)>0
                        UNION ALL			
                            SELECT
                                0 AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                ((RESERVE_STOCK_IN-STOCK_IN) + ((RESERVE_STOCK_OUT-STOCK_OUT)*-1)) AS RESERVED_STOCK,
                                0 AS PURCHASE_ORDER_STOCK,
                                ORR.STOCK_ID,
                                ISNULL(ORR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                #NEW_DSN3#.ORDER_ROW_RESERVED  ORR
                            	JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = ORR.STOCK_ID
                            WHERE
                                ORDER_ID IS NULL
                                AND SHIP_ID IS NULL
                                AND INVOICE_ID IS NULL
                        UNION ALL
                            SELECT
                                0 AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                (STOCK_ARTIR-STOCK_AZALT) AS RESERVED_STOCK,
                                0  AS PURCHASE_ORDER_STOCK,
                                STOCK_ID,
                                SPEC_MAIN_ID
                            FROM
                                (
                                    SELECT
                                        SUM(STOCK_ARTIR) STOCK_ARTIR,
                                        SUM(STOCK_AZALT) STOCK_AZALT,
                                        STOCK_ID,
                                        SPEC_MAIN_ID
                                    FROM
                                        (
                                            SELECT
                                                (QUANTITY) AS STOCK_ARTIR,
                                                0 AS STOCK_AZALT,
                                                STOCK_ID,
                                                ISNULL(SPEC_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                #NEW_DSN3#.PRODUCTION_ORDERS
                                                JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = PRODUCTION_ORDERS.STOCK_ID
                                            WHERE
                                                IS_STOCK_RESERVED = 1 AND
                                                IS_DEMONTAJ=0 AND
                                                SPEC_MAIN_ID IS NOT NULL
                                        UNION ALL
                                            SELECT
                                                0 AS STOCK_ARTIR,
                                                (QUANTITY) AS STOCK_AZALT,
                                                STOCK_ID,
                                                ISNULL(SPEC_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                #NEW_DSN3#.PRODUCTION_ORDERS
                                                JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = PRODUCTION_ORDERS.STOCK_ID
                                            WHERE
                                                IS_STOCK_RESERVED = 1 AND
                                                IS_DEMONTAJ=1 AND
                                                SPEC_MAIN_ID IS NOT NULL
                                        UNION ALL
                                            SELECT
                                                0 AS STOCK_ARTIR,
                                                POS.AMOUNT AS STOCK_AZALT,
                                                POS.STOCK_ID,
                                                ISNULL(POS.SPECT_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                #NEW_DSN3#.PRODUCTION_ORDERS PO,
                                                #NEW_DSN3#.PRODUCTION_ORDERS_STOCKS POS
                                                JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = POS.STOCK_ID
                                            WHERE
                                                PO.IS_STOCK_RESERVED = 1 AND
                                                PO.P_ORDER_ID = POS.P_ORDER_ID AND
                                                PO.IS_DEMONTAJ=0 AND
                                                ISNULL(POS.STOCK_ID,0)>0 AND
                                                POS.IS_SEVK <> 1 AND
                                                ISNULL(IS_FREE_AMOUNT,0) = 0
                                                AND PO.P_ORDER_ID <> @p_order_id
                                        UNION ALL
                                            SELECT
                                                POS.AMOUNT AS STOCK_ARTIR,
                                                0 AS STOCK_AZALT,
                                                POS.STOCK_ID,
                                                ISNULL(POS.SPECT_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                #NEW_DSN3#.PRODUCTION_ORDERS PO,
                                                #NEW_DSN3#.PRODUCTION_ORDERS_STOCKS POS
                                                JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = POS.STOCK_ID
                                            WHERE
                                                PO.IS_STOCK_RESERVED = 1 AND
                                                PO.P_ORDER_ID = POS.P_ORDER_ID AND
                                                PO.IS_DEMONTAJ=1 AND
                                                ISNULL(POS.STOCK_ID,0)>0 AND
                                                POS.IS_SEVK <> 1 AND
                                                ISNULL(IS_FREE_AMOUNT,0) = 0
                                                AND PO.P_ORDER_ID <> @p_order_id
                                        UNION ALL
                                            SELECT 
                                                (P_ORD_R_R.AMOUNT)*-1 AS  STOCK_ARTIR,
                                                0 AS STOCK_AZALT,
                                                P_ORD_R_R.STOCK_ID,
                                                ISNULL(P_ORD.SPEC_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                #NEW_DSN3#.PRODUCTION_ORDER_RESULTS P_ORD_R,
                                                #NEW_DSN3#.PRODUCTION_ORDER_RESULTS_ROW P_ORD_R_R
                                                JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = P_ORD_R_R.STOCK_ID,
                                                #NEW_DSN3#.PRODUCTION_ORDERS P_ORD
                                            WHERE
                                                P_ORD.IS_STOCK_RESERVED=1 AND
                                                P_ORD.SPEC_MAIN_ID IS NOT NULL AND
                                                P_ORD.P_ORDER_ID = P_ORD_R.P_ORDER_ID AND
                                                P_ORD_R_R.PR_ORDER_ID=P_ORD_R.PR_ORDER_ID AND
                                                P_ORD_R_R.TYPE=1 AND
                                                P_ORD_R.IS_STOCK_FIS=1 AND
                                                P_ORD_R_R.IS_SEVKIYAT IS NULL
                                        UNION ALL
                                            SELECT 
                                                0 AS STOCK_ARTIR,
                                                (P_ORD_R_R.AMOUNT)*-1 AS STOCK_AZALT,
                                                P_ORD_R_R.STOCK_ID,
                                                ISNULL(P_ORD.SPEC_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM 
                                                #NEW_DSN3#.PRODUCTION_ORDER_RESULTS P_ORD_R,
                                                #NEW_DSN3#.PRODUCTION_ORDER_RESULTS_ROW P_ORD_R_R
                                                JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = P_ORD_R_R.STOCK_ID,
                                                #NEW_DSN3#.PRODUCTION_ORDERS P_ORD
                                            WHERE
                                                P_ORD.IS_STOCK_RESERVED=1 AND
                                                P_ORD.SPEC_MAIN_ID IS NOT NULL AND
                                                P_ORD.P_ORDER_ID = P_ORD_R.P_ORDER_ID AND
                                                P_ORD_R_R.PR_ORDER_ID=P_ORD_R.PR_ORDER_ID AND
                                                P_ORD_R_R.TYPE=2 AND
                                                P_ORD_R.IS_STOCK_FIS=1 AND
                                                P_ORD_R_R.IS_SEVKIYAT <> 1
                                ) T1
                            GROUP BY 
                                STOCK_ID,
                                T1.SPEC_MAIN_ID
                            )A1
                        ) T1
                    GROUP BY
                            STOCK_ID,
                            SPEC_MAIN_ID
                        ) AS GET_STOCK_LAST
                END
            END
        
            else
                BEGIN
        
                    IF @type =1
                BEGIN
                
                    SELECT																																																																																																																																																																																																																																	 
                        ISNULL(PRODUCT_STOCK,0) AS PRODUCT_STOCK,
                        ISNULL(SALEABLE_STOCK,0) AS SALEABLE_STOCK,
                        STOCK_ID,
                        SPEC_MAIN_ID
                    FROM 
                        (
                        SELECT 
                            ROUND(SUM(REAL_STOCK),4) REAL_STOCK,
                            ROUND(SUM(PRODUCT_STOCK),4) PRODUCT_STOCK,
                            ROUND(SUM(PRODUCT_STOCK+RESERVED_STOCK),4) SALEABLE_STOCK,
                            ROUND(SUM(PURCHASE_ORDER_STOCK),4) PURCHASE_ORDER_STOCK,
                            STOCK_ID,
                            T1.SPEC_MAIN_ID
                        FROM
                        (
                            SELECT
                                (SR.STOCK_IN - SR.STOCK_OUT) AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                0 AS RESERVED_STOCK,
                                0 AS PURCHASE_ORDER_STOCK,
                                SR.STOCK_ID,
                                ISNULL(SR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                STOCKS_ROW SR
                            JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = SR.STOCK_ID
                            WHERE
                                1=1
                        UNION ALL			
                            SELECT
                                0 AS REAL_STOCK,
                                (SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,
                                0 AS RESERVED_STOCK,
                                0 AS PURCHASE_ORDER_STOCK,
                                SR.STOCK_ID,
                                ISNULL(SR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                #new_dsn#.STOCKS_LOCATION SL,
                                STOCKS_ROW SR
                                JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = SR.STOCK_ID
                            WHERE
                                SR.STORE =SL.DEPARTMENT_ID
                                AND SR.STORE_LOCATION=SL.LOCATION_ID
                                AND SL.NO_SALE = 0
                        UNION ALL
                            SELECT
                                0 AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                ((RESERVE_STOCK_OUT-STOCK_OUT)*-1) AS RESERVED_STOCK,
                                RESERVE_STOCK_IN AS PURCHASE_ORDER_STOCK,
                                ORR.STOCK_ID,
                                ISNULL(ORR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                #NEW_DSN3#.GET_ORDER_ROW_RESERVED ORR
                                JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = ORR.STOCK_ID, 
                                #NEW_DSN3#.ORDERS ORDS
                            WHERE
                                ORDS.RESERVED = 1 AND 
                                ORDS.ORDER_STATUS = 1 AND	
                                ORR.ORDER_ID=ORDS.ORDER_ID AND 
                                ((RESERVE_STOCK_IN-STOCK_IN)>0 OR (RESERVE_STOCK_OUT-STOCK_OUT)>0)
                        UNION ALL
                            SELECT
                                0 AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                (RESERVE_STOCK_IN-STOCK_IN) AS RESERVED_STOCK,
                                0 AS PURCHASE_ORDER_STOCK,
                                ORR.STOCK_ID,
                                ISNULL(ORR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                #NEW_DSN3#.GET_ORDER_ROW_RESERVED ORR
                                JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = ORR.STOCK_ID, 
                                #NEW_DSN3#.ORDERS ORDS,
                                #new_dsn#.STOCKS_LOCATION SL
                            WHERE
                                ORDS.RESERVED = 1 AND 
                                ORDS.ORDER_STATUS = 1 AND	
                                ORDS.DELIVER_DEPT_ID =SL.DEPARTMENT_ID AND 
                                ORDS.LOCATION_ID=SL.LOCATION_ID AND 
                                SL.NO_SALE = 0	 AND 
                                ORR.ORDER_ID=ORDS.ORDER_ID AND 
                                (RESERVE_STOCK_IN-STOCK_IN)>0
                        UNION ALL			
                            SELECT
                                0 AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                ((RESERVE_STOCK_IN-STOCK_IN) + ((RESERVE_STOCK_OUT-STOCK_OUT)*-1)) AS RESERVED_STOCK,
                                0 AS PURCHASE_ORDER_STOCK,
                                ORR.STOCK_ID,
                                ISNULL(ORR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                #NEW_DSN3#.ORDER_ROW_RESERVED  ORR
                            	JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = ORR.STOCK_ID
                            WHERE
                                ORDER_ID IS NULL
                                AND SHIP_ID IS NULL
                                AND INVOICE_ID IS NULL
                        UNION ALL
                            SELECT
                                0 AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                (STOCK_ARTIR-STOCK_AZALT) AS RESERVED_STOCK,
                                0  AS PURCHASE_ORDER_STOCK,
                                STOCK_ID,
                                SPEC_MAIN_ID
                            FROM
                                (
                                    SELECT
                                        SUM(STOCK_ARTIR) STOCK_ARTIR,
                                        SUM(STOCK_AZALT) STOCK_AZALT,
                                        STOCK_ID,
                                        SPEC_MAIN_ID
                                    FROM
                                        (
                                            SELECT
                                                (QUANTITY) AS STOCK_ARTIR,
                                                0 AS STOCK_AZALT,
                                                STOCK_ID,
                                                ISNULL(SPEC_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                #NEW_DSN3#.PRODUCTION_ORDERS
                                                JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = PRODUCTION_ORDERS.STOCK_ID
                                            WHERE
                                                IS_STOCK_RESERVED = 1 AND
                                                IS_DEMONTAJ=0 AND
                                                SPEC_MAIN_ID IS NOT NULL
                                        UNION ALL
                                            SELECT
                                                0 AS STOCK_ARTIR,
                                                (QUANTITY) AS STOCK_AZALT,
                                                STOCK_ID,
                                                ISNULL(SPEC_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                #NEW_DSN3#.PRODUCTION_ORDERS
                                                JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = PRODUCTION_ORDERS.STOCK_ID
                                            WHERE
                                                IS_STOCK_RESERVED = 1 AND
                                                IS_DEMONTAJ=1 AND
                                                SPEC_MAIN_ID IS NOT NULL
                                        UNION ALL
                                            SELECT
                                                0 AS STOCK_ARTIR,
                                                POS.AMOUNT AS STOCK_AZALT,
                                                POS.STOCK_ID,
                                                ISNULL(POS.SPECT_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                #NEW_DSN3#.PRODUCTION_ORDERS PO,
                                                #NEW_DSN3#.PRODUCTION_ORDERS_STOCKS POS
                                                JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = POS.STOCK_ID
                                            WHERE
                                                PO.IS_STOCK_RESERVED = 1 AND
                                                PO.P_ORDER_ID = POS.P_ORDER_ID AND
                                                PO.IS_DEMONTAJ=0 AND
                                                ISNULL(POS.STOCK_ID,0)>0 AND
                                                POS.IS_SEVK <> 1 AND
                                                ISNULL(IS_FREE_AMOUNT,0) = 0
                                        UNION ALL
                                            SELECT
                                                POS.AMOUNT AS STOCK_ARTIR,
                                                0 AS STOCK_AZALT,
                                                POS.STOCK_ID,
                                                ISNULL(POS.SPECT_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                #NEW_DSN3#.PRODUCTION_ORDERS PO,
                                                #NEW_DSN3#.PRODUCTION_ORDERS_STOCKS POS
                                                JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = POS.STOCK_ID
                                            WHERE
                                                PO.IS_STOCK_RESERVED = 1 AND
                                                PO.P_ORDER_ID = POS.P_ORDER_ID AND
                                                PO.IS_DEMONTAJ=1 AND
                                                ISNULL(POS.STOCK_ID,0)>0 AND
                                                POS.IS_SEVK <> 1 AND
                                                ISNULL(IS_FREE_AMOUNT,0) = 0
                                        UNION ALL
                                            SELECT 
                                                (P_ORD_R_R.AMOUNT)*-1 AS  STOCK_ARTIR,
                                                0 AS STOCK_AZALT,
                                                P_ORD_R_R.STOCK_ID,
                                                ISNULL(P_ORD.SPEC_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                #NEW_DSN3#.PRODUCTION_ORDER_RESULTS P_ORD_R,
                                                #NEW_DSN3#.PRODUCTION_ORDER_RESULTS_ROW P_ORD_R_R
                                                JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = P_ORD_R_R.STOCK_ID,
                                                #NEW_DSN3#.PRODUCTION_ORDERS P_ORD
                                            WHERE
                                                P_ORD.IS_STOCK_RESERVED=1 AND
                                                P_ORD.SPEC_MAIN_ID IS NOT NULL AND
                                                P_ORD.P_ORDER_ID = P_ORD_R.P_ORDER_ID AND
                                                P_ORD_R_R.PR_ORDER_ID=P_ORD_R.PR_ORDER_ID AND
                                                P_ORD_R_R.TYPE=1 AND
                                                P_ORD_R.IS_STOCK_FIS=1 AND
                                                P_ORD_R_R.IS_SEVKIYAT IS NULL
                                        UNION ALL
                                            SELECT 
                                                0 AS STOCK_ARTIR,
                                                (P_ORD_R_R.AMOUNT)*-1 AS STOCK_AZALT,
                                                P_ORD_R_R.STOCK_ID,
                                                ISNULL(P_ORD.SPEC_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM 
                                                #NEW_DSN3#.PRODUCTION_ORDER_RESULTS P_ORD_R,
                                                #NEW_DSN3#.PRODUCTION_ORDER_RESULTS_ROW P_ORD_R_R
                                                JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = P_ORD_R_R.STOCK_ID,
                                                #NEW_DSN3#.PRODUCTION_ORDERS P_ORD
                                            WHERE
                                                P_ORD.IS_STOCK_RESERVED=1 AND
                                                P_ORD.SPEC_MAIN_ID IS NOT NULL AND
                                                P_ORD.P_ORDER_ID = P_ORD_R.P_ORDER_ID AND
                                                P_ORD_R_R.PR_ORDER_ID=P_ORD_R.PR_ORDER_ID AND
                                                P_ORD_R_R.TYPE=2 AND
                                                P_ORD_R.IS_STOCK_FIS=1 AND
                                                P_ORD_R_R.IS_SEVKIYAT <> 1
                                ) T1
                            GROUP BY 
                                STOCK_ID,
                                T1.SPEC_MAIN_ID
                            )A1
                        ) T1
                    GROUP BY
                            STOCK_ID,
                            SPEC_MAIN_ID
                        ) AS GET_STOCK_LAST
                END
                ELSE
                BEGIN
                    SELECT 
                        ISNULL(PRODUCT_STOCK,0) AS PRODUCT_STOCK,
                        ISNULL(SALEABLE_STOCK,0) AS SALEABLE_STOCK,
                        STOCK_ID,
                        SPEC_MAIN_ID
                    FROM 
                        (
                        SELECT 
                            ROUND(SUM(REAL_STOCK),4) REAL_STOCK,
                            ROUND(SUM(PRODUCT_STOCK),4) PRODUCT_STOCK,
                            ROUND(SUM(PRODUCT_STOCK+RESERVED_STOCK),4) SALEABLE_STOCK,
                            ROUND(SUM(PURCHASE_ORDER_STOCK),4) PURCHASE_ORDER_STOCK,
                            STOCK_ID,
                            T1.SPEC_MAIN_ID
                        FROM
                        (
                            SELECT
                                (SR.STOCK_IN - SR.STOCK_OUT) AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                0 AS RESERVED_STOCK,
                                0 AS PURCHASE_ORDER_STOCK,
                                SR.STOCK_ID,
                                ISNULL(SR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                STOCKS_ROW SR
                            JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = SR.STOCK_ID
                             JOIN
                            (
                                    SELECT
                                        CONVERT(NVARCHAR(10),SL.LOCATION_ID)+'_'+CONVERT(NVARCHAR(10),SL.DEPARTMENT_ID) AS ID 
                                    FROM 
                                        #new_dsn#.STOCKS_LOCATION SL,
                                        #new_dsn#.DEPARTMENT D
                                    WHERE
                                        SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND SL.IS_SCRAP = 1
                            ) as SCARP ON  SCARP.ID <> CONVERT(NVARCHAR(10),SR.STORE_LOCATION)+'_'+CONVERT(NVARCHAR(10),SR.STORE)
                        UNION ALL			
                            SELECT
                                0 AS REAL_STOCK,
                                (SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,
                                0 AS RESERVED_STOCK,
                                0 AS PURCHASE_ORDER_STOCK,
                                SR.STOCK_ID,
                                ISNULL(SR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                #new_dsn#.STOCKS_LOCATION SL,
                                STOCKS_ROW SR
                                JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = SR.STOCK_ID
                             JOIN
                            (
                                    SELECT
                                        CONVERT(NVARCHAR(10),SL.LOCATION_ID)+'_'+CONVERT(NVARCHAR(10),SL.DEPARTMENT_ID) AS ID 
                                    FROM 
                                        #new_dsn#.STOCKS_LOCATION SL,
                                        #new_dsn#.DEPARTMENT D
                                    WHERE
                                        SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND SL.IS_SCRAP = 1
                            ) as SCARP ON  SCARP.ID <> CONVERT(NVARCHAR(10),SR.STORE_LOCATION)+'_'+CONVERT(NVARCHAR(10),SR.STORE)
                            
                                
                            WHERE
                                
                                SR.STORE =SL.DEPARTMENT_ID
                                AND SR.STORE_LOCATION=SL.LOCATION_ID
                                AND SL.NO_SALE = 0
                        UNION ALL
                            SELECT
                                0 AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                ((RESERVE_STOCK_OUT-STOCK_OUT)*-1) AS RESERVED_STOCK,
                                RESERVE_STOCK_IN AS PURCHASE_ORDER_STOCK,
                                ORR.STOCK_ID,
                                ISNULL(ORR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                #NEW_DSN3#.GET_ORDER_ROW_RESERVED ORR
                                JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = ORR.STOCK_ID, 
                                #NEW_DSN3#.ORDERS ORDS
                            WHERE
                                ORDS.RESERVED = 1 AND 
                                ORDS.ORDER_STATUS = 1 AND	
                                ORR.ORDER_ID=ORDS.ORDER_ID AND 
                                ((RESERVE_STOCK_IN-STOCK_IN)>0 OR (RESERVE_STOCK_OUT-STOCK_OUT)>0)
                        UNION ALL
                            SELECT
                                0 AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                (RESERVE_STOCK_IN-STOCK_IN) AS RESERVED_STOCK,
                                0 AS PURCHASE_ORDER_STOCK,
                                ORR.STOCK_ID,
                                ISNULL(ORR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                #NEW_DSN3#.GET_ORDER_ROW_RESERVED ORR
                                JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = ORR.STOCK_ID, 
                                #NEW_DSN3#.ORDERS ORDS,
                                #new_dsn#.STOCKS_LOCATION SL
                            WHERE
                                ORDS.RESERVED = 1 AND 
                                ORDS.ORDER_STATUS = 1 AND	
                                ORDS.DELIVER_DEPT_ID =SL.DEPARTMENT_ID AND 
                                ORDS.LOCATION_ID=SL.LOCATION_ID AND 
                                SL.NO_SALE = 0	 AND 
                                ORR.ORDER_ID=ORDS.ORDER_ID AND 
                                (RESERVE_STOCK_IN-STOCK_IN)>0
                        UNION ALL			
                            SELECT
                                0 AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                ((RESERVE_STOCK_IN-STOCK_IN) + ((RESERVE_STOCK_OUT-STOCK_OUT)*-1)) AS RESERVED_STOCK,
                                0 AS PURCHASE_ORDER_STOCK,
                                ORR.STOCK_ID,
                                ISNULL(ORR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                #NEW_DSN3#.ORDER_ROW_RESERVED  ORR
                            	JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = ORR.STOCK_ID
                            WHERE
                                ORDER_ID IS NULL
                                AND SHIP_ID IS NULL
                                AND INVOICE_ID IS NULL
                        UNION ALL
                            SELECT
                                0 AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                (STOCK_ARTIR-STOCK_AZALT) AS RESERVED_STOCK,
                                0  AS PURCHASE_ORDER_STOCK,
                                STOCK_ID,
                                SPEC_MAIN_ID
                            FROM
                                (
                                    SELECT
                                        SUM(STOCK_ARTIR) STOCK_ARTIR,
                                        SUM(STOCK_AZALT) STOCK_AZALT,
                                        STOCK_ID,
                                        SPEC_MAIN_ID
                                    FROM
                                        (
                                            SELECT
                                                (QUANTITY) AS STOCK_ARTIR,
                                                0 AS STOCK_AZALT,
                                                STOCK_ID,
                                                ISNULL(SPEC_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                #NEW_DSN3#.PRODUCTION_ORDERS
                                                JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = PRODUCTION_ORDERS.STOCK_ID
                                            WHERE
                                                IS_STOCK_RESERVED = 1 AND
                                                IS_DEMONTAJ=0 AND
                                                SPEC_MAIN_ID IS NOT NULL
                                        UNION ALL
                                            SELECT
                                                0 AS STOCK_ARTIR,
                                                (QUANTITY) AS STOCK_AZALT,
                                                STOCK_ID,
                                                ISNULL(SPEC_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                #NEW_DSN3#.PRODUCTION_ORDERS
                                                JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = PRODUCTION_ORDERS.STOCK_ID
                                            WHERE
                                                IS_STOCK_RESERVED = 1 AND
                                                IS_DEMONTAJ=1 AND
                                                SPEC_MAIN_ID IS NOT NULL
                                        UNION ALL
                                            SELECT
                                                0 AS STOCK_ARTIR,
                                                POS.AMOUNT AS STOCK_AZALT,
                                                POS.STOCK_ID,
                                                ISNULL(POS.SPECT_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                #NEW_DSN3#.PRODUCTION_ORDERS PO,
                                                #NEW_DSN3#.PRODUCTION_ORDERS_STOCKS POS
                                                JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = POS.STOCK_ID
                                            WHERE
                                                PO.IS_STOCK_RESERVED = 1 AND
                                                PO.P_ORDER_ID = POS.P_ORDER_ID AND
                                                PO.IS_DEMONTAJ=0 AND
                                                ISNULL(POS.STOCK_ID,0)>0 AND
                                                POS.IS_SEVK <> 1 AND
                                                ISNULL(IS_FREE_AMOUNT,0) = 0
                                        UNION ALL
                                            SELECT
                                                POS.AMOUNT AS STOCK_ARTIR,
                                                0 AS STOCK_AZALT,
                                                POS.STOCK_ID,
                                                ISNULL(POS.SPECT_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                #NEW_DSN3#.PRODUCTION_ORDERS PO,
                                                #NEW_DSN3#.PRODUCTION_ORDERS_STOCKS POS
                                                JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = POS.STOCK_ID
                                            WHERE
                                                PO.IS_STOCK_RESERVED = 1 AND
                                                PO.P_ORDER_ID = POS.P_ORDER_ID AND
                                                PO.IS_DEMONTAJ=1 AND
                                                ISNULL(POS.STOCK_ID,0)>0 AND
                                                POS.IS_SEVK <> 1 AND
                                                ISNULL(IS_FREE_AMOUNT,0) = 0
                                        UNION ALL
                                            SELECT 
                                                (P_ORD_R_R.AMOUNT)*-1 AS  STOCK_ARTIR,
                                                0 AS STOCK_AZALT,
                                                P_ORD_R_R.STOCK_ID,
                                                ISNULL(P_ORD.SPEC_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                #NEW_DSN3#.PRODUCTION_ORDER_RESULTS P_ORD_R,
                                                #NEW_DSN3#.PRODUCTION_ORDER_RESULTS_ROW P_ORD_R_R
                                                JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = P_ORD_R_R.STOCK_ID,
                                                #NEW_DSN3#.PRODUCTION_ORDERS P_ORD
                                            WHERE
                                                P_ORD.IS_STOCK_RESERVED=1 AND
                                                P_ORD.SPEC_MAIN_ID IS NOT NULL AND
                                                P_ORD.P_ORDER_ID = P_ORD_R.P_ORDER_ID AND
                                                P_ORD_R_R.PR_ORDER_ID=P_ORD_R.PR_ORDER_ID AND
                                                P_ORD_R_R.TYPE=1 AND
                                                P_ORD_R.IS_STOCK_FIS=1 AND
                                                P_ORD_R_R.IS_SEVKIYAT IS NULL
                                        UNION ALL
                                            SELECT 
                                                0 AS STOCK_ARTIR,
                                                (P_ORD_R_R.AMOUNT)*-1 AS STOCK_AZALT,
                                                P_ORD_R_R.STOCK_ID,
                                                ISNULL(P_ORD.SPEC_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM 
                                                #NEW_DSN3#.PRODUCTION_ORDER_RESULTS P_ORD_R,
                                                #NEW_DSN3#.PRODUCTION_ORDER_RESULTS_ROW P_ORD_R_R
                                                JOIN #new_dsn#.fnsplit(@stock_id_list,',') AS XXX on XXX.item = P_ORD_R_R.STOCK_ID,
                                                #NEW_DSN3#.PRODUCTION_ORDERS P_ORD
                                            WHERE
                                                P_ORD.IS_STOCK_RESERVED=1 AND
                                                P_ORD.SPEC_MAIN_ID IS NOT NULL AND
                                                P_ORD.P_ORDER_ID = P_ORD_R.P_ORDER_ID AND
                                                P_ORD_R_R.PR_ORDER_ID=P_ORD_R.PR_ORDER_ID AND
                                                P_ORD_R_R.TYPE=2 AND
                                                P_ORD_R.IS_STOCK_FIS=1 AND
                                                P_ORD_R_R.IS_SEVKIYAT <> 1
                                ) T1
                            GROUP BY 
                                STOCK_ID,
                                T1.SPEC_MAIN_ID
                            )A1
                        ) T1
                    GROUP BY
                            STOCK_ID,
                            SPEC_MAIN_ID
                        ) AS GET_STOCK_LAST
                END
        
                END           
        END
</cfquery>

<cfquery name="ADD_SP" datasource="#new_dsn2#">
CREATE  PROCEDURE [SpGetStockLastStrategy] AS
	BEGIN
		SELECT 
			SUM(REAL_STOCK) REAL_STOCK,
			SUM(PRODUCT_STOCK) PRODUCT_STOCK,
			SUM(RESERVED_STOCK) RESERVED_STOCK,
			SUM(PURCHASE_PROD_STOCK) PURCHASE_PROD_STOCK,
			SUM(RESERVED_PROD_STOCK) RESERVED_PROD_STOCK,
			SUM(PRODUCT_STOCK+RESERVED_STOCK) SALEABLE_STOCK,
			SUM(RESERVE_SALE_ORDER_STOCK) RESERVE_SALE_ORDER_STOCK,
			SUM(NOSALE_STOCK) NOSALE_STOCK,
			SUM(BELONGTO_INSTITUTION_STOCK) BELONGTO_INSTITUTION_STOCK,
			SUM(RESERVE_PURCHASE_ORDER_STOCK) RESERVE_PURCHASE_ORDER_STOCK,
			SUM(PRODUCTION_ORDER_STOCK) PRODUCTION_ORDER_STOCK,
			SUM(NOSALE_RESERVED_STOCK) AS NOSALE_RESERVED_STOCK,
			PRODUCT_ID, 
			STOCK_ID,
			DEPARTMENT_ID,
			LOCATION_ID
	INTO  ####TStockLastProfile	
	FROM
		(
			SELECT
				(SR.STOCK_IN - SR.STOCK_OUT) AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				0 AS RESERVED_STOCK,
				0 AS PURCHASE_PROD_STOCK,
				0 AS RESERVED_PROD_STOCK,
				0 AS RESERVE_SALE_ORDER_STOCK,
				0 AS NOSALE_STOCK, 
				0 AS BELONGTO_INSTITUTION_STOCK,
				0 AS RESERVE_PURCHASE_ORDER_STOCK,
				0 AS PRODUCTION_ORDER_STOCK,
				0 AS NOSALE_RESERVED_STOCK,
				SR.STOCK_ID,
				SR.PRODUCT_ID,
				SR.STORE AS DEPARTMENT_ID,
				SR.STORE_LOCATION AS LOCATION_ID
			FROM
				STOCKS_ROW SR 
			WHERE
				SR.STORE IS NOT NULL AND
				SR.STORE_LOCATION IS NOT NULL 
		UNION ALL
			SELECT
				(SR.STOCK_IN - SR.STOCK_OUT) AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				0 AS RESERVED_STOCK,
				0 AS PURCHASE_PROD_STOCK,
				0 AS RESERVED_PROD_STOCK,
				0 AS RESERVE_SALE_ORDER_STOCK,
				0 AS NOSALE_STOCK, 
				0 AS BELONGTO_INSTITUTION_STOCK,
				0 AS RESERVE_PURCHASE_ORDER_STOCK,
				0 AS PRODUCTION_ORDER_STOCK,
				0 AS NOSALE_RESERVED_STOCK,
				SR.STOCK_ID,
				SR.PRODUCT_ID,
				'-1'  AS DEPARTMENT_ID,
				'-1'  AS LOCATION_ID
			FROM
				STOCKS_ROW SR 
			WHERE
				UPD_ID IS NULL
		UNION ALL
			SELECT
				0 AS REAL_STOCK,
				(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,
				0 AS RESERVED_STOCK,
				0 AS PURCHASE_PROD_STOCK,
				0 AS RESERVED_PROD_STOCK,
				0 AS RESERVE_SALE_ORDER_STOCK,
				0 AS NOSALE_STOCK, 
				0 AS BELONGTO_INSTITUTION_STOCK,
				0 AS RESERVE_PURCHASE_ORDER_STOCK,
				0 AS PRODUCTION_ORDER_STOCK,
				0 AS NOSALE_RESERVED_STOCK,
				SR.STOCK_ID,
				SR.PRODUCT_ID,
				SR.STORE AS DEPARTMENT_ID,
				SR.STORE_LOCATION AS LOCATION_ID
			FROM
				#new_dsn#.STOCKS_LOCATION SL,
				STOCKS_ROW SR  
			WHERE
				SR.STORE =SL.DEPARTMENT_ID
				AND SR.STORE_LOCATION=SL.LOCATION_ID
				AND SL.NO_SALE = 0
		UNION ALL
			SELECT
				0 AS REAL_STOCK,
				-1*(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,
				0 AS RESERVED_STOCK,
				0 AS PURCHASE_PROD_STOCK,
				0 AS RESERVED_PROD_STOCK,
				0 AS RESERVE_SALE_ORDER_STOCK,
				0 AS NOSALE_STOCK, 
				0 AS BELONGTO_INSTITUTION_STOCK,
				0 AS RESERVE_PURCHASE_ORDER_STOCK,
				0 AS PRODUCTION_ORDER_STOCK,
				0 AS NOSALE_RESERVED_STOCK,
				SR.STOCK_ID,
				SR.PRODUCT_ID,
				SR.STORE AS DEPARTMENT_ID,
				SR.STORE_LOCATION AS LOCATION_ID
			FROM
				STOCKS_ROW SR  ,
				#new_dsn#.STOCKS_LOCATION SL 
			WHERE	
				SR.STORE = SL.DEPARTMENT_ID AND
				SR.STORE_LOCATION = SL.LOCATION_ID AND
				ISNULL(SL.IS_SCRAP,0)=1
		UNION ALL
			SELECT
				0 AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				0 AS RESERVED_STOCK,
				0 AS PURCHASE_PROD_STOCK,
				0 AS RESERVED_PROD_STOCK,
				0 AS RESERVE_SALE_ORDER_STOCK,
				(SR.STOCK_IN - SR.STOCK_OUT) AS NOSALE_STOCK,
				0 AS BELONGTO_INSTITUTION_STOCK,
				0 AS RESERVE_PURCHASE_ORDER_STOCK,
				0 AS PRODUCTION_ORDER_STOCK,
				0 AS NOSALE_RESERVED_STOCK,
				SR.STOCK_ID,
				SR.PRODUCT_ID,
				SR.STORE AS DEPARTMENT_ID,
				SR.STORE_LOCATION AS LOCATION_ID
			FROM
				#new_dsn#.STOCKS_LOCATION SL,
				STOCKS_ROW SR  
			WHERE
				SR.STORE =SL.DEPARTMENT_ID
				AND SR.STORE_LOCATION=SL.LOCATION_ID
				AND SL.NO_SALE =1
		UNION ALL
			SELECT
				0 AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				0 AS RESERVED_STOCK,
				0 AS PURCHASE_PROD_STOCK,
				0 AS RESERVED_PROD_STOCK,
				0 AS RESERVE_SALE_ORDER_STOCK,
				0 AS NOSALE_STOCK, 
				(SR.STOCK_IN - SR.STOCK_OUT) AS BELONGTO_INSTITUTION_STOCK,
				0 AS RESERVE_PURCHASE_ORDER_STOCK,
				0 AS PRODUCTION_ORDER_STOCK,
				0 AS NOSALE_RESERVED_STOCK,
				SR.STOCK_ID,
				SR.PRODUCT_ID,
				SR.STORE AS DEPARTMENT_ID,
				SR.STORE_LOCATION AS LOCATION_ID
			FROM
				#new_dsn#.STOCKS_LOCATION SL,
				STOCKS_ROW SR  
			WHERE
				SR.STORE =SL.DEPARTMENT_ID
				AND SR.STORE_LOCATION=SL.LOCATION_ID
				AND SL.BELONGTO_INSTITUTION =1
		UNION ALL
			SELECT
				0 AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				((RESERVE_STOCK_OUT-STOCK_OUT)*-1) AS RESERVED_STOCK,
				0 AS PURCHASE_PROD_STOCK,
				0 AS RESERVED_PROD_STOCK,
				(RESERVE_STOCK_OUT-STOCK_OUT) AS RESERVE_SALE_ORDER_STOCK,
				0 AS NOSALE_STOCK,
				0 AS BELONGTO_INSTITUTION_STOCK,
				(RESERVE_STOCK_IN-STOCK_IN) AS RESERVE_PURCHASE_ORDER_STOCK,
				0 AS PRODUCTION_ORDER_STOCK,
				0 AS NOSALE_RESERVED_STOCK,
				ORR.STOCK_ID,
				ORR.PRODUCT_ID,
				ORDS.DELIVER_DEPT_ID AS DEPARTMENT_ID,
				ORDS.LOCATION_ID AS LOCATION_ID
			FROM
				#NEW_DSN3#.GET_ORDER_ROW_RESERVED ORR  , 
				#NEW_DSN3#.ORDERS ORDS
			WHERE
				ORDS.RESERVED = 1 AND 
				ORDS.ORDER_STATUS = 1 AND	
				ORDS.DELIVER_DEPT_ID IS NOT NULL AND
				ORDS.LOCATION_ID IS NOT NULL AND
				ORR.ORDER_ID = ORDS.ORDER_ID AND 
				((RESERVE_STOCK_IN-STOCK_IN)>0 OR (RESERVE_STOCK_OUT-STOCK_OUT)>0)
		UNION ALL
			SELECT
				0 AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				(RESERVE_STOCK_IN-STOCK_IN) AS RESERVED_STOCK,
				0 AS PURCHASE_PROD_STOCK,
				0 AS RESERVED_PROD_STOCK,
				0 AS RESERVE_SALE_ORDER_STOCK,
				0 AS NOSALE_STOCK,
				0 AS BELONGTO_INSTITUTION_STOCK,
				0 AS RESERVE_PURCHASE_ORDER_STOCK,
				0 AS PRODUCTION_ORDER_STOCK,
				0 AS NOSALE_RESERVED_STOCK,
				ORR.STOCK_ID,
				ORR.PRODUCT_ID,
				ORDS.DELIVER_DEPT_ID AS DEPARTMENT_ID,
				ORDS.LOCATION_ID AS LOCATION_ID
			FROM
				#NEW_DSN3#.GET_ORDER_ROW_RESERVED ORR , 
				#NEW_DSN3#.ORDERS ORDS,
				#new_dsn#.STOCKS_LOCATION SL
			WHERE
				ORDS.RESERVED = 1 AND 
				ORDS.ORDER_STATUS = 1 AND
				ORDS.DELIVER_DEPT_ID=SL.DEPARTMENT_ID AND
				ORDS.LOCATION_ID=SL.LOCATION_ID AND
				SL.NO_SALE=0 AND
				ORDS.PURCHASE_SALES=0 AND
				ORDS.ORDER_ZONE=0 AND
				ORR.ORDER_ID = ORDS.ORDER_ID AND 
				(RESERVE_STOCK_IN-STOCK_IN)>0	
		UNION ALL
			SELECT
				0 AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				0 AS RESERVED_STOCK,
				0 AS PURCHASE_PROD_STOCK,
				0 AS RESERVED_PROD_STOCK,
				0 AS RESERVE_SALE_ORDER_STOCK,
				0 AS NOSALE_STOCK,
				0 AS BELONGTO_INSTITUTION_STOCK,
				0 AS RESERVE_PURCHASE_ORDER_STOCK,
				0 AS PRODUCTION_ORDER_STOCK,
				(RESERVE_STOCK_IN-STOCK_IN) AS NOSALE_RESERVED_STOCK,
				ORR.STOCK_ID,
				ORR.PRODUCT_ID,
				ORDS.DELIVER_DEPT_ID AS DEPARTMENT_ID,
				ORDS.LOCATION_ID AS LOCATION_ID
			FROM
				#NEW_DSN3#.GET_ORDER_ROW_RESERVED ORR , 
				#NEW_DSN3#.ORDERS ORDS,
				#new_dsn#.STOCKS_LOCATION SL
			WHERE
				ORDS.RESERVED = 1 AND 
				ORDS.ORDER_STATUS = 1 AND	
				ORDS.DELIVER_DEPT_ID IS NOT NULL AND
				ORDS.LOCATION_ID IS NOT NULL AND
				ORDS.DELIVER_DEPT_ID=SL.DEPARTMENT_ID AND
				ORDS.LOCATION_ID=SL.LOCATION_ID AND
				SL.NO_SALE=1 AND
				ORDS.PURCHASE_SALES=0 AND
				ORDS.ORDER_ZONE=0 AND
				ORR.ORDER_ID = ORDS.ORDER_ID AND 
				(RESERVE_STOCK_IN-STOCK_IN)>0
			UNION ALL
			SELECT
					0 AS REAL_STOCK,
					0 AS PRODUCT_STOCK,
					(STOCK_ARTIR-STOCK_AZALT) AS RESERVED_STOCK,
					STOCK_ARTIR AS PURCHASE_PROD_STOCK,
					STOCK_AZALT AS RESERVED_PROD_STOCK,
					0  AS RESERVE_SALE_ORDER_STOCK,
					0 AS NOSALE_STOCK,
					0 AS BELONGTO_INSTITUTION_STOCK,
					0  AS RESERVE_PURCHASE_ORDER_STOCK,
					(STOCK_ARTIR-STOCK_AZALT)  AS PRODUCTION_ORDER_STOCK,
					0 AS NOSALE_RESERVED_STOCK,
					GET_PRODUCTION_RESERVED_LOCATION.STOCK_ID,
					GET_PRODUCTION_RESERVED_LOCATION.PRODUCT_ID,
					GET_PRODUCTION_RESERVED_LOCATION.DEPARTMENT_ID,
					GET_PRODUCTION_RESERVED_LOCATION.LOCATION_ID
				FROM
					#NEW_DSN3#.GET_PRODUCTION_RESERVED_LOCATION 
		) T1
		GROUP BY
			PRODUCT_ID, 
			STOCK_ID,
			DEPARTMENT_ID,
			LOCATION_ID
	END
</cfquery>

<cfquery name="ADD_SP" datasource="#new_dsn2#">
CREATE PROCEDURE [SpGetStockStrategy]
        AS 
        SELECT XXX.* 
                INTO  ####TStocStrategy
                FROM 
                ####GetStockProfile gsp
                JOIN
                (
            
                    SELECT
                        PRODUCT_ID,
                        STOCK_ID,
                        SUM(MINIMUM_STOCK) AS MINIMUM_STOCK,
                        SUM(MAXIMUM_STOCK) AS MAXIMUM_STOCK,
                        SUM(REPEAT_STOCK_VALUE) AS REPEAT_STOCK_VALUE,
                        SUM(BLOCK_STOCK_VALUE) AS BLOCK_STOCK_VALUE,
                        1 AS STRATEGY_TYPE,
                        DEPARTMENT_ID,
                        PROVISION_TIME,
                        IS_LIVE_ORDER,
                        MINIMUM_ORDER_STOCK_VALUE,
                        MAXIMUM_ORDER_STOCK_VALUE,
                        STOCK_ACTION_ID
                    FROM
                    (
                        SELECT
                            TOTAL_AMOUNT AS MINIMUM_STOCK,
                            0 AS MAXIMUM_STOCK,
                            0 AS REPEAT_STOCK_VALUE,
                            0 AS BLOCK_STOCK_VALUE,
                            SS.PRODUCT_ID,
                            SS.STOCK_ID,
                            SS.DEPARTMENT_ID,
                            SS.PROVISION_TIME,
                            SS.IS_LIVE_ORDER,
                            SS.MINIMUM_ORDER_STOCK_VALUE,
                            SS.MAXIMUM_ORDER_STOCK_VALUE,
                            SS.STOCK_ACTION_ID
                        FROM
                            INVOICE_DAILY_SALES IDS,
                            #NEW_DSN3#.STOCK_STRATEGY SS 
                        WHERE
                            IDS.STOCK_ID=SS.STOCK_ID				
                            AND DATEDIFF(day,IDS.INVOICE_DATE, getdate()) <= MINIMUM_STOCK
                            AND SS.STRATEGY_TYPE=1
                    UNION ALL
                        SELECT
                            0 AS MINIMUM_STOCK,
                            TOTAL_AMOUNT AS MAXIMUM_STOCK,
                            0 AS REPEAT_STOCK_VALUE,
                            0 AS BLOCK_STOCK_VALUE,
                            SS.PRODUCT_ID,
                            SS.STOCK_ID,
                            SS.DEPARTMENT_ID,
                            SS.PROVISION_TIME,
                            SS.IS_LIVE_ORDER,
                            SS.MINIMUM_ORDER_STOCK_VALUE,
                            SS.MAXIMUM_ORDER_STOCK_VALUE,
                            SS.STOCK_ACTION_ID
                        FROM
                            INVOICE_DAILY_SALES IDS,
                            #NEW_DSN3#.STOCK_STRATEGY SS
                        WHERE
                            IDS.STOCK_ID=SS.STOCK_ID				
                            AND DATEDIFF(day,IDS.INVOICE_DATE, getdate()) <= MAXIMUM_STOCK
                            AND SS.STRATEGY_TYPE=1
                    UNION ALL
                        SELECT
                            0 AS MINIMUM_STOCK,
                            0 AS MAXIMUM_STOCK,
                            TOTAL_AMOUNT AS REPEAT_STOCK_VALUE,
                            0 AS BLOCK_STOCK_VALUE,
                            SS.PRODUCT_ID,
                            SS.STOCK_ID,
                            SS.DEPARTMENT_ID,
                            SS.PROVISION_TIME,
                            SS.IS_LIVE_ORDER,
                            SS.MINIMUM_ORDER_STOCK_VALUE,
                            SS.MAXIMUM_ORDER_STOCK_VALUE,
                            SS.STOCK_ACTION_ID
                        FROM
                            INVOICE_DAILY_SALES IDS,
                            #NEW_DSN3#.STOCK_STRATEGY SS
                        WHERE
                            IDS.STOCK_ID=SS.STOCK_ID				
                            AND DATEDIFF(day,IDS.INVOICE_DATE, getdate()) <= REPEAT_STOCK_VALUE
                            AND SS.STRATEGY_TYPE=1 
                    ) AS ALL_TABLE
                    GROUP BY 
                        PRODUCT_ID,
                        STOCK_ID,
                        DEPARTMENT_ID,
                        PROVISION_TIME,
                        IS_LIVE_ORDER,
                        MINIMUM_ORDER_STOCK_VALUE,
                        MAXIMUM_ORDER_STOCK_VALUE,
                        STOCK_ACTION_ID
                UNION ALL
    
                    SELECT
                        PRODUCT_ID,
                        STOCK_ID,
                        MINIMUM_STOCK,
                        MAXIMUM_STOCK,
                        REPEAT_STOCK_VALUE,
                        BLOCK_STOCK_VALUE,
                        STRATEGY_TYPE,
                        DEPARTMENT_ID,
                        PROVISION_TIME,
                        IS_LIVE_ORDER,
                        MINIMUM_ORDER_STOCK_VALUE,
                        MAXIMUM_ORDER_STOCK_VALUE,
                        STOCK_ACTION_ID
                    FROM
                        #NEW_DSN3#.STOCK_STRATEGY SS
                    WHERE
                        STRATEGY_TYPE=0	
                ) AS xxx ON gsp.STOCK_ID = XXX.STOCK_ID
</cfquery>

<cfquery name="ADD_SP" datasource="#new_dsn2#">
CREATE PROCEDURE [SpGetStoctProfile]
                AS 
                    BEGIN
                        
                        SELECT 
                            SUM(REAL_STOCK) REAL_STOCK,
                            SUM(PRODUCT_STOCK) PRODUCT_STOCK,
                            SUM(RESERVED_STOCK) RESERVED_STOCK,
                            SUM(PURCHASE_PROD_STOCK) PURCHASE_PROD_STOCK,
                            SUM(RESERVED_PROD_STOCK) RESERVED_PROD_STOCK,
                            SUM(PRODUCT_STOCK+RESERVED_STOCK) SALEABLE_STOCK,
                            SUM(RESERVE_SALE_ORDER_STOCK) RESERVE_SALE_ORDER_STOCK,
                            SUM(NOSALE_STOCK) NOSALE_STOCK,
                            SUM(BELONGTO_INSTITUTION_STOCK) BELONGTO_INSTITUTION_STOCK,
                            SUM(RESERVE_PURCHASE_ORDER_STOCK) RESERVE_PURCHASE_ORDER_STOCK,
                            SUM(PRODUCTION_ORDER_STOCK) PRODUCTION_ORDER_STOCK,
                            SUM(NOSALE_RESERVED_STOCK) AS NOSALE_RESERVED_STOCK,
                            T1.PRODUCT_ID, 
                            T1.STOCK_ID
                        INTO ####TStockProfile
                        FROM
                        (
                            SELECT
                                (SR.STOCK_IN - SR.STOCK_OUT) AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                0 AS RESERVED_STOCK,
                                0 AS PURCHASE_PROD_STOCK,
                                0 AS RESERVED_PROD_STOCK,
                                0 AS RESERVE_SALE_ORDER_STOCK,
                                0 AS NOSALE_STOCK, 
                                0 AS BELONGTO_INSTITUTION_STOCK,
                                0 AS RESERVE_PURCHASE_ORDER_STOCK,
                                0 AS PRODUCTION_ORDER_STOCK,
                                0 AS NOSALE_RESERVED_STOCK,
                                SR.STOCK_ID,
                                SR.PRODUCT_ID
                            FROM
                                STOCKS_ROW SR
                                JOIN ####GetStockProfile GSP ON SR.STOCK_ID = GSP.STOCK_ID 
                            UNION ALL			
                                SELECT
                                    0 AS REAL_STOCK,
                                    (SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,
                                    0 AS RESERVED_STOCK,
                                    0 AS PURCHASE_PROD_STOCK,
                                    0 AS RESERVED_PROD_STOCK,
                                    0 AS RESERVE_SALE_ORDER_STOCK,
                                    0 AS NOSALE_STOCK, 
                                    0 AS BELONGTO_INSTITUTION_STOCK,
                                    0 AS RESERVE_PURCHASE_ORDER_STOCK,
                                    0 AS PRODUCTION_ORDER_STOCK,
                                    0 AS NOSALE_RESERVED_STOCK,
                                    SR.STOCK_ID,
                                    SR.PRODUCT_ID
                                FROM
                                    #new_dsn#.STOCKS_LOCATION SL,
                                    STOCKS_ROW SR
                                    JOIN ####GetStockProfile GSP ON SR.STOCK_ID = GSP.STOCK_ID 
                                WHERE
                                    SR.STORE =SL.DEPARTMENT_ID
                                    AND SR.STORE_LOCATION=SL.LOCATION_ID
                                    AND SL.NO_SALE = 0
                            UNION ALL
                                SELECT
                                    0 AS REAL_STOCK,
                                    -1*(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,
                                    0 AS RESERVED_STOCK,
                                    0 AS PURCHASE_PROD_STOCK,
                                    0 AS RESERVED_PROD_STOCK,
                                    0 AS RESERVE_SALE_ORDER_STOCK,
                                    0 AS NOSALE_STOCK, 
                                    0 AS BELONGTO_INSTITUTION_STOCK,
                                    0 AS RESERVE_PURCHASE_ORDER_STOCK,

                                    0 AS PRODUCTION_ORDER_STOCK,
                                    0 AS NOSALE_RESERVED_STOCK,
                                    SR.STOCK_ID,
                                    SR.PRODUCT_ID
                                FROM
                                    STOCKS_ROW SR JOIN ####GetStockProfile GSP ON SR.STOCK_ID = GSP.STOCK_ID  ,
                                    #new_dsn#.STOCKS_LOCATION SL 
                                WHERE	
                                    SR.STORE = SL.DEPARTMENT_ID AND
                                    SR.STORE_LOCATION = SL.LOCATION_ID AND
                                    ISNULL(SL.IS_SCRAP,0)=1
                            UNION ALL			
                                SELECT
                                    0 AS REAL_STOCK,
                                    0 AS PRODUCT_STOCK,
                                    0 AS RESERVED_STOCK,
                                    0 AS PURCHASE_PROD_STOCK,
                                    0 AS RESERVED_PROD_STOCK,
                                    0 AS RESERVE_SALE_ORDER_STOCK,
                                    (SR.STOCK_IN - SR.STOCK_OUT) AS NOSALE_STOCK,
                                    0 AS BELONGTO_INSTITUTION_STOCK,
                                    0 AS RESERVE_PURCHASE_ORDER_STOCK,
                                    0 AS PRODUCTION_ORDER_STOCK,
                                    0 AS NOSALE_RESERVED_STOCK,
                                    SR.STOCK_ID,
                                    SR.PRODUCT_ID
                                FROM
                                    #new_dsn#.STOCKS_LOCATION SL,
                                    STOCKS_ROW SR JOIN ####GetStockProfile GSP ON SR.STOCK_ID = GSP.STOCK_ID 
                                WHERE
                                    SR.STORE =SL.DEPARTMENT_ID
                                    AND SR.STORE_LOCATION=SL.LOCATION_ID
                                    AND SL.NO_SALE =1
                            UNION ALL
                                SELECT
                                    0 AS REAL_STOCK,
                                    0 AS PRODUCT_STOCK,
                                    0 AS RESERVED_STOCK,
                                    0 AS PURCHASE_PROD_STOCK,
                                    0 AS RESERVED_PROD_STOCK,
                                    0 AS RESERVE_SALE_ORDER_STOCK,
                                    0 AS NOSALE_STOCK, 
                                    (SR.STOCK_IN - SR.STOCK_OUT) AS BELONGTO_INSTITUTION_STOCK,
                                    0 AS RESERVE_PURCHASE_ORDER_STOCK,
                                    0 AS PRODUCTION_ORDER_STOCK,
                                    0 AS NOSALE_RESERVED_STOCK,
                                    SR.STOCK_ID,
                                    SR.PRODUCT_ID
                                FROM
                                    #new_dsn#.STOCKS_LOCATION SL,
                                    STOCKS_ROW SR JOIN ####GetStockProfile GSP ON SR.STOCK_ID = GSP.STOCK_ID 
                                WHERE
                                    SR.STORE =SL.DEPARTMENT_ID
                                    AND SR.STORE_LOCATION=SL.LOCATION_ID
                                    AND SL.BELONGTO_INSTITUTION =1
                            UNION ALL			
                                SELECT
                                    0 AS REAL_STOCK,
                                    0 AS PRODUCT_STOCK,
                                    ((RESERVE_STOCK_OUT-STOCK_OUT)*-1) AS RESERVED_STOCK,
                                    0 AS PURCHASE_PROD_STOCK,
                                    0 AS RESERVED_PROD_STOCK,
                                    (RESERVE_STOCK_OUT-STOCK_OUT) AS RESERVE_SALE_ORDER_STOCK,
                                    0 AS NOSALE_STOCK,
                                    0 AS BELONGTO_INSTITUTION_STOCK,
                                    (RESERVE_STOCK_IN-STOCK_IN) AS RESERVE_PURCHASE_ORDER_STOCK,
                                    0 AS PRODUCTION_ORDER_STOCK,
                                    0 AS NOSALE_RESERVED_STOCK,
                                    ORR.STOCK_ID,
                                    ORR.PRODUCT_ID
                                FROM
                                    #NEW_DSN3#.GET_ORDER_ROW_RESERVED ORR JOIN ####GetStockProfile GSP ON ORR.STOCK_ID = GSP.STOCK_ID , 
                                    #NEW_DSN3#.ORDERS ORDS
                                WHERE
                                    ORDS.RESERVED = 1 AND 
                                    ORDS.ORDER_STATUS = 1 AND	
                                    ORR.ORDER_ID = ORDS.ORDER_ID AND
                                    ((RESERVE_STOCK_IN-STOCK_IN)>0 OR (RESERVE_STOCK_OUT-STOCK_OUT)>0)	
                            UNION ALL			
                                SELECT
                                    0 AS REAL_STOCK,
                                    0 AS PRODUCT_STOCK,
                                    (RESERVE_STOCK_IN-STOCK_IN) AS RESERVED_STOCK,
                                    0 AS PURCHASE_PROD_STOCK,
                                    0 AS RESERVED_PROD_STOCK,
                                    0 AS RESERVE_SALE_ORDER_STOCK,
                                    0 AS NOSALE_STOCK,
                                    0 AS BELONGTO_INSTITUTION_STOCK,
                                    0 AS RESERVE_PURCHASE_ORDER_STOCK,
                                    0 AS PRODUCTION_ORDER_STOCK,
                                    0 AS NOSALE_RESERVED_STOCK,
                                    ORR.STOCK_ID,
                                    ORR.PRODUCT_ID
                                FROM
                                    #new_dsn#.STOCKS_LOCATION SL,
                                    #NEW_DSN3#.GET_ORDER_ROW_RESERVED ORR JOIN ####GetStockProfile GSP ON ORR.STOCK_ID = GSP.STOCK_ID , 
                                    #NEW_DSN3#.ORDERS ORDS
                                WHERE
                                    ORDS.DELIVER_DEPT_ID=SL.DEPARTMENT_ID AND
                                    ORDS.LOCATION_ID=SL.LOCATION_ID AND
                                    SL.NO_SALE = 0 AND
                                    ORDS.PURCHASE_SALES=0 AND
                                    ORDS.ORDER_ZONE=0 AND
                                    ORDS.RESERVED = 1 AND 
                                    ORDS.ORDER_STATUS = 1 AND	
                                    ORR.ORDER_ID = ORDS.ORDER_ID AND
                                    (RESERVE_STOCK_IN-STOCK_IN)>0
                            UNION ALL			
                                SELECT
                                    0 AS REAL_STOCK,
                                    0 AS PRODUCT_STOCK,
                                    0 AS RESERVED_STOCK,
                                    0 AS PURCHASE_PROD_STOCK,
                                    0 AS RESERVED_PROD_STOCK,
                                    0 AS RESERVE_SALE_ORDER_STOCK,
                                    0 AS NOSALE_STOCK,
                                    0 AS BELONGTO_INSTITUTION_STOCK,
                                    0 AS RESERVE_PURCHASE_ORDER_STOCK,
                                    0 AS PRODUCTION_ORDER_STOCK,
                                    (RESERVE_STOCK_IN-STOCK_IN) AS NOSALE_RESERVED_STOCK,
                                    ORR.STOCK_ID,
                                    ORR.PRODUCT_ID
                                FROM
                                    #new_dsn#.STOCKS_LOCATION SL,
                                    #NEW_DSN3#.GET_ORDER_ROW_RESERVED ORR JOIN ####GetStockProfile GSP ON ORR.STOCK_ID = GSP.STOCK_ID , 
                                    #NEW_DSN3#.ORDERS ORDS
                                WHERE
                                    ORDS.DELIVER_DEPT_ID=SL.DEPARTMENT_ID AND
                                    ORDS.LOCATION_ID=SL.LOCATION_ID AND
                                    SL.NO_SALE = 1 AND
                                    ORDS.PURCHASE_SALES=0 AND
                                    ORDS.ORDER_ZONE=0 AND
                                    ORDS.RESERVED = 1 AND 
                                    ORDS.ORDER_STATUS = 1 AND	
                                    ORR.ORDER_ID = ORDS.ORDER_ID AND
                                    (RESERVE_STOCK_IN-STOCK_IN)>0
                            UNION ALL			
                                SELECT
                                    0 AS REAL_STOCK,
                                    0 AS PRODUCT_STOCK,
                                    ((RESERVE_STOCK_IN-STOCK_IN) + ((RESERVE_STOCK_OUT-STOCK_OUT)*-1)) AS RESERVED_STOCK,
                                    0 AS PURCHASE_PROD_STOCK,
                                    0 AS RESERVED_PROD_STOCK,
                                    (RESERVE_STOCK_OUT-STOCK_OUT) AS RESERVE_SALE_ORDER_STOCK,
                                    0 AS NOSALE_STOCK,
                                    0 AS BELONGTO_INSTITUTION_STOCK,
                                    (RESERVE_STOCK_IN-STOCK_IN) AS RESERVE_PURCHASE_ORDER_STOCK,
                                    0 AS PRODUCTION_ORDER_STOCK,
                                    0 AS NOSALE_RESERVED_STOCK,
                                    ORR.STOCK_ID,
                                    ORR.PRODUCT_ID
                                FROM
                                    #NEW_DSN3#.ORDER_ROW_RESERVED  ORR JOIN ####GetStockProfile GSP ON ORR.STOCK_ID = GSP.STOCK_ID 
                                WHERE
                                    ORDER_ID IS NULL
                                    AND SHIP_ID IS NULL
                                    AND INVOICE_ID IS NULL
                            UNION ALL
                                SELECT
                                    0 AS REAL_STOCK,
                                    0 AS PRODUCT_STOCK,
                                    (STOCK_ARTIR-STOCK_AZALT) AS RESERVED_STOCK,
                                    STOCK_ARTIR AS PURCHASE_PROD_STOCK,
                                    STOCK_AZALT AS RESERVED_PROD_STOCK,
                                    0  AS RESERVE_SALE_ORDER_STOCK,
                                    0 AS NOSALE_STOCK,
                                    0 AS BELONGTO_INSTITUTION_STOCK,
                                    0  AS RESERVE_PURCHASE_ORDER_STOCK,
                                    (STOCK_ARTIR-STOCK_AZALT)  AS PRODUCTION_ORDER_STOCK,
                                    0 AS NOSALE_RESERVED_STOCK,
                                    GSP.STOCK_ID,
                                    GSP.PRODUCT_ID
                                FROM
                                    #NEW_DSN3#.GET_PRODUCTION_RESERVED JOIN ####GetStockProfile GSP ON GET_PRODUCTION_RESERVED.STOCK_ID = GSP.STOCK_ID  
                        ) T1 
                        GROUP BY
                            t1.PRODUCT_ID, 
                            t1.STOCK_ID
                END
</cfquery>


<cfquery name="ADD_SP" datasource="#new_dsn2#">
CREATE PROCEDURE [UPD_SHIP_COST]
            @aktarim_is_location_based_cost bit,
            @is_prod_cost_type bit
        AS
        BEGIN
        
            SET NOCOUNT ON;
             IF ( @aktarim_is_location_based_cost = 1  and @is_prod_cost_type = 0 )
                 BEGIN
                      UPDATE
                                SHIP_ROW
                                SET
                                    COST_PRICE=ISNULL(XXX.p1,0),            
                                    EXTRA_COST=ISNULL((XXX.r1),0)
                                            
                                FROM 

                                    SHIP_ROW
                                OUTER APPLY 
                                    (
                                        SELECT
                                                    TOP 1 
                                              
                                                             ROUND((PURCHASE_NET_SYSTEM_LOCATION),4) AS p1
                                                            ,ROUND((PURCHASE_EXTRA_COST_SYSTEM_LOCATION),4) AS r1
                                                
                                                    FROM 
                                                        #NEW_DSN3#.PRODUCT_COST GPCP
                                                    WHERE
                                                            GPCP.START_DATE <= (SELECT INV.SHIP_DATE FROM SHIP INV WHERE INV.SHIP_ID = SHIP_ROW.SHIP_ID)
                                                            AND GPCP.PRODUCT_ID = SHIP_ROW.PRODUCT_ID
                                                            AND ISNULL(GPCP.SPECT_MAIN_ID,0)=ISNULL((SELECT S.SPECT_MAIN_ID FROM #NEW_DSN3#.SPECTS S WHERE S.SPECT_VAR_ID = SHIP_ROW.SPECT_VAR_ID),0)
                                                            AND GPCP.LOCATION_ID = (SELECT II.LOCATION FROM SHIP II WHERE II.SHIP_ID = SHIP_ROW.SHIP_ID)
                                                            AND GPCP.DEPARTMENT_ID = (SELECT II.DELIVER_STORE_ID FROM SHIP II WHERE II.SHIP_ID = SHIP_ROW.SHIP_ID)
                                                   ORDER BY GPCP.START_DATE DESC,GPCP.RECORD_DATE DESC,GPCP.PRODUCT_COST_ID DESC
                                    ) AS XXX
                                JOIN
                                    ####GET_INVOICE GET_INVOICE ON SHIP_ROW.SHIP_ID = GET_INVOICE.ACTION_ID AND GET_INVOICE.SHIP_TYPE_NEW=81
            
                END
            ELSE
                IF (@aktarim_is_location_based_cost = 0  and @is_prod_cost_type = 0)
                    BEGIN
                          UPDATE
                                SHIP_ROW
                            SET
                                COST_PRICE=ISNULL(XXX.p1,0),            
                                EXTRA_COST=ISNULL((XXX.r1),0)
                                            
                            FROM 
                                SHIP_ROW
                            OUTER APPLY 
                                (
                                    SELECT
                                                TOP 1 
                                                    ROUND((PURCHASE_NET_SYSTEM),4) AS p1,
                                                    ROUND((PURCHASE_EXTRA_COST_SYSTEM),4) AS r1
                                                FROM 
                                                    #NEW_DSN3#.PRODUCT_COST GPCP
                                                WHERE
                                                    GPCP.START_DATE <= (SELECT INV.SHIP_DATE FROM SHIP INV WHERE INV.SHIP_ID = SHIP_ROW.SHIP_ID)
                                                    AND GPCP.PRODUCT_ID = SHIP_ROW.PRODUCT_ID
                                                    AND ISNULL(GPCP.SPECT_MAIN_ID,0)=ISNULL((SELECT S.SPECT_MAIN_ID FROM #NEW_DSN3#.SPECTS S WHERE S.SPECT_VAR_ID = SHIP_ROW.SPECT_VAR_ID),0)
                                                ORDER BY 
                                                    GPCP.START_DATE DESC,
                                                    GPCP.RECORD_DATE DESC,
                                                    GPCP.PRODUCT_COST_ID DESC
                                ) AS XXX
                            JOIN
                                ####GET_INVOICE GET_INVOICE ON SHIP_ROW.SHIP_ID = GET_INVOICE.ACTION_ID AND GET_INVOICE.SHIP_TYPE_NEW=81
                    END
        
                    ELSE
                        IF (@aktarim_is_location_based_cost = 1  and @is_prod_cost_type =1 )
                            BEGIN
                                  UPDATE
                                        SHIP_ROW
                                        SET
                                            COST_PRICE=ISNULL(XXX.p1,0),            
                                            EXTRA_COST=ISNULL((XXX.r1),0)
                                            
                                        FROM 
                                            SHIP_ROW
                                        OUTER APPLY 
                                            (
                                                SELECT
                                                            TOP 1 
                                                                    ROUND((PURCHASE_NET_SYSTEM_LOCATION),4) AS p1
                                                                   ,ROUND((PURCHASE_EXTRA_COST_SYSTEM_LOCATION),4) AS r1
        
                                                            FROM 
                                                                #NEW_DSN3#.PRODUCT_COST GPCP
                                                            WHERE
                                                                GPCP.START_DATE <= (SELECT INV.SHIP_DATE FROM SHIP INV WHERE INV.SHIP_ID = SHIP_ROW.SHIP_ID)
                                                                AND GPCP.PRODUCT_ID = SHIP_ROW.PRODUCT_ID
                                                                AND GPCP.LOCATION_ID = (SELECT II.LOCATION FROM SHIP II WHERE II.SHIP_ID = SHIP_ROW.SHIP_ID)
                                                                AND GPCP.DEPARTMENT_ID = (SELECT II.DELIVER_STORE_ID FROM SHIP II WHERE II.SHIP_ID = SHIP_ROW.SHIP_ID)
                                                            ORDER BY 
                                                                GPCP.START_DATE DESC,
                                                                GPCP.RECORD_DATE DESC,
                                                                GPCP.PRODUCT_COST_ID DESC
                                            ) AS XXX
                                        JOIN
                                            ####GET_INVOICE GET_INVOICE ON SHIP_ROW.SHIP_ID = GET_INVOICE.ACTION_ID AND GET_INVOICE.SHIP_TYPE_NEW=81
                            END
        
                        ELSE
                            IF (@aktarim_is_location_based_cost = 0  and @is_prod_cost_type = 1 )
                            BEGIN
                                  UPDATE
        
                                        SHIP_ROW
                                        SET
                                            COST_PRICE=ISNULL(XXX.p1,0),            
                                            EXTRA_COST=ISNULL((XXX.r1),0)
                                            
                                        FROM 
                                            SHIP_ROW
                                        OUTER APPLY 
                                            (
                                                SELECT
                                                            TOP 1 
                                                                    ROUND((PURCHASE_NET_SYSTEM),4) AS p1
                                                                    ,ROUND((PURCHASE_EXTRA_COST_SYSTEM),4) AS r1
                                                            FROM 
                                                                #NEW_DSN3#.PRODUCT_COST GPCP
                                                            WHERE
                                                                GPCP.START_DATE <= (SELECT INV.SHIP_DATE FROM SHIP INV WHERE INV.SHIP_ID = SHIP_ROW.SHIP_ID)
                                                                AND GPCP.PRODUCT_ID = SHIP_ROW.PRODUCT_ID
                                                            ORDER BY GPCP.START_DATE DESC,GPCP.RECORD_DATE DESC,GPCP.PRODUCT_COST_ID DESC
                                            ) AS XXX
                                        JOIN
                                            ####GET_INVOICE GET_INVOICE ON SHIP_ROW.SHIP_ID = GET_INVOICE.ACTION_ID AND GET_INVOICE.SHIP_TYPE_NEW=81
                            END
                            ELSE
                     IF ( @aktarim_is_location_based_cost = 2  and @is_prod_cost_type = 0 )
                         BEGIN
                              UPDATE
                                        SHIP_ROW
                                        SET
                                            COST_PRICE=ISNULL(XXX.p1,0),            
                                            EXTRA_COST=ISNULL((XXX.r1),0)
                                                    
                                        FROM 
        
                                            SHIP_ROW
                                        OUTER APPLY 
                                            (
                                                SELECT
                                                            TOP 1 
                                                      
                                                                     ROUND((PURCHASE_NET_SYSTEM_DEPARTMENT),4) AS p1
                                                                    ,ROUND((PURCHASE_EXTRA_COST_SYSTEM_DEPARTMENT),4) AS r1
                                                        
                                                            FROM 
                                                                #NEW_DSN3#.PRODUCT_COST GPCP
                                                            WHERE
                                                                    GPCP.START_DATE <= (SELECT INV.SHIP_DATE FROM SHIP INV WHERE INV.SHIP_ID = SHIP_ROW.SHIP_ID)
                                                                    AND GPCP.PRODUCT_ID = SHIP_ROW.PRODUCT_ID
                                                                    AND ISNULL(GPCP.SPECT_MAIN_ID,0)=ISNULL((SELECT S.SPECT_MAIN_ID FROM workcube_cf_1.SPECTS S WHERE S.SPECT_VAR_ID = SHIP_ROW.SPECT_VAR_ID),0)
                                                                    AND GPCP.DEPARTMENT_ID = (SELECT II.DELIVER_STORE_ID FROM SHIP II WHERE II.SHIP_ID = SHIP_ROW.SHIP_ID)
                                                           ORDER BY GPCP.START_DATE DESC,GPCP.RECORD_DATE DESC,GPCP.PRODUCT_COST_ID DESC
                                            ) AS XXX
                                        JOIN
                                            ####GET_INVOICE GET_INVOICE ON SHIP_ROW.SHIP_ID = GET_INVOICE.ACTION_ID AND GET_INVOICE.SHIP_TYPE_NEW=81
                    
                        END
                    ELSE
                        IF (@aktarim_is_location_based_cost = 2  and @is_prod_cost_type =1 )
                            BEGIN
                                    UPDATE
                                        SHIP_ROW
                                        SET
                                            COST_PRICE=ISNULL(XXX.p1,0),            
                                            EXTRA_COST=ISNULL((XXX.r1),0)
                                                    
                                        FROM 
                                            SHIP_ROW
                                        OUTER APPLY 
                                            (
                                                SELECT
                                                            TOP 1 
                                                                    ROUND((PURCHASE_NET_SYSTEM_DEPARTMENT),4) AS p1
                                                                    ,ROUND((PURCHASE_EXTRA_COST_SYSTEM_DEPARTMENT),4) AS r1
                
                                                            FROM 
                                                                #NEW_DSN3#.PRODUCT_COST GPCP
                                                            WHERE
                                                                GPCP.START_DATE <= (SELECT INV.SHIP_DATE FROM SHIP INV WHERE INV.SHIP_ID = SHIP_ROW.SHIP_ID)
                                                                AND GPCP.PRODUCT_ID = SHIP_ROW.PRODUCT_ID
                                                                AND GPCP.DEPARTMENT_ID = (SELECT II.DELIVER_STORE_ID FROM SHIP II WHERE II.SHIP_ID = SHIP_ROW.SHIP_ID)
                                                            ORDER BY 
                                                                GPCP.START_DATE DESC,
                                                                GPCP.RECORD_DATE DESC,
                                                                GPCP.PRODUCT_COST_ID DESC
                                            ) AS XXX
                                        JOIN
                                            ####GET_INVOICE GET_INVOICE ON SHIP_ROW.SHIP_ID = GET_INVOICE.ACTION_ID AND GET_INVOICE.SHIP_TYPE_NEW=81
                            END
        
        END
</cfquery>

<!---views--->

    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_PRODUCT_COST_PERIOD] AS
		SELECT      
			PRODUCT_COST.PRODUCT_COST_ID,
            PRODUCT_COST.PROCESS_STAGE,
            PRODUCT_COST.PRODUCT_ID,
            PRODUCT_COST.UNIT_ID,
            PRODUCT_COST.IS_SPEC,
            PRODUCT_COST.SPECT_MAIN_ID,
            PRODUCT_COST.PRODUCT_COST_STATUS,
            PRODUCT_COST.INVENTORY_CALC_TYPE,
            PRODUCT_COST.START_DATE,
            PRODUCT_COST.COST_TYPE_ID,
            PRODUCT_COST.PRODUCT_COST,
            PRODUCT_COST.MONEY,
            PRODUCT_COST.STANDARD_COST,
            PRODUCT_COST.STANDARD_COST_MONEY,
            PRODUCT_COST.STANDARD_COST_RATE,
            PRODUCT_COST.PURCHASE_NET,
            PRODUCT_COST.PURCHASE_NET_MONEY,
            PRODUCT_COST.PURCHASE_EXTRA_COST,
            PRODUCT_COST.PRICE_PROTECTION,
            PRODUCT_COST.PRICE_PROTECTION_MONEY,
            PRODUCT_COST.PRICE_PROTECTION_TYPE,
            PRODUCT_COST.PURCHASE_NET_SYSTEM_ALL PURCHASE_NET_SYSTEM,
            PRODUCT_COST.PURCHASE_NET_SYSTEM_MONEY,
            PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM,
            PRODUCT_COST.PRODUCT_COST_SYSTEM,
            PRODUCT_COST.PURCHASE_NET_SYSTEM_2_ALL PURCHASE_NET_SYSTEM_2,
            PRODUCT_COST.PURCHASE_NET_SYSTEM_MONEY_2,
            PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM_2,
            PRODUCT_COST.AVAILABLE_STOCK,
            PRODUCT_COST.PARTNER_STOCK,
            PRODUCT_COST.ACTIVE_STOCK,
            PRODUCT_COST.IS_STANDARD_COST,
            PRODUCT_COST.IS_ACTIVE_STOCK,
            PRODUCT_COST.IS_PARTNER_STOCK,
            PRODUCT_COST.COST_DESCRIPTION,
            PRODUCT_COST.ACTION_PROCESS_TYPE,
            PRODUCT_COST.ACTION_PROCESS_CAT_ID,
            PRODUCT_COST.ACTION_ID,
            PRODUCT_COST.ACTION_ROW_ID,
            PRODUCT_COST.ACTION_ROW_PRICE,
            PRODUCT_COST.ACTION_TYPE,
            PRODUCT_COST.ACTION_PERIOD_ID,
            PRODUCT_COST.ACTION_AMOUNT,
            PRODUCT_COST.ACTION_DATE,
            PRODUCT_COST.ACTION_DUE_DATE,
            PRODUCT_COST.DEPARTMENT_ID,
            PRODUCT_COST.LOCATION_ID,
            PRODUCT_COST.PRODUCT_COST_LOCATION,
            PRODUCT_COST.MONEY_LOCATION,
            PRODUCT_COST.STANDARD_COST_LOCATION,
            PRODUCT_COST.STANDARD_COST_MONEY_LOCATION,
            PRODUCT_COST.STANDARD_COST_RATE_LOCATION,
            PRODUCT_COST.PURCHASE_NET_LOCATION,
            PRODUCT_COST.PURCHASE_NET_MONEY_LOCATION,
            PRODUCT_COST.PURCHASE_EXTRA_COST_LOCATION,
            PRODUCT_COST.PRICE_PROTECTION_LOCATION,
            PRODUCT_COST.PRICE_PROTECTION_MONEY_LOCATION,
            PRODUCT_COST.PURCHASE_NET_SYSTEM_LOCATION,
            PRODUCT_COST.PURCHASE_NET_SYSTEM_MONEY_LOCATION,
            PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM_LOCATION,
            PRODUCT_COST.PURCHASE_NET_SYSTEM_2_LOCATION,
            PRODUCT_COST.PURCHASE_NET_SYSTEM_MONEY_2_LOCATION,
            PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION,
            PRODUCT_COST.AVAILABLE_STOCK_LOCATION,
            PRODUCT_COST.PARTNER_STOCK_LOCATION,
            PRODUCT_COST.ACTIVE_STOCK_LOCATION,
            PRODUCT_COST.IS_SEVK,
            PRODUCT_COST.RECORD_DATE,
            PRODUCT_COST.RECORD_EMP,
            PRODUCT_COST.RECORD_IP,
            PRODUCT_COST.UPDATE_DATE,
            PRODUCT_COST.UPDATE_EMP,
            PRODUCT_COST.UPDATE_IP,
            PRODUCT_COST.IS_SUGGEST,
            PRODUCT_COST.PRICE_PROTECTION_TOTAL,
            PRODUCT_COST.PRICE_PROTECTION_AMOUNT,
            PRODUCT_COST.DUE_DATE,
            PRODUCT_COST.DUE_DATE_LOCATION
		FROM   
			#new_prod_db#.PRODUCT_COST,
			#new_dsn#.SETUP_PERIOD
		WHERE
			#new_dsn#.SETUP_PERIOD.OUR_COMPANY_ID = #OUR_COMPANY_ID# AND 
			#new_prod_db#.PRODUCT_COST.ACTION_PERIOD_ID = #new_dsn#.SETUP_PERIOD.PERIOD_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_ALL_STOCKS_ROW_COST] AS
			SELECT 
				PRODUCT_ID,
				STOCK_ID,
				SPECT_VAR_ID,
                LOT_NO,
				ISNULL((SELECT
					TOP 1 (PURCHASE_NET_SYSTEM + PURCHASE_EXTRA_COST_SYSTEM)  
				FROM 
					GET_PRODUCT_COST_PERIOD
				WHERE
					GET_PRODUCT_COST_PERIOD.START_DATE <= STOCKS_ROW.PROCESS_DATE
					AND GET_PRODUCT_COST_PERIOD.PRODUCT_ID = STOCKS_ROW.PRODUCT_ID
					AND ISNULL(GET_PRODUCT_COST_PERIOD.SPECT_MAIN_ID,0)=ISNULL(STOCKS_ROW.SPECT_VAR_ID,0)
				ORDER BY
					GET_PRODUCT_COST_PERIOD.START_DATE DESC,
					GET_PRODUCT_COST_PERIOD.RECORD_DATE DESC,
					GET_PRODUCT_COST_PERIOD.PRODUCT_COST_ID DESC
					),0) AS NET_MALIYET,
				ISNULL((SELECT
					TOP 1 (PURCHASE_NET_SYSTEM_2 + PURCHASE_EXTRA_COST_SYSTEM_2)  
				FROM 
					GET_PRODUCT_COST_PERIOD
				WHERE
					GET_PRODUCT_COST_PERIOD.START_DATE <= STOCKS_ROW.PROCESS_DATE
					AND GET_PRODUCT_COST_PERIOD.PRODUCT_ID = STOCKS_ROW.PRODUCT_ID
					AND ISNULL(GET_PRODUCT_COST_PERIOD.SPECT_MAIN_ID,0)=ISNULL(STOCKS_ROW.SPECT_VAR_ID,0)
				ORDER BY 
					GET_PRODUCT_COST_PERIOD.START_DATE DESC,
					GET_PRODUCT_COST_PERIOD.RECORD_DATE DESC,
					GET_PRODUCT_COST_PERIOD.PRODUCT_COST_ID DESC
					),0) AS NET_MALIYET_2,
				STOCK_IN,
				STOCK_OUT,
				UPD_ID,
				PROCESS_DATE,
				PROCESS_TYPE,
				STORE,
				STORE_LOCATION
			FROM 
				STOCKS_ROW

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [DAILY_STOCKS] AS
			SELECT 
				(SUM(STOCK_IN-STOCK_OUT)*(SUM(NET_MALIYET)/COUNT(PRODUCT_ID)))  AS COST_TOTAL,
				(SUM(STOCK_IN-STOCK_OUT)*(SUM(NET_MALIYET_2)/COUNT(PRODUCT_ID)))  AS COST_OTHER_MONEY_TOTAL,
				SUM(STOCK_IN-STOCK_OUT) AS AMOUNT,
				PROCESS_DATE
			FROM
				GET_ALL_STOCKS_ROW_COST
			WHERE
				ISNUMERIC(UPD_ID) = 1
				AND PROCESS_TYPE <> 81
			GROUP BY
				PROCESS_DATE

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [DAILY_TOTAL_STOCKS] AS
			SELECT 
				D1.PROCESS_DATE,
				SUM(D2.AMOUNT) AMOUNT,
				SUM(D2.COST_TOTAL) COST_TOTAL,
				SUM(D2.COST_OTHER_MONEY_TOTAL) COST_OTHER_MONEY_TOTAL		  
			FROM
				DAILY_STOCKS D1,
				DAILY_STOCKS D2
			WHERE
				D1.PROCESS_DATE >= D2.PROCESS_DATE
			GROUP BY D1.PROCESS_DATE

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [DAILY_CREDIT] AS
		SELECT		
	
			SUM(INCOME_VALUE) INCOME_VALUE,
			SUM(EXPENSE_VALUE) EXPENSE_VALUE,
			SUM(INCOME_VALUE-EXPENSE_VALUE) AS BAKIYE,
			SUM(INCOME_OTHER_MONEY_VALUE) INCOME_OTHER_MONEY_VALUE,
			SUM(EXPENSE_OTHER_MONEY_VALUE) EXPENSE_OTHER_MONEY_VALUE,
			SUM(INCOME_OTHER_MONEY_VALUE-EXPENSE_OTHER_MONEY_VALUE) AS OTHER_BAKIYE,
			PROCESS_DATE
		FROM
		(	SELECT
				(TOTAL_PRICE* (CCP_M.RATE2 / CCP_M.RATE1)) AS INCOME_VALUE,
				0 AS EXPENSE_VALUE,
				( (TOTAL_PRICE* (CCP_M.RATE2 / CCP_M.RATE1)) / ISNULL(
				(SELECT
					(CPM.RATE2 / CPM.RATE1)
				FROM 
					CREDIT_CONTRACT_PAYMENT_INCOME_MONEY CPM,
					#new_dsn#.SETUP_PERIOD SET_PRD
				WHERE 
					SET_PRD.PERIOD_ID=#PERIOD_ID#
					<cfif get_periods.PERIOD_YEAR lt 2009>
					AND CPM.MONEY_TYPE=ISNULL(SET_PRD.OTHER_MONEY,'YTL')
					<cfelse>
					AND CPM.MONEY_TYPE=ISNULL(SET_PRD.OTHER_MONEY,'TL')
					</cfif>
					AND CPM.ACTION_ID=CCP.CREDIT_CONTRACT_PAYMENT_ID
				),1)) AS INCOME_OTHER_MONEY_VALUE,
				0 AS EXPENSE_OTHER_MONEY_VALUE,
				PROCESS_DATE				
			FROM
				CREDIT_CONTRACT_PAYMENT_INCOME CCP,
				CREDIT_CONTRACT_PAYMENT_INCOME_MONEY CCP_M
			WHERE
				CCP.CREDIT_CONTRACT_PAYMENT_ID=CCP_M.ACTION_ID
				AND CCP_M.MONEY_TYPE=CCP.ACTION_CURRENCY_ID
				AND CCP.PROCESS_TYPE = 292 
		UNION ALL
			SELECT
				0 AS INCOME_VALUE,
				(TOTAL_PRICE* (CCP_M.RATE2 / CCP_M.RATE1)) AS EXPENSE_VALUE,
				0 AS INCOME_OTHER_MONEY_VALUE,
				( (TOTAL_PRICE* (CCP_M.RATE2 / CCP_M.RATE1)) / ISNULL(
				(SELECT
					(CPM.RATE2 / CPM.RATE1)
				FROM 
					CREDIT_CONTRACT_PAYMENT_INCOME_MONEY CPM,
					#new_dsn#.SETUP_PERIOD SET_PRD
				WHERE 
					SET_PRD.PERIOD_ID=#PERIOD_ID#
					<cfif get_periods.PERIOD_YEAR lt 2009>
					AND CPM.MONEY_TYPE=ISNULL(SET_PRD.OTHER_MONEY,'YTL')
					<cfelse>
					AND CPM.MONEY_TYPE=ISNULL(SET_PRD.OTHER_MONEY,'TL')
					</cfif>
					AND CPM.ACTION_ID=CCP.CREDIT_CONTRACT_PAYMENT_ID
				),1)) AS EXPENSE_OTHER_MONEY_VALUE,
				PROCESS_DATE
			FROM
				CREDIT_CONTRACT_PAYMENT_INCOME CCP,
				CREDIT_CONTRACT_PAYMENT_INCOME_MONEY CCP_M
			WHERE
				CCP.CREDIT_CONTRACT_PAYMENT_ID=CCP_M.ACTION_ID
				AND CCP_M.MONEY_TYPE=CCP.ACTION_CURRENCY_ID
				AND CCP.PROCESS_TYPE = 291
		) AS C1
		GROUP BY PROCESS_DATE

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [DAILY_TOTAL_CREDIT] AS
		SELECT 
			DC_1.PROCESS_DATE,
			SUM(DC_2.INCOME_VALUE) INCOME_VALUE,
			SUM(DC_2.EXPENSE_VALUE) EXPENSE_VALUE,
			SUM(DC_2.BAKIYE) AS BAKIYE,
			SUM(DC_2.INCOME_OTHER_MONEY_VALUE) INCOME_OTHER_MONEY_VALUE,
			SUM(DC_2.EXPENSE_OTHER_MONEY_VALUE) EXPENSE_OTHER_MONEY_VALUE,
			SUM(DC_2.OTHER_BAKIYE) AS OTHER_BAKIYE
		FROM
			DAILY_CREDIT DC_1,
			DAILY_CREDIT DC_2
		WHERE
			DC_1.PROCESS_DATE >= DC_2.PROCESS_DATE
		GROUP BY DC_1.PROCESS_DATE

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [SETUP_MONEY] AS
        SELECT
            MONEY_ID, 
            MONEY, 
            RATE1,
            RATE2,
            MONEY_STATUS, 
            PERIOD_ID,
            COMPANY_ID, 
            ACCOUNT_950, 
            PER_ACCOUNT, 
            RATE3, 
            RECORD_DATE, 
            RECORD_EMP, 
            RECORD_IP, 
            UPDATE_DATE, 
            UPDATE_EMP, 
            UPDATE_IP, 
            RATEPP2, 
            RATEPP3, 
            RATEWW2,
            RATEWW3, 
            CURRENCY_CODE, 
            DSP_RATE_SALE, 
            DSP_RATE_PUR, 
            DSP_UPDATE_DATE, 
            EFFECTIVE_SALE, 
            EFFECTIVE_PUR,  
            DSP_EFFECTIVE_SALE, 
            DSP_EFFECTIVE_PUR, 
            MONEY_NAME, 
            MONEY_SYMBOL 
        FROM
           #new_dsn#.SETUP_MONEY
        WHERE
            PERIOD_ID=#PERIOD_ID#

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [DAILY_ACCOUNT_REMAINDER] AS
		SELECT	
			SUM(ALACAK) ALACAK,
			SUM(BORC) BORC,
			SUM(ALACAK_SYSTEM) ALACAK_SYSTEM,
			SUM(BORC_SYSTEM) BORC_SYSTEM,
			ACTION_CURRENCY_ID,
			ACCOUNT_ID,
			ACTION_DATE,
			ISNULL(	
				(SELECT
					TOP 1 (MNY_H.RATE2/MNY_H.RATE1) AS RATE
				FROM 
					#new_dsn#.MONEY_HISTORY MNY_H
				WHERE 
					MNY_H.PERIOD_ID=#PERIOD_ID#
					AND MNY_H.MONEY=ACTION_CURRENCY_ID
					AND MNY_H.VALIDATE_DATE <= ACR_1.ACTION_DATE
				ORDER BY MONEY_HISTORY_ID DESC),
			
				(SELECT
					(SM.RATE2/SM.RATE1) AS RATE
				FROM 
					SETUP_MONEY SM
				WHERE 
					SM.MONEY=ACTION_CURRENCY_ID
					)
				) AS ACTION_CURRENCY_RATE,
			ISNULL(	
				(SELECT
					TOP 1 (MNY_H.RATE2/MNY_H.RATE1) AS RATE
				FROM 
					#new_dsn#.MONEY_HISTORY MNY_H,
					#new_dsn#.SETUP_PERIOD SET_PRD
				WHERE 
					SET_PRD.PERIOD_ID=#PERIOD_ID#
					AND MNY_H.PERIOD_ID= SET_PRD.PERIOD_ID
					
					AND MNY_H.MONEY=ISNULL(SET_PRD.OTHER_MONEY,'TL')
					
					AND MNY_H.VALIDATE_DATE <= ACR_1.ACTION_DATE
				ORDER BY MONEY_HISTORY_ID DESC),
			
				(SELECT
					(SM.RATE2/SM.RATE1) AS RATE
				FROM 
					SETUP_MONEY SM,
					#new_dsn#.SETUP_PERIOD SET_PRD
				WHERE 
					SET_PRD.PERIOD_ID=#PERIOD_ID# 
					AND SM.MONEY=ISNULL(SET_PRD.OTHER_MONEY,'TL')
					
				)
			) AS OTHER_MONEY2_RATE
		FROM
			(
			SELECT     
				0 AS ALACAK, 
				0 AS ALACAK_SYSTEM, 
				BA.ACTION_VALUE AS BORC,
				BA.SYSTEM_ACTION_VALUE AS BORC_SYSTEM,
				BA.ACTION_CURRENCY_ID,		
				ACCOUNTS.ACCOUNT_ID,
				ACCOUNTS.ACCOUNT_NAME, 
				BA.ACTION_DATE
			FROM
				BANK_ACTIONS BA,
				#new_dsn3#.ACCOUNTS AS ACCOUNTS
			WHERE
				ACCOUNTS.ACCOUNT_ID = BA.ACTION_TO_ACCOUNT_ID 
				AND BA.ACTION_TYPE_ID <> 93
				
			UNION ALL
			SELECT 	
				BA.ACTION_VALUE AS ALACAK, 	
				BA.SYSTEM_ACTION_VALUE AS ALACAK_SYSTEM, 	
				0 AS BORC,
				0 AS BORC_SYSTEM,
				BA.ACTION_CURRENCY_ID,
				ACCOUNTS.ACCOUNT_ID,
				ACCOUNTS.ACCOUNT_NAME, 
				BA.ACTION_DATE
			FROM
				BANK_ACTIONS BA,
				#new_dsn3#.ACCOUNTS AS ACCOUNTS
			WHERE
				ACCOUNTS.ACCOUNT_ID = BA.ACTION_FROM_ACCOUNT_ID
				AND BA.ACTION_TYPE_ID <> 93
			) AS ACR_1
		GROUP BY 
			ACTION_CURRENCY_ID,
			ACCOUNT_ID,
			ACTION_DATE

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [DAILY_CASH_REMAINDER] AS
		SELECT	
			SUM(BORC) BORC,
			SUM(ALACAK) ALACAK,
			SUM(BORC_SYSTEM) BORC_SYSTEM,
			SUM(ALACAK_SYSTEM) ALACAK_SYSTEM,
			CASH_ACTION_CURRENCY_ID,
			ACTION_DATE,
			CASH_ID,
			ISNULL(	
				(SELECT
					TOP 1 (MNY_H.RATE2/MNY_H.RATE1) AS RATE
				FROM 
					#new_dsn#.MONEY_HISTORY MNY_H
				WHERE 
					MNY_H.PERIOD_ID=#PERIOD_ID#
					AND MNY_H.MONEY=CASH_ACTION_CURRENCY_ID
					AND MNY_H.VALIDATE_DATE< = C_1.ACTION_DATE
				ORDER BY MONEY_HISTORY_ID DESC),
			
				(SELECT
					(SM.RATE2/SM.RATE1) AS RATE
				FROM 
					SETUP_MONEY SM
				WHERE 
					SM.MONEY=CASH_ACTION_CURRENCY_ID
					)
				) AS ACTION_CURRENCY_RATE,
			ISNULL(	
				(SELECT
					TOP 1 (MNY_H.RATE2/MNY_H.RATE1) AS RATE
				FROM 
					#new_dsn#.MONEY_HISTORY MNY_H,
					#new_dsn#.SETUP_PERIOD SET_PRD
				WHERE 
					SET_PRD.PERIOD_ID=#PERIOD_ID#
					AND MNY_H.PERIOD_ID= SET_PRD.PERIOD_ID
					
					AND MNY_H.MONEY=ISNULL(SET_PRD.OTHER_MONEY,'TL')
					
					AND MNY_H.VALIDATE_DATE <= C_1.ACTION_DATE
				ORDER BY MONEY_HISTORY_ID DESC),
			
				(SELECT
					(SM.RATE2/SM.RATE1) AS RATE
				FROM 
					SETUP_MONEY SM,
					#new_dsn#.SETUP_PERIOD SET_PRD
				WHERE 
					SET_PRD.PERIOD_ID=#PERIOD_ID# 
					AND SM.MONEY=ISNULL(SET_PRD.OTHER_MONEY,'TL')
					
				)
				) AS OTHER_MONEY2_RATE
		
		FROM
			(
			SELECT
					0 AS BORC, 
					0 AS BORC_SYSTEM, 
					CA.CASH_ACTION_VALUE AS ALACAK, 
					CA.ACTION_VALUE AS ALACAK_SYSTEM, 
					CA.CASH_ACTION_CURRENCY_ID,
					CA.ACTION_DATE,
					CASH.CASH_ID
				FROM
					CASH_ACTIONS CA, 
					CASH
				WHERE
					CA.CASH_ACTION_FROM_CASH_ID = CASH.CASH_ID 
				
			UNION ALL
				SELECT
					CA.CASH_ACTION_VALUE AS BORC,
					CA.ACTION_VALUE AS BORC_SYSTEM,
					0 AS ALACAK,
					0 AS ALACAK_SYSTEM, 
					CA.CASH_ACTION_CURRENCY_ID,
					CA.ACTION_DATE,
					CASH.CASH_ID
				FROM
					CASH_ACTIONS CA, 
					CASH
				WHERE
					CA.CASH_ACTION_TO_CASH_ID = CASH.CASH_ID 
				
			) AS C_1
		GROUP BY
			CASH_ACTION_CURRENCY_ID,
			ACTION_DATE,
			CASH_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [DAILY_EFFECTIVE_MONEY] AS
		SELECT 
			SUM(BORC) BORC,
			SUM(ALACAK) ALACAK,
			SUM(BORC-ALACAK) BAKIYE,
			SUM(BORC2) BORC2,		
			SUM(ALACAK2) ALACAK2,
			SUM(BORC2-ALACAK2) BAKIYE2,
			ACTION_DATE
		FROM
			(
				SELECT
					(BORC*ACTION_CURRENCY_RATE) BORC,
					(ALACAK*ACTION_CURRENCY_RATE) ALACAK,
					((BORC*ACTION_CURRENCY_RATE)/OTHER_MONEY2_RATE) BORC2,
					((ALACAK*ACTION_CURRENCY_RATE)/OTHER_MONEY2_RATE) ALACAK2,
					ACTION_DATE
				FROM
					DAILY_CASH_REMAINDER
			UNION
				SELECT
					(BORC*ACTION_CURRENCY_RATE) BORC,
					(ALACAK*ACTION_CURRENCY_RATE) ALACAK,
					((BORC*ACTION_CURRENCY_RATE)/OTHER_MONEY2_RATE) BORC2,
					((ALACAK*ACTION_CURRENCY_RATE)/OTHER_MONEY2_RATE) ALACAK2,
					ACTION_DATE
				FROM
					DAILY_ACCOUNT_REMAINDER
			
			) AS A_1
		GROUP BY
			ACTION_DATE

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [DAILY_TOTAL_EFFECTIVE_MONEY] AS
		SELECT 
			DM_1.ACTION_DATE,
			SUM(DM_2.BORC) BORC,
			SUM(DM_2.BORC2) BORC2,
			SUM(DM_2.ALACAK) AS ALACAK,
			SUM(DM_2.ALACAK2) AS ALACAK2,
			SUM(DM_2.BORC-DM_2.ALACAK) BAKIYE,
			SUM(DM_2.BORC2-DM_2.ALACAK2) BAKIYE2
		FROM
			DAILY_EFFECTIVE_MONEY DM_1,
			DAILY_EFFECTIVE_MONEY DM_2
		WHERE
			DM_1.ACTION_DATE >= DM_2.ACTION_DATE
	
		GROUP BY DM_1.ACTION_DATE

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [DAILY_CARI_REMAINDER] AS 
		SELECT 
			SUM(BORC) BORC,
			SUM(BORC2) BORC2,
			SUM(ALACAK) ALACAK,
			SUM(ALACAK2) ALACAK2,
			SUM(BORC-ALACAK) BAKIYE,
			SUM(BORC2-ALACAK2) BAKIYE2,
			ACTION_DATE
		FROM
			(
				SELECT
					C.ACTION_VALUE AS BORC,
					C.ACTION_VALUE_2 AS BORC2,
					0 AS ALACAK,
					0 AS ALACAK2,
					ACTION_DATE
				FROM
					CARI_ROWS C
				WHERE 
					TO_CMP_ID IS NOT NULL
					OR TO_CONSUMER_ID IS NOT NULL
					OR TO_EMPLOYEE_ID IS NOT NULL						
			UNION ALL
				SELECT
					0 AS BORC,
					0 AS BORC2,
					C.ACTION_VALUE AS ALACAK,
					C.ACTION_VALUE_2 AS ALACAK2,
					ACTION_DATE
				FROM
	
					CARI_ROWS C
				WHERE
					FROM_CMP_ID IS NOT NULL
					OR FROM_CONSUMER_ID IS NOT NULL
					OR FROM_EMPLOYEE_ID IS NOT NULL				
			) AS CARI_TOPLAM_1
		GROUP BY ACTION_DATE

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [DAILY_TOTAL_CARI_REMAINDER] AS
		SELECT 
			D1.ACTION_DATE,
			SUM(D2.ALACAK) ALACAK,
			SUM(D2.BORC) BORC,
			SUM(D2.BORC-D2.ALACAK) BAKIYE,
			SUM(D2.BORC2) BORC2,
			SUM(D2.ALACAK2) ALACAK2,
			SUM(D2.BAKIYE2) BAKIYE2
		FROM
			DAILY_CARI_REMAINDER D1,
			DAILY_CARI_REMAINDER D2
		WHERE
			D1.ACTION_DATE >= D2.ACTION_DATE
		GROUP BY D1.ACTION_DATE

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [VOUCHER_IN_CASH] AS
			SELECT
				0 AS ALACAK, 
				SUM(VOUCHER.OTHER_MONEY_VALUE) AS BORC, 
				CASH.CASH_ID, 
				CASH.CASH_NAME
			FROM
				CASH,
				VOUCHER_PAYROLL,
				VOUCHER,
				VOUCHER_HISTORY
			WHERE
				VOUCHER.VOUCHER_STATUS_ID = 1 AND
				CASH.CASH_ID = VOUCHER_PAYROLL.PAYROLL_CASH_ID AND
				VOUCHER_HISTORY.VOUCHER_ID = VOUCHER.VOUCHER_ID AND
				VOUCHER_HISTORY.PAYROLL_ID = VOUCHER_PAYROLL.ACTION_ID AND
				VOUCHER_HISTORY.HISTORY_ID = (SELECT MAX(VH.HISTORY_ID) FROM VOUCHER_HISTORY VH WHERE VH.VOUCHER_ID = VOUCHER.VOUCHER_ID AND VH.STATUS = 1)
			GROUP BY
				CASH.CASH_ID, 
				CASH.CASH_NAME

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [VOUCHER_IN_CASH_TOTAL] AS
			SELECT
				SUM(VIC.BORC-VIC.ALACAK) AS BAKIYE, 
				SUM(VIC.BORC) AS BORC, 
				SUM(VIC.ALACAK) AS ALACAK,
				VIC.CASH_ID,
				VIC.CASH_NAME
			FROM
				VOUCHER_IN_CASH VIC
			GROUP BY
				VIC.CASH_ID,
				VIC.CASH_NAME

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_RELATION_PAPERS_1] AS
		SELECT 
			OPP_ID,
			0 OFFER_ID,
			0 ORDER_ID
		FROM
			#new_dsn3#.OPPORTUNITIES OPPORTUNITIES
		WHERE
			OPP_ID NOT IN (SELECT ISNULL(OPP_ID,0) FROM #new_dsn3#.OFFER OFFER)
	UNION
		SELECT 
			0 OPP_ID,
			OFFER_ID,
			0 ORDER_ID
		FROM
			#new_dsn3#.OFFER OFFER
		WHERE
			OFFER.OPP_ID IS NULL AND
			OFFER.OFFER_ID NOT IN (SELECT ISNULL(OFFER_ID,0) FROM #new_dsn3#.ORDERS ORDERS)
	UNION
		SELECT 
			OPPORTUNITIES.OPP_ID,
			OFFER.OFFER_ID,
			0 ORDER_ID
		FROM
			#new_dsn3#.OPPORTUNITIES OPPORTUNITIES,
			#new_dsn3#.OFFER OFFER
		WHERE
			OPPORTUNITIES.OPP_ID = OFFER.OPP_ID AND
			OFFER.OFFER_ID NOT IN (SELECT ISNULL(OFFER_ID,0) FROM #new_dsn3#.ORDERS ORDERS)
	UNION
		SELECT 
			OPPORTUNITIES.OPP_ID,
			OFFER.OFFER_ID,
			ORDERS.ORDER_ID
		FROM
			#new_dsn3#.OPPORTUNITIES OPPORTUNITIES,
			#new_dsn3#.OFFER OFFER,
			#new_dsn3#.ORDERS ORDERS
		WHERE
			OPPORTUNITIES.OPP_ID = OFFER.OPP_ID AND
			OFFER.OFFER_ID=ORDERS.OFFER_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_RELATION_PAPERS_2] AS
        SELECT 
			ORDERS_SHIP.ORDER_ID,
			ORDERS_SHIP.SHIP_ID,
			0 INVOICE,
			0 SHIP_RESULT_ID,
			0 P_ORDER_ID,
			0 PR_ORDER_ID,
			0 FIS_ID
		FROM
			#new_dsn3#.ORDERS_SHIP ORDERS_SHIP
		WHERE
			ORDERS_SHIP.PERIOD_ID=#PERIOD_ID# AND
			ORDERS_SHIP.ORDER_ID NOT IN (SELECT ORDER_ID FROM #new_dsn3#.ORDERS_INVOICE WHERE PERIOD_ID=#PERIOD_ID#) AND
			ORDERS_SHIP.ORDER_ID NOT IN (SELECT DISTINCT PRODUCTION_ORDER_ID FROM  #new_dsn3#.PRODUCTION_ORDERS_ROW) AND
			ORDERS_SHIP.SHIP_ID NOT IN (SELECT SHIP_ID FROM INVOICE_SHIPS WHERE SHIP_PERIOD_ID=#PERIOD_ID#) AND
			ORDERS_SHIP.ORDER_ID NOT IN (SELECT ISNULL(ORDER_ID,0) FROM #new_dsn3#.PRODUCTION_ORDERS_ROW) AND
			ORDERS_SHIP.SHIP_ID NOT IN (
										SELECT 
											ISNULL(SHIP_RESULT_ROW.SHIP_ID,0) 
										FROM 
											SHIP_RESULT_ROW,
											SHIP_RESULT
										WHERE
											SHIP_RESULT.SHIP_RESULT_ID=SHIP_RESULT_ROW.SHIP_RESULT_ID AND
											ISNULL(SHIP_RESULT.IS_TYPE,0)<>2
										) 
	UNION 
		--sipariş irsaliyede faturada var SEVKİYAT YOK ÜRETİM YOK
		SELECT 
			ORDERS_SHIP.ORDER_ID,
			ORDERS_SHIP.SHIP_ID,
			INVOICE_SHIPS.INVOICE_ID,
			0 SHIP_RESULT_ID,
			0 P_ORDER_ID,
			0 PR_ORDER_ID,
			0 FIS_ID
		FROM
			#new_dsn3#.ORDERS_SHIP ORDERS_SHIP,
			INVOICE,
			INVOICE_SHIPS
		WHERE
			ORDERS_SHIP.SHIP_ID=INVOICE_SHIPS.SHIP_ID AND
			INVOICE_SHIPS.INVOICE_ID = INVOICE.INVOICE_ID AND
			ORDERS_SHIP.PERIOD_ID=#PERIOD_ID# AND
			INVOICE_SHIPS.SHIP_PERIOD_ID= #PERIOD_ID# AND
			ORDERS_SHIP.ORDER_ID NOT IN (SELECT ISNULL(ORDER_ID,0) FROM #new_dsn3#.PRODUCTION_ORDERS_ROW) AND
			INVOICE_SHIPS.SHIP_ID NOT IN (
											SELECT 
												ISNULL(SHIP_RESULT_ROW.SHIP_ID,0) 
											FROM 
												SHIP_RESULT_ROW,
												SHIP_RESULT
											WHERE
												SHIP_RESULT.SHIP_RESULT_ID=SHIP_RESULT_ROW.SHIP_RESULT_ID AND
												ISNULL(SHIP_RESULT.IS_TYPE,0)<>2
											)
	UNION
	--sipariş irsaliyede VAR fatura YOK VEYA VAR SEVKİYAT VAR ÜRETİM YOK
		SELECT 
			ORDERS_SHIP.ORDER_ID,
			ORDERS_SHIP.SHIP_ID,
			(SELECT TOP 1 INVOICE_ID FROM INVOICE_SHIPS WHERE SHIP_PERIOD_ID=#PERIOD_ID# AND ORDERS_SHIP.SHIP_ID=INVOICE_SHIPS.SHIP_ID) AS INVOICE_ID,
			SHIP_RESULT.SHIP_RESULT_ID,
			0 P_ORDER_ID,
			0 PR_ORDER_ID,
			0 FIS_ID
		FROM
			#new_dsn3#.ORDERS_SHIP ORDERS_SHIP,
			SHIP_RESULT_ROW,
			SHIP_RESULT
		WHERE
			ORDERS_SHIP.SHIP_ID = SHIP_RESULT_ROW.SHIP_ID AND
			SHIP_RESULT.SHIP_RESULT_ID = SHIP_RESULT_ROW.SHIP_RESULT_ID AND
			ORDERS_SHIP.PERIOD_ID=#PERIOD_ID# AND
			SHIP_RESULT.SHIP_RESULT_ID=SHIP_RESULT_ROW.SHIP_RESULT_ID AND
			ISNULL(SHIP_RESULT.IS_TYPE,0)<>2 AND
			ORDERS_SHIP.ORDER_ID NOT IN (SELECT ISNULL(ORDER_ID,0) FROM #new_dsn3#.PRODUCTION_ORDERS_ROW)	
	UNION 
		--sipariş yok irsaliye ve fatura var SEVKİYAT YOK
		SELECT 
			0 ORDER_ID,
			INVOICE_SHIPS.SHIP_ID,
			INVOICE_SHIPS.INVOICE_ID,
			0 SHIP_RESULT_ID,
			0 P_ORDER_ID,
			0 PR_ORDER_ID,
			0 FIS_ID
		FROM
			INVOICE_SHIPS
		WHERE
			INVOICE_SHIPS.SHIP_PERIOD_ID=#PERIOD_ID# AND
			INVOICE_SHIPS.SHIP_ID NOT IN (SELECT SHIP_ID FROM #new_dsn3#.ORDERS_SHIP WHERE PERIOD_ID=#PERIOD_ID#) AND
			INVOICE_SHIPS.INVOICE_ID NOT IN (SELECT SHIP_ID FROM #new_dsn3#.ORDERS_INVOICE WHERE PERIOD_ID=#PERIOD_ID#) AND
			INVOICE_SHIPS.SHIP_ID NOT IN (
											SELECT 
												ISNULL(SHIP_RESULT_ROW.SHIP_ID,0) 
											FROM 
												SHIP_RESULT_ROW,
												SHIP_RESULT
											WHERE
												SHIP_RESULT.SHIP_RESULT_ID=SHIP_RESULT_ROW.SHIP_RESULT_ID AND
												ISNULL(SHIP_RESULT.IS_TYPE,0)<>2
											)
	UNION 
		--sipariş yok irsaliye ve fatura var SEVKİYAT VAR
		SELECT 
			0 ORDER_ID,
			INVOICE_SHIPS.SHIP_ID,
			INVOICE_SHIPS.INVOICE_ID,
			SHIP_RESULT_ROW.SHIP_RESULT_ID SHIP_RESULT_ID,
			0 P_ORDER_ID,
			0 PR_ORDER_ID,
			0 FIS_ID
		FROM
			INVOICE_SHIPS,
			SHIP_RESULT_ROW,
			SHIP_RESULT
		WHERE
			INVOICE_SHIPS.SHIP_PERIOD_ID=#PERIOD_ID# AND
			INVOICE_SHIPS.SHIP_ID NOT IN (SELECT ORDERS_SHIP.SHIP_ID FROM  #new_dsn3#.ORDERS_SHIP ORDERS_SHIP WHERE PERIOD_ID=#PERIOD_ID#) AND
			INVOICE_SHIPS.INVOICE_ID NOT IN (SELECT ORDERS_INVOICE.INVOICE_ID FROM #new_dsn3#.ORDERS_INVOICE ORDERS_INVOICE WHERE PERIOD_ID=#PERIOD_ID#) AND
			SHIP_RESULT_ROW.SHIP_ID=INVOICE_SHIPS.SHIP_ID AND
			SHIP_RESULT.SHIP_RESULT_ID=SHIP_RESULT_ROW.SHIP_RESULT_ID AND
			ISNULL(SHIP_RESULT.IS_TYPE,0)<>2
	----------------------
	UNION
		--siparişin irasliyesi YOK FATURA YOK SEVKİYAT(İRSALİYEDEN) YOK ÜRETİM EMRİ VAR ÜRETİM SONUCU YOK
		SELECT 
			ORDERS.ORDER_ID,
			0 SHIP_ID,
			0 INVOICE,
			0 SHIP_RESULT_ID,
			PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID P_ORDER_ID,
			0 PR_ORDER_ID,
			0 FIS_ID
		FROM
			#new_dsn3#.ORDERS ORDERS,
			#new_dsn3#.PRODUCTION_ORDERS_ROW PRODUCTION_ORDERS_ROW
	
		WHERE
			ORDERS.ORDER_ID = PRODUCTION_ORDERS_ROW.ORDER_ID AND
			ORDERS.ORDER_ID NOT IN (SELECT ORDER_ID FROM #new_dsn3#.ORDERS_INVOICE WHERE PERIOD_ID=#PERIOD_ID#) AND
			ORDERS.ORDER_ID NOT IN (SELECT ORDER_ID FROM #new_dsn3#.ORDERS_SHIP WHERE PERIOD_ID=#PERIOD_ID#) AND
			PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID NOT IN (SELECT P_ORDER_ID FROM #new_dsn3#.PRODUCTION_ORDER_RESULTS)
	
	UNION
		--siparişin irsaliyesi var FATURA YOK SEVKİYAT(İRSALİYEDEN) YOK ÜRETİM EMRİ VAR ÜRETİM SONUCU YOK
		SELECT 
			ORDERS_SHIP.ORDER_ID,
			ORDERS_SHIP.SHIP_ID,
			0 INVOICE,
			0 SHIP_RESULT_ID,
			PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID P_ORDER_ID,
			0 PR_ORDER_ID,
			0 FIS_ID
		FROM
			#new_dsn3#.ORDERS_SHIP ORDERS_SHIP,
			#new_dsn3#.PRODUCTION_ORDERS_ROW PRODUCTION_ORDERS_ROW
		WHERE
			ORDERS_SHIP.ORDER_ID = PRODUCTION_ORDERS_ROW.ORDER_ID AND
			ORDERS_SHIP.PERIOD_ID=#PERIOD_ID# AND
			ORDERS_SHIP.ORDER_ID NOT IN (SELECT ORDER_ID FROM #new_dsn3#.ORDERS_INVOICE WHERE PERIOD_ID=#PERIOD_ID#) AND
			ORDERS_SHIP.SHIP_ID NOT IN (SELECT SHIP_ID FROM INVOICE_SHIPS WHERE SHIP_PERIOD_ID=#PERIOD_ID#) AND
			ORDERS_SHIP.SHIP_ID NOT IN (
										SELECT 
											ISNULL(SHIP_RESULT_ROW.SHIP_ID,0) 
										FROM 
											SHIP_RESULT_ROW,
											SHIP_RESULT
										WHERE
											SHIP_RESULT.SHIP_RESULT_ID=SHIP_RESULT_ROW.SHIP_RESULT_ID AND
											ISNULL(SHIP_RESULT.IS_TYPE,0)<>2
										) AND
			PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID NOT IN (SELECT P_ORDER_ID FROM #new_dsn3#.PRODUCTION_ORDER_RESULTS)
	UNION 
		--sipariş irsaliyede faturada var SEVKİYAT YOK ÜRETİM EMRİ VAR ÜERTİM SONUCU YOK
		SELECT 
			ORDERS_SHIP.ORDER_ID,
			ORDERS_SHIP.SHIP_ID,
			INVOICE_SHIPS.INVOICE_ID,
			0 SHIP_RESULT_ID,
			PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID P_ORDER_ID,
			0 PR_ORDER_ID,
			0 FIS_ID
		FROM
			#new_dsn3#.ORDERS_SHIP ORDERS_SHIP,
			INVOICE,
			INVOICE_SHIPS,
			#new_dsn3#.PRODUCTION_ORDERS_ROW PRODUCTION_ORDERS_ROW
		WHERE
			ORDERS_SHIP.ORDER_ID = PRODUCTION_ORDERS_ROW.ORDER_ID AND
			ORDERS_SHIP.SHIP_ID=INVOICE_SHIPS.SHIP_ID AND
			INVOICE_SHIPS.INVOICE_ID = INVOICE.INVOICE_ID AND
			ORDERS_SHIP.PERIOD_ID=#PERIOD_ID# AND
			INVOICE_SHIPS.SHIP_PERIOD_ID=#PERIOD_ID# AND
			INVOICE_SHIPS.SHIP_ID NOT IN (
											SELECT 
												ISNULL(SHIP_RESULT_ROW.SHIP_ID,0) 
											FROM 
												SHIP_RESULT_ROW,
												SHIP_RESULT
											WHERE
												SHIP_RESULT.SHIP_RESULT_ID=SHIP_RESULT_ROW.SHIP_RESULT_ID AND
												ISNULL(SHIP_RESULT.IS_TYPE,0)<>2
											) AND
			PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID NOT IN (SELECT P_ORDER_ID FROM #new_dsn3#.PRODUCTION_ORDER_RESULTS)
	UNION 
		--sipariş irsaliyede faturada var SEVKİYAT VAR ÜRETİM EMRİ VAR ÜRETİM SONUC YOK
		SELECT 
			ORDERS_SHIP.ORDER_ID,
			ORDERS_SHIP.SHIP_ID,
			INVOICE_SHIPS.INVOICE_ID,
			0 SHIP_RESULT_ID,
			PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID P_ORDER_ID,
			0 PR_ORDER_ID,
			0 FIS_ID
		FROM
			#new_dsn3#.ORDERS_SHIP ORDERS_SHIP,
			#new_dsn3#.PRODUCTION_ORDERS_ROW PRODUCTION_ORDERS_ROW,
			INVOICE,
			INVOICE_SHIPS,
			SHIP_RESULT_ROW,
			SHIP_RESULT
		WHERE
			ORDERS_SHIP.ORDER_ID = PRODUCTION_ORDERS_ROW.ORDER_ID AND
			ORDERS_SHIP.SHIP_ID=INVOICE_SHIPS.SHIP_ID AND
			INVOICE_SHIPS.INVOICE_ID = INVOICE.INVOICE_ID AND

			ORDERS_SHIP.PERIOD_ID=#PERIOD_ID# AND
			INVOICE_SHIPS.SHIP_PERIOD_ID=#PERIOD_ID# AND
			SHIP_RESULT_ROW.SHIP_ID=INVOICE_SHIPS.SHIP_ID AND
			SHIP_RESULT.SHIP_RESULT_ID=SHIP_RESULT_ROW.SHIP_RESULT_ID AND
			ISNULL(SHIP_RESULT.IS_TYPE,0)<>2 AND
			PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID NOT IN (SELECT P_ORDER_ID FROM #new_dsn3#.PRODUCTION_ORDER_RESULTS)
	---------
	
	UNION
		--siparişin irasliyesi YOK FATURA YOK SEVKİYAT(İRSALİYEDEN) YOK ÜRETİM EMRİ VAR SONUÇTA VAR stok fıs yok
		SELECT 
			ORDERS.ORDER_ID,
			0 SHIP_ID,
			0 INVOICE,
			0 SHIP_RESULT_ID,
			PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID P_ORDER_ID,
			PRODUCTION_ORDER_RESULTS.PR_ORDER_ID,
			0 FIS_ID
		FROM
			#new_dsn3#.ORDERS ORDERS,
			#new_dsn3#.PRODUCTION_ORDERS_ROW PRODUCTION_ORDERS_ROW,
			#new_dsn3#.PRODUCTION_ORDER_RESULTS PRODUCTION_ORDER_RESULTS
		WHERE
			ORDERS.ORDER_ID = PRODUCTION_ORDERS_ROW.ORDER_ID AND
			PRODUCTION_ORDER_RESULTS.P_ORDER_ID=PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID AND
			ORDERS.ORDER_ID NOT IN (SELECT ORDER_ID FROM #new_dsn3#.ORDERS_INVOICE WHERE PERIOD_ID=#PERIOD_ID#) AND
			ORDERS.ORDER_ID NOT IN (SELECT ORDER_ID FROM #new_dsn3#.ORDERS_SHIP WHERE PERIOD_ID=#PERIOD_ID#) AND
			PRODUCTION_ORDER_RESULTS.IS_STOCK_FIS = 0
	
	UNION
		--siparişin irasliyesi var FATURA YOK SEVKİYAT(İRSALİYEDEN) YOK ÜRETİM EMRİ VAR üretim sonucu var STOK FIS YOK
		SELECT 
			ORDERS_SHIP.ORDER_ID,
			ORDERS_SHIP.SHIP_ID,
			0 INVOICE,
			0 SHIP_RESULT_ID,
			PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID P_ORDER_ID,
			PRODUCTION_ORDER_RESULTS.PR_ORDER_ID,
			0 FIS_ID
		FROM
			#new_dsn3#.ORDERS_SHIP ORDERS_SHIP,
			#new_dsn3#.PRODUCTION_ORDERS_ROW PRODUCTION_ORDERS_ROW,
			#new_dsn3#.PRODUCTION_ORDER_RESULTS PRODUCTION_ORDER_RESULTS
		WHERE
			ORDERS_SHIP.ORDER_ID = PRODUCTION_ORDERS_ROW.ORDER_ID AND
			PRODUCTION_ORDER_RESULTS.P_ORDER_ID=PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID AND
			ORDERS_SHIP.PERIOD_ID=#PERIOD_ID# AND
			ORDERS_SHIP.ORDER_ID NOT IN (SELECT ORDER_ID FROM #new_dsn3#.ORDERS_INVOICE WHERE PERIOD_ID=#PERIOD_ID#) AND
			ORDERS_SHIP.SHIP_ID NOT IN (SELECT SHIP_ID FROM INVOICE_SHIPS WHERE SHIP_PERIOD_ID=#PERIOD_ID#) AND
			ORDERS_SHIP.SHIP_ID NOT IN (
							SELECT ISNULL(SHIP_RESULT_ROW.SHIP_ID,0) 
							FROM 
								SHIP_RESULT_ROW,
								SHIP_RESULT
							WHERE
								SHIP_RESULT.SHIP_RESULT_ID=SHIP_RESULT_ROW.SHIP_RESULT_ID AND
								ISNULL(SHIP_RESULT.IS_TYPE,0)<>2
							)
			AND PRODUCTION_ORDER_RESULTS.IS_STOCK_FIS = 0
	UNION 
		--sipariş irsaliyede faturada var SEVKİYAT YOK ÜRETİM EMRİ VAR üretim sonucu var STOK FIS YOK
		SELECT 
			ORDERS_SHIP.ORDER_ID,
			ORDERS_SHIP.SHIP_ID,
			INVOICE_SHIPS.INVOICE_ID,
			0 SHIP_RESULT_ID,
			PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID P_ORDER_ID,
			PRODUCTION_ORDER_RESULTS.PR_ORDER_ID,
			0 FIS_ID
		FROM
			#new_dsn3#.ORDERS_SHIP ORDERS_SHIP,
			INVOICE,
			INVOICE_SHIPS,
			#new_dsn3#.PRODUCTION_ORDERS_ROW PRODUCTION_ORDERS_ROW,
			#new_dsn3#.PRODUCTION_ORDER_RESULTS PRODUCTION_ORDER_RESULTS
		WHERE
			ORDERS_SHIP.ORDER_ID = PRODUCTION_ORDERS_ROW.ORDER_ID AND
			PRODUCTION_ORDER_RESULTS.P_ORDER_ID=PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID AND
			ORDERS_SHIP.SHIP_ID=INVOICE_SHIPS.SHIP_ID AND
			INVOICE_SHIPS.INVOICE_ID = INVOICE.INVOICE_ID AND
			ORDERS_SHIP.PERIOD_ID=#PERIOD_ID# AND
			INVOICE_SHIPS.SHIP_PERIOD_ID=#PERIOD_ID# AND
			INVOICE_SHIPS.SHIP_ID NOT IN (SELECT ISNULL(SHIP_RESULT_ROW.SHIP_ID,0) 
							FROM 
								SHIP_RESULT_ROW,
								SHIP_RESULT
							WHERE
								SHIP_RESULT.SHIP_RESULT_ID=SHIP_RESULT_ROW.SHIP_RESULT_ID AND
								ISNULL(SHIP_RESULT.IS_TYPE,0)<>2
							)
			AND PRODUCTION_ORDER_RESULTS.IS_STOCK_FIS = 0
	UNION 
		--sipariş irsaliyede faturada var SEVKİYAT VAR ÜRETİM EMRİ VAR üretim sonucu var STOK FIS YOK
		SELECT 
			ORDERS_SHIP.ORDER_ID,
			ORDERS_SHIP.SHIP_ID,
			INVOICE_SHIPS.INVOICE_ID,
			0 SHIP_RESULT_ID,
			PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID P_ORDER_ID,
			PRODUCTION_ORDER_RESULTS.PR_ORDER_ID,
			0 FIS_ID
		FROM
			#new_dsn3#.ORDERS_SHIP ORDERS_SHIP,
			#new_dsn3#.PRODUCTION_ORDERS_ROW PRODUCTION_ORDERS_ROW,
			INVOICE,
			INVOICE_SHIPS,
			SHIP_RESULT_ROW,
			SHIP_RESULT,
			#new_dsn3#.PRODUCTION_ORDER_RESULTS PRODUCTION_ORDER_RESULTS
		WHERE
			ORDERS_SHIP.ORDER_ID = PRODUCTION_ORDERS_ROW.ORDER_ID AND
			PRODUCTION_ORDER_RESULTS.P_ORDER_ID=PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID AND
			ORDERS_SHIP.SHIP_ID=INVOICE_SHIPS.SHIP_ID AND
			INVOICE_SHIPS.INVOICE_ID = INVOICE.INVOICE_ID AND
			ORDERS_SHIP.PERIOD_ID=#PERIOD_ID# AND
			INVOICE_SHIPS.SHIP_PERIOD_ID=#PERIOD_ID# AND
			SHIP_RESULT_ROW.SHIP_ID=INVOICE_SHIPS.SHIP_ID AND
			SHIP_RESULT.SHIP_RESULT_ID=SHIP_RESULT_ROW.SHIP_RESULT_ID AND
			ISNULL(SHIP_RESULT.IS_TYPE,0)<>2 AND
			PRODUCTION_ORDER_RESULTS.IS_STOCK_FIS = 0
	-------------
	UNION
		--siparişin irasliyesi YOK FATURA YOK SEVKİYAT(İRSALİYEDEN) YOK ÜRETİM EMRİ VAR SONUÇTA VAR stok fıs var
		SELECT 
			ORDERS.ORDER_ID,
			0 SHIP_ID,
			0 INVOICE,
			0 SHIP_RESULT_ID,
			PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID P_ORDER_ID,
			PRODUCTION_ORDER_RESULTS.PR_ORDER_ID,
			STOCK_FIS.FIS_ID
		FROM
			#new_dsn3#.ORDERS ORDERS,
			#new_dsn3#.PRODUCTION_ORDERS_ROW PRODUCTION_ORDERS_ROW,
			#new_dsn3#.PRODUCTION_ORDER_RESULTS PRODUCTION_ORDER_RESULTS,
			STOCK_FIS
		WHERE
			ORDERS.ORDER_ID = PRODUCTION_ORDERS_ROW.ORDER_ID AND
			PRODUCTION_ORDER_RESULTS.P_ORDER_ID=PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID AND
			ORDERS.ORDER_ID NOT IN (SELECT ORDER_ID FROM #new_dsn3#.ORDERS_INVOICE WHERE PERIOD_ID=#PERIOD_ID#) AND
			ORDERS.ORDER_ID NOT IN (SELECT ORDER_ID FROM #new_dsn3#.ORDERS_SHIP WHERE PERIOD_ID=#PERIOD_ID#) AND
			PRODUCTION_ORDER_RESULTS.IS_STOCK_FIS = 1 AND
			STOCK_FIS.PROD_ORDER_RESULT_NUMBER = PRODUCTION_ORDER_RESULTS.PR_ORDER_ID
	
	UNION
		--siparişin irasliyesi var FATURA YOK SEVKİYAT(İRSALİYEDEN) YOK ÜRETİM EMRİ VAR üretim sonucu var STOK FIS VAR
		SELECT 
			ORDERS_SHIP.ORDER_ID,
			ORDERS_SHIP.SHIP_ID,
			0 INVOICE,
			0 SHIP_RESULT_ID,
			PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID P_ORDER_ID,
			PRODUCTION_ORDER_RESULTS.PR_ORDER_ID,
			STOCK_FIS.FIS_ID
		FROM
			#new_dsn3#.ORDERS_SHIP ORDERS_SHIP,
			#new_dsn3#.PRODUCTION_ORDERS_ROW PRODUCTION_ORDERS_ROW,
			#new_dsn3#.PRODUCTION_ORDER_RESULTS PRODUCTION_ORDER_RESULTS,
			STOCK_FIS STOCK_FIS
		WHERE
			ORDERS_SHIP.ORDER_ID = PRODUCTION_ORDERS_ROW.ORDER_ID AND
			PRODUCTION_ORDER_RESULTS.P_ORDER_ID=PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID AND
			ORDERS_SHIP.PERIOD_ID=#PERIOD_ID# AND
			ORDERS_SHIP.ORDER_ID NOT IN (SELECT ORDER_ID FROM #new_dsn3#.ORDERS_INVOICE WHERE PERIOD_ID=#PERIOD_ID#) AND
			ORDERS_SHIP.SHIP_ID NOT IN (SELECT SHIP_ID FROM INVOICE_SHIPS WHERE SHIP_PERIOD_ID=#PERIOD_ID#) AND
			ORDERS_SHIP.SHIP_ID NOT IN (
							SELECT ISNULL(SHIP_RESULT_ROW.SHIP_ID,0) 
							FROM 
								SHIP_RESULT_ROW,
								SHIP_RESULT
							WHERE
								SHIP_RESULT.SHIP_RESULT_ID=SHIP_RESULT_ROW.SHIP_RESULT_ID AND
								ISNULL(SHIP_RESULT.IS_TYPE,0)<>2
							)
			AND PRODUCTION_ORDER_RESULTS.IS_STOCK_FIS = 1 AND
			STOCK_FIS.PROD_ORDER_RESULT_NUMBER = PRODUCTION_ORDER_RESULTS.PR_ORDER_ID
	UNION 
		--sipariş irsaliyede faturada var SEVKİYAT YOK ÜRETİM EMRİ VAR üretim sonucu var STOK FIS VAR
		SELECT
			ORDERS_SHIP.ORDER_ID,
			ORDERS_SHIP.SHIP_ID,
			INVOICE_SHIPS.INVOICE_ID,
			0 SHIP_RESULT_ID,
			PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID P_ORDER_ID,
			PRODUCTION_ORDER_RESULTS.PR_ORDER_ID,
			STOCK_FIS.FIS_ID
		FROM
			#new_dsn3#.ORDERS_SHIP ORDERS_SHIP,
			INVOICE INVOICE,
			INVOICE_SHIPS INVOICE_SHIPS,
			#new_dsn3#.PRODUCTION_ORDERS_ROW PRODUCTION_ORDERS_ROW,
			#new_dsn3#.PRODUCTION_ORDER_RESULTS PRODUCTION_ORDER_RESULTS,
			STOCK_FIS STOCK_FIS
		WHERE
			ORDERS_SHIP.ORDER_ID = PRODUCTION_ORDERS_ROW.ORDER_ID AND
			PRODUCTION_ORDER_RESULTS.P_ORDER_ID=PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID AND
			ORDERS_SHIP.SHIP_ID=INVOICE_SHIPS.SHIP_ID AND
			INVOICE_SHIPS.INVOICE_ID = INVOICE.INVOICE_ID AND
			ORDERS_SHIP.PERIOD_ID=#PERIOD_ID# AND
			INVOICE_SHIPS.SHIP_PERIOD_ID=#PERIOD_ID# AND
			INVOICE_SHIPS.SHIP_ID NOT IN (SELECT ISNULL(SHIP_RESULT_ROW.SHIP_ID,0) 
							FROM 
								SHIP_RESULT_ROW,
								SHIP_RESULT
							WHERE
								SHIP_RESULT.SHIP_RESULT_ID=SHIP_RESULT_ROW.SHIP_RESULT_ID AND
								ISNULL(SHIP_RESULT.IS_TYPE,0)<>2
							)
			AND PRODUCTION_ORDER_RESULTS.IS_STOCK_FIS = 1 AND
			STOCK_FIS.PROD_ORDER_RESULT_NUMBER = PRODUCTION_ORDER_RESULTS.PR_ORDER_ID
	UNION 
		--sipariş irsaliyede faturada var SEVKİYAT VAR ÜRETİM EMRİ VAR üretim sonucu var
		SELECT 
			ORDERS_SHIP.ORDER_ID,
			ORDERS_SHIP.SHIP_ID,
			INVOICE_SHIPS.INVOICE_ID,
			SHIP_RESULT.SHIP_RESULT_ID SHIP_RESULT_ID,
			PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID P_ORDER_ID,
			PRODUCTION_ORDER_RESULTS.PR_ORDER_ID,
			STOCK_FIS.FIS_ID
		FROM
			#new_dsn3#.ORDERS_SHIP ORDERS_SHIP,
			#new_dsn3#.PRODUCTION_ORDERS_ROW PRODUCTION_ORDERS_ROW,
			INVOICE,
			INVOICE_SHIPS,
			SHIP_RESULT_ROW,
			SHIP_RESULT,
			#new_dsn3#.PRODUCTION_ORDER_RESULTS PRODUCTION_ORDER_RESULTS,
			STOCK_FIS
		WHERE
			ORDERS_SHIP.ORDER_ID = PRODUCTION_ORDERS_ROW.ORDER_ID AND
			PRODUCTION_ORDER_RESULTS.P_ORDER_ID=PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID AND
			ORDERS_SHIP.SHIP_ID=INVOICE_SHIPS.SHIP_ID AND
			INVOICE_SHIPS.INVOICE_ID = INVOICE.INVOICE_ID AND
			ORDERS_SHIP.PERIOD_ID=#PERIOD_ID# AND
			INVOICE_SHIPS.SHIP_PERIOD_ID=#PERIOD_ID# AND
			SHIP_RESULT_ROW.SHIP_ID=INVOICE_SHIPS.SHIP_ID AND
			SHIP_RESULT.SHIP_RESULT_ID=SHIP_RESULT_ROW.SHIP_RESULT_ID AND
			ISNULL(SHIP_RESULT.IS_TYPE,0)<>2 AND
			PRODUCTION_ORDER_RESULTS.IS_STOCK_FIS = 1 AND
			STOCK_FIS.PROD_ORDER_RESULT_NUMBER = PRODUCTION_ORDER_RESULTS.PR_ORDER_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_RELATION_PAPERS] AS
			SELECT 
				OPP_ID,
				OFFER_ID,
				ORDER_ID,
				0 SHIP_ID,
				0 INVOICE,
				0 SHIP_RESULT_ID,
				0 P_ORDER_ID,
				0 PR_ORDER_ID,
				0 FIS_ID
			FROM
				GET_RELATION_PAPERS_1
			WHERE
				ORDER_ID = 0 OR ORDER_ID NOT IN (SELECT ORDER_ID FROM #new_dsn3#.ORDERS_SHIP WHERE PERIOD_ID=2)
		UNION
			SELECT 
				0 OPP_ID,
				0 OFFER_ID,
				ORDER_ID ORDER_ID,
				SHIP_ID,
				INVOICE,
				SHIP_RESULT_ID,
				P_ORDER_ID,
				PR_ORDER_ID,
				FIS_ID
			FROM
				GET_RELATION_PAPERS_2
		UNION 
			SELECT 
				GET_RELATION_PAPERS_1.OPP_ID,
				GET_RELATION_PAPERS_1.OFFER_ID,
				GET_RELATION_PAPERS_1.ORDER_ID,
				GET_RELATION_PAPERS_2.SHIP_ID,
				GET_RELATION_PAPERS_2.INVOICE,
				GET_RELATION_PAPERS_2.SHIP_RESULT_ID,
				GET_RELATION_PAPERS_2.P_ORDER_ID,
				GET_RELATION_PAPERS_2.PR_ORDER_ID,
				GET_RELATION_PAPERS_2.FIS_ID
			FROM
				GET_RELATION_PAPERS_1,
				GET_RELATION_PAPERS_2
			WHERE
				GET_RELATION_PAPERS_1.ORDER_ID > 0 AND
				GET_RELATION_PAPERS_2.ORDER_ID > 0 AND 
				GET_RELATION_PAPERS_1.ORDER_ID = GET_RELATION_PAPERS_2.ORDER_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_ALL_STOCKS_ROW_COST_LOCATION] AS
			SELECT 
				PRODUCT_ID,
				STOCK_ID,
				SPECT_VAR_ID,
                LOT_NO,
				ISNULL((SELECT
					TOP 1 (PURCHASE_NET_SYSTEM_LOCATION + PURCHASE_EXTRA_COST_SYSTEM_LOCATION)  
				FROM 
					GET_PRODUCT_COST_PERIOD
				WHERE
					GET_PRODUCT_COST_PERIOD.START_DATE <= STOCKS_ROW.PROCESS_DATE
					AND GET_PRODUCT_COST_PERIOD.PRODUCT_ID = STOCKS_ROW.PRODUCT_ID
					AND ISNULL(GET_PRODUCT_COST_PERIOD.SPECT_MAIN_ID,0)=ISNULL(STOCKS_ROW.SPECT_VAR_ID,0)
					AND GET_PRODUCT_COST_PERIOD.DEPARTMENT_ID=STOCKS_ROW.STORE
				ORDER BY
					GET_PRODUCT_COST_PERIOD.START_DATE DESC,
					GET_PRODUCT_COST_PERIOD.RECORD_DATE DESC,
					GET_PRODUCT_COST_PERIOD.PRODUCT_COST_ID DESC
					),0) AS NET_MALIYET,
				ISNULL((SELECT
					TOP 1 (PURCHASE_NET_SYSTEM_2_LOCATION + PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION)  
				FROM 
					GET_PRODUCT_COST_PERIOD
				WHERE
					GET_PRODUCT_COST_PERIOD.START_DATE <= STOCKS_ROW.PROCESS_DATE
					AND GET_PRODUCT_COST_PERIOD.PRODUCT_ID = STOCKS_ROW.PRODUCT_ID
					AND ISNULL(GET_PRODUCT_COST_PERIOD.SPECT_MAIN_ID,0)=ISNULL(STOCKS_ROW.SPECT_VAR_ID,0)
					AND GET_PRODUCT_COST_PERIOD.DEPARTMENT_ID=STOCKS_ROW.STORE
				ORDER BY 
					GET_PRODUCT_COST_PERIOD.START_DATE DESC,
					GET_PRODUCT_COST_PERIOD.RECORD_DATE DESC,
					GET_PRODUCT_COST_PERIOD.PRODUCT_COST_ID DESC
					),0) AS NET_MALIYET_2,
				STOCK_IN,
				STOCK_OUT,
				UPD_ID,
				PROCESS_DATE,
				PROCESS_TYPE,
				STORE,
				STORE_LOCATION
			FROM 
				STOCKS_ROW

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_STOCKS_ROW_COST_LOCATION] AS
		SELECT 
			(SUM(NET_MALIYET)/COUNT(PRODUCT_ID))  AS MALIYET,
			(SUM(NET_MALIYET_2)/COUNT(PRODUCT_ID))  AS MALIYET_2,
			SUM(STOCK_IN)  AS STOCK_IN,
			SUM(STOCK_OUT)  AS STOCK_OUT,
			UPD_ID,
			PROCESS_DATE,
			PROCESS_TYPE,
			STORE,
			STORE_LOCATION,
			PRODUCT_ID,
			STOCK_ID
		FROM
			GET_ALL_STOCKS_ROW_COST_LOCATION
		GROUP BY
			UPD_ID,
			PROCESS_DATE,
			PROCESS_TYPE,
			STORE,
			STORE_LOCATION,
			PRODUCT_ID,
			STOCK_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_STOCKS_ROW_COST_SPECT] AS
		SELECT 
			(SUM(NET_MALIYET)/COUNT(PRODUCT_ID))  AS MALIYET,
			(SUM(NET_MALIYET_2)/COUNT(PRODUCT_ID))  AS MALIYET_2,
			SUM(STOCK_IN)  AS STOCK_IN,
			SUM(STOCK_OUT)  AS STOCK_OUT,
			UPD_ID,
			PROCESS_DATE,
			PROCESS_TYPE,
			STORE,
			STORE_LOCATION,
			PRODUCT_ID,
			STOCK_ID,
			SPECT_VAR_ID
		FROM
			GET_ALL_STOCKS_ROW_COST
		GROUP BY
			UPD_ID,
			PROCESS_DATE,
			PROCESS_TYPE,
			STORE,
			STORE_LOCATION,
			PRODUCT_ID,
			STOCK_ID,
			SPECT_VAR_ID

</cfquery>
<cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_STOCKS_ROW_COST_LOT] AS
		SELECT 
			(SUM(NET_MALIYET)/COUNT(PRODUCT_ID))  AS MALIYET,
			(SUM(NET_MALIYET_2)/COUNT(PRODUCT_ID))  AS MALIYET_2,
			SUM(STOCK_IN)  AS STOCK_IN,
			SUM(STOCK_OUT)  AS STOCK_OUT,
			UPD_ID,
			PROCESS_DATE,
			PROCESS_TYPE,
			STORE,
			STORE_LOCATION,
			PRODUCT_ID,
			STOCK_ID,
			LOT_NO
		FROM
			GET_ALL_STOCKS_ROW_COST
		GROUP BY
			UPD_ID,
			PROCESS_DATE,
			PROCESS_TYPE,
			STORE,
			STORE_LOCATION,
			PRODUCT_ID,
			STOCK_ID,
			LOT_NO

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_STOCKS_ROW_COST_SPECT_LOCATION] AS
		SELECT 
			(SUM(NET_MALIYET)/COUNT(PRODUCT_ID))  AS MALIYET,
			(SUM(NET_MALIYET_2)/COUNT(PRODUCT_ID))  AS MALIYET_2,
			SUM(STOCK_IN)  AS STOCK_IN,
			SUM(STOCK_OUT)  AS STOCK_OUT,
			UPD_ID,
			PROCESS_DATE,
			PROCESS_TYPE,
			STORE,
			STORE_LOCATION,
			PRODUCT_ID,
			STOCK_ID,
			SPECT_VAR_ID
		FROM
			GET_ALL_STOCKS_ROW_COST_LOCATION
		GROUP BY
			UPD_ID,
			PROCESS_DATE,
			PROCESS_TYPE,
			STORE,
			STORE_LOCATION,
			PRODUCT_ID,
			STOCK_ID,
			SPECT_VAR_ID

</cfquery>
<cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_STOCKS_ROW_COST_LOT_LOCATION] AS
		SELECT 
			(SUM(NET_MALIYET)/COUNT(PRODUCT_ID))  AS MALIYET,
			(SUM(NET_MALIYET_2)/COUNT(PRODUCT_ID))  AS MALIYET_2,
			SUM(STOCK_IN)  AS STOCK_IN,
			SUM(STOCK_OUT)  AS STOCK_OUT,
			UPD_ID,
			PROCESS_DATE,
			PROCESS_TYPE,
			STORE,
			STORE_LOCATION,
			PRODUCT_ID,
			STOCK_ID,
			LOT_NO
		FROM
			GET_ALL_STOCKS_ROW_COST_LOCATION
		GROUP BY
			UPD_ID,
			PROCESS_DATE,
			PROCESS_TYPE,
			STORE,
			STORE_LOCATION,
			PRODUCT_ID,
			STOCK_ID,
			LOT_NO

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [CARI_ROWS_TOPLAM] AS
		SELECT
        CASE WHEN C.TO_CMP_ID IS NOT NULL THEN  SUM(C.ACTION_VALUE) ELSE 0 END AS BORC,
        CASE WHEN C.TO_CMP_ID IS NOT NULL THEN SUM(C.ACTION_VALUE_2) ELSE 0 END AS BORC2,		
        CASE WHEN C.FROM_CMP_ID IS NOT NULL THEN SUM(C.ACTION_VALUE) ELSE 0 END AS ALACAK,
        CASE WHEN C.FROM_CMP_ID IS NOT NULL THEN SUM(C.ACTION_VALUE_2) ELSE 0  END AS ALACAK2,
        CASE WHEN C.FROM_CMP_ID IS NOT NULL THEN SUM(ISNULL(OTHER_CASH_ACT_VALUE,0)) ELSE 0  END AS ALACAK3,				
        CASE WHEN C.TO_CMP_ID IS NOT NULL THEN C.TO_CMP_ID ELSE C.FROM_CMP_ID  END AS COMPANY_ID,
        CASE WHEN C.TO_CMP_ID IS NOT NULL THEN SUM(ISNULL(OTHER_CASH_ACT_VALUE,0)) ELSE 0 END AS BORC3,
        OTHER_MONEY,
        CASE WHEN DATEDIFF(day,ACTION_DATE,ISNULL(DUE_DATE,ACTION_DATE)) = 0 THEN 1 ELSE  DATEDIFF(day,ACTION_DATE,ISNULL(DUE_DATE,ACTION_DATE)) END AS DATE_DIFF,
        CASE WHEN DATEDIFF(day,ISNULL(DUE_DATE,ACTION_DATE),GETDATE()) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(DUE_DATE,ACTION_DATE),GETDATE()) END AS DUE_DATE_DIFF,
        ACTION_DATE,
        DUE_DATE,
        PROJECT_ID,
        SUBSCRIPTION_ID,
        ACC_TYPE_ID,
        ACTION_TYPE_ID,
        ISNULL(TO_BRANCH_ID,FROM_BRANCH_ID) BRANCH_ID,
        C.FROM_CMP_ID,
        C.TO_CMP_ID
    FROM
        CARI_ROWS C
    WHERE
        C.TO_CMP_ID IS NOT NULL OR C.FROM_CMP_ID IS NOT NULL
    GROUP BY
        C.FROM_CMP_ID,
        C.TO_CMP_ID,
        OTHER_MONEY,
        ACTION_DATE,
        DUE_DATE,
        PROJECT_ID,
        SUBSCRIPTION_ID,
        ACC_TYPE_ID,
        ACTION_TYPE_ID,
        ISNULL(TO_BRANCH_ID,FROM_BRANCH_ID)

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [COMPANY_REMAINDER_BRANCH] AS
			SELECT
				COMPANY_ID, 
				BRANCH_ID,
				ROUND(SUM(BORC-ALACAK),5) AS BAKIYE, 
				ROUND(SUM(BORC2-ALACAK2),5) AS BAKIYE2, 
				SUM(BORC) AS BORC,
				SUM(BORC2) AS BORC2,
				SUM(ALACAK) AS ALACAK,
				SUM(ALACAK2) AS ALACAK2,
				CASE WHEN SUM(BORC)= 0 THEN SUM((BORC*DATE_DIFF)) ELSE ROUND((SUM((BORC*DATE_DIFF))/SUM(BORC)),0) END AS VADE_BORC,
				CASE WHEN SUM(ALACAK)= 0 THEN SUM((ALACAK*DATE_DIFF)) ELSE ROUND((SUM((ALACAK*DATE_DIFF))/SUM(ALACAK)),0) END AS VADE_ALACAK,
				CASE WHEN SUM(BORC)= 0 THEN SUM((BORC*DUE_DATE_DIFF)) ELSE ROUND((SUM((BORC*DUE_DATE_DIFF))/SUM(BORC)),0) END AS VADE_BORC_NEW,
				CASE WHEN SUM(ALACAK)= 0 THEN SUM((ALACAK*DUE_DATE_DIFF)) ELSE ROUND((SUM((ALACAK*DUE_DATE_DIFF))/SUM(ALACAK)),0) END AS VADE_ALACAK_NEW
			FROM
				CARI_ROWS_TOPLAM
			GROUP BY
				COMPANY_ID,
				BRANCH_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [COMPANY_REMAINDER_MONEY_BRANCH] AS
			SELECT
				COMPANY_ID, 
				BRANCH_ID,
				SUM(BORC-ALACAK) AS BAKIYE, 
				SUM(BORC2-ALACAK2) AS BAKIYE2,
				SUM(BORC3-ALACAK3) AS BAKIYE3,
				SUM(BORC) AS BORC,
				SUM(BORC2) AS BORC2,
				SUM(BORC3) AS BORC3,
				SUM(ALACAK) AS ALACAK,
				SUM(ALACAK2) AS ALACAK2,
				SUM(ALACAK3) AS ALACAK3,
				OTHER_MONEY,
				CASE WHEN SUM(BORC3)= 0 THEN SUM((BORC3*DATE_DIFF)) ELSE ROUND((SUM((BORC3*DATE_DIFF))/SUM(BORC3)),0) END AS VADE_BORC3,
				CASE WHEN SUM(ALACAK3)= 0 THEN SUM((ALACAK3*DATE_DIFF)) ELSE ROUND((SUM((ALACAK3*DATE_DIFF))/SUM(ALACAK3)),0) END AS VADE_ALACAK3,
				CASE WHEN SUM(BORC3)= 0 THEN SUM((BORC3*DUE_DATE_DIFF)) ELSE ROUND((SUM((BORC3*DUE_DATE_DIFF))/SUM(BORC3)),0) END AS VADE_BORC_NEW3,
				CASE WHEN SUM(ALACAK3)= 0 THEN SUM((ALACAK3*DUE_DATE_DIFF)) ELSE ROUND((SUM((ALACAK3*DUE_DATE_DIFF))/SUM(ALACAK3)),0) END AS VADE_ALACAK_NEW3
			FROM
				CARI_ROWS_TOPLAM
			GROUP BY
				COMPANY_ID,
				BRANCH_ID,
				OTHER_MONEY

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [COMPANY_REMAINDER_MONEY_PROJECT_BRANCH] AS
			SELECT     
				COMPANY_ID, 
				PROJECT_ID,
				OTHER_MONEY,
				BRANCH_ID,
				SUM(BORC-ALACAK) AS BAKIYE, 
				SUM(BORC2-ALACAK2) AS BAKIYE2,
				SUM(BORC3-ALACAK3) AS BAKIYE3,
				SUM(BORC) AS BORC,
				SUM(BORC2) AS BORC2,
				SUM(BORC3) AS BORC3,
				SUM(ALACAK) AS ALACAK,
				SUM(ALACAK2) AS ALACAK2,
				SUM(ALACAK3) AS ALACAK3,
				CASE WHEN SUM(BORC3)= 0 THEN SUM((BORC3*DATE_DIFF)) ELSE ROUND((SUM((BORC3*DATE_DIFF))/SUM(BORC3)),0) END AS VADE_BORC3,
				CASE WHEN SUM(ALACAK3)= 0 THEN SUM((ALACAK3*DATE_DIFF)) ELSE ROUND((SUM((ALACAK3*DATE_DIFF))/SUM(ALACAK3)),0) END AS VADE_ALACAK3
			FROM         
				CARI_ROWS_TOPLAM
			GROUP BY 
				COMPANY_ID, 	
				OTHER_MONEY,
				PROJECT_ID,
				BRANCH_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [COMPANY_REMAINDER_PROJECT_BRANCH] AS
			SELECT     
				COMPANY_ID, 
				PROJECT_ID,
				BRANCH_ID,
				ROUND(SUM(BORC-ALACAK),5) AS BAKIYE, 
				ROUND(SUM(BORC2-ALACAK2),5) AS BAKIYE2, 
				SUM(BORC) AS BORC,
				SUM(BORC2) AS BORC2,
				SUM(ALACAK) AS ALACAK,
				SUM(ALACAK2) AS ALACAK2,
				CASE WHEN SUM(BORC)= 0 THEN SUM((BORC*DATE_DIFF)) ELSE ROUND((SUM((BORC*DATE_DIFF))/SUM(BORC)),0) END AS VADE_BORC,
				CASE WHEN SUM(ALACAK)= 0 THEN SUM((ALACAK*DATE_DIFF)) ELSE ROUND((SUM((ALACAK*DATE_DIFF))/SUM(ALACAK)),0) END AS VADE_ALACAK
			FROM         
				CARI_ROWS_TOPLAM
			GROUP BY 
				COMPANY_ID, 
				PROJECT_ID,
				BRANCH_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [CARI_ROWS_CONSUMER] AS
		SELECT
			CASE WHEN C.TO_CONSUMER_ID IS NOT NULL  THEN SUM(C.ACTION_VALUE) ELSE 0 END AS BORC,
			CASE WHEN C.TO_CONSUMER_ID IS NOT NULL  THEN SUM(C.ACTION_VALUE_2) ELSE 0 END AS BORC2,	
			CASE WHEN C.TO_CONSUMER_ID IS NOT NULL  THEN SUM(ISNULL(OTHER_CASH_ACT_VALUE,0)) ELSE 0 END AS BORC3,	
			CASE WHEN C.FROM_CONSUMER_ID IS NOT NULL THEN SUM(C.ACTION_VALUE) ELSE 0 END AS ALACAK,
			CASE WHEN C.FROM_CONSUMER_ID IS NOT NULL THEN SUM(C.ACTION_VALUE_2) ELSE 0 END AS ALACAK2,
			CASE WHEN C.FROM_CONSUMER_ID IS NOT NULL THEN SUM(ISNULL(OTHER_CASH_ACT_VALUE,0)) ELSE 0 END AS ALACAK3,
			CASE WHEN C.TO_CONSUMER_ID IS NOT NULL THEN C.TO_CONSUMER_ID ELSE C.FROM_CONSUMER_ID END AS CONSUMER_ID,
			OTHER_MONEY,
			CASE WHEN DATEDIFF(day,ACTION_DATE,ISNULL(DUE_DATE,ACTION_DATE)) = 0 THEN 1 ELSE  DATEDIFF(day,ACTION_DATE,ISNULL(DUE_DATE,ACTION_DATE)) END AS DATE_DIFF,
			CASE WHEN DATEDIFF(day,ISNULL(DUE_DATE,ACTION_DATE),GETDATE()) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(DUE_DATE,ACTION_DATE),GETDATE()) END AS DUE_DATE_DIFF,
			PROJECT_ID,
            SUBSCRIPTION_ID,
			ACC_TYPE_ID,
			DUE_DATE,
			ACTION_DATE,
			ACTION_TYPE_ID,
			ISNULL(TO_BRANCH_ID,FROM_BRANCH_ID) BRANCH_ID,
			C.TO_CONSUMER_ID,
			C.FROM_CONSUMER_ID
		FROM
			CARI_ROWS C
		WHERE
			C.TO_CONSUMER_ID IS NOT NULL OR  C.FROM_CONSUMER_ID IS NOT NULL
		GROUP BY
			C.TO_CONSUMER_ID,
			C.FROM_CONSUMER_ID,
			OTHER_MONEY,
			ACTION_DATE,
			DUE_DATE,
			PROJECT_ID,
            SUBSCRIPTION_ID,
			ACC_TYPE_ID,
			ACTION_DATE,
			ACTION_TYPE_ID,
			ISNULL(TO_BRANCH_ID,FROM_BRANCH_ID)

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [CONSUMER_REMAINDER_BRANCH] AS
			SELECT
				CONSUMER_ID,
				BRANCH_ID,
				ROUND(SUM(BORC-ALACAK),5) AS BAKIYE, 
				ROUND(SUM(BORC2-ALACAK2),5) AS BAKIYE2,
				ROUND(SUM(BORC),5) AS BORC,
				ROUND(SUM(BORC2),5) AS BORC2,
				ROUND(SUM(ALACAK),5) AS ALACAK,
				ROUND(SUM(ALACAK2),5) AS ALACAK2,
				CASE WHEN SUM(BORC)= 0 THEN SUM((BORC*DATE_DIFF)) ELSE ROUND((SUM((BORC*DATE_DIFF))/SUM(BORC)),0) END AS VADE_BORC,
				CASE WHEN SUM(ALACAK)= 0 THEN SUM((ALACAK*DATE_DIFF)) ELSE ROUND((SUM((ALACAK*DATE_DIFF))/SUM(ALACAK)),0) END AS VADE_ALACAK,	
				CASE WHEN SUM(BORC)= 0 THEN SUM((BORC*DUE_DATE_DIFF)) ELSE ROUND((SUM((BORC*DUE_DATE_DIFF))/SUM(BORC)),0) END AS VADE_BORC_NEW,
				CASE WHEN SUM(ALACAK)= 0 THEN SUM((ALACAK*DUE_DATE_DIFF)) ELSE ROUND((SUM((ALACAK*DUE_DATE_DIFF))/SUM(ALACAK)),0) END AS VADE_ALACAK_NEW
			FROM
				CARI_ROWS_CONSUMER
			GROUP BY
				CONSUMER_ID,
				BRANCH_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [ACCOUNT_ACCOUNT_REMAINDER] AS
        SELECT
            CASE WHEN BA=1 THEN SUM(ACCOUNT_CARD_ROWS.AMOUNT) ELSE 0 END AS ALACAK,
            CASE WHEN BA=1 THEN SUM(ISNULL(ACCOUNT_CARD_ROWS.AMOUNT_2,0)) ELSE 0 END AS ALACAK_2,
            CASE WHEN BA=0 THEN SUM(ACCOUNT_CARD_ROWS.AMOUNT) ELSE 0 END AS BORC, 
            CASE WHEN BA=0 THEN SUM(ISNULL(ACCOUNT_CARD_ROWS.AMOUNT_2,0)) ELSE 0 END AS BORC_2,
            ACCOUNT_CARD_ROWS.ACCOUNT_ID,
            ACCOUNT_CARD.ACTION_DATE,
            ACCOUNT_CARD.CARD_TYPE,
            ACCOUNT_CARD.CARD_CAT_ID
        FROM
            ACCOUNT_CARD_ROWS,
            ACCOUNT_CARD
        WHERE
             ACCOUNT_CARD.CARD_ID = ACCOUNT_CARD_ROWS.CARD_ID 
        GROUP BY
            ACCOUNT_CARD_ROWS.ACCOUNT_ID,
            ACCOUNT_CARD.ACTION_DATE,
            ACCOUNT_CARD.CARD_TYPE,
            ACCOUNT_CARD.CARD_CAT_ID,
            ACCOUNT_CARD_ROWS.BA

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [ACCOUNT_ACCOUNT_REMAINDER_LAST] AS
			SELECT
				SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC - ACCOUNT_ACCOUNT_REMAINDER.ALACAK) AS BAKIYE, 
				SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC) AS BORC,
				SUM(ACCOUNT_ACCOUNT_REMAINDER.ALACAK) AS ALACAK, 
				SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC_2 - ACCOUNT_ACCOUNT_REMAINDER.ALACAK_2) AS BAKIYE_2, 
				SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC_2) AS BORC_2,
				SUM(ACCOUNT_ACCOUNT_REMAINDER.ALACAK_2) AS ALACAK_2, 
				ACCOUNT_PLAN.ACCOUNT_CODE, 
				ACCOUNT_PLAN.ACCOUNT_NAME,
				ACCOUNT_PLAN.ACCOUNT_ID,
				ACCOUNT_PLAN.IFRS_CODE, 
				ACCOUNT_PLAN.IFRS_NAME,
				ACCOUNT_ACCOUNT_REMAINDER.ACTION_DATE,
				ACCOUNT_ACCOUNT_REMAINDER.CARD_TYPE,
				ACCOUNT_ACCOUNT_REMAINDER.CARD_CAT_ID	
			FROM
				ACCOUNT_PLAN,
				ACCOUNT_ACCOUNT_REMAINDER
			WHERE
				(
					(ACCOUNT_PLAN.SUB_ACCOUNT=1 AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID LIKE ACCOUNT_PLAN.ACCOUNT_CODE +'%')
					OR
					(ACCOUNT_PLAN.SUB_ACCOUNT=0 AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID = ACCOUNT_PLAN.ACCOUNT_CODE)
				)
			GROUP BY
				ACCOUNT_PLAN.ACCOUNT_CODE, 
				ACCOUNT_PLAN.ACCOUNT_NAME,
				ACCOUNT_PLAN.IFRS_CODE, 
				ACCOUNT_PLAN.IFRS_NAME,
				ACCOUNT_PLAN.ACCOUNT_ID, 
				ACCOUNT_ACCOUNT_REMAINDER.ACTION_DATE,
				ACCOUNT_ACCOUNT_REMAINDER.CARD_TYPE,
				ACCOUNT_ACCOUNT_REMAINDER.CARD_CAT_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [CONSUMER_REMAINDER_MONEY_BRANCH] AS
			SELECT
				CONSUMER_ID, 
				BRANCH_ID,
				SUM(BORC-ALACAK) AS BAKIYE, 
				SUM(BORC2-ALACAK2) AS BAKIYE2,
				SUM(BORC3-ALACAK3) AS BAKIYE3,
				SUM(BORC) AS BORC,
				SUM(BORC2) AS BORC2,
				SUM(BORC3) AS BORC3,
				SUM(ALACAK) AS ALACAK,
				SUM(ALACAK2) AS ALACAK2,
				SUM(ALACAK3) AS ALACAK3,
				OTHER_MONEY,
				CASE WHEN SUM(BORC3)= 0 THEN SUM((BORC3*DATE_DIFF)) ELSE ROUND((SUM((BORC3*DATE_DIFF))/SUM(BORC3)),0) END AS VADE_BORC3,
				CASE WHEN SUM(ALACAK3)= 0 THEN SUM((ALACAK3*DATE_DIFF)) ELSE ROUND((SUM((ALACAK3*DATE_DIFF))/SUM(ALACAK3)),0) END AS VADE_ALACAK3,
				CASE WHEN SUM(BORC3)= 0 THEN SUM((BORC3*DUE_DATE_DIFF)) ELSE ROUND((SUM((BORC3*DUE_DATE_DIFF))/SUM(BORC3)),0) END AS VADE_BORC_NEW3,
				CASE WHEN SUM(ALACAK3)= 0 THEN SUM((ALACAK3*DUE_DATE_DIFF)) ELSE ROUND((SUM((ALACAK3*DUE_DATE_DIFF))/SUM(ALACAK3)),0) END AS VADE_ALACAK_NEW3
			FROM
				CARI_ROWS_CONSUMER
			GROUP BY
				CONSUMER_ID,
				BRANCH_ID,
				OTHER_MONEY

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [ACCOUNT_ACCOUNT_REMAINDER_NOPROCESS] AS
			SELECT
				ACCOUNT_CODE, 
				0 AS ALACAK, 
				0 AS BORC, 
				0 AS BAKIYE,
				0 AS ALACAK_2, 
				0 AS BORC_2, 
				0 AS BAKIYE_2,
				ACCOUNT_NAME, 
				ACCOUNT_ID
			FROM
				ACCOUNT_PLAN
			WHERE
				(ACCOUNT_CODE NOT IN (SELECT ACCOUNT_CODE FROM ACCOUNT_ACCOUNT_REMAINDER_LAST))

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [CONSUMER_REMAINDER_MONEY_PROJECT_BRANCH] AS
			SELECT
				CONSUMER_ID, 
				OTHER_MONEY,
				PROJECT_ID,
				BRANCH_ID,		
				SUM(BORC-ALACAK) AS BAKIYE, 
				SUM(BORC2-ALACAK2) AS BAKIYE2,
				SUM(BORC3-ALACAK3) AS BAKIYE3,
				SUM(BORC) AS BORC,
				SUM(BORC2) AS BORC2,
				SUM(BORC3) AS BORC3,
				SUM(ALACAK) AS ALACAK,
				SUM(ALACAK2) AS ALACAK2,
				SUM(ALACAK3) AS ALACAK3,
				CASE WHEN SUM(BORC3)= 0 THEN SUM((BORC3*DATE_DIFF)) ELSE ROUND((SUM((BORC3*DATE_DIFF))/SUM(BORC3)),0) END AS VADE_BORC3,
				CASE WHEN SUM(ALACAK3)= 0 THEN SUM((ALACAK3*DATE_DIFF)) ELSE ROUND((SUM((ALACAK3*DATE_DIFF))/SUM(ALACAK3)),0) END AS VADE_ALACAK3
			FROM
				CARI_ROWS_CONSUMER
			GROUP BY
				CONSUMER_ID,
				OTHER_MONEY,
				PROJECT_ID,
				BRANCH_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [CONSUMER_REMAINDER_PROJECT_BRANCH] AS
			SELECT
				CONSUMER_ID, 
				PROJECT_ID,
				BRANCH_ID,
				ROUND(SUM(BORC-ALACAK),5) AS BAKIYE, 
				ROUND(SUM(BORC2-ALACAK2),5) AS BAKIYE2,
				ROUND(SUM(BORC),5) AS BORC,
				ROUND(SUM(BORC2),5) AS BORC2,
				ROUND(SUM(ALACAK),5) AS ALACAK,
				ROUND(SUM(ALACAK2),5) AS ALACAK2,
				CASE WHEN SUM(BORC)= 0 THEN SUM((BORC*DATE_DIFF)) ELSE ROUND((SUM((BORC*DATE_DIFF))/SUM(BORC)),0) END AS VADE_BORC,
				CASE WHEN SUM(ALACAK)= 0 THEN SUM((ALACAK*DATE_DIFF)) ELSE ROUND((SUM((ALACAK*DATE_DIFF))/SUM(ALACAK)),0) END AS VADE_ALACAK	
			FROM
				CARI_ROWS_CONSUMER
			GROUP BY
				CONSUMER_ID,
				PROJECT_ID,
				BRANCH_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [ACCOUNT_ACCOUNT_REMAINDER_TOTAL] AS
			SELECT
				ACCOUNT_CODE, 
				SUM(BAKIYE) AS BAKIYE,
				SUM(ALACAK) AS ALACAK,
				SUM(BORC) AS BORC,
				SUM(BAKIYE_2) AS BAKIYE_2,
				SUM(ALACAK_2) AS ALACAK_2,
				SUM(BORC_2) AS BORC_2,
				ACCOUNT_NAME,
				ACCOUNT_ID
			FROM
				ACCOUNT_ACCOUNT_REMAINDER_LAST AR
			GROUP BY
				ACCOUNT_CODE,
				ACCOUNT_NAME,
				ACCOUNT_ID
		UNION
			SELECT
				ACCOUNT_CODE, 
				BAKIYE, 
				ALACAK, 
				BORC,
				BAKIYE_2,
				ALACAK_2,
				BORC_2,
				ACCOUNT_NAME,
				ACCOUNT_ID
			FROM
				ACCOUNT_ACCOUNT_REMAINDER_NOPROCESS AN

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [ACCOUNT_REMAINDER] AS
		SELECT 
            CASE WHEN ACCOUNTS.ACCOUNT_ID = BANK_ACTIONS.ACTION_FROM_ACCOUNT_ID THEN SUM(BANK_ACTIONS.ACTION_VALUE) ELSE 0 END AS ALACAK,
            CASE WHEN ACCOUNTS.ACCOUNT_ID = BANK_ACTIONS.ACTION_TO_ACCOUNT_ID THEN SUM(BANK_ACTIONS.ACTION_VALUE - ISNULL(BANK_ACTIONS.MASRAF, 0)) ELSE 0 END AS BORC,
			CASE WHEN ACCOUNTS.ACCOUNT_ID = BANK_ACTIONS.ACTION_FROM_ACCOUNT_ID THEN SUM(BANK_ACTIONS.SYSTEM_ACTION_VALUE) ELSE 0 END AS ALACAK_SYSTEM,
            CASE WHEN ACCOUNTS.ACCOUNT_ID = BANK_ACTIONS.ACTION_TO_ACCOUNT_ID THEN SUM(BANK_ACTIONS.SYSTEM_ACTION_VALUE) ELSE 0 END AS BORC_SYSTEM,
            ACCOUNTS.ACCOUNT_ID, 
            ACCOUNTS.ACCOUNT_NAME, 
            ACCOUNTS.ACCOUNT_CURRENCY_ID, 
            MAX(BANK_ACTIONS.ACTION_DATE) AS TARIH
    	FROM 
            BANK_ACTIONS, 
            #new_dsn3#.ACCOUNTS AS ACCOUNTS
   		 WHERE
            (ACCOUNTS.ACCOUNT_ID = BANK_ACTIONS.ACTION_FROM_ACCOUNT_ID OR ACCOUNTS.ACCOUNT_ID = BANK_ACTIONS.ACTION_TO_ACCOUNT_ID) AND
       		 BANK_ACTIONS.ACTION_TYPE_ID <> 93
    	GROUP BY
            ACCOUNTS.ACCOUNT_ID, 
            ACCOUNTS.ACCOUNT_NAME, 
            ACCOUNTS.ACCOUNT_CURRENCY_ID,	
            BANK_ACTIONS.ACTION_FROM_ACCOUNT_ID,
            BANK_ACTIONS.ACTION_TO_ACCOUNT_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [ACCOUNT_REMAINDER_LAST] AS
			SELECT
				SUM(BORC - ALACAK) AS BAKIYE, 
				SUM(BORC_SYSTEM - ALACAK_SYSTEM) AS BAKIYE_SYSTEM, 
				SUM(BORC) AS BORC, 
				SUM(ALACAK) AS ALACAK,
				SUM(BORC_SYSTEM) AS BORC_SYSTEM, 
				SUM(ALACAK_SYSTEM) AS ALACAK_SYSTEM,
				MAX(TARIH) AS TARIH, 
				ACCOUNT_ID, 
				ACCOUNT_NAME,
				ACCOUNT_CURRENCY_ID
			FROM
				ACCOUNT_REMAINDER
			GROUP BY
				ACCOUNT_ID,
				ACCOUNT_NAME,
				ACCOUNT_CURRENCY_ID

</cfquery>

<cfquery name="get_all_period" datasource="#dsn#">
    SELECT 
        * 
    FROM 
        SETUP_PERIOD
    WHERE
        PERIOD_YEAR IN (#get_periods.period_year#,#get_periods.period_year+1#) 
        AND OUR_COMPANY_ID = #get_periods.OUR_COMPANY_ID#
</cfquery>
<cfscript>
    str_query = "";
    str_query2 = "";
    str_query = "#str_query# CREATE VIEW GET_CONSIGMENT_PRODUCT_SALE AS SELECT SUM(A1.INVOICE_AMOUNT) AS INVOICE_AMOUNT,A1.PRODUCT_ID,A1.STOCK_ID,A1.ACTION_DATE ,A1.DEPARTMENT_ID, A1.LOCATION_ID";
    str_query = "#str_query# ,CASE WHEN SPECT_VAR_ID = 0 THEN 0 ELSE ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM  #dsn#_#get_periods.OUR_COMPANY_ID#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID = A1.SPECT_VAR_ID),0) END AS SPECT_MAIN_ID FROM ( ";
    for( i = 1 ;i lte get_all_period.recordcount; i = i + 1)
        {	
            str_query2 = "#str_query2# SELECT SUM(AMOUNT) AS INVOICE_AMOUNT,GSRR.STOCK_ID,GSRR.PRODUCT_ID,ISNULL(GSRR.SPECT_VAR_ID,0) AS SPECT_VAR_ID,I.INVOICE_DATE AS ACTION_DATE,SR.STORE AS DEPARTMENT_ID, SR.STORE_LOCATION AS LOCATION_ID FROM  #dsn#_#get_all_period.PERIOD_YEAR[i]#_#get_all_period.OUR_COMPANY_ID[i]#.SHIP_ROW_RELATION GSRR, #dsn#_#get_all_period.PERIOD_YEAR[i]#_#get_all_period.OUR_COMPANY_ID[i]#.INVOICE I,";
            str_query2 = "#str_query2# (SELECT DISTINCT UPD_ID,STORE_LOCATION,STORE,PROCESS_TYPE FROM STOCKS_ROW WHERE PROCESS_TYPE = 72) AS SR";
            str_query2 = "#str_query2# WHERE GSRR.SHIP_ID=SR.UPD_ID AND GSRR.SHIP_PERIOD = #get_periods.PERIOD_ID# AND GSRR.TO_INVOICE_ID IS NOT NULL AND GSRR.TO_INVOICE_ID =I.INVOICE_ID AND GSRR.TO_INVOICE_CAT =I.INVOICE_CAT GROUP BY GSRR.PRODUCT_ID,GSRR.STOCK_ID,GSRR.SPECT_VAR_ID,I.INVOICE_DATE,SR.STORE,SR.STORE_LOCATION";
            if(i neq get_all_period.recordcount)
                str_query2 = "#str_query2# UNION";
        }
    str_query="#str_query# #str_query2# ) AS A1 GROUP BY PRODUCT_ID,STOCK_ID,SPECT_VAR_ID,ACTION_DATE,DEPARTMENT_ID, LOCATION_ID";
    //WriteOutput("#str_query#");
</cfscript>
<cfquery name="ins_view_main_db" datasource="#new_dsn2#">
    #str_query#
</cfquery>
  
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_CONSIGMENT_DETAIL] AS
			SELECT 
				SUM(STOCK_OUT) AS STOCK_IN,
				0 AS STOCK_OUT,
				SHIP_DATE AS ACTION_DATE,
				SR.PRODUCT_ID,
				SR.STOCK_ID,
				SR.SPECT_VAR_ID AS SPECT_MAIN_ID,
				SR.STORE AS DEPARTMENT_ID,
				SR.STORE_LOCATION AS LOCATION_ID 
			FROM
				SHIP S,
				STOCKS_ROW SR
			WHERE
				SR.UPD_ID= S.SHIP_ID
				AND S.SHIP_TYPE=SR.PROCESS_TYPE
				AND S.SHIP_TYPE=72
			GROUP BY
				SHIP_DATE,
				SR.PRODUCT_ID,
				SR.STOCK_ID,
				SR.SPECT_VAR_ID,
				SR.STORE,
				SR.STORE_LOCATION
			UNION ALL
			
			SELECT
				0 AS STOCK_IN,
				SUM(GSRR.AMOUNT) AS STOCK_OUT,
				SHIP.SHIP_DATE AS ACTION_DATE,
				GSRR.PRODUCT_ID,
				GSRR.STOCK_ID,
				GSRR.SPECT_VAR_ID AS SPECT_MAIN_ID,
				SHIP.DEPARTMENT_IN AS DEPARTMENT_ID,
				SHIP.LOCATION_IN AS LOCATION_ID 
			FROM  
				SHIP_ROW_RELATION GSRR,  
				(SELECT DISTINCT UPD_ID,STORE_LOCATION,STORE,PROCESS_TYPE FROM STOCKS_ROW WHERE PROCESS_TYPE = 72) AS SR,
				SHIP
			WHERE 
				GSRR.SHIP_PERIOD=#PERIOD_ID# AND 
				GSRR.SHIP_ID =SR.UPD_ID 
				AND GSRR.TO_SHIP_TYPE = SHIP.SHIP_TYPE
				AND GSRR.TO_SHIP_ID =SHIP.SHIP_ID
				AND SHIP.SHIP_TYPE=75	
			GROUP BY
				SHIP.SHIP_DATE,
				GSRR.PRODUCT_ID,
				GSRR.STOCK_ID,
				GSRR.SPECT_VAR_ID,
				SHIP.DEPARTMENT_IN,
				SHIP.LOCATION_IN 			
			UNION ALL
			SELECT 
				0 AS STOCK_IN,
				SUM(GC.INVOICE_AMOUNT) AS STOCK_OUT,
				GC.ACTION_DATE,
				GC.PRODUCT_ID,
				GC.STOCK_ID,
				GC.SPECT_MAIN_ID,
				GC.DEPARTMENT_ID,
				GC.LOCATION_ID 
			FROM
				GET_CONSIGMENT_PRODUCT_SALE GC
			GROUP BY
				ACTION_DATE,
				GC.PRODUCT_ID,
				GC.STOCK_ID,
				GC.SPECT_MAIN_ID,
				GC.DEPARTMENT_ID,
				GC.LOCATION_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [CASH_REMAINDER] AS
		SELECT DISTINCT
			CASE WHEN CASH_ACTIONS.CASH_ACTION_TO_CASH_ID = CASH.CASH_ID THEN   SUM(CASH_ACTIONS.CASH_ACTION_VALUE)ELSE 0 END AS BORC, 
			CASE WHEN CASH_ACTIONS.CASH_ACTION_FROM_CASH_ID = CASH.CASH_ID THEN  SUM(CASH_ACTIONS.CASH_ACTION_VALUE) ELSE 0 END AS ALACAK, 
			CASH.CASH_ID, 
			CASH.CASH_NAME
		FROM
			CASH_ACTIONS, 
			CASH
		WHERE
			CASH_ACTIONS.CASH_ACTION_FROM_CASH_ID = CASH.CASH_ID OR CASH_ACTIONS.CASH_ACTION_TO_CASH_ID = CASH.CASH_ID
		GROUP BY
			CASH.CASH_ID, 
			CASH.CASH_NAME,
			CASH_ACTIONS.CASH_ACTION_TO_CASH_ID,
			CASH_ACTIONS.CASH_ACTION_FROM_CASH_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [CASH_REMAINDER_LAST] AS
			SELECT
				SUM(BORC-ALACAK) AS BAKIYE, 
				SUM(BORC) AS BORC, 
				SUM(ALACAK) AS ALACAK, 
				CASH_ID, 
				CASH_NAME
			FROM
				CASH_REMAINDER
			GROUP BY
				CASH_ID, 
				CASH_NAME

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [CHEQUE_IN_CASH] AS
			SELECT
				0 AS ALACAK, 
				SUM(CHEQUE.OTHER_MONEY_VALUE) AS BORC, 
				CASH.CASH_ID, 
				CASH.CASH_NAME
			FROM
				CASH,
				PAYROLL,
				CHEQUE,
				CHEQUE_HISTORY
			WHERE
				CHEQUE.CHEQUE_STATUS_ID = 1 AND
				CASH.CASH_ID = PAYROLL.PAYROLL_CASH_ID AND
				CHEQUE_HISTORY.CHEQUE_ID = CHEQUE.CHEQUE_ID AND
				CHEQUE_HISTORY.PAYROLL_ID = PAYROLL.ACTION_ID AND
				CHEQUE_HISTORY.HISTORY_ID = (SELECT MAX(CH.HISTORY_ID) FROM CHEQUE_HISTORY CH WHERE CH.CHEQUE_ID = CHEQUE.CHEQUE_ID AND CH.STATUS = 1)
			GROUP BY
				CASH.CASH_ID, 
				CASH.CASH_NAME

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [CHEQUE_IN_CASH_TOTAL] AS
			SELECT
				SUM(CIC.BORC-CIC.ALACAK) AS BAKIYE, 
				SUM(CIC.BORC) AS BORC, 
				SUM(CIC.ALACAK) AS ALACAK,
				CIC.CASH_ID,
				CIC.CASH_NAME
			FROM
				CHEQUE_IN_CASH CIC
			GROUP BY
				CIC.CASH_ID,
				CIC.CASH_NAME

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [COMPANY_REMAINDER] AS
			SELECT
				COMPANY_ID, 
				ROUND(SUM(BORC-ALACAK),5) AS BAKIYE, 
				ROUND(SUM(BORC2-ALACAK2),5) AS BAKIYE2, 
				SUM(BORC) AS BORC,
				SUM(BORC2) AS BORC2,
				SUM(ALACAK) AS ALACAK,
				SUM(ALACAK2) AS ALACAK2,
				CASE WHEN SUM(BORC)= 0 THEN SUM((BORC*DATE_DIFF)) ELSE ROUND((SUM((BORC*DATE_DIFF))/SUM(BORC)),0) END AS VADE_BORC,
				CASE WHEN SUM(ALACAK)= 0 THEN SUM((ALACAK*DATE_DIFF)) ELSE ROUND((SUM((ALACAK*DATE_DIFF))/SUM(ALACAK)),0) END AS VADE_ALACAK,
				CASE WHEN SUM(BORC)= 0 THEN SUM((BORC*DUE_DATE_DIFF)) ELSE ROUND((SUM((BORC*DUE_DATE_DIFF))/SUM(BORC)),0) END AS VADE_BORC_NEW,
				CASE WHEN SUM(ALACAK)= 0 THEN SUM((ALACAK*DUE_DATE_DIFF)) ELSE ROUND((SUM((ALACAK*DUE_DATE_DIFF))/SUM(ALACAK)),0) END AS VADE_ALACAK_NEW
			FROM
				CARI_ROWS_TOPLAM
			GROUP BY
				COMPANY_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [COMPANY_REMAINDER_MONEY] AS
			SELECT
				COMPANY_ID, 
				SUM(BORC-ALACAK) AS BAKIYE, 
				SUM(BORC2-ALACAK2) AS BAKIYE2,
				SUM(BORC3-ALACAK3) AS BAKIYE3,
				SUM(BORC) AS BORC,
				SUM(BORC2) AS BORC2,
				SUM(BORC3) AS BORC3,
				SUM(ALACAK) AS ALACAK,
				SUM(ALACAK2) AS ALACAK2,
				SUM(ALACAK3) AS ALACAK3,
				OTHER_MONEY,
				CASE WHEN SUM(BORC3)= 0 THEN SUM((BORC3*DATE_DIFF)) ELSE ROUND((SUM((BORC3*DATE_DIFF))/SUM(BORC3)),0) END AS VADE_BORC3,
				CASE WHEN SUM(ALACAK3)= 0 THEN SUM((ALACAK3*DATE_DIFF)) ELSE ROUND((SUM((ALACAK3*DATE_DIFF))/SUM(ALACAK3)),0) END AS VADE_ALACAK3,
				CASE WHEN SUM(BORC3)= 0 THEN SUM((BORC3*DUE_DATE_DIFF)) ELSE ROUND((SUM((BORC3*DUE_DATE_DIFF))/SUM(BORC3)),0) END AS VADE_BORC_NEW3,
				CASE WHEN SUM(ALACAK3)= 0 THEN SUM((ALACAK3*DUE_DATE_DIFF)) ELSE ROUND((SUM((ALACAK3*DUE_DATE_DIFF))/SUM(ALACAK3)),0) END AS VADE_ALACAK_NEW3
			FROM
				CARI_ROWS_TOPLAM
			GROUP BY
				COMPANY_ID,
				OTHER_MONEY

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [COMPANY_REMAINDER_PROJECT] AS
			SELECT     
				COMPANY_ID, 
				PROJECT_ID,
				ROUND(SUM(BORC-ALACAK),5) AS BAKIYE, 
				ROUND(SUM(BORC2-ALACAK2),5) AS BAKIYE2, 
				SUM(BORC) AS BORC,
				SUM(BORC2) AS BORC2,
				SUM(ALACAK) AS ALACAK,
				SUM(ALACAK2) AS ALACAK2,
				CASE WHEN SUM(BORC)= 0 THEN SUM((BORC*DATE_DIFF)) ELSE ROUND((SUM((BORC*DATE_DIFF))/SUM(BORC)),0) END AS VADE_BORC,
				CASE WHEN SUM(ALACAK)= 0 THEN SUM((ALACAK*DATE_DIFF)) ELSE ROUND((SUM((ALACAK*DATE_DIFF))/SUM(ALACAK)),0) END AS VADE_ALACAK
			FROM         
				CARI_ROWS_TOPLAM
			GROUP BY 
				COMPANY_ID, 
				PROJECT_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [COMPANY_REMAINDER_MONEY_PROJECT] AS
			SELECT     
				COMPANY_ID, 
				PROJECT_ID,
				OTHER_MONEY,
				SUM(BORC-ALACAK) AS BAKIYE, 
				SUM(BORC2-ALACAK2) AS BAKIYE2,
				SUM(BORC3-ALACAK3) AS BAKIYE3,
				SUM(BORC) AS BORC,
				SUM(BORC2) AS BORC2,
				SUM(BORC3) AS BORC3,
				SUM(ALACAK) AS ALACAK,
				SUM(ALACAK2) AS ALACAK2,
				SUM(ALACAK3) AS ALACAK3,
				CASE WHEN SUM(BORC3)= 0 THEN SUM((BORC3*DATE_DIFF)) ELSE ROUND((SUM((BORC3*DATE_DIFF))/SUM(BORC3)),0) END AS VADE_BORC3,
				CASE WHEN SUM(ALACAK3)= 0 THEN SUM((ALACAK3*DATE_DIFF)) ELSE ROUND((SUM((ALACAK3*DATE_DIFF))/SUM(ALACAK3)),0) END AS VADE_ALACAK3
			FROM         
				CARI_ROWS_TOPLAM
			GROUP BY 
				COMPANY_ID, 	
				OTHER_MONEY,
				PROJECT_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [VOUCHER_REMAINING_AMOUNT] AS			
			SELECT
				VOUCHER_ID,
				VOUCHER_VALUE-ROUND(SUM((CLOSED_AMOUNT)/(V.OTHER_MONEY_VALUE/V.VOUCHER_VALUE)),4) REMAINING_VALUE,
				OTHER_MONEY_VALUE-SUM(CLOSED_AMOUNT) OTHER_REMAINING_VALUE,
				OTHER_MONEY_VALUE2-ROUND(SUM((CLOSED_AMOUNT)/(V.OTHER_MONEY_VALUE/V.OTHER_MONEY_VALUE2)),4) OTHER_REMAINING_VALUE2
			FROM
				VOUCHER V,
				VOUCHER_CLOSED VC
			WHERE
				V.VOUCHER_ID = VC.ACTION_ID
				AND V.OTHER_MONEY_VALUE2 > 0
			GROUP BY
				VOUCHER_ID,VOUCHER_VALUE,OTHER_MONEY_VALUE,OTHER_MONEY_VALUE2
		UNION
			SELECT
				VOUCHER_ID,
				SUM(VOUCHER_VALUE) REMAINING_VALUE,
				SUM(OTHER_MONEY_VALUE) OTHER_REMAINING_VALUE,
				SUM(OTHER_MONEY_VALUE2) OTHER_REMAINING_VALUE2
			FROM
				VOUCHER V
			WHERE
				VOUCHER_ID NOT IN(SELECT ACTION_ID FROM VOUCHER_CLOSED WHERE ACTION_ID = VOUCHER_ID)
				AND V.OTHER_MONEY_VALUE2 > 0
			GROUP BY
				VOUCHER_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [COMPANY_RISK] AS
		SELECT 
			SUM( Q1.BORC ) AS BORC,
			SUM( Q1.BORC2 ) AS BORC2,
			SUM( Q1.ALACAK ) AS ALACAK,
			SUM( Q1.ALACAK2 ) AS ALACAK2,
			SUM( Q1.BAKIYE ) AS BAKIYE,
			SUM( Q1.BAKIYE2 ) AS BAKIYE2,
			SUM( Q1.VADE_BORC ) AS VADE_BORC,
			SUM( Q1.VADE_ALACAK ) AS VADE_ALACAK,
			SUM( Q1.VADE_BORC_NEW ) AS VADE_BORC_NEW,
			SUM( Q1.VADE_ALACAK_NEW ) AS VADE_ALACAK_NEW,
			SUM( Q1.CEK_ODENMEDI ) AS CEK_ODENMEDI,
			SUM( Q1.CEK_ODENMEDI2 ) AS CEK_ODENMEDI2,
			SUM( Q1.CEK_KARSILIKSIZ ) AS CEK_KARSILIKSIZ,
			SUM( Q1.CEK_KARSILIKSIZ2 ) AS CEK_KARSILIKSIZ2,
			SUM( Q1.SENET_ODENMEDI ) AS SENET_ODENMEDI,
			SUM( Q1.SENET_ODENMEDI2 ) AS SENET_ODENMEDI2,
			SUM( Q1.SENET_KARSILIKSIZ ) AS SENET_KARSILIKSIZ,
			SUM( Q1.SENET_KARSILIKSIZ2) AS SENET_KARSILIKSIZ2,
			SUM( Q1.FORWARD_SALE_LIMIT ) AS FORWARD_SALE_LIMIT,
			SUM( Q1.OPEN_ACCOUNT_RISK_LIMIT ) AS OPEN_ACCOUNT_RISK_LIMIT,
			SUM( Q1.PAYMENT_BLOKAJ ) AS PAYMENT_BLOKAJ,
			SUM( Q1.TOTAL_RISK_LIMIT ) AS TOTAL_RISK_LIMIT,
			SUM( Q1.SECURE_TOTAL_TAKE ) AS SECURE_TOTAL_TAKE,
			SUM( Q1.SECURE_TOTAL_TAKE2 ) AS SECURE_TOTAL_TAKE2,
			SUM( Q1.SECURE_TOTAL_GIVE ) AS SECURE_TOTAL_GIVE,
			SUM( Q1.SECURE_TOTAL_GIVE2 ) AS SECURE_TOTAL_GIVE2,
			Q1.COMPANY_ID
		FROM
			(
			SELECT 
				BORC,
				BORC2,
				ALACAK,
				ALACAK2,
				BAKIYE,
				BAKIYE2,
				VADE_BORC,
				VADE_ALACAK,
				VADE_BORC_NEW,
				VADE_ALACAK_NEW,
				0 AS CEK_ODENMEDI,
				0 AS CEK_ODENMEDI2,
				0 AS CEK_KARSILIKSIZ,
				0 AS CEK_KARSILIKSIZ2,
				0 AS SENET_ODENMEDI,
				0 AS SENET_ODENMEDI2,
				0 AS SENET_KARSILIKSIZ,
				0 AS SENET_KARSILIKSIZ2,
				0 AS FORWARD_SALE_LIMIT,
				0 AS OPEN_ACCOUNT_RISK_LIMIT,
				0 AS PAYMENT_BLOKAJ,
				0 AS TOTAL_RISK_LIMIT,
				0 AS SECURE_TOTAL_TAKE,
				0 AS SECURE_TOTAL_TAKE2,
				0 AS SECURE_TOTAL_GIVE,
				0 AS SECURE_TOTAL_GIVE2,
				COMPANY_ID
			FROM 
				COMPANY_REMAINDER
					
		UNION ALL
			
			SELECT
				0 AS BORC,
				0 AS BORC2,
				0 AS ALACAK,
				0 AS ALACAK2,
				0 AS BAKIYE,
				0 AS BAKIYE2,
				0 AS VADE_BORC,
				0 AS VADE_ALACAK,
				0 AS VADE_BORC_NEW,
				0 AS VADE_ALACAK_NEW,
				SUM(CHEQUE.OTHER_MONEY_VALUE) AS CEK_ODENMEDI,
				SUM(CHEQUE.OTHER_MONEY_VALUE2) AS CEK_ODENMEDI2,
				0 AS CEK_KARSILIKSIZ,
				0 AS CEK_KARSILIKSIZ2,
				0 AS SENET_ODENMEDI,
				0 AS SENET_ODENMEDI2,
				0 AS SENET_KARSILIKSIZ,
				0 AS SENET_KARSILIKSIZ2,
				0 AS FORWARD_SALE_LIMIT,
				0 AS OPEN_ACCOUNT_RISK_LIMIT,
				0 AS PAYMENT_BLOKAJ,
				0 AS TOTAL_RISK_LIMIT,
				0 AS SECURE_TOTAL_TAKE,
				0 AS SECURE_TOTAL_TAKE2,
				0 AS SECURE_TOTAL_GIVE,
				0 AS SECURE_TOTAL_GIVE2,
				CHEQUE.COMPANY_ID
			FROM
				CHEQUE
			WHERE
				CHEQUE.CHEQUE_ID IS NOT NULL AND
				CHEQUE.CHEQUE_STATUS_ID IN (1,2,13)
				AND CHEQUE.COMPANY_ID IS NOT NULL 
			GROUP BY
				CHEQUE.COMPANY_ID
		UNION ALL
			
			SELECT
				0 AS BORC,
				0 AS BORC2,
				0 AS ALACAK,
				0 AS ALACAK2,
				0 AS BAKIYE,
				0 AS BAKIYE2,
				0 AS VADE_BORC,
				0 AS VADE_ALACAK,
				0 AS VADE_BORC_NEW,
				0 AS VADE_ALACAK_NEW,
				SUM(CHEQUE.OTHER_MONEY_VALUE) AS CEK_ODENMEDI,
				SUM(CHEQUE.OTHER_MONEY_VALUE2) AS CEK_ODENMEDI2,
				0 AS CEK_KARSILIKSIZ,
				0 AS CEK_KARSILIKSIZ2,
				0 AS SENET_ODENMEDI,
				0 AS SENET_ODENMEDI2,
				0 AS SENET_KARSILIKSIZ,
				0 AS SENET_KARSILIKSIZ2,
				0 AS FORWARD_SALE_LIMIT,
				0 AS OPEN_ACCOUNT_RISK_LIMIT,
				0 AS PAYMENT_BLOKAJ,
				0 AS TOTAL_RISK_LIMIT,
				0 AS SECURE_TOTAL_TAKE,
				0 AS SECURE_TOTAL_TAKE2,
				0 AS SECURE_TOTAL_GIVE,
				0 AS SECURE_TOTAL_GIVE2,
				CHEQUE.OWNER_COMPANY_ID COMPANY_ID
			FROM
				CHEQUE
			WHERE
				CHEQUE.CHEQUE_ID IS NOT NULL AND
				CHEQUE.CHEQUE_STATUS_ID = 4 AND
				CHEQUE.CHEQUE_DUEDATE > GETDATE()
				AND CHEQUE.OWNER_COMPANY_ID IS NOT NULL 
			GROUP BY
				CHEQUE.OWNER_COMPANY_ID				
		UNION ALL
				
			SELECT
				0 AS BORC,
				0 AS BORC2,
				0 AS ALACAK,
				0 AS ALACAK2,
				0 AS BAKIYE,
				0 AS BAKIYE2,
				0 AS VADE_BORC,
				0 AS VADE_ALACAK,
				0 AS VADE_BORC_NEW,
				0 AS VADE_ALACAK_NEW,
				0 AS CEK_ODENMEDI,
				0 AS CEK_ODENMEDI2,
				SUM(CHEQUE.OTHER_MONEY_VALUE) AS CEK_KARSILIKSIZ,
				SUM(CHEQUE.OTHER_MONEY_VALUE2) AS CEK_KARSILIKSIZ2,
				0 AS SENET_ODENMEDI,
				0 AS SENET_ODENMEDI2,
				0 AS SENET_KARSILIKSIZ,
				0 AS SENET_KARSILIKSIZ2,
				0 AS FORWARD_SALE_LIMIT,
				0 AS OPEN_ACCOUNT_RISK_LIMIT,
				0 AS PAYMENT_BLOKAJ,
				0 AS TOTAL_RISK_LIMIT,
				0 AS SECURE_TOTAL_TAKE,
				0 AS SECURE_TOTAL_TAKE2,
				0 AS SECURE_TOTAL_GIVE,
				0 AS SECURE_TOTAL_GIVE2,
				CHEQUE.COMPANY_ID
			FROM
				CHEQUE
			WHERE
				CHEQUE.CHEQUE_ID IS NOT NULL AND
				CHEQUE.CHEQUE_STATUS_ID = 5 
			GROUP BY
				CHEQUE.COMPANY_ID
					
		UNION ALL
				
			SELECT
				0 AS BORC,
				0 AS BORC2,
				0 AS ALACAK,
				0 AS ALACAK2,
				0 AS BAKIYE,
				0 AS BAKIYE2,
				0 AS VADE_BORC,
				0 AS VADE_ALACAK,
				0 AS VADE_BORC_NEW,
				0 AS VADE_ALACAK_NEW,
				0 AS CEK_ODENMEDI,
				0 AS CEK_ODENMEDI2,
				0 AS CEK_KARSILIKSIZ,
				0 AS CEK_KARSILIKSIZ2,
				(SELECT OTHER_REMAINING_VALUE FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) AS SENET_ODENMEDI,
				(SELECT OTHER_REMAINING_VALUE2 FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) AS SENET_ODENMEDI2,
				0 AS SENET_KARSILIKSIZ,
				0 AS SENET_KARSILIKSIZ2,
				0 AS FORWARD_SALE_LIMIT,
				0 AS OPEN_ACCOUNT_RISK_LIMIT,
				0 AS PAYMENT_BLOKAJ,
				0 AS TOTAL_RISK_LIMIT,
				0 AS SECURE_TOTAL_TAKE,
				0 AS SECURE_TOTAL_TAKE2,
				0 AS SECURE_TOTAL_GIVE,
				0 AS SECURE_TOTAL_GIVE2,
				V.COMPANY_ID
			FROM
				VOUCHER V
			WHERE
				V.VOUCHER_ID IS NOT NULL AND
				V.VOUCHER_STATUS_ID IN (1,2,13,11)
				AND V.COMPANY_ID IS NOT NULL 

		UNION ALL
				
			SELECT
				0 AS BORC,
				0 AS BORC2,
				0 AS ALACAK,
				0 AS ALACAK2,
				0 AS BAKIYE,
				0 AS BAKIYE2,
				0 AS VADE_BORC,
				0 AS VADE_ALACAK,
				0 AS VADE_BORC_NEW,
				0 AS VADE_ALACAK_NEW,
				0 AS CEK_ODENMEDI,
				0 AS CEK_ODENMEDI2,
				0 AS CEK_KARSILIKSIZ,
				0 AS CEK_KARSILIKSIZ2,
				(SELECT OTHER_REMAINING_VALUE FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) AS SENET_ODENMEDI,
				(SELECT OTHER_REMAINING_VALUE2 FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) AS SENET_ODENMEDI2,
				0 AS SENET_KARSILIKSIZ,
				0 AS SENET_KARSILIKSIZ2,
				0 AS FORWARD_SALE_LIMIT,
				0 AS OPEN_ACCOUNT_RISK_LIMIT,
				0 AS PAYMENT_BLOKAJ,
				0 AS TOTAL_RISK_LIMIT,
				0 AS SECURE_TOTAL_TAKE,
				0 AS SECURE_TOTAL_TAKE2,
				0 AS SECURE_TOTAL_GIVE,
				0 AS SECURE_TOTAL_GIVE2,
				V.OWNER_COMPANY_ID COMPANY_ID
			FROM
				VOUCHER V
			WHERE
				V.VOUCHER_ID IS NOT NULL AND
				V.VOUCHER_STATUS_ID = 4 AND					
				V.VOUCHER_DUEDATE > GETDATE()
				AND V.OWNER_COMPANY_ID IS NOT NULL 

		UNION ALL
			
			SELECT
				0 AS BORC,
				0 AS BORC2,
				0 AS ALACAK,
				0 AS ALACAK2,
				0 AS BAKIYE,
				0 AS BAKIYE2,
				0 AS VADE_BORC,
				0 AS VADE_ALACAK,
				0 AS VADE_BORC_NEW,
				0 AS VADE_ALACAK_NEW,
				0 AS CEK_ODENMEDI,
				0 AS CEK_ODENMEDI2,
				0 AS CEK_KARSILIKSIZ,
				0 AS CEK_KARSILIKSIZ2,
				0 AS SENET_ODENMEDI,
				0 AS SENET_ODENMEDI2,
				(SELECT OTHER_REMAINING_VALUE FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) AS SENET_KARSILIKSIZ,
				(SELECT OTHER_REMAINING_VALUE2 FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) AS SENET_KARSILIKSIZ2,
				0 AS FORWARD_SALE_LIMIT,
				0 AS OPEN_ACCOUNT_RISK_LIMIT,
				0 AS PAYMENT_BLOKAJ,
				0 AS TOTAL_RISK_LIMIT,
				0 AS SECURE_TOTAL_TAKE,
				0 AS SECURE_TOTAL_TAKE2,
				0 AS SECURE_TOTAL_GIVE,
				0 AS SECURE_TOTAL_GIVE2,
				V.COMPANY_ID
			FROM
				VOUCHER V
			WHERE
				V.VOUCHER_ID IS NOT NULL AND
				V.VOUCHER_STATUS_ID= 5 
					
		UNION ALL
			
			SELECT 
				0 AS BORC,
				0 AS BORC2,
				0 AS ALACAK,
				0 AS ALACAK2,
				0 AS BAKIYE,
				0 AS BAKIYE2,
				0 AS VADE_BORC,
				0 AS VADE_ALACAK,
				0 AS VADE_BORC_NEW,
				0 AS VADE_ALACAK_NEW,
				0 AS CEK_ODENMEDI,
				0 AS CEK_ODENMEDI2,
				0 AS CEK_KARSILIKSIZ,
				0 AS CEK_KARSILIKSIZ2,
				0 AS SENET_ODENMEDI,
				0 AS SENET_ODENMEDI2,
				0 AS SENET_KARSILIKSIZ,
				0 AS SENET_KARSILIKSIZ2,
				CC.FORWARD_SALE_LIMIT_OTHER*(SM.RATE2/SM.RATE1) FORWARD_SALE_LIMIT,
				CC.OPEN_ACCOUNT_RISK_LIMIT_OTHER*(SM.RATE2/SM.RATE1) OPEN_ACCOUNT_RISK_LIMIT,
				CC.PAYMENT_BLOKAJ*(SM.RATE2/SM.RATE1) PAYMENT_BLOKAJ,
				CC.TOTAL_RISK_LIMIT_OTHER*(SM.RATE2/SM.RATE1) TOTAL_RISK_LIMIT,
				0 AS SECURE_TOTAL_TAKE,
				0 AS SECURE_TOTAL_TAKE2,
				0 AS SECURE_TOTAL_GIVE,
				0 AS SECURE_TOTAL_GIVE2,
				CC.COMPANY_ID
			FROM 
				#new_dsn#.COMPANY_CREDIT CC,
				SETUP_MONEY SM
			WHERE
				CC.MONEY = SM.MONEY AND				
				CC.OUR_COMPANY_ID = #get_periods.OUR_COMPANY_ID# AND
				CC.COMPANY_ID IS NOT NULL	
			
		UNION ALL
		
			SELECT 
				0 AS BORC,
				0 AS BORC2,
				0 AS ALACAK,
				0 AS ALACAK2,
				0 AS BAKIYE,
				0 AS BAKIYE2,
				0 AS VADE_BORC,
				0 AS VADE_ALACAK,
				0 AS VADE_BORC_NEW,
				0 AS VADE_ALACAK_NEW,
				0 AS CEK_ODENMEDI,
				0 AS CEK_ODENMEDI2,
				0 AS CEK_KARSILIKSIZ,
				0 AS CEK_KARSILIKSIZ2,
				0 AS SENET_ODENMEDI,
				0 AS SENET_ODENMEDI2,
				0 AS SENET_KARSILIKSIZ,
				0 AS SENET_KARSILIKSIZ2,
				0 AS FORWARD_SALE_LIMIT,
				0 AS OPEN_ACCOUNT_RISK_LIMIT,
				0 AS PAYMENT_BLOKAJ,
				0 AS TOTAL_RISK_LIMIT,
				SUM(CS.ACTION_VALUE) AS SECURE_TOTAL_TAKE,
				SUM(CS.ACTION_VALUE2) AS SECURE_TOTAL_TAKE2,
				0 AS SECURE_TOTAL_GIVE,
				0 AS SECURE_TOTAL_GIVE2,
				CS.COMPANY_ID
			FROM 
				#new_dsn#.COMPANY_SECUREFUND CS
			WHERE 
				CS.GIVE_TAKE = 0 AND
				CS.FINISH_DATE > GETDATE() AND
				CS.OUR_COMPANY_ID =#get_periods.OUR_COMPANY_ID# AND
				CS.SECUREFUND_STATUS = 1 AND
                CS.IS_RETURN IS NULL AND --iade edilen teminatlarin risk tutarından dusulmesi gerekir
				CS.COMPANY_ID IS NOT NULL
			GROUP BY
				CS.COMPANY_ID
			
		UNION ALL
		
			SELECT 
				0 AS BORC,
				0 AS BORC2,
				0 AS ALACAK,
				0 AS ALACAK2,
				0 AS BAKIYE,
				0 AS BAKIYE2,
				0 AS VADE_BORC,
				0 AS VADE_ALACAK,
				0 AS VADE_BORC_NEW,
				0 AS VADE_ALACAK_NEW,
				0 AS CEK_ODENMEDI,
				0 AS CEK_ODENMEDI2,
				0 AS CEK_KARSILIKSIZ,
				0 AS CEK_KARSILIKSIZ2,
				0 AS SENET_ODENMEDI,
				0 AS SENET_ODENMEDI2,
				0 AS SENET_KARSILIKSIZ,
				0 AS SENET_KARSILIKSIZ2,
				0 AS FORWARD_SALE_LIMIT,
				0 AS OPEN_ACCOUNT_RISK_LIMIT,
				0 AS PAYMENT_BLOKAJ,
				0 AS TOTAL_RISK_LIMIT,
				0 AS SECURE_TOTAL_TAKE,
				0 AS SECURE_TOTAL_TAKE2,
				SUM(CS.ACTION_VALUE) AS SECURE_TOTAL_GIVE,
				SUM(CS.ACTION_VALUE2) AS SECURE_TOTAL_GIVE2,
				CS.COMPANY_ID
			FROM 
				#new_dsn#.COMPANY_SECUREFUND CS
			WHERE 
				CS.GIVE_TAKE = 1 AND
				CS.FINISH_DATE > GETDATE() AND
				CS.OUR_COMPANY_ID = #get_periods.OUR_COMPANY_ID# AND
				CS.SECUREFUND_STATUS = 1 AND
                CS.IS_RETURN IS NULL AND --iade edilen teminatlarin risk tutarından dusulmesi gerekir
				CS.COMPANY_ID IS NOT NULL
			GROUP BY
				CS.COMPANY_ID
				) AS Q1
			GROUP BY
				Q1.COMPANY_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [COMPANY_RISK_MONEY] AS
			SELECT 
				SUM( Q1.BORC ) AS BORC,
				SUM( Q1.BORC3 ) AS BORC2,
				SUM( Q1.ALACAK ) AS ALACAK,
				SUM( Q1.ALACAK3 ) AS ALACAK2,
				SUM( Q1.BAKIYE ) AS BAKIYE,
				SUM( Q1.BAKIYE3 ) AS BAKIYE2,
				SUM( Q1.VADE_BORC ) AS VADE_BORC,
				SUM( Q1.VADE_ALACAK ) AS VADE_ALACAK,
				SUM( Q1.VADE_BORC_NEW ) AS VADE_BORC_NEW,
				SUM( Q1.VADE_ALACAK_NEW ) AS VADE_ALACAK_NEW,
				SUM( Q1.CEK_ODENMEDI ) AS CEK_ODENMEDI,
				SUM( Q1.CEK_ODENMEDI3 ) AS CEK_ODENMEDI2,
				SUM( Q1.CEK_KARSILIKSIZ ) AS CEK_KARSILIKSIZ,
				SUM( Q1.CEK_KARSILIKSIZ3 ) AS CEK_KARSILIKSIZ2,
				SUM( Q1.SENET_ODENMEDI ) AS SENET_ODENMEDI,
				SUM( Q1.SENET_ODENMEDI3 ) AS SENET_ODENMEDI2,
				SUM( Q1.SENET_KARSILIKSIZ ) AS SENET_KARSILIKSIZ,
				SUM( Q1.SENET_KARSILIKSIZ3) AS SENET_KARSILIKSIZ2,
				SUM( Q1.FORWARD_SALE_LIMIT ) AS FORWARD_SALE_LIMIT,
				SUM( Q1.OPEN_ACCOUNT_RISK_LIMIT ) AS OPEN_ACCOUNT_RISK_LIMIT,
				SUM( Q1.TOTAL_RISK_LIMIT ) AS TOTAL_RISK_LIMIT,
				SUM( Q1.FORWARD_SALE_LIMIT3 ) AS FORWARD_SALE_LIMIT3,
				SUM( Q1.OPEN_ACCOUNT_RISK_LIMIT3 ) AS OPEN_ACCOUNT_RISK_LIMIT3,
				SUM( Q1.TOTAL_RISK_LIMIT3 ) AS TOTAL_RISK_LIMIT3,
				SUM( Q1.SECURE_TOTAL_TAKE ) AS SECURE_TOTAL_TAKE,
				SUM( Q1.SECURE_TOTAL_TAKE3 ) AS SECURE_TOTAL_TAKE2,
				SUM( Q1.SECURE_TOTAL_GIVE ) AS SECURE_TOTAL_GIVE,
				SUM( Q1.SECURE_TOTAL_GIVE3 ) AS SECURE_TOTAL_GIVE2,
				Q1.COMPANY_ID,
				Q1.OTHER_MONEY
			FROM
				(
				SELECT 
					BORC,
					BORC3,
					ALACAK,
					ALACAK3,
					BAKIYE,
					BAKIYE3,
					VADE_BORC3 VADE_BORC,
					VADE_ALACAK3 VADE_ALACAK,
					VADE_BORC_NEW3 VADE_BORC_NEW,
					VADE_ALACAK_NEW3 VADE_ALACAK_NEW,
					0 AS CEK_ODENMEDI,
					0 AS CEK_ODENMEDI3,
					0 AS CEK_KARSILIKSIZ,
					0 AS CEK_KARSILIKSIZ3,
					0 AS SENET_ODENMEDI,
					0 AS SENET_ODENMEDI3,
					0 AS SENET_KARSILIKSIZ,
					0 AS SENET_KARSILIKSIZ3,
					0 AS FORWARD_SALE_LIMIT,
					0 AS OPEN_ACCOUNT_RISK_LIMIT,
					0 AS TOTAL_RISK_LIMIT,
					0 AS FORWARD_SALE_LIMIT3,
					0 AS OPEN_ACCOUNT_RISK_LIMIT3,
					0 AS TOTAL_RISK_LIMIT3,
					0 AS SECURE_TOTAL_TAKE,
					0 AS SECURE_TOTAL_TAKE3,
					0 AS SECURE_TOTAL_GIVE,
					0 AS SECURE_TOTAL_GIVE3,
					COMPANY_ID,
					OTHER_MONEY
				FROM 
					COMPANY_REMAINDER_MONEY
						
			UNION ALL

			SELECT
				0 AS BORC,
				0 AS BORC3,
				0 AS ALACAK,
				0 AS ALACAK3,
				0 AS BAKIYE,
				0 AS BAKIYE3,
				0 AS VADE_BORC,
				0 AS VADE_ALACAK,
				0 AS VADE_BORC_NEW,
				0 AS VADE_ALACAK_NEW,
				SUM(CHEQUE.OTHER_MONEY_VALUE) AS CEK_ODENMEDI,
				SUM(ISNULL(CHEQUE.CH_OTHER_MONEY_VALUE,CHEQUE.CHEQUE_VALUE)) AS CEK_ODENMEDI3,
				0 AS CEK_KARSILIKSIZ,
				0 AS CEK_KARSILIKSIZ3,
				0 AS SENET_ODENMEDI,
				0 AS SENET_ODENMEDI3,
				0 AS SENET_KARSILIKSIZ,
				0 AS SENET_KARSILIKSIZ3,
				0 AS FORWARD_SALE_LIMIT,
				0 AS OPEN_ACCOUNT_RISK_LIMIT,
				0 AS TOTAL_RISK_LIMIT,
				0 AS FORWARD_SALE_LIMIT3,
				0 AS OPEN_ACCOUNT_RISK_LIMIT3,
				0 AS TOTAL_RISK_LIMIT3,
				0 AS SECURE_TOTAL_TAKE,
				0 AS SECURE_TOTAL_TAKE3,
				0 AS SECURE_TOTAL_GIVE,
				0 AS SECURE_TOTAL_GIVE3,
				CHEQUE.COMPANY_ID,
				ISNULL(CHEQUE.CH_OTHER_MONEY,CHEQUE.CURRENCY_ID) OTHER_MONEY
			FROM
				CHEQUE
			WHERE
				CHEQUE.CHEQUE_ID IS NOT NULL AND
				CHEQUE.CHEQUE_STATUS_ID IN (1,2,13)
				AND CHEQUE.COMPANY_ID IS NOT NULL 
			GROUP BY
				CHEQUE.COMPANY_ID,
				ISNULL(CHEQUE.CH_OTHER_MONEY,CHEQUE.CURRENCY_ID)
		UNION ALL
			SELECT
				0 AS BORC,
				0 AS BORC3,
				0 AS ALACAK,
				0 AS ALACAK3,
				0 AS BAKIYE,
				0 AS BAKIYE3,
				0 AS VADE_BORC,
				0 AS VADE_ALACAK,
				0 AS VADE_BORC_NEW,
				0 AS VADE_ALACAK_NEW,
				SUM(CHEQUE.OTHER_MONEY_VALUE) AS CEK_ODENMEDI,
				SUM(ISNULL(CHEQUE.CH_OTHER_MONEY_VALUE,CHEQUE.CHEQUE_VALUE)) AS CEK_ODENMEDI3,
				0 AS CEK_KARSILIKSIZ,
				0 AS CEK_KARSILIKSIZ3,
				0 AS SENET_ODENMEDI,
				0 AS SENET_ODENMEDI3,
				0 AS SENET_KARSILIKSIZ,
				0 AS SENET_KARSILIKSIZ3,
				0 AS FORWARD_SALE_LIMIT,
				0 AS OPEN_ACCOUNT_RISK_LIMIT,
				0 AS TOTAL_RISK_LIMIT,
				0 AS FORWARD_SALE_LIMIT3,
				0 AS OPEN_ACCOUNT_RISK_LIMIT3,
				0 AS TOTAL_RISK_LIMIT3,
				0 AS SECURE_TOTAL_TAKE,
				0 AS SECURE_TOTAL_TAKE3,
				0 AS SECURE_TOTAL_GIVE,
				0 AS SECURE_TOTAL_GIVE3,
				CHEQUE.OWNER_COMPANY_ID COMPANY_ID,
				ISNULL(CHEQUE.CH_OTHER_MONEY,CHEQUE.CURRENCY_ID) OTHER_MONEY
			FROM
				CHEQUE
			WHERE
				CHEQUE.CHEQUE_ID IS NOT NULL AND
				CHEQUE.CHEQUE_STATUS_ID = 4 AND
				CHEQUE.CHEQUE_DUEDATE > GETDATE()
				AND CHEQUE.OWNER_COMPANY_ID IS NOT NULL 
			GROUP BY
				CHEQUE.OWNER_COMPANY_ID,
				ISNULL(CHEQUE.CH_OTHER_MONEY,CHEQUE.CURRENCY_ID)
		UNION ALL
			SELECT
				0 AS BORC,
				0 AS BORC3,
				0 AS ALACAK,
				0 AS ALACAK3,
				0 AS BAKIYE,
				0 AS BAKIYE3,
				0 AS VADE_BORC,
				0 AS VADE_ALACAK,
				0 AS VADE_BORC_NEW,
				0 AS VADE_ALACAK_NEW,
				0 AS CEK_ODENMEDI,
				0 AS CEK_ODENMEDI3,
				SUM(CHEQUE.OTHER_MONEY_VALUE) AS CEK_KARSILIKSIZ,
				SUM(ISNULL(CHEQUE.CH_OTHER_MONEY_VALUE,CHEQUE.CHEQUE_VALUE)) AS CEK_KARSILIKSIZ3,
				0 AS SENET_ODENMEDI,
				0 AS SENET_ODENMEDI3,
				0 AS SENET_KARSILIKSIZ,
				0 AS SENET_KARSILIKSIZ3,
				0 AS FORWARD_SALE_LIMIT,
				0 AS OPEN_ACCOUNT_RISK_LIMIT,	
				0 AS TOTAL_RISK_LIMIT,
				0 AS FORWARD_SALE_LIMIT3,
				0 AS OPEN_ACCOUNT_RISK_LIMIT3,
				0 AS TOTAL_RISK_LIMIT3,
				0 AS SECURE_TOTAL_TAKE,

				0 AS SECURE_TOTAL_TAKE3,
				0 AS SECURE_TOTAL_GIVE,
				0 AS SECURE_TOTAL_GIVE3,
				CHEQUE.COMPANY_ID,
				ISNULL(CHEQUE.CH_OTHER_MONEY,CHEQUE.CURRENCY_ID) OTHER_MONEY
			FROM
				CHEQUE
			WHERE
				CHEQUE.CHEQUE_ID IS NOT NULL AND
				CHEQUE.CHEQUE_STATUS_ID = 5 
			GROUP BY
				CHEQUE.COMPANY_ID,
				ISNULL(CHEQUE.CH_OTHER_MONEY,CHEQUE.CURRENCY_ID)
		UNION ALL
			SELECT
				0 AS BORC,
				0 AS BORC3,
				0 AS ALACAK,
				0 AS ALACAK3,
				0 AS BAKIYE,
				0 AS BAKIYE3,
				0 AS VADE_BORC,
				0 AS VADE_ALACAK,
				0 AS VADE_BORC_NEW,
				0 AS VADE_ALACAK_NEW,
				0 AS CEK_ODENMEDI,
				0 AS CEK_ODENMEDI3,
				0 AS CEK_KARSILIKSIZ,
				0 AS CEK_KARSILIKSIZ3,
				(SELECT OTHER_REMAINING_VALUE FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) AS SENET_ODENMEDI,
				(SELECT REMAINING_VALUE FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) AS SENET_ODENMEDI3,
				0 AS SENET_KARSILIKSIZ,
				0 AS SENET_KARSILIKSIZ3,
				0 AS FORWARD_SALE_LIMIT,
				0 AS OPEN_ACCOUNT_RISK_LIMIT,
				0 AS TOTAL_RISK_LIMIT,
				0 AS FORWARD_SALE_LIMIT3,
				0 AS OPEN_ACCOUNT_RISK_LIMIT3,
				0 AS TOTAL_RISK_LIMIT3,
				0 AS SECURE_TOTAL_TAKE,
				0 AS SECURE_TOTAL_TAKE3,
				0 AS SECURE_TOTAL_GIVE,
				0 AS SECURE_TOTAL_GIVE3,
				V.COMPANY_ID,
				ISNULL(V.CH_OTHER_MONEY,V.CURRENCY_ID) OTHER_MONEY
			FROM
				VOUCHER V
			WHERE
				V.VOUCHER_ID IS NOT NULL AND
				V.VOUCHER_STATUS_ID IN (1,2,13,11)
				AND V.COMPANY_ID IS NOT NULL 
		UNION ALL
			SELECT
				0 AS BORC,
				0 AS BORC3,
				0 AS ALACAK,
				0 AS ALACAK3,
				0 AS BAKIYE,
				0 AS BAKIYE3,
				0 AS VADE_BORC,
				0 AS VADE_ALACAK,
				0 AS VADE_BORC_NEW,
				0 AS VADE_ALACAK_NEW,
				0 AS CEK_ODENMEDI,
				0 AS CEK_ODENMEDI3,
				0 AS CEK_KARSILIKSIZ,
				0 AS CEK_KARSILIKSIZ3,
				(SELECT OTHER_REMAINING_VALUE FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) AS SENET_ODENMEDI,
				(SELECT REMAINING_VALUE FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) AS SENET_ODENMEDI3,
				0 AS SENET_KARSILIKSIZ,
				0 AS SENET_KARSILIKSIZ3,
				0 AS FORWARD_SALE_LIMIT,
				0 AS OPEN_ACCOUNT_RISK_LIMIT,
				0 AS TOTAL_RISK_LIMIT,
				0 AS FORWARD_SALE_LIMIT3,
				0 AS OPEN_ACCOUNT_RISK_LIMIT3,
				0 AS TOTAL_RISK_LIMIT3,
				0 AS SECURE_TOTAL_TAKE,
				0 AS SECURE_TOTAL_TAKE3,
				0 AS SECURE_TOTAL_GIVE,
				0 AS SECURE_TOTAL_GIVE3,
				V.OWNER_COMPANY_ID COMPANY_ID,
				ISNULL(V.CH_OTHER_MONEY,V.CURRENCY_ID) OTHER_MONEY
			FROM
				VOUCHER V
			WHERE
				V.VOUCHER_ID IS NOT NULL AND
				V.VOUCHER_STATUS_ID = 4 AND
				V.VOUCHER_DUEDATE > GETDATE()	
				AND V.OWNER_COMPANY_ID IS NOT NULL 
		UNION ALL
			SELECT
				0 AS BORC,
				0 AS BORC3,
				0 AS ALACAK,
				0 AS ALACAK3,
				0 AS BAKIYE,
				0 AS BAKIYE3,
				0 AS VADE_BORC,
				0 AS VADE_ALACAK,
				0 AS VADE_BORC_NEW,
				0 AS VADE_ALACAK_NEW,
				0 AS CEK_ODENMEDI,
				0 AS CEK_ODENMEDI3,
				0 AS CEK_KARSILIKSIZ,
				0 AS CEK_KARSILIKSIZ3,
				0 AS SENET_ODENMEDI,
				0 AS SENET_ODENMEDI3,
				(SELECT OTHER_REMAINING_VALUE FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) AS SENET_KARSILIKSIZ,
				(SELECT REMAINING_VALUE FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) AS SENET_KARSILIKSIZ3,
				0 AS FORWARD_SALE_LIMIT,
				0 AS OPEN_ACCOUNT_RISK_LIMIT,
				0 AS TOTAL_RISK_LIMIT,
				0 AS FORWARD_SALE_LIMIT3,
				0 AS OPEN_ACCOUNT_RISK_LIMIT3,
				0 AS TOTAL_RISK_LIMIT3,
				0 AS SECURE_TOTAL_TAKE,
				0 AS SECURE_TOTAL_TAKE3,
				0 AS SECURE_TOTAL_GIVE,
				0 AS SECURE_TOTAL_GIVE3,
				V.COMPANY_ID,
				ISNULL(V.CH_OTHER_MONEY,V.CURRENCY_ID) OTHER_MONEY
			FROM
				VOUCHER V
			WHERE
				V.VOUCHER_ID IS NOT NULL AND
				V.VOUCHER_STATUS_ID= 5 
						
			UNION ALL
				
				SELECT 
					0 AS BORC,
					0 AS BORC3,
					0 AS ALACAK,
					0 AS ALACAK3,
					0 AS BAKIYE,
					0 AS BAKIYE3,
					0 AS VADE_BORC,
					0 AS VADE_ALACAK,
					0 AS VADE_BORC_NEW,
					0 AS VADE_ALACAK_NEW,
					0 AS CEK_ODENMEDI,
					0 AS CEK_ODENMEDI3,
					0 AS CEK_KARSILIKSIZ,
					0 AS CEK_KARSILIKSIZ3,
					0 AS SENET_ODENMEDI,
					0 AS SENET_ODENMEDI3,
					0 AS SENET_KARSILIKSIZ,
					0 AS SENET_KARSILIKSIZ3,
					CC.FORWARD_SALE_LIMIT_OTHER*(SM.RATE2/SM.RATE1) FORWARD_SALE_LIMIT,
					CC.OPEN_ACCOUNT_RISK_LIMIT_OTHER*(SM.RATE2/SM.RATE1) OPEN_ACCOUNT_RISK_LIMIT,
					CC.TOTAL_RISK_LIMIT_OTHER*(SM.RATE2/SM.RATE1) TOTAL_RISK_LIMIT,
					CC.FORWARD_SALE_LIMIT_OTHER FORWARD_SALE_LIMIT3,
					CC.OPEN_ACCOUNT_RISK_LIMIT_OTHER OPEN_ACCOUNT_RISK_LIMIT3,
					CC.TOTAL_RISK_LIMIT_OTHER TOTAL_RISK_LIMIT3,
					0 AS SECURE_TOTAL_TAKE,
					0 AS SECURE_TOTAL_TAKE3,
					0 AS SECURE_TOTAL_GIVE,
					0 AS SECURE_TOTAL_GIVE3,
					CC.COMPANY_ID,
					CC.MONEY OTHER_MONEY
				FROM 
					#new_dsn#.COMPANY_CREDIT CC,
					SETUP_MONEY SM
				WHERE
					CC.MONEY = SM.MONEY AND					
					CC.OUR_COMPANY_ID = #get_periods.OUR_COMPANY_ID# AND
					CC.COMPANY_ID IS NOT NULL	
				
			UNION ALL
			
				SELECT 
					0 AS BORC,
					0 AS BORC3,
					0 AS ALACAK,
					0 AS ALACAK3,
					0 AS BAKIYE,
					0 AS BAKIYE3,
					0 AS VADE_BORC,
					0 AS VADE_ALACAK,
					0 AS VADE_BORC_NEW,
					0 AS VADE_ALACAK_NEW,
					0 AS CEK_ODENMEDI,
					0 AS CEK_ODENMEDI3,
					0 AS CEK_KARSILIKSIZ,
					0 AS CEK_KARSILIKSIZ3,
					0 AS SENET_ODENMEDI,
					0 AS SENET_ODENMEDI3,
					0 AS SENET_KARSILIKSIZ,
					0 AS SENET_KARSILIKSIZ3,
					0 AS FORWARD_SALE_LIMIT,
					0 AS OPEN_ACCOUNT_RISK_LIMIT,
					0 AS TOTAL_RISK_LIMIT,
					0 AS FORWARD_SALE_LIMIT3,
					0 AS OPEN_ACCOUNT_RISK_LIMIT3,
					0 AS TOTAL_RISK_LIMIT3,
					SUM(CS.ACTION_VALUE) AS SECURE_TOTAL_TAKE,
					SUM(CS.SECUREFUND_TOTAL) AS SECURE_TOTAL_TAKE3,
					0 AS SECURE_TOTAL_GIVE,
					0 AS SECURE_TOTAL_GIVE3,
					CS.COMPANY_ID,
					CS.MONEY_CAT OTHER_MONEY
				FROM 
					#new_dsn#.COMPANY_SECUREFUND CS
				WHERE 
					CS.GIVE_TAKE = 0 AND
					CS.FINISH_DATE > GETDATE() AND
					CS.OUR_COMPANY_ID=#get_periods.OUR_COMPANY_ID# AND
					CS.SECUREFUND_STATUS = 1 AND
                    CS.IS_RETURN IS NULL AND --iade edilen teminatlarin risk tutarından dusulmesi gerekir
					CS.COMPANY_ID IS NOT NULL
				GROUP BY
					CS.COMPANY_ID,
					CS.MONEY_CAT
				
			UNION ALL
			
				SELECT 
					0 AS BORC,
					0 AS BORC3,
					0 AS ALACAK,
					0 AS ALACAK3,
					0 AS BAKIYE,
					0 AS BAKIYE3,
					0 AS VADE_BORC,
					0 AS VADE_ALACAK,
					0 AS VADE_BORC_NEW,
					0 AS VADE_ALACAK_NEW,
					0 AS CEK_ODENMEDI,
					0 AS CEK_ODENMEDI3,
					0 AS CEK_KARSILIKSIZ,
					0 AS CEK_KARSILIKSIZ3,
					0 AS SENET_ODENMEDI,
					0 AS SENET_ODENMEDI3,
					0 AS SENET_KARSILIKSIZ,
					0 AS SENET_KARSILIKSIZ3,
					0 AS FORWARD_SALE_LIMIT,
					0 AS OPEN_ACCOUNT_RISK_LIMIT,
					0 AS TOTAL_RISK_LIMIT,
					0 AS FORWARD_SALE_LIMIT3,
					0 AS OPEN_ACCOUNT_RISK_LIMIT3,
					0 AS TOTAL_RISK_LIMIT3,
					0 AS SECURE_TOTAL_TAKE,
					0 AS SECURE_TOTAL_TAKE3,
					SUM(CS.ACTION_VALUE) AS SECURE_TOTAL_GIVE,
					SUM(CS.SECUREFUND_TOTAL) AS SECURE_TOTAL_GIVE3,
					CS.COMPANY_ID,
					CS.MONEY_CAT OTHER_MONEY
				FROM 
					#new_dsn#.COMPANY_SECUREFUND CS
				WHERE 
					CS.GIVE_TAKE = 1 AND
					CS.FINISH_DATE > GETDATE() AND
					CS.OUR_COMPANY_ID=#get_periods.OUR_COMPANY_ID# AND
					CS.SECUREFUND_STATUS = 1 AND
                    CS.IS_RETURN IS NULL AND --iade edilen teminatlarin risk tutarından dusulmesi gerekir
					CS.COMPANY_ID IS NOT NULL
				GROUP BY
					CS.COMPANY_ID,
					CS.MONEY_CAT
					) AS Q1
				GROUP BY
					Q1.COMPANY_ID,
					Q1.OTHER_MONEY

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [CONSUMER_REMAINDER] AS
			SELECT
				CONSUMER_ID, 
				ROUND(SUM(BORC-ALACAK),5) AS BAKIYE, 
				ROUND(SUM(BORC2-ALACAK2),5) AS BAKIYE2,
				ROUND(SUM(BORC),5) AS BORC,
				ROUND(SUM(BORC2),5) AS BORC2,
				ROUND(SUM(ALACAK),5) AS ALACAK,
				ROUND(SUM(ALACAK2),5) AS ALACAK2,
				CASE WHEN SUM(BORC)= 0 THEN SUM((BORC*DATE_DIFF)) ELSE ROUND((SUM((BORC*DATE_DIFF))/SUM(BORC)),0) END AS VADE_BORC,
				CASE WHEN SUM(ALACAK)= 0 THEN SUM((ALACAK*DATE_DIFF)) ELSE ROUND((SUM((ALACAK*DATE_DIFF))/SUM(ALACAK)),0) END AS VADE_ALACAK,	
				CASE WHEN SUM(BORC)= 0 THEN SUM((BORC*DUE_DATE_DIFF)) ELSE ROUND((SUM((BORC*DUE_DATE_DIFF))/SUM(BORC)),0) END AS VADE_BORC_NEW,
				CASE WHEN SUM(ALACAK)= 0 THEN SUM((ALACAK*DUE_DATE_DIFF)) ELSE ROUND((SUM((ALACAK*DUE_DATE_DIFF))/SUM(ALACAK)),0) END AS VADE_ALACAK_NEW
			FROM
				CARI_ROWS_CONSUMER
			GROUP BY
				CONSUMER_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [CONSUMER_REMAINDER_MONEY] AS
			SELECT
				CONSUMER_ID, 
				SUM(BORC-ALACAK) AS BAKIYE, 
				SUM(BORC2-ALACAK2) AS BAKIYE2,
				SUM(BORC3-ALACAK3) AS BAKIYE3,
				SUM(BORC) AS BORC,
				SUM(BORC2) AS BORC2,
				SUM(BORC3) AS BORC3,
				SUM(ALACAK) AS ALACAK,
				SUM(ALACAK2) AS ALACAK2,
				SUM(ALACAK3) AS ALACAK3,
				OTHER_MONEY,
				CASE WHEN SUM(BORC3)= 0 THEN SUM((BORC3*DATE_DIFF)) ELSE ROUND((SUM((BORC3*DATE_DIFF))/SUM(BORC3)),0) END AS VADE_BORC3,
				CASE WHEN SUM(ALACAK3)= 0 THEN SUM((ALACAK3*DATE_DIFF)) ELSE ROUND((SUM((ALACAK3*DATE_DIFF))/SUM(ALACAK3)),0) END AS VADE_ALACAK3,
				CASE WHEN SUM(BORC3)= 0 THEN SUM((BORC3*DUE_DATE_DIFF)) ELSE ROUND((SUM((BORC3*DUE_DATE_DIFF))/SUM(BORC3)),0) END AS VADE_BORC_NEW3,
				CASE WHEN SUM(ALACAK3)= 0 THEN SUM((ALACAK3*DUE_DATE_DIFF)) ELSE ROUND((SUM((ALACAK3*DUE_DATE_DIFF))/SUM(ALACAK3)),0) END AS VADE_ALACAK_NEW3
			FROM
				CARI_ROWS_CONSUMER
			GROUP BY
				CONSUMER_ID,
				OTHER_MONEY

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [CONSUMER_REMAINDER_PROJECT] AS
			SELECT
				CONSUMER_ID, 
				PROJECT_ID,
				ROUND(SUM(BORC-ALACAK),5) AS BAKIYE, 
				ROUND(SUM(BORC2-ALACAK2),5) AS BAKIYE2,
				ROUND(SUM(BORC),5) AS BORC,
				ROUND(SUM(BORC2),5) AS BORC2,
				ROUND(SUM(ALACAK),5) AS ALACAK,
				ROUND(SUM(ALACAK2),5) AS ALACAK2,
				CASE WHEN SUM(BORC)= 0 THEN SUM((BORC*DATE_DIFF)) ELSE ROUND((SUM((BORC*DATE_DIFF))/SUM(BORC)),0) END AS VADE_BORC,
				CASE WHEN SUM(ALACAK)= 0 THEN SUM((ALACAK*DATE_DIFF)) ELSE ROUND((SUM((ALACAK*DATE_DIFF))/SUM(ALACAK)),0) END AS VADE_ALACAK	
			FROM
				CARI_ROWS_CONSUMER
			GROUP BY
				CONSUMER_ID,
				PROJECT_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [CONSUMER_REMAINDER_MONEY_PROJECT] AS
			SELECT
				CONSUMER_ID, 
				OTHER_MONEY,
				PROJECT_ID,			
				SUM(BORC-ALACAK) AS BAKIYE, 
				SUM(BORC2-ALACAK2) AS BAKIYE2,
				SUM(BORC3-ALACAK3) AS BAKIYE3,
				SUM(BORC) AS BORC,
				SUM(BORC2) AS BORC2,
				SUM(BORC3) AS BORC3,
				SUM(ALACAK) AS ALACAK,
				SUM(ALACAK2) AS ALACAK2,
				SUM(ALACAK3) AS ALACAK3,
				CASE WHEN SUM(BORC3)= 0 THEN SUM((BORC3*DATE_DIFF)) ELSE ROUND((SUM((BORC3*DATE_DIFF))/SUM(BORC3)),0) END AS VADE_BORC3,
				CASE WHEN SUM(ALACAK3)= 0 THEN SUM((ALACAK3*DATE_DIFF)) ELSE ROUND((SUM((ALACAK3*DATE_DIFF))/SUM(ALACAK3)),0) END AS VADE_ALACAK3
			FROM
				CARI_ROWS_CONSUMER
			GROUP BY
				CONSUMER_ID,
				OTHER_MONEY,
				PROJECT_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [CONSUMER_RISK] AS	
		SELECT 
			SUM( Q1.BORC ) AS BORC,
			SUM( Q1.BORC2 ) AS BORC2,
			SUM( Q1.ALACAK ) AS ALACAK,
			SUM( Q1.ALACAK2 ) AS ALACAK2,
			SUM( Q1.BAKIYE ) AS BAKIYE,
			SUM( Q1.BAKIYE2 ) AS BAKIYE2,
			SUM( Q1.VADE_BORC ) AS VADE_BORC,
			SUM( Q1.VADE_ALACAK ) AS VADE_ALACAK,
			SUM( Q1.VADE_BORC_NEW ) AS VADE_BORC_NEW,
			SUM( Q1.VADE_ALACAK_NEW ) AS VADE_ALACAK_NEW,
			SUM( Q1.CEK_ODENMEDI ) AS CEK_ODENMEDI,
			SUM( Q1.CEK_ODENMEDI2 ) AS CEK_ODENMEDI2,
			SUM( Q1.CEK_KARSILIKSIZ ) AS CEK_KARSILIKSIZ,
			SUM( Q1.CEK_KARSILIKSIZ2 ) AS CEK_KARSILIKSIZ2,
			SUM( Q1.SENET_ODENMEDI ) AS SENET_ODENMEDI,
			SUM( Q1.SENET_ODENMEDI2 ) AS SENET_ODENMEDI2,
			SUM( Q1.SENET_KARSILIKSIZ ) AS SENET_KARSILIKSIZ,
			SUM( Q1.SENET_KARSILIKSIZ2) AS SENET_KARSILIKSIZ2,
			SUM( Q1.KEFIL_SENET_ODENMEDI ) AS KEFIL_SENET_ODENMEDI,
			SUM( Q1.KEFIL_SENET_ODENMEDI2 ) AS KEFIL_SENET_ODENMEDI2,
			SUM( Q1.KEFIL_SENET_KARSILIKSIZ ) AS KEFIL_SENET_KARSILIKSIZ,
			SUM( Q1.KEFIL_SENET_KARSILIKSIZ2) AS KEFIL_SENET_KARSILIKSIZ2,
			SUM( Q1.FORWARD_SALE_LIMIT ) AS FORWARD_SALE_LIMIT,
			SUM( Q1.OPEN_ACCOUNT_RISK_LIMIT ) AS OPEN_ACCOUNT_RISK_LIMIT,
			SUM( Q1.PAYMENT_BLOKAJ ) AS PAYMENT_BLOKAJ,
			SUM( Q1.TOTAL_RISK_LIMIT ) AS TOTAL_RISK_LIMIT,
			SUM( Q1.SECURE_TOTAL_TAKE ) AS SECURE_TOTAL_TAKE,
			SUM( Q1.SECURE_TOTAL_TAKE2 ) AS SECURE_TOTAL_TAKE2,
			SUM( Q1.SECURE_TOTAL_GIVE ) AS SECURE_TOTAL_GIVE,
			SUM( Q1.SECURE_TOTAL_GIVE2 ) AS SECURE_TOTAL_GIVE2,
			Q1.CONSUMER_ID
		FROM
			(
			SELECT 
				BORC,
				BORC2,
				ALACAK,
				ALACAK2,
				BAKIYE,
				BAKIYE2,
				VADE_BORC,
				VADE_ALACAK,
				VADE_BORC_NEW,
				VADE_ALACAK_NEW,
				0 AS CEK_ODENMEDI,
				0 AS CEK_ODENMEDI2,
				0 AS CEK_KARSILIKSIZ,
				0 AS CEK_KARSILIKSIZ2,
				0 AS SENET_ODENMEDI,
				0 AS SENET_ODENMEDI2,
				0 AS SENET_KARSILIKSIZ,
				0 AS SENET_KARSILIKSIZ2,
				0 AS KEFIL_SENET_ODENMEDI,
				0 AS KEFIL_SENET_ODENMEDI2,
				0 AS KEFIL_SENET_KARSILIKSIZ,
				0 AS KEFIL_SENET_KARSILIKSIZ2,
				0 AS FORWARD_SALE_LIMIT,
				0 AS OPEN_ACCOUNT_RISK_LIMIT,
				0 AS PAYMENT_BLOKAJ,
				0 AS TOTAL_RISK_LIMIT,
				0 AS SECURE_TOTAL_TAKE,
				0 AS SECURE_TOTAL_TAKE2,
				0 AS SECURE_TOTAL_GIVE,
				0 AS SECURE_TOTAL_GIVE2,
				CONSUMER_ID
			FROM 
				CONSUMER_REMAINDER
		UNION ALL
			SELECT
				0 AS BORC,
				0 AS BORC2,
				0 AS ALACAK,
				0 AS ALACAK2,
				0 AS BAKIYE,
				0 AS BAKIYE2,
				0 AS VADE_BORC,
				0 AS VADE_ALACAK,
				0 AS VADE_BORC_NEW,
				0 AS VADE_ALACAK_NEW,
				SUM(CHEQUE.OTHER_MONEY_VALUE) AS CEK_ODENMEDI,
				SUM(CHEQUE.OTHER_MONEY_VALUE2) AS CEK_ODENMEDI2,
				0 AS CEK_KARSILIKSIZ,
				0 AS CEK_KARSILIKSIZ2,
				0 AS SENET_ODENMEDI,
				0 AS SENET_ODENMEDI2,
				0 AS SENET_KARSILIKSIZ,
				0 AS SENET_KARSILIKSIZ2,
				0 AS KEFIL_SENET_ODENMEDI,
				0 AS KEFIL_SENET_ODENMEDI2,
				0 AS KEFIL_SENET_KARSILIKSIZ,
				0 AS KEFIL_SENET_KARSILIKSIZ2,
				0 AS FORWARD_SALE_LIMIT,
				0 AS OPEN_ACCOUNT_RISK_LIMIT,
				0 AS PAYMENT_BLOKAJ,
				0 AS TOTAL_RISK_LIMIT,
				0 AS SECURE_TOTAL_TAKE,
				0 AS SECURE_TOTAL_TAKE2,
				0 AS SECURE_TOTAL_GIVE,
				0 AS SECURE_TOTAL_GIVE2,
				CHEQUE.CONSUMER_ID
			FROM
				CHEQUE
			WHERE
				CHEQUE.CHEQUE_ID IS NOT NULL AND
				CHEQUE.CHEQUE_STATUS_ID IN (1,2,13)
				AND CHEQUE.CONSUMER_ID IS NOT NULL 
			GROUP BY
				CHEQUE.CONSUMER_ID
		UNION ALL
			SELECT
				0 AS BORC,
				0 AS BORC2,
				0 AS ALACAK,
				0 AS ALACAK2,
				0 AS BAKIYE,
				0 AS BAKIYE2,
				0 AS VADE_BORC,
				0 AS VADE_ALACAK,
				0 AS VADE_BORC_NEW,
				0 AS VADE_ALACAK_NEW,
				SUM(CHEQUE.OTHER_MONEY_VALUE) AS CEK_ODENMEDI,
				SUM(CHEQUE.OTHER_MONEY_VALUE2) AS CEK_ODENMEDI2,
				0 AS CEK_KARSILIKSIZ,
				0 AS CEK_KARSILIKSIZ2,
				0 AS SENET_ODENMEDI,
				0 AS SENET_ODENMEDI2,
				0 AS SENET_KARSILIKSIZ,
				0 AS SENET_KARSILIKSIZ2,
				0 AS KEFIL_SENET_ODENMEDI,
				0 AS KEFIL_SENET_ODENMEDI2,
				0 AS KEFIL_SENET_KARSILIKSIZ,
				0 AS KEFIL_SENET_KARSILIKSIZ2,
				0 AS FORWARD_SALE_LIMIT,
				0 AS OPEN_ACCOUNT_RISK_LIMIT,
				0 AS PAYMENT_BLOKAJ,
				0 AS TOTAL_RISK_LIMIT,
				0 AS SECURE_TOTAL_TAKE,
				0 AS SECURE_TOTAL_TAKE2,
				0 AS SECURE_TOTAL_GIVE,
				0 AS SECURE_TOTAL_GIVE2,
				CHEQUE.OWNER_CONSUMER_ID CONSUMER_ID
			FROM
				CHEQUE
			WHERE
				CHEQUE.CHEQUE_ID IS NOT NULL AND
				CHEQUE.CHEQUE_STATUS_ID = 4 AND
				CHEQUE.OWNER_CONSUMER_ID > GETDATE()	
				AND CHEQUE.CONSUMER_ID IS NOT NULL 
			GROUP BY
				CHEQUE.OWNER_CONSUMER_ID
		UNION ALL
			SELECT
				0 AS BORC,
				0 AS BORC2,
				0 AS ALACAK,
				0 AS ALACAK2,
				0 AS BAKIYE,
				0 AS BAKIYE2,
				0 AS VADE_BORC,
				0 AS VADE_ALACAK,
				0 AS VADE_BORC_NEW,
				0 AS VADE_ALACAK_NEW,
				0 AS CEK_ODENMEDI,
				0 AS CEK_ODENMEDI2,
				SUM(CHEQUE.OTHER_MONEY_VALUE) AS CEK_KARSILIKSIZ,
				SUM(CHEQUE.OTHER_MONEY_VALUE2) AS CEK_KARSILIKSIZ2,
				0 AS SENET_ODENMEDI,
				0 AS SENET_ODENMEDI2,
				0 AS SENET_KARSILIKSIZ,
				0 AS SENET_KARSILIKSIZ2,
				0 AS KEFIL_SENET_ODENMEDI,
				0 AS KEFIL_SENET_ODENMEDI2,
				0 AS KEFIL_SENET_KARSILIKSIZ,
				0 AS KEFIL_SENET_KARSILIKSIZ2,
				0 AS FORWARD_SALE_LIMIT,
				0 AS OPEN_ACCOUNT_RISK_LIMIT,
				0 AS PAYMENT_BLOKAJ,
	
				0 AS TOTAL_RISK_LIMIT,
				0 AS SECURE_TOTAL_TAKE,
				0 AS SECURE_TOTAL_TAKE2,
				0 AS SECURE_TOTAL_GIVE,
				0 AS SECURE_TOTAL_GIVE2,
				CHEQUE.CONSUMER_ID
			FROM
				CHEQUE
			WHERE
				CHEQUE.CHEQUE_ID IS NOT NULL AND
				CHEQUE.CHEQUE_STATUS_ID = 5 
			GROUP BY
				CHEQUE.CONSUMER_ID
		UNION ALL
			SELECT
				0 AS BORC,
				0 AS BORC2,
				0 AS ALACAK,
				0 AS ALACAK2,
				0 AS BAKIYE,
				0 AS BAKIYE2,
				0 AS VADE_BORC,
				0 AS VADE_ALACAK,
				0 AS VADE_BORC_NEW,
				0 AS VADE_ALACAK_NEW,
				0 AS CEK_ODENMEDI,
				0 AS CEK_ODENMEDI2,
				0 AS CEK_KARSILIKSIZ,
				0 AS CEK_KARSILIKSIZ2,
				(SELECT OTHER_REMAINING_VALUE FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) AS SENET_ODENMEDI,
				(SELECT OTHER_REMAINING_VALUE2 FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) AS SENET_ODENMEDI2,
				0 AS SENET_KARSILIKSIZ,
				0 AS SENET_KARSILIKSIZ2,
				0 AS KEFIL_SENET_ODENMEDI,
				0 AS KEFIL_SENET_ODENMEDI2,
				0 AS KEFIL_SENET_KARSILIKSIZ,
				0 AS KEFIL_SENET_KARSILIKSIZ2,
				0 AS FORWARD_SALE_LIMIT,
				0 AS OPEN_ACCOUNT_RISK_LIMIT,
				0 AS PAYMENT_BLOKAJ,
				0 AS TOTAL_RISK_LIMIT,
				0 AS SECURE_TOTAL_TAKE,
				0 AS SECURE_TOTAL_TAKE2,
				0 AS SECURE_TOTAL_GIVE,
				0 AS SECURE_TOTAL_GIVE2,
				V.CONSUMER_ID
			FROM
				VOUCHER V
			WHERE
				V.VOUCHER_ID IS NOT NULL AND
				V.VOUCHER_STATUS_ID IN (1,2,13,11)
				AND V.CONSUMER_ID IS NOT NULL 

		UNION ALL
			SELECT
				0 AS BORC,
				0 AS BORC2,
				0 AS ALACAK,
				0 AS ALACAK2,
				0 AS BAKIYE,
				0 AS BAKIYE2,
				0 AS VADE_BORC,
				0 AS VADE_ALACAK,
				0 AS VADE_BORC_NEW,
				0 AS VADE_ALACAK_NEW,
				0 AS CEK_ODENMEDI,
				0 AS CEK_ODENMEDI2,
				0 AS CEK_KARSILIKSIZ,
				0 AS CEK_KARSILIKSIZ2,
				(SELECT OTHER_REMAINING_VALUE FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) AS SENET_ODENMEDI,
				(SELECT OTHER_REMAINING_VALUE2 FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) AS SENET_ODENMEDI2,
				0 AS SENET_KARSILIKSIZ,
				0 AS SENET_KARSILIKSIZ2,
				0 AS KEFIL_SENET_ODENMEDI,
				0 AS KEFIL_SENET_ODENMEDI2,
				0 AS KEFIL_SENET_KARSILIKSIZ,
				0 AS KEFIL_SENET_KARSILIKSIZ2,
				0 AS FORWARD_SALE_LIMIT,
				0 AS OPEN_ACCOUNT_RISK_LIMIT,
				0 AS PAYMENT_BLOKAJ,
				0 AS TOTAL_RISK_LIMIT,
				0 AS SECURE_TOTAL_TAKE,
				0 AS SECURE_TOTAL_TAKE2,
				0 AS SECURE_TOTAL_GIVE,
				0 AS SECURE_TOTAL_GIVE2,
				V.OWNER_CONSUMER_ID CONSUMER_ID
			FROM
				VOUCHER V
			WHERE
				V.VOUCHER_ID IS NOT NULL AND
				V.VOUCHER_STATUS_ID = 4 AND
				V.VOUCHER_DUEDATE > GETDATE()
				AND V.OWNER_CONSUMER_ID IS NOT NULL 

		UNION ALL
			SELECT
				0 AS BORC,
				0 AS BORC2,
				0 AS ALACAK,
				0 AS ALACAK2,
				0 AS BAKIYE,
				0 AS BAKIYE2,
				0 AS VADE_BORC,
				0 AS VADE_ALACAK,
				0 AS VADE_BORC_NEW,
				0 AS VADE_ALACAK_NEW,
				0 AS CEK_ODENMEDI,
				0 AS CEK_ODENMEDI2,
				0 AS CEK_KARSILIKSIZ,
				0 AS CEK_KARSILIKSIZ2,
				0 AS SENET_ODENMEDI,
				0 AS SENET_ODENMEDI2,
				(SELECT OTHER_REMAINING_VALUE FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) AS SENET_KARSILIKSIZ,
				(SELECT OTHER_REMAINING_VALUE2 FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) AS SENET_KARSILIKSIZ2,
				0 AS KEFIL_SENET_ODENMEDI,
				0 AS KEFIL_SENET_ODENMEDI2,
				0 AS KEFIL_SENET_KARSILIKSIZ,
				0 AS KEFIL_SENET_KARSILIKSIZ2,
				0 AS FORWARD_SALE_LIMIT,
				0 AS OPEN_ACCOUNT_RISK_LIMIT,
				0 AS PAYMENT_BLOKAJ,
				0 AS TOTAL_RISK_LIMIT,
				0 AS SECURE_TOTAL_TAKE,
				0 AS SECURE_TOTAL_TAKE2,
				0 AS SECURE_TOTAL_GIVE,
				0 AS SECURE_TOTAL_GIVE2,
				V.CONSUMER_ID
			FROM
				VOUCHER V
			WHERE
				V.VOUCHER_ID IS NOT NULL AND
				V.VOUCHER_STATUS_ID= 5
		UNION ALL
			SELECT
				0 AS BORC,
				0 AS BORC2,
				0 AS ALACAK,
				0 AS ALACAK2,
				0 AS BAKIYE,
				0 AS BAKIYE2,
				0 AS VADE_BORC,
				0 AS VADE_ALACAK,
				0 AS VADE_BORC_NEW,
				0 AS VADE_ALACAK_NEW,
				0 AS CEK_ODENMEDI,
				0 AS CEK_ODENMEDI2,
				0 AS CEK_KARSILIKSIZ,
				0 AS CEK_KARSILIKSIZ2,
				0 AS SENET_ODENMEDI,
				0 AS SENET_ODENMEDI2,
				0 AS SENET_KARSILIKSIZ,
				0 AS SENET_KARSILIKSIZ2,
				SUM(VG.AMOUNT) AS KEFIL_SENET_ODENMEDI,
				SUM(VG.AMOUNT2) AS KEFIL_SENET_ODENMEDI2,
				0 AS KEFIL_SENET_KARSILIKSIZ,
				0 AS KEFIL_SENET_KARSILIKSIZ2,
				0 AS FORWARD_SALE_LIMIT,
				0 AS OPEN_ACCOUNT_RISK_LIMIT,
				0 AS PAYMENT_BLOKAJ,
				0 AS TOTAL_RISK_LIMIT,
				0 AS SECURE_TOTAL_TAKE,
				0 AS SECURE_TOTAL_TAKE2,
				0 AS SECURE_TOTAL_GIVE,
				0 AS SECURE_TOTAL_GIVE2,
				VG.CONSUMER_ID
			FROM
				VOUCHER V,
				VOUCHER_GUARANTORS VG
			WHERE
				V.VOUCHER_ID IS NOT NULL AND
				(
				V.VOUCHER_STATUS_ID IN (1,2)
				OR
					(
					V.VOUCHER_STATUS_ID = 4 AND
					
					V.VOUCHER_DUEDATE > GETDATE()
					
					)
				)
				AND V.VOUCHER_ID = VG.VOUCHER_ID
			GROUP BY
				VG.CONSUMER_ID
		UNION ALL
			SELECT
				0 AS BORC,
				0 AS BORC2,
				0 AS ALACAK,
				0 AS ALACAK2,
				0 AS BAKIYE,
				0 AS BAKIYE2,
				0 AS VADE_BORC,
				0 AS VADE_ALACAK,
				0 AS VADE_BORC_NEW,
				0 AS VADE_ALACAK_NEW,
				0 AS CEK_ODENMEDI,
				0 AS CEK_ODENMEDI2,
				0 AS CEK_KARSILIKSIZ,
				0 AS CEK_KARSILIKSIZ2,
				0 AS SENET_ODENMEDI,
				0 AS SENET_ODENMEDI2,
				0 AS SENET_KARSILIKSIZ,
				0 AS SENET_KARSILIKSIZ2,
				0 AS KEFIL_SENET_ODENMEDI,
				0 AS KEFIL_SENET_ODENMEDI2,
				SUM(VG.AMOUNT) AS KEFIL_SENET_KARSILIKSIZ,
				SUM(VG.AMOUNT2) AS KEFIL_SENET_KARSILIKSIZ,
				0 AS FORWARD_SALE_LIMIT,
				0 AS OPEN_ACCOUNT_RISK_LIMIT,
				0 AS PAYMENT_BLOKAJ,
				0 AS TOTAL_RISK_LIMIT,
				0 AS SECURE_TOTAL_TAKE,
				0 AS SECURE_TOTAL_TAKE2,
				0 AS SECURE_TOTAL_GIVE,
				0 AS SECURE_TOTAL_GIVE2,
				VG.CONSUMER_ID
			FROM
				VOUCHER V,
				VOUCHER_GUARANTORS VG
			WHERE
				V.VOUCHER_STATUS_ID= 5 
				AND V.VOUCHER_ID = VG.VOUCHER_ID
			GROUP BY
				VG.CONSUMER_ID
		UNION ALL
			SELECT 
				0 AS BORC,
				0 AS BORC2,
				0 AS ALACAK,
				0 AS ALACAK2,
				0 AS BAKIYE,
				0 AS BAKIYE2,
				0 AS VADE_BORC,
				0 AS VADE_ALACAK,
				0 AS VADE_BORC_NEW,
				0 AS VADE_ALACAK_NEW,
				0 AS CEK_ODENMEDI,
				0 AS CEK_ODENMEDI2,
				0 AS CEK_KARSILIKSIZ,
				0 AS CEK_KARSILIKSIZ2,
				0 AS SENET_ODENMEDI,
				0 AS SENET_ODENMEDI2,
				0 AS SENET_KARSILIKSIZ,
				0 AS SENET_KARSILIKSIZ2,
				0 AS KEFIL_SENET_ODENMEDI,
				0 AS KEFIL_SENET_ODENMEDI2,
				0 AS KEFIL_SENET_KARSILIKSIZ,
				0 AS KEFIL_SENET_KARSILIKSIZ2,
				CC.FORWARD_SALE_LIMIT_OTHER*(SM.RATE2/SM.RATE1) FORWARD_SALE_LIMIT,
				CC.OPEN_ACCOUNT_RISK_LIMIT_OTHER*(SM.RATE2/SM.RATE1) OPEN_ACCOUNT_RISK_LIMIT,
				CC.PAYMENT_BLOKAJ*(SM.RATE2/SM.RATE1) PAYMENT_BLOKAJ,
				CC.TOTAL_RISK_LIMIT_OTHER*(SM.RATE2/SM.RATE1) TOTAL_RISK_LIMIT,
				0 AS SECURE_TOTAL_TAKE,
				0 AS SECURE_TOTAL_TAKE2,
				0 AS SECURE_TOTAL_GIVE,
				0 AS SECURE_TOTAL_GIVE2,
				CC.CONSUMER_ID
			FROM 
				#new_dsn#.COMPANY_CREDIT CC,
				SETUP_MONEY SM
			WHERE
				CC.MONEY = SM.MONEY AND			
				CC.OUR_COMPANY_ID=#get_periods.OUR_COMPANY_ID# AND
				CC.CONSUMER_ID IS NOT NULL
		UNION ALL
			SELECT 
				0 AS BORC,
				0 AS BORC2,
				0 AS ALACAK,
				0 AS ALACAK2,
				0 AS BAKIYE,
				0 AS BAKIYE2,
				0 AS VADE_BORC,
				0 AS VADE_ALACAK,
				0 AS VADE_BORC_NEW,
				0 AS VADE_ALACAK_NEW,
				0 AS CEK_ODENMEDI,
				0 AS CEK_ODENMEDI2,
				0 AS CEK_KARSILIKSIZ,
				0 AS CEK_KARSILIKSIZ2,
				0 AS SENET_ODENMEDI,
				0 AS SENET_ODENMEDI2,
				0 AS SENET_KARSILIKSIZ,
				0 AS SENET_KARSILIKSIZ2,
				0 AS KEFIL_SENET_ODENMEDI,
				0 AS KEFIL_SENET_ODENMEDI2,
				0 AS KEFIL_SENET_KARSILIKSIZ,
				0 AS KEFIL_SENET_KARSILIKSIZ2,
				0 AS FORWARD_SALE_LIMIT,
				0 AS OPEN_ACCOUNT_RISK_LIMIT,
				0 AS PAYMENT_BLOKAJ,
				0 AS TOTAL_RISK_LIMIT,
				SUM(CS.ACTION_VALUE) AS SECURE_TOTAL_TAKE,
				SUM(CS.ACTION_VALUE2) AS SECURE_TOTAL_TAKE2,
				0 AS SECURE_TOTAL_GIVE,
				0 AS SECURE_TOTAL_GIVE2,
				CS.CONSUMER_ID
			FROM 
				#new_dsn#.COMPANY_SECUREFUND CS
			WHERE 
				CS.GIVE_TAKE = 0 AND
				CS.OUR_COMPANY_ID=#get_periods.OUR_COMPANY_ID# AND
				CS.FINISH_DATE > GETDATE() AND
				CS.SECUREFUND_STATUS = 1 AND
                CS.IS_RETURN IS NULL AND --iade edilen teminatlarin risk tutarından dusulmesi gerekir
				CS.CONSUMER_ID IS NOT NULL
			GROUP BY
				CS.CONSUMER_ID
		UNION ALL
			SELECT 
				0 AS BORC,
				0 AS BORC2,
				0 AS ALACAK,
				0 AS ALACAK2,
				0 AS BAKIYE,
				0 AS BAKIYE2,
				0 AS VADE_BORC,
				0 AS VADE_ALACAK,
				0 AS VADE_BORC_NEW,
				0 AS VADE_ALACAK_NEW,
				0 AS CEK_ODENMEDI,
				0 AS CEK_ODENMEDI2,
				0 AS CEK_KARSILIKSIZ,
				0 AS CEK_KARSILIKSIZ2,
				0 AS SENET_ODENMEDI,
				0 AS SENET_ODENMEDI2,
				0 AS SENET_KARSILIKSIZ,
				0 AS SENET_KARSILIKSIZ2,
				0 AS KEFIL_SENET_ODENMEDI,
				0 AS KEFIL_SENET_ODENMEDI2,
				0 AS KEFIL_SENET_KARSILIKSIZ,
				0 AS KEFIL_SENET_KARSILIKSIZ2,
				0 AS FORWARD_SALE_LIMIT,
				0 AS OPEN_ACCOUNT_RISK_LIMIT,
				0 AS PAYMENT_BLOKAJ,
				0 AS TOTAL_RISK_LIMIT,
				0 AS SECURE_TOTAL_TAKE,
				0 AS SECURE_TOTAL_TAKE2,
				SUM(CS.ACTION_VALUE) AS SECURE_TOTAL_GIVE,
				SUM(CS.ACTION_VALUE2) AS SECURE_TOTAL_GIVE2,
				CS.CONSUMER_ID
			FROM 
				#new_dsn#.COMPANY_SECUREFUND CS
			WHERE 
				CS.GIVE_TAKE = 1 AND
				CS.OUR_COMPANY_ID=#get_periods.OUR_COMPANY_ID# AND
				CS.FINISH_DATE > GETDATE() AND
				CS.SECUREFUND_STATUS = 1 AND
                CS.IS_RETURN IS NULL AND --iade edilen teminatlarin risk tutarından dusulmesi gerekir
				CS.CONSUMER_ID IS NOT NULL
	
			GROUP BY
				CS.CONSUMER_ID
				) AS Q1
			GROUP BY
				Q1.CONSUMER_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [CONSUMER_RISK_MONEY] AS
		SELECT 
			SUM( Q1.BORC ) AS BORC,
			SUM( Q1.BORC3 ) AS BORC2,
			SUM( Q1.ALACAK ) AS ALACAK,
			SUM( Q1.ALACAK3 ) AS ALACAK2,
			SUM( Q1.BAKIYE ) AS BAKIYE,
			SUM( Q1.BAKIYE3 ) AS BAKIYE2,
			SUM( Q1.VADE_BORC ) AS VADE_BORC,
			SUM( Q1.VADE_ALACAK ) AS VADE_ALACAK,
			SUM( Q1.VADE_BORC_NEW ) AS VADE_BORC_NEW,
			SUM( Q1.VADE_ALACAK_NEW ) AS VADE_ALACAK_NEW,
			SUM( Q1.CEK_ODENMEDI ) AS CEK_ODENMEDI,
			SUM( Q1.CEK_ODENMEDI3 ) AS CEK_ODENMEDI2,
			SUM( Q1.CEK_KARSILIKSIZ ) AS CEK_KARSILIKSIZ,
			SUM( Q1.CEK_KARSILIKSIZ3 ) AS CEK_KARSILIKSIZ2,
			SUM( Q1.SENET_ODENMEDI ) AS SENET_ODENMEDI,
			SUM( Q1.SENET_ODENMEDI3 ) AS SENET_ODENMEDI2,
			SUM( Q1.SENET_KARSILIKSIZ ) AS SENET_KARSILIKSIZ,
			SUM( Q1.SENET_KARSILIKSIZ3) AS SENET_KARSILIKSIZ2,
			SUM( Q1.FORWARD_SALE_LIMIT ) AS FORWARD_SALE_LIMIT,
			SUM( Q1.OPEN_ACCOUNT_RISK_LIMIT ) AS OPEN_ACCOUNT_RISK_LIMIT,
			SUM( Q1.TOTAL_RISK_LIMIT ) AS TOTAL_RISK_LIMIT,
			SUM( Q1.FORWARD_SALE_LIMIT3 ) AS FORWARD_SALE_LIMIT3,
			SUM( Q1.OPEN_ACCOUNT_RISK_LIMIT3 ) AS OPEN_ACCOUNT_RISK_LIMIT3,
			SUM( Q1.TOTAL_RISK_LIMIT3 ) AS TOTAL_RISK_LIMIT3,
			SUM( Q1.SECURE_TOTAL_TAKE ) AS SECURE_TOTAL_TAKE,
			SUM( Q1.SECURE_TOTAL_TAKE3 ) AS SECURE_TOTAL_TAKE2,
			SUM( Q1.SECURE_TOTAL_GIVE ) AS SECURE_TOTAL_GIVE,
			SUM( Q1.SECURE_TOTAL_GIVE3 ) AS SECURE_TOTAL_GIVE2,
			Q1.CONSUMER_ID,
			Q1.OTHER_MONEY
		FROM
			(
			SELECT 
				BORC,
				BORC3,
				ALACAK,
				ALACAK3,
				BAKIYE,
				BAKIYE3,
				VADE_BORC3 VADE_BORC,
				VADE_ALACAK3 VADE_ALACAK,
				VADE_BORC_NEW3 VADE_BORC_NEW,
				VADE_ALACAK_NEW3 VADE_ALACAK_NEW,
				0 AS CEK_ODENMEDI,
				0 AS CEK_ODENMEDI3,
				0 AS CEK_KARSILIKSIZ,
				0 AS CEK_KARSILIKSIZ3,
				0 AS SENET_ODENMEDI,
				0 AS SENET_ODENMEDI3,
				0 AS SENET_KARSILIKSIZ,
				0 AS SENET_KARSILIKSIZ3,
				0 AS FORWARD_SALE_LIMIT,
				0 AS OPEN_ACCOUNT_RISK_LIMIT,
				0 AS TOTAL_RISK_LIMIT,
				0 AS FORWARD_SALE_LIMIT3,
				0 AS OPEN_ACCOUNT_RISK_LIMIT3,
				0 AS TOTAL_RISK_LIMIT3,
				0 AS SECURE_TOTAL_TAKE,
				0 AS SECURE_TOTAL_TAKE3,
				0 AS SECURE_TOTAL_GIVE,
				0 AS SECURE_TOTAL_GIVE3,
				CONSUMER_ID,
				OTHER_MONEY
			FROM 
				CONSUMER_REMAINDER_MONEY
		UNION ALL
			SELECT
				0 AS BORC,
				0 AS BORC3,
				0 AS ALACAK,
				0 AS ALACAK3,
				0 AS BAKIYE,
				0 AS BAKIYE3,
				0 AS VADE_BORC,
				0 AS VADE_ALACAK,
				0 AS VADE_BORC_NEW,
				0 AS VADE_ALACAK_NEW,
				SUM(CHEQUE.OTHER_MONEY_VALUE) AS CEK_ODENMEDI,
				SUM(CHEQUE.CHEQUE_VALUE) AS CEK_ODENMEDI3,
				0 AS CEK_KARSILIKSIZ,
				0 AS CEK_KARSILIKSIZ3,
				0 AS SENET_ODENMEDI,
				0 AS SENET_ODENMEDI3,
				0 AS SENET_KARSILIKSIZ,
				0 AS SENET_KARSILIKSIZ3,
				0 AS FORWARD_SALE_LIMIT,
				0 AS OPEN_ACCOUNT_RISK_LIMIT,
				0 AS TOTAL_RISK_LIMIT,
				0 AS FORWARD_SALE_LIMIT3,
				0 AS OPEN_ACCOUNT_RISK_LIMIT3,
				0 AS TOTAL_RISK_LIMIT3,
				0 AS SECURE_TOTAL_TAKE,
				0 AS SECURE_TOTAL_TAKE3,
				0 AS SECURE_TOTAL_GIVE,
				0 AS SECURE_TOTAL_GIVE3,
				CHEQUE.CONSUMER_ID,
				CHEQUE.CURRENCY_ID OTHER_MONEY
			FROM
				CHEQUE
			WHERE
				CHEQUE.CHEQUE_ID IS NOT NULL AND
				CHEQUE.CHEQUE_STATUS_ID IN (1,2,13)
				AND CHEQUE.CONSUMER_ID IS NOT NULL 
			GROUP BY
				CHEQUE.CONSUMER_ID,
				CHEQUE.CURRENCY_ID
		UNION ALL
			SELECT
				0 AS BORC,
				0 AS BORC3,
				0 AS ALACAK,
				0 AS ALACAK3,
				0 AS BAKIYE,
				0 AS BAKIYE3,
				0 AS VADE_BORC,
				0 AS VADE_ALACAK,
				0 AS VADE_BORC_NEW,
				0 AS VADE_ALACAK_NEW,
				SUM(CHEQUE.OTHER_MONEY_VALUE) AS CEK_ODENMEDI,
				SUM(CHEQUE.CHEQUE_VALUE) AS CEK_ODENMEDI3,
				0 AS CEK_KARSILIKSIZ,
				0 AS CEK_KARSILIKSIZ3,
				0 AS SENET_ODENMEDI,
				0 AS SENET_ODENMEDI3,
				0 AS SENET_KARSILIKSIZ,
				0 AS SENET_KARSILIKSIZ3,
				0 AS FORWARD_SALE_LIMIT,
				0 AS OPEN_ACCOUNT_RISK_LIMIT,
				0 AS TOTAL_RISK_LIMIT,
				0 AS FORWARD_SALE_LIMIT3,
				0 AS OPEN_ACCOUNT_RISK_LIMIT3,
				0 AS TOTAL_RISK_LIMIT3,
				0 AS SECURE_TOTAL_TAKE,
				0 AS SECURE_TOTAL_TAKE3,
				0 AS SECURE_TOTAL_GIVE,
				0 AS SECURE_TOTAL_GIVE3,
				CHEQUE.OWNER_CONSUMER_ID CONSUMER_ID,
				CHEQUE.CURRENCY_ID OTHER_MONEY
			FROM
				CHEQUE
			WHERE
				CHEQUE.CHEQUE_ID IS NOT NULL AND
				CHEQUE.CHEQUE_STATUS_ID = 4 AND
				CHEQUE.CHEQUE_DUEDATE > GETDATE()
				AND CHEQUE.OWNER_CONSUMER_ID IS NOT NULL 
			GROUP BY
				CHEQUE.OWNER_CONSUMER_ID,
				CHEQUE.CURRENCY_ID
		UNION ALL
			SELECT
				0 AS BORC,
				0 AS BORC3,
				0 AS ALACAK,
				0 AS ALACAK3,
				0 AS BAKIYE,
				0 AS BAKIYE3,
				0 AS VADE_BORC,
				0 AS VADE_ALACAK,
				0 AS VADE_BORC_NEW,
				0 AS VADE_ALACAK_NEW,
				0 AS CEK_ODENMEDI,
				0 AS CEK_ODENMEDI3,
				SUM(CHEQUE.OTHER_MONEY_VALUE) AS CEK_KARSILIKSIZ,
				SUM(CHEQUE.CHEQUE_VALUE) AS CEK_KARSILIKSIZ3,
				0 AS SENET_ODENMEDI,
				0 AS SENET_ODENMEDI3,
				0 AS SENET_KARSILIKSIZ,
				0 AS SENET_KARSILIKSIZ3,
				0 AS FORWARD_SALE_LIMIT,
				0 AS OPEN_ACCOUNT_RISK_LIMIT,	
				0 AS TOTAL_RISK_LIMIT,
				0 AS FORWARD_SALE_LIMIT3,
				0 AS OPEN_ACCOUNT_RISK_LIMIT3,
				0 AS TOTAL_RISK_LIMIT3,
				0 AS SECURE_TOTAL_TAKE,
				0 AS SECURE_TOTAL_TAKE3,
				0 AS SECURE_TOTAL_GIVE,
				0 AS SECURE_TOTAL_GIVE3,
				CHEQUE.CONSUMER_ID,
				CHEQUE.CURRENCY_ID OTHER_MONEY
			FROM
				CHEQUE
			WHERE
				CHEQUE.CHEQUE_ID IS NOT NULL AND
				CHEQUE.CHEQUE_STATUS_ID = 5 
			GROUP BY
				CHEQUE.CONSUMER_ID,
				CHEQUE.CURRENCY_ID
		UNION ALL
			SELECT
				0 AS BORC,
				0 AS BORC3,
				0 AS ALACAK,
				0 AS ALACAK3,
				0 AS BAKIYE,
				0 AS BAKIYE3,
				0 AS VADE_BORC,
				0 AS VADE_ALACAK,
				0 AS VADE_BORC_NEW,
				0 AS VADE_ALACAK_NEW,
				0 AS CEK_ODENMEDI,
				0 AS CEK_ODENMEDI3,
				0 AS CEK_KARSILIKSIZ,
				0 AS CEK_KARSILIKSIZ3,
				(SELECT OTHER_REMAINING_VALUE FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) AS SENET_ODENMEDI,
				(SELECT REMAINING_VALUE FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) AS SENET_ODENMEDI3,
				0 AS SENET_KARSILIKSIZ,
				0 AS SENET_KARSILIKSIZ3,
				0 AS FORWARD_SALE_LIMIT,
				0 AS OPEN_ACCOUNT_RISK_LIMIT,
				0 AS TOTAL_RISK_LIMIT,
				0 AS FORWARD_SALE_LIMIT3,
				0 AS OPEN_ACCOUNT_RISK_LIMIT3,
				0 AS TOTAL_RISK_LIMIT3,
				0 AS SECURE_TOTAL_TAKE,
				0 AS SECURE_TOTAL_TAKE3,
				0 AS SECURE_TOTAL_GIVE,
				0 AS SECURE_TOTAL_GIVE3,
				V.CONSUMER_ID,
				V.CURRENCY_ID OTHER_MONEY
			FROM
				VOUCHER V
			WHERE
				V.VOUCHER_ID IS NOT NULL AND
				V.VOUCHER_STATUS_ID IN (1,2,13,11)
				AND V.CONSUMER_ID IS NOT NULL 

		UNION ALL
			SELECT
				0 AS BORC,
				0 AS BORC3,
				0 AS ALACAK,
				0 AS ALACAK3,
				0 AS BAKIYE,
				0 AS BAKIYE3,
				0 AS VADE_BORC,
				0 AS VADE_ALACAK,
				0 AS VADE_BORC_NEW,
				0 AS VADE_ALACAK_NEW,
				0 AS CEK_ODENMEDI,
				0 AS CEK_ODENMEDI3,
				0 AS CEK_KARSILIKSIZ,
				0 AS CEK_KARSILIKSIZ3,
				(SELECT OTHER_REMAINING_VALUE FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) AS SENET_ODENMEDI,
				(SELECT REMAINING_VALUE FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) AS SENET_ODENMEDI3,
				0 AS SENET_KARSILIKSIZ,
				0 AS SENET_KARSILIKSIZ3,
				0 AS FORWARD_SALE_LIMIT,
				0 AS OPEN_ACCOUNT_RISK_LIMIT,
				0 AS TOTAL_RISK_LIMIT,
				0 AS FORWARD_SALE_LIMIT3,
				0 AS OPEN_ACCOUNT_RISK_LIMIT3,
				0 AS TOTAL_RISK_LIMIT3,
				0 AS SECURE_TOTAL_TAKE,
				0 AS SECURE_TOTAL_TAKE3,
				0 AS SECURE_TOTAL_GIVE,
				0 AS SECURE_TOTAL_GIVE3,
				V.OWNER_CONSUMER_ID CONSUMER_ID,
				V.CURRENCY_ID OTHER_MONEY
			FROM
				VOUCHER V
			WHERE
				V.VOUCHER_ID IS NOT NULL AND
				V.VOUCHER_STATUS_ID = 4 AND
				V.VOUCHER_DUEDATE > GETDATE()	
				AND V.OWNER_CONSUMER_ID IS NOT NULL 
	
		UNION ALL
			SELECT
				0 AS BORC,
				0 AS BORC3,
				0 AS ALACAK,
				0 AS ALACAK3,
				0 AS BAKIYE,

				0 AS BAKIYE3,
				0 AS VADE_BORC,
				0 AS VADE_ALACAK,
				0 AS VADE_BORC_NEW,
				0 AS VADE_ALACAK_NEW,
				0 AS CEK_ODENMEDI,
				0 AS CEK_ODENMEDI3,
				0 AS CEK_KARSILIKSIZ,
				0 AS CEK_KARSILIKSIZ3,
				0 AS SENET_ODENMEDI,
				0 AS SENET_ODENMEDI3,
				(SELECT OTHER_REMAINING_VALUE FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) AS SENET_KARSILIKSIZ,
				(SELECT REMAINING_VALUE FROM VOUCHER_REMAINING_AMOUNT WHERE VOUCHER_ID = V.VOUCHER_ID) AS SENET_KARSILIKSIZ3,
				0 AS FORWARD_SALE_LIMIT,
				0 AS OPEN_ACCOUNT_RISK_LIMIT,
				0 AS TOTAL_RISK_LIMIT,
				0 AS FORWARD_SALE_LIMIT3,
				0 AS OPEN_ACCOUNT_RISK_LIMIT3,
				0 AS TOTAL_RISK_LIMIT3,
				0 AS SECURE_TOTAL_TAKE,
				0 AS SECURE_TOTAL_TAKE3,
				0 AS SECURE_TOTAL_GIVE,
				0 AS SECURE_TOTAL_GIVE3,
				V.CONSUMER_ID,
				V.CURRENCY_ID OTHER_MONEY
			FROM
				VOUCHER V
			WHERE
				V.VOUCHER_ID IS NOT NULL AND
				V.VOUCHER_STATUS_ID= 5 
		UNION ALL
			SELECT 
				0 AS BORC,
				0 AS BORC3,
				0 AS ALACAK,
				0 AS ALACAK3,
				0 AS BAKIYE,
				0 AS BAKIYE3,
				0 AS VADE_BORC,
				0 AS VADE_ALACAK,
				0 AS VADE_BORC_NEW,
				0 AS VADE_ALACAK_NEW,
				0 AS CEK_ODENMEDI,
				0 AS CEK_ODENMEDI3,
				0 AS CEK_KARSILIKSIZ,
				0 AS CEK_KARSILIKSIZ3,
				0 AS SENET_ODENMEDI,
				0 AS SENET_ODENMEDI3,
				0 AS SENET_KARSILIKSIZ,
				0 AS SENET_KARSILIKSIZ3,
				CC.FORWARD_SALE_LIMIT_OTHER*(SM.RATE2/SM.RATE1) FORWARD_SALE_LIMIT,
				CC.OPEN_ACCOUNT_RISK_LIMIT_OTHER*(SM.RATE2/SM.RATE1) OPEN_ACCOUNT_RISK_LIMIT,
				CC.TOTAL_RISK_LIMIT_OTHER*(SM.RATE2/SM.RATE1) TOTAL_RISK_LIMIT,
				CC.FORWARD_SALE_LIMIT_OTHER FORWARD_SALE_LIMIT3,
				CC.OPEN_ACCOUNT_RISK_LIMIT_OTHER OPEN_ACCOUNT_RISK_LIMIT3,
				CC.TOTAL_RISK_LIMIT_OTHER TOTAL_RISK_LIMIT3,
				0 AS SECURE_TOTAL_TAKE,
				0 AS SECURE_TOTAL_TAKE3,
				0 AS SECURE_TOTAL_GIVE,
				0 AS SECURE_TOTAL_GIVE3,
				CC.CONSUMER_ID,
				CC.MONEY OTHER_MONEY
			FROM 
				#new_dsn#.COMPANY_CREDIT CC,
				SETUP_MONEY SM
			WHERE
				CC.MONEY = SM.MONEY AND			
				CC.OUR_COMPANY_ID=#get_periods.OUR_COMPANY_ID# AND
				CC.CONSUMER_ID IS NOT NULL
		UNION ALL
			SELECT 
				0 AS BORC,
				0 AS BORC3,
				0 AS ALACAK,
				0 AS ALACAK3,
				0 AS BAKIYE,
				0 AS BAKIYE3,
				0 AS VADE_BORC,
				0 AS VADE_ALACAK,
				0 AS VADE_BORC_NEW,
				0 AS VADE_ALACAK_NEW,
				0 AS CEK_ODENMEDI,
				0 AS CEK_ODENMEDI3,
				0 AS CEK_KARSILIKSIZ,
				0 AS CEK_KARSILIKSIZ3,
				0 AS SENET_ODENMEDI,
				0 AS SENET_ODENMEDI3,
				0 AS SENET_KARSILIKSIZ,
				0 AS SENET_KARSILIKSIZ3,
				0 AS FORWARD_SALE_LIMIT,
				0 AS OPEN_ACCOUNT_RISK_LIMIT,
				0 AS TOTAL_RISK_LIMIT,
				0 AS FORWARD_SALE_LIMIT3,
				0 AS OPEN_ACCOUNT_RISK_LIMIT3,
				0 AS TOTAL_RISK_LIMIT3,
				SUM(CS.ACTION_VALUE) AS SECURE_TOTAL_TAKE,
				SUM(CS.SECUREFUND_TOTAL) AS SECURE_TOTAL_TAKE3,
				0 AS SECURE_TOTAL_GIVE,
				0 AS SECURE_TOTAL_GIVE3,
				CS.CONSUMER_ID,
				CS.MONEY_CAT OTHER_MONEY
			FROM 
				#new_dsn#.COMPANY_SECUREFUND CS
			WHERE 
				CS.GIVE_TAKE = 0 AND
				CS.OUR_COMPANY_ID=#get_periods.OUR_COMPANY_ID# AND
				CS.FINISH_DATE > GETDATE() AND
				CS.SECUREFUND_STATUS = 1 AND
                CS.IS_RETURN IS NULL AND --iade edilen teminatlarin risk tutarından dusulmesi gerekir
				CS.CONSUMER_ID IS NOT NULL
			GROUP BY
				CS.CONSUMER_ID,
				CS.MONEY_CAT
		UNION ALL
			SELECT 
				0 AS BORC,
				0 AS BORC3,
				0 AS ALACAK,
				0 AS ALACAK3,
				0 AS BAKIYE,
				0 AS BAKIYE3,
				0 AS VADE_BORC,
				0 AS VADE_ALACAK,
				0 AS VADE_BORC_NEW,
				0 AS VADE_ALACAK_NEW,
				0 AS CEK_ODENMEDI,
				0 AS CEK_ODENMEDI3,
				0 AS CEK_KARSILIKSIZ,
				0 AS CEK_KARSILIKSIZ3,
				0 AS SENET_ODENMEDI,
				0 AS SENET_ODENMEDI3,
				0 AS SENET_KARSILIKSIZ,
				0 AS SENET_KARSILIKSIZ3,
				0 AS FORWARD_SALE_LIMIT,
				0 AS OPEN_ACCOUNT_RISK_LIMIT,
				0 AS TOTAL_RISK_LIMIT,
				0 AS FORWARD_SALE_LIMIT3,
				0 AS OPEN_ACCOUNT_RISK_LIMIT3,
				0 AS TOTAL_RISK_LIMIT3,
				0 AS SECURE_TOTAL_TAKE,
				0 AS SECURE_TOTAL_TAKE3,
				SUM(CS.ACTION_VALUE) AS SECURE_TOTAL_GIVE,
				SUM(CS.SECUREFUND_TOTAL) AS SECURE_TOTAL_GIVE3,
				CS.CONSUMER_ID,
				CS.MONEY_CAT OTHER_MONEY
			FROM 
				#new_dsn#.COMPANY_SECUREFUND CS
			WHERE 
				CS.GIVE_TAKE = 1 AND
				CS.OUR_COMPANY_ID=#get_periods.OUR_COMPANY_ID# AND
				CS.FINISH_DATE > GETDATE() AND
				CS.SECUREFUND_STATUS = 1 AND
                CS.IS_RETURN IS NULL AND --iade edilen teminatlarin risk tutarından dusulmesi gerekir
				CS.CONSUMER_ID IS NOT NULL
	
			GROUP BY
				CS.CONSUMER_ID,
				CS.MONEY_CAT
				) AS Q1
			GROUP BY
				Q1.CONSUMER_ID,
				Q1.OTHER_MONEY

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [CARI_ROWS_EMPLOYEE] AS
		SELECT DISTINCT
			CASE WHEN C.TO_EMPLOYEE_ID IS NOT NULL THEN  SUM(C.ACTION_VALUE)ELSE 0 END AS BORC,
			CASE WHEN C.TO_EMPLOYEE_ID IS NOT NULL THEN SUM(C.ACTION_VALUE_2) ELSE 0 END AS BORC2,
			CASE WHEN C.TO_EMPLOYEE_ID IS NOT NULL THEN SUM(ISNULL(OTHER_CASH_ACT_VALUE,0))  ELSE 0 END AS BORC3,
			CASE WHEN C.FROM_EMPLOYEE_ID IS NOT NULL THEN SUM(C.ACTION_VALUE) ELSE 0 END AS ALACAK,
			CASE WHEN C.FROM_EMPLOYEE_ID IS NOT NULL THEN SUM(C.ACTION_VALUE_2)  ELSE 0 END AS ALACAK2,
			CASE WHEN C.FROM_EMPLOYEE_ID IS NOT NULL THEN SUM(ISNULL(OTHER_CASH_ACT_VALUE,0)) ELSE 0 END AS ALACAK3,	
			CASE WHEN C.TO_EMPLOYEE_ID IS NOT NULL THEN C.TO_EMPLOYEE_ID ELSE C.FROM_EMPLOYEE_ID END AS EMPLOYEE_ID,				
			OTHER_MONEY,
			CASE WHEN DATEDIFF(day,ACTION_DATE,ISNULL(DUE_DATE,ACTION_DATE)) = 0 THEN 1 ELSE  DATEDIFF(day,ACTION_DATE,ISNULL(DUE_DATE,ACTION_DATE)) END AS DATE_DIFF,
            CASE WHEN DATEDIFF(day,ISNULL(DUE_DATE,ACTION_DATE),GETDATE()) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(DUE_DATE,ACTION_DATE),GETDATE()) END AS DUE_DATE_DIFF,
			ACTION_DATE,
			DUE_DATE,
			PROJECT_ID,
            SUBSCRIPTION_ID,
			ACC_TYPE_ID,
            ISNULL(TO_BRANCH_ID,FROM_BRANCH_ID) BRANCH_ID,
			C.TO_EMPLOYEE_ID,
			C.FROM_EMPLOYEE_ID
		FROM
			CARI_ROWS C
		WHERE
			(C.TO_EMPLOYEE_ID IS NOT NULL) OR ( C.FROM_EMPLOYEE_ID IS NOT NULL)
		GROUP BY
			C.TO_EMPLOYEE_ID,
			C.FROM_EMPLOYEE_ID,
			OTHER_MONEY,
			ACTION_DATE,
			DUE_DATE,
			PROJECT_ID,
            SUBSCRIPTION_ID,
			ACC_TYPE_ID,
            ISNULL(TO_BRANCH_ID,FROM_BRANCH_ID)

</cfquery>
	<cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [COMPANY_REMAINDER_SUBSCRIPTION] AS
				SELECT     
					COMPANY_ID, 
					SUBSCRIPTION_ID,
					ROUND(SUM(BORC-ALACAK),5) AS BAKIYE, 
					ROUND(SUM(BORC2-ALACAK2),5) AS BAKIYE2, 
					SUM(BORC) AS BORC,
					SUM(BORC2) AS BORC2,
					SUM(ALACAK) AS ALACAK,
					SUM(ALACAK2) AS ALACAK2,
					CASE WHEN SUM(BORC)= 0 THEN SUM((BORC*DATE_DIFF)) ELSE ROUND((SUM((BORC*DATE_DIFF))/SUM(BORC)),0) END AS VADE_BORC,
					CASE WHEN SUM(ALACAK)= 0 THEN SUM((ALACAK*DATE_DIFF)) ELSE ROUND((SUM((ALACAK*DATE_DIFF))/SUM(ALACAK)),0) END AS VADE_ALACAK
				FROM         
					CARI_ROWS_TOPLAM
				GROUP BY 
					COMPANY_ID, 
					SUBSCRIPTION_ID
</cfquery>
	<cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [COMPANY_REMAINDER_MONEY_SUBSCRIPTION] AS
			SELECT     
				COMPANY_ID, 
				OTHER_MONEY,
				SUBSCRIPTION_ID,
				SUM(BORC-ALACAK) AS BAKIYE, 
				SUM(BORC2-ALACAK2) AS BAKIYE2,
				SUM(BORC3-ALACAK3) AS BAKIYE3,
				SUM(BORC) AS BORC,
				SUM(BORC2) AS BORC2,
				SUM(BORC3) AS BORC3,
				SUM(ALACAK) AS ALACAK,
				SUM(ALACAK2) AS ALACAK2,
				SUM(ALACAK3) AS ALACAK3,
				CASE WHEN SUM(BORC3)= 0 THEN SUM((BORC3*DATE_DIFF)) ELSE ROUND((SUM((BORC3*DATE_DIFF))/SUM(BORC3)),0) END AS VADE_BORC3,
				CASE WHEN SUM(ALACAK3)= 0 THEN SUM((ALACAK3*DATE_DIFF)) ELSE ROUND((SUM((ALACAK3*DATE_DIFF))/SUM(ALACAK3)),0) END AS VADE_ALACAK3
			FROM         
				CARI_ROWS_TOPLAM
			GROUP BY 
				COMPANY_ID, 	
				OTHER_MONEY,
				SUBSCRIPTION_ID 
</cfquery>
	<cfquery name="cr_view" datasource="#new_dsn2#">
	   CREATE VIEW [COMPANY_REMAINDER_ACC_TYPE] AS
			SELECT     
				COMPANY_ID, 
				ACC_TYPE_ID,
				ROUND(SUM(BORC-ALACAK),5) AS BAKIYE, 
				ROUND(SUM(BORC2-ALACAK2),5) AS BAKIYE2, 
				SUM(BORC) AS BORC,
				SUM(BORC2) AS BORC2,
				SUM(ALACAK) AS ALACAK,
				SUM(ALACAK2) AS ALACAK2,
				CASE WHEN SUM(BORC)= 0 THEN SUM((BORC*DATE_DIFF)) ELSE ROUND((SUM((BORC*DATE_DIFF))/SUM(BORC)),0) END AS VADE_BORC,
				CASE WHEN SUM(ALACAK)= 0 THEN SUM((ALACAK*DATE_DIFF)) ELSE ROUND((SUM((ALACAK*DATE_DIFF))/SUM(ALACAK)),0) END AS VADE_ALACAK
			FROM         
				CARI_ROWS_TOPLAM
			GROUP BY 
				COMPANY_ID, 
				ACC_TYPE_ID
</cfquery>
	<cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [COMPANY_REMAINDER_MONEY_ACC_TYPE] AS
			SELECT     
				COMPANY_ID, 
				OTHER_MONEY,
				ACC_TYPE_ID,
				SUM(BORC-ALACAK) AS BAKIYE, 
				SUM(BORC2-ALACAK2) AS BAKIYE2,
				SUM(BORC3-ALACAK3) AS BAKIYE3,
				SUM(BORC) AS BORC,
				SUM(BORC2) AS BORC2,
				SUM(BORC3) AS BORC3,
				SUM(ALACAK) AS ALACAK,
				SUM(ALACAK2) AS ALACAK2,
				SUM(ALACAK3) AS ALACAK3,
				CASE WHEN SUM(BORC3)= 0 THEN SUM((BORC3*DATE_DIFF)) ELSE ROUND((SUM((BORC3*DATE_DIFF))/SUM(BORC3)),0) END AS VADE_BORC3,
				CASE WHEN SUM(ALACAK3)= 0 THEN SUM((ALACAK3*DATE_DIFF)) ELSE ROUND((SUM((ALACAK3*DATE_DIFF))/SUM(ALACAK3)),0) END AS VADE_ALACAK3
			FROM         
				CARI_ROWS_TOPLAM
			GROUP BY 
				COMPANY_ID, 	
				OTHER_MONEY,
				ACC_TYPE_ID
</cfquery>
	<cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [CONSUMER_REMAINDER_SUBSCRIPTION] AS
			SELECT     
				CONSUMER_ID, 
				SUBSCRIPTION_ID,
				ROUND(SUM(BORC-ALACAK),5) AS BAKIYE, 
				ROUND(SUM(BORC2-ALACAK2),5) AS BAKIYE2, 
				SUM(BORC) AS BORC,
				SUM(BORC2) AS BORC2,
				SUM(ALACAK) AS ALACAK,
				SUM(ALACAK2) AS ALACAK2,
				CASE WHEN SUM(BORC)= 0 THEN SUM((BORC*DATE_DIFF)) ELSE ROUND((SUM((BORC*DATE_DIFF))/SUM(BORC)),0) END AS VADE_BORC,
				CASE WHEN SUM(ALACAK)= 0 THEN SUM((ALACAK*DATE_DIFF)) ELSE ROUND((SUM((ALACAK*DATE_DIFF))/SUM(ALACAK)),0) END AS VADE_ALACAK
			FROM         
				CARI_ROWS_CONSUMER
			GROUP BY 
				CONSUMER_ID, 
				SUBSCRIPTION_ID
</cfquery>	
	<cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [CONSUMER_REMAINDER_MONEY_SUBSCRIPTION] AS
			SELECT     
				CONSUMER_ID, 
				OTHER_MONEY,
				SUBSCRIPTION_ID,
				SUM(BORC-ALACAK) AS BAKIYE, 
				SUM(BORC2-ALACAK2) AS BAKIYE2,
				SUM(BORC3-ALACAK3) AS BAKIYE3,
				SUM(BORC) AS BORC,
				SUM(BORC2) AS BORC2,
				SUM(BORC3) AS BORC3,
				SUM(ALACAK) AS ALACAK,
				SUM(ALACAK2) AS ALACAK2,
				SUM(ALACAK3) AS ALACAK3,
				CASE WHEN SUM(BORC3)= 0 THEN SUM((BORC3*DATE_DIFF)) ELSE ROUND((SUM((BORC3*DATE_DIFF))/SUM(BORC3)),0) END AS VADE_BORC3,
				CASE WHEN SUM(ALACAK3)= 0 THEN SUM((ALACAK3*DATE_DIFF)) ELSE ROUND((SUM((ALACAK3*DATE_DIFF))/SUM(ALACAK3)),0) END AS VADE_ALACAK3
			FROM         
				CARI_ROWS_CONSUMER
			GROUP BY 
				CONSUMER_ID, 	
				OTHER_MONEY,
				SUBSCRIPTION_ID
</cfquery>
	<cfquery name="cr_view" datasource="#new_dsn2#">
	    CREATE VIEW [CONSUMER_REMAINDER_ACC_TYPE] AS
			SELECT
				CONSUMER_ID, 
				ACC_TYPE_ID,
				ROUND(SUM(BORC-ALACAK),5) AS BAKIYE, 
				ROUND(SUM(BORC2-ALACAK2),5) AS BAKIYE2,
				ROUND(SUM(BORC),5) AS BORC,
				ROUND(SUM(BORC2),5) AS BORC2,
				ROUND(SUM(ALACAK),5) AS ALACAK,
				ROUND(SUM(ALACAK2),5) AS ALACAK2,
				CASE WHEN SUM(BORC)= 0 THEN SUM((BORC*DATE_DIFF)) ELSE ROUND((SUM((BORC*DATE_DIFF))/SUM(BORC)),0) END AS VADE_BORC,
				CASE WHEN SUM(ALACAK)= 0 THEN SUM((ALACAK*DATE_DIFF)) ELSE ROUND((SUM((ALACAK*DATE_DIFF))/SUM(ALACAK)),0) END AS VADE_ALACAK	
			FROM
				CARI_ROWS_CONSUMER
			GROUP BY
				CONSUMER_ID,
				ACC_TYPE_ID
</cfquery>
	<cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [CONSUMER_REMAINDER_MONEY_ACC_TYPE] AS
			SELECT     
				CONSUMER_ID, 
				OTHER_MONEY,
				ACC_TYPE_ID,
				SUM(BORC-ALACAK) AS BAKIYE, 
				SUM(BORC2-ALACAK2) AS BAKIYE2,
				SUM(BORC3-ALACAK3) AS BAKIYE3,
				SUM(BORC) AS BORC,
				SUM(BORC2) AS BORC2,
				SUM(BORC3) AS BORC3,
				SUM(ALACAK) AS ALACAK,
				SUM(ALACAK2) AS ALACAK2,
				SUM(ALACAK3) AS ALACAK3,
				CASE WHEN SUM(BORC3)= 0 THEN SUM((BORC3*DATE_DIFF)) ELSE ROUND((SUM((BORC3*DATE_DIFF))/SUM(BORC3)),0) END AS VADE_BORC3,
				CASE WHEN SUM(ALACAK3)= 0 THEN SUM((ALACAK3*DATE_DIFF)) ELSE ROUND((SUM((ALACAK3*DATE_DIFF))/SUM(ALACAK3)),0) END AS VADE_ALACAK3
			FROM         
				CARI_ROWS_CONSUMER
			GROUP BY 
				CONSUMER_ID, 	
				OTHER_MONEY,
				ACC_TYPE_ID
</cfquery>
	<cfquery name="cr_view" datasource="#new_dsn2#">
	    CREATE VIEW [EMPLOYEE_REMAINDER_SUBSCRIPTION] AS
			SELECT
				EMPLOYEE_ID, 
				SUBSCRIPTION_ID,
				SUM(BORC-ALACAK) AS BAKIYE, 
				SUM(BORC) AS BORC,
				SUM(BORC2) AS BORC2,
				SUM(ALACAK) AS ALACAK,
				SUM(ALACAK2) AS ALACAK2,
				CASE WHEN SUM(BORC)= 0 THEN SUM((BORC*DATE_DIFF)) ELSE ROUND((SUM((BORC*DATE_DIFF))/SUM(BORC)),0) END AS VADE_BORC,
				CASE WHEN SUM(ALACAK)= 0 THEN SUM((ALACAK*DATE_DIFF)) ELSE ROUND((SUM((ALACAK*DATE_DIFF))/SUM(ALACAK)),0) END AS VADE_ALACAK,
				ACC_TYPE_ID
			FROM
				CARI_ROWS_EMPLOYEE
			GROUP BY
				EMPLOYEE_ID,
				SUBSCRIPTION_ID,
				ACC_TYPE_ID
</cfquery>
	<cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [EMPLOYEE_REMAINDER_MONEY_SUBSCRIPTION] AS
			SELECT
				EMPLOYEE_ID, 
				SUM(BORC-ALACAK) AS BAKIYE, 
				SUM(BORC2-ALACAK2) AS BAKIYE2,
				SUM(BORC3-ALACAK3) AS BAKIYE3,
				SUM(BORC) AS BORC,
				SUM(BORC2) AS BORC2,
				SUM(BORC3) AS BORC3,
				SUM(ALACAK) AS ALACAK,
				SUM(ALACAK2) AS ALACAK2,
				SUM(ALACAK3) AS ALACAK3,
				OTHER_MONEY,
				SUBSCRIPTION_ID,
				CASE WHEN SUM(BORC3)= 0 THEN SUM((BORC3*DATE_DIFF)) ELSE ROUND((SUM((BORC3*DATE_DIFF))/SUM(BORC3)),0) END AS VADE_BORC3,
				CASE WHEN SUM(ALACAK3)= 0 THEN SUM((ALACAK3*DATE_DIFF)) ELSE ROUND((SUM((ALACAK3*DATE_DIFF))/SUM(ALACAK3)),0) END AS VADE_ALACAK3,
				ACC_TYPE_ID
			FROM
				CARI_ROWS_EMPLOYEE
			GROUP BY
				EMPLOYEE_ID,
				OTHER_MONEY,
				SUBSCRIPTION_ID,
				ACC_TYPE_ID
</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [EMPLOYEE_REMAINDER] AS
			SELECT
				EMPLOYEE_ID, 
				ROUND(SUM(BORC-ALACAK),5) AS BAKIYE, 
				ROUND(SUM(BORC2-ALACAK2),5) AS BAKIYE2, 
				SUM(BORC) AS BORC,
				SUM(BORC2) AS BORC2,
				SUM(ALACAK) AS ALACAK,
				SUM(ALACAK2) AS ALACAK2,
				CASE WHEN SUM(BORC)= 0 THEN SUM((BORC*DATE_DIFF)) ELSE ROUND((SUM((BORC*DATE_DIFF))/SUM(BORC)),0) END AS VADE_BORC,
				CASE WHEN SUM(ALACAK)= 0 THEN SUM((ALACAK*DATE_DIFF)) ELSE ROUND((SUM((ALACAK*DATE_DIFF))/SUM(ALACAK)),0) END AS VADE_ALACAK,
				ACC_TYPE_ID
			FROM
				CARI_ROWS_EMPLOYEE
			GROUP BY
				EMPLOYEE_ID,
				ACC_TYPE_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [EMPLOYEE_REMAINDER_MONEY] AS
			SELECT
				EMPLOYEE_ID, 
				SUM(BORC-ALACAK) AS BAKIYE, 
				SUM(BORC2-ALACAK2) AS BAKIYE2,
				SUM(BORC3-ALACAK3) AS BAKIYE3,
				SUM(BORC) AS BORC,
				SUM(BORC2) AS BORC2,
				SUM(BORC3) AS BORC3,
				SUM(ALACAK) AS ALACAK,
				SUM(ALACAK2) AS ALACAK2,
				SUM(ALACAK3) AS ALACAK3,
				OTHER_MONEY,
				CASE WHEN SUM(BORC3)= 0 THEN SUM((BORC3*DATE_DIFF)) ELSE ROUND((SUM((BORC3*DATE_DIFF))/SUM(BORC3)),0) END AS VADE_BORC3,
				CASE WHEN SUM(ALACAK3)= 0 THEN SUM((ALACAK3*DATE_DIFF)) ELSE ROUND((SUM((ALACAK3*DATE_DIFF))/SUM(ALACAK3)),0) END AS VADE_ALACAK3,
				ACC_TYPE_ID
			FROM
				CARI_ROWS_EMPLOYEE
			GROUP BY
				EMPLOYEE_ID,
				OTHER_MONEY,
				ACC_TYPE_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [EMPLOYEE_REMAINDER_PROJECT] AS
			SELECT
				EMPLOYEE_ID, 
				PROJECT_ID,
				SUM(BORC-ALACAK) AS BAKIYE, 
				SUM(BORC) AS BORC,
				SUM(BORC2) AS BORC2,
				SUM(ALACAK) AS ALACAK,
				SUM(ALACAK2) AS ALACAK2,
				CASE WHEN SUM(BORC)= 0 THEN SUM((BORC*DATE_DIFF)) ELSE ROUND((SUM((BORC*DATE_DIFF))/SUM(BORC)),0) END AS VADE_BORC,
				CASE WHEN SUM(ALACAK)= 0 THEN SUM((ALACAK*DATE_DIFF)) ELSE ROUND((SUM((ALACAK*DATE_DIFF))/SUM(ALACAK)),0) END AS VADE_ALACAK,
				ACC_TYPE_ID
			FROM
				CARI_ROWS_EMPLOYEE
			GROUP BY
				EMPLOYEE_ID,
				PROJECT_ID,
				ACC_TYPE_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [EMPLOYEE_REMAINDER_MONEY_PROJECT] AS
			SELECT
				EMPLOYEE_ID, 
				SUM(BORC-ALACAK) AS BAKIYE, 
				SUM(BORC2-ALACAK2) AS BAKIYE2,
				SUM(BORC3-ALACAK3) AS BAKIYE3,
				SUM(BORC) AS BORC,
				SUM(BORC2) AS BORC2,
				SUM(BORC3) AS BORC3,
				SUM(ALACAK) AS ALACAK,
				SUM(ALACAK2) AS ALACAK2,
				SUM(ALACAK3) AS ALACAK3,
				OTHER_MONEY,
				PROJECT_ID,
				CASE WHEN SUM(BORC3)= 0 THEN SUM((BORC3*DATE_DIFF)) ELSE ROUND((SUM((BORC3*DATE_DIFF))/SUM(BORC3)),0) END AS VADE_BORC3,
				CASE WHEN SUM(ALACAK3)= 0 THEN SUM((ALACAK3*DATE_DIFF)) ELSE ROUND((SUM((ALACAK3*DATE_DIFF))/SUM(ALACAK3)),0) END AS VADE_ALACAK3,
				ACC_TYPE_ID
			FROM
				CARI_ROWS_EMPLOYEE
			GROUP BY
				EMPLOYEE_ID,
				OTHER_MONEY,
				PROJECT_ID,
				ACC_TYPE_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [EMPLOYEE_REMAINDER_BRANCH] AS
			SELECT
				EMPLOYEE_ID,
				BRANCH_ID,
				ROUND(SUM(BORC-ALACAK),5) AS BAKIYE, 
				ROUND(SUM(BORC2-ALACAK2),5) AS BAKIYE2,
				ROUND(SUM(BORC),5) AS BORC,
				ROUND(SUM(BORC2),5) AS BORC2,
				ROUND(SUM(ALACAK),5) AS ALACAK,
				ROUND(SUM(ALACAK2),5) AS ALACAK2,
				CASE WHEN SUM(BORC)= 0 THEN SUM((BORC*DATE_DIFF)) ELSE ROUND((SUM((BORC*DATE_DIFF))/SUM(BORC)),0) END AS VADE_BORC,
				CASE WHEN SUM(ALACAK)= 0 THEN SUM((ALACAK*DATE_DIFF)) ELSE ROUND((SUM((ALACAK*DATE_DIFF))/SUM(ALACAK)),0) END AS VADE_ALACAK,	
				CASE WHEN SUM(BORC)= 0 THEN SUM((BORC*DUE_DATE_DIFF)) ELSE ROUND((SUM((BORC*DUE_DATE_DIFF))/SUM(BORC)),0) END AS VADE_BORC_NEW,
				CASE WHEN SUM(ALACAK)= 0 THEN SUM((ALACAK*DUE_DATE_DIFF)) ELSE ROUND((SUM((ALACAK*DUE_DATE_DIFF))/SUM(ALACAK)),0) END AS VADE_ALACAK_NEW
			FROM
				CARI_ROWS_EMPLOYEE
			GROUP BY
				EMPLOYEE_ID,
				BRANCH_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [EMPLOYEE_REMAINDER_MONEY_BRANCH] AS
			SELECT
				EMPLOYEE_ID, 
				BRANCH_ID,
				SUM(BORC-ALACAK) AS BAKIYE, 
				SUM(BORC2-ALACAK2) AS BAKIYE2,
				SUM(BORC3-ALACAK3) AS BAKIYE3,
				SUM(BORC) AS BORC,
				SUM(BORC2) AS BORC2,
				SUM(BORC3) AS BORC3,
				SUM(ALACAK) AS ALACAK,
				SUM(ALACAK2) AS ALACAK2,
				SUM(ALACAK3) AS ALACAK3,
				OTHER_MONEY,
				CASE WHEN SUM(BORC3)= 0 THEN SUM((BORC3*DATE_DIFF)) ELSE ROUND((SUM((BORC3*DATE_DIFF))/SUM(BORC3)),0) END AS VADE_BORC3,
				CASE WHEN SUM(ALACAK3)= 0 THEN SUM((ALACAK3*DATE_DIFF)) ELSE ROUND((SUM((ALACAK3*DATE_DIFF))/SUM(ALACAK3)),0) END AS VADE_ALACAK3,
				CASE WHEN SUM(BORC3)= 0 THEN SUM((BORC3*DUE_DATE_DIFF)) ELSE ROUND((SUM((BORC3*DUE_DATE_DIFF))/SUM(BORC3)),0) END AS VADE_BORC_NEW3,
				CASE WHEN SUM(ALACAK3)= 0 THEN SUM((ALACAK3*DUE_DATE_DIFF)) ELSE ROUND((SUM((ALACAK3*DUE_DATE_DIFF))/SUM(ALACAK3)),0) END AS VADE_ALACAK_NEW3
			FROM
				CARI_ROWS_EMPLOYEE
			GROUP BY
				EMPLOYEE_ID,
				BRANCH_ID,
				OTHER_MONEY

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [EMPLOYEE_REMAINDER_MONEY_PROJECT_BRANCH] AS
			SELECT
				EMPLOYEE_ID, 
				OTHER_MONEY,
				PROJECT_ID,
				BRANCH_ID,		
				SUM(BORC-ALACAK) AS BAKIYE, 
				SUM(BORC2-ALACAK2) AS BAKIYE2,
				SUM(BORC3-ALACAK3) AS BAKIYE3,
				SUM(BORC) AS BORC,
				SUM(BORC2) AS BORC2,
				SUM(BORC3) AS BORC3,
				SUM(ALACAK) AS ALACAK,
				SUM(ALACAK2) AS ALACAK2,
				SUM(ALACAK3) AS ALACAK3,
				CASE WHEN SUM(BORC3)= 0 THEN SUM((BORC3*DATE_DIFF)) ELSE ROUND((SUM((BORC3*DATE_DIFF))/SUM(BORC3)),0) END AS VADE_BORC3,
				CASE WHEN SUM(ALACAK3)= 0 THEN SUM((ALACAK3*DATE_DIFF)) ELSE ROUND((SUM((ALACAK3*DATE_DIFF))/SUM(ALACAK3)),0) END AS VADE_ALACAK3
			FROM
				CARI_ROWS_EMPLOYEE
			GROUP BY
				EMPLOYEE_ID,
				OTHER_MONEY,
				PROJECT_ID,
				BRANCH_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [EMPLOYEE_REMAINDER_PROJECT_BRANCH] AS
			SELECT
				EMPLOYEE_ID, 
				PROJECT_ID,
				BRANCH_ID,
				ROUND(SUM(BORC-ALACAK),5) AS BAKIYE, 
				ROUND(SUM(BORC2-ALACAK2),5) AS BAKIYE2,
				ROUND(SUM(BORC),5) AS BORC,
				ROUND(SUM(BORC2),5) AS BORC2,
				ROUND(SUM(ALACAK),5) AS ALACAK,
				ROUND(SUM(ALACAK2),5) AS ALACAK2,
				CASE WHEN SUM(BORC)= 0 THEN SUM((BORC*DATE_DIFF)) ELSE ROUND((SUM((BORC*DATE_DIFF))/SUM(BORC)),0) END AS VADE_BORC,
				CASE WHEN SUM(ALACAK)= 0 THEN SUM((ALACAK*DATE_DIFF)) ELSE ROUND((SUM((ALACAK*DATE_DIFF))/SUM(ALACAK)),0) END AS VADE_ALACAK	
			FROM
				CARI_ROWS_EMPLOYEE
			GROUP BY
				EMPLOYEE_ID,
				PROJECT_ID,
				BRANCH_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_ACCOUNT_CARD] AS
			SELECT 
				ACC.ACTION_DATE,
				ACC.BILL_NO,
				ACC.CARD_CAT_ID,
				ACC.CARD_TYPE,
				ACC.CARD_TYPE_NO,	
				AP.ACCOUNT_NAME,
				AP.IFRS_CODE AS ACC_IFRS_CODE,
				AP.IFRS_NAME,
				ACC.PAPER_NO,
				ACC.ACTION_TYPE,
				ACC.CARD_DETAIL,
				ACC.IS_COMPOUND,
				ACR.*
			FROM
				ACCOUNT_CARD ACC,
				ACCOUNT_CARD_ROWS ACR,
				ACCOUNT_PLAN AP
			WHERE 
				ACR.CARD_ID=ACC.CARD_ID AND
				AP.ACCOUNT_CODE=ACR.ACCOUNT_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_ACC_CODE_TOTAL_DAILY] AS
			SELECT 
				SUM(AMOUNT) AS AMOUNT_TOTAL,
				SUM(ISNULL(AMOUNT_2,0)) AS AMOUNT_TOTAL_2,
				BA,
				ACTION_DATE,
				ACCOUNT_ID
			FROM	
				GET_ACCOUNT_CARD
			GROUP BY 
				ACCOUNT_ID,
				ACTION_DATE,
				BA

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_ACCOUNT_CARD_TOTAL_DAILY] AS
			SELECT 
				SUM(AMOUNT) AS AMOUNT_TOTAL,
				BA,
				ACTION_DATE
			FROM
				GET_ACCOUNT_CARD
			GROUP BY 
				ACTION_DATE,
				BA

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_STOCK] AS
			SELECT
				SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK, 
				S.PRODUCT_ID, 
				S.STOCK_ID, 
				S.STOCK_CODE, 
				S.PROPERTY,
				S.STOCK_STATUS, 
				S.BARCOD
			FROM
				#new_prod_db#.STOCKS S,
				STOCKS_ROW SR
			WHERE
				S.STOCK_ID = SR.STOCK_ID	
			GROUP BY
				S.PRODUCT_ID,
				S.STOCK_ID,
				S.STOCK_CODE,
				S.PROPERTY,
				S.STOCK_STATUS, 
				S.BARCOD

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_PRODUCT_STOCK] AS
			SELECT
				SUM(PRODUCT_STOCK) AS PRODUCT_TOTAL_STOCK, 
				PRODUCT_ID
			FROM
				GET_STOCK GS
			GROUP BY
				PRODUCT_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_SCEN_EXPENSE] AS

			SELECT
				-1 AS SCEN_TYPE_ID, 
				C.CHEQUE_DUEDATE AS TARIH, 
				SUM(C.CHEQUE_VALUE*(SM.RATE2/SM.RATE1)) AS CHEQUE_TOTAL,
				0 VOUCHER_TOTAL,
				0 CC_EXPENSE_TOTAL,
				0 CREDIT_CONTRACT_TOTAL,
				0 BANK_ORDER_TOTAL,
				0 BUDGET_TOTAL,
				0 SCEN_EXPENSE_TOTAL
			FROM
				CHEQUE C,
				SETUP_MONEY	SM
			WHERE
				C.CHEQUE_STATUS_ID IN (6) AND
				C.CURRENCY_ID = SM.MONEY
			GROUP BY
				C.CHEQUE_DUEDATE
		
			UNION ALL
			
			SELECT
				-2  AS SCEN_TYPE_ID, 
				V.VOUCHER_DUEDATE AS TARIH, 
				0 CHEQUE_TOTAL,
				SUM(V.VOUCHER_VALUE*(SM.RATE2/SM.RATE1)) VOUCHER_TOTAL,
				0 CC_EXPENSE_TOTAL,
				0 CREDIT_CONTRACT_TOTAL,
				0 BANK_ORDER_TOTAL,
				0 BUDGET_TOTAL,
				0 SCEN_EXPENSE_TOTAL
			FROM
				VOUCHER V,
				SETUP_MONEY	SM
			WHERE
				V.VOUCHER_STATUS_ID IN (6) AND
				V.CURRENCY_ID = SM.MONEY
			GROUP BY
				V.VOUCHER_DUEDATE
			UNION ALL
		
			SELECT
				-3 AS SCEN_TYPE_ID,
				DATEADD(d,ISNULL(CC.PAYMENT_DAY,0),CER.ACC_ACTION_DATE) AS TARIH,
				0 CHEQUE_TOTAL,
				0 VOUCHER_TOTAL,
				(CER.INSTALLMENT_AMOUNT-(ISNULL((SELECT SUM(CCBER.CLOSED_AMOUNT) FROM #new_dsn3#.CREDIT_CARD_BANK_EXPENSE_RELATIONS CCBER WHERE CCBER.CC_BANK_EXPENSE_ROWS_ID = CER.CC_BANK_EXPENSE_ROWS_ID),0)))*(CEM.RATE2/CEM.RATE1) CC_EXPENSE_TOTAL,
				0 CREDIT_CONTRACT_TOTAL,
				0 BANK_ORDER_TOTAL,
				0 BUDGET_TOTAL,
				0 SCEN_EXPENSE_TOTAL
			FROM
				#new_dsn3#.CREDIT_CARD CC,
				#new_dsn3#.CREDIT_CARD_BANK_EXPENSE CE,
				#new_dsn3#.CREDIT_CARD_BANK_EXPENSE_ROWS CER,
				#new_dsn3#.CREDIT_CARD_BANK_EXPENSE_MONEY CEM
			WHERE
				CE.CREDITCARD_EXPENSE_ID = CEM.ACTION_ID AND
				CEM.MONEY_TYPE = CE.ACTION_CURRENCY_ID AND
				CC.CREDITCARD_ID = CE.CREDITCARD_ID AND
				CE.CREDITCARD_EXPENSE_ID = CER.CREDITCARD_EXPENSE_ID AND
				CER.INSTALLMENT_AMOUNT > 0
			GROUP BY
				CER.ACC_ACTION_DATE,
				CC.PAYMENT_DAY,
				CER.CC_BANK_EXPENSE_ROWS_ID,
				CER.INSTALLMENT_AMOUNT,
				CEM.RATE2,
				CEM.RATE1
			UNION ALL
			
			SELECT
				-4 AS SCEN_TYPE_ID,
				PROCESS_DATE AS TARIH,
				0 CHEQUE_TOTAL,
				0 VOUCHER_TOTAL,
				0 CC_EXPENSE_TOTAL,
				(TOTAL_PRICE * (SM.RATE2 / SM.RATE1)) CREDIT_CONTRACT_TOTAL,
				0 BANK_ORDER_TOTAL,
				0 BUDGET_TOTAL,
				0 SCEN_EXPENSE_TOTAL
			FROM
				#new_dsn3#.CREDIT_CONTRACT_ROW CC,
				#new_dsn3#.CREDIT_CONTRACT C,
				SETUP_MONEY SM
			WHERE
				C.CREDIT_CONTRACT_ID = CC.CREDIT_CONTRACT_ID AND
				C.IS_SCENARIO = 1 AND
				CREDIT_CONTRACT_TYPE = 1 AND
				TOTAL_PRICE > 0 AND
			
				((CC.OTHER_MONEY = 'YTL' AND SM.MONEY = 'TL') OR SM.MONEY = CC.OTHER_MONEY) AND
				
				CC.IS_PAID = 0 AND
				(CC.IS_PAID_ROW  = 0 OR CC.IS_PAID_ROW IS NULL)
			UNION ALL
			SELECT
				-5 AS SCEN_TYPE_ID,
				PAYMENT_DATE AS TARIH,
				0 CHEQUE_TOTAL,
				0 VOUCHER_TOTAL,
				0 CC_EXPENSE_TOTAL,
				0 CREDIT_CONTRACT_TOTAL,
				SUM(BON.ACTION_VALUE*(SM.RATE2/SM.RATE1)) AS BANK_ORDER_TOTAL,
				0 BUDGET_TOTAL,
				0 SCEN_EXPENSE_TOTAL
			FROM
				BANK_ORDERS BON,
				SETUP_MONEY SM
			WHERE
				(BON.IS_PAID = 0 OR BON.IS_PAID IS NULL)
				AND BON.ACTION_MONEY = SM.MONEY
				AND BANK_ORDER_TYPE = 250
			GROUP BY
				PAYMENT_DATE,
				SM.RATE2, 
				SM.RATE1
			UNION ALL
			SELECT
				-6 AS SCEN_TYPE_ID,
				BPR.PLAN_DATE AS TARIH,
				0 CHEQUE_TOTAL,
				0 VOUCHER_TOTAL,
				0 CC_EXPENSE_TOTAL,
				0 CREDIT_CONTRACT_TOTAL,
				0 BANK_ORDER_TOTAL,
				SUM(BPR.OTHER_ROW_TOTAL_EXPENSE*(SM.RATE2/SM.RATE1)) AS BUDGET_TOTAL,
				0 SCEN_EXPENSE_TOTAL
			FROM
				#new_dsn#.BUDGET_PLAN BP,
				#new_dsn#.BUDGET_PLAN_ROW BPR,
				SETUP_MONEY SM
			WHERE
				BP.BUDGET_PLAN_ID = BPR.BUDGET_PLAN_ID 
				AND BP.OTHER_MONEY = SM.MONEY
				AND BP.IS_SCENARIO = 1
			GROUP BY
				BPR.PLAN_DATE,
				SM.RATE2, 
				SM.RATE1
			UNION ALL
			SELECT
				SE.SCENARIO_TYPE_ID AS SCEN_TYPE_ID, 
				SE.START_DATE AS TARIH,
				0 CHEQUE_TOTAL,
				0 VOUCHER_TOTAL,
				0 CC_EXPENSE_TOTAL,		
				0 CREDIT_CONTRACT_TOTAL,
				0 BANK_ORDER_TOTAL,
				0 BUDGET_TOTAL,
				SUM(SE.PERIOD_VALUE*(SM.RATE2/SM.RATE1)) SCEN_EXPENSE_TOTAL
			FROM
				#new_dsn3#.SCEN_EXPENSE_PERIOD_ROWS SE, 
				SETUP_MONEY SM
			WHERE
				SE.TYPE = 0 AND
				SM.MONEY = SE.PERIOD_CURRENCY AND
				SE.SCEN_EXPENSE_STATUS = 1
			GROUP BY
				SE.START_DATE,
				SE.PERIOD_VALUE, 
				SM.RATE2, 
				SM.RATE1,
				SE.SCENARIO_TYPE_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_SCEN_INCOME] AS
			SELECT
				-1 AS SCEN_TYPE_ID, 
				C.CHEQUE_DUEDATE AS TARIH, 
				SUM(C.CHEQUE_VALUE*(SM.RATE2/SM.RATE1)) AS CHEQUE_TOTAL,
				0 VOUCHER_TOTAL,
				0 CC_BANK_PAYM,		
				0 CREDIT_CONTRACT_TOTAL,
				0 BANK_ORDER_TOTAL,
				0 BUDGET_TOTAL,
				0 SCEN_EXPENSE_TOTAL
			FROM
				CHEQUE C,
				SETUP_MONEY	SM
			WHERE
				C.CHEQUE_STATUS_ID IN (1,2,13) AND
				C.CURRENCY_ID = SM.MONEY
			GROUP BY
				C.CHEQUE_DUEDATE
		UNION ALL
			SELECT
				-2 AS SCEN_TYPE_ID, 
				V.VOUCHER_DUEDATE AS TARIH,
				0 CHEQUE_TOTAL,
				SUM(V.VOUCHER_VALUE*(SM.RATE2/SM.RATE1)) VOUCHER_TOTAL,
				0 CC_BANK_PAYM,		
				0 CREDIT_CONTRACT_TOTAL,
				0 BANK_ORDER_TOTAL,
				0 BUDGET_TOTAL,
				0 SCEN_EXPENSE_TOTAL
			FROM
				VOUCHER V,
				SETUP_MONEY	SM
			WHERE
				V.VOUCHER_STATUS_ID IN (1,2,13) AND
				V.CURRENCY_ID = SM.MONEY
			GROUP BY
				V.VOUCHER_DUEDATE
		UNION ALL
			SELECT
				-3 AS SCEN_TYPE_ID,
				CR.BANK_ACTION_DATE AS TARIH,
				0 CHEQUE_TOTAL,
				0 VOUCHER_TOTAL,
				SUM((CASE WHEN CCP.ACTION_TYPE_ID = 245 THEN -CR.AMOUNT ELSE CR.AMOUNT END)) AS CC_BANK_PAYM,
				0 CREDIT_CONTRACT_TOTAL,
				0 BANK_ORDER_TOTAL,
				0 BUDGET_TOTAL,
				0 SCEN_EXPENSE_TOTAL
			FROM
				#new_dsn3#.CREDIT_CARD_BANK_PAYMENTS_ROWS CR,
				#new_dsn3#.CREDIT_CARD_BANK_PAYMENTS CCP
			WHERE
				CR.CREDITCARD_PAYMENT_ID = CCP.CREDITCARD_PAYMENT_ID AND
				ISNULL(CCP.IS_VOID,0) <> 1 AND
				ISNULL(CCP.RELATION_CREDITCARD_PAYMENT_ID,0) NOT IN (SELECT CCBP.CREDITCARD_PAYMENT_ID FROM #new_dsn3#.CREDIT_CARD_BANK_PAYMENTS CCBP WHERE ISNULL(CCBP.IS_VOID,0) = 1) AND
				CR.BANK_ACTION_ID IS NULL AND
				CR.AMOUNT > 0
			GROUP BY
				CR.BANK_ACTION_DATE
		UNION ALL
			SELECT
				-4 AS SCEN_TYPE_ID,
				PROCESS_DATE AS TARIH,
				0 CHEQUE_TOTAL,
				0 VOUCHER_TOTAL,
				0 CC_BANK_PAYM,		
				(TOTAL_PRICE * (SM.RATE2 / SM.RATE1)) CREDIT_CONTRACT_TOTAL,
				0 BANK_ORDER_TOTAL,
				0 BUDGET_TOTAL,
				0 SCEN_EXPENSE_TOTAL
			FROM
				#new_dsn3#.CREDIT_CONTRACT_ROW CC,
				#new_dsn3#.CREDIT_CONTRACT C,
				SETUP_MONEY SM
			WHERE
				C.CREDIT_CONTRACT_ID = CC.CREDIT_CONTRACT_ID AND
				C.IS_SCENARIO = 1 AND
				CREDIT_CONTRACT_TYPE = 2 AND
				TOTAL_PRICE > 0 AND
			
				((CC.OTHER_MONEY = 'YTL' AND SM.MONEY = 'TL') OR SM.MONEY = CC.OTHER_MONEY) AND
				
				CC.IS_PAID = 0 AND
				(CC.IS_PAID_ROW  = 0 OR CC.IS_PAID_ROW IS NULL)
		UNION ALL
			SELECT
				-5 AS SCEN_TYPE_ID,
				PAYMENT_DATE AS TARIH,
				0 CHEQUE_TOTAL,
				0 VOUCHER_TOTAL,
				0 CC_EXPENSE_TOTAL,
				0 CREDIT_CONTRACT_TOTAL,
				SUM(BON.ACTION_VALUE*(SM.RATE2/SM.RATE1)) AS BANK_ORDER_TOTAL,
				0 BUDGET_TOTAL,
				0 SCEN_EXPENSE_TOTAL
			FROM
				BANK_ORDERS BON,
				SETUP_MONEY SM
			WHERE
				(BON.IS_PAID = 0 OR BON.IS_PAID IS NULL)
				AND BON.ACTION_MONEY = SM.MONEY
				AND BANK_ORDER_TYPE = 251
			GROUP BY
				PAYMENT_DATE,
				SM.RATE2, 
				SM.RATE1
		UNION ALL
			SELECT
				-6 AS SCEN_TYPE_ID,
				BPR.PLAN_DATE AS TARIH,
				0 CHEQUE_TOTAL,
				0 VOUCHER_TOTAL,
				0 CC_EXPENSE_TOTAL,
				0 CREDIT_CONTRACT_TOTAL,
				0 BANK_ORDER_TOTAL,
				SUM(BPR.OTHER_ROW_TOTAL_INCOME*(SM.RATE2/SM.RATE1)) AS BUDGET_TOTAL,
				0 SCEN_EXPENSE_TOTAL
			FROM
				#new_dsn#.BUDGET_PLAN BP,
				#new_dsn#.BUDGET_PLAN_ROW BPR,
				SETUP_MONEY SM
			WHERE
				BP.BUDGET_PLAN_ID = BPR.BUDGET_PLAN_ID 
				AND BP.OTHER_MONEY = SM.MONEY
				AND BP.IS_SCENARIO = 1
			GROUP BY
				BPR.PLAN_DATE,
				SM.RATE2, 
				SM.RATE1
		UNION ALL
			SELECT
				SE.SCENARIO_TYPE_ID AS SCEN_TYPE_ID, 
				SE.START_DATE AS TARIH, 
				0 CHEQUE_TOTAL,
				0 VOUCHER_TOTAL,
				0 CC_BANK_PAYM,		
				0 CREDIT_CONTRACT_TOTAL,
				0 BANK_ORDER_TOTAL,
				0 BUDGET_TOTAL,
				SUM(SE.PERIOD_VALUE * (SM.RATE2 / SM.RATE1)) SCEN_EXPENSE_TOTAL
			FROM
				#new_dsn3#.SCEN_EXPENSE_PERIOD_ROWS SE, 
				SETUP_MONEY SM
			WHERE
				SE.TYPE = 1 AND 
				SE.SCEN_EXPENSE_STATUS = 1 AND
				SM.MONEY = SE.PERIOD_CURRENCY
			GROUP BY
				SE.START_DATE, 
				SE.PERIOD_VALUE, 
				SM.RATE2, 
				SM.RATE1,
				SE.SCENARIO_TYPE_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_SCEN_LAST] AS
			SELECT
				SE.SCEN_TYPE_ID,
				SE.TARIH AS THEDATE,
				SUM(SE.CHEQUE_TOTAL) ALACAK_CHEQUE_TOTAL,
				SUM(SE.VOUCHER_TOTAL) ALACAK_VOUCHER_TOTAL,
				SUM(SE.CC_EXPENSE_TOTAL) ALACAK_CC_TOTAL,		
				SUM(SE.CREDIT_CONTRACT_TOTAL) ALACAK_CREDIT_CONTRACT_TOTAL,
				SUM(SE.BANK_ORDER_TOTAL) ALACAK_BANK_ORDER_TOTAL,
				SUM(SE.SCEN_EXPENSE_TOTAL) ALACAK_SCEN_EXPENSE_TOTAL,
				SUM(SE.BUDGET_TOTAL) ALACAK_BUDGET_TOTAL,
				0 BORC_CHEQUE_TOTAL,
				0 BORC_VOUCHER_TOTAL,
				0 BORC_CC_TOTAL,		
				0 BORC_CREDIT_CONTRACT_TOTAL,
				0 BORC_BANK_ORDER_TOTAL,
				0 BORC_SCEN_EXPENSE_TOTAL,
				0 BORC_BUDGET_TOTAL
			FROM
				GET_SCEN_EXPENSE SE
			GROUP BY
				SE.TARIH,
				SE.SCEN_TYPE_ID
		UNION ALL
			SELECT
				SI.SCEN_TYPE_ID,
				SI.TARIH AS THEDATE,
				0 ALACAK_CHEQUE_TOTAL,
				0 ALACAK_VOUCHER_TOTAL,
				0 ALACAK_CC_TOTAL,		
				0 ALACAK_CREDIT_CONTRACT_TOTAL,
				0 ALACAK_BANK_ORDER_TOTAL,
				0 ALACAK_SCEN_EXPENSE_TOTAL,
				0 ALACAK_BUDGET_TOTAL,
				SUM(SI.CHEQUE_TOTAL) BORC_CHEQUE_TOTAL,
				SUM(SI.VOUCHER_TOTAL) BORC_VOUCHER_TOTAL,
				SUM(SI.CC_BANK_PAYM) BORC_CC_TOTAL,		
				SUM(SI.CREDIT_CONTRACT_TOTAL) BORC_CREDIT_CONTRACT_TOTAL,
				SUM(SI.BANK_ORDER_TOTAL) BORC_BANK_ORDER_TOTAL,
				SUM(SI.SCEN_EXPENSE_TOTAL) BORC_SCEN_EXPENSE_TOTAL,
				SUM(SI.BUDGET_TOTAL) BORC_BUDGET_TOTAL
			FROM
				GET_SCEN_INCOME SI
			GROUP BY
				SI.TARIH, 
				SI.SCEN_TYPE_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [INVOICE_DAILY_SALES] AS
		SELECT
			SUM(AMOUNT) AS TOTAL_AMOUNT,
			I.INVOICE_DATE,
			IR.PRODUCT_ID,
			IR.STOCK_ID,
			I.DEPARTMENT_ID
		FROM
			INVOICE I,
			INVOICE_ROW IR
		WHERE
			I.INVOICE_ID = IR.INVOICE_ID				
			AND I.PURCHASE_SALES=1
			AND INVOICE_CAT <>66
		GROUP BY
			I.INVOICE_DATE,
			I.DEPARTMENT_ID,
			IR.PRODUCT_ID,
			IR.STOCK_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_STOCK_STRATEGY] AS
			(	
				(
				SELECT
					PRODUCT_ID,
					STOCK_ID,
					SUM(MINIMUM_STOCK) AS MINIMUM_STOCK,
					SUM(MAXIMUM_STOCK) AS MAXIMUM_STOCK,
					SUM(REPEAT_STOCK_VALUE) AS REPEAT_STOCK_VALUE,
					SUM(BLOCK_STOCK_VALUE) AS BLOCK_STOCK_VALUE,
					1 AS STRATEGY_TYPE,
					DEPARTMENT_ID,
					PROVISION_TIME,
					IS_LIVE_ORDER,
					MINIMUM_ORDER_STOCK_VALUE,
					MAXIMUM_ORDER_STOCK_VALUE,
					STOCK_ACTION_ID
				FROM
				(
					(
					SELECT
						TOTAL_AMOUNT AS MINIMUM_STOCK,
						0 AS MAXIMUM_STOCK,
						0 AS REPEAT_STOCK_VALUE,
						0 AS BLOCK_STOCK_VALUE,
						SS.PRODUCT_ID,
						SS.STOCK_ID,
						SS.DEPARTMENT_ID,
						SS.PROVISION_TIME,
						SS.IS_LIVE_ORDER,
						SS.MINIMUM_ORDER_STOCK_VALUE,
						SS.MAXIMUM_ORDER_STOCK_VALUE,
						SS.STOCK_ACTION_ID
					FROM
						INVOICE_DAILY_SALES IDS,
						#new_dsn3#.STOCK_STRATEGY SS 
					WHERE
						IDS.STOCK_ID=SS.STOCK_ID				
						AND DATEDIFF(day,IDS.INVOICE_DATE, getdate()) <= MINIMUM_STOCK
						AND SS.STRATEGY_TYPE=1
					)
				UNION ALL
					(
					SELECT
						0 AS MINIMUM_STOCK,
						TOTAL_AMOUNT AS MAXIMUM_STOCK,
						0 AS REPEAT_STOCK_VALUE,
						0 AS BLOCK_STOCK_VALUE,
						SS.PRODUCT_ID,
						SS.STOCK_ID,
						SS.DEPARTMENT_ID,
						SS.PROVISION_TIME,
						SS.IS_LIVE_ORDER,
						SS.MINIMUM_ORDER_STOCK_VALUE,
						SS.MAXIMUM_ORDER_STOCK_VALUE,
						SS.STOCK_ACTION_ID
					FROM
						INVOICE_DAILY_SALES IDS,
						#new_dsn3#.STOCK_STRATEGY SS
					WHERE
						IDS.STOCK_ID=SS.STOCK_ID				
						AND DATEDIFF(day,IDS.INVOICE_DATE, getdate()) <= MAXIMUM_STOCK
						AND SS.STRATEGY_TYPE=1
					)
				UNION ALL
					(
					SELECT
						0 AS MINIMUM_STOCK,
						0 AS MAXIMUM_STOCK,
						TOTAL_AMOUNT AS REPEAT_STOCK_VALUE,
						0 AS BLOCK_STOCK_VALUE,
						SS.PRODUCT_ID,
						SS.STOCK_ID,
						SS.DEPARTMENT_ID,
						SS.PROVISION_TIME,
						SS.IS_LIVE_ORDER,
						SS.MINIMUM_ORDER_STOCK_VALUE,
						SS.MAXIMUM_ORDER_STOCK_VALUE,
						SS.STOCK_ACTION_ID
					FROM
						INVOICE_DAILY_SALES IDS,
						#new_dsn3#.STOCK_STRATEGY SS
					WHERE
						IDS.STOCK_ID=SS.STOCK_ID				
						AND DATEDIFF(day,IDS.INVOICE_DATE, getdate()) <= REPEAT_STOCK_VALUE
						AND SS.STRATEGY_TYPE=1 
					)
				) AS ALL_TABLE
				GROUP BY 
					PRODUCT_ID,
					STOCK_ID,
					DEPARTMENT_ID,
					PROVISION_TIME,
					IS_LIVE_ORDER,
					MINIMUM_ORDER_STOCK_VALUE,
					MAXIMUM_ORDER_STOCK_VALUE,
					STOCK_ACTION_ID
				)
			UNION ALL
				(
				SELECT
					PRODUCT_ID,
					STOCK_ID,
					MINIMUM_STOCK,
					MAXIMUM_STOCK,
					REPEAT_STOCK_VALUE,
					BLOCK_STOCK_VALUE,
					STRATEGY_TYPE,
					DEPARTMENT_ID,
					PROVISION_TIME,
					IS_LIVE_ORDER,
					MINIMUM_ORDER_STOCK_VALUE,
					MAXIMUM_ORDER_STOCK_VALUE,
					STOCK_ACTION_ID
				FROM
					#new_dsn3#.STOCK_STRATEGY SS
				WHERE
					STRATEGY_TYPE=0
				)
			)

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_STOCKS_ROW_COST] AS
		SELECT 
			(SUM(NET_MALIYET)/COUNT(PRODUCT_ID))  AS MALIYET,
			(SUM(NET_MALIYET_2)/COUNT(PRODUCT_ID))  AS MALIYET_2,
			SUM(STOCK_IN)  AS STOCK_IN,
			SUM(STOCK_OUT)  AS STOCK_OUT,
			UPD_ID,
			PROCESS_DATE,
			PROCESS_TYPE,
			STORE,
			STORE_LOCATION,
			PRODUCT_ID,
			STOCK_ID
		FROM
			GET_ALL_STOCKS_ROW_COST
		GROUP BY
			UPD_ID,
			PROCESS_DATE,
			PROCESS_TYPE,
			STORE,
			STORE_LOCATION,
			PRODUCT_ID,
			STOCK_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_TAX] AS
			SELECT
				SUM(AMOUNT) AS BORC, 
				0 AS ALACAK, 
				DATEPART(MONTH, 
				AC.ACTION_DATE) AS AY
			FROM
				ACCOUNT_CARD_ROWS ACR, 
				ACCOUNT_CARD AC
			WHERE
				AC.CARD_ID = ACR.CARD_ID AND 
				ACR.BA = 0 AND ACR.ACCOUNT_ID LIKE '391%'
			GROUP BY
				DATEPART(MONTH, AC.ACTION_DATE)
		UNION
			SELECT
				0 AS BORC, 
				SUM(AMOUNT) AS ALACAK, 
				DATEPART(MONTH, AC.ACTION_DATE) AS AY
			FROM
				ACCOUNT_CARD_ROWS ACR, 
				ACCOUNT_CARD AC
			WHERE
				AC.CARD_ID = ACR.CARD_ID AND 
				ACR.BA = 1 AND ACR.ACCOUNT_ID LIKE '391%'
			GROUP BY

				DATEPART(MONTH, AC.ACTION_DATE)
		UNION
			SELECT
				SUM(AMOUNT) AS BORC, 
				0 AS ALACAK, 
				DATEPART(MONTH, AC.ACTION_DATE) AS AY
			FROM
				ACCOUNT_CARD_ROWS ACR, 
				ACCOUNT_CARD AC
			WHERE
				AC.CARD_ID = ACR.CARD_ID AND 
				ACR.BA = 0 AND ACR.ACCOUNT_ID LIKE '191%'
			GROUP BY
				DATEPART(MONTH, AC.ACTION_DATE)
		UNION
			SELECT
				0 AS BORC, 
				SUM(AMOUNT) AS ALACAK, 
				DATEPART(MONTH, AC.ACTION_DATE) AS AY
			FROM
				ACCOUNT_CARD_ROWS ACR, 
				ACCOUNT_CARD AC
			WHERE
				AC.CARD_ID = ACR.CARD_ID AND 
				ACR.BA = 1 AND ACR.ACCOUNT_ID LIKE '191%'
			GROUP BY
				DATEPART(MONTH, AC.ACTION_DATE)

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_TAX_LAST] AS
			SELECT
				SUM(BORC - ALACAK) AS BAKIYE,
				SUM(BORC) AS BORC, 
				SUM(ALACAK) AS ALACAK, 
				AY
			FROM
				GET_TAX
			GROUP BY
				AY

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [INVOICE_ROW_SALES_DETAIL] AS
	 SELECT 
		DEPARTMENT_ID, 
		INVOICE_DATE,
		COMPANY_ID,
		NETTOTAL,	
		GROSSTOTAL,
		INVOICE_ID,
		INVOICE_ROW_ID,
		STOCK_ID,
		PRODUCT_ID,
		AMOUNT,
		SALE_EMP,
		(INV_M.RATE2/INV_M.RATE1) AS OTHER_MONEY_RATE,
		ISNULL((SELECT
				TOP 1 (PURCHASE_NET_SYSTEM + PURCHASE_EXTRA_COST_SYSTEM)  
			FROM 
				GET_PRODUCT_COST_PERIOD
			WHERE
				GET_PRODUCT_COST_PERIOD.START_DATE <= INV_TOTAL.INVOICE_DATE
				AND GET_PRODUCT_COST_PERIOD.PRODUCT_ID = INV_TOTAL.PRODUCT_ID
				AND ISNUMERIC(GET_PRODUCT_COST_PERIOD.SPECT_MAIN_ID)=0
			ORDER BY
				GET_PRODUCT_COST_PERIOD.START_DATE DESC,
				GET_PRODUCT_COST_PERIOD.RECORD_DATE DESC
				),0) AS PROD_COST
	FROM
		(
		SELECT	
			I.DEPARTMENT_ID, 
			I.INVOICE_DATE,
			I.COMPANY_ID,
			CASE WHEN (I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)= 0 THEN IR.NETTOTAL ELSE ((1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) *IR.NETTOTAL) END AS NETTOTAL,	
			CASE WHEN (I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)= 0 THEN (IR.NETTOTAL + (IR.TAXTOTAL*ISNULL(I.TEVKIFAT_ORAN/100,1) )-(IR.NETTOTAL * ISNULL(I.STOPAJ_ORAN/100,0) )) ELSE (  ( (1- (I.SA_DISCOUNT)/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT) ) * IR.NETTOTAL) + (IR.TAXTOTAL*ISNULL(I.TEVKIFAT_ORAN/100,1)) - (IR.NETTOTAL * ISNULL(I.STOPAJ_ORAN/100,0) ) ) END AS GROSSTOTAL,
			I.INVOICE_ID,
			IR.INVOICE_ROW_ID,
			IR.STOCK_ID,
			IR.PRODUCT_ID,
			IR.AMOUNT,
			I.SALE_EMP	
		FROM
			INVOICE I,
			INVOICE_ROW IR
		WHERE
			I.INVOICE_ID=IR.INVOICE_ID
			AND I.INVOICE_CAT IN (48,50,52,53,531,56,58,62,561)
			AND I.IS_IPTAL=0
			AND I.NETTOTAL > 0
		UNION ALL		
			SELECT	
			I.DEPARTMENT_ID, 
			I.INVOICE_DATE,
			I.COMPANY_ID,
			CASE WHEN (I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)= 0 THEN (-1)*IR.NETTOTAL ELSE ((1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) *IR.NETTOTAL*(-1)) END AS NETTOTAL,
			CASE WHEN (I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)= 0 THEN  (-1)*(IR.NETTOTAL + (IR.TAXTOTAL*ISNULL(I.TEVKIFAT_ORAN/100,1) )-(IR.NETTOTAL * ISNULL(I.STOPAJ_ORAN/100,0) )) ELSE (-1)*(  ( (1- (I.SA_DISCOUNT)/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT) ) * IR.NETTOTAL) + (IR.TAXTOTAL*ISNULL(I.TEVKIFAT_ORAN/100,1)) - (IR.NETTOTAL * ISNULL(I.STOPAJ_ORAN/100,0) ) ) END AS GROSSTOTAL,	
			I.INVOICE_ID,
			IR.INVOICE_ROW_ID,
			IR.STOCK_ID,
			IR.PRODUCT_ID,
			IR.AMOUNT,
			I.SALE_EMP	
		FROM
			INVOICE I,
			INVOICE_ROW IR
		WHERE
			I.INVOICE_ID=IR.INVOICE_ID
			AND I.INVOICE_CAT IN (51,54,55,63)
			AND I.IS_IPTAL=0
			AND I.NETTOTAL > 0
		) AS INV_TOTAL,
		INVOICE_MONEY INV_M,
		#new_dsn#.SETUP_PERIOD STP
	WHERE
		INV_M.ACTION_ID=INV_TOTAL.INVOICE_ID
		AND STP.PERIOD_ID=#PERIOD_ID# 
        AND INV_M.MONEY_TYPE = ISNULL(STP.OTHER_MONEY,'TL')

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [INVOICE_ROW_POS_SALES_DETAIL] AS 
		SELECT
			I.DEPARTMENT_ID,
			I.INVOICE_DATE,
			I.COMPANY_ID,
			IRP.NETTOTAL,
			IRP.GROSSTOTAL,
			I.INVOICE_ID,
			IRP.INVOICE_ROW_ID INVOICE_POS_ROW_ID,
			IRP.STOCK_ID,
			IRP.PRODUCT_ID,
			IRP.AMOUNT,
			I.SALE_EMP,
			ISNULL(	(SELECT
					TOP 1 (MNY_H.RATE2/MNY_H.RATE1) AS RATE
				FROM 
					#new_dsn#.MONEY_HISTORY MNY_H,
					#new_dsn#.SETUP_PERIOD SET_PRD
				WHERE 
					SET_PRD.PERIOD_ID=#PERIOD_ID#
					AND MNY_H.PERIOD_ID= SET_PRD.PERIOD_ID
					
					AND MNY_H.MONEY = ISNULL(SET_PRD.OTHER_MONEY,'TL')
					
					AND MNY_H.VALIDATE_DATE <= I.INVOICE_DATE
				ORDER BY MONEY_HISTORY_ID DESC),		
			
				(SELECT
					(SM.RATE2/SM.RATE1) AS RATE
				FROM 
					SETUP_MONEY SM,
					#new_dsn#.SETUP_PERIOD SET_PRD
				WHERE 
					SET_PRD.PERIOD_ID = #PERIOD_ID# 
					AND SM.MONEY=ISNULL(SET_PRD.OTHER_MONEY,'TL')
					
					
				)
			) AS OTHER_MONEY_RATE,	
			ISNULL((SELECT
				TOP 1 (PURCHASE_NET_SYSTEM + PURCHASE_EXTRA_COST_SYSTEM)  
			FROM 
				GET_PRODUCT_COST_PERIOD
			WHERE
				GET_PRODUCT_COST_PERIOD.START_DATE <= I.INVOICE_DATE
				AND GET_PRODUCT_COST_PERIOD.PRODUCT_ID = IRP.PRODUCT_ID
				AND ISNUMERIC(GET_PRODUCT_COST_PERIOD.SPECT_MAIN_ID)=0
			ORDER BY
				GET_PRODUCT_COST_PERIOD.START_DATE DESC,
				GET_PRODUCT_COST_PERIOD.RECORD_DATE DESC
				),0) AS PROD_COST
		FROM
			INVOICE I,
			INVOICE_ROW_POS IRP	
		WHERE
			I.INVOICE_ID=IRP.INVOICE_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [DAILY_TOTAL_SALES] AS
    SELECT
		D.BRANCH_ID,
		INVOICE_DATE,
		SUM(NETTOTAL) NET_SALE,
		SUM(NETTOTAL/OTHER_MONEY_RATE) NET_SALE_OTHER_MONEY,
		SUM(GROSSTOTAL) TOTAL_SALE,
		SUM(GROSSTOTAL/OTHER_MONEY_RATE) TOTAL_SALE_OTHER_MONEY,
		COUNT(DISTINCT INVOICE_ID) INVOICE_COUNT,
		COUNT(DISTINCT INVOICE_ROW_ID) INVOICE_ROW_COUNT,
		COUNT(DISTINCT INVOICE_POS_ROW_ID) INVOICE_POS_ROW_COUNT,
		COUNT(DISTINCT STOCK_ID) STOCK_UNIQUE_COUNT,
		SUM(AMOUNT) AMOUNT,
		SUM(PROD_COST*AMOUNT) TOTAL_COST,
		SUM((PROD_COST/OTHER_MONEY_RATE)*AMOUNT) TOTAL_COST_OTHER_MONEY,
		SALE_EMP
	FROM
		(
		SELECT DEPARTMENT_ID,INVOICE_DATE,NETTOTAL,GROSSTOTAL,INVOICE_ID,'0' AS INVOICE_ROW_ID,INVOICE_POS_ROW_ID,STOCK_ID,AMOUNT,PROD_COST,OTHER_MONEY_RATE,SALE_EMP FROM INVOICE_ROW_POS_SALES_DETAIL
		UNION ALL
		SELECT DEPARTMENT_ID,INVOICE_DATE,NETTOTAL,GROSSTOTAL,INVOICE_ID,INVOICE_ROW_ID,'0' AS INVOICE_POS_ROW_ID,STOCK_ID,AMOUNT,PROD_COST,OTHER_MONEY_RATE,SALE_EMP FROM INVOICE_ROW_SALES_DETAIL		
		) AS GET_ALL_SALES,
		#new_dsn#.DEPARTMENT D
	WHERE
		GET_ALL_SALES.DEPARTMENT_ID=D.DEPARTMENT_ID	
	GROUP BY 
		D.BRANCH_ID,
		INVOICE_DATE,
		SALE_EMP

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [DAILY_PRODUCT_SALES] AS
		SELECT
			STOCK_ID,
			PRODUCT_ID,
			COMPANY_ID,
			DEPARTMENT_ID,
			INVOICE_DATE,
			SUM(NETTOTAL) NET_SALE,
			SUM(NETTOTAL/OTHER_MONEY_RATE) NET_SALE_OTHER_MONEY,
			SUM(GROSSTOTAL) TOTAL_SALE,
			SUM(GROSSTOTAL/OTHER_MONEY_RATE) TOTAL_SALE_OTHER_MONEY,
			COUNT(DISTINCT INVOICE_ID) INVOICE_COUNT,
			COUNT(DISTINCT INVOICE_ROW_ID) INVOICE_ROW_COUNT,
			COUNT(DISTINCT INVOICE_POS_ROW_ID) INVOICE_POS_ROW_COUNT,
			COUNT(DISTINCT STOCK_ID) STOCK_UNIQUE_COUNT,
			SUM(AMOUNT) AMOUNT,
			SUM(PROD_COST*AMOUNT) TOTAL_COST,
			SUM((PROD_COST/OTHER_MONEY_RATE)*AMOUNT) TOTAL_COST_OTHER_MONEY
		FROM
			(
			SELECT 
				DEPARTMENT_ID,INVOICE_DATE,COMPANY_ID,
				NETTOTAL,GROSSTOTAL,INVOICE_ID,
				'0'AS INVOICE_ROW_ID,INVOICE_POS_ROW_ID,
				STOCK_ID,PRODUCT_ID,AMOUNT,
				PROD_COST,OTHER_MONEY_RATE 
			FROM 
				INVOICE_ROW_POS_SALES_DETAIL
			UNION ALL
			SELECT 
				DEPARTMENT_ID,INVOICE_DATE,COMPANY_ID,
				NETTOTAL,GROSSTOTAL,INVOICE_ID,
				INVOICE_ROW_ID,'0'INVOICE_POS_ROW_ID,
				STOCK_ID,PRODUCT_ID,AMOUNT,
				PROD_COST,OTHER_MONEY_RATE 
			FROM 
				INVOICE_ROW_SALES_DETAIL		
	
	
			) AS GET_ALL_SALES
		GROUP BY 
			STOCK_ID,
			PRODUCT_ID,
			COMPANY_ID,
			DEPARTMENT_ID,
			INVOICE_DATE

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [DAILY_BRANCH_SALES] AS
	SELECT
		D.BRANCH_ID,
		INVOICE_DATE,
		SUM(NET_SALE) NETTOTAL ,
		SUM(NET_SALE_OTHER_MONEY) OTHER_MONEY_NETTOTAL ,
		SUM(TOTAL_SALE) GROSSTOTAL ,
		SUM(TOTAL_SALE_OTHER_MONEY) OTHER_MONEY_GROSSTOTAL ,
		SUM(AMOUNT) AMOUNT,
		SUM(TOTAL_COST) TOTAL_COST ,
		SUM(TOTAL_COST_OTHER_MONEY) TOTAL_COST_OTHER_MONEY 
	FROM	
		DAILY_PRODUCT_SALES AS INV_S,
		#new_dsn#.DEPARTMENT D
	WHERE
		INV_S.DEPARTMENT_ID=D.DEPARTMENT_ID
	GROUP BY 
		D.BRANCH_ID,	
		INVOICE_DATE

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [DAILY_PRODUCT_BRAND_SALES] AS
	SELECT
		PB.BRAND_ID,
		PB.BRAND_NAME,
		INVOICE_DATE,
		SUM(NET_SALE) NETTOTAL ,
		SUM(NET_SALE_OTHER_MONEY) OTHER_MONEY_NETTOTAL ,
		SUM(TOTAL_SALE) GROSSTOTAL ,
		SUM(TOTAL_SALE_OTHER_MONEY) OTHER_MONEY_GROSSTOTAL ,
		SUM(AMOUNT) AMOUNT,
		SUM(TOTAL_COST) TOTAL_COST ,
		SUM(TOTAL_COST_OTHER_MONEY) TOTAL_COST_OTHER_MONEY 
	FROM	
		DAILY_PRODUCT_SALES AS INV_S,
		#new_dsn3#.STOCKS S,
		#new_dsn3#.PRODUCT_BRANDS PB
	
	WHERE
		INV_S.STOCK_ID=S.STOCK_ID
		AND S.BRAND_ID=PB.BRAND_ID
	GROUP BY 
		PB.BRAND_ID,
		PB.BRAND_NAME,
		INVOICE_DATE

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [DAILY_PRODUCT_CAT_SALES] AS
	SELECT
		PC.PRODUCT_CAT,
		PC.PRODUCT_CATID,
		INVOICE_DATE,
		SUM(NET_SALE) NETTOTAL ,
		SUM(NET_SALE_OTHER_MONEY) OTHER_MONEY_NETTOTAL ,
		SUM(TOTAL_SALE) GROSSTOTAL ,
		SUM(TOTAL_SALE_OTHER_MONEY) OTHER_MONEY_GROSSTOTAL ,
		SUM(AMOUNT) AMOUNT,
		SUM(TOTAL_COST) TOTAL_COST ,
		SUM(TOTAL_COST_OTHER_MONEY) TOTAL_COST_OTHER_MONEY 
	FROM	
		DAILY_PRODUCT_SALES AS INV_S,
		#new_dsn3#.STOCKS S,
		#new_dsn3#.PRODUCT_CAT PC
	WHERE
		INV_S.STOCK_ID=S.STOCK_ID
		AND S.PRODUCT_CATID=PC.PRODUCT_CATID
	GROUP BY 
		PC.PRODUCT_CAT,
		PC.PRODUCT_CATID,
		INVOICE_DATE


</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [DAILY_PRODUCT_COMPANY_SALES] AS
	SELECT
		C.COMPANY_ID,
		C.NICKNAME,
		INVOICE_DATE,
		SUM(NET_SALE) NETTOTAL ,
		SUM(NET_SALE_OTHER_MONEY) OTHER_MONEY_NETTOTAL ,
		SUM(TOTAL_SALE) GROSSTOTAL ,
		SUM(TOTAL_SALE_OTHER_MONEY) OTHER_MONEY_GROSSTOTAL ,
		SUM(AMOUNT) AMOUNT,
		SUM(TOTAL_COST) TOTAL_COST ,
		SUM(TOTAL_COST_OTHER_MONEY) TOTAL_COST_OTHER_MONEY
	FROM	
		DAILY_PRODUCT_SALES AS INV_S,
		#new_dsn3#.STOCKS S,
		#new_dsn#.COMPANY C
	WHERE
		INV_S.STOCK_ID=S.STOCK_ID
		AND S.COMPANY_ID=C.COMPANY_ID
	GROUP BY 
		C.COMPANY_ID,
		C.NICKNAME,
		INVOICE_DATE

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [DAILY_PRODUCT_MANAGER_SALES] AS
	SELECT
		EP.EMPLOYEE_ID,
		EP.POSITION_CODE,
		EP.EMPLOYEE_NAME,
		EP.EMPLOYEE_SURNAME,
		INVOICE_DATE,
		SUM(NET_SALE) NETTOTAL ,
		SUM(NET_SALE_OTHER_MONEY) OTHER_MONEY_NETTOTAL ,
		SUM(TOTAL_SALE) GROSSTOTAL ,
		SUM(TOTAL_SALE_OTHER_MONEY) OTHER_MONEY_GROSSTOTAL ,
		SUM(AMOUNT) AMOUNT,
		SUM(TOTAL_COST) TOTAL_COST ,
		SUM(TOTAL_COST_OTHER_MONEY) TOTAL_COST_OTHER_MONEY 
	FROM	
		DAILY_PRODUCT_SALES AS INV_S,
		#new_dsn3#.STOCKS S,
		#new_dsn#.EMPLOYEE_POSITIONS EP
	WHERE
		INV_S.STOCK_ID=S.STOCK_ID
		AND S.PRODUCT_MANAGER=EP.POSITION_CODE
	GROUP BY 
		EP.EMPLOYEE_ID,
		EP.POSITION_CODE,
		EP.EMPLOYEE_NAME,
		EP.EMPLOYEE_SURNAME,
		INVOICE_DATE

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [DAILY_WORKGROUP_PAR_SALES] AS
	SELECT
		WP.POSITION_CODE,
		INV_S.COMPANY_ID,
		INVOICE_DATE,
		SUM(NET_SALE) NETTOTAL ,
		SUM(NET_SALE_OTHER_MONEY) OTHER_MONEY_NETTOTAL ,
		SUM(TOTAL_SALE) GROSSTOTAL ,
		SUM(TOTAL_SALE_OTHER_MONEY) OTHER_MONEY_GROSSTOTAL ,
		SUM(AMOUNT) AMOUNT,
		SUM(TOTAL_COST) TOTAL_COST ,
		SUM(TOTAL_COST_OTHER_MONEY) TOTAL_COST_OTHER_MONEY
	FROM	
		DAILY_PRODUCT_SALES AS INV_S,
		#new_dsn#.WORKGROUP_EMP_PAR WP
	WHERE
		INV_S.COMPANY_ID=WP.COMPANY_ID AND	
		WP.IS_MASTER = 1 AND
		WP.OUR_COMPANY_ID = #OUR_COMPANY_ID#
	GROUP BY
		WP.POSITION_CODE,
		INV_S.COMPANY_ID,
		INVOICE_DATE

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [ACCOUNT_ACCOUNT_REMAINDER_MONEY] AS
			SELECT
				0 AS ALACAK,
				SUM(ACCOUNT_CARD_ROWS.AMOUNT) AS BORC,	
				0 AS ALACAK2,
				SUM(ISNULL(ACCOUNT_CARD_ROWS.AMOUNT_2,0)) AS BORC2,	
				0 AS ALACAK3,
				SUM(ISNULL(ACCOUNT_CARD_ROWS.OTHER_AMOUNT,0)) AS BORC3,
				ACCOUNT_CARD_ROWS.OTHER_CURRENCY AS OTHER_MONEY,
				ACCOUNT_CARD_ROWS.ACCOUNT_ID,
				ACCOUNT_CARD.ACTION_DATE,
				ACCOUNT_CARD.CARD_TYPE,
				ACCOUNT_CARD.CARD_CAT_ID
			FROM
				ACCOUNT_CARD_ROWS,ACCOUNT_CARD
			WHERE
				BA = 0 AND ACCOUNT_CARD.CARD_ID=ACCOUNT_CARD_ROWS.CARD_ID
			GROUP BY
				ACCOUNT_CARD_ROWS.ACCOUNT_ID,
				ACCOUNT_CARD.ACTION_DATE,
				ACCOUNT_CARD.CARD_TYPE,
				ACCOUNT_CARD.CARD_CAT_ID,
				ACCOUNT_CARD_ROWS.OTHER_CURRENCY
		UNION
			SELECT
				SUM(ACCOUNT_CARD_ROWS.AMOUNT)AS ALACAK,
				0 AS BORC,	
				SUM(ISNULL(ACCOUNT_CARD_ROWS.AMOUNT_2,0))AS ALACAK2,
				0 AS BORC2,	
				SUM(ISNULL(ACCOUNT_CARD_ROWS.OTHER_AMOUNT,0))AS ALACAK3,
				0 AS BORC3,
				ACCOUNT_CARD_ROWS.OTHER_CURRENCY AS OTHER_MONEY,
				ACCOUNT_CARD_ROWS.ACCOUNT_ID,
				ACCOUNT_CARD.ACTION_DATE,
				ACCOUNT_CARD.CARD_TYPE,
				ACCOUNT_CARD.CARD_CAT_ID
			FROM
				ACCOUNT_CARD_ROWS,
				ACCOUNT_CARD
			WHERE
				BA = 1 AND ACCOUNT_CARD.CARD_ID=ACCOUNT_CARD_ROWS.CARD_ID
			GROUP BY
				ACCOUNT_CARD_ROWS.ACCOUNT_ID,
				ACCOUNT_CARD.ACTION_DATE,
				ACCOUNT_CARD.CARD_TYPE,
				ACCOUNT_CARD.CARD_CAT_ID,
				ACCOUNT_CARD_ROWS.OTHER_CURRENCY

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [ACTIVITY_SUMMARY_DAILY] AS
		SELECT
			ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
			SUM(GET_PURCHASES) GET_PURCHASES,
			SUM(GET_PURCHASES2) GET_PURCHASES2,
			SUM(GET_PURCHASES_PAPERS) GET_PURCHASES_PAPERS,
			SUM(GET_PURCHASE_DIFF) GET_PURCHASE_DIFF,
			SUM(GET_PURCHASE_DIFF2) GET_PURCHASE_DIFF2,
			SUM(GET_PURCHASE_DIFF_PAPERS) GET_PURCHASE_DIFF_PAPERS,
			SUM(GET_PURCHASE_RETURN) GET_PURCHASE_RETURN,
			SUM(GET_PURCHASE_RETURN2) GET_PURCHASE_RETURN2,
			SUM(GET_PURCHASE_RETURN_PAPERS) GET_PURCHASE_RETURN_PAPERS,
			SUM(GET_EXPENSE) GET_EXPENSE,
			SUM(GET_EXPENSE2) GET_EXPENSE2,
			SUM(GET_EXPENSE_PAPERS) GET_EXPENSE_PAPERS,
			SUM(GET_SALES) GET_SALES,
			SUM(GET_SALES2) GET_SALES2,
			SUM(GET_SALES_PAPERS) GET_SALES_PAPERS,
			SUM(GET_SALES_CANCELED) GET_SALES_CANCELED,
			SUM(GET_SALES2_CANCELED) GET_SALES2_CANCELED,
			SUM(GET_SALES_PAPERS_CANCELED) GET_SALES_PAPERS_CANCELED,
			SUM(GET_SALES_DIFF) GET_SALES_DIFF,
			SUM(GET_SALES_DIFF2) GET_SALES_DIFF2,
			SUM(GET_SALES_DIFF_PAPERS) GET_SALES_DIFF_PAPERS,
			SUM(GET_SALES_RETURN) GET_SALES_RETURN,
			SUM(GET_SALES_RETURN2) GET_SALES_RETURN2,
			SUM(GET_SALES_RETURN_PAPERS) GET_SALES_RETURN_PAPERS,
			SUM(GET_INCOME) GET_INCOME,
			SUM(GET_INCOME2) GET_INCOME2,
			SUM(GET_INCOME_PAPERS) GET_INCOME_PAPERS,
			SUM(GET_CASH) GET_CASH,
			SUM(GET_CASH2) GET_CASH2,
			SUM(GET_CASH_PAPERS) GET_CASH_PAPERS,
			SUM(GET_CHEQUE) GET_CHEQUE,
			SUM(GET_CHEQUE2)GET_CHEQUE2,
			SUM(GET_CHEQUE_PAPERS) GET_CHEQUE_PAPERS,
			SUM(GET_CHEQUE_RETURN) GET_CHEQUE_RETURN,
			SUM(GET_CHEQUE2_RETURN)GET_CHEQUE2_RETURN,
			SUM(GET_CHEQUE_RETURN_PAPERS) GET_CHEQUE_RETURN_PAPERS,
			SUM(GET_VOUCHER) GET_VOUCHER,		
			SUM(GET_VOUCHER2) GET_VOUCHER2,
			SUM(GET_VOUCHER_PAPERS) GET_VOUCHER_PAPERS,
			SUM(GET_VOUCHER_RETURN) GET_VOUCHER_RETURN,
			SUM(GET_VOUCHER2_RETURN) GET_VOUCHER2_RETURN,
			SUM(GET_VOUCHER_RETURN_PAPERS) GET_VOUCHER_RETURN_PAPERS,
			SUM(GET_REVENUE) GET_REVENUE,
			SUM(GET_REVENUE2)GET_REVENUE2,
			SUM(GET_REVENUE_PAPERS) GET_REVENUE_PAPERS,
			SUM(GET_CREDIT_REVENUE) GET_CREDIT_REVENUE,
			SUM(GET_CREDIT_REVENUE2)GET_CREDIT_REVENUE2,
			SUM(GET_CREDIT_REVENUE_PAPERS) GET_CREDIT_REVENUE_PAPERS,
			SUM(GET_PAYM) GET_PAYM,
			SUM(GET_PAYM2)GET_PAYM2,
			SUM(GET_PAYM_PAPERS) GET_PAYM_PAPERS,
			SUM(GET_CHEQUE_P) GET_CHEQUE_P,
			SUM(GET_CHEQUE_P2) GET_CHEQUE_P2,
			SUM(GET_CHEQUE_P_PAPERS) GET_CHEQUE_P_PAPERS,
			SUM(GET_CHEQUE_P_RETURN) GET_CHEQUE_P_RETURN,
			SUM(GET_CHEQUE_P2_RETURN) GET_CHEQUE_P2_RETURN,
			SUM(GET_CHEQUE_P_RETURN_PAPERS) GET_CHEQUE_P_RETURN_PAPERS,
			SUM(GET_VOUCHER_P) GET_VOUCHER_P,	
			SUM(GET_VOUCHER_P2) GET_VOUCHER_P2,
			SUM(GET_VOUCHER_P_PAPERS) GET_VOUCHER_P_PAPERS,	
			SUM(GET_VOUCHER_P_RETURN) GET_VOUCHER_P_RETURN,
			SUM(GET_VOUCHER_P2_RETURN) GET_VOUCHER_P2_RETURN,
			SUM(GET_VOUCHER_P_RETURN_PAPERS) GET_VOUCHER_P_RETURN_PAPERS,
			SUM(GET_PAYMENTS) GET_PAYMENTS,
			SUM(GET_PAYMENTS2) GET_PAYMENTS2,
			SUM(GET_PAYMENTS_PAPERS) GET_PAYMENTS_PAPERS,
			SUM(GET_CREDIT_PAYMENTS) GET_CREDIT_PAYMENTS,
			SUM(GET_CREDIT_PAYMENTS2) GET_CREDIT_PAYMENTS2,
			SUM(GET_CREDIT_PAYMENTS_PAPERS) GET_CREDIT_PAYMENTS_PAPERS
		FROM (
	
				SELECT
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					SUM(ACTION_VALUE) GET_PURCHASES,
					SUM(ACTION_VALUE_2) GET_PURCHASES2,
					COUNT(ACTION_TYPE_ID) GET_PURCHASES_PAPERS,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_PURCHASE_DIFF_PAPERS,
					0 GET_PURCHASE_RETURN,
					0 GET_PURCHASE_RETURN2,
					0 GET_PURCHASE_RETURN_PAPERS,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_EXPENSE_PAPERS,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_PAPERS,
					0 GET_SALES_CANCELED,
					0 GET_SALES2_CANCELED,
					0 GET_SALES_PAPERS_CANCELED,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_DIFF_PAPERS,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_SALES_RETURN_PAPERS,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_INCOME_PAPERS,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CASH_PAPERS,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_PAPERS,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_CHEQUE_RETURN_PAPERS,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,
					0 GET_VOUCHER_PAPERS,
					0 GET_VOUCHER_RETURN,			
					0 GET_VOUCHER2_RETURN,
					0 GET_VOUCHER_RETURN_PAPERS,	
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_REVENUE_PAPERS,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_CREDIT_REVENUE_PAPERS,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_PAYM_PAPERS,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_PAPERS,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_CHEQUE_P_RETURN_PAPERS,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_PAPERS,
					0 GET_VOUCHER_P_RETURN,	
					0 GET_VOUCHER_P2_RETURN,
					0 GET_VOUCHER_P_RETURN_PAPERS,	
					0 GET_PAYMENTS,
					0 GET_PAYMENTS2,
					0 GET_PAYMENTS_PAPERS,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS2,
					0 GET_CREDIT_PAYMENTS_PAPERS
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (59,60,601,64,65,68,690,691,591,592)
				GROUP BY
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
				SELECT
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASES_PAPERS,
					SUM(ACTION_VALUE) GET_PURCHASE_DIFF,
					SUM(ACTION_VALUE_2) GET_PURCHASE_DIFF2,
					COUNT(ACTION_TYPE_ID) GET_PURCHASES_DIFF_PAPERS,
					0 GET_PURCHASE_RETURN,
					0 GET_PURCHASE_RETURN2,
					0 GET_PURCHASE_RETURN_PAPERS,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_EXPENSE_PAPERS,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_PAPERS,
					0 GET_SALES_CANCELED,
					0 GET_SALES2_CANCELED,
					0 GET_SALES_PAPERS_CANCELED,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_DIFF_PAPERS,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_SALES_RETURN_PAPERS,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_INCOME_PAPERS,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CASH_PAPERS,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_PAPERS,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_CHEQUE_RETURN_PAPERS,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,
					0 GET_VOUCHER_PAPERS,
					0 GET_VOUCHER_RETURN,			
					0 GET_VOUCHER2_RETURN,
					0 GET_VOUCHER_RETURN_PAPERS,	
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_REVENUE_PAPERS,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_CREDIT_REVENUE_PAPERS,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_PAYM_PAPERS,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_PAPERS,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_CHEQUE_P_RETURN_PAPERS,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_PAPERS,
					0 GET_VOUCHER_P_RETURN,	
					0 GET_VOUCHER_P2_RETURN,
					0 GET_VOUCHER_P_RETURN_PAPERS,	
					0 GET_PAYMENTS,
					0 GET_PAYMENTS2,
					0 GET_PAYMENTS_PAPERS,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS2,
					0 GET_CREDIT_PAYMENTS_PAPERS
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (51,63)
				GROUP BY
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
				SELECT
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASES_PAPERS,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_PURCHASE_DIFF_PAPERS,
					SUM(ACTION_VALUE) GET_PURCHASE_RETURN,
					SUM(ACTION_VALUE_2) GET_PURCHASE_RETURN2,
					COUNT(ACTION_TYPE_ID) GET_PURCHASE_RETURN_PAPERS,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_EXPENSE_PAPERS,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_PAPERS,
					0 GET_SALES_CANCELED,
					0 GET_SALES2_CANCELED,
					0 GET_SALES_PAPERS_CANCELED,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_DIFF_PAPERS,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_SALES_RETURN_PAPERS,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_INCOME_PAPERS,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CASH_PAPERS,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_PAPERS,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_CHEQUE_RETURN_PAPERS,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,
					0 GET_VOUCHER_PAPERS,
					0 GET_VOUCHER_RETURN,			
					0 GET_VOUCHER2_RETURN,
					0 GET_VOUCHER_RETURN_PAPERS,	
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_REVENUE_PAPERS,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_CREDIT_REVENUE_PAPERS,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_PAYM_PAPERS,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_PAPERS,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_CHEQUE_P_RETURN_PAPERS,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_PAPERS,
					0 GET_VOUCHER_P_RETURN,	
					0 GET_VOUCHER_P2_RETURN,
					0 GET_VOUCHER_P_RETURN_PAPERS,	
					0 GET_PAYMENTS,
					0 GET_PAYMENTS2,
					0 GET_PAYMENTS_PAPERS,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS2,
					0 GET_CREDIT_PAYMENTS_PAPERS
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (62)
				GROUP BY
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
				SELECT
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASES_PAPERS,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_PURCHASE_DIFF_PAPERS,
					0 GET_PURCHASE_RETURN,
					0 GET_PURCHASE_RETURN2,
					0 GET_PURCHASE_RETURN_PAPERS,
					SUM(ACTION_VALUE) GET_EXPENSE,
					SUM(ACTION_VALUE_2) GET_EXPENSE2,
					COUNT(ACTION_TYPE_ID) GET_EXPENSE_PAPERS,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_PAPERS,
					0 GET_SALES_CANCELED,
					0 GET_SALES2_CANCELED,
					0 GET_SALES_PAPERS_CANCELED,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_DIFF_PAPERS,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_SALES_RETURN_PAPERS,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_INCOME_PAPERS,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CASH_PAPERS,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_PAPERS,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_CHEQUE_RETURN_PAPERS,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,
					0 GET_VOUCHER_PAPERS,
					0 GET_VOUCHER_RETURN,			
					0 GET_VOUCHER2_RETURN,
					0 GET_VOUCHER_RETURN_PAPERS,	
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_REVENUE_PAPERS,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_CREDIT_REVENUE_PAPERS,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_PAYM_PAPERS,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_PAPERS,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_CHEQUE_P_RETURN_PAPERS,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_PAPERS,
					0 GET_VOUCHER_P_RETURN,	
					0 GET_VOUCHER_P2_RETURN,
					0 GET_VOUCHER_P_RETURN_PAPERS,	
					0 GET_PAYMENTS,
					0 GET_PAYMENTS2,
					0 GET_PAYMENTS_PAPERS,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS2,
					0 GET_CREDIT_PAYMENTS_PAPERS
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (42,120,131)
				GROUP BY
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
				SELECT
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASES_PAPERS,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_PURCHASE_DIFF_PAPERS,
					0 GET_PURCHASE_RETURN,
					0 GET_PURCHASE_RETURN2,
					0 GET_PURCHASE_RETURN_PAPERS,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_EXPENSE_PAPERS,
					SUM(ACTION_VALUE) GET_SALES,
					SUM(ACTION_VALUE_2) GET_SALES2,
					COUNT(ACTION_TYPE_ID) GET_SALES_PAPERS,
					0 GET_SALES_CANCELED,
					0 GET_SALES2_CANCELED,
					0 GET_SALES_PAPERS_CANCELED,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_DIFF_PAPERS,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_SALES_RETURN_PAPERS,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_INCOME_PAPERS,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CASH_PAPERS,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_PAPERS,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_CHEQUE_RETURN_PAPERS,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,
					0 GET_VOUCHER_PAPERS,
					0 GET_VOUCHER_RETURN,			
					0 GET_VOUCHER2_RETURN,
					0 GET_VOUCHER_RETURN_PAPERS,	
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_REVENUE_PAPERS,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_CREDIT_REVENUE_PAPERS,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_PAYM_PAPERS,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_PAPERS,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_CHEQUE_P_RETURN_PAPERS,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_PAPERS,
					0 GET_VOUCHER_P_RETURN,	
					0 GET_VOUCHER_P2_RETURN,
					0 GET_VOUCHER_P_RETURN_PAPERS,	
					0 GET_PAYMENTS,
					0 GET_PAYMENTS2,
					0 GET_PAYMENTS_PAPERS,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS2,
					0 GET_CREDIT_PAYMENTS_PAPERS
				FROM
					CARI_ROWS
				WHERE
					IS_CANCEL = 0 AND
					ACTION_TYPE_ID IN (48,52,53,56,57,58,66,67,531,532,561)
				GROUP BY
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
			SELECT
				ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
				0 GET_PURCHASES,
				0 GET_PURCHASES2,
				0 GET_PURCHASES_PAPERS,
				0 GET_PURCHASE_DIFF,
				0 GET_PURCHASE_DIFF2,
				0 GET_PURCHASE_DIFF_PAPERS,
				0 GET_PURCHASE_RETURN,
				0 GET_PURCHASE_RETURN2,
				0 GET_PURCHASE_RETURN_PAPERS,
				0 GET_EXPENSE,
				0 GET_EXPENSE2,
				0 GET_EXPENSE_PAPERS,
				0 GET_SALES,
				0 GET_SALES2,
				0 GET_SALES_PAPERS,
				SUM(ACTION_VALUE) GET_SALES_CANCELED,
				SUM(ACTION_VALUE_2) GET_SALES2_CANCELED,
				COUNT(ACTION_TYPE_ID) GET_SALES_PAPERS_CANCELED,
				0 GET_SALES_DIFF,
				0 GET_SALES_DIFF2,
				0 GET_SALES_DIFF_PAPERS,
				0 GET_SALES_RETURN,
				0 GET_SALES_RETURN2,
				0 GET_SALES_RETURN_PAPERS,
				0 GET_INCOME,
				0 GET_INCOME2,
				0 GET_INCOME_PAPERS,
				0 GET_CASH,
				0 GET_CASH2,
				0 GET_CASH_PAPERS,
				0 GET_CHEQUE,
				0 GET_CHEQUE2,
				0 GET_CHEQUE_PAPERS,
				0 GET_CHEQUE_RETURN,
				0 GET_CHEQUE2_RETURN,
				0 GET_CHEQUE_RETURN_PAPERS,
				0 GET_VOUCHER,
				0 GET_VOUCHER2,
				0 GET_VOUCHER_PAPERS,
				0 GET_VOUCHER_RETURN,			
				0 GET_VOUCHER2_RETURN,
				0 GET_VOUCHER_RETURN_PAPERS,	
				0 GET_REVENUE,
				0 GET_REVENUE2,
				0 GET_REVENUE_PAPERS,
				0 GET_CREDIT_REVENUE,
				0 GET_CREDIT_REVENUE2,
				0 GET_CREDIT_REVENUE_PAPERS,
				0 GET_PAYM,
				0 GET_PAYM2,
				0 GET_PAYM_PAPERS,
				0 GET_CHEQUE_P,
				0 GET_CHEQUE_P2,
				0 GET_CHEQUE_P_PAPERS,
				0 GET_CHEQUE_P_RETURN,
				0 GET_CHEQUE_P2_RETURN,
				0 GET_CHEQUE_P_RETURN_PAPERS,
				0 GET_VOUCHER_P,
				0 GET_VOUCHER_P2,
				0 GET_VOUCHER_P_PAPERS,
				0 GET_VOUCHER_P_RETURN,	
				0 GET_VOUCHER_P2_RETURN,
				0 GET_VOUCHER_P_RETURN_PAPERS,	
				0 GET_PAYMENTS,
				0 GET_PAYMENTS2,
				0 GET_PAYMENTS_PAPERS,
				0 GET_CREDIT_PAYMENTS,
				0 GET_CREDIT_PAYMENTS2,
				0 GET_CREDIT_PAYMENTS_PAPERS
			FROM
				CARI_ROWS
			WHERE
				IS_CANCEL = 1 AND
				ACTION_TYPE_ID IN (48,52,53,56,57,58,66,67,531,532,561)					
			GROUP BY
				ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
				SELECT
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASES_PAPERS,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_PURCHASE_DIFF_PAPERS,
					0 GET_PURCHASE_RETURN,
					0 GET_PURCHASE_RETURN2,
					0 GET_PURCHASE_RETURN_PAPERS,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_EXPENSE_PAPERS,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_PAPERS,
					0 GET_SALES_CANCELED,
					0 GET_SALES2_CANCELED,
					0 GET_SALES_PAPERS_CANCELED,
					SUM(ACTION_VALUE) GET_SALES_DIFF,
					SUM(ACTION_VALUE_2) GET_SALES_DIFF2,
					COUNT(ACTION_TYPE_ID) GET_SALES_DIFF_PAPERS,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_SALES_RETURN_PAPERS,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_INCOME_PAPERS,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CASH_PAPERS,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_PAPERS,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_CHEQUE_RETURN_PAPERS,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,
					0 GET_VOUCHER_PAPERS,
					0 GET_VOUCHER_RETURN,			
					0 GET_VOUCHER2_RETURN,
					0 GET_VOUCHER_RETURN_PAPERS,	
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_REVENUE_PAPERS,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_CREDIT_REVENUE_PAPERS,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_PAYM_PAPERS,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_PAPERS,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_CHEQUE_P_RETURN_PAPERS,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_PAPERS,
					0 GET_VOUCHER_P_RETURN,	
					0 GET_VOUCHER_P2_RETURN,
					0 GET_VOUCHER_P_RETURN_PAPERS,	
					0 GET_PAYMENTS,
					0 GET_PAYMENTS2,
					0 GET_PAYMENTS_PAPERS,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS2,
					0 GET_CREDIT_PAYMENTS_PAPERS
				FROM
	
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (50,58)
				GROUP BY
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
				SELECT
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASES_PAPERS,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_PURCHASE_DIFF_PAPERS,
					0 GET_PURCHASE_RETURN,
					0 GET_PURCHASE_RETURN2,
					0 GET_PURCHASE_RETURN_PAPERS,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_EXPENSE_PAPERS,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_PAPERS,
					0 GET_SALES_CANCELED,
					0 GET_SALES2_CANCELED,
					0 GET_SALES_PAPERS_CANCELED,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_DIFF_PAPERS,
					SUM(ACTION_VALUE) GET_SALES_RETURN,
					SUM(ACTION_VALUE_2) GET_SALES_RETURN2,
					COUNT(ACTION_TYPE_ID) GET_SALES_RETURN_PAPERS,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_INCOME_PAPERS,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CASH_PAPERS,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_PAPERS,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_CHEQUE_RETURN_PAPERS,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,
					0 GET_VOUCHER_PAPERS,
					0 GET_VOUCHER_RETURN,			
					0 GET_VOUCHER2_RETURN,
					0 GET_VOUCHER_RETURN_PAPERS,	
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_REVENUE_PAPERS,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_CREDIT_REVENUE_PAPERS,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_PAYM_PAPERS,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_PAPERS,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_CHEQUE_P_RETURN_PAPERS,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_PAPERS,
					0 GET_VOUCHER_P_RETURN,	
					0 GET_VOUCHER_P2_RETURN,
					0 GET_VOUCHER_P_RETURN_PAPERS,	
					0 GET_PAYMENTS,
					0 GET_PAYMENTS2,
					0 GET_PAYMENTS_PAPERS,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS2,
					0 GET_CREDIT_PAYMENTS_PAPERS
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (54,55)
				GROUP BY
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
				SELECT
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASES_PAPERS,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,

					0 GET_PURCHASE_DIFF_PAPERS,
					0 GET_PURCHASE_RETURN,
					0 GET_PURCHASE_RETURN2,
					0 GET_PURCHASE_RETURN_PAPERS,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_EXPENSE_PAPERS,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_PAPERS,
					0 GET_SALES_CANCELED,
					0 GET_SALES2_CANCELED,
					0 GET_SALES_PAPERS_CANCELED,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_DIFF_PAPERS,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_SALES_RETURN_PAPERS,
					SUM(ACTION_VALUE) GET_INCOME,
					SUM(ACTION_VALUE_2) GET_INCOME2,
					COUNT(ACTION_TYPE_ID) GET_INCOME_PAPERS,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CASH_PAPERS,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_PAPERS,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_CHEQUE_RETURN_PAPERS,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,
					0 GET_VOUCHER_PAPERS,
					0 GET_VOUCHER_RETURN,			
					0 GET_VOUCHER2_RETURN,
					0 GET_VOUCHER_RETURN_PAPERS,	
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_REVENUE_PAPERS,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_CREDIT_REVENUE_PAPERS,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_PAYM_PAPERS,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_PAPERS,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_CHEQUE_P_RETURN_PAPERS,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_PAPERS,
					0 GET_VOUCHER_P_RETURN,	
					0 GET_VOUCHER_P2_RETURN,
					0 GET_VOUCHER_P_RETURN_PAPERS,	
					0 GET_PAYMENTS,
					0 GET_PAYMENTS2,
					0 GET_PAYMENTS_PAPERS,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS2,
					0 GET_CREDIT_PAYMENTS_PAPERS
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (41,121)
				GROUP BY
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
				SELECT
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASES_PAPERS,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_PURCHASE_DIFF_PAPERS,
					0 GET_PURCHASE_RETURN,
					0 GET_PURCHASE_RETURN2,
					0 GET_PURCHASE_RETURN_PAPERS,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_EXPENSE_PAPERS,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_PAPERS,
					0 GET_SALES_CANCELED,
					0 GET_SALES2_CANCELED,
					0 GET_SALES_PAPERS_CANCELED,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_DIFF_PAPERS,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_SALES_RETURN_PAPERS,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_INCOME_PAPERS,
					SUM(ACTION_VALUE) GET_CASH,
					SUM(ACTION_VALUE_2) GET_CASH2,
					COUNT(ACTION_TYPE_ID) GET_CASH_PAPERS,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_PAPERS,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_CHEQUE_RETURN_PAPERS,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,
					0 GET_VOUCHER_PAPERS,
					0 GET_VOUCHER_RETURN,			
					0 GET_VOUCHER2_RETURN,
					0 GET_VOUCHER_RETURN_PAPERS,	
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_REVENUE_PAPERS,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_CREDIT_REVENUE_PAPERS,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_PAYM_PAPERS,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_PAPERS,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_CHEQUE_P_RETURN_PAPERS,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_PAPERS,
					0 GET_VOUCHER_P_RETURN,	
					0 GET_VOUCHER_P2_RETURN,
					0 GET_VOUCHER_P_RETURN_PAPERS,	
					0 GET_PAYMENTS,
					0 GET_PAYMENTS2,
					0 GET_PAYMENTS_PAPERS,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS2,
					0 GET_CREDIT_PAYMENTS_PAPERS	
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (31,35,1040,1050)
				GROUP BY
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
				SELECT
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASES_PAPERS,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_PURCHASE_DIFF_PAPERS,
					0 GET_PURCHASE_RETURN,
					0 GET_PURCHASE_RETURN2,
					0 GET_PURCHASE_RETURN_PAPERS,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_EXPENSE_PAPERS,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_PAPERS,
					0 GET_SALES_CANCELED,
					0 GET_SALES2_CANCELED,
					0 GET_SALES_PAPERS_CANCELED,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_DIFF_PAPERS,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_SALES_RETURN_PAPERS,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_INCOME_PAPERS,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CASH_PAPERS,
					SUM(ACTION_VALUE) GET_CHEQUE,
					SUM(ACTION_VALUE_2) GET_CHEQUE2,
					COUNT(ACTION_TYPE_ID) GET_CHEQUE_PAPERS,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_CHEQUE_RETURN_PAPERS,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,
					0 GET_VOUCHER_PAPERS,
					0 GET_VOUCHER_RETURN,			
					0 GET_VOUCHER2_RETURN,
					0 GET_VOUCHER_RETURN_PAPERS,	
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_REVENUE_PAPERS,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_CREDIT_REVENUE_PAPERS,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_PAYM_PAPERS,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_PAPERS,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_CHEQUE_P_RETURN_PAPERS,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_PAPERS,
					0 GET_VOUCHER_P_RETURN,	
					0 GET_VOUCHER_P2_RETURN,
					0 GET_VOUCHER_P_RETURN_PAPERS,	
					0 GET_PAYMENTS,
					0 GET_PAYMENTS2,
					0 GET_PAYMENTS_PAPERS,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS2,
					0 GET_CREDIT_PAYMENTS_PAPERS
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (90)
				GROUP BY
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
				SELECT
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASES_PAPERS,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_PURCHASE_DIFF_PAPERS,
					0 GET_PURCHASE_RETURN,
					0 GET_PURCHASE_RETURN2,
					0 GET_PURCHASE_RETURN_PAPERS,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_EXPENSE_PAPERS,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_PAPERS,
					0 GET_SALES_CANCELED,
					0 GET_SALES2_CANCELED,
					0 GET_SALES_PAPERS_CANCELED,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_DIFF_PAPERS,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_SALES_RETURN_PAPERS,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_INCOME_PAPERS,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CASH_PAPERS,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_PAPERS,
					SUM(ACTION_VALUE) GET_CHEQUE_RETURN,
					SUM(ACTION_VALUE_2) GET_CHEQUE2_RETURN,
					COUNT(ACTION_TYPE_ID) GET_CHEQUE_RETURN_PAPERS,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,
					0 GET_VOUCHER_PAPERS,
					0 GET_VOUCHER_RETURN,			
					0 GET_VOUCHER2_RETURN,
					0 GET_VOUCHER_RETURN_PAPERS,	
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_REVENUE_PAPERS,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_CREDIT_REVENUE_PAPERS,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_PAYM_PAPERS,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_PAPERS,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_CHEQUE_P_RETURN_PAPERS,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_PAPERS,
					0 GET_VOUCHER_P_RETURN,	
					0 GET_VOUCHER_P2_RETURN,
					0 GET_VOUCHER_P_RETURN_PAPERS,	
					0 GET_PAYMENTS,
					0 GET_PAYMENTS2,
					0 GET_PAYMENTS_PAPERS,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS2,
					0 GET_CREDIT_PAYMENTS_PAPERS	
				FROM
					CARI_ROWS
				WHERE

					ACTION_TYPE_ID IN (94)
				GROUP BY
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
	
				SELECT
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASES_PAPERS,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_PURCHASE_DIFF_PAPERS,
					0 GET_PURCHASE_RETURN,
					0 GET_PURCHASE_RETURN2,
					0 GET_PURCHASE_RETURN_PAPERS,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_EXPENSE_PAPERS,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_PAPERS,
					0 GET_SALES_CANCELED,
					0 GET_SALES2_CANCELED,
					0 GET_SALES_PAPERS_CANCELED,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_DIFF_PAPERS,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_SALES_RETURN_PAPERS,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_INCOME_PAPERS,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CASH_PAPERS,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_PAPERS,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_CHEQUE_RETURN_PAPERS,
					SUM(ACTION_VALUE) GET_VOUCHER,
					SUM(ACTION_VALUE_2) GET_VOUCHER2,	
					COUNT(ACTION_TYPE_ID) GET_VOUCHER_PAPERS,
					0 GET_VOUCHER_RETURN,			
					0 GET_VOUCHER2_RETURN,
					0 GET_VOUCHER_RETURN_PAPERS,	
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_REVENUE_PAPERS,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_CREDIT_REVENUE_PAPERS,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_PAYM_PAPERS,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_PAPERS,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_CHEQUE_P_RETURN_PAPERS,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_PAPERS,
					0 GET_VOUCHER_P_RETURN,	
					0 GET_VOUCHER_P2_RETURN,
					0 GET_VOUCHER_P_RETURN_PAPERS,	
					0 GET_PAYMENTS,
					0 GET_PAYMENTS2,
					0 GET_PAYMENTS_PAPERS,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS2,
					0 GET_CREDIT_PAYMENTS_PAPERS
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (97)
				GROUP BY
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
				SELECT
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASES_PAPERS,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_PURCHASE_DIFF_PAPERS,
					0 GET_PURCHASE_RETURN,
					0 GET_PURCHASE_RETURN2,
					0 GET_PURCHASE_RETURN_PAPERS,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_EXPENSE_PAPERS,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_PAPERS,
					0 GET_SALES_CANCELED,
					0 GET_SALES2_CANCELED,
					0 GET_SALES_PAPERS_CANCELED,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_DIFF_PAPERS,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_SALES_RETURN_PAPERS,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_INCOME_PAPERS,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CASH_PAPERS,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_PAPERS,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_CHEQUE_RETURN_PAPERS,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,
					0 GET_VOUCHER_PAPERS,
					SUM(ACTION_VALUE) GET_VOUCHER_RETURN,	
					SUM(ACTION_VALUE_2) GET_VOUCHER2_RETURN,					
					COUNT(ACTION_TYPE_ID) GET_VOUCHER_RETURN_PAPERS,
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_REVENUE_PAPERS,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_CREDIT_REVENUE_PAPERS,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_PAYM_PAPERS,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_PAPERS,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_CHEQUE_P_RETURN_PAPERS,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_PAPERS,
					0 GET_VOUCHER_P_RETURN,	
					0 GET_VOUCHER_P2_RETURN,
					0 GET_VOUCHER_P_RETURN_PAPERS,	
					0 GET_PAYMENTS,
					0 GET_PAYMENTS2,
					0 GET_PAYMENTS_PAPERS,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS2,
					0 GET_CREDIT_PAYMENTS_PAPERS
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (101)
				GROUP BY
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL 
				SELECT
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASES_PAPERS,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_PURCHASE_DIFF_PAPERS,
					0 GET_PURCHASE_RETURN,
					0 GET_PURCHASE_RETURN2,
					0 GET_PURCHASE_RETURN_PAPERS,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_EXPENSE_PAPERS,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_PAPERS,
					0 GET_SALES_CANCELED,
					0 GET_SALES2_CANCELED,
					0 GET_SALES_PAPERS_CANCELED,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_DIFF_PAPERS,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_SALES_RETURN_PAPERS,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_INCOME_PAPERS,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CASH_PAPERS,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_PAPERS,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_CHEQUE_RETURN_PAPERS,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,
					0 GET_VOUCHER_PAPERS,
					0 GET_VOUCHER_RETURN,		
					0 GET_VOUCHER2_RETURN,
					0 GET_VOUCHER_RETURN_PAPERS,
					SUM(ACTION_VALUE) GET_REVENUE,
					SUM(ACTION_VALUE_2) GET_REVENUE2,
					COUNT(ACTION_TYPE_ID) GET_REVENUE_PAPERS,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_CREDIT_REVENUE_PAPERS,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_PAYM_PAPERS,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_PAPERS,

					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_CHEQUE_P_RETURN_PAPERS,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_PAPERS,
					0 GET_VOUCHER_P_RETURN,	
					0 GET_VOUCHER_P2_RETURN,
					0 GET_VOUCHER_P_RETURN_PAPERS,	
					0 GET_PAYMENTS,
					0 GET_PAYMENTS2,
					0 GET_PAYMENTS_PAPERS,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS2,
					0 GET_CREDIT_PAYMENTS_PAPERS
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (24,240,241,1043,1053)
				GROUP BY
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
				SELECT
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASES_PAPERS,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_PURCHASE_DIFF_PAPERS,
					0 GET_PURCHASE_RETURN,
					0 GET_PURCHASE_RETURN2,
					0 GET_PURCHASE_RETURN_PAPERS,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_EXPENSE_PAPERS,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_PAPERS,
					0 GET_SALES_CANCELED,
					0 GET_SALES2_CANCELED,
					0 GET_SALES_PAPERS_CANCELED,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_DIFF_PAPERS,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_SALES_RETURN_PAPERS,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_INCOME_PAPERS,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CASH_PAPERS,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_PAPERS,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_CHEQUE_RETURN_PAPERS,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,
					0 GET_VOUCHER_PAPERS,
					0 GET_VOUCHER_RETURN,		
					0 GET_VOUCHER2_RETURN,
					0 GET_VOUCHER_RETURN_PAPERS,
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_REVENUE_PAPERS,
					SUM(ACTION_VALUE) GET_CREDIT_REVENUE,
					SUM(ACTION_VALUE_2) GET_CREDIT_REVENUE2,
					COUNT(ACTION_TYPE_ID) GET_CREDIT_REVENUE_PAPERS,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_PAYM_PAPERS,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_PAPERS,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_CHEQUE_P_RETURN_PAPERS,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_PAPERS,
					0 GET_VOUCHER_P_RETURN,	
					0 GET_VOUCHER_P2_RETURN,
					0 GET_VOUCHER_P_RETURN_PAPERS,	
					0 GET_PAYMENTS,
					0 GET_PAYMENTS2,
					0 GET_PAYMENTS_PAPERS,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS2,
					0 GET_CREDIT_PAYMENTS_PAPERS
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (292)
	
				GROUP BY
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
				SELECT
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASES_PAPERS,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_PURCHASE_DIFF_PAPERS,
					0 GET_PURCHASE_RETURN,
					0 GET_PURCHASE_RETURN2,
					0 GET_PURCHASE_RETURN_PAPERS,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_EXPENSE_PAPERS,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_PAPERS,
					0 GET_SALES_CANCELED,
					0 GET_SALES2_CANCELED,
					0 GET_SALES_PAPERS_CANCELED,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_DIFF_PAPERS,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_SALES_RETURN_PAPERS,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_INCOME_PAPERS,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CASH_PAPERS,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_PAPERS,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_CHEQUE_RETURN_PAPERS,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,
					0 GET_VOUCHER_PAPERS,
					0 GET_VOUCHER_RETURN,		
					0 GET_VOUCHER2_RETURN,
					0 GET_VOUCHER_RETURN_PAPERS,
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_REVENUE_PAPERS,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_CREDIT_REVENUE_PAPERS,
					SUM(ACTION_VALUE) GET_PAYM,
					SUM(ACTION_VALUE_2) GET_PAYM2,
					COUNT(ACTION_TYPE_ID) GET_PAYM_PAPERS,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_PAPERS,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_CHEQUE_P_RETURN_PAPERS,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_PAPERS,
					0 GET_VOUCHER_P_RETURN,	
					0 GET_VOUCHER_P2_RETURN,
					0 GET_VOUCHER_P_RETURN_PAPERS,	
					0 GET_PAYMENTS,
					0 GET_PAYMENTS2,
					0 GET_PAYMENTS_PAPERS,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS2,
					0 GET_CREDIT_PAYMENTS_PAPERS
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (32,1041,1051)
				GROUP BY
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
				SELECT
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASES_PAPERS,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_PURCHASE_DIFF_PAPERS,
					0 GET_PURCHASE_RETURN,
					0 GET_PURCHASE_RETURN2,
					0 GET_PURCHASE_RETURN_PAPERS,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_EXPENSE_PAPERS,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_PAPERS,
					0 GET_SALES_CANCELED,
					0 GET_SALES2_CANCELED,
					0 GET_SALES_PAPERS_CANCELED,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_DIFF_PAPERS,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_SALES_RETURN_PAPERS,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_INCOME_PAPERS,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CASH_PAPERS,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_PAPERS,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_CHEQUE_RETURN_PAPERS,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,
					0 GET_VOUCHER_PAPERS,
					0 GET_VOUCHER_RETURN,		
					0 GET_VOUCHER2_RETURN,
					0 GET_VOUCHER_RETURN_PAPERS,
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_REVENUE_PAPERS,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_CREDIT_REVENUE_PAPERS,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_PAYM_PAPERS,
					SUM(ACTION_VALUE) GET_CHEQUE_P,
					SUM(ACTION_VALUE_2) GET_CHEQUE_P2,
					COUNT(ACTION_TYPE_ID) GET_CHEQUE_P_PAPERS,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_CHEQUE_P_RETURN_PAPERS,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_PAPERS,
					0 GET_VOUCHER_P_RETURN,	
					0 GET_VOUCHER_P2_RETURN,
					0 GET_VOUCHER_P_RETURN_PAPERS,	
					0 GET_PAYMENTS,
					0 GET_PAYMENTS2,
					0 GET_PAYMENTS_PAPERS,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS2,
					0 GET_CREDIT_PAYMENTS_PAPERS
				FROM
					CARI_ROWS
				WHERE
	
					ACTION_TYPE_ID IN (91)
	
				GROUP BY
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
				SELECT
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASES_PAPERS,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_PURCHASE_DIFF_PAPERS,
					0 GET_PURCHASE_RETURN,
					0 GET_PURCHASE_RETURN2,
					0 GET_PURCHASE_RETURN_PAPERS,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_EXPENSE_PAPERS,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_PAPERS,
					0 GET_SALES_CANCELED,
					0 GET_SALES2_CANCELED,
					0 GET_SALES_PAPERS_CANCELED,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_DIFF_PAPERS,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_SALES_RETURN_PAPERS,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_INCOME_PAPERS,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CASH_PAPERS,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_PAPERS,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_CHEQUE_RETURN_PAPERS,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,
					0 GET_VOUCHER_PAPERS,
					0 GET_VOUCHER_RETURN,		
					0 GET_VOUCHER2_RETURN,
					0 GET_VOUCHER_RETURN_PAPERS,
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_REVENUE_PAPERS,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_CREDIT_REVENUE_PAPERS,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_PAYM_PAPERS,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_PAPERS,
					SUM(ACTION_VALUE) GET_CHEQUE_P_RETURN,
					SUM(ACTION_VALUE_2) GET_CHEQUE_P2_RETURN,
					COUNT(ACTION_TYPE_ID) GET_CHEQUE_P_RETURN_PAPERS,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_PAPERS,
					0 GET_VOUCHER_P_RETURN,	
					0 GET_VOUCHER_P2_RETURN,
					0 GET_VOUCHER_P_RETURN_PAPERS,	
					0 GET_PAYMENTS,
					0 GET_PAYMENTS2,
					0 GET_PAYMENTS_PAPERS,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS2,
					0 GET_CREDIT_PAYMENTS_PAPERS
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (95)
	
				GROUP BY
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID	
		UNION ALL
				SELECT
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASES_PAPERS,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_PURCHASE_DIFF_PAPERS,
					0 GET_PURCHASE_RETURN,
					0 GET_PURCHASE_RETURN2,
					0 GET_PURCHASE_RETURN_PAPERS,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_EXPENSE_PAPERS,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_PAPERS,
					0 GET_SALES_CANCELED,
					0 GET_SALES2_CANCELED,
					0 GET_SALES_PAPERS_CANCELED,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_DIFF_PAPERS,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_SALES_RETURN_PAPERS,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_INCOME_PAPERS,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CASH_PAPERS,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_PAPERS,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_CHEQUE_RETURN_PAPERS,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,
					0 GET_VOUCHER_PAPERS,
					0 GET_VOUCHER_RETURN,		
					0 GET_VOUCHER2_RETURN,
					0 GET_VOUCHER_RETURN_PAPERS,
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_REVENUE_PAPERS,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_CREDIT_REVENUE_PAPERS,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_PAYM_PAPERS,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_PAPERS,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_CHEQUE_P_RETURN_PAPERS,
					SUM(ACTION_VALUE) GET_VOUCHER_P,
					SUM(ACTION_VALUE_2) GET_VOUCHER_P2,
					COUNT(ACTION_TYPE_ID) GET_VOUCHER_P_PAPERS,
					0 GET_VOUCHER_P_RETURN,	
					0 GET_VOUCHER_P2_RETURN,
					0 GET_VOUCHER_P_RETURN_PAPERS,	
					0 GET_PAYMENTS,
					0 GET_PAYMENTS2,
					0 GET_PAYMENTS_PAPERS,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS2,
					0 GET_CREDIT_PAYMENTS_PAPERS
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (98)
				GROUP BY
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
				SELECT
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASES_PAPERS,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_PURCHASE_DIFF_PAPERS,
					0 GET_PURCHASE_RETURN,
					0 GET_PURCHASE_RETURN2,
					0 GET_PURCHASE_RETURN_PAPERS,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_EXPENSE_PAPERS,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_PAPERS,
					0 GET_SALES_CANCELED,
					0 GET_SALES2_CANCELED,
					0 GET_SALES_PAPERS_CANCELED,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_DIFF_PAPERS,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_SALES_RETURN_PAPERS,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_INCOME_PAPERS,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CASH_PAPERS,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_PAPERS,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_CHEQUE_RETURN_PAPERS,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,
					0 GET_VOUCHER_PAPERS,
					0 GET_VOUCHER_RETURN,		
					0 GET_VOUCHER2_RETURN,
					0 GET_VOUCHER_RETURN_PAPERS,
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_REVENUE_PAPERS,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_CREDIT_REVENUE_PAPERS,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_PAYM_PAPERS,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_PAPERS,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_CHEQUE_P_RETURN_PAPERS,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_PAPERS,
					SUM(ACTION_VALUE) GET_VOUCHER_P_RETURN,
					SUM(ACTION_VALUE_2) GET_VOUCHER_P2_RETURN,
					COUNT(ACTION_TYPE_ID) GET_VOUCHER_P_RETURN_PAPERS,
					0 GET_PAYMENTS,
					0 GET_PAYMENTS2,
					0 GET_PAYMENTS_PAPERS,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS2,
					0 GET_CREDIT_PAYMENTS_PAPERS
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (108)
				GROUP BY
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
				SELECT
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASES_PAPERS,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_PURCHASE_DIFF_PAPERS,
					0 GET_PURCHASE_RETURN,
					0 GET_PURCHASE_RETURN2,
					0 GET_PURCHASE_RETURN_PAPERS,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_EXPENSE_PAPERS,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_PAPERS,
					0 GET_SALES_CANCELED,
					0 GET_SALES2_CANCELED,
					0 GET_SALES_PAPERS_CANCELED,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_DIFF_PAPERS,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_SALES_RETURN_PAPERS,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_INCOME_PAPERS,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CASH_PAPERS,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_PAPERS,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_CHEQUE_RETURN_PAPERS,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,
					0 GET_VOUCHER_PAPERS,
					0 GET_VOUCHER_RETURN,		
					0 GET_VOUCHER2_RETURN,
					0 GET_VOUCHER_RETURN_PAPERS,
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_REVENUE_PAPERS,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_CREDIT_REVENUE_PAPERS,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_PAYM_PAPERS,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_PAPERS,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_CHEQUE_P_RETURN_PAPERS,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_PAPERS,
					0 GET_VOUCHER_P_RETURN,	
					0 GET_VOUCHER_P2_RETURN,
					0 GET_VOUCHER_P_RETURN_PAPERS,	
					SUM(ACTION_VALUE) GET_PAYMENTS,
					SUM(ACTION_VALUE_2) GET_PAYMENTS2,
					COUNT(ACTION_TYPE_ID) GET_PAYMENTS_PAPERS,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS2,
					0 GET_CREDIT_PAYMENTS_PAPERS
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (25,242,1044,1054)
				GROUP BY
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
				SELECT
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASES_PAPERS,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_PURCHASE_DIFF_PAPERS,
					0 GET_PURCHASE_RETURN,
					0 GET_PURCHASE_RETURN2,
					0 GET_PURCHASE_RETURN_PAPERS,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_EXPENSE_PAPERS,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_PAPERS,
					0 GET_SALES_CANCELED,
					0 GET_SALES2_CANCELED,
					0 GET_SALES_PAPERS_CANCELED,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_DIFF_PAPERS,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_SALES_RETURN_PAPERS,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_INCOME_PAPERS,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CASH_PAPERS,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_PAPERS,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_CHEQUE_RETURN_PAPERS,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,
					0 GET_VOUCHER_PAPERS,
					0 GET_VOUCHER_RETURN,		
					0 GET_VOUCHER2_RETURN,
					0 GET_VOUCHER_RETURN_PAPERS,
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_REVENUE_PAPERS,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_CREDIT_REVENUE_PAPERS,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_PAYM_PAPERS,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_PAPERS,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_CHEQUE_P_RETURN_PAPERS,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_PAPERS,
					0 GET_VOUCHER_P_RETURN,	
					0 GET_VOUCHER_P2_RETURN,
					0 GET_VOUCHER_P_RETURN_PAPERS,
					0 GET_PAYMENTS,
					0 GET_PAYMENTS2,
					0 GET_PAYMENTS_PAPERS,
					SUM(ACTION_VALUE) GET_CREDIT_PAYMENTS,
					SUM(ACTION_VALUE_2) GET_CREDIT_PAYMENTS2,
					COUNT(ACTION_TYPE_ID) GET_CREDIT_PAYMENTS_PAPERS
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (291)
				GROUP BY
					ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
			) GET_CARI_ROWS
		GROUP BY
			ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [ACTIVITY_SUMMARY_DAILY_FOR_COMPANY]  AS
			SELECT
				COMPANY_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
				SUM(GET_PURCHASES) GET_PURCHASES,
				SUM(GET_PURCHASES2) GET_PURCHASES2,
				SUM(GET_PURCHASE_DIFF) GET_PURCHASE_DIFF,
				SUM(GET_PURCHASE_DIFF2) GET_PURCHASE_DIFF2,
				SUM(GET_PURCHASE_RETURN) GET_PURCHASE_RETURN,
				SUM(GET_PURCHASE_RETURN2) GET_PURCHASE_RETURN2,
				SUM(GET_EXPENSE) GET_EXPENSE,
				SUM(GET_EXPENSE2) GET_EXPENSE2,
				SUM(GET_SALES) GET_SALES,
				SUM(GET_SALES2) GET_SALES2,
				SUM(GET_SALES_DIFF) GET_SALES_DIFF,
				SUM(GET_SALES_DIFF2) GET_SALES_DIFF2,
				SUM(GET_SALES_RETURN) GET_SALES_RETURN,
				SUM(GET_SALES_RETURN2) GET_SALES_RETURN2,
				SUM(GET_INCOME) GET_INCOME,
				SUM(GET_INCOME2) GET_INCOME2,
				SUM(GET_CASH) GET_CASH,
				SUM(GET_CASH2) GET_CASH2,
				SUM(GET_CHEQUE) GET_CHEQUE,
				SUM(GET_CHEQUE2)GET_CHEQUE2,
				SUM(GET_CHEQUE_RETURN) GET_CHEQUE_RETURN,
				SUM(GET_CHEQUE2_RETURN)GET_CHEQUE2_RETURN,
				SUM(GET_VOUCHER) GET_VOUCHER,		
				SUM(GET_VOUCHER2) GET_VOUCHER2,
				SUM(GET_VOUCHER_RETURN) GET_VOUCHER_RETURN,
				SUM(GET_VOUCHER2_RETURN) GET_VOUCHER2_RETURN,
				SUM(GET_REVENUE) GET_REVENUE,
				SUM(GET_REVENUE2)GET_REVENUE2,
				SUM(GET_CREDIT_REVENUE) GET_CREDIT_REVENUE,
				SUM(GET_CREDIT_REVENUE2)GET_CREDIT_REVENUE2,
				SUM(GET_PAYM) GET_PAYM,
				SUM(GET_PAYM2)GET_PAYM2,
				SUM(GET_CHEQUE_P) GET_CHEQUE_P,
				SUM(GET_CHEQUE_P2) GET_CHEQUE_P2,
				SUM(GET_CHEQUE_P_RETURN) GET_CHEQUE_P_RETURN,
				SUM(GET_CHEQUE_P2_RETURN) GET_CHEQUE_P2_RETURN,
				SUM(GET_VOUCHER_P) GET_VOUCHER_P,	
				SUM(GET_VOUCHER_P2) GET_VOUCHER_P2,
				SUM(GET_VOUCHER_P_RETURN) GET_VOUCHER_P_RETURN,
				SUM(GET_VOUCHER_P2_RETURN) GET_VOUCHER_P2_RETURN,
				SUM(GET_PAYMENTS) GET_PAYMENTS,
				SUM(GET_PAYMENTS_2) GET_PAYMENTS2,
				SUM(GET_CREDIT_PAYMENTS) GET_CREDIT_PAYMENTS,
				SUM(GET_CREDIT_PAYMENTS_2) GET_CREDIT_PAYMENTS2
			FROM (
			
					SELECT
						FROM_CMP_ID COMPANY_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
						SUM(ACTION_VALUE) GET_PURCHASES,
						SUM(ACTION_VALUE_2) GET_PURCHASES2,
						0 GET_PURCHASE_DIFF,
						0 GET_PURCHASE_DIFF2,
						0 GET_PURCHASE_RETURN,
						0 GET_PURCHASE_RETURN2,
						0 GET_EXPENSE,
						0 GET_EXPENSE2,
						0 GET_SALES,
						0 GET_SALES2,
						0 GET_SALES_DIFF,
						0 GET_SALES_DIFF2,
						0 GET_SALES_RETURN,
						0 GET_SALES_RETURN2,
						0 GET_INCOME,
						0 GET_INCOME2,
						0 GET_CASH,
						0 GET_CASH2,
						0 GET_CHEQUE,
						0 GET_CHEQUE2,
						0 GET_CHEQUE_RETURN,
						0 GET_CHEQUE2_RETURN,
						0 GET_VOUCHER,
						0 GET_VOUCHER2,	
						0 GET_VOUCHER_RETURN,			
						0 GET_VOUCHER2_RETURN,
						0 GET_REVENUE,
						0 GET_REVENUE2,
						0 GET_CREDIT_REVENUE,
						0 GET_CREDIT_REVENUE2,
						0 GET_PAYM,
						0 GET_PAYM2,
						0 GET_CHEQUE_P,
						0 GET_CHEQUE_P2,
						0 GET_CHEQUE_P_RETURN,
						0 GET_CHEQUE_P2_RETURN,
						0 GET_VOUCHER_P,
						0 GET_VOUCHER_P2,
						0 GET_VOUCHER_P_RETURN,	
						0 GET_VOUCHER_P2_RETURN,
						0 GET_PAYMENTS,
						0 GET_PAYMENTS_2,
						0 GET_CREDIT_PAYMENTS,
						0 GET_CREDIT_PAYMENTS_2
					FROM
						CARI_ROWS
					WHERE
						ACTION_TYPE_ID IN (59,60,601,64,65,68,690,691,591,592) AND
						FROM_CMP_ID IS NOT NULL
					GROUP BY
						ACTION_DATE,FROM_CMP_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID	
			UNION ALL
					SELECT
						FROM_CMP_ID COMPANY_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
						0 GET_PURCHASES,
						0 GET_PURCHASES2,
						SUM(ACTION_VALUE) GET_PURCHASE_DIFF,
						SUM(ACTION_VALUE_2) GET_PURCHASE_DIFF2,
						0 GET_PURCHASE_RETURN,
						0 GET_PURCHASE_RETURN2,
						0 GET_EXPENSE,
						0 GET_EXPENSE2,
						0 GET_SALES,
						0 GET_SALES2,
						0 GET_SALES_DIFF,
						0 GET_SALES_DIFF2,
						0 GET_SALES_RETURN,
						0 GET_SALES_RETURN2,
						0 GET_INCOME,
						0 GET_INCOME2,
						0 GET_CASH,
						0 GET_CASH2,
						0 GET_CHEQUE,					
						0 GET_CHEQUE2,
						0 GET_CHEQUE_RETURN,
						0 GET_CHEQUE2_RETURN,
						0 GET_VOUCHER,
						0 GET_VOUCHER2,	
						0 GET_VOUCHER_RETURN,			
						0 GET_VOUCHER2_RETURN,
						0 GET_REVENUE,
						0 GET_REVENUE2,
						0 GET_CREDIT_REVENUE,
						0 GET_CREDIT_REVENUE2,
						0 GET_PAYM,
						0 GET_PAYM2,
						0 GET_CHEQUE_P,
						0 GET_CHEQUE_P2,
						0 GET_CHEQUE_P_RETURN,
						0 GET_CHEQUE_P2_RETURN,
						0 GET_VOUCHER_P,
						0 GET_VOUCHER_P2,
						0 GET_VOUCHER_P_RETURN,
						0 GET_VOUCHER_P2_RETURN,
						0 GET_PAYMENTS,
						0 GET_PAYMENTS_2,
						0 GET_CREDIT_PAYMENTS,
						0 GET_CREDIT_PAYMENTS_2
						
					FROM
						CARI_ROWS
					WHERE
						ACTION_TYPE_ID IN (51,63) AND
						FROM_CMP_ID IS NOT NULL
					GROUP BY
						ACTION_DATE,FROM_CMP_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
			UNION ALL
					SELECT
						TO_CMP_ID COMPANY_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
						0 GET_PURCHASES,
						0 GET_PURCHASES2,
						0 GET_PURCHASE_DIFF,
						0 GET_PURCHASE_DIFF2,
						SUM(ACTION_VALUE) GET_PURCHASE_RETURN,
						SUM(ACTION_VALUE_2) GET_PURCHASE_RETURN2,
						0 GET_EXPENSE,
						0 GET_EXPENSE2,
						0 GET_SALES,
						0 GET_SALES2,
						0 GET_SALES_DIFF,
						0 GET_SALES_DIFF2,
						0 GET_SALES_RETURN,
	
						0 GET_SALES_RETURN2,
						0 GET_INCOME,
						0 GET_INCOME2,
						0 GET_CASH,
						0 GET_CASH2,
						0 GET_CHEQUE,
						0 GET_CHEQUE2,
						0 GET_CHEQUE_RETURN,
						0 GET_CHEQUE2_RETURN,
						0 GET_VOUCHER,
						0 GET_VOUCHER2,		
						0 GET_VOUCHER_RETURN,		
						0 GET_VOUCHER2_RETURN,
						0 GET_REVENUE,
						0 GET_REVENUE2,
						0 GET_CREDIT_REVENUE,
						0 GET_CREDIT_REVENUE2,
						0 GET_PAYM,
						0 GET_PAYM2,
						0 GET_CHEQUE_P,
						0 GET_CHEQUE_P2,
						0 GET_CHEQUE_P_RETURN,
						0 GET_CHEQUE_P2_RETURN,
						0 GET_VOUCHER_P,
						0 GET_VOUCHER_P2,
						0 GET_VOUCHER_P_RETURN,
						0 GET_VOUCHER_P2_RETURN,
						0 GET_PAYMENTS,
						0 GET_PAYMENTS_2,
						0 GET_CREDIT_PAYMENTS,
						0 GET_CREDIT_PAYMENTS_2
						
					FROM
						CARI_ROWS
					WHERE
						ACTION_TYPE_ID IN (62) AND
						TO_CMP_ID IS NOT NULL
					GROUP BY
						ACTION_DATE,TO_CMP_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
			UNION ALL
					SELECT
						FROM_CMP_ID COMPANY_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
						0 GET_PURCHASES,
						0 GET_PURCHASES2,
						0 GET_PURCHASE_DIFF,
	
						0 GET_PURCHASE_DIFF2,
						0 GET_PURCHASE_RETURN,
						0 GET_PURCHASE_RETURN2,
						SUM(ACTION_VALUE) GET_EXPENSE,
						SUM(ACTION_VALUE_2) GET_EXPENSE2,
						0 GET_SALES,
						0 GET_SALES2,
						0 GET_SALES_DIFF,
						0 GET_SALES_DIFF2,
						0 GET_SALES_RETURN,
						0 GET_SALES_RETURN2,
						0 GET_INCOME,
						0 GET_INCOME2,
						0 GET_CASH,
						0 GET_CASH2,
						0 GET_CHEQUE,
						0 GET_CHEQUE2,
						0 GET_CHEQUE_RETURN,
						0 GET_CHEQUE2_RETURN,
						0 GET_VOUCHER,
						0 GET_VOUCHER2,		
						0 GET_VOUCHER_RETURN,		
						0 GET_VOUCHER2_RETURN,
						0 GET_REVENUE,
						0 GET_REVENUE2,
						0 GET_CREDIT_REVENUE,
						0 GET_CREDIT_REVENUE2,
						0 GET_PAYM,
						0 GET_PAYM2,
						0 GET_CHEQUE_P,
						0 GET_CHEQUE_P2,
						0 GET_CHEQUE_P_RETURN,
						0 GET_CHEQUE_P2_RETURN,
						0 GET_VOUCHER_P,
						0 GET_VOUCHER_P2,
						0 GET_VOUCHER_P_RETURN,	
						0 GET_VOUCHER_P2_RETURN,
						0 GET_PAYMENTS,
						0 GET_PAYMENTS_2,
						0 GET_CREDIT_PAYMENTS,
						0 GET_CREDIT_PAYMENTS_2
					FROM
						CARI_ROWS
					WHERE
						ACTION_TYPE_ID IN (42,120,131)AND
						FROM_CMP_ID IS NOT NULL
					GROUP BY
						ACTION_DATE,FROM_CMP_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
			UNION ALL
					SELECT
						TO_CMP_ID COMPANY_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
						0 GET_PURCHASES,
						0 GET_PURCHASES2,
						0 GET_PURCHASE_DIFF,
						0 GET_PURCHASE_DIFF2,
						0 GET_PURCHASE_RETURN,
						0 GET_PURCHASE_RETURN2,
						0 GET_EXPENSE,
						0 GET_EXPENSE2,
						SUM(ACTION_VALUE) GET_SALES,
						SUM(ACTION_VALUE_2) GET_SALES2,
						0 GET_SALES_DIFF,
						0 GET_SALES_DIFF2,
						0 GET_SALES_RETURN,
						0 GET_SALES_RETURN2,
						0 GET_INCOME,
						0 GET_INCOME2,
						0 GET_CASH,
						0 GET_CASH2,
						0 GET_CHEQUE,
						0 GET_CHEQUE2,
						0 GET_CHEQUE_RETURN,
						0 GET_CHEQUE2_RETURN,
						0 GET_VOUCHER,
						0 GET_VOUCHER2,		
						0 GET_VOUCHER_RETURN,		
						0 GET_VOUCHER2_RETURN,
						0 GET_REVENUE,
						0 GET_REVENUE2,
						0 GET_CREDIT_REVENUE,
						0 GET_CREDIT_REVENUE2,
						0 GET_PAYM,
						0 GET_PAYM2,
						0 GET_CHEQUE_P,
						0 GET_CHEQUE_P2,
						0 GET_CHEQUE_P_RETURN,
						0 GET_CHEQUE_P2_RETURN,
						0 GET_VOUCHER_P,
						0 GET_VOUCHER_P2,
						0 GET_VOUCHER_P_RETURN,	
						0 GET_VOUCHER_P2_RETURN,
						0 GET_PAYMENTS,
						0 GET_PAYMENTS_2,
						0 GET_CREDIT_PAYMENTS,
						0 GET_CREDIT_PAYMENTS_2
					FROM
						CARI_ROWS
					WHERE
						ACTION_TYPE_ID IN (52,53,56,561,66,67,531)AND
						TO_CMP_ID IS NOT NULL
					GROUP BY
						ACTION_DATE,TO_CMP_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
			UNION ALL
					SELECT
						TO_CMP_ID COMPANY_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
						0 GET_PURCHASES,
						0 GET_PURCHASES2,
						0 GET_PURCHASE_DIFF,
						0 GET_PURCHASE_DIFF2,
						0 GET_PURCHASE_RETURN,
						0 GET_PURCHASE_RETURN2,
						0 GET_EXPENSE,
						0 GET_EXPENSE2,
						0 GET_SALES,
						0 GET_SALES2,
						SUM(ACTION_VALUE) GET_SALES_DIFF,
						SUM(ACTION_VALUE_2) GET_SALES_DIFF2,
						0 GET_SALES_RETURN,
						0 GET_SALES_RETURN2,
						0 GET_INCOME,
						0 GET_INCOME2,
						0 GET_CASH,
						0 GET_CASH2,
						0 GET_CHEQUE,
						0 GET_CHEQUE2,
						0 GET_CHEQUE_RETURN,
						0 GET_CHEQUE2_RETURN,
						0 GET_VOUCHER,
						0 GET_VOUCHER2,		
						0 GET_VOUCHER_RETURN,		
						0 GET_VOUCHER2_RETURN,
						0 GET_REVENUE,
						0 GET_REVENUE2,
						0 GET_CREDIT_REVENUE,
						0 GET_CREDIT_REVENUE2,
						0 GET_PAYM,
						0 GET_PAYM2,
						0 GET_CHEQUE_P,
						0 GET_CHEQUE_P2,
						0 GET_CHEQUE_P_RETURN,
						0 GET_CHEQUE_P2_RETURN,
						0 GET_VOUCHER_P,
						0 GET_VOUCHER_P2,
						0 GET_VOUCHER_P_RETURN,	
						0 GET_VOUCHER_P2_RETURN,
						0 GET_PAYMENTS,
						0 GET_PAYMENTS_2,
						0 GET_CREDIT_PAYMENTS,
						0 GET_CREDIT_PAYMENTS_2
					FROM
						CARI_ROWS
					WHERE
						ACTION_TYPE_ID IN (50,58)AND
						TO_CMP_ID IS NOT NULL
					GROUP BY
						ACTION_DATE,TO_CMP_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
			UNION ALL
					SELECT
						FROM_CMP_ID COMPANY_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
						0 GET_PURCHASES,
						0 GET_PURCHASES2,
						0 GET_PURCHASE_DIFF,
						0 GET_PURCHASE_DIFF2,
						0 GET_SALES_RETURN,
						0 GET_SALES_RETURN2,
						0 GET_EXPENSE,
						0 GET_EXPENSE2,
						0 GET_SALES,
						0 GET_SALES2,
						0 GET_SALES_DIFF,
						0 GET_SALES_DIFF2,
						SUM(ACTION_VALUE) GET_SALES_RETURN,
						SUM(ACTION_VALUE_2) GET_SALES_RETURN2,
						0 GET_INCOME,
						0 GET_INCOME2,
						0 GET_CASH,
						0 GET_CASH2,
						0 GET_CHEQUE,
						0 GET_CHEQUE2,
						0 GET_CHEQUE_RETURN,
						0 GET_CHEQUE2_RETURN,
						0 GET_VOUCHER,
						0 GET_VOUCHER2,		
						0 GET_VOUCHER_RETURN,		
						0 GET_VOUCHER2_RETURN,
						0 GET_REVENUE,
						0 GET_REVENUE2,
						0 GET_CREDIT_REVENUE,
						0 GET_CREDIT_REVENUE2,
						0 GET_PAYM,
						0 GET_PAYM2,
						0 GET_CHEQUE_P,
						0 GET_CHEQUE_P2,
						0 GET_CHEQUE_P_RETURN,
						0 GET_CHEQUE_P2_RETURN,
						0 GET_VOUCHER_P,
						0 GET_VOUCHER_P2,
						0 GET_VOUCHER_P_RETURN,
						0 GET_VOUCHER_P2_RETURN,
						0 GET_PAYMENTS,
						0 GET_PAYMENTS_2,
						0 GET_CREDIT_PAYMENTS,
						0 GET_CREDIT_PAYMENTS_2
					FROM
						CARI_ROWS
					WHERE
						ACTION_TYPE_ID IN (54,55)AND
						FROM_CMP_ID IS NOT NULL
					GROUP BY
						ACTION_DATE,FROM_CMP_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
			UNION ALL
					SELECT
						TO_CMP_ID COMPANY_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
						0 GET_PURCHASES,
						0 GET_PURCHASES2,
						0 GET_PURCHASE_DIFF,
						0 GET_PURCHASE_DIFF2,
						0 GET_SALES_RETURN,
						0 GET_SALES_RETURN2,
						0 GET_EXPENSE,
						0 GET_EXPENSE2,
						0 GET_SALES,
						0 GET_SALES2,
						0 GET_SALES_DIFF,
						0 GET_SALES_DIFF2,
						0 GET_SALES_RETURN,
						0 GET_SALES_RETURN2,
						SUM(ACTION_VALUE) GET_INCOME,
						SUM(ACTION_VALUE_2) GET_INCOME2,
						0 GET_CASH,
						0 GET_CASH2,
						0 GET_CHEQUE,
						0 GET_CHEQUE2,
						0 GET_CHEQUE_RETURN,
						0 GET_CHEQUE2_RETURN,
						0 GET_VOUCHER,
						0 GET_VOUCHER2,		
						0 GET_VOUCHER_RETURN,		
						0 GET_VOUCHER2_RETURN,
						0 GET_REVENUE,
						0 GET_REVENUE2,
						0 GET_CREDIT_REVENUE,
						0 GET_CREDIT_REVENUE2,
						0 GET_PAYM,
						0 GET_PAYM2,
						0 GET_CHEQUE_P,
						0 GET_CHEQUE_P2,
						0 GET_CHEQUE_P_RETURN,
						0 GET_CHEQUE_P2_RETURN,
						0 GET_VOUCHER_P,
						0 GET_VOUCHER_P2,
						0 GET_VOUCHER_P_RETURN,
						0 GET_VOUCHER_P2_RETURN,
						0 GET_PAYMENTS,
						0 GET_PAYMENTS_2,
						0 GET_CREDIT_PAYMENTS,
						0 GET_CREDIT_PAYMENTS_2
					FROM
						CARI_ROWS
					WHERE
						ACTION_TYPE_ID IN (41,121)AND
						TO_CMP_ID IS NOT NULL
					GROUP BY
						ACTION_DATE,TO_CMP_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
			UNION ALL
					SELECT
						FROM_CMP_ID COMPANY_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
						0 GET_PURCHASES,
						0 GET_PURCHASES2,
						0 GET_PURCHASE_DIFF,
						0 GET_PURCHASE_DIFF2,
						0 GET_SALES_RETURN,
						0 GET_SALES_RETURN2,
						0 GET_EXPENSE,
						0 GET_EXPENSE2,
						0 GET_SALES,
						0 GET_SALES2,
						0 GET_SALES_DIFF,
						0 GET_SALES_DIFF2,
						0 GET_SALES_RETURN,
						0 GET_SALES_RETURN2,
						0 GET_INCOME,
						0 GET_INCOME2,
						SUM(ACTION_VALUE) GET_CASH,
						SUM(ACTION_VALUE_2) GET_CASH2,
						0 GET_CHEQUE,
						0 GET_CHEQUE2,
						0 GET_CHEQUE_RETURN,
						0 GET_CHEQUE2_RETURN,
						0 GET_VOUCHER,
						0 GET_VOUCHER2,		
						0 GET_VOUCHER_RETURN,		
						0 GET_VOUCHER2_RETURN,
						0 GET_REVENUE,
						0 GET_REVENUE2,
						0 GET_CREDIT_REVENUE,
						0 GET_CREDIT_REVENUE2,
						0 GET_PAYM,
						0 GET_PAYM2,
						0 GET_CHEQUE_P,
						0 GET_CHEQUE_P2,
						0 GET_CHEQUE_P_RETURN,
						0 GET_CHEQUE_P2_RETURN,
						0 GET_VOUCHER_P,
						0 GET_VOUCHER_P2,
						0 GET_VOUCHER_P_RETURN,
						0 GET_VOUCHER_P2_RETURN,
						0 GET_PAYMENTS,
						0 GET_PAYMENTS_2,
						0 GET_CREDIT_PAYMENTS,
						0 GET_CREDIT_PAYMENTS_2			
					FROM
						CARI_ROWS
					WHERE
						ACTION_TYPE_ID IN (31,35,1040,1050)AND
						FROM_CMP_ID IS NOT NULL
					GROUP BY
						ACTION_DATE,FROM_CMP_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
			UNION ALL
					SELECT
						FROM_CMP_ID COMPANY_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
						0 GET_PURCHASES,
						0 GET_PURCHASES2,
						0 GET_PURCHASE_DIFF,
						0 GET_PURCHASE_DIFF2,
						0 GET_SALES_RETURN,
						0 GET_SALES_RETURN2,
						0 GET_EXPENSE,
						0 GET_EXPENSE2,
						0 GET_SALES,
						0 GET_SALES2,
						0 GET_SALES_DIFF,
						0 GET_SALES_DIFF2,
						0 GET_SALES_RETURN,
						0 GET_SALES_RETURN2,
						0 GET_INCOME,
						0 GET_INCOME2,
						0 GET_CASH,
						0 GET_CASH2,
						SUM(ACTION_VALUE) GET_CHEQUE,
						SUM(ACTION_VALUE_2) GET_CHEQUE2,
						0 GET_CHEQUE_RETURN,
						0 GET_CHEQUE2_RETURN,
						0 GET_VOUCHER,
						0 GET_VOUCHER2,
						0 GET_VOUCHER_RETURN,		
						0 GET_VOUCHER2_RETURN,
						0 GET_REVENUE,
						0 GET_REVENUE2,
						0 GET_CREDIT_REVENUE,
						0 GET_CREDIT_REVENUE2,
						0 GET_PAYM,
						0 GET_PAYM2,
						0 GET_CHEQUE_P,
						0 GET_CHEQUE_P2,
						0 GET_CHEQUE_P_RETURN,
						0 GET_CHEQUE_P2_RETURN,
						0 GET_VOUCHER_P,
						0 GET_VOUCHER_P2,
						0 GET_VOUCHER_P_RETURN,
						0 GET_VOUCHER_P2_RETURN,
						0 GET_PAYMENTS,
						0 GET_PAYMENTS_2,
						0 GET_CREDIT_PAYMENTS,
						0 GET_CREDIT_PAYMENTS_2			
					FROM
						CARI_ROWS
					WHERE
						ACTION_TYPE_ID IN (90)AND
						FROM_CMP_ID IS NOT NULL
					GROUP BY
						ACTION_DATE,FROM_CMP_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
			UNION ALL
					SELECT
						TO_CMP_ID COMPANY_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
						0 GET_PURCHASES,
						0 GET_PURCHASES2,
						0 GET_PURCHASE_DIFF,
						0 GET_PURCHASE_DIFF2,
						0 GET_SALES_RETURN,
						0 GET_SALES_RETURN2,
						0 GET_EXPENSE,
						0 GET_EXPENSE2,
						0 GET_SALES,
						0 GET_SALES2,
						0 GET_SALES_DIFF,
						0 GET_SALES_DIFF2,
						0 GET_SALES_RETURN,
						0 GET_SALES_RETURN2,
						0 GET_INCOME,
						0 GET_INCOME2,
						0 GET_CASH,
						0 GET_CASH2,
						0 GET_CHEQUE,
						0 GET_CHEQUE2,
						SUM(ACTION_VALUE) GET_CHEQUE_RETURN,
						SUM(ACTION_VALUE_2) GET_CHEQUE2_RETURN,
						0 GET_VOUCHER,
						0 GET_VOUCHER2,	
						0 GET_VOUCHER_RETURN,			
						0 GET_VOUCHER2_RETURN,
						0 GET_REVENUE,
						0 GET_REVENUE2,
						0 GET_CREDIT_REVENUE,
						0 GET_CREDIT_REVENUE2,
						0 GET_PAYM,
						0 GET_PAYM2,
						0 GET_CHEQUE_P,
						0 GET_CHEQUE_P2,
						0 GET_CHEQUE_P_RETURN,
						0 GET_CHEQUE_P2_RETURN,
						0 GET_VOUCHER_P,
						0 GET_VOUCHER_P2,
						0 GET_VOUCHER_P_RETURN,
						0 GET_VOUCHER_P2_RETURN,
						0 GET_PAYMENTS,
						0 GET_PAYMENTS_2,
						0 GET_CREDIT_PAYMENTS,
						0 GET_CREDIT_PAYMENTS_2			
					FROM
						CARI_ROWS
					WHERE
						ACTION_TYPE_ID IN (94)AND
						TO_CMP_ID IS NOT NULL
					GROUP BY
						ACTION_DATE,TO_CMP_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
			UNION ALL
					SELECT
						FROM_CMP_ID COMPANY_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
						0 GET_PURCHASES,
						0 GET_PURCHASES2,
						0 GET_PURCHASE_DIFF,
						0 GET_PURCHASE_DIFF2,
						0 GET_SALES_RETURN,
						0 GET_SALES_RETURN2,
						0 GET_EXPENSE,
						0 GET_EXPENSE2,
						0 GET_SALES,
						0 GET_SALES2,
						0 GET_SALES_DIFF,
						0 GET_SALES_DIFF2,
						0 GET_SALES_RETURN,
						0 GET_SALES_RETURN2,
						0 GET_INCOME,
						0 GET_INCOME2,
						0 GET_CASH,
						0 GET_CASH2,
						0 GET_CHEQUE,
						0 GET_CHEQUE2,
						0 GET_CHEQUE_RETURN,
						0 GET_CHEQUE2_RETURN,
						SUM(ACTION_VALUE) GET_VOUCHER,
						SUM(ACTION_VALUE_2) GET_VOUCHER2,	
						0 GET_VOUCHER_RETURN,	
						0 GET_VOUCHER2_RETURN,
						0 GET_REVENUE,
						0 GET_REVENUE2,
						0 GET_CREDIT_REVENUE,
						0 GET_CREDIT_REVENUE2,
						0 GET_PAYM,
						0 GET_PAYM2,
						0 GET_CHEQUE_P,
						0 GET_CHEQUE_P2,
						0 GET_CHEQUE_P_RETURN,
						0 GET_CHEQUE_P2_RETURN,
						0 GET_VOUCHER_P,
						0 GET_VOUCHER_P2,
						0 GET_VOUCHER_P_RETURN,
						0 GET_VOUCHER_P2_RETURN,
						0 GET_PAYMENTS,
						0 GET_PAYMENTS_2,
						0 GET_CREDIT_PAYMENTS,
						0 GET_CREDIT_PAYMENTS_2
					FROM
						CARI_ROWS
					WHERE
						ACTION_TYPE_ID IN (97)AND
						FROM_CMP_ID IS NOT NULL
					GROUP BY
						ACTION_DATE,FROM_CMP_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
			UNION ALL
					SELECT
						TO_CMP_ID COMPANY_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
						0 GET_PURCHASES,
						0 GET_PURCHASES2,
						0 GET_PURCHASE_DIFF,
						0 GET_PURCHASE_DIFF2,
						0 GET_SALES_RETURN,
						0 GET_SALES_RETURN2,
						0 GET_EXPENSE,
						0 GET_EXPENSE2,
						0 GET_SALES,
						0 GET_SALES2,
						0 GET_SALES_DIFF,
						0 GET_SALES_DIFF2,
						0 GET_SALES_RETURN,
						0 GET_SALES_RETURN2,
						0 GET_INCOME,
						0 GET_INCOME2,
						0 GET_CASH,
						0 GET_CASH2,
						0 GET_CHEQUE,
						0 GET_CHEQUE2,
						0 GET_CHEQUE_RETURN,
						0 GET_CHEQUE2_RETURN,
						0 GET_VOUCHER,
						0 GET_VOUCHER2,		
						SUM(ACTION_VALUE) GET_VOUCHER_RETURN,	
						SUM(ACTION_VALUE_2) GET_VOUCHER2_RETURN,					
						0 GET_REVENUE,
						0 GET_REVENUE2,
						0 GET_CREDIT_REVENUE,
						0 GET_CREDIT_REVENUE2,
						0 GET_PAYM,
						0 GET_PAYM2,
						0 GET_CHEQUE_P,
						0 GET_CHEQUE_P2,
						0 GET_CHEQUE_P_RETURN,
						0 GET_CHEQUE_P2_RETURN,
						0 GET_VOUCHER_P,
						0 GET_VOUCHER_P2,
						0 GET_VOUCHER_P_RETURN,
						0 GET_VOUCHER_P2_RETURN,
						0 GET_PAYMENTS,
						0 GET_PAYMENTS_2,
						0 GET_CREDIT_PAYMENTS,
						0 GET_CREDIT_PAYMENTS_2
					FROM
						CARI_ROWS
					WHERE
						ACTION_TYPE_ID IN (101)AND
						TO_CMP_ID IS NOT NULL
					GROUP BY
						ACTION_DATE,TO_CMP_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
			UNION ALL
					SELECT
						FROM_CMP_ID COMPANY_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
						0 GET_PURCHASES,
						0 GET_PURCHASES2,
						0 GET_PURCHASE_DIFF,
						0 GET_PURCHASE_DIFF2,
						0 GET_SALES_RETURN,
						0 GET_SALES_RETURN2,
						0 GET_EXPENSE,
						0 GET_EXPENSE2,
						0 GET_SALES,
						0 GET_SALES2,
						0 GET_SALES_DIFF,
						0 GET_SALES_DIFF2,
						0 GET_SALES_RETURN,
						0 GET_SALES_RETURN2,
						0 GET_INCOME,
						0 GET_INCOME2,
						0 GET_CASH,
						0 GET_CASH2,
						0 GET_CHEQUE,
						0 GET_CHEQUE2,
						0 GET_CHEQUE_RETURN,
						0 GET_CHEQUE2_RETURN,
						0 GET_VOUCHER,
						0 GET_VOUCHER2,		
						0 GET_VOUCHER_RETURN,		
						0 GET_VOUCHER2_RETURN,
						SUM(ACTION_VALUE) GET_REVENUE,
						SUM(ACTION_VALUE_2) GET_REVENUE2,
						0 GET_CREDIT_REVENUE,
						0 GET_CREDIT_REVENUE2,
						0 GET_PAYM,
						0 GET_PAYM2,
						0 GET_CHEQUE_P,
						0 GET_CHEQUE_P2,
						0 GET_CHEQUE_P_RETURN,
						0 GET_CHEQUE_P2_RETURN,
						0 GET_VOUCHER_P,
						0 GET_VOUCHER_P2,
						0 GET_VOUCHER_P_RETURN,
						0 GET_VOUCHER_P2_RETURN,
						0 GET_PAYMENTS,
						0 GET_PAYMENTS_2,
						0 GET_CREDIT_PAYMENTS,
						0 GET_CREDIT_PAYMENTS_2
					FROM
						CARI_ROWS
					WHERE
						ACTION_TYPE_ID IN (24,240,241,1043,1053)AND
						FROM_CMP_ID IS NOT NULL
					GROUP BY
						ACTION_DATE,FROM_CMP_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
			UNION ALL
					SELECT
						FROM_CMP_ID COMPANY_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
						0 GET_PURCHASES,
						0 GET_PURCHASES2,
						0 GET_PURCHASE_DIFF,
						0 GET_PURCHASE_DIFF2,
						0 GET_SALES_RETURN,
						0 GET_SALES_RETURN2,
						0 GET_EXPENSE,
						0 GET_EXPENSE2,
						0 GET_SALES,
						0 GET_SALES2,
						0 GET_SALES_DIFF,
						0 GET_SALES_DIFF2,
						0 GET_SALES_RETURN,
						0 GET_SALES_RETURN2,
						0 GET_INCOME,
						0 GET_INCOME2,
						0 GET_CASH,
						0 GET_CASH2,
						0 GET_CHEQUE,
						0 GET_CHEQUE2,
						0 GET_CHEQUE_RETURN,
						0 GET_CHEQUE2_RETURN,
						0 GET_VOUCHER,
						0 GET_VOUCHER2,		
						0 GET_VOUCHER_RETURN,		
						0 GET_VOUCHER2_RETURN,
						0 GET_REVENUE,
						0 GET_REVENUE2,
						SUM(ACTION_VALUE) GET_CREDIT_REVENUE,
						SUM(ACTION_VALUE_2) GET_CREDIT_REVENUE2,
						0 GET_PAYM,
						0 GET_PAYM2,
						0 GET_CHEQUE_P,
						0 GET_CHEQUE_P2,
						0 GET_CHEQUE_P_RETURN,
						0 GET_CHEQUE_P2_RETURN,
						0 GET_VOUCHER_P,
						0 GET_VOUCHER_P2,
						0 GET_VOUCHER_P_RETURN,
						0 GET_VOUCHER_P2_RETURN,
						0 GET_PAYMENTS,
						0 GET_PAYMENTS_2,
						0 GET_CREDIT_PAYMENTS,
						0 GET_CREDIT_PAYMENTS_2			
					FROM
						CARI_ROWS
					WHERE
						ACTION_TYPE_ID IN (292)AND
						FROM_CMP_ID IS NOT NULL			
					GROUP BY
						ACTION_DATE,FROM_CMP_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
			UNION ALL
					SELECT
						TO_CMP_ID COMPANY_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
						0 GET_PURCHASES,
						0 GET_PURCHASES2,
						0 GET_PURCHASE_DIFF,
						0 GET_PURCHASE_DIFF2,
						0 GET_SALES_RETURN,
						0 GET_SALES_RETURN2,
						0 GET_EXPENSE,
						0 GET_EXPENSE2,
						0 GET_SALES,
						0 GET_SALES2,
						0 GET_SALES_DIFF,
						0 GET_SALES_DIFF2,
						0 GET_SALES_RETURN,
						0 GET_SALES_RETURN2,
						0 GET_INCOME,
						0 GET_INCOME2,
						0 GET_CASH,
						0 GET_CASH2,
						0 GET_CHEQUE,
						0 GET_CHEQUE2,
						0 GET_CHEQUE_RETURN,
						0 GET_CHEQUE2_RETURN,
						0 GET_VOUCHER,
						0 GET_VOUCHER2,		
						0 GET_VOUCHER_RETURN,		
						0 GET_VOUCHER2_RETURN,
						0 GET_REVENUE,
						0 GET_REVENUE2,
						0 GET_CREDIT_REVENUE,
						0 GET_CREDIT_REVENUE2,
						SUM(ACTION_VALUE) GET_PAYM,
						SUM(ACTION_VALUE_2) GET_PAYM2,
						0 GET_CHEQUE_P,
						0 GET_CHEQUE_P2,
						0 GET_CHEQUE_P_RETURN,
						0 GET_CHEQUE_P2_RETURN,
						0 GET_VOUCHER_P,
						0 GET_VOUCHER_P2,
						0 GET_VOUCHER_P_RETURN,
						0 GET_VOUCHER_P2_RETURN,
						0 GET_PAYMENTS,
						0 GET_PAYMENTS_2,
						0 GET_CREDIT_PAYMENTS,
						0 GET_CREDIT_PAYMENTS_2
					FROM
						CARI_ROWS
					WHERE
						ACTION_TYPE_ID IN (32,1041,1051)AND
						TO_CMP_ID IS NOT NULL
					GROUP BY
						ACTION_DATE,TO_CMP_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
			UNION ALL
					SELECT
						TO_CMP_ID COMPANY_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
						0 GET_PURCHASES,
						0 GET_PURCHASES2,
						0 GET_PURCHASE_DIFF,
						0 GET_PURCHASE_DIFF2,
						0 GET_SALES_RETURN,
						0 GET_SALES_RETURN2,
						0 GET_EXPENSE,
						0 GET_EXPENSE2,
						0 GET_SALES,
						0 GET_SALES2,
						0 GET_SALES_DIFF,
						0 GET_SALES_DIFF2,
						0 GET_SALES_RETURN,
						0 GET_SALES_RETURN2,
						0 GET_INCOME,
						0 GET_INCOME2,
						0 GET_CASH,
						0 GET_CASH2,
						0 GET_CHEQUE,
						0 GET_CHEQUE2,
						0 GET_CHEQUE_RETURN,
						0 GET_CHEQUE2_RETURN,
						0 GET_VOUCHER,
						0 GET_VOUCHER2,		
						0 GET_VOUCHER_RETURN,		
						0 GET_VOUCHER2_RETURN,
						0 GET_REVENUE,
						0 GET_REVENUE2,
						0 GET_CREDIT_REVENUE,
						0 GET_CREDIT_REVENUE2,
						0 GET_PAYM,
						0 GET_PAYM2,
						SUM(ACTION_VALUE) GET_CHEQUE_P,
						SUM(ACTION_VALUE_2) GET_CHEQUE_P2,
						0 GET_CHEQUE_P_RETURN,
						0 GET_CHEQUE_P2_RETURN,
						0 GET_VOUCHER_P,
						0 GET_VOUCHER_P2,
						0 GET_VOUCHER_P_RETURN,
						0 GET_VOUCHER_P2_RETURN,
						0 GET_PAYMENTS,
						0 GET_PAYMENTS_2,
						0 GET_CREDIT_PAYMENTS,
						0 GET_CREDIT_PAYMENTS_2
					FROM
						CARI_ROWS
					WHERE
						ACTION_TYPE_ID IN (91)AND
						TO_CMP_ID IS NOT NULL		
					GROUP BY
						ACTION_DATE,TO_CMP_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
			UNION ALL
					SELECT
						FROM_CMP_ID COMPANY_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
						0 GET_PURCHASES,
						0 GET_PURCHASES2,
						0 GET_PURCHASE_DIFF,
						0 GET_PURCHASE_DIFF2,
						0 GET_SALES_RETURN,
						0 GET_SALES_RETURN2,
						0 GET_EXPENSE,
						0 GET_EXPENSE2,
						0 GET_SALES,
						0 GET_SALES2,
						0 GET_SALES_DIFF,
						0 GET_SALES_DIFF2,
						0 GET_SALES_RETURN,
						0 GET_SALES_RETURN2,
						0 GET_INCOME,
						0 GET_INCOME2,
						0 GET_CASH,
						0 GET_CASH2,
						0 GET_CHEQUE,
						0 GET_CHEQUE2,
						0 GET_CHEQUE_RETURN,
						0 GET_CHEQUE2_RETURN,
						0 GET_VOUCHER,
						0 GET_VOUCHER2,		
						0 GET_VOUCHER_RETURN,		
						0 GET_VOUCHER2_RETURN,
						0 GET_REVENUE,
						0 GET_REVENUE2,
						0 GET_CREDIT_REVENUE,
						0 GET_CREDIT_REVENUE2,
						0 GET_PAYM,
						0 GET_PAYM2,
						0 GET_CHEQUE_P,
						0 GET_CHEQUE_P2,
						SUM(ACTION_VALUE) GET_CHEQUE_P_RETURN,
						SUM(ACTION_VALUE_2) GET_CHEQUE_P2_RETURN,
						0 GET_VOUCHER_P,
						0 GET_VOUCHER_P2,
						0 GET_VOUCHER_P_RETURN,
						0 GET_VOUCHER_P2_RETURN,
						0 GET_PAYMENTS,
						0 GET_PAYMENTS_2,
						0 GET_CREDIT_PAYMENTS,
						0 GET_CREDIT_PAYMENTS_2
					FROM
						CARI_ROWS
					WHERE
						ACTION_TYPE_ID IN (95)AND
						FROM_CMP_ID IS NOT NULL		
					GROUP BY
						ACTION_DATE,FROM_CMP_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
			UNION ALL
					SELECT
						TO_CMP_ID COMPANY_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
						0 GET_PURCHASES,
						0 GET_PURCHASES2,
						0 GET_PURCHASE_DIFF,
						0 GET_PURCHASE_DIFF2,
						0 GET_SALES_RETURN,
						0 GET_SALES_RETURN2,
						0 GET_EXPENSE,
						0 GET_EXPENSE2,
						0 GET_SALES,
						0 GET_SALES2,
						0 GET_SALES_DIFF,
						0 GET_SALES_DIFF2,
						0 GET_SALES_RETURN,
						0 GET_SALES_RETURN2,
						0 GET_INCOME,
						0 GET_INCOME2,
						0 GET_CASH,
						0 GET_CASH2,
						0 GET_CHEQUE,
						0 GET_CHEQUE2,
						0 GET_CHEQUE_RETURN,
						0 GET_CHEQUE2_RETURN,
						0 GET_VOUCHER,
						0 GET_VOUCHER2,		
						0 GET_VOUCHER_RETURN,		
						0 GET_VOUCHER2_RETURN,
						0 GET_REVENUE,
						0 GET_REVENUE2,
						0 GET_CREDIT_REVENUE,
						0 GET_CREDIT_REVENUE2,
						0 GET_PAYM,
						0 GET_PAYM2,
						0 GET_CHEQUE_P,
						0 GET_CHEQUE_P2,
						0 GET_CHEQUE_P_RETURN,
						0 GET_CHEQUE_P2_RETURN,
						SUM(ACTION_VALUE) GET_VOUCHER_P,
						SUM(ACTION_VALUE_2) GET_VOUCHER_P2,
						0 GET_VOUCHER_P_RETURN,
						0 GET_VOUCHER_P2_RETURN,
						0 GET_PAYMENTS,
						0 GET_PAYMENTS_2,
						0 GET_CREDIT_PAYMENTS,
						0 GET_CREDIT_PAYMENTS_2
					FROM
						CARI_ROWS
					WHERE
						ACTION_TYPE_ID IN (98)AND
						TO_CMP_ID IS NOT NULL
					GROUP BY
						ACTION_DATE,TO_CMP_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
			UNION ALL
					SELECT
						FROM_CMP_ID COMPANY_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
						0 GET_PURCHASES,
						0 GET_PURCHASES2,
						0 GET_PURCHASE_DIFF,
						0 GET_PURCHASE_DIFF2,
						0 GET_SALES_RETURN,
						0 GET_SALES_RETURN2,
						0 GET_EXPENSE,
						0 GET_EXPENSE2,
						0 GET_SALES,
						0 GET_SALES2,
						0 GET_SALES_DIFF,
						0 GET_SALES_DIFF2,
						0 GET_SALES_RETURN,
						0 GET_SALES_RETURN2,
						0 GET_INCOME,
						0 GET_INCOME2,
						0 GET_CASH,
						0 GET_CASH2,
						0 GET_CHEQUE,
						0 GET_CHEQUE2,
						0 GET_CHEQUE_RETURN,
						0 GET_CHEQUE2_RETURN,
						0 GET_VOUCHER,
						0 GET_VOUCHER2,		
						0 GET_VOUCHER_RETURN,		
						0 GET_VOUCHER2_RETURN,
						0 GET_REVENUE,
						0 GET_REVENUE2,
						0 GET_CREDIT_REVENUE,
						0 GET_CREDIT_REVENUE2,
						0 GET_PAYM,
						0 GET_PAYM2,
						0 GET_CHEQUE_P,
						0 GET_CHEQUE_P2,
						0 GET_CHEQUE_P_RETURN,
						0 GET_CHEQUE_P2_RETURN,
						0 GET_VOUCHER_P,
						0 GET_VOUCHER_P2,
						SUM(ACTION_VALUE) GET_VOUCHER_P_RETURN,
						SUM(ACTION_VALUE_2) GET_VOUCHER_P2_RETURN,
						0 GET_PAYMENTS,
						0 GET_PAYMENTS_2,
						0 GET_CREDIT_PAYMENTS,
						0 GET_CREDIT_PAYMENTS_2
					FROM
						CARI_ROWS
					WHERE
						ACTION_TYPE_ID IN (108)AND
						FROM_CMP_ID IS NOT NULL
					GROUP BY
						ACTION_DATE,FROM_CMP_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
			UNION ALL
					SELECT
						TO_CMP_ID COMPANY_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
						0 GET_PURCHASES,
						0 GET_PURCHASES2,
						0 GET_PURCHASE_DIFF,
						0 GET_PURCHASE_DIFF2,
						0 GET_SALES_RETURN,
						0 GET_SALES_RETURN2,
						0 GET_EXPENSE,
						0 GET_EXPENSE2,
	
						0 GET_SALES,
						0 GET_SALES2,
						0 GET_SALES_DIFF,
						0 GET_SALES_DIFF2,
						0 GET_SALES_RETURN,
						0 GET_SALES_RETURN2,
						0 GET_INCOME,
						0 GET_INCOME2,
						0 GET_CASH,
						0 GET_CASH2,
						0 GET_CHEQUE,
						0 GET_CHEQUE2,
						0 GET_CHEQUE_RETURN,
						0 GET_CHEQUE2_RETURN,
						0 GET_VOUCHER,
						0 GET_VOUCHER2,		
						0 GET_VOUCHER_RETURN,		
						0 GET_VOUCHER2_RETURN,
						0 GET_REVENUE,
						0 GET_REVENUE2,
						0 GET_CREDIT_REVENUE,
						0 GET_CREDIT_REVENUE2,
						0 GET_PAYM,
						0 GET_PAYM2,
						0 GET_CHEQUE_P,
						0 GET_CHEQUE_P2,
						0 GET_CHEQUE_P_RETURN,
						0 GET_CHEQUE_P2_RETURN,
						0 GET_VOUCHER_P,
						0 GET_VOUCHER_P2,
						0 GET_VOUCHER_P_RETURN,	
						0 GET_VOUCHER_P2_RETURN,
						SUM(ACTION_VALUE) GET_PAYMENTS,
						SUM(ACTION_VALUE_2) GET_PAYMENTS_2,
						0 GET_CREDIT_PAYMENTS,
						0 GET_CREDIT_PAYMENTS_2
					FROM
						CARI_ROWS
					WHERE
						ACTION_TYPE_ID IN (25,242,1044,1054)AND
						TO_CMP_ID IS NOT NULL
					GROUP BY
						ACTION_DATE,TO_CMP_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
			UNION ALL
					SELECT
						TO_CMP_ID COMPANY_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
						0 GET_PURCHASES,
						0 GET_PURCHASES2,
						0 GET_PURCHASE_DIFF,
						0 GET_PURCHASE_DIFF2,
						0 GET_SALES_RETURN,
						0 GET_SALES_RETURN2,
						0 GET_EXPENSE,
						0 GET_EXPENSE2,
						0 GET_SALES,
						0 GET_SALES2,
						0 GET_SALES_DIFF,
						0 GET_SALES_DIFF2,
						0 GET_SALES_RETURN,
						0 GET_SALES_RETURN2,
						0 GET_INCOME,
						0 GET_INCOME2,
						0 GET_CASH,
						0 GET_CASH2,
						0 GET_CHEQUE,
						0 GET_CHEQUE2,
						0 GET_CHEQUE_RETURN,
						0 GET_CHEQUE2_RETURN,
						0 GET_VOUCHER,
						0 GET_VOUCHER2,		
						0 GET_VOUCHER_RETURN,		
						0 GET_VOUCHER2_RETURN,
						0 GET_REVENUE,
						0 GET_REVENUE2,
						0 GET_CREDIT_REVENUE,
						0 GET_CREDIT_REVENUE2,
						0 GET_PAYM,
						0 GET_PAYM2,
						0 GET_CHEQUE_P,
						0 GET_CHEQUE_P2,
						0 GET_CHEQUE_P_RETURN,
						0 GET_CHEQUE_P2_RETURN,
						0 GET_VOUCHER_P,
						0 GET_VOUCHER_P2,
						0 GET_VOUCHER_P_RETURN,		
						0 GET_VOUCHER_P2_RETURN,
						0 GET_PAYMENTS,
						0 GET_PAYMENTS_2,
						SUM(ACTION_VALUE) GET_CREDIT_PAYMENTS,
						SUM(ACTION_VALUE_2) GET_CREDIT_PAYMENTS_2
					FROM
						CARI_ROWS
					WHERE
						ACTION_TYPE_ID IN (291)AND
						TO_CMP_ID IS NOT NULL
					GROUP BY
						ACTION_DATE,TO_CMP_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
				) GET_CARI_ROWS
			GROUP BY
				ACTION_DATE,COMPANY_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [ACTIVITY_SUMMARY_DAILY_FOR_CONSUMER] AS
		SELECT
			CONSUMER_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
			SUM(GET_PURCHASES) GET_PURCHASES,
			SUM(GET_PURCHASES2) GET_PURCHASES2,
			SUM(GET_PURCHASE_DIFF) GET_PURCHASE_DIFF,
			SUM(GET_PURCHASE_DIFF2) GET_PURCHASE_DIFF2,
			SUM(GET_PURCHASE_RETURN) GET_PURCHASE_RETURN,
			SUM(GET_PURCHASE_RETURN2) GET_PURCHASE_RETURN2,
			SUM(GET_EXPENSE) GET_EXPENSE,
			SUM(GET_EXPENSE2) GET_EXPENSE2,
			SUM(GET_SALES) GET_SALES,
			SUM(GET_SALES2) GET_SALES2,
			SUM(GET_SALES_DIFF) GET_SALES_DIFF,
			SUM(GET_SALES_DIFF2) GET_SALES_DIFF2,
			SUM(GET_SALES_RETURN) GET_SALES_RETURN,
			SUM(GET_SALES_RETURN2) GET_SALES_RETURN2,
			SUM(GET_INCOME) GET_INCOME,
			SUM(GET_INCOME2) GET_INCOME2,
			SUM(GET_CASH) GET_CASH,
			SUM(GET_CASH2) GET_CASH2,
			SUM(GET_CHEQUE) GET_CHEQUE,
			SUM(GET_CHEQUE2)GET_CHEQUE2,
			SUM(GET_CHEQUE_RETURN) GET_CHEQUE_RETURN,
			SUM(GET_CHEQUE2_RETURN)GET_CHEQUE2_RETURN,
			SUM(GET_VOUCHER) GET_VOUCHER,		
			SUM(GET_VOUCHER2) GET_VOUCHER2,
			SUM(GET_VOUCHER_RETURN) GET_VOUCHER_RETURN,
			SUM(GET_VOUCHER2_RETURN) GET_VOUCHER2_RETURN,
			SUM(GET_REVENUE) GET_REVENUE,
			SUM(GET_REVENUE2)GET_REVENUE2,
			SUM(GET_CREDIT_REVENUE) GET_CREDIT_REVENUE,
			SUM(GET_CREDIT_REVENUE2)GET_CREDIT_REVENUE2,
			SUM(GET_PAYM) GET_PAYM,
			SUM(GET_PAYM2)GET_PAYM2,
			SUM(GET_CHEQUE_P) GET_CHEQUE_P,
			SUM(GET_CHEQUE_P2) GET_CHEQUE_P2,
			SUM(GET_CHEQUE_P_RETURN) GET_CHEQUE_P_RETURN,
			SUM(GET_CHEQUE_P2_RETURN) GET_CHEQUE_P2_RETURN,
			SUM(GET_VOUCHER_P) GET_VOUCHER_P,	
			SUM(GET_VOUCHER_P2) GET_VOUCHER_P2,
			SUM(GET_VOUCHER_P_RETURN) GET_VOUCHER_P_RETURN,
			SUM(GET_VOUCHER_P2_RETURN) GET_VOUCHER_P2_RETURN,
			SUM(GET_PAYMENTS) GET_PAYMENTS,
			SUM(GET_PAYMENTS_2) GET_PAYMENTS2,
			SUM(GET_CREDIT_PAYMENTS) GET_CREDIT_PAYMENTS,
			SUM(GET_CREDIT_PAYMENTS_2) GET_CREDIT_PAYMENTS2
		FROM (
		
				SELECT
					FROM_CONSUMER_ID CONSUMER_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					SUM(ACTION_VALUE) GET_PURCHASES,
					SUM(ACTION_VALUE_2) GET_PURCHASES2,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_PURCHASE_RETURN,
					0 GET_PURCHASE_RETURN2,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,	
					0 GET_VOUCHER_RETURN,			
					0 GET_VOUCHER2_RETURN,
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_RETURN,	
					0 GET_VOUCHER_P2_RETURN,
					0 GET_PAYMENTS,
					0 GET_PAYMENTS_2,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS_2
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (59,60,601,64,65,68,690,691,591,592) AND
					FROM_CONSUMER_ID IS NOT NULL
				GROUP BY
					ACTION_DATE,FROM_CONSUMER_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID			
		UNION ALL
				SELECT
					FROM_CONSUMER_ID CONSUMER_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					SUM(ACTION_VALUE) GET_PURCHASE_DIFF,
					SUM(ACTION_VALUE_2) GET_PURCHASE_DIFF2,
					0 GET_PURCHASE_RETURN,
					0 GET_PURCHASE_RETURN2,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CHEQUE,					
					0 GET_CHEQUE2,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,	
					0 GET_VOUCHER_RETURN,			
					0 GET_VOUCHER2_RETURN,
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_RETURN,
					0 GET_VOUCHER_P2_RETURN,
					0 GET_PAYMENTS,
					0 GET_PAYMENTS_2,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS_2
					
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (51,63) AND
					FROM_CONSUMER_ID IS NOT NULL
				GROUP BY
					ACTION_DATE,FROM_CONSUMER_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
				SELECT
					TO_CONSUMER_ID CONSUMER_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					SUM(ACTION_VALUE) GET_PURCHASE_RETURN,
					SUM(ACTION_VALUE_2) GET_PURCHASE_RETURN2,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,		
					0 GET_VOUCHER_RETURN,		
					0 GET_VOUCHER2_RETURN,
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_RETURN,
					0 GET_VOUCHER_P2_RETURN,
					0 GET_PAYMENTS,
					0 GET_PAYMENTS_2,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS_2
					
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (62) AND
					TO_CONSUMER_ID IS NOT NULL
				GROUP BY
					ACTION_DATE,TO_CONSUMER_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
				SELECT
					FROM_CONSUMER_ID CONSUMER_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_PURCHASE_RETURN,
					0 GET_PURCHASE_RETURN2,
					SUM(ACTION_VALUE) GET_EXPENSE,
					SUM(ACTION_VALUE_2) GET_EXPENSE2,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,		
					0 GET_VOUCHER_RETURN,		
					0 GET_VOUCHER2_RETURN,
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_RETURN,	
					0 GET_VOUCHER_P2_RETURN,
					0 GET_PAYMENTS,
					0 GET_PAYMENTS_2,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS_2
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (42,120,131)AND
					FROM_CONSUMER_ID IS NOT NULL
				GROUP BY
					ACTION_DATE,FROM_CONSUMER_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
				SELECT
					TO_CONSUMER_ID CONSUMER_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_PURCHASE_RETURN,
					0 GET_PURCHASE_RETURN2,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					SUM(ACTION_VALUE) GET_SALES,
					SUM(ACTION_VALUE_2) GET_SALES2,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,		
					0 GET_VOUCHER_RETURN,		
					0 GET_VOUCHER2_RETURN,
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_RETURN,	
					0 GET_VOUCHER_P2_RETURN,
					0 GET_PAYMENTS,
					0 GET_PAYMENTS_2,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS_2
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (52,53,56,561,66,67,531)AND
					TO_CONSUMER_ID IS NOT NULL
				GROUP BY
					ACTION_DATE,TO_CONSUMER_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
				SELECT
					TO_CONSUMER_ID CONSUMER_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_PURCHASE_RETURN,
					0 GET_PURCHASE_RETURN2,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_SALES,
					0 GET_SALES2,
					SUM(ACTION_VALUE) GET_SALES_DIFF,
					SUM(ACTION_VALUE_2) GET_SALES_DIFF2,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,		
					0 GET_VOUCHER_RETURN,		
					0 GET_VOUCHER2_RETURN,
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_RETURN,	
					0 GET_VOUCHER_P2_RETURN,
					0 GET_PAYMENTS,
					0 GET_PAYMENTS_2,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS_2
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (50,58)AND
					TO_CONSUMER_ID IS NOT NULL
				GROUP BY
					ACTION_DATE,TO_CONSUMER_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
				SELECT
					FROM_CONSUMER_ID CONSUMER_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					SUM(ACTION_VALUE) GET_SALES_RETURN,
					SUM(ACTION_VALUE_2) GET_SALES_RETURN2,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,		
					0 GET_VOUCHER_RETURN,		
					0 GET_VOUCHER2_RETURN,
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_RETURN,
					0 GET_VOUCHER_P2_RETURN,
					0 GET_PAYMENTS,
					0 GET_PAYMENTS_2,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS_2
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (54,55)AND
					FROM_CONSUMER_ID IS NOT NULL
				GROUP BY
					ACTION_DATE,FROM_CONSUMER_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
				SELECT
					TO_CONSUMER_ID CONSUMER_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					SUM(ACTION_VALUE) GET_INCOME,
					SUM(ACTION_VALUE_2) GET_INCOME2,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,		
					0 GET_VOUCHER_RETURN,		
					0 GET_VOUCHER2_RETURN,
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_RETURN,
					0 GET_VOUCHER_P2_RETURN,
					0 GET_PAYMENTS,
					0 GET_PAYMENTS_2,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS_2
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (41,121)AND
					TO_CONSUMER_ID IS NOT NULL
				GROUP BY
					ACTION_DATE,TO_CONSUMER_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
				SELECT
					FROM_CONSUMER_ID CONSUMER_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_INCOME,
					0 GET_INCOME2,
					SUM(ACTION_VALUE) GET_CASH,
					SUM(ACTION_VALUE_2) GET_CASH2,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,		
					0 GET_VOUCHER_RETURN,		
					0 GET_VOUCHER2_RETURN,
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_RETURN,
					0 GET_VOUCHER_P2_RETURN,
					0 GET_PAYMENTS,
					0 GET_PAYMENTS_2,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS_2			
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (31,35,1040,1050)AND
					FROM_CONSUMER_ID IS NOT NULL
				GROUP BY
					ACTION_DATE,FROM_CONSUMER_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
				SELECT
					FROM_CONSUMER_ID CONSUMER_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_CASH,
					0 GET_CASH2,
					SUM(ACTION_VALUE) GET_CHEQUE,
					SUM(ACTION_VALUE_2) GET_CHEQUE2,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,
					0 GET_VOUCHER_RETURN,		
					0 GET_VOUCHER2_RETURN,
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_RETURN,
					0 GET_VOUCHER_P2_RETURN,
					0 GET_PAYMENTS,
					0 GET_PAYMENTS_2,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS_2			
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (90)AND
					FROM_CONSUMER_ID IS NOT NULL
				GROUP BY
					ACTION_DATE,FROM_CONSUMER_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
				SELECT
					TO_CONSUMER_ID CONSUMER_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					SUM(ACTION_VALUE) GET_CHEQUE_RETURN,
					SUM(ACTION_VALUE_2) GET_CHEQUE2_RETURN,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,	
					0 GET_VOUCHER_RETURN,			
					0 GET_VOUCHER2_RETURN,
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_VOUCHER_P,
	
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_RETURN,
					0 GET_VOUCHER_P2_RETURN,
					0 GET_PAYMENTS,
					0 GET_PAYMENTS_2,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS_2			
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (94)AND
					TO_CONSUMER_ID IS NOT NULL
				GROUP BY
					ACTION_DATE,TO_CONSUMER_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
				SELECT
					FROM_CONSUMER_ID CONSUMER_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					SUM(ACTION_VALUE) GET_VOUCHER,
					SUM(ACTION_VALUE_2) GET_VOUCHER2,	
					0 GET_VOUCHER_RETURN,	
					0 GET_VOUCHER2_RETURN,
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_RETURN,
					0 GET_VOUCHER_P2_RETURN,
					0 GET_PAYMENTS,
					0 GET_PAYMENTS_2,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS_2
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (97)AND
					FROM_CONSUMER_ID IS NOT NULL
				GROUP BY
					ACTION_DATE,FROM_CONSUMER_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
				SELECT
					TO_CONSUMER_ID CONSUMER_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,		
					SUM(ACTION_VALUE) GET_VOUCHER_RETURN,	
					SUM(ACTION_VALUE_2) GET_VOUCHER2_RETURN,					
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_RETURN,
					0 GET_VOUCHER_P2_RETURN,
					0 GET_PAYMENTS,
					0 GET_PAYMENTS_2,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS_2
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (101)AND
					TO_CONSUMER_ID IS NOT NULL
				GROUP BY
					ACTION_DATE,TO_CONSUMER_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
				SELECT
					FROM_CONSUMER_ID CONSUMER_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,		
					0 GET_VOUCHER_RETURN,		
					0 GET_VOUCHER2_RETURN,
					SUM(ACTION_VALUE) GET_REVENUE,
					SUM(ACTION_VALUE_2) GET_REVENUE2,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_RETURN,
					0 GET_VOUCHER_P2_RETURN,
					0 GET_PAYMENTS,
					0 GET_PAYMENTS_2,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS_2
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (24,240,241,1043,1053)AND
					FROM_CONSUMER_ID IS NOT NULL
				GROUP BY
					ACTION_DATE,FROM_CONSUMER_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
				SELECT
					FROM_CONSUMER_ID CONSUMER_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,		
					0 GET_VOUCHER_RETURN,		
					0 GET_VOUCHER2_RETURN,
					0 GET_REVENUE,
					0 GET_REVENUE2,
					SUM(ACTION_VALUE) GET_CREDIT_REVENUE,
					SUM(ACTION_VALUE_2) GET_CREDIT_REVENUE2,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_RETURN,
					0 GET_VOUCHER_P2_RETURN,
					0 GET_PAYMENTS,
					0 GET_PAYMENTS_2,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS_2			
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (292)AND
					FROM_CONSUMER_ID IS NOT NULL			
				GROUP BY
					ACTION_DATE,FROM_CONSUMER_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
				SELECT
					TO_CONSUMER_ID CONSUMER_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,		
					0 GET_VOUCHER_RETURN,		
					0 GET_VOUCHER2_RETURN,
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					SUM(ACTION_VALUE) GET_PAYM,
					SUM(ACTION_VALUE_2) GET_PAYM2,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_RETURN,
					0 GET_VOUCHER_P2_RETURN,
					0 GET_PAYMENTS,
					0 GET_PAYMENTS_2,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS_2
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (32,1041,1051)AND
					TO_CONSUMER_ID IS NOT NULL
				GROUP BY
					ACTION_DATE,TO_CONSUMER_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
				SELECT
					TO_CONSUMER_ID CONSUMER_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,		
					0 GET_VOUCHER_RETURN,		
					0 GET_VOUCHER2_RETURN,
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_PAYM,
					0 GET_PAYM2,
					SUM(ACTION_VALUE) GET_CHEQUE_P,
					SUM(ACTION_VALUE_2) GET_CHEQUE_P2,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_RETURN,
					0 GET_VOUCHER_P2_RETURN,
					0 GET_PAYMENTS,
					0 GET_PAYMENTS_2,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS_2
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (91)AND
					TO_CONSUMER_ID IS NOT NULL		
				GROUP BY
					ACTION_DATE,TO_CONSUMER_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
				SELECT
					FROM_CONSUMER_ID CONSUMER_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,		
					0 GET_VOUCHER_RETURN,		
					0 GET_VOUCHER2_RETURN,
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					SUM(ACTION_VALUE) GET_CHEQUE_P_RETURN,
					SUM(ACTION_VALUE_2) GET_CHEQUE_P2_RETURN,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_RETURN,
					0 GET_VOUCHER_P2_RETURN,
					0 GET_PAYMENTS,
					0 GET_PAYMENTS_2,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS_2
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (95)AND
					FROM_CONSUMER_ID IS NOT NULL		
				GROUP BY
					ACTION_DATE,FROM_CONSUMER_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
				SELECT
					TO_CONSUMER_ID CONSUMER_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,		
					0 GET_VOUCHER_RETURN,		
					0 GET_VOUCHER2_RETURN,
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					SUM(ACTION_VALUE) GET_VOUCHER_P,
					SUM(ACTION_VALUE_2) GET_VOUCHER_P2,
					0 GET_VOUCHER_P_RETURN,
					0 GET_VOUCHER_P2_RETURN,
					0 GET_PAYMENTS,
					0 GET_PAYMENTS_2,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS_2
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (98)AND
					TO_CONSUMER_ID IS NOT NULL
				GROUP BY
					ACTION_DATE,TO_CONSUMER_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
				SELECT
					FROM_CONSUMER_ID CONSUMER_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,		
					0 GET_VOUCHER_RETURN,		
					0 GET_VOUCHER2_RETURN,
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					SUM(ACTION_VALUE) GET_VOUCHER_P_RETURN,
					SUM(ACTION_VALUE_2) GET_VOUCHER_P2_RETURN,
					0 GET_PAYMENTS,
					0 GET_PAYMENTS_2,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS_2
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (108)AND
					FROM_CONSUMER_ID IS NOT NULL
				GROUP BY
					ACTION_DATE,FROM_CONSUMER_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
				SELECT
					TO_CONSUMER_ID CONSUMER_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,		
					0 GET_VOUCHER_RETURN,		
					0 GET_VOUCHER2_RETURN,
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_RETURN,	
					0 GET_VOUCHER_P2_RETURN,
					SUM(ACTION_VALUE) GET_PAYMENTS,
					SUM(ACTION_VALUE_2) GET_PAYMENTS_2,
					0 GET_CREDIT_PAYMENTS,
					0 GET_CREDIT_PAYMENTS_2
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (25,242,1044,1054)AND
					TO_CONSUMER_ID IS NOT NULL
				GROUP BY
					ACTION_DATE,TO_CONSUMER_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
		UNION ALL
				SELECT
					TO_CONSUMER_ID CONSUMER_ID,ACTION_DATE,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID,
					0 GET_PURCHASES,
					0 GET_PURCHASES2,
					0 GET_PURCHASE_DIFF,
					0 GET_PURCHASE_DIFF2,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_EXPENSE,
					0 GET_EXPENSE2,
					0 GET_SALES,
					0 GET_SALES2,
					0 GET_SALES_DIFF,
					0 GET_SALES_DIFF2,
					0 GET_SALES_RETURN,
					0 GET_SALES_RETURN2,
					0 GET_INCOME,
					0 GET_INCOME2,
					0 GET_CASH,
					0 GET_CASH2,
					0 GET_CHEQUE,
					0 GET_CHEQUE2,
					0 GET_CHEQUE_RETURN,
					0 GET_CHEQUE2_RETURN,
					0 GET_VOUCHER,
					0 GET_VOUCHER2,		
					0 GET_VOUCHER_RETURN,		
					0 GET_VOUCHER2_RETURN,
					0 GET_REVENUE,
					0 GET_REVENUE2,
					0 GET_CREDIT_REVENUE,
					0 GET_CREDIT_REVENUE2,
					0 GET_PAYM,
					0 GET_PAYM2,
					0 GET_CHEQUE_P,
					0 GET_CHEQUE_P2,
					0 GET_CHEQUE_P_RETURN,
					0 GET_CHEQUE_P2_RETURN,
					0 GET_VOUCHER_P,
					0 GET_VOUCHER_P2,
					0 GET_VOUCHER_P_RETURN,		
					0 GET_VOUCHER_P2_RETURN,
					0 GET_PAYMENTS,
					0 GET_PAYMENTS_2,
					SUM(ACTION_VALUE) GET_CREDIT_PAYMENTS,
					SUM(ACTION_VALUE_2) GET_CREDIT_PAYMENTS_2
				FROM
					CARI_ROWS
				WHERE
					ACTION_TYPE_ID IN (291)AND
					TO_CONSUMER_ID IS NOT NULL
				GROUP BY
					ACTION_DATE,TO_CONSUMER_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID
			) GET_CARI_ROWS
		GROUP BY
			ACTION_DATE,CONSUMER_ID,FROM_BRANCH_ID,TO_BRANCH_ID,PROJECT_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [CHEQUE_IN_BANK] AS
			SELECT
				0 AS ALACAK, 
				SUM(CHEQUE.OTHER_MONEY_VALUE) AS BORC, 
				ACCOUNTS.ACCOUNT_ID, 
				ACCOUNTS.ACCOUNT_NAME
			FROM
				#new_dsn3#.ACCOUNTS AS ACCOUNTS,
				PAYROLL,
				CHEQUE,
				CHEQUE_HISTORY
			WHERE
				CHEQUE.CHEQUE_STATUS_ID = 2 AND 
				ACCOUNTS.ACCOUNT_ID = PAYROLL.PAYROLL_ACCOUNT_ID AND
				CHEQUE_HISTORY.CHEQUE_ID = CHEQUE.CHEQUE_ID AND
				CHEQUE_HISTORY.PAYROLL_ID = PAYROLL.ACTION_ID AND
				CHEQUE_HISTORY.HISTORY_ID = (SELECT MAX(CH.HISTORY_ID) FROM CHEQUE_HISTORY CH WHERE CH.CHEQUE_ID = CHEQUE.CHEQUE_ID AND CH.STATUS = 2)
			GROUP BY
				ACCOUNTS.ACCOUNT_ID, 
				ACCOUNTS.ACCOUNT_NAME

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [CHEQUE_IN_GUARANTEE] AS
			SELECT
				SUM(CHEQUE.OTHER_MONEY_VALUE) AS TEMINAT_CEKLER, 
				ACCOUNTS.ACCOUNT_ID, 
				ACCOUNTS.ACCOUNT_NAME
			FROM
				#new_dsn3#.ACCOUNTS AS ACCOUNTS,
				PAYROLL,
				CHEQUE,
				CHEQUE_HISTORY
			WHERE
				CHEQUE.CHEQUE_STATUS_ID = 13 AND 
				ACCOUNTS.ACCOUNT_ID = PAYROLL.PAYROLL_ACCOUNT_ID AND
				CHEQUE_HISTORY.CHEQUE_ID = CHEQUE.CHEQUE_ID AND
				CHEQUE_HISTORY.PAYROLL_ID = PAYROLL.ACTION_ID AND
				CHEQUE_HISTORY.HISTORY_ID = (SELECT MAX(CH.HISTORY_ID) FROM CHEQUE_HISTORY CH WHERE CH.CHEQUE_ID = CHEQUE.CHEQUE_ID AND CH.STATUS = 13)
			GROUP BY
				ACCOUNTS.ACCOUNT_ID, 
				ACCOUNTS.ACCOUNT_NAME

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [CHEQUE_TO_PAY] AS
		SELECT
			0 AS ALACAK, 
			SUM(CHEQUE.OTHER_MONEY_VALUE) AS BORC,
			ACCOUNTS.ACCOUNT_ID,
			ACCOUNTS.ACCOUNT_NAME
		FROM 
			#new_dsn3#.ACCOUNTS AS ACCOUNTS,
			CHEQUE
		WHERE
			CHEQUE.CHEQUE_STATUS_ID = 6 AND 
			ACCOUNTS.ACCOUNT_ID = CHEQUE.ACCOUNT_ID 
		GROUP BY
			ACCOUNTS.ACCOUNT_ID, 
			ACCOUNTS.ACCOUNT_NAME

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [CHEQUE_VOUCHER_TOTAL] 
		AS
		SELECT
			0 ACTION_VALUE_B,
			SUM(OTHER_MONEY_VALUE) ACTION_VALUE_A,
			OTHER_MONEY ACTION_CURRENCY,
			0 ACTION_VALUE2_B,
			SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_A,
			OTHER_MONEY2 ACTION_MONEY2,		
			0 OTHER_CASH_ACT_VALUE_B,
			SUM(OTHER_MONEY_VALUE/(PAYROLL_MONEY.RATE2/PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_A,
			--CHEQUE.CURRENCY_ID OTHER_MONEY,
			PAYROLL_OTHER_MONEY OTHER_MONEY,
			CHEQUE.COMPANY_ID,
			CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
		FROM
			CHEQUE,
			PAYROLL,
			PAYROLL_MONEY
		WHERE
			(CHEQUE_STATUS_ID IN (1,2,13,5,10) OR (CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE > GETDATE())) AND
			CHEQUE_PAYROLL_ID = PAYROLL.ACTION_ID AND
			CHEQUE.COMPANY_ID IS NOT NULL AND 
			PAYROLL.PAYROLL_OTHER_MONEY = PAYROLL_MONEY.MONEY_TYPE AND
			PAYROLL.ACTION_ID = PAYROLL_MONEY.ACTION_ID
		GROUP BY
			--CHEQUE.CURRENCY_ID,
			OTHER_MONEY,
			OTHER_MONEY2,
			CHEQUE.COMPANY_ID,
			PAYROLL_REVENUE_DATE,
			CHEQUE_DUEDATE,
			PAYROLL_RECORD_DATE,
			PAYROLL_OTHER_MONEY
	UNION ALL
		SELECT
			0 ACTION_VALUE_B,
			SUM(OTHER_MONEY_VALUE) ACTION_VALUE_A,
			OTHER_MONEY ACTION_CURRENCY,
			0 ACTION_VALUE2_B,
			SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_A,
			OTHER_MONEY2 ACTION_MONEY2,		
			0 OTHER_CASH_ACT_VALUE_B,
			SUM(OTHER_MONEY_VALUE/(VOUCHER_PAYROLL_MONEY.RATE2/VOUCHER_PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_A,
			--VOUCHER.CURRENCY_ID OTHER_MONEY,
			PAYROLL_OTHER_MONEY OTHER_MONEY,
			VOUCHER.COMPANY_ID,
			CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
		FROM
			VOUCHER,
			VOUCHER_PAYROLL,
			VOUCHER_PAYROLL_MONEY
		WHERE
			(VOUCHER_STATUS_ID IN (1,2,13,5,10,11) OR (VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE > GETDATE())) AND
			VOUCHER_PAYROLL_ID = VOUCHER_PAYROLL.ACTION_ID AND
			VOUCHER.COMPANY_ID IS NOT NULL AND 
			VOUCHER_PAYROLL.PAYROLL_OTHER_MONEY = VOUCHER_PAYROLL_MONEY.MONEY_TYPE AND
			VOUCHER_PAYROLL.ACTION_ID = VOUCHER_PAYROLL_MONEY.ACTION_ID
		GROUP BY 
			--VOUCHER.CURRENCY_ID,
			OTHER_MONEY,
			OTHER_MONEY2,
			VOUCHER.COMPANY_ID,
			PAYROLL_REVENUE_DATE,
			VOUCHER_DUEDATE,
			PAYROLL_RECORD_DATE,
			PAYROLL_OTHER_MONEY
	UNION ALL
		SELECT
			SUM(OTHER_MONEY_VALUE) ACTION_VALUE_B,
			0 ACTION_VALUE_A,
			OTHER_MONEY ACTION_CURRENCY,
			SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_B,
			0 ACTION_VALUE2_A,
			OTHER_MONEY2 ACTION_MONEY2,		
			SUM(OTHER_MONEY_VALUE/(PAYROLL_MONEY.RATE2/PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_B,
			0 OTHER_CASH_ACT_VALUE_A,
			--CHEQUE.CURRENCY_ID OTHER_MONEY,
			PAYROLL_OTHER_MONEY OTHER_MONEY,
			CHEQUE.COMPANY_ID,
			CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
		FROM
			CHEQUE,
			PAYROLL,
			PAYROLL_MONEY
		WHERE
			CHEQUE_STATUS_ID IN (6) AND
			CHEQUE_PAYROLL_ID = PAYROLL.ACTION_ID AND
			CHEQUE.COMPANY_ID IS NOT NULL AND 
			PAYROLL.PAYROLL_OTHER_MONEY = PAYROLL_MONEY.MONEY_TYPE AND
			PAYROLL.ACTION_ID = PAYROLL_MONEY.ACTION_ID
		GROUP BY
			--CHEQUE.CURRENCY_ID,
	
			OTHER_MONEY,
			OTHER_MONEY2,
			CHEQUE.COMPANY_ID,
			PAYROLL_REVENUE_DATE,
			CHEQUE_DUEDATE,
			PAYROLL_RECORD_DATE,
			PAYROLL_OTHER_MONEY
	UNION ALL
		SELECT
			SUM(OTHER_MONEY_VALUE) ACTION_VALUE_B,
			0 ACTION_VALUE_A,
			OTHER_MONEY ACTION_CURRENCY,
			SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_B,
			0 ACTION_VALUE2_A,
			OTHER_MONEY2 ACTION_MONEY2,		
			SUM(OTHER_MONEY_VALUE/(VOUCHER_PAYROLL_MONEY.RATE2/VOUCHER_PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_B,
			0 OTHER_CASH_ACT_VALUE_A,
			--VOUCHER.CURRENCY_ID OTHER_MONEY,
			PAYROLL_OTHER_MONEY OTHER_MONEY,			
			VOUCHER.COMPANY_ID,
			CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
		FROM
			VOUCHER,
			VOUCHER_PAYROLL,
			VOUCHER_PAYROLL_MONEY
		WHERE
			VOUCHER_STATUS_ID IN (6) AND
			VOUCHER_PAYROLL_ID = VOUCHER_PAYROLL.ACTION_ID AND
			VOUCHER.COMPANY_ID IS NOT NULL AND 
			VOUCHER_PAYROLL.PAYROLL_OTHER_MONEY = VOUCHER_PAYROLL_MONEY.MONEY_TYPE AND
			VOUCHER_PAYROLL.ACTION_ID = VOUCHER_PAYROLL_MONEY.ACTION_ID
		GROUP BY 
			--VOUCHER.CURRENCY_ID,
			OTHER_MONEY,
			OTHER_MONEY2,
			VOUCHER.COMPANY_ID,
			PAYROLL_REVENUE_DATE,
			VOUCHER_DUEDATE,
			PAYROLL_RECORD_DATE,
			PAYROLL_OTHER_MONEY

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [CHEQUE_VOUCHER_TOTAL_BRANCH]  AS
			SELECT
				0 ACTION_VALUE_B,
				SUM(OTHER_MONEY_VALUE) ACTION_VALUE_A,
				OTHER_MONEY ACTION_CURRENCY,
				0 ACTION_VALUE2_B,
				SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_A,
				OTHER_MONEY2 ACTION_MONEY2,		
				0 OTHER_CASH_ACT_VALUE_B,
				SUM(OTHER_MONEY_VALUE/(PAYROLL_MONEY.RATE2/PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_A,
				PAYROLL_OTHER_MONEY OTHER_MONEY,
				CHEQUE.COMPANY_ID,
				PAYROLL.BRANCH_ID,
				CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
			FROM
				CHEQUE,
				PAYROLL,
				PAYROLL_MONEY
			WHERE
				(CHEQUE_STATUS_ID IN (1,2,13,5,10) OR (CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE > GETDATE())) AND
				CHEQUE_PAYROLL_ID = PAYROLL.ACTION_ID AND
				CHEQUE.COMPANY_ID IS NOT NULL AND 
				PAYROLL.PAYROLL_OTHER_MONEY = PAYROLL_MONEY.MONEY_TYPE AND
				PAYROLL.ACTION_ID = PAYROLL_MONEY.ACTION_ID
			GROUP BY
				OTHER_MONEY,
				OTHER_MONEY2,
				CHEQUE.COMPANY_ID,
				PAYROLL.BRANCH_ID,
				PAYROLL_REVENUE_DATE,
				CHEQUE_DUEDATE,
				PAYROLL_RECORD_DATE,
				PAYROLL_OTHER_MONEY
		UNION ALL
			SELECT
				0 ACTION_VALUE_B,
				SUM(OTHER_MONEY_VALUE) ACTION_VALUE_A,
				OTHER_MONEY ACTION_CURRENCY,
				0 ACTION_VALUE2_B,
				SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_A,
				OTHER_MONEY2 ACTION_MONEY2,		
				0 OTHER_CASH_ACT_VALUE_B,
				SUM(OTHER_MONEY_VALUE/(VOUCHER_PAYROLL_MONEY.RATE2/VOUCHER_PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_A,
				PAYROLL_OTHER_MONEY OTHER_MONEY,
				VOUCHER.COMPANY_ID,
				VOUCHER_PAYROLL.BRANCH_ID,
				CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
			FROM
				VOUCHER,
				VOUCHER_PAYROLL,
				VOUCHER_PAYROLL_MONEY
			WHERE
				(VOUCHER_STATUS_ID IN (1,2,13,5,10,11) OR (VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE > GETDATE())) AND
				VOUCHER_PAYROLL_ID = VOUCHER_PAYROLL.ACTION_ID AND
				VOUCHER.COMPANY_ID IS NOT NULL AND 
				VOUCHER_PAYROLL.PAYROLL_OTHER_MONEY = VOUCHER_PAYROLL_MONEY.MONEY_TYPE AND
				VOUCHER_PAYROLL.ACTION_ID = VOUCHER_PAYROLL_MONEY.ACTION_ID
			GROUP BY 
				OTHER_MONEY,
				OTHER_MONEY2,
				VOUCHER.COMPANY_ID,
				VOUCHER_PAYROLL.BRANCH_ID,
				PAYROLL_REVENUE_DATE,
				VOUCHER_DUEDATE,
				PAYROLL_RECORD_DATE,
				PAYROLL_OTHER_MONEY
		UNION ALL
			SELECT
				SUM(OTHER_MONEY_VALUE) ACTION_VALUE_B,
				0 ACTION_VALUE_A,
				OTHER_MONEY ACTION_CURRENCY,
				SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_B,
				0 ACTION_VALUE2_A,
				OTHER_MONEY2 ACTION_MONEY2,		
				SUM(OTHER_MONEY_VALUE/(PAYROLL_MONEY.RATE2/PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_B,
				0 OTHER_CASH_ACT_VALUE_A,
				PAYROLL_OTHER_MONEY OTHER_MONEY,
				CHEQUE.COMPANY_ID,
				PAYROLL.BRANCH_ID,
				CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
			FROM
				CHEQUE,
				PAYROLL,
				PAYROLL_MONEY
			WHERE
				CHEQUE_STATUS_ID IN (6) AND
				CHEQUE_PAYROLL_ID = PAYROLL.ACTION_ID AND
				CHEQUE.COMPANY_ID IS NOT NULL AND 
				PAYROLL.PAYROLL_OTHER_MONEY = PAYROLL_MONEY.MONEY_TYPE AND
				PAYROLL.ACTION_ID = PAYROLL_MONEY.ACTION_ID
			GROUP BY
				OTHER_MONEY,
				OTHER_MONEY2,
				CHEQUE.COMPANY_ID,
				PAYROLL.BRANCH_ID,
				PAYROLL_REVENUE_DATE,
				CHEQUE_DUEDATE,
				PAYROLL_RECORD_DATE,
				PAYROLL_OTHER_MONEY
		UNION ALL
			SELECT

				SUM(OTHER_MONEY_VALUE) ACTION_VALUE_B,
	
				0 ACTION_VALUE_A,
				OTHER_MONEY ACTION_CURRENCY,
				SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_B,
				0 ACTION_VALUE2_A,
				OTHER_MONEY2 ACTION_MONEY2,		
				SUM(OTHER_MONEY_VALUE/(VOUCHER_PAYROLL_MONEY.RATE2/VOUCHER_PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_B,
				0 OTHER_CASH_ACT_VALUE_A,
				PAYROLL_OTHER_MONEY OTHER_MONEY,			
				VOUCHER.COMPANY_ID,
				VOUCHER_PAYROLL.BRANCH_ID,
				CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
			FROM
				VOUCHER,
				VOUCHER_PAYROLL,
				VOUCHER_PAYROLL_MONEY
			WHERE
				VOUCHER_STATUS_ID IN (6) AND
				VOUCHER_PAYROLL_ID = VOUCHER_PAYROLL.ACTION_ID AND
				VOUCHER.COMPANY_ID IS NOT NULL AND 
				VOUCHER_PAYROLL.PAYROLL_OTHER_MONEY = VOUCHER_PAYROLL_MONEY.MONEY_TYPE AND
				VOUCHER_PAYROLL.ACTION_ID = VOUCHER_PAYROLL_MONEY.ACTION_ID
			GROUP BY 
				OTHER_MONEY,
				OTHER_MONEY2,
				VOUCHER.COMPANY_ID,
				VOUCHER_PAYROLL.BRANCH_ID,
				PAYROLL_REVENUE_DATE,
				VOUCHER_DUEDATE,
				PAYROLL_RECORD_DATE,
				PAYROLL_OTHER_MONEY

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [CHEQUE_VOUCHER_TOTAL_CONSUMER] AS
			SELECT
				0 ACTION_VALUE_B,
				SUM(OTHER_MONEY_VALUE) ACTION_VALUE_A,
				OTHER_MONEY ACTION_CURRENCY,
				0 ACTION_VALUE2_B,
				SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_A,
				OTHER_MONEY2 ACTION_MONEY2,		
				0 OTHER_CASH_ACT_VALUE_B,
				SUM(OTHER_MONEY_VALUE/(PAYROLL_MONEY.RATE2/PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_A,
				--CHEQUE.CURRENCY_ID OTHER_MONEY,
				PAYROLL_OTHER_MONEY OTHER_MONEY,
				CHEQUE.CONSUMER_ID,
				CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
			FROM
				CHEQUE,
				PAYROLL,
				PAYROLL_MONEY
			WHERE
				(CHEQUE_STATUS_ID IN (1,2,13,5,10) OR (CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE > GETDATE())) AND
				CHEQUE_PAYROLL_ID = PAYROLL.ACTION_ID AND
				CHEQUE.CONSUMER_ID IS NOT NULL AND 
				PAYROLL.PAYROLL_OTHER_MONEY = PAYROLL_MONEY.MONEY_TYPE AND
				PAYROLL.ACTION_ID = PAYROLL_MONEY.ACTION_ID
			GROUP BY
				--CHEQUE.CURRENCY_ID,
				OTHER_MONEY,
				OTHER_MONEY2,
				CHEQUE.CONSUMER_ID,
				PAYROLL_REVENUE_DATE,
				CHEQUE_DUEDATE,
				PAYROLL_RECORD_DATE,
				PAYROLL_OTHER_MONEY
		UNION ALL
			SELECT
				0 ACTION_VALUE_B,
				SUM(OTHER_MONEY_VALUE) ACTION_VALUE_A,
				OTHER_MONEY ACTION_CURRENCY,
				0 ACTION_VALUE2_B,
				SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_A,
				OTHER_MONEY2 ACTION_MONEY2,		
				0 OTHER_CASH_ACT_VALUE_B,
				SUM(OTHER_MONEY_VALUE/(VOUCHER_PAYROLL_MONEY.RATE2/VOUCHER_PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_A,
				--VOUCHER.CURRENCY_ID OTHER_MONEY,
				PAYROLL_OTHER_MONEY OTHER_MONEY,
				VOUCHER.CONSUMER_ID,
				CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
			FROM
				VOUCHER,
				VOUCHER_PAYROLL,
				VOUCHER_PAYROLL_MONEY
			WHERE
				(VOUCHER_STATUS_ID IN (1,2,13,5,10,11) OR (VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE > GETDATE())) AND
				VOUCHER_PAYROLL_ID = VOUCHER_PAYROLL.ACTION_ID AND
				VOUCHER.CONSUMER_ID IS NOT NULL AND 
				VOUCHER_PAYROLL.PAYROLL_OTHER_MONEY = VOUCHER_PAYROLL_MONEY.MONEY_TYPE AND
				VOUCHER_PAYROLL.ACTION_ID = VOUCHER_PAYROLL_MONEY.ACTION_ID
			GROUP BY 
				--VOUCHER.CURRENCY_ID,
				OTHER_MONEY,
				OTHER_MONEY2,
				VOUCHER.CONSUMER_ID,
				PAYROLL_REVENUE_DATE,
				VOUCHER_DUEDATE,
				PAYROLL_RECORD_DATE,
				PAYROLL_OTHER_MONEY
		UNION ALL
			SELECT
				SUM(OTHER_MONEY_VALUE) ACTION_VALUE_B,
				0 ACTION_VALUE_A,
				OTHER_MONEY ACTION_CURRENCY,
				SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_B,
				0 ACTION_VALUE2_A,
				OTHER_MONEY2 ACTION_MONEY2,		
				SUM(OTHER_MONEY_VALUE/(PAYROLL_MONEY.RATE2/PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_B,
				0 OTHER_CASH_ACT_VALUE_A,
				--CHEQUE.CURRENCY_ID OTHER_MONEY,
				PAYROLL_OTHER_MONEY OTHER_MONEY,
				CHEQUE.CONSUMER_ID,
				CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
			FROM
				CHEQUE,
				PAYROLL,
				PAYROLL_MONEY
			WHERE
				CHEQUE_STATUS_ID IN (6) AND
				CHEQUE_PAYROLL_ID = PAYROLL.ACTION_ID AND
				CHEQUE.CONSUMER_ID IS NOT NULL AND 
				PAYROLL.PAYROLL_OTHER_MONEY = PAYROLL_MONEY.MONEY_TYPE AND
				PAYROLL.ACTION_ID = PAYROLL_MONEY.ACTION_ID
			GROUP BY
				--CHEQUE.CURRENCY_ID,
				OTHER_MONEY,
				OTHER_MONEY2,
				CHEQUE.CONSUMER_ID,
				PAYROLL_REVENUE_DATE,
				CHEQUE_DUEDATE,
				PAYROLL_RECORD_DATE,
				PAYROLL_OTHER_MONEY
		UNION ALL
			SELECT
				SUM(OTHER_MONEY_VALUE) ACTION_VALUE_B,
				0 ACTION_VALUE_A,
				OTHER_MONEY ACTION_CURRENCY,
				SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_B,
				0 ACTION_VALUE2_A,
				OTHER_MONEY2 ACTION_MONEY2,		
				SUM(OTHER_MONEY_VALUE/(VOUCHER_PAYROLL_MONEY.RATE2/VOUCHER_PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_B,
				0 OTHER_CASH_ACT_VALUE_A,
				--VOUCHER.CURRENCY_ID OTHER_MONEY,
				PAYROLL_OTHER_MONEY OTHER_MONEY,			
				VOUCHER.CONSUMER_ID,
				CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
			FROM
				VOUCHER,
				VOUCHER_PAYROLL,
				VOUCHER_PAYROLL_MONEY
			WHERE
				VOUCHER_STATUS_ID IN (6) AND
				VOUCHER_PAYROLL_ID = VOUCHER_PAYROLL.ACTION_ID AND
				VOUCHER.CONSUMER_ID IS NOT NULL AND 
				VOUCHER_PAYROLL.PAYROLL_OTHER_MONEY = VOUCHER_PAYROLL_MONEY.MONEY_TYPE AND
				VOUCHER_PAYROLL.ACTION_ID = VOUCHER_PAYROLL_MONEY.ACTION_ID
			GROUP BY 
				--VOUCHER.CURRENCY_ID,
				OTHER_MONEY,
				OTHER_MONEY2,
				VOUCHER.CONSUMER_ID,
				PAYROLL_REVENUE_DATE,
				VOUCHER_DUEDATE,
				PAYROLL_RECORD_DATE,
				PAYROLL_OTHER_MONEY

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [CHEQUE_VOUCHER_TOTAL_CONSUMER_BRANCH] AS
				SELECT
					0 ACTION_VALUE_B,
					SUM(OTHER_MONEY_VALUE) ACTION_VALUE_A,
					OTHER_MONEY ACTION_CURRENCY,
					0 ACTION_VALUE2_B,
					SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_A,
					OTHER_MONEY2 ACTION_MONEY2,		
					0 OTHER_CASH_ACT_VALUE_B,
					SUM(OTHER_MONEY_VALUE/(PAYROLL_MONEY.RATE2/PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_A,
					PAYROLL_OTHER_MONEY OTHER_MONEY,
					CHEQUE.CONSUMER_ID,
					PAYROLL.BRANCH_ID,
					CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
				FROM
					CHEQUE,
					PAYROLL,
					PAYROLL_MONEY
				WHERE
					(CHEQUE_STATUS_ID IN (1,2,13,5,10) OR (CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE > GETDATE())) AND
					CHEQUE_PAYROLL_ID = PAYROLL.ACTION_ID AND
					CHEQUE.CONSUMER_ID IS NOT NULL AND 
					PAYROLL.PAYROLL_OTHER_MONEY = PAYROLL_MONEY.MONEY_TYPE AND
					PAYROLL.ACTION_ID = PAYROLL_MONEY.ACTION_ID
				GROUP BY
					OTHER_MONEY,
					OTHER_MONEY2,
					CHEQUE.CONSUMER_ID,
					PAYROLL.BRANCH_ID,
					PAYROLL_REVENUE_DATE,
					CHEQUE_DUEDATE,
					PAYROLL_RECORD_DATE,
					PAYROLL_OTHER_MONEY
			UNION ALL
				SELECT
					0 ACTION_VALUE_B,
					SUM(OTHER_MONEY_VALUE) ACTION_VALUE_A,
					OTHER_MONEY ACTION_CURRENCY,
					0 ACTION_VALUE2_B,
					SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_A,
					OTHER_MONEY2 ACTION_MONEY2,		
					0 OTHER_CASH_ACT_VALUE_B,
					SUM(OTHER_MONEY_VALUE/(VOUCHER_PAYROLL_MONEY.RATE2/VOUCHER_PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_A,
					PAYROLL_OTHER_MONEY OTHER_MONEY,
					VOUCHER.CONSUMER_ID,
					VOUCHER_PAYROLL.BRANCH_ID,
					CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
				FROM
					VOUCHER,
					VOUCHER_PAYROLL,
					VOUCHER_PAYROLL_MONEY
				WHERE
					(VOUCHER_STATUS_ID IN (1,2,13,5,10,11) OR (VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE > GETDATE())) AND
					VOUCHER_PAYROLL_ID = VOUCHER_PAYROLL.ACTION_ID AND
					VOUCHER.CONSUMER_ID IS NOT NULL AND 
					VOUCHER_PAYROLL.PAYROLL_OTHER_MONEY = VOUCHER_PAYROLL_MONEY.MONEY_TYPE AND
					VOUCHER_PAYROLL.ACTION_ID = VOUCHER_PAYROLL_MONEY.ACTION_ID
				GROUP BY 
					OTHER_MONEY,
					OTHER_MONEY2,
					VOUCHER.CONSUMER_ID,
					VOUCHER_PAYROLL.BRANCH_ID,
					PAYROLL_REVENUE_DATE,
					VOUCHER_DUEDATE,
					PAYROLL_RECORD_DATE,
					PAYROLL_OTHER_MONEY
			UNION ALL
				SELECT
					SUM(OTHER_MONEY_VALUE) ACTION_VALUE_B,
					0 ACTION_VALUE_A,
					OTHER_MONEY ACTION_CURRENCY,
					SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_B,
					0 ACTION_VALUE2_A,
					OTHER_MONEY2 ACTION_MONEY2,		
					SUM(OTHER_MONEY_VALUE/(PAYROLL_MONEY.RATE2/PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_B,
					0 OTHER_CASH_ACT_VALUE_A,
					PAYROLL_OTHER_MONEY OTHER_MONEY,
					CHEQUE.CONSUMER_ID,
					PAYROLL.BRANCH_ID,
					CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
				FROM
					CHEQUE,
					PAYROLL,
					PAYROLL_MONEY
				WHERE
					CHEQUE_STATUS_ID IN (6) AND
					CHEQUE_PAYROLL_ID = PAYROLL.ACTION_ID AND
					CHEQUE.CONSUMER_ID IS NOT NULL AND 
					PAYROLL.PAYROLL_OTHER_MONEY = PAYROLL_MONEY.MONEY_TYPE AND
					PAYROLL.ACTION_ID = PAYROLL_MONEY.ACTION_ID
				GROUP BY
					OTHER_MONEY,
					OTHER_MONEY2,
					CHEQUE.CONSUMER_ID,
					PAYROLL.BRANCH_ID,
					PAYROLL_REVENUE_DATE,
					CHEQUE_DUEDATE,
					PAYROLL_RECORD_DATE,
					PAYROLL_OTHER_MONEY
			UNION ALL
				SELECT
					SUM(OTHER_MONEY_VALUE) ACTION_VALUE_B,
					0 ACTION_VALUE_A,
					OTHER_MONEY ACTION_CURRENCY,
					SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_B,
					0 ACTION_VALUE2_A,
					OTHER_MONEY2 ACTION_MONEY2,		
					SUM(OTHER_MONEY_VALUE/(VOUCHER_PAYROLL_MONEY.RATE2/VOUCHER_PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_B,
					0 OTHER_CASH_ACT_VALUE_A,
					PAYROLL_OTHER_MONEY OTHER_MONEY,			
					VOUCHER.CONSUMER_ID,
					VOUCHER_PAYROLL.BRANCH_ID,
					CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
				FROM
					VOUCHER,
					VOUCHER_PAYROLL,
					VOUCHER_PAYROLL_MONEY
				WHERE
					VOUCHER_STATUS_ID IN (6) AND
					VOUCHER_PAYROLL_ID = VOUCHER_PAYROLL.ACTION_ID AND
					VOUCHER.CONSUMER_ID IS NOT NULL AND 
					VOUCHER_PAYROLL.PAYROLL_OTHER_MONEY = VOUCHER_PAYROLL_MONEY.MONEY_TYPE AND
					VOUCHER_PAYROLL.ACTION_ID = VOUCHER_PAYROLL_MONEY.ACTION_ID
				GROUP BY 
					OTHER_MONEY,
					OTHER_MONEY2,
					VOUCHER.CONSUMER_ID,
					VOUCHER_PAYROLL.BRANCH_ID,
					PAYROLL_REVENUE_DATE,
					VOUCHER_DUEDATE,
					PAYROLL_RECORD_DATE,
					PAYROLL_OTHER_MONEY

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [CHEQUE_VOUCHER_TOTAL_CONSUMER_PROJECT] AS
			SELECT
				0 ACTION_VALUE_B,
				SUM(OTHER_MONEY_VALUE) ACTION_VALUE_A,
				OTHER_MONEY ACTION_CURRENCY,
				0 ACTION_VALUE2_B,
				SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_A,
				OTHER_MONEY2 ACTION_MONEY2,		
				0 OTHER_CASH_ACT_VALUE_B,
				SUM(OTHER_MONEY_VALUE/(PAYROLL_MONEY.RATE2/PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_A,
				PAYROLL.PROJECT_ID,
				PAYROLL_OTHER_MONEY OTHER_MONEY,
				CHEQUE.CONSUMER_ID,
				CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
			FROM
				CHEQUE,
				PAYROLL,
				PAYROLL_MONEY
			WHERE
				(CHEQUE_STATUS_ID IN (1,2,13,5,10) OR (CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE > GETDATE())) AND
				CHEQUE_PAYROLL_ID = PAYROLL.ACTION_ID AND
				CHEQUE.CONSUMER_ID IS NOT NULL AND 
				PAYROLL.PAYROLL_OTHER_MONEY = PAYROLL_MONEY.MONEY_TYPE AND
				PAYROLL.ACTION_ID = PAYROLL_MONEY.ACTION_ID
			GROUP BY
				PAYROLL.PROJECT_ID,
				OTHER_MONEY,
				OTHER_MONEY2,
				CHEQUE.CONSUMER_ID,
				PAYROLL_REVENUE_DATE,
				CHEQUE_DUEDATE,
				PAYROLL_RECORD_DATE,
				PAYROLL_OTHER_MONEY
		UNION ALL
			SELECT
				0 ACTION_VALUE_B,
				SUM(OTHER_MONEY_VALUE) ACTION_VALUE_A,
				OTHER_MONEY ACTION_CURRENCY,
				0 ACTION_VALUE2_B,
				SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_A,
				OTHER_MONEY2 ACTION_MONEY2,		
				0 OTHER_CASH_ACT_VALUE_B,
				SUM(OTHER_MONEY_VALUE/(VOUCHER_PAYROLL_MONEY.RATE2/VOUCHER_PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_A,
				VOUCHER_PAYROLL.PROJECT_ID,
				PAYROLL_OTHER_MONEY OTHER_MONEY,
				VOUCHER.CONSUMER_ID,
				CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
			FROM
				VOUCHER,
				VOUCHER_PAYROLL,
				VOUCHER_PAYROLL_MONEY
			WHERE
				(VOUCHER_STATUS_ID IN (1,2,13,5,10,11) OR (VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE > GETDATE())) AND
				VOUCHER_PAYROLL_ID = VOUCHER_PAYROLL.ACTION_ID AND
				VOUCHER.CONSUMER_ID IS NOT NULL AND 
				VOUCHER_PAYROLL.PAYROLL_OTHER_MONEY = VOUCHER_PAYROLL_MONEY.MONEY_TYPE AND
				VOUCHER_PAYROLL.ACTION_ID = VOUCHER_PAYROLL_MONEY.ACTION_ID
			GROUP BY 
				VOUCHER_PAYROLL.PROJECT_ID,
				OTHER_MONEY,
				OTHER_MONEY2,
				VOUCHER.CONSUMER_ID,
				PAYROLL_REVENUE_DATE,
				VOUCHER_DUEDATE,
				PAYROLL_RECORD_DATE,
				PAYROLL_OTHER_MONEY
		UNION ALL
			SELECT
				SUM(OTHER_MONEY_VALUE) ACTION_VALUE_B,
				0 ACTION_VALUE_A,
				OTHER_MONEY ACTION_CURRENCY,
				SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_B,
				0 ACTION_VALUE2_A,
				OTHER_MONEY2 ACTION_MONEY2,		
				SUM(OTHER_MONEY_VALUE/(PAYROLL_MONEY.RATE2/PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_B,
				0 OTHER_CASH_ACT_VALUE_A,
				PAYROLL.PROJECT_ID,
				PAYROLL_OTHER_MONEY OTHER_MONEY,
				CHEQUE.CONSUMER_ID,
				CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
			FROM
				CHEQUE,
				PAYROLL,
				PAYROLL_MONEY
			WHERE
				CHEQUE_STATUS_ID IN (6) AND
				CHEQUE_PAYROLL_ID = PAYROLL.ACTION_ID AND
				CHEQUE.CONSUMER_ID IS NOT NULL AND 
				PAYROLL.PAYROLL_OTHER_MONEY = PAYROLL_MONEY.MONEY_TYPE AND
				PAYROLL.ACTION_ID = PAYROLL_MONEY.ACTION_ID
			GROUP BY
				PAYROLL.PROJECT_ID,
				OTHER_MONEY,
				OTHER_MONEY2,
				CHEQUE.CONSUMER_ID,
				PAYROLL_REVENUE_DATE,
				CHEQUE_DUEDATE,
				PAYROLL_RECORD_DATE,
				PAYROLL_OTHER_MONEY
		UNION ALL
			SELECT
				SUM(OTHER_MONEY_VALUE) ACTION_VALUE_B,
				0 ACTION_VALUE_A,
				OTHER_MONEY ACTION_CURRENCY,
				SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_B,
				0 ACTION_VALUE2_A,
				OTHER_MONEY2 ACTION_MONEY2,		
				SUM(OTHER_MONEY_VALUE/(VOUCHER_PAYROLL_MONEY.RATE2/VOUCHER_PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_B,
				0 OTHER_CASH_ACT_VALUE_A,
				VOUCHER_PAYROLL.PROJECT_ID,
				PAYROLL_OTHER_MONEY OTHER_MONEY,			
				VOUCHER.CONSUMER_ID,
				CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
			FROM
				VOUCHER,
				VOUCHER_PAYROLL,
				VOUCHER_PAYROLL_MONEY
			WHERE
				VOUCHER_STATUS_ID IN (6) AND
				VOUCHER_PAYROLL_ID = VOUCHER_PAYROLL.ACTION_ID AND
				VOUCHER.CONSUMER_ID IS NOT NULL AND 
				VOUCHER_PAYROLL.PAYROLL_OTHER_MONEY = VOUCHER_PAYROLL_MONEY.MONEY_TYPE AND
				VOUCHER_PAYROLL.ACTION_ID = VOUCHER_PAYROLL_MONEY.ACTION_ID
			GROUP BY 
				VOUCHER_PAYROLL.PROJECT_ID,
				OTHER_MONEY,
				OTHER_MONEY2,
				VOUCHER.CONSUMER_ID,
				PAYROLL_REVENUE_DATE,
				VOUCHER_DUEDATE,
				PAYROLL_RECORD_DATE,
				PAYROLL_OTHER_MONEY

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [CHEQUE_VOUCHER_TOTAL_CONSUMER_PROJECT_BRANCH] AS
			SELECT
				0 ACTION_VALUE_B,
				SUM(OTHER_MONEY_VALUE) ACTION_VALUE_A,
				OTHER_MONEY ACTION_CURRENCY,
				0 ACTION_VALUE2_B,
				SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_A,
				OTHER_MONEY2 ACTION_MONEY2,		
				0 OTHER_CASH_ACT_VALUE_B,
				SUM(OTHER_MONEY_VALUE/(PAYROLL_MONEY.RATE2/PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_A,
				PAYROLL.PROJECT_ID,
				PAYROLL_OTHER_MONEY OTHER_MONEY,
				CHEQUE.CONSUMER_ID,
				PAYROLL.BRANCH_ID,
				CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
			FROM
				CHEQUE,
				PAYROLL,
				PAYROLL_MONEY
			WHERE
				(CHEQUE_STATUS_ID IN (1,2,13,5,10) OR (CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE > GETDATE())) AND
				CHEQUE_PAYROLL_ID = PAYROLL.ACTION_ID AND
				CHEQUE.CONSUMER_ID IS NOT NULL AND 
				PAYROLL.PAYROLL_OTHER_MONEY = PAYROLL_MONEY.MONEY_TYPE AND
				PAYROLL.ACTION_ID = PAYROLL_MONEY.ACTION_ID
			GROUP BY
				PAYROLL.PROJECT_ID,
				OTHER_MONEY,
				OTHER_MONEY2,
				CHEQUE.CONSUMER_ID,
				PAYROLL.BRANCH_ID,
				PAYROLL_REVENUE_DATE,
				CHEQUE_DUEDATE,
				PAYROLL_RECORD_DATE,
				PAYROLL_OTHER_MONEY
		UNION ALL
			SELECT
				0 ACTION_VALUE_B,
				SUM(OTHER_MONEY_VALUE) ACTION_VALUE_A,
				OTHER_MONEY ACTION_CURRENCY,
				0 ACTION_VALUE2_B,
				SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_A,
				OTHER_MONEY2 ACTION_MONEY2,		
				0 OTHER_CASH_ACT_VALUE_B,
				SUM(OTHER_MONEY_VALUE/(VOUCHER_PAYROLL_MONEY.RATE2/VOUCHER_PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_A,
				VOUCHER_PAYROLL.PROJECT_ID,
				PAYROLL_OTHER_MONEY OTHER_MONEY,
				VOUCHER.CONSUMER_ID,
				VOUCHER_PAYROLL.BRANCH_ID,
				CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
			FROM
				VOUCHER,
				VOUCHER_PAYROLL,
				VOUCHER_PAYROLL_MONEY
			WHERE
				(VOUCHER_STATUS_ID IN (1,2,13,5,10,11) OR (VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE > GETDATE())) AND
				VOUCHER_PAYROLL_ID = VOUCHER_PAYROLL.ACTION_ID AND
				VOUCHER.CONSUMER_ID IS NOT NULL AND 
				VOUCHER_PAYROLL.PAYROLL_OTHER_MONEY = VOUCHER_PAYROLL_MONEY.MONEY_TYPE AND
				VOUCHER_PAYROLL.ACTION_ID = VOUCHER_PAYROLL_MONEY.ACTION_ID
			GROUP BY 
				VOUCHER_PAYROLL.PROJECT_ID,
				OTHER_MONEY,
				OTHER_MONEY2,
				VOUCHER.CONSUMER_ID,
				VOUCHER_PAYROLL.BRANCH_ID,
				PAYROLL_REVENUE_DATE,
				VOUCHER_DUEDATE,
				PAYROLL_RECORD_DATE,
				PAYROLL_OTHER_MONEY
		UNION ALL
			SELECT
				SUM(OTHER_MONEY_VALUE) ACTION_VALUE_B,
				0 ACTION_VALUE_A,
				OTHER_MONEY ACTION_CURRENCY,
				SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_B,
				0 ACTION_VALUE2_A,
				OTHER_MONEY2 ACTION_MONEY2,		
				SUM(OTHER_MONEY_VALUE/(PAYROLL_MONEY.RATE2/PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_B,
				0 OTHER_CASH_ACT_VALUE_A,
				PAYROLL.PROJECT_ID,
				PAYROLL_OTHER_MONEY OTHER_MONEY,
				CHEQUE.CONSUMER_ID,
				PAYROLL.BRANCH_ID,
				CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
			FROM
				CHEQUE,
				PAYROLL,
				PAYROLL_MONEY
			WHERE
				CHEQUE_STATUS_ID IN (6) AND
				CHEQUE_PAYROLL_ID = PAYROLL.ACTION_ID AND
				CHEQUE.CONSUMER_ID IS NOT NULL AND 
				PAYROLL.PAYROLL_OTHER_MONEY = PAYROLL_MONEY.MONEY_TYPE AND
				PAYROLL.ACTION_ID = PAYROLL_MONEY.ACTION_ID
			GROUP BY
				PAYROLL.PROJECT_ID,
				OTHER_MONEY,
				OTHER_MONEY2,
				CHEQUE.CONSUMER_ID,
				PAYROLL.BRANCH_ID,
				PAYROLL_REVENUE_DATE,
				CHEQUE_DUEDATE,
				PAYROLL_RECORD_DATE,
				PAYROLL_OTHER_MONEY
		UNION ALL
			SELECT
				SUM(OTHER_MONEY_VALUE) ACTION_VALUE_B,
				0 ACTION_VALUE_A,
				OTHER_MONEY ACTION_CURRENCY,
				SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_B,
				0 ACTION_VALUE2_A,
				OTHER_MONEY2 ACTION_MONEY2,		
				SUM(OTHER_MONEY_VALUE/(VOUCHER_PAYROLL_MONEY.RATE2/VOUCHER_PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_B,
				0 OTHER_CASH_ACT_VALUE_A,
				VOUCHER_PAYROLL.PROJECT_ID,
				PAYROLL_OTHER_MONEY OTHER_MONEY,			
				VOUCHER.CONSUMER_ID,
				VOUCHER_PAYROLL.BRANCH_ID,
				CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
			FROM
				VOUCHER,
				VOUCHER_PAYROLL,
				VOUCHER_PAYROLL_MONEY
			WHERE
				VOUCHER_STATUS_ID IN (6) AND
				VOUCHER_PAYROLL_ID = VOUCHER_PAYROLL.ACTION_ID AND
				VOUCHER.CONSUMER_ID IS NOT NULL AND 
				VOUCHER_PAYROLL.PAYROLL_OTHER_MONEY = VOUCHER_PAYROLL_MONEY.MONEY_TYPE AND
				VOUCHER_PAYROLL.ACTION_ID = VOUCHER_PAYROLL_MONEY.ACTION_ID
			GROUP BY 
				VOUCHER_PAYROLL.PROJECT_ID,
				OTHER_MONEY,
				OTHER_MONEY2,
				VOUCHER.CONSUMER_ID,
				VOUCHER_PAYROLL.BRANCH_ID,
				PAYROLL_REVENUE_DATE,
				VOUCHER_DUEDATE,
				PAYROLL_RECORD_DATE,
				PAYROLL_OTHER_MONEY

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [CHEQUE_VOUCHER_TOTAL_EMPLOYEE] AS
			SELECT
				0 ACTION_VALUE_B,
				SUM(OTHER_MONEY_VALUE) ACTION_VALUE_A,
				OTHER_MONEY ACTION_CURRENCY,
				0 ACTION_VALUE2_B,
				SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_A,
				OTHER_MONEY2 ACTION_MONEY2,		
				0 OTHER_CASH_ACT_VALUE_B,
				SUM(OTHER_MONEY_VALUE/(PAYROLL_MONEY.RATE2/PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_A,
				--CHEQUE.CURRENCY_ID OTHER_MONEY,
				PAYROLL_OTHER_MONEY OTHER_MONEY,
				CHEQUE.EMPLOYEE_ID,
				CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
			FROM
				CHEQUE,
				PAYROLL,
				PAYROLL_MONEY
			WHERE
				(CHEQUE_STATUS_ID IN (1,2,13,5,10) OR (CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE > GETDATE())) AND
				CHEQUE_PAYROLL_ID = PAYROLL.ACTION_ID AND
				CHEQUE.EMPLOYEE_ID IS NOT NULL AND 
				PAYROLL.PAYROLL_OTHER_MONEY = PAYROLL_MONEY.MONEY_TYPE AND
				PAYROLL.ACTION_ID = PAYROLL_MONEY.ACTION_ID
			GROUP BY
				--CHEQUE.CURRENCY_ID,
				OTHER_MONEY,
				OTHER_MONEY2,
				CHEQUE.EMPLOYEE_ID,
				PAYROLL_REVENUE_DATE,
				CHEQUE_DUEDATE,
				PAYROLL_RECORD_DATE,
				PAYROLL_OTHER_MONEY
		UNION ALL
			SELECT
				0 ACTION_VALUE_B,
				SUM(OTHER_MONEY_VALUE) ACTION_VALUE_A,
				OTHER_MONEY ACTION_CURRENCY,
				0 ACTION_VALUE2_B,
				SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_A,
				OTHER_MONEY2 ACTION_MONEY2,		
				0 OTHER_CASH_ACT_VALUE_B,
				SUM(OTHER_MONEY_VALUE/(VOUCHER_PAYROLL_MONEY.RATE2/VOUCHER_PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_A,
				--VOUCHER.CURRENCY_ID OTHER_MONEY,
				PAYROLL_OTHER_MONEY OTHER_MONEY,
				VOUCHER.EMPLOYEE_ID,
				CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
			FROM
				VOUCHER,
				VOUCHER_PAYROLL,
				VOUCHER_PAYROLL_MONEY
			WHERE
				(VOUCHER_STATUS_ID IN (1,2,13,5,10,11) OR (VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE > GETDATE())) AND
				VOUCHER_PAYROLL_ID = VOUCHER_PAYROLL.ACTION_ID AND
				VOUCHER.EMPLOYEE_ID IS NOT NULL AND 
				VOUCHER_PAYROLL.PAYROLL_OTHER_MONEY = VOUCHER_PAYROLL_MONEY.MONEY_TYPE AND
				VOUCHER_PAYROLL.ACTION_ID = VOUCHER_PAYROLL_MONEY.ACTION_ID
			GROUP BY 
				--VOUCHER.CURRENCY_ID,
				OTHER_MONEY,
				OTHER_MONEY2,
				VOUCHER.EMPLOYEE_ID,
				PAYROLL_REVENUE_DATE,
				VOUCHER_DUEDATE,
				PAYROLL_RECORD_DATE,
				PAYROLL_OTHER_MONEY
		UNION ALL
			SELECT
				SUM(OTHER_MONEY_VALUE) ACTION_VALUE_B,
				0 ACTION_VALUE_A,
				OTHER_MONEY ACTION_CURRENCY,
				SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_B,
				0 ACTION_VALUE2_A,
				OTHER_MONEY2 ACTION_MONEY2,		
				SUM(OTHER_MONEY_VALUE/(PAYROLL_MONEY.RATE2/PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_B,
				0 OTHER_CASH_ACT_VALUE_A,
				--CHEQUE.CURRENCY_ID OTHER_MONEY,
				PAYROLL_OTHER_MONEY OTHER_MONEY,
				CHEQUE.EMPLOYEE_ID,
				CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
			FROM
				CHEQUE,
				PAYROLL,
				PAYROLL_MONEY
			WHERE
				CHEQUE_STATUS_ID IN (6) AND
				CHEQUE_PAYROLL_ID = PAYROLL.ACTION_ID AND
				CHEQUE.EMPLOYEE_ID IS NOT NULL AND 
				PAYROLL.PAYROLL_OTHER_MONEY = PAYROLL_MONEY.MONEY_TYPE AND
				PAYROLL.ACTION_ID = PAYROLL_MONEY.ACTION_ID
			GROUP BY
				--CHEQUE.CURRENCY_ID,
				OTHER_MONEY,
				OTHER_MONEY2,
				CHEQUE.EMPLOYEE_ID,
				PAYROLL_REVENUE_DATE,
				CHEQUE_DUEDATE,
				PAYROLL_RECORD_DATE,
				PAYROLL_OTHER_MONEY
		UNION ALL
			SELECT
				SUM(OTHER_MONEY_VALUE) ACTION_VALUE_B,
				0 ACTION_VALUE_A,
				OTHER_MONEY ACTION_CURRENCY,
				SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_B,
				0 ACTION_VALUE2_A,
				OTHER_MONEY2 ACTION_MONEY2,		
				SUM(OTHER_MONEY_VALUE/(VOUCHER_PAYROLL_MONEY.RATE2/VOUCHER_PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_B,
				0 OTHER_CASH_ACT_VALUE_A,
				--VOUCHER.CURRENCY_ID OTHER_MONEY,
				PAYROLL_OTHER_MONEY OTHER_MONEY,			
				VOUCHER.EMPLOYEE_ID,
				CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
			FROM
				VOUCHER,
				VOUCHER_PAYROLL,
				VOUCHER_PAYROLL_MONEY
			WHERE
				VOUCHER_STATUS_ID IN (6) AND
				VOUCHER_PAYROLL_ID = VOUCHER_PAYROLL.ACTION_ID AND
				VOUCHER.EMPLOYEE_ID IS NOT NULL AND 
				VOUCHER_PAYROLL.PAYROLL_OTHER_MONEY = VOUCHER_PAYROLL_MONEY.MONEY_TYPE AND
				VOUCHER_PAYROLL.ACTION_ID = VOUCHER_PAYROLL_MONEY.ACTION_ID
			GROUP BY 
				--VOUCHER.CURRENCY_ID,
				OTHER_MONEY,
				OTHER_MONEY2,
				VOUCHER.EMPLOYEE_ID,
				PAYROLL_REVENUE_DATE,
				VOUCHER_DUEDATE,
				PAYROLL_RECORD_DATE,
				PAYROLL_OTHER_MONEY

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [CHEQUE_VOUCHER_TOTAL_EMPLOYEE_BRANCH] AS
		SELECT
			0 ACTION_VALUE_B,
			SUM(OTHER_MONEY_VALUE) ACTION_VALUE_A,
			OTHER_MONEY ACTION_CURRENCY,
			0 ACTION_VALUE2_B,
			SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_A,
			OTHER_MONEY2 ACTION_MONEY2,		
			0 OTHER_CASH_ACT_VALUE_B,
			SUM(OTHER_MONEY_VALUE/(PAYROLL_MONEY.RATE2/PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_A,
			PAYROLL_OTHER_MONEY OTHER_MONEY,
			CHEQUE.EMPLOYEE_ID,
			PAYROLL.BRANCH_ID,
			CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
		FROM
			CHEQUE,
			PAYROLL,
			PAYROLL_MONEY
		WHERE
			(CHEQUE_STATUS_ID IN (1,2,13,5,10) OR (CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE > GETDATE())) AND
			CHEQUE_PAYROLL_ID = PAYROLL.ACTION_ID AND
			CHEQUE.EMPLOYEE_ID IS NOT NULL AND 
			PAYROLL.PAYROLL_OTHER_MONEY = PAYROLL_MONEY.MONEY_TYPE AND
			PAYROLL.ACTION_ID = PAYROLL_MONEY.ACTION_ID
		GROUP BY
			OTHER_MONEY,
			OTHER_MONEY2,
			CHEQUE.EMPLOYEE_ID,
			PAYROLL.BRANCH_ID,
			PAYROLL_REVENUE_DATE,
			CHEQUE_DUEDATE,
			PAYROLL_RECORD_DATE,
			PAYROLL_OTHER_MONEY
	UNION ALL
		SELECT
			0 ACTION_VALUE_B,
			SUM(OTHER_MONEY_VALUE) ACTION_VALUE_A,
			OTHER_MONEY ACTION_CURRENCY,
			0 ACTION_VALUE2_B,
			SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_A,
			OTHER_MONEY2 ACTION_MONEY2,		
			0 OTHER_CASH_ACT_VALUE_B,
			SUM(OTHER_MONEY_VALUE/(VOUCHER_PAYROLL_MONEY.RATE2/VOUCHER_PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_A,
			PAYROLL_OTHER_MONEY OTHER_MONEY,
			VOUCHER.EMPLOYEE_ID,
			VOUCHER_PAYROLL.BRANCH_ID,
			CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
		FROM
			VOUCHER,
			VOUCHER_PAYROLL,
			VOUCHER_PAYROLL_MONEY
		WHERE
			(VOUCHER_STATUS_ID IN (1,2,13,5,10,11) OR (VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE > GETDATE())) AND
			VOUCHER_PAYROLL_ID = VOUCHER_PAYROLL.ACTION_ID AND
			VOUCHER.EMPLOYEE_ID IS NOT NULL AND 
			VOUCHER_PAYROLL.PAYROLL_OTHER_MONEY = VOUCHER_PAYROLL_MONEY.MONEY_TYPE AND
			VOUCHER_PAYROLL.ACTION_ID = VOUCHER_PAYROLL_MONEY.ACTION_ID
		GROUP BY 
			OTHER_MONEY,
			OTHER_MONEY2,
			VOUCHER.EMPLOYEE_ID,
			VOUCHER_PAYROLL.BRANCH_ID,
			PAYROLL_REVENUE_DATE,
			VOUCHER_DUEDATE,
			PAYROLL_RECORD_DATE,
			PAYROLL_OTHER_MONEY
	UNION ALL
		SELECT
			SUM(OTHER_MONEY_VALUE) ACTION_VALUE_B,
			0 ACTION_VALUE_A,
			OTHER_MONEY ACTION_CURRENCY,
			SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_B,
			0 ACTION_VALUE2_A,
			OTHER_MONEY2 ACTION_MONEY2,		
			SUM(OTHER_MONEY_VALUE/(PAYROLL_MONEY.RATE2/PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_B,
			0 OTHER_CASH_ACT_VALUE_A,
			PAYROLL_OTHER_MONEY OTHER_MONEY,
			CHEQUE.EMPLOYEE_ID,
			PAYROLL.BRANCH_ID,
			CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
		FROM
			CHEQUE,
			PAYROLL,
			PAYROLL_MONEY
		WHERE
			CHEQUE_STATUS_ID IN (6) AND
			CHEQUE_PAYROLL_ID = PAYROLL.ACTION_ID AND
			CHEQUE.EMPLOYEE_ID IS NOT NULL AND 
			PAYROLL.PAYROLL_OTHER_MONEY = PAYROLL_MONEY.MONEY_TYPE AND
			PAYROLL.ACTION_ID = PAYROLL_MONEY.ACTION_ID
		GROUP BY
			OTHER_MONEY,
			OTHER_MONEY2,
			CHEQUE.EMPLOYEE_ID,
			PAYROLL.BRANCH_ID,
			PAYROLL_REVENUE_DATE,
			CHEQUE_DUEDATE,
			PAYROLL_RECORD_DATE,
			PAYROLL_OTHER_MONEY
	UNION ALL
		SELECT
			SUM(OTHER_MONEY_VALUE) ACTION_VALUE_B,
			0 ACTION_VALUE_A,
			OTHER_MONEY ACTION_CURRENCY,
			SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_B,
			0 ACTION_VALUE2_A,
			OTHER_MONEY2 ACTION_MONEY2,		
			SUM(OTHER_MONEY_VALUE/(VOUCHER_PAYROLL_MONEY.RATE2/VOUCHER_PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_B,
			0 OTHER_CASH_ACT_VALUE_A,
			PAYROLL_OTHER_MONEY OTHER_MONEY,			
			VOUCHER.EMPLOYEE_ID,
			VOUCHER_PAYROLL.BRANCH_ID,
			CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
		FROM
			VOUCHER,
			VOUCHER_PAYROLL,
			VOUCHER_PAYROLL_MONEY
		WHERE
			VOUCHER_STATUS_ID IN (6) AND
			VOUCHER_PAYROLL_ID = VOUCHER_PAYROLL.ACTION_ID AND
			VOUCHER.EMPLOYEE_ID IS NOT NULL AND 
			VOUCHER_PAYROLL.PAYROLL_OTHER_MONEY = VOUCHER_PAYROLL_MONEY.MONEY_TYPE AND
			VOUCHER_PAYROLL.ACTION_ID = VOUCHER_PAYROLL_MONEY.ACTION_ID
		GROUP BY 
			OTHER_MONEY,
			OTHER_MONEY2,
			VOUCHER.EMPLOYEE_ID,
			VOUCHER_PAYROLL.BRANCH_ID,
			PAYROLL_REVENUE_DATE,
			VOUCHER_DUEDATE,
			PAYROLL_RECORD_DATE,
			PAYROLL_OTHER_MONEY

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [CHEQUE_VOUCHER_TOTAL_EMPLOYEE_PROJECT] AS
			SELECT
				0 ACTION_VALUE_B,
				SUM(OTHER_MONEY_VALUE) ACTION_VALUE_A,
				OTHER_MONEY ACTION_CURRENCY,
				0 ACTION_VALUE2_B,
				SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_A,
				OTHER_MONEY2 ACTION_MONEY2,		
				0 OTHER_CASH_ACT_VALUE_B,
				SUM(OTHER_MONEY_VALUE/(PAYROLL_MONEY.RATE2/PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_A,
				PAYROLL.PROJECT_ID,
				PAYROLL_OTHER_MONEY OTHER_MONEY,
				CHEQUE.EMPLOYEE_ID,
				CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
			FROM
				CHEQUE,
				PAYROLL,
				PAYROLL_MONEY
			WHERE
				(CHEQUE_STATUS_ID IN (1,2,13,5,10) OR (CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE > GETDATE())) AND
				CHEQUE_PAYROLL_ID = PAYROLL.ACTION_ID AND
				CHEQUE.EMPLOYEE_ID IS NOT NULL AND 
				PAYROLL.PAYROLL_OTHER_MONEY = PAYROLL_MONEY.MONEY_TYPE AND
				PAYROLL.ACTION_ID = PAYROLL_MONEY.ACTION_ID
			GROUP BY
				PAYROLL.PROJECT_ID,
				OTHER_MONEY,
				OTHER_MONEY2,
				CHEQUE.EMPLOYEE_ID,
				PAYROLL_REVENUE_DATE,
				CHEQUE_DUEDATE,
				PAYROLL_RECORD_DATE,
				PAYROLL_OTHER_MONEY
		UNION ALL
			SELECT
				0 ACTION_VALUE_B,
				SUM(OTHER_MONEY_VALUE) ACTION_VALUE_A,
				OTHER_MONEY ACTION_CURRENCY,
				0 ACTION_VALUE2_B,
				SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_A,
				OTHER_MONEY2 ACTION_MONEY2,		
				0 OTHER_CASH_ACT_VALUE_B,
				SUM(OTHER_MONEY_VALUE/(VOUCHER_PAYROLL_MONEY.RATE2/VOUCHER_PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_A,
				VOUCHER_PAYROLL.PROJECT_ID,
				PAYROLL_OTHER_MONEY OTHER_MONEY,
				VOUCHER.EMPLOYEE_ID,
				CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
			FROM
				VOUCHER,
				VOUCHER_PAYROLL,
				VOUCHER_PAYROLL_MONEY
			WHERE
				(VOUCHER_STATUS_ID IN (1,2,13,5,10,11) OR (VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE > GETDATE())) AND
				VOUCHER_PAYROLL_ID = VOUCHER_PAYROLL.ACTION_ID AND
				VOUCHER.EMPLOYEE_ID IS NOT NULL AND 
				VOUCHER_PAYROLL.PAYROLL_OTHER_MONEY = VOUCHER_PAYROLL_MONEY.MONEY_TYPE AND
				VOUCHER_PAYROLL.ACTION_ID = VOUCHER_PAYROLL_MONEY.ACTION_ID
			GROUP BY 
				VOUCHER_PAYROLL.PROJECT_ID,
				OTHER_MONEY,
				OTHER_MONEY2,
				VOUCHER.EMPLOYEE_ID,
				PAYROLL_REVENUE_DATE,
				VOUCHER_DUEDATE,
				PAYROLL_RECORD_DATE,
				PAYROLL_OTHER_MONEY
		UNION ALL
			SELECT
				SUM(OTHER_MONEY_VALUE) ACTION_VALUE_B,
				0 ACTION_VALUE_A,
				OTHER_MONEY ACTION_CURRENCY,
				SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_B,
				0 ACTION_VALUE2_A,
				OTHER_MONEY2 ACTION_MONEY2,		
				SUM(OTHER_MONEY_VALUE/(PAYROLL_MONEY.RATE2/PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_B,
				0 OTHER_CASH_ACT_VALUE_A,
				PAYROLL.PROJECT_ID,
				PAYROLL_OTHER_MONEY OTHER_MONEY,
				CHEQUE.EMPLOYEE_ID,
				CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
			FROM
				CHEQUE,
				PAYROLL,
				PAYROLL_MONEY
			WHERE
				CHEQUE_STATUS_ID IN (6) AND
				CHEQUE_PAYROLL_ID = PAYROLL.ACTION_ID AND
				CHEQUE.EMPLOYEE_ID IS NOT NULL AND 
				PAYROLL.PAYROLL_OTHER_MONEY = PAYROLL_MONEY.MONEY_TYPE AND
				PAYROLL.ACTION_ID = PAYROLL_MONEY.ACTION_ID
			GROUP BY
				PAYROLL.PROJECT_ID,
				OTHER_MONEY,
				OTHER_MONEY2,
				CHEQUE.EMPLOYEE_ID,
				PAYROLL_REVENUE_DATE,
				CHEQUE_DUEDATE,
				PAYROLL_RECORD_DATE,
				PAYROLL_OTHER_MONEY
		UNION ALL
			SELECT
				SUM(OTHER_MONEY_VALUE) ACTION_VALUE_B,
				0 ACTION_VALUE_A,
				OTHER_MONEY ACTION_CURRENCY,
				SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_B,
				0 ACTION_VALUE2_A,
				OTHER_MONEY2 ACTION_MONEY2,		
				SUM(OTHER_MONEY_VALUE/(VOUCHER_PAYROLL_MONEY.RATE2/VOUCHER_PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_B,
				0 OTHER_CASH_ACT_VALUE_A,
				VOUCHER_PAYROLL.PROJECT_ID,
				PAYROLL_OTHER_MONEY OTHER_MONEY,			
				VOUCHER.EMPLOYEE_ID,
				CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
			FROM
				VOUCHER,
				VOUCHER_PAYROLL,
				VOUCHER_PAYROLL_MONEY
			WHERE
				VOUCHER_STATUS_ID IN (6) AND
				VOUCHER_PAYROLL_ID = VOUCHER_PAYROLL.ACTION_ID AND
				VOUCHER.EMPLOYEE_ID IS NOT NULL AND 
				VOUCHER_PAYROLL.PAYROLL_OTHER_MONEY = VOUCHER_PAYROLL_MONEY.MONEY_TYPE AND
				VOUCHER_PAYROLL.ACTION_ID = VOUCHER_PAYROLL_MONEY.ACTION_ID
			GROUP BY 
				VOUCHER_PAYROLL.PROJECT_ID,
				OTHER_MONEY,
				OTHER_MONEY2,
				VOUCHER.EMPLOYEE_ID,
				PAYROLL_REVENUE_DATE,
				VOUCHER_DUEDATE,
				PAYROLL_RECORD_DATE,
				PAYROLL_OTHER_MONEY

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [CHEQUE_VOUCHER_TOTAL_EMPLOYEE_PROJECT_BRANCH] AS
			SELECT
				0 ACTION_VALUE_B,
				SUM(OTHER_MONEY_VALUE) ACTION_VALUE_A,
				OTHER_MONEY ACTION_CURRENCY,
				0 ACTION_VALUE2_B,
				SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_A,
				OTHER_MONEY2 ACTION_MONEY2,		
				0 OTHER_CASH_ACT_VALUE_B,
				SUM(OTHER_MONEY_VALUE/(PAYROLL_MONEY.RATE2/PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_A,
				PAYROLL.PROJECT_ID,
				PAYROLL_OTHER_MONEY OTHER_MONEY,
				CHEQUE.EMPLOYEE_ID,
				PAYROLL.BRANCH_ID,
				CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
			FROM
				CHEQUE,
				PAYROLL,
				PAYROLL_MONEY
			WHERE
				(CHEQUE_STATUS_ID IN (1,2,13,5,10) OR (CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE > GETDATE())) AND
				CHEQUE_PAYROLL_ID = PAYROLL.ACTION_ID AND
				CHEQUE.EMPLOYEE_ID IS NOT NULL AND 
				PAYROLL.PAYROLL_OTHER_MONEY = PAYROLL_MONEY.MONEY_TYPE AND
				PAYROLL.ACTION_ID = PAYROLL_MONEY.ACTION_ID
			GROUP BY
				PAYROLL.PROJECT_ID,
				OTHER_MONEY,
				OTHER_MONEY2,
				CHEQUE.EMPLOYEE_ID,
				PAYROLL.BRANCH_ID,
				PAYROLL_REVENUE_DATE,
				CHEQUE_DUEDATE,
				PAYROLL_RECORD_DATE,
				PAYROLL_OTHER_MONEY
		UNION ALL
			SELECT
				0 ACTION_VALUE_B,
				SUM(OTHER_MONEY_VALUE) ACTION_VALUE_A,
				OTHER_MONEY ACTION_CURRENCY,
				0 ACTION_VALUE2_B,
				SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_A,
				OTHER_MONEY2 ACTION_MONEY2,		
				0 OTHER_CASH_ACT_VALUE_B,
				SUM(OTHER_MONEY_VALUE/(VOUCHER_PAYROLL_MONEY.RATE2/VOUCHER_PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_A,
				VOUCHER_PAYROLL.PROJECT_ID,
				PAYROLL_OTHER_MONEY OTHER_MONEY,
				VOUCHER.EMPLOYEE_ID,
				VOUCHER_PAYROLL.BRANCH_ID,
				CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
			FROM
				VOUCHER,
				VOUCHER_PAYROLL,
				VOUCHER_PAYROLL_MONEY
			WHERE
				(VOUCHER_STATUS_ID IN (1,2,13,5,10,11) OR (VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE > GETDATE())) AND
				VOUCHER_PAYROLL_ID = VOUCHER_PAYROLL.ACTION_ID AND
				VOUCHER.EMPLOYEE_ID IS NOT NULL AND 
				VOUCHER_PAYROLL.PAYROLL_OTHER_MONEY = VOUCHER_PAYROLL_MONEY.MONEY_TYPE AND
				VOUCHER_PAYROLL.ACTION_ID = VOUCHER_PAYROLL_MONEY.ACTION_ID
			GROUP BY 
				VOUCHER_PAYROLL.PROJECT_ID,
				OTHER_MONEY,
				OTHER_MONEY2,
				VOUCHER.EMPLOYEE_ID,
				VOUCHER_PAYROLL.BRANCH_ID,
				PAYROLL_REVENUE_DATE,
				VOUCHER_DUEDATE,
				PAYROLL_RECORD_DATE,
				PAYROLL_OTHER_MONEY
		UNION ALL
			SELECT
				SUM(OTHER_MONEY_VALUE) ACTION_VALUE_B,
				0 ACTION_VALUE_A,
				OTHER_MONEY ACTION_CURRENCY,
				SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_B,
				0 ACTION_VALUE2_A,
				OTHER_MONEY2 ACTION_MONEY2,		
				SUM(OTHER_MONEY_VALUE/(PAYROLL_MONEY.RATE2/PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_B,
				0 OTHER_CASH_ACT_VALUE_A,
				PAYROLL.PROJECT_ID,
				PAYROLL_OTHER_MONEY OTHER_MONEY,
				CHEQUE.EMPLOYEE_ID,
				PAYROLL.BRANCH_ID,
				CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
			FROM
				CHEQUE,
				PAYROLL,
				PAYROLL_MONEY
			WHERE
				CHEQUE_STATUS_ID IN (6) AND
				CHEQUE_PAYROLL_ID = PAYROLL.ACTION_ID AND
				CHEQUE.EMPLOYEE_ID IS NOT NULL AND 
				PAYROLL.PAYROLL_OTHER_MONEY = PAYROLL_MONEY.MONEY_TYPE AND
				PAYROLL.ACTION_ID = PAYROLL_MONEY.ACTION_ID
			GROUP BY
				PAYROLL.PROJECT_ID,
				OTHER_MONEY,
				OTHER_MONEY2,
				CHEQUE.EMPLOYEE_ID,
				PAYROLL.BRANCH_ID,
				PAYROLL_REVENUE_DATE,
				CHEQUE_DUEDATE,
				PAYROLL_RECORD_DATE,
				PAYROLL_OTHER_MONEY
		UNION ALL
			SELECT
				SUM(OTHER_MONEY_VALUE) ACTION_VALUE_B,
				0 ACTION_VALUE_A,
				OTHER_MONEY ACTION_CURRENCY,
				SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_B,
				0 ACTION_VALUE2_A,
				OTHER_MONEY2 ACTION_MONEY2,		
				SUM(OTHER_MONEY_VALUE/(VOUCHER_PAYROLL_MONEY.RATE2/VOUCHER_PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_B,
				0 OTHER_CASH_ACT_VALUE_A,
				VOUCHER_PAYROLL.PROJECT_ID,
				PAYROLL_OTHER_MONEY OTHER_MONEY,			
				VOUCHER.EMPLOYEE_ID,
				VOUCHER_PAYROLL.BRANCH_ID,
				CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
			FROM
				VOUCHER,
				VOUCHER_PAYROLL,
				VOUCHER_PAYROLL_MONEY
			WHERE
				VOUCHER_STATUS_ID IN (6) AND
				VOUCHER_PAYROLL_ID = VOUCHER_PAYROLL.ACTION_ID AND
				VOUCHER.EMPLOYEE_ID IS NOT NULL AND 
				VOUCHER_PAYROLL.PAYROLL_OTHER_MONEY = VOUCHER_PAYROLL_MONEY.MONEY_TYPE AND
				VOUCHER_PAYROLL.ACTION_ID = VOUCHER_PAYROLL_MONEY.ACTION_ID
			GROUP BY 
				VOUCHER_PAYROLL.PROJECT_ID,
				OTHER_MONEY,
				OTHER_MONEY2,
				VOUCHER.EMPLOYEE_ID,
				VOUCHER_PAYROLL.BRANCH_ID,
				PAYROLL_REVENUE_DATE,
				VOUCHER_DUEDATE,
				PAYROLL_RECORD_DATE,
				PAYROLL_OTHER_MONEY

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [CHEQUE_VOUCHER_TOTAL_PROJECT] AS
			SELECT
				0 ACTION_VALUE_B,
				SUM(OTHER_MONEY_VALUE) ACTION_VALUE_A,
				OTHER_MONEY ACTION_CURRENCY,
				0 ACTION_VALUE2_B,
				SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_A,
				OTHER_MONEY2 ACTION_MONEY2,		
				0 OTHER_CASH_ACT_VALUE_B,
				SUM(OTHER_MONEY_VALUE/(PAYROLL_MONEY.RATE2/PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_A,
				PAYROLL.PROJECT_ID,
				PAYROLL_OTHER_MONEY OTHER_MONEY,
				CHEQUE.COMPANY_ID,
				CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
			FROM
				CHEQUE,
				PAYROLL,
				PAYROLL_MONEY
			WHERE
				(CHEQUE_STATUS_ID IN (1,2,13,5,10) OR (CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE > GETDATE())) AND
				CHEQUE_PAYROLL_ID = PAYROLL.ACTION_ID AND
				CHEQUE.COMPANY_ID IS NOT NULL AND 
				PAYROLL.PAYROLL_OTHER_MONEY = PAYROLL_MONEY.MONEY_TYPE AND
				PAYROLL.ACTION_ID = PAYROLL_MONEY.ACTION_ID
			GROUP BY
				PAYROLL.PROJECT_ID,
				OTHER_MONEY,
				OTHER_MONEY2,
				CHEQUE.COMPANY_ID,
				PAYROLL_REVENUE_DATE,
				CHEQUE_DUEDATE,
				PAYROLL_RECORD_DATE,
				PAYROLL_OTHER_MONEY
		UNION ALL
			SELECT
				0 ACTION_VALUE_B,
				SUM(OTHER_MONEY_VALUE) ACTION_VALUE_A,
				OTHER_MONEY ACTION_CURRENCY,
				0 ACTION_VALUE2_B,
				SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_A,
				OTHER_MONEY2 ACTION_MONEY2,		
				0 OTHER_CASH_ACT_VALUE_B,
				SUM(OTHER_MONEY_VALUE/(VOUCHER_PAYROLL_MONEY.RATE2/VOUCHER_PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_A,
				VOUCHER_PAYROLL.PROJECT_ID,
				PAYROLL_OTHER_MONEY OTHER_MONEY,
				VOUCHER.COMPANY_ID,
				CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
			FROM
				VOUCHER,
				VOUCHER_PAYROLL,
				VOUCHER_PAYROLL_MONEY
			WHERE
				(VOUCHER_STATUS_ID IN (1,2,13,5,10,11) OR (VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE > GETDATE())) AND
				VOUCHER_PAYROLL_ID = VOUCHER_PAYROLL.ACTION_ID AND
				VOUCHER.COMPANY_ID IS NOT NULL AND 
				VOUCHER_PAYROLL.PAYROLL_OTHER_MONEY = VOUCHER_PAYROLL_MONEY.MONEY_TYPE AND
				VOUCHER_PAYROLL.ACTION_ID = VOUCHER_PAYROLL_MONEY.ACTION_ID
			GROUP BY 
				VOUCHER_PAYROLL.PROJECT_ID,
				OTHER_MONEY,
				OTHER_MONEY2,
				VOUCHER.COMPANY_ID,
				PAYROLL_REVENUE_DATE,
				VOUCHER_DUEDATE,
				PAYROLL_RECORD_DATE,
				PAYROLL_OTHER_MONEY
		UNION ALL
			SELECT
				SUM(OTHER_MONEY_VALUE) ACTION_VALUE_B,
				0 ACTION_VALUE_A,
				OTHER_MONEY ACTION_CURRENCY,
				SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_B,
				0 ACTION_VALUE2_A,
				OTHER_MONEY2 ACTION_MONEY2,		
				SUM(OTHER_MONEY_VALUE/(PAYROLL_MONEY.RATE2/PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_B,
				0 OTHER_CASH_ACT_VALUE_A,
				PAYROLL.PROJECT_ID,
				PAYROLL_OTHER_MONEY OTHER_MONEY,
				CHEQUE.COMPANY_ID,
				CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
			FROM
				CHEQUE,
				PAYROLL,
				PAYROLL_MONEY
			WHERE
				CHEQUE_STATUS_ID IN (6) AND
				CHEQUE_PAYROLL_ID = PAYROLL.ACTION_ID AND
				CHEQUE.COMPANY_ID IS NOT NULL AND 
				PAYROLL.PAYROLL_OTHER_MONEY = PAYROLL_MONEY.MONEY_TYPE AND
				PAYROLL.ACTION_ID = PAYROLL_MONEY.ACTION_ID
			GROUP BY
				PAYROLL.PROJECT_ID,
				OTHER_MONEY,
				OTHER_MONEY2,
				CHEQUE.COMPANY_ID,
				PAYROLL_REVENUE_DATE,
				CHEQUE_DUEDATE,
				PAYROLL_RECORD_DATE,
				PAYROLL_OTHER_MONEY
		UNION ALL
			SELECT
				SUM(OTHER_MONEY_VALUE) ACTION_VALUE_B,
				0 ACTION_VALUE_A,
				OTHER_MONEY ACTION_CURRENCY,
				SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_B,
				0 ACTION_VALUE2_A,
				OTHER_MONEY2 ACTION_MONEY2,		
				SUM(OTHER_MONEY_VALUE/(VOUCHER_PAYROLL_MONEY.RATE2/VOUCHER_PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_B,
				0 OTHER_CASH_ACT_VALUE_A,
				VOUCHER_PAYROLL.PROJECT_ID,
				PAYROLL_OTHER_MONEY OTHER_MONEY,			
				VOUCHER.COMPANY_ID,
				CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
			FROM
				VOUCHER,
				VOUCHER_PAYROLL,
				VOUCHER_PAYROLL_MONEY
			WHERE
				VOUCHER_STATUS_ID IN (6) AND
				VOUCHER_PAYROLL_ID = VOUCHER_PAYROLL.ACTION_ID AND
				VOUCHER.COMPANY_ID IS NOT NULL AND 
				VOUCHER_PAYROLL.PAYROLL_OTHER_MONEY = VOUCHER_PAYROLL_MONEY.MONEY_TYPE AND
				VOUCHER_PAYROLL.ACTION_ID = VOUCHER_PAYROLL_MONEY.ACTION_ID
			GROUP BY 
				VOUCHER_PAYROLL.PROJECT_ID,
				OTHER_MONEY,
				OTHER_MONEY2,
				VOUCHER.COMPANY_ID,
				PAYROLL_REVENUE_DATE,
				VOUCHER_DUEDATE,
				PAYROLL_RECORD_DATE,
				PAYROLL_OTHER_MONEY

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [CHEQUE_VOUCHER_TOTAL_PROJECT_BRANCH] AS
			SELECT
				0 ACTION_VALUE_B,
				SUM(OTHER_MONEY_VALUE) ACTION_VALUE_A,
				OTHER_MONEY ACTION_CURRENCY,
				0 ACTION_VALUE2_B,
				SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_A,
				OTHER_MONEY2 ACTION_MONEY2,		
				0 OTHER_CASH_ACT_VALUE_B,
				SUM(OTHER_MONEY_VALUE/(PAYROLL_MONEY.RATE2/PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_A,
				PAYROLL.PROJECT_ID,
				PAYROLL_OTHER_MONEY OTHER_MONEY,
				CHEQUE.COMPANY_ID,
				PAYROLL.BRANCH_ID,
				CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
			FROM
				CHEQUE,
				PAYROLL,
				PAYROLL_MONEY
			WHERE
				(CHEQUE_STATUS_ID IN (1,2,13,5,10) OR (CHEQUE_STATUS_ID = 4 AND CHEQUE_DUEDATE > GETDATE())) AND
				CHEQUE_PAYROLL_ID = PAYROLL.ACTION_ID AND
				CHEQUE.COMPANY_ID IS NOT NULL AND 
				PAYROLL.PAYROLL_OTHER_MONEY = PAYROLL_MONEY.MONEY_TYPE AND
				PAYROLL.ACTION_ID = PAYROLL_MONEY.ACTION_ID
			GROUP BY
				PAYROLL.PROJECT_ID,
				OTHER_MONEY,
				OTHER_MONEY2,
				CHEQUE.COMPANY_ID,
				PAYROLL.BRANCH_ID,
				PAYROLL_REVENUE_DATE,
				CHEQUE_DUEDATE,
				PAYROLL_RECORD_DATE,
				PAYROLL_OTHER_MONEY
		UNION ALL
			SELECT
				0 ACTION_VALUE_B,
				SUM(OTHER_MONEY_VALUE) ACTION_VALUE_A,
				OTHER_MONEY ACTION_CURRENCY,
				0 ACTION_VALUE2_B,
				SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_A,
				OTHER_MONEY2 ACTION_MONEY2,		
				0 OTHER_CASH_ACT_VALUE_B,
				SUM(OTHER_MONEY_VALUE/(VOUCHER_PAYROLL_MONEY.RATE2/VOUCHER_PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_A,
				VOUCHER_PAYROLL.PROJECT_ID,
				PAYROLL_OTHER_MONEY OTHER_MONEY,
				VOUCHER.COMPANY_ID,
				VOUCHER_PAYROLL.BRANCH_ID,
				CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
			FROM
				VOUCHER,
				VOUCHER_PAYROLL,
				VOUCHER_PAYROLL_MONEY
			WHERE
				(VOUCHER_STATUS_ID IN (1,2,13,5,10,11) OR (VOUCHER_STATUS_ID = 4 AND VOUCHER_DUEDATE > GETDATE())) AND
				VOUCHER_PAYROLL_ID = VOUCHER_PAYROLL.ACTION_ID AND
				VOUCHER.COMPANY_ID IS NOT NULL AND 
				VOUCHER_PAYROLL.PAYROLL_OTHER_MONEY = VOUCHER_PAYROLL_MONEY.MONEY_TYPE AND
				VOUCHER_PAYROLL.ACTION_ID = VOUCHER_PAYROLL_MONEY.ACTION_ID
			GROUP BY 
				VOUCHER_PAYROLL.PROJECT_ID,
				OTHER_MONEY,
				OTHER_MONEY2,
				VOUCHER.COMPANY_ID,
				VOUCHER_PAYROLL.BRANCH_ID,
				PAYROLL_REVENUE_DATE,
				VOUCHER_DUEDATE,
				PAYROLL_RECORD_DATE,
				PAYROLL_OTHER_MONEY
		UNION ALL
			SELECT
				SUM(OTHER_MONEY_VALUE) ACTION_VALUE_B,
				0 ACTION_VALUE_A,
				OTHER_MONEY ACTION_CURRENCY,
				SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_B,
				0 ACTION_VALUE2_A,
				OTHER_MONEY2 ACTION_MONEY2,		
				SUM(OTHER_MONEY_VALUE/(PAYROLL_MONEY.RATE2/PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_B,
				0 OTHER_CASH_ACT_VALUE_A,
				PAYROLL.PROJECT_ID,
				PAYROLL_OTHER_MONEY OTHER_MONEY,
				CHEQUE.COMPANY_ID,
				PAYROLL.BRANCH_ID,
				CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(CHEQUE_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
			FROM
				CHEQUE,
				PAYROLL,
				PAYROLL_MONEY
			WHERE
				CHEQUE_STATUS_ID IN (6) AND
				CHEQUE_PAYROLL_ID = PAYROLL.ACTION_ID AND
				CHEQUE.COMPANY_ID IS NOT NULL AND 
				PAYROLL.PAYROLL_OTHER_MONEY = PAYROLL_MONEY.MONEY_TYPE AND
				PAYROLL.ACTION_ID = PAYROLL_MONEY.ACTION_ID
			GROUP BY
				PAYROLL.PROJECT_ID,
				OTHER_MONEY,
				OTHER_MONEY2,
				CHEQUE.COMPANY_ID,
				PAYROLL.BRANCH_ID,
				PAYROLL_REVENUE_DATE,
				CHEQUE_DUEDATE,
				PAYROLL_RECORD_DATE,
				PAYROLL_OTHER_MONEY
		UNION ALL
			SELECT
				SUM(OTHER_MONEY_VALUE) ACTION_VALUE_B,
				0 ACTION_VALUE_A,
				OTHER_MONEY ACTION_CURRENCY,
				SUM(OTHER_MONEY_VALUE2) ACTION_VALUE2_B,
				0 ACTION_VALUE2_A,
				OTHER_MONEY2 ACTION_MONEY2,		
				SUM(OTHER_MONEY_VALUE/(VOUCHER_PAYROLL_MONEY.RATE2/VOUCHER_PAYROLL_MONEY.RATE1)) OTHER_CASH_ACT_VALUE_B,
				0 OTHER_CASH_ACT_VALUE_A,
				VOUCHER_PAYROLL.PROJECT_ID,
				PAYROLL_OTHER_MONEY OTHER_MONEY,			
				VOUCHER.COMPANY_ID,
				VOUCHER_PAYROLL.BRANCH_ID,
				CASE WHEN DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) = 0 THEN 1 ELSE  DATEDIFF(day,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE),ISNULL(VOUCHER_DUEDATE,ISNULL(PAYROLL_REVENUE_DATE,PAYROLL_RECORD_DATE))) END AS DATE_DIFF
			FROM
				VOUCHER,
				VOUCHER_PAYROLL,
				VOUCHER_PAYROLL_MONEY
			WHERE
				VOUCHER_STATUS_ID IN (6) AND
				VOUCHER_PAYROLL_ID = VOUCHER_PAYROLL.ACTION_ID AND
				VOUCHER.COMPANY_ID IS NOT NULL AND 
				VOUCHER_PAYROLL.PAYROLL_OTHER_MONEY = VOUCHER_PAYROLL_MONEY.MONEY_TYPE AND
				VOUCHER_PAYROLL.ACTION_ID = VOUCHER_PAYROLL_MONEY.ACTION_ID
			GROUP BY 
				VOUCHER_PAYROLL.PROJECT_ID,
				OTHER_MONEY,
				OTHER_MONEY2,
				VOUCHER.COMPANY_ID,
				VOUCHER_PAYROLL.BRANCH_ID,
				PAYROLL_REVENUE_DATE,
				VOUCHER_DUEDATE,
				PAYROLL_RECORD_DATE,
				PAYROLL_OTHER_MONEY

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [CONSUMER_GROUP_SALE] AS
			SELECT
				SALE_STAGE,
				CONSUMER_ID,
				INVOICE_DATE,
				SUM(NETTOTAL) NETTOTAL,
				SUM(GROSSTOTAL) GROSSTOTAL,
				SUM(INV_NETTOTAL) INV_NETTOTAL,
				SUM(INV_GROSSTOTAL) INV_GROSSTOTAL
			FROM
			(
				SELECT
					I.SALE_STAGE,
					I.CONSUMER_ID,
					I.INVOICE_DATE,
					CASE WHEN INVOICE_CAT IN(54,55,62) THEN -1*I.GROSSTOTAL ELSE I.GROSSTOTAL END AS NETTOTAL,
					CASE WHEN INVOICE_CAT IN(54,55,62) THEN -1*I.NETTOTAL ELSE I.NETTOTAL END AS GROSSTOTAL,
					CASE WHEN INVOICE_CAT IN(54,55,62) THEN -1*I.INV_GROSSTOTAL ELSE I.INV_GROSSTOTAL END AS INV_NETTOTAL,
					CASE WHEN INVOICE_CAT IN(54,55,62) THEN -1*I.INV_NETTOTAL ELSE I.INV_NETTOTAL END AS INV_GROSSTOTAL
				FROM
					INVOICE_MULTILEVEL_SALES I
				WHERE
					I.INVOICE_CAT IN(52,53,54,55,62))
			T1
			GROUP BY
				SALE_STAGE,
				CONSUMER_ID,
				INVOICE_DATE

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [CONSUMER_SALE] AS
			SELECT
				CONSUMER_ID,
				INVOICE_DATE,
				INVOICE_ID,
				INVOICE_CAT,
				SUM(NETTOTAL) NETTOTAL,
				SUM(GROSSTOTAL) GROSSTOTAL,
				SUM(INV_NETTOTAL) INV_NETTOTAL,
				SUM(INV_GROSSTOTAL) INV_GROSSTOTAL
			FROM
			(
				SELECT DISTINCT
					I.REF_CONSUMER_ID AS CONSUMER_ID,
					I.INVOICE_DATE,
					I.INVOICE_ID,
					I.INVOICE_CAT,
					CASE WHEN INVOICE_CAT IN(54,55,62) THEN -1*I.GROSSTOTAL ELSE I.GROSSTOTAL END AS NETTOTAL,
					CASE WHEN INVOICE_CAT IN(54,55,62) THEN -1*I.NETTOTAL ELSE I.NETTOTAL END AS GROSSTOTAL,
					CASE WHEN INVOICE_CAT IN(54,55,62) THEN -1*I.INV_GROSSTOTAL ELSE I.INV_GROSSTOTAL END AS INV_NETTOTAL,
					CASE WHEN INVOICE_CAT IN(54,55,62) THEN -1*I.INV_NETTOTAL ELSE I.INV_NETTOTAL END AS INV_GROSSTOTAL
				FROM
					INVOICE_MULTILEVEL_SALES I
				WHERE
					I.INVOICE_CAT IN(52,53,54,55,62)		
			)
			T1
			GROUP BY
				CONSUMER_ID,
				INVOICE_DATE,
				INVOICE_ID,
				INVOICE_CAT

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [DAILY_DUE_REMAINDER] AS
		SELECT 
			SUM(BORC) BORC,
			SUM(BORC2) BORC2,
			SUM(ALACAK) ALACAK,
			SUM(ALACAK2) ALACAK2,
			SUM(BORC-ALACAK) BAKIYE,
			SUM(BORC2-ALACAK2) BAKIYE2,
			DUE_DATE
		FROM
			(
			SELECT
				CR.ACTION_VALUE AS BORC,
				CR.ACTION_VALUE_2 AS BORC2,
				0 AS ALACAK,
				0 AS ALACAK2,
				CR.DUE_DATE,
				CR.CARI_ACTION_ID
			FROM
				CARI_ROWS CR
			WHERE 
				(TO_CMP_ID IS NOT NULL
				OR TO_CONSUMER_ID IS NOT NULL
				OR TO_EMPLOYEE_ID IS NOT NULL)
				AND CR.ACTION_ID NOT IN 
					(
						SELECT 
							ICR.ACTION_ID 
						FROM 
							CARI_CLOSED_ROW ICR,
							CARI_CLOSED IC
						WHERE 
							ICR.CLOSED_ID = IC.CLOSED_ID 
							AND ICR.CLOSED_AMOUNT IS NOT NULL
							AND CR.ACTION_TYPE_ID = ICR.ACTION_TYPE_ID
							AND ((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS'))
							AND (((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS'))
							AND CR.OTHER_MONEY = ICR.OTHER_MONEY	
					)
				AND CR.ACTION_TYPE_ID IN (40,50,52,53,56,57,58,62,66,531,561,48,121)
		UNION ALL
			SELECT
				(CR.ACTION_VALUE-ROUND(SUM(ICR.CLOSED_AMOUNT),2)) AS BORC,
				(CR.ACTION_VALUE-ROUND(SUM(ICR.CLOSED_AMOUNT),2))/(CR.ACTION_VALUE/CR.ACTION_VALUE_2) AS BORC2,
				0 AS ALACAK,
				0 AS ALACAK2,
				CR.DUE_DATE,
				CR.CARI_ACTION_ID
			FROM
				CARI_ROWS CR,
				CARI_CLOSED_ROW ICR
			WHERE 
				CR.ACTION_ID = ICR.ACTION_ID
				AND CR.ACTION_TYPE_ID = ICR.ACTION_TYPE_ID
				AND ((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS'))
				AND (((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS'))
				AND (TO_CMP_ID IS NOT NULL
				OR TO_CONSUMER_ID IS NOT NULL
				OR TO_EMPLOYEE_ID IS NOT NULL)	
				AND CR.ACTION_TYPE_ID IN (40,50,52,53,56,57,58,62,66,531,561,48,121)
			GROUP BY
				CR.ACTION_VALUE,
				CR.ACTION_VALUE_2,
				CR.DUE_DATE,
				CR.CARI_ACTION_ID	
		UNION ALL
			SELECT
				0 AS BORC,
				0 AS BORC2,
				CR.ACTION_VALUE AS ALACAK,
				CR.ACTION_VALUE_2 AS ALACAK2,
				CR.DUE_DATE,
				CR.CARI_ACTION_ID
			FROM
				CARI_ROWS CR
			WHERE
				(FROM_CMP_ID IS NOT NULL
				OR FROM_CONSUMER_ID IS NOT NULL
				OR FROM_EMPLOYEE_ID IS NOT NULL	)
				AND CR.ACTION_ID NOT IN 
					(
						SELECT 
							ICR.ACTION_ID 
						FROM 
							CARI_CLOSED_ROW ICR,
							CARI_CLOSED IC
						WHERE 
							ICR.CLOSED_ID = IC.CLOSED_ID 
							AND ICR.CLOSED_AMOUNT IS NOT NULL
							AND CR.ACTION_TYPE_ID = ICR.ACTION_TYPE_ID
							AND ((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS'))
							AND (((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS'))
							AND CR.OTHER_MONEY = ICR.OTHER_MONEY	
					)
				AND CR.ACTION_TYPE_ID IN (40,51,54,55,59,591,592,60,61,63,64,65,68,690,691,601,49,120,122)
		UNION ALL
			SELECT
				0 AS BORC,
				0 AS BORC2,
				(CR.ACTION_VALUE-ROUND(SUM(ICR.CLOSED_AMOUNT),2))AS ALACAK,
				(CR.ACTION_VALUE-ROUND(SUM(ICR.CLOSED_AMOUNT),2))/(CR.ACTION_VALUE/CR.ACTION_VALUE_2) AS ALACAK2,
				CR.DUE_DATE,
				CR.CARI_ACTION_ID
			FROM
				CARI_ROWS CR,
				CARI_CLOSED_ROW ICR
			WHERE
				CR.ACTION_ID = ICR.ACTION_ID
				AND CR.ACTION_TYPE_ID = ICR.ACTION_TYPE_ID
				AND ((CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS' AND CR.CARI_ACTION_ID = ICR.CARI_ACTION_ID) OR (CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS'))
				AND (((CR.ACTION_TABLE = 'INVOICE' OR CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS') AND CR.DUE_DATE = ICR.DUE_DATE) OR (CR.ACTION_TABLE <> 'INVOICE' AND CR.ACTION_TABLE <> 'EXPENSE_ITEM_PLANS'))
				AND (FROM_CMP_ID IS NOT NULL
				OR FROM_CONSUMER_ID IS NOT NULL
				OR FROM_EMPLOYEE_ID IS NOT NULL)
				AND CR.ACTION_TYPE_ID IN (40,51,54,55,59,591,592,60,61,63,64,65,68,690,691,601,49,120,122)	
			GROUP BY
				CR.ACTION_VALUE,
				CR.ACTION_VALUE_2,
				CR.DUE_DATE	,
				CR.CARI_ACTION_ID		
		) AS CARI_TOPLAM_1
		GROUP BY DUE_DATE

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_ACCOUNT_CARD_DETAIL] AS
			SELECT 
				ACC.ACTION_DATE,
				ACC.BILL_NO,
				ACC.CARD_TYPE,
				ACC.CARD_TYPE_NO,	
				AP.ACCOUNT_NAME,
				ACC.PAPER_NO,
				ACC.ACTION_TYPE,
				ACC.CARD_DETAIL,
				COMPANY.FULLNAME AS CARI_HESAP,
				COMPANY.TAXOFFICE AS VERGI_DAIRESI,
				COMPANY.TAXNO AS VERGI_NO,
				COMPANY.IS_RELATED_COMPANY AS BAGLI_UYE,
				ACR.CARD_ID,
                ACR.CARD_ROW_ID,
                ACR.ACCOUNT_ID,
                ACR.BA,
                ACR.AMOUNT,
                ACR.AMOUNT_CURRENCY,
                ACR.DETAIL,
                ACR.AMOUNT_2,
                ACR.ROW_ACTION_ID,
                ACR.ROW_ACTION_TYPE_ID,
                ACR.ROW_PAPER_NO,
                ACR.AMOUNT_CURRENCY_2,
                ACR.OTHER_AMOUNT,
                ACR.OTHER_CURRENCY,
                ACR.QUANTITY,
                ACR.PRICE,
                ACR.BILL_CONTROL_NO,
                ACR.IFRS_CODE,
                ACR.ACCOUNT_CODE2,
                ACR.IS_RATE_DIFF_ROW,
                ACR.COST_PROFIT_CENTER,
                ACR.ACC_DEPARTMENT_ID,
                ACR.ACC_BRANCH_ID,
                ACR.ACC_PROJECT_ID	
			FROM
				ACCOUNT_CARD ACC,
				ACCOUNT_CARD_ROWS ACR,
				ACCOUNT_PLAN AP,
				#new_dsn#.COMPANY COMPANY
			WHERE 
				ACR.CARD_ID=ACC.CARD_ID AND	
				AP.ACCOUNT_CODE=ACR.ACCOUNT_ID AND 
				ACC.ACC_COMPANY_ID = COMPANY.COMPANY_ID AND 
				ACC.ACC_COMPANY_ID IS NOT NULL
			UNION 
			SELECT 
				ACC.ACTION_DATE,
				ACC.BILL_NO,
				ACC.CARD_TYPE,
				ACC.CARD_TYPE_NO,	
				AP.ACCOUNT_NAME,
				ACC.PAPER_NO,
				ACC.ACTION_TYPE,
				ACC.CARD_DETAIL,
				(CONSUMER.CONSUMER_NAME + CONSUMER.CONSUMER_SURNAME) AS CARI_HESAP,
				CONSUMER.TAX_OFFICE AS VERGI_DAIRESI,
				CONSUMER.TAX_POSTCODE  AS VERGI_NO,
				CONSUMER.IS_RELATED_CONSUMER AS BAGLI_UYE,
				ACR.CARD_ID,
                ACR.CARD_ROW_ID,
                ACR.ACCOUNT_ID,
                ACR.BA,
                ACR.AMOUNT,
                ACR.AMOUNT_CURRENCY,
                ACR.DETAIL,
                ACR.AMOUNT_2,
                ACR.ROW_ACTION_ID,
                ACR.ROW_ACTION_TYPE_ID,
                ACR.ROW_PAPER_NO,
                ACR.AMOUNT_CURRENCY_2,
                ACR.OTHER_AMOUNT,
                ACR.OTHER_CURRENCY,
                ACR.QUANTITY,
                ACR.PRICE,
                ACR.BILL_CONTROL_NO,
                ACR.IFRS_CODE,
                ACR.ACCOUNT_CODE2,
                ACR.IS_RATE_DIFF_ROW,
                ACR.COST_PROFIT_CENTER,
                ACR.ACC_DEPARTMENT_ID,
                ACR.ACC_BRANCH_ID,
                ACR.ACC_PROJECT_ID		
			FROM
				ACCOUNT_CARD ACC,
				ACCOUNT_CARD_ROWS ACR,
				ACCOUNT_PLAN AP,
				#new_dsn#.CONSUMER CONSUMER
			WHERE 
				ACR.CARD_ID=ACC.CARD_ID AND	
				AP.ACCOUNT_CODE=ACR.ACCOUNT_ID AND 
				ACC.ACC_CONSUMER_ID = CONSUMER.CONSUMER_ID AND 
				ACC.ACC_CONSUMER_ID IS NOT NULL
			UNION 
			SELECT 
				ACC.ACTION_DATE,
				ACC.BILL_NO,
				ACC.CARD_TYPE,
				ACC.CARD_TYPE_NO,	
				AP.ACCOUNT_NAME,
				ACC.PAPER_NO,
				ACC.ACTION_TYPE,
				ACC.CARD_DETAIL,
				'' AS CARI_HESAP,
				'' AS VERGI_DAIRESI,
				'' AS VERGI_NO,
				2 AS BAGLI_UYE,
				ACR.CARD_ID,
                ACR.CARD_ROW_ID,
                ACR.ACCOUNT_ID,
                ACR.BA,
                ACR.AMOUNT,

                ACR.AMOUNT_CURRENCY,
                ACR.DETAIL,
                ACR.AMOUNT_2,
                ACR.ROW_ACTION_ID,
                ACR.ROW_ACTION_TYPE_ID,
                ACR.ROW_PAPER_NO,
                ACR.AMOUNT_CURRENCY_2,
                ACR.OTHER_AMOUNT,
                ACR.OTHER_CURRENCY,
                ACR.QUANTITY,
                ACR.PRICE,
                ACR.BILL_CONTROL_NO,
                ACR.IFRS_CODE,
                ACR.ACCOUNT_CODE2,
                ACR.IS_RATE_DIFF_ROW,
                ACR.COST_PROFIT_CENTER,
                ACR.ACC_DEPARTMENT_ID,
                ACR.ACC_BRANCH_ID,
                ACR.ACC_PROJECT_ID	
			FROM
				ACCOUNT_CARD ACC,
				ACCOUNT_CARD_ROWS ACR,
				ACCOUNT_PLAN AP
			WHERE 
				ACR.CARD_ID=ACC.CARD_ID AND	
				AP.ACCOUNT_CODE=ACR.ACCOUNT_ID AND 	
				ACC.ACC_CONSUMER_ID IS NULL AND
				ACC.ACC_COMPANY_ID IS NULL

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_ACCOUNT_CARD_GROUP] AS	
			SELECT 
				AP2.ACCOUNT_CODE  AS TOP_ACCOUNT_CODE,	
				AP2.ACCOUNT_NAME AS TOP_ACCOUNT_NAME,
				AP2.IFRS_CODE  AS TOP_ACCOUNT_IFRS_CODE,	
				AP2.IFRS_NAME AS TOP_ACCOUNT_IFRS_NAME,
				AP.IFRS_CODE AS ACC_IFRS_CODE,
				AP.IFRS_NAME,
				AP.ACCOUNT_NAME,
				ACC.ACTION_DATE,
				ACC.BILL_NO,
				ACC.CARD_TYPE,
				ACC.CARD_CAT_ID,
				ACC.CARD_TYPE_NO,		
				ACC.PAPER_NO,
				ACC.ACTION_TYPE,
				ACC.CARD_DETAIL,
				ACC.IS_COMPOUND,	
				ACR.CARD_ID,
                ACR.CARD_ROW_ID,
                ACR.ACCOUNT_ID,
                ACR.BA,
                ACR.AMOUNT,
                ACR.AMOUNT_CURRENCY,
                ACR.DETAIL,
                ACR.AMOUNT_2,
                ACR.ROW_ACTION_ID,
                ACR.ROW_ACTION_TYPE_ID,
                ACR.ROW_PAPER_NO,
                ACR.AMOUNT_CURRENCY_2,
                ACR.OTHER_AMOUNT,
                ACR.OTHER_CURRENCY,
                ACR.QUANTITY,
                ACR.PRICE,
                ACR.BILL_CONTROL_NO,
                ACR.IFRS_CODE,
                ACR.ACCOUNT_CODE2,
                ACR.IS_RATE_DIFF_ROW,
                ACR.COST_PROFIT_CENTER,
                ACR.ACC_DEPARTMENT_ID,
                ACR.ACC_BRANCH_ID,
                ACR.ACC_PROJECT_ID		
			FROM
				ACCOUNT_CARD ACC,
				ACCOUNT_CARD_ROWS ACR,
				ACCOUNT_PLAN AP,
				ACCOUNT_PLAN AP2
			WHERE 
				ACR.CARD_ID=ACC.CARD_ID 
				
				AND AP.ACCOUNT_CODE=ACR.ACCOUNT_ID
				AND (
					AP2.ACCOUNT_CODE =replace(left(AP.ACCOUNT_CODE,charindex('.',AP.ACCOUNT_CODE)),'.','')		
					OR 
					(
						AP2.ACCOUNT_CODE =AP.ACCOUNT_CODE AND
						len(replace(left(AP.ACCOUNT_CODE,charindex('.',AP.ACCOUNT_CODE)),'.',''))=0
					)
				)

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_ACTION_PROJECT_PRODUCTS] AS
			SELECT DISTINCT
				SFR.STOCK_ID,
				ISNULL(SF.PROJECT_ID,SF.PROJECT_ID_IN) AS PROJECT_ID,
				SF.FIS_TYPE AS PROCESS_TYPE,
				SF.FIS_DATE AS ACTION_DATE,
				2 AS PURCHASE_SALES,
				'STOCK_FIS' AS ACTION_TYPE
			FROM
				STOCK_FIS SF,
				STOCK_FIS_ROW SFR
			WHERE
				SF.FIS_ID = SFR.FIS_ID	
				AND (SF.PROJECT_ID IS NOT NULL OR SF.PROJECT_ID_IN IS NOT NULL)
		UNION
			SELECT DISTINCT
				SHIP_ROW.STOCK_ID,
				ISNULL(SHIP.PROJECT_ID,SHIP.PROJECT_ID_IN) AS PROJECT_ID,
				SHIP.SHIP_TYPE AS PROCESS_TYPE,
				SHIP.SHIP_DATE AS ACTION_DATE,
				SHIP.PURCHASE_SALES,
				'SHIP' AS ACTION_TYPE
			FROM
				SHIP,
				SHIP_ROW
			WHERE
				SHIP.SHIP_ID = SHIP_ROW.SHIP_ID
				AND SHIP.IS_SHIP_IPTAL=0
				AND (SHIP.PROJECT_ID_IN IS NOT NULL OR SHIP.PROJECT_ID IS NOT NULL)
		UNION
			SELECT DISTINCT
				INVOICE_ROW.STOCK_ID,
				INVOICE.PROJECT_ID,
				INVOICE.INVOICE_CAT AS PROCESS_TYPE,
				INVOICE.INVOICE_DATE AS ACTION_DATE,
				INVOICE.PURCHASE_SALES,
				'INVOICE' AS ACTION_TYPE
			FROM
				INVOICE,
				INVOICE_ROW
			WHERE
				INVOICE.INVOICE_ID = INVOICE_ROW.INVOICE_ID
				AND INVOICE.IS_IPTAL = 0
				AND INVOICE.PROJECT_ID IS NOT NULL
				AND INVOICE_CAT <> 67
				AND INVOICE_CAT <> 69
		UNION
			SELECT DISTINCT
				ORR.STOCK_ID,
				ORD.PROJECT_ID,
				0 AS PROCESS_TYPE,
				ORD.ORDER_DATE AS ACTION_DATE,
				0 AS PURCHASE_SALES,
				'ORDER_SALE' AS ACTION_TYPE
			FROM
				#new_dsn3#.ORDERS ORD,
				#new_dsn3#.ORDER_ROW ORR
			WHERE
				ORR.ORDER_ID = ORD.ORDER_ID
				AND ORD.PROJECT_ID IS NOT NULL
				AND ORD.ORDER_STATUS = 1
				AND ORD.PURCHASE_SALES=0
		UNION
			SELECT DISTINCT
				ORR.STOCK_ID,
				ORD.PROJECT_ID,
				0 AS PROCESS_TYPE,
				ORD.ORDER_DATE AS ACTION_DATE,
				1 AS PURCHASE_SALES,
				'ORDERS' AS ACTION_TYPE
			FROM
				#new_dsn3#.ORDERS ORD,
				#new_dsn3#.ORDER_ROW ORR
			WHERE
				ORR.ORDER_ID = ORD.ORDER_ID
				AND ORD.PROJECT_ID IS NOT NULL
				AND ORD.ORDER_STATUS = 1
				AND
				(	
						(ORD.PURCHASE_SALES = 1 AND ORD.ORDER_ZONE = 0)  	OR
						(ORD.PURCHASE_SALES = 0 AND ORD.ORDER_ZONE = 1)	
				)
		UNION
			SELECT DISTINCT
				PMR.STOCK_ID,
				PM.PROJECT_ID,
				0 AS PROCESS_TYPE,
				'' AS ACTION_DATE,
				2 AS PURCHASE_SALES,
				'PROMATERIAL' AS ACTION_TYPE
			FROM
				#new_dsn#.PRO_MATERIAL PM,
				#new_dsn#.PRO_MATERIAL_ROW PMR
			WHERE 
				PM.PRO_MATERIAL_ID=PMR.PRO_MATERIAL_ID AND
				PM.PROJECT_ID IS NOT NULL
		UNION
			SELECT DISTINCT
				INDR.STOCK_ID,
				IND.PROJECT_ID,
				0 AS PROCESS_TYPE,
				IND.RECORD_DATE AS ACTION_DATE,
				2 AS PURCHASE_SALES,
				'INTERNAL' AS ACTION_TYPE
			FROM
				#new_dsn3#.INTERNALDEMAND IND,
				#new_dsn3#.INTERNALDEMAND_ROW INDR
			WHERE
				INDR.I_ID = IND.INTERNAL_ID
				AND IND.PROJECT_ID IS NOT NULL
		UNION
			SELECT DISTINCT
				PORD.STOCK_ID,
				PORD.PROJECT_ID,
				0 AS PROCESS_TYPE,
				PORD.START_DATE AS ACTION_DATE,
				2 AS PURCHASE_SALES,
				'PRODUCTION_ORDERS' AS ACTION_TYPE
			FROM
				#new_dsn3#.PRODUCTION_ORDERS PORD
			WHERE
				PORD.PROJECT_ID IS NOT NULL

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_ALL_ACC_CODE_DAILY_TOTAL] AS
			SELECT 
				SUM(AMOUNT) AS AMOUNT_TOTAL,
				SUM(ISNULL(AMOUNT_2,0)) AS AMOUNT_TOTAL_2,
				AP.ACCOUNT_CODE,
				ACTION_DATE,
				BA
			FROM
				ACCOUNT_CARD ACC,
				ACCOUNT_CARD_ROWS ACR,
				ACCOUNT_PLAN AP
			WHERE 
				ACR.CARD_ID=ACC.CARD_ID
				AND AP.SUB_ACCOUNT = 1
				AND AP.ACCOUNT_CODE = substring(ACR.ACCOUNT_ID,1,len(AP.ACCOUNT_CODE))
				AND substring(ACR.ACCOUNT_ID,(len(AP.ACCOUNT_CODE)+1),1)='.'		
			GROUP BY	
				AP.ACCOUNT_CODE,
				ACTION_DATE,
				BA
		UNION ALL
			SELECT 
				SUM(AMOUNT) AS AMOUNT_TOTAL,
				SUM(ISNULL(AMOUNT_2,0)) AS AMOUNT_TOTAL_2,
				AP.ACCOUNT_CODE,
				ACTION_DATE,
				BA
			FROM
				ACCOUNT_CARD ACC,
				ACCOUNT_CARD_ROWS ACR,
				ACCOUNT_PLAN AP
			WHERE 
				ACR.CARD_ID=ACC.CARD_ID	
				AND AP.SUB_ACCOUNT = 0
				AND AP.ACCOUNT_CODE = ACR.ACCOUNT_ID
			GROUP BY	
				AP.ACCOUNT_CODE,
				ACTION_DATE,
				BA

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_ALL_STOCK_ACTION_DETAIL] AS
			SELECT
				(SR.STOCK_IN - SR.STOCK_OUT) AS TOTAL_STOCK, 
				SR.PRODUCT_ID, 
				SR.STOCK_ID, 
				SR.STOCK_IN AS GIRIS,
				SR.STOCK_OUT AS CIKIS,	
				SR.STORE,
				SR.STORE_LOCATION,
				SR.UPD_ID,
				SR.PROCESS_TYPE,
				SR.PROCESS_DATE,		
				S.RECORD_DATE AS RECORD_DATE,	
				S.SHIP_DATE AS ACTION_DATE,		
				S.SHIP_NUMBER AS ACTION_NUMBER,
				S.PROJECT_ID
			FROM	
				STOCKS_ROW SR,
				SHIP S
			WHERE
				SR.UPD_ID=S.SHIP_ID
				AND SR.PROCESS_TYPE=S.SHIP_TYPE
			UNION ALL
			SELECT
				(SR.STOCK_IN - SR.STOCK_OUT) AS TOTAL_STOCK, 
				SR.PRODUCT_ID, 
				SR.STOCK_ID, 
				SR.STOCK_IN AS GIRIS,
				SR.STOCK_OUT AS CIKIS,	
				SR.STORE,
				SR.STORE_LOCATION,
				SR.UPD_ID,
				SR.PROCESS_TYPE,
				SR.PROCESS_DATE,
				SF.RECORD_DATE AS RECORD_DATE,	
				SF.FIS_DATE AS ACTION_DATE,	
				SF.FIS_NUMBER AS ACTION_NUMBER,
				SF.PROJECT_ID

			FROM	
				STOCKS_ROW SR,
				STOCK_FIS SF
			WHERE
				SR.UPD_ID=SF.FIS_ID
				AND SR.PROCESS_TYPE=SF.FIS_TYPE
			UNION ALL
			SELECT
				(SR.STOCK_IN - SR.STOCK_OUT) AS TOTAL_STOCK, 
				SR.PRODUCT_ID, 
				SR.STOCK_ID, 
				SR.STOCK_IN AS GIRIS,
				SR.STOCK_OUT AS CIKIS,	
				SR.STORE,
				SR.STORE_LOCATION,
				SR.UPD_ID,
				SR.PROCESS_TYPE,
				SR.PROCESS_DATE,
				SF.RECORD_DATE AS RECORD_DATE,
				SF.PROCESS_DATE AS ACTION_DATE,		
				SF.EXCHANGE_NUMBER AS ACTION_NUMBER,
				'' AS PROJECT_ID
			FROM	
				STOCKS_ROW SR,
				STOCK_EXCHANGE SF
			WHERE
				SR.UPD_ID=SF.STOCK_EXCHANGE_ID
				AND SR.PROCESS_TYPE=SF.PROCESS_TYPE
			UNION ALL
			SELECT
				(SR.STOCK_IN - SR.STOCK_OUT) AS TOTAL_STOCK, 
				SR.PRODUCT_ID, 
				SR.STOCK_ID, 
				SR.STOCK_IN AS GIRIS,
				SR.STOCK_OUT AS CIKIS,	
				SR.STORE,
				SR.STORE_LOCATION,
				SR.UPD_ID,
				SR.PROCESS_TYPE,
				SR.PROCESS_DATE,
				SR.PROCESS_DATE AS RECORD_DATE,
				SR.PROCESS_DATE AS ACTION_DATE,
				'' AS FIS_NUMBER,
				'' AS PROJECT_ID
			FROM
				STOCKS_ROW SR
			WHERE
				SR.PROCESS_TYPE =117
			UNION ALL	
			SELECT
				(SR.STOCK_IN - SR.STOCK_OUT) AS TOTAL_STOCK, 
				SR.PRODUCT_ID, 
				SR.STOCK_ID, 
				SR.STOCK_IN AS GIRIS,
				SR.STOCK_OUT AS CIKIS,	
				SR.STORE,
				SR.STORE_LOCATION,
				SR.UPD_ID,
				SR.PROCESS_TYPE,
				SR.PROCESS_DATE,
				EXP_P.RECORD_DATE AS RECORD_DATE,		
				EXP_P.EXPENSE_DATE AS ACTION_DATE,			
				EXP_P.PAPER_NO AS ACTION_NUMBER,
				EXP_P.PROJECT_ID
			FROM	
				STOCKS_ROW SR,
				EXPENSE_ITEM_PLANS EXP_P
			WHERE
				SR.UPD_ID=EXP_P.EXPENSE_ID
				AND SR.PROCESS_TYPE=EXP_P.ACTION_TYPE

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_END_SERIES_PROCESSES] AS 
		SELECT 
			SF.FIS_DATE,
			S.STOCK_ID,
			S.PRODUCT_ID,
			S.PRODUCT_NAME,
			SFR.AMOUNT,
			SFR.PRICE,
			SFR.PRICE_OTHER,
			SFR.OTHER_MONEY,
			SL.DEPARTMENT_ID,
			SL.LOCATION_ID
		FROM 
			STOCK_FIS SF,
			STOCK_FIS_ROW SFR,
			#new_dsn3#.STOCKS S,
			#new_dsn#.STOCKS_LOCATION SL
		WHERE
			SF.FIS_ID=SFR.FIS_ID
			AND SF.FIS_TYPE=1131
			AND SF.FIS_ID IN (SELECT UPD_ID FROM STOCKS_ROW WHERE PROCESS_TYPE=1131)
			AND SF.DEPARTMENT_IN=SL.DEPARTMENT_ID
			AND SF.LOCATION_IN=SL.LOCATION_ID
			AND SL.IS_END_OF_SERIES=1
			AND S.STOCK_ID=SFR.STOCK_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_LOCATION_STOCK_FOR_REPORT] AS
			SELECT
				SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_REAL_STOCK, 
				S.PRODUCT_ID, 
				S.STOCK_ID
			FROM
				#new_dsn3#.STOCKS S,
				STOCKS_ROW SR
			WHERE
				S.STOCK_ID = SR.STOCK_ID
				AND (
					(SR.STORE=74 AND SR.STORE_LOCATION=45)
					OR (SR.STORE IS NULL AND SR.STORE_LOCATION IS NULL)
					)
			GROUP BY
				S.PRODUCT_ID,
				S.STOCK_ID
</cfquery>

<cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_PRODUCT_STOCK_BRANCH] AS
			SELECT
				SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,
				SR.PRODUCT_ID,
				B.BRANCH_ID, 
				B.BRANCH_NAME
			FROM
				#new_dsn#.DEPARTMENT D,
				#new_dsn#.BRANCH B,
				STOCKS_ROW SR
			WHERE
				D.DEPARTMENT_ID = SR.STORE AND
				B.BRANCH_ID = D.BRANCH_ID
			GROUP BY
				SR.PRODUCT_ID,
				B.BRANCH_ID,
				B.BRANCH_NAME

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_SHIP_RESULT] AS
			SELECT
				 'SHIP' IS_TYPE,
				SR.SHIP_RESULT_ID,
				SR.SHIP_FIS_NO,
				SR.SERVICE_COMPANY_ID,
				SR.MAIN_SHIP_FIS_NO,
				SRW.SHIP_ID,
				C.OZEL_KOD_2
			FROM 
				SHIP_RESULT SR, 
				SHIP_RESULT_ROW SRW, 
				#new_dsn#.COMPANY C
			WHERE
				SR.SHIP_RESULT_ID = SRW.SHIP_RESULT_ID AND
				SR.IS_TYPE IS NULL AND 
				SR.SERVICE_COMPANY_ID = C.COMPANY_ID
			UNION
			
			SELECT
				'ORDER' IS_TYPE, 
				SR.SHIP_RESULT_ID, 
				SR.SHIP_FIS_NO,
				SR.SERVICE_COMPANY_ID, 
				SR.MAIN_SHIP_FIS_NO,
				SRW.SHIP_ID, 
				C.OZEL_KOD_2
			FROM
				SHIP_RESULT SR, SHIP_RESULT_ROW SRW, 
				#new_dsn#.COMPANY C
			WHERE
				SR.SHIP_RESULT_ID = SRW.SHIP_RESULT_ID AND
				SR.IS_TYPE = 2 AND
				SR.SERVICE_COMPANY_ID = C.COMPANY_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_SHIP_ROW_RELATION] AS
			SELECT
				0  AS SHIP_AMOUNT,
				SUM(AMOUNT) AS INVOICE_AMOUNT,
				SHIP_ID,
				SHIP_PERIOD,
				PRODUCT_ID,
				STOCK_ID,
				SPECT_VAR_ID,
				SHIP_WRK_ROW_ID
			FROM
				SHIP_ROW_RELATION
			WHERE
				ISNULL(TO_SHIP_ID,0)=0
			GROUP BY
				SHIP_ID,
				SHIP_PERIOD,
				PRODUCT_ID,
				STOCK_ID,
				SPECT_VAR_ID,
				SHIP_WRK_ROW_ID
				
			UNION ALL
			
			SELECT
				SUM(AMOUNT) AS SHIP_AMOUNT,
				0 AS  INVOICE_AMOUNT,
				SHIP_ID,
				SHIP_PERIOD,
				PRODUCT_ID,
				STOCK_ID,
				SPECT_VAR_ID,
				SHIP_WRK_ROW_ID
			FROM
				SHIP_ROW_RELATION
			WHERE
				ISNULL(TO_INVOICE_ID,0)=0
			GROUP BY
				SHIP_ID,
				SHIP_PERIOD,
				PRODUCT_ID,
				STOCK_ID,
				SPECT_VAR_ID,
				SHIP_WRK_ROW_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_STOCK_LAST] AS
		SELECT 
			ROUND(SUM(REAL_STOCK),4) REAL_STOCK,
			ROUND(SUM(PRODUCT_STOCK),4) PRODUCT_STOCK,
			ROUND(SUM(PRODUCT_STOCK+RESERVED_STOCK),4) SALEABLE_STOCK,
			ROUND(SUM(PURCHASE_ORDER_STOCK),4) PURCHASE_ORDER_STOCK,
			PRODUCT_ID, 
			STOCK_ID
		FROM
		(
			SELECT

				(SR.STOCK_IN - SR.STOCK_OUT) AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				0 AS RESERVED_STOCK,
				0 AS PURCHASE_ORDER_STOCK,
				SR.STOCK_ID,
				SR.PRODUCT_ID
			FROM
				STOCKS_ROW SR
		UNION ALL
			SELECT
				0 AS REAL_STOCK,
				(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,
				0 AS RESERVED_STOCK,
				0 AS PURCHASE_ORDER_STOCK,
				SR.STOCK_ID,
				SR.PRODUCT_ID
			FROM
				#new_dsn#.STOCKS_LOCATION SL,
				STOCKS_ROW SR
			WHERE
				SR.STORE =SL.DEPARTMENT_ID
				AND SR.STORE_LOCATION=SL.LOCATION_ID
				AND SL.NO_SALE = 0
		UNION ALL
			SELECT
				0 AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				((RESERVE_STOCK_OUT-STOCK_OUT)*-1) AS RESERVED_STOCK,
				RESERVE_STOCK_IN AS PURCHASE_ORDER_STOCK,
				ORR.STOCK_ID,
				ORR.PRODUCT_ID
			FROM
				#new_dsn3#.GET_ORDER_ROW_RESERVED ORR, 
				#new_dsn3#.ORDERS ORDS
			WHERE
				ORDS.RESERVED = 1 AND 
				ORDS.ORDER_STATUS = 1 AND	
				ORR.ORDER_ID=ORDS.ORDER_ID AND 
				((RESERVE_STOCK_IN-STOCK_IN)>0 OR (RESERVE_STOCK_OUT-STOCK_OUT)>0)
		UNION ALL
			SELECT
				0 AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				(RESERVE_STOCK_IN-STOCK_IN) AS RESERVED_STOCK,
				0 AS PURCHASE_ORDER_STOCK,
				ORR.STOCK_ID,
				ORR.PRODUCT_ID

			FROM
				#new_dsn3#.GET_ORDER_ROW_RESERVED ORR, 
				#new_dsn3#.ORDERS ORDS,
				#new_dsn#.STOCKS_LOCATION SL
			WHERE
				ORDS.RESERVED = 1 AND 
				ORDS.ORDER_STATUS = 1 AND	
				ORDS.DELIVER_DEPT_ID =SL.DEPARTMENT_ID AND 
				ORDS.LOCATION_ID=SL.LOCATION_ID AND 
				SL.NO_SALE = 0	 AND 
				ORR.ORDER_ID=ORDS.ORDER_ID AND 
				(RESERVE_STOCK_IN-STOCK_IN)>0
		UNION ALL
			SELECT
				0 AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				((RESERVE_STOCK_IN-STOCK_IN) + ((RESERVE_STOCK_OUT-STOCK_OUT)*-1)) AS RESERVED_STOCK,
				0 AS PURCHASE_ORDER_STOCK,
				ORR.STOCK_ID,
				ORR.PRODUCT_ID
			FROM
				#new_dsn3#.ORDER_ROW_RESERVED  ORR
			WHERE
				ORDER_ID IS NULL
				AND SHIP_ID IS NULL
				AND INVOICE_ID IS NULL
		UNION ALL
			SELECT
				0 AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				(STOCK_ARTIR-STOCK_AZALT) AS RESERVED_STOCK,
				0  AS PURCHASE_ORDER_STOCK,
				STOCK_ID,
				PRODUCT_ID
			FROM
				#new_dsn3#.GET_PRODUCTION_RESERVED
		UNION ALL
			SELECT
				0 AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				-1*(STOCK_IN - SR.STOCK_OUT) AS RESERVED_STOCK,
				0  AS PURCHASE_ORDER_STOCK,
				SR.STOCK_ID,
				SR.PRODUCT_ID
			FROM
				STOCKS_ROW SR,
				#new_dsn#.STOCKS_LOCATION SL 
			WHERE	
				SR.STORE = SL.DEPARTMENT_ID AND
				SR.STORE_LOCATION = SL.LOCATION_ID AND
				ISNULL(SL.IS_SCRAP,0)=1
		) T1
	GROUP BY
			PRODUCT_ID, 
			STOCK_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_STOCK_LAST_LOCATION] AS
		SELECT 
			SUM(REAL_STOCK) REAL_STOCK,
			SUM(PRODUCT_STOCK) PRODUCT_STOCK,
			SUM(RESERVED_STOCK) RESERVED_STOCK,
			SUM(PURCHASE_PROD_STOCK) PURCHASE_PROD_STOCK,
			SUM(RESERVED_PROD_STOCK) RESERVED_PROD_STOCK,
			SUM(PRODUCT_STOCK+RESERVED_STOCK) SALEABLE_STOCK,
			SUM(RESERVE_SALE_ORDER_STOCK) RESERVE_SALE_ORDER_STOCK,
			SUM(NOSALE_STOCK) NOSALE_STOCK,
			SUM(BELONGTO_INSTITUTION_STOCK) BELONGTO_INSTITUTION_STOCK,
			SUM(RESERVE_PURCHASE_ORDER_STOCK) RESERVE_PURCHASE_ORDER_STOCK,
			SUM(PRODUCTION_ORDER_STOCK) PRODUCTION_ORDER_STOCK,
			SUM(NOSALE_RESERVED_STOCK) AS NOSALE_RESERVED_STOCK,
			PRODUCT_ID, 
			STOCK_ID,
			DEPARTMENT_ID,
			LOCATION_ID
		FROM
		(
			SELECT
				(SR.STOCK_IN - SR.STOCK_OUT) AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				0 AS RESERVED_STOCK,
				0 AS PURCHASE_PROD_STOCK,
				0 AS RESERVED_PROD_STOCK,
				0 AS RESERVE_SALE_ORDER_STOCK,
				0 AS NOSALE_STOCK, 
				0 AS BELONGTO_INSTITUTION_STOCK,
				0 AS RESERVE_PURCHASE_ORDER_STOCK,
				0 AS PRODUCTION_ORDER_STOCK,
				0 AS NOSALE_RESERVED_STOCK,
				SR.STOCK_ID,
				SR.PRODUCT_ID,
				SR.STORE AS DEPARTMENT_ID,
				SR.STORE_LOCATION AS LOCATION_ID
			FROM
				STOCKS_ROW SR
			WHERE
				SR.STORE IS NOT NULL AND
				SR.STORE_LOCATION IS NOT NULL 
		UNION ALL
			SELECT
				(SR.STOCK_IN - SR.STOCK_OUT) AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				0 AS RESERVED_STOCK,
				0 AS PURCHASE_PROD_STOCK,
				0 AS RESERVED_PROD_STOCK,
				0 AS RESERVE_SALE_ORDER_STOCK,
				0 AS NOSALE_STOCK, 
				0 AS BELONGTO_INSTITUTION_STOCK,
				0 AS RESERVE_PURCHASE_ORDER_STOCK,
				0 AS PRODUCTION_ORDER_STOCK,
				0 AS NOSALE_RESERVED_STOCK,
				SR.STOCK_ID,
				SR.PRODUCT_ID,
				'-1'  AS DEPARTMENT_ID,
				'-1'  AS LOCATION_ID
			FROM
				STOCKS_ROW SR
			WHERE
				UPD_ID IS NULL
		UNION ALL
			SELECT
				0 AS REAL_STOCK,
				(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,
				0 AS RESERVED_STOCK,
				0 AS PURCHASE_PROD_STOCK,
				0 AS RESERVED_PROD_STOCK,
				0 AS RESERVE_SALE_ORDER_STOCK,
				0 AS NOSALE_STOCK, 
				0 AS BELONGTO_INSTITUTION_STOCK,
				0 AS RESERVE_PURCHASE_ORDER_STOCK,
				0 AS PRODUCTION_ORDER_STOCK,
				0 AS NOSALE_RESERVED_STOCK,
				SR.STOCK_ID,
				SR.PRODUCT_ID,
				SR.STORE AS DEPARTMENT_ID,
				SR.STORE_LOCATION AS LOCATION_ID
			FROM
				#new_dsn#.STOCKS_LOCATION SL,
				STOCKS_ROW SR
			WHERE
				SR.STORE =SL.DEPARTMENT_ID
				AND SR.STORE_LOCATION=SL.LOCATION_ID
				AND SL.NO_SALE = 0
		UNION ALL
			SELECT
				0 AS REAL_STOCK,
				-1*(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,
				0 AS RESERVED_STOCK,
				0 AS PURCHASE_PROD_STOCK,
				0 AS RESERVED_PROD_STOCK,
				0 AS RESERVE_SALE_ORDER_STOCK,
				0 AS NOSALE_STOCK, 
				0 AS BELONGTO_INSTITUTION_STOCK,
				0 AS RESERVE_PURCHASE_ORDER_STOCK,
				0 AS PRODUCTION_ORDER_STOCK,
				0 AS NOSALE_RESERVED_STOCK,
				SR.STOCK_ID,
				SR.PRODUCT_ID,
				SR.STORE AS DEPARTMENT_ID,
				SR.STORE_LOCATION AS LOCATION_ID
			FROM
				STOCKS_ROW SR,
				#new_dsn#.STOCKS_LOCATION SL 
			WHERE	
				SR.STORE = SL.DEPARTMENT_ID AND
				SR.STORE_LOCATION = SL.LOCATION_ID AND
				ISNULL(SL.IS_SCRAP,0)=1
		UNION ALL
			SELECT
				0 AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				0 AS RESERVED_STOCK,
				0 AS PURCHASE_PROD_STOCK,
				0 AS RESERVED_PROD_STOCK,
				0 AS RESERVE_SALE_ORDER_STOCK,
				(SR.STOCK_IN - SR.STOCK_OUT) AS NOSALE_STOCK,
				0 AS BELONGTO_INSTITUTION_STOCK,
				0 AS RESERVE_PURCHASE_ORDER_STOCK,
				0 AS PRODUCTION_ORDER_STOCK,
				0 AS NOSALE_RESERVED_STOCK,
				SR.STOCK_ID,
				SR.PRODUCT_ID,
				SR.STORE AS DEPARTMENT_ID,
				SR.STORE_LOCATION AS LOCATION_ID
			FROM
				#new_dsn#.STOCKS_LOCATION SL,
				STOCKS_ROW SR
			WHERE
				SR.STORE =SL.DEPARTMENT_ID
				AND SR.STORE_LOCATION=SL.LOCATION_ID
				AND SL.NO_SALE =1
		UNION ALL
			SELECT
				0 AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				0 AS RESERVED_STOCK,
				0 AS PURCHASE_PROD_STOCK,
				0 AS RESERVED_PROD_STOCK,
				0 AS RESERVE_SALE_ORDER_STOCK,
				0 AS NOSALE_STOCK, 
				(SR.STOCK_IN - SR.STOCK_OUT) AS BELONGTO_INSTITUTION_STOCK,
				0 AS RESERVE_PURCHASE_ORDER_STOCK,
				0 AS PRODUCTION_ORDER_STOCK,
				0 AS NOSALE_RESERVED_STOCK,
				SR.STOCK_ID,
				SR.PRODUCT_ID,
				SR.STORE AS DEPARTMENT_ID,
				SR.STORE_LOCATION AS LOCATION_ID
			FROM
				#new_dsn#.STOCKS_LOCATION SL,
				STOCKS_ROW SR
			WHERE
				SR.STORE =SL.DEPARTMENT_ID
				AND SR.STORE_LOCATION=SL.LOCATION_ID
				AND SL.BELONGTO_INSTITUTION =1
		UNION ALL
			SELECT
				0 AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				((RESERVE_STOCK_OUT-STOCK_OUT)*-1) AS RESERVED_STOCK,
				0 AS PURCHASE_PROD_STOCK,
				0 AS RESERVED_PROD_STOCK,
				(RESERVE_STOCK_OUT-STOCK_OUT) AS RESERVE_SALE_ORDER_STOCK,
				0 AS NOSALE_STOCK,
				0 AS BELONGTO_INSTITUTION_STOCK,
				(RESERVE_STOCK_IN-STOCK_IN) AS RESERVE_PURCHASE_ORDER_STOCK,
				0 AS PRODUCTION_ORDER_STOCK,
				0 AS NOSALE_RESERVED_STOCK,
				ORR.STOCK_ID,
				ORR.PRODUCT_ID,
				ORDS.DELIVER_DEPT_ID AS DEPARTMENT_ID,
				ORDS.LOCATION_ID AS LOCATION_ID
			FROM
				#new_dsn3#.GET_ORDER_ROW_RESERVED ORR, 
				#new_dsn3#.ORDERS ORDS
			WHERE
				ORDS.RESERVED = 1 AND 
				ORDS.ORDER_STATUS = 1 AND	
				ORDS.DELIVER_DEPT_ID IS NOT NULL AND
				ORDS.LOCATION_ID IS NOT NULL AND
				ORR.ORDER_ID = ORDS.ORDER_ID AND 
				((RESERVE_STOCK_IN-STOCK_IN)>0 OR (RESERVE_STOCK_OUT-STOCK_OUT)>0)
		UNION ALL
			SELECT
				0 AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				(RESERVE_STOCK_IN-STOCK_IN) AS RESERVED_STOCK,
				0 AS PURCHASE_PROD_STOCK,
				0 AS RESERVED_PROD_STOCK,
				0 AS RESERVE_SALE_ORDER_STOCK,
				0 AS NOSALE_STOCK,
				0 AS BELONGTO_INSTITUTION_STOCK,
				0 AS RESERVE_PURCHASE_ORDER_STOCK,
				0 AS PRODUCTION_ORDER_STOCK,
				0 AS NOSALE_RESERVED_STOCK,
				ORR.STOCK_ID,
				ORR.PRODUCT_ID,
				ORDS.DELIVER_DEPT_ID AS DEPARTMENT_ID,
				ORDS.LOCATION_ID AS LOCATION_ID
			FROM
				#new_dsn3#.GET_ORDER_ROW_RESERVED ORR, 
				#new_dsn3#.ORDERS ORDS,
				#new_dsn#.STOCKS_LOCATION SL
			WHERE
				ORDS.RESERVED = 1 AND 
				ORDS.ORDER_STATUS = 1 AND
				ORDS.DELIVER_DEPT_ID=SL.DEPARTMENT_ID AND
				ORDS.LOCATION_ID=SL.LOCATION_ID AND
				SL.NO_SALE=0 AND
				ORDS.PURCHASE_SALES=0 AND
				ORDS.ORDER_ZONE=0 AND
				ORR.ORDER_ID = ORDS.ORDER_ID AND 
				(RESERVE_STOCK_IN-STOCK_IN)>0	
		UNION ALL
			SELECT
				0 AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				0 AS RESERVED_STOCK,
				0 AS PURCHASE_PROD_STOCK,
				0 AS RESERVED_PROD_STOCK,
				0 AS RESERVE_SALE_ORDER_STOCK,
				0 AS NOSALE_STOCK,
				0 AS BELONGTO_INSTITUTION_STOCK,
				0 AS RESERVE_PURCHASE_ORDER_STOCK,
				0 AS PRODUCTION_ORDER_STOCK,
				(RESERVE_STOCK_IN-STOCK_IN) AS NOSALE_RESERVED_STOCK,
				ORR.STOCK_ID,
				ORR.PRODUCT_ID,
				ORDS.DELIVER_DEPT_ID AS DEPARTMENT_ID,
				ORDS.LOCATION_ID AS LOCATION_ID
			FROM
				#new_dsn3#.GET_ORDER_ROW_RESERVED ORR, 
				#new_dsn3#.ORDERS ORDS,
				#new_dsn#.STOCKS_LOCATION SL
			WHERE
				ORDS.RESERVED = 1 AND 
				ORDS.ORDER_STATUS = 1 AND	
				ORDS.DELIVER_DEPT_ID IS NOT NULL AND
				ORDS.LOCATION_ID IS NOT NULL AND
				ORDS.DELIVER_DEPT_ID=SL.DEPARTMENT_ID AND
				ORDS.LOCATION_ID=SL.LOCATION_ID AND
				SL.NO_SALE=1 AND
				ORDS.PURCHASE_SALES=0 AND
				ORDS.ORDER_ZONE=0 AND
				ORR.ORDER_ID = ORDS.ORDER_ID AND 
				(RESERVE_STOCK_IN-STOCK_IN)>0
			UNION ALL
			SELECT
					0 AS REAL_STOCK,
					0 AS PRODUCT_STOCK,
					(STOCK_ARTIR-STOCK_AZALT) AS RESERVED_STOCK,
					STOCK_ARTIR AS PURCHASE_PROD_STOCK,
					STOCK_AZALT AS RESERVED_PROD_STOCK,
					0  AS RESERVE_SALE_ORDER_STOCK,
					0 AS NOSALE_STOCK,
					0 AS BELONGTO_INSTITUTION_STOCK,
					0  AS RESERVE_PURCHASE_ORDER_STOCK,
					(STOCK_ARTIR-STOCK_AZALT)  AS PRODUCTION_ORDER_STOCK,
					0 AS NOSALE_RESERVED_STOCK,
					STOCK_ID,
					PRODUCT_ID,
					DEPARTMENT_ID,
					LOCATION_ID
				FROM
					#new_dsn3#.GET_PRODUCTION_RESERVED_LOCATION
		) T1
		GROUP BY
			PRODUCT_ID, 
			STOCK_ID,
			DEPARTMENT_ID,
			LOCATION_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_STOCK_LAST_PROFILE] AS
		SELECT 
			SUM(REAL_STOCK) REAL_STOCK,
			SUM(PRODUCT_STOCK) PRODUCT_STOCK,
			SUM(RESERVED_STOCK) RESERVED_STOCK,
			SUM(PURCHASE_PROD_STOCK) PURCHASE_PROD_STOCK,
			SUM(RESERVED_PROD_STOCK) RESERVED_PROD_STOCK,
			SUM(PRODUCT_STOCK+RESERVED_STOCK) SALEABLE_STOCK,
			SUM(RESERVE_SALE_ORDER_STOCK) RESERVE_SALE_ORDER_STOCK,
			SUM(NOSALE_STOCK) NOSALE_STOCK,
			SUM(BELONGTO_INSTITUTION_STOCK) BELONGTO_INSTITUTION_STOCK,
			SUM(RESERVE_PURCHASE_ORDER_STOCK) RESERVE_PURCHASE_ORDER_STOCK,
			SUM(PRODUCTION_ORDER_STOCK) PRODUCTION_ORDER_STOCK,
			SUM(NOSALE_RESERVED_STOCK) AS NOSALE_RESERVED_STOCK,
			PRODUCT_ID, 
			STOCK_ID
		FROM
		(
			SELECT
				(SR.STOCK_IN - SR.STOCK_OUT) AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				0 AS RESERVED_STOCK,
				0 AS PURCHASE_PROD_STOCK,
				0 AS RESERVED_PROD_STOCK,
				0 AS RESERVE_SALE_ORDER_STOCK,
				0 AS NOSALE_STOCK, 
				0 AS BELONGTO_INSTITUTION_STOCK,
				0 AS RESERVE_PURCHASE_ORDER_STOCK,
				0 AS PRODUCTION_ORDER_STOCK,
				0 AS NOSALE_RESERVED_STOCK,
				SR.STOCK_ID,
				SR.PRODUCT_ID
			FROM
				STOCKS_ROW SR
			UNION ALL			
				SELECT
					0 AS REAL_STOCK,
					(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,
					0 AS RESERVED_STOCK,
					0 AS PURCHASE_PROD_STOCK,
					0 AS RESERVED_PROD_STOCK,
					0 AS RESERVE_SALE_ORDER_STOCK,
					0 AS NOSALE_STOCK, 
					0 AS BELONGTO_INSTITUTION_STOCK,
					0 AS RESERVE_PURCHASE_ORDER_STOCK,
					0 AS PRODUCTION_ORDER_STOCK,
					0 AS NOSALE_RESERVED_STOCK,
					SR.STOCK_ID,
					SR.PRODUCT_ID
				FROM
					#new_dsn#.STOCKS_LOCATION SL,
					STOCKS_ROW SR
				WHERE
					SR.STORE =SL.DEPARTMENT_ID
					AND SR.STORE_LOCATION=SL.LOCATION_ID
					AND SL.NO_SALE = 0
			UNION ALL
				SELECT
					0 AS REAL_STOCK,
					-1*(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,
					0 AS RESERVED_STOCK,
					0 AS PURCHASE_PROD_STOCK,
					0 AS RESERVED_PROD_STOCK,
					0 AS RESERVE_SALE_ORDER_STOCK,
					0 AS NOSALE_STOCK, 
					0 AS BELONGTO_INSTITUTION_STOCK,
					0 AS RESERVE_PURCHASE_ORDER_STOCK,
					0 AS PRODUCTION_ORDER_STOCK,
					0 AS NOSALE_RESERVED_STOCK,
					SR.STOCK_ID,
					SR.PRODUCT_ID
				FROM
					STOCKS_ROW SR,
					#new_dsn#.STOCKS_LOCATION SL 
				WHERE	
					SR.STORE = SL.DEPARTMENT_ID AND
					SR.STORE_LOCATION = SL.LOCATION_ID AND
					ISNULL(SL.IS_SCRAP,0)=1
			UNION ALL			
				SELECT
					0 AS REAL_STOCK,
					0 AS PRODUCT_STOCK,
					0 AS RESERVED_STOCK,
					0 AS PURCHASE_PROD_STOCK,
					0 AS RESERVED_PROD_STOCK,
					0 AS RESERVE_SALE_ORDER_STOCK,
					(SR.STOCK_IN - SR.STOCK_OUT) AS NOSALE_STOCK,
					0 AS BELONGTO_INSTITUTION_STOCK,
					0 AS RESERVE_PURCHASE_ORDER_STOCK,
					0 AS PRODUCTION_ORDER_STOCK,
					0 AS NOSALE_RESERVED_STOCK,
					SR.STOCK_ID,
					SR.PRODUCT_ID
				FROM
					#new_dsn#.STOCKS_LOCATION SL,
					STOCKS_ROW SR
				WHERE
					SR.STORE =SL.DEPARTMENT_ID
					AND SR.STORE_LOCATION=SL.LOCATION_ID
					AND SL.NO_SALE =1
			UNION ALL
				SELECT
					0 AS REAL_STOCK,
					0 AS PRODUCT_STOCK,
					0 AS RESERVED_STOCK,
					0 AS PURCHASE_PROD_STOCK,
					0 AS RESERVED_PROD_STOCK,
					0 AS RESERVE_SALE_ORDER_STOCK,
					0 AS NOSALE_STOCK, 
					(SR.STOCK_IN - SR.STOCK_OUT) AS BELONGTO_INSTITUTION_STOCK,
					0 AS RESERVE_PURCHASE_ORDER_STOCK,
					0 AS PRODUCTION_ORDER_STOCK,
					0 AS NOSALE_RESERVED_STOCK,
					SR.STOCK_ID,
					SR.PRODUCT_ID
				FROM
					#new_dsn#.STOCKS_LOCATION SL,
					STOCKS_ROW SR
				WHERE
					SR.STORE =SL.DEPARTMENT_ID
					AND SR.STORE_LOCATION=SL.LOCATION_ID
					AND SL.BELONGTO_INSTITUTION =1
			UNION ALL			
				SELECT
					0 AS REAL_STOCK,
					0 AS PRODUCT_STOCK,
					((RESERVE_STOCK_OUT-STOCK_OUT)*-1) AS RESERVED_STOCK,
					0 AS PURCHASE_PROD_STOCK,
					0 AS RESERVED_PROD_STOCK,
					(RESERVE_STOCK_OUT-STOCK_OUT) AS RESERVE_SALE_ORDER_STOCK,
					0 AS NOSALE_STOCK,
					0 AS BELONGTO_INSTITUTION_STOCK,
					(RESERVE_STOCK_IN-STOCK_IN) AS RESERVE_PURCHASE_ORDER_STOCK,
					0 AS PRODUCTION_ORDER_STOCK,
					0 AS NOSALE_RESERVED_STOCK,
					ORR.STOCK_ID,
					ORR.PRODUCT_ID
				FROM
					#new_dsn3#.GET_ORDER_ROW_RESERVED ORR, 
					#new_dsn3#.ORDERS ORDS
				WHERE
					ORDS.RESERVED = 1 AND 
					ORDS.ORDER_STATUS = 1 AND	
					ORR.ORDER_ID = ORDS.ORDER_ID AND
					((RESERVE_STOCK_IN-STOCK_IN)>0 OR (RESERVE_STOCK_OUT-STOCK_OUT)>0)	
			UNION ALL			
				SELECT
					0 AS REAL_STOCK,
					0 AS PRODUCT_STOCK,
					(RESERVE_STOCK_IN-STOCK_IN) AS RESERVED_STOCK,
					0 AS PURCHASE_PROD_STOCK,
					0 AS RESERVED_PROD_STOCK,
					0 AS RESERVE_SALE_ORDER_STOCK,
					0 AS NOSALE_STOCK,
					0 AS BELONGTO_INSTITUTION_STOCK,
					0 AS RESERVE_PURCHASE_ORDER_STOCK,
					0 AS PRODUCTION_ORDER_STOCK,
					0 AS NOSALE_RESERVED_STOCK,
					ORR.STOCK_ID,
					ORR.PRODUCT_ID
				FROM
					#new_dsn#.STOCKS_LOCATION SL,
					#new_dsn3#.GET_ORDER_ROW_RESERVED ORR, 
					#new_dsn3#.ORDERS ORDS
				WHERE
					ORDS.DELIVER_DEPT_ID=SL.DEPARTMENT_ID AND
					ORDS.LOCATION_ID=SL.LOCATION_ID AND
					SL.NO_SALE = 0 AND
					ORDS.PURCHASE_SALES=0 AND
					ORDS.ORDER_ZONE=0 AND
					ORDS.RESERVED = 1 AND 
					ORDS.ORDER_STATUS = 1 AND	
					ORR.ORDER_ID = ORDS.ORDER_ID AND
					(RESERVE_STOCK_IN-STOCK_IN)>0
			UNION ALL			
				SELECT
					0 AS REAL_STOCK,
					0 AS PRODUCT_STOCK,
					0 AS RESERVED_STOCK,
					0 AS PURCHASE_PROD_STOCK,
					0 AS RESERVED_PROD_STOCK,
					0 AS RESERVE_SALE_ORDER_STOCK,
					0 AS NOSALE_STOCK,
					0 AS BELONGTO_INSTITUTION_STOCK,
					0 AS RESERVE_PURCHASE_ORDER_STOCK,
					0 AS PRODUCTION_ORDER_STOCK,
					(RESERVE_STOCK_IN-STOCK_IN) AS NOSALE_RESERVED_STOCK,
					ORR.STOCK_ID,
					ORR.PRODUCT_ID
				FROM
					#new_dsn#.STOCKS_LOCATION SL,
					#new_dsn3#.GET_ORDER_ROW_RESERVED ORR, 
					#new_dsn3#.ORDERS ORDS
				WHERE
					ORDS.DELIVER_DEPT_ID=SL.DEPARTMENT_ID AND
					ORDS.LOCATION_ID=SL.LOCATION_ID AND
					SL.NO_SALE = 1 AND
					ORDS.PURCHASE_SALES=0 AND
					ORDS.ORDER_ZONE=0 AND
					ORDS.RESERVED = 1 AND 
					ORDS.ORDER_STATUS = 1 AND	
					ORR.ORDER_ID = ORDS.ORDER_ID AND
					(RESERVE_STOCK_IN-STOCK_IN)>0
			UNION ALL			
				SELECT
					0 AS REAL_STOCK,
					0 AS PRODUCT_STOCK,
					((RESERVE_STOCK_IN-STOCK_IN) + ((RESERVE_STOCK_OUT-STOCK_OUT)*-1)) AS RESERVED_STOCK,
					0 AS PURCHASE_PROD_STOCK,
					0 AS RESERVED_PROD_STOCK,
					(RESERVE_STOCK_OUT-STOCK_OUT) AS RESERVE_SALE_ORDER_STOCK,
					0 AS NOSALE_STOCK,
					0 AS BELONGTO_INSTITUTION_STOCK,
					(RESERVE_STOCK_IN-STOCK_IN) AS RESERVE_PURCHASE_ORDER_STOCK,
					0 AS PRODUCTION_ORDER_STOCK,
					0 AS NOSALE_RESERVED_STOCK,
					ORR.STOCK_ID,
					ORR.PRODUCT_ID
				FROM
					#new_dsn3#.ORDER_ROW_RESERVED  ORR
				WHERE
					ORDER_ID IS NULL
					AND SHIP_ID IS NULL
					AND INVOICE_ID IS NULL
			UNION ALL
				SELECT
					0 AS REAL_STOCK,
					0 AS PRODUCT_STOCK,
					(STOCK_ARTIR-STOCK_AZALT) AS RESERVED_STOCK,
					STOCK_ARTIR AS PURCHASE_PROD_STOCK,
					STOCK_AZALT AS RESERVED_PROD_STOCK,
					0  AS RESERVE_SALE_ORDER_STOCK,
					0 AS NOSALE_STOCK,
					0 AS BELONGTO_INSTITUTION_STOCK,
					0  AS RESERVE_PURCHASE_ORDER_STOCK,
					(STOCK_ARTIR-STOCK_AZALT)  AS PRODUCTION_ORDER_STOCK,
					0 AS NOSALE_RESERVED_STOCK,
					STOCK_ID,
					PRODUCT_ID
				FROM
					#new_dsn3#.GET_PRODUCTION_RESERVED
		) T1
		GROUP BY
			PRODUCT_ID, 
			STOCK_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_STOCK_LAST_SHELF] AS
		SELECT 
			SUM(REAL_STOCK) REAL_STOCK,
			SUM(PRODUCT_STOCK) PRODUCT_STOCK,
			SUM(RESERVED_STOCK) RESERVED_STOCK,
			SUM(PRODUCT_STOCK+RESERVED_STOCK) SALEABLE_STOCK,
			STOCK_ID,
			PRODUCT_ID,		
			SHELF_NUMBER
		FROM
		(
			SELECT
				(SR.STOCK_IN - SR.STOCK_OUT) AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				0 AS RESERVED_STOCK,
				0 AS SALEABLE_STOCK,
				SR.STOCK_ID,
				SR.PRODUCT_ID,
				SR.SHELF_NUMBER
			FROM
				STOCKS_ROW SR
			WHERE
				SR.SHELF_NUMBER IS NOT NULL
		UNION ALL
			SELECT
				(SR.STOCK_IN - SR.STOCK_OUT) AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				0 AS RESERVED_STOCK,
				0 AS SALEABLE_STOCK,
				SR.STOCK_ID,
				SR.PRODUCT_ID,
				''  AS SHELF_NUMBER
			FROM
				STOCKS_ROW SR
			WHERE
				UPD_ID IS NULL
		UNION ALL
			SELECT
				0 AS REAL_STOCK,
				(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,
				0 AS RESERVED_STOCK,
				0 AS SALEABLE_STOCK,
				SR.STOCK_ID,
				SR.PRODUCT_ID,
				SR.SHELF_NUMBER
			FROM
				#new_dsn3#.PRODUCT_PLACE PP,
				STOCKS_ROW SR
			WHERE
				SR.SHELF_NUMBER = PP.PRODUCT_PLACE_ID
		UNION ALL
			SELECT
				0 AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				((RESERVE_STOCK_OUT-STOCK_OUT)*-1) AS RESERVED_STOCK,
				0 AS SALEABLE_STOCK,
				ORR.STOCK_ID,
				ORR.PRODUCT_ID,
				ORDS_R.SHELF_NUMBER
			FROM
				#new_dsn3#.GET_ORDER_ROW_RESERVED ORR, 
				#new_dsn3#.ORDERS ORDS,
				#new_dsn3#.ORDER_ROW ORDS_R
			WHERE	
				ORDS.RESERVED = 1 AND 
				ORDS.ORDER_STATUS = 1 AND	
				ORDS_R.ORDER_ID = ORDS.ORDER_ID AND
				ORDS_R.SHELF_NUMBER IS NOT NULL AND
				ORR.ORDER_ID = ORDS.ORDER_ID AND
				((RESERVE_STOCK_IN-STOCK_IN)>0 OR (RESERVE_STOCK_OUT-STOCK_OUT)>0)			
		UNION ALL
			SELECT
				0 AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				(RESERVE_STOCK_IN-STOCK_IN) AS RESERVED_STOCK,
				0 AS SALEABLE_STOCK,
				ORR.STOCK_ID,
				ORR.PRODUCT_ID,
				ORDS_R.SHELF_NUMBER
			FROM
				#new_dsn3#.GET_ORDER_ROW_RESERVED ORR, 
				#new_dsn3#.ORDERS ORDS,
				#new_dsn3#.ORDER_ROW ORDS_R,
				#new_dsn#.STOCKS_LOCATION SL
			WHERE
				ORDS.DELIVER_DEPT_ID=SL.DEPARTMENT_ID AND
				ORDS.LOCATION_ID=SL.LOCATION_ID AND
				SL.NO_SALE = 0 AND
				ORDS.PURCHASE_SALES=0 AND
				ORDS.ORDER_ZONE=0 AND	
				ORDS.RESERVED = 1 AND 
				ORDS.ORDER_STATUS = 1 AND	
				ORDS_R.ORDER_ID = ORDS.ORDER_ID AND
				ORDS_R.SHELF_NUMBER IS NOT NULL AND
				ORR.ORDER_ID = ORDS.ORDER_ID AND
				(RESERVE_STOCK_IN-STOCK_IN)>0			
		) T1
		GROUP BY
			STOCK_ID,
			PRODUCT_ID,		
			SHELF_NUMBER

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_STOCK_LAST_SPECT] AS
		SELECT
			SUM(REAL_STOCK) REAL_STOCK,
			SUM(PRODUCT_STOCK) PRODUCT_STOCK,
			SUM(PRODUCT_STOCK+RESERVED_STOCK) SALEABLE_STOCK,
			SUM(PURCHASE_ORDER_STOCK) PURCHASE_ORDER_STOCK,
			PRODUCT_ID,
			STOCK_ID,
			SPECT_MAIN_ID
		FROM
		(
			SELECT
				(STOCK_IN - STOCK_OUT) AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				0 AS RESERVED_STOCK,
				0 AS SALE_ORDER_STOCK,
				0 AS PURCHASE_ORDER_STOCK,
				SR.PRODUCT_ID, 
				SR.STOCK_ID,
				SR.SPECT_VAR_ID SPECT_MAIN_ID
			FROM			
				STOCKS_ROW SR
		UNION ALL
			SELECT
				0 AS REAL_STOCK,
				(STOCK_IN - STOCK_OUT) AS PRODUCT_STOCK,
				0 AS RESERVED_STOCK,
				0 AS SALE_ORDER_STOCK,
				0 AS PURCHASE_ORDER_STOCK,
				SR.PRODUCT_ID, 
				SR.STOCK_ID,
				SR.SPECT_VAR_ID SPECT_MAIN_ID
			FROM			
				#new_dsn#.STOCKS_LOCATION SL,
				STOCKS_ROW SR
			WHERE			
				SR.STORE =SL.DEPARTMENT_ID
				AND SR.STORE_LOCATION=SL.LOCATION_ID
				AND SL.NO_SALE = 0
		UNION ALL
			SELECT
				0 AS REAL_STOCK,
				-1*(STOCK_IN - STOCK_OUT) AS PRODUCT_STOCK,
				0 AS RESERVED_STOCK,
				0 AS SALE_ORDER_STOCK,
				0 AS PURCHASE_ORDER_STOCK,
				SR.PRODUCT_ID, 
				SR.STOCK_ID,
				SR.SPECT_VAR_ID SPECT_MAIN_ID
			FROM
				STOCKS_ROW SR,
				#new_dsn#.STOCKS_LOCATION SL 
			WHERE	
				SR.STORE = SL.DEPARTMENT_ID AND
				SR.STORE_LOCATION = SL.LOCATION_ID AND
				ISNULL(SL.IS_SCRAP,0)=1	
	UNION ALL
			SELECT
				0 AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)*-1)  AS RESERVED_STOCK,
				0 AS SALE_ORDER_STOCK,
				ORR.RESERVE_STOCK_IN  AS PURCHASE_ORDER_STOCK,
				ORR.PRODUCT_ID, 
				ORR.STOCK_ID,
				(SELECT SPECT_MAIN_ID FROM #new_dsn3#.SPECTS WHERE SPECT_VAR_ID=ORR.SPECT_VAR_ID) SPECT_MAIN_ID
			FROM
				#new_dsn3#.GET_ORDER_ROW_RESERVED ORR, 
				#new_dsn3#.ORDERS ORDS
			WHERE
				ORDS.RESERVED = 1 AND 
				ORDS.ORDER_STATUS = 1 AND	
				ORR.ORDER_ID = ORDS.ORDER_ID AND
				((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0 OR (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0)	
		UNION ALL
			SELECT
				0 AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				(ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) AS RESERVED_STOCK,
				0 AS SALE_ORDER_STOCK,
				0 AS PURCHASE_ORDER_STOCK,
				ORR.PRODUCT_ID, 
				ORR.STOCK_ID,
				(SELECT SPECT_MAIN_ID FROM #new_dsn3#.SPECTS WHERE SPECT_VAR_ID=ORR.SPECT_VAR_ID) SPECT_MAIN_ID
			FROM
				#new_dsn#.STOCKS_LOCATION SL,
				#new_dsn3#.GET_ORDER_ROW_RESERVED ORR, 
				#new_dsn3#.ORDERS ORDS
			WHERE
				ORDS.DELIVER_DEPT_ID=SL.DEPARTMENT_ID AND
				ORDS.LOCATION_ID=SL.LOCATION_ID AND
				SL.NO_SALE = 0 AND
				ORDS.PURCHASE_SALES=0 AND
				ORDS.ORDER_ZONE=0 AND	
				ORDS.RESERVED = 1 AND 
				ORDS.ORDER_STATUS = 1 AND	
				ORR.ORDER_ID = ORDS.ORDER_ID AND
				(ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0
		UNION ALL
			SELECT
				0 AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				(STOCK_ARTIR-STOCK_AZALT) AS RESERVED_STOCK,
				0 AS SALE_ORDER_STOCK,
				0 AS PURCHASE_ORDER_STOCK,
				GRS.PRODUCT_ID, 
				GRS.STOCK_ID,
				GRS.SPECT_MAIN_ID SPECT_MAIN_ID
			FROM
				#new_dsn3#.GET_PRODUCTION_RESERVED_SPECT GRS
			
		) T1
		GROUP BY
			PRODUCT_ID, 
			STOCK_ID,
			SPECT_MAIN_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_STOCK_LAST_SPECT_LOCATION_REPORT] AS
				SELECT
				SUM(REAL_STOCK) REAL_STOCK,
				SUM(PRODUCT_STOCK) PRODUCT_STOCK,
				SUM(PRODUCT_STOCK+RESERVED_STOCK) SALEABLE_STOCK,
				SUM(PURCHASE_ORDER_STOCK) PURCHASE_ORDER_STOCK,
				PRODUCT_ID,
				STOCK_ID,
				SPECT_MAIN_ID,
				DEPARTMENT_ID,
				LOCATION_ID
			FROM
			(
				SELECT
					(STOCK_IN - STOCK_OUT) AS REAL_STOCK,
					0 AS PRODUCT_STOCK,
					0 AS RESERVED_STOCK,
					0 AS SALE_ORDER_STOCK,
					0 AS PURCHASE_ORDER_STOCK,
					SR.PRODUCT_ID, 
					SR.STOCK_ID,
					SR.SPECT_VAR_ID SPECT_MAIN_ID,
					SR.STORE AS DEPARTMENT_ID,
					SR.STORE_LOCATION AS LOCATION_ID
				FROM			
					STOCKS_ROW SR
			UNION ALL
				SELECT
					0 AS REAL_STOCK,
					(STOCK_IN - STOCK_OUT) AS PRODUCT_STOCK,
					0 AS RESERVED_STOCK,
					0 AS SALE_ORDER_STOCK,
					0 AS PURCHASE_ORDER_STOCK,
					SR.PRODUCT_ID, 
					SR.STOCK_ID,
					SR.SPECT_VAR_ID SPECT_MAIN_ID,
					SR.STORE AS DEPARTMENT_ID,
					SR.STORE_LOCATION AS LOCATION_ID
				FROM			
					#new_dsn#.STOCKS_LOCATION SL,
					STOCKS_ROW SR
				WHERE			
					SR.STORE =SL.DEPARTMENT_ID
					AND SR.STORE_LOCATION=SL.LOCATION_ID
					AND SL.NO_SALE = 0
			UNION ALL
				SELECT
					0 AS REAL_STOCK,
					-1*(STOCK_IN - STOCK_OUT) AS PRODUCT_STOCK,
					0 AS RESERVED_STOCK,
					0 AS SALE_ORDER_STOCK,
					0 AS PURCHASE_ORDER_STOCK,
					SR.PRODUCT_ID, 
					SR.STOCK_ID,
					SR.SPECT_VAR_ID SPECT_MAIN_ID,
					SR.STORE AS DEPARTMENT_ID,
					SR.STORE_LOCATION AS LOCATION_ID
				FROM
					STOCKS_ROW SR,
					#new_dsn#.STOCKS_LOCATION SL 
				WHERE	
					SR.STORE = SL.DEPARTMENT_ID AND
					SR.STORE_LOCATION = SL.LOCATION_ID AND
					ISNULL(SL.IS_SCRAP,0)=1	
			UNION ALL
				SELECT
					0 AS REAL_STOCK,
					0 AS PRODUCT_STOCK,
					((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)*-1)  AS RESERVED_STOCK,
					0 AS SALE_ORDER_STOCK,
					ORR.RESERVE_STOCK_IN  AS PURCHASE_ORDER_STOCK,
					ORR.PRODUCT_ID, 
					ORR.STOCK_ID,
					(SELECT SPECT_MAIN_ID FROM #new_dsn3#.SPECTS WHERE SPECT_VAR_ID=ORR.SPECT_VAR_ID) SPECT_MAIN_ID,
					ORDS.DELIVER_DEPT_ID AS DEPARTMENT_ID,
					ORDS.LOCATION_ID AS LOCATION_ID
				FROM
					#new_dsn3#.GET_ORDER_ROW_RESERVED ORR, 
					#new_dsn3#.ORDERS ORDS
				WHERE
					ORDS.RESERVED = 1 AND 
					ORDS.ORDER_STATUS = 1 AND	
					ORR.ORDER_ID = ORDS.ORDER_ID AND
					((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0 OR (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0)	
			UNION ALL
				SELECT
					0 AS REAL_STOCK,
					0 AS PRODUCT_STOCK,
					(ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) AS RESERVED_STOCK,
					0 AS SALE_ORDER_STOCK,
					0 AS PURCHASE_ORDER_STOCK,
					ORR.PRODUCT_ID, 
					ORR.STOCK_ID,
					(SELECT SPECT_MAIN_ID FROM #new_dsn3#.SPECTS WHERE SPECT_VAR_ID=ORR.SPECT_VAR_ID) SPECT_MAIN_ID,
					ORDS.DELIVER_DEPT_ID AS DEPARTMENT_ID,
					ORDS.LOCATION_ID AS LOCATION_ID
				FROM
					#new_dsn#.STOCKS_LOCATION SL,
					#new_dsn3#.GET_ORDER_ROW_RESERVED ORR, 
					#new_dsn3#.ORDERS ORDS
				WHERE
					ORDS.DELIVER_DEPT_ID=SL.DEPARTMENT_ID AND
					ORDS.LOCATION_ID=SL.LOCATION_ID AND
					SL.NO_SALE = 0 AND
					ORDS.PURCHASE_SALES=0 AND
					ORDS.ORDER_ZONE=0 AND	
					ORDS.RESERVED = 1 AND 
					ORDS.ORDER_STATUS = 1 AND	
					ORR.ORDER_ID = ORDS.ORDER_ID AND
					(ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0
			UNION ALL
				SELECT
					0 AS REAL_STOCK,
					0 AS PRODUCT_STOCK,
					(STOCK_ARTIR-STOCK_AZALT) AS RESERVED_STOCK,
					0 AS SALE_ORDER_STOCK,
					0 AS PURCHASE_ORDER_STOCK,
					GRS.PRODUCT_ID, 
					GRS.STOCK_ID,
					GRS.SPECT_MAIN_ID SPECT_MAIN_ID,
					DEPARTMENT_ID,
					LOCATION_ID
				FROM
					#new_dsn3#.GET_PRODUCTION_RESERVED_SPECT_LOCATION GRS
			) T1
			GROUP BY
				PRODUCT_ID, 
				STOCK_ID,
				SPECT_MAIN_ID,
				DEPARTMENT_ID,
				LOCATION_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_STOCK_LOCATION] AS
			SELECT
				SUM(SR.STOCK_IN - SR.STOCK_OUT) AS TOTAL_STOCK,
				S.PRODUCT_ID,
				S.STOCK_ID,
				S.STOCK_CODE,
				S.PROPERTY,
				S.STOCK_STATUS,
				S.BARCOD
			FROM
				#new_dsn3#.STOCKS S,
				#new_dsn#.STOCKS_LOCATION SL,
				STOCKS_ROW SR
			WHERE
				S.STOCK_ID = SR.STOCK_ID AND
				SR.STORE =SL.DEPARTMENT_ID
				AND SR.STORE_LOCATION=SL.LOCATION_ID
				AND SL.NO_SALE = 0
			GROUP BY
				S.PRODUCT_ID,
				S.STOCK_ID,
				S.STOCK_CODE, 
				S.PROPERTY,
				S.STOCK_STATUS,
				S.BARCOD

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_STOCK_LOCATION_SPECT] AS
			SELECT
				SUM(SR.STOCK_IN - SR.STOCK_OUT) AS TOTAL_STOCK, 
				S.PRODUCT_ID, 
				S.STOCK_ID, 
				S.STOCK_CODE, 
				S.PROPERTY,
				S.STOCK_STATUS, 
				S.BARCOD,
				SR.SPECT_VAR_ID
			FROM
				#new_prod_db#.STOCKS S,		
				#new_dsn#.STOCKS_LOCATION SL,
				STOCKS_ROW SR
			WHERE
				S.STOCK_ID = SR.STOCK_ID AND	
				SR.STORE =SL.DEPARTMENT_ID
				AND SR.STORE_LOCATION=SL.LOCATION_ID
				AND SL.NO_SALE = 0
			GROUP BY
				S.PRODUCT_ID, 
				S.STOCK_ID, 
				S.STOCK_CODE, 
				S.PROPERTY,
				S.STOCK_STATUS, 
				S.BARCOD,
				SR.SPECT_VAR_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_STOCK_LOCATION_SPECT_TOTAL] AS
			SELECT
				SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK, 
				S.PRODUCT_ID, 
				S.STOCK_ID, 
				S.STOCK_CODE, 
				S.PROPERTY,
				S.STOCK_STATUS, 
				S.BARCOD,
				SR.SPECT_VAR_ID,
				SR.STORE,
				SR.STORE_LOCATION
			FROM
				#new_prod_db#.STOCKS S,
				STOCKS_ROW SR
			WHERE
				S.STOCK_ID = SR.STOCK_ID	
			GROUP BY
				S.PRODUCT_ID,
				S.STOCK_ID,
				S.STOCK_CODE,
				S.PROPERTY,
				S.STOCK_STATUS, 
				S.BARCOD,
				SR.SPECT_VAR_ID,
				SR.STORE,
				SR.STORE_LOCATION

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_STOCK_LOCATION_TOTAL] AS
			SELECT
				SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK, 
				S.PRODUCT_ID, 
				S.STOCK_ID, 
				S.STOCK_CODE, 
				S.PROPERTY,
				S.STOCK_STATUS, 
				S.BARCOD,
				SR.STORE,
				SR.STORE_LOCATION
			FROM
				#new_prod_db#.STOCKS S,
				STOCKS_ROW SR
			WHERE
				S.STOCK_ID = SR.STOCK_ID	
			GROUP BY
				S.PRODUCT_ID,
				S.STOCK_ID,
				S.STOCK_CODE,
				S.PROPERTY,
				S.STOCK_STATUS, 
				S.BARCOD,
				SR.STORE,
				SR.STORE_LOCATION

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_STOCK_PRODUCT] AS
			SELECT
				ROUND(SUM(SR.STOCK_IN - SR.STOCK_OUT),4) AS PRODUCT_STOCK, 
				S.PRODUCT_ID, 
				S.STOCK_ID, 
				S.STOCK_CODE, 
				S.PROPERTY, 
				S.BARCOD,
				SR.STORE AS DEPARTMENT_ID
			FROM
				#new_prod_db#.STOCKS S,
				STOCKS_ROW SR
			WHERE
				S.STOCK_ID = SR.STOCK_ID
			GROUP BY
				S.PRODUCT_ID, 
				S.STOCK_ID, 
				S.STOCK_CODE, 
				S.PROPERTY, 
				S.BARCOD, 
				SR.STORE

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_STOCK_PRODUCT_BRANCH] AS
		SELECT
			SUM(Q1.STOCK_IN - Q1.STOCK_OUT) AS PRODUCT_STOCK, 
			Q1.PRODUCT_ID, 
			Q1.STOCK_ID, 
			Q1.STOCK_CODE, 
			Q1.PROPERTY, 
			Q1.BARCOD, 
			Q1.BRANCH_ID	
		FROM
			(SELECT
				SR.STOCK_IN,
				SR.STOCK_OUT, 
				S.PRODUCT_ID, 
				S.STOCK_ID, 
				S.STOCK_CODE, 
				S.PROPERTY, 
				S.BARCOD, 
				D.BRANCH_ID
			FROM
				#new_dsn#.DEPARTMENT D,
				#new_dsn3#.STOCKS S,
				STOCKS_ROW SR
			WHERE
				S.STOCK_ID = SR.STOCK_ID AND
				D.DEPARTMENT_ID = SR.STORE AND
				SR.UPD_ID IS NOT NULL
			UNION ALL
			SELECT
				SR.STOCK_IN,
				SR.STOCK_OUT, 
				S.PRODUCT_ID, 
				S.STOCK_ID, 
				S.STOCK_CODE, 
				S.PROPERTY, 
				S.BARCOD, 
				PB.BRANCH_ID
			FROM
				#new_dsn3#.STOCKS S,
				STOCKS_ROW SR,
				#new_prod_db#.PRODUCT_BRANCH PB
			WHERE
				S.STOCK_ID = SR.STOCK_ID AND
				SR.UPD_ID IS NULL AND
				PB.PRODUCT_ID = S.PRODUCT_ID
			)Q1
		GROUP BY
			Q1.PRODUCT_ID, 
			Q1.STOCK_ID, 
			Q1.STOCK_CODE, 
			Q1.PROPERTY, 
			Q1.BARCOD,
			Q1.BRANCH_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_STOCK_PRODUCT_BRANCH_SPECT] AS
			SELECT
				SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK, 
				P.PRODUCT_ID, 
				S.STOCK_ID, 
				S.STOCK_CODE, 
				S.PROPERTY, 
				S.BARCOD, 
				B.BRANCH_ID, 
				B.BRANCH_NAME,
				SR.SPECT_VAR_ID
			FROM
				#new_dsn#.DEPARTMENT D,
				#new_dsn#.BRANCH B,
				#new_dsn3#.PRODUCT P,
				#new_dsn3#.STOCKS S,
				STOCKS_ROW SR
			WHERE
				P.PRODUCT_ID = S.PRODUCT_ID AND
				S.STOCK_ID = SR.STOCK_ID AND
				D.DEPARTMENT_ID = SR.STORE AND
				B.BRANCH_ID = D.BRANCH_ID
			GROUP BY
				P.PRODUCT_ID, 
				S.STOCK_ID, 
				S.STOCK_CODE, 
				S.PROPERTY, 
				S.BARCOD,
				B.BRANCH_ID, 
				B.BRANCH_NAME,
				SR.SPECT_VAR_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_STOCK_PRODUCT_LOT_NO] AS
			SELECT
				ROUND(SUM(SR.STOCK_IN - SR.STOCK_OUT),4) AS PRODUCT_STOCK, 
				S.PRODUCT_ID, 
				S.STOCK_ID, 
				S.STOCK_CODE, 
				S.PROPERTY, 
				S.BARCOD,
				SR.STORE AS DEPARTMENT_ID,
				SR.LOT_NO
			FROM
				#new_prod_db#.STOCKS S,
				STOCKS_ROW SR
			WHERE
				S.STOCK_ID = SR.STOCK_ID
			GROUP BY
				S.PRODUCT_ID, 
				S.STOCK_ID, 
				S.STOCK_CODE, 
				S.PROPERTY, 
				S.BARCOD, 
				SR.STORE,
				SR.LOT_NO
</cfquery>

<cfquery name="cr_view" datasource="#new_dsn2#">
CREATE  VIEW [GET_STOCK_PRODUCT_SPECT] AS
			SELECT
				SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK, 
				S.PRODUCT_ID, 
				S.STOCK_ID, 
				S.STOCK_CODE, 
				S.PROPERTY, 
				S.BARCOD,
				SR.STORE AS DEPARTMENT_ID,
				SR.SPECT_VAR_ID
			FROM
				#new_prod_db#.STOCKS S,
				STOCKS_ROW SR
			WHERE
				S.STOCK_ID = SR.STOCK_ID
			GROUP BY
				S.PRODUCT_ID, 
				S.STOCK_ID, 
				S.STOCK_CODE, 
				S.PROPERTY, 
				S.BARCOD, 
				SR.STORE,
				SR.SPECT_VAR_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_STOCK_SHELF] AS
			SELECT
				SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK, 
				SR.PRODUCT_ID, 
				SR.STOCK_ID,
				SR.DELIVER_DATE,
				--SR.STORE,
				--SR.STORE_LOCATION,
				SR.SHELF_NUMBER AS SHELF_ID	
			FROM			
				STOCKS_ROW SR
			WHERE
				ISNULL(SR.UPD_ID,0)<>0
			GROUP BY
				SR.PRODUCT_ID, 
				SR.STOCK_ID,
				SR.DELIVER_DATE,
				--SR.STORE,
				--SR.STORE_LOCATION,
				SR.SHELF_NUMBER

</cfquery>
 <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_STOCK_SHELF_ONLY] AS
		SELECT
            SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK, 
            SR.PRODUCT_ID, 
            SR.STOCK_ID,
            SR.SHELF_NUMBER AS SHELF_ID,
			SR.DELIVER_DATE
        FROM			
            STOCKS_ROW SR
        GROUP BY
            SR.PRODUCT_ID, 
            SR.STOCK_ID,
            SR.SHELF_NUMBER,
			SR.DELIVER_DATE

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [GET_STOCK_SPECT] AS
			SELECT
				SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK, 
				S.PRODUCT_ID, 
				S.STOCK_ID, 
				S.STOCK_CODE, 
				S.PROPERTY,
				S.STOCK_STATUS, 
				S.BARCOD,
				SR.SPECT_VAR_ID
			FROM
				#new_prod_db#.STOCKS S,
				STOCKS_ROW SR
			WHERE
				S.STOCK_ID = SR.STOCK_ID	
			GROUP BY
				S.PRODUCT_ID,
				S.STOCK_ID,
				S.STOCK_CODE,
				S.PROPERTY,
				S.STOCK_STATUS, 
				S.BARCOD,
				SR.SPECT_VAR_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [INVOICE_ROW_POS_SALES] AS
			SELECT
				S.STOCK_ID ,
				S.PRODUCT_ID ,
				S.COMPANY_ID ,
				SUM(IRP.AMOUNT) AS SATISMIKTAR ,
				IRP.PRICE ,
				SUM(IRP.NETTOTAL) AS SATISNET ,
				SUM(IRP.TAXTOTAL) AS SATISVERGI ,
				SUM(IRP.GROSSTOTAL) AS SATISTOPLAM ,
				I.INVOICE_ID ,
				I.INVOICE_NUMBER ,
				I.DEPARTMENT_ID ,
				I.INVOICE_DATE ,
				B.BRANCH_ID,
				S.PRODUCT_NAME + ' ' + S.PROPERTY AS PRODUCT_NAME,
				
				S.PRODUCT_CATID,
				S.STOCK_CODE,
				IRP.PRICE AS KDVLI_SATISFIYATI,
				IRP.UNIT,
				I.INVOICE_CAT,
				DEPARTMENT_HEAD,
				S.PRODUCT_MANAGER,
				S.STOCK_CODE AS PRODUCT_CODE,
				IRP.INVOICE_DATE AS INVOICE_ROW_DATE
			FROM
				#new_dsn3#.STOCKS S,
				#new_dsn#.COMPANY C,
				#new_dsn#.DEPARTMENT D,
				#new_dsn#.BRANCH B,
				INVOICE_ROW_POS IRP,
				INVOICE I
			WHERE 
				IRP.STOCK_ID = S.STOCK_ID AND	
				S.COMPANY_ID = C.COMPANY_ID AND
				I.INVOICE_ID = IRP.INVOICE_ID AND
				D.BRANCH_ID = B.BRANCH_ID AND
				I.DEPARTMENT_ID = D.DEPARTMENT_ID
			GROUP BY
				I.INVOICE_ID,
				I.INVOICE_NUMBER,
				I.DEPARTMENT_ID,
				I.INVOICE_DATE,
				IRP.PRICE,
				S.STOCK_ID,
				S.PRODUCT_ID,
				S.COMPANY_ID,
				B.BRANCH_ID,
				S.PRODUCT_NAME,
				S.PROPERTY,
				S.PRODUCT_CATID,
				S.STOCK_CODE,
				IRP.PRICE,
				IRP.UNIT,
				I.INVOICE_CAT,
				DEPARTMENT_HEAD,
				S.PRODUCT_MANAGER,	
				IRP.INVOICE_DATE

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [INVOICE_ROW_SALES] AS 
			SELECT
				S.STOCK_ID,
				S.PRODUCT_ID,
				S.COMPANY_ID,
				SUM(IR.AMOUNT) AS SATISMIKTAR, 
				IR.PRICE,
				SUM(IR.NETTOTAL) AS SATISNET,
				SUM(IR.DISCOUNTTOTAL) AS SATISINDIRIM,
				SUM(IR.TAXTOTAL) AS SATISVERGI,
				SUM(IR.GROSSTOTAL) AS SATISTOPLAM,
				I.INVOICE_ID,
				I.INVOICE_NUMBER,
				I.INVOICE_CAT,
				I.DEPARTMENT_ID, 
				I.INVOICE_DATE,
				B.BRANCH_ID,
				IR.UNIT,
				IR.UNIT_ID,
				S.PRODUCT_NAME + ' ' + S.PROPERTY AS PRODUCT_NAME,
				
				S.PRODUCT_CATID,
				S.STOCK_CODE,
				DEPARTMENT_HEAD,
				S.PRODUCT_MANAGER
			FROM 
				#new_dsn3#.PRODUCT_UNIT PU,	
				#new_dsn#.BRANCH B,
				#new_dsn#.DEPARTMENT D, 	
				#new_dsn3#.STOCKS S,
				#new_dsn#.COMPANY C,
				INVOICE I,
				INVOICE_ROW IR 
			WHERE 
				S.COMPANY_ID = C.COMPANY_ID AND
				D.BRANCH_ID = B.BRANCH_ID AND		
				I.DEPARTMENT_ID = D.DEPARTMENT_ID AND
				IR.UNIT_ID = PU.PRODUCT_UNIT_ID AND
				S.PRODUCT_ID = IR.PRODUCT_ID AND
				IR.STOCK_ID = S.STOCK_ID AND 
				I.INVOICE_ID = IR.INVOICE_ID
			GROUP BY 
				I.INVOICE_ID, 
				I.INVOICE_NUMBER, 
				I.DEPARTMENT_ID, 
				I.INVOICE_DATE, 
				IR.PRICE, 
				S.STOCK_ID, 
				S.PRODUCT_ID, 
				S.COMPANY_ID,
				B.BRANCH_ID, 
				IR.UNIT, IR.UNIT_ID, 
				S.PRODUCT_NAME, 
				S.PROPERTY, 
				I.INVOICE_CAT, 
				S.PRODUCT_CATID, 
				S.STOCK_CODE,
				DEPARTMENT_HEAD,
				S.PRODUCT_MANAGER

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [STOCK_IN_OUT] AS
			SELECT
				SUM(SR.STOCK_IN) AS GIRIS, 
				SUM(SR.STOCK_OUT) AS CIKIS, 
				S.PROPERTY, 
				SUM(SR.STOCK_IN - SR.STOCK_OUT) AS STOCK_, 
				S.STOCK_ID, 
				S.PRODUCT_NAME
			FROM
				#new_dsn3#.STOCKS S,		
				STOCKS_ROW SR
			WHERE
				(SR.UPD_ID IS NOT NULL) AND 
				S.STOCK_ID = SR.STOCK_ID
			GROUP BY
				S.STOCK_ID, S.PRODUCT_NAME, S.PROPERTY

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [STOCKS_SALES] AS
			SELECT
				SUM(SR.STOCK_OUT) AS SATIS, 
				S.PRODUCT_ID, 
				S.STOCK_ID, 
				CAST(S.PRODUCT_NAME AS NVARCHAR(50)) + ' ' + CAST(S.PROPERTY AS NVARCHAR(50)) AS STOCK_NAME, 
				
				D.DEPARTMENT_ID, 
				S.PRODUCT_NAME, 
				D.DEPARTMENT_HEAD
			FROM
				STOCKS_ROW SR,
				#new_dsn3#.STOCKS S,		
				#new_dsn#.DEPARTMENT D
			WHERE
				SR.PROCESS_TYPE IN (70, 71, 88)
				AND SR.STORE = D.DEPARTMENT_ID
				AND SR.STOCK_ID = S.STOCK_ID
			GROUP BY
				S.PRODUCT_ID, 
				S.STOCK_ID, 
				D.DEPARTMENT_HEAD, 
				S.PRODUCT_NAME, 
				S.PROPERTY, 
				D.DEPARTMENT_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [VOUCHER_IN_BANK] AS
			SELECT
				0 AS ALACAK,
				SUM(VOUCHER.OTHER_MONEY_VALUE) AS BORC,
				ACCOUNTS.ACCOUNT_ID, 
				ACCOUNTS.ACCOUNT_NAME
			FROM
				#new_dsn3#.ACCOUNTS AS ACCOUNTS,
				VOUCHER_PAYROLL,
				VOUCHER,
				VOUCHER_HISTORY
			WHERE
				VOUCHER.VOUCHER_STATUS_ID = 2 AND
				VOUCHER_HISTORY.VOUCHER_ID = VOUCHER.VOUCHER_ID AND
				VOUCHER_HISTORY.PAYROLL_ID = VOUCHER_PAYROLL.ACTION_ID AND
				ACCOUNTS.ACCOUNT_ID = VOUCHER_PAYROLL.PAYROLL_ACCOUNT_ID  AND
				VOUCHER_HISTORY.HISTORY_ID = (SELECT MAX(VH.HISTORY_ID) FROM VOUCHER_HISTORY VH WHERE VH.VOUCHER_ID = VOUCHER.VOUCHER_ID AND VH.STATUS = 2)
			GROUP BY
				ACCOUNTS.ACCOUNT_ID, ACCOUNTS.ACCOUNT_NAME

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [VOUCHER_IN_GUARANTEE] AS
			SELECT
				SUM(VOUCHER.OTHER_MONEY_VALUE) AS TEMINAT_SENET,
				ACCOUNTS.ACCOUNT_ID, 
				ACCOUNTS.ACCOUNT_NAME
			FROM
				#new_dsn3#.ACCOUNTS AS ACCOUNTS,
				VOUCHER_PAYROLL,
				VOUCHER,
				VOUCHER_HISTORY
			WHERE
				VOUCHER.VOUCHER_STATUS_ID = 13 AND
				VOUCHER_HISTORY.VOUCHER_ID = VOUCHER.VOUCHER_ID AND
				VOUCHER_HISTORY.PAYROLL_ID = VOUCHER_PAYROLL.ACTION_ID AND
				ACCOUNTS.ACCOUNT_ID = VOUCHER_PAYROLL.PAYROLL_ACCOUNT_ID  AND
				VOUCHER_HISTORY.HISTORY_ID = (SELECT MAX(VH.HISTORY_ID) FROM VOUCHER_HISTORY VH WHERE VH.VOUCHER_ID = VOUCHER.VOUCHER_ID AND VH.STATUS = 13)
			GROUP BY
				ACCOUNTS.ACCOUNT_ID, ACCOUNTS.ACCOUNT_NAME

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [VOUCHER_TO_GET] AS
			SELECT
				0 AS BORC, 
				SUM(VOUCHER.OTHER_MONEY_VALUE) AS ALACAK
			FROM 
				VOUCHER,
				VOUCHER_HISTORY,
				VOUCHER_PAYROLL
			WHERE
				VOUCHER.VOUCHER_STATUS_ID = 1 AND 
				VOUCHER_HISTORY.VOUCHER_ID = VOUCHER.VOUCHER_ID AND
				VOUCHER_HISTORY.PAYROLL_ID = VOUCHER_PAYROLL.ACTION_ID

</cfquery>
    <cfquery name="cr_view" datasource="#new_dsn2#">
		CREATE VIEW [VOUCHER_TO_PAY] AS
			SELECT
				0 AS ALACAK, 
				SUM(VOUCHER.OTHER_MONEY_VALUE) AS BORC
			FROM 
				VOUCHER,
				VOUCHER_HISTORY,
				VOUCHER_PAYROLL
			WHERE
				VOUCHER.VOUCHER_STATUS_ID = 6 AND 
				VOUCHER_HISTORY.VOUCHER_ID = VOUCHER.VOUCHER_ID AND
				VOUCHER_HISTORY.PAYROLL_ID = VOUCHER_PAYROLL.ACTION_ID
</cfquery>

<cfquery name="get_pre_period" datasource="#dsn#">
		SELECT 
			* 
		FROM 
			SETUP_PERIOD
		WHERE
			PERIOD_YEAR IN (#get_periods.period_year-1#) 
			AND OUR_COMPANY_ID = #get_periods.OUR_COMPANY_ID#
	</cfquery>
	<cfif get_pre_period.recordcount> <!--- onceki donem varsa, o donemdeki GET_CONSIGMENT_DETAIL viewinden yeni view olusturuluyor --->
		<cfquery name="ins_view_main_db" datasource="#new_dsn2#">
			CREATE VIEW GET_PRE_PERIOD_CONSIGMENT_DETAIL AS
				SELECT
					STOCK_IN,
					STOCK_OUT,
					ACTION_DATE,
					PRODUCT_ID,
					STOCK_ID,
					SPECT_MAIN_ID,
					DEPARTMENT_ID,
					LOCATION_ID
				FROM
					#dsn#_#get_pre_period.PERIOD_YEAR#_#get_pre_period.OUR_COMPANY_ID#.GET_CONSIGMENT_DETAIL
		</cfquery>
	<cfelse><!--- eğer bir önceki dönem yoksa,wievden boş kayıt gelmesi için aşağıda  PRODUCT_ID IS NULL diye bakılıyor... --->
		<cfquery name="ins_view_main_db" datasource="#new_dsn2#">
			CREATE VIEW GET_PRE_PERIOD_CONSIGMENT_DETAIL AS
				SELECT
					STOCK_IN,
					STOCK_OUT,
					ACTION_DATE,
					PRODUCT_ID,
					STOCK_ID,
					SPECT_MAIN_ID,
					DEPARTMENT_ID,
					LOCATION_ID
				FROM
					GET_CONSIGMENT_DETAIL
				WHERE
					PRODUCT_ID IS NULL
		</cfquery>
	</cfif>

ok --> <cfoutput>#get_periods.currentrow#</cfoutput><br>
	</cfloop>
</cfif>






