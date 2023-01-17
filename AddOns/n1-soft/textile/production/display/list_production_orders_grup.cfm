<cfset fuseaction_ = ListGetAt(attributes.fuseaction,2,'.')>
<cfsetting showdebugoutput="yes">
<cf_get_lang_set module_name="prod">
<cfset fuseaction_ = replace(fuseaction_,'emptypopup_','')>
<cf_xml_page_edit default_value="1" fuseact="prod.#fuseaction_#">
<cfparam name="attributes.short_code_id" default="">
<cfparam name="attributes.production_stage" default="">
<cfparam name="attributes.lot_no" default="">
<cfparam name="attributes.is_submitted" default="">
<cfparam name="attributes.oby" default="1">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.order_no" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.station_id" default="">
<cfparam name="attributes.order_employee_id" default="">
<cfparam name="attributes.order_employee" default="">
<cfparam name="attributes.sales_partner_id" default="">
<cfparam name="attributes.sales_partner" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.product_catid" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.start_date_2" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.finish_date_2" default="">
<cfparam name="attributes.position_code" default="">
<cfparam name="attributes.position_name" default="">
<cfparam name="attributes.product_cat_code" default="">
<cfparam name="attributes.status" default="2">
<cfparam name="attributes.related_orders" default="1">
<cfparam name="attributes.station_list" default="0">
<cfparam name="attributes.opplist" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
<cfelse>
	<cfset attributes.start_date=''>
</cfif>	
<cfif isdefined('attributes.start_date_2') and isdate(attributes.start_date_2)>
	<cf_date tarih='attributes.start_date_2'>
</cfif>
<cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
<cfelse>
	<cfset attributes.finish_date=''>
</cfif>
<cfif isdefined('attributes.finish_date_2') and isdate(attributes.finish_date_2)>
	<cf_date tarih='attributes.finish_date_2'>
</cfif>
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.related_stock_id" default="">
<cfparam name="attributes.related_product_id" default="">
<cfparam name="attributes.related_product_name" default="">
<cfparam name="attributes.spect_main_id" default="">
<cfparam name="attributes.spect_name" default="">
<cfparam name="attributes.reference_no" default="">
<cfif fuseaction_ contains 'operations'>
	<cfparam name="attributes.result" default="0">
<cfelse>
	<cfparam name="attributes.result" default="">
