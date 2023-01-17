<cfparam name="attributes.search_department_id" default="">
<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
    SELECT 
        PRODUCT_CAT.PRODUCT_CATID, 
        PRODUCT_CAT.HIERARCHY, 
        PRODUCT_CAT.HIERARCHY + ' - ' + PRODUCT_CAT.PRODUCT_CAT AS PRODUCT_CAT_NEW
    FROM 
        PRODUCT_CAT,
        PRODUCT_CAT_OUR_COMPANY PCO
    WHERE 
        PRODUCT_CAT.PRODUCT_CATID = PCO.PRODUCT_CATID AND
        PCO.OUR_COMPANY_ID = #session.ep.company_id# 
    ORDER BY 
        HIERARCHY ASC
</cfquery>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">

<cf_box title="#getLang('','Kategori Stok Raporu',62805)#">
<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
    
    <cfquery name="get_stocks_status_all" datasource="#dsn3#">
    	SELECT DISTINCT
        	ISNULL((SELECT SUM(PRODUCT_STOCK) FROM #DSN2_ALIAS#.GET_STOCK_LAST_LOCATION WHERE S.STOCK_ID = GET_STOCK_LAST_LOCATION.STOCK_ID <cfif len(attributes.search_department_id)>AND GET_STOCK_LAST_LOCATION.DEPARTMENT_ID IN (#attributes.search_department_id#)</cfif>),0) AS URUN_STOCK,
            PC.PRODUCT_CAT,
            PC.PRODUCT_CATID,
            P.PRODUCT_ID,
            P.PRODUCT_NAME,
            P.P_PROFIT AS A_KAR,
            P.S_PROFIT AS S_KAR,
            ISNULL(( 
                SELECT TOP 1 
                    PT1.P_MARGIN
                FROM
                    #DSN_DEV#.PRICE_TABLE PT1
                WHERE
                    PT1.IS_ACTIVE_S = 1 AND
                    (
                    	PT1.STARTDATE <= #bugun_# AND 
                        DATEADD("d",-1,PT1.FINISHDATE) >= #bugun_#
                    ) AND
                    (
                    	PT1.STOCK_ID = S.STOCK_ID OR 
                        (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID)
                    )
                ORDER BY
                	PT1.STARTDATE DESC,
					PT1.ROW_ID DESC
            ),P.P_PROFIT) AS FA_KAR,
            ISNULL(( 
                SELECT TOP 1 
                    PT1.MARGIN
                FROM
                    #DSN_DEV#.PRICE_TABLE PT1
                WHERE
                    PT1.IS_ACTIVE_S = 1 AND
                    (
                    	PT1.STARTDATE <= #bugun_# AND 
                        DATEADD("d",-1,PT1.FINISHDATE) >= #bugun_#
                    ) AND
                    (
                    	PT1.STOCK_ID = S.STOCK_ID OR 
                        (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID)
                    )
                ORDER BY
                	PT1.STARTDATE DESC,
					PT1.ROW_ID DESC
            ),P.S_PROFIT) AS FS_KAR,
            ISNULL(( 
                SELECT TOP 1 
                    PT1.NEW_PRICE_KDV
                FROM
                    #DSN_DEV#.PRICE_TABLE PT1
                WHERE
                    PT1.IS_ACTIVE_S = 1 AND
                    (
                    	PT1.STARTDATE <= #bugun_# AND 
                        DATEADD("d",-1,PT1.FINISHDATE) >= #bugun_#
                    ) AND
                    (
                    	PT1.STOCK_ID = S.STOCK_ID OR 
                        (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID)
                    )
                ORDER BY
                	PT1.STARTDATE DESC,
					PT1.ROW_ID DESC
            ),PS_SATIS.PRICE_KDV) AS PRICE_SATIS_KDV,
            ISNULL(( 
                SELECT TOP 1 
                    PT1.NEW_ALIS_KDV
                FROM
                    #DSN_DEV#.PRICE_TABLE PT1
                WHERE
                    PT1.IS_ACTIVE_P = 1 AND
                    (PT1.P_STARTDATE <= #bugun_# AND DATEADD("d",-1,PT1.P_FINISHDATE) >= #bugun_#) AND
                    (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID))
                ORDER BY
                	PT1.STARTDATE DESC,
					PT1.ROW_ID DESC
            ),PS_ALIS.PRICE_KDV) AS PRICE_ALIS_KDV
        FROM
            STOCKS S,
            #dsn1_alias#.PRODUCT P,
            #dsn1_alias#.PRODUCT_CAT PC,
			PRICE_STANDART PS_ALIS,
			PRICE_STANDART PS_SATIS,
            PRODUCT_UNIT PU
       	WHERE
            PU.PRODUCT_ID = P.PRODUCT_ID AND
            PS_ALIS.PRODUCT_ID = P.PRODUCT_ID AND
            PS_SATIS.PRODUCT_ID = P.PRODUCT_ID AND
            PU.IS_MAIN = 1 AND
            PU.PRODUCT_UNIT_ID = PS_ALIS.UNIT_ID AND
            PU.PRODUCT_UNIT_ID = PS_SATIS.UNIT_ID AND
            P.IS_SALES = 1 AND
            P.PRODUCT_STATUS = 1 AND
            S.STOCK_STATUS = 1 AND		
            PS_ALIS.PURCHASESALES = 0 AND
            PS_ALIS.PRICESTANDART_STATUS = 1 AND
            PS_SATIS.PURCHASESALES = 1 AND
            PS_SATIS.PRICESTANDART_STATUS = 1 AND
            S.PRODUCT_ID = P.PRODUCT_ID AND
            P.PRODUCT_CATID = PC.PRODUCT_CATID 
            <cfif not ((isdefined("attributes.p_cat_list") and listlen(attributes.p_cat_list)) or (isdefined("attributes.hierarchy") and listlen(attributes.hierarchy)))>
				AND P.PRODUCT_ID = -1
            </cfif>
			<cfif isdefined("attributes.p_cat_list") and listlen(attributes.p_cat_list)>
            	AND PC.PRODUCT_CATID IN (#attributes.p_cat_list#)
            </cfif>
            <cfif isdefined("attributes.hierarchy") and listlen(attributes.hierarchy)>
            	AND PC.HIERARCHY LIKE '#attributes.hierarchy#.%'
            </cfif>
    </cfquery>
    
    <cfquery name="get_stocks_status" dbtype="query">
    	SELECT
        	SUM(URUN_STOCK) AS URUN_STOCK,
            PRODUCT_CAT,
            PRODUCT_CATID,
            PRICE_ALIS_KDV,
            PRICE_SATIS_KDV,
            PRODUCT_ID,
            PRODUCT_NAME,
            A_KAR,
            S_KAR
        FROM
        	get_stocks_status_all
        GROUP BY
        	PRODUCT_CAT,
            PRODUCT_CATID,
            PRICE_ALIS_KDV,
            PRICE_SATIS_KDV,
            PRODUCT_ID,
            PRODUCT_NAME,
            A_KAR,
            S_KAR,
            FA_KAR,
            FS_KAR  	
    </cfquery>
    
    <cfquery name="get_cat_status" dbtype="query">
    	SELECT
        	PRODUCT_NAME,
            PRODUCT_ID,
            A_KAR,
            S_KAR,
            SUM(URUN_STOCK) AS TOPLAM_STOCK,
            SUM(PRICE_ALIS_KDV) / 1 AS ALIS_ORTALAMA,
            SUM(PRICE_SATIS_KDV) / 1 AS SATIS_ORTALAMA,
            COUNT(PRODUCT_ID) AS URUN_SAYISI,
            SUM(URUN_STOCK) * SUM(PRICE_ALIS_KDV) / 1 AS TOTAL_RAKAM
        FROM
        	get_stocks_status
        WHERE
        	URUN_STOCK > 0
        GROUP BY
        	PRODUCT_NAME,
            PRODUCT_ID ,
            A_KAR,
            S_KAR,
            FA_KAR,
            FS_KAR
        ORDER BY
        	TOTAL_RAKAM DESC      	
    </cfquery>
    <cfset toplam = 0>
    
        <cf_grid_list id='tabletest'>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='57657.Ürün'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='57452.Stok'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='57657.Ürün'> <cf_get_lang dictionary_id='61560.Alış Karı'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='57657.Ürün'> <cf_get_lang dictionary_id='40627.Satış Karı'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='58084.Fiyat'> <cf_get_lang dictionary_id='61560.Alış Karı'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='58084.Fiyat'> <cf_get_lang dictionary_id='40627.Satış Karı'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='58176.Alış'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='57448.Satış'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></th>
                </tr>
            </thead>
            <tbody>
                <cfoutput query="get_cat_status">
                    <tr>
                        <td>#currentrow#</td>
                        <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=retail.popup_product_stocks&product_id=#PRODUCT_ID#','list');" class="tableyazi">#PRODUCT_NAME#</a></td>
                        <td style="text-align:right;">#tlformat(TOPLAM_STOCK)#</td>
                        <td style="text-align:right;">#tlformat(A_KAR)#</td>
                        <td style="text-align:right;">#tlformat(S_KAR)#</td>
                        <td style="text-align:right;">#tlformat(FA_KAR)#</td>
                        <td style="text-align:right;">#tlformat(FS_KAR)#</td>
                        <td style="text-align:right;">#tlformat(ALIS_ORTALAMA)#</td>
                        <td style="text-align:right;">#tlformat(SATIS_ORTALAMA)#</td>
                        <td style="text-align:right;">#tlformat(TOPLAM_STOCK * ALIS_ORTALAMA)#</td>
                    </tr>
                    <cfset toplam = toplam + (TOPLAM_STOCK * ALIS_ORTALAMA)>
                </cfoutput>
            </tbody>
            <tfoot>
                <cfoutput>
                    <tr>
                        <td colspan="9" style="text-align:right;" class="formbold"><cf_get_lang dictionary_id='40302.Toplamlar'></td>
                        <td style="text-align:right;" class="formbold">#tlformat(toplam)#</td>
                    </tr>
                </cfoutput>
            </tfoot>
        </cf_grid_list>
    </cf_box>
    </div>
    
