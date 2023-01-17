<cfset only_this_year = 1>

<cfif month(now()) eq 1 and day(now()) lte order_control_day>
	<cfset only_this_year = 0>
</cfif>

<cfif month(now()) eq 12 and day(now()) gt order_control_day>
	<cfset only_this_year = 0>
</cfif>

<cfquery name="get_periods" datasource="#dsn#">
	SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID IS NOT NULL <cfif only_this_year eq 1>AND PERIOD_YEAR = #year(now())#</cfif>
    	
</cfquery>
<cfquery name="get_periods_ic" datasource="#dsn#">
	SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID IS NOT NULL <cfif only_this_year eq 1>AND PERIOD_YEAR = #year(now())#</cfif>
</cfquery>

<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.hierarchy1" default="">
<cfparam name="attributes.hierarchy2" default="">
<cfparam name="attributes.hierarchy3" default="">
<cfparam name="attributes.search_department_id" default="#merkez_depo_id#">
<cfparam name="attributes.startdate" default="#date_add('d',order_control_day,now())#">
<cfparam name="attributes.finishdate" default="#now()#">
<cfparam name="attributes.add_type" default="">
<cfparam name="attributes.view_type" default="">

<cfif isdefined("attributes.is_form_submitted")>
	<cfif isdate(attributes.startdate)><cf_date tarih = "attributes.startdate"></cfif>
	<cfif isdate(attributes.finishdate)><cf_date tarih = "attributes.finishdate"></cfif>
</cfif>
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
<cfif get_alt_groups.recordcount>
	<cfset p_cat_list = valuelist(get_alt_groups.PRODUCT_CATID)>
<cfelse>
	<cfset p_cat_list = "">
</cfif>

