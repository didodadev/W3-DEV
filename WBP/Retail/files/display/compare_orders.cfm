<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.limit" default="0">
<cfparam name="attributes.size_type" default="">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box >
        <cfform name="search_" action="#request.self#?fuseaction=retail.list_stock_count_orders&event=compareOrders&main_order_id=#attributes.main_order_id#" method="post">
            <cf_box_search plus="0">
                <div class="form-group">
                    <cfinput type="text" name="keyword" value="#attributes.keyword#" placeholder="#getLang('','Filtre',57460)#">
                </div>
                <div class="form-group">
                    <select name="size_type" id="size_type">
                        <option value=""><cf_get_lang dictionary_id='62486.Tüm Sayım'></option>  
                        <option value="5"<cfif attributes.size_type eq 5>selected</cfif>>+/- <cf_get_lang dictionary_id='62402.Değer İçi'></option>
                        <option value="4"<cfif attributes.size_type eq 4>selected</cfif>>+/- <cf_get_lang dictionary_id='62403.Değer Dışı'></option>                                       
                        <option value="3"<cfif attributes.size_type eq 3>selected</cfif>><cf_get_lang dictionary_id='39789.Eşittir'></option>
                        <option value="2"<cfif attributes.size_type eq 2>selected</cfif>><cf_get_lang dictionary_id='51823.Eşit Değil'></option>
                        <option value="1" <cfif attributes.size_type eq 1>selected</cfif>><cf_get_lang dictionary_id='39794.Büyüktür'></option>  
                        <option value="0"<cfif attributes.size_type eq 0>selected</cfif>><cf_get_lang dictionary_id='39793.Küçüktür'></option>                                 
                    </select> 
                </div>
                <div class="form-group small">
                    <cfinput type="text" style="width:70px;" id="limit" name="limit" value="#attributes.limit#" class="moneybox" onkeyup="return(FormatCurrency(this,event,2));">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button is_excel="1" button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfset sayim1_id_ = attributes.main_order_id>
    <cfquery name="get_sayim_1" datasource="#dsn_dev#">
        SELECT ORDER_ID,ORDER_DATE,DEPARTMENT_ID FROM STOCK_COUNT_ORDERS WHERE ORDER_ID = #sayim1_id_#
    </cfquery>
    <cfset attributes.department_id = get_sayim_1.DEPARTMENT_ID>
    <cfset attributes.order_date = createodbcdatetime(get_sayim_1.ORDER_DATE)>
    <cfquery name="get_sayim_2" datasource="#dsn_dev#">
        SELECT ORDER_ID FROM STOCK_COUNT_ORDERS WHERE COUNT_TYPE = 2 AND MAIN_ORDER_ID = #sayim1_id_#
    </cfquery>
    <cfset sayim2_id_ = get_sayim_2.ORDER_ID>

    <cfquery name="get_sayim_3" datasource="#dsn_dev#">
        SELECT ORDER_ID FROM STOCK_COUNT_ORDERS WHERE COUNT_TYPE = 3 AND MAIN_ORDER_ID = #sayim1_id_#
    </cfquery>
    <cfset sayim3_id_ = get_sayim_3.ORDER_ID>

    <cfquery name="get_rows" datasource="#dsn_dev#">
    SELECT
        *
    FROM
        (
        SELECT
            SUM(TOPLAM_MIKTAR) AS T1,
            SUM(TOPLAM_MIKTAR_2) AS T2,
            SUM(TOPLAM_MIKTAR_3) AS T3,
            T1.STOCK_ID,
            T1.STOCK_NAME,
            (
                SELECT     
                    SUM(SR.STOCK_IN - SR.STOCK_OUT) AS REAL_STOCK
                FROM          
                    #dsn2_alias#.STOCKS_ROW SR
                WHERE      
                    SR.STORE = #attributes.department_id# AND 
                    SR.PROCESS_DATE <= #attributes.order_date# AND
                    SR.STOCK_ID = T1.STOCK_ID
            )
            AS REAL_STOCK,
            S.BARCOD AS BARCODE,
            S.STOCK_CODE
        FROM
            (
                SELECT 
                    STOCK_ID,
                    STOCK_NAME,
                    SUM(AMOUNT) AS TOPLAM_MIKTAR,
                    0 AS TOPLAM_MIKTAR_2,
                    0 AS TOPLAM_MIKTAR_3
                FROM 
                    STOCK_COUNT_ORDERS_ROWS 
                WHERE 
                    ORDER_ID = #sayim1_id_# AND 
                    STOCK_ID IS NOT NULL
                GROUP BY
                    STOCK_ID,
                    STOCK_NAME
                UNION ALL
                SELECT 
                    STOCK_ID,
                    STOCK_NAME,
                    0 AS TOPLAM_MIKTAR,
                    SUM(AMOUNT) AS TOPLAM_MIKTAR_2,
                    0 AS TOPLAM_MIKTAR_3
                FROM 
                    STOCK_COUNT_ORDERS_ROWS 
                WHERE 
                    ORDER_ID = #sayim2_id_# AND 
                    STOCK_ID IS NOT NULL
                GROUP BY
                    STOCK_ID,
                    STOCK_NAME
                UNION ALL
                SELECT 
                    STOCK_ID,
                    STOCK_NAME,
                    0 AS TOPLAM_MIKTAR,
                    0 AS TOPLAM_MIKTAR_2,
                    SUM(AMOUNT) AS TOPLAM_MIKTAR_3
                FROM 
                    STOCK_COUNT_ORDERS_ROWS 
                WHERE 
                    ORDER_ID = #sayim3_id_# AND 
                    STOCK_ID IS NOT NULL
                GROUP BY
                    STOCK_ID,
                    STOCK_NAME
            ) AS T1,
            #dsn3_alias#.STOCKS S
        WHERE
            S.STOCK_ID = T1.STOCK_ID
        GROUP BY
            S.STOCK_CODE,
            S.BARCOD,
            T1.STOCK_ID,
            T1.STOCK_NAME
        ) T_SON
    WHERE
        <cfif len(attributes.keyword)>
            (
            STOCK_NAME LIKE '%#attributes.keyword#%' OR 
            BARCODE = '#attributes.keyword#'
            )
            AND
        </cfif>
        <cfif len(attributes.size_type) and len(attributes.limit)>
            (T1 - T2)
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
            AND
        </cfif>
        STOCK_ID IS NOT NULL
    ORDER BY
        STOCK_CODE,
        STOCK_NAME,
        STOCK_ID
    </cfquery>
    <!-- sil -->
    <cf_box title="#getLang('','1. Sayım ve 2.Sayım Karşılaştırma',62487)#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='57633.Barkod'></th>
                    <th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='57452.Stok'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='32041.Sayım'> 1</th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='32041.Sayım'> 2</th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='58583.Fark'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='32041.Sayım'> 3</th>
                </tr>
            </thead>
            <tbody>
                <cfoutput query="get_rows">
                    <tr>
                        <td>#currentrow#</td>
                        <td>#BARCODE#</td>
                        <td>#STOCK_NAME#</td>
                        <td style="text-align:right;">#tlformat(REAL_STOCK,2)#</td>
                        <td style="text-align:right;">#tlformat(T1,2)#</td>
                        <td style="text-align:right;">#tlformat(T2,2)#</td>
                        <td style="text-align:right;">#tlformat(T1-T2,2)#</td>
                        <td style="text-align:right;">#tlformat(T3,2)#</td>
                    </tr>
                </cfoutput>
            </tbody>
        </cf_grid_list>
    </cf_box>
</div>
<!-- sil -->