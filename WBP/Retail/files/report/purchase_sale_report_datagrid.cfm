<cfif isdefined("session.ep.userid")>
	<cfset userid_ = session.ep.userid>
<cfelse>
	<cfset userid_ = session.pp.userid>
</cfif> 

<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.hierarchy1" default="">
<cfparam name="attributes.hierarchy2" default="">
<cfparam name="attributes.hierarchy3" default="">
<cfparam name="attributes.search_department_id" default="#merkez_depo_id#">
<cfparam name="attributes.finishdate" default="#now()#">
<cfparam name="attributes.startdate" default="#date_add('d',-7,attributes.finishdate)#">
<cfparam name="attributes.uretici" default="">

<cfif isdefined("session.ep.userid")>
    <cfparam name="attributes.company" default="" >
    <cfparam name="attributes.company_id" default="" >
    <cfparam name="attributes.project_id" default="">
    <cfparam name="attributes.project_head" default="">
<cfelse>
    <cfset attributes.company = session.pp.company>
    <cfset attributes.company_id = session.pp.company_id>
    <cfset attributes.project_id = session.pp.project_id>
    <cfset attributes.project_head = session.pp.project_name>
</cfif>

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
    SELECT DISTINCT
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

<cfsavecontent  variable="title"><cf_get_lang dictionary_id='61876.Alış Satış Raporu'></cfsavecontent>
<cf_report_list_search title="#title#" id="analyse_report">
    <cf_report_list_search_area>
        <cfform action="#request.self#?fuseaction=retail.purchase_sale_report_datagrid" method="post" name="search_depo">
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
                                        option_text="#getLang('','Alt Grup',61642)#  2" 
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
                                        <br />
                                        <input type="checkbox" value="1" name="is_department_multi" <cfif isdefined("attributes.is_department_multi")>checked</cfif>/><cf_get_lang dictionary_id='61978.Departman Dağılımı Göster'>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-6 col-xs-12">
                                <div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='29533.Tedarikçi'></label>
									<div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <cfif isdefined("session.ep.userid")>
                                                <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isDefined("attributes.company") and len(attributes.company)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>" />
                                                <input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isDefined("attributes.company") and len(attributes.company)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
                                                <input type="text" name="company" id="company" style="width:120px;"  value="<cfif isdefined("attributes.company") and len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',0,0','COMPANY_ID,CONSUMER_ID','company_id,consumer_id','','3','250');" autocomplete="off">
                                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable ('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_name=search_depo.company&field_comp_id=search_depo.company_id&field_consumer=search_depo.consumer_id&select_list=7,8&keyword='+encodeURIComponent(document.search_depo.company.value));"></span>
                                            <cfelse>
                                                <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isDefined("attributes.company") and len(attributes.company)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>" />
                                                <input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isDefined("attributes.company") and len(attributes.company)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
                                                <input type="text" name="company" id="company" style="width:120px;"  value="<cfif isdefined("attributes.company") and len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>" readonly autocomplete="off">
                                            </cfif>
                                        </div>
									</div>
								</div>
                                <div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
									<div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <cfif isdefined("session.ep.userid")>
                                                <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined("attributes.project_id") and len (attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
                                                <input type="text" name="project_head" id="project_head" style="width:120px;"value="<cfif isdefined('attributes.project_head') and  len(attributes.project_head)><cfoutput>#URLDecode(attributes.project_head)#</cfoutput></cfif>" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
                                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable ('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=search_depo.project_id&project_head=search_depo.project_head');"></span>
                                            <cfelse>
                                                <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined("attributes.project_id") and len (attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
                                                <input type="text" name="project_head" id="project_head" style="width:120px;"value="<cfif isdefined('attributes.project_head') and  len(attributes.project_head)><cfoutput>#URLDecode(attributes.project_head)#</cfoutput></cfif>" readonly autocomplete="off">
                                            </cfif>
                                        </div>
									</div>
								</div>
                                <div class="form-group">
                                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
                                    <div class="col col-8 col-sm-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang Dictionary_id ='58053.Başlangıç Tarihi'></cfsavecontent>
                                            <cfinput type="text" name="startdate" style="width:65px;" value="#attributes.startdate#" validate="eurodate" message="#message#" maxlength="10" required="yes"> 
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>  
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                                    <div class="col col-8 col-sm-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message2"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang Dictionary_id ='57700.Bitiş Tarihi'></cfsavecontent>
                                            <cfinput type="text" name="finishdate" style="width:65px;" value="#attributes.finishdate#" validate="eurodate" message="#message#" maxlength="10" required="yes">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>  
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"></label>
                                    <div class="col col-12 col-xs-12">
                                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=retail.popup_select_rival_products&type=10&op_f_name=add_row</cfoutput>','list');"><i class="icn-md icon-plus-square"></i></a>
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
                    </div>
                    <div class="row ReportContentBorder">
                		<div class="ReportContentFooter">
                                <cf_wrk_search_button button_type="1" search_function="control_search_depo()">
                                <input type="button" value="Excel" onclick="get_excel();"/>
                        </div>
                    </div>
                </div>
            </div>    
        </cfform>
    </cf_report_list_search_area>
</cf_report_list_search>

<div id="control_h"></div>
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
<cfif isdefined("attributes.is_form_submitted")>
<cfquery name="get_alt_groups" dbtype="query" result="get_alt_groups_r">
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


<cfquery name="get_internaldemand" datasource="#DSN3#" result="donus">
SELECT
	*
FROM
	(
	SELECT
        ISNULL((SELECT TOP 1 ETR.SUB_TYPE_ID FROM #DSN_DEV_ALIAS#.EXTRA_PRODUCT_TYPES_ROWS ETR WHERE P.PRODUCT_ID = ETR.PRODUCT_ID AND ETR.TYPE_ID = #uretici_type_id#),0) AS SUB_TYPE_ID,
        ISNULL((SELECT TOP 1 ETR.SUB_TYPE_NAME FROM #DSN_DEV_ALIAS#.EXTRA_PRODUCT_TYPES_ROWS ETR WHERE P.PRODUCT_ID = ETR.PRODUCT_ID AND ETR.TYPE_ID = #ambalaj_type_id#),0) AS AMBALAJ,
        ISNULL((SELECT TOP 1 ETR.SUB_TYPE_NAME FROM #DSN_DEV_ALIAS#.EXTRA_PRODUCT_TYPES_ROWS ETR WHERE P.PRODUCT_ID = ETR.PRODUCT_ID AND ETR.TYPE_ID = #marka_type_id#),0) AS MARKA,
        ISNULL((SELECT TOP 1 ETR.SUB_TYPE_NAME FROM #DSN_DEV_ALIAS#.EXTRA_PRODUCT_TYPES_ROWS ETR WHERE P.PRODUCT_ID = ETR.PRODUCT_ID AND ETR.TYPE_ID = #uretici_type_id#),0) AS URETICI,
        ISNULL(PT_ALIS.NEW_ALIS,PRICE_STANDART.PRICE) AS LISTE_FIYATI_ALIS,
        ISNULL(PT_SATIS.NEW_PRICE,PS2.PRICE) AS LISTE_FIYATI_SATIS,
        ISNULL(PT_SATIS.NEW_PRICE_KDV,PS2.PRICE_KDV) AS LISTE_FIYATI_SATIS_KDV,
		<cfoutput query="get_list_departments">
            ISNULL((SELECT SUM(PRODUCT_STOCK) FROM #DSN#_#session.ep.period_year#_#session.ep.company_id#.GET_STOCK_PRODUCT WHERE S.PRODUCT_ID = GET_STOCK_PRODUCT.PRODUCT_ID AND GET_STOCK_PRODUCT.DEPARTMENT_ID = #department_id#),0) AS STOCK_#department_id#,
			0.00 AS ALIM_MIKTAR_#department_id#,
            0.00 AS ALIM_TUTAR_#department_id#,
            0.00 AS SATIS_MIKTAR_#department_id#,
            0.00 AS SATIS_TUTAR_#department_id#,
            0.00 AS SATIS_TUTAR_BRUT_#department_id#,
            0.00 AS SATIS_TUTAR_BRUT_KDVSIZ_#department_id#,
            0.00 AS ROW_ORT_#department_id#,
		</cfoutput>
        <cfif not listfind(valuelist(get_list_departments.department_id),merkez_depo_id)>
        	ISNULL((SELECT SUM(PRODUCT_STOCK) FROM #DSN#_#session.ep.period_year#_#session.ep.company_id#.GET_STOCK_PRODUCT WHERE S.PRODUCT_ID = GET_STOCK_PRODUCT.PRODUCT_ID AND GET_STOCK_PRODUCT.DEPARTMENT_ID = #merkez_depo_id#),0) AS STOCK_#merkez_depo_id#,
			0.00 AS ALIM_MIKTAR_#merkez_depo_id#,
            0.00 AS ALIM_TUTAR_#merkez_depo_id#,
            0.00 AS SATIS_MIKTAR_#merkez_depo_id#,
            0.00 AS SATIS_TUTAR_#merkez_depo_id#,
            0.00 AS SATIS_TUTAR_BRUT_#merkez_depo_id#,
            0.00 AS SATIS_TUTAR_BRUT_KDVSIZ_#merkez_depo_id#,
            0.00 AS ROW_ORT_#merkez_depo_id#,
        </cfif>
        (SELECT C.FULLNAME FROM #DSN_ALIAS#.COMPANY C WHERE C.COMPANY_ID = P.COMPANY_ID) AS COMPANY_NAME,
        (SELECT PP.PROJECT_HEAD FROM #DSN_ALIAS#.PRO_PROJECTS PP WHERE PP.PROJECT_ID = P.PROJECT_ID) AS PROJECT_NAME,
        S.STOCK_CODE,
        S.PRODUCT_NAME,
        S.PROPERTY,
        S.STOCK_ID,
        S.TAX,
        S.TAX_PURCHASE,
        PC.PRODUCT_CATID
	FROM 
        PRODUCT_CAT PC,
        STOCKS S
        	OUTER APPLY	(
            	SELECT TOP 1 
                    PT1.NEW_PRICE_KDV,
                    PT1.NEW_PRICE
                FROM
                    #DSN_DEV#.PRICE_TABLE PT1
                WHERE
                    PT1.IS_ACTIVE_S = 1 AND
                    PT1.STARTDATE <= #bugun_# AND 
                    DATEADD("d",-1,PT1.FINISHDATE) >= #bugun_# AND
                    ISNULL(PT1.STOCK_ID,S.STOCK_ID) = S.STOCK_ID AND 
                    PT1.PRODUCT_ID = S.PRODUCT_ID
                ORDER BY
                    PT1.STOCK_ID ASC,
                    PT1.STARTDATE DESC,
                    PT1.ROW_ID DESC
            ) PT_SATIS
            OUTER APPLY	(
            	SELECT TOP 1 
                    PT1.NEW_ALIS
                FROM
                    #DSN_DEV#.PRICE_TABLE PT1
                WHERE
                    PT1.IS_ACTIVE_P = 1 AND
                    PT1.P_STARTDATE <= #bugun_# AND 
                    DATEADD("d",-1,PT1.P_FINISHDATE) >= #bugun_# AND
                    ISNULL(PT1.STOCK_ID,S.STOCK_ID) = S.STOCK_ID AND 
                    PT1.PRODUCT_ID = S.PRODUCT_ID
                ORDER BY
                    PT1.STOCK_ID ASC,
                    PT1.P_STARTDATE DESC,
                    PT1.ROW_ID DESC
            ) PT_ALIS
        ,
        #dsn1_alias#.PRODUCT P
            LEFT JOIN PRODUCT_UNIT ON P.PRODUCT_ID = PRODUCT_UNIT.PRODUCT_ID
        	LEFT JOIN PRICE_STANDART ON P.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID
            LEFT JOIN PRICE_STANDART AS PS2 ON P.PRODUCT_ID = PS2.PRODUCT_ID
	WHERE	
		<cfif isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_head") and len(attributes.project_head)>
            P.PROJECT_ID IN (#attributes.project_id#) AND
        </cfif>
        <cfif isdefined('attributes.company_id') and len(attributes.company_id) and len(attributes.company)>
          	P.COMPANY_ID = #attributes.company_id# AND
        <cfelseif isdefined('attributes.consumer_id') and len(attributes.consumer_id) and len(attributes.company)>
            P.CONSUMER_ID= #attributes.consumer_id# AND
        </cfif>
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
        P.PRODUCT_STATUS = 1 AND
        PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
        PRICE_STANDART.PURCHASESALES = 0 AND
        PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID AND
        
        PS2.PRICESTANDART_STATUS = 1 AND
        PS2.PURCHASESALES = 1 AND
        PRODUCT_UNIT.PRODUCT_UNIT_ID = PS2.UNIT_ID AND
        
        
        S.PRODUCT_ID = P.PRODUCT_ID AND
        S.PRODUCT_CATID = PC.PRODUCT_CATID 
        <cfif listlen(p_cat_list) neq GET_PRODUCT_CAT3.recordcount>
        	AND PC.PRODUCT_CATID IN (#p_cat_list#)
        </cfif>
  ) T1
WHERE
	STOCK_CODE LIKE '%.%.%'
	<cfif isdefined("attributes.uretici") and listlen(attributes.uretici)>
    	AND SUB_TYPE_ID IN (#attributes.uretici#)
    </cfif>
ORDER BY
     STOCK_CODE ASC,
     PRODUCT_NAME ASC
</cfquery>


<cfset wrk_id = 'a_' & dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#userid_#_'&round(rand()*100)>

<cfif get_internaldemand.recordcount>
 <!---   <cftry>
    	<cfquery name="drop_" datasource="#dsn_dev#">
            DROP TABLE ##GlobalTempTablo_#wrk_id#
        </cfquery>
        <cfcatch type="any"></cfcatch>
    </cftry> --->
    
    
    <cfquery name="cretea_" datasource="#dsn_dev#">
    	CREATE TABLE ##GlobalTempTablo_#wrk_id#
        (
            STOCK_ID int
        )
    </cfquery>
    
    <cfoutput query="get_internaldemand">
    	<cfif currentrow eq 1 or stock_id neq stock_id[currentrow - 1]>
            <cfquery name="add_" datasource="#dsn_Dev#">
                INSERT INTO ##GlobalTempTablo_#wrk_id# values (#STOCK_ID#);
            </cfquery>
        </cfif>
    </cfoutput>
    
    
    <cfset stock_id_list = valuelist(get_internaldemand.stock_id)>
    
    <cfquery name="get_alimlar" datasource="#dsn_dev#" result="get_alimlar_r">
    	SELECT 
            SUM(GSR.SATIR_FIYATI * GSR.AMOUNT) AS ALIM_TUTAR,
            SUM(GSR.AMOUNT) AS ALIM_MIKTAR,
            GSR.STOCK_ID,
            GSR.DEPARTMENT_IN AS DEPARTMENT_ID
        FROM 
            GET_SHIP_ROWS_REAL GSR,
            ##GlobalTempTablo_#wrk_id# AAA
        WHERE
            GSR.DEPARTMENT_IN IN (#valuelist(get_list_departments.department_id)#) AND
            GSR.SHIP_TYPE = 76 AND
            GSR.SHIP_DATE >= #attributes.startdate# AND 
            GSR.SHIP_DATE <= #attributes.finishdate# AND 
            GSR.STOCK_ID = AAA.STOCK_ID
        GROUP BY
        	GSR.STOCK_ID,
            GSR.DEPARTMENT_IN
    </cfquery>
    
       

    
    
    <cfoutput query="get_alimlar">
    	<!---
    	<cfset 'alim_miktar_#stock_id#_#department_id#' = ALIM_MIKTAR>
        <cfset 'alim_tutar_#stock_id#_#department_id#' = ALIM_TUTAR>
		--->
        <cfif listfind(stock_id_list,stock_id)>
        	<cfset querysetcell(get_internaldemand,'ALIM_MIKTAR_#department_id#',ALIM_MIKTAR,listfind(stock_id_list,stock_id))>
            <cfset querysetcell(get_internaldemand,'ALIM_TUTAR_#department_id#',ALIM_TUTAR,listfind(stock_id_list,stock_id))>
        </cfif>
    </cfoutput>


	<cfif listfind(attributes.search_department_id,merkez_depo_id)>
		<cfoutput query="get_departments_search">
            <cfquery name="get_satis_#department_id#" datasource="#dsn_dev#" result="satis_donen">
                EXEC ortalama_satis_getir '#valuelist(get_internaldemand.stock_id)#',#attributes.startdate#,#attributes.finishdate#,#department_id#
            </cfquery>
        </cfoutput>
        
        <cfquery name="get_satis_all" dbtype="query">
			<cfoutput query="get_departments_search">
                SELECT ORAN,STOCK_ID,#department_id# AS DEPARTMENT_ID FROM get_satis_#department_id#
                <cfif currentrow neq get_departments_search.recordcount>UNION </cfif>
            </cfoutput>
        </cfquery>
    <cfelse>
    	<cfoutput query="get_list_departments">
            <cfquery name="get_satis_#department_id#" datasource="#dsn_dev#" result="satis_donen">
                EXEC ortalama_satis_getir '#valuelist(get_internaldemand.stock_id)#',#attributes.startdate#,#attributes.finishdate#,#department_id#
            </cfquery>
        </cfoutput>
        
        <cfquery name="get_satis_all" dbtype="query">
			<cfoutput query="get_list_departments">
                SELECT ORAN,STOCK_ID,#department_id# AS DEPARTMENT_ID FROM get_satis_#department_id#
                <cfif currentrow neq get_list_departments.recordcount>UNION </cfif>
            </cfoutput>
        </cfquery>
    </cfif>
    
    
    <cfquery name="get_satis" dbtype="query">
        SELECT SUM(ORAN) AS ORAN,STOCK_ID,DEPARTMENT_ID FROM get_satis_all WHERE DEPARTMENT_ID <> #merkez_depo_id# GROUP BY STOCK_ID,DEPARTMENT_ID
    </cfquery>
    
    <cfquery name="get_satis_merkez" dbtype="query">
        SELECT SUM(ORAN) AS ORAN,STOCK_ID FROM get_satis_all GROUP BY STOCK_ID
    </cfquery>
    
    
    
    <cfoutput query="get_satis">
    	<!--- <cfset 'row_ort_#stock_id#_#department_id#' = ORAN> --->
         <cfif listfind(stock_id_list,stock_id) and listfind(valuelist(get_list_departments.department_id),department_id)>
        	<cfset querysetcell(get_internaldemand,'ROW_ORT_#department_id#',ORAN,listfind(stock_id_list,stock_id))>
         </cfif>
    </cfoutput>
    
    <cfoutput query="get_satis_merkez">
        <!--- <cfset 'row_ort_#stock_id#_#merkez_depo_id#' = ORAN> --->
         <cfif listfind(stock_id_list,stock_id)>
        	<cfset querysetcell(get_internaldemand,'ROW_ORT_#merkez_depo_id#',ORAN,listfind(stock_id_list,stock_id))>
         </cfif>
    </cfoutput>

    <cfquery name="get_satis_tutarlar" datasource="#dsn_dev#" result="get_satis_tutarlar_r">
    SELECT
    	DEPARTMENT_ID,
        STOCK_ID,
        SUM(SATIS_MIKTAR) AS SATIS_MIKTAR,
        SUM(SATIS_TUTAR) AS SATIS_TUTAR,
        SUM(SATIS_TUTAR_BRUT) AS SATIS_TUTAR_BRUT,
        SUM(SATIS_TUTAR_BRUT_KDVSIZ) AS SATIS_TUTAR_BRUT_KDVSIZ
    FROM
    	(
                SELECT 
                    D.DEPARTMENT_ID,
                    GAR.STOCK_ID,
                    (CASE WHEN GA.FIS_IPTAL > 0  THEN 0 * (GAR.MIKTAR) WHEN ((GA.BELGE_TURU = '2' AND GAR.SATIR_IPTALMI = 0) OR (GA.BELGE_TURU <> '2' AND GAR.SATIR_IPTALMI = 1)) THEN -1  * (GAR.MIKTAR) ELSE (GAR.MIKTAR) END) AS SATIS_MIKTAR,
                    (CASE WHEN GA.FIS_IPTAL > 0  THEN 0 * (GAR.MIKTAR) WHEN ((GA.BELGE_TURU = '2' AND GAR.SATIR_IPTALMI = 0) OR (GA.BELGE_TURU <> '2' AND GAR.SATIR_IPTALMI = 1)) THEN -1  * (GAR.SATIR_TOPLAM - GAR.SATIR_INDIRIM - GAR.SATIR_PROMOSYON_INDIRIM - GAR.SATIR_KDV_TUTAR) ELSE (GAR.SATIR_TOPLAM - GAR.SATIR_PROMOSYON_INDIRIM - GAR.SATIR_INDIRIM - GAR.SATIR_KDV_TUTAR) END) AS SATIS_TUTAR,
                    (CASE WHEN GA.FIS_IPTAL > 0  THEN 0 * (GAR.MIKTAR) WHEN ((GA.BELGE_TURU = '2' AND GAR.SATIR_IPTALMI = 0) OR (GA.BELGE_TURU <> '2' AND GAR.SATIR_IPTALMI = 1)) THEN -1  * (GAR.SATIR_TOPLAM) ELSE (GAR.SATIR_TOPLAM) END) AS SATIS_TUTAR_BRUT,
                    (CASE WHEN GA.FIS_IPTAL > 0  THEN 0 * (GAR.MIKTAR) WHEN ((GA.BELGE_TURU = '2' AND GAR.SATIR_IPTALMI = 0) OR (GA.BELGE_TURU <> '2' AND GAR.SATIR_IPTALMI = 1)) THEN -1 * (GAR.SATIR_TOPLAM - GAR.SATIR_KDV_TUTAR) ELSE (GAR.SATIR_TOPLAM - GAR.SATIR_KDV_TUTAR) END) AS SATIS_TUTAR_BRUT_KDVSIZ
                FROM
                    #dsn_dev_alias#.GENIUS_ACTIONS GA,
                    #dsn_dev_alias#.GENIUS_ACTIONS_ROWS GAR,
                    #dsn_alias#.DEPARTMENT D
                WHERE
                    GA.FIS_TARIHI >= #attributes.startdate# AND 
                    GA.FIS_TARIHI < #dateadd('d',1,attributes.finishdate)# AND
                    GA.ACTION_ID = GAR.ACTION_ID AND
                    GA.DEPARTMENT_ID = D.DEPARTMENT_ID AND
                    GAR.STOCK_ID IN (SELECT STOCK_ID FROM ##GlobalTempTablo_#wrk_id#)
            UNION ALL
                SELECT 
                    GSRA.DELIVER_STORE_ID AS DEPARTMENT_ID,
                    GSRA.STOCK_ID,
                    (GSRA.AMOUNT) AS SATIS_MIKTAR,
                    (GSRA.NETTOTAL) AS SATIS_TUTAR,
                    (GSRA.GROSSTOTAL) AS SATIS_TUTAR_BRUT,
                    (GSRA.GROSSTOTAL - TAXTOTAL) AS SATIS_TUTAR_BRUT_KDVSIZ
                FROM
                    GET_SHIP_ROWS_REAL GSRA
                WHERE
                    (
                    GSRA.SHIP_TYPE = 70 AND GSRA.PROCESS_CAT <> 114 
                    OR
                    GSRA.SHIP_TYPE = 71
                    )
                    AND
                    GSRA.SHIP_DATE >= #attributes.startdate# AND 
                    GSRA.SHIP_DATE < #dateadd('d',1,attributes.finishdate)# AND
                    GSRA.STOCK_ID IN (SELECT STOCK_ID FROM ##GlobalTempTablo_#wrk_id#)
       ) T1
    GROUP BY
    	DEPARTMENT_ID,
        STOCK_ID
    </cfquery>
    
    
    
    <!--- <cfset t_total_row_total_satis_tutar = 0> --->
    <!--- <cfset t_total_row_total_satis_tutar_brut = 0> --->
    <!--- <cfset t_total_row_total_satis_tutar_brut_kdvsiz = 0>--->
    
    <cfquery name="get_totals" dbtype="query">
    	SELECT
        	SUM(SATIS_TUTAR) AS SATIS_TUTAR_ALL,
            SUM(SATIS_TUTAR_BRUT) AS SATIS_TUTAR_BRUT_ALL,
            SUM(SATIS_TUTAR_BRUT_KDVSIZ) AS SATIS_TUTAR_BRUT_KDVSIZ_ALL
        FROM
        	get_satis_tutarlar
    </cfquery>

    <cfset g_total_row_total_satis_tutar = get_totals.SATIS_TUTAR_ALL>
	<cfset g_total_row_total_satis_tutar_brut = get_totals.SATIS_TUTAR_BRUT_ALL>
    <cfset g_total_row_total_satis_tutar_brut_kdvsiz = get_totals.SATIS_TUTAR_BRUT_KDVSIZ_ALL>
    
    <cfoutput query="get_satis_tutarlar">
		<!---
		<cfset 'satis_miktar_#STOCK_ID#_#DEPARTMENT_ID#' = SATIS_MIKTAR>
		<cfset 'satis_tutar_#STOCK_ID#_#DEPARTMENT_ID#' = SATIS_TUTAR>
        <cfset 'satis_tutar_brut_#STOCK_ID#_#DEPARTMENT_ID#' = SATIS_TUTAR_BRUT>
        <cfset 'satis_tutar_brut_kdvsiz_#STOCK_ID#_#DEPARTMENT_ID#' = SATIS_TUTAR_BRUT_KDVSIZ>
		--->
        <cfif listfind(stock_id_list,stock_id) and listfind(valuelist(get_list_departments.department_id),department_id)>
        	<cfset querysetcell(get_internaldemand,'SATIS_MIKTAR_#department_id#',SATIS_MIKTAR,listfind(stock_id_list,stock_id))>
            <cfset querysetcell(get_internaldemand,'SATIS_TUTAR_#department_id#',SATIS_TUTAR,listfind(stock_id_list,stock_id))>
            <cfset querysetcell(get_internaldemand,'SATIS_TUTAR_BRUT_#department_id#',SATIS_TUTAR_BRUT,listfind(stock_id_list,stock_id))>
            <cfset querysetcell(get_internaldemand,'SATIS_TUTAR_BRUT_KDVSIZ_#department_id#',SATIS_TUTAR_BRUT_KDVSIZ,listfind(stock_id_list,stock_id))>
        </cfif>
    </cfoutput>
    
 <!---
   <cfdump var="#get_satis_tutarlar_r#">
    <cfdump var="#donus#">
    <cfdump var="#get_alimlar_r#">
    <cfdump var="#now()#">
    <cfabort>
	--->
</cfif> 

   <cftry>
    	<cfquery name="drop_" datasource="#dsn_dev#">
            DROP TABLE ##GlobalTempTablo_#wrk_id#
        </cfquery>
        <cfcatch type="any"></cfcatch>
    </cftry>



<cfset last_birinci_ = "">
<cfset last_ikinci_ = "">
<cfset last_ucuncu_ = "">


<cfset name_list = "id,row_type,sira,altgrup1,altgrup2,company_name,project_name,marka,ambalaj,stok_id,stok,alis_kdv,satis_kdv">
<cfoutput query="get_list_departments">
	<cfif isdefined("attributes.is_department_multi")>
    	<cfset name_list = listappend(name_list,'d_stok_yeter_#department_id#,d_ort_satis_#department_id#,d_tutar_yuzde_#department_id#,d_guncel_stok_#department_id#,d_guncel_stok_tutar_haric_#department_id#,d_alis_miktar_#department_id#,d_alis_tutar_#department_id#,d_satis_miktar_#department_id#,d_satis_tutar_#department_id#,d_satis_brut_kdvsiz_#department_id#,d_satis_brut_kdvli_#department_id#')>
    </cfif>
</cfoutput>
<cfset name_list = listappend(name_list,'t_stok_yeter,t_ort_satis,s_tutar_yuzde,t_guncel_stok,t_guncel_stok_tutar_haric,t_alis_miktar,t_alis_tutar,t_satis_miktar,t_satis_tutar,t_satis_brut_kdvsiz,t_satis_brut_kdvli,t_liste_fiyat')>

<cfset turkce_name_list = "ID,Satır Tipi,Sıra,Alt Grup 1,Alt Grup 2,Firma,Proje,Marka,Ambalaj,Stok ID,Stok,Alış KDV,Satış KDV">
<cfoutput query="get_list_departments">
	<cfif isdefined("attributes.is_department_multi")>
    	<cfset turkce_name_list = listappend(turkce_name_list,'Stok Yeter,Ortalama Satış,Yüzde,Stok,Stok Tutar,Alış Miktar,Alış Tutar,Satış Miktar,Satış Tutar,KDVsiz Brüt Satış,Kdvli Brüt Satış')>
    </cfif>
</cfoutput>
<cfset turkce_name_list = listappend(turkce_name_list,'Stok Yeter,Ortalama Satış,Yüzde,Stok,Stok Tutar,Alış Miktar,Alış Tutar,Satış Miktar,Satış Tutar,KDVsiz Brüt Satış,Kdvli Brüt Satış,Fiyat')>


<!---
<cfoutput query="get_internaldemand">
	<cfloop from="1" to="#get_list_departments.recordcount#" index="dept">
		<cfset dept_ = get_list_departments.department_id[dept]>
		
		<cfif isdefined("satis_miktar_#stock_id#_#dept_#")>
			<cfset satis_ = evaluate("satis_miktar_#stock_id#_#dept_#")>
		<cfelse>
			<cfset satis_ = 0>
		</cfif>
		
		<cfset 'satis_#dept_#' = satis_>
		
		<cfif isdefined("SATIS_TUTAR_#stock_id#_#dept_#")>
			<cfset satis_tutar_ = evaluate("SATIS_TUTAR_#stock_id#_#dept_#")>
			<cfset satis_tutar_brut_ = evaluate("SATIS_TUTAR_BRUT_#stock_id#_#dept_#")>
			<cfset satis_tutar_brut_kdvsiz_ = evaluate("SATIS_TUTAR_BRUT_KDVSIZ_#stock_id#_#dept_#")>
		<cfelse>
			<cfset satis_tutar_ = 0>
			<cfset satis_tutar_brut_ = 0>
			<cfset satis_tutar_brut_kdvsiz_ = 0>
		</cfif>
		
		<cfset g_total_row_total_satis_tutar = g_total_row_total_satis_tutar + satis_tutar_>
		<!--- <cfset t_total_row_total_satis_tutar = t_total_row_total_satis_tutar + satis_tutar_> --->
		
		<cfset g_total_row_total_satis_tutar_brut = g_total_row_total_satis_tutar_brut + satis_tutar_brut_>
		<!--- <cfset t_total_row_total_satis_tutar_brut = t_total_row_total_satis_tutar_brut + satis_tutar_brut_> --->
		
		<cfset g_total_row_total_satis_tutar_brut_kdvsiz = g_total_row_total_satis_tutar_brut_kdvsiz + satis_tutar_brut_kdvsiz_>
		<!--- <cfset t_total_row_total_satis_tutar_brut_kdvsiz = t_total_row_total_satis_tutar_brut_kdvsiz + satis_tutar_brut_kdvsiz_> --->
	</cfloop>
</cfoutput>
--->


<cfset last_group_id_ = "">

<cfset group_total_stok = 0>
<cfset group_total_stok_tutar = 0>

<cfset group_total_alim = 0>
<cfset group_total_alim_tutar = 0>

<cfset group_total_satis = 0>
<cfset group_total_satis_tutar = 0>

<cfset group_yeterlilik = 0>
<cfset group_ortalama_satis = 0>

<cfset group_stock_count = 0>


<cfset group_row_total_stok = 0>
<cfset group_row_total_stok_tutar = 0>

<cfset group_row_total_alim = 0>
<cfset group_row_total_alim_tutar = 0>

<cfset group_row_total_satis = 0>
<cfset group_row_total_satis_tutar = 0>
<cfset group_row_total_satis_tutar_liste = 0>
<cfset group_row_total_satis_tutar_brut = 0>
<cfset group_row_total_satis_tutar_brut_kdvsiz = 0>

<cfset group_row_yeterlilik = 0>
<cfset group_row_ortalama_satis = 0>

<cfset group_row_stock_count = 0>
<cfset group_row_satis_yuzdelik = 0>

<cfset t_total_stok = 0>
<cfset t_total_stok_tutar = 0>

<cfset t_total_alim = 0>
<cfset t_total_alim_tutar = 0>

<cfset t_total_satis = 0>
<cfset t_total_satis_tutar = 0>

<cfset t_yeterlilik = 0>
<cfset t_ortalama_satis = 0>

<cfset t_stock_count = 0>


<cfset t_row_total_stok = 0>
<cfset t_row_total_stok_tutar = 0>

<cfset t_row_total_alim = 0>
<cfset t_row_total_alim_tutar = 0>

<cfset t_row_total_satis = 0>
<cfset t_row_total_satis_tutar = 0>
<cfset t_row_total_satis_tutar_liste = 0>
<cfset t_row_total_satis_tutar_brut = 0>
<cfset t_row_total_satis_tutar_brut_kdvsiz = 0>

<cfset t_row_yeterlilik = 0>
<cfset t_row_ortalama_satis = 0>

<cfset t_row_stock_count = 0>
<cfset t_row_satis_yuzdelik = 0>


<cfoutput query="get_list_departments">
	<cfset 'group_total_stok_#department_id#' = 0>
	<cfset 'group_total_stok_tutar_#department_id#' = 0>
	
	<cfset 'group_total_alim_#department_id#' = 0>
	<cfset 'group_total_alim_tutar_#department_id#' = 0>
	
	<cfset 'group_total_satis_#department_id#' = 0>
	<cfset 'group_total_satis_tutar_#department_id#' = 0>
	
	<cfset 'group_yeterlilik_#department_id#' = 0>
	<cfset 'group_ortalama_satis_#department_id#' = 0>
	
	<cfset 'group_stock_count_#department_id#' = 0>
</cfoutput>



<cfset CRLF = Chr(13) & Chr(10)>
<cfset dataset = "">
<cfset icerik_2_son = "">
<cfif get_internaldemand.recordcount>
<cfoutput query="get_internaldemand">
	<cfset row_total_stok = 0>
	<cfset row_total_stok_tutar = 0>
    
    <cfset row_total_alim = 0>
    <cfset row_total_alim_tutar = 0>
    
    <cfset row_total_satis = 0>
    <cfset row_total_satis_tutar = 0>
    <cfset row_total_satis_tutar_brut = 0>
    <cfset row_total_satis_tutar_brut_kdvsiz = 0>
    
    <cfset row_yeterlilik = 0>
    <cfset row_ortalama_satis = 0>
    
    <cfset birinci_ = listfirst(stock_code,'.')>
    <cfset ikinci_ = birinci_ & '.' & listgetat(stock_code,2,'.')>
    <cfset ucuncu_ = ikinci_ & '.' & listgetat(stock_code,3,'.')>


	<cfset row_ = "">
	
    
    <cfset r_number = '1' & round(rand()*100) & '00' & dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'#userid_##stock_id#'&round(rand()*100)>
    <cfset deger_ = '"id":"#r_number#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    
	<cfset deger_ = '"row_type":"1"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    <cfset deger_ = '"sira":"#currentrow#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    
    <cfsavecontent variable="icerik_1">
    	<cfif not len(last_ikinci_) or last_ikinci_ is not ikinci_>
			<cfset sira_ = listfind(hierarchy_list,ikinci_)>
            <cfif sira_ neq 0>#listgetat(hierarchy_name_list,sira_,'╗')#</cfif>
        </cfif>
    </cfsavecontent>
    
    <cfsavecontent variable="icerik_2">
    	<cfif not len(last_ucuncu_) or last_ucuncu_ is not ucuncu_>
			<cfset sira_ = listfind(hierarchy_list,ucuncu_)>
            <cfif sira_ neq 0>
                #listgetat(hierarchy_name_list,sira_,'╗')#
                <cfset icerik_2_son = listgetat(hierarchy_name_list,sira_,'╗')>
                <cfset last_group_id_ = listgetat(hierarchy_name_list,sira_,'╗')>
            </cfif>
        </cfif>
    </cfsavecontent>
    
    <cfsavecontent variable="link_">#replacelist(PROPERTY,'+,%,},!','_,_,_,_')#</cfsavecontent>
    <cfsavecontent variable="company_name_">#replacelist(company_name,'(,),},!','_,_,_,_')#</cfsavecontent>
    <cfsavecontent variable="project_name_">#PROJECT_NAME#</cfsavecontent>
    
    <cfset deger_ = '"altgrup1":"#icerik_1#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    <cfset deger_ = '"altgrup2":"#icerik_2#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    <cfset deger_ = '"company_name":"#company_name_#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    <cfset deger_ = '"project_name":"#project_name_#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    <cfset deger_ = '"marka":"#marka#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    <cfset deger_ = '"ambalaj":"#ambalaj#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    <cfset deger_ = '"stok_id":"#stock_id#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    <cfset deger_ = '"stok":"#link_#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    <cfset deger_ = '"alis_kdv":"#tax_purchase#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    <cfset deger_ = '"satis_kdv":"#tax#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    
    <cfloop from="1" to="#get_list_departments.recordcount#" index="dept">
		<cfset dept_ = get_list_departments.department_id[dept]>
                        
		<cfif isdefined('row_ort_#dept_#')>
            <cfset ort_satis_ = evaluate("row_ort_#dept_#")>
        <cfelse>
            <cfset ort_satis_ = 0>
        </cfif>
        
        <cfset stok_ = evaluate("STOCK_#dept_#")>
        
        <!---
        <cfif isdefined("alim_miktar_#stock_id#_#dept_#")>
            <cfset alim_ = evaluate("alim_miktar_#stock_id#_#dept_#")>
            <cfset alim_tutar_ = evaluate("alim_tutar_#stock_id#_#dept_#")>
        <cfelse>
            <cfset alim_ = 0>
            <cfset alim_tutar_ = 0>
        </cfif>
		--->
        <cfif isdefined("alim_miktar_#dept_#")>
            <cfset alim_ = evaluate("alim_miktar_#dept_#")>
            <cfset alim_tutar_ = evaluate("alim_tutar_#dept_#")>
        <cfelse>
            <cfset alim_ = 0>
            <cfset alim_tutar_ = 0>
        </cfif>
        
        <!---
        <cfif isdefined("satis_miktar_#stock_id#_#dept_#")>
            <cfset satis_ = evaluate("satis_miktar_#stock_id#_#dept_#")>
        <cfelse>
            <cfset satis_ = 0>
        </cfif>
		--->
        
        <cfif isdefined("satis_miktar_#dept_#")>
            <cfset satis_ = evaluate("satis_miktar_#dept_#")>
        <cfelse>
            <cfset satis_ = 0>
        </cfif>
        
        
        <cfset 'satis_#dept_#' = satis_>
        
        <!---
        <cfif isdefined("SATIS_TUTAR_#stock_id#_#dept_#")>
            <cfset satis_tutar_ = evaluate("SATIS_TUTAR_#stock_id#_#dept_#")>
            <cfset satis_tutar_brut_ = evaluate("SATIS_TUTAR_BRUT_#stock_id#_#dept_#")>
            <cfset satis_tutar_brut_kdvsiz_ = evaluate("SATIS_TUTAR_BRUT_KDVSIZ_#stock_id#_#dept_#")>
        <cfelse>
            <cfset satis_tutar_ = 0>
            <cfset satis_tutar_brut_ = 0>
            <cfset satis_tutar_brut_kdvsiz_ = 0>
        </cfif>
		--->
        <cfif isdefined("SATIS_TUTAR_#dept_#")>
            <cfset satis_tutar_ = evaluate("SATIS_TUTAR_#dept_#")>
            <cfset satis_tutar_brut_ = evaluate("SATIS_TUTAR_BRUT_#dept_#")>
            <cfset satis_tutar_brut_kdvsiz_ = evaluate("SATIS_TUTAR_BRUT_KDVSIZ_#dept_#")>
        <cfelse>
            <cfset satis_tutar_ = 0>
            <cfset satis_tutar_brut_ = 0>
            <cfset satis_tutar_brut_kdvsiz_ = 0>
        </cfif>
        
        <cfif stok_ gt 0 and ort_satis_ gt 0>
            <cfset yeterlilik_ = wrk_round(stok_ / ort_satis_)>
        <cfelse>
            <cfset yeterlilik_ = 0>
        </cfif>
        
        <cfset row_total_stok = row_total_stok + stok_>
        <cfset row_total_stok_tutar = row_total_stok_tutar + (stok_ * liste_fiyati_alis)>
        
        <cfset row_total_alim = row_total_alim + alim_>
        <cfset row_total_alim_tutar = row_total_alim_tutar + alim_tutar_>
        
        <cfset row_total_satis = row_total_satis + satis_>
        <cfset row_total_satis_tutar = row_total_satis_tutar + satis_tutar_>
        <cfset row_total_satis_tutar_brut = row_total_satis_tutar_brut + satis_tutar_brut_>
        <cfset row_total_satis_tutar_brut_kdvsiz = row_total_satis_tutar_brut_kdvsiz + satis_tutar_brut_kdvsiz_>
        
        <cfset row_yeterlilik = row_yeterlilik + yeterlilik_>
        
        <cfset 'group_total_stok_#dept_#' = evaluate('group_total_stok_#dept_#') + stok_>
        <cfset 'group_total_stok_tutar_#dept_#' = evaluate('group_total_stok_tutar_#dept_#') + (stok_ * liste_fiyati_alis)>
        
        <cfset 'group_total_alim_#dept_#' = evaluate('group_total_alim_#dept_#') + alim_>
        <cfset 'group_total_alim_tutar_#dept_#' = evaluate('group_total_alim_tutar_#dept_#') + alim_tutar_>
        
        <cfset 'group_total_satis_#dept_#' = evaluate('group_total_satis_#dept_#') + satis_>
        <cfset 'group_total_satis_tutar_#dept_#' = evaluate('group_total_satis_tutar_#dept_#') + satis_tutar_>
        
        <cfif stok_ gt 0 and ort_satis_ gt 0>
            <cfset 'group_yeterlilik_#dept_#' = evaluate('group_yeterlilik_#dept_#') + yeterlilik_>
            <cfset 'group_ortalama_satis_#dept_#' = evaluate('group_ortalama_satis_#dept_#') + ort_satis_>
            
            <cfset 'group_stock_count_#dept_#' = evaluate('group_stock_count_#dept_#') + 1>
        </cfif>
        
        <cfif get_list_departments.department_id[dept] neq merkez_depo_id or (get_list_departments.recordcount eq 1 and get_list_departments.department_id eq merkez_depo_id)>
            <cfset row_ortalama_satis = row_ortalama_satis + ort_satis_>
        </cfif>
        
		<cfif isdefined("attributes.is_department_multi")>
			<cfset deger_ = '"d_stok_yeter_#dept_#":"#wrk_round(yeterlilik_)#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
            <cfset deger_ = '"d_ort_satis_#dept_#":"#wrk_round(ort_satis_)#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
            <cfset deger_ = '"d_tutar_yuzde_#dept_#":""'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
            <cfset deger_ = '"d_guncel_stok_#dept_#":"#wrk_round(stok_)#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
            <cfset deger_ = '"d_guncel_stok_tutar_haric_#dept_#":"#wrk_round(stok_ * liste_fiyati_alis)#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
            <cfset deger_ = '"d_alis_miktar_#dept_#":"#wrk_round(alim_)#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
            <cfset deger_ = '"d_alis_tutar_#dept_#":"#wrk_round(alim_tutar_)#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
            <cfset deger_ = '"d_satis_miktar_#dept_#":"#wrk_round(satis_)#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
            <cfset deger_ = '"d_satis_tutar_#dept_#":"#wrk_round(satis_tutar_)#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
            <cfset deger_ = '"d_satis_brut_kdvsiz_#dept_#":"#wrk_round(satis_tutar_brut_kdvsiz_)#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
            <cfset deger_ = '"d_satis_brut_kdvli_#dept_#":"#wrk_round(satis_tutar_brut_)#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
       </cfif>
    </cfloop>
    
    <cfif row_total_satis_tutar gt 0>
		<cfset row_satis_yuzdelik = wrk_round(row_total_satis_tutar * 100 / g_total_row_total_satis_tutar)>
    <cfelse>
        <cfset row_satis_yuzdelik = 0>
    </cfif>

    <cfset group_row_total_stok = group_row_total_stok + row_total_stok>
    <cfset group_row_total_stok_tutar = group_row_total_stok_tutar + row_total_stok_tutar>
    
    <cfset group_row_total_alim = group_row_total_alim + row_total_alim>
    <cfset group_row_total_alim_tutar = group_row_total_alim_tutar + row_total_alim_tutar>
    
    <cfset group_row_total_satis = group_row_total_satis + row_total_satis>
    <cfset group_row_total_satis_tutar = group_row_total_satis_tutar + row_total_satis_tutar>
    <cfset group_row_total_satis_tutar_brut = group_row_total_satis_tutar_brut + row_total_satis_tutar_brut>
    <cfset group_row_total_satis_tutar_brut_kdvsiz = group_row_total_satis_tutar_brut_kdvsiz + row_total_satis_tutar_brut_kdvsiz>
    
    <cfif row_total_stok gt 0 and row_ortalama_satis gt 0>
        <cfset group_row_yeterlilik = group_row_yeterlilik + row_yeterlilik>
        <cfset group_row_ortalama_satis = group_row_ortalama_satis + row_ortalama_satis>
        
        <cfset group_row_stock_count = group_row_stock_count + 1>
    </cfif>
    
    <cfset group_row_satis_yuzdelik = group_row_satis_yuzdelik + row_satis_yuzdelik>
    
    <cfset t_row_total_stok = t_row_total_stok + row_total_stok>
    <cfset t_total_stok_tutar = t_row_total_stok_tutar + row_total_stok_tutar>
    
    <cfset t_row_total_alim = t_row_total_alim + row_total_alim>
    <cfset t_row_total_alim_tutar = t_row_total_alim_tutar + row_total_alim_tutar>
    
    <cfset t_row_total_satis = t_row_total_satis + row_total_satis>
    <cfset t_row_total_satis_tutar = t_row_total_satis_tutar + row_total_satis_tutar>
    <cfset t_row_total_satis_tutar_brut = t_row_total_satis_tutar_brut + row_total_satis_tutar_brut>
    <cfset t_row_total_satis_tutar_brut_kdvsiz = t_row_total_satis_tutar_brut_kdvsiz + row_total_satis_tutar_brut_kdvsiz>
    
    <cfif row_total_stok gt 0 and row_ortalama_satis gt 0>
        <cfset t_row_yeterlilik = t_row_yeterlilik + row_yeterlilik>
        <cfset t_row_ortalama_satis = t_row_ortalama_satis + row_ortalama_satis>
        
        <cfset t_row_stock_count = t_row_stock_count + 1>
    </cfif>
    
    <cfset t_row_satis_yuzdelik = t_row_satis_yuzdelik + row_satis_yuzdelik>
    
    <cfif row_ortalama_satis gt 1 and row_ortalama_satis lte 1.99>
        <cfset o_color = "##FFFF66">
    <cfelseif row_ortalama_satis gt 2 and row_ortalama_satis lte 3.99>
        <cfset o_color = "##CCFF66">
    <cfelseif row_ortalama_satis gt 4>
        <cfset o_color = "##00FF00">
    <cfelse>
        <cfset o_color = "##FFFFFF">
    </cfif>
    
    <cfset deger_ = '"t_stok_yeter":"#wrk_round(row_yeterlilik)#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
	<cfset deger_ = '"t_ort_satis":"#wrk_round(row_ortalama_satis)#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    <cfset deger_ = '"s_tutar_yuzde":"% #wrk_round(row_satis_yuzdelik)#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    <cfset deger_ = '"t_guncel_stok":"#wrk_round(row_total_stok)#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    <cfset deger_ = '"t_guncel_stok_tutar_haric":"#wrk_round(row_total_stok_tutar)#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    <cfset deger_ = '"t_alis_miktar":"#wrk_round(row_total_alim)#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    <cfset deger_ = '"t_alis_tutar":"#wrk_round(row_total_alim_tutar)#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    <cfset deger_ = '"t_satis_miktar":"#wrk_round(row_total_satis)#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    <cfset deger_ = '"t_satis_tutar":"#wrk_round(row_total_satis_tutar)#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    <cfset deger_ = '"t_satis_brut_kdvsiz":"#wrk_round(row_total_satis_tutar_brut_kdvsiz)#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    <cfset deger_ = '"t_satis_brut_kdvli":"#wrk_round(row_total_satis_tutar_brut)#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    <cfset deger_ = '"t_liste_fiyat":"#wrk_round(LISTE_FIYATI_SATIS_KDV)#"'> <cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
      
    <cfset dataset = listappend(dataset,"{#row_##CRLF#}")>
    
    <cfif currentrow eq get_internaldemand.recordcount or PRODUCT_CATID neq PRODUCT_CATID[currentrow+1]>
    	<cfset row_ = "">
		
		<cfset r_number = '2' & round(rand()*100) & '00' & dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'#userid_#'&round(rand()*100)&round(rand()*100)&round(rand()*100)>
		<cfset deger_ = '"id":"#r_number#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
		
		<cfset deger_ = '"row_type":"2"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
		<cfset deger_ = '"sira":""'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
        <cfset deger_ = '"altgrup1":""'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
		<cfset deger_ = '"altgrup2":""'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
        <cfset deger_ = '"company_name":""'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    	<cfset deger_ = '"project_name":""'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
        <cfset deger_ = '"marka":""'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
        <cfset deger_ = '"ambalaj":""'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
        <cfset deger_ = '"stok_id":""'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
        <cfset deger_ = '"stok":"#icerik_2_son# Ara Toplam"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
        <cfset deger_ = '"alis_kdv":""'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
        <cfset deger_ = '"satis_kdv":""'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
        
        <cfloop from="1" to="#get_list_departments.recordcount#" index="dept">
             <cfset dept_ = get_list_departments.department_id[dept]>
             <cfsavecontent variable="ic_1">
             	<cfif evaluate('group_yeterlilik_#dept_#') gt 0>
                    #wrk_round(evaluate('group_yeterlilik_#dept_#') / evaluate('group_stock_count_#dept_#'))#
                </cfif>
             </cfsavecontent>
             <cfsavecontent variable="ic_2">
             	<cfif evaluate('group_ortalama_satis_#dept_#') gt 0>
                    #wrk_round(evaluate('group_ortalama_satis_#dept_#') / evaluate('group_stock_count_#dept_#'))#
                </cfif>
             </cfsavecontent>
             
            <cfif isdefined("attributes.is_department_multi")>
				<cfset deger_ = '"d_stok_yeter_#dept_#":"#ic_1#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
                <cfset deger_ = '"d_ort_satis_#dept_#":"#ic_2#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
                <cfset deger_ = '"d_tutar_yuzde_#dept_#":""'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
                <cfset deger_ = '"d_guncel_stok_#dept_#":"#wrk_round(Evaluate('group_total_stok_#dept_#'))#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
                <cfset deger_ = '"d_guncel_stok_tutar_haric_#dept_#":"#wrk_round(Evaluate('group_total_stok_tutar_#dept_#'))#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
                <cfset deger_ = '"d_alis_miktar_#dept_#":"#wrk_round(Evaluate('group_total_alim_#dept_#'))#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
                <cfset deger_ = '"d_alis_tutar_#dept_#":"#wrk_round(Evaluate('group_total_alim_tutar_#dept_#'))#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
                <cfset deger_ = '"d_satis_miktar_#dept_#":"#wrk_round(Evaluate('group_total_satis_#dept_#'))#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
                <cfset deger_ = '"d_satis_tutar_#dept_#":"#wrk_round(Evaluate('group_total_satis_tutar_#dept_#'))#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
                <cfset deger_ = '"d_satis_brut_kdvsiz_#dept_#":""'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
                <cfset deger_ = '"d_satis_brut_kdvli_#dept_#":""'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
        	</cfif>
        </cfloop>
        	
        
		<cfsavecontent variable="ic1"><cfif group_row_yeterlilik gt 0>#wrk_round(group_row_yeterlilik / group_row_stock_count)#</cfif></cfsavecontent>
		<cfsavecontent variable="ic2"><cfif group_row_ortalama_satis gt 0>#wrk_round(group_row_ortalama_satis / group_row_stock_count)#</cfif></cfsavecontent>
        
		<cfset deger_ = '"t_stok_yeter":"#ic1#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
		<cfset deger_ = '"t_ort_satis":"#ic2#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
        <cfset deger_ = '"s_tutar_yuzde":"% #wrk_round(group_row_satis_yuzdelik)#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
        <cfset deger_ = '"t_guncel_stok":"#wrk_round(group_row_total_stok)#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
        <cfset deger_ = '"t_guncel_stok_tutar_haric":"#wrk_round(group_row_total_stok_tutar)#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
        <cfset deger_ = '"t_alis_miktar":"#wrk_round(group_row_total_alim)#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
        <cfset deger_ = '"t_alis_tutar":"#wrk_round(group_row_total_alim_tutar)#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
        <cfset deger_ = '"t_satis_miktar":"#wrk_round(group_row_total_satis)#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
        <cfset deger_ = '"t_satis_tutar":"#wrk_round(group_row_total_satis_tutar)#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
        <cfset deger_ = '"t_satis_brut_kdvsiz":"#wrk_round(group_row_total_satis_tutar_brut_kdvsiz)#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
        <cfset deger_ = '"t_satis_brut_kdvli":"#wrk_round(group_row_total_satis_tutar_brut)#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
        <cfset deger_ = '"t_liste_fiyat":""'> <cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
        
        <cfset dataset = listappend(dataset,"{#row_##CRLF#}")>
        
        <cfloop from="1" to="#get_list_departments.recordcount#" index="dept">
			<cfset dept_ = get_list_departments.department_id[dept]>
            <cfset 'group_total_stok_#dept_#' = 0>
            <cfset 'group_total_stok_tutar_#dept_#' = 0>
            
            <cfset 'group_total_alim_#dept_#' = 0>
            <cfset 'group_total_alim_tutar_#dept_#' = 0>
            
            <cfset 'group_total_satis_#dept_#' = 0>
            <cfset 'group_total_satis_tutar_#dept_#' = 0>
            
            <cfset 'group_yeterlilik_#dept_#' = 0>
            <cfset 'group_ortalama_satis_#dept_#' = 0>
            
            <cfset 'group_stock_count_#dept_#' = 0>
        </cfloop>
        
        <cfset group_row_total_stok = 0>
        <cfset group_row_total_stok_tutar = 0>
        
        <cfset group_row_total_alim = 0>
        <cfset group_row_total_alim_tutar = 0>
        
        <cfset group_row_total_satis = 0>
        <cfset group_row_total_satis_tutar = 0>
        <cfset group_row_total_satis_tutar_liste = 0>
        <cfset group_row_total_satis_tutar_brut = 0>
        <cfset group_row_total_satis_tutar_brut_kdvsiz = 0>
        
        <cfset group_row_yeterlilik = 0>
        <cfset group_row_ortalama_satis = 0>
        
        <cfset group_row_stock_count = 0>
        
        <cfset group_row_satis_yuzdelik = 0>
    </cfif>
    
    	<cfset last_birinci_ = birinci_>
		<cfset last_ikinci_ = ikinci_>
        <cfset last_ucuncu_ = ucuncu_>
</cfoutput>
</cfif>

<cfset row_ = "">

<cfset r_number = '3' & round(rand()*100) & '00' & dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'#userid_#'&round(rand()*100)>
<cfset deger_ = '"id":"#r_number#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    
<cfset deger_ = '"row_type":"3"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
<cfset deger_ = '"sira":""'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
<cfset deger_ = '"altgrup1":""'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
<cfset deger_ = '"altgrup2":""'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
<cfset deger_ = '"company_name":""'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
<cfset deger_ = '"project_name":""'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
<cfset deger_ = '"marka":""'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
<cfset deger_ = '"ambalaj":""'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
<cfset deger_ = '"stok_id":""'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
<cfset deger_ = '"stok":"Genel Toplam"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
<cfset deger_ = '"alis_kdv":""'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
<cfset deger_ = '"satis_kdv":""'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
<cfif get_list_departments.recordcount>
<cfoutput query="get_list_departments">
	<cfif isdefined("attributes.is_department_multi")>
		<cfset deger_ = '"d_stok_yeter_#dept_#":""'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
        <cfset deger_ = '"d_ort_satis_#dept_#":""'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
        <cfset deger_ = '"d_tutar_yuzde_#dept_#":""'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
        <cfset deger_ = '"d_guncel_stok_#dept_#":""'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
        <cfset deger_ = '"d_guncel_stok_tutar_haric_#dept_#":""'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
        <cfset deger_ = '"d_alis_miktar_#dept_#":""'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
        <cfset deger_ = '"d_alis_tutar_#dept_#":""'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
        <cfset deger_ = '"d_satis_miktar_#dept_#":""'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
        <cfset deger_ = '"d_satis_tutar_#dept_#":""'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
        <cfset deger_ = '"d_satis_brut_kdvsiz_#dept_#":""'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
        <cfset deger_ = '"d_satis_brut_kdvli_#dept_#":""'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    </cfif>
</cfoutput>
</cfif>
<cfoutput>
    <cfsavecontent variable="ic1"><cfif t_row_yeterlilik gt 0>#wrk_round(t_row_yeterlilik / t_row_stock_count)#</cfif></cfsavecontent>
    <cfsavecontent variable="ic2"><cfif t_row_ortalama_satis gt 0>#wrk_round(t_row_ortalama_satis / t_row_stock_count)#</cfif></cfsavecontent>
    
    <cfset deger_ = '"t_stok_yeter":"#ic1#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    <cfset deger_ = '"t_ort_satis":"#ic2#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    <cfset deger_ = '"s_tutar_yuzde":"% #wrk_round(t_row_satis_yuzdelik)#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    <cfset deger_ = '"t_guncel_stok":"#wrk_round(t_row_total_stok)#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    <cfset deger_ = '"t_guncel_stok_tutar_haric":"#wrk_round(t_row_total_stok_tutar)#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    <cfset deger_ = '"t_alis_miktar":"#wrk_round(t_row_total_alim)#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    <cfset deger_ = '"t_alis_tutar":"#wrk_round(t_row_total_alim_tutar)#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    <cfset deger_ = '"t_satis_miktar":"#wrk_round(t_row_total_satis)#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    <cfset deger_ = '"t_satis_tutar":"#wrk_round(t_row_total_satis_tutar)#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    <cfset deger_ = '"t_satis_brut_kdvsiz":"#wrk_round(t_row_total_satis_tutar_brut_kdvsiz)#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    <cfset deger_ = '"t_satis_brut_kdvli":"#wrk_round(t_row_total_satis_tutar_brut)#"'><cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    <cfset deger_ = '"t_liste_fiyat":""'> <cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
</cfoutput>

<cfset dataset = listappend(dataset,"{#row_##CRLF#}")>

<cfset dataset = "[" & dataset & "]">

<cfif not directoryexists('#upload_folder#retail\xml\')>
    <cfdirectory action="create" directory="#upload_folder#retail#dir_seperator#xml">
</cfif>
<cffile action="write" file="#upload_folder#retail\xml\alis_satis_#userid_#.txt" output="#dataset#" charset="utf-8">

<link rel="stylesheet" type="text/css" href="/wbp/retail/files/js/jqwidgets/jqwidgets/styles/jqx.base.css" />
<link rel="stylesheet" type="text/css" href="/wbp/retail/files/js/jqwidgets/jqwidgets/styles/jqx.energyblue.css" />
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxcore.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxdata.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxbuttons.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxscrollbar.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxmenu.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.edit.js?version=<cfoutput>#CreateUUID()#</cfoutput>"></script>

<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.selection.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.columnsresize.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.columnsreorder.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.filter.js"></script>

<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxnumberinput_new.js?version=<cfoutput>#CreateUUID()#</cfoutput>"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxinput.js"></script>

<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxlistbox.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxcheckbox.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxtooltip.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxdropdownlist.js"></script>


<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.grouping.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.aggregates.js?version=<cfoutput>#CreateUUID()#</cfoutput>"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/scripts/demos.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/demos/jqxgrid/localization.js?version=<cfoutput>#CreateUUID()#</cfoutput>"></script>

<div id='jqxWidget'><div id="jqxgrid"></div></div>

<style>
	.ara_toplam{background-color:#CCF; font-weight:bold; color:#666666;}
	.genel_toplam{background-color:#CCF; font-weight:bold; color:#666666;}
	
	.stock_rengi{background-color:#FFE4B5; color:#666666;}
	
	.satis_rengi{background-color:#CCFF66; color:#666666;}
	
	.total_rengi{background-color:#CF9; color:#666666;}
	
	.o1{background-color:#FFFF66; color:#666666;}
	.o2{background-color:#CCFF66; color:#666666;}
	.o3{background-color:#00FF00; color:#666666;}
	.o4{background-color:#FFFFFF; color:#666666;}
	
	.standart{background-color:#ffffff; color:#666666;}
</style>


<cfset text_name_list = "id,row_type,sira,altgrup1,altgrup2,company_name,project_name,marka,ambalaj,stok_id,stok,alis_kdv,satis_kdv,s_tutar_yuzde">


<cfset non_show_list = "id,row_type">
<cfset non_filter_list = "sira_no">

<form name="print_form" action="index.cfm?fuseaction=retail.popup_purchase_sale_report_datagrid" method="post">
	<div id="print_div" style="display:none;">
        <input type="text" name="rowcount" value="">
        <textarea id="print_note" name="print_note" style="height:150px; width:200px;"></textarea>
        <textarea id="name_list" name="name_list"><cfoutput>#name_list#</cfoutput></textarea>
        <textarea id="turkce_name_list" name="turkce_name_list"><cfoutput>#turkce_name_list#</cfoutput></textarea>
        <textarea id="non_show_list" name="non_show_list"><cfoutput>#non_show_list#</cfoutput></textarea>
        <textarea id="row_list" name="row_list" style="height:150px; width:200px;"></textarea>
    </div>
</form>

<script type="text/javascript">
function get_excel()
{
	var rows = $('#jqxgrid').jqxGrid('getboundrows');
	eleman_sayisi = rows.length;
	
	//alert(JSON.stringify(rows));
	
	document.getElementById('print_note').value = JSON.stringify(rows);
	windowopen('','medium','print_window_scr');
	adress_ = 'index.cfm?fuseaction=retail.popup_purchase_sale_report_datagrid';
	
	document.print_form.rowcount.value = eleman_sayisi;
	
	document.print_form.action = adress_;
	document.print_form.target = 'print_window_scr';
	document.print_form.submit();
}

$(document).ready(function () 
{
	foot_ = parseInt(600);
	head_ = parseInt(50);
	
	jheight = foot_ - head_ - 80;
	jwidth = window.innerWidth - 40;
    <cfoutput>var url = "/documents/retail/xml/alis_satis_#userid_#.txt";</cfoutput>
	var source =
	 {
		dataType: "json",
		dataFields: [
			<cfoutput>
				<cfloop from="1" to="#listlen(name_list)#" index="eleman_">
				<cfset kol_name = listgetat(name_list,eleman_)>
				{name: '#kol_name#', type: '<cfif not listfind(text_name_list,kol_name)>float<cfelse>string</cfif>'}<cfif eleman_ neq listlen(name_list)>,</cfif> 
				</cfloop>
			</cfoutput>
		],
		id:'id',
		url: url
	 };
	 
	 
	 
	 var dataAdapter = new $.jqx.dataAdapter(source);
	
	$("#jqxgrid").jqxGrid(
	{
		ready: function () 
		{
			$("#jqxgrid").jqxGrid('autoresizecolumns');
		},
		theme: 'energyblue',
		virtualmode: false,
		rendergridrows: function (obj) {
		return obj.data;
		},
		width:jwidth,
		height: jheight,
		source:dataAdapter,
		sortable: false,
		columnsResize: true,
		columnsReorder: false,
		editable:false,
		localization: getLocalization('de'),
		showfilterrow: true,
		filterable: true,
		filtermode: 'excel',
		showtoolbar: false,
		showaggregates: false,
		showstatusbar: false,
		columnsheight:25,
		selectionmode: 'singlerow',
		<cfif isdefined("attributes.is_department_multi")>
		columngroups: 
		[
		  <cfoutput query="get_list_departments">{ text: '#department_head#', align: 'center', name: 'cg_#department_id#'}<cfif currentrow neq get_list_departments.recordcount>,</cfif></cfoutput>
		],
		</cfif>
		columns:[
				<cfoutput>
				<cfloop from="1" to="#listlen(name_list)#" index="eleman_">
					<cfset kol_name = listgetat(name_list,eleman_)>
					<cfset t_name = listgetat(turkce_name_list,eleman_)>
						<cfif not listfind(non_show_list,kol_name)>{
							cellclassname:function (row, columnfield, value, rowdata)
							{
								satir_tipi = rowdata.row_type;
								if(satir_tipi == '2')
									return "ara_toplam";
								else if(satir_tipi == '3')
									return "genel_toplam";
								else if(satir_tipi == 1 && columnfield == 't_guncel_stok')
									return "stock_rengi";
								else if(satir_tipi == 1 && (columnfield == 't_satis_miktar' || columnfield == 't_satis_tutar') )
									return "satis_rengi";
								else if(satir_tipi == 1 && (columnfield == 't_satis_brut_kdvsiz' || columnfield == 't_satis_brut_kdvli'))
									return "total_rengi";
								else if(satir_tipi == 1 && columnfield == 't_ort_satis' && value > 1 && value <= 1.99)
									return "o1";
								else if(satir_tipi == 1 && columnfield == 't_ort_satis' && value > 2 && value <= 3.99)
									return "o2";
								else if(satir_tipi == 1 && columnfield == 't_ort_satis' && value > 4)
									return "o3";
								else if(satir_tipi == 1 && columnfield == 't_ort_satis')
									return "o4";
								else
									return "standart";
							},
							<cfif isdefined("attributes.is_department_multi")>
								<cfif left(kol_name,2) is 'd_' and isnumeric(listlast(kol_name,'_'))>
									columngroup: 'cg_#listlast(kol_name,'_')#',
								</cfif>
							</cfif>
							text: '#t_name#', dataField: '#kol_name#', <cfif not listfind(non_filter_list,kol_name)>filterable:true,</cfif><cfif not listfind(text_name_list,kol_name)>columntype:'numberinput',cellsformat:'c2',filtertype:'number',align: 'right',cellsalign: 'right',</cfif> minWidth: 50, width: 50,hidden:false}<cfif eleman_ neq listlen(name_list)>,</cfif></cfif>
					</cfloop>
				</cfoutput>
		]
	});
});
</script>
</cfif>