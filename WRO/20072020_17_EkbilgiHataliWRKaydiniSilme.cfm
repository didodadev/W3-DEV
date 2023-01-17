<!-- Description : Ek bilgi ile ilgili  hatalı WRO kaydını siler
Developer: Gülbahar Inan
Company : Workcube
Destination: Main  -->
<querytag>
    DELETE FROM WRK_DBUPGRADE_SCRIPTS WHERE FILE_NAME LIKE '%10072020_14_EkbilgiSecenekSayısıArtırma_main.cfm%'

    DELETE FROM WRK_DBUPGRADE_SCRIPTS WHERE FILE_NAME LIKE '%10072020_14_EkbilgiSecenekSayısıArtırma_company.cfm%'
</querytag>
