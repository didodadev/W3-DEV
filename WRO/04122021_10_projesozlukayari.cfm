<!-- Description :Projeye Sözlük Ayarı Eklendi.
Developer: Fatih Kara
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='PRO_PROJECTS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME='LANGUAGE_ID')
    BEGIN
        ALTER TABLE PRO_PROJECTS ADD LANGUAGE_ID INT NULL
    END;
</querytag>