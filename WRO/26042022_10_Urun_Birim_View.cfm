<!-- Description : PRODUCT_UNIT view düzenlemesi yapıldı.
Developer: Fatih Kara
Company : Workcube
Destination: Company -->

<querytag>
    ALTER VIEW [PRODUCT_UNIT] AS
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
</querytag>