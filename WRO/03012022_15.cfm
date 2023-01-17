<!-- Description : Projeler'de Google Drive proje klasörü oluşturmak için GOOGLE_PROJECT_FOLDER_ID kolonu eklendi.
Developer: Alper ÇİTMEN
Company : Workcube
Destination: main-->
<querytag>
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PRO_PROJECTS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'GOOGLE_PROJECT_FOLDER_ID')
        BEGIN
            ALTER TABLE PRO_PROJECTS ADD
            GOOGLE_PROJECT_FOLDER_ID nvarchar(200) NULL
        END;
</querytag>