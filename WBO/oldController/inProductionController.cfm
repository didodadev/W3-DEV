<cf_get_lang_set module_name="prod">
<cfif (isdefined("attributes.event") and listFindNoCase('list,excel',attributes.event)) or not isdefined("attributes.event")>
	<cfset fuseaction_ = ListGetAt(attributes.fuseaction,2,'.')>
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
            get_prod_order_action = createObject("component", "production_plan.cfc.get_prod_order");
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
        <cfset url_str = url_str & "&start_date=#dateformat(attributes.start_date,'dd/mm/yyyy')#">
    </cfif>
    <cfif isdate(attributes.start_date_2)>
        <cfset url_str = url_str & "&start_date_2=#dateformat(attributes.start_date_2,'dd/mm/yyyy')#">
    </cfif>
    <cfif isdate(attributes.finish_date)>
        <cfset url_str = url_str & "&finish_date=#dateformat(attributes.finish_date,'dd/mm/yyyy')#">
    </cfif>
    <cfif isdate(attributes.finish_date_2)>
        <cfset url_str = url_str & "&finish_date_2=#dateformat(attributes.finish_date_2,'dd/mm/yyyy')#">
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
    </cfquery>
    <cfif fuseaction_ contains 'demands'><!--- Talep --->
        <cfset print_type_ = 282>
        <cfset colspan_info = 10>
    <cfelseif fuseaction_ contains 'order'><!--- Emir --->
        <cfset print_type_ = 281>
        <cfset colspan_info = 12>	
    <cfelse>
        <cfset print_type_ = 281>
        <cfset colspan_info = 16>
    </cfif>
    
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
                 <cfif fuseaction_ contains 'operations'>
                 	<cfif attributes.result eq 1>
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
                    </cfif>
                 </cfif>
        </cfif>
    </cfif>
