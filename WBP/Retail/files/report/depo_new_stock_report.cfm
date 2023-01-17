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
<link href="/css/assets/template/report/report.css" rel="stylesheet"> 

<cfsavecontent  variable="head"><cf_get_lang dictionary_id='61475.Depo Tüm Stok Raporu'></cfsavecontent>
<cf_report_list_search title="#head#">
    <cf_report_list_search_area>
        <cfform action="#request.self#?fuseaction=retail.depo_new_stock_report" method="post" name="search_depo">
            <input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
            <div class="row">
                <div class="col col-12 col-xs-12">
                    <div class="row formContent">
                        <div class="row" type="row">
                            <div class="col col-3 col-md-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57460.Filtre'></label>
                                    <div class="col col-9 col-xs-12">
                                        <cfinput type="text" name="keyword" id="keyword" style="width:90px;" value="#attributes.keyword#" maxlength="500">
                                    </div>
                                </div>	
                                <div class="form-group">
                                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                                    <div class="col col-9 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                                            <cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                                        </div>
                                    </div>
                                </div>	
                                <div class="form-group">
                                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='38737.Stok Durumu'></label>
                                    <div class="col col-9 col-xs-12">
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
                                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                                    <div class="col col-9 col-xs-12">
                                        <cf_multiselect_check 
                                        query_name="get_departments_search"  
                                        name="search_department_id"
                                        option_text="#getLang('','Departman',57572)#" 
                                        width="180"
                                        option_name="department_head" 
                                        option_value="department_id"
                                        value="#attributes.search_department_id#">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58202.Üretici'></label>
                                    <div class="col col-9 col-xs-12">
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
                                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='61641.Ana Grup'></label>
                                    <div class="col col-9 col-xs-12">
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
                                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='61642.Alt Grup'> 1</label>
                                    <div class="col col-9 col-xs-12">
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
                                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='61642.Alt Grup'> 2</label>
                                    <div class="col col-9 col-xs-12">
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
		alert('<cf_get_lang dictionary_id='55104.Departman Seçiniz'>!');
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



<cfset en_genel_toplam = en_genel_toplam + TOPLAM_STOCK> 

</cfoutput>
<!-- sil -->
    <!---<table cellpadding="2" cellspacing="1" width="99%" align="center" class="color-border">--->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cf_grid_list>
            <thead>
                <tr class="color-black">
                    <th ><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th ><cf_get_lang dictionary_id='61641.Ana Grup'></th>
                    <th ><cf_get_lang dictionary_id='61642.Alt Grup'> 1</th>
                    <th ><cf_get_lang dictionary_id='61642.Alt Grup'> 2</th>
                    <th ><cf_get_lang dictionary_id='57452.Stok'> ID</th>
                    <th ><cf_get_lang dictionary_id='57633.Barkod'></th>
                    <th ><cf_get_lang dictionary_id='57657.Ürün'></th>
                    <th ><cf_get_lang dictionary_id='57756.Durum'></th>
                
                    <cfif listlen(attributes.search_department_id)>
                        <cfoutput query="get_list_departments"><th style="text-align:right;" class="form-title">#DEPARTMENT_HEAD#</th></cfoutput>
                    </cfif>
                    <th style="text-align:right;" class="form-title">D. <cf_get_lang dictionary_id='29512.Toplam Stok'></th>
                </tr>
            </thead>
            <tbody>
                
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
                        <td>#stock_id#</td>
                        <td>#BARCOD#</td>
                        <td><cfif len(PROPERTY)>#PROPERTY#<cfelse>#product_name#</cfif></td>
                        <td><cfif stock_status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
           
                        <cfset row_total_ = 0>
                        <cfif listlen(attributes.search_department_id)>
                            <cfloop query="get_list_departments">
                                <td style="text-align:right;">#TLFORMAT(evaluate("get_internaldemand.MAGAZA_STOCK_#GET_LIST_DEPARTMENTS.DEPARTMENT_ID#"))#</td>
                                <cfset row_total_ = row_total_ + evaluate("get_internaldemand.MAGAZA_STOCK_#GET_LIST_DEPARTMENTS.DEPARTMENT_ID#")>
                                <cfset 'dept_total_#GET_LIST_DEPARTMENTS.DEPARTMENT_ID#' = evaluate('dept_total_#GET_LIST_DEPARTMENTS.DEPARTMENT_ID#') + evaluate("get_internaldemand.MAGAZA_STOCK_#GET_LIST_DEPARTMENTS.DEPARTMENT_ID#")>                        
                            </cfloop>
                        </cfif>
                        <td style="text-align:right;">#TLFORMAT(row_total_)#</td>
                  
                    </tr>
                    <cfset ucuncu_en_toplam = ucuncu_en_toplam + TOPLAM_STOCK>
                   
    
                    <cfset last_birinci_ = birinci_>
                    <cfset last_ikinci_ = ikinci_>
                    <cfset last_ucuncu_ = ucuncu_>
                    <cfif currentrow eq get_internaldemand.recordcount or not get_internaldemand.stock_code[currentrow + 1] contains ucuncu_>
                    
                        <cfset ucuncu_toplam = 0> 
                        <cfif listlen(attributes.search_department_id)>
                            <cfloop query="get_list_departments">
                                <cfset 'dept_total_#GET_LIST_DEPARTMENTS.DEPARTMENT_ID#' = 0>
                            </cfloop>
                        </cfif>         
                    </cfif>
                </cfoutput>
            </tbody>
            <tfoot>
                <cfoutput>
                    <tr class="color-row">
                        <td colspan="<cfif isdefined("attributes.stock_info")>15<cfelse>8</cfif>"  class="form-title"><cf_get_lang dictionary_id='40035.Genel Toplamlar'></td>
                        <cfif listlen(attributes.search_department_id)>
                            <cfloop query="get_list_departments">
                                <td style="text-align:right; ">#tlformat(evaluate('general_dept_total_#GET_LIST_DEPARTMENTS.DEPARTMENT_ID#'))#</td>
                            </cfloop>
                        </cfif>
                        <td style="text-align:right; ">#TLFORMAT(genel_toplam)#</td>
                        <cfif isdefined("attributes.stock_info")>
                            <td style="text-align:right;">#TLFORMAT(en_genel_toplam)#</td>
                            <td style="text-align:right;">#TLFORMAT(genel_toplam_stock_al)#</td>
                            <td style="text-align:right;">#TLFORMAT(genel_toplam_stock_al_kdv)#</td>
                            <td style="text-align:right;">#TLFORMAT(genel_toplam_stock_sat)#</td>
                            <td style="text-align:right;">#TLFORMAT(genel_toplam_stock_sat_kdv)#</td>
                        </cfif>
                    </tr>
                </cfoutput>
            </tfoot>
        </cf_grid_list>
    </cf_box>
</div>
    	
   
<!-- sil -->
</cfif>
