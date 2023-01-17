<cfset fuseaction_ = ListGetAt(attributes.fuseaction,2,'.')>
<cfsetting showdebugoutput="yes">
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
<cfif isdefined('attributes.demand_no')><cfset attributes.keyword = attributes.demand_no><cfset attributes.is_submitted = 1></cfif>
<cfif isdefined("attributes.is_submitted") and len(attributes.is_submitted)>
	<cfscript>
		get_prod_order_action = createObject("component", "V16.production_plan.cfc.get_prod_order");
        get_prod_order_action.dsn3 = dsn3;
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
			station_list : '#IIf(IsDefined("station_list"),"station_list",DE(""))#'
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
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%prod.order%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery><!-- sil -->
<cfif fuseaction_ contains 'demands'><!--- Talep --->
	<cfset colspan_info = 12>
<cfelseif fuseaction_ contains 'order'><!--- Emir --->
	<cfset colspan_info = 15>	
<cfelse>
	<cfset colspan_info = 17>
</cfif>
<cfsavecontent variable="header_">
    <cfif fuseaction_ contains 'order'>
        <cf_get_lang dictionary_id='30804.Üretim Emirleri'>
    <cfelseif fuseaction_ contains 'demands'>
        <cf_get_lang dictionary_id='57527.Talepler'>
    <cfelseif fuseaction_ contains 'in_productions'>
        <cf_get_lang dictionary_id='58812.Üretimdekiler'>
    <cfelseif fuseaction_ contains 'operations'>
        <cf_get_lang dictionary_id='36376.Operasyonlar'>
    </cfif>
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
<cfif isdefined("is_show_deliver_day_") and is_show_deliver_day_>
	<cfset colspan_info = colspan_info + 1 />
