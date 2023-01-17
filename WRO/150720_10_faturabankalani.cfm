<!-- Description : invoice ve historysine bank id alanı eklendi
Developer: İlker
Company : Workcube
Destination: period -->
<querytag>
    BEGIN
        IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' and TABLE_NAME='INVOICE' AND COLUMN_NAME='BANK_ID' )
        BEGIN   
            ALTER TABLE INVOICE ADD BANK_ID int NULL 
        END;
    END;

    BEGIN
        IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' and TABLE_NAME='INVOICE_HISTORY' AND COLUMN_NAME='BANK_ID' )
        BEGIN   
            ALTER TABLE INVOICE_HISTORY ADD BANK_ID int NULL 
        END;
    END;
</querytag>