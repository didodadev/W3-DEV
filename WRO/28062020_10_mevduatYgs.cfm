<!-- Description : Vadeli Mevduat Ygs tanımı
Developer: İlker Altındal
Company : Workcube
Destination: Period -->

<querytag>  
    
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' and TABLE_NAME='INTEREST_YIELD_PLAN' AND COLUMN_NAME='YGS' )
    BEGIN   
        ALTER TABLE INTEREST_YIELD_PLAN ADD YGS int NULL 
    END;
   
</querytag>