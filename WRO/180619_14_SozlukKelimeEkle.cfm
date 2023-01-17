<!-- Description : Kebir Raporu için sözlüğe yeni dil eklenmiştir.
Developer: Melek Kocabey
Company : Workcube
Destination: Main-->
<querytag>
    UPDATE 
        SETUP_LANGUAGE_TR 
    SET 
        ITEM='Girilen kaydın başlangıç ve bitiş tarihi aynı çalışma dönemi içerisinde olmalıdır!',
        ITEM_TR='Girilen kaydın başlangıç ve bitiş tarihi aynı çalışma dönemi içerisinde olmalıdır!', 
        ITEM_ENG='The start and end date of the entered entry must be within the same working period!' 
    WHERE 
        DICTIONARY_ID = 55062    
</querytag>