</cfif><!-- sil -->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search_list" action="#request.self#?fuseaction=prod.#fuseaction_#" method="post">
            <input type="hidden" name="is_submitted" id="is_submitted" value="1">
            <input type="hidden" name="is_excel" id="is_excel" value="0">
            <cf_box_search>
                <div class="form-group">
                    <cfif fuseaction_ contains 'operations'>
                        <cfsavecontent variable="key_title"><cf_get_lang dictionary_id='29474.Emir No'> ,<cf_get_lang dictionary_id ='29419.Operasyon'> , <cf_get_lang dictionary_id='58211.Siparis No'> <cf_get_lang dictionary_id='57989.ve'>  <cf_get_lang dictionary_id ='36698.Lot No'>,<cf_get_lang dictionary_id ='58784.Referans'>,<cf_get_lang dictionary_id='60540.Ürün Alanlarında Arama Yapabilirsiniz'> !</cfsavecontent>
                    <cfelse>
                        <cfsavecontent variable="key_title"><cf_get_lang dictionary_id='36446.Talep No'>, <cf_get_lang dictionary_id='29474.Emir No'> , <cf_get_lang dictionary_id='58211.Siparis No'> <cf_get_lang dictionary_id='57989.ve'>  <cf_get_lang dictionary_id ='36698.Lot No'>,<cf_get_lang dictionary_id ='58784.Referans'>,<cf_get_lang dictionary_id='60540.Ürün Alanlarında Arama Yapabilirsiniz'> !</cfsavecontent>
                    </cfif>
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
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='47919.Sigortalar'></cfsavecontent>
                    <cf_wrk_search_input name="keyword" id="keyword" title="#key_title#" style="width:80px;" check_column="#checked_list#" checkbox="Üretim Emri No,Talep No,Lot No,Referans No,Sipariş Numarası" columnlist="P_ORDER_NO1,DEMAND_NO1,LOT_NO1,REFERENCE_NO1,ORDER_NUMBER1" placeholder="#message#">
                    <!---<cfinput type="text" name="keyword" id="keyword" title="#key_title#"  style="width:80px;">--->
                </div>
                <cfif fuseaction_ contains 'order' or fuseaction_ contains 'in_productions'>
                    <div class="form-group">
                        <select name="prod_order_stage" id="prod_order_stage">
                            <option value=""><cf_get_lang dictionary_id='58859.Süreç'></option>
                            <cfoutput query="get_process_type">
                                <option value="#process_row_id#"<cfif isdefined('attributes.prod_order_stage') and attributes.prod_order_stage eq process_row_id>selected</cfif>>#stage#</option>
                            </cfoutput>
                        </select>
                    </div>
                </cfif>
                <cfif (fuseaction_ contains 'demands') or (fuseaction_ contains 'order')>
                    <div class="form-group">
                        <select name="related_orders" id="related_orders" >
                            <option value="1" <cfif attributes.related_orders eq 1>selected</cfif>><cf_get_lang dictionary_id='36656.Emir'> <cf_get_lang dictionary_id='58651.Türü'></option>
                            <option value="2" <cfif attributes.related_orders eq 2>selected</cfif>><cf_get_lang dictionary_id='60541.Üst Emirler'></option>
                            <option value="3" <cfif attributes.related_orders eq 3>selected</cfif>><cf_get_lang dictionary_id='60542.Alt Emirler'></option>
                        </select>
                    </div>
                </cfif>
                <cfif fuseaction_ contains 'operations'>
                    <div class="form-group">
                        <select name="result" id="result"  title="<cf_get_lang dictionary_id='36452.Operasyon Sonucu'>">
                            <option value="1"<cfif attributes.result eq 1>selected</cfif>><cf_get_lang dictionary_id ='36900.Girilenler'></option>
                            <option value="0"<cfif attributes.result eq 0>selected</cfif>><cf_get_lang dictionary_id ='36899.Girilmeyenler'></option>
                        </select>
                    </div>
                <cfelse>
                <div class="form-group">
                    <select name="result" id="result">
                        <option value=""><cf_get_lang dictionary_id='29651.Üretim Sonucu'></option>
                        <option value="1"<cfif attributes.result eq 1>selected</cfif>><cf_get_lang dictionary_id ='36900.Girilenler'></option>
                        <option value="0"<cfif attributes.result eq 0>selected</cfif>><cf_get_lang dictionary_id ='36899.Girilmeyenler'></option>
                    </select>
                </div>
                </cfif>
                <div class="form-group">
                    <select name="oby" id="oby">
                        <option value="1" <cfif attributes.oby eq 1>selected</cfif>><cf_get_lang dictionary_id='29458.Azalan No'></option>
                        <option value="2" <cfif attributes.oby eq 2>selected</cfif>><cf_get_lang dictionary_id='29459.Artan No'></option>
                        <option value="3" <cfif attributes.oby eq 3>selected</cfif>><cf_get_lang dictionary_id='57926.Azalan Tarih'></option>
                        <option value="4" <cfif attributes.oby eq 4>selected</cfif>><cf_get_lang dictionary_id='57925.Artan Tarih'></option>
                    </select>
                </div>
                <div class="form-group">
                    <select name="status" id="status">
                        <option value="1" <cfif attributes.status eq 1>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                        <option value="2" <cfif attributes.status eq 2>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                        <option value="3" <cfif attributes.status eq 3>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                    </select>
                </div>
            
                <div class="form-group small">
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,255" maxlength="3" style="width:25px;">
                </div>
             
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
                <div class="form-group">
                    <cfif not fuseaction_ contains 'operations'>
                        <cfoutput>
                        <cfif fuseaction_ contains 'demands'>
                            <a class="ui-btn ui-btn-gray2" href="#request.self#?fuseaction=prod.demands&event=multi-add&is_demand=1&is_collacted=1">
                                <i class="fa fa-clone" title="<cf_get_lang dictionary_id='36531.Toplu Talep Ekle'>"></i>
                            </a>
                        <cfelse>
                            <a class="ui-btn ui-btn-gray2" href="#request.self#?fuseaction=prod.order&event=multi-add&is_collacted=1">
                                <i class="fa fa-clone" title="<cf_get_lang dictionary_id='36534.Toplu Üretim Emri Ekle'>"></i>
                            </a>
                        </cfif>
                        </cfoutput>
                    </cfif>
                </div>
            </cf_box_search>
            <cf_box_search_detail>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <cfif fuseaction_ contains 'demands' or fuseaction_ contains 'in_productions'> 
                        <div class="form-group" id="item-member_name">
                            <label class="col col-12"><cf_get_lang dictionary_id ='57519.Cari Hesap'></label>
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
                        <label class="col col-12"><cf_get_lang dictionary_id ='57486.Kategori'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="product_cat_code" id="product_cat_code" value="<cfif len(attributes.product_cat)><cfoutput>#attributes.product_cat_code#</cfoutput></cfif>">
                                <input type="hidden" name="product_catid" id="product_catid" value="<cfoutput>#attributes.product_catid#</cfoutput>">
                                <cfinput type="text" name="product_cat" id="product_cat" style="width:110px;" value="#attributes.product_cat#" onFocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID','product_catid','','3','200');">
                                <span class="input-group-addon icon-ellipsis btnPointer" title="Kategori Ekle" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&field_code=search_list.product_cat_code&is_sub_category=1&field_id=search_list.product_catid&field_name=search_list.product_cat');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-position_name">
                        <label class="col col-12"><cf_get_lang dictionary_id='57544.Sorumlu'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="position_code" id="position_code" value="<cfif len(attributes.position_code) and len(attributes.position_name)><cfoutput>#attributes.position_code#</cfoutput></cfif>">
                                <input type="text" name="position_name" id="position_name" style="width:110px;" value="<cfif len(attributes.position_code) and len(attributes.position_name)><cfoutput>#attributes.position_name#</cfoutput></cfif>" maxlength="255" onfocus="AutoComplete_Create('position_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','position_code','','3','135');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=search_list.position_code&field_name=search_list.position_name&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.search_list.position_name.value),'list');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-order_employee">
                        <label class="col col-12"><cf_get_lang dictionary_id ='36785.Satış Çalışanı'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="order_employee_id"  id="order_employee_id"value="<cfoutput>#attributes.order_employee_id#</cfoutput>">
                                <input type="text"  name="order_employee"  id="order_employee"  style="width:110px;"  value="<cfoutput>#attributes.order_employee#</cfoutput>" onfocus="AutoComplete_Create('order_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','order_employee_id','','3','135')" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_list.order_employee_id&field_name=search_list.order_employee&select_list=1','list');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-related_product_name">
                        <label class="col col-12"><cf_get_lang dictionary_id ='36445.Hammadde'></label>
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
                        <label class="col col-12"><cf_get_lang dictionary_id ='29473.İstasyonlar'></label>
                        <div class="col col-12">
                            <select name="station_id" id="station_id" style="width:170px;">
                                <option value=""><cf_get_lang dictionary_id='36371.Tüm İstasyonlar'></option>
                                <option value="0" <cfif attributes.station_id eq 0>selected</cfif>><cf_get_lang dictionary_id='36444.İstasyonu Boş Olanlar'></option>
                                <cfoutput query="get_w">
                                    <option value="#station_id#"<cfif attributes.station_id eq station_id>selected</cfif>><cfif len(up_station)>&nbsp;&nbsp;</cfif>#station_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-project_id">
                        <label class="col col-12"><cf_get_lang dictionary_id='57416.Proje'></label>
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
                        <label class="col col-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="stock_id" id="stock_id" value="<cfoutput>#attributes.stock_id#</cfoutput>">
                                <input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.product_id#</cfoutput>">
                                <input type="text"   name="product_name"  id="product_name"   value="<cfoutput>#attributes.product_name#</cfoutput>" passthrough="readonly=yes" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE,','get_product_autocomplete','0','PRODUCT_ID,STOCK_ID','product_id,stock_id','','3','225');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="spect_remove();windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=search_list.stock_id&product_id=search_list.product_id&field_name=search_list.product_name&keyword='+encodeURIComponent(document.search_list.product_name.value),'list');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-spect_name">
                        <label class="col col-12"><cf_get_lang dictionary_id='57647.Spec'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="spect_main_id" id="spect_main_id" value="<cfoutput>#attributes.spect_main_id#</cfoutput>">
                                <input type="text" name="spect_name" id="spect_name" value="<cfoutput>#attributes.spect_name#</cfoutput>" style="width:110px;">
                                <span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="product_control();"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-short_code_id">
                        <label class="col col-12"><cf_get_lang dictionary_id ='58225.Model'></label>
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
                <cfif isdefined("is_show_production_station") and is_show_production_station eq 1>
                    <cfif fuseaction_ contains 'order' or fuseaction_ contains 'in_productions'>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                            <div class="form-group" id="item-production_stage">
                                <label class="col col-12"><cf_get_lang dictionary_id='57756.Durum'></label>
                                <div class="col col-12">
                                    <cfif fuseaction_ contains 'order'>
                                        <select name="production_stage" id="production_stage" style="width:125px;height:65px" multiple="multiple">
                                            <option value="4" style="background-color:#00CCFF;font-size:12px;"<cfif isdefined("attributes.production_stage") and listfind(attributes.production_stage,'4')>selected</cfif>><cf_get_lang dictionary_id ='36583.Başlamadı'></option>
                                            <option value="0" style="background-color:#FFCC33;"<cfif isdefined("attributes.production_stage") and listfind(attributes.production_stage,'0')>selected</cfif>><cf_get_lang dictionary_id ='36891.Operatöre Gönderildi'></option>
                                            <option value="1" style="background-color:#00CC33;"<cfif isdefined("attributes.production_stage") and listfind(attributes.production_stage,'1')>selected</cfif>><cf_get_lang dictionary_id ='36890.Başladı'></option>
                                            <option value="3" style="background-color:#CCCCCC;"<cfif isdefined("attributes.production_stage") and listfind(attributes.production_stage,'3')>selected</cfif>><cf_get_lang dictionary_id ='36893.Üretim Durdu(Arıza)'></option>
                                            <option value="2" style="background-color:#FF0000;"<cfif isdefined("attributes.production_stage") and listfind(attributes.production_stage,'2')>selected</cfif>><cf_get_lang dictionary_id ='36584.Bitti'></option>
                                        </select>
                                    <cfelseif fuseaction_ contains 'in_productions'>
                                        <select name="production_stage" id="production_stage" style="width:125px;height:65px" multiple="multiple">
                                            <option value="1" style="background-color:#00CC33;"<cfif isdefined("attributes.production_stage") and listfind(attributes.production_stage,'1')>selected</cfif>><cf_get_lang dictionary_id ='36890.Başladı'></option>
                                            <option value="3" style="background-color:#CCCCCC;"<cfif isdefined("attributes.production_stage") and listfind(attributes.production_stage,'3')>selected</cfif>><cf_get_lang dictionary_id ='36893.Üretim Durdu(Arıza)'></option>
                                        </select>
                                    </cfif>
                                </div>
                            </div>
                        </div>
                    </cfif>
                </cfif>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                    <div class="form-group" id="item-start_date">
                        <label class="col col-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
                                    <cfinput type="text" name="start_date" maxlength="10" validate="#validate_style#" style="width:80px;" value="#dateformat(attributes.start_date,dateformat_style)#">
                                <cfelse>
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58745.Başlama Tarihi Girmelisiniz'> !</cfsavecontent>
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
                        <label class="col col-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
                                    <cfinput type="text" name="finish_date" maxlength="10" value="#dateformat(attributes.finish_date,dateformat_style)#"  validate="#validate_style#" style="width:80px;">
                                <cfelse>
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi girmelisiniz'></cfsavecontent>
                                    <cfinput required="Yes" message="#message#" type="text" name="finish_date" maxlength="10" value="#dateformat(attributes.finish_date,dateformat_style)#"  validate="#validate_style#" style="width:80px;">
                                </cfif>
                                <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                                <span class="input-group-addon no-bg"></span>
                                <cfinput type="text" name="finish_date_2" value="#dateformat(attributes.finish_date_2,dateformat_style)#" validate="#validate_style#" style="width:80px;">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date_2"></span>
                            </div>
                        </div>
                    </div>
                    <cfif fuseaction_ contains 'operations'>
                    <div class="form-group" id="item-member_name">
                        <label class="col col-12"><cf_get_lang dictionary_id='36376.Operasyonlar'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="operation_type_id" id="operation_type_id" value="<cfif isdefined("attributes.operation_type_id") and len(attributes.operation_type_id)><cfoutput>#attributes.operation_type_id#</cfoutput></cfif>" />
                                <input type="text" name="operation_type" id="operation_type" style="width:90px;" value="<cfif isdefined("attributes.operation_type") and len(attributes.operation_type) and len(attributes.operation_type_id)><cfoutput>#attributes.operation_type#</cfoutput></cfif>" />
                                <span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_operation_type&field_id=search_list.operation_type_id&field_name=search_list.operation_type&is_submitted=1&keyword='+encodeURIComponent(document.search_list.operation_type.value),'list');"></span>
                            </div>
                        </div>
                    </div>
                    </cfif>
                </div>
            </cf_box_search_detail>
        </cfform>
    </cf_box>
        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
            <cfset filename = "#createuuid()#">
            <cfheader name="Expires" value="#Now()#">
            <cfcontent type="application/vnd.msexcel;charset=utf-8">
            <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        </cfif>
    <cf_box title="#header_#" uidrop="1" hide_table_column="1">
        <form name="convert_demand_to_production" method="post" action="<cfoutput>#request.self#?</cfoutput>fuseaction=prod.emptypopup_convert_demand_to_production">
            <cf_grid_list>
                <thead>
                    <tr>
                        <cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                            <!-- sil -->
                            <th width="20"></th>
                            <!-- sil -->
                        </cfif>
                        <th><cfif fuseaction_ contains 'demands'><cf_get_lang dictionary_id='36446.Talep No'><cfelse><cf_get_lang dictionary_id='29474.Emir No'></cfif></th>
                        <cfif isdefined("is_show_demand_no") and is_show_demand_no eq 1>
                            <th width="30"><cf_get_lang dictionary_id='36446.Talep No'></th>
                        </cfif>
                        <cfif fuseaction_ contains 'demands' or  fuseaction_ contains 'order'>
                            <cfif isdefined("is_show_order_no") and is_show_order_no eq 1>
                                <th><cf_get_lang dictionary_id='58211.Siparis No'></th>
                            </cfif>
                            <cfif isdefined("is_show_lot_no") and is_show_lot_no eq 1>
                                <th><cf_get_lang dictionary_id ='36698.Lot No'></th>
                            </cfif>
                        <cfelse>
                            <th><cf_get_lang dictionary_id='58211.Siparis No'></th>
                            <th><cf_get_lang dictionary_id ='36698.Lot No'></th>
                        </cfif>
                        <th><cf_get_lang dictionary_id='57645.Teslim Tarihi'></th>
                        <cfif isdefined("is_show_deliver_day_") and is_show_deliver_day_>
                            <th><cf_get_lang dictionary_id='62064.Teslim Tarihine Kalan Gün'></th>
                        </cfif>
                        <cfif isdefined("is_show_demand_no_") and is_show_demand_no_ eq 1>
                            <th><cf_get_lang dictionary_id='43583.İç Talep No'></th>
                        </cfif>
                        <cfif isdefined("is_show_member") and is_show_member eq 1>
                            <th><cf_get_lang dictionary_id ='57519.Cari Hesap'></th>
                        </cfif>
                        <cfif fuseaction_ contains 'order'><th><cf_get_lang dictionary_id='40294.Satış Çalışanı'></th></cfif>
                        <cfif isdefined("is_show_detail") and is_show_detail eq 1>
                            <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                        </cfif>
                        <cfif isdefined("is_show_project") and is_show_project eq 1>
                            <th><cf_get_lang dictionary_id='57416.Proje'></th>
                        </cfif>
                        <cfif fuseaction_ contains 'demands'></cfif>
                            <th><cf_get_lang dictionary_id='58834.İstasyon'></th> 
                        <cfif fuseaction_ contains 'demands'></cfif>
                        <cfif fuseaction_ contains 'demands' or fuseaction_ contains 'order'>
                            <cfif is_show_process eq 1>         
                                <th><cf_get_lang dictionary_id='58859.Süreç'></th>
                            </cfif>
                        <cfelse>
                            <th><cf_get_lang dictionary_id='58859.Süreç'></th>
                        </cfif>
                        <cfif fuseaction_ contains 'operations'>
                            <th><cf_get_lang dictionary_id='29419.Operasyon'></th>
                            <th><cf_get_lang dictionary_id='60554.Operasyon Miktarı'></th>
                            <th style="width:100px;"><cf_get_lang dictionary_id='36765.İşlemi Yapan'></th>
                        </cfif>
                        <cfif fuseaction_ contains 'demands'>
                            <th><cf_get_lang dictionary_id ='57518.Stok Kod'></th>
                            <th><cf_get_lang dictionary_id='57657.Ürün'></th>
                            <cfif isdefined("is_spec_code") and is_spec_code eq 1>
                                <th><cf_get_lang dictionary_id='54850.Spec Id'></th>
                            </cfif>
                            <cfif isdefined("is_show_spec_no") and is_show_spec_no neq 0>
                                <th><cf_get_lang dictionary_id='57647.Spec'></th>
                            </cfif>
                            <th><cf_get_lang dictionary_id='57635.Miktar'></th>
                        <cfelse>
                            <th><cf_get_lang dictionary_id ='57518.Stok Kod'></th>
                            <th><cf_get_lang dictionary_id='57657.Ürün'></th>
                            <cfif isdefined("is_spec_code") and is_spec_code eq 1>
                                <th><cf_get_lang dictionary_id='54850.Spec Id'></th>
                            </cfif>
                            <cfif isdefined("is_show_spec_no") and is_show_spec_no neq 0>
                                <th><cf_get_lang dictionary_id='57647.Spec'></th>
                            </cfif>
                            <th><cf_get_lang dictionary_id='57635.Miktar'></th>
                            <cfif isdefined("is_show_result_amount") and is_show_result_amount eq 1>
                                <th><cf_get_lang dictionary_id='36608.Üretilen'></th>
                                <th><cf_get_lang dictionary_id='58444.Kalan'></th>
                            </cfif>
                        </cfif>
                        <!-- sil -->
                            <th><cf_get_lang dictionary_id='57636.Birim'></th>
                        <!-- sil -->
                        <cfif fuseaction_ contains 'demands'>
                            <cfif fuseaction_ contains 'autoexcelpopuppage'>
                                <cfif isdefined("is_show_temp_date") and is_show_temp_date eq 1>
                                    <th <cfif ((fuseaction_ contains 'demands' and not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)) or (fuseaction_ contains 'order' and attributes.result eq 0))>style="text-align:left;width:100px;"<cfelse>style="text-align:left;width:80px;"</cfif>>
                                        <cf_get_lang dictionary_id='36604.Hedef Başlangıç'>
                                    </th>
                                    <th <cfif ((fuseaction_ contains 'demands' and not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)) or (fuseaction_ contains 'order' and attributes.result eq 0))>style="text-align:left;width:100px;"<cfelse>style="text-align:left;width:80px;"</cfif>>
                                        <cf_get_lang dictionary_id='36606.Hedef Bitiş'>
                                    </th>
                                    <th width="30"><cf_get_lang dictionary_id='57635.Miktar'></th>
                                </cfif>
                            </cfif>
                            <!-- sil -->
                        </cfif>
                        <cfif fuseaction_ contains 'demands'>
                            <cfif isdefined("is_show_temp_date") and is_show_temp_date eq 1>
                                <th <cfif ((fuseaction_ contains 'demands' and not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)) or (fuseaction_ contains 'order' and attributes.result eq 0))>style="text-align:left;width:100px;"<cfelse>style="text-align:left;width:80px;"</cfif>>
                                    <cf_get_lang dictionary_id='36604.Hedef Başlangıç'>
                                    <cfif ((fuseaction_ contains 'demands' and not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)) or (fuseaction_ contains 'order' and attributes.result eq 0))><br/>
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lütfen Tarih Giriniz'> !</cfsavecontent>
                                        <input type="text" name="temp_date" id="temp_date" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>" style="width:70px;" class="box" onblur="change_date_info(1);" validate="#validate_style#" message="<cfoutput>#message#</cfoutput>">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58781.Lütfen Saat Giriniz'> !</cfsavecontent>
                                        <input type="text" name="temp_hour" id="temp_hour" value="00" style="width:30px;" class="box" onkeyup="isNumber(this);" onblur="change_date_info(1);" validate="integer" message="<cfoutput>#message#</cfoutput>">
                                        <input type="text" name="temp_min" id="temp_min" value="00" style="width:30px;" class="box" onkeyup="isNumber(this);" onblur="change_date_info(1);" validate="integer" message="<cfoutput>#message#</cfoutput>">
                                    </cfif>
                                </th>
                                <th <cfif ((fuseaction_ contains 'demands' and not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)) or (fuseaction_ contains 'order' and attributes.result eq 0))>style="text-align:left;width:100px;"<cfelse>style="text-align:left;width:80px;"</cfif>>
                                    <cf_get_lang dictionary_id='36606.Hedef Bitiş'>
                                    <cfif ((fuseaction_ contains 'demands' and not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)) or (fuseaction_ contains 'order' and attributes.result eq 0))><br/>
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lütfen Tarih Giriniz'> !</cfsavecontent>
                                        <input type="text" name="temp_date_2" id="temp_date_2" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>" style="width:70px;" class="box" onblur="change_date_info(2);" validate="#validate_style#" message="<cfoutput>#message#</cfoutput>">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58781.Lütfen Saat Giriniz'> !</cfsavecontent>
                                        <input type="text" name="temp_hour_2" id="temp_hour_2" value="00" style="width:30px;" class="box" onkeyup="isNumber(this);" onblur="change_date_info(2);" validate="integer" message="<cfoutput>#message#</cfoutput>">
                                        <input type="text" name="temp_min_2" id="temp_min_2" value="00" style="width:30px;" class="box" onkeyup="isNumber(this);" onblur="change_date_info(2);" validate="integer" message="<cfoutput>#message#</cfoutput>">
                                    </cfif>
                                </th>
                            </cfif>
                        <cfelse>
                            <th <cfif ((fuseaction_ contains 'demands' and not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)) or (fuseaction_ contains 'order' and attributes.result eq 0))>style="text-align:left;width:100px;"<cfelse>style="text-align:left;width:80px;"</cfif>>
                                <cf_get_lang dictionary_id='36604.Hedef Başlangıç'>
                                <cfif ((fuseaction_ contains 'demands' and not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)) or (fuseaction_ contains 'order' and attributes.result eq 0))><br/>
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lütfen Tarih Giriniz'> !</cfsavecontent>
                                    <input type="text" name="temp_date" id="temp_date" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>" style="width:70px;" class="box" onblur="change_date_info(1);" validate="#validate_style#" message="<cfoutput>#message#</cfoutput>">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58781.Lütfen Saat Giriniz'> !</cfsavecontent>
                                    <input type="text" name="temp_hour" id="temp_hour" value="00" style="width:30px;" class="box" onkeyup="isNumber(this);" onblur="change_date_info(1);" validate="integer" message="<cfoutput>#message#</cfoutput>">
                                    <input type="text" name="temp_min" id="temp_min" value="00" style="width:30px;" class="box" onkeyup="isNumber(this);" onblur="change_date_info(1);" validate="integer" message="<cfoutput>#message#</cfoutput>">
                                </cfif>
                            </th>
                            <th <cfif ((fuseaction_ contains 'demands' and not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)) or (fuseaction_ contains 'order' and attributes.result eq 0))>style="text-align:left;width:100px;"<cfelse>style="text-align:left;width:80px;"</cfif>>
                                <cf_get_lang dictionary_id='36606.Hedef Bitiş'>
                                <cfif ((fuseaction_ contains 'demands' and not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)) or (fuseaction_ contains 'order' and attributes.result eq 0))><br/>
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lütfen Tarih Giriniz'> !</cfsavecontent>
                                    <input type="text" name="temp_date_2" id="temp_date_2" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>" style="width:70px;" class="box" onblur="change_date_info(2);" validate="#validate_style#" message="<cfoutput>#message#</cfoutput>">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58781.Lütfen Saat Giriniz'> !</cfsavecontent>
                                    <input type="text" name="temp_hour_2" id="temp_hour_2" value="00" style="width:30px;" class="box" onkeyup="isNumber(this);" onblur="change_date_info(2);" validate="integer" message="<cfoutput>#message#</cfoutput>">
                                    <input type="text" name="temp_min_2" id="temp_min_2" value="00" style="width:30px;" class="box" onkeyup="isNumber(this);" onblur="change_date_info(2);" validate="integer" message="<cfoutput>#message#</cfoutput>">
                                </cfif>
                            </th>
                        </cfif>
                        <cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                            <cfif fuseaction_ neq 'demands'>
                                <th width="20"><cf_get_lang dictionary_id='57756.Durum'></th>
                            </cfif>
                            <th width="20">
                            <cfif (fuseaction_ contains 'demands' or  fuseaction_ contains 'order') and is_show_multi_print eq 1>
                                <cfoutput><a href="javascript://" onclick="send_services_print();"><i class="fa fa-print" title="<cf_get_lang dictionary_id='36535.Toplu Yazdır'>" alt="<cf_get_lang dictionary_id='36535.Toplu Yazdır'>"></i></a></cfoutput>
                            </cfif>
                            </th>
                            <th width="20">
                                <cfif not fuseaction_ contains 'operations'>
                                    <cfoutput>
                                    <cfif fuseaction_ contains 'demands'>
                                        <a href="#request.self#?fuseaction=prod.demands&event=add&is_demand=1">
                                            <i class="fa fa-plus" title="<cf_get_lang dictionary_id='36389.Talep Ekle'>" ></i>
                                        </a>
                                    <cfelse>
                                        <a href="#request.self#?fuseaction=prod.order&event=add">
                                            <i class="fa fa-plus" title="<cf_get_lang dictionary_id='36378.Üretim Emri Ekle'>" alt="<cf_get_lang dictionary_id='36378.Üretim Emri Ekle'>"></i>
                                        </a>
                                    </cfif>
                                    </cfoutput>
                                </cfif>
                            </th>
                            <th class="header_icn_none text-center">
                                <cfif get_po_det.recordcount>
                                    <input type="checkbox" name="allSelectDemand" id="allSelectDemand" onclick="wrk_select_all('allSelectDemand','row_demand');">                
                                </cfif>
                            </th>
                        </cfif>
                        <!-- sil -->
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
                            <cfset project_id_list =''>
                            <cfset company_id_list =''>
                            <cfset consumer_id_list =''>
                            <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                                <cfset attributes.startrow=1>
                                <cfset attributes.maxrows=get_po_det.recordcount>
                            </cfif>
                            <cfoutput query="get_po_det">
                                <cfif len(p_order_id) and not listfind(p_order_id_list,p_order_id)>
                                    <cfset p_order_id_list=listappend(p_order_id_list,p_order_id)>
                                </cfif>
                                <cfif len(prod_order_stage) and not listfind(prod_order_stage_list,prod_order_stage)>
                                    <cfset prod_order_stage_list=listappend(prod_order_stage_list,prod_order_stage)>
                                </cfif>
                                <cfif fuseaction_ contains 'demands'>
                                    <cfif len(STOCK_ID) and not listfind(stock_id_list,STOCK_ID)>
                                        <cfset stock_id_list=listappend(stock_id_list,STOCK_ID)>
                                    </cfif>
                                </cfif>
                                <cfif fuseaction_ contains 'operations'>
                                    <cfif len(operation_type_id) and not listfind(operation_type_id_list,operation_type_id)>
                                        <cfset operation_type_id_list=listappend(operation_type_id_list,operation_type_id)>
                                    </cfif>
                                    <cfif attributes.result eq 1>
                                        <cfif len(action_employee_id) and not listfind(action_employee_id_list,action_employee_id)>
                                            <cfset action_employee_id_list=listappend(action_employee_id_list,action_employee_id)>
                                        </cfif>
                                    </cfif>
                                </cfif>
                                <cfif len(project_id) and not listfind(project_id_list,project_id)>
                                    <cfset project_id_list=listappend(project_id_list,project_id)>
                                </cfif>
                                <cfif len(company_id) and not listfind(company_id_list,company_id)>
                                    <cfset company_id_list=listappend(company_id_list,company_id)>
                                </cfif>
                                <cfif len(consumer_id) and not listfind(consumer_id_list,consumer_id)>
                                    <cfset consumer_id_list=listappend(consumer_id_list,consumer_id)>
                                </cfif>
                            </cfoutput>
                            <cfquery name="GET_ROW" datasource="#dsn3#">
                                SELECT
                                    ORDER_NUMBER,
                                    PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID P_ORDER_ID
                                FROM
                                    PRODUCTION_ORDERS_ROW,
                                    ORDERS
                                WHERE
                                    PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID IN(#p_order_id_list#) AND
                                    PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID 
                            </cfquery>
                            <cfloop query="GET_ROW">
                                <cfif not isdefined('order_list_#p_order_id#')>
                                    <cfset 'order_list_#p_order_id#' = ORDER_NUMBER>
                                <cfelse>
                                    <cfset 'order_list_#p_order_id#' = listdeleteduplicates(ListAppend(Evaluate('order_list_#p_order_id#'),ORDER_NUMBER,','))>
                                </cfif>
                            </cfloop>
                            <cfif len(stock_id_list) and  fuseaction_ contains 'demands'>
                                <cfquery name="GET_STOCK_STATIONS" datasource="#DSN3#">
                                    SELECT
                                        WP.STOCK_ID,
                                        0 AS MAIN_STOCK_ID ,
                                        W.STATION_ID AS STATION_ID_ ,
                                        W.STATION_NAME,
                                        WP.OPERATION_TYPE_ID,
                                        ISNULL(WP.PRODUCTION_TIME,0) P_TIME
                                    FROM 
                                        WORKSTATIONS W,
                                        WORKSTATIONS_PRODUCTS WP
                                    WHERE
                                        W.STATION_ID = WP.WS_ID 
                                        AND WP.STOCK_ID IN (#stock_id_list#)
                                        AND WP.MAIN_STOCK_ID IS NULL
                                UNION ALL
                                    SELECT
                                        WP.STOCK_ID,
                                        WP.MAIN_STOCK_ID,
                                        W.STATION_ID AS STATION_ID_ ,
                                        W.STATION_NAME,
                                        WP.OPERATION_TYPE_ID,
                                        ISNULL(WP.PRODUCTION_TIME,0) P_TIME
                                    FROM 
                                        WORKSTATIONS W,
                                        WORKSTATIONS_PRODUCTS WP
                                    WHERE
                                        W.STATION_ID = WP.WS_ID 
                                        AND WP.MAIN_STOCK_ID IN (#stock_id_list#)
                                </cfquery>
                                <cfloop query="GET_STOCK_STATIONS">
                                    <cfif not isdefined('stock_defined_stations_list_#STOCK_ID#')>
                                        <cfset 'stock_defined_stations_list_#STOCK_ID#' = STATION_ID_>
                                    <cfelse>
                                        <cfset 'stock_defined_stations_list_#STOCK_ID#' = listdeleteduplicates(ListAppend(Evaluate('stock_defined_stations_list_#STOCK_ID#'),STATION_ID_,','))>
                                    </cfif>
                                </cfloop>
                            </cfif>
                            <cfif len(prod_order_stage_list)>
                                <cfset prod_order_stage_list=listsort(prod_order_stage_list,"numeric","ASC",",")>
                                <cfquery name="PROCESS_TYPE" datasource="#DSN#">
                                    SELECT
                                        STAGE,
                                        PROCESS_ROW_ID
                                    FROM
                                        PROCESS_TYPE_ROWS
                                    WHERE
                                        PROCESS_ROW_ID IN(#prod_order_stage_list#)
                                    ORDER BY
                                        PROCESS_ROW_ID
                                </cfquery>
                            </cfif>
                            <cfif fuseaction_ contains 'operations'>
                                <cfif len(operation_type_id_list)>
                                    <cfset operation_type_id_list=listsort(operation_type_id_list,"numeric","ASC",",")>
                                    <cfquery name="get_operation_type" datasource="#dsn3#">
                                        SELECT
                                            OPERATION_TYPE,
                                            OPERATION_TYPE_ID
                                        FROM
                                            OPERATION_TYPES
                                        WHERE
                                            OPERATION_TYPE_ID IN(#operation_type_id_list#)
                                        ORDER BY
                                            OPERATION_TYPE_ID
                                    </cfquery>
                                </cfif>
                                <cfif attributes.result eq 1>
                                    <cfif len(action_employee_id_list)>
                                        <cfset action_employee_id_list=listsort(action_employee_id_list,"numeric","ASC",",")>
                                        <cfquery name="get_action_employee" datasource="#dsn#">
                                            SELECT 
                                                EMPLOYEE_ID,
                                                EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME ACTION_EMPLOYEE 
                                            FROM 
                                                EMPLOYEES 
                                            WHERE 
                                                EMPLOYEE_ID IN (#action_employee_id_list#) 
                                            ORDER BY 
                                                EMPLOYEE_ID
                                        </cfquery>
                                    </cfif>
                                </cfif>
                            </cfif>
                            <cfif len(project_id_list)>
                                <cfset project_id_list=listsort(project_id_list,"numeric","ASC",",")>
                                <cfquery name="get_project" datasource="#DSN#">
                                    SELECT PROJECT_HEAD,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN(#project_id_list#) ORDER BY PROJECT_ID
                                </cfquery>
                                <cfset project_id_list = listsort(valuelist(get_project.PROJECT_ID),"numeric","asc",",")>
                            </cfif>
                            <cfif isdefined("is_show_member") and is_show_member eq 1>
                                <cfif len(company_id_list)>
                                    <cfset company_id_list=listsort(company_id_list,"numeric","ASC",",")>
                                    <cfquery name="get_company" datasource="#dsn#">
                                        SELECT COMPANY_ID,FULLNAME FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#) ORDER BY COMPANY_ID
                                    </cfquery>
                                    <cfset company_id_list = listsort(valuelist(get_company.COMPANY_ID),"numeric","asc",",")>
                                </cfif>
                                <cfif len(consumer_id_list)>
                                    <cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
                                    <cfquery name="get_consumer" datasource="#dsn#">
                                        SELECT CONSUMER_ID,CONSUMER_NAME+' '+CONSUMER_SURNAME FULLNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
                                    </cfquery>
                                    <cfset consumer_id_list = listsort(valuelist(get_consumer.CONSUMER_ID),"numeric","asc",",")>
                                </cfif>
                            </cfif>
                            <input type="hidden" name="process_stage_" id="process_stage_" value="">
                            <input type="hidden" name="is_upd_related_demands" id="is_upd_related_demands" value="<cfif isdefined("is_upd_related_demands")><cfoutput>#is_upd_related_demands#</cfoutput><cfelse>0</cfif>"><!--- İlişkili taleplerin güncellenip güncellenmeyeceğini tutuyor arka sayfada kullanılıyor --->
                            <input type="hidden" name="process_type" id="process_type" value=""><!--- process type query sayfasında 0 ise talepler üretime çevirili 1 ise sadece bilgileri güncellenir.. --->
                            <input type="hidden" name="p_order_id_list" id="p_order_id_list" value="">
                            <cfif fuseaction_ contains 'operations'>
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
                            <cfoutput query="get_po_det">
                                <tr>
                                    <cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                                        <!-- sil -->
                                        <td align="center" id="order_row#currentrow#" class="color-row" onclick="gizle_goster(order_stocks_detail#currentrow#);connectAjax('#currentrow#','#p_order_id#','#PRODUCT_ID#','#STOCK_ID#','#quantity#','#SPEC_MAIN_ID#');gizle_goster_nested('siparis_goster#currentrow#','siparis_gizle#currentrow#');">
                                            <img id="siparis_goster#currentrow#" style="cursor:pointer;" src="/images/listele.gif" title="<cf_get_lang dictionary_id ='58596.Göster'>">
                                            <img id="siparis_gizle#currentrow#" style="cursor:pointer;display:none;" src="/images/listele_down.gif" title="<cf_get_lang dictionary_id ='58628.Gizle'>">
                                        </td>
                                        <!-- sil -->
                                    </cfif>
                                    <cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                                        <cfif fuseaction_ contains 'demands'>
                                            <td><a href="#request.self#?fuseaction=prod.demands&event=upd&upd=#p_order_id#" ><cfif fuseaction_ contains 'demands'>#demand_no#<cfelse>#p_order_no#</cfif></a></td>
                                        <cfelse>
                                            <td><a href="#request.self#?fuseaction=prod.order&event=upd&upd=#p_order_id#" ><cfif fuseaction_ contains 'demands'>#demand_no#<cfelse>#p_order_no#</cfif></a></td>
                                        </cfif>
                                    <cfelse>
                                        <td><cfif fuseaction_ contains 'demands'>#demand_no#<cfelse>#p_order_no#</cfif></td>
                                    </cfif>
                                    <cfif isdefined("is_show_demand_no") and is_show_demand_no eq 1>
                                            <td><cfif len(demand_no)>#demand_no#<cfelse>&nbsp;</cfif></td>
                                    </cfif>
                                    <cfif fuseaction_ contains 'demands' or  fuseaction_ contains 'order'>
                                        <cfif isdefined("is_show_order_no") and is_show_order_no eq 1>
                                            <td><cfif isdefined("order_list_#p_order_id#")>#evaluate("order_list_#p_order_id#")#</cfif></td>
                                        </cfif>
                                        <cfif isdefined("is_show_lot_no") and is_show_lot_no eq 1>
                                            <td nowrap>#get_po_det.lot_no#</td>
                                        </cfif>
                                    <cfelse>
                                        <td><cfif isdefined("order_list_#p_order_id#")>#evaluate("order_list_#p_order_id#")#</cfif></td>
                                        <td nowrap>#get_po_det.lot_no#</td>
                                    </cfif>
                                    <td>#dateformat(DELIVERDATE,dateformat_style)#</td>
                                    <cfif isdefined("is_show_deliver_day_") and is_show_deliver_day_>
                                        <cfset left_day = 0 />
                                        <cfif is_show_deliver_day_ Eq 1 And Len(DELIVERDATE)>
                                            <cfset left_day = dateDiff("d",Now(),DELIVERDATE) />
                                        <cfelseif is_show_deliver_day_ Eq 2>
                                            <cfset left_day = dateDiff("d",Now(),FINISH_DATE) />
                                        </cfif>
                                        <td<cfif left_day Lte 0> style="color:red;"</cfif>>#left_day#</td>
                                    </cfif>
                                    <cfif isdefined("is_show_demand_no_") and is_show_demand_no_ eq 1>
                                        <td nowrap>#get_po_det.ICT_NO#</td>
                                    </cfif>
                                    <cfif isdefined("is_show_member") and is_show_member eq 1>
                                        <td>
                                            <cfif listlen(company_id)>
                                                #get_company.FULLNAME[listfind(company_id_list,company_id,',')]#
                                            <cfelseif listlen(consumer_id)>
                                                #get_consumer.FULLNAME[listfind(consumer_id_list,consumer_id,',')]#
                                            </cfif>
                                        </td>
                                    </cfif>
                                    <cfif fuseaction_ contains 'order'><td>#get_emp_info(ORDER_EMPLOYEE_ID,0,0)#</td></cfif>
                                    <cfif isdefined("is_show_detail") and is_show_detail eq 1>
                                        <td>#detail#</td>
                                    </cfif>
                                    <cfif isdefined("is_show_project") and is_show_project eq 1>
                                        <td><cfif len(project_id)>#get_project.PROJECT_HEAD[listfind(project_id_list,project_id,',')]#</cfif></td>
                                    </cfif>
                                    <cfset _station_id_ = station_id>
                                    <cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                                        <cfif fuseaction_ contains 'demands'>
                                            <cfif fuseaction_ contains 'autoexcelpopuppage'>
                                                <td>
                                                    <cfif len(_station_id_)>
                                                        #get_station_prod(station_id)#
                                                    </cfif>
                                                </td>
                                            <cfelse>
                                                <!-- sil -->
                                                <td>
                                                    <cfset _stock_id_ = STOCK_ID>
                                                    <select name="station_id_#p_order_id#" id="station_id_#p_order_id#" style="width:100px;">
                                                        <cfloop query="get_w">
                                                            <cfif isdefined('stock_defined_stations_list_#_stock_id_#') and ListFind(Evaluate('stock_defined_stations_list_#_stock_id_#'),get_w.station_id,',') or get_w.station_id eq _station_id_>
                                                                <option value="#get_w.station_id#"<cfif _station_id_ eq get_w.station_id>selected</cfif>><cfif len(up_station)>&nbsp;&nbsp;</cfif>#station_name#</option>
                                                            </cfif>
                                                        </cfloop>
                                                    </select>
                                                </td>
                                                <!-- sil -->
                                            </cfif>
                                        <cfelseif fuseaction_ contains 'operations'>
                                            <td>
                                                <cfif attributes.result eq 1><!--- operasyon sonucu girilenler listeleniyorsa operasyon sonucundaki istasyonu seçili olarak getiriyoruz. --->
                                                    <cfif len(operation_type_id)>
                                                        <cfquery name="GET_STATIONS" datasource="#DSN3#">
                                                            SELECT
                                                                W.STATION_ID AS STATION_ID_ ,
                                                                W.STATION_NAME
                                                            FROM 
                                                                WORKSTATIONS W,
                                                                WORKSTATIONS_PRODUCTS WP
                                                            WHERE
                                                                W.STATION_ID = WP.WS_ID 
                                                                AND WP.OPERATION_TYPE_ID IN (#operation_type_id#)
                                                                <!--- AND WP.MAIN_STOCK_ID IS NULL --->
                                                                ORDER BY STATION_NAME
                                                        </cfquery>
                                                    <cfelse>
                                                        <cfset GET_STATIONS.recordcount = 0>
                                                    </cfif>
                                                    <cfset result_station_id_ = result_station_id>
                                                    <select name="station_id_#currentrow#" id="station_id_#currentrow#" style="width:100px;">
                                                        <cfloop query="GET_STATIONS">
                                                            <option value="#STATION_ID_#" <cfif len(result_station_id_) and STATION_ID_ eq result_station_id_>selected</cfif>>#STATION_NAME#</option>
                                                        </cfloop>
                                                    </select>
                                                <cfelse>
                                                    <cfif len(operation_type_id)>
                                                        <cfquery name="GET_STATIONS" datasource="#DSN3#">
                                                            SELECT
                                                                W.STATION_ID AS STATION_ID_ ,
                                                                W.STATION_NAME
                                                            FROM 
                                                                WORKSTATIONS W,
                                                                WORKSTATIONS_PRODUCTS WP
                                                            WHERE
                                                                W.STATION_ID = WP.WS_ID 
                                                                AND WP.OPERATION_TYPE_ID IN (#operation_type_id#)
                                                                <!--- AND WP.MAIN_STOCK_ID IS NULL --->
                                                                ORDER BY STATION_NAME
                                                        </cfquery>
                                                    <cfelse>
                                                        <cfset GET_STATIONS.recordcount = 0>
                                                    </cfif>
                                                    <select name="station_id_#currentrow#" id="station_id_#currentrow#" style="width:100px;">
                                                        <cfloop query="GET_STATIONS">
                                                            <option value="#STATION_ID_#">#STATION_NAME#</option>
                                                        </cfloop>
                                                    </select>
                                                </cfif>
                                            </td>
                                        <cfelse>
                                            <td>
                                                <cfif len(_station_id_)>
                                                    <a  href="#request.self#?fuseaction=prod.list_workstation&event=upd&station_id=#station_id#">#get_station_prod(station_id)#</a>
                                                </cfif>
                                            </td>
                                        </cfif>
                                    <cfelse>
                                        <td>
                                            <cfif len(_station_id_)>
                                                #get_station_prod(station_id)#
                                            </cfif>
                                        </td>
                                    </cfif>
                                    <cfif (((fuseaction_ contains 'demands' or  fuseaction_ contains 'order') and is_show_process eq 1) or (not (fuseaction_ contains 'demands' or  fuseaction_ contains 'order'))) and not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                                        <td id="td_process_#p_order_id#"><cfif len(prod_order_stage)>#process_type.stage[listfind(prod_order_stage_list,prod_order_stage,',')]#</cfif></td>
                                    <cfelseif (((fuseaction_ contains 'demands' or  fuseaction_ contains 'order') and is_show_process eq 1) or (not (fuseaction_ contains 'demands' or  fuseaction_ contains 'order'))) and (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                                        <td><cfif len(prod_order_stage)>#process_type.stage[listfind(prod_order_stage_list,prod_order_stage,',')]#</cfif></td>
                                    </cfif>
                                    <cfif (fuseaction_ contains 'demands' or (fuseaction_ contains 'order' and attributes.result eq 0)) and not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                                    <cfelse>
                                        <cfif fuseaction_ contains 'operations'>
                                            <td>
                                                <input type="hidden" name="operation_type_id_#currentrow#" id="operation_type_id_#currentrow#" value="#operation_type_id#">
                                                <cfif len(operation_type_id)>#get_operation_type.OPERATION_TYPE[listfind(operation_type_id_list,operation_type_id,',')]#</cfif>
                                            </td>
                                            <td align="right" style="text-align:right;">
                                                <cfif attributes.result eq 1>
                                                    <input type="text" name="operation_amount_#currentrow#" id="operation_amount_#currentrow#" value="#real_amount#" maxlength="10" style="width:65px; padding:0px!important;" class="moneybox" onkeyup="return(FormatCurrency(this,event,3));">
                                                    <input type="hidden" name="operation_amount__#currentrow#" id="operation_amount__#currentrow#" value="#last_amount + real_amount#" />
                                                    <input type="hidden" name="operation_result_id_#currentrow#" id="operation_result_id_#currentrow#" value="#OPERATION_RESULT_ID#">
                                                <cfelse>
                                                    <input type="text" name="operation_amount_#currentrow#" id="operation_amount_#currentrow#" value="#last_amount#" maxlength="10" style="width:65px; padding:0px!important;" class="moneybox" onkeyup="return(FormatCurrency(this,event,3));">
                                                    <input type="hidden" name="operation_amount__#currentrow#" id="operation_amount__#currentrow#" value="#last_amount#" />
                                                    <input type="hidden" name="operation_result_id_#currentrow#" id="operation_result_id_#currentrow#" value="">
                                                </cfif>
                                            </td>
                                            <td nowrap="nowrap">
                                                <cfif attributes.result eq 1>
                                                    <div class="input-group">
                                                        <input type="hidden" name="employee_id_#CURRENTROW#" id="employee_id_#CURRENTROW#" value="<cfif len(action_employee_id)>#action_employee_id#</cfif>">
                                                        <input type="text" style="width:80px;" name="employee_name_#CURRENTROW#" id="employee_name_#CURRENTROW#" value="<cfif len(action_employee_id)>#get_action_employee.ACTION_EMPLOYEE[listfind(action_employee_id_list,action_employee_id,',')]#</cfif>" class="text">
                                                        <span class="input-group-addon icon-ellipsis" onclick="pencere_ac_employee(#CURRENTROW#);" title="<cf_get_lang dictionary_id='57734.Seçiniz'>"></span>
                                                    </div>
                                                <cfelse>
                                                    <div class="input-group">
                                                        <input type="hidden" name="employee_id_#CURRENTROW#" id="employee_id_#CURRENTROW#" value="#session.ep.userid#">
                                                        <input type="text" style="width:80px;" name="employee_name_#CURRENTROW#" id="employee_name_#CURRENTROW#" value="#get_emp_info(session.ep.userid,0,0)#" class="text">
                                                        <span class="input-group-addon icon-ellipsis" onclick="pencere_ac_employee(#CURRENTROW#);" title="<cf_get_lang dictionary_id='57734.Seçiniz'>"></span>
                                                    </div>        
                                                </cfif>
                                            </td>
                                        </cfif>
                                        <td>#stock_code#</td>
                                        <td>
                                            <cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                                                <a href="#request.self#?fuseaction=prod.list_product_tree&event=upd&stock_id=#stock_id#" >
                                                    #product_name# #property#
                                                </a>
                                            <cfelse>
                                                #product_name# #property#
                                            </cfif>
                                        </td>
                                        <cfif isdefined("is_spec_code") and is_spec_code eq 1><td>#SPECT_VAR_ID#</td></cfif>
                                        <cfif isdefined("is_show_spec_no") and is_show_spec_no neq 0>
                                            <td>
                                                <cfif len(SPECT_VAR_ID) or len(SPEC_MAIN_ID)>
                                                    <cfset s_link = '&id=#SPECT_VAR_ID#&stock_id=#stock_id#&spect_main_id=#SPEC_MAIN_ID#'>
                                                    <cfif not len(SPECT_VAR_ID)>
                                                        <cfset s_link = '&upd_main_spect=1&spect_main_id=#SPEC_MAIN_ID#'>
                                                    </cfif>
                                                    <cfif is_show_spec_no eq 2><!--- spec no gelsin --->
                                                        <cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                                                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_upd_spect#s_link#&is_disable=1','list');" >
                                                                #SPEC_MAIN_ID#-#SPECT_VAR_ID#
                                                            </a>
                                                        <cfelse>
                                                            #SPEC_MAIN_ID#-#SPECT_VAR_ID#
                                                        </cfif>
                                                    <cfelseif is_show_spec_no eq 1><!--- spec adı gelsin --->
                                                        <cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                                                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_upd_spect#s_link#&is_disable=1','list');" >
                                                                #SPECT_VAR_NAME#
                                                            </a>
                                                        <cfelse>
                                                            #SPECT_VAR_NAME#
                                                        </cfif>
                                                    </cfif>
                                                </cfif>
                                            </td>
                                        </cfif>
                                        <td align="right" style="text-align:right;">#TlFormat(quantity)#</td>
                                        <cfif isdefined("is_show_result_amount") and is_show_result_amount eq 1>
                                            <cfif fuseaction_ contains 'operations'>
                                                <cfif attributes.result eq 1>
                                                    <td align="right" style="text-align:right;">#TlFormat(real_amount)#</td>
                                                    <td align="right" style="text-align:right;">#TlFormat(LAST_AMOUNT)#</td>
                                                <cfelse>
                                                    <td align="right" style="text-align:right;">#TlFormat(quantity-last_amount)#</td>
                                                    <td align="right" style="text-align:right;">#TlFormat(LAST_AMOUNT)#</td>
                                                </cfif>
                                            <cfelse>
                                                <td align="right" style="text-align:right;">#TlFormat(row_result_amount)#</td>
                                                <td align="right" style="text-align:right;">#TlFormat(quantity-row_result_amount)#</td>
                                            </cfif>
                                        </cfif>
                                    </cfif>
                                    <!-- sil --><td>#MAIN_UNIT#</td><!-- sil -->
                                    <!-- sil -->
                                    <cfif (fuseaction_ contains 'demands' or (fuseaction_ contains 'order' and attributes.result eq 0)) and not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                                        <cfif fuseaction_ contains 'autoexcelpopuppage'>
                                            <td>#dateformat(start_date,dateformat_style)# #TimeFormat(start_date,'HH')#:#TimeFormat(start_date,'MM')#</td>
                                            <td>#dateformat(finish_date,dateformat_style)# #TimeFormat(finish_date,'HH')#:#TimeFormat(finish_date,'MM')#</td>
                                            <td style="text-align:right;">#tlformat(quantity,3)#</td>
                                        <cfelse>
                                            <!-- sil -->
                                            <cfif fuseaction_ contains 'demands'>
                                                <cfif isdefined("is_show_temp_date") and is_show_temp_date eq 1>
                                                    <td nowrap>
                                                        <input maxlength="10" type="text" id="production_start_date_#p_order_id#" name="production_start_date_#p_order_id#"  validate="#validate_style#" style="width:65px;" value="#dateformat(start_date,dateformat_style)#">
                                                        <cf_wrk_date_image date_field="production_start_date_#p_order_id#">
                                                        <cf_wrkTimeFormat name="production_start_h_#p_order_id#" id="production_start_h_#p_order_id#"value="#TimeFormat(start_date,'HH')#">	
                                                        <select name="production_start_m_#p_order_id#" id="production_start_m_#p_order_id#">
                                                            <cfloop from="0" to="59" index="i">
                                                                <option value="#i#" <cfif TimeFormat(start_date,'MM') eq i>selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
                                                            </cfloop>
                                                        </select>
                                                    </td>
                                                    <td nowrap>
                                                        <input maxlength="10" type="text" name="production_finish_date_#p_order_id#" id="production_finish_date_#p_order_id#" validate="#validate_style#" style="width:65px;" value="#dateformat(finish_date,dateformat_style)#">
                                                        <cf_wrk_date_image date_field="production_finish_date_#p_order_id#">
                                                        <cf_wrkTimeFormat name="production_finish_h_#p_order_id#" id="production_finish_h_#p_order_id#" value="#TimeFormat(finish_date,'HH')#">	
                                                        <select name="production_finish_m_#p_order_id#" id="production_finish_m_#p_order_id#">
                                                            <cfloop from="0" to="59" index="i">
                                                                <option value="#i#" <cfif TimeFormat(finish_date,'MM') eq i>selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
                                                            </cfloop>
                                                        </select>
                                                    </td>
                                                </cfif>
                                            <cfelse>
                                                <td nowrap>
                                                    <input maxlength="10" type="text" id="production_start_date_#p_order_id#" name="production_start_date_#p_order_id#"  validate="#validate_style#" style="width:65px;" value="#dateformat(start_date,dateformat_style)#">
                                                    <cf_wrk_date_image date_field="production_start_date_#p_order_id#">
                                                    <cf_wrkTimeFormat  name="production_start_h_#p_order_id#" id="production_start_h_#p_order_id#" value="#TimeFormat(start_date,'HH')#">	
                                                    <select name="production_start_m_#p_order_id#" id="production_start_m_#p_order_id#">
                                                        <cfloop from="0" to="59" index="i">
                                                            <option value="#i#" <cfif TimeFormat(start_date,'MM') eq i>selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
                                                        </cfloop>
                                                    </select>
                                                </td>
                                                <td nowrap>
                                                    <input maxlength="10" type="text" name="production_finish_date_#p_order_id#" id="production_finish_date_#p_order_id#" validate="#validate_style#" style="width:65px;" value="#dateformat(finish_date,dateformat_style)#">
                                                    <cf_wrk_date_image date_field="production_finish_date_#p_order_id#">
                                                    <cf_wrkTimeFormat name="production_finish_h_#p_order_id#" id="production_finish_h_#p_order_id#" value="#TimeFormat(finish_date,'HH')#">	
                                                    <select name="production_finish_m_#p_order_id#" id="production_finish_m_#p_order_id#">
                                                        <cfloop from="0" to="59" index="i">
                                                            <option value="#i#" <cfif TimeFormat(finish_date,'MM') eq i>selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
                                                        </cfloop>
                                                    </select>
                                                </td>
                                            </cfif>
                                            <td>
                                                <input type="hidden" name="old_quantity_#p_order_id#" id="old_quantity_#p_order_id#" value="#quantity#">
                                                <input type="text" style="width:65px;" name="quantity_#p_order_id#" id="quantity_#p_order_id#" value="#tlformat(quantity,3)#" class="moneybox" onkeyup="return(FormatCurrency(this,event,3));">
                                            </td>
                                            <!-- sil -->
                                        </cfif>
                                        <cfif isdefined("is_show_result_amount") and is_show_result_amount eq 1>
                                            <td align="right" style="text-align:right;">#row_result_amount#</td>
                                            <td align="right" style="text-align:right;">#quantity-row_result_amount#</td>
                                        </cfif>
                                    </cfif>
                                    <td>#dateformat(start_date,dateformat_style)# #TimeFormat(start_date,'#timeformat_style#')#</td>
                                    <td>#dateformat(finish_date,dateformat_style)# #TimeFormat(finish_date,'#timeformat_style#')#</td>
                                    <cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                                    <cfif fuseaction_ neq 'demands'>
                                        <td style="text-align:center;">
                                        <cfif IS_STAGE eq 4>
                                                <cfif IS_GROUP_LOT eq 1>
                                                    <i class="fa fa-google" style="color:##0DD8FC;font-size:13px" title="<cf_get_lang dictionary_id ='36892.Gruplandı Fakat Operatöre Gönderilmedi'>"></i>
                                                <cfelse>
                                                    <i class="fa fa-circle" style="color:##0DD8FC;font-size:13px" title="<cf_get_lang dictionary_id ='36583.Başlamadı'>"></i>
                                                </cfif>       
                                            <cfelseif IS_STAGE eq 0>
                                                <i class="fa fa-circle" style="color:##FAAB38;font-size:13px" title="<cf_get_lang dictionary_id ='36891.Operatöre Gönderildi'>"></i>
                                            <cfelseif IS_STAGE eq 1>
                                                <i class="fa fa-circle" style="color:##A2FA38;font-size:13px"  title="<cf_get_lang dictionary_id ='36890.Başladı'>"></i>
                                            <cfelseif IS_STAGE eq 2>
                                                <i class="fa fa-circle" style="color:red;font-size:13px" title="<cf_get_lang dictionary_id ='36584.Bitti'>">
                                            <cfelseif IS_STAGE eq 3>
                                                <i class="fa fa-circle"  style="color:##858484;font-size:13px" title="<cf_get_lang dictionary_id ='36893.Üretim Durdu(Arıza)'>"></i>
                                        </cfif>
                                        </td>
                                    </cfif>
                                    <td align="center"><a target="_blank" href="#request.self#?fuseaction=objects.popup_print_files&action_id=#p_order_id#&date1=#DateFormat(attributes.start_date,dateformat_style)#&date2=#DateFormat(attributes.finish_date,dateformat_style)#&iid=#attributes.station_id#&iiid=<cfif len(attributes.product_cat)>#attributes.product_cat_code#</cfif>
                                    <cfif len(attributes.result)>&keyword=#attributes.result#</cfif>&action_row_id=#attributes.production_stage#"><i class="fa fa-print" title="<cf_get_lang dictionary_id='57474.Yazdır'>" alt="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></a></td>
                                    <td style="text-align:center;">
                                        <cfif fuseaction_ contains 'demands'>
                                            <a href="javascript://" onclick="window.open('#request.self#?fuseaction=prod.demands&event=upd&upd=#p_order_id#')"> <i class="fa fa-pencil" title="<cf_get_lang dictionary_id='47243.Üretim Talepleri'>" alt="<cf_get_lang dictionary_id='47243.Üretim Talepleri'>"></i></a>
                                        <cfelse>
                                            <a href="javascript://" onclick="window.open('#request.self#?fuseaction=prod.order&event=upd&upd=#p_order_id#')"> <i class="fa fa-pencil" title="<cf_get_lang dictionary_id='36436.Üretim Emri Düzenle'>" alt="<cf_get_lang dictionary_id='47243.Üretim Talepleri'>"></i></a>
                                        </cfif>
                                    </td>
                                    <td style="text-align:center;">
                                    <input type="checkbox" name="row_demand" id="row_demand" value="#P_ORDER_ID#;#CURRENTROW#"></td>
                                    <!-- sil -->
                                    </cfif>
                                </tr>
                                <cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                                <!-- sil -->
                                <tr id="order_stocks_detail#currentrow#" class="nohover" style="display:none" >
                                    <td colspan="#colspan_info#">
                                        <div align="left" id="DISPLAY_ORDER_STOCK_INFO#currentrow#" style="border:none;"></div>
                                    </td>
                                </tr>
                                <!-- sil -->
                                </cfif>
                            </cfoutput>                
                        <cfelse>
                            <tr>
                                <td colspan="<cfoutput>#colspan_info#</cfoutput>"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                            </tr>
                        </cfif>
                    <cfelse>
                        <tr>
                            <td colspan="<cfoutput>#colspan_info#</cfoutput>"><cf_get_lang dictionary_id ='57701.Filtre Ediniz'> !</td>
                        </tr>
                    </cfif>
                </tbody> 
            </cf_grid_list>
        </form>
        <cfif get_po_det.recordcount>   
            <form name="go_p_order_list" method="post" action="<cfoutput>#request.self#?</cfoutput>fuseaction=prod.order">
                <input type="hidden" name="keyword" id="keyword" value=""><!--- Üretim Emirlerin Listesine Giderken Doldurulur.. --->
                <input type="hidden" name="production_order_no" id="production_order_no" value=""><!--- Üretim Malzeme İhtiyaçlarına Giderken doldurulur.. --->
                <input type="hidden" name="is_submitted" id="is_submitted" value="1">
                <input type="hidden" name="start_date" id="start_date" value="">
                <input type="hidden" name="finish_date" id="finish_date" value="">
                <input type="hidden" name="row_demand_all" id="row_demand_all" value="<cfoutput query="get_po_det">#P_ORDER_ID#<cfif currentrow neq recordcount>,</cfif></cfoutput>">
            </form>
        </cfif>  
        <cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
            <cfif attributes.totalrecords gt attributes.maxrows>
            <!-- sil -->
                <cf_paging 
                    page="#attributes.page#"
                    maxrows="#attributes.maxrows#"
                    totalrecords="#attributes.totalrecords#"
                    startrow="#attributes.startrow#"
                    adres="prod.#fuseaction_##url_str#">
            <!-- sil -->
            </cfif>
        </cfif>
    </cf_box>
    <!-- sil -->
    <cfif len(attributes.is_submitted) and get_po_det.recordcount and (not (isdefined('attributes.is_excel') and attributes.is_excel eq 1))>
        <cf_box>
            <div class="ui-form-list-btn flex-end ui-info-bottom" style="border-top:none;">
            <div class="form-group">
                <a href="javascript://" class="ui-wrk-btn ui-wrk-btn-red" name="excelll" id="excelll" onclick="convert_to_excel();"><i class="fa fa-file-excel-o"></i> <cf_get_lang dictionary_id ='57858.Excel Getir'></a>
            </div>
                <cfif not fuseaction_ contains 'operations'>
                    
                    <div class="form-group">
                        <a href="javascript://" class="ui-btn ui-btn-update" onclick="demand_convert_to_production(3);"><i class="fa fa-list-alt"></i>  <cf_get_lang dictionary_id ='36523.Malzeme İhtiyaç Listesi'></a>
                    </div>
                    <div class="form-group">
                        <a href="javascript://" class="ui-wrk-btn ui-wrk-btn-extra" id="tumune_ihtiyac_button" onclick="demand_convert_to_production(4);"><i class="fa fa-list"></i> <cf_get_lang dictionary_id ='36524.Tümüne Malzeme İhtiyaç Listesi'></a>
                    </div>
                    <div class="form-group">
                        <a href="javascript://" class="ui-wrk-btn ui-wrk-btn-success" onclick="demand_convert_to_production(2);"><i class="fa fa-clone"></i> <cf_get_lang dictionary_id ='36815.Grupla'></a>
                    </div>
                    <cfif fuseaction_ contains 'order' and attributes.result eq 0 and not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                        <div class="form-group"><a href="javascript://" class="ui-wrk-btn ui-wrk-btn-success" onclick="demand_convert_to_production(5);"><i class="fa fa-pencil"></i> <cf_get_lang dictionary_id='36995.Seçili Emirleri Güncelle'></a></div>
                    </cfif>
                    <cfif fuseaction_ contains 'demands'>
                        <div class="form-group">
                            <a href="javascript://" class="ui-wrk-btn ui-wrk-btn-extra" name="updDemandValues_" id="updDemandValues_" onclick="demand_convert_to_production(1);"><i class="fa fa-pencil"></i> <cf_get_lang dictionary_id ='36530.Seçili Talepleri Güncelle'></a>
                        </div>
                        <div class="form-group">
                            <a href="javascript://" class="ui-wrk-btn ui-wrk-btn-red" name="delDemandValues_" id="delDemandValues_"  onclick="demand_convert_to_production(6);"><i class="fa fa-eraser"></i> <cf_get_lang dictionary_id ='36996.Seçili Talepleri Sil'></a>
                        </div>
                        <div class="form-group">
                            <a href="javascript://" class="ui-wrk-btn ui-wrk-btn-success" name="convert_to_production_" id="convert_to_production_" onclick="demand_convert_to_production(0);"><i class="fa fa-refresh"></i> <cf_get_lang dictionary_id ='36647.Üretime Çevir'></a>
                        </div>
                    </cfif>
                    <cfif (fuseaction_ contains 'demands' or (fuseaction_ contains 'order' and attributes.result eq 0)) and not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                        <div class="form-group"><cf_workcube_process is_upd='0' process_cat_width='140' is_detail='0'></div>
                    </cfif>
                </cfif>
                <cfif fuseaction_ contains 'operations' and attributes.result eq 0>
                    <div class="form-group"><a href="javascript://" class="ui-wrk-btn ui-wrk-btn-extra" name="convert_to_production_" id="convert_to_production_" onclick="demand_convert_to_production(7);"><i class="fa fa-pencil"></i> <cf_get_lang dictionary_id='60545.Seçili Operasyonları Sonlandır'></a></div>
                <cfelseif fuseaction_ contains 'operations' and attributes.result eq 1>
                    <div class="form-group"><a href="javascript://" class="ui-wrk-btn ui-wrk-btn-extra" name="convert_to_production_" id="convert_to_production_" onclick="demand_convert_to_production(7);"><i class="fa fa-pencil"></i> <cf_get_lang dictionary_id='60546.Seçili Operasyonları Güncelle'></a></div>
                </cfif>
            </div>
            <div id="user_message_demand"></div>
        </cf_box>
        <div id="groups_p"></div> 
    </cfif>
    <!-- sil -->
</div>
<script type="text/javascript"> 
    document.getElementById('keyword').focus();                       
    function kontrol()
        {
            if(!$("#maxrows").val().length)
            {
                alertObject({message: "<cfoutput><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfoutput>"})    
                return false;
            }
            return true;
        }
    function demand_convert_to_production(type)
        {
            /* document.getElementById("process_stage_").value  = document.getElementById("process_stage").value; */
            if(type==4)// type 4 ise
            {
                document.getElementById("tumune_ihtiyac_button").value='<cfoutput><cf_get_lang dictionary_id='57705.İşleniyor'></cfoutput>';
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
                            var items = document.querySelectorAll('input[type=checkbox]:checked');
                            for(var i = 0; i < items.length; i++ ){
                                if(items[i].value != "on"){ 
                                    //tems[i].value);
                                    p_order_id_list+=list_getat(items[i].value,1,';')+',';
                                    currntrow_list+=list_getat(items[i].value,2,';')+',';
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
                                        user_message='<cf_get_lang dictionary_id ="36564.Malzeme İhtiyaç Listesine Yönlendiriliyorsunuz Lütfen Bekleyiniz">!';
                                    else if(type==1)
                                    {
                                        
                                        var selected_process_ = $("#process_stage").val();
                                        if(selected_process_=='')
                                        {
                                            alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id ='58859.Süreç'>");
                                            return false;
                                        }
                                        else 
                                            $("#process_stage_").val(selected_process_);
                                        
                                        user_message='<cf_get_lang dictionary_id ="36577.Talepler Güncelleniyor Lütfen Bekleyiniz">!';
                                    }
                                    else if(type==5)
                                    {
                                        var selected_process_ = $("#process_stage").val();
                                        if(selected_process_=='')
                                        {
                                            alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id ='58859.Süreç'>");
                                            return false;
                                        }
                                        else 
                                            $("#process_stage_").val(selected_process_);
                                        
                                        user_message='<cf_get_lang dictionary_id="36991.Emirler Güncelleniyor Lütfen Bekleyiniz"> !';
                                    }
                                    else if(type==6)
                                    {
                                        var selected_process_ = $("#process_stage").val();
                                        if(selected_process_=='')
                                        {
                                            alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id ='58859.Süreç'>");
                                            return false;
                                        }
                                        user_message='<cf_get_lang dictionary_id="36992.Talepler Siliniyor Lütfen Bekleyiniz"> !';
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
                                                alert(crtrow +". <cf_get_lang dictionary_id='60547.Satırda İstasyon Eksik'>. <cf_get_lang dictionary_id='58837.Lütfen İstasyon Seçiniz'>.");
                                                return false;
                                            }
                                            if(document.getElementById('operation_amount_'+crtrow).value == '')
                                            {
                                                alert(crtrow +". <cf_get_lang dictionary_id='60548.Satırda Miktar Eksik'>. <cf_get_lang dictionary_id='60222.Lütfen Miktar Seçiniz'>.");
                                                return false;
                                            }
                                            if(document.getElementById('operation_amount_'+crtrow).value > document.getElementById('operation_amount__'+crtrow).value)
                                            {
                                                alert(crtrow +". <cf_get_lang dictionary_id='60549.Satırda Operasyon Miktarı Kalan Miktardan Fazla'>.");
                                                return false;
                                            }
                                            if(document.getElementById('employee_id_'+crtrow).value == '')
                                            {
                                                alert(crtrow +". <cf_get_lang dictionary_id='60550.Satırda İşlemi Yapan Eksik'>. <cf_get_lang dictionary_id='60551.Lütfen İşlemi Yapanı Seçiniz'>.");
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
                                        user_message="<cf_get_lang dictionary_id ='36578.Talepler Üretime Çeviriliyor Lütfen Bekleyiniz'>!";
                                        
                                    
                                    $("#process_type").val(type);
                                    windowopen('','small','p_action_window');
                                    document.convert_demand_to_production.target = 'p_action_window';
                                    document.convert_demand_to_production.submit();
                                    //AjaxFormSubmit(convert_demand_to_production,'user_message_demand',1,user_message,'<cf_get_lang dictionary_id ="1374.Tamamlandı">!','','',1);
                                }
                                
                            }
                        }
                        else{
                            if(type==0)
                                alert("<cf_get_lang dictionary_id ='36579.Üretime Göndermek İçin Talep Seçiniz'>");
                            else if(type==1)
                                alert("<cf_get_lang dictionary_id ='36580.Güncellenecek Talepleri Seçiniz'>!");
                            else if(type==5)
                                alert("<cf_get_lang dictionary_id ='36993.Güncellenecek Emirleri Seçiniz'>!");
                            else if(type==6)
                                alert("<cf_get_lang dictionary_id ='36994.Silinecek Talepleri Seçiniz'>!");
                            else if(type==2)
                                alert("<cf_get_lang dictionary_id ='36581.Gruplanacak Satırları Seçiniz'>!");
                            else if(type==3)
                                alert("<cf_get_lang dictionary_id ='36582.Malzeme İhtiyaçları İçin Talep Seçiniz'>!");
                            else if(type==7)
                                alert("<cf_get_lang dictionary_id ='60552.Sonlandırılacak Operasyonları Seçiniz'>!");
                            return false;
                        }
                    }
            }// type 4 degilse	
        }	
    <cfif (fuseaction_ is 'demands' or  fuseaction_ is 'order') and is_show_multi_print eq 1>
        function send_services_print()
        {	
        <cfif len(attributes.is_submitted)>
                <cfif not get_po_det.recordcount>
                    alert("<cf_get_lang dictionary_id ='36586.Yazdırılacak Belge Bulunamadı Toplu Print Yapamazsınız'>!");
                    return false;
                </cfif>
                <cfif get_po_det.recordcount eq 1>
                    if(document.convert_demand_to_production.row_demand.checked == false)
                    {
                        alert("<cf_get_lang dictionary_id ='36586.Yazdırılacak Belge Bulunamadı Toplu Print Yapamazsınız'>!");
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
                        alert("<cf_get_lang dictionary_id ='36586.Yazdırılacak Belge Bulunamadı Toplu Print Yapamazsınız'>!");
                        return false;
                    }
                </cfif>
                windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files</cfoutput>&iid='+service_list_,'page');
            <cfelse>
                alert("<cf_get_lang dictionary_id ='36586.Yazdırılacak Belge Bulunamadı Toplu Print Yapamazsınız'>!");
                return false;
            </cfif>
        }
    </cfif>   
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
		alert("<cf_get_lang dictionary_id ='36828.Spect Seçmek için öncelikle ürün seçmeniz gerekmektedir'>");
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
	function connectAjax(crtrow,p_order_id,prod_id,stock_id,order_amount,spect_main_id)
	{
		var bb = '<cfoutput>#request.self#?fuseaction=objects.emptypopup_ajax_product_stock_info&deep_level_max=1&tree_stock_status=1</cfoutput>&p_order_id='+p_order_id+'&pid='+prod_id+'&sid='+ stock_id+'&amount='+order_amount+'&spect_main_id='+spect_main_id;
		AjaxPageLoad(bb,'DISPLAY_ORDER_STOCK_INFO'+crtrow,1);
	}
</script>