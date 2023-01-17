<cfsetting showdebugoutput="no">
<cfparam name="attributes.module_id_control" default="22">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_money2" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.start_date1" default="">
<cfparam name="attributes.finish_date1" default="">
<cfparam name="attributes.output_date_1" default="">
<cfparam name="attributes.output_date_2" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.location_id" default="">
<cfparam name="attributes.department_name" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.expense_item_id" default="">
<cfparam name="attributes.expense_center_id" default="">
<cfparam name="attributes.amor_method" default="">
<cfparam name="attributes.report_type" default="1">
<cfparam name="attributes.account_id" default="">
<cfparam name="attributes.account_name" default="">
<cfparam name="attributes.debt_account_id" default="">
<cfparam name="attributes.debt_account_name" default="">
<cfparam name="attributes.claim_account_id" default="">
<cfparam name="attributes.claim_account_name" default="">
<cfparam name="attributes.last_inv_status" default="">
<cfparam name="attributes.subscription_id" default="">
<cfparam name="attributes.subscription_no" default="">
<cfparam name="attributes.inventory_type" default="">
<cfparam name="attributes.inventory_cat_id" default="">
<cfparam name="attributes.inventory_cat" default="">
<cfparam name="attributes.inventories" default="2">
<cfparam name="attributes.accounting_target" default="0">
<cfparam name="attributes.is_excel" default="">
<cfparam name="type_" default="0">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfif attributes.is_excel eq 1>
	<cfset attributes.maxrows="100000">
</cfif>
<cfquery name="get_expense_item" datasource="#dsn2#">
	SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS ORDER BY EXPENSE_ITEM_NAME
</cfquery>
<cfquery name="get_expense_center" datasource="#dsn2#">
	SELECT EXPENSE_ID, EXPENSE,EXPENSE_CODE FROM EXPENSE_CENTER ORDER BY EXPENSE
</cfquery>
<cfquery name="get_period" datasource="#dsn#">
	SELECT * FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #session.ep.company_id# 
</cfquery>
<cfquery name="get_inventory_cat" datasource="#dsn3#">
	SELECT INVENTORY_CAT_ID, INVENTORY_CAT, HIERARCHY FROM SETUP_INVENTORY_CAT ORDER BY HIERARCHY
</cfquery>

