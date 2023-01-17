<cfparam name="attributes.hierarchy1" default="">
<cfparam name="attributes.hierarchy2" default="">
<cfparam name="attributes.hierarchy3" default="">
<cfparam name="attributes.uretici" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.size_type" default="">
<cfparam name="attributes.report_type" default="1">
<cfparam name="attributes.regions" default="1">
<cfparam name="attributes.siralama" default="1">
<cfparam name="attributes.siralama_tipi" default="1">
<cfparam name="attributes.search_department_id" default="">
<cfparam name="attributes.limit" default="0">

<cfquery name="get_departments_search" datasource="#dsn#">
	SELECT 
    	DEPARTMENT_ID,DEPARTMENT_HEAD 
    FROM 
    	DEPARTMENT D
    WHERE
    	D.IS_STORE IN (1,3) AND
        ISNULL(D.IS_PRODUCTION,0) = 0
    ORDER BY 
    	DEPARTMENT_HEAD
</cfquery>

<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
    SELECT 
        PRODUCT_CAT.PRODUCT_CATID, 
        PRODUCT_CAT.HIERARCHY, 
        PRODUCT_CAT.PRODUCT_CAT,
        PRODUCT_CAT.HIERARCHY + ' - ' + PRODUCT_CAT.PRODUCT_CAT AS PRODUCT_CAT_NEW
    FROM 
        PRODUCT_CAT
    ORDER BY 
        HIERARCHY ASC
</cfquery>
<cfset hierarchy_list = valuelist(GET_PRODUCT_CAT.HIERARCHY)>
<cfset hierarchy_name_list = valuelist(GET_PRODUCT_CAT.PRODUCT_CAT,'╗')>

<cfquery name="GET_PRODUCT_CAT1" dbtype="query">
	SELECT 
        *
    FROM 
        GET_PRODUCT_CAT
    WHERE 
        HIERARCHY NOT LIKE '%.%'
    ORDER BY 
        HIERARCHY ASC
</cfquery>

<cfquery name="GET_PRODUCT_CAT2" dbtype="query">
	SELECT 
        *
    FROM 
        GET_PRODUCT_CAT
    WHERE 
        HIERARCHY LIKE '%.%' AND
        HIERARCHY NOT LIKE '%.%.%'
    ORDER BY 
        HIERARCHY ASC
</cfquery>

<cfquery name="GET_PRODUCT_CAT3" dbtype="query">
	SELECT 
        *
    FROM 
        GET_PRODUCT_CAT
    WHERE 
        HIERARCHY LIKE '%.%.%'
    ORDER BY 
        HIERARCHY ASC
</cfquery>

<cfquery name="get_uretici" datasource="#DSN_dev#">
	SELECT SUB_TYPE_ID,SUB_TYPE_NAME FROM EXTRA_PRODUCT_TYPES_SUBS WHERE TYPE_ID = #uretici_type_id# ORDER BY SUB_TYPE_NAME
</cfquery>

