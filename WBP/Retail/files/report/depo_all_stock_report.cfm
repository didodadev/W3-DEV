<cfparam name="attributes.hierarchy1" default="">
<cfparam name="attributes.hierarchy2" default="">
<cfparam name="attributes.hierarchy3" default="">
<cfparam name="attributes.uretici" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.search_department_id" default="#merkez_depo_id#">
<cfparam name="attributes.stock_status" default="1">

<cfif isdefined("attributes.finishdate") and len(attributes.finishdate) and isdate(attributes.finishdate)>
	<cf_date tarih='attributes.finishdate'>
<cfelse>
	<cfset attributes.finishdate = createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')>	
</cfif>

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
	SELECT SUB_TYPE_ID,SUB_TYPE_NAME FROM EXTRA_PRODUCT_TYPES_SUBS WHERE TYPE_ID = #uretici_type_id# 
</cfquery>

<cf_report_list_search title="#getLang('','Sipariş Stok Raporu',32444)#">
    <cf_report_list_search_area>
        <cfform action="#request.self#?fuseaction=retail.depo_all_stock_report" method="post" name="search_depo">
            <input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
            <div class="row">
                <div class="col col-12 col-xs-12">
                    <div class="row formContent">
                        <div class="row" type="row">	
                            <div class="col col-3 col-md-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57460.Filtre'></label>
                                    <div class="col col-12 col-xs-12">
                                        <cfinput type="text" name="keyword" id="keyword" style="width:90px;" value="#attributes.keyword#" maxlength="500">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='32542.Stok Durumu'></label>
                                    <div class="col col-12 col-xs-12">
                                        <select name="stock_status">
                                            <option value="1" <cfif attributes.stock_status eq 1>selected</cfif>><cf_get_lang dictionary_id='33476.Stokta Olanlar'></option>
                                            <option value="0" <cfif attributes.stock_status eq 0>selected</cfif>><cf_get_lang dictionary_id='61615.Stokta Olmayanlar'></option>
                                            <option value="-1" <cfif attributes.stock_status eq -1>selected</cfif>><cf_get_lang dictionary_id='62061.Eksi Stoklar'></option>
                                            <option value="-2" <cfif attributes.stock_status eq -2>selected</cfif>><cf_get_lang dictionary_id='62062.Eksi ve Sıfır Stoklar'></option>
                                            <option value="" <cfif not len(attributes.stock_status)>selected</cfif>><cf_get_lang dictionary_id='62063.Tüm Stoklar'></option>
                                        </select>
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
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#getLang('','Bitiş Tarihi',57700)#" required="yes" style="width:65px;">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label><cf_get_lang dictionary_id='62804.Stok Bilgisi'><input type="checkbox" value="1" name="stock_info" <cfif isdefined("attributes.stock_info")>checked</cfif>></label>
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
	if(document.getElementById('search_department_id').value == '')
	{
		alert('<cf_get_lang dictionary_id='53200.Departman Seçiniz'>!');
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
        HIERARCHY LIKE '%.%.%' AND
    </cfif>
    PRODUCT_CATID IS NOT NULL 
    
</cfquery>
<cfif get_alt_GROUPS.recordcount>
	<cfset p_cat_list = valuelist(get_alt_GROUPS.PRODUCT_CATID)>
<cfelse>
	<cfset p_cat_list = "">
</cfif>

<cfquery name="get_internaldemand" datasource="#DSN2#" result="donus">
SELECT
	*
FROM
	(
	SELECT
		ISNULL((
        	SELECT
            	SUM(STOCK_IN-STOCK_OUT) AS STOCK
            FROM
            	#dsn#_#year(finishdate)#_#session.ep.company_id#.STOCKS_ROW SR1
            WHERE
            	SR1.STOCK_ID = S.STOCK_ID AND
                <cfif not isdefined("attributes.stock_info")>
                	SR1.STORE IN (#attributes.search_department_id#) AND
                <cfelse>
                	SR1.STORE NOT IN (#iade_depo_id#) AND    
                </cfif>
                SR1.PROCESS_DATE < #dateadd('d',1,attributes.finishdate)#
        ),0)  AS TOPLAM_STOCK,
        <cfif listlen(attributes.search_department_id)>
    		<cfloop list="#attributes.search_department_id#" index="dd"> 
                    ISNULL((
                    SELECT
                        SUM(STOCK_IN-STOCK_OUT) AS STOCK
                    FROM
                        #dsn#_#year(finishdate)#_#session.ep.company_id#.STOCKS_ROW SR1
                    WHERE
                        SR1.STOCK_ID = S.STOCK_ID AND
                        SR1.STORE IN (#dd#) AND
              			SR1.PROCESS_DATE < #dateadd('d',1,attributes.finishdate)#
                ),0)  AS MAGAZA_STOCK_#dd#,
             </cfloop>
        </cfif>  
        ISNULL((SELECT TOP 1 ETR.SUB_TYPE_ID FROM #DSN_DEV_ALIAS#.EXTRA_PRODUCT_TYPES_ROWS ETR WHERE S.PRODUCT_ID = ETR.PRODUCT_ID AND ETR.TYPE_ID = #uretici_type_id#),0) AS SUB_TYPE_ID,
       	PU.ADD_UNIT AS UNIT,
        PRICE_STANDART.PRICE PRICE_STANDART,
        PRICE_STANDART.PRICE_KDV PRICE_STANDART_KDV,
        PS.PRICE STANDART_SALE_PRICE,
        PS.PRICE_KDV AS STANDART_SALE_PRICE_KDV,
        ISNULL(( 
            SELECT TOP 1 
                PT1.NEW_ALIS
            FROM
                #DSN_DEV#.PRICE_TABLE PT1
            WHERE
                PT1.IS_ACTIVE_P = 1 AND
                PT1.P_STARTDATE <= #attributes.finishdate# AND 
                DATEADD("d",-1,PT1.P_FINISHDATE) >= #attributes.finishdate# AND
                (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = S.PRODUCT_ID))
            ORDER BY
                PT1.STARTDATE DESC,
                PT1.ROW_ID DESC
        ),9999) AS ALIS_LISTE_FIYATI,
        ISNULL((
            SELECT TOP 1
                PTS.STANDART_ALIS_LISTE
            FROM
                #dsn_dev_alias#.PRICE_TABLE_STANDART PTS
            WHERE
                PTS.STD_P_STARTDATE <= #attributes.finishdate# AND
                PTS.PRODUCT_ID = S.PRODUCT_ID
            ORDER BY
                PTS.RECORD_DATE DESC,
                PTS.STD_P_STARTDATE DESC,
                PTS.STANDART_ALIS ASC
            ),9999) AS OGUNKU_STANDART_FIYAT,
       	ISNULL(( 
                SELECT TOP 1 
                    PT1.NEW_PRICE
                FROM
                    #DSN_DEV#.PRICE_TABLE PT1
                WHERE
                    (
                    PT1.IS_ACTIVE_S = 1 AND
                    PT1.STARTDATE <= #attributes.finishdate# AND DATEADD("d",-1,PT1.FINISHDATE) >= #attributes.finishdate#) AND
                    PT1.PRODUCT_ID = S.PRODUCT_ID
                ORDER BY
                	PT1.STARTDATE DESC,
			PT1.ROW_ID DESC
            ),9999) AS SATIS_LISTE_FIYAT,
        ISNULL((
            SELECT TOP 1
                PTS.READ_FIRST_SATIS_PRICE
            FROM
                #dsn_dev_alias#.PRICE_TABLE_STANDART PTS
            WHERE
                PTS.STANDART_S_STARTDATE <= #attributes.finishdate# AND
                PTS.PRODUCT_ID = S.PRODUCT_ID
            ORDER BY
                PTS.RECORD_DATE DESC,
                PTS.STANDART_S_STARTDATE DESC,
                PTS.READ_FIRST_SATIS_PRICE_KDV ASC
            ),9999) AS OGUNKU_STANDART_SATIS_FIYAT,
        S.*
	FROM 
        #dsn3_alias#.STOCKS S,
        #dsn1_alias#.PRODUCT_CAT PC,
        #dsn3_alias#.PRICE_STANDART,
        #dsn3_alias#.PRICE_STANDART PS,
        #dsn3_alias#.PRODUCT_UNIT PU
	WHERE	
		PU.PRODUCT_ID = S.PRODUCT_ID AND
        PU.IS_MAIN = 1 AND
        PS.PRODUCT_ID = S.PRODUCT_ID AND
        PRICE_STANDART.PRODUCT_ID = S.PRODUCT_ID AND
        PS.PURCHASESALES = 1 AND
        PRICE_STANDART.PURCHASESALES = 0 AND
        PS.PRICESTANDART_STATUS = 1 AND
        PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
		<cfif len(attributes.keyword)>
        (
       		S.PRODUCT_NAME + ' ' + S.PROPERTY LIKE '%#attributes.keyword#%'
            OR
            (
                S.PRODUCT_NAME IS NOT NULL
                <cfloop from="1" to="#listlen(attributes.keyword,' ')#" index="ccc">
                    <cfif ccc eq 1>
                        <cfset kelime_ = listgetat(attributes.keyword,ccc,' ')>
                        AND
                        (
                        S.PRODUCT_NAME + ' ' + S.PROPERTY + ' ' + S.PRODUCT_CODE LIKE '%#kelime_#%' OR
                        S.PRODUCT_CODE_2 = '#kelime_#' OR
                        S.BARCOD = '#kelime_#' OR    
                        S.STOCK_CODE = '#kelime_#' OR
                        S.STOCK_CODE_2 = '#kelime_#' 
                        )
                   <cfelse>
                        <cfset kelime_ = listgetat(attributes.keyword,ccc,' ')>
                        AND
                        (
                        S.PRODUCT_NAME + ' ' + S.PROPERTY + ' ' + S.PRODUCT_CODE LIKE '%#kelime_#%' OR
                        S.PRODUCT_CODE_2 = '#kelime_#' OR
                        S.BARCOD = '#kelime_#' OR    
                        S.STOCK_CODE = '#kelime_#' OR
                        S.STOCK_CODE_2 = '#kelime_#'  
                        )
                   </cfif>
                </cfloop>
            )
       ) AND
    <cfelse>
        S.PRODUCT_NAME LIKE '%#attributes.keyword#%' AND
    </cfif>
        S.PRODUCT_STATUS = 1 AND
        --S.STOCK_STATUS = 1 AND
        S.PRODUCT_CATID = PC.PRODUCT_CATID 
        <cfif len(p_cat_list)>
            AND PC.PRODUCT_CATID IN (#p_cat_list#)
        </cfif>
    ) 
    T1
WHERE
	<cfif isdefined("attributes.uretici") and listlen(attributes.uretici)>
    	SUB_TYPE_ID IN (#attributes.uretici#) AND
    </cfif>
    <cfif attributes.stock_status eq 0>
    	TOPLAM_STOCK = 0 AND
    </cfif>
    <cfif attributes.stock_status eq 1>
    	TOPLAM_STOCK > 0 AND
    </cfif>
    <cfif attributes.stock_status eq -1>
    	TOPLAM_STOCK < 0 AND
    </cfif>
    <cfif attributes.stock_status eq -2>
    	TOPLAM_STOCK <= 0 AND
    </cfif>
	TOPLAM_STOCK IS NOT NULL
ORDER BY
     T1.STOCK_CODE ASC,
     T1.PRODUCT_NAME ASC
</cfquery> 

<!---
<cfdump var="#donus.EXECUTIONTIME#">
--->

<cfif listlen(attributes.search_department_id)>
    <cfquery name="get_list_departments" dbtype="query">
        SELECT * FROM get_departments_search WHERE DEPARTMENT_ID IN (#attributes.search_department_id#) ORDER BY DEPARTMENT_HEAD
    </cfquery>
</cfif>


<cfset en_genel_toplam = 0> 
<cfset genel_toplam = 0> 
<cfset genel_toplam_stock_al = 0> 
<cfset genel_toplam_stock_al_kdv = 0> 
<cfset genel_toplam_stock_sat = 0> 
<cfset genel_toplam_stock_sat_kdv = 0> 
<cfif listlen(attributes.search_department_id)>
	<cfloop query="get_list_departments">
		<cfset 'general_dept_total_#GET_LIST_DEPARTMENTS.DEPARTMENT_ID#' = 0>
	</cfloop>
</cfif>


<cfoutput query="get_internaldemand">
<cfset row_total_ = 0>
<cfif listlen(attributes.search_department_id)>
	<cfloop query="get_list_departments">
    	<cfset row_total_ = row_total_ + evaluate("get_internaldemand.MAGAZA_STOCK_#GET_LIST_DEPARTMENTS.DEPARTMENT_ID#")>
		<cfset 'general_dept_total_#GET_LIST_DEPARTMENTS.DEPARTMENT_ID#' = evaluate('general_dept_total_#GET_LIST_DEPARTMENTS.DEPARTMENT_ID#') + evaluate("get_internaldemand.MAGAZA_STOCK_#GET_LIST_DEPARTMENTS.DEPARTMENT_ID#")>
    </cfloop>
</cfif>

<cfset a_kdv = tax_purchase>
<cfset s_kdv = tax>

<cfset satis_kdv_rank = 1 + (s_kdv / 100)>
<cfset alis_kdv_rank = 1 + (s_kdv / 100)>

<cfif len(PRICE_STANDART)>
	<cfset alis_ = PRICE_STANDART>
    <cfset alis_kdv_ = PRICE_STANDART * alis_kdv_rank>
<cfelse>
	<cfset alis_ = 0>
    <cfset alis_kdv_ = 0>
</cfif>

<cfif ogunku_standart_fiyat neq 9999>
	<cfset alis_ = ogunku_standart_fiyat>
	<cfset alis_kdv_ = ogunku_standart_fiyat * alis_kdv_rank>
</cfif>

<cfif alis_liste_fiyati neq 9999 and alis_liste_fiyati lt alis_>
	<cfset alis_ = alis_liste_fiyati>
	<cfset alis_kdv_ = alis_liste_fiyati * alis_kdv_rank>
</cfif>                    

<cfset satis_ = standart_sale_price>
<cfset satis_kdv_ = standart_sale_price_kdv>

<cfif ogunku_standart_satis_fiyat neq 9999>
	<cfset satis_ = ogunku_standart_satis_fiyat>
	<cfset satis_kdv_ = ogunku_standart_satis_fiyat * satis_kdv_rank>
</cfif>

<cfif satis_liste_fiyat neq 9999 and satis_liste_fiyat lt satis_>
	<cfset satis_ = satis_liste_fiyat>
	<cfset satis_kdv_ = satis_liste_fiyat * satis_kdv_rank>
</cfif>

<cfset en_genel_toplam = en_genel_toplam + TOPLAM_STOCK> 
<cfset genel_toplam = genel_toplam + row_total_>
<cfset genel_toplam_stock_al = genel_toplam_stock_al + (TOPLAM_STOCK * alis_)> 
<cfset genel_toplam_stock_al_kdv = genel_toplam_stock_al_kdv + (TOPLAM_STOCK * alis_kdv_)> 
<cfset genel_toplam_stock_sat = genel_toplam_stock_sat + (TOPLAM_STOCK * satis_)> 
<cfset genel_toplam_stock_sat_kdv = genel_toplam_stock_sat_kdv + (TOPLAM_STOCK * satis_kdv_)> 
</cfoutput>
<!-- sil -->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cf_grid_list>
            <thead>
                <tr class="color-header">
                    <th class="form-title" height="22"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th class="form-title"><cf_get_lang dictionary_id='61641.Ana Grup'></th>
                    <th class="form-title"><cf_get_lang dictionary_id='61642.Alt Grup'> 1</th>
                    <th class="form-title"><cf_get_lang dictionary_id='61642.Alt Grup'> 2</th>
                    <th class="form-title"><cf_get_lang dictionary_id='44019.Ürün'></th>
                    <cfif isdefined("attributes.stock_info")>
                    <th class="form-title"><cf_get_lang dictionary_id='57756.Durum'></th>
                    <th class="form-title"><cf_get_lang dictionary_id='57452.Stok'> ID</th>
                    <th class="form-title"><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
                    <th class="form-title"><cf_get_lang dictionary_id='37631.Alış KDV'></th>
                    <th class="form-title"><cf_get_lang dictionary_id='37916.Satış KDV'></th>
                    <th class="form-title"><cf_get_lang dictionary_id='57636.Birim'></th>
                    <th class="form-title"><cf_get_lang dictionary_id='46811.Alış Fiyat'></th>
                    <th class="form-title"><cf_get_lang dictionary_id='46811.Alış Fiyat'> <cf_get_lang dictionary_id='57639.KDV'></th>
                    <th class="form-title"><cf_get_lang dictionary_id='46812.Satış Fiyat'></th>
                    <th class="form-title"><cf_get_lang dictionary_id='46812.Satış Fiyat'> <cf_get_lang dictionary_id='57639.KDV'></th>
                    </cfif>
                    <cfif listlen(attributes.search_department_id)>
                        <cfoutput query="get_list_departments"><th style="text-align:right;" class="form-title">#DEPARTMENT_HEAD#</th></cfoutput>
                    </cfif>
                    <th style="text-align:right;" class="form-title">D. <cf_get_lang dictionary_id='29512.Toplam Stok'></th>
                    <cfif isdefined("attributes.stock_info")>
                        <th style="text-align:right;" class="form-title"><cf_get_lang dictionary_id='29512.Toplam Stok'></th>
                        <th style="text-align:right;" class="form-title"><cf_get_lang dictionary_id='57452.Stok'> * <cf_get_lang dictionary_id='46811.Alış Fiyat'></th>
                        <th style="text-align:right;" class="form-title"><cf_get_lang dictionary_id='57452.Stok'> * <cf_get_lang dictionary_id='46811.Alış Fiyat'> <cf_get_lang dictionary_id='57639.KDV'></th>
                        <th style="text-align:right;" class="form-title"><cf_get_lang dictionary_id='57452.Stok'> * <cf_get_lang dictionary_id='46812.Satış Fiyat'></th>
                        <th style="text-align:right;" class="form-title"><cf_get_lang dictionary_id='57452.Stok'> * <cf_get_lang dictionary_id='46812.Satış Fiyat'> <cf_get_lang dictionary_id='57639.KDV'></th>
                    </cfif>
                </tr>
            </thead>
            <tbody>
                <cfoutput>
                <tr class="color-row">
                    <td colspan="<cfif isdefined("attributes.stock_info")>15<cfelse>5</cfif>" style="" class="form-title"><cf_get_lang dictionary_id='40035.Genel Toplamlar'></td>
                    <cfif listlen(attributes.search_department_id)>
                        <cfloop query="get_list_departments">
                            <td style="text-align:right;">#tlformat(evaluate('general_dept_total_#GET_LIST_DEPARTMENTS.DEPARTMENT_ID#'))#</td>
                        </cfloop>
                    </cfif>
                    <td style="text-align:right;">#TLFORMAT(genel_toplam)#</td>
                    <cfif isdefined("attributes.stock_info")>
                        <td style="text-align:right;">#TLFORMAT(en_genel_toplam)#</td>
                        <td style="text-align:right;">#TLFORMAT(genel_toplam_stock_al)#</td>
                        <td style="text-align:right;">#TLFORMAT(genel_toplam_stock_al_kdv)#</td>
                        <td style="text-align:right;">#TLFORMAT(genel_toplam_stock_sat)#</td>
                        <td style="text-align:right;">#TLFORMAT(genel_toplam_stock_sat_kdv)#</td>
                    </cfif>
                </tr>
                </cfoutput>
                
                <cfset ucuncu_toplam = 0> 
                <cfif listlen(attributes.search_department_id)>
                    <cfloop query="get_list_departments">
                        <cfset 'dept_total_#GET_LIST_DEPARTMENTS.DEPARTMENT_ID#' = 0>
                    </cfloop>
                </cfif>
                
                <cfset last_birinci_ = "">
                <cfset last_ikinci_ = "">
                <cfset last_ucuncu_ = "">
                <cfset ucuncu_toplam = 0>
                <cfset ucuncu_en_toplam = 0>
                <cfset ara_toplam_stock_al = 0> 
                <cfset ara_toplam_stock_al_kdv = 0> 
                <cfset ara_toplam_stock_sat = 0> 
                <cfset ara_toplam_stock_sat_kdv = 0> 
                <cfif listlen(attributes.search_department_id)>
                    <cfloop query="get_list_departments">
                        <cfset 'dept_total_#GET_LIST_DEPARTMENTS.DEPARTMENT_ID#' = 0>
                    </cfloop>
                </cfif>
                <cfoutput query="get_internaldemand">
                    <cfset birinci_ = listfirst(stock_code,'.')>
                    <cfset ikinci_ = birinci_ & '.' & listgetat(stock_code,2,'.')>
                    <cfif listlen(stock_code,'.') gt 2>
                        <cfset ucuncu_ = ikinci_ & '.' & listgetat(stock_code,3,'.')>
                    <cfelse>
                        <cfset ucuncu_ = "">
                    </cfif>
                    <tr class="color-row">
                        <td>#currentrow#</td>
                        <td>
                            <cfif not len(last_birinci_) or last_birinci_ is not birinci_>
                                <cfset sira_ = listfind(hierarchy_list,birinci_)>
                                <cfif sira_ neq 0>#listgetat(hierarchy_name_list,sira_,'╗')#</cfif>
                            </cfif>
                        </td>
                        <td>
                            <cfif not len(last_ikinci_) or last_ikinci_ is not ikinci_>
                                <cfset sira_ = listfind(hierarchy_list,ikinci_)>
                                <cfif sira_ neq 0>#listgetat(hierarchy_name_list,sira_,'╗')#</cfif>
                            </cfif>
                        </td>
                        <td>
                            <cfif not len(last_ucuncu_) or last_ucuncu_ is not ucuncu_>
                                <cfset sira_ = listfind(hierarchy_list,ucuncu_)>
                                <cfif sira_ neq 0>#listgetat(hierarchy_name_list,sira_,'╗')#</cfif>
                            </cfif>
                        </td>
                        <td><cfif len(PROPERTY)>#PROPERTY#<cfelse>#product_name#</cfif></td>
                        <cfif isdefined("attributes.stock_info")>
                        <td><cfif stock_status eq 1>Aktif<cfelse>Pasif</cfif></td>
                        <td>#stock_id#</td>
                        <td>#stock_code#</td>
                        <td>#tax_purchase#</td>
                        <td>#tax#</td>
                        <td>#UNIT#</td>
                        
                        <cfset a_kdv = tax_purchase>
                        <cfset s_kdv = tax>
                        
                        <cfset satis_kdv_rank = 1 + (s_kdv / 100)>
                        <cfset alis_kdv_rank = 1 + (s_kdv / 100)>
                        
                        <cfif len(PRICE_STANDART)>
                            <cfset alis_ = PRICE_STANDART>
                            <cfset alis_kdv_ = PRICE_STANDART * alis_kdv_rank>
                        <cfelse>
                            <cfset alis_ = 0>
                            <cfset alis_kdv_ = 0>
                        </cfif>
                        
                        <cfif ogunku_standart_fiyat neq 9999>
                            <cfset alis_ = ogunku_standart_fiyat>
                            <cfset alis_kdv_ = ogunku_standart_fiyat * alis_kdv_rank>
                        </cfif>
                        
                        <cfif alis_liste_fiyati neq 9999 and alis_liste_fiyati lt alis_>
                            <cfset alis_ = alis_liste_fiyati>
                            <cfset alis_kdv_ = alis_liste_fiyati * alis_kdv_rank>
                        </cfif>                    
                        
                        <cfset satis_ = standart_sale_price>
                        <cfset satis_kdv_ = standart_sale_price_kdv>
                        
                        <cfif ogunku_standart_satis_fiyat neq 9999>
                            <cfset satis_ = ogunku_standart_satis_fiyat>
                            <cfset satis_kdv_ = ogunku_standart_satis_fiyat * satis_kdv_rank>
                        </cfif>
                        
                        <cfif satis_liste_fiyat neq 9999 and satis_liste_fiyat lt satis_>
                            <cfset satis_ = satis_liste_fiyat>
                            <cfset satis_kdv_ = satis_liste_fiyat * satis_kdv_rank>
                        </cfif>
            
                        <td style="text-align:right;">#tlformat(alis_)#</td>
                        <td style="text-align:right;">#tlformat(alis_kdv_)#</td>
                        
                                    
                        <td style="text-align:right;">#tlformat(satis_)#</td>
                        <td style="text-align:right;">#tlformat(satis_kdv_)#</td>
                        </cfif>
                        <cfset row_total_ = 0>
                        <cfif listlen(attributes.search_department_id)>
                            <cfloop query="get_list_departments">
                                <td style="text-align:right;">#TLFORMAT(evaluate("get_internaldemand.MAGAZA_STOCK_#GET_LIST_DEPARTMENTS.DEPARTMENT_ID#"))#</td>
                                <cfset row_total_ = row_total_ + evaluate("get_internaldemand.MAGAZA_STOCK_#GET_LIST_DEPARTMENTS.DEPARTMENT_ID#")>
                                <cfset 'dept_total_#GET_LIST_DEPARTMENTS.DEPARTMENT_ID#' = evaluate('dept_total_#GET_LIST_DEPARTMENTS.DEPARTMENT_ID#') + evaluate("get_internaldemand.MAGAZA_STOCK_#GET_LIST_DEPARTMENTS.DEPARTMENT_ID#")>                        
                            </cfloop>
                        </cfif>
                        <td style="text-align:right;">#TLFORMAT(row_total_)#</td>
                        <cfif isdefined("attributes.stock_info")>
                            <td style="text-align:right;">#TLFORMAT(TOPLAM_STOCK)#</td>
                            <td style="text-align:right;">#TLFORMAT(TOPLAM_STOCK * alis_)#</td>
                            <td style="text-align:right;">#TLFORMAT(TOPLAM_STOCK * alis_kdv_)#</td>
                            <td style="text-align:right;">#TLFORMAT(TOPLAM_STOCK * satis_)#</td>
                            <td style="text-align:right;">#TLFORMAT(TOPLAM_STOCK * satis_kdv_)#</td>
                        </cfif>
                    </tr>
                    <cfset ucuncu_en_toplam = ucuncu_en_toplam + TOPLAM_STOCK>
                    <cfset ucuncu_toplam = ucuncu_toplam + row_total_>   
                    <cfset ara_toplam_stock_al = ara_toplam_stock_al + (TOPLAM_STOCK * alis_)> 
                    <cfset ara_toplam_stock_al_kdv = ara_toplam_stock_al_kdv + (TOPLAM_STOCK * alis_kdv_)> 
                    <cfset ara_toplam_stock_sat = ara_toplam_stock_sat + (TOPLAM_STOCK * satis_)> 
                    <cfset ara_toplam_stock_sat_kdv = ara_toplam_stock_sat_kdv + (TOPLAM_STOCK * satis_kdv_)> 

                    <cfset last_birinci_ = birinci_>
                    <cfset last_ikinci_ = ikinci_>
                    <cfset last_ucuncu_ = ucuncu_>
                    <cfif currentrow eq get_internaldemand.recordcount or not get_internaldemand.stock_code[currentrow + 1] contains ucuncu_>
                        <tr class="color-row">
                            <td colspan="<cfif isdefined("attributes.stock_info")>15<cfelse>5</cfif>" style="" class="form-title">Toplamlar</td>
                            <cfif listlen(attributes.search_department_id)>
                                <cfloop query="get_list_departments">
                                    <td style="text-align:right;">#tlformat(evaluate('dept_total_#GET_LIST_DEPARTMENTS.DEPARTMENT_ID#'))#</td>
                                </cfloop>
                            </cfif>
                            <td style="text-align:right;">#TLFORMAT(ucuncu_toplam)#</td>
                            <cfif isdefined("attributes.stock_info")>
                                <td style="text-align:right;">#TLFORMAT(ucuncu_en_toplam)#</td>
                                <td style="text-align:right;">#TLFORMAT(ara_toplam_stock_al)#</td>
                                <td style="text-align:right;">#TLFORMAT(ara_toplam_stock_al_kdv)#</td>
                                <td style="text-align:right;">#TLFORMAT(ara_toplam_stock_sat)#</td>
                                <td style="text-align:right;">#TLFORMAT(ara_toplam_stock_sat_kdv)#</td>
                            </cfif>
                        </tr>
                        <cfset ucuncu_toplam = 0> 
                        <cfif listlen(attributes.search_department_id)>
                            <cfloop query="get_list_departments">
                                <cfset 'dept_total_#GET_LIST_DEPARTMENTS.DEPARTMENT_ID#' = 0>
                            </cfloop>
                        </cfif>         
                    </cfif>
                </cfoutput>
            </tbody>
        </cf_grid_list>
    </cf_box>
</div>

<!-- sil -->
</cfif>