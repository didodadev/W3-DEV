CREATE PROCEDURE [@_dsn_main_@].[ADD_PERFORMANCE_COUNTER]
                    @BODY_TEXT NVARCHAR(MAX),
                    @DATASOURCE nvarchar(1000),
                    @TEMPLATE nvarchar(1000),
                    @EXECUTIONTIME FLOAT,
                    @TIME nvarchar(50),
                    @ROWCOUNT INT,
                    @USER_ID INT		
                AS
                BEGIN
                    SET NOCOUNT ON;
                
                IF NOT EXISTS (SELECT PERFORMANCE_COUNTER_ID FROM WRK_PERFORMANCE_COUNTER WHERE TEMPLATE = @TEMPLATE  )  
                BEGIN 
                INSERT INTO [WRK_PERFORMANCE_COUNTER]
                           (
                            [BODY_TEXT]
                           ,[DATASOURCE]
                           ,[TEMPLATE]
                           ,[EXECUTIONTIME]
                           ,[TIME]
                           ,[ROWCOUNT]
                           ,[USER_ID]
                           )
                     VALUES
                           (
                           @BODY_TEXT,
                            @DATASOURCE,
                           @TEMPLATE,
                           @EXECUTIONTIME,
                           @TIME,
                           @ROWCOUNT,
                           @USER_ID
                           )
                END
                END

CREATE PROCEDURE [@_dsn_main_@].[EMAIL_TYPE_CONTROL] 
				@EMAIL NVARCHAR(200)
			AS
			BEGIN
			DECLARE @SQL_ NVARCHAR(500),@ParmDefinition nvarchar(300),@RELATION_TYPE_IID INT,@RELATION_TYPEE NVARCHAR(100)
				IF EXISTS (SELECT COMPANY_ID FROM COMPANY WHERE COMPANY_EMAIL=@EMAIL)
					BEGIN
						SET @SQL_ = N'SELECT @RELATION_TYPE_ID =COMPANY_ID
						FROM COMPANY
						WHERE COMPANY_EMAIL = @COMPANY_EMAIL';
						SET @ParmDefinition = N'@COMPANY_EMAIL NVARCHAR(100),
						@RELATION_TYPE_ID INT OUTPUT ';
						SET @RELATION_TYPEE='COMPANY_ID'
						EXECUTE sp_executesql
						@SQL_
						,@ParmDefinition
						,@COMPANY_EMAIL = @EMAIL
						,@RELATION_TYPE_ID = @RELATION_TYPE_IID OUTPUT;
						SELECT @RELATION_TYPE_IID AS RELATION_TYPE_ID,@RELATION_TYPEE AS RELATION_TYPE
					END
				ELSE
					BEGIN
						IF EXISTS (SELECT COMPANY_ID FROM COMPANY_PARTNER WHERE COMPANY_PARTNER_EMAIL=@EMAIL)
							BEGIN
								SET @SQL_ = N'SELECT @RELATION_TYPE_ID =PARTNER_ID
								FROM COMPANY_PARTNER
								WHERE COMPANY_PARTNER_EMAIL = @COMPANY_EMAIL';
								SET @ParmDefinition = N'@COMPANY_EMAIL NVARCHAR(100),
								@RELATION_TYPE_ID INT OUTPUT ';
								SET @RELATION_TYPEE='PARTNER_ID'
								EXECUTE sp_executesql
								@SQL_
								,@ParmDefinition
								,@COMPANY_EMAIL = @EMAIL
								,@RELATION_TYPE_ID = @RELATION_TYPE_IID OUTPUT;
								SELECT @RELATION_TYPE_IID AS RELATION_TYPE_ID,@RELATION_TYPEE AS RELATION_TYPE
							END
						ELSE 
							BEGIN
								IF EXISTS (SELECT CONSUMER_ID FROM CONSUMER WHERE CONSUMER_EMAIL=@EMAIL)
									BEGIN
										SET @SQL_ = N'SELECT @RELATION_TYPE_ID =CONSUMER_ID
										FROM CONSUMER
										WHERE CONSUMER_EMAIL = @COMPANY_EMAIL';
										SET @ParmDefinition = N'@COMPANY_EMAIL NVARCHAR(100),
										@RELATION_TYPE_ID INT OUTPUT ';
										SET @RELATION_TYPEE='CONSUMER_ID'
										EXECUTE sp_executesql
										@SQL_
										,@ParmDefinition
										,@COMPANY_EMAIL = @EMAIL
										,@RELATION_TYPE_ID = @RELATION_TYPE_IID OUTPUT;
										SELECT @RELATION_TYPE_IID AS RELATION_TYPE_ID,@RELATION_TYPEE AS RELATION_TYPE
									END
								ELSE
									BEGIN
										IF EXISTS (SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_EMAIL=@EMAIL)
											BEGIN
												SET @SQL_ = N'SELECT @RELATION_TYPE_ID =EMPLOYEE_ID
												FROM EMPLOYEES
												WHERE EMPLOYEE_EMAIL = @COMPANY_EMAIL';
												SET @ParmDefinition = N'@COMPANY_EMAIL NVARCHAR(100),
												@RELATION_TYPE_ID INT OUTPUT ';
												SET @RELATION_TYPEE='EMPLOYEE_ID'
												EXECUTE sp_executesql
												@SQL_
												,@ParmDefinition
												,@COMPANY_EMAIL = @EMAIL
												,@RELATION_TYPE_ID = @RELATION_TYPE_IID OUTPUT;
												SELECT @RELATION_TYPE_IID AS RELATION_TYPE_ID,@RELATION_TYPEE AS RELATION_TYPE
											END
										ELSE
											BEGIN
												SELECT NULL AS RELATION_TYPE_ID,NULL AS RELATION_TYPE
											END	
									END						
							END
								
					END	
			END

