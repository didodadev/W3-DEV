
<cfset dept_ = 6>
<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
<cfset attributes.search_startdate = dateadd("d",-90,bugun_)>
<cfset attributes.search_finishdate = dateadd("d",-3,bugun_)>
<cfset stock_id_ = 15265>


<cfquery name="get_rows" datasource="#dsn_dev#">
    SELECT
        D1.S_TARIH TARIH,
        D1.DEPARTMENT_ID,
        D1.SALES_COUNT AS SATIS_MIKTAR,
        D1.STOCK_COUNT AS STOCK_MIKTAR,
        D1.STOCK_APPLY
    FROM
        DAILY_STOCK_ACTIONS_16BIN D1
    WHERE
        D1.STOCK_ID = #stock_id_# AND
        D1.S_TARIH BETWEEN #attributes.search_startdate# AND #attributes.search_finishdate# AND
        (
            (#dept_# = 13 AND D1.DEPARTMENT_ID <> 13 ) OR
        	(#dept_# <> 13 AND D1.DEPARTMENT_ID = #dept_#)  
        )
   	ORDER BY
    	D1.S_TARIH DESC
</cfquery>
<cfdump var="#get_rows#">


<!---
<cfquery name="get_1" datasource="#dsn_dev#">
    SELECT fnc_get_ortalama_satis_stok(#stock_id_#,#dept_#,#attributes.search_startdate#,#attributes.search_finishdate#)
</cfquery>
<cfdump var="#get_1#">

<cfquery name="get_2" datasource="#dsn_dev#">
    SELECT fnc_get_ortalama_satis_stok2(#stock_id_#,#dept_#,#attributes.search_startdate#,#attributes.search_finishdate#)
</cfquery>
<cfdump var="#get_2#">


<cfquery name="get_3" datasource="#dsn_dev#">
	EXEC pro_get_ortalama_satis_stok_new #stock_id_#,#dept_#,#attributes.search_startdate#,#attributes.search_finishdate#
</cfquery>
<cfdump var="#get_3#">

--->
<cfexit method="exittemplate">

<hr /><hr />

<!---
<cfquery name="get_3" datasource="#dsn_dev#">
	EXEC pro_get_ortalama_satis_stok_new #stock_id_#,#dept_#,#attributes.search_startdate#,#attributes.search_finishdate#
</cfquery>
<cfdump var="#get_3#">
--->



<cfquery name="get_3" datasource="#dsn_Dev#">
SELECT
    ROUND(SUM(TOPLAM_SATIS/TOPLAM_GUN),2)						
FROM
    (
    SELECT
        SUM(SATIS_MIKTAR) AS TOPLAM_SATIS,
        COUNT(CASE WHEN (STOCK_MIKTAR > 0 OR SATIS_MIKTAR <> 0) THEN 1 ELSE NULL END) AS TOPLAM_GUN,
        DEPARTMENT_HEAD
    FROM
        (
            SELECT
                TARIH,
                DEPARTMENT_HEAD,
                ISNULL(SUM(SR4.STOCK_OUT - SR4.STOCK_IN),0) SATIS_MIKTAR,
                STOCK_MIKTAR
            FROM
                (
                SELECT
                    T1.TARIH,
                    T1.DEPARTMENT_HEAD,
                    T1.DEPARTMENT_ID,
                    ISNULL(SUM(SR3.STOCK_IN-SR3.STOCK_OUT),0) AS STOCK_MIKTAR
                FROM
                    (
                        SELECT
                            PPD.TARIH,
                            D.DEPARTMENT_HEAD,
                            D.DEPARTMENT_ID,
                            D.IS_STORE
                        FROM
                            PRODUCT_PRICE_DATES PPD,
                            workcube_gulgen.DEPARTMENT D
                        WHERE
                            (
                                   (#dept_# = 13 AND D.DEPARTMENT_ID <> 13 ) OR
                                   (#dept_# <> 13 AND D.DEPARTMENT_ID = #dept_#)  
                             )
                             AND
                            D.IS_STORE IN (1,3) AND
                            ISNULL(D.IS_PRODUCTION,0) = 0 AND
                            D.DEPARTMENT_ID NOT IN (13,17) AND
                            PPD.TARIH BETWEEN #attributes.search_startdate# AND #attributes.search_finishdate#
                    ) T1
                        LEFT JOIN GET_STOCK_ROWS SR3 ON 
                            (
                                SR3.STOCK_ID = #stock_id_# AND
                                SR3.PROCESS_DATE <= T1.TARIH AND
                                YEAR(SR3.PROCESS_DATE) = YEAR(T1.TARIH) AND
                                SR3.STORE = T1.DEPARTMENT_ID
                            )
                GROUP BY
                    T1.TARIH,
                    T1.DEPARTMENT_HEAD,
                    T1.DEPARTMENT_ID
                ) 
                GUNLER
                     LEFT JOIN GET_STOCK_ROWS SR4 ON 
                        (
                            SR4.STOCK_ID = #stock_id_# AND 
                            YEAR(SR4.PROCESS_DATE) = YEAR(GUNLER.TARIH) AND
                            MONTH(SR4.PROCESS_DATE) = MONTH(GUNLER.TARIH) AND
                            DAY(SR4.PROCESS_DATE) = DAY(GUNLER.TARIH) AND
                            SR4.PROCESS_TYPE IN (67,52,70,-1003,-1005) AND
                            SR4.STORE = GUNLER.DEPARTMENT_ID
                        )
            GROUP BY
                TARIH,
                DEPARTMENT_HEAD,
                STOCK_MIKTAR
        ) TSON1
   GROUP BY
        DEPARTMENT_HEAD
     ) TSON
    WHERE
		TOPLAM_GUN > 0
</cfquery>
<cfdump var="#get_3#" label="dokum">
<!---
<cfquery name="get_4" datasource="#dsn_dev#">
	SELECT
        SUM(SATIS_MIKTAR) AS TOPLAM_SATIS,
        COUNT(CASE WHEN (STOCK_MIKTAR > 0 OR SATIS_MIKTAR <> 0) THEN 1 ELSE NULL END) AS TOPLAM_GUN,
        DEPARTMENT_HEAD
    FROM
        (
            SELECT
                TARIH,
                DEPARTMENT_HEAD,
                ISNULL(SUM(SR4.STOCK_OUT - SR4.STOCK_IN),0) SATIS_MIKTAR,
                STOCK_MIKTAR
            FROM
                (
                SELECT
                    T1.TARIH,
                    T1.DEPARTMENT_HEAD,
                    T1.DEPARTMENT_ID,
                    ISNULL(SUM(SR3.STOCK_IN-SR3.STOCK_OUT),0) AS STOCK_MIKTAR
                FROM
                    (
                        SELECT
                            PPD.TARIH,
                            D.DEPARTMENT_HEAD,
                            D.DEPARTMENT_ID,
                            D.IS_STORE
                        FROM
                            PRODUCT_PRICE_DATES PPD,
                            workcube_gulgen.DEPARTMENT D
                        WHERE
                            (
                                   (#dept_# = 13 AND D.DEPARTMENT_ID <> 13 ) OR
                                   (#dept_# <> 13 AND D.DEPARTMENT_ID = #dept_#)  
                             )
                             AND
                            D.IS_STORE IN (1,3) AND
                            ISNULL(D.IS_PRODUCTION,0) = 0 AND
                            D.DEPARTMENT_ID NOT IN (13,17) AND
                            PPD.TARIH BETWEEN #attributes.search_startdate# AND #attributes.search_finishdate#
                    ) T1
                        LEFT JOIN GET_STOCK_ROWS SR3 ON 
                            (
                                SR3.STOCK_ID =  #stock_id_# AND
                                SR3.PROCESS_DATE <= T1.TARIH AND
                                YEAR(SR3.PROCESS_DATE) = YEAR(T1.TARIH) AND
                                SR3.STORE = T1.DEPARTMENT_ID
                            )
                GROUP BY
                    T1.TARIH,
                    T1.DEPARTMENT_HEAD,
                    T1.DEPARTMENT_ID
                ) 
                GUNLER
                     LEFT JOIN GET_STOCK_ROWS SR4 ON 
                        (
                            SR4.STOCK_ID =  #stock_id_# AND 
                            YEAR(SR4.PROCESS_DATE) = YEAR(GUNLER.TARIH) AND
                        	MONTH(SR4.PROCESS_DATE) = MONTH(GUNLER.TARIH) AND
                        	DAY(SR4.PROCESS_DATE) = DAY(GUNLER.TARIH) AND
                            SR4.PROCESS_TYPE IN (67,52,70,-1003,-1005)
                        )
            GROUP BY
                TARIH,
                DEPARTMENT_HEAD,
                STOCK_MIKTAR
     ) TSON1
    GROUP BY
        DEPARTMENT_HEAD
</cfquery>
<cfdump var="#get_4#">
--->