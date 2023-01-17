<!-- Description : Menkul kıymet Ygs tanımı
Developer: İlker Altındal
Company : Workcube
Destination: Company -->

<querytag>  
    
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='STOCKBONDS' AND COLUMN_NAME='YGS' )
    BEGIN   
        ALTER TABLE STOCKBONDS ADD YGS int NULL 
    END;

    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='STOCKBONDS_SALEPURCHASE_ROW' AND COLUMN_NAME='YGS' )
    BEGIN   
        ALTER TABLE STOCKBONDS_SALEPURCHASE_ROW ADD YGS int NULL 
    END;
   
</querytag>