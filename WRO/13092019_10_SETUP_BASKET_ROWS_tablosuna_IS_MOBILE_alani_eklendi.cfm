<!-- Description : SETUP_BASKET_ROWS tablosuna is_mobile alanı eklendi.
Developer: Ahmet Yolcu
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_BASKET_ROWS' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'IS_MOBILE')
    BEGIN
        ALTER TABLE SETUP_BASKET_ROWS ADD IS_MOBILE [bit] NULL
    END;
</querytag>