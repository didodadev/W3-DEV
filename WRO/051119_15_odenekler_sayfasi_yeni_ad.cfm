<!-- Description : Ödenekler - Görüntüleme  sayfa ismi Ek Ödenekler, Ücret Ödenek Tanım sayfa ismi Ücret Ödenek olarak değiştirildi.
Developer: Deniz Hamurpet
Company : Workcube
Destination: Main -->
<querytag>
    UPDATE WRK_OBJECTS SET HEAD = 'Ek Ödenekler' , DICTIONARY_ID = 53399 WHERE FULL_FUSEACTION='ehesap.list_payments'
    UPDATE WRK_OBJECTS SET HEAD = 'Ücret Ödenek' , DICTIONARY_ID = 56118 WHERE FULL_FUSEACTION='ehesap.list_salary'
</querytag>