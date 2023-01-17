<!-- Description : EXPENSE_ITEM_PLAN_REQUESTS tablosuna TREATED alanı eklendi
Developer: Gulbahar Inan
Company : Workcube
Destination: Main-->
<querytag>
   
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PROGRAM_PARAMETERS' AND COLUMN_NAME = 'EXPENSE_ITEM_ID')
        BEGIN
        ALTER TABLE SETUP_PROGRAM_PARAMETERS ADD 
        EXPENSE_ITEM_ID INT NULL
        END

</querytag>