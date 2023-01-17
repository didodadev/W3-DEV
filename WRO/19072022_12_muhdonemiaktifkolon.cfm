<!-- Description : Muhasebe dönemine Aktif - Pasif kolonu eklendi.
Developer: İlker Altındal
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='SETUP_PERIOD' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME= 'IS_ACTIVE')
    BEGIN
        ALTER TABLE SETUP_PERIOD ADD IS_ACTIVE bit
    END
</querytag>