<cfelseif listfind('addorder,adddemand,adddemandCollacted',attributes.event)>  
	<cfinclude template="../objects/functions/auto_complete_functions.js">
    <cf_xml_page_edit fuseact="prod.add_prod_order">
    <cfparam name="paper_project_id" default="">
    <cfparam name="attributes.station_id" default="">
    <cfparam name="attributes.station_name" default="">
    <cfparam name="attributes.start_hour" default="#timeformat(dateadd('h',session.ep.time_zone, now()),'HH')#">
    <cfparam name="attributes.finish_hour" default="#timeformat(dateadd('h',session.ep.time_zone, now()),'HH')#">
    <cfparam name="attributes.start_mnt" default="#timeformat(dateadd('h',session.ep.time_zone, now()),'MM')#">
    <cfparam name="attributes.finish_mnt" default="#timeformat(dateadd('h',session.ep.time_zone, now()),'MM')#">    
    <script type="text/javascript">
      temp_var = 0;
    </script>
    <cfquery name="GET_MONEY" datasource="#dsn#">
        SELECT	PERIOD_ID,MONEY,RATE1,RATE2 FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS = 1
    </cfquery>
    <cfset money_str ='&search_process_date=#DateFormat(now(),"DD/MM/YYYY")#&company_id=1'>
    <cfoutput query="GET_MONEY">
    <cfset money_str = '#money_str#&#MONEY#=#RATE2#'>
    </cfoutput>
    <cfif isdefined("attributes.upd")><!---Üretim Emri Kopyalama --->
        <cfquery name="GET_DET_PO" datasource="#DSN3#">
            SELECT
                P.IS_PRODUCTION,
                P.IS_PROTOTYPE,
                PO.P_ORDER_ID,
                PO.STOCK_ID,
                PO.STATION_ID,
                PO.DEMAND_NO,
                PO.PO_RELATED_ID,
                PO.ORDER_ID,
                PO.QUANTITY,
                PO.P_ORDER_NO,
                PO.START_DATE,
                PO.FINISH_DATE,
                PO.STATUS,
                PO.IS_STOCK_RESERVED,
                PO.IS_DEMONTAJ,
                PO.PROD_ORDER_STAGE,
                PO.LOT_NO,
                PO.PROJECT_ID,
                PO.REFERENCE_NO,
                PO.SPEC_MAIN_ID,
                PO.SPECT_VAR_ID,
                PO.SPECT_VAR_NAME,
                PO.DETAIL,
                PO.DP_ORDER_ID,
                PO.RECORD_EMP,
                PO.RECORD_DATE,
                PO.UPDATE_EMP,
                PO.UPDATE_DATE,
                PO.PRINT_COUNT,
                PO.IS_STAGE,
                PO.WRK_ROW_RELATION_ID,
                S.PROPERTY,
                P.PRODUCT_NAME,
                P.PRODUCT_ID,
                S.STOCK_ID,
                S.STOCK_CODE,
                S.PRODUCT_UNIT_ID,
                ISNULL(PO.RESULT_AMOUNT,0) ROW_RESULT_AMOUNT,
                ISNULL((SELECT
                    SUM(POR_.AMOUNT) ORDER_AMOUNT
                FROM
                    PRODUCTION_ORDER_RESULTS_ROW POR_,
                    PRODUCTION_ORDER_RESULTS POO
                WHERE
                    POR_.PR_ORDER_ID = POO.PR_ORDER_ID
                    AND POO.P_ORDER_ID = PO.P_ORDER_ID
                    AND POR_.TYPE = 1
                    AND POR_.SPEC_MAIN_ID IN (SELECT PRODUCTION_ORDERS.SPEC_MAIN_ID FROM PRODUCTION_ORDERS WHERE PRODUCTION_ORDERS.P_ORDER_ID = POO.P_ORDER_ID)
                ),0) RESULT_AMOUNT
            FROM
                PRODUCTION_ORDERS PO,
                STOCKS S,
                PRODUCT P
            WHERE
                PO.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd#"> AND
                PO.STOCK_ID = S.STOCK_ID AND
                S.PRODUCT_ID = P.PRODUCT_ID
        </cfquery>
        <cfif GET_DET_PO.recordcount>    
            <cfset attributes.IS_PRODUCTION = GET_DET_PO.IS_PRODUCTION>
            <cfset attributes.IS_PROTOTYPE = GET_DET_PO.IS_PROTOTYPE>
            <cfset attributes.STOCK_ID = GET_DET_PO.STOCK_ID>
            <cfset attributes.STATION_ID = GET_DET_PO.STATION_ID>
            <cfset attributes.DEMAND_NO = GET_DET_PO.DEMAND_NO>
            <cfset attributes.PO_RELATED_ID = GET_DET_PO.PO_RELATED_ID>
            <cfset attributes.ORDER_ID = GET_DET_PO.ORDER_ID>
            <cfset attributes.QUANTITY = GET_DET_PO.QUANTITY>
            <cfset attributes.P_ORDER_NO = GET_DET_PO.P_ORDER_NO>
            <cfset attributes.START_DATE = GET_DET_PO.START_DATE>
            <cfset attributes.FINISH_DATE = GET_DET_PO.FINISH_DATE>
            <cfset attributes.STATUS = GET_DET_PO.STATUS>
            <cfset attributes.IS_STOCK_RESERVED = GET_DET_PO.IS_STOCK_RESERVED>
            <cfset attributes.IS_DEMONTAJ = GET_DET_PO.IS_DEMONTAJ>
            <cfset attributes.PROD_ORDER_STAGE = GET_DET_PO.PROD_ORDER_STAGE>
            <cfset attributes.LOT_NO = GET_DET_PO.LOT_NO>
            <cfset attributes.PROJECT_ID = GET_DET_PO.PROJECT_ID>
            <cfset attributes.REFERENCE_NO = GET_DET_PO.REFERENCE_NO>
            <cfset attributes.SPECT_MAIN_ID = GET_DET_PO.SPEC_MAIN_ID>
            <cfset attributes.SPECT_VAR_ID = GET_DET_PO.SPECT_VAR_ID>
            <cfset attributes.SPECT_VAR_NAME = GET_DET_PO.SPECT_VAR_NAME>
            <cfset attributes.DETAIL = GET_DET_PO.DETAIL>
            <cfset attributes.DP_ORDER_ID = GET_DET_PO.DP_ORDER_ID>
            <cfset attributes.PRINT_COUNT = GET_DET_PO.PRINT_COUNT>
            <cfset attributes.IS_STAGE = GET_DET_PO.IS_STAGE>
            <cfset attributes.PROPERTY = GET_DET_PO.PROPERTY>
            <cfset attributes.PRODUCT_NAME = GET_DET_PO.PRODUCT_NAME>
            <cfset attributes.PRODUCT_ID = GET_DET_PO.PRODUCT_ID>
            <cfset attributes.STOCK_ID = GET_DET_PO.STOCK_ID>
            <cfset attributes.STOCK_CODE = GET_DET_PO.STOCK_CODE>
            <cfset attributes.ROW_RESULT_AMOUNT = GET_DET_PO.ROW_RESULT_AMOUNT>
            <cfset attributes.RESULT_AMOUNT = GET_DET_PO.RESULT_AMOUNT>
            <cfset attributes.PRODUCT_UNIT_ID = GET_DET_PO.PRODUCT_UNIT_ID>
            <cfset attributes.WRK_ROW_RELATION_ID = GET_DET_PO.WRK_ROW_RELATION_ID>
            <cfquery name="GET_ORDER_ROW" datasource="#DSN3#">
                SELECT DISTINCT
                    ORDERS.ORDER_ID,
                    ORDERS.ORDER_NUMBER
                FROM
                    ORDERS,
                    PRODUCTION_ORDERS_ROW
                WHERE
                    PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd#"> AND
                    PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID
            </cfquery>
            <cfif GET_ORDER_ROW.RECORDCOUNT>
                <cfset attributes.order_id = GET_ORDER_ROW.ORDER_ID>
                <cfset attributes.ORDER_NUMBER = GET_ORDER_ROW.ORDER_number>
                <cfquery name="GET_ORDER_ROW_1" datasource="#DSN3#">
                    SELECT
                        ORDER_ROW.ORDER_ROW_ID,
                        ORDER_ROW.SPECT_VAR_ID,
                        ORDER_ROW.SPECT_VAR_NAME
                    FROM
                        ORDER_ROW
                    WHERE
                        ORDER_ROW.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_ORDER_ROW.ORDER_ID#"> AND
                        ORDER_ROW.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.STOCK_ID#"> 
                </cfquery>
                <cfset attributes.order_row_id_ = GET_ORDER_ROW_1.ORDER_ROW_ID>
            </cfif>
            <cfif len(attributes.PRODUCT_UNIT_ID)>
                <cfquery name="GET_UNIT" datasource="#DSN3#">
                    SELECT  
                        S.UNIT
                    FROM 
                        PRODUCT_UNIT P,
                        #DSN_ALIAS#.SETUP_UNIT S
                    WHERE 
                        P.UNIT_ID = S.UNIT_ID AND
                        P.PRODUCT_UNIT_ID = #attributes.PRODUCT_UNIT_ID#
                </cfquery>
                <cfset attributes.unit_name = get_unit.unit>
            </cfif>
            <cfif len(attributes.STATION_ID)>
                <cfquery name="get_station" datasource="#dsn3#">
                    SELECT STATION_NAME FROM WORKSTATIONS WHERE STATION_ID = #attributes.STATION_ID#
                </cfquery>
                <cfset attributes.station_name = get_station.STATION_NAME>
            </cfif>
        </cfif>
    </cfif>
    <cf_papers paper_type="prod_order">
    <cfif isdefined("attributes.order_row_id")>
        <cfquery name="GET_AMOUNT" datasource="#DSN3#">
            SELECT
                CASE WHEN (QUANTITY-ISNULL((SELECT SUM(QUANTITY) FROM PRODUCTION_ORDERS WHERE P_ORDER_ID IN(SELECT PRODUCTION_ORDER_ID FROM PRODUCTION_ORDERS_ROW WHERE PRODUCTION_ORDERS_ROW.ORDER_ROW_ID = ORDER_ROW.ORDER_ROW_ID)),0))< 0
                THEN QUANTITY 
                ELSE 
                (QUANTITY-ISNULL((SELECT SUM(QUANTITY) FROM PRODUCTION_ORDERS WHERE P_ORDER_ID IN(SELECT PRODUCTION_ORDER_ID FROM PRODUCTION_ORDERS_ROW WHERE PRODUCTION_ORDERS_ROW.ORDER_ROW_ID = ORDER_ROW.ORDER_ROW_ID)),0)) END
                QUANTITY,
                ORDERS.PROJECT_ID,
                ORDERS.ORDER_NUMBER,
                ORDERS.ORDER_DETAIL,
                ORDER_ROW.SPECT_VAR_ID,
                ORDERS.DELIVERDATE AS DELIVER_DATE,
                ORDER_ROW.STOCK_ID,
                STOCKS.PRODUCT_NAME,
                STOCKS.IS_PROTOTYPE
            FROM
                ORDER_ROW,
                ORDERS,
                STOCKS
            WHERE 
                ORDER_ROW.ORDER_ROW_ID IN(#attributes.order_row_id#) AND
                ORDER_ROW.ORDER_ID = ORDERS.ORDER_ID AND
                STOCKS.STOCK_ID = ORDER_ROW.STOCK_ID
        </cfquery>
        <cfif GET_AMOUNT.recordcount>
            <cfquery name="get_min_order_date" dbtype="query"><!--- Birden fazla sipariş geliyorsa teslim tarihi bu siparişlerin en erkenine alınıyor. --->
                SELECT MIN(DELIVER_DATE) AS DELIVER_DATE FROM GET_AMOUNT WHERE  DELIVER_DATE > #NOW()#
            </cfquery>
            <cfset all_quantity= 0>
            <cfloop query="GET_AMOUNT"><cfset all_quantity = all_quantity + quantity></cfloop>
            <cfset attributes.start_date =date_add('h',session.ep.time_zone,now())>
            <cfif get_min_order_date.recordcount>
                <cfset GET_AMOUNT.deliver_date = get_min_order_date.DELIVER_DATE>
            <cfelse>
                <cfset GET_AMOUNT.deliver_date = date_add('d',1,now())>
            </cfif>
            <cfset GET_AMOUNT.quantity = all_quantity>
            <cfset GET_AMOUNT.order_number = ValueList(GET_AMOUNT.ORDER_NUMBER,',')>
            <cfquery name="get_product_station" datasource="#dsn3#">
                SELECT
                    (SELECT STATION_NAME FROM WORKSTATIONS WHERE STATION_ID =WSP.WS_ID) AS STATION_NAME,
                    WS_ID
                FROM 
                    WORKSTATIONS_PRODUCTS WSP
                WHERE 
                    STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_AMOUNT.STOCK_ID#">
            </cfquery>
            <cfif get_product_station.recordcount>
                <cfset attributes.station_id= get_product_station.WS_ID>
                <cfset attributes.station_name= get_product_station.STATION_NAME>
            </cfif>
        </cfif>
    </cfif>
<cfelseif listfind('updorder,upddemand',attributes.event)>  
	<cf_xml_page_edit fuseact="prod.add_prod_order">
	<cfif not isnumeric(attributes.upd)>
        <cfset hata  = 10>
        <cfinclude template="../dsp_hata.cfm">
        <cfabort>
    </cfif>
    <cfquery name="get_tree_xml_amount" datasource="#dsn#">
        SELECT 
            PROPERTY_VALUE,
            PROPERTY_NAME
        FROM
            FUSEACTION_PROPERTY
        WHERE
            OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            FUSEACTION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="prod.add_product_tree"> AND
            PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="is_show_prod_amount">
    </cfquery>
    <cfif get_tree_xml_amount.recordcount>
        <cfset is_show_prod_amount = get_tree_xml_amount.PROPERTY_VALUE>
    <cfelse>
        <cfset is_show_prod_amount = 1>
    </cfif>
    <cfquery name="GET_DET_PO" datasource="#DSN3#">
        SELECT
            P.IS_PRODUCTION,
            P.IS_PROTOTYPE,
            PO.P_ORDER_ID,
            PO.STOCK_ID,
            PO.STATION_ID,
            PO.DEMAND_NO,
            PO.PO_RELATED_ID,
            PO.ORDER_ID,
            PO.QUANTITY,
            PO.P_ORDER_NO,
            PO.START_DATE,
            PO.FINISH_DATE,
            PO.STATUS,
            PO.IS_STOCK_RESERVED,
            PO.IS_DEMONTAJ,
            PO.PROD_ORDER_STAGE,
            PO.LOT_NO,
            PO.PROJECT_ID,
            PO.REFERENCE_NO,
            PO.SPEC_MAIN_ID,
            PO.SPECT_VAR_ID,
            PO.SPECT_VAR_NAME,
            PO.DETAIL,
            PO.DP_ORDER_ID,
            PO.RECORD_EMP,
            PO.RECORD_DATE,
            PO.UPDATE_EMP,
            PO.UPDATE_DATE,
            PO.PRINT_COUNT,
            PO.IS_STAGE,
            PO.WORK_ID,
            S.PROPERTY,
            P.PRODUCT_NAME,
            P.PRODUCT_ID,
            S.STOCK_ID,
            S.STOCK_CODE,
            ISNULL(PO.RESULT_AMOUNT,0) ROW_RESULT_AMOUNT,
            ISNULL((SELECT SUM(POR_.AMOUNT) ORDER_AMOUNT
            FROM
                PRODUCTION_ORDER_RESULTS_ROW POR_,
                PRODUCTION_ORDER_RESULTS POO
            WHERE
                POR_.PR_ORDER_ID = POO.PR_ORDER_ID AND 
                POO.P_ORDER_ID = PO.P_ORDER_ID AND 
                POR_.TYPE = 1 AND 
                POR_.SPEC_MAIN_ID IN (SELECT PRODUCTION_ORDERS.SPEC_MAIN_ID FROM PRODUCTION_ORDERS WHERE PRODUCTION_ORDERS.P_ORDER_ID = POO.P_ORDER_ID)
            ),0) RESULT_AMOUNT
        FROM
            PRODUCTION_ORDERS PO,
            STOCKS S,
            PRODUCT P
        WHERE
            PO.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd#"> AND
            PO.STOCK_ID = S.STOCK_ID AND
            S.PRODUCT_ID = P.PRODUCT_ID
    </cfquery>
    <cfif not get_det_po.recordcount>
        <cfset hata  = 10>
        <cfinclude template="../dsp_hata.cfm">
        <cfabort>
    </cfif>
    <cfscript>
        attributes.stock_id = get_det_po.stock_id;
    </cfscript>
    <cfinclude template="../production_plan/query/get_station_infos.cfm">
    <cfinclude template="../production_plan/query/get_pr_order_id.cfm">
    <cfquery name="GET_ORDER_ROW" datasource="#DSN3#">
        SELECT DISTINCT
            ORDERS.ORDER_ID,
            ORDERS.ORDER_NUMBER,
            ORDER_ROW.ORDER_ROW_ID
        FROM
            ORDERS,
            PRODUCTION_ORDERS_ROW
                LEFT JOIN ORDER_ROW ON PRODUCTION_ORDERS_ROW.ORDER_ROW_ID =  ORDER_ROW.ORDER_ROW_ID
        WHERE
            PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd#"> AND
            PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID
    </cfquery>
    <cfif len(get_order_row.order_row_id)>
        <cfquery name="GET_ORDER_ROW_1" datasource="#DSN3#">
            SELECT
                ORDER_ROW_ID,
                SPECT_VAR_ID,
                SPECT_VAR_NAME,
                DELIVER_DATE
            FROM
                ORDER_ROW
            WHERE
                ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_row.order_id#"> AND
                STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#"> AND
                ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_row.order_row_id#">
        </cfquery>
    </cfif>
    <cfquery name="GET_ORDER_RESULT" datasource="#DSN3#"><!--- Sonuç girilip girilmediğini kontrolü için kullanılıyor. --->
        SELECT
            PR_ORDER_ID,
            START_DATE,
            FINISH_DATE,
            RESULT_NO,
            POSITION_ID,
            STATION_ID
        FROM
            PRODUCTION_ORDER_RESULTS
        WHERE
            P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd#">
    </cfquery>
    <!--- Üretimin altında ilişkili olan üretim emri varmı diye bakıyoru,eğer varsa üretim içinde ürün ve spec değişimlerini yaptırmayacağız.Şimdilik böyle yapıyoruz eğer istek olursa
    üretim emri ekleme sayfasında olduğu gibi bir ajax ile alt bileşenlerini gösterip ona göre üretim emrini silip seçilen yeni ürün ve spec'e göre üretim emrini güncelliyeceğiz..! M.ER 24102008
     --->
    <cfset prod_and_spec_disp = ''>
    <cfquery name="GET_PRODUCTION_ORDERS_RELATED" datasource="#DSN3#">
        SELECT TOP 1 P_ORDER_ID FROM PRODUCTION_ORDERS WHERE PO_RELATED_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd#">
    </cfquery>
    <cfif GET_PRODUCTION_ORDERS_RELATED.recordcount>
        <cfset prod_and_spec_disp = 'style="display:none;"'>
    </cfif>
    <cfif len(GET_DET_PO.DEMAND_NO) and GET_DET_PO.IS_STAGE eq -1 and GET_DET_PO.IS_STOCK_RESERVED eq 0><cfset is_demand = 1></cfif>
    <cfif isdate(get_det_po.START_DATE) and IsDate(get_det_po.FINISH_DATE)><cfset date_control = 1><cfelse><cfset date_control =0></cfif>
</cfif>

<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<script type="text/javascript">
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
		
		function pencere_ac_employee(no)
		{
			//row_id_ = p_order_id+'_'+stock_id+'_'+no;
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=convert_demand_to_production.employee_id_' + no +'&field_name=convert_demand_to_production.employee_name_' + no +'&select_list=1,9','list');
		}
		
		function convert_to_excel()
		{		
			document.search_list.is_excel.value = 1;
			search_list.action='<cfoutput>#request.self#?fuseaction=prod.#fuseaction_#&event=excel</cfoutput>';
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
		function connectAjax(crtrow,p_order_id,prod_id,stock_id,order_amount,spect_main_id)
		{
			var bb = '<cfoutput>#request.self#?fuseaction=objects.emptypopup_ajax_product_stock_info&deep_level_max=1&tree_stock_status=1</cfoutput>&p_order_id='+p_order_id+'&pid='+prod_id+'&sid='+ stock_id+'&amount='+order_amount+'&spect_main_id='+spect_main_id;
			AjaxPageLoad(bb,'DISPLAY_ORDER_STOCK_INFO'+crtrow,1);
		}
		
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
                                                alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no ='1447.Süreç'>");
                                                return false;
                                            }
                                            user_message='<cf_get_lang no ="264.Talepler Güncelleniyor Lütfen Bekleyiniz">!';
                                        }
                                        else if(type==5)
                                        {
                                            var selected_process_ = document.convert_demand_to_production.process_stage.value;
                                            if(selected_process_=='')
                                            {
                                                alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no ='1447.Süreç'>");
                                                return false;
                                            }
                                            user_message='<cf_get_lang no="678.Emirler Güncelleniyor Lütfen Bekleyiniz"> !';
                                        }
                                        else if(type==6)
                                        {
                                            var selected_process_ = document.convert_demand_to_production.process_stage.value;
                                            if(selected_process_=='')
                                            {
                                                alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no ='1447.Süreç'>");
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
                                    //    AjaxFormSubmit(convert_demand_to_production,'user_message_demand',1,user_message,'<cf_get_lang_main no ="1374.Tamamlandı">!','','',1);
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
<cfelseif listfind('addorder,adddemand,adddemandCollacted',attributes.event)>  
	<cfoutput>
	<script type="text/javascript">
		<cfif isdefined("attributes.order_row_id")> <!--- Siparişten geliyorsa bilgilerin doğru olduğu düşünelerek spect ağacını çalıştıralım. --->
			$(document).ready(function(){
				show_product_tree_info();
				});
		</cfif>
		function show_product_tree_info()
		{
			_kontol_ = date_control();
			if(_kontol_ == true)
			_kontol_ = kontrol_form();
			if(_kontol_ == true)
			{
				var spect_var_id = list_getat(document.getElementById('spect_var_id').value,1,',');
				var spect_main_id = list_getat(document.getElementById('spect_main_id').value,1,',');
				if(document.getElementById('po_related_id')!= undefined)
					var po_related_id = document.getElementById('po_related_id').value;
				else
					var po_related_id = '';
				project_id_ = document.getElementById('project_id').value;
				var order_id = document.getElementById('order_id').value;
				var order_row_id = document.getElementById('order_row_id').value;
				var quantity = filterNum(document.getElementById('quantity').value,8);
				var stock_id = document.getElementById('stock_id').value;
				var start_m = document.getElementById('start_m').value;
				var start_h = document.getElementById('start_h').value;
				var finish_h = document.getElementById('finish_h').value;
				var finish_m = document.getElementById('finish_m').value;
				var start_date = document.getElementById('start_date').value;
				var deliver_date = document.getElementById('finish_date').value;
				var finish_date = document.getElementById('finish_date').value;
				if(document.getElementById('detail').value.indexOf("'") > -1)
					document.getElementById('detail').value = document.getElementById('detail').value.split("'").join(' ');
				var detail = document.getElementById('detail').value;
				var work_id = document.getElementById('work_id').value;
				var work_head = document.getElementById('work_head').value;
				if(document.getElementById('copy_demand_no')!= undefined)
					var demand_no = document.getElementById('copy_demand_no').value;
				else
					var demand_no = '';
				if(document.getElementById('wrk_row_relation_id')!= undefined)
					var wrk_row_relation_id = document.getElementById('wrk_row_relation_id').value;
				else
					var wrk_row_relation_id = '';
				var url_str = '&demand_no='+demand_no+'&wrk_row_relation_id='+wrk_row_relation_id+'&project_id='+project_id_+'&po_related_id='+po_related_id+'&spect_main_id='+spect_main_id+'&deliver_date='+deliver_date+'&start_date='+start_date+'&stock_id='+stock_id+'&order_row_id='+order_row_id+'&order_amount='+quantity+'&order_id='+order_id+'&spect_var_id='+spect_var_id+'';
					url_str +='&start_m='+start_m+'&start_h='+start_h+'&finish_h='+finish_h+'&finish_m='+finish_m+'&detail='+detail+'&finish_date='+finish_date+'&work_id='+work_id+'&work_head='+work_head+''; 
			AjaxPageLoad('#request.self#?fuseaction=prod.order&event=addorderAjax<cfif isdefined('attributes.is_demand') and attributes.is_demand eq 1>&is_demand=1</cfif>&#xml_str#'+url_str+'','PRODUCT_TREE',1);
				return false;
			}
		}
		function temizle_spect()
		{
			document.all.spect_main_id.value="";
			document.all.spect_var_id.value="";
			document.all.spect_var_name.value="";
		}
		function open_spec(row_info)
		{
			if(row_info == undefined)
			{
				if(document.getElementById('stock_id').value.length > 0 && document.getElementById('product_name').value.length > 0){
					if(document.getElementById('spect_var_id').value == "" && document.getElementById('spect_main_id').value == "")	
					windowopen('#request.self#?fuseaction=objects.popup_add_spect_list#money_str#&field_main_id=spect_main_id&field_name=spect_var_name&field_id=spect_var_id&stock_id='+document.getElementById('stock_id').value+'','project');
					else if(document.getElementById('spect_var_id').value == "")	
						windowopen('#request.self#?fuseaction=objects.popup_list_spect_main&is_from_prod_order=1&main_to_add_spect=1&basket_id=1&field_name=add_production_order.spect_var_name&field_main_id=add_production_order.spect_main_id&field_id=add_production_order.spect_var_id&create_main_spect_and_add_new_spect_id=1&stock_id='+document.getElementById('stock_id').value,'project');
					else if(document.getElementById('spect_var_id').value != "")	
						windowopen('#request.self#?fuseaction=objects.popup_upd_spect&create_main_spect_and_add_new_spect_id=1&field_name=spect_var_name&field_id=spect_var_id&field_main_id=spect_main_id&id='+document.getElementById('spect_var_id').value+'&stock_id='+document.getElementById('stock_id').value,'project');
				}	
				else
					alert("<cf_get_lang_main no='782.Zorunlu alan'> : <cf_get_lang_main no ='245.Ürün'>");
			}
			else
			{
				if(document.getElementById('stock_id'+row_info).value.length > 0 && document.getElementById('product_name'+row_info).value.length > 0){
					if(document.getElementById('spect_var_id'+row_info).value == "" && document.getElementById('spect_main_id'+row_info).value == "")	
					windowopen('#request.self#?fuseaction=objects.popup_add_spect_list#money_str#&field_main_id=spect_main_id&field_name=spect_var_name&field_id=spect_var_id&stock_id='+document.getElementById('stock_id'+row_info).value+'','project');
					else if(document.getElementById('spect_var_id'+row_info).value == "")	
						windowopen('#request.self#?fuseaction=objects.popup_list_spect_main&main_to_add_spect=1&basket_id=1&field_name=add_production_order.spect_var_name'+row_info+'&field_main_id=add_production_order.spect_main_id'+row_info+'&field_id=add_production_order.spect_var_id'+row_info+'&create_main_spect_and_add_new_spect_id=1&stock_id='+document.getElementById('stock_id'+row_info).value,'project');
					else if(document.getElementById('spect_var_id'+row_info).value != "")	
						windowopen('#request.self#?fuseaction=objects.popup_upd_spect&create_main_spect_and_add_new_spect_id=1&field_name=spect_var_name'+row_info+'&field_id=spect_var_id'+row_info+'&field_main_id=spect_main_id'+row_info+'&id='+document.getElementById('spect_var_id'+row_info).value+'&stock_id='+document.getElementById('stock_id'+row_info).value,'project');
				}	
				else
					alert("<cf_get_lang_main no='782.Zorunlu alan'> : <cf_get_lang_main no ='245.Ürün'>");
			}
		}
		function kontrol_form()
		{ 
			if(document.getElementById('stock_id').value == "")
			{
				alert("<cf_get_lang_main no='782.Zorunlu alan'> : <cf_get_lang_main no ='245.Ürün'>");
				return false;
			}
			if(document.getElementById('quantity').value == "")
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no ='223.Miktar'>!");
				return false;
			}
			if((document.getElementById('station_id_1_0').value == ""))
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no ='1422.İstasyon'>");
				return false;
			}
			
			
			<cfif is_station_amount_kontrol eq 1>
				var listParam = document.getElementById('stock_id').value + "*" + document.getElementById('station_id_1_0').value ;
				var get_station = wrk_safe_query("prdp_get_station_2",'dsn3',0,listParam);
				if(get_station.recordcount > 0 && get_station.MIN_PRODUCT_AMOUNT > 0)
				{
					if(get_station.MIN_PRODUCT_AMOUNT <= parseFloat(filterNum(document.getElementById('quantity').value)))
					{
						_production_type = get_station.PRODUCTION_TYPE;
						if(_production_type == 1 && (filterNum(document.getElementById('quantity').value)%get_station.MIN_PRODUCT_AMOUNT)!= 0)
						{//üretim tipi katları şeklinde girilmişse verilen üretim miktarı istasyonun üretim miktarının katları şeklinde olmlıdır.
							alert("<cf_get_lang no ='558.Bu İstasyonda Üretilecek Ürününün Miktarı'> "+ get_station.MIN_PRODUCT_AMOUNT +" <cf_get_lang no ='559.ve Katları Şeklinde Girilmelidir'> !");
							return false;
						}	
					}
					else if(get_station.MIN_PRODUCT_AMOUNT < parseFloat(filterNum(document.getElementById('quantity').value)))
					{
						alert("<cf_get_lang no ='560.Miktar,İstasyonun Min Üretim Miktarından Küçük Olamaz'> !");
						return false;
					}
				}
			</cfif>
			return true;
		}
		function pencere_ac_work()
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_work&field_id=all.work_id&field_name=all.work_head','list');
		}
		
		function date_control()
		{
			<cfif is_time_calculation eq 0 and not (isdefined('attributes.is_demand') and attributes.is_demand eq 1)>
			if((document.getElementById('start_date').value != "") && (document.getElementById('finish_date').value != ""))
			return time_check(document.getElementById('start_date'), document.getElementById('start_h'), document.getElementById('start_m'), document.getElementById('finish_date'),  document.getElementById('finish_h'), document.getElementById('finish_m'), "<cf_get_lang no ='605.Üretim Başlama Tarihi,Bitiş Tarihinden Önce Olmalıdır'> !");
			else if((document.getElementById('start_date').value == ""))
			{
				alert("<cf_get_lang_main no='782.Zorunlu alan'> : <cf_get_lang_main no='89.başlangıç'>  <cf_get_lang_main no ='1181.tarihi'>");
			return false;
			}
			else if((document.getElementById('finish_date').value == ""))
			{
				alert("<cf_get_lang_main no='782.Zorunlu alan'> : <cf_get_lang_main no='90.Bitiş'> <cf_get_lang_main no ='1181.tarihi'>");
				return false;
			}
			</cfif>
			return true;
		}
		function station_stock_control(type)
		{
			<cfif isdefined('is_product_station_relation') and is_product_station_relation eq 1>
				if(document.getElementById('stock_id').value ==""){
					document.getElementById('station_id_1_0').value = "";
					document.getElementById('station_name').value = "";
					alert("<cf_get_lang no ='518.Önce Ürün Seçiniz'>!");
					return false;
				  }
				
				else{
					if(type==1){
					var my_deger ="get_auto_complete('get_station','station_name','STATION_NAME','station_id_1_0','STATION_ID','show_station','25','"+document.getElementById('stock_id').value+"',0,'','','function_value_station');"
					document.getElementById('function_value_station').value = my_deger;
					eval(my_deger);		
					}
					else if(type==2)
						windowopen('#request.self#?fuseaction=prod.popup_list_workstation&field_name=add_production_order.station_name&field_id=add_production_order.station_id_1_0&c=1&stock_id='+document.getElementById('stock_id').value+'','list');
					}
				
			<cfelse>
					if(type==1)
					{
					var my_deger ="get_auto_complete('get_station','station_name','STATION_NAME','station_id_1_0','STATION_ID','show_station','25','',0,'','','function_value_station');"
					document.getElementById('function_value_station').value = my_deger;
					eval(my_deger);		
					}
					else if(type==2)
						windowopen('#request.self#?fuseaction=prod.popup_list_workstation&field_name=add_production_order.station_name&field_id=add_production_order.station_id_1_0&c=1','list');
			</cfif>
		}
		function open_product_tree(){
			if(document.getElementById('stock_id').value != "" && document.getElementById('product_name').value != "")
				windowopen('#request.self#?fuseaction=prod.list_product_tree&event=upd&stock_id='+document.getElementById('stock_id').value+'','list_horizantal');
			else
				alert('<cf_get_lang no="518.Önce Ürün Seçiniz">');
		}
		function get_product_main_spec(type){
			if(document.getElementById('stock_id').value != "" && document.getElementById('product_name').value != ""){
				//type'in undefined oplması demek autocompleteden geldiği anlamına geliyor,autocomplete sadece ürün adı ve id'sini düşürdüğü için burda tekrardan çekiyoruz.Ancak ürün popup'undan düşürdüğümüz zaman ise
				//spec_main_id de düştüğü için bu bloğa sokmuyoruz sadece istasyonunu seçili getiriyoruz.
				if(type == undefined){
					var get_main_spec_id = wrk_safe_query('prdp_get_main_spec_id','dsn3',0,document.getElementById('stock_id').value);
					if(get_main_spec_id.recordcount){
						document.getElementById('spect_main_id').value = get_main_spec_id.SPECT_MAIN_ID ;
						document.getElementById('spect_var_name').value = get_main_spec_id.SPECT_MAIN_NAME ;
					}
					else{
						document.getElementById('spect_main_id').value = "";
						document.getElementById('spect_var_name').value = "";
					}
				}
				
				var get_product_station = wrk_safe_query('prdp_get_product_station','dsn3',0,document.getElementById('stock_id').value);
				if(get_product_station.recordcount){
					document.getElementById('station_id_1_0').value = get_product_station.STATION_ID ;
					document.getElementById('station_name').value = get_product_station.STATION_NAME ;
				}
				else{
					document.getElementById('station_id_1_0').value = "" ;
					document.getElementById('station_name').value = "";
				}
			}	
			else
				alert('<cf_get_lang no="518.Önce Ürün Seçiniz">');
		}
		function calc_deliver_date()
		{
			stock_id_list = '';
			var row_c = document.getElementsByName('stock_id').length;
			if(row_c != 0)
			{
				if(document.getElementById('quantity').value == "")
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no ='223.Miktar'>!");
					return false;
				}
				else
				{
					var n_stock_id =document.all.stock_id.value;
					var n_amount = filterNum(document.all.quantity.value,6);
					var n_spect_id = document.all.spect_var_id.value;
					var n_is_production = 1;
					if(n_spect_id == "") n_spect_id =0;
					if(n_stock_id != "" && n_is_production ==1)//ürün silinmemiş ise
						stock_id_list +=n_stock_id+'-'+n_spect_id+'-'+n_amount+'-'+n_is_production+',';
					document.getElementById('deliver_date_info').style.display='';
					AjaxPageLoad('#request.self#?fuseaction=prod.popup_ajax_deliver_date_calc&from_p_order_list=1&is_from_order=1&stock_id_list='+stock_id_list+'','deliver_date_info',1,"<cf_get_lang no ='170.Tarih Hesaplanıyor'>");
				}
			}
			else
				alert("<cf_get_lang_main no='782.Zorunlu alan'> : <cf_get_lang_main no ='245.Ürün'>");	
		}
	</script>
	</cfoutput>
