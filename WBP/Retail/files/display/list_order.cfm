<cf_get_lang_set module_name="purchase"><!--- sayfanin en altinda kapanisi var --->
<cf_xml_page_edit fuseact ="purchase.list_order">
    <cfset order_stage_ = 1>
<cfif fusebox.circuit is 'store'>
	<cfset my_url_action = 'store.detail_order_purchase'>
<cfelseif fusebox.circuit is 'retail'>
	<cfset my_url_action = 'retail.list_order&event=upd'>
<cfelse>
	<cfset my_url_action = 'purchase.detail_order'>
</cfif>
<cfif fusebox.circuit is 'store'>
	<cfset url_action = 'store.list_purchase_order'>
<cfelseif fusebox.circuit is 'retail'>
	<cfset url_action = 'retail.list_order'>
<cfelse>
	<cfset url_action = 'purchase.list_order'>
</cfif>
<cfparam name="attributes.form_varmi" default="1">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.order_no" default="">
<cfparam name="attributes.order_status" default="1">
<cfparam name="attributes.currency_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.employee" default="" >
<cfparam name="attributes.employee_id" default="" >

<cfif isdefined("session.ep.userid")>
    <cfparam name="attributes.company" default="" >
    <cfparam name="attributes.company_id" default="" >
    <cfparam name="attributes.project_id" default="">
    <cfparam name="attributes.listing_type" default="0">
    <cfparam name="attributes.project_head" default="">
<cfelse>
    <cfset attributes.company = session.pp.company>
    <cfset attributes.company_id = session.pp.company_id>
    <cfset attributes.project_id = session.pp.project_id>
    <cfset attributes.project_head = session.pp.project_name>
    <cfset attributes.listing_type = 1>
</cfif>

<cfif isdefined("session.ep.userid")>
    <cfparam name="attributes.order_stage" default="#order_stage_#">
    <cfparam name="attributes.irsaliye_fatura" default="">
<cfelse>
	<cfparam name="attributes.order_stage" default="#valid_order_stage_#">
    <cfparam name="attributes.irsaliye_fatura" default="3">
</cfif>

<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.position_code" default="">
<cfparam name="attributes.position_name" default="">
<cfparam name="attributes.prod_cat" default="">
<cfparam name="attributes.quantity" default="">
<cfparam name="attributes.unit" default="">
<cfparam name="attributes.order_type" default="">
<cfparam name="attributes.sort_type" default="4">

<cfparam name="attributes.foreign_categories" default="">
<cfparam name="attributes.zone_id" default="">
<cfparam name="attributes.deliver_start_date" default="">
<cfparam name="attributes.deliver_finish_date" default="">

<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
<cfelse>
	<cfset attributes.start_date = "">
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
<cfelse>
	<cfset attributes.finish_date = "">
</cfif>
<cfif isdefined("attributes.deliver_start_date") and isdate(attributes.deliver_start_date)>
	<cf_date tarih="attributes.deliver_start_date">
</cfif>
<cfif isdefined("attributes.deliver_finish_date") and isdate(attributes.deliver_finish_date)>
	<cf_date tarih="attributes.deliver_finish_date">
</cfif>
<cfquery name="get_my_branches" datasource="#dsn#">
	SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#
</cfquery>
<cfif get_my_branches.recordcount>
	<cfset my_branch_list = valuelist(get_my_branches.BRANCH_ID)>
<cfelse>
	<cfset my_branch_list = '0'>
