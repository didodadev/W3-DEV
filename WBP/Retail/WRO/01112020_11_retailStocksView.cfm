<!-- Description : Retail Stock View
Developer: Pınar Yıldız
Company : Workcube
Destination: Company -->
<querytag>
   
ALTER VIEW [STOCKS] AS
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
                PRODUCT.PRODUCT_STATUS,
                PRODUCT.PRODUCT_NAME,
                PRODUCT.PRODUCT_CODE,
                PRODUCT.PRODUCT_CODE_2,
                PRODUCT.BARCOD AS PRODUCT_BARCOD,
                ISNULL((SELECT PT.TAX FROM PRODUCT_TAX PT WHERE PT.PRODUCT_ID =  @_dsn_product_@.PRODUCT.PRODUCT_ID AND PT.OUR_COMPANY_ID = 1), @_dsn_product_@.PRODUCT.TAX) TAX,
                ISNULL((SELECT PT.OTV FROM PRODUCT_TAX PT WHERE PT.PRODUCT_ID =  @_dsn_product_@.PRODUCT.PRODUCT_ID AND PT.OUR_COMPANY_ID = 1), @_dsn_product_@.PRODUCT.OTV) OTV,
                ISNULL((SELECT PT.TAX_PURCHASE FROM PRODUCT_TAX PT WHERE PT.PRODUCT_ID =  @_dsn_product_@.PRODUCT.PRODUCT_ID AND PT.OUR_COMPANY_ID = 1), @_dsn_product_@.PRODUCT.TAX_PURCHASE) TAX_PURCHASE,
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
                PRODUCT.IS_LOT_NO,
                STOCKS.OLD_PRODUCT_ID,
                STOCKS.NEW_PRODUCT_ID,
                STOCKS.OLD_STOCK_ID,
                STOCKS.STOCK_IS_SALES,
                STOCKS.STOCK_IS_PURCHASE,
                STOCKS.STOCK_IS_PURCHASE_C,
                STOCKS.STOCK_IS_PURCHASE_M
        FROM   
                @_dsn_product_@.PRODUCT,
                @_dsn_product_@.STOCKS,
                @_dsn_product_@.PRODUCT_OUR_COMPANY
        WHERE     
                ( @_dsn_product_@.PRODUCT_OUR_COMPANY.OUR_COMPANY_ID = 1) AND
                @_dsn_product_@.PRODUCT.PRODUCT_ID =  @_dsn_product_@.PRODUCT_OUR_COMPANY.PRODUCT_ID AND
                @_dsn_product_@.STOCKS.PRODUCT_ID =  @_dsn_product_@.PRODUCT.PRODUCT_ID   
</querytag>
