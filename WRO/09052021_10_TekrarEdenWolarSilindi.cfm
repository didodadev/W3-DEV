<!-- Description : Tekrar eden woları sildirme işlemi yapıldı.
Developer: Botan Kayğan
Company : Workcube
Destination: Main-->

<querytag>     
    DELETE
    FROM
        WRK_OBJECTS
    WHERE
        WRK_OBJECTS_ID NOT IN (
            SELECT
                MIN(WRK_OBJECTS_ID)
            FROM
                WRK_OBJECTS
            GROUP BY
                FULL_FUSEACTION
        )
</querytag>