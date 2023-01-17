<cf_get_lang_set module_name="purchase"><!--- sayfanin en altinda kapanisi var --->
<cf_xml_page_edit fuseact ="purchase.list_order">
<cfset my_url_action = 'purchase.list_order'>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.order_no" default="">
<cfparam name="attributes.referance_no" default="">
<cfparam name="attributes.order_status" default="">
<cfparam name="attributes.currency_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department_ids" default="">
<cfparam name="attributes.location_id" default="">
<cfparam name="attributes.employee" default="" >
<cfparam name="attributes.employee_id" default="" >
<cfparam name="attributes.company" default="" >
<cfparam name="attributes.company_id" default="" >
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.position_code" default="">
<cfparam name="attributes.position_name" default="">
<cfparam name="attributes.prod_cat" default="">
<cfparam name="attributes.order_stage" default="">
<cfparam name="attributes.listing_type" default="">
<cfparam name="attributes.quantity" default="">
<cfparam name="attributes.unit" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.sort_type" default="4">
<cfparam name="attributes.irsaliye_fatura" default="">
<cfparam name="attributes.foreign_categories" default="">
<cfparam name="attributes.zone_id" default="">
<cfparam name="attributes.branch_ids" default="">
<cfparam name="attributes.deliver_start_date" default="">
<cfparam name="attributes.deliver_finish_date" default="">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
<cfelse>
<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
	<cfset attributes.start_date=''>
<cfelse>
	<cfset attributes.start_date = wrk_get_today()>
</cfif>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
<cfelse>
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.finish_date=''>
	<cfelse>
		<cfset attributes.finish_date = date_add('ww',1,attributes.start_date)>
	</cfif>
</cfif>
<cfif isdefined("attributes.deliver_start_date") and isdate(attributes.deliver_start_date)>
	<cf_date tarih="attributes.deliver_start_date">
</cfif>
<cfif isdefined("attributes.deliver_finish_date") and isdate(attributes.deliver_finish_date)>
	<cf_date tarih="attributes.deliver_finish_date">
</cfif>
<cfinclude template="../query/get_stores2.cfm">
<cfscript>
    cmp_branch = createObject("component","V16.hr.cfc.get_branches");
    cmp_branch.dsn = dsn;
    get_branches = cmp_branch.get_branch(ehesap_control : 1,comp_id :session.ep.company_id);
