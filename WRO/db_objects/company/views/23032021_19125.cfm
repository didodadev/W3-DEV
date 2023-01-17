CREATE VIEW [@_dsn_company_@].[GET_ORDER_ROW_RESERVED] AS
                    SELECT 
                        STOCK_ID,
                        PRODUCT_ID,
                        SPECT_VAR_ID,
                        ORDER_ID,
                        STOCK_STRATEGY_ID,
                        SUM(RESERVE_STOCK_IN)      RESERVE_STOCK_IN,
                        SUM(RESERVE_STOCK_OUT)     RESERVE_STOCK_OUT,
                        SUM(STOCK_IN)              STOCK_IN,
                        SUM(STOCK_OUT)             STOCK_OUT
                    FROM ORDER_ROW_RESERVED
                        LEFT JOIN (
                                SELECT ORDER_WRK_ROW_ID,
                                        COUNT(ROW_RESERVED_ID) AS SAYAC
                                FROM   ORDER_ROW_RESERVED
                                GROUP BY
                                        ORDER_WRK_ROW_ID
                                HAVING COUNT(ROW_RESERVED_ID) > 1
                            )                  AS XXX
                            ON  XXX.ORDER_WRK_ROW_ID = ORDER_ROW_RESERVED.ORDER_WRK_ROW_ID
                    WHERE  ORDER_ROW_RESERVED.ORDER_WRK_ROW_ID IS NULL
                        OR  (INVOICE_ID IS NULL AND SHIP_ID IS NULL)
                        OR  (
                                (INVOICE_ID IS NOT NULL OR SHIP_ID IS NOT NULL)
                                AND ORDER_ROW_RESERVED.ORDER_WRK_ROW_ID IS NOT NULL
                                AND XXX.ORDER_WRK_ROW_ID IS NOT NULL
                            )
                    GROUP BY
                        STOCK_ID,
                        PRODUCT_ID,
                        SPECT_VAR_ID,
                        ORDER_ID,
                        STOCK_STRATEGY_ID

CREATE VIEW [@_dsn_company_@].[GET_ORDER_ROWS_RESERVED] AS
                    SELECT
                        STOCK_ID,
                        PRODUCT_ID,
                        SPECT_VAR_ID,
                        ORDER_ID,
                        STOCK_STRATEGY_ID,
                        ORDER_ROW_RESERVED.ORDER_WRK_ROW_ID,
                        SUM(RESERVE_STOCK_IN)      RESERVE_STOCK_IN,
                        SUM(RESERVE_STOCK_OUT)     RESERVE_STOCK_OUT,
                        SUM(STOCK_IN)              STOCK_IN,
                        SUM(STOCK_OUT)             STOCK_OUT
                    FROM   ORDER_ROW_RESERVED
                    LEFT JOIN (
                                SELECT ORDER_WRK_ROW_ID,
                                    COUNT(ROW_RESERVED_ID) AS SAYAC
                                FROM   ORDER_ROW_RESERVED
                                GROUP BY
                                    ORDER_WRK_ROW_ID
                                HAVING COUNT(ROW_RESERVED_ID) > 1
                            )                  AS XXX
                            ON  XXX.ORDER_WRK_ROW_ID = ORDER_ROW_RESERVED.ORDER_WRK_ROW_ID
                    WHERE  ORDER_ROW_RESERVED.ORDER_WRK_ROW_ID IS NULL
                    OR  (INVOICE_ID IS NULL AND SHIP_ID IS NULL)
                    OR  (
                            (INVOICE_ID IS NOT NULL OR SHIP_ID IS NOT NULL)
                            AND ORDER_ROW_RESERVED.ORDER_WRK_ROW_ID IS NOT NULL
                            AND XXX.ORDER_WRK_ROW_ID IS NOT NULL
                        )
                    GROUP BY
                    STOCK_ID,
                    PRODUCT_ID,
                    SPECT_VAR_ID,
                    ORDER_ID,
                    ORDER_ROW_RESERVED.ORDER_WRK_ROW_ID,
                    STOCK_STRATEGY_ID

CREATE VIEW [@_dsn_company_@].[PRODUCT_UNIT] AS
                    SELECT     
                        [@_dsn_product_@].PRODUCT_UNIT.PRODUCT_UNIT_ID,
                        [@_dsn_product_@].PRODUCT_UNIT.PRODUCT_UNIT_STATUS,
                        [@_dsn_product_@].PRODUCT_UNIT.PRODUCT_ID,
                        [@_dsn_product_@].PRODUCT_UNIT.MAIN_UNIT_ID,
                        [@_dsn_product_@].PRODUCT_UNIT.MAIN_UNIT,
                        [@_dsn_product_@].PRODUCT_UNIT.UNIT_ID,
                        [@_dsn_product_@].PRODUCT_UNIT.ADD_UNIT,
                        [@_dsn_product_@].PRODUCT_UNIT.MULTIPLIER,
                        [@_dsn_product_@].PRODUCT_UNIT.DIMENTION,
                        [@_dsn_product_@].PRODUCT_UNIT.DESI_VALUE,
                        [@_dsn_product_@].PRODUCT_UNIT.WEIGHT,
                        [@_dsn_product_@].PRODUCT_UNIT.IS_MAIN,
                        [@_dsn_product_@].PRODUCT_UNIT.IS_SHIP_UNIT,
                        [@_dsn_product_@].PRODUCT_UNIT.UNIT_MULTIPLIER,
                        [@_dsn_product_@].PRODUCT_UNIT.UNIT_MULTIPLIER_STATIC,
                        [@_dsn_product_@].PRODUCT_UNIT.VOLUME,
                        [@_dsn_product_@].PRODUCT_UNIT.RECORD_DATE,
                        [@_dsn_product_@].PRODUCT_UNIT.RECORD_EMP,
                        [@_dsn_product_@].PRODUCT_UNIT.UPDATE_DATE,
                        [@_dsn_product_@].PRODUCT_UNIT.UPDATE_EMP,
                        [@_dsn_product_@].PRODUCT_UNIT.IS_ADD_UNIT,
                        [@_dsn_product_@].PRODUCT_UNIT.QUANTITY,
                        [@_dsn_product_@].PRODUCT_UNIT.PACKAGES,
                        [@_dsn_product_@].PRODUCT_UNIT.PATH,
                        [@_dsn_product_@].PRODUCT_UNIT.PACKAGE_CONTROL_TYPE,
                        [@_dsn_product_@].PRODUCT_UNIT.INSTRUCTION
                    FROM
                        [@_dsn_product_@].PRODUCT,
                        [@_dsn_product_@].PRODUCT_UNIT,
                        [@_dsn_product_@].PRODUCT_OUR_COMPANY
                    WHERE
                        [@_dsn_product_@].PRODUCT_OUR_COMPANY.OUR_COMPANY_ID = @_companyid_@ AND 
                        [@_dsn_product_@].PRODUCT.PRODUCT_ID = [@_dsn_product_@].PRODUCT_OUR_COMPANY.PRODUCT_ID AND
                        [@_dsn_product_@].PRODUCT.PRODUCT_ID = [@_dsn_product_@].PRODUCT_UNIT.PRODUCT_ID

CREATE VIEW [@_dsn_company_@].[STOCKS] AS			 
                    SELECT
                        STOCKS.STOCK_ID,
                        STOCKS.STOCK_CODE,
                        STOCKS.STOCK_CODE_2,
                        STOCKS.PRODUCT_ID,
                        STOCKS.PROPERTY,
                        STOCKS.BARCOD,
                        STOCKS.PRODUCT_UNIT_ID,
                        STOCKS.MANUFACT_CODE,
                        STOCKS.STOCK_STATUS,
                        STOCKS.RECORD_EMP,
                        STOCKS.RECORD_IP,
                        STOCKS.RECORD_DATE,
                        STOCKS.UPDATE_EMP,
                        STOCKS.UPDATE_IP,
                        STOCKS.UPDATE_DATE,
                        STOCKS.SERIAL_BARCOD,
                        STOCKS.COUNTER_MULTIPLIER,
                        PRODUCT.PRODUCT_STATUS,
                        PRODUCT.PRODUCT_NAME,
                        PRODUCT.PRODUCT_CODE,
                        PRODUCT.PRODUCT_CODE_2,
                        PRODUCT.BARCOD AS PRODUCT_BARCOD,
                        ISNULL((SELECT PT.TAX FROM PRODUCT_TAX PT WHERE PT.PRODUCT_ID = [@_dsn_product_@].PRODUCT.PRODUCT_ID AND PT.OUR_COMPANY_ID = @_companyid_@),[@_dsn_product_@].PRODUCT.TAX) TAX,
                        ISNULL((SELECT PT.OTV FROM PRODUCT_TAX PT WHERE PT.PRODUCT_ID = [@_dsn_product_@].PRODUCT.PRODUCT_ID AND PT.OUR_COMPANY_ID = @_companyid_@),[@_dsn_product_@].PRODUCT.OTV) OTV,
                        ISNULL((SELECT PT.TAX_PURCHASE FROM PRODUCT_TAX PT WHERE PT.PRODUCT_ID = [@_dsn_product_@].PRODUCT.PRODUCT_ID AND PT.OUR_COMPANY_ID = @_companyid_@),[@_dsn_product_@].PRODUCT.TAX_PURCHASE) TAX_PURCHASE,
                        PRODUCT.COMPANY_ID,
                        PRODUCT.BRAND_ID,
                        PRODUCT.PRODUCT_MANAGER,
                        PRODUCT.PRODUCT_CATID,
                        PRODUCT.IS_INVENTORY,
                        PRODUCT.IS_PRODUCTION,
                        PRODUCT.IS_SALES,
                        PRODUCT.IS_PURCHASE,
                        PRODUCT.IS_TERAZI,
                        PRODUCT.IS_SERIAL_NO,
                        PRODUCT.IS_KARMA,
                        PRODUCT.PRODUCT_DETAIL,
                        PRODUCT.IS_PROTOTYPE,
                        PRODUCT.IS_INTERNET,
                        PRODUCT.IS_COST,
                        PRODUCT.IS_QUALITY,
                        PRODUCT.IS_ZERO_STOCK,
                        PRODUCT.IS_LIMITED_STOCK,
                        PRODUCT.PRODUCT_DETAIL2,
                        PRODUCT.SHORT_CODE_ID,
                        PRODUCT.IS_COMMISSION,
                        PRODUCT.USER_FRIENDLY_URL,
                        PRODUCT.SEGMENT_ID,
                        PRODUCT.MIN_MARGIN,
                        PRODUCT.MAX_MARGIN,
                        PRODUCT.SHELF_LIFE,
                        PRODUCT.PACKAGE_CONTROL_TYPE,
                        PRODUCT.IS_EXTRANET,
                        PRODUCT.IS_LOT_NO
                    FROM   
                        [@_dsn_product_@].PRODUCT,
                        [@_dsn_product_@].STOCKS,
                        [@_dsn_product_@].PRODUCT_OUR_COMPANY
                    WHERE     
                            ([@_dsn_product_@].PRODUCT_OUR_COMPANY.OUR_COMPANY_ID = @_companyid_@) AND
                            [@_dsn_product_@].PRODUCT.PRODUCT_ID = [@_dsn_product_@].PRODUCT_OUR_COMPANY.PRODUCT_ID AND
                            [@_dsn_product_@].STOCKS.PRODUCT_ID = [@_dsn_product_@].PRODUCT.PRODUCT_ID

