<!-- Description : INSURANCE_RATIO tablosuna İmbat için Ücret Kuralı alanı Eklendi.
Developer: Muzaffer Köse
Company : Teknik Bilfi İşlem
Destination: main--> 
<querytag>    
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INSURANCE_RATIO' AND COLUMN_NAME = 'DEATH_INSURANCE_PREMIUM_WORKER_MADEN')
    BEGIN
        ALTER TABLE INSURANCE_RATIO ADD 
        DEATH_INSURANCE_PREMIUM_WORKER_MADEN float NULL
    END
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='INSURANCE_RATIO' AND COLUMN_NAME='DEATH_INSURANCE_PREMIUM_BOSS_MADEN')
    BEGIN     
        ALTER TABLE INSURANCE_RATIO ADD 
        DEATH_INSURANCE_PREMIUM_BOSS_MADEN float NULL
    END;
</querytag> 