CREATE PROCEDURE [@_dsn_main_@].[FAVOUTIRES] 
				 @user_id int
				AS  
				BEGIN     
					SELECT 
						FAVORITE_SHORTCUT_KEY,
						FAVORITE_NAME,
						IS_NEW_PAGE,
						FAVORITE
					FROM 
						FAVORITES
					WHERE
						EMP_ID = @user_id
					ORDER BY 
						FAVORITE_NAME
				END

CREATE PROCEDURE [@_dsn_main_@].[GET_FUSEACTION_FROM_WRK_APP] 
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
                        
                        SET @SQL +='   
                                            (
                                                FUSEACTION	LIKE '''+@FUSEACTION+''' OR
                                                ACTION_PAGE	LIKE '''+@ACTION_PAGE+'''
                                            )'
                            
            exec (@SQL);
            END

CREATE PROCEDURE [@_dsn_main_@].[GET_FUSEACTION_FROM_WRK_APP1] 
                                    @PERIOD_ID NVARCHAR(9),
                                    @COMPANY_ID NVARCHAR(9),
                                    @FUSEACTION NVARCHAR(200),
                                    @ACTION_PAGE NVARCHAR(200)
                                        
                                AS
                                BEGIN
                                    DECLARE @SQL NVARCHAR(1000)
                                    SET NOCOUNT OFF;
                                    SET @SQL = '	
                                        SELECT
                                                USERID,
                                                ACTION_PAGE, 
                                                IS_ONLY_SHOW_PAGE,
                                                NAME,
                                                SURNAME,
												COMPANY_ID
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
                                            
                                            SET @SQL +='   
                                                                (
                                                                    FUSEACTION	LIKE '''+@FUSEACTION+''' OR
                                                                    ACTION_PAGE	LIKE '''+@ACTION_PAGE+'''
                                                                )'
                                                
                                PRINT (@SQL);
                                END

