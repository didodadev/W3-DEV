<script src="AddOns/n1-soft/textile/sales/display/gant/dhtmlxgantt.js?v=6.2.0"></script>
<link rel="stylesheet" href="AddOns/n1-soft/textile/sales/display/gant/dhtmlxgantt.css?v=6.2.0">
<link rel="stylesheet" href="AddOns/n1-soft/textile/sales/display/gant/controls_styles.css?v=6.2.0">
<script src="AddOns/n1-soft/textile/sales/display/gant/jquery_multiselect.js?v=6.1.7"></script>
<link rel="stylesheet" href="AddOns/n1-soft/textile/sales/display/gant/jquery_multiselect.css?v=6.1.7">
<script src="https://cdnjs.cloudflare.com/ajax/libs/chosen/1.8.7/chosen.jquery.js?v=6.1.7"></script>
<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/chosen/1.8.7/chosen.css?v=6.1.7">
<style>
	html, body {
		padding: 0px;
		margin: 0px;
		height: 100%;
	}

	#gantt_here {
		width:100%;
		height:100%;
	}

	.gantt_grid_scale .gantt_grid_head_cell,
	.gantt_task .gantt_task_scale .gantt_scale_cell {
		font-weight: bold;
		font-size: 14px;
		color: rgba(0, 0, 0, 0.7);
	}

	.resource_marker{
		text-align: center;
	}
	.resource_marker div{
		width: 28px;
		height: 28px;
		line-height: 29px;
		display: inline-block;
		border-radius: 15px;
		color: #FFF;
		margin: 3px;
	}
	.resource_marker.workday_ok div {
		background: #51c185;
	}

	.resource_marker.workday_over div{
		background: #ff8686;
	}

	.owner-label{
		width: 20px;
		height: 20px;
		line-height: 20px;
		font-size: 12px;
		display: inline-block;
		border: 1px solid #cccccc;
		border-radius: 25px;
		background: #e6e6e6;
		color: #6f6f6f;
		margin: 0 3px;
		font-weight: bold;
	}

</style>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.start_date" default=''>
<cfparam name="attributes.finish_date" default=''>
<cfparam name="attributes.opplist" default="">
<cfparam name="attributes.station_id" default="">
<cfparam name="attributes.report_type" default="2">
<cfparam name="attributes.gosterim_type" default="0">
<cfparam name="attributes.istasyon_type" default="0">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfquery name="GET_OPERATION" datasource="#dsn3#">
	select 
		OPERATION_TYPE_ID,
		OPERATION_TYPE
	from OPERATION_TYPES
</cfquery>
<cfquery name="GET_W" datasource="#dsn#">
        SELECT 
            STATION_ID,
            STATION_NAME,
            '' UP_STATION
        FROM 
            #dsn3_alias#.WORKSTATIONS 
        WHERE 
            ACTIVE = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
            DEPARTMENT IN (SELECT DEPARTMENT.DEPARTMENT_ID FROM DEPARTMENT,EMPLOYEE_POSITION_BRANCHES WHERE DEPARTMENT.BRANCH_ID = EMPLOYEE_POSITION_BRANCHES.BRANCH_ID AND EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) 
        ORDER BY STATION_NAME ASC
    </cfquery>

