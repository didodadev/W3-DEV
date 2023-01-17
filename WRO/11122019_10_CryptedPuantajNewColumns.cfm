
<!-- Description : Employees Puantaj Rows Tablosuna Şifreli Veriler için Alanlar Açıldı
Developer: Esme Uysal
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME ='GELIR_VERGISI_MATRAH_ENC')
    BEGIN 
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS ADD GELIR_VERGISI_MATRAH_ENC nvarchar(250) NULL
    END
</querytag>