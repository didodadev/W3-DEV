<!-- Description : Yeniden Sipariş Noktasında Uyar, dili stock modulunde iki defa tanımlandığından dolayı biri silindi.Ve Unice Kodu sözlüğe eklendi.
Developer: Canan Ebret
Company : Workcube
Destination: Main-->
<querytag>
    UPDATE SETUP_LANGUAGE_TR SET ITEM='?', ITEM_TR='?', ITEM_ENG='?' WHERE DICTIONARY_ID = 45607
    UPDATE SETUP_LANGUAGE_TR SET ITEM='UNECE Kodu', ITEM_TR='UNECE Kodu', ITEM_ENG='UNECE Code' WHERE DICTIONARY_ID = 51014   
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Kalite Kontrol Başlangıç Tarihi', ITEM_TR='Kalite Kontrol Başlangıç Tarihi', ITEM_ENG='Quality Control Start Date' WHERE DICTIONARY_ID = 51015
</querytag>