<cfelseif listfind('updorder,upddemand',attributes.event)>  
	<script type="text/javascript">
        function date_control()
        {   
            if($('#start_date').val() != "" && $('#finish_date').val() != "")
                return time_check(document.getElementById('start_date'), document.getElementById('start_h'), document.getElementById('start_m'), document.getElementById('finish_date'),  document.getElementById('finish_h'), document.getElementById('finish_m'), "<cf_get_lang no ='605.Üretim Başlama Tarihi,Bitiş Tarihinden Önce Olmalıdır'>!");
            else
                {alert("<cf_get_lang no ='553.Başlangıç ve Bitiş Tarihini Düzgün Giriniz'>");return false;}
        }
        
        function unformat_fields()
        {
            _kontol_ = date_control();
            if(_kontol_ == true)
            {
                if($('#stock_id').val() == "")
                {
                    alert("<cf_get_lang no='461.Lütfen Ürün Seçiniz'> !");
                    return false;
                }
                
                if($('#station_id').val() == "")// && (add_production_order.route_id.value == "")
                {
                    alert("<cf_get_lang no='477.İstasyon Seçmek Zorundasınız'> !");
                    return false;
                }
                <cfif is_station_amount_kontrol eq 1>
                    var listParam = add_production_order.stock_id.value + "*" +  add_production_order.station_id.value
                    var get_station = wrk_safe_query("prdp_get_station_2",'dsn3',0,listParam);
                    if(get_station.recordcount > 0 && get_station.MIN_PRODUCT_AMOUNT > 0)
                    {
                        if(filterNum(document.getElementById('quantity').value) < get_station.MIN_PRODUCT_AMOUNT)
                        {
                            alert("İstasyon Tanımlarındaki Minimum Üretim Miktarından Az Üretim Emri Veremezsiniz !");
                            return false;
                        }
                    }
                </cfif>
                if($('#p_order_no'))
                {
                    var listParam = $('#p_order_no').val() + "*" + "<cfoutput>#attributes.upd#</cfoutput>";
                    var paper_number= wrk_safe_query("prdp_paper_number",'dsn3',0,listParam);
                    if(paper_number.recordcount) // ayni uretim varsa uyari ver FB20080704
                    {
                        alert("<cf_get_lang no ='554.Bu Üretim Numarasına Ait Kayıt Vardır Lütfen Kontrol Ediniz'> !");
                        return false;
                    }
                }
                var stock_id_exit_list = "";
                for (var k=1;k<=row_count_exit;k++)
                {
                    if($('#row_kontrol_exit'+k).val() == 1)
                    {
                        stock_id_exit_list+=$('#stock_id_exit'+k).val()+",";
                    }
                }
                var stock_id_outage_list = "";
                for (var k=1;k<=row_count_outage;k++)
                {
                    if($('#row_kontrol_outage'+k).val() == 1)
                    {
                        stock_id_outage_list+=$('#stock_id_outage'+k).val()+",";
                    }
                }
                return process_cat_control();
            }
            else{
            return false;}
		return true;
        }
        function calc_deliver_date()
        {
            stock_id_list = '';
            var row_c = $('#stock_id').length;
            if(row_c != 0)
            {
                if($('#quantity').val() == "")
                {
                    alert("<cf_get_lang no ='73.Miktar Giriniz'>!");
                    return false;
                }
                else
                {
                    var n_stock_id = $('#stock_id').val();
                    var n_amount = filterNum($('#quantity').val(),6);
                    var n_spect_id = $('#spect_var_id').val();
                    var n_is_production = 1;
                    if(n_spect_id == "") n_spect_id =0;
                    if(n_stock_id != "" && n_is_production ==1)//ürün silinmemiş ise
                        stock_id_list +=n_stock_id+'-'+n_spect_id+'-'+n_amount+'-'+n_is_production+',';
                    $('#deliver_date_info').show();
                    //document.getElementById('deliver_date_info').style.display='';
                    AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=prod.popup_ajax_deliver_date_calc&is_from_order=1&from_p_order_list=1&stock_id_list='+stock_id_list+'','deliver_date_info',1,"<cf_get_lang no ='170.Tarih Hesaplanıyor'>");
                }
            }
            else
                alert("<cf_get_lang no ='364.Ürün Seçmelisiniz'> ");	
        }
        function aktar()
        {
            var sarf_uzunluk = $('#product_sarf_recordcount').val();
            if(sarf_uzunluk>0)
            {
                for (i=1;i<=sarf_uzunluk;i++)
                {
                    if($('#is_free_amount_exit'+i).val() == 0)// && eval("document.getElementById('spect_main_row_exit'+i)").value != ''
                    {
                        <cfif get_det_po.is_demontaj eq 0>
                            var x=parseInt($('#quantity').val());
                            if(x>0)/*Eğer Üretilecek olan ana ürün miktarı 1den büyükse.*/
                            {
								
                                $('#amount_exit'+i).val( (filterNum($('#amount_exit_'+i).val(),8))/(filterNum($('#quantity_').val(),8))*(filterNum($('#quantity').val(),8)) );
    
                                var a = $('#amount_exit'+i).val();
                                var b=commaSplit(a,8);
                                $('#amount_exit'+i).val(b);
                            }	
                        </cfif>
                    }
                    <cfif get_det_po.is_demontaj eq 1>
                        var x=parseInt($('#amount_exit'+1).val());
                        if(x>0)/*Demontaj yapılacak ürün miktarı 1 den fazla ise*/
                            {
                                var get_det_po_quantity = "<cfoutput>#get_det_po.QUANTITY#</cfoutput>";
                                $('#quantity').val( (filterNum($('#quantity_').val(),8)/parseFloat(get_det_po_quantity))*filterNum($('#amount_exit'+1).val(),8) );
                                var a = $('#quantity').val();
                                //var a=document.getElementById('quantity').value=(filterNum(document.getElementById('quantity_').value,8)/parseFloat(<cfoutput>#get_det_po.QUANTITY#</cfoutput>))*filterNum(eval("document.getElementById('amount_exit'+1)").value,8);
                                var b=commaSplit(a,8);
                                $('#quantity').val(b);
                            }
                    </cfif>
                }
            }
            var fire_uzunluk = $('#product_fire_recordcount').val();
            if(fire_uzunluk>0)
            {
                for (i=1;i<=fire_uzunluk;i++)
                {
                    if($('#is_free_amount_outage'+i).val() == 0)// && eval("document.getElementById('spect_main_row_outage'+i)").value != ''
                    {
                        <cfif get_det_po.is_demontaj eq 0>
                            var x=parseInt($('#quantity').val());
                            if(x>0)/*Eğer Üretilecek olan ana ürün miktarı 1den büyükse.*/
                            {
                                $('#amount_outage'+i).val( (filterNum($('#amount_outage_'+i).val(),8))/(filterNum($('#quantity_').val(),8))*(filterNum($('#quantity').val(),8)) );
                                var a = $('#amount_outage'+i).val();
                                var b=commaSplit(a,8);
                                $('#amount_outage'+i).val(b);
                            }	
                        </cfif>
                    }
                }
            }
        }
        function aktar2(type,crnt)
        {
            if(type == 2)
            {
                if($('#amount_exit'+crnt).val() != '')
                    $('#amount_exit_'+crnt).val($('#amount_exit'+crnt).val());
                else
                {
                    $('#amount_exit'+crnt).val(1);
                    $('#amount_exit_'+crnt).val(1);
                }
            }	
            if(type == 3)
            {
                if($('#amount_outage'+crnt).val() != '')
                    $('#amount_outage_'+crnt).val($('#amount_outage'+crnt).val());
                else
                {
                    $('#amount_outage'+crnt).val(1);
                    $('#amount_outage_'+crnt).val(1);
                }
            }	
        }
        function pencere_ac_alternative(no,pid,sid)//sarf ürünlerin alternatiflerini açıyor
        {
            form_stock = $('#stock_id_exit'+no);
            <cfif is_add_alternative_product eq 1>
                //var tree_info_null_ = 1;  1 olarak gönderildiğinde sadece ürün detayındaki alternatifleri getirir.
                url_str='&tree_info_null_=1&product_id=add_production_order.product_id_exit'+no+'&call_function=calc_amount_exit&call_function_paremeter='+no+'&run_function=alternative_product_cost&send_product_id=p_id,'+no+'&field_id=add_production_order.stock_id_exit'+no+'&field_unit_name=add_production_order.unit_exit'+no+'&field_code=add_production_order.stock_code_exit'+no+'&field_name=add_production_order.product_name_exit' + no + '&field_amount=add_production_order.amount_exit' + no + '&field_unit=add_production_order.unit_id_exit'+no+'&stock_id=' + form_stock.val()+'&alternative_product='+pid+'&is_form_submitted=1&is_only_alternative=1';
            <cfelse>
                url_str='&tree_stock_id='+sid+'&product_id=add_production_order.product_id_exit'+no+'&call_function=calc_amount_exit&call_function_paremeter='+no+'&run_function=alternative_product_cost&send_product_id=p_id,'+no+'&field_id=add_production_order.stock_id_exit'+no+'&field_unit_name=add_production_order.unit_exit'+no+'&field_code=add_production_order.stock_code_exit'+no+'&field_name=add_production_order.product_name_exit' + no + '&field_amount=add_production_order.amount_exit' + no + '&field_unit=add_production_order.unit_id_exit'+no+'&stock_id=' + form_stock.val()+'&alternative_product='+pid+'&is_form_submitted=1&is_only_alternative=1';
            </cfif>
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names'+url_str+'','list');
        }
        function pencere_ac_alternative_outage(no,pid,sid)//fire ürünlerin alternatiflerini açıyor
        {
            form_stock = $('#stock_id_outage'+no);
            <cfif is_add_alternative_product eq 1>
                //var tree_info_null_ = 1;  1 olarak gönderildiğinde sadece ürün detayındaki alternatifleri getirir.
                url_str='&tree_info_null_=1&product_id=add_production_order.product_id_outage'+no+'&call_function=calc_amount_outage&call_function_paremeter='+no+'&run_function=alternative_product_cost_outage&send_product_id=p_id,'+no+'&field_id=add_production_order.stock_id_outage'+no+'&field_unit_name=add_production_order.unit_outage'+no+'&field_code=add_production_order.stock_code_outage'+no+'&field_name=add_production_order.product_name_outage' + no + '&field_unit=add_production_order.unit_id_outage'+no+'&field_amount=add_production_order.amount_outage'+no+'&stock_id=' + form_stock.val()+'&alternative_product='+pid+'&is_form_submitted=1&is_only_alternative=1';
            <cfelse>
                url_str='&tree_stock_id='+sid+'&product_id=add_production_order.product_id_outage'+no+'&call_function=calc_amount_outage&call_function_paremeter='+no+'&run_function=alternative_product_cost_outage&send_product_id=p_id,'+no+'&field_id=add_production_order.stock_id_outage'+no+'&field_unit_name=add_production_order.unit_outage'+no+'&field_code=add_production_order.stock_code_outage'+no+'&field_name=add_production_order.product_name_outage' + no + '&field_unit=add_production_order.unit_id_outage'+no+'&field_amount=add_production_order.amount_outage'+no+'&stock_id=' + form_stock.val()+'&alternative_product='+pid+'&is_form_submitted=1&is_only_alternative=1';
            </cfif>
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names'+url_str+'','list');
        }
        
        function alternative_product_cost(pid,no)
        {
            //ürün değiştiği için spectler sıfırlanıyor
            $('#spec_main_id_exit'+no).val("");
            $('#spect_name_exit'+no).val("");
        }
        function alternative_product_cost_outage(pid,no)
        {
            //ürün değiştiği için spectler sıfırlanıyor
            $('#spec_main_id_outage'+no).val("");
            $('#spect_name_outage'+no).val("");
        }
        function get_stok_spec_detail_ajax(product_id)
        {
            goster(prod_stock_and_spec_detail_div);
            tempX = event.clientX + document.body.scrollLeft;
            tempY = event.clientY + document.body.scrollTop;
            document.getElementById('prod_stock_and_spec_detail_div').style.left = tempX+10;
            document.getElementById('prod_stock_and_spec_detail_div').style.top = tempY;
            AjaxPageLoad('<cfoutput>#request.self#?fuseaction=stock.popup_list_product_spects&from_production_result_detail=1&pid='+product_id+'</cfoutput>','prod_stock_and_spec_detail_div',1)	
        }	
        function get_stok_spec_detail_ajax_outage(product_id)
        {
            goster(prod_stock_and_spec_detail_div);
            tempX = event.clientX + document.body.scrollLeft;
            tempY = event.clientY + document.body.scrollTop;
            document.getElementById('prod_stock_and_spec_detail_div').style.left = tempX+10;
            document.getElementById('prod_stock_and_spec_detail_div').style.top = tempY;
            AjaxPageLoad('<cfoutput>#request.self#?fuseaction=stock.popup_list_product_spects&from_production_result_detail=1&pid='+product_id+'</cfoutput>','prod_stock_and_spec_detail_div',1)	
        }	
        function sil_exit(sy)
        {
            var my_element=document.getElementById("row_kontrol_exit"+sy);
			my_element.value=0;
			var my_element=eval("frm_row_exit"+sy);
			my_element.style.display="none";
        }
        function sil_outage(sy)
        {			
            var my_element=document.getElementById("row_kontrol_outage"+sy);
			my_element.value=0;
			var my_element=eval("frm_row_outage"+sy);
			my_element.style.display="none";

        }
		$( document ).ready(function() {
			row_count_exit = 2;
		});       
        
        function add_row_exit(is_add_info_,row_kontrol_exit,is_phantom_exit,is_sevk_exit,is_property_exit,is_free_amount_exit,stock_code_exit,product_id_exit,stock_id_exit,product_name_exit,stock_code_exit,spec_main_id_exit,spect_name_exit,lot_no_exit,amount_exit,unit_id_exit,unit_exit)
        {
            if(is_add_info_==undefined) is_add_info_=1;
            if(row_kontrol_exit==undefined) row_kontrol_exit="";
            if(is_phantom_exit==undefined) is_phantom_exit="";
            if(is_sevk_exit==undefined) is_sevk_exit="";
            if(is_property_exit==undefined) is_property_exit="";
            if(is_free_amount_exit==undefined) is_free_amount_exit="";
            if(stock_code_exit==undefined) stock_code_exit="";
            if(product_id_exit==undefined) product_id_exit="";
            if(stock_id_exit==undefined) stock_id_exit="";
            if(product_name_exit==undefined) product_name_exit="";
            if(stock_code_exit==undefined) stock_code_exit="";
            if(spec_main_id_exit==undefined) spec_main_id_exit="";
            if(spect_name_exit==undefined) spect_name_exit="";
            if(lot_no_exit==undefined) lot_no_exit="";
            if(amount_exit==undefined) amount_exit=1;
            if(unit_id_exit==undefined) unit_id_exit="";
            if(unit_exit==undefined) unit_exit="";
            
            row_count_exit++;
            var newRow;
            var newCell;
            newRow = document.getElementById("table2").insertRow(document.getElementById("table2").rows.length);
            newRow.setAttribute("name","frm_row_exit" + row_count_exit);
            newRow.setAttribute("id","frm_row_exit" + row_count_exit);
            newRow.setAttribute("NAME","frm_row_exit" + row_count_exit);
            newRow.setAttribute("ID","frm_row_exit" + row_count_exit);
            newRow.className = 'color-row';
            document.add_production_order.record_num_exit.value = row_count_exit;
            <cfif isdefined("is_add_product_sarf_fire") and is_add_product_sarf_fire eq 1>
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.innerHTML = '<a style="cursor:pointer" onclick="copy_row_exit('+row_count_exit+');" title="<cf_get_lang_main no="1560.Satır Kopyala">"><img  src="images/copy_list.gif" border="0"></a><a style="cursor:pointer" onclick="sil_exit(' + row_count_exit + ');"><img src="images/delete_list.gif" border="0" align="absmiddle" alt="Sil"></a>';
            </cfif>
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="hidden" name="is_add_info_' + row_count_exit +'" id="is_add_info_' + row_count_exit +'" value="'+is_add_info_+'"><input type="hidden" name="row_kontrol_exit' + row_count_exit +'" id="row_kontrol_exit' + row_count_exit +'" value="1">';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="hidden" name="is_phantom_exit' + row_count_exit +'" id="is_phantom_exit' + row_count_exit +'" value="'+ is_phantom_exit+'"><input type="hidden" name="is_sevk_exit' + row_count_exit +'" id="is_sevk_exit' + row_count_exit +'" value="'+ is_sevk_exit+'"><input type="hidden" name="is_property_exit' + row_count_exit +'" id="is_property_exit' + row_count_exit +'" value="'+ is_property_exit+'"><input type="hidden" name="is_free_amount_exit' + row_count_exit +'" id="is_free_amount_exit' + row_count_exit +'" value="'+ is_free_amount_exit+'"><input type="text" name="stock_code_exit' + row_count_exit +'" id="stock_code_exit' + row_count_exit +'" value="'+stock_code_exit+'" readonly style="width:150px;">';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="hidden" name="product_id_exit' + row_count_exit +'" id="product_id_exit' + row_count_exit +'"  value="'+ product_id_exit+'"><input type="hidden" name="stock_id_exit' + row_count_exit +'" id="stock_id_exit' + row_count_exit +'" value="'+ stock_id_exit+'"><input type="text" name="product_name_exit' + row_count_exit +'" id="product_name_exit' + row_count_exit +'" readonly style="width:280px;" value="'+ product_name_exit+'"></a><a href="javascript://" onClick="pencere_ac_product('+ row_count_exit +');"> <i class="icon-ellipsis"></i></a>';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="spec_main_id_exit' + row_count_exit +'" id="spec_main_id_exit' + row_count_exit +'" readonly style="width:40px;" value="'+ spec_main_id_exit+'"> <input name="spect_name_exit' + row_count_exit +'" id="spect_name_exit' + row_count_exit +'" value="'+ spect_name_exit+'" readonly style="width:200px;">';
            <cfif isdefined("is_show_lot_no") and is_show_lot_no eq 1>
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.innerHTML = '<input type="text" name="lot_no_exit' + row_count_exit +'" id="lot_no_exit' + row_count_exit +'" value="'+ lot_no_exit +'" onKeyup="lotno_control(' + row_count_exit +',2);" style="width:100px;"/> <a href="javascript://" onclick="pencere_ac_list_product(' + row_count_exit +',2);"> <i class="icon-ellipsis"></i></a> ';
            </cfif>
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="amount_exit' + row_count_exit +'" id="amount_exit' + row_count_exit +'" value="'+amount_exit+'" onKeyup="return(FormatCurrency(this,event,8));" class="moneybox" style="width:100px;"><input type="hidden" name="amount_exit_' + row_count_exit +'" id="amount_exit_' + row_count_exit +'" value="'+amount_exit+'" onKeyup="return(FormatCurrency(this,event,8));" class="moneybox" style="width:100px;">';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="hidden" name="unit_id_exit' + row_count_exit +'" id="unit_id_exit' + row_count_exit +'" value="'+ unit_id_exit+'"><input type="text" name="unit_exit' + row_count_exit +'" id="unit_exit' + row_count_exit +'"  value="'+ unit_exit+'" readonly style="width:60px;">';		
        }
        
        
        function copy_row_exit(no_info)
        {
            if ($("#is_add_info_" + no_info) == undefined) is_add_info_ =""; else is_add_info_ = $("#is_add_info_" + no_info).val();
            if ($("#row_kontrol_exit" + no_info) == undefined) row_kontrol_exit =""; else row_kontrol_exit = $("#row_kontrol_exit" + no_info).val();
            if ($("#is_phantom_exit" + no_info) == undefined) is_phantom_exit =""; else is_phantom_exit = $("#is_phantom_exit" + no_info).val();
            if ($("#is_sevk_exit" + no_info) == undefined) is_sevk_exit =""; else is_sevk_exit = $("#is_sevk_exit" + no_info).val();
            if ($("#is_property_exit" + no_info) == undefined) is_property_exit =""; else is_property_exit = $("#is_property_exit" + no_info).val();
            if ($("#is_free_amount_exit" + no_info) == undefined) is_free_amount_exit =""; else is_free_amount_exit = $("#is_free_amount_exit" + no_info).val();
            if ($("#stock_code_exit" + no_info) == undefined) stock_code_exit =""; else stock_code_exit = $("#stock_code_exit" + no_info).val();
            if ($("#product_id_exit" + no_info) == undefined) product_id_exit =""; else product_id_exit = $("#product_id_exit" + no_info).val();
            if ($("#stock_id_exit" + no_info) == undefined) stock_id_exit =""; else stock_id_exit = $("#stock_id_exit" + no_info).val();
            if ($("#product_name_exit" + no_info) == undefined) product_name_exit =""; else product_name_exit = $("#product_name_exit" + no_info).val();
            if ($("#stock_code_exit" + no_info) == undefined) stock_code_exit =""; else stock_code_exit = $("#stock_code_exit" + no_info).val();
            if ($("#spec_main_id_exit" + no_info) == undefined) spec_main_id_exit =""; else spec_main_id_exit = $("#spec_main_id_exit" + no_info).val();
            if ($("#spect_name_exit" + no_info) == undefined) spect_name_exit =""; else spect_name_exit = $("#spect_name_exit" + no_info).val();
            if ($("#lot_no_exit" + no_info) == undefined) lot_no_exit =""; else lot_no_exit = $("#lot_no_exit" + no_info).val();
            if ($("#amount_exit" + no_info) == undefined) amount_exit =""; else amount_exit = $("#amount_exit" + no_info).val();
            if ($("#unit_id_exit" + no_info) == undefined) unit_id_exit =""; else unit_id_exit = $("#unit_id_exit" + no_info).val();
            if ($("#unit_exit" + no_info) == undefined) unit_exit =""; else unit_exit = $("#unit_exit" + no_info).val();
            add_row_exit(is_add_info_,row_kontrol_exit,is_phantom_exit,is_sevk_exit,is_property_exit,is_free_amount_exit,stock_code_exit,product_id_exit,stock_id_exit,product_name_exit,stock_code_exit,spec_main_id_exit,spect_name_exit,lot_no_exit,amount_exit,unit_id_exit,unit_exit);
     }
        
        function pencere_ac_product(no)
        {
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&call_function=calc_amount_exit&call_function_paremeter='+no+'&stock_and_spect=1&product_id=add_production_order.product_id_exit'+no+'&field_id=add_production_order.stock_id_exit'+no+'&field_name=add_production_order.product_name_exit'+no+'&field_code=add_production_order.stock_code_exit'+no+'&field_spect_main_id=add_production_order.spec_main_id_exit'+no+'&field_spect_main_name=add_production_order.spect_name_exit'+no+'&field_unit=add_production_order.unit_id_exit'+no+'&field_unit_name=add_production_order.unit_exit'+no+'&field_amount=add_production_order.amount_exit'+no,'list');
        }
        function calc_amount_exit(no)
        {
            $("#amount_exit" + no).val( filterNum($("#amount_exit" + no).val()) * filterNum($("#amount_exit_" + no).val()));
        }
    
       row_count_outage = 1;
        function add_row_outage(is_add_info_,row_kontrol_outage,is_phantom_outage,is_sevk_outage,is_property_outage,is_free_amount_outage,stock_code_outage,product_id_outage,stock_id_outage,product_name_outage,stock_code_outage,spec_main_id_outage,spect_name_outage,lot_no_outage,amount_outage,unit_id_outage,unit_outage)
        {
            if(is_add_info_==undefined) is_add_info_=1;
            if(row_kontrol_outage==undefined) row_kontrol_outage="";
            if(is_phantom_outage==undefined) is_phantom_outage=0;
            if(is_sevk_outage==undefined) is_sevk_outage=0;
            if(is_property_outage==undefined) is_property_outage=4;
            if(is_free_amount_outage==undefined) is_free_amount_outage="";
            if(stock_code_outage==undefined) stock_code_outage="";
            if(product_id_outage==undefined) product_id_outage="";
            if(stock_id_outage==undefined) stock_id_outage="";
            if(product_name_outage==undefined) product_name_outage="";
            if(stock_code_outage==undefined) stock_code_outage="";
            if(spec_main_id_outage==undefined) spec_main_id_outage="";
            if(spect_name_outage==undefined) spect_name_outage="";
            if(lot_no_outage==undefined) lot_no_outage="";
            if(amount_outage==undefined) amount_outage=1;
            if(unit_id_outage==undefined) unit_id_outage="";
            if(unit_outage==undefined) unit_outage="";
    
            row_count_outage++;
            var newRow;
            var newCell;
            newRow = document.getElementById("table3").insertRow(document.getElementById("table3").rows.length);
            newRow.setAttribute("name","frm_row_outage" + row_count_outage);
            newRow.setAttribute("id","frm_row_outage" + row_count_outage);
            newRow.setAttribute("NAME","frm_row_outage" + row_count_outage);
            newRow.setAttribute("ID","frm_row_outage" + row_count_outage);
            newRow.className = 'color-row';
            document.add_production_order.record_num_outage.value = row_count_outage;
            <cfif isdefined("is_add_product_sarf_fire") and is_add_product_sarf_fire eq 1>
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.innerHTML = '<a style="cursor:pointer" onclick="copy_row_outage('+row_count_exit+');" title="<cf_get_lang_main no="1560.Satır Kopyala">"><img  src="images/copy_list.gif" border="0"></a><a style="cursor:pointer" onclick="sil_outage(' + row_count_outage + ');"><img src="images/delete_list.gif" border="0" align="absmiddle" alt="Sil"></a>';
            </cfif>
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="hidden" name="is_add_info_' + row_count_outage +'" id="is_add_info_' + row_count_outage +'" value="'+is_add_info_+'"><input type="hidden" name="row_kontrol_outage' + row_count_outage +'" id="row_kontrol_outage' + row_count_outage +'" value="1">';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="hidden" name="is_phantom_outage' + row_count_outage +'" id="is_phantom_outage' + row_count_outage +'" value="'+is_phantom_outage+'"><input type="hidden" name="is_sevk_outage' + row_count_outage +'" id="is_sevk_outage' + row_count_outage +'" value="'+is_sevk_outage+'"><input type="hidden" name="is_property_outage' + row_count_outage +'" id="is_property_outage' + row_count_outage +'" value="'+is_property_outage+'"><input type="hidden" name="is_free_amount_outage' + row_count_outage +'" id="is_free_amount_outage' + row_count_outage +'" value="'+is_free_amount_outage+'"><input type="text" name="stock_code_outage' + row_count_outage +'" id="stock_code_outage' + row_count_outage +'"  value="'+stock_code_outage+'" readonly style="width:150px;">';
            newCell = newRow.insertCell(newRow.cells.length);
           newCell.innerHTML = '<input type="hidden" name="product_id_outage' + row_count_outage +'" id="product_id_outage' + row_count_outage +'" value="'+product_id_outage+'"><input type="hidden" name="stock_id_outage' + row_count_outage +'" id="stock_id_outage' + row_count_outage +'"  value="'+stock_id_outage+'"><input type="text" name="product_name_outage' + row_count_outage +'" id="product_name_outage' + row_count_outage +'" value="'+product_name_outage+'" readonly style="width:280px;"></a><a href="javascript://" onClick="pencere_ac_product_outage('+ row_count_outage +');"> <i class="icon-ellipsis"></i></a>';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="spec_main_id_outage' + row_count_outage +'" id="spec_main_id_outage' + row_count_outage +'" value="'+spec_main_id_outage+'" readonly style="width:40px;"> <input name="spect_name_outage' + row_count_outage +'" id="spect_name_outage' + row_count_outage +'" value="'+spect_name_outage+'" readonly style="width:200px;">';
            <cfif isdefined("is_show_lot_no") and is_show_lot_no eq 1>
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.innerHTML = '<input type="text" name="lot_no_outage' + row_count_outage +'" id="lot_no_outage' + row_count_outage +'" value="'+ lot_no_outage +'" onKeyup="lotno_control(' + row_count_outage +',3);" style="width:100px;"/> <a href="javascript://" onclick="pencere_ac_list_product(' + row_count_outage +',3);"><i class="icon-ellipsis"></i></a> ';
            </cfif>
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="amount_outage' + row_count_outage +'" id="amount_outage' + row_count_outage +'" value="'+amount_outage+'" onKeyup="return(FormatCurrency(this,event,8));" class="moneybox" style="width:100px;"><input type="hidden" name="amount_outage_' + row_count_outage +'" id="amount_outage_' + row_count_outage +'" value="'+amount_outage+'" onKeyup="return(FormatCurrency(this,event,8));" class="moneybox" style="width:100px;">';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="hidden" name="unit_id_outage' + row_count_outage +'" id="unit_id_outage' + row_count_outage +'"  value="'+unit_id_outage+'"><input type="text" name="unit_outage' + row_count_outage +'" id="unit_outage' + row_count_outage +'" value="'+unit_outage+'" readonly style="width:60px;">';
        }
        
        function copy_row_outage(no_info)
        {
            if ($("#is_add_info_" + no_info) == undefined) is_add_info_ =""; else is_add_info_ = $("#is_add_info_" + no_info).val();
            if ($("#row_kontrol_outage" + no_info) == undefined) row_kontrol_outage =""; else row_kontrol_outage = $("#row_kontrol_outage" + no_info).val();
            if ($("#is_phantom_outage" + no_info) == undefined) is_phantom_outage =""; else is_phantom_outage = $("#is_phantom_outage" + no_info).val();
            if ($("#is_sevk_outage" + no_info) == undefined) is_sevk_outage =""; else is_sevk_outage = $("#is_sevk_outage" + no_info).val();
            if ($("#is_property_outage" + no_info) == undefined) is_property_outage =""; else is_property_outage = $("#is_property_outage" + no_info).val();
            if ($("#is_free_amount_outage" + no_info) == undefined) is_free_amount_outage =""; else is_free_amount_outage = $("#is_free_amount_outage" + no_info).val();
            if ($("#stock_code_outage" + no_info) == undefined) stock_code_outage =""; else stock_code_outage = $("#stock_code_outage" + no_info).val();
            if ($("#product_id_outage" + no_info) == undefined) product_id_outage =""; else product_id_outage = $("#product_id_outage" + no_info).val();
            if ($("#stock_id_outage" + no_info) == undefined) stock_id_outage =""; else stock_id_outage = $("#stock_id_outage" + no_info).val();
            if ($("#product_name_outage" + no_info) == undefined) product_name_outage =""; else product_name_outage = $("#product_name_outage" + no_info).val();
            if ($("#stock_code_outage" + no_info) == undefined) stock_code_outage =""; else stock_code_outage = $("#stock_code_outage" + no_info).val();
            if ($("#spec_main_id_outage" + no_info) == undefined) spec_main_id_outage =""; else spec_main_id_outage = $("#spec_main_id_outage" + no_info).val();
            if ($("#spect_name_outage" + no_info) == undefined) spect_name_outage =""; else spect_name_outage = $("#spect_name_outage" + no_info).val();
            if ($("#lot_no_outage" + no_info) == undefined) lot_no_outage =""; else lot_no_outage = $("#lot_no_outage" + no_info).val();
            if ($("#amount_outage" + no_info) == undefined) amount_outage =""; else amount_outage = $("#amount_outage" + no_info).val();
            if ($("#unit_id_outage" + no_info) == undefined) unit_id_outage =""; else unit_id_outage = $("#unit_id_outage" + no_info).val();
            if ($("#unit_outage" + no_info) == undefined) unit_outage =""; else unit_outage = $("#unit_outage" + no_info).val();
            add_row_outage(is_add_info_,row_kontrol_outage,is_phantom_outage,is_sevk_outage,is_property_outage,is_free_amount_outage,stock_code_outage,product_id_outage,stock_id_outage,product_name_outage,stock_code_outage,spec_main_id_outage,spect_name_outage,lot_no_outage,amount_outage,unit_id_outage,unit_outage);
        }
        
        function pencere_ac_product_outage(no)
        {
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&call_function=calc_amount_outage&call_function_paremeter='+no+'&stock_and_spect=1&product_id=add_production_order.product_id_outage'+no+'&field_id=add_production_order.stock_id_outage'+no+'&field_name=add_production_order.product_name_outage'+no+'&field_code=add_production_order.stock_code_outage'+no+'&field_spect_main_id=add_production_order.spec_main_id_outage'+no+'&field_spect_main_name=add_production_order.spect_name_outage'+no+'&field_unit=add_production_order.unit_id_outage'+no+'&field_unit_name=add_production_order.unit_outage'+no+'&field_amount=add_production_order.amount_outage'+no,'list');
        }
        function calc_amount_outage(no)
        {
            $("#amount_outage" + no).val( filterNum($("#amount_outage" + no).val()) * filterNum($("#amount_outage_" + no).val()));
        }
        function pencere_ac_list_product(no,type)//ürünlere lot_no ekliyor
        {
            if(type == 2)
            {//sarf ise type 2
                form_stock_code = $("#stock_code_exit"+no).val();
                if(form_stock_code!= undefined && form_stock_code!='')
                {
                    url_str='&is_sale_product=1&update_product_row_id=0&is_lot_no_based=1&prod_order_result_=1&sort_type=1&lot_no=add_production_order.lot_no_exit'+no+'&keyword=' + form_stock_code+'&is_form_submitted=1&int_basket_id=1';
                    windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_products'+url_str+'','list');
                }
                else
                    alert("<cf_get_lang_main no='815.Ürün Seçmelisiniz'>!");
            }
            else if(type == 3)
            {//fire ise type 3
                form_stock_code = $("#stock_code_outage"+no).val();
                if(form_stock_code!= undefined && form_stock_code!='')
                {
                    url_str='&is_sale_product=1&update_product_row_id=0&is_lot_no_based=1&prod_order_result_=1&sort_type=1&lot_no=add_production_order.lot_no_outage'+no+'&keyword=' + form_stock_code+'&is_form_submitted=1&int_basket_id=1';
                    windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_products'+url_str+'','list');
                }
                else
                    alert("<cf_get_lang_main no='815.Ürün Seçmelisiniz'>!");
            }
        }
        function lotno_control(crntrow,type)
        {
            //var prohibited=' [space] , ",    #,  $, %, &, ', (, ), *, +, ,, ., /, <, =, >, ?, @, [, \, ], ], `, {, |,   }, , «, ';
            var prohibited_asci='32,34,35,36,37,38,39,40,41,42,43,44,47,60,61,62,63,64,91,92,93,94,96,123,124,125,156,171';
            if(type == 2)
                lot_no = document.getElementById('lot_no_exit'+crntrow);
            else if(type ==3)
                lot_no = document.getElementById('lot_no_outage'+crntrow);
            toplam_ = lot_no.value.length;
            deger_ = lot_no.value;
            if(toplam_>0)
            {
                for(var this_tus_=0; this_tus_< toplam_; this_tus_++)
                {
                    tus_ = deger_.charAt(this_tus_);
                    cont_ = list_find(prohibited_asci,tus_.charCodeAt());
                    if(cont_>0)
                    {
                        alert("[space],\"\,#,$,%,&,',(,),*,+,,/,<,=,>,?,@,[,\,],],`,{,|,},«,; Katakterlerinden Oluşan Lot No Girilemez!");
                        lot_no.value = '';
                        break;
                    }
                }
            }
        }
    </script>
