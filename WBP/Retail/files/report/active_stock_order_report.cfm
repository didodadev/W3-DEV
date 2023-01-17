<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.hierarchy1" default="">
<cfparam name="attributes.hierarchy2" default="">
<cfparam name="attributes.hierarchy3" default="">
<cfparam name="attributes.search_department_id" default="#merkez_depo_id#">
<cfparam name="attributes.uretici" default="">
<cfquery name="get_my_branches" datasource="#dsn#">
	SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#
</cfquery>
<cfif get_my_branches.recordcount>
	<cfset my_branch_list = valuelist(get_my_branches.BRANCH_ID)>
<cfelse>
	<cfset my_branch_list = '0'>
</cfif>
<cfquery name="get_departments_search" datasource="#dsn#">
	SELECT 
    	DEPARTMENT_ID,DEPARTMENT_HEAD 
    FROM 
    	DEPARTMENT D
    WHERE
    	D.DEPARTMENT_ID NOT IN (#iade_depo_id#) AND
    	D.IS_STORE IN (1,3) AND
        ISNULL(D.IS_PRODUCTION,0) = 0 AND
        D.BRANCH_ID IN (#my_branch_list#)
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
	SELECT SUB_TYPE_ID,SUB_TYPE_NAME FROM EXTRA_PRODUCT_TYPES_SUBS WHERE TYPE_ID = #uretici_type_id#
</cfquery>

<cfsavecontent variable="title"><cf_get_lang dictionary_id='61878.Güncel Stok Sipariş Raporu'></cfsavecontent>
<cf_report_list_search title="#title#">
    <cf_report_list_search_area>
        <cfform action="#request.self#?fuseaction=retail.active_stock_order_report" method="post" name="search_depo">
            <input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
            <div class="row">
                <div class="col col-12 col-xs-12">
                    <div class="row formContent">
                        <div class="row" type="row">	
                            <div class="col col-3 col-md-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57460.Filtre'></label>
                                    <div class="col col-12 col-xs-12">
                                        <cfinput type="text" name="keyword" value="#attributes.keyword#">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58202.Üretici'></label>
                                    <div class="col col-12 col-xs-12">
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
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='35449.Departman'></label>
                                    <div class="col col-12 col-xs-12">
                                        <cf_multiselect_check 
                                        query_name="get_departments_search"  
                                        name="search_department_id"
                                        option_text="#getLang('','Departman',35449)#" 
                                        width="180"
                                        option_name="department_head" 
                                        option_value="department_id"
                                        value="#attributes.search_department_id#">
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='61641.Ana Grup'></label>
                                    <div class="col col-12 col-xs-12">
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
                                    <div class="col col-12 col-xs-12">
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
                                    <div class="col col-12 col-xs-12">
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
                            <div class="col col-3 col-md-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"></label>
                                    <div class="col col-12 col-xs-12">
                                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=retail.popup_select_rival_products&type=10&op_f_name=add_row</cfoutput>','list');"><i class="icn-md icon-plus-square"></i></a>
                                    </div>
                                </div>
                                <div id="product_div">
                                    <cfif isdefined("attributes.search_stock_id") and len(attributes.search_stock_id)>
                                        <cfquery name="get_stocks" datasource="#dsn1#">
                                            SELECT STOCK_ID,PROPERTY FROM STOCKS WHERE STOCK_ID IN (#attributes.search_stock_id#)
                                        </cfquery>
                                        <cfoutput query="get_stocks">
                                            <div id="selected_product_#STOCK_ID#"><a href="javascript://" onclick="del_row_p('#STOCK_ID#')"><img src="/images/delete_list.gif"></a><input type="hidden" name="search_stock_id" value="#stock_id#">#property#</div>
                                        </cfoutput>
                                    </cfif>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row ReportContentBorder">
                        <div class="ReportContentFooter">
                            <cf_wrk_search_button  button_type="1" search_function="control_search_depo()">
                        </div>
                    </div>
                </div>
            </div>
        </cfform>
    </cf_report_list_search_area>
</cf_report_list_search>


<cfif isdefined("attributes.is_form_submitted")>

<cfquery name="get_periods_all" datasource="#dsn#">
	SELECT * FROM SETUP_PERIOD
</cfquery>

<cfquery name="get_order_date" datasource="#dsn_dev#">
	SELECT ORDER_DAY FROM SEARCH_TABLES_DEFINES
</cfquery>
<cfset order_control_day = -1 * get_order_date.ORDER_DAY>

	<cfif listlen(attributes.search_department_id)>
        <cfquery name="get_list_departments" dbtype="query">
            SELECT * FROM get_departments_search WHERE DEPARTMENT_ID IN (#attributes.search_department_id#) ORDER BY DEPARTMENT_HEAD
        </cfquery>
    <cfelse>
    	<cfquery name="get_list_departments" dbtype="query">
            SELECT * FROM get_departments_search WHERE DEPARTMENT_ID IN (#merkez_depo_id#) ORDER BY DEPARTMENT_HEAD
        </cfquery>
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
        </cfif>
        PRODUCT_CATID IS NOT NULL AND
        HIERARCHY LIKE '%.%.%'
    </cfquery>
    <cfif get_alt_groups.recordcount>
        <cfset p_cat_list = valuelist(get_alt_groups.PRODUCT_CATID)>
    <cfelse>
        <cfset p_cat_list = "">
    </cfif>
    
    <cfquery name="get_urunler" datasource="#DSN3#" result="donus">
        SELECT
            *
        FROM
            (
            SELECT
                ISNULL((SELECT TOP 1 ETR.SUB_TYPE_ID FROM #DSN_DEV_ALIAS#.EXTRA_PRODUCT_TYPES_ROWS ETR WHERE S.PRODUCT_ID = ETR.PRODUCT_ID AND ETR.TYPE_ID = #uretici_type_id#),0) AS SUB_TYPE_ID,
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
                ),PRICE_STANDART.PRICE) AS LISTE_FIYATI_ALIS,
                ISNULL(( 
                    SELECT TOP 1 
                        PT1.NEW_PRICE_KDV
                    FROM
                        #DSN_DEV#.PRICE_TABLE PT1
                    WHERE
                        PT1.IS_ACTIVE_S = 1 AND
                        PT1.P_STARTDATE <= #bugun_# AND 
                        DATEADD("d",-1,PT1.P_FINISHDATE) >= #bugun_# AND
                        (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID))
                    ORDER BY
                        PT1.STARTDATE DESC,
                        PT1.ROW_ID DESC
                ),PS2.PRICE) AS LISTE_FIYATI_SATIS,
                <cfoutput query="get_list_departments">
                    ISNULL((SELECT SUM(PRODUCT_STOCK) FROM #DSN#_#year(now())#_#session.ep.company_id#.GET_STOCK_PRODUCT WHERE S.STOCK_ID = GET_STOCK_PRODUCT.STOCK_ID AND GET_STOCK_PRODUCT.DEPARTMENT_ID = #department_id#),0) AS STOCK_#department_id#,
                </cfoutput>
                S.STOCK_CODE,
                S.PRODUCT_NAME,
                S.PROPERTY,
                S.STOCK_ID,
                S.TAX,
                PC.PRODUCT_CATID,
                EPTR.SUB_TYPE_NAME AS AMBALAJ,
                EPTR2.SUB_TYPE_NAME AS MARKA,
                EPTR3.SUB_TYPE_NAME AS URETICI
            FROM 
                PRODUCT_CAT PC,
                STOCKS S,
                #dsn1_alias#.PRODUCT P
                    LEFT JOIN #dsn_dev_alias#.EXTRA_PRODUCT_TYPES_ROWS EPTR ON (P.PRODUCT_ID = EPTR.PRODUCT_ID AND EPTR.TYPE_ID = #ambalaj_type_id#)
                    LEFT JOIN #dsn_dev_alias#.EXTRA_PRODUCT_TYPES_ROWS EPTR2 ON (P.PRODUCT_ID = EPTR2.PRODUCT_ID AND EPTR2.TYPE_ID = #marka_type_id#)
                    LEFT JOIN #dsn_dev_alias#.EXTRA_PRODUCT_TYPES_ROWS EPTR3 ON (P.PRODUCT_ID = EPTR3.PRODUCT_ID AND EPTR3.TYPE_ID = #uretici_type_id#)
                    LEFT JOIN PRODUCT_UNIT ON P.PRODUCT_ID = PRODUCT_UNIT.PRODUCT_ID
                    LEFT JOIN PRICE_STANDART ON PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID
                    LEFT JOIN PRICE_STANDART AS PS2 ON PRODUCT_UNIT.PRODUCT_ID = PS2.PRODUCT_ID
            WHERE	
                <cfif isdefined("attributes.search_stock_id") and len(attributes.search_stock_id)>
                    S.STOCK_ID IN (#attributes.search_stock_id#) AND
                </cfif>
                <cfif isdefined("session.pp.userid")>
                    P.COMPANY_ID = #session.pp.company_id# AND
                </cfif>
                <cfif isdefined("session.pp.project_id") and len(session.pp.project_id)>
                    P.PROJECT_ID IN (#session.pp.project_id#) AND
                </cfif>
                <cfif len(attributes.keyword)>
                    (
                    P.PRODUCT_NAME + ' ' + S.PROPERTY LIKE '%#attributes.keyword#%'
                        OR
                        (
                            P.PRODUCT_NAME IS NOT NULL
                            <cfloop from="1" to="#listlen(attributes.keyword,' ')#" index="ccc">
                                <cfif ccc eq 1>
                                    <cfset kelime_ = listgetat(attributes.keyword,ccc,' ')>
                                    AND
                                    (
                                    P.PRODUCT_NAME + ' ' + S.PROPERTY + ' ' + P.PRODUCT_CODE LIKE '%#kelime_#%' OR
                                    P.PRODUCT_CODE_2 = '#kelime_#' OR
                                    S.BARCOD = '#kelime_#' OR    
                                    S.STOCK_CODE = '#kelime_#' OR
                                    S.STOCK_CODE_2 = '#kelime_#'                                
                                    )
                               <cfelse>
                                    <cfset kelime_ = listgetat(attributes.keyword,ccc,' ')>
                                    AND
                                    (
                                    P.PRODUCT_NAME + ' ' + S.PROPERTY + ' ' + P.PRODUCT_CODE LIKE '%#kelime_#%' OR
                                    P.PRODUCT_CODE_2 = '#kelime_#' OR
                                    S.BARCOD = '#kelime_#' OR    
                                    S.STOCK_CODE = '#kelime_#' OR
                                    S.STOCK_CODE_2 = '#kelime_#'                                
                                    )
                               </cfif>
                            </cfloop>
                        )
                   )
                <cfelse>
                    P.PRODUCT_NAME LIKE '%#attributes.keyword#%'
                </cfif>
                AND
                PRODUCT_UNIT.IS_MAIN = 1 AND 
                PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
                PRICE_STANDART.PURCHASESALES = 0 AND
                PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID AND
                PS2.PRICESTANDART_STATUS = 1 AND
                PS2.PURCHASESALES = 1 AND
                PRODUCT_UNIT.PRODUCT_UNIT_ID = PS2.UNIT_ID AND
                S.PRODUCT_ID = P.PRODUCT_ID AND
                --S.PRODUCT_STATUS = 1 AND
                --S.STOCK_STATUS = 1 AND
                S.PRODUCT_CATID = PC.PRODUCT_CATID AND
                PC.PRODUCT_CATID IN (#p_cat_list#)
          ) T1
        WHERE
            STOCK_CODE IS NOT NULL
            <cfif isdefined("attributes.uretici") and listlen(attributes.uretici)>
                AND SUB_TYPE_ID IN (#attributes.uretici#)
            </cfif>
        ORDER BY
             STOCK_CODE ASC,
             PRODUCT_NAME ASC
        </cfquery>
    
    <cfif get_urunler.recordcount>
    	<cfquery name="get_siparisler" datasource="#dsn3#">
            SELECT
                SUM(CASH_HAREKET - DONUSEN) AS ORDER_TUTAR,
                SUM(CASH_HAREKET_MIKTAR - MIKTAR_DONUSEN) AS ORDER_MIKTAR,
                DELIVER_DEPT_ID,
                STOCK_ID
            FROM
            (
                SELECT
                    O.DELIVER_DEPT_ID,
                    ORR.STOCK_ID,
                    ROUND((ORR.NETTOTAL * (100 + ORR.TAX) / 100),2) AS CASH_HAREKET,
                    ORR.QUANTITY AS CASH_HAREKET_MIKTAR,
                    ISNULL((
                            SELECT
                                SUM(TOTAL)
                            FROM
                                (
                                <cfset count = 0>
                               <cfloop query="get_periods_all">
                               <cfset count = count + 1>
                               <cfset db_ = "#dsn#_#get_periods_all.PERIOD_YEAR#_#session.ep.company_id#">
                               <cfif count neq 1>
                                UNION ALL
                               </cfif>
                                SELECT 
                                    ROUND(SUM(SR.GROSSTOTAL),2) AS TOTAL
                                FROM
                                    #db_#.SHIP S,
                                    #db_#.SHIP_ROW SR,
                                    #dsn3_alias#.ORDERS_SHIP OSS
                                WHERE
                                    S.SHIP_ID = SR.SHIP_ID AND
                                    OSS.SHIP_ID = S.SHIP_ID AND
                                    OSS.ORDER_ID = O.ORDER_ID AND
                                    SR.STOCK_ID = ORR.STOCK_ID
                               </cfloop>
                               ) T1 
                            ),0)
                      AS DONUSEN,
                   ISNULL((
                            SELECT
                                SUM(TOTAL)
                            FROM
                                (
                                <cfset count = 0>
                               <cfloop query="get_periods_all">
                               <cfset count = count + 1>
                               <cfset db_ = "#dsn#_#get_periods_all.PERIOD_YEAR#_#session.ep.company_id#">
                               <cfif count neq 1>
                                UNION ALL
                               </cfif>
                                SELECT 
                                    ROUND(SUM(SR.AMOUNT),2) AS TOTAL
                                FROM
                                    #db_#.SHIP S,
                                    #db_#.SHIP_ROW SR,
                                    #dsn3_alias#.ORDERS_SHIP OSS
                                WHERE
                                    S.SHIP_ID = SR.SHIP_ID AND
                                    OSS.SHIP_ID = S.SHIP_ID AND
                                    OSS.ORDER_ID = O.ORDER_ID AND
                                    SR.STOCK_ID = ORR.STOCK_ID
                               </cfloop>
                               ) T1 
                            ),0)
                      AS MIKTAR_DONUSEN
                FROM
                    #dsn3_alias#.ORDERS O,
                    #dsn3_alias#.ORDER_ROW ORR
                WHERE
                    O.DELIVER_DEPT_ID IN (#valuelist(get_list_departments.department_id)#) AND
                    O.ORDER_STAGE = #valid_order_stage_# AND
                    O.ORDER_STATUS = 1 AND
                    O.PURCHASE_SALES = 0 AND	
                    O.ORDER_ID = ORR.ORDER_ID AND
                    O.ORDER_DATE >= #dateadd('d',order_control_day,bugun_)#
            ) T1
            WHERE
            	ROUND(CASH_HAREKET,2) >= ROUND(DONUSEN,2)
            GROUP BY
            	DELIVER_DEPT_ID,
                STOCK_ID
        </cfquery>
        <cfoutput query="get_siparisler">
        	<cfset 'siparis_#STOCK_ID#_#DELIVER_DEPT_ID#' = ORDER_MIKTAR>
            <cfset 'siparis_tutar_#STOCK_ID#_#DELIVER_DEPT_ID#' = ORDER_TUTAR>
        </cfoutput>
    </cfif>    
    
    <cfset last_ucuncu_ = "">
	<cfset last_ikinci_ = "">
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box>
            <cf_grid_list>
                <thead>
                    <tr>
                        <th colspan="9">&nbsp;</th>
                        <th colspan="<cfoutput>#get_list_departments.recordcount+1#</cfoutput>" style="text-align:center;"><cf_get_lang dictionary_id='62218.Güncel Stoklar'></th>
                        <th colspan="<cfoutput>#get_list_departments.recordcount+1#</cfoutput>" style="text-align:center;"><cf_get_lang dictionary_id='62227.Güncel Stok Alış KDVli Tutar'></th>
                        <th colspan="<cfoutput>#get_list_departments.recordcount+2#</cfoutput>" style="text-align:center;"><cf_get_lang dictionary_id='62219.Sipariş Bakiye'></th>
                    </tr>
                    <tr>
                        <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                        <th><cf_get_lang dictionary_id='61642.Alt Grup'> 1</th>
                        <th><cf_get_lang dictionary_id='61642.Alt Grup'> 2</th>
                        <th><cf_get_lang dictionary_id='58847.Marka'></th>
                        <th><cf_get_lang dictionary_id='33269.Ambalaj'></th>
                        <th><cf_get_lang dictionary_id='57452.Stok'> ID</th>
                        <th><cf_get_lang dictionary_id='57452.Stok'></th>
                        <th style="text-align:right;"><cf_get_lang dictionary_id='62225.Kdvli Alış'></th>
                        <th style="text-align:right;"><cf_get_lang dictionary_id='62226.Kdvli Satış'></th>
                        <cfoutput query="get_list_departments"><th>#department_head#</th></cfoutput>
                        <th><cf_get_lang dictionary_id='57492.Toplam'></th>
                        <cfoutput query="get_list_departments"><th>#department_head#</th></cfoutput>
                        <th><cf_get_lang dictionary_id='57492.Toplam'></th>
                        <cfoutput query="get_list_departments"><th>#department_head#</th></cfoutput>
                        <th><cf_get_lang dictionary_id='57492.Toplam'></th>
                        <th><cf_get_lang dictionary_id='29534.Toplam Tutar'></th>
                    </tr>
                </thead>
                <tbody>
                    <cfset t_stock_total = 0>
                    <cfset t_stock_tl_total = 0>
                    <cfset t_siparis_total = 0>
                    <cfset t_siparis_tutar_total = 0>
                    
                    <cfoutput query="get_list_departments">
                            <cfset 't_stock_total_#department_id#' = 0>
                            <cfset 't_stock_tl_total_#department_id#' = 0>
                            <cfset 't_siparis_total_#department_id#' = 0>
                    </cfoutput>
                    
                    <cfoutput query="get_urunler">
                        <cfset birinci_ = listfirst(stock_code,'.')>
                        <cfset ikinci_ = birinci_ & '.' & listgetat(stock_code,2,'.')>
                        <cfset ucuncu_ = ikinci_ & '.' & listgetat(stock_code,3,'.')>
                    <tr>
                        <td>#currentrow#</td>
                        <td>
                            <cfif not len(last_ikinci_) or last_ikinci_ is not ikinci_>
                                <cfset sira_ = listfind(hierarchy_list,ikinci_)>
                                <cfif sira_ neq 0>#listgetat(hierarchy_name_list,sira_,'╗')#</cfif>
                            </cfif>
                        </td>
                        <td>
                            <cfif not len(last_ucuncu_) or last_ucuncu_ is not ucuncu_>
                                <cfset sira_ = listfind(hierarchy_list,ucuncu_)>
                                <cfif sira_ neq 0>
                                    #listgetat(hierarchy_name_list,sira_,'╗')#
                                    <cfset last_group_id_ = listgetat(hierarchy_name_list,sira_,'╗')>
                                </cfif>
                            </cfif>
                        </td>
                        <td>#marka#</td>
                        <td>#ambalaj#</td>
                        <td>#stock_id#</td>
                        <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=retail.popup_product_stocks&stock_id=#stock_id#','page_display');" class="tableyazi">#PROPERTY#</a></td>
                        <td style="text-align:right;">#tlformat(LISTE_FIYATI_ALIS)#</td>
                        <td style="text-align:right;">#tlformat(LISTE_FIYATI_SATIS)#</td>
                        
                        <cfset row_stock_total = 0>
                        <cfloop query="get_list_departments">
                            <cfset depo_ = evaluate('get_urunler.STOCK_#department_id#')>
                            <cfset row_stock_total = row_stock_total + depo_>
                            <cfset 't_stock_total_#department_id#' = evaluate('t_stock_total_#department_id#') + depo_>
                                <td style="text-align:right;">#tlformat(depo_)#</td>
                        </cfloop>
                        <td style="text-align:right; ">#tlformat(row_stock_total)#</td>
                        
                        <cfset row_stock_tl_total = 0>
                        <cfloop query="get_list_departments">
                            <cfset depo_ = evaluate('get_urunler.STOCK_#department_id#') * get_urunler.LISTE_FIYATI_ALIS>
                            <cfset row_stock_tl_total = row_stock_tl_total + depo_>
                            <cfset 't_stock_tl_total_#department_id#' = evaluate('t_stock_tl_total_#department_id#') + depo_>
                                <td style="text-align:right;">#tlformat(depo_)#</td>
                        </cfloop>
                        <td style="text-align:right; ">#tlformat(row_stock_tl_total)#</td>
                        
                        <cfset row_siparis_total = 0>
                        <cfset row_siparis_tl_total = 0>
                        <cfloop query="get_list_departments">
                            <cfif isdefined('siparis_#get_urunler.stock_id#_#department_id#')>
                                <cfset depo_ = evaluate('siparis_#get_urunler.stock_id#_#department_id#')>
                            <cfelse>
                                <cfset depo_ = 0>
                            </cfif>
                            
                            <cfif isdefined('siparis_tutar_#get_urunler.stock_id#_#department_id#')>
                                <cfset depo_tutar_ = evaluate('siparis_tutar_#get_urunler.stock_id#_#department_id#')>
                            <cfelse>
                                <cfset depo_tutar_ = 0>
                            </cfif>
                            
                            <cfset row_siparis_total = row_siparis_total + depo_>
                            <cfset row_siparis_tl_total = row_siparis_tl_total + depo_tutar_>
                            <cfset 't_siparis_total_#department_id#' = evaluate('t_siparis_total_#department_id#') + depo_>
                                <td style="text-align:right;">#tlformat(depo_)#</td>
                        </cfloop>
                        <td style="text-align:right; ">#tlformat(row_siparis_total)#</td>
                        <td style="text-align:right; ">#tlformat(row_siparis_tl_total)#</td>

                        <cfset t_stock_total = t_stock_total + row_stock_total>
                        <cfset t_stock_tl_total = t_stock_tl_total + row_stock_tl_total>
                        <cfset t_siparis_total = t_siparis_total + row_siparis_total>
                        <cfset t_siparis_tutar_total = t_siparis_tutar_total + row_siparis_tl_total>
                    </tr>
                </cfoutput>
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="9" class="formbold"><cf_get_lang dictionary_id='40302.Toplamlar'></td>
                        <cfoutput query="get_list_departments">
                            <td style="text-align:right;">#tlformat(evaluate('t_stock_total_#department_id#'))#</td>
                        </cfoutput>
                        <cfoutput>
                            <td style="text-align:right; ">#tlformat(t_stock_total)#</td>
                        </cfoutput>
                        
                        <cfoutput query="get_list_departments">
                            <td style="text-align:right;">#tlformat(evaluate('t_stock_tl_total_#department_id#'))#</td>
                        </cfoutput>
                        <cfoutput>
                            <td style="text-align:right; ">#tlformat(t_stock_tl_total)#</td>
                        </cfoutput>
                        
                        <cfoutput query="get_list_departments">
                            <td style="text-align:right;">#tlformat(evaluate('t_siparis_total_#department_id#'))#</td>
                        </cfoutput>
                        <cfoutput>
                            <td style="text-align:right; ">#tlformat(t_siparis_total)#</td>
                            <td style="text-align:right; ">#tlformat(t_siparis_tutar_total)#</td>
                        </cfoutput>
                    </tr>
                </tfoot>
            </cf_grid_list>
        </cf_box>
    </div>
</cfif>
<script>
function add_row(sid_,pname_,psales_)
{
	icerik_ = '<div id="selected_product_' + sid_ + '">';
	icerik_ += '<a href="javascript://" onclick="del_row_p(' + sid_ +')">';
	icerik_ += '<img src="/images/delete_list.gif">';
	icerik_ += '</a>';
	icerik_ += '<input type="hidden" name="search_stock_id" value="' + sid_ + '">';
	icerik_ += pname_;
	icerik_ += '</div>';
	
	$('#product_div').append(icerik_);
}

function del_row_p(sid_)
{
	$("#selected_product_" + sid_).remove();	
}

function control_search_depo()
{
	if(document.getElementById('search_department_id').value == '')
	{
		alert('<cf_get_lang dictionary_id='53200.Departman Seçiniz'>!');
		return false;
	}
	return true;
}
</script>