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
<cfsavecontent variable="title"><cf_get_lang dictionary_id='61876.Alış Satış Raporu'></cfsavecontent>
<cf_report_list_search title="#title#">
    <cf_report_list_search_area>
        <cfform name="rapor" method="post" action="#request.self#?fuseaction=retail.purchase_sale_report">
            <input type="hidden" name="is_form_submitted" id="is_form_submitted" value="">
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
                                        <cfinput type="text" name="keyword" value="#attributes.keyword#" >
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
                                                <input type="text"   name="company" id="company" style="width:120px;"  value="<cfif isdefined("attributes.company") and len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',0,0','COMPANY_ID,CONSUMER_ID','company_id,consumer_id','','3','250');" autocomplete="off">
                                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_name=rapor.company&field_comp_id=rapor.company_id&field_consumer=rapor.consumer_id&select_list=7,8&keyword='+encodeURIComponent(document.rapor.company.value));"></span>
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
                                                <input type="text"   name="project_head" id="project_head" style="width:120px;"value="<cfif isdefined('attributes.project_head') and  len(attributes.project_head)><cfoutput>#URLDecode(attributes.project_head)#</cfoutput></cfif>" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
                                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=rapor.project_id&project_head=rapor.project_head');"></span>
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
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id ='58053.Başlangıç Tarihi'></cfsavecontent>
                                            <cfinput type="text" name="startdate" style="width:65px;" value="#attributes.startdate#" validate="eurodate" message="#message#" maxlength="10" required="yes">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='57700.Bitiş Tarihi'></label>
                                    <div class="col col-8 col-sm-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message2"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id ='57700.Bitiş Tarihi'></cfsavecontent>
                                            <cfinput type="text" name="finishdate" style="width:65px;" value="#attributes.finishdate#" validate="eurodate" message="#message2#" maxlength="10" required="yes">
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
                        </div>
                    </div>
                </div>
            </div>
        </cfform>
	</cf_report_list_search_area>
</cf_report_list_search>

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

<cfquery name="get_internaldemand" datasource="#DSN3#" result="donus">
SELECT
	*
