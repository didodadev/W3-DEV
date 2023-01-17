<!-- Description :Bütçe kalemi güncelle sayfasında eski bütçe kalem kodu boş ise id sinin yazılacak şekilde update edilmesi sağlandı.
Developer: Melek KOCABEY
Company : Workcube
Destination: period-->
<querytag>
    IF EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='EXPENSE_ITEMS' AND TABLE_SCHEMA = '@_dsn_period_@' )
    BEGIN
        UPDATE
            EXPENSE_ITEMS
        SET 
            EXPENSE_ITEM_CODE = EXPENSE_ITEM_ID
        WHERE 
            EXPENSE_ITEM_CODE IS NULL
    END;
 </querytag>