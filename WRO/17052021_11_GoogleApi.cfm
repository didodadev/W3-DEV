<!-- Description : Şirket Akış parametrelerine Google API Key ve Google Dil kolonları eklendi.
Developer: Esma Uysal
Company : Workcube
Destination: Main -->
<querytag>
    
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='OUR_COMPANY_INFO' AND COLUMN_NAME='GOOGLE_API_KEY')
    BEGIN
        ALTER TABLE OUR_COMPANY_INFO ADD
        GOOGLE_API_KEY nvarchar(150) NULL
    END  
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='OUR_COMPANY_INFO' AND COLUMN_NAME='GOOGLE_LANGUAGE')
    BEGIN
        ALTER TABLE OUR_COMPANY_INFO ADD
        GOOGLE_LANGUAGE varchar(150) NULL
    END  
</querytag>
