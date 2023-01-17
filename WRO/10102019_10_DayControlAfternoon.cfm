<!-- Description : İzin Süreleri sayfası için Öğleden Sonra Yarım günlük izin süresi aalanı açıldı.
Developer: Esma Uysal
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_OFFTIME_LIMIT' AND COLUMN_NAME = 'DAY_CONTROL_AFTERNOON')
    BEGIN
        ALTER TABLE SETUP_OFFTIME_LIMIT ADD
        DAY_CONTROL_AFTERNOON int NULL
    END;
</querytag>