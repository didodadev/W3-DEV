<!-- Description : Anlaşmalı Kurum Faturalarına pozisyon kodu bilgisi eklendi
Developer: Pınar Yıldız
Company : Workcube
Destination: Period -->
<querytag>
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EXPENSE_ITEM_PLANS' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME= 'POSITION_CODE')
    BEGIN
        ALTER TABLE EXPENSE_ITEM_PLANS ADD POSITION_CODE INT
    END
</querytag>
