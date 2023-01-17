<!-- Description : Giden Senaryo Viewinde bank type düzenlendi
Developer: Melek Kocabey
Company : Workcube
Destination: Period -->
<querytag>
    ALTER VIEW [GET_SCEN_EXPENSE] AS
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
            @_dsn_period_@.CHEQUE C,
            @_dsn_period_@.SETUP_MONEY	SM
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
                @_dsn_period_@.VOUCHER V,
                @_dsn_period_@.SETUP_MONEY	SM
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
                (CER.INSTALLMENT_AMOUNT-(ISNULL((SELECT SUM(CCBER.CLOSED_AMOUNT) FROM @_dsn_company_@.CREDIT_CARD_BANK_EXPENSE_RELATIONS CCBER WHERE CCBER.CC_BANK_EXPENSE_ROWS_ID = CER.CC_BANK_EXPENSE_ROWS_ID),0)))*(CEM.RATE2/CEM.RATE1) CC_EXPENSE_TOTAL,
                0 CREDIT_CONTRACT_TOTAL,
                0 BANK_ORDER_TOTAL,
                0 BUDGET_TOTAL,
                0 SCEN_EXPENSE_TOTAL
            FROM
                @_dsn_company_@.CREDIT_CARD CC,
                @_dsn_company_@.CREDIT_CARD_BANK_EXPENSE CE,
                @_dsn_company_@.CREDIT_CARD_BANK_EXPENSE_ROWS CER,
                @_dsn_company_@.CREDIT_CARD_BANK_EXPENSE_MONEY CEM
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
                @_dsn_company_@.CREDIT_CONTRACT_ROW CC,
                @_dsn_company_@.CREDIT_CONTRACT C,
                @_dsn_period_@.SETUP_MONEY SM
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
                @_dsn_period_@.BANK_ORDERS BON,
                @_dsn_period_@.SETUP_MONEY SM
            WHERE
                (BON.IS_PAID = 0 OR BON.IS_PAID IS NULL)
                AND BON.ACTION_MONEY = SM.MONEY
                AND BANK_ORDER_TYPE = 260
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
                @_dsn_main_@.BUDGET_PLAN BP,
                @_dsn_main_@.BUDGET_PLAN_ROW BPR,
                @_dsn_period_@.SETUP_MONEY SM
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
                    @_dsn_company_@.SCEN_EXPENSE_PERIOD_ROWS SE, 
                    @_dsn_period_@.SETUP_MONEY SM
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
</querytag>