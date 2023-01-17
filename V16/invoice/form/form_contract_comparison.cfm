<!--- type geliyor ve 1 ise satış faturasıdır --->
<!--- diff_type: 
	1 : koşul 
	2 : aksiyon
	3 : sipariş
	4 : fiyat
	5 : kur
	6 : fiyat koruma
	7 : manuel
--->
<cf_get_lang_set module_name="invoice">
<cfparam name="attributes.type" default="0">
<cfif attributes.type eq 0>
    <cfset round_num = session.ep.our_company_info.purchase_price_round_num>
<cfelse>
    <cfset round_num = session.ep.our_company_info.sales_price_round_num>
</cfif>
<cfquery name="get_invoice_all" datasource="#DSN2#">
    SELECT IS_DIFF_DISCOUNT, IS_DIFF_PRICE, MAIN_INVOICE_ROW_ID,DIFF_TYPE,DIFF_INVOICE_ID FROM INVOICE_CONTRACT_COMPARISON WHERE MAIN_INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.iid#">
</cfquery>
<cfquery name="get_invoice_control" datasource="#DSN2#">
    SELECT INVOICE_ID FROM INVOICE_CONTROL WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.iid#">
</cfquery>
<cfset list_inv_row = ValueList(get_invoice_all.main_invoice_row_id)>
<cfinclude template="../query/get_comparisons.cfm">
<cfset prod_list_id=ValueList(get_invoice_info.product_id,',')>

<cfquery name="get_price_cat_exceptions" datasource="#dsn3#">
    SELECT PCE.PRICE_MONEY, PCE.PRICE, PCE.DISCOUNT_RATE, PCE.DISCOUNT_RATE_2, PCE.DISCOUNT_RATE_3, PCE.DISCOUNT_RATE_4, PCE.DISCOUNT_RATE_5 
    FROM PRICE_CAT_EXCEPTIONS AS PCE LEFT JOIN RELATED_CONTRACT AS RC ON PCE.CONTRACT_ID = RC.CONTRACT_ID 
    WHERE <cfif len(get_invoice_info.COMPANY_ID)> PCE.COMPANY_ID = #get_invoice_info.COMPANY_ID# AND </cfif> PCE.PRODUCT_ID IN (#get_invoice_info.PRODUCT_ID#) 
        AND (RC.STARTDATE <= '#get_invoice_info.invoice_date#' AND RC.FINISHDATE >= '#get_invoice_info.invoice_date#') 