</cfif>
<cfif isdefined('is_workstation_order_') and is_workstation_order_ eq 1>
    <cfquery name="GET_W" datasource="#dsn#">
       SELECT
			T1.*,
			WORKSTATIONS2.STATION_NAME UPSTATION
		FROM
		(
        SELECT 
            CASE WHEN UP_STATION IS NULL THEN
                STATION_ID 
            ELSE
                 UP_STATION 
            END AS UPSTATION_ID,
            STATION_ID,
            STATION_NAME,
             UP_STATION,
            CASE WHEN (SELECT TOP 1 WS1.UP_STATION FROM #dsn3_alias#.WORKSTATIONS WS1 WHERE WS1.UP_STATION = WORKSTATIONS.STATION_ID) IS NOT NULL THEN 0 ELSE 1 END AS TYPE
        FROM 
            #dsn3_alias#.WORKSTATIONS
        WHERE 
            ACTIVE = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
            DEPARTMENT IN (SELECT DEPARTMENT.DEPARTMENT_ID FROM DEPARTMENT,EMPLOYEE_POSITION_BRANCHES WHERE DEPARTMENT.BRANCH_ID = EMPLOYEE_POSITION_BRANCHES.BRANCH_ID AND EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) 
       )T1
            LEFT JOIN #dsn3_alias#.WORKSTATIONS AS WORKSTATIONS2 ON WORKSTATIONS2.STATION_ID = T1.UPSTATION_ID
        ORDER BY  
         	UPSTATION,
            UPSTATION_ID,
            UP_STATION,
            TYPE,
            STATION_NAME
    </cfquery>
<cfelse>
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
</cfif>
<cfquery name="GET_OPERATION" datasource="#dsn3#">
	select 
		OPERATION_TYPE_ID,
		OPERATION_TYPE
	from OPERATION_TYPES
</cfquery>
<cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
	SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT
</cfquery>
<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
	SELECT CONSCAT_ID,CONSCAT FROM CONSUMER_CAT ORDER BY HIERARCHY
</cfquery>
<cfif GET_W.recordcount><cfset authority_station_id_list = ValueList(GET_W.STATION_ID,',')><cfelse><cfset authority_station_id_list = 0></cfif>
<cfif len(attributes.station_id)>
	<cfquery name="get_station_list" datasource="#dsn3#">
		SELECT STATION_ID FROM WORKSTATIONS WHERE UP_STATION = #attributes.station_id#
	</cfquery>
	<cfif get_station_list.recordcount><cfset station_list = ValueList(get_station_list.STATION_ID)><cfelse><cfset station_list = 0></cfif>
</cfif>
<cfif isdefined('attributes.ORDER_NUMBER1') and len(attributes.ORDER_NUMBER1)><cfset attributes.keyword = attributes.ORDER_NUMBER1><cfset attributes.is_submitted = 1></cfif>
<cfif isdefined("attributes.is_submitted") and len(attributes.is_submitted)>
	<cfscript>
		get_prod_order_action = createObject("component", "AddOns.N1-Soft.textile.cfc.production_orders");
		get_prod_order_action.dsn3 = dsn3;
		get_prod_order_action.dsn = dsn;
        GET_PO = get_prod_order_action.get_prod_order_fnc(
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
			opplist:attributes.opplist,
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
		GET_PO_DET = get_prod_order_action.get_prod_order_fnc2(
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
			opplist:attributes.opplist
		);
	</cfscript>
	<cfparam name="attributes.totalrecords" default='#get_po_det.query_count#'>
<cfelse>
	<cfset GET_PO_DET.recordcount = 0>
	<cfparam name="attributes.totalrecords" default='0'>
</cfif>
<cfscript>wrkUrlStrings('url_str','status','production_stage','is_submitted','keyword','order_no','consumer_id','company_id','member_type','member_name','station_id','order_employee_id','order_employee','sales_partner_id','sales_partner','product_id','product_name','prod_order_stage','result','related_product_id','related_product_name','related_stock_id');</cfscript>
<cfif isdate(attributes.start_date)>
	<cfset url_str = url_str & "&start_date=#dateformat(attributes.start_date,dateformat_style)#">
</cfif>
<cfif isdate(attributes.start_date_2)>
	<cfset url_str = url_str & "&start_date_2=#dateformat(attributes.start_date_2,dateformat_style)#">
</cfif>
<cfif isdate(attributes.finish_date)>
	<cfset url_str = url_str & "&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
</cfif>
<cfif isdate(attributes.finish_date_2)>
	<cfset url_str = url_str & "&finish_date_2=#dateformat(attributes.finish_date_2,dateformat_style)#">
</cfif>
<cfif isDefined('attributes.oby') and len(attributes.oby)>
	<cfset url_str = "#url_str#&oby=#attributes.oby#">
</cfif>
<cfif isDefined('attributes.short_code_id') and len(attributes.short_code_id)>
	<cfset url_str = '#url_str#&short_code_id=#attributes.short_code_id#'>
</cfif>
<cfif isDefined('attributes.short_code_name') and len(attributes.short_code_name)>
	<cfset url_str = '#url_str#&short_code_name=#attributes.short_code_name#'>
</cfif>
<cfif len(attributes.position_code) and len(attributes.position_name)>
	<cfset url_str = "#url_str#&position_code=#attributes.position_code#&position_name=#attributes.position_name#">
</cfif>
<cfif len(attributes.product_cat_code)>
	<cfset url_str="#url_str#&product_cat_code=#attributes.product_cat_code#">
</cfif>
<cfif len(attributes.product_catid)>
	<cfset url_str="#url_str#&product_catid=#attributes.product_catid#">
</cfif>
<cfif isDefined('attributes.project_id') and len(attributes.project_id)>
	<cfset url_str = '#url_str#&project_id=#attributes.project_id#'>
</cfif>
<cfif isDefined('attributes.project_head') and len(attributes.project_head)>
	<cfset url_str = '#url_str#&project_head=#attributes.project_head#'>
</cfif>
<cfif len(attributes.product_cat)>
	<cfset url_str="#url_str#&product_cat=#attributes.product_cat#">
</cfif>
<cfif isDefined('attributes.operation_type_id') and len(attributes.operation_type_id)>
	<cfset url_str = '#url_str#&operation_type_id=#attributes.operation_type_id#'>
</cfif>
<cfif isDefined('attributes.operation_type') and len(attributes.operation_type)>
	<cfset url_str = '#url_str#&operation_type=#attributes.operation_type#'>
</cfif>
<cfif isDefined('attributes.related_orders') and len(attributes.related_orders)>
	<cfset url_str = '#url_str#&related_orders=#attributes.related_orders#'>
</cfif>
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
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%textile.order%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>

	<cfset print_type_ = 281>
	<cfset colspan_info = 13>	
<cfsavecontent variable="header_">
        <cf_get_lang no='55.Üretim Emirleri'>
</cfsavecontent>
<!--- Yazdırmak istediğimiz zaman fuseaction'un başına autoexcelpopuppage ifadesi eklendiği için fuseaction_ is ifadeleri fuseaction_ contains şekline dönüştürüldü.. EY 20130212 --->
<cfif isdefined("is_show_demand_no") and is_show_demand_no eq 1>
	<cfset colspan_info = colspan_info+1>
</cfif>
<cfif isdefined("is_spec_code") and is_spec_code eq 1>
	<cfset colspan_info = colspan_info+1>
</cfif>
<cfif isdefined("is_spec_name") and is_spec_name eq 1>
	<cfset colspan_info = colspan_info+1>
</cfif>
<cfif isdefined("is_show_process") and is_show_process eq 1>
	<cfset colspan_info = colspan_info+1>
</cfif>
<cfif isdefined("is_show_result_amount") and is_show_result_amount eq 1>
	<cfset colspan_info = colspan_info+2>
</cfif>
<cfif isdefined("is_show_lot_no") and is_show_lot_no eq 1>
	<cfset colspan_info = colspan_info+1>
</cfif>
<cfif isdefined("is_show_order_no") and is_show_order_no eq 1>
	<cfset colspan_info = colspan_info+1>
</cfif>
<cfif isdefined("is_show_detail") and is_show_detail eq 1>
	<cfset colspan_info = colspan_info+1>
</cfif>
<cfif isdefined("is_show_project") and is_show_project eq 1>
	<cfset colspan_info = colspan_info+1>
</cfif>
<cfif isdefined("is_show_temp_date") and is_show_temp_date eq 1>
	<cfset colspan_info = colspan_info+2>
</cfif>
<cfif isdefined("is_show_member") and is_show_member eq 1>
	<cfset colspan_info = colspan_info+2>
</cfif>
<cfif fuseaction_ contains 'operations'>
	<cfset colspan_info = colspan_info+3>
</cfif>
<cfif isdefined("is_show_demand_no_") and is_show_demand_no_ eq 1>
	<cfset colspan_info = colspan_info+1>
</cfif>
	<cfform name="search_list" action="#request.self#?fuseaction=textile.#fuseaction_#" method="post">
		<input type="hidden" name="is_submitted" id="is_submitted" value="1">
		<input type="hidden" name="is_excel" id="is_excel" value="0">
		<cf_big_list_search title="#header_#">
			<cf_big_list_search_area>
				<cf_object_main_table>
					<cf_object_table column_width_list="60,80">
					<div class="row">
						<div class="col col-12 form-inline ">
							<div class="form-group">
								<div class="input-group x-15">
										<cfsavecontent variable="key_title"><cf_get_lang_main no='1677.Emir No'>,Operasyon No , <cf_get_lang_main no='799.Siparis No'> ve  <cf_get_lang no ='385.Lot No'>,<cf_get_lang_main no ='1372.Referans'>,<cf_get_lang_main no='245.Ürün'> Alanlarında Arama Yapabilirsiniz!</cfsavecontent>
									<cfset checked_list = "">
									<cfif isdefined("attributes.P_ORDER_NO1")>
										<cfset checked_list = listappend(checked_list,"P_ORDER_NO1")>
									</cfif>
									<cfif isdefined("attributes.DEMAND_NO1")>
										<cfset checked_list = listappend(checked_list,"DEMAND_NO1")>
									</cfif>
									<cfif isdefined("attributes.LOT_NO1")>
										<cfset checked_list = listappend(checked_list,"LOT_NO1")>
									</cfif>
									<cfif isdefined("attributes.REFERENCE_NO1")>
										<cfset checked_list = listappend(checked_list,"REFERENCE_NO1")>
									</cfif>
									<cfif isdefined("attributes.ORDER_NUMBER1")>
										<cfset checked_list = listappend(checked_list,"ORDER_NUMBER1")>
									</cfif>
									<cf_wrk_search_input name="keyword" id="keyword" title="#key_title#" style="width:80px;" check_column="#checked_list#" checkbox="Üretim Emri No,Operasyon No,Lot No,Referans No,Sipariş Numarası" columnlist="P_ORDER_NO1,DEMAND_NO1,LOT_NO1,REFERENCE_NO1,ORDER_NUMBER1" placeholder="#getLang('assetcare',48)#">
									<!---<cfinput type="text" name="keyword" id="keyword" title="#key_title#"  style="width:80px;">--->
								</div>
							</div>
							<div class="form-group">
								<cf_multiselect_check
								  name="opplist"
								  query_name="get_operation"
								  option_name="OPERATION_TYPE"
								  option_value="OPERATION_TYPE_ID"
								  option_text="Operasyon Seç"
								  value="#attributes.opplist#">
							  </div>
								<div class="form-group">
									<select name="prod_order_stage" id="prod_order_stage" style="width:100px;">
										<option value=""><cf_get_lang_main no='1447.Süreç'></option>
										<cfoutput query="get_process_type">
											<option value="#process_row_id#"<cfif isdefined('attributes.prod_order_stage') and attributes.prod_order_stage eq process_row_id>selected</cfif>>#stage#</option>
										</cfoutput>
									</select>
								</div>
							<!---<cfif (fuseaction_ contains 'demands') or (fuseaction_ contains 'order')>
								<div class="form-group">
									<select name="related_orders" id="related_orders" style="width:100px;">
										<option value="1" <cfif attributes.related_orders eq 1>selected</cfif>><cf_get_lang no='343.Emir'> <cf_get_lang_main no='1239.Türü'></option>
										<option value="2" <cfif attributes.related_orders eq 2>selected</cfif>>Üst Emirler</option>
										<option value="3" <cfif attributes.related_orders eq 3>selected</cfif>>Alt Emirler</option>
									</select>

								</div>
							</cfif>--->
						
							<div class="form-group">
								<select name="result" id="result" style="width:100px;">
									<option value=""><cf_get_lang_main no='1854.Üretim Sonucu'></option>
									<option value="1"<cfif attributes.result eq 1>selected</cfif>><cf_get_lang no ='587.Girilenler'></option>
									<option value="0"<cfif attributes.result eq 0>selected</cfif>><cf_get_lang no ='586.Girilmeyenler'></option>
								</select>
							</div>
						
							<div class="form-group">
								<select name="oby" id="oby" style="width:100px;">
									<option value="1" <cfif attributes.oby eq 1>selected</cfif>><cf_get_lang_main no='1661.Azalan No'></option>
									<option value="2" <cfif attributes.oby eq 2>selected</cfif>><cf_get_lang_main no='1662.Artan No'></option>
									<option value="3" <cfif attributes.oby eq 3>selected</cfif>><cf_get_lang_main no='514.Azalan Tarih'></option>
									<option value="4" <cfif attributes.oby eq 4>selected</cfif>><cf_get_lang_main no='513.Artan Tarih'></option>
								</select>
							</div>
							<div class="form-group">
								<select name="status" id="status" style="width:65px;">
									<option value="1" <cfif attributes.status eq 1>selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
									<option value="2" <cfif attributes.status eq 2>selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
									<option value="3" <cfif attributes.status eq 3>selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
								</select>
							</div>
							<div class="form-group">
								<div class="input-group x-3_5">
									<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,255" maxlength="3" style="width:25px;">
								</div>
							</div>
							<div class="form-group">
								<cf_wrk_search_button>
							</div>
							<div class="form-group">
								<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
							</div>
						</div>
					</div>
					</cf_object_table>
				</cf_object_main_table>
			</cf_big_list_search_area>
			<cf_big_list_search_detail_area>
				<cf_object_main_table>
						<div class="row" type="row">
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
							<cfif fuseaction_ contains 'demands' or fuseaction_ contains 'in_productions'> 
								<div class="form-group" id="item-member_name">
									<label class="col col-12"><cf_get_lang_main no ='107.Cari Hesap'></label>
									<div class="col col-12">
										<div class="input-group">
											<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id")><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
											<input type="hidden" name="company_id"  id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">
											<input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type")><cfoutput>#attributes.member_type#</cfoutput></cfif>">
											<input type="text" name="member_name"   id="member_name" style="width:110px;"  value="<cfif isdefined("attributes.member_name") and len(attributes.member_name)><cfoutput>#attributes.member_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','consumer_id,company_id,member_type','','3','250');" autocomplete="off">
											<span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_consumer=search_list.consumer_id&field_comp_id=search_list.company_id&field_member_name=search_list.member_name&field_type=search_list.member_type&select_list=7,8&keyword='+encodeURIComponent(document.search_list.member_name.value),'list');"></span>
										</div>
									</div>
								</div>
							  </cfif>
								<div class="form-group" id="item-product_cat">
									<label class="col col-12"><cf_get_lang_main no ='74.Kategori'></label>
									<div class="col col-12">
										<div class="input-group">
											<input type="hidden" name="product_cat_code" id="product_cat_code" value="<cfif len(attributes.product_cat)><cfoutput>#attributes.product_cat_code#</cfoutput></cfif>">
											<input type="hidden" name="product_catid" id="product_catid" value="<cfoutput>#attributes.product_catid#</cfoutput>">
											<cfinput type="text" name="product_cat" id="product_cat" style="width:110px;" value="#attributes.product_cat#" onFocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID','product_catid','','3','200');">
											<span class="input-group-addon icon-ellipsis btnPointer" title="Kategori Ekle" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&field_code=search_list.product_cat_code&is_sub_category=1&field_id=search_list.product_catid&field_name=search_list.product_cat','list');"></span>
										</div>
									</div>
								</div>
								<div class="form-group" id="item-position_name">
									<label class="col col-12"><cf_get_lang_main no='132.Sorumlu'></label>
									<div class="col col-12">
										<div class="input-group">
											<input type="hidden" name="position_code" id="position_code" value="<cfif len(attributes.position_code) and len(attributes.position_name)><cfoutput>#attributes.position_code#</cfoutput></cfif>">
											<input type="text" name="position_name" id="position_name" style="width:110px;" value="<cfif len(attributes.position_code) and len(attributes.position_name)><cfoutput>#attributes.position_name#</cfoutput></cfif>" maxlength="255" onfocus="AutoComplete_Create('position_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','position_code','','3','135');" autocomplete="off">
											<span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=search_list.position_code&field_name=search_list.position_name&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.search_list.position_name.value),'list');"></span>
										</div>
									</div>
								</div>
								<div class="form-group" id="item-order_employee">
									<label class="col col-12"><cf_get_lang no ='472.Satış Çalışanı'></label>
									<div class="col col-12">
										<div class="input-group">
											<input type="hidden" name="order_employee_id"  id="order_employee_id"value="<cfoutput>#attributes.order_employee_id#</cfoutput>">
											<input type="text"  name="order_employee"  id="order_employee"  style="width:110px;"  value="<cfoutput>#attributes.order_employee#</cfoutput>" onfocus="AutoComplete_Create('order_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','order_employee_id','','3','135')" autocomplete="off">
											<span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_list.order_employee_id&field_name=search_list.order_employee&select_list=1','list');"></span>
										</div>
									</div>
								</div>
								<div class="form-group" id="item-related_product_name">
									<label class="col col-12"><cf_get_lang no ='132.Hammadde'></label>
									<div class="col col-12">
										<div class="input-group">
											<input type="hidden" name="related_stock_id" id="related_stock_id" value="<cfoutput>#attributes.related_stock_id#</cfoutput>">
											<input type="hidden" name="related_product_id" id="related_product_id" value="<cfoutput>#attributes.related_product_id#</cfoutput>">
											<input type="text"   name="related_product_name"  id="related_product_name" style="width:110px;"  value="<cfoutput>#attributes.related_product_name#</cfoutput>" passthrough="readonly=yes" onfocus="AutoComplete_Create('related_product_name','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','PRODUCT_ID,STOCK_ID','related_product_id,related_stock_id','','3','225');" autocomplete="off">
											<span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="spect_remove();windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=search_list.related_stock_id&product_id=search_list.related_product_id&field_name=search_list.related_product_name&keyword='+encodeURIComponent(document.search_list.related_product_name.value),'list');"></span>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
								<div class="form-group" id="item-station_id">
									<label class="col col-12"><cf_get_lang_main no ='1676.İstasyonlar'></label>
									<div class="col col-12">
										<select name="station_id" id="station_id" style="width:170px;">
										  <option value=""><cf_get_lang no='58.Tüm İstasyonlar'></option>
										  <option value="0" <cfif attributes.station_id eq 0>selected</cfif>><cf_get_lang no='131.İstasyonu Boş Olanlar'></option>
										  <cfoutput query="get_w">
											  <option value="#station_id#"<cfif attributes.station_id eq station_id>selected</cfif>><cfif len(up_station)>&nbsp;&nbsp;</cfif>#station_name#</option>
										  </cfoutput>
										</select>
									</div>
								</div>
								<div class="form-group" id="item-project_id">
									<label class="col col-12"><cf_get_lang_main no='4.Proje'></label>
									<div class="col col-12">
										<cfif isdefined('attributes.project_head') and len(attributes.project_head)>
											<cfset project_id_ = #attributes.project_id#>
										<cfelse>
											<cfset project_id_ = ''>
										</cfif>
										<cf_wrkproject
											project_id="#project_id_#"
											width="110"
											agreementno="1" customer="2" employee="3" priority="4" stage="5"
											boxwidth="1000"
											boxheight="400">
									</div>
								</div>
								<div class="form-group" id="item-product_name">
									<label class="col col-12"><cf_get_lang_main no='245.Ürün'></label>
									<div class="col col-12">
										<div class="input-group">
											<input type="hidden" name="stock_id" id="stock_id" value="<cfoutput>#attributes.stock_id#</cfoutput>">
											<input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.product_id#</cfoutput>">
											<input type="text"   name="product_name"  id="product_name" style="width:110px;"  value="<cfoutput>#attributes.product_name#</cfoutput>" passthrough="readonly=yes" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE,','get_product_autocomplete','0','PRODUCT_ID,STOCK_ID','product_id,stock_id','','3','225');" autocomplete="off">
											<span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="spect_remove();windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=search_list.stock_id&product_id=search_list.product_id&field_name=search_list.product_name&keyword='+encodeURIComponent(document.search_list.product_name.value),'list');"></span>
										</div>
									</div>
								</div>
								<div class="form-group" id="item-spect_name">
									<label class="col col-12"><cf_get_lang_main no='235.Spec'></label>
									<div class="col col-12">
										<div class="input-group">
											<input type="hidden" name="spect_main_id" id="spect_main_id" value="<cfoutput>#attributes.spect_main_id#</cfoutput>">
											<input type="text" name="spect_name" id="spect_name" value="<cfoutput>#attributes.spect_name#</cfoutput>" style="width:110px;">
											<span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="product_control();"></span>
										</div>
									</div>
								</div>
								<div class="form-group" id="item-short_code_id">
									<label class="col col-12"><cf_get_lang_main no ='813.Model'></label>
									<div class="col col-12">
										
											<cf_wrkproductmodel
												returninputvalue="short_code_id,short_code_name"
												returnqueryvalue="MODEL_ID,MODEL_NAME"
												width="110"
												fieldname="short_code_name"
												fieldid="short_code_id"
												compenent_name="getProductModel"            
												boxwidth="300"
												boxheight="150"                        
												model_id="#attributes.short_code_id#">
											
									</div>
								</div>
							</div>
						
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
								<div class="form-group" id="item-start_date">
									<label class="col col-12"><cf_get_lang_main no='641.Başlangıç Tarihi'></label>
									<div class="col col-12">
										<div class="input-group">
											<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
												<cfinput type="text" name="start_date" maxlength="10" validate="#validate_style#" style="width:80px;" value="#dateformat(attributes.start_date,dateformat_style)#">
											<cfelse>
												<cfsavecontent variable="message"><cf_get_lang_main no='1333.Başlama Tarihi Girmelisiniz'> !</cfsavecontent>
												<cfinput required="Yes" message="#message#" type="text" name="start_date" maxlength="10" validate="#validate_style#" style="width:80px;" value="#dateformat(attributes.start_date,dateformat_style)#">
										  </cfif>
											<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
											<span class="input-group-addon no-bg"></span>
											<cfinput type="text" name="start_date_2" value="#dateformat(attributes.start_date_2,dateformat_style)#" validate="#validate_style#" style="width:80px;">
											<span class="input-group-addon"><cf_wrk_date_image date_field="start_date_2"></span>
										</div>
									</div>
								</div>
								<div class="form-group" id="item-finish_date">
									<label class="col col-12"><cf_get_lang_main no='288.Bitiş Tarihi'></label>
									<div class="col col-12">
										<div class="input-group">
											<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
												<cfinput type="text" name="finish_date" maxlength="10" value="#dateformat(attributes.finish_date,dateformat_style)#"  validate="#validate_style#" style="width:80px;">
											<cfelse>
												<cfsavecontent variable="message"><cf_get_lang_main no='327.Bitiş Tarihi girmelisiniz'></cfsavecontent>
												<cfinput required="Yes" message="#message#" type="text" name="finish_date" maxlength="10" value="#dateformat(attributes.finish_date,dateformat_style)#"  validate="#validate_style#" style="width:80px;">
											</cfif>
											<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
											<span class="input-group-addon no-bg"></span>
											<cfinput type="text" name="finish_date_2" value="#dateformat(attributes.finish_date_2,dateformat_style)#" validate="#validate_style#" style="width:80px;">
											<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date_2"></span>
										</div>
									</div>
								</div>			
							</div>
						</div>
						
																		 
				</cf_object_main_table>
			</cf_big_list_search_detail_area>
		</cf_big_list_search>
	</cfform>
