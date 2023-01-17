<!---5.8.19 satış bölgesi filtresi eklendi.ceren --->
<cf_xml_page_edit fuseact="stock.list_command">
<cf_get_lang_set module_name="stock">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfif x_currency_is_ship eq 1>
	<cfparam name="attributes.currency_id" default="-6">
<cfelse>
	<cfparam name="attributes.currency_id" default="">
</cfif>
<cfparam name="attributes.cat" default="">
<cfparam name="attributes.stock_branch_id" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.ref_no" default="">
<cfparam name="attributes.ord_stage" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.date1" default="">
<cfparam name="attributes.date2" default="">
<cfparam name="attributes.documentdate1" default="">
<cfparam name="attributes.documentdate2" default="">
<cfparam name="attributes.ship_method" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.location_id" default="">
<cfparam name="attributes.department_txt" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.spect_main_id" default="">
<cfparam name="attributes.spect_main_name" default="">
<cfparam name="attributes.order_stage" default="">
<cfparam name="attributes.sale_add_option" default="">
<cfparam name="attributes.product_code" default="">
<cfparam name="attributes.product_cat_id" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.city_id" default="">
<cfparam name="attributes.city" default="">
<cfparam name="attributes.county_id" default="">
<cfparam name="attributes.county" default="">
<cfparam name="attributes.product_brand_id" default="">
<cfparam name="attributes.product_brand_name" default="">
<cfparam name="attributes.product_model_id" default="">
<cfparam name="attributes.product_model_name" default="">
<cfparam name="attributes.subscription_id" default="">
<cfparam name="attributes.subscription_no" default="">
<cfparam name="attributes.our_comp_id" default="#session.ep.company_id#">
<cfparam name="attributes.record_emp_id" default="">
<cfparam name="attributes.record_emp_name" default="">
<cfparam name="attributes.deliver_emp_id" default="">
<cfparam name="attributes.deliver_emp_name" default="">
<cfparam name="attributes.zone_id" default="">
<cfparam name="attributes.SZ_ID" default="">
<cfif x_equipment_planning_info eq 1>
	<cfparam name="attributes.listing_type" default="3">
<cfelse>
	<cfparam name="attributes.listing_type" default="1">
</cfif>
<cfif isDate(attributes.date1)><cf_date tarih="attributes.date1"></cfif>
<cfif isDate(attributes.date2)><cf_date tarih="attributes.date2"></cfif>
<cfif isDate(attributes.documentdate1)><cf_date tarih="attributes.documentdate1"></cfif>
<cfif isDate(attributes.documentdate2)><cf_date tarih="attributes.documentdate2"></cfif>
<cfif not (isDate(attributes.date1) or isDate(attributes.date2) or isDate(attributes.documentdate1) or isDate(attributes.documentdate2))>
	<cfquery name="GET_PERIOD_DATE" datasource="#DSN#">
		SELECT PERIOD_YEAR FROM SETUP_PERIOD WHERE PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year-1#"> ORDER BY PERIOD_YEAR
	</cfquery>
	<cfif Len(get_period_date.period_year)>
		<cfset period_startdate_ = '#get_period_date.period_year#-01-01'>
	<cfelse>
		<cfset period_startdate_ = '#session.ep.period_year#-01-01'>
	</cfif>
	<cfset period_finishdate_ = '#session.ep.period_year#-12-31'>
	<!--- Tarih Araliginin 7 Gunden Fazla Olmamasi icin sadece asagidaki functionda uyari veriliyor, uygun degerleri kullanici belirler --->
	
	<cfif x_is_startdate_diff_period_documentdate eq 1 and x_is_finishdate_diff_period_documentdate eq 1>
		<!--- Donem Basi, Donem Sonu; Donem Basi ve Donem Sonu --->
		<cfif not isDate(attributes.documentdate1)><cfset attributes.documentdate1 = period_startdate_></cfif>
		<cfif not isDate(attributes.documentdate2)><cfset attributes.documentdate2 = period_finishdate_></cfif>
	<cfelseif x_is_startdate_diff_period_documentdate eq 1 and x_is_finishdate_diff_period_documentdate eq 0>
		<!--- Donem Basi, Donem Sonu Degil; Donem Basi ve Bir Hafta Sonrasi --->
		<cfif not isDate(attributes.documentdate1)><cfset attributes.date1 = period_startdate_>
		<cfif not isDate(attributes.documentdate2)><cfset attributes.documentdate1 = date_add('ww',1,period_startdate_)></cfif>
	<cfelseif x_is_startdate_diff_period_documentdate eq 0 and x_is_finishdate_diff_period_documentdate eq 1></cfif>
		<!--- Donem Basi Degil, Donem Sonu; Donem Sonu ve Bir Hafta Oncesi --->
		<cfif not isDate(attributes.documentdate1)><cfset attributes.documentdate1 = date_add('ww',-1,period_finishdate_)></cfif>
		<cfif not isDate(attributes.documentdate2)><cfset attributes.documentdate2 = period_finishdate_></cfif>
	<cfelseif x_is_date_diff_documentdate eq 1>
		<!--- Donem Basi Degil, Donem Sonu Degil; Bugun ve Bir Hafta Oncesi --->
		<cfif not isDate(attributes.documentdate1)><cfset attributes.documentdate1 = date_add("ww",-1,wrk_get_today())></cfif>
		<cfif not isDate(attributes.documentdate2)><cfset attributes.documentdate2 = wrk_get_today()></cfif>
	</cfif>
	<cfif x_is_startdate_diff_period eq 1 and x_is_finishdate_diff_period eq 1>
		<!--- Donem Basi, Donem Sonu; Donem Basi ve Donem Sonu --->
		<cfif not isDate(attributes.date1)><cfset attributes.date1 = period_startdate_></cfif>
		<cfif not isDate(attributes.date2)><cfset attributes.date2 = period_finishdate_></cfif>
	<cfelseif x_is_startdate_diff_period eq 1 and x_is_finishdate_diff_period eq 0>
		<!--- Donem Basi, Donem Sonu Degil; Donem Basi ve Bir Hafta Sonrasi --->
		<cfif not isDate(attributes.date1)><cfset attributes.date1 = period_startdate_>
		<cfif not isDate(attributes.date2)><cfset attributes.date2 = date_add('ww',1,period_startdate_)></cfif>
	<cfelseif x_is_startdate_diff_period eq 0 and x_is_finishdate_diff_period eq 1></cfif>
		<!--- Donem Basi Degil, Donem Sonu; Donem Sonu ve Bir Hafta Oncesi --->
		<cfif not isDate(attributes.date1)><cfset attributes.date1 = date_add('ww',-1,period_finishdate_)></cfif>
		<cfif not isDate(attributes.date2)><cfset attributes.date2 = period_finishdate_></cfif>
	<cfelseif x_is_date_diff eq 1>
		<!--- Donem Basi Degil, Donem Sonu Degil; Bugun ve Bir Hafta Oncesi --->
		<cfif not isDate(attributes.date1)><cfset attributes.date1 = date_add("ww",-1,wrk_get_today())></cfif>
		<cfif not isDate(attributes.date2)><cfset attributes.date2 = wrk_get_today()></cfif>
	</cfif>
</cfif>
<cfif x_equipment_planning_info eq 1 and attributes.listing_type eq 3>
	<cfparam name="attributes.planning_status" default="">
	<!--- Planlama bazinda ekip tarih bilgileri belirleniyor --->
	<cfparam name="attributes.planning_date" default="#dateFormat(now(),dateformat_style)#">
	<cf_date tarih="attributes.planning_date">
	<cfquery name="GET_PLANNING_INFO" datasource="#DSN3#">
		SELECT
			PLANNING_ID,
			PLANNING_DATE,
			TEAM_CODE,
			RELATION_COMP_ID,
			RELATION_CONS_ID
		FROM
			DISPATCH_TEAM_PLANNING
		WHERE
			PLANNING_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.planning_date#">
	</cfquery>
	<!--- Basketteki Miktar Yuvarlamalari Getiriliyor 4SatisSip,6SatinalmaSip,10SatisIrs,11AlimIrs,31SevkIrs, --->
	<cfquery name="GET_BASKET_AMOUNT_ROUND" datasource="#DSN3#">
		SELECT BASKET_ID, ISNULL(AMOUNT_ROUND,0) AMOUNT_ROUND FROM SETUP_BASKET WHERE B_TYPE = 1 AND  BASKET_ID IN (4,6) ORDER BY BASKET_ID
	</cfquery>
	<cfloop query="get_basket_amount_round">
		<cfset "basket_amount_round_#basket_id#" = amount_round>
	</cfloop>
</cfif>
<cfquery name="GET_BRANCHES" datasource="#DSN#">
	SELECT BRANCH_ID, BRANCH_NAME FROM BRANCH WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND BRANCH_STATUS = 1 ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="GET_SHIP_METHOD" datasource="#DSN#">
	SELECT SHIP_METHOD_ID,#dsn#.Get_Dynamic_Language(SHIP_METHOD_ID,'#session.ep.language#','SHIP_METHOD','SHIP_METHOD',NULL,NULL,SHIP_METHOD) AS SHIP_METHOD FROM SHIP_METHOD ORDER BY SHIP_METHOD
</cfquery>
<cfquery name="GET_OUR_COMPANY" datasource="#DSN#">
	SELECT
		SP.OUR_COMPANY_ID OUR_COMP_ID,
		O.NICK_NAME OUR_COMP_NAME
	FROM
		EMPLOYEE_POSITIONS EP,
		SETUP_PERIOD SP,
		EMPLOYEE_POSITION_PERIODS EPP,
		OUR_COMPANY O
	WHERE 
		SP.OUR_COMPANY_ID = O.COMP_ID AND
		SP.PERIOD_ID = EPP.PERIOD_ID AND
		EP.POSITION_ID = EPP.POSITION_ID AND
		EP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
	GROUP BY
		SP.OUR_COMPANY_ID,
		O.NICK_NAME
	ORDER BY
		O.NICK_NAME
</cfquery>
<cfquery name="GET_PROCESS" datasource="#DSN#"><!--- siparis, depo sevk asamalari --->
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID,
		PT.PROCESS_NAME,
		PT.PROCESS_ID
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		(	
			<cfif x_equipment_planning_info neq 1>
				PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%stock.upd_dispatch_internaldemand%"> OR
			</cfif>
			PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%sales.detail_order_sa%"> OR
			PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%purchase.detail_order%"> OR
			PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%sales.add_fast_sale%">
		)
	ORDER BY
		PT.PROCESS_NAME,
		PTR.LINE_NUMBER
</cfquery>

<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfif isdefined("attributes.is_submitted")>
	<cfinclude template="../query/get_order_list.cfm">
<cfelse>
	<cfset get_order_list.recordcount=0>
</cfif>

<cfif get_order_list.recordcount>
	<cfparam name="attributes.totalrecords" default='#get_order_list.query_count#'>
