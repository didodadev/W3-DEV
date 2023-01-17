<!-- Description : Gelen-Giden Evrak Süreç alanı eklendi.
Developer: Melek KOCABEY
Company : Workcube
Destination: main -->
<querytag>  
    BEGIN
        IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' and TABLE_NAME='PAPER_CARGO_COURIER' AND COLUMN_NAME='PROCESS_STAGE')
        BEGIN   
            ALTER TABLE PAPER_CARGO_COURIER ADD PROCESS_STAGE int NULL 
        END;
    END;
</querytag>