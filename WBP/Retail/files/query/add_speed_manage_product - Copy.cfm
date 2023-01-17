

<cfset simdiki_zaman_ = now()>
&nbsp;&nbsp;&nbsp;Kayıt İşlemi Yapılıyor... Lütfen Bekleyiniz!<br /><br /> 
&nbsp;&nbsp;&nbsp;Tablo Bilgisi Yazılıyor... Lütfen Bekleyiniz!<br /><br /> 
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
            RECORD_DATE,
            RECORD_EMP
            )
       	VALUES
        	(
            <cfif isdefined("attributes.table_secret_code")>'#attributes.table_secret_code#'<cfelse>NULL</cfif>,
            '#attributes.table_code#',
            '#attributes.table_info#',
            #simdiki_zaman_#,
            #session.ep.userid#
            )
    </cfquery>
    <cfset attributes.table_id = max_id.IDENTITYCOL>
    <script>
		window.opener.document.search_product.table_code.value = '<cfoutput>#attributes.table_code#</cfoutput>';
		window.opener.document.info_form.table_code.value = '<cfoutput>#attributes.table_code#</cfoutput>';
	</script>
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
            TABLE_INFO = '#attributes.table_info#',
            UPDATE_DATE = #simdiki_zaman_#,
            UPDATE_EMP = #session.ep.userid#
        WHERE
        	TABLE_ID = #attributes.table_id#
    </cfquery>
</cfif>


<cfset attributes.changed_product_list = attributes.selected_product_list>


