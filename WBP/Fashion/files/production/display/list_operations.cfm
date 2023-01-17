<cfset fuseaction_ = ListGetAt(attributes.fuseaction,2,'.')>
<cfsetting showdebugoutput="no">
<cf_get_lang_set module_name="prod">
<cfset fuseaction_ = replace(fuseaction_,'emptypopup_','')>
<cf_xml_page_edit default_value="1" fuseact="prod.#fuseaction_#">
<cfparam name="attributes.short_code_id" default="">
<cfparam name="attributes.production_stage" default="">
<cfparam name="attributes.lot_no" default="">
<cfparam name="attributes.req_no" default="">
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
<cfparam name="attributes.result" default="">
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


<cfquery name="GET_OPERATION" datasource="#dsn3#">
	select 
		OPERATION_TYPE_ID,
		OPERATION_TYPE
	from OPERATION_TYPES
</cfquery>
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
<cfif isdefined("attributes.is_submitted") and len(attributes.is_submitted)>
	<cfscript>
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
            REQ_NO1 : '#IIf(IsDefined("attributes.REQ_NO1"),"attributes.REQ_NO1",DE(""))#',
			REFERENCE_NO1 : '#IIf(IsDefined("attributes.REFERENCE_NO1"),"attributes.REFERENCE_NO1",DE(""))#',
			ORDER_NUMBER1 : '#IIf(IsDefined("attributes.ORDER_NUMBER1") && len(attributes.ORDER_NUMBER1),"attributes.ORDER_NUMBER1",DE(""))#',
			PRODUCT_NAME1 : '#IIf(IsDefined("attributes.PRODUCT_NAME1"),"attributes.PRODUCT_NAME1",DE(""))#',
			is_excel : '#IIf(IsDefined("attributes.is_excel"),"attributes.is_excel",DE(""))#'
		);
	</cfscript>
	<cfparam name="attributes.totalrecords" default='#get_po_det.recordcount#'>
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
</cfquery>

	<cfset print_type_ = 281>
	<cfset colspan_info = 12>


