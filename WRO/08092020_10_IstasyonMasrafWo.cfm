 <!-- Description :İş İstasyonu Masraf Tanımları Listeleme Sayfası Pasife Çekildi
Developer: Pınar Yıldız
Company : Workcube
Destination: Main -->
<querytag>
    IF EXISTS (
            SELECT WRK_OBJECTS_ID
            FROM WRK_OBJECTS
            WHERE FULL_FUSEACTION = 'prod.list_workstation_expense'
        )
    BEGIN
        UPDATE WRK_OBJECTS SET IS_ACTIVE = 0 WHERE FULL_FUSEACTION = 'prod.list_workstation_expense'
    END
        
</querytag>