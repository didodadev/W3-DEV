<!-- Description : kurumsal ve bireysel hesaplarda kep adres alanları eklendi.
Developer: İlker Altındal
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'COMPANY' AND COLUMN_NAME = 'COMPANY_KEP_ADDRESS')
    BEGIN
        ALTER TABLE COMPANY ADD
        COMPANY_KEP_ADDRESS NVARCHAR(250) NULL
    END;
    
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CONSUMER' AND COLUMN_NAME = 'CONSUMER_KEP_ADDRESS')
    BEGIN
        ALTER TABLE CONSUMER ADD
        CONSUMER_KEP_ADDRESS NVARCHAR(250) NULL
    END;

</querytag>