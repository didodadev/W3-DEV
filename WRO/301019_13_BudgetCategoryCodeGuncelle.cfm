<!-- Description :Bütçe kategori sayfasında eski kategorilerde kategori kodu boş ise id sinin yazılacak şekilde update edilmesi sağlandı.
Developer: Melek KOCABEY
Company : Workcube
Destination: period-->
<querytag>
    IF EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='EXPENSE_CATEGORY' AND TABLE_SCHEMA = '@_dsn_period_@' )
    BEGIN
        UPDATE
            EXPENSE_CATEGORY
        SET 
            EXPENSE_CAT_CODE = EXPENSE_CAT_ID
        WHERE 
            EXPENSE_CAT_CODE IS NULL
    END;
 </querytag>