CREATE PROCEDURE [@_dsn_main_@].[GET_LANGUAGE] 
			@LANGUAGE_NAME NVARCHAR(3), 
			@MODULE_ID NVARCHAR(32)
			AS
			DECLARE @QUERY_STRING NVARCHAR(1000)
			SET @QUERY_STRING = '
			SELECT
			ITEM
			FROM
			SETUP_LANGUAGE_'
			SET @QUERY_STRING = @QUERY_STRING + @LANGUAGE_NAME
			SET @QUERY_STRING = @QUERY_STRING + '
			WHERE
			MODULE_ID = '
			SET @QUERY_STRING = @QUERY_STRING + ''' + @MODULE_ID + '''
			SET @QUERY_STRING = @QUERY_STRING + '
			ORDER BY
			ITEM_ID'
			EXEC (@QUERY_STRING)

CREATE PROCEDURE [@_dsn_main_@].[GET_MAIN_MENU_SETTINGS]
                 
                    @MENU_ID INT 
                AS
                BEGIN
                    SET NOCOUNT ON;
                        SELECT *
                        FROM 
                            MAIN_MENU_SETTINGS 
                        WHERE IS_ACTIVE= 1 AND MENU_ID = @MENU_ID
                END

CREATE PROCEDURE [@_dsn_main_@].[GET_MAIN_MENU_SETTINGS_SITE]
            @http_host nvarchar(50)
        AS
        BEGIN
            -- SET NOCOUNT ON added to prevent extra result sets from
            -- interfering with SELECT statements.
            SET NOCOUNT ON;
        
            SELECT MENU_ID, OUR_COMPANY_ID, SITE_DOMAIN, IS_LOGO, IS_FLASH_LOGO, IS_TREE_MENU, MENU_NAME, IS_ACTIVE, IS_PUBLISH, IS_VISUAL, AYRAC_BUTON, AYRAC_BUTON_SERVER_ID, LOGO_FILE, BACKGROUND_FILE, IS_AYRAC, AYRAC_TEXT, AYRAC_RIGHT, AYRAC_LEFT, AYRAC_CENTER, AYRAC_WIDTH, BOTTOM_MENU_BACKGROUND, TOP_MENU_BACKGROUND, CENTER_MENU_BACKGROUND, TOP_MARJIN, LEFT_MARJIN, LEFT_INNER_MARJIN, TOP_INNER_MARJIN, FOOTER_MENU_BACKGROUND, CONTENT_MENU_BACKGROUND, BACKGROUND_COLOR, COLOR_TOP_MENU, COLOR_CENTER_MENU, COLOR_BOTTOM_MENU, COLOR_FOOTER_MENU, COLOR_CONTENT_MENU, TO_EMPS, POSITION_CAT_IDS, USER_GROUP_IDS, DEPARTMENT_IDS, STOCK_TYPE, MAIN_BACKGROUND, SECOND_BACKGROUND, SECOND_LINK, MAIN_LINK, MAIN_HEIGHT, SECOND_HEIGHT, FOOTER_HEIGHT, MAIN_ALIGN, MAIN_VALIGN, SECOND_ALIGN, FOOTER_ALIGN, FOOTER_VALIGN, IS_ALPHABETIC, LOGO_HEIGHT, LOGO_WIDTH, COMPANY_CAT_IDS, CONSUMER_CAT_IDS, IS_PARTNER, IS_PUBLIC, IS_CAREER, GENERAL_WIDTH, GENERAL_WIDTH_TYPE, GENERAL_ALIGN, CSS_FILE, MENU_STYLE, LANGUAGE_ID, LOGO_FILE_SERVER_ID, BACKGROUND_FILE_SERVER_ID, AYRAC_RIGHT_SERVER_ID, AYRAC_LEFT_SERVER_ID, AYRAC_CENTER_SERVER_ID, BOTTOM_MENU_BG_SERVER_ID, TOP_MENU_BACKGROUND_SERVER_ID, CENTER_MENU_BG_SERVER_ID, FOOTER_MENU_BG_SERVER_ID, CONTENT_MENU_BG_SERVER_ID, CSS_FILE_SERVER_ID, SITE_TITLE, SITE_DESCRIPTION, SITE_KEYWORDS, IS_LOGO_BLOCK, MAIN_FILE, SECOND_FILE, FOOTER_FILE, SITE_HEADERS, MYHOME_FILE, LOGIN_FILE, SABLON_FILE, RECORD_EMP, RECORD_IP, RECORD_DATE, UPDATE_EMP, UPDATE_IP, UPDATE_DATE, IS_PASSWORD_CONTROL, APP_KEY, STD_DESCRIPTION, IS_PDA FROM MAIN_MENU_SETTINGS WHERE IS_ACTIVE = 1 AND SITE_DOMAIN = @http_host
        END

