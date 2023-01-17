<script src="WBP/Fashion/files/sales/display/gant/dhtmlxgantt.js?v=6.2.0"></script>
<script src="WBP/Fashion/files/sales/display/gant/dhtmlxgantt_grouping.js?v=6.2.0"></script>
<script src="WBP/Fashion/files/sales/display/gant/dhtmlxgantt_auto_scheduling.js?v=6.2.0"></script>
<link rel="stylesheet" href="WBP/Fashion/files/sales/display/gant/dhtmlxgantt.css?v=6.2.0">
<link rel="stylesheet" href="WBP/Fashion/files/sales/display/gant/controls_styles.css?v=6.2.0">
<script src="WBP/Fashion/files/sales/display/gant/jquery_multiselect.js?v=6.1.7"></script>
<link rel="stylesheet" href="WBP/Fashion/files/sales/display/gant/jquery_multiselect.css?v=6.1.7">
<script src="https://cdnjs.cloudflare.com/ajax/libs/chosen/1.8.7/chosen.jquery.js?v=6.1.1"></script>
<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/chosen/1.8.7/chosen.css?v=6.1.1">
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
		width: auto;
		min-width:28px;
		height: 28px;
		line-height: 30px;
		display: inline-block;
		border-radius: 15px;
		color: #FFF;
		margin: 3px;
		padding: 0 5px;
	}
	/* .resource_marker.workday_ok div {
		background: #51c185;
	}

	.resource_marker.workday_over div{
		background: #ff8686;
	} */

	.capacity{
		background:#1faae8;
	}
	.full{
		background: #ff8686;
	}
	.empty{
		background: #27f338;
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

<cfquery name="GET_WORKSTATION_ALL" datasource="#dsn#">
	SELECT
		T1.*,
		WORKSTATIONS2.STATION_NAME UPSTATION
	FROM
	(
		SELECT
			WORKSTATIONS.STATION_ID,
			WORKSTATIONS.STATION_NAME,
			WORKSTATIONS.EMP_ID,
			WORKSTATIONS.UP_STATION,
			WORKSTATIONS.OUTSOURCE_PARTNER,
			WORKSTATIONS.CAPACITY,
			WORKSTATIONS.COMMENT,
			OPS.OPERATION_TYPE_ID,
			BRANCH.BRANCH_ID,
			BRANCH.BRANCH_NAME,
			DEPARTMENT.DEPARTMENT_HEAD,
			ISNULL((SELECT SUM(WPC.CAPACITY) AS CAP FROM #dsn3_alias#.WORKSTATIONS_PRODUCTS AS WPC WHERE WPC.WS_ID = WORKSTATIONS.STATION_ID),0) AS STATION_CAPACITY,
			CASE WHEN WORKSTATIONS.UP_STATION IS NULL THEN
				WORKSTATIONS.STATION_ID 
			ELSE
				WORKSTATIONS.UP_STATION 
			END AS UPSTATION_ID,
			WORKSTATIONS.STATION_ID KONTROL_STATION,
			WORKSTATIONS.STATION_NAME KONTROL_NAME,
			CASE WHEN (SELECT TOP 1 WS1.UP_STATION FROM #dsn3_alias#.WORKSTATIONS WS1 WHERE WS1.UP_STATION = WORKSTATIONS.STATION_ID) IS NOT NULL THEN 0 ELSE 1 END AS TYPE,
			(SELECT TOP 1 PO.FINISH_DATE FROM #dsn3_alias#.PRODUCTION_ORDERS PO WHERE PO.STATION_ID = WORKSTATIONS.STATION_ID AND PO.IS_STAGE <> -1 ORDER BY PO.FINISH_DATE DESC) MAX_ORDER_DATE
		FROM
			#dsn3_alias#.WORKSTATIONS AS WORKSTATIONS
			LEFT JOIN OPERATIONS_STATIONS AS OPS ON WORKSTATIONS.STATION_ID = OPS.STATION_ID,
			BRANCH AS BRANCH,
			DEPARTMENT AS DEPARTMENT
		WHERE
			WORKSTATIONS.BRANCH = BRANCH.BRANCH_ID AND
			WORKSTATIONS.DEPARTMENT = DEPARTMENT.DEPARTMENT_ID
			<cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>AND WORKSTATIONS.STATION_ID IN(SELECT WS_ID FROM #dsn3_alias#.WORKSTATIONS_PRODUCTS WP WHERE WP.STOCK_ID IN(#attributes.stock_id#))</cfif>
			<cfif isdefined("attributes.up_search") and len(attributes.up_search)>AND WORKSTATIONS.UP_STATION = #attributes.up_search# AND</cfif>
			<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>AND WORKSTATIONS.BRANCH = #attributes.branch_id#</cfif>
			<cfif isdefined("attributes.keyword") and len(attributes.keyword)>AND WORKSTATIONS.STATION_NAME LIKE '%#attributes.keyword#%'</cfif>	
			<cfif isdefined("attributes.is_active") and len(attributes.is_active)>AND WORKSTATIONS.ACTIVE = #attributes.is_active#</cfif>
		)T1
		LEFT JOIN #dsn3_alias#.WORKSTATIONS AS WORKSTATIONS2 ON WORKSTATIONS2.STATION_ID = T1.UPSTATION_ID
	ORDER BY 
		UPSTATION,
		UPSTATION_ID,
		UP_STATION,
		TYPE,
		STATION_NAME
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="search_list" action="" method="post">
			<input type="hidden" name="is_submitted" id="is_submitted" value="1">
			<input type="hidden" name="is_excel" id="is_excel" value="0">
			<cf_box_search more="0">
				<div class="form-group">
					<div class="input-group">
						<cfinput type="text" name="start_date" maxlength="10" validate="#validate_style#" value="#dateformat(attributes.start_date,dateformat_style)#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" validate="#validate_style#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
					</div>
				</div>
				<div class="form-group">
					<select name="station_id" id="station_id">
						<option value=""><cf_get_lang dictionary_id='36371.Tüm İstasyonlar'></option>
						<option value="0"><cf_get_lang dictionary_id='38098.İstasyonu Boş Olanlar'></option>
						<cfoutput query="get_w">
							<option value="#station_id#" <cfif isdefined("attributes.station_id") and attributes.station_id eq station_id>selected</cfif>><cfif len(up_station)></cfif>#station_name#</option>
						</cfoutput>
					</select>
				</div>
				<!---
				<div class="form-group">
					<div class="col col-12">
						<select name="report_type" id="raport_type" style="width:170px;">
							<option value="">Rapor Tipi</option>
							<option value="0" <cfif attributes.report_type eq 0>selected </cfif>>Gün Bazında</option>
							<option value="1" <cfif attributes.report_type eq 1>selected </cfif>>Haftalık Bazında</option>
							<option value="2" <cfif attributes.report_type eq 2>selected </cfif>>Aylık Bazında</option>
						</select>
					</div>
				</div>
				<div class="form-group">
					<div class="col col-12">
						<select name="gosterim_type" id="gosterim_type" style="width:170px;">
							<option value="">Gösterim Tipi</option>
							<option value="0" <cfif attributes.gosterim_type eq 0>selected </cfif>>Miktar Göster</option>
							<option value="1" <cfif attributes.gosterim_type eq 1>selected </cfif>>Yüzde (%) Göster</option>
						</select>
					</div>
				</div>--->
				<div class="form-group">
						<select name="istasyon_type" id="istasyon_type">
							<option value="0" <cfif attributes.istasyon_type eq 0>selected </cfif>><cf_get_lang dictionary_id='62772.İş İstasyonu Göster'></option>
							<option value="1" <cfif attributes.istasyon_type eq 1>selected </cfif>><cf_get_lang dictionary_id='62773.İş İstasyonu Gizle'></option>
						</select>
				</div>
				<div class="form-group large">
					<cfif isdefined("attributes.opplist")>
						<cf_multiselect_check
							name="opplist"
							query_name="get_operation"
							option_name="OPERATION_TYPE"
							option_value="OPERATION_TYPE_ID"
							option_text="Operasyon Seç"
							value='#attributes.opplist#'>
					<cfelse>
						<cf_multiselect_check
							name="opplist"
							query_name="get_operation"
							option_name="OPERATION_TYPE"
							option_value="OPERATION_TYPE_ID"
							option_text="Operasyon Seç">
					</cfif>
				</div>
				<div class="form-group">
					<label class="col col-6">
						<input type="radio" id="scale1" class="gantt_radio" name="scale" value="day" checked>
						<label for="scale1"><cf_get_lang dictionary_id='58457.Günlük'></label>
					</label>
					<label class="col col-6">
						<input type="radio" id="scale2" class="gantt_radio" name="scale" value="week">
						<label for="scale2"><cf_get_lang dictionary_id='58458.Haftalık'></label>
					</label>
					<label class="col col-6">
						<input type="radio" id="scale3" class="gantt_radio" name="scale" value="month">
						<label for="scale3"><cf_get_lang dictionary_id='58932.Aylık'></label>
					</label>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,255" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box>
		<cfscript>

			//Üretim Siparişleri
			get_order_action = createObject("component", "WBP.Fashion.files.cfc.get_orders_grup");
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
			get_prod_order_action = createObject("component", "WBP.Fashion.files.cfc.operation_process");
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
			get_prod_order_action = createObject("component", "WBP.Fashion.files.cfc.production_orders");
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
		<div id="gantt_here" style="height:800px;"></div>
	</cf_box>
</div>
<script>

	function shouldHighlightTask(task){
		var store = gantt.$resourcesStore;
		var taskResource = task[gantt.config.resource_property],
			selectedResource = store.getSelectedId();
		if(taskResource == selectedResource || store.isChildOf(taskResource, selectedResource)){
			return true;
		}
	}

	gantt.templates.grid_row_class = function(start, end, task){
		var css = [];
		if(gantt.hasChild(task.id)){
			css.push("folder_row");
		}

		if(task.$virtual){
			css.push("group_row")
		}

		if(shouldHighlightTask(task)){
			css.push("highlighted_resource");
		}

		return css.join(" ");
	};

	gantt.templates.task_row_class = function(start, end, task){
		if(shouldHighlightTask(task)){
			return "highlighted_resource";
		}
		return "";
	};

	gantt.templates.timeline_cell_class = function (task, date) {
		if (!gantt.isWorkTime({date: date, task: task}))
			return "week_end";
		return "";
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
		var totalCapacity = 0.0,
			productionPlanTotalResult = 0.0,
			status = false,
			workStations = [],
			productionPlan = [];
		console.log(tasks);
		//mode [ 0 -> sipariş, 1 -> operasyon, 2 -> iş istasyonu, 3 -> üretim emri ]	

		var workStationsTasks = getResourceTasks(resource.id);

		workStationsTasks.forEach(el => {
			if( el.mode[2] && workStations.indexOf(el.id) == -1 ){
				totalCapacity += parseFloat( el.station_capacity );
				workStations.push( el.id );

				var productionPlanTasks = getResourceTasks(el.id);
				
				productionPlanTasks.forEach(elPro => {
					if(elPro.mode[3] && productionPlan.indexOf(elPro.id) == -1){
						productionPlanTotalResult += parseFloat( elPro.ue_operation_amount ) - parseFloat( elPro.ue_result_amount );
						productionPlan.push( elPro.id ); 
					}
				});
			}
		});
		return ( tasks[0]["mode"][1] ) ? "<div class='capacity'>" + totalCapacity + "</div>" + "<div class='full'>" + productionPlanTotalResult + "</div>" + "<div class='empty'>" + (totalCapacity - productionPlanTotalResult) + "</div>" : "";
	};

	function shouldHighlightResource(resource){
		var selectedTaskId = gantt.getState().selected_task;
		if(gantt.isTaskExists(selectedTaskId)){
			var selectedTask = gantt.getTask(selectedTaskId),
				selectedResource = selectedTask[gantt.config.resource_property];

			if(resource.id == selectedResource){
				return true;
			}else if(gantt.$resourcesStore.isChildOf(selectedResource, resource.id)){
				return true;
			}
		}
		return false;
	}

	var resourceTemplates = {
		grid_row_class: function(start, end, resource){
			var css = [];
			if(gantt.$resourcesStore.hasChild(resource.id)){
				css.push("folder_row");
				css.push("group_row");
			}
			if(shouldHighlightResource(resource)){
				css.push("highlighted_resource");
			}
			return css.join(" ");
		},
		task_row_class: function(start, end, resource){
			var css = [];
			if(shouldHighlightResource(resource)){
				css.push("highlighted_resource");
			}
			if(gantt.$resourcesStore.hasChild(resource.id)){
				css.push("group_row");
			}

			return css.join(" ");

		}
	};

	gantt.locale.labels.section_owner = "Owner";
	gantt.config.lightbox.sections = [
		{name: "description", height: 38, map_to: "text", type: "textarea", focus: true},
		{name: "owner", height: 22, map_to: "owner_id", type: "select", options: gantt.serverList("people")},
		{name: "time", type: "duration", map_to: "auto"}
	];

	function getResourceTasks(resourceId){
		var store = gantt.getDatastore(gantt.config.resource_store),
			field = gantt.config.resource_property,
			tasks;

		if(store.hasChild(resourceId)){
			tasks = gantt.getTaskBy(field, store.getChildren(resourceId));
		}else{
			tasks = gantt.getTaskBy(field, resourceId);
		}
		return tasks;
	}

	var resourceConfig = {
		scale_height: 30,
		scales: [
			{unit: "day", step: 1, date: "%d %M"}
		],
		columns: [
			{
				name: "name", label: "Adı", tree:true, width:180, template: function (resource) {
					return resource.text;
				}, resize: true
			},
			{
				name: "progress", label: "Tamamlanan", align:"center",template: function (resource) {
					var tasks = getResourceTasks(resource.id);

					var totalToDo = 0,
						totalDone = 0;
					tasks.forEach(function(task){
						totalToDo += task.duration;
						totalDone += task.duration * (task.progress || 0);
					});

					var completion = 0;
					if(totalToDo){
						completion = Math.floor((totalDone / totalToDo)*100);
					}

					return Math.floor(completion) + "%";
				}, resize: true
			},
			{
				name: "workload", label: "Yoğunluk", align:"center", template: function (resource) {
					var tasks = getResourceTasks(resource.id);
					var totalDuration = 0;
					tasks.forEach(function(task){
						totalDuration += task.duration;
					});

					//return (totalDuration || 0) * 8 + "h";
					return totalDuration + "gün";
				}, resize: true
			},
			{
				name: "capacity", label: "Kapasite", align:"center",template: function (resource) {
					var store = gantt.getDatastore(gantt.config.resource_store);
					var n = store.hasChild(resource.id) ? store.getChildren(resource.id).length : 1

					var state = gantt.getState();

					//return gantt.calculateDuration(state.min_date, state.max_date) * n * 8 + "h";
					return gantt.calculateDuration(state.min_date, state.max_date) * n + "gün";
				}
			}

		]
	};

	gantt.config.scales = [
		{unit: "month", step: 1, format: "%F, %Y"},
		{unit: "day", step: 1, format: "%d %M"}
	];

	gantt.config.auto_scheduling = true;
	gantt.config.auto_scheduling_strict = true;
	gantt.config.work_time = true;
	gantt.config.columns = [
		{name: "text", tree: true, width: 200, resize: true},
		{name: "start_date", label: "Başlangıç", align: "center", width: 80, resize: true},
		{name: "owner", align: "center", width: 80, label: "Owner", template: function (task) {
			if(task.type == gantt.config.types.project){
				return "";
			}

			var store = gantt.getDatastore(gantt.config.resource_store);
			var owner = store.getItem(task[gantt.config.resource_property]);
			if (owner) {
				return owner.text;
			} else {
				return "Unassigned";
			}
		}, resize: true},
		{name: "duration", label:"Gün", width: 60, align: "center", resize: true}
	];

	gantt.config.resource_store = "resource";
	gantt.config.resource_property = "owner_id";
	gantt.config.order_branch = true;
	gantt.config.open_tree_initially = true;
	gantt.config.scale_height = 50;
	gantt.config.layout = {
		css: "gantt_container",
		rows: [
			{
				gravity: 2,
				cols: [
					{view: "grid", group:"grids", scrollY: "scrollVer"},
					{resizer: true, width: 1},
					{view: "timeline", scrollX: "scrollHor", scrollY: "scrollVer"},
					{view: "scrollbar", id: "scrollVer", group:"vertical"}
				]
			},
			{ resizer: true, width: 1, next: "resources"},
			

			{
				gravity:1,
				id: "resources",
				config: resourceConfig,
				templates: resourceTemplates,
				cols: [
					{ view: "resourceGrid", group:"grids", scrollY: "resourceVScroll" },
					{ resizer: true, width: 1},
					{ view: "resourceTimeline", scrollX: "scrollHor", scrollY: "resourceVScroll"},
					{ view: "scrollbar", id: "resourceVScroll", group:"vertical"}
				]
			},
			{view: "scrollbar", id: "scrollHor"}
		]
	};

	var resourceMode = "hours";
	gantt.attachEvent("onGanttReady", function(){
		var radios = [].slice.call(gantt.$container.querySelectorAll("input[type='radio']"));
		radios.forEach(function(r){
			gantt.event(r, "change", function(e){
				var radios = [].slice.call(gantt.$container.querySelectorAll("input[type='radio']"));
				radios.forEach(function(r){
					r.parentNode.className = r.parentNode.className.replace("active", "");
				});

				if(this.checked){
					resourceMode = this.value;
					this.parentNode.className += " active";
					gantt.getDatastore(gantt.config.resource_store).refresh();
				}
			});
		});
	});

	gantt.$resourcesStore = gantt.createDatastore({
		name: gantt.config.resource_store,
		type: "treeDatastore",
		initItem: function (item) {
			item.parent = item.parent || gantt.config.root_id;
			item[gantt.config.resource_property] = item.parent;
			item.open = true;
			return item;
		}
	});

	gantt.$resourcesStore.attachEvent("onAfterSelect", function(id){
		gantt.refreshData();
	});
	var demo_tasks = {
		"data":[
			<cfoutput query="GET_ORDERS">
				{"id": "#ORDER_NUMBER#", "text": "#ORDER_NUMBER#", "start_date": "#Replace(dateformat(ORDER_DATE,dateformat_style),'/','-','all')#", "duration": "#datediff('d',ORDER_DATE,DELIVERDATE)#", "parent":"0", "progress": 1, "open": true, mode : [true, false, false, false]},
			</cfoutput>
			<cfoutput query="GET_PO_DET">
				{ "id": "OP_#OPERATION_TYPE_ID#", "text": "#OPERATION_TYPE#", "start_date" : "#Replace(dateformat(DUE_DATE,dateformat_style),'/','-','all')#", "duration": "#datediff('d',DELIVERDATE,DUE_DATE)#", "parent": "#ORDER_NUMBER#", "progress": 0.8,"open": true, mode : [false, true, false, false], "owner_id": ['OP_#OPERATION_TYPE_ID#']},
			</cfoutput>
			<cfoutput query="GET_WORKSTATION_ALL">
				{ id: "OP_#OPERATION_TYPE_ID#_#STATION_ID#", text: "#STATION_NAME#", station_capacity : "#STATION_CAPACITY#", duration : "0", parent: "OP_#OPERATION_TYPE_ID#", "progress": 0.8,"open": true, mode : [false, false, true, false], "owner_id": ['OP_#OPERATION_TYPE_ID#_#STATION_ID#']},
			</cfoutput>
			<cfoutput query="GET_UE_DET">
				{ "id": "#PARTY_NO#", "text": "#PARTY_NO#", "start_date": "#Replace(dateformat(PARTY_STARTDATE,dateformat_style),'/','-','all')#", "duration": "#datediff('d',PARTY_STARTDATE,PARTY_FINISHDATE)#", "parent": "OP_#OPERATION_TYPE_ID#_#STATION_ID#", "progress": 0.8, "open": true, mode : [false, false, false, true], "ue_operation_amount" : "#OPERATION_AMOUNT#", "ue_production_order_amount" : "#PRODUCTION_ORDER_AMOUNT#", "ue_result_amount" : "#RESULT_AMOUNT#" , "owner_id": ['#PARTY_NO#']}<cfif currentRow lt GET_UE_DET.recordcount>,</cfif>
			</cfoutput>
		]
	};
	gantt.init("gantt_here");
	gantt.parse(demo_tasks);

	gantt.$resourcesStore.attachEvent("onParse", function(){
		var people = [];
		gantt.$resourcesStore.eachItem(function(res){
			if(!gantt.$resourcesStore.hasChild(res.id)){
				var copy = gantt.copy(res);
				copy.key = res.id;
				copy.label = res.text;
				people.push(copy);
			}
		});
		gantt.updateCollection("people", people);
	});

	gantt.$resourcesStore.parse([
		<cfoutput query="GET_PO_DET">
			{ id: "OP_#OPERATION_TYPE_ID#", text: "#OPERATION_TYPE#", parent: null},
		</cfoutput>
		<cfoutput query="GET_WORKSTATION_ALL">
			{ id: "OP_#OPERATION_TYPE_ID#_#STATION_ID#", text: "#STATION_NAME#", parent: "OP_#OPERATION_TYPE_ID#"},
		</cfoutput>
		<cfoutput query="GET_UE_DET">
			{ id: "#PARTY_NO#", text: "#PARTY_NO#", parent: "OP_#OPERATION_TYPE_ID#_#STATION_ID#"}<cfif currentRow lt GET_UE_DET.recordcount>,</cfif>
		</cfoutput>
	]);
	
	var zoomConfig = {
		levels: [
			{
				name:"day",
				scale_height: 27,
				min_column_width:150,
				scales:[
					{unit: "day", step: 1, format: "%d %M"}
				]
			},
			{
				name:"week",
				scale_height: 50,
				min_column_width:150,
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
				min_column_width:150,
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
	
	var radios = document.getElementsByName("scale");
	for (var i = 0; i < radios.length; i++) {
		radios[i].onclick = function (event) {
			gantt.ext.zoom.setLevel(event.target.value);
		};
	}
</script>

