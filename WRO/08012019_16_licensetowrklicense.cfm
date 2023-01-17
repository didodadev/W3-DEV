<!-- Description : LICENSE tablo ismi WRK_LICENSE olarak değiştirildi.
Developer: Esma Uysal
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='WRK_LICENSE' )
    BEGIN
        EXEC sp_rename 'LICENSE', 'WRK_LICENSE';
    END;
</querytag>