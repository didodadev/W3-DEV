<!-- Description : Üretim sonuç satırları fire
Developer: Fatih Kara
Company : Workcube
Destination: Company-->
<querytag>
    ALTER PROCEDURE [ADD_PRODUCTION_ORDER_RESULTS_ROW_O]
        @TYPE int,
        @PR_ORDER_ID int,
        @BARCODE nvarchar(43),
        @STOCK_ID int,
        @PRODUCT_ID int,
        @LOT_NO nvarchar(100),
        @AMOUNT float,
        @AMOUNT2 float,
        @UNIT_ID int,
        @UNIT2 nvarchar(50),
        @SERIAL_NO nvarchar(50),
        @NAME_PRODUCT nvarchar(500),
        @UNIT_NAME nvarchar(65),
        @IS_SEVKIYAT bit,
        @SPECT_ID int,
        @SPEC_MAIN_ID int,
        @SPECT_NAME nvarchar(500) ,
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
        @WRK_ROW_ID nvarchar(50),
        @WRK_ROW_RELATION_ID nvarchar(50),
        @LINE_NUMBER int,
        @IS_MANUAL_COST bit,
        @EXPIRATION_DATE datetime,
        @WIDTH float,
        @HEIGHT float,
        @LENGTH float,
        @SPECIFIC_WEIGHT float,
        @WEIGHT float
    AS
        BEGIN
            SET NOCOUNT ON;
                INSERT INTO
                        PRODUCTION_ORDER_RESULTS_ROW
                        (
                            TYPE,
                            PR_ORDER_ID,
                            BARCODE,
                            STOCK_ID,
                            PRODUCT_ID,
                            LOT_NO,
                            AMOUNT,
                            AMOUNT2,
                            UNIT_ID,
                            UNIT2,
                            SERIAL_NO,
                            NAME_PRODUCT,
                            UNIT_NAME,
                            IS_SEVKIYAT,
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
                            WRK_ROW_ID,
                            WRK_ROW_RELATION_ID,
                            LINE_NUMBER,
                            IS_MANUAL_COST,
                            EXPIRATION_DATE,
                            WIDTH,
                            HEIGHT,
                            LENGTH,
                            SPECIFIC_WEIGHT,
                            WEIGHT
                        )
                        VALUES
                        (
                            @TYPE,
                            @PR_ORDER_ID,
                            @BARCODE,
                            @STOCK_ID,
                            @PRODUCT_ID,
                            @LOT_NO,
                            @AMOUNT,
                            @AMOUNT2,
                            @UNIT_ID,
                            @UNIT2,
                            @SERIAL_NO,
                            @NAME_PRODUCT,
                            @UNIT_NAME,
                            @IS_SEVKIYAT,
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
                            @WRK_ROW_ID,
                            @WRK_ROW_RELATION_ID,
                            @LINE_NUMBER,
                            @IS_MANUAL_COST,
                            @EXPIRATION_DATE,
                            @WIDTH,
                            @HEIGHT,
                            @LENGTH,
                            @SPECIFIC_WEIGHT,
                            @WEIGHT
                        )
    END
</querytag>