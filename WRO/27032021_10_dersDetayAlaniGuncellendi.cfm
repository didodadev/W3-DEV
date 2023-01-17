<!-- Description : Ders detay alanında karakter sorunu yaşanıyordu. nvarchar(MAX) olarak güncellendi.
Developer: Alper ÇİTMEN
Company : Workcube
Destination: Main -->
<querytag>
    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TRAINING_CLASS' AND COLUMN_NAME = 'PROCESS_STAGE')
    BEGIN
        ALTER TABLE TRAINING_CLASS 
        ALTER COLUMN CLASS_OBJECTIVE NVARCHAR(MAX) NULL
    END;
</querytag>