</cfscript>
<cfif isdefined("attributes.form_varmi")>
	<cfset arama_yapilmali = 0>
	<cfscript>
    get_order_list_action = createObject("component", "V16.purchase.cfc.get_order_list");
	get_order_list_action.dsn3 = dsn3;
	get_order_list_action.dsn_alias = dsn_alias;
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
			referance_no : '#IIf(IsDefined("attributes.referance_no"),"attributes.referance_no",DE(""))#',
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
            branch_ids : '#IIf(IsDefined("attributes.branch_ids"),"attributes.branch_ids",DE(""))#'
			);
            
	</cfscript>
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
<cfset url_action = 'purchase.list_order'>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="form" method="post" action="#request.self#?fuseaction=#url_action#">
            <input name="form_varmi" id="form_varmi" value="1" type="hidden">
                <cf_box_search>
                    <cfoutput>
                        <div class="form-group">
                            <input type="text" name="keyword" id="keyword" placeholder="<cf_get_lang dictionary_id='57460.Filtre'>" value="#attributes.keyword#" maxlength="50">
                        </div>
                        <div class="form-group">
                            <input type="text" name="order_no" id="order_no" placeholder="<cf_get_lang dictionary_id='57487.No'>" value="#attributes.order_no#" maxlength="50">
                        </div>
                        <div class="form-group">
                            <input type="text" name="referance_no" value="#attributes.referance_no#" placeholder="<cf_get_lang dictionary_id='58794.Referans No'>" maxlength="255">
                        </div>
                        <div class="form-group">
                            <select name="listing_type" id="listing_type">
                                <option value="1" <cfif attributes.listing_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57660.Belge Bazında'></option>
                                <option value="2" <cfif attributes.listing_type eq 2>selected</cfif>><cf_get_lang dictionary_id='29539.Satır Bazında'></option>
                            </select>
                        </div>
                    </cfoutput>
                    <div class="form-group">
                        <select name="sort_type" id="sort_type">
                            <option value="1" <cfif attributes.sort_type eq 1>selected</cfif>><cf_get_lang dictionary_id="38542.Teslim Tarihine Göre Artan"></option>
                            <option value="2" <cfif attributes.sort_type eq 2>selected</cfif>><cf_get_lang dictionary_id="38543.Teslim Tarihine Göre Azalan"></option>
                            <option value="3" <cfif attributes.sort_type eq 3>selected</cfif>><cf_get_lang dictionary_id="38544.Sipariş Tarihine Göre Artan"></option>
                            <option value="4" <cfif attributes.sort_type eq 4>selected</cfif>><cf_get_lang dictionary_id="38545.Sipariş Tarihine Göre Azalan"></option>
                        </select>
                    </div>
                    <div class="form-group small">
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Filtre',57537)#" maxlength="3">
                    </div>
                    <div class="form-group">
                        <cf_wrk_search_button button_type="4" search_function='input_control()'>
                        <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1' tag_module="list_order_pdf">
                    </div>
                </cf_box_search>
                <cfif len(attributes.listing_type) and attributes.listing_type eq 2> 
                    <cfset row_col_span=16>
                <cfelse> 
                    <cfset row_col_span=12>
                </cfif>
                <cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2>
                    <cfset row_col_span=row_col_span+2>
                </cfif>
                <cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2) and isdefined('xml_dsp_ship_amount_info_') and xml_dsp_ship_amount_info_ eq 1>
                    <cfset row_col_span=row_col_span+2>
                </cfif>
                <cfif xml_dsp_project_info_ eq 1>
                    <cfset ++row_col_span>
                </cfif>
                <cfif isdefined("xml_ref_no") and xml_ref_no eq 1>
                    <cfset ++row_col_span>
                </cfif>
                <cfif xml_show_branch eq 1>
                    <cfset ++row_col_span>
                </cfif>
                <cfif xml_dsp_record_emp_info_ eq 1>
                    <cfset ++row_col_span>
                </cfif>
                <cfif xml_dsp_process_info_ eq 1>
                    <cfset ++row_col_span>
                </cfif>
                <cfif xml_dsp_row_other_money_ eq 1>
                    <cfset ++row_col_span>
                </cfif>
                <cfif xml_deliver_date eq 1>
                    <cfset ++row_col_span>
                </cfif>
                <cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2 and isdefined('xml_dsp_row_other_money_') and xml_dsp_row_other_money_ eq 1>
                    <cfset ++row_col_span>
                </cfif>
                <cf_box_search_detail>
                    <div class="col col-3 col-md-8 col-sm-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-project_id">			
                            <label class="col col-12"><cf_get_lang dictionary_id ='57416.proje'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined("attributes.project_id") and len (attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
                                    <input type="text" name="project_head" id="project_head" value="<cfif isdefined('attributes.project_head') and  len(attributes.project_head)><cfoutput>#URLDecode(attributes.project_head)#</cfoutput></cfif>" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=form.project_id&project_head=form.project_head');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-position_code">
                            <label class="col col-12"><cf_get_lang dictionary_id='57544.Sorumlu'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <input type="hidden" name="position_code" id="position_code" value="<cfif len(attributes.position_code) and len(attributes.position_name)><cfoutput>#attributes.position_code#</cfoutput></cfif>">
                                    <input type="text" name="position_name" id="position_name"  value="<cfif len(attributes.position_code) and len(attributes.position_name)><cfoutput>#attributes.position_name#</cfoutput></cfif>" maxlength="255" onfocus="AutoComplete_Create('position_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','position_code','','3','135');" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis"  onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=form.position_code&field_name=form.position_name&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.form.position_name.value));"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-employee_id">		
                            <label class="col col-12"><cf_get_lang dictionary_id='57899.Kaydeden'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
                                    <input type="text" name="employee" id="employee" value="<cfoutput>#attributes.employee#</cfoutput>"  onfocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','125');" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form.employee_id&field_name=form.employee&select_list=1&branch_related')"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-currency_id">		
                            <label class="col col-12"><cf_get_lang dictionary_id='57482.Aşama'></label>
                            <div class="col col-12">
                                <select name="currency_id" id="currency_id">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <option value="-7" <cfif attributes.currency_id eq -7>selected</cfif>><cf_get_lang dictionary_id ='29748.Eksik Teslimat'></option>
                                    <option value="-8" <cfif attributes.currency_id eq -8>selected</cfif>><cf_get_lang dictionary_id ='29749.Fazla Teslimat'></option>
                                    <option value="-6" <cfif attributes.currency_id eq -6>selected</cfif>><cf_get_lang dictionary_id='58761.Sevk'></option>
                                    <option value="-5" <cfif attributes.currency_id eq -5>selected</cfif>><cf_get_lang dictionary_id ='57456.Üretim'></option>
                                    <option value="-4" <cfif attributes.currency_id eq -4>selected</cfif>><cf_get_lang dictionary_id ='29747.Kısmi Üretim'></option>
                                    <option value="-3" <cfif attributes.currency_id eq -3>selected</cfif>><cf_get_lang dictionary_id='29746.Kapatıldı'></option>
                                    <option value="-10" <cfif attributes.currency_id eq -10>selected</cfif>><cf_get_lang dictionary_id='58623.Kapatıldı (Manuel)'></option>
                                    <option value="-2" <cfif attributes.currency_id eq -2>selected</cfif>><cf_get_lang dictionary_id ='29745.Tedarik'></option>
                                    <option value="-9" <cfif attributes.currency_id eq -9>selected</cfif>><cf_get_lang dictionary_id='58506.İptal'></option>
                                    <option value="-1" <cfif attributes.currency_id eq -1>selected</cfif>><cf_get_lang dictionary_id='58717.Açık'></option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-8 col-sm-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-product_id">			
                            <label class="col col-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
                                <div class="col col-12">
                                    <div class="input-group">
                                    <input type="hidden" name="product_id" id="product_id" <cfif len(attributes.product_name)>value="<cfoutput>#attributes.product_id#</cfoutput>"</cfif>>
                                    <input type="text" name="product_name" id="product_name" value="<cfoutput>#attributes.product_name#</cfoutput>" passthrough="readonly=yes" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID','product_id','','3','225');" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=form.product_id&field_name=form.product_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&keyword='+encodeURIComponent(document.form.product_name.value));"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-company_id">
                            <label class="col col-12"><cf_get_lang dictionary_id='29533.Tedarikçi'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isDefined("attributes.company") and len(attributes.company)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>" />
                                    <input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isDefined("attributes.company") and len(attributes.company)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
                                    <input type="text" name="company" id="company"   value="<cfif isdefined("attributes.company") and len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',0,0','COMPANY_ID,CONSUMER_ID','company_id,consumer_id','','3','250');" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_name=form.company&field_comp_id=form.company_id&field_consumer=form.consumer_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=7,8&keyword='+encodeURIComponent(document.form.company.value));"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-prod_cat">
                            <label class="col col-12"><cf_get_lang dictionary_id='29401.Ürün Kategorisi'></label>
                            <div class="col col-12">
                                <cfinclude template="../query/get_product_cat.cfm">
                                <select name="prod_cat" id="prod_cat" >
                                    <option value="" selected><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_product_cat">
                                        <cfif listlen(HIERARCHY,".") lte 3>
                                            <option value="#HIERARCHY#"<cfif (attributes.prod_cat eq HIERARCHY) and len(attributes.prod_cat) eq len(HIERARCHY)> selected</cfif>>#HIERARCHY#-#product_cat#</option>
                                        </cfif>
                                    </cfoutput>
                                </select>                   
                            </div>
                        </div>
                        <div class="form-group" id="item-irsaliye_fatura">		
                            <label class="col col-12"><cf_get_lang dictionary_id='38572.Sipariş Tipi'></label>
                            <div class="col col-12">
                                <select name="irsaliye_fatura" id="irsaliye_fatura">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <option value="1" <cfif attributes.irsaliye_fatura eq 1>selected</cfif>><cf_get_lang dictionary_id="38568.İrsaliyeleşen"></option>
                                    <option value="2" <cfif attributes.irsaliye_fatura eq 2>selected</cfif>><cf_get_lang dictionary_id="38569.Faturalaşan"></option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-8 col-sm-12" type="column" index="3" sort="true">
                        <div class="form-group">										  
                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                            <div class="col col-12 col-xs-12">
                                <div id="BRANCH_PLACE">                                           
                                    <cf_multiselect_check 
                                        query_name="get_branches"  
                                        name="branch_ids"
                                        width="140" 
                                        option_value="BRANCH_ID"
                                        option_name="branch_name"
                                        option_text="#getLang('main',322)#"
                                        value="#attributes.branch_ids#">
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-department_id">
                            <label class="col col-12"><cf_get_lang dictionary_id='41184.Depo- Lokasyon'></label>			
                            <div class="col col-12">
                            <cfif not isdefined("session.check")>
                                    <cf_wrkdepartmentlocation 
                                        returninputvalue="department_ids,department_id,location_id"
                                        returnqueryvalue="LOCATION_NAME,DEPARTMENT_ID,LOCATION_ID"
                                        fieldname="department_ids"
                                        fieldid="location_id"
                                        department_fldid="department_id"
                                        department_id="#attributes.department_id#"
                                        location_name="#attributes.department_ids#"
                                        location_id="#attributes.location_id#"
                                        user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                        width="120">
                                        <!---
                                    <select name="department_id" id="department_id" >
                                        <option value=""><cfoutput>#getLang('main',322)#</cfoutput></option>
                                        <cfoutput query="stores">
                                            <option value="#department_id#"<cfif attributes.department_id eq stores.department_id> selected</cfif>>#department_head#</option>
                                        </cfoutput>
                                    </select>--->
                                <cfelse>
                                    <input type="Text" value="<cfoutput>#session.store#<cfif isDefined("SESSION.LOCATION_ID")>--#SESSION.LOCATION_NAME#</cfif></cfoutput>" disabled >
                                </cfif>
                            </div>
                        </div>
                        
                        <div class="form-group" id="item-order_stage">
                            <label class="col col-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
                            <div class="col col-12">
                                <select name="order_stage" id="order_stage">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_process_type">
                                        <option value="#process_row_id#"<cfif attributes.order_stage eq process_row_id>selected</cfif>>#stage#</option>
                                    </cfoutput>
                                </select>                  
                            </div>
                        </div>
                        <div class="form-group" id="item-foreign_categories">		
                            <label class="col col-12"><cf_get_lang dictionary_id='29691.Yurtiçi'>/<cf_get_lang dictionary_id='29692.Yurtdışı'></label>
                            <div class="col col-12">
                                <select name="foreign_categories" id="foreign_categories">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <option value="1" <cfif isdefined("attributes.foreign_categories") and attributes.foreign_categories eq 1> selected</cfif>><cf_get_lang dictionary_id='29692.Yurtdışı'></option>
                                    <option value="0" <cfif isdefined("attributes.foreign_categories") and attributes.foreign_categories eq 0> selected</cfif>><cf_get_lang dictionary_id='29691.Yurtiçi'></option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-8 col-sm-12" type="column" index="4" sort="true">
                        <div class="form-group" id="item-order_status">		
                            <label class="col col-12"><cf_get_lang dictionary_id='30111.Durumu'></label>	
                            <div class="col col-12">
                                <select name="order_status" id="order_status">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <option value="1"<cfif attributes.order_status eq 1> selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                                    <option value="0"<cfif attributes.order_status eq 0> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                                </select>
                            </div>
                        </div>
                        <cfif xml_zone_list eq 1>
                            <div class="form-group" id="item-zone_id">		
                                <label class="col col-12"><cf_get_lang dictionary_id='57767.Bölge'></label>
                                <div class="col col-12">
                                    <cf_wrk_zones fieldid='zone_id' selected_value='#attributes.zone_id#'>               
                                </div>
                            </div>
                        </cfif>
                            <div class="form-group" id="item-start_date">	
                            <label class="col col-12"><cf_get_lang dictionary_id='57073.Belge Tarihi'></label>		
                            <div class="col col-12">
                                <div class="input-group">
                                    <cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
                                        <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" maxlength="10" >
                                    <cfelse>
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlama Tarihi Girmelisiniz'></cfsavecontent>
                                        <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
                                    </cfif>
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                                    <span class="input-group-addon no-bg"></span>
                                    <cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
                                        <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#"  validate="#validate_style#" maxlength="10">
                                    <cfelse>
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
                                        <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#"  validate="#validate_style#" maxlength="10" message="#message#">
                                    </cfif>
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                                </div>
                            </div>
                        </div>
                        <cfif xml_deliver_date eq 1>
                            <div class="form-group" id="item-deliver_start_date">	
                            <label class="col col-12"><cf_get_lang dictionary_id='57645.Teslim Tarihi'></label>	
                                <div class="col col-12">
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlama Tarihi Girmelisiniz'></cfsavecontent>
                                        <cfinput type="text" name="deliver_start_date" value="#dateformat(attributes.deliver_start_date,dateformat_style)#"  validate="#validate_style#" maxlength="10" message="#message#">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="deliver_start_date"></span>
                                        <span class="input-group-addon no-bg"></span>
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
                                        <cfinput type="text" name="deliver_finish_date" value="#dateformat(attributes.deliver_finish_date,dateformat_style)#"  validate="#validate_style#" maxlength="10" message="#message#">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="deliver_finish_date">  </span>  
                                    </div>         
                                </div>
                            </div>
                        </cfif>
                    </div>
                </cf_box_search_detail>
        </cfform>            
    </cf_box>
    <cfsavecontent variable="title"><cf_get_lang dictionary_id='38553.Satın Alma Siparişleri'></cfsavecontent>
    <cf_box title="#title#" uidrop="1" hide_table_column="1" woc_setting = "#{ checkbox_name : 'print_order_id',  print_type : 91 }#" >
        <cf_grid_list id="list_order_pdf">
            <thead>
                <tr>
                    
                    <cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
                        <!-- sil --><th></th><!-- sil -->
                    </cfif>
                    
                    <th width="20"><cf_get_lang dictionary_id='57487.No'></th>
                    <cfif isdefined("xml_ref_no") and xml_ref_no eq 1>
                    <th><cf_get_lang dictionary_id='58794.Referans No'></th>
                    </cfif>
                    <th><cf_get_lang dictionary_id='57073.Belge Tarihi'></th>
                    <cfif xml_deliver_date eq 1><th><cf_get_lang dictionary_id='57645.Teslim Tarihi'></th></cfif>
                    <cfif xml_show_branch eq 1><th><cf_get_lang dictionary_id='57453.Şube'></th></cfif>
                    <th><cf_get_lang dictionary_id='57480.Başlık'></th>
                    <cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
                        <th><cf_get_lang dictionary_id='58800.Ürün Kodu'></th>
                        <th><cf_get_lang dictionary_id='57657.Ürün'></th>
                    </cfif>
                    <th><cf_get_lang dictionary_id='57574.Şirket'><cfif xml_dsp_partner_info_ eq 1> -<cf_get_lang dictionary_id='57578.Yetkili'></cfif></th>
                    <th><cf_get_lang dictionary_id='58763.Depo'></th>
                    <cfif xml_dsp_record_emp_info_ eq 1><th><cf_get_lang dictionary_id='57899.Kaydeden'></th></cfif>
                    <cfif xml_dsp_process_info_ eq 1><th><cf_get_lang dictionary_id='41330.Sipariş Süreci'></th></cfif>
                    <th><cf_get_lang dictionary_id='57482.Aşama'></th>
                    <cfif xml_dsp_project_info_ eq 1><th><cf_get_lang dictionary_id='57416.Proje'></th></cfif>
                    <cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
                        <th><cf_get_lang dictionary_id='57635.Miktar'></th>
                        <th><cf_get_lang dictionary_id='58506.İptal'></th>
                        <cfif isdefined('xml_dsp_ship_amount_info_') and xml_dsp_ship_amount_info_ eq 1>
                            <th title="İrsaliyeleşen Miktar"><cf_get_lang dictionary_id='38515.İrs Miktar'></th>
                            <th><cf_get_lang dictionary_id='58444.Kalan'></th>
                        </cfif>
                        <th class="form-title"><cf_get_lang dictionary_id='57636.Birim'></th>
                    </cfif>
                    <cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2 and isdefined('xml_dsp_row_other_money_') and xml_dsp_row_other_money_ eq 1>
                        <th><cf_get_lang dictionary_id ='38516.Döviz Birim Fiyat'></th>
                        <th><cf_get_lang dictionary_id ='57489.Para Br'></th>
                    </cfif>
                    <cfif len(attributes.listing_type) and attributes.listing_type eq 1>
                        <th><cf_get_lang dictionary_id="39067.Kdv siz Toplam"></th>
                        <th><cf_get_lang dictionary_id ='57489.Para Br'></th>
                    </cfif>
                    <th><cf_get_lang dictionary_id='57673.Tutar'></th>
                    <th><cf_get_lang dictionary_id ='57489.Para Br'></th>
                    <th><cf_get_lang dictionary_id='57677.Döviz'><cf_get_lang dictionary_id='57673.Tutar'></th>
                    <th><cf_get_lang dictionary_id ='57489.Para Br'></th>
                    
                    <!-- sil --><th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_order&event=add</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th><!-- sil -->
                    <cfif isdefined("attributes.form_varmi") and get_order_list.recordcount >
                        <th width="20" class="text-center header_icn_none">
                        <input type="checkbox" name="allSelectDemand" id="allSelectDemand" onclick="wrk_select_all('allSelectDemand','print_order_id');"></th>	</cfif>
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
                                SELECT DISTINCT PERIOD_ID FROM ORDERS_SHIP WHERE ORDER_ID IN (#orders_id_list#)
                                UNION ALL
                                SELECT DISTINCT PERIOD_ID FROM ORDERS_INVOICE WHERE ORDER_ID IN (#orders_id_list#)
                            </cfquery>
                            <cfif get_order_ship_periods.recordcount>
                                <cfset orders_ship_period_list =listdeleteduplicates(valuelist(get_order_ship_periods.PERIOD_ID))>
                                <cfif listlen(orders_ship_period_list) eq 1 and orders_ship_period_list eq session.ep.period_id>
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
                                                IR.WRK_ROW_RELATION_ID = ORR.WRK_ROW_ID AND 
                                                ORR.ORDER_ROW_ID IN (#order_row_id_list#)
                                        UNION ALL
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
                                            
                                                IR.WRK_ROW_RELATION_ID IN (SELECT SR.WRK_ROW_ID FROM #dsn2_alias#.SHIP_ROW SR WHERE SR.WRK_ROW_RELATION_ID = ORR.WRK_ROW_ID)
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
                                                *
                                            FROM
                                            (
                                                SELECT 
                                                    IR.INVOICE_ID,
                                                    ORR.WRK_ROW_ID AS ORDER_WRK_ROW_ID,
                                                    ORR.ORDER_ID,
                                                    ORR.STOCK_ID,
                                                    IR.AMOUNT,
                                                    ORR.ORDER_ROW_ID
                                                FROM 
                                                    #dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.INVOICE_ROW IR,
                                                    ORDER_ROW ORR
                                                WHERE 
                                                        IR.WRK_ROW_RELATION_ID = ORR.WRK_ROW_ID 
                                                    
            
            
                                                UNION
                                                
                                                        SELECT 
                                                            IR.INVOICE_ID,
                                                            ORR.WRK_ROW_ID AS ORDER_WRK_ROW_ID,
                                                            ORR.ORDER_ID,
                                                            ORR.STOCK_ID,
                                                            IR.AMOUNT,
                                                            ORR.ORDER_ROW_ID
                                                        FROM 
                                                            #dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP_ROW SR 
                                                            JOIN ORDER_ROW ORR ON SR.WRK_ROW_RELATION_ID =  ORR.WRK_ROW_ID 
                                                            JOIN #dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.INVOICE_ROW IR ON IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID
                                            ) AS XXX
                                                <cfif currentrow neq get_period_dsns.recordcount> UNION ALL </cfif>					
                                            </cfloop> 
                                        ) AS A1
                                        WHERE
                                            ORDER_ROW_ID IN (#order_row_id_list#)
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
                                <cfif listlen(ship_period_list) eq 1 and ship_period_list eq session.ep.period_id>
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
                    <cfoutput query="get_order_list" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                        <cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2><!--- satır bazında listeleme yapılacaksa --->
                            <cfset row_ship_amount_=0>
                            <cfif (isdefined('xml_dsp_ship_amount_info_') and xml_dsp_ship_amount_info_ eq 1) or (isdefined('xml_dps_price_from_row_amount_') and xml_dps_price_from_row_amount_ eq 1)>
                                <cfif isdefined('row_ship_amount_#ORDER_ID#_#STOCK_ID#_#WRK_ROW_ID#') and len(evaluate('row_ship_amount_#ORDER_ID#_#STOCK_ID#_#WRK_ROW_ID#'))>
                                    <cfset row_ship_amount_=evaluate('row_ship_amount_#ORDER_ID#_#STOCK_ID#_#WRK_ROW_ID#')>
                                </cfif>
                            </cfif>
                        </cfif>
                        <tr>
                            
                            <cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
                                <!-- sil --><td align="center" id="order_row#currentrow#" class="color-row" onclick="gizle_goster(order_stocks_detail#currentrow#);connectAjax('#currentrow#','#PRODUCT_ID#','#STOCK_ID#','#unit#','#numberformat(quantity)#');gizle_goster(siparis_goster#currentrow#);gizle_goster(siparis_gizle#currentrow#);">
                                    <img id="siparis_goster#currentrow#" src="/images/listele.gif" title="<cf_get_lang dictionary_id ='58596.Göster'>">
                                    <img id="siparis_gizle#currentrow#" src="/images/listele_down.gif" title="<cf_get_lang dictionary_id ='58628.Gizle'>" style="display:none">
                                </td><!-- sil -->
                            </cfif>
                            
                            <td><a href="#request.self#?fuseaction=#my_url_action#&event=upd&order_id=#order_id#" class="tableyazi">#order_number#</a></td>
                            <cfif isdefined("xml_ref_no") and xml_ref_no eq 1>
                            <td>#REF_NO#</td>
                            </cfif>
                            <td align="center">#dateformat(order_date,dateformat_style)#</td>
                            <cfif xml_deliver_date eq 1><td align="center">#dateformat(deliver_date_,dateformat_style)#</td></cfif>
                            <cfif xml_show_branch eq 1><td>#branch_name#</td></cfif>
                            <td width="100"><a href="#request.self#?fuseaction=#my_url_action#&event=upd&order_id=#order_id#" class="tableyazi">#order_head#</a></td>
                            <cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
                                <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#PRODUCT_ID#','medium');" class="tableyazi">#STOCK_CODE#</a></td>
                                <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#PRODUCT_ID#','medium');" class="tableyazi">#PRODUCT_NAME#</a></td>
                            </cfif>
                            <td width="200px;">
                                <cfif len(company_id)>
                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#COMPANY_ID#','medium');" class="tableyazi">#NICKNAME# </a>
                                <cfelseif Len(consumer_id)>
                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#consumer_id#','medium');" class="tableyazi">#CONSUMER_NAME#</a>
                                </cfif>
                                <cfif xml_dsp_partner_info_ eq 1>
                                    <cfif len(partner_id)>
                                        - <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#PARTNER_ID#','medium');" class="tableyazi">#PARTNER_NAME#</a>
                                    </cfif>
                                </cfif>
                            </td>
                            <td><cfif isdefined('get_all_dep.department_head')>#get_all_dep.department_head[listfind(depo_list,DELIVER_DEPT_ID,',')]#</cfif></td>
                            <cfif xml_dsp_record_emp_info_ eq 1><td nowrap><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#RECORD_EMP#','medium');" class="tableyazi">#EMPLOYEE_NAME#</a></td></cfif>
                            <cfif xml_dsp_process_info_ eq 1><td>#STAGE#</td></cfif>
                            <td width="75" nowrap>
                                <cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
                                    <cfswitch expression = "#ORDER_ROW_CURRENCY#">
                                        <cfcase value="-7"><cf_get_lang dictionary_id='29748.Eksik Teslimat'></cfcase>
                                        <cfcase value="-8"><cf_get_lang dictionary_id='29749.Fazla Teslimat'></cfcase>
                                        <cfcase value="-6"><cf_get_lang dictionary_id='58761.Sevk'> </cfcase>
                                        <cfcase value="-5"><cf_get_lang dictionary_id='57456.Üretim'> </cfcase>
                                        <cfcase value="-4"><cf_get_lang dictionary_id='29747.Kısmi Üretim'></cfcase>
                                        <cfcase value="-3"><cf_get_lang dictionary_id='29746.Kapatıldı'> </cfcase>
                                        <cfcase value="-10"><cf_get_lang dictionary_id='58623.Kapatıldı (Manuel)'></cfcase>
                                        <cfcase value="-2"><cf_get_lang dictionary_id='29745.Tedarik'></cfcase>
                                        <cfcase value="-1"><cf_get_lang dictionary_id='58717.Açık'></cfcase>
                                        <cfcase value="-9"><cf_get_lang dictionary_id='58506.İptal'></cfcase> 
                                    </cfswitch>
                                </cfif>
                                <br>
                                <cfif is_processed eq 1>
                                    <font color="FF0000">
                                    <cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2>
                                        <cfif isdefined('xml_dsp_ship_amount_info_') and xml_dsp_ship_amount_info_ eq 1>
                                            <cfif isdefined('order_row_ship_info_#WRK_ROW_ID#') and evaluate('order_row_ship_info_#WRK_ROW_ID#') eq 1>
                                                <cf_get_lang dictionary_id='57893.İrsaliye Kesildi'><cfif fuseaction contains 'autoexcelpopuppage'>,<cfelse><br/></cfif>
                                            </cfif>
                                            <cfif isdefined('order_row_invoice_info_#WRK_ROW_ID#') and evaluate('order_row_invoice_info_#WRK_ROW_ID#') eq 1>
                                                <cf_get_lang dictionary_id='38670.Faturalandı'>
                                            </cfif>
                                        </cfif>
                                    <cfelse>
                                        <cfif isdefined('order_info_#ORDER_ID#_irsaliye')>
                                            <cf_get_lang dictionary_id='57893.İrsaliye Kesildi'><cfif fuseaction contains 'autoexcelpopuppage'>,<cfelse><br/></cfif>
                                        </cfif>
                                        <cfif isdefined('order_info_#ORDER_ID#_fatura')>
                                            <cf_get_lang dictionary_id='38670.Faturalandı'>
                                        </cfif>
                                    </cfif>
                                    </font>
                                </cfif>
                            </td>
                            <cfif xml_dsp_project_info_ eq 1>
                                <td>
                                    <cfif isdefined("get_order_list.project_id") and len(get_order_list.project_id)> 
                                        <a href="#request.self#?fuseaction=project.projects&event=det&id=#PROJECT_ID#" class="tableyazi">#PROJECT_HEAD#</a></td>
                                    <cfelse>
                                        <cf_get_lang dictionary_id='58459.projesiz'>
                                    </cfif>
                                </td> 
                            </cfif>
                            <cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
                                <td class="text-right">#quantity#</td>
                                <td class="text-right">#cancel_amount#</td>
                                <cfif isdefined('xml_dsp_ship_amount_info_') and xml_dsp_ship_amount_info_ eq 1>
                                    <td class="text-right"><!--- irsaliyelesen--->
                                        <cfif row_ship_amount_ neq 0>
                                            #row_ship_amount_#
                                        <cfelse>
                                            0
                                        </cfif>
                                    </td>
                                    <td class="text-right"><!--- kalan --->
                                        <cfif len(row_ship_amount_)>
                                            #quantity-cancel_amount-row_ship_amount_#
                                        </cfif>
                                    </td>
                                </cfif>
                                <td>#unit#</td>
                            </cfif>
                            <cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2) and isdefined('xml_dsp_row_other_money_') and xml_dsp_row_other_money_ eq 1>
                                <td class="text-right"><cfif len(PRICE_OTHER)>#TLFormat(PRICE_OTHER)#</cfif></td>
                                <td><cfif len(PRICE_OTHER)>#OTHER_MONEY#</cfif></td>
                            </cfif>
                            <cfif len(attributes.listing_type) and attributes.listing_type eq 1>
                                <cfset get_order_kdvsiz = get_order_list_action.get_order_kdvsiz(order_id : order_id)>
                                <td class="text-right">#TLFormat(get_order_kdvsiz.KDVSIZ_TOPLAM)#</td>
                                <td class="text-right">#session.ep.money#</td>
                            </cfif>
                            <td class="text-right">
                                <cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2) and isdefined('xml_dps_price_from_row_amount_') and xml_dps_price_from_row_amount_ eq 1 and row_ship_amount_ neq 0>
                                    #TLFormat((quantity-cancel_amount-row_ship_amount_)*PRICE)#
                                <cfelse>
                                    #TLFormat(NETTOTAL)#
                                </cfif>
                            </td>
                            <td>&nbsp;#session.ep.money#</td>
                            <td class="text-right">
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
                            
                            <!-- sil --><td align="center"><a href="#request.self#?fuseaction=#my_url_action#&event=upd&order_id=#order_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td><!-- sil -->
                                <td style="text-align:center"><input type="checkbox" name="print_order_id" id="print_order_id"  value="#order_id#"></td>
                        </tr>
                        
                        <tr id="order_stocks_detail#currentrow#" class="color-list" style="display:none">
                            <td colspan="25">
                                <div align="left" id="DISPLAY_ORDER_STOCK_INFO#currentrow#"></div>
                            </td>
                            
                        </tr>
                        
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="<cfoutput>#row_col_span#</cfoutput>"><cfif arama_yapilmali neq 1><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
        <cfif get_order_list.recordcount and (attributes.maxrows lt attributes.totalrecords)>
            <table cellpadding="0" cellspacing="0" border="0" width="98%" height="35" align="center">
                <tr>
                    <td>
                        <cfset url_str = attributes.fuseaction&"&form_varmi=1">
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
                        <cfif isdate(attributes.start_date)>
                            <cfset url_str = url_str & "&start_date=#dateformat(attributes.start_date,dateformat_style)#">
                        </cfif>
                        <cfif isdate(attributes.finish_date)>
                            <cfset url_str = url_str & "&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
                        </cfif>
                        <cfif isdate(attributes.deliver_start_date)>
                            <cfset url_str = url_str & "&deliver_start_date=#dateformat(attributes.deliver_start_date,dateformat_style)#">
                        </cfif>
                        <cfif isdate(attributes.deliver_finish_date)>
                            <cfset url_str = url_str & "&deliver_finish_date=#dateformat(attributes.deliver_finish_date,dateformat_style)#">
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
                        <cfif isdefined("attributes.order_stage") and len(attributes.order_stage)>
                            <cfset url_str = url_str & "&order_stage=#attributes.order_stage#">
                        </cfif>
                        <cfif len(attributes.order_no)>
                            <cfset url_str = url_str & "&order_no=#attributes.order_no#">
                        </cfif>
                        <cfif len(attributes.referance_no)>
                            <cfset url_str = url_str & "&referance_no=#attributes.referance_no#">
                        </cfif>
                        <cfif len(attributes.zone_id)>
                            <cfset url_str = url_str & "&order_no=#attributes.zone_id#">
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
                        <cfif isdefined("attributes.branch_ids") and len(attributes.branch_ids)>
                            <cfset url_str = "#url_str#&branch_ids=#attributes.branch_ids#">
                        </cfif>
                        <cfif isdefined("attributes.location_id") and len(attributes.location_id)>
                            <cfset url_str = "#url_str#&location_id=#attributes.location_id#">
                        </cfif>
                        <cfset url_str = url_str & "&sort_type=#attributes.sort_type#">
                        <cf_paging page="#attributes.page#" 
                            maxrows="#attributes.maxrows#"
                            totalrecords="#attributes.totalrecords#"
                            startrow="#attributes.startrow#"
                            adres="#url_str#">
                    </td>
                    <td style="text-align:right;"> <cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
                </tr>
            </table>
        </cfif>
    </cf_box>
</div>
<br/>
<script type="text/javascript">
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
				(form.start_date.value.lenght == 0 || form.finish_date.value.lenght == 0 || form.branch_id.value.lenght == 0)
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
<cfsetting showdebugoutput="yes">
