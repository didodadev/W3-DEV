<!---Yeni Versiyona Kadar Çalıştırılmaması Gerekiyor <cfabort>--->
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="DROP_VIEWS" datasource="#DSN#">
			IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[EMPLOYEES_PUANTAJ_COST]'))
				DROP VIEW [EMPLOYEES_PUANTAJ_COST]
			IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[GET_COMPANY_PARTNER_MAIN]'))
				DROP VIEW [GET_COMPANY_PARTNER_MAIN]	
			IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[GET_MY_COMPANYCAT]'))
				DROP VIEW [GET_MY_COMPANYCAT]	
			IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[GET_MY_CONSUMERCAT]'))
				DROP VIEW [GET_MY_CONSUMERCAT]	
			IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SALES_ZONES_ALL_1]'))
				DROP VIEW [SALES_ZONES_ALL_1]	
			IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SALES_ZONES_ALL_2]'))
				DROP VIEW [SALES_ZONES_ALL_2]	
            IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[GET_EMPLOYEE_IN_OUT]'))
				DROP VIEW [GET_EMPLOYEE_IN_OUT]
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[fnSplit]')  and type = 'TF')
				DROP FUNCTION [fnSplit]
		</cfquery>
        <cfquery name="CREATE_PERIOD_DB_SP" datasource="#DSN#">
            CREATE FUNCTION [fnSplit](
            @sInputList VARCHAR(8000) -- List of delimited items
            , @sDelimiter VARCHAR(8000) = ',' -- delimiter that separates items
            ) RETURNS @List TABLE (item VARCHAR(8000))
            
            BEGIN
            DECLARE @sItem VARCHAR(8000)
            WHILE CHARINDEX(@sDelimiter,@sInputList,0) <> 0
            BEGIN
            SELECT
            @sItem=RTRIM(LTRIM(SUBSTRING(@sInputList,1,CHARINDEX(@sDelimiter,@sInputList,0)-1))),
            @sInputList=RTRIM(LTRIM(SUBSTRING(@sInputList,CHARINDEX(@sDelimiter,@sInputList,0)+LEN(@sDelimiter),LEN(@sInputList))))
            
            IF LEN(@sItem) > 0
            INSERT INTO @List SELECT @sItem
            END
            
            IF LEN(@sInputList) > 0
            INSERT INTO @List SELECT @sInputList -- Put the last item in
            RETURN
            END
        </cfquery>
        <cfquery name="GET_EMPLOYEE_IN_OUT" datasource="#DSN#">
                CREATE VIEW [GET_EMPLOYEE_IN_OUT] AS
                    WITH CTE1 AS
                    (SELECT 
                        EIO.EMPLOYEE_ID, 
                        START_DATE, 
                        FINISH_DATE,
                        ROW_NUMBER() OVER (PARTITION BY EMPLOYEE_ID ORDER BY START_DATE) AS ranking
                    FROM 
                        EMPLOYEES_IN_OUT EIO
                    ),
                    CTE2 AS
                    (
                        SELECT 
                            T1.EMPLOYEE_ID, 
                            T1.START_DATE, T1.FINISH_DATE, T2.FINISH_DATE as prev_Finish, 
                            (CASE WHEN T1.START_DATE = T2.FINISH_DATE+1 THEN 0 ELSE 1 END) as YeniBaslangic
                        FROM CTE1 T1
                            LEFT OUTER JOIN CTE1 T2 ON T1.EMPLOYEE_ID = T2.EMPLOYEE_ID and T1.ranking = T2.ranking+1
                    ),
                    CTE3 as 
                    (
                        SELECT  
                            (SELECT MAX(START_DATE) FROM CTE2 CT WHERE EIO.EMPLOYEE_ID = CT.EMPLOYEE_ID AND EIO.START_DATE>=CT.START_DATE AND YeniBaslangic = 1) AS HesaplanmisKidemBaslangic, 
                            (CASE WHEN CTE2.YeniBaslangic= 1 then 'Yeni Başlangıç' else 'Nakil' end) as GirisTipi,
                            EIO.*
                        FROM 
                            EMPLOYEES_IN_OUT EIO INNER JOIN CTE2 ON CTE2.EMPLOYEE_ID = EIO.EMPLOYEE_ID  
                        WHERE 
                            CTE2.START_DATE = EIO.START_DATE
                    )
                    SELECT DISTINCT
                        EIO.IN_OUT_ID,
                        E.EMPLOYEE_ID,
                        E.EMPLOYEE_NAME,
                        E.EMPLOYEE_SURNAME,
                        HesaplanmisKidemBaslangic,
                        GirisTipi
                    FROM 
                        EMPLOYEES E INNER JOIN CTE3 EIO ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID
                        </cfquery>
                        
                        <cfquery name="EMPLOYEES_PUANTAJ_COST" datasource="#DSN#">
                            CREATE VIEW [EMPLOYEES_PUANTAJ_COST] AS
                                SELECT
                                SUM(TOPLAM_MALIYET - TAZMINATLAR) AS TOPLAM_CLAIM_COST,
                                SUM(TAZMINATLAR) AS TOTAL_TAZMINATLAR,
                                SUM(TOPLAM_MALIYET) AS TOTAL_COST,
                                SUM(NORMAL_MALIYET) AS NORMAL_COST,
                                SUM(FAZLA_MESAI_NORMAL) AS EXT_SALARY_NORMAL,
                                SUM(FAZLA_MESAI_HAFTA_TATILI) AS EXT_SALARY_WEEKEND,
                                SUM(FAZLA_MESAI_GENEL_TATIL) AS EXT_SALARY_OFFDAY,
                                SUM(FAZLA_MESAI_TOTAL) AS EXT_SALARY_TOTAL,
                                SUM(HAFTA_ICI_NORMAL_ILK_SAAT + FAZLA_MESAI_45_ILK_SAAT) AS EXT_SALARY_NORMAL_HOURS,
                                SUM(HAFTA_SONU_ILK_SAAT) AS EXT_SALARY_WEEKEND_HOURS,
                                SUM(GENEL_TATIL_ILK_SAAT) AS EXT_SALARY_OFFDAY_HOURS,
                                SUM(TOPLAM_CALISMA_SAATI) AS TOTAL_WORK_HOURS,
                                EMPLOYEE_ID,
                                SAL_YEAR,
                                SAL_MON
                            FROM
                                (
                                    SELECT
                                        TAZMINATLAR,
                                        TOPLAM_MALIYET,
                                        NORMAL_MALIYET,
                                        FAZLA_MESAI_TOTAL,
                                        TOPLAM_CALISMA_SAATI,
                                        CASE
                                            WHEN FAZLA_MESAI_TOTAL > 0
                                            THEN
                                                (FAZLA_MESAI_TOTAL / (HAFTA_ICI_NORMAL_ILK + HAFTA_SONU_ILK + GENEL_TATIL_ILK + FAZLA_MESAI_45_ILK) * (FAZLA_MESAI_45_ILK + HAFTA_ICI_NORMAL_ILK))
                                            ELSE
                                                0 
                                            END AS FAZLA_MESAI_NORMAL,
                                        CASE
                                            WHEN FAZLA_MESAI_TOTAL > 0
                                            THEN
                                                (FAZLA_MESAI_TOTAL / (HAFTA_ICI_NORMAL_ILK + HAFTA_SONU_ILK + GENEL_TATIL_ILK + FAZLA_MESAI_45_ILK) * HAFTA_SONU_ILK)
                                            ELSE
                                                0 
                                            END AS FAZLA_MESAI_HAFTA_TATILI,
                                        CASE
                                            WHEN FAZLA_MESAI_TOTAL > 0
                                            THEN
                                                (FAZLA_MESAI_TOTAL / (HAFTA_ICI_NORMAL_ILK + HAFTA_SONU_ILK + GENEL_TATIL_ILK + FAZLA_MESAI_45_ILK) * GENEL_TATIL_ILK)
                                            ELSE
                                                0 
                                            END AS FAZLA_MESAI_GENEL_TATIL,
                                            HAFTA_ICI_NORMAL_ILK_SAAT,
                                            HAFTA_SONU_ILK_SAAT,
                                            GENEL_TATIL_ILK_SAAT,
                                            FAZLA_MESAI_45_ILK_SAAT,
                                            EMPLOYEE_ID,
                                            SAL_MON,
                                            SAL_YEAR
                                    FROM	
                                            (SELECT 
                                                    (YILLIK_IZIN_AMOUNT + KIDEM_AMOUNT + IHBAR_AMOUNT) AS TAZMINATLAR,
                                                    (TOTAL_SALARY - VERGI_ISTISNA_VERGI + ISSIZLIK_ISVEREN_HISSESI + SSK_ISVEREN_HISSESI + SSDF_ISVEREN_HISSESI + VERGI_ISTISNA_SSK + VERGI_ISTISNA_VERGI + VERGI_ISTISNA_DAMGA - SSK_ISVEREN_HISSESI_GOV - SSK_ISVEREN_HISSESI_5921 - SSK_ISVEREN_HISSESI_5746 + (SSK_ISCI_HISSESI - ((SSK_MATRAH - (SSK_DEVIR + SSK_DEVIR_LAST)) * 14 / 100)) + (ISSIZLIK_ISCI_HISSESI - ((SSK_MATRAH - (SSK_DEVIR + SSK_DEVIR_LAST)) * 1 / 100)) + SSK_ISCI_HISSESI_DUSULECEK) AS TOPLAM_MALIYET,
                                                    (TOTAL_SALARY - EXT_SALARY - VERGI_ISTISNA_VERGI + ISSIZLIK_ISVEREN_HISSESI + SSK_ISVEREN_HISSESI + SSDF_ISVEREN_HISSESI + VERGI_ISTISNA_SSK + VERGI_ISTISNA_VERGI + VERGI_ISTISNA_DAMGA - SSK_ISVEREN_HISSESI_GOV - SSK_ISVEREN_HISSESI_5921 - SSK_ISVEREN_HISSESI_5746 + (SSK_ISCI_HISSESI - ((SSK_MATRAH - (SSK_DEVIR + SSK_DEVIR_LAST)) * 14 / 100)) + (ISSIZLIK_ISCI_HISSESI - ((SSK_MATRAH - (SSK_DEVIR + SSK_DEVIR_LAST)) * 1 / 100)) + SSK_ISCI_HISSESI_DUSULECEK) AS NORMAL_MALIYET,
                                                    EXT_SALARY AS FAZLA_MESAI_TOTAL,
                                                    ((EXT_TOTAL_HOURS_0-EXT_TOTAL_HOURS_3) * SPP.EX_TIME_PERCENT / 100) AS HAFTA_ICI_NORMAL_ILK,
                                                    CASE
                                                        WHEN SPP.WEEKEND_MULTIPLIER IS NULL THEN 
                                                            EXT_TOTAL_HOURS_1 * SPP.EX_TIME_PERCENT / 100
                                                        ELSE 
                                                             EXT_TOTAL_HOURS_1 * SPP.WEEKEND_MULTIPLIER
                                                    END AS HAFTA_SONU_ILK,
                                                    CASE
                                                        WHEN SPP.OFFICIAL_MULTIPLIER IS NULL THEN 
                                                            EXT_TOTAL_HOURS_2 * 100 / 100
                                                        ELSE 
                                                             EXT_TOTAL_HOURS_2 * SPP.OFFICIAL_MULTIPLIER
                                                    END AS GENEL_TATIL_ILK,
                                                    (EXT_TOTAL_HOURS_3 * SPP.EX_TIME_PERCENT_HIGH / 100) AS FAZLA_MESAI_45_ILK,
                                                    (EXT_TOTAL_HOURS_0-EXT_TOTAL_HOURS_3) AS HAFTA_ICI_NORMAL_ILK_SAAT,
                                                    EXT_TOTAL_HOURS_1 AS HAFTA_SONU_ILK_SAAT,
                                                    EXT_TOTAL_HOURS_2 AS GENEL_TATIL_ILK_SAAT,
                                                    EXT_TOTAL_HOURS_3 AS FAZLA_MESAI_45_ILK_SAAT,
                                                    CASE
                                                        WHEN TOTAL_HOURS > 0 THEN 
                                                            TOTAL_HOURS
                                                        ELSE 
                                                            TOTAL_DAYS * 7.5
                                                    END AS TOPLAM_CALISMA_SAATI,
                                                    EPR.EMPLOYEE_ID,
                                                    EP.SAL_MON,
                                                    EP.SAL_YEAR
                                                FROM
                                                    EMPLOYEES_PUANTAJ EP,
                                                    EMPLOYEES_PUANTAJ_ROWS EPR,
                                                    SETUP_PROGRAM_PARAMETERS SPP
                                                WHERE
                                                    YEAR(SPP.STARTDATE) = EP.SAL_YEAR AND
                                                    MONTH(SPP.STARTDATE) <= EP.SAL_MON AND
                                                    YEAR(SPP.FINISHDATE) = EP.SAL_YEAR AND
                                                    MONTH(SPP.FINISHDATE) >= EP.SAL_MON AND
                                                    EP.PUANTAJ_ID = EPR.PUANTAJ_ID
                                                ) AS ILK_QUERY
                                ) AS SECOND_QUERY
                            GROUP BY
                                EMPLOYEE_ID,
                                SAL_YEAR,
                                SAL_MON
		</cfquery>
		<cfquery name="GET_COMPANY_PARTNER_MAIN" datasource="#DSN#">
			CREATE VIEW [GET_COMPANY_PARTNER_MAIN] AS
				SELECT  
					C.COMPANY_ID, 
					C.ISPOTANTIAL,
					C.FULLNAME, 
					C.CITY AS CITY_ID, 
					C.COMPANYCAT_ID, 
					C.COMPANY_STATUS, 
					C.COUNTY AS COUNTY_ID, 
					C.DISTRICT, 
					C.SEMT, 
					C.IMS_CODE_ID, 
					C.DUTY_PERIOD, 
					C.MANAGER_PARTNER_ID, 
					C.STOCK_AMOUNT, 
					C.TAXOFFICE, 
					C.TAXNO, 
					C.COMPANY_EMAIL, 
					C.COMPANY_TEL1, 
					C.COMPANY_TELCODE, 
					CP.PARTNER_ID, 
					CP.COMPANY_PARTNER_NAME, 
					CP.COMPANY_PARTNER_SURNAME, 
					CP.MISSION, 
					CP.SEX, 
					CP.MOBIL_CODE, 
					CP.MOBILTEL, 
					CP.IS_SMS, 
					CP.GRADUATE_YEAR, 
					CP.TC_IDENTITY, 
					CPD.FACULTY AS UNIVERSITY_ID, 
					CPD.EDU1, 
					CPD.BIRTHPLACE, 
					CPD.BIRTHDATE, 
					CPD.MARRIED_DATE, 
					CPD.MARRIED, 
					CC.COMPANYCAT, 
					CC.COMPANYCAT_TYPE, 
					C.MAIN_STREET, 
					C.STREET, C.DUKKAN_NO
				FROM 
					COMPANY AS C INNER JOIN
					COMPANY_PARTNER AS CP ON C.COMPANY_ID = CP.COMPANY_ID INNER JOIN
					COMPANY_PARTNER_DETAIL AS CPD ON CP.PARTNER_ID = CPD.PARTNER_ID INNER JOIN
					COMPANY_CAT AS CC ON C.COMPANYCAT_ID = CC.COMPANYCAT_ID	
		</cfquery>	
		<cfquery name="GET_MY_COMPANYCAT" datasource="#DSN#">
			CREATE VIEW [GET_MY_COMPANYCAT] AS
			SELECT	
				DISTINCT
				SP.OUR_COMPANY_ID,
				EP.EMPLOYEE_ID,
				CT.COMPANYCAT_ID,
				CT.COMPANYCAT,
				CT.COMPANYCAT_TYPE
			FROM
				EMPLOYEE_POSITIONS EP,
				SETUP_PERIOD SP,
				EMPLOYEE_POSITION_PERIODS EPP,
				OUR_COMPANY O,
				COMPANY_CAT CT,
				COMPANY_CAT_OUR_COMPANY CO		
			WHERE
				EP.EMPLOYEE_ID IS NOT NULL AND
				SP.OUR_COMPANY_ID = O.COMP_ID AND
				SP.PERIOD_ID = EPP.PERIOD_ID AND
				EP.POSITION_ID = EPP.POSITION_ID AND
				CT.COMPANYCAT_ID = CO.COMPANYCAT_ID AND
				CO.OUR_COMPANY_ID = SP.OUR_COMPANY_ID
		</cfquery> 			
		<cfquery name="GET_MY_CONSUMERCAT" datasource="#DSN#">
				CREATE VIEW [GET_MY_CONSUMERCAT] AS
				SELECT 
					DISTINCT
					SP.OUR_COMPANY_ID,
					EP.EMPLOYEE_ID,
					CT.CONSCAT_ID,
					CT.CONSCAT,
					CT.HIERARCHY,
					CT.IS_ACTIVE
				FROM
					EMPLOYEE_POSITIONS EP,
					SETUP_PERIOD SP,
					EMPLOYEE_POSITION_PERIODS EPP,
					OUR_COMPANY O,
					CONSUMER_CAT CT,
					CONSUMER_CAT_OUR_COMPANY CO 
				WHERE
					EP.EMPLOYEE_ID IS NOT NULL AND
					SP.OUR_COMPANY_ID = O.COMP_ID AND
					SP.PERIOD_ID = EPP.PERIOD_ID AND
					EP.POSITION_ID = EPP.POSITION_ID AND
					CT.CONSCAT_ID = CO.CONSCAT_ID AND
					CO.OUR_COMPANY_ID = SP.OUR_COMPANY_ID
		</cfquery>
		<cfquery name="SALES_ZONES_ALL_1" datasource="#DSN#">		
			CREATE VIEW [SALES_ZONES_ALL_1] AS 
			SELECT
				DISTINCT
				SZ1.SZ_HIERARCHY,
				SZ1.POSITION_CODE,
				SZ1.IMS_ID
			FROM		
			(	
				-- Satis bolgeleri ekibinde ise
				SELECT
					SZ.SZ_HIERARCHY,
					SZG.POSITION_CODE POSITION_CODE,
					SZTIM.IMS_ID
				FROM
					SALES_ZONES SZ,
					SALES_ZONE_GROUP SZG,
					SALES_ZONES_TEAM SZT,
					SALES_ZONES_TEAM_IMS_CODE SZTIM
				WHERE
					SZG.SZ_ID = SZ.SZ_ID AND
					SZ.SZ_ID = SZT.SALES_ZONES AND
					SZT.TEAM_ID = SZTIM.TEAM_ID
				
				UNION ALL
				
				-- Satis bolgesinde yonetici ise
				SELECT
					SZ.SZ_HIERARCHY,
					SZ.RESPONSIBLE_POSITION_CODE POSITION_CODE,
					SZTIM.IMS_ID
				FROM
					SALES_ZONES SZ,
					SALES_ZONES_TEAM SZT,
					SALES_ZONES_TEAM_IMS_CODE SZTIM
				WHERE
					SZ.RESPONSIBLE_POSITION_CODE IS NOT NULL AND
					SZ.SZ_ID = SZT.SALES_ZONES AND
					SZT.TEAM_ID = SZTIM.TEAM_ID
				) SZ1
			</cfquery>
		<cfquery name="SALES_ZONES_ALL_2" datasource="#DSN#">
			CREATE VIEW [SALES_ZONES_ALL_2] AS 
			SELECT
				ST2.POSITION_CODE,
				ST2.IMS_ID,
				ST2.COMPANY_CAT_IDS,
				ST2.CONSUMER_CAT_IDS
			FROM
			(
			--Takımda Ekip Lideri
			SELECT 
				SALES_ZONES_TEAM.LEADER_POSITION_CODE POSITION_CODE,
				SALES_ZONES_TEAM.COMPANY_CAT_IDS,
				SALES_ZONES_TEAM.CONSUMER_CAT_IDS,
				SALES_ZONES_TEAM_IMS_CODE.IMS_ID
			FROM
				SALES_ZONES_TEAM,
				SALES_ZONES_TEAM_IMS_CODE
			WHERE
				SALES_ZONES_TEAM.LEADER_POSITION_CODE IS NOT NULL AND
				SALES_ZONES_TEAM_IMS_CODE.TEAM_ID = SALES_ZONES_TEAM.TEAM_ID
			UNION
			--Takımda Ekipde ise
			SELECT 
				SALES_ZONES_TEAM_ROLES.POSITION_CODE,
				SALES_ZONES_TEAM.COMPANY_CAT_IDS,
				SALES_ZONES_TEAM.CONSUMER_CAT_IDS,
				SALES_ZONES_TEAM_IMS_CODE.IMS_ID
			FROM
				SALES_ZONES_TEAM,
				SALES_ZONES_TEAM_ROLES,
				SALES_ZONES_TEAM_IMS_CODE
			WHERE
				SALES_ZONES_TEAM_IMS_CODE.TEAM_ID = SALES_ZONES_TEAM_ROLES.TEAM_ID
				AND SALES_ZONES_TEAM_IMS_CODE.TEAM_ID = SALES_ZONES_TEAM.TEAM_ID
			) ST2	
		</cfquery>
		<cfquery name="drop_sp" datasource="#DSN#">
			IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FAVOUTIRES]') AND type in (N'P', N'PC'))
			DROP PROCEDURE [FAVOUTIRES]
			
			IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GET_LANGUAGE]') AND type in (N'P', N'PC'))
			DROP PROCEDURE [GET_LANGUAGE]
			
			IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GET_MESSAGE]') AND type in (N'P', N'PC'))
			DROP PROCEDURE [GET_MESSAGE]
			
			IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ITEM_LANGUAGE]') AND type in (N'P', N'PC'))
			DROP PROCEDURE [ITEM_LANGUAGE]
			
			IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UPDATE_WRK_ACTION_PROCEDURE]') AND type in (N'P', N'PC'))
			DROP PROCEDURE [UPDATE_WRK_ACTION_PROCEDURE]
			
			IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[WRITE_VISIT_ACTION]') AND type in (N'P', N'PC'))
			DROP PROCEDURE [WRITE_VISIT_ACTION]
			
			IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[WRK_GENERATESERVICENO]') AND type in (N'P', N'PC'))
			DROP PROCEDURE [WRK_GENERATESERVICENO]
			
			IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[WRK_PAGE]') AND type in (N'P', N'PC'))
			DROP PROCEDURE [WRK_PAGE]
			
			IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[WRK_PAGE_ROWS]') AND type in (N'P', N'PC'))
			DROP PROCEDURE [WRK_PAGE_ROWS]
			
			IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[WRK_PAGE_TOTAL]') AND type in (N'P', N'PC'))
			DROP PROCEDURE [WRK_PAGE_TOTAL]
			
			IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[WRK_OBJECTS_PROC]') AND type in (N'P', N'PC'))
			DROP PROCEDURE [WRK_OBJECTS_PROC]
			
			IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EMAIL_TYPE_CONTROL]') AND type in (N'P', N'PC'))
			DROP PROCEDURE [EMAIL_TYPE_CONTROL]
            
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GET_FUSEACTION_FROM_WRK_APP]') AND type in (N'P', N'PC'))
			DROP PROCEDURE [GET_FUSEACTION_FROM_WRK_APP]
            
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GET_WORKCUBE_APP]') AND type in (N'P', N'PC'))
			DROP PROCEDURE [GET_WORKCUBE_APP]  
            
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ADD_PERFORMANCE_COUNTER]') AND type in (N'P', N'PC'))
			DROP PROCEDURE [ADD_PERFORMANCE_COUNTER]
            
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GET_FUSEACTION_FROM_WRK_APP1]') AND type in (N'P', N'PC'))
			DROP PROCEDURE [GET_FUSEACTION_FROM_WRK_APP1]
            
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GET_MAIN_MENU_SETTINGS]') AND type in (N'P', N'PC'))
			DROP PROCEDURE [GET_MAIN_MENU_SETTINGS]
            
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GET_MAIN_MENU_SETTINGS_SITE]') AND type in (N'P', N'PC'))
			DROP PROCEDURE [GET_MAIN_MENU_SETTINGS_SITE]
            
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GET_MONEY_HISTORY]') AND type in (N'P', N'PC'))
			DROP PROCEDURE [GET_MONEY_HISTORY]
            
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GET_MY_SETTINGS]') AND type in (N'P', N'PC'))
			DROP PROCEDURE [GET_MY_SETTINGS]
            
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GET_MY_SETTINGS_POSITIONS]') AND type in (N'P', N'PC'))
			DROP PROCEDURE [GET_MY_SETTINGS_POSITIONS]
            
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GET_SITE_PAGES]') AND type in (N'P', N'PC'))
			DROP PROCEDURE [GET_SITE_PAGES]
            
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GET_WIDGET]') AND type in (N'P', N'PC'))
			DROP PROCEDURE [GET_WIDGET]
            
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GET_WRK_SECURE_BANNED_IP]') AND type in (N'P', N'PC'))
			DROP PROCEDURE [GET_WRK_SECURE_BANNED_IP]
            
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GET_WRK_SECURE_LOG]') AND type in (N'P', N'PC'))
			DROP PROCEDURE [GET_WRK_SECURE_LOG]
        </cfquery>
        
         <cfquery name="GET_WRK_SECURE_LOG" datasource="#DSN#">
            CREATE PROCEDURE [GET_WRK_SECURE_LOG]
            @remote_addr nvarchar(50) 
            AS
            BEGIN
                SET NOCOUNT ON;
                SELECT ID FROM WRK_SECURE_LOG WHERE REMOTE_ADDR = @remote_addr  AND ACTIVE = 1
            END
		</cfquery>
        
        <cfquery name="GET_WRK_SECURE_BANNED_IP" datasource="#DSN#">
        CREATE PROCEDURE [GET_WRK_SECURE_BANNED_IP]  
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
        </cfquery>
        <cfquery name="GET_WIDGET" datasource="#DSN#">
        CREATE PROCEDURE [GET_WIDGET]
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
        </cfquery>
        <cfquery name="GET_SITE_PAGES" datasource="#DSN#">
        CREATE PROCEDURE [GET_SITE_PAGES]
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
        </cfquery>
        <cfquery name="GET_MY_SETTINGS_POSITIONS" datasource="#DSN#">
            CREATE PROCEDURE [GET_MY_SETTINGS_POSITIONS]
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
		</cfquery>
        
         <cfquery name="GET_MY_SETTINGS" datasource="#DSN#">
        CREATE PROCEDURE [GET_MY_SETTINGS]
 
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
        </cfquery>
        <cfquery name="GET_MONEY_HISTORY" datasource="#DSN#">
        	CREATE PROCEDURE [GET_MONEY_HISTORY] 
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
        </cfquery>
        
        <cfquery name="GET_MAIN_MENU_SETTINGS_SITE" datasource="#DSN#">
        CREATE PROCEDURE [GET_MAIN_MENU_SETTINGS_SITE]
            @http_host nvarchar(50)
        AS
        BEGIN
            -- SET NOCOUNT ON added to prevent extra result sets from
            -- interfering with SELECT statements.
            SET NOCOUNT ON;
        
            SELECT MENU_ID, OUR_COMPANY_ID, SITE_DOMAIN, IS_LOGO, IS_FLASH_LOGO, IS_TREE_MENU, MENU_NAME, IS_ACTIVE, IS_PUBLISH, IS_VISUAL, AYRAC_BUTON, AYRAC_BUTON_SERVER_ID, LOGO_FILE, BACKGROUND_FILE, IS_AYRAC, AYRAC_TEXT, AYRAC_RIGHT, AYRAC_LEFT, AYRAC_CENTER, AYRAC_WIDTH, BOTTOM_MENU_BACKGROUND, TOP_MENU_BACKGROUND, CENTER_MENU_BACKGROUND, TOP_MARJIN, LEFT_MARJIN, LEFT_INNER_MARJIN, TOP_INNER_MARJIN, FOOTER_MENU_BACKGROUND, CONTENT_MENU_BACKGROUND, BACKGROUND_COLOR, COLOR_TOP_MENU, COLOR_CENTER_MENU, COLOR_BOTTOM_MENU, COLOR_FOOTER_MENU, COLOR_CONTENT_MENU, TO_EMPS, POSITION_CAT_IDS, USER_GROUP_IDS, DEPARTMENT_IDS, STOCK_TYPE, MAIN_BACKGROUND, SECOND_BACKGROUND, SECOND_LINK, MAIN_LINK, MAIN_HEIGHT, SECOND_HEIGHT, FOOTER_HEIGHT, MAIN_ALIGN, MAIN_VALIGN, SECOND_ALIGN, FOOTER_ALIGN, FOOTER_VALIGN, IS_ALPHABETIC, LOGO_HEIGHT, LOGO_WIDTH, COMPANY_CAT_IDS, CONSUMER_CAT_IDS, IS_PARTNER, IS_PUBLIC, IS_CAREER, GENERAL_WIDTH, GENERAL_WIDTH_TYPE, GENERAL_ALIGN, CSS_FILE, MENU_STYLE, LANGUAGE_ID, LOGO_FILE_SERVER_ID, BACKGROUND_FILE_SERVER_ID, AYRAC_RIGHT_SERVER_ID, AYRAC_LEFT_SERVER_ID, AYRAC_CENTER_SERVER_ID, BOTTOM_MENU_BG_SERVER_ID, TOP_MENU_BACKGROUND_SERVER_ID, CENTER_MENU_BG_SERVER_ID, FOOTER_MENU_BG_SERVER_ID, CONTENT_MENU_BG_SERVER_ID, CSS_FILE_SERVER_ID, SITE_TITLE, SITE_DESCRIPTION, SITE_KEYWORDS, IS_LOGO_BLOCK, MAIN_FILE, SECOND_FILE, FOOTER_FILE, SITE_HEADERS, MYHOME_FILE, LOGIN_FILE, SABLON_FILE, RECORD_EMP, RECORD_IP, RECORD_DATE, UPDATE_EMP, UPDATE_IP, UPDATE_DATE, IS_PASSWORD_CONTROL, APP_KEY, STD_DESCRIPTION, IS_PDA FROM MAIN_MENU_SETTINGS WHERE IS_ACTIVE = 1 AND SITE_DOMAIN = @http_host
        END
        </cfquery>
        
        <cfquery name="GET_MAIN_MENU_SETTINGS" datasource="#DSN#">
                CREATE PROCEDURE [GET_MAIN_MENU_SETTINGS]
                 
                    @MENU_ID INT 
                AS
                BEGIN
                    SET NOCOUNT ON;
                        SELECT *
                        FROM 
                            MAIN_MENU_SETTINGS 
                        WHERE IS_ACTIVE= 1 AND MENU_ID = @MENU_ID
                END
        </cfquery>
        
        
        <cfquery name="GET_FUSEACTION_FROM_WRK_APP1" datasource="#DSN#">
                    CREATE PROCEDURE [GET_FUSEACTION_FROM_WRK_APP1] 
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
        </cfquery>
        
        <cfquery name="ADD_PERFORMANCE_COUNTER" datasource="#DSN#">
        
                CREATE PROCEDURE [ADD_PERFORMANCE_COUNTER]
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
        </cfquery>
        
		<cfquery name="FAVOUTIRES" datasource="#DSN#">
			CREATE PROCEDURE [FAVOUTIRES] 
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
		</cfquery>
		<cfquery name="GET_LANGUAGE" datasource="#DSN#">
			CREATE PROCEDURE [GET_LANGUAGE] 
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
		</cfquery>
		<cfquery name="GET_MESSAGE" datasource="#DSN#">
			CREATE PROCEDURE [GET_MESSAGE] 
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
		</cfquery>	
		<cfquery name="ITEM_LANGUAGE" datasource="#DSN#">
			CREATE PROCEDURE [ITEM_LANGUAGE]
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
			@xStr nvarchar(1000); -- çalışacak string
			set @tStr = '
			SELECT SLI.ITEM FROM [DBDBDBDB].[TBLTBL] P,SETUP_LANGUAGE_INFO SLI 
			where P.[IDIDID]=SLI.UNIQUE_COLUMN_ID AND SLI.LANGUAGE=LNGLNG';
			set @tStr1 = REPLACE(@tStr, 'TBLTBL',@tablename);
			set @tStr2 = REPLACE(@tStr1 , 'DBDBDBDB', @sourcedatabase);
			set @xStr= REPLACE(@tStr2 , 'IDIDID', @ID);
			set @xStr= REPLACE(@xStr , 'LNGLNG', @LANGUAGE);
			exec(@xStr);
			END
		</cfquery>
		<cfquery name="UPDATE_WRK_ACTION_PROCEDURE" datasource="#DSN#">
			CREATE PROCEDURE [UPDATE_WRK_ACTION_PROCEDURE]
				@USER_TYPE INT,
				@USER_ID INT,
				@ACTION_PAGE NTEXT,
				@ACTION_DATE DATETIME,
				@FUSEACTION NVARCHAR(MAX),
                @WORKCUBEID nvarchar(250)
			AS
			BEGIN
			SET NOCOUNT ON;
			UPDATE WRK_SESSION SET ACTION_PAGE=@ACTION_PAGE,ACTION_DATE=@ACTION_DATE,FUSEACTION=@FUSEACTION 
			WHERE USER_TYPE=@USER_TYPE AND USERID=@USER_ID AND SESSIONID = @WORKCUBEID
			END
		</cfquery>
		<cfquery name="WRITE_VISIT_ACTION" datasource="#DSN#">
			CREATE PROCEDURE [WRITE_VISIT_ACTION]	
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
		</cfquery>
		<cfquery name="WRK_GENERATESERVICENO" datasource="#DSN#">
				CREATE PROC [WRK_GENERATESERVICENO]
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
		</cfquery>
		<!---<cfquery name="WRK_PAGE" datasource="#DSN#">
			CREATE PROCEDURE [WRK_PAGE]
				 @f_circuit nvarchar(max),
				 @f_control nvarchar(max)
				AS  
				BEGIN     
				SELECT 
					MODUL,
					FOLDER,
					FILE_NAME,
					FILE_TYPE,
					WRK_OBJECTS_ID
				FROM
					WRK_OBJECTS
				WHERE 
					MODUL_SHORT_NAME = @f_circuit  AND
					FUSEACTION =  @f_control AND 
					IS_ACTIVE = 1 
				END		
		</cfquery>	
		<cfquery name="WRK_PAGE_ROWS" datasource="#DSN#">
			 CREATE PROCEDURE [WRK_PAGE_ROWS]
			  @fieldlist nvarchar(max) = '*'
			 ,@datasrc nvarchar(max)
			 ,@filter nvarchar(max) = ''
			 ,@orderBy nvarchar(200)
			 ,@pageNum int = 1
			 ,@pageSize int = NULL
			AS
			  SET NOCOUNT ON
			  DECLARE
				 @STMT nvarchar(max)         -- SQL to execute
			
			  IF LTRIM(RTRIM(@filter)) = '' SET @filter = '1 = 1'
			  IF @pageSize IS NULL BEGIN
				SET @STMT =  'SELECT   ' + @fieldlist + 
							 'FROM     ' + @datasrc +
							 'WHERE    ' + @filter + 
							 'ORDER BY ' + @orderBy
				EXEC (@STMT)                
			  END ELSE BEGIN   
			
				DECLARE
				  @lbound int,
				  @ubound int
			
				SET @pageNum = ABS(@pageNum)
				SET @pageSize = ABS(@pageSize)
				IF @pageNum < 1 SET @pageNum = 1
				IF @pageSize < 1 SET @pageSize = 1
				SET @lbound = ((@pageNum - 1) * @pageSize)
				SET @ubound = @lbound + @pageSize + 1
				
				SET @STMT =  'SELECT  *
							  FROM    (
										SELECT  ROW_NUMBER() OVER(ORDER BY ' + @orderBy + ') AS row,' + @fieldlist + '
										FROM    ' + @datasrc + '
										WHERE   ' + @filter + '
									  ) AS tbl
							  WHERE
									  row > ' + CONVERT(varchar(9), @lbound) + ' AND
									  row < ' + CONVERT(varchar(9), @ubound)
				EXEC (@STMT)             
				
			  END		
		</cfquery>	
		<cfquery name="WRK_PAGE_TOTAL" datasource="#DSN#">
			 CREATE PROCEDURE [WRK_PAGE_TOTAL]
			  @fieldid nvarchar(max) = '*'
			 ,@datasrc nvarchar(max)
			 ,@filter nvarchar(max) = ''
			 ,@pageNum int = 1
			 ,@pageSize int = NULL
			AS
			SET NOCOUNT ON
			  DECLARE
				 @STMT nvarchar(max)   
				,@recct int                 
			 BEGIN
				 SET @STMT =  'SELECT   @recct = COUNT(' + @fieldid + ')
							  FROM     ' + @datasrc + '
							  WHERE    ' + @filter
				EXEC sp_executeSQL @STMT, @params = N'@recct INT OUTPUT', @recct = @recct OUTPUT
				SELECT @recct AS recct     
			  END
		
		</cfquery>--->
		<cfquery name="WRK_OBJECTS_PROC" datasource="#DSN#">
			CREATE PROCEDURE [WRK_OBJECTS_PROC] 
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
		</cfquery>	
		<cfquery name="EMAIL_TYPE_CONTROL" datasource="#DSN#">
			CREATE PROCEDURE [EMAIL_TYPE_CONTROL] 
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
		</cfquery>
        <cfquery name="GET_FUSEACTION_FROM_WRK_APP" datasource="#DSN#">
             CREATE PROCEDURE [GET_FUSEACTION_FROM_WRK_APP] 
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
                            SURNAME
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
        </cfquery>
        <cfquery name="GET_WORKCUBE_APP" datasource="#DSN#">
        	CREATE PROCEDURE [GET_WORKCUBE_APP]
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
			THEIR_RECORDS_ONLY,
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
			DOCK_PHONE,
			REPORT_USER_LEVEL,
			DATA_LEVEL
         FROM 
             WRK_SESSION 
         WHERE 
         	SESSIONID = +@sessInfo
			AND USER_TYPE = +@userType
            --CFTOKEN = +@CFTOCKEN AND 
            --CFID =+@CFID 
        END
        </cfquery>
		<!---Fonksiyonlar siliniyor--->
		<cfquery name="DROP_FUNCTION" datasource="#DSN#">
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Get_Dynamic_Language]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
            	DROP FUNCTION [Get_Dynamic_Language] 
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[IS_ZERO]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
            	DROP FUNCTION [IS_ZERO]
		</cfquery>
        <!---Fonksiyonlar create ediliyor--->
        <cfquery name="CREATE_FUNCTION" datasource="#DSN#">
            CREATE FUNCTION [Get_Dynamic_Language]
            (
            @ID INT,
            @LANGUAGE NVARCHAR(50),
            @TABLE_NAME NVARCHAR(50),
            @COLUMN_NAME NVARCHAR(100),
            @COMPANY_ID INT,
            @PERIOD_ID INT,
            @NAME NVARCHAR(100)
            )
            RETURNS NVARCHAR(100)
            AS
            
            BEGIN;
            DECLARE @LANGUAGE_ORG NVARCHAR(500);
            DECLARE @KOSUL1 NVARCHAR(100); 
            
            
            IF EXISTS(SELECT * FROM SETUP_LANGUAGE_INFO_SETTINGS WHERE COLUMN_NAME=@COLUMN_NAME AND TABLE_NAME=@TABLE_NAME )
            BEGIN
            IF( @COMPANY_ID IS NULL) AND (@PERIOD_ID IS NULL)
            BEGIN  
            SET @LANGUAGE_ORG=(SELECT ITEM 
                           FROM SETUP_LANGUAGE_INFO_SETTINGS 
                           WHERE UNIQUE_COLUMN_ID=@ID AND 
                                 LANGUAGE=@LANGUAGE AND 
                                 COLUMN_NAME=@COLUMN_NAME AND 
                                 TABLE_NAME=@TABLE_NAME)
            SET @KOSUL1=ISNULL(@LANGUAGE_ORG,@NAME)
            END
            ELSE IF @COMPANY_ID IS NOT NULL OR @PERIOD_ID IS NULL
            BEGIN
            SET @LANGUAGE_ORG=(SELECT ITEM 
                           FROM SETUP_LANGUAGE_INFO_SETTINGS  
                           WHERE UNIQUE_COLUMN_ID=@ID AND 
                                 LANGUAGE=@LANGUAGE AND 
                                 COLUMN_NAME=@COLUMN_NAME AND 
                                 TABLE_NAME=@TABLE_NAME AND (COMPANY_ID=@COMPANY_ID))
                                 SET @KOSUL1=ISNULL(@LANGUAGE_ORG,@NAME)
            END
            ELSE IF @COMPANY_ID IS NULL OR @PERIOD_ID IS NOT NULL
            BEGIN
            SET @LANGUAGE_ORG=(SELECT ITEM 
                           FROM SETUP_LANGUAGE_INFO_SETTINGS  
                           WHERE UNIQUE_COLUMN_ID=@ID AND 
                                 LANGUAGE=@LANGUAGE AND 
                                 COLUMN_NAME=@COLUMN_NAME AND 
                                 TABLE_NAME=@TABLE_NAME AND (PERIOD_ID=@PERIOD_ID))
                                 SET @KOSUL1=ISNULL(@LANGUAGE_ORG,@NAME)
            END
            END
            
            ELSE
            BEGIN
            IF( @COMPANY_ID IS NULL) AND (@PERIOD_ID IS NULL)
            BEGIN  
            SET @LANGUAGE_ORG=(SELECT ITEM 
                           FROM SETUP_LANGUAGE_INFO 
                           WHERE UNIQUE_COLUMN_ID=@ID AND 
                                 LANGUAGE=@LANGUAGE AND 
                                 COLUMN_NAME=@COLUMN_NAME AND 
                                 TABLE_NAME=@TABLE_NAME)
            SET @KOSUL1=ISNULL(@LANGUAGE_ORG,@NAME)
            END
            ELSE IF @COMPANY_ID IS NOT NULL OR @PERIOD_ID IS NULL
            BEGIN
            SET @LANGUAGE_ORG=(SELECT ITEM 
                           FROM SETUP_LANGUAGE_INFO 
                           WHERE UNIQUE_COLUMN_ID=@ID AND 
                                 LANGUAGE=@LANGUAGE AND 
                                 COLUMN_NAME=@COLUMN_NAME AND 
                                 TABLE_NAME=@TABLE_NAME AND (COMPANY_ID=@COMPANY_ID))
                                 SET @KOSUL1=ISNULL(@LANGUAGE_ORG,@NAME)
            END
            ELSE IF @COMPANY_ID IS NULL OR @PERIOD_ID IS NOT NULL
            BEGIN
            SET @LANGUAGE_ORG=(SELECT ITEM 
                           FROM SETUP_LANGUAGE_INFO 
                           WHERE UNIQUE_COLUMN_ID=@ID AND 
                                 LANGUAGE=@LANGUAGE AND 
                                 COLUMN_NAME=@COLUMN_NAME AND 
                                 TABLE_NAME=@TABLE_NAME AND (PERIOD_ID=@PERIOD_ID))
                                 SET @KOSUL1=ISNULL(@LANGUAGE_ORG,@NAME)
            END
            END
            RETURN @KOSUL1
            END
        </cfquery>
        <cfquery name="CREATE_FUNCTION" datasource="#DSN#">
            CREATE FUNCTION [IS_ZERO] (
            @Number FLOAT,
            @IsZeroNumber FLOAT
            )
            RETURNS FLOAT
            AS
            BEGIN
            IF (@Number = 0)
            BEGIN
            SET @Number = @IsZeroNumber
            END
            RETURN (@Number)
            END
        </cfquery>
	</cftransaction>
</cflock>
main db de işlemler tamamlandı --><br/>
