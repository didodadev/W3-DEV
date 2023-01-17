<cfquery name="get_periods" datasource="#dsn#">
	SELECT * FROM SETUP_PERIOD ORDER BY PERIOD_ID DESC
</cfquery>
<CFTRY>
<CFQUERY NAME="EXIST_CONTROL" DATASOURCE="#dsn_dev#">
select * from INFORMATION_SCHEMA.VIEWS WHERE TABLE_NAME = 'GET_PURCHASE_INVOICE_ALL' AND TABLE_SCHEMA = '#dsn_dev#'
</CFQUERY>

<cfif EXIST_CONTROL.recordcount>
	<cftransaction>
	<cfquery name="a_view4" datasource="#dsn_dev#">
		ALTER VIEW [GET_PURCHASE_INVOICE_ALL]
		AS
		<cfoutput query="get_periods">
		<cfif currentrow neq 1> UNION ALL </cfif>
		SELECT 
			IR.WRK_ROW_RELATION_ID,
			I.INVOICE_ID,
			I.DEPARTMENT_ID,
			IR.STOCK_ID,
			IR.AMOUNT,	
			IR.NETTOTAL,
			IR.GROSSTOTAL,
			ROUND(IR.NETTOTAL / IR.AMOUNT,2) SATIR_FIYATI,
			I.INVOICE_DATE
		FROM 
			#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.INVOICE I,
			#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.INVOICE_ROW IR
		WHERE
			I.INVOICE_ID = IR.INVOICE_ID AND
			ISNULL(I.IS_IPTAL,0) = 0 AND
			I.INVOICE_CAT = 59
		</cfoutput>
	</cfquery>
	<cfquery name="a_view2" datasource="#dsn_dev#">
		ALTER VIEW [GET_SHIP_ROWS_REAL]
		AS
		<cfoutput query="get_periods">
		<cfif currentrow neq 1> UNION ALL </cfif>
		SELECT 
			S.SHIP_TYPE,
			S.PROCESS_CAT,
			SR.WRK_ROW_ID,
			S.DEPARTMENT_IN,
			S.DELIVER_STORE_ID,
			SR.PRODUCT_ID,
			SR.STOCK_ID,
			SR.AMOUNT,
			SR.NETTOTAL,
			ISNULL((
				SELECT TOP 1 SATIR_FIYATI FROM GET_PURCHASE_INVOICE_ALL WHERE WRK_ROW_RELATION_ID = SR.WRK_ROW_ID
			),ROUND(SR.NETTOTAL / SR.AMOUNT,4)) AS SATIR_FIYATI,
			SR.GROSSTOTAL,
			SR.TAXTOTAL,
			S.SHIP_DATE
		FROM 
			#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.SHIP S,
			#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.SHIP_ROW SR
		WHERE
			S.SHIP_ID = SR.SHIP_ID AND
			ISNULL(S.IS_SHIP_IPTAL,0) = 0 AND
			S.SHIP_TYPE IN (70,71,76)
		</cfoutput>
	</cfquery>
	<cfquery name="a_view2" datasource="#dsn_dev#">
	<cfoutput query="get_periods">
	IF (NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DAILY_ACTIONS_#PERIOD_YEAR#' ) )
		BEGIN
			CREATE TABLE [DAILY_ACTIONS_#PERIOD_YEAR#](
				[ROW_ID] [int] IDENTITY(1,1) NOT NULL,
				[STOCK_ID] [int] NULL,
				[S_DAY] [int] NULL,
				[S_MONTH] [int] NULL,
				[S_YEAR] [int] NULL,
				[S_TARIH] [datetime] NULL,
				[SALES_COUNT_1] [float] NULL,
				[STOCK_COUNT_1] [float] NULL,
				[STOCK_APPLY_1] [int] NULL,
				[SALES_COUNT_11] [float] NULL,
				[STOCK_COUNT_11] [float] NULL,
				[STOCK_APPLY_11] [int] NULL,
				[SALES_COUNT_3] [float] NULL,
				[STOCK_COUNT_3] [float] NULL,
				[STOCK_APPLY_3] [int] NULL,
				[SALES_COUNT_4] [float] NULL,
				[STOCK_COUNT_4] [float] NULL,
				[STOCK_APPLY_4] [int] NULL,
				[SALES_COUNT_12] [float] NULL,
				[STOCK_COUNT_12] [float] NULL,
				[STOCK_APPLY_12] [int] NULL,
				[SALES_COUNT_6] [float] NULL,
				[STOCK_COUNT_6] [float] NULL,
				[STOCK_APPLY_6] [int] NULL,
				[SALES_COUNT_7] [float] NULL,
				[STOCK_COUNT_7] [float] NULL,
				[STOCK_APPLY_7] [int] NULL,
				[SALES_COUNT_21] [float] NULL,
				[STOCK_COUNT_21] [float] NULL,
				[STOCK_APPLY_21] [int] NULL,
				[SALES_COUNT_9] [float] NULL,
				[STOCK_COUNT_9] [float] NULL,
				[STOCK_APPLY_9] [int] NULL,
				[SALES_COUNT_10] [float] NULL,
				[STOCK_COUNT_10] [float] NULL,
				[STOCK_APPLY_10] [int] NULL,
				[SALES_COUNT_22] [float] NULL,
				[STOCK_COUNT_22] [float] NULL,
				[STOCK_APPLY_22] [int] NULL
			) ON [PRIMARY]
		END
		</cfoutput>
	</CFQUERY>
	<cfquery name="a_view2" datasource="#dsn_dev#">
		ALTER VIEW [DAILY_ACTIONS]
		AS
		<cfoutput query="get_periods">
		<cfif currentrow neq 1> UNION ALL </cfif>
			SELECT * FROM DAILY_ACTIONS_#PERIOD_YEAR#
		</cfoutput>
	</cfquery>
	<!---
	<cfquery name="a_view2" datasource="#dsn_dev#">
	IF ( EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DAILY_STOCK_ACTIONS_1BIN' ) )
	BEGIN
		ALTER VIEW [DAILY_STOCK_ACTIONS_ALL]
		AS
		<cfloop from="1" to="35" index="ii">
		<cfif ii neq 1> UNION ALL </cfif>
			SELECT * FROM DAILY_STOCK_ACTIONS_#ii#BIN
		</cfloop>
	END
	</cfquery>--->
	<cfquery name="a_view7" datasource="#dsn_dev#">
		ALTER VIEW [GET_ALL_CASH_PAYMENTS]
		AS
		<cfoutput query="get_periods">
		<cfif currentrow neq 1> UNION ALL </cfif>
				SELECT
					C.CASH_NAME,
					B.BRANCH_NAME,
					B.BRANCH_ID,
					C.CASH_ID,
					CA.ACTION_DATE,
					CA.ACTION_DETAIL,
					CA.CASH_ACTION_VALUE AS ODEME,
					CM.FULLNAME AS SIRKET,
					CA.PAPER_NO,
					CN.CONSUMER_NAME + ' ' + CN.CONSUMER_SURNAME AS BIREYSEL 
				FROM 
					#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.CASH C,
					#dsn#.BRANCH B,
					#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.CASH_ACTIONS CA
						LEFT JOIN #dsn#.COMPANY CM ON (CM.COMPANY_ID = CA.CASH_ACTION_TO_COMPANY_ID)
						LEFT JOIN #dsn#.CONSUMER CN ON (CN.CONSUMER_ID = CA.CASH_ACTION_FROM_CONSUMER_ID)
				WHERE 
					CA.ACTION_TYPE_ID = 32 AND
					CA.CASH_ACTION_FROM_CASH_ID = C.CASH_ID AND
					C.BRANCH_ID = B.BRANCH_ID
		UNION ALL
			SELECT
					C.CASH_NAME,
					B.BRANCH_NAME,
					B.BRANCH_ID,
					C.CASH_ID,
					EIP.EXPENSE_DATE AS ACTION_DATE,
					EIP.DETAIL AS ACTION_DETAIL,
					EIP.TOTAL_AMOUNT_KDVLI AS ODEME,
					CM.FULLNAME AS SIRKET,
					EIP.PAPER_NO,
					CN.CONSUMER_NAME + ' ' + CN.CONSUMER_SURNAME AS BIREYSEL 
				FROM 
					#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.CASH C,
					#dsn#.BRANCH B,
					#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.EXPENSE_ITEM_PLANS EIP
						LEFT JOIN #dsn#.COMPANY CM ON (CM.COMPANY_ID = EIP.CH_COMPANY_ID)
						LEFT JOIN #dsn#.CONSUMER CN ON (CN.CONSUMER_ID = EIP.CH_CONSUMER_ID)
				WHERE 
					EIP.EXPENSE_CASH_ID = C.CASH_ID AND
					EIP.EXPENSE_COST_TYPE = 120 AND
					EIP.IS_CASH = 1 AND
					C.BRANCH_ID = B.BRANCH_ID
		</cfoutput>
	</cfquery>
	<cfquery name="a_view7" datasource="#dsn_dev#">
		ALTER VIEW [GET_ALL_INVOICE]
		AS
		<cfoutput query="get_periods">
		<cfif currentrow neq 1> UNION ALL </cfif>
				SELECT 
			I.INVOICE_CAT,
			I.PROCESS_CAT,
			I.INVOICE_DATE,
			I.INVOICE_NUMBER
		FROM 
			#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.INVOICE I
		</cfoutput>
	</cfquery>
	<cfquery name="a_view6" datasource="#dsn_dev#">
		ALTER VIEW [GET_ALL_Z_INVOICE]
		AS
		<cfoutput query="get_periods">
		<cfif currentrow neq 1> UNION ALL </cfif>
		SELECT
			SUM(T1.NAKIT_TOTAL) AS NAKIT_TOTAL,
			SUM(T1.DOLAR_TOTAL_TL) AS DOLAR_TOTAL_TL,
			SUM(T1.EURO_TOTAL_TL) AS EURO_TOTAL_TL,
			SUM(T1.DOLAR_TOTAL) AS DOLAR_TOTAL,
			SUM(T1.EURO_TOTAL) AS EURO_TOTAL,
			SUM(T1.YEMEK_TOTAL) AS YEMEK_TOTAL,
			SUM(T1.KK_TOTAL) AS KK_TOTAL,
			COUNT(T1.BRANCH_ID) AS AAA,
			SUM(T1.NETTOTAL) AS TOPLAM_SATIS,
			T1.INVOICE_CAT,
			T1.PROCESS_CAT,
			T1.INVOICE_DATE,
			T1.BRANCH_ID,
			ISNULL((
				SELECT
					SUM(CA.CASH_ACTION_VALUE)
				FROM 
					#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.CASH_ACTIONS CA,
					#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.CASH C
				WHERE 
					CA.ACTION_TYPE_ID = 21 AND
					CA.CASH_ACTION_FROM_CASH_ID = C.CASH_ID AND
					CA.ACTION_DATE = T1.INVOICE_DATE AND
					C.CASH_ID IN (1,11,12)
			),0) AS BANKAYA_YATAN_TOTAL,
			ISNULL((
				SELECT
					SUM(CA.CASH_ACTION_VALUE)
				FROM 
					#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.CASH_ACTIONS CA,
					#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.CASH C
				WHERE 
					CA.ACTION_TYPE_ID = 32 AND
					CA.CASH_ACTION_FROM_CASH_ID = C.CASH_ID AND
					CA.ACTION_DATE = T1.INVOICE_DATE AND
					C.BRANCH_ID = T1.BRANCH_ID
			),0) AS ODEME_TOTAL,
			ISNULL((
				SELECT
					SUM(I2.NETTOTAL)
				FROM 
					#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.INVOICE I2,
					#dsn#.DEPARTMENT D2
				WHERE 
					I2.INVOICE_CAT = 55 AND
					I2.PROCESS_CAT = 89 AND
					I2.DEPARTMENT_ID = D2.DEPARTMENT_ID AND
					I2.INVOICE_DATE = T1.INVOICE_DATE AND
					D2.BRANCH_ID = T1.BRANCH_ID
			),0) AS IADE_TOTAL,
			ISNULL((
				SELECT
					SUM(I3.NETTOTAL)
				FROM 
					#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.INVOICE I3,
					#dsn#.DEPARTMENT D3
				WHERE 
					I3.IS_CASH = 1 AND
					I3.IS_PROCESSED = 1 AND
					I3.INVOICE_CAT = 52 AND
					I3.PROCESS_CAT = 105 AND
					I3.DEPARTMENT_ID = D3.DEPARTMENT_ID AND
					I3.INVOICE_DATE = T1.INVOICE_DATE AND
					D3.BRANCH_ID = T1.BRANCH_ID
			),0) AS FATURALI_SATIS_TOTAL,
			ISNULL((
				SELECT
					SUM(I3.NETTOTAL)
				FROM 
					#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.INVOICE I3,
					#dsn#.DEPARTMENT D3
				WHERE 
					ISNULL(I3.IS_CASH,0) = 0 AND
					I3.IS_PROCESSED = 1 AND
					I3.INVOICE_CAT = 52 AND
					I3.PROCESS_CAT = 105 AND
					I3.DEPARTMENT_ID = D3.DEPARTMENT_ID AND
					I3.INVOICE_DATE = T1.INVOICE_DATE AND
					D3.BRANCH_ID = T1.BRANCH_ID
			),0) AS DIGER_FATURALI_SATIS_TOTAL,
			ISNULL((
				SELECT
					SUM(TOTAL_AMOUNT_KDVLI)
				FROM
					#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.EXPENSE_ITEM_PLANS EIP,
					#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.CASH C
				WHERE
					EIP.EXPENSE_CASH_ID = C.CASH_ID AND
					EIP.EXPENSE_COST_TYPE = 120 AND
					EIP.IS_CASH = 1 AND
					EIP.EXPENSE_DATE = T1.INVOICE_DATE AND
					C.BRANCH_ID = T1.BRANCH_ID
			),0) AS MASRAF_FISI_TOTAL
		FROM
			(
				SELECT 
					I.INVOICE_CAT,
					I.PROCESS_CAT,
					I.INVOICE_DATE,
					D.BRANCH_ID,
					I.NETTOTAL,
					ISNULL((
						SELECT 
							SUM(ACTION_VALUE)
						FROM
							#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.INVOICE_CASH_POS,
							#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.CASH_ACTIONS
						WHERE
							CASH_ACTIONS.ACTION_ID=INVOICE_CASH_POS.CASH_ID
							AND INVOICE_CASH_POS.INVOICE_ID=I.INVOICE_ID 
					),0) AS NAKIT_TOTAL,
					ISNULL((
						SELECT 
							SUM(ACTION_VALUE)
						FROM
							#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.INVOICE_CASH_POS,
							#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.CASH_ACTIONS,
							#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.CASH
						WHERE
							CASH.CASH_ID = CASH_ACTIONS.CASH_ACTION_TO_CASH_ID AND
							CASH_ACTIONS.ACTION_ID=INVOICE_CASH_POS.CASH_ID AND 
							INVOICE_CASH_POS.INVOICE_ID=I.INVOICE_ID AND
							CASH.CASH_CURRENCY_ID = 'USD'
					),0) AS DOLAR_TOTAL_TL,
					ISNULL((
						SELECT 
							SUM(CASH_ACTION_VALUE)
						FROM
							#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.INVOICE_CASH_POS,
							#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.CASH_ACTIONS,
							#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.CASH
						WHERE
							CASH.CASH_ID = CASH_ACTIONS.CASH_ACTION_TO_CASH_ID AND
							CASH_ACTIONS.ACTION_ID=INVOICE_CASH_POS.CASH_ID AND 
							INVOICE_CASH_POS.INVOICE_ID=I.INVOICE_ID AND
							CASH.CASH_CURRENCY_ID = 'USD'
					),0) AS DOLAR_TOTAL,
					ISNULL((
						SELECT 
							SUM(ACTION_VALUE)
						FROM
							#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.INVOICE_CASH_POS,
							#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.CASH_ACTIONS,
							#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.CASH
						WHERE
							CASH.CASH_ID = CASH_ACTIONS.CASH_ACTION_TO_CASH_ID AND
							CASH_ACTIONS.ACTION_ID=INVOICE_CASH_POS.CASH_ID AND 
							INVOICE_CASH_POS.INVOICE_ID=I.INVOICE_ID AND
							CASH.CASH_CURRENCY_ID = 'EUR'
					),0) AS EURO_TOTAL_TL,
					ISNULL((
						SELECT 
							SUM(CASH_ACTION_VALUE)
						FROM
							#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.INVOICE_CASH_POS,
							#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.CASH_ACTIONS,
							#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.CASH
						WHERE
							CASH.CASH_ID = CASH_ACTIONS.CASH_ACTION_TO_CASH_ID AND
							CASH_ACTIONS.ACTION_ID=INVOICE_CASH_POS.CASH_ID AND 
							INVOICE_CASH_POS.INVOICE_ID=I.INVOICE_ID AND
							CASH.CASH_CURRENCY_ID = 'EUR'
					),0) AS EURO_TOTAL,
					ISNULL((
						SELECT
							SUM(CCBP.SALES_CREDIT)
						FROM
							#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.INVOICE_CASH_POS ICP,
							#dsn#_#OUR_COMPANY_ID#.CREDIT_CARD_BANK_PAYMENTS CCBP
						WHERE
							ICP.INVOICE_ID= I.INVOICE_ID AND
							ICP.POS_ACTION_ID=CCBP.CREDITCARD_PAYMENT_ID AND
							ICP.POS_ID IN (13,14,15,16)
					),0) AS YEMEK_TOTAL,
					ISNULL((
						SELECT
							SUM(CCBP.SALES_CREDIT)
						FROM
							#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.INVOICE_CASH_POS ICP,
							#dsn#_#OUR_COMPANY_ID#.CREDIT_CARD_BANK_PAYMENTS CCBP
						WHERE
							ICP.INVOICE_ID= I.INVOICE_ID AND
							ICP.POS_ACTION_ID=CCBP.CREDITCARD_PAYMENT_ID AND
							ICP.POS_ID NOT IN (13,14,15,16)
					),0) AS KK_TOTAL
				FROM 
					#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.INVOICE I,
					#dsn#.DEPARTMENT D
				WHERE
					I.INVOICE_CAT = 69 AND
					I.DEPARTMENT_ID = D.DEPARTMENT_ID
					--AND I.INVOICE_ID = 57479
		) T1
		GROUP BY
			T1.INVOICE_CAT,
			T1.PROCESS_CAT,
			T1.INVOICE_DATE,
			T1.BRANCH_ID
		</cfoutput>
	</cfquery>
	<cfquery name="a_view5" datasource="#dsn_dev#">
		ALTER VIEW [GET_INVOICE_SHIPS]
		AS
		<cfoutput query="get_periods">
		<cfif currentrow neq 1> UNION ALL </cfif>
		SELECT * FROM #dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.INVOICE_SHIPS
		</cfoutput>
	</cfquery>
	<cfquery name="a_view3" datasource="#dsn_dev#">
		ALTER VIEW [GET_SHIP_ROWS]
		AS
		<cfoutput query="get_periods">
		<cfif currentrow neq 1> UNION ALL </cfif>
		SELECT 
			S.DEPARTMENT_IN,
			SR.STOCK_ID,
			SR.AMOUNT,
			SR.NETTOTAL,
			SR.GROSSTOTAL,
			SR.TAXTOTAL,
			S.SHIP_DATE
		FROM 
			#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.SHIP S,
			#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.SHIP_ROW SR
		WHERE
			S.SHIP_ID = SR.SHIP_ID AND
			ISNULL(S.IS_SHIP_IPTAL,0) = 0 AND
			S.SHIP_TYPE = 76
		</cfoutput>
	</cfquery>
	<cfquery name="a_view" datasource="#dsn_dev#">
		ALTER VIEW [GET_STOCK_ROWS]
		AS
		<cfoutput query="get_periods">
		<cfif currentrow neq 1> UNION ALL </cfif>
			SELECT STOCK_IN,STOCK_OUT,STOCK_ID,PROCESS_TYPE,PROCESS_DATE,STORE,0 AS UPPER_PROCESS_TYPE FROM #dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.STOCKS_ROW
		</cfoutput>
	</cfquery>
	<cfoutput query="get_periods">
	<cfquery name="proc" datasource="#dsn_dev#">
		ALTER PROCEDURE [#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#].[get_stock_last_location_function]
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
                    #dsn#.fnSplit(@stock_id_list,',') AS TB1
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
                     #dsn#.fnSplit(@stock_id_list,',') AS TB1
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
                     #dsn#.STOCKS_LOCATION SL WITH (NOLOCK),
                    STOCKS_ROW SR WITH (NOLOCK)
                JOIN
                     #dsn#.fnSplit(@stock_id_list,',') AS TB1
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
                     #dsn#.fnSplit(@stock_id_list,',') AS TB1
                ON 
                    TB1.item = SR.STOCK_ID	
                    ,
                     #dsn#.STOCKS_LOCATION SL WITH (NOLOCK) 
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
                     #dsn#.STOCKS_LOCATION SL WITH (NOLOCK),
                    STOCKS_ROW SR WITH (NOLOCK)
                JOIN
                     #dsn#.fnSplit(@stock_id_list,',') AS TB1
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
                     #dsn#.STOCKS_LOCATION SL WITH (NOLOCK),
                    STOCKS_ROW SR WITH (NOLOCK)
                JOIN
                     #dsn#.fnSplit(@stock_id_list,',') AS TB1
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
                      #dsn#_#OUR_COMPANY_ID#.GET_ORDER_ROW_RESERVED ORR WITH (NOLOCK)
                JOIN
                     #dsn#.fnSplit(@stock_id_list,',') AS TB1
                ON 
                    TB1.item = ORR.STOCK_ID
                    , 
                      #dsn#_#OUR_COMPANY_ID#.ORDERS ORDS WITH (NOLOCK)
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
                      #dsn#_#OUR_COMPANY_ID#.GET_ORDER_ROW_RESERVED ORR WITH (NOLOCK)
                JOIN
                     #dsn#.fnSplit(@stock_id_list,',') AS TB1
                ON 
                    TB1.item = ORR.STOCK_ID	
                    , 
                      #dsn#_#OUR_COMPANY_ID#.ORDERS ORDS WITH (NOLOCK),
                     #dsn#.STOCKS_LOCATION SL WITH (NOLOCK)
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
                      #dsn#_#OUR_COMPANY_ID#.GET_ORDER_ROW_RESERVED ORR WITH (NOLOCK)
                JOIN
                     #dsn#.fnSplit(@stock_id_list,',') AS TB1
                ON 
                    TB1.item = ORR.STOCK_ID
                    , 
                      #dsn#_#OUR_COMPANY_ID#.ORDERS ORDS WITH (NOLOCK),
                     #dsn#.STOCKS_LOCATION SL WITH (NOLOCK)
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
                          #dsn#_#OUR_COMPANY_ID#.GET_PRODUCTION_RESERVED_LOCATION WITH (NOLOCK)
                    JOIN
                         #dsn#.fnSplit(@stock_id_list,',') AS TB1
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
	</cfoutput>
	</cftransaction>
<cfelse>
	<cftransaction>
	<cfquery name="a_view4" datasource="#dsn_dev#">
		CREATE VIEW [GET_PURCHASE_INVOICE_ALL]
		AS
		<cfoutput query="get_periods">
		<cfif currentrow neq 1> UNION ALL </cfif>
		SELECT 
			IR.WRK_ROW_RELATION_ID,
			I.INVOICE_ID,
			I.DEPARTMENT_ID,
			IR.STOCK_ID,
			IR.AMOUNT,	
			IR.NETTOTAL,
			IR.GROSSTOTAL,
			ROUND(IR.NETTOTAL / IR.AMOUNT,2) SATIR_FIYATI,
			I.INVOICE_DATE
		FROM 
			#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.INVOICE I,
			#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.INVOICE_ROW IR
		WHERE
			I.INVOICE_ID = IR.INVOICE_ID AND
			ISNULL(I.IS_IPTAL,0) = 0 AND
			I.INVOICE_CAT = 59
		</cfoutput>
	</cfquery>
	<cfquery name="a_view2" datasource="#dsn_dev#">
		CREATE VIEW [GET_SHIP_ROWS_REAL]
		AS
		<cfoutput query="get_periods">
		<cfif currentrow neq 1> UNION ALL </cfif>
		SELECT 
			S.SHIP_TYPE,
			S.PROCESS_CAT,
			SR.WRK_ROW_ID,
			S.DEPARTMENT_IN,
			S.DELIVER_STORE_ID,
			SR.PRODUCT_ID,
			SR.STOCK_ID,
			SR.AMOUNT,
			SR.NETTOTAL,
			ISNULL((
				SELECT TOP 1 SATIR_FIYATI FROM GET_PURCHASE_INVOICE_ALL WHERE WRK_ROW_RELATION_ID = SR.WRK_ROW_ID
			),ROUND(SR.NETTOTAL / SR.AMOUNT,4)) AS SATIR_FIYATI,
			SR.GROSSTOTAL,
			SR.TAXTOTAL,
			S.SHIP_DATE
		FROM 
			#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.SHIP S,
			#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.SHIP_ROW SR
		WHERE
			S.SHIP_ID = SR.SHIP_ID AND
			ISNULL(S.IS_SHIP_IPTAL,0) = 0 AND
			S.SHIP_TYPE IN (70,71,76)
		</cfoutput>
	</cfquery>
	<cfquery name="a_view2" datasource="#dsn_dev#">
	<cfoutput query="get_periods">
	IF (NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DAILY_ACTIONS_#PERIOD_YEAR#' ) )
		BEGIN
			CREATE TABLE [DAILY_ACTIONS_#PERIOD_YEAR#](
				[ROW_ID] [int] IDENTITY(1,1) NOT NULL,
				[STOCK_ID] [int] NULL,
				[S_DAY] [int] NULL,
				[S_MONTH] [int] NULL,
				[S_YEAR] [int] NULL,
				[S_TARIH] [datetime] NULL,
				[SALES_COUNT_1] [float] NULL,
				[STOCK_COUNT_1] [float] NULL,
				[STOCK_APPLY_1] [int] NULL,
				[SALES_COUNT_11] [float] NULL,
				[STOCK_COUNT_11] [float] NULL,
				[STOCK_APPLY_11] [int] NULL,
				[SALES_COUNT_3] [float] NULL,
				[STOCK_COUNT_3] [float] NULL,
				[STOCK_APPLY_3] [int] NULL,
				[SALES_COUNT_4] [float] NULL,
				[STOCK_COUNT_4] [float] NULL,
				[STOCK_APPLY_4] [int] NULL,
				[SALES_COUNT_12] [float] NULL,
				[STOCK_COUNT_12] [float] NULL,
				[STOCK_APPLY_12] [int] NULL,
				[SALES_COUNT_6] [float] NULL,
				[STOCK_COUNT_6] [float] NULL,
				[STOCK_APPLY_6] [int] NULL,
				[SALES_COUNT_7] [float] NULL,
				[STOCK_COUNT_7] [float] NULL,
				[STOCK_APPLY_7] [int] NULL,
				[SALES_COUNT_21] [float] NULL,
				[STOCK_COUNT_21] [float] NULL,
				[STOCK_APPLY_21] [int] NULL,
				[SALES_COUNT_9] [float] NULL,
				[STOCK_COUNT_9] [float] NULL,
				[STOCK_APPLY_9] [int] NULL,
				[SALES_COUNT_10] [float] NULL,
				[STOCK_COUNT_10] [float] NULL,
				[STOCK_APPLY_10] [int] NULL,
				[SALES_COUNT_22] [float] NULL,
				[STOCK_COUNT_22] [float] NULL,
				[STOCK_APPLY_22] [int] NULL
			) ON [PRIMARY]
		END
		</cfoutput>
	</CFQUERY>
	<cfquery name="a_view2" datasource="#dsn_dev#">
		CREATE VIEW [DAILY_ACTIONS]
		AS
		<cfoutput query="get_periods">
		<cfif currentrow neq 1> UNION ALL </cfif>
			SELECT * FROM DAILY_ACTIONS_#PERIOD_YEAR#
		</cfoutput>
	</cfquery>
	<!---
	<cfquery name="a_view2" datasource="#dsn_dev#">
	IF ( EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DAILY_STOCK_ACTIONS_1BIN' ) )
	BEGIN
		CREATE VIEW [DAILY_STOCK_ACTIONS_ALL]
		AS
		<cfloop from="1" to="35" index="ii">
		<cfif ii neq 1> UNION ALL </cfif>
			SELECT * FROM DAILY_STOCK_ACTIONS_#ii#BIN
		</cfloop>
	END
	</cfquery>---->
	<cfquery name="a_view7" datasource="#dsn_dev#">
		CREATE VIEW [GET_ALL_CASH_PAYMENTS]
		AS
		<cfoutput query="get_periods">
		<cfif currentrow neq 1> UNION ALL </cfif>
				SELECT
					C.CASH_NAME,
					B.BRANCH_NAME,
					B.BRANCH_ID,
					C.CASH_ID,
					CA.ACTION_DATE,
					CA.ACTION_DETAIL,
					CA.CASH_ACTION_VALUE AS ODEME,
					CM.FULLNAME AS SIRKET,
					CA.PAPER_NO,
					CN.CONSUMER_NAME + ' ' + CN.CONSUMER_SURNAME AS BIREYSEL 
				FROM 
					#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.CASH C,
					#dsn#.BRANCH B,
					#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.CASH_ACTIONS CA
						LEFT JOIN #dsn#.COMPANY CM ON (CM.COMPANY_ID = CA.CASH_ACTION_TO_COMPANY_ID)
						LEFT JOIN #dsn#.CONSUMER CN ON (CN.CONSUMER_ID = CA.CASH_ACTION_FROM_CONSUMER_ID)
				WHERE 
					CA.ACTION_TYPE_ID = 32 AND
					CA.CASH_ACTION_FROM_CASH_ID = C.CASH_ID AND
					C.BRANCH_ID = B.BRANCH_ID
		UNION ALL
			SELECT
					C.CASH_NAME,
					B.BRANCH_NAME,
					B.BRANCH_ID,
					C.CASH_ID,
					EIP.EXPENSE_DATE AS ACTION_DATE,
					EIP.DETAIL AS ACTION_DETAIL,
					EIP.TOTAL_AMOUNT_KDVLI AS ODEME,
					CM.FULLNAME AS SIRKET,
					EIP.PAPER_NO,
					CN.CONSUMER_NAME + ' ' + CN.CONSUMER_SURNAME AS BIREYSEL 
				FROM 
					#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.CASH C,
					#dsn#.BRANCH B,
					#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.EXPENSE_ITEM_PLANS EIP
						LEFT JOIN #dsn#.COMPANY CM ON (CM.COMPANY_ID = EIP.CH_COMPANY_ID)
						LEFT JOIN #dsn#.CONSUMER CN ON (CN.CONSUMER_ID = EIP.CH_CONSUMER_ID)
				WHERE 
					EIP.EXPENSE_CASH_ID = C.CASH_ID AND
					EIP.EXPENSE_COST_TYPE = 120 AND
					EIP.IS_CASH = 1 AND
					C.BRANCH_ID = B.BRANCH_ID
		</cfoutput>
	</cfquery>
	<cfquery name="a_view7" datasource="#dsn_dev#">
		CREATE VIEW [GET_ALL_INVOICE]
		AS
		<cfoutput query="get_periods">
		<cfif currentrow neq 1> UNION ALL </cfif>
				SELECT 
			I.INVOICE_CAT,
			I.PROCESS_CAT,
			I.INVOICE_DATE,
			I.INVOICE_NUMBER
		FROM 
			#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.INVOICE I
		</cfoutput>
	</cfquery>
	<cfquery name="a_view6" datasource="#dsn_dev#">
		CREATE VIEW [GET_ALL_Z_INVOICE]
		AS
		<cfoutput query="get_periods">
		<cfif currentrow neq 1> UNION ALL </cfif>
		SELECT
			SUM(T1.NAKIT_TOTAL) AS NAKIT_TOTAL,
			SUM(T1.DOLAR_TOTAL_TL) AS DOLAR_TOTAL_TL,
			SUM(T1.EURO_TOTAL_TL) AS EURO_TOTAL_TL,
			SUM(T1.DOLAR_TOTAL) AS DOLAR_TOTAL,
			SUM(T1.EURO_TOTAL) AS EURO_TOTAL,
			SUM(T1.YEMEK_TOTAL) AS YEMEK_TOTAL,
			SUM(T1.KK_TOTAL) AS KK_TOTAL,
			COUNT(T1.BRANCH_ID) AS AAA,
			SUM(T1.NETTOTAL) AS TOPLAM_SATIS,
			T1.INVOICE_CAT,
			T1.PROCESS_CAT,
			T1.INVOICE_DATE,
			T1.BRANCH_ID,
			ISNULL((
				SELECT
					SUM(CA.CASH_ACTION_VALUE)
				FROM 
					#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.CASH_ACTIONS CA,
					#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.CASH C
				WHERE 
					CA.ACTION_TYPE_ID = 21 AND
					CA.CASH_ACTION_FROM_CASH_ID = C.CASH_ID AND
					CA.ACTION_DATE = T1.INVOICE_DATE AND
					C.CASH_ID IN (1,11,12)
			),0) AS BANKAYA_YATAN_TOTAL,
			ISNULL((
				SELECT
					SUM(CA.CASH_ACTION_VALUE)
				FROM 
					#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.CASH_ACTIONS CA,
					#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.CASH C
				WHERE 
					CA.ACTION_TYPE_ID = 32 AND
					CA.CASH_ACTION_FROM_CASH_ID = C.CASH_ID AND
					CA.ACTION_DATE = T1.INVOICE_DATE AND
					C.BRANCH_ID = T1.BRANCH_ID
			),0) AS ODEME_TOTAL,
			ISNULL((
				SELECT
					SUM(I2.NETTOTAL)
				FROM 
					#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.INVOICE I2,
					#dsn#.DEPARTMENT D2
				WHERE 
					I2.INVOICE_CAT = 55 AND
					I2.PROCESS_CAT = 89 AND
					I2.DEPARTMENT_ID = D2.DEPARTMENT_ID AND
					I2.INVOICE_DATE = T1.INVOICE_DATE AND
					D2.BRANCH_ID = T1.BRANCH_ID
			),0) AS IADE_TOTAL,
			ISNULL((
				SELECT
					SUM(I3.NETTOTAL)
				FROM 
					#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.INVOICE I3,
					#dsn#.DEPARTMENT D3
				WHERE 
					I3.IS_CASH = 1 AND
					I3.IS_PROCESSED = 1 AND
					I3.INVOICE_CAT = 52 AND
					I3.PROCESS_CAT = 105 AND
					I3.DEPARTMENT_ID = D3.DEPARTMENT_ID AND
					I3.INVOICE_DATE = T1.INVOICE_DATE AND
					D3.BRANCH_ID = T1.BRANCH_ID
			),0) AS FATURALI_SATIS_TOTAL,
			ISNULL((
				SELECT
					SUM(I3.NETTOTAL)
				FROM 
					#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.INVOICE I3,
					#dsn#.DEPARTMENT D3
				WHERE 
					ISNULL(I3.IS_CASH,0) = 0 AND
					I3.IS_PROCESSED = 1 AND
					I3.INVOICE_CAT = 52 AND
					I3.PROCESS_CAT = 105 AND
					I3.DEPARTMENT_ID = D3.DEPARTMENT_ID AND
					I3.INVOICE_DATE = T1.INVOICE_DATE AND
					D3.BRANCH_ID = T1.BRANCH_ID
			),0) AS DIGER_FATURALI_SATIS_TOTAL,
			ISNULL((
				SELECT
					SUM(TOTAL_AMOUNT_KDVLI)
				FROM
					#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.EXPENSE_ITEM_PLANS EIP,
					#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.CASH C
				WHERE
					EIP.EXPENSE_CASH_ID = C.CASH_ID AND
					EIP.EXPENSE_COST_TYPE = 120 AND
					EIP.IS_CASH = 1 AND
					EIP.EXPENSE_DATE = T1.INVOICE_DATE AND
					C.BRANCH_ID = T1.BRANCH_ID
			),0) AS MASRAF_FISI_TOTAL
		FROM
			(
				SELECT 
					I.INVOICE_CAT,
					I.PROCESS_CAT,
					I.INVOICE_DATE,
					D.BRANCH_ID,
					I.NETTOTAL,
					ISNULL((
						SELECT 
							SUM(ACTION_VALUE)
						FROM
							#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.INVOICE_CASH_POS,
							#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.CASH_ACTIONS
						WHERE
							CASH_ACTIONS.ACTION_ID=INVOICE_CASH_POS.CASH_ID
							AND INVOICE_CASH_POS.INVOICE_ID=I.INVOICE_ID 
					),0) AS NAKIT_TOTAL,
					ISNULL((
						SELECT 
							SUM(ACTION_VALUE)
						FROM
							#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.INVOICE_CASH_POS,
							#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.CASH_ACTIONS,
							#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.CASH
						WHERE
							CASH.CASH_ID = CASH_ACTIONS.CASH_ACTION_TO_CASH_ID AND
							CASH_ACTIONS.ACTION_ID=INVOICE_CASH_POS.CASH_ID AND 
							INVOICE_CASH_POS.INVOICE_ID=I.INVOICE_ID AND
							CASH.CASH_CURRENCY_ID = 'USD'
					),0) AS DOLAR_TOTAL_TL,
					ISNULL((
						SELECT 
							SUM(CASH_ACTION_VALUE)
						FROM
							#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.INVOICE_CASH_POS,
							#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.CASH_ACTIONS,
							#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.CASH
						WHERE
							CASH.CASH_ID = CASH_ACTIONS.CASH_ACTION_TO_CASH_ID AND
							CASH_ACTIONS.ACTION_ID=INVOICE_CASH_POS.CASH_ID AND 
							INVOICE_CASH_POS.INVOICE_ID=I.INVOICE_ID AND
							CASH.CASH_CURRENCY_ID = 'USD'
					),0) AS DOLAR_TOTAL,
					ISNULL((
						SELECT 
							SUM(ACTION_VALUE)
						FROM
							#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.INVOICE_CASH_POS,
							#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.CASH_ACTIONS,
							#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.CASH
						WHERE
							CASH.CASH_ID = CASH_ACTIONS.CASH_ACTION_TO_CASH_ID AND
							CASH_ACTIONS.ACTION_ID=INVOICE_CASH_POS.CASH_ID AND 
							INVOICE_CASH_POS.INVOICE_ID=I.INVOICE_ID AND
							CASH.CASH_CURRENCY_ID = 'EUR'
					),0) AS EURO_TOTAL_TL,
					ISNULL((
						SELECT 
							SUM(CASH_ACTION_VALUE)
						FROM
							#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.INVOICE_CASH_POS,
							#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.CASH_ACTIONS,
							#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.CASH
						WHERE
							CASH.CASH_ID = CASH_ACTIONS.CASH_ACTION_TO_CASH_ID AND
							CASH_ACTIONS.ACTION_ID=INVOICE_CASH_POS.CASH_ID AND 
							INVOICE_CASH_POS.INVOICE_ID=I.INVOICE_ID AND
							CASH.CASH_CURRENCY_ID = 'EUR'
					),0) AS EURO_TOTAL,
					ISNULL((
						SELECT
							SUM(CCBP.SALES_CREDIT)
						FROM
							#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.INVOICE_CASH_POS ICP,
							#dsn#_#OUR_COMPANY_ID#.CREDIT_CARD_BANK_PAYMENTS CCBP
						WHERE
							ICP.INVOICE_ID= I.INVOICE_ID AND
							ICP.POS_ACTION_ID=CCBP.CREDITCARD_PAYMENT_ID AND
							ICP.POS_ID IN (13,14,15,16)
					),0) AS YEMEK_TOTAL,
					ISNULL((
						SELECT
							SUM(CCBP.SALES_CREDIT)
						FROM
							#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.INVOICE_CASH_POS ICP,
							#dsn#_#OUR_COMPANY_ID#.CREDIT_CARD_BANK_PAYMENTS CCBP
						WHERE
							ICP.INVOICE_ID= I.INVOICE_ID AND
							ICP.POS_ACTION_ID=CCBP.CREDITCARD_PAYMENT_ID AND
							ICP.POS_ID NOT IN (13,14,15,16)
					),0) AS KK_TOTAL
				FROM 
					#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.INVOICE I,
					#dsn#.DEPARTMENT D
				WHERE
					I.INVOICE_CAT = 69 AND
					I.DEPARTMENT_ID = D.DEPARTMENT_ID
					--AND I.INVOICE_ID = 57479
		) T1
		GROUP BY
			T1.INVOICE_CAT,
			T1.PROCESS_CAT,
			T1.INVOICE_DATE,
			T1.BRANCH_ID
		</cfoutput>
	</cfquery>
	<cfquery name="a_view5" datasource="#dsn_dev#">
		CREATE VIEW [GET_INVOICE_SHIPS]
		AS
		<cfoutput query="get_periods">
		<cfif currentrow neq 1> UNION ALL </cfif>
		SELECT * FROM #dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.INVOICE_SHIPS
		</cfoutput>
	</cfquery>
	<cfquery name="a_view3" datasource="#dsn_dev#">
		CREATE VIEW [GET_SHIP_ROWS]
		AS
		<cfoutput query="get_periods">
		<cfif currentrow neq 1> UNION ALL </cfif>
		SELECT 
			S.DEPARTMENT_IN,
			SR.STOCK_ID,
			SR.AMOUNT,
			SR.NETTOTAL,
			SR.GROSSTOTAL,
			SR.TAXTOTAL,
			S.SHIP_DATE
		FROM 
			#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.SHIP S,
			#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.SHIP_ROW SR
		WHERE
			S.SHIP_ID = SR.SHIP_ID AND
			ISNULL(S.IS_SHIP_IPTAL,0) = 0 AND
			S.SHIP_TYPE = 76
		</cfoutput>
	</cfquery>
	<cfquery name="a_view" datasource="#dsn_dev#">
		CREATE VIEW [GET_STOCK_ROWS]
		AS
		<cfoutput query="get_periods">
		<cfif currentrow neq 1> UNION ALL </cfif>
			SELECT STOCK_IN,STOCK_OUT,STOCK_ID,PROCESS_TYPE,PROCESS_DATE,STORE,0 AS UPPER_PROCESS_TYPE FROM #dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.STOCKS_ROW
		</cfoutput>
	</cfquery>
	<cfoutput query="get_periods">
	<cfquery name="proc" datasource="#dsn_dev#">
		CREATE PROCEDURE [#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#].[get_stock_last_location_function]
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
                    #dsn#.fnSplit(@stock_id_list,',') AS TB1
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
                     #dsn#.fnSplit(@stock_id_list,',') AS TB1
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
                     #dsn#.STOCKS_LOCATION SL WITH (NOLOCK),
                    STOCKS_ROW SR WITH (NOLOCK)
                JOIN
                     #dsn#.fnSplit(@stock_id_list,',') AS TB1
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
                     #dsn#.fnSplit(@stock_id_list,',') AS TB1
                ON 
                    TB1.item = SR.STOCK_ID	
                    ,
                     #dsn#.STOCKS_LOCATION SL WITH (NOLOCK) 
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
                     #dsn#.STOCKS_LOCATION SL WITH (NOLOCK),
                    STOCKS_ROW SR WITH (NOLOCK)
                JOIN
                     #dsn#.fnSplit(@stock_id_list,',') AS TB1
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
                     #dsn#.STOCKS_LOCATION SL WITH (NOLOCK),
                    STOCKS_ROW SR WITH (NOLOCK)
                JOIN
                     #dsn#.fnSplit(@stock_id_list,',') AS TB1
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
                      #dsn#_#OUR_COMPANY_ID#.GET_ORDER_ROW_RESERVED ORR WITH (NOLOCK)
                JOIN
                     #dsn#.fnSplit(@stock_id_list,',') AS TB1
                ON 
                    TB1.item = ORR.STOCK_ID
                    , 
                      #dsn#_#OUR_COMPANY_ID#.ORDERS ORDS WITH (NOLOCK)
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
                      #dsn#_#OUR_COMPANY_ID#.GET_ORDER_ROW_RESERVED ORR WITH (NOLOCK)
                JOIN
                     #dsn#.fnSplit(@stock_id_list,',') AS TB1
                ON 
                    TB1.item = ORR.STOCK_ID	
                    , 
                      #dsn#_#OUR_COMPANY_ID#.ORDERS ORDS WITH (NOLOCK),
                     #dsn#.STOCKS_LOCATION SL WITH (NOLOCK)
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
                      #dsn#_#OUR_COMPANY_ID#.GET_ORDER_ROW_RESERVED ORR WITH (NOLOCK)
                JOIN
                     #dsn#.fnSplit(@stock_id_list,',') AS TB1
                ON 
                    TB1.item = ORR.STOCK_ID
                    , 
                      #dsn#_#OUR_COMPANY_ID#.ORDERS ORDS WITH (NOLOCK),
                     #dsn#.STOCKS_LOCATION SL WITH (NOLOCK)
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
                          #dsn#_#OUR_COMPANY_ID#.GET_PRODUCTION_RESERVED_LOCATION WITH (NOLOCK)
                    JOIN
                         #dsn#.fnSplit(@stock_id_list,',') AS TB1
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
	</cfoutput>
	</cftransaction>
</cfif>
<cfcatch>
	<cfdump var="#cfcatch#" abort>
	<script>
		alert('<cfoutput>#cfcatch.message#</cfoutput>')
	</script>
</cfcatch>
</CFTRY>
<script>
	alert('Aktarım Tamamlandı!');
	window.close();
</script>