<cf_big_list>
	<thead>
		<tr>		
			<cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
				<!-- sil -->
				<th style="width:1%;"></th>
				<!-- sil -->
				
			</cfif>
			<th>Üretim Emri No</th>
			<th>Operasyon</th>
			<th><cf_get_lang_main no='799.Siparis No'></th>
			<th >Firma</th>
			<th>Proje</th>
			<th>Ürün Kodu</th>
			<th>Ürün Özel Kodu</th>
			<th>Ürün</th>
			<th>Müşteri Order No</th>
			<th>Müşteri Model No</th>
			<th>Planlanan <cf_get_lang_main no='223.Miktar'></th>
			<th>Üretimdeki <cf_get_lang_main no='223.Miktar'></th>
			<th>Üretilen</th>
			<th>Kalan Miktar</th>
			<th><cf_get_lang_main no='1447.Süreç'></th>
			<th>Termin Tarihi</th>
			<th>Üretim Başlangıç </th>
			<th>Üretim Bitiş </th>
			<th> </th>			
		</tr>
	</thead>
	
	<tbody>
		<cfif len(attributes.is_submitted)>
			<cfif get_po_det.recordcount>
				<cfset prod_order_stage_list = ''>
				<cfset stock_id_list =''>
				<cfset p_order_id_list =''>
				<cfset operation_type_id_list =''>
				<cfset action_employee_id_list =''>
				<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
					<cfset attributes.startrow=1>
					<cfset attributes.maxrows=get_po_det.recordcount>
				</cfif>
				<cfoutput query="get_po_det" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfif len(party_id) and not listfind(p_order_id_list,party_id)>
						<cfset p_order_id_list=listappend(p_order_id_list,party_id)>
					</cfif>
					<cfif len(prod_order_stage) and not listfind(prod_order_stage_list,prod_order_stage)>
						<cfset prod_order_stage_list=listappend(prod_order_stage_list,prod_order_stage)>
					</cfif>
					<cfif fuseaction_ is 'demands'>
						<cfif len(STOCK_ID) and not listfind(stock_id_list,STOCK_ID)>
							<cfset stock_id_list=listappend(stock_id_list,STOCK_ID)>
						</cfif>
					</cfif>
					<cfif fuseaction_ is 'operations'>
						<cfif len(operation_type_id) and not listfind(operation_type_id_list,operation_type_id)>
							<cfset operation_type_id_list=listappend(operation_type_id_list,operation_type_id)>
						</cfif>
						<cfif attributes.result eq 1>
							<cfif len(action_employee_id) and not listfind(action_employee_id_list,action_employee_id)>
								<cfset action_employee_id_list=listappend(action_employee_id_list,action_employee_id)>
							</cfif>
						</cfif>
					</cfif>
				</cfoutput>

			
			
				<form name="go_p_order_list" method="post" action="<cfoutput>#request.self#?</cfoutput>fuseaction=prod.order">
					<input type="hidden" name="keyword" id="keyword" value=""><!--- Üretim Emirlerin Listesine Giderken Doldurulur.. --->
					<input type="hidden" name="production_order_no" id="production_order_no" value=""><!--- Üretim Malzeme İhtiyaçlarına Giderken doldurulur.. --->
					<input type="hidden" name="is_submitted" value="1">
					<input type="hidden" name="start_date" value="">
					<input type="hidden" name="finish_date" value="">
					<input type="hidden" name="row_demand_all" value="<cfoutput query="get_po_det">#PARTY_ID#<cfif currentrow neq recordcount>,</cfif></cfoutput>">
				</form>
				<form name="convert_demand_to_production" method="post" action="<cfoutput>#request.self#?</cfoutput>fuseaction=prod.emptypopup_convert_demand_to_production_tex">
					<input type="hidden" name="is_upd_related_demands" value="<cfif isdefined("is_upd_related_demands")><cfoutput>#is_upd_related_demands#</cfoutput><cfelse>0</cfif>"><!--- İlişkili taleplerin güncellenip güncellenmeyeceğini tutuyor arka sayfada kullanılıyor --->
					<cfif fuseaction_ is 'operations'>
						<input type="hidden" name="operation_id_list" id="operation_id_list" value="">
						<input type="hidden" name="employee_id_list" id="employee_id_list" value="">
						<input type="hidden" name="p_order_id_list" id="p_order_id_list" value="">
						<input type="hidden" name="amount_list" id="amount_list" value="">
						<input type="hidden" name="station_id_list" id="station_id_list" value="">
						<input type="hidden" name="operation_result_id_list" id="operation_result_id_list" value="">
						<cfif attributes.result eq 1>
							<input type="hidden" name="result" id="result" value="1">
						<cfelse>
							<input type="hidden" name="result" id="result" value="0">
						</cfif>
					</cfif>
				
					<cfset toplamadet=0>
					<cfset toplamhedefmaliyet=0>
					<cfset toplamtutar=0>
					<cfset fark=0>
					<cfset toplam_miktar=0>
					<cfset toplam_uretilen=0>
					<cfset toplam_kalan=0>		
					<cfset toplam_maliyet=0>
					<cfset toplam_maliyet_top=0>
					
					<cfoutput query="get_po_det" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
										
						<cfset toplamadet=toplamadet+0>			
					
						<cfset fark=0>
						
						<tr>
							<cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
								<td align="center" id="order_row#currentrow#" class="color-row" onClick="gizle_goster(order_stocks_color_detail#currentrow#);connectAjaxDetail('#currentrow#','#PRODUCT_ID#','','','','','#ORDER_ID#','','#PARTY_ID#');gizle_goster(siparis_goster#currentrow#);gizle_goster(siparis_gizle#currentrow#);">
										<i id="siparis_goster#currentrow#" class="fa fa-chevron-circle-right fa-2x"  style="cursor:pointer;" title="<cf_get_lang_main no ='1184.Göster'>"></i>
										<i id="siparis_gizle#currentrow#" class="fa fa-chevron-circle-down fa-2x" style="cursor:pointer;display:none;"  title="<cf_get_lang_main no ='1216.Gizle'>"></i>
								</td>
							</cfif>
							<td>
									<cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
										<a class="tableyazi" href="#request.self#?fuseaction=textile.order&event=upd&party_id=#party_id#">
											#party_no#
										</a>
									<cfelse>
										#party_no#
									</cfif>
							</td>
							<td>#operation_type#</td>
							<td>#ORDER_NUMBER#</td>
							<td>#FULLNAME#</td>
							<td>#project_head#</td>
							<td>#product_code#</td>
							<td>#PRODUCT_CODE_2#</td>
							<td width="200">
								<cfquery name="productcat" datasource="#dsn1#"> 
									SELECT 
										PRODUCT_CAT.PRODUCT_CAT
									FROM 
										PRODUCT_CAT,
										PRODUCT
									WHERE
										PRODUCT.PRODUCT_CATID=PRODUCT_CAT.PRODUCT_CATID AND
										PRODUCT.PRODUCT_ID = #product_id#
								</cfquery>
								<cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
									<a href="#request.self#?fuseaction=product.list_product&event=det&pid=#product_id#" class="tableyazi">
											#product_name# #productcat.product_cat#
									</a>
								<cfelse>
												#product_name# #productcat.product_cat#
								</cfif>
							</td>
							<td>#company_order_no#</td>
							<td>#company_model_no#</td>
							<td align="right" style="text-align:right;">
								#operation_amount#
							</td>
							<td align="right" style="text-align:right;">
								#production_order_amount-result_amount#
							</td>
							<td align="right" style="text-align:right;">
								#result_amount#
							</td>
							<td align="right" style="text-align:right;">
								#operation_amount-result_amount#
							</td>
							<td></td>
							<td>#dateformat(deliverdate,'dd/mm/yyyy')#</td>
							<td>#dateformat(party_startdate,'dd/mm/yyyy')#</td>
							<td>#dateformat(party_finishdate,'dd/mm/yyyy')#</td>
							<td>
								<a href="#request.self#?fuseaction=textile.order&event=upd&party_id=#party_id#"><i class="fa fa-edit fa-2x" title="Güncelle"></i></a>
							</td>
						</tr>
						<cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
							<tr id="order_stocks_detail#currentrow#"   class="nohover" style="display:none" >
								<td colspan="#colspan_info#">
									<div align="left" id="DISPLAY_ORDER_STOCK_INFO#currentrow#" style="border:none;"></div>
								</td>
							</tr>
							<tr id="order_stocks_color_detail#currentrow#" style="display:none;" class="nohover">
								<td colspan="#colspan_info#"> 
									<div align="left" id="DISPLAY_ORDER_STOCK_COLOR_DETAIL#currentrow#" style="border:none;"></div>
								</td>
							</tr>
							</cfif>
					</cfoutput>
					
	</tbody>
	<cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
		<!-- sil -->
		<!---<tfoot>
			<tr height="40" class="nohover">			
				<td colspan="<cfoutput>#colspan_info#</cfoutput>" align="right" style="text-align:right;">
					<input type="button" value="<cf_get_lang_main no ='446.Excel Getir'>" name="excelll" onClick="convert_to_excel();">
					<cfif fuseaction_ is not 'operations'>
						<input type="button" value="<cf_get_lang no ='502.Grupla'>" style="display:none;" onClick="demand_convert_to_production(2);">
						<input type="button" value="<cf_get_lang no ='210.Malzeme İhtiyaç Listesi'>"  onClick="demand_convert_to_production(3);">
						<input type="button" id="tumune_ihtiyac_button" value="<cf_get_lang no ='211.Tümüne Malzeme İhtiyaç Listesi'>" onClick="demand_convert_to_production(4);">
						<cfif (fuseaction_ is 'demands' or (fuseaction_ is 'order' and attributes.result eq 0)) and not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
							<cf_workcube_process is_upd='0' process_cat_width='140' is_detail='0'>
						</cfif>
						<cfif fuseaction_ is 'order' and attributes.result eq 0 and not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
							<input type="button" value="<cf_get_lang no='682.Seçili Emirleri Güncelle'>"  onClick="demand_convert_to_production(5);">
						</cfif>
						<cfif fuseaction_ is 'demands'>
							<input type="button" name="updDemandValues_" value="<cf_get_lang no ='217.Seçili Talepleri Güncelle'>" onClick="demand_convert_to_production(1);">
							<input type="button" name="delDemandValues_" value="<cf_get_lang no ='683.Seçili Talepleri Sil'>" onClick="demand_convert_to_production(6);">
							<input type="button" name="convert_to_production_" value="<cf_get_lang no ='334.Üretime Çevir'>" onClick="demand_convert_to_production(0);">
						</cfif>
					</cfif>
					<cfif fuseaction_ is 'operations' and attributes.result eq 0>
						<input type="button" name="convert_to_production_" value="Seçili Operasyonları Sonlandır" onClick="demand_convert_to_production(7);">
					<cfelseif fuseaction_ is 'operations' and attributes.result eq 1>
						<input type="button" name="convert_to_production_" value="Seçili Operasyonları Güncelle" onClick="demand_convert_to_production(7);">
					</cfif>
					<input type="hidden" name="process_type" id="process_type" value=""><!--- process type query sayfasında 0 ise talepler üretime çevirili 1 ise sadece bilgileri güncellenir.. --->
					<input type="hidden" name="p_order_id_list" id="p_order_id_list" value="">
					<div id="user_message_demand"></div>
				</td>
			</tr>				
		</tfoot>--->
		<!-- sil -->
	</cfif>
				</form>
	<tbody>
		<script type="text/javascript">
			function demand_convert_to_production(type)
			{
				if(type==4)// type 4 ise
				{
					document.getElementById("tumune_ihtiyac_button").value='<cfoutput>#lang_array_main.item[293]#</cfoutput>';
					document.getElementById("tumune_ihtiyac_button").disabled = true;
					window.go_p_order_list.action = "<cfoutput>#request.self#</cfoutput>?fuseaction=prod.list_materials_total";
					document.go_p_order_list.submit();
				}
							else// type 4 degilse
							{
								var is_selected=0;
								if(document.getElementsByName('row_demand').length > 0){
									var p_order_id_list="";
									var currntrow_list="";
									if(document.getElementsByName('row_demand').length ==1){
										if(document.getElementById('row_demand').checked==true){
											is_selected=1;
											p_order_id_list+=list_getat(document.convert_demand_to_production.row_demand.value,1,';')+',';
											currntrow_list+=list_getat(document.convert_demand_to_production.row_demand.value,2,';')+',';
										}
									}	
									else{
										for (i=0;i<document.getElementsByName('row_demand').length;i++){
												if(document.convert_demand_to_production.row_demand[i].checked==true){ 
													p_order_id_list+=list_getat(document.convert_demand_to_production.row_demand[i].value,1,';')+',';
													currntrow_list+=list_getat(document.convert_demand_to_production.row_demand[i].value,2,';')+',';
													is_selected=1;
												}
										}		
									}
									if(is_selected==1){
										if(list_len(p_order_id_list,',') > 1)
											{
											p_order_id_list = p_order_id_list.substr(0,p_order_id_list.length-1);	
											document.getElementById('p_order_id_list').value=p_order_id_list;
											if(type==2)//gruplanmak isteniyor.
											{
												<cfoutput>
												AjaxPageLoad('#request.self#?fuseaction=prod.popup_ajax_production_orders_groups&station_id='+document.getElementById('station_id').value+'&p_order_id_list='+document.getElementById('p_order_id_list').value+'','groups_p',1)
												</cfoutput>
											}
											else
											{							
												if(type==3)
													user_message='<cf_get_lang no ="251.Malzeme İhtiyaç Listesine Yönlendiriliyorsunuz Lütfen Bekleyiniz">!';
												else if(type==1)
												{
													var selected_process_ = document.convert_demand_to_production.process_stage.value;
													if(selected_process_=='')
													{
														alert("<cf_get_lang no ='252.Süreç Seçmelisiniz'>!");
														return false;
													}
													user_message='<cf_get_lang no ="264.Talepler Güncelleniyor Lütfen Bekleyiniz">!';
												}
												else if(type==5)
												{
													var selected_process_ = document.convert_demand_to_production.process_stage.value;
													if(selected_process_=='')
													{
														alert("<cf_get_lang no ='252.Süreç Seçmelisiniz'>!");
														return false;
													}
													user_message='<cf_get_lang no="678.Emirler Güncelleniyor Lütfen Bekleyiniz"> !';
												}
												else if(type==6)
												{
													var selected_process_ = document.convert_demand_to_production.process_stage.value;
													if(selected_process_=='')
													{
														alert("<cf_get_lang no ='252.Süreç Seçmelisiniz'>!");
														return false;
													}
													user_message='<cf_get_lang no="679.Talepler Siliniyor Lütfen Bekleyiniz"> !';
												}
												else if(type == 7)
												{
													var employee_id_list_ = "";
													var station_id_list_ = "";
													var operation_type_id_list_ = "";
													var operation_amount_list_ = "";
													var operation_result_id_list_ = "";
													for(crt=1;crt<list_len(currntrow_list);crt++)
													{
														var crtrow = list_getat(currntrow_list,crt,',');
														if(document.getElementById('station_id_'+crtrow).value == '')
														{
															alert(crtrow +'. Satırda İstasyon Eksik. Lütfen İstasyon Seçiniz.');
															return false;
														}
														if(document.getElementById('operation_amount_'+crtrow).value == '')
														{
															alert(crtrow +'. Satırda Miktar Eksik. Lütfen Miktar Seçiniz.');
															return false;
														}
														if(document.getElementById('operation_amount_'+crtrow).value > document.getElementById('operation_amount__'+crtrow).value)
														{
															alert(crtrow +'. Satırda Operasyon Miktarı Kalan Miktardan Fazla.');
															return false;
														}
														if(document.getElementById('employee_id_'+crtrow).value == '')
														{
															alert(crtrow +'. Satırda İşlemi Yapan Eksik. Lütfen İşlemi Yapanı Seçiniz.');
															return false;
														}
														employee_id_list_+=document.getElementById('employee_id_'+crtrow).value+';';
														station_id_list_+=document.getElementById('station_id_'+crtrow).value+';';
														operation_type_id_list_+=document.getElementById('operation_type_id_'+crtrow).value+';';
														operation_amount_list_+=document.getElementById('operation_amount_'+crtrow).value+';';
														<cfif attributes.result eq 1>//sadece üretim sonucu girilenlerde gelsin. güncelleme yapabilmek için.
															operation_result_id_list_+=document.getElementById('operation_result_id_'+crtrow).value+';';
														</cfif>
													}
													document.getElementById('p_order_id_list').value = p_order_id_list ;
													document.getElementById('operation_id_list').value = operation_type_id_list_ ;
													document.getElementById('employee_id_list').value = employee_id_list_ ;
													document.getElementById('station_id_list').value = station_id_list_ ;
													document.getElementById('amount_list').value = operation_amount_list_ ;
													<cfif attributes.result eq 1>	
														document.getElementById('operation_result_id_list').value = operation_result_id_list_ ;
														user_message='Operasyon Sonuçları Güncelleniyor Lütfen Bekleyiniz!';
													<cfelseif attributes.result eq 0>
														user_message='Operasyon Sonuçları Ekleniyor Lütfen Bekleyiniz!';
													</cfif>
												}
												else if(type==0)
													user_message='<cf_get_lang no ="265.Talepler Üretime Çeviriliyor Lütfen Bekleyiniz">!';
													
												document.getElementById('process_type').value=type;
												windowopen('','small','p_action_window');
												convert_demand_to_production.target = 'p_action_window';
												convert_demand_to_production.submit();
												//AjaxFormSubmit(convert_demand_to_production,'user_message_demand',1,user_message,'<cf_get_lang_main no ="1374.Tamamlandı">!','','',1);
											}
											
										}
									}
									else{
										if(type==0)
											alert("<cf_get_lang no ='266.Üretime Göndermek İçin Talep Seçiniz'>");
										else if(type==1)
											alert("<cf_get_lang no ='267.Güncellenecek Talepleri Seçiniz'>!");
										else if(type==5)
											alert("<cf_get_lang no='680.Güncellenecek Emirleri Seçiniz'>!");
										else if(type==6)
											alert("<cf_get_lang no='681.Silinecek Talepleri Seçiniz'>!");
										else if(type==2)
											alert("<cf_get_lang no ='268.Gruplanacak Satırları Seçiniz'>!");
										else if(type==3)
											alert("<cf_get_lang no ='269.Malzeme İhtiyaçları İçin Talep Seçiniz'>!");
										else if(type==7)
											alert("Sonlandırılacak Operasyonları Seçiniz!");
										return false;
									}
								}
						}// type 4 degilse	
					}	
				</script>
			<cfelse>
				<tr>
					<td colspan="<cfoutput>#colspan_info#</cfoutput>"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
				</tr>
			</cfif>
		<cfelse>
			<tr>
				<td colspan="<cfoutput>#colspan_info#</cfoutput>"><cf_get_lang_main no ='289.Filtre Ediniz'> !</td>
			</tr>
		</cfif>
	</tbody>
