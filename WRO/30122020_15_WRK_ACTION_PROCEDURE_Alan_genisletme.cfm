<!-- Description : UPDATE_WRK_ACTION_PROCEDURE alana sığmayan fuseaction'lar için alan limiti arttırıldı
Developer: Mert Yüce
Company : Workcube
Destination: Main-->

<querytag>
    IF EXISTS (SELECT 'Y' FROM sys.schemas s WHERE schema_id in (SELECT schema_id FROM sys.objects WHERE  name = 'UPDATE_WRK_ACTION_PROCEDURE') AND name = '@_dsn_main_@')
    BEGIN
        EXEC('ALTER PROCEDURE [@_dsn_main_@].[UPDATE_WRK_ACTION_PROCEDURE]
            @USER_TYPE INT,
            @USER_ID INT,
            @ACTION_PAGE NTEXT,
            @ACTION_DATE DATETIME,
            @FUSEACTION NVARCHAR(MAX),
            @WORKCUBEID NVARCHAR(250)
        AS
        BEGIN
            SET NOCOUNT ON
        END')
    END
</querytag>