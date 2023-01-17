<!-- Description : WOJ_FUSEACTION alan özellikleri değiştirildi
Developer: Uğur Hamurpet
Company : Workcube
Destination: Main -->
<querytag>
    IF EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='WRK_OUTPUT_JOB' AND COLUMN_NAME ='WOJ_FUSEACTION' )
    BEGIN 
        ALTER TABLE WRK_OUTPUT_JOB 
        ALTER COLUMN WOJ_FUSEACTION nvarchar(200) NULL
    END;
</querytag>