<cfif listlen(attributes.search_department_id)>
    <cfquery name="get_list_departments" dbtype="query">
        SELECT * FROM get_departments_search WHERE DEPARTMENT_ID IN (#attributes.search_department_id#) ORDER BY DEPARTMENT_HEAD
    </cfquery>
    <cfset dept_list = valuelist(get_list_departments.department_id)>
<cfelse>
	<cfset dept_list = listfirst(session.ep.USER_LOCATION,'-')>
</cfif>

    <cfquery name="get_dagilim" datasource="#dsn3#" result="get_dagilim_r">
        SELECT
            STOK_ADI,
            URUN_ADI,
            DISPATCH_SHIP_ID,
            DELIVER_DATE,
            MIKTAR,
            KARSILANAN,
            KALAN,
            DEPT_IN,
            DEPT_OUT,
            BARCOD,
            ISNULL((SELECT SUM(PRODUCT_STOCK) FROM #DSN#_#year(now())#_#session.ep.company_id#.GET_STOCK_PRODUCT WHERE T_ALL.STOCK_ID = GET_STOCK_PRODUCT.STOCK_ID AND GET_STOCK_PRODUCT.DEPARTMENT_ID = T_ALL.DEPARTMENT_IN),0) AS IN_STOCK,
            ISNULL((SELECT SUM(PRODUCT_STOCK) FROM #DSN#_#year(now())#_#session.ep.company_id#.GET_STOCK_PRODUCT WHERE T_ALL.STOCK_ID = GET_STOCK_PRODUCT.STOCK_ID AND GET_STOCK_PRODUCT.DEPARTMENT_ID = T_ALL.DEPARTMENT_OUT),0) AS OUT_STOCK,
            IN_STOCK- OUT_STOCK as KALAN,
            CODE
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
                    SIR.AMOUNT MIKTAR,
                    (SELECT D.DEPARTMENT_HEAD FROM #dsn_alias#.DEPARTMENT D WHERE D.DEPARTMENT_ID = SI.DEPARTMENT_IN) AS DEPT_IN,
                    (SELECT D.DEPARTMENT_HEAD FROM #dsn_alias#.DEPARTMENT D WHERE D.DEPARTMENT_ID = SI.DEPARTMENT_OUT) AS DEPT_OUT,
                    SI.*,
                    SIR.STOCK_ID,
                    S.PROPERTY AS STOK_ADI,
                    S.PRODUCT_NAME AS URUN_ADI,
                    S.BARCOD
                FROM
                    #dsn#_#period_year#_#our_company_id#.SHIP_INTERNAL SI,
                    #dsn#_#period_year#_#our_company_id#.SHIP_INTERNAL_ROW SIR,
                    STOCKS S
                WHERE
			        <cfif isdefined("attributes.search_stock_id") and len(attributes.search_stock_id)>
                        S.STOCK_ID IN (#attributes.search_stock_id#) AND
                    </cfif>
                    <cfif len(attributes.keyword)>
                        (
                        SI.CODE LIKE '%#attributes.keyword#%'
                        OR
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
                    <cfif attributes.add_type eq 1>
                    	SI.CODE IS NOT NULL AND
                    </cfif>
                    <cfif attributes.add_type eq 0>
                    	SI.CODE IS NULL AND
                    </cfif>
                    S.PRODUCT_CATID IN (#p_cat_list#) AND
                    SIR.STOCK_ID = S.STOCK_ID AND
                    <cfif len(attributes.startdate)>
                    SI.DELIVER_DATE >= #attributes.startdate# AND
                    </cfif>
                    <cfif len(attributes.finishdate)>
                    SI.DELIVER_DATE < #DATEADD('d',1,attributes.finishdate)# AND
                    </cfif>
                    SI.DISPATCH_SHIP_ID = SIR.DISPATCH_SHIP_ID AND
                    <cfif attributes.view_type eq 0>
                    	SI.DEPARTMENT_OUT IN (#dept_list#)
                    <cfelseif attributes.view_type eq 1>
                    	SI.DEPARTMENT_IN IN (#dept_list#)
                    <cfelse>
                    	(SI.DEPARTMENT_IN IN (#dept_list#) OR SI.DEPARTMENT_OUT IN (#dept_list#))
                    </cfif>
                <cfif currentrow neq get_periods.recordcount>
                UNION ALL
                </cfif>
            </cfoutput>
          ) T_ALL
         WHERE
            MIKTAR > KARSILANAN   
        ORDER BY
            DELIVER_DATE DESC,
            DEPT_IN,
            STOK_ADI             
    </cfquery>
<cfelse>
	<cfset get_dagilim.recordcount = 0>
</cfif>
    <cf_big_list_search title="Sevk Bakiye Raporu">
    <cfform action="#request.self#?fuseaction=retail.depo_transfer_report_1" method="post" name="search_depo">
    <input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
        <cf_big_list_search_area>
            <table>
                <tr>
                    <td>Filtre</td>
                    <td><cfinput type="text" name="keyword" value="#attributes.keyword#"></td>
                    <td>Kayıt Tipi</td>
                    <td>
                    	<select name="add_type">
                        	<option value="">Hepsi</option>
                            <option value="0" <cfif attributes.add_type eq 0>selected</cfif>>Mağaza Talebi</option>
                            <option value="1" <cfif attributes.add_type eq 1>selected</cfif>>Merkezi Dağıtım</option>
                        </select>
                    </td>
                    <td>İşlem Tipi</td>
                    <td>
                    	<select name="view_type">
                        	<option value="">Hepsi</option>
                            <option value="0" <cfif attributes.view_type eq 0>selected</cfif>>Çıkışlar</option>
                            <option value="1" <cfif attributes.view_type eq 1>selected</cfif>>Girişler</option>
                        </select>
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
                    <td><cf_get_lang_main no ='89.Başlangıç'>
                        <cfsavecontent variable="message"><cf_get_lang_main no='641.Başlangıç Tarihi'></cfsavecontent>
                        <cfinput type="text" name="startdate" style="width:65px;" value="#dateformat(attributes.startdate,'dd/mm/yyyy')#" validate="eurodate" message="#message#" maxlength="10" required="yes">
                        <cf_wrk_date_image date_field="startdate">
                    </td>
                    <td><cf_get_lang_main no ='90.Bitiş'>
                        <cfsavecontent variable="message"><cf_get_lang_main no='288.Bitiş Tarihi'></cfsavecontent>
                        <cfinput type="text" name="finishdate" style="width:65px;" value="#dateformat(attributes.finishdate,'dd/mm/yyyy')#" validate="eurodate" message="#message#" maxlength="10" required="yes">
                        <cf_wrk_date_image date_field="finishdate">
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
                    <td><cf_wrk_search_button search_function="control_search_depo()"></td>
                    <td><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=retail.popup_select_rival_products&type=10&op_f_name=add_row</cfoutput>','list');"><img src="/images/plus.gif" /></a></td>
               </tr>
            </table>
            <br />
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
        </cf_big_list_search_area>
    </cfform>
    </cf_big_list_search>
<!-- sil -->
<table style="float:left; margin-left:10px;">
	<tr>
    <td>
<!-- sil -->
    <cf_big_list> 
    <thead>             
        <tr>
            <th>Tarih</th>
            <!-- sil --><th>Talep Edilen</th><!-- sil -->
            <!-- sil --><th style="text-align:right; width:50px;">Tale Edilen M. Stok</th><!-- sil -->
            <th>Talep Eden</th>
            <!-- sil --><th style="text-align:right; width:50px;">Talep Eden M. Stok</th><!-- sil -->
            <th>Barkod</th>
            <th>Stok</th>
            <!-- sil --><th>No</th><!-- sil -->
            <!-- sil --><th>Kod</th><!-- sil -->
            <th style="text-align:right;">Miktar</th>
            <th style="text-align:right;">Karşılanan</th>
        </tr>
    </thead>
    <tbody>
    <cfset day_in_total = 0>
    <cfset day_k_total = 0>
    
    <cfset g_in_total = 0>
    <cfset g_k_total = 0>
    <cfif get_dagilim.recordcount>
        <cfoutput query="get_dagilim">
        <tr>
            <td><cfif currentrow eq 1 or dateformat(deliver_date,'dd/mm/yyyy') is not dateformat(deliver_date[currentrow-1],'dd/mm/yyyy')>#dateformat(deliver_date,'dd/mm/yyyy')#</cfif></td>
            <!-- sil --><td nowrap="nowrap">#DEPT_OUT#</td><!-- sil -->
            <!-- sil --><td style="text-align:right;">#OUT_STOCK#</td><!-- sil -->
            <td nowrap="nowrap">#DEPT_IN#</td>
            <!-- sil --><td style="text-align:right;">#IN_STOCK#</td><!-- sil -->
            <td>#BARCOD#</td>
            <td nowrap="nowrap">#STOK_ADI#</td>
            <!-- sil --><td><a href="#request.self#?fuseaction=stock.upd_dispatch_internaldemand&ship_id=#DISPATCH_SHIP_ID#" target="s_window" class="tableyazi">#DISPATCH_SHIP_ID#</a></td><!-- sil -->
            <!-- sil --><td>#code#</td><!-- sil -->
            <td style="text-align:right;">#MIKTAR#</td>
            <td style="text-align:right;">#KARSILANAN#</td>
            <td style="text-align:right;">#KALAN#</td>
        </tr>
        <cfset day_in_total = day_in_total + MIKTAR>
		<cfset day_k_total = day_k_total + KARSILANAN>
        
        <cfset g_in_total = g_in_total + MIKTAR>
		<cfset g_k_total = g_k_total + KARSILANAN>
        <cfif currentrow eq get_dagilim.recordcount or dateformat(deliver_date,'dd/mm/yyyy') is not dateformat(deliver_date[currentrow+1],'dd/mm/yyyy')>
        <tr>
            <td colspan="<cfif fusebox.fuseaction contains 'excel'>4<cfelse>9</cfif>" class="formbold" style="background-color:##F96;">#dateformat(deliver_date,'dd/mm/yyyy')# Toplam</td>
            <td style="background-color:##F96;text-align:right;" class="formbold">#day_in_total#</td>
            <td style="background-color:##F96;text-align:right;" class="formbold">#day_k_total#</td>
        </tr> 
        <cfset day_in_total = 0>
		<cfset day_k_total = 0>     
        </cfif>
        </cfoutput>
    </cfif>
    </tbody>
    <cfoutput>
    <tfoot>
    	<tr>
            <td colspan="<cfif fusebox.fuseaction contains 'excel'>4<cfelse>9</cfif>" class="formbold">Genel Toplam</td>
            <td style="text-align:right;" class="formbold">#g_in_total#</td>
            <td style="text-align:right;" class="formbold">#g_k_total#</td>
        </tr> 
    </tfoot>
    </cfoutput>
    </cf_big_list>
<!-- sil -->
    </td>
    </tr>
</table>
<!-- sil -->