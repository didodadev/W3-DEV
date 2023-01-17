<!-- Description : Add New Column for Old SGK Days in Employees Table
Developer: Esma R. Uysal
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES' AND COLUMN_NAME = 'OLD_SGK_DAYS')
    BEGIN
        ALTER TABLE EMPLOYEES ADD
        OLD_SGK_DAYS int NULL
    END;
    UPDATE SETUP_LANGUAGE_TR SET ITEM = 'Geçmiş SGK Gün', ITEM_TR = 'Geçmiş SGK Gün', ITEM_ENG = 'Old SGK Days' WHERE DICTIONARY_ID = 54358
</querytag>