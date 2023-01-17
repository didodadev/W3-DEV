<!-- Description : WRK_OBJECTS tablosuna IS_ONLY_SHOW_PAGE kolonu eklendi.
Developer: Canan Ebret
Company : Workcube
Destination: Main -->
<querytag>
        IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='WRK_OBJECTS' AND COLUMN_NAME ='IS_ONLY_SHOW_PAGE')
        BEGIN 
        ALTER TABLE WRK_OBJECTS ADD IS_ONLY_SHOW_PAGE bit
        END;
</querytag>            