<cf_big_list_search title="Sayım Karşılaştırma Raporu (Grup ve Ürün Bazlı)">
<cfform action="#request.self#?fuseaction=retail.list_stock_count_orders_report_product_cat_product" method="post" name="search_depo">
<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
	<cf_big_list_search_area>
    	<table cellpadding="0" cellspacing="0">
            <tr>
                <td valign="top" style="text-align:right">
                	Filtre 
                    <cfinput type="text" name="keyword" value="#attributes.keyword#">
                	Departman               	
                                <cf_multiselect_check 
                                        query_name="get_departments_search"  
                                        name="search_department_id"
                                        option_text="Departman" 
                                        width="180"
                                        option_name="department_head" 
                                        option_value="department_id"
                                        value="#attributes.search_department_id#">                            
                        	<br><br>                            
                            Alan
                            <select name="regions" id="regions" style="width:80px;">                  
                                <option value="1" <cfif attributes.regions eq 1>selected</cfif>>Tutar Fark</option>  
                                <option value="0" <cfif attributes.regions eq 0>selected</cfif>>Miktar Fark</option>                                 
                            </select> 
                            <select name="size_type" id="size_type">
                                    <option value="">Seçiniz</option> 
                                    <option value="5"<cfif attributes.size_type eq 5>selected</cfif>>+/- Değer İçi</option>
                                    <option value="4"<cfif attributes.size_type eq 4>selected</cfif>>+/- Değer Dışı</option>                                   
                                    <option value="3"<cfif attributes.size_type eq 3>selected</cfif>>Eşittir</option>
                                    <option value="2"<cfif attributes.size_type eq 2>selected</cfif>>Eşit Değil</option>
                                    <option value="1"<cfif attributes.size_type eq 1>selected</cfif>>Büyüktür</option>  
                                    <option value="0"<cfif attributes.size_type eq 0>selected</cfif>>Küçüktür</option>                                 
                            </select> 
                            <cfinput type="text" style="width:70px;" id="limit" name="limit" value="#attributes.limit#" class="moneybox" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));">
                </td>
                <td valign="top" style="text-align:right;">Üretici
                	<cf_multiselect_check 
                            query_name="get_uretici"  
                            name="uretici"
                            option_text="Üretici" 
                            width="180"
                            option_name="SUB_TYPE_NAME" 
                            option_value="SUB_TYPE_ID"
                            value="#attributes.uretici#">
                            <br><br>
                            Sıralama 
                            <select name="siralama_tipi" id="siralama_tipi" style="width:70px;">                
                                        <option value="1" <cfif attributes.siralama_tipi eq 1>selected</cfif>>Artan</option>  
                                        <option value="0" <cfif attributes.siralama_tipi eq 0>selected</cfif>>Azalan</option>                                 
                            </select> 
                            <select name="siralama" id="siralama" style="width:95px;">                  
                                <option value="1" <cfif attributes.siralama eq 1>selected</cfif>>Sayım Tutarı</option>  
                                <option value="2" <cfif attributes.siralama eq 2>selected</cfif>>Gerçek Tutar</option>    
                                <option value="3" <cfif attributes.siralama eq 3>selected</cfif>>Tutar Fark</option>   
                                <option value="4" <cfif attributes.siralama eq 4>selected</cfif>>Sayım Miktarı</option>   
                                <option value="5" <cfif attributes.siralama eq 5>selected</cfif>>Gerçek Miktar</option>   
                                <option value="6" <cfif attributes.siralama eq 6>selected</cfif>>Miktar Fark</option>                                
                            </select>                            
                          
                </td>
                <td valign="top">
                    <cf_multiselect_check 
                        query_name="GET_PRODUCT_CAT1"
                        selected_text="" 
                        name="hierarchy1"
                        option_text="Ana Grup" 
                        width="100"
                        height="250"
                        option_name="PRODUCT_CAT_NEW" 
                        option_value="hierarchy"
                        value="#attributes.hierarchy1#">
                        <br />
                        <input type="checkbox" name="cat_in_out1" value="1" <cfif isdefined("attributes.cat_in_out1") or not isdefined("attributes.is_form_submitted")>checked</cfif>/>
                        İçeren Kayıtlar         
                </td>
                <td valign="top">
                    <cf_multiselect_check 
                        query_name="GET_PRODUCT_CAT2"
                        selected_text="" 
                        name="hierarchy2"
                        option_text="Alt Grup 1" 
                        width="100"
                        height="250"
                        option_name="PRODUCT_CAT_NEW" 
                        option_value="hierarchy"
                        value="#attributes.hierarchy2#">
                        <br />
                        <input type="checkbox" name="cat_in_out2" value="1" <cfif isdefined("attributes.cat_in_out2") or not isdefined("attributes.is_form_submitted")>checked</cfif>/>
                        İçeren Kayıtlar
                </td>
                <td valign="top">
                    <cf_multiselect_check 
                        query_name="GET_PRODUCT_CAT3"
                        selected_text=""  
                        name="hierarchy3"
                        option_text="Alt Grup 2" 
                        width="100"
                        height="250"
                        option_name="PRODUCT_CAT_NEW" 
                        option_value="hierarchy"
                        value="#attributes.hierarchy3#">
                        <br />
                        <input type="checkbox" name="cat_in_out3" value="1" <cfif isdefined("attributes.cat_in_out3") or not isdefined("attributes.is_form_submitted")>checked</cfif>/>
                        İçeren Kayıtlar
                </td>
                <td valign="top"><cf_wrk_search_button search_function="control_search_depo()"></td>
           </tr>
           
      	</table>
    </cf_big_list_search_area>
