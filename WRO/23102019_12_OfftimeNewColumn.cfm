<!-- Description : İzinler Tablosuna İptal edilen izinlerin tutulacağı kolon ve İzin İptal Et Dil queryleri.
Developer: Esma Uysal
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'OFFTIME' AND COLUMN_NAME = 'IS_CANCEL')
    BEGIN
        ALTER TABLE OFFTIME ADD
        IS_CANCEL bit NULL
    END;
    UPDATE SETUP_LANGUAGE_TR SET ITEM='İzni İptal Et', ITEM_TR='İzni İptal Et', ITEM_ENG='Cancel Your Dayoff' WHERE DICTIONARY_ID = 51675
    UPDATE SETUP_LANGUAGE_TR SET ITEM='İzini iptal etmek istediğinize emin misiniz?', ITEM_TR='İzini iptal etmek istediğinize emin misiniz?', ITEM_ENG='Are you sure cancel your dayoff?' WHERE DICTIONARY_ID = 51682  
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Yıllık İzin İptal Talepleri', ITEM_TR='Yıllık İzin İptal Talepleri', ITEM_ENG='Annual Leave Cancellation Requests' WHERE DICTIONARY_ID = 51691  
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Yıllık İzin İptal', ITEM_TR='Yıllık İzin İptal', ITEM_ENG='Annual Leave Cancellation' WHERE DICTIONARY_ID = 51693  
</querytag>