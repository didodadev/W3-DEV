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

<cf_big_list_search title="Stok Güncel Raporu">
<cfform action="#request.self#?fuseaction=retail.purchase_to_date_report" method="post" name="search_depo">
<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
	<cf_big_list_search_area>
    	<table>
            <tr>
                <td><cf_get_lang_main no='48.Filtre'></td>
                <td><cfinput type="text" name="keyword" id="keyword" style="width:90px;" value="#attributes.keyword#" maxlength="500"></td>
                <td><input type="checkbox" value="1" name="stock_info" <cfif isdefined("attributes.stock_info")>checked</cfif>> Stok Bilgisi</td>
                <td>Tarih</td>
                <td>
                    <cfsavecontent variable="message">Bitiş</cfsavecontent>
                    <cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                    <cf_wrk_date_image date_field="finishdate">
                </td>
                <td>Stok Durumu</td>
                <td>
                	<select name="stock_status">
                    		<option value="1" <cfif attributes.stock_status eq 1>selected</cfif>>Stok Olanlar</option>
                            <option value="0" <cfif attributes.stock_status eq 0>selected</cfif>>Stok Olmayanlar</option>
                            <option value="-1" <cfif attributes.stock_status eq -1>selected</cfif>>Eksi Stoklar</option>
                            <option value="-2" <cfif attributes.stock_status eq -2>selected</cfif>>Eksi ve Sıfır Stoklar</option>
                            <option value="" <cfif not len(attributes.stock_status)>selected</cfif>>Tüm Stoklar</option>
                    </select>
                </td>
                <td>Departman</td>
                <td>
                	<cf_multiselect_check 
                            query_name="get_departments_search"  
                            name="search_department_id"
                            option_text="Departman" 
                            width="180"
                            option_name="department_head" 
                            option_value="department_id"
                            value="#attributes.search_department_id#">
                </td>
                <td>Üretici</td>
                <td>
                	<cf_multiselect_check 
                            query_name="get_uretici"  
                            name="uretici"
                            option_text="Üretici" 
                            width="180"
                            option_name="SUB_TYPE_NAME" 
                            option_value="SUB_TYPE_ID"
                            value="#attributes.uretici#">
                </td>
                <td>
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
                <td>
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
                <td>
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
                <td><cf_wrk_search_button search_function="control_search_depo()"></td>
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
        S.PRODUCT_CATID = PC.PRODUCT_CATID AND
        PC.PRODUCT_CATID IN (#p_cat_list#)
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
    <table cellpadding="2" cellspacing="1" width="99%" align="center" class="color-border">
    	<thead>
        <tr class="color-header">
            	<th class="form-title" height="22">Sıra</th>
               <!--- <th class="form-title">Ana Grup</th>
                <th class="form-title">Alt Grup 1</th>
                <th class="form-title">Alt Grup 2</th>--->
                <th class="form-title">Ürün</th>
                <cfif isdefined("attributes.stock_info")>
                <th class="form-title">Durum</th>
                <th class="form-title">Stok ID</th>
                <th class="form-title">Stok Kodu</th>
                <th class="form-title">Alış KDV</th>
                <th class="form-title">Satış KDV</th>
                <th class="form-title">Birim</th>
                <!--- <th class="form-title">A. Fiyat</th>--->
                 <th class="form-title">A. Fiyat KDV</th>
                 <!---<th class="form-title">S. Fiyat</th>--->
                 <!---<th class="form-title">S. Fiyat KDV</th>--->
                </cfif>
                <cfif listlen(attributes.search_department_id)>
                	<cfoutput query="get_list_departments"><th style="text-align:right;" class="form-title">#DEPARTMENT_HEAD#</th></cfoutput>
                </cfif>
               <!--- <th style="text-align:right;" class="form-title">D. Toplam Stok</th> --->
                <cfif isdefined("attributes.stock_info")>
                	<th style="text-align:right;" class="form-title">Toplam Stok</th>
                	 <!---<th style="text-align:right;" class="form-title">Stok * Alış Fiyatı</th>--->
                    <th style="text-align:right;" class="form-title">Stok * Alış Fiyatı KDV</th>
                   <!--- <th style="text-align:right;" class="form-title">Stok * Satış Fiyatı</th> --->
                  <!---   <th style="text-align:right;" class="form-title">Stok * Satış Fiyatı KDV</th>--->
                </cfif>
            </tr>
        </thead>
        <tbody>
        	<cfoutput>
            <tr class="color-row">
                <td colspan="<cfif isdefined("attributes.stock_info")>6<cfelse>4</cfif>" style="background-color:##6CC;" class="form-title">Genel Toplamlar</td>
                <cfif listlen(attributes.search_department_id)>
                    <cfloop query="get_list_departments">
                        <td style="text-align:right;background-color:##6CC;">#tlformat(evaluate('general_dept_total_#GET_LIST_DEPARTMENTS.DEPARTMENT_ID#'))#</td>
                    </cfloop>
                </cfif>
               <!--- <td style="text-align:right;background-color:##6CC;">#TLFORMAT(genel_toplam)#</td>--->
                <cfif isdefined("attributes.stock_info")>
                	<td style="text-align:right;background-color:##6CC;">#TLFORMAT(en_genel_toplam)#</td>
                    <td style="text-align:right;background-color:##6CC;">#TLFORMAT(genel_toplam_stock_al)#</td>
                    <td style="text-align:right;background-color:##6CC;">#TLFORMAT(genel_toplam_stock_al_kdv)#</td>
                    <td style="text-align:right;background-color:##6CC;">#TLFORMAT(genel_toplam_stock_sat)#</td>
                    <td style="text-align:right;background-color:##6CC;">#TLFORMAT(genel_toplam_stock_sat_kdv)#</td>
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
                <cfset ucuncu_ = ikinci_ & '.' & listgetat(stock_code,3,'.')>
                <tr class="color-row">
                	<td>#currentrow#</td>
                   <!--- <td>
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
                    </td> --->
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
          
                   <!--- <td style="text-align:right;">#tlformat(alis_)#</td> --->
                    <td style="text-align:right;">#tlformat(alis_kdv_)#</td>
                    
                                
                    <!---<td style="text-align:right;">#tlformat(satis_)#</td>
                     <td style="text-align:right;">#tlformat(satis_kdv_)#</td>--->
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
                    	<!---<td style="text-align:right;">#TLFORMAT(TOPLAM_STOCK * alis_)#</td> --->
                        <td style="text-align:right;">#TLFORMAT(TOPLAM_STOCK * alis_kdv_)#</td>
                        <!---<td style="text-align:right;">#TLFORMAT(TOPLAM_STOCK * satis_)#</td>--->
                       <!--- <td style="text-align:right;">#TLFORMAT(TOPLAM_STOCK * satis_kdv_)#</td>--->
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
                    	<td colspan="<cfif isdefined("attributes.stock_info")>6<cfelse>4</cfif>" style="background-color:##6CC;" class="form-title">Toplamlar</td>
                        <cfif listlen(attributes.search_department_id)>
                            <cfloop query="get_list_departments">
                                <td style="text-align:right;background-color:##6CC;">#tlformat(evaluate('dept_total_#GET_LIST_DEPARTMENTS.DEPARTMENT_ID#'))#</td>
                            </cfloop>
                        </cfif>
                        <td style="text-align:right;background-color:##6CC;">#TLFORMAT(ucuncu_toplam)#</td>
                        <cfif isdefined("attributes.stock_info")>
                        	<td style="text-align:right;background-color:##6CC;">#TLFORMAT(ucuncu_en_toplam)#</td>
                            <td style="text-align:right;background-color:##6CC;">#TLFORMAT(ara_toplam_stock_al)#</td>
                            <td style="text-align:right;background-color:##6CC;">#TLFORMAT(ara_toplam_stock_al_kdv)#</td>
                            <td style="text-align:right;background-color:##6CC;">#TLFORMAT(ara_toplam_stock_sat)#</td>
                            <td style="text-align:right;background-color:##6CC;">#TLFORMAT(ara_toplam_stock_sat_kdv)#</td>
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
    </table>
<!-- sil -->
</cfif>