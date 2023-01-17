<!---
<cfquery name="get_" datasource="#dsn_dev#">
	SELECT TOP 1 * FROM DimDate WHERE YearCalendar = #year(now())#
</cfquery>
<cfif not get_.recordcount>
	<cfset gun_ = createdate(year(now()),1,1)>
	<cfloop from="0" to="3670" index="i">
		<cfset new_gun_ = dateadd('d',i,gun_)>
        <cfif YEAR(new_gun_) lt 2025>        	
            <cfquery name="add_" datasource="#dsn_dev#">
                INSERT INTO
                    DimDate
                    (
                    FullDate,
                    YearCalendar
                    )
                    VALUES
                    (
                    #createodbcdate(new_gun_)#,
                    #YEAR(gun_)#
                    )
            </cfquery>
        </cfif>
    </cfloop>
</cfif>
--->


<cfset dept_list = '1,3,4,6,7,9,10,11,12,21,22'>


<cfset dept_ = 10>
<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
<cfset attributes.search_startdate = createodbcdatetime(createdate(2018,1,2))>
<cfset attributes.search_finishdate = createodbcdatetime(createdate(2018,1,17))>
<cfset stock_id_ = 30322>


<cfset stock_id_ = "46">


<cfloop list="#stock_id_#" index="sid">
	 <cfquery name="get_1" datasource="#dsn_dev#">
        EXEC ortalama_satis_getir '#stock_id_#','#dateformat(attributes.search_startdate,"yyyy-mm-dd")#','#dateformat(attributes.search_finishdate,"yyyy-mm-dd")#','#dept_#'
    </cfquery>
    <cfdump var="#get_1#">

    <cfquery name="get_1" datasource="#dsn_dev#">
        SELECT fnc_get_ortalama_satis_stok('#stock_id_#',#dept_#,#attributes.search_startdate#,#attributes.search_finishdate#)
    </cfquery>
    <cfdump var="#get_1#">
    
    <cfquery name="get_1" datasource="#dsn_dev#">
        EXEC stock_devir_hizi_getir '#stock_id_#','#dateformat(attributes.search_startdate,"yyyy-mm-dd")#','#dateformat(attributes.search_finishdate,"yyyy-mm-dd")#','#dept_#'
    </cfquery>
    <cfdump var="#get_1#">
    
    
   
</cfloop>

<cfexit method="exittemplate">


<cfquery name="get_" datasource="#dsn_dev#">
SELECT
*
FROM
(
SELECT 
	(SELECT TOP 1 ST.ATT_VALUE FROM SEARCH_TABLES_ROWS_NEW  ST WHERE ST.PRODUCT_CODE LIKE CAST(PRODUCT_ID AS NVARCHAR) + '_%' AND  ST.TABLE_CODE = PT.TABLE_CODE AND ST.ATT_NAME = 'company_code' AND ST.ATT_VALUE <> '' ORDER BY ST.ROW_ID DESC) AS KKK,
	PT.COMPANY_ID,
	PT.PROJECT_ID,
	PT.TABLE_CODE,
	PT.ACTION_CODE,
	PT.PRODUCT_ID,
	PT.ROW_ID,
	PT.STARTDATE 
FROM 
	PRICE_TABLE PT
WHERE 
	YEAR(PT.STARTDATE) = 2017 AND 
	MONTH(PT.STARTDATE) > 0 AND
	PT.COMPANY_ID IS NOT NULL
) T1
WHERE
	KKK NOT LIKE CAST(COMPANY_ID AS NVARCHAR) + '_%'
</cfquery>

<cfoutput query="get_">
	<cfset c_id_ = listfirst(KKK,'_')>
    <cfset p_id_ = listlast(KKK,'_')>
	
    <cfquery name="upd_" datasource="#dsn_dev#">
    UPDATE
    	PRICE_TABLE
    SET
    	COMPANY_ID = #c_id_#,
        PROJECT_ID = #p_id_#,
        OLD_COMPANY_ID = <cfif len(COMPANY_ID)>#COMPANY_ID#<cfelse>NULL</cfif>,
        OLD_PROJECT_ID = <cfif len(PROJECT_ID)>#PROJECT_ID#<cfelse>NULL</cfif>
    WHERE
    	ROW_ID = #row_id#
     </cfquery>
</cfoutput>


<cfexit method="exittemplate">
<cfset product_id = 6277>
<cfset stock_id = 6281>
<cfset COMPANY_ID_ = 1721>
<cfset stock_id_ = 6281>

<cfquery name="get_periods" datasource="#dsn#">
	SELECT * FROM SETUP_PERIOD WHERE PERIOD_YEAR IN (2016,2017)
</cfquery>

<cfset o_gun_maliyet = wrk_round(get_daily_maliyet(product_id,stock_id,2017,2,10),2)>

<CFDUMP var="#o_gun_maliyet#">

<cfset gun_ilk_alis_ = createodbcdatetime(createdate(2017,2,2))>
<cfset gun_son_alis_ = createodbcdatetime(createdate(2017,2,10))>

<cfset gun_ilk_ = createodbcdatetime(createdate(2017,2,2))>
<cfset gun_son_ = createodbcdatetime(createdate(2017,2,10))>

<cfquery name="get_satis" datasource="#dsn#">
SELECT
    SUM(SATIS1) AS SATIS
FROM
    (
         <cfset count_ = 0>
         <cfloop query="get_periods">
         <cfset count_ = count_ + 1>
          <cfif count_ neq 1>
                UNION ALL
          </cfif>
         
            SELECT
                SUM(IRP.AMOUNT) AS SATIS1
            FROM
                #dsn#_#period_year#_#our_company_id#.INVOICE_ROW_POS IRP,
                #dsn#_#period_year#_#our_company_id#.INVOICE I
            WHERE
                IRP.STOCK_ID = #stock_id_# AND
                IRP.INVOICE_ID = I.INVOICE_ID AND
                I.INVOICE_DATE BETWEEN #createodbcdatetime(gun_ilk_)# AND #createodbcdatetime(gun_son_)#
            UNION ALL
			
            SELECT
                SUM(IRP.AMOUNT) AS SATIS1
            FROM
                #dsn#_#period_year#_#our_company_id#.INVOICE_ROW IRP,
                #dsn#_#period_year#_#our_company_id#.INVOICE I
            WHERE
                I.INVOICE_CAT = 52 AND
                I.PROCESS_CAT = 93 AND
                IRP.STOCK_ID = #stock_id_# AND
                IRP.INVOICE_ID = I.INVOICE_ID AND
                I.INVOICE_DATE BETWEEN #createodbcdatetime(gun_ilk_)# AND #createodbcdatetime(gun_son_)#
		   UNION ALL
           
            SELECT
                SUM(SR.STOCK_OUT - SR.STOCK_IN) AS SATIS1
            FROM
                #dsn#_#period_year#_#our_company_id#.STOCKS_ROW SR
            WHERE
                SR.PROCESS_TYPE IN (-1003,-1004,-1005) AND
                SR.STOCK_ID = #stock_id_# AND
                SR.PROCESS_DATE >= #createodbcdatetime(gun_ilk_)# AND
               	SR.PROCESS_DATE  < #dateadd('d',1,createodbcdatetime(gun_son_))#
        </cfloop>
    ) AS T1
</cfquery>

<cfdump var="#get_satis#">

<cfquery name="get_alislar" datasource="#dsn#">
SELECT
    SUM(T1.NETTOTAL) ALIS_TUTARLAR,
    SUM(T1.AMOUNT) ALISLAR
FROM
    (
     <cfset count_ = 0>
     <cfloop query="get_periods">
     <cfset count_ = count_ + 1>
      <cfif count_ neq 1>
            UNION ALL
      </cfif>
            SELECT
                IR.NETTOTAL,
                IR.AMOUNT,
                IC_TABLE.SHIP_DATE,
                I.INVOICE_DATE
            FROM
                #dsn#_#period_year#_#our_company_id#.INVOICE I,
                #dsn#_#period_year#_#our_company_id#.INVOICE_ROW IR
                    LEFT JOIN
                        (
                            SELECT
                                S.SHIP_DATE,
                                SR.WRK_ROW_ID,
                                ISS.INVOICE_ID
                            FROM
                                #dsn#_#period_year#_#our_company_id#.INVOICE_SHIPS ISS,
                                #dsn#_#period_year#_#our_company_id#.SHIP S,
                                #dsn#_#period_year#_#our_company_id#.SHIP_ROW SR
                            WHERE
                                ISS.SHIP_ID = S.SHIP_ID AND
                                S.SHIP_ID = SR.SHIP_ID
                        ) IC_TABLE ON (IR.WRK_ROW_RELATION_ID = IC_TABLE.WRK_ROW_ID AND IC_TABLE.INVOICE_ID = IR.INVOICE_ID)
            WHERE
                I.COMPANY_ID = #COMPANY_ID_# AND
                IR.STOCK_ID = #stock_id_# AND
                I.INVOICE_ID = IR.INVOICE_ID AND
                ISNULL(I.IS_IPTAL,0) = 0 AND
                I.PROCESS_CAT NOT IN (#dahil_olmayan_tipler#) AND
                I.PURCHASE_SALES = 0
     </cfloop>
     ) T1
WHERE
    (
    SHIP_DATE IS NOT NULL AND
    SHIP_DATE <= INVOICE_DATE AND 
    ISNULL(SHIP_DATE,INVOICE_DATE) BETWEEN #createodbcdatetime(gun_ilk_alis_)# AND #createodbcdatetime(gun_son_alis_)#
    )
    OR
    (
    SHIP_DATE > INVOICE_DATE AND 
    INVOICE_DATE BETWEEN #createodbcdatetime(gun_ilk_alis_)# AND #createodbcdatetime(gun_son_alis_)#
    )
</cfquery>

<cfdump var="#get_alislar#">


<cfexit method="exittemplate">
<cfquery name="get_actions" datasource="#dsn#_2016_1">
    SELECT
        TYPE,
        SUM(TOPLAM) AS G_TOTAL,
        ISLEM_TARIHI,
        ISNULL((SELECT ISNULL(SUM(SR.STOCK_IN - SR.STOCK_OUT),0) AS MEVCUT_STOCK FROM STOCKS_ROW SR WHERE SR.STOCK_ID = 13077 AND SR.PROCESS_DATE < T1.ISLEM_TARIHI),0) AS GUN_SONU_STOK
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
                SFR.STOCK_ID = 13077
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
                SR.STOCK_ID = 13077
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
    <cfdump var="#get_actions#">



<cfif get_actions.recordcount>
        <cfset tutar_toplam_ = 0>
        <cfset miktar_toplam_ = 0>
        <cfset ilk_maliyet_ = 0>
        <!--- <cfset last_maliyet_ = -1> --->
		<cfset last_maliyet_ = get_daily_cost_price(PRODUCT_ID,session.ep.period_year,1,1,0,0)>
            <cfoutput query="get_actions">
                    <cfquery name="get_daily_fiyat" datasource="#dsn1#">
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
                                    #DSN_DEV#.PRICE_TABLE PT1
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
                            PRODUCT P,
                            PRICE_STANDART PS
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
                    #tlformat(maliyet_,2)#
                <cfelse>
                    <cfset maliyet_= ilk_deger_>
                    #tlformat(maliyet_,2)#
                </cfif>
        
                #ilk_deger_# #maliyet_# <br />
                <cfset last_maliyet_ = maliyet_>
            </cfoutput>
    <cfelse>
        <cfset last_maliyet_ = 0>
    </cfif>
<cfexit method="exittemplate">

<cfset dept_list = '1,3,4,6,7,9,10,11,12,21,22'>


<cfset dept_ = 10>
<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
<cfset attributes.search_startdate = createodbcdatetime(createdate(2016,2,14))>
<cfset attributes.search_finishdate = createodbcdatetime(createdate(2016,5,13))>
<cfset stock_id_ = 30322>


<cfset stock_id_ = "1898">


<cfloop list="#stock_id_#" index="sid">
	 <cfquery name="get_1" datasource="#dsn_dev#">
        EXEC ortalama_satis_getir '#sid#','#dateformat(attributes.search_startdate,"yyyy-mm-dd")#','#dateformat(attributes.search_finishdate,"yyyy-mm-dd")#','#dept_#'
    </cfquery>
    <cfdump var="#get_1#">

    <cfquery name="get_1" datasource="#dsn_dev#">
        SELECT fnc_get_ortalama_satis_stok('#sid#',#dept_#,#attributes.search_startdate#,#attributes.search_finishdate#)
    </cfquery>
    <cfdump var="#get_1#">
    
    <cfquery name="get_1" datasource="#dsn_dev#">
        EXEC stock_devir_hizi_getir '#sid#','#dateformat(attributes.search_startdate,"yyyy-mm-dd")#','#dateformat(attributes.search_finishdate,"yyyy-mm-dd")#','#dept_#'
    </cfquery>
    <cfdump var="#get_1#">
    
</cfloop>

