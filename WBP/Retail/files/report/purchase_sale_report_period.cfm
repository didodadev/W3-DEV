<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.hierarchy1" default="">
<cfparam name="attributes.hierarchy2" default="">
<cfparam name="attributes.hierarchy3" default="">
<cfparam name="attributes.search_department_id" default="#merkez_depo_id#">
<cfparam name="attributes.finishdate" default="">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.uretici" default="">

<cfparam name="attributes.months" default="">
<cfparam name="attributes.years" default="#year(now())#">
<cfparam name="attributes.periods" default="1,2,3,4">

<cfif len(attributes.months)>
	<cfset attributes.periods = ''>
    <cfif listfind(attributes.months,'1') or listfind(attributes.months,'2') or listfind(attributes.months,'3')>
    	<cfset attributes.periods = listappend(attributes.periods,'1')>
    </cfif>
    <cfif listfind(attributes.months,'4') or listfind(attributes.months,'5') or listfind(attributes.months,'6')>
    	<cfset attributes.periods = listappend(attributes.periods,'2')>
    </cfif>
    <cfif listfind(attributes.months,'7') or listfind(attributes.months,'8') or listfind(attributes.months,'9')>
    	<cfset attributes.periods = listappend(attributes.periods,'3')>
    </cfif>
    <cfif listfind(attributes.months,'10') or listfind(attributes.months,'11') or listfind(attributes.months,'12')>
    	<cfset attributes.periods = listappend(attributes.periods,'4')>
    </cfif>
</cfif>

<cfset attributes.period_count = listlen(attributes.periods)>
<cfset attributes.year_count = listlen(attributes.years)>

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

<cfquery name="get_years" datasource="#dsn#">
	SELECT 2014 AS YEAR
    <cfloop from="2015" to="#year(now())#" index="aaa">
    UNION
    SELECT #aaa# AS YEAR
	</cfloop>
   </cfquery>

<cfquery name="get_pers" datasource="#dsn#">
	SELECT 1 AS PERIOD_ID,'1.Çeyrek' AS PERIOD
    UNION
    SELECT 2 AS PERIOD_ID,'2.Çeyrek' AS PERIOD
    UNION
    SELECT 3 AS PERIOD_ID,'3.Çeyrek' AS PERIOD
    UNION
    SELECT 4 AS PERIOD_ID,'4.Çeyrek' AS PERIOD
</cfquery>

<cfquery name="get_months" datasource="#dsn#">
	SELECT 1 AS AY_ID,'Ocak' AS AY
    UNION
    SELECT 2 AS AY_ID,'Şubat' AS AY
    UNION
    SELECT 3 AS AY_ID,'Mart' AS AY
    UNION
    SELECT 4 AS AY_ID,'Nisan' AS AY
    UNION
    SELECT 5 AS AY_ID,'Mayıs' AS AY
    UNION
    SELECT 6 AS AY_ID,'Haziran' AS AY
    UNION
    SELECT 7 AS AY_ID,'Temmuz' AS AY
    UNION
    SELECT 8 AS AY_ID,'Ağustos' AS AY
    UNION
    SELECT 9 AS AY_ID,'Eylül' AS AY
    UNION
    SELECT 10 AS AY_ID,'Ekim' AS AY
    UNION
    SELECT 11 AS AY_ID,'Kasım' AS AY
    UNION
    SELECT 12 AS AY_ID,'Aralık' AS AY
</cfquery>

<cfsavecontent  variable="head"><cf_get_lang dictionary_id='61357.Dönemsel Satış Raporu'></cfsavecontent>
<cf_report_list_search title="#head#">
    <cf_report_list_search_area>
        <cfform action="#request.self#?fuseaction=retail.purchase_sale_report_period" method="post" name="search_depo">
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
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58455.Yıl'></label>
                                    <div class="col col-12 col-xs-12">
                                        <cf_multiselect_check 
                                        query_name="get_years"
                                        selected_text="" 
                                        name="years"
                                        option_text="#getLang('','Yıllar',56645)#" 
                                        width="75"
                                        height="90"
                                        option_name="YEAR" 
                                        option_value="year"
                                        value="#attributes.years#">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='50800.Çeyrek'></label>
                                    <div class="col col-12 col-xs-12">
                                        <cf_multiselect_check 
                                        query_name="get_pers"
                                        selected_text="" 
                                        name="periods"
                                        option_text="#getLang('','Period',51459)#" 
                                        width="75"
                                        height="90"
                                        option_name="period" 
                                        option_value="period_id"
                                        value="#attributes.periods#">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58724.Ay'></label>
                                    <div class="col col-12 col-xs-12">
                                        <cf_multiselect_check 
                                        query_name="get_months"
                                        selected_text="" 
                                        name="months"
                                        option_text="#getLang('','Tüm Aylar',31841)#" 
                                        width="130"
                                        height="260"
                                        option_name="ay" 
                                        option_value="ay_id"
                                        value="#attributes.months#">
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-6 col-xs-12">
                                <br>
                                <div class="form-group">
                                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
                                    <div class="col col-8 col-sm-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
                                            <cfinput type="text" name="startdate" style="width:65px;" value="#attributes.startdate#" validate="eurodate" message="#message#" maxlength="10" required="no">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                                    <div class="col col-8 col-sm-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
                                            <cfinput type="text" name="finishdate" style="width:65px;" value="#attributes.finishdate#" validate="eurodate" message="#message#" maxlength="10" required="no">
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

