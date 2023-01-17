<!-- Description : GET_WORKCUBE_APP stored procedure'üne  worktips_open alanı eklendi.
Developer: Emine Yılmaz
Company : Workcube
Destination: Main -->
<querytag>
    ALTER PROCEDURE [GET_WORKCUBE_APP]
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
            EFATURA_DATE,
            IS_EDEFTER,
            IS_EARCHIVE,
            EARCHIVE_DATE,
            IS_LOT_NO,
			IS_BRANCH_AUTHORIZATION,
			DATEFORMAT_STYLE,
			TIMEFORMAT_STYLE,
			MONEYFORMAT_STYLE,
			THEIR_RECORDS_ONLY,
			DOCK_PHONE,
			REPORT_USER_LEVEL,
            DATA_LEVEL,
            WORKTIPS_OPEN
         FROM 
             WRK_SESSION 
         WHERE 
         	SESSIONID = +@sessInfo
			AND USER_TYPE = +@userType
            --CFTOKEN = +@CFTOCKEN AND 
            --CFID =+@CFID 
        END
</querytag>