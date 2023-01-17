<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
<cfif isdefined("attributes.search_startdate") and isdate(attributes.search_startdate)>
	<cf_date tarih = "attributes.search_startdate">
<cfelse>
	<cfset attributes.search_startdate = dateadd("d",-90,bugun_)>
</cfif>
<cfif isdefined("attributes.search_finishdate") and isdate(attributes.search_finishdate)>
	<cf_date tarih = "attributes.search_finishdate">
<cfelse>
	<cfset attributes.search_finishdate = dateadd("d",-1,bugun_)>
</cfif>

<cfif isdefined("attributes.table_code")>
    <cfquery name="get_table" datasource="#dsn_dev#" result="get_table_result">
        SELECT
            TABLE_SECRET_CODE,
            TABLE_INFO,
            TABLE_ID
        FROM
            SEARCH_TABLES
        WHERE
            TABLE_CODE = '#attributes.table_code#'
    </cfquery>
    <cfquery name="get_products" datasource="#dsn3#" result="query_result">
        SELECT
            P.*,
            PC.HIERARCHY,
            PC.PRODUCT_CAT,
            ISNULL(P.MAX_MARGIN,10) AS MAX_MARGIN_DEGER,
            S.PROPERTY,
            S.STOCK_ID,
            S.BARCOD AS S_BARCOD,
            S.STOCK_CODE,
            ISNULL(#dsn_dev_alias#.fnc_get_ortalama_satis_stok(S.STOCK_ID,#merkez_depo_id#,#attributes.search_startdate#,#attributes.search_finishdate#),0) AS ROW_ORT_STOK_SATIS_MIKTARI,
            PRICE_STANDART.PRICE PRICE_STANDART,
            PRICE_STANDART.PRICE_KDV PRICE_STANDART_KDV,
            ISNULL(( 
                    SELECT TOP 1 
                        PT1.NEW_PRICE_KDV
                    FROM
                        #DSN_DEV#.PRICE_TABLE PT1
                    WHERE
                        (
                        PT1.IS_ACTIVE_S = 1 AND
                        PT1.STARTDATE <= #bugun_# AND DATEADD("d",-1,PT1.FINISHDATE) >= #bugun_#) AND
                        (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID))
                    ORDER BY
                        PT1.STARTDATE DESC,
                        PT1.ROW_ID DESC
                    ),PS2.PRICE_KDV) AS LISTE_FIYATI,
             ISNULL(( 
                    SELECT TOP 1 
                        PT1.NEW_ALIS_KDV
                    FROM
                        #DSN_DEV#.PRICE_TABLE PT1
                    WHERE
                        (
                        PT1.IS_ACTIVE_P = 1 AND
                        PT1.P_STARTDATE <= #bugun_# AND DATEADD("d",-1,PT1.P_FINISHDATE) >= #bugun_#) AND
                        (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID))
                    ORDER BY
                        PT1.NEW_ALIS_KDV DESC,
                        PT1.P_STARTDATE DESC,
                        PT1.ROW_ID DESC
                    ),PRICE_STANDART.PRICE_KDV) AS LISTE_FIYATI_ALIS,
            ISNULL((SELECT SUM(PRODUCT_STOCK) FROM #DSN#_#year(now())#_#session.ep.company_id#.GET_STOCK_PRODUCT WHERE S.STOCK_ID = GET_STOCK_PRODUCT.STOCK_ID),0) AS ROW_STOCK,
            ISNULL((
                SELECT	
                    SUM(ORR.QUANTITY)
                FROM
                    ORDERS O INNER JOIN
                    ORDER_ROW ORR ON ORR.ORDER_ID = O.ORDER_ID
                WHERE
                    O.ORDER_STAGE = 76 AND
                    O.PURCHASE_SALES = 0 AND
                    ORR.ORDER_ROW_CURRENCY NOT IN (-3,-10) AND
                    ORR.STOCK_ID = S.STOCK_ID AND 
                    O.ORDER_DATE >= #dateadd('d',order_control_day,now())# AND 
                    O.ORDER_DATE <= #bugun_#
            ),0) PURCHASE_ORDER_QUANTITY        
        FROM 
            #DSN_DEV_ALIAS#.SEARCH_TABLES_PRODUCTS ST,
            STOCKS S,
            PRODUCT_CAT PC,
            #dsn1_alias#.PRODUCT P
                LEFT JOIN PRODUCT_UNIT ON P.PRODUCT_ID = PRODUCT_UNIT.PRODUCT_ID
                LEFT JOIN PRICE_STANDART ON PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID
                LEFT JOIN PRICE_STANDART AS PS2 ON PRODUCT_UNIT.PRODUCT_ID = PS2.PRODUCT_ID
        WHERE
            P.PRODUCT_CATID = PC.PRODUCT_CATID AND
            S.STOCK_STATUS = 1 AND
            P.PRODUCT_STATUS = 1 AND
            P.PRODUCT_ID = S.PRODUCT_ID AND
            PS2.PRICESTANDART_STATUS = 1 AND
            PS2.PURCHASESALES = 1 AND
            PRODUCT_UNIT.PRODUCT_UNIT_ID = PS2.UNIT_ID AND
            PRICE_STANDART.PURCHASESALES = 0 AND
            PRODUCT_UNIT.IS_MAIN = 1 AND 
            PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
            PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID AND
            P.PRODUCT_ID = ST.PRODUCT_ID AND
            ST.TABLE_ID = #get_table.TABLE_ID#
        ORDER BY
            P.PRODUCT_CODE ASC,
            P.PRODUCT_NAME,
            S.PROPERTY
    </cfquery>
<cfelseif isdefined("attributes.hierarchy")>
	<cfquery name="get_products" datasource="#dsn3#" result="query_result">
        SELECT
            P.*,
            PC.HIERARCHY,
            PC.PRODUCT_CAT,
            ISNULL(P.MAX_MARGIN,10) AS MAX_MARGIN_DEGER,
            S.PROPERTY,
            S.STOCK_ID,
            S.BARCOD AS S_BARCOD,
            S.STOCK_CODE,
            ISNULL(#dsn_dev_alias#.fnc_get_ortalama_satis_stok(S.STOCK_ID,#merkez_depo_id#,#attributes.search_startdate#,#attributes.search_finishdate#),0) AS ROW_ORT_STOK_SATIS_MIKTARI,
            PRICE_STANDART.PRICE PRICE_STANDART,
            PRICE_STANDART.PRICE_KDV PRICE_STANDART_KDV,
            ISNULL(( 
                    SELECT TOP 1 
                        PT1.NEW_PRICE_KDV
                    FROM
                        #DSN_DEV#.PRICE_TABLE PT1
                    WHERE
                        (
                        PT1.IS_ACTIVE_S = 1 AND
                        PT1.STARTDATE <= #bugun_# AND DATEADD("d",-1,PT1.FINISHDATE) >= #bugun_#) AND
                        (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID))
                    ORDER BY
                        PT1.STARTDATE DESC,
                        PT1.ROW_ID DESC
                    ),PS2.PRICE_KDV) AS LISTE_FIYATI,
             ISNULL(( 
                    SELECT TOP 1 
                        PT1.NEW_ALIS_KDV
                    FROM
                        #DSN_DEV#.PRICE_TABLE PT1
                    WHERE
                        (
                        PT1.IS_ACTIVE_P = 1 AND
                        PT1.P_STARTDATE <= #bugun_# AND DATEADD("d",-1,PT1.P_FINISHDATE) >= #bugun_#) AND
                        (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID))
                    ORDER BY
                        PT1.NEW_ALIS_KDV DESC,
                        PT1.P_STARTDATE DESC,
                        PT1.ROW_ID DESC
                    ),PRICE_STANDART.PRICE_KDV) AS LISTE_FIYATI_ALIS,
            ISNULL((SELECT SUM(PRODUCT_STOCK) FROM #DSN#_#year(now())#_#session.ep.company_id#.GET_STOCK_PRODUCT WHERE S.STOCK_ID = GET_STOCK_PRODUCT.STOCK_ID),0) AS ROW_STOCK,
            ISNULL((
                SELECT	
                    SUM(ORR.QUANTITY)
                FROM
                    ORDERS O INNER JOIN
                    ORDER_ROW ORR ON ORR.ORDER_ID = O.ORDER_ID
                WHERE
                    O.ORDER_STAGE = 76 AND
                    O.PURCHASE_SALES = 0 AND
                    ORR.ORDER_ROW_CURRENCY NOT IN (-3,-10) AND
                    ORR.STOCK_ID = S.STOCK_ID AND 
                    O.ORDER_DATE >= #dateadd('d',order_control_day,now())# AND 
                    O.ORDER_DATE <= #bugun_#
            ),0) PURCHASE_ORDER_QUANTITY        
        FROM 
            STOCKS S,
            PRODUCT_CAT PC,
            #dsn1_alias#.PRODUCT P
                LEFT JOIN PRODUCT_UNIT ON P.PRODUCT_ID = PRODUCT_UNIT.PRODUCT_ID
                LEFT JOIN PRICE_STANDART ON PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID
                LEFT JOIN PRICE_STANDART AS PS2 ON PRODUCT_UNIT.PRODUCT_ID = PS2.PRODUCT_ID
        WHERE
            P.PRODUCT_CATID = PC.PRODUCT_CATID AND
            PC.HIERARCHY = '#attributes.hierarchy#' AND
            S.STOCK_STATUS = 1 AND
            P.PRODUCT_STATUS = 1 AND
            P.PRODUCT_ID = S.PRODUCT_ID AND
            PS2.PRICESTANDART_STATUS = 1 AND
            PS2.PURCHASESALES = 1 AND
            PRODUCT_UNIT.PRODUCT_UNIT_ID = PS2.UNIT_ID AND
            PRICE_STANDART.PURCHASESALES = 0 AND
            PRODUCT_UNIT.IS_MAIN = 1 AND 
            PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
            PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID
        ORDER BY
            P.PRODUCT_CODE ASC,
            P.PRODUCT_NAME,
            S.PROPERTY
    </cfquery>
</cfif>
<div style="<cfif isdefined('attributes.hierarchy')>display:none;</cfif>">
<cfif isdefined("attributes.table_code")>
	<cfsavecontent variable="header_">
       <input type="button" value="Artı" onclick="get_seller_table('1');" style="width:50px;"/>
       <input type="button" value="Eksi" onclick="get_seller_table('0');" style="width:50px;"/>
       <input type="button" value="Tümü" onclick="get_seller_table('2');" style="width:50px;"/>
    </cfsavecontent>
	<cf_medium_list_search title="#trim(header_)#"></cf_medium_list_search>
</cfif>
	<cfif isdefined('attributes.table_code')>
    	<cf_medium_list id="manage_table_seller_limit_arti" style="display:none;">
            <thead>
                <tr>
                    <th>Limit Tablosu</th>
                    <th colspan="4" style="text-align:center;">Değerler</th>
                    <th colspan="6" style="text-align:center;">Stok Sipariş Tutarı</th>
                    <th colspan="8" style="text-align:center;">Hedef</th>
                </tr>
                <tr>
                    <th>Liste Adı</th>
                    <th>1 Gün.Ort.Sat.Mk</th>
                    <th>2 Gün.Ort.Sat.TL</th>
                    <th>3 Vade</th>
                    <th>4 İlave Gün</th>
                    <th>5 Stok Ad.</th>
                    <th>6 Stok Tut.</th>
                    <th>7 Sip. Ad.</th>
                    <th>8 Sip Tut.</th>
                    <th>9 Stok + Sip. Top. Ad.</th>
                    <th>10 Stok + Sip Top. Tut.</th>
                    <th>11 Vade Gün Ad.</th>
                    <th>12 Ek Vade Gün Ad.</th>
                    <th>13 Vade + Ek Vade Ad.</th>
                    <th>14 Vade Gün Tut.</th>
                    <th>15 Ek Vade Gün Tut.</th>
                    <th>16 Max. Hedef Tut.<br>VadeGün + EkVade Gün Tut.</th>
                    <th>17 Satıcı Limit Adet</th>
                    <th>18 Satıcı Limit Tutar <br> 16-10</th>
                </tr>
            </thead>
            <tbody>
                <cfset t_ROW_ORT_STOK_SATIS_MIKTARI = 0>
                <cfset t_gunluk_satis_tutar = 0>
                <cfset t_vade_total_ = 0>
                <cfset t_ek_vade_ = 0>
                <cfset t_row_stock = 0>
                <cfset t_eldeki_stock_tutar = 0>
                <cfset t_PURCHASE_ORDER_QUANTITY = 0>
                <cfset t_PURCHASE_ORDER_TUTAR = 0>
                <cfset t_total_miktar_ = 0>
                <cfset t_total_tutar_ = 0>
                <cfset t_vade_gun_miktar_ = 0>
                <cfset t_vade_gun_tutar_ = 0>
                <cfset t_ek_vade_gun_miktar_ = 0>
                <cfset t_ek_vade_gun_tutar_ = 0>
                <cfset t_total_vade_miktar_ = 0>
                <cfset t_total_vade_tutar_ = 0>
                <cfset t_satici_limit_miktar_ = 0>
                <cfset t_satici_limit_tutar_ = 0>
                <cfset p_count = 0>
                <cfset ort_p_count = 0>
                
                <cfset gt_ROW_ORT_STOK_SATIS_MIKTARI = 0>
                <cfset gt_gunluk_satis_tutar = 0>
                <cfset gt_vade_total_ = 0>
                <cfset gt_ek_vade_ = 0>
                <cfset gt_row_stock = 0>
                <cfset gt_eldeki_stock_tutar = 0>
                <cfset gt_PURCHASE_ORDER_QUANTITY = 0>
                <cfset gt_PURCHASE_ORDER_TUTAR = 0>
                <cfset gt_total_miktar_ = 0>
                <cfset gt_total_tutar_ = 0>
                <cfset gt_vade_gun_miktar_ = 0>
                <cfset gt_vade_gun_tutar_ = 0>
                <cfset gt_ek_vade_gun_miktar_ = 0>
                <cfset gt_ek_vade_gun_tutar_ = 0>
                <cfset gt_total_vade_miktar_ = 0>
                <cfset gt_total_vade_tutar_ = 0>
                <cfset gt_satici_limit_miktar_ = 0>
                <cfset gt_satici_limit_tutar_ = 0>
                <cfset gp_count = 0>
                <cfset ort_gp_count = 0>
                
                <cfoutput query="get_products">
                <cfif len(DUEDAY)>
                    <cfset vade_ = DUEDAY>
                <cfelse>
                    <cfset vade_ = 30>
                </cfif>
                <cfif len(ADD_STOCK_DAY)>
                    <cfset ek_vade_ = ADD_STOCK_DAY>
                <cfelse>
                    <cfset ek_vade_ = 1>
                </cfif>
                <cfset gunluk_satis_tutar = ROW_ORT_STOK_SATIS_MIKTARI * LISTE_FIYATI>
                <cfset vade_total_ = vade_>
                <cfset eldeki_stock_tutar = row_stock * LISTE_FIYATI_ALIS>
                <cfset total_miktar_ = row_stock + PURCHASE_ORDER_QUANTITY>

                <cfset total_tutar_ = eldeki_stock_tutar + (PURCHASE_ORDER_QUANTITY * LISTE_FIYATI_ALIS)>
                <cfset vade_gun_miktar_ = ROW_ORT_STOK_SATIS_MIKTARI * vade_total_>
                <cfset ek_vade_gun_miktar_ = ROW_ORT_STOK_SATIS_MIKTARI * ek_vade_>
                <cfset total_vade_miktar_ = vade_gun_miktar_ + ek_vade_gun_miktar_>
                <cfset vade_gun_tutar_ = gunluk_satis_tutar * vade_total_>
                <cfset ek_vade_gun_tutar_ = gunluk_satis_tutar * ek_vade_>
                <cfset total_vade_tutar_ = vade_gun_tutar_ + ek_vade_gun_tutar_>
                <cfset satici_limit_miktar_ = total_vade_miktar_ - total_miktar_>
                <cfset satici_limit_tutar_ = total_vade_tutar_ - total_tutar_>
            <cfif satici_limit_tutar_ gte 0>
                <tr row_code="product_cat_#product_catid#" style="">
                    <td style="background-color:##CCFFCC;" title="#product_id# / #tlformat(LISTE_FIYATI)#">#property#</td>
                    <td style="background-color:##CCFFCC;text-align:right;">#tlformat(ROW_ORT_STOK_SATIS_MIKTARI)#</td>
                    <td style="background-color:##CCFFCC;text-align:right;">#tlformat(gunluk_satis_tutar)#</td>
                    <td style="background-color:##CCFFCC;text-align:right;">#vade_total_#</td>
                    <td style="background-color:##CCFFCC;text-align:right;">#ek_vade_#</td>
                    <td style="background-color:##FFDEAD;text-align:right;">#tlformat(row_stock)#</td>
                    <td style="background-color:##dcdcdc;text-align:right;">#tlformat(eldeki_stock_tutar)#</td>
                    <td style="background-color:##FFDEAD;text-align:right;">#tlformat(PURCHASE_ORDER_QUANTITY)#</td>
                    <td style="background-color:##dcdcdc;text-align:right;">#tlformat(PURCHASE_ORDER_QUANTITY * LISTE_FIYATI_ALIS)#</td>
                    <td style="background-color:##FFDEAD;text-align:right;">#tlformat(total_miktar_)#</td>
                    <td style="background-color:##dcdcdc;text-align:right;">#tlformat(total_tutar_)#</td>
                    <td style="background-color:##FFFACD;text-align:right;">#tlformat(vade_gun_miktar_)#</td>
                    <td style="background-color:##FFFACD;text-align:right;">#tlformat(ek_vade_gun_miktar_)#</td>
                    <td style="background-color:##FFFACD;text-align:right;">#tlformat(total_vade_miktar_)#</td>
                    <td style="background-color:##dcdcdc;text-align:right;">#tlformat(vade_gun_tutar_)#</td>
                    <td style="background-color:##dcdcdc;text-align:right;">#tlformat(ek_vade_gun_tutar_)#</td>
                    <td style="background-color:##FFFACD;text-align:right;">#tlformat(total_vade_tutar_)#</td>
                    <td style="background-color:##FFFACD;text-align:right;">#tlformat(satici_limit_miktar_)#</td>
                    <td style="background-color:##FFFACD;text-align:right;">#tlformat(satici_limit_tutar_)#</td>
                </tr>
                <cfif ROW_ORT_STOK_SATIS_MIKTARI gt 0 or row_stock gt 0 or PURCHASE_ORDER_QUANTITY gt 0>
                    <cfset t_ROW_ORT_STOK_SATIS_MIKTARI = t_ROW_ORT_STOK_SATIS_MIKTARI + ROW_ORT_STOK_SATIS_MIKTARI>
                    <cfset t_gunluk_satis_tutar = t_gunluk_satis_tutar + gunluk_satis_tutar>
                    <cfset t_vade_total_ = t_vade_total_ + vade_total_>
                    <cfset t_ek_vade_ = t_ek_vade_ + ek_vade_>
                    <cfset ort_p_count = ort_p_count + 1>
                </cfif>
                <cfset t_row_stock = t_row_stock + row_stock>
                <cfset t_eldeki_stock_tutar = t_eldeki_stock_tutar + eldeki_stock_tutar>
                <cfset t_PURCHASE_ORDER_QUANTITY = t_PURCHASE_ORDER_QUANTITY + PURCHASE_ORDER_QUANTITY>
                <cfset t_PURCHASE_ORDER_TUTAR = t_PURCHASE_ORDER_TUTAR + (PURCHASE_ORDER_QUANTITY * LISTE_FIYATI)>
                <cfset t_total_miktar_ = t_total_miktar_ + total_miktar_>
                <cfset t_total_tutar_ = t_total_tutar_ + total_tutar_>
                <cfset t_vade_gun_miktar_ = t_vade_gun_miktar_ + vade_gun_miktar_>
                <cfset t_vade_gun_tutar_ = t_vade_gun_tutar_ + vade_gun_tutar_>
                <cfset t_ek_vade_gun_miktar_ = t_ek_vade_gun_miktar_ + ek_vade_gun_miktar_>
                <cfset t_ek_vade_gun_tutar_ = t_ek_vade_gun_tutar_ + ek_vade_gun_tutar_>
                <cfset t_total_vade_miktar_ = t_total_vade_miktar_ + total_vade_miktar_>
                <cfset t_total_vade_tutar_ = t_total_vade_tutar_ + total_vade_tutar_>
                <cfset t_satici_limit_miktar_ = t_satici_limit_miktar_ + satici_limit_miktar_>
                <cfset t_satici_limit_tutar_ = t_satici_limit_tutar_ + satici_limit_tutar_>
                <cfset p_count = p_count + 1>
                
                
                <cfif ROW_ORT_STOK_SATIS_MIKTARI gt 0 or row_stock gt 0 or PURCHASE_ORDER_QUANTITY gt 0>
                    <cfset gt_ROW_ORT_STOK_SATIS_MIKTARI = gt_ROW_ORT_STOK_SATIS_MIKTARI + ROW_ORT_STOK_SATIS_MIKTARI>
                    <cfset gt_gunluk_satis_tutar = gt_gunluk_satis_tutar + gunluk_satis_tutar>
                    <cfset gt_vade_total_ = gt_vade_total_ + vade_total_>
                    <cfset gt_ek_vade_ = gt_ek_vade_ + ek_vade_>
                    <cfset ort_gp_count = ort_gp_count + 1>
                </cfif>
                <cfset gt_row_stock = gt_row_stock + row_stock>
                <cfset gt_eldeki_stock_tutar = gt_eldeki_stock_tutar + eldeki_stock_tutar>
                <cfset gt_PURCHASE_ORDER_QUANTITY = gt_PURCHASE_ORDER_QUANTITY + PURCHASE_ORDER_QUANTITY>
                <cfset gt_PURCHASE_ORDER_TUTAR = gt_PURCHASE_ORDER_TUTAR + (PURCHASE_ORDER_QUANTITY * LISTE_FIYATI)>
                <cfset gt_total_miktar_ = gt_total_miktar_ + total_miktar_>
                <cfset gt_total_tutar_ = gt_total_tutar_ + total_tutar_>
                <cfset gt_vade_gun_miktar_ = gt_vade_gun_miktar_ + vade_gun_miktar_>
                <cfset gt_vade_gun_tutar_ = gt_vade_gun_tutar_ + vade_gun_tutar_>
                <cfset gt_ek_vade_gun_miktar_ = gt_ek_vade_gun_miktar_ + ek_vade_gun_miktar_>
                <cfset gt_ek_vade_gun_tutar_ = gt_ek_vade_gun_tutar_ + ek_vade_gun_tutar_>
                <cfset gt_total_vade_miktar_ = gt_total_vade_miktar_ + total_vade_miktar_>
                <cfset gt_total_vade_tutar_ = gt_total_vade_tutar_ + total_vade_tutar_>
                <cfset gt_satici_limit_miktar_ = gt_satici_limit_miktar_ + satici_limit_miktar_>
                <cfset gt_satici_limit_tutar_ = gt_satici_limit_tutar_ + satici_limit_tutar_>
                <cfset gp_count = gp_count + 1>
           </cfif>     
               <cfif (currentrow eq get_products.recordcount or HIERARCHY neq HIERARCHY[currentrow + 1]) and p_count gt 0>
                    <tr>
                        <td style="background-color:##CAF7E8;">
                            <a href="javascript://" onclick="goster_seller_limit_rows_arti('#product_catid#');" class="tableyazi">#PRODUCT_CAT#</a>
                        </td>
                        <td style="background-color:##CAF7E8;text-align:right"><cfif ort_p_count gt 0>#tlformat(t_ROW_ORT_STOK_SATIS_MIKTARI)#<cfelse>0</cfif></td>
                        <td style="background-color:##CAF7E8;text-align:right"><cfif ort_p_count gt 0>#tlformat(t_gunluk_satis_tutar )#<cfelse>0</cfif></td>
                        <td style="background-color:##CAF7E8;text-align:right"><cfif ort_p_count gt 0>#tlformat(t_vade_total_ / ort_p_count)#<cfelse>0</cfif></td>
                        <td style="background-color:##CAF7E8;text-align:right"><cfif ort_p_count gt 0>#tlformat(t_ek_vade_ / ort_p_count)#<cfelse>0</cfif></td>
                        <td style="background-color:##FFAB73;text-align:right">#tlformat(t_row_stock)#</td>
                        <td style="background-color:##a9a9a9;text-align:right;">#tlformat(t_eldeki_stock_tutar)#</td>
                        <td style="background-color:##FFAB73;text-align:right">#tlformat(t_PURCHASE_ORDER_QUANTITY)#</td>
                        <td style="background-color:##a9a9a9;text-align:right">#tlformat(t_PURCHASE_ORDER_TUTAR)#</td>
                        <td style="background-color:##FFAB73;text-align:right">#tlformat(t_total_miktar_)#</td>
                        <td style="background-color:##2f4f4f;color:##b0e0e6;text-align:right">#tlformat(t_total_tutar_)#</td>
                        
                        <td style="background-color:##FFE500;text-align:right">#tlformat(t_vade_gun_miktar_)#</td>
                        <td style="background-color:##FFE500;text-align:right">#tlformat(t_ek_vade_gun_miktar_)#</td>
                        <td style="background-color:##FFE500;text-align:right;">#tlformat(t_total_vade_miktar_)#</td>
                        <td style="background-color:##a9a9a9;text-align:right">#tlformat(t_vade_gun_tutar_)#</td>
                        <td style="background-color:##a9a9a9;text-align:right">#tlformat(t_ek_vade_gun_tutar_)#</td>
                        <td style="background-color:##2f4f4f;color:##b0e0e6;text-align:right;">#tlformat(t_total_vade_tutar_)#</td>
                        <td style="background-color:##FFE500;text-align:right">#tlformat(t_satici_limit_miktar_)#</td>
                        <td style="background-color:##FFE500;text-align:right;<cfif t_satici_limit_tutar_ lte 0>color:red;</cfif>">#tlformat(t_satici_limit_tutar_)#</td>
                    </tr>
                    
                    <cfset t_ROW_ORT_STOK_SATIS_MIKTARI = 0>
                    <cfset t_gunluk_satis_tutar = 0>
                    <cfset t_vade_total_ = 0>
                    <cfset t_ek_vade_ = 0>
                    <cfset t_row_stock = 0>
                    <cfset t_eldeki_stock_tutar = 0>
                    <cfset t_PURCHASE_ORDER_QUANTITY = 0>
                    <cfset t_PURCHASE_ORDER_TUTAR = 0>
                    <cfset t_total_miktar_ = 0>
                    <cfset t_total_tutar_ = 0>
                    <cfset t_vade_gun_miktar_ = 0>
                    <cfset t_vade_gun_tutar_ = 0>
                    <cfset t_ek_vade_gun_miktar_ = 0>
                    <cfset t_ek_vade_gun_tutar_ = 0>
                    <cfset t_total_vade_miktar_ = 0>
                    <cfset t_total_vade_tutar_ = 0>
                    <cfset t_satici_limit_miktar_ = 0>
                    <cfset t_satici_limit_tutar_ = 0>
                    <cfset p_count = 0>
                    <cfset ort_p_count = 0>
                </cfif>
                </cfoutput>
            </tbody>
            <tfoot>
                <cfoutput>
                    <tr>
                        <td style="background-color:##5CCCCC;">Toplam</td>
                        <td style="background-color:##5CCCCC;text-align:right">#tlformat(gt_ROW_ORT_STOK_SATIS_MIKTARI)#</td>
                        <td style="background-color:##5CCCCC;text-align:right">#tlformat(gt_gunluk_satis_tutar)#</td>
                        <td style="background-color:##5CCCCC;text-align:right">#tlformat(gt_vade_total_ / ort_gp_count)#</td>
                        <td style="background-color:##5CCCCC;text-align:right">#tlformat(gt_ek_vade_ / ort_gp_count)#</td>
                        <td style="background-color:##FF8D40;text-align:right">#tlformat(gt_row_stock)#</td>
                        <td style="background-color:##696969;color:##ffffff;text-align:right">#tlformat(gt_eldeki_stock_tutar)#</td>
                        <td style="background-color:##FF8D40;text-align:right">#tlformat(gt_PURCHASE_ORDER_QUANTITY)#</td>
                        <td style="background-color:##696969;color:##ffffff;text-align:right">#tlformat(gt_PURCHASE_ORDER_TUTAR)#</td>
                        <td style="background-color:##FF8D40;text-align:right">#tlformat(gt_total_miktar_)#</td>
                        <td style="background-color:##000000;color:##ffffff;text-align:right">aaa#tlformat(gt_total_tutar_)#</td>
                        
                        <td style="background-color:##BFB130;text-align:right">#tlformat(gt_vade_gun_miktar_)#</td>
                        <td style="background-color:##BFB130;text-align:right">#tlformat(gt_ek_vade_gun_miktar_)#</td>
                        <td style="background-color:##BFB130;text-align:right">#tlformat(gt_total_vade_miktar_)#</td>
                        <td style="background-color:##696969;color:##ffffff;text-align:right">#tlformat(gt_vade_gun_tutar_)#</td>
                        <td style="background-color:##696969;color:##ffffff;text-align:right">#tlformat(gt_ek_vade_gun_tutar_)#</td>
                        <td style="background-color:##000000;color:##ffffff;text-align:right">#tlformat(gt_total_vade_tutar_)#</td>
                        <td style="background-color:##BFB130;text-align:right">#tlformat(gt_satici_limit_miktar_)#</td>
                        <td style="background-color:##BFB130;text-align:right">#tlformat(gt_satici_limit_tutar_)#</td>
                    </tr>
                </cfoutput>
            </tfoot>
        </cf_medium_list>
        <cf_medium_list id="manage_table_seller_limit_eksi" style="display:none;">
            <thead>
                <tr>
                    <th>Limit Tablosu</th>
                    <th colspan="4" style="text-align:center;">Değerler</th>
                    <th colspan="6" style="text-align:center;">Stok Sipariş Tutarı</th>
                    <th colspan="8" style="text-align:center;">Hedef</th>
                </tr>
                <tr>
                    <th>Liste Adı</th>
                    <th>1 Gün.Ort.Sat.Mk</th>
                    <th>2 Gün.Ort.Sat.TL</th>
                    <th>3 Vade</th>
                    <th>4 İlave Gün</th>
                    <th>5 Stok Ad.</th>
                    <th>6 Stok Tut.</th>
                    <th>7 Sip. Ad.</th>
                    <th>8 Sip Tut.</th>
                    <th>9 Stok + Sip. Top. Ad.</th>
                    <th>10 Stok + Sip Top. Tut.</th>
                    <th>11 Vade Gün Ad.</th>
                    <th>12 Ek Vade Gün Ad.</th>
                    <th>13 Vade + Ek Vade Ad.</th>
                    <th>14 Vade Gün Tut.</th>
                    <th>15 Ek Vade Gün Tut.</th>
                    <th>16 Max. Hedef Tut.<br>VadeGün + EkVade Gün Tut.</th>
                    <th>17 Satıcı Limit Adet</th>
                    <th>18 Satıcı Limit Tutar <br> 16-10</th>
                </tr>
            </thead>
            <tbody>
                <cfset t_ROW_ORT_STOK_SATIS_MIKTARI = 0>
                <cfset t_gunluk_satis_tutar = 0>
                <cfset t_vade_total_ = 0>
                <cfset t_ek_vade_ = 0>
                <cfset t_row_stock = 0>
                <cfset t_eldeki_stock_tutar = 0>
                <cfset t_PURCHASE_ORDER_QUANTITY = 0>
                <cfset t_PURCHASE_ORDER_TUTAR = 0>
                <cfset t_total_miktar_ = 0>
                <cfset t_total_tutar_ = 0>
                <cfset t_vade_gun_miktar_ = 0>
                <cfset t_vade_gun_tutar_ = 0>
                <cfset t_ek_vade_gun_miktar_ = 0>
                <cfset t_ek_vade_gun_tutar_ = 0>
                <cfset t_total_vade_miktar_ = 0>
                <cfset t_total_vade_tutar_ = 0>
                <cfset t_satici_limit_miktar_ = 0>
                <cfset t_satici_limit_tutar_ = 0>
                <cfset p_count = 0>
                <cfset ort_p_count = 0>
                
                <cfset gt_ROW_ORT_STOK_SATIS_MIKTARI = 0>
                <cfset gt_gunluk_satis_tutar = 0>
                <cfset gt_vade_total_ = 0>
                <cfset gt_ek_vade_ = 0>
                <cfset gt_row_stock = 0>
                <cfset gt_eldeki_stock_tutar = 0>
                <cfset gt_PURCHASE_ORDER_QUANTITY = 0>
                <cfset gt_PURCHASE_ORDER_TUTAR = 0>
                <cfset gt_total_miktar_ = 0>
                <cfset gt_total_tutar_ = 0>
                <cfset gt_vade_gun_miktar_ = 0>
                <cfset gt_vade_gun_tutar_ = 0>
                <cfset gt_ek_vade_gun_miktar_ = 0>
                <cfset gt_ek_vade_gun_tutar_ = 0>
                <cfset gt_total_vade_miktar_ = 0>
                <cfset gt_total_vade_tutar_ = 0>
                <cfset gt_satici_limit_miktar_ = 0>
                <cfset gt_satici_limit_tutar_ = 0>
                <cfset gp_count = 0>
                <cfset ort_gp_count = 0>
                
                <cfoutput query="get_products">
                <cfif len(DUEDAY)>
                    <cfset vade_ = DUEDAY>
                <cfelse>
                    <cfset vade_ = 30>
                </cfif>
                <cfif len(ADD_STOCK_DAY)>
                    <cfset ek_vade_ = ADD_STOCK_DAY>
                <cfelse>
                    <cfset ek_vade_ = 1>
                </cfif>
                <cfset gunluk_satis_tutar = ROW_ORT_STOK_SATIS_MIKTARI * LISTE_FIYATI>
                <cfset vade_total_ = vade_>
                <cfset eldeki_stock_tutar = row_stock * LISTE_FIYATI_ALIS>
                <cfset total_miktar_ = row_stock + PURCHASE_ORDER_QUANTITY>
                <cfset total_tutar_ = eldeki_stock_tutar + (PURCHASE_ORDER_QUANTITY * LISTE_FIYATI_ALIS)>
                <cfset vade_gun_miktar_ = ROW_ORT_STOK_SATIS_MIKTARI * vade_total_>
                <cfset ek_vade_gun_miktar_ = ROW_ORT_STOK_SATIS_MIKTARI * ek_vade_>
                <cfset total_vade_miktar_ = vade_gun_miktar_ + ek_vade_gun_miktar_>
                <cfset vade_gun_tutar_ = gunluk_satis_tutar * vade_total_>
                <cfset ek_vade_gun_tutar_ = gunluk_satis_tutar * ek_vade_>
                <cfset total_vade_tutar_ = vade_gun_tutar_ + ek_vade_gun_tutar_>
                <cfset satici_limit_miktar_ = total_vade_miktar_ - total_miktar_>
                <cfset satici_limit_tutar_ = total_vade_tutar_ - total_tutar_>
            <cfif satici_limit_tutar_ lt 0>
                <tr row_code="product_cat_#product_catid#" style="">
                    <td style="background-color:##CCFFCC;" title="#product_id# / #tlformat(LISTE_FIYATI)#">#property#</td>
                    <td style="background-color:##CCFFCC;text-align:right;">#tlformat(ROW_ORT_STOK_SATIS_MIKTARI)#</td>
                    <td style="background-color:##CCFFCC;text-align:right;">#tlformat(gunluk_satis_tutar)#</td>
                    <td style="background-color:##CCFFCC;text-align:right;">#vade_total_#</td>
                    <td style="background-color:##CCFFCC;text-align:right;">#ek_vade_#</td>
                    <td style="background-color:##FFDEAD;text-align:right;">#tlformat(row_stock)#</td>
                    <td style="background-color:##dcdcdc;text-align:right;">#tlformat(eldeki_stock_tutar)#</td>
                    <td style="background-color:##FFDEAD;text-align:right;">#tlformat(PURCHASE_ORDER_QUANTITY)#</td>
                    <td style="background-color:##dcdcdc;text-align:right;">#tlformat(PURCHASE_ORDER_QUANTITY * LISTE_FIYATI_ALIS)#</td>
                    <td style="background-color:##FFDEAD;text-align:right;">#tlformat(total_miktar_)#</td>
                    <td style="background-color:##dcdcdc;text-align:right;">#tlformat(total_tutar_)#</td>
                    <td style="background-color:##FFFACD;text-align:right;">#tlformat(vade_gun_miktar_)#</td>
                    <td style="background-color:##FFFACD;text-align:right;">#tlformat(ek_vade_gun_miktar_)#</td>
                    <td style="background-color:##FFFACD;text-align:right;">#tlformat(total_vade_miktar_)#</td>
                    <td style="background-color:##dcdcdc;text-align:right;">#tlformat(vade_gun_tutar_)#</td>
                    <td style="background-color:##dcdcdc;text-align:right;">#tlformat(ek_vade_gun_tutar_)#</td>
                    <td style="background-color:##FFFACD;text-align:right;">#tlformat(total_vade_tutar_)#</td>
                    <td style="background-color:##FFFACD;text-align:right;">#tlformat(satici_limit_miktar_)#</td>
                    <td style="background-color:##FFFACD;text-align:right;">#tlformat(satici_limit_tutar_)#</td>
                </tr>
                <cfif ROW_ORT_STOK_SATIS_MIKTARI gt 0 or row_stock gt 0 or PURCHASE_ORDER_QUANTITY gt 0>
                    <cfset t_ROW_ORT_STOK_SATIS_MIKTARI = t_ROW_ORT_STOK_SATIS_MIKTARI + ROW_ORT_STOK_SATIS_MIKTARI>
                    <cfset t_gunluk_satis_tutar = t_gunluk_satis_tutar + gunluk_satis_tutar>
                    <cfset t_vade_total_ = t_vade_total_ + vade_total_>
                    <cfset t_ek_vade_ = t_ek_vade_ + ek_vade_>
                    <cfset ort_p_count = ort_p_count + 1>
                </cfif>
                <cfset t_row_stock = t_row_stock + row_stock>
                <cfset t_eldeki_stock_tutar = t_eldeki_stock_tutar + eldeki_stock_tutar>
                <cfset t_PURCHASE_ORDER_QUANTITY = t_PURCHASE_ORDER_QUANTITY + PURCHASE_ORDER_QUANTITY>
                <cfset t_PURCHASE_ORDER_TUTAR = t_PURCHASE_ORDER_TUTAR + (PURCHASE_ORDER_QUANTITY * LISTE_FIYATI)>
                <cfset t_total_miktar_ = t_total_miktar_ + total_miktar_>
                <cfset t_total_tutar_ = t_total_tutar_ + total_tutar_>
                <cfset t_vade_gun_miktar_ = t_vade_gun_miktar_ + vade_gun_miktar_>
                <cfset t_vade_gun_tutar_ = t_vade_gun_tutar_ + vade_gun_tutar_>
                <cfset t_ek_vade_gun_miktar_ = t_ek_vade_gun_miktar_ + ek_vade_gun_miktar_>
                <cfset t_ek_vade_gun_tutar_ = t_ek_vade_gun_tutar_ + ek_vade_gun_tutar_>
                <cfset t_total_vade_miktar_ = t_total_vade_miktar_ + total_vade_miktar_>
                <cfset t_total_vade_tutar_ = t_total_vade_tutar_ + total_vade_tutar_>
                <cfset t_satici_limit_miktar_ = t_satici_limit_miktar_ + satici_limit_miktar_>
                <cfset t_satici_limit_tutar_ = t_satici_limit_tutar_ + satici_limit_tutar_>
                <cfset p_count = p_count + 1>
                
                
                <cfif ROW_ORT_STOK_SATIS_MIKTARI gt 0 or row_stock gt 0 or PURCHASE_ORDER_QUANTITY gt 0>
                    <cfset gt_ROW_ORT_STOK_SATIS_MIKTARI = gt_ROW_ORT_STOK_SATIS_MIKTARI + ROW_ORT_STOK_SATIS_MIKTARI>
                    <cfset gt_gunluk_satis_tutar = gt_gunluk_satis_tutar + gunluk_satis_tutar>
                    <cfset gt_vade_total_ = gt_vade_total_ + vade_total_>
                    <cfset gt_ek_vade_ = gt_ek_vade_ + ek_vade_>
                    <cfset ort_gp_count = ort_gp_count + 1>
                </cfif>
                <cfset gt_row_stock = gt_row_stock + row_stock>
                <cfset gt_eldeki_stock_tutar = gt_eldeki_stock_tutar + eldeki_stock_tutar>
                <cfset gt_PURCHASE_ORDER_QUANTITY = gt_PURCHASE_ORDER_QUANTITY + PURCHASE_ORDER_QUANTITY>
                <cfset gt_PURCHASE_ORDER_TUTAR = gt_PURCHASE_ORDER_TUTAR + (PURCHASE_ORDER_QUANTITY * LISTE_FIYATI)>
                <cfset gt_total_miktar_ = gt_total_miktar_ + total_miktar_>
                <cfset gt_total_tutar_ = gt_total_tutar_ + total_tutar_>
                <cfset gt_vade_gun_miktar_ = gt_vade_gun_miktar_ + vade_gun_miktar_>
                <cfset gt_vade_gun_tutar_ = gt_vade_gun_tutar_ + vade_gun_tutar_>
                <cfset gt_ek_vade_gun_miktar_ = gt_ek_vade_gun_miktar_ + ek_vade_gun_miktar_>
                <cfset gt_ek_vade_gun_tutar_ = gt_ek_vade_gun_tutar_ + ek_vade_gun_tutar_>
                <cfset gt_total_vade_miktar_ = gt_total_vade_miktar_ + total_vade_miktar_>
                <cfset gt_total_vade_tutar_ = gt_total_vade_tutar_ + total_vade_tutar_>
                <cfset gt_satici_limit_miktar_ = gt_satici_limit_miktar_ + satici_limit_miktar_>
                <cfset gt_satici_limit_tutar_ = gt_satici_limit_tutar_ + satici_limit_tutar_>
                <cfset gp_count = gp_count + 1>
           </cfif>     
               <cfif (currentrow eq get_products.recordcount or HIERARCHY neq HIERARCHY[currentrow + 1]) and p_count gt 0>
                    <tr>
                        <td style="background-color:##CAF7E8;">
                            <a href="javascript://" onclick="goster_seller_limit_rows_eksi('#product_catid#');" class="tableyazi">#PRODUCT_CAT#</a>
                        </td>
                        <td style="background-color:##CAF7E8;text-align:right"><cfif ort_p_count gt 0>#tlformat(t_ROW_ORT_STOK_SATIS_MIKTARI)#<cfelse>0</cfif></td>
                        <td style="background-color:##CAF7E8;text-align:right"><cfif ort_p_count gt 0>#tlformat(t_gunluk_satis_tutar )#<cfelse>0</cfif></td>
                        <td style="background-color:##CAF7E8;text-align:right"><cfif ort_p_count gt 0>#tlformat(t_vade_total_ / ort_p_count)#<cfelse>0</cfif></td>
                        <td style="background-color:##CAF7E8;text-align:right"><cfif ort_p_count gt 0>#tlformat(t_ek_vade_ / ort_p_count)#<cfelse>0</cfif></td>
                        <td style="background-color:##FFAB73;text-align:right">#tlformat(t_row_stock)#</td>
                        <td style="background-color:##a9a9a9;text-align:right;">#tlformat(t_eldeki_stock_tutar)#</td>
                        <td style="background-color:##FFAB73;text-align:right">#tlformat(t_PURCHASE_ORDER_QUANTITY)#</td>
                        <td style="background-color:##a9a9a9;text-align:right">#tlformat(t_PURCHASE_ORDER_TUTAR)#</td>
                        <td style="background-color:##FFAB73;text-align:right">#tlformat(t_total_miktar_)#</td>
                        <td style="background-color:##2f4f4f;color:##b0e0e6;text-align:right">#tlformat(t_total_tutar_)#</td>
                        
                        <td style="background-color:##FFE500;text-align:right">#tlformat(t_vade_gun_miktar_)#</td>
                        <td style="background-color:##FFE500;text-align:right">#tlformat(t_ek_vade_gun_miktar_)#</td>
                        <td style="background-color:##FFE500;text-align:right;">#tlformat(t_total_vade_miktar_)#</td>
                        <td style="background-color:##a9a9a9;text-align:right">#tlformat(t_vade_gun_tutar_)#</td>
                        <td style="background-color:##a9a9a9;text-align:right">#tlformat(t_ek_vade_gun_tutar_)#</td>
                        <td style="background-color:##2f4f4f;color:##b0e0e6;text-align:right;">#tlformat(t_total_vade_tutar_)#</td>
                        <td style="background-color:##FFE500;text-align:right">#tlformat(t_satici_limit_miktar_)#</td>
                        <td style="background-color:##FFE500;text-align:right;<cfif t_satici_limit_tutar_ lte 0>color:red;</cfif>">#tlformat(t_satici_limit_tutar_)#</td>
                    </tr>
                    
                    <cfset t_ROW_ORT_STOK_SATIS_MIKTARI = 0>
                    <cfset t_gunluk_satis_tutar = 0>
                    <cfset t_vade_total_ = 0>
                    <cfset t_ek_vade_ = 0>
                    <cfset t_row_stock = 0>
                    <cfset t_eldeki_stock_tutar = 0>
                    <cfset t_PURCHASE_ORDER_QUANTITY = 0>
                    <cfset t_PURCHASE_ORDER_TUTAR = 0>
                    <cfset t_total_miktar_ = 0>
                    <cfset t_total_tutar_ = 0>
                    <cfset t_vade_gun_miktar_ = 0>
                    <cfset t_vade_gun_tutar_ = 0>
                    <cfset t_ek_vade_gun_miktar_ = 0>
                    <cfset t_ek_vade_gun_tutar_ = 0>
                    <cfset t_total_vade_miktar_ = 0>
                    <cfset t_total_vade_tutar_ = 0>
                    <cfset t_satici_limit_miktar_ = 0>
                    <cfset t_satici_limit_tutar_ = 0>
                    <cfset p_count = 0>
                    <cfset ort_p_count = 0>
                </cfif>
                </cfoutput>
            </tbody>
            <tfoot>
                <cfoutput>
                    <tr>
                        <td style="background-color:##5CCCCC;">Toplam</td>
                        <td style="background-color:##5CCCCC;text-align:right">#tlformat(gt_ROW_ORT_STOK_SATIS_MIKTARI)#</td>
                        <td style="background-color:##5CCCCC;text-align:right">#tlformat(gt_gunluk_satis_tutar)#</td>
                        <td style="background-color:##5CCCCC;text-align:right">#tlformat(gt_vade_total_ / ort_gp_count)#</td>
                        <td style="background-color:##5CCCCC;text-align:right">#tlformat(gt_ek_vade_ / ort_gp_count)#</td>
                        <td style="background-color:##FF8D40;text-align:right">#tlformat(gt_row_stock)#</td>
                        <td style="background-color:##696969;color:##ffffff;text-align:right">#tlformat(gt_eldeki_stock_tutar)#</td>
                        <td style="background-color:##FF8D40;text-align:right">#tlformat(gt_PURCHASE_ORDER_QUANTITY)#</td>
                        <td style="background-color:##696969;color:##ffffff;text-align:right">#tlformat(gt_PURCHASE_ORDER_TUTAR)#</td>
                        <td style="background-color:##FF8D40;text-align:right">#tlformat(gt_total_miktar_)#</td>
                        <td style="background-color:##000000;color:##ffffff;text-align:right">aaa#tlformat(gt_total_tutar_)#</td>
                        
                        <td style="background-color:##BFB130;text-align:right">#tlformat(gt_vade_gun_miktar_)#</td>
                        <td style="background-color:##BFB130;text-align:right">#tlformat(gt_ek_vade_gun_miktar_)#</td>
                        <td style="background-color:##BFB130;text-align:right">#tlformat(gt_total_vade_miktar_)#</td>
                        <td style="background-color:##696969;color:##ffffff;text-align:right">#tlformat(gt_vade_gun_tutar_)#</td>
                        <td style="background-color:##696969;color:##ffffff;text-align:right">#tlformat(gt_ek_vade_gun_tutar_)#</td>
                        <td style="background-color:##000000;color:##ffffff;text-align:right">#tlformat(gt_total_vade_tutar_)#</td>
                        <td style="background-color:##BFB130;text-align:right">#tlformat(gt_satici_limit_miktar_)#</td>
                        <td style="background-color:##BFB130;text-align:right">#tlformat(gt_satici_limit_tutar_)#</td>
                    </tr>
                </cfoutput>
            </tfoot>
        </cf_medium_list>
    </cfif>
    <cfif isdefined('attributes.table_code')>
    	<cfset id_ = "manage_table_seller_limit_all">
    <cfelse>
    	<cfset id_ = "manage_table_seller_limit">
    </cfif>
    <cf_medium_list id="#id_#">
        <thead>
            <tr>
                <th>Limit Tablosu</th>
                <th colspan="4" style="text-align:center;">Değerler</th>
                <th colspan="6" style="text-align:center;">Stok Sipariş Tutarı</th>
                <th colspan="8" style="text-align:center;">Hedef</th>
            </tr>
            <tr>
                <th>Liste Adı</th>
                <th>1 Gün.Ort.Sat.Mk</th>
                <th>2 Gün.Ort.Sat.TL</th>
                <th>3 Vade</th>
                <th>4 İlave Gün</th>
                <th>5 Stok Ad.</th>
                <th>6 Stok Tut.</th>
                <th>7 Sip. Ad.</th>
                <th>8 Sip Tut.</th>
                <th>9 Stok + Sip. Top. Ad.</th>
                <th>10 Stok + Sip Top. Tut.</th>
                <th>11 Vade Gün Ad.</th>
                <th>12 Ek Vade Gün Ad.</th>
                <th>13 Vade + Ek Vade Ad.</th>
                <th>14 Vade Gün Tut.</th>
                <th>15 Ek Vade Gün Tut.</th>
                <th>16 Max. Hedef Tut.<br>VadeGün + EkVade Gün Tut.</th>
                <th>17 Satıcı Limit Adet</th>
                <th>18 Satıcı Limit Tutar <br> 16-10</th>
            </tr>
        </thead>
        <tbody>
            <cfset t_ROW_ORT_STOK_SATIS_MIKTARI = 0>
            <cfset t_gunluk_satis_tutar = 0>
            <cfset t_vade_total_ = 0>
            <cfset t_ek_vade_ = 0>
            <cfset t_row_stock = 0>
            <cfset t_eldeki_stock_tutar = 0>
            <cfset t_PURCHASE_ORDER_QUANTITY = 0>
            <cfset t_PURCHASE_ORDER_TUTAR = 0>
            <cfset t_total_miktar_ = 0>
            <cfset t_total_tutar_ = 0>
            <cfset t_vade_gun_miktar_ = 0>
            <cfset t_vade_gun_tutar_ = 0>
            <cfset t_ek_vade_gun_miktar_ = 0>
            <cfset t_ek_vade_gun_tutar_ = 0>
            <cfset t_total_vade_miktar_ = 0>
            <cfset t_total_vade_tutar_ = 0>
            <cfset t_satici_limit_miktar_ = 0>
            <cfset t_satici_limit_tutar_ = 0>
            <cfset p_count = 0>
            <cfset ort_p_count = 0>
            
            <cfset gt_ROW_ORT_STOK_SATIS_MIKTARI = 0>
            <cfset gt_gunluk_satis_tutar = 0>
            <cfset gt_vade_total_ = 0>
            <cfset gt_ek_vade_ = 0>
            <cfset gt_row_stock = 0>
            <cfset gt_eldeki_stock_tutar = 0>
            <cfset gt_PURCHASE_ORDER_QUANTITY = 0>
            <cfset gt_PURCHASE_ORDER_TUTAR = 0>
            <cfset gt_total_miktar_ = 0>
            <cfset gt_total_tutar_ = 0>
            <cfset gt_vade_gun_miktar_ = 0>
            <cfset gt_vade_gun_tutar_ = 0>
            <cfset gt_ek_vade_gun_miktar_ = 0>
            <cfset gt_ek_vade_gun_tutar_ = 0>
            <cfset gt_total_vade_miktar_ = 0>
            <cfset gt_total_vade_tutar_ = 0>
            <cfset gt_satici_limit_miktar_ = 0>
            <cfset gt_satici_limit_tutar_ = 0>
            <cfset gp_count = 0>
            <cfset ort_gp_count = 0>
            
            <cfoutput query="get_products">
            <cfif len(DUEDAY)>
                <cfset vade_ = DUEDAY>
            <cfelse>
                <cfset vade_ = 30>
            </cfif>
            <cfif len(ADD_STOCK_DAY)>
                <cfset ek_vade_ = ADD_STOCK_DAY>
            <cfelse>
                <cfset ek_vade_ = 1>
            </cfif>
            <tr row_code="product_cat_#product_catid#" style="display:none;">
                <td style="background-color:##CCFFCC;" title="#product_id# / #tlformat(LISTE_FIYATI)#">#property#</td>
                <td style="background-color:##CCFFCC;text-align:right;">#tlformat(ROW_ORT_STOK_SATIS_MIKTARI)#</td>
                <td style="background-color:##CCFFCC;text-align:right;">
                    <cfset gunluk_satis_tutar = ROW_ORT_STOK_SATIS_MIKTARI * LISTE_FIYATI>
                    #tlformat(gunluk_satis_tutar)#
                </td>
                <td style="background-color:##CCFFCC;text-align:right;">
                    <cfset vade_total_ = vade_>
                    #vade_total_#
                </td>
                <td style="background-color:##CCFFCC;text-align:right;">#ek_vade_#</td>
                <td style="background-color:##FFDEAD;text-align:right;">#tlformat(row_stock)#</td>
                <td style="background-color:##dcdcdc;text-align:right;">
                    <cfset eldeki_stock_tutar = row_stock * LISTE_FIYATI_ALIS>
                    #tlformat(eldeki_stock_tutar)#
                </td>
                <td style="background-color:##FFDEAD;text-align:right;">#tlformat(PURCHASE_ORDER_QUANTITY)#</td>
                <td style="background-color:##dcdcdc;text-align:right;">#tlformat(PURCHASE_ORDER_QUANTITY * LISTE_FIYATI_ALIS)#</td>
                <td style="background-color:##FFDEAD;text-align:right;">
                    <cfset total_miktar_ = row_stock + PURCHASE_ORDER_QUANTITY>
                    #tlformat(total_miktar_)#
                </td>
                <td style="background-color:##dcdcdc;text-align:right;">
                    <cfset total_tutar_ = eldeki_stock_tutar + (PURCHASE_ORDER_QUANTITY * LISTE_FIYATI_ALIS)>
                    #tlformat(total_tutar_)#
                </td>
                <td style="background-color:##FFFACD;text-align:right;">
                    <cfset vade_gun_miktar_ = ROW_ORT_STOK_SATIS_MIKTARI * vade_total_>
                    #tlformat(vade_gun_miktar_)#
                </td>
                <td style="background-color:##FFFACD;text-align:right;">
                    <cfset ek_vade_gun_miktar_ = ROW_ORT_STOK_SATIS_MIKTARI * ek_vade_>
                    #tlformat(ek_vade_gun_miktar_)#
                </td>
                <td style="background-color:##FFFACD;text-align:right;">
                    <cfset total_vade_miktar_ = vade_gun_miktar_ + ek_vade_gun_miktar_>
                    #tlformat(total_vade_miktar_)#
                </td>
                <td style="background-color:##dcdcdc;text-align:right;">
                    <cfset vade_gun_tutar_ = gunluk_satis_tutar * vade_total_>
                    #tlformat(vade_gun_tutar_)#
                </td>
                <td style="background-color:##dcdcdc;text-align:right;">
                    <cfset ek_vade_gun_tutar_ = gunluk_satis_tutar * ek_vade_>
                    #tlformat(ek_vade_gun_tutar_)#
                </td>
                <td style="background-color:##FFFACD;text-align:right;">
                    <cfset total_vade_tutar_ = vade_gun_tutar_ + ek_vade_gun_tutar_>
                    #tlformat(total_vade_tutar_)#
                </td>
                <td style="background-color:##FFFACD;text-align:right;">
                    <cfset satici_limit_miktar_ = total_vade_miktar_ - total_miktar_>
                    #tlformat(satici_limit_miktar_)#
                </td>
                <td style="background-color:##FFFACD;text-align:right;">
                    <cfset satici_limit_tutar_ = total_vade_tutar_ - total_tutar_>
                    #tlformat(satici_limit_tutar_)#
                </td>
            </tr>
            <cfif ROW_ORT_STOK_SATIS_MIKTARI gt 0 or row_stock gt 0 or PURCHASE_ORDER_QUANTITY gt 0>
                <cfset t_ROW_ORT_STOK_SATIS_MIKTARI = t_ROW_ORT_STOK_SATIS_MIKTARI + ROW_ORT_STOK_SATIS_MIKTARI>
                <cfset t_gunluk_satis_tutar = t_gunluk_satis_tutar + gunluk_satis_tutar>
                <cfset t_vade_total_ = t_vade_total_ + vade_total_>
                <cfset t_ek_vade_ = t_ek_vade_ + ek_vade_>
                <cfset ort_p_count = ort_p_count + 1>
            </cfif>
            <cfset t_row_stock = t_row_stock + row_stock>
            <cfset t_eldeki_stock_tutar = t_eldeki_stock_tutar + eldeki_stock_tutar>
            <cfset t_PURCHASE_ORDER_QUANTITY = t_PURCHASE_ORDER_QUANTITY + PURCHASE_ORDER_QUANTITY>
            <cfset t_PURCHASE_ORDER_TUTAR = t_PURCHASE_ORDER_TUTAR + (PURCHASE_ORDER_QUANTITY * LISTE_FIYATI)>
            <cfset t_total_miktar_ = t_total_miktar_ + total_miktar_>
            <cfset t_total_tutar_ = t_total_tutar_ + total_tutar_>
            <cfset t_vade_gun_miktar_ = t_vade_gun_miktar_ + vade_gun_miktar_>
            <cfset t_vade_gun_tutar_ = t_vade_gun_tutar_ + vade_gun_tutar_>
            <cfset t_ek_vade_gun_miktar_ = t_ek_vade_gun_miktar_ + ek_vade_gun_miktar_>
            <cfset t_ek_vade_gun_tutar_ = t_ek_vade_gun_tutar_ + ek_vade_gun_tutar_>
            <cfset t_total_vade_miktar_ = t_total_vade_miktar_ + total_vade_miktar_>
            <cfset t_total_vade_tutar_ = t_total_vade_tutar_ + total_vade_tutar_>
            <cfset t_satici_limit_miktar_ = t_satici_limit_miktar_ + satici_limit_miktar_>
            <cfset t_satici_limit_tutar_ = t_satici_limit_tutar_ + satici_limit_tutar_>
            <cfset p_count = p_count + 1>
            
            
            <cfif ROW_ORT_STOK_SATIS_MIKTARI gt 0 or row_stock gt 0 or PURCHASE_ORDER_QUANTITY gt 0>
                <cfset gt_ROW_ORT_STOK_SATIS_MIKTARI = gt_ROW_ORT_STOK_SATIS_MIKTARI + ROW_ORT_STOK_SATIS_MIKTARI>
                <cfset gt_gunluk_satis_tutar = gt_gunluk_satis_tutar + gunluk_satis_tutar>
                <cfset gt_vade_total_ = gt_vade_total_ + vade_total_>
                <cfset gt_ek_vade_ = gt_ek_vade_ + ek_vade_>
                <cfset ort_gp_count = ort_gp_count + 1>
            </cfif>
            <cfset gt_row_stock = gt_row_stock + row_stock>
            <cfset gt_eldeki_stock_tutar = gt_eldeki_stock_tutar + eldeki_stock_tutar>
            <cfset gt_PURCHASE_ORDER_QUANTITY = gt_PURCHASE_ORDER_QUANTITY + PURCHASE_ORDER_QUANTITY>
            <cfset gt_PURCHASE_ORDER_TUTAR = gt_PURCHASE_ORDER_TUTAR + (PURCHASE_ORDER_QUANTITY * LISTE_FIYATI)>
            <cfset gt_total_miktar_ = gt_total_miktar_ + total_miktar_>
            <cfset gt_total_tutar_ = gt_total_tutar_ + total_tutar_>
            <cfset gt_vade_gun_miktar_ = gt_vade_gun_miktar_ + vade_gun_miktar_>
            <cfset gt_vade_gun_tutar_ = gt_vade_gun_tutar_ + vade_gun_tutar_>
            <cfset gt_ek_vade_gun_miktar_ = gt_ek_vade_gun_miktar_ + ek_vade_gun_miktar_>
            <cfset gt_ek_vade_gun_tutar_ = gt_ek_vade_gun_tutar_ + ek_vade_gun_tutar_>
            <cfset gt_total_vade_miktar_ = gt_total_vade_miktar_ + total_vade_miktar_>
            <cfset gt_total_vade_tutar_ = gt_total_vade_tutar_ + total_vade_tutar_>
            <cfset gt_satici_limit_miktar_ = gt_satici_limit_miktar_ + satici_limit_miktar_>
            <cfset gt_satici_limit_tutar_ = gt_satici_limit_tutar_ + satici_limit_tutar_>
            <cfset gp_count = gp_count + 1>
            
            <cfif (currentrow eq get_products.recordcount or HIERARCHY neq HIERARCHY[currentrow + 1])>
                <tr>
                    <td style="background-color:##CAF7E8;">
                        <a href="javascript://" onclick="goster_seller_limit_rows('#product_catid#');" class="tableyazi">#PRODUCT_CAT#</a>
                    </td>
                    <td style="background-color:##CAF7E8;text-align:right"><cfif ort_p_count gt 0>#tlformat(t_ROW_ORT_STOK_SATIS_MIKTARI)#<cfelse>0</cfif></td>
                    <td style="background-color:##CAF7E8;text-align:right"><cfif ort_p_count gt 0>#tlformat(t_gunluk_satis_tutar )#<cfelse>0</cfif></td>
                    <td style="background-color:##CAF7E8;text-align:right"><cfif ort_p_count gt 0>#tlformat(t_vade_total_ / ort_p_count)#<cfelse>0</cfif></td>
                    <td style="background-color:##CAF7E8;text-align:right"><cfif ort_p_count gt 0>#tlformat(t_ek_vade_ / ort_p_count)#<cfelse>0</cfif></td>
                    <td style="background-color:##FFAB73;text-align:right">#tlformat(t_row_stock)#</td>
                    <td style="background-color:##a9a9a9;text-align:right;">#tlformat(t_eldeki_stock_tutar)#</td>
                    <td style="background-color:##FFAB73;text-align:right">#tlformat(t_PURCHASE_ORDER_QUANTITY)#</td>
                    <td style="background-color:##a9a9a9;text-align:right">#tlformat(t_PURCHASE_ORDER_TUTAR)#</td>
                    <td style="background-color:##FFAB73;text-align:right">#tlformat(t_total_miktar_)#</td>
                    <td style="background-color:##2f4f4f;color:##b0e0e6;text-align:right">#tlformat(t_total_tutar_)#</td>
                    
                    <td style="background-color:##FFE500;text-align:right">#tlformat(t_vade_gun_miktar_)#</td>
                    <td style="background-color:##FFE500;text-align:right">#tlformat(t_ek_vade_gun_miktar_)#</td>
                    <td style="background-color:##FFE500;text-align:right;">#tlformat(t_total_vade_miktar_)#</td>
                    <td style="background-color:##a9a9a9;text-align:right">#tlformat(t_vade_gun_tutar_)#</td>
                    <td style="background-color:##a9a9a9;text-align:right">#tlformat(t_ek_vade_gun_tutar_)#</td>
                    <td style="background-color:##2f4f4f;color:##b0e0e6;text-align:right;">#tlformat(t_total_vade_tutar_)#</td>
                    <td style="background-color:##FFE500;text-align:right">#tlformat(t_satici_limit_miktar_)#</td>
                    <td style="background-color:##FFE500;text-align:right;<cfif t_satici_limit_tutar_ lte 0>color:red;</cfif>">#tlformat(t_satici_limit_tutar_)#</td>
                </tr>
                
                <cfset t_ROW_ORT_STOK_SATIS_MIKTARI = 0>
                <cfset t_gunluk_satis_tutar = 0>
                <cfset t_vade_total_ = 0>
                <cfset t_ek_vade_ = 0>
                <cfset t_row_stock = 0>
                <cfset t_eldeki_stock_tutar = 0>
                <cfset t_PURCHASE_ORDER_QUANTITY = 0>
                <cfset t_PURCHASE_ORDER_TUTAR = 0>
                <cfset t_total_miktar_ = 0>
                <cfset t_total_tutar_ = 0>
                <cfset t_vade_gun_miktar_ = 0>
                <cfset t_vade_gun_tutar_ = 0>
                <cfset t_ek_vade_gun_miktar_ = 0>
                <cfset t_ek_vade_gun_tutar_ = 0>
                <cfset t_total_vade_miktar_ = 0>
                <cfset t_total_vade_tutar_ = 0>
                <cfset t_satici_limit_miktar_ = 0>
                <cfset t_satici_limit_tutar_ = 0>
                <cfset p_count = 0>
                <cfset ort_p_count = 0>
            </cfif>
            </cfoutput>
        </tbody>
        <tfoot>
            <cfoutput>
                <tr>
                    <td style="background-color:##5CCCCC;">Toplam</td>
                    <td style="background-color:##5CCCCC;text-align:right">#tlformat(gt_ROW_ORT_STOK_SATIS_MIKTARI)#</td>
                    <td style="background-color:##5CCCCC;text-align:right">#tlformat(gt_gunluk_satis_tutar)#</td>
                    <td style="background-color:##5CCCCC;text-align:right">#tlformat(gt_vade_total_ / ort_gp_count)#</td>
                    <td style="background-color:##5CCCCC;text-align:right">#tlformat(gt_ek_vade_ / ort_gp_count)#</td>
                    <td style="background-color:##FF8D40;text-align:right">#tlformat(gt_row_stock)#</td>
                    <td style="background-color:##696969;color:##ffffff;text-align:right">#tlformat(gt_eldeki_stock_tutar)#</td>
                    <td style="background-color:##FF8D40;text-align:right">#tlformat(gt_PURCHASE_ORDER_QUANTITY)#</td>
                    <td style="background-color:##696969;color:##ffffff;text-align:right">#tlformat(gt_PURCHASE_ORDER_TUTAR)#</td>
                    <td style="background-color:##FF8D40;text-align:right">#tlformat(gt_total_miktar_)#</td>
                    <td style="background-color:##000000;color:##ffffff;text-align:right">aaa#tlformat(gt_total_tutar_)#</td>
                    
                    <td style="background-color:##BFB130;text-align:right">#tlformat(gt_vade_gun_miktar_)#</td>
                    <td style="background-color:##BFB130;text-align:right">#tlformat(gt_ek_vade_gun_miktar_)#</td>
                    <td style="background-color:##BFB130;text-align:right">#tlformat(gt_total_vade_miktar_)#</td>
                    <td style="background-color:##696969;color:##ffffff;text-align:right">#tlformat(gt_vade_gun_tutar_)#</td>
                    <td style="background-color:##696969;color:##ffffff;text-align:right">#tlformat(gt_ek_vade_gun_tutar_)#</td>
                    <td style="background-color:##000000;color:##ffffff;text-align:right">#tlformat(gt_total_vade_tutar_)#</td>
                    <td style="background-color:##BFB130;text-align:right">#tlformat(gt_satici_limit_miktar_)#</td>
                    <td style="background-color:##BFB130;text-align:right">#tlformat(gt_satici_limit_tutar_)#</td>
                </tr>
            </cfoutput>
        </tfoot>
    </cf_medium_list>
</div>
<cfif isdefined("attributes.hierarchy")>
    <cfquery name="get_defines" datasource="#dsn_dev#">
        SELECT * FROM SEARCH_TABLES_DEFINES
    </cfquery>
    <cfquery name="get_cat" datasource="#dsn3#">
        SELECT PRODUCT_CAT FROM PRODUCT_CAT WHERE HIERARCHY = '#attributes.hierarchy#'
    </cfquery>
	<cfoutput>
    	<div id="ic_div_#attributes.group_no#"><span style="font-size:10px;color:###get_defines.group_font_color#">#get_cat.PRODUCT_CAT# : Stok + Sip Top. Tut. : #tlformat(gt_total_tutar_)# Max. Hedef Tut. VadeGün + EkVade Gün Tut. :#tlformat(gt_total_vade_tutar_)# Satıcı Limit Tutar : #tlformat(gt_satici_limit_tutar_)#</span></div>
    </cfoutput>
    <script>
		<cfoutput>
			try
			{
			document.getElementById('group_real_#attributes.group_no#').innerHTML = document.getElementById('ic_div_#attributes.group_no#').innerHTML;
			}
			catch(e)
			{
			//	
			}
		</cfoutput>
	</script>
</cfif>