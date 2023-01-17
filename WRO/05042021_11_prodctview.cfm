<!-- Description : PRODUCT view düzenlemesi
Developer: ilker Altındal
Company : Workcube
Destination: Company -->

<querytag>
    ALTER VIEW [PRODUCT] AS
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
                ISNULL((SELECT PT.TAX FROM PRODUCT_TAX PT WHERE PT.PRODUCT_ID = @_dsn_product_@.PRODUCT.PRODUCT_ID AND PT.OUR_COMPANY_ID=@_companyid_@),@_dsn_product_@.PRODUCT.TAX) TAX,
                ISNULL((SELECT PT.TAX_PURCHASE FROM PRODUCT_TAX PT WHERE PT.PRODUCT_ID = @_dsn_product_@.PRODUCT.PRODUCT_ID AND PT.OUR_COMPANY_ID=@_companyid_@),@_dsn_product_@.PRODUCT.TAX_PURCHASE) TAX_PURCHASE,
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
                ISNULL((SELECT PT.OTV FROM PRODUCT_TAX PT WHERE PT.PRODUCT_ID = @_dsn_product_@.PRODUCT.PRODUCT_ID AND PT.OUR_COMPANY_ID = @_companyid_@),@_dsn_product_@.PRODUCT.OTV) OTV,
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
                ORIGIN_ID
        FROM          
                @_dsn_product_@.PRODUCT,
                @_dsn_product_@.PRODUCT_OUR_COMPANY
        WHERE     
                (@_dsn_product_@.PRODUCT_OUR_COMPANY.OUR_COMPANY_ID = @_companyid_@) AND
                @_dsn_product_@.PRODUCT.PRODUCT_ID = @_dsn_product_@.PRODUCT_OUR_COMPANY.PRODUCT_ID
</querytag>