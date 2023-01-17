<!-- Description : Einvoice number tablosuna serileri sıralı şekilde takip edebilmek için order alanı eklendi.
Developer: Mahmut Çifçi
Company : Gramoni
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'ETRANSFORMATION_PREFIX' AND COLUMN_NAME = 'PREFIX_ORDER')
    BEGIN
        ALTER TABLE ETRANSFORMATION_PREFIX ADD PREFIX_ORDER int NULL
    END;
</querytag>