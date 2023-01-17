<!-- Description : Vadeli Mevduat Getiri Satırları Eksik Alanlar
Developer: İlker Altındal
Company : Workcube
Destination: Period -->

<querytag>  
    
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INTEREST_YIELD_PLAN_ROWS' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'CHANGE_RATE')
    BEGIN
        ALTER TABLE INTEREST_YIELD_PLAN_ROWS ADD CHANGE_RATE int
    END;
    
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'INTEREST_YIELD_PLAN_ROWS' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'CHANGE_NEW_RATE')
    BEGIN
        ALTER TABLE INTEREST_YIELD_PLAN_ROWS ADD CHANGE_NEW_RATE float
    END;

</querytag>