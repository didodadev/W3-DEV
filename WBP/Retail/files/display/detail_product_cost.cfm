<cfif not isdefined("attributes.stock_id") or attributes.stock_id eq 0>
	<cfquery name="get_name" datasource="#dsn3#">
        SELECT PRODUCT_NAME,STOCK_ID FROM STOCKS WHERE PRODUCT_ID = #attributes.product_id#
    </cfquery>
    <cfset stock_id = valuelist(get_name.stock_id)>
    <cfsavecontent variable="header_"><cfoutput>#get_name.PRODUCT_NAME#</cfoutput></cfsavecontent>
<cfelse>
	<cfquery name="get_name" datasource="#dsn1#">
        SELECT PROPERTY FROM STOCKS WHERE STOCK_ID = #stock_id#
    </cfquery>
    <cfsavecontent variable="header_"><cfoutput>#get_name.PROPERTY#</cfoutput></cfsavecontent>
</cfif>
<cf_popup_box title="Maliyet : #header_#">
<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
<cfset kasa_cikislar = "3,8,9,10,13">
<cfset kasa_cikis_olmayanlar = "2,4,5,12">
<cfset fazla_stok = "1">
    
<cfset attributes.yil = year(bugun_)>
<cfset attributes.ay = month(bugun_)>
<cfset attributes.gun = day(bugun_)>

<cfset tarih_ = createodbcdatetime(createdate(attributes.yil,attributes.ay,attributes.gun))>
<cfquery name="get_actions" datasource="#dsn2#">
SELECT
	TYPE,
	SUM(TOPLAM) AS G_TOTAL,
	ISLEM_TARIHI,
    ISNULL(
    	(
        	SELECT 
            	ISNULL(SUM(SR.STOCK_IN - SR.STOCK_OUT),0) AS MEVCUT_STOCK 
            FROM 
            	STOCKS_ROW SR 
            WHERE 
            	SR.STOCK_ID IN (#stock_id#) AND SR.PROCESS_DATE < T1.ISLEM_TARIHI),0) AS GUN_SONU_STOK
FROM
	(
		SELECT
			0 AS TYPE,
            SUM(SFR.AMOUNT) AS TOPLAM,
			SF.FIS_DATE AS ISLEM_TARIHI
		FROM
			STOCK_FIS SF,
			STOCK_FIS_ROW SFR
		WHERE 
            SF.FIS_ID = SFR.FIS_ID AND
			SF.FIS_TYPE = 114 AND
			SFR.STOCK_ID IN (#stock_id#) 
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
			SR.STOCK_ID IN (#stock_id#) 
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
<table>
<tr>
<td>
<cf_medium_list>
<thead>
	<tr>
    	<th>Sıra</th>
        <th nowrap="nowrap">İşlem Tipi</th>
        <th>Tarih</th>
        <th style="text-align:right;">Miktar</th>
        <th style="text-align:right;">Net Alış</th>
        <th style="text-align:right;">Toplam</th>
        <th style="text-align:right;">T. Miktar</th>
        <th style="text-align:right;">T. Toplam</th>
        <th style="text-align:right;">Gün Sonu Stok</th>
		<th style="text-align:right;">Ortalama Birim Maliyet</th>
    </tr>
</thead>
<tbody>
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
	<tr>
    	<td>#currentrow#</td>
        <td><cfif type eq 0>Devir<cfelse>İrsaliye</cfif></td>
        <td>#dateformat(ISLEM_TARIHI,'dd/mm/yyyy')#</td>
        <td style="text-align:right;">#G_TOTAL#</td>
        <td style="text-align:right;">#tlformat(ilk_deger_)#</td>
        <td style="text-align:right;">#tlformat(G_TOTAL * ilk_deger_)#</td>
        <td style="text-align:right;">#tlformat(miktar_toplam_,2)#</td>
        <td style="text-align:right;">#tlformat(tutar_toplam_,2)#</td>
        <td style="text-align:right;">#tlformat(GUN_SONU_STOK,2)#</td>
        <td style="text-align:right;">
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
        </td>
        <cfset last_maliyet_ = maliyet_>
    </tr>
	</cfoutput>
</tbody>
</cf_medium_list>
</td>
</tr>
</table>
<cfelse>
	<cfset maliyet_ = 0>
</cfif>
</cf_popup_box>