CREATE PROCEDURE [@_dsn_main_@].[GET_MESSAGE] 
				@USER_TYPE INTEGER, 
				@USER_ID INTEGER
			AS
			DECLARE @QUERY_STRING NVARCHAR(1000)
			SET @QUERY_STRING = '
			SELECT
                RECEIVER_ID,
                WRK_MESSAGE_ID,
                ISNULL(IS_ALERTED,0) AS IS_ALERTED,
                IS_CLOSED
			FROM
			WRK_MESSAGE
			WHERE
			RECEIVER_ID = ' +CONVERT(varchar(9), @USER_ID) + 
			'AND RECEIVER_TYPE = ' + +CONVERT(varchar(9),  @USER_TYPE)
			EXEC (@QUERY_STRING)

CREATE PROCEDURE [@_dsn_main_@].[GET_MONEY_HISTORY] 
                @action_date datetime,
                @money_type nvarchar(500),
                @period_id nvarchar(500)
            AS
            BEGIN
                SET NOCOUNT ON;
                SELECT 
                    (RATE2/RATE1) RATE,
                    MONEY MONEY_TYPE 
                FROM 
                    MONEY_HISTORY 
                WHERE 
                    VALIDATE_DATE <= @action_date AND 
                    MONEY = @money_type AND
                    PERIOD_ID = @period_id
                ORDER BY 
                    VALIDATE_DATE DESC,
                    MONEY_HISTORY_ID DESC
				END

CREATE PROCEDURE [@_dsn_main_@].[GET_MY_SETTINGS]
 
            @EMPLOYEE_ID INT 
        AS
        BEGIN
            SET NOCOUNT ON;
                SELECT
                    * 
                FROM
                    MY_SETTINGS
                WHERE
                     EMPLOYEE_ID = @EMPLOYEE_ID
        END

CREATE PROCEDURE [@_dsn_main_@].[GET_MY_SETTINGS_POSITIONS]
                @Param1 INT 
            AS
            BEGIN
                SET NOCOUNT ON;
                SELECT 
                    MENU_POSITION_ID,
                    PANEL_NAME,
                    COLUMN_INDEX,
                    WIDGET_HEAD,
                    IS_WIDGET,
                    IS_CLOSE		
                FROM
                    MY_SETTINGS_POSITIONS 
                WHERE 
                    EMP_ID = @Param1
                ORDER BY
                    COLUMN_INDEX,
                    SEQUENCE_INDEX
            END

