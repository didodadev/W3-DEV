<!-- Description : GET_FUSEACTION_FROM_WRK_APP procedure düzenlendi
Developer: Uğur Hamurpet
Company : Workcube
Destination: Main-->
<querytag>
    ALTER PROCEDURE [GET_FUSEACTION_FROM_WRK_APP] 
        @PERIOD_ID NVARCHAR(9),
        @COMPANY_ID NVARCHAR(9),
        @FUSEACTION NVARCHAR(MAX),
        @ACTION_PAGE NVARCHAR(MAX)
            
    AS
    BEGIN
        DECLARE @SQL NVARCHAR(MAX)
        SET NOCOUNT OFF;
        SET @SQL = '	
            SELECT
                    USERID,
                    ACTION_PAGE, 
                    IS_ONLY_SHOW_PAGE,
                    NAME,
                    SURNAME,
                    COMPANY_ID,
                    ACTION_PAGE_Q_STRING
                FROM 
                    WRK_SESSION
                WHERE  '		 
                IF (LEN(@PERIOD_ID) > 0)
                    BEGIN 
                        SET @SQL +=' PERIOD_ID = '+@PERIOD_ID+' AND'
                    END
                ELSE
                    BEGIN 
                        IF (LEN(@COMPANY_ID)>0 )
                            BEGIN
                                SET @SQL +='COMPANY_ID ='+@COMPANY_ID+'AND '	
                            END	
                                    
                    END	
                
                SET @SQL +='(
                                FUSEACTION	LIKE '''+@FUSEACTION+''' OR
                                ACTION_PAGE	LIKE '''+@ACTION_PAGE+'''
                            )'         
    exec (@SQL);
    END
</querytag>