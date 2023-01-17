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
        PRODUCT_CAT,
        PRODUCT_CAT_OUR_COMPANY PCO
    WHERE 
        PRODUCT_CAT.PRODUCT_CATID = PCO.PRODUCT_CATID AND
        PCO.OUR_COMPANY_ID = #session.ep.company_id# 
    ORDER BY 
        HIERARCHY ASC
</cfquery>

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
<cf_report_list_search title="#getLang('','Stok Kontrol Raporu Ana Grup',61874)#">
    <cf_report_list_search_area>
        <cfform action="#request.self#?fuseaction=retail.depo_stock_report_upper" method="post" name="search_depo">
            <input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
            <div class="row">
                <div class="col col-12 col-xs-12">
                    <div class="row formContent">
                        <div class="row" type="row">	
                            <div class="col col-3 col-md-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                                    <div class="col col-12 col-xs-12">
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
                        </div>
                    </div>
                    <div class="row ReportContentBorder">
                        <div class="ReportContentFooter">
                            <cf_wrk_search_button button_type="1">
                        </div>
                    </div>
                </div>
            </div>
        </cfform>
	</cf_report_list_search_area>
</cf_report_list_search>

<cfif isdefined("attributes.is_form_submitted")>

<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>

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

    <cfquery name="get_stocks_status_all" datasource="#dsn3#" result="aaa">
    	SELECT
        	ISNULL((SELECT SUM(PRODUCT_STOCK) FROM #DSN2_ALIAS#.GET_STOCK_PRODUCT WHERE S.STOCK_ID = GET_STOCK_PRODUCT.STOCK_ID <cfif len(attributes.search_department_id)>AND GET_STOCK_PRODUCT.DEPARTMENT_ID IN (#attributes.search_department_id#)</cfif>),0) AS URUN_STOCK,
            PC.PRODUCT_CAT,
            PC.PRODUCT_CATID,
            SUBSTRING(PC.HIERARCHY,0,charindex('.',PC.HIERARCHY)) AS ANA_HIERARCHY,
            P.PRODUCT_ID,
            P.PRODUCT_NAME,
            ISNULL(( 
                SELECT TOP 1 
                    PT1.NEW_PRICE_KDV
                FROM
                    #DSN_DEV#.PRICE_TABLE PT1
                WHERE
                    PT1.IS_ACTIVE_S = 1 AND
                    (
                    	PT1.STARTDATE <= #bugun_# AND 
                        DATEADD("d",-1,PT1.FINISHDATE) >= #bugun_#
                    ) AND
                    (
                    	PT1.STOCK_ID = S.STOCK_ID OR 
                        (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID)
                    )
                ORDER BY
                	PT1.STARTDATE DESC,
					PT1.ROW_ID DESC
            ),PS_SATIS.PRICE_KDV) AS PRICE_SATIS_KDV,
            ISNULL(( 
                SELECT TOP 1 
                    PT1.NEW_ALIS_KDV
                FROM
                    #DSN_DEV#.PRICE_TABLE PT1
                WHERE
                    PT1.IS_ACTIVE_P = 1 AND
                    (PT1.P_STARTDATE <= #bugun_# AND DATEADD("d",-1,PT1.P_FINISHDATE) >= #bugun_#) AND
                    (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID))
                ORDER BY
                	PT1.STARTDATE DESC,
					PT1.ROW_ID DESC
            ),PS_ALIS.PRICE_KDV) AS PRICE_ALIS_KDV
        FROM
            STOCKS S,
            #dsn1_alias#.PRODUCT P,
            #dsn1_alias#.PRODUCT_CAT PC,
			PRICE_STANDART PS_ALIS,
			PRICE_STANDART PS_SATIS,
            PRODUCT_UNIT PU
       	WHERE
            PU.PRODUCT_ID = P.PRODUCT_ID AND
            PS_ALIS.PRODUCT_ID = P.PRODUCT_ID AND
            PS_SATIS.PRODUCT_ID = P.PRODUCT_ID AND
            PU.IS_MAIN = 1 AND
            PU.PRODUCT_UNIT_ID = PS_ALIS.UNIT_ID AND
            PU.PRODUCT_UNIT_ID = PS_SATIS.UNIT_ID AND
            P.IS_SALES = 1 AND
            P.PRODUCT_STATUS = 1 AND
            S.STOCK_STATUS = 1 AND		
            PS_ALIS.PURCHASESALES = 0 AND
            PS_ALIS.PRICESTANDART_STATUS = 1 AND
            PS_SATIS.PURCHASESALES = 1 AND
            PS_SATIS.PRICESTANDART_STATUS = 1 AND
            S.PRODUCT_ID = P.PRODUCT_ID AND  
            
            P.PRODUCT_CATID = PC.PRODUCT_CATID 
                <cfif len(p_cat_list)>
                    AND PC.PRODUCT_CATID IN (#p_cat_list#)
                </cfif>
    </cfquery>
    
    <cfquery name="get_stocks_status" dbtype="query">
    	SELECT
        	SUM(URUN_STOCK) AS URUN_STOCK,
            PRODUCT_CAT,
            PRODUCT_CATID,
            ANA_HIERARCHY,
            PRICE_ALIS_KDV,
            PRICE_SATIS_KDV,
            PRODUCT_ID,
            PRODUCT_NAME
        FROM
        	get_stocks_status_all
        GROUP BY
        	PRODUCT_CAT,
            PRODUCT_CATID,
            ANA_HIERARCHY,
            PRICE_ALIS_KDV,
            PRICE_SATIS_KDV,
            PRODUCT_ID,
            PRODUCT_NAME     	
    </cfquery>
    
    <cfquery name="get_cat_status" dbtype="query">
    	SELECT
        	ANA_HIERARCHY,
            SUM(URUN_STOCK) AS TOPLAM_STOCK,
            SUM(PRICE_ALIS_KDV) / COUNT(PRODUCT_ID) AS ALIS_ORTALAMA,
            SUM(PRICE_SATIS_KDV) / COUNT(PRODUCT_ID) AS SATIS_ORTALAMA,
            COUNT(PRODUCT_ID) AS URUN_SAYISI,
            SUM(URUN_STOCK * PRICE_ALIS_KDV) AS TOTAL_RAKAM
        FROM
        	get_stocks_status
        WHERE
        	URUN_STOCK > 0
        GROUP BY
        	ANA_HIERARCHY
	   	ORDER BY
    		TOTAL_RAKAM DESC
    </cfquery>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box>
            <cf_grid_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                        <th><cf_get_lang dictionary_id='57486.Kategori'></th>
                        <th style="text-align:right;"><cf_get_lang dictionary_id='57657.Ürün'></th>
                        <th style="text-align:right;"><cf_get_lang dictionary_id='57452.Stok'></th>
                        <th style="text-align:right;"><cf_get_lang dictionary_id='58176.Alış'></th>
                        <th style="text-align:right;"><cf_get_lang dictionary_id='57448.Satış'></th>
                        <th style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></th>
                    </tr>
                </thead>
                <tbody>
                    <cfif get_cat_status.recordcount>
                    <cfoutput query="get_cat_status">
                        <cfquery name="get_name" dbtype="query">
                            SELECT PRODUCT_CAT,PRODUCT_CATID FROM GET_PRODUCT_CAT1 WHERE HIERARCHY = '#ANA_HIERARCHY#'
                        </cfquery>
                        <tr>
                            <td>#currentrow#</td>
                            <td><a href="#request.self#?fuseaction=retail.depo_stock_report_upper&event=reportCat&p_cat_list=#get_name.PRODUCT_CATID#&search_department_id=#attributes.search_department_id#" class="tableyazi" target="blank">#get_name.PRODUCT_CAT#</a></td>
                            <td style="text-align:right;">#tlformat(URUN_SAYISI)#</td>
                            <td style="text-align:right;">#tlformat(TOPLAM_STOCK)#</td>
                            <td style="text-align:right;">#tlformat(ALIS_ORTALAMA)#</td>
                            <td style="text-align:right;">#tlformat(SATIS_ORTALAMA)#</td>
                            <td style="text-align:right;">#tlformat(TOTAL_RAKAM)#</td>
                        </tr>
                    </cfoutput>
                </cfif>
                </tbody>
            </cf_grid_list>
        </cf_box>
    </div>
<form name="sub_form" action="index.cfm?fuseaction=retail.depo_stock_product_report" method="post">
	<input type="hidden" name="search_department_id" value="<cfoutput>#attributes.search_department_id#</cfoutput>"/>
    <input type="hidden" name="hierarchy" value=""/>
    <input type="hidden" name="p_cat_list" value="<cfoutput>#p_cat_list#</cfoutput>"/>
</form>
</cfif>
<script>
function get_sub_rows(hierarchy)
{
	document.sub_form.hierarchy.value = hierarchy;
	document.sub_form.target = 'blank';
	document.sub_form.submit();
}

</script>