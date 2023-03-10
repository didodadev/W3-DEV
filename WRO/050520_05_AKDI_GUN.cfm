<!-- Description : EMPLOYEE_DAILY_IN_OUT ve EMPLOYEES_PUANTAJ_ROWS  tablosuna İmbat için Akdi Günün W3 sisteminse dahil edilmesi için yeni alanları eklenmiştir
Developer: Muzaffer Köse
Company : Teknik Bilfi İşlem 
Destination: main-->
<querytag>    
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEE_DAILY_IN_OUT' AND COLUMN_NAME = 'WEEKEND_DAY_MULTIPLIER')
    BEGIN
        ALTER TABLE EMPLOYEE_DAILY_IN_OUT ADD 
        IS_AKDI_DAY  int NULL
    END
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME='AKDI_DAY')
    BEGIN     
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS  ADD 
        AKDI_DAY float NULL
    END;
      IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME='AKDI_HOUR')
    BEGIN     
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS  ADD 
        AKDI_HOUR float NULL
    END;
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME='AKDI_AMOUNT')
    BEGIN     
        ALTER TABLE EMPLOYEES_PUANTAJ_ROWS  ADD 
        AKDI_AMOUNT float NULL
    END;
    
</querytag> 