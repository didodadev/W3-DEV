<!--- fiyat düzenleme kodu --->
<cfquery name="get_orders" datasource="#dsn3#" result="aaa">
	SELECT
    	ISNULL((
            SELECT TOP 1
                PTS.STANDART_ALIS_LISTE
            FROM
                #dsn_dev#.PRICE_TABLE_STANDART PTS
            WHERE
                PTS.STD_P_STARTDATE <= O.ORDER_DATE AND
                PTS.PRODUCT_ID = ORR.PRODUCT_ID
            ORDER BY
                PTS.STD_P_STARTDATE DESC,
                PTS.ROW_ID DESC,
                PTS.STANDART_ALIS ASC
        ),9999) AS OGUNKU_STANDART_FIYAT,
        ISNULL((
            SELECT TOP 1
                PTS.ROW_ID
            FROM
                #dsn_dev#.PRICE_TABLE_STANDART PTS
            WHERE
                PTS.STD_P_STARTDATE <= O.ORDER_DATE AND
                PTS.PRODUCT_ID = ORR.PRODUCT_ID
            ORDER BY
                PTS.STD_P_STARTDATE DESC,
                PTS.ROW_ID DESC,
                PTS.STANDART_ALIS ASC
        ),-1) AS OGUNKU_STANDART_LISTE_ID,
        ROUND(PS.PRICE,4) AS AKTIF_STANDART_FIYAT,
        ISNULL(( 
            SELECT TOP 1 
                PT1.NEW_ALIS
            FROM
                #dsn_dev#.PRICE_TABLE PT1
            WHERE
                PT1.PRICE_TYPE NOT IN (#kasa_cikislar#) AND
                PT1.IS_ACTIVE_P = 1 AND
                PT1.P_STARTDATE <= O.ORDER_DATE AND 
                DATEADD("d",-1,PT1.P_FINISHDATE) >= O.ORDER_DATE AND
                (PT1.STOCK_ID = ORR.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = ORR.PRODUCT_ID))
            ORDER BY
                PT1.STARTDATE DESC,
                PT1.ROW_ID DESC
        ),9999) AS LISTE_FIYATI,
        ISNULL(( 
            SELECT TOP 1 
                PT1.ROW_ID
            FROM
                #dsn_dev#.PRICE_TABLE PT1
            WHERE
                 PT1.PRICE_TYPE NOT IN (#kasa_cikislar#) AND
                PT1.IS_ACTIVE_P = 1 AND
                PT1.P_STARTDATE <= O.ORDER_DATE AND 
                DATEADD("d",-1,PT1.P_FINISHDATE) >= O.ORDER_DATE AND
                (PT1.STOCK_ID = ORR.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = ORR.PRODUCT_ID))
            ORDER BY
                PT1.STARTDATE DESC,
                PT1.ROW_ID DESC
        ),-1) AS LISTE_ID,
        O.ORDER_DATE,
        ORR.*
    FROM
    	ORDERS O,
        ORDER_ROW ORR,
        PRICE_STANDART PS
    WHERE
        O.ORDER_ID IN (#order_id_list#) AND
        PS.PRODUCT_ID = ORR.PRODUCT_ID AND
        PS.PURCHASESALES = 0 AND
        PS.PRICESTANDART_STATUS = 1 AND
        O.ORDER_ID = ORR.ORDER_ID
</cfquery>

<cfoutput query="get_orders">
	<cfset order_row_id_ = get_orders.order_row_id>
    <cfset quantity_ = get_orders.quantity>
    <cfset ogun_s_list_id_ = get_orders.OGUNKU_STANDART_LISTE_ID>
    <cfset list_id_ = get_orders.LISTE_ID>
    
    <cfset ilk_deger_ = 0>
    <cfset ilk_deger_type = -1>
    
	<cfif OGUNKU_STANDART_FIYAT lt 9999>
    	<cfset ilk_deger_ = OGUNKU_STANDART_FIYAT>
        <cfset liste_id_ = -1 * OGUNKU_STANDART_LISTE_ID>
    </cfif>
	<cfif LISTE_FIYATI lt 9999 and LISTE_FIYATI lt OGUNKU_STANDART_FIYAT>
    	<cfset ilk_deger_ = LISTE_FIYATI>
        <cfset liste_id_ = LISTE_ID>
    </cfif>
    <cfif OGUNKU_STANDART_FIYAT eq 9999 and LISTE_FIYATI eq 9999>
    	<cfset ilk_deger_ = AKTIF_STANDART_FIYAT>
        <cfset liste_id_ = 0>
    </cfif>
    
    <cfloop from="1" to="10" index="i">
		<cfset 'a_discount_#i#' = 0>
    </cfloop>
    <cfset discount_manuel = 0>
    
    <cfif liste_id_ eq 0>
    	<cfset price_ = AKTIF_STANDART_FIYAT>
        <cfset price_other_ = AKTIF_STANDART_FIYAT>
        <cfset nettotal_ = price_ * quantity_>
        <cfset other_money_value_ = price_ * quantity_>
    <cfelseif liste_id_ lt 0>
    	<cfquery name="get_price_std" datasource="#dsn_dev#">
        	SELECT * FROM PRICE_TABLE_STANDART WHERE ROW_ID = #-1 * liste_id_#
        </cfquery>

        <cfset price_ = get_price_std.STANDART_ALIS>
        <cfset price_other_ = get_price_std.STANDART_ALIS>
        <cfset nettotal_ = get_price_std.STANDART_ALIS_LISTE * quantity_>
        <cfset other_money_value_ = get_price_std.STANDART_ALIS_LISTE * quantity_>
        
        <cfif len(get_price_std.STD_SALES_DISCOUNT1)><cfset a_discount_1 = get_price_std.STD_SALES_DISCOUNT1></cfif>
        <cfif len(get_price_std.STD_SALES_DISCOUNT2)><cfset a_discount_2 = get_price_std.STD_SALES_DISCOUNT2></cfif>
        <cfif len(get_price_std.STD_SALES_DISCOUNT3)><cfset a_discount_3 = get_price_std.STD_SALES_DISCOUNT3></cfif>
        <cfif len(get_price_std.STD_SALES_DISCOUNT4)><cfset a_discount_4 = get_price_std.STD_SALES_DISCOUNT4></cfif>
        <cfif len(get_price_std.STD_SALES_DISCOUNT5)><cfset a_discount_5 = get_price_std.STD_SALES_DISCOUNT5></cfif>
        <cfif len(get_price_std.STD_SALES_DISCOUNT6)><cfset a_discount_6 = get_price_std.STD_SALES_DISCOUNT6></cfif>
        <cfif len(get_price_std.STD_SALES_DISCOUNT7)><cfset a_discount_7 = get_price_std.STD_SALES_DISCOUNT7></cfif>
        <cfif len(get_price_std.STD_SALES_DISCOUNT8)><cfset a_discount_8 = get_price_std.STD_SALES_DISCOUNT8></cfif>
        <cfif len(get_price_std.STD_SALES_DISCOUNT9)><cfset a_discount_9 = get_price_std.STD_SALES_DISCOUNT9></cfif>
        <cfif len(get_price_std.STD_SALES_DISCOUNT10)><cfset a_discount_10 = get_price_std.STD_SALES_DISCOUNT10></cfif>
        <cfif len(get_price_std.STD_P_DISCOUNT_MANUEL)><cfset discount_manuel = get_price_std.STD_P_DISCOUNT_MANUEL></cfif>
    <cfelse>
    	<cfquery name="get_price_t" datasource="#dsn_dev#">
        	SELECT * FROM PRICE_TABLE WHERE ROW_ID = #list_id_#
        </cfquery>
        
        <cfset price_ = get_price_t.BRUT_ALIS>
        <cfset price_other_ = get_price_t.BRUT_ALIS>
        <cfset nettotal_ = get_price_t.NEW_ALIS * quantity_>
        <cfset other_money_value_ = get_price_t.NEW_ALIS * quantity_>
        
        <cfif len(get_price_t.DISCOUNT1)><cfset a_discount_1 = get_price_t.DISCOUNT1></cfif>
        <cfif len(get_price_t.DISCOUNT2)><cfset a_discount_2 = get_price_t.DISCOUNT2></cfif>
        <cfif len(get_price_t.DISCOUNT3)><cfset a_discount_3 = get_price_t.DISCOUNT3></cfif>
        <cfif len(get_price_t.DISCOUNT4)><cfset a_discount_4 = get_price_t.DISCOUNT4></cfif>
        <cfif len(get_price_t.DISCOUNT5)><cfset a_discount_5 = get_price_t.DISCOUNT5></cfif>
        <cfif len(get_price_t.DISCOUNT6)><cfset a_discount_6 = get_price_t.DISCOUNT6></cfif>
        <cfif len(get_price_t.DISCOUNT7)><cfset a_discount_7 = get_price_t.DISCOUNT7></cfif>
        <cfif len(get_price_t.DISCOUNT8)><cfset a_discount_8 = get_price_t.DISCOUNT8></cfif>
        <cfif len(get_price_t.DISCOUNT9)><cfset a_discount_9 = get_price_t.DISCOUNT9></cfif>
        <cfif len(get_price_t.DISCOUNT10)><cfset a_discount_10 = get_price_t.DISCOUNT10></cfif>
        <cfif len(get_price_t.MANUEL_DISCOUNT)><cfset discount_manuel = get_price_t.MANUEL_DISCOUNT></cfif>
    </cfif>
    
    
    
    <cfquery name="updcc1_" datasource="#dsn3#" result="aaa">
    	UPDATE
        	ORDER_ROW
        SET
        	PRICE = #price_#,
            PRICE_OTHER = #price_other_#,
            NETTOTAL = #nettotal_#,
            OTHER_MONEY_VALUE = #other_money_value_#,
            DISCOUNT_1 = #a_discount_1#,
            DISCOUNT_2 = #a_discount_2#,
            DISCOUNT_3 = #a_discount_3#,
            DISCOUNT_4 = #a_discount_4#,
            DISCOUNT_5 = #a_discount_5#,
            DISCOUNT_6 = #a_discount_6#,
            DISCOUNT_7 = #a_discount_7#,
            DISCOUNT_8 = #a_discount_8#,
            DISCOUNT_9 = #a_discount_9#,
            DISCOUNT_10 = #a_discount_10#,
            DISCOUNT_COST = #discount_manuel#
        WHERE
        	ORDER_ROW_ID = #order_row_id_#
    </cfquery>
</cfoutput>
<!--- fiyat düzenleme kodu --->