<cfif listlen(attributes.search_department_id)>
    <cfquery name="get_list_departments" dbtype="query">
        SELECT * FROM get_departments_search WHERE DEPARTMENT_ID IN (#attributes.search_department_id#) ORDER BY DEPARTMENT_HEAD
    </cfquery>
</cfif>



<cfquery name="get_ilk_urunler" datasource="#dsn3#" result="ilk_r">
SELECT
	*
FROM
	(
	SELECT
    	ISNULL((
		SELECT
        	SUM(SGD.SATIS)
        FROM
        	#dsn_dev_alias#.STOK_GUNLUK_DURUM SGD,
            #dsn_dev_alias#.DimDate DAS
        WHERE
        	DAS.YearCalendar IN (#attributes.years#) AND
			<cfif isdefined("attributes.months") and len(attributes.months)>
                DAS.MonthNumberOfYear IN (#attributes.months#) AND
            </cfif>
            <cfif len(attributes.startdate)>
                DAS.FullDate >= #attributes.startdate# AND 
            </cfif>
            <cfif len(attributes.finishdate)>
                DAS.FullDate < #dateadd('d',1,attributes.finishdate)# AND
            </cfif>
            SGD.STOCK_ID = S.STOCK_ID AND
            SGD.STORE IN (#valuelist(get_list_departments.department_id)#) AND
            SGD.TARIH = DAS.FullDate
		),0) AS SATIS,
        S.PRODUCT_ID,
        ISNULL((SELECT TOP 1 EPTR4.SUB_TYPE_ID FROM #dsn_dev_alias#.EXTRA_PRODUCT_TYPES_ROWS EPTR4 WHERE EPTR4.PRODUCT_ID = S.PRODUCT_ID AND EPTR4.TYPE_ID = 10 AND EPTR4.SUB_TYPE_ID IS NOT NULL),0) AS MUADIL_TIPI,
        ISNULL((SELECT TOP 1 EPTR4.SUB_TYPE_NAME FROM #dsn_dev_alias#.EXTRA_PRODUCT_TYPES_ROWS EPTR4 WHERE EPTR4.PRODUCT_ID = S.PRODUCT_ID AND EPTR4.TYPE_ID = 10 AND EPTR4.SUB_TYPE_ID IS NOT NULL),0) AS MUADIL_TIPI_ADI
    FROM
        STOCKS S,
        #dsn1_alias#.PRODUCT P
    WHERE
    	S.PRODUCT_ID = P.PRODUCT_ID AND
		<cfif isdefined("session.pp.userid")>
        	P.COMPANY_ID = #session.pp.company_id# AND
        </cfif>
        <cfif isdefined("session.pp.project_id") and len(session.pp.project_id)>
        	P.PROJECT_ID IN (#session.pp.project_id#) AND
        </cfif>
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
        <cfif isdefined("attributes.uretici") and listlen(attributes.uretici)>
            S.PRODUCT_ID IN (SELECT EPTR4.PRODUCT_ID FROM #dsn_dev_alias#.EXTRA_PRODUCT_TYPES_ROWS EPTR4 WHERE EPTR4.PRODUCT_ID IS NOT NULL AND EPTR4.SUB_TYPE_ID IN (#attributes.uretici#)) AND
        </cfif>
        S.PRODUCT_CATID IN (#p_cat_list#)
     ) T_ALL
WHERE
	SATIS > 0
</cfquery>

<cfif get_ilk_urunler.recordcount>
	<cfset ana_urun_list = listdeleteduplicates(valuelist(get_ilk_urunler.product_id))>
	<cfset arama_list = listdeleteduplicates(valuelist(get_ilk_urunler.product_id))>
    <cfset muadil_list = listdeleteduplicates(valuelist(get_ilk_urunler.MUADIL_TIPI))>
    
    <cfif listfind(muadil_list,0)>
    	<cfset muadil_list = listdeleteat(muadil_list,listfind(muadil_list,0))>
    </cfif>
    <cfif listfind(muadil_list,4962)><!--- a TİPİ DAHİL DEĞİL --->
    	<cfset muadil_list = listdeleteat(muadil_list,listfind(muadil_list,4962))>
    </cfif>
    <cfif listfind(muadil_list,6050)><!--- PALET TİPİ DAHİL DEĞİL --->
    	<cfset muadil_list = listdeleteat(muadil_list,listfind(muadil_list,6050))>
    </cfif>
    
    <cfquery name="get_muadil_products" datasource="#dsn_dev#">
        SELECT
            P1.PRODUCT_ID,
            P1.PRODUCT_NAME,
            EPTR.*
        FROM
            #DSN1_ALIAS#.PRODUCT P1,
            EXTRA_PRODUCT_TYPES_ROWS EPTR
        WHERE
            P1.PRODUCT_ID NOT IN (#arama_list#) AND
            EPTR.PRODUCT_ID = P1.PRODUCT_ID AND
            EPTR.TYPE_ID = 10 AND
            EPTR.SUB_TYPE_ID IN (#muadil_list#)
    </cfquery>
    <cfif get_muadil_products.recordcount>
    	<cfset muadil_urun_list = valuelist(get_muadil_products.product_id)>
		<cfset arama_list = listappend(arama_list,listdeleteduplicates(valuelist(get_muadil_products.product_id)))>
    </cfif>
<cfelse>
	<cfset arama_list = "">
    <cfset ana_urun_list = "">
    <cfset muadil_urun_list = "">
</cfif>


<cfquery name="get_internaldemand_all" datasource="#DSN3#" result="donus">
SELECT
	SUM(SATIS) T_SATIS,
    SUM(SATIS_TUTAR) T_SATIS_TUTAR,
    PERIOD,
    YIL,
    PRODUCT_ID,
    STOCK_CODE,
    PRODUCT_NAME,
    PROPERTY,
    STOCK_ID,
    TAX,
    PRODUCT_CATID,
    AMBALAJ,
    MARKA,
    URETICI
FROM
	(
	SELECT
        ISNULL((
		SELECT
        	SUM(SGD.SATIS)
        FROM
        	#dsn_dev_alias#.STOK_GUNLUK_DURUM SGD
        WHERE
        	SGD.STOCK_ID = S.STOCK_ID AND
            SGD.STORE IN (#valuelist(get_list_departments.department_id)#) AND
            SGD.TARIH = DAS.FullDate
		),0) AS SATIS,
        DAS.FullDate AS S_TARIH,
        SATIS_TUTARLAR.S_TUTAR AS SATIS_TUTAR,
        CASE 
        	WHEN (DAS.MonthNumberOfYear = 1 OR DAS.MonthNumberOfYear = 2 OR DAS.MonthNumberOfYear = 3) THEN 1
            WHEN (DAS.MonthNumberOfYear = 4 OR DAS.MonthNumberOfYear = 5 OR DAS.MonthNumberOfYear = 6) THEN 2
            WHEN (DAS.MonthNumberOfYear = 7 OR DAS.MonthNumberOfYear = 8 OR DAS.MonthNumberOfYear = 9) THEN 3
            WHEN (DAS.MonthNumberOfYear = 10 OR DAS.MonthNumberOfYear = 11 OR DAS.MonthNumberOfYear = 12) THEN 4
            END AS PERIOD,
        DAS.YearCalendar AS YIL,
        S.PRODUCT_ID,
        S.STOCK_CODE,
        S.PRODUCT_NAME,
        S.PROPERTY,
        S.STOCK_ID,
        S.TAX,
        PC.PRODUCT_CATID,
        PS2.PRICE,
        EPTR.SUB_TYPE_NAME AS AMBALAJ,
        EPTR2.SUB_TYPE_NAME AS MARKA,
        EPTR3.SUB_TYPE_NAME AS URETICI
	FROM 
        #dsn_dev_alias#.DimDate DAS,
        PRODUCT_CAT PC,
        #dsn1_alias#.PRODUCT P,
        STOCKS S
        	LEFT JOIN #dsn_dev_alias#.EXTRA_PRODUCT_TYPES_ROWS EPTR ON (S.PRODUCT_ID = EPTR.PRODUCT_ID AND EPTR.TYPE_ID = #ambalaj_type_id#)
            LEFT JOIN #dsn_dev_alias#.EXTRA_PRODUCT_TYPES_ROWS EPTR2 ON (S.PRODUCT_ID = EPTR2.PRODUCT_ID AND EPTR2.TYPE_ID = #marka_type_id#)
            LEFT JOIN #dsn_dev_alias#.EXTRA_PRODUCT_TYPES_ROWS EPTR3 ON (S.PRODUCT_ID = EPTR3.PRODUCT_ID AND EPTR3.TYPE_ID = #uretici_type_id#)
            LEFT JOIN PRODUCT_UNIT ON S.PRODUCT_ID = PRODUCT_UNIT.PRODUCT_ID
        	LEFT JOIN PRICE_STANDART ON PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID
            LEFT JOIN PRICE_STANDART AS PS2 ON PRODUCT_UNIT.PRODUCT_ID = PS2.PRODUCT_ID
            LEFT JOIN
            	(
                	SELECT 
                    	SUM(SATIS_TUTAR) AS S_TUTAR,
                        STOCK_ID,
                        ISLEM_YIL,
                        ISLEM_AY,
                        ISLEM_GUN
                    FROM 
                       (
                            SELECT 
                                YEAR(GA.FIS_TARIHI) AS ISLEM_YIL,
                                MONTH(GA.FIS_TARIHI) AS ISLEM_AY,
                                DAY(GA.FIS_TARIHI) AS ISLEM_GUN,
                                GAR.STOCK_ID,
                                (CASE WHEN GA.FIS_IPTAL > 0  THEN 0 * (GAR.MIKTAR) WHEN (CAST(GA.BELGE_TURU AS NVARCHAR) = '2' OR GAR.SATIR_IPTALMI = 1) THEN -1 * (GAR.SATIR_TOPLAM - GAR.SATIR_INDIRIM - GAR.SATIR_PROMOSYON_INDIRIM - GAR.SATIR_KDV_TUTAR) ELSE (GAR.SATIR_TOPLAM - GAR.SATIR_PROMOSYON_INDIRIM - GAR.SATIR_INDIRIM - GAR.SATIR_KDV_TUTAR) END) AS SATIS_TUTAR
                            FROM
                                #dsn_dev_alias#.GENIUS_ACTIONS GA,
                                #dsn_dev_alias#.GENIUS_ACTIONS_ROWS GAR,
                                #dsn1_alias#.STOCKS S2,
                                #dsn_alias#.DEPARTMENT D
                            WHERE
                                <cfif get_list_departments.recordcount>
                                	GA.DEPARTMENT_ID IN (#VALUELIST(get_list_departments.DEPARTMENT_ID)#) AND
                                </cfif>
                                GA.DEPARTMENT_ID = D.DEPARTMENT_ID AND
                                GA.ACTION_ID = GAR.ACTION_ID AND
								<cfif isdefined("attributes.months") and len(attributes.months)>
                                    MONTH(GA.FIS_TARIHI) IN (#attributes.months#) AND
                                </cfif>
                                <cfif len(attributes.startdate)>
                                    GA.FIS_TARIHI >= #attributes.startdate# AND 
                                </cfif>
                                <cfif len(attributes.finishdate)>
                                    GA.FIS_TARIHI < #dateadd('d',1,attributes.finishdate)# AND
                                </cfif>
                                YEAR(GA.FIS_TARIHI) IN (#attributes.years#) AND
                                S2.STOCK_ID = GAR.STOCK_ID
								<cfif listlen(arama_list)>
                                    AND S2.PRODUCT_ID IN (#arama_list#)
                                <cfelse>
                                    AND S2.PRODUCT_ID = 0
                                </cfif>
                            UNION ALL
                            SELECT 
                                YEAR(SHIP_DATE) AS ISLEM_YIL,
                                MONTH(SHIP_DATE) AS ISLEM_AY,
                                DAY(SHIP_DATE) AS ISLEM_GUN,
                                GSRA.STOCK_ID,
                                (GSRA.NETTOTAL) AS SATIS_TUTAR
                            FROM
                                #dsn_dev_alias#.GET_SHIP_ROWS_REAL GSRA
                            WHERE
                                <cfif get_list_departments.recordcount>
                                	GSRA.DEPARTMENT_IN IN (#VALUELIST(get_list_departments.DEPARTMENT_ID)#) AND
                                </cfif>
                                (
                                GSRA.SHIP_TYPE = 70 AND GSRA.PROCESS_CAT <> 114 
                                OR
                                GSRA.SHIP_TYPE = 71
                                )
                                AND
                                <cfif isdefined("attributes.months") and len(attributes.months)>
                                    MONTH(GSRA.SHIP_DATE) IN (#attributes.months#) AND
                                </cfif>
                                <cfif len(attributes.startdate)>
                                    GSRA.SHIP_DATE >= #attributes.startdate# AND 
                                </cfif>
                                <cfif len(attributes.finishdate)>
                                    GSRA.SHIP_DATE < #dateadd('d',1,attributes.finishdate)# AND
                                </cfif>
                                YEAR(GSRA.SHIP_DATE) IN (#attributes.years#)
                                <cfif listlen(arama_list)>
                                    AND GSRA.PRODUCT_ID IN (#arama_list#)
                                <cfelse>
                                    AND GSRA.PRODUCT_ID = 0
                                </cfif>
                      ) T2
                GROUP BY
                	STOCK_ID,
                    ISLEM_YIL,
                    ISLEM_AY,
                    ISLEM_GUN
                ) AS SATIS_TUTARLAR ON S.STOCK_ID = SATIS_TUTARLAR.STOCK_ID
	WHERE	
		S.STOCK_ID = SATIS_TUTARLAR.STOCK_ID AND
        DAS.YearCalendar = SATIS_TUTARLAR.ISLEM_YIL AND
        DAS.MonthNumberOfYear = SATIS_TUTARLAR.ISLEM_AY AND
        DAS.DayNumberOfMonth = SATIS_TUTARLAR.ISLEM_GUN AND
		<cfif listlen(arama_list)>
        	P.PRODUCT_ID IN (#arama_list#) AND
        <cfelse>
        	P.PRODUCT_ID = 0 AND
        </cfif>
        DAS.YearCalendar IN (#attributes.years#) AND
		<cfif isdefined("attributes.months") and len(attributes.months)>
        	DAS.MonthNumberOfYear IN (#attributes.months#) AND
        </cfif>
		<cfif len(attributes.startdate)>
        	DAS.FullDate >= #attributes.startdate# AND 
        </cfif>
        <cfif len(attributes.finishdate)>
        	DAS.FullDate < #dateadd('d',1,attributes.finishdate)# AND
        </cfif>
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
        S.PRODUCT_CATID = PC.PRODUCT_CATID
   ) T1
GROUP BY
	T1.PERIOD,
    T1.YIL,
    T1.PRODUCT_ID,
    T1.STOCK_CODE,
    T1.PRODUCT_NAME,
    T1.PROPERTY,
    T1.STOCK_ID,
    T1.TAX,
    T1.PRODUCT_CATID,
    T1.PRICE,
    T1.AMBALAJ,
    T1.MARKA,
    T1.URETICI
ORDER BY
   T1.STOCK_CODE ASC,
   T1.PRODUCT_NAME ASC
</cfquery>

<cfif get_internaldemand_all.recordcount>
    <cfquery name="get_internaldemand" dbtype="query">
        SELECT DISTINCT
            PRODUCT_ID,
            STOCK_CODE,
            PRODUCT_NAME,
            PROPERTY,
            STOCK_ID,
            TAX,
            PRODUCT_CATID,
            AMBALAJ,
            MARKA,
            URETICI
        FROM
            get_internaldemand_all
        ORDER BY
            STOCK_CODE ASC,
            PRODUCT_NAME ASC
    </cfquery>
<cfelse>
	<cfset get_internaldemand.recordcount = 0>
</cfif>

<cfoutput query="get_internaldemand_all">
	<cfset 'satis_#stock_id#_#PERIOD#_#YIL#' = T_SATIS>
    <cfset 'satis_tutar_#stock_id#_#PERIOD#_#YIL#' = T_SATIS_TUTAR>
    <cfif isdefined('toplam_tutar_#PERIOD#_#YIL#')>
    	<cfset 'toplam_tutar_#PERIOD#_#YIL#' = evaluate('toplam_tutar_#PERIOD#_#YIL#') + (T_SATIS_TUTAR)>
    <cfelse>
    	<cfset 'toplam_tutar_#PERIOD#_#YIL#' = T_SATIS_TUTAR>
    </cfif>
    
    <cfif isdefined('toplam_satis_#PERIOD#_#YIL#')>
    	<cfset 'toplam_satis_#PERIOD#_#YIL#' = evaluate('toplam_satis_#PERIOD#_#YIL#') + (T_SATIS)>
    <cfelse>
    	<cfset 'toplam_satis_#PERIOD#_#YIL#' = (T_SATIS)>
    </cfif>
    
    <cfif isdefined('toplam_tutar_p_#PRODUCT_CATID#_#PERIOD#_#YIL#')>
    	<cfset 'toplam_tutar_p_#PRODUCT_CATID#_#PERIOD#_#YIL#' = evaluate('toplam_tutar_p_#PRODUCT_CATID#_#PERIOD#_#YIL#') + (T_SATIS_TUTAR)>
    <cfelse>
    	<cfset 'toplam_tutar_p_#PRODUCT_CATID#_#PERIOD#_#YIL#' = T_SATIS_TUTAR>
    </cfif>
    
    <cfif isdefined('toplam_satis_p_#PRODUCT_CATID#_#PERIOD#_#YIL#')>
    	<cfset 'toplam_satis_p_#PRODUCT_CATID#_#PERIOD#_#YIL#' = evaluate('toplam_satis_p_#PRODUCT_CATID#_#PERIOD#_#YIL#') + (T_SATIS)>
    <cfelse>
    	<cfset 'toplam_satis_p_#PRODUCT_CATID#_#PERIOD#_#YIL#' = (T_SATIS)>
    </cfif>
</cfoutput>

<cfset last_birinci_ = "">
<cfset last_ikinci_ = "">
<cfset last_ucuncu_ = "">
<cfset last_group_id_ = "">

<!-- sil -->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cf_grid_list>
            <thead>
                <tr>
                    <th ><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th ><cf_get_lang dictionary_id='61642.Alt Grup'> 2</th>
                    <th ><cf_get_lang dictionary_id='58847.Marka'></th>
                    <th ><cf_get_lang dictionary_id='33269.Ambalaj'></th>
                    <th ><cf_get_lang dictionary_id='57452.Stok'></th>
                    <th  colspan="<cfoutput>#attributes.year_count * attributes.period_count#</cfoutput>"><cf_get_lang dictionary_id='29959.Satış Miktar'></th>
                    <th ><cf_get_lang dictionary_id='37151.Toplam Satış Miktarı'></th>
                    <th  colspan="<cfoutput>#attributes.year_count * attributes.period_count#</cfoutput>"><cf_get_lang dictionary_id='39129.Satış Tutarı'></th>
                    <th ><cf_get_lang dictionary_id='40624.Toplam Satış Tutarı'></th>
                    <th   colspan="<cfoutput>#attributes.year_count * attributes.period_count#</cfoutput>"><cf_get_lang dictionary_id='39129.Satış Tutarı'>(<cf_get_lang dictionary_id='38174.Yüzde'>)</th>
                </tr>
                <tr>
                    <th colspan="5">&nbsp;</th>
                    <cfloop from="1" to="#attributes.period_count#" index="pi">
                        <cfoutput><th style="text-align:right; " colspan="#attributes.year_count#" nowrap="nowrap">#listgetat(attributes.periods,pi)#. <cf_get_lang dictionary_id='50800.Çeyrek'></th></cfoutput>
                    </cfloop>
                    <th style="text-align:right; ">&nbsp;</th>
                    <cfloop from="1" to="#attributes.period_count#" index="pi">
                        <cfoutput><th style="text-align:right; " colspan="#attributes.year_count#" nowrap="nowrap">#listgetat(attributes.periods,pi)#. <cf_get_lang dictionary_id='50800.Çeyrek'></th></cfoutput>
                    </cfloop>
                    <th style="text-align:right; ">&nbsp;</th>
                    <cfloop from="1" to="#attributes.period_count#" index="pi">
                        <cfoutput><th style="text-align:right; " colspan="#attributes.year_count#" nowrap="nowrap">#listgetat(attributes.periods,pi)#. <cf_get_lang dictionary_id='50800.Çeyrek'></th></cfoutput>
                    </cfloop>
                </tr>
                <tr>
                    <th colspan="5">&nbsp;</th>
                    <cfloop from="1" to="#attributes.period_count#" index="pi">
                        <cfloop from="1" to="#attributes.year_count#" index="yy">
                            <th style="text-align:right; "><cfoutput>#listgetat(attributes.years,yy)#</cfoutput></th>
                        </cfloop>
                    </cfloop>
                    <th style="text-align:right; ">&nbsp;</th>
                    <cfloop from="1" to="#attributes.period_count#" index="pi">
                        <cfloop from="1" to="#attributes.year_count#" index="yy">
                            <th style="text-align:right; "><cfoutput>#listgetat(attributes.years,yy)#</cfoutput></th>
                        </cfloop>
                    </cfloop>
                    <th style="text-align:right; ">&nbsp;</th>
                    <cfloop from="1" to="#attributes.period_count#" index="pi">
                        <cfloop from="1" to="#attributes.year_count#" index="yy">
                            <th style="text-align:right; "><cfoutput>#listgetat(attributes.years,yy)#</cfoutput></th>
                        </cfloop>
                    </cfloop>
                </tr>
            </thead>
            <tbody>
            <cfif get_internaldemand.recordcount>
                <cfoutput query="get_internaldemand">
                    <cfset birinci_ = listfirst(stock_code,'.')>
                    <cfset ikinci_ = birinci_ & '.' & listgetat(stock_code,2,'.')>
                    <cfset ucuncu_ = ikinci_ & '.' & listgetat(stock_code,3,'.')>
                    <tr>
                        <td>#currentrow#</td>
                        <td nowrap="nowrap">
                            <cfif not len(last_ucuncu_) or last_ucuncu_ is not ucuncu_>
                                <cfset sira_ = listfind(hierarchy_list,ucuncu_)>
                                <cfif sira_ neq 0>
                                    #listgetat(hierarchy_name_list,sira_,'╗')#
                                    <cfset last_group_id_ = listgetat(hierarchy_name_list,sira_,'╗')>
                                </cfif>
                            </cfif>
                        </td>
                        <td nowrap="nowrap">#marka#</td>
                        <td nowrap="nowrap">#ambalaj#</td>
                        <td nowrap="nowrap"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=retail.popup_product_stocks&stock_id=#stock_id#','page_display');" class="tableyazi">#PROPERTY#</a></td>
                        <cfset satir_satis_toplam_ = 0>
                        <cfloop from="1" to="#attributes.period_count#" index="pi">
                            <cfset per_ = listgetat(attributes.periods,pi)>
                            <cfloop from="1" to="#attributes.year_count#" index="yy">
                                <td style="text-align:right; ">
                                    <cfset year_ = listgetat(attributes.years,yy)>
                                    <cfif isdefined("satis_#stock_id#_#per_#_#year_#")>
                                        <cfset r_ = evaluate("satis_#stock_id#_#per_#_#year_#")>
                                    <cfelse>
                                        <cfset r_ = 0>
                                    </cfif>
                                    #tlformat(r_)#
                                </td>
                                <cfset satir_satis_toplam_ = satir_satis_toplam_ + r_>
                            </cfloop>
                        </cfloop>
                        <td style="text-align:right;">#tlformat(satir_satis_toplam_)#</td>
                        
                        <cfset satir_tutar_toplam_ = 0>
                        <cfloop from="1" to="#attributes.period_count#" index="pi">
                            <cfset per_ = listgetat(attributes.periods,pi)>
                            <cfloop from="1" to="#attributes.year_count#" index="yy">
                                <td style="text-align:right; ">
                                    <cfset year_ = listgetat(attributes.years,yy)>
                                    <cfif isdefined("satis_tutar_#stock_id#_#per_#_#year_#")>
                                        <cfset r_ = evaluate("satis_tutar_#stock_id#_#per_#_#year_#")>
                                    <cfelse>
                                        <cfset r_ = 0>
                                    </cfif>
                                    #tlformat(r_)#
                                </td>
                                <cfset satir_tutar_toplam_ = satir_tutar_toplam_ + r_>
                            </cfloop>
                        </cfloop>
                        <td style="text-align:right;">#tlformat(satir_tutar_toplam_)#</td>
                        <cfloop from="1" to="#attributes.period_count#" index="pi">
                            <cfset per_ = listgetat(attributes.periods,pi)>
                            <cfloop from="1" to="#attributes.year_count#" index="yy">
                            <cfset year_ = listgetat(attributes.years,yy)>
                                <td style="text-align:right; ">
                                    <cfif isdefined("satis_tutar_#stock_id#_#per_#_#year_#")>
                                        <cfset r_ = evaluate("satis_tutar_#stock_id#_#per_#_#year_#")>
                                    <cfelse>
                                        <cfset r_ = 0>
                                    </cfif>
                                    <!---
                                    <cfif isdefined("toplam_tutar_#per_#_#year_#")>
                                        <cfset t_ = evaluate("toplam_tutar_#per_#_#year_#")>
                                    <cfelse>
                                        <cfset t_ = 0>
                                    </cfif>
                                    --->
                                    <cfif isdefined("toplam_tutar_p_#PRODUCT_CATID#_#per_#_#year_#")>
                                        <cfset t_ = evaluate("toplam_tutar_p_#PRODUCT_CATID#_#per_#_#year_#")>
                                    <cfelse>
                                        <cfset t_ = 0>
                                    </cfif>
                                    <cfif t_ gt 0 and r_ gt 0>
                                        %#tlformat(r_ * 100 / t_)#
                                    <cfelse>
                                        %#tlformat(0)#
                                    </cfif> 
                                </td>
                            </cfloop>
                        </cfloop>
                    </tr>   
                    <cfif currentrow eq get_internaldemand.recordcount or PRODUCT_CATID neq PRODUCT_CATID[currentrow+1]>
                    <tr>
                        <td colspan="5" style=" "><b>#last_group_id_#</b> <cf_get_lang dictionary_id='40302.Toplamlar'></th>
                        <cfset satir_satis_toplam_ = 0>
                        <cfloop from="1" to="#attributes.period_count#" index="pi">
                            <cfset per_ = listgetat(attributes.periods,pi)>
                            <cfloop from="1" to="#attributes.year_count#" index="yy">
                                <td style="text-align:right;  ">
                                    <cfset year_ = listgetat(attributes.years,yy)>
                                    <cfif isdefined("toplam_satis_p_#PRODUCT_CATID#_#per_#_#year_#")>
                                        <cfset r_ = evaluate("toplam_satis_p_#PRODUCT_CATID#_#per_#_#year_#")>
                                    <cfelse>
                                        <cfset r_ = 0>
                                    </cfif>
                                    #tlformat(r_)#
                                </td>
                                <cfset satir_satis_toplam_ = satir_satis_toplam_ + r_>
                            </cfloop>
                        </cfloop>
                        <td style="text-align:right; ">#tlformat(satir_satis_toplam_)#</td>
                        
                        <cfset satir_tutar_toplam_ = 0>
                        <cfloop from="1" to="#attributes.period_count#" index="pi">
                            <cfset per_ = listgetat(attributes.periods,pi)>
                            <cfloop from="1" to="#attributes.year_count#" index="yy">
                                <td style="text-align:right;  ">
                                    <cfset year_ = listgetat(attributes.years,yy)>
                                    <cfif isdefined("toplam_tutar_p_#PRODUCT_CATID#_#per_#_#year_#")>
                                        <cfset r_ = evaluate("toplam_tutar_p_#PRODUCT_CATID#_#per_#_#year_#")>
                                    <cfelse>
                                        <cfset r_ = 0>
                                    </cfif>
                                    #tlformat(r_)#
                                </td>
                                <cfset satir_tutar_toplam_ = satir_tutar_toplam_ + r_>
                            </cfloop>
                        </cfloop>
                        <td style="text-align:right; ">#tlformat(satir_tutar_toplam_)#</td>
                        <cfloop from="1" to="#attributes.period_count#" index="pi">
                            <cfset per_ = listgetat(attributes.periods,pi)>
                            <cfloop from="1" to="#attributes.year_count#" index="yy">
                            <cfset year_ = listgetat(attributes.years,yy)>
                                <td style="text-align:right;  ">
                                    <cfif isdefined("toplam_tutar_p_#PRODUCT_CATID#_#per_#_#year_#")>
                                        <cfset r_ = evaluate("toplam_tutar_p_#PRODUCT_CATID#_#per_#_#year_#")>
                                    <cfelse>
                                        <cfset r_ = 0>
                                    </cfif>
                                    <cfif isdefined("toplam_tutar_#per_#_#year_#")>
                                        <cfset t_ = evaluate("toplam_tutar_#per_#_#year_#")>
                                    <cfelse>
                                        <cfset t_ = 0>
                                    </cfif>
                                    <!---
                                    <cfif t_ gt 0 and r_ gt 0>
                                        #tlformat(r_ * 100 / t_)#
                                    <cfelse>
                                        #tlformat(0)#
                                    </cfif> 
                                    --->
                                    %100
                                </td>
                            </cfloop>
                        </cfloop>
                    </tr>
                    </cfif>
                    <cfset last_birinci_ = birinci_>
                    <cfset last_ikinci_ = ikinci_>
                    <cfset last_ucuncu_ = ucuncu_>
                </cfoutput>
                </cfif>
                <cfoutput>
                    <tr>
                    <td colspan="5" ><b><cf_get_lang dictionary_id='57680.Genel Toplam'></b></th>
                    <cfset satir_satis_toplam_ = 0>
                    <cfloop from="1" to="#attributes.period_count#" index="pi">
                        <cfset per_ = listgetat(attributes.periods,pi)>
                        <cfloop from="1" to="#attributes.year_count#" index="yy">
                            <td style="text-align:right; ">
                                <cfset year_ = listgetat(attributes.years,yy)>
                                <cfif isdefined("toplam_satis_#per_#_#year_#")>
                                    <cfset r_ = evaluate("toplam_satis_#per_#_#year_#")>
                                <cfelse>
                                    <cfset r_ = 0>
                                </cfif>
                                #tlformat(r_)#
                            </td>
                            <cfset satir_satis_toplam_ = satir_satis_toplam_ + r_>
                        </cfloop>
                    </cfloop>
                    <td style="text-align:right;">#tlformat(satir_satis_toplam_)#</td>
                    
                    <cfset satir_tutar_toplam_ = 0>
                    <cfloop from="1" to="#attributes.period_count#" index="pi">
                        <cfset per_ = listgetat(attributes.periods,pi)>
                        <cfloop from="1" to="#attributes.year_count#" index="yy">
                            <td style="text-align:right;  ">
                                <cfset year_ = listgetat(attributes.years,yy)>
                                <cfif isdefined("toplam_tutar_#per_#_#year_#")>
                                    <cfset r_ = evaluate("toplam_tutar_#per_#_#year_#")>
                                <cfelse>
                                    <cfset r_ = 0>
                                </cfif>
                                #tlformat(r_)#
                            </td>
                            <cfset satir_tutar_toplam_ = satir_tutar_toplam_ + r_>
                        </cfloop>
                    </cfloop>
                    <td style="text-align:right; ">#tlformat(satir_tutar_toplam_)#</td>
                    <cfloop from="1" to="#attributes.period_count#" index="pi">
                        <cfset per_ = listgetat(attributes.periods,pi)>
                        <cfloop from="1" to="#attributes.year_count#" index="yy">
                        <cfset year_ = listgetat(attributes.years,yy)>
                            <td style="text-align:right;  ">%100</td>
                        </cfloop>
                    </cfloop>
                </tr>
                </cfoutput>
            </tbody>
        </cf_grid_list>
    </cf_box>
</div>
    
<!-- sil -->
</cfif>