<cfform name="search_list" action="" method="post">
    <input type="hidden" name="is_submitted" id="is_submitted" value="1">
    <input type="hidden" name="is_excel" id="is_excel" value="0">
    
                <div class="row">
                	<div class="col col-12 form-inline">
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group col col-3">
								<div class="col col-12">
									<div class="input-group">
										<cfinput type="text" name="start_date" maxlength="10" validate="#validate_style#" style="width:80px;" value="#dateformat(attributes.start_date,dateformat_style)#">
										<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
										<span class="input-group-addon no-bg"></span>
										<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" validate="#validate_style#" style="width:80px;">
										<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
									</div>
								</div>
							</div>
							<div class="form-group col col-3">
								<div class="col col-12">
									<select name="station_id" id="station_id" style="width:170px;">
									  <option value="">Tüm İstasyonlar</option>
									  <option value="0" <cfif attributes.station_id eq 0>selected</cfif>><cf_get_lang dictionary_id='38098.İstasyonu Boş Olanlar'></option>
									  <cfoutput query="get_w">
										  <option value="#station_id#"<cfif attributes.station_id eq station_id>selected</cfif>><cfif len(up_station)>&nbsp;&nbsp;</cfif>#station_name#</option>
									  </cfoutput>
									</select>
								</div>
							</div>
							<!---
							<div class="form-group col col-3">
								<div class="col col-12">
									<select name="report_type" id="raport_type" style="width:170px;">
									  <option value="">Rapor Tipi</option>
									  <option value="0" <cfif attributes.report_type eq 0>selected </cfif>>Gün Bazında</option>
									  <option value="1" <cfif attributes.report_type eq 1>selected </cfif>>Haftalık Bazında</option>
									  <option value="2" <cfif attributes.report_type eq 2>selected </cfif>>Aylık Bazında</option>
									</select>
								</div>
							</div>
							<div class="form-group col col-3">
								<div class="col col-12">
									<select name="gosterim_type" id="gosterim_type" style="width:170px;">
									  <option value="">Gösterim Tipi</option>
									  <option value="0" <cfif attributes.gosterim_type eq 0>selected </cfif>>Miktar Göster</option>
									  <option value="1" <cfif attributes.gosterim_type eq 1>selected </cfif>>Yüzde (%) Göster</option>
									</select>
								</div>
							</div>--->
							<div class="form-group col col-3">
								<div class="col col-12">
									<select name="istasyon_type" id="istasyon_type" style="width:170px;">
									  <option value="0" <cfif attributes.istasyon_type eq 0>selected </cfif>>İş İstasyonu Göster</option>
									  <option value="1" <cfif attributes.istasyon_type eq 1>selected </cfif>>İş İstasyonu Gizle</option>
									</select>
								</div>
							</div>
							<div class="form-group col col-3">
								<div class="col col-12">
									<cf_multiselect_check
									  name="opplist"
									  query_name="get_operation"
									  option_name="OPERATION_TYPE"
									  option_value="OPERATION_TYPE_ID"
									  option_text="Operasyon Seç"
									  value="#attributes.opplist#">
								  </div>
							 </div>
							 <div class="form-group col col-6">
								<form class="gantt_control">
									<input type="radio" id="scale1" class="gantt_radio" name="scale" value="day" checked>
									<label for="scale1">Günlük</label>

									<input type="radio" id="scale2" class="gantt_radio" name="scale" value="week">
									<label for="scale2">Haftalık</label>

									<input type="radio" id="scale3" class="gantt_radio" name="scale" value="month">
									<label for="scale3">Aylık</label>

								</form>
							 </div>
							 <div class="form-group">
								<div class="input-group x-3_5">
									<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,255" maxlength="3" style="width:25px;">
								</div>
							</div>
							 <div class="form-group">
								<cf_wrk_search_button>
							</div>
			            </div>
                    </div>
                </div>
</cfform>

