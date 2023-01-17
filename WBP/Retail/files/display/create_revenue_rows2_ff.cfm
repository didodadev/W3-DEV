<cfif isdefined("attributes.is_clear_old_rows")>
    <cfquery name="cont_" datasource="#dsn_dev#">
        DELETE
        FROM
            INVOICE_FF_ROWS
        WHERE
        	FF_TYPE IN (0,2) AND
            INVOICE_ID IS NOT NULL AND
			<cfif isdefined("attributes.company_ids") and len(attributes.company_ids)>
                COMPANY_ID IN (#attributes.company_ids#) AND
            </cfif>
            INVOICE_DATE >= #attributes.startdate# AND
            INVOICE_DATE <= #attributes.finishdate# AND
            ISNULL(FF_PAID,0) = 0
    </cfquery>
</cfif>

<!--- FİYAT FARKLARI --->
<cfquery name="get_comps_invoice_all" datasource="#dsn2#" result="result1">
SELECT
	*,
    ISNULL(SHIP_DATE,INVOICE_DATE) ISLEM_TARIHI
FROM
(
    SELECT
        I.PROCESS_CAT,
        ISNULL((SELECT COUNT(IR2.INVOICE_ID) FROM INVOICE_ROW IR2 WHERE IR2.NETTOTAL = 0 AND IR2.INVOICE_ID = I.INVOICE_ID),0) SIFIR_BEDELLI,
        T1.COMP_CODE,
        ISNULL(P.PROJECT_ID,0) AS PRODUCT_PROJECT_ID,
        ISNULL(P.COMPANY_ID,0) AS PRODUCT_COMPANY_ID,
        I.COMPANY_ID,
        IR.TAX,
        I.PROJECT_ID,
        IC_TABLE.SHIP_DATE,
        I.INVOICE_DATE,
        I.INVOICE_ID,
        T1.TEDARIKCI_ADI,
        T1.PROJE_ADI,
        I.INVOICE_NUMBER,
        IR.NAME_PRODUCT,
        IR.INVOICE_ROW_ID,
        IR.WRK_ROW_ID,
        IR.NETTOTAL,
        ROUND(IR.NETTOTAL / IR.AMOUNT,4) AS FATURA_FIYATI,
        IR.PRODUCT_ID,
        IR.STOCK_ID,
        IR.AMOUNT,
        ISNULL((
            SELECT TOP 1
                PTS.STANDART_ALIS_LISTE
            FROM
                #dsn_dev_alias#.PRICE_TABLE_STANDART PTS
            WHERE
                PTS.STD_P_STARTDATE <= ISNULL(IC_TABLE.SHIP_DATE,I.INVOICE_DATE) AND
                PTS.PRODUCT_ID = IR.PRODUCT_ID
            ORDER BY
                PTS.STD_P_STARTDATE DESC,
                PTS.ROW_ID DESC,
                PTS.STANDART_ALIS ASC
        ),9999) AS OGUNKU_STANDART_FIYAT,
        ISNULL((
            SELECT TOP 1
                PTS.TABLE_CODE
            FROM
                #dsn_dev_alias#.PRICE_TABLE_STANDART PTS
            WHERE
                PTS.STD_P_STARTDATE <= ISNULL(IC_TABLE.SHIP_DATE,I.INVOICE_DATE) AND
                PTS.PRODUCT_ID = IR.PRODUCT_ID
            ORDER BY
                PTS.STD_P_STARTDATE DESC,
                PTS.ROW_ID DESC,
                PTS.STANDART_ALIS ASC
        ),'AKTARIM') AS OGUNKU_STANDART_FIYAT_TABLO,
        (
            SELECT TOP 1
                PTS.ROW_ID
            FROM
                #dsn_dev_alias#.PRICE_TABLE_STANDART PTS
            WHERE
                PTS.STD_P_STARTDATE <= ISNULL(IC_TABLE.SHIP_DATE,I.INVOICE_DATE) AND
                PTS.PRODUCT_ID = IR.PRODUCT_ID
            ORDER BY
                PTS.STD_P_STARTDATE DESC,
                PTS.ROW_ID DESC,
                PTS.STANDART_ALIS ASC
        ) AS OGUNKU_STANDART_FIYAT_TABLO_ROW_ID,
        ROUND(PS.PRICE,4) AS AKTIF_STANDART_FIYAT,
        ISNULL(( 
            SELECT TOP 1 
                PT1.NEW_ALIS
            FROM
                #dsn_dev_alias#.PRICE_TABLE PT1
            WHERE
                PT1.PRICE_TYPE IN (#fazla_stok#,#kasa_cikis_olmayanlar#) AND
                PT1.IS_ACTIVE_P = 1 AND
                PT1.P_STARTDATE <= ISNULL(IC_TABLE.SHIP_DATE,I.INVOICE_DATE) AND 
                PT1.P_FINISHDATE >= ISNULL(IC_TABLE.SHIP_DATE,I.INVOICE_DATE) AND
                (PT1.STOCK_ID = IR.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = IR.PRODUCT_ID))
            ORDER BY
                PT1.P_STARTDATE DESC,
                PT1.ROW_ID DESC,
                PT1.NEW_ALIS ASC
        ),9999) AS LISTE_FIYATI,
        ISNULL(( 
            SELECT TOP 1 
                PT1.TABLE_CODE
            FROM
                #dsn_dev_alias#.PRICE_TABLE PT1
            WHERE
                PT1.PRICE_TYPE IN (#fazla_stok#,#kasa_cikis_olmayanlar#) AND
                PT1.IS_ACTIVE_P = 1 AND
                PT1.P_STARTDATE <= ISNULL(IC_TABLE.SHIP_DATE,I.INVOICE_DATE) AND 
                PT1.P_FINISHDATE >= ISNULL(IC_TABLE.SHIP_DATE,I.INVOICE_DATE) AND
                (PT1.STOCK_ID = IR.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = IR.PRODUCT_ID))
            ORDER BY
                PT1.P_STARTDATE DESC,
                PT1.ROW_ID DESC,
                PT1.NEW_ALIS ASC
        ),'AKTARIM') AS LISTE_FIYATI_TABLE_CODE,
        ISNULL(( 
            SELECT TOP 1 
                PT1.PRICE_TYPE
            FROM
                #dsn_dev_alias#.PRICE_TABLE PT1
            WHERE
                PT1.PRICE_TYPE IN (#fazla_stok#,#kasa_cikis_olmayanlar#) AND
                PT1.IS_ACTIVE_P = 1 AND
                PT1.P_STARTDATE <= ISNULL(IC_TABLE.SHIP_DATE,I.INVOICE_DATE) AND 
                PT1.P_FINISHDATE >= ISNULL(IC_TABLE.SHIP_DATE,I.INVOICE_DATE) AND
                (PT1.STOCK_ID = IR.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = IR.PRODUCT_ID))
            ORDER BY
                PT1.P_STARTDATE DESC,
                PT1.ROW_ID DESC,
                PT1.NEW_ALIS ASC
        ),-2) AS LISTE_FIYATI_PRICE_TYPE,
        ( 
            SELECT TOP 1 
                PT1.ROW_ID
            FROM
                #dsn_dev_alias#.PRICE_TABLE PT1
            WHERE
                PT1.PRICE_TYPE IN (#fazla_stok#,#kasa_cikis_olmayanlar#) AND
                PT1.IS_ACTIVE_P = 1 AND
                PT1.P_STARTDATE <= ISNULL(IC_TABLE.SHIP_DATE,I.INVOICE_DATE) AND 
                PT1.P_FINISHDATE >= ISNULL(IC_TABLE.SHIP_DATE,I.INVOICE_DATE) AND
                (PT1.STOCK_ID = IR.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = IR.PRODUCT_ID))
            ORDER BY
                PT1.P_STARTDATE DESC,
                PT1.ROW_ID DESC,
                PT1.NEW_ALIS ASC
        ) AS LISTE_FIYATI_TABLE_ROW_ID
    FROM
        (
        SELECT
            CAST(C.COMPANY_ID AS NVARCHAR) + '_' + CAST(0 AS NVARCHAR) AS COMP_CODE,
            0 AS PROJECT_ID,
            C.COMPANY_ID,
            C.NICKNAME AS TEDARIKCI_ADI,
            '' AS PROJE_ADI,
            C.MEMBER_CODE,
            C.CITY,
            CC.COMPANYCAT
        FROM
            #dsn_alias#.COMPANY C,
            #dsn_alias#.COMPANY_CAT CC
        WHERE
            C.COMPANYCAT_ID = CC.COMPANYCAT_ID AND
            C.COMPANY_ID NOT IN (SELECT PP.COMPANY_ID FROM #dsn_alias#.PRO_PROJECTS PP WHERE PP.COMPANY_ID IS NOT NULL)
        UNION ALL
        SELECT
            CAST(C.COMPANY_ID AS NVARCHAR) + '_' + CAST(PP.PROJECT_ID AS NVARCHAR) AS COMP_CODE,
            PP.PROJECT_ID,
            C.COMPANY_ID,
            C.NICKNAME TEDARIKCI_ADI,
            PP.PROJECT_HEAD AS PROJE_ADI,
            C.MEMBER_CODE,
            C.CITY,
            CC.COMPANYCAT
        FROM
            #dsn_alias#.COMPANY C,
            #dsn_alias#.COMPANY_CAT CC,
            #dsn_alias#.PRO_PROJECTS PP
        WHERE
            C.COMPANYCAT_ID = CC.COMPANYCAT_ID AND
            C.COMPANY_ID = PP.COMPANY_ID
        ) 
        T1,
        #dsn1_alias#.PRICE_STANDART PS,
        #dsn1_alias#.PRODUCT P,
        INVOICE I,
        INVOICE_ROW IR
        	LEFT JOIN
            	(
                	 SELECT
                    	ISNULL((
                        	SELECT TOP 1
                            	CASE 
                                	WHEN (ORR.NETTOTAL > 0 AND ORR.PRICE <= T5.LISTE_FIYATI_SHIP AND ORR.PRICE <= T5.OGUNKU_STANDART_FIYAT_SHIP) THEN O.ORDER_DATE
                                    ELSE T5.SHIP_DATE END AS TARIH                                   	
                            FROM
                            	#dsn3_alias#.ORDERS O,
                                #dsn3_alias#.ORDER_ROW ORR,
                                #dsn3_alias#.ORDERS_SHIP OS
                            WHERE
                                O.ORDER_ID = ORR.ORDER_ID AND
                                OS.ORDER_ID = O.ORDER_ID AND
                                OS.SHIP_ID = T5.SHIP_ID AND
                                OS.PERIOD_ID = #session.ep.period_id# AND
                                ORR.STOCK_ID = T5.STOCK_ID
                        ),T5.SHIP_DATE) AS SHIP_DATE,
                    	T5.WRK_ROW_ID,
                        T5.INVOICE_ID
                    FROM
                    	(
                            SELECT                        
                                ISNULL(( 
                                    SELECT TOP 1 
                                        PT1.NEW_ALIS
                                    FROM
                                        #dsn_dev_alias#.PRICE_TABLE PT1
                                    WHERE
                                        PT1.PRICE_TYPE IN (#fazla_stok#,#kasa_cikis_olmayanlar#) AND
                                        PT1.IS_ACTIVE_P = 1 AND
                                        PT1.P_STARTDATE <= S.SHIP_DATE AND 
                                        DATEADD("d",-1,PT1.P_FINISHDATE) >= S.SHIP_DATE AND
                                        (PT1.STOCK_ID = SR.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = SR.PRODUCT_ID))
                                    ORDER BY
                                        PT1.P_STARTDATE DESC,
                                        PT1.ROW_ID DESC,
                                        PT1.NEW_ALIS ASC
                                ),9999) AS LISTE_FIYATI_SHIP,
                                ISNULL((
                                    SELECT TOP 1
                                        PTS.STANDART_ALIS_LISTE
                                    FROM
                                        #dsn_dev_alias#.PRICE_TABLE_STANDART PTS
                                    WHERE
                                        PTS.STD_P_STARTDATE <= S.SHIP_DATE AND
                                        PTS.PRODUCT_ID = SR.PRODUCT_ID
                                    ORDER BY
                                        PTS.STD_P_STARTDATE DESC,
                                        PTS.STANDART_ALIS ASC
                                ),9999) AS OGUNKU_STANDART_FIYAT_SHIP,
                                SR.WRK_ROW_ID,
                                S.SHIP_DATE,
                                S.SHIP_ID,
                                SR.STOCK_ID,
                                ISS.INVOICE_ID
                            FROM
                                INVOICE_SHIPS ISS,
                                SHIP S,
                                SHIP_ROW SR
                            WHERE
                                ISS.SHIP_ID = S.SHIP_ID AND
                                S.SHIP_ID = SR.SHIP_ID
                       ) T5
                ) IC_TABLE ON (IR.WRK_ROW_RELATION_ID = IC_TABLE.WRK_ROW_ID AND IC_TABLE.INVOICE_ID = IR.INVOICE_ID)        
    WHERE
		<cfif isdefined("attributes.company_ids") and len(attributes.company_ids)>
            I.COMPANY_ID IN (#attributes.company_ids#) AND
        </cfif>
        --I.INVOICE_NUMBER = 'SMR-2017000002554' AND 
        IR.PRODUCT_ID = P.PRODUCT_ID AND
        I.INVOICE_DATE >= #attributes.startdate# AND
        I.INVOICE_DATE >= #createodbcdatetime(createdate(2016,12,1))# AND
        I.INVOICE_DATE <= #attributes.finishdate# AND	     
		PS.PRODUCT_ID = IR.PRODUCT_ID AND
        PS.PURCHASESALES = 0 AND
        PS.PRICESTANDART_STATUS = 1 AND
        T1.COMP_CODE = CAST(I.COMPANY_ID AS NVARCHAR) + '_' + CAST(ISNULL(I.PROJECT_ID,0) AS NVARCHAR) AND
        I.INVOICE_ID = IR.INVOICE_ID AND
        ISNULL(I.IS_IPTAL,0) = 0 AND
        I.PROCESS_CAT NOT IN (#dahil_olmayan_tipler#) AND
        I.PURCHASE_SALES = 0
) T2
ORDER BY
    T2.TEDARIKCI_ADI ASC,
    T2.PROJE_ADI ASC
</cfquery>



<cfoutput query="get_comps_invoice_all">
	<cfset price_type_ = -2>
	<cfset ilk_deger_ = 0>
    <cfset table_code_ = ''>
    <cfset table_row_id_ = ''>
	<cfif OGUNKU_STANDART_FIYAT lt 9999 and OGUNKU_STANDART_FIYAT lt FATURA_FIYATI>
    	<cfset ilk_deger_ = OGUNKU_STANDART_FIYAT>
        <cfset price_type_ = -1>
        <cfset table_code_ = OGUNKU_STANDART_FIYAT_TABLO>
        <cfset table_row_id_ = OGUNKU_STANDART_FIYAT_TABLO_ROW_ID>
    </cfif>
	<cfif LISTE_FIYATI lt 9999 and LISTE_FIYATI lt OGUNKU_STANDART_FIYAT and LISTE_FIYATI lt FATURA_FIYATI>
    	<cfset ilk_deger_ = LISTE_FIYATI>
        <cfset price_type_ = LISTE_FIYATI_PRICE_TYPE>
        <cfset table_code_ = LISTE_FIYATI_TABLE_CODE>
        <cfset table_row_id_ = LISTE_FIYATI_TABLE_ROW_ID>
    </cfif>
    <cfif OGUNKU_STANDART_FIYAT eq 9999 and LISTE_FIYATI eq 9999>
    	<cfset ilk_deger_ = AKTIF_STANDART_FIYAT>
        <cfset price_type_ = -2>
        <cfset table_code_ = ''>
        <cfset table_row_id_ = ''>
    </cfif>
	<cfif ilk_deger_ gt 0 and ilk_deger_ lt FATURA_FIYATI>
		<cfset deger_ = wrk_round(NETTOTAL - (ilk_deger_ * AMOUNT))>
            
        <cfquery name="cont_" datasource="#dsn2#">
            SELECT 
                FF_ROW_ID 
            FROM 
                #dsn_dev_alias#.INVOICE_FF_ROWS 
            WHERE 
                INVOICE_ID = #INVOICE_ID# AND
                WRK_ROW_ID = '#WRK_ROW_ID#' AND 
                STOCK_ID = #STOCK_ID# AND 
                FF_TYPE = <cfif len(price_type_) and listfind(kasa_cikis_olmayanlar,price_type_)>2<cfelse>0</cfif> 
                --AND PRICE_TYPE = #price_type_#
        </cfquery>
        <cfif not cont_.recordcount>
            <cfquery name="add_" datasource="#dsn2#">
                    INSERT INTO
                        #dsn_dev_alias#.INVOICE_FF_ROWS      
                        (
                        INVOICE_ID,
                        INVOICE_NUMBER,
                        INVOICE_ROW_ID,
                        PRODUCT_ID,
                        STOCK_ID,
                        INVOICE_DATE,
                        AMOUNT,
                        FF_GROSS,
                        FF_BASE,
                        PERIOD_ID,
                        WRK_ROW_ID,
                        COMPANY_ID,
                        PROJECT_ID,
                        COMP_CODE,
                        FF_NET,
                        FF_PAID,
                        FF_TYPE,
                        PRICE_TYPE,
                        TABLE_CODE,
                        TABLE_ROW_ID,
                        TAX,
                        FF_DAILY_COST,
                        CODE
                        )
                        VALUES
                        (
                        #INVOICE_ID#,
                        '#INVOICE_NUMBER#',
                        #INVOICE_ROW_ID#,
                        #PRODUCT_ID#,
                        #STOCK_ID#,
                        #CREATEODBCDATETIME(INVOICE_DATE)#,
                        #AMOUNT#,
                        #FATURA_FIYATI#,
                        #ilk_deger_#,
                        #session.ep.period_id#,
                        '#WRK_ROW_ID#',
                        #COMPANY_ID#,
                        <cfif COMPANY_ID eq product_company_id and len(project_id) and product_project_id neq 0 and project_id neq product_project_id>
							<cfset COMP_CODE_ = '#COMPANY_ID#_#PRODUCT_PROJECT_ID#'>
                            #PRODUCT_PROJECT_ID#
                        <cfelse>
                            <cfif len(PROJECT_ID)>
                            <cfset COMP_CODE_ = '#COMPANY_ID#_#PROJECT_ID#'>
                                #PROJECT_ID#
                            <cfelse>
                            <cfset COMP_CODE_ = '#COMPANY_ID#_0'>
                                NULL
                            </cfif>
                        </cfif>    
                        ,
                        '#COMP_CODE_#',
                        #deger_#,
                        0,
                        <cfif len(price_type_) and listfind(kasa_cikis_olmayanlar,price_type_)>2<cfelse>0</cfif>,
                        #price_type_#,
                        '#table_code_#',
                        <cfif len(table_row_id_)>#table_row_id_#<cfelse>NULL</cfif>,
                        #TAX#,
                        #get_daily_maliyet(PRODUCT_ID,STOCK_ID,year(INVOICE_DATE),month(INVOICE_DATE),day(INVOICE_DATE))#,
                        '#dateformat(now(),"dd/mm/yyyy")# MANUEL FF (0)'
                        )
                </cfquery>
                <!--- #get_daily_maliyet(PRODUCT_ID,STOCK_ID,year(INVOICE_DATE),month(INVOICE_DATE),day(INVOICE_DATE))# --->
        </cfif>
    </cfif>
</cfoutput>
<!--- FİYAT FARKLARI --->

<cf_medium_list_search title="Fiyat Farkları Aktarma"></cf_medium_list_search>
<br />
Fiyat Farkları Düzenlendi.