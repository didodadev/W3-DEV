<!-- Description : Employees Salary Tablosuna Şifreli Veriler için Alanlar Açıldı
Developer: Pınar Yıldız
Company : Workcube
Destination: Main -->
<querytag>
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EMPLOYEES_SALARY' AND COLUMN_NAME ='M1_ENC')
        BEGIN  
            ALTER TABLE EMPLOYEES_SALARY 
            ADD 
            M1_ENC nvarchar(250) NULL,
            M2_ENC nvarchar(250) NULL,
            M3_ENC nvarchar(250) NULL,
            M4_ENC nvarchar(250) NULL,
            M5_ENC nvarchar(250) NULL,
            M6_ENC nvarchar(250) NULL,
            M7_ENC nvarchar(250) NULL,
            M8_ENC nvarchar(250) NULL,
            M9_ENC nvarchar(250) NULL,
            M10_ENC nvarchar(250) NULL,
            M11_ENC nvarchar(250) NULL,
            M12_ENC nvarchar(250) NULL
        END;
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EMPLOYEES_SALARY_PLAN' AND COLUMN_NAME ='M1_ENC')
        BEGIN  
            ALTER TABLE EMPLOYEES_SALARY_PLAN 
            ADD 
            M1_ENC nvarchar(250) NULL,
            M2_ENC nvarchar(250) NULL,
            M3_ENC nvarchar(250) NULL,
            M4_ENC nvarchar(250) NULL,
            M5_ENC nvarchar(250) NULL,
            M6_ENC nvarchar(250) NULL,
            M7_ENC nvarchar(250) NULL,
            M8_ENC nvarchar(250) NULL,
            M9_ENC nvarchar(250) NULL,
            M10_ENC nvarchar(250) NULL,
            M11_ENC nvarchar(250) NULL,
            M12_ENC nvarchar(250) NULL
        END;
        
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EMPLOYEES_SALARY_HISTORY' AND COLUMN_NAME ='M1_ENC')
        BEGIN  
            ALTER TABLE EMPLOYEES_SALARY_HISTORY 
            ADD 
            M1_ENC nvarchar(250) NULL,
            M2_ENC nvarchar(250) NULL,
            M3_ENC nvarchar(250) NULL,
            M4_ENC nvarchar(250) NULL,
            M5_ENC nvarchar(250) NULL,
            M6_ENC nvarchar(250) NULL,
            M7_ENC nvarchar(250) NULL,
            M8_ENC nvarchar(250) NULL,
            M9_ENC nvarchar(250) NULL,
            M10_ENC nvarchar(250) NULL,
            M11_ENC nvarchar(250) NULL,
            M12_ENC nvarchar(250) NULL
        END;
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EMPLOYEES_PUANTAJ_ROWS' AND COLUMN_NAME ='SALARY_ENC')
        BEGIN  
            ALTER TABLE EMPLOYEES_PUANTAJ_ROWS 
            ADD 
            SALARY_ENC nvarchar(250) NULL,
            DAMGA_VERGISI_MATRAH_ENC nvarchar(250) NULL,
            KUMULATIF_GELIR_MATRAH_ENC nvarchar(250) NULL,
            TOTAL_SALARY_ENC nvarchar(250) NULL,
            TOTAL_AMOUNT_ENC nvarchar(250) NULL,
            NET_UCRET_ENC nvarchar(250) NULL,
            WEEKLY_AMOUNT_ENC nvarchar(250) NULL,
            WEEKEND_AMOUNT_ENC nvarchar(250) NULL,
            OFFDAYS_AMOUNT_ENC nvarchar(250) NULL
        END;
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='OUR_COMPANY_INFO' AND COLUMN_NAME ='IS_ENCRYPTED_SALARY')
        BEGIN  
            ALTER TABLE OUR_COMPANY_INFO 
            ADD IS_ENCRYPTED_SALARY BIT NULL
        END;
        UPDATE SETUP_LANGUAGE_TR SET ITEM = 'Çalışan Maaşları Şifreli Tutulsun',ITEM_TR= 'Çalışan Maaşları Şifreli Tutulsun',ITEM_ENG = 'Keep Employee Salaries Encrypted' WHERE DICTIONARY_ID = 54572
</querytag>