<cfif isdefined("attributes.delete_product_list") and len(attributes.delete_product_list)>
	<cfquery name="del_rows" datasource="#dsn_dev#">
        DELETE FROM 
            SEARCH_TABLES_ROWS 
        WHERE 
            TABLE_ID = #attributes.table_id# 
            AND PRODUCT_ID IN (#attributes.delete_product_list#)
    </cfquery>

    <cfquery name="del_rows" datasource="#dsn_dev#">
        DELETE FROM 
            SEARCH_TABLES_PRODUCTS 
        WHERE 
            TABLE_ID = #attributes.table_id# 
            AND PRODUCT_ID IN (#attributes.delete_product_list#)
    </cfquery>
    &nbsp;&nbsp;&nbsp;Tablodan Silinecek Ürünler Silindi. Lütfen Bekleyiniz!<br /><br /> 
</cfif>

<cfif isdefined("attributes.changed_product_list") and len(attributes.changed_product_list)>
	<cfset attributes.real_p_list = attributes.changed_product_list>
<cfelse>
	Hiç Bir Satır Seçmediniz! Ekranı Kapatıp Satır Seçiniz!
    <cfexit method="exittemplate">
</cfif>

&nbsp;&nbsp;&nbsp;Eski Bilgiler Siliniyor... Lütfen Bekleyiniz!<br /><br /> 

<cfquery name="del_rows" datasource="#dsn_dev#">
	DELETE FROM 
    	SEARCH_TABLES_ROWS 
    WHERE 
    	TABLE_ID = #attributes.table_id# 
		<cfif isdefined("attributes.changed_product_list") and len(attributes.changed_product_list)>
        	AND (PRODUCT_ID IN (#attributes.changed_product_list#) OR PRODUCT_ID IS NULL)
		<cfelseif listlen(attributes.all_product_list)>
        	AND (PRODUCT_ID IN (#attributes.all_product_list#) OR PRODUCT_ID IS NULL)
        </cfif>
</cfquery>

<cfquery name="del_rows" datasource="#dsn_dev#">
	DELETE FROM 
    	SEARCH_TABLES_PRODUCTS 
    WHERE 
        TABLE_ID = #attributes.table_id# 
		<cfif isdefined("attributes.changed_product_list") and len(attributes.changed_product_list)>
        	AND PRODUCT_ID IN (#attributes.changed_product_list#)
		<cfelseif listlen(attributes.all_product_list)>
        	AND PRODUCT_ID IN (#attributes.all_product_list#)
        </cfif>
</cfquery>

<cfquery name="del_rows" datasource="#dsn_dev#">
	DELETE FROM SEARCH_TABLES_DEPARTMENTS WHERE TABLE_ID = #attributes.table_id#
</cfquery>

<cfif not len(attributes.department_id_list)>
	<cfset attributes.department_id_list = 13>
</cfif>


&nbsp;&nbsp;&nbsp;Şube Bilgileri Yazılıyor... Lütfen Bekleyiniz!<br /><br /> 

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



<!---
<cfquery name="del_rows" datasource="#dsn_dev#">
	DELETE FROM PRICE_TABLE WHERE TABLE_ID = #attributes.table_id#
</cfquery>
--->

&nbsp;&nbsp;&nbsp;Satırlar Yazılıyor... Lütfen Bekleyiniz!<br /><br /> 


<cfset elemanlar_ = StructKeyList(attributes)>
<cfset uzunluk_ = listlen(elemanlar_)>
<cfset yazma_list = "real_p_list,REAL_P_LIST,ALL_PRODUCT_LIST,SELECTED_PRODUCT_LIST,FUSEACTION,IS_BASKET_HIDDEN,ADD_DEL_PRODUCT_NAME_TEXT,ALL_PRODUCT_LIST_ROW,DEPARTMENT_ID_LIST,FINISHDATE,TABLE_CODE,TABLE_ID,PRICE_TYPE_UPPER,STD_ROUND_NUMBER,IS_PURCHASE_TYPE,ONLY_TABLE_SAVE">


<cfset tarih_ = now()>

    <cfloop from="1" to="#uzunluk_#" index="ccc">
        <cfset eleman = listgetat(elemanlar_,ccc)>
        <cfset deger = evaluate("attributes.#eleman#")>
		
		<cfset replace_list = "order_date_1_,s_order_date_1_,lead_order_2_,order_date_2_,s_order_date_2_,stock_satis_amount_2_,stock_satis_amount_tutar_2_,stock_satis_amount_tutar_kdvli_2_,stock_satis_amount_koli_2_">
		<cfset replace_list_new = "orderdate1_,s_orderdate1_,lead_order2_,order_date2_,s_orderdate2_,stock_satis_amunt2_,stock_satis_amount_tutar2_,stock_satis_amount_tutar_kdvli2_,stock_satis_amount_koli2_">
        
        <cfset isim_ = lcase(eleman)>
        <cfset isim_ = replacelist(isim_,replace_list,replace_list_new)>
        
        <cfset uzunluk_ = listlen(isim_,'_')>
        
        <cfset pid_ = "">
        <cfloop from="1" to="#uzunluk_#" index="ccxc">
            <cfset ara_eleman_ = listgetat(isim_,ccxc,'_')>
            <cfif not len(pid_) and isnumeric(ara_eleman_)>
                <cfset pid_ = ara_eleman_>
            </cfif>
        </cfloop>
        <cfif len(pid_) and isnumeric(pid_)>
        	<cfset a_pid = pid_>
        <cfelse>
        	<cfset a_pid = 0>
        </cfif>	
        
		<cfif not listfindnocase(yazma_list,eleman) and not listfindnocase(yazma_list,ucase(eleman)) and a_pid neq 0 and listfindnocase(attributes.real_p_list,a_pid)>
            <cfif len(deger)>
                <cfstoredproc procedure="add_table_row" datasource="#DSN_DEV#">
                    <cfprocparam TYPE="IN" cfsqltype="cf_sql_integer" value="#attributes.table_id#">
                    <cfprocparam TYPE="IN" cfsqltype="cf_sql_text" value="#attributes.table_code#">
                    <cfprocparam TYPE="IN" cfsqltype="cf_sql_text" value="#eleman#">
                    <cfprocparam TYPE="IN" cfsqltype="cf_sql_text" value="#deger#">
                    <cfprocparam TYPE="IN" cfsqltype="cf_sql_integer" value="#a_pid#">
                </cfstoredproc>
            </cfif>
       	</cfif>
    </cfloop>
    
    
    <cfquery name="add_history" datasource="#dsn_dev#">
    	INSERT INTO
        	SEARCH_TABLES_ROWS_HISTORY
            (
            TABLE_ID,
            TABLE_CODE,
            ATT_NAME,
            ATT_VALUE,
            HISTORY_DATE
            )
          SELECT
          	TABLE_ID,
            TABLE_CODE,
            ATT_NAME,
            ATT_VALUE,
            #tarih_#
          FROM
          	SEARCH_TABLES_ROWS
          WHERE
          	TABLE_ID = #attributes.table_id#
    </cfquery>
	
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

<cfif isdefined("attributes.real_p_list") and len(attributes.real_p_list)>
    <cfloop list="#attributes.real_p_list#" index="cc">
    	<cfquery name="upd_product" datasource="#dsn1#">
            UPDATE 
                PRODUCT 
            SET 
                PRODUCT_NAME = '#wrk_eval("attributes.product_name_#cc#")#',
                IS_PURCHASE = <cfif isdefined("attributes.is_purchase_#cc#")>1<cfelse>0</cfif>,
                IS_PURCHASE_C = <cfif isdefined("attributes.is_purchase_c_#cc#")>1<cfelse>0</cfif>,
                IS_PURCHASE_M = <cfif isdefined("attributes.is_purchase_m_#cc#")>1<cfelse>0</cfif>,
                IS_SALES = <cfif isdefined("attributes.is_sales_#cc#")>1<cfelse>0</cfif>,
                UPDATE_EMP = #session.ep.userid#,
                UPDATE_DATE = #simdiki_zaman_#,
                UPDATE_IP = '#cgi.REMOTE_ADDR#'
            WHERE
                PRODUCT_ID = #CC#
        </cfquery>
        
        <cfset stock_list = evaluate("attributes.product_stock_list_#cc#")>
        <cfloop list="#stock_list#" index="stock_id_">
        	<cfset stock_adi_ = wrk_eval("attributes.stock_name_#CC#_#stock_id_#")>
            <cfquery name="get_stock_name" datasource="#dsn1#">
            	SELECT PROPERTY FROM STOCKS WHERE STOCK_ID = #stock_id_#
            </cfquery>
            <cfif get_stock_name.PROPERTY is not stock_adi_>
                <cfquery name="upd_" datasource="#dsn1#">
                    UPDATE
                        STOCKS
                    SET
                        PROPERTY = '#stock_adi_#',
                        UPDATE_DATE = #simdiki_zaman_#
                    WHERE
                        STOCK_ID = #stock_id_#
                </cfquery>
            </cfif>
        </cfloop>
    
    	<!--- standart alis fiyatlari duzenlenir --->
		<cfset startdate_ = evaluate("attributes.std_p_startdate_#cc#")>
        <cfif len(startdate_)>
            <CF_DATE tarih="startdate_">
        </cfif>
        <cfif len(startdate_) and datediff("n",startdate_,simdiki_zaman_) gt 0>
            <cfquery name="upd_" datasource="#dsn3#">
                UPDATE
                    PRICE_STANDART
                SET
                    PRICE = #filternum(evaluate("attributes.STANDART_ALIS_LISTE_#cc#"))#,
                    PRICE_KDV = #filternum(evaluate("attributes.STANDART_ALIS_KDVLI_#cc#"))#,
                    RECORD_DATE = #simdiki_zaman_#,
                    START_DATE = #startdate_#
                WHERE
                    PURCHASESALES = 0 AND
                    PRODUCT_ID = #CC#
            </cfquery>
       </cfif>  
    </cfloop>
</cfif>

<cfif not isdefined("attributes.only_table_save")>
&nbsp;&nbsp;&nbsp;Fiyatlar Yazılıyor... Lütfen Bekleyiniz!<br /><br />
	<cfif isdefined("attributes.real_p_list") and len(attributes.real_p_list)>
        <cfloop list="#attributes.real_p_list#" index="cc">
           <cfquery name="get_product_info" datasource="#dsn1#">
                SELECT
                    TAX,
                    TAX_PURCHASE
                FROM
                    PRODUCT
                WHERE
                    PRODUCT_ID = #CC#
            </cfquery>
            <!--- hemen gececek standart satis fiyatlari duzenlenir --->
			<cfif attributes.update_price_action neq 2 and isdefined("attributes.is_active_ss_#cc#")>
            	<cfset s_startdate_ = evaluate("attributes.std_s_startdate_#cc#")>
                <cfif len(s_startdate_)>
                    <CF_DATE tarih="s_startdate_">
                </cfif>
				<cfif len(s_startdate_) and isdate(s_startdate_) and datediff("n",s_startdate_,simdiki_zaman_) gt 0>
                    <cfquery name="upd_" datasource="#dsn3#">
                        UPDATE
                            PRICE_STANDART
                        SET
                            PRICE = #filternum(evaluate("attributes.READ_FIRST_SATIS_PRICE_#cc#"))#,
                            PRICE_KDV = #filternum(evaluate("attributes.READ_FIRST_SATIS_PRICE_KDV_#cc#"))#,
                            RECORD_DATE = #simdiki_zaman_#,
                            START_DATE = #s_startdate_#
                        WHERE
                            PURCHASESALES = 1 AND
                            PRODUCT_ID = #CC#
                    </cfquery>
                </cfif>
            </cfif>
            <!--- hemen gececek standart satis fiyatlari duzenlenir --->
			
            <!--- <cfif isdefined("attributes.is_active_ss_#cc#") and len(evaluate("attributes.std_s_startdate_#cc#")) and isdate(evaluate("attributes.std_s_startdate_#cc#"))> --->
                <cfset s_startdate_ = evaluate("attributes.std_s_startdate_#cc#")>
                <CF_DATE tarih="s_startdate_">
                
                <cfset p_startdate_ = evaluate("attributes.STD_P_STARTDATE_#cc#")>
                <cfif len(p_startdate_)>
                	<CF_DATE tarih="p_startdate_">
                </cfif>
                
                <cfset discount_manuel = evaluate('attributes.std_p_discount_manuel_#cc#')>
				<cfif len(discount_manuel)>
                    <cfset discount_manuel = filternum(discount_manuel,4)>
                <cfelse>
                    <cfset discount_manuel = 0>
                </cfif>
                <cfset discount_ilk = evaluate('attributes.std_sales_discount_#cc#')>
                
                <cfloop from="1" to="10" index="i">
                    <cfset 'discount#i#' = 0>
                </cfloop>
    
                <cfset i = 0>
                <cfloop list="#discount_ilk#" index="dis" delimiters="+">
                    <cfset i = i+1>
                    <cfset 'discount#i#' = filterNum(dis)>
                </cfloop>
                
                
                <cfquery name="add_" datasource="#dsn_dev#">
                    INSERT INTO
                    	PRICE_TABLE_STANDART
                       	(
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
                        RECORD_EMP
                        )
                   VALUES
                   		(
                         #attributes.table_id#,
                        '#attributes.table_code#',
                        <cfif len(p_startdate_)>#p_startdate_#<cfelse>NULL</cfif>,
                        <cfif len(evaluate("attributes.STANDART_ALIS_#cc#"))>#filternum(evaluate("attributes.STANDART_ALIS_#cc#"))#<cfelse>NULL</cfif>,
                        #discount1#,
                        #discount2#,
                        #discount3#,
                        #discount4#,
                        #discount5#,
                        #discount6#,
                        #discount7#,
                        #discount8#,
                        #discount9#,
                        #discount10#,
                        #discount_manuel#,
                        <cfif len(evaluate("attributes.STANDART_ALIS_LISTE_#cc#"))>#filternum(evaluate("attributes.STANDART_ALIS_LISTE_#cc#"))#<cfelse>NULL</cfif>,
                        <cfif len(evaluate("attributes.STANDART_ALIS_KDVLI_#cc#"))>#filternum(evaluate("attributes.STANDART_ALIS_KDVLI_#cc#"))#<cfelse>NULL</cfif>,
                        '#evaluate("attributes.STANDART_ALIS_PRICE_RATE_#cc#")#',
                        #s_startdate_#,
                        <cfif len(evaluate("attributes.S_PROFIT_#cc#"))>#filternum(evaluate("attributes.S_PROFIT_#cc#"))#<cfelse>NULL</cfif>,
                        <cfif len(evaluate("attributes.READ_FIRST_SATIS_PRICE_#cc#"))>#filternum(evaluate("attributes.READ_FIRST_SATIS_PRICE_#cc#"))#<cfelse>NULL</cfif>,
                        <cfif len(evaluate("attributes.READ_FIRST_SATIS_PRICE_KDV_#cc#"))>#filternum(evaluate("attributes.READ_FIRST_SATIS_PRICE_KDV_#cc#"))#<cfelse>NULL</cfif>,
                        '#evaluate("attributes.READ_FIRST_SATIS_PRICE_RATE_#cc#")#',
                        <cfif len(evaluate("attributes.P_PROFIT_#cc#"))>#filternum(evaluate("attributes.P_PROFIT_#cc#"))#<cfelse>NULL</cfif>,
                        <cfif attributes.update_price_action eq 2>0<cfelse><cfif isdefined("attributes.is_active_ss_#cc#")>1<cfelse>0</cfif></cfif>,
                        #CC#,
                        NULL,
                        #simdiki_zaman_#,
                        #session.ep.userid#
                        )
                </cfquery>
            <!--- </cfif> --->
			
			<cfif isdefined("attributes.is_selected_#cc#")>
            	<cfset fiyat_sayisi_ = evaluate('attributes.product_price_change_count_#cc#')>
                <cfif not len(fiyat_sayisi_)>
                	<cfset fiyat_sayisi_ = 0>
                </cfif>
                
                <cfif fiyat_sayisi_ gt 0>
                	<!--- coklu fiyat yaz --->
                    <cfset fiyat_list_ = evaluate('attributes.product_price_change_detail_#cc#')>
                    
                    <cfloop list="#fiyat_list_#" delimiters="*" index="fiyat_tumu">
                    	<cfset fiyat_satiri_ = fiyat_tumu>
                        <cfset fiyat_satiri_ = replace(fiyat_satiri_,';;',';0;','all')>
                        <cfset fiyat_satiri_ = replace(fiyat_satiri_,';;',';0;','all')>
                        
                        <cfloop from="1" to="#listlen(fiyat_satiri_,';')#" index="f_col">
                        	<cfset deger_ = listgetat(fiyat_satiri_,f_col,';')>
							<cfif f_col eq 2>
                            	<cfset 'attributes.price_type_#cc#' = deger_>
                            </cfif>
                            
                            <cfif f_col eq 3>
                            	<cfset 'attributes.NEW_ALIS_START_#cc#' = deger_>
                            </cfif>
                            
                            <cfif f_col eq 4>
                            	<cfset 'attributes.sales_discount_#cc#' = deger_>
                            </cfif>
                            
                            <cfif f_col eq 5>
                            	<cfset 'attributes.p_discount_manuel_#cc#' = deger_>
                            </cfif>
                            
                            <cfif f_col eq 6>
                            	<cfset 'attributes.NEW_ALIS_#cc#' = deger_>
                            </cfif>
                            
                            <cfif f_col eq 7>
                            	<cfset 'attributes.NEW_ALIS_KDVLI_#cc#' = deger_>
                            </cfif>
                            
                            <cfif f_col eq 8>
                            	<cfset 'attributes.p_startdate_#cc#' = deger_>
                            </cfif>
                            
                            <cfif f_col eq 9>
                            	<cfset 'attributes.p_finishdate_#cc#' = deger_>
                            </cfif>
                            
                            <cfif f_col eq 10>
                            	<cfset 'attributes.p_marj_#cc#' = deger_>
                            </cfif>
                            
                            <cfif f_col eq 11>
                            	<cfset 'attributes.is_active_p_#cc#' = deger_>
                            </cfif>
                            
                            <cfif f_col eq 12>
                            	<cfset 'attributes.FIRST_SATIS_PRICE_#cc#' = deger_>
                            </cfif>
                            
                            <cfif f_col eq 13>
                            	<cfset 'attributes.FIRST_SATIS_PRICE_KDV_#cc#' = deger_>
                            </cfif>
                            
                            <cfif f_col eq 14>
                            	<cfset 'attributes.READ_FIRST_SATIS_PRICE_RATE_#cc#' = deger_>
                            </cfif>
                            
                            <cfif f_col eq 15>
                            	<cfset 'attributes.p_ss_marj_#cc#' = deger_>
                            </cfif>
                            
                            <cfif f_col eq 16>
                            	<cfset 'attributes.startdate_#cc#' = deger_>
                            </cfif>
                            
                            <cfif f_col eq 17>
                            	<cfset 'attributes.finishdate_#cc#' = deger_>
                            </cfif>
                            
                            <cfif f_col eq 18>
                            	<cfset 'attributes.is_active_s_#cc#' = deger_>
                            </cfif>
                            
                            <cfif f_col eq 19>
                            	<cfset 'attributes.p_dueday_#cc#' = deger_>
                            </cfif>
                            
                            <cfif f_col eq 20>
                            	<cfset 'attributes.product_price_change_lastrowid_#cc#' = deger_>
                            </cfif>
                        </cfloop>

                        <cfinclude template="add_speed_manage_product_price.cfm">
                    </cfloop>
                    <!--- coklu fiyat yaz --->
                <cfelse>
            		<!--- tek fiyatı fiyat tablosu yaz --->
						<cfinclude template="add_speed_manage_product_price.cfm">
					<!--- tek fiyatı fiyat tablosu yaz --->
               	</cfif>
            </cfif>
        </cfloop>
    </cfif>
    <cfquery name="del_" datasource="#dsn_dev#">
    	DELETE FROM SEARCH_TABLES_ROWS WHERE TABLE_ID = #attributes.table_id# AND ATT_NAME LIKE '%PRODUCT_PRICE_CHANGE_DETAIL%'
    </cfquery>
    <cfquery name="upd_" datasource="#dsn_dev#">
    	UPDATE
        	SEARCH_TABLES_ROWS
        SET
        	ATT_VALUE = 0
        WHERE
        	TABLE_ID = #attributes.table_id# AND
            ATT_NAME LIKE '%PRODUCT_PRICE_CHANGE_COUNT%'
    </cfquery>
    <cfquery name="upd_" datasource="#dsn_dev#">
    	UPDATE
        	SEARCH_TABLES_ROWS
        SET
        	ATT_VALUE = 0
        WHERE
        	TABLE_ID = #attributes.table_id# AND
            ATT_NAME LIKE '%PRODUCT_PRICE_CHANGE_%'
    </cfquery>
</cfif>

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
    	YEAR(P_STARTDATE) IN (2014,2015) AND
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
    <hr />
</cfoutput>
&nbsp;&nbsp;<font color="red">İşlemler Bitti...</font><br /><br />