<cfparam name="attributes.product_status" default="2">
<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>

<cfquery name="get_periods" datasource="#dsn#">
	SELECT * FROM SETUP_PERIOD
</cfquery>
<cfquery name="get_periods_ic" datasource="#dsn#">
	SELECT * FROM SETUP_PERIOD
</cfquery>

<cfif attributes.transfer_type eq 1>
    <cfquery name="get_transfer_products" datasource="#dsn_dev#">
    	SELECT 
        	STOCK_ID,
            AMOUNT,
            TO_DEPARTMENT_ID
        FROM 
            STOCK_TRANSFER_LIST
        WHERE
        	DEPARTMENT_ID = #attributes.department_id#
    </cfquery>
    <cfoutput query="get_transfer_products">
    	<cfset 'dagilim_#STOCK_ID#_#TO_DEPARTMENT_ID#' = AMOUNT>
    </cfoutput>
</cfif>

<cfquery name="get_products" datasource="#dsn3#" result="query_result">
    SELECT
        P.PRODUCT_NAME, 
        P.PRODUCT_CODE,
        P.PRODUCT_ID,
        P.PRODUCT_CATID,
        P.TAX_PURCHASE,
        P.TAX,
        P.P_PROFIT,
        P.S_PROFIT,
        P.IS_PURCHASE,
        P.PRODUCT_STATUS,
        P.COMPANY_ID,
        P.PROJECT_ID,
        P.ADD_STOCK_DAY,
        P.IS_PURCHASE_C,
        P.IS_PURCHASE_M,
        P.IS_SALES,
        P.BARCOD,
        P.MAXIMUM_STOCK,
        P.MINIMUM_STOCK,
        P.ORDER_LIMIT,
        P.MIN_MARGIN,
        P.MAX_MARGIN,
        EPTR.SUB_TYPE_NAME,
        PRODUCT_CAT.PRODUCT_CAT,
        S.PROPERTY,
        S.STOCK_ID,
        S.BARCOD AS S_BARCOD,
        S.STOCK_CODE,
        ISNULL(( 
            SELECT TOP 1 
                PT1.NEW_ALIS_KDV
            FROM
                #DSN_DEV#.PRICE_TABLE PT1
            WHERE
                PT1.IS_ACTIVE_P = 1 AND
                PT1.P_STARTDATE <= #bugun_# AND 
                DATEADD("d",-1,PT1.P_FINISHDATE) >= #bugun_# AND
                (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID))
            ORDER BY
                PT1.P_STARTDATE DESC,
                PT1.ROW_ID DESC
        ),PS.PRICE_KDV) AS LISTE_FIYATI,
        <cfloop from="1" to="#dept_count#" index="cc">
        	<cfset dept_id_ = listgetat(dept_list,cc)>
            ISNULL(#dsn_dev_alias#.fnc_get_ortalama_satis_stok(S.STOCK_ID,#dept_id_#,#attributes.search_startdate#,#attributes.search_finishdate#),0) AS ROW_ORT_STOK_SATIS_MIKTARI_#dept_id_#,
            ISNULL((SELECT SUM(PRODUCT_STOCK) FROM #DSN2_ALIAS#.GET_STOCK_PRODUCT WHERE S.STOCK_ID = GET_STOCK_PRODUCT.STOCK_ID AND GET_STOCK_PRODUCT.DEPARTMENT_ID = #dept_id_#),0) AS SUBE_STOCK_#dept_id_#,
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
               	O.DELIVER_DEPT_ID = #dept_id_# AND
                O.ORDER_DATE >= #dateadd('d',order_control_day,bugun_)# AND
       			O.ORDER_DATE <= #bugun_# 
        	),0) PURCHASE_ORDER_QUANTITY_#dept_id_#,
        	ISNULL((
				SELECT
                	SUM(MIKTAR - KARSILANAN)
                FROM
                    (
					<cfoutput query="get_periods">
                        SELECT
                            ISNULL((
                                SELECT
                                    SUM(AMOUNT) AS AMOUNT_TOTAL
                                FROM
                                    (
                                        <cfset p_count_ = 0>
                                        <cfloop query="get_periods_ic">
                                            <cfset p_count_ = p_count_ + 1>
                                            SELECT 
                                                SROW.AMOUNT
                                            FROM 
                                                #dsn#_#get_periods_ic.period_year#_#get_periods_ic.our_company_id#.SHIP_ROW SROW 
                                            WHERE 
                                                SROW.WRK_ROW_RELATION_ID = SIR.WRK_ROW_ID
                                        <cfif p_count_ neq get_periods_ic.recordcount>
                                            UNION ALL
                                        </cfif>
                                        </cfloop>
                                    ) T1
                            ),0) AS KARSILANAN,
                            CASE WHEN SI.DEPARTMENT_IN = #dept_id_# THEN SIR.AMOUNT ELSE (-1 * SIR.AMOUNT) END AS MIKTAR
                        FROM
                            #dsn#_#period_year#_#our_company_id#.SHIP_INTERNAL SI,
                            #dsn#_#period_year#_#our_company_id#.SHIP_INTERNAL_ROW SIR
                        WHERE
                            SI.DELIVER_DATE >= #dateadd('d',order_control_day,bugun_)# AND
       						SI.DELIVER_DATE < #dateadd('d',1,bugun_)# AND
                            SI.DISPATCH_SHIP_ID = SIR.DISPATCH_SHIP_ID AND
                            (SI.DEPARTMENT_IN = #dept_id_# OR SI.DEPARTMENT_OUT = #dept_id_#) AND
                            SIR.STOCK_ID = S.STOCK_ID
                        <cfif currentrow neq get_periods.recordcount>
                        UNION ALL
                        </cfif>
                    </cfoutput>
                  ) T_ALL                   
            ),0) AS SHIP_INTERNAL_#dept_id_#,
        </cfloop>
        ISNULL((SELECT SUM(PRODUCT_STOCK) FROM #DSN2_ALIAS#.GET_STOCK_PRODUCT WHERE S.STOCK_ID = GET_STOCK_PRODUCT.STOCK_ID AND GET_STOCK_PRODUCT.DEPARTMENT_ID IN (#merkez_depo_id#)),0) AS DEPO_STOCK,
        ISNULL(fnc_get_unit_multiplier(P.PRODUCT_ID,#koli_unit#),fnc_get_unit_multiplier(P.PRODUCT_ID,#teneke_unit#)) MULTIPLIER,
        ISNULL((SELECT SUM(PRODUCT_STOCK) FROM #DSN2_ALIAS#.GET_STOCK_PRODUCT WHERE S.STOCK_ID = GET_STOCK_PRODUCT.STOCK_ID AND GET_STOCK_PRODUCT.DEPARTMENT_ID = #ATTRIBUTES.DEPARTMENT_ID#),0) AS DAGITILACAK_STOCK,
        ISNULL(#dsn_dev_alias#.fnc_get_ortalama_satis_stok(S.STOCK_ID,#ATTRIBUTES.DEPARTMENT_ID#,#attributes.search_startdate#,#attributes.search_finishdate#),0) AS ROW_ORT_STOK_SATIS_MIKTARI
    FROM 
        STOCKS S,
        PRICE_STANDART PS,
        #dsn1_alias#.PRODUCT P
        LEFT JOIN #dsn_dev_alias#.EXTRA_PRODUCT_TYPES_ROWS EPTR ON (P.PRODUCT_ID = EPTR.PRODUCT_ID AND EPTR.TYPE_ID = #ambalaj_type_id#)
        LEFT JOIN PRODUCT_CAT ON P.PRODUCT_CATID = PRODUCT_CAT.PRODUCT_CATID
    WHERE
        P.PRODUCT_ID = PS.PRODUCT_ID AND
        PS.PRICESTANDART_STATUS = 1 AND
        PS.PURCHASESALES = 0 AND
        S.STOCK_ID IN (#p_list#) AND
        (P.IS_PURCHASE = 1 OR P.IS_SALES = 1) AND
        <cfif attributes.product_status neq 2>
            ISNULL(P.PRODUCT_STATUS,0) = #attributes.product_status# AND
        </cfif>
        S.STOCK_STATUS = 1 AND
        P.PRODUCT_ID = S.PRODUCT_ID
    ORDER BY
        P.PRODUCT_CODE ASC,
        SUB_TYPE_NAME,
    	P.PRODUCT_NAME,
        S.PROPERTY
</cfquery>


<cfset name_list = "sube_yeter,id,list_price,dagilim_toplam,depo_stock,sira_no,stock_id,barcode,stock_code,product_cat,product_name,stock_name,sube_ortalama_satis,sube_stock,tutar_sube_stock,koli_carpan,product_code">
<cfloop from="1" to="#dept_count#" index="cc">
	<cfset dept_id_ = listgetat(dept_list,cc)>
	<cfset name_list = listappend(name_list,'sube_ortalama_satis_#dept_id_#')>
    <cfset name_list = listappend(name_list,'sube_stock_#dept_id_#')>
    <cfset name_list = listappend(name_list,'dagilim_#dept_id_#')>
    <cfset name_list = listappend(name_list,'reel_dagilim_#dept_id_#')>
    <cfset name_list = listappend(name_list,'sube_stock_yeterlilik_#dept_id_#')>
    <cfset name_list = listappend(name_list,'yoldaki_#dept_id_#')>
    <cfset name_list = listappend(name_list,'ship_internal_#dept_id_#')>
    <cfset name_list = listappend(name_list,'onay_#dept_id_#')>
</cfloop>

<cfset deger_list = "Double">
<cfloop from="2" to="#listlen(name_list)#" index="aa">
	<cfset deger_list = listappend(deger_list,'varchar')>
</cfloop>

<cfset query_count = 0>
<cfset myQuery = QueryNew("#name_list#","#deger_list#")>

<cfoutput query="get_products">
	<cfset r_number = '0' & round(rand()*100) & '#product_id##stock_id#00' & dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'#userid_#'&round(rand()*100)>
    
    <cfset query_count = query_count + 1>
	<cfset newRow = QueryAddRow(MyQuery,1)>
    
    <cfset temp = QuerySetCell(myQuery,"id","#r_number#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"sira_no","#currentrow#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"stock_id","#stock_id#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"barcode","#S_BARCOD#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"stock_code","#STOCK_CODE#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"product_cat","#PRODUCT_CAT#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"product_name","#PRODUCT_NAME#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"stock_name","#PROPERTY#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"product_code","#product_id#_#stock_id#_#attributes.department_id#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"koli_carpan","#MULTIPLIER#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"sube_ortalama_satis","#ROW_ORT_STOK_SATIS_MIKTARI#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"sube_stock","#DAGITILACAK_STOCK#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"dagilim_toplam","#DAGITILACAK_STOCK#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"tutar_sube_stock","#DAGITILACAK_STOCK * LISTE_FIYATI#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"depo_stock","#DEPO_STOCK#",query_count)>
    
    <cfset temp = QuerySetCell(myQuery,"list_price","#LISTE_FIYATI#",query_count)>
    
    <cfset DAGITILACAK_STOCK_ = DAGITILACAK_STOCK>
    
    <cfif DAGITILACAK_STOCK_ gt 0 and ROW_ORT_STOK_SATIS_MIKTARI gt 0>
		<cfset stockta_yeterlilik_suresi = wrk_round(DAGITILACAK_STOCK_ / ROW_ORT_STOK_SATIS_MIKTARI)>
    <cfelse>
        <cfset stockta_yeterlilik_suresi = 0>
    </cfif>
    <cfset temp = QuerySetCell(myQuery,"sube_yeter","#stockta_yeterlilik_suresi#",query_count)>

    <cfif isdefined("attributes.yeter_limit") and len(attributes.yeter_limit) and attributes.yeter_type eq 1 and DAGITILACAK_STOCK_ gt 0>
		<cfif stockta_yeterlilik_suresi gt attributes.yeter_limit>
			<cfset fazla_kisim = ceiling((stockta_yeterlilik_suresi - attributes.yeter_limit) * ROW_ORT_STOK_SATIS_MIKTARI)>
            <cfset DAGITILACAK_STOCK_ = fazla_kisim>
            <cfif DAGITILACAK_STOCK_ lt 0>
            	<cfset DAGITILACAK_STOCK_ = 0>
            </cfif>
        </cfif>
    </cfif>
	
	<cfset kalan_stok = DAGITILACAK_STOCK_>
    
    <cfset toplam_ortalama = 0>
    <cfloop from="1" to="#dept_count#" index="kk">
        <cfset dept_id_ = listgetat(dept_list,kk)>
        <cfset satis_ortalama_ = evaluate('ROW_ORT_STOK_SATIS_MIKTARI_#dept_id_#')>
        
        <cfset dept_satis_ = evaluate('ROW_ORT_STOK_SATIS_MIKTARI_#dept_id_#')>
        <cfset row_stock = evaluate('SUBE_STOCK_#dept_id_#')>
        <cfset row_yoldaki = evaluate('PURCHASE_ORDER_QUANTITY_#dept_id_#')>
        <cfset row_ship_internal = evaluate('SHIP_INTERNAL_#dept_id_#')>
        
		<cfif not len(dept_satis_)>
			<cfset dept_dagilim_ = 0>
        <cfelse>
            <cfset dept_dagilim_ = Ceiling(dept_satis_ * attributes.order_day)>
            
            <cfif isdefined("attributes.real_stock") and row_stock gt 0>
                <cfset dept_dagilim_ = dept_dagilim_ - row_stock>
            </cfif>		
            <cfif isdefined("attributes.way_stock")>
                <cfset dept_dagilim_ = dept_dagilim_ - row_yoldaki> 
            </cfif>
            <cfif isdefined("attributes.ship_internal")>
            	<cfset dept_dagilim_ = dept_dagilim_ - row_ship_internal>
            </cfif>
            
            <cfif dept_dagilim_ lt 0>
                <cfset dept_dagilim_ = 0>
            </cfif>                          
        </cfif>
        
        <cfif dept_dagilim_ gt 0>
    		<cfset toplam_ortalama = toplam_ortalama + satis_ortalama_>
        </cfif>
    </cfloop>    
    
    <cfloop from="1" to="#dept_count#" index="cc">
        <cfset dept_id_ = listgetat(dept_list,cc)>
        <cfset temp = QuerySetCell(myQuery,"sube_ortalama_satis_#dept_id_#","#evaluate('ROW_ORT_STOK_SATIS_MIKTARI_#dept_id_#')#",query_count)>
        <cfset temp = QuerySetCell(myQuery,"sube_stock_#dept_id_#","#evaluate('SUBE_STOCK_#dept_id_#')#",query_count)>
        <cfif evaluate('SUBE_STOCK_#dept_id_#') gt 0 and evaluate('ROW_ORT_STOK_SATIS_MIKTARI_#dept_id_#') gt 0>
			<cfset stockta_yeterlilik_suresi = wrk_round(evaluate('SUBE_STOCK_#dept_id_#') / evaluate('ROW_ORT_STOK_SATIS_MIKTARI_#dept_id_#'))>
        <cfelse>
            <cfset stockta_yeterlilik_suresi = 0>
        </cfif>
        <cfset temp = QuerySetCell(myQuery,"sube_stock_yeterlilik_#dept_id_#","#stockta_yeterlilik_suresi#",query_count)>
        
        <cfset dept_satis_ = evaluate('ROW_ORT_STOK_SATIS_MIKTARI_#dept_id_#')>
        <cfset row_stock = evaluate('SUBE_STOCK_#dept_id_#')>
        <cfset row_yoldaki = evaluate('PURCHASE_ORDER_QUANTITY_#dept_id_#')>
        <cfset row_ship_internal = evaluate('SHIP_INTERNAL_#dept_id_#')>
        
		<cfif not len(dept_satis_)>
			<cfset dept_dagilim_ = 0>
        <cfelse>
            <cfset dept_dagilim_ = Ceiling(dept_satis_ * attributes.order_day)>
            
            <cfif isdefined("attributes.real_stock") and row_stock gt 0>
                <cfset dept_dagilim_ = dept_dagilim_ - row_stock>
            </cfif>		
            <cfif isdefined("attributes.way_stock")>
                <cfset dept_dagilim_ = dept_dagilim_ - row_yoldaki> 
            </cfif> 
            
            <cfif isdefined("attributes.ship_internal")>
            	<cfset dept_dagilim_ = dept_dagilim_ - row_ship_internal>
            </cfif>  
            
            <cfif dept_dagilim_ lt 0>
                <cfset dept_dagilim_ = 0>
            </cfif>                          
        </cfif>
        
        <!---
		<cfif kalan_stok gt 0 and kalan_stok gte dept_dagilim_>
        	<cfset reel_dagilim = dept_dagilim_>
            <cfset kalan_stok = kalan_stok - dept_dagilim_>
        <cfelseif kalan_stok gt 0 and kalan_stok lt dept_dagilim_>
        	<cfset reel_dagilim = kalan_stok>
            <cfset kalan_stok = 0>
        <cfelse>
        	<cfset reel_dagilim = 0>
        </cfif>
		--->
        
		<cfif attributes.transfer_type eq 0>
        	<cfif dept_dagilim_ gt 0 and toplam_ortalama>
                <cfset dagilim_payi = ceiling(wrk_round((DAGITILACAK_STOCK_ * dept_satis_) / toplam_ortalama))>
            <cfelse>
                <cfset dagilim_payi = 0>
            </cfif>
            
            <cfif dagilim_payi gt dept_dagilim_>
                <cfset dagilim_payi = dept_dagilim_>
            </cfif>
            
            <cfif kalan_stok gt 0 and kalan_stok gte dagilim_payi>
                <cfset reel_dagilim = dagilim_payi>
                <cfset kalan_stok = kalan_stok - dagilim_payi>
            <cfelseif kalan_stok gt 0 and kalan_stok lt dagilim_payi>
                <cfset reel_dagilim = kalan_stok>
                <cfset kalan_stok = 0>
            <cfelse>
                <cfset reel_dagilim = 0>
            </cfif>
        <cfelse>
        	<cfset reel_dagilim = 0>
            <cfif isdefined("dagilim_#stock_id#_#dept_id_#")>
            	<cfset reel_dagilim = evaluate('dagilim_#stock_id#_#dept_id_#')>
            </cfif>
        </cfif>
        
        <cfset temp = QuerySetCell(myQuery,"dagilim_#dept_id_#","#wrk_round(dept_dagilim_,0)#",query_count)>
        <cfset temp = QuerySetCell(myQuery,"reel_dagilim_#dept_id_#","#reel_dagilim#",query_count)>
        <cfset temp = QuerySetCell(myQuery,"yoldaki_#dept_id_#","#row_yoldaki#",query_count)>
        <cfset temp = QuerySetCell(myQuery,"ship_internal_#dept_id_#","#row_ship_internal#",query_count)>
        <cfif reel_dagilim gt 0>
        	<cfset temp = QuerySetCell(myQuery,"onay_#dept_id_#","1",query_count)>
        <cfelse>
			<cfset temp = QuerySetCell(myQuery,"onay_#dept_id_#","0",query_count)>
        </cfif>
    </cfloop>	
</cfoutput>

<cfif isdefined("attributes.yeter_limit") and len(attributes.yeter_limit)>
	<cfquery name="myQuery" dbtype="query">
    	SELECT * FROM myQuery WHERE SUBE_YETER <cfif attributes.yeter_type eq 0><=<cfelse>>=</cfif> #attributes.yeter_limit#
    </cfquery>
</cfif>

<cfset CRLF = Chr(13) & Chr(10)>
<cfset dataset = "">
<cfoutput query="myQuery">
	<cfset row_ = "">
	<cfloop list="#name_list#" index="columns">
    	<cfset deger_ = '"#trim(lcase(columns))#":"#trim(evaluate(columns))#"'>
        <cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    </cfloop>
    <cfset dataset = listappend(dataset,"{#row_##CRLF#}")>
</cfoutput>

<cfif not directoryexists('#upload_folder#retail\xml\')>
    <cfdirectory action="create" directory="#upload_folder#retail#dir_seperator#xml">
</cfif>
<cfset dataset = "[" & dataset & "]">
<cffile action="write" file="#upload_folder#retail\xml\transfer_#userid_#.txt" output="#dataset#" charset="utf-8">