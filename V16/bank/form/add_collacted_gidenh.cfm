<cf_get_lang_set module_name="bank">
	<cf_xml_page_edit fuseact="bank.add_collacted_gidenh">
	<cfinclude template="../query/control_bill_no.cfm">
	<cfif not isdefined("attributes.new_dsn3")><cfset new_dsn3 = dsn3><cfelse><cfset new_dsn3 = attributes.new_dsn3></cfif>
	<cfif not isdefined("attributes.new_dsn2")><cfset new_dsn2 = dsn2><cfelse><cfset new_dsn2 = attributes.new_dsn2></cfif>
	<cfif not isdefined("session_basket_kur_ekle")>
		<cfinclude template="../../objects/functions/get_basket_money_js.cfm">  <!---rate1Array, rate2Array bu fonksiyonda tanımlanıyor.--->
		
	</cfif>
	<!--- <cfinclude template="../query/get_control.cfm"> --->
	<cfinclude template="../../cash/query/get_money.cfm">
	<cfset paper_type = 2>
	<cfset str_money_bskt_main = session.ep.money>
	<cfif paper_type eq 1>
		<cfset select_input = 'account_id'>
		<cfset auto_paper_type = "incoming_transfer">
	<cfelseif paper_type eq 2>
		<cfset select_input = 'account_id'>
		<cfset auto_paper_type = "outgoing_transfer">
	<cfelseif paper_type eq 3>
		<cfset select_input = 'cash_action_to_cash_id'>
		<cfset auto_paper_type = "revenue_receipt">
	<cfelseif paper_type eq 4>
		<cfset select_input = 'cash_action_from_cash_id'>
		<cfset auto_paper_type = "cash_payment">
	<cfelseif paper_type eq 5>
		<cfset select_input = 'action_currency_id'>
		<cfset auto_paper_type = "debit_claim">
	</cfif>
	<cfif isdefined("attributes.multi_id") and len(attributes.multi_id)>
		<cfif (session.ep.isBranchAuthorization)>
			<cfset control_branch_id = ListGetAt(session.ep.user_location,2,"-")>
		</cfif>
		<cfquery name="get_money" datasource="#dsn2#">
			SELECT MONEY_TYPE AS MONEY,* FROM BANK_ACTION_MULTI_MONEY WHERE ACTION_ID = #attributes.multi_id# ORDER BY ACTION_MONEY_ID
		</cfquery>
		<cfif not get_money.recordcount>
			<cfquery name="get_money" datasource="#dsn2#">
				SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE MONEY_STATUS=1 ORDER BY MONEY_ID
			</cfquery>
		</cfif>
		<cfquery name="GET_SPECIAL_DEFINITION" datasource="#DSN#">
			SELECT SPECIAL_DEFINITION_ID,SPECIAL_DEFINITION FROM SETUP_SPECIAL_DEFINITION <cfif listfind("2,4",paper_type)> WHERE SPECIAL_DEFINITION_TYPE = 2<cfelseif listfind("1,3",paper_type)>WHERE SPECIAL_DEFINITION_TYPE = 1</cfif>
		</cfquery>
		<cfquery name="get_action_detail" datasource="#dsn2#">
			SELECT
				BAM.*,
				BA.ACTION_TO_COMPANY_ID AS ACTION_COMPANY_ID,
				BA.ACTION_TO_CONSUMER_ID AS ACTION_CONSUMER_ID,
				BA.ACTION_TO_EMPLOYEE_ID AS ACTION_EMPLOYEE_ID,
				ISNULL(C.FULLNAME,ISNULL(CM.CONSUMER_NAME+' '+CM.CONSUMER_SURNAME,E.EMPLOYEE_NAME +' '+E.EMPLOYEE_SURNAME )) AS NAME_COMPANY,
				BA.ACTION_VALUE_2 AS ACTION_VALUE_OTHER,
				BA.SUBSCRIPTION_ID,
				(SELECT SUBSCRIPTION_NO FROM #dsn3_alias#.SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID =BA.SUBSCRIPTION_ID ) AS SUBSCRIPTION_NO,
				BA.PAPER_NO,
				BA.PROJECT_ID,
				PP.PROJECT_HEAD,
				BA.ACTION_ID,
				BA.ACTION_VALUE,
				BA.ACTION_DETAIL,
				BA.OTHER_MONEY AS ACTION_CURRENCY,
				BAM.UPD_STATUS,
				BA.MASRAF,
				BA.EXPENSE_CENTER_ID,
				EC.EXPENSE,
				BA.EXPENSE_ITEM_ID,
				EI.EXPENSE_ITEM_NAME,
				BA.FROM_BRANCH_ID,
				BA.ASSETP_ID,
				AP.ASSETP,
				BA.SPECIAL_DEFINITION_ID,
				BA.ACC_DEPARTMENT_ID AS DEPARTMENT_ID,
				BA.ACC_TYPE_ID,
				SA.ACC_TYPE_NAME,
				BA.AVANS_ID,
				BA.BANK_ORDER_ID,
				C.MEMBER_CODE,
				BA.ACTION_CURRENCY_ID AS ACTION_CURRENCY2,
				BA.SYSTEM_ACTION_VALUE
			FROM
				BANK_ACTIONS_MULTI BAM
				LEFT JOIN BANK_ACTIONS BA ON BAM.MULTI_ACTION_ID = BA.MULTI_ACTION_ID 
				LEFT JOIN #dsn_alias#.COMPANY C ON BA.ACTION_TO_COMPANY_ID=C.COMPANY_ID
				LEFT JOIN #dsn_alias#.CONSUMER CM ON CM.CONSUMER_ID = BA.ACTION_TO_CONSUMER_ID
				LEFT JOIN #dsn_alias#.EMPLOYEES E ON E.EMPLOYEE_ID = BA.ACTION_TO_EMPLOYEE_ID
				LEFT JOIN #dsn_alias#.PRO_PROJECTS PP ON BA.PROJECT_ID = PP.PROJECT_ID
				LEFT JOIN #dsn_alias#.ASSET_P AP ON BA.ASSETP_ID = AP.ASSETP_ID
				LEFT JOIN #dsn_alias#.SETUP_ACC_TYPE SA ON SA.ACC_TYPE_ID = BA.ACC_TYPE_ID
				LEFT JOIN EXPENSE_CENTER EC ON EC.EXPENSE_ID = BA.EXPENSE_CENTER_ID
				LEFT JOIN EXPENSE_ITEMS EI ON EI.EXPENSE_ITEM_ID = BA.EXPENSE_ITEM_ID
				WHERE
					BAM.MULTI_ACTION_ID = #url.multi_id#
					<cfif (session.ep.isBranchAuthorization)>
					AND                    
					(
						BA.ACTION_TYPE_ID NOT IN (21,22,23) AND
						(BA.FROM_BRANCH_ID = #control_branch_id# OR
						BA.TO_BRANCH_ID = #control_branch_id#)
					)
					</cfif>
				ORDER BY
					BA.ACTION_ID
		</cfquery>
		<cfset from_account_id = get_action_detail.from_account_id>
		<cfset from_branch_id = get_action_detail.from_branch_id>
		<cfset from_department_id = get_action_detail.ACC_DEPARTMENT_ID>
	<cfelseif isdefined("attributes.puantaj_id") and len(attributes.puantaj_id)>
		<cfquery name="get_action_detail" datasource="#dsn#">
			SELECT
				EP.DEKONT_ID,
				'' PROCESS_CAT,
				EP.ACTION_DATE,
				'' AS ACTION_COMPANY_ID,
				'' AS ACTION_CONSUMER_ID,
				EPCR.EMPLOYEE_ID AS ACTION_EMPLOYEE_ID,
				'' AS PROJECT_HEAD,
				EC.EXPENSE,
				EI.EXPENSE_ITEM_NAME,
				'' AS ASSETP,
				'' AS MEMBER_CODE,
				(E.EMPLOYEE_NAME +' '+E.EMPLOYEE_SURNAME ) AS NAME_COMPANY,
				((EPCR.ACTION_VALUE
				-
				ISNULL(
				(
					SELECT 
						SUM(#dsn_alias#.IS_ZERO(AMOUNT_2,AMOUNT))
					FROM
						EMPLOYEES_PUANTAJ_ROWS_EXT EXT,
						EMPLOYEES_PUANTAJ_ROWS EPR
					WHERE
						EPR.EMPLOYEE_PUANTAJ_ID = EXT.EMPLOYEE_PUANTAJ_ID
						AND (EPR.IN_OUT_ID = EPCR.IN_OUT_ID OR EPCR.IN_OUT_ID IS NULL)
						AND EPR.PUANTAJ_ID = #attributes.puantaj_id#
						AND EPR.EMPLOYEE_ID = EPCR.EMPLOYEE_ID
						AND EXT.EXT_TYPE = 1
				)
				,0))/(EPCR.ACTION_VALUE/EPCR.OTHER_ACTION_VALUE)) ACTION_VALUE_OTHER,
				'' SUBSCRIPTION_ID,
				'' AS SUBSCRIPTION_NO,
				'' PAPER_NO,
				'' PROJECT_ID,
				'' ACTION_ID,
				(EPCR.ACTION_VALUE
				-
				ISNULL(
				(
					SELECT 
						SUM(#dsn_alias#.IS_ZERO(AMOUNT_2,AMOUNT))
					FROM
						EMPLOYEES_PUANTAJ_ROWS_EXT EXT,
						EMPLOYEES_PUANTAJ_ROWS EPR
					WHERE
						EPR.EMPLOYEE_PUANTAJ_ID = EXT.EMPLOYEE_PUANTAJ_ID
						AND (EPR.IN_OUT_ID = EPCR.IN_OUT_ID OR EPCR.IN_OUT_ID IS NULL)
						AND EPR.PUANTAJ_ID = #attributes.puantaj_id#
						AND EPR.EMPLOYEE_ID = EPCR.EMPLOYEE_ID
						AND EXT.EXT_TYPE = 1
				)
				,0)
				) ACTION_VALUE,
				EP.ACTION_DETAIL,
				EP.OTHER_MONEY AS ACTION_CURRENCY,
				0 UPD_STATUS,
				0 MASRAF,
				EPCR.EXPENSE_CENTER_ID,
				EPCR.EXPENSE_ITEM_ID,
				'' ASSETP_ID,
				'' FROM_BRANCH_ID,
				'' SPECIAL_DEFINITION_ID,
				EPCR.ACC_TYPE_ID,
				SA.ACC_TYPE_NAME,
				'' ACTION_CURRENCY2
			FROM
				EMPLOYEES_PUANTAJ_CARI_ACTIONS EP INNER JOIN 
				EMPLOYEES_PUANTAJ_CARI_ACTIONS_ROW EPCR ON EP.DEKONT_ID = EPCR.DEKONT_ID 
				LEFT JOIN SETUP_ACC_TYPE SA ON SA.ACC_TYPE_ID = EPCR.ACC_TYPE_ID
				LEFT JOIN #dsn_alias#.EMPLOYEES E ON E.EMPLOYEE_ID = EPCR.EMPLOYEE_ID
				LEFT JOIN EXPENSE_CENTER EC ON EC.EXPENSE_ID = EPCR.EXPENSE_CENTER_ID
				LEFT JOIN EXPENSE_ITEMS EI ON EI.EXPENSE_ITEM_ID = EPCR.EXPENSE_ITEM_ID
			WHERE
				EP.PUANTAJ_ID = #attributes.puantaj_id# AND
				EP.IS_VIRTUAL = #attributes.is_virtual_puantaj#
				AND EPCR.ACTION_VALUE > 0
				AND (EPCR.ACC_TYPE_ID IS NULL OR EPCR.ACC_TYPE_ID < 0 OR SA.IS_SALARY_ACCOUNT = 1)<!--- sadece standart işlem tipindeki satırlar gelsin --->
				AND 
				(
					(EPCR.ACTION_VALUE
					-
					ISNULL(
					(
						SELECT 
							SUM(#dsn_alias#.IS_ZERO(AMOUNT_2,AMOUNT))
						FROM
							EMPLOYEES_PUANTAJ_ROWS_EXT EXT,
							EMPLOYEES_PUANTAJ_ROWS EPR
						WHERE
							EPR.EMPLOYEE_PUANTAJ_ID = EXT.EMPLOYEE_PUANTAJ_ID
							AND (EPR.IN_OUT_ID = EPCR.IN_OUT_ID OR EPCR.IN_OUT_ID IS NULL)
							AND EPR.PUANTAJ_ID = #attributes.puantaj_id#
							AND EPR.EMPLOYEE_ID = EPCR.EMPLOYEE_ID
							AND EXT.EXT_TYPE = 1
					)
					,0)
					) > 0
					AND (EPCR.IS_TAX_REFUND <>1)
				) 
			UNION
			SELECT
				EP.DEKONT_ID,
				'' PROCESS_CAT,
				EP.ACTION_DATE,
				'' AS ACTION_COMPANY_ID,
				'' AS ACTION_CONSUMER_ID,
				EPCR.EMPLOYEE_ID AS ACTION_EMPLOYEE_ID,
				'' AS PROJECT_HEAD,
				EC.EXPENSE,
				EI.EXPENSE_ITEM_NAME,
				'' AS ASSETP,
				'' AS MEMBER_CODE,
				   (E.EMPLOYEE_NAME +' '+E.EMPLOYEE_SURNAME ) AS NAME_COMPANY,
				((EPCR.ACTION_VALUE)/(EPCR.ACTION_VALUE/EPCR.OTHER_ACTION_VALUE)) ACTION_VALUE_OTHER,
				'' SUBSCRIPTION_ID,
				'' AS SUBSCRIPTION_NO,
				'' PAPER_NO,
				'' PROJECT_ID,
				'' ACTION_ID,
				(EPCR.ACTION_VALUE) AS ACTION_VALUE,
				EP.ACTION_DETAIL,
				EP.OTHER_MONEY AS ACTION_CURRENCY,
				0 UPD_STATUS,
				0 MASRAF,
				EPCR.EXPENSE_CENTER_ID,
				EPCR.EXPENSE_ITEM_ID,
				'' ASSETP_ID,
				'' FROM_BRANCH_ID,
				'' SPECIAL_DEFINITION_ID,
				EPCR.ACC_TYPE_ID,
				SA.ACC_TYPE_NAME,
				'' ACTION_CURRENCY2
			FROM
				EMPLOYEES_PUANTAJ_CARI_ACTIONS EP INNER JOIN 
				EMPLOYEES_PUANTAJ_CARI_ACTIONS_ROW EPCR ON EP.DEKONT_ID = EPCR.DEKONT_ID
				LEFT JOIN SETUP_ACC_TYPE SA ON SA.ACC_TYPE_ID = EPCR.ACC_TYPE_ID
				LEFT JOIN #dsn_alias#.EMPLOYEES E ON E.EMPLOYEE_ID = EPCR.EMPLOYEE_ID
				LEFT JOIN EXPENSE_CENTER EC ON EC.EXPENSE_ID = EPCR.EXPENSE_CENTER_ID
				LEFT JOIN EXPENSE_ITEMS EI ON EI.EXPENSE_ITEM_ID = EPCR.EXPENSE_ITEM_ID
			WHERE
				EP.PUANTAJ_ID = #attributes.puantaj_id# AND
				EP.IS_VIRTUAL = #attributes.is_virtual_puantaj#
				AND EPCR.ACTION_VALUE > 0
				AND (EPCR.ACC_TYPE_ID IS NULL OR EPCR.ACC_TYPE_ID < 0 OR SA.IS_SALARY_ACCOUNT = 1)<!--- sadece standart işlem tipindeki satırlar gelsin --->
				AND 
				(
					(EPCR.ACTION_VALUE) >0
					AND EPCR.IS_TAX_REFUND =1
				) 		
		</cfquery>
		<cfif get_action_detail.recordcount>
			<cfquery name="get_money" datasource="#dsn#">
				SELECT MONEY_TYPE AS MONEY,* FROM EMPLOYEES_PUANTAJ_CARI_ACTIONS_MONEY WHERE ACTION_ID = #get_action_detail.dekont_id#
			</cfquery>
		<cfelse>
			<cfset get_action_detail.recordcount = 0>	
		</cfif>
		<cfif not get_money.recordcount>
			<cfquery name="get_money" datasource="#dsn2#">
				SELECT MONEY,0 AS IS_SELECTED, * FROM SETUP_MONEY WHERE MONEY_STATUS = 1 ORDER BY MONEY_ID
			</cfquery>
		</cfif>
		<cfquery name="GET_SPECIAL_DEFINITION" datasource="#DSN#">
			SELECT SPECIAL_DEFINITION_ID,SPECIAL_DEFINITION FROM SETUP_SPECIAL_DEFINITION <cfif listfind("2,4",paper_type)> WHERE SPECIAL_DEFINITION_TYPE = 2<cfelseif listfind("1,3",paper_type)>WHERE SPECIAL_DEFINITION_TYPE = 1</cfif>
		</cfquery>
		<cfset from_account_id = ''>
		<cfset from_branch_id = ''>
		<cfset from_department_id = ''>
	<cfelseif isdefined("attributes.collacted_havale_list") and len(attributes.collacted_havale_list)>
		<cfquery name="get_action_detail" datasource="#dsn2#">
			SELECT
				BO.COMPANY_ID AS ACTION_COMPANY_ID,
				BO.CONSUMER_ID AS ACTION_CONSUMER_ID,
				BO.EMPLOYEE_ID AS ACTION_EMPLOYEE_ID,
				BO.OTHER_MONEY_VALUE AS ACTION_VALUE_OTHER,
				BO.PROJECT_ID AS PROJECT_ID,
				PP.PROJECT_HEAD,
				'' AS EXPENSE,
				'' AS EXPENSE_ITEM_NAME,
				'' AS ASSETP,
				C.MEMBER_CODE,
				ISNULL(C.FULLNAME,ISNULL(CM.CONSUMER_NAME+' '+CM.CONSUMER_SURNAME,E.EMPLOYEE_NAME +' '+E.EMPLOYEE_SURNAME )) AS NAME_COMPANY,
				BO.SUBSCRIPTION_ID,
				(SELECT SUBSCRIPTION_NO FROM #dsn3_alias#.SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID =BO.SUBSCRIPTION_ID ) AS SUBSCRIPTION_NO,
				'' PAPER_NO,
				'' ACTION_ID,
				BO.ACTION_VALUE AS ACTION_VALUE,
				'' ACTION_DETAIL,
				BO.OTHER_MONEY AS ACTION_CURRENCY,
				'' FROM_BRANCH_ID,
				0 MASRAF,
				'' EXPENSE_CENTER_ID,
				'' EXPENSE_ITEM_ID,
				'' ASSETP_ID,
				BO.SPECIAL_DEFINITION_ID,
				'' ACC_DEPARTMENT_ID,
					 BO.ACC_TYPE_ID,
				SA.ACC_TYPE_NAME,
				'' MULTI_ACTION_ID,
				'' ACTION_TYPE_ID,
				'' AS FROM_ACCOUNT_ID,
				BO.PAYMENT_DATE AS ACTION_DATE,
				#attributes.collacted_process_cat# PROCESS_CAT,
				BANK_ORDER_TYPE_ID,
				BANK_ORDER_ID,
				'' ACTION_CURRENCY2
			FROM
				BANK_ORDERS BO
				LEFT JOIN #dsn_alias#.COMPANY C ON BO.COMPANY_ID=C.COMPANY_ID
				LEFT JOIN #dsn_alias#.CONSUMER CM ON CM.CONSUMER_ID = BO.CONSUMER_ID
				LEFT JOIN #dsn_alias#.EMPLOYEES E ON E.EMPLOYEE_ID = BO.EMPLOYEE_ID
				LEFT JOIN #dsn_alias#.PRO_PROJECTS PP ON BO.PROJECT_ID = PP.PROJECT_ID
				LEFT JOIN #dsn_alias#.SETUP_ACC_TYPE SA ON SA.ACC_TYPE_ID = BO.ACC_TYPE_ID
			WHERE
				BO.BANK_ORDER_ID IN (#attributes.collacted_havale_list#)
		</cfquery>
		<cfoutput query="get_action_detail">
			 <cfquery name="get_bank_order_type" datasource="#dsn2#">
				SELECT BANK_ORDER_TYPE_ID FROM BANK_ORDERS WHERE BANK_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_action_detail.bank_order_id#"> 
			</cfquery>
		</cfoutput>
		<cfquery name="GET_SPECIAL_DEFINITION" datasource="#DSN#">
			SELECT SPECIAL_DEFINITION_ID,SPECIAL_DEFINITION FROM SETUP_SPECIAL_DEFINITION <cfif listfind("2,4",paper_type)> WHERE SPECIAL_DEFINITION_TYPE = 2<cfelseif listfind("1,3",paper_type)>WHERE SPECIAL_DEFINITION_TYPE = 1</cfif>
		</cfquery>
		<cfif len(attributes.collacted_bank_account)><cfset from_account_id = attributes.collacted_bank_account><cfelse><cfset from_account_id = get_action_detail.from_account_id></cfif>
		<cfset from_branch_id = get_action_detail.from_branch_id>
		<cfset from_department_id = get_action_detail.ACC_DEPARTMENT_ID>
	<!--- avans taleplerinden geliyor ise--->
	<cfelseif isdefined('attributes.payment_ids') and len(attributes.payment_ids)>
		<cfquery name="get_action_detail" datasource="#dsn#">
			SELECT 
				'' AS ACTION_COMPANY_ID,
				'' AS ACTION_CONSUMER_ID,
				CP.TO_EMPLOYEE_ID AS ACTION_EMPLOYEE_ID,
				'' AS FROM_ACCOUNT_ID,
				CP.ID AS ACTION_ID,
				(SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = CP.TO_EMPLOYEE_ID) AS NAME_COMPANY,
				E.EMPLOYEE_NO AS MEMBER_CODE,
				'' AS ASSETP,
				'' AS ASSETP_ID,
				'' as PROCESS_CAT,
				'' SUBSCRIPTION_ID,
				'' AS SUBSCRIPTION_NO,
				'' AS PAPER_NO,
				CP.AMOUNT AS ACTION_VALUE,
				CP.AMOUNT AS ACTION_VALUE_OTHER,
				0 AS MASRAF,
				CP.MONEY AS ACTION_CURRENCY,
				CP.MONEY AS ACTION_CURRENCY2,
				'' as ACTION_TYPE_ID,
				'' SPECIAL_DEFINITION_ID,
				'' AS ACTION_DATE,
				CP.PERIOD_ID,
				CP.ID AS AVANS_ID,
				CP.TO_EMPLOYEE_ID,
				(SELECT EXPENSE FROM EXPENSE_CENTER EC,EMPLOYEES_IN_OUT_PERIOD EIP WHERE EC.EXPENSE_CODE = EIP.EXPENSE_CODE AND EIP.PERIOD_ID = CP.PERIOD_ID AND CP.IN_OUT_ID = EIP.IN_OUT_ID) AS EXPENSE,
				(SELECT EXPENSE_CENTER_ID FROM EXPENSE_CENTER EC,EMPLOYEES_IN_OUT_PERIOD EIP WHERE EC.EXPENSE_CODE = EIP.EXPENSE_CODE AND EIP.PERIOD_ID = CP.PERIOD_ID AND CP.IN_OUT_ID = EIP.IN_OUT_ID) AS EXPENSE_CENTER_ID,
				(SELECT EXPENSE_ID FROM EXPENSE_CENTER EC,EMPLOYEES_IN_OUT_PERIOD EIP WHERE EC.EXPENSE_CODE = EIP.EXPENSE_CODE AND EIP.PERIOD_ID = CP.PERIOD_ID AND CP.IN_OUT_ID = EIP.IN_OUT_ID) AS EXPENSE_ID,
				'' AS EXPENSE_NAME,
				'' AS EXPENSE,
				'' AS EXPENSE_CODE_NAME,
				'' AS EXPENSE_ITEM_ID,
				'' AS EXPENSE_ITEM_NAME,
				(SELECT TOP 1 EA.ACCOUNT_CODE FROM EMPLOYEES_ACCOUNTS EA WHERE EA.EMPLOYEE_ID = CP.TO_EMPLOYEE_ID AND EA.IN_OUT_ID = EI.IN_OUT_ID AND EA.PERIOD_ID=CP.PERIOD_ID AND EA.ACC_TYPE_ID=ISNULL((SELECT ACC_TYPE_ID FROM SETUP_PAYMENT_INTERRUPTION WHERE ODKES_ID = DEMAND_TYPE),-2)) AS ACCOUNT_CODE ,
				E.EMPLOYEE_NO,
				ISNULL((SELECT ACC_TYPE_ID FROM SETUP_PAYMENT_INTERRUPTION WHERE ODKES_ID = CP.DEMAND_TYPE),-2) AS ACC_TYPE_ID,
				(SELECT ACC_TYPE_NAME FROM SETUP_ACC_TYPE WHERE ACC_TYPE_ID = ISNULL((SELECT ACC_TYPE_ID FROM SETUP_PAYMENT_INTERRUPTION WHERE ODKES_ID = CP.DEMAND_TYPE),-2)) ACC_TYPE_NAME,
				CP.DETAIL AS ACTION_DETAIL,
				CP.PROJECT_ID,
				(SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = CP.PROJECT_ID) AS PROJECT_HEAD
			FROM 
				CORRESPONDENCE_PAYMENT CP,
				EMPLOYEES E,
				EMPLOYEES_IN_OUT EI
			WHERE 
				CP.ID IN(#attributes.payment_ids#) AND
				CP.IN_OUT_ID = EI.IN_OUT_ID AND 
				EI.EMPLOYEE_ID = E.EMPLOYEE_ID 
		</cfquery>
		<!---<cfif get_payments.recordcount>
			<cfoutput query="get_payments">
				<script type="text/javascript">
					add_row('#AMOUNT#','','#EMPLOYEE_NO#','employee','','','#TO_EMPLOYEE_ID#_#ACC_TYPE_ID#','#NAMESURNAME#-#ACC_TYPE_NAME#','#ACCOUNT_CODE#','','#EXPENSE_ID#','#EXPENSE_ITEM_ID#','#EXPENSE_NAME#','#EXPENSE_ITEM_NAME#','','','','','#PROJECT_ID#','#PROJECT_HEAD#','','#DETAIL#','','','','','','','','#get_payments.id#','');
				</script>
			</cfoutput>
		</cfif>--->
		<cfset from_account_id = ''>
		<cfset from_branch_id = ''>
		<cfset from_department_id = ''>
		
		<cfquery name="GET_SPECIAL_DEFINITION" datasource="#DSN#">
			SELECT SPECIAL_DEFINITION_ID,SPECIAL_DEFINITION FROM SETUP_SPECIAL_DEFINITION <cfif listfind("2,4",paper_type)> WHERE SPECIAL_DEFINITION_TYPE = 2<cfelseif listfind("1,3",paper_type)>WHERE SPECIAL_DEFINITION_TYPE = 1</cfif>
		</cfquery>
		<!--- Taksitli avans taleplerinden geliyor ise--->
	<cfelseif isdefined('attributes.other_payment_ids') and len(attributes.other_payment_ids)>
		<cfquery name="get_action_detail" datasource="#dsn#">
			SELECT 
				'' AS ACTION_COMPANY_ID,
				'' AS ACTION_CONSUMER_ID,
				SGR.EMPLOYEE_ID AS ACTION_EMPLOYEE_ID,
				'' AS FROM_ACCOUNT_ID,
				SGR.SPGR_ID AS ACTION_ID,
				(SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = SGR.EMPLOYEE_ID) AS NAME_COMPANY,
				E.EMPLOYEE_NO AS MEMBER_CODE,
				'' AS ASSETP,
				'' AS ASSETP_ID,
				'' as PROCESS_CAT,
				'' SUBSCRIPTION_ID,
				'' AS SUBSCRIPTION_NO,
				'' AS PAPER_NO,
				SGR.AMOUNT_GET AS ACTION_VALUE,
				SGR.AMOUNT_GET AS ACTION_VALUE_OTHER,
				0 AS MASRAF,
				'TL' AS ACTION_CURRENCY,
				'' AS ACTION_CURRENCY2,
				'' as ACTION_TYPE_ID,
				'' SPECIAL_DEFINITION_ID,
				'' AS ACTION_DATE,
				SGR.PERIOD_GET,
				SGR.SPGR_ID AS AVANS_ID,
				SGR.EMPLOYEE_ID,
				(SELECT EXPENSE FROM EXPENSE_CENTER EC,EMPLOYEES_IN_OUT_PERIOD EIP WHERE EC.EXPENSE_CODE = EIP.EXPENSE_CODE AND EIP.PERIOD_ID = SGR.PERIOD_GET AND SGR.IN_OUT_ID = EIP.IN_OUT_ID) AS EXPENSE,
				(SELECT EXPENSE_CENTER_ID FROM EXPENSE_CENTER EC,EMPLOYEES_IN_OUT_PERIOD EIP WHERE EC.EXPENSE_CODE = EIP.EXPENSE_CODE AND EIP.PERIOD_ID = SGR.PERIOD_GET AND SGR.IN_OUT_ID = EIP.IN_OUT_ID) AS EXPENSE_CENTER_ID,
				(SELECT EXPENSE_ID FROM EXPENSE_CENTER EC,EMPLOYEES_IN_OUT_PERIOD EIP WHERE EC.EXPENSE_CODE = EIP.EXPENSE_CODE AND EIP.PERIOD_ID = SGR.PERIOD_GET AND SGR.IN_OUT_ID = EIP.IN_OUT_ID) AS EXPENSE_ID,
				(SELECT EXPENSE FROM EXPENSE_CENTER EC,EMPLOYEES_IN_OUT_PERIOD EIP WHERE EC.EXPENSE_CODE = EIP.EXPENSE_CODE AND EIP.PERIOD_ID = SGR.PERIOD_GET AND SGR.IN_OUT_ID = EIP.IN_OUT_ID) AS EXPENSE_NAME,
				(SELECT EXPENSE_CODE FROM EMPLOYEES_IN_OUT_PERIOD WHERE IN_OUT_ID = EI.IN_OUT_ID AND PERIOD_ID = SGR.PERIOD_GET) AS EXPENSE_CODE,
				(SELECT EXPENSE_CODE_NAME FROM EMPLOYEES_IN_OUT_PERIOD WHERE IN_OUT_ID = EI.IN_OUT_ID AND PERIOD_ID = SGR.PERIOD_GET) AS EXPENSE_CODE_NAME,
				(SELECT EXPENSE_ITEM_ID FROM EMPLOYEES_IN_OUT_PERIOD WHERE IN_OUT_ID = EI.IN_OUT_ID AND PERIOD_ID = SGR.PERIOD_GET) AS EXPENSE_ITEM_ID,
				(SELECT EXPENSE_ITEM_NAME FROM EMPLOYEES_IN_OUT_PERIOD WHERE IN_OUT_ID = EI.IN_OUT_ID AND PERIOD_ID = SGR.PERIOD_GET) AS EXPENSE_ITEM_NAME,
				(SELECT TOP 1 EA.ACCOUNT_CODE FROM EMPLOYEES_ACCOUNTS EA WHERE EA.EMPLOYEE_ID = SGR.EMPLOYEE_ID AND EA.IN_OUT_ID = EI.IN_OUT_ID AND EA.PERIOD_ID=SGR.PERIOD_GET AND EA.ACC_TYPE_ID=ISNULL((SELECT ACC_TYPE_ID FROM SETUP_PAYMENT_INTERRUPTION WHERE ODKES_ID = SGR.ODKES_ID),-2)) AS ACCOUNT_CODE ,
				E.EMPLOYEE_NO,
				'' AS ACC_TYPE_NAME,
				SGR.DETAIL AS ACTION_DETAIL,
				'' AS PROJECT_ID,
				'' AS PROJECT_HEAD,
				ISNULL((SELECT ACC_TYPE_ID FROM SETUP_PAYMENT_INTERRUPTION WHERE ODKES_ID = SGR.ODKES_ID),-2) AS ACC_TYPE_ID,
				(SELECT ACC_TYPE_NAME FROM SETUP_ACC_TYPE WHERE ACC_TYPE_ID = ISNULL((SELECT ACC_TYPE_ID FROM SETUP_PAYMENT_INTERRUPTION WHERE ODKES_ID = SGR.ODKES_ID),-2)) ACC_TYPE_NAME
			FROM 
				SALARYPARAM_GET_REQUESTS SGR,
				EMPLOYEES E,
				EMPLOYEES_IN_OUT EI
			WHERE 
				SGR.SPGR_ID IN(#attributes.other_payment_ids#) AND
				SGR.IN_OUT_ID = EI.IN_OUT_ID AND 
				EI.EMPLOYEE_ID = E.EMPLOYEE_ID 
		</cfquery>
		<cfset from_account_id = ''>
		<cfset from_branch_id = ''>
		<cfset from_department_id = ''>
		<cfquery name="GET_SPECIAL_DEFINITION" datasource="#DSN#">
			SELECT SPECIAL_DEFINITION_ID,SPECIAL_DEFINITION FROM SETUP_SPECIAL_DEFINITION <cfif listfind("2,4",paper_type)> WHERE SPECIAL_DEFINITION_TYPE = 2<cfelseif listfind("1,3",paper_type)>WHERE SPECIAL_DEFINITION_TYPE = 1</cfif>
		</cfquery>
	<cfelse>
		<cfquery name="GET_SPECIAL_DEFINITION" datasource="#DSN#">
			SELECT SPECIAL_DEFINITION_ID,SPECIAL_DEFINITION FROM SETUP_SPECIAL_DEFINITION <cfif listfind("2,4",paper_type)> WHERE SPECIAL_DEFINITION_TYPE = 2<cfelseif listfind("1,3",paper_type)>WHERE SPECIAL_DEFINITION_TYPE = 1</cfif>
		</cfquery>
		<cfset from_account_id = ''>
		<cfset from_branch_id = ''>
		<cfset from_department_id = ''>
		<cfset get_action_detail.recordcount = 0>
	</cfif>
	<cfscript>
		sepet = StructNew();
		sepet.satir = ArrayNew(1);
		if(IsDefined('get_action_detail.recordcount') and len(get_action_detail.recordcount)){
		for(i=1;i<=get_action_detail.recordcount;i++)
		{
			sepet.satir[i] = StructNew();
			
			sepet.satir[i].ACTION_COMPANY_ID = get_action_detail.ACTION_COMPANY_ID[i];
			if(isdefined("attributes.multi_id") and len(attributes.multi_id))
			{
					
					sepet.satir[i].AVANS_ID = get_action_detail.AVANS_ID[i];
					sepet.satir[i].ACTION_CURRENCY2 = get_action_detail.ACTION_CURRENCY2[i];
					sepet.satir[i].SYSTEM_AMOUNT = get_action_detail.SYSTEM_ACTION_VALUE[i];
			}
			sepet.satir[i].MEMBER_CODE = get_action_detail.MEMBER_CODE[i];
			if(len(get_action_detail.ACC_TYPE_NAME[i]))
				sepet.satir[i].COMP_NAME = get_action_detail.NAME_COMPANY[i] & '-' & get_action_detail.ACC_TYPE_NAME[i];
			else
				sepet.satir[i].COMP_NAME = get_action_detail.NAME_COMPANY[i];
			sepet.satir[i].PROJECT_HEAD = get_action_detail.PROJECT_HEAD[i];
			sepet.satir[i].ASSET_NAME = get_action_detail.ASSETP[i];
			sepet.satir[i].ROW_EXP_CENTER_NAME = get_action_detail.EXPENSE[i];
			sepet.satir[i].ROW_EXP_ITEM_NAME = get_action_detail.EXPENSE_ITEM_NAME[i];
			if(get_action_detail.ACTION_COMPANY_ID[i] != '')
			sepet.satir[i].MEMBER_TYPE = 'partner';
			else if(get_action_detail.ACTION_EMPLOYEE_ID[i] != '')
			sepet.satir[i].MEMBER_TYPE = 'employee';
			else
			sepet.satir[i].MEMBER_TYPE = 'consumer';
			if(len(get_action_detail.ACC_TYPE_ID[i]) and len(get_action_detail.ACTION_COMPANY_ID[i]))
				sepet.satir[i].ACTION_COMPANY_ID = get_action_detail.ACTION_COMPANY_ID[i] & '_' & get_action_detail.ACC_TYPE_ID[i];
			else
				sepet.satir[i].ACTION_COMPANY_ID = get_action_detail.ACTION_COMPANY_ID[i];
			if(len(get_action_detail.ACC_TYPE_ID[i]) and len(get_action_detail.ACTION_CONSUMER_ID[i]))
				sepet.satir[i].ACTION_CONSUMER_ID = get_action_detail.ACTION_CONSUMER_ID[i] & '_' & get_action_detail.ACC_TYPE_ID[i];
			else
				sepet.satir[i].ACTION_CONSUMER_ID = get_action_detail.ACTION_CONSUMER_ID[i];
			if(len(get_action_detail.ACC_TYPE_ID[i]))
				sepet.satir[i].ACTION_EMPLOYEE_ID = get_action_detail.ACTION_EMPLOYEE_ID[i] & '_' & get_action_detail.ACC_TYPE_ID[i];
			else
				sepet.satir[i].ACTION_EMPLOYEE_ID = get_action_detail.ACTION_EMPLOYEE_ID[i];
			sepet.satir[i].PAPER_NUMBER = get_action_detail.PAPER_NO[i];
			sepet.satir[i].SUBSCRIPTION_ID = get_action_detail.SUBSCRIPTION_ID[i];
			sepet.satir[i].SUBSCRIPTION_NO = get_action_detail.SUBSCRIPTION_NO[i];
			sepet.satir[i].ACTION_VALUE = get_action_detail.ACTION_VALUE[i] - get_action_detail.MASRAF[i];
			sepet.satir[i].ACTION_VALUE_OTHER = get_action_detail.ACTION_VALUE_OTHER[i];
			sepet.satir[i].ACTION_DETAIL = get_action_detail.ACTION_DETAIL[i];
			sepet.satir[i].ASSET_ID = get_action_detail.ASSETP_ID[i];
			
			sepet.satir[i].EXPENSE_AMOUNT = get_action_detail.MASRAF[i];
			sepet.satir[i].ACTION_CURRENCY = get_action_detail.ACTION_CURRENCY[i];
			sepet.satir[i].ROW_EXP_CENTER_ID = get_action_detail.EXPENSE_CENTER_ID[i];
			sepet.satir[i].ROW_EXP_ITEM_ID = get_action_detail.EXPENSE_ITEM_ID[i];
			
			sepet.satir[i].DETAIL = get_action_detail.ACTION_DETAIL[i];
			sepet.satir[i].PROJECT_ID = get_action_detail.PROJECT_ID[i];
			sepet.satir[i].ACTION_ID = get_action_detail.ACTION_ID[i];
			
			sepet.satir[i].SPECIAL_DEFINITION_ID = get_action_detail.SPECIAL_DEFINITION_ID[i];
			
			sepet.satir[i].ROW_KONTROL = 1;
			sepet.satir[i].ACT_ROW_ID = get_action_detail.ACTION_ID[i];
			
			if(isdefined("attributes.puantaj_id") and len(attributes.puantaj_id)){
				sepet.satir[i].DEKONT_ID = get_action_detail.DEKONT_ID[i];
				sepet.satir[i].PROCESS_CAT = get_action_detail.PROCESS_CAT[i];
				sepet.satir[i].ACTION_DATE = get_action_detail.ACTION_DATE[i];
				sepet.satir[i].UPD_STATUS = get_action_detail.UPD_STATUS[i];
				sepet.satir[i].ACTION_CURRENCY2 = '';
				sepet.satir[i].AVANS_ID = '';
				sepet.satir[i].SYSTEM_AMOUNT = '';
			}
			if(isdefined("attributes.collacted_havale_list") and len(attributes.collacted_havale_list)){
				sepet.satir[i].MULTI_ACTION_ID = get_action_detail.MULTI_ACTION_ID[i];
				sepet.satir[i].ACTION_TYPE_ID = get_action_detail.ACTION_TYPE_ID[i];
				sepet.satir[i].FROM_ACCOUNT_ID = get_action_detail.FROM_ACCOUNT_ID[i];
				sepet.satir[i].ACTION_DATE = get_action_detail.ACTION_DATE[i];
				sepet.satir[i].PROCESS_CAT = get_action_detail.PROCESS_CAT[i];
				sepet.satir[i].BANK_ORDER_TYPE_ID = get_action_detail.BANK_ORDER_TYPE_ID[i];
				sepet.satir[i].BANK_ORDER_ID = get_action_detail.BANK_ORDER_ID[i];
				sepet.satir[i].ACTION_CURRENCY2 = '';
				sepet.satir[i].AVANS_ID = '';
				sepet.satir[i].SYSTEM_AMOUNT = '';
				sepet.satir[i].BANK_ORDER_PROCESS_CAT =  get_action_detail.BANK_ORDER_TYPE_ID[i];
				
			}
			if(isdefined("attributes.payment_ids") and len(attributes.payment_ids)){
				sepet.satir[i].MULTI_ACTION_ID = 250;
				sepet.satir[i].ACTION_TYPE_ID = 25;
				sepet.satir[i].FROM_ACCOUNT_ID = get_action_detail.FROM_ACCOUNT_ID[i];
				sepet.satir[i].ACTION_DATE = get_action_detail.ACTION_DATE[i];
				sepet.satir[i].PROCESS_CAT = '';
				sepet.satir[i].AVANS_ID = get_action_detail.AVANS_ID[i];
				sepet.satir[i].SYSTEM_AMOUNT = '';
				sepet.satir[i].ACTION_CURRENCY2 = get_action_detail.ACTION_CURRENCY2[i];
			}
				if(isdefined("attributes.other_payment_ids") and len(attributes.other_payment_ids)){
					sepet.satir[i].MULTI_ACTION_ID = 250;
					sepet.satir[i].ACTION_TYPE_ID = 25;
					sepet.satir[i].FROM_ACCOUNT_ID = get_action_detail.FROM_ACCOUNT_ID[i];
					sepet.satir[i].ACTION_DATE = get_action_detail.ACTION_DATE[i];
					sepet.satir[i].PROCESS_CAT = '';
					sepet.satir[i].AVANS_ID = get_action_detail.AVANS_ID[i];
					sepet.satir[i].SYSTEM_AMOUNT = '';
					sepet.satir[i].ACTION_CURRENCY2 = '';
				}
		}
		}
		
	</cfscript>
	<cfif paper_type neq 3>
		<cfquery name="get_row_multi_paper" datasource="#dsn3#">
			SELECT * FROM GENERAL_PAPERS WHERE PAPER_TYPE IS NULL
		</cfquery>
	<cfelse>
		<cfquery name="get_row_multi_paper" datasource="#dsn3#">
			SELECT * FROM PAPERS_NO WHERE EMPLOYEE_ID = #session.ep.userid# ORDER BY PAPER_ID DESC
		</cfquery>
	</cfif>
	<cfif get_row_multi_paper.recordcount and len(evaluate('get_row_multi_paper.#auto_paper_type#_NUMBER'))>
			<cfset paper_code = evaluate('get_row_multi_paper.#auto_paper_type#_NO')>
			<cfset paper_number = evaluate('get_row_multi_paper.#auto_paper_type#_NUMBER')+1>
		<cfelse>
			<cfset paper_code = "">
			<cfset paper_number = "">
		</cfif>
	<cfif ArrayLen(sepet.satir)>
	<cfloop index="aaa" from="1" to="#arrayLen(sepet.satir)#">
		<cfset sepet.satir[aaa].MONEY_ID = ''>
		<cfset sepet.satir[aaa].FROM_BRANCH_ID = #from_account_id#>
		<cfset sepet.satir[aaa].SPECIAL_DEFINITION = ''>
		<cfset money_list = ''>
		<cfset SPECIAL_DEFINITION_list = ''>
		<cfoutput query="get_money">
			<cfset money_list = listappend(money_list,'#money#;#rate1#;#rate2#')>
		</cfoutput>
		<cfoutput query="get_special_definition">
			<cfset SPECIAL_DEFINITION_list = listappend(SPECIAL_DEFINITION_list,'#special_definition_id#;#special_definition#')>
		</cfoutput>
		<cfset sepet.satir[aaa].PAPER_NUMBER = '#paper_code#-#paper_number#'>
		<cfset paper_number = paper_number + 1>	
		<cfif len(sepet.satir[aaa].ACTION_CURRENCY2)>
			<cfset sepet.satir[aaa].MONEY_ID_EXTRA = '<option value="">#getLang('','seçiniz',57734)#</option>'>
		<cfelse>
			<cfset sepet.satir[aaa].MONEY_ID_EXTRA = '<option value="" selected="selected">#getLang('','seçiniz',57734)#</option>'>
		</cfif>
		<cfif len(sepet.satir[aaa].SPECIAL_DEFINITION_ID)>
			<cfset sepet.satir[aaa].SPECIAL_DEFINITION = '<option value="">#getLang('','seçiniz',57734)#</option>'>
		<cfelse>
			<cfset sepet.satir[aaa].SPECIAL_DEFINITION = '<option value="" selected="selected">#getLang('','seçiniz',57734)#</option>'>
		</cfif>
		<cfloop list="#money_list#" index="info_list">
			<cfif StructKeyExists(sepet.satir[aaa],'ACTION_CURRENCY') and listfirst(info_list,';') eq sepet.satir[aaa].ACTION_CURRENCY>
				<cfset selected_ = 'selected="selected"'>
			<cfelse>
				<cfset selected_ = ''>
			</cfif>
			<!---<cfset sepet.satir[aaa].MONEY_ID = sepet.satir[aaa].MONEY_ID>--->
			<cfset sepet.satir[aaa].MONEY_ID_EXTRA = sepet.satir[aaa].MONEY_ID_EXTRA & "<option value='#info_list#' #selected_#>#listfirst(info_list,';')#</option>">
		</cfloop>
		<cfset sepet.satir[aaa].MONEY_ID = sepet.satir[aaa].ACTION_CURRENCY>
		<cfloop list="#SPECIAL_DEFINITION_list#" index="special_list">
			<cfif StructKeyExists(sepet.satir[aaa],'SPECIAL_DEFINITION_ID') and sepet.satir[aaa].SPECIAL_DEFINITION_ID eq listfirst(special_list,';')>
				<cfset selected_ = 'selected="selected"'>
			<cfelse>
				<cfset selected_ = ''>
			</cfif>
			<cfset sepet.satir[aaa].SPECIAL_DEFINITION = sepet.satir[aaa].SPECIAL_DEFINITION & "<option value='#listfirst(special_list,';')#' #selected_#>#listlast(special_list,';')#</option>">
		</cfloop>
	</cfloop>
	<cfelse>
		<cfset money_list = ''>
		<cfset SPECIAL_DEFINITION_list = ''>
		<cfoutput query="get_money">
			<cfset money_list = listappend(money_list,'#money#;#rate1#;#rate2#')>
		</cfoutput>
		<cfoutput query="get_special_definition">
			<cfset SPECIAL_DEFINITION_list = listappend(SPECIAL_DEFINITION_list,'#special_definition_id#;#special_definition#')>
		</cfoutput>
	</cfif>
	<cfset date_info = now()>
	<cfif isdefined('get_action_detail') and get_action_detail.recordcount neq 0 and not isdefined("collacted_havale_list") and not isdefined("attributes.payment_ids") and not isdefined("attributes.other_payment_ids")>
		<cfset date_info = get_action_detail.action_date>
	</cfif>
	<cfset basketCollected = serializeJSON(sepet.satir)>
	<cfif left(basketCollected, 2) is "//"><cfset basketCollected = mid(basketCollected, 3, len(basketCollected) - 2)></cfif>
	<cfset basketCollected = URLEncodedFormat(basketCollected, "utf-8")>
	<cfset modulename = "bank">
	<div id="toplu_giden_file" style="margin-left:1000px; margin-top:15px; position:absolute;display:none;z-index:9999;"></div>
	<cfset pageHead = getLang('','Toplu giden havale',29555)><!--- Toplu Giden Havale --->
	<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<div id="basket_main_div">
			<cfform name="add_process" method="post" action="">
				<cf_basket_form id="collacted_gidenh">
					<input name="record_num" id="record_num" type="hidden" value="">
					<input type="hidden" name="paperNumber" id="paperNumber" value="<cfoutput>#paper_number#</cfoutput>" />
					<input type="hidden" id="form_action_address" name="form_action_address" value="<cfoutput>bank.emptypopup_add_collacted_gidenh</cfoutput>" />
					<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
					<cfif isdefined('attributes.from_assign_order')><!---banka talimatlari ekranından geliyor ise--->
						<input type="hidden" name="from_assign_order" id="from_assign_order" value="<cfoutput>#attributes.from_assign_order#</cfoutput>">
					</cfif>
					<cfif isdefined("attributes.puantaj_id") and len(attributes.puantaj_id)>
						<input type="hidden" name="puantaj_id" id="puantaj_id" value="<cfoutput>#attributes.puantaj_id#</cfoutput>">
						<input type="hidden" name="new_dsn2" id="new_dsn2" value="<cfoutput>#attributes.new_dsn2#</cfoutput>">
						<input type="hidden" name="new_dsn3" id="new_dsn3" value="<cfoutput>#attributes.new_dsn3#</cfoutput>">
						<input type="hidden" name="is_virtual" id="is_virtual" value="<cfoutput>#attributes.is_virtual_puantaj#</cfoutput>">
						<input type="hidden" name="new_period_id" id="new_period_id" value="<cfoutput>#attributes.new_period_id#</cfoutput>">
					</cfif>
					<cfif isdefined('attributes.payment_ids')><!---ehesap/ avans talepleri ekranından geliyor ise--->
						<input type="hidden" name="payment_ids" id="payment_ids" value="<cfoutput>#attributes.payment_ids#</cfoutput>">
					</cfif>
					<cfif isdefined('attributes.other_payment_ids')><!---ehesap/ Taksitli avans talepleri ekranından geliyor ise--->
						<input type="hidden" name="other_payment_ids" id="other_payment_ids" value="<cfoutput>#attributes.other_payment_ids#</cfoutput>">
					</cfif>
					<cf_box_elements>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group" id="item-action_date">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'>*</label>
								<div class="col col-8 col-xs-12">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent>
									<div class="input-group">
										<cfinput type="text" name="action_date" value="#dateformat(date_info,dateformat_style)#" onBlur="change_money_info('add_process','action_date');" maxlength="10" validate="#validate_style#" required="Yes" message="#message#">
										<span class="input-group-addon"><cf_wrk_date_image date_field="action_date" call_function="change_money_info"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-process_cat">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.işlem tipi'>*</label>
								<div class="col col-8 col-xs-12">
									<cfif isdefined('get_action_detail') and get_action_detail.recordcount neq 0 >
										<cf_workcube_process_cat process_cat="#get_action_detail.process_cat#">
									<cfelse>
										<cf_workcube_process_cat>
									</cfif>                                	
								</div>
							</div>
							<div class="form-group" id="item-to_account_id">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48706.Banka/Hesap'>*</label>
								<div class="col col-8 col-xs-12">
									<cf_wrkBankAccounts call_function='kur_ekle_f_hesapla' selected_value='#from_account_id#' control_status='1'>
								</div>
							</div>
						</div>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
							<cfif session.ep.isBranchAuthorization eq 0>
								<div class="form-group" id="item-to_branch_id">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57453.Şube'></label>
									<div class="col col-8 col-xs-12">
										<cf_wrkDepartmentBranch selected_value='#from_branch_id#' fieldId='branch_id' is_branch='1' is_default='1' is_deny_control='1'>
									</div>
								</div>
							</cfif>
							<div class="form-group" id="item-acc_department_id">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
								<div class="col col-8 col-xs-12">
									<cf_wrkDepartmentBranch fieldId='acc_department_id' selected_value='#from_department_id#' is_department='1' is_deny_control='0'>
								</div>
							</div>
						</div>
					</cf_box_elements>
					<cf_box_footer>
						<cf_workcube_buttons is_upd='0' add_function='control_form()'>
					</cf_box_footer>
				
				
					<cf_basket id="collacted_gidenh_bask">

						<cfset paper_type = 2>
						<cfif isdefined("attributes.multi_id") and len(attributes.multi_id)>
							<cfset is_copy = 1>
						<cfelseif isdefined("attributes.puantaj_id") and len(attributes.puantaj_id)>
							<cfset is_copy = 1>
						<cfelseif isdefined("attributes.in_out_id_list") and len(attributes.in_out_id_list)>
							<cfset is_copy = 1>
						</cfif>
						<cf_grid_list id="add_period" name="add_period" class="detail_basket_list">
							<thead id="tblBasket">
								<tr>
									<th width="25"></th>
									<th width="35"><a href="javascript://" onClick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='57582.Ekle'>"></i></a></th>
									<th><cf_get_lang dictionary_id='57519.Cari Hesap'> *</th>
									<th><cf_get_lang dictionary_id='57880.Belge No'>*</th>
									<th><cf_get_lang dictionary_id='57673.Tutar'>*</th>
									<th><cf_get_lang dictionary_id='57489.Para Birimi'>*</th>
									<th><cf_get_lang dictionary_id='49016.İşlem Dövizli Tutar'>*</th>
									<th><cf_get_lang dictionary_id='58121.İşlem Dövizi'>*</th>
									<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
									<th><cf_get_lang dictionary_id='57416.Proje'><cfif isdefined("x_required_project") and x_required_project eq 1>*</cfif></th>
									<th><cf_get_lang dictionary_id ='29502.Abone No'></th>
									<cfif session.ep.our_company_info.asset_followup eq 1>
										<th><cf_get_lang dictionary_id ='58833.Fiziki Varlık'></th>
									</cfif>
									<cfif isDefined("x_select_type_info") and x_select_type_info neq 0><th><cf_get_lang dictionary_id='58929.Tahsilat Tipi'><cfif x_select_type_info eq 2>*</cfif></th></cfif>
									<th><cf_get_lang dictionary_id='58930.Masraf'></th>
									<th><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th>
									<th><cf_get_lang dictionary_id='58551.Gider Kalemi'></th>
								</tr>
							</thead>
							<tbody id="basketItemBase" style="display:none; width:99%;">
								<tr ItemRow>
									<td><span id="rowNr">1</span></td>
									<td>
										<input type="hidden" name="row_kontrol" id="row_kontrol" value="">
										<input type="hidden" name="act_row_id" id="act_row_id" value=""><!--- belge kapama işlemlernde sıkıntı oluşturgu için satırlar update edilecek --->
										<cfif (isdefined("attributes.collacted_havale_list") and len(attributes.collacted_havale_list)) or (isdefined("get_action_detail.bank_order_id") and len(get_action_detail.bank_order_id))>
										
											
											<input type="hidden" name="bank_order_process_cat" id="bank_order_process_cat" value=""> <!--- Gelen Banka Talimatı process type --->
											<input type="hidden" name="bank_order_id" id="bank_order_id" value="">	
										</cfif>
										<ul class="ui-icon-list">
											<li><a href="javascript://" id="btnDelete"><i class="fa fa-minus"></i></a></li>
											<li><a href="javascript://" id="copy_basket_row_id"  onclick="copy_row('#currentrow#');" title="<cf_get_lang dictionary_id='58972.Satır Kopyala'>"><i class="fa fa-copy"></i></a></li>
										</ul>
									</td>
									<td style="text-align:left;">
										<input type="hidden" name="related_action_id" id="related_action_id" value="">
										<input type="hidden" name="related_action_type#currentrow#" id="related_action_type" value="">
										<input type="hidden" name="avans_id" id="avans_id" value="">
										<input type="hidden" name="member_code" id="member_code" value="">
										<input type="hidden" name="member_type" id="member_type" value="">
										<input type="hidden" name="action_employee_id" id="action_employee_id" value="">
										<input type="hidden" name="action_company_id" id="action_company_id" value="">
										<input type="hidden" name="action_consumer_id" id="action_consumer_id" value="">
										<div class="form-group">
											<div class="input-group">
												<input type="text" name="comp_name" id="comp_name"  value="">
											</div>
										</div>
									</td>
									<cfif isdefined("is_copy")>
										<td><div class="form-group"><input type="text" id="paper_number" name="paper_number" readonly="readonly" value=""></div></td>
									<cfelse>
										<td><div class="form-group"><input type="text" id="paper_number" name="paper_number" readonly="readonly" value=""></div></td>
									</cfif> 
									<td><div class="form-group"><input type="hidden" name="system_amount" id="system_amount" value="0">
									<input type="text" name="action_value" id="action_value" value="" onkeyup="return(FormatCurrency(this,event));" maxlength="20" class="moneybox"></div>
									</td>
									<td>
										<div class="form-group"><input type="text" name="tl_value" id="tl_value" value=""  readonly="readonly"></div>
									</td>
									<td><div class="form-group"><input type="text" name="action_value_other" id="action_value_other" value="" maxlength="20" onkeyup="return(FormatCurrency(this,event));" class="moneybox" ></div></td>
									<td>
										<div class="form-group"><select name="money_id" id="money_id"></select></div></td>
									<td><div class="form-group"><input type="text" name="action_detail" id="action_detail" value=""></div></td>
									<td nowrap><div class="form-group">
										<div class="input-group"><input name="project_id" id="project_id" type="hidden" value=""><input name="project_head" id="project_head" value=""></div></div></td>
									<td nowrap>
										<div class="form-group">
											<div class="input-group"><input type="hidden" name="subscription_id" id="subscription_id" />
										<input type="text" name="subscription_no" id="subscription_no"/></div></div>
									</td>
									<cfif session.ep.our_company_info.asset_followup eq 1>
										<td nowrap><div class="form-group">
											<div class="input-group"><input name="asset_id" id="asset_id" type="hidden" value="">
										<input id="asset_name" name="asset_name"  value=""></div></div></td>
									</cfif>
									<cfif isDefined("x_select_type_info") and x_select_type_info neq 0><td><div class="form-group"><select name="special_definition_id" id="special_definition_id"></select></div></td></cfif>
									<td >
										<div class="form-group"><input type="text" name="expense_amount" id="expense_amount" value="" onkeyup="return(FormatCurrency(this,event));" maxlength="20" class="moneybox"></div>
									</td>
									<td nowrap>
										<div class="form-group">
											<div class="input-group"><input type="hidden" name="expense_center_id" id="expense_center_id" value="" >
										<input type="text"  name="expense_center_name" id="expense_center_name"  value=""></div></div>
									</td>
									<td nowrap>
										<div class="form-group">
											<div class="input-group"><input type="hidden" name="expense_item_id" id="expense_item_id" value="">
										<input type="text" name="expense_item_name" id="expense_item_name" value=""></div></div>
									</td>
								</tr>
							</tbody>
						</cf_grid_list>
						<cf_basket_footer>
							<div class="ui-pagination basket_row_count" id="basket_money_totals_table">
								<div class="pagi-left basket_row_button">
								<ul>
									<li class="pagesButtonPassive"><a href="javascript://" name="btnPrevLast" id="btnPrevLast" value=""><i class="fa fa-angle-double-left"></i></a></li>
									<li class="pagesButtonPassive"><a href="javascript://" name="btnPrev" id="btnPrev" value=""><i class="fa fa-angle-left"></i></a></li>
									<li><input type="text" id="pageInf" name="pageInf" value=""  style="width:25px;" readonly="readonly"/></li>
									<li class="pagesButtonActive"><a href="javascript://" name="btnNext" id="btnNext" value=""><i class="fa fa-angle-right"></i></a></li>
									<li><a href="javascript://" name="btnNextLast" id="btnNextLast" value=""><i class="fa fa-angle-double-right"></i></a></li>
									
								</ul>
								</div>
								<div class="rowCountText">
								<span class="txtbold"><b><cf_get_lang dictionary_id="44423.Satır Sayısı"></b>: </span><span id="itemCount" class="txtbold">0</span>
								<span class="txtbold"><b><cf_get_lang dictionary_id="57581.Sayfa"></b>: </span><span id="itemPageCount" class="txtbold">0</span>
								</div>
							</div> 
						
							<div class="ui-row">
								<div id="sepetim_total" class="padding-0">
									<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
										<div class="totalBox">
											<div class="totalBoxHead font-grey-mint">
												<span class="headText"> <cf_get_lang dictionary_id='57677.Döviz'> </span>
												<div class="collapse">
													<span class="icon-minus"></span>
												</div>
											</div>
											<div class="totalBoxBody">
												<table cellspacing="0" id="money_rate_table">
													<cfoutput>
														<input id="kur_say" type="hidden" name="kur_say" value="#get_money.recordcount#">
														<cfloop query="get_money">
															<cfif isdefined("xml_money_type") and xml_money_type eq 0>
																<cfset currency_rate_ = RATE2>
															<cfelseif isdefined("xml_money_type") and xml_money_type eq 1>
																<cfset currency_rate_ = RATE3>
															<cfelseif isdefined("xml_money_type") and xml_money_type eq 2>
																<cfset currency_rate_ = RATE2>
															</cfif>	                
															<cfif is_selected eq 1><cfset str_money_bskt_main = money></cfif>
																<tr>
																<td>
																	<cfif session.ep.rate_valid eq 1>
																		<cfset readonly_info = "yes">
																	<cfelse>
																		<cfset readonly_info = "no">
																	</cfif>
																	<input type="hidden" name="hidden_rd_money_#currentrow#" value="#money#" id="hidden_rd_money_#currentrow#">
																	<input type="hidden" name="txt_rate1_#currentrow#" value="#rate1#" id="txt_rate1_#currentrow#">
																	<input type="radio" name="rd_money" id="rd_money" value="#money#,#currentrow#,#rate1#,#rate2#" onClick="toplam_hesapla();" <cfif str_money_bskt_main eq money>checked</cfif>>#money#
																</td>
																<td valign="bottom">#TLFormat(rate1,0)#/<input type="text" class="box" id="txt_rate2_#currentrow#" <cfif readonly_info>readonly</cfif> name="txt_rate2_#currentrow#" <cfif money eq session.ep.money>readonly="yes"</cfif> value="#TLFormat(rate2,rate_round_num_info)#" style="width:65px;" onKeyUp="return(FormatCurrency(this,event,'#rate_round_num_info#'));" onBlur="if(filterNum(this.value,'#rate_round_num_info#') <=0) this.value=commaSplit(1);kur_ekle_f_hesapla('#select_input#',false);"></td>
																</tr>
														</cfloop>
													</cfoutput>                   	
												</table>
											</div>
										</div>
									</div>
									<div class="col col-5 col-md-5 col-sm-5 col-xs-12">
										<div class="totalBox">
											<div class="totalBoxHead font-grey-mint">
												<span class="headText"> <cf_get_lang dictionary_id='57492.Toplam'> </span>
												<div class="collapse">
													<span class="icon-minus"></span>
												</div>
											</div>
											<div class="totalBoxBody"> 
												<table>
											<tr>
												<td>
													<input type="text" name="total_amount" class="box" readonly value="0" id="total_amount">&nbsp;
													<input type="text" name="tl_value1" id="tl_value1" class="box" readonly="readonly" value="<cfoutput>#session.ep.money#</cfoutput>" style="width:40px;">
												</td>
											</tr>
										</table>
										</div>
									</div>
								</div>
							</div>
						</cf_basket_footer>
					</cf_basket>
				</cf_basket_form>
			</cfform>
		</div>
		<!--- cari action id list gönderilirse ona göre geliyor--->
		<cfif isdefined('attributes.cari_action_id_list') and len(attributes.cari_action_id_list)>
			<cfquery name="get_payments" datasource="#dsn#">
				SELECT DISTINCT
					CP.CARI_ACTION_ID,
					CP.FROM_EMPLOYEE_ID,
					(SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = CP.FROM_EMPLOYEE_ID) AS NAMESURNAME,
					CP.ACTION_VALUE,
					CP.ACTION_CURRENCY_ID,
					CP.SUBSCRIPTION_ID,
					(SELECT SUBSCRIPTION_NO FROM #dsn3_alias#.SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID =CP.SUBSCRIPTION_ID ) AS SUBSCRIPTION_NO,
					(SELECT EXPENSE_ID FROM EXPENSE_CENTER EC,EMPLOYEES_IN_OUT_PERIOD EIP WHERE EC.EXPENSE_CODE = EIP.EXPENSE_CODE AND EIP.PERIOD_ID = #session.ep.period_id# AND EI.IN_OUT_ID = EIP.IN_OUT_ID) AS EXPENSE_ID,
					(SELECT EXPENSE FROM EXPENSE_CENTER EC,EMPLOYEES_IN_OUT_PERIOD EIP WHERE EC.EXPENSE_CODE = EIP.EXPENSE_CODE AND EIP.PERIOD_ID = #session.ep.period_id# AND EI.IN_OUT_ID = EIP.IN_OUT_ID) AS EXPENSE_NAME,
					(SELECT EXPENSE_CODE FROM EMPLOYEES_IN_OUT_PERIOD WHERE IN_OUT_ID = EI.IN_OUT_ID AND PERIOD_ID = #session.ep.period_id#) AS EXPENSE_CODE,
					(SELECT EXPENSE_CODE_NAME FROM EMPLOYEES_IN_OUT_PERIOD WHERE IN_OUT_ID = EI.IN_OUT_ID AND PERIOD_ID = #session.ep.period_id#) AS EXPENSE_CODE_NAME,
					(SELECT EXPENSE_ITEM_ID FROM EMPLOYEES_IN_OUT_PERIOD WHERE IN_OUT_ID = EI.IN_OUT_ID AND PERIOD_ID = #session.ep.period_id#) AS EXPENSE_ITEM_ID,
					(SELECT EXPENSE_ITEM_NAME FROM EMPLOYEES_IN_OUT_PERIOD WHERE IN_OUT_ID = EI.IN_OUT_ID AND PERIOD_ID = #session.ep.period_id#) AS EXPENSE_ITEM_NAME,
					(SELECT TOP 1 EA.ACCOUNT_CODE FROM EMPLOYEES_ACCOUNTS EA WHERE EA.EMPLOYEE_ID = CP.TO_EMPLOYEE_ID AND EA.IN_OUT_ID = EI.IN_OUT_ID AND EA.PERIOD_ID=#session.ep.period_id# AND EA.ACC_TYPE_ID=CP.ACC_TYPE_ID) AS ACCOUNT_CODE ,
					E.EMPLOYEE_NO,
					CP.ACC_TYPE_ID,
					SC.ACC_TYPE_NAME
				FROM 
					#dsn2_alias#.CARI_ROWS CP,
					EMPLOYEES E,
					EMPLOYEES_IN_OUT EI,
					SETUP_ACC_TYPE SC
				WHERE 
					CP.CARI_ACTION_ID IN(#attributes.cari_action_id_list#) AND
					EI.FINISH_DATE IS NULL AND
					CP.FROM_EMPLOYEE_ID = EI.EMPLOYEE_ID AND 
					EI.EMPLOYEE_ID = E.EMPLOYEE_ID 
					AND CP.ACC_TYPE_ID = SC.ACC_TYPE_ID
			</cfquery>
			<cfif get_payments.recordcount>
				<cfoutput query="get_payments">
					<script type="text/javascript">
						add_row('#ACTION_VALUE#','','#EMPLOYEE_NO#','employee','','','#FROM_EMPLOYEE_ID#_#ACC_TYPE_ID#','#NAMESURNAME#-#ACC_TYPE_NAME#','#ACCOUNT_CODE#','','#EXPENSE_ID#','#EXPENSE_ITEM_ID#','#EXPENSE_NAME#','#EXPENSE_ITEM_NAME#','','','','','','','','','','','','','','','','','','#get_payments.cari_action_id#');
					</script>
				</cfoutput>
			</cfif>
		</cfif>
	</cf_box>
</div>
	<script>
		 var datapage = 1;
		$(document).ready(function(){
			$("#btnNext,#btnNextLast, #btnPrev, #btnPrevLast").bind("click", showBasketItems);
			$("#pageInf").val(datapage);
			$("paperNumber").val();
			init();
			showBasketItems();
		});
		
		function init()
		{
			window.basket = {
				header: {},
				footer : {
							row_kontrol : <cfoutput>1</cfoutput>,
							
						},
				items: $.evalJSON(decodeURIComponent("<cfoutput>#basketCollected#</cfoutput>")),
				scrollIndex: 0,
				pageSize: <cfoutput>#session.ep.maxrows#</cfoutput>
			}
			window.basket.items.rows_ = window.basket.items.length
				
		}
		function showBasketItems(e)
		{
			if(window.basket.scrollIndex == Math.min(window.basket.items.length, window.basket.scrollIndex + window.basket.pageSize))
				deletedPage = 1;
			else
				deletedPage = 0;
			
			if (e != null && $(e.currentTarget).attr("id") == "btnNext") 
			{
				window.basket.scrollIndex = parseFloat($("#basket_main_div #pageInf").val())*window.basket.pageSize;
				$("#basket_main_div #pageInf").val(parseFloat($("#basket_main_div #pageInf").val())+1);
				datapage++;
				$("#pageInf").val(datapage);
			}
			if ((e != null && $(e.currentTarget).attr("id") == "btnPrev") || deletedPage == 1) 
			{
				window.basket.scrollIndex = Math.max(0, window.basket.scrollIndex - window.basket.pageSize);
				$("#basket_main_div #pageInf").val(parseFloat($("#basket_main_div #pageInf").val())-1);
				datapage--;
				$("#pageInf").val(datapage);
			}
			if (e != null && $(e.currentTarget).attr("id") == "btnPrevLast")
			{ 
				window.basket.scrollIndex = 0;
				$("#basket_main_div #pageInf").val(Math.floor(1));
				datapage = Math.ceil(1);
				$("#pageInf").val(datapage);
			}
				if (e != null && $(e.currentTarget).attr("id") == "btnNextLast")
			{
				if(window.basket.items.length % window.basket.pageSize == 0)
				{
					window.basket.scrollIndex = (Math.floor(window.basket.items.length / window.basket.pageSize)-1) * window.basket.pageSize;
					$("#basket_main_div #pageInf").val(Math.floor(window.basket.items.length / window.basket.pageSize));
				}
				else
				{
					window.basket.scrollIndex = (Math.floor(window.basket.items.length / window.basket.pageSize)) * window.basket.pageSize;
					$("#basket_main_div #pageInf").val(Math.floor(window.basket.items.length / window.basket.pageSize)+1);
				}
			}
			
			if((window.basket.scrollIndex+window.basket.pageSize) >= window.basket.items.length)
				$("#btnNext, #btnLast").attr('disabled', 'disabled');
			else
				$("#btnNext, #btnLast").removeAttr("disabled");
				
			if(window.basket.scrollIndex == 0)
				$("#btnPrev, #btnPrevLast").attr('disabled', 'disabled');
			else
				$("#btnPrev, #btnPrevLast").removeAttr("disabled");
			
			$("#tblBasket tr[ItemRow]").remove();
			document.getElementById('record_num').value = window.basket.items.length ;
			
			for (var i = window.basket.scrollIndex; i < Math.min(window.basket.items.length, window.basket.scrollIndex + window.basket.pageSize); i++)
			{
				$("#tblBasket").append($("#basketItemBase").html());
				var item = $("#tblBasket tr[ItemRow]").last();
				var data = window.basket.items[i];
				$(item).find("#rowNr").text(i + 1);
				$(item).attr("itemIndex", i);
				fillArrayField('row_kontrol',data['ROW_KONTROL'],data['ROW_KONTROL'],i);
				fillArrayField('act_row_id',data['ACTION_ID'],data['ACTION_ID'],i);
				fillArrayField('comp_name',data['COMP_NAME'],data['COMP_NAME'],i);
				fillArrayField('member_code',data['MEMBER_CODE'],data['MEMBER_CODE'],i);
				fillArrayField('avans_id',data['AVANS_ID'],data['AVANS_ID'],i);
				if(data['ACTION_EMPLOYEE_ID'] != null){
					fillArrayField('action_employee_id',data['ACTION_EMPLOYEE_ID'],data['ACTION_EMPLOYEE_ID'],i);
					fillArrayField('member_type','employee','employee',i);
				}
				if(data['ACTION_COMPANY_ID'] != null){
					fillArrayField('action_company_id',data['ACTION_COMPANY_ID'],data['ACTION_COMPANY_ID'],i);
					fillArrayField('member_type','partner','partner',i);
				}
				if(data['ACTION_CONSUMER_ID'] != null){
					fillArrayField('action_consumer_id',data['ACTION_CONSUMER_ID'],data['ACTION_CONSUMER_ID'],i);
					fillArrayField('member_type','consumer','consumer',i);
				}
				$(item).find("#comp_name").after('<span class="input-group-addon icon-ellipsis" onclick="pencere_ac_company('+i+')"></span>');
				
				fillArrayField('paper_number',data['PAPER_NUMBER'],data['PAPER_NUMBER'],i);
				
				fillArrayField('system_amount',data['SYSTEM_ACTION_VALUE'],data['SYSTEM_ACTION_VALUE'],i);
				document.getElementById('tl_value1').value=data['ACTION_CURRENCY2'];
				fillArrayField('tl_value',data['ACTION_CURRENCY2'],data['ACTION_CURRENCY2'],i);
				fillArrayField('action_value_other',parseFloat(data['ACTION_VALUE_OTHER']),commaSplit(data['ACTION_VALUE_OTHER'],2),i);
				fillArrayField('action_detail',data['ACTION_DETAIL'],data['ACTION_DETAIL'],i);
				if(data['ACTION_VALUE']!=null && data['ACTION_VALUE']!='')
					fillArrayField('action_value',parseFloat(data['ACTION_VALUE']),commaSplit(data['ACTION_VALUE'],2),i);
				else
					fillArrayField('action_value',parseFloat(0),commaSplit(0),i);
				fillArrayField('project_id',data['PROJECT_ID'],data['PROJECT_ID'],i);
				fillArrayField('project_head',data['PROJECT_HEAD'],data['PROJECT_HEAD'],i);
				$(item).find("#project_head").after('<span class="input-group-addon icon-ellipsis" onclick="open_basket_project_popup('+i+')"></span>');
				fillArrayField('subscription_id',data['SUBSCRIPTION_ID'],data['SUBSCRIPTION_ID'],i);
				fillArrayField('subscription_no',data['SUBSCRIPTION_NO'],data['SUBSCRIPTION_NO'],i);
				$(item).find("#subscription_no").after('<span class="input-group-addon icon-ellipsis" onclick="open_basket_subscription_popup('+i+')"></span>');
				fillArrayField('asset_id',data['ASSET_ID'],data['ASSET_ID'],i);
				fillArrayField('asset_name',data['ASSET_NAME'],data['ASSET_NAME'],i);
				$(item).find("#asset_name").after('<span class="input-group-addon icon-ellipsis" onclick="pencere_ac_asset('+i+')"></span>');
				if(data['EXPENSE_AMOUNT']!=null && data['EXPENSE_AMOUNT']!='')
					fillArrayField('expense_amount',data['EXPENSE_AMOUNT'],commaSplit(data['EXPENSE_AMOUNT'],2),i);
				else
					fillArrayField('expense_amount',commaSplit(parseFloat(0),2),commaSplit(parseFloat(0),2),i);
				fillArrayField('expense_center_id',data['ROW_EXP_CENTER_ID'],data['ROW_EXP_CENTER_ID'],i);
				fillArrayField('expense_center_name',data['ROW_EXP_CENTER_NAME'],data['ROW_EXP_CENTER_NAME'],i);
				$(item).find("#expense_center_name").after('<span class="input-group-addon icon-ellipsis" onclick="pencere_ac_exp('+i+')"></span>');
				fillArrayField('expense_item_id',data['ROW_EXP_ITEM_ID'],data['ROW_EXP_ITEM_ID'],i);
				fillArrayField('expense_item_name',data['ROW_EXP_ITEM_NAME'],data['ROW_EXP_ITEM_NAME'],i);
				$(item).find("#expense_item_name").after('<span class="input-group-addon icon-ellipsis" onclick="pencere_ac_exp2('+i+')"></span>');
				fillArrayField('expense_item_name',data['ROW_EXP_ITEM_NAME'],data['ROW_EXP_ITEM_NAME'],i);
				
				
				if(data.MONEY_ID != null)
					myMoney = list_first(data.MONEY_ID,';');
				else
					myMoney = data['ACTION_CURRENCY'];

				/*
				if (data.MONEY_ID_EXTRA != null) 
				{
					
					fillArrayField('money_id',myMoney,myMoney,i,2);		
				}
				*/

				if (data.MONEY_ID_EXTRA != null) 
				{
					fillArrayField('money_id',myMoney,myMoney,i,2);		
					money_id_extra = "";
					data.MONEY_ID_EXTRA = "";
					<cfoutput>
						<cfloop list='#money_list#' index='info_list'>
							if('#listfirst(info_list,';')#' == list_first(myMoney,';'))
								data.MONEY_ID_EXTRA += '<option value="#info_list#" selected="selected">#listfirst(info_list,";")#</option>'
							else
								data.MONEY_ID_EXTRA += '<option value="#info_list#">#listfirst(info_list,";")#</option>'
						</cfloop>
					</cfoutput>
					$(item).find("#money_id").html(data.MONEY_ID_EXTRA);
				}
				
				if (data.SPECIAL_DEFINITION != null) 
				{	
					$(item).find("#special_definition_id").html(data.SPECIAL_DEFINITION);
					fillArrayField('special_definition_id',data['SPECIAL_DEFINITION_ID'],data['SPECIAL_DEFINITION_ID'],i,2);		
					//console.log(data);
				}
				
				if(data['ROW_KONTROL'] == 0)
				{
					$("#tblBasket tr[ItemRow]").eq(i).css('display','none');
				}
				
				fillArrayField('bank_order_id',data['BANK_ORDER_ID'],data['BANK_ORDER_ID'],i);
				fillArrayField('bank_order_process_cat',data['BANK_ORDER_PROCESS_CAT'],data['BANK_ORDER_PROCESS_CAT'],i);
				
				$(item).find("#action_value").bind("blur", formatField);
				$(item).find("#expense_amount").bind("blur", formatField1);
				$(item).find("#paper_number").bind("blur", formatField1);
				$(item).find("#action_detail").bind("blur", formatField1);
				$(item).find("#special_definition_id").bind("change", formatField1);
				$(item).find("#action_value_other").bind("blur", formatField);
				$(item).find("#action_value_other").attr('readonly', '');
				$(item).find("#money_id").bind("change", formatField);
				$(item).find("#rd_money").bind("click", formatField);
				$(item).find("#btnDelete").bind("click", deleteBasketItem);
				$(item).find("#copy_basket_row_id").attr("onclick",'copy_basket_row('+i+')');
				$(item).find("#comp_name").bind("blur", formatField1);
				$(item).find("#project_head").bind("blur", formatField1);
				$(item).find("#subscription_no").bind("blur", formatField1);
				$(item).find("#expense_center_name").bind("blur", formatField1);
				$(item).find("#expense_item_name").bind("blur", formatField1);
			}
			
			$("#itemCount").text(window.basket.items.length);
			
			if(window.basket.items.length % window.basket.pageSize == 0)
				$("#itemPageCount").text(Math.floor(window.basket.items.length / window.basket.pageSize));
			else
				$("#itemPageCount").text(Math.floor(window.basket.items.length / window.basket.pageSize)+1);

			if (window.basket.items.length > window.basket.pageSize)
			{
				$("#btnNext, #btnPrev, #btnNextLast, #btnPrevLast, #pageInf").show();
			} else {
				$("#btnNext, #btnPrev, #btnNextLast, #btnPrevLast, #pageInf").hide();
			}
			toplam_hesapla();
			kur_ekle_f_hesapla('account_id',false);
		}
		function goPage()
		{
			if(parseFloat($("#basket_main_div #pageInf").val()) < 1)
				$("#basket_main_div #pageInf").val(1);
			window.basket.scrollIndex = (parseFloat($("#basket_main_div #pageInf").val()) * window.basket.pageSize) - window.basket.pageSize;
			if(window.basket.scrollIndex > window.basket.items.length)
				window.basket.scrollIndex = window.basket.items.length - window.basket.pageSize;
			else if(window.basket.scrollIndex + window.basket.pageSize == window.basket.items.length)
				$("#btnNext, #btnLast").attr('disabled', 'disabled');
			else
				$("#btnNext, #btnLast").removeAttr("disabled");
			showBasketItems();
		}
		
		function add_row(amount,other_money,member_code,member_type,action_company_id,action_consumer_id,action_employee_id,comp_name,acc_code,paper_no,exp_center_id,exp_item_id,exp_center_name,exp_item_name,inc_center_id,inc_item_id,inc_center_name,inc_item_name,project_id,project_name,expense_amount,action_detail,employee_id,employee_name,asset_id,asset_name,special_definition_id,contract_id,contract_head,avans_id,other_amount,related_cari_action_id,related_action_id,related_action_type,subscription_id,subscription_no,is_import)
		{
			var currency_type = eval('add_process.account_id.options[add_process.account_id.selectedIndex]').value;	
			if(document.getElementById('currency_id') != undefined)
				currency_type = document.getElementById('currency_id').value;
			else
				currency_type = list_getat(currency_type,2,';');
				
				if(currency_type.length == 0)
					{
						alert("<cf_get_lang dictionary_id='50020.Banka Hesabı Seçiniz'>");
						return false;
					}	
			
				<cfif isdefined('get_action_detail') and get_action_detail.recordcount neq 0 and len(get_action_detail.action_currency2)>
					ACTION_CURRENCY2 = '<cfoutput>#get_action_detail.action_currency2#</cfoutput>';
				<cfelseif isdefined('get_action_detail') and get_action_detail.recordcount eq 0>
					if(currency_type.length >0)
						ACTION_CURRENCY2 = currency_type;	
					else
						{
							alert("<cf_get_lang dictionary_id='50020.Banka Hesabı Seçiniz'>");
							return false;
						}
				<cfelseif isdefined("attributes.collacted_havale_list") and len(attributes.collacted_havale_list)>
					ACTION_CURRENCY2 = '';
				</cfif>
				if(amount == undefined) amount = 0;
				if(other_amount == undefined) other_amount = 0;
				if(expense_amount == undefined) expense_amount = 0;
				
				if(member_code == undefined) member_code = '';
				if(member_type == undefined) member_type = '';
				if(acc_code == undefined) acc_code = '';
				if(action_company_id == undefined) action_company_id = '';
				if(action_consumer_id == undefined) action_consumer_id = '';
				if(action_employee_id == undefined) action_employee_id = '';
				if(comp_name == undefined) comp_name = '';
				if(paper_no == undefined) paper_no = '';
				if(subscription_id == undefined) subscription_id = '';
				if(subscription_no == undefined) subscription_no = '';
				if(exp_center_id == undefined) exp_center_id = '';
				if(exp_item_id == undefined) exp_item_id = '';
				if(exp_center_name == undefined) exp_center_name = '';
				if(exp_item_name == undefined) exp_item_name = '';
				
				if(inc_center_id == undefined) inc_center_id = '';
				if(inc_item_id == undefined) inc_item_id = '';
				if(inc_center_name == undefined) inc_center_name = '';
				if(inc_item_name == undefined) inc_item_name = '';
				
				if(project_id == undefined) project_id = '';
				if(project_name == undefined) project_name = '';
				if(action_detail == undefined) action_detail = '';
				
				if(employee_id == undefined) employee_id = '<cfoutput>#session.ep.userid#</cfoutput>';
				if(employee_name == undefined) employee_name = '<cfoutput>#get_emp_info(session.ep.userid,0,0)#</cfoutput>';
				if(related_action_id == undefined) related_action_id = '';
				if(related_action_type == undefined) related_action_type = '';
				
				if(asset_id == undefined) asset_id = '';
				if(asset_name == undefined) asset_name = '';
				if(special_definition_id == undefined) special_definition_id = '';
				if(contract_id == undefined) contract_id = '';
				if(contract_head == undefined) contract_head = '';
				if(avans_id == undefined) avans_id = '';
				if(related_cari_action_id == undefined) related_cari_action_id = '';
				if(other_money == undefined) other_money = '<cfoutput>#session.ep.money#</cfoutput>';
				
				money_id_extra = '' ;
				
				<cfoutput>
					<cfloop list='#money_list#' index='info_list'>
						if('#listfirst(info_list,';')#' == other_money)
							money_id_extra += '<option value="#info_list#" selected="selected">#listfirst(info_list,";")#</option>'
						else
							money_id_extra += '<option value="#info_list#">#listfirst(info_list,";")#</option>'
					</cfloop>
				</cfoutput>
				
				SPECIAL_DEFINITION = '<option value="">Seçiniz</option>' ;
				<cfoutput>
					
					<cfloop query='get_special_definition'>
						if('#SPECIAL_DEFINITION_ID#' == special_definition_id)
							SPECIAL_DEFINITION += '<option value="#SPECIAL_DEFINITION_ID#" selected="selected">#SPECIAL_DEFINITION#</option>'
						else
							SPECIAL_DEFINITION += '<option value="#SPECIAL_DEFINITION_ID#">#SPECIAL_DEFINITION#</option>'
					</cfloop>
				</cfoutput>
				paperNumber = $("#paperNumber").val();
				paperNumber = parseInt(paperNumber);
				paper_number = '<cfoutput>#paper_code#-</cfoutput>'+paperNumber;
				$("#paperNumber").val(paperNumber+1);
				
			window.basket.items.push({
				
				ACTION_COMPANY_ID : action_company_id,
				ACTION_CONSUMER_ID : action_consumer_id,
				ACTION_EMPLOYEE_ID : action_employee_id,
				COMP_NAME : comp_name,
				AVANS_ID : avans_id,
				ACTION_DETAIL : action_detail,
				MEMBER_CODE : member_code,
				PROJECT_ID : project_id,
				MEMBER_TYPE: member_type,
				ASSET_ID : asset_id,
				ASSET_NAME : asset_name,
				ROW_KONTROL : 1,
				PAPER_NUMBER :paper_number,
				ACTION_VALUE : amount,
				ACTION_VALUE_OTHER : 0,
				PROJECT_HEAD : project_name, 
				SUBSCRIPTION_ID : subscription_id, 
				SUBSCRIPTION_NO : subscription_no, 
				ROW_EXP_CENTER_ID : exp_center_id,
				ROW_EXP_CENTER_NAME : exp_center_name,
				SYSTEM_ACTION_VALUE : 0,
				SYSTEM_AMOUNT: 0,
				ROW_EXP_ITEM_ID : exp_item_id,
				ROW_EXP_ITEM_NAME : exp_item_name,
				EXPENSE_AMOUNT : expense_amount,
				ACTION_CURRENCY : other_money,
				ACTION_CURRENCY2 : ACTION_CURRENCY2,
				MONEY_ID_EXTRA: money_id_extra,
				SPECIAL_DEFINITION_ID : special_definition_id,
				SPECIAL_DEFINITION :SPECIAL_DEFINITION
			});
		//	console.log(window.basket.items);
			if(is_import == undefined){
				showBasketItems(); 
        		toplam_hesapla();
			}
			/* toplam_hesapla(); */
		}
		Number.prototype.format = function(n, x) {
			var re = '\\d(?=(\\d{' + (x || 3) + '})+' + (n > 0 ? '\\.' : '$') + ')';
			return this.toFixed(Math.max(0, ~~n)).replace(new RegExp(re, 'g'), '$&,');
		};
		function formatField(e)
		{
			rowNumber = Number($(e.target).closest("tr[ItemRow]").attr("itemIndex"));
			fixedRowNumber = rowNumber - window.basket.scrollIndex ;
			newId = $(e.target).attr("id");
			switch ($(e.target).attr("id")){
				case "action_value":
				if($("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_value").val()=='' || $("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_value").val()== 0)
					{
						fillArrayField('action_value',parseFloat(0),commaSplit(parseFloat(0),2),rowNumber,1);
						fillArrayField('action_value_other',parseFloat(0),commaSplit(parseFloat(0),2),rowNumber,1);
						fillArrayField('system_amount',parseFloat(0),commaSplit(parseFloat(0),2),rowNumber,1);
						kur_ekle_f_hesapla('action_value',false,rowNumber);
					}
				else
				{
					fillArrayField('action_value',parseFloat(filterNum($("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_value").val())),commaSplit(parseFloat(filterNum($("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_value").val())),2),rowNumber,1);
					kur_ekle_f_hesapla('action_value',false,rowNumber);
					fillArrayField('action_value_other',parseFloat(filterNum($("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_value_other").val())),$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_value_other").val(),rowNumber,1);
				}
				break;
				/* case "action_value_other":
				if($("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_value_other").val()=='' || $("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_value_other").val()== 0 || $("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_value_other").val()== commaSplit(parseFloat(0),2))
					{
						fillArrayField('action_value',parseFloat(0),commaSplit(parseFloat(0),2),rowNumber,1);
						fillArrayField('action_value_other',parseFloat(0),commaSplit(parseFloat(0),2),rowNumber,1);
						fillArrayField('system_amount',parseFloat(0),commaSplit(parseFloat(0),2),rowNumber,1);
						kur_hesapla2('action_value_other',rowNumber);
					}
				else
				{
					fillArrayField('action_value_other',parseFloat(filterNum($("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_value_other").val())),commaSplit(parseFloat(filterNum($("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_value_other").val())),2),rowNumber,1);
					kur_hesapla2('action_value_other',rowNumber);
					fillArrayField('action_value',parseFloat(filterNum($("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_value").val())),$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_value").val(),rowNumber,1);
				} 
				//fillArrayField('action_value',$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_value").val(),111111..format(2),rowNumber,1);
				break;*/
				case "money_id":
				fillArrayField('money_id',$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#money_id").find(":selected").val(),$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#money_id").find(":selected").val(),rowNumber,1);
				fillArrayField('action_value',parseFloat(filterNum($("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_value").val())),$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_value").val(),rowNumber,1);
				kur_ekle_f_hesapla('action_value',false,rowNumber);
				fillArrayField('action_value_other',parseFloat(filterNum($("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_value_other").val())),$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_value_other").val(),rowNumber,1);
				data.MONEY_ID_EXTRA = data.MONEY_ID_EXTRA.replace(' selected="selected"','');
				data.MONEY_ID_EXTRA = data.MONEY_ID_EXTRA.replace(data.MONEY_ID+"'",data.MONEY_ID + "'" + ' selected="selected"');
				break;
				case "rd_money":
				toplam_hesapla();
					break;
				
			}
		//	console.log(data);
		}
		
		function formatField1(e)
		{
			rowNumber = Number($(e.target).closest("tr[ItemRow]").attr("itemIndex"));
			fixedRowNumber = rowNumber - window.basket.scrollIndex ;
			newId = $(e.target).attr("id");
			switch ($(e.target).attr("id")){
				case "action_detail":
				fillArrayField('action_detail',$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_detail").val(),$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_detail").val(),rowNumber,1);
				break;
				case "expense_amount":
				fillArrayField('expense_amount',parseFloat(filterNum($("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#expense_amount").val())),commaSplit(parseFloat(filterNum($("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#expense_amount").val())),2),rowNumber,1);
				if($("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#expense_amount").val() == '' || $("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#expense_amount").val()  == 0)
					fillArrayField('expense_amount',commaSplit(parseFloat(0),2),commaSplit(parseFloat(0),2),rowNumber);
				else
					fillArrayField('expense_amount',parseFloat(filterNum($("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#expense_amount").val())),commaSplit(parseFloat(filterNum($("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#expense_amount").val())),2),rowNumber,1);
				break;
				case "special_definition_id" :
				fillArrayField('special_definition_id',$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#special_definition_id").find(":selected").val(),$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#special_definition_id").find(":selected").val(),rowNumber,1);
				data.SPECIAL_DEFINITION = data.SPECIAL_DEFINITION.replace(' selected="selected"','');
				data.SPECIAL_DEFINITION = data.SPECIAL_DEFINITION.replace(data.SPECIAL_DEFINITION_ID+"'",data.SPECIAL_DEFINITION_ID + "'" + ' selected="selected"');
				break;
				case "subscription_no":
				fillArrayField('subscription_no',$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#subscription_no").val(),$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#subscription_no").val(),rowNumber,1);
				if(window.basket.items[rowNumber]['SUBSCRIPTION_NO'] == null || window.basket.items[rowNumber]['SUBSCRIPTION_NO']  == '')
				fillArrayField('subscription_id','','',rowNumber,1);
				break;
				case "comp_name":
				fillArrayField('comp_name',$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#comp_name").val(),$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#comp_name").val(),rowNumber,1);
				break;
				case "project_head":
				fillArrayField('project_head',$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#project_head").val(),$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#project_head").val(),rowNumber,1);
				if(window.basket.items[rowNumber]['PROJECT_HEAD'] == null || window.basket.items[rowNumber]['PROJECT_HEAD']  == '')
				fillArrayField('project_id','','',rowNumber,1);
				break;
				case "expense_center_name":
				fillArrayField('expense_center_name',$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#expense_center_name").val(),$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#expense_center_name").val(),rowNumber,1);
				if(window.basket.items[rowNumber]['EXPENSE_CENTER_NAME'] == null || window.basket.items[rowNumber]['EXPENSE_CENTER_NAME'] == '')
				fillArrayField('expense_center_id','','',rowNumber,1);
				break;
				case "expense_item_name":
				fillArrayField('expense_item_name',$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#expense_item_name").val(),$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#expense_item_name").val(),rowNumber,1);
				if(window.basket.items[rowNumber]['EXPENSE_ITEM_NAME']  == null || window.basket.items[rowNumber]['EXPENSE_ITEM_NAME'] == '')
				fillArrayField('expense_item_id','','',rowNumber,1);
				break;
			}
		}
		function fillArrayField(fieldName,ArrayValue,FieldValue,rowNumber,notArray,extraFunction)  // Bu fonksiyon her seferinde array ve ekrandaki inputları tek tek doldurmamak için tek bir yere taşındı.
		{
			
			if(fieldName == 'Tax')
				new_fieldName = 'tax_percent';
			else if(fieldName == 'OTV')
				new_fieldName = 'otv_oran';
			else
				new_fieldName = fieldName;
			
			data = window.basket.items[rowNumber];
			rowNumber -= window.basket.scrollIndex; 
			//Baskete yeni satır eklerken karma koli olma durumuna göre bazı durumlarda Amount alanı readonly olabiliyor yada hesaplayı tetikleyebilecek tarzda olabiliyor. Bu ayrımı yapmak için eklendi.
			if(extraFunction)
				$("#tblBasket tr[ItemRow]").eq(rowNumber).find("#"+fieldName).attr($.trim(ListFirst(extraFunction,'=')),$.trim(ListLast(extra_function,'=')));
			
			if(notArray == 1) // Hem array'i hem ekranı günceller.
			{
				arrayText = new_fieldName.toUpperCase();
				data[arrayText] = ArrayValue;
				$("#tblBasket tr[ItemRow]").eq(rowNumber).find("#"+fieldName).val(FieldValue);
		
			}
			else if(notArray == 2) // Sadece array'i günceller. Hesapla fonksiyonunda kullanılıyor. Hesapla işlemleri array üzerinden yazıldığı için ekrandan girilen değer array'i güncellemesi lazım.
			{
				arrayText = new_fieldName.toUpperCase();
				data[arrayText] = ArrayValue;
			}
			else
			{
				$("#tblBasket tr[ItemRow]").eq(rowNumber).find("#"+fieldName).val(FieldValue);
			}
			if(fieldName== 'action_value')
			{
			//	console.log(data);
			//	console.log(rowNumber);
			}
		}
		function pencere_ac_company(satir)
		{
			var field_company_name_ = 'comp_name';
			var field_company_id_ ='action_company_id';
			var field_employee_id_ ='action_employee_id';
			var field_consumer_id_ ='action_consumer_id';
			var field_member_code_ ='member_code';
			var field_member_type_ ='member_type';
			windowopen('index.cfm?fuseaction=objects.popup_list_pars&is_multi_act=1&is_cari_action=1&select_list=1,2,3,9&field_comp_id=form.'+field_company_id_+'&field_member_name=form.'+field_company_name_+'&field_member_account_code=form.'+ field_member_code_ +'&field_type=from.' + field_member_type_ + '&field_name=form.' + field_company_name_ +'&field_emp_id=form.'+ field_employee_id_ +'&field_consumer=from.'+ field_consumer_id_ +'&satir='+satir,'list');
		}
		function open_basket_project_popup(satir)
		{
			var field_project_name_ = 'project_head';
			var field_project_id_='project_id';
			openBoxDraggable('index.cfm?fuseaction=objects.popup_list_projects&project_id=form.'+field_project_id_+'&project_head=form.'+field_project_name_+'&satir='+satir);
		}
	
		function pencere_ac_asset(satir)
		{
			var field_asset_name_ = 'asset_name';
			var field_asset_id_ ='asset_id';
			windowopen('index.cfm?fuseaction=assetcare.popup_list_assetps&field_id=form.'+field_asset_id_+'&field_name=form.'+field_asset_name_+'&event_id=0&motorized_vehicle=0&satir='+satir,'list');
		}
		function pencere_ac_exp(satir)
		{
			var field_project_name_ = 'expense_center_name';
			var field_project_id_ ='expense_center_id';
			windowopen('index.cfm?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=form.' + field_project_id_ +'&field_name=form.' + field_project_name_+'&satir='+satir,'list');
		}
		function open_basket_subscription_popup(satir){
		var field_name_ = 'subscription_no';
		var field_id_='subscription_id';
		windowopen('index.cfm?fuseaction=objects.popup_list_subscription&&field_id=form.'+field_id_+'&field_no=form.'+field_name_+'&satir='+satir,'list');
		}
		function pencere_ac_exp2(satir)
		{
			var field_project_name_ = 'expense_item_name';
			var field_project_id_ ='expense_item_id';
			windowopen('index.cfm?fuseaction=objects.popup_list_exp_item&field_id=form.' + field_project_id_ +'&field_name=form.' + field_project_name_+'&satir='+satir,'list');
		}
		function deleteBasketItem(e,satir){
			var itemIndex = $(e.target).closest("#tblBasket tr[ItemRow]").attr("itemIndex");
			window.basket.items.splice(itemIndex, 1);
			showBasketItems();
			toplam_hesapla();
		}
		function copy_basket_row(from_row_no,act_row_id)
		{
			var cloned = {};
			for (var prop in window.basket.items[from_row_no]) // Array'in ilgili elemanları döndürülüyor
			{
				if(prop != 'ACT_ROW_ID')
					cloned[prop] = window.basket.items[from_row_no][prop];
				
			}
			money_id_extra = "";
			cloned.MONEY_ID_EXTRA = '';
			<cfoutput>
				<cfloop list='#money_list#' index='info_list'>
					if('#listfirst(info_list,';')#' == list_first(cloned.MONEY_ID,';'))
						money_id_extra += '<option value="#info_list#" selected="selected">#listfirst(info_list,";")#</option>'
					else
						money_id_extra += '<option value="#info_list#">#listfirst(info_list,";")#</option>'
				</cfloop>
			</cfoutput>
			cloned.MONEY_ID_EXTRA =money_id_extra;
			//Üst tarafta kopyalanan satır olduğu gibi kopyalandı. Alt tarafta ise bazı menuel değişecek alanları değiştiriyoruz.
			paperNumber = $("#paperNumber").val();
			paperNumber = parseInt(paperNumber);
			cloned.PAPER_NUMBER= '<cfoutput>#paper_code#-</cfoutput>'+paperNumber;
			paperNumber = paperNumber + 1;
			$("#paperNumber").val(paperNumber);
			window.basket.items.push(cloned);
			showBasketItems();
			
		}
		function control_del_form()
		{
			<cfif isdefined("is_update")>
				if(!control_account_process(<cfoutput>'#get_action_detail.multi_action_id#','#get_action_detail.action_type_id#'</cfoutput>)) return false;
			</cfif>
			return true;
		}
		function kur_ekle_f_hesapla(select_input,doviz_tutar,satir)
		{
			<cfif not isdefined("attributes.is_other_act")>
				if(satir != undefined)
				{
					if(window.basket.items[satir]['ACTION_VALUE'] == '' || window.basket.items[satir]['ACTION_VALUE'] == null )
					{
						window.basket.items[satir]['ACTION_VALUE'] =0;
						fillArrayField('action_value',commaSplit(parseFloat(0),2),commaSplit(parseFloat(0),2),satir);
					}
			
					fixedRowNumber = rowNumber - window.basket.scrollIndex ;
					if(!doviz_tutar) doviz_tutar=false;
					var currency_type = eval($("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#"+select_input).find(":selected").val());
					
					if(document.getElementById('currency_id') != undefined)
					{	
						currency_type = document.getElementById('currency_id').value;
					}
					else
						currency_type = list_getat(currency_type,2,';');
					row_currency = list_getat($("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#money_id").find(":selected").val(),1,';');
					var other_money_value_eleman=window.basket.items[satir]['ACTION_VALUE_OTHER'];
					var temp_act,temp_base_act,rate1_eleman,rate2_eleman;
					if(doviz_tutar && ( other_money_value_eleman.value.length==0 || filterNum(other_money_value_eleman.value)==0) )
					{
						other_money_value_eleman.value = '';
						return false;
					}
					if(doviz_tutar == false && window.basket.items[satir]['ACTION_VALUE'] != "" && currency_type != "")
					{	
					
						for(var i=1;i<=add_process.kur_say.value;i++)
						{	
							rate1_eleman = parseFloat(filterNum(eval('add_process.txt_rate1_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>'));
							rate2_eleman = parseFloat(filterNum(eval('add_process.txt_rate2_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>'));
							
							if( eval('add_process.hidden_rd_money_'+i).value == currency_type)
							{
								
								temp_act=window.basket.items[satir]['ACTION_VALUE']*(rate2_eleman/rate1_eleman); 
								window.basket.items[satir]['SYSTEM_AMOUNT'] = temp_act;
								
							}
						}
						for(var i=1;i<=add_process.kur_say.value;i++)
						{
							rate1_eleman = parseFloat(filterNum(eval('add_process.txt_rate1_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>'));
							rate2_eleman = parseFloat(filterNum(eval('add_process.txt_rate2_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>'));
							if(eval('add_process.hidden_rd_money_'+i).value == row_currency)
							{
								fillArrayField('action_value_other',parseFloat(wrk_round(window.basket.items[satir]['SYSTEM_AMOUNT']*(rate1_eleman/rate2_eleman))),commaSplit(wrk_round(window.basket.items[satir]['SYSTEM_AMOUNT']*(rate1_eleman/rate2_eleman)),2),satir);
								window.basket.items[satir]['SYSTEM_AMOUNT'] = wrk_round(window.basket.items[satir]['SYSTEM_AMOUNT']);
							}
						}
					}
				}
				else
				{	
					
					if(!doviz_tutar) doviz_tutar=false;
					var currency_type = eval('add_process.'+select_input+'.options[add_process.'+select_input+'.selectedIndex]').value;	
					if(document.getElementById('currency_id') != undefined)
						currency_type = document.getElementById('currency_id').value;
					else
						currency_type = list_getat(currency_type,2,';');
					for(var kk=0;kk<window.basket.items.length;kk++)
					{  
						window.basket.items[kk]['ACTION_CURRENCY2']=currency_type;
						fillArrayField('tl_value',currency_type,currency_type,kk);
						document.getElementById('tl_value1').value=currency_type;
						var other_money_value_eleman=window.basket.items[kk]['ACTION_VALUE_OTHER'];
						var temp_act,temp_base_act,rate1_eleman,rate2_eleman;
						row_currency = list_getat(window.basket.items[kk]['MONEY_ID'],1,';');
						if(doviz_tutar && ( other_money_value_eleman.value.length==0 || filterNum(other_money_value_eleman.value)==0) )
						{
							other_money_value_eleman.value = '';
							return false;
						}
						
						if(doviz_tutar == false && window.basket.items[kk]['ACTION_VALUE'] != "" && currency_type != "")
						{	
							
							for(var i=1;i<=add_process.kur_say.value;i++)
							{	
								rate1_eleman = filterNum(eval('add_process.txt_rate1_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
								rate2_eleman = filterNum(eval('add_process.txt_rate2_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
								
								if( eval('add_process.hidden_rd_money_'+i).value == currency_type)
								{ 
									temp_act=parseFloat(window.basket.items[kk]['ACTION_VALUE'])*(rate2_eleman/rate1_eleman); 
									window.basket.items[kk]['SYSTEM_AMOUNT'] = temp_act;
									
								}
							}
							for(var i=1;i<=add_process.kur_say.value;i++)
							{
								rate1_eleman = filterNum(eval('add_process.txt_rate1_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
								rate2_eleman = filterNum(eval('add_process.txt_rate2_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
								
								if(eval('add_process.hidden_rd_money_'+i).value == row_currency)
								{ 
									fillArrayField('action_value_other',parseFloat(wrk_round(window.basket.items[kk]['SYSTEM_AMOUNT']*(rate1_eleman/rate2_eleman))),commaSplit(parseFloat(wrk_round(window.basket.items[kk]['SYSTEM_AMOUNT']*(rate1_eleman/rate2_eleman))),2),(kk),1);
									
									window.basket.items[kk]['SYSTEM_AMOUNT'] = parseFloat(wrk_round(window.basket.items[kk]['SYSTEM_AMOUNT']));
									
								}
							}
									
						}
					}
				}
				
				toplam_hesapla();
			</cfif>
			return true;
		}
		function kur_hesapla2(select_input,satir){ 
			if(window.basket.items[satir]['ACTION_VALUE_OTHER'] == '' ||window.basket.items[satir]['ACTION_VALUE_OTHER'] == null )
			{
				window.basket.items[satir]['ACTION_VALUE_OTHER'] =0;
				fillArrayField('action_value_other',0,0,satir);
			}
			
			fixedRowNumber = rowNumber - window.basket.scrollIndex ; 
			var currency_type = eval($("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#"+select_input).find(":selected").val());
			if(document.getElementById('currency_id') != undefined)
				currency_type = document.getElementById('currency_id').value;
			else
				currency_type = list_getat(currency_type,2,';');
			for(var kk=1;kk<=add_process.record_num.value;kk++)
			{
				row_currency = $("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#money_id").find(":selected").val();
				for(var i=1;i<=add_process.kur_say.value;i++)
				{	
					rate1_eleman = filterNum(eval('add_process.txt_rate1_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
					rate2_1 = list_getat(row_currency,3,';');
					rate2_2 = parseFloat(filterNum(eval('add_process.txt_rate2_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>'));
					
					if(eval('add_process.hidden_rd_money_'+i).value == currency_type)
					{  
	
						var aaa= wrk_round(parseFloat(window.basket.items[satir]['ACTION_VALUE_OTHER']));
						window.basket.items[satir]['ACTION_VALUE'] = wrk_round(parseFloat(aaa));
						fillArrayField('action_value',parseFloat(aaa),commaSplit(wrk_round(aaa),2),satir);
						temp_act=window.basket.items[satir]['ACTION_VALUE']*rate2_2/rate1_eleman;
						window.basket.items[satir]['SYSTEM_AMOUNT'] = temp_act;
					}
				}
			}
			toplam_hesapla();
			return true;
		}
		function toplam_hesapla()
		{
			rate2_value = 0;
			deger_diger_para = '<cfoutput>#session.ep.money#</cfoutput>';
			for (var t=1; t<=document.getElementById('kur_say').value; t++)
			{
				if(document.add_process.rd_money[t-1].checked == true)
				{
					for(k=1;k<=add_process.record_num.value;k++)
					{
						rate2_value = filterNum(eval("document.add_process.txt_rate2_"+t).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
						deger_diger_para = list_getat(document.add_process.rd_money[t-1].value,1,',');
					}
				}
			}
			var total_amount = 0;
			for(j=1;j<=add_process.record_num.value;j++)
			{ 
				if(eval(window.basket.items[j-1]['ROW_KONTROL'])==1)
				{	
					total_amount += parseFloat(window.basket.items[j-1]['ACTION_VALUE']);
					<cfif isdefined("attributes.debt_claim")>
					fillArrayField('action_value_other',0,0,j);
					<cfelseif isdefined('get_action_detail')>
						var selected_ptype = document.add_process.process_cat.options[document.add_process.process_cat.selectedIndex].value;
						if (selected_ptype != '')
							eval('var proc_control = document.add_process.ct_process_type_'+selected_ptype+'.value');
						else
							var proc_control = '';
						if(proc_control != '' && (proc_control == 45 || proc_control == 46))
							fillArrayField('action_value_other',0,0,j);
						else
						{
							<cfif isdefined("attributes.is_other_act")>
								fillArrayField('action_value_other',0,0,j);
							</cfif>
						}
					</cfif>
					var selected_ptype = document.add_process.process_cat.options[document.add_process.process_cat.selectedIndex].value;
					if (selected_ptype != '')
						eval('var proc_control = document.add_process.ct_process_type_'+selected_ptype+'.value');
					else
						var proc_control = '';
					if(proc_control != '' && (proc_control == 45 || proc_control == 46))
						fillArrayField('action_value_other',0,0,j);
					else
					{
						<cfif isdefined("attributes.is_other_act")>
							fillArrayField('action_value_other',0,0,j);
						</cfif>
					}
				}
			}
			if(rate2_value==0)
				other_total_amount=0;
			else
				other_total_amount = total_amount/rate2_value;
			add_process.total_amount.value = commaSplit(total_amount);
			
		}
		
		function updateBasketItemFromPopup(index, data){
			for (var prop in data){
				window.basket.items[index][prop] = data[prop];
				//console.log(data[prop]+'-'+prop);
			}
			
			if (data['ROW_SUBSCRIPTION_NAME'] != null) fillArrayField('subscription_no',data['ROW_SUBSCRIPTION_NAME'],data['ROW_SUBSCRIPTION_NAME'],index,1);
			if (data['ROW_SUBSCRIPTION_ID'] != null) fillArrayField('subscription_id',Number(data['ROW_SUBSCRIPTION_ID']),Number(data['ROW_SUBSCRIPTION_ID']),index,1);
			
			if (data['ROW_PROJECT_NAME'] != null) fillArrayField('project_head',data['ROW_PROJECT_NAME'],data['ROW_PROJECT_NAME'],index,1);
			if (data['ROW_PROJECT_ID'] != null) fillArrayField('project_id',Number(data['ROW_PROJECT_ID']),Number(data['ROW_PROJECT_ID']),index,1);
			
			if (data['NAME_COMPANY'] != null) fillArrayField('comp_name',data['NAME_COMPANY'],data['NAME_COMPANY'],index,1);
			
			if ( data['COMPANY_ID'] != null )
			{
			 fillArrayField('action_company_id',data['COMPANY_ID'],data['COMPANY_ID'],index,1);
			 fillArrayField('action_employee_id','','',index,1);
			 fillArrayField('member_type','partner','partner',index,1);
			 fillArrayField('member_code',data['MEMBER_CODE'],data['MEMBER_CODE'],index,1);
			}
			
			if (data['CONSUMER_ID'] != null)
			{
				 fillArrayField('action_consumer_id',data['CONSUMER_ID'],data['CONSUMER_ID'],index,1);
				 fillArrayField('action_employee_id','','',index,1);
				 fillArrayField('action_company_id','','',index,1);
				fillArrayField('member_code',data['MEMBER_ACCOUNT_CODE'],data['MEMBER_ACCOUNT_CODE'],index,1);
				fillArrayField('member_type','consumer','consumer',index,1);
			}
			
			if (data['CONSUMER_NAME'] != null) fillArrayField('comp_name',data['CONSUMER_NAME'],data['CONSUMER_NAME'],index,1);
			
			
			if (data['ASSETP_ID'] != null) fillArrayField('asset_id',Number(data['ASSETP_ID']),Number(data['ASSETP_ID']),index,1);
			if (data['ASSETP'] != null) fillArrayField('asset_name',data['ASSETP'],data['ASSETP'],index,1);
			
			if (data['ROW_EXP_CENTER_ID'] != null) fillArrayField('expense_center_id',Number(data['ROW_EXP_CENTER_ID']),Number(data['ROW_EXP_CENTER_ID']),index,1);
			if (data['ROW_EXP_CENTER_NAME'] != null) fillArrayField('expense_center_name',data['ROW_EXP_CENTER_NAME'],data['ROW_EXP_CENTER_NAME'],index,1);
			
			if (data['ROW_EXP_ITEM_ID'] != null) fillArrayField('expense_item_id',Number(data['ROW_EXP_ITEM_ID']),Number(data['ROW_EXP_ITEM_ID']),index,1);
			if (data['ROW_EXP_ITEM_NAME'] != null) fillArrayField('expense_item_name',data['ROW_EXP_ITEM_NAME'],data['ROW_EXP_ITEM_NAME'],index,1);
			
			if (data.BASKET_EMPLOYEE != null) fillArrayField('comp_name',data.BASKET_EMPLOYEE,data.BASKET_EMPLOYEE,index,1);
			if (data.BASKET_EMPLOYEE_ID != null){
				fillArrayField('action_employee_id',data.BASKET_EMPLOYEE_ID,data.BASKET_EMPLOYEE_ID,index,1);
				fillArrayField('member_type','employee','employee',index,1);		
				fillArrayField('action_company_id','','',index,1);
				fillArrayField('member_code',data['ROW_ACC_CODE'],data['ROW_ACC_CODE'],index,1);
			}
			
		}
		function control_form()
		{ 
			if(!chk_process_cat('add_process')) return false;
			if(!check_display_files('add_process')) return false;
			if(!chk_period(add_process.action_date,'İşlem')) return false;
			if($("#account_id").val() == "")
			{
				alert("<cf_get_lang dictionary_id='48706.Banka/Hesap'>!");
				return false;
			}
			
			if(!window.basket.items.length)
			{
				alert("<cf_get_lang dictionary_id='48478.Lütfen Satır Ekleyiniz'>");
				return false;
			}
			for(a=0 ; a<window.basket.items.length ; a++)
			{	
				if((window.basket.items[a].COMP_NAME ==null || window.basket.items[a].COMP_NAME == '') && window.basket.items[a].ROW_KONTROL !=0 )
				{
					alert("<cf_get_lang dictionary_id='56329.Cari Seçmelisiniz'> <cf_get_lang dictionary_id='58230.Satır No'>:" +(a+1)+"" );	
					return false;
				}
				
				if((window.basket.items[a].PAPER_NUMBER ==null || window.basket.items[a].PAPER_NUMBER == '') && window.basket.items[a].ROW_KONTROL !=0)
				{
					alert("<cf_get_lang dictionary_id='54868.Belge No Girmelisiniz'> <cf_get_lang dictionary_id='58230.Satır No'>:" +(a+1)+"");	
					return false;
				}
				
				if((window.basket.items[a].MONEY_ID == null || window.basket.items[a].MONEY_ID == '') && window.basket.items[a].ROW_KONTROL !=0)
				{
					alert("<cf_get_lang dictionary_id='41991.Para Birimi Girmelisiniz'> <cf_get_lang dictionary_id='58230.Satır No'>:" +(a+1)+"");	
					return false;
				}
				<cfif x_required_project eq 1>
					if((window.basket.items[a].PROJECT_ID == null || window.basket.items[a].PROJECT_HEAD == '') && window.basket.items[a].ROW_KONTROL !=0)
					{
						alert((a+1)+'. Satırda Proje Girmelisiniz !');	
						return false;
					}
				</cfif>		
				<cfif x_select_type_info eq 2>
					if((window.basket.items[a].SPECIAL_DEFINITION_ID == null || window.basket.items[a].SPECIAL_DEFINITION_ID == '') && window.basket.items[a].ROW_KONTROL !=0)
					{
						alert((a+1)+'. Ödeme Tipi Seçmelisiniz !');	
						return false;
					}
				</cfif>	
				if(window.basket.items[a].EXPENSE_AMOUNT != 0){
					if((window.basket.items[a].ROW_EXP_CENTER_ID == '' && window.basket.items[a].ROW_EXP_CENTER_NAME == '') || (window.basket.items[a].ROW_EXP_ITEM_ID == '' && window.basket.items[a].ROW_EXP_ITEM_NAME == '') && window.basket.items[a].ROW_KONTROL !=0)		
					{
						alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='58460.Masraf Merkezi'> <cf_get_lang dictionary_id='57989.ve'> <cf_get_lang dictionary_id='58551.Gider Kalemi'> <cf_get_lang dictionary_id='58230.Satır No'>: "+ (a+1));
						return false;
					}	
				}					
			}
			if(!paper_no_control(document.getElementById('record_num').value,'<cfoutput>#dsn2#</cfoutput>','BANK_ACTIONS','ACTION_TYPE_ID*25','PAPER_NO','OUTGOING_TRANSFER','ROW_KONTROL','PAPER_NUMBER')) return false;
				
			$("#basket_main_div div[basket_header]").find("input,select,textarea").each(function(index,element){
				if($(element).is("input") && $(element).attr("type") == "checkbox")
				{
					if($(element).is(":checked")) window.basket.header[$(element).attr("name")] = 1;
				}
				else if($(element).is("input") && $(element).attr("type") == "radio")
				{
					if ($(element).is(":checked")) window.basket.header[$(element).attr("name")] = $(element).val();
				}
				else
				{
					window.basket.header[$(element).attr("name")] = $(element).val();
				}
			})
			$("#basket_main_div div[basket_footer]").find("input,select,textarea").each(function(index,element){
				if($(element).is("input") && $(element).attr("type") == "checkbox")
				{
					if($(element).is(":checked")) window.basket.footer[$(element).attr("name")] = 1;
				}
				else if($(element).is("input") && $(element).attr("type") == "radio")
				{
					if ($(element).is(":checked")) window.basket.footer[$(element).attr("name")] = $(element).val();
				}
				else
				{
						val_ = $(element).val();
					window.basket.footer[$(element).attr("name")] = val_;
				}
			})
				
			$("#hidden_fields").find("input").each(function(index,element){
				window.basket.footer[$(element).attr("name")] = $(element).val();
			})
			callURLBank("<cfoutput>#request.self#?fuseaction=objects.emptypopup_basket_converter&isAjax=1&ajax=1&xmlhttp=1&_cf_nodebug=true</cfoutput>",handlerPostBank,{ basket: encodeURIComponent($.toJSON(window.basket)) });
			return false;
				
		}
		function callURLBank(url, callback, data, target, async)
		{   
			// Make method POST if data parameter is specified
			var method = (data != null) ? "POST": "GET";
			$.ajax({
				async: async != null ? async: true,
				url: url,
				type: method,
				data: data,
				success: function(responseData, status, jqXHR)
				{ 
					callback(target, responseData, status, jqXHR); 
				}
				/*,
				error: function(xhr, opt, err)
				{
					// If error string is empty, it means page redirected to another url before ajax process done. Skip the process on this situation
					if (err != null && err.toString().length != 0) callback(target, err, opt, xhr); 
				}
				*/
			});
		}
		function handlerPostBank(target, responseData, status, jqXHR){
			responseData = $.trim(responseData);
			
			$('#working_div_main').css("display", "none");
			
			if(responseData.substr(0,2) == '//') responseData = responseData.substr(2,responseData.length-2);
			//console.log(responseData);
		
			ajax_request_script(responseData);
			
			var SCRIPT_REGEX = /<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi;
			while (SCRIPT_REGEX.test(responseData)) {
				responseData = responseData.replace(SCRIPT_REGEX, "");
			}
			responseData = responseData.replace(/<!-- sil -->/g, '');
			responseData = responseData.replace(/(\r\n|\n|\r)/gm,'');
			if($.trim(responseData).length > 10) /* İşlem Başarılı, işlem hatalı gibi geri dönüş değerleri kontrol ediliyor. */
				alert($.trim(responseData));
		}
		function open_file()
		{
			document.getElementById('toplu_giden_file').style.display='';
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.popup_add_collacted_from_file&type=3<cfif isdefined("attributes.multi_id")>&multi_id=#attributes.multi_id#</cfif></cfoutput>','toplu_giden_file',1);
			return false;
		}
	 </script>
	