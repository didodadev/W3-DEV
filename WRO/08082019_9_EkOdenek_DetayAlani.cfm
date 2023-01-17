<!-- Description : Çalışan ücret kartındaki Ek Ödenekler için detay alanı eklendi.
Developer: Esma Uysal
Company : Workcube
Destination: Main -->
<querytag>
     IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='SALARYPARAM_PAY' AND COLUMN_NAME='DETAIL')
        BEGIN
            ALTER TABLE SALARYPARAM_PAY ADD  DETAIL nvarchar(250)
        END;
</querytag>