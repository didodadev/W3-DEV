<!-- Description : Added a new column which named IS_MANDATE to PAGE_WARNINGS
Developer: Uğur Hamurpet
Company : Workcube
Destination: Main-->
<querytag>   
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='PAGE_WARNINGS' AND COLUMN_NAME='IS_MANDATE')
    BEGIN
        ALTER TABLE PAGE_WARNINGS ADD 
        IS_MANDATE bit NULL;
    END;
</querytag>