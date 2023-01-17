<cfparam name="attributes.hierarchy1" default="">
<cfparam name="attributes.hierarchy2" default="">
<cfparam name="attributes.hierarchy3" default="">
<cfparam name="attributes.search_department_id" default="">

<cfquery name="get_departments_search" datasource="#dsn#">
	SELECT 
    	DEPARTMENT_ID,DEPARTMENT_HEAD 
    FROM 
    	DEPARTMENT D
    WHERE
    	D.IS_STORE IN (1,3) AND
        ISNULL(D.IS_PRODUCTION,0) = 0 AND
        BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
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

<cfsavecontent  variable="head"><cf_get_lang dictionary_id='61871.Depo Sıfır Stok Raporu'></cfsavecontent>
<cf_report_list_search title="#head#">
    <cf_report_list_search_area>
        <cfform action="#request.self#?fuseaction=retail.depo_all_stock_report2" method="post" name="search_depo">
            <input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
            <div class="row">
                <div class="col col-12 col-xs-12">
                    <div class="row formContent">
                        <div class="row" type="row">
                            <div class="col col-4 col-md-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                                    <div class="col col-12 col-xs-12">
                                        <select name="search_department_id" id="search_department_id">
                                            <cfloop query="get_departments_search">
                                                <cfoutput>
                                                <option value="#department_id#" <cfif get_departments_search.department_id eq attributes.search_department_id> selected </cfif>>#department_head#</option>
                                                </cfoutput>
                                            </cfloop>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='61641.Ana Grup'></label>
                                    <div class="col col-12 col-xs-12col col-12">
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

