<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: F.Gülşah TAN			Developer	: F.Gülşah TAN	
Analys Date : 24/05/2016			Dev Date	: 24/05/2016		
Description :
	Bu component ürünler objesine ait add,upd ve list fonksiyonlarını gerceklestirir.
----------------------------------------------------------------------->
<cfcomponent>	
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn1 = '#dsn#_product'>
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'>
    <cfset dsn2 = '#dsn#_#session.ep.company_id#'>
    <cfinclude template="../fbx_workcube_funcs.cfm">
	<!--- list --->
    <cffunction name="List" returntype="query">
        <cfargument name="price_catid" default="-1" type="numeric" required="no" hint="Ürün Fiyat Listesi Id">
        <cfargument name="pid" default="0" type="numeric" required="no" hint="Ürün Id" >
        <cfargument name="product_status" default="0" type="numeric" required="no" hint="Ürün Aktif/Pasif">
        <cfargument name="product_name" default="" type="string" required="no" hint="Ürün Adı">
        <cfargument name="barcode" default="" type="string" required="no" hint="Barkod">
        <cfargument name="product_types" default="0" type="numeric" required="no" hint="Ürün Bilgisi">
        <cfargument name="pos_code" default="" type="string" required="no" hint="Sorumlu Kod">
        <cfargument name="product_stages" default="0" type="numeric" required="no" hint="Süreç">
        <cfargument name="record_emp_id" default="0" type="numeric" required="no" hint="Kaydeden">
        <cfargument name="company_id" default="0" type="numeric" required="no" hint="Tedarikçi">
        <cfargument name="brand_id" default="0" type="numeric" required="no" hint="Marka Id">
        <cfargument name="brand_name" default="" type="string" required="no" hint="Marka Adı">
        <cfargument name="short_code_id" default="0" type="numeric" required="no" hint="Model Id">
        <cfargument name="short_code_name" default="" type="string" required="no" hint="Model Kod">
        <cfargument name="cat" default="0" type="numeric" required="no" hint="Kategori">
        <cfargument name="category_name" default="" type="string" required="no" hint="Kategori Adı">
        <cfargument name="keyword" default="" type="string" required="no" hint="Filtre">
        <cfargument name="special_code" default="" type="string" required="no" hint="Özel Kod">
        <cfargument name="list_property_id" default="0" type="numeric" required="no" hint="Ürün Özellikleri Id">
        <cfargument name="list_variation_id" default="0" type="numeric" required="no" hint="Ürün Varyasyon Id">
        <cfargument name="sort_type" default="0" type="numeric" required="no" hint="Ürün Listeleme Seçenekleri Değer">
        <cfargument name="startrow" default="0" type="numeric" required="no" hint="Başlangıç Değeri">
        <cfargument name="BARCODE1" default="0" type="numeric" required="no" hint="Filtre Barkod No">
        <cfargument name="PRODUCT_NAME1" default="0" type="numeric" required="no" hint="Filtre Ürün Adı">
        <cfargument name="SPECIAL_CODE1" default="0" type="numeric" required="no" hint="Filtre Özel Kod">
        <cfargument name="MANUFACT_CODE1" default="0" type="numeric" required="no" hint="Filtre Ürün Kodu">
        <cfargument name="USER_FRIENDLY_URL1" default="0" type="numeric" required="no" hint="Filtre Kullanıcı Dostu URL">
        <cfargument name="PRODUCT_CODE1" default="0" type="numeric" required="no" hint="Filtre Ürün Kodu">
        <cfargument name="PRODUCT_DETAIL1" default="0" type="numeric" required="no" hint="Filtre Ürün Detayı">
        <cfargument name="COMPANY_STOCK_CODE1" default="0" type="numeric" required="no" hint="Filtre Üye Stok Kodu">
        <cfargument name="COMPANY_PRODUCT_NAME1" default="0" type="numeric" required="no" hint="Filtre Üye Ürün Adı">
        <cfargument name="maxrows" default="0" type="numeric" required="no" hint="Maximum Sayı">
        <cfif arguments.PRODUCT_NAME1 neq 0 or arguments.BARCODE1 neq 0 or arguments.SPECIAL_CODE1 neq 0 or arguments.MANUFACT_CODE1 neq 0 or arguments.USER_FRIENDLY_URL1 neq 0 or arguments.PRODUCT_CODE1 neq 0 or arguments.PRODUCT_DETAIL1 neq 0 or arguments.COMPANY_STOCK_CODE1 neq 0 or arguments.COMPANY_PRODUCT_NAME1 neq 0>  
            <cfelse>
                <cfset arguments.BARCODE1 = 1 >            
                <cfset arguments.PRODUCT_NAME1 = 1 >
                <cfset arguments.SPECIAL_CODE1 = 1 >
                <cfset arguments.MANUFACT_CODE1 = 1 >
                <cfset arguments.USER_FRIENDLY_URL1 = 1 >
                <cfset arguments.PRODUCT_CODE1 = 1 >
                <cfset arguments.PRODUCT_DETAIL1 = 1 >
                <cfset arguments.COMPANY_STOCK_CODE1 = 1 >
                <cfset arguments.COMPANY_PRODUCT_NAME1 = 1 >
        </cfif>
        <cfquery name="GET_PRODUCT" datasource="#DSN3#">
            WITH CTE1 AS (
            SELECT
                P.PRODUCT_ID,
                P.PRODUCT_CODE,
                P.PRODUCT_STATUS,
                P.USER_FRIENDLY_URL ,
                P.PRODUCT_CODE_2,
                P.MANUFACT_CODE,
                PRODUCT_NAME,
                P.BARCOD,
                P.TAX,
                P.IS_ADD_XML,
                P.BRAND_ID,
                P.RECORD_MEMBER,
                P.RECORD_DATE,
                P.UPDATE_DATE,
                P.PROD_COMPETITIVE,
                P.MAX_MARGIN,
                P.MIN_MARGIN,
                P.IS_ZERO_STOCK,
                P.RECORD_BRANCH_ID,
                P.PRODUCT_STAGE,
                P.SHORT_CODE_ID,
                <cfif ((arguments.price_catid eq -1) or (arguments.price_catid eq -2)) and (arguments.price_catid neq 0)>
                    PS.PRICE,
                    PS.PRICE_KDV,
                    PS.IS_KDV,
                    PS.MONEY,
                <cfelseif  arguments.price_catid neq -1 and arguments.price_catid neq -2 and arguments.price_catid neq 0>
                    PR.MONEY,
                    PR.PRICE,
                    PR.PRICE_KDV,
                    PR.IS_KDV,
                </cfif>
                PU.PRODUCT_UNIT_ID,
                PU.ADD_UNIT,
                PU.MAIN_UNIT,
                P.PACKAGE_CONTROL_TYPE,
                P.OTV_AMOUNT,
                P.OTV,
                P.CUSTOMS_RECIPE_CODE,
                PTR.STAGE,
                PB.BRAND_NAME,
                PBM.MODEL_NAME
            FROM 
                PRODUCT P
                    LEFT JOIN #dsn#.PROCESS_TYPE_ROWS PTR 
                        ON PTR.PROCESS_ROW_ID = P.PRODUCT_STAGE
                    LEFT JOIN #dsn3#.PRODUCT_COMP_PERM PCP 
                        ON PCP.COMPETITIVE_ID = P.PROD_COMPETITIVE  AND PCP.POSITION_CODE = #session.ep.position_code# 
                    LEFT JOIN #dsn1#.PRODUCT_BRANDS PB  
                        ON PB.BRAND_ID = P.BRAND_ID
                    LEFT JOIN #dsn1#.PRODUCT_BRANDS_MODEL PBM
                        ON PBM.MODEL_ID = P.SHORT_CODE_ID
            <cfif (arguments.price_catid eq -1  or arguments.price_catid eq -2) and arguments.price_catid neq 0>
                ,PRICE_STANDART PS,
            <cfelseif (arguments.price_catid neq -1 and arguments.price_catid neq -2) and arguments.price_catid neq 0>
                ,PRICE PR,
            </cfif>
            <cfif session.ep.isBranchAuthorization>#dsn1#.PRODUCT_BRANCH PBR,</cfif><!--- FB 20070702 sube icin --->
                PRODUCT_UNIT PU
            WHERE
            <cfif arguments.pid neq 0>
                P.PRODUCT_ID = #pid# AND
            </cfif>
                P.PRODUCT_ID = PU.PRODUCT_ID AND
                PU.PRODUCT_UNIT_STATUS = 1 AND
            <cfif (arguments.product_status neq 0 and (arguments.product_status neq 2))>
                PRODUCT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#product_status#"> AND
            </cfif>
            <cfif arguments.product_types neq 0 and (arguments.product_types eq 1)>
                P.IS_PURCHASE = 1 AND
            <cfelseif arguments.product_types neq 0 and (arguments.product_types eq 2)>
                P.IS_INVENTORY = 0 AND
            <cfelseif arguments.product_types neq 0 and (arguments.product_types eq 3)>
                P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0 AND
            <cfelseif arguments.product_types neq 0 and (arguments.product_types eq 4)>
                P.IS_TERAZI = 1 AND
            <cfelseif arguments.product_types neq 0 and (arguments.product_types eq 5)>
                P.IS_PURCHASE = 0 AND
            <cfelseif arguments.product_types neq 0 and (arguments.product_types eq 6)>
                P.IS_PRODUCTION = 1 AND
            <cfelseif arguments.product_types neq 0 and (arguments.product_types eq 7)>
                P.IS_SERIAL_NO = 1 AND
            <cfelseif arguments.product_types neq 0 and (arguments.product_types eq 8)>
                P.IS_KARMA = 1 AND
            <cfelseif arguments.product_types neq 0 and (arguments.product_types eq 9)>
                P.IS_INTERNET = 1 AND
            <cfelseif arguments.product_types neq 0 and (arguments.product_types eq 10)>
                P.IS_PROTOTYPE = 1 AND
            <cfelseif arguments.product_types neq 0 and (arguments.product_types eq 11)>
                P.IS_ZERO_STOCK = 1 AND
            <cfelseif arguments.product_types neq 0 and (arguments.product_types eq 12)>
                P.IS_EXTRANET = 1 AND
            <cfelseif arguments.product_types neq 0 and (arguments.product_types eq 13)>
                P.IS_COST = 1 AND
            <cfelseif arguments.product_types neq 0 and (arguments.product_types eq 14)>
                P.IS_SALES = 1 AND
            <cfelseif arguments.product_types neq 0 and (arguments.product_types eq 15)>
                P.IS_QUALITY = 1 AND
            <cfelseif arguments.product_types neq 0 and (arguments.product_types eq 16)>
                P.IS_INVENTORY = 1 AND
            <cfelseif arguments.product_types neq 0 and (arguments.product_types eq 17)>
                P.IS_LOT_NO = 1 AND
            </cfif>
            <cfif isdefined("arguments.pos_code") and len(arguments.pos_code)>
                P.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#pos_code#"> AND
            </cfif>
            <cfif arguments.product_stages neq 0>
                PRODUCT_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_stages#"> AND
            </cfif>
            <cfif arguments.record_emp_id neq 0>
                P.RECORD_MEMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#record_emp_id#"> AND
            </cfif>
            <cfif arguments.company_id neq 0>
                (
                    P.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#company_id#"> OR
                    P.PRODUCT_ID IN (SELECT PRODUCT_ID FROM CONTRACT_PURCHASE_PROD_DISCOUNT WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#company_id#"> AND START_DATE <= #now()# AND FINISH_DATE >= #now()#)
                )
                AND
            </cfif>
            <cfif arguments.brand_id neq 0 and len(arguments.brand_name)>
                P.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#brand_id#"> AND
            </cfif>
            <cfif arguments.short_code_id neq 0 and len(arguments.short_code_name)>
                P.SHORT_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#short_code_id#"> AND
            </cfif>				
            <cfif arguments.cat neq 0 and len(arguments.category_name)>
                P.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cat#.%"> AND
            </cfif>
            <cfif (arguments.price_catid neq 0 and (arguments.price_catid eq -1)) or (arguments.price_catid neq 0 and (arguments.price_catid eq -2))>
                PS.PURCHASESALES = <cfif (arguments.price_catid eq -1)>0<cfelse>1</cfif> AND
                PS.PRICESTANDART_STATUS = 1 AND	
                P.PRODUCT_ID = PS.PRODUCT_ID AND
                PS.UNIT_ID = PU.PRODUCT_UNIT_ID AND
                PU.PRODUCT_UNIT_STATUS = 1
            <cfelseif arguments.price_catid neq 0 and (arguments.price_catid neq -1) and (arguments.price_catid neq -2)>
                PR.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#price_catid#"> AND
                PR.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
                (PR.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> OR PR.FINISHDATE IS NULL) AND
                P.PRODUCT_ID = PR.PRODUCT_ID AND
                ISNULL(PR.STOCK_ID,0) = 0 AND
                ISNULL(PR.SPECT_VAR_ID,0) = 0 AND
                PR.UNIT = PU.PRODUCT_UNIT_ID AND
                PU.PRODUCT_UNIT_STATUS = 1
            </cfif>
                <cfif isdefined('arguments.keyword') and len(arguments.keyword)>
                  AND 
                        (
                             (1=2)  
                            <cfif arguments.PRODUCT_NAME1 neq 0>
                                OR ( P.PRODUCT_NAME  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> ) 
                            </cfif>                                
                            <cfif arguments.BARCODE1 neq 0>
                                OR (P.BARCOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)									
                            </cfif> 
                            <cfif arguments.SPECIAL_CODE1 neq 0>
                                OR (P.PRODUCT_CODE_2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)									
                            </cfif> 
                            <cfif arguments.MANUFACT_CODE1 neq 0>
                                OR (P.MANUFACT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)									
                            </cfif>
                            <cfif arguments.USER_FRIENDLY_URL1 neq 0>
                                OR (P.USER_FRIENDLY_URL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)									
                            </cfif>
                            <cfif arguments.PRODUCT_CODE1 neq 0>
                                OR (P.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)									
                            </cfif>
                             <cfif arguments.PRODUCT_DETAIL1 neq 0>
                                OR (P.PRODUCT_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)									
                            </cfif>
                             <cfif arguments.COMPANY_STOCK_CODE1 neq 0>
                                OR P.PRODUCT_ID IN (SELECT STOCKS.PRODUCT_ID FROM STOCKS,#dsn1#.SETUP_COMPANY_STOCK_CODE SCSC WHERE STOCKS.STOCK_ID = SCSC.STOCK_ID AND (SCSC.COMPANY_STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">))									
                            </cfif>
                            <cfif arguments.COMPANY_PRODUCT_NAME1 neq 0>
                                OR P.PRODUCT_ID IN (SELECT STOCKS.PRODUCT_ID FROM STOCKS,#dsn1#.SETUP_COMPANY_STOCK_CODE SCSC WHERE STOCKS.STOCK_ID = SCSC.STOCK_ID AND SCSC.COMPANY_PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)
                            </cfif>
                         )
                 </cfif>
            <cfif isDefined("arguments.special_code") and len(arguments.special_code)>
                AND P.PRODUCT_CODE_2 LIKE '<cfif len(arguments.special_code) gt 2>%</cfif>#special_code#%'
            </cfif>
            <cfif  arguments.list_property_id neq 0 and arguments.list_variation_id neq 0>
                        AND P.PRODUCT_ID IN
                        (
                            SELECT
                                PRODUCT_ID
                            FROM
                                #dsn1#.PRODUCT_DT_PROPERTIES PRODUCT_DT_PROPERTIES
                            WHERE
                                <cfloop from="1" to="#listlen(list_property_id,',')#" index="pro_index">
                                PRODUCT_ID IN (
        
                                                SELECT 
                                                    PRODUCT_ID
                                                FROM
                                                    #dsn1#.PRODUCT_DT_PROPERTIES PRODUCT_DT_PROPERTIES 
                                                WHERE
                                                    (
                                                    PROPERTY_ID = #ListGetAt(list_property_id,pro_index,",")# AND VARIATION_ID = #ListGetAt(list_variation_id,pro_index,",")#
                                                    <cfif ListGetAt(list_property_value,pro_index,",") neq 'empty'>AND(TOTAL_MAX=#ListGetAt(list_property_value,pro_index,",")# OR TOTAL_MIN=#ListGetAt(list_property_value,pro_index,",")#)</cfif>
                                                    )
                                                  GROUP BY 
                                                    PRODUCT_ID  
                                            ) 
                                <cfif pro_index lt listlen(list_property_id,',')>AND</cfif>
                                </cfloop>
                        )
                    </cfif>
        
            <cfif session.ep.isBranchAuthorization> <!--- FB 20070702 yetkili subelerdeki urunler --->
                AND PBR.PRODUCT_ID = P.PRODUCT_ID
                AND PBR.BRANCH_ID IN  (SELECT
                                            B.BRANCH_ID
                                        FROM 
                                            #dsn#.BRANCH B, 
                                            #dsn#.EMPLOYEE_POSITION_BRANCHES EPB
                                        WHERE 
                                            EPB.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
                                            EPB.BRANCH_ID = B.BRANCH_ID )	
            </cfif>
                
               ),
               CTE2 AS (
                    SELECT
                        CTE1.*,
                        ROW_NUMBER() OVER (	ORDER BY
                                                <cfif arguments.sort_type eq 1>                                                   
                                                     PRODUCT_NAME                                                     
                                                <cfelseif arguments.sort_type eq 2>
                                                    PRODUCT_CODE
                                                <cfelseif arguments.sort_type eq 3>
                                                    PRODUCT_CODE DESC
                                                <cfelseif arguments.sort_type eq 4>
                                                    PRODUCT_CODE_2 
                                                <cfelseif arguments.sort_type eq 5>
                                                    PRODUCT_CODE_2 DESC
                                                <cfelseif  arguments.sort_type eq 6>
                                                    BARCOD 
                                                <cfelseif arguments.sort_type eq 7>
                                                    BARCOD DESC
                                                <cfelseif arguments.sort_type eq 8>
                                                    ISNULL(UPDATE_DATE,RECORD_DATE)
                                                <cfelseif arguments.sort_type eq 9>
                                                    ISNULL(UPDATE_DATE,RECORD_DATE) DESC
                                                <cfelse>                                                  
                                                     PRODUCT_NAME                                                  
                                                </cfif>
                                        ) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                    FROM
                        CTE1
                )
                SELECT
                    CTE2.*
                FROM
                    CTE2
                WHERE
                    RowNum BETWEEN #startrow# and #startrow#+(#maxrows#-1)
        </cfquery>    
        <cfreturn GET_PRODUCT>
    </cffunction>
    
    <!---get --->
    <cffunction name="get" returntype="query">
    	<cfargument name="product_id" required="yes" type="numeric" hint="Ürün Id"> 
        <cfquery name="get" datasource="#dsn3#">
            SELECT 
                C.FULLNAME COMPANY,
                PC.PRODUCT_CAT,
                PC.HIERARCHY,
                PB.BRAND_CODE,
                PB.BRAND_NAME,
                PBM.MODEL_NAME,            
                PRODUCT_UNIT.IS_SHIP_UNIT,
                PRODUCT_UNIT.MAIN_UNIT_ID,
                PRODUCT_UNIT.WEIGHT,
                PRODUCT_UNIT.DIMENTION,
                PRODUCT_UNIT.VOLUME,
                P.TAX,
                P.OTV,
                P.TAX_PURCHASE,
                P.MIN_MARGIN,
                P.MAX_MARGIN,
                P.PRODUCT_DETAIL,
                P.BARCOD,
                P.PRODUCT_CODE_2,
                P.BRAND_ID,
                P.PRODUCT_NAME,
                P.PRODUCT_MANAGER,
                P.PROD_COMPETITIVE,
                P.SEGMENT_ID,
                P.SHELF_LIFE,
                P.COMPANY_ID,
                P.PACKAGE_CONTROL_TYPE,
                P.IS_TERAZI,
                P.IS_COST,
                P.IS_KARMA,
                P.IS_LIMITED_STOCK,
                P.IS_SERIAL_NO,
                P.IS_ZERO_STOCK,
                P.IS_EXTRANET,
                P.IS_INTERNET,
                P.IS_PURCHASE,
                P.IS_SALES,
                P.IS_PRODUCTION,
                P.IS_INVENTORY,
                P.IS_PROTOTYPE,
                P.IS_GIFT_CARD,
                P.IS_QUALITY,
                P.GIFT_VALID_DAY,
                P.MANUFACT_CODE,
                P.BRAND_ID,
                P.PRODUCT_CATID,
                P.SHORT_CODE,
                P.SHORT_CODE_ID,
                P.CUSTOMS_RECIPE_CODE,
                P.IS_LOT_NO,
                PCP.POSITION_CODE,*
            FROM 
                #dsn3#.PRODUCT P
                LEFT JOIN #dsn1#.PRODUCT_CAT_POSITIONS PCP
                    ON PCP.PRODUCT_CAT_ID = P.PRODUCT_CATID
                LEFT JOIN PRODUCT_UNIT ON P.PRODUCT_ID = PRODUCT_UNIT.PRODUCT_ID AND IS_MAIN=1
                LEFT JOIN PRODUCT_CAT PC 
                    ON P.PRODUCT_CATID = PC.PRODUCT_CATID
                LEFT JOIN PRODUCT_BRANDS PB 
                    ON P.BRAND_ID = PB.BRAND_ID
                LEFT JOIN #dsn1#.PRODUCT_BRANDS_MODEL PBM 
                    ON SHORT_CODE_ID = PBM.MODEL_ID
                LEFT JOIN #dsn#.COMPANY C 
                    ON C.COMPANY_ID = P.COMPANY_ID
            WHERE
                P.PRODUCT_ID = #arguments.product_id#
        </cfquery>
        <cfreturn get>
    </cffunction>
    <!--- add --->    
    <cffunction name="add" access="public" returntype="string">
        <cfargument name="product_catid" type="numeric" default="0" required="yes" hint="Ürün Kategori Id">
        <cfargument name="acc_code_cat" type="numeric" default="0" required="no" hint="Muhasebe Kod Grubu">
        <cfargument name="segment_id" type="numeric" default="0" required="no" hint="Hedef Pazar">
        <cfargument name="product_manager" type="numeric" default="0" required="no" hint="Sorumlu">
        <cfargument name="is_quality" type="numeric" default="0" required="no" hint="Kalite">
        <cfargument name="is_cost" type="numeric" default="0" required="no" hint="Maliyet">
        <cfargument name="is_inventory" type="numeric" default="0" required="no" hint="Envanter">
        <cfargument name="is_production" type="numeric" default="0" required="no" hint="Üretim">
        <cfargument name="is_sales" type="numeric" default="0" required="no" hint="Satış">
        <cfargument name="is_purchase" type="numeric" default="0" required="no" hint="Tedarik">
        <cfargument name="is_prototype" type="numeric" default="0" required="no" hint="Prototip">
        <cfargument name="is_terazi" type="numeric" default="0" required="no" hint="Terazi">
        <cfargument name="is_serial_no" type="numeric" default="0" required="no" hint="Seri No">
        <cfargument name="is_zero_stock" type="numeric" default="0" required="no" hint="Sıfır Stok">
        <cfargument name="is_karma" type="numeric" default="0" required="no" hint="Karma Koli">
        <cfargument name="is_limited_stock" type="numeric" default="0" required="no" hint="Stoklarla Sınırlı">
        <cfargument name="is_lot_no" type="numeric" default="0" required="no" hint="Lot No">
        <cfargument name="product_name" type="string" default="NULL" required="yes" hint="Ürün Adı">
        <cfargument name="tax" type="numeric" default="0" required="no" hint="Satış KDV">
        <cfargument name="tax_purchase" type="numeric" default="0" required="no" hint="Alış KDV">
        <cfargument name="barcod" type="string" default="NULL" required="no" hint="Barkod">
        <cfargument name="product_detail" type="string" default="NULL" required="no" hint="Açıklama">
        <cfargument name="company_id" type="numeric" default="0" required="no" hint="Tedarikçi Id">
        <cfargument name="brand_name" type="string" default="NULL" required="no" hint="Marka Adı">
        <cfargument name="brand_id" type="numeric" default="0" required="no" hint="Marka Id">
        <cfargument name="product_code" type="string" default="NULL" required="yes" hint="Ürün Kodu">
        <cfargument name="manufact_code" type="string" default="NULL" required="no" hint="Üretici ürün Kodu">
        <cfargument name="shelf_life" type="numeric" default="0" required="no" hint="Raf Ömrü">
        <cfargument name="is_internet" type="numeric" default="0" required="no" hint="İnternet">
        <cfargument name="prod_comp" type="numeric" default="0" required="no" hint="Fiyat Yetkisi">
        <cfargument name="process_stage" type="numeric" default="0" required="no" hint="Süreç">
        <cfargument name="min_margin" type="numeric" default="0" required="no" hint="Minimum Marj">
        <cfargument name="max_margin" type="numeric" default="0" required="no" hint="Maximum Marj">
        <cfargument name="OTV" type="numeric" default="0" required="no" hint="ÖTV">
        <cfargument name="OTV_AMOUNT" type="numeric" default="0" required="no" hint="OTV Miktar">
        <cfargument name="product_code_2" type="string" default="NULL" required="no" hint="Özel Kod">
        <cfargument name="short_code" type="string" default="NULL" required="no" hint="Model Kod">
        <cfargument name="short_code_id" type="numeric" default="0" required="no" hint="Model Id">
        <cfargument name="work_product_name" type="string" default="NULL" required="no" hint="İşçilik Ürünü">
        <cfargument name="work_stock_id" type="numeric" default="0" required="no" hint="İşçilik Ürünü Id">
        <cfargument name="work_stock_amount" type="numeric" default="0" required="no" hint="İşçilik Ürünü Miktar">
        <cfargument name="package_control_type" type="numeric" default="0" required="no" hint="Paket Kontrol Tipi">
        <cfargument name="is_commission" type="numeric" default="0" required="no" hint="Pos Komisyonu Hesapla">
        <cfargument name="is_gift_card" type="numeric" default="0" required="no" hint="Hediye Kartı">
        <cfargument name="gift_valid_day" type="numeric" default="0" required="no" hint="Geçerlilik Günü">
        <cfargument name="customs_recipe_code" type="string" default="NULL" required="no" hint="Gümrük Tarife Kodu">
        <cfargument name="weight" type="numeric" default="0" required="no" hint="Ağırlık">
        <cfargument name="dimention" type="numeric" default="0" required="no" hint="Boyut">
        <cfargument name="volume" type="numeric" default="0" required="no" hint="Hacim">
        <cfargument name="money_id_sa" type="string" default="NULL" required="no" hint="Standart Alış Para Birimi">
        <cfargument name="maximum_stock" type="numeric" default="0" required="no" hint="Maksimum Stok">
        <cfargument name="provision_time" type="numeric" default="0" required="no" hint="Tedarik Süresi">
        <cfargument name="repeat_stock_value" type="numeric" default="0" required="no" hint="Yeniden Sipariş Noktası">
        <cfargument name="minimum_stock" type="numeric" default="0" required="no" hint="Minumum Stok">
        <cfargument name="minimum_order_stock_value" type="numeric" default="0" required="no" hint="Minimum Sipariş Miktarı">
        <cfargument name="is_live_order" type="numeric" default="0" required="no" hint="Yeni Sipariş Noktasında Uyarı Ver">
        <cfargument name="strategy_type" type="numeric" default="0" required="yes" hint="Strateji Türü">
        <cfargument name="strategy_order_type" type="numeric" default="0" required="no" hint="Sipariş Tipi">
        <cfargument name="block_stock_value" type="numeric" default="0" required="no" hint="Bloke Stok Miktarı">
        <cfargument name="saleable_stock_action_id" type="numeric" default="0" required="no" hint="Satılabilir Stok Prensipleri">
        <cfargument name="user_friendly_url" type="string" default="NULL" required="no" hint="Kullanıcı Dostu Url">
        <cfargument name="purchase" type="numeric" default="0" required="no" hint="Standart Alış">
        <cfargument name="price" type="numeric" default="0" required="no" hint="Standart Satış">
        <cfargument name="is_tax_included_sales" type="numeric" default="0" required="no" hint="KDV Dahil">
        <cfargument name="property_row_count" type="numeric" default="0" required="no" hint="Ürün Özellik Sayısı">
        <cfargument name="is_tax_included_purchase" type="numeric" default="0" required="no" hint="Standart Alış KDV DH">
        <cfargument name="brand_code" type="string" default="NULL" required="no" hint="Marka Kodu">
        <cfargument name="product_status" type="numeric" default="0" required="no" hint="Ürün Aktif/Pasif">
        <cfargument name="MONEY_ID_SS" type="string" default="TL" required="no" hint="Standart Satiş Para Birimi">
        <cfset list="',""">
        <cfset list2=" , ">
        <cfset max_product_id="">
        <cfset arguments.PRODUCT_NAME = replacelist(arguments.PRODUCT_NAME,list,list2)><!--- ürün adına tek ve cift tirnak yazilmamali --->
        <cfset arguments.PRODUCT_NAME = trim(arguments.PRODUCT_NAME)>
        <cfset arguments.BARCOD=trim(arguments.BARCOD)>
        <!--- ürün kodunu hierarchye göre oluşturalım --->
        <cfquery name="GET_OUR_COMPANY_INFO" datasource="#dsn1#">
            SELECT IS_BRAND_TO_CODE,IS_PRODUCT_COMPANY FROM #dsn#.OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
        </cfquery>
        <cfquery name="GET_PRODUCT_CAT" datasource="#dsn1#">
            SELECT HIERARCHY FROM #dsn1#.PRODUCT_CAT WHERE PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_catid#">
        </cfquery>
        <cfset arguments.product_code="#trim(arguments.product_code)#">
        <cfset arguments.product_code="#get_product_cat.hierarchy#.#arguments.product_code#">
        <cfset product_code_2_format="#arguments.brand_code#.#listlast(get_product_cat.hierarchy,'.')#.#arguments.short_code#">
        <!--- ürün kodu oluştu --->
        <cfset bugun_00 = DateFormat(now(),'dd/mm/yyyy')>
        <cf_date tarih='bugun_00'>
        
        <cfif isdefined('arguments.acc_code_cat') and len(arguments.acc_code_cat)>
            <cfquery name="GET_CODES" datasource="#dsn1#">
                SELECT * FROM #dsn3#.SETUP_PRODUCT_PERIOD_CAT WHERE PRO_CODE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.acc_code_cat#">
            </cfquery>
            <cfquery name="GET_OTHER_PERIOD" datasource="#dsn1#">
                SELECT PERIOD_ID FROM #dsn#.SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.COMPANY_ID#">
            </cfquery>
        <cfelse>
            <cfset get_codes.recordcount = 0>
        </cfif>
        <cfquery name="ADD_PRODUCT" datasource="#dsn1#" result="MAX_ID">
            INSERT INTO 
                #dsn1#.PRODUCT
            (
                PRODUCT_STATUS,
                IS_QUALITY,
                IS_COST,
                IS_INVENTORY,
                IS_PRODUCTION,
                IS_SALES,
                IS_PURCHASE,
                IS_PROTOTYPE,
                IS_TERAZI,
                IS_SERIAL_NO,
                IS_ZERO_STOCK,
                IS_KARMA,
                IS_LIMITED_STOCK,
                IS_LOT_NO,
                PRODUCT_CATID,
                PRODUCT_NAME,
                TAX,
                TAX_PURCHASE,
                BARCOD,
                PRODUCT_DETAIL,
                COMPANY_ID,
                BRAND_ID,
                RECORD_DATE,
                RECORD_MEMBER,
                MEMBER_TYPE,
                PRODUCT_CODE,
                MANUFACT_CODE,
                SHELF_LIFE,
                <cfif isDefined('arguments.SEGMENT_ID') and len(arguments.SEGMENT_ID)>
                SEGMENT_ID,
                </cfif>
                <cfif isDefined('arguments.PRODUCT_MANAGER') and len(arguments.PRODUCT_MANAGER)>
                PRODUCT_MANAGER,
                </cfif>
                IS_INTERNET,
                IS_EXTRANET,
                PROD_COMPETITIVE,
                PRODUCT_STAGE,
                MIN_MARGIN,
                MAX_MARGIN,
                OTV,
                PRODUCT_CODE_2,
                SHORT_CODE,
                SHORT_CODE_ID,
                WORK_STOCK_ID,
                WORK_STOCK_AMOUNT,
                RECORD_BRANCH_ID,
                PACKAGE_CONTROL_TYPE,
                IS_COMMISSION,
                IS_GIFT_CARD,
                GIFT_VALID_DAY,
                CUSTOMS_RECIPE_CODE
            )
            VALUES 
            (
                <cfif isDefined("arguments.product_status") and arguments.product_status eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                <cfif isDefined("arguments.is_quality") and arguments.is_quality eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                <cfif isDefined("arguments.IS_COST") and arguments.IS_COST eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                <cfif isDefined("arguments.IS_INVENTORY") and arguments.IS_INVENTORY eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                <cfif isDefined("arguments.IS_PRODUCTION") and arguments.IS_PRODUCTION eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                <cfif isDefined("arguments.IS_SALES") and arguments.IS_SALES eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                <cfif isDefined("arguments.IS_PURCHASE") and arguments.IS_PURCHASE eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                <cfif isDefined("arguments.IS_PROTOTYPE") and arguments.IS_PROTOTYPE eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                <cfif isDefined("arguments.IS_TERAZI") and arguments.IS_TERAZI eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                <cfif isDefined("arguments.IS_SERIAL_NO") and arguments.IS_SERIAL_NO eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                <cfif isDefined("arguments.IS_ZERO_STOCK") and arguments.IS_ZERO_STOCK eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                <cfif isDefined("arguments.IS_KARMA") and arguments.IS_KARMA eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                <cfif isDefined("arguments.is_limited_stock") and arguments.is_limited_stock eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                <cfif isDefined("arguments.IS_LOT_NO") and arguments.IS_LOT_NO eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_CATID#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PRODUCT_NAME#">,
                <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.TAX#">,					
                <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.TAX_PURCHASE#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.BARCOD#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PRODUCT_DETAIL#">,
                <cfif not len(arguments.COMPANY_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.COMPANY_ID#"></cfif>,
                <cfif len(arguments.brand_name) and len(arguments.brand_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.BRAND_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#SESSION.EP.USERKEY#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PRODUCT_CODE#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MANUFACT_CODE#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SHELF_LIFE#">,
                <cfif isDefined('arguments.SEGMENT_ID') and len(arguments.SEGMENT_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SEGMENT_ID#">,</cfif>
                <cfif isDefined('arguments.PRODUCT_MANAGER') and len(arguments.PRODUCT_MANAGER)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_MANAGER#">,</cfif>
                <cfif isDefined('arguments.is_internet') and arguments.is_internet eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1">,<cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0">,</cfif>
                <cfif isDefined('arguments.is_extranet') and arguments.is_extranet eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1">,<cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0">,</cfif>
                <cfif isDefined('arguments.prod_comp') and len(arguments.prod_comp)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.prod_comp#">,<cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">,</cfif>
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
                <cfif isDefined('arguments.MIN_MARGIN') and len(arguments.MIN_MARGIN)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.min_margin#"><cfelse>0</cfif>,
                <cfif isDefined('arguments.MAX_MARGIN') and len(arguments.MAX_MARGIN)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.max_margin#"><cfelse>0</cfif>,
                <cfif isDefined('arguments.OTV') and len(arguments.OTV)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.OTV#"><cfelse><cfqueryparam cfsqltype="cf_sql_float" value="" null="yes"></cfif>,
                <cfif get_our_company_info.is_brand_to_code>
                    <cfif len(arguments.product_code_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_code_2#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#product_code_2_format#"></cfif>,
                <cfelse>
                    <cfif len(arguments.product_code_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_code_2#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                </cfif>
                <cfif len(arguments.short_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SHORT_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                <cfif len(arguments.short_code_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.short_code_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                <cfif isdefined('arguments.work_product_name') and len(arguments.work_product_name) and len(arguments.work_stock_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.work_stock_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                <cfif isdefined('arguments.work_product_name') and len(arguments.work_product_name) and len(arguments.work_stock_id) and len(arguments.work_stock_amount)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.work_stock_amount#"><cfelse><cfqueryparam cfsqltype="cf_sql_float" value="" null="yes"></cfif>,
                <cfif session.ep.isBranchAuthorization><cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                <cfif isdefined('arguments.PACKAGE_CONTROL_TYPE') and len(arguments.PACKAGE_CONTROL_TYPE)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PACKAGE_CONTROL_TYPE#">,<cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">,</cfif>
                <cfif isDefined("arguments.is_commission") and arguments.is_commission eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                <cfif isDefined("arguments.is_gift_card") and arguments.is_gift_card eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                <cfif isDefined('arguments.gift_valid_day') and len(arguments.gift_valid_day)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.gift_valid_day#"><cfelse>NULL</cfif>,				
                <cfif isdefined("arguments.customs_recipe_code") and len(arguments.customs_recipe_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.customs_recipe_code#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>
            )
        </cfquery>   
        <cfquery name="GET_PID" datasource="#dsn1#">
            SELECT MAX(PRODUCT_ID) AS PRODUCT_ID FROM #dsn1#.PRODUCT
        </cfquery>
        <cfset pid = GET_PID.PRODUCT_ID>
        <cfif GET_OUR_COMPANY_INFO.IS_PRODUCT_COMPANY EQ 1>
            <cfquery name="add_general_parameters2" datasource="#dsn1#">
                INSERT INTO #dsn1#.PRODUCT_GENERAL_PARAMETERS
                (
                    PRODUCT_ID,
                    COMPANY_ID, 
                    OUR_COMPANY_ID,
                    PRODUCT_MANAGER,
                    PRODUCT_STATUS, 
                    IS_INVENTORY, 
                    IS_PRODUCTION, 
                    IS_SALES, 
                    IS_PURCHASE, 
                    IS_PROTOTYPE,
                    IS_INTERNET, 
                    IS_EXTRANET, 
                    IS_TERAZI, 
                    IS_KARMA, 
                    IS_ZERO_STOCK, 
                    IS_LIMITED_STOCK, 
                    IS_SERIAL_NO, 
                    IS_COST, 
                    IS_QUALITY, 
                    IS_COMMISSION,
                    IS_GIFT_CARD,
                    IS_LOT_NO,
                    GIFT_VALID_DAY
                )
                VALUES
                (
                    #pid#, 
                    <cfif arguments.COMPANY_ID is ""><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.COMPANY_ID#"></cfif>,
                    #session.ep.company_id#,
                    <cfif isDefined('arguments.PRODUCT_MANAGER') and len(arguments.PRODUCT_MANAGER)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_MANAGER#"><cfelse>NULL</cfif>,
                    <cfif isDefined("arguments.PRODUCT_STATUS")><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("arguments.is_inventory") and arguments.is_inventory eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("arguments.is_production") and arguments.is_production eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
                    <cfif isDefined("arguments.is_sales") and arguments.is_sales eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
                    <cfif isDefined("arguments.is_purchase") and arguments.is_purchase eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
                    <cfif isDefined("arguments.is_prototype") and arguments.is_prototype eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("arguments.is_internet") and arguments.is_internet eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("arguments.is_extranet") and arguments.is_extranet eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
                    <cfif isDefined("arguments.is_terazi") and arguments.is_terazi eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("arguments.is_karma") and arguments.is_karma eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("arguments.is_zero_stock") and arguments.is_zero_stock eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("arguments.is_limited_stock") and arguments.is_limited_stock eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("arguments.is_serial_no") and arguments.is_serial_no eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("arguments.is_cost") and arguments.is_cost eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("arguments.is_quality") and arguments.is_quality eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("arguments.is_commission") and arguments.is_commission eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined('arguments.is_gift_card')><cfqueryparam cfsqltype="cf_sql_integer" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="0"></cfif>,
                    <cfif isDefined("arguments.is_lot_no") and arguments.is_lot_no eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined('arguments.gift_valid_day') and len(arguments.gift_valid_day)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.gift_valid_day#"><cfelse>NULL</cfif>
                )
            </cfquery>
        </cfif>
        <cfif GET_CODES.recordcount and GET_OTHER_PERIOD.recordcount>
            <cfloop list="#ValueList(GET_OTHER_PERIOD.PERIOD_ID)#" index="i">
                <cfquery name="ADD_MAIN_UNIT" datasource="#dsn1#">
                    INSERT INTO
                        #dsn3#.PRODUCT_PERIOD
                    (
                        PRODUCT_ID,  
                        PERIOD_ID,
                        ACCOUNT_CODE,
                        ACCOUNT_CODE_PUR,
                        ACCOUNT_DISCOUNT,
                        ACCOUNT_PRICE,
                        ACCOUNT_PUR_IADE,
                        ACCOUNT_IADE,
                        ACCOUNT_DISCOUNT_PUR,
                        ACCOUNT_YURTDISI,					
                        ACCOUNT_YURTDISI_PUR,
                        EXPENSE_CENTER_ID,
                        EXPENSE_ITEM_ID,
                        INCOME_ITEM_ID,
                        EXPENSE_TEMPLATE_ID,
                        ACTIVITY_TYPE_ID,
                        COST_EXPENSE_CENTER_ID,
                        INCOME_ACTIVITY_TYPE_ID,
                        INCOME_TEMPLATE_ID,
                        ACCOUNT_LOSS,
                        ACCOUNT_EXPENDITURE,
                        OVER_COUNT,
                        UNDER_COUNT,
                        PRODUCTION_COST,
                        HALF_PRODUCTION_COST,
                        SALE_PRODUCT_COST,
                        MATERIAL_CODE,
                        KONSINYE_PUR_CODE,
                        KONSINYE_SALE_CODE,
                        KONSINYE_SALE_NAZ_CODE,
                        DIMM_CODE,
                        DIMM_YANS_CODE,
                        PROMOTION_CODE,
                        PRODUCT_PERIOD_CAT_ID,
                        ACCOUNT_PRICE_PUR,
                        MATERIAL_CODE_SALE,
                        PRODUCTION_COST_SALE,
                        SALE_MANUFACTURED_COST,
                        PROVIDED_PROGRESS_CODE,
                        SCRAP_CODE_SALE,
                        SCRAP_CODE,
                        PROD_GENERAL_CODE,
                        PROD_LABOR_COST_CODE,
                        RECEIVED_PROGRESS_CODE,
                        INVENTORY_CAT_ID,
                        INVENTORY_CODE,
                        AMORTIZATION_METHOD_ID,
                        AMORTIZATION_TYPE_ID,
                        AMORTIZATION_EXP_CENTER_ID,
                        AMORTIZATION_EXP_ITEM_ID,
                        AMORTIZATION_CODE
                    )
                    VALUES 
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PID.PRODUCT_ID#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">,
                        <cfif len(GET_CODES.ACCOUNT_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.ACCOUNT_CODE_PUR)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_CODE_PUR#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.ACCOUNT_DISCOUNT)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_DISCOUNT#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.ACCOUNT_PRICE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_PRICE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.ACCOUNT_PUR_IADE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_PUR_IADE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.ACCOUNT_IADE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_IADE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.ACCOUNT_DISCOUNT_PUR)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_DISCOUNT_PUR#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.ACCOUNT_YURTDISI)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_YURTDISI#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.ACCOUNT_YURTDISI_PUR)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_YURTDISI_PUR#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.INC_CENTER_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.INC_CENTER_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.EXP_ITEM_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.EXP_ITEM_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.INC_ITEM_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.INC_ITEM_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.EXP_TEMPLATE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.EXP_TEMPLATE_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.EXP_ACTIVITY_TYPE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.EXP_ACTIVITY_TYPE_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.EXP_CENTER_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.EXP_CENTER_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.INC_ACTIVITY_TYPE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.INC_ACTIVITY_TYPE_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.INC_TEMPLATE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CODES.INC_TEMPLATE_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.ACCOUNT_LOSS)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_LOSS#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.ACCOUNT_EXPENDITURE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_EXPENDITURE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.OVER_COUNT)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.OVER_COUNT#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.UNDER_COUNT)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.UNDER_COUNT#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.PRODUCTION_COST)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PRODUCTION_COST#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.HALF_PRODUCTION_COST)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.HALF_PRODUCTION_COST#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.SALE_PRODUCT_COST)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.SALE_PRODUCT_COST#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.MATERIAL_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.MATERIAL_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.KONSINYE_PUR_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.KONSINYE_PUR_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.KONSINYE_SALE_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.KONSINYE_SALE_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.KONSINYE_SALE_NAZ_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.KONSINYE_SALE_NAZ_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.DIMM_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.DIMM_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.DIMM_YANS_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.DIMM_YANS_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.PROMOTION_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PROMOTION_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif isdefined('arguments.acc_code_cat') and len(arguments.acc_code_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.acc_code_cat#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.ACCOUNT_PRICE_PUR)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.ACCOUNT_PRICE_PUR#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.MATERIAL_CODE_SALE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.MATERIAL_CODE_SALE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.PRODUCTION_COST_SALE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PRODUCTION_COST_SALE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.SALE_MANUFACTURED_COST)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.SALE_MANUFACTURED_COST#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.PROVIDED_PROGRESS_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PROVIDED_PROGRESS_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.SCRAP_CODE_SALE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.SCRAP_CODE_SALE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.SCRAP_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.SCRAP_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.PROD_GENERAL_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PROD_GENERAL_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.PROD_LABOR_COST_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.PROD_LABOR_COST_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.RECEIVED_PROGRESS_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.RECEIVED_PROGRESS_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.INVENTORY_CAT_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.INVENTORY_CAT_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.INVENTORY_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.INVENTORY_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.AMORTIZATION_METHOD_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_METHOD_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.AMORTIZATION_TYPE_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_TYPE_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.AMORTIZATION_EXP_CENTER_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_EXP_CENTER_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.AMORTIZATION_EXP_ITEM_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_EXP_ITEM_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
                        <cfif len(GET_CODES.AMORTIZATION_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_CODES.AMORTIZATION_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>
                   
                    )
                </cfquery>
            </cfloop>
        </cfif>
        <cfquery name="ADD_MAIN_UNIT" datasource="#dsn1#">
            INSERT INTO
                #dsn1#.PRODUCT_UNIT 
            (
                PRODUCT_ID, 
                PRODUCT_UNIT_STATUS, 
                MAIN_UNIT_ID, 
                MAIN_UNIT, 
                UNIT_ID, 
                ADD_UNIT,
                DIMENTION,
                WEIGHT,
                VOLUME,
                IS_MAIN,
                IS_SHIP_UNIT,
                RECORD_EMP,
                RECORD_DATE
        
            )
            VALUES 
            (
                #GET_PID.PRODUCT_ID#,
                1,
                #LISTGETAT(UNIT_ID,1)#,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#LISTGETAT(UNIT_ID,2)#">,
                #LISTGETAT(UNIT_ID,1)#,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#LISTGETAT(UNIT_ID,2)#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DIMENTION#">,
                <cfif len(arguments.WEIGHT)>#arguments.WEIGHT#<cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.volume#" null="#not len(arguments.volume)#">,
                1,
                <cfif isdefined('is_ship_unit')>1<cfelse>0</cfif>,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
            )					
        </cfquery>
        <cfquery name="GET_MAX_UNIT" datasource="#dsn1#">
            SELECT MAX(PRODUCT_UNIT_ID) AS MAX_UNIT FROM #dsn1#.PRODUCT_UNIT
        </cfquery>
        <cfscript>
            if (isnumeric(arguments.PURCHASE))
                if (arguments.is_tax_included_purchase eq 1)
                {
                    purchase_kdvsiz = wrk_round(arguments.PURCHASE*100/(arguments.tax_purchase+100),session.ep.our_company_info.purchase_price_round_num);
                    purchase_kdvli = arguments.PURCHASE;
                    purchase_is_tax_included = 1;
                }
                else
                {
                    purchase_kdvsiz = arguments.PURCHASE;
                    purchase_kdvli =  wrk_round(arguments.PURCHASE*(1+(arguments.tax_purchase/100)),session.ep.our_company_info.purchase_price_round_num);
                    purchase_is_tax_included = 0;
                }
            else
            {
                purchase_kdvsiz = 0;
                purchase_kdvli = 0;
                purchase_is_tax_included = 0;
            }					
        </cfscript>
        <!--- purchasesales is 0 / alış fiyatı --->
        <cfquery name="ADD_STD_PRICE" datasource="#dsn1#">
            INSERT INTO
                #dsn1#.PRICE_STANDART
            (
                PRODUCT_ID, 
                PURCHASESALES, 
                PRICE, 
                PRICE_KDV,
                IS_KDV,
                ROUNDING,
                MONEY,
                START_DATE,
                RECORD_DATE,
                PRICESTANDART_STATUS,
                UNIT_ID,
                RECORD_EMP
            )
            VALUES
            (
                #GET_PID.PRODUCT_ID#,
                0,
                #purchase_kdvsiz#,
                #purchase_kdvli#,
                #purchase_is_tax_included#,
                0,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MONEY_ID_SA#">,
                #bugun_00#,
                #NOW()#,
                1,
                #GET_MAX_UNIT.MAX_UNIT#,
                #SESSION.EP.USERID#
            )
        </cfquery>
        <cfscript>
            if (isnumeric(arguments.PRICE))
                if (arguments.is_tax_included_sales eq 1)
                {
                    price_kdvsiz = wrk_round(arguments.PRICE*100/(arguments.tax+100),session.ep.our_company_info.sales_price_round_num);
                    price_kdvli = arguments.PRICE;
                    price_is_tax_included = 1;
                }
                else
                {
                    price_kdvsiz = arguments.PRICE;
                    price_kdvli = wrk_round(arguments.PRICE*(1+(arguments.tax/100)),session.ep.our_company_info.sales_price_round_num);
                    price_is_tax_included = 0;
                }
            else
            {
                price_kdvsiz = 0;
                price_kdvli = 0;
                price_is_tax_included = 0;
            }					
        </cfscript>
        <!--- purchasesales is 1 / satış fiyatı --->
        <cfquery name="ADD_STD_PRICE" datasource="#dsn1#">
            INSERT INTO 
                #dsn1#.PRICE_STANDART
            (
                PRODUCT_ID, 
                PURCHASESALES, 
                PRICE, 
                PRICE_KDV,
                IS_KDV,
                ROUNDING,
                MONEY,
                START_DATE,
                RECORD_DATE,
                PRICESTANDART_STATUS,
                UNIT_ID,
                RECORD_EMP
            )
            VALUES
            (
                #GET_PID.PRODUCT_ID#,
                1,
                #price_kdvsiz#,
                #price_kdvli#,
                #price_is_tax_included#,
                0,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MONEY_ID_SS#">,
                #bugun_00#,
                #NOW()#,
                1,
                #GET_MAX_UNIT.MAX_UNIT#,
                #SESSION.EP.USERID#
            )
        </cfquery>
        <!--- Subedeben kayıt atilmis ise ilgili sube listesine fiyat atilmasi  --->
        <cfif session.ep.isBranchAuthorization>
            <cfscript>
                add_price(product_id : get_pid.product_id,
                    product_unit_id : get_max_unit.max_unit,
                    price_cat : get_price_cat.price_catid,
                    start_date : createodbcdatetime(createdatetime(year(now()),month(now()),day(now()),hour(now()),(minute(now()) - minute(now()) mod 5),0)),
                    price : price_kdvsiz,
                    price_money : arguments.money_id_sa,
                    is_kdv : arguments.is_tax_included_sales,
                    price_with_kdv : price_kdvli
                    );
            </cfscript>
        </cfif>	
        <cfquery name="ADD_STOCKS" datasource="#dsn1#">
            INSERT INTO
                #dsn1#.STOCKS
            (
                STOCK_CODE,
                STOCK_CODE_2,
                PRODUCT_ID,
                PROPERTY,
                BARCOD,					
                PRODUCT_UNIT_ID,
                STOCK_STATUS,
                MANUFACT_CODE,
                RECORD_EMP, 
                RECORD_IP,
                RECORD_DATE
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PRODUCT_CODE#">,
                <cfif get_our_company_info.is_brand_to_code eq 1>
                    <cfif len(arguments.product_code_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_code_2#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#product_code_2_format#"></cfif>,
                <cfelse>
                    <cfif len(arguments.product_code_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_code_2#"><cfelse>NULL</cfif>,
                </cfif>
                #GET_PID.PRODUCT_ID#,
                '', <!--- property degeri null oldugunda raporlar, urun agacı gibi bir cok ekranda property le beraber cekilen urun isminde sorun oluyordu ---><!--- '-',  boş olarak eklenmesi terch edildi--->
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.BARCOD#">,
                #GET_MAX_UNIT.MAX_UNIT#,
                1,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MANUFACT_CODE#">,
                #session.ep.userid#,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#remote_addr#">,
                #now()#
            )
        </cfquery>
        <cfquery name="GET_MAX_STCK" datasource="#dsn1#">
            SELECT MAX(STOCK_ID) AS MAX_STCK FROM #dsn1#.STOCKS
        </cfquery>
        <cfquery name="ADD_STOCK_BARCODE" datasource="#dsn1#">
            INSERT INTO 
                #dsn1#.STOCKS_BARCODES
            (
                STOCK_ID,
                BARCODE,
                UNIT_ID
            )
            VALUES 
            (
                #GET_MAX_STCK.MAX_STCK#,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.BARCOD#">,
                #GET_MAX_UNIT.MAX_UNIT#
            )
        </cfquery>
        
        <cfquery name="ADD_PRODUCT_OUR_COMPANY_ID" datasource="#dsn1#">
            INSERT INTO 
                #dsn1#.PRODUCT_OUR_COMPANY
                (
                    PRODUCT_ID,
                    OUR_COMPANY_ID
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#get_pid.product_id#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                )
        </cfquery>
        
        <!--- FB 20070702 urune sessiondaki branch ekleniyor --->
        <cfquery name="add_product_branch_id" datasource="#dsn1#">
            INSERT INTO
                #dsn1#.PRODUCT_BRANCH
            (
                PRODUCT_ID,
                BRANCH_ID,
                RECORD_EMP, 
                RECORD_IP,
                RECORD_DATE
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#get_pid.product_id#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">,
                #session.ep.userid#,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#remote_addr#">,
                #now()#				
            )
        </cfquery>
        <cfquery name="get_my_periods" datasource="#dsn1#">
            SELECT * FROM #dsn#.SETUP_PERIOD WHERE OUR_COMPANY_ID = #SESSION.EP.COMPANY_ID#
        </cfquery>
        <cfloop query="get_my_periods">           
            <cfset temp_dsn = "#DSN#_#PERIOD_YEAR#_#SESSION.EP.COMPANY_ID#">            
            <cfquery name="INSRT_STK_ROW" datasource="#dsn1#">
                INSERT INTO #temp_dsn#.STOCKS_ROW 
                    (
                        STOCK_ID,
                        PRODUCT_ID
                    )
                VALUES 
                    (
                        #GET_MAX_STCK.MAX_STCK#,
                        #GET_PID.PRODUCT_ID#
                    )
            </cfquery>
        </cfloop>
                <!--- Stok Stratejisi Ekliyor! --->
        <cfquery name="ADD_STK_STRATEGY" datasource="#dsn1#">
            INSERT INTO
                #dsn3#.STOCK_STRATEGY 
            (
                PRODUCT_ID,
                STOCK_ID,
                MAXIMUM_STOCK,
                PROVISION_TIME,
                REPEAT_STOCK_VALUE,
                MINIMUM_STOCK,
                MINIMUM_ORDER_STOCK_VALUE,
                MINIMUM_ORDER_UNIT_ID,
                IS_LIVE_ORDER,
                STRATEGY_TYPE,
                STRATEGY_ORDER_TYPE,
                BLOCK_STOCK_VALUE,
                STOCK_ACTION_ID
            )
            VALUES
            (
                #pid#,
                #GET_MAX_STCK.MAX_STCK#,
                <cfif len(arguments.maximum_stock)>#arguments.MAXIMUM_STOCK#,<cfelse>NULL,</cfif>
                <cfif len(arguments.provision_time) >#arguments.PROVISION_TIME#,<cfelse>NULL,</cfif>
                <cfif len(arguments.repeat_stock_value)>#arguments.REPEAT_STOCK_VALUE#,<cfelse>NULL,</cfif>
                <cfif len(arguments.minimum_stock)>#arguments.MINIMUM_STOCK#,<cfelse>NULL,</cfif>
                <cfif len(arguments.minimum_order_stock_value)>#arguments.MINIMUM_ORDER_STOCK_VALUE#,<cfelse>NULL,</cfif>
                #GET_MAX_UNIT.MAX_UNIT#,
                <cfif isDefined("arguments.is_live_order")>#arguments.IS_LIVE_ORDER#,<cfelse>0,</cfif>
                #arguments.STRATEGY_TYPE#,
                <cfif isDefined("arguments.strategy_order_type") and len(arguments.strategy_order_type)>#arguments.strategy_order_type#<cfelse>NULL</cfif>,
                <cfif isDefined("arguments.block_stock_value") and len(arguments.block_stock_value)>#arguments.block_stock_value#<cfelse>NULL</cfif>,
                <cfif isDefined("arguments.saleable_stock_action_id") and len(arguments.saleable_stock_action_id)>#arguments.saleable_stock_action_id#<cfelse>NULL</cfif>
            )
        </cfquery>
        <cfif isDefined("arguments.block_stock_value") and len(arguments.block_stock_value)>
            <cfquery name="GET_MAX_STRATEGY" datasource="#dsn1#">
                SELECT MAX(STOCK_STRATEGY_ID) MAX_ID FROM #dsn3#.STOCK_STRATEGY WHERE STOCK_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#GET_MAX_STCK.MAX_STCK#">
            </cfquery>
            <cfquery name="ADD_STK_STRATEGY" datasource="#dsn1#">
                INSERT INTO
                    #dsn3#.ORDER_ROW_RESERVED 
                (
                    STOCK_STRATEGY_ID,
                    STOCK_ID,
                    PRODUCT_ID,
                    RESERVE_STOCK_IN,
                    RESERVE_STOCK_OUT,
                    STOCK_IN,
                    STOCK_OUT
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_MAX_STRATEGY.MAX_ID#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_MAX_STCK.MAX_STCK#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#pid#">,
                    0,
                    #arguments.block_stock_value#,
                    0,
                    0
                )
            </cfquery>
        </cfif>       
        <!---<cfif isdefined("arguments.USER_FRIENDLY_URL") and len(arguments.USER_FRIENDLY_URL)> 
            <cf_workcube_user_friendly user_friendly_url='#arguments.user_friendly_url#' action_type='PRODUCT_ID' action_id='#pid#' action_page='objects2.detail_product&product_id=#pid#'>
            <cfquery name="upd_product_" datasource="#dsn1#">
                UPDATE #dsn1#.PRODUCT SET USER_FRIENDLY_URL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.user_friendly_url#"> WHERE PRODUCT_ID = #pid#
            </cfquery>
        </cfif>--->
        <cfreturn MAX_ID.IDENTITYCOL>       
    </cffunction> 
    
    <!--- upd --->
    <cffunction name="upd" access="public" returntype="string">
    <cfargument name="product_name" type="string" default="NULL" required="yes" hint="Ürün Adı">
    <cfargument name="barcod" type="string" default="NULL" required="no" hint="Barkod">
    <cfargument name="pid" type="numeric" default="NULL" required="yes" hint="Ürün Id">
    <cfargument name="old_product_catid" type="numeric" default="NULL" required="no" hint="Eski Ürün Kategori Id">
    <cfargument name="product_catid" type="numeric" default="0" required="yes" hint="Ürün Kategori Id">
    <cfargument name="product_code" type="string" default="NULL" required="yes" hint="Ürün Kodu">
    <cfargument name="old_product_code" type="string" default="NULL" required="yes" hint="Eski Ürün Kodu">
    <cfargument name="user_friendly_url" type="string" default="NULL" required="no" hint="Kullanıcı Dostu Url">
    <cfargument name="quality_startdate" type="string" default="NULL" required="no" hint="Kalite Kontrol Başlangıç Tarihi">
    <cfargument name="product_status" type="numeric" default="0" required="no" hint="Ürün Aktif/Pasif">
    <cfargument name="is_quality" type="numeric" default="0" required="no" hint="Kalite">
    <cfargument name="is_cost" type="numeric" default="0" required="no" hint="Maliyet">
    <cfargument name="is_inventory" type="numeric" default="0" required="no" hint="Envanter">
    <cfargument name="is_production" type="numeric" default="0" required="no" hint="Üretim">
    <cfargument name="is_sales" type="numeric" default="0" required="no" hint="Satış">
    <cfargument name="is_purchase" type="numeric" default="0" required="no" hint="Tedarik">
    <cfargument name="is_prototype" type="numeric" default="0" required="no" hint="Prototip">
    <cfargument name="is_terazi" type="numeric" default="0" required="no" hint="Terazi">
    <cfargument name="is_serial_no" type="numeric" default="0" required="no" hint="Seri No">
    <cfargument name="is_zero_stock" type="numeric" default="0" required="no" hint="Sıfır Stok">
    <cfargument name="is_karma" type="numeric" default="0" required="no" hint="Karma Koli">
    <cfargument name="is_limited_stock" type="numeric" default="0" required="no" hint="Stoklarla Sınırlı">
    <cfargument name="is_commission" type="numeric" default="0" required="no" hint="Pos Komisyonu Hesapla">
    <cfargument name="is_add_xml" type="numeric" default="0" required="no" hint="XML de Gelsin">
    <cfargument name="is_lot_no" type="numeric" default="0" required="no" hint="Lot No">
    <cfargument name="company_id" type="numeric" default="0" required="no" hint="Tedarikçi Id">
    <cfargument name="product_manager" type="numeric" default="0" required="no" hint="Sorumlu">
    <cfargument name="is_internet" type="numeric" default="0" required="no" hint="İnternet">
    <cfargument name="is_extranet" type="numeric" default="0" required="no" hint="Extranet">
    <cfargument name="is_gift_card" type="numeric" default="0" required="no" hint="Hediye Kartı">
    <cfargument name="gift_valid_day" type="numeric" default="0" required="no" hint="Geçerlilik Günü">
    <cfargument name="tax" type="numeric" default="0" required="no" hint="Satış KDV">
    <cfargument name="OTV" type="numeric" default="0" required="no" hint="OTV">
    <cfargument name="OTV_AMOUNT" type="numeric" default="0" required="no" hint="OTV Miktar">
    <cfargument name="product_detail" type="string" default="NULL" required="no" hint="Açıklama"> 
    <cfargument name="product_detail2" type="string" default="NULL" required="no" hint="Açıklama2">
    <cfargument name="brand_name" type="string" default="NULL" required="no" hint="Marka Adı">
    <cfargument name="brand_id" type="numeric" default="0" required="no" hint="Marka Id">  
    <cfargument name="manufact_code" type="string" default="NULL" required="no" hint="Üretici ürün Kodu">
    <cfargument name="shelf_life" type="numeric" default="0" required="no" hint="Raf Ömrü">
    <cfargument name="segment_id" type="numeric" default="0" required="no" hint="Hedef Pazar">
    <cfargument name="prod_comp" type="numeric" default="0" required="no" hint="Fiyat Yetkisi">
    <cfargument name="process_stage" type="numeric" default="0" required="no" hint="Süreç"> 
    <cfargument name="min_margin" type="numeric" default="0" required="no" hint="Minimum Marj">
    <cfargument name="max_margin" type="numeric" default="0" required="no" hint="Maximum Marj">
    <cfargument name="product_code_2" type="string" default="NULL" required="no" hint="Özel Kod">
    <cfargument name="old_product_code_2" type="string" default="NULL" required="no" hint="Eski Özel Kod Id">
    <cfargument name="short_code" type="string" default="NULL" required="no" hint="Model Kod">
    <cfargument name="short_code_id" type="numeric" default="0" required="no" hint="Model Id">
    <cfargument name="work_product_name" type="string" default="NULL" required="no" hint="İşçilik Ürünü">
    <cfargument name="work_stock_id" type="numeric" default="0" required="no" hint="İşçilik Ürünü Id">
    <cfargument name="work_stock_amount" type="numeric" default="0" required="no" hint="İşçilik Ürünü Miktar">
    <cfargument name="package_control_type" type="numeric" default="0" required="no" hint="Paket Kontrol Tipi">
    <cfargument name="customs_recipe_code" type="string" default="NULL" required="no" hint="Gümrük Tarife Kodu">
    <cfargument name="comp" type="string" default="NULL" required="no" hint="Tedarikçi Adı">
    <cfargument name="OLD_BARCOD" type="string" default="NULL" required="no" hint="Eski Barkod">
    <cfargument name="STANDART_ALIS" type="string" default="NULL" required="no" hint="Standart Alış Fiyatı">
    <cfargument name="OLD_STANDART_ALIS" type="string" default="NULL" required="no" hint="Eski Standart Alış Fiyatı">
    <cfargument name="money_id_sa" type="string" default="NULL" required="no" hint="Standart Alış Para Birimi">
    <cfargument name="money_id_sa_old" type="string" default="NULL" required="no" hint="Eski Standart Alış Para Birimi">
    <cfargument name="is_tax_included_purchase" type="numeric" default="0" required="no" hint="Standart Alış KDV DH">
    <cfargument name="tax_purchase" type="numeric" default="0" required="no" hint="Alış KDV">
    <cfargument name="old_tax_purchase" type="numeric" default="0" required="no" hint="Eski Alış KDV">
    <cfargument name="old_tax_sell" type="numeric" default="0" required="no" hint="Eski Satış KDV">
    <cfargument name="MONEY_ID_SS" type="string" default="TL" required="no" hint="Standart Satiş Para Birimi">
    <cfargument name="MONEY_ID_SS_OLD" type="string" default="TL" required="no" hint="Eski Standart Satiş Para Birimi">
    <cfargument name="is_tax_included_sales" type="string" default="0" required="no" hint="Standart Satiş KDV DH">
    <cfargument name="old_is_tax_included_sales" type="string" default="0" required="no" hint="Eski Standart Satiş KDV DH">
    
    <cfset arguments.PRODUCT_NAME = trim(arguments.PRODUCT_NAME)>
    <cfset arguments.BARCOD=TRIM(arguments.BARCOD)>
    <cfset bugun_00 = DateFormat(now(),'dd/mm/yyyy')>
    <cf_date tarih='bugun_00'>
    <cfquery name="CHECK_SAME" datasource="#DSN1#">
        SELECT P.PRODUCT_ID FROM PRODUCT P WHERE P.PRODUCT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PRODUCT_NAME#"> AND P.PRODUCT_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pid#">
    </cfquery>
    <cfquery name="get_stock_barcode_query" datasource="#dsn1#">
        SELECT MIN(STOCK_ID) STOCK_ID FROM STOCKS WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pid#">
    </cfquery>
    <cfif not (arguments.old_product_catid is arguments.product_catid)>
        <!--- Kategori degismisse ürün kodu da degisir ürün kodu ile bu ürüne bagli stoklar da degiseceginden hepsini yenileyelim. --->
        <cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
            SELECT HIERARCHY FROM #dsn3#.PRODUCT_CAT WHERE PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_CATID#">
        </cfquery>
        <cfset arguments.PRODUCT_CODE = '#get_product_cat.HIERARCHY#.#trim(ListLast(arguments.PRODUCT_CODE,'.'))#'>
        <cfquery name="SEL_STOCK_ESKILER" datasource="#dsn1#">
            SELECT STOCK_CODE AS PRODUCT_CODE, STOCK_ID FROM #dsn1#.STOCKS WHERE STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.OLD_PRODUCT_CODE#%">
        </cfquery>
        <cfloop query="sel_stock_eskiler">
            <cfset temp = "">
            <cfset fark = Len(sel_stock_eskiler.product_code) - Len(arguments.old_product_code)>
            <cfif (fark neq 0)>
                <cfset temp = arguments.product_code & Right(sel_stock_eskiler.product_code,fark)>
            <cfelse>
                <cfset temp = arguments.product_code>
            </cfif>
            <cfquery name="UPD_STOCK" datasource="#dsn1#">
                UPDATE 
                    #dsn1#.STOCKS 
                SET 
                    STOCK_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#temp#">,
                    UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#REMOTE_ADDR#">,
                    UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                WHERE 
                    STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SEL_STOCK_ESKILER.STOCK_ID#">
            </cfquery>
        </cfloop>
        <!--- cat değiştiği için info plus siliniyor--->
        <cfquery name="DEL_INFOPLUS" datasource="#dsn1#">
            DELETE FROM #dsn3#.PRODUCT_INFO_PLUS WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pid#">
        </cfquery>
    <cfelse>
        <!--- Kategori degismemis ama ürün kodu degismis ise ürün kodu ile bu ürüne bagli stoklar da degiseceginden hepsini yenileyelim.--->
        <cfif not (arguments.old_product_code is arguments.product_code)>
            <cfquery name="SEL_STOCK_ESKILER" datasource="#DSN1#">
                SELECT STOCK_CODE AS PRODUCT_CODE, STOCK_ID FROM #dsn1#.STOCKS WHERE STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.OLD_PRODUCT_CODE#%">
            </cfquery>
            <cfloop query="sel_stock_eskiler">
                <cfset temp="">
                <cfset fark = Len(sel_stock_eskiler.product_code) - Len(arguments.old_product_code)>
                <cfif fark neq 0>
                    <cfset temp = arguments.product_code & Right(sel_stock_eskiler.product_code,fark)>
                <cfelse>
                    <cfset temp = arguments.product_code>
                </cfif>
                <cfquery name="UPD_STOCK" datasource="#DSN1#">
                    UPDATE 
                        #dsn1#.STOCKS 
                    SET 
                        STOCK_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TEMP#">,
                        UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#REMOTE_ADDR#">,
                        UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    WHERE 
                        STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SEL_STOCK_ESKILER.STOCK_ID#">
                </cfquery>
            </cfloop>
        </cfif>
    </cfif>
    <cfif isdefined("arguments.USER_FRIENDLY_URL") and len(arguments.USER_FRIENDLY_URL)> 
        <cf_workcube_user_friendly user_friendly_url='#arguments.user_friendly_url#' action_type='PRODUCT_ID' action_id='#arguments.pid#' action_page='objects2.detail_product&product_id=#arguments.pid#'>
    </cfif>
    <cfif isdefined("arguments.quality_startdate") and len(arguments.quality_startdate)>
        <cf_date tarih="arguments.quality_startdate">
    </cfif>
    <cfquery name="get_our_company_info" datasource="#DSN1#">
        SELECT IS_PRODUCT_COMPANY FROM #dsn#.OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
    </cfquery>
    <cfquery name="UPD_PRODUCT" datasource="#DSN1#" result="xxxx">
        UPDATE 
            #dsn1#.PRODUCT 
        SET 
            USER_FRIENDLY_URL = <cfif isdefined("arguments.USER_FRIENDLY_URL") and len(arguments.USER_FRIENDLY_URL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#user_friendly_#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" null="yes" value=""></cfif>,
            <cfif get_our_company_info.is_product_company eq 0>
                PRODUCT_STATUS = <cfif isDefined("arguments.PRODUCT_STATUS") and arguments.PRODUCT_STATUS eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_QUALITY = <cfif isDefined("arguments.is_quality") and arguments.is_quality eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_COST = <cfif isDefined("arguments.IS_COST") and arguments.IS_COST eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_INVENTORY = <cfif isDefined("arguments.IS_INVENTORY") and arguments.IS_INVENTORY eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_PRODUCTION = <cfif isDefined("arguments.IS_PRODUCTION") and arguments.IS_PRODUCTION eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_SALES = <cfif isDefined("arguments.IS_SALES") and arguments.IS_SALES eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_PURCHASE = <cfif isDefined("arguments.IS_PURCHASE") and arguments.IS_PURCHASE eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_PROTOTYPE = <cfif isDefined("arguments.IS_PROTOTYPE") and arguments.IS_PROTOTYPE eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_TERAZI = <cfif isDefined("arguments.IS_TERAZI") and arguments.IS_TERAZI eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_SERIAL_NO = <cfif isDefined("arguments.IS_SERIAL_NO") and arguments.IS_SERIAL_NO eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_ZERO_STOCK = <cfif isDefined("arguments.IS_ZERO_STOCK") and arguments.IS_ZERO_STOCK eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_KARMA = <cfif isDefined("arguments.IS_KARMA") and arguments.IS_KARMA eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_LIMITED_STOCK = <cfif isDefined("arguments.is_limited_stock") and arguments.is_limited_stock eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_COMMISSION = <cfif isDefined("arguments.is_commission") and arguments.is_commission eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_ADD_XML = <cfif isDefined("arguments.is_add_xml") and arguments.is_add_xml eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                IS_LOT_NO = <cfif isDefined("arguments.is_lot_no") and arguments.is_lot_no eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                COMPANY_ID = <cfif isDefined("arguments.COMPANY_ID") and len(arguments.COMPANY_ID) and len(arguments.COMP)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.COMPANY_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                PRODUCT_MANAGER = <cfif isDefined('arguments.PRODUCT_MANAGER') and len(arguments.PRODUCT_MANAGER) and isDefined('arguments.PRODUCT_MANAGER_NAME') and len(arguments.PRODUCT_MANAGER_NAME)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_MANAGER#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" null="yes" value=""></cfif>,
                IS_INTERNET = <cfif isDefined('arguments.is_internet') and arguments.is_internet eq 1><cfqueryparam cfsqltype="cf_sql_integer" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="0"></cfif>,
                IS_EXTRANET = <cfif isDefined('arguments.is_extranet') and arguments.is_extranet eq 1><cfqueryparam cfsqltype="cf_sql_integer" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="0"></cfif>,
                IS_GIFT_CARD = <cfif isDefined('arguments.is_gift_card') and arguments.is_gift_card eq 1 ><cfqueryparam cfsqltype="cf_sql_integer" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="0"></cfif>,
                GIFT_VALID_DAY = <cfif isDefined('arguments.gift_valid_day') and len(arguments.gift_valid_day)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.gift_valid_day#"><cfelse>NULL</cfif>,
            </cfif>
            PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_CATID#">,
            PRODUCT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PRODUCT_NAME#">,
            TAX = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.TAX#">,
            TAX_PURCHASE = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.TAX_PURCHASE#">,
            OTV = <cfif isDefined('arguments.OTV') and len(arguments.OTV)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.OTV#"><cfelse>NULL</cfif>,
            OTV_AMOUNT=<cfif isDefined('arguments.OTV_AMOUNT') and len(arguments.OTV_AMOUNT)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.OTV_AMOUNT#"><cfelse>NULL</cfif>,
            BARCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.BARCOD#">,
            PRODUCT_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PRODUCT_DETAIL#">,
            PRODUCT_DETAIL2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PRODUCT_DETAIL2#">,
            BRAND_ID = <cfif len(arguments.brand_name) and len(arguments.brand_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.brand_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
            PRODUCT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PRODUCT_CODE#">,
            MANUFACT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MANUFACT_CODE#">,
            SHELF_LIFE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SHELF_LIFE#">,
            SEGMENT_ID = <cfif isDefined('arguments.SEGMENT_ID') and len(arguments.SEGMENT_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SEGMENT_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
            
            PROD_COMPETITIVE = <cfif isDefined('arguments.prod_comp') and len(arguments.prod_comp)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.prod_comp#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
            PRODUCT_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
            MIN_MARGIN = <cfif isDefined('arguments.MIN_MARGIN') and len(arguments.MIN_MARGIN)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.MIN_MARGIN#"><cfelse><cfqueryparam cfsqltype="cf_sql_float" value="0"></cfif>,		
            MAX_MARGIN = <cfif isDefined('arguments.MAX_MARGIN') and len(arguments.MAX_MARGIN)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.MAX_MARGIN#"><cfelse><cfqueryparam cfsqltype="cf_sql_float" value="0"></cfif>,		
            PRODUCT_CODE_2 = <cfif len(arguments.product_code_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_code_2#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
            SHORT_CODE = <cfif len(arguments.SHORT_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SHORT_CODE#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
            SHORT_CODE_ID = <cfif len(arguments.SHORT_CODE_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SHORT_CODE_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
            WORK_STOCK_ID = <cfif isdefined('arguments.work_product_name') and len(arguments.work_product_name) and len(arguments.work_stock_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.work_stock_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
            WORK_STOCK_AMOUNT = <cfif isdefined('arguments.work_product_name') and len(arguments.work_product_name) and len(arguments.work_stock_id) and len(arguments.work_stock_amount)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.work_stock_amount#"><cfelse><cfqueryparam cfsqltype="cf_sql_float" value="" null="yes"></cfif>,
            PACKAGE_CONTROL_TYPE = <cfif isdefined('arguments.PACKAGE_CONTROL_TYPE') and len(arguments.PACKAGE_CONTROL_TYPE)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PACKAGE_CONTROL_TYPE#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
            <cfif IsDefined("session.ep.userid")>
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
            <cfelseif IsDefined("session.pp.userid")>
                UPDATE_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">,
            </cfif>		
            UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
            UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
            CUSTOMS_RECIPE_CODE = <cfif isdefined("arguments.customs_recipe_code") and len(arguments.customs_recipe_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.customs_recipe_code#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>
            <cfif get_our_company_info.is_product_company eq 0>,QUALITY_START_DATE = <cfif isdefined("arguments.quality_startdate") and len(arguments.quality_startdate)><cfqueryparam cfsqltype="cf_sql_date" value="#arguments.quality_startdate#"><cfelse><cfqueryparam cfsqltype="cf_sql_date" value="" null="yes"></cfif></cfif>
        WHERE 
            PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pid#">
    </cfquery>
    <cfif get_our_company_info.recordcount and get_our_company_info.IS_PRODUCT_COMPANY eq 1>
        <cfquery name="GET_PRODUCT_COMPANY" datasource="#DSN1#">
            SELECT OUR_COMPANY_ID,PRODUCT_ID FROM #dsn1#.PRODUCT_GENERAL_PARAMETERS WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pid#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
        </cfquery>
        <cfif not GET_PRODUCT_COMPANY.recordcount>
            <cfquery name="add_general_parameters" datasource="#dsn1#">
                INSERT INTO #dsn1#.PRODUCT_GENERAL_PARAMETERS
                (
                    PRODUCT_ID,
                    COMPANY_ID, 
                    OUR_COMPANY_ID,
                    PRODUCT_MANAGER,
                    PRODUCT_STATUS, 
                    IS_INVENTORY, 
                    IS_PRODUCTION, 
                    IS_SALES, 
                    IS_PURCHASE, 
                    IS_PROTOTYPE,
                    IS_INTERNET, 
                    IS_EXTRANET, 
                    IS_TERAZI, 
                    IS_KARMA, 
                    IS_ZERO_STOCK, 
                    IS_LIMITED_STOCK, 
                    IS_SERIAL_NO, 
                    IS_COST, 
                    IS_QUALITY, 
                    IS_COMMISSION,
                    IS_ADD_XML,
                    IS_GIFT_CARD,
                    IS_LOT_NO,
                    GIFT_VALID_DAY,
                    QUALITY_START_DATE
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pid#">, 
                    <cfif isDefined("arguments.COMPANY_ID") and len(arguments.COMPANY_ID) and len(arguments.COMP)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.COMPANY_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                    #session.ep.company_id#,
                    <cfif isDefined('arguments.PRODUCT_MANAGER') and len(arguments.PRODUCT_MANAGER) and isDefined('arguments.PRODUCT_MANAGER_NAME') and len(arguments.PRODUCT_MANAGER_NAME)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_MANAGER#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" null="yes" value=""></cfif>,
                    <cfif isDefined("arguments.PRODUCT_STATUS")><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("arguments.is_inventory") and arguments.is_inventory eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("arguments.is_production") and arguments.is_production eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
                    <cfif isDefined("arguments.is_sales") and arguments.is_sales eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
                    <cfif isDefined("arguments.is_purchase") and arguments.is_purchase eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
                    <cfif isDefined("arguments.is_prototype") and arguments.is_prototype eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("arguments.is_internet") and arguments.is_internet eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("arguments.is_extranet") and arguments.is_extranet eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
                    <cfif isDefined("arguments.is_terazi") and arguments.is_terazi eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("arguments.is_karma") and arguments.is_karma eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("arguments.is_zero_stock") and arguments.is_zero_stock eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("arguments.is_limited_stock") and arguments.is_limited_stock eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("arguments.is_serial_no") and arguments.is_serial_no eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("arguments.is_cost") and arguments.is_cost eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("arguments.is_quality") and arguments.is_quality eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("arguments.is_commission") and arguments.is_commission eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined("arguments.is_add_xml") and arguments.is_add_xml eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined('arguments.is_gift_card')><cfqueryparam cfsqltype="cf_sql_integer" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="0"></cfif>,
                    <cfif isDefined("arguments.is_lot_no") and arguments.is_lot_no eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    <cfif isDefined('arguments.gift_valid_day') and len(arguments.gift_valid_day)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.gift_valid_day#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.quality_startdate") and len(arguments.quality_startdate)><cfqueryparam cfsqltype="cf_sql_date" value="#arguments.quality_startdate#"><cfelse><cfqueryparam cfsqltype="cf_sql_date" value="" null="yes"></cfif>
                )
            </cfquery>
        <cfelse>
            <cfquery name="upd_general_parameters" datasource="#dsn1#">
                UPDATE
                    #dsn1#.PRODUCT_GENERAL_PARAMETERS
                SET
                    PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pid#">, 
                    COMPANY_ID = <cfif isDefined("arguments.COMPANY_ID") and len(arguments.COMPANY_ID) and len(arguments.COMP)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.COMPANY_ID#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
                    OUR_COMPANY_ID = #session.ep.company_id#,
                    PRODUCT_MANAGER = <cfif isDefined('arguments.PRODUCT_MANAGER') and len(arguments.PRODUCT_MANAGER) and isDefined('arguments.PRODUCT_MANAGER_NAME') and len(arguments.PRODUCT_MANAGER_NAME)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_MANAGER#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" null="yes" value=""></cfif>,
                    PRODUCT_STATUS = <cfif isDefined("arguments.PRODUCT_STATUS")><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    IS_INVENTORY = <cfif isDefined("arguments.is_inventory") and arguments.is_inventory eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    IS_PRODUCTION = <cfif isDefined("arguments.is_production") and arguments.is_production eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
                    IS_SALES = <cfif isDefined("arguments.is_sales") and arguments.is_sales eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
                    IS_PURCHASE = <cfif isDefined("arguments.is_purchase") and arguments.is_purchase eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
                    IS_PROTOTYPE = <cfif isDefined("arguments.is_prototype") and arguments.is_prototype eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    IS_INTERNET = <cfif isDefined("arguments.is_internet") and arguments.is_internet eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    IS_EXTRANET = <cfif isDefined("arguments.is_extranet") and arguments.is_extranet eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>, 
                    IS_TERAZI = <cfif isDefined("arguments.is_terazi") and arguments.is_terazi eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    IS_KARMA = <cfif isDefined("arguments.is_karma") and arguments.is_karma eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    IS_ZERO_STOCK = <cfif isDefined("arguments.is_zero_stock") and arguments.is_zero_stock eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    IS_LIMITED_STOCK = <cfif isDefined("arguments.is_limited_stock") and arguments.is_limited_stock eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    IS_SERIAL_NO = <cfif isDefined("arguments.is_serial_no") and arguments.is_serial_no eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    IS_COST = <cfif isDefined("arguments.is_cost") and arguments.is_cost eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    IS_QUALITY = <cfif isDefined("arguments.is_quality") and arguments.is_quality eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    IS_COMMISSION = <cfif isDefined("arguments.is_commission") and arguments.is_commission eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    IS_ADD_XML = <cfif isDefined("arguments.is_add_xml") and arguments.is_add_xml eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    IS_GIFT_CARD = <cfif isDefined('arguments.is_gift_card')><cfqueryparam cfsqltype="cf_sql_integer" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="0"></cfif>,
                    IS_LOT_NO = <cfif isDefined("arguments.is_lot_no") and arguments.is_lot_no eq 1><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
                    GIFT_VALID_DAY = <cfif isDefined('arguments.gift_valid_day') and len(arguments.gift_valid_day)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.gift_valid_day#"><cfelse>NULL</cfif>,
                    QUALITY_START_DATE = <cfif isdefined("arguments.quality_startdate") and len(arguments.quality_startdate)><cfqueryparam cfsqltype="cf_sql_date" value="#arguments.quality_startdate#"><cfelse><cfqueryparam cfsqltype="cf_sql_date" value="" null="yes"></cfif>
                WHERE
                    PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pid#">
            </cfquery>
        </cfif>
    </cfif>
    <cfif arguments.is_spect_name_upd eq 1>
        <cfquery name="get_prod_prototype" datasource="#DSN1#">
            SELECT IS_PROTOTYPE FROM #dsn1#.PRODUCT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pid#">
        </cfquery>
        <cfif get_prod_prototype.IS_PROTOTYPE eq 0>
            <cfquery name="upd_prod_spect" datasource="#dsn1#" maxrows="1">
                UPDATE
                    #dsn3#.SPECT_MAIN
                SET
                    SPECT_MAIN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PRODUCT_NAME#">
                WHERE
                    STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_stock_barcode_query.STOCK_ID#"> AND
                    SPECT_STATUS = 1
            </cfquery>
        </cfif>
    </cfif>
    <cfif arguments.BARCOD neq arguments.OLD_BARCOD or arguments.MANUFACT_CODE neq arguments.old_MANUFACT_CODE or arguments.PRODUCT_CODE_2 neq arguments.old_PRODUCT_CODE_2>
        <cfquery name="upd_stock_barcode" datasource="#DSN1#">
            UPDATE
                #dsn1#.STOCKS
            SET
                <cfif arguments.PRODUCT_CODE_2 neq arguments.old_PRODUCT_CODE_2>STOCK_CODE_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PRODUCT_CODE_2#">,</cfif>
                <cfif arguments.MANUFACT_CODE neq arguments.old_MANUFACT_CODE>MANUFACT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MANUFACT_CODE#">,</cfif>
                <cfif arguments.BARCOD neq arguments.OLD_BARCOD>BARCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.BARCOD#">,</cfif>
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#REMOTE_ADDR#">,
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
            WHERE
                STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_stock_barcode_query.STOCK_ID#">
        </cfquery>
        <cfif arguments.BARCOD neq arguments.OLD_BARCOD and get_stock_barcode_query.recordcount>
            <cfquery name="upd_stock_barcode" datasource="#dsn1#">
                UPDATE
                    #dsn1#.STOCKS_BARCODES
                SET
                    BARCODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.BARCOD#">
                WHERE
                    BARCODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.OLD_BARCOD#"> AND 
                    STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_stock_barcode_query.STOCK_ID#">
            </cfquery>
        </cfif>
    </cfif>
    <cfquery name="GET_UNIT" datasource="#dsn1#">
        SELECT 
            PRODUCT_UNIT_ID 
        FROM 
            #dsn1#.PRODUCT_UNIT 
        WHERE 
            PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pid#"> AND 
            IS_MAIN = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND 
            PRODUCT_UNIT_STATUS = 1
    </cfquery>
    <cfif (STANDART_ALIS neq OLD_STANDART_ALIS) or (arguments.MONEY_ID_SA neq arguments.MONEY_ID_SA_OLD) or (arguments.is_tax_included_purchase neq arguments.old_is_tax_included_purchase) or (arguments.old_tax_purchase neq arguments.tax_purchase) or (arguments.old_tax_sell neq arguments.tax)>
         <cfquery name="DEL_PRODUCT_PRICE_PURCHASE" datasource="#dsn1#">
            DELETE FROM
                #dsn1#.PRICE_STANDART
            WHERE
                PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pid#"> AND
                PURCHASESALES = <cfqueryparam cfsqltype="cf_sql_smallint" value="0"> AND
                UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_UNIT.PRODUCT_UNIT_ID#"> AND
                START_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bugun_00#">						
        </cfquery> 
        <cfscript>
            if (isnumeric(arguments.STANDART_ALIS))
                if (arguments.is_tax_included_purchase eq 1)
                    {
                        purchase_kdvsiz = wrk_round(arguments.STANDART_ALIS*100/(arguments.tax_purchase+100),session.ep.our_company_info.purchase_price_round_num);
                        purchase_kdvli = arguments.STANDART_ALIS;
                        purchase_is_tax_included = 1;
                    }
                else
                    {
                        purchase_kdvsiz = arguments.STANDART_ALIS;
                        purchase_kdvli = wrk_round(arguments.STANDART_ALIS*(1+(arguments.tax_purchase/100)),session.ep.our_company_info.purchase_price_round_num);
                        purchase_is_tax_included = 0;
                    }
            else
                {
                    purchase_kdvsiz = 0;
                    purchase_kdvli = 0;
                    purchase_is_tax_included = 0;
                }					
        </cfscript>
        <cfquery name="CORRECT_PRICE_0" datasource="#dsn1#">
            UPDATE 
                #dsn1#.PRICE_STANDART
            SET 
                PRICESTANDART_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="0">,
                RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">
            WHERE 
                PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pid#"> AND 
                PURCHASESALES = <cfqueryparam cfsqltype="cf_sql_smallint" value="0"> AND
                UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_UNIT.PRODUCT_UNIT_ID#"> AND
                PRICESTANDART_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
        </cfquery>
        <cfquery name="ADD_STANDART_PRICE" datasource="#dsn1#">
            INSERT INTO 
                #dsn1#.PRICE_STANDART
            (
                PRODUCT_ID,
                PURCHASESALES,
                PRICE,
                PRICE_KDV,
                IS_KDV,
                ROUNDING,
                START_DATE,
                RECORD_DATE,
                RECORD_IP,
                PRICESTANDART_STATUS,
                MONEY,
                UNIT_ID,
                RECORD_EMP
            )
            VALUES 
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pid#">,
                <cfqueryparam cfsqltype="cf_sql_smallint" value="0">,							
                <cfqueryparam cfsqltype="cf_sql_float" value="#purchase_kdvsiz#">,
                <cfqueryparam cfsqltype="cf_sql_float" value="#purchase_kdvli#">,
                <cfqueryparam cfsqltype="cf_sql_smallint" value="#purchase_is_tax_included#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bugun_00#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTEADDR#">,
                <cfqueryparam cfsqltype="cf_sql_smallint" value="1">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MONEY_ID_SA#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_UNIT.PRODUCT_UNIT_ID#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">
            )
        </cfquery>
    </cfif>
    <cfif (arguments.OLD_STANDART_SATIS neq arguments.STANDART_SATIS) or (arguments.MONEY_ID_SS neq arguments.MONEY_ID_SS_OLD) or (arguments.is_tax_included_sales neq arguments.old_is_tax_included_sales) or (arguments.old_tax_purchase neq arguments.tax_purchase) or (arguments.old_tax_sell neq arguments.tax)>
        <cfquery name="DEL_PRODUCT_PRICE_SALES" datasource="#dsn1#">
            DELETE FROM
                #dsn1#.PRICE_STANDART
            WHERE
                PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pid#"> AND
                PURCHASESALES = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
                UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_UNIT.PRODUCT_UNIT_ID#"> AND
                START_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bugun_00#">						
        </cfquery>
        <cfscript>
            if (isnumeric(arguments.STANDART_SATIS))
                if (arguments.is_tax_included_sales eq 1)
                    {
                        price_kdvsiz = wrk_round(arguments.STANDART_SATIS*100/(arguments.tax+100),session.ep.our_company_info.sales_price_round_num);
                        price_kdvli = arguments.STANDART_SATIS;
                        price_is_tax_included = 1;
                    }
                else
                    {
                        price_kdvsiz = arguments.STANDART_SATIS;
                        price_kdvli = wrk_round(arguments.STANDART_SATIS*(1+(arguments.tax/100)),session.ep.our_company_info.sales_price_round_num);
                        price_is_tax_included = 0;
                    }
            else
                {
                    price_kdvsiz = 0;
                    price_kdvli = 0;
                    price_is_tax_included = 0;
                }					
        </cfscript>
        <cfquery name="CORRECT_PRICE_0" datasource="#dsn1#">
            UPDATE 
                PRICE_STANDART
            SET 
                PRICESTANDART_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="0">,
                RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">
            WHERE 
                PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pid#"> AND 
                PURCHASESALES = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
                UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_UNIT.PRODUCT_UNIT_ID#"> AND
                PRICESTANDART_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
        </cfquery>
        <cfquery name="ADD_STANDART_PRICE" datasource="#dsn1#">
            INSERT INTO #dsn1#.PRICE_STANDART 
                (
                    PRODUCT_ID,
                    PURCHASESALES,							
                    PRICE,
                    PRICE_KDV,
                    IS_KDV,
                    ROUNDING,
                    START_DATE,
                    RECORD_DATE,
                    RECORD_IP,
                    PRICESTANDART_STATUS,
                    MONEY,
                    UNIT_ID,
                    RECORD_EMP
                )
            VALUES 
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pid#">,
                    <cfqueryparam cfsqltype="cf_sql_smallint" value="1">,							
                    <cfqueryparam cfsqltype="cf_sql_float" value="#price_kdvsiz#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#price_kdvli#">,
                    <cfqueryparam cfsqltype="cf_sql_smallint" value="#price_is_tax_included#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bugun_00#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTEADDR#">,
                    <cfqueryparam cfsqltype="cf_sql_smallint" value="1">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MONEY_ID_SS#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_UNIT.PRODUCT_UNIT_ID#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">
                )						
        </cfquery>
    </cfif>
    <cfreturn arguments.pid>
    </cffunction>  
    
    <!---get product image --->
    <cffunction name="get_product_images" returntype="query">
    <cfargument name="product_id" required="yes" type="numeric" hint="Ürün Id" default="0"> 
            <cfquery name="GET_IMAGES" datasource="#DSN1#">
                SELECT 
                    PI.IMAGE_SIZE,
                    PI.PRODUCT_IMAGEID,
                    PI.PATH,
                    PI.DETAIL,
                    PI.PATH_SERVER_ID,
                    PI.STOCK_ID,
                    PI.IS_EXTERNAL_LINK,
                    P.PRODUCT_NAME,
                    P.PRODUCT_ID ID
                FROM
                    PRODUCT_IMAGES PI,
                    PRODUCT P
                WHERE
                    P.PRODUCT_ID = PI.PRODUCT_ID AND
                    PI.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
                ORDER BY
                    PI.PRODUCT_IMAGEID DESC
            </cfquery>
        <cfreturn get_images>
    </cffunction>
    
    <!---Sirket Akis Parametrelerinde Ürün parametre bilgisi şirkete bağlı olarak gelsin mi secenegi evet ise buradan ceker, degilse eski yapi devam eder --->
    <cffunction name="get_product_general_parameters" returntype="query">
    <cfargument name="product_id" required="yes" type="numeric" hint="Ürün Id" default="0"> 
            <cfquery name="get_product_general_parameters" datasource="#DSN1#">
               SELECT
                    PRODUCT_PARAMETERS_ID, 
                    PRODUCT_ID, 
                    COMPANY_ID, 
                    PRODUCT_STATUS, 
                    IS_INVENTORY, 
                    IS_PRODUCTION, 
                    IS_SALES, 
                    IS_PURCHASE, 
                    IS_PROTOTYPE, 
                    IS_INTERNET, 
                    IS_EXTRANET, 
                    IS_TERAZI, 
                    IS_KARMA, IS_ZERO_STOCK, 
                    IS_LIMITED_STOCK, 
                    IS_SERIAL_NO, 
                    IS_COST, 
                    IS_QUALITY, 
                    IS_COMMISSION, 
                    OUR_COMPANY_ID, 
                    PRODUCT_MANAGER, 
                    IS_ADD_XML, 
                    IS_GIFT_CARD, 
                    GIFT_VALID_DAY, 
                    QUALITY_START_DATE, 
                    IS_LOT_NO
                FROM 
                    PRODUCT_GENERAL_PARAMETERS
                WHERE 
                    PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"> 
                    AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
            </cfquery>
        <cfreturn get_product_general_parameters>
    </cffunction>
</cfcomponent>