</cfif>
<cfquery name="STORES" datasource="#DSN#">
	SELECT
		D.DEPARTMENT_ID,
        D.DEPARTMENT_HEAD
        <cfif attributes.fuseaction eq 'purchase.add_order_product_all_criteria'>        
            ,SL.LOCATION_ID
            ,SL.STATUS
            ,SL.COMMENT
        </cfif>
	FROM
		DEPARTMENT D
        <cfif attributes.fuseaction eq 'purchase.add_order_product_all_criteria'>
       		,STOCKS_LOCATION SL
        </cfif>
	WHERE 
		D.IS_STORE <> 2 AND	
		D.DEPARTMENT_STATUS = 1
        <cfif attributes.fuseaction eq 'purchase.add_order_product_all_criteria'>
        	AND SL.DEPARTMENT_ID = D.DEPARTMENT_ID
        </cfif>
        AND D.BRANCH_ID IN (#my_branch_list#)
	ORDER BY
		D.DEPARTMENT_HEAD
</cfquery>


<cfif isdefined("attributes.form_varmi")>
	<cfset arama_yapilmali = 0>
	<cfscript>
	get_order_list_action = createObject("component", "wbp.retail.files.cfc.get_order_list");
	get_order_list_action.dsn3 = dsn3;
	get_order_list_action.dsn = dsn;
	get_order_list_action.dsn_dev = dsn;
	get_order_list_action.dsn_alias = dsn_alias;
	get_order_list_action.dsn2_alias = dsn2_alias;
    /*
	get_order_list = get_order_list_action.get_order_list_fnc
		(
			listing_type : '#IIf(IsDefined("attributes.listing_type"),"attributes.listing_type",DE(""))#',
			xml_dsp_row_other_money_ : '#IIf(IsDefined("xml_dsp_row_other_money_"),"xml_dsp_row_other_money_",DE(""))#',
			xml_dsp_ship_amount_info_ : '#IIf(IsDefined("xml_dsp_ship_amount_info_"),"#xml_dsp_ship_amount_info_#",DE(""))#',
			xml_dps_price_from_row_amount_ : '#IIf(IsDefined("xml_dps_price_from_row_amount_"),"#xml_dps_price_from_row_amount_#",DE(""))#',
			start_date : '#IIf(IsDefined("attributes.start_date"),"attributes.start_date",DE(""))#',
			finish_date : '#IIf(IsDefined("attributes.finish_date"),"attributes.finish_date",DE(""))#',
			deliver_start_date : '#IIf(IsDefined("attributes.deliver_start_date"),"attributes.deliver_start_date",DE(""))#',
			deliver_finish_date : '#IIf(IsDefined("attributes.deliver_finish_date"),"attributes.deliver_finish_date",DE(""))#',
			currency_id : '#IIf(IsDefined("attributes.currency_id"),"attributes.currency_id",DE(""))#',
			department_id : '#IIf(IsDefined("attributes.department_id"),"attributes.department_id",DE(""))#',
			order_status : '#IIf(IsDefined("attributes.order_status"),"attributes.order_status",DE(""))#',
			project_id : '#IIf(IsDefined("attributes.project_id"),"attributes.project_id",DE(""))#',
			project_head : '#IIf(IsDefined("attributes.project_head"),"attributes.project_head",DE(""))#',
			product_id : '#IIf(IsDefined("attributes.product_id"),"attributes.product_id",DE(""))#',
			prod_cat : '#IIf(IsDefined("attributes.prod_cat"),"attributes.prod_cat",DE(""))#',
			position_code : '#IIf(IsDefined("attributes.position_code"),"attributes.position_code",DE(""))#',
			product_name : '#IIf(IsDefined("attributes.product_name"),"attributes.product_name",DE(""))#',
			position_name : '#IIf(IsDefined("attributes.position_name"),"attributes.position_name",DE(""))#',
			keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(""))#',
			order_no : '#IIf(IsDefined("attributes.order_no"),"attributes.order_no",DE(""))#',
			subscription_id : '#IIf(IsDefined("attributes.subscription_id"),"attributes.subscription_id",DE(""))#',
			priority : '#IIf(IsDefined("attributes.priority"),"attributes.priority",DE(""))#',
			keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(""))#',
			member_type : '#IIf(IsDefined("attributes.member_type"),"attributes.member_type",DE(""))#',
			member_name : '#IIf(IsDefined("attributes.member_name"),"attributes.member_name",DE(""))#',
			company_id : '#IIf(IsDefined("attributes.company_id"),"attributes.company_id",DE(""))#',
			company : '#IIf(IsDefined("attributes.company"),"attributes.company",DE(""))#',
			consumer_id : '#IIf(IsDefined("attributes.consumer_id"),"attributes.consumer_id",DE(""))#',
			employee : '#IIf(IsDefined("attributes.employee"),"attributes.employee",DE(""))#',
			employee_id : '#IIf(IsDefined("attributes.employee_id"),"attributes.employee_id",DE(""))#',
			order_stage : '#IIf(IsDefined("attributes.order_stage"),"attributes.order_stage",DE(""))#',
			zone_id : '#IIf(IsDefined("attributes.zone_id"),"attributes.zone_id",DE(""))#',
			sort_type : '#IIf(IsDefined("attributes.sort_type"),"attributes.sort_type",DE(""))#',
			irsaliye_fatura : '#IIf(IsDefined("attributes.irsaliye_fatura"),"attributes.irsaliye_fatura",DE(""))#',
			foreign_categories : '#IIf(IsDefined("attributes.foreign_categories"),"attributes.foreign_categories",DE(""))#',
			module_name : '#IIf(IsDefined("fusebox.circuit"),"fusebox.circuit",DE(""))#',
			order_type : '#IIf(IsDefined("attributes.order_type"),"attributes.order_type",DE(""))#'
			);
            */
            GET_ORDER_LIST = { recordcount: 0 };
	</cfscript>
    
    <cfif attributes.listing_type eq 0 and GET_ORDER_LIST.recordcount>
    	<cfquery name="get_order_list" dbtype="query">
        	SELECT
            	MAX(ORDER_ID) AS ORDER_ID,
                COUNT(ORDER_ID) AS BELGE_SAYISI,
                COUNT(DISTINCT DELIVER_DEPT_ID) AS DEPO_SAYISI,
                COUNT(DISTINCT RECORD_EMP) AS KAYDEDEN_SAYISI,
                COUNT(DISTINCT ORDER_STAGE) AS SUREC_SAYISI,
                SUM(URUN_SAYISI) AS URUN_SAYISI,
                SUM(NETTOTAL) AS NETTOTAL,
                SUM(DONUSEN) AS DONUSEN,
                SUM(OTHER_MONEY_VALUE) AS OTHER_MONEY_VALUE,
                'TL' AS OTHER_MONEY,
                SUM(ACIK_URUN_SAYISI) AS ACIK_URUN_SAYISI,
                SUM(SEVK_URUN_SAYISI) AS SEVK_URUN_SAYISI,
                COMP_CODE,
                PROJECT_HEAD,
                PROJECT_ID,
                NICKNAME,
                ORDER_YIL,
                ORDER_AY,
                ORDER_GUN,
                COMPANY_ID,
                '' AS CONSUMER_ID,
                0 AS IS_PROCESSED,
                '' AS STAGE,
                '' AS EMPLOYEE_NAME,
                '' AS EMPLOYEE_SURNAME,
                '' AS RECORD_EMP,
                '' AS PARTNER_ID,
                '<cf_get_lang dictionary_id='63178.Firma Siparişi'>' AS ORDER_HEAD,
                '' AS ORDER_DATE,
                '' AS DELIVER_DATE_,
                '' AS DELIVER_DEPT_ID,
                '' AS ORDER_CODE,
                '' AS ORDER_NUMBER,
                '' as ref_no,
                '' as branch_name
            FROM
            	GET_ORDER_LIST
            GROUP BY
            	COMPANY_ID,
                ORDER_YIL,
                ORDER_AY,
                ORDER_GUN,
                COMP_CODE,
                PROJECT_HEAD,
                PROJECT_ID,
                NICKNAME
            ORDER BY
            	ORDER_YIL DESC,
                ORDER_AY DESC,
                ORDER_GUN DESC,
                COMP_CODE DESC
        </cfquery>        
    </cfif>
    
<cfelse>
  	<cfset arama_yapilmali = 1>
  	<cfset get_order_list.recordcount = 0>
</cfif>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_order_list.recordcount#'>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
<cfquery name="GET_PROCESS_TYPE" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%purchase.list_order%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="form" method="post" action="#request.self#?fuseaction=#url_action#">
        <input name="form_varmi" id="form_varmi" value="1" type="hidden">
            <cf_box_search plus="0">
                <div class="form-group">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                    <cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255" placeholder="#message#">
                </div>
                <div class="form-group">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57487.No'></cfsavecontent>
                    <cfinput type="text" name="order_no" value="#attributes.order_no#" maxlength="255" placeholder="#message#">
                </div>
                <div class="form-group">
                    <select name="order_type" id="order_type">
                        <option value=""><cf_get_lang dictionary_id='61579.Tüm Siparişler'></option>
                        <option value="1" <cfif attributes.order_type eq 1>selected</cfif>><cf_get_lang dictionary_id='42446.Otomatik'></option>
                        <option value="2" <cfif attributes.order_type eq 2>selected</cfif>><cf_get_lang dictionary_id='37748.Mağaza'></option>
                    </select>
                </div>
                <div class="form-group">
                    <select name="listing_type" id="listing_type">
                        <option value="0" <cfif attributes.listing_type eq 0>selected</cfif>><cf_get_lang dictionary_id='39349.Tedarikçi Bazında'></option>
                        <option value="1" <cfif attributes.listing_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57660.Belge Bazında'></option>
                        <option value="2" <cfif attributes.listing_type eq 2>selected</cfif>><cf_get_lang dictionary_id='29539.Satır Bazında'></option>
                    </select>
                </div>
                <div class=form-group>
                    <select name="currency_id" id="currency_id">
                        <option value=""><cf_get_lang dictionary_id='57482.Aşama'></option>
                        <option value="-7" <cfif attributes.currency_id eq -7>selected</cfif>><cf_get_lang dictionary_id ='29748.Eksik Teslimat'></option>
                        <option value="-8" <cfif attributes.currency_id eq -8>selected</cfif>><cf_get_lang dictionary_id ='29749.Fazla Teslimat'></option>
                        <option value="-6" <cfif attributes.currency_id eq -6>selected</cfif>><cf_get_lang dictionary_id='58761.Sevk'></option>
                        <option value="-5" <cfif attributes.currency_id eq -5>selected</cfif>><cf_get_lang dictionary_id ='57456.Üretim'></option>
                        <option value="-4" <cfif attributes.currency_id eq -4>selected</cfif>><cf_get_lang dictionary_id ='29747.Kısmi Üretim'></option>
                        <option value="-3" <cfif attributes.currency_id eq -3>selected</cfif>><cf_get_lang dictionary_id='29746.Kapatıldı'></option>
                        <option value="-2" <cfif attributes.currency_id eq -2>selected</cfif>><cf_get_lang dictionary_id ='29745.Tedarik'></option>
                        <option value="-1" <cfif attributes.currency_id eq -1>selected</cfif>><cf_get_lang dictionary_id='58717.Açık'></option>
                    </select>
                </div>
                <div class="form-group">
                    <select name="irsaliye_fatura" id="irsaliye_fatura">
                        <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                        <option value="3" <cfif attributes.irsaliye_fatura eq 3>selected</cfif>><cf_get_lang dictionary_id='61580.İrsaliyeye veya Faturaya Dönüşmemişler'></option>
                        <option value="1" <cfif attributes.irsaliye_fatura eq 1>selected</cfif>><cf_get_lang dictionary_id="38568.İrsaliyeleşen"></option>
                        <option value="2" <cfif attributes.irsaliye_fatura eq 2>selected</cfif>><cf_get_lang dictionary_id="38569.Faturalaşan"></option>
                    </select>
                </div>
                <div class="form-group">
                    <select name="foreign_categories" id="foreign_categories">
                        <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                        <option value="1" <cfif isdefined("attributes.foreign_categories") and attributes.foreign_categories eq 1> selected</cfif>><cf_get_lang dictionary_id='29692.Yurtdışı'></option>
                        <option value="0" <cfif isdefined("attributes.foreign_categories") and attributes.foreign_categories eq 0> selected</cfif>><cf_get_lang dictionary_id='29691.Yurtiçi'></option>
                    </select>
                </div>
                <div class="form-group">
                    <select name="sort_type" id="sort_type">
                        <option value=""><cf_get_lang dictionary_id='58924.Sıralama'></option>
                        <option value="1" <cfif attributes.sort_type eq 1>selected</cfif>><cf_get_lang dictionary_id='36818.Teslim Tarihine Göre Artan'></option>
                        <option value="2" <cfif attributes.sort_type eq 2>selected</cfif>><cf_get_lang dictionary_id='36819.Teslim Tarihine Göre Azalan'></option>
                        <option value="3" <cfif attributes.sort_type eq 3>selected</cfif>><cf_get_lang dictionary_id='36816.Sipariş Tarihine Göre Artan'></option>
                        <option value="4" <cfif attributes.sort_type eq 4>selected</cfif>><cf_get_lang dictionary_id='36817.Sipariş Tarihine Göre Azalan'></option>
                        <option value="5" <cfif attributes.sort_type eq 5>selected</cfif>><cf_get_lang dictionary_id='61581.Vade Tarihine Göre Artan'></option>
                        <option value="6" <cfif attributes.sort_type eq 6>selected</cfif>><cf_get_lang dictionary_id='61582.Vade Tarihine Göre Azalan'></option>
                    </select>
                </div>
                <div class="form-group ">
                    <div class="input-group small">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı'>!</cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">    
                    </div>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function='input_control()'>
                    <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                </div>
            </cf_box_search>
            <cf_box_search_detail>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group">
                        <label class="col col-12"><cf_get_lang dictionary_id='57544.Sorumlu'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="position_code" id="position_code" value="<cfif len(attributes.position_code) and len(attributes.position_name)><cfoutput>#attributes.position_code#</cfoutput></cfif>">
                                <input type="text" name="position_name" id="position_name" value="<cfif len(attributes.position_code) and len(attributes.position_name)><cfoutput>#attributes.position_name#</cfoutput></cfif>" maxlength="255" onfocus="AutoComplete_Create('position_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','position_code','','3','135');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=form.position_code&field_name=form.position_name&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.form.position_name.value));"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-12"><cf_get_lang dictionary_id='29533.Tedarikçi'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfif isdefined("session.ep.userid")>
                                    <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isDefined("attributes.company") and len(attributes.company)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>" />
                                    <input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isDefined("attributes.company") and len(attributes.company)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
                                    <input type="text" name="company" id="company" value="<cfif isdefined("attributes.company") and len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',0,0','COMPANY_ID,CONSUMER_ID','company_id,consumer_id','','3','250');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_name=form.company&field_comp_id=form.company_id&field_consumer=form.consumer_id<cfif fusebox.circuit eq "store">&is_store_module=1</cfif>&select_list=7,8&keyword='+encodeURIComponent(document.form.company.value));"></span>
                                <cfelse>
                                    <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isDefined("attributes.company") and len(attributes.company)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>" />
                                    <input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isDefined("attributes.company") and len(attributes.company)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
                                    <input type="text" name="company" id="company" value="<cfif isdefined("attributes.company") and len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>" readonly autocomplete="off">
                                </cfif>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-12"><cf_get_lang dictionary_id='44019.Ürün'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="product_id" id="product_id" <cfif len(attributes.product_name)>value="<cfoutput>#attributes.product_id#</cfoutput>"</cfif>>
                                <input type="text" name="product_name" id="product_name" value="<cfoutput>#attributes.product_name#</cfoutput>" passthrough="readonly=yes" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID','product_id','','3','225');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=form.product_id&field_name=form.product_name<cfif fusebox.circuit eq "store">&is_store_module=1</cfif>&keyword='+encodeURIComponent(document.form.product_name.value));"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-12"><cf_get_lang dictionary_id='29401.Ürün Kategorisi'></label>
                        <div class="col col-12">
                            <cfinclude template="../../../../V16/purchase/query/get_product_cat.cfm">
                            <select name="prod_cat" id="prod_cat">
                                <option value="" selected><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_product_cat">
                                    <cfif listlen(HIERARCHY,".") lte 3>
                                        <option value="#HIERARCHY#"<cfif (attributes.prod_cat eq HIERARCHY) and len(attributes.prod_cat) eq len(HIERARCHY)> selected</cfif>>#HIERARCHY#-#product_cat#</option>
                                    </cfif>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group">
                        <label class="col col-12"><cf_get_lang dictionary_id ='57416.Proje'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfif isdefined("session.ep.userid")>
                                    <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined("attributes.project_id") and len (attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
                                    <input type="text" name="project_head" id="project_head" value="<cfif isdefined('attributes.project_head') and  len(attributes.project_head)><cfoutput>#URLDecode(attributes.project_head)#</cfoutput></cfif>" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=form.project_id&project_head=form.project_head');"></span>
                                <cfelse>
                                    <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined("attributes.project_id") and len (attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
                                    <input type="text" name="project_head" id="project_head" value="<cfif isdefined('attributes.project_head') and  len(attributes.project_head)><cfoutput>#URLDecode(attributes.project_head)#</cfoutput></cfif>" readonly autocomplete="off">
                                </cfif>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-12"><cf_get_lang dictionary_id='57899.Kaydeden'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
                                <input type="text" name="employee" id="employee" value="<cfoutput>#attributes.employee#</cfoutput>" onfocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','125');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form.employee_id&field_name=form.employee&select_list=1&branch_related')"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-12"><cf_get_lang dictionary_id='57493.Aktif'>/<cf_get_lang dictionary_id='57494.Pasif'></label>
                        <div class="col col-12">
                            <select name="order_status" id="order_status">
                                <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                                <option value="1"<cfif attributes.order_status eq 1> selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                                <option value="0"<cfif attributes.order_status eq 0> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group">
                        <label class="col col-12"><cf_get_lang dictionary_id='61583.Sipariş Tarihi Başlangıç'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#getLang('','Başlama Tarihi Girmelisiniz',58745)#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-12"><cf_get_lang dictionary_id='61585.Sipariş Tarihi Bitiş'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#getLang('','Bitiş Tarihi Girmelisiniz',57739)#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-12"><cf_get_lang dictionary_id='58763.Depo'></label>
                        <div class="col col-12">
                            <cfif not isdefined("session.check")>
                                <select name="department_id" id="department_id">
                                    <option value=""><cf_get_lang dictionary_id='33775.Tüm Depolar'></option>
                                    <cfoutput query="stores">
                                        <option value="#department_id#"<cfif attributes.department_id eq stores.department_id> selected</cfif>>#department_head#</option>
                                    </cfoutput>
                                </select>
                            <cfelse>
                                <input type="Text" value="<cfoutput>#session.store#<cfif isDefined("SESSION.LOCATION_ID")>--#SESSION.LOCATION_NAME#</cfif></cfoutput>" disabled>
                            </cfif>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                    <div class="form-group">
                        <label class="col col-12"><cf_get_lang dictionary_id='61584.Vade Tarihi Başlangıç'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfinput type="text" name="deliver_start_date" value="#dateformat(attributes.deliver_start_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#getLang('','Başlama Tarihi Girmelisiniz',58745)#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="deliver_start_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-12"><cf_get_lang dictionary_id='61586.Vade Tarihi Bitiş'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfinput type="text" name="deliver_finish_date" value="#dateformat(attributes.deliver_finish_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#getLang('','Bitiş Tarihi Girmelisiniz',57739)#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="deliver_finish_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
                        <div class="col col-12">
                            <select name="order_stage" id="order_stage">
                                <option value=""><cf_get_lang dictionary_id='58859.Süreç'></option>
                                <cfoutput query="get_process_type">
                                    <option value="#process_row_id#"<cfif attributes.order_stage eq process_row_id>selected</cfif>>#stage#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
            </cf_box_search_detail>
        </cfform> 
    </cf_box>
    <cf_box title="#getLang('','Siparişler',45228)#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <!-- sil -->
                    <cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
                        <th></th>
                    </cfif>
                    <!-- sil -->
                    <cfif isdefined("session.ep.userid")><th><cf_get_lang dictionary_id='48886.İşlem Kodu'></th></cfif>
                    <th><cf_get_lang dictionary_id='57487.No'></th>
                    <cfif isdefined("xml_ref_no") and xml_ref_no eq 1>
                    <th><cf_get_lang dictionary_id='58794.Referans No'></th>
                    </cfif>
                    <th><cf_get_lang dictionary_id='57073.Belge Tarihi'></th>
                    <cfif xml_deliver_date eq 1><th><cf_get_lang dictionary_id='57881.Vade Tarihi'></th></cfif>
                    <cfif xml_show_branch eq 1><th><cf_get_lang dictionary_id='57453.Şube'></th></cfif>
                    <cfif isdefined("session.ep.userid")><th><cf_get_lang dictionary_id='58820.Başlık'></th></cfif>
                    <cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
                        <th class="form-title"><cf_get_lang dictionary_id='58800.Ürün Kodu'></th>
                        <th class="form-title"><cf_get_lang dictionary_id='44019.Ürün'></th>
                    </cfif>
                    <th><cf_get_lang dictionary_id='57574.Şirket'><cfif xml_dsp_partner_info_ eq 1> -<cf_get_lang dictionary_id='57578.Yetkili'></cfif></th>
                    <cfif xml_dsp_project_info_ eq 1><th><cf_get_lang dictionary_id='57416.Proje'></th></cfif>
                    <th><cf_get_lang dictionary_id='58763.Depo'></th>
                    <cfif isdefined("session.ep.userid")>
                        <cfif xml_dsp_record_emp_info_ eq 1><th><cf_get_lang dictionary_id='57899.Kaydeden'></th></cfif>
                        <cfif xml_dsp_process_info_ eq 1><th><cf_get_lang dictionary_id='38546.Sipariş Süreci'></th></cfif>
                        <cfif (isdefined('attributes.listing_type') and attributes.listing_type neq 0)>
                            <th><cf_get_lang dictionary_id='57482.Aşama'></th>
                        </cfif>
                    </cfif>
                    <cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
                        <th><cf_get_lang dictionary_id='57635.Miktar'></th>
                        <th><cf_get_lang dictionary_id='58506.İptal'></th>
                        <cfif isdefined('xml_dsp_ship_amount_info_') and xml_dsp_ship_amount_info_ eq 1>
                            <th title="İrsaliyeleşen Miktar"><cf_get_lang dictionary_id='32724.İrsaliye Miktarı'></th>
                            <th><cf_get_lang dictionary_id='58444.Kalan'></th>
                        </cfif>
                        <th class="form-title"><cf_get_lang dictionary_id='57636.Birim'></th>
                    </cfif>
                    <cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2 and isdefined('xml_dsp_row_other_money_') and xml_dsp_row_other_money_ eq 1>
                        <th><cf_get_lang no ='38516.Döviz Birim Fiyat'></th>
                        <th><cf_get_lang dictionary_id ='34434.Para Br'></th>
                    </cfif>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='38568.İrsaliyeleşen'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='58444.Kalan'></th>
                    <cfif isdefined("session.ep.userid")>
                        <th><cf_get_lang dictionary_id ='34434.Para Br'></th>
                        <th style="text-align:right;"><cf_get_lang dictionary_id='57677.Döviz'><cf_get_lang dictionary_id='57673.Tutar'></th>
                        <th><cf_get_lang dictionary_id ='34434.Para Br'></th>
                        <th style="text-align:right;"><cf_get_lang dictionary_id='44019.Ürün'></th>
                        <th style="text-align:right;"><cf_get_lang dictionary_id='32658.Onaysız'></th>
                        <th style="text-align:right;"><cf_get_lang dictionary_id='32658.Onaysız'></th>
                        <cfif isdefined("session.ep.userid")>
                            <!-- sil -->
                            <cfif fusebox.circuit is 'store'>
                                <th width="15" class="header_icn_none"><!---<a href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_orders_purchase</cfoutput>"><i class="fa fa-plus"></i></a>---></th>
                            <cfelse>
                                <th width="15" class="header_icn_none"><!---<a href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_order&event=add</cfoutput>"><i class="fa fa-plus"></i></a>---></th>
                            </cfif>
                            <!-- sil -->
                        </cfif>
                    </cfif>
                    <th width="20"></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_order_list.recordcount>
                    <cfscript>
                        partner_id_list='';
                        employee_id_list='';
                        company_id_list='';
                        consumer_id_list='';
                        depo_list = '';
                        order_stage_list='';
                        orders_id_list = '';
                        order_row_id_list='';
                        project_name_list = "";
                    </cfscript>
                    <cfoutput query="get_order_list" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                        <cfif len(deliver_dept_id) and not listfind(depo_list,deliver_dept_id)>
                            <cfset depo_list = listappend(depo_list,deliver_dept_id)>
                        </cfif>
                        <cfif len(order_id) and is_processed eq 1>
                            <cfif not listfind(orders_id_list,order_id)>
                                <cfset orders_id_list=listappend(orders_id_list,order_id)>
                            </cfif>
                            <cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)>
                                <cfset order_row_id_list=listappend(order_row_id_list,order_row_id)>				
                            </cfif>
                        </cfif>
                    </cfoutput>
                    <cfif len(depo_list)>
                        <cfset depo_list = listsort(depo_list,"numeric","ASC",",")>
                        <cfquery name="get_all_dep" datasource="#dsn#">
                            SELECT DEPARTMENT_HEAD,DEPARTMENT_ID FROM DEPARTMENT WHERE <cfif len(depo_list)> DEPARTMENT_ID IN (#depo_list#) <cfelse> DEPARTMENT_ID IS NULL </cfif> ORDER BY DEPARTMENT_ID
                        </cfquery>
                        <cfset depo_list = ListSort(ListDeleteDuplicates(ValueList(get_all_dep.department_id,',')),'numeric','ASC',',')>
                    </cfif>
                    <cfif len(orders_id_list)>
                        <cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
                            <cfquery name="get_order_ship_periods" datasource="#dsn3#">
                                SELECT DISTINCT PERIOD_ID FROM ORDERS_SHIP WHERE ORDER_ID IN (0)<!--- #orders_id_list# --->
                                UNION ALL
                                SELECT DISTINCT PERIOD_ID FROM ORDERS_INVOICE WHERE ORDER_ID IN (0)<!--- #orders_id_list# --->
                            </cfquery>
                            <cfif get_order_ship_periods.recordcount>
                                <cfset orders_ship_period_list =listdeleteduplicates(valuelist(get_order_ship_periods.PERIOD_ID))>
                                <cfif listlen(orders_ship_period_list) eq 1 and orders_ship_period_list eq session_base.period_id>
                                    <cfquery name="get_ship_info" datasource="#dsn2#">
                                        SELECT SR.SHIP_ID,SR.STOCK_ID,ISNULL(ORR.WRK_ROW_ID,0) AS ORDER_WRK_ROW_ID,SR.ROW_ORDER_ID ORDER_ID,SR.AMOUNT FROM SHIP_ROW SR,#dsn3_alias#.ORDER_ROW ORR WHERE SR.WRK_ROW_RELATION_ID=ORR.WRK_ROW_ID AND SR.ROW_ORDER_ID IN (#orders_id_list#)
                                    </cfquery>
                                <cfelse>
                                    <!---siparis farklı periyotlardaki irsaliyelerle iliskili --->
                                    <cfquery name="get_period_dsns" datasource="#dsn2#">
                                        SELECT PERIOD_YEAR,OUR_COMPANY_ID,PERIOD_ID FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID IN (#orders_ship_period_list#)
                                    </cfquery>
                                    <cfquery name="get_ship_info" datasource="#dsn2#">
                                        SELECT
                                            A1.SHIP_ID,
                                            A1.ORDER_WRK_ROW_ID,
                                            A1.ROW_ORDER_ID ORDER_ID,
                                            A1.STOCK_ID,
                                            A1.AMOUNT
                                        FROM
                                        (
                                        <cfloop query="get_period_dsns">
                                            SELECT
                                                SR.SHIP_ID,
                                                ISNULL(SR.WRK_ROW_RELATION_ID,0) AS ORDER_WRK_ROW_ID,
                                                SR.ROW_ORDER_ID,
                                                SR.STOCK_ID,
                                                SR.AMOUNT
                                            FROM
                                                #dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP_ROW SR
                                            WHERE
                                                SR.ROW_ORDER_ID IN (#orders_id_list#)
                                            <cfif currentrow neq get_period_dsns.recordcount> UNION ALL </cfif>					
                                        </cfloop> ) AS A1
                                    </cfquery>
                                </cfif>
                                <cfif listlen(orders_ship_period_list) eq 1 and orders_ship_period_list eq session.ep.period_id>
                                    <cfquery name="get_invoice_info" datasource="#dsn3#">
                                        SELECT 
                                            IR.INVOICE_ID,
                                            ORR.WRK_ROW_ID AS ORDER_WRK_ROW_ID,
                                            ORR.ORDER_ID,
                                            ORR.STOCK_ID,
                                            IR.AMOUNT
                                        FROM 
                                            #dsn2_alias#.INVOICE_ROW IR,
                                            ORDER_ROW ORR
                                        WHERE 
                                            (
                                                IR.WRK_ROW_RELATION_ID = ORR.WRK_ROW_ID 
                                                OR 
                                                IR.WRK_ROW_RELATION_ID IN (SELECT SR.WRK_ROW_ID FROM #dsn2_alias#.SHIP_ROW SR WHERE SR.WRK_ROW_RELATION_ID = ORR.WRK_ROW_ID)
                                            )
                                            AND ORR.ORDER_ROW_ID IN (#order_row_id_list#)
                                    </cfquery>
                                <cfelse>
                                    <cfquery name="get_period_dsns" datasource="#dsn#">
                                        SELECT PERIOD_YEAR,OUR_COMPANY_ID,PERIOD_ID FROM SETUP_PERIOD WHERE PERIOD_ID IN (#orders_ship_period_list#)
                                    </cfquery>
                                    <cfquery name="get_invoice_info" datasource="#dsn3#">
                                        SELECT
                                            A1.INVOICE_ID,
                                            A1.ORDER_WRK_ROW_ID,
                                            A1.ORDER_ID,
                                            A1.STOCK_ID,
                                            A1.AMOUNT
                                        FROM
                                        (
                                        <cfloop query="get_period_dsns">
                                        SELECT 
                                            IR.INVOICE_ID,
                                            ORR.WRK_ROW_ID AS ORDER_WRK_ROW_ID,
                                            ORR.ORDER_ID,
                                            ORR.STOCK_ID,
                                            IR.AMOUNT
                                        FROM 
                                            #dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.INVOICE_ROW IR,
                                            ORDER_ROW ORR
                                        WHERE 
                                            (
                                                IR.WRK_ROW_RELATION_ID = ORR.WRK_ROW_ID 
                                                OR 
                                                IR.WRK_ROW_RELATION_ID IN (SELECT SR.WRK_ROW_ID FROM #dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP_ROW SR WHERE SR.WRK_ROW_RELATION_ID = ORR.WRK_ROW_ID)
                                            )
                                            AND ORR.ORDER_ROW_ID IN (#order_row_id_list#)
                                            <cfif currentrow neq get_period_dsns.recordcount> UNION ALL </cfif>					
                                        </cfloop> ) AS A1
                                    </cfquery>
                                </cfif>
                            </cfif>
                            <cfscript>
                                if(isdefined("get_ship_info"))
                                    for(ord_ii=1; ord_ii lte get_ship_info.recordcount; ord_ii=ord_ii+1)
                                    {
                                        if(isdefined('row_ship_amount_#get_ship_info.ORDER_ID[ord_ii]#_#get_ship_info.STOCK_ID[ord_ii]#_#get_ship_info.ORDER_WRK_ROW_ID[ord_ii]#') and len(evaluate('row_ship_amount_#get_ship_info.ORDER_ID[ord_ii]#_#get_ship_info.STOCK_ID[ord_ii]#_#get_ship_info.ORDER_WRK_ROW_ID[ord_ii]#')))
                                            'row_ship_amount_#get_ship_info.ORDER_ID[ord_ii]#_#get_ship_info.STOCK_ID[ord_ii]#_#get_ship_info.ORDER_WRK_ROW_ID[ord_ii]#'= evaluate('row_ship_amount_#get_ship_info.ORDER_ID[ord_ii]#_#get_ship_info.STOCK_ID[ord_ii]#_#get_ship_info.ORDER_WRK_ROW_ID[ord_ii]#') + get_ship_info.AMOUNT[ord_ii];
                                        else
                                            'row_ship_amount_#get_ship_info.ORDER_ID[ord_ii]#_#get_ship_info.STOCK_ID[ord_ii]#_#get_ship_info.ORDER_WRK_ROW_ID[ord_ii]#'= get_ship_info.AMOUNT[ord_ii];
            
                                        'order_row_ship_info_#get_ship_info.ORDER_WRK_ROW_ID[ord_ii]#' = 1;
                                    }
                                if(isdefined("get_invoice_info"))
                                    for(ord_ii=1; ord_ii lte get_invoice_info.recordcount; ord_ii=ord_ii+1)
                                    {
                                        'order_row_invoice_info_#get_invoice_info.ORDER_WRK_ROW_ID[ord_ii]#' = 1;
                                    }
                            </cfscript>           
                        <cfelse><!--- belge bazında --->
                            <!--- Siparişten irsaliyeye ve direkt faturaya çekilenleri bulduk. --->
                            <cfquery name="get_orders_ship_and_invoice" datasource="#dsn3#">
                                    SELECT 'irsaliye' TYPE,ORDER_ID,SHIP_ID,PERIOD_ID FROM ORDERS_SHIP WHERE ORDER_ID IN (#orders_id_list#) 
                                UNION ALL
                                    SELECT 'fatura' TYPE,ORDER_ID,'' AS SHIP_ID,PERIOD_ID FROM ORDERS_INVOICE  WHERE ORDER_ID IN (#orders_id_list#) 
                                    <!--- Period Eklerseniz bir önceki dönemin şipariş bilgileri gelmez eklemeyiniz please..M.ER 20 01 2009 --->
                            </cfquery>
                            <cfset ship_id_list = listdeleteduplicates(ValueList(get_orders_ship_and_invoice.SHIP_ID,','))>
                            <cfset ship_period_list=listdeleteduplicates(valuelist(get_orders_ship_and_invoice.PERIOD_ID))>
                            <cfif len(ship_id_list)>
                                <cfif listlen(ship_period_list) eq 1 and ((isdefined("session.ep.period_id") and ship_period_list eq session.ep.period_id) or (isdefined("session.pp.period_id") and ship_period_list eq session.pp.period_id))>
                                    <cfif (isdefined('xml_dsp_ship_amount_info_') and xml_dsp_ship_amount_info_ eq 1) or (isdefined('xml_dps_price_from_row_amount_') and xml_dps_price_from_row_amount_ eq 1)><!--- irsaliyelesen miktar bulunuyor --->
                                        <cfquery name="GET_ALL_SHIP_AMOUNT" datasource="#dsn2#">
                                            SELECT 
                                                SUM(AMOUNT) AS AMOUNT,ISNULL(WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID,STOCK_ID,PRODUCT_ID,ROW_ORDER_ID
                                            FROM
                                                SHIP_ROW
                                            WHERE
                                                SHIP_ID IN (#ship_id_list#)
                                                AND ROW_ORDER_ID IN (#orders_id_list#)
                                            GROUP BY
                                                ISNULL(WRK_ROW_RELATION_ID,0),STOCK_ID,PRODUCT_ID,ROW_ORDER_ID
                                        </cfquery>
                                    </cfif>
                                    <cfquery name="ALL_GET_SHIP_INVOICE" datasource="#dsn2#">
                                        SELECT SHIP_ID FROM INVOICE_SHIPS WHERE SHIP_ID IN(#ship_id_list#)
                                    </cfquery>
                                <cfelse>
                                    <cfquery name="get_ship_periods_" datasource="#dsn#">
                                        SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID IN (#ship_period_list#)
                                    </cfquery>
                                    <cfoutput query="get_orders_ship_and_invoice">
                                        <cfif len(get_orders_ship_and_invoice.SHIP_ID)>
                                            <cfif isdefined('control_ship_list_#period_id#')>
                                                <cfset 'control_ship_list_#period_id#'=listappend(evaluate('control_ship_list_#period_id#'),get_orders_ship_and_invoice.SHIP_ID)>
                                            <cfelse>
                                                <cfset 'control_ship_list_#period_id#'=get_orders_ship_and_invoice.SHIP_ID>
                                            </cfif>
                                        </cfif>
                                    </cfoutput>
                                    <cfif (isdefined('xml_dsp_ship_amount_info_') and xml_dsp_ship_amount_info_ eq 1) or (isdefined('xml_dps_price_from_row_amount_') and xml_dps_price_from_row_amount_ eq 1)><!--- irsaliyelesen miktar bulunuyor --->
                                        <cfquery name="GET_ALL_SHIP_AMOUNT" datasource="#dsn2#">
                                            <cfloop query="get_ship_periods_">
                                                SELECT 
                                                    SUM(AMOUNT) AS AMOUNT,ISNULL(WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID,STOCK_ID,PRODUCT_ID,ROW_ORDER_ID
                                                FROM
                                                    #dsn#_#get_ship_periods_.PERIOD_YEAR#_#get_ship_periods_.OUR_COMPANY_ID#.SHIP_ROW
                                                WHERE
                                                    SHIP_ID IN (#evaluate('control_ship_list_#get_ship_periods_.period_id#')#)
                                                    AND ROW_ORDER_ID IN (#orders_id_list#)
                                                GROUP BY 
                                                    ISNULL(WRK_ROW_RELATION_ID,0),STOCK_ID,PRODUCT_ID,ROW_ORDER_ID
                                                <cfif get_ship_periods_.recordcount neq 1 and currentrow neq get_ship_periods_.recordcount>
                                                UNION ALL
                                                </cfif>
                                            </cfloop>
                                        </cfquery>
                                    </cfif>
                                    <cfquery name="ALL_GET_SHIP_INVOICE" datasource="#dsn2#">
                                        <cfloop query="get_ship_periods_">
                                            SELECT 
                                                SHIP_ID 
                                            FROM 
                                                #dsn#_#get_ship_periods_.PERIOD_YEAR#_#get_ship_periods_.OUR_COMPANY_ID#.INVOICE_SHIPS
                                            WHERE
                                                SHIP_ID IN (#evaluate('control_ship_list_#get_ship_periods_.period_id#')#) AND SHIP_PERIOD_ID=#get_ship_periods_.period_id#
                                            <cfif get_ship_periods_.recordcount neq 1 and currentrow neq get_ship_periods_.recordcount>
                                            UNION ALL
                                            </cfif>
                                        </cfloop>
                                    </cfquery>
                                </cfif>
                            </cfif>
                            <cfif get_orders_ship_and_invoice.recordcount>
                                <cfscript>
                                    order_and_ship_list ='';
                                    for(oi=1;oi lte get_orders_ship_and_invoice.recordcount;oi=oi+1){
                                        'order_info_#get_orders_ship_and_invoice.ORDER_ID[oi]#_#get_orders_ship_and_invoice.TYPE[oi]#' = 1;
                                        if(len(get_orders_ship_and_invoice.SHIP_ID[oi])){
                                            order_and_ship_list = ListAppend(order_and_ship_list,get_orders_ship_and_invoice.ORDER_ID[oi],',');
                                            order_and_ship_list = ListAppend(order_and_ship_list,get_orders_ship_and_invoice.SHIP_ID[oi],'█');
                                        }	
                                    }
                                </cfscript>
                                <cfif len(order_and_ship_list) and len(ship_id_list)>
                                    <cfloop list="#order_and_ship_list#" delimiters="," index="sh_or">
                                        <cfquery name="GET_SHIP_INVOICE"dbtype="query">
                                            SELECT SHIP_ID FROM ALL_GET_SHIP_INVOICE WHERE SHIP_ID = #ListGetAt(sh_or,2,'█')#
                                        </cfquery>
                                        <cfif GET_SHIP_INVOICE.recordcount><cfset 'order_info_#ListGetAt(sh_or,1,'█')#_fatura' = 1></cfif>
                                    </cfloop>
                                </cfif>
                            </cfif>
                        </cfif>
                    </cfif>
                    <cfset page_total = 0>
                    <cfset page_total_d = 0>
                    
                    <cfset comp_total = 0>
                    <cfset comp_total_d = 0>
                    
                    <cfset vade_total = 0>
                    <cfset vade_total_d = 0>
                    
                    <cfset depo_total = 0>
                    <cfset depo_total_d = 0>
      
                    <cfoutput query="get_order_list" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                        <cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2><!--- satır bazında listeleme yapılacaksa --->
                            <cfset row_ship_amount_=0>
                            <cfif (isdefined('xml_dsp_ship_amount_info_') and xml_dsp_ship_amount_info_ eq 1) or (isdefined('xml_dps_price_from_row_amount_') and xml_dps_price_from_row_amount_ eq 1)>
                                <cfif isdefined('row_ship_amount_#ORDER_ID#_#STOCK_ID#_#WRK_ROW_ID#') and len(evaluate('row_ship_amount_#ORDER_ID#_#STOCK_ID#_#WRK_ROW_ID#'))>
                                    <cfset row_ship_amount_=evaluate('row_ship_amount_#ORDER_ID#_#STOCK_ID#_#WRK_ROW_ID#')>
                                </cfif>
                            </cfif>
                        </cfif>
                        <cfif isdefined("attributes.view_type")><cfset vade_ = dateformat(vade_tarihi,'ddmmyyyy')></cfif>
                        <tr <cfif isdefined("attributes.view_type")>style="display:none;" rel_dept="dept_rows_#deliver_dept_id#_#vade_#_#company_id#" rel_date1="date_rows_#vade_#_#company_id#" rel_comp2="company_rows_#company_id#"</cfif>>
                            <!-- sil -->
                            <cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
                                <td align="center" id="order_row#currentrow#" class="color-row" onclick="gizle_goster(order_stocks_detail#currentrow#);connectAjax('#currentrow#','#PRODUCT_ID#','#STOCK_ID#','#unit#','#numberformat(quantity)#');gizle_goster(siparis_goster#currentrow#);gizle_goster(siparis_gizle#currentrow#);">
                                    <img id="siparis_goster#currentrow#" src="/images/listele.gif" title="<cf_get_lang dictionary_id ='58596.Göster'>">
                                    <img id="siparis_gizle#currentrow#" src="/images/listele_down.gif" title="<cf_get_lang dictionary_id ='58628.Gizle'>" style="display:none">
                                </td>
                            </cfif>
                            <!-- sil -->
                            <cfif isdefined("session.ep.userid")>
                            <td>
                                <div id="aciklama_#currentrow#" style="display:none; position:absolute; padding:3px; width:1000px; margin-top:20px; border:2px ##000000 solid; background-color:yellow;" onmouseout="hide('aciklama_#currentrow#');">
                                    <cf_get_lang dictionary_id='63177.Detay Siparişler Yükleniyor'>
                                </div>
                                <cfif len(order_code)>
                                    <a href="#request.self#?fuseaction=retail.speed_manage_product_new&order_code=#order_code#" class="tableyazi" target="_blank">#order_code#</a>
                                <cfelse>
                                    <cfif attributes.listing_type eq 0>
                                    #BELGE_SAYISI# <cf_get_lang dictionary_id='57611.Sipariş'>
                                    </cfif>
                                </cfif>
                            </td>
                            </cfif>
                            <td><a href="#request.self#?fuseaction=retail.speed_manage_product_new&order_id=#order_id#" class="tableyazi" target="_blank">#order_number#</a></td>
                            <cfif isdefined("xml_ref_no") and xml_ref_no eq 1>
                            <td>#REF_NO#</td>
                            </cfif>
                            <td align="center">
                                <cfif attributes.listing_type eq 0>
                                    #dateformat(createodbcdatetime(createdate(ORDER_YIL,ORDER_AY,ORDER_GUN)),'dd/mm/yyyy')#
                                <cfelse>
                                    #dateformat(order_date,'dd/mm/yyyy')#
                                </cfif>
                            </td>
                            <cfif xml_deliver_date eq 1>
                            <td align="center">
                                <cfif attributes.listing_type eq 0>
                                    #dateformat(createodbcdatetime(createdate(ORDER_YIL,ORDER_AY,ORDER_GUN)),'dd/mm/yyyy')#
                                <cfelse>
                                    #dateformat(vade_tarihi,'dd/mm/yyyy')#
                                </cfif>
                            </td>
                            </cfif>
                            <cfif xml_show_branch eq 1><td>#branch_name#</td></cfif>
                            <cfif isdefined("session.ep.userid")>
                            <td width="100">
                            <cfif attributes.listing_type eq 0>
                                #order_head#
                            <cfelse>
                                #order_head#
                            </cfif>    
                            </td>
                            </cfif>
                            <cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
                                <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#PRODUCT_ID#','medium');" class="tableyazi">#STOCK_CODE#</a></td>
                                <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#PRODUCT_ID#','medium');" class="tableyazi">#PRODUCT_NAME#</a></td>
                            </cfif>
                            <td width="200px;">
                                <cfif len(company_id)>
                                    <a href="#request.self#?fuseaction=retail.speed_manage_product_new&order_company_code=#COMP_CODE#&order_date=<cfif attributes.listing_type eq 0>#dateformat(createodbcdatetime(createdate(ORDER_YIL,ORDER_AY,ORDER_GUN)),'ddmmyyyy')#<cfelse>#dateformat(order_date,'ddmmyyyy')#</cfif>" class="tableyazi" target="_blank">#NICKNAME#</a>
                                <cfelseif Len(consumer_id)>
                                    #CONSUMER_NAME#
                                </cfif>
                            </td>
                            <cfif xml_dsp_project_info_ eq 1>
                                <td>
                                <cfif isdefined("session.ep.userid")>
                                    <cfif isdefined("get_order_list.project_id") and get_order_list.project_id neq 0> 
                                        <a href="#request.self#?fuseaction=project.projects&event=det&id=#PROJECT_ID#" class="tableyazi">#PROJECT_HEAD#</a>
                                    <cfelse>
                                        <cf_get_lang dictionary_id='58459.Projesiz'>
                                    </cfif>
                                <cfelse>
                                    <cfif isdefined("get_order_list.project_id") and len(get_order_list.project_id)> 
                                        #PROJECT_HEAD#
                                    <cfelse>
                                        <cf_get_lang dictionary_id='58459.Projesiz'>
                                    </cfif>
                                </cfif>
                                </td> 
                            </cfif>
                            <td <!---<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 0)>onmouseover="get_aciklama('#currentrow#','#comp_code#','#attributes.order_stage#','#dateformat(createodbcdatetime(createdate(ORDER_YIL,ORDER_AY,ORDER_GUN)),'ddmmyyyy')#');" onmouseout="hide('aciklama_#currentrow#');"</cfif>--->>
                            <cfif attributes.listing_type eq 0>
                                #DEPO_SAYISI# <cf_get_lang dictionary_id='58763.Depo'>
                            <cfelse>
                                <cfif isdefined('get_all_dep.department_head')>#get_all_dep.department_head[listfind(depo_list,DELIVER_DEPT_ID,',')]#</cfif>
                            </cfif>
                            </td>
                            <cfif isdefined("session.ep.userid")>
                                <cfif xml_dsp_record_emp_info_ eq 1>
                                <td nowrap>
                                <cfif attributes.listing_type eq 0>
                                    #KAYDEDEN_SAYISI# <cf_get_lang dictionary_id='29831.Kişi'>
                                <cfelse>
                                    <cfif isdefined("session.ep.userid")>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#RECORD_EMP#','medium');" class="tableyazi">#EMPLOYEE_NAME#</a>
                                    <cfelse>
                                        #EMPLOYEE_NAME#
                                    </cfif>
                                </cfif>
                                </td>
                                </cfif>
                                <cfif xml_dsp_process_info_ eq 1>
                                    <td>
                                    <cfif attributes.listing_type eq 0>
                                        #SUREC_SAYISI# <cf_get_lang dictionary_id='57482.Aşama'>
                                    <cfelse>
                                        #STAGE#
                                    </cfif>
                                    </td>
                                </cfif>
                            
                                <cfif (isdefined('attributes.listing_type') and attributes.listing_type neq 0)>
                                <td nowrap>
                                    <cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)>
                                        <cfswitch expression = "#ORDER_ROW_CURRENCY#">
                                            <cfcase value="-7"><cf_get_lang dictionary_id='29748.Eksik Teslimat'> </cfcase>
                                            <cfcase value="-8"><cf_get_lang dictionary_id='29749.Fazla Teslimat'> </cfcase>
                                            <cfcase value="-6"><cf_get_lang dictionary_id='58761.Sevk'> </cfcase>
                                            <cfcase value="-5"><cf_get_lang dictionary_id='57456.Üretim'> </cfcase>
                                            <cfcase value="-4"><cf_get_lang dictionary_id='29747.Kısmi Üretim'> </cfcase>
                                            <cfcase value="-3"><cf_get_lang dictionary_id='29746.Kapatıldı'> </cfcase>
                                            <cfcase value="-2"><cf_get_lang dictionary_id='29745.Tedarik'> </cfcase>
                                            <cfcase value="-1"><cf_get_lang dictionary_id='58717.Açık'> </cfcase>
                                        </cfswitch>
                                    </cfif>
                                    <br>
                                    <cfif is_processed eq 1>
                                        <cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2>
                                            <cfif isdefined('xml_dsp_ship_amount_info_') and xml_dsp_ship_amount_info_ eq 1>
                                                <cfif isdefined('order_row_ship_info_#WRK_ROW_ID#') and evaluate('order_row_ship_info_#WRK_ROW_ID#') eq 1>
                                                    <cf_get_lang dictionary_id='57893.İrsaliye Kesildi'><br/>
                                                </cfif>
                                                <cfif isdefined('order_row_invoice_info_#WRK_ROW_ID#') and evaluate('order_row_invoice_info_#WRK_ROW_ID#') eq 1>
                                                    <cf_get_lang dictionary_id='30878.Faturalandı'>
                                                </cfif>
                                            </cfif>
                                        <cfelse>
                                            <cfif isdefined('order_info_#ORDER_ID#_irsaliye')>
                                                <cf_get_lang dictionary_id='57893.İrsaliye Kesildi'><br/>
                                            </cfif>
                                            <cfif isdefined('order_info_#ORDER_ID#_fatura')>
                                                <cf_get_lang dictionary_id=' 30878.Faturalandı'>
                                            </cfif>
                                        </cfif>
                                    </cfif>
                                </td>
                                </cfif>
                            </cfif>
                            <cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
                                <td align="right" style="text-align:right;">#quantity#</td>
                                <td align="right" style="text-align:right;">#cancel_amount#</td>
                                <cfif isdefined('xml_dsp_ship_amount_info_') and xml_dsp_ship_amount_info_ eq 1>
                                    <td align="right" style="text-align:right;"><!--- irsaliyelesen--->
                                        <cfif row_ship_amount_ neq 0>
                                            #row_ship_amount_#
                                        <cfelse>
                                            0
                                        </cfif>
                                    </td>
                                    <td align="right" style="text-align:right;"><!--- kalan --->
                                        <cfif len(row_ship_amount_)>
                                            #quantity-cancel_amount-row_ship_amount_#
                                        </cfif>
                                    </td>
                                </cfif>
                                <td>#unit#</td>
                            </cfif>
                    
                            <cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2) and isdefined('xml_dsp_row_other_money_') and xml_dsp_row_other_money_ eq 1>
                                <td align="right" style="text-align:right;"><cfif len(PRICE_OTHER)>#TLFormat(PRICE_OTHER)#</cfif></td>
                                <td><cfif len(PRICE_OTHER)>#OTHER_MONEY#</cfif></td>
                            </cfif>
                            <td align="right" style="text-align:right;">
                                <cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2) and isdefined('xml_dps_price_from_row_amount_') and xml_dps_price_from_row_amount_ eq 1 and row_ship_amount_ neq 0>
                                    <cfset nettotal_ = ((quantity-cancel_amount-row_ship_amount_)*PRICE)>
                                <cfelse>
                                    <cfif len(NETTOTAL)>
                                        <cfset nettotal_ = NETTOTAL>
                                    <cfelse>
                                        <cfset nettotal_ = 0>
                                    </cfif>
                                </cfif>
                                #TLFormat(nettotal_)#
                                <cfset page_total = page_total + nettotal_>
                            </td>
                            <td style="text-align:right;">
                                <cfif len(donusen)>
                                    <cfset donusen_ = donusen>
                                <cfelse>
                                    <cfset donusen_ = 0>
                                </cfif>
                                #TLFormat(donusen_)#
                                <cfset page_total_d = page_total_d + donusen_>
                            </td>
                            <td style="text-align:right;">#tlformat(nettotal_ - donusen_)#</td>
                        <cfif isdefined("session.ep.userid")>
                            <td>&nbsp;#session.ep.money#</td>
                            <td align="right" style="text-align:right;">
                                <cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2) and isdefined('xml_dps_price_from_row_amount_') and xml_dps_price_from_row_amount_ eq 1 and row_ship_amount_ neq 0>
                                    #TLFormat((quantity-row_ship_amount_)*PRICE_OTHER)#
                                <cfelse>
                                    #TLFormat(OTHER_MONEY_VALUE)#
                                </cfif>
                            </td>
                            <td>&nbsp;
                                <cfif len(OTHER_MONEY_VALUE)>
                                    <cfif session.ep.period_year gte 2009 and len(OTHER_MONEY) and OTHER_MONEY is 'YTL'>
                                        #session.ep.money#
                                    <cfelseif session.ep.period_year lt 2009 and len(OTHER_MONEY) and OTHER_MONEY is 'TL'>
                                        #session.ep.money#
                                    <cfelse>
                                        #OTHER_MONEY#
                                    </cfif>
                                </cfif>
                            </td>
                            <td style="text-align:right;">#tlformat(URUN_SAYISI,0)#</td>
                            <td style="text-align:right;">#tlformat(ACIK_URUN_SAYISI,0)#</td>
                            <td style="text-align:right;">#tlformat(SEVK_URUN_SAYISI,0)#</td>
                            <cfif isdefined("session.ep.userid")>
                            <!-- sil -->
                            <td width= "15" align="center"><a href="#request.self#?fuseaction=#my_url_action#&order_id=#order_id#"><i class="fa fa-pencil"></i></a></td>
                            <!-- sil -->
                            </cfif>
                    </cfif>
                            <td nowrap="nowrap">
                                <ul class="ui-icon-list">
                                <!---<li><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=retail.popup_update_order_speed_manage_product&order_id=#ORDER_ID#&is_view=1','page');"><i class="fa fa-envelope"></i></a></li>--->
                                <li><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#ORDER_ID#&print_type=91','page')"><i class="fa fa-print"></i></a>
                                </ul></li>
                            </td>
                        </tr>
                        <!-- sil -->
                        <tr id="order_stocks_detail#currentrow#" class="color-list" style="display:none">
                            <td colspan="25">
                                <div align="left" id="DISPLAY_ORDER_STOCK_INFO#currentrow#"></div>
                            </td>
                        </tr>
                        <!-- sil -->
                        <cfset comp_total = comp_total + nettotal_>
                        <cfset comp_total_d = comp_total_d + donusen_>
                        
                        <cfset vade_total = vade_total + nettotal_>
                        <cfset vade_total_d = vade_total_d + donusen_>
                        
                        <cfset depo_total = depo_total + nettotal_>
                        <cfset depo_total_d = depo_total_d + donusen_>
                    
                    <cfif isdefined("attributes.view_type")>
                        <cfif currentrow eq get_order_list.recordcount or deliver_dept_id neq deliver_dept_id[currentrow + 1]>
                            <cfset vade_ = dateformat(vade_tarihi,'ddmmyyyy')>
                            <tr <cfif isdefined("attributes.view_type")>style="display:none;" rel_date="date_rows_#vade_#_#company_id#" rel_comp1="company_rows_#company_id#"</cfif>>
                                <td colspan="19" style="font-weight:bold;">
                                    <a href="javascript://" onclick="get_comp_dept_vade_rows('#company_id#','#vade_#','#deliver_dept_id#');">Depo : <cfif isdefined('get_all_dep.department_head')>#get_all_dep.department_head[listfind(depo_list,DELIVER_DEPT_ID,',')]#</cfif></a>
                                </td>
                                <td style="text-align:right;font-weight:bold;">#tlformat(depo_total)#</td>
                                <td style="text-align:right;font-weight:bold;">#tlformat(depo_total_d)#</td>
                                <td style="text-align:right;font-weight:bold;">#tlformat(depo_total - depo_total_d)#</td>
                                <td colspan="8" style="text-align:right;"></td>
                            </tr>
                            <cfset depo_total = 0>
                            <cfset depo_total_d = 0>
                        </cfif>
                        <cfif currentrow eq get_order_list.recordcount or vade_tarihi neq vade_tarihi[currentrow + 1]>
                            <cfset vade_ = dateformat(vade_tarihi,'ddmmyyyy')>
                            <tr <cfif isdefined("attributes.view_type")>style="display:none;" rel_comp="company_rows_#company_id#"</cfif>>
                                <td colspan="19" style="font-weight:bold;">
                                    <a href="javascript://" onclick="get_comp_vade_rows('#company_id#','#vade_#');">Vade Tarihi : #dateformat(vade_tarihi,'dd/mm/yyyy')#</a>
                                </td>
                                <td style="text-align:right;font-weight:bold;">#tlformat(vade_total)#</td>
                                <td style="text-align:right;font-weight:bold;">#tlformat(vade_total_d)#</td>
                                <td style="text-align:right;font-weight:bold;">#tlformat(vade_total - vade_total_d)#</td>
                                <td colspan="8" style="text-align:right;"></td>
                            </tr>
                            <input type="hidden" name="comp_vade_durum_#vade_#_#company_id#" id="comp_vade_durum_#vade_#_#company_id#" value="0"/>
                            <cfset vade_total = 0>
                            <cfset vade_total_d = 0>
                        </cfif>
                        <cfif currentrow eq get_order_list.recordcount or company_id neq company_id[currentrow + 1]>
                            <tr>
                                <td colspan="19" style="font-weight:bold;">
                                    <input type="hidden" name="comp_durum_#company_id#" id="comp_durum_#company_id#" value="0"/>
                                    <a href="javascript://" onclick="get_comp_rows('#company_id#');"><cfif len(company_id)>
                                        #NICKNAME#
                                    <cfelseif Len(consumer_id)>
                                        #CONSUMER_NAME#
                                    </cfif></a>
                                </td>
                                <td style="text-align:right;font-weight:bold;">#tlformat(comp_total)#</td>
                                <td style="text-align:right;font-weight:bold;">#tlformat(comp_total_d)#</td>
                                <td style="text-align:right;font-weight:bold;">#tlformat(comp_total - comp_total_d)#</td>
                                <td colspan="8" style="text-align:right;"></td>
                            </tr>
                            <cfset comp_total = 0>
                            <cfset comp_total_d = 0>
                        </cfif>
                </cfif>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="23"><cfif arama_yapilmali neq 1><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></td>
                    </tr>
                </cfif>
            </tbody>
            <cfif get_order_list.recordcount>
            <cfquery name="get_totals" dbtype="query">
                SELECT
                    SUM(NETTOTAL) AS GT,
                    SUM(DONUSEN) AS DT,
                    SUM(NETTOTAL - DONUSEN) AS KT
                FROM
                    get_order_list
            </cfquery>
            <cfoutput>
                <tfoot>
                    <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td colspan="<cfif attributes.listing_type eq 2>8</cfif>" style="text-align:right;" class="formbold"><cf_get_lang dictionary_id='55447.Sayfa Toplam'></td>
                        <td style="text-align:right;" class="formbold">#tlformat(page_total)#</td>
                        <td style="text-align:right;" class="formbold">#tlformat(page_total_d)#</td>
                        <td style="text-align:right;" class="formbold">#tlformat(page_total - page_total_d)#</td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td colspan="<cfif attributes.listing_type eq 2>8</cfif>" style="text-align:right;" class="formbold"><cf_get_lang dictionary_id='57680.Genel Toplam'></td>
                        <td style="text-align:right;" class="formbold">#tlformat(get_totals.GT)#</td>
                        <td style="text-align:right;" class="formbold">#tlformat(get_totals.DT)#</td>
                        <td style="text-align:right;" class="formbold">#tlformat(get_totals.KT)#</td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                </tfoot>
            </cfoutput>
            </cfif>
        </cf_grid_list>
        <cfset url_str = "retail.list_order&form_varmi=1">
        <cfif len(attributes.company_id) and len(attributes.company)>
            <cfset url_str = url_str & "&company_id=#attributes.company_id#&company=#attributes.company#">
        <cfelseif len(attributes.consumer_id) and len(attributes.company)>
            <cfset url_str = url_str & "&consumer_id=#attributes.consumer_id#&company=#attributes.company#">
        </cfif>
        <cfif len(attributes.keyword)>
            <cfset url_str = url_str & "&keyword=#attributes.keyword#">
        </cfif>
        <cfif len(attributes.currency_id)>
            <cfset url_str = url_str & "&currency_id=#attributes.currency_id#">
        </cfif>
        <cfif len(attributes.department_id)>
            <cfset url_str = url_str & "&department_id=#attributes.department_id#">
        </cfif>
        <cfif isdefined('attributes.project_id') and len(attributes.project_id) and isdefined('attributes.project_head') and len(attributes.project_head)>
            <cfset url_str = url_str & "&project_id=#attributes.project_id#&project_head=#URLEncodedFormat(attributes.project_head)#">
        </cfif>
        <cfif len(attributes.order_status)>
            <cfset url_str = url_str & "&order_status=#attributes.order_status#">
        </cfif>
        <cfif len(attributes.start_date) and isdate(attributes.start_date)>
            <cfset url_str = url_str & "&start_date=#dateformat(attributes.start_date,'dd/mm/yyyy')#">
        </cfif>
        <cfif len(attributes.finish_date) and isdate(attributes.finish_date)>
            <cfset url_str = url_str & "&finish_date=#dateformat(attributes.finish_date,'dd/mm/yyyy')#">
        </cfif>
        <cfif isdate(attributes.deliver_start_date)>
            <cfset url_str = url_str & "&deliver_start_date=#dateformat(attributes.deliver_start_date,'dd/mm/yyyy')#">
        </cfif>
        <cfif isdate(attributes.deliver_finish_date)>
            <cfset url_str = url_str & "&deliver_finish_date=#dateformat(attributes.deliver_finish_date,'dd/mm/yyyy')#">
        </cfif>
        <cfif len(attributes.product_id) and len(attributes.product_name)>
            <cfset url_str = url_str & "&product_id=#attributes.product_id#&product_name=#attributes.product_name#">
        </cfif>
        <cfif len(attributes.employee_id) and len(attributes.employee)>
            <cfset url_str = url_str & "&employee_id=#attributes.employee_id#&employee=#attributes.employee#">
        </cfif>
        <cfif len(attributes.prod_cat)>
            <cfset url_str = url_str & "&prod_cat=#attributes.prod_cat#">
        </cfif>
        <cfif len(attributes.position_code) and len(attributes.position_name)>
            <cfset url_str = url_str & "&position_code=#attributes.position_code#&position_name=#attributes.position_name#">
        </cfif>
        <cfif isdefined("attributes.order_stage")>
            <cfset url_str = url_str & "&order_stage=#attributes.order_stage#">
        </cfif>
        <cfif len(attributes.order_no)>
            <cfset url_str = url_str & "&order_no=#attributes.order_no#">
        </cfif>
        <cfif len(attributes.zone_id)>
            <cfset url_str = url_str & "&order_no=#attributes.zone_id#">
        </cfif>
        <cfif len(attributes.order_type)>
            <cfset url_str = url_str & "&order_type=#attributes.order_type#">
        </cfif>
        <cfif isdefined("attributes.listing_type") and len(attributes.listing_type)>
            <cfset url_str = "#url_str#&listing_type=#attributes.listing_type#">
        </cfif>
        <cfif isdefined("attributes.irsaliye_fatura") and len(attributes.irsaliye_fatura)>
            <cfset url_str = "#url_str#&irsaliye_fatura=#attributes.irsaliye_fatura#">
        </cfif>
        <cfif isdefined("attributes.foreign_categories") and len(attributes.foreign_categories)>
            <cfset url_str = "#url_str#&foreign_categories=#attributes.foreign_categories#">
        </cfif>
        <cfset url_str = url_str & "&sort_type=#attributes.sort_type#">
    
        <cf_paging page="#attributes.page#" 
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="#url_str#">
    </cf_box>
</div>             

	

<script type="text/javascript">
function get_comp_rows(comp_id)
{
	durum_ = document.getElementById('comp_durum_' + comp_id).value;
	
	//rel_dept="dept_rows_#deliver_dept_id#_#dateformat(vade_tarihi,'ddmmyyy')#_#company_id#" rel_date="date_rows_#dateformat(vade_tarihi,'ddmmyyy')#_#company_id#"
	rel_ = "rel_comp='company_rows_" + comp_id + "'";
	col1 = $("tr[" + rel_ + "]");
	col1.toggle();
	
	if(durum_ == '0')
	{
		rel_ = "rel_comp1='company_rows_" + comp_id + "'";
		col1 = $("tr[" + rel_ + "]");
		col1.hide();
		
		rel_ = "rel_comp2='company_rows_" + comp_id + "'";
		col1 = $("tr[" + rel_ + "]");
		col1.hide();
		
		document.getElementById('comp_durum_' + comp_id).value = '1';
	}
	else
	{
		rel_ = "rel_comp1='company_rows_" + comp_id + "'";
		col1 = $("tr[" + rel_ + "]");
		col1.hide();
		
		rel_ = "rel_comp2='company_rows_" + comp_id + "'";
		col1 = $("tr[" + rel_ + "]");
		col1.hide();
		document.getElementById('comp_durum_' + comp_id).value = '0';	
	}
}
function get_comp_vade_rows(comp_id,vade)
{
	durum_ = document.getElementById('comp_vade_durum_' + vade + '_' + comp_id).value;
	
	rel_ = "rel_date='date_rows_" + vade + "_" + comp_id + "'";
	col1 = $("tr[" + rel_ + "]");
	col1.toggle();

	if(durum_ == '0')
	{
		rel_ = "rel_date1='date_rows_" + vade + "_" + comp_id + "'";
		col1 = $("tr[" + rel_ + "]");
		col1.hide();
		document.getElementById('comp_vade_durum_' + vade + '_' + comp_id).value = '1';
	}
	else
	{
		document.getElementById('comp_vade_durum_' + vade + '_' + comp_id).value = '0';	
	}
}

function get_comp_dept_vade_rows(comp_id,vade,dept)
{
	rel_ = "rel_dept='dept_rows_" + dept + "_" + vade + "_" + comp_id + "'";
	col1 = $("tr[" + rel_ + "]");
	col1.toggle();	
}


function get_aciklama(row_id,comp_code,stage,date)
{
	show('aciklama_' + row_id);
	adres = '<cfoutput>#request.self#?fuseaction=retail.emptypopup_get_company_orders</cfoutput>';
	adres = adres + '&comp_code=' + comp_code;
	adres = adres + '&stage=' + stage;
	adres = adres + '&order_date=' + date;
	AjaxPageLoad(adres,'aciklama_' + row_id,1);
}
	document.getElementById('keyword').focus();
	function connectAjax(crtrow,prod_id,stock_id,unit_,order_amount)
	{
		var bb = '<cfoutput>#request.self#?fuseaction=objects.emptypopup_ajax_product_stock_info&sales=1&purchase=1</cfoutput>&pid='+prod_id+'&sid='+ stock_id+'&amount='+ order_amount;
		AjaxPageLoad(bb,'DISPLAY_ORDER_STOCK_INFO'+crtrow,1);
	}
	
	function input_control()
	{
		<cfif not session.ep.our_company_info.UNCONDITIONAL_LIST>
			if( 
				form.keyword.value.length == 0 && form.department_id.value.length == 0 && form.order_no.value.length == 0 &&
				(form.employee_id.value.length == 0 || form.employee.value.length == 0) &&
				(form.company_id.value.length == 0 || form.company.value.length == 0) &&
				(form.position_code.value.length == 0 || form.position_name.value.length == 0) &&
				(form.start_date.value.lenght == 0 || form.finish_date.value.lenght == 0)
			  )
			{
				alert("<cf_get_lang dictionary_id='58950.En az bir alanda filtre etmelisiniz'> !");
				return false;
			}
			else return true;
		<cfelse>	
			return true;
		</cfif>
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->