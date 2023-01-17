<!-- Description : OUR_COMPANY_INFO tablosunda IS_PURCHASE_ORDER_UPDATE bit alanı eklendi.
Developer: Emine Yılmaz
Company : Workcube
Destination: Main -->
<querytag>

    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='OUR_COMPANY_INFO' AND COLUMN_NAME='IS_PURCHASE_ORDER_UPDATE')
    BEGIN
        ALTER TABLE OUR_COMPANY_INFO 
        ADD IS_PURCHASE_ORDER_UPDATE [bit] NULL
    END;
 
    UPDATE OUR_COMPANY_INFO SET IS_PURCHASE_ORDER_UPDATE=1 WHERE IS_ORDER_UPDATE=1
   

</querytag>