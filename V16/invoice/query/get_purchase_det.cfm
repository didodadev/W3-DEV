<cfquery name="GET_SALE_DET" datasource="#dsn2#">
	SELECT 
		INVOICE.*,
        CASE WHEN BA.ACTION_ID IS NOT NULL THEN BA.ACTION_ID WHEN CA.ACTION_ID IS NOT NULL THEN CA.ACTION_ID WHEN CCBE.CREDITCARD_EXPENSE_ID IS NOT NULL THEN CCBE.CREDITCARD_EXPENSE_ID ELSE 0 END AS RELATED_ACTION_ID,
        CASE WHEN BA.ACTION_ID IS NOT NULL THEN 'BANK_ACTIONS' WHEN CA.ACTION_ID IS NOT NULL THEN 'CASH_ACTIONS' WHEN CCBE.CREDITCARD_EXPENSE_ID IS NOT NULL THEN 'CREDIT_CARD_BANK_EXPENSE' ELSE '' END AS RELATED_ACTION_TABLE
	FROM
		INVOICE
		LEFT JOIN CASH_ACTIONS CA ON CA.PAPER_NO = INVOICE.INVOICE_NUMBER AND CA.ACTION_TYPE_ID = 34
		LEFT JOIN BANK_ACTIONS BA ON BA.PAPER_NO = INVOICE.INVOICE_NUMBER AND INVOICE.INVOICE_ID=BA.BILL_ID
		LEFT JOIN #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE CCBE ON CCBE.PAPER_NO = INVOICE.INVOICE_NUMBER AND INVOICE.INVOICE_ID=CCBE.INVOICE_ID
	WHERE
		INVOICE_CAT <> 67 AND
		INVOICE_CAT <> 69 AND
		INVOICE.INVOICE_ID = #url.iid# AND
        PURCHASE_SALES = 0
	<cfif session.ep.isBranchAuthorization>
		AND (
			INVOICE.RECORD_EMP IN
			(
				SELECT 
					EMPLOYEE_ID
				FROM 
					#dsn_alias#.EMPLOYEE_POSITIONS EP,
					#dsn_alias#.DEPARTMENT D
				WHERE
					EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND
					D.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">
			)
		OR
			DEPARTMENT_ID IN
			(
				SELECT 
					DEPARTMENT_ID
				FROM 
					#dsn_alias#.DEPARTMENT D
				WHERE
					D.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">
			)
		)
	</cfif>		
</cfquery>
<cfquery name="get_efatura_det" datasource="#dsn2#">
	SELECT 
		RECEIVING_DETAIL_ID
	FROM
		EINVOICE_RECEIVING_DETAIL
	WHERE
		INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.iid#">
	ORDER BY
		RECEIVING_DETAIL_ID DESC
</cfquery>
<cfif len(get_sale_det.company_id)>
	<cfquery name="GET_SALE_DET_COMP" datasource="#dsn#">
		SELECT 
			COMPANY_ID,
			TAXOFFICE,
			TAXNO,
			COMPANY_ADDRESS,
			FULLNAME,
            USE_EFATURA,
            EFATURA_DATE
		FROM
			COMPANY
		WHERE 
			COMPANY_ID = #GET_SALE_DET.COMPANY_ID#
	</cfquery>
	<cfif len(GET_SALE_DET.PARTNER_ID)>
		<cfquery name="GET_SALE_DET_CONS" datasource="#dsn#">
			SELECT
				PARTNER_ID,COMPANY_PARTNER_NAME,
				COMPANY_PARTNER_SURNAME
			FROM
				COMPANY_PARTNER
			WHERE
				PARTNER_ID= #GET_SALE_DET.PARTNER_ID#
		</cfquery>
	</cfif>
<cfelseif len(GET_SALE_DET.CONSUMER_ID)>
	<cfquery name="GET_CONS_NAME" datasource="#dsn#">
		SELECT
			CONSUMER_NAME,
			CONSUMER_SURNAME,
			COMPANY,
			CONSUMER_ID,
            USE_EFATURA,
            EFATURA_DATE
		FROM
			CONSUMER
		WHERE
			CONSUMER_ID=#GET_SALE_DET.CONSUMER_ID#
	</cfquery>		
</cfif>
<cfif len(GET_SALE_DET.DELIVER_EMP) and GET_SALE_DET.PURCHASE_SALES eq 0 and isnumeric(GET_SALE_DET.DELIVER_EMP)>
	<cfquery name="GET_SALE_DET_DELIVER_EMP" datasource="#dsn#">
		SELECT
			POSITION_ID,
			EMPLOYEE_NAME,
			EMPLOYEE_SURNAME
		FROM
			EMPLOYEE_POSITIONS
		WHERE
			EMPLOYEE_ID= #GET_SALE_DET.DELIVER_EMP# 
	</cfquery>
</cfif>

<cfquery name="get_period_dsns" datasource="#dsn#"> <!--- faturaya irsaliye cekilebilecek aktif dönem ve bir önceki dönem bilgilerini getiriyor --->
	SELECT PERIOD_YEAR,OUR_COMPANY_ID,PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID =#session.ep.company_id# AND PERIOD_YEAR IN (#session.ep.period_year#,#session.ep.period_year-1#)
