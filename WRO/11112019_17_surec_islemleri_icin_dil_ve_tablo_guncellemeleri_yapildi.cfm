<!-- Description : Sureç işlemleri için dil güncellemeleri yapıldı, yeni tablo kolonları oluşturuldu
Developer: Uğur Hamurpet
Company : Workcube
Destination: Main -->
<querytag>

    UPDATE SETUP_LANGUAGE_TR SET ITEM='Onay olmadan sonraki aşamaya geçme', ITEM_TR='Onay olmadan sonraki aşamaya geçme', ITEM_ENG='Proceed to the next stage without approval'  WHERE DICTIONARY_ID = 30386
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Tekrar Yap', ITEM_TR='Tekrar Yap', ITEM_ENG='Do it Again'  WHERE DICTIONARY_ID = 57214
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Başkasına Gönder', ITEM_TR='Başkasına Gönder', ITEM_ENG='Send to someone else' WHERE DICTIONARY_ID = 57218
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Destek Al', ITEM_TR='Destek Al', ITEM_ENG='Get Support'  WHERE DICTIONARY_ID = 57226
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Sonraki aşamalar değiştirilmesin', ITEM_TR='Sonraki aşamalar değiştirilmesin', ITEM_ENG='Do not change subsequent stages'  WHERE DICTIONARY_ID = 30454
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Süreç Grubu', ITEM_TR='Süreç Grubu', ITEM_ENG='Process Group'  WHERE DICTIONARY_ID = 31787
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Yapmakta olduğunuz bu işlem şirketinizi ve sizi bağlayacak konular içerebilir.', ITEM_TR='Yapmakta olduğunuz bu işlem şirketinizi ve sizi bağlayacak konular içerebilir.', ITEM_ENG='This may include issues that may interest you and your company.'  WHERE DICTIONARY_ID = 31762
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Devam etmek istediğinize emin misiniz', ITEM_TR='Devam etmek istediğinize emin misiniz', ITEM_ENG='Are you sure you want to continue'  WHERE DICTIONARY_ID = 31761
    UPDATE SETUP_LANGUAGE_TR SET ITEM='1.Amirden onay al', ITEM_TR='1.Amirden onay al', ITEM_ENG='Get approval from first supervisor'  WHERE DICTIONARY_ID = 33648
    UPDATE SETUP_LANGUAGE_TR SET ITEM='2.Amirden onay al', ITEM_TR='2.Amirden onay al', ITEM_ENG='Get approval from second supervisor'  WHERE DICTIONARY_ID = 33647
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Onaydan sonra sonraki aşamaya geç', ITEM_TR='Onaydan sonra sonraki aşamaya geç', ITEM_ENG='Proceed to next stage after approval'  WHERE DICTIONARY_ID = 33646
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Bu aşamada amir onayları istendiğinden aşama yetkileri tanımlanamaz', ITEM_TR='Bu aşamada amir onayları istendiğinden aşama yetkileri tanımlanamaz', ITEM_ENG='Stage authorizations cannot be defined at this stage because supervisor requests approvals'  WHERE DICTIONARY_ID = 33659
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Onay İste', ITEM_TR='Onay İste', ITEM_ENG='Request Approval'  WHERE DICTIONARY_ID = 30389
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Tüm checkerlar onaylasın', ITEM_TR='Tüm checkerlar onaylasın', ITEM_ENG='All Checkers Approval'  WHERE DICTIONARY_ID = 30457

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROCESS_TYPE_ROWS' AND COLUMN_NAME = 'IS_AGAIN')
    BEGIN
    ALTER TABLE PROCESS_TYPE_ROWS ADD
    IS_AGAIN bit NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROCESS_TYPE_ROWS' AND COLUMN_NAME = 'IS_SUPPORT')
    BEGIN
    ALTER TABLE PROCESS_TYPE_ROWS ADD
    IS_SUPPORT bit NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROCESS_TYPE_ROWS' AND COLUMN_NAME = 'IS_CANCEL')
    BEGIN
    ALTER TABLE PROCESS_TYPE_ROWS ADD
    IS_CANCEL bit NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROCESS_TYPE_ROWS' AND COLUMN_NAME = 'IS_APPROVE_ALL_CHECKERS')
    BEGIN
    ALTER TABLE PROCESS_TYPE_ROWS ADD
    IS_APPROVE_ALL_CHECKERS bit NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROCESS_TYPE_ROWS' AND COLUMN_NAME = 'IS_CONFIRM_FIRST_CHIEF')
    BEGIN
    ALTER TABLE PROCESS_TYPE_ROWS ADD
    IS_CONFIRM_FIRST_CHIEF bit NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROCESS_TYPE_ROWS' AND COLUMN_NAME = 'IS_CONFIRM_SECOND_CHIEF')
    BEGIN
    ALTER TABLE PROCESS_TYPE_ROWS ADD
    IS_CONFIRM_SECOND_CHIEF bit NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROCESS_TYPE_ROWS' AND COLUMN_NAME = 'IS_REFUSE')
    BEGIN
    ALTER TABLE PROCESS_TYPE_ROWS ADD
    IS_REFUSE bit NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROCESS_TYPE_ROWS' AND COLUMN_NAME = 'IS_CONFIRM_STAGE_ID')
    BEGIN
    ALTER TABLE PROCESS_TYPE_ROWS ADD
    IS_CONFIRM_STAGE_ID int NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROCESS_TYPE_ROWS' AND COLUMN_NAME = 'IS_REFUSE_STAGE_ID')
    BEGIN
    ALTER TABLE PROCESS_TYPE_ROWS ADD
    IS_REFUSE_STAGE_ID int NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROCESS_TYPE_ROWS' AND COLUMN_NAME = 'IS_AGAIN_STAGE_ID')
    BEGIN
    ALTER TABLE PROCESS_TYPE_ROWS ADD
    IS_AGAIN_STAGE_ID int NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROCESS_TYPE_ROWS' AND COLUMN_NAME = 'IS_SUPPORT_STAGE_ID')
    BEGIN
    ALTER TABLE PROCESS_TYPE_ROWS ADD
    IS_SUPPORT_STAGE_ID int NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROCESS_TYPE_ROWS' AND COLUMN_NAME = 'IS_CANCEL_STAGE_ID')
    BEGIN
    ALTER TABLE PROCESS_TYPE_ROWS ADD
    IS_CANCEL_STAGE_ID int NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROCESS_TYPE_ROWS' AND COLUMN_NAME = 'TEMPLATE_WO')
    BEGIN
    ALTER TABLE PROCESS_TYPE_ROWS ADD
    TEMPLATE_WO nvarchar(MAX) NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PROCESS_TYPE_ROWS' AND COLUMN_NAME = 'TEMPLATE_PRINT_ID')
    BEGIN
    ALTER TABLE PROCESS_TYPE_ROWS ADD
    TEMPLATE_PRINT_ID int NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PAGE_WARNINGS' AND COLUMN_NAME = 'IS_AGAIN')
    BEGIN
    ALTER TABLE PAGE_WARNINGS ADD
    IS_AGAIN bit NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PAGE_WARNINGS' AND COLUMN_NAME = 'IS_SUPPORT')
    BEGIN
    ALTER TABLE PAGE_WARNINGS ADD
    IS_SUPPORT bit NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PAGE_WARNINGS' AND COLUMN_NAME = 'IS_CANCEL')
    BEGIN
    ALTER TABLE PAGE_WARNINGS ADD
    IS_CANCEL bit NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PAGE_WARNINGS' AND COLUMN_NAME = 'IS_REFUSE')
    BEGIN
    ALTER TABLE PAGE_WARNINGS ADD
    IS_REFUSE bit NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PAGE_WARNINGS' AND COLUMN_NAME = 'IS_APPROVE_ALL_CHECKERS')
    BEGIN
    ALTER TABLE PAGE_WARNINGS ADD
    IS_APPROVE_ALL_CHECKERS bit NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PAGE_WARNINGS' AND COLUMN_NAME = 'IS_CONFIRM_FIRST_CHIEF')
    BEGIN
    ALTER TABLE PAGE_WARNINGS ADD
    IS_CONFIRM_FIRST_CHIEF bit NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PAGE_WARNINGS' AND COLUMN_NAME = 'IS_CONFIRM_SECOND_CHIEF')
    BEGIN
    ALTER TABLE PAGE_WARNINGS ADD
    IS_CONFIRM_SECOND_CHIEF bit NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PAGE_WARNINGS' AND COLUMN_NAME = 'POSITION_CODE_CC')
    BEGIN
    ALTER TABLE PAGE_WARNINGS ADD
    POSITION_CODE_CC bit NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PAGE_WARNINGS' AND COLUMN_NAME = 'SENDER_POSITION_CODE')
    BEGIN
    ALTER TABLE PAGE_WARNINGS ADD
    SENDER_POSITION_CODE bit NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PAGE_WARNINGS_ACTIONS' AND COLUMN_NAME = 'IS_AGAIN')
    BEGIN
    ALTER TABLE PAGE_WARNINGS_ACTIONS ADD
    IS_AGAIN bit NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PAGE_WARNINGS_ACTIONS' AND COLUMN_NAME = 'IS_SUPPORT')
    BEGIN
    ALTER TABLE PAGE_WARNINGS_ACTIONS ADD
    IS_SUPPORT bit NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PAGE_WARNINGS_ACTIONS' AND COLUMN_NAME = 'IS_CANCEL')
    BEGIN
    ALTER TABLE PAGE_WARNINGS_ACTIONS ADD
    IS_CANCEL bit NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PAGE_WARNINGS_ACTIONS' AND COLUMN_NAME = 'IS_REFUSE')
    BEGIN
    ALTER TABLE PAGE_WARNINGS_ACTIONS ADD
    IS_REFUSE bit NULL
    END;

</querytag>