</cfif>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();	
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'prod.##fuseaction_##';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'production_plan/display/list_production_orders.cfm';
	
if(not isdefined('attributes.event') or attributes.event is 'list')
	{
		WOStruct['#attributes.fuseaction#']['excel'] = structNew();
		WOStruct['#attributes.fuseaction#']['excel']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['excel']['fuseaction'] = 'prod.##fuseaction_##';
		WOStruct['#attributes.fuseaction#']['excel']['filePath'] = 'production_plan/display/list_production_orders.cfm';
		WOStruct['#attributes.fuseaction#']['excel']['queryPath'] = 'production_plan/query/convert_demand_to_production.cfm';
	}
	
	if(listFindNoCase('addorder',attributes.event)){
		WOStruct['#attributes.fuseaction#']['addorder'] = structNew();
		WOStruct['#attributes.fuseaction#']['addorder']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['addorder']['fuseaction'] = 'prod.add_prod_order';
		WOStruct['#attributes.fuseaction#']['addorder']['filePath'] = 'production_plan/form/add_prod_order.cfm';
		WOStruct['#attributes.fuseaction#']['addorder']['queryPath'] = 'production_plan/query/add_production_ordel_all.cfm';
		WOStruct['#attributes.fuseaction#']['addorder']['nextEvent'] = 'prod.order&event=updorder';
		WOStruct['#attributes.fuseaction#']['addorder']['js'] = "javascript:gizle_goster_ikili('prod_order','prod_order_bask')";
	}
	if(listFindNoCase('addorderAjax',attributes.event)){
		WOStruct['#attributes.fuseaction#']['addorderAjax'] = structNew();
		WOStruct['#attributes.fuseaction#']['addorderAjax']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['addorderAjax']['fuseaction'] = 'prod.add_prod_order';
		WOStruct['#attributes.fuseaction#']['addorderAjax']['filePath'] = 'production_plan/display/display_product_tree.cfm';
		WOStruct['#attributes.fuseaction#']['addorderAjax']['queryPath'] = 'production_plan/query/add_production_ordel_all.cfm';
		if(isdefined('attributes.is_demand'))
		WOStruct['#attributes.fuseaction#']['addorderAjax']['nextEvent'] = 'prod.order&event=upddemand';
		else
		WOStruct['#attributes.fuseaction#']['addorderAjax']['nextEvent'] = 'prod.order&event=updorder';
	}
	if(listFindNoCase('adddemand',attributes.event)){
		WOStruct['#attributes.fuseaction#']['adddemand'] = structNew();
		WOStruct['#attributes.fuseaction#']['adddemand']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['adddemand']['fuseaction'] = 'prod.add_prod_order';
		WOStruct['#attributes.fuseaction#']['adddemand']['filePath'] = 'production_plan/form/add_prod_order.cfm';
		WOStruct['#attributes.fuseaction#']['adddemand']['queryPath'] = 'production_plan/query/add_production_ordel_all.cfm';
		WOStruct['#attributes.fuseaction#']['adddemand']['js'] = "javascript:gizle_goster_ikili('prod_order','prod_order_bask')";
		WOStruct['#attributes.fuseaction#']['adddemand']['nextEvent'] = 'prod.demands&event=upddemand';
	}
	if(listFindNoCase('adddemandCollacted',attributes.event)){
		WOStruct['#attributes.fuseaction#']['adddemandCollacted'] = structNew();
		WOStruct['#attributes.fuseaction#']['adddemandCollacted']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['adddemandCollacted']['fuseaction'] = 'prod.add_prod_order';
		WOStruct['#attributes.fuseaction#']['adddemandCollacted']['filePath'] = 'production_plan/form/add_prod_order.cfm';
		WOStruct['#attributes.fuseaction#']['adddemandCollacted']['queryPath'] = 'production_plan/query/add_production_order_all_sub.cfm';
		WOStruct['#attributes.fuseaction#']['adddemandCollacted']['js'] = "javascript:gizle_goster_ikili('prod_order','prod_order_bask')";
		WOStruct['#attributes.fuseaction#']['adddemandCollacted']['nextEvent'] = 'prod.demands&event=upddemand';
	}
	if(listFindNoCase('updorder',attributes.event)){	
		WOStruct['#attributes.fuseaction#']['updorder'] = structNew();
		WOStruct['#attributes.fuseaction#']['updorder']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['updorder']['fuseaction'] = 'prod.form_upd_prod_order';
		WOStruct['#attributes.fuseaction#']['updorder']['filePath'] = 'production_plan/form/upd_prod_order.cfm';
		WOStruct['#attributes.fuseaction#']['updorder']['queryPath'] = 'production_plan/query/upd_production_order.cfm';
		WOStruct['#attributes.fuseaction#']['updorder']['nextEvent'] = 'prod.order&event=updorder';
		WOStruct['#attributes.fuseaction#']['updorder']['paremeters'] = 'upd=##attributes.upd##';
		WOStruct['#attributes.fuseaction#']['updorder']['Identity'] = '##attributes.upd##';
	}
	if(listFindNoCase('upddemand',attributes.event)){	
		WOStruct['#attributes.fuseaction#']['upddemand'] = structNew();
		WOStruct['#attributes.fuseaction#']['upddemand']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['upddemand']['fuseaction'] = 'prod.form_upd_prod_order';
		WOStruct['#attributes.fuseaction#']['upddemand']['filePath'] = 'production_plan/form/upd_prod_order.cfm';
		WOStruct['#attributes.fuseaction#']['upddemand']['queryPath'] = 'production_plan/query/upd_production_order.cfm';
		WOStruct['#attributes.fuseaction#']['upddemand']['nextEvent'] = 'prod.demands&event=upddemand';
		WOStruct['#attributes.fuseaction#']['upddemand']['paremeters'] = 'upd=##attributes.upd##';
		WOStruct['#attributes.fuseaction#']['upddemand']['Identity'] = '##attributes.upd##';
	}
	if(IsDefined("attributes.event") && (attributes.event is 'updorder' || attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=prod.emptypopup_del_production_order';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'production_plan/query/del_production_order.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'production_plan/query/del_production_order.cfm';
		WOStruct['#attributes.fuseaction#']['del']['parameters'] = 'p_order_id=##attributes.p_order_id##&name=##get_det_po.p_order_no##&PO_RELATED_ID=##GET_DET_PO.PO_RELATED_ID##';
		WOStruct['#attributes.fuseaction#']['del']['Identity'] = '##attributes.p_order_id##';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'prod.order&event=list';
	
	}
	if(attributes.event is 'addorder')
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['addorder'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['addorder']['menus'] = structNew();
			if (not isdefined("attributes.is_collacted")){
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['addorder']['menus'][0]['text'] = '#lang_array.item[52]#';		
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['addorder']['menus'][0]['onClick'] = "open_product_tree(document.getElementById('stock_id').value)";
			}
			else{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['addorder']['menus'][0]['text'] = 'CVS İmport';		
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['addorder']['menus'][0]['onClick'] = "open_file()";
			}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
	 if(attributes.event is 'updorder')
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updorder'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updorder']['menus'] = structNew();
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updorder']['menus'][0]['text'] = '#lang_array_main.item[345]#';		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updorder']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=prod.form_upd_prod_order&action_name=upd&action_id=#attributes.upd#&relation_papers_type=P_ORDER_ID','list')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updorder']['menus'][1]['text'] = '#lang_array_main.item[2252]#';		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updorder']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=prod.order&event=addorder&po_related_id=#attributes.upd#')";
				
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updorder']['menus'][2]['text'] = '#lang_array.item[52]#';		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updorder']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=prod.list_product_tree&event=upd&stock_id=#get_det_po.stock_id#')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updorder']['menus'][3]['text'] = '#lang_array_main.item[2207]#';		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updorder']['menus'][3]['onClick'] = "windowopen('#request.self#?fuseaction=prod.popup_add_prod_order_asset&id=#attributes.upd#','list')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updorder']['menus'][4]['text'] = '#lang_array_main.item[170]#';		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updorder']['menus'][4]['onClick'] = "windowopen('#request.self#?fuseaction=prod.order&event=addorder')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updorder']['menus'][5]['text'] = 'Tarihçe';		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updorder']['menus'][5]['customTag'] = '<cf_wrk_history act_type="5" act_id="#attributes.upd#" boxwidth="600" boxheight="500">';
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.upd#&print_type=281','page')";
		
		i=6;
		if(get_det_po.quantity-get_det_po.result_amount >= 0 && not isdefined('is_demand')){
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updorder']['menus'][i]['text'] = '#lang_array_main.item[1854]#';	
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updorder']['menus'][i]['href'] = "#request.self#?fuseaction=prod.list_results&event=add&p_order_id=#attributes.upd#";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updorder']['menus'][i]['target'] = "_blank";

		
		i=i+1;
		}		
		
		if(session.ep.our_company_info.guaranty_followup){
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updorder']['menus'][i]['text'] = '#lang_array_main.item[305]#-#lang_array_main.item[306]#';		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updorder']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=stock.list_serial_operations&is_filtre=1&belge_no=#URLEncodedFormat(get_det_po.p_order_no)#&process_id=#attributes.UPD#&process_cat_id=1194')";
		i=i+1;
		}
		
		if(isdefined('is_demand')){
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updorder']['menus'][i]['text'] = '#lang_array_main.item[64]#';		
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updorder']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=prod.order&event=addorder&is_demand=1&upd=#attributes.upd#')";		
			i=i+1;
		}
		else
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updorder']['menus'][i]['text'] = '#lang_array_main.item[64]#';		
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updorder']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=prod.order&event=addorder&upd=#attributes.upd#')";		
			i=i+1;
		}	
		
		if(len(get_det_po.order_id)){
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updorder']['menus'][i]['text'] = '#lang_array.item[71]#';		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updorder']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=prod.popup_list_prod_order&product_id=#get_det_po.product_id#&query_p_order_id=#attributes.upd#&order_no=#get_det_po.order_id#','page')";
		i=i+1;
		}
		
		if(len(GET_DET_PO.PO_RELATED_ID)){
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updorder']['menus'][i]['text'] = '#lang_array.item[551]#';		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updorder']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=prod.order&event=updorder&upd=#GET_DET_PO.PO_RELATED_ID#')";
		i=i+1;
		}
		
		if(len(get_det_po.order_id)){
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updorder']['menus'][i]['text'] = '#lang_array.item[51]#';		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updorder']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=prod.detail_order&order_id=#get_det_po.order_id#&order_row_id=#get_det_po.order_row_id#')";
		i=i+1;
		}
				
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'inProductionController';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'addorder,updorder';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'PRODUCTION_ORDERS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-product_name','item-quantity','item-start_date','item-finish_date','item-station_name']";
	

</cfscript>
