<!-- Description : Ödeme yöntemi sayfasında kullanılmak için Setup_Paymethod tablosuna IS_DATE_CONTROL alanı açıldı. 
Developer: Ceren SARIAYDIN
Company : Workcube
Destination: Main -->
<querytag>
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PAYMETHOD' AND COLUMN_NAME = 'IS_DATE_CONTROL')
        BEGIN
        ALTER TABLE SETUP_PAYMETHOD ADD 
        IS_DATE_CONTROL [bit] NULL
        END;
		UPDATE SETUP_LANGUAGE_TR SET ITEM = 'Genel Tatil ve Hafta Tatilinde Vade İlk İş Gününe Ertelensin', ITEM_TR = 'Genel Tatil ve Hafta Tatilinde Vade İlk İş Gününe Ertelensin', ITEM_ENG = 'General Holiday and Week Holiday Maturity Postponed to First Business Day' WHERE DICTIONARY_ID = 46679 
</querytag>