CREATE PROCEDURE [@_dsn_main_@].[GET_SITE_PAGES]
                @user_friendly_url nvarchar(200),
                @fuseact_ nvarchar(200),
                @menu_id int
            AS
            BEGIN
                -- SET NOCOUNT ON added to prevent extra result sets from
                -- interfering with SELECT statements.
                SET NOCOUNT ON;
            
                IF (@fuseact_ = 'user_friendly')
                    BEGIN
                        SELECT 
                            MSLS.ROW_ID,
                            MSLS.OBJECT_POSITION,
                            MSLS.OBJECT_NAME,
                            MSLS.FACTION,
                            MSLS.ORDER_NUMBER,
                            MSLS.OBJECT_FOLDER,
                            MSLS.OBJECT_FILE_NAME,
                            MSLS.DESIGN_ID,
                            MSLS.CLASS_CSS_NAME,
                            MSL.LEFT_WIDTH,
                            MSL.RIGHT_WIDTH,
                            MSL.CENTER_WIDTH,
                            MSL.MARGIN
                        FROM 
                            MAIN_SITE_LAYOUTS_SELECTS MSLS,
                            MAIN_SITE_LAYOUTS MSL
                        WHERE 
                            MSLS.FACTION = @user_friendly_url AND
                            MSLS.FACTION = MSL.FACTION AND
                            MSLS.MENU_ID = MSL.MENU_ID AND
                            MSL.MENU_ID = @menu_id
                    END
                ELSE
                    BEGIN
                        SELECT 
                            MSLS.ROW_ID,
                            MSLS.OBJECT_POSITION,
                            MSLS.OBJECT_NAME,
                            MSLS.FACTION,
                            MSLS.ORDER_NUMBER,
                            MSLS.OBJECT_FOLDER,
                            MSLS.OBJECT_FILE_NAME,
                            MSLS.DESIGN_ID,
                            MSLS.CLASS_CSS_NAME,
                            MSL.LEFT_WIDTH,
                            MSL.RIGHT_WIDTH,
                            MSL.CENTER_WIDTH,
                            MSL.MARGIN
                        FROM 
                            MAIN_SITE_LAYOUTS_SELECTS MSLS,
                            MAIN_SITE_LAYOUTS MSL
                        WHERE 
                            MSLS.FACTION = @fuseact_ AND
                            MSLS.FACTION = MSL.FACTION AND
                            MSLS.MENU_ID = MSL.MENU_ID AND
                            MSL.MENU_ID = @menu_id
                    END
            
            END

CREATE PROCEDURE [@_dsn_main_@].[GET_WIDGET]
            @Param1 INT 
        AS
        BEGIN
            SET NOCOUNT ON;
            SELECT 
                URL,
                WIDGET_SCRIPT,
                WIDGET_RECORD_COUNT,
                WIDGET_SHOW_IMAGE 
            FROM 
                MY_SETTINGS_POSITIONS 
            WHERE 
                MENU_POSITION_ID =  @Param1
        END



CREATE PROCEDURE [@_dsn_main_@].[GET_WORKCUBE_APP]
                @CFTOCKEN  nvarchar(100),
                @CFID nvarchar(50),
				@sessInfo nvarchar(100),
				@userType bit
            AS
            BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT OFF;
    
        -- Insert statements for procedure here
        SELECT 
			CFID, 
			CFTOKEN, 
			WORKCUBE_ID, 
			USERID,
			USER_TYPE, 
			TIMEOUT_MIN, 
			SESSIONID, 
			ACTION_DATE, 
			ACTION_PAGE, 
			USERNAME, 
			NAME, 
			SURNAME, 
			POSITION_CODE, 
			TIME_ZONE, 
			POSITION_NAME,
			LANGUAGE_ID, 
			DESIGN_ID, 
			DESIGN_COLOR, 
			COMPANY_ID, 
			COMPANY, 
			COMPANY_NICK, 
			OUR_COMPANY_ID,
			OUR_COMPANY, 
			OUR_COMPANY_NICK, 
			EHESAP, MAXROWS, 
			USER_LOCATION, 
			USERKEY, 
			PERIOD_ID, 
			PERIOD_YEAR, 
			IS_INTEGRATED,
			USER_LEVEL, 
			USER_LEVEL_EXTRA, 
			WORKCUBE_SECTOR, 
			IS_COST, 
			ERROR_TEXT, 
			COMPANY_CATEGORY, 
			ADMIN_STATUS, 
			PERIOD_DATE, 
			USER_IP, 
			FUSEACTION, 
			PARTNER_OR_CONSUMER, 
			MENU_ID, 
			IS_GUARANTY_FOLLOWUP, 
			IS_PROJECT_FOLLOWUP, 
			IS_ASSET_FOLLOWUP, 
			IS_SALES_ZONE_FOLLOWUP, 
			IS_SMS, 
			IS_UNCONDITIONAL_LIST, 
			AUTHORITY_CODE_HR, 
			IS_SUBSCRIPTION_CONTRACT, 
			MONEY, 
			MONEY2, 
			OTHER_MONEY, 
			POWER_USER, 
			SPECT_TYPE, 
			SERVER_MACHINE, 
			IS_PAPER_CLOSER, 
			DOMAIN_NAME, 
			IS_ONLY_SHOW_PAGE, 
			IS_VIDEO_LIVE, 
			LIVE_VIDEO_ID, 
			IS_IFRS, 
			DISCOUNT_VALID, 
			PRICE_DISPLAY_VALID, 
			COST_DISPLAY_VALID, 
			CONSUMER_PRIORITY, 
			PRICE_VALID, 
			RATE_ROUND_NUM, 
			IS_MAXROWS_CONTROL_OFF,
			PURCHASE_PRICE_ROUND_NUM, 
			SALES_PRICE_ROUND_NUM, 
			MEMBER_VIEW_CONTROL, 
			DUEDATE_VALID, 
			IS_LOCATION_FOLLOW, 
			POWER_USER_LEVEL_ID, 
			RATE_VALID, 
			PROCESS_DATE, 
			IS_PROD_COST_TYPE,
			IS_STOCK_BASED_COST, 
			COMPANY_EMAIL, 
			IS_PROJECT_GROUP,
			SPECIAL_MENU_FILE,
            START_DATE,
			FINISH_DATE,
            IS_ADD_INFORMATIONS,
            IS_EFATURA,
            IS_EDEFTER,
            IS_LOT_NO,
			BROWSER_INFO,
			IS_BRANCH_AUTHORIZATION,
			DATEFORMAT_STYLE,
			TIMEFORMAT_STYLE,
			MONEYFORMAT_STYLE
         FROM 
             WRK_SESSION 
         WHERE 
			SESSIONID = +@sessInfo
			AND USER_TYPE = +@userType
            --CFTOKEN = +@CFTOCKEN AND 
            --CFID =+@CFID 
        END



