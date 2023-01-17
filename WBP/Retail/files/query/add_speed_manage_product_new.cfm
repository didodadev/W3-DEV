<cfflush>
<cfflush interval='100'>
<cfset baslama_ani = now()>
<cfset attributes.only_table_save = 1>
<cfparam name="attributes.print_note" default="">
<cfif isdefined("attributes.table_code") and len(attributes.table_code) neq 8>
	<cfset attributes.table_code = "">
</cfif>

<cfset standart_fiyat_yapildi = 0>

<cfset simdiki_zaman_ = now()>
<cfif not isdefined("attributes.table_code") or not len(attributes.table_code)>
    <cflock timeout="20">
        <cfquery name="get_table_no" datasource="#dsn_dev#">
            SELECT TABLE_NUMBER FROM SEARCH_TABLE_NO
        </cfquery>
        <cfset new_number = get_table_no.TABLE_NUMBER + 1>
        <cfquery name="upd_table_no" datasource="#dsn_dev#">
            UPDATE SEARCH_TABLE_NO SET TABLE_NUMBER = #new_number#
        </cfquery>
    </cflock>
    <cfset attributes.table_code = new_number>
    <cfloop from="1" to="#8-len(new_number)#" index="ccc">
    	<cfset attributes.table_code = "0" & attributes.table_code>
    </cfloop>
    
    <cfquery name="add_" datasource="#dsn_dev#" result="max_id">
    	INSERT INTO
        	SEARCH_TABLES
        	(
            TABLE_SECRET_CODE,
            TABLE_CODE,
            TABLE_INFO,
            IS_MAIN,
            RECORD_DATE,
            RECORD_EMP
            )
       	VALUES
        	(
            <cfif isdefined("attributes.table_secret_code")>'#attributes.table_secret_code#'<cfelse>NULL</cfif>,
            '#attributes.table_code#',
            '#attributes.table_info#',
            #attributes.is_main#,
            #simdiki_zaman_#,
            #session.ep.userid#
            )
    </cfquery>
    <cfset attributes.table_id = max_id.IDENTITYCOL>
<cfelse>
	<cfquery name="get_table_id" datasource="#dsn_dev#">
    	SELECT TABLE_ID FROM SEARCH_TABLES WHERE TABLE_CODE = '#attributes.table_code#'
    </cfquery>
    <cfset attributes.table_id = get_table_id.TABLE_ID>
    <cfquery name="upd_" datasource="#dsn_dev#">
    	UPDATE
        	SEARCH_TABLES
        SET
        	<cfif isdefined("attributes.table_secret_code")>TABLE_SECRET_CODE = '#attributes.table_secret_code#'<cfelse>NULL</cfif>,
            IS_MAIN = #attributes.is_main#,
            TABLE_INFO = '#attributes.table_info#',
            <cfif isdefined("session.ep.userid")>
            	UPDATE_EMP = #session.ep.userid#,
            <cfelse>
            	UPDATE_PAR = #session.pp.userid#,
            </cfif>
            UPDATE_DATE = #simdiki_zaman_#
        WHERE
        	TABLE_ID = #attributes.table_id#
    </cfquery>
</cfif>


<cfset attributes.changed_product_list = attributes.secili_urunler>
<cfset attributes.real_p_list = attributes.changed_product_list>

