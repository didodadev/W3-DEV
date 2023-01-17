<cf_get_lang_set module_name="product">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
   <cf_xml_page_edit>
    <cfinclude template="../product/query/get_price_cat.cfm">    
    <cfinclude template="../product/query/get_money.cfm">
    <cfparam name="attributes.employee" default="">
    <cfparam name="attributes.product_name" default="">
    <cfparam name="attributes.product_code" default="">
    <cfparam name="attributes.manufact_code" default="">
    <cfparam name="attributes.brand_id" default="">
    <cfparam name="attributes.pos_code" default="">
    <cfparam name="attributes.product_cat" default="">
    <cfparam name="attributes.product_catid" default="0">
    <cfparam name="attributes.get_company_id" default="">
    <cfparam name="attributes.get_company" default="">
    <cfparam name="attributes.is_active" default="-2">
    <cfparam name="attributes.referans_price_list" default="">
    <cfparam name="attributes.rec_date" default="">
    <cfparam name="attributes.price_rec_date" default="">
    <cfparam name="attributes.brand_id" default="">
    <cfparam name="attributes.brand_name" default="">
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1> 
    <cfif len(attributes.rec_date)><cf_date tarih='attributes.rec_date'></cfif>
    <cfif len(attributes.price_rec_date)><cf_date tarih='attributes.price_rec_date'></cfif>
    <cfquery name="GET_COMPETITIVE_LIST" datasource="#DSN3#">
        SELECT COMPETITIVE_ID FROM PRODUCT_COMP_PERM WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
    </cfquery>
    <cfset competitive_list = valuelist(get_competitive_list.competitive_id)>
    
    <!--- event değişebilir --->    
    <cfif len(attributes.product_cat) and len(attributes.product_catid)>
                    <cfquery name="GET_PRODUCT_CATS" datasource="#DSN3#">
                        SELECT 
                            PRODUCT_CATID, 
                            HIERARCHY
                        FROM 
                            PRODUCT_CAT 
                        WHERE 
                            PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#">
                        ORDER BY 
                            HIERARCHY
                    </cfquery>		  
                </cfif> 
    <cfquery name="check_table" datasource="#DSN3#">
        IF EXISTS (select * from tempdb.sys.tables where name='####GET_PRODUCT_collacted_#session.ep.userid#_#DSN3#')
        DROP TABLE ####GET_PRODUCT_collacted_#session.ep.userid#_#DSN3#
    </cfquery>
    <cfquery name="INSERT_GET_PRODUCT" datasource="#DSN3#">
        SELECT 
            P.MANUFACT_CODE,
            P.PRODUCT_NAME, 
            P.RECORD_DATE, 
            P.PRODUCT_CODE,
            P.PRODUCT_ID,
            P.BRAND_ID,
            P.TAX,
            P.TAX_PURCHASE,
            P.MAX_MARGIN,
            P.MIN_MARGIN,
            P.PROD_COMPETITIVE,
            PU.PRODUCT_UNIT_ID,
            PU.MAIN_UNIT,
            PRODUCT_CAT.PRODUCT_CAT,
            P.BARCOD
        INTO ####GET_PRODUCT_collacted_#session.ep.userid#_#DSN3#
        FROM 
            PRODUCT P,
            PRODUCT_UNIT PU,
            PRODUCT_CAT
        WHERE 
            P.PRODUCT_ID = PU.PRODUCT_ID AND
            P.PRODUCT_STATUS = 1 AND
            PU.IS_MAIN = 1 AND
            PU.PRODUCT_UNIT_STATUS = 1 AND
            PRODUCT_CAT.PRODUCT_CATID = P.PRODUCT_CATID
            <cfif len(attributes.product_cat) and len(attributes.product_catid)>
                AND P.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_product_cats.hierarchy#.%">
            </cfif>
            <cfif len(attributes.employee) and len(attributes.pos_code)>
                AND P.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#">
            </cfif>
            <cfif len(attributes.get_company) and len(attributes.get_company_id)>
                AND P.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.get_company_id#">
            </cfif>
            <cfif len(attributes.brand_id)>
                AND P.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">
            </cfif>
            <cfif len(attributes.rec_date)>
                AND P.RECORD_DATE >= #attributes.rec_date#
            </cfif>
            <cfif len(attributes.product_name)>
                AND (P.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.product_name#%"> OR  P.BARCOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.product_name#%"> OR P.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.product_name#%">)
            </cfif>
            <cfif len(attributes.product_code)>
                AND (P.PRODUCT_CODE_2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.product_code#%">)
            </cfif>
            <cfif len(attributes.manufact_code)>
                AND (P.MANUFACT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.manufact_code#%">)
            </cfif>
            <cfif attributes.is_active eq -1>
                AND P.IS_PURCHASE = 1
            </cfif>          
        ORDER BY 
            P.PRODUCT_NAME
    </cfquery>
    <cfquery name="GET_PRODUCT" datasource="#DSN3#">
             WITH CTE1 AS (SELECT * FROM ####GET_PRODUCT_collacted_#session.ep.userid#_#DSN3# ),
                   CTE2 AS (
                        SELECT
                            CTE1.*,
                            ROW_NUMBER() OVER (	ORDER BY  PRODUCT_NAME
                                            ) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                        FROM
                            CTE1
                    )
                    SELECT
                        CTE2.*
                    FROM
                        CTE2
                    WHERE
                        RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1) 
    </cfquery>
    <cfparam name="attributes.totalrecords" default="#GET_PRODUCT.query_count#">
    <cfset product_id_list =ValueList(get_product.product_id,',')>
    <cfset newrecordcount = 0>
    <cfif get_product.recordcount>
    	<!---GET_PRODUCT_P_DISCOUNT_ALL--->
        <cfquery name="GET_PRODUCT_P_DISCOUNT_ALL" datasource="#DSN3#">
            SELECT
                CPPD.DISCOUNT1,
                CPPD.DISCOUNT2,
                CPPD.DISCOUNT3,
                CPPD.DISCOUNT4,
                CPPD.DISCOUNT5,
                CPPD.PRODUCT_ID,
                CPPD.RECORD_DATE
            FROM
                CONTRACT_PURCHASE_PROD_DISCOUNT CPPD,
                PRODUCT PR
            WHERE
                CPPD.PRODUCT_ID = PR.PRODUCT_ID AND
                PR.PRODUCT_STATUS = 1
            <cfif len(attributes.product_cat) and len(attributes.product_catid)>
                AND PR.PRODUCT_CODE LIKE '#get_product_cats.hierarchy#.%'
            </cfif>
            <cfif len(attributes.employee) and len(attributes.pos_code)>
                AND PR.PRODUCT_MANAGER = #attributes.pos_code#
            </cfif>
            <cfif len(attributes.get_company) and len(attributes.get_company_id)>
                AND PR.COMPANY_ID = #attributes.get_company_id#
            </cfif>
            <cfif len(attributes.brand_id)>
                AND PR.BRAND_ID = #attributes.brand_id#
            </cfif>
            <cfif len(attributes.rec_date)>
                AND PR.RECORD_DATE >= #attributes.rec_date#
            </cfif>
            <cfif len(attributes.product_name)>
                AND (PR.PRODUCT_NAME LIKE '%#attributes.product_name#%' OR  PR.BARCOD LIKE '%#attributes.product_name#%' OR PR.PRODUCT_CODE LIKE '%#attributes.product_name#%')
            </cfif>
            <cfif len(attributes.product_code)>
                AND (PR.PRODUCT_CODE_2 LIKE '%#attributes.product_code#%')
            </cfif>
            <cfif attributes.is_active eq -1>
                AND PR.IS_PURCHASE = 1
            </cfif>
    
            ORDER BY 
                CPPD.START_DATE DESC
        </cfquery>
        <!---GET_PRICE_STANDART_ALL--->
        <cfquery name="GET_PRICE_STANDART_ALL" datasource="#DSN3#">
            SELECT
                PS.MONEY,
                PS.PRICE,
                PS.PRICE_KDV,
                PS.IS_KDV,
                PS.PRODUCT_ID,
                PS.PURCHASESALES,
                PS.PRICESTANDART_STATUS,
                PS.UNIT_ID,
                PS.START_DATE,
                PS.RECORD_DATE
            FROM
                PRICE_STANDART PS,
                PRODUCT PR,
                PRODUCT_UNIT PU
            WHERE
                PS.PRODUCT_ID = PR.PRODUCT_ID AND
                PR.PRODUCT_ID = PU.PRODUCT_ID AND
                PR.PRODUCT_STATUS = 1 AND
                PU.IS_MAIN = 1
            <cfif len(attributes.price_rec_date)>
                AND PS.START_DATE <= #attributes.price_rec_date#
            <cfelse>
                AND PS.PRICESTANDART_STATUS = 1
            </cfif>
            <cfif len(attributes.product_cat) and len(attributes.product_catid)>
                AND PR.PRODUCT_CODE LIKE '#get_product_cats.hierarchy#.%'
            </cfif>
            <cfif len(attributes.employee) and len(attributes.pos_code)>
                AND PR.PRODUCT_MANAGER = #attributes.pos_code#
            </cfif>
            <cfif len(attributes.get_company) and len(attributes.get_company_id)>
                AND PR.COMPANY_ID = #attributes.get_company_id#
            </cfif>	
            <cfif len(attributes.brand_id)>
                AND PR.BRAND_ID = #attributes.brand_id#
            </cfif>
            <cfif len(attributes.rec_date)>
                AND PR.RECORD_DATE >= #attributes.rec_date#
            </cfif>
            <cfif len(attributes.product_name)>
                AND (PR.PRODUCT_NAME LIKE '%#attributes.product_name#%' OR  PR.BARCOD LIKE '%#attributes.product_name#%' OR PR.PRODUCT_CODE LIKE '%#attributes.product_name#%')
            </cfif>
            <cfif len(attributes.product_code)>
                AND (PR.PRODUCT_CODE_2 LIKE '%#attributes.product_code#%')
            </cfif>
            <cfif attributes.is_active eq -1>
                AND PR.IS_PURCHASE = 1
            </cfif>
        </cfquery>
        
        <cfif attributes.is_active neq -2>
            <!---GET_PRICE_STANDART_SALES_ALL--->
            <cfquery name="GET_PRICE_STANDART_SALES_ALL" datasource="#DSN3#">
                SELECT
                    P.MONEY,
                    P.PRICE,
                    P.PRICE_KDV,
                    P.IS_KDV,
                    P.PRODUCT_ID,
                    P.PRICE_CATID,
                    P.UNIT,
                    P.CATALOG_ID
                FROM
                    PRICE P,
                    PRODUCT PR,
                    PRODUCT_UNIT PU
                WHERE
                    P.PRODUCT_ID = PR.PRODUCT_ID AND
                    PR.PRODUCT_ID = PU.PRODUCT_ID AND
                    ISNULL(P.STOCK_ID,0)=0 AND
                    ISNULL(P.SPECT_VAR_ID,0)=0 AND
                    P.STARTDATE <= #now()# AND
                    (P.FINISHDATE >= #now()# OR P.FINISHDATE IS NULL) AND
                    PR.PRODUCT_STATUS = 1 AND
                    PU.IS_MAIN = 1
                <cfif len(attributes.product_cat) and len(attributes.product_catid)>
                    AND PR.PRODUCT_CODE LIKE '#get_product_cats.hierarchy#.%'
                </cfif>
                <cfif len(attributes.employee) and len(attributes.pos_code)>
                    AND PR.PRODUCT_MANAGER = #attributes.pos_code#
                </cfif>
                <cfif len(attributes.get_company) and len(attributes.get_company_id)>
                    AND PR.COMPANY_ID = #attributes.get_company_id#
                </cfif>
                    AND P.PRICE_CATID = #attributes.is_active#
                <cfif len(attributes.brand_id)>
                    AND PR.BRAND_ID = #attributes.brand_id#
                </cfif>
                <cfif len(attributes.rec_date)>
                    AND PR.RECORD_DATE >= #attributes.rec_date#
                </cfif>
                <cfif len(attributes.product_name)>
                    AND (PR.PRODUCT_NAME LIKE '%#attributes.product_name#%' OR  PR.BARCOD LIKE '%#attributes.product_name#%' OR PR.PRODUCT_CODE LIKE '%#attributes.product_name#%')
                </cfif>
                <cfif len(attributes.product_code)>
                    AND (PR.PRODUCT_CODE_2 LIKE '%#attributes.product_code#%')
                </cfif>
                <cfif attributes.is_active eq -1>
                    AND PR.IS_PURCHASE = 1
                </cfif>
            </cfquery>
        </cfif>
        <cfif len(attributes.referans_price_list)><!--- Referans Fiyat Listesi Seçilmiş ise öncelikle burda bu fiyat listesine ait tüm fiyatları seçiyoruz. --->
            <cfif not len(product_id_list)> <cfset product_id_list = 0></cfif>
            <cfif attributes.referans_price_list is 'm'><!--- Maliyet seçilmiş ise maliyetten fiyatları getirsin. --->
                <cfquery name="GET_PRICE_REFERANS_SALES_ALL" datasource="#DSN1#">
                    SELECT
                       PRODUCT_COST. PRODUCT_ID,
                        -1 PRICE_CATID,
                        PRODUCT_COST.PRODUCT_COST AS PRICE,
                        PRODUCT_COST.MONEY
                    FROM
                        PRODUCT_COST JOIN ####GET_PRODUCT_collacted_#session.ep.userid#_#DSN3# TEMP  ON 	TEMP.PRODUCT_ID = PRODUCT_COST.PRODUCT_ID
                    WHERE
                        PRODUCT_COST_STATUS = 1 
                    ORDER BY
                        START_DATE DESC
                        <cfif isdefined("rec_date") and len(rec_date)>,
                        RECORD_DATE DESC
                        </cfif>
                </cfquery>
              
            <cfelseif attributes.referans_price_list eq -4><!--- Son Alışlar ise --->
                <cfquery name="GET_PRICE_REFERANS_SALES_ALL" datasource="#DSN1#">
                    SELECT
                        PU.PRODUCT_UNIT_ID,
                        PU.PRODUCT_ID,
                        -4 PRICE_CATID,
                        ISNULL((SELECT TOP 1 IR.PRICE_OTHER FROM #dsn2_alias#.INVOICE_ROW AS IR,#dsn2_alias#.INVOICE AS I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = 0 AND PU.PRODUCT_UNIT_ID = IR.UNIT_ID AND IR.PRODUCT_ID = P.PRODUCT_ID ORDER BY I.INVOICE_DATE DESC ),0) AS PRICE,
                        (SELECT TOP 1 IR.OTHER_MONEY FROM #dsn2_alias#.INVOICE_ROW AS IR,#dsn2_alias#.INVOICE AS I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = 0 AND PU.PRODUCT_UNIT_ID = IR.UNIT_ID AND IR.PRODUCT_ID = P.PRODUCT_ID ORDER BY I.INVOICE_DATE DESC ) as MONEY
                    FROM 
                        PRODUCT_UNIT PU JOIN ####GET_PRODUCT_collacted_#session.ep.userid#_#DSN3# TEMP  ON TEMP.PRODUCT_ID = PU.PRODUCT_ID ,
                        PRODUCT P 
                    WHERE
                        P.PRODUCT_ID = PU.PRODUCT_ID 
                </cfquery>
            <cfelse>
                <cfquery name="GET_PRICE_REFERANS_SALES_ALL" datasource="#DSN3#">
                    SELECT
                        P.MONEY,
                        P.PRICE,
                        P.PRICE_KDV,
                        P.IS_KDV,
                        P.PRODUCT_ID,
                        P.PRICE_CATID,
                        P.UNIT,
                        P.CATALOG_ID
                    FROM
                        PRICE P,
                        PRODUCT PR,
                        PRODUCT_UNIT PU
                    WHERE
                        P.PRODUCT_ID = PR.PRODUCT_ID AND
                        PR.PRODUCT_ID = PU.PRODUCT_ID AND
                        ISNULL(P.STOCK_ID,0)=0 AND
                        ISNULL(P.SPECT_VAR_ID,0)=0 AND

                        P.STARTDATE <= #now()# AND
                        (P.FINISHDATE >= #now()# OR P.FINISHDATE IS NULL) AND
                        PR.PRODUCT_STATUS = 1 AND
                        PU.IS_MAIN = 1
                    <cfif len(attributes.product_cat) and len(attributes.product_catid)>
                        AND PR.PRODUCT_CODE LIKE '#get_product_cats.hierarchy#.%'
                    </cfif>
                    <cfif len(attributes.employee) and len(attributes.pos_code)>
                        AND PR.PRODUCT_MANAGER = #attributes.pos_code#
                    </cfif>
                    <cfif len(attributes.get_company) and len(attributes.get_company_id)>
                        AND PR.COMPANY_ID = #attributes.get_company_id#
                    </cfif>
                        AND P.PRICE_CATID = #attributes.referans_price_list#
                        AND P.PRODUCT_ID IN (SELECT PRODUCT_ID FROM ####GET_PRODUCT_collacted_#session.ep.userid#_#DSN3#)
                    </cfquery>
            </cfif>	
         </cfif>
         <cfif len(attributes.price_rec_date) and (attributes.is_active eq -1  or attributes.is_active eq -2 )>
			  <cfset totalrecords =  0>
              <cfoutput query="get_product">
                    <cfquery name="GET_PRICE_STANDART_PURCHASE" dbtype="query" maxrows="1">
                        SELECT
                            MONEY,
                            PRICE,
                            PRICE_KDV
                        FROM
                            GET_PRICE_STANDART_ALL
                        WHERE
                            <cfif len(attributes.price_rec_date)>
                            START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.price_rec_date#"> AND
                            START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1,attributes.price_rec_date)#"> AND
                            <cfelse>
                            PRICESTANDART_STATUS = 1 AND
                            </cfif>
                            PRODUCT_ID = #PRODUCT_ID# AND
                            PURCHASESALES = 0 AND
                            UNIT_ID = #PRODUCT_UNIT_ID#
                        <cfif len(attributes.price_rec_date)>
                        ORDER BY 
                            START_DATE DESC,
                            RECORD_DATE DESC
                        </cfif>
                    </cfquery>
                    <cfquery name="GET_PRICE_STANDART_SALES_COLUMN" dbtype="query" maxrows="1">
                        SELECT
                            MONEY,
                            PRICE,
                            PRICE_KDV,
                            IS_KDV
                        FROM
                            GET_PRICE_STANDART_ALL
                        WHERE
                            <cfif len(attributes.price_rec_date)>
                            START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.price_rec_date#"> AND
                            START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1,attributes.price_rec_date)#"> AND
                            <cfelse>
                            PRICESTANDART_STATUS = 1 AND
                            </cfif>
                            PRODUCT_ID = #PRODUCT_ID# AND
                            PURCHASESALES = 1 AND
                            UNIT_ID = #PRODUCT_UNIT_ID#
                        <cfif len(attributes.price_rec_date)>
                        ORDER BY 
                            START_DATE DESC,
                            RECORD_DATE DESC
                        </cfif>
                    </cfquery>
                    <cfif not len(attributes.price_rec_date) or (len(attributes.price_rec_date) and attributes.is_active eq -1 and get_price_standart_purchase.recordcount) or (len(attributes.price_rec_date) and attributes.is_active eq -2 and GET_PRICE_STANDART_SALES_COLUMN.recordcount)>
                        <cfset totalrecords =  totalrecords +  1>
                    </cfif>
              </cfoutput>
          <cfelse>
                <cfset  totalrecords =  get_product.query_count>
          </cfif>
    </cfif>  
<cfelseif isdefined("attributes.event") and attributes.event is 'updmixproduct'>
    <cfinclude template="../product/query/get_money.cfm">
    <cfparam name="attributes.product_id" default="">
    <cfparam name="attributes.pos_code" default="">
    <cfparam name="attributes.employee" default="">
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.company_name" default="">
    <cfparam name="attributes.product_catid" default="">
    <cfparam name="attributes.product_name" default="">
    <cfparam name="attributes.product_cat" default="">
    <cfparam name="attributes.p_product_id" default="">
    <cfparam name="attributes.product_model_name" default="">
    <cfparam name="attributes.brand_id" default="">
    <cfparam name="attributes.brand_name" default="">
    <cfparam name="attributes.product_model_id" default="">
    <cfparam name="attributes.product_model_name" default="">
    <cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>  
    <cfif IsDefined("attributes.form_varmi") and len (attributes.p_product_id)>
    	<cfquery name="get_mix_prod_price" datasource="#DSN1#">
            SELECT
                KP.ENTRY_ID,
                KP.KARMA_PRODUCT_ID,
                KP.PRODUCT_NAME,
                S.BARCOD,
                PC.PRODUCT_CAT,
                KP.PRODUCT_NAME+ ' ' +S.PROPERTY AS 'URUN',
                KP.SALES_PRICE,
                KP.MONEY,
                KP.UNIT
             FROM 
                KARMA_PRODUCTS KP
                INNER JOIN PRODUCT P ON P.PRODUCT_ID = KP.PRODUCT_ID
                INNER JOIN PRODUCT_CAT PC ON PC.PRODUCT_CATID = P.PRODUCT_CATID
                INNER JOIN STOCKS S ON KP.STOCK_ID =S.STOCK_ID 
             WHERE 
                  
                     KP.KARMA_PRODUCT_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_product_id#"> 
                <cfif isdefined("attributes.product_catid") and isdefined("attributes.product_cat") and len (attributes.product_catid) and len (attributes.product_cat)>
                    AND PC.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#">
                </cfif>
                <cfif isdefined("attributes.brand_name") and isdefined("attributes.brand_id") and len (attributes.brand_id) and len (attributes.brand_name)>
                    AND P.BRAND_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#"> 
                </cfif>
                <cfif isdefined("attributes.product_model_id") and isdefined("attributes.product_model_name") and len (attributes.product_model_id) and len (attributes.product_model_name)>
                    AND P.BRAND_ID =<cfqueryparam cfsqltype="cf_sql_integer" value=" #attributes.product_model_id#"> 
                </cfif>
        </cfquery>
        <cfparam name="attributes.totalrecords" default="#get_mix_prod_price.recordcount#">
         <cfquery name="GET_PRICE" datasource="#DSN3#">
            SELECT
                PRICE,
                PRICE_KDV,
                IS_KDV,
                MONEY 
            FROM
                PRICE_STANDART,
                PRODUCT_UNIT
            WHERE
                PRICE_STANDART.PURCHASESALES = 1 AND
                PRODUCT_UNIT.IS_MAIN = 1 AND 
                PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
                PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND 
                PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID AND	
                PRICE_STANDART.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_product_id#">
        </cfquery>
    </cfif>      
<cfelseif isdefined("attributes.event") and attributes.event is "updpricetotal"> 
    <cfinclude template="../product/query/get_money.cfm">
    <cfinclude template="../product/query/get_price_cat.cfm">
    <cfparam name="attributes.employee" default="">
    <cfparam name="attributes.product_name" default="">
    <cfparam name="attributes.pos_code" default="">
    <cfparam name="attributes.product_cat" default="">
    <cfparam name="attributes.product_catid" default="0">
    <cfparam name="attributes.stock_id" default="">
    <cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.company_name" default="">
    <cfparam name="attributes.price_cat_list" default="">
    <cfparam name="attributes.referans_price_list" default="">
    <cfparam name="attributes.rec_date" default="">
    <cfparam name="attributes.price_rec_date" default="">
    <cfparam name="attributes.brand_id" default="">
    <cfparam name="attributes.brand_name" default="">
    <cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
    <cfif len(attributes.rec_date)>
        <cf_date tarih='attributes.rec_date'>
    </cfif>
    <cfif len(attributes.price_rec_date)>
        <cf_date tarih='attributes.price_rec_date'>
    </cfif>
    <cfset adres = url.fuseaction>
    <cfif isDefined('attributes.form_submit') and len(attributes.form_submit)>
        <cfset adres = '#adres#&form_submit=#attributes.form_submit#'>
    </cfif>
    <cfif isDefined('attributes.price_cat_list') and len(attributes.price_cat_list)>
        <cfset adres = '#adres#&price_cat_list=#attributes.price_cat_list#'>
    </cfif>
    <cfif isDefined('attributes.referans_price_list') and len(attributes.referans_price_list)>
        <cfset adres = '#adres#&referans_price_list=#attributes.referans_price_list#'>
    </cfif>
    <cfif isDefined('attributes.company_id') and len(attributes.company_id)>
        <cfset adres = '#adres#&company_id=#attributes.company_id#'>
    </cfif>
    <cfif isDefined('attributes.company_name') and len(attributes.company_name)>
        <cfset adres = '#adres#&company_name=#attributes.company_name#'>
    </cfif>
    <cfif isDefined('attributes.price_rec_date') and len(attributes.price_rec_date)>
        <cfset adres = "#adres#&price_rec_date=#dateformat(attributes.price_rec_date,'dd/mm/yyyy')#">
    </cfif>
    <cfif isDefined('attributes.product_name') and len(attributes.product_name)>
        <cfset adres = "#adres#&product_name=#attributes.product_name#">
    </cfif>
    <cfif isDefined('attributes.product_catid') and len(attributes.product_catid)>
        <cfset adres = "#adres#&product_catid=#attributes.product_catid#">
    </cfif>
    <cfif isDefined('attributes.product_id') and len(attributes.product_id)>
        <cfset adres = "#adres#&product_id=#attributes.product_id#">
    </cfif>
    <cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>
        <cfset adres = "#adres#&stock_id=#attributes.stock_id#">
    </cfif>
    <cfif isDefined('attributes.product_cat') and len(attributes.product_cat)>
        <cfset adres = "#adres#&product_cat=#attributes.product_cat#">
    </cfif>
    <cfif isDefined('attributes.rec_date') and len(attributes.rec_date)>
        <cfset adres = "#adres#&rec_date=#attributes.rec_date#">
    </cfif>
    <cfif isDefined('attributes.pos_code') and len(attributes.pos_code)>
        <cfset adres = "#adres#&pos_code=#attributes.pos_code#">
    </cfif>
    <cfif isDefined('attributes.employee') and len(attributes.employee)>
        <cfset adres = "#adres#&employee=#attributes.employee#">
    </cfif>
    <cfif isDefined('attributes.brand_id') and len(attributes.brand_id)>
        <cfset adres = "#adres#&brand_id=#attributes.brand_id#">
    </cfif>
    <cfif isDefined('attributes.brand_name') and len(attributes.brand_name)>
        <cfset adres = "#adres#&brand_name=#attributes.brand_name#">
    </cfif>  
    <cfif isdefined('attributes.form_submit')>
    	<cfif len(attributes.product_cat) and len(attributes.product_catid)>
            <cfquery name="GET_PRODUCT_CATS" datasource="#dsn3#">
                SELECT
                    PRODUCT_CATID, 
                    HIERARCHY
                FROM 
                    PRODUCT_CAT 
                WHERE 
                    PRODUCT_CATID = #attributes.product_catid#
                ORDER BY 
                    HIERARCHY
            </cfquery>		  
        </cfif>  
        <cfquery name="GET_PRODUCT" datasource="#DSN3#">
            SELECT 
                PRODUCT.PRODUCT_NAME, 
                PRODUCT.RECORD_DATE, 
                PRODUCT.PRODUCT_CODE,
                PRODUCT.PRODUCT_ID,
                PRODUCT.BRAND_ID,
                PRODUCT.TAX,
                PRODUCT.TAX_PURCHASE,
                PRODUCT.MAX_MARGIN,
                PRODUCT.MIN_MARGIN,
                PRODUCT.PROD_COMPETITIVE,
                PRODUCT_UNIT.PRODUCT_UNIT_ID,
                PRODUCT_UNIT.MAIN_UNIT
            FROM 
                PRODUCT,
                PRODUCT_UNIT
            WHERE 
                PRODUCT.PRODUCT_ID = PRODUCT_UNIT.PRODUCT_ID AND
                PRODUCT.PRODUCT_STATUS = 1 AND
                PRODUCT_UNIT.IS_MAIN = 1 AND
                PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1
                <cfif len(attributes.product_cat) and len(attributes.product_catid)>
                AND PRODUCT_CODE LIKE '#get_product_cats.hierarchy#.%'
                </cfif>
                <cfif len(attributes.employee) and len(attributes.pos_code)>
                AND PRODUCT_MANAGER=#attributes.pos_code#
                </cfif>
                <cfif len(attributes.company_name) and len(attributes.company_id)>
                AND COMPANY_ID = #attributes.company_id#
                </cfif>
                <cfif len(attributes.brand_id) and len(attributes.brand_name)>
                AND BRAND_ID = #attributes.brand_id#
                </cfif>
                <cfif len(attributes.rec_date)>
                AND PRODUCT.RECORD_DATE >= #attributes.rec_date#
                </cfif>
                <cfif len(attributes.product_name)>
                AND PRODUCT.PRODUCT_NAME LIKE '%#attributes.product_name#%'
                </cfif>
        </cfquery>
        <cfparam name="attributes.page" default=1>
        <cfparam name="attributes.totalrecords" default='#get_product.recordcount#'>
        <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
        <cfif get_product.recordcount>
            <!--- Ürüne ait indirimler çekiliyor. --->
            <cfquery name="GET_PRODUCT_P_DISCOUNT_ALL" datasource="#DSN3#">
                SELECT
                    CPPD.DISCOUNT1,
                    CPPD.DISCOUNT2,
                    CPPD.DISCOUNT3,
                    CPPD.DISCOUNT4,
                    CPPD.DISCOUNT5,
                    CPPD.PRODUCT_ID,
                    CPPD.RECORD_DATE
                FROM
                    CONTRACT_PURCHASE_PROD_DISCOUNT CPPD,
                    PRODUCT PR
                WHERE
                    CPPD.PRODUCT_ID = PR.PRODUCT_ID AND
                    PR.PRODUCT_STATUS = 1
                    <cfif len(attributes.product_cat) and len(attributes.product_catid)>
                    AND PR.PRODUCT_CODE LIKE '#get_product_cats.hierarchy#.%'
                    </cfif>
                    <cfif len(attributes.employee) and len(attributes.pos_code)>
                    AND PR.PRODUCT_MANAGER=#attributes.pos_code#
                    </cfif>
                    <cfif len(attributes.company_name) and len(attributes.company_id)>
                    AND PR.COMPANY_ID = #attributes.company_id#
                    </cfif>
                ORDER BY 
                    CPPD.START_DATE DESC
            </cfquery>
            <!--- Ürünlerin standart alış ve satış fiyatları çekiliyor. --->
            <cfquery name="GET_PRICE_STANDART_ALL" datasource="#DSN3#">
            SELECT
                PS.MONEY,
                PS.PRICE,
                PS.PRICE_KDV,
                PS.IS_KDV,
                PS.PRODUCT_ID,
                PS.PURCHASESALES,
                PS.PRICESTANDART_STATUS,
                PS.UNIT_ID,
                PS.START_DATE,
                PS.RECORD_DATE
            FROM
                PRICE_STANDART PS,
                PRODUCT PR,
                PRODUCT_UNIT PU
            WHERE
                PS.PRODUCT_ID = PR.PRODUCT_ID AND
                PR.PRODUCT_ID = PU.PRODUCT_ID AND
                PR.PRODUCT_STATUS = 1 AND
                PU.IS_MAIN = 1
                <cfif len(attributes.price_rec_date)>
                AND PS.START_DATE <= #attributes.price_rec_date#
                <cfelse>
                AND PS.PRICESTANDART_STATUS = 1
                </cfif>
                <cfif len(attributes.product_cat) and len(attributes.product_catid)>
                AND PR.PRODUCT_CODE LIKE '#get_product_cats.hierarchy#.%'
                </cfif>
                <cfif len(attributes.employee) and len(attributes.pos_code)>
                AND PR.PRODUCT_MANAGER=#attributes.pos_code#
                </cfif>
                <cfif len(attributes.company_name) and len(attributes.company_id)>
                AND PR.COMPANY_ID = #attributes.company_id#
                </cfif>				
            </cfquery>
            <!--- Seçilen Liste Fiyatları Geliyor--->
            <cfquery name="GET_PRICE_LIST_SALES_ALL" datasource="#DSN3#">
                SELECT
                    P.MONEY,
                    P.PRICE,
                    P.PRICE_KDV,
                    P.IS_KDV,
                    P.PRODUCT_ID,
                    P.PRICE_CATID,
                    P.UNIT,
                    P.CATALOG_ID
                FROM
                    PRICE P,
                    PRODUCT PR,
                    PRODUCT_UNIT PU
                WHERE
                    P.PRODUCT_ID = PR.PRODUCT_ID AND
                    PR.PRODUCT_ID = PU.PRODUCT_ID AND
                    ISNULL(P.STOCK_ID,0)=0 AND
                    ISNULL(P.SPECT_VAR_ID,0)=0 AND
                    P.STARTDATE <= #now()# AND
                    (P.FINISHDATE >= #now()# OR P.FINISHDATE IS NULL) AND
                    PR.PRODUCT_STATUS = 1 AND
                    PU.IS_MAIN = 1
                    <cfif len(attributes.product_cat) and len(attributes.product_catid)>
                    AND PR.PRODUCT_CODE LIKE '#get_product_cats.hierarchy#.%'
                    </cfif>
                    <cfif len(attributes.employee) and len(attributes.pos_code)>
                    AND PR.PRODUCT_MANAGER=#attributes.pos_code#
                    </cfif>
                    <cfif len(attributes.company_name) and len(attributes.company_id)>
                    AND PR.COMPANY_ID = #attributes.company_id#
                    </cfif>
                    <!--- AND P.PRICE_CATID = #attributes.price_cat_list# --->
                    AND P.PRICE_CATID IN (#attributes.price_cat_list#)
            </cfquery>
            <!--- Referanssssssssssss --->
            <cfif len(attributes.referans_price_list)><!--- Referans Fiyat Listesi Seçilmiş ise öncelikle burda bu fiyat listesine ait tüm fiyatları seçiyoruz. --->
                <cfif attributes.referans_price_list is 'm'><!--- Maliyet seçilmiş ise maliyetten fiyatları getirsin. --->
                    <cfquery name="GET_PRICE_REFERANS_SALES_ALL" datasource="#dsn1#">
                    SELECT
                        PRODUCT_ID,
                        -1 PRICE_CATID,
                        PRODUCT_COST AS PRICE,
                        MONEY
                    FROM
                        PRODUCT_COST	
                    WHERE
                        PRODUCT_COST_STATUS = 1
                    ORDER BY 
                        START_DATE DESC,RECORD_DATE DESC
                    </cfquery>
                <cfelse><!--- Maliyet değil ise seçilen fiyat listeine göre fiyatlar geliyor. --->
                    <cfquery name="GET_PRICE_REFERANS_SALES_ALL" datasource="#DSN3#">
                        SELECT
                            P.MONEY,
                            P.PRICE,
                            P.PRICE_KDV,
                            P.IS_KDV,
                            P.PRODUCT_ID,
                            P.PRICE_CATID,
                            P.UNIT,
                            P.CATALOG_ID
                        FROM
                            PRICE P,
                            PRODUCT PR,
                            PRODUCT_UNIT PU
                        WHERE
                            P.PRODUCT_ID = PR.PRODUCT_ID AND
                            PR.PRODUCT_ID = PU.PRODUCT_ID AND
                            ISNULL(P.STOCK_ID,0)=0 AND
                            ISNULL(P.SPECT_VAR_ID,0)=0 AND
                            P.STARTDATE <= #now()# AND
                            (P.FINISHDATE >= #now()# OR P.FINISHDATE IS NULL) AND
                            PR.PRODUCT_STATUS = 1 AND
                            PU.IS_MAIN = 1
                            <cfif len(attributes.product_cat) and len(attributes.product_catid)>
                            AND PR.PRODUCT_CODE LIKE '#get_product_cats.hierarchy#.%'
                            </cfif>
                            <cfif len(attributes.employee) and len(attributes.pos_code)>
                            AND PR.PRODUCT_MANAGER=#attributes.pos_code#
                            </cfif>
                            <cfif len(attributes.company_name) and len(attributes.company_id)>
                            AND PR.COMPANY_ID = #attributes.company_id#
                            </cfif>
                            AND P.PRICE_CATID = #attributes.referans_price_list#
                    </cfquery>
                </cfif>	
            </cfif>
        </cfif>
    </cfif>
</cfif>  

<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<script type="text/javascript">	
        function input_control()
        { 	
            bos = 6;
            if(search_product.product_cat.value.length == 0) search_product.product_catid.value = '';
            if(search_product.get_company.value.length == 0) search_product.get_company_id.value = '';
            if(search_product.employee.value.length == 0) search_product.pos_code.value = '';
            if(search_product.brand_name.value.length == 0) search_product.brand_id.value = '';
            
            if (search_product.get_company_id.value == '') bos--;
            if (search_product.product_catid.value == '') bos--;
            if (search_product.pos_code.value == '') bos--;
            if (search_product.brand_id.value == '') bos--;
            if (search_product.product_name.value == '') bos--;
            if (search_product.rec_date.value == '') bos--;
            if(bos < 1)
            {
                alert("<cf_get_lang_main no='1538.En Az Bir arama Kriteri Girmelisiniz'>!");
                return false;
            }
            else
            {
                if(search_product.is_active.selectedIndex > 1)
                {
                    search_product.price_rec_date.disabled = false;
                    search_product.price_rec_date.value = '';
                }
                return true;
            }
        }
        
        function disablePRecDate()
        {
            if (search_product.is_active.selectedIndex > 1)
            {
                search_product.price_rec_date.value = '';
                search_product.price_rec_date.disabled = true;
            }
            else
                search_product.price_rec_date.disabled = false;
        }
        function check_all(deger)
            {
                <cfif get_price_cat.recordcount gt 1>
                    for(i=0; i<search_product.price_cat_list.length; i++)
                        search_product.price_cat_list[i].checked = deger;
                <cfelseif get_price_cat.recordcount eq 1>
                    search_product.price_cat_list.checked = deger;
                </cfif>
            }
    </script>
	<cfif isdefined("get_product")>
        <script type="text/javascript">
        function check_all(deger)
            {
                <cfif get_price_cat.recordcount gt 1>
                    for(i=0; i<form_add_product_property.price_cat_list.length; i++)
                        form_add_product_property.price_cat_list[i].checked = deger;
                <cfelseif get_price_cat.recordcount eq 1>
                    form_add_product_property.price_cat_list.checked = deger;
                </cfif>
            }
            function hesapla_fiyat(k,deger,price_type)//price type güncellenek olan fiyatını nerden alacağını bulmak için eklendi,eğer price_type tanımlı geliyorsa referans fiyat listesindeki fiyat üzerinden hesaplama yapılacak.
            {
                purchase_price = eval('form_add_product_property._ref_price_'+k);  
                tax_purchase_val = eval('form_add_product_property.tax_purchase_val'+k);
                purchase_price_with_tax = eval('form_add_product_property.purchase_price_with_tax'+k);
                sales_price = eval('form_add_product_property.sales_price'+k);
                tax_sales_val = eval('form_add_product_property.tax_sales_val'+k);
                sales_price_with_tax = eval('form_add_product_property.sales_price_with_tax'+k);
                kar_marj_degeri = eval('form_add_product_property.kar_marj_degeri'+k);
                
                sales_price_old = filterNum( eval('form_add_product_property.sales_price_old'+k).value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
                sales_price_with_tax_old = filterNum( eval('form_add_product_property.sales_price_with_tax_old'+k).value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
                
                //Alanlar F1'den geçirilerek Javascript'in anlayacağı hale getiriliyor
                purchase_price.value = filterNum(purchase_price.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
                tax_purchase_val.value = filterNum(tax_purchase_val.value);
                purchase_price_with_tax.value = filterNum(purchase_price_with_tax.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
                sales_price.value = filterNum(sales_price.value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
                tax_sales_val.value = filterNum(tax_sales_val.value,0);
                sales_price_with_tax.value = filterNum(sales_price_with_tax.value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
                kar_marj_degeri.value = filterNum(kar_marj_degeri.value);
                    
                //Default Değerler Burada Yapılıyor
                sales_price_hesap_deger = sales_price.value;
                purchase_price_with_tax_hesap_deger = sales_price_with_tax.value;
                kar_m_deger = kar_marj_degeri.value;
                //Alanların 0'dan Farklılıkları Kontrol Ediliyor
                if(!purchase_price.value.length) purchase_price.value = 0;
                if(!tax_purchase_val.value.length) tax_purchase_val.value = 0;
                if(!purchase_price_with_tax.value.length) purchase_price_with_tax.value = 0;
                if(!sales_price.value.length) sales_price.value = 0;
                if(!tax_sales_val.value.length) tax_sales_val.value = 0;
                if(!sales_price_with_tax.value.length) sales_price_with_tax.value = 0; 
                if(!kar_marj_degeri.value.length) kar_marj_degeri.value = 0; 
                
                if(!sales_price_old.length) sales_price_old = 0; 
                if(!sales_price_with_tax_old.length) sales_price_with_tax_old = 0; 
                
                //İndirimlerin Eval İle k. Değerleri Hesaplanıyor
                discount_1_val = eval('form_add_product_property.discount_1_val'+k).value;
                discount_2_val = eval('form_add_product_property.discount_2_val'+k).value;
                discount_3_val = eval('form_add_product_property.discount_3_val'+k).value;
                discount_4_val = eval('form_add_product_property.discount_4_val'+k).value;
                discount_5_val = eval('form_add_product_property.discount_5_val'+k).value;
                
                //İndirimlerin 0'dan Farklılıkları Kontrol Ediliyor
                if(!discount_1_val.length) discount_1_val = 0;
                if(!discount_2_val.length) discount_2_val = 0;
                if(!discount_3_val.length) discount_3_val = 0;
                if(!discount_4_val.length) discount_4_val = 0;
                if(!discount_5_val.length) discount_5_val = 0;
                purchase_price_hesap_deger = parseFloat(purchase_price.value);
                purchase_price_hesap_deger = wrk_round(purchase_price_hesap_deger,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
                kdvsiz_net_alis = purchase_price_hesap_deger;//(purchase_price_hesap_deger*100)/(100+parseFloat(tax_purchase_val.value));
                //Alış Fiyatı Üzerinden İskontolu KDV'li Satış Fiyatı Hesaplanıyor
                if (deger==1)
                { 					
                    if (sales_price.value != 0 && purchase_price_with_tax.value != 0)
                        {
                            kar_m_deger = (((parseFloat(sales_price.value) - kdvsiz_net_alis )) / kdvsiz_net_alis)*100; //(sales_price.value / purchase_price_hesap_deger); 
                            kar_m_deger = wrk_round(kar_m_deger);
                        }
                }
                    
                //Satış Fiyatı Üzerinden KDV'li Satış Fiyatı Hesaplanıyor
                if (deger==3)
                { 
                    if (sales_price_old.value != sales_price.value)
                    {
                        purchase_price_with_tax_hesap_deger = (parseFloat(sales_price.value) * (100 + parseFloat(tax_sales_val.value)))/100;
                        purchase_price_with_tax_hesap_deger = wrk_round(purchase_price_with_tax_hesap_deger,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
                        if (sales_price.value != 0 && purchase_price_with_tax.value != 0)
                            {
                                kar_m_deger = ((sales_price_hesap_deger - kdvsiz_net_alis) * 100) / kdvsiz_net_alis; //(sales_price.value / purchase_price_with_tax.value);
                                kar_m_deger = wrk_round(kar_m_deger);
                            }
                    }
                }
                
                //KDV'li Satış Fiyatı Üzerinden Satış Fiyatı Hesaplanlıyor
                if(deger==4)
                { 
                    if (sales_price_with_tax_old.value != sales_price_with_tax.value)
                    {
                        sales_price_hesap_deger = (parseFloat(sales_price_with_tax.value)*100)/(100 + parseFloat(tax_sales_val.value)); 
                        sales_price_hesap_deger = wrk_round(sales_price_hesap_deger,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
                        if (sales_price.value != 0 && purchase_price_with_tax.value != 0)
                            {
                            kar_m_deger = ((sales_price_hesap_deger - kdvsiz_net_alis) * 100) / kdvsiz_net_alis;
                            kar_m_deger = wrk_round(kar_m_deger);
                            }
                    }
                }
                
                //Marj Üzerinden Satış Fiyatı Hesaplanlıyor
                if(deger==5)
                {
                    sales_price_kdvsiz = (((kar_m_deger * kdvsiz_net_alis) / 100) + kdvsiz_net_alis);
                    sales_price_hesap_deger = wrk_round(sales_price_kdvsiz*(100 + parseFloat(tax_sales_val.value))/100,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>); 
    
                    purchase_price.value = commaSplit(purchase_price.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
                    tax_purchase_val.value = commaSplit(tax_purchase_val.value);
                    purchase_price_with_tax.value = commaSplit(purchase_price_with_tax.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
                    sales_price.value = commaSplit(sales_price_kdvsiz,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
                    tax_sales_val.value = commaSplit(tax_sales_val.value,0);
                    sales_price_with_tax.value = commaSplit(sales_price_hesap_deger,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
                    kar_marj_degeri.value = commaSplit(kar_m_deger);
                }
                
                //Değerler F2 ve Commasplitten geçiriliyor
                if (deger==1){
                    purchase_price.value = commaSplit(purchase_price.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
                    tax_purchase_val.value = commaSplit(tax_purchase_val.value);
                    purchase_price_with_tax.value = commaSplit(purchase_price_hesap_deger,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
                    sales_price.value = commaSplit(sales_price.value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
                    tax_sales_val.value = commaSplit(tax_sales_val.value,0);
                    sales_price_with_tax.value = commaSplit(sales_price_with_tax.value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
                    kar_marj_degeri.value = commaSplit(kar_m_deger);
                }
                
                //Degerler F2 ve CommaSplitten Geçiriliyor
                if (deger==3){
                    purchase_price.value = commaSplit(purchase_price.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
                    tax_purchase_val.value = commaSplit(tax_purchase_val.value);
                    purchase_price_with_tax.value = commaSplit(purchase_price_with_tax.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
                    sales_price.value = commaSplit(sales_price.value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
                    tax_sales_val.value = commaSplit(tax_sales_val.value,0);
                    sales_price_with_tax.value = commaSplit(purchase_price_with_tax_hesap_deger,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
                    kar_marj_degeri.value = commaSplit(kar_m_deger);
                }
                                
                //Degerler F2 ve CommaSplitten Geçiriliyor
                if (deger==4){
                    purchase_price.value = commaSplit(purchase_price.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
                    tax_purchase_val.value = commaSplit(tax_purchase_val.value);
                    purchase_price_with_tax.value = commaSplit(purchase_price_with_tax.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
                    sales_price.value = commaSplit(sales_price_hesap_deger,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
                    tax_sales_val.value = commaSplit(tax_sales_val.value,0);
                    sales_price_with_tax.value = commaSplit(sales_price_with_tax.value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
                    kar_marj_degeri.value = commaSplit(kar_m_deger);
                }
                //kar marjı sınırlarla ilişkisi anlaşılır
                min_margin = eval('form_add_product_property.min_margin'+k);
                max_margin = eval('form_add_product_property.max_margin'+k);
                //sayfa bozuk kontrol satiri <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                if (kar_m_deger < 0)
                    {
                    kar_marj_degeri.style.color = 'Blue';
                    //alert('Zarar Oranlı İşlem Yaptınız!');
                    }
                else
                    {
                    if (kar_m_deger < min_margin.value)
                        kar_marj_degeri.style.color = 'Red';
                    else if (kar_m_deger > max_margin.value)
                        kar_marj_degeri.style.color = 'Red';
                    else
                        kar_marj_degeri.style.color = 'Black';
                    }
            }
            //Gonderme Esnasında Filter Num İle Temizlemeler Yapılıyor
            function gonder2()
            {
                <cfif newrecordcount gt 1>//get_product.recordcount
                for (h=1; h <= <cfoutput>#newrecordcount#</cfoutput>; h++)//get_product.recordcount
                    {
                        m = h - 1;
                        if (eval('form_add_product_property.is_record_active['+m+'].checked') == true)
                            {
                            n = form_add_product_property.product_id[m].value;
                            purchase_price=eval('form_add_product_property.purchase_price'+n);
                            tax_purchase_val=eval('form_add_product_property.tax_purchase_val'+n);
                            purchase_price_with_tax=eval('form_add_product_property.purchase_price_with_tax'+n);
                            sales_price=eval('form_add_product_property.sales_price'+n);
                            tax_sales_val=eval('form_add_product_property.tax_sales_val'+n);
                            sales_price_with_tax=eval('form_add_product_property.sales_price_with_tax'+n);
                            
                            purchase_price.value = filterNum(purchase_price.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
                            tax_purchase_val.value = filterNum(tax_purchase_val.value);
                            purchase_price_with_tax.value = filterNum(purchase_price_with_tax.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
                            sales_price.value = filterNum(sales_price.value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
                            tax_sales_val.value = filterNum(tax_sales_val.value,0);
                            sales_price_with_tax.value = filterNum(sales_price_with_tax.value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
                            }
                    }
                <cfelse>
                if (form_add_product_property.is_record_active.checked == true)
                    {
                    n = form_add_product_property.product_id.value;
                    purchase_price=eval('form_add_product_property.purchase_price'+n);
                    tax_purchase_val=eval('form_add_product_property.tax_purchase_val'+n);
                    purchase_price_with_tax=eval('form_add_product_property.purchase_price_with_tax'+n);
                    sales_price=eval('form_add_product_property.sales_price'+n);
                    tax_sales_val=eval('form_add_product_property.tax_sales_val'+n);
                    sales_price_with_tax=eval('form_add_product_property.sales_price_with_tax'+n);
                    
                    purchase_price.value = filterNum(purchase_price.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
                    tax_purchase_val.value = filterNum(tax_purchase_val.value);
                    purchase_price_with_tax.value = filterNum(purchase_price_with_tax.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
                    sales_price.value = filterNum(sales_price.value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
                    tax_sales_val.value = filterNum(tax_sales_val.value,0);
                    sales_price_with_tax.value = filterNum(sales_price_with_tax.value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
                    }
                </cfif>
                return true;
            }
            function select_all()
            {
            for (h=1; h <= <cfoutput>#newrecordcount#</cfoutput>; h++)
                {
                    m = h - 1;
                    var check = eval('form_add_product_property.is_record_active['+m+']');
                    
                    check.checked = true;
                
                }
            }
            function not_select_all()
            {
            for (h=1; h <= <cfoutput>#newrecordcount#</cfoutput>; h++)
                {
                    m = h - 1;
                    var check = eval('form_add_product_property.is_record_active['+m+']');
                    
                    check.checked = false;
                
                }
            }
            function uygula_marj(deger)
            {
                <cfloop list="#product_id_list#" index="pid">
                    eval('form_add_product_property.kar_marj_degeri'+<cfoutput>#pid#</cfoutput>).value = commaSplit(deger);
                    hesapla_fiyat(<cfoutput>#pid#</cfoutput>,5,'ref_price');//5'in anlamı marj üzerinden fiyatlama yapıldığını gösteriyor.3.cü gönderilen değerde fiyatın referans fiyat listesi üzerinden hesaplanacağını gösteriyor.
                </cfloop>
            }
            function gonder1(no)
            {
			return false;
              document.getElementById('window_status').value=no;
                if(process_cat_control()==false)
                    return false;
                flag = 0;
                <cfif newrecordcount gt 1>//get_product.recordcount
                for (h=1; h <= <cfoutput>#newrecordcount#</cfoutput>; h++)//get_product.recordcount
                    {
                        m = h - 1;
                        if (eval('form_add_product_property.is_record_active['+m+'].checked') == true)
                        {
                            flag = 1;
                            break;
                        }
                    }
                <cfelse>
                    if (form_add_product_property.is_record_active.checked == true)
                        flag = 1;
                </cfif>
                if (flag == 0)
                    {
                    alert("<cf_get_lang no ='804.En az 1 ürün seçmelisiniz'> !");
                    return false;
                    }
                <cfif attributes.is_active neq -1 and attributes.is_active neq -2> 
                else if
                (
                <cfif get_price_cat.recordcount gt 1>
                    <cfoutput query="get_price_cat">
                    form_add_product_property.price_cat_list[#currentrow-1#].checked == false
                    <cfif get_price_cat.currentrow neq get_price_cat.recordcount>&&</cfif>
                    </cfoutput>
                <cfelseif get_price_cat.recordcount eq 1>
                    form_add_product_property.price_cat_list.checked == false
                </cfif>
                )
                {
                    window.alert("<cf_get_lang no='335.En az bir liste seçmelisiniz'>!");
                    return false;		
                }
                </cfif>
                else
                    {
                        if(!CheckEurodate(form_add_product_property.start_date.value,"<cf_get_lang_main no ='243.Başlama Tarihi'>") || !form_add_product_property.start_date.value.length) 
                            {
                                alert("<cf_get_lang_main no ='1333.Başlama Tarihi girmelisiniz'> !");
                                return false;
                            }
                        return gonder2();
                    }
            }
            disablePRecDate();
        </script>
        <script type="text/javascript">
            function all_money_unit(money_unit)
            {	
                <cfif get_product.recordcount>
                    <cfoutput query="get_product">
                    document.getElementById('sales_money#product_id#').value = money_unit;
                     </cfoutput>
                </cfif>
            }  
        
            function all_is_tax_included()
            {	
                <cfif get_product.recordcount>
                    <cfoutput query="get_product">
                    if(document.form_add_product_property.is_tax_included.checked==true)
                        document.getElementById('is_tax_included#product_id#').checked=true;
                    else
                        document.getElementById('is_tax_included#product_id#').checked=false;					
                    </cfoutput>
                </cfif>
            }  
        </script>
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is "updmixproduct">
	<script>	
		function calculate_grosstotal(type)
		{
			document.form_basket.grosstotal_cost.value = 0;
			document.form_basket.grosstotal_price.value = 0;
			var row_count=<cfoutput>#GET_MONEY.RECORDCOUNT#</cfoutput>
			for(ix=1;ix<row_count+1;ix++){
				
					
					<cfloop query=GET_MONEY>
						if(type =='<cfoutput>#GET_MONEY.MONEY#</cfoutput>')
						{
						document.form_basket.grosstotal_price.value = commaSplit(Number(filterNum(document.form_basket.grosstotal_price.value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>')) + Number(filterNum(eval("document.form_basket.total_product_price"+ix).value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>'))/<cfoutput>#GET_MONEY.RATE2[currentrow]#</cfoutput>,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');
						}
					</cfloop>
					document.form_basket.selected_money.value=type;
				
			}
		}
		
		function hesapla_row(type,row_info)
		{
			
			if(type==2)
			{
			var k= parseFloat(filterNum($('#new_price'+row_info).val(),'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>'));
			var m=eval(document.getElementById('total').value)-eval(k);
			form_value_rate_satir = list_getat(eval("document.getElementById('p_money" + row_info + "')").value,2,';');
			p=eval(form_value_rate_satir) * eval(k);
			$('#total').val()=(eval(m)+ eval(p));
			//document.getElementById('total').value=(eval(m)+ eval(p));
			}
			if(type==3)
			{
				form_value_rate_foot = list_getat(eval("document.getElementById('f_money')").value,2,';');
				var k= parseFloat(filterNum($('#total').val(),'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>'));
			   //	var c=document.getElementById('total').value;
				var c=$('#total').val();
				p=form_value_rate_foot *c;
				$('#total').val()=p;
				//document.getElementById('total').value =p; 
			}
	
	
		}
	</script>
<cfelseif isdefined("attributes.event") and attributes.event is 'updpricetotal'>
	<script type="text/javascript">
		function input_control()
		{
			var is_ok=0;
			var select_count=0;
			if(search_product.referans_price_list.value =='')
			{
				alert("<cf_get_lang no ='813.Referans Fiyat Listesi Seçiniz'>");
				return false;
			}
			if(search_product.price_cat_list.value =='')
			{
				alert("<cf_get_lang no ='814.Düzenlenecek Fiyat Listesi Seçiniz'>");
				return false;
			}
			if(document.search_product.price_cat_list.length)
			{
				for(var i=0;i<document.search_product.price_cat_list.length;i++)
				{
					if (document.search_product.price_cat_list.options[ i ].selected)
						select_count++;
					if(select_count == 6) break;
				}
				if(select_count>5)
				{
					alert("<cf_get_lang no ='815.Düzenlenecek Fiyat Listesi 5 den fazla olamaz'>!");
					return false;
				}
			}	
			if(search_product.product_cat.value.length != 0)
				is_ok++;
			if(search_product.company_id.value.length != 0 && search_product.company_name.value.length != '')	
				is_ok++;
			if(search_product.brand_name.value.length != 0 && search_product.brand_id.value.length != 0)	
				is_ok++;
			if(search_product.employee.value.length != 0 && search_product.pos_code.value.length != 0)
				is_ok++;
			if(search_product.product_name.value.length != 0)
				is_ok++;
			if (is_ok >= 2)
			{
				return true;
			}else
			{
				alert("<cf_get_lang no ='816.Arama kriteri olarak en az iki seçenek seçilmelidir'>!");
				return false;			
			}
		}
    </script>
    <cfif isdefined("get_product")>
		<script type="text/javascript">
            function set_div_position()
            {
                document.getElementById('price_detail_head').style.top=document.getElementById('price_detail').scrollTop+"px";
                document.getElementById('price_detail_head_left').style.top=document.getElementById('price_detail').scrollTop+"px";
                document.getElementById('price_detail_row_left').style.left=document.getElementById('price_detail').scrollLeft+"px";
                document.getElementById('price_detail_head_left').style.left=document.getElementById('price_detail').scrollLeft+"px";
            }
            function select_price_cat(element)
            {
                if(element.checked==true)
                    var check=true;
                else
                    var check=false;
                
                if(eval("document.getElementById('price_cat_product_list_" + element.value + "')").length>0)
                {
                    for(var i=0;i<eval("document.getElementById('price_cat_product_list_"+element.value+"')").length;i++)
                    {
                        eval("document.getElementById('price_cat_product_list_"+element.value+"')")[i].checked=check;
                    }
                }else
                {
                    document.getElementById('price_cat_product_list_'+element.value).checked=check;
                }
            }
    
            
            function hesapla_fiyat(type,product_id,p_cat_id,tax)//price type güncellenek olan fiyatını nerden alacağını bulmak için eklendi,eğer price_type tanımlı geliyorsa referans fiyat listesindeki fiyat üzerinden hesaplama yapılacak.
            {
                //Type == 1 ise Marjın üzerine tıklanmıştır 2 ise Listenin KDV'siz Fiyatının üzerine tıklanmıştır 3 ise KDV'li fiyata tıklanmıştır.
                var row_referance_price = filterNum(document.getElementById('ref_price_'+product_id).value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);//Satırdaki referans fiyatı teşkil ediyor
                var row_price_list_margin = filterNum(document.getElementById('price_cat_margin_'+product_id+'_'+p_cat_id).value);//Satırdaki liste fiyatlarına ait marjı tutuyor
                var row_sales_price_list = filterNum(document.getElementById('sales_price_list_'+product_id+'_'+p_cat_id).value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);//Satırdaki kdv'siz liste fiyatı
                var row_sales_price_list_kdv = filterNum(document.getElementById('sales_price_list_kdv_'+product_id+'_'+p_cat_id).value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);//Satırdaki kdv'li liste fiyatı
                //Tıklanınca gelen liste fiyatının value'sine değer atmak için...
                if (type==1 && row_referance_price > 0)//Marj'ın üzerine tıklanmışsa ona göre liste fiyatını değiştir.
                {
                    //Kdv'siz fiyatı hesapla
                    document.getElementById('sales_price_list_'+product_id+'_'+p_cat_id).value = commaSplit((row_referance_price + ((row_referance_price/100)*row_price_list_margin)),<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
                    //Kdv'li fiyatı hesapla
                    var row_sales_price_list = filterNum(document.getElementById('sales_price_list_'+product_id+'_'+p_cat_id).value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);//Satırdaki kdv'siz liste fiyatı tekrar tanımlanıyor değiştiri 
                    document.getElementById('sales_price_list_kdv_'+product_id+'_'+p_cat_id).value = commaSplit(( row_sales_price_list + (row_sales_price_list/100)*tax),<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
                }
                else if (type==2 && row_referance_price > 0)//Eğer liste fiyatına tıklanmış ise ona göre marjı düzenliyoruz.
                {
                    document.getElementById('price_cat_margin_'+product_id+'_'+p_cat_id).value = commaSplit((row_sales_price_list-row_referance_price) / (row_referance_price/100),2);
                    document.getElementById('sales_price_list_kdv_'+product_id+'_'+p_cat_id).value = commaSplit(row_sales_price_list +((row_sales_price_list/100)*tax),<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
                }
                else if (type==3 && row_referance_price > 0)
                {
                    document.getElementById('sales_price_list_'+product_id+'_'+p_cat_id).value = commaSplit(((row_sales_price_list_kdv)/(100 + tax))*(100),<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);//Satırdaki kdv'siz liste fiyatı yenilendi
                    //burada satırdaki liste fiyatını tekrar tanımladım çünkü kdv'li fiyatın değişmesinden sonra fiyat yenileniyor.
                    var row_sales_price_list = filterNum(document.getElementById('sales_price_list_'+product_id+'_'+p_cat_id).value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);//Satırdaki kdv'siz liste fiyatı tekrar tanımlandı
                    document.getElementById('price_cat_margin_'+product_id+'_'+p_cat_id).value =  commaSplit((row_sales_price_list-row_referance_price) / (row_referance_price/100),2);
                }
            
            }	
            function gonder()
            {
                if(document.all.process_stage.value == '')
                {
                    alert("<cf_get_lang no ='818.Ürün Fiyat Süreci ne Yetkiniz Yok'>");
                    return false;
                }
                if(document.form_add_price.start_date.value == '')
                {
                alert("<cf_get_lang_main no ='326.Başlangıç Tarihi Girmelisiniz'>");
                return false;
                }
    
                for(var p_cat_i=1;p_cat_i <= list_len('<cfoutput>#attributes.price_cat_list#</cfoutput>',',');p_cat_i++)
                {
                    var price_cat_id=list_getat('<cfoutput>#attributes.price_cat_list#</cfoutput>',p_cat_i,',');
                    if(eval('document.form_add_price.price_cat_product_list_'+price_cat_id).length>0)
                    {
                        for(var i=0;i<eval('document.form_add_price.price_cat_product_list_'+price_cat_id).length;i++)
                        {
                            if(eval('document.form_add_price.price_cat_product_list_'+price_cat_id)[i].checked==true)
                            {
                                var product_id=eval('document.form_add_price.price_cat_product_list_'+price_cat_id)[i].value;
                                document.getElementById('sales_price_list_'+product_id+'_'+price_cat_id).value = filterNum(document.getElementById('sales_price_list_'+product_id+'_'+price_cat_id).value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);//Satırdaki kdv'siz liste fiyatı
                                document.getElementById('sales_price_list_kdv_'+product_id+'_'+price_cat_id).value = filterNum(document.getElementById('sales_price_list_kdv_'+product_id+'_'+price_cat_id).value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);//Satırdaki kdv'li liste fiyatı		
                            }
                        }
                    }else
                    {
                        if(eval('document.form_add_price.price_cat_product_list_'+price_cat_id).checked==true)
                        {
                            var product_id=eval('document.form_add_price.price_cat_product_list_'+price_cat_id).value;
                            document.getElementById('sales_price_list_'+product_id+'_'+price_cat_id).value = filterNum(document.getElementById('sales_price_list_'+product_id+'_'+price_cat_id).value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);//Satırdaki kdv'siz liste fiyatı
                            document.getElementById('sales_price_list_kdv_'+product_id+'_'+price_cat_id).value = filterNum(document.getElementById('sales_price_list_kdv_'+product_id+'_'+price_cat_id).value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);//Satırdaki kdv'li liste fiyatı		
                        }                    
                    }
                }              
                return true;
            }
        </script>
    </cfif>
</cfif>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();	
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.collacted_product_prices';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'product/form/add_collacted_product_prices.cfm';	
	WOStruct['#attributes.fuseaction#']['list']['js'] = 'javascript:gizle_goster_ikili("product_prices","product_prices_bask")';
	WOStruct['#attributes.fuseaction#']['list']['default'] = 1;	

	WOStruct['#attributes.fuseaction#']['collectedPrice'] = structNew();
	WOStruct['#attributes.fuseaction#']['collectedPrice']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['collectedPrice']['fuseaction'] = 'product.collacted_product_prices';
	WOStruct['#attributes.fuseaction#']['collectedPrice']['filePath'] = 'product/query/add_collacted_product_prices_amount.cfm';
	WOStruct['#attributes.fuseaction#']['collectedPrice']['queryPath'] = 'product/query/add_collacted_product_prices_amount.cfm';
	WOStruct['#attributes.fuseaction#']['collectedPrice']['nextEvent'] = 'product.collacted_product_prices';
	
	WOStruct['#attributes.fuseaction#']['updmixproduct'] = structNew();
	WOStruct['#attributes.fuseaction#']['updmixproduct']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['updmixproduct']['fuseaction'] = 'product.collacted_product_prices';
	WOStruct['#attributes.fuseaction#']['updmixproduct']['filePath'] = 'product/form/upd_price_mix_product.cfm';
	WOStruct['#attributes.fuseaction#']['updmixproduct']['queryPath'] = 'product/form/upd_price_mix_product.cfm';
	WOStruct['#attributes.fuseaction#']['updmixproduct1']['parameters'] = '';
	WOStruct['#attributes.fuseaction#']['updmixproduct1']['Identity'] = '';	
	WOStruct['#attributes.fuseaction#']['updmixproduct']['nextEvent'] = 'product.collacted_product_prices&event=updmixproduct';
	WOStruct['#attributes.fuseaction#']['updmixproduct']['js'] = "javascript:gizle_goster_ikili('product_prices','product_prices_bask')";
	
	WOStruct['#attributes.fuseaction#']['updmixproduct1'] = structNew();
	WOStruct['#attributes.fuseaction#']['updmixproduct1']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['updmixproduct1']['fuseaction'] = 'product.collacted_product_prices';
	WOStruct['#attributes.fuseaction#']['updmixproduct1']['filePath'] = 'product/form/upd_price_mix_product.cfm';
	WOStruct['#attributes.fuseaction#']['updmixproduct1']['queryPath'] = 'product/query/upd_price_mix_product.cfm';
	WOStruct['#attributes.fuseaction#']['updmixproduct1']['parameters'] = 'p_product_id=##attributes.product_id##';
	WOStruct['#attributes.fuseaction#']['updmixproduct1']['Identity'] = '##attributes.product_id##';
	WOStruct['#attributes.fuseaction#']['updmixproduct1']['nextEvent'] = 'product.collacted_product_prices&event=updmixproduct';
	WOStruct['#attributes.fuseaction#']['updmixproduct1']['js'] = "javascript:gizle_goster_ikili('product_prices','product_prices_bask')";
	
	WOStruct['#attributes.fuseaction#']['updpricetotal'] = structNew();
	WOStruct['#attributes.fuseaction#']['updpricetotal']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['updpricetotal']['fuseaction'] = 'product.collacted_product_prices';
	WOStruct['#attributes.fuseaction#']['updpricetotal']['filePath'] = 'product/form/add_collacted_product_prices_total.cfm';
	WOStruct['#attributes.fuseaction#']['updpricetotal']['queryPath'] = 'product/form/add_collacted_product_prices_total.cfm';
	WOStruct['#attributes.fuseaction#']['updpricetotal']['parameters'] = '';
	WOStruct['#attributes.fuseaction#']['updpricetotal']['Identity'] = '';
	WOStruct['#attributes.fuseaction#']['updpricetotal']['nextEvent'] = 'product.collacted_product_prices&event=updpricetotal';
	WOStruct['#attributes.fuseaction#']['updpricetotal']['js'] = "javascript:gizle_goster_ikili('prices_total_','prices_total_bask_')";
	
	WOStruct['#attributes.fuseaction#']['updpricetotal1'] = structNew();
	WOStruct['#attributes.fuseaction#']['updpricetotal1']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['updpricetotal1']['fuseaction'] = 'product.collacted_product_prices';
	WOStruct['#attributes.fuseaction#']['updpricetotal1']['filePath'] = 'product/form/add_collacted_product_prices_total.cfm';
	WOStruct['#attributes.fuseaction#']['updpricetotal1']['queryPath'] = 'product/query/add_collacted_product_prices_amount_total.cfm';
	WOStruct['#attributes.fuseaction#']['updpricetotal1']['parameters'] = '';
	WOStruct['#attributes.fuseaction#']['updpricetotal1']['Identity'] = '';
	WOStruct['#attributes.fuseaction#']['updpricetotal1']['nextEvent'] = 'product.collacted_product_prices&event=updpricetotal';
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'collectedProductPriceController';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'updmixproduct1';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'KARMA_PRODUCTS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'product';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "[]";
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'collectedProductPriceController';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'updpricetotal1';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'PRICE';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "[]";
	
	if(attributes.event is 'list')
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][0]['text'] = '#lang_array.item[456]# #lang_array.item[379]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=product.collacted_product_prices&event=updmixproduct','horizantal')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][1]['text'] = '#lang_array_main.item[620]# #lang_array.item[379]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=product.collacted_product_prices&event=updpricetotal','horizantal')";
		if(isDefined("form.form_varmi")){
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=product.popup_collacted_product_prices#page_code#','page')";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	else if(attributes.event is 'updmixproduct')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmixproduct'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmixproduct']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmixproduct']['menus'][0]['text'] = '#lang_array_main.item[620]# #lang_array.item[379]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmixproduct']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=product.collacted_product_prices&event=updpricetotal')";
		if(isDefined("form.form_varmi")){
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmixproduct']['icons']['print']['text'] = '#lang_array_main.item[62]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updmixproduct']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=product.popup_collacted_product_prices#page_code#','page')";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	else if(attributes.event is 'updpricetotal')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updpricetotal'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updpricetotal']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updpricetotal']['menus'][0]['text'] = '#lang_array.item[379]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updpricetotal']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=product.collacted_product_prices&event=list')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updpricetotal']['menus'][1]['customTag'] = "<cf_workcube_file_action pdf='1' mail='1' doc='1' print='0'>";

		if(isDefined("form.form_submit")){
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updpricetotal']['icons']['print']['text'] = '#lang_array_main.item[62]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updpricetotal']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=product.popup_collacted_product_prices#page_code#','page')";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	
</cfscript>