CREATE PROCEDURE [@_dsn_main_@].[GET_WRK_SECURE_BANNED_IP]  
            @banned_ip nvarchar(50)
        AS
        BEGIN
            SET NOCOUNT ON;
            SELECT 
                ID 
            FROM 
                WRK_SECURE_BANNED_IP 
            WHERE 
                REMOTE_ADDR =@banned_ip AND 
                ACTIVE = 1
        END

CREATE PROCEDURE [@_dsn_main_@].[GET_WRK_SECURE_LOG]
            @remote_addr nvarchar(50) 
            AS
            BEGIN
                SET NOCOUNT ON;
                SELECT ID FROM WRK_SECURE_LOG WHERE REMOTE_ADDR = @remote_addr  AND ACTIVE = 1
            END

CREATE PROCEDURE [@_dsn_main_@].[ITEM_LANGUAGE]
			@sourcedatabase nvarchar (100),
			@tablename nvarchar(50),
			@ID nvarchar(50),
			@LANGUAGE NVARCHAR(10)
			AS
			BEGIN
				SET NOCOUNT ON;
			declare
			@tStr nvarchar(1000), -- ayarlama stringi
			@tStr1 nvarchar(1000),
			@tStr2 nvarchar(1000),
			@xStr nvarchar(1000); -- �al��acak string
			set @tStr = '
			SELECT SLI.ITEM FROM [DBDBDBDB].[TBLTBL] P,SETUP_LANGUAGE_INFO SLI 
			where P.[IDIDID]=SLI.UNIQUE_COLUMN_ID AND SLI.LANGUAGE=LNGLNG';
			set @tStr1 = REPLACE(@tStr, 'TBLTBL',@tablename);
			set @tStr2 = REPLACE(@tStr1 , 'DBDBDBDB', @sourcedatabase);
			set @xStr= REPLACE(@tStr2 , 'IDIDID', @ID);
			set @xStr= REPLACE(@xStr , 'LNGLNG', @LANGUAGE);
			exec(@xStr);
			END

