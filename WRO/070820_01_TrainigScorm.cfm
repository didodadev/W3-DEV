<!-- Description : Eğitim Scorm Düzeltme
Developer: Yunus Özay
Company : Team
Destination: Main -->
<querytag>
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME='TRAINING_CLASS_SCO_DATA' AND COLUMN_NAME='RECORD_DATE' )
    BEGIN   
        ALTER TABLE TRAINING_CLASS_SCO_DATA ADD RECORD_DATE datetime NULL 
    END;
</querytag>