<!--- 
<cfquery name="urun_list" datasource="#DSN2#">
	SELECT
		S.STOCK_ID,
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
        S.PRODUCT_CATID = PC.PRODUCT_CATID AND
        PC.PRODUCT_CATID IN (#p_cat_list#)
</cfquery>
--->

<cfquery name="get_internaldemand" datasource="#DSN2#">
SELECT
	*
FROM
	(
	SELECT
        ISNULL((SELECT SUM(GSLL.REAL_STOCK) FROM GET_STOCK_LAST_LOCATION GSLL WHERE GSLL.STOCK_ID = S.STOCK_ID AND GSLL.DEPARTMENT_ID IN (#attributes.search_department_id#)),0) AS TOPLAM_STOCK,
        ISNULL((SELECT SUM(GSLL.REAL_STOCK) FROM GET_STOCK_LAST_LOCATION GSLL WHERE GSLL.STOCK_ID = S.STOCK_ID AND GSLL.DEPARTMENT_ID IN (#merkez_depo_id#)),0) AS MERKEZ_DEPO,
		<cfif listlen(attributes.search_department_id)>
    		<cfloop list="#attributes.search_department_id#" index="dd">
        		ISNULL((SELECT SUM(GSLL.REAL_STOCK) FROM GET_STOCK_LAST_LOCATION GSLL WHERE GSLL.STOCK_ID = S.STOCK_ID AND GSLL.DEPARTMENT_ID = #dd#),0) AS MAGAZA_STOCK_#dd#,
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
        S.PRODUCT_CATID = PC.PRODUCT_CATID AND
        PC.PRODUCT_CATID IN (#p_cat_list#)
    ) T1
WHERE
	TOPLAM_STOCK < 1 AND MERKEZ_DEPO > 0
    ORDER BY
     T1.STOCK_CODE ASC,
     T1.PRODUCT_NAME ASC
</cfquery>
<cfquery name="get_sum_merkez" dbtype="query">
	SELECT SUM(MERKEZ_DEPO) AS MERKEZ FROM get_internaldemand
</cfquery>
<cfif listlen(attributes.search_department_id)>
    <cfquery name="get_list_departments" dbtype="query">
        SELECT * FROM get_departments_search WHERE DEPARTMENT_ID IN (#attributes.search_department_id#) ORDER BY DEPARTMENT_HEAD
    </cfquery>
</cfif>


<cfset genel_toplam = 0> 
<cfif listlen(attributes.search_department_id)>
	<cfloop query="get_list_departments">
		<cfset 'general_dept_total_#get_list_departments.DEPARTMENT_ID#' = 0>
	</cfloop>
</cfif>


<cfoutput query="get_internaldemand">
<cfset row_total_ = 0>
<cfif listlen(attributes.search_department_id)>
	<cfloop query="get_list_departments">
    	<cfset row_total_ = row_total_ + evaluate("get_internaldemand.MAGAZA_STOCK_#get_list_departments.DEPARTMENT_ID#")>
		<cfset 'general_dept_total_#get_list_departments.DEPARTMENT_ID#' = evaluate('general_dept_total_#get_list_departments.DEPARTMENT_ID#') + evaluate("get_internaldemand.MAGAZA_STOCK_#get_list_departments.DEPARTMENT_ID#")>
    </cfloop>
</cfif>
<cfset genel_toplam = genel_toplam + row_total_>
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
                        <th><cf_get_lang dictionary_id='50882.Merkez Depo'></th>
                        <cfif listlen(attributes.search_department_id)>
                            <cfoutput query="get_list_departments"><th style="text-align:right;">#DEPARTMENT_HEAD#</th></cfoutput>
                        </cfif>
                        <!--- <th style="text-align:right;">Toplam Stok</th> --->
                    </tr>
                </thead>
                <tbody>
                    <cfoutput>
                    <tr>
                        <td colspan="5" class="form-title"><cf_get_lang dictionary_id='40035.Genel Toplamlar'></td>
                        <td style="text-align:right;">#tlformat(get_sum_merkez.MERKEZ)#</td>
                        <cfif listlen(attributes.search_department_id)>
                            <cfloop query="get_list_departments">
                                <td style="text-align:right;">#tlformat(evaluate('general_dept_total_#get_list_departments.DEPARTMENT_ID#'))#</td>
                            </cfloop>
                        </cfif>
                        <!--- <td style="text-align:right;background-color:##6CC;">#TLFORMAT(genel_toplam)#</td> --->
                    </tr>
                    </cfoutput>
        
                    <cfset ucuncu_toplam = 0> 
                    <cfif listlen(attributes.search_department_id)>
                        <cfloop query="get_list_departments">
                            <cfset 'dept_total_#get_list_departments.DEPARTMENT_ID#' = 0>
                        </cfloop>
                    </cfif>
                      
                    <cfset last_birinci_ = "">
                    <cfset last_ikinci_ = "">
                    <cfset last_ucuncu_ = "">
                    <cfset ucuncu_toplam = 0>
                    <cfif listlen(attributes.search_department_id)>
                        <cfloop query="get_list_departments">
                            <cfset 'dept_total_#get_list_departments.DEPARTMENT_ID#' = 0>
                        </cfloop>
                    </cfif>
                    <cfset merkez_total = 0>
                    <cfoutput query="get_internaldemand">
                        <cfset birinci_ = listfirst(stock_code,'.')>
                        <cfset ikinci_ = birinci_ & '.' & listgetat(stock_code,2,'.')>
                        <cfset ucuncu_ = ikinci_ & '.' & listgetat(stock_code,3,'.')>
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
                            <td style="text-align:right;">#MERKEZ_DEPO#
                            <cfset merkez_total = merkez_total+evaluate(#merkez_depo#)>
                            </td>
                            <cfset row_total_ = 0>
                            <cfif listlen(attributes.search_department_id)>
                                <cfloop query="get_list_departments">
                                    <td style="text-align:right;">#TLFORMAT(evaluate("get_internaldemand.MAGAZA_STOCK_#get_list_departments.DEPARTMENT_ID#"))#</td>
                                    <cfset row_total_ = row_total_ + evaluate("get_internaldemand.MAGAZA_STOCK_#get_list_departments.DEPARTMENT_ID#")>
                                    <cfset 'dept_total_#get_list_departments.DEPARTMENT_ID#' = evaluate('dept_total_#get_list_departments.DEPARTMENT_ID#') + evaluate("get_internaldemand.MAGAZA_STOCK_#get_list_departments.DEPARTMENT_ID#")>                        
                                </cfloop>
                            </cfif>
                            <!--- <td style="text-align:right;">#TLFORMAT(row_total_)#</td> --->
                        </tr>
                        <cfset ucuncu_toplam = ucuncu_toplam + row_total_>   
        
                        <cfset last_birinci_ = birinci_>
                        <cfset last_ikinci_ = ikinci_>
                        <cfset last_ucuncu_ = ucuncu_>
                        <cfif currentrow eq get_internaldemand.recordcount or not get_internaldemand.stock_code[currentrow + 1] contains ucuncu_>
                            <tr>
                                <td colspan="5" class="form-title"><cf_get_lang dictionary_id='53263.Toplamlar'></td>
                                <td style="text-align:right;">#merkez_total# <cfset merkez_total =0> </td>
                                <cfif listlen(attributes.search_department_id)>
                                    <cfloop query="get_list_departments">
                                        <td style="text-align:right;">#tlformat(evaluate('dept_total_#get_list_departments.DEPARTMENT_ID#'))#</td>
                                    </cfloop>
                                </cfif>
                                <!--- <td style="text-align:right;background-color:##6CC;">#TLFORMAT(ucuncu_toplam)#</td> --->
                            </tr>
                            <cfset ucuncu_toplam = 0> 
                            <cfif listlen(attributes.search_department_id)>
                                <cfloop query="get_list_departments">
                                    <cfset 'dept_total_#get_list_departments.DEPARTMENT_ID#' = 0>
                                </cfloop>
                            </cfif>         
                        </cfif>
                    </cfoutput>
                </tbody>
            </cf_grid_list>
        </cf_box>
    </div>
</cfif>