CREATE PROCEDURE [@_dsn_main_@].[UPDATE_WRK_ACTION_PROCEDURE]
				@USER_TYPE INT,
				@USER_ID INT,
				@ACTION_PAGE NTEXT,
				@ACTION_DATE DATETIME,
				@FUSEACTION NVARCHAR(500),
                @WORKCUBEID NVARCHAR(250)
			AS
			BEGIN
			SET NOCOUNT ON;
			UPDATE WRK_SESSION SET ACTION_PAGE=@ACTION_PAGE,ACTION_DATE=@ACTION_DATE,FUSEACTION=@FUSEACTION 
			WHERE USER_TYPE=@USER_TYPE AND USERID=@USER_ID AND SESSIONID = @WORKCUBEID
			END

CREATE PROCEDURE [@_dsn_main_@].[WRITE_VISIT_ACTION]	
				@user_type integer,
				@user_id integer,
				@wrk_cookie VARCHAR(50),
				@is_new integer,
				@simdi DATETIME,
				@remote_adress VARCHAR(100),
				@http_host VARCHAR(50),
				@visit_page VARCHAR(1500),
				@http_referer VARCHAR(1500),
				@visit_fuseact_1 VARCHAR(50),
				@visit_fuseact_2 VARCHAR(100),
				@visit_parameters VARCHAR(1500),
				@browser_info VARCHAR(250)
			AS
			BEGIN 
				 SET NOCOUNT ON 
				INSERT 
					INTO 
				WRK_VISIT 
					(
					USER_TYPE,
					USER_ID,
					WRK_COOKIE,
					IS_NEW,
					VISIT_DATE,
					VISIT_IP,
					VISIT_SITE,
					VISIT_PAGE,
					VISIT_FROM_PAGE,
					VISIT_MODULE,
					VISIT_FUSEACTION,
					VISIT_PARAMETERS,
					BROWSER_INFO
					)
				VALUES
					(
						@user_type,
						@user_id,
						@wrk_cookie,
						@is_new,
						@simdi,
						@remote_adress,
						@http_host,
						@visit_page,
						@http_referer,
						@visit_fuseact_1,
						@visit_fuseact_2,
						@visit_parameters,
						@browser_info
					)
				END

CREATE PROCEDURE [@_dsn_main_@].[WRK_GENERATESERVICENO]
			(
				@pPrefix as varchar(10),
				@pUser as varchar(10)
			)
		 AS
			DECLARE 
				@ServiceID int,
				@ServiceNo varchar(50), 
				@RndNumStr varchar(3),
				@FormatedTime varchar(100)
			SELECT 
				 @RndNumStr		= Cast(ROUND(((999 - 0 -1) * RAND() + 0), 0) as varchar(10))
				,@FormatedTime	= CONVERT(varchar(100),GETDATE(),112)+REPLACE(CONVERT(varchar(100),GETDATE(),108),':','')
			SELECT ServiceNo = isnull(@pPrefix,'')+ '-' + @FormatedTime + isnull(@pUser,'') + @RndNumStr

CREATE PROCEDURE [@_dsn_main_@].[WRK_OBJECTS_PROC] 
			 @f_circuit nvarchar(max),
			 @f_control nvarchar(max)
			AS  
			BEGIN     
				SELECT 
					WRK_OBJECTS_ID,
					FILE_NAME,
					FOLDER,
					MODUL,
					LEFT_MENU_NAME,
					IS_WBO_DENIED,
					IS_WBO_FORM_LOCK,
					IS_WBO_LOCK,
					IS_UPDATE,
					TYPE
				FROM
					WRK_OBJECTS
				WHERE 
					MODUL_SHORT_NAME = @f_circuit  AND
                    (
                        FUSEACTION =  @f_control OR
                        FUSEACTION2 =  @f_control
                    ) AND 
					IS_ACTIVE = 1 
				UPDATE 
					WRK_OBJECTS 
				SET 
					OBJECTS_COUNT = OBJECTS_COUNT+1 
				WHERE 
					MODUL_SHORT_NAME = @f_circuit  AND
					FUSEACTION =  @f_control AND 
					IS_ACTIVE = 1 
			END