</cfquery>
<!--- INVOICE_SHIPS tablosundaki SHIP_NUMBER alanı irsaliye no bilgilerini tutmadıgında ilgili döneme baglanıp irsaliye nolar alınıyor --->
<cfquery name="GET_WITH_SHIP_ALL" datasource="#dsn#">
	SELECT
		SHIP_NUMBER,
		SHIP_DATE,
		SHIP_ID,
		INVOICE_ID,
		IS_WITH_SHIP,
		SHIP_PERIOD_ID
	FROM
	(
	<cfloop query="get_period_dsns">
		SELECT
			S.SHIP_NUMBER,
			S.SHIP_DATE,
			INV_S.SHIP_ID,
			INV_S.INVOICE_ID,
			INV_S.IS_WITH_SHIP,
			INV_S.SHIP_PERIOD_ID
		FROM
			#dsn2_alias#.INVOICE_SHIPS INV_S,
			#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP S
		WHERE
			INV_S.SHIP_ID = S.SHIP_ID AND
			INV_S.SHIP_PERIOD_ID = #get_period_dsns.period_id# AND
			INV_S.INVOICE_ID = #url.iid#
		<cfif currentrow neq get_period_dsns.recordcount>
		UNION ALL
		</cfif>					
	</cfloop>
	) AS A1
</cfquery>

<!--- Iliskili Ithal Mal Girisi Varsa Faturada Butonlar Gorunmemeli, Cunku Iliski Kopuyor FBS 20150221 --->
<cfquery name="get_customs_invoice" datasource="#dsn2#">
	SELECT SHIP.SHIP_NUMBER FROM INVOICE_SHIPS, SHIP WHERE SHIP.SHIP_ID = INVOICE_SHIPS.SHIP_ID AND IMPORT_INVOICE_ID = #url.iid# AND IMPORT_PERIOD_ID = #session.ep.period_id# AND INVOICE_SHIPS.SHIP_ID IS NOT NULL
</cfquery>
<cfif not get_customs_invoice.recordcount>
	<cfquery name="get_next_periods" datasource="#dsn#">
		SELECT PERIOD_YEAR FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #session.ep.company_id# AND PERIOD_YEAR > #session.ep.period_year#
	</cfquery>
	<cfif get_next_periods.recordcount>
		<cfquery name="get_customs_invoice" datasource="#dsn2#">
			<cfloop query="get_next_periods">
				<cfset new_dsn2_alias = "#dsn#_#get_next_periods.period_year#_#session.ep.company_id#">
				SELECT SHIP.SHIP_NUMBER FROM #new_dsn2_alias#.INVOICE_SHIPS, #new_dsn2_alias#.SHIP WHERE SHIP.SHIP_ID = INVOICE_SHIPS.SHIP_ID AND IMPORT_INVOICE_ID = #url.iid# AND IMPORT_PERIOD_ID = #session.ep.period_id# AND INVOICE_SHIPS.SHIP_ID IS NOT NULL
			<cfif get_next_periods.currentrow neq get_next_periods.recordcount>UNION ALL</cfif>
			</cfloop>
		</cfquery>
	</cfif>
</cfif>
<cfif get_customs_invoice.recordcount><cfset is_related_customs_ships = ValueList(get_customs_invoice.ship_number,",")><cfelse><cfset is_related_customs_ships = 0></cfif>

<!--- faturaya cekilen irsaliyeler ve bu irsaliyelerin period_id lerini tutar --->
<cfset ship_id_with_period = "">
<cfset ship_date_without_period = "">
<cfloop query="GET_WITH_SHIP_ALL">
	<cfset ship_id_with_period = listappend(ship_id_with_period,'#GET_WITH_SHIP_ALL.SHIP_ID#;#GET_WITH_SHIP_ALL.SHIP_PERIOD_ID#')>
	<cfif GET_WITH_SHIP_ALL.IS_WITH_SHIP eq 0>
		<cfset ship_date_without_period = listappend(ship_date_without_period,'#dateformat(GET_WITH_SHIP_ALL.SHIP_DATE,"dd/mm/yyyy")#')>
	</cfif>
</cfloop>
<cfquery name="GET_WITH_SHIP" dbtype="query">
	SELECT * FROM GET_WITH_SHIP_ALL WHERE IS_WITH_SHIP = 1 
</cfquery>
<cfquery name="GET_ORDER" datasource="#DSN3#">
	SELECT
		ORDERS_INVOICE.ORDER_ID,
		ORDERS_INVOICE.ORDER_NUMBER,
		ORDER_DATE
	FROM 
		ORDERS_INVOICE,
		ORDERS
	WHERE 
		ORDERS_INVOICE.INVOICE_ID = #attributes.iid# AND
		ORDERS_INVOICE.PERIOD_ID = #session.ep.period_id# AND
		ORDERS.ORDER_ID = ORDERS_INVOICE.ORDER_ID
</cfquery>
<cfif get_order.recordcount>
	<cfquery name="GET_ORDER_NUM" datasource="#DSN3#">
		SELECT
			ORDER_NUMBER,
			ORDER_ID
		FROM 
			ORDERS 
		WHERE 
		<cfif get_order.recordcount>
			ORDER_ID IN (#listsort(valuelist(get_order.order_id),"numeric","asc",",")#)
		<cfelse>
			ORDER_ID IS NULL
		</cfif>
	</cfquery>
</cfif>
