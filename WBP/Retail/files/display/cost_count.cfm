<cffunction name="get_daily_cost_price" returntype="string" output="false">
	<cfargument name="product_id" required="true">
	<cfargument name="yil" required="true">
    <cfargument name="ay" required="true">
    <cfargument name="gun" required="true">
    <cfargument name="company_id" required="true">
    <cfargument name="project_id" required="true">
    
<cfset kasa_cikislar = "3,8,9,10,13">
<cfset kasa_cikis_olmayanlar = "2,4,5,12">
<cfset fazla_stok = "1">

    <cfset tarih_ = createodbcdatetime(createdate(arguments.yil,arguments.ay,arguments.gun))>
    
    <cfquery name="get_price" datasource="#dsn2#">
    	SELECT
            ISNULL((
                SELECT TOP 1
                    PTS.STANDART_ALIS_LISTE
                FROM
                    #dsn_dev_alias#.PRICE_TABLE_STANDART PTS
                WHERE
                    PTS.STD_P_STARTDATE <= #tarih_# AND
                    PTS.PRODUCT_ID = P.PRODUCT_ID
                ORDER BY
                	PTS.RECORD_DATE DESC,
                    PTS.STD_P_STARTDATE DESC,
                    PTS.STANDART_ALIS ASC
            ),9999) AS OGUNKU_STANDART_FIYAT,
            ROUND(PS.PRICE,4) AS AKTIF_STANDART_FIYAT,
            ISNULL(( 
                SELECT TOP 1 
                    PT1.NEW_ALIS
                FROM
                    #dsn_dev_alias#.PRICE_TABLE PT1
                WHERE
                    <cfif arguments.project_id gt 0>
                    	PT1.PROJECT_ID = #arguments.project_id# AND
                    </cfif>
                    <cfif arguments.company_id gt 0>
                   		PT1.COMPANY_ID = #arguments.company_id# AND
                    </cfif>
                    PT1.PRICE_TYPE NOT IN (#kasa_cikislar#) AND
                    PT1.IS_ACTIVE_P = 1 AND
                    PT1.P_STARTDATE <= #tarih_# AND 
                    DATEADD("d",-1,PT1.P_FINISHDATE) >= #tarih_# AND
                    (PT1.PRODUCT_ID = P.PRODUCT_ID)
                ORDER BY
                    PT1.P_STARTDATE DESC,
                    PT1.ROW_ID DESC
            ),9999) AS LISTE_FIYATI
        FROM
            #dsn1_alias#.PRODUCT P,
            #dsn1_alias#.PRICE_STANDART PS
        WHERE
            PS.PRODUCT_ID = P.PRODUCT_ID AND
            PS.PURCHASESALES = 0 AND
            PS.PRICESTANDART_STATUS = 1 AND
            P.PRODUCT_ID = #arguments.product_id#
    </cfquery>
    <cfset ilk_deger_ = 0>
    
	<cfoutput query="get_price">
    	<cfif OGUNKU_STANDART_FIYAT lt 9999>
            <cfset ilk_deger_ = OGUNKU_STANDART_FIYAT>
        </cfif>
        <cfif LISTE_FIYATI lt 9999 and LISTE_FIYATI lt OGUNKU_STANDART_FIYAT>
            <cfset ilk_deger_ = LISTE_FIYATI>
        </cfif>
        <cfif OGUNKU_STANDART_FIYAT eq 9999 and LISTE_FIYATI eq 9999>
            <cfset ilk_deger_ = AKTIF_STANDART_FIYAT>
        </cfif>
    </cfoutput>
    
    <cfset price_ = ilk_deger_>
    <cfreturn price_>
</cffunction>

<cffunction name="get_daily_maliyet" returntype="string" output="false">
    <cfargument name="product_id" required="true">
    <cfargument name="stock_id" required="true">
	<cfargument name="yil" required="true">
    <cfargument name="ay" required="true">
    <cfargument name="gun" required="true">

	<cfset product_id = arguments.product_id>
    <cfset stock_id = arguments.stock_id>
    <cfset attributes.yil = arguments.yil>
    <cfset attributes.ay = arguments.ay>
    <cfset attributes.gun = arguments.gun>
    
    
    <cfset kasa_cikislar = "3,8,9,10,13">
    <cfset kasa_cikis_olmayanlar = "2,4,5,12">
    <cfset fazla_stok = "1">
    
    <cfset tarih_ = createodbcdatetime(createdate(attributes.yil,attributes.ay,attributes.gun))>
    
    <cfquery name="get_actions" datasource="#dsn#_#yil#_1">
    SELECT
        TYPE,
        SUM(TOPLAM) AS G_TOTAL,
        ISLEM_TARIHI,
        ISNULL((SELECT ISNULL(SUM(SR.STOCK_IN - SR.STOCK_OUT),0) AS MEVCUT_STOCK FROM STOCKS_ROW SR WHERE SR.STOCK_ID = #stock_id# AND SR.PROCESS_DATE < T1.ISLEM_TARIHI),0) AS GUN_SONU_STOK
    FROM
        (
            SELECT
                1 AS TYPE,
                SUM(SFR.AMOUNT) AS TOPLAM,
                SF.FIS_DATE AS ISLEM_TARIHI
            FROM
                STOCK_FIS SF,
                STOCK_FIS_ROW SFR
            WHERE 
                SF.FIS_ID = SFR.FIS_ID AND
                SF.FIS_TYPE = 114 AND
                SFR.STOCK_ID = #stock_id# 
            GROUP BY
                SF.FIS_DATE
        UNION ALL
            SELECT
                1 AS TYPE,
                SUM(SR.AMOUNT),
                S.SHIP_DATE AS ISLEM_TARIHI
            FROM
                SHIP S,
                SHIP_ROW SR
            WHERE
                S.IS_SHIP_IPTAL = 0 AND
                S.SHIP_ID = SR.SHIP_ID AND
                S.SHIP_TYPE = 76 AND
                SR.STOCK_ID = #stock_id#
            GROUP BY
                S.SHIP_DATE
       ) T1
    WHERE
        ISLEM_TARIHI <= #tarih_#
    GROUP BY
        TYPE,
        ISLEM_TARIHI
    ORDER BY
        TYPE
    </cfquery>
	<cfif get_actions.recordcount>
        <cfset tutar_toplam_ = 0>
        <cfset miktar_toplam_ = 0>
        <cfset ilk_maliyet_ = 0>
        <!--- <cfset last_maliyet_ = -1> --->
		<cfset last_maliyet_ = get_daily_cost_price(PRODUCT_ID,session.ep.period_year,1,1,0,0)>
            <cfoutput query="get_actions">
                    <cfquery name="get_daily_fiyat" datasource="#dsn2#">
                        SELECT
                            ISNULL((
                            SELECT TOP 1
                                PTS.STANDART_ALIS_LISTE
                            FROM
                                #DSN_DEV_ALIAS#.PRICE_TABLE_STANDART PTS
                            WHERE
                                PTS.STD_P_STARTDATE <= #CREATEODBCDATETIME(ISLEM_TARIHI)# AND
                                PTS.PRODUCT_ID = P.PRODUCT_ID
                            ORDER BY
                                PTS.STD_P_STARTDATE DESC,
                                PTS.STANDART_ALIS ASC
                            ),9999) AS OGUNKU_STANDART_FIYAT,
                            ROUND(PS.PRICE,4) AS AKTIF_STANDART_FIYAT,
                            ISNULL(( 
                                SELECT TOP 1 
                                    PT1.NEW_ALIS
                                FROM
                                    #DSN_DEV_ALIAS#.PRICE_TABLE PT1
                                WHERE
                                    (
                                    PT1.PRICE_TYPE IN (#fazla_stok#,#kasa_cikis_olmayanlar#)
                                    OR
                                    PT1.PRICE_TYPE IS NULL
                                    ) 
                                    AND
                                    PT1.IS_ACTIVE_P = 1 AND
                                    PT1.P_STARTDATE <= #CREATEODBCDATETIME(ISLEM_TARIHI)# AND 
                                    DATEADD("d",-1,PT1.P_FINISHDATE) >= #CREATEODBCDATETIME(ISLEM_TARIHI)# AND
                                    PT1.PRODUCT_ID = P.PRODUCT_ID
                                ORDER BY
                                    PT1.NEW_ALIS ASC,
                                    PT1.P_STARTDATE DESC,
                                    PT1.ROW_ID DESC
                            ),9999) AS LISTE_FIYATI
                      FROM
                            #dsn1_alias#.PRODUCT P,
                            #dsn1_alias#.PRICE_STANDART PS
                      WHERE
                            P.PRODUCT_ID = #PRODUCT_ID# AND
                            P.PRODUCT_ID = PS.PRODUCT_ID AND
                            PS.PURCHASESALES = 0 AND
                            PS.PRICESTANDART_STATUS = 1
                    </cfquery>
                    <cfif get_daily_fiyat.OGUNKU_STANDART_FIYAT lt 9999>
                        <cfset ilk_deger_ = get_daily_fiyat.OGUNKU_STANDART_FIYAT>
                    </cfif>
                    <cfif get_daily_fiyat.LISTE_FIYATI lt 9999 and get_daily_fiyat.LISTE_FIYATI lt get_daily_fiyat.OGUNKU_STANDART_FIYAT>
                        <cfset ilk_deger_ = get_daily_fiyat.LISTE_FIYATI>
                    </cfif>
                    <cfif get_daily_fiyat.OGUNKU_STANDART_FIYAT eq 9999 and get_daily_fiyat.LISTE_FIYATI eq 9999>
                        <cfset ilk_deger_ = get_daily_fiyat.AKTIF_STANDART_FIYAT>
                    </cfif>
                    <cfset tutar_toplam_ = tutar_toplam_ + (G_TOTAL * ilk_deger_)>
                    <cfset miktar_toplam_ = miktar_toplam_ + G_TOTAL>
                    <cfset maliyet_ = 0 >
        
                <cfif GUN_SONU_STOK eq 0>
                    <cfif GUN_SONU_STOK + G_TOTAL eq 0>
                        <cfset maliyet_ = last_maliyet_>
                    <cfelse>
                        <cfset maliyet_ = ((last_maliyet_ * GUN_SONU_STOK) + (G_TOTAL * ilk_deger_)) / (GUN_SONU_STOK + G_TOTAL)>
                    </cfif>
                <cfelse>
                    <cfset maliyet_= ilk_deger_>
                </cfif>
                <cfset last_maliyet_ = maliyet_>
            </cfoutput>
    <cfelse>
        <cfset last_maliyet_ = 0>
    </cfif>
    <cfreturn last_maliyet_>
</cffunction>

<cffunction name="get_daily_maliyet_dept" returntype="string" output="false">
	<cfargument name="department_ids" required="true">
    <cfargument name="product_id" required="true">
    <cfargument name="stock_id" required="true">
	<cfargument name="yil" required="true">
    <cfargument name="ay" required="true">
    <cfargument name="gun" required="true">

	<cfset product_id = arguments.product_id>
    <cfset stock_id = arguments.stock_id>
    <cfset attributes.yil = arguments.yil>
    <cfset attributes.ay = arguments.ay>
    <cfset attributes.gun = arguments.gun>
    
    
    <cfset kasa_cikislar = "3,8,9,10,13">
    <cfset kasa_cikis_olmayanlar = "2,4,5,12">
    <cfset fazla_stok = "1">
    
    <cfset tarih_ = createodbcdatetime(createdate(attributes.yil,attributes.ay,attributes.gun))>
    
    <cfquery name="get_actions" datasource="#dsn2#">
    SELECT
        TYPE,
        SUM(TOPLAM) AS G_TOTAL,
        ISLEM_TARIHI,
        ISNULL((SELECT ISNULL(SUM(SR.STOCK_IN - SR.STOCK_OUT),0) AS MEVCUT_STOCK FROM STOCKS_ROW SR WHERE SR.STOCK_ID = #stock_id# AND SR.PROCESS_DATE < T1.ISLEM_TARIHI),0) AS GUN_SONU_STOK
    FROM
        (
            SELECT
                1 AS TYPE,
                SUM(SFR.AMOUNT) AS TOPLAM,
                SF.FIS_DATE AS ISLEM_TARIHI
            FROM
                STOCK_FIS SF,
                STOCK_FIS_ROW SFR
            WHERE 
                (
                    SF.DEPARTMENT_IN IN (#department_ids#)
                    OR
                    SF.DEPARTMENT_OUT IN (#department_ids#)
                ) AND
                SF.FIS_ID = SFR.FIS_ID AND
                SF.FIS_TYPE = 114 AND
                SFR.STOCK_ID = #stock_id# 
            GROUP BY
                SF.FIS_DATE
        UNION ALL
            SELECT
                1 AS TYPE,
                SUM(SR.AMOUNT),
                S.SHIP_DATE AS ISLEM_TARIHI
            FROM
                SHIP S,
                SHIP_ROW SR
            WHERE
                S.DEPARTMENT_IN IN (#department_ids#) AND
                S.IS_SHIP_IPTAL = 0 AND
                S.SHIP_ID = SR.SHIP_ID AND
                S.SHIP_TYPE = 76 AND
                SR.STOCK_ID = #stock_id#
            GROUP BY
                S.SHIP_DATE
       ) T1
    WHERE
        ISLEM_TARIHI <= #tarih_#
    GROUP BY
        TYPE,
        ISLEM_TARIHI
    ORDER BY
        TYPE
    </cfquery>
	<cfif get_actions.recordcount>
        <cfset tutar_toplam_ = 0>
        <cfset miktar_toplam_ = 0>
        <cfset ilk_maliyet_ = 0>
        <!--- <cfset last_maliyet_ = -1> --->
		<cfset last_maliyet_ = get_daily_cost_price(PRODUCT_ID,session.ep.period_year,1,1,0,0)>
        
            <cfoutput query="get_actions">
                    <cfquery name="get_daily_fiyat" datasource="#dsn2#">
                        SELECT
                            ISNULL((
                            SELECT TOP 1
                                PTS.STANDART_ALIS_LISTE
                            FROM
                                #DSN_DEV_ALIAS#.PRICE_TABLE_STANDART PTS
                            WHERE
                                PTS.STD_P_STARTDATE <= #CREATEODBCDATETIME(ISLEM_TARIHI)# AND
                                PTS.PRODUCT_ID = P.PRODUCT_ID
                            ORDER BY
                                PTS.STD_P_STARTDATE DESC,
                                PTS.STANDART_ALIS ASC
                            ),9999) AS OGUNKU_STANDART_FIYAT,
                            ROUND(PS.PRICE,4) AS AKTIF_STANDART_FIYAT,
                            ISNULL(( 
                                SELECT TOP 1 
                                    PT1.NEW_ALIS
                                FROM
                                    #DSN_DEV_ALIAS#.PRICE_TABLE PT1
                                WHERE
                                    (
                                    PT1.PRICE_TYPE IN (#fazla_stok#,#kasa_cikis_olmayanlar#)
                                    OR
                                    PT1.PRICE_TYPE IS NULL
                                    ) 
                                    AND
                                    PT1.IS_ACTIVE_P = 1 AND
                                    PT1.P_STARTDATE <= #CREATEODBCDATETIME(ISLEM_TARIHI)# AND 
                                    DATEADD("d",-1,PT1.P_FINISHDATE) >= #CREATEODBCDATETIME(ISLEM_TARIHI)# AND
                                    PT1.PRODUCT_ID = P.PRODUCT_ID
                                ORDER BY
                                    PT1.NEW_ALIS ASC,
                                    PT1.P_STARTDATE DESC,
                                    PT1.ROW_ID DESC
                            ),9999) AS LISTE_FIYATI
                      FROM
                            #dsn1_alias#.PRODUCT P,
                            #dsn1_alias#.PRICE_STANDART PS
                      WHERE
                            P.PRODUCT_ID = #PRODUCT_ID# AND
                            P.PRODUCT_ID = PS.PRODUCT_ID AND
                            PS.PURCHASESALES = 0 AND
                            PS.PRICESTANDART_STATUS = 1
                    </cfquery>
                    <cfif get_daily_fiyat.OGUNKU_STANDART_FIYAT lt 9999>
                        <cfset ilk_deger_ = get_daily_fiyat.OGUNKU_STANDART_FIYAT>
                    </cfif>
                    <cfif get_daily_fiyat.LISTE_FIYATI lt 9999 and get_daily_fiyat.LISTE_FIYATI lt get_daily_fiyat.OGUNKU_STANDART_FIYAT>
                        <cfset ilk_deger_ = get_daily_fiyat.LISTE_FIYATI>
                    </cfif>
                    <cfif get_daily_fiyat.OGUNKU_STANDART_FIYAT eq 9999 and get_daily_fiyat.LISTE_FIYATI eq 9999>
                        <cfset ilk_deger_ = get_daily_fiyat.AKTIF_STANDART_FIYAT>
                    </cfif>
                    <cfset tutar_toplam_ = tutar_toplam_ + (G_TOTAL * ilk_deger_)>
                    <cfset miktar_toplam_ = miktar_toplam_ + G_TOTAL>
                    <cfset maliyet_ = 0 >
        
                <cfif GUN_SONU_STOK gt 0>
                    <cfif GUN_SONU_STOK + G_TOTAL eq 0>
                        <cfset maliyet_ = last_maliyet_>
                    <cfelse>
                        <cfset maliyet_ = ((last_maliyet_ * GUN_SONU_STOK) + (G_TOTAL * ilk_deger_)) / (GUN_SONU_STOK + G_TOTAL)>
                    </cfif>
                <cfelse>
                    <cfset maliyet_= ilk_deger_>
                </cfif>
                <cfset last_maliyet_ = maliyet_>
            </cfoutput>
    <cfelse>
        <cfset last_maliyet_ = 0>
    </cfif>
    <cfreturn last_maliyet_>
</cffunction>