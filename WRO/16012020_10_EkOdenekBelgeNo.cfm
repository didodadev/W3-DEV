<!-- Description : Ek Ödenekler için genel Belge numarasında yeni kolonlar açıldı.
Developer: Esma Uysal
Company : Workcube
Destination: Main-->
<querytag>
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GENERAL_PAPERS_MAIN' AND COLUMN_NAME = 'ADDITIONAL_ALLOWANCE_NO')
        BEGIN
            ALTER TABLE GENERAL_PAPERS_MAIN ADD 
            ADDITIONAL_ALLOWANCE_NO nvarchar(50) NULL
        END;
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GENERAL_PAPERS_MAIN' AND COLUMN_NAME = 'ADDITIONAL_ALLOWANCE_NUMBER')
        BEGIN
            ALTER TABLE GENERAL_PAPERS_MAIN ADD 
            ADDITIONAL_ALLOWANCE_NUMBER INT NULL
        END;
</querytag>