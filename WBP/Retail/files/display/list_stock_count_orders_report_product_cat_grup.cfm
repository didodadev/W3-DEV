<cfparam name="attributes.hierarchy1" default="">
<cfparam name="attributes.hierarchy2" default="">
<cfparam name="attributes.hierarchy3" default="">
<cfparam name="attributes.uretici" default="">
<cfparam name="attributes.grup_code" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.size_type" default="">
<cfparam name="attributes.report_type" default="1">
<cfparam name="attributes.regions" default="1">
<cfparam name="attributes.siralama" default="1">
<cfparam name="attributes.siralama_tipi" default="1">
<cfparam name="attributes.limit" default="0">
<cfparam name="attributes.search_order_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>

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

<cfquery name="get_stock_open_import" datasource="#DSN_DEV#">
	SELECT
        CAST(ORDER_ID AS NVARCHAR) + ' - ' + ORDER_DETAIL + ' - ' + DEPARTMENT.DEPARTMENT_HEAD + ' - ' + CONVERT(NVARCHAR(10),ORDER_DATE,103) AS ORDER_INFO,
        STOCK_COUNT_ORDERS.*,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		DEPARTMENT.DEPARTMENT_HEAD,
        ISNULL((SELECT TABLE_CODE FROM #DSN_DEV_ALIAS#.STOCK_MANAGE_TABLES  WHERE ORDER_ID = STOCK_COUNT_ORDERS.ORDER_ID),0) STOCK_TABLE
	FROM
		STOCK_COUNT_ORDERS,
		#DSN_ALIAS#.EMPLOYEES EMPLOYEES,
		#DSN_ALIAS#.DEPARTMENT DEPARTMENT
	WHERE
        STOCK_COUNT_ORDERS.COUNT_TYPE = 1 AND
        STOCK_COUNT_ORDERS.STATUS = 1 AND
        DEPARTMENT.DEPARTMENT_ID = STOCK_COUNT_ORDERS.DEPARTMENT_ID AND
		STOCK_COUNT_ORDERS.RECORD_EMP = EMPLOYEES.EMPLOYEE_ID 
	ORDER BY
		STOCK_COUNT_ORDERS.ORDER_DATE DESC
</cfquery>

<cf_report_list_search title="#getLang('','Grup Sıralı Ürün Bazlı Sayım Karşılaştırma Raporu',62748)#">
    <cf_report_list_search_area>
        <cfform action="#request.self#?fuseaction=retail.list_stock_count_orders_report_product_cat_grup" method="post" name="search_depo">
            <input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
            <div class="row">
                <div class="col col-12 col-xs-12">
                    <div class="row formContent">
                        <div class="row" type="row">
                            <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
                                <div class="col col-12 col-xs-12">
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57460.Filtre'></label>
                                        <div class="col col-12">
                                            <cfinput type="text" name="keyword" value="#attributes.keyword#">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='62399.Sayım Emri'></label>
                                        <div class="col col-12">
                                            <cf_multiselect_check 
                                            query_name="get_stock_open_import"  
                                            name="search_order_id"
                                            option_text="#getLang('','Sayım Emirleri',62399)#" 
                                            width="180"
                                            option_name="order_info" 
                                            option_value="order_id"
                                            filter="1"
                                            value="#attributes.search_order_id#">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58202.Üretici'></label>
                                        <div class="col col-12">
                                            <cf_multiselect_check 
                                            query_name="get_uretici"  
                                            name="uretici"
                                            option_text="#getLang('','Üretici',58202)#" 
                                            width="180"
                                            option_name="SUB_TYPE_NAME" 
                                            option_value="SUB_TYPE_ID"
                                            value="#attributes.uretici#">
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
                                <div class="col col-12 col-xs-12">
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='61641.Ana Grup'></label>
                                        <div class="col col-12">
                                            <cf_multiselect_check 
                                            query_name="GET_PRODUCT_CAT1"
                                            selected_text="" 
                                            name="hierarchy1"
                                            option_text="#getLang('','Ana Grup',61641)#" 
                                            width="100"
                                            height="250"
                                            option_name="PRODUCT_CAT_NEW" 
                                            option_value="hierarchy"
                                            value="#attributes.hierarchy1#">
                                            <br />
                                            <input type="checkbox" name="cat_in_out1" value="1" <cfif isdefined("attributes.cat_in_out1") or not isdefined("attributes.is_form_submitted")>checked</cfif>/>
                                            <cf_get_lang dictionary_id='61653.İçeren Kayıtlar'>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='61642.Alt Grup'> 1</label>
                                        <div class="col col-12">
                                            <cf_multiselect_check 
                                            query_name="GET_PRODUCT_CAT2"
                                            selected_text="" 
                                            name="hierarchy2"
                                            option_text="#getLang('','Alt Grup',61642)# 1" 
                                            width="100"
                                            height="250"
                                            option_name="PRODUCT_CAT_NEW" 
                                            option_value="hierarchy"
                                            value="#attributes.hierarchy2#">
                                            <br />
                                            <input type="checkbox" name="cat_in_out2" value="1" <cfif isdefined("attributes.cat_in_out2") or not isdefined("attributes.is_form_submitted")>checked</cfif>/>
                                            <cf_get_lang dictionary_id='61653.İçeren Kayıtlar'>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='61642.Alt Grup'> 2</label>
                                        <div class="col col-12">
                                            <cf_multiselect_check 
                                            query_name="GET_PRODUCT_CAT3"
                                            selected_text=""  
                                            name="hierarchy3"
                                            option_text="#getLang('','Alt Grup',61642)# 2" 
                                            width="100"
                                            height="250"
                                            option_name="PRODUCT_CAT_NEW" 
                                            option_value="hierarchy"
                                            value="#attributes.hierarchy3#">
                                            <br />
                                            <input type="checkbox" name="cat_in_out3" value="1" <cfif isdefined("attributes.cat_in_out3") or not isdefined("attributes.is_form_submitted")>checked</cfif>/>
                                            <cf_get_lang dictionary_id='61653.İçeren Kayıtlar'>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-3 col-sm-6 col-xs-12">
                                <div class="col col-12 col-xs-12">
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57662.Alan'></label>
                                        <div class="col col-12 col-xs-12">
                                            <div class="input-group">
                                                <cfinput type="text" style="width:70px;" id="limit" name="limit" value="#attributes.limit#" class="moneybox" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));">
                                                <span class="input-group-addon no-bg"></span>
                                                <select name="regions" id="regions" style="width:80px;">                  
                                                    <option value="1" <cfif attributes.regions eq 1>selected</cfif>><cf_get_lang dictionary_id='62400.Tutar Fark'></option>  
                                                    <option value="0" <cfif attributes.regions eq 0>selected</cfif>><cf_get_lang dictionary_id='62401.Miktar Fark'></option>                                 
                                                </select>  
                                                <span class="input-group-addon no-bg"></span>
                                                <select name="size_type" id="size_type">
                                                    <option value="">Seçiniz</option> 
                                                    <option value="5"<cfif attributes.size_type eq 5>selected</cfif>>+/- <cf_get_lang dictionary_id='62402.Değer İçi'></option>
                                                    <option value="4"<cfif attributes.size_type eq 4>selected</cfif>>+/- <cf_get_lang dictionary_id='62403.Değer Dışı'></option>                                   
                                                    <option value="3"<cfif attributes.size_type eq 3>selected</cfif>><cf_get_lang dictionary_id='39789.Eşittir'></option>
                                                    <option value="2"<cfif attributes.size_type eq 2>selected</cfif>><cf_get_lang dictionary_id='51823.Eşit Değil'></option>
                                                    <option value="1"<cfif attributes.size_type eq 1>selected</cfif>><cf_get_lang dictionary_id='39794.Büyüktür'></option>  
                                                    <option value="0"<cfif attributes.size_type eq 0>selected</cfif>><cf_get_lang dictionary_id='39793.Küçüktür'></option>                                 
                                            </select> 
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col col-12 col-xs-12">
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58924.Sıralama'></label>
                                        <div class="col col-12 col-xs-12" >
                                            <div class="input-group">
                                                <select name="siralama_tipi" id="siralama_tipi" style="width:70px;">                
                                                    <option value="1" <cfif attributes.siralama_tipi eq 1>selected</cfif>><cf_get_lang dictionary_id='29826.Artan'></option>  
                                                    <option value="0" <cfif attributes.siralama_tipi eq 0>selected</cfif>><cf_get_lang dictionary_id='29827.Azalan'></option>                                 
                                                </select> 
                                                <span class="input-group-addon no-bg"></span>
                                                <select name="siralama" id="siralama" style="width:95px;">                  
                                                    <option value="1" <cfif attributes.siralama eq 1>selected</cfif>><cf_get_lang dictionary_id='62404.Sayım Tutarı'></option>  
                                                    <option value="2" <cfif attributes.siralama eq 2>selected</cfif>><cf_get_lang dictionary_id='62405.Gerçek Tutar'></option>    
                                                    <option value="3" <cfif attributes.siralama eq 3>selected</cfif>><cf_get_lang dictionary_id='62400.Tutar Fark'></option>   
                                                    <option value="4" <cfif attributes.siralama eq 4>selected</cfif>><cf_get_lang dictionary_id='62406.Sayım Miktarı'></option>   
                                                    <option value="5" <cfif attributes.siralama eq 5>selected</cfif>><cf_get_lang dictionary_id='62407.Gerçek Miktar'></option>   
                                                    <option value="6" <cfif attributes.siralama eq 6>selected</cfif>><cf_get_lang dictionary_id='62401.Miktar Fark'></option>                                
                                                </select>   
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row ReportContentBorder">
                        <div class="ReportContentFooter">
                            <cf_wrk_search_button button_type="1" search_function="control_search_depo()">
                        </div>	  
                    </div>
                </div>
            </div>
        </cfform>
    </cf_report_list_search_area>
