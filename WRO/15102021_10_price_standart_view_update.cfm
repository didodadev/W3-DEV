<!-- Description : PRICE_STANDART view düzenlemesi yapıldı.
Developer: Uğur Hamurpet
Company : Workcube
Destination: Company -->

<querytag>
    ALTER VIEW [PRICE_STANDART] AS
    SELECT      
        @_dsn_product_@.PRICE_STANDART.*
    FROM   
        @_dsn_product_@.PRODUCT,
        @_dsn_product_@.PRICE_STANDART,
        @_dsn_product_@.PRODUCT_OUR_COMPANY
    WHERE     
        (@_dsn_product_@.PRODUCT_OUR_COMPANY.OUR_COMPANY_ID = @_companyid_@) AND
        @_dsn_product_@.PRODUCT.PRODUCT_ID = @_dsn_product_@.PRODUCT_OUR_COMPANY.PRODUCT_ID AND
        @_dsn_product_@.PRICE_STANDART.PRODUCT_ID = @_dsn_product_@.PRODUCT.PRODUCT_ID
</querytag>