<cfscript>

	//Üretim Siparişleri
	get_order_action = createObject("component", "AddOns.N1-Soft.textile.cfc.get_orders_grup");
	get_order_action.dsn3 = dsn3;
	get_order_action.dsn1 = dsn1;
	get_order_action.dsn_alias = dsn_alias;
	get_order_action.dsn1_alias = dsn1_alias;
	GET_ORDERS = get_order_action.get_orders_fnc(
		ajax : '#IIf(IsDefined("attributes.ajax"),"attributes.ajax",DE(""))#',
		branch_id : '#IIf(IsDefined("attributes.branch_id"),"attributes.branch_id",DE(""))#',
		station_id : '#IIf(IsDefined("attributes.station_id"),"attributes.station_id",DE(""))#',
		department_id : '#IIf(IsDefined("attributes.department_id"),"attributes.department_id",DE(""))#',
		stock_id_ : '#IIf(IsDefined("attributes.stock_id_"),"attributes.stock_id_",DE(""))#',
		product_name : '#IIf(IsDefined("attributes.product_name"),"attributes.product_name",DE(""))#',
		durum_siparis : '#IIf(IsDefined("attributes.durum_siparis"),"attributes.durum_siparis",DE(""))#',
		priority : '#IIf(IsDefined("attributes.priority"),"attributes.priority",DE(""))#',
		position_code : '#IIf(IsDefined("attributes.position_code"),"attributes.position_code",DE(""))#',
		position_name : '#IIf(IsDefined("attributes.position_name"),"attributes.position_name",DE(""))#',
		short_code_id : '#IIf(IsDefined("attributes.short_code_id"),"attributes.short_code_id",DE(""))#',
		short_code_name : '#IIf(IsDefined("attributes.short_code_name"),"attributes.short_code_name",DE(""))#',
		keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(""))#',
		start_date : '#IIf(IsDefined("attributes.start_date"),"attributes.start_date",DE(""))#',
		finish_date : '#IIf(IsDefined("attributes.finish_date"),"attributes.finish_date",DE(""))#',
		start_date_order : '#IIf(IsDefined("attributes.start_date_order"),"attributes.start_date_order",DE(""))#',
		finish_date_order : '#IIf(IsDefined("attributes.finish_date_order"),"attributes.finish_date_order",DE(""))#',
		sales_partner : '#IIf(IsDefined("attributes.sales_partner"),"attributes.sales_partner",DE(""))#',
		sales_partner_id : '#IIf(IsDefined("attributes.sales_partner_id"),"attributes.sales_partner_id",DE(""))#',
		order_employee : '#IIf(IsDefined("attributes.order_employee"),"attributes.order_employee",DE(""))#',
		order_employee_id : '#IIf(IsDefined("attributes.order_employee_id"),"attributes.order_employee_id",DE(""))#',
		member_name : '#IIf(IsDefined("attributes.member_name"),"attributes.member_name",DE(""))#',
		company_id : '#IIf(IsDefined("attributes.company_id"),"attributes.company_id",DE(""))#',
		consumer_id : '#IIf(IsDefined("attributes.consumer_id"),"attributes.consumer_id",DE(""))#',
		pro_member_name : '#IIf(IsDefined("attributes.pro_member_name"),"attributes.pro_member_name",DE(""))#',
		pro_company_id : '#IIf(IsDefined("attributes.pro_company_id"),"attributes.pro_company_id",DE(""))#',
		pro_consumer_id : '#IIf(IsDefined("attributes.pro_consumer_id"),"attributes.pro_consumer_id",DE(""))#',
		project_head : '#IIf(IsDefined("attributes.project_head"),"attributes.project_head",DE(""))#',
		project_id : '#IIf(IsDefined("attributes.project_id"),"attributes.project_id",DE(""))#',
		member_cat_type : '#IIf(IsDefined("attributes.member_cat_type"),"attributes.member_cat_type",DE(""))#',
		spect_main_id : '#IIf(IsDefined("attributes.spect_main_id"),"attributes.spect_main_id",DE(""))#',
		product_id_ : '#IIf(IsDefined("attributes.product_id_"),"attributes.product_id_",DE(""))#',
		product_name : '#IIf(IsDefined("attributes.product_name"),"attributes.product_name",DE(""))#',
		spect_name : '#IIf(IsDefined("attributes.spect_name"),"attributes.spect_name",DE(""))#',
		member_cat_type : '#IIf(IsDefined("attributes.member_cat_type"),"attributes.member_cat_type",DE(""))#',
		category : '#IIf(IsDefined("attributes.category"),"attributes.category",DE(""))#',
		category_name : '#IIf(IsDefined("attributes.category_name"),"attributes.category_name",DE(""))#',
		date_filter : '#IIf(IsDefined("attributes.date_filter"),"attributes.date_filter",DE(""))#',
		startrow : '#attributes.startrow#',
		maxrows : '#attributes.maxrows#'
	);

	//Operasyonlar
	get_prod_order_action = createObject("component", "AddOns.n1-soft.textile.cfc.operation_process");
	get_prod_order_action.dsn3 = dsn3;
	GET_PO_DET = get_prod_order_action.getOperationMain(
		product_id : '#IIf(IsDefined("attributes.product_id"),"attributes.product_id",DE(""))#',
		product_name : '#IIf(IsDefined("attributes.product_name"),"attributes.product_name",DE(""))#',
		related_product_id : '#IIf(IsDefined("attributes.related_product_id"),"attributes.related_product_id",DE(""))#',
		related_stock_id : '#IIf(IsDefined("attributes.related_stock_id"),"attributes.related_stock_id",DE(""))#',
		related_product_name : '#IIf(IsDefined("attributes.related_product_name"),"attributes.related_product_name",DE(""))#',
		production_stage : '#IIf(IsDefined("attributes.production_stage"),"attributes.production_stage",DE(""))#',
		position_code : '#IIf(IsDefined("attributes.position_code"),"attributes.position_code",DE(""))#',
		position_name : '#IIf(IsDefined("attributes.position_name"),"attributes.position_name",DE(""))#',
		product_cat : '#IIf(IsDefined("attributes.product_cat"),"attributes.product_cat",DE(""))#',
		product_cat_code : '#IIf(IsDefined("attributes.product_cat_code"),"attributes.product_cat_code",DE(""))#',
		product_catid : '#IIf(IsDefined("attributes.product_catid"),"attributes.product_catid",DE(""))#',
		spect_main_id : '#IIf(IsDefined("attributes.spect_main_id"),"attributes.spect_main_id",DE(""))#',
		spect_name : '#IIf(IsDefined("attributes.spect_name"),"attributes.spect_name",DE(""))#',
		short_code_id : '#IIf(IsDefined("attributes.short_code_id"),"attributes.short_code_id",DE(""))#',
		short_code_name : '#IIf(IsDefined("attributes.short_code_name"),"attributes.short_code_name",DE(""))#',
		keyword : '#IIf(IsDefined("attributes.keyword") && len(attributes.keyword),"attributes.keyword",DE(""))#',
		result : '#IIf(IsDefined("attributes.result"),"attributes.result",DE(""))#',
		sales_partner : '#IIf(IsDefined("attributes.sales_partner"),"attributes.sales_partner",DE(""))#',
		sales_partner_id : '#IIf(IsDefined("attributes.sales_partner_id"),"attributes.sales_partner_id",DE(""))#',
		order_employee : '#IIf(IsDefined("attributes.order_employee"),"attributes.order_employee",DE(""))#',
		order_employee_id : '#IIf(IsDefined("attributes.order_employee_id"),"attributes.order_employee_id",DE(""))#',
		project_head : '#IIf(IsDefined("attributes.project_head"),"attributes.project_head",DE(""))#',
		project_id : '#IIf(IsDefined("attributes.project_id"),"attributes.project_id",DE(""))#',
		member_type : '#IIf(IsDefined("attributes.member_type"),"attributes.member_type",DE(""))#',
		member_name : '#IIf(IsDefined("attributes.member_name"),"attributes.member_name",DE(""))#',
		company_id : '#IIf(IsDefined("attributes.company_id"),"attributes.company_id",DE(""))#',
		consumer_id : '#IIf(IsDefined("attributes.consumer_id"),"attributes.consumer_id",DE(""))#',
		status : '#IIf(IsDefined("attributes.status"),"attributes.status",DE(""))#',
		fuseaction_ : '#IIf(IsDefined("fuseaction_"),"fuseaction_",DE(""))#',
		is_show_result_amount : '#IIf(IsDefined("is_show_result_amount"),"is_show_result_amount",DE(""))#',
		operation_type_id : '#IIf(IsDefined("operation_type_id"),"operation_type_id",DE(""))#',
		operation_type : '#IIf(IsDefined("operation_type"),"operation_type",DE(""))#',
		station_id : '#IIf(IsDefined("attributes.station_id"),"attributes.station_id",DE(""))#',
		authority_station_id_list : '#IIf(IsDefined("authority_station_id_list"),"authority_station_id_list",DE(""))#',
		related_orders : '#IIf(IsDefined("related_orders"),"related_orders",DE(""))#',
		station_list : '#IIf(IsDefined("station_list"),"station_list",DE(""))#',
		opplist : '#IIf(IsDefined("attributes.opplist"),"attributes.opplist",DE(""))#',
		startrow : '#IIf(IsDefined("attributes.startrow"),"attributes.startrow",DE(""))#',
		maxrows : '#IIf(IsDefined("attributes.maxrows"),"attributes.maxrows",DE(""))#',
		start_date : '#IIf(IsDefined("attributes.start_date"),"attributes.start_date",DE(""))#',
		start_date_2 : '#IIf(IsDefined("attributes.start_date_2"),"attributes.start_date_2",DE(""))#',
		finish_date : '#IIf(IsDefined("attributes.finish_date"),"attributes.finish_date",DE(""))#',
		finish_date_2 : '#IIf(IsDefined("attributes.finish_date_2"),"attributes.finish_date_2",DE(""))#',
		prod_order_stage : '#IIf(IsDefined("attributes.prod_order_stage"),"attributes.prod_order_stage",DE(""))#',
		oby : '#IIf(IsDefined("attributes.oby"),"attributes.oby",DE(""))#',
		P_ORDER_NO1 : '#IIf(IsDefined("attributes.P_ORDER_NO1"),"attributes.P_ORDER_NO1",DE(""))#',
		DEMAND_NO1 : '#IIf(IsDefined("attributes.DEMAND_NO1"),"attributes.DEMAND_NO1",DE(""))#',
		LOT_NO1 : '#IIf(IsDefined("attributes.LOT_NO1"),"attributes.LOT_NO1",DE(""))#',
		REQ_NO1 : '#IIf(IsDefined("attributes.REQ_NO1"),"attributes.REQ_NO1",DE(""))#',
		REFERENCE_NO1 : '#IIf(IsDefined("attributes.REFERENCE_NO1"),"attributes.REFERENCE_NO1",DE(""))#',
		ORDER_NUMBER1 : '#IIf(IsDefined("attributes.ORDER_NUMBER1") && len(attributes.ORDER_NUMBER1),"attributes.ORDER_NUMBER1",DE(""))#',
		PRODUCT_NAME1 : '#IIf(IsDefined("attributes.PRODUCT_NAME1"),"attributes.PRODUCT_NAME1",DE(""))#',
		is_excel : '#IIf(IsDefined("attributes.is_excel"),"attributes.is_excel",DE(""))#'
	);

	//Üretim Emirleri
	get_prod_order_action = createObject("component", "AddOns.N1-Soft.textile.cfc.production_orders");
	get_prod_order_action.dsn3 = dsn3;
	get_prod_order_action.dsn = dsn;
	GET_UE = get_prod_order_action.get_prod_order_fnc(
		product_id : '#IIf(IsDefined("attributes.product_id"),"attributes.product_id",DE(""))#',
		product_name : '#IIf(IsDefined("attributes.product_name"),"attributes.product_name",DE(""))#',
		related_product_id : '#IIf(IsDefined("attributes.related_product_id"),"attributes.related_product_id",DE(""))#',
		related_stock_id : '#IIf(IsDefined("attributes.related_stock_id"),"attributes.related_stock_id",DE(""))#',
		related_product_name : '#IIf(IsDefined("attributes.related_product_name"),"attributes.related_product_name",DE(""))#',
		production_stage : '#IIf(IsDefined("attributes.production_stage"),"attributes.production_stage",DE(""))#',
		position_code : '#IIf(IsDefined("attributes.position_code"),"attributes.position_code",DE(""))#',
		position_name : '#IIf(IsDefined("attributes.position_name"),"attributes.position_name",DE(""))#',
		product_cat : '#IIf(IsDefined("attributes.product_cat"),"attributes.product_cat",DE(""))#',
		product_cat_code : '#IIf(IsDefined("attributes.product_cat_code"),"attributes.product_cat_code",DE(""))#',
		product_catid : '#IIf(IsDefined("attributes.product_catid"),"attributes.product_catid",DE(""))#',
		spect_main_id : '#IIf(IsDefined("attributes.spect_main_id"),"attributes.spect_main_id",DE(""))#',
		spect_name : '#IIf(IsDefined("attributes.spect_name"),"attributes.spect_name",DE(""))#',
		short_code_id : '#IIf(IsDefined("attributes.short_code_id"),"attributes.short_code_id",DE(""))#',
		short_code_name : '#IIf(IsDefined("attributes.short_code_name"),"attributes.short_code_name",DE(""))#',
		keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(""))#',
		result : '#IIf(IsDefined("attributes.result"),"attributes.result",DE(""))#',
		sales_partner : '#IIf(IsDefined("attributes.sales_partner"),"attributes.sales_partner",DE(""))#',
		sales_partner_id : '#IIf(IsDefined("attributes.sales_partner_id"),"attributes.sales_partner_id",DE(""))#',
		order_employee : '#IIf(IsDefined("attributes.order_employee"),"attributes.order_employee",DE(""))#',
		order_employee_id : '#IIf(IsDefined("attributes.order_employee_id"),"attributes.order_employee_id",DE(""))#',
		project_head : '#IIf(IsDefined("attributes.project_head"),"attributes.project_head",DE(""))#',
		project_id : '#IIf(IsDefined("attributes.project_id"),"attributes.project_id",DE(""))#',
		member_type : '#IIf(IsDefined("attributes.member_type"),"attributes.member_type",DE(""))#',
		member_name : '#IIf(IsDefined("attributes.member_name"),"attributes.member_name",DE(""))#',
		company_id : '#IIf(IsDefined("attributes.company_id"),"attributes.company_id",DE(""))#',
		consumer_id : '#IIf(IsDefined("attributes.consumer_id"),"attributes.consumer_id",DE(""))#',
		status : '#IIf(IsDefined("attributes.status"),"attributes.status",DE(""))#',
		fuseaction_ : '#IIf(IsDefined("fuseaction_"),"fuseaction_",DE(""))#',
		is_show_result_amount : '#IIf(IsDefined("is_show_result_amount"),"is_show_result_amount",DE(""))#',
		operation_type_id : '#IIf(IsDefined("operation_type_id"),"operation_type_id",DE(""))#',
		operation_type : '#IIf(IsDefined("operation_type"),"operation_type",DE(""))#',
		station_id : '#IIf(IsDefined("attributes.station_id"),"attributes.station_id",DE(""))#',
		authority_station_id_list : '#IIf(IsDefined("authority_station_id_list"),"authority_station_id_list",DE(""))#',
		related_orders : '#IIf(IsDefined("related_orders"),"related_orders",DE(""))#',
		station_list : '#IIf(IsDefined("station_list"),"station_list",DE(""))#',
		opplist: '#IIf(IsDefined("attributes.opplist"),"attributes.opplist",DE(""))#',
		startrow : '#IIf(IsDefined("attributes.startrow"),"attributes.startrow",DE(""))#',
		maxrows : '#IIf(IsDefined("attributes.maxrows"),"attributes.maxrows",DE(""))#',
		start_date : '#IIf(IsDefined("attributes.start_date"),"attributes.start_date",DE(""))#',
		start_date_2 : '#IIf(IsDefined("attributes.start_date_2"),"attributes.start_date_2",DE(""))#',
		finish_date : '#IIf(IsDefined("attributes.finish_date"),"attributes.finish_date",DE(""))#',
		finish_date_2 : '#IIf(IsDefined("attributes.finish_date_2"),"attributes.finish_date_2",DE(""))#',
		prod_order_stage : '#IIf(IsDefined("attributes.prod_order_stage"),"attributes.prod_order_stage",DE(""))#',
		oby : '#IIf(IsDefined("attributes.oby"),"attributes.oby",DE(""))#',
		P_ORDER_NO1 : '#IIf(IsDefined("attributes.P_ORDER_NO1"),"attributes.P_ORDER_NO1",DE(""))#',
		DEMAND_NO1 : '#IIf(IsDefined("attributes.DEMAND_NO1"),"attributes.DEMAND_NO1",DE(""))#',
		LOT_NO1 : '#IIf(IsDefined("attributes.LOT_NO1"),"attributes.LOT_NO1",DE(""))#',
		REFERENCE_NO1 : '#IIf(IsDefined("attributes.REFERENCE_NO1"),"attributes.REFERENCE_NO1",DE(""))#',
		ORDER_NUMBER1 : '#IIf(IsDefined("attributes.ORDER_NUMBER1"),"attributes.ORDER_NUMBER1",DE(""))#',
		PRODUCT_NAME1 : '#IIf(IsDefined("attributes.PRODUCT_NAME1"),"attributes.PRODUCT_NAME1",DE(""))#',
		is_excel : '#IIf(IsDefined("attributes.is_excel"),"attributes.is_excel",DE(""))#'
	);
	GET_UE_DET = get_prod_order_action.get_prod_order_fnc2(
		station_id : '#IIf(IsDefined("attributes.station_id"),"attributes.station_id",DE(""))#',
		authority_station_id_list : '#IIf(IsDefined("authority_station_id_list"),"authority_station_id_list",DE(""))#',
		product_cat : '#IIf(IsDefined("attributes.product_cat"),"attributes.product_cat",DE(""))#',
		product_cat_code : '#IIf(IsDefined("attributes.product_cat_code"),"attributes.product_cat_code",DE(""))#',
		product_id : '#IIf(IsDefined("attributes.product_id"),"attributes.product_id",DE(""))#',
		product_name : '#IIf(IsDefined("attributes.product_name"),"attributes.product_name",DE(""))#',
		start_date : '#IIf(IsDefined("attributes.start_date"),"attributes.start_date",DE(""))#',
		start_date_2 : '#IIf(IsDefined("attributes.start_date_2"),"attributes.start_date_2",DE(""))#',
		finish_date : '#IIf(IsDefined("attributes.finish_date"),"attributes.finish_date",DE(""))#',
		finish_date_2 : '#IIf(IsDefined("attributes.finish_date_2"),"attributes.finish_date_2",DE(""))#',
		prod_order_stage : '#IIf(IsDefined("attributes.prod_order_stage"),"attributes.prod_order_stage",DE(""))#',
		oby : '#IIf(IsDefined("attributes.oby"),"attributes.oby",DE(""))#',
		fuseaction_ : '#IIf(IsDefined("fuseaction_"),"fuseaction_",DE(""))#',
		station_list : '#IIf(IsDefined("station_list"),"station_list",DE(""))#',
		opplist: '#IIf(IsDefined("attributes.opplist"),"attributes.opplist",DE(""))#'
	);