</cf_big_list>
<cfif attributes.totalrecords gt attributes.maxrows>
	<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
		<tr>
			<td>
				<cf_pages 
					page="#attributes.page#" 
					maxrows="#attributes.maxrows#" 
					totalrecords="#get_po_det.recordcount#" 
					startrow="#attributes.startrow#" 
					adres="prod.#fuseaction_##url_str#">
			</td>
			<!-- sil -->
			<td align="right" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords# &nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
			<!-- sil -->
		</tr>
	</table>
</cfif>
<table width="100%" align="center" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td><div id="groups_p"></div></td>
	</tr>
</table>
<script type="text/javascript">
document.getElementById('keyword').focus();
 <cfif (fuseaction_ is 'demands' or  fuseaction_ is 'order') and is_show_multi_print eq 1>
	function send_services_print()
	{	
	<cfif len(attributes.is_submitted)>
			<cfif not get_po_det.recordcount>
				alert("<cf_get_lang no ='273.Yazdırılacak Belge  Bulunamadı Toplu Print Yapamazsınız'>!");
				return false;
			</cfif>
			<cfif get_po_det.recordcount eq 1>
				if(document.convert_demand_to_production.row_demand.checked == false)
				{
					alert("<cf_get_lang no ='273.Yazdırılacak Belge  Bulunamadı Toplu Print Yapamazsınız'>!");
					return false;
				}
				else
					service_list_ = list_getat(document.convert_demand_to_production.row_demand.value,1,';');
			</cfif>
			<cfif get_po_det.recordcount gt 1>
				service_list_ = "";
				for (i=0; i < document.convert_demand_to_production.row_demand.length; i++)
				{
					if(document.convert_demand_to_production.row_demand[i].checked == true)
						{
						service_list_ = service_list_ + list_getat(document.convert_demand_to_production.row_demand[i].value,1,';') + ',';
						}	
				}
				if(service_list_.length == 0)
				{
					alert("<cf_get_lang no ='273.Yazdırılacak Belge  Bulunamadı Toplu Print Yapamazsınız'>!");
					return false;
				}
			</cfif>
			windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&print_type=#print_type_#</cfoutput>&iid='+service_list_,'page');
		<cfelse>
			alert("<cf_get_lang no ='273.Yazdırılacak Belge  Bulunamadı Toplu Print Yapamazsınız'>!");
			return false;
		</cfif>
	}
