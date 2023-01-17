<!--- TolgaS 20080516 gelen parametrelerde belgenonun kullanılıyormu onun kontolü için sorgu yapacaktır.--->
<cffunction name="get_paper_control" access="public" returnType="query" output="yes">
	<cfargument name="no_value" required="yes" type="string"><!--- kullanılmak istenen belge no --->
	<cfargument name="maxrows" required="no" type="string"><!--- kayıt sayısı gereksiz ancak workdata dan geliyor boş yollanabilir--->
	<cfargument name="paper_type" required="yes" type="string"><!--- belge tipi --->
	<cfargument name="purchase_sales" type="string" default="true"><!--- alış satış --->
	<cfargument name="upd_id" type="string" default="0"><!--- guncelleme ise işlem yapılan belge id o belgeye bakmaması için --->
	<cfargument name="company_id" required="no" type="string" default="0"><!--- guncellemelerde farklı carilerde aynı numara olabilir ise (örnek alış faturası) bu parametreler kullanılacak --->
	<cfargument name="consumer_id" required="no" type="string" default="0">
	<cfargument name="employee_id" required="no" type="string" default="0">
	<cfargument name="dsn_type" required="no" type="string" default="#dsn2#"><!--- ilerde başka dsn lerde gerekebilir parametre şimdiden var --->
	<cfscript>
        if(arguments.dsn_type eq 'undefined' or not len(arguments.dsn_type))arguments.dsn_type = dsn2;
        if(arguments.purchase_sales eq 'undefined' or not len(arguments.purchase_sales))arguments.purchase_sales = true;
        if(arguments.upd_id eq 'undefined' or not len(arguments.upd_id))arguments.upd_id = 0;
        if(arguments.company_id eq 'undefined' or not len(arguments.company_id))arguments.company_id = 0;
        if(arguments.consumer_id eq 'undefined' or not len(arguments.consumer_id))arguments.consumer_id = 0;
        if(arguments.employee_id eq 'undefined' or not len(arguments.employee_id))arguments.employee_id = 0;
    </cfscript>
    <cfquery name="get_paper_control" datasource="#arguments.dsn_type#">
        SELECT 
            <cfif arguments.paper_type eq 'SHIP_FIS'>
                SHIP_RESULT_ID
            <cfelseif arguments.paper_type eq 'ASSET'>
                ASSET_NO
            <cfelseif arguments.paper_type eq 'INVOICE' or arguments.paper_type eq 'E_INVOICE'>
                INVOICE_NUMBER
            <cfelseif arguments.paper_type eq 'SHIP'>
                SHIP_NUMBER
            <cfelseif arguments.paper_type eq 'STOCK_FIS'>
                FIS_NUMBER
            <cfelseif arguments.paper_type eq 'INCOMING_TRANSFER' or arguments.paper_type eq 'OUTGOING_TRANSFER' or arguments.paper_type eq 'BUDGET_PLAN' or arguments.paper_type eq 'VIRMAN' or arguments.paper_type eq 'CREDITCARD_DEBIT_PAYMENT'>
                PAPER_NO
            <cfelseif arguments.paper_type eq 'EXPENSE_COST' or arguments.paper_type eq 'INCOME_COST' or arguments.paper_type eq 'CREDITCARD_REVENUE' or arguments.paper_type eq 'EXPENDITURE_REQUEST'>
                PAPER_NO
            <cfelseif arguments.paper_type eq 'REVENUE_RECEIPT' or arguments.paper_type eq 'CASH_PAYMENT'>
                PAPER_NO
            <cfelseif arguments.paper_type eq 'DEBIT_CLAIM' or arguments.paper_type eq 'CARI_TO_CARI'>
				PAPER_NO
		    <cfelseif arguments.paper_type eq 'FIXTURES'>
            	INVENTORY_NUMBER
			<cfelseif (arguments.paper_type eq 'QUALITY_CONTROL') or (arguments.paper_type eq 'PRODUCTION_QUALITY_CONTROL')>
				Q_CONTROL_NO
			<cfelseif arguments.paper_type eq 'BUYING_SECURITIES' or arguments.paper_type eq 'SECURITIES_SALE'>
				PAPER_NO
			<cfelseif arguments.paper_type eq 'TAHAKKUK_PLAN'>
				PAPER_NO
			<cfelseif arguments.paper_type eq 'WORK'>
				WORK_NO
			<cfelseif arguments.paper_type eq 'TRAVEL_DEMAND'>
				PAPER_NO
			<cfelseif arguments.paper_type eq 'SHIP_INTERNAL'>
				PAPER_NO
			<cfelseif arguments.paper_type eq 'CREDIT'>
				CREDIT_NO
			<cfelseif arguments.paper_type eq 'CREDIT_REVENUE' or arguments.paper_type eq 'CREDIT_PAYMENT'>
				DOCUMENT_NO
            </cfif>
        FROM
             <cfif arguments.paper_type eq 'SHIP_FIS'>
                SHIP_RESULT
             <cfelseif arguments.paper_type eq 'INVOICE' or arguments.paper_type eq 'E_INVOICE'>
                INVOICE
            <cfelseif arguments.paper_type eq 'ASSET'>
                ASSET
            <cfelseif arguments.paper_type eq 'SHIP'>
                SHIP
            <cfelseif arguments.paper_type eq 'STOCK_FIS'>
                STOCK_FIS
            <cfelseif arguments.paper_type eq 'INCOMING_TRANSFER' or arguments.paper_type eq 'OUTGOING_TRANSFER' or arguments.paper_type eq 'VIRMAN' or arguments.paper_type eq 'CREDITCARD_DEBIT_PAYMENT'>
                BANK_ACTIONS
            <cfelseif arguments.paper_type eq 'BUDGET_PLAN'>
                BUDGET_PLAN
            <cfelseif arguments.paper_type eq 'EXPENSE_COST' or arguments.paper_type eq 'INCOME_COST'>
                EXPENSE_ITEM_PLANS
            <cfelseif arguments.paper_type eq 'EXPENDITURE_REQUEST'>
            	EXPENSE_ITEM_PLAN_REQUESTS
            <cfelseif arguments.paper_type eq 'CREDITCARD_REVENUE'>
            	CREDIT_CARD_BANK_PAYMENTS
            <cfelseif arguments.paper_type eq 'REVENUE_RECEIPT' or arguments.paper_type eq 'CASH_PAYMENT'>
            	CASH_ACTIONS
			<cfelseif arguments.paper_type eq 'DEBIT_CLAIM' or arguments.paper_type eq 'CARI_TO_CARI'>
				CARI_ACTIONS
            <cfelseif arguments.paper_type eq 'FIXTURES'>
            	ASSET_P
			<cfelseif (arguments.paper_type eq 'QUALITY_CONTROL') or (arguments.paper_type eq 'PRODUCTION_QUALITY_CONTROL')>
				ORDER_RESULT_QUALITY
			<cfelseif arguments.paper_type eq 'BUYING_SECURITIES' or arguments.paper_type eq 'SECURITIES_SALE'>
				STOCKBONDS_SALEPURCHASE
			<cfelseif arguments.paper_type eq 'TAHAKKUK_PLAN'>
				TAHAKKUK_PLAN
            <cfelseif arguments.paper_type eq 'WORK'>
			    PRO_WORKS
            <cfelseif arguments.paper_type eq 'TRAVEL_DEMAND'>
				EMPLOYEES_TRAVEL_DEMAND
			<cfelseif arguments.paper_type eq 'SHIP_INTERNAL'>
				SHIP_INTERNAL
			<cfelseif arguments.paper_type eq 'CREDIT'>
				CREDIT_CONTRACT
			<cfelseif arguments.paper_type eq 'CREDIT_REVENUE' or arguments.paper_type eq 'CREDIT_PAYMENT'>
				CREDIT_CONTRACT_PAYMENT_INCOME
            </cfif>
        WHERE
		<cfif arguments.paper_type eq 'SHIP_FIS'>
			SHIP_FIS_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.no_value#">
			<cfif arguments.upd_id>
				AND SHIP_RESULT_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.upd_id#">
			</cfif>
			<cfif arguments.company_id or arguments.consumer_id or arguments.employee_id>
				<cfif arguments.company_id>
					AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
				<cfelseif arguments.consumer_id>
					AND CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
				</cfif>
			</cfif>
		<cfelseif arguments.paper_type eq 'ASSET'>
			ASSET_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.no_value#">
			<cfif arguments.upd_id>
				AND ASSET_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.upd_id#">
			</cfif>
		<cfelseif arguments.paper_type eq 'INVOICE' or arguments.paper_type eq 'E_INVOICE'>
			INVOICE_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.no_value#">
			<cfif arguments.upd_id>
				AND INVOICE_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.upd_id#">
			</cfif>
			<cfif arguments.company_id>
				AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
			<cfelseif arguments.consumer_id>
				AND CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
			</cfif>
			AND PURCHASE_SALES = <cfif arguments.purchase_sales>1<cfelse>0</cfif>
		<cfelseif arguments.paper_type eq 'SHIP'>
			SHIP_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.no_value#">
			<cfif arguments.upd_id>
				AND SHIP_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.upd_id#">
			</cfif>
			<cfif arguments.company_id>
				AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
			<cfelseif arguments.consumer_id>
				AND CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
			</cfif>
			AND PURCHASE_SALES = <cfif arguments.purchase_sales>1<cfelse>0</cfif>
		<cfelseif arguments.paper_type eq 'STOCK_FIS'>
			FIS_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.no_value#">
			<cfif arguments.upd_id>
				AND FIS_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.upd_id#">
			</cfif>
		<cfelseif arguments.paper_type eq 'INCOMING_TRANSFER' or arguments.paper_type eq 'OUTGOING_TRANSFER' or arguments.paper_type eq 'VIRMAN' or arguments.paper_type eq 'CREDITCARD_DEBIT_PAYMENT'>
			PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.no_value#">
		<cfelseif arguments.paper_type eq 'BUYING_SECURITIES' or arguments.paper_type eq 'SECURITIES_SALE'>
			PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.no_value#">
		<cfelseif arguments.paper_type eq 'TAHAKKUK_PLAN'>
            PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.no_value#">
		<cfelseif arguments.paper_type eq 'REVENUE_RECEIPT' or arguments.paper_type eq 'CASH_PAYMENT'>
			PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.no_value#">
		<cfelseif arguments.paper_type eq 'DEBIT_CLAIM'>
			PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.no_value#">
		<cfelseif arguments.paper_type eq 'CARI_TO_CARI'>
			PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.no_value#">
		<cfelseif arguments.paper_type eq 'TRAVEL_DEMAND'>
            PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.no_value#">
		<cfelseif arguments.paper_type eq 'BUDGET_PLAN'>
			PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.no_value#">
			<cfif arguments.upd_id>
				AND BUDGET_PLAN_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.upd_id#">
			</cfif>
			<!--- Butce mainde tutulup sirkette gibi calistigindan ayni belge no farkli sirkette kullanildiginda sorun oluyordu kontrol ekledim fbs 20120704 --->
			AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		<cfelseif arguments.paper_type eq 'EXPENSE_COST' or arguments.paper_type eq 'INCOME_COST'>
			<cfif arguments.paper_type eq 'EXPENSE_COST'>
				EXPENSE_COST_TYPE = 120 AND
			<cfelseif arguments.paper_type eq 'INCOME_COST'>
				EXPENSE_COST_TYPE = 121 AND
			</cfif>
			PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.no_value#">
			<cfif arguments.upd_id>
				AND EXPENSE_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.upd_id#">
			</cfif>
			<cfif arguments.company_id>
				AND CH_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
			<cfelseif arguments.consumer_id>
				AND CH_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
			</cfif>
		<cfelseif arguments.paper_type eq 'EXPENDITURE_REQUEST'>
			PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.no_value#">
			<cfif arguments.upd_id>
				AND EXPENSE_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.upd_id#">
			</cfif>
		<cfelseif arguments.paper_type eq 'FIXTURES'>
			INVENTORY_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.no_value#">
			<cfif arguments.upd_id>
				AND ASSETP_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.upd_id#">
			</cfif>
		<cfelseif arguments.paper_type eq 'WORK'>
			WORK_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.no_value#">
			<cfif arguments.upd_id>
				AND WORK_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.upd_id#">
			</cfif>
		<cfelseif (arguments.paper_type eq 'QUALITY_CONTROL') or (arguments.paper_type eq 'PRODUCTION_QUALITY_CONTROL')>
			Q_CONTROL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.no_value#">
			<cfif arguments.upd_id>
				AND OR_Q_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.upd_id#">
			</cfif>
		<cfelseif arguments.paper_type eq 'CREDITCARD_REVENUE'>
			PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.no_value#">
			<cfif arguments.upd_id>
				AND CREDITCARD_PAYMENT_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.upd_id#">
			</cfif>
        <cfelseif arguments.paper_type eq 'SHIP_INTERNAL'>
			PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.no_value#">
			<cfif arguments.upd_id>
				AND DISPATCH_SHIP_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.upd_id#">
			</cfif>
		<cfelseif arguments.paper_type eq 'CREDIT'>
			CREDIT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.no_value#">
			<cfif arguments.upd_id>
				AND CREDIT_CONTRACT_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.upd_id#">
			</cfif>
		<cfelseif arguments.paper_type eq 'CREDIT_REVENUE' or arguments.paper_type eq 'CREDIT_PAYMENT'>
			DOCUMENT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.no_value#">
			<cfif arguments.upd_id>
				AND CREDIT_CONTRACT_PAYMENT_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.upd_id#">
			</cfif>
        </cfif>
    </cfquery>
	<cfif get_paper_control.recordcount and arguments.paper_type eq 'EXPENSE_COST' and listlen(arguments.no_value,'-') gt 1>
		<cfset new_number = listlast(arguments.no_value,'-')>
		<cfquery name="upd_paper" datasource="#DSN3#">
			UPDATE GENERAL_PAPERS SET EXPENSE_COST_NUMBER = EXPENSE_COST_NUMBER + 1  WHERE PAPER_TYPE IS NULL AND EXPENSE_COST_NUMBER < #new_number#
		</cfquery>
	<cfelseif get_paper_control.recordcount and arguments.paper_type eq 'EXPENDITURE_REQUEST' and listlen(arguments.no_value,'-') gt 1>
		<cfset new_number = listlast(arguments.no_value,'-')>
		<cfquery name="upd_paper" datasource="#DSN3#">
			UPDATE GENERAL_PAPERS SET EXPENDITURE_REQUEST_NUMBER = EXPENDITURE_REQUEST_NUMBER + 1  WHERE PAPER_TYPE IS NULL AND EXPENDITURE_REQUEST_NUMBER < #new_number#
		</cfquery>
	<cfelseif get_paper_control.recordcount and arguments.paper_type eq 'INCOMING_TRANSFER' and listlen(arguments.no_value,'-') gt 1>
		<cfset new_number = listlast(arguments.no_value,'-')>
		<cfquery name="upd_paper" datasource="#DSN3#">
			UPDATE GENERAL_PAPERS SET INCOMING_TRANSFER_NUMBER = INCOMING_TRANSFER_NUMBER + 1  WHERE PAPER_TYPE IS NULL AND INCOMING_TRANSFER_NUMBER < #new_number#
		</cfquery>
    <cfelseif get_paper_control.recordcount and arguments.paper_type eq 'STOCK_FIS' and listlen(arguments.no_value,'-') gt 1>
		<cfset new_number = listlast(arguments.no_value,'-')>
		<cfquery name="upd_paper" datasource="#DSN3#">
			UPDATE GENERAL_PAPERS SET STOCK_FIS_NUMBER = STOCK_FIS_NUMBER + 1  WHERE PAPER_TYPE IS NULL AND STOCK_FIS_NUMBER < #new_number#
		</cfquery>
	<cfelseif get_paper_control.recordcount and arguments.paper_type eq 'OUTGOING_TRANSFER' and listlen(arguments.no_value,'-') gt 1>
		<cfset new_number = listlast(arguments.no_value,'-')>
		<cfquery name="upd_paper" datasource="#DSN3#">
			UPDATE GENERAL_PAPERS SET OUTGOING_TRANSFER_NUMBER = OUTGOING_TRANSFER_NUMBER + 1  WHERE PAPER_TYPE IS NULL AND OUTGOING_TRANSFER_NUMBER < #new_number#
		</cfquery>
	<cfelseif get_paper_control.recordcount and arguments.paper_type eq 'CREDITCARD_DEBIT_PAYMENT' and listlen(arguments.no_value,'-') gt 1>
		<cfset new_number = listlast(arguments.no_value,'-')>
		<cfquery name="upd_paper" datasource="#DSN3#">
			UPDATE GENERAL_PAPERS SET CREDITCARD_DEBIT_PAYMENT_NUMBER = CREDITCARD_DEBIT_PAYMENT_NUMBER + 1  WHERE PAPER_TYPE IS NULL AND CREDITCARD_DEBIT_PAYMENT_NUMBER < #new_number#
		</cfquery>
	<cfelseif get_paper_control.recordcount and arguments.paper_type eq 'VIRMAN' and listlen(arguments.no_value,'-') gt 1>
		<cfset new_number = listlast(arguments.no_value,'-')>
		<cfquery name="upd_paper" datasource="#DSN3#">
			UPDATE GENERAL_PAPERS SET VIRMAN_NUMBER = VIRMAN_NUMBER + 1  WHERE PAPER_TYPE IS NULL AND VIRMAN_NUMBER < #new_number#
		</cfquery>
	<cfelseif get_paper_control.recordcount and arguments.paper_type eq 'BUYING_SECURITIES' and listlen(arguments.no_value,'-') gt 1>
		<cfset new_number = listlast(arguments.no_value,'-')>
		<cfquery name="upd_paper" datasource="#DSN3#">
			UPDATE GENERAL_PAPERS SET BUYING_SECURITIES_NUMBER = BUYING_SECURITIES_NUMBER + 1  WHERE PAPER_TYPE IS NULL AND BUYING_SECURITIES_NUMBER < #new_number#
		</cfquery>
	<cfelseif get_paper_control.recordcount and arguments.paper_type eq 'SECURITIES_SALE' and listlen(arguments.no_value,'-') gt 1>
		<cfset new_number = listlast(arguments.no_value,'-')>
		<cfquery name="upd_paper" datasource="#DSN3#">
			UPDATE GENERAL_PAPERS SET SECURITIES_SALE_NUMBER = SECURITIES_SALE_NUMBER + 1  WHERE PAPER_TYPE IS NULL AND SECURITIES_SALE_NUMBER < #new_number#
		</cfquery>	
	<cfelseif get_paper_control.recordcount and arguments.paper_type eq 'TAHAKKUK_PLAN' and listlen(arguments.no_value,'-') gt 1>
        <cfset new_number = listlast(arguments.no_value,'-')>
        <cfquery name="upd_paper" datasource="#DSN3#">
            UPDATE GENERAL_PAPERS SET TAHAKKUK_PLAN_NUMBER = TAHAKKUK_PLAN_NUMBER + 1  WHERE PAPER_TYPE IS NULL AND TAHAKKUK_PLAN_NUMBER < #new_number#
        </cfquery>
	<cfelseif get_paper_control.recordcount and arguments.paper_type eq 'REVENUE_RECEIPT' and listlen(arguments.no_value,'-') gt 1>
		<cfset new_number = listlast(arguments.no_value,'-')>
		<cfquery name="kontrol_print" datasource="#dsn3#">
			SELECT * FROM PAPERS_NO WHERE EMPLOYEE_ID = #session.ep.userid# ORDER BY PAPER_ID DESC 
		</cfquery>
		<cfif kontrol_print.recordcount>
			<cfquery name="upd_paper" datasource="#DSN3#">
				UPDATE PAPERS_NO SET REVENUE_RECEIPT_NUMBER = REVENUE_RECEIPT_NUMBER + 1  WHERE EMPLOYEE_ID = #session.ep.userid# AND REVENUE_RECEIPT_NUMBER < #new_number#
			</cfquery>
		<cfelse>
			<cfquery name="kontrol_print" datasource="#dsn3#">
				SELECT
					*
				FROM
					PAPERS_NO PN,
					#dsn_alias#.SETUP_PRINTER_USERS SPU
				WHERE
					PN.PRINTER_ID = SPU.PRINTER_ID AND
					SPU.PRINTER_EMP_ID = #session.ep.userid#
				ORDER BY
					PAPER_ID DESC 
			</cfquery>
			<cfif kontrol_print.recordcount>
				<cfquery name="upd_paper" datasource="#DSN3#">
					UPDATE PAPERS_NO SET REVENUE_RECEIPT_NUMBER = REVENUE_RECEIPT_NUMBER + 1 WHERE PAPER_ID=#kontrol_print.PAPER_ID# AND REVENUE_RECEIPT_NUMBER < #new_number#
				</cfquery>
			</cfif>	
		</cfif>	
	<cfelseif get_paper_control.recordcount and arguments.paper_type eq 'INVOICE' and listlen(arguments.no_value,'-') gt 1>
		<cfset new_number = listlast(arguments.no_value,'-')>
		<cfquery name="kontrol_print" datasource="#dsn3#">
			SELECT * FROM PAPERS_NO WHERE EMPLOYEE_ID = #session.ep.userid# ORDER BY PAPER_ID DESC 
		</cfquery>
		<cfif kontrol_print.recordcount>
			<cfquery name="upd_paper" datasource="#DSN3#">
				UPDATE PAPERS_NO SET INVOICE_NUMBER = INVOICE_NUMBER + 1  WHERE EMPLOYEE_ID = #session.ep.userid# AND INVOICE_NUMBER < #new_number#
			</cfquery>
		<cfelse>
			<cfquery name="kontrol_print" datasource="#dsn3#">
				SELECT
					*
				FROM
					PAPERS_NO PN,
					#dsn_alias#.SETUP_PRINTER_USERS SPU
				WHERE
					PN.PRINTER_ID = SPU.PRINTER_ID AND
					SPU.PRINTER_EMP_ID = #session.ep.userid#
				ORDER BY
					PAPER_ID DESC 
			</cfquery>
			<cfif kontrol_print.recordcount>
				<cfquery name="upd_paper" datasource="#DSN3#">
					UPDATE PAPERS_NO SET INVOICE_NUMBER = INVOICE_NUMBER + 1 WHERE PAPER_ID=#kontrol_print.PAPER_ID# AND INVOICE_NUMBER < #new_number#
				</cfquery>
			</cfif>	
		</cfif>	
	<cfelseif get_paper_control.recordcount and arguments.paper_type eq 'CASH_PAYMENT' and listlen(arguments.no_value,'-') gt 1>
		<cfset new_number = listlast(arguments.no_value,'-')>
		<cfquery name="upd_paper" datasource="#DSN3#">
			UPDATE GENERAL_PAPERS SET CASH_PAYMENT_NUMBER = CASH_PAYMENT_NUMBER + 1  WHERE PAPER_TYPE IS NULL AND CASH_PAYMENT_NUMBER < #new_number#
		</cfquery>
	<cfelseif get_paper_control.recordcount and arguments.paper_type eq 'CREDITCARD_REVENUE' and listlen(arguments.no_value,'-') gt 1>
		<cfset new_number = listlast(arguments.no_value,'-')>
		<cfquery name="upd_paper" datasource="#DSN3#">
			UPDATE GENERAL_PAPERS SET CREDITCARD_REVENUE_NUMBER = CREDITCARD_REVENUE_NUMBER + 1  WHERE PAPER_TYPE IS NULL AND CREDITCARD_REVENUE_NUMBER < #new_number#
		</cfquery>
	<cfelseif get_paper_control.recordcount and arguments.paper_type eq 'DEBIT_CLAIM' and listlen(arguments.no_value,'-') gt 1>
		<cfset new_number = listlast(arguments.no_value,'-')>
		<cfquery name="upd_paper" datasource="#DSN3#">
			UPDATE GENERAL_PAPERS SET DEBIT_CLAIM_NUMBER = DEBIT_CLAIM_NUMBER + 1  WHERE PAPER_TYPE IS NULL AND DEBIT_CLAIM_NUMBER < #new_number#
		</cfquery>
	<cfelseif get_paper_control.recordcount and arguments.paper_type eq 'CARI_TO_CARI' and listlen(arguments.no_value,'-') gt 1>
		<cfset new_number = listlast(arguments.no_value,'-')>
		<cfquery name="upd_paper" datasource="#DSN3#">
			UPDATE GENERAL_PAPERS SET CARI_TO_CARI_NUMBER = CARI_TO_CARI_NUMBER + 1  WHERE PAPER_TYPE IS NULL AND CARI_TO_CARI_NUMBER < #new_number#
		</cfquery>
	<cfelseif get_paper_control.recordcount and arguments.paper_type eq 'CREDIT' and listlen(arguments.no_value,'-') gt 1>
			<cfset new_number = listlast(arguments.no_value,'-')>
			<cfquery name="upd_paper" datasource="#DSN3#">
				UPDATE GENERAL_PAPERS SET CREDIT_NUMBER = CREDIT_NUMBER + 1  WHERE PAPER_TYPE IS NULL AND CREDIT_NUMBER < #new_number#
			</cfquery>
	<cfelseif get_paper_control.recordcount and arguments.paper_type eq 'CREDIT_REVENUE' and listlen(arguments.no_value,'-') gt 1>
		<cfset new_number = listlast(arguments.no_value,'-')>
		<cfquery name="upd_paper" datasource="#DSN3#">
			UPDATE GENERAL_PAPERS SET CREDIT_REVENUE_NUMBER = CREDIT_REVENUE_NUMBER + 1  WHERE PAPER_TYPE IS NULL AND CREDIT_REVENUE_NUMBER < #new_number#
		</cfquery>
	<cfelseif get_paper_control.recordcount and arguments.paper_type eq 'CREDIT_PAYMENT' and listlen(arguments.no_value,'-') gt 1>
		<cfset new_number = listlast(arguments.no_value,'-')>
		<cfquery name="upd_paper" datasource="#DSN3#">
			UPDATE GENERAL_PAPERS SET CREDIT_PAYMENT_NUMBER = CREDIT_PAYMENT_NUMBER + 1  WHERE PAPER_TYPE IS NULL AND CREDIT_PAYMENT_NUMBER < #new_number#
		</cfquery>
	</cfif>
	<cfreturn get_paper_control>
	<cfabort>
</cffunction>