</cfscript>
<body>

<div id="gantt_here" style='width:100%; height:600px;'></div>

<script>
	gantt.config.columns = [
		{name: "text", tree: true, width: 200, resize: true},
		{name: "start_date", align: "center", width: 80, resize: true},
		{name: "owner", align: "center", width: 75, label: "Owner", template: function (task) {
			if (task.type == gantt.config.types.project) {
				return "";
			}

			var result = "";
			var store = gantt.getDatastore("resource");
			var owners = task[gantt.config.resource_property];

			if (!owners || !owners.length) {
				return "Unassigned";
			}

			/* if(owners.length == 1){
				return store.getItem(owners).text;
			} */
			
			owners.forEach(function(ownerId) {
				var owner = store.getItem(ownerId);
				if (!owner)
					return;
				result += "<div class='owner-label' title='" + owner.text + "'>" + owner.text.substr(0, 1) + "</div>";

			});
			
			return result;
			}, resize: true
		},
		{name: "duration", width: 60, align: "center"},
		{name: "add", width: 44}
	];

	var resourceConfig = {
		columns: [
			{
				name: "name", label: "Name", tree:true, template: function (resource) {
					return resource.text;
				}
			},
			{
				name: "workload", label: "Workload", template: function (resource) {
					var tasks;
					var store = gantt.getDatastore(gantt.config.resource_store),
						field = gantt.config.resource_property;

					if(store.hasChild(resource.id)){
						tasks = gantt.getTaskBy(field, store.getChildren(resource.id));
					}else{
						tasks = gantt.getTaskBy(field, resource.id);
					}

					var totalDuration = 0;
					for (var i = 0; i < tasks.length; i++) {
						totalDuration += tasks[i].duration;
					}

					return (totalDuration || 0) * 8 + "h";
				}
			}
		]
	};

	gantt.templates.resource_cell_class = function(start_date, end_date, resource, tasks){
		var css = [];
		css.push("resource_marker");
		if (tasks.length <= 1) {
			css.push("workday_ok");
		} else {
			css.push("workday_over");
		}
		return css.join(" ");
	};

	gantt.templates.resource_cell_value = function(start_date, end_date, resource, tasks){
		return "<div>" + tasks.length * 8 + "</div>";
	};

	gantt.locale.labels.section_owner = "Owner";
	gantt.config.lightbox.sections = [
		{name: "description", height: 38, map_to: "text", type: "textarea", focus: true},
		//{name: "owner", height: 22, map_to: "owner_id", type: "select", options: gantt.serverList("people")},
		{name:"owner",height:60, type:"multiselect", options:gantt.serverList("people"), map_to:"owner_id", unassigned_value:5 },
		{name: "time", type: "duration", map_to: "auto"}
	];

	gantt.config.resource_store = "resource";
	gantt.config.resource_property = "owner_id";
	gantt.config.order_branch = true;
	gantt.config.open_tree_initially = true;
	gantt.config.layout = {
		css: "gantt_container",
		rows: [
			{
				cols: [
					{view: "grid", group:"grids", scrollY: "scrollVer"},
					{resizer: true, width: 1},
					{view: "timeline", scrollX: "scrollHor", scrollY: "scrollVer"},
					{view: "scrollbar", id: "scrollVer", group:"vertical"}
				],
				gravity:2
			},
			{resizer: true, width: 1},
			{
				config: resourceConfig,
				cols: [
					{view: "resourceGrid", group:"grids", width: 435, scrollY: "resourceVScroll" },
					{resizer: true, width: 1},
					{view: "resourceTimeline", scrollX: "scrollHor", scrollY: "resourceVScroll"},
					{view: "scrollbar", id: "resourceVScroll", group:"vertical"}
				],
				gravity:1
			},
			{view: "scrollbar", id: "scrollHor"}
		]
	};

	var resourcesStore = gantt.createDatastore({
		name: gantt.config.resource_store,
		type: "treeDatastore",
		initItem: function (item) {
			item.parent = item.parent || gantt.config.root_id;
			item[gantt.config.resource_property] = item.parent;
			item.open = true;
			return item;
		}
	});

	var demo_tasks = {
		"data":[
			<cfoutput query="GET_ORDERS">
				{"id": "#ORDER_NUMBER#", "total_catacity" : 0, "kalan" : 0, "text": "#ORDER_NUMBER#", "start_date": "#Replace(dateformat(ORDER_DATE,dateformat_style),'/','-','all')#", "duration": "#datediff('d',ORDER_DATE,DELIVERDATE)#", "parent":"0", "progress": 1, "open": true},
			</cfoutput>
			<cfoutput query="GET_PO_DET">
				{ "id": "OP_#P_OPERATION_ID#","total_catacity" : 10, "kalan" : 2, "text": "#OPERATION_TYPE#", "start_date" : "#Replace(dateformat(DUE_DATE,dateformat_style),'/','-','all')#", "duration": "#datediff('d',DELIVERDATE,DUE_DATE)#", "parent": "#ORDER_NUMBER#", "progress": 0.8,"open": true, "owner_id": ['OP_#P_OPERATION_ID#']},
			</cfoutput>
			<cfoutput query="GET_UE_DET">
				{ "id": "#PARTY_NO#", "total_catacity" : 0, "kalan" : 0, "text": "#PARTY_NO#", "start_date": "#Replace(dateformat(PARTY_STARTDATE,dateformat_style),'/','-','all')#", "duration": "#datediff('d',PARTY_STARTDATE,PARTY_FINISHDATE)#", "parent": "OP_#P_OPERATION_ID#", "progress": 0.8, "open": true, "owner_id": ['#PARTY_NO#']}<cfif currentRow lt GET_UE_DET.recordcount>,</cfif>
			</cfoutput>
		],
		"links":[
				{ id: "2", source: "2", target: "3", type: "0" },
				{ id: "3", source: "3", target: "4", type: "0" },
				{ id: "7", source: "8", target: "9", type: "0" },
				{ id: "8", source: "9", target: "10", type: "0" },
				{ id: "16", source: "17", target: "25", type: "0" },
				{ id: "17", source: "18", target: "19", type: "0" },
				{ id: "18", source: "19", target: "20", type: "0" },
				{ id: "22", source: "13", target: "24", type: "0" },
				{ id: "23", source: "25", target: "18", type: "0" }
			]
	};

	gantt.init("gantt_here");
	gantt.parse(demo_tasks);

	resourcesStore.attachEvent("onParse", function(){
		var people = [];
		resourcesStore.eachItem(function(res){
			if(!resourcesStore.hasChild(res.id)){
				console.log(res);
				var copy = gantt.copy(res);
				copy.key = res.id;
				copy.label = res.text;
				people.push(copy);
			}
		});
		gantt.updateCollection("people", people);
	});

	var resourceData = [
		<cfoutput query="GET_ORDERS">
			{id: "OR_#ORDER_NUMBER#", text: "#ORDER_NUMBER#", parent: null},
		</cfoutput>
		<cfoutput query="GET_PO_DET">
			{ id: "OP_#P_OPERATION_ID#", text: "#OPERATION_TYPE#", parent: "OR_#ORDER_NUMBER#"},
		</cfoutput>
		<cfoutput query="GET_UE_DET">
			{ id: "#PARTY_NO#", text: "#PARTY_NO#", parent: "OP_#P_OPERATION_ID#"}<cfif currentRow lt GET_UE_DET.recordcount>,</cfif>
		</cfoutput>
	];
    
	resourcesStore.parse(resourceData);

	/* resourcesStore.parse([
		{id: 1, text: "QA", parent:null},
		{id: 2, text: "Development", parent:null},
		{id: 3, text: "Sales", parent:null},
		{id: 4, text: "Other", parent:null},
		{id: 5, text: "Unassigned", parent:4},
		{id: 6, text: "John", parent:1},
		{id: 7, text: "Mike", parent:2},
		{id: 8, text: "Anna", parent:2},
		{id: 9, text: "Bill", parent:3},
		{id: 10, text: "Floe", parent:3}
	]); */

	var zoomConfig = {
		levels: [
			{
				name:"day",
				scale_height: 27,
				min_column_width:80,
				scales:[
					{unit: "day", step: 1, format: "%d %M"}
				]
			},
			{
				name:"week",
				scale_height: 50,
				min_column_width:50,
				scales:[
					{unit: "week", step: 1, format: function (date) {
						var dateToStr = gantt.date.date_to_str("%d %M");
						var endDate = gantt.date.add(date, -6, "day");
						var weekNum = gantt.date.date_to_str("%W")(date);
						return "#" + weekNum + ", " + dateToStr(date) + " - " + dateToStr(endDate);
					}},
					{unit: "day", step: 1, format: "%j %D"}
				]
			},
			{
				name:"month",
				scale_height: 50,
				min_column_width:120,
				scales:[
					{unit: "month", format: "%F, %Y"},
					{unit: "week", format: "Week #%W"}
				]
			},
		]
	};

	gantt.ext.zoom.init(zoomConfig);
	gantt.ext.zoom.setLevel("day");
	gantt.ext.zoom.attachEvent("onAfterZoom", function(level, config){
		document.querySelector(".gantt_radio[value='" +config.name+ "']").checked = true;
	});
		
	gantt.templates.task_text=function(start,end,task){
		return task.total_catacity + " / " + task.kalan;
	}; 

	gantt.init("gantt_here", new Date(2018, 8, 1), new Date(2019, 10, 1));
	gantt.parse(demo_tasks);

	var radios = document.getElementsByName("scale");
	for (var i = 0; i < radios.length; i++) {
		radios[i].onclick = function (event) {
			gantt.ext.zoom.setLevel(event.target.value);
		};
	}

</script>
</body>