</cf_report_list_search>

<script>
function control_search_depo()
{
	if(document.getElementById('size_type').value != '' && document.getElementById('limit').value == '')
	{
		alert('<cf_get_lang dictionary_id='29943.Lütfen miktar giriniz'>!');
		document.getElementById('limit').focus();
		return false;
	}
	return true;
}
</script>
<cfif isdefined("attributes.is_form_submitted")>

<cfif not isdefined("attributes.search_order_id") or not len(attributes.search_order_id)>
	<script>
		alert('<cf_get_lang dictionary_id='62408.Sayım Emri Seçmelisiniz'>!');
		history.back();
	</script>
    <cfabort>
</cfif>

<cfif listlen(attributes.search_order_id)>
    <cfquery name="get_sayim_info" datasource="#dsn_dev#">
        SELECT YEAR(ORDER_DATE) AS SAYIM_YIL FROM STOCK_COUNT_ORDERS WHERE ORDER_ID IN (#attributes.search_order_id#)
    </cfquery>
    <cfset dsn_sayim = "#dsn#_#get_sayim_info.SAYIM_YIL#_#session.ep.company_id#">
<cfelse>
	<cfset dsn_sayim = "#dsn2#">
</cfif>

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
            HIERARCHY LIKE '%.%.%' AND
        </cfif>
        PRODUCT_CATID IS NOT NULL 
        
    </cfquery>
    <cfif get_alt_groups.recordcount>
        <cfset p_cat_list = valuelist(get_alt_groups.PRODUCT_CATID)>
    <cfelse>
        <cfset p_cat_list = "">
    </cfif>
    
    <cfquery name="get_counts" datasource="#dsn_sayim#">
    SELECT
    T3.STOCK_NAME,
    T3.STOCK_ID,
    T3.BARCOD,
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
        T2.HIERARCHY,
        T2.IS_UPDATE
    FROM
    	(
        (
        SELECT
            ISNULL((
            SELECT
                SUM(SR.STOCK_IN - SR.STOCK_OUT)
            FROM
                STOCKS_ROW SR
            WHERE
                SR.STORE = T1.DEPARTMENT_ID AND
                SR.STOCK_ID = T1.STOCK_ID AND
                (
                SR.PROCESS_DATE < T1.ORDER_DATE
                OR
                    (
                    SR.PROCESS_DATE >= T1.ORDER_DATE AND 
                    SR.PROCESS_DATE < DATEADD("dd",1,T1.ORDER_DATE) AND
                    SR.PROCESS_TYPE <> -1002
                    )
                )
            ),0)
            AS TOPLAM_STOCK,
            SUM(AMOUNT) AS TOTAL_COUNT_AMOUNT,
            T1.STOCK_NAME,
            T1.STOCK_ID,
            T1.BARCOD,
            T1.HIERARCHY,
            T1.IS_UPDATE,
            T1.LISTE_FIYATI
        FROM
            (            
            SELECT
                ISNULL((SELECT TOP 1 ETR.SUB_TYPE_ID FROM #DSN_DEV_ALIAS#.EXTRA_PRODUCT_TYPES_ROWS ETR WHERE S.PRODUCT_ID = ETR.PRODUCT_ID AND ETR.TYPE_ID = #uretici_type_id#),0) AS SUB_TYPE_ID,
                SCO.DEPARTMENT_ID,
                S.PROPERTY AS STOCK_NAME,
                SCOR.STOCK_ID,
                S.BARCOD,
                PC.HIERARCHY,
                SCOR.AMOUNT,
                SCOR.IS_UPDATE,
                SCO.ORDER_DATE,
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
            	<cfif listlen(attributes.search_order_id)>
                SCO.ORDER_ID IN (#attributes.search_order_id#) AND
                <cfelse>
                SCO.ORDER_ID = -1 AND
                </cfif>
                S.PRODUCT_ID = PS.PRODUCT_ID AND
                PS.PURCHASESALES = 0 AND
                PS.PRICESTANDART_STATUS = 1 AND
                SCO.STATUS = 1 AND
                SCOR.ORDER_ID = SCO.ORDER_ID AND
                SCOR.STOCK_ID = S.STOCK_ID AND
                S.PRODUCT_STATUS = 1 AND
                S.STOCK_STATUS = 1 AND
                S.PRODUCT_CATID = PC.PRODUCT_CATID
                <cfif len(p_cat_list)>
                    AND PC.PRODUCT_CATID IN (#p_cat_list#)
                </cfif>
                <cfif len(attributes.keyword)> AND (S.PROPERTY LIKE '%#attributes.keyword#%' OR S.BARCOD LIKE '%#attributes.keyword#%')</cfif>
            ) T1
        WHERE
            <cfif isdefined("attributes.uretici") and listlen(attributes.uretici)>
                SUB_TYPE_ID IN (#attributes.uretici#) AND
            </cfif>
            STOCK_ID IS NOT NULL
        GROUP BY
        	T1.DEPARTMENT_ID,
            T1.STOCK_NAME,
            T1.STOCK_ID,
            T1.BARCOD,
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

<cfquery name="get_s_dept" dbtype="query">
	SELECT DISTINCT DEPARTMENT_HEAD FROM get_stock_open_import WHERE ORDER_ID IN (#attributes.search_order_id#)
</cfquery>
<cfset dept_list = valuelist(get_s_dept.department_head)>

       	<cfset sayim_tutari = 0>
		<cfset gercek_tutar = 0>
        <cfset tutar_fark_ = 0>
        <cfset sayim_miktari = 0>
        <cfset gercek_miktar = 0>
        <cfset miktar_fark = 0>
<!-- sil -->       
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_grid_list>
    	<thead>
        	<tr>
            	<th><cf_get_lang dictionary_id='58577.Sıra'></th> 
                <th><cf_get_lang dictionary_id='35449.Departman'></th>                 
                <th><cf_get_lang dictionary_id='57633.Barkod'></th>   
                <th><cf_get_lang dictionary_id='51499.Grup Kodu'></th>              
                <th><cf_get_lang dictionary_id='44019.Ürün'></th>  
                <th><cf_get_lang dictionary_id='62409.Sayım Tekrarı'></th>
                <th style="text-align:right;"><cf_get_lang dictionary_id='62404.Sayım Tutarı'></th>
                <th style="text-align:right;"><cf_get_lang dictionary_id='62405.Gerçek Tutar'></th>
                <th style="text-align:right;"><cf_get_lang dictionary_id='62400.Tutar Fark'></th>
                <th style="text-align:right;"><cf_get_lang dictionary_id='62406.Sayım Miktarı'></th>
                <th style="text-align:right;"><cf_get_lang dictionary_id='62407.Gerçek Miktar'></th>
                <th style="text-align:right;"><cf_get_lang dictionary_id='62401.Miktar Fark'></th>
            </tr>
        </thead>
        <tbody>
        	<cfsavecontent variable="icerik"> 
        	<cfoutput query="get_counts">
            	<tr>
                    <td>#currentrow#</td>                    
                    <td>#dept_list#</td>
                    <td>#barcod#</td>
                    <td>#HIERARCHY#</td>
                    <td>#stock_name#</td>
                    <td><cfif IS_UPDATE eq 1><cf_get_lang dictionary_id='33964.Yapıldı'></cfif></td>                   
                    <td style="text-align:right;">#tlformat(TOPLAM_COUNT_TUTAR,2)#</td>
                    <td style="text-align:right;">#tlformat(TOPLAM_STOCK_TUTAR,2)#</td>
                    <td style="text-align:right;">#tlformat(TUTAR_FARK,2)#</td>
                    <td style="text-align:right;">#tlformat(TOTAL_COUNT_AMOUNT,2)#</td>
                    <td style="text-align:right;">#tlformat(TOPLAM_STOCK,2)#</td>
                    <td style="text-align:right;">#tlformat(MIKTAR_FARK,2)#</td>
                </tr>
                <cfset sayim_tutari = sayim_tutari + #TOPLAM_COUNT_TUTAR#>
                <cfset gercek_tutar = gercek_tutar + #TOPLAM_STOCK_TUTAR#>
                <cfset tutar_fark_ = tutar_fark_ + (TOPLAM_STOCK_TUTAR - TOPLAM_COUNT_TUTAR)>
                <cfset sayim_miktari = sayim_miktari + #TOTAL_COUNT_AMOUNT#>
                <cfset gercek_miktar = gercek_miktar + #TOPLAM_STOCK#>
                <cfset miktar_fark = miktar_fark + #TOTAL_COUNT_AMOUNT# - #TOPLAM_STOCK#>
            </cfoutput>
            </cfsavecontent>
             <cfoutput>#icerik#</cfoutput>
        </tbody>
        <tfoot>
            <cfoutput>
            	<cfset cols = 6>
                <tr>
                    <td style="text-align:right;" colspan="#cols#"><cf_get_lang dictionary_id='40302.Toplamlar'></td>
                    <td style="text-align:right;">#tlformat(sayim_tutari,2)#</td>
                    <td style="text-align:right;">#tlformat(gercek_tutar,2)#</td>
                    <td style="text-align:right;">#tlformat(tutar_fark_,2)#</td>
                    <td style="text-align:right;">#tlformat(sayim_miktari,2)#</td>
                    <td style="text-align:right;">#tlformat(gercek_miktar,2)#</td>
                    <td style="text-align:right;">#tlformat(miktar_fark,2)#</td>
                </tr>
             </cfoutput>
        </tfoot>
    </cf_grid_list>
</div>
<!-- sil --> 
</cfif>