<!--- Bu sayfaya eklenen işlem kategorileri solve_process_records.cfm dosyasına da eklenmeli. --->
<!--- invoice --->
<!--- 21,22,23,24,25,26,27,31,32,34,38,39,41,42,43,50,53,55,56,58,59,60,62,63,65,68,90,91,92,93,94,95,101,105,120,121,241,243,250,591,691,1043,1044,1046 --->
<cfquery name="GET_INVOICE_ID" datasource="#DSN2#" >
	SELECT
		ACTION_ID
	FROM
		ACCOUNT_CARD
	WHERE
		ACTION_TYPE IN (48,49,50,51,52,53,54,55,56,561,57,58,59,60,601,61,62,63,64,65,66,67,68,690,691,591,592,531,532,69)
	AND
		CARD_ID IN (#cardlist#)	
</cfquery>
<cfset invoice_list = valuelist(GET_INVOICE_ID.ACTION_ID,",")>
<cfif len(invoice_list) and len(cardlist) >
	<cfquery datasource="#DSN2#" name="UPD_INOICE">
		UPDATE
			INVOICE
		SET
			 UPD_STATUS = 0
		WHERE
			INVOICE_ID IN (#invoice_list#)
	</cfquery>
</cfif>
<!--- masraf --->
<cfquery name="GET_EXPENSE_ID" datasource="#DSN2#" >
	SELECT
		ACTION_ID
	FROM
		ACCOUNT_CARD
	WHERE
		ACTION_TYPE IN (120,121)
	AND
		CARD_ID IN (#cardlist#)	
</cfquery>
<cfset expense_list = valuelist(GET_EXPENSE_ID.ACTION_ID,",")>
<cfif len(expense_list) and len(cardlist) >
	<cfquery datasource="#DSN2#" name="UPD_EXPENSE">
		UPDATE
			EXPENSE_ITEM_PLANS
		SET
			UPD_STATUS = 0
		WHERE
			EXPENSE_ID IN (#expense_list#)
	</cfquery>
</cfif>
<!--- cari --->
<cfquery name="GET_CARI_ID" datasource="#DSN2#" >
	SELECT
		ACTION_ID
	FROM
		ACCOUNT_CARD
	WHERE
		ACTION_TYPE IN (41,42,43)
	AND
		CARD_ID IN (#cardlist#)	
</cfquery>
<cfset cari_list = valuelist(GET_CARI_ID.ACTION_ID,",")>
<cfif len(cari_list) and len(cardlist) >
	<cfquery datasource="#DSN2#" name="UPD_CARI">
		UPDATE
			CARI_ACTIONS
		SET
			UPD_STATUS = 0
		WHERE
			ACTION_ID IN (#cari_list#)
	</cfquery>
</cfif>
<!--- cash --->
<cfquery name="GET_CASH_ID" datasource="#DSN2#" >
	SELECT
		ACTION_ID
	FROM
		ACCOUNT_CARD
	WHERE
		ACTION_TYPE IN (30,31,32,33,34,35,36,37,38,39,1040,1041,1042,1050,1051,1052)
		AND CARD_ID IN (#cardlist#)	
</cfquery>
<cfset cash_list =  ValueList(GET_CASH_ID.ACTION_ID)>
<cfif len(cash_list)>
	<cfquery datasource="#DSN2#" name="UPD_INOICE">
		UPDATE
			CASH_ACTIONS
		SET
			 UPD_STATUS = 0
		WHERE
			ACTION_ID IN (#cash_list#)
	</cfquery>
	<!--- Tahsilata bağlı faturalar da güncellenecek --->
	<cfquery name="GET_INVOICE_ID2" datasource="#DSN2#">
		SELECT INVOICE_ID FROM INVOICE_CASH_POS WHERE CASH_ID IN (#cash_list#)
	</cfquery>
	<cfset invoice_list2 = valuelist(GET_INVOICE_ID2.INVOICE_ID,",")>
	<cfif len(invoice_list2)>
		<cfquery datasource="#DSN2#" name="UPD_INOICE">
			UPDATE
				INVOICE
			SET
				UPD_STATUS = 0
			WHERE
				INVOICE_ID IN (#invoice_list2#)
		</cfquery>
	</cfif>
</cfif>
<!--- Kasa toplu --->
<cfquery name="GET_CASH_MULTI_ID" datasource="#DSN2#" >
	SELECT
		ACTION_ID
	FROM
		ACCOUNT_CARD
	WHERE
		ACTION_TYPE IN (310,320)
		AND	CARD_ID IN (#cardlist#)	
</cfquery>
<cfset cash_multi_list = ValueList(GET_CASH_MULTI_ID.ACTION_ID)>
<cfif len(cash_multi_list)>
	<cfquery datasource="#DSN2#" name="UPD_BANK">
		UPDATE
			CASH_ACTIONS_MULTI
		SET
			UPD_STATUS = 0
		WHERE
			MULTI_ACTION_ID IN (#cash_multi_list#)
	</cfquery>
</cfif>
<!--- Banka toplu (toplu virman,toplu gelen havale,toplu giden havale)--->
<cfquery name="GET_BANK_MULTI_ID" datasource="#DSN2#" >
	SELECT
		ACTION_ID
	FROM
		ACCOUNT_CARD
	WHERE
		ACTION_TYPE IN (230,240,253)
		AND	CARD_ID IN (#cardlist#)	
</cfquery>
<cfset bank_multi_list = ValueList(GET_BANK_MULTI_ID.ACTION_ID)>
<cfif len(bank_multi_list)>
	<cfquery datasource="#DSN2#" name="UPD_BANK">
		UPDATE
			BANK_ACTIONS_MULTI
		SET
			UPD_STATUS = 0
		WHERE
			MULTI_ACTION_ID IN (#bank_multi_list#)
	</cfquery>
</cfif>
<!--- cari toplu --->
<cfquery name="GET_CARI_MULTI_ID" datasource="#DSN2#" >
	SELECT
		ACTION_ID
	FROM
		ACCOUNT_CARD
	WHERE
		ACTION_TYPE IN (410,420,45,46)
		AND	CARD_ID IN (#cardlist#)	
</cfquery>
<cfset ch_multi_list = ValueList(GET_CARI_MULTI_ID.ACTION_ID)>
<cfif len(ch_multi_list)>
	<cfquery datasource="#DSN2#" name="UPD_BANK">
		UPDATE
			CARI_ACTIONS_MULTI
		SET
			UPD_STATUS = 0
		WHERE
			MULTI_ACTION_ID IN (#ch_multi_list#)
	</cfquery>
</cfif>
<!--- bank --->
<cfquery name="GET_BANK_ID" datasource="#DSN2#" >
	SELECT
		ACTION_ID
	FROM
		ACCOUNT_CARD
	WHERE
		ACTION_TYPE IN (20,21,22,23,24,25,26,27,28,29,1053,1054,1055,1043,1044,1045,243,244)
		AND CARD_ID IN (#cardlist#)	
</cfquery>
<cfset bank_list = ValueList(GET_BANK_ID.ACTION_ID) >
<cfif len(bank_list)>
	<cfquery datasource="#DSN2#" name="UPD_INOICE">
		UPDATE
			BANK_ACTIONS
		SET
			 UPD_STATUS = 0
		WHERE
			ACTION_ID IN (#bank_list#)
	</cfquery>
</cfif>
<!--- kredi kartı tahsilatlar ve tahsilat iptal--->
<cfquery name="GET_CREDIT_ID" datasource="#DSN2#" >
	SELECT
		ACTION_ID
	FROM
		ACCOUNT_CARD
	WHERE
		ACTION_TYPE IN (241,245)
		AND CARD_ID IN (#cardlist#)	
</cfquery>
<cfset credit_list = ValueList(GET_CREDIT_ID.ACTION_ID) >
<cfif len(credit_list)>
	<cfquery datasource="#DSN2#" name="UPD_CREDIT">
		UPDATE
			#dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS
		SET
			UPD_STATUS = 0
		WHERE
			CREDITCARD_PAYMENT_ID IN (#credit_list#)
	</cfquery>
	<!--- Tahsilata bağlı faturalar da güncellenecek --->
	<cfquery name="GET_INVOICE_ID2" datasource="#DSN2#">
		SELECT INVOICE_ID FROM INVOICE_CASH_POS WHERE POS_ACTION_ID IN (#credit_list#)
	</cfquery>
	<cfset invoice_list2 = valuelist(GET_INVOICE_ID2.INVOICE_ID,",")>
	<cfif len(invoice_list2)>
		<cfquery datasource="#DSN2#" name="UPD_INOICE">
			UPDATE
				INVOICE
			SET
				UPD_STATUS = 0
			WHERE
				INVOICE_ID IN (#invoice_list2#)
		</cfquery>
	</cfif>
</cfif>
<!--- kredi kartı ödemeler ve ödeme iptal--->
<cfquery name="GET_CREDIT_ID2" datasource="#DSN2#" >
	SELECT
		ACTION_ID
	FROM
		ACCOUNT_CARD
	WHERE
		ACTION_TYPE IN (242,246)
		AND CARD_ID IN (#cardlist#)	
</cfquery>
<cfset credit_list2 = ValueList(GET_CREDIT_ID2.ACTION_ID) >
<cfif len(credit_list2)>
	<cfquery datasource="#DSN2#" name="UPD_CREDIT">
		UPDATE
			#dsn3_alias#.CREDIT_CARD_BANK_EXPENSE
		SET
			UPD_STATUS = 0
		WHERE
			CREDITCARD_EXPENSE_ID IN (#credit_list2#)
	</cfquery>
</cfif>
<!--- payroll --->
<cfquery name="GET_PAYROLL_ID" datasource="#DSN2#" >
	SELECT
		ACTION_ID
	FROM
		ACCOUNT_CARD
	WHERE
		ACTION_TYPE IN (90,91,92,93,94,95,96,133)
	AND
		CARD_ID IN (#cardlist#)	
</cfquery>
<cfset payroll_list=ValueList(GET_PAYROLL_ID.ACTION_ID)>
<cfif len(payroll_list)>
	<cfquery datasource="#DSN2#" name="UPD_INOICE">
		UPDATE PAYROLL SET UPD_STATUS = 0 WHERE ACTION_ID IN (#payroll_list#)
	</cfquery>
</cfif>
<!---  voucher --->
<cfquery name="GET_VPAYROLL_ID" datasource="#DSN2#" >
	SELECT
		ACTION_ID
	FROM
		ACCOUNT_CARD
	WHERE
		ACTION_TYPE IN (97,98,99,100,101,102,103)
	AND
		CARD_ID IN (#cardlist#)	
</cfquery>
<cfset vou_payroll_list = ValueList(GET_VPAYROLL_ID.ACTION_ID)>
<cfif len(vou_payroll_list)>
	<cfquery datasource="#DSN2#" name="UPD_INOICE">
		UPDATE	VOUCHER_PAYROLL	SET	 UPD_STATUS = 0	WHERE ACTION_ID IN (#vou_payroll_list#)
	</cfquery>
</cfif>
<!--- Cheque History --->
<cfquery name="GET_HPAYROLL_ID" datasource="#DSN2#">
	SELECT	ACTION_ID FROM ACCOUNT_CARD WHERE ACTION_TYPE IN (1046) AND	CARD_ID IN (#cardlist#)
</cfquery>
<cfset h_payroll_list = ValueList(GET_HPAYROLL_ID.ACTION_ID)>
<cfif len(h_payroll_list)>
	<cfquery datasource="#DSN2#" name="UPD_INOICE">
		UPDATE CHEQUE_HISTORY SET UPD_STATUS = 0 WHERE CHEQUE_ID IN (#h_payroll_list#)
	</cfquery>
</cfif>	
<!---  voucher his --->
<cfquery name="GET_VHPAYROLL_ID" datasource="#DSN2#">
	SELECT
		ACTION_ID
	FROM
		ACCOUNT_CARD
	WHERE
		ACTION_TYPE IN (1056)
	AND
		CARD_ID IN (#cardlist#)	
</cfquery>
<cfset vouh_payroll_list = ValueList(GET_VHPAYROLL_ID.ACTION_ID)>
<cfif len(vouh_payroll_list)>
	<cfquery datasource="#DSN2#" name="UPD_INOICE">
		UPDATE VOUCHER_HISTORY SET	UPD_STATUS = 0 WHERE VOUCHER_ID IN (#vouh_payroll_list#)
	</cfquery>
</cfif>
<!--- ship --->
<cfquery name="get_ship_id" datasource="#dsn2#">
	SELECT
		ACTION_ID
	FROM
		ACCOUNT_CARD
	WHERE
		ACTION_TYPE IN (81,811)
	AND
		CARD_ID IN (#cardlist#)	
</cfquery>
<cfset ship_id_list = valuelist(get_ship_id.action_id)>
<cfif len(ship_id_list)>
	<cfquery name="upd_ship" datasource="#dsn2#">
		UPDATE SHIP SET SHIP_STATUS = 0 WHERE SHIP_ID IN (#ship_id_list#)
	</cfquery>
</cfif>
<!--- kredi ödemesi ve tahsilat --->
<cfquery name="get_credit_id" datasource="#dsn2#">
	SELECT
		ACTION_ID
	FROM
		ACCOUNT_CARD
	WHERE
		ACTION_TYPE IN (291,292)
	AND
		CARD_ID IN (#cardlist#)	
</cfquery>
<cfset credit_id_list = valuelist(get_credit_id.action_id)>
<cfif len(credit_id_list)>
	<cfquery name="upd_ship" datasource="#dsn2#">
		UPDATE CREDIT_CONTRACT_PAYMENT_INCOME SET UPD_STATUS = 0 WHERE CREDIT_CONTRACT_PAYMENT_ID IN (#credit_id_list#)
	</cfquery>
</cfif>
<!--- stok virman --->
<cfquery name="get_stock_exchange_id" datasource="#dsn2#">
	SELECT
		ACTION_ID
	FROM
		ACCOUNT_CARD
	WHERE
		ACTION_TYPE IN (116)
		AND	CARD_ID IN (#cardlist#)	
</cfquery>
<cfset stock_exchange_id_list = valuelist(get_stock_exchange_id.action_id)>
<cfif len(stock_exchange_id_list)>
	<cfquery name="upd_stock_exchange" datasource="#dsn2#">
		UPDATE STOCK_EXCHANGE SET UPD_STATUS = 0 WHERE STOCK_EXCHANGE_ID IN (#stock_exchange_id_list#)
	</cfquery>
</cfif>
<!--- planlama/tahakkuk fisi --->
<cfquery name="get_budget_plan_id" datasource="#dsn2#">
	SELECT
		ACTION_ID
	FROM
		ACCOUNT_CARD
	WHERE
		ACTION_TYPE IN (160,161)
	AND
		CARD_ID IN (#cardlist#)	
</cfquery>
<cfset budget_plan_id_list = valuelist(get_budget_plan_id.action_id)>
<cfif len(budget_plan_id_list)>
	<cfquery name="upd_budget_plan" datasource="#dsn2#">
		UPDATE #dsn_alias#.BUDGET_PLAN SET UPD_STATUS = 0 WHERE BUDGET_PLAN_ID IN (#budget_plan_id_list#) AND OUR_COMPANY_ID = #session.ep.company_id# AND PERIOD_ID = #session.ep.period_id#
	</cfquery>
</cfif>