<cfset output_type = '1182,66,83'>
<cfset input_type = '118,82,1181'>
<cfif isdefined("attributes.form_submitted")>
	<cfscript>
		if(isDefined('attributes.accounting_target') and listfind('1,2',attributes.accounting_target)) {
			go_ifrs = 1;
		} else {
			go_ifrs = 0;
		}
	</cfscript>
	<cfparam name="attributes.page" default=1>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfif isdate(attributes.start_date)><cf_date tarih = "attributes.start_date"></cfif>
	<cfif isdate(attributes.finish_date)><cf_date tarih = "attributes.finish_date"></cfif>
	<cfif isdate(attributes.start_date1)><cf_date tarih = "attributes.start_date1"></cfif>
	<cfif isdate(attributes.finish_date1)><cf_date tarih = "attributes.finish_date1"></cfif>
	<cfif isdate(attributes.output_date_1)><cf_date tarih = "attributes.output_date_1"></cfif>	
	<cfif isdate(attributes.output_date_2)><cf_date tarih = "attributes.output_date_2"></cfif>	
	<cfquery name="check_table" datasource="#dsn3#">
		IF EXISTS (SELECT * FROM tempdb.sys.tables where name = '####detail_inventory_report_#session.ep.userid#' )
			DROP TABLE tempdb.####detail_inventory_report_#session.ep.userid#
	</cfquery>
	<cfquery name="get_all_inventory" datasource="#dsn3#" result="xx">
		SELECT * 
			INTO tempdb.####detail_inventory_report_#session.ep.userid#
		FROM 
		(
		<cfif (attributes.report_type eq 2 and attributes.inventories eq 1) or attributes.report_type eq 1>
			<cfloop query="get_period">
			SELECT
				(SELECT TOP 1 INVENTORY_ID FROM INVENTORY_ROW WHERE INVENTORY_ID = I.INVENTORY_ID AND PROCESS_TYPE = 1181 AND PERIOD_ID = #session.ep.period_id#) as DEVIR,
				<cfif isdefined("attributes.is_entry_date_info") and len(attributes.finish_date1)>
					(SELECT SUM(INVENTORY_ROW3.STOCK_IN-ISNULL(INVENTORY_ROW3.STOCK_OUT,0)) FROM INVENTORY_ROW INVENTORY_ROW3 WHERE INVENTORY_ROW3.INVENTORY_ID = I.INVENTORY_ID AND INVENTORY_ROW3.ACTION_DATE <= #attributes.finish_date1#) AS ROW_AMOUNT,
				<cfelse>
					<cfif attributes.report_type eq 1>
						I.QUANTITY ROW_AMOUNT,
					<cfelse>
						IR.QUANTITY ROW_AMOUNT,
					</cfif>
				</cfif> 
				I.INVENTORY_ID,
				I.INVENTORY_NAME,
				I.INVENTORY_NUMBER,
				I.PROCESS_CAT,
				I.QUANTITY,
				I.AMORTIZATON_ESTIMATE,
				I.AMORTIZATON_METHOD,
				I.AMOUNT,
				I.ENTRY_DATE,
				I.COMP_ID,
				I.COMP_PARTNER_ID,
				I.LAST_INVENTORY_VALUE,
				I.ACCOUNT_ID,
				I.CLAIM_ACCOUNT_ID,
				I.DEBT_ACCOUNT_ID,
				I.AMOUNT_2,
				I.RECORD_DATE,
				I.LAST_INVENTORY_VALUE_2,
				<cfif go_ifrs eq 0>
					I.INVENTORY_DURATION INVENTORY_DURATION,
				<cfelse>
					I.INVENTORY_DURATION_IFRS INVENTORY_DURATION,
				</cfif>
				I.ACCOUNT_PERIOD,
				I.EXPENSE_ITEM_ID,
				I.EXPENSE_CENTER_ID,
				I.PROJECT_ID,
				I.CONSUMER_ID,
				I.AMORTIZATION_COUNT,
				I.AMORT_LAST_VALUE,
				I.AMORTIZATION_TYPE,
				ISNULL((
					SELECT 
						SUM(II.PERIODIC_AMORT_VALUE*INV_QUANTITY) AS FIRST_VALUE
					FROM 
						<cfif go_ifrs eq 0>
							INVENTORY_AMORTIZATON II,
						<cfelse>
							INVENTORY_AMORTIZATON_IFRS II,
						</cfif>
						INVENTORY_AMORTIZATION_MAIN IM
					WHERE 
						II.INVENTORY_ID = I.INVENTORY_ID
						AND II.INV_AMORT_MAIN_ID = IM.INV_AMORT_MAIN_ID
						<cfif isdefined("attributes.is_entry_date_info") and len(attributes.finish_date1)>
							AND IM.ACTION_DATE <= #createodbcdatetime(attributes.finish_date1)#
						</cfif>
						<cfif attributes.report_type eq 2>
							AND IM.ACTION_DATE <= IR.ACTION_DATE
						<cfelse>
							AND II.AMORTIZATON_YEAR < #session.ep.period_year#
						</cfif>
				),0) FIRST_VALUE,
				ISNULL((
					SELECT 
						<cfif attributes.report_type eq 2>
							TOP 1 II.AMORTIZATON_VALUE
						<cfelse>
							SUM(II.PERIODIC_AMORT_VALUE*INV_QUANTITY) AS LAST_VALUE
						</cfif>
					FROM 
						<cfif go_ifrs eq 0>
							INVENTORY_AMORTIZATON II,
						<cfelse>
							INVENTORY_AMORTIZATON_IFRS II,
						</cfif>
						INVENTORY_AMORTIZATION_MAIN IM
					WHERE 
						II.INVENTORY_ID = I.INVENTORY_ID
						AND II.INV_AMORT_MAIN_ID = IM.INV_AMORT_MAIN_ID
						<cfif isdefined("attributes.is_entry_date_info") and len(attributes.finish_date1)>
							AND IM.ACTION_DATE <= #createodbcdatetime(attributes.finish_date1)#
						</cfif>
						<cfif attributes.report_type eq 2>
							AND IM.ACTION_DATE <= IR.ACTION_DATE
						<cfelse>
							AND II.AMORTIZATON_YEAR >= #session.ep.period_year#
						</cfif>
					<cfif attributes.report_type eq 2>
						ORDER BY
							IM.ACTION_DATE DESC
					</cfif>
				),0) LAST_VALUE,
				ISNULL((
					SELECT 
						SUM(II.PERIODIC_AMORT_VALUE) AS FIRST_VALUE
					FROM 
						<cfif go_ifrs eq 0>
							INVENTORY_AMORTIZATON II,
						<cfelse>
							INVENTORY_AMORTIZATON_IFRS II,
						</cfif>
						INVENTORY_AMORTIZATION_MAIN IM
					WHERE 
						II.INVENTORY_ID = I.INVENTORY_ID
						AND II.INV_AMORT_MAIN_ID = IM.INV_AMORT_MAIN_ID
						<cfif isdefined("attributes.is_entry_date_info") and len(attributes.finish_date1)>
							AND IM.ACTION_DATE <= #createodbcdatetime(attributes.finish_date1)#
						</cfif>
						<cfif attributes.report_type eq 2>
							AND IM.ACTION_DATE <= IR.ACTION_DATE
						<cfelse>
							AND II.AMORTIZATON_YEAR < #session.ep.period_year#
						</cfif>
				),0) FIRST_VALUE_UNIT,
				ISNULL((
					SELECT 
						<cfif attributes.report_type eq 2>
							TOP 1 II.AMORTIZATON_VALUE
						<cfelse>
							SUM(II.PERIODIC_AMORT_VALUE) AS LAST_VALUE
						</cfif>
					FROM 
						<cfif go_ifrs eq 0>
							INVENTORY_AMORTIZATON II,
						<cfelse>
							INVENTORY_AMORTIZATON_IFRS II,
						</cfif>
						INVENTORY_AMORTIZATION_MAIN IM
					WHERE 
						II.INVENTORY_ID = I.INVENTORY_ID
						AND II.INV_AMORT_MAIN_ID = IM.INV_AMORT_MAIN_ID
						<cfif isdefined("attributes.is_entry_date_info") and len(attributes.finish_date1)>
							AND IM.ACTION_DATE <= #createodbcdatetime(attributes.finish_date1)#
						</cfif>
						<cfif attributes.report_type eq 2>
							AND IM.ACTION_DATE <= IR.ACTION_DATE
						<cfelse>
							AND II.AMORTIZATON_YEAR >= #session.ep.period_year#
						</cfif>
					<cfif attributes.report_type eq 2>
						ORDER BY
							IM.ACTION_DATE DESC
					</cfif>
				),0) LAST_VALUE_UNIT,
				YEAR(ENTRY_DATE) AS ENTRY_YEAR,
				IR.ACTION_DATE OUTPUT_DATE,
				ICAT.INVENTORY_CAT,
				INV.DEPARTMENT_ID,
				INV.INVOICE_NUMBER,
				INV.INVOICE_DATE,
				INV.COMPANY_ID
			FROM 
				INVENTORY I
				LEFT JOIN SETUP_INVENTORY_CAT ICAT ON ICAT.INVENTORY_CAT_ID = I.INVENTORY_CATID,
				INVENTORY_ROW IR,
				#dsn#_#get_period.period_year#_#get_period.our_company_id#.INVOICE INV
			WHERE
				I.INVENTORY_ID = IR.INVENTORY_ID
				AND IR.ACTION_ID = INV.INVOICE_ID
				AND IR.PROCESS_TYPE = 65
				<cfif len(attributes.keyword)>
					AND (I.INVENTORY_NAME LIKE '%#attributes.keyword#%' OR I.INVENTORY_NUMBER LIKE '%#attributes.keyword#%')
				</cfif>
				<cfif len(attributes.start_date)>
					AND I.RECORD_DATE >= #attributes.start_date#
				</cfif>
				<cfif len(attributes.finish_date)>
					AND I.RECORD_DATE < #DATEADD("d",1,attributes.finish_date)#
				</cfif>
				<cfif len(attributes.start_date1)>
					AND I.ENTRY_DATE >= #attributes.start_date1#
				</cfif>
				<cfif len(attributes.finish_date1)>
					AND I.ENTRY_DATE <= #attributes.finish_date1#
				</cfif>
				<cfif len(attributes.expense_item_id)>
					AND I.EXPENSE_ITEM_ID = #attributes.expense_item_id#		
				</cfif>
				<cfif len(attributes.expense_center_id)>
					AND I.EXPENSE_CENTER_ID = #attributes.expense_center_id#		
				</cfif>
				<cfif len(attributes.amor_method)>
					AND I.AMORTIZATON_METHOD = #attributes.amor_method#
				</cfif>
				<cfif len(attributes.account_id) and len(attributes.account_name)>
					AND I.ACCOUNT_ID = '#attributes.account_id#'
				</cfif>
				<cfif len(attributes.debt_account_id) and len(attributes.debt_account_name)>
					AND I.DEBT_ACCOUNT_ID = '#attributes.debt_account_id#'
				</cfif>
				<cfif len(attributes.claim_account_id) and len(attributes.claim_account_name)>
					AND I.CLAIM_ACCOUNT_ID = '#attributes.claim_account_id#'
				</cfif>
				<cfif len(attributes.department_id) and len(attributes.department_name)>
					AND INV.DEPARTMENT_ID = #attributes.department_id#
					AND INV.DEPARTMENT_LOCATION = #attributes.location_id#
				</cfif>
				<cfif len(attributes.project_id) and len(attributes.project_head)>
					AND INV.PROJECT_ID = #attributes.project_id#
					AND I.PROJECT_ID = #attributes.project_id#
				</cfif>
				<cfif isDefined("attributes.inventory_type") and len(attributes.inventory_type)>
					AND I.INVENTORY_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.inventory_type#">
				</cfif> 
				<cfif isdefined('attributes.subscription_id') and len(attributes.subscription_id) and isdefined('attributes.subscription_no') and len(attributes.subscription_no)>
					AND I.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
				</cfif>
				<cfif isdate(attributes.output_date_1)>
					AND I.INVENTORY_ID IN (SELECT INVENTORY_ID FROM INVENTORY_ROW WHERE ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.output_date_1#"> AND PROCESS_TYPE IN (<cfqueryparam list="yes" cfsqltype="cf_sql_integer" value="#output_type#">))
				</cfif>
				<cfif isdate(attributes.output_date_2)>
					AND I.INVENTORY_ID IN (SELECT INVENTORY_ID FROM INVENTORY_ROW WHERE ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATE_ADD('d',1,attributes.output_date_2)#"> AND PROCESS_TYPE IN (<cfqueryparam list="yes" cfsqltype="cf_sql_integer" value="#output_type#">))
				</cfif>
				<cfif isDefined("attributes.last_inv_status") and len(attributes.last_inv_status)>
					<cfif attributes.last_inv_status eq 1>
						AND I.LAST_INVENTORY_VALUE > 0
						AND ISNULL((SELECT SUM(ISNULL(IR.STOCK_IN,0)-ISNULL(IR.STOCK_OUT,0)) FROM INVENTORY_ROW IR WHERE IR.INVENTORY_ID = I.INVENTORY_ID),I.QUANTITY) > 0
					<cfelse>
						AND 
						(
						I.LAST_INVENTORY_VALUE = 0
						OR 
						ISNULL((SELECT SUM(ISNULL(IR.STOCK_IN,0)-ISNULL(IR.STOCK_OUT,0)) FROM INVENTORY_ROW IR WHERE IR.INVENTORY_ID = I.INVENTORY_ID),I.QUANTITY)  = 0
						)
					</cfif>
				</cfif>
				<cfif Len(attributes.inventory_cat_id) and Len(attributes.inventory_cat)>
					AND I.INVENTORY_CATID = #attributes.inventory_cat_id#
				</cfif>
				AND PERIOD_ID = #get_period.period_id#
			<cfif currentrow neq recordcount>
				UNION ALL
			</cfif>
		</cfloop>
			UNION ALL
		</cfif>
		SELECT 
			(SELECT TOP 1 INVENTORY_ID FROM INVENTORY_ROW WHERE INVENTORY_ID = I.INVENTORY_ID AND PROCESS_TYPE = 1181 AND PERIOD_ID = #session.ep.period_id#) as DEVIR,
			<cfif isdefined("attributes.is_entry_date_info") and len(attributes.finish_date1)>
				(SELECT SUM(INVENTORY_ROW3.STOCK_IN-ISNULL(INVENTORY_ROW3.STOCK_OUT,0)) FROM INVENTORY_ROW INVENTORY_ROW3 WHERE INVENTORY_ROW3.INVENTORY_ID = I.INVENTORY_ID AND INVENTORY_ROW3.ACTION_DATE <= #attributes.finish_date1#) AS ROW_AMOUNT,
			<cfelse>
				<cfif attributes.report_type eq 1>
					I.QUANTITY ROW_AMOUNT,
				<cfelse>
					IR.QUANTITY ROW_AMOUNT,
				</cfif>
			</cfif> 
			I.INVENTORY_ID,
			I.INVENTORY_NAME,
			I.INVENTORY_NUMBER,
			I.PROCESS_CAT,
			I.QUANTITY,
			I.AMORTIZATON_ESTIMATE,
			I.AMORTIZATON_METHOD,
			I.AMOUNT,
			I.ENTRY_DATE,
			I.COMP_ID,
			I.COMP_PARTNER_ID,
			I.LAST_INVENTORY_VALUE,
			I.ACCOUNT_ID,
			I.CLAIM_ACCOUNT_ID,
			I.DEBT_ACCOUNT_ID,
			I.AMOUNT_2,
			I.RECORD_DATE,
			I.LAST_INVENTORY_VALUE_2,
			<cfif go_ifrs eq 0>
				I.INVENTORY_DURATION INVENTORY_DURATION,
			<cfelse>
				I.INVENTORY_DURATION_IFRS INVENTORY_DURATION,
			</cfif>
			I.ACCOUNT_PERIOD,
			I.EXPENSE_ITEM_ID,
			I.EXPENSE_CENTER_ID,
			I.PROJECT_ID,
			I.CONSUMER_ID,
			I.AMORTIZATION_COUNT,
			I.AMORT_LAST_VALUE,
			I.AMORTIZATION_TYPE,
			CASE WHEN IR.PROCESS_TYPE = 1181 THEN 
				ISNULL((
					SELECT 
						SUM(II.PERIODIC_AMORT_VALUE*INV_QUANTITY) AS FIRST_VALUE
					FROM 
						<cfif go_ifrs eq 0>
							INVENTORY_AMORTIZATON II,
						<cfelse>
							INVENTORY_AMORTIZATON_IFRS II,
						</cfif>
						INVENTORY_AMORTIZATION_MAIN IM
					WHERE 
						II.INVENTORY_ID = I.INVENTORY_ID
						AND II.INV_AMORT_MAIN_ID = IM.INV_AMORT_MAIN_ID
						<cfif isdefined("attributes.is_entry_date_info") and len(attributes.finish_date1)>
							AND IM.ACTION_DATE <= #createodbcdatetime(attributes.finish_date1)#
						</cfif>
						<cfif attributes.report_type eq 2>
							AND IM.ACTION_DATE <= IR.ACTION_DATE
						<cfelse>
							AND II.AMORTIZATON_YEAR < #session.ep.period_year#
						</cfif>
				),0)+
			   	ISNULL((
					SELECT 
						TOP 1 (AMORTIZATON_VALUE+PERIODIC_AMORT_VALUE)*INV_QUANTITY
					FROM 
						<cfif go_ifrs eq 0>
							INVENTORY_AMORTIZATON II,
						<cfelse>
							INVENTORY_AMORTIZATON_IFRS II,
						</cfif>
						INVENTORY_AMORTIZATION_MAIN IM
					WHERE 
						II.INVENTORY_ID = I.INVENTORY_ID
						AND II.INV_AMORT_MAIN_ID = IM.INV_AMORT_MAIN_ID
						AND IM.PROCESS_TYPE = 1181
					ORDER BY
						IM.ACTION_DATE
				),0)
			ELSE
				ISNULL((
					SELECT 
						SUM(II.PERIODIC_AMORT_VALUE*INV_QUANTITY) AS FIRST_VALUE
					FROM 
						<cfif go_ifrs eq 0>
							INVENTORY_AMORTIZATON II,
						<cfelse>
							INVENTORY_AMORTIZATON_IFRS II,
						</cfif>
						INVENTORY_AMORTIZATION_MAIN IM
					WHERE 
						II.INVENTORY_ID = I.INVENTORY_ID
						AND II.INV_AMORT_MAIN_ID = IM.INV_AMORT_MAIN_ID
						<cfif isdefined("attributes.is_entry_date_info") and len(attributes.finish_date1)>
							AND IM.ACTION_DATE <= #createodbcdatetime(attributes.finish_date1)#
						</cfif>
						<cfif attributes.report_type eq 2>
							AND IM.ACTION_DATE <= IR.ACTION_DATE
						<cfelse>
							AND II.AMORTIZATON_YEAR < #session.ep.period_year#
						</cfif>
				),0)
			END AS FIRST_VALUE,
			ISNULL((
				SELECT 
					<cfif attributes.report_type eq 2>
						TOP 1 II.AMORTIZATON_VALUE
					<cfelse>
						SUM(II.PERIODIC_AMORT_VALUE*INV_QUANTITY) AS LAST_VALUE
					</cfif>
				FROM 
					<cfif go_ifrs eq 0>
							INVENTORY_AMORTIZATON II,
						<cfelse>
							INVENTORY_AMORTIZATON_IFRS II,
						</cfif>
					INVENTORY_AMORTIZATION_MAIN IM
				WHERE 
					II.INVENTORY_ID = I.INVENTORY_ID
					AND II.INV_AMORT_MAIN_ID = IM.INV_AMORT_MAIN_ID
					<cfif isdefined("attributes.is_entry_date_info") and len(attributes.finish_date1)>
						AND IM.ACTION_DATE <= #createodbcdatetime(attributes.finish_date1)#
					</cfif>
					<cfif attributes.report_type eq 2>
						AND IM.ACTION_DATE <= IR.ACTION_DATE
					<cfelse>
						AND II.AMORTIZATON_YEAR >= #session.ep.period_year#
					</cfif>
				<cfif attributes.report_type eq 2>
					ORDER BY
						IM.ACTION_DATE DESC
				</cfif>
			),0) LAST_VALUE,
			CASE WHEN IR.PROCESS_TYPE = 1181 THEN 
				ISNULL((
					SELECT 
						SUM(II.PERIODIC_AMORT_VALUE) AS FIRST_VALUE
					FROM 
						<cfif go_ifrs eq 0>
							INVENTORY_AMORTIZATON II,
						<cfelse>
							INVENTORY_AMORTIZATON_IFRS II,
						</cfif>
						INVENTORY_AMORTIZATION_MAIN IM
					WHERE 
						II.INVENTORY_ID = I.INVENTORY_ID
						AND II.INV_AMORT_MAIN_ID = IM.INV_AMORT_MAIN_ID
						<cfif isdefined("attributes.is_entry_date_info") and len(attributes.finish_date1)>
							AND IM.ACTION_DATE <= #createodbcdatetime(attributes.finish_date1)#
						</cfif>
						<cfif attributes.report_type eq 2>
							AND IM.ACTION_DATE <= IR.ACTION_DATE
						<cfelse>
							AND II.AMORTIZATON_YEAR < #session.ep.period_year#
						</cfif>
				),0)+
				ISNULL((
					SELECT 
						TOP 1 AMORTIZATON_VALUE+PERIODIC_AMORT_VALUE
					FROM 
						<cfif go_ifrs eq 0>
							INVENTORY_AMORTIZATON II,
						<cfelse>
							INVENTORY_AMORTIZATON_IFRS II,
						</cfif>
						INVENTORY_AMORTIZATION_MAIN IM
					WHERE 
						II.INVENTORY_ID = I.INVENTORY_ID
						AND II.INV_AMORT_MAIN_ID = IM.INV_AMORT_MAIN_ID
						AND IM.PROCESS_TYPE = 1181
					ORDER BY
						IM.ACTION_DATE
				),0)
			ELSE
				ISNULL((
					SELECT 
						SUM(II.PERIODIC_AMORT_VALUE) AS FIRST_VALUE
					FROM 
						<cfif go_ifrs eq 0>
							INVENTORY_AMORTIZATON II,
						<cfelse>
							INVENTORY_AMORTIZATON_IFRS II,
						</cfif>
						INVENTORY_AMORTIZATION_MAIN IM
					WHERE 
						II.INVENTORY_ID = I.INVENTORY_ID
						AND II.INV_AMORT_MAIN_ID = IM.INV_AMORT_MAIN_ID
						<cfif isdefined("attributes.is_entry_date_info") and len(attributes.finish_date1)>
							AND IM.ACTION_DATE <= #createodbcdatetime(attributes.finish_date1)#
						</cfif>
						<cfif attributes.report_type eq 2>
							AND IM.ACTION_DATE <= IR.ACTION_DATE
						<cfelse>
							AND II.AMORTIZATON_YEAR < #session.ep.period_year#
						</cfif>
				),0)
			END AS FIRST_VALUE_UNIT,
			ISNULL((
				SELECT 
					<cfif attributes.report_type eq 2>
						TOP 1 II.AMORTIZATON_VALUE
					<cfelse>
						SUM(II.PERIODIC_AMORT_VALUE) AS LAST_VALUE
					</cfif>
				FROM 
					<cfif go_ifrs eq 0>
							INVENTORY_AMORTIZATON II,
						<cfelse>
							INVENTORY_AMORTIZATON_IFRS II,
						</cfif>
					INVENTORY_AMORTIZATION_MAIN IM
				WHERE 
					II.INVENTORY_ID = I.INVENTORY_ID
					AND II.INV_AMORT_MAIN_ID = IM.INV_AMORT_MAIN_ID
					<cfif isdefined("attributes.is_entry_date_info") and len(attributes.finish_date1)>
						AND IM.ACTION_DATE <= #createodbcdatetime(attributes.finish_date1)#
					</cfif>
					<cfif attributes.report_type eq 2>
						AND IM.ACTION_DATE <= IR.ACTION_DATE
					<cfelse>
						AND II.AMORTIZATON_YEAR >= #session.ep.period_year#
					</cfif>
				<cfif attributes.report_type eq 2>
					ORDER BY
						IM.ACTION_DATE DESC
				</cfif>
			),0) LAST_VALUE_UNIT,
			YEAR(ENTRY_DATE) AS ENTRY_YEAR,
			IR.ACTION_DATE OUTPUT_DATE,
			ICAT.INVENTORY_CAT,
			0 AS DEPARTMENT_ID,
			'' AS INVOICE_NUMBER,
			ENTRY_DATE AS INVOICE_DATE,
			0 AS COMPANY_ID
		FROM 
			INVENTORY I
			LEFT JOIN SETUP_INVENTORY_CAT ICAT ON ICAT.INVENTORY_CAT_ID = I.INVENTORY_CATID,
			INVENTORY_ROW IR
		WHERE
			I.INVENTORY_ID = IR.INVENTORY_ID
			<cfif attributes.report_type eq 2 and attributes.inventories eq 0>
				AND IR.PROCESS_TYPE IN (#output_type#)
			<cfelseif attributes.report_type eq 2 and attributes.inventories eq 1>
				AND IR.PROCESS_TYPE IN (#input_type#)
			<cfelseif attributes.report_type eq 1>
				<cfif isdefined("attributes.is_inv_info")>
					AND IR.PROCESS_TYPE = 1181
				<cfelse>
					AND IR.PROCESS_TYPE IN (118,1181)
				</cfif>
			</cfif>
			<cfif len(attributes.keyword)>
				AND (I.INVENTORY_NAME LIKE '%#attributes.keyword#%' OR I.INVENTORY_NUMBER LIKE '%#attributes.keyword#%')
			</cfif>
			<cfif len(attributes.start_date)>
				AND I.RECORD_DATE >= #attributes.start_date#
			</cfif>
			<cfif len(attributes.finish_date)>
				AND I.RECORD_DATE < #DATEADD("d",1,attributes.finish_date)#
			</cfif>
			<cfif len(attributes.start_date1)>
				AND I.ENTRY_DATE >= #attributes.start_date1#
			</cfif>
			<cfif len(attributes.finish_date1)>
				AND I.ENTRY_DATE <= #attributes.finish_date1#
			</cfif>
			<cfif len(attributes.expense_item_id)>
				AND I.EXPENSE_ITEM_ID = #attributes.expense_item_id#		
			</cfif>
			<cfif len(attributes.project_head)>
				AND I.PROJECT_ID = #attributes.PROJECT_ID#		
			</cfif>
			<cfif len(attributes.expense_center_id)>
				AND I.EXPENSE_CENTER_ID = #attributes.expense_center_id#		
			</cfif>
			<cfif len(attributes.amor_method)>
				AND I.AMORTIZATON_METHOD = #attributes.amor_method#
			</cfif>
			<cfif len(attributes.account_id) and len(attributes.account_name)>
				AND I.ACCOUNT_ID = '#attributes.account_id#'
			</cfif>
			<cfif len(attributes.debt_account_id) and len(attributes.debt_account_name)>
				AND I.DEBT_ACCOUNT_ID = '#attributes.debt_account_id#'
			</cfif>
			<cfif len(attributes.claim_account_id) and len(attributes.claim_account_name)>
				AND I.CLAIM_ACCOUNT_ID = '#attributes.claim_account_id#'
			</cfif>
			<cfif isDefined("attributes.inventory_type") and len(attributes.inventory_type)>
				AND I.INVENTORY_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.inventory_type#">
			</cfif> 
			<cfif isdefined('attributes.subscription_id') and len(attributes.subscription_id) and isdefined('attributes.subscription_no') and len(attributes.subscription_no)>
				AND I.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
			</cfif>
			<cfif isdate(attributes.output_date_1)>
				AND I.INVENTORY_ID IN (SELECT INVENTORY_ID FROM INVENTORY_ROW WHERE ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.output_date_1#"> AND PROCESS_TYPE IN (<cfqueryparam list="yes" cfsqltype="cf_sql_integer" value="#output_type#">))
			</cfif>
			<cfif isdate(attributes.output_date_2)>
				AND I.INVENTORY_ID IN (SELECT INVENTORY_ID FROM INVENTORY_ROW WHERE ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATE_ADD('d',1,attributes.output_date_2)#"> AND PROCESS_TYPE IN (<cfqueryparam list="yes" cfsqltype="cf_sql_integer" value="#output_type#">))
			</cfif>
			<cfif isDefined("attributes.last_inv_status") and len(attributes.last_inv_status)>
				<cfif attributes.last_inv_status eq 1>
					AND I.LAST_INVENTORY_VALUE > 0
					AND ISNULL((SELECT SUM(ISNULL(IR.STOCK_IN,0)-ISNULL(IR.STOCK_OUT,0)) FROM INVENTORY_ROW IR WHERE IR.INVENTORY_ID = I.INVENTORY_ID),I.QUANTITY) > 0
				<cfelse>
					AND 
					(
					I.LAST_INVENTORY_VALUE = 0
					OR 
					ISNULL((SELECT SUM(ISNULL(IR.STOCK_IN,0)-ISNULL(IR.STOCK_OUT,0)) FROM INVENTORY_ROW IR WHERE IR.INVENTORY_ID = I.INVENTORY_ID),I.QUANTITY)  = 0
					)
				</cfif>
			</cfif>
			<cfif Len(attributes.inventory_cat_id) and Len(attributes.inventory_cat)>
				AND I.INVENTORY_CATID = #attributes.inventory_cat_id#
			</cfif>
		<cfif isdefined("attributes.is_inv_info")>
			<cfloop query="get_period">
				 UNION ALL
				SELECT 
					(SELECT TOP 1 INVENTORY_ID FROM INVENTORY_ROW WHERE INVENTORY_ID = I.INVENTORY_ID AND PROCESS_TYPE = 1181 AND PERIOD_ID = #session.ep.period_id#) as DEVIR,
					<cfif isdefined("attributes.is_entry_date_info") and len(attributes.finish_date1)>
						(SELECT SUM(INVENTORY_ROW3.STOCK_IN-ISNULL(INVENTORY_ROW3.STOCK_OUT,0)) FROM INVENTORY_ROW INVENTORY_ROW3 WHERE INVENTORY_ROW3.INVENTORY_ID = I.INVENTORY_ID AND INVENTORY_ROW3.ACTION_DATE <= #attributes.finish_date1#) AS ROW_AMOUNT,
					<cfelse>
						<cfif attributes.report_type eq 1>
							I.QUANTITY ROW_AMOUNT,
						<cfelse>
							IR.QUANTITY ROW_AMOUNT,
						</cfif>
					</cfif> 
					I.INVENTORY_ID,
					I.INVENTORY_NAME,
					I.INVENTORY_NUMBER,
					I.PROCESS_CAT,
					I.QUANTITY,
					I.AMORTIZATON_ESTIMATE,
					I.AMORTIZATON_METHOD,
					I.AMOUNT,
					I.ENTRY_DATE,
					I.COMP_ID,
					I.COMP_PARTNER_ID,
					I.LAST_INVENTORY_VALUE,
					I.ACCOUNT_ID,
					I.CLAIM_ACCOUNT_ID,
					I.DEBT_ACCOUNT_ID,
					I.AMOUNT_2,
					I.RECORD_DATE,
					I.LAST_INVENTORY_VALUE_2,
					<cfif go_ifrs eq 0>
						I.INVENTORY_DURATION INVENTORY_DURATION,
					<cfelse>
						I.INVENTORY_DURATION_IFRS INVENTORY_DURATION,
					</cfif>
					I.ACCOUNT_PERIOD,
					I.EXPENSE_ITEM_ID,
					I.EXPENSE_CENTER_ID,
					I.PROJECT_ID,
					I.CONSUMER_ID,
					I.AMORTIZATION_COUNT,
					I.AMORT_LAST_VALUE,
					I.AMORTIZATION_TYPE,
					ISNULL((
						SELECT 
							SUM(II.PERIODIC_AMORT_VALUE*INV_QUANTITY) AS FIRST_VALUE
						FROM 
							<cfif go_ifrs eq 0>
							INVENTORY_AMORTIZATON II,
						<cfelse>
							INVENTORY_AMORTIZATON_IFRS II,
						</cfif>
							INVENTORY_AMORTIZATION_MAIN IM
						WHERE 
							II.INVENTORY_ID = I.INVENTORY_ID
							AND II.INV_AMORT_MAIN_ID = IM.INV_AMORT_MAIN_ID
							<cfif isdefined("attributes.is_entry_date_info") and len(attributes.finish_date1)>
								AND IM.ACTION_DATE <= #createodbcdatetime(attributes.finish_date1)#
							</cfif>
							<cfif attributes.report_type eq 2>
								AND IM.ACTION_DATE <= IR.ACTION_DATE
							<cfelse>

								AND II.AMORTIZATON_YEAR < #session.ep.period_year#
							</cfif>
					),0) FIRST_VALUE,
					ISNULL((
						SELECT 
							<cfif attributes.report_type eq 2>
								TOP 1 II.AMORTIZATON_VALUE
							<cfelse>
								SUM(II.PERIODIC_AMORT_VALUE*INV_QUANTITY) AS LAST_VALUE
							</cfif>
						FROM 
							<cfif go_ifrs eq 0>
							INVENTORY_AMORTIZATON II,
						<cfelse>
							INVENTORY_AMORTIZATON_IFRS II,
						</cfif>
							INVENTORY_AMORTIZATION_MAIN IM
						WHERE 
							II.INVENTORY_ID = I.INVENTORY_ID
							AND II.INV_AMORT_MAIN_ID = IM.INV_AMORT_MAIN_ID
							<cfif isdefined("attributes.is_entry_date_info") and len(attributes.finish_date1)>
								AND IM.ACTION_DATE <= #createodbcdatetime(attributes.finish_date1)#
							</cfif>
							<cfif attributes.report_type eq 2>
								AND IM.ACTION_DATE <= IR.ACTION_DATE
							<cfelse>
								AND II.AMORTIZATON_YEAR >= #session.ep.period_year#
							</cfif>
						<cfif attributes.report_type eq 2>
							ORDER BY
								IM.ACTION_DATE DESC
						</cfif>
					),0) LAST_VALUE,
					ISNULL((
						SELECT 
							SUM(II.PERIODIC_AMORT_VALUE) AS FIRST_VALUE
						FROM 
							<cfif go_ifrs eq 0>
							INVENTORY_AMORTIZATON II,
						<cfelse>
							INVENTORY_AMORTIZATON_IFRS II,
						</cfif>
							INVENTORY_AMORTIZATION_MAIN IM
						WHERE 
							II.INVENTORY_ID = I.INVENTORY_ID
							AND II.INV_AMORT_MAIN_ID = IM.INV_AMORT_MAIN_ID
							<cfif isdefined("attributes.is_entry_date_info") and len(attributes.finish_date1)>
								AND IM.ACTION_DATE <= #createodbcdatetime(attributes.finish_date1)#
							</cfif>
							<cfif attributes.report_type eq 2>
								AND IM.ACTION_DATE <= IR.ACTION_DATE
							<cfelse>
								AND II.AMORTIZATON_YEAR < #session.ep.period_year#
							</cfif>
					),0) FIRST_VALUE_UNIT,
					ISNULL((
						SELECT 
							<cfif attributes.report_type eq 2>
								TOP 1 II.AMORTIZATON_VALUE
							<cfelse>
								SUM(II.PERIODIC_AMORT_VALUE) AS LAST_VALUE
							</cfif>
						FROM 
							<cfif go_ifrs eq 0>
							INVENTORY_AMORTIZATON II,
						<cfelse>
							INVENTORY_AMORTIZATON_IFRS II,
						</cfif>
							INVENTORY_AMORTIZATION_MAIN IM
						WHERE 
							II.INVENTORY_ID = I.INVENTORY_ID
							AND II.INV_AMORT_MAIN_ID = IM.INV_AMORT_MAIN_ID
							<cfif isdefined("attributes.is_entry_date_info") and len(attributes.finish_date1)>
								AND IM.ACTION_DATE <= #createodbcdatetime(attributes.finish_date1)#
							</cfif>
							<cfif attributes.report_type eq 2>
								AND IM.ACTION_DATE <= IR.ACTION_DATE
							<cfelse>
								AND II.AMORTIZATON_YEAR >= #session.ep.period_year#
							</cfif>
						<cfif attributes.report_type eq 2>
							ORDER BY
								IM.ACTION_DATE DESC
						</cfif>
					),0) LAST_VALUE_UNIT,
					YEAR(ENTRY_DATE) AS ENTRY_YEAR,
					IR.ACTION_DATE OUTPUT_DATE,
					ICAT.INVENTORY_CAT,
					0 AS DEPARTMENT_ID,
					INVOICE.INVOICE_NUMBER,
					INVOICE.INVOICE_DATE,
					INVOICE.COMPANY_ID
				FROM 
					INVENTORY I
					LEFT JOIN SETUP_INVENTORY_CAT ICAT ON ICAT.INVENTORY_CAT_ID = I.INVENTORY_CATID,
					INVENTORY_ROW IR,
					#dsn#_#get_period.period_year#_#get_period.our_company_id#.STOCK_FIS SF,
					#dsn#_#get_period.period_year#_#get_period.our_company_id#.STOCK_FIS_ROW SFR,
					#dsn#_#get_period.period_year#_#get_period.our_company_id#.INVOICE
				WHERE
					I.INVENTORY_ID = IR.INVENTORY_ID
					AND I.INVENTORY_ID = SFR.INVENTORY_ID
					AND INVOICE.INVOICE_ID = SF.RELATED_INVOICE_ID
					AND SF.FIS_ID = SFR.FIS_ID
					AND SF.FIS_TYPE = 118
					<cfif len(attributes.keyword)>
						AND (I.INVENTORY_NAME LIKE '%#attributes.keyword#%' OR I.INVENTORY_NUMBER LIKE '%#attributes.keyword#%')
					</cfif>
					<cfif len(attributes.start_date)>
						AND I.RECORD_DATE >= #attributes.start_date#
					</cfif>
					<cfif len(attributes.finish_date)>
						AND I.RECORD_DATE < #DATEADD("d",1,attributes.finish_date)#
					</cfif>
					<cfif len(attributes.start_date1)>
						AND I.ENTRY_DATE >= #attributes.start_date1#
					</cfif>

					<cfif len(attributes.finish_date1)>
						AND I.ENTRY_DATE <= #attributes.finish_date1#
					</cfif>
					<cfif len(attributes.expense_item_id)>
						AND I.EXPENSE_ITEM_ID = #attributes.expense_item_id#		
					</cfif>
					<cfif len(attributes.expense_center_id)>
						AND I.EXPENSE_CENTER_ID = #attributes.expense_center_id#		
					</cfif>
					<cfif len(attributes.amor_method)>
						AND I.AMORTIZATON_METHOD = #attributes.amor_method#
					</cfif>
					<cfif len(attributes.account_id) and len(attributes.account_name)>
						AND I.ACCOUNT_ID = '#attributes.account_id#'
					</cfif>
					<cfif len(attributes.debt_account_id) and len(attributes.debt_account_name)>
						AND I.DEBT_ACCOUNT_ID = '#attributes.debt_account_id#'
					</cfif>
					<cfif len(attributes.claim_account_id) and len(attributes.claim_account_name)>
						AND I.CLAIM_ACCOUNT_ID = '#attributes.claim_account_id#'
					</cfif>
					<cfif isDefined("attributes.inventory_type") and len(attributes.inventory_type)>
						AND I.INVENTORY_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.inventory_type#">
					</cfif> 
					<cfif isdefined('attributes.subscription_id') and len(attributes.subscription_id) and isdefined('attributes.subscription_no') and len(attributes.subscription_no)>
						AND I.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
					</cfif>
					<cfif isdate(attributes.output_date_1)>
						AND I.INVENTORY_ID IN (SELECT INVENTORY_ID FROM INVENTORY_ROW WHERE ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.output_date_1#"> AND PROCESS_TYPE IN (<cfqueryparam list="yes" cfsqltype="cf_sql_integer" value="#output_type#">))
					</cfif>
					<cfif isdate(attributes.output_date_2)>
						AND I.INVENTORY_ID IN (SELECT INVENTORY_ID FROM INVENTORY_ROW WHERE ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATE_ADD('d',1,attributes.output_date_2)#"> AND PROCESS_TYPE IN (<cfqueryparam list="yes" cfsqltype="cf_sql_integer" value="#output_type#">))
					</cfif>
					<cfif isDefined("attributes.last_inv_status") and len(attributes.last_inv_status)>
						<cfif attributes.last_inv_status eq 1>
							AND I.LAST_INVENTORY_VALUE > 0
							AND ISNULL((SELECT SUM(ISNULL(IR.STOCK_IN,0)-ISNULL(IR.STOCK_OUT,0)) FROM INVENTORY_ROW IR WHERE IR.INVENTORY_ID = I.INVENTORY_ID),I.QUANTITY) > 0
						<cfelse>
							AND 
							(
							I.LAST_INVENTORY_VALUE = 0
							OR 
							ISNULL((SELECT SUM(ISNULL(IR.STOCK_IN,0)-ISNULL(IR.STOCK_OUT,0)) FROM INVENTORY_ROW IR WHERE IR.INVENTORY_ID = I.INVENTORY_ID),I.QUANTITY)  = 0
							)
						</cfif>
					</cfif>
					<cfif Len(attributes.inventory_cat_id) and Len(attributes.inventory_cat)>
						AND I.INVENTORY_CATID = #attributes.inventory_cat_id#
					</cfif>
			</cfloop>
		</cfif>
	) AS XXX   
	 <cfif  len(attributes.department_name)>
	 	WHERE DEPARTMENT_ID <> 0
	 </cfif> 
	ORDER BY
		<cfif isdefined("attributes.is_period_group")>
			ENTRY_DATE
		<cfelse>
			INVENTORY_NUMBER
		</cfif>
	</cfquery>
	
	
	<cfquery name="get_all_inventory" datasource="#dsn3#">
		WITH CTE1 as 
		(
			SELECT 
				dir.*
				 ,CASE WHEN amount <> 0 AND LEN(AMOUNT_2)>0 THEN  (amount_2 / amount) ELSE 1 END AS RATE2
				,get_sale_amount.SALE_MIKTAR 
			FROM 
				####detail_inventory_report_#session.ep.userid# dir
			LEFT JOIN
				(
					SELECT 
						SUM(STOCK_OUT) AS SALE_MIKTAR,
						INVENTORY_ID as INVENTORY_ID5
					FROM
						INVENTORY_ROW
					WHERE
						PROCESS_TYPE IN(66,1182) AND INVENTORY_ID > 0
					GROUP BY
						INVENTORY_ID					
				 ) as get_sale_amount
			 ON
				dir.INVENTORY_ID  =  get_sale_amount.INVENTORY_ID5 
		  ),
		 CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (	ORDER BY
												INVENTORY_NUMBER
									) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
					FROM
						CTE1  
					)
			SELECT
				CTE2.*
				<cfif attributes.page neq 1>
				,TOPLAM.*
				</cfif>
			FROM
				CTE2
				<cfif attributes.page neq 1>
					OUTER APPLY
					(
						SELECT 
							<cfif isdefined("attributes.is_entry_date_info")  or attributes.report_type eq 2>
								SUM(ROW_AMOUNT) AS toplam_miktar
							<cfelse>
								SUM(
									ISNULL(QUANTITY,0) - ISNULL(SALE_MIKTAR,0)
									
									) AS toplam_miktar
							</cfif>
							,SUM(amount) AS toplam_ilk_deger
							,SUM(amount*
										<cfif isdefined("attributes.is_entry_date_info")  or attributes.report_type eq 2>
											ROW_AMOUNT
										<cfelse>
											   (ISNULL(QUANTITY,0) - ISNULL(SALE_MIKTAR,0))
										</cfif>
								 ) AS son_toplam_ilk_deger
							,SUM(AMOUNT_2) AS toplam_ilk_deger_2
							,SUM(amount_2*
									<cfif isdefined("attributes.is_entry_date_info")  or attributes.report_type eq 2>
										ROW_AMOUNT
									<cfelse>
											(ISNULL(QUANTITY,0) - ISNULL(SALE_MIKTAR,0))
									</cfif>
								) AS son_toplam_ilk_deger_2
							<cfif attributes.report_type eq 1>
								,SUM(FIRST_VALUE) as toplam_donem_oncesi
								, SUM(FIRST_VALUE* RATE2 )  AS toplam_donem_oncesi_2
								,SUM(LAST_VALUE) AS toplam_donem
								,SUM(last_value*RATE2) AS toplam_donem_2
								,SUM(FIRST_VALUE*RATE2+LAST_VALUE*RATE2) AS toplam_son_donem_2
							</cfif>  
							<cfif attributes.report_type eq 1 >
								,SUM( AMOUNT - LAST_VALUE_UNIT - FIRST_VALUE_UNIT ) AS toplam_son_deger
								, SUM((AMOUNT - LAST_VALUE_UNIT - FIRST_VALUE_UNIT)*RATE2) AS toplam_son_deger_2
								<cfif isdefined("attributes.is_entry_date_info")  or attributes.report_type eq 2>
									,SUM( (AMOUNT - LAST_VALUE_UNIT - FIRST_VALUE_UNIT)* row_amount ) AS son_toplam_son_deger
									,SUM((AMOUNT - LAST_VALUE_UNIT - FIRST_VALUE_UNIT)* row_amount*RATE2) AS son_toplam_son_deger_2
								<cfelse>
									,SUM( (AMOUNT - LAST_VALUE_UNIT - FIRST_VALUE_UNIT)*  (ISNULL(QUANTITY,0) - ISNULL(SALE_MIKTAR,0))) AS son_toplam_son_deger
									,SUM((AMOUNT - LAST_VALUE_UNIT - FIRST_VALUE_UNIT)*RATE2*  (ISNULL(QUANTITY,0) - ISNULL(SALE_MIKTAR,0))) AS son_toplam_son_deger_2
								</cfif>
							<cfelse>
								,SUM( LAST_VALUE) AS toplam_son_deger
								,SUM(LAST_VALUE*RATE2) AS toplam_son_deger_2
								<cfif isdefined("attributes.is_entry_date_info")  or attributes.report_type eq 2>
									,SUM(LAST_VALUE* row_amount ) AS son_toplam_son_deger
									,SUM(LAST_VALUE* row_amount*RATE2) AS son_toplam_son_deger_2
								<cfelse>
									,SUM( LAST_VALUE*  (ISNULL(QUANTITY,0) - ISNULL(SALE_MIKTAR,0))) AS son_toplam_son_deger
									,SUM(LAST_VALUE*RATE2*  (ISNULL(QUANTITY,0) - ISNULL(SALE_MIKTAR,0))) AS son_toplam_son_deger_2
								</cfif>
							</cfif>
						FROM 
							CTE2 
						WHERE 
							RowNum BETWEEN 1 and #attributes.startrow-attributes.maxrows#+(#attributes.maxrows#-1)
					) as TOPLAM
				</cfif>
			WHERE
				RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
	</cfquery>
	<cfparam name="attributes.totalrecords" default="#get_all_inventory.query_count#">
<cfelse>
	<cfset get_all_inventory.query_count = 0 >
</cfif>

<cfif isdate(attributes.start_date)><cfset attributes.start_date = dateformat(attributes.start_date,dateformat_style)></cfif>
<cfif isdate(attributes.finish_date)><cfset attributes.finish_date = dateformat(attributes.finish_date,dateformat_style)></cfif>
<cfif isdate(attributes.start_date1)><cfset attributes.start_date1 = dateformat(attributes.start_date1,dateformat_style)></cfif>
<cfif isdate(attributes.finish_date1)><cfset attributes.finish_date1 = dateformat(attributes.finish_date1,dateformat_style)></cfif>
<cfif isdate(attributes.output_date_1)><cfset attributes.output_date_1 = dateformat(attributes.output_date_1,dateformat_style)></cfif>
<cfif isdate(attributes.output_date_2)><cfset attributes.output_date_2 = dateformat(attributes.output_date_2,dateformat_style)></cfif>
<cfform name="inventory_report" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='58478.Sabit Kıymet'> <cf_get_lang dictionary_id='39666.Analizi'></cfsavecontent>
	<cf_report_list_search title="#title#">
		<cf_report_list_search_area>
			 <div class="row">
				 <div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57460.Filtre'></label>
										<div class="col col-12">
											<input type="text" name="keyword" id="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>" style="width:120px;">	
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58763.Depo'></label>
										<div class="col col-12">
											<div class="input-group">
												<input type="hidden" name="department_id" id="department_id" value="<cfoutput>#attributes.department_id#</cfoutput>">
												<input type="hidden" name="location_id" id="location_id" value="<cfoutput>#attributes.location_id#</cfoutput>">
												<cfinput type="text" name="department_name" style="width:120px;" value="#attributes.department_name#" onFocus="AutoComplete_Create('department_name','DEPARTMENT_HEAD,COMMENT','DEPARTMENT_NAME','get_department_location','','DEPARTMENT_ID,LOCATION_ID,BRANCH_ID','department_id,location_id,branch_id','','3','200');" autocomplete="off">
												<span class="input-group-addon btnPointer icon-ellipsis"  onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_stores_locations&form_name=inventory_report&field_location_id=location_id&field_name=department_name&field_id=department_id&is_no_sale=1</cfoutput>','list');"></span>
											</div>	
										</div>	
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57587.Borç'> <cf_get_lang dictionary_id='58811.Muhasebe Kodu'></label>
										<div class="col col-12">
											<div class="input-group">	  
												<input type="hidden" name="debt_account_id" id="debt_account_id" value="<cfif len(attributes.debt_account_name)><cfoutput>#attributes.debt_account_id#</cfoutput></cfif>">	
												<input type="text" name="debt_account_name" id="debt_account_name" onfocus="AutoComplete_Create('debt_account_name','ACCOUNT_CODE','ACCOUNT_NAME,ACCOUNT_CODE','get_account_code','\'0\',0','ACCOUNT_CODE','debt_account_id','','3','200');" style="width:120px;" value="<cfif len(attributes.debt_account_name)><cfoutput>#attributes.debt_account_name#</cfoutput></cfif>">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=inventory_report.debt_account_id&field_name=inventory_report.debt_account_name','list');">			
												</span>	
											</div>
										</div>	
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='40435.Alacak Muhasebe Kodu'></label>
										<div class="col col-12">
											<div class="input-group">
												<input type="hidden" name="claim_account_id" id="claim_account_id" value="<cfif len(attributes.claim_account_id)><cfoutput>#attributes.claim_account_id#</cfoutput></cfif>">	
												<input type="text" name="claim_account_name" id="claim_account_name" onfocus="AutoComplete_Create('claim_account_name','ACCOUNT_CODE','ACCOUNT_NAME,ACCOUNT_CODE','get_account_code','\'0\',0','ACCOUNT_CODE','claim_account_id','','3','200');" style="width:120px;" value="<cfif len(attributes.claim_account_name)><cfoutput>#attributes.claim_account_name#</cfoutput></cfif>" onkeyup="get_wrk_acc_code_3();">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=inventory_report.claim_account_id&field_name=inventory_report.claim_account_name','list');"></span>
											</div>
										</div>	
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58602.Demirbaş'> <cf_get_lang dictionary_id='58811.Muhasebe Kodu'></label>
										<div class="col col-12">
											<div class="input-group">
												<input type="hidden" name="account_id" id="account_id" value="<cfif len(attributes.account_name)><cfoutput>#attributes.account_id#</cfoutput></cfif>">	
												<input type="text" name="account_name" id="account_name" onfocus="AutoComplete_Create('account_name','ACCOUNT_CODE','ACCOUNT_NAME,ACCOUNT_CODE','get_account_code','\'0\',0','ACCOUNT_CODE','account_id','','3','200');" style="width:120px;" value="<cfif len(attributes.account_name)><cfoutput>#attributes.account_name#</cfoutput></cfif>" onkeyup="get_wrk_acc_code_1();">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=inventory_report.account_id&field_name=inventory_report.account_name','list');"></span>
											</div>
										</div>	
									</div>
								</div>
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58551.Gider Kalemi'></label>
										<div class="col col-12">
											<select name="expense_item_id" id="expense_item_id" style="width:130px;" class="txt">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<cfoutput query="get_expense_item">
													<option value="#expense_item_id#" <cfif attributes.expense_item_id eq expense_item_id>selected</cfif>>
														#expense_item_name#
													</option>
												</cfoutput>
											</select>
										</div>	
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></label>
										<div class="col col-12">
											<select name="expense_center_id" id="expense_center_id" style="width:130px;" class="txt">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<cfoutput query="get_expense_center">
													<option value="#expense_id#" <cfif attributes.expense_center_id eq expense_id>selected</cfif>>
														#expense#
													</option>
												</cfoutput>
											</select>	
										</div>	
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='29420.Amortisman Yöntemi'></label>
										<div class="col col-12">
											<select name="amor_method" id="amor_method" style="width:130px;">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<option value="0" <cfif attributes.amor_method eq "0">selected</cfif>><cf_get_lang dictionary_id='29421.Azalan Bakiye Üzerinden'></option>
												<option value="1" <cfif attributes.amor_method eq "1">selected</cfif>><cf_get_lang dictionary_id='29422.Normal Amortisman'></option>
											</select>
										</div>	
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="58602.Demirbaş"> <cf_get_lang dictionary_id="38937.Tipi"></label>
										<div class="col col-12">
											<select name="inventory_type" id="inventory_type" style="width:130px;">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<option value="1" <cfif attributes.inventory_type eq "1">selected</cfif>><cf_get_lang dictionary_id="39693.Devirden Gelen"></option>
												<option value="2" <cfif attributes.inventory_type eq "2">selected</cfif>><cf_get_lang dictionary_id="39694.Faturadan Kaydedilen"></option>
												<option value="3" <cfif attributes.inventory_type eq "3">selected</cfif>><cf_get_lang dictionary_id="39699.Stok Fişinden Kaydedilen"></option>
												<option value="4" <cfif attributes.inventory_type eq "4">selected</cfif>><cf_get_lang dictionary_id="39700.İrsaliyeden Kaydedilen"></option>
											</select>
										</div>	
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'></label>
										<div class="col col-12">
											<select name="last_inv_status" id="last_inv_status" style="width:69px;">
												<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
												<option value="1" <cfif attributes.last_inv_status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
												<option value="0" <cfif attributes.last_inv_status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.pasif'></option>
											</select>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group" id="item-inventory_cat">
										<label class="col col-12"><cf_get_lang dictionary_id='41488.Sabit Kıymet Kategorisi'></label>
										<div class="col col-12">
											<div class="input-group">
											<input type="hidden" id="inventory_cat_id" name="inventory_cat_id" value="">
											<input type="text" id="inventory_cat" name="inventory_cat" value="<cfif len(attributes.inventory_cat_id)><cfoutput>#attributes.inventory_cat#</cfoutput></cfif>">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_inventory_cat&field_id=inventory_cat_id&field_name=inventory_cat','list');"></span>
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='29502.Abone No'></label>
										<div class="col col-12">
											<cf_wrk_subscriptions subscription_id='#attributes.subscription_id#' subscription_no='#attributes.subscription_no#' width_info='120' form_name='inventory_report' img_info='plus_thin'>						
										</div>	
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
										<div class="col col-12">
											<div class="input-group">
												<input type="hidden" name="project_id" id="project_id" value="<cfoutput>#attributes.project_id#</cfoutput>">
												<input type="text" name="project_head" id="project_head" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','250');" style="width:119px;" value="<cfoutput>#attributes.project_head#</cfoutput>">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=inventory_report.project_id&project_head=inventory_report.project_head');"></span>	
											</div>
										</div>	
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></label>
										<div class="col col-6">
											<div class="input-group">
												<cfsavecontent variable="message1"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'></cfsavecontent>
												<cfinput type="text" name="start_date" value="#attributes.start_date#" validate="#validate_style#" message="#message1#" style="width:65px;">
												<span class="input-group-addon">
													<cf_wrk_date_image date_field="start_date">
												</span>
											</div>
										</div>	
										<div class="col col-6">
											<div class="input-group">
												<cfinput type="text" name="finish_date" value="#attributes.finish_date#"  validate="#validate_style#" message="#message1#" style="width:65px;">
												<span class="input-group-addon">
													<cf_wrk_date_image date_field="finish_date">
												</span>
											</div>
										</div>	
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57628.Giriş Tarihi'></label>
										<div class="col col-6">
											<div class="input-group">
												<cfsavecontent variable="message1"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'></cfsavecontent>
												<cfinput type="text" name="start_date1" value="#attributes.start_date1#" validate="#validate_style#" message="#message1#" style="width:65px;">
												<span class="input-group-addon">
													<cf_wrk_date_image date_field="start_date1">
												</span>
											</div>	
										</div>	
										<div class="col col-6">
											<div class="input-group">
												<cfinput type="text" name="finish_date1" value="#attributes.finish_date1#"  validate="#validate_style#" message="#message1#" style="width:65px;">
												<span class="input-group-addon">
													<cf_wrk_date_image date_field="finish_date1">
												</span>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">&nbsp;</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12">
											<input type="checkbox" name="is_inv_info" id="is_inv_info" value="1" <cfif isdefined("attributes.is_inv_info")>checked</cfif>><cf_get_lang dictionary_id='40646.Demirbaş Alış Bilgilerini Göster'>
										</label>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12">
											<input type="checkbox" name="is_period_group" id="is_period_group" <cfif isdefined("attributes.is_period_group")>checked</cfif>><cf_get_lang dictionary_id='40434.Dönem Bazında Grupla'>
										</label>	
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12">
											<input type="checkbox" name="is_money2" id="is_money2" <cfif isdefined("attributes.is_money2") and len(attributes.is_money2)>checked</cfif>>2.<cf_get_lang dictionary_id='39647.Döviz Göster'>
										</label>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12">
											<cfif len(session.ep.money2)>
												<input type="checkbox" name="is_entry_date_info" id="is_entry_date_info" <cfif isdefined("attributes.is_entry_date_info")>checked<cfelseif attributes.report_type neq 1>disabled</cfif>><cf_get_lang dictionary_id="39702.Giriş Tarihindeki Durumu Göster">
											</cfif>
										</label>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='60776.Muhasebe seçeneği'></label>
										<div class="col col-12">
											<select name="accounting_target" id="accounting_target" style="width:140px;">
												<option value="0" <cfif attributes.accounting_target eq 0>selected</cfif>><cf_get_lang dictionary_id ='58793.tek düzen'></option>
												<option value="1" <cfif attributes.accounting_target eq 1>selected</cfif>><cf_get_lang dictionary_id ='58308.IFRS'></option>
												<option value="2" <cfif attributes.accounting_target eq 2>selected</cfif>><cf_get_lang dictionary_id="58793.Tek düzen"> + <cf_get_lang dictionary_id="58308.ufrs"></option>
											</select>
										</div>	
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58960.Rapor Tipi'></label>
										<div class="col col-12">
											<select name="report_type" id="report_type" style="width:153px;" onchange="kontrol_report_type();">
												<option value="1" <cfif attributes.report_type eq 1>selected</cfif>><cf_get_lang dictionary_id='40469.Sabit Kıymet Bazında'></option>
												<option value="2" <cfif attributes.report_type eq 2>selected</cfif>><cf_get_lang dictionary_id="57554.Giriş"> <cf_get_lang dictionary_id="57431.Çıkış"> <cf_get_lang dictionary_id="58601.Bazında"></option>
											</select>
										</div>	
									</div>
									<div class="form-group">
										<label id="is_input_output" class="col col-12 col-xs-12" <cfif attributes.report_type neq 2> style="display:none;"</cfif>><cf_get_lang dictionary_id="38933.Giriş-Çıkış"></label>
										<div class="col col-12 col-xs-12">
											<div id="input_output" <cfif attributes.report_type neq 2> style="display:none;"</cfif>>
												<select name="inventories" id="inventories" style="width:69px;" onchange="control_inventories()">
													<option value="2"><cf_get_lang dictionary_id='57708.Tümü'></option>
													<option value="1"<cfif isdefined('attributes.inventories') and (attributes.inventories eq 1)> selected</cfif>><cf_get_lang dictionary_id='57554.Giriş'></option>
													<option value="0"<cfif isdefined('attributes.inventories') and (attributes.inventories eq 0)> selected</cfif>><cf_get_lang dictionary_id='57431.Çıkış'></option>
												</select>
											</div>
										</div>
									</div>
									<div class="form-group">
										<label id="outputdate" class="col col-12 col-xs-12"  <cfif attributes.inventories neq 0> style="display:none;"</cfif>><cf_get_lang dictionary_id='29438.Çıkış Tarihi'></label>
										<div id="outputdate_" <cfif attributes.inventories neq 0> style="display:none;"</cfif> colspan="2">
											<div class="col col-6 col-xs-12">
												<div class="input-group">
													<cfsavecontent variable="message1"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'></cfsavecontent>
													<cfinput type="text" name="output_date_1" value="#attributes.output_date_1#" validate="#validate_style#" message="#message1#" style="width:65px;">
													<span class="input-group-addon">
													<cf_wrk_date_image date_field="output_date_1">
													</span> 
												</div>
											</div>
											<div class="col col-6 col-xs-12">
												<div class="input-group">	
													<cfinput type="text" name="output_date_2" value="#attributes.output_date_2#"  validate="#validate_style#" message="#message1#" style="width:65px;">
													<span class="input-group-addon">
													<cf_wrk_date_image date_field="output_date_2">
													</span>	
												</div>	
											</div>
										</div>
									</div> 
								</div>
							</div>
						</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
							<input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'> <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3" style="width:25px;">
							<cfelse>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
							</cfif>
							<input type="hidden" name="form_submitted" id="form_submitted" value="">
							<cf_wrk_report_search_button button_type='1' search_function='control()' is_excel='1'>
						</div>	  
					</div>
				 </div>
			 </div>
		</cf_report_list_search_area>
	</cf_report_list_search>
</cfform>
<cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-16">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-16">
		<cfset type_ = 1>
	<cfelse>
		<cfset type_ = 0>
</cfif>
<cfif isdefined("attributes.form_submitted")>
	<cfif get_all_inventory.recordcount>
		<!--- Yerini degistirmeyiniz. Excel alirken tum veriyi aldigimiz icin company_id_list,consumer_id_list gibi ifadeler maxrows kadar dönmeli --->
		<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
			<cfset type_ = 1>
			<cfset attributes.startrow=1>
			<cfset attributes.maxrows=get_all_inventory.QUERY_COUNT>
		<cfelse>
			<cfset type_ = 0>
		</cfif>
		<cfset project_id_list=''>
		<cfset department_id_list=''>
		<cfset company_id_list=''>
		<cfset consumer_id_list=''>
		<cfoutput query="get_all_inventory" >
			<cfif len(company_id) and company_id gt 0 and not listfind(company_id_list,company_id)>
				<cfset company_id_list=listappend(company_id_list,company_id)>
			</cfif>
			<cfif len(consumer_id) and consumer_id gt 0 and not listfind(consumer_id_list,consumer_id)>
				<cfset consumer_id_list=listappend(consumer_id_list,consumer_id)>
			</cfif>
			<cfif len(project_id) and project_id gt 0 and not listfind(project_id_list,project_id)>
				<cfset project_id_list=listappend(project_id_list,project_id)>
			</cfif>
			<cfif len(department_id) and department_id gt 0 and not listfind(department_id_list,department_id)>
				<cfset department_id_list=listappend(department_id_list,department_id)>
			</cfif>
		</cfoutput>
		<cfset company_id_list=listsort(company_id_list,"numeric")>
		<cfset consumer_id_list=listsort(consumer_id_list,"numeric")>
		<cfif len(company_id_list)>
			<cfquery name="get_company_detail" datasource="#DSN#">
				SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#) ORDER BY COMPANY_ID
			</cfquery>
		</cfif>
		<cfif len(consumer_id_list)>
			<cfquery name="get_consumer_detail" datasource="#DSN#">
				SELECT CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
			</cfquery>
		</cfif>
		<cfif len(project_id_list)>
			<cfset project_id_list=listsort(project_id_list,"numeric","ASC",",")>
			<cfquery name="get_pro" datasource="#dsn#">
				SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_id_list#) ORDER BY PROJECT_ID
			</cfquery>
		</cfif>
		<cfif len(department_id_list)>
			<cfset department_id_list=listsort(department_id_list,"numeric","ASC",",")>
			<cfquery name="get_dep" datasource="#dsn#">
				SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID IN (#department_id_list#) ORDER BY DEPARTMENT_ID
			</cfquery>
		</cfif>	
		<cfscript>
			toplam_miktar1 = 0;
			toplam_ilk_deger1 = 0;
			toplam_son_deger_2 = 0;
			son_toplam_son_deger_2 = 0;
			son_toplam_ilk_deger1 = 0;
			son_toplam_ilk_deger_21 = 0;
			toplam_donem_oncesi1 = 0;
			toplam_donem1 = 0;
			toplam_son_donem1 = 0;
			toplam_son_deger1 = 0;
			son_toplam_son_deger1 = 0;
			son_toplam_son_deger_21 = 0;
			toplam_ilk_deger_21 = 0;
			toplam_donem_oncesi_21 = 0;
			toplam_donem_21 = 0;
			toplam_son_donem_21 = 0;
			toplam_son_deger_21 = 0;
			genel_toplam_miktar = 0;
			genel_toplam_ilk_deger = 0;
			genel_toplam_donem_oncesi = 0;
			genel_son_toplam_ilk_deger = 0;
			genel_son_toplam_ilk_deger_2 = 0;
			genel_toplam_donem = 0;
			genel_toplam_son_donem = 0;
			genel_toplam_son_deger = 0;
			genel_toplam_ilk_deger_2 = 0;
			genel_toplam_donem_oncesi_2 = 0;
			genel_toplam_donem_2 = 0;
			genel_toplam_son_donem_2 = 0;
			genel_toplam_son_deger_2 = 0;
		</cfscript>
	</cfif>
	<cf_report_list>
			<thead>
				<tr>
					<th nowrap="nowrap"><cf_get_lang dictionary_id='57487.No'></th>
					<th width="100" nowrap><cf_get_lang dictionary_id='58602.Demirbaş'> <cf_get_lang dictionary_id='57487.No'></th>
					<th width="150" nowrap><cf_get_lang dictionary_id='41488.Sabit Kıymet Kategorisi'></th>
					<th width="150" nowrap><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<cfif isdefined("attributes.is_inv_info")>
						<th width="150" nowrap><cf_get_lang dictionary_id='57519.cari hesap'></th>
						<th width="150" nowrap><cf_get_lang dictionary_id='58133.Fatura no'></th>
						<th width="150" nowrap><cf_get_lang dictionary_id='58759.Fatura tarihi'></th>
					</cfif>
					<th width="80" nowrap><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
					<th width="80" nowrap><cf_get_lang dictionary_id='57628.Giriş Tarihi'></th>
					<cfif (attributes.inventories eq 0 or attributes.inventories eq 2) and attributes.report_type eq 2><th width="80" nowrap><cf_get_lang dictionary_id='29438.Çıkış Tarihi'></th></cfif>
					<th width="100" nowrap><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></th>
					<th width="100" nowrap><cf_get_lang dictionary_id='57587.Borç'> <cf_get_lang dictionary_id='58811.Muhasebe Kodu'></th>
					<th width="100" nowrap><cf_get_lang dictionary_id='57588.Alacak'> <cf_get_lang dictionary_id='58811.Muhasebe Kodu'></th>
					<th width="100" nowrap><cf_get_lang dictionary_id='58763.Depo'></th>
					<th width="100" nowrap><cf_get_lang dictionary_id='57416.Proje'></th>
					<th width="85" nowrap><cf_get_lang dictionary_id='39668.Faydalı Ömür'></th>
					<th width="85" nowrap><cf_get_lang dictionary_id='39667.Amortisman Oranı'></th>
					<th nowrap><cf_get_lang dictionary_id='40552.Hesaplama Dönemi'><br/>(<cf_get_lang dictionary_id='40553.Periyod/Yıl'>)</th>
					<th width="50" nowrap><cf_get_lang dictionary_id='57635.Miktar'></th>
					<th width="100" nowrap align="right"><cf_get_lang dictionary_id='39669.İlk Değer'></th>
					<cfif isdefined("attributes.is_money2")>
						<th width="125" nowrap align="right"><cf_get_lang dictionary_id='39669.İlk Değer'> <cfoutput>#session.ep.money2#</cfoutput></th>
					</cfif>
					<th width="100" nowrap align="right"><cf_get_lang dictionary_id ='40540.Toplam İlk Değer'></th>
					<cfif isdefined("attributes.is_money2")>
						<th width="125" nowrap align="right"><cf_get_lang dictionary_id='40540.Toplam İlk Değer'><cfoutput>#session.ep.money2#</cfoutput></th>
					</cfif>
					<cfif attributes.report_type eq 1>
						<th width="125" style="text-align:center;" nowrap><cf_get_lang dictionary_id='39671.Dönem Öncesi Birikmiş Amortisman'></th>
						<cfif isdefined("attributes.is_money2")>
							<th width="125" style="text-align:center;" nowrap><cf_get_lang dictionary_id='39671.Dönem Öncesi Birikmiş Amortisman'> <cfoutput>#session.ep.money2#</cfoutput></th>
						</cfif>
						<th width="125" style="text-align:center;" nowrap><cf_get_lang dictionary_id='39672.Dönem Ayrılan Amortisman'></th>
						<cfif isdefined("attributes.is_money2")>
						<th width="125" style="text-align:center;" nowrap><cf_get_lang dictionary_id='39672.Dönem Ayrılan Amortisman'>
							</th>
						</cfif>
						<th width="125" align="center" nowrap><cf_get_lang dictionary_id='39673.Toplam Birikmiş Amortisman'></th>
						<cfif isdefined("attributes.is_money2")>
							<th width="125" align="center" nowrap><cf_get_lang dictionary_id='39673.Toplam Birikmiş Amortisman'> <cfoutput>#session.ep.money2#</cfoutput></th>
						</cfif>
					</cfif>
					<th width="115" nowrap align="right"><cf_get_lang dictionary_id='39670.Son Değer'></th>
					<cfif isdefined("attributes.is_money2")>
						<th width="115" nowrap align="right"><cf_get_lang dictionary_id='39670.Son Değer'> <cfoutput>#session.ep.money2#</cfoutput></th>
					</cfif>
					<th width="115" nowrap align="right"><cf_get_lang dictionary_id='58604.Toplam Son Değer'></th>
					<cfif isdefined("attributes.is_money2")>
						<th width="115" nowrap align="right"><cf_get_lang dictionary_id='58604.Toplam Son Değer'><cfoutput>#session.ep.money2#</cfoutput></th>
					</cfif>
				</tr>
			</thead>
			<cfif isdefined("attributes.is_inv_info") and (attributes.inventories eq 0 or attributes.inventories eq 2) and attributes.report_type eq 2>
				<cfset colspan_info = 18>
			<cfelseif isdefined("attributes.is_inv_info")>
				<cfset colspan_info = 17>
			<cfelseif not isdefined("attributes.is_inv_info") and (attributes.inventories eq 0 or attributes.inventories eq 2) and attributes.report_type eq 2>
				<cfset colspan_info = 15>
			<cfelse>
				<cfset colspan_info = 14>
			</cfif>
			<cfif get_all_inventory.recordcount>
				<cfif attributes.page neq 1><!---devreden kısmı --->
					<cfset inventory_id_list = ''>
					<cfoutput>
						<cfscript>
							toplam_miktar1 = get_all_inventory.toplam_miktar;
							toplam_ilk_deger1 =get_all_inventory.toplam_ilk_deger;
							son_toplam_ilk_deger1 =get_all_inventory.son_toplam_ilk_deger;
							son_toplam_ilk_deger_21 =get_all_inventory.son_toplam_ilk_deger_2;
							if (attributes.report_type eq 1 )
							{
							toplam_donem_oncesi1 =get_all_inventory.toplam_donem_oncesi;
								toplam_donem1 = get_all_inventory.toplam_donem;
								toplam_donem_oncesi_21 = get_all_inventory.toplam_donem_oncesi_2;
								toplam_donem_21 = get_all_inventory.toplam_donem_2;
							}
						
							toplam_son_deger1 =get_all_inventory.toplam_son_deger;
							son_toplam_son_deger1 =get_all_inventory.son_toplam_son_deger;
							son_toplam_son_deger_21 = get_all_inventory.son_toplam_son_deger_2;
							toplam_ilk_deger_21 = get_all_inventory.toplam_ilk_deger_2;
						
							toplam_son_deger_21 =get_all_inventory.toplam_son_deger_2;
							toplam_son_donem1 = toplam_donem_oncesi1 +  toplam_donem1;
							toplam_son_donem_21 = toplam_donem_oncesi_21 + toplam_donem_21;
						</cfscript>
					</cfoutput> 
					<tbody>
						<cfoutput>
							<tr>
								<td colspan="#colspan_info#" align="right" class="txtboldblue"><cf_get_lang dictionary_id='58034.Devreden'></td>
								<td class="txtboldblue" align="right" format="numeric">#TLFormat(toplam_miktar1)#</td>
								<td class="txtboldblue" align="right" format="numeric">#TLFormat(toplam_ilk_deger1)#</td>
								<cfif isdefined("attributes.is_money2")><td class="txtboldblue" align="right" format="numeric">#TLFormat(toplam_ilk_deger_21)#</td></cfif>
								<td class="txtboldblue" align="right" format="numeric">#TLFormat(son_toplam_ilk_deger1)#</td>
								<cfif isdefined("attributes.is_money2")><td align="right" class="txtboldblue" format="numeric">#TLFormat(son_toplam_ilk_deger_21)#</td></cfif>
								<cfif attributes.report_type eq 1>
									<td class="txtboldblue" align="right" format="numeric">#TLFormat(toplam_donem_oncesi1)#</td>
									<cfif isdefined("attributes.is_money2")><td align="right" class="txtboldblue" format="numeric">#TLFormat(toplam_donem_oncesi_21)#</td></cfif>
									<td class="txtboldblue" align="right" format="numeric">#TLFormat(toplam_donem1)#</td>
									<cfif isdefined("attributes.is_money2")><td align="right" class="txtboldblue" format="numeric">#TLFormat(toplam_donem_21)#</td></cfif>
									<td class="txtboldblue" align="right" format="numeric">#TLFormat(toplam_son_donem1)#</td>
									<cfif isdefined("attributes.is_money2")><td align="right" class="txtboldblue" format="numeric">#TLFormat(toplam_son_donem_21)#</td></cfif>
								</cfif>
								<td align="right" class="txtboldblue" format="numeric">#TLFormat(toplam_son_deger1)#</td>
								<cfif isdefined("attributes.is_money2")><td align="right" class="txtboldblue" format="numeric">#TLFormat(toplam_son_deger_21)#</td></cfif>
								<td align="right" class="txtboldblue" format="numeric">#TLFormat(son_toplam_son_deger1)#</td>
								<cfif isdefined("attributes.is_money2")><td align="right" class="txtboldblue" format="numeric">#TLFormat(son_toplam_son_deger_21)#</td></cfif>
							</tr>
						</cfoutput>
					</tbody>
				</cfif><!---devreden kısmı --->
				<cfif not isdefined("attributes.is_period_group")>
					<tbody>
						<cfoutput query="get_all_inventory">
							<tr>
								<td>#rownum#</td>
								<td>#inventory_number#</td>
								<td>#inventory_cat#</td>
								<td>#inventory_name#</td>
								<cfif isdefined("attributes.is_inv_info")>
									<td>
										<cfif len(company_id) and company_id gt 0>
											<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
												#get_company_detail.FULLNAME[listfind(company_id_list,company_id,',')]#
											<cfelse>
												<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
													#get_company_detail.FULLNAME[listfind(company_id_list,company_id,',')]#
												<cfelse>
													<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','medium');">#get_company_detail.FULLNAME[listfind(company_id_list,company_id,',')]#</a>
												</cfif>
											</cfif>
										<cfelseif len(consumer_id) and consumer_id gt 0>
											<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
												#get_consumer_detail.CONSUMER_NAME[listfind(consumer_id_list,consumer_id,',')]# #get_consumer_detail.CONSUMER_SURNAME[listfind(consumer_id_list,consumer_id,',')]#
											<cfelse>
												<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#consumer_id#','medium');">#get_consumer_detail.CONSUMER_NAME[listfind(consumer_id_list,consumer_id,',')]# #get_consumer_detail.CONSUMER_SURNAME[listfind(consumer_id_list,consumer_id,',')]#</a>
											</cfif>
										</cfif>
									</td>
									<td>#invoice_number#</td>
									<td>
										<cfif len(invoice_date) and invoice_date neq 0>#dateformat(invoice_date,dateformat_style)#</cfif>
									</td>
								</cfif>
								<td>#dateformat(record_date,dateformat_style)#</td>
								<td>#dateformat(entry_date,dateformat_style)#</td>
								<cfif (attributes.inventories eq 0 or attributes.inventories eq 2) and attributes.report_type eq 2><td>#dateformat(OUTPUT_DATE,dateformat_style)#</td></cfif>
								<td>#account_id#</td>
								<td>#debt_account_id#</td>
								<td>#claim_account_id#</td>
								<td><cfif len(department_id_list) and len(department_id) and department_id gt 0>#get_dep.department_head[listfind(department_id_list,department_id,',')]#</cfif></td>
								<td><cfif len(project_id_list) and len(project_id) and project_id gt 0>#get_pro.project_head[listfind(project_id_list,project_id,',')]#</cfif></td>
								<td align="right"><cfif len(inventory_duration)>#TLFormat(inventory_duration)#</cfif></td>
								<td align="right" format="numeric">#amortizaton_estimate#</td>
								<td align="right" format="numeric">#account_period#</td>
								<td align="right" format="numeric">
									<cfif isdefined("attributes.is_entry_date_info")  or attributes.report_type eq 2>
										#row_amount#
										<cfset miktar = row_amount>
									<cfelse>
										<cfif len(sale_miktar)>
											#quantity-sale_miktar#
											<cfset miktar = quantity-sale_miktar>
										<cfelse>
											#quantity# 
											<cfset miktar = quantity>
										</cfif>
									</cfif>
								</td>
								<cfset toplam_miktar1 = toplam_miktar1 + miktar>
								<td align="right" format="numeric">#TlFormat(amount)#</td>
								<cfset toplam_ilk_deger1 = toplam_ilk_deger1 + amount>
								<cfif isdefined("attributes.is_money2")>
									<td align="right" format="numeric">#TlFormat(amount_2)#</td>
									<cfset toplam_ilk_deger_21= toplam_ilk_deger_21 + amount_2>
								</cfif>
								<cfif amount neq 0 and len(amount_2)>
									<cfset rate2 = amount_2 / amount>
								<cfelse>
									<cfset rate2 = 1>	
								</cfif>
								<td align="right" format="numeric">#TlFormat(amount*miktar)#</td>
								<cfset son_toplam_ilk_deger1 = son_toplam_ilk_deger1 + (amount*miktar)>
								<cfif isdefined("attributes.is_money2")>
									<cfset son_toplam_ilk_deger_21 = son_toplam_ilk_deger_21 + (amount_2*miktar)>
									<td align="right" format="numeric">#TlFormat(amount_2*miktar)#</td>
								</cfif>
								<cfset satir_toplam = 0>
								<cfset satir_toplam_2 = 0>
								<cfif len(last_value)>
									<cfset satir_donem_sonra = last_value_unit*miktar>
									<cfset satir_donem_sonra2 = last_value_unit*miktar*rate2>
								<cfelse>
									<cfset satir_donem_sonra = 0>
									<cfset satir_donem_sonra2 = 0>
								</cfif>
								<cfif len(first_value)>
									<cfset satir_donem_once = first_value_unit*miktar>
									<cfset satir_donem_once2 = first_value_unit*miktar*rate2>
								<cfelse>
									<cfset satir_donem_once = 0>
									<cfset satir_donem_once2 = 0>
								</cfif>
								<cfset satir_donem_once = (amount*miktar - last_inventory_value*miktar - satir_donem_sonra)>
								<cfset satir_donem_once2 = (amount_2*miktar - last_inventory_value_2*miktar - satir_donem_sonra2)>
								<cfif attributes.report_type eq 1>
									<td align="right" format="numeric">
									<!--- PY dönem öncesi --->
									<cfif len(DEVIR)>
										<cfif satir_donem_sonra lt 1>
											#tlformat(amount*miktar)#
											<cfset satir_donem_once = amount*miktar>
										<cfelse>
											<!--- #WRK_ROUND(100/INVENTORY_DURATION,3)#<br>
											#amount#-#miktar/100#-#100/INVENTORY_DURATION#-#session.ep.period_year-year(entry_date)#--->
											#tlformat((amount*miktar/100)*(amortizaton_estimate)*(session.ep.period_year-year(entry_date)))#
											<cfset satir_donem_once = (amount*miktar/100)*(amortizaton_estimate)*(session.ep.period_year-year(entry_date))>
										</cfif>
										<!---  TOPLAM TUTAR * 100/(FAYDALI ÖMÜR)*(bu sene - GİRİŞ TARİHİ yıl) --->
									<!---	#amount#-#miktar/100#-#100/INVENTORY_DURATION#-#session.ep.period_year-year(entry_date)#
										(amount*miktar/100)*(WRK_ROUND(100/INVENTORY_DURATION,5))*(session.ep.period_year-year(entry_date)) --->
										
									<cfelse>
										#TlFormat(satir_donem_once)#
									</cfif>
									<!---
									TOPLAM TUTAR * 100/(FAYDALI ÖMÜR)*2020-2015(GİRİŞ TARİHİ)
								** #WRK_ROUND(100/15,5)#	#(amount*miktar/100)*(WRK_ROUND(100/15,5))*5#  #tlformat((amount*miktar/100)*(WRK_ROUND(100/15,5))*5)#*** <br>
									toplam tutar - 
									#amount*miktar#**#last_inventory_value*miktar#**#satir_donem_sonra# <br>
										#amount#**#miktar#**#last_inventory_value#**#last_value_unit# --->
										
										<cfset satir_toplam = satir_toplam + satir_donem_once>
										<cfset toplam_donem_oncesi1 = toplam_donem_oncesi1 + satir_donem_once>
										<cfset toplam_son_donem1 = toplam_son_donem1 + satir_donem_once> 
									</td>
									<cfif isdefined("attributes.is_money2")>
										<td align="right" format="numeric">
											#TlFormat(satir_donem_once2)#
											<cfset satir_toplam_2 = satir_toplam_2 + satir_donem_once2>
											<cfset toplam_donem_oncesi_21 = toplam_donem_oncesi_21 + satir_donem_once2>
											<cfset toplam_son_donem_21 = toplam_son_donem_21 + satir_donem_once2> 
										</td>
									</cfif>
									<td align="right" format="numeric">
										#TlFormat(satir_donem_sonra)#
										<cfset satir_toplam = satir_toplam + satir_donem_sonra>
										<cfset toplam_donem1 = toplam_donem1 + satir_donem_sonra>
										<cfset toplam_son_donem1 = toplam_son_donem1 + satir_donem_sonra> 
									</td>
									<cfif isdefined("attributes.is_money2")>
										<td align="right" format="numeric">
											#TlFormat(satir_donem_sonra2)#
											<cfset satir_toplam_2 = satir_toplam_2 + satir_donem_sonra2>
											<cfset toplam_donem_21 = toplam_donem_21 + satir_donem_sonra2>
											<cfset toplam_son_donem_21 = toplam_son_donem_21 + satir_donem_sonra2> 
										</td>	
									</cfif>
									<td align="right" format="numeric">#TlFormat(satir_toplam)#</td>
									<cfif isdefined("attributes.is_money2")>
										<td align="right" format="numeric">#TlFormat(satir_toplam_2)#</td>
									</cfif>
									<cfset last_inventory_value_ = last_inventory_value>
									<cfset last_inventory_value_2_ = last_inventory_value_ *rate2>
									<td align="right" format="numeric">
										<cfif miktar eq 0>#TlFormat(0)#<cfelse>#TlFormat(last_inventory_value_)#</cfif>
									</td>
									<cfif miktar neq 0>
										<cfset toplam_son_deger1 = toplam_son_deger1 + last_inventory_value_>
									</cfif>
									<cfif isdefined("attributes.is_money2")>
										<td align="right" format="numeric">
											<cfif miktar eq 0>#TlFormat(0)#<cfelse>#TlFormat(last_inventory_value_2_)#</cfif>
										</td>
										<cfif miktar neq 0>
											<cfset toplam_son_deger_21 = toplam_son_deger_21 + last_inventory_value_2_>
										</cfif>
									</cfif>
									<td align="right" format="numeric">#TlFormat(last_inventory_value_*miktar)#</td>
									<cfset son_toplam_son_deger1 = son_toplam_son_deger1 + last_inventory_value_*miktar>
									<cfif isdefined("attributes.is_money2")>
										<td align="right" format="numeric">#TlFormat(last_inventory_value_2_*miktar)#</td>
											<cfset son_toplam_son_deger_21 = son_toplam_son_deger_21 + last_inventory_value_2_*miktar>
									</cfif>
								<cfelse>
									<cfset last_inventory_value_ = amount  - satir_donem_once - satir_donem_sonra>
									<cfset last_inventory_value_2_ = amount_2 - satir_donem_once2 - satir_donem_sonra2>
									<td align="right" format="numeric">#TlFormat(last_value)#</td>
									<cfif last_inventory_value_2_ neq 0><cfset rate2 = last_inventory_value_/last_inventory_value_2_><cfelse><cfset rate2 = 1></cfif>
									<cfset toplam_son_deger1 = toplam_son_deger1 + last_value>
									<cfif attributes.report_type neq 2><cfset last_value_2 = last_value / rate2></cfif>
									<cfif isdefined("attributes.is_money2")>
										<td align="right" format="numeric">#TlFormat(last_value*RATE2)#</td>
										<cfset toplam_son_deger_21 = toplam_son_deger_21 + (last_value*RATE2)>
									</cfif>
									<td align="right" format="numeric">#TlFormat(last_value*miktar)#</td>
									<cfset son_toplam_son_deger1 = son_toplam_son_deger1 + last_value*miktar>
									<cfif isdefined("attributes.is_money2")>
										<td align="right" format="numeric">#TlFormat((last_value*RATE2)*miktar)#</td>
										<cfset son_toplam_son_deger_21 = son_toplam_son_deger_21 + (last_value*RATE2)*miktar>
									</cfif>
								</cfif>
							</tr>
						</cfoutput>
					</tbody>
					<tfoot><!---Sayfa toplamı --->
						<cfoutput><!--- toplam satırı --->
							<tr>
								<td colspan="#colspan_info#" class="txtboldblue" align="right"><cf_get_lang dictionary_id='57680.Genel Toplam'></td>
								<td class="txtboldblue" align="right" format="numeric">#TLFormat(toplam_miktar1)#</td>
								<td class="txtboldblue" align="right" format="numeric">#TLFormat(toplam_ilk_deger1)#</td>
								<cfif isdefined("attributes.is_money2")><td class="txtboldblue" align="right" format="numeric">#TLFormat(toplam_ilk_deger_21)#</td></cfif>
								<td class="txtboldblue" align="right" format="numeric">#TLFormat(son_toplam_ilk_deger1)#</td>
								<cfif isdefined("attributes.is_money2")><td class="txtboldblue" align="right" format="numeric">#TLFormat(son_toplam_ilk_deger_21)#</td></cfif>
								<cfif attributes.report_type eq 1>
									<td class="txtboldblue" align="right" format="numeric">#TLFormat(toplam_donem_oncesi1)#</td>
									<cfif isdefined("attributes.is_money2")><td class="txtboldblue" align="right" format="numeric">#TLFormat(toplam_donem_oncesi_21)#</td></cfif>
									<td class="txtboldblue" align="right" format="numeric">#TLFormat(toplam_donem1)#</td>
									<cfif isdefined("attributes.is_money2")><td class="txtboldblue" align="right" format="numeric">#TLFormat(toplam_donem_21)#</td></cfif>
									<td class="txtboldblue" align="right" format="numeric">#TLFormat(toplam_son_donem1)#</td>
									<cfif isdefined("attributes.is_money2")><td class="txtboldblue" align="right" format="numeric">#TLFormat(toplam_son_donem_21)#</td></cfif>
								</cfif>
								<td class="txtboldblue" align="right" format="numeric">#TLFormat(toplam_son_deger1)#</td>
								<cfif isdefined("attributes.is_money2")><td class="txtboldblue" align="right" format="numeric">#TLFormat(toplam_son_deger_21)#</td></cfif>
								<td class="txtboldblue" align="right" format="numeric">#TLFormat(son_toplam_son_deger1)#</td>
								<cfif isdefined("attributes.is_money2")><td class="txtboldblue" align="right" format="numeric">#TLFormat(son_toplam_son_deger_21)#</td></cfif>
							</tr>
						</cfoutput>	
					</tfoot><!---Sayfa toplamı --->
				<cfelse>
					<tbody>
						<cfoutput query="get_all_inventory">
							<tr>
								<td>#rownum#</td>
								<td>#inventory_number#</td>
								<td>#inventory_cat#</td>
								<td>#inventory_name#</td>
								<cfif isdefined("attributes.is_inv_info")>
									<td>
										<cfif len(company_id) and company_id gt 0>
											<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
												#get_company_detail.FULLNAME[listfind(company_id_list,company_id,',')]#
											<cfelse>
												<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','medium');">#get_company_detail.FULLNAME[listfind(company_id_list,company_id,',')]#</a>
											</cfif>
										<cfelseif len(consumer_id) and consumer_id gt 0>
											<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
												#get_consumer_detail.CONSUMER_NAME[listfind(consumer_id_list,consumer_id,',')]# #get_consumer_detail.CONSUMER_SURNAME[listfind(consumer_id_list,consumer_id,',')]#
											<cfelse>
												<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#consumer_id#','medium');">#get_consumer_detail.CONSUMER_NAME[listfind(consumer_id_list,consumer_id,',')]# #get_consumer_detail.CONSUMER_SURNAME[listfind(consumer_id_list,consumer_id,',')]#</a>
											</cfif>
										</cfif>
									</td>
									<td>#invoice_number#</td>
									<td>
										<cfif len(invoice_date) and invoice_date neq 0>#dateformat(invoice_date,dateformat_style)#</cfif>
									</td>
								</cfif>
								<td>#dateformat(record_date,dateformat_style)#</td>
								<td>#dateformat(entry_date,dateformat_style)#</td>
								<cfif (attributes.inventories eq 0 or attributes.inventories eq 2) and attributes.report_type eq 2>
									<td>#dateformat(output_date,dateformat_style)#</td>
								</cfif>
								<td>#account_id#</td>
								<td>#debt_account_id#</td>
								<td>#claim_account_id#</td>
								<td><cfif len(department_id_list) and len(department_id) and department_id gt 0>#get_dep.department_head[listfind(department_id_list,department_id,',')]#</cfif></td>
								<td><cfif len(project_id_list) and len(project_id) and project_id gt 0>#get_pro.project_head[listfind(project_id_list,project_id,',')]#</cfif></td>
								<td align="right" format="numeric"><cfif len(inventory_duration)>#TLFormat(inventory_duration)#</cfif></td>
								<td align="right">#amortizaton_estimate#</td>
								<td align="right">#account_period#</td>
								<td align="right">
									#row_amount#
									<cfset miktar = row_amount>
								</td>
								<cfset toplam_miktar1 = toplam_miktar1 + miktar>
								<td align="right" format="numeric">#TlFormat(amount)#</td><!--- ilk değer --->
								<cfset toplam_ilk_deger1 = toplam_ilk_deger1 + amount>
								<cfif len(amount_2)>
									<cfset toplam_ilk_deger_21 = toplam_ilk_deger_21 + amount_2>
								</cfif>
								<cfif isdefined("attributes.is_money2")>
									<td align="right" format="numeric">#TlFormat(amount_2)#</td><!--- ilk değer (is_money2)--->
								</cfif>
								<cfif amount neq 0 and len(amount_2)>
									<cfset rate2 = amount_2 / amount>
								<cfelse>
									<cfset rate2 = 1>	
								</cfif>
								<td align="right" format="numeric">#TlFormat(amount*miktar)#</td>
								<cfset son_toplam_ilk_deger1 = son_toplam_ilk_deger1 + (amount*miktar)>
								<cfif isdefined("attributes.is_money2")>
									<cfif len(amount_2)>
										<cfset son_toplam_ilk_deger_21 = son_toplam_ilk_deger_21 + (amount_2*miktar)>
									</cfif>
									<td style="text-align:right;" format="numeric">
										<cfif len(amount_2)>
											#TlFormat(amount_2*miktar)#
										<cfelse>
											#TlFormat(0)#
										</cfif>
									</td>
								</cfif>
								<cfset satir_toplam = 0>
								<cfset satir_toplam_2 = 0>
								<cfif len(last_value)>
									<cfset satir_donem_sonra = last_value>
									<cfset satir_donem_sonra2 = last_value*rate2>
								<cfelse>
									<cfset satir_donem_sonra = 0>
									<cfset satir_donem_sonra2 = 0>
								</cfif>
								<cfif len(first_value)>
									<cfset satir_donem_once = first_value>
									<cfset satir_donem_once2 = first_value*rate2>
								<cfelse>
									<cfset satir_donem_once = 0>
									<cfset satir_donem_once2 = 0>
								</cfif>
								<cfset satir_donem_once = (amount - last_inventory_value - satir_donem_sonra)>
								<cfset satir_donem_once2 =  (amount_2 - last_inventory_value_2 - satir_donem_sonra2)>
								<cfif attributes.report_type eq 1>
									<td align="right" format="numeric">
									#TlFormat(satir_donem_once*miktar)#
										<cfset satir_toplam = satir_toplam + satir_donem_once*miktar>
										<cfset toplam_donem_oncesi1 = toplam_donem_oncesi1 + satir_donem_once*miktar>
										<cfset toplam_son_donem1 = toplam_son_donem1 + satir_donem_once*miktar> 
									</td>
									<cfif isdefined("attributes.is_money2")>
										<td align="right" format="numeric">
											#TlFormat(satir_donem_once2*miktar)#
											<cfset satir_toplam_2 = satir_toplam_2 + satir_donem_once2*miktar>
											<cfset toplam_donem_oncesi_21 = toplam_donem_oncesi_21 + satir_donem_once2*miktar>
											<cfset toplam_son_donem_21 = toplam_son_donem_21 + satir_donem_once2*miktar> 
										</td>
									</cfif>
									<td align="right" format="numeric">
										#TlFormat(satir_donem_sonra*miktar)#
										<cfset satir_toplam = satir_toplam + satir_donem_sonra*miktar>
										<cfset toplam_donem1 = toplam_donem1 + satir_donem_sonra*miktar>
										<cfset toplam_son_donem1 = toplam_son_donem1 + satir_donem_sonra*miktar> 
									</td>
									<cfif isdefined("attributes.is_money2")>
										<td align="right" format="numeric">
											#TlFormat(satir_donem_sonra2*miktar)#
											<cfset satir_toplam_2 = satir_toplam_2 + satir_donem_sonra2*miktar>
											<cfset toplam_donem_21 = toplam_donem_21 + satir_donem_sonra2*miktar>
											<cfset toplam_son_donem_21 = toplam_son_donem_21 + satir_donem_sonra2*miktar> 
										</td>	
									</cfif>
									<td align="right" format="numeric">#TlFormat(satir_toplam)#</td>
									<cfif isdefined("attributes.is_money2")>
										<td align="right" format="numeric">#TlFormat(satir_toplam_2)#</td>
									</cfif>
								</cfif>
								<cfset last_inventory_value_ = amount - satir_donem_once - satir_donem_sonra>
								<cfset last_inventory_value_2_ = amount_2 - satir_donem_once2 - satir_donem_sonra2>
								<cfset toplam_son_deger1 = toplam_son_deger1 + last_inventory_value_>
								<td align="right" format="numeric">#TlFormat(last_inventory_value_)#</td>
								<cfif isdefined("attributes.is_money2") and len(attributes.is_money2)>
									<td align="right" format="numeric">#TlFormat(last_inventory_value_2_)#</td>
									<cfset toplam_son_deger_2 = toplam_son_deger_2 + last_inventory_value_2_>
								</cfif>
								<td align="right" format="numeric">#TlFormat(last_inventory_value_*miktar)#</td>
								<cfset son_toplam_son_deger = son_toplam_son_deger1 + last_inventory_value_*miktar>
								<cfif isdefined("attributes.is_money2") and len(attributes.is_money2)>
									<td align="right" format="numeric">#TlFormat(last_inventory_value_2_*miktar)#</td>
									<cfset son_toplam_son_deger_2 = son_toplam_son_deger_2 + last_inventory_value_2_*miktar>
								</cfif>
							</tr>
							<cfif (rownum neq query_count and entry_year neq entry_year[rownum + 1])>
								<tfoot>
									<tr>
										<td class="txtboldblue" colspan="#colspan_info#">#entry_year# <cf_get_lang dictionary_id='57492.Toplam'></td>
										<td align="right" class="txtboldblue" format="numeric">#TLFormat(toplam_miktar1)#</td>
										<td align="right" class="txtboldblue" format="numeric">#TLFormat(toplam_ilk_deger1)#</td>
										<cfif isdefined("attributes.is_money2")><td align="right" class="txtboldblue" format="numeric">#TLFormat(toplam_ilk_deger_21)#</td></cfif>
										<td align="right" class="txtboldblue" format="numeric">#TLFormat(son_toplam_ilk_deger1)#</td>
										<cfif isdefined("attributes.is_money2")><td align="right" class="txtboldblue" format="numeric">#TLFormat(son_toplam_ilk_deger_21)#</td></cfif>
										<cfif attributes.report_type eq 1>
											<td align="right" class="txtboldblue" format="numeric">#TLFormat(toplam_donem_oncesi1)#</td>
											<cfif isdefined("attributes.is_money2")><td align="right" class="txtboldblue" format="numeric">#TLFormat(toplam_donem_oncesi_21)#</td></cfif>
											<td align="right" class="txtboldblue" format="numeric">#TLFormat(toplam_donem1)#</td>
											<cfif isdefined("attributes.is_money2")><td align="right" class="txtboldblue" format="numeric">#TLFormat(toplam_donem_21)#</td></cfif>
											<td align="right" class="txtboldblue" format="numeric">#TLFormat(toplam_son_donem1)#</td>
											<cfif isdefined("attributes.is_money2")><td align="right" class="txtboldblue" format="numeric">#TLFormat(toplam_son_donem_21)#</td></cfif>
										</cfif>
										<td align="right" class="txtboldblue" format="numeric">#TLFormat(toplam_son_deger1)#</td>
										<cfif isdefined("attributes.is_money2")><td align="right" class="txtboldblue" format="numeric">#TLFormat(toplam_son_deger_21)#</td></cfif>
										<td align="right" class="txtboldblue" format="numeric">#TLFormat(son_toplam_son_deger1)#</td>
										<cfif isdefined("attributes.is_money2")><td align="right" class="txtboldblue" format="numeric">#TLFormat(son_toplam_son_deger_21)#</td></cfif>
									</tr>
								</tfoot>
								<cfset genel_toplam_ilk_deger = genel_toplam_ilk_deger + toplam_ilk_deger1>
								<cfset genel_toplam_donem_oncesi = genel_toplam_donem_oncesi + toplam_donem_oncesi1>
								<cfset genel_toplam_donem = genel_toplam_donem + toplam_donem1>
								<cfset genel_toplam_son_donem = genel_toplam_son_donem + toplam_son_donem1>
								<cfset genel_toplam_son_deger = genel_toplam_son_deger + toplam_son_deger1>
								<cfset genel_toplam_ilk_deger_2 = genel_toplam_ilk_deger_2 + toplam_ilk_deger_21>
								<cfset genel_toplam_donem_oncesi_2 = genel_toplam_donem_oncesi_2 + toplam_donem_oncesi_21>
								<cfset genel_toplam_donem_2 = genel_toplam_donem_2 + toplam_donem_21>
								<cfset genel_toplam_son_donem_2 = genel_toplam_son_donem_2 + toplam_son_donem_21>
								<cfset genel_toplam_son_deger_2 = genel_toplam_son_deger_2 + toplam_son_deger_21>
								<cfset genel_son_toplam_ilk_deger = genel_son_toplam_ilk_deger + son_toplam_ilk_deger1>
								<cfset genel_son_toplam_ilk_deger_2 = genel_son_toplam_ilk_deger_2 + son_toplam_ilk_deger_21>
								<cfset genel_toplam_miktar = genel_toplam_miktar + toplam_miktar1>
								<cfset toplam_miktar1 = 0>
								<cfset toplam_ilk_deger1 = 0>
								<cfset toplam_donem_oncesi1 = 0>
								<cfset toplam_donem1 = 0>
								<cfset toplam_son_donem1 = 0>
								<cfset toplam_son_deger1 = 0>
								<cfset toplam_ilk_deger_21 = 0>

								<cfset toplam_donem_oncesi_21 = 0>
								<cfset toplam_donem_21 = 0>
								<cfset toplam_son_donem_21 = 0>
								<cfset toplam_son_deger_21 = 0>
								<cfset son_toplam_ilk_deger1 = 0>
								<cfset son_toplam_ilk_deger_21 = 0>
							<cfelseif rownum eq query_count>
								<tfoot>
								<tr>
									<td class="txtboldblue" colspan="#colspan_info#">#entry_year# <cf_get_lang dictionary_id='57492.Toplam'></td>
									<td align="right" class="txtboldblue" format="numeric">#TLFormat(toplam_miktar1)#</td>
									<td align="right" class="txtboldblue" format="numeric">#TLFormat(toplam_ilk_deger1)#</td>
									<cfif isdefined("attributes.is_money2")><td align="right" class="txtboldblue" format="numeric">#TLFormat(toplam_ilk_deger_21)#</td></cfif>
									<td align="right" class="txtboldblue" format="numeric">#TLFormat(son_toplam_ilk_deger1)#</td>
									<cfif isdefined("attributes.is_money2")><td align="right" class="txtboldblue" format="numeric">#TLFormat(son_toplam_ilk_deger_21)#</td></cfif>
									<cfif attributes.report_type eq 1>
										<td align="right" class="txtboldblue" format="numeric">#TLFormat(toplam_donem_oncesi1)#</td>
										<cfif isdefined("attributes.is_money2")><td align="right" class="txtboldblue" format="numeric">#TLFormat(toplam_donem_oncesi_21)#</td></cfif>
										<td align="right" class="txtboldblue" format="numeric">#TLFormat(toplam_donem1)#</td>
										<cfif isdefined("attributes.is_money2")><td align="right" class="txtboldblue" format="numeric">#TLFormat(toplam_donem_21)#</td></cfif>
										<td align="right" class="txtboldblue" format="numeric">#TLFormat(toplam_son_donem1)#</td>
										<cfif isdefined("attributes.is_money2")><td align="right" class="txtboldblue" format="numeric">#TLFormat(toplam_son_donem_21)#</td></cfif> 
									</cfif>
									<td align="right" class="txtboldblue" format="numeric">#TLFormat(toplam_son_deger1)#</td>
									<cfif isdefined("attributes.is_money2")><td align="right" class="txtboldblue" format="numeric">#TLFormat(toplam_son_deger_21)#</td></cfif>
									<td align="right" class="txtboldblue" format="numeric">#TLFormat(son_toplam_son_deger1)#</td>
									<cfif isdefined("attributes.is_money2")><td align="right" class="txtboldblue" format="numeric">#TLFormat(son_toplam_son_deger_21)#</td></cfif>
								</tr>
								<cfset genel_toplam_ilk_deger = genel_toplam_ilk_deger + toplam_ilk_deger1>
								<cfset genel_toplam_donem_oncesi = genel_toplam_donem_oncesi + toplam_donem_oncesi1>
								<cfset genel_toplam_donem = genel_toplam_donem + toplam_donem1>
								<cfset genel_toplam_son_donem = genel_toplam_son_donem + toplam_son_donem1>
								<cfset genel_toplam_son_deger = genel_toplam_son_deger + toplam_son_deger1>
								<cfset genel_toplam_ilk_deger_2 = genel_toplam_ilk_deger_2 + toplam_ilk_deger_21>
								<cfset genel_toplam_donem_oncesi_2 = genel_toplam_donem_oncesi_2 + toplam_donem_oncesi_21>
								<cfset genel_toplam_donem_2 = genel_toplam_donem_2 + toplam_donem_21>
								<cfset genel_toplam_son_donem_2 = genel_toplam_son_donem_2 + toplam_son_donem_21>
								<cfset genel_toplam_son_deger_2 = genel_toplam_son_deger_2 + toplam_son_deger_21>
								<cfset genel_son_toplam_ilk_deger = genel_son_toplam_ilk_deger + son_toplam_ilk_deger1>
								<cfset genel_son_toplam_ilk_deger_2 = genel_son_toplam_ilk_deger_2 + son_toplam_ilk_deger_21>
								<cfset genel_toplam_miktar = genel_toplam_miktar + toplam_miktar1>
								<tr>
									<td class="txtboldblue" colspan="#colspan_info#"><cf_get_lang dictionary_id='57680.Genel Toplam'></td>
									<td align="right" class="txtboldblue" format="numeric">#TLFormat(genel_toplam_miktar)#</td>
									<td align="right" class="txtboldblue" format="numeric">#TLFormat(genel_toplam_ilk_deger)#</td>
									<cfif isdefined("attributes.is_money2")><td align="right" class="txtboldblue" format="numeric">#TLFormat(genel_toplam_ilk_deger_2)#</td></cfif>
									<td align="right" class="txtboldblue" format="numeric">#TLFormat(genel_son_toplam_ilk_deger)#</td>
									<cfif isdefined("attributes.is_money2")><td align="right" class="txtboldblue" format="numeric">#TLFormat(genel_son_toplam_ilk_deger_2)#</td></cfif>
									<cfif attributes.report_type eq 1>
										<td align="right" class="txtboldblue" format="numeric">#TLFormat(genel_toplam_donem_oncesi)#</td>
										<cfif isdefined("attributes.is_money2")><td align="right" class="txtboldblue" format="numeric">#TLFormat(genel_toplam_donem_oncesi_2)#</td></cfif>
										<td align="right" class="txtboldblue" format="numeric">#TLFormat(genel_toplam_donem)#</td>
										<cfif isdefined("attributes.is_money2")><td align="right" class="txtboldblue" format="numeric">#TLFormat(genel_toplam_donem_2)#</td></cfif>
										<td align="right" class="txtboldblue" format="numeric">#TLFormat(genel_toplam_son_donem)#</td>
										<cfif isdefined("attributes.is_money2")><td align="right" class="txtboldblue" format="numeric">#TLFormat(genel_toplam_son_donem_2)#</td></cfif> 
									</cfif>
									<td align="right" class="txtboldblue" format="numeric">#TLFormat(genel_toplam_son_deger)#</td>
									<cfif isdefined("attributes.is_money2")><td align="right" class="txtboldblue" format="numeric">#TLFormat(genel_toplam_son_deger_2)#</td></cfif>
									<td align="right" class="txtboldblue" format="numeric">#TLFormat(son_toplam_son_deger1)#</td>
									<cfif isdefined("attributes.is_money2")><td align="right" class="txtboldblue" format="numeric">#TLFormat(son_toplam_son_deger_2)#</td></cfif>
								</tr>
								</tfoot>
							</cfif>
						</cfoutput>
					</tbody>	  
				</cfif>
			<cfelse>
				<tr>
					<td colspan="31"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
				</tr>
			</cfif>
	</cf_report_list>
	<cfset adres = "">
	<cfif isdefined("attributes.form_submitted") and attributes.totalrecords gt attributes.maxrows>
		<cfset adres = "report.detail_inventory_report&form_submitted=1">
		<cfif len(attributes.keyword)>
			<cfset adres = "#adres#&keyword=#attributes.keyword#">
		</cfif>
		<cfif len(attributes.start_date)>
			<cfset adres = "#adres#&start_date=#attributes.start_date#">
		</cfif>
		<cfif len(attributes.finish_date)>
			<cfset adres = "#adres#&finish_date=#attributes.finish_date#">
		</cfif>
		<cfif len(attributes.start_date1)>
			<cfset adres = "#adres#&start_date1=#attributes.start_date1#">
		</cfif>
		<cfif len(attributes.finish_date1)>
			<cfset adres = "#adres#&finish_date1=#attributes.finish_date1#">
		</cfif>
		<cfif len(attributes.output_date_1)>
			<cfset adres = "#adres#&output_date_1=#attributes.output_date_1#">
		</cfif>
		<cfif len(attributes.output_date_2)>
			<cfset adres = "#adres#&output_date_2=#attributes.output_date_2#">
		</cfif>
		<cfif len(attributes.expense_item_id)>
			<cfset adres = "#adres#&expense_item_id=#attributes.expense_item_id#">
		</cfif>
		<cfif len(attributes.expense_center_id)>
			<cfset adres = "#adres#&expense_center_id=#attributes.expense_center_id#">
		</cfif>
		<cfif len(attributes.amor_method)>
			<cfset adres = "#adres#&amor_method=#attributes.amor_method#">
		</cfif>
		<cfif len(attributes.account_id) and len(attributes.account_name)>
			<cfset adres = "#adres#&account_id=#attributes.account_id#">
			<cfset adres = "#adres#&account_name=#attributes.account_name#">
		</cfif>
		<cfif len(attributes.debt_account_id) and len(attributes.debt_account_name)>
			<cfset adres = "#adres#&debt_account_id=#attributes.debt_account_id#">
			<cfset adres = "#adres#&debt_account_name=#attributes.debt_account_name#">
		</cfif>			
		<cfif len(attributes.claim_account_id) and len(attributes.claim_account_name)>
			<cfset adres = "#adres#&claim_account_id=#attributes.claim_account_id#">
			<cfset adres = "#adres#&claim_account_name=#attributes.claim_account_name#">
		</cfif>	
		<cfif len(attributes.department_id) and len(attributes.department_name)>
			<cfset adres = "#adres#&department_id=#attributes.department_id#">
			<cfset adres = "#adres#&department_name=#attributes.department_name#">
			<cfset adres = "#adres#&location_id=#attributes.location_id#">
		</cfif>	
		<cfif len(attributes.project_id) and len(attributes.project_head)>
			<cfset adres = "#adres#&project_id=#attributes.project_id#">
			<cfset adres = "#adres#&project_head=#attributes.project_head#">
		</cfif>
		<cfif len(attributes.last_inv_status) and len(attributes.last_inv_status)>
			<cfset adres = "#adres#&last_inv_status=#attributes.last_inv_status#">
		</cfif>	
		<cfif isdefined("attributes.inventory_type")>
			<cfset adres = "#adres#&inventory_type=#attributes.inventory_type#">
		</cfif>
		<cfif isdefined('attributes.subscription_id') and len(attributes.subscription_id) and isdefined('attributes.subscription_no') and len(attributes.subscription_no)>
			<cfset adres = "#adres#&subscription_id=#attributes.subscription_id#&subscription_no=#attributes.subscription_no#">
		</cfif>
		<cfif isdefined("attributes.inventories")>
			<cfset adres = "#adres#&inventories=#attributes.inventories#">
		</cfif>
		<cfif isdefined("attributes.report_type")>
			<cfset adres = "#adres#&report_type=#attributes.report_type#">
		</cfif>
		<cfif isdefined("attributes.is_money2")>
			<cfset adres = "#adres#&is_money2=#attributes.is_money2#">
		</cfif>
		<cfif isdefined("attributes.is_inv_info")>
			<cfset adres = "#adres#&is_inv_info=#attributes.is_inv_info#">
		</cfif>
		<cfif isdefined("attributes.is_entry_date_info")>
			<cfset adres = "#adres#&is_entry_date_info=#attributes.is_entry_date_info#">
		</cfif>
		<cfif isdefined("attributes.inventory_cat_id") and Len(attributes.inventory_cat_id) and Len(attributes.inventory_cat)>
			<cfset adres = "#adres#&inventory_cat_id=#attributes.inventory_cat_id#&inventory_cat=#attributes.inventory_cat#">
		</cfif>
		<cf_paging 
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres#"></td>
	
	</cfif>
</cfif>
<script type="text/javascript">
	function control()
	{
		if ((document.inventory_report.start_date.value != '') && (document.inventory_report.finish_date.value != '') &&
		!date_check(inventory_report.start_date,inventory_report.finish_date,"<cf_get_lang dictionary_id ='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
		{
			return false;
		}

		if ((document.inventory_report.start_date1.value != '') && (document.inventory_report.finish_date1.value != '') &&
		!date_check(inventory_report.start_date1,inventory_report.finish_date1,"<cf_get_lang dictionary_id ='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
		{
			return false;
		}

		if(document.inventory_report.is_excel.checked==false)
		{
			document.inventory_report.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
			return true;
		}
		else
			document.inventory_report.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_detail_inventory_report</cfoutput>" 
	}
	function kontrol_report_type()
	{
		if(document.inventory_report.report_type.value == 2)
		{
			input_output.style.display = '';
			is_input_output.style.display = '';
		}
		else
		{
			input_output.style.display = 'none';
			is_input_output.style.display = 'none';
			document.inventory_report.inventories.value = 2;
		}
		if(document.inventory_report.report_type.value == 1)
		{
			document.inventory_report.is_entry_date_info.disabled = false;
		}
		else
		{
			document.inventory_report.is_entry_date_info.disabled = true;
		}
		control_inventories();
	}
	function control_inventories()
	{
		if(document.inventory_report.report_type.value == 2 && document.inventory_report.inventories.value == 0)
		{
			outputdate.style.display = '';
			outputdate_.style.display = '';
		}
		else
		{
			outputdate.style.display = 'none';
			outputdate_.style.display = 'none';
		}
	}
</script>
<!-- sil -->