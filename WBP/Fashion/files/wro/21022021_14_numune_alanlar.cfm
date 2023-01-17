<!-- Description : Numuneye copya bilgisi, hedef miktar ve tutar alanları eklendi
Developer: Halit Yurttaş
Company : Workcube
Destination: COMPANY-->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_company_@' AND TABLE_NAME = 'TEXTILE_SAMPLE_REQUEST' AND COLUMN_NAME = 'AMOUNT_BSMV')
    BEGIN
    ALTER TABLE EXPENSE_ITEMS_ROWS ADD 
    AMOUNT_BSMV float
    END;

</querytag>