</cfif>
	function sonucekle(party_id)
			{
				window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=textile.list_results&event=add&party_id='+party_id,'list');
			}

	function pencere_ac_employee(no)
	{
		//row_id_ = p_order_id+'_'+stock_id+'_'+no;
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=convert_demand_to_production.employee_id_' + no +'&field_name=convert_demand_to_production.employee_name_' + no +'&select_list=1,9','list');
	}
	
	function convert_to_excel()
	{
		document.search_list.is_excel.value = 1;
		search_list.action='<cfoutput>#request.self#?fuseaction=prod.emptypopup_#fuseaction_#</cfoutput>';
		search_list.submit();
		document.search_list.is_excel.value = 0;
		search_list.action='<cfoutput>#request.self#?fuseaction=prod.#fuseaction_#</cfoutput>';
		return true;
	}
	function change_date_info(type)
	{
		if(type == 1)//hedef başlangıç
		{
			if(document.getElementById('temp_hour').value == '' || document.getElementById('temp_hour').value > 23)
				document.getElementById('temp_hour').value = '00';
			if(document.getElementById('temp_min').value == '' || document.getElementById('temp_min').value > 59)
				document.getElementById('temp_min').value = '00';
			if(document.getElementById('temp_date').value!= '')
				for (i=0;i<document.getElementsByName('row_demand').length;i++)
				{
					new_row_number = parseInt(<cfoutput>#attributes.startrow#</cfoutput>+i);
					new_id = list_getat(document.convert_demand_to_production.row_demand[new_row_number-1].value,1,';');
					document.getElementById('production_start_date_'+new_id).value = document.getElementById('temp_date').value;
					document.getElementById('production_start_h_'+new_id).value = parseFloat(document.getElementById('temp_hour').value);
					document.getElementById('production_start_m_'+new_id).value = parseFloat(document.getElementById('temp_min').value);
				}
		}
		else//hedef bitiş
		{
			if(document.getElementById('temp_hour_2').value == '' || document.getElementById('temp_hour_2').value > 23)
				document.getElementById('temp_hour_2').value = '00';
			if(document.getElementById('temp_min_2').value == '' || document.getElementById('temp_min_2').value > 59)
				document.getElementById('temp_min_2').value = '00';
			if(document.getElementById('temp_date_2').value!= '')
				for (i=0;i<document.getElementsByName('row_demand').length;i++)
				{
					new_row_number = parseInt(<cfoutput>#attributes.startrow#</cfoutput>+i);
					new_id = list_getat(document.convert_demand_to_production.row_demand[new_row_number-1].value,1,';');
					document.getElementById('production_finish_date_'+new_id).value = document.getElementById('temp_date_2').value;
					document.getElementById('production_finish_h_'+new_id).value = parseFloat(document.getElementById('temp_hour_2').value);
					document.getElementById('production_finish_m_'+new_id).value = parseFloat(document.getElementById('temp_min_2').value);
				}
		}
	}
	function product_control()/*Ürün seçmeden spect seçemesin.*/
	{
		if(document.search_list.stock_id.value=="" || document.search_list.product_name.value=="" )
		{
		alert("<cf_get_lang no ='515.Spect Seçmek için öncelikle ürün seçmeniz gerekmektedir'>");
		return false;
		}
		else
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=search_list.spect_main_id&field_name=search_list.spect_name&is_display=1&stock_id='+document.search_list.stock_id.value,'list');
	}
	function spect_remove()/*Eğer ürün seçildikten sonra spect seçilmişse yeniden ürün seçerse ilgili spect'i kaldır.*/
	{
		document.search_list.spect_main_id.value = "";
		document.search_list.spect_name.value = "";	
	}
	function connectAjaxDetail(crtrow,prod_id,stock_id,order_amount,spect_main_id,renkid,orderid,lotno,party_id){
	var bb = '<cfoutput>#request.self#?fuseaction=textile.emptypopup_ajax_list_production_orders&deep_level_max=1&tree_stock_status=1</cfoutput>&pid='+prod_id+'&sid='+ stock_id+'&amount='+order_amount+'&spect_main_id='+spect_main_id+'&orderid='+orderid+'&renkid='+renkid+'&lot_no='+lotno+'&party_id='+party_id+'&row_number='+crtrow;
		AjaxPageLoad(bb,'DISPLAY_ORDER_STOCK_COLOR_DETAIL'+crtrow,1);
			
	}

	function operasyonlist(rid,oid,pid,lotno)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=prod.popup_prod_operasyon&renkid='+rid+'&order_id='+oid+'&product_id='+pid+'&lotno='+lotno,'list');
	}
	
</script>