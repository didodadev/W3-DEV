<!-- Description :  WODIBA_RULE_SETS tablosuna IS_PROCESS_INVOICE_CLOSING ve INVOICE_CLOSING_PAYMENT_TOLERANS_VALUE alanları eklendi.
Developer: Fatih Ekin
Company : Gramoni
Destination: Main -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME='WODIBA_RULE_SETS' AND COLUMN_NAME='IS_PROCESS_INVOICE_CLOSING')
    BEGIN
        ALTER TABLE WODIBA_RULE_SETS
        ADD IS_PROCESS_INVOICE_CLOSING BIT NULL
    END;
	
	IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME='WODIBA_RULE_SETS' AND COLUMN_NAME ='INVOICE_CLOSING_PAYMENT_TOLERANS_VALUE')
    BEGIN
        ALTER TABLE WODIBA_RULE_SETS
		ADD INVOICE_CLOSING_PAYMENT_TOLERANS_VALUE FLOAT NULL
    END;
</querytag>