</cfquery>
<cfquery name="GET_STD_PRICE" datasource="#DSN1#">
    SELECT
        PRODUCT_ID,
        PRICE,
        <cfif session.ep.period_year lt 2009>
            CASE WHEN PRICE_STANDART.MONEY ='TL' THEN '<cfoutput>#session.ep.money#</cfoutput>' ELSE PRICE_STANDART.MONEY END AS MONEY,
        <cfelseif session.ep.period_year gte 2009>
            CASE WHEN PRICE_STANDART.MONEY ='YTL' THEN '<cfoutput>#session.ep.money#</cfoutput>' ELSE PRICE_STANDART.MONEY END AS MONEY,
        <cfelse>
            PRICE_STANDART.MONEY,
        </cfif> 
        UNIT_ID,
        PURCHASESALES,
        START_DATE,
        RECORD_DATE
    FROM
        PRICE_STANDART
    WHERE
        PURCHASESALES = <cfif attributes.type eq 0>0<cfelse>1</cfif> AND
        PRODUCT_ID IN (#prod_list_id#)
    ORDER BY
        PRODUCT_ID
</cfquery>
<cf_box title="#getLang('','',58751)#">
    <cfif invoice_ship_relation.recordcount eq 1 >(<cf_get_lang dictionary_id ='57358.İrsaliye Nosu'> <cfoutput>#INVOICE_SHIP_RELATION.SHIP_NUMBER#</cfoutput><cf_get_lang dictionary_id ='57360.Olan İrsaliyenin Cari Hesabı Faturadan Farklıdır'>)
    <cfelseif invoice_ship_relation.recordcount gt 1>(<cf_get_lang dictionary_id ='57359.İrsaliye Noları'> <cfoutput query="INVOICE_SHIP_RELATION">#SHIP_NUMBER#<cfif INVOICE_SHIP_RELATION.recordcount neq currentrow>,</cfif></cfoutput> <cf_get_lang dictionary_id ='57361.Olan İrsaliyelerin Cari Hesapları Faturadan Farklıdır'>)</cfif>
    <form name="form_fark" id="form_fark" method="post" action="<cfoutput>#request.self#?fuseaction=invoice.emptypopup_add_contract_comparison</cfoutput>">            
        <cf_grid_list>
            <thead>
                    <tr>
                    <th colspan="22">
                    <cfoutput>
                        <input type="hidden" name="active_period" id="active_period" value="#session.ep.period_id#">
                        <input type="hidden" name="invoice_id" id="invoice_id" value="#url.iid#">
                        <input type="hidden" name="company_id" id="company_id" value="#get_invoice_info.company_id#">
                        <input type="hidden" name="consumer_id" id="consumer_id" value="#get_invoice_info.consumer_id#">
                        <input type="hidden" name="department_id" id="department_id" value="#get_invoice_info.department_id#">
                        <input type="hidden" name="location_id" id="location_id" value="#get_invoice_info.department_location#">
                        <input type="hidden" name="invoice_number" id="invoice_number" value="#get_invoice_info.invoice_number#">
                        <input type="hidden" name="invoice_date" id="invoice_date" value="#dateformat(get_invoice_info.invoice_date,dateformat_style)#">
                        <input type="hidden" name="max_kayit" id="max_kayit" value="#get_invoice_info.Recordcount#">
                    
                        <b><cf_get_lang dictionary_id='57519.Cari Hesap'></b>:
                        <cfif len(get_invoice_info.company_id)>
                            #get_par_info(get_invoice_info.company_id,1,1,0)#
                        <cfelseif len(get_invoice_info.consumer_id)>
                            #get_cons_info(get_invoice_info.consumer_id,1,0)#
                        </cfif>
                        <cfif len(get_invoice_info.partner_id)>
                            - #get_par_info(get_invoice_info.partner_id,0,-1,0)#
                        </cfif>
                        &nbsp;&nbsp;&nbsp;
                        <b><cf_get_lang dictionary_id='58133.Fatura No'></b>: #get_invoice_info.invoice_number#
                        &nbsp;&nbsp;&nbsp;<b><cf_get_lang dictionary_id='58759.Fatura Tarihi'></b>
                        : #dateformat(get_invoice_info.invoice_date,dateformat_style)#
                    </cfoutput>
                    </th>
                    <th>
                        <input type="checkbox" name="chk_diff_" id="chk_diff_" onclick="all_check('chk_diff_')"  value="">
                    </th>
                    <th>
                        <input type="checkbox" name="chk_rate_diff_" id="chk_rate_diff_" onclick="all_check('chk_rate_diff_')" value="">
                    </th>
                    <th><input type="checkbox" name="chk_manuel_diff_" id="chk_manuel_diff_"  onclick="all_check('chk_manuel_diff_')" value=""></td>
                    <th nowrap="nowrap" width="20"><input type="radio" title="<cf_get_lang dictionary_id ='58488.Alınan'>" name="invoice_type_" id="invoice_type_" value="1" onclick="all_check('invoice_type_1')" ><br/>
                    </th>
                    <th nowrap="nowrap" width="20">
                        <input type="radio" title="<cf_get_lang dictionary_id ='58490.Verilen'>" name="invoice_type_" id="invoice_type_"  onclick="all_check('invoice_type_2')" value="0"><br/>
                    </th>
                </tr>
                <tr>
                    <th colspan="5"><cf_get_lang dictionary_id ='57362.Ürün Bilgisi'></th>
                    <th colspan="8"><cf_get_lang dictionary_id ='57363.Kosullara Göre Olması Gereken'></th>
                    <th colspan="3"><cf_get_lang dictionary_id ='57364.Olan'></th>
                    <th colspan="6"><cf_get_lang dictionary_id ='57365.En Yüksek Fark'></th>
                    <th colspan="3"><cf_get_lang dictionary_id ='57692.İşlem'></th>
                    <th colspan="2"><cf_get_lang dictionary_id ='57332.Fark Tipi'></th>
                </tr>
                <tr>
                    <th><cf_get_lang dictionary_id ='57657.Ürün'>/<cf_get_lang dictionary_id ='57629.Açıklama'></th>
                    <th><cf_get_lang dictionary_id ='57635.Miktar'></th>
                    <th><cf_get_lang dictionary_id ='57636.Birim'></th>
                    <th><cf_get_lang dictionary_id ='57639.KDV'></th>
                    <th><cf_get_lang dictionary_id ='57236.Standart'> <cfif attributes.type eq 0><cf_get_lang dictionary_id='58176.Alış'><cfelse><cf_get_lang dictionary_id ='57448.Satış'></cfif><cf_get_lang dictionary_id ='58084.Fiyat'> </th>
                    <th colspan="2"><cf_get_lang dictionary_id ='57367.Alış Satış Koşulu'></th>
                    <th colspan="2"><cf_get_lang dictionary_id ='57368.Aksiyon'></th>
                    <th colspan="2"><cf_get_lang dictionary_id ='57611.Sipariş'></th>
                    <th><cf_get_lang dictionary_id ='57369.Promosyon'></th>
                    <th><cf_get_lang dictionary_id ='33086.Özel Fiyat'></th>
                    <th><cf_get_lang dictionary_id ='57639.KDV'></th>
                    <th colspan="2"><cf_get_lang dictionary_id ='57441.Fatura'></th>
                    <th><cf_get_lang dictionary_id ='57370.Koşul Tipi'></th>
                    <th><cf_get_lang dictionary_id ='57239.Fiyat Farkı'></th>
                    <th><cf_get_lang dictionary_id ='57371.İskonto Farkı'></th>
                    <th colspan="2"><cf_get_lang dictionary_id ='57202.Fark Tutarı'></th>
                    <th><cf_get_lang dictionary_id ='57884.Kur Farkı'></th>
                    <th><cf_get_lang dictionary_id ='57239.Fiyat Farkı'></th>
                    <th><cf_get_lang dictionary_id ='57884.Kur Farkı'></th>
                    <th><cf_get_lang dictionary_id ='57336.Manuel Fark'></th>
                    <th><cf_get_lang dictionary_id ='58488.Alınan'></th>
                    <th><cf_get_lang dictionary_id ='58490.Verilen'></th>
                </tr>
            </thead>
            <tbody>
                <cfscript>
                    siparis_toplam=0;
                    fatura_toplam=0;
                    aks_toplam=0;
                    ksl_toplam=0;
                    fiyat_toplam=0;
                    fark_siparis = 0;
                    fark_toplam_siparis = 0;
                    fark = 0;
                    fark_kaydet = 0;
                    total_diff=0;
                </cfscript>
                <cfoutput query="GET_INVOICE_INFO">
                    <cfscript>
                        satir_fiyat_farki = 0;//toplam_satir_fiyat_farki toplam satırdaki fiyat farkı
                        satir_iskonto_farki = 0;//toplam_satir_iskonto_farki toplam satır faturalanması gereken tutar
                        satir_iskonto_tutar_farki = 0;//toplam_satir_iskonto_tutari_farki toplam satırdaki iskonto farkı
                        satir_siparis_tutar_farki = 0;//toplam_satir_siparis_tutari_farki toplam satırdaki siparis farkı
                    </cfscript>
                    <cfif len(get_invoice_info.ship_id) and get_invoice_info.ship_id>
                        <cfquery name="GET_INVOICE_SHIP_DATE" dbtype="query">
                            SELECT SHIP_DATE FROM GET_INVOICE_SHIP_DATE_ALL WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice_info.ship_id#">
                        </cfquery>
                    </cfif>
                    <cfquery name="GET_PURCHASE_PROD_DISCOUNT_DETAIL"  dbtype="query" maxrows="1"><!--- kosul faturadaki sirket icin --->
                        SELECT 
                            * 
                        FROM 
                            get_cat_pur
                        WHERE
                            PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
                        <cfif len(get_invoice_info.ship_id) and get_invoice_info.ship_id and len(GET_INVOICE_SHIP_DATE.SHIP_DATE)>
                            AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(GET_INVOICE_SHIP_DATE.SHIP_DATE)#">
                            AND (FINISH_DATE IS NULL OR FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(GET_INVOICE_SHIP_DATE.SHIP_DATE)#)">)
                        <cfelse>
                            AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(get_invoice_info.INVOICE_DATE)#">
                            AND (FINISH_DATE IS NULL OR FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(get_invoice_info.INVOICE_DATE)#">)
                        </cfif>
                        <cfif len(get_invoice_info.company_id)>
                            AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice_info.company_id#">
                        <cfelse>
                            AND 1 = 0
                        </cfif>
                        ORDER BY 
                            START_DATE DESC
                    </cfquery>
                    <cfif not GET_PURCHASE_PROD_DISCOUNT_DETAIL.RECORDCOUNT>
                        <cfquery name="GET_PURCHASE_PROD_DISCOUNT_DETAIL" dbtype="query" maxrows="1"><!--- kosul faturadaki sirket icin yoksa genel olarak cekiyor --->
                            SELECT 
                                * 
                            FROM 
                                get_cat_pur
                            WHERE
                                PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> AND 
                                COMPANY_ID IS NULL
                            <cfif len(get_invoice_info.ship_id) and get_invoice_info.ship_id and len(GET_INVOICE_SHIP_DATE.SHIP_DATE)>
                                AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(GET_INVOICE_SHIP_DATE.SHIP_DATE)#">
                                AND (FINISH_DATE IS NULL OR FINISH_DATE > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(GET_INVOICE_SHIP_DATE.SHIP_DATE)#)">)
                            <cfelse>
                                AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(get_invoice_info.INVOICE_DATE)#">
                                AND (FINISH_DATE IS NULL OR FINISH_DATE > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(get_invoice_info.INVOICE_DATE)#">)
                            </cfif>
                            ORDER BY 
                                START_DATE DESC
                        </cfquery>
                    </cfif>
                    <cfif len(branchid) and len(attributes.company_id)>
                        <cfquery name="get_c_general_discounts" dbtype="query" maxrows="5">
                            SELECT
                                DISCOUNT
                            FROM
                                get_c_general_discounts_all
                            WHERE
                                <cfif len(get_invoice_info.ship_id) and get_invoice_info.ship_id and len(GET_INVOICE_SHIP_DATE.SHIP_DATE)>
                                    START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(GET_INVOICE_SHIP_DATE.SHIP_DATE)#"> AND
                                    FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(GET_INVOICE_SHIP_DATE.SHIP_DATE)#)">
                                <cfelse>
                                    START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(get_invoice_info.INVOICE_DATE)#"> AND
                                    FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(get_invoice_info.INVOICE_DATE)#">
                                </cfif>
                            ORDER BY
                                GENERAL_DISCOUNT_ID
                        </cfquery>
                        <cfscript>
                            d6 = "";
                            d7 = "";
                            d8 = "";
                            d9 = "";
                            d10 = "";
                        </cfscript>
                        <cfif get_c_general_discounts.recordcount>
                            <cfloop query="get_c_general_discounts">
                                <cfset 'd#currentrow+5#' = get_c_general_discounts.DISCOUNT>
                            </cfloop>
                        </cfif>
                    <cfelse>
                        <cfscript>
                            d6 = "";
                            d7 = "";
                            d8 = "";
                            d9 = "";
                            d10 = "";
                        </cfscript>
                    </cfif>
                    <cfquery name="GET_PRICE_STANDART_PURCHASE" dbtype="query" maxrows="1"><!--- standart fiyatı --->
                        SELECT
                            PRICE,
                            MONEY,
                            UNIT_ID
                        FROM
                            GET_STD_PRICE
                        WHERE
                            PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice_info.product_id#"> AND
                            PURCHASESALES = <cfif attributes.type eq 0>0<cfelse>1</cfif>
                        <cfif len(get_invoice_info.SHIP_ID) and get_invoice_info.SHIP_ID and len(GET_INVOICE_SHIP_DATE.SHIP_DATE)>
                            AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(GET_INVOICE_SHIP_DATE.SHIP_DATE)#">
                        <cfelse>
                            AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(get_invoice_info.INVOICE_DATE)#">
                        </cfif>
                        ORDER BY
                            START_DATE DESC,
                            RECORD_DATE DESC
                    </cfquery>
                    <cfif not GET_PRICE_STANDART_PURCHASE.recordcount>
                        <script type="text/javascript">
                            alert("#PRODUCT_NAME#<cf_get_lang dictionary_id ='57372.adlı ürünün ilgili tarihten önce bir satınalma fiyatı olmadığı için karşılaştırma yapılamaz \nSatınalma fiyatını ekledikten sonra tekrar deneyiniz'>.");				
                            window.close();
                        </script>
                        <cfabort>
                    </cfif>
                    <cfquery name="GET_PROD_TAX" datasource="#DSN3#">
                        SELECT
                            TAX,
                            TAX_PURCHASE
                        FROM
                            PRODUCT
                        WHERE
                            PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
                    </cfquery>
                    <cfquery name="GET_MULTIPLIER_ST_PURC" datasource="#DSN3#">
                        SELECT
                            MULTIPLIER
                        FROM
                            PRODUCT_UNIT
                        WHERE
                            PRODUCT_UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PRICE_STANDART_PURCHASE.UNIT_ID#"> AND
                            PRODUCT_UNIT_STATUS = 1 AND 
                            PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
                    </cfquery>
                    <cfif not GET_MULTIPLIER_ST_PURC.recordcount>
                        <script type="text/javascript">
                            alert("#PRODUCT_NAME# <cf_get_lang dictionary_id ='57373.adlı ürünün satınalma fiyatında kullanılan birimi ile şu andaki birimleri aynı olmadığı için karşılaştırma yapılamaz Bu ürünle ilgili satırları faturadan silip tekrar ekledikten sonra, karşılaştırma yapmayı tekrar deneyiniz'>.");
                            window.close();
                        </script>
                        <cfabort>
                    </cfif>
        
                    <cfquery name="GET_MULTIPLIER_INV" datasource="#DSN3#">
                        SELECT
                            MULTIPLIER
                        FROM
                            PRODUCT_UNIT
                        WHERE
                            ADD_UNIT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#unit#"> AND
                            PRODUCT_UNIT_STATUS = 1 AND
                            PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
                    </cfquery>
                    <cfif not GET_MULTIPLIER_INV.recordcount>
                        <script type="text/javascript">
                            alert("#PRODUCT_NAME# <cf_get_lang dictionary_id ='57374.adlı ürünün faturaya kaydedilen birimi ile şu andaki birimleri aynı olmadığı için karşılaştırma yapılamaz Bu ürünle ilgili satırları faturadan silip tekrar ekledikten sonra, karşılaştırma yapmayı tekrar deneyiniz'>.");
                            window.close();
                        </script>
                        <cfabort>
                    </cfif>
                    <cfset carpan = GET_MULTIPLIER_ST_PURC.MULTIPLIER / GET_MULTIPLIER_INV.MULTIPLIER>
                    <cfquery name="GET_CATALOG_PROM_PROD" dbtype="query" maxrows="1"><!--- aksiyon --->
                        SELECT
                            *
                        FROM
                            get_cat_proms
                        WHERE
                            PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
                        <cfif len(get_invoice_info.SHIP_ID) and get_invoice_info.SHIP_ID and len(GET_INVOICE_SHIP_DATE.SHIP_DATE)>
                            AND KONDUSYON_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(GET_INVOICE_SHIP_DATE.SHIP_DATE)#">
                            AND KONDUSYON_FINISH_DATE > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(GET_INVOICE_SHIP_DATE.SHIP_DATE)#">
                        <cfelse>
                            AND KONDUSYON_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(get_invoice_info.INVOICE_DATE)#">
                            AND KONDUSYON_FINISH_DATE > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(get_invoice_info.INVOICE_DATE)#">
                        </cfif>
                        ORDER BY
                            RECORD_DATE DESC
                    </cfquery>
                    <cfif isdefined('order_list') and listlen(order_list)>
                        <cfquery name="GET_ORDER_ROW" datasource="#dsn3#" maxrows="1"><!--- Siparişten faturaya dönüştürülmüş --->
                            SELECT
                                ORR.PRICE,
                                (ORR.NETTOTAL/ORR.QUANTITY) NETTOTAL,
                                ORR.NETTOTAL NETTOTAL_ROW,
                                ORR.QUANTITY,
                                ORR.OTHER_MONEY,
                                (ORR.OTHER_MONEY_VALUE/ORR.QUANTITY) OTHER_MONEY_VALUE,
                                ORR.DISCOUNT_1,ORR.DISCOUNT_2,ORR.DISCOUNT_3,ORR.DISCOUNT_4,ORR.DISCOUNT_5,
                                ORR.DISCOUNT_6,ORR.DISCOUNT_7,ORR.DISCOUNT_8,ORR.DISCOUNT_9,ORR.DISCOUNT_10,
                                ORR.DISCOUNT_COST
                            FROM
                                ORDER_ROW ORR 
                            WHERE
                                WRK_ROW_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_row_relation_id#">
                                AND ORR.ORDER_ID IN (#order_list#)
                        </cfquery>
                        <cfif not GET_ORDER_ROW.Recordcount>
                            <cfquery name="GET_ORDER_ROW" datasource="#dsn2#" maxrows="1"><!--- İrsaliyeden faturaya dönüştürülmüş--->
                                SELECT
                                    ORR.PRICE,
                                    (ORR.NETTOTAL/ORR.AMOUNT) NETTOTAL,
                                    ORR.NETTOTAL NETTOTAL_ROW,
                                    ORR.AMOUNT,
                                    ORR.OTHER_MONEY,
                                    (ORR.OTHER_MONEY_VALUE/ORR.AMOUNT) OTHER_MONEY_VALUE,
                                    ORR.DISCOUNT DISCOUNT_1,ORR.DISCOUNT2 DISCOUNT_2,ORR.DISCOUNT3 DISCOUNT_3,ORR.DISCOUNT4 DISCOUNT_4,ORR.DISCOUNT5 DISCOUNT_5,
                                    ORR.DISCOUNT6 DISCOUNT_6,ORR.DISCOUNT7 DISCOUNT_7,ORR.DISCOUNT8 DISCOUNT_8,ORR.DISCOUNT9 DISCOUNT_9,ORR.DISCOUNT10 DISCOUNT_10,
                                    ORR.DISCOUNT_COST
                                FROM
                                    SHIP_ROW ORR 
                                    LEFT JOIN #DSN3_ALIAS#.ORDERS_SHIP OS ON ORR.SHIP_ID = OS.SHIP_ID
                                WHERE
                                    WRK_ROW_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_row_relation_id#">
                                    AND OS.ORDER_ID IN (#order_list#)
                            </cfquery>
                        </cfif>
                    </cfif>
                    <cfscript>
                        //indirimler üzerinden toplam satirlar
                        fatura_toplam_discount =  NET_TOTAL;
                        fatura_toplam_discount_other =  NETTOTAL_INVOICE_ROW;
                        if(fatura_toplam_discount_other gt 0 and isdefined('attributes.#OTHER_MONEY#') and len(evaluate('attributes.#OTHER_MONEY#')))
                            inv_rate=evaluate('attributes.#OTHER_MONEY#');//fatura_toplam_discount/fatura_toplam_discount_other;//fatura kuru
                        else
                            inv_rate=1;
                        
                        if (GET_CATALOG_PROM_PROD.RECORDCOUNT)//aksiyon varsa
                        {
                            if (GET_CATALOG_PROM_PROD.DISCOUNT1 eq "") aks_discount1 = 0; else aks_discount1 = GET_CATALOG_PROM_PROD.DISCOUNT1;
                            if (GET_CATALOG_PROM_PROD.DISCOUNT2 eq "") aks_discount2 = 0; else aks_discount2 = GET_CATALOG_PROM_PROD.DISCOUNT2;
                            if (GET_CATALOG_PROM_PROD.DISCOUNT3 eq "") aks_discount3 = 0; else aks_discount3 = GET_CATALOG_PROM_PROD.DISCOUNT3;
                            if (GET_CATALOG_PROM_PROD.DISCOUNT4 eq "") aks_discount4 = 0; else aks_discount4 = GET_CATALOG_PROM_PROD.DISCOUNT4;
                            if (GET_CATALOG_PROM_PROD.DISCOUNT5 eq "") aks_discount5 = 0; else aks_discount5 = GET_CATALOG_PROM_PROD.DISCOUNT5;
                            if (GET_CATALOG_PROM_PROD.DISCOUNT6 eq "") aks_discount6 = 0; else aks_discount6 = GET_CATALOG_PROM_PROD.DISCOUNT6;
                            if (GET_CATALOG_PROM_PROD.DISCOUNT7 eq "") aks_discount7 = 0; else aks_discount7 = GET_CATALOG_PROM_PROD.DISCOUNT7;
                            if (GET_CATALOG_PROM_PROD.DISCOUNT8 eq "") aks_discount8 = 0; else aks_discount8 = GET_CATALOG_PROM_PROD.DISCOUNT8;
                            if (GET_CATALOG_PROM_PROD.DISCOUNT9 eq "") aks_discount9 = 0; else aks_discount9 = GET_CATALOG_PROM_PROD.DISCOUNT9;
                            if (GET_CATALOG_PROM_PROD.DISCOUNT10 eq "") aks_discount10 = 0; else aks_discount10 = GET_CATALOG_PROM_PROD.DISCOUNT10;
                            if (GET_CATALOG_PROM_PROD.ACTION_PRICE_DISCOUNT eq "") aks_discount_prc = 0; else aks_discount_prc = GET_CATALOG_PROM_PROD.ACTION_PRICE_DISCOUNT*evaluate('attributes.#GET_CATALOG_PROM_PROD.MONEY#');
                            if (GET_CATALOG_PROM_PROD.PURCHASE_PRICE eq "") 
                                aks_purchase_price = 0; 
                            else 
                                aks_purchase_price = GET_CATALOG_PROM_PROD.PURCHASE_PRICE*evaluate('attributes.#GET_CATALOG_PROM_PROD.MONEY#');
                            if(session.ep.our_company_info.workcube_sector eq 'it')//perakende sektorunde tutar iskontosu alanı kart indirimi mantigi ile kullaniliyormus o yuzden dusmemeli
                                aks_toplam_discount = (aks_purchase_price-aks_discount_prc)*((100 - aks_discount1)/100)*((100 - aks_discount2)/100)*((100 - aks_discount3)/100)*((100 - aks_discount4)/100)*((100 - aks_discount5)/100)*((100 - aks_discount6)/100)*((100 - aks_discount7)/100)*((100 - aks_discount8)/100)*((100 - aks_discount9)/100)*((100 - aks_discount10)/100);
                            else
                                aks_toplam_discount = (aks_purchase_price)*((100 - aks_discount1)/100)*((100 - aks_discount2)/100)*((100 - aks_discount3)/100)*((100 - aks_discount4)/100)*((100 - aks_discount5)/100)*((100 - aks_discount6)/100)*((100 - aks_discount7)/100)*((100 - aks_discount8)/100)*((100 - aks_discount9)/100)*((100 - aks_discount10)/100);						
                        }
                        else
                        {
                            aks_purchase_price = 0;
                            aks_toplam_discount = '';
                        }
                        if (GET_PURCHASE_PROD_DISCOUNT_DETAIL.RECORDCOUNT)//kosul varsa
                        {
                            if (GET_PURCHASE_PROD_DISCOUNT_DETAIL.DISCOUNT1 eq "") ksl_discount1 = 0; else ksl_discount1 = GET_PURCHASE_PROD_DISCOUNT_DETAIL.DISCOUNT1;
                            if (GET_PURCHASE_PROD_DISCOUNT_DETAIL.DISCOUNT2 eq "") ksl_discount2 = 0; else ksl_discount2 = GET_PURCHASE_PROD_DISCOUNT_DETAIL.DISCOUNT2;
                            if (GET_PURCHASE_PROD_DISCOUNT_DETAIL.DISCOUNT3 eq "") ksl_discount3 = 0; else ksl_discount3 = GET_PURCHASE_PROD_DISCOUNT_DETAIL.DISCOUNT3;
                            if (GET_PURCHASE_PROD_DISCOUNT_DETAIL.DISCOUNT4 eq "") ksl_discount4 = 0; else ksl_discount4 = GET_PURCHASE_PROD_DISCOUNT_DETAIL.DISCOUNT4;
                            if (GET_PURCHASE_PROD_DISCOUNT_DETAIL.DISCOUNT5 eq "") ksl_discount5 = 0; else ksl_discount5 = GET_PURCHASE_PROD_DISCOUNT_DETAIL.DISCOUNT5;
                            if (GET_PURCHASE_PROD_DISCOUNT_DETAIL.DISCOUNT_CASH eq "") ksl_discount_prc = 0; else ksl_discount_prc = GET_PURCHASE_PROD_DISCOUNT_DETAIL.DISCOUNT_CASH;
                            if (ksl_discount_prc gt 0 and isdefined('attributes.#GET_PURCHASE_PROD_DISCOUNT_DETAIL.DISCOUNT_CASH_MONEY#')) ksl_discount_prc = ksl_discount_prc*evaluate('attributes.#GET_PURCHASE_PROD_DISCOUNT_DETAIL.DISCOUNT_CASH_MONEY#');
                            /*buradakiler anlasmadan gelen genel indirimler*/
                            if (d6 eq "") ksl_discount6 = 0; else ksl_discount6 = d6;
                            if (d7 eq "") ksl_discount7 = 0; else ksl_discount7 = d7;
                            if (d8 eq "") ksl_discount8 = 0; else ksl_discount8 = d8;
                            if (d9 eq "") ksl_discount9 = 0; else ksl_discount9 = d9;
                            if (d10 eq "") ksl_discount10 = 0; else ksl_discount10 = d10;
                            if(len(get_price_standart_purchase.price) and len(carpan) and carpan neq 0) 
                                ksl_purchase_price = (get_price_standart_purchase.price/carpan)*evaluate('attributes.#GET_PRICE_STANDART_PURCHASE.MONEY#');//attributes.rate2; 
                            else  
                                ksl_purchase_price = 0;
                            if(session.ep.our_company_info.workcube_sector eq 'it')
                                ksl_toplam_discount =  (ksl_purchase_price-ksl_discount_prc)*((100 - ksl_discount1)/100)*((100 - ksl_discount2)/100)*((100 - ksl_discount3)/100)*((100 - ksl_discount4)/100)*((100 - ksl_discount5)/100)*((100 - ksl_discount6)/100)*((100 - ksl_discount7)/100)*((100 - ksl_discount8)/100)*((100 - ksl_discount9)/100)*((100 - ksl_discount10)/100);
                            else
                                ksl_toplam_discount =  (ksl_purchase_price)*((100 - ksl_discount1)/100)*((100 - ksl_discount2)/100)*((100 - ksl_discount3)/100)*((100 - ksl_discount4)/100)*((100 - ksl_discount5)/100)*((100 - ksl_discount6)/100)*((100 - ksl_discount7)/100)*((100 - ksl_discount8)/100)*((100 - ksl_discount9)/100)*((100 - ksl_discount10)/100);						
                        }
                        else
                        {
                            ksl_purchase_price = 0;
                            ksl_toplam_discount = '';
                        }
                        
                        //standat fiyatlar üzerinden toplam satirlar
                        if(isdefined('GET_ORDER_ROW') and len(GET_ORDER_ROW.NETTOTAL))
                        {
                            siparis_purchase_price = GET_ORDER_ROW.PRICE;
                            siparis_toplam_discount = GET_ORDER_ROW.NETTOTAL;
                            siparis_toplam_discount_other =GET_ORDER_ROW.NETTOTAL_ROW;
                            if(GET_ORDER_ROW.OTHER_MONEY eq OTHER_MONEY and GET_ORDER_ROW.OTHER_MONEY_VALUE gt 0)
                                order_rate = GET_ORDER_ROW.NETTOTAL/GET_ORDER_ROW.OTHER_MONEY_VALUE;
                            else
                                order_rate = 0;
                        }
                        else
                        {
                            siparis_purchase_price =0;
                            siparis_toplam_discount ='';
                            siparis_toplam_discount_other =0;
                            order_rate = 0;
                        }
                        
                        fatura_toplam_satir =  PRICE;
                        aks_toplam_satir_amount =  aks_purchase_price;
                        ksl_toplam_satir_amount =  ksl_purchase_price;
                        if(len(amount))
                        {
                            fatura_toplam_discount_amount = fatura_toplam_discount*amount;
                            if(len(aks_toplam_discount))aks_toplam_discount_amount = aks_toplam_discount*amount; else aks_toplam_discount_amount =0;
                            if(len(ksl_toplam_discount)) ksl_toplam_discount_amount = ksl_toplam_discount*amount; else ksl_toplam_discount_amount=0;
                            fatura_toplam_satir =  fatura_toplam_satir*amount;
                            aks_toplam_satir_amount = aks_toplam_satir_amount*amount;
                            ksl_toplam_satir_amount = ksl_toplam_satir_amount*amount;
                            if(len(siparis_toplam_discount))siparis_toplam_satir_amount = siparis_toplam_discount*amount; else siparis_toplam_satir_amount=0;
                        }
                        //toplamlar
                        siparis_toplam = siparis_toplam + siparis_toplam_satir_amount;
                        fatura_toplam = fatura_toplam + fatura_toplam_discount_amount;
                        ksl_toplam = ksl_toplam + ksl_toplam_discount_amount;
                        aks_toplam = aks_toplam + aks_toplam_discount_amount;
                        
                        //en büyük fark
                        ksl_fark=0;
                        aks_fark = 0;
                        siparis_fark = 0;
                        fiyat_fark = 0;
                        if(len(ksl_toplam_discount))
                            ksl_fark = (fatura_toplam_discount - ksl_toplam_discount)*amount;
                        if(len(aks_toplam_discount))
                            aks_fark = (fatura_toplam_discount - aks_toplam_discount)*amount;
                        if(len(siparis_toplam_discount))
                            siparis_fark = (fatura_toplam_discount - siparis_toplam_discount)*amount;
                        
                        if(len(GET_PRICE_STANDART_PURCHASE.PRICE))//standat fiyatla fatura fiyat arasındaki fark
                            fiyat_fark= (fatura_toplam_discount - (GET_PRICE_STANDART_PURCHASE.PRICE*evaluate('attributes.#GET_PRICE_STANDART_PURCHASE.MONEY#')))*amount;//sistem para birimine cevirir ve çıkarır
                            
                            
                        diff_type = 0;	
                        if(len(ksl_toplam_discount) and (not len(aks_toplam_discount) or ksl_toplam_discount lte aks_toplam_discount) and (not len(siparis_toplam_discount) or ksl_toplam_discount lte siparis_toplam_discount))
                            diff_type = 1;
                        else if(len(aks_toplam_discount) and (not len(ksl_toplam_discount) or aks_toplam_discount lte ksl_toplam_discount) and (not len(siparis_toplam_discount) or aks_toplam_discount lte siparis_toplam_discount))
                            diff_type = 2;
                        else if(len(siparis_toplam_discount) and (not len(ksl_toplam_discount) or siparis_toplam_discount lte ksl_toplam_discount) and (not len(aks_toplam_discount) or siparis_toplam_discount lte aks_toplam_discount))
                            diff_type = 3;
                        else if(fiyat_fark neq 0)
                            diff_type = 4;		
                        
                        if((diff_type eq 4 and fiyat_fark lt 0) or (diff_type eq 2 and aks_fark lt 0) or (diff_type eq 1 and ksl_fark lt 0) or (diff_type eq 3 and siparis_fark lt 0)) diff_type_2 = 1; else diff_type_2 = 0;
                        
                        if(diff_type eq 2)
                            sd_fiyat_farki=(PRICE-aks_purchase_price)*amount;
                        else if(diff_type eq 4)
                            sd_fiyat_farki=(PRICE-siparis_purchase_price)*amount;
                        else
                            sd_fiyat_farki=(PRICE-GET_PRICE_STANDART_PURCHASE.PRICE*evaluate('attributes.#GET_PRICE_STANDART_PURCHASE.MONEY#'))*amount;
                    </cfscript>
                <tr onclick="gizle_goster(discount_#currentrow#);" style="cursor:pointer;">
                    <td nowrap style="text-align:center;">#PRODUCT_NAME#
                        <input type="hidden" name="product_id_#currentrow#" id="product_id_#currentrow#" value="#PRODUCT_ID#">
                        <input type="hidden" name="stock_id_#currentrow#" id="stock_id_#currentrow#" value="#STOCK_ID#">
                        <input type="hidden" name="invoice_row_amount_#currentrow#" id="invoice_row_amount_#currentrow#" value="#AMOUNT#">
                        <input type="hidden" name="invoice_row_id_#currentrow#" id="invoice_row_id_#currentrow#" value="#invoice_row_id#">
                        <input type="hidden" name="wrk_row_id_#currentrow#" id="wrk_row_id_#currentrow#" value="#wrk_row_id#">
                        <input type="hidden" name="invoice_row_tax_#currentrow#" id="invoice_row_tax_#currentrow#" value="#tax#">
                    </td>
                    <td nowrap style="text-align:center;">#AMOUNT#</td>
                    <td nowrap style="text-align:center;">#UNIT#</td>
                    <td nowrap style="text-align:center;">#GET_PROD_TAX.TAX#</td>
                    <td nowrap style="text-align:center;">#TLFormat(GET_PRICE_STANDART_PURCHASE.PRICE,round_num)# #GET_PRICE_STANDART_PURCHASE.MONEY#</td>
                    <td nowrap style="text-align:center;"><cfif len(ksl_toplam_discount)>#TLformat(ksl_toplam_discount,round_num)# #session.ep.money#</cfif></td>
                    <td nowrap style="text-align:center;"><cfif len(ksl_toplam_discount)><cfif OTHER_MONEY eq session.ep.money>#TLformat(ksl_toplam_discount,round_num)#<cfelse>#TLformat(ksl_toplam_discount/inv_rate,round_num)#</cfif> #OTHER_MONEY#</cfif></td>
                    <td nowrap style="text-align:center;"><cfif len(aks_toplam_discount)>#TLformat(aks_toplam_discount,round_num)# #session.ep.money#</cfif></td>
                    <td nowrap style="text-align:center;"><cfif len(aks_toplam_discount)><cfif OTHER_MONEY eq session.ep.money>#TLformat(aks_toplam_discount,round_num)#<cfelse>#TLformat(aks_toplam_discount/inv_rate,round_num)#</cfif> #OTHER_MONEY#</cfif></td>
                    <td nowrap style="text-align:center;"><cfif isdefined('GET_ORDER_ROW') and GET_ORDER_ROW.RECORDCOUNT>#TLFormat(siparis_toplam_discount,round_num)# #session.ep.money#</cfif></td>
                    <td nowrap style="text-align:center;"><cfif isdefined('GET_ORDER_ROW') and GET_ORDER_ROW.RECORDCOUNT>#TLFormat(siparis_toplam_discount_other,round_num)# #GET_ORDER_ROW.OTHER_MONEY#</cfif></td>
                    <td nowrap style="text-align:center;">#PROM_ID#</td>
                    <td nowrap style="text-align:center;"><cfif len(get_price_cat_exceptions.PRICE)>#TLFormat(get_price_cat_exceptions.PRICE)# #get_price_cat_exceptions.PRICE_MONEY#</cfif></td>
                    <td nowrap style="text-align:center;">#TAX#</td>
                    <td nowrap style="text-align:center;"><cfif diff_type_2 eq 1><font color="red"></cfif>#TLformat(fatura_toplam_discount,round_num)# #session.ep.money#<cfif diff_type_2 eq 1></font></cfif></td>
                    <td nowrap style="text-align:center;"><cfif diff_type_2 eq 1><font color="red"></cfif>#TLformat(fatura_toplam_discount_other,round_num)# #OTHER_MONEY#<cfif diff_type_2 eq 1></font></cfif></td>
                    <td nowrap style="text-align:center;"><cfif diff_type gt 0><cfif diff_type eq 1><cf_get_lang dictionary_id ='57238.Koşul'><cfelseif diff_type eq 2><cf_get_lang dictionary_id ='57368.Aksiyon'><cfelseif diff_type eq 3><cf_get_lang dictionary_id ='57611.Sipariş'><cfelseif diff_type eq 4><cf_get_lang dictionary_id='58084.Fiyat'></cfif></cfif></td>
                    <td nowrap style="text-align:center;"><cfif diff_type gt 0>#TLformat(sd_fiyat_farki,round_num)#</cfif></td>
                    <td nowrap style="text-align:center;">
                        <cfif diff_type eq 1>
                            #TLformat(ksl_fark-sd_fiyat_farki,round_num)#
                        <cfelseif diff_type eq 2>
                            #TLformat(aks_fark-sd_fiyat_farki,round_num)#
                        <cfelseif diff_type eq 3>
                            #TLformat(siparis_fark-sd_fiyat_farki,round_num)#
                        <cfelseif diff_type eq 4>
                            #TLformat(fiyat_fark-sd_fiyat_farki,round_num)#
                        </cfif>
                    </td>
                    <td nowrap style="text-align:center;">
                    <cfif diff_type gt 0>
                        <cfif diff_type eq 1>
                            #TLformat(ksl_fark,round_num)# <cfset total_diff=total_diff+ksl_fark>
                        <cfelseif diff_type eq 2>
                            #TLformat(aks_fark,round_num)# <cfset total_diff=total_diff+aks_fark>
                        <cfelseif diff_type eq 3>
                            #TLformat(siparis_fark,round_num)# <cfset total_diff=total_diff+siparis_fark>
                        <cfelseif diff_type eq 4>
                            #TLformat(fiyat_fark,round_num)# <cfset total_diff=total_diff+fiyat_fark>
                        </cfif> #session.ep.money#
                    </cfif>
                    </td>
                    <td nowrap style="text-align:center;">
                        <cfif diff_type gt 0>
                            <cfif diff_type eq 1>
                                #TLformat(ksl_fark/inv_rate,round_num)#
                            <cfelseif diff_type eq 2>
                                #TLformat(aks_fark/inv_rate,round_num)#
                            <cfelseif diff_type eq 3>
                                #TLformat(siparis_fark/inv_rate,round_num)#
                            <cfelseif diff_type eq 4>
                                #TLformat(fiyat_fark/inv_rate,round_num)#
                            </cfif>
                            #OTHER_MONEY#
                            <input type="hidden" name="fiyat_farki_other_#currentrow#" id="fiyat_farki_other_#currentrow#" value="<cfif diff_type eq 1>#ksl_fark/inv_rate#<cfelseif diff_type eq 2>#aks_fark/inv_rate#<cfelseif diff_type eq 3>#abs(siparis_fark/inv_rate)#<cfelseif diff_type eq 4>#fiyat_fark/inv_rate#</cfif>">
                            <input type="hidden" name="other_money_#currentrow#" id="other_money_#currentrow#" value="#OTHER_MONEY#">
                        </cfif>
                    </td>
                    <td nowrap style="text-align:center;">
                        <cfif isdefined('GET_ORDER_ROW') and order_rate gt 0>
                            #TLFormat(inv_rate-order_rate,round_num)# - #TLFormat(fatura_toplam_discount_other*AMOUNT*(inv_rate-order_rate),round_num)# #session.ep.money#
                            <input type="hidden" name="rate_diff_amount_#currentrow#" id="rate_diff_amount_#currentrow#" value="#fatura_toplam_discount_other*AMOUNT*(inv_rate-order_rate)#">
                            <input type="hidden" name="rate_diff_amount_other_#currentrow#" id="rate_diff_amount_other_#currentrow#" value="#(fatura_toplam_discount_other*AMOUNT*(inv_rate-order_rate))/inv_rate#">
                            <input type="hidden" name="rate_diff_other_money_#currentrow#" id="rate_diff_other_money_#currentrow#" value="#OTHER_MONEY#">
                        <cfelse>
                            #TLFormat(0,round_num)#
                        </cfif>
                    </td>
                    <cfquery name="get_invoice_all_sub" dbtype="query">
                        SELECT MAIN_INVOICE_ROW_ID,DIFF_TYPE FROM get_invoice_all WHERE MAIN_INVOICE_ROW_ID = #invoice_row_id#
                    </cfquery>
                    <td align="center">
                    <cfif diff_type eq 1><cfset f=wrk_round(ksl_fark,round_num)><cfelseif diff_type eq 2><cfset f=wrk_round(aks_fark,round_num)><cfelseif diff_type eq 3><cfset f=wrk_round(siparis_fark,round_num)><cfelseif diff_type eq 4><cfset f=wrk_round(fiyat_fark,round_num)></cfif>
                    <cfif diff_type gt 0 and f neq 0>
                        <input type="checkbox" name="chk_diff_#currentrow#" id="chk_diff_#currentrow#" onclick="goster(discount_#currentrow#);" value="#diff_type#" <cfif get_invoice_all_sub.main_invoice_row_id eq invoice_row_id>disabled <cfif get_invoice_all_sub.diff_type eq 4>checked</cfif></cfif>>
                        <input type="hidden" name="fiyat_farki_#currentrow#" id="fiyat_farki_#currentrow#" value="<cfif diff_type eq 1>#ksl_fark#<cfelseif diff_type eq 2>#aks_fark#<cfelseif diff_type eq 3>#abs(siparis_fark)#<cfelseif diff_type eq 4>#fiyat_fark#</cfif>">
                    <cfelse>
                        <script type="text/javascript">
                            document.getElementById('chk_diff_').style.display='none';
                        </script>	
                    </cfif>
                    </td>
                    <td align="center">
                    <cfif isdefined('GET_ORDER_ROW') and order_rate gt 0 and wrk_round(inv_rate-order_rate,round_num) neq 0.0000><!--- çok küçük farkları göz ardı edmek için wrk_round dan gecirdim --->
                        <input type="checkbox" name="chk_rate_diff_#currentrow#" id="chk_rate_diff_#currentrow#" onclick="goster(discount_#currentrow#)" value="5"  <cfif get_invoice_all_sub.main_invoice_row_id eq invoice_row_id>disabled <cfif get_invoice_all_sub.diff_type eq 5>checked</cfif></cfif>>
                        <input type="hidden" name="rate_diff_#currentrow#" id="rate_diff_#currentrow#" value="#inv_rate-order_rate#">
                    <cfelse>
                        <script type="text/javascript">
                            document.getElementById('chk_rate_diff_').style.display='none';
                        </script>	
                    </cfif>
                    </td>
                    <td align="center"><input type="checkbox" name="chk_manuel_diff_#currentrow#" id="chk_manuel_diff_#currentrow#" onclick="goster(discount_#currentrow#)" value="7"  <cfif get_invoice_all_sub.main_invoice_row_id eq invoice_row_id>disabled <cfif get_invoice_all_sub.diff_type eq 7>checked</cfif></cfif>></td>
                    <td><input type="radio" title="<cf_get_lang dictionary_id ='58488.Alınan'>" name="invoice_type_#currentrow#" id="invoice_type_#currentrow#" onclick="goster(discount_#currentrow#)" value="1" <cfif isdefined('attributes.type') and attributes.type eq 1 and diff_type_2 neq 1>checked</cfif> <cfif get_invoice_all_sub.main_invoice_row_id eq invoice_row_id>disabled</cfif>><br/>                       
                    </td>
                    <td>
                       <input type="radio" title=" <cf_get_lang dictionary_id ='58490.Verilen'>" name="invoice_type_#currentrow#" id="invoice_type_#currentrow#" onclick="goster(discount_#currentrow#)" value="0"  <cfif diff_type_2 eq 1 or (isdefined('attributes.type') and attributes.type eq 0)>checked</cfif> <cfif get_invoice_all_sub.main_invoice_row_id eq invoice_row_id>disabled</cfif>><br/>
                    </td>
                </tr>
                <tr id="discount_#currentrow#" style="display:none;" class="nohover">
                    <td colspan="27">
                        <table class="medium_list">
                            <thead>
                                <tr>
                                    <th></th>
                                    <th><cf_get_lang dictionary_id ='57641.İsk'> 1</th>
                                    <th><cf_get_lang dictionary_id ='57641.İsk'> 2</th>
                                    <th><cf_get_lang dictionary_id ='57641.İsk'> 3</th>
                                    <th><cf_get_lang dictionary_id ='57641.İsk'> 4</th>
                                    <th><cf_get_lang dictionary_id ='57641.İsk'> 5</th>
                                    <th><cf_get_lang dictionary_id ='57641.İsk'> 6</th>
                                    <th><cf_get_lang dictionary_id ='57641.İsk'> 7</th>
                                    <th><cf_get_lang dictionary_id ='57641.İsk'> 8</th>
                                    <th><cf_get_lang dictionary_id ='57641.İsk'> 9</th>
                                    <th><cf_get_lang dictionary_id ='57641.İsk'> 10</th>
                                    <th><cf_get_lang dictionary_id ='57377.Tutar İsk'> (Rebate)</th>
                                    <th><cf_get_lang dictionary_id ='37755.Back End Rebate'></th>
                                    <th><cf_get_lang dictionary_id ='57378.Back End Rebate Oran'></th>
                                    <th><cf_get_lang dictionary_id ='57379.Mal Fazlası'></th>
                                    <th><cf_get_lang dictionary_id ='57380.İade Gün'> - <cf_get_lang dictionary_id ='58456.Oran'></th>
                                    <th><cf_get_lang dictionary_id ='57381.Fiyat Koruma Gün'></th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td class="color-list"><cf_get_lang dictionary_id ='57441.Fatura'></td>
                                    <td style="text-align:center;">#DISCOUNT1#</td>
                                    <td style="text-align:center;">#DISCOUNT2#</td>
                                    <td style="text-align:center;">#DISCOUNT3#</td>
                                    <td style="text-align:center;">#DISCOUNT4#</td>
                                    <td style="text-align:center;">#DISCOUNT5#</td>
                                    <td style="text-align:center;">#DISCOUNT6#</td>
                                    <td style="text-align:center;">#DISCOUNT7#</td>
                                    <td style="text-align:center;">#DISCOUNT8#</td>
                                    <td style="text-align:center;">#DISCOUNT9#</td>
                                    <td style="text-align:center;">#DISCOUNT10#</td>
                                    <td style="text-align:center;">#TLFormat(DISCOUNT_COST)#</td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td><cf_get_lang dictionary_id ='57238.Koşul'></td>
                                    <td style="text-align:center;"><cfif len(ksl_toplam_discount) and isdefined('ksl_discount1')>#ksl_discount1#</cfif></td>
                                    <td style="text-align:center;"><cfif len(ksl_toplam_discount) and isdefined('ksl_discount2')>#ksl_discount2#</cfif></td>
                                    <td style="text-align:center;"><cfif len(ksl_toplam_discount) and isdefined('ksl_discount3')>#ksl_discount3#</cfif></td>
                                    <td style="text-align:center;"><cfif len(ksl_toplam_discount) and isdefined('ksl_discount4')>#ksl_discount4#</cfif></td>
                                    <td style="text-align:center;"><cfif len(ksl_toplam_discount) and isdefined('ksl_discount5')>#ksl_discount5#</cfif></td>
                                    <td style="text-align:center;"><cfif len(ksl_toplam_discount) and isdefined('ksl_discount6')>#ksl_discount6#</cfif></td>
                                    <td style="text-align:center;"><cfif len(ksl_toplam_discount) and isdefined('ksl_discount7')>#ksl_discount7#</cfif></td>
                                    <td style="text-align:center;"><cfif len(ksl_toplam_discount) and isdefined('ksl_discount8')>#ksl_discount8#</cfif></td>
                                    <td style="text-align:center;"><cfif len(ksl_toplam_discount) and isdefined('ksl_discount9')>#ksl_discount9#</cfif></td>
                                    <td style="text-align:center;"><cfif len(ksl_toplam_discount) and isdefined('ksl_discount10')>#ksl_discount10#</cfif></td>
                                    <td style="text-align:center;">#TLFormat(GET_PURCHASE_PROD_DISCOUNT_DETAIL.DISCOUNT_CASH,round_num)# #GET_PURCHASE_PROD_DISCOUNT_DETAIL.DISCOUNT_CASH_MONEY#</td>
                                    <td style="text-align:center;">#TLFormat(GET_PURCHASE_PROD_DISCOUNT_DETAIL.REBATE_CASH_1)#</td>
                                    <td style="text-align:center;">#TLFormat(GET_PURCHASE_PROD_DISCOUNT_DETAIL.REBATE_RATE)#</td>
                                    <td style="text-align:center;">#GET_PURCHASE_PROD_DISCOUNT_DETAIL.EXTRA_PRODUCT_1# - #GET_PURCHASE_PROD_DISCOUNT_DETAIL.EXTRA_PRODUCT_2#</td>
                                    <td style="text-align:center;">#GET_PURCHASE_PROD_DISCOUNT_DETAIL.RETURN_DAY#-#GET_PURCHASE_PROD_DISCOUNT_DETAIL.RETURN_RATE#</td>
                                    <td style="text-align:center;">#GET_PURCHASE_PROD_DISCOUNT_DETAIL.PRICE_PROTECTION_DAY#</td>
                                </tr>
                                <tr>
                                    <td class="color-list"><cf_get_lang dictionary_id ='57368.Aksiyon'></td>
                                    <td style="text-align:center;"><cfif len(aks_toplam_discount) and isdefined('aks_discount1')>#aks_discount1#</cfif></td>
                                    <td style="text-align:center;"><cfif len(aks_toplam_discount) and isdefined('aks_discount2')>#aks_discount2#</cfif></td>
                                    <td style="text-align:center;"><cfif len(aks_toplam_discount) and isdefined('aks_discount3')>#aks_discount3#</cfif></td>
                                    <td style="text-align:center;"><cfif len(aks_toplam_discount) and isdefined('aks_discount4')>#aks_discount4#</cfif></td>
                                    <td style="text-align:center;"><cfif len(aks_toplam_discount) and isdefined('aks_discount5')>#aks_discount5#</cfif></td>
                                    <td style="text-align:center;"><cfif len(aks_toplam_discount) and isdefined('aks_discount6')>#aks_discount6#</cfif></td>
                                    <td style="text-align:center;"><cfif len(aks_toplam_discount) and isdefined('aks_discount7')>#aks_discount7#</cfif></td>
                                    <td style="text-align:center;"><cfif len(aks_toplam_discount) and isdefined('aks_discount8')>#aks_discount8#</cfif></td>
                                    <td style="text-align:center;"><cfif len(aks_toplam_discount) and isdefined('aks_discount9')>#aks_discount9#</cfif></td>
                                    <td style="text-align:center;"><cfif len(aks_toplam_discount) and isdefined('aks_discount10')>#aks_discount10#</cfif></td>
                                    <td style="text-align:center;">#TLFormat(GET_CATALOG_PROM_PROD.ACTION_PRICE_DISCOUNT,round_num)#</td>
                                    <td style="text-align:center;">#TLFormat(GET_CATALOG_PROM_PROD.REBATE_CASH_1)#</td>
                                    <td style="text-align:center;">#TLFormat(GET_CATALOG_PROM_PROD.REBATE_RATE)#</td>
                                    <td style="text-align:center;">#GET_CATALOG_PROM_PROD.EXTRA_PRODUCT_1# - #GET_CATALOG_PROM_PROD.EXTRA_PRODUCT_2#</td>
                                    <td style="text-align:center;">#GET_CATALOG_PROM_PROD.RETURN_DAY#-#GET_CATALOG_PROM_PROD.RETURN_RATE#</td>
                                    <td style="text-align:center;">#GET_CATALOG_PROM_PROD.PRICE_PROTECTION_DAY#</td>
                                </tr>
                                <tr>
                                    <td class="color-list"><cf_get_lang dictionary_id ='57611.Sipariş'></td>
                                    <td style="text-align:center;"><cfif isdefined('GET_ORDER_ROW')>#GET_ORDER_ROW.DISCOUNT_1#</cfif></td>
                                    <td style="text-align:center;"><cfif isdefined('GET_ORDER_ROW')>#GET_ORDER_ROW.DISCOUNT_2#</cfif></td>
                                    <td style="text-align:center;"><cfif isdefined('GET_ORDER_ROW')>#GET_ORDER_ROW.DISCOUNT_3#</cfif></td>
                                    <td style="text-align:center;"><cfif isdefined('GET_ORDER_ROW')>#GET_ORDER_ROW.DISCOUNT_4#</cfif></td>
                                    <td style="text-align:center;"><cfif isdefined('GET_ORDER_ROW')>#GET_ORDER_ROW.DISCOUNT_5#</cfif></td>
                                    <td style="text-align:center;"><cfif isdefined('GET_ORDER_ROW')>#GET_ORDER_ROW.DISCOUNT_6#</cfif></td>
                                    <td style="text-align:center;"><cfif isdefined('GET_ORDER_ROW')>#GET_ORDER_ROW.DISCOUNT_7#</cfif></td>
                                    <td style="text-align:center;"><cfif isdefined('GET_ORDER_ROW')>#GET_ORDER_ROW.DISCOUNT_8#</cfif></td>
                                    <td style="text-align:center;"><cfif isdefined('GET_ORDER_ROW')>#GET_ORDER_ROW.DISCOUNT_9#</cfif></td>
                                    <td style="text-align:center;"><cfif isdefined('GET_ORDER_ROW')>#GET_ORDER_ROW.DISCOUNT_10#</cfif></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td class="color-list"><cf_get_lang dictionary_id ='33086.Özel Fiyat'></td>
                                    <td style="text-align:center;"><cfif isdefined('get_price_cat_exceptions') and get_price_cat_exceptions.recordcount gt 0><cfif len(get_price_cat_exceptions.DISCOUNT_RATE)><cfelse>0</cfif></cfif></td>
                                    <td style="text-align:center;"><cfif isdefined('get_price_cat_exceptions') and get_price_cat_exceptions.recordcount gt 0><cfif len(get_price_cat_exceptions.DISCOUNT_RATE_2)><cfelse>0</cfif></cfif></td>
                                    <td style="text-align:center;"><cfif isdefined('get_price_cat_exceptions') and get_price_cat_exceptions.recordcount gt 0><cfif len(get_price_cat_exceptions.DISCOUNT_RATE_3)><cfelse>0</cfif></cfif></td>
                                    <td style="text-align:center;"><cfif isdefined('get_price_cat_exceptions') and get_price_cat_exceptions.recordcount gt 0><cfif len(get_price_cat_exceptions.DISCOUNT_RATE_4)><cfelse>0</cfif></cfif></td>
                                    <td style="text-align:center;"><cfif isdefined('get_price_cat_exceptions') and get_price_cat_exceptions.recordcount gt 0><cfif len(get_price_cat_exceptions.DISCOUNT_RATE_5)><cfelse>0</cfif></cfif></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                            </tbody>
                        </table>
                        </td>
                </tr>
                </cfoutput>	
            </tbody>
            <tfoot>
                <tr>
                    <td colspan="5" class="txtbold"><cf_get_lang dictionary_id ='57492.Toplam'></td>
                    <td colspan="2" style="text-align:center;"><cfoutput>#TLFormat(ksl_toplam,round_num)# #session.ep.money#</cfoutput></td>
                    <td colspan="2" style="text-align:center;"><cfoutput>#TLFormat(aks_toplam,round_num)# #session.ep.money#</cfoutput></td>
                    <td colspan="2" style="text-align:center;"><cfif isdefined('GET_ORDER_ROW')><cfoutput>#TLFormat(siparis_toplam,round_num)# #session.ep.money#</cfoutput></cfif></td>
                    <td></td>
                    <td colspan="3" style="text-align:center;"><cfoutput>#TLFormat(fatura_toplam,round_num)# #session.ep.money#</cfoutput></td>
                    <td></td>
                    <td colspan="5" style="text-align:center;"><cfoutput>#TLFormat(total_diff,round_num)# #session.ep.money#</cfoutput></td>
                    <td></td>
                    <td colspan="5"></td>
                </tr>
                <cfscript>
                    if (IsNumeric(get_invoice_info.SA_DISCOUNT))
                        fatura_alti_tutar = get_invoice_info.SA_DISCOUNT;
                    else
                        fatura_alti_tutar = 0;
                        
                    if(diff_type gt 0)
                        fark_alt_ind = total_diff - fatura_alti_tutar;
                    else
                        fark_alt_ind = 0;
                </cfscript> 
                <tr>
                    <td colspan="12" class="txtbold"><cf_get_lang dictionary_id ='57678.Fatura Altı İndirim'></td>
                    <td colspan="3" style="text-align:center;"><cfoutput>#TLFormat(fatura_alti_tutar,round_num)#</cfoutput></td>
                    <td></td>
                    <td colspan="5" style="text-align:center;"><cfoutput>#TLFormat(fark_alt_ind,round_num)# #session.ep.money#</cfoutput></td>
                    <td colspan="6"></td>
                </tr>
            </tfoot>
        </cf_grid_list>            
        <cf_box_elements>
            <div class="col col-4">
                <div class="form-group">
                    <label class="col col-4 col-xs-12"><cf_get_lang_main no="1447.Süreç"></label>
                    <div class="col col-8 col-xs-12">
                        <cf_workcube_process 
                            is_upd='0' 
                            is_detail='0'
                            fusepath='invoice.popup_get_contract_comparison'
                            >
                    </div>
                </div>
                <div class="form-group" id="item-control_date">
                    <label class="col col-4 col-xs-12"><cfoutput>#getLang('main',330)#</cfoutput></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="text" name="control_date" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>" validate="<cfoutput>#validate_style#</cfoutput>"> 
                            <span class="input-group-addon"><cf_wrk_date_image date_field="control_date"></span>
                        </div>
                    </div> 
                </div>
            </div>
            <div class="col col-4">
                <div class="form-group" id="item-controlled_by">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57032.Kontrol Eden'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfoutput>#session.ep.USERID#</cfoutput>">
                            <input type="text" name="record_emp_name" id="record_emp_name" style="width:120px;" onfocus="AutoComplete_Create('record_emp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','record_emp_id','form','3','135')" value="<cfoutput>#session.ep.name# #session.ep.surname#</cfoutput>" autocomplete="off">
                            <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=form.record_emp_name&field_emp_id=form.record_emp_id<cfif fusebox.circuit is "store">&is_store_module=1</cfif>&select_list=1,9','list');return false"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-customer-note">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57467.Not'> :</label>
                    <div class="col col-8 col-xs-12">
                        <textarea name="customer_note" maxlength="50"></textarea>
                    </div>
                </div>
            </div>
            <div class="col col-4">
                <cfif isdefined("get_customer_value") and GET_CUSTOMER_VALUE.recordcount and len(GET_CUSTOMER_VALUE.CUSTOMER_VALUE)>
                    <div class="form-group" id="item-customer-value">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58552.Müşteri Değeri'> : </label>
                        <label class="col col-8 col-xs-12"><cfoutput>#GET_CUSTOMER_VALUE.CUSTOMER_VALUE#</cfoutput></label>
                    </div>
                </cfif>                        
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cfif GET_INVOICE_INFO.recordcount gt get_invoice_all.recordcount>
                <cf_workcube_buttons is_upd='0' is_cancel='0' add_function='control()'>
            </cfif>
            <cfif get_invoice_control.recordcount>
                <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=invoice.list_conract_comparison" onclick="window.close();" target="_blank" class="txtsubmenu"><cf_get_lang dictionary_id ='57382.Kontrol Edildi Kontrol Listesine Gitmek İçin Tıklayınız'></a>
                <cfif len(get_invoice_all.diff_invoice_id)>
                    <cfquery name="get_inv_cat" datasource="#dsn2#">
                        SELECT INVOICE_ID,INVOICE_CAT,INVOICE_NUMBER,PURCHASE_SALES FROM INVOICE WHERE INVOICE_ID = #get_invoice_all.diff_invoice_id#
                    </cfquery>
                    <cfoutput>
                        <br/><cf_get_lang dictionary_id='32847.İlişkili Fatura'> :
                        <cfif get_inv_cat.purchase_sales>
                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=invoice.form_add_bill&event=upd&iid=#get_inv_cat.invoice_id#','wide');" class="tableyazi">#get_inv_cat.invoice_number#</a>
                        <cfelseif not get_inv_cat.purchase_sales>
                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=invoice.form_add_bill_purchas&event=upd&iid=#get_inv_cat.invoice_id#','wide');" class="tableyazi">#get_inv_cat.invoice_number#</a>
                        </cfif>
                    </cfoutput>
                </cfif>
            </cfif>
        </cf_box_footer>
    </form>
</cf_box>
<script type="text/javascript">
    function control()
    {
        selected=0;
        for(var i=0;i<=<cfoutput>#get_invoice_info.RECORDCOUNT#</cfoutput>;i++)
        {
            if(((document.getElementById("chk_diff_"+i) != undefined && document.getElementById("chk_diff_"+i).checked==true) || (document.getElementById("rate_diff_"+i) != undefined && document.getElementById("rate_diff_"+i).checked==true) ) && (document.getElementById("chk_manuel_diff_"+i)!=undefined && document.getElementById("chk_manuel_diff_"+i).checked==true))
            {
                alert("<cf_get_lang dictionary_id ='57383.Aynı Satırda Hem Manuel Fark Hemde Kur veya Fiyat Farkından Dolayı Kontrol Kaydı Yapamazsınız'>!");
                return false;
            }
            if(document.getElementById("chk_diff_"+i)!=undefined && document.getElementById("chk_diff_"+i).checked==true)
                selected=1;
            if(document.getElementById("chk_rate_diff_"+i)!=undefined && document.getElementById("chk_rate_diff_"+i).checked==true)
                selected=1;
            if(document.getElementById("chk_manuel_diff_"+i)!=undefined && document.getElementById("chk_manuel_diff_"+i).checked==true)
                selected=1;
        }
        if(!selected)
        {
            alert("<cf_get_lang dictionary_id='57280.Seçim Yapınız'>!");
            return false;
        }
        if(!process_cat_control()) return false;
        return true;

    }
    function all_check(value)
    {
        for(i=1;i<=<cfoutput>#get_invoice_info.RECORDCOUNT#</cfoutput>;i++)
        {
            if(value=='chk_diff_' && document.getElementById("chk_diff_"+i)!=undefined && document.getElementById("chk_diff_"+i).disabled == false)
            {
                document.getElementById("chk_diff_"+i).checked = document.getElementById("chk_diff_").checked;
            }
            if(value=='chk_rate_diff_' && document.getElementById("chk_rate_diff_"+i)!=undefined && document.getElementById("chk_rate_diff_"+i).disabled == false)
            {
                document.getElementById("chk_rate_diff_"+i).checked =document.getElementById("chk_rate_diff_").checked;
            }
            if(value=='chk_manuel_diff_' && document.getElementById("chk_manuel_diff_"+i)!=undefined && document.getElementById("chk_manuel_diff_"+i).disabled == false)
            {
                document.getElementById("chk_manuel_diff_"+i).checked = document.getElementById("chk_manuel_diff_").checked;
            }
            if(value=='invoice_type_1' && document.getElementsByName("invoice_type_"+i)[0].disabled == false)
            {
                document.getElementsByName("invoice_type_"+i)[0].checked = document.getElementsByName("invoice_type_")[0].checked;
            }
            if(value=='invoice_type_2' && document.getElementsByName("invoice_type_"+i)[1].disabled == false)
            {
                document.getElementsByName("invoice_type_"+i)[1].checked =document.getElementsByName("invoice_type_")[1].checked;
            }
        }
        return true;
    }
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
