<!-- Description : Company şemasındaki tablolara Price_standart kolonu eklendi
Developer: Mahmut Aslan
Company : Workcube
Destination: product-->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_product_@' AND TABLE_NAME = 'PRICE_STANDART' AND COLUMN_NAME = 'PROCESS_STAGE')
    BEGIN
    ALTER TABLE PRICE_STANDART ADD 
    PROCESS_STAGE  int
    END;

</querytag>