<cfparam name="attributes.hierarchy1" default="">
<cfparam name="attributes.hierarchy2" default="">
<cfparam name="attributes.hierarchy3" default="">
<cfparam name="attributes.search_department_id" default="#merkez_depo_id#">
<cfparam name="attributes.finishdate" default="#now()#">
<cfparam name="attributes.startdate" default="#date_add('d',-1,attributes.finishdate)#">

<cfif isdefined("attributes.is_form_submitted")>
	<cfif isdate(attributes.startdate)><cf_date tarih = "attributes.startdate"></cfif>
	<cfif isdate(attributes.finishdate)><cf_date tarih = "attributes.finishdate"></cfif>
</cfif>
<cfif isdate(attributes.startdate)>
	<cfset attributes.startdate = dateformat(attributes.startdate, "dd/mm/yyyy")>
</cfif>
<cfif isdate(attributes.finishdate)>
	<cfset attributes.finishdate = dateformat(attributes.finishdate, "dd/mm/yyyy")>
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

<cfsavecontent  variable="head"><cf_get_lang dictionary_id='61475.Depo Tüm Stok Raporu'></cfsavecontent>
<cf_report_list_search title="#head#">
    <cf_report_list_search_area>
        <cfform action="#request.self#?fuseaction=retail.depo_all_stock_report4" method="post" name="search_depo">
            <input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
            <div class="row">
                <div class="col col-12 col-xs-12">
                    <div class="row formContent">
                        <div class="row" type="row">
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
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                                    <div class="col col-12 col-xs-12">
                                        <cf_multiselect_check 
                                        query_name="get_departments_search"  
                                        name="search_department_id"
                                        option_text="Departman" 
                                        width="180"
                                        option_name="department_head" 
                                        option_value="department_id"
                                        value="#attributes.search_department_id#">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
                                            <cfinput type="text" name="startdate" style="width:65px;" value="#attributes.startdate#" validate="eurodate" message="#message#" maxlength="10" required="yes">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
                                            <cfinput type="text" name="finishdate" style="width:65px;" value="#attributes.finishdate#" validate="eurodate" message="#message#" maxlength="10" required="yes">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
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
<cfif isdate(attributes.startdate)><cf_date tarih = "attributes.startdate"></cfif>
	<cfif isdate(attributes.finishdate)><cf_date tarih = "attributes.finishdate"></cfif>
<cfquery name="get_internaldemand" datasource="#DSN2#">
SELECT
	*
