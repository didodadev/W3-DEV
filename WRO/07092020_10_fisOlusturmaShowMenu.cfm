 <!-- Description : Pos Fiş oluşturma sayfası show menüden çıkartıldı
Developer: Pınar Yıldız
Company : Workcube
Destination: Main -->
<querytag>
    IF EXISTS (
            SELECT WRK_OBJECTS_ID
            FROM WRK_OBJECTS
            WHERE FULL_FUSEACTION = 'pos.list_fileimports_total'
        )
    BEGIN
        UPDATE WRK_OBJECTS SET IS_MENU = 0 WHERE FULL_FUSEACTION = 'pos.list_fileimports_total'
    END
        
</querytag>