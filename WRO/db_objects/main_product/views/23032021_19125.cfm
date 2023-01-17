CREATE VIEW [@_dsn_main_@].[EMPLOYEES_PUANTAJ_COST] AS
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

CREATE VIEW [@_dsn_main_@].[GET_COMPANY_PARTNER_MAIN] AS
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

CREATE VIEW [@_dsn_main_@].[GET_EMPLOYEE_IN_OUT] AS
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
                            (CASE WHEN CTE2.YeniBaslangic= 1 then 'Yeni Ba�lang��' else 'Nakil' end) as GirisTipi,
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

CREATE VIEW [@_dsn_main_@].[GET_MY_COMPANYCAT] AS
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

CREATE VIEW [@_dsn_main_@].[GET_MY_CONSUMERCAT] AS
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

CREATE VIEW [@_dsn_main_@].[SALES_ZONES_ALL_1] AS 
			SELECT
				DISTINCT
				SZ1.SZ_HIERARCHY,
				SZ1.POSITION_CODE,
				SZ1.IMS_ID
			FROM		
			(	
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

CREATE VIEW [@_dsn_main_@].[SALES_ZONES_ALL_2] AS 
			SELECT
				ST2.POSITION_CODE,
				ST2.IMS_ID,
				ST2.COMPANY_CAT_IDS,
				ST2.CONSUMER_CAT_IDS
			FROM
			(
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