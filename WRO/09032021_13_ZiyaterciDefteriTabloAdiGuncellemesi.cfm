<!-- Description : Ziyaretçi Defteri tablo adı için güncelleme
Developer: Alper ÇİTMEN
Company : Workcube
Destination: Main-->
<querytag>

    IF EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='VISITOR_BOOK' AND COLUMN_NAME='DATE')
    BEGIN
        IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='VISITOR_BOOK' AND COLUMN_NAME='VISIT_DATE')
        BEGIN
            EXEC sp_rename 'VISITOR_BOOK.DATE', 'VISIT_DATE', 'COLUMN';
        END;
    END;

</querytag>

