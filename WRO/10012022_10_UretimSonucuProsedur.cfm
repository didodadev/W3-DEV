<!-- Description : Üretim sonuç satırları
Developer: Fatih Kara
Company : Workcube
Destination: Company-->
<querytag>
    ALTER PROCEDURE [@_dsn_company_@].[ADD_PRODUCTION_ORDER_RESULTS_ROW]
        @TREE_TYPE NVARCHAR(43),
        @TYPE int,
        @PR_ORDER_ID int,
        @BARCODE nvarchar(43),
        @STOCK_ID int,
        @PRODUCT_ID int,
        @AMOUNT float,
        @AMOUNT2 float,
        @UNIT_ID int,
        @UNIT2 nvarchar(50),
        @NAME_PRODUCT nvarchar(500),
        @UNIT_NAME nvarchar(65),
        @SPECT_ID int,
        @SPEC_MAIN_ID int,
        @SPECT_NAME nvarchar(500),
        @COST_ID int,
        @KDV_PRICE float,
        @PURCHASE_NET_SYSTEM float,
        @PURCHASE_NET_SYSTEM_MONEY nvarchar(43),
        @PURCHASE_EXTRA_COST_SYSTEM float,
        @PURCHASE_NET_SYSTEM_TOTAL float,
        @PURCHASE_NET float,
        @PURCHASE_NET_MONEY nvarchar(43),
        @PURCHASE_NET_2 float,
        @PURCHASE_EXTRA_COST_SYSTEM_2 float,
        @PURCHASE_NET_MONEY_2 nvarchar(43),
        @PURCHASE_EXTRA_COST float,
        @PURCHASE_NET_TOTAL float,
        @PRODUCT_NAME2 nvarchar(500),
        @FIRE_AMOUNT float,
        @IS_FREE_AMOUNT bit,
        @WRK_ROW_ID nvarchar(50),
        @WRK_ROW_RELATION_ID nvarchar(50),
        @WIDTH float,
        @HEIGHT float,
        @LENGTH float,
        @SPECIFIC_WEIGHT float,
        @WEIGHT float,
        @WORK_ID int,
        @WORK_HEAD nvarchar(50)
        
    AS
    BEGIN
        SET NOCOUNT ON;
    
        INSERT INTO
            PRODUCTION_ORDER_RESULTS_ROW
            (
                TREE_TYPE,
                TYPE,
                PR_ORDER_ID,
                BARCODE,
                STOCK_ID,
                PRODUCT_ID,
                AMOUNT,
                AMOUNT2,
                UNIT_ID,
                UNIT2,
                NAME_PRODUCT,
                UNIT_NAME,
                SPECT_ID,
                SPEC_MAIN_ID,
                SPECT_NAME,
                COST_ID,
                KDV_PRICE,
                PURCHASE_NET_SYSTEM,
                PURCHASE_NET_SYSTEM_MONEY,
                PURCHASE_EXTRA_COST_SYSTEM,
                PURCHASE_NET_SYSTEM_TOTAL,
                PURCHASE_NET,
                PURCHASE_NET_MONEY,
                PURCHASE_NET_2,
                PURCHASE_EXTRA_COST_SYSTEM_2,
                PURCHASE_NET_MONEY_2,
                PURCHASE_EXTRA_COST,
                PURCHASE_NET_TOTAL,
                PRODUCT_NAME2,
                FIRE_AMOUNT,
                IS_FREE_AMOUNT,
                WRK_ROW_ID,
                WRK_ROW_RELATION_ID,
                WIDTH,
                HEIGHT,
                LENGTH,
                SPECIFIC_WEIGHT,
                WEIGHT,
                WORK_ID,
                WORK_HEAD
            )
            VALUES
            (
                @TREE_TYPE,
                @TYPE,
                @PR_ORDER_ID,
                @BARCODE,
                @STOCK_ID,
                @PRODUCT_ID,
                @AMOUNT,
                @AMOUNT2,
                @UNIT_ID,
                @UNIT2,
                @NAME_PRODUCT,
                @UNIT_NAME,
                @SPECT_ID,
                @SPEC_MAIN_ID,
                @SPECT_NAME,
                @COST_ID,
                @KDV_PRICE,
                @PURCHASE_NET_SYSTEM,
                @PURCHASE_NET_SYSTEM_MONEY,
                @PURCHASE_EXTRA_COST_SYSTEM,
                @PURCHASE_NET_SYSTEM_TOTAL,
                @PURCHASE_NET,
                @PURCHASE_NET_MONEY,
                @PURCHASE_NET_2,
                @PURCHASE_EXTRA_COST_SYSTEM_2,
                @PURCHASE_NET_MONEY_2,
                @PURCHASE_EXTRA_COST,
                @PURCHASE_NET_TOTAL,
                @PRODUCT_NAME2,
                @FIRE_AMOUNT,
                @IS_FREE_AMOUNT,
                @WRK_ROW_ID,
                @WRK_ROW_RELATION_ID,
                @WIDTH,
                @HEIGHT,
                @LENGTH,
                @SPECIFIC_WEIGHT,
                @WEIGHT,
                @WORK_ID,
                @WORK_HEAD
            )
    END
</querytag>