FROM
	(
	SELECT
        ISNULL((SELECT SUM(GSLL.REAL_STOCK) FROM GET_STOCK_LAST_LOCATION GSLL WHERE GSLL.STOCK_ID = S.STOCK_ID AND GSLL.DEPARTMENT_ID IN (#attributes.search_department_id#)),0) AS TOPLAM_STOCK,
		<cfif listlen(attributes.search_department_id)>
    		<cfloop list="#attributes.search_department_id#" index="dd">
        		ISNULL((SELECT SUM(GSLL.REAL_STOCK) FROM GET_STOCK_LAST_LOCATION GSLL WHERE GSLL.STOCK_ID = S.STOCK_ID AND GSLL.DEPARTMENT_ID = #dd#),0) AS MAGAZA_STOCK_#dd#,
            </cfloop>
            
            <cfloop list="#attributes.search_department_id#" index="dd">
        		ISNULL((
                	SELECT
                    SUM(T2.BIRIMIK)
                    FROM
                    (                
                	SELECT PA.BIRIMIK  FROM #dsn_dev#.PRODUCT_ACTIONS AS PA WHERE PA.STOCK_ID = S.STOCK_ID AND PA.DEPARTMENT_ID = #dd# AND PA.HAREKET_TIP_KOD IN(33,55,57) AND TARIH BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
                UNION ALL
                
     				SELECT 
                    	CASE WHEN SR.STOCK_IN > 0 THEN SR.STOCK_IN ELSE SR.STOCK_OUT END BIRIMIK
                    FROM
                        STOCKS_ROW AS SR
                    WHERE
                        SR.PROCESS_DATE IS NOT NULL AND SR.STOCK_ID = S.STOCK_ID AND SR.STORE = #dd# AND SR.PROCESS_TYPE IN (67) AND
                        PROCESS_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
                	) T2
                    ),0) AS MAGAZA_SATIS_#dd#,
            </cfloop>
        </cfif>
        
        S.STOCK_CODE,
        S.PRODUCT_NAME,
        S.PROPERTY,
        S.STOCK_ID
	FROM 
        #dsn3_alias#.STOCKS S,
        #dsn1_alias#.PRODUCT_CAT PC
	WHERE	
		S.PRODUCT_STATUS = 1 AND
        S.STOCK_STATUS = 1 AND
        S.PRODUCT_CATID = PC.PRODUCT_CATID 
        <cfif len(p_cat_list)>
           AND PC.PRODUCT_CATID IN (#p_cat_list#)
        </cfif>
    ) T1

ORDER BY
     T1.STOCK_CODE ASC,
     T1.PRODUCT_NAME ASC
</cfquery> 

<cfif listlen(attributes.search_department_id)>
    <cfquery name="get_list_departments" dbtype="query">
        SELECT * FROM get_departments_search WHERE DEPARTMENT_ID IN (#attributes.search_department_id#) ORDER BY DEPARTMENT_HEAD
    </cfquery>
</cfif>


<cfset genel_toplam = 0> 
<cfset genel_toplam_sat = 0> 
<cfif listlen(attributes.search_department_id)>
	<cfloop query="get_list_departments">
		<cfset 'general_dept_total_#get_list_departments.DEPARTMENT_ID#' = 0>
        <cfset 'general_dept_total_sat#get_list_departments.DEPARTMENT_ID#' = 0>
	</cfloop>
</cfif>


<cfoutput query="get_internaldemand">
<cfset row_total_ = 0>
<cfset row_total_sat = 0>
<cfif listlen(attributes.search_department_id)>
	<cfloop query="get_list_departments">
    	<cfset row_total_ = row_total_ + evaluate("get_internaldemand.MAGAZA_STOCK_#get_list_departments.DEPARTMENT_ID#")>
        <cfset row_total_sat = row_total_sat + evaluate("get_internaldemand.MAGAZA_SATIS_#get_list_departments.DEPARTMENT_ID#")>
		<cfset 'general_dept_total_#get_list_departments.DEPARTMENT_ID#' = evaluate('general_dept_total_#get_list_departments.DEPARTMENT_ID#') + evaluate("get_internaldemand.MAGAZA_STOCK_#get_list_departments.DEPARTMENT_ID#")>
        <cfset 'general_dept_total_sat#get_list_departments.DEPARTMENT_ID#' = evaluate('general_dept_total_sat#get_list_departments.DEPARTMENT_ID#') + evaluate("get_internaldemand.MAGAZA_SATIS_#get_list_departments.DEPARTMENT_ID#")>
    </cfloop>
</cfif>
<cfset genel_toplam = genel_toplam + row_total_>
<cfset genel_toplam_sat = genel_toplam_sat + row_total_sat>
</cfoutput>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='61641.Ana Grup'></th>
                    <th><cf_get_lang dictionary_id='61642.Alt Grup'> 1</th>
                    <th><cf_get_lang dictionary_id='61642.Alt Grup'> 2</th>
                    <th><cf_get_lang dictionary_id='57657.Ürün'></th>
                    <cfif listlen(attributes.search_department_id)>
                        <cfoutput query="get_list_departments"><th style="text-align:right;" colspan="2">#DEPARTMENT_HEAD#</th></cfoutput>
                    </cfif>
                    <th style="text-align:right;" colspan="2"><cf_get_lang dictionary_id='50141.Toplamlar'></th>
                </tr>
            </thead>
                    <thead>
                <tr>
                    <th colspan="5">&nbsp;</th>
                    
                    <cfif listlen(attributes.search_department_id)>
                        <cfoutput query="get_list_departments"><th style="text-align:right;"><cf_get_lang dictionary_id='57452.Stok'></th><th style="text-align:right;"><cf_get_lang dictionary_id='57448.Satış'></th></cfoutput>
                    </cfif>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='29512.Toplam Stok'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='37285.Toplam Satış'></th>
                </tr>
            </thead>
            <tbody>
                <cfoutput>
                <tr>
                    <td colspan="5" style=" " class="form-title"><cf_get_lang dictionary_id='40035.Genel Toplamlar'></td>
                    <cfif listlen(attributes.search_department_id)>
                        <cfloop query="get_list_departments">
                            <td style="text-align:right; ">#tlformat(evaluate('general_dept_total_#get_list_departments.DEPARTMENT_ID#'))#</td>
                            <td style="text-align:right; ">#tlformat(evaluate('general_dept_total_sat#get_list_departments.DEPARTMENT_ID#'))#</td>
                        </cfloop>
                    </cfif>
                    <td style="text-align:right; ">#TLFORMAT(genel_toplam)#</td>
                    <td style="text-align:right; ">#TLFORMAT(genel_toplam_sat)#</td>
                </tr>
                </cfoutput>
                
                <cfset ucuncu_toplam = 0> 
                <cfset ucuncu_toplam_sat = 0> 
                <cfif listlen(attributes.search_department_id)>
                    <cfloop query="get_list_departments">
                        <cfset 'dept_total_#get_list_departments.DEPARTMENT_ID#' = 0>
                        <cfset 'dept_total_sat#get_list_departments.DEPARTMENT_ID#' = 0>
                    </cfloop>
                </cfif>
                
                <cfset last_birinci_ = "">
                <cfset last_ikinci_ = "">
                <cfset last_ucuncu_ = "">
                <cfset ucuncu_toplam = 0>
                <cfset ucuncu_toplam_sat = 0>
                <cfif listlen(attributes.search_department_id)>
                    <cfloop query="get_list_departments">
                        <cfset 'dept_total_#get_list_departments.DEPARTMENT_ID#' = 0>
                        <cfset 'dept_total_sat#get_list_departments.DEPARTMENT_ID#' = 0>
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
                    <tr>
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
                        <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=retail.popup_product_stocks&stock_id=#stock_id#','page_display');" class="tableyazi">#PROPERTY#</a></td>
                        <cfset row_total_ = 0>
                        <cfset row_total_sat = 0>
                        <cfif listlen(attributes.search_department_id)>
                            <cfloop query="get_list_departments">
                                <td style="text-align:right;">#TLFORMAT(evaluate("get_internaldemand.MAGAZA_STOCK_#get_list_departments.DEPARTMENT_ID#"))#</td>
                                <td style="text-align:right;">#TLFORMAT(evaluate("get_internaldemand.MAGAZA_SATIS_#get_list_departments.DEPARTMENT_ID#"))#</td>
                                <cfset row_total_ = row_total_ + evaluate("get_internaldemand.MAGAZA_STOCK_#get_list_departments.DEPARTMENT_ID#")>
                                <cfset row_total_sat = row_total_sat + evaluate("get_internaldemand.MAGAZA_SATIS_#get_list_departments.DEPARTMENT_ID#")>
                                <cfset 'dept_total_#get_list_departments.DEPARTMENT_ID#' = evaluate('dept_total_#get_list_departments.DEPARTMENT_ID#') + evaluate("get_internaldemand.MAGAZA_STOCK_#get_list_departments.DEPARTMENT_ID#")>     
                                <cfset 'dept_total_sat#get_list_departments.DEPARTMENT_ID#' = evaluate('dept_total_sat#get_list_departments.DEPARTMENT_ID#') + evaluate("get_internaldemand.MAGAZA_SATIS_#get_list_departments.DEPARTMENT_ID#")>                       
                            </cfloop>
                        </cfif>
                        <td style="text-align:right;">#TLFORMAT(row_total_)#</td>
                        <td style="text-align:right;">#TLFORMAT(row_total_sat)#</td>
                    </tr>
                    <cfset ucuncu_toplam = ucuncu_toplam + row_total_>  
                    <cfset ucuncu_toplam_sat = ucuncu_toplam_sat + row_total_sat> 

                    <cfset last_birinci_ = birinci_>
                    <cfset last_ikinci_ = ikinci_>
                    <cfset last_ucuncu_ = ucuncu_>
                    <cfif currentrow eq get_internaldemand.recordcount or not get_internaldemand.stock_code[currentrow + 1] contains ucuncu_>
                        <tr>
                            <td colspan="5" style=" " class="form-title">Toplamlar</td>
                            <cfif listlen(attributes.search_department_id)>
                                <cfloop query="get_list_departments">
                                    <td style="text-align:right; ">#tlformat(evaluate('dept_total_#get_list_departments.DEPARTMENT_ID#'))#</td>
                                    <td style="text-align:right; ">#tlformat(evaluate('dept_total_sat#get_list_departments.DEPARTMENT_ID#'))#</td>
                                </cfloop>
                            </cfif>
                            <td style="text-align:right; ">#TLFORMAT(ucuncu_toplam)#</td>
                            <td style="text-align:right; ">#TLFORMAT(ucuncu_toplam_sat)#</td>
                        </tr>
                        <cfset ucuncu_toplam = 0> 
                        <cfset ucuncu_toplam_sat = 0>
                        <cfif listlen(attributes.search_department_id)>
                            <cfloop query="get_list_departments">
                                <cfset 'dept_total_#get_list_departments.DEPARTMENT_ID#' = 0>
                                <cfset 'dept_total_sat#get_list_departments.DEPARTMENT_ID#' = 0>
                            </cfloop>
                        </cfif>         
                    </cfif>
                </cfoutput>
            </tbody>
        </cf_grid_list>
    </cf_box>
</div>
</cfif>