<cfelse>
	<cfparam name="attributes.totalrecords" default='0'>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="list_order" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_command">
            <input type="hidden" name="is_submitted" id="is_submitted" value="1">
            <cf_box_search>
                    <div class="form-group" id="form_ul_keyword">
                        <cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang(48,'Filtre',57460)#">
                    </div>
                    <div class="form-group" id="form_ul_ref_no">
                        <cfinput type="text" name="ref_no" id="ref_no" value="#attributes.ref_no#" maxlength="50" placeholder="#getLang(1382,'Referans No',58794)#">
                    </div>
                    <div class="form-group" id="BRANCH_PLACE">
                        <select name="stock_branch_id" id="stock_branch_id">
                            <option value=""><cf_get_lang dictionary_id='57453.Şube'></option>
                            <cfoutput query="GET_BRANCHES"><option value="#GET_BRANCHES.branch_id#"<cfif attributes.stock_branch_id eq GET_BRANCHES.branch_id>selected</cfif>>#branch_name#</option></cfoutput>
                        </select>
                    </div>
                    <div class="form-group" id="form_ul_ship_method">
                        <select name="ship_method" id="ship_method">
                            <option value=""><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></option>
                            <cfoutput query="get_ship_method">
                                <option value="#get_ship_method.ship_method_id#" <cfif attributes.ship_method eq get_ship_method.ship_method_id>selected</cfif>>#get_ship_method.ship_method#</option>
                            </cfoutput>
                        </select>
                    </div>
                    <div class="form-group" id="form_ul_currency_id">
                        <select name="currency_id" id="currency_id">
                            <option value=""><cf_get_lang dictionary_id='57482.Aşama'></option><!--- default : -3,-6,-8,-7 --->
                            <option value="-7" <cfif attributes.currency_id eq -7>selected</cfif>><cf_get_lang dictionary_id='29748.Eksik Teslimat'></option>
                            <cfif x_show_surplus_delivery eq 1><option value="-8" <cfif attributes.currency_id eq -8>selected</cfif>><cf_get_lang dictionary_id='29749.Fazla Teslimat'></option></cfif>
                            <option value="-6" <cfif attributes.currency_id eq -6>selected</cfif>><cf_get_lang dictionary_id='58761.Sevk'></option>
                            <cfif x_show_production_currency eq 1><option value="-5" <cfif attributes.currency_id eq -5>selected</cfif>><cf_get_lang dictionary_id='57456.Üretim'></option></cfif>
                            <cfif Len(attributes.listing_type) and attributes.listing_type neq 3>
                                <option value="-3" <cfif attributes.currency_id eq -3>selected</cfif>><cf_get_lang dictionary_id='29746.Kapatıldı'></option>
                            </cfif>
                        </select>
                    </div>
                    <div class="form-group" id="form_ul_ord_stage">
                        <select name="ord_stage" id="ord_stage">
                            <option value=""><cf_get_lang dictionary_id='58859.Süreç'></option>
                            <cfoutput query="get_process" group="process_id">
                                <optgroup label="#process_name#"></optgroup>
                                <cfoutput>
                                <option value="#get_process.process_row_id#" <cfif Len(attributes.ord_stage) and attributes.ord_stage eq get_process.process_row_id>selected</cfif>>#get_process.stage#</option>
                                </cfoutput>
                            </cfoutput>
                        </select>
                    </div>
                    <div class="form-group" id="form_ul_listing_type">
                        <select name="listing_type" id="listing_type" onchange="contrl_funcs(this.value)">
                            <option value="1" <cfif attributes.listing_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57660.Belge Bazında'></option>
                            <option value="2" <cfif attributes.listing_type eq 2>selected</cfif>><cf_get_lang dictionary_id='29539.Satır Bazında'></option>
                            <cfif x_equipment_planning_info eq 1>
                                <option value="3" <cfif attributes.listing_type eq 3>selected</cfif>><cf_get_lang dictionary_id='45211.Sevkiyat Bazında'></option>
                            </cfif>
                        </select>
                    </div>
                    <div class="form-group small">
                        <cfsavecontent variable="message"></cfsavecontent>
                        <cfif x_equipment_planning_info eq 1 and attributes.listing_type eq 3>
                            <cfset maxrows_ = 999>
                        <cfelse>
                            <cfset maxrows_ = 250>
                        </cfif>
                        <cfinput type="text" name="maxrows" maxlength="3" onKeyUp="isNumber(this)" id="maxrows" value="#attributes.maxrows#" validate="integer" range="1,#maxrows_#" required="yes" message="#message#">
                    </div>
                    <div class="form-group">
                        <cf_wrk_search_button search_function='input_control()' button_type="4">
                    </div>
            </cf_box_search>
            <cf_box_search_detail>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <cfif session.ep.our_company_info.subscription_contract eq 1>
                        <cfquery name="GET_SALE_ADD_OPTION" datasource="#DSN3#">
                            SELECT SALES_ADD_OPTION_ID, SALES_ADD_OPTION_NAME FROM SETUP_SALES_ADD_OPTIONS
                        </cfquery>
                        <div class="form-group" id="form_ul_sale_add_option">
                            <label class="col col-12"><cf_get_lang dictionary_id ='45590.Satış Özel Tanım'></label>
                            <div class="col col-12">
                                <select name="sale_add_option" id="sale_add_option">
                                    <option value=""><cf_get_lang dictionary_id ='45590.Satış Özel Tanım'></option>
                                    <cfoutput query="get_sale_add_option">
                                        <option value="#sales_add_option_id#" <cfif attributes.sale_add_option eq sales_add_option_id>selected</cfif>>#sales_add_option_name#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                    </cfif>
                        <div class="form-group" id="form_sales_zone_id">
                            <label class="col col-12"><cf_get_lang dictionary_id='57659.Satış Bölgesi'></label>
                            <div class="col col-12">
                                <cf_wrk_saleszone 
                                    name="SZ_ID"
                                    option_text="#getLang('','Satış Bölgesi',57659)#"
                                    value="#attributes.SZ_ID#">  
                            </div>
                        </div>
                        <div class="form-group" id="form_ul_zone_id">
                            <label class="col col-12"><cf_get_lang dictionary_id='57992.Bölge'></label>
                            <div class="col col-12">
                                <cf_wrk_zones fieldid='zone_id' selected_value='#attributes.zone_id#' width='120'>
                            </div>
                        </div>
                    <div class="form-group" id="form_ul_city">
                        <label class="col col-12"><cf_get_lang dictionary_id='58608.İl'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="city_id" id="city_id" value="<cfif len(attributes.city)><cfoutput>#attributes.city_id#</cfoutput></cfif>">
                                <input type="text" name="city" id="city" value="<cfoutput><cfif len(attributes.city)>#attributes.city#</cfif></cfoutput>" onfocus="AutoComplete_Create('city','CITY_NAME','CITY_NAME','get_city','0','CITY_ID,CITY_NAME','city_id,city','','3','120');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_dsp_city&field_id=list_order.city_id&field_name=list_order.city'</cfoutput>,'','ui-draggable-box-small');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="form_ul_county">
                        <label class="col col-12"><cf_get_lang dictionary_id='58638.İlçe'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="county_id" id="county_id" value="<cfif len(attributes.county)><cfoutput>#attributes.county_id#</cfoutput></cfif>">
                                <input type="text" name="county" id="county" value="<cfoutput><cfif len(attributes.county)>#attributes.county#</cfif></cfoutput>" onfocus="AutoComplete_Create('county','COUNTY_NAME','CITY_NAME,COUNTY_NAME','get_county','0','COUNTY_ID,COUNTY_NAME','county_id,county','','3','150');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_dsp_county&field_id=list_order.county_id&field_name=list_order.county&city_id=' + document.list_order.city_id.value</cfoutput>,'','ui-draggable-box-small');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="form_ul_record_emp_name">
                        <label class="col col-12"><cf_get_lang dictionary_id='57899.Kaydeden'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfoutput>
                                    <input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfif Len(attributes.record_emp_id) and Len(attributes.record_emp_name)>#attributes.record_emp_id#</cfif>">
                                    <input type="text" name="record_emp_name" id="record_emp_name" value="<cfif Len(attributes.record_emp_id) and Len(attributes.record_emp_name)>#attributes.record_emp_name#</cfif>" onfocus="AutoComplete_Create('record_emp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','record_emp_id','','3','200');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=list_order.record_emp_id&field_name=list_order.record_emp_name&select_list=1&branch_related')"></span>
                                </cfoutput>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <cfif session.ep.our_company_info.subscription_contract eq 1>
                        <div class="form-group" id="form_ul_subscription_no">
                            <label class="col col-12"><cf_get_lang dictionary_id='58832.Abone'></label>
                            <div class="col col-12">
                                <cf_wrk_subscriptions subscription_id='#attributes.subscription_id#' subscription_no='#attributes.subscription_no#' width_info='120' fieldid='subscription_id' fieldname='subscription_no' form_name='list_order' img_info='plus_thin'>
                            </div>
                        </div>
                    </cfif>
                    <div class="form-group" id="form_ul_project_head">
                        <label class="col col-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfoutput>
                                    <input type="hidden" name="project_id" id="project_id" value="<cfif len(attributes.project_head)>#attributes.project_id#</cfif>">
                                    <input type="text" name="project_head" id="project_head" value="<cfif len(attributes.project_head)>#attributes.project_head#</cfif>" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=list_order.project_id&project_head=list_order.project_head');"></span>
                                </cfoutput>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="form_ul_company">
                        <label class="col col-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfoutput>
                                    <input type="hidden" name="consumer_id" id="consumer_id" value="#attributes.consumer_id#">			
                                    <input type="hidden" name="company_id" id="company_id" value="#attributes.company_id#">
                                    <input type="text" name="company" id="company" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',0,0,0','CONSUMER_ID,COMPANY_ID','consumer_id,company_id','','3','150');" value="#URLDecode(attributes.company)#" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_pars&field_consumer=list_order.consumer_id&field_member_name=list_order.company&field_comp_id=list_order.company_id&select_list=2,3&keyword='+encodeURIComponent(document.list_order.company.value));"></span>
                                    </cfoutput>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="form_ul_department_txt">
                        <label class="col col-12"><cf_get_lang dictionary_id='58763.Depo'></label>
                        <div class="col col-12">
                            <cf_wrkdepartmentlocation 
                            returninputvalue="department_txt,department_id,location_id"
                            returnqueryvalue="LOCATION_NAME,DEPARTMENT_ID,LOCATION_ID"
                            fieldname="department_txt"
                            fieldid="location_id"
                            department_fldid="department_id"
                            department_id="#attributes.department_id#"
                            location_name="#attributes.department_txt#"
                            location_id="#attributes.location_id#"
                            user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                            width="120">
                        </div>
                    </div>
                    <div class="form-group" id="form_ul_product_cat">
                        <label class="col col-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfoutput>
                                    <input type="hidden" name="product_code" id="product_code" value="<cfif len(attributes.product_cat) and len(attributes.product_code)>#attributes.product_code#</cfif>">
                                    <input type="hidden" name="product_cat_id" id="product_cat_id" value="<cfif len(attributes.product_cat) and len(attributes.product_cat_id)>#attributes.product_cat_id#</cfif>">
                                    <input type="text" name="product_cat" id="product_cat" onfocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','0','PRODUCT_CATID,HIERARCHY','product_cat_id,product_code','','3','175','','1');" value="<cfif len(attributes.product_cat) and len(attributes.product_code)>#attributes.product_cat#</cfif>" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=list_order.product_cat_id&field_code=list_order.product_code&field_name=list_order.product_cat&keyword='+encodeURIComponent(document.list_order.product_cat.value));"></span>
                                </cfoutput>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="form_ul_deliver_emp_name">
                        <label class="col col-12"><cf_get_lang dictionary_id='57775.Teslim Alan'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfoutput>
                                    <input type="hidden" name="deliver_emp_id" id="deliver_emp_id" value="<cfif Len(attributes.deliver_emp_id) and Len(attributes.deliver_emp_id)>#attributes.deliver_emp_id#</cfif>">
                                    <input type="text" name="deliver_emp_name" id="deliver_emp_name" value="<cfif Len(attributes.deliver_emp_name) and Len(attributes.deliver_emp_name)>#attributes.deliver_emp_name#</cfif>" onfocus="AutoComplete_Create('deliver_emp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','deliver_emp_id','','3','200');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=list_order.deliver_emp_id&field_name=list_order.deliver_emp_name&select_list=1&branch_related')"></span>
                                </cfoutput>
                            </div>
                        </div>
                    </div>
                    <cfif x_equipment_planning_info eq 1 and attributes.listing_type eq 3><!--- Sevkiyat Bazinda Gelecek Filtreler --->
                        <div class="form-group" id="form_ul_product_name">
                            <label class="col col-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <cfoutput>
                                        <input type="hidden" name="stock_id" id="stock_id" value="#attributes.stock_id#">
                                        <input type="hidden" name="product_id" id="product_id" value="#attributes.product_id#">
                                        <input type="text" name="product_name" id="product_name" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','STOCK_ID,PRODUCT_ID','stock_id,product_id','','3','130');" value="#attributes.product_name#">
                                        <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_names&stock_and_spect=1&field_spect_main_id=list_order.spect_main_id&field_spect_main_name=list_order.spect_main_name&field_id=list_order.stock_id&product_id=list_order.product_id&field_name=list_order.product_name&keyword='+encodeURIComponent(document.list_order.product_name.value));"></span>
                                    </cfoutput>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="form_ul_spect_main_name">
                            <label class="col col-12"><cf_get_lang dictionary_id='57647.Spec'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <cfoutput>
                                        <input type="hidden" name="spect_main_id" id="spect_main_id" value="#attributes.spect_main_id#">
                                        <input type="text" name="spect_main_name" id="spect_main_name" value="#attributes.spect_main_name#">
                                        <span class="input-group-addon icon-ellipsis" onclick="product_control();"></span>
                                    </cfoutput>
                                </div>
                            </div>
                        </div> 
                        <div class="form-group" id="form_ul_product_brand_name">
                            <label class="col col-12"><cf_get_lang dictionary_id='58847.Marka'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                        <cfoutput>
                                            <input type="hidden" name="product_brand_id" id="product_brand_id" value="<cfif len(attributes.product_brand_name)>#attributes.product_brand_id#</cfif>">
                                            <input type="text" name="product_brand_name" id="product_brand_name" value="<cfif len(attributes.product_brand_name)>#attributes.product_brand_name#</cfif>" onfocus="AutoComplete_Create('product_brand_name','BRAND_NAME','BRAND_NAME','get_brand','0','BRAND_ID,BRAND_NAME','product_brand_id,product_brand_name','','3','130','','');" autocomplete="off">
                                            <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_brands&brand_id=list_order.product_brand_id&brand_name=list_order.product_brand_name&keyword='+encodeURIComponent(document.list_order.product_brand_name.value),'','ui-draggable-box-small');"></span>
                                        </cfoutput>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="form_ul_product_model_name">
                            <label class="col col-12"><cf_get_lang dictionary_id='58225.Model'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <cfoutput>
                                        <input type="hidden" name="product_model_id" id="product_model_id" value="<cfif len(attributes.product_model_name)>#attributes.product_model_id#</cfif>">
                                        <input type="text" name="product_model_name" id="product_model_name" value="<cfif len(attributes.product_model_name)>#attributes.product_model_name#</cfif>" onfocus="AutoComplete_Create('product_model_name','MODEL_NAME','MODEL_NAME','get_product_model','0','MODEL_ID,MODEL_NAME','product_model_id,product_model_name','','3','130','','1');" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_product_model&model_id=list_order.product_model_id&model_name=list_order.product_model_name&keyword='+encodeURIComponent(document.list_order.product_model_name.value));"></span>
                                    </cfoutput>
                                </div>
                            </div>
                        </div>
                    </cfif>    
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                    <div class="form-group" id="form_ul_documentdate1">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lütfen Tarih Giriniz'></cfsavecontent>
                        <cfsavecontent variable="message_documentdate"><cf_get_lang dictionary_id='57879.Teslim Tarihi'></cfsavecontent>
                        <label class="col col-12"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></label>
                        <div class="col col-6">
                            <div class="input-group">
                                <cfinput type="text" name="documentdate1" id="documentdate1" maxlength="10" value="#dateformat(attributes.documentdate1,dateformat_style)#" validate="#validate_style#" message="#message#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="documentdate1" title="#message_documentdate#"></span>
                            </div>
                        </div>
                        <div class="col col-6">
                            <div class="input-group">
                                <cfinput type="text" name="documentdate2" id="documentdate2" maxlength="10" value="#dateformat(attributes.documentdate2,dateformat_style)#" validate="#validate_style#" message="#message#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="documentdate2" title="#message_documentdate#"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="form_ul_date1">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lütfen Tarih Giriniz'></cfsavecontent>
                        <cfsavecontent variable="message_date"><cf_get_lang dictionary_id='57645.Teslim Tarih'></cfsavecontent>
                        <label class="col col-12"><cf_get_lang dictionary_id='57879.Teslim Tarihi'></label>
                        <div class="col col-6">
                            <div class="input-group">
                                <cfinput type="text" maxlength="10" name="date1" id="date1" value="#dateformat(attributes.date1,dateformat_style)#" validate="#validate_style#" message="#message#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="date1" title="#message_date#"></span>
                            </div>
                        </div>
                        <div class="col col-6">
                            <div class="input-group">
                                <cfinput type="text" name="date2" id="date2" maxlength="10" value="#dateformat(attributes.date2,dateformat_style)#" validate="#validate_style#" message="#message#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="date2" title="#message_date#"></span>
                            </div>
                        </div>
                    </div>
                    <cfif x_equipment_planning_info eq 1 and attributes.listing_type eq 3>
                        <div class="form-group" id="form_ul_planning_date">
                            <label class="col col-12"><cf_get_lang dictionary_id='58881.Plan Tarihi'></label>
                            <div class="col col-6">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='45759.Lütfen Ekip Tarihini Kontrol Ediniz!'> !</cfsavecontent>
                                    <cfinput type="text" maxlength="10" name="planning_date" id="planning_date" value="#dateformat(attributes.planning_date,dateformat_style)#" validate="#validate_style#" required="yes" message="#message#">
                                    <cfsavecontent variable="message_plandate"><cf_get_lang dictionary_id='58881.Plan Tarihi'></cfsavecontent>
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="planning_date" title="#message_plandate#"></span>
                                </div>
                            </div>
                            <div class="col col-6">
                                <select name="planning_status" id="planning_status">
                                    <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                                    <option value="1" <cfif attributes.planning_status eq 1>selected</cfif>><cf_get_lang dictionary_id='58869.Planlanan'></option>
                                    <option value="0" <cfif attributes.planning_status eq 0>selected</cfif>><cf_get_lang dictionary_id='45293.Planlanmayan'></option>
                                </select>
                            </div>
                        </div>
                    </cfif>  
                    <div class="form-group" id="form_ul_cat">
                        <label class="col col-12"><cf_get_lang dictionary_id='57800.İşlem Tipi'></label>
                        <div class="col col-12">
                                <cfsavecontent variable="cat_1"><cf_get_lang dictionary_id='45314.Verilen Siparişler'></cfsavecontent>
                                <cfsavecontent variable="cat_2"><cf_get_lang dictionary_id='45313.Alınan Siparişler'></cfsavecontent>
                                <cfsavecontent variable="cat_3"><cf_get_lang dictionary_id='45433.İşlenen Sevk Talepleri'></cfsavecontent>
                                <cfsavecontent variable="cat_4"><cf_get_lang dictionary_id='45447.İşlenmeyen Sevk Talepleri'></cfsavecontent>
                                <cfsavecontent variable="cat_5"><cf_get_lang dictionary_id='45522.Teslim Alınan İrsaliyeler'></cfsavecontent>
                                <cfsavecontent variable="cat_6"><cf_get_lang dictionary_id='45523.Teslim Alınmayan İrsaliyeler'></cfsavecontent>
                                <cfscript>
                                    CAT_QUERY = QueryNew("CAT_ID, CAT_NAME");
                                    if(x_equipment_planning_info eq 0 or attributes.listing_type neq 3)
                                        QueryAddRow(CAT_QUERY,6);
                                    else
                                        QueryAddRow(CAT_QUERY,2);
                                    QuerySetCell(CAT_QUERY,"CAT_ID",1,1);QuerySetCell(CAT_QUERY,"CAT_NAME","#cat_1#",1);
                                    QuerySetCell(CAT_QUERY,"CAT_ID",2,2);QuerySetCell(CAT_QUERY,"CAT_NAME","#cat_2#",2);
                                    if(x_equipment_planning_info eq 0 or attributes.listing_type neq 3)
                                    {
                                        QuerySetCell(CAT_QUERY,"CAT_ID",3,3);QuerySetCell(CAT_QUERY,"CAT_NAME","#cat_3#",3);
                                        QuerySetCell(CAT_QUERY,"CAT_ID",4,4);QuerySetCell(CAT_QUERY,"CAT_NAME","#cat_4#",4);
                                        QuerySetCell(CAT_QUERY,"CAT_ID",5,5);QuerySetCell(CAT_QUERY,"CAT_NAME","#cat_5#",5);
                                        QuerySetCell(CAT_QUERY,"CAT_ID",6,6);QuerySetCell(CAT_QUERY,"CAT_NAME","#cat_6#",6);
                                    }
                                </cfscript>		
                                <cf_multiselect_check 
                                        query_name="CAT_QUERY"  
                                        name="cat"
                                        width="185" 
                                        option_value="CAT_ID"
                                        option_name="CAT_NAME" value="#attributes.cat#">
                        </div>
                    </div> 
                    <div class="form-group" id="item-is_dispatch">
                        <label class="col col-12">
                            <input type="checkbox" name="is_dispatch" id="is_dispatch" value="1" <cfif isdefined("attributes.is_dispatch")> checked</cfif>><cf_get_lang dictionary_id='45727.Sevk Edilmemişler'>
                        </label>
                    </div>
                    <cfif x_equipment_planning_info eq 1 and attributes.listing_type eq 3><!--- Sevkiyat Bazinda Gelecek Filtreler --->
                        <div class="form-group" id="form_ul_records_problems">
                            <label class="col col-12">
                                <input type="checkbox" value="1" name="records_problems" id="records_problems" <cfif isdefined("attributes.records_problems")>checked</cfif>><cf_get_lang dictionary_id='45225.Sorunlu Kayıtlar'>
                            </label>
                        </div>
                    </cfif>
                </div>
            </cf_box_search_detail>
        </cfform>
     </cf_box>
    <cf_box  title="#getLang("","Sevk-Lojistik Emirleri",47211)#" uidrop="1" hide_table_column="1" resize="1" collapsable="1" woc_setting = "#{ checkbox_name : 'print_islem_id', print_type : 10 }#">
        <cf_grid_list>
            <cfset colspan_info = 23>
            <cfif x_is_row_amount eq 1><cfset colspan_info = colspan_info+1></cfif>
            <cfif x_is_row_unit eq 1><cfset colspan_info = colspan_info+1></cfif>
            <cfif x_is_row_detail eq 1><cfset colspan_info = colspan_info+1></cfif>
            <thead>
                <tr>
                    <!--- xml parametreleri var dikkat, silinmemelidir --->
                    <th width="30"><cf_get_lang dictionary_id="58577.Sıra"></th>
                    <th width="30"><cf_get_lang dictionary_id='57487.No'></th>
                    <cfif attributes.listing_type eq 3 and x_show_list_order_row_id eq 1><th><cf_get_lang dictionary_id='45180.Sipariş Satir İd'></th></cfif>
                    <cfif x_equipment_planning_info eq 1 and attributes.listing_type eq 3 and not ListFind(x_productiondate_hide_company,session.ep.company_id,',')><th><cf_get_lang dictionary_id='58868.İş Emri'></th></cfif>
                    <th><cf_get_lang dictionary_id='57800.İşlem tipi'></th>
                    <th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
                    <th><cf_get_lang dictionary_id='57480.Başlık'></th>
                    <th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
                    <th><cf_get_lang dictionary_id='57453.Şube'></th>
                    <th><cf_get_lang dictionary_id='57879.Islem Tarihi'></th>
                    <!-- sil --><cfif not ListFind(x_deliverdate_hide_company,session.ep.company_id,',')><th><cf_get_lang dictionary_id='57645.Teslim tarihi'></th></cfif><!-- sil -->
                    <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
                    <th><cf_get_lang dictionary_id='57485.Öncelik'></th>
                    <th><cf_get_lang dictionary_id="57482.Aşama"></th>
                    <th><cf_get_lang dictionary_id='45273.Giris Depo'></th>
                    <th><cf_get_lang dictionary_id='29428.Çıkış Depo'></th>
                    <cfif attributes.listing_type neq 1>
                        <cfif x_equipment_planning_info eq 1 and attributes.listing_type eq 3>
                            <th><cf_get_lang dictionary_id='57611.Sipariş'> <cf_get_lang dictionary_id='45756.Depo Mik.'></th>
                            <th><cf_get_lang dictionary_id='45786.Plan'></th>
                        </cfif>
                        <th><cf_get_lang dictionary_id='57657.Ürün'></th>
                        <th><cf_get_lang dictionary_id='57647.Spec'></th>
                    </cfif>
                    <cfif attributes.listing_type eq 2 and x_is_row_detail eq 1>
                        <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                    </cfif>
                    <cfif attributes.listing_type eq 2 and x_is_row_amount eq 1>
                        <th><cf_get_lang dictionary_id='57635.Miktar'></th>
                    </cfif>
                    <cfif attributes.listing_type eq 2 and x_is_row_unit eq 1>
                        <th><cf_get_lang dictionary_id='57636.birim'></th>
                    </cfif>
                    <th><cf_get_lang dictionary_id='58794.Ref No'></th>
                    <cfif ListFind('1,2',attributes.listing_type,',')>
                        <th width="20"><!--- Sevk Et/Sevk Al ---></th>
                        <th width="20"><!--- Fatura Kes ---></th>
                        <cfif session.ep.our_company_info.guaranty_followup eq 1><th width="2%"><!--- Garanti-Seri Nolar ---></th></cfif>
                        <th width="20"><!--- Paketle CheckBox ---></th>
                        <th width="20" class="header_icn_none text-center"><!--- Print Et ---><i class="fa fa-print" title="<cf_get_lang dictionary_id='57474.Yazdır'>" alt="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></th>
                        <th width="20"><!--- Print Count --->(P)</th>
                    <cfelseif x_equipment_planning_info eq 1 and attributes.listing_type eq 3>
                        <th><cf_get_lang dictionary_id='57611.Sipariş'></th>
                        <th><cf_get_lang dictionary_id='57773.İrsaliye'></th>
                        <th><cf_get_lang dictionary_id='45786.Plan'></th>
                        <!-- sil -->
                        <th><cf_get_lang dictionary_id='58444.Kalan'></th>
                        <th width="65" class="header_icn_none">
                            <select name="equipment_planning_all" id="equipment_planning_all"  onchange="equipment_all();">
                                <option value=""><cf_get_lang dictionary_id='58870.Ekip - Araç'></option>
                                <cfoutput query="get_planning_info">
                                    <cfif (x_equipment_planning_relation_member eq 1 and (len(attributes.company) and (ListFind(Relation_Comp_Id,attributes.company_id) or ListFind(Relation_Cons_Id,attributes.consumer_id)))) or x_equipment_planning_relation_member eq 0>
                                        <option value="#planning_id#">#team_code#</option>
                                    </cfif>
                                </cfoutput>
                            </select>
                        </th>
                        <!-- sil -->
                    </cfif>
                </tr>
            </thead>
                <cfif get_order_list.recordcount>
                    <cfset company_id_list=''>
                    <cfset consumer_id_list=''>
                    <cfset partner_id_list=''>
                    <cfset priority_list=''>
                    <cfset department_list=''>
                    <cfset location_list = ''>
                    <cfset action_id_list=''>
                    <cfset relation_ship_list=''>
                    <cfset Complete_List=''>
                    <cfset order_row_id_list=''>
                    <cfset record_emp_id_list=''>
                    <cfform name="add_ship" id="add_ship" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_packetship&event=add">
                        <tbody>
                            <input type="hidden" name="list_logistic" id="list_logistic" value="">
                            <input type="hidden" name="today_date" id="today_date" value="<cfoutput>#now()#</cfoutput>">
                            <input type="hidden" name="row_count_form" id="row_count_form" value="<cfoutput>#get_order_list.recordcount#</cfoutput>">
                            <cfoutput query="get_order_list" >
                                <cfif isdefined("islem_row_id") and len(islem_row_id) and not listfind(order_row_id_list,islem_row_id)>
                                    <cfset order_row_id_list=listappend(order_row_id_list,islem_row_id)>
                                </cfif>
                                <cfif len(company_id) and not listfind(company_id_list,company_id)>
                                    <cfset company_id_list=listappend(company_id_list,company_id)>
                                </cfif>
                                <cfif len(consumer_id) and not listfind(consumer_id_list,consumer_id)>
                                    <cfset consumer_id_list=listappend(consumer_id_list,consumer_id)>
                                </cfif>
                                <cfif len(partner_id) and not listfind(partner_id_list,partner_id)>
                                    <cfset partner_id_list=listappend(partner_id_list,partner_id)>
                                </cfif>
                                <cfif len(priority_id) and not listfind(priority_list,priority_id)>
                                    <cfset priority_list=listappend(priority_list,priority_id)>
                                </cfif>
                                <cfif len(record_emp) and not listfind(record_emp_id_list,record_emp)>
                                    <cfset record_emp_id_list=listappend(record_emp_id_list,record_emp)>
                                </cfif>
                                <cfif len(dept_in) and not listfind(department_list,dept_in)>
                                    <cfset department_list=listappend(department_list,dept_in)>
                                </cfif>
                                <cfif len(dept_out) and not listfind(department_list,dept_out)>
                                    <cfset department_list=listappend(department_list,dept_out)>
                                </cfif>
                                <cfif len("#dept_in#-#loc_in#") and not listfind(location_list,"#dept_in#-#loc_in#")>
                                    <cfset location_list=listappend(location_list,"#dept_in#-#loc_in#")>
                                </cfif>
                                <cfif len("#dept_out#-#loc_out#") and not listfind(location_list,"#dept_out#-#loc_out#")>
                                    <cfset location_list=listappend(location_list,"#dept_out#-#loc_out#")>
                                </cfif>
                                <cfif type_id eq 1 and len(islem_id) and not listfind(action_id_list,islem_id)><!--- sadece siparislerin order_id leri toplanıyor --->
                                    <cfset action_id_list=listappend(action_id_list,islem_id)>
                                </cfif>
                                <cfif x_equipment_planning_info eq 1 and attributes.listing_type eq 3>
                                    <cfif islem_id and not listfind(relation_ship_list,islem_id)>
                                        <cfset relation_ship_list = ListAppend(relation_ship_list,islem_id,',')>
                                    </cfif>
                                </cfif>
                            </cfoutput>
                            <cfif not len(attributes.cat) or listfind(attributes.cat,1) or listfind(attributes.cat,2)><!--- Sadece siparisler icin --->
                                <cfif listlen(action_id_list)>
                                    <cfquery name="GET_SHIPS" datasource="#DSN3#">
                                        SELECT
                                            OS.ORDER_ID,
                                            OS.SHIP_ID,
                                            S.SHIP_TYPE,
                                            S.SHIP_NUMBER
                                        FROM
                                            ORDERS_SHIP OS,
                                            #dsn2_alias#.SHIP S
                                        WHERE 
                                            S.SHIP_ID = OS.SHIP_ID AND
                                            OS.ORDER_ID IN (<cfqueryparam list="yes" value="#action_id_list#">)
                                    </cfquery>
                                </cfif>
                            </cfif>
                            <cfif len(priority_list)>
                                <cfset priority_list=listsort(priority_list,'numeric','asc',',')>
                                <cfquery name="GET_COMMETHOD" datasource="#DSN#">
                                    SELECT PRIORITY_ID,PRIORITY,COLOR FROM SETUP_PRIORITY WHERE PRIORITY_ID IN (<cfqueryparam list="yes" value="#priority_list#">) ORDER BY PRIORITY_ID
                                </cfquery>
                                <cfset priority_list = listsort(listdeleteduplicates(valuelist(get_commethod.priority_id,',')),'numeric','ASC',',')>
                            </cfif>
                            <cfif len(record_emp_id_list)>
                                <cfset record_emp_id_list=listsort(record_emp_id_list,'numeric','asc',',')>
                                <cfquery name="get_rec_emp" datasource="#DSN#">
                                    SELECT EMPLOYEE_ID,EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME EMPLOYEE FROM EMPLOYEES WHERE EMPLOYEE_ID IN (<cfqueryparam list="yes" value="#record_emp_id_list#">) ORDER BY EMPLOYEE_ID
                                </cfquery>
                                <cfset record_emp_id_list = listsort(listdeleteduplicates(valuelist(get_rec_emp.employee_id,',')),'numeric','ASC',',')>
                            </cfif>
                            <cfif len(department_list)>
                                <cfset department_list=listsort(department_list,'numeric','asc',',')>
                                <cfquery name="GET_DEPT_NAME" datasource="#DSN#">
                                    SELECT DEPARTMENT_HEAD,DEPARTMENT_ID,BRANCH_ID FROM DEPARTMENT WHERE DEPARTMENT_ID IN (<cfqueryparam list="yes" value="#department_list#">) AND IS_STORE <> 2 ORDER BY DEPARTMENT_ID
                                </cfquery>
                                <cfset main_department_list = listsort(listdeleteduplicates(valuelist(get_dept_name.department_id,',')),'numeric','ASC',',')>
                            </cfif>
                            <cfif ListLen(location_list,',')>
                                <cfset location_list=listsort(location_list,'text','asc',',')>
                                <cfquery name="get_location" datasource="#dsn#">
                                    SELECT
                                        SL.COMMENT,
                                        CAST(D.DEPARTMENT_ID AS NVARCHAR(10)) + CAST('-' AS NVARCHAR(1)) + CAST(SL.LOCATION_ID AS NVARCHAR(10)) DEPARTMENT_LOCATIONS_
                                    FROM
                                        DEPARTMENT D,
                                        STOCKS_LOCATION SL
                                    WHERE
                                        D.DEPARTMENT_ID = SL.DEPARTMENT_ID AND
                                        D.IS_STORE <> 2 AND
                                        CAST(D.DEPARTMENT_ID AS NVARCHAR(10)) + CAST('-' AS NVARCHAR(1)) + CAST(SL.LOCATION_ID AS NVARCHAR(10)) IN (#ListQualify(location_list,"'",",")#)
                                    ORDER BY
                                        CAST(D.DEPARTMENT_ID AS NVARCHAR(10)) + CAST('-' AS NVARCHAR(1)) + CAST(SL.LOCATION_ID AS NVARCHAR(10))
                                </cfquery>
                                <cfset location_list = ListSort(ListDeleteDuplicates(ValueList(get_location.department_locations_,',')),"text","asc",",")>
                            </cfif>
                            <cfif listlen(company_id_list)>
                                <cfset company_id_list=listsort(company_id_list,"numeric","asc",",")>
                                <cfquery name="GET_COMPANY_DETAIL" datasource="#DSN#">
                                    SELECT FULLNAME,COMPANY_ID FROM COMPANY WHERE COMPANY_ID IN (<cfqueryparam list="yes" value="#company_id_list#">) ORDER BY COMPANY_ID
                                </cfquery>
                                <cfset company_id_list = listsort(listdeleteduplicates(valuelist(get_company_detail.company_id,',')),'numeric','ASC',',')>
                            </cfif>
                            <cfif listlen(consumer_id_list)>
                                <cfset consumer_id_list=listsort(consumer_id_list,"numeric","asc",",")>
                                <cfquery name="GET_CONSUMER_DETAIL" datasource="#DSN#">
                                    SELECT CONSUMER_NAME,CONSUMER_SURNAME,CONSUMER_ID FROM CONSUMER WHERE CONSUMER_ID IN (<cfqueryparam list="yes" value="#consumer_id_list#">) ORDER BY CONSUMER_ID
                                </cfquery>
                                <cfset consumer_id_list = listsort(listdeleteduplicates(valuelist(get_consumer_detail.consumer_id,',')),'numeric','ASC',',')>
                            </cfif>
                            <cfif listlen(partner_id_list)>
                                <cfset partner_id_list=listsort(partner_id_list,"numeric","asc",",")>
                                <cfquery name="GET_PARTNER_DETAIL" datasource="#DSN#">
                                    SELECT
                                        CP.COMPANY_PARTNER_NAME,
                                        CP.COMPANY_PARTNER_SURNAME,
                                        C.NICKNAME,
                                        CP.PARTNER_ID
                                    FROM
                                        COMPANY_PARTNER CP,
                                        COMPANY C
                                    WHERE 
                                        CP.PARTNER_ID IN (<cfqueryparam list="yes" value="#partner_id_list#">) AND
                                        CP.COMPANY_ID = C.COMPANY_ID
                                    ORDER BY
                                        CP.PARTNER_ID
                                </cfquery>
                                <cfset partner_id_list = listsort(listdeleteduplicates(valuelist(get_partner_detail.partner_id,',')),'numeric','ASC',',')>
                            </cfif>
                            <cfif ListLen(relation_ship_list)>
                                <cfquery name="GET_SETUP_PERIOD" datasource="#DSN#">
                                    SELECT PERIOD_YEAR, OUR_COMPANY_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                                </cfquery>
                                <cfquery name="GET_RELATION_SHIP" datasource="#DSN3#">
                                    <cfloop query="get_setup_period">
                                        SELECT
                                            SHIP_ROW.WRK_ROW_RELATION_ID, 
                                            SHIP_ROW.AMOUNT
                                        FROM
                                            #dsn#_#get_setup_period.period_year#_#get_setup_period.our_company_id#.SHIP_ROW SHIP_ROW,
                                            ORDERS_SHIP OS,
                                            ORDER_ROW ORR
                                        WHERE
                                            OS.SHIP_ID = SHIP_ROW.SHIP_ID
                                            AND OS.ORDER_ID = ORR.ORDER_ID
                                            AND SHIP_ROW.WRK_ROW_RELATION_ID=ORR.WRK_ROW_ID
                                            AND OS.ORDER_ID IN (<cfqueryparam list="yes" value="#relation_ship_list#">)
                                        <cfif currentrow neq get_setup_period.recordcount>
                                        UNION ALL
                                        </cfif>
                                    </cfloop>
                                    ORDER BY WRK_ROW_RELATION_ID
                                </cfquery>
                                <cfif not GET_RELATION_SHIP.recordcount>
                                    <!--- Irsaliye yoksa direkt faturaya da cekilmis olabilir --->
                                    <cfquery name="GET_RELATION_SHIP" datasource="#DSN3#">
                                        <cfloop query="get_setup_period">
                                            SELECT
                                                INVOICE_ROW.WRK_ROW_RELATION_ID, 
                                                INVOICE_ROW.AMOUNT
                                            FROM
                                                #dsn#_#get_setup_period.period_year#_#get_setup_period.our_company_id#.INVOICE_ROW INVOICE_ROW,
                                                ORDERS_INVOICE OS,
                                                ORDER_ROW ORR
                                            WHERE
                                                OS.INVOICE_ID = INVOICE_ROW.INVOICE_ID
                                                AND OS.ORDER_ID = ORR.ORDER_ID
                                                AND INVOICE_ROW.WRK_ROW_RELATION_ID=ORR.WRK_ROW_ID
                                                AND OS.ORDER_ID IN (<cfqueryparam list="yes" value="#relation_ship_list#">)
                                            <cfif currentrow neq get_setup_period.recordcount>
                                            UNION ALL
                                            </cfif>
                                        </cfloop>
                                        ORDER BY WRK_ROW_RELATION_ID
                                    </cfquery>
                                </cfif>
                            </cfif>
                            <cfif x_equipment_planning_info eq 1 and attributes.listing_type eq 3>
                                <cfquery name="GET_MULTISHIP_PLANNING_INFO" datasource="#DSN2#"><!--- Planlama Miktarlari --->
                                    SELECT
                                        SR.OUT_DATE,
                                        SR.SHIP_RESULT_ID,
                                        SR.EQUIPMENT_PLANNING_ID,
                                        SRR.SHIP_RESULT_ROW_ID,
                                        SRR.ORDER_ROW_AMOUNT,
                                        SRR.ORDER_ROW_ID,
                                        SRR.WRK_ROW_ID
                                    FROM
                                        SHIP_RESULT SR,
                                        SHIP_RESULT_ROW SRR
                                    WHERE
                                        SR.SHIP_RESULT_ID = SRR.SHIP_RESULT_ID
                                        AND SRR.ORDER_ROW_ID IN (<cfqueryparam list="yes" value="#order_row_id_list#">)
                                    ORDER BY
                                        SR.SHIP_RESULT_ID DESC
                                </cfquery>
                                <cfquery name="GET_DEPT_AMOUNT_SPEC_PROD" datasource="#DSN3#"><!--- Spec- Depo Üretim Emri Miktari --->
                                    SELECT 
                                        ISNULL(SUM(PORR.AMOUNT),0) AS QUANTITY,
                                        POR.ORDER_ROW_ID
                                    FROM 
                                        PRODUCTION_ORDERS PO,
                                        PRODUCTION_ORDERS_ROW POR,
                                        PRODUCTION_ORDER_RESULTS PORS,
                                        PRODUCTION_ORDER_RESULTS_ROW PORR
                                    WHERE
                                        PO.P_ORDER_ID = POR.PRODUCTION_ORDER_ID
                                        AND PO.P_ORDER_ID = PORS.P_ORDER_ID
                                        AND PORS.PR_ORDER_ID = PORR.PR_ORDER_ID
                                        AND PORR.STOCK_ID = PO.STOCK_ID
                                        AND POR.ORDER_ROW_ID IN (<cfqueryparam list="yes" value="#order_row_id_list#">)
                                        AND PORS.PR_ORDER_ID IN(SELECT SF.PROD_ORDER_RESULT_NUMBER FROM #dsn2_alias#.STOCK_FIS SF WHERE SF.PROD_ORDER_RESULT_NUMBER IS NOT NULL AND SF.PROD_ORDER_RESULT_NUMBER = PORS.PR_ORDER_ID)
                                    GROUP BY 
                                        POR.ORDER_ROW_ID
                                </cfquery>
                                <cfquery name="GET_PRODUCTION_DATE_INFO_ALL" datasource="#DSN3#">
                                    SELECT
                                        PO.FINISH_DATE,
                                        POR.ORDER_ROW_ID,
                                        PO.STOCK_ID
                                    FROM
                                        PRODUCTION_ORDERS PO,
                                        PRODUCTION_ORDERS_ROW POR						
                                    WHERE
                                        PO.P_ORDER_ID = POR.PRODUCTION_ORDER_ID AND
                                        POR.ORDER_ROW_ID IN (<cfqueryparam list="yes" value="#order_row_id_list#">) AND
                                        IS_STAGE <> -1
                                    ORDER BY
                                        STOCK_ID,
                                        FINISH_DATE DESC
                                </cfquery>
                                <cfquery name="GET_COMPLETE" datasource="#DSN2#"><!--- Problemli Sevkiyat Kayitlari --->
                                    SELECT WRK_ROW_RELATION_ID FROM SHIP_RESULT_ROW_COMPLETE WHERE PROBLEM_RESULT_ID = 1
                                </cfquery>
                                <cfset Complete_List = ValueList(Get_Complete.Wrk_Row_Relation_Id,',')>
                            </cfif>
                            <!--- Plan Bilgisi; Ekip Tarihinde Planlanmis Urunlerin Toplamlari --->
                            <cfif x_equipment_planning_info eq 1 and attributes.listing_type eq 3>
                                <cfquery name="GET_PLANNING_RELATION_ROW" datasource="#DSN3#">
                                    SELECT
                                        SUM(ISNULL(SRR.ORDER_ROW_AMOUNT,0)) RESULT_AMOUNT,
                                        ORR.STOCK_ID,
                                        (SELECT SPECT_MAIN_ID FROM SPECTS S WHERE S.SPECT_VAR_ID = ORR.SPECT_VAR_ID) SPECT_MAIN_ID
                                    FROM
                                        ORDER_ROW ORR,
                                        #dsn2_alias#.SHIP_RESULT_ROW SRR
                                    WHERE
                                        ORR.WRK_ROW_ID = SRR.WRK_ROW_RELATION_ID AND
                                        SRR.SHIP_RESULT_ID IN (SELECT SHIP_RESULT_ID FROM #dsn2_alias#.SHIP_RESULT WHERE OUT_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.planning_date#">)
                                    GROUP BY
                                        ORR.STOCK_ID,
                                        ORR.SPECT_VAR_ID
                                </cfquery>
                            </cfif>
                            <!--- //Plan Bilgisi --->
                            <cfoutput query="get_order_list">
                                    <cfset ship_amount_ = 0>
                                    <cfset planning_amount_ = 0>
                                    <cfset diff_amount_ = 0>
                                    <cfset equipment_id_ = "">
                                    <!---  alis mi satis mi, satis demek workcube sisteminin sahibi sirketin birilerine satis yapmasi demektir --->
                                    <cfif attributes.listing_type neq 3>
                                        <cfquery name="GET_PRINT" datasource="#DSN3#">
                                            SELECT PRINT_COUNT FROM ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#islem_id#">
                                        </cfquery>
                                    </cfif>
                                    <cfif type_id eq 1 or type_id eq 5>
                                        <cfif (purchase_sales eq 1 and order_zone eq 0) or (purchase_sales eq 0 and order_zone eq 1)>
                                            <cfset is_sale_order = 1><!--- satis --->
                                            <cfset link_str="#request.self#?fuseaction=stock.list_command&event=det&order_id=#islem_id#">
                                        <cfelse>
                                            <cfset is_sale_order = 0><!--- alis --->
                                            <cfset link_str="#request.self#?fuseaction=#fusebox.circuit#.list_command&event=detp&order_id=#islem_id#">
                                        </cfif>
                                    <cfelseif type_id eq 2>
                                        <cfset link_str="#request.self#?fuseaction=#fusebox.circuit#.add_dispatch_internaldemand&event=upd&ship_id=#islem_id#">
                                    <cfelseif type_id eq 3>
                                        <cfset link_str="#request.self#?fuseaction=#fusebox.circuit#.add_ship_dispatch&event=upd&ship_id=#islem_id#">
                                    </cfif>
                                    <cfif isdefined("islem_row_id")><input type="hidden" name="islem_row_id_#currentrow#" id="islem_row_id_#currentrow#" value="#islem_row_id#"></cfif>
                                    <input type="hidden" name="row_company_id_#currentrow#" id="row_company_id_#currentrow#" value="#company_id#">
                                    <input type="hidden" name="row_consumer_id_#currentrow#" id="row_consumer_id_#currentrow#" value="#consumer_id#">
                                    <tr <cfif attributes.listing_type neq 3 and get_print.print_count gt 0 and type_id eq 1>style="color:red;"</cfif>>
                                        <td>#rownum#</td>
                                        <td><a href="#link_str#" class="tableyazi">#islem_no#</a></td>
                                        <cfif attributes.listing_type eq 3 and x_show_list_order_row_id eq 1><td>#islem_row_id#</td></cfif>
                                        <cfif x_equipment_planning_info eq 1 and attributes.listing_type eq 3>
                                            <!--- Satirdaki Siparis ve urunun iliskili oldugu uretim emirlerinden ilkinin tarihini getiriyor --->
                                            <cfquery name="GET_PRODUCTION_DATE_INFO" dbtype="query">
                                                SELECT MAX(FINISH_DATE) FINISH_DATE FROM GET_PRODUCTION_DATE_INFO_ALL WHERE ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_list.islem_row_id#"> AND STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_list.stok_id#">
                                            </cfquery>
                                            <cfif not ListFind(x_productiondate_hide_company,session.ep.company_id,',')>
                                                <td nowrap><cfif get_production_date_info.recordcount>#DateFormat(get_production_date_info.finish_date,dateformat_style)#</cfif></td>
                                            </cfif>
                                        </cfif>
                                        <td><cfif type_id eq 1>
                                                <cfif is_sale_order eq 1><cf_get_lang dictionary_id='57448.Satış'><cfelse><cf_get_lang dictionary_id='49752.Satınalma'></cfif><cfif attributes.listing_type neq 3> <cf_get_lang dictionary_id='57611.Sipariş'></cfif>
                                            <cfelseif type_id eq 2>
                                                <cf_get_lang dictionary_id='45525.Sevk Talebi'>
                                            <cfelse>
                                                <cf_get_lang dictionary_id='29587.Sevk Irsaliyesi'>
                                            </cfif>
                                        </td>
                                        <td><cfif len(record_emp)>#get_rec_emp.employee[listfind(record_emp_id_list,record_emp,',')]#</cfif></td>
                                    <td align="left"><cfif Len(order_head)>#left(order_head,25)#...</cfif></td>
                                        <td><cfif len(partner_id)>
                                                #get_partner_detail.nickname[listfind(partner_id_list,partner_id,',')]# <cfif attributes.listing_type neq 3>- #get_partner_detail.company_partner_name[listfind(partner_id_list,partner_id,',')]# #get_partner_detail.company_partner_surname[listfind(partner_id_list,partner_id,',')]#</cfif>
                                            <cfelseif len(company_id)>
                                                #get_company_detail.fullname[listfind(company_id_list,company_id,',')]#
                                            <cfelseif len(consumer_id)>
                                                #get_consumer_detail.consumer_name[listfind(consumer_id_list,consumer_id,',')]# #get_consumer_detail.consumer_surname[listfind(consumer_id_list,consumer_id,',')]#
                                            </cfif>
                                        </td>
                                        <td>#BRANCH_NAME#</td>
                                        <td>#dateformat(islem_tarihi,dateformat_style)#</td>
                                        <!-- sil -->
                                        <cfif not ListFind(x_deliverdate_hide_company,session.ep.company_id,',')>
                                        <td nowrap>
                                            <cfif x_equipment_planning_info eq 1 and attributes.listing_type eq 3>
                                            <!--- Tarih taginden degistirilen tarih aninda siparis satirindaki teslim tarihi alanina yansir-update edilir --->
                                                <div id="update_row_deliver_date_#islem_row_id#" style="display:none;"></div> 
                                                <input type="text" name="row_deliver_date_#islem_row_id#" id="row_deliver_date_#islem_row_id#"  readonly class="box_" value="#dateformat(teslim_tarihi,dateformat_style)#" onchange="change_deliverdate(this.value,#islem_row_id#);">
                                            <cfelse>
                                                #dateformat(teslim_tarihi,dateformat_style)#
                                            </cfif>
                                        </td>
                                        </cfif>
                                        <!-- sil -->
                                        <td>#dateformat(record_date,dateformat_style)#</td>
                                        <td><cfif type_id eq 1><cfif len(priority_list)><font color="#get_commethod.color[listfind(priority_list,priority_id,',')]#">#get_commethod.priority[listfind(priority_list,priority_id,',')]#</font></cfif></cfif></td>
                                        <td>
                                            <cfif attributes.listing_type eq 1>
                                                #stage#
                                            <cfelse>
                                                <cfif order_currency eq -7><cf_get_lang dictionary_id='29748.Eksik Teslimat'>
                                                    <cfelseif order_currency eq -8><cf_get_lang dictionary_id='29749.Fazla Teslimat'>
                                                    <cfelseif order_currency eq -6><cf_get_lang dictionary_id='58761.Sevk'>
                                                    <cfelseif order_currency eq -5><cf_get_lang dictionary_id='57456.Üretim'>
                                                    <cfelseif order_currency eq -4><cf_get_lang dictionary_id='29747.Kısmi Üretim'>
                                                    <cfelseif order_currency eq -3><cf_get_lang dictionary_id='29746.Kapatıldı'>
                                                    <cfelseif order_currency eq -2><cf_get_lang dictionary_id='29745.Tedarik'>
                                                    <cfelseif order_currency eq -1><cf_get_lang dictionary_id='58717.Açık'>
                                                </cfif>
                                            </cfif>
                                        </td>
                                        <cfif type_id eq 1>
                                            <cfif is_sale_order><!--- Satissa --->
                                                <td>&nbsp;</td>
                                                <td><cfif len(dept_in)>
                                                        #get_dept_name.department_head[listfind(main_department_list,dept_in)]#
                                                        <cfif x_is_location_info and Len(loc_in)> - #get_location.comment[ListFind(location_list,"#dept_in#-#loc_in#",',')]#</cfif>
                                                    <cfelse>
                                                        -
                                                    </cfif>
                                                </td>
                                            <cfelse><!--- Satinalmaysa --->
                                                    <td><cfif len(dept_in)>
                                                            #get_dept_name.department_head[listfind(main_department_list,dept_in)]#
                                                            <cfif x_is_location_info and Len(loc_in)> - #get_location.comment[ListFind(location_list,"#dept_in#-#loc_in#",',')]#</cfif>
                                                        <cfelse>
                                                            -
                                                        </cfif>
                                                    </td>
                                                <td>&nbsp;</td>
                                            </cfif>
                                        <cfelse>
                                                <td><cfif Len(dept_in)>
                                                        #get_dept_name.department_head[ListFind(main_department_list,dept_in)]#
                                                        <cfif x_is_location_info and Len(loc_in)> - #get_location.comment[ListFind(location_list,"#dept_in#-#loc_in#",',')]#</cfif>
                                                    </cfif>
                                                </td>
                                            <td><cfif len(dept_out)>
                                                    #get_dept_name.department_head[listfind(main_department_list,dept_out)]#
                                                    <cfif x_is_location_info and Len(loc_out)> - #get_location.comment[ListFind(location_list,"#dept_out#-#loc_out#",',')]#</cfif>
                                                </cfif>
                                            </td>
                                        </cfif>
                                        <cfif attributes.listing_type neq 1>
                                            <cfif x_equipment_planning_info eq 1 and attributes.listing_type eq 3>
                                            <td>
                                                <cfquery name="Get_Dept_Amount_Spec_Sub_prod" dbtype="query">
                                                    SELECT SUM(QUANTITY) STOCK_AMOUNT FROM Get_Dept_Amount_Spec_Prod WHERE ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#islem_row_id#">
                                                </cfquery>
                                                <cfif Get_Dept_Amount_Spec_Sub_prod.recordcount and len(Get_Dept_Amount_Spec_Sub_prod.STOCK_AMOUNT)>
                                                    #TLFormat(Get_Dept_Amount_Spec_Sub_prod.Stock_Amount,0)#
                                                <cfelseif Get_Production_Date_Info.recordcount>
                                                    #TLFormat(0,0)#
                                                <cfelse>
                                                    <cfif Len(dept_in) and Len(loc_in) and len(spec_id)>
                                                        <!--- Depo Stok Miktari- Spec --->
                                                        <cfif STOCK_AMOUNT1 gt 0>#TLFormat(STOCK_AMOUNT1,0)#<cfelse>-</cfif>
                                                    <cfelseif Len(dept_in) and Len(loc_in) and not len(spec_id) and len(urun_id)>
                                                        <!--- Depo Stok Miktari- Urun --->
                                                        <cfif STOCK_AMOUNT2 gt 0>#TLFormat(STOCK_AMOUNT2,0)#<cfelse>-</cfif>
                                                    <cfelse>
                                                        -
                                                    </cfif>
                                                </cfif>
                                            </td>
                                            <td>
                                                <!--- Plan Bilgisi; Ekip Tarihinde Planlanmis Urunlerin Toplamlari --->
                                                <cfquery name="Get_Planning_Relation_Row_Sub" dbtype="query">
                                                    SELECT SUM(RESULT_AMOUNT) AMOUNT FROM Get_Planning_Relation_Row WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stok_id#"> <cfif Len(spec_main_id)>AND SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#spec_main_id#"><!--- AND SPECT_MAIN_ID = #spec_id# ---></cfif>
                                                </cfquery>
                                                <cfif Get_Planning_Relation_Row_Sub.RecordCount>
                                                    #TLFormat(Get_Planning_Relation_Row_Sub.Amount,0)#
                                                <cfelse>
                                                    -
                                                </cfif>
                                            </td>
                                            </cfif>
                                            <td>
                                                <cfif x_equipment_planning_info eq 1 and attributes.listing_type eq 3>
                                                    <div class="nohoverDivBox" style="position:absolute; margin-left:-600px; display:none;" id="show_rezerved_orders_detail#currentrow#"></div>
                                                    <cfset row_spect_id = SPEC_ID>
                                                    <cfif not len(row_spect_id)><cfset row_spect_id = 0></cfif>
                                                    <a style="cursor:pointer;" class="tableyazi" onclick="show_order_detail(#currentrow#,#URUN_ID#,#STOK_ID#,#row_spect_id#,#is_sale_order#);">
                                                        #urun_adi#
                                                    </a>
                                                <cfelse>
                                                    #urun_adi#
                                                </cfif>
                                            </td>
                                            <td>#spec_adi#</td>
                                        </cfif>
                                        <cfif attributes.listing_type eq 2 and x_is_row_detail eq 1>
                                            <td>#PRODUCT_NAME2#</td>
                                        </cfif>
                                        <cfif attributes.listing_type eq 2 and x_is_row_amount eq 1>
                                            <td>#tlformat(MIKTAR)#</td>
                                        </cfif>
                                        <cfif attributes.listing_type eq 2 and x_is_row_unit eq 1>
                                            <td>#BIRIM#</td>
                                        </cfif>
                                        <td>#ref_no#</td>
                                        <cfif ListFind('1,2',attributes.listing_type,',')>
                                            <cfif type_id eq 1>
                                                <cfquery name="GET_ROW_SHIP" dbtype="query">
                                                    SELECT SHIP_NUMBER,SHIP_TYPE,SHIP_ID FROM GET_SHIPS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#islem_id#">
                                                </cfquery>
                                                <cfif Len(attributes.listing_type) and attributes.listing_type eq 2>
                                                    <cfset add_url_row = "&order_row_id=#islem_row_id#"><!--- Satir Bazinda Satir Id de Gonderiliyor --->
                                                <cfelse>
                                                    <cfset add_url_row = "">
                                                </cfif>
                                                <td>
                                                    <cfif not listfind('-3,-8',order_currency)><!--- kapatıldı veya fazla teslimat asamasında degilse irsaliye oluşturulabilir. --->
                                                        <cfif is_sale_order>
                                                            <cfset stk_url="#request.self#?fuseaction=#fusebox.circuit#.form_add_sale&order_id=#islem_id##add_url_row#">
                                                            <cfset stk_alt="Sevk Et">
                                                            <a href="#stk_url#" title="#stk_alt#"><i class="fa fa-file-text"></i></a>
                                                        <cfelse>
                                                            <cfset stk_url="#request.self#?fuseaction=#fusebox.circuit#.form_add_purchase&order_id=#islem_id##add_url_row#">
                                                            <cfset stk_alt="Sevk Al">
                                                            <a href="#stk_url#"  title="#stk_alt#"><i class="fa fa-file-text"></i></a>
                                                        </cfif>
                                                    </cfif>
                                                </td>
                                                <td>
                                                    <cfset new_action = 'invoice'>
                                                    <cfif  not listfind('-3,-8',order_currency)>
                                                        <cfif is_sale_order>
                                                            <cfset inv_url="#request.self#?fuseaction=#new_action#.form_add_bill&order_id=#islem_id##add_url_row#">
                                                            <cfset inv_alt="Satış Faturası Kes">
                                                        <cfelse>
                                                            <cfset inv_url="#request.self#?fuseaction=#new_action#.form_add_bill_purchase&order_id=#islem_id##add_url_row#">
                                                            <cfset inv_alt="Alış Faturası Kes">
                                                        </cfif>
                                                        <a href="#inv_url#" title="#inv_alt#"><i class="fa fa-edit"></i></a>
                                                    </cfif>
                                                </td>
                                                <cfif session.ep.our_company_info.guaranty_followup eq 1>
                                                    <td><cfquery name="GET_IS_SERIAL_NO" datasource="#DSN3#">
                                                            SELECT
                                                                STOCKS.IS_SERIAL_NO
                                                            FROM
                                                                ORDER_ROW,
                                                                STOCKS
                                                            WHERE
                                                                ORDER_ROW.STOCK_ID = STOCKS.STOCK_ID AND
                                                                ORDER_ROW.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#islem_id#"> AND
                                                                STOCKS.IS_SERIAL_NO = 1
                                                        </cfquery>
                                                        <cfif get_is_serial_no.recordcount>
                                                            <cfif get_row_ship.recordcount>
                                                                <a href="#request.self#?fuseaction=#fusebox.circuit#.list_serial_operations&is_filtre=1&belge_no=#get_row_ship.ship_number#&general_process_id=0&process_cat_id=#get_row_ship.ship_type#&process_id=#get_row_ship.ship_id#" title="<cf_get_lang dictionary_id='57717.Garanti'>-<cf_get_lang dictionary_id='57718.Seri Nolar'>"><i class="fa fa-barcode"></i></a>
                                                            <cfelse>
                                                                <a href="javascript://" onclick="alert('Sipariş Seri Takibi Yapılan Ürün İçermekte.\nLütfen Sevk İşlemi Yapınız.');" title="<cf_get_lang dictionary_id='57717.Garanti'>-<cf_get_lang dictionary_id='57718.Seri Nolar'>"><i class="fa fa-barcode"></i>
                                                            </cfif>
                                                        </cfif>
                                                    </td>
                                                </cfif>
                                            <cfelse>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <cfif session.ep.our_company_info.guaranty_followup eq 1><td>&nbsp;</td></cfif>
                                            </cfif>
                                            <cfif type_id eq 1>
                                                <td><cfif order_currency eq -3>
                                                        <cfquery name="CONTROL" datasource="#DSN2#" maxrows="1">
                                                            SELECT SHIP_ROW.SHIP_ID FROM SHIP_ROW, SHIP_RESULT_ROW WHERE SHIP_ROW.SHIP_ID = SHIP_RESULT_ROW.SHIP_ID AND SHIP_ROW.ROW_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#islem_id#">
                                                        </cfquery>
                                                        <cfquery name="CONTROL2" datasource="#DSN2#">
                                                            SELECT ROW_ORDER_ID FROM SHIP_ROW WHERE ROW_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#islem_id#">
                                                        </cfquery>
                                                        <cfif control2.recordcount>
                                                            <input type="hidden" name="logistic_company_id" id="logistic_company_id" value="#company_id#">
                                                            <input type="hidden" name="logistic_consumer_id" id="logistic_consumer_id" value="#consumer_id#">
                                                            <input type="checkbox" name="is_logistic" id="is_logistic" value="#islem_id#" <cfif control.recordcount> disabled</cfif>>
                                                        </cfif>
                                                    </cfif>
                                                </td>
                                                <td>			
                                                    <cfif get_order_list.order_currency neq -8>
                                                        <cfif is_sale_order>
                                                            <a href="javascript://" onclick="window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#get_order_list.islem_id#&action=#attributes.fuseaction#&action_type=commands&print_type=73','WOC');"><i class="fa fa-print" title="<cf_get_lang dictionary_id='57474.Yazdır'>" alt="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></a>
                                                            <cfelse>
                                                            <a href="javascript://" onclick="window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#get_order_list.islem_id#&action=#attributes.fuseaction#&action_type=commands&print_type=91','WOC');"><i class="fa fa-print" title="<cf_get_lang dictionary_id='57474.Yazdır'>" alt="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></a>
                                                        </cfif>
                                                    </cfif>
                                                </td>
                                                <td><cfif is_sale_order>#get_print.print_count#</cfif></td>
                                            <cfelseif type_id eq 2>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                            <cfelse>
                                                <td>&nbsp;</td>
                                                <td><a href="javascript://" onclick="window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#islem_id#&action=#attributes.fuseaction#&print_type=30','WOC');"><i class="fa fa-print" title="<cf_get_lang dictionary_id='57474.Yazdır'>" alt="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></a></td>
                                                <td>&nbsp;</td>
                                            </cfif>
                                        <cfelseif x_equipment_planning_info eq 1 and attributes.listing_type eq 3>
                                            <!--- Planlama Bazinda --->
                                            <cfif Purchase_Sales eq 1><!--- Satis ---><cfset round_ = ListLast(Evaluate("Basket_Amount_Round_4"),";")><cfelse><!--- Alis ---><cfset round_ = ListLast(Evaluate("Basket_Amount_Round_6"),";")></cfif>
                                            <td><cfif miktar contains '.'>#TLFormat(miktar,round_,0)#<cfelse>#TLFormat(miktar,0)#</cfif></td>
                                            <td>
                                                <cfif attributes.listing_type eq 3>
                                                    <cfif isdefined("get_relation_ship")>
                                                        <cfquery name="get_sub_amount" dbtype="query">
                                                            SELECT SUM(AMOUNT) AMOUNT FROM get_relation_ship WHERE WRK_ROW_RELATION_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_order_list.wrk_row_id#">
                                                        </cfquery>
                                                        <cfif Len(get_sub_amount.amount)>
                                                            <cfset ship_amount_ = get_sub_amount.amount>
                                                        </cfif>
                                                    </cfif>
                                                    <cfif ship_amount_ contains '.'>#TLFormat(ship_amount_,round_,0)#<cfelse>#TLFormat(ship_amount_,0)#</cfif>
                                                </cfif>
                                            </td>
                                            <td>						
                                                <cfquery name="Get_MultiShip_Planning_Info_Sub1" dbtype="query">
                                                    SELECT
                                                        SUM(ORDER_ROW_AMOUNT) ORDER_ROW_AMOUNT
                                                    FROM
                                                        Get_MultiShip_Planning_Info
                                                    WHERE
                                                        OUT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.planning_date#"> AND 
                                                        OUT_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('ww',1,attributes.planning_date)#"> AND 
                                                        ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#islem_row_id#">
                                                </cfquery>
                                                <cfquery name="Get_MultiShip_Planning_Info_Sub2" dbtype="query">
                                                    SELECT
                                                        EQUIPMENT_PLANNING_ID
                                                    FROM
                                                        Get_MultiShip_Planning_Info
                                                    WHERE
                                                        <cfif type_id eq 5 and Len(Complete_List)>
                                                            WRK_ROW_ID NOT IN (#ListQualify(Complete_List,"'",",","all")#) AND
                                                        </cfif>
                                                        ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#islem_row_id#"> AND
                                                        OUT_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.planning_date#">
                                                </cfquery>
                                                <cfif Len(Get_MultiShip_Planning_Info_Sub1.Order_Row_Amount)>
                                                    <cfset planning_amount_ = Get_MultiShip_Planning_Info_Sub1.Order_Row_Amount>
                                                </cfif>
                                                <cfif Len(Get_MultiShip_Planning_Info_Sub2.Equipment_Planning_Id)>
                                                    <cfset equipment_id_ = Get_MultiShip_Planning_Info_Sub2.Equipment_Planning_Id>
                                                </cfif>
                                                <cfif planning_amount_ contains '.'>#TLFormat(planning_amount_,2,0)#<cfelse>#TLFormat(planning_amount_,0)#</cfif>
                                            </td>
                                            <!-- sil -->
                                            <td>
                                                <!--- records_problems; Sorunlu kayitlar olmasi durumunda irsaliyelesen miktar yaziliyor --->
                                                <cfif isdefined("attributes.records_problems")>
                                                    <cfset 'diff_amount_#islem_row_id#' = ship_amount_>
                                                <cfelse>
                                                    <cfset diff_amount_ = miktar - ship_amount_>
                                                    <cfif diff_amount_ gt 0>
                                                        <cfset 'diff_amount_#islem_row_id#' = diff_amount_>
                                                    <cfelse>
                                                        <cfset 'diff_amount_#islem_row_id#' = 0>
                                                    </cfif>
                                                </cfif>
                                                <input type="hidden" name="old_order_amount_#islem_row_id#" id="old_order_amount_#islem_row_id#" value="#TLFormat(miktar)#">
                                                <input type="hidden" name="is_problem_#islem_row_id#" id="is_problem_#islem_row_id#" value="<cfif type_id eq 5>1<cfelse>0</cfif>"><!--- Sevkiyattan donen sorunlu kayitlar --->
                                                <cfif evaluate('diff_amount_#islem_row_id#') contains '.'>
                                                    <cfset diff_amount_control_ = "#TLFormat(evaluate('diff_amount_#islem_row_id#'),round_,0)#">
                                                <cfelse>
                                                    <cfset diff_amount_control_ = "#TLFormat(evaluate('diff_amount_#islem_row_id#'),0)#">
                                                </cfif>
                                                <cfsavecontent variable="in_message"><cf_get_lang dictionary_id='38519.Miktarı Kontrol Ediniz'>!</cfsavecontent>
                                                <input type="text" name="diff_amount_#islem_row_id#" id="diff_amount_#islem_row_id#" onblur="if(filterNum(this.value,2)=='' || filterNum(this.value,2)==0 || filterNum(this.value,4) < 0){this.value=0;}if(filterNum(this.value,2) > #diff_amount_#){alert('Kalan Miktar #TLFormat(diff_amount_,0)# dan Fazla Olmamalıdır!');this.value=commaSplit(#diff_amount_#,0);}" class="box" value="#diff_amount_control_#" message="#in_message#" <cfif miktar-ship_amount_ eq 0 or isdefined("attributes.records_problems")>disabled</cfif>>
                                            </td>
                                            <td nowrap>
                                                <input type="hidden" name="old_equipment_planning_#islem_row_id#" id="old_equipment_planning_#islem_row_id#" value="#equipment_id_#">
                                                <select name="equipment_planning_#islem_row_id#" id="equipment_planning_#islem_row_id#" >
                                                    <option value=""><cf_get_lang dictionary_id='58870.Ekip - Araç'></option>
                                                    <cfloop query="get_planning_info">
                                                        <cfif (x_equipment_planning_relation_member eq 1 and equipment_id_ eq planning_id) or (x_equipment_planning_relation_member eq 1 and ( (ListFind(Relation_Comp_Id,get_order_list.company_id) or ListFind(Relation_Cons_Id,get_order_list.consumer_id)) or ((ListFind(Relation_Comp_Id,attributes.company_id) or ListFind(Relation_Cons_Id,attributes.consumer_id)) and len(attributes.company) ) ) ) or x_equipment_planning_relation_member eq 0>
                                                            <option value="#planning_id#" <cfif equipment_id_ eq planning_id>selected</cfif>>#team_code#</option>
                                                        </cfif>
                                                    </cfloop>
                                                </select>
                                            </td>
                                            <!-- sil -->
                                        </cfif>
                                    </tr>
                            </cfoutput>
                            
                        </tbody>
                    </cfform>
                </cfif>
        </cf_grid_list>
        <cfif not get_order_list.recordcount>
        <div class="ui-info-bottom">
            <p><cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</p>
            </div>
        </cfif>
        <cfset adres="#fusebox.circuit#.list_command&is_submitted=1">
        <cfset adres = "#adres#&currency_id=#attributes.currency_id#">
        <cfif isdate(attributes.date1)><cfset adres = "#adres#&date1=#dateformat(attributes.date1,dateformat_style)#"></cfif>
        <cfif isdate(attributes.date2)><cfset adres = "#adres#&date2=#dateformat(attributes.date2,dateformat_style)#"></cfif>
        <cfif isdate(attributes.documentdate1)><cfset adres = "#adres#&documentdate1=#dateformat(attributes.documentdate1,dateformat_style)#"></cfif>
        <cfif isdate(attributes.documentdate2)><cfset adres = "#adres#&documentdate2=#dateformat(attributes.documentdate2,dateformat_style)#"></cfif>
        <cfif len(attributes.listing_type)><cfset adres = "#adres#&listing_type=#attributes.listing_type#"></cfif>
        <cfif x_equipment_planning_info eq 1 and attributes.listing_type eq 3>
            <cfif isdefined("attributes.records_problems")><cfset adres = "#adres#&records_problems=#attributes.records_problems#"></cfif>
            <cfif Len(attributes.planning_status)><cfset adres = "#adres#&planning_status=#attributes.planning_status#"></cfif>
            <cfif isdate(attributes.planning_date)><cfset adres = "#adres#&planning_date=#dateformat(attributes.planning_date,dateformat_style)#"></cfif>
            <cfif len(attributes.product_name) and len(attributes.product_id)>
                <cfset adres = "#adres#&stock_id=#attributes.stock_id#&product_id=#attributes.product_id#&product_name=#attributes.product_name#">
            </cfif>
            <cfif len(attributes.spect_main_name) and len(attributes.spect_main_id)>
                <cfset adres = "#adres#&spect_main_id=#attributes.spect_main_id#&spect_main_name=#attributes.spect_main_name#">
            </cfif>
            <cfif len(attributes.product_brand_name) and len(attributes.product_brand_id)>
                <cfset adres = "#adres#&product_brand_id=#attributes.product_brand_id#&product_brand_name=#attributes.product_brand_name#">
            </cfif>
            <cfif len(attributes.product_model_name) and len(attributes.product_model_id)>
                <cfset adres = "#adres#&product_model_id=#attributes.product_model_id#&product_model_name=#attributes.product_model_name#">
            </cfif>
        </cfif>
        <cfif len(attributes.ord_stage)><cfset adres = "#adres#&ord_stage=#attributes.ord_stage#"></cfif>
        <cfif len(attributes.ship_method)><cfset adres = "#adres#&ship_method=#attributes.ship_method#"></cfif>
        <cfif len(attributes.our_comp_id)><cfset adres = "#adres#&our_comp_id=#attributes.our_comp_id#"></cfif>
        <cfif len(attributes.sale_add_option)><cfset adres = "#adres#&sale_add_option=#attributes.sale_add_option#"></cfif>
        <cfif len(attributes.keyword)><cfset adres = "#adres#&keyword=#attributes.keyword#"></cfif>
        <cfif len(attributes.ref_no)><cfset adres = "#adres#&ref_no=#attributes.ref_no#"></cfif>
        <cfif len(attributes.cat)><cfset adres = "#adres#&cat=#attributes.cat#"></cfif>
        <cfif isdefined("attributes.is_dispatch")><cfset adres = "#adres#&is_dispatch=#attributes.is_dispatch#"></cfif>
        <cfif isDefined('attributes.stock_branch_id') and len(attributes.stock_branch_id)><cfset adres = "#adres#&stock_branch_id=#attributes.stock_branch_id#"></cfif>
        <cfif len(attributes.company) and len(attributes.company_id)>
            <cfset adres = "#adres#&company_id=#attributes.company_id#&company=#attributes.company#">
        </cfif>
        <cfif len(attributes.company) and len(attributes.consumer_id)>
            <cfset adres = "#adres#&consumer_id=#attributes.consumer_id#&company=#attributes.company#">
        </cfif>
        <cfif len(attributes.project_head) and len(attributes.project_id)>
            <cfset adres = "#adres#&project_id=#attributes.project_id#&project_head=#attributes.project_head#">
        </cfif>
        <cfif len(attributes.city) and len(attributes.city_id)>
            <cfset adres = "#adres#&city_id=#attributes.city_id#&city=#attributes.city#">
        </cfif>
        <cfif len(attributes.county) and len(attributes.county_id)>
            <cfset adres = "#adres#&county_id=#attributes.county_id#&county=#attributes.county#">
        </cfif>
        <cfif len(attributes.department_txt) and len(attributes.department_id)>
            <cfset adres = "#adres#&department_id=#attributes.department_id#&department_txt=#attributes.department_txt#">
            <cfif len(attributes.department_id)>
                <cfset adres = "#adres#&location_id=#attributes.location_id#">
            </cfif>
        </cfif>
        <cfif len(attributes.product_cat) and len(attributes.product_code)>
            <cfset adres = "#adres#&product_cat_id=#attributes.product_cat_id#&product_code=#attributes.product_code#&product_cat=#attributes.product_cat#">
        </cfif>
        <cfif isdefined('attributes.subscription_id') and len(attributes.subscription_id) and isdefined('attributes.subscription_no') and len(attributes.subscription_no)>
            <cfset adres = "#adres#&subscription_id=#attributes.subscription_id#&subscription_no=#attributes.subscription_no#">
        </cfif>
        <cfif isdefined('attributes.record_emp_id') and len(attributes.record_emp_name)>
            <cfset adres = "#adres#&record_emp_id=#attributes.record_emp_id#&record_emp_name=#attributes.record_emp_name#">
        </cfif>
        <cfif isdefined('attributes.deliver_emp_id') and len(attributes.deliver_emp_name)>
            <cfset adres = "#adres#&deliver_emp_id=#attributes.deliver_emp_id#&deliver_emp_name=#attributes.deliver_emp_name#">
        </cfif>
        <cfif isdefined('attributes.SZ_ID') and len(attributes.SZ_ID)>
            <cfset adres = "#adres#&SZ_ID=#attributes.SZ_ID#">
        </cfif>
        <cfif isdefined('attributes.sales_zone_id') and len(attributes.sales_zone_id)>
            <cfset adres = "#adres#&sales_zone_id=#attributes.sales_zone_id#">
        </cfif>
        <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="#adres#">
    </cf_box>
    <cfif get_order_list.recordcount>
    <cf_box pure="1">
        <div class="ui-form-list-btn flex-end" style="border-top:none;">
<cf_box_elements>
            <!-- sil -->
            <cfif ListFind('1,2',attributes.listing_type,',')>
                <cfif not len(attributes.cat) or listfind(attributes.cat,1) or listfind(attributes.cat,2)>
                    <cfoutput>
                            <cfsavecontent variable="toplu_paket"><cf_get_lang dictionary_id ='45585.Toplu Paketle'></cfsavecontent>
                            <cfsavecontent variable="packet"><cf_get_lang dictionary_id ='45587.Paketle'></cfsavecontent>
                                <a onclick='kontrol2()' class="ui-wrk-btn ui-wrk-btn-extra"><i class="fa fa-clone"></i> #toplu_paket#</a>
                                <a onclick='kontrol()' class="ui-wrk-btn ui-wrk-btn-success"><i class="fa fa-share-square"></i> #packet#</a>
                    </cfoutput>
                </cfif>
            <cfelseif x_equipment_planning_info eq 1 and attributes.listing_type eq 3>
                            <input type="hidden" name="order_row_list_" id="order_row_list_" value=""><!--- form gonderilirken order_row degerleri function ile dolduruluyor --->
                            <cfoutput>
                                <input type="hidden" name="planning_date_" id="planning_date_" value="#attributes.planning_date#">
                                <input type="hidden" name="date1_" id="date1_" value="#attributes.date1#">
                                <input type="hidden" name="date2_" id="date2_" value="#attributes.date2#">
                                <input type="hidden" name="cat_" id="cat_" value="#attributes.cat#">
                                
                                <input type="hidden" name="product_code_" id="product_code_" value="#attributes.product_code#">
                                <input type="hidden" name="product_cat_id_" id="product_cat_id_" value="#attributes.product_cat_id#">
                                <input type="hidden" name="product_cat_" id="product_cat_" value="#attributes.product_cat#">
                                <input type="hidden" name="consumer_id_" id="consumer_id_" value="#attributes.consumer_id#">
                                <input type="hidden" name="company_id_" id="company_id_" value="#attributes.company_id#">
                                <input type="hidden" name="company_" id="company_" value="#attributes.company#">
                                <input type="hidden" name="ref_no_" id="ref_no_" value="#attributes.ref_no#">
                                <input type="hidden" name="keyword_" id="keyword_" value="#attributes.keyword#">
                            </cfoutput>
                            <div class="form-group">
                                <cf_workcube_process is_upd='0' process_cat_width='120;margin-top:5px;' is_detail='0'>
                            </div>
                            <cfsavecontent variable="sevk_planla"><cf_get_lang dictionary_id='58871.Sevk Planı Oluştur'></cfsavecontent>
                            <div class="form-group">
                            <cfoutput> 
                            <a onclick='kontrol_sevk()' class="ui-wrk-btn ui-wrk-btn-red"><i class="fa fa-edit"></i> #sevk_planla#</a>
                           </cfoutput>
                        </div>
            </cfif>
            <!-- sil -->
        </cf_box_elements></div>
    </cf_box>
</cfif>
</div>
<script type="text/javascript">
document.getElementById('keyword').focus();
function show_order_detail(row_id,product_id,stock_id,spect_var_id,purchase_sales)
{
	document.getElementById('show_rezerved_orders_detail'+row_id+'').style.display='block';
	AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_reserved_orders&is_from_stock=1&taken='+purchase_sales+'&spect_var_id='+spect_var_id+'&pid='+product_id+'&sid='+stock_id+'&row_id='+row_id+'','show_rezerved_orders_detail'+row_id+'',1);
}

function contrl_funcs(my_val)
{
	
if(my_val==3)
{document.list_order.cat.value=2;}	
else
	$('#records_problems').attr('readonly', true);
}
function temizle(x)
{
	if (x == 1)
		if(list_order.county.value.length == 0) list_order.county_id.value='';
	else
		if(list_order.city.value.length == 0) list_order.city_id.value='';
}

function input_control()
{
	<cfif x_is_date_diff eq 1>
		if(datediff(document.getElementById('date1').value,document.getElementById('date2').value,0) >= 8)
		{
			alert("<cf_get_lang dictionary_id ='45728.Tarih Aralığı En Fazla 7 Gün Olmalıdır'>!")
			return false;
		}
	</cfif>
	<cfif x_is_date_diff_documentdate eq 1>
		if(datediff(document.getElementById('documentdate1').value,document.getElementById('documentdate2').value,0) >= 8)
		{
			alert("<cf_get_lang dictionary_id ='45728.Tarih Aralığı En Fazla 7 Gün Olmalıdır'>!")
			return false;
		}
	</cfif>
	<cfif x_equipment_planning_info eq 1 and attributes.listing_type eq 3>
	if(document.getElementById('records_problems').checked==true && document.getElementById("listing_type").value != 3)
	{
		alert("<cf_get_lang dictionary_id='61114.Sorunlu Kayıtlar Filtresi Yalnızca Sevkiyat Bazında Filtrelenir'>");
		return false; 
	}
	</cfif>
	<cfif not session.ep.our_company_info.unconditional_list>
		if(list_order.project_head.value.length==0) 
			list_order.project_id.value='';
		if(list_order.keyword.value.length==0 && list_order.cat.value.length==0 && list_order.ship_method.value.length==0 && (list_order.company.value.length == 0 || (list_order.consumer_id.value.length == 0 && list_order.company_id.value.length == 0)) && list_order.project_head.value.length==0 && list_order.ord_stage.value.length==0
		&& (list_order.city_id.value.length == 0 || list_order.city.value.length == 0) && (list_order.county_id.value.length == 0 || list_order.county.value.length == 0) && (list_order.date1.value.length == 0) && (list_order.date2.value.length == 0)) 
		{
		   alert ("<cf_get_lang dictionary_id='57526.En Az Bir Alanda Filtre Etmelisiniz'>!"); 
		   return false;
		}
		else
			return true;
	<cfelse>
		return true;
	</cfif>
}

<cfif attributes.listing_type eq 3>
function kontrol_sevk()
{
	if(document.getElementById("process_stage").value == '')
	{
		alert("<cf_get_lang dictionary_id='57976.Lütfen Süreçlerinizi Tanımlayınız ve/veya Tanımlanan Süreçler Üzerinde Yetkiniz Yok'>");
		return false;
	}
	
	
	var order_row_list_ = '';
	var row_equipment_control_ = 0;
	
	var ekip_list_ = '0';
	var ekip_cus_list_ = '0';

	<cfif get_order_list.recordcount>
		<cfoutput query="get_order_list" >
			//Xmlde Ekip planlamada Cari iliskisi kurulsun secilir ise, ayni sevkiyat icerisine birden fazla cari eklenmemesi gerekiyor
			<cfif x_equipment_planning_relation_member eq 1>
				if(document.getElementById("equipment_planning_#islem_row_id#").value != '')
				{	
					ekip_id_ = document.getElementById("equipment_planning_#islem_row_id#").value;
					var get_equipment_comp = wrk_query("SELECT PLANNING_ID FROM DISPATCH_TEAM_PLANNING WHERE (RELATION_COMP_ID IS NOT NULL OR RELATION_CONS_ID IS NOT NULL) AND PLANNING_ID = " +  ekip_id_,"dsn3");
					if(get_equipment_comp.recordcount)
					{
						ekip_list_ = ekip_list_ + ',' + ekip_id_;
						<cfif len(company_id)>
							ekip_cus_list_ = ekip_cus_list_ + ',' + 'comp-#company_id#';
						<cfelse>
							ekip_cus_list_ = ekip_cus_list_ + ',' + 'cons-#consumer_id#';
						</cfif>
					}
				}
			</cfif>
			
			if(document.getElementById("equipment_planning_#islem_row_id#").value != '' || document.getElementById("old_equipment_planning_#islem_row_id#").value != '')
				var order_row_list_ = order_row_list_  + '#islem_row_id#,';

			if((document.getElementById("equipment_planning_#islem_row_id#").value != '' && filterNum(document.getElementById("diff_amount_#islem_row_id#").value) == 0))
				row_equipment_control_ = 1;
		</cfoutput>
		document.getElementById("order_row_list_").value = order_row_list_;

		//Xmlde Ekip planlamada Cari iliskisi kurulsun secilir ise, ayni sevkiyat icerisine birden fazla cari eklenmemesi gerekiyor
		<cfif x_equipment_planning_relation_member eq 1>
			//Formdaki ekipler kontrol ediliyor
			for(xx=2;xx<=list_len(ekip_list_);xx++)
			{
				this_ekip_ = list_getat(ekip_list_,xx);
				this_musteri_ = list_getat(ekip_cus_list_,xx);
				for(yy=2;yy<=list_len(ekip_list_);yy++)
				{
					if(xx != yy)
					{
						second_ekip_ = list_getat(ekip_list_,yy);
						second_musteri_ = list_getat(ekip_cus_list_,yy);
						if(this_ekip_ == second_ekip_ &&  this_musteri_ != second_musteri_)
						{
							alert("<cf_get_lang dictionary_id='45765.Aynı Ekibe Farklı Müşteriler Tanımlayamazsınız!'>");
							return false;
						}
					}
				}				
			}
			//Daha onceden planlanmis ekip- sevkiyatlar kontrol ediliyor
			for(xx=2;xx<=list_len(ekip_list_);xx++)
			{
				this_ekip_ = list_getat(ekip_list_,xx);
				this_musteri_ = list_getat(ekip_cus_list_,xx);
				var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + this_ekip_;
				var get_relation_multiship = wrk_safe_query("stk_get_relation_multiship","dsn2",0,listParam);
				if(get_relation_multiship.recordcount)
				{
					for(mm=0; mm < get_relation_multiship.recordcount; mm++)
					{
						if(get_relation_multiship.COMPANY_ID[mm] != '')
						{
							second_musteri_ = 'comp-' + get_relation_multiship.COMPANY_ID[mm];
						}
						else
						{
							second_musteri_ = 'cons-' + get_relation_multiship.CONSUMER_ID[mm];
						}
						if(this_musteri_ != second_musteri_)
						{
							alert("<cf_get_lang dictionary_id='45764.Bu Ekip Daha Önce Farklı Bir Müşteri İçin Seçilmiş'>");
							return false;
						}
					}
				}
			}
		</cfif>
	</cfif>
	if(order_row_list_ == '')
	{
		alert("<cf_get_lang dictionary_id ='45763.En Az Bir Ekip Seçmelisiniz!'>");
		return false;
	}
	if(row_equipment_control_ == 1)
	{
		alert("<cf_get_lang dictionary_id ='45762.Lütfen Ekiplerin Sevk Edilecek Miktarlarını Kontrol Ediniz !'>");
		return false;
	}
	
	<cfif get_order_list.recordcount>
		<cfoutput query="get_order_list" >
			if(document.getElementById("equipment_planning_#islem_row_id#").value != '' || document.getElementById("old_equipment_planning_#islem_row_id#").value != '')
				document.getElementById("diff_amount_#islem_row_id#").value = filterNum(document.getElementById("diff_amount_#islem_row_id#").value);
		</cfoutput>
	</cfif>
	if(!process_cat_control()) return false;

	document.add_ship.action='<cfoutput>#request.self#</cfoutput>?fuseaction=stock.emptypopup_add_multi_packetship&order_row_list_='+document.getElementById("order_row_list_").value+'&planning_date_='+planning_date_.value+'&process_stage='+process_stage.value+'&date1_='+date1_.value+'&date2_='+date2_.value+'&cat_='+cat_.value+'&product_code_='+product_code_.value+'&product_cat_id_='+product_cat_id_.value+'&consumer_id_='+consumer_id_.value+'&product_cat_='+product_cat_.value+'&company_id_='+company_id_.value+'&company_='+company_.value+'&ref_no_='+ref_no_.value+'&keyword_='+keyword_.value;
	document.add_ship.submit();
	return false;	
}

function equipment_all()
{
	<cfif get_order_list.recordcount>
	<cfoutput query="get_order_list" >
		document.getElementById("equipment_planning_#islem_row_id#").value = document.getElementById("equipment_planning_all").value;
	</cfoutput>
	</cfif>
}

function change_deliverdate(xx,yy)
{
	if(xx != '')
	{
		updrowdeliverdate_div = 'update_row_deliver_date_'+yy;
		var send_address = '<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.emptypopup_upd_order_row_deliver_date&row_order_id=' + yy + '&row_deliver_date=' + xx;
		AjaxPageLoad(send_address,updrowdeliverdate_div ,1);
	}
	else
	{
		alert("<cf_get_lang dictionary_id ='45761.Tarih Alanı Boş Olmamalıdır !'>");
		return false;
	}
}
</cfif>

function kontrol()
{
	var my_lengt = document.getElementsByName('logistic_company_id').length;
	kontrol_deger = 0;
	kontrol_deger2= 0;
	
	//checkbox birden fazla ise sayfada
	if (document.getElementById("is_logistic").length != undefined)
	{
		for(xx=0;xx<my_lengt;xx++)
		{
			if(document.all.is_logistic[xx].checked==true)
			{
				kontrol_deger2+=1;
				if(kontrol_deger == 0)
				{
					if(document.all.logistic_company_id[xx].value != '')
					{
						kontrol_deger =1;
						kontrol_member =document.all.logistic_company_id[xx].value;
					}
					else if(document.all.logistic_consumer_id[xx].value != '')
					{
						kontrol_deger =2;
						kontrol_member = document.all.logistic_consumer_id[xx].value;
					}
				}
				else
				{
					if(document.all.logistic_company_id[xx].value != '')
					{
						if((kontrol_member != document.all.logistic_company_id[xx].value != '' && kontrol_deger == 1) || kontrol_deger != 1 )
						{
							alert("<cf_get_lang dictionary_id ='45589.Paketlenecek Carileri Kontrol Ediniz '>!");
							return false;
						}
					}
					else if(document.all.logistic_consumer_id[xx].value != '')
					{
						if((kontrol_member != document.all.logistic_consumer_id[xx].value != '' && kontrol_deger == 2) || kontrol_deger != 2)
						{
							alert("<cf_get_lang dictionary_id ='45589.Paketlenecek Carileri Kontrol Ediniz '>!");
							return false;
						}
	
					}
				}
			}
		}
	}
	else
	{				
		if(document.getElementById("is_logistic").checked==true)
		{
			kontrol_deger2+=1;
			if(document.getElementById("logistic_company_id").value != '' && document.getElementById("logistic_consumer_id").value != '')
			{
				alert("<cf_get_lang dictionary_id ='45589.Paketlenecek Carileri Kontrol Ediniz '>!");
				return false;
			}
		}
	}	
	//BK
	if(kontrol_deger2 == 0)
	{
		alert("<cf_get_lang dictionary_id ='45589.Paketlenecek Carileri Kontrol Ediniz '> !");
		return false;
	}
	
	add_ship.action='<cfoutput>#request.self#?fuseaction=stock.list_packetship&event=add</cfoutput>';
	add_ship.submit();
	return true;
}

function kontrol2()
{
	var my_lengt = document.getElementsByName('is_logistic').length;
	kontrol_deger2= 0;

	if (document.getElementById("is_logistic").length != undefined)
		for(xx=0;xx<my_lengt;xx++)
			if(document.all.is_logistic[xx].checked==true)
				kontrol_deger2+=1;

	if(kontrol_deger2 < 2)
	{
		alert("<cf_get_lang dictionary_id ='45589.Paketlenecek Carileri Kontrol Ediniz '>!");
		return false;
	}

	add_ship.action='<cfoutput>#request.self#?fuseaction=stock.list_multi_packetship&event=add</cfoutput>';
	add_ship.submit();
	return true;
}

function product_control()
{
	if(document.getElementById('stock_id').value=="" || document.getElementById('product_name').value == "" )
	{
		alert("<cf_get_lang dictionary_id ='45639.Spect Seçmek İçin Öncelikle Ürün Seçmeniz Gerekmektedir'>!");
		return false;
	}
	else
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=list_order.spect_main_id&field_name=list_order.spect_main_name&is_display=1&stock_id='+document.getElementById('stock_id').value);
}
	function showBranch(our_comp_id)	
	{
		var comp_id = document.list_order.our_comp_id.value;
		if (comp_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&comp_id="+comp_id+"&is_department=0";
			AjaxPageLoad(send_address,'BRANCH_PLACE',1,'<cf_get_lang dictionary_id="55769.İlişkili Şubeler">');
		}
	}

</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
<cfsetting showdebugoutput="yes">