CREATE VIEW [@_dsn_company_@].[GET_STOCK_RESERVED_ROW] AS
                    SELECT
                        SUM( ((RESERVE_STOCK_OUT) - (STOCK_OUT) ) *   PU.MULTIPLIER ) AS  STOCK_AZALT,
                        0 AS STOCK_ARTIR,			
                        S.PRODUCT_ID,
                        S.STOCK_ID,
                        S.STOCK_CODE,
                        S.PROPERTY,
                        S.BARCOD, 
                        PU.MAIN_UNIT,
                        ORDS.ORDER_ID
                    FROM
                        [@_dsn_product_@].STOCKS S 
                        JOIN  GET_ORDER_ROW_RESERVED ORR ON S.STOCK_ID =  ORR.STOCK_ID
                        JOIN ORDERS ORDS ON ORDS.ORDER_ID =ORR.ORDER_ID	
                        JOIN [@_dsn_product_@].PRODUCT_UNIT PU ON S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID
                        
                    WHERE
                        ORDS.RESERVED = 1 AND
                        ORDS.ORDER_STATUS = 1 AND
                        (
                            (ORDS.PURCHASE_SALES=1 AND ORDS.ORDER_ZONE=0 )
                            OR (ORDS.PURCHASE_SALES=0 AND ORDS.ORDER_ZONE=1 )
                        )AND
                        (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0
                    GROUP BY
                        S.PRODUCT_ID,
                        S.STOCK_ID,
                        S.STOCK_CODE,
                        S.PROPERTY,
                        S.BARCOD, 
                        PU.MAIN_UNIT,
                        ORDS.ORDER_ID 
                    UNION 
                        SELECT
                            0 AS STOCK_AZALT,	
                            SUM(  ((RESERVE_STOCK_IN) - (STOCK_IN) ) *   PU.MULTIPLIER  ) AS STOCK_ARTIR,
                            S.PRODUCT_ID,
                            S.STOCK_ID,
                            S.STOCK_CODE,
                            S.PROPERTY,
                            S.BARCOD, 
                            PU.MAIN_UNIT,
                            ORDS.ORDER_ID
                        FROM
                            [@_dsn_product_@].STOCKS S 
                            JOIN  GET_ORDER_ROW_RESERVED ORR ON S.STOCK_ID =  ORR.STOCK_ID
                            JOIN ORDERS ORDS ON ORDS.ORDER_ID =ORR.ORDER_ID	
                            JOIN [@_dsn_product_@].PRODUCT_UNIT PU ON S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID
                           
                            JOIN [@_dsn_main_@].STOCKS_LOCATION SL ON  ORDS.DELIVER_DEPT_ID =SL.DEPARTMENT_ID AND ORDS.LOCATION_ID=SL.LOCATION_ID 
                        WHERE
                            ORR.STOCK_ID = S.STOCK_ID AND 
                            ORDS.RESERVED = 1 AND
                            ORDS.ORDER_STATUS = 1 AND
                            ORR.ORDER_ID = ORDS.ORDER_ID AND		
                            ORDS.PURCHASE_SALES=0 AND
                            ORDS.ORDER_ZONE=0 AND
                            ORDS.DELIVER_DEPT_ID IS NOT NULL AND 
                            SL.NO_SALE = 0 AND
                            (ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0
                        GROUP BY
                            S.PRODUCT_ID,
                            S.STOCK_ID,
                            S.STOCK_CODE,
                            S.PROPERTY,
                            S.BARCOD,
                            PU.MAIN_UNIT,
                            ORDS.ORDER_ID
                    UNION
                        SELECT
                            SUM((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT) * PU.MULTIPLIER) AS STOCK_AZALT,
                            SUM((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) * PU.MULTIPLIER) AS STOCK_ARTIR,
                            S.PRODUCT_ID,
                            S.STOCK_ID,
                            S.STOCK_CODE,
                            S.PROPERTY,
                            S.BARCOD, 
                            PU.MAIN_UNIT,
                            0 ORDER_ID
                         FROM
                            STOCKS S,
                            GET_ORDER_ROW_RESERVED ORR, 
                            PRODUCT_UNIT PU
                         WHERE
                            ORR.STOCK_ID=S.STOCK_ID AND
                            ORR.ORDER_ID IS NULL AND
                            S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                            ((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0 OR (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0 )
                         GROUP BY
                            S.PRODUCT_ID,
                            S.STOCK_ID,
                            S.STOCK_CODE,
                            S.PROPERTY,
                            S.BARCOD, 
                            PU.MAIN_UNIT

CREATE VIEW [@_dsn_company_@].[GET_STOCK_RESERVED] AS
                        SELECT 
                            SUM(STOCK_AZALT) AS STOCK_AZALT,
                            SUM(STOCK_ARTIR) AS STOCK_ARTIR,
                            PRODUCT_ID,
                            STOCK_ID,
                            STOCK_CODE,
                            PROPERTY,
                            BARCOD,
                            MAIN_UNIT
                        FROM 
                            GET_STOCK_RESERVED_ROW
                        GROUP BY 
                            PRODUCT_ID,
                            STOCK_ID,
                            STOCK_CODE,
                            PROPERTY,
                            BARCOD,
                            MAIN_UNIT

CREATE VIEW [@_dsn_company_@].[GET_ORDER_ROW_RESERVED_LOCATION] AS
                        SELECT STOCK_ID,
                               PRODUCT_ID,
                               SPECT_VAR_ID,
                               ORDER_ID,
                               STOCK_STRATEGY_ID,
                               LOCATION_ID,
                               DEPARTMENT_ID,
                               SUM(RESERVE_STOCK_IN)      RESERVE_STOCK_IN,
                               SUM(RESERVE_STOCK_OUT)     RESERVE_STOCK_OUT,
                               SUM(STOCK_IN)              STOCK_IN,
                               SUM(STOCK_OUT)             STOCK_OUT
                        FROM   ORDER_ROW_RESERVED
                               LEFT JOIN (
                                        SELECT ORDER_WRK_ROW_ID,
                                               COUNT(ROW_RESERVED_ID) AS SAYAC
                                        FROM   ORDER_ROW_RESERVED
                                        GROUP BY
                                               ORDER_WRK_ROW_ID
                                        HAVING COUNT(ROW_RESERVED_ID) > 1
                                    )                  AS XXX
                                    ON  XXX.ORDER_WRK_ROW_ID = ORDER_ROW_RESERVED.ORDER_WRK_ROW_ID
                        WHERE  ORDER_ROW_RESERVED.ORDER_WRK_ROW_ID IS NULL
                               OR  (INVOICE_ID IS NULL AND SHIP_ID IS NULL)
                               OR  (
                                       (INVOICE_ID IS NOT NULL OR SHIP_ID IS NOT NULL)
                                       AND ORDER_ROW_RESERVED.ORDER_WRK_ROW_ID IS NOT NULL
                                       AND XXX.ORDER_WRK_ROW_ID IS NOT NULL
                                   )
                        GROUP BY
                               STOCK_ID,
                               PRODUCT_ID,
                               SPECT_VAR_ID,
                               ORDER_ID,
                               STOCK_STRATEGY_ID,
                               LOCATION_ID,
                               DEPARTMENT_ID

CREATE VIEW [@_dsn_company_@].[GET_STOCK_RESERVED_ROW_LOCATION] AS
                        SELECT
                            SUM((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT) * PU.MULTIPLIER) AS STOCK_AZALT,
                            0 AS STOCK_ARTIR,			
                            S.PRODUCT_ID,
                            S.STOCK_ID,
                            S.STOCK_CODE,
                            S.PROPERTY,
                            S.BARCOD, 
                            PU.MAIN_UNIT,
                            ORDS.ORDER_ID,
                            ISNULL(ORR.DEPARTMENT_ID,ORDS.DELIVER_DEPT_ID) AS DEPARTMENT_ID,
                            ISNULL(ORR.LOCATION_ID,ORDS.LOCATION_ID) AS LOCATION_ID
                         FROM
                            STOCKS S,
                            GET_ORDER_ROW_RESERVED_LOCATION ORR, 
                            ORDERS ORDS,		
                            PRODUCT_UNIT PU
                         WHERE
                            ORR.STOCK_ID = S.STOCK_ID AND 
                            ORDS.RESERVED = 1 AND
                            ORDS.ORDER_STATUS = 1 AND
                            ORR.ORDER_ID = ORDS.ORDER_ID AND
                            (
                                (ORDS.PURCHASE_SALES=1 AND ORDS.ORDER_ZONE=0 )
                                OR (ORDS.PURCHASE_SALES=0 AND ORDS.ORDER_ZONE=1 )
                            )AND
                            S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                            (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0
                         GROUP BY
                            S.PRODUCT_ID,
                            S.STOCK_ID,
                            S.STOCK_CODE,
                            S.PROPERTY,
                            S.BARCOD,
                            PU.MAIN_UNIT,
                            ORDS.ORDER_ID,
                            ORDS.DELIVER_DEPT_ID,
                            ORDS.LOCATION_ID,
                            ORR.DEPARTMENT_ID,
                            ORR.LOCATION_ID
                        UNION
                        SELECT
                            0 AS STOCK_AZALT,
                            SUM((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) * PU.MULTIPLIER) AS STOCK_ARTIR,			
                            S.PRODUCT_ID,
                            S.STOCK_ID,
                            S.STOCK_CODE,
                            S.PROPERTY,
                            S.BARCOD, 
                            PU.MAIN_UNIT,
                            ORDS.ORDER_ID,
                            ISNULL(ORR.DEPARTMENT_ID,ORDS.DELIVER_DEPT_ID) AS DEPARTMENT_ID,
                            ISNULL(ORR.LOCATION_ID,ORDS.LOCATION_ID) AS LOCATION_ID
                         FROM
                            STOCKS S,
                            GET_ORDER_ROW_RESERVED_LOCATION ORR, 
                            ORDERS ORDS,
                            [@_dsn_main_@].STOCKS_LOCATION SL,	
                            PRODUCT_UNIT PU
                         WHERE
                            ORR.STOCK_ID = S.STOCK_ID AND 
                            ORDS.RESERVED = 1 AND
                            ORDS.ORDER_STATUS = 1 AND
                            ORR.ORDER_ID = ORDS.ORDER_ID AND		
                            ORDS.PURCHASE_SALES=0 AND
                            ORDS.ORDER_ZONE=0 AND
                            ORDS.DELIVER_DEPT_ID =SL.DEPARTMENT_ID AND
                            ORDS.LOCATION_ID=SL.LOCATION_ID AND
                            ORDS.DELIVER_DEPT_ID IS NOT NULL AND 
                            SL.NO_SALE = 0 AND
                            S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                            (ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0
                         GROUP BY
                            S.PRODUCT_ID,
                            S.STOCK_ID,
                            S.STOCK_CODE,
                            S.PROPERTY,
                            S.BARCOD,
                            PU.MAIN_UNIT,
                            ORDS.ORDER_ID,
                            ORDS.DELIVER_DEPT_ID,
                            ORDS.LOCATION_ID,
                            ORR.DEPARTMENT_ID,
                            ORR.LOCATION_ID
                        UNION 
                        SELECT
                            SUM((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)* SR.AMOUNT_VALUE * PU.MULTIPLIER) AS STOCK_AZALT,
                            0 AS STOCK_ARTIR,
                            S.PRODUCT_ID,
                            S.STOCK_ID,
                            S.STOCK_CODE,
                            S.PROPERTY,
                            S.BARCOD, 
                            PU.MAIN_UNIT,
                            ORDS.ORDER_ID,
                            ISNULL(ORR.DEPARTMENT_ID,ORDS.DELIVER_DEPT_ID) AS DEPARTMENT_ID,
                            ISNULL(ORR.LOCATION_ID,ORDS.LOCATION_ID) AS LOCATION_ID
                         FROM
                            STOCKS S,
                            GET_ORDER_ROW_RESERVED_LOCATION ORR, 
                            ORDERS ORDS,
                            SPECTS_ROW SR,		
                            PRODUCT_UNIT PU
                         WHERE
                            SR.STOCK_ID = S.STOCK_ID AND 
                            ORR.SPECT_VAR_ID=SR.SPECT_ID AND
                            SR.IS_SEVK=1 AND
                            ORDS.RESERVED = 1 AND
                            ORDS.ORDER_STATUS = 1 AND
                            ORR.ORDER_ID = ORDS.ORDER_ID AND
                            (
                                (ORDS.PURCHASE_SALES=1 AND ORDS.ORDER_ZONE=0 )
                                OR (ORDS.PURCHASE_SALES=0 AND ORDS.ORDER_ZONE=1 )
                            )AND
                            S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                            (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0
                         GROUP BY
                            S.PRODUCT_ID,
                            S.STOCK_ID,
                            S.STOCK_CODE,
                            S.PROPERTY,
                            S.BARCOD, 
                            PU.MAIN_UNIT,
                            ORDS.ORDER_ID,
                            ORDS.DELIVER_DEPT_ID,
                            ORDS.LOCATION_ID,
                            ORR.DEPARTMENT_ID,
                            ORR.LOCATION_ID
                        UNION 	
                        SELECT
                            0 AS STOCK_AZALT,
                            SUM((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)* SR.AMOUNT_VALUE * PU.MULTIPLIER) AS STOCK_ARTIR,
                            S.PRODUCT_ID,
                            S.STOCK_ID,
                            S.STOCK_CODE,
                            S.PROPERTY,
                            S.BARCOD,
                            PU.MAIN_UNIT,
                            ORDS.ORDER_ID,
                            ISNULL(ORR.DEPARTMENT_ID,ORDS.DELIVER_DEPT_ID) AS DEPARTMENT_ID,
                            ISNULL(ORR.LOCATION_ID,ORDS.LOCATION_ID) AS LOCATION_ID
                         FROM
                            STOCKS S,
                            GET_ORDER_ROW_RESERVED_LOCATION ORR, 
                            ORDERS ORDS,
                            SPECTS_ROW SR,
                            [@_dsn_main_@].STOCKS_LOCATION SL,
                            PRODUCT_UNIT PU
                         WHERE
                            SR.STOCK_ID = S.STOCK_ID AND 
                            ORR.SPECT_VAR_ID=SR.SPECT_ID AND
                            SR.IS_SEVK=1 AND
                            ORDS.RESERVED = 1 AND
                            ORDS.ORDER_STATUS = 1 AND
                            ORR.ORDER_ID = ORDS.ORDER_ID AND
                            ORDS.PURCHASE_SALES=0 AND
                            ORDS.ORDER_ZONE=0 AND
                            ORDS.DELIVER_DEPT_ID =SL.DEPARTMENT_ID AND
                            ORDS.LOCATION_ID=SL.LOCATION_ID AND
                            ORDS.DELIVER_DEPT_ID IS NOT NULL AND 
                            SL.NO_SALE = 0  AND		
                            S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                            (ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0
                         GROUP BY
                            S.PRODUCT_ID,
                            S.STOCK_ID,
                            S.STOCK_CODE,
                            S.PROPERTY,
                            S.BARCOD, 
                            PU.MAIN_UNIT,
                            ORDS.ORDER_ID,
                            ORDS.DELIVER_DEPT_ID,
                            ORDS.LOCATION_ID,
                            ORR.DEPARTMENT_ID,
                            ORR.LOCATION_ID

CREATE VIEW [@_dsn_company_@].[PRODUCT] AS
                        SELECT      
                            PRODUCT.PRODUCT_ID,
                            PRODUCT_STATUS,
                            PRODUCT_CODE,
                            COMPANY_ID,
                            PRODUCT_CATID,
                            BARCOD,
                            PRODUCT_NAME,
                            PRODUCT_DETAIL,
                            PRODUCT_DETAIL2,
                            ISNULL((SELECT PT.TAX FROM PRODUCT_TAX PT WHERE PT.PRODUCT_ID = [@_dsn_product_@].PRODUCT.PRODUCT_ID AND PT.OUR_COMPANY_ID=1),[@_dsn_product_@].PRODUCT.TAX) TAX,
                            ISNULL((SELECT PT.TAX_PURCHASE FROM PRODUCT_TAX PT WHERE PT.PRODUCT_ID = [@_dsn_product_@].PRODUCT.PRODUCT_ID AND PT.OUR_COMPANY_ID=1),[@_dsn_product_@].PRODUCT.TAX_PURCHASE) TAX_PURCHASE,
                            IS_INVENTORY,
                            IS_PRODUCTION,
                            SHELF_LIFE,
                            IS_SALES,
                            IS_PURCHASE,
                            MANUFACT_CODE,
                            IS_PROTOTYPE,
                            PRODUCT_TREE_AMOUNT,
                            PRODUCT_MANAGER,
                            SEGMENT_ID,
                            IS_INTERNET,
                            PROD_COMPETITIVE,
                            PRODUCT_STAGE,
                            IS_TERAZI,
                            BRAND_ID,
                            IS_SERIAL_NO,
                            IS_ZERO_STOCK,
                            MIN_MARGIN,
                            MAX_MARGIN,
                            ISNULL((SELECT PT.OTV FROM PRODUCT_TAX PT WHERE PT.PRODUCT_ID = [@_dsn_product_@].PRODUCT.PRODUCT_ID AND PT.OUR_COMPANY_ID = @_companyid_@),[@_dsn_product_@].PRODUCT.OTV) OTV,
                            IS_KARMA,
                            PRODUCT_CODE_2,
                            SHORT_CODE,
                            IS_COST,
                            IS_QUALITY,
                            WORK_STOCK_ID,
                            WORK_STOCK_AMOUNT,
                            IS_EXTRANET,
                            IS_KARMA_SEVK,
                            RECORD_BRANCH_ID,
                            RECORD_MEMBER,
                            RECORD_DATE,
                            MEMBER_TYPE,
                            UPDATE_DATE,
                            UPDATE_EMP,
                            UPDATE_PAR,
                            UPDATE_IP,
                            USER_FRIENDLY_URL,
                            PACKAGE_CONTROL_TYPE,
                            IS_LIMITED_STOCK,
                            SHORT_CODE_ID,
                            IS_COMMISSION,
                            CUSTOMS_RECIPE_CODE,
                            IS_ADD_XML,
                            IS_GIFT_CARD,
                            GIFT_VALID_DAY,
                            REF_PRODUCT_CODE,
                            QUALITY_START_DATE,
                            IS_LOT_NO,
                            OTV_AMOUNT,
                            OIV,
                            BSMV,
                            ORIGIN_ID,
                            INSTRUCTION,
                            PRODUCT.WATALOGY_CAT_ID,
                            PRODUCT.PRODUCT_DETAIL_WATALOGY,
                            PRODUCT.IS_WATALOGY_INTEGRATED
                        FROM          
                            [@_dsn_product_@].PRODUCT,
                            [@_dsn_product_@].PRODUCT_OUR_COMPANY
                        WHERE     
                            ([@_dsn_product_@].PRODUCT_OUR_COMPANY.OUR_COMPANY_ID = @_companyid_@) AND
                            [@_dsn_product_@].PRODUCT.PRODUCT_ID = [@_dsn_product_@].PRODUCT_OUR_COMPANY.PRODUCT_ID

CREATE VIEW [@_dsn_company_@].[STOCKS_BARCODES] AS
                        SELECT     
                            [@_dsn_product_@]. STOCKS_BARCODES.STOCK_ID,
                            [@_dsn_product_@].STOCKS_BARCODES.BARCODE,
                            [@_dsn_product_@].STOCKS_BARCODES.UNIT_ID
                        FROM   
                            [@_dsn_product_@].PRODUCT,
                            [@_dsn_product_@].STOCKS_BARCODES,
                            [@_dsn_product_@].STOCKS,
                            [@_dsn_product_@].PRODUCT_OUR_COMPANY
                        WHERE     
                            ([@_dsn_product_@].PRODUCT_OUR_COMPANY.OUR_COMPANY_ID = @_companyid_@) AND
                            [@_dsn_product_@].PRODUCT.PRODUCT_ID = [@_dsn_product_@].PRODUCT_OUR_COMPANY.PRODUCT_ID AND
                            [@_dsn_product_@].STOCKS.PRODUCT_ID = [@_dsn_product_@].PRODUCT.PRODUCT_ID AND
                            [@_dsn_product_@].STOCKS_BARCODES.STOCK_ID = [@_dsn_product_@].STOCKS.STOCK_ID AND
                            LEN([@_dsn_product_@].STOCKS_BARCODES.BARCODE) >5

CREATE VIEW [@_dsn_company_@].[GET_STOCK_BARCODES_GENIUS] AS
                        (
                            (
                            SELECT
                                STOCKS.PRODUCT_ID,
                                STOCKS.STOCK_CODE,
                                STOCKS.PROPERTY,
                                STOCKS.STOCK_ID,
                                STOCKS.BARCOD AS BARCODE,
                                PRODUCT.PRODUCT_NAME,
                                PRODUCT_UNIT.MULTIPLIER,
                                PRODUCT_UNIT.ADD_UNIT
                            FROM
                                STOCKS,
                                PRODUCT,
                                PRODUCT_UNIT
                            WHERE
                                STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
                                PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID
                            )
                            
                            UNION
                            
                            (
                            SELECT
                                STOCKS.PRODUCT_ID,
                                STOCKS.STOCK_CODE,
                                STOCKS.PROPERTY,
                                STOCKS_BARCODES.STOCK_ID,
                                STOCKS_BARCODES.BARCODE,
                                PRODUCT.PRODUCT_NAME,
                                PRODUCT_UNIT.MULTIPLIER,
                                PRODUCT_UNIT.ADD_UNIT
                            FROM
                                STOCKS_BARCODES,
                                STOCKS,
                                PRODUCT,
                                PRODUCT_UNIT
                            WHERE
                                STOCKS.STOCK_ID = STOCKS_BARCODES.STOCK_ID AND
                                STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
                                PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID
                            )
                        )

CREATE VIEW [@_dsn_company_@].[GET_STOCK_RESERVED_SPECT] AS		
                        SELECT
                            SUM((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT) * PU.MULTIPLIER) AS STOCK_AZALT,
                            SUM((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) * PU.MULTIPLIER) AS STOCK_ARTIR,
                            S.PRODUCT_ID, 
                            S.STOCK_ID,
                            S.STOCK_CODE, 
                            S.PROPERTY, 
                            S.BARCOD, 
                            PU.MAIN_UNIT,
                            ORDS.ORDER_ID,
                            SP.SPECT_MAIN_ID
                        FROM
                            STOCKS S,
                            GET_ORDER_ROW_RESERVED ORR,
                            ORDERS ORDS,
                            PRODUCT_UNIT PU,
                            SPECTS SP
                        WHERE
                            ORR.STOCK_ID = S.STOCK_ID AND 
                            ORDS.RESERVED = 1 AND 
                            ORDS.ORDER_STATUS = 1 AND
                            ORR.ORDER_ID = ORDS.ORDER_ID AND
                            S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                            SP.SPECT_VAR_ID=ORR.SPECT_VAR_ID AND
                            ((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0 OR (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0 )
                        GROUP BY
                            S.PRODUCT_ID,
                            S.STOCK_ID,
                            S.STOCK_CODE,
                            S.PROPERTY,
                            S.BARCOD,
                            PU.MAIN_UNIT,
                            ORDS.ORDER_ID,
                            SP.SPECT_MAIN_ID
                        UNION
                        SELECT
                            SUM((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT) * PU.MULTIPLIER) AS STOCK_AZALT,
                            SUM((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) * PU.MULTIPLIER) AS STOCK_ARTIR,
                            S.PRODUCT_ID, 
                            S.STOCK_ID,
                            S.STOCK_CODE, 
                            S.PROPERTY, 
                            S.BARCOD, 
                            PU.MAIN_UNIT,
                            ORDS.ORDER_ID,
                            NULL
                        FROM
                            STOCKS S,
                            GET_ORDER_ROW_RESERVED ORR,
                            ORDERS ORDS,
                            PRODUCT_UNIT PU
                        WHERE
                            ORR.STOCK_ID = S.STOCK_ID AND 
                            ORDS.RESERVED = 1 AND 
                            ORDS.ORDER_STATUS = 1 AND
                            ORR.ORDER_ID = ORDS.ORDER_ID AND
                            S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                            ORR.SPECT_VAR_ID IS NULL AND
                            ((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0 OR (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0 )
                        GROUP BY
                            S.PRODUCT_ID,
                            S.STOCK_ID,
                            S.STOCK_CODE,
                            S.PROPERTY,
                            S.BARCOD,
                            PU.MAIN_UNIT,
                            ORDS.ORDER_ID
                        UNION 
                        SELECT
                            SUM((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)* SR.AMOUNT_VALUE * PU.MULTIPLIER) AS STOCK_AZALT,
                            SUM((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) *SR.AMOUNT_VALUE * PU.MULTIPLIER) AS STOCK_ARTIR,
                            S.PRODUCT_ID,
                            S.STOCK_ID,
                            S.STOCK_CODE,
                            S.PROPERTY,
                            S.BARCOD, 
                            PU.MAIN_UNIT,
                            ORDS.ORDER_ID,
                            NULL
                         FROM
                            STOCKS S,
                            GET_ORDER_ROW_RESERVED ORR, 
                            ORDERS ORDS,
                            SPECTS_ROW SR,
                            PRODUCT_UNIT PU
                         WHERE
                            SR.STOCK_ID = S.STOCK_ID AND 
                            ORR.SPECT_VAR_ID=SR.SPECT_ID AND
                            SR.IS_SEVK=1 AND
                            ORDS.RESERVED = 1 AND
                            ORDS.ORDER_STATUS = 1 AND
                            ORR.ORDER_ID = ORDS.ORDER_ID AND
                            S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                            ((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0 OR (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0 )
                         GROUP BY
                            S.PRODUCT_ID,
                            S.STOCK_ID,
                            S.STOCK_CODE,
                            S.PROPERTY,
                            S.BARCOD, 
                            PU.MAIN_UNIT,
                            ORDS.ORDER_ID

CREATE VIEW [@_dsn_company_@].[GET_PRODUCTION_RESERVED_SPECT] AS
                        SELECT
                            SUM(STOCK_ARTIR) AS STOCK_ARTIR,
                            SUM(STOCK_AZALT) AS STOCK_AZALT,
                            STOCK_ID,
                            PRODUCT_ID,
                            SPECT_MAIN_ID
                        FROM
                            (
                            SELECT
                                CASE WHEN SUM(STOCK_ARTIR) > 0 THEN SUM(STOCK_ARTIR) ELSE 0 END AS STOCK_ARTIR,
                                CASE WHEN SUM(STOCK_AZALT) > 0 THEN SUM(STOCK_AZALT) ELSE 0 END AS STOCK_AZALT,
                                S.STOCK_ID,
                                S.PRODUCT_ID,
                                T1.SPECT_MAIN_ID,
                                T1.P_ORDER_ID
                            FROM
                            (
                                SELECT 	
                                    (P_ORD.QUANTITY) AS STOCK_ARTIR,
                                    0 AS STOCK_AZALT,	
                                    P_ORD.STOCK_ID,
                                    P_ORD.SPEC_MAIN_ID SPECT_MAIN_ID,
                                    P_ORD.P_ORDER_ID
                                FROM
                                    PRODUCTION_ORDERS P_ORD
                                WHERE 
                                    P_ORD.IS_STOCK_RESERVED = 1 AND 
                                    P_ORD.IS_DEMONTAJ=0
                            UNION ALL
                                SELECT 	
                                    0 AS STOCK_ARTIR,
                                    (P_ORD.QUANTITY) AS STOCK_AZALT,	
                                    P_ORD.STOCK_ID, 
                                    POS.SPECT_MAIN_ID SPECT_MAIN_ID,
                                    P_ORD.P_ORDER_ID
                                FROM
                                    PRODUCTION_ORDERS P_ORD,
                                    PRODUCTION_ORDERS_STOCKS POS
                                WHERE 
                                    P_ORD.IS_STOCK_RESERVED = 1 AND 
                                    P_ORD.P_ORDER_ID=POS.P_ORDER_ID AND
                                    P_ORD.IS_DEMONTAJ=1 AND
                                    ISNULL(IS_FREE_AMOUNT,0) = 0
                            UNION ALL
                                SELECT
                                    0 AS STOCK_ARTIR,	
                                    POS.AMOUNT AS STOCK_AZALT,
                                    POS.STOCK_ID,
                                    POS.SPECT_MAIN_ID SPECT_MAIN_ID,
                                    PO.P_ORDER_ID
                                FROM
                                    PRODUCTION_ORDERS PO,
                                    PRODUCTION_ORDERS_STOCKS POS
                                WHERE
                                    PO.IS_STOCK_RESERVED=1 AND
                                    PO.P_ORDER_ID=POS.P_ORDER_ID AND
                    
                                    PO.IS_DEMONTAJ=0 AND
                                    POS.IS_SEVK <> 1 AND
                                    ISNULL(IS_FREE_AMOUNT,0) = 0
                            UNION ALL
                                SELECT
                                    POS.AMOUNT AS STOCK_ARTIR,	
                                    0 AS STOCK_AZALT,
                                    POS.STOCK_ID,
                                    POS.SPECT_MAIN_ID,
                                    PO.P_ORDER_ID
                                FROM
                                    PRODUCTION_ORDERS PO,
                                    PRODUCTION_ORDERS_STOCKS POS
                                WHERE
                                    PO.IS_STOCK_RESERVED=1 AND
                                    PO.P_ORDER_ID=POS.P_ORDER_ID AND
                                    PO.IS_DEMONTAJ = 1 AND
                                    POS.IS_SEVK <> 1 AND
                                    ISNULL(IS_FREE_AMOUNT,0) = 0
                            UNION ALL
                                SELECT 
                                    (P_ORD_R_R.AMOUNT)*-1 AS STOCK_ARTIR,
                                    0 AS STOCK_AZALT,
                                    P_ORD_R_R.STOCK_ID,
                                    P_ORD_R_R.SPEC_MAIN_ID SPECT_MAIN_ID,
                                    P_ORD.P_ORDER_ID
                                FROM
                                    PRODUCTION_ORDER_RESULTS P_ORD_R,
                                    PRODUCTION_ORDER_RESULTS_ROW P_ORD_R_R,
                                    PRODUCTION_ORDERS P_ORD,
                                    SPECT_MAIN SP
                                WHERE
                                    P_ORD.IS_STOCK_RESERVED=1 AND
                                    P_ORD.P_ORDER_ID = P_ORD_R.P_ORDER_ID AND
                                    P_ORD_R_R.PR_ORDER_ID=P_ORD_R.PR_ORDER_ID AND
                                    SP.SPECT_MAIN_ID=P_ORD_R_R.SPEC_MAIN_ID AND
                                    P_ORD_R_R.TYPE=1 AND
                                    P_ORD_R.IS_STOCK_FIS=1 AND
                                    ISNULL(P_ORD_R_R.IS_SEVKIYAT,0)<>1
                            UNION ALL
                                SELECT 
                                    0 AS STOCK_ARTIR,
                                    (P_ORD_R_R.AMOUNT)*-1 AS STOCK_AZALT,
                                    P_ORD_R_R.STOCK_ID,
                                    P_ORD_R_R.SPEC_MAIN_ID SPECT_MAIN_ID,
                                    P_ORD.P_ORDER_ID
                                FROM
                                    PRODUCTION_ORDER_RESULTS P_ORD_R,
                                    PRODUCTION_ORDER_RESULTS_ROW P_ORD_R_R,
                                    PRODUCTION_ORDERS P_ORD,
                                    SPECT_MAIN SP
                                WHERE
                                    P_ORD.IS_STOCK_RESERVED=1 AND
                                    P_ORD.P_ORDER_ID = P_ORD_R.P_ORDER_ID AND
                                    P_ORD_R_R.PR_ORDER_ID=P_ORD_R.PR_ORDER_ID AND
                                    SP.SPECT_MAIN_ID=P_ORD_R_R.SPEC_MAIN_ID AND
                                    P_ORD_R_R.TYPE IN(2,3) AND
                                    P_ORD_R.IS_STOCK_FIS=1 AND
                                    ISNULL(P_ORD_R_R.IS_SEVKIYAT,0)<>1
                            UNION ALL
                                SELECT 
                                    0 AS STOCK_ARTIR,
                                    (P_ORD_R_R.AMOUNT)*-1 AS STOCK_AZALT,
                                    P_ORD_R_R.STOCK_ID,
                                    P_ORD_R_R.SPEC_MAIN_ID SPECT_MAIN_ID,
                                    P_ORD.P_ORDER_ID
                                FROM
                                    PRODUCTION_ORDER_RESULTS P_ORD_R,
                                    PRODUCTION_ORDER_RESULTS_ROW P_ORD_R_R,
                                    PRODUCTION_ORDERS P_ORD
                                WHERE
                                    P_ORD.IS_STOCK_RESERVED=1 AND
                                    P_ORD.P_ORDER_ID = P_ORD_R.P_ORDER_ID AND
                                    P_ORD_R_R.PR_ORDER_ID=P_ORD_R.PR_ORDER_ID AND
                                    P_ORD_R_R.SPEC_MAIN_ID IS NULL AND
                                    P_ORD_R_R.TYPE IN(2,3) AND
                                    P_ORD_R.IS_STOCK_FIS=1 AND
                                    ISNULL(P_ORD_R_R.IS_SEVKIYAT,0)<>1
                            ) T1,
                                [@_dsn_product_@].STOCKS S
                            WHERE
                                S.STOCK_ID=T1.STOCK_ID
                            GROUP BY 
                                S.STOCK_ID,
                                S.PRODUCT_ID,
                                T1.SPECT_MAIN_ID,
                                T1.P_ORDER_ID
                        )T2
                    GROUP BY
                        STOCK_ID,
                        PRODUCT_ID,
                        SPECT_MAIN_ID

CREATE VIEW [@_dsn_company_@].[GET_STOCK_RESERVED_LAST_SPECT] AS
                        SELECT 
                            SUM(STOCK_ARTIR) AS STOCK_ARTIR,
                            SUM(STOCK_AZALT) AS STOCK_AZALT,
                            SUM(STOCK_ARTIR-STOCK_AZALT) AS FARK,
                            PRODUCT_ID,
                            STOCK_ID,
                            SPECT_MAIN_ID
                        FROM
                        (	 
                            SELECT
                                GSR.STOCK_ARTIR AS STOCK_ARTIR,
                                GSR.STOCK_AZALT AS STOCK_AZALT, 
                                GSR.PRODUCT_ID,
                                GSR.STOCK_ID,
                                GSR.SPECT_MAIN_ID
                            FROM
                                GET_STOCK_RESERVED_SPECT GSR
                            
                        UNION 
                                
                            SELECT
                                GPR.STOCK_ARTIR,
                                GPR.STOCK_AZALT,
                                GPR.PRODUCT_ID,
                                GPR.STOCK_ID,
                                GPR.SPECT_MAIN_ID
                            FROM
                                GET_PRODUCTION_RESERVED_SPECT GPR
                            )  AS TOTAL_RESERVE
                        
                        GROUP BY
                             PRODUCT_ID,
                             STOCK_ID,
                             SPECT_MAIN_ID

CREATE VIEW [@_dsn_company_@].[GET_STOCK_RESERVED_TRIGGER] AS
                        SELECT 
                            SUM(STOCK_AZALT) AS STOCK_AZALT,
                            SUM(STOCK_ARTIR) AS STOCK_ARTIR,
                            PRODUCT_ID,
                            STOCK_ID,
                            STOCK_CODE,
                            PROPERTY,
                            BARCOD,
                            MAIN_UNIT
                        FROM 
                        (
                            SELECT
                                SUM((ORR.RESERVE_OUT-ORR.STOCK_OUT) * PU.MULTIPLIER) AS STOCK_AZALT,
                                0 AS STOCK_ARTIR,			
                        
                                S.PRODUCT_ID,
                                S.STOCK_ID,
                                S.STOCK_CODE,
                                S.PROPERTY,
                                S.BARCOD, 
                                PU.MAIN_UNIT
                             FROM
                                STOCKS S,
                                ORDER_RESERVED_TOTAL ORR, 
                                PRODUCT_UNIT PU
                             WHERE
                                ORR.STOCK_ID = S.STOCK_ID AND			
                                S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                                (ORR.RESERVE_OUT-ORR.STOCK_OUT)>0
                             GROUP BY
                                S.PRODUCT_ID,
                                S.STOCK_ID,
                                S.STOCK_CODE,
                                S.PROPERTY,
                                S.BARCOD,
                                PU.MAIN_UNIT
                            UNION
                            SELECT
                                0 AS STOCK_AZALT,
                                SUM((ORR.RESERVE_IN-ORR.STOCK_IN) * PU.MULTIPLIER) AS STOCK_ARTIR,			
                                S.PRODUCT_ID,
                                S.STOCK_ID,
                                S.STOCK_CODE,
                                S.PROPERTY,
                                S.BARCOD, 
                                PU.MAIN_UNIT
                             FROM
                                STOCKS S,
                                ORDER_RESERVED_TOTAL ORR, 
                                ORDERS ORDS,
                                [@_dsn_main_@].STOCKS_LOCATION SL,	
                                PRODUCT_UNIT PU
                             WHERE
                                ORR.STOCK_ID = S.STOCK_ID AND 
                                ORR.DEPARTMENT_ID =SL.DEPARTMENT_ID AND
                                ORR.LOCATION_ID=SL.LOCATION_ID AND
                                ORR.DEPARTMENT_ID IS NOT NULL AND 
                                SL.NO_SALE = 0 AND
                                S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                                (ORR.RESERVE_IN-ORR.STOCK_IN)>0
                             GROUP BY
                                S.PRODUCT_ID,
                                S.STOCK_ID,
                                S.STOCK_CODE,
                                S.PROPERTY,
                                S.BARCOD,
                                PU.MAIN_UNIT
                            UNION 
                            SELECT
                                SUM((ORR.RESERVE_OUT-ORR.STOCK_OUT)* SR.AMOUNT_VALUE * PU.MULTIPLIER) AS STOCK_AZALT,
                                0 AS STOCK_ARTIR,
                                S.PRODUCT_ID,
                                S.STOCK_ID,
                                S.STOCK_CODE,
                                S.PROPERTY,
                                S.BARCOD, 
                                PU.MAIN_UNIT
                             FROM
                                STOCKS S,
                                ORDER_RESERVED_TOTAL ORR,
                                SPECTS_ROW SR,		
                                PRODUCT_UNIT PU
                             WHERE
                                SR.STOCK_ID = S.STOCK_ID AND 
                                ORR.SPECT_VAR_ID=SR.SPECT_ID AND
                                SR.IS_SEVK=1 AND
                                S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                                (ORR.RESERVE_OUT-ORR.STOCK_OUT)>0
                             GROUP BY
                                S.PRODUCT_ID,
                                S.STOCK_ID,
                                S.STOCK_CODE,
                                S.PROPERTY,
                                S.BARCOD, 
                                PU.MAIN_UNIT
                            UNION 	
                            SELECT
                                0 AS STOCK_AZALT,
                                SUM((ORR.RESERVE_IN-ORR.STOCK_IN)* SR.AMOUNT_VALUE * PU.MULTIPLIER) AS STOCK_ARTIR,
                                S.PRODUCT_ID,
                                S.STOCK_ID,
                                S.STOCK_CODE,
                                S.PROPERTY,
                                S.BARCOD, 
                                PU.MAIN_UNIT
                             FROM
                                STOCKS S,
                                ORDER_RESERVED_TOTAL ORR,
                                SPECTS_ROW SR,
                                [@_dsn_main_@].STOCKS_LOCATION SL,
                                PRODUCT_UNIT PU
                             WHERE
                                SR.STOCK_ID = S.STOCK_ID AND 
                                ORR.SPECT_VAR_ID=SR.SPECT_ID AND
                                SR.IS_SEVK=1 AND
                        
                                ORR.DEPARTMENT_ID =SL.DEPARTMENT_ID AND
                                ORR.LOCATION_ID=SL.LOCATION_ID AND
                                ORR.DEPARTMENT_ID IS NOT NULL AND 
                                SL.NO_SALE = 0  AND		
                                S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                                (ORR.RESERVE_IN-ORR.STOCK_IN)>0
                             GROUP BY
                                S.PRODUCT_ID,
                                S.STOCK_ID,
                                S.STOCK_CODE,
                                S.PROPERTY,
                                S.BARCOD, 
                                PU.MAIN_UNIT	
                            ) AS GET_STOCK_RESERVED_ROW
                        GROUP BY 
                            PRODUCT_ID,
                            STOCK_ID,
                            STOCK_CODE,
                            PROPERTY,
                            BARCOD,
                            MAIN_UNIT

CREATE VIEW [@_dsn_company_@].[PRICE_STANDART] AS
                        SELECT      
                            [@_dsn_product_@].PRICE_STANDART.*
                        FROM   
                            [@_dsn_product_@].PRODUCT,
                            [@_dsn_product_@].PRICE_STANDART,
                            [@_dsn_product_@].PRODUCT_OUR_COMPANY
                        WHERE     
                            ([@_dsn_product_@].PRODUCT_OUR_COMPANY.OUR_COMPANY_ID = @_companyid_@) AND
                            [@_dsn_product_@].PRODUCT.PRODUCT_ID = [@_dsn_product_@].PRODUCT_OUR_COMPANY.PRODUCT_ID AND
                            [@_dsn_product_@].PRICE_STANDART.PRODUCT_ID = [@_dsn_product_@].PRODUCT.PRODUCT_ID

CREATE VIEW [@_dsn_company_@].[PRICE_STANDART_DISCOUNT] AS
                        SELECT
                            PS.PRODUCT_ID,
                            (
                            SELECT TOP 1 ((((((((((((PS.PRICE - ISNULL(PC.DISCOUNT_CASH,0)) * (100-ISNULL(PC.DISCOUNT1,0))/100)* (100-ISNULL(PC.DISCOUNT2,0))/100)* (100-ISNULL(PC.DISCOUNT3,0))/100)* (100-ISNULL(PC.DISCOUNT4,0))/100)* (100-ISNULL(PC.DISCOUNT5,0))/100)* (100-ISNULL(PC.DISCOUNT6,0))/100)* (100-ISNULL(PC.DISCOUNT7,0))/100)*(100-ISNULL(PC.DISCOUNT8,0))/100)*(100-ISNULL(PC.DISCOUNT9,0))/100)*(100-ISNULL(PC.DISCOUNT10,0))/100))
                            FROM 
                                CONTRACT_PURCHASE_PROD_DISCOUNT PC
                            WHERE
                                PC.PRODUCT_ID=PS.PRODUCT_ID AND
                                (PC.FINISH_DATE >= PS.START_DATE OR PC.FINISH_DATE IS NULL)
                            ORDER BY PC.START_DATE DESC
                            ) NET_PRICE,
                            (
                            SELECT TOP 1 ((((((((((((PS.PRICE - ISNULL(PC.DISCOUNT_CASH,0)) * (100-ISNULL(PC.DISCOUNT1,0))/100)* (100-ISNULL(PC.DISCOUNT2,0))/100)* (100-ISNULL(PC.DISCOUNT3,0))/100)* (100-ISNULL(PC.DISCOUNT4,0))/100)* (100-ISNULL(PC.DISCOUNT5,0))/100)* (100-ISNULL(PC.DISCOUNT6,0))/100)* (100-ISNULL(PC.DISCOUNT7,0))/100)*(100-ISNULL(PC.DISCOUNT8,0))/100)*(100-ISNULL(PC.DISCOUNT9,0))/100)*(100-ISNULL(PC.DISCOUNT10,0))/100))
                            FROM 
                                CONTRACT_PURCHASE_PROD_DISCOUNT PC
                            WHERE
                                PC.PRODUCT_ID=PS.PRODUCT_ID AND
                                (PC.FINISH_DATE >= PS.START_DATE OR PC.FINISH_DATE IS NULL)
                            ORDER BY PC.START_DATE DESC
                            )*(100+P.TAX_PURCHASE)/100 NET_PRICE_KDV,
                            PS.PRICE PRICE ,
                            PS.PRICE_KDV PRICE_KDV,
                            PS.MONEY MONEY,
                            PU.ADD_UNIT ADD_UNIT,
                            PU.MAIN_UNIT MAIN_UNIT
                        FROM
                            PRODUCT P,
                            PRICE_STANDART PS,
                            PRODUCT_UNIT PU
                        WHERE
                            P.PRODUCT_ID=PS.PRODUCT_ID AND
                            PS.PURCHASESALES = 0 AND
                            PS.PRICESTANDART_STATUS = 1 AND	
                            PS.UNIT_ID = PU.PRODUCT_UNIT_ID AND
                            PU.IS_MAIN=1

CREATE VIEW [@_dsn_company_@].[DAILY_INVENTORIES] AS 
                        SELECT 
                            SUM(LAST_INVENTORY_VALUE) LAST_INVENTORY_VALUE,
                            SUM(LAST_INVENTORY_VALUE_2) LAST_INVENTORY_VALUE_2,
                            ENTRY_DATE
                        FROM
                            (
                                SELECT
                                    SUM(LAST_INVENTORY_VALUE*QUANTITY) LAST_INVENTORY_VALUE,
                                    SUM(LAST_INVENTORY_VALUE_2*QUANTITY) LAST_INVENTORY_VALUE_2,
                                    ENTRY_DATE
                                FROM
                                    INVENTORY
                                GROUP BY ENTRY_DATE
                            ) AS INVENTORY_VALUE
                        GROUP BY
                            ENTRY_DATE

CREATE VIEW [@_dsn_company_@].[DAILY_TOTAL_INVENTORIES] AS
                    SELECT 
                        D1.ENTRY_DATE,
                        SUM(D2.LAST_INVENTORY_VALUE) LAST_INVENTORY_VALUE,
                        SUM(D2.LAST_INVENTORY_VALUE_2) LAST_INVENTORY_VALUE_2
                    FROM
                        DAILY_INVENTORIES D1,
                        DAILY_INVENTORIES D2
                    WHERE
                        D1.ENTRY_DATE >= D2.ENTRY_DATE
                    GROUP BY
                        D1.ENTRY_DATE

CREATE VIEW [@_dsn_company_@].[PRODUCT_COST] AS
                        SELECT      
                            [@_dsn_product_@].PRODUCT_COST.PRODUCT_COST_ID,
                            [@_dsn_product_@].PRODUCT_COST.PROCESS_STAGE,
                            [@_dsn_product_@].PRODUCT_COST.PRODUCT_ID,
                            [@_dsn_product_@].PRODUCT_COST.UNIT_ID,
                            [@_dsn_product_@].PRODUCT_COST.IS_SPEC,
                            [@_dsn_product_@].PRODUCT_COST.SPECT_MAIN_ID,
                            [@_dsn_product_@].PRODUCT_COST.PRODUCT_COST_STATUS,
                            [@_dsn_product_@].PRODUCT_COST.INVENTORY_CALC_TYPE,
                            [@_dsn_product_@].PRODUCT_COST.START_DATE,
                            [@_dsn_product_@].PRODUCT_COST.COST_TYPE_ID,
                            [@_dsn_product_@].PRODUCT_COST.PRODUCT_COST,
                            [@_dsn_product_@].PRODUCT_COST.MONEY,
                            [@_dsn_product_@].PRODUCT_COST.STANDARD_COST,
                            [@_dsn_product_@].PRODUCT_COST.STANDARD_COST_MONEY,
                            [@_dsn_product_@].PRODUCT_COST.STANDARD_COST_RATE,
                            [@_dsn_product_@].PRODUCT_COST.PURCHASE_NET,
                            [@_dsn_product_@].PRODUCT_COST.PURCHASE_NET_MONEY,
                            [@_dsn_product_@].PRODUCT_COST.PURCHASE_EXTRA_COST,
                            [@_dsn_product_@].PRODUCT_COST.PRICE_PROTECTION,
                            [@_dsn_product_@].PRODUCT_COST.PRICE_PROTECTION_MONEY,
                            [@_dsn_product_@].PRODUCT_COST.PRICE_PROTECTION_TYPE,
                            [@_dsn_product_@].PRODUCT_COST.PURCHASE_NET_SYSTEM,
                            [@_dsn_product_@].PRODUCT_COST.PURCHASE_NET_SYSTEM_MONEY,
                            [@_dsn_product_@].PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM,
                            [@_dsn_product_@].PRODUCT_COST.PRODUCT_COST_SYSTEM,
                            [@_dsn_product_@].PRODUCT_COST.PURCHASE_NET_SYSTEM_2,
                            [@_dsn_product_@].PRODUCT_COST.PURCHASE_NET_SYSTEM_MONEY_2,
                            [@_dsn_product_@].PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM_2,
                            [@_dsn_product_@].PRODUCT_COST.AVAILABLE_STOCK,
                            [@_dsn_product_@].PRODUCT_COST.PARTNER_STOCK,
                            [@_dsn_product_@].PRODUCT_COST.ACTIVE_STOCK,
                            [@_dsn_product_@].PRODUCT_COST.IS_STANDARD_COST,
                            [@_dsn_product_@].PRODUCT_COST.IS_ACTIVE_STOCK,
                            [@_dsn_product_@].PRODUCT_COST.IS_PARTNER_STOCK,
                            [@_dsn_product_@].PRODUCT_COST.COST_DESCRIPTION,
                            [@_dsn_product_@].PRODUCT_COST.ACTION_PROCESS_TYPE,
                            [@_dsn_product_@].PRODUCT_COST.ACTION_PROCESS_CAT_ID,
                            [@_dsn_product_@].PRODUCT_COST.ACTION_ID,
                            [@_dsn_product_@].PRODUCT_COST.ACTION_ROW_ID,
                            [@_dsn_product_@].PRODUCT_COST.ACTION_ROW_PRICE,
                            [@_dsn_product_@].PRODUCT_COST.ACTION_TYPE,
                            [@_dsn_product_@].PRODUCT_COST.ACTION_PERIOD_ID,
                            [@_dsn_product_@].PRODUCT_COST.ACTION_AMOUNT,
                            [@_dsn_product_@].PRODUCT_COST.ACTION_DATE,
                            [@_dsn_product_@].PRODUCT_COST.ACTION_DUE_DATE,
                            [@_dsn_product_@].PRODUCT_COST.DEPARTMENT_ID,
                            [@_dsn_product_@].PRODUCT_COST.LOCATION_ID,
                            [@_dsn_product_@].PRODUCT_COST.PRODUCT_COST_LOCATION,
                            [@_dsn_product_@].PRODUCT_COST.MONEY_LOCATION,
                            [@_dsn_product_@].PRODUCT_COST.STANDARD_COST_LOCATION,
                            [@_dsn_product_@].PRODUCT_COST.STANDARD_COST_MONEY_LOCATION,
                            [@_dsn_product_@].PRODUCT_COST.STANDARD_COST_RATE_LOCATION,
                            [@_dsn_product_@].PRODUCT_COST.PURCHASE_NET_LOCATION,
                            [@_dsn_product_@].PRODUCT_COST.PURCHASE_NET_MONEY_LOCATION,
                            [@_dsn_product_@].PRODUCT_COST.PURCHASE_EXTRA_COST_LOCATION,
                            [@_dsn_product_@].PRODUCT_COST.PRICE_PROTECTION_LOCATION,
                            [@_dsn_product_@].PRODUCT_COST.PRICE_PROTECTION_MONEY_LOCATION,
                            [@_dsn_product_@].PRODUCT_COST.PURCHASE_NET_SYSTEM_LOCATION,
                            [@_dsn_product_@].PRODUCT_COST.PURCHASE_NET_SYSTEM_MONEY_LOCATION,
                            [@_dsn_product_@].PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM_LOCATION,
                            [@_dsn_product_@].PRODUCT_COST.PURCHASE_NET_SYSTEM_2_LOCATION,
                            [@_dsn_product_@].PRODUCT_COST.PURCHASE_NET_SYSTEM_MONEY_2_LOCATION,
                            [@_dsn_product_@].PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION,
                            [@_dsn_product_@].PRODUCT_COST.AVAILABLE_STOCK_LOCATION,
                            [@_dsn_product_@].PRODUCT_COST.PARTNER_STOCK_LOCATION,
                            [@_dsn_product_@].PRODUCT_COST.ACTIVE_STOCK_LOCATION,
                            [@_dsn_product_@].PRODUCT_COST.IS_SEVK,
                            [@_dsn_product_@].PRODUCT_COST.RECORD_DATE,
                            [@_dsn_product_@].PRODUCT_COST.RECORD_EMP,
                            [@_dsn_product_@].PRODUCT_COST.RECORD_IP,
                            [@_dsn_product_@].PRODUCT_COST.UPDATE_DATE,
                            [@_dsn_product_@].PRODUCT_COST.UPDATE_EMP,
                            [@_dsn_product_@].PRODUCT_COST.UPDATE_IP,
                            [@_dsn_product_@].PRODUCT_COST.IS_SUGGEST,
                            [@_dsn_product_@].PRODUCT_COST.PRICE_PROTECTION_TOTAL,
                            [@_dsn_product_@].PRODUCT_COST.PRICE_PROTECTION_AMOUNT,
                            [@_dsn_product_@].PRODUCT_COST.DUE_DATE,
                            [@_dsn_product_@].PRODUCT_COST.DUE_DATE_LOCATION,
                            [@_dsn_product_@].PRODUCT_COST.PHYSICAL_DATE,
                            [@_dsn_product_@].PRODUCT_COST.PHYSICAL_DATE_LOCATION,
                            [@_dsn_product_@].PRODUCT_COST.ACTION_EXTRA_COST,
                            [@_dsn_product_@].PRODUCT_COST.STOCK_ID,
                            [@_dsn_product_@].PRODUCT_COST.PURCHASE_NET_ALL,
                            [@_dsn_product_@].PRODUCT_COST.PURCHASE_NET_SYSTEM_ALL,
                            [@_dsn_product_@].PRODUCT_COST.PURCHASE_NET_SYSTEM_2_ALL,
                            [@_dsn_product_@].PRODUCT_COST.PURCHASE_NET_LOCATION_ALL,
                            [@_dsn_product_@].PRODUCT_COST.PURCHASE_NET_SYSTEM_LOCATION_ALL,
                            [@_dsn_product_@].PRODUCT_COST.PURCHASE_NET_SYSTEM_2_LOCATION_ALL,
                            [@_dsn_product_@].PRODUCT_COST.PURCHASE_NET_DEPARTMENT_ALL,
                            [@_dsn_product_@].PRODUCT_COST.PURCHASE_NET_SYSTEM_DEPARTMENT_ALL,
                            [@_dsn_product_@].PRODUCT_COST.PURCHASE_NET_SYSTEM_2_DEPARTMENT_ALL,
                            [@_dsn_product_@].PRODUCT_COST.PRODUCT_COST_DEPARTMENT,
                            [@_dsn_product_@].PRODUCT_COST.MONEY_DEPARTMENT,
                            [@_dsn_product_@].PRODUCT_COST.STANDARD_COST_DEPARTMENT,
                            [@_dsn_product_@].PRODUCT_COST.STANDARD_COST_MONEY_DEPARTMENT,
                            [@_dsn_product_@].PRODUCT_COST.STANDARD_COST_RATE_DEPARTMENT,
                            [@_dsn_product_@].PRODUCT_COST.PURCHASE_NET_DEPARTMENT,
                            [@_dsn_product_@].PRODUCT_COST.PURCHASE_NET_MONEY_DEPARTMENT,
                            [@_dsn_product_@].PRODUCT_COST.PURCHASE_EXTRA_COST_DEPARTMENT,
                            [@_dsn_product_@].PRODUCT_COST.PRICE_PROTECTION_DEPARTMENT,
                            [@_dsn_product_@].PRODUCT_COST.PRICE_PROTECTION_MONEY_DEPARTMENT,
                            [@_dsn_product_@].PRODUCT_COST.PURCHASE_NET_SYSTEM_DEPARTMENT,
                            [@_dsn_product_@].PRODUCT_COST.PURCHASE_NET_SYSTEM_MONEY_DEPARTMENT,
                            [@_dsn_product_@].PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM_DEPARTMENT,
                            [@_dsn_product_@].PRODUCT_COST.PURCHASE_NET_SYSTEM_2_DEPARTMENT,
                            [@_dsn_product_@].PRODUCT_COST.PURCHASE_NET_SYSTEM_MONEY_2_DEPARTMENT,
                            [@_dsn_product_@].PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM_2_DEPARTMENT,
                            [@_dsn_product_@].PRODUCT_COST.AVAILABLE_STOCK_DEPARTMENT,
                            [@_dsn_product_@].PRODUCT_COST.PARTNER_STOCK_DEPARTMENT,
                            [@_dsn_product_@].PRODUCT_COST.ACTIVE_STOCK_DEPARTMENT,
                            [@_dsn_product_@].PRODUCT_COST.DUE_DATE_DEPARTMENT,
                            [@_dsn_product_@].PRODUCT_COST.PHYSICAL_DATE_DEPARTMENT
                        FROM   
                             [@_dsn_product_@].PRODUCT,
                             [@_dsn_product_@].PRODUCT_COST,
                             [@_dsn_product_@].PRODUCT_OUR_COMPANY,
                             [@_dsn_main_@].SETUP_PERIOD
                        WHERE     
                            [@_dsn_main_@].SETUP_PERIOD.OUR_COMPANY_ID = @_companyid_@ AND
                            [@_dsn_main_@].SETUP_PERIOD.PERIOD_ID = [@_dsn_product_@].PRODUCT_COST.ACTION_PERIOD_ID AND   
                            ([@_dsn_product_@].PRODUCT_OUR_COMPANY.OUR_COMPANY_ID = @_companyid_@) AND
                            [@_dsn_product_@].PRODUCT.PRODUCT_ID = [@_dsn_product_@].PRODUCT_OUR_COMPANY.PRODUCT_ID AND
                            [@_dsn_product_@].PRODUCT_COST.PRODUCT_ID = [@_dsn_product_@].PRODUCT.PRODUCT_ID

CREATE VIEW [@_dsn_company_@].[PRODUCT_UNIT_PROFIT] AS
                        SELECT
                            SUM(PRICE_STANDART.PRICE - PRODUCT_COST.PRODUCT_COST) AS PROFIT,
                            PRODUCT.PRODUCT_NAME, PRODUCT.PRODUCT_ID, 
                            PRODUCT_COST.MONEY, PRODUCT_UNIT.ADD_UNIT AS UNIT
                        FROM
                            PRICE_STANDART, 
                            PRODUCT_COST, 
                            PRODUCT, 
                            PRODUCT_UNIT
                        WHERE
                            PRICE_STANDART.PRODUCT_ID = PRODUCT_COST.PRODUCT_ID AND 
                            PRICE_STANDART.UNIT_ID = PRODUCT_COST.UNIT_ID AND
                            PRODUCT_COST.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
                            PRODUCT_COST.UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID AND
                            PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
                            PRICE_STANDART.PURCHASESALES = 1 AND 
                            PRODUCT_COST.PRODUCT_COST_STATUS = 1
                        GROUP BY
                            PRODUCT.PRODUCT_NAME,
                            PRODUCT.PRODUCT_ID,
                            PRODUCT_COST.MONEY,
                            PRODUCT_UNIT.ADD_UNIT

CREATE VIEW [@_dsn_company_@].[GET_PRODUCTION_RESERVED] AS
                        SELECT
                                SUM(STOCK_ARTIR) STOCK_ARTIR,
                                SUM(STOCK_AZALT) STOCK_AZALT,
                                STOCK_ID,
                                PRODUCT_ID
                            FROM
                                (
                                SELECT
                                    CASE WHEN SUM(STOCK_ARTIR) > 0 THEN SUM(STOCK_ARTIR) ELSE 0 END AS STOCK_ARTIR,
                                    CASE WHEN SUM(STOCK_AZALT) > 0 THEN SUM(STOCK_AZALT) ELSE 0 END AS STOCK_AZALT,
                                    S.STOCK_ID,
                                    S.PRODUCT_ID,
                                    P_ORDER_ID
                                FROM
                                    (
                                        SELECT
                                            (QUANTITY) AS STOCK_ARTIR,
                                            0 AS STOCK_AZALT,
                                            STOCK_ID,
                                            P_ORDER_ID
                                        FROM
                                            PRODUCTION_ORDERS
                                        WHERE
                                            IS_STOCK_RESERVED = 1 AND
                                            IS_DEMONTAJ=0 AND
                                            SPEC_MAIN_ID IS NOT NULL
                                            AND STATUS=1
                                        
                                    UNION ALL
                                        SELECT
                                            0 AS STOCK_ARTIR,
                                            (QUANTITY) AS STOCK_AZALT,
                                            STOCK_ID,
                                            P_ORDER_ID
                                        FROM
                                            PRODUCTION_ORDERS
                                        WHERE
                                            IS_STOCK_RESERVED = 1 AND
                                            IS_DEMONTAJ=1 AND
                                            SPEC_MAIN_ID IS NOT NULL
                                            AND STATUS=1
                                            
                                    UNION ALL
                                        SELECT
                                            0 AS STOCK_ARTIR,
                                            CASE WHEN ISNULL((SELECT
                                                        SUM(POR_.AMOUNT)
                                                    FROM
                                                        PRODUCTION_ORDER_RESULTS_ROW POR_,
                                                        PRODUCTION_ORDER_RESULTS POO
                                                    WHERE
                                                        POR_.PR_ORDER_ID = POO.PR_ORDER_ID
                                                        AND POO.P_ORDER_ID = PO.P_ORDER_ID
                                                        AND POR_.STOCK_ID = POS.STOCK_ID
                                                        AND POO.IS_STOCK_FIS = 1
                                                    ),0) > (ISNULL(PO.RESULT_AMOUNT,0))
                                                    
                                    THEN
                                    (
                                                        (
                                                                SELECT 
                                                                    SUM(AMOUNT) AMOUNT
                                                                FROM
                                                                    PRODUCTION_ORDERS_STOCKS
                                                                WHERE
                                                                P_ORDER_ID = PO.P_ORDER_ID AND STOCK_ID = POS.STOCK_ID
                                                        )
                                                        /
                                                        (
                                                        
                                                            SELECT 
                                                                QUANTITY 
                                                            FROM 
                                                                PRODUCTION_ORDERS
                                                            WHERE
                                                                P_ORDER_ID = PO.P_ORDER_ID
                                                        )
                                                    
                                                    )*(ISNULL(PO.QUANTITY,0) - ISNULL(PO.RESULT_AMOUNT,0))
                                    ELSE 									
                                    (((POS.AMOUNT*(ISNULL(PO.QUANTITY,0) - ISNULL(PO.RESULT_AMOUNT,0)))/(ISNULL(PO.QUANTITY,0)))) END AS STOCK_AZALT,
                                            POS.STOCK_ID,
                                            PO.P_ORDER_ID
                                        FROM
                                            PRODUCTION_ORDERS PO,
                                            PRODUCTION_ORDERS_STOCKS POS
                                        WHERE
                                            PO.IS_STOCK_RESERVED = 1 AND
                                            PO.P_ORDER_ID = POS.P_ORDER_ID AND
                                            PO.IS_DEMONTAJ=0 AND
                                            ISNULL(POS.STOCK_ID,0)>0 AND
                                            POS.IS_SEVK <> 1 AND
                                            ISNULL(IS_FREE_AMOUNT,0) = 0
                                            AND PO.STATUS=1
                                    UNION ALL
                                        SELECT
                                            POS.AMOUNT AS STOCK_ARTIR,
                                            0 AS STOCK_AZALT,
                                            POS.STOCK_ID,
                                            PO.P_ORDER_ID
                                        FROM
                                            PRODUCTION_ORDERS PO,
                                            PRODUCTION_ORDERS_STOCKS POS
                                        WHERE
                                            PO.IS_STOCK_RESERVED = 1 AND
                                            POS.P_ORDER_ID = PO.P_ORDER_ID AND
                                            PO.IS_DEMONTAJ=1 AND
                                            ISNULL(POS.STOCK_ID,0)>0 AND
                                            POS.IS_SEVK <> 1 AND
                                            ISNULL(IS_FREE_AMOUNT,0) = 0
                                            AND PO.STATUS=1
                                    UNION ALL
                                        SELECT 
                                            (P_ORD_R_R.AMOUNT)*-1 AS  STOCK_ARTIR,
                                            0 AS STOCK_AZALT,
                                            P_ORD_R_R.STOCK_ID,
                                            P_ORD_R.P_ORDER_ID
                                        FROM
                                            PRODUCTION_ORDER_RESULTS P_ORD_R,
                                            PRODUCTION_ORDER_RESULTS_ROW P_ORD_R_R,
                                            PRODUCTION_ORDERS P_ORD
                                        WHERE
                                            P_ORD.IS_STOCK_RESERVED=1 AND
                                            P_ORD.SPEC_MAIN_ID IS NOT NULL AND
                                            P_ORD.P_ORDER_ID = P_ORD_R.P_ORDER_ID AND
                                            P_ORD_R_R.PR_ORDER_ID=P_ORD_R.PR_ORDER_ID AND
                                            P_ORD_R_R.TYPE=1 AND
                                            P_ORD_R.IS_STOCK_FIS=1 AND
                                            P_ORD_R_R.IS_SEVKIYAT IS NULL
                                            AND P_ORD.STATUS=1
                
                                ) T1,
                                [@_dsn_product_@].STOCKS S
                                WHERE
                                    S.STOCK_ID=T1.STOCK_ID					
                                GROUP BY 
                                    S.STOCK_ID,
                                    S.PRODUCT_ID,
                                    P_ORDER_ID
                                )T2
                            GROUP BY
                                STOCK_ID,
                                PRODUCT_ID

CREATE VIEW [@_dsn_company_@].[GET_STOCK_RESERVED_LAST] AS
                        SELECT 
                            SUM(STOCK_ARTIR) AS STOCK_ARTIR,
                            SUM(STOCK_AZALT) AS STOCK_AZALT,
                            SUM(STOCK_ARTIR-STOCK_AZALT) AS FARK,
                            PRODUCT_ID,
                            STOCK_ID
                        FROM
                            (	
                            SELECT
                                GSR.STOCK_ARTIR AS STOCK_ARTIR,
                                GSR.STOCK_AZALT AS STOCK_AZALT, 
                                GSR.PRODUCT_ID,
                                GSR.STOCK_ID
                            FROM
                                GET_STOCK_RESERVED GSR
                            
                    UNION 
                                
                            SELECT
                                GPR.STOCK_ARTIR,
                                GPR.STOCK_AZALT,
                                GPR.PRODUCT_ID,
                                GPR.STOCK_ID
                            FROM
                                GET_PRODUCTION_RESERVED GPR
                            )  AS TOTAL_RESERVE
                        
                        GROUP BY
                            PRODUCT_ID,
                            STOCK_ID

CREATE VIEW [@_dsn_company_@].[GET_STOCK_RESERVED_SPECT_LOCATION] AS		
                        SELECT
                            SUM((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT) * PU.MULTIPLIER) AS STOCK_AZALT,
                            SUM((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) * PU.MULTIPLIER) AS STOCK_ARTIR,
                            S.PRODUCT_ID, 
                            S.STOCK_ID,
                            S.STOCK_CODE, 
                            S.PROPERTY, 
                            S.BARCOD, 
                            PU.MAIN_UNIT,
                            ORDS.ORDER_ID,
                            SP.SPECT_MAIN_ID,
                            ISNULL(ORR.DEPARTMENT_ID,ORDS.DELIVER_DEPT_ID) AS DEPARTMENT_ID,
                            ISNULL(ORR.LOCATION_ID,ORDS.LOCATION_ID) AS LOCATION_ID
                        FROM
                            STOCKS S,
                            GET_ORDER_ROW_RESERVED_LOCATION ORR,
                            ORDERS ORDS,
                            PRODUCT_UNIT PU,
                            SPECTS SP
                        WHERE
                            ORR.STOCK_ID = S.STOCK_ID AND 
                            ORDS.RESERVED = 1 AND 
                            ORDS.ORDER_STATUS = 1 AND
                            ORR.ORDER_ID = ORDS.ORDER_ID AND
                            S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                            SP.SPECT_VAR_ID=ORR.SPECT_VAR_ID AND
                            ((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0 OR (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0 )
                        GROUP BY
                            S.PRODUCT_ID,
                            S.STOCK_ID,
                            S.STOCK_CODE,
                            S.PROPERTY,
                            S.BARCOD,
                            PU.MAIN_UNIT,
                            ORDS.ORDER_ID,
                            SP.SPECT_MAIN_ID,
                            ORDS.DELIVER_DEPT_ID,
                            ORDS.LOCATION_ID,
                            ORR.DEPARTMENT_ID,
                            ORR.LOCATION_ID
                        UNION
                        SELECT
                            SUM((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT) * PU.MULTIPLIER) AS STOCK_AZALT,
                            SUM((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) * PU.MULTIPLIER) AS STOCK_ARTIR,
                            S.PRODUCT_ID, 
                            S.STOCK_ID,
                            S.STOCK_CODE, 
                            S.PROPERTY, 
                            S.BARCOD, 
                            PU.MAIN_UNIT,
                            ORDS.ORDER_ID,
                            NULL,
                            ISNULL(ORR.DEPARTMENT_ID,ORDS.DELIVER_DEPT_ID) AS DEPARTMENT_ID,
                            ISNULL(ORR.LOCATION_ID,ORDS.LOCATION_ID) AS LOCATION_ID
                        FROM
                            STOCKS S,
                            GET_ORDER_ROW_RESERVED_LOCATION ORR,
                            ORDERS ORDS,
                            PRODUCT_UNIT PU
                        WHERE
                            ORR.STOCK_ID = S.STOCK_ID AND 
                            ORDS.RESERVED = 1 AND 
                            ORDS.ORDER_STATUS = 1 AND
                            ORR.ORDER_ID = ORDS.ORDER_ID AND
                            S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                            ORR.SPECT_VAR_ID IS NULL AND
                            ((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0 OR (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0 )
                        GROUP BY
                            S.PRODUCT_ID,
                            S.STOCK_ID,
                            S.STOCK_CODE,
                            S.PROPERTY,
                            S.BARCOD,
                            PU.MAIN_UNIT,
                            ORDS.ORDER_ID,
                            ORDS.DELIVER_DEPT_ID,
                            ORDS.LOCATION_ID,
                            ORR.DEPARTMENT_ID,
                            ORR.LOCATION_ID
                        UNION 
                        SELECT
                            SUM((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)* SR.AMOUNT_VALUE * PU.MULTIPLIER) AS STOCK_AZALT,
                            SUM((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) *SR.AMOUNT_VALUE * PU.MULTIPLIER) AS STOCK_ARTIR,
                            S.PRODUCT_ID,
                            S.STOCK_ID,
                            S.STOCK_CODE,
                            S.PROPERTY,
                            S.BARCOD, 
                            PU.MAIN_UNIT,
                            ORDS.ORDER_ID,
                            NULL,
                            ISNULL(ORR.DEPARTMENT_ID,ORDS.DELIVER_DEPT_ID) AS DEPARTMENT_ID,
                            ISNULL(ORR.LOCATION_ID,ORDS.LOCATION_ID) AS LOCATION_ID
                         FROM
                            STOCKS S,
                            GET_ORDER_ROW_RESERVED_LOCATION ORR, 
                            ORDERS ORDS,
                            SPECTS_ROW SR,
                            PRODUCT_UNIT PU
                         WHERE
                            SR.STOCK_ID = S.STOCK_ID AND 
                            ORR.SPECT_VAR_ID=SR.SPECT_ID AND
                            SR.IS_SEVK=1 AND
                            ORDS.RESERVED = 1 AND
                            ORDS.ORDER_STATUS = 1 AND
                            ORR.ORDER_ID = ORDS.ORDER_ID AND
                            S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                            ((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0 OR (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0 )
                         GROUP BY
                            S.PRODUCT_ID,
                            S.STOCK_ID,
                            S.STOCK_CODE,
                            S.PROPERTY,
                            S.BARCOD, 
                            PU.MAIN_UNIT,
                            ORDS.ORDER_ID,
                            ORDS.DELIVER_DEPT_ID,
                            ORDS.LOCATION_ID,
                            ORR.DEPARTMENT_ID,
                            ORR.LOCATION_ID

CREATE VIEW [@_dsn_company_@].[GET_ALL_ORDER_ROW] AS
                        SELECT
                            ORR.WRK_ROW_RELATION_ID,
                            ORR.QUANTITY
                        FROM 
                            ORDERS O,
                            ORDER_ROW ORR
                        WHERE 
                            O.ORDER_ID = ORR.ORDER_ID
                            AND O.ORDER_STAGE IN(71)
                        UNION ALL
                        SELECT
                            OFR.WRK_ROW_RELATION_ID,
                            ORR.QUANTITY
                        FROM 
                            ORDERS O,
                            ORDER_ROW ORR,
                            OFFER_ROW OFR
                        WHERE 
                            O.OFFER_ID = OFR.OFFER_ID AND
                            ORR.WRK_ROW_RELATION_ID = OFR.WRK_ROW_ID AND
                            O.ORDER_STAGE IN(71)
                        UNION ALL
                        SELECT
                            IR.WRK_ROW_RELATION_ID,
                            ORR.QUANTITY
                        FROM 
                            INTERNALDEMAND I,
                            INTERNALDEMAND_ROW IR,
                            OFFER OO,
                            OFFER_ROW OFR,
                            ORDERS O,
                            ORDER_ROW ORR
                        WHERE 
                            OO.OFFER_ID = OFR.OFFER_ID AND
                            I.INTERNAL_ID = IR.I_ID AND
            
                            O.ORDER_ID = ORR.ORDER_ID AND
                            IR.WRK_ROW_ID = OFR.WRK_ROW_RELATION_ID AND
                            OFR.WRK_ROW_ID = ORR.WRK_ROW_RELATION_ID AND
                            O.ORDER_STAGE IN(71)
                        UNION ALL
                        SELECT
                            IR.WRK_ROW_RELATION_ID,
                            ORR.QUANTITY
                        FROM 
                            INTERNALDEMAND I,
                            INTERNALDEMAND_ROW IR,
                            OFFER OO,
                            OFFER_ROW OFR,
                            OFFER OO2,
                            OFFER_ROW OFR2,
                            ORDERS O,
                            ORDER_ROW ORR
                        WHERE 
                            OO.OFFER_ID = OFR.OFFER_ID AND
                            OO2.OFFER_ID = OFR2.OFFER_ID AND
                            I.INTERNAL_ID = IR.I_ID AND
                            O.ORDER_ID = ORR.ORDER_ID AND
                            IR.WRK_ROW_ID = OFR.WRK_ROW_RELATION_ID AND
                            OFR.WRK_ROW_ID = OFR2.WRK_ROW_RELATION_ID AND
                            OFR2.WRK_ROW_ID = ORR.WRK_ROW_RELATION_ID AND
                            O.ORDER_STAGE IN(71)
                        UNION ALL
                        SELECT
                            OFR.WRK_ROW_RELATION_ID,
                            ORR.QUANTITY
                        FROM 
                            OFFER OO,
                            OFFER_ROW OFR,
                            OFFER OO2,
                            OFFER_ROW OFR2,
                            ORDERS O,
                            ORDER_ROW ORR
                        WHERE 
                            OO.OFFER_ID = OFR.OFFER_ID AND
                            OO2.OFFER_ID = OFR2.OFFER_ID AND
                            O.ORDER_ID = ORR.ORDER_ID AND
                            OFR.WRK_ROW_ID = OFR2.WRK_ROW_RELATION_ID AND
                            OFR2.WRK_ROW_ID = ORR.WRK_ROW_RELATION_ID AND
                            O.ORDER_STAGE IN(71)

CREATE VIEW [@_dsn_company_@].[GET_ORDER_ROW_RESERVED_ALL] AS
                        SELECT STOCK_ID,
                           PRODUCT_ID,
                           ORDER_ID,
                           STOCK_STRATEGY_ID,
                           SUM(RESERVE_STOCK_IN)      RESERVE_STOCK_IN,
                           SUM(RESERVE_STOCK_OUT)     RESERVE_STOCK_OUT,
                           SUM(STOCK_IN)              STOCK_IN,
                           SUM(STOCK_OUT)             STOCK_OUT
                        FROM   ORDER_ROW_RESERVED
                           LEFT JOIN (
                                    SELECT ORDER_WRK_ROW_ID,
                                           COUNT(ROW_RESERVED_ID) AS SAYAC
                                    FROM   ORDER_ROW_RESERVED
                                    GROUP BY
                                           ORDER_WRK_ROW_ID
                                    HAVING COUNT(ROW_RESERVED_ID) > 1
                                )                  AS XXX
                                ON  XXX.ORDER_WRK_ROW_ID = ORDER_ROW_RESERVED.ORDER_WRK_ROW_ID
                        WHERE  ORDER_ROW_RESERVED.ORDER_WRK_ROW_ID IS NULL
                           OR  (INVOICE_ID IS NULL AND SHIP_ID IS NULL)
                           OR  (
                                   (INVOICE_ID IS NOT NULL OR SHIP_ID IS NOT NULL)
                                   AND ORDER_ROW_RESERVED.ORDER_WRK_ROW_ID IS NOT NULL
                                   AND XXX.ORDER_WRK_ROW_ID IS NOT NULL
                               )
                        GROUP BY
                           STOCK_ID,
                           PRODUCT_ID,
                           ORDER_ID,
                           STOCK_STRATEGY_ID

CREATE VIEW [@_dsn_company_@].[GET_PRODUCTION_RESERVED_LOCATION] AS
                SELECT
					SUM(STOCK_ARTIR) STOCK_ARTIR,
					SUM(STOCK_AZALT) STOCK_AZALT,
					STOCK_ID,
					PRODUCT_ID,
                    DEPARTMENT_ID,
                    LOCATION_ID
				FROM
					(   
				    SELECT
                        CASE WHEN SUM(STOCK_ARTIR) > 0 THEN SUM(STOCK_ARTIR) ELSE 0 END AS STOCK_ARTIR,
                        CASE WHEN SUM(STOCK_AZALT) > 0 THEN SUM(STOCK_AZALT) ELSE 0 END AS STOCK_AZALT,
                        S.STOCK_ID,
                        S.PRODUCT_ID,
						P_ORDER_ID,
                        DEPARTMENT_ID,
                        LOCATION_ID
                    FROM
                        (
                            SELECT
                                (QUANTITY) AS STOCK_ARTIR,
                                0 AS STOCK_AZALT,
                                STOCK_ID,
								P_ORDER_ID,
                                PRODUCTION_DEP_ID as DEPARTMENT_ID,
                                PRODUCTION_LOC_ID AS LOCATION_ID
                            FROM
                                PRODUCTION_ORDERS
                            WHERE
                                IS_STOCK_RESERVED = 1 AND
                                IS_DEMONTAJ=0 AND
                                SPEC_MAIN_ID IS NOT NULL
								AND STATUS=1
                        UNION ALL
                            SELECT
                                0 AS STOCK_ARTIR,
                                (QUANTITY) AS STOCK_AZALT,
                                STOCK_ID,
								P_ORDER_ID,
                                PRODUCTION_DEP_ID as DEPARTMENT_ID, 
                                PRODUCTION_LOC_ID AS LOCATION_ID
                            FROM
                                PRODUCTION_ORDERS
                            WHERE
                                IS_STOCK_RESERVED = 1 AND
                                IS_DEMONTAJ=1 AND
                                SPEC_MAIN_ID IS NOT NULL
								AND STATUS=1
                        UNION ALL
                            SELECT
                                0 AS STOCK_ARTIR,
                                --(ISNULL(PO.QUANTITY,0) - ISNULL(PO.RESULT_AMOUNT,0)) AS STOCK_AZALT,
								 CASE WHEN ISNULL((SELECT
											SUM(POR_.AMOUNT)
										FROM
											PRODUCTION_ORDER_RESULTS_ROW POR_,
											PRODUCTION_ORDER_RESULTS POO
										WHERE
											POR_.PR_ORDER_ID = POO.PR_ORDER_ID
											AND POO.P_ORDER_ID = PO.P_ORDER_ID
											AND POR_.STOCK_ID = POS.STOCK_ID
											AND POO.IS_STOCK_FIS = 1
										),0) > (ISNULL(PO.RESULT_AMOUNT,0))
										 
						THEN
						 (
											(
													SELECT 
														SUM(AMOUNT) AMOUNT
													FROM
														PRODUCTION_ORDERS_STOCKS
													WHERE
													P_ORDER_ID = PO.P_ORDER_ID AND STOCK_ID = POS.STOCK_ID
											)
											/
											(
											
												SELECT 
													QUANTITY 
												FROM 
													PRODUCTION_ORDERS
												WHERE
													P_ORDER_ID = PO.P_ORDER_ID
											)
										
										)*(ISNULL(PO.QUANTITY,0) - ISNULL(PO.RESULT_AMOUNT,0))
						 ELSE 									
                         (((POS.AMOUNT*(ISNULL(PO.QUANTITY,0) - ISNULL(PO.RESULT_AMOUNT,0)))/(ISNULL(PO.QUANTITY,0)))) END AS STOCK_AZALT,
                                POS.STOCK_ID,
								PO.P_ORDER_ID,
                                PO.EXIT_DEP_ID as DEPARTMENT_ID,
                                PO.EXIT_LOC_ID AS LOCATION_ID
                            FROM
                                PRODUCTION_ORDERS PO,
                                PRODUCTION_ORDERS_STOCKS POS
                            WHERE
                                PO.IS_STOCK_RESERVED = 1 AND
                                POS.P_ORDER_ID = PO.P_ORDER_ID AND
                                PO.IS_DEMONTAJ=0 AND
                                ISNULL(POS.STOCK_ID,0)>0 AND
                                POS.IS_SEVK <> 1 AND
                                ISNULL(IS_FREE_AMOUNT,0) = 0
								AND PO.STATUS=1
                        UNION ALL
                            SELECT
                                POS.AMOUNT AS STOCK_ARTIR,
                                0 AS STOCK_AZALT,
                                POS.STOCK_ID,
								PO.P_ORDER_ID,
                                PO.PRODUCTION_DEP_ID as DEPARTMENT_ID,
                                PO.PRODUCTION_LOC_ID AS LOCATION_ID
                            FROM
                                PRODUCTION_ORDERS PO,
                                PRODUCTION_ORDERS_STOCKS POS
                            WHERE
                                PO.IS_STOCK_RESERVED = 1 AND
                                POS.P_ORDER_ID = PO.P_ORDER_ID AND
                                PO.IS_DEMONTAJ=1 AND
                                ISNULL(POS.STOCK_ID,0)>0 AND
                                POS.IS_SEVK <> 1 AND
                                ISNULL(IS_FREE_AMOUNT,0) = 0
								AND PO.STATUS=1
                        UNION ALL
                            SELECT 
                                (P_ORD_R_R.AMOUNT)*-1 AS  STOCK_ARTIR,
                                0 AS STOCK_AZALT,
                                P_ORD_R_R.STOCK_ID,
								P_ORD_R.P_ORDER_ID,
                                P_ORD_R.PRODUCTION_DEP_ID AS DEPARTMENT_ID,
                                P_ORD_R.PRODUCTION_LOC_ID AS LOCATION_ID
                            FROM
                                PRODUCTION_ORDER_RESULTS P_ORD_R,
                                PRODUCTION_ORDER_RESULTS_ROW P_ORD_R_R,
                                PRODUCTION_ORDERS P_ORD
                            WHERE
                                P_ORD.IS_STOCK_RESERVED=1 AND
                                P_ORD.SPEC_MAIN_ID IS NOT NULL AND
                                P_ORD.P_ORDER_ID = P_ORD_R.P_ORDER_ID AND
                                P_ORD_R_R.PR_ORDER_ID=P_ORD_R.PR_ORDER_ID AND
                                P_ORD_R_R.TYPE=1 AND
                                P_ORD_R.IS_STOCK_FIS=1 AND
                                P_ORD_R_R.IS_SEVKIYAT IS NULL
								AND P_ORD.STATUS=1
						
                    ) T1,
                    [@_dsn_product_@].STOCKS S
                    WHERE
                        S.STOCK_ID=T1.STOCK_ID
                    GROUP BY 
                        S.STOCK_ID,
                        S.PRODUCT_ID,
						T1.P_ORDER_ID,
                        T1.DEPARTMENT_ID,
                        T1.LOCATION_ID
				)T2
				GROUP BY
					STOCK_ID,
					PRODUCT_ID,
                    DEPARTMENT_ID,
                    LOCATION_ID

CREATE VIEW [@_dsn_company_@].[GET_PRODUCTION_RESERVED_SPECT_LOCATION] AS
                            SELECT
                            SUM(STOCK_ARTIR) AS STOCK_ARTIR,
                            SUM(STOCK_AZALT) AS STOCK_AZALT,
                            STOCK_ID,
                            PRODUCT_ID,
                            SPECT_MAIN_ID,
                            DEPARTMENT_ID,
                            LOCATION_ID
                        FROM
                            (
                            SELECT
                                CASE WHEN SUM(STOCK_ARTIR) > 0 THEN SUM(STOCK_ARTIR) ELSE 0 END AS STOCK_ARTIR,
                                CASE WHEN SUM(STOCK_AZALT) > 0 THEN SUM(STOCK_AZALT) ELSE 0 END AS STOCK_AZALT,
                                S.STOCK_ID,
                                S.PRODUCT_ID,
                                T1.SPECT_MAIN_ID,
                                T1.DEPARTMENT_ID,
                                T1.LOCATION_ID,
                                T1.P_ORDER_ID
                            FROM
                            (
                                SELECT 	
                                    (P_ORD.QUANTITY) AS STOCK_ARTIR,
                                    0 AS STOCK_AZALT,	
                                    P_ORD.STOCK_ID,
                                    P_ORD.SPEC_MAIN_ID SPECT_MAIN_ID,
                                    P_ORD.PRODUCTION_DEP_ID as DEPARTMENT_ID,
                                    P_ORD.PRODUCTION_LOC_ID AS LOCATION_ID,
                                    P_ORD.P_ORDER_ID
                                FROM
                                    PRODUCTION_ORDERS P_ORD
                                WHERE 
                                    P_ORD.IS_STOCK_RESERVED = 1 AND 
                                    P_ORD.IS_DEMONTAJ=0
                                UNION ALL
                                SELECT 	
                                    0 AS STOCK_ARTIR,
                                    (P_ORD.QUANTITY) AS STOCK_AZALT,	
                                    P_ORD.STOCK_ID, 
                                    P_ORD.SPEC_MAIN_ID SPECT_MAIN_ID,
                                    P_ORD.PRODUCTION_DEP_ID as DEPARTMENT_ID,
                                    P_ORD.PRODUCTION_LOC_ID AS LOCATION_ID,
                                    P_ORD.P_ORDER_ID
                                FROM
                                    PRODUCTION_ORDERS P_ORD
                                WHERE 
                                    P_ORD.IS_STOCK_RESERVED = 1 AND 
                                    P_ORD.IS_DEMONTAJ=1
                                UNION ALL
                                SELECT
                                    0 AS STOCK_ARTIR,	
                                    POS.AMOUNT AS STOCK_AZALT,
                                    POS.STOCK_ID,
                                    POS.SPECT_MAIN_ID,
                                    PO.PRODUCTION_DEP_ID as DEPARTMENT_ID,
                                    PO.PRODUCTION_LOC_ID AS LOCATION_ID,
                                    PO.P_ORDER_ID
                                FROM
                                    PRODUCTION_ORDERS PO,
                                    PRODUCTION_ORDERS_STOCKS POS
                                WHERE
                                    PO.IS_STOCK_RESERVED=1 AND
                                    PO.P_ORDER_ID = POS.P_ORDER_ID AND
                                    PO.IS_DEMONTAJ=0 AND
                                    POS.IS_SEVK <> 1 AND
                                    ISNULL(IS_FREE_AMOUNT,0) = 0
                                UNION ALL
                                SELECT
                                    POS.AMOUNT AS STOCK_ARTIR,	
                                    0 AS STOCK_AZALT,
                                    POS.STOCK_ID,
                                    POS.SPECT_MAIN_ID,
                                    PO.PRODUCTION_DEP_ID as DEPARTMENT_ID,
                                    PO.PRODUCTION_LOC_ID AS LOCATION_ID,
                                    PO.P_ORDER_ID
                                FROM
                                    PRODUCTION_ORDERS PO,
                                    PRODUCTION_ORDERS_STOCKS POS
                                WHERE
                                    PO.IS_STOCK_RESERVED=1 AND
                                    PO.P_ORDER_ID = POS.P_ORDER_ID AND
                                    PO.IS_DEMONTAJ = 1 AND
                                    POS.IS_SEVK <> 1 AND
                                    ISNULL(IS_FREE_AMOUNT,0) = 0
                                UNION ALL
                                SELECT 
                                    (P_ORD_R_R.AMOUNT)*-1 AS STOCK_ARTIR,
                                    0 AS STOCK_AZALT,
                                    P_ORD_R_R.STOCK_ID,
                                    SP.SPECT_MAIN_ID,
                                    P_ORD_R.PRODUCTION_DEP_ID AS DEPARTMENT_ID,
                                    P_ORD_R.PRODUCTION_LOC_ID AS LOCATION_ID,
                                    P_ORD.P_ORDER_ID
                                FROM
                                    PRODUCTION_ORDER_RESULTS P_ORD_R,
                                    PRODUCTION_ORDER_RESULTS_ROW P_ORD_R_R,
                                    PRODUCTION_ORDERS P_ORD,
                                    SPECT_MAIN SP
                                WHERE
                                    P_ORD.IS_STOCK_RESERVED=1 AND
                                    P_ORD.P_ORDER_ID = P_ORD_R.P_ORDER_ID AND
                                    P_ORD_R_R.PR_ORDER_ID=P_ORD_R.PR_ORDER_ID AND
                                    SP.SPECT_MAIN_ID=P_ORD_R_R.SPEC_MAIN_ID AND
                                    P_ORD_R_R.TYPE=1 AND
                                    P_ORD_R.IS_STOCK_FIS=1 AND
                                    ISNULL(P_ORD_R_R.IS_SEVKIYAT,0)<>1
                                UNION ALL
                                SELECT 
                                    0 AS STOCK_ARTIR,
                                    (P_ORD_R_R.AMOUNT)*-1 AS STOCK_AZALT,
                                    P_ORD_R_R.STOCK_ID,
                                    SP.SPECT_MAIN_ID,
                                    P_ORD_R.EXIT_DEP_ID AS DEPARTMENT_ID,
                                    P_ORD_R.EXIT_LOC_ID AS LOCATION_ID,
                                    P_ORD.P_ORDER_ID
                                FROM
                                    PRODUCTION_ORDER_RESULTS P_ORD_R,
                                    PRODUCTION_ORDER_RESULTS_ROW P_ORD_R_R,
                                    PRODUCTION_ORDERS P_ORD,
                                    SPECT_MAIN SP
                                WHERE
                                    P_ORD.IS_STOCK_RESERVED=1 AND
                                    P_ORD.P_ORDER_ID = P_ORD_R.P_ORDER_ID AND
                                    P_ORD_R_R.PR_ORDER_ID=P_ORD_R.PR_ORDER_ID AND
                                    SP.SPECT_MAIN_ID=P_ORD_R_R.SPEC_MAIN_ID AND
                                    P_ORD_R_R.TYPE IN(2,3) AND
                                    P_ORD_R.IS_STOCK_FIS=1 AND
                                    ISNULL(P_ORD_R_R.IS_SEVKIYAT,0)<>1
                                UNION ALL
                                SELECT 
                                    0 AS STOCK_ARTIR,
                                    (P_ORD_R_R.AMOUNT)*-1 AS STOCK_AZALT,
                                    P_ORD_R_R.STOCK_ID,
                                    NULL,
                                    P_ORD_R.EXIT_DEP_ID AS DEPARTMENT_ID,
                                    P_ORD_R.EXIT_LOC_ID AS LOCATION_ID,
                                    P_ORD.P_ORDER_ID
                                FROM
                                    PRODUCTION_ORDER_RESULTS P_ORD_R,
                                    PRODUCTION_ORDER_RESULTS_ROW P_ORD_R_R,
                                    PRODUCTION_ORDERS P_ORD
                                WHERE
                                    P_ORD.IS_STOCK_RESERVED=1 AND
                                    P_ORD.P_ORDER_ID = P_ORD_R.P_ORDER_ID AND
                                    P_ORD_R_R.PR_ORDER_ID=P_ORD_R.PR_ORDER_ID AND
                                    P_ORD_R_R.SPEC_MAIN_ID IS NULL AND
                                    P_ORD_R_R.TYPE IN(2,3) AND
                                    P_ORD_R.IS_STOCK_FIS=1 AND
                                    ISNULL(P_ORD_R_R.IS_SEVKIYAT,0)<>1
                            ) T1,
                                [@_dsn_product_@].STOCKS S
                            WHERE
                                S.STOCK_ID=T1.STOCK_ID
                            GROUP BY 
                                S.STOCK_ID,
                                S.PRODUCT_ID,
                                T1.SPECT_MAIN_ID,
                                T1.DEPARTMENT_ID,
                                T1.LOCATION_ID,
                                T1.P_ORDER_ID
                            )T2
                        GROUP BY
                            STOCK_ID,
                            PRODUCT_ID,
                            SPECT_MAIN_ID,
                            DEPARTMENT_ID,
                            LOCATION_ID

CREATE VIEW [@_dsn_company_@].[GET_PRODUCTION_STOCKS] AS
                        SELECT
                            SUM(QUANTITY) AS STOK, 
                            STOCK_ID
                        FROM
                            PRODUCTION_ORDERS
                        GROUP BY
                            STOCK_ID

CREATE VIEW [@_dsn_company_@].[GET_STOCK_BARCODES] AS
                        SELECT DISTINCT
                            S.PRODUCT_ID,
                            SB.STOCK_ID,
                            SB.BARCODE,
                            SB.UNIT_ID AS UNIT_ID
                         FROM
                            [@_dsn_product_@].STOCKS_BARCODES SB,
                            [@_dsn_product_@].STOCKS S,
                            [@_dsn_product_@].PRODUCT P,
                            [@_dsn_product_@].PRODUCT_OUR_COMPANY POC
                         WHERE
                            S.STOCK_ID = SB.STOCK_ID AND
                            S.PRODUCT_ID = P.PRODUCT_ID AND
                            P.PRODUCT_ID = POC.PRODUCT_ID AND
                            POC.OUR_COMPANY_ID= @_companyid_@

CREATE VIEW [@_dsn_company_@].[INTERNALDEMAND_RELATION] AS
                        SELECT DISTINCT
                            INTERNALDEMAND_ID,
                            TO_OFFER_ID,
                            TO_ORDER_ID,
                            TO_SHIP_ID,
                            TO_STOCK_FIS_ID,
                            PERIOD_ID
                        FROM
                            INTERNALDEMAND_RELATION_ROW

CREATE VIEW [@_dsn_company_@].[PRODUCT_BRANDS] AS
                        SELECT     
                            PB.BRAND_ID,
                            PB.BRAND_NAME,
                            PB.BRAND_CODE,
                            PB.DETAIL,
                            PB.IS_ACTIVE,
                            PB.IS_INTERNET,
                            PB.RECORD_EMP,
                            PB.RECORD_DATE,
                            PB.RECORD_IP,
                            PB.UPDATE_EMP,
                            PB.UPDATE_DATE,
                            PB.UPDATE_IP
                        FROM        
                            [@_dsn_product_@].PRODUCT_BRANDS PB,
                            [@_dsn_product_@].PRODUCT_BRANDS_OUR_COMPANY PBO
                        WHERE
                            PB.BRAND_ID = PBO.BRAND_ID AND
                            PBO.OUR_COMPANY_ID = @_companyid_@

CREATE VIEW [@_dsn_company_@].[PRODUCT_CAT] AS
                        SELECT    
                            PRODUCT_CAT.PRODUCT_CATID,
                            PRODUCT_CAT.HIERARCHY,
                            PRODUCT_CAT.PRODUCT_CAT,
                            PRODUCT_CAT.DETAIL,
                            PRODUCT_CAT.POSITION_CODE,
                            PRODUCT_CAT.POSITION_CODE2,
                            PRODUCT_CAT.DSP,
                            PRODUCT_CAT.IS_PUBLIC,
                            PRODUCT_CAT.PROFIT_MARGIN,
                            PRODUCT_CAT.PROFIT_MARGIN_MAX,
                            PRODUCT_CAT.IS_SUB_PRODUCT_CAT,
                            PRODUCT_CAT.IS_CUSTOMIZABLE,
                            PRODUCT_CAT.RECORD_DATE,
                            PRODUCT_CAT.RECORD_EMP,
                            PRODUCT_CAT.RECORD_EMP_IP,
                            PRODUCT_CAT.UPDATE_DATE,
                            PRODUCT_CAT.UPDATE_EMP,
                            PRODUCT_CAT.UPDATE_EMP_IP,
                            PRODUCT_CAT.LIST_ORDER_NO,
                            PRODUCT_CAT.IMAGE_CAT,
                            PRODUCT_CAT.IMAGE_CAT_SERVER_ID,
                            PRODUCT_CAT.USER_FRIENDLY_URL,
                            PRODUCT_CAT.IS_INSTALLMENT_PAYMENT                            
                        FROM         
                             [@_dsn_product_@].PRODUCT_CAT,
                             [@_dsn_product_@].PRODUCT_CAT_OUR_COMPANY PBO
                        WHERE
                            PRODUCT_CAT.PRODUCT_CATID = PBO.PRODUCT_CATID AND 
                            PBO.OUR_COMPANY_ID = @_companyid_@

CREATE VIEW [@_dsn_company_@].[PRODUCT_IMAGES] AS
                        SELECT     
                            [@_dsn_product_@].PRODUCT_IMAGES.PRODUCT_ID,
                            [@_dsn_product_@].PRODUCT_IMAGES.PRODUCT_IMAGEID,
                            [@_dsn_product_@].PRODUCT_IMAGES.PATH,
                            [@_dsn_product_@].PRODUCT_IMAGES.DETAIL,
                            [@_dsn_product_@].PRODUCT_IMAGES.IMAGE_SIZE,
                            [@_dsn_product_@].PRODUCT_IMAGES.UPDATE_DATE,
                            [@_dsn_product_@].PRODUCT_IMAGES.UPDATE_EMP,
                            [@_dsn_product_@].PRODUCT_IMAGES.UPDATE_IP,
                            [@_dsn_product_@].PRODUCT_IMAGES.PROPERTY_ID,
                            [@_dsn_product_@].PRODUCT_IMAGES.UPDATE_PAR,
                            [@_dsn_product_@].PRODUCT_IMAGES.IS_INTERNET,
                            [@_dsn_product_@].PRODUCT_IMAGES.PATH_SERVER_ID,
                            [@_dsn_product_@].PRODUCT_IMAGES.STOCK_ID,
                            [@_dsn_product_@].PRODUCT_IMAGES.IS_EXTERNAL_LINK
                        FROM   
                             [@_dsn_product_@].PRODUCT,
                             [@_dsn_product_@].PRODUCT_IMAGES,
                             [@_dsn_product_@].PRODUCT_OUR_COMPANY
                        WHERE     
                             ([@_dsn_product_@].PRODUCT_OUR_COMPANY.OUR_COMPANY_ID = @_companyid_@) AND
                             [@_dsn_product_@].PRODUCT.PRODUCT_ID = [@_dsn_product_@].PRODUCT_OUR_COMPANY.PRODUCT_ID AND
                             [@_dsn_product_@].PRODUCT_IMAGES.PRODUCT_ID = [@_dsn_product_@].PRODUCT.PRODUCT_ID

CREATE VIEW [@_dsn_company_@].[STOCKS_PROPERTY] AS
                        SELECT     
                            [@_dsn_product_@]. STOCKS_PROPERTY.STOCK_ID,
                            [@_dsn_product_@].STOCKS_PROPERTY.PROPERTY_ID,
                            [@_dsn_product_@].STOCKS_PROPERTY.PROPERTY_DETAIL_ID,
                            [@_dsn_product_@].STOCKS_PROPERTY.PROPERTY_DETAIL,
                            [@_dsn_product_@].STOCKS_PROPERTY.TOTAL_MIN,
                            [@_dsn_product_@].STOCKS_PROPERTY.TOTAL_MAX,
                            [@_dsn_product_@].STOCKS_PROPERTY.OLD_PROPERTY_ID
                        FROM   
                            [@_dsn_product_@].PRODUCT,
                            [@_dsn_product_@].STOCKS_PROPERTY,
                            [@_dsn_product_@].STOCKS,
                            [@_dsn_product_@].PRODUCT_OUR_COMPANY
                        WHERE     
                            ([@_dsn_product_@].PRODUCT_OUR_COMPANY.OUR_COMPANY_ID = @_companyid_@) AND
                            [@_dsn_product_@].PRODUCT.PRODUCT_ID = [@_dsn_product_@].PRODUCT_OUR_COMPANY.PRODUCT_ID AND
                            [@_dsn_product_@].STOCKS.PRODUCT_ID = [@_dsn_product_@].PRODUCT.PRODUCT_ID AND
                            [@_dsn_product_@].STOCKS_PROPERTY.STOCK_ID = [@_dsn_product_@].STOCKS.STOCK_ID