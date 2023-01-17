<!-- Description : İş Kategorisi ve Toplantı Kategorisine ve Zaman harcamalarına Arge gününe dahil alanı eklendi
Developer: Esma R. Uysal
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PRO_WORK_CAT' AND COLUMN_NAME = 'IS_RD_SSK')
    BEGIN
        ALTER TABLE PRO_WORK_CAT ADD
        IS_RD_SSK int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EVENT_CAT' AND COLUMN_NAME = 'IS_RD_SSK')
    BEGIN
        ALTER TABLE EVENT_CAT ADD
        IS_RD_SSK int NULL
    END; 
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TIME_COST' AND COLUMN_NAME = 'IS_RD_SSK')
    BEGIN
        ALTER TABLE TIME_COST ADD
        IS_RD_SSK int NULL
    END;
</querytag>