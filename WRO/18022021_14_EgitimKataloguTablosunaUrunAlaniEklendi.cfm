<!-- Description :  Egitim tablosuna tablosuna Product_ID alanı eklendi
Developer: Gülbahar İnan
Company : Workcube
Destination: main -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='TRAINING' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME='PRODUCT_ID')
    BEGIN
        ALTER TABLE TRAINING
        ADD PRODUCT_ID INT NULL
    END;
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='TRAINING' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME='TOTAL_HOURS')
    BEGIN
        ALTER TABLE TRAINING
        ADD TOTAL_HOURS INT NULL
    END;
</querytag>