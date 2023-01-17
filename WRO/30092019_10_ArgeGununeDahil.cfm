<!-- Description : İzin ve Mazeret Kategorisi için ARGE gününe dahil kolonu eklendi.
Developer: Yunus Özay
Company : Team Yazılım
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_OFFTIME' AND COLUMN_NAME = 'IS_RD_SSK')
    BEGIN
        ALTER TABLE SETUP_OFFTIME ADD
        IS_RD_SSK bit NULL
    END;
</querytag>