<!--- Yazdırmak istediğimiz zaman fuseaction'un başına autoexcelpopuppage ifadesi eklendiği için fuseaction_ is ifadeleri fuseaction_ contains şekline dönüştürüldü.. EY 20130212 --->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search_list" action="#request.self#?fuseaction=textile.#fuseaction_#" method="post">
            <input type="hidden" name="is_submitted" id="is_submitted" value="1">
            <input type="hidden" name="is_excel" id="is_excel" value="0">
            <cf_box_search>
                <div class="form-group">
                    <div class="input-group x-15">
                        <cfsavecontent variable="key_title"><cf_get_lang dictionary_id='29474.Emir No'> ,<cf_get_lang dictionary_id='29419.Operasyon'> ,<cf_get_lang dictionary_id='62568.Numune No'>, <cf_get_lang dictionary_id='58211.Sipariş No'> ve  <cf_get_lang dictionary_id='36698.Lot No'>, <cf_get_lang dictionary_id='58784.Referans'>, <cf_get_lang dictionary_id='57657.Ürün'> <cf_get_lang dictionary_id='36501.Alanlarında Arama Yapabilirsiniz'>!</cfsavecontent>
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
                        <cfif isdefined("attributes.REQ_NO1")>
                            <cfset checked_list = listappend(checked_list,"REQ_NO1")>
                        </cfif>
                        <cf_wrk_search_input name="keyword" id="keyword" title="#key_title#" check_column="#checked_list#" checkbox="Üretim Emri No,Talep No,Lot No,Referans No,Numune Numarası,Sipariş Numarası" columnlist="P_ORDER_NO1,DEMAND_NO1,LOT_NO1,REFERENCE_NO1,REQ_NO1,ORDER_NUMBER1" placeholder="#getLang('assetcare',48)#">
                        <!---<cfinput type="text" name="keyword" id="keyword" title="#key_title#"  style="width:80px;">--->
                    </div>
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
                <div class="form-group x-15">
                    <cf_multiselect_check
                        name="opplist"
                        query_name="get_operation"
                        option_name="OPERATION_TYPE"
                        option_value="OPERATION_TYPE_ID"
                        option_text="Operasyon Seç"
                        value="#attributes.opplist#">
                </div>
                <div class="form-group">
                    <select name="result" id="result" title="Üretim Sonucu">
                        <option value="" <cfif not len(attributes.result)>selected</cfif>><cf_get_lang dictionary_id='29651.Üretim Sonucu'></option>
                        <option value="1"<cfif attributes.result eq 1>selected</cfif>><cf_get_lang dictionary_id='36900.Girilenler'></option>
                        <option value="0"<cfif attributes.result eq 0>selected</cfif>><cf_get_lang dictionary_id='36899.Girilmeyenler'></option>
                    </select>
                </div>
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
                <div class="form-group x-3_5">
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,255" maxlength="3">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
                <div class="form-group">
                    <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                </div>
            </cf_box_search>
            <cf_box_search_detail>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-member_name">
                        <label class="col col-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id")><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
                                <input type="hidden" name="company_id"  id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">
                                <input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type")><cfoutput>#attributes.member_type#</cfoutput></cfif>">
                                <input type="text" name="member_name"   id="member_name"  value="<cfif isdefined("attributes.member_name") and len(attributes.member_name)><cfoutput>#attributes.member_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','consumer_id,company_id,member_type','','3','250');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_consumer=search_list.consumer_id&field_comp_id=search_list.company_id&field_member_name=search_list.member_name&field_type=search_list.member_type&select_list=7,8&keyword='+encodeURIComponent(document.search_list.member_name.value));"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-product_cat">
                        <label class="col col-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="product_cat_code" id="product_cat_code" value="<cfif len(attributes.product_cat)><cfoutput>#attributes.product_cat_code#</cfoutput></cfif>">
                                <input type="hidden" name="product_catid" id="product_catid" value="<cfoutput>#attributes.product_catid#</cfoutput>">
                                <cfinput type="text" name="product_cat" id="product_cat" value="#attributes.product_cat#" onFocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID','product_catid','','3','200');">
                                <span class="input-group-addon icon-ellipsis btnPointer" title="Kategori Ekle" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&field_code=search_list.product_cat_code&is_sub_category=1&field_id=search_list.product_catid&field_name=search_list.product_cat');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-position_name">
                        <label class="col col-12"><cf_get_lang dictionary_id='57544.Sorumlu'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="position_code" id="position_code" value="<cfif len(attributes.position_code) and len(attributes.position_name)><cfoutput>#attributes.position_code#</cfoutput></cfif>">
                                <input type="text" name="position_name" id="position_name" value="<cfif len(attributes.position_code) and len(attributes.position_name)><cfoutput>#attributes.position_name#</cfoutput></cfif>" maxlength="255" onfocus="AutoComplete_Create('position_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','position_code','','3','135');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=search_list.position_code&field_name=search_list.position_name&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.search_list.position_name.value));"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-order_employee">
                        <label class="col col-12"><cf_get_lang no ='472.Satış Çalışanı'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="order_employee_id"  id="order_employee_id"value="<cfoutput>#attributes.order_employee_id#</cfoutput>">
                                <input type="text"  name="order_employee"  id="order_employee"  value="<cfoutput>#attributes.order_employee#</cfoutput>" onfocus="AutoComplete_Create('order_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','order_employee_id','','3','135')" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_list.order_employee_id&field_name=search_list.order_employee&select_list=1');"></span>
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
                                <span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="spect_remove();openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=search_list.related_stock_id&product_id=search_list.related_product_id&field_name=search_list.related_product_name&keyword='+encodeURIComponent(document.search_list.related_product_name.value));"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-station_id">
                        <label class="col col-12"><cf_get_lang dictionary_id='29473.İstasyonlar'></label>
                        <div class="col col-12">
                            <select name="station_id" id="station_id">
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
                                <input type="text"   name="product_name"  id="product_name" style="width:110px;"  value="<cfoutput>#attributes.product_name#</cfoutput>" passthrough="readonly=yes" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE,','get_product_autocomplete','0','PRODUCT_ID,STOCK_ID','product_id,stock_id','','3','225');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="spect_remove();openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=search_list.stock_id&product_id=search_list.product_id&field_name=search_list.product_name&keyword='+encodeURIComponent(document.search_list.product_name.value));"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-spect_name">
                        <label class="col col-12"><cf_get_lang dictionary_id='57647.Spekt'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="spect_main_id" id="spect_main_id" value="<cfoutput>#attributes.spect_main_id#</cfoutput>">
                                <input type="text" name="spect_name" id="spect_name" value="<cfoutput>#attributes.spect_name#</cfoutput>" style="width:110px;">
                                <span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="product_control();"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-short_code_id">
                        <label class="col col-12"><cf_get_lang dictionary_id='58225.Model'></label>
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
                                <label class="col col-12"><cfoutput>#getLang('main',344)#</cfoutput></label>
                                <div class="col col-12">
                                    <cfif fuseaction_ contains 'order'>
                                        <select name="production_stage" id="production_stage" style="width:125px;height:65px" multiple="multiple">
                                            <option value="4" style="background-color:#00CCFF;font-size:12px;"<cfif isdefined("attributes.production_stage") and listfind(attributes.production_stage,'4')>selected</cfif>><cf_get_lang no ='270.Başlamadı'></option>
                                            <option value="0" style="background-color:#FFCC33;"<cfif isdefined("attributes.production_stage") and listfind(attributes.production_stage,'0')>selected</cfif>><cf_get_lang no ='578.Operatöre Gönderildi'></option>
                                            <option value="1" style="background-color:#00CC33;"<cfif isdefined("attributes.production_stage") and listfind(attributes.production_stage,'1')>selected</cfif>><cf_get_lang no ='577.Başladı'></option>
                                            <option value="3" style="background-color:#CCCCCC;"<cfif isdefined("attributes.production_stage") and listfind(attributes.production_stage,'3')>selected</cfif>><cf_get_lang no ='580.Üretim Durdu(Arıza)'></option>
                                            <option value="2" style="background-color:#FF0000;"<cfif isdefined("attributes.production_stage") and listfind(attributes.production_stage,'2')>selected</cfif>><cf_get_lang no ='271.Bitti'></option>
                                        </select>
                                    <cfelseif fuseaction_ contains 'in_productions'>
                                        <select name="production_stage" id="production_stage" style="width:125px;height:65px" multiple="multiple">
                                            <option value="1" style="background-color:#00CC33;"<cfif isdefined("attributes.production_stage") and listfind(attributes.production_stage,'1')>selected</cfif>><cf_get_lang no ='577.Başladı'></option>
                                            <option value="3" style="background-color:#CCCCCC;"<cfif isdefined("attributes.production_stage") and listfind(attributes.production_stage,'3')>selected</cfif>><cf_get_lang no ='580.Üretim Durdu(Arıza)'></option>
                                        </select>
                                    </cfif>
                                </div>
                            </div>
                        </div>
                    </cfif>
                </cfif>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                    <div class="form-group" id="item-start_date">
                        <label class="col col-12">Tarih</label>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
                                    <cfinput type="text" name="start_date" maxlength="10" validate="#validate_style#" value="#dateformat(attributes.start_date,dateformat_style)#">
                                <cfelse>
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58745.Başlama Tarihi Girmelisiniz'> !</cfsavecontent>
                                    <cfinput required="Yes" message="#message#" type="text" name="start_date" maxlength="10" validate="#validate_style#" value="#dateformat(attributes.start_date,dateformat_style)#">
                                </cfif>
                                <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                                <span class="input-group-addon no-bg"></span>
                                <cfinput type="text" name="start_date_2" value="#dateformat(attributes.start_date_2,dateformat_style)#" validate="#validate_style#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="start_date_2"></span>
                            </div>
                        </div>
                    </div>
                    <!--- <div class="form-group" id="item-finish_date">
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
                    </div>--->
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
    <cfsavecontent variable="header_"><cf_get_lang no='63.Operasyonlar'></cfsavecontent>
    <cf_box title="#header_#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                        <!-- sil -->
                        <th style="width:1%;"></th>
                        <!-- sil -->
                    </cfif>
                        <!---<th style="width:120px;">Resim</th>--->
                        <th style="width:50px;"><cf_get_lang dictionary_id='58211.Sipariş No'></th>
                        <!---<th style="width:80px;">Ürün Kodu</th>--->
                        <th style="width:250px;"><cf_get_lang dictionary_id='57657.Ürün'></th>
                        <th><cf_get_lang dictionary_id='57645.Teslim Tarihi'></th>
                        <th><cf_get_lang dictionary_id='58847.Marka'></th>
                        <th><cf_get_lang dictionary_id='57486.Kategori'></th>
                        <th style="width:100px;"><cf_get_lang dictionary_id='57416.Proje'></th>
                        <th style="text-align:left;width:100px;"><cf_get_lang dictionary_id='29419.Operasyon'></th>         
                        <th style="width:30px;text-align:right;"><cf_get_lang dictionary_id='58869.Planlanan'><cf_get_lang dictionary_id='29419.Operasyon'> <cf_get_lang dictionary_id='57635.Miktar'></th>
                        <th style="width:60px;text-align:right;"><cf_get_lang dictionary_id='62566.Gerçekleşen Operasyon Miktarı'></th>
                        <th style="width:30px;text-align:right;"><cf_get_lang dictionary_id='36608.Üretilen'></th>
                            <th style="width:30px;text-align:right;"><cf_get_lang dictionary_id='58444.Kalan'></th>
                    <!-- sil -->
                    <cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                        <th style="width:10px;"></th>
                        <th style="text-align:center; width:10px;">
                        </th>
                        <th style="text-align:center; width:10px;">
                        </th>
                        <th style="text-align:center; width:10px;">
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
                            <cfif fuseaction_ contains 'demands'>
                                <cfif len(STOCK_ID) and not listfind(stock_id_list,STOCK_ID)>
                                    <cfset stock_id_list=listappend(stock_id_list,STOCK_ID)>
                                </cfif>
                            </cfif>
                            <cfif fuseaction_ contains 'operations'>
                                <cfif len(operation_type_id) and not listfind(operation_type_id_list,operation_type_id)>
                                    <cfset operation_type_id_list=listappend(operation_type_id_list,operation_type_id)>
                                </cfif>
                            
                            </cfif>
                        </cfoutput>
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
                        <form name="go_p_order_list" method="post" action="<cfoutput>#request.self#?</cfoutput>fuseaction=prod.order">
                            <input type="hidden" name="keyword" id="keyword" value=""><!--- Üretim Emirlerin Listesine Giderken Doldurulur.. --->
                            <input type="hidden" name="production_order_no" id="production_order_no" value=""><!--- Üretim Malzeme İhtiyaçlarına Giderken doldurulur.. --->
                            <input type="hidden" name="is_submitted" id="is_submitted" value="1">
                            <input type="hidden" name="start_date" id="start_date" value="">
                            <input type="hidden" name="finish_date" id="finish_date" value="">
                        <!--- <input type="hidden" name="row_demand_all" id="row_demand_all" value="<cfoutput query="get_po_det">#P_ORDER_ID#<cfif currentrow neq recordcount>,</cfif></cfoutput>">--->
                        </form>
                        <form name="convert_demand_to_production" method="post" action="<cfoutput>#request.self#?</cfoutput>fuseaction=prod.emptypopup_convert_demand_to_production">
                            <input type="hidden" name="is_upd_related_demands" id="is_upd_related_demands" value="<cfif isdefined("is_upd_related_demands")><cfoutput>#is_upd_related_demands#</cfoutput><cfelse>0</cfif>"><!--- İlişkili taleplerin güncellenip güncellenmeyeceğini tutuyor arka sayfada kullanılıyor --->
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
                            <cfset url_="">
                            <cfset url_ = "#file_web_path#product/">
                            <cfset uploadFolder = application.systemParam.systemParam().upload_folder />
                            <cfset path = "#upload_folder#product#dir_seperator#">
                            <cfoutput query="get_po_det">
                                <tr <cfif line eq 1>bgcolor="##FADBD8"</cfif>>
                                    <cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                                        <!-- sil --><cfset quantity=0>
                                        <td align="center" id="order_row#currentrow#"  onclick="gizle_goster(operation_detail#currentrow#);connectAjax('#currentrow#','#main_operation_id#','#p_operation_id#','#operation_type_id#','#line#','#req_id#','#order_id#');gizle_goster_nested('siparis_goster#currentrow#','siparis_gizle#currentrow#');">
                                                <i id="siparis_goster#currentrow#" class="fa fa-chevron-circle-right fa-2x" aria-hidden="true" title="<cf_get_lang dictionary_id='58596.Göster'>"></i>	
                                                <i id="siparis_gizle#currentrow#" class="fa fa-chevron-circle-down fa-2x"  title="<cf_get_lang dictionary_id='58628.Gizle'>" style="display:none;"></i>
                                        </td>
                                        <!-- sil -->
                                    </cfif>
                                    <!---<td>
                                        <cfset assetFileName=asset_file_name>
                                        <cfset asset_id=asset_id>
                                        <cfset assetcat_id=assetcat_id>
                                        <cfset file_path = '#path##assetFileName#'>
                                        <cfif len(assetFileName) and FileExists(file_path)>
                                            <cfif len(assetFileName) and FileExists("#uploadFolder#thumbnails/middle/#assetFileName#")>
                                                <cfset imagePath = "documents/thumbnails/middle/#assetFileName#">
                                            <cfelse>
                                                <cfset imagePath = "documents/thumbnails/middle/#assetFileName#"/>
                                            </cfif>
                                            <cfset icon = false>
                                        <cfelse>
                                            <cfset imagePath = "images/intranet/no-image.png">
                                            <cfset icon = true>
                                        </cfif>
                                        <div class="image">
                                            <cfif icon>
                                                
                                                <img src="#imagePath#" style="margin-left: 10px; width:70px; height:50px;" class="img-thumbnail">
                                            <cfelse>
                                            <cfset ext=lcase(listlast(assetFileName, '.')) />
                                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_download_file&<cfif ext eq "jpg" or ext eq "jpeg" or ext eq "png" or ext eq "bmp" or ext eq "pdf" or ext eq "txt" or ext eq "gif">direct_show=1&</cfif>file_name=#url_##assetFileName#&file_control=asset.form_upd_asset&asset_id=#asset_id#&assetcat_id=#assetcat_id#','medium');">
                                                    <img src="#imagePath#" style="margin: 10px; width:100px;" class="img-thumbnail">
                                                    
                                                </a>
                                            </cfif>
                                        </div>
                                    </td>--->
                                    <td><a href="javacript://" class="tableyazi" onclick="window.open('#request.self#?fuseaction=sales.list_order&event=upd&order_id=#order_id#','page')">#order_number#</a></td>
                                    <!---<td>#product_code#</td>--->
                                    <td>
                                        <cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                                            <a href="#request.self#?fuseaction=prod.list_product_tree&event=upd&stock_id=#stock_id#" class="tableyazi">
                                                #product_name# 
                                            </a>
                                        <cfelse>
                                            #product_name# 
                                        </cfif>
                                    </td>
                                    <td>#dateformat((get_po_det.invoice_date),dateformat_style)#</td><!---#dateformat(date_add('h',session.ep.time_zone,record_date),dateformat_style)#--->
                                    <td>#get_po_det.short_code#</td>
                                    <td>#get_po_det.REQ_HEAD#</td>
                                    <td>#get_po_det.project_head#</td>
                                    <td>#line# - #OPERATION_TYPE#</td>
                                        <cfset planlanan_miktar=amount>
                                        <cfset oncekioperasyon_miktar=planlanan_miktar>        
                                        <cfset gerceklesen_op_miktar=order_amount>
                                        <cfset uretilen_miktar=result_amount>
                                        <cfset kalan_miktar=oncekioperasyon_miktar-uretilen_miktar>
                                    <td style="text-align:right;">#amount#</td>
                                        <td style="text-align:right;">
                                            #gerceklesen_op_miktar#
                                        </td>
                                        <td style="text-align:right;">
                                            #uretilen_miktar#
                                        </td>
                                        <td style="text-align:right;">
                                            #kalan_miktar#
                                        </td>
                                    <td>#MAIN_UNIT#</td>
                                    <!-- sil -->
                                    <cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                                
                                        <td>
                                            <cfif gerceklesen_op_miktar gt 0 and kalan_miktar lte 0>
                                                <img src="/images/red_glob.gif" title="İşlem Bitti">
                                            <cfelseif gerceklesen_op_miktar eq 0>
                                                <img src="/images/blue_glob.gif" title="İşlem Başlamadı">  
                                            <cfelseif gerceklesen_op_miktar gt 0 and kalan_miktar gt 0>
                                                <img src="/images/green_glob.gif" title="İşlem Başladı">
                                            </cfif>                   
                                        </td>
                                
                                    <td align="center"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_print_files&print_type=#print_type_#&action_id=#p_order_id#&date1=#DateFormat(attributes.start_date,dateformat_style)#&date2=#DateFormat(attributes.finish_date,dateformat_style)#&iid=#attributes.station_id#&iiid=<cfif len(attributes.product_cat)>#attributes.product_cat_code#</cfif>
                                    <cfif len(attributes.result)>&keyword=#attributes.result#</cfif>&action_row_id=#attributes.production_stage#','page');"><i class="fa fa-print fa-2x" aria-hidden="true"></i></a></td>
                                
                                    <td width="1%">
                                        <a href="javascript://" onclick="operasyon_detay('#main_operation_id#','#req_id#','#order_id#','#req_no#')"><i class="fa fa-edit fa-2x" title="Güncelle"></i></a>
                                    </td>
                                    <!-- sil -->
                                    </cfif>
                                </tr>
                                <cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                                <!-- sil -->
                                <tr id="operation_detail#currentrow#" class="nohover" style="display:none" >
                                    <td colspan="#colspan_info#">
                                        <div align="left" id="DISPLAY_OPERATION_INFO#currentrow#" style="border:none;"></div>
                                    </td>
                                </tr>
                                <!-- sil -->
                                </cfif>
                            </cfoutput>
                        <cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                    </tbody>
                <!-- sil -->
            <tfoot>
                <!---<tr height="40" class="nohover">
                    <td colspan="<cfoutput>#colspan_info#</cfoutput>" align="right" style="text-align:right;">
                        <input type="button" value="<cf_get_lang_main no ='446.Excel Getir'>" name="excelll" id="excelll" onclick="convert_to_excel();">
                        <cfif fuseaction_ contains 'operations' and attributes.result eq 0>
                            <input type="button" name="convert_to_production_" id="convert_to_production_" value="Seçili Operasyonları Sonlandır" onclick="demand_convert_to_production(7);">
                        <cfelseif fuseaction_ contains 'operations' and attributes.result eq 1>
                            <input type="button" name="convert_to_production_" id="convert_to_production_" value="Seçili Operasyonları Güncelle" onclick="demand_convert_to_production(7);">
                        </cfif>
                        <input type="hidden" name="process_type" id="process_type" value=""><!--- process type query sayfasında 0 ise talepler üretime çevirili 1 ise sadece bilgileri güncellenir.. --->
                        <input type="hidden" name="p_order_id_list" id="p_order_id_list" value="">
                        <div id="user_message_demand"></div>
                    </td>
                </tr>---->
                <!-- sil -->
            </tfoot>
            <tbody>
                </cfif>
                </form>
                <script type="text/javascript">
                
                function kontrol()
                {
                    if(!$("#maxrows").val().length)
                    {
                        alertObject({message: "<cfoutput><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfoutput>"})    
                        return false;
                    }
                    return true;
                }
                    function demand_convert_to_production(type)
                        {
                            if(type==4)// type 4 ise
                            {
                                document.getElementById("tumune_ihtiyac_button").value='<cfoutput>#getLang("main",293)#</cfoutput>';
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
                                                        alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='58859.Süreç'>");
                                                        return false;
                                                    }
                                                    user_message='<cf_get_lang no ="264.Talepler Güncelleniyor Lütfen Bekleyiniz">!';
                                                }
                                                else if(type==5)
                                                {
                                                    var selected_process_ = document.convert_demand_to_production.process_stage.value;
                                                    if(selected_process_=='')
                                                    {
                                                        alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='58859.Süreç'>");
                                                        return false;
                                                    }
                                                    user_message='<cf_get_lang dictionary_id='36991.Emirler Güncelleniyor Lütfen Bekleyiniz'> !';
                                                }
                                                else if(type==6)
                                                {
                                                    var selected_process_ = document.convert_demand_to_production.process_stage.value;
                                                    if(selected_process_=='')
                                                    {
                                                        alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='58859.Süreç'>");
                                                        return false;
                                                    }
                                                    user_message='<cf_get_lang dictionary_id='36992.Talepler Siliniyor Lütfen Bekleyiniz'> !';
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
                                                            alert(crtrow +'. <cf_get_lang dictionary_id='60547.Satırda İstasyon Eksik'>. <cf_get_lang dictionary_id='58837.Lütfen İstasyon Seçiniz.'>');
                                                            return false;
                                                        }
                                                        if(document.getElementById('operation_amount_'+crtrow).value == '')
                                                        {
                                                            alert(crtrow +'. <cf_get_lang dictionary_id='60548.Satırda Miktar Eksik'>. <cf_get_lang dictionary_id='29943.Lütfen miktar giriniz'>');
                                                            return false;
                                                        }
                                                        if(document.getElementById('operation_amount_'+crtrow).value > document.getElementById('operation_amount__'+crtrow).value)
                                                        {
                                                            alert(crtrow +'. <cf_get_lang dictionary_id='60549.Satırda Operasyon Miktarı Kalan Miktardan Fazla'>');
                                                            return false;
                                                        }
                                                        if(document.getElementById('employee_id_'+crtrow).value == '')
                                                        {
                                                            alert(crtrow +'. <cf_get_lang dictionary_id='60550.Satırda İşlemi Yapan Eksik'>. <cf_get_lang dictionary_id='60551.Lütfen İşlemi Yapanı Seçiniz'>.');
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
                                                        user_message='<cf_get_lang dictionary_id='54941.İşlemler Güncelleniyor Lütfen Bekleyiniz'>!';
                                                    <cfelseif attributes.result eq 0>
                                                        user_message='<cf_get_lang dictionary_id='62567.Operasyon Sonuçları Ekleniyor Lütfen Bekleyiniz'>!';
                                                    </cfif>
                                                }
                                                else if(type==0)
                                                    user_message='<cf_get_lang dictionary_id='36578.Talepler Üretime Çeviriliyor Lütfen Bekleyiniz'>!';
                                                    
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
                                            alert("<cf_get_lang dictionary_id='36579.Üretime Göndermek İçin Talep Seçiniz'>");
                                        else if(type==1)
                                            alert("<cf_get_lang dictionary_id='36580.Güncellenecek Talepleri Seçiniz'>!");
                                        else if(type==5)
                                            alert("<cf_get_lang dictionary_id='36993.Güncellenecek Emirleri Seçiniz'>!");
                                        else if(type==6)
                                            alert("<cf_get_lang dictionary_id='36994.Silinecek Talepleri Seçiniz'>!");
                                        else if(type==2)
                                            alert("<cf_get_lang dictionary_id='36581.Gruplanacak Satırları Seçiniz'>!");
                                        else if(type==3)
                                            alert("<cf_get_lang dictionary_id='36582.Malzeme İhtiyaçları İçin Talep Seçiniz'>!");
                                        else if(type==7)
                                            alert("<cf_get_lang dictionary_id='60552.Sonlandırılacak Operasyonları Seçiniz'>!");
                                        return false;
                                    }
                                }
                        }// type 4 degilse	
                    }	
                </script>
                <cfelse>
                    <tr>
                        <td colspan="<cfoutput>#colspan_info#</cfoutput>"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                    </tr>
                </cfif>
            <cfelse>
                <tr>
                    <td colspan="<cfoutput>#colspan_info#</cfoutput>"><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</td>
                </tr>
        </cfif>
            </tbody>
        </cf_grid_list>
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
        <table width="100%" align="center" cellpadding="0" cellspacing="0" border="0">
            <tr>
                <td><div id="groups_p"></div></td>
            </tr>
        </table>
    </cf_box>
