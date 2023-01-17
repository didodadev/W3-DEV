<!-- Description : Gdpr Yetki Tanım Tablosu
Developer: Pınar Yıldız
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GDPR_SENSITIVITY_LABEL' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'SENSITIVITY_LABEL_NO')
    BEGIN
        ALTER TABLE GDPR_SENSITIVITY_LABEL
        ADD SENSITIVITY_LABEL_NO INT 
    END
</querytag>