<cfquery name="del_rows" datasource="#dsn_dev#">
    DELETE FROM 
        SEARCH_TABLES_ROWS_NEW
    WHERE 
        TABLE_ID = #attributes.table_id# AND
        (PRODUCT_ID IN (#attributes.changed_product_list#) OR PRODUCT_ID IS NULL)
</cfquery>

<cfquery name="del_rows" datasource="#dsn_dev#">
	DELETE FROM 
    	SEARCH_TABLES_PRODUCTS 
    WHERE 
        TABLE_ID = #attributes.table_id# 
        AND
        PRODUCT_ID IN (#attributes.changed_product_list#)
</cfquery>

<cfquery name="del_rows" datasource="#dsn_dev#">
	DELETE FROM SEARCH_TABLES_DEPARTMENTS WHERE TABLE_ID = #attributes.table_id#
</cfquery>

<cfif not len(attributes.department_id_list)>
	<cfset attributes.department_id_list = 13>
</cfif>

<cfloop list="#attributes.department_id_list#" index="ddd">
    <cfquery name="add_" datasource="#dsn_dev#">
    	INSERT INTO
        	SEARCH_TABLES_DEPARTMENTS
            (
            TABLE_ID,
            TABLE_CODE,
            DEPARTMENT_ID
            )
            VALUES
            (
            #attributes.table_id#,
            '#attributes.table_code#',
            #ddd#
            )
    </cfquery>
</cfloop>

<cfset count_ = 0>
<cfloop list="#attributes.real_p_list#" index="ccc">
<cfset count_ = count_ + 1>
	<cfquery name="add_" datasource="#dsn_dev#">
        INSERT INTO
            SEARCH_TABLES_PRODUCTS
            (
            TABLE_ID,
            TABLE_CODE,
            PRODUCT_ID,
            LINE_NUMBER
            )
            VALUES
            (
            #attributes.table_id#,
            '#attributes.table_code#',
            #ccc#,
            #count_#
            )
    </cfquery>
</cfloop>

<cfif isdefined("attributes.basket")>
	<cfset new_basket = DeserializeJSON(attributes.basket)>
    <cfset satir_sayisi = form.ROWCOUNT>
<cfelse>
	<cfset new_basket = DeserializeJSON(attributes.print_note)>
    <cfset satir_sayisi = arraylen(new_basket)>
</cfif>


<cfset yazilmayacak_liste = "donem_satis,uid,list_price_kdv,siparis_tutar_1,siparis_tutar_2,siparis_tutar_kdv_1,siparis_tutar_kdv_2,c_is_standart_satis_aktif,sub_rows_count,product_price_change_count,product_price_change_detail,product_price_change_lastrowid,product_color,price_control,c_first_satis_price,c_new_alis_kdvli,order_code,ReportsTo,info_standart_alis,c_standart_satis,c_standart_satis_kdv,s_profit,barcode,product_code_r,is_purchase,is_purchase_c,is_purchase_m,is_sales,eski_standart_alis_kdvli,eski_standart_satis_kdvli,liste_oran,price_type,p_startdate,p_finishdate,new_alis_start,sales_discount,p_discount_manuel,new_alis,new_alis_kdvli,is_active_p,startdate,finishdate,first_satis_price,first_satis_price_kdv,is_active_s,maliyet,avg_rival,ortalama_satis_gunu,stok_yeterlilik_suresi,stok_devir_hizi,gun_total,genel_stok_tutar,stok_dagitim,urun_stok,depo_stok,magaza_stok,yoldaki_stok,carpan,carpan2,add_stock_gun,seviye_bilgisi,oneri_siparis,oneri_siparis2,alistan_maliyetli_marjli_fiyat,sira_no,product_cat,avantaj_oran,p_product_type">


<!---
<cfloop from="1" to="#satir_sayisi#" index="ccc">
	<cfset satir = new_basket[ccc]>
    <cfset key_list = StructKeyList(satir)>
    <cfset active_row_ = new_basket[ccc].active_row>
    
    <cfif active_row_ is true or active_row_ is 'true'>
    	<cfquery name="add_history" datasource="#dsn_dev#">
        <cfloop list="#key_list#" index="kkk">
            <cfif not listfind(yazilmayacak_liste,kkk)>
				<cfset deger_ = evaluate("new_basket[#ccc#].#kkk#")>
                    INSERT INTO
                        SEARCH_TABLES_ROWS_NEW
                        (
                        TABLE_ID,
                        TABLE_CODE,
                        ATT_NAME,
                        ATT_VALUE,
                        PRODUCT_CODE,
                        PRODUCT_ID
                        )
                        VALUES
                        (
                        #attributes.table_id#,
                        '#attributes.table_code#',
                        '#kkk#',
                        '#deger_#',
                        '#new_basket[ccc].product_code#',
                        #new_basket[ccc].ReportsTo#
                        )
          </cfif>
        </cfloop>
        </cfquery>
    </cfif>
</cfloop>
--->
<cfloop from="1" to="#satir_sayisi#" index="ccc">
	<cfset satir = new_basket[ccc]>
    <cfset key_list = StructKeyList(satir)>
    
    <cfloop list="#yazilmayacak_liste#" index="aaa">
        <cftry>
		<cfset sira_ = listfind(key_list,aaa)>
        <cfset key_list = listdeleteat(key_list,sira_)>
        <cfcatch type="any"></cfcatch>
        </cftry>
    </cfloop>
    
    <cfset active_row_ = new_basket[ccc].active_row>
    
    <cfif active_row_ is true or active_row_ is 'true'>
        <cfquery name="add_history" datasource="#dsn_dev#">
            INSERT INTO
                SEARCH_TABLES_ROWS_NEW
                (
                TABLE_ID,
                TABLE_CODE,
                ATT_NAME,
                ATT_VALUE,
                PRODUCT_CODE,
                PRODUCT_ID
                )
                VALUES
                <cfloop list="#key_list#" index="kkk">
                    <cfset deger_ = evaluate("new_basket[#ccc#].#kkk#")>
                    (
                    #attributes.table_id#,
                    '#attributes.table_code#',
                    '#kkk#',
                    '#deger_#',
                    '#new_basket[ccc].product_code#',
                    #new_basket[ccc].ReportsTo#
                    )
                    <cfif kkk neq listlast(key_list)>,</cfif>
                </cfloop>
        </cfquery>
    </cfif>
</cfloop>

<cfif isdefined("attributes.screen_wrk_id")>
	<cfset wrk_id = attributes.screen_wrk_id>
<cfelse>
    <cfquery name="get_table_no" datasource="#dsn_dev#">
        SELECT TABLE_CODE FROM SEARCH_TABLE_NO
    </cfquery>
    <cfset new_number = get_table_no.TABLE_CODE + 1>
    <cfquery name="upd_table_no" datasource="#dsn_dev#">
        UPDATE SEARCH_TABLE_NO SET TABLE_CODE = #new_number#
    </cfquery>
    
    <cfset wrk_id = new_number>
    <cfloop from="1" to="#8-len(new_number)#" index="ccc">
        <cfset wrk_id = "0" & wrk_id>
    </cfloop>
</cfif>


<cfloop from="1" to="#satir_sayisi#" index="ccc">
	<cfset satir_numarasi = ccc>
    <cfset product_id_ = new_basket[satir_numarasi].product_id>
    <cfset active_row_ = new_basket[satir_numarasi].active_row>
	<cfset row_type_ = new_basket[satir_numarasi].row_type>
    <cfset pname_ = new_basket[satir_numarasi].product_name>
    <cfset is_purchase_ = new_basket[satir_numarasi].is_purchase>
    <cfset is_purchase_c_ = new_basket[satir_numarasi].is_purchase_c>
    <cfset is_purchase_m_ = new_basket[satir_numarasi].is_purchase_m>
    <cfset is_sales_ = new_basket[satir_numarasi].is_sales>
    <cfset stock_count_ = new_basket[satir_numarasi].stock_count>
    <cfset stock_id_ = new_basket[satir_numarasi].stock_id>
    <cfset add_day_ = new_basket[satir_numarasi].add_stock_gun>
        
    <cfset s_startdate_ = new_basket[satir_numarasi].standart_satis_baslangic>
    <cfif len(s_startdate_) and s_startdate_ is not 'null' and  s_startdate_ contains 'T'>
		<cfset s_startdate_ = createodbcdatetime(createdate(listgetat(s_startdate_,1,'-'),listgetat(s_startdate_,2,'-'),left(listgetat(s_startdate_,3,'-'),2)))>
        <cfif not new_basket[satir_numarasi].standart_satis_baslangic contains 'T00:00'>
            <cfset s_startdate_ = dateadd('d',1,s_startdate_)>
        </cfif>
        <cfset s_startdate_ = dateformat(s_startdate_,'dd/mm/yyyy')>
    <cfelseif len(s_startdate_) and s_startdate_ is not 'null' and s_startdate_ contains '/'>
    	<cfset s_startdate_ = s_startdate_>
    </cfif>
    
    <cfset startdate_ = new_basket[satir_numarasi].standart_alis_baslangic>
    <cfif len(startdate_) and startdate_ is not 'null' and  startdate_ contains 'T'>
		<cfset startdate_ = createodbcdatetime(createdate(listgetat(startdate_,1,'-'),listgetat(startdate_,2,'-'),left(listgetat(startdate_,3,'-'),2)))>
        <cfif not new_basket[satir_numarasi].standart_alis_baslangic contains 'T00:00'>
            <cfset startdate_ = dateadd('d',1,startdate_)>
        </cfif>
        <cfset startdate_ = dateformat(startdate_,'dd/mm/yyyy')>
    <cfelseif len(startdate_) and startdate_ is not 'null' and  startdate_ contains '/'>
    	<cfset startdate_ = startdate_>
    </cfif>
    
    
    <cfset attributes.company_code = new_basket[satir_numarasi].company_code>
    <cftry>
    	<cfset attributes.price_type_id = new_basket[satir_numarasi].price_type_id>
    <cfcatch type="any">
    	<cfset attributes.price_type_id = ''>
    </cfcatch>
    </cftry>
    <cfset attributes.STANDART_ALIS_LISTE = new_basket[satir_numarasi].standart_alis_liste>
    <cfset attributes.STANDART_ALIS_KDVLI = new_basket[satir_numarasi].standart_alis_kdvli>
    
    <cfset attributes.TAX_PURCHASE = new_basket[satir_numarasi].standart_alis_kdv>
    <cfset attributes.TAX = new_basket[satir_numarasi].satis_kdv>
    
    <cfset attributes.READ_FIRST_SATIS_PRICE = new_basket[satir_numarasi].standart_satis>
    <cfset attributes.READ_FIRST_SATIS_PRICE_KDV = new_basket[satir_numarasi].standart_satis_kdv>
    
    <cfif row_type_ eq 1 and active_row_ is true>
    	<cfquery name="get_product_table" datasource="#dsn_dev#">
        	SELECT 
            	STP.TABLE_ID,
                STP.TABLE_CODE 
            FROM 
            	SEARCH_TABLES_PRODUCTS STP,
                SEARCH_TABLES ST
            WHERE
            	STP.PRODUCT_ID = #product_id_# AND
                STP.TABLE_ID = ST.TABLE_ID AND
                ST.IS_MAIN = 1
        </cfquery>
        
        <cfif get_product_table.recordcount>
        	<cfset attributes.p_table_id = get_product_table.TABLE_ID>
            <cfset attributes.p_table_code = get_product_table.TABLE_CODE>
        <cfelse>
        	<cfset attributes.p_table_id = attributes.TABLE_ID>
            <cfset attributes.p_table_code = attributes.TABLE_CODE>
        </cfif>
    
        <cfif isdefined("session.ep.userid")>
            <cfquery name="upd_product" datasource="#dsn1#">
                UPDATE 
                    PRODUCT 
                SET 
                    PRODUCT_NAME = '#pname_#',
                    IS_PURCHASE = <cfif is_purchase_ is true>1<cfelse>0</cfif>,
                    IS_PURCHASE_C = <cfif is_purchase_ is true><cfif is_purchase_c_ is true>1<cfelse>0</cfif><cfelse>0</cfif>,
                    IS_PURCHASE_M = <cfif is_purchase_ is true><cfif is_purchase_m_ is true>1<cfelse>0</cfif><cfelse>0</cfif>,
                    IS_SALES = <cfif is_sales_ is true>1<cfelse>0</cfif>,
                    <cfif is_sales_ is false and is_purchase_ is false>
                        PRODUCT_STATUS = 0,
                    <cfelse>
                    	PRODUCT_STATUS = 1,
                    </cfif>
                    ADD_STOCK_DAY = <cfif len(add_day_)>#add_day_#<cfelse>0</cfif>,
                    UPDATE_EMP = #session.ep.userid#,
                    UPDATE_DATE = #simdiki_zaman_#,
                    UPDATE_IP = '#cgi.REMOTE_ADDR#'
                WHERE
                    PRODUCT_ID = #product_id_#
            </cfquery>
            <cfif stock_count_ eq 1>
                <cfquery name="upd_" datasource="#dsn1#">
                    UPDATE
                        STOCKS
                    SET
                        STOCK_IS_PURCHASE = <cfif is_purchase_ is true>1<cfelse>0</cfif>,
                        STOCK_IS_PURCHASE_C = <cfif is_purchase_ is true><cfif is_purchase_c_ is true>1<cfelse>0</cfif><cfelse>0</cfif>,
                        STOCK_IS_PURCHASE_M = <cfif is_purchase_ is true><cfif is_purchase_m_ is true>1<cfelse>0</cfif><cfelse>0</cfif>,
                        STOCK_IS_SALES = <cfif is_sales_ is true>1<cfelse>0</cfif>,
                        PROPERTY = '#pname_#',
                        UPDATE_DATE = #simdiki_zaman_#
                    WHERE
                        PRODUCT_ID = #product_id_#
                </cfquery>
            </cfif>
        </cfif>
        
        <cfif len(startdate_) and startdate_ is not 'null'>
            <cf_date tarih = 'startdate_'>
        </cfif>

        <cfif len(startdate_) and year(startdate_) eq year(simdiki_zaman_) and month(startdate_) eq month(simdiki_zaman_) and day(startdate_) eq day(simdiki_zaman_)>
            <cfquery name="upd_" datasource="#dsn3#">
                UPDATE
                    PRICE_STANDART
                SET
                    PRICE = #new_basket[satir_numarasi].standart_alis_liste#,
                    PRICE_KDV = #new_basket[satir_numarasi].standart_alis_kdvli#,
                    RECORD_DATE = #simdiki_zaman_#,
                    START_DATE = #startdate_#
                WHERE
                    PURCHASESALES = 0 AND
                    PRODUCT_ID = #product_id_#
            </cfquery>
       	</cfif>
        
        <!--- hemen gececek standart satis fiyatlari duzenlenir --->
        <cfif len(s_startdate_) and s_startdate_ is not 'null'>
            <cf_date tarih = 's_startdate_'>
        </cfif>
        
		<cfset is_standart_satis_aktif_ = new_basket[satir_numarasi].is_standart_satis_aktif>
		<cfif attributes.update_price_action neq 2 and is_standart_satis_aktif_ is true>
            <cfif len(s_startdate_) and year(s_startdate_) eq year(simdiki_zaman_) and month(s_startdate_) eq month(simdiki_zaman_) and day(s_startdate_) eq day(simdiki_zaman_)>
                <cfquery name="upd_" datasource="#dsn3#">
                    UPDATE
                        PRICE_STANDART
                    SET
                        PRICE = #new_basket[satir_numarasi].standart_satis#,
                        PRICE_KDV = #new_basket[satir_numarasi].standart_satis_kdv#,
                        RECORD_DATE = #simdiki_zaman_#,
                        START_DATE = #s_startdate_#
                    WHERE
                        PURCHASESALES = 1 AND
                        PRODUCT_ID = #product_id_#
                </cfquery>
            </cfif>
        </cfif>
       <!--- hemen gececek standart satis fiyatlari duzenlenir --->
       
       <!--- standart fiyat tablosuna kayit at --->
	    <cfset discount_manuel = new_basket[satir_numarasi].standart_alis_indirim_tutar>
        <cfif not len(discount_manuel)>
            <cfset discount_manuel = 0>
        </cfif>
        
        <cfset discount_ilk = new_basket[satir_numarasi].standart_alis_indirim_yuzde>
        
        <cfloop from="1" to="10" index="i">
            <cfset 'discount#i#' = 0>
        </cfloop>

        <cfset i = 0>
        <cfloop list="#discount_ilk#" index="dis" delimiters="+">
            <cfset i = i+1>
            <cfset 'discount#i#' = filterNum(dis)>
        </cfloop>
        
        <cfquery name="get_cont_std" datasource="#dsn_dev#">
        	SELECT
            	*
            FROM
            	PRICE_TABLE_STANDART
            WHERE
            	PRODUCT_ID = #product_id_# AND
                TABLE_ID = #attributes.p_table_id# AND
                TABLE_CODE = '#attributes.p_table_code#' AND
                STANDART_ALIS_LISTE <cfif len(new_basket[satir_numarasi].standart_alis_liste)> = #new_basket[satir_numarasi].standart_alis_liste#<cfelse>IS NULL</cfif> AND
                READ_FIRST_SATIS_PRICE_KDV <cfif len(new_basket[satir_numarasi].standart_satis_kdv)> = #new_basket[satir_numarasi].standart_satis_kdv#<cfelse>IS NULL</cfif> AND
                STD_P_STARTDATE <cfif len(startdate_)> = #startdate_#<cfelse>IS NULL</cfif> AND
                STANDART_S_STARTDATE <cfif len(s_startdate_)> = #s_startdate_#<cfelse>IS NULL</cfif> AND
                IS_ACTIVE_S = <cfif attributes.update_price_action eq 2>0<cfelseif attributes.update_price_action eq 0>1<cfelse><cfif is_standart_satis_aktif_ is true>1<cfelse>0</cfif></cfif>
        </cfquery>
        
        <cfif not get_cont_std.recordcount>
        	<cfset standart_fiyat_yapildi = 1>
            <cfquery name="add_" datasource="#dsn_dev#">
                INSERT INTO
                    PRICE_TABLE_STANDART
                    (
                    WRK_ID,
                    INFO_S_DATE,
                    TABLE_ID,
                    TABLE_CODE,
                    STD_P_STARTDATE,
                    STANDART_ALIS,
                    STD_SALES_DISCOUNT1,
                    STD_SALES_DISCOUNT2,
                    STD_SALES_DISCOUNT3,
                    STD_SALES_DISCOUNT4,
                    STD_SALES_DISCOUNT5,
                    STD_SALES_DISCOUNT6,
                    STD_SALES_DISCOUNT7,
                    STD_SALES_DISCOUNT8,
                    STD_SALES_DISCOUNT9,
                    STD_SALES_DISCOUNT10,
                    STD_P_DISCOUNT_MANUEL,
                    STANDART_ALIS_LISTE,
                    STANDART_ALIS_KDVLI,
                    STANDART_ALIS_PRICE_RATE,
                    STANDART_S_STARTDATE,
                    S_PROFIT,
                    READ_FIRST_SATIS_PRICE,
                    READ_FIRST_SATIS_PRICE_KDV,
                    READ_FIRST_SATIS_PRICE_RATE,
                    P_PROFIT,
                    IS_ACTIVE_S,
                    PRODUCT_ID,
                    STOCK_ID,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_PAR
                    )
               VALUES
                    (
                    '#WRK_ID#',
                    '#new_basket[satir_numarasi].standart_alis_baslangic#',
                    #attributes.p_table_id#,
                    '#attributes.p_table_code#',
                    <cfif len(startdate_)>#startdate_#<cfelse>NULL</cfif>,
                    <cfif len(new_basket[satir_numarasi].standart_alis)>#new_basket[satir_numarasi].standart_alis#<cfelse>NULL</cfif>,
                    <cfif len(discount1)>#discount1#<cfelse>0</cfif>,
                    <cfif len(discount2)>#discount2#<cfelse>0</cfif>,
                    <cfif len(discount3)>#discount3#<cfelse>0</cfif>,
                    <cfif len(discount4)>#discount4#<cfelse>0</cfif>,
                    <cfif len(discount5)>#discount5#<cfelse>0</cfif>,
                    <cfif len(discount6)>#discount6#<cfelse>0</cfif>,
                    <cfif len(discount7)>#discount7#<cfelse>0</cfif>,
                    <cfif len(discount8)>#discount8#<cfelse>0</cfif>,
                    <cfif len(discount9)>#discount9#<cfelse>0</cfif>,
                    <cfif len(discount10)>#discount10#<cfelse>0</cfif>,
                    #discount_manuel#,
                    <cfif len(new_basket[satir_numarasi].standart_alis_liste)>#new_basket[satir_numarasi].standart_alis_liste#<cfelse>NULL</cfif>,
                    <cfif len(new_basket[satir_numarasi].standart_alis_kdvli)>#new_basket[satir_numarasi].standart_alis_kdvli#<cfelse>NULL</cfif>,
                    '#new_basket[satir_numarasi].standart_alis_oran#',
                    <cfif len(s_startdate_)>#s_startdate_#<cfelse>NULL</cfif>,
                    <cfif len(new_basket[satir_numarasi].standart_satis_kar)>#new_basket[satir_numarasi].standart_satis_kar#<cfelse>NULL</cfif>,
                    <cfif len(new_basket[satir_numarasi].standart_satis)>#new_basket[satir_numarasi].standart_satis#<cfelse>NULL</cfif>,
                    <cfif len(new_basket[satir_numarasi].standart_satis_kdv)>#new_basket[satir_numarasi].standart_satis_kdv#<cfelse>NULL</cfif>,
                    '#new_basket[satir_numarasi].standart_satis_oran#',
                    <cfif len(new_basket[satir_numarasi].standart_alis_kar)>#new_basket[satir_numarasi].standart_alis_kar#<cfelse>NULL</cfif>,
                    <cfif attributes.update_price_action eq 2>0<cfelseif attributes.update_price_action eq 0>1<cfelse><cfif is_standart_satis_aktif_ is true>1<cfelse>0</cfif></cfif>,
                    #product_id_#,
                    NULL,
                    #simdiki_zaman_#,
                    <cfif isdefined("session.ep.userid")>#session.ep.userid#<cfelse>NULL</cfif>,
                    <cfif isdefined("session.pp.userid")>#session.pp.userid#<cfelse>NULL</cfif>
                    )
            </cfquery>
      </cfif>
      <!--- standart fiyat tablosuna kayit at --->
    <cfelseif row_type_ eq 2 and (active_row_ is true or active_row_ is 'true')>
    	<cfquery name="upd_" datasource="#dsn1#">
            UPDATE
                STOCKS
            SET
                STOCK_IS_PURCHASE = <cfif is_purchase_ is true>1<cfelse>0</cfif>,
                STOCK_IS_PURCHASE_C = <cfif is_purchase_ is true><cfif is_purchase_c_ is true>1<cfelse>0</cfif><cfelse>0</cfif>,
                STOCK_IS_PURCHASE_M = <cfif is_purchase_ is true><cfif is_purchase_m_ is true>1<cfelse>0</cfif><cfelse>0</cfif>,
                STOCK_IS_SALES = <cfif is_sales_ is true>1<cfelse>0</cfif>,
                PROPERTY = '#pname_#',
                UPDATE_DATE = #simdiki_zaman_#
            WHERE
                STOCK_ID = #stock_id_#
        </cfquery>
    <cfelseif row_type_ eq 3 and (active_row_ is true or active_row_ is 'true') and listlen(attributes.department_id_list) eq 1>
    	<cfquery name="upd_" datasource="#dsn1#">
            UPDATE
                STOCKS
            SET
                STOCK_IS_PURCHASE = <cfif is_purchase_ is true>1<cfelse>0</cfif>,
                STOCK_IS_PURCHASE_C = <cfif is_purchase_ is true><cfif is_purchase_c_ is true>1<cfelse>0</cfif><cfelse>0</cfif>,
                STOCK_IS_PURCHASE_M = <cfif is_purchase_ is true><cfif is_purchase_m_ is true>1<cfelse>0</cfif><cfelse>0</cfif>,
                STOCK_IS_SALES = <cfif is_sales_ is true>1<cfelse>0</cfif>,
                PROPERTY = '#pname_#',
                UPDATE_DATE = #simdiki_zaman_#
            WHERE
                STOCK_ID = #stock_id_#
        </cfquery>
    </cfif>
</cfloop>

<cfset attributes.table_code_main = attributes.table_code>

<cfloop from="1" to="#satir_sayisi#" index="ccc">
	<cfset satir_numarasi = ccc>
    <cfset product_id_ = new_basket[satir_numarasi].product_id>
    <cfset active_row_ = new_basket[satir_numarasi].active_row>
	<cfset row_type_ = new_basket[satir_numarasi].row_type>
        
    <cftry>
    	<cfset attributes.price_type_id = new_basket[satir_numarasi].price_type_id>
        <cfset attributes.price_type = new_basket[satir_numarasi].price_type_id>
    <cfcatch type="any">
    	<cfset attributes.price_type_id = ''>
        <cfset attributes.price_type = ''>
    </cfcatch>
    </cftry>
    
    <cfset attributes.NEW_ALIS_START = new_basket[satir_numarasi].new_alis_start>
    <cfset attributes.sales_discount = new_basket[satir_numarasi].sales_discount>
    <cfset attributes.p_discount_manuel = new_basket[satir_numarasi].p_discount_manuel>
    <cfset attributes.NEW_ALIS = new_basket[satir_numarasi].new_alis>
    <cfset attributes.NEW_ALIS_KDVLI = new_basket[satir_numarasi].new_alis_kdvli>
    <cfset attributes.p_marj = new_basket[satir_numarasi].alis_kar>
    <cfset attributes.p_startdate = new_basket[satir_numarasi].p_startdate>
    <cfset attributes.p_finishdate = new_basket[satir_numarasi].p_finishdate>
    <cfset attributes.startdate = new_basket[satir_numarasi].startdate>
    <cfset attributes.finishdate = new_basket[satir_numarasi].finishdate> 
    <cfset attributes.is_active_p = new_basket[satir_numarasi].is_active_p>
    <cfset attributes.is_active_s = new_basket[satir_numarasi].is_active_s>
    <cfset attributes.p_dueday = new_basket[satir_numarasi].dueday>
    <cfset attributes.product_price_change_lastrowid = new_basket[satir_numarasi].product_price_change_lastrowid>
    <cfset attributes.FIRST_SATIS_PRICE = new_basket[satir_numarasi].first_satis_price>
    <cfset attributes.FIRST_SATIS_PRICE_KDV = new_basket[satir_numarasi].first_satis_price_kdv>
    <cfset attributes.READ_FIRST_SATIS_PRICE_RATE = new_basket[satir_numarasi].standart_satis_oran>
    <cfset attributes.p_ss_marj = new_basket[satir_numarasi].p_ss_marj>
    
    <cfset attributes.STANDART_ALIS_LISTE = new_basket[satir_numarasi].standart_alis_liste>
    <cfset attributes.STANDART_ALIS_KDVLI = new_basket[satir_numarasi].standart_alis_kdvli>
    
    <cfset attributes.TAX_PURCHASE = new_basket[satir_numarasi].standart_alis_kdv>
    <cfset attributes.TAX = new_basket[satir_numarasi].satis_kdv>
    
    <cfset attributes.READ_FIRST_SATIS_PRICE = new_basket[satir_numarasi].standart_satis>
    <cfset attributes.READ_FIRST_SATIS_PRICE_KDV = new_basket[satir_numarasi].standart_satis_kdv>
    
    <cfset attributes.p_product_type = new_basket[satir_numarasi].p_product_type>
    
    <cfif attributes.startdate is 'null'>
    	<cfset attributes.startdate = "">
    </cfif> 
    
	<cfif attributes.finishdate is 'null'>
    	<cfset attributes.finishdate = "">
    </cfif>
    
    <cfif attributes.p_startdate is 'null'>
    	<cfset attributes.p_startdate = "">
    </cfif> 
    
	<cfif attributes.p_finishdate is 'null'>
    	<cfset attributes.p_finishdate = "">
    </cfif>
    
    <cfif len(attributes.startdate) and attributes.startdate contains 'T'>
		<cfset attributes.startdate = createodbcdatetime(createdate(listgetat(attributes.startdate,1,'-'),listgetat(attributes.startdate,2,'-'),left(listgetat(attributes.startdate,3,'-'),2)))>
        <cfif not new_basket[satir_numarasi].startdate contains 'T00:00'>
            <cfset attributes.startdate = dateadd('d',1,attributes.startdate)>
        </cfif>
        <cfset attributes.startdate = dateformat(attributes.startdate,'dd/mm/yyyy')>
    <cfelseif len(attributes.startdate) and attributes.startdate contains '/'>
    	<cfset attributes.startdate = attributes.startdate>
    </cfif>
    
    <cfif len(attributes.finishdate) and attributes.finishdate contains 'T'>
		<cfset attributes.finishdate = createodbcdatetime(createdate(listgetat(attributes.finishdate,1,'-'),listgetat(attributes.finishdate,2,'-'),left(listgetat(attributes.finishdate,3,'-'),2)))>
        <cfif not new_basket[satir_numarasi].finishdate contains 'T00:00'>
            <cfset attributes.finishdate = dateadd('d',1,attributes.finishdate)>
        </cfif>
        <cfset attributes.finishdate = dateformat(attributes.finishdate,'dd/mm/yyyy')>
    <cfelseif len(attributes.finishdate) and attributes.finishdate contains '/'>
    	<cfset attributes.finishdate = attributes.finishdate>
    </cfif>
    
    <cfif len(attributes.p_startdate) and attributes.p_startdate contains 'T'>
		<cfset attributes.p_startdate = createodbcdatetime(createdate(listgetat(attributes.p_startdate,1,'-'),listgetat(attributes.p_startdate,2,'-'),left(listgetat(attributes.p_startdate,3,'-'),2)))>
        <cfif not new_basket[satir_numarasi].p_startdate contains 'T00:00'>
            <cfset attributes.p_startdate = dateadd('d',1,attributes.p_startdate)>
        </cfif>
        <cfset attributes.p_startdate = dateformat(attributes.p_startdate,'dd/mm/yyyy')>
    <cfelseif len(attributes.p_startdate) and attributes.p_startdate contains '/'>
    	<cfset attributes.p_startdate = attributes.p_startdate>
    </cfif>
    
    <cfif len(attributes.p_finishdate) and attributes.p_finishdate contains 'T'>
		<cfset attributes.p_finishdate = createodbcdatetime(createdate(listgetat(attributes.p_finishdate,1,'-'),listgetat(attributes.p_finishdate,2,'-'),left(listgetat(attributes.p_finishdate,3,'-'),2)))>
        <cfif not new_basket[satir_numarasi].p_finishdate contains 'T00:00'>
            <cfset attributes.p_finishdate = dateadd('d',1,attributes.p_finishdate)>
        </cfif>
        <cfset attributes.p_finishdate = dateformat(attributes.p_finishdate,'dd/mm/yyyy')>
    <cfelseif len(attributes.p_finishdate) and attributes.p_finishdate contains '/'>
    	<cfset attributes.p_finishdate = attributes.p_finishdate>
    </cfif>
    
    <cfif attributes.is_active_s is true>
    	<cfset attributes.is_active_s = 1>
    <cfelse>
    	<cfset attributes.is_active_s = 0>
    </cfif>
    
    <cfif attributes.is_active_p is true>
    	<cfset attributes.is_active_p = 1>
    <cfelse>
    	<cfset attributes.is_active_p = 0>
    </cfif>
    
    <cfif attributes.p_product_type is true>
    	<cfset attributes.p_product_type = 1>
    <cfelse>
    	<cfset attributes.p_product_type = 0>
    </cfif>
    
    <cfset attributes.price_departments = new_basket[satir_numarasi].price_departments>
    
	<cfif row_type_ eq 1 and active_row_ is true>
    	
    	<cfquery name="get_product_table" datasource="#dsn_dev#">
        	SELECT 
            	STP.TABLE_ID,
                STP.TABLE_CODE 
            FROM 
            	SEARCH_TABLES_PRODUCTS STP,
                SEARCH_TABLES ST
            WHERE
            	STP.PRODUCT_ID = #product_id_# AND
                STP.TABLE_ID = ST.TABLE_ID AND
                ST.IS_MAIN = 1
        </cfquery>
        
        <cfif get_product_table.recordcount>
        	<cfset attributes.p_table_id = get_product_table.TABLE_ID>
            <cfset attributes.p_table_code = get_product_table.TABLE_CODE>
        <cfelse>
        	<cfset attributes.p_table_id = attributes.TABLE_ID>
            <cfset attributes.p_table_code = attributes.TABLE_CODE>
        </cfif>
    
        <cfset fiyat_sayisi_ = new_basket[satir_numarasi].product_price_change_count>
        <cfif not len(fiyat_sayisi_)>
            <cfset fiyat_sayisi_ = 0>
        </cfif>
        
        <cfif attributes.update_price_action eq 1>
        	<cfset fiyat_sayisi_ = 0> 
        </cfif>
              
        <cfif fiyat_sayisi_ gt 0>
            <!--- coklu fiyat yaz --->
            <cfset fiyat_list_ = new_basket[satir_numarasi].product_price_change_detail>
            
            <cfloop list="#fiyat_list_#" delimiters="*" index="fiyat_tumu">
                <cfset fiyat_satiri_ = fiyat_tumu>
                <cfset fiyat_satiri_ = replace(fiyat_satiri_,';;',';0;','all')>
                <cfset fiyat_satiri_ = replace(fiyat_satiri_,';;',';0;','all')>
                
                <cfloop from="1" to="#listlen(fiyat_satiri_,';')#" index="f_col">
                    <cfset deger_ = listgetat(fiyat_satiri_,f_col,';')>
                    <cfif f_col eq 2>
                        <cfset attributes.price_type = deger_>
                    </cfif>
                    
                    <cfif f_col eq 3>
                        <cfset attributes.NEW_ALIS_START = deger_>
                    </cfif>
                    
                    <cfif f_col eq 4>
                        <cfset attributes.sales_discount = deger_>
                    </cfif>
                    
                    <cfif f_col eq 5>
                        <cfset attributes.p_discount_manuel = deger_>
                    </cfif>
                    
                    <cfif f_col eq 6>
                        <cfset attributes.NEW_ALIS = deger_>
                    </cfif>
                    
                    <cfif f_col eq 7>
                        <cfset attributes.NEW_ALIS_KDVLI = deger_>
                    </cfif>
                    
                    <cfif f_col eq 8>
                        <cfset attributes.p_startdate = deger_>
                    </cfif>
                    
                    <cfif f_col eq 9>
                        <cfset attributes.p_finishdate = deger_>
                    </cfif>
                    
                    <cfif f_col eq 10>
                        <cfset attributes.p_marj = deger_>
                    </cfif>
                    
                    <cfif f_col eq 11>
                        <cfset attributes.is_active_p = deger_>
                    </cfif>
                    
                    <cfif f_col eq 12>
                        <cfset attributes.FIRST_SATIS_PRICE = deger_>
                    </cfif>
                    
                    <cfif f_col eq 13>
                        <cfset attributes.FIRST_SATIS_PRICE_KDV = deger_>
                    </cfif>
                    
                    <cfif f_col eq 14>
                        <cfset attributes.READ_FIRST_SATIS_PRICE_RATE = deger_>
                    </cfif>
                    
                    <cfif f_col eq 15>
                        <cfset attributes.p_ss_marj = deger_>
                    </cfif>
                    
                    <cfif f_col eq 16>
                        <cfset attributes.startdate = deger_>
                    </cfif>
                    
                    <cfif f_col eq 17>
                        <cfset attributes.finishdate = deger_>
                    </cfif>
                    
                    <cfif f_col eq 18>
                        <cfset attributes.is_active_s = deger_>
                    </cfif>
                    
                    <cfif f_col eq 19>
                        <cfset attributes.p_dueday = deger_>
                    </cfif>
                    
                    <cfif f_col eq 20>
                        <cfset attributes.price_departments = deger_>
                    </cfif>
                    
                    <cfif f_col eq 21>
                        <cfset attributes.p_product_type = deger_>
                    </cfif>
                    
                    <cfif f_col eq 22>
                        <cfset attributes.product_price_change_lastrowid = deger_>
                    </cfif>
                </cfloop>
    
                <cfinclude template="add_speed_manage_product_price_new.cfm">
            </cfloop>
            <!--- coklu fiyat yaz --->
        <cfelse>
            <!--- tek fiyatı fiyat tablosu yaz --->
                <cfinclude template="add_speed_manage_product_price_new.cfm">
            <!--- tek fiyatı fiyat tablosu yaz --->
        </cfif>
    </cfif>
</cfloop>

<cfquery name="get_price_codes" datasource="#dsn_dev#">
	SELECT DISTINCT
        ISNULL(PRICE_TYPE,0) AS PRICE_TYPE,
        STARTDATE,
        FINISHDATE,
        P_STARTDATE,
        P_FINISHDATE,
        TABLE_CODE,
        RECORD_DATE
   	FROM 
    	PRICE_TABLE 
    WHERE 
    	YEAR(P_STARTDATE) > 2014 AND
        P_STARTDATE IS NOT NULL AND
        P_FINISHDATE IS NOT NULL AND
        STARTDATE IS NOT NULL AND
        FINISHDATE IS NOT NULL AND
        (ACTION_CODE IS NULL OR ACTION_CODE = '')
</cfquery>

<cfoutput query="get_price_codes">
   	<cfquery name="get_table_no" datasource="#dsn_dev#">
        SELECT TABLE_CODE FROM SEARCH_TABLE_NO
    </cfquery>
    <cfset new_number = get_table_no.TABLE_CODE + 1>
    <cfquery name="upd_table_no" datasource="#dsn_dev#">
        UPDATE SEARCH_TABLE_NO SET TABLE_CODE = #new_number#
    </cfquery>
    
    <cfset attributes.table_code = new_number>
    <cfloop from="1" to="#8-len(new_number)#" index="ccc">
    	<cfset attributes.table_code = "0" & attributes.table_code>
    </cfloop>
    
    <cfquery name="upd_" datasource="#dsn_dev#">
    	UPDATE
        	PRICE_TABLE
        SET
        	ACTION_CODE = '#attributes.table_code#'
        WHERE
        	RECORD_DATE = #CREATEODBCDATETIME(RECORD_DATE)# AND 
            ISNULL(PRICE_TYPE,0) = #PRICE_TYPE# AND
            P_STARTDATE = #CREATEODBCDATETIME(P_STARTDATE)# AND
            P_FINISHDATE = #CREATEODBCDATETIME(P_FINISHDATE)# AND
            STARTDATE = #CREATEODBCDATETIME(STARTDATE)# AND
            FINISHDATE = #CREATEODBCDATETIME(FINISHDATE)# AND
            TABLE_CODE = '#get_price_codes.TABLE_CODE#'
    </cfquery>
</cfoutput>

<cfquery name="get_this_rows" datasource="#dsn_dev#">
	SELECT DISTINCT ACTION_CODE FROM PRICE_TABLE WHERE WRK_ID = '#wrk_id#'
</cfquery>
<cfif isdefined("attributes.basket")>
	<cfif get_this_rows.recordcount>
        <cfoutput>#attributes.table_code_main#*#valuelist(get_this_rows.ACTION_CODE,'+')#</cfoutput>
    <cfelse>
        <cfoutput>#attributes.table_code_main#</cfoutput>
    </cfif>
<cfelse>
	<cf_popup_box title="İşlem Durumu (Tablo Kodu : #attributes.table_code_main#)">
    	<table width="100%">
        <tr>
        <td style="text-align:center;">
        <br />
        <cfif standart_fiyat_yapildi eq 1 or get_this_rows.recordcount or attributes.update_price_action eq 1>
        	<font color="green" style="font-size:16px;font-weight:bold;">İşlemler Tamamlandı!</font>
        <cfelse>
        	<font color="blue" style="font-size:16px;font-weight:bold;">Liste Kayıt Edildi! Ancak Herhangi Bir Fiyat Kayıt Edilmedi!</font>
        </cfif>
        <br /><br />
        <cfif get_this_rows.recordcount>
        	<br /><b>Ana İşlem Kodu : <i><cfoutput>#wrk_id#</cfoutput></i></b><br />
        	<br><b>İşlem Kodları:</b><br />
            <cfoutput query="get_this_rows">
            	#ACTION_CODE#<br />
            </cfoutput>
            <cfquery name="get_this_products" datasource="#dsn_dev#">
                SELECT ROW_ID,PRODUCT_ID,STOCK_ID FROM PRICE_TABLE WHERE WRK_ID = '#wrk_id#' ORDER BY ROW_ID DESC
            </cfquery>
            <cfset p_list = "">
            <cfset row_list = "">
            
            <cfoutput query="get_this_products">
            	<cfif not listfind(p_list,PRODUCT_ID)>
                	<cfset p_list = listappend(p_list,PRODUCT_ID)>
                    <cfset row_list = listappend(row_list,ROW_ID)>
                </cfif>
            </cfoutput>
            
            <script>
				function list_find(listem,degerim,delim)
				{
					var kontrol=0;
					if(!delim) delim = ',';
					var listem_1=listem.split(delim);
					for (var m=0; m < listem_1.length; m++)
						if(listem_1[m]==degerim)
						{
							kontrol=1;
							break;
						}
					if(kontrol) 
						return m+1; 
					else 
						return 0;
				}
				
				function list_getat(gelen_,number,delim_)
				/* cf deki listgetat in javascript hali*/
				/*Düzenleme 20060405 */
				{
					if(!delim_) delim_ = ',';	
					gelen_1=gelen_.split(delim_);
				
					if((gelen_.length == 0) || (number > gelen_1.length) || (number < 1))
						return '';
					else
						return gelen_1[number-1];
				}
				
				p_list_ = '<cfoutput>#p_list#</cfoutput>';
				row_list_ = '<cfoutput>#row_list#</cfoutput>';
				
				var rows = window.opener.$('#jqxgrid').jqxGrid('getboundrows');
				var eleman_sayisi = rows.length;
				
				for (var m=0; m < eleman_sayisi; m++)
				{
					pid_ = rows[m].product_id;
					if((rows[m].active_row == true || rows[m].active_row == 'true') && rows[m].row_type == '1' && list_find(p_list_,pid_))
					{
						sira_ = list_find(p_list_,pid_);
						rows[m].product_price_change_lastrowid = list_getat(row_list_,sira_);	
					}
				}
				window.opener.$("#jqxgrid").jqxGrid('applyfilters');
			</script>
        <cfelse>
        	<cfif attributes.update_price_action eq 1>
            	Fiyat Düzenlemeleri Yapıldı!
            <cfelse>
            	<font color="red">Özel Fiyatlandırma Yapılmadı!</font>
            </cfif>
        </cfif>
        <cfif standart_fiyat_yapildi eq 1>
        	<br /><br />Standart Fiyatlandırma Yapıldı!
            <!--- fiyat guncelleme --->
            <cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
			<cfset zaman_ = dateadd('h',2,bugun_)>
            <cfset gun_ = day(zaman_)>
            <cfset ay_ = month(zaman_)>
            <cfset yil_ = year(zaman_)>
            
            <cfloop from="1" to="0" index="day1" step="-1">
            <cfset zaman_ = dateadd('h',2,bugun_)>
            <cfset zaman_ = dateadd('d',-1*day1,zaman_)>
            <cfset gun_ = day(zaman_)>
            <cfset ay_ = month(zaman_)>
            <cfset yil_ = year(zaman_)>
                <cfquery name="get_today_prices_alis" datasource="#dsn_dev#">
                    SELECT
                        *
                    FROM
                        PRICE_TABLE_STANDART
                    WHERE
                        YEAR(STD_P_STARTDATE) = #yil_# AND
                        MONTH(STD_P_STARTDATE) = #ay_# AND
                        DAY(STD_P_STARTDATE) = #gun_# AND
                        STANDART_ALIS_LISTE IS NOT NULL AND
                        STANDART_ALIS_KDVLI IS NOT NULL
                    ORDER BY RECORD_DATE ASC
                </cfquery>
                
                <cfoutput query="get_today_prices_alis">
                    <cfquery name="upd_" datasource="#dsn3#">
                        UPDATE
                            PRICE_STANDART
                        SET
                            START_DATE = #createodbcdatetime(createdate(yil_,ay_,gun_))#,
                            PRICE = #STANDART_ALIS_LISTE#,
                            PRICE_KDV = #STANDART_ALIS_KDVLI#,
                            RECORD_DATE = #now()#
                        WHERE
                            PURCHASESALES = 0 AND
                            PRICESTANDART_STATUS = 1 AND
                            PRODUCT_ID = #PRODUCT_ID#
                    </cfquery>
                </cfoutput>
                
                
                <cfquery name="get_today_prices_satis" datasource="#dsn_dev#">
                    SELECT
                        *
                    FROM
                        PRICE_TABLE_STANDART
                    WHERE
                        YEAR(STANDART_S_STARTDATE) = #yil_# AND
                        MONTH(STANDART_S_STARTDATE) = #ay_# AND
                        DAY(STANDART_S_STARTDATE) = #gun_# AND
                        IS_ACTIVE_S = 1 AND
                        STANDART_ALIS_LISTE IS NOT NULL AND
                        STANDART_ALIS_KDVLI IS NOT NULL AND
                        READ_FIRST_SATIS_PRICE_KDV IS NOT NULL AND
                        READ_FIRST_SATIS_PRICE > 0
                    ORDER BY RECORD_DATE ASC
                </cfquery>
                
                <cfoutput query="get_today_prices_satis">
                    <cfquery name="upd_" datasource="#dsn3#">
                        UPDATE
                            PRICE_STANDART
                        SET
                            START_DATE = #createodbcdatetime(createdate(yil_,ay_,gun_))#,
                            PRICE = #READ_FIRST_SATIS_PRICE#,
                            PRICE_KDV = #READ_FIRST_SATIS_PRICE_KDV#,
                            RECORD_DATE = #now()#
                        WHERE
                            PURCHASESALES = 1 AND
                            PRICESTANDART_STATUS = 1 AND
                            PRODUCT_ID = #PRODUCT_ID#
                    </cfquery>
                </cfoutput>
            </cfloop>
            <!--- fiyat guncelleme --->
        <cfelse>
        	<br /><br /><font color="red">Standart Fiyatlandırma Yapılmadı!</font>
        </cfif>
        
        <br />
        <!---
        İşlemlerin Başlama Anı : <cfoutput>#baslama_ani#</cfoutput> <br />
        İşlemlerin Tamamlanma Anı : <cfoutput>#now()#</cfoutput>
		--->
        <script>
			window.opener.document.search_product.table_code.value = '<cfoutput>#attributes.table_code_main#</cfoutput>';
			window.opener.document.info_form.inner_table_code.value = '<cfoutput>#attributes.table_code_main#</cfoutput>';
		</script>
        </td>
        </tr>
        </table>
    </cf_popup_box>
</cfif>