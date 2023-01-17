<!-- Description :  PRO_WORKS tablosuna WORK_HEAD alanı alanı karakter sayısı arttırıldı.
Developer: Fatma Zehra Dere
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='PRO_WORKS' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME='WORK_HEAD')
    BEGIN
        ALTER TABLE PRO_WORKS 
        ALTER COLUMN WORK_HEAD nvarchar(250) NULL;
    END;
</querytag>