</cfform>
</cf_big_list_search>

<script>
function control_search_depo()
{
	if(document.getElementById('search_department_id').value == '')
	{
		alert('Depo Seçiniz!');
		return false;
	}
	if(document.getElementById('size_type').value != '' && document.getElementById('limit').value == '')
	{
		alert('Miktar Giriniz!');
		document.getElementById('limit').focus();
		return false;
	}
	return true;
}
</script>
<cfif isdefined("attributes.is_form_submitted")>
    <cfquery name="get_alt_groups" dbtype="query">
        SELECT
            *
        FROM
            GET_PRODUCT_CAT
        WHERE
        <cfif isdefined("attributes.HIERARCHY1") and len(attributes.HIERARCHY1)>
            <cfif isdefined("attributes.cat_in_out1")>
            (
                <cfset count_ = 0>
                <cfloop list="#attributes.HIERARCHY1#" index="ccc">
                    <cfset count_ = count_ + 1>
                    HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ccc#.%">
                    <cfif count_ Neq listlen(attributes.HIERARCHY1)>
                        OR
                    </cfif>
                </cfloop>
            )
            AND
            <cfelse>
            (
                <cfset count_ = 0>
                <cfloop list="#attributes.HIERARCHY1#" index="ccc">
                    <cfset count_ = count_ + 1>
                    HIERARCHY NOT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ccc#.%">
                    <cfif count_ Neq listlen(attributes.HIERARCHY1)>
                        AND
                    </cfif>
                </cfloop>
            )
            AND
            </cfif>
        </cfif>
        
        <cfif isdefined("attributes.HIERARCHY2") and len(attributes.HIERARCHY2)>
            <cfif isdefined("attributes.cat_in_out2")>
            (
                <cfset count_ = 0>
                <cfloop list="#attributes.HIERARCHY2#" index="ccc">
                    <cfset count_ = count_ + 1>
                    HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ccc#.%">
                    <cfif count_ Neq listlen(attributes.HIERARCHY2)>
                        OR
                    </cfif>
                </cfloop>
            )
            AND
            <cfelse>
            (
                <cfset count_ = 0>
                <cfloop list="#attributes.HIERARCHY2#" index="ccc">
                    <cfset count_ = count_ + 1>
                    HIERARCHY NOT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ccc#.%">
                    <cfif count_ Neq listlen(attributes.HIERARCHY2)>
                        AND
                    </cfif>
                </cfloop>
            )
            AND
            </cfif>
        </cfif>
        
        <cfif isdefined("attributes.HIERARCHY3") and len(attributes.HIERARCHY3)>
            <cfif isdefined("attributes.cat_in_out3")>
            (
                <cfset count_ = 0>
                <cfloop list="#attributes.HIERARCHY3#" index="ccc">
                    <cfset count_ = count_ + 1>
                    HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ccc#">
                    <cfif count_ Neq listlen(attributes.HIERARCHY3)>
                        OR
                    </cfif>
                </cfloop>
            )
            AND
            <cfelse>
            (
                <cfset count_ = 0>
                <cfloop list="#attributes.HIERARCHY3#" index="ccc">
                    <cfset count_ = count_ + 1>
                    HIERARCHY <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#ccc#">
                    <cfif count_ Neq listlen(attributes.HIERARCHY3)>
                        AND
                    </cfif>
                </cfloop>
            )
            AND
            </cfif>
        </cfif>
        PRODUCT_CATID IS NOT NULL AND
        HIERARCHY LIKE '%.%.%'
    </cfquery>
    <cfif get_alt_groups.recordcount>
        <cfset p_cat_list = valuelist(get_alt_groups.PRODUCT_CATID)>
    <cfelse>
        <cfset p_cat_list = "">
    </cfif>
    
    <cfquery name="get_counts" datasource="#DSN2#">
    SELECT
    T3.STOCK_NAME,
    T3.STOCK_ID,
    T3.BARCOD,
    T3.PRODUCT_CAT,
    T3.PRODUCT_CATID,
    T3.HIERARCHY,
    T3.IS_UPDATE,
    
    SUM(T3.TOPLAM_STOCK) AS TOPLAM_STOCK,
    SUM(T3.TOTAL_COUNT_AMOUNT) AS TOTAL_COUNT_AMOUNT,
    SUM(T3.TOPLAM_STOCK_TUTAR) AS TOPLAM_STOCK_TUTAR,
    SUM(T3.TOPLAM_COUNT_TUTAR) AS TOPLAM_COUNT_TUTAR,
    SUM(T3.MIKTAR_FARK) AS MIKTAR_FARK,
    SUM(T3.TUTAR_FARK) AS TUTAR_FARK     
    FROM
    (
    SELECT
    	TOPLAM_STOCK,        
        TOTAL_COUNT_AMOUNT,
        (TOPLAM_STOCK - TOTAL_COUNT_AMOUNT) AS MIKTAR_FARK,
        (TOPLAM_STOCK * LISTE_FIYATI) AS TOPLAM_STOCK_TUTAR,
        (TOTAL_COUNT_AMOUNT * LISTE_FIYATI) AS TOPLAM_COUNT_TUTAR,
        ((TOPLAM_STOCK * LISTE_FIYATI) - (TOTAL_COUNT_AMOUNT * LISTE_FIYATI)) AS TUTAR_FARK,
        T2.STOCK_NAME,
        T2.STOCK_ID,
        T2.BARCOD,
        T2.PRODUCT_CAT,
        T2.PRODUCT_CATID,
        T2.HIERARCHY,
        T2.IS_UPDATE
    FROM
    	(
        (
        SELECT
            ISNULL((SELECT SUM(GSLL.REAL_STOCK) FROM 
            
            (
                        SELECT     SUM(REAL_STOCK) AS REAL_STOCK,  PRODUCT_ID, STOCK_ID, DEPARTMENT_ID, LOCATION_ID
                        FROM         (SELECT     STOCK_IN - STOCK_OUT AS REAL_STOCK, STOCK_ID, PRODUCT_ID, STORE AS DEPARTMENT_ID, STORE_LOCATION AS LOCATION_ID
                                               FROM          STOCKS_ROW AS SR
                                               WHERE      (STORE IS NOT NULL) AND (STORE_LOCATION IS NOT NULL) AND SR.PROCESS_DATE <= DATEADD("dd",1,T1.ORDER_DATE)
                                               UNION ALL
                                               SELECT     STOCK_IN - STOCK_OUT AS REAL_STOCK, STOCK_ID, PRODUCT_ID, '-1' AS DEPARTMENT_ID, '-1' AS LOCATION_ID
                                               FROM         STOCKS_ROW AS SR
                                               WHERE     (UPD_ID IS NULL) AND SR.PROCESS_DATE <= DATEADD("dd",1,T1.ORDER_DATE)
                                               ) AS T1
                                               WHERE DEPARTMENT_ID = #attributes.search_department_id#
                        GROUP BY PRODUCT_ID, STOCK_ID, DEPARTMENT_ID, LOCATION_ID
                        )
                        
             GSLL WHERE GSLL.STOCK_ID = T1.STOCK_ID AND GSLL.DEPARTMENT_ID IN (#attributes.search_department_id#)),0) AS TOPLAM_STOCK,
            SUM(AMOUNT) AS TOTAL_COUNT_AMOUNT,
            T1.STOCK_NAME,
            T1.STOCK_ID,
            T1.BARCOD,
            T1.PRODUCT_CAT,
            T1.PRODUCT_CATID,
            T1.HIERARCHY,
            T1.IS_UPDATE,
            T1.LISTE_FIYATI
        FROM
            (            
            SELECT
                ISNULL((SELECT TOP 1 ETR.SUB_TYPE_ID FROM #DSN_DEV_ALIAS#.EXTRA_PRODUCT_TYPES_ROWS ETR WHERE S.PRODUCT_ID = ETR.PRODUCT_ID AND ETR.TYPE_ID = #uretici_type_id#),0) AS SUB_TYPE_ID,
                S.PROPERTY AS STOCK_NAME,
                SCOR.STOCK_ID,
                S.BARCOD,
                SCOR.AMOUNT,
                SCOR.IS_UPDATE,
                SCO.ORDER_DATE,
                PC.PRODUCT_CAT,
                PC.PRODUCT_CATID,
                PC.HIERARCHY,
                ISNULL(( 
                SELECT TOP 1 
                    PT1.NEW_ALIS
                FROM
                    #DSN_DEV#.PRICE_TABLE PT1
                WHERE
                    PT1.IS_ACTIVE_P = 1 AND
                    PT1.STARTDATE <= SCO.ORDER_DATE AND 
                    DATEADD("d",-1,PT1.FINISHDATE) >= SCO.ORDER_DATE AND
                    (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = S.PRODUCT_ID))
                ORDER BY
                	PT1.STARTDATE DESC,
					PT1.ROW_ID DESC
            	),PRICE) AS LISTE_FIYATI
            FROM 
                #dsn3_alias#.STOCKS S,
                #dsn1_alias#.PRODUCT_CAT PC,
                #dsn_dev_alias#.STOCK_COUNT_ORDERS_ROWS SCOR,
                #dsn_dev_alias#.STOCK_COUNT_ORDERS SCO,
                #dsn1_alias#.PRICE_STANDART PS
            WHERE	
            	S.PRODUCT_ID = PS.PRODUCT_ID AND
                PS.PURCHASESALES = 0 AND
                PS.PRICESTANDART_STATUS = 1 AND
                SCO.STATUS = 1 AND
                SCOR.ORDER_ID = SCO.ORDER_ID AND
                SCO.DEPARTMENT_ID IN (#attributes.search_department_id#) AND
                SCOR.STOCK_ID = S.STOCK_ID AND
                S.PRODUCT_STATUS = 1 AND
                S.STOCK_STATUS = 1 AND
                S.PRODUCT_CATID = PC.PRODUCT_CATID AND
                PC.PRODUCT_CATID IN (#p_cat_list#)
                <cfif len(attributes.keyword)> AND (S.PROPERTY LIKE '%#attributes.keyword#%' OR S.BARCOD LIKE '%#attributes.keyword#%')</cfif>
            ) T1
        WHERE
            <cfif isdefined("attributes.uretici") and listlen(attributes.uretici)>
                SUB_TYPE_ID IN (#attributes.uretici#) AND
            </cfif>
            STOCK_ID IS NOT NULL
        GROUP BY
        	T1.STOCK_NAME,
            T1.STOCK_ID,
            T1.BARCOD,
            T1.PRODUCT_CAT,
            T1.PRODUCT_CATID,
            T1.HIERARCHY,
            T1.ORDER_DATE,
            T1.IS_UPDATE,
            T1.LISTE_FIYATI
        )
        
        ) T2
     	) T3   
        <cfif len(attributes.size_type)>
        WHERE
			<cfif attributes.regions eq 1>T3.TUTAR_FARK <cfelse>T3.MIKTAR_FARK</cfif>
            <cfif attributes.size_type eq 1>
            >
            <cfelseif attributes.size_type eq 0>
            <
            <cfelseif attributes.size_type eq 2>
            <>
            <cfelseif attributes.size_type eq 3>
            =
            <cfelseif attributes.size_type eq 4>
            NOT BETWEEN  
            <cfelseif attributes.size_type eq 5>
            BETWEEN
            </cfif> 
            <cfif attributes.size_type eq 4 or attributes.size_type eq 5>
             	#filternum(-1*attributes.limit)# AND #filternum(attributes.limit)#
            <cfelse>
            	#filternum(attributes.limit)#
            </cfif>
        </cfif>        
        GROUP BY
        T3.STOCK_NAME,
        T3.STOCK_ID,
        T3.BARCOD,
        T3.PRODUCT_CAT,
        T3.PRODUCT_CATID,
        T3.HIERARCHY,
        T3.IS_UPDATE
        ORDER BY      
        	T3.HIERARCHY,  	
        	<cfif attributes.siralama eq 1>TOPLAM_COUNT_TUTAR 
            <cfelseif attributes.siralama eq 2>TOPLAM_STOCK_TUTAR
            <cfelseif attributes.siralama eq 3>TUTAR_FARK
            <cfelseif attributes.siralama eq 4>TOTAL_COUNT_AMOUNT
            <cfelseif attributes.siralama eq 5>TOPLAM_STOCK
            <cfelseif attributes.siralama eq 6>MIKTAR_FARK</cfif>
            <cfif attributes.siralama_tipi eq 1> ASC, <cfelseif attributes.siralama_tipi eq 0> DESC, </cfif>  
            T3.STOCK_NAME,
            T3.STOCK_ID   
     </cfquery>

       	<cfset sayim_tutari = 0>
		<cfset gercek_tutar = 0>
        <cfset tutar_fark_ = 0>

        <cfset sayim_miktari = 0>
        <cfset gercek_miktar = 0>
        <cfset miktar_fark_ = 0>
        
        <cfset grup_sayim_tutari = 0>
		<cfset grup_gercek_tutar = 0>
        <cfset grup_tutar_fark = 0>
        <cfset grup_sayim_miktari = 0>
        <cfset grup_gercek_miktar = 0>
        <cfset grup_miktar_fark = 0>
<cfquery name="main_grup" dbtype="query">
    SELECT 
    	PRODUCT_CAT,
    	PRODUCT_CATID,
        SUM(TOPLAM_STOCK) AS TOPLAM_STOCK,
        SUM(TOTAL_COUNT_AMOUNT) AS TOTAL_COUNT_AMOUNT,
        SUM(TOPLAM_STOCK_TUTAR) AS TOPLAM_STOCK_TUTAR,
        SUM(TOPLAM_COUNT_TUTAR) AS TOPLAM_COUNT_TUTAR,
        SUM(MIKTAR_FARK) AS MIKTAR_FARK,
        SUM(TUTAR_FARK) AS TUTAR_FARK    
    FROM 
    	GET_COUNTS 
    GROUP BY
    	PRODUCT_CAT,
    	PRODUCT_CATID
    ORDER BY 
    	PRODUCT_CAT
</cfquery>

<cfif main_grup.recordcount gt 0>
	<cfset product_cat_list = valuelist(main_grup.PRODUCT_CAT)>
</cfif>
<!-- sil -->      
 
      <table class="big_list" id="manage_table">
    	<thead>
        	<tr>
            	<th>Sıra</th>                  
                <th>Grup</th>  
                <th>Grup Kodu</th>              
                <th>Barkod</th>                
                <th>Ürün</th>  
                <th>Sayım Tekrarı</th>
                <th style="text-align:right;">Sayım Tutarı</th>
                <th style="text-align:right;">Gerçek Tutar</th>
                <th style="text-align:right;">Tutar Fark</th>
                <th style="text-align:right;">Sayım Miktarı</th>
                <th style="text-align:right;">Gerçek Miktar</th>
                <th style="text-align:right;">Miktar Fark</th>
            </tr>
        </thead>
        <tbody >
        
        	<cfsavecontent variable="icerik"> 
            <cfset last_p_cat =''>
            <cfset p_cat = ''>
            <cfset row = 0>
            
        	<cfoutput query="get_counts">   
            	<cfset p_cat = #product_cat#>
                <cfif p_cat neq last_p_cat>                	
					<cfset row = row+1>  
                 
                    <tr>  
                    	<td style="text-align:right;"></td>
                        <td style="text-align:left;">
                        <a href="javascript://" onclick="get_product_stock_row('#row#');"><img src="/images/listele.gif" id="p_image_#row#" align="absbottom"/></a>      	
                    	<a href="javascript://" onclick="get_out_product_stock_row('#row#');"><img src="/images/listele_down.gif" id="p_image2_#row#" style="display:none;"/></a>
                        #PRODUCT_CAT#</td>
                        <td style="text-align:left;">#HIERARCHY#</td>
                        <td style="text-align:left;" colspan="3"></td>
                        <td style="text-align:right;"><cfloop query="main_grup" startrow="1" endrow="#main_grup.recordcount#"><cfif get_counts.PRODUCT_CAT eq main_grup.product_cat> #TLFORMAT(main_grup.TOPLAM_COUNT_TUTAR)#</cfif></cfloop></td>              
                        <td style="text-align:right;"><cfloop query="main_grup" startrow="1" endrow="#main_grup.recordcount#"><cfif get_counts.PRODUCT_CAT eq main_grup.product_cat> #TLFORMAT(main_grup.TOPLAM_STOCK_TUTAR)#</cfif></cfloop></td>
                        <td style="text-align:right;"><cfloop query="main_grup" startrow="1" endrow="#main_grup.recordcount#"><cfif get_counts.PRODUCT_CAT eq main_grup.product_cat> #TLFORMAT(main_grup.TUTAR_FARK)#</cfif></cfloop></td>
                        <td style="text-align:right;"><cfloop query="main_grup" startrow="1" endrow="#main_grup.recordcount#"><cfif get_counts.PRODUCT_CAT eq main_grup.product_cat> #TLFORMAT(main_grup.TOTAL_COUNT_AMOUNT)#</cfif></cfloop></td>
                        <td style="text-align:right;"><cfloop query="main_grup" startrow="1" endrow="#main_grup.recordcount#"><cfif get_counts.PRODUCT_CAT eq main_grup.product_cat> #TLFORMAT(main_grup.TOPLAM_STOCK)#</cfif></cfloop></td>
                        <td style="text-align:right;"><cfloop query="main_grup" startrow="1" endrow="#main_grup.recordcount#"><cfif get_counts.PRODUCT_CAT eq main_grup.product_cat> #TLFORMAT(main_grup.MIKTAR_FARK)#</cfif></cfloop></td>
                    </tr>                    
                </cfif>                
                <tr rel="rows#row#" style="display:none;">                
                        <td>#currentrow#</td>
                        <td>#PRODUCT_CAT#</td>  
                        <td>#HIERARCHY#</td>                 
                        <td>#barcod#</td>
                        <td>#stock_name#</td>
                        <td><cfif IS_UPDATE eq 1>Yapıldı</cfif></td>                   
                        <td style="text-align:right;background-color:##000000; <cfif TOPLAM_COUNT_TUTAR lt 0>color:##FF0000; <cfelse>color:##00FF7F;</cfif>">#tlformat(TOPLAM_COUNT_TUTAR,2)#</td>
                        <td style="text-align:right;background-color:##4169E1; <cfif TOPLAM_STOCK_TUTAR lt 0>color:##FF0000; <cfelse>color:##FFD700;</cfif>">#tlformat(TOPLAM_STOCK_TUTAR,2)#</td>
                        <td style="text-align:right;background-color:##696969; <cfif TOPLAM_COUNT_TUTAR - TOPLAM_STOCK_TUTAR lt 0>color:##FFA500; <cfelse>color:##FFFFFF;</cfif>">#tlformat(TUTAR_FARK,2)#</td>
                        <td style="text-align:right;background-color:##000000; <cfif TOTAL_COUNT_AMOUNT lt 0>color:##FF0000; <cfelse>color:##00FF7F;</cfif>">#tlformat(TOTAL_COUNT_AMOUNT,2)#</td>
                        <td style="text-align:right;background-color:##4169E1; <cfif TOPLAM_STOCK lt 0>color:##FF0000; <cfelse>color:##FFD700;</cfif>">#tlformat(TOPLAM_STOCK,2)#</td>
                        <td style="text-align:right;background-color:##696969; <cfif TOTAL_COUNT_AMOUNT - TOPLAM_STOCK lt 0>color:##FFA500; <cfelse>color:##FFFFFF;</cfif>">#tlformat(MIKTAR_FARK,2)#</td>                      
                </tr> 
                
                <cfset last_p_cat =p_cat>
                <cfset sayim_tutari = sayim_tutari + #TOPLAM_COUNT_TUTAR#>
                <cfset gercek_tutar = gercek_tutar + #TOPLAM_STOCK_TUTAR#>
                <cfset tutar_fark_ = tutar_fark_ + #TUTAR_FARK#>
                <cfset sayim_miktari = sayim_miktari + #TOTAL_COUNT_AMOUNT#>
                <cfset gercek_miktar = gercek_miktar + #TOPLAM_STOCK#>
                <cfset miktar_fark_ = miktar_fark_ + #MIKTAR_FARK#>  
            </cfoutput>
        
            </cfsavecontent>
            <cfoutput>
            	<cfset cols = 5>
            <tr>
            		<td style="text-align:center;background-color:##A52A2A; color:##FFFFFF;">
                    <a href="javascript://" onclick="get_product_stock_row_all('#row#');"><img src="/images/listele.gif" id="p_image_#row#" align="absbottom"/></a>      	
                    <a href="javascript://" onclick="get_out_product_stock_row_all('#row#');"><img src="/images/listele_down.gif" id="p_image2_#row#" style="display:none;"/></a>
                     </td>   
                    <td style="text-align:right;background-color:##A52A2A; color:##FFFFFF;" colspan="#cols#">Toplamlar</td>
                    <td style="text-align:right;background-color:##A52A2A; <cfif sayim_tutari lt 0>color:##FF0000; <cfelse>color:##00FF7F;</cfif>">#tlformat(sayim_tutari,2)#</td>
                    <td style="text-align:right;background-color:##A52A2A; <cfif gercek_tutar lt 0>color:##FF0000; <cfelse>color:##FFD700;</cfif>">#tlformat(gercek_tutar,2)#</td>
                    <td style="text-align:right;background-color:##A52A2A; <cfif tutar_fark_ lt 0>color:##FFA500; <cfelse>color:##FFFFFF;</cfif>">#tlformat(tutar_fark_,2)#</td>
                    <td style="text-align:right;background-color:##A52A2A; <cfif sayim_miktari lt 0>color:##FF0000; <cfelse>color:##00FF7F;</cfif>">#tlformat(sayim_miktari,2)#</td>
                    <td style="text-align:right;background-color:##A52A2A; <cfif gercek_miktar lt 0>color:##FF0000; <cfelse>color:##FFD700;</cfif>">#tlformat(gercek_miktar,2)#</td>
                    <td style="text-align:right;background-color:##A52A2A; <cfif miktar_fark_ lt 0>color:##FFA500; <cfelse>color:##FFFFFF;</cfif>">#tlformat(miktar_fark_,2)#</td>
                </tr>
             </cfoutput>           
             <cfoutput>#icerik#</cfoutput>
        </tbody>
     </table>
<!-- sil --> 
</cfif>
<script>
	function get_product_stock_row(row_)
	{
		rel_ = "rel='rows" + row_ + "'";
		col1 = $("#manage_table tr[" + rel_ + "]");
	
		col1.toggle();
		
		$('#p_image_' + row_).hide();
		$('#p_image2_' + row_).show();
	}
	function get_out_product_stock_row(row_)
	{
		rel_ = "rel='rows" + row_ + "'";
		col1 = $("#manage_table tr[" + rel_ + "]");
		
		col1.toggle();
		
		$('#p_image2_' + row_).hide();
		$('#p_image_' + row_).show();
	}
	function get_product_stock_row_all(row_)
	{
		eleman_sayisi = row_;
		for (var m=1; m <= eleman_sayisi; m++)
			{
		rel_ = "rel='rows" + m + "'";
		col1 = $("#manage_table tr[" + rel_ + "]");
	
		col1.toggle();
		
		$('#p_image_' + row_).hide();
		$('#p_image2_' + row_).show();
			}
	}
	function get_out_product_stock_row_all(row_)
	{
		eleman_sayisi = row_;
		for (var m=1; m <= eleman_sayisi; m++)
		{
		rel_ = "rel='rows" + m + "'";
		col1 = $("#manage_table tr[" + rel_ + "]");
		
		col1.toggle();
		
		$('#p_image2_' + row_).hide();
		$('#p_image_' + row_).show();
		}
	}
</script>