</div>
<script type="text/javascript">
document.getElementById('keyword').focus();
 <cfif (fuseaction_ is 'demands' or  fuseaction_ is 'order') and is_show_multi_print eq 1>
	function send_services_print()
	{	
	<cfif len(attributes.is_submitted)>
			<cfif not get_po_det.recordcount>
				alert("<cf_get_lang dictionary_id='36586.Yazdırılacak Belge  Bulunamadı! Toplu Print Yapamazsınız'>!");
				return false;
			</cfif>
			<cfif get_po_det.recordcount eq 1>
				if(document.convert_demand_to_production.row_demand.checked == false)
				{
					alert("<cf_get_lang dictionary_id='36586.Yazdırılacak Belge  Bulunamadı! Toplu Print Yapamazsınız'>!");
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
					alert("<cf_get_lang dictionary_id='36586.Yazdırılacak Belge  Bulunamadı! Toplu Print Yapamazsınız'>!");
					return false;
				}
			</cfif>
			windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&print_type=#print_type_#</cfoutput>&iid='+service_list_,'page');
		<cfelse>
			alert("<cf_get_lang dictionary_id='36586.Yazdırılacak Belge  Bulunamadı! Toplu Print Yapamazsınız'>!");
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
		alert("<cf_get_lang no ='515.Spect Seçmek için öncelikle ürün seçmeniz gerekmektedir'>");
		return false;
		}
		else
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=search_list.spect_main_id&field_name=search_list.spect_name&is_display=1&stock_id='+document.search_list.stock_id.value);
	}
	function spect_remove()/*Eğer ürün seçildikten sonra spect seçilmişse yeniden ürün seçerse ilgili spect'i kaldır.*/
	{
		document.search_list.spect_main_id.value = "";
		document.search_list.spect_name.value = "";	
	}
	function connectAjax(crtrow,main_operation_id,p_operation_id,operation_type_id,line,req_id,order_id)
	{
        marj=5;
		var bb = '<cfoutput>#request.self#</cfoutput>?fuseaction=textile.emptypopup_ajax_list_operations&req_id='+req_id+'&order_id='+order_id+'&main_operation_id='+main_operation_id+'&p_operation_id='+p_operation_id+'&operation_type_id='+operation_type_id+'&line='+line+'&marj='+marj;
		AjaxPageLoad(bb,'DISPLAY_OPERATION_INFO'+crtrow,1);
    }
function operasyon_detay(id,req_id,order_id,req_no){
   window.location.href='<cfoutput>#request.self#?</cfoutput>fuseaction=textile.tracking&event=measurement&req_id='+req_id+'&order_id_='+order_id+'&req_no='+req_no+'&main_operation_id='+id;
}
</script>
