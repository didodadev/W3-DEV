<!-- Description : 19.12.5 ile holistic sürümü tablolar ve kolon değişiklikleri
Developer: Fatih Kara
Company : Workcube
Destination: Period -->
<querytag>  
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME='EINVOICE_NUMBER')
    BEGIN
        CREATE TABLE [EINVOICE_NUMBER]([ID] int NOT NULL IDENTITY(1,1),[EINVOICE_PREFIX] nvarchar(50) NOT NULL, [EINVOICE_NUMBER] nvarchar(50) NULL);
    END;
</querytag>