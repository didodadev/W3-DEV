<!-- Description : Kısa çalışma ödeneğine bağlı yeni kolonlar eklenddi(Kısa çalışma oranı, İlk hafta Hessaplama)
Developer: Esma Uysal
Company : Workcube
Destination: main-->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'OFFTIME' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'SHORT_WORKING_HOURS')
    BEGIN
        ALTER TABLE OFFTIME ADD SHORT_WORKING_HOURS float
    END 
</querytag>