FROM
	(
	SELECT
        ISNULL((SELECT TOP 1 ETR.SUB_TYPE_ID FROM #DSN_DEV_ALIAS#.EXTRA_PRODUCT_TYPES_ROWS ETR WHERE S.PRODUCT_ID = ETR.PRODUCT_ID AND ETR.TYPE_ID = #uretici_type_id#),0) AS SUB_TYPE_ID,
        ISNULL(( 
            SELECT TOP 1 
                PT1.NEW_ALIS
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
        ),PRICE_STANDART.PRICE) AS LISTE_FIYATI_ALIS_KDVLI,
        ISNULL(( 
            SELECT TOP 1 
                PT1.NEW_PRICE
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
        ),PS2.PRICE_KDV) AS LISTE_FIYATI_SATIS_KDV,
        <cfoutput query="get_list_departments">
            ISNULL((SELECT SUM(AMOUNT) FROM #dsn_dev_alias#.GET_SHIP_ROWS GSR WHERE GSR.SHIP_DATE >= #attributes.startdate# AND GSR.SHIP_DATE <= #attributes.finishdate# AND GSR.STOCK_ID = S.STOCK_ID AND GSR.DEPARTMENT_IN = #department_id#),0) AS ALIM_#department_id#,
        	                ISNULL(
    (
                	SELECT 
                    	SUM(SATIR_FIYATI * AMOUNT) 
                    FROM 
                    	#dsn_dev_alias#.GET_SHIP_ROWS_REAL GSR 
                    WHERE 
                    	GSR.SHIP_TYPE = 76 AND
                        GSR.SHIP_DATE >= #attributes.startdate# AND 
                        GSR.SHIP_DATE <= #attributes.finishdate# AND 
                        GSR.STOCK_ID = S.STOCK_ID AND 
                        GSR.DEPARTMENT_IN = #department_id#
                ),0) AS ALIM_TUTAR_#department_id#,
           ISNULL((SELECT SUM(PRODUCT_STOCK) FROM #DSN#_#year(now())#_#session.ep.company_id#.GET_STOCK_PRODUCT WHERE S.PRODUCT_ID = GET_STOCK_PRODUCT.PRODUCT_ID AND GET_STOCK_PRODUCT.DEPARTMENT_ID = #department_id#),0) AS STOCK_#department_id#,
           ISNULL(#dsn_dev_alias#.fnc_get_ortalama_satis_stok(S.STOCK_ID,#department_id#,#attributes.startdate#,#attributes.finishdate#),0) AS ROW_ORT_#department_id#, 
		</cfoutput>
        ISNULL(#dsn_dev_alias#.fnc_get_ortalama_satis_stok(S.STOCK_ID,#merkez_depo_id#,#attributes.startdate#,#attributes.finishdate#),0) AS ORTALAMA_SATIS, 
         RY.FULLNAME,
         (SELECT PP.PROJECT_HEAD FROM #DSN_ALIAS#.PRO_PROJECTS PP WHERE PP.PROJECT_ID = P.PROJECT_ID) AS PROJECT_NAME,
      <!---  PROJECT(SELECT
                  '' AS PROJE_ADI,
                        
            FROM
                
                COMPANY_CAT CC
            WHERE
                      RY.COMPANYCAT_ID = CC.COMPANYCAT_ID 
		
        UNION ALL
            SELECT
                PP.PROJECT_HEAD AS PROJE_ADI,
                              FROM
                
                COMPANY_CAT CC,
                PRO_PROJECTS PP
            WHERE
      
                RY.COMPANYCAT_ID = CC.COMPANYCAT_ID AND
                RY.COMPANY_ID = PP.COMPANY_ID),--->
              S.STOCK_CODE,
        S.PRODUCT_NAME,
        S.PROPERTY,
        S.STOCK_ID,
        S.TAX_PURCHASE,
        S.TAX,
        PC.PRODUCT_CATID,
        EPTR.SUB_TYPE_NAME AS AMBALAJ,
        EPTR2.SUB_TYPE_NAME AS MARKA,
        EPTR3.SUB_TYPE_NAME AS URETICI
	FROM 
        PRODUCT_CAT PC,
        STOCKS S, 
        #dsn_alias#.COMPANY RY,
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
		<cfif isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_head") and len(attributes.project_head)>
            P.PROJECT_ID IN (#attributes.project_id#) AND
        </cfif>
        <cfif isdefined('attributes.company_id') and len(attributes.company_id) and len(attributes.company)>
          	P.COMPANY_ID = #attributes.company_id# AND
        <cfelseif isdefined('attributes.consumer_id') and len(attributes.consumer_id) and len(attributes.company)>
            P.CONSUMER_ID= #attributes.consumer_id# AND
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
        --S.STOCK_STATUS = 1 AND
        PS2.PRICESTANDART_STATUS = 1 AND
        PS2.PURCHASESALES = 1 AND
        PRODUCT_UNIT.PRODUCT_UNIT_ID = PS2.UNIT_ID AND
        S.PRODUCT_ID = P.PRODUCT_ID AND
        --S.PRODUCT_STATUS = 1 AND
        S.PRODUCT_CATID = PC.PRODUCT_CATID AND
        PC.PRODUCT_CATID IN (#p_cat_list#)  AND
        P.COMPANY_ID=RY.COMPANY_ID 
        
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

<cfif get_internaldemand.recordcount>
<cfset  stock_id_list = valuelist(get_internaldemand.stock_id)>
    <cfquery name="get_satis_tutarlar" datasource="#dsn_dev#">
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
               (CASE WHEN GA.FIS_IPTAL > 0  THEN 0 * (GAR.MIKTAR) WHEN ((GA.BELGE_TURU = '2' AND GAR.SATIR_IPTALMI = 0) OR (GA.BELGE_TURU <> '2' AND GAR.SATIR_IPTALMI = 1)) THEN -1 * (GAR.MIKTAR) ELSE (GAR.MIKTAR) END) AS SATIS_MIKTAR,
               (CASE WHEN GA.FIS_IPTAL > 0  THEN 0 * (GAR.MIKTAR) WHEN ((GA.BELGE_TURU = '2' AND GAR.SATIR_IPTALMI = 0) OR (GA.BELGE_TURU <> '2' AND GAR.SATIR_IPTALMI = 1)) THEN -1 * (GAR.SATIR_TOPLAM - GAR.SATIR_INDIRIM - GAR.SATIR_PROMOSYON_INDIRIM - GAR.SATIR_KDV_TUTAR) ELSE (GAR.SATIR_TOPLAM - GAR.SATIR_PROMOSYON_INDIRIM - GAR.SATIR_INDIRIM - GAR.SATIR_KDV_TUTAR) END) AS SATIS_TUTAR,
               (CASE WHEN GA.FIS_IPTAL > 0  THEN 0 * (GAR.MIKTAR) WHEN ((GA.BELGE_TURU = '2' AND GAR.SATIR_IPTALMI = 0) OR (GA.BELGE_TURU <> '2' AND GAR.SATIR_IPTALMI = 1)) THEN -1  * (GAR.SATIR_TOPLAM) ELSE (GAR.SATIR_TOPLAM) END) AS SATIS_TUTAR_BRUT,
               (CASE WHEN GA.FIS_IPTAL > 0  THEN 0 * (GAR.MIKTAR) WHEN ((GA.BELGE_TURU = '2' AND GAR.SATIR_IPTALMI = 0) OR (GA.BELGE_TURU <> '2' AND GAR.SATIR_IPTALMI = 1)) THEN -1  * (GAR.SATIR_TOPLAM - GAR.SATIR_KDV_TUTAR) ELSE (GAR.SATIR_TOPLAM - GAR.SATIR_KDV_TUTAR) END) AS SATIS_TUTAR_BRUT_KDVSIZ
            FROM
                #dsn_dev_alias#.GENIUS_ACTIONS GA,
                #dsn_dev_alias#.GENIUS_ACTIONS_ROWS GAR,
                #dsn_alias#.DEPARTMENT D
            WHERE
                GA.FIS_TARIHI >= #attributes.startdate# AND 
                GA.FIS_TARIHI < #dateadd('d',1,attributes.finishdate)# AND
                GA.ACTION_ID = GAR.ACTION_ID AND
                GA.DEPARTMENT_ID = D.DEPARTMENT_ID AND
                GAR.STOCK_ID IN (#stock_id_list#)
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
                GSRA.STOCK_ID IN (#stock_id_list#)
       ) T1
    GROUP BY
    	DEPARTMENT_ID,
        STOCK_ID
    </cfquery>
    <cfoutput query="get_satis_tutarlar">
		<cfset 'satis_miktar_#STOCK_ID#_#DEPARTMENT_ID#' = SATIS_MIKTAR>
		<cfset 'satis_tutar_#STOCK_ID#_#DEPARTMENT_ID#' = SATIS_TUTAR>
        <cfset 'satis_tutar_brut_#STOCK_ID#_#DEPARTMENT_ID#' = SATIS_TUTAR_BRUT>
        <cfset 'satis_tutar_brut_kdvsiz_#STOCK_ID#_#DEPARTMENT_ID#' = SATIS_TUTAR_BRUT_KDVSIZ>
    </cfoutput>
</cfif>

<cfset last_birinci_ = "">
<cfset last_ikinci_ = "">
<cfset last_ucuncu_ = "">
<!-- sil -->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <!---<th>Ana Grup</th>--->
                    <th><cf_get_lang dictionary_id='61642.Alt Grup'> 1</th>
                    <th><cf_get_lang dictionary_id='61642.Alt Grup'> 2</th>
                    <!---<th>Üretici</th>--->
                    <th><cf_get_lang dictionary_id='58847.Marka'></th>
                    <th><cf_get_lang dictionary_id='33269.Ambalaj'></th>
                    <th><cf_get_lang dictionary_id='58061.Cari'></th>
                    <th><cf_get_lang dictionary_id='57416.Proje'></th> 
                    <th><cf_get_lang dictionary_id='57452.Stok'></th>
                        <th>A.<cf_get_lang dictionary_id='57639.KDV'></th>
                        <th>S.<cf_get_lang dictionary_id='57639.KDV'></th>
                    <cfif isdefined("attributes.is_department_multi")><cfoutput query="get_list_departments"><th style="text-align:center;" colspan="11" rel="depo_cols">#DEPARTMENT_HEAD#</th></cfoutput></cfif>
                    <th style="text-align:center;" colspan="15"><cf_get_lang dictionary_id='50141.Toplamlar'></th>
                </tr>
            </thead>
            <thead>
                <tr>
                    <th colspan="10">&nbsp;</th>
                    <cfif isdefined("attributes.is_department_multi")>
                    <cfoutput query="get_list_departments">
                        <th style="text-align:right; display:;" rel="depo_cols"><cf_get_lang dictionary_id='62208.Stok Yeterlilik'></th>
                        <th style="text-align:right; display:;" rel="depo_cols"><cf_get_lang dictionary_id='62209.Ortalama Satış'></th>
                        <th style="text-align:right; display:;" rel="depo_cols"><cf_get_lang dictionary_id='58456.Oran'></th>
                        <th style="text-align:right; display:;" rel="depo_cols"><cf_get_lang dictionary_id='62210.Güncel Stok'></th>
                        <th style="text-align:right; display:;" rel="depo_cols"><cf_get_lang dictionary_id='62211.Güncel Stok Tutarı'> <cf_get_lang dictionary_id='62212.Toplam Hariç'></th>
                        <th style="text-align:right; display:;" rel="depo_cols"><cf_get_lang dictionary_id='39874.Alış Miktarı'></th>
                        <th style="text-align:right; display:;" rel="depo_cols"><cf_get_lang dictionary_id='39875.Alış Tutarı'>(<cf_get_lang dictionary_id='32998.KDV Hariç'>)</th>
                        <th style="text-align:right; display:;" rel="depo_cols"><cf_get_lang dictionary_id='29959.Satış Miktar'></th>
                        <th style="text-align:right; display:;" rel="depo_cols"><cf_get_lang dictionary_id='39129.Satış Tutarı'>(<cf_get_lang dictionary_id='32998.KDV Hariç'>)</th>
                        <th style="text-align:right; display:;" rel="depo_cols"><cf_get_lang dictionary_id='39129.Satış Tutarı'> <cf_get_lang dictionary_id='62213.Brüt KDVsiz Tutar'></th>
                        <th style="text-align:right; display:;" rel="depo_cols"><cf_get_lang dictionary_id='39129.Satış Tutarı'> <cf_get_lang dictionary_id='61545.Brüt KDVli Tutar'></th>
                    </cfoutput>
                    </cfif>
                    <th style="text-align:right;">T. <cf_get_lang dictionary_id='62208.Stok Yeterlilik'></th>
                    <th style="text-align:right;">T. <cf_get_lang dictionary_id='62209.Ortalama Satış'></th>
                    <th style="text-align:right;">S.<cf_get_lang dictionary_id='62214.Tutar Toplam'> H %</th>
                    <th style="text-align:right;">T. <cf_get_lang dictionary_id='62210.Güncel Stok'></th>
                    <th style="text-align:right;">T. <cf_get_lang dictionary_id='62211.Güncel Stok Tutarı'> <cf_get_lang dictionary_id='62212.Toplam Hariç'></th>
                    <th style="text-align:right;">T. <cf_get_lang dictionary_id='39875.Alış Tutarı'></th>
                    <th style="text-align:right;">T.<cf_get_lang dictionary_id='39875.Alış Tutarı'>(<cf_get_lang dictionary_id='32998.KDV Hariç'>)</th>
                    <th style="text-align:right;">T. <cf_get_lang dictionary_id='29959.Satış Miktar'></th>
                    <th style="text-align:right;">T. <cf_get_lang dictionary_id='39129.Satış Tutarı'>(<cf_get_lang dictionary_id='32998.KDV Hariç'>)</th>
                    <th style="text-align:right;">T. <cf_get_lang dictionary_id='39129.Satış Tutarı'> <cf_get_lang dictionary_id='62213.Brüt KDVsiz Tutar'></th>
                    <th style="text-align:right;">T. <cf_get_lang dictionary_id='39129.Satış Tutarı'> <cf_get_lang dictionary_id='61545.Brüt KDVli Tutar'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='32526.Alış Fiyatı'> (<cf_get_lang dictionary_id='32998.KDV Hariç'>)</th>
                    <th style="text-align:right;">T. <cf_get_lang dictionary_id='39130.Satış Maliyeti'> (<cf_get_lang dictionary_id='32998.KDV Hariç'>)</th>
                    <th style="text-align:right;">T. <cf_get_lang dictionary_id='39130.Satış Maliyeti'> <cf_get_lang dictionary_id='34463.KDV Dahil'></th>
                    <!---  <th style="text-align:right;">T. Satış Liste Kdvsiz</th>
                    --->
                    <th style="text-align:right;">T. <cf_get_lang dictionary_id='62215.Satış Liste'> <cf_get_lang dictionary_id='34463.KDV Dahil'></th>
                </tr>
            </thead>
            <tbody>
            
            <cfset g_total_row_total_satis_tutar = 0>
            <cfset t_total_row_total_satis_tutar = 0>
            <cfset g_total_row_total_satis_tutar_brut = 0>
            <cfset t_total_row_total_satis_tutar_brut = 0>
            
            <cfset g_total_row_total_satis_tutar_brut_kdvsiz = 0>
            <cfset t_total_row_total_satis_tutar_brut_kdvsiz = 0>
            
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
                    <cfset t_total_row_total_satis_tutar = t_total_row_total_satis_tutar + satis_tutar_>
                    
                    <cfset g_total_row_total_satis_tutar_brut = g_total_row_total_satis_tutar_brut + satis_tutar_brut_>
                    <cfset t_total_row_total_satis_tutar_brut = t_total_row_total_satis_tutar_brut + satis_tutar_brut_>
                    
                    <cfset g_total_row_total_satis_tutar_brut_kdvsiz = g_total_row_total_satis_tutar_brut_kdvsiz + satis_tutar_brut_kdvsiz_>
                    <cfset t_total_row_total_satis_tutar_brut_kdvsiz = t_total_row_total_satis_tutar_brut_kdvsiz + satis_tutar_brut_kdvsiz_>
                </cfloop>
            </cfoutput>
            
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
            
            <!--- --->
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
            
            <cfset t_row_total_liste_fiyati_alis = 0>
            <cfset t_row_total_satis_maliyet_fiyati = 0>
                <cfset t_row_total_satis_maliyet_fiyati_kdvli = 0>
            
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
                    
                <cfoutput query="get_internaldemand">
                
                    <cfset row_total_stok = 0>
                    <cfset row_total_stok_tutar = 0>
                    
                    <cfset row_total_liste_fiyati_alis = 0>
                        <cfset row_total_satis_maliyet_fiyati = 0>
                        <cfset row_total_satis_maliyet_fiyati_kdvli = 0>
                        
                    
                    
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
                        <td>#FULLNAME#</td> 
                        <td>#PROJECT_NAME#</td>                 
                        <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=retail.popup_product_stocks&stock_id=#stock_id#','page_display');" class="tableyazi">#PROPERTY#</a></td>
                            <td>#TAX_PURCHASE#</td>
                            <td>#TAX#</td>
                            <cfloop from="1" to="#get_list_departments.recordcount#" index="dept">
                            <cfset dept_ = get_list_departments.department_id[dept]>
                            <cfset ort_satis_ = evaluate("ROW_ORT_#dept_#")>
                            <cfset stok_ = evaluate("STOCK_#dept_#")>
                            <cfset alim_ = evaluate("ALIM_#dept_#")>
                            <cfset alim_tutar_ = evaluate("ALIM_TUTAR_#dept_#")>
                            
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
                            
                            <cfif stok_ gt 0 and ort_satis_ gt 0>
                                <cfset yeterlilik_ = wrk_round(stok_ / ort_satis_)>
                            <cfelse>
                                <cfset yeterlilik_ = 0>
                            </cfif>
                            
                            <cfset row_total_stok = row_total_stok + stok_>
                            <cfset row_total_stok_tutar = row_total_stok_tutar + (stok_ * liste_fiyati_alis)>
                            
                            <cfset row_total_liste_fiyati_alis = liste_fiyati_alis>
                            <cfset row_total_liste_fiyati_alis_kdvli = liste_fiyati_alis_kdvli>
                            
                            <cfset row_total_satis_maliyet_fiyati =  row_total_satis_maliyet_fiyati + (satis_ * liste_fiyati_alis)>
                            <cfset row_total_satis_maliyet_fiyati_kdvli =  row_total_satis_maliyet_fiyati_kdvli +  (satis_ * liste_fiyati_alis)>
                            
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
                            <td style="text-align:right; display:;" rel="depo_cols">#tlformat(yeterlilik_)#</td>
                            <td style="text-align:right; display:;" rel="depo_cols">#tlformat(ort_satis_)#</td>
                            <td style="text-align:right; display:;" rel="depo_cols"></td>
                            <td style="text-align:right; display:;" rel="depo_cols">#tlformat(stok_)#</td>
                            <td style="text-align:right; display:;" rel="depo_cols">#tlformat(stok_ * liste_fiyati_alis)#</td>
                            <td style="text-align:right; display:;" rel="depo_cols">#tlformat(alim_)#</td>
                            <td style="text-align:right; display:;" rel="depo_cols">#tlformat(alim_tutar_)#</td>
                            <td style="text-align:right; display:;" rel="depo_cols">#tlformat(satis_)#</td>
                            <td style="text-align:right; display:;" rel="depo_cols">#tlformat(satis_tutar_)#</td>
                            <td style="text-align:right; display:;" rel="depo_cols">#tlformat(satis_tutar_brut_kdvsiz_)#</td>
                            <td style="text-align:right; display:;" rel="depo_cols">#tlformat(satis_tutar_brut_)#</td>
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
                        
                        <!--- --->
                        
                        <cfset t_row_total_stok = t_row_total_stok + row_total_stok>
                        <cfset t_total_stok_tutar = t_row_total_stok_tutar + row_total_stok_tutar>
                        
                        <cfset t_row_total_alim = t_row_total_alim + row_total_alim>
                        <cfset t_row_total_alim_tutar = t_row_total_alim_tutar + row_total_alim_tutar>
                        
                        <cfset t_row_total_satis = t_row_total_satis + row_total_satis>
                        <cfset t_row_total_satis_tutar = t_row_total_satis_tutar + row_total_satis_tutar>
                        <cfset t_row_total_satis_tutar_brut = t_row_total_satis_tutar_brut + row_total_satis_tutar_brut>
                        <cfset t_row_total_satis_tutar_brut_kdvsiz = t_row_total_satis_tutar_brut_kdvsiz + row_total_satis_tutar_brut_kdvsiz>
                        
                        <cfset t_row_total_liste_fiyati_alis = t_row_total_liste_fiyati_alis+row_total_liste_fiyati_alis>
                        
                        <cfset t_row_total_satis_maliyet_fiyati = t_row_total_satis_maliyet_fiyati+row_total_satis_maliyet_fiyati> 
                        <cfset t_row_total_satis_maliyet_fiyati_kdvli = t_row_total_satis_maliyet_fiyati_kdvli +((((liste_fiyati_alis_kdvli/100)* TAX_PURCHASE) +liste_fiyati_alis_kdvli)*row_total_satis)>
                
                        
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
                        
                        <td style="text-align:right;">#tlformat(row_yeterlilik)#</td>
                        <td style="text-align:right;">#tlformat(row_ortalama_satis)#</td>
                        <td style="text-align:right;">% #tlformat(row_satis_yuzdelik)#</td>
                        <td style="text-align:right;">#tlformat(row_total_stok)#</td>
                        <td style="text-align:right;">#tlformat(row_total_stok_tutar)#</td>
                        <td style="text-align:right;">#tlformat(row_total_alim)#</td>
                        <td style="text-align:right;" title="Alım Ortalaması : <cfif row_total_alim gt 0>#tlformat(row_total_alim_tutar / row_total_alim)#<cfelse>0</cfif>">#tlformat(row_total_alim_tutar)#</td>
                        <td style="text-align:right;">#tlformat(row_total_satis)#</td>
                        <td style="text-align:right;">#tlformat(row_total_satis_tutar)#</td>
                        <td style="text-align:right;">#tlformat(row_total_satis_tutar_brut_kdvsiz)#</td>
                        <td style="text-align:right;">#tlformat(row_total_satis_tutar_brut)#</td>
                        <td style="text-align:right;">#tlformat(liste_fiyati_alis)#</td>  <!---emrah ---->
                        <td style="text-align:right;">#tlformat(liste_fiyati_alis*row_total_satis)#</td>  <!---emrah ---->
                        <td style="text-align:right;">#tlformat((((liste_fiyati_alis_kdvli/100)* TAX_PURCHASE) +liste_fiyati_alis_kdvli)*row_total_satis)#</td>  <!---emrah ---->
                        <td style="text-align:right;">#TLFORMAT(LISTE_FIYATI_SATIS_KDV)#</td>
                    </tr>
                    <cfif currentrow eq get_internaldemand.recordcount or PRODUCT_CATID neq PRODUCT_CATID[currentrow+1]>
                    <tr>
                        <td colspan="10"><b>#last_group_id_#</b> <cf_get_lang dictionary_id='62320.Toplamları'></td>
                        <cfloop from="1" to="#get_list_departments.recordcount#" index="dept">
                            <cfset dept_ = get_list_departments.department_id[dept]>
                            <cfif isdefined("attributes.is_department_multi")>
                            <td style="text-align:right; display:; " rel="depo_cols">
                                <cfif evaluate('group_yeterlilik_#dept_#') gt 0>
                                    #tlformat(evaluate('group_yeterlilik_#dept_#') / evaluate('group_stock_count_#dept_#'))#
                                </cfif>
                            </td>
                            <td style="text-align:right; display:; " rel="depo_cols">
                                <cfif evaluate('group_ortalama_satis_#dept_#') gt 0>
                                    #tlformat(evaluate('group_ortalama_satis_#dept_#') / evaluate('group_stock_count_#dept_#'))#
                                </cfif>
                            </td>
                            <td style="text-align:right; display:; " rel="depo_cols">&nbsp;</td>
                            <td style="text-align:right; display:; " rel="depo_cols">#tlformat(Evaluate('group_total_stok_#dept_#'))#</td>
                            <td style="text-align:right; display:; " rel="depo_cols">#tlformat(Evaluate('group_total_stok_tutar_#dept_#'))#</td>
                            <td style="text-align:right; display:; " rel="depo_cols">#tlformat(Evaluate('group_total_alim_#dept_#'))#</td>
                            <td style="text-align:right; display:; " rel="depo_cols">#tlformat(Evaluate('group_total_alim_tutar_#dept_#'))#</td>
                            <td style="text-align:right; display:; " rel="depo_cols">#tlformat(Evaluate('group_total_satis_#dept_#'))#</td>
                            <td style="text-align:right; display:; " rel="depo_cols">#tlformat(Evaluate('group_total_satis_tutar_#dept_#'))#</td>
                            <td style="text-align:right; display:; " rel="depo_cols">&nbsp;</td>
                            <td style="text-align:right; display:; " rel="depo_cols">&nbsp;</td>
                            </cfif>
                        </cfloop>
                        <td style="text-align:right; "><cfif group_row_yeterlilik gt 0>#tlformat(group_row_yeterlilik / group_row_stock_count)#</cfif></td>
                        <td style="text-align:right; "><cfif group_row_ortalama_satis gt 0>#tlformat(group_row_ortalama_satis / group_row_stock_count)#</cfif></td>
                        <td style="text-align:right; ">% #tlformat(group_row_satis_yuzdelik)#</td>
                        <td style="text-align:right; ">#tlformat(group_row_total_stok)#</td>
                        <td style="text-align:right; ">#tlformat(group_row_total_stok_tutar)#</td>
                        <td style="text-align:right; ">#tlformat(group_row_total_alim)#</td>
                        <td style="text-align:right; ">#tlformat(group_row_total_alim_tutar)#</td>
                        <td style="text-align:right; ">#tlformat(group_row_total_satis)#</td>
                        <td style="text-align:right; ">#tlformat(group_row_total_satis_tutar)#</td>
                        <td style="text-align:right; ">#tlformat(group_row_total_satis_tutar_brut_kdvsiz)#</td>
                        <td style="text-align:right; ">#tlformat(group_row_total_satis_tutar_brut)#</td>
                        <td style="text-align:right; ">&nbsp;</td>
                        <td style="text-align:right; ">&nbsp;</td>
                        <td style="text-align:right; ">&nbsp;</td>
                        <td style="text-align:right; ">&nbsp;</td>
                        <!---<td style="text-align:right;background-color:##CCF;">&nbsp;</td>--->
                    </tr>
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
            </tbody>
            <cfoutput>
            <tfoot>
                <tr>
                    <td colspan="7" ><b><cf_get_lang dictionary_id='40035.Genel Toplamlar'></b></th>
                    <cfloop from="1" to="#get_list_departments.recordcount#" index="dept">
                    <cfif isdefined("attributes.is_department_multi")>
                        <td style="text-align:right; display:; " rel="depo_cols">&nbsp;</td>
                        <td style="text-align:right; display:; " rel="depo_cols">&nbsp;</td>
                        <td style="text-align:right; display:; " rel="depo_cols">&nbsp;</td>
                        <td style="text-align:right; display:; " rel="depo_cols">&nbsp;</td>
                        <td style="text-align:right; display:; " rel="depo_cols">&nbsp;</td>
                        <td style="text-align:right; display:; " rel="depo_cols">&nbsp;</td>
                        <td style="text-align:right; display:; " rel="depo_cols">&nbsp;</td>
                        <td style="text-align:right; display:; " rel="depo_cols">&nbsp;</td>
                        <td style="text-align:right; display:; " rel="depo_cols">&nbsp;</td>
                        <td style="text-align:right; display:; " rel="depo_cols">&nbsp;</td>
                        <td style="text-align:right; display:; " rel="depo_cols">&nbsp;</td>
                    </cfif>
                    </cfloop>
                    <td style="text-align:right; ">&nbsp;</td>
                    <td style="text-align:right; ">&nbsp;</td>
                    <td style="text-align:right; "><cfif t_row_yeterlilik gt 0>#tlformat(t_row_yeterlilik / t_row_stock_count)#</cfif></td>
                    <td style="text-align:right; "><cfif t_row_ortalama_satis gt 0>#tlformat(t_row_ortalama_satis / t_row_stock_count)#</cfif></td>
                    <td style="text-align:right;">% #tlformat(t_row_satis_yuzdelik)#</td>
                    <td style="text-align:right;">#tlformat(t_row_total_stok)#</td>
                    <td style="text-align:right;">#tlformat(t_row_total_stok_tutar)#</td>
                    <td style="text-align:right;">#tlformat(t_row_total_alim)#</td>
                    <td style="text-align:right;">#tlformat(t_row_total_alim_tutar)#</td>
                    <td style="text-align:right;">#tlformat(t_row_total_satis)#</td>
                    <td style="text-align:right;">#tlformat(t_row_total_satis_tutar)#</td>
                    <td style="text-align:right;">#tlformat(t_row_total_satis_tutar_brut_kdvsiz)#</td>
                    <td style="text-align:right; ">#tlformat(t_row_total_satis_tutar_brut)#</td>
                        <td style="text-align:right; ">#tlformat(t_row_total_liste_fiyati_alis)#</td><!--- emrah --->
                        <td style="text-align:right; ">#tlformat(t_row_total_satis_maliyet_fiyati)#</td><!--- emrah --->
                                    <td style="text-align:right; ">#tlformat(t_row_total_satis_maliyet_fiyati_kdvli)#</td>
                                    <td style="text-align:right; ">&nbsp;</td>
                    <!---<td style="text-align:right;background-color:##CCF;">&nbsp;</td>--->
                </tr>
            </tfoot>
            </cfoutput>
        </cf_grid_list>
    </cf_box>
</div>
    
<!-- sil -->
</cfif>