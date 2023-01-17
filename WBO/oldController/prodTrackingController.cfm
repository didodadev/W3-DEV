<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cf_xml_page_edit fuseact="prod.tracking">
    <cfparam name="attributes.short_code_id" default="">
    <cfparam name="attributes.spect_main_id" default="">
    <cfparam name="attributes.spect_name" default="">
    <cfparam name="attributes.product_name" default="">
    <cfparam name="attributes.product_id_" default="">
    <cfparam name="attributes.stock_id_" default="">
    <cfparam name="attributes.keyword" default="">
  <cfparam name="attributes.durum_siparis" default="0">
    <cfparam name="attributes.priority" default="">
    <cfparam name="attributes.date_filter" default="">
    <cfparam name="attributes.start_date" default="">
    <cfparam name="attributes.finish_date" default="">
    <cfparam name="attributes.start_date_order" default="">
    <cfparam name="attributes.finish_date_order" default="">
    <cfparam name="attributes.category_name" default="">
    <cfparam name="attributes.category" default="">
    <cfparam name="attributes.project_id" default="">
    <cfparam name="attributes.member_cat_type" default="">
    <cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
        <cf_date tarih='attributes.start_date'>
    <cfelse>
        <cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
            <cfset attributes.start_date=''>
        <cfelse>
            <cfset attributes.start_date=wrk_get_today()>
        </cfif>
    </cfif>	
    <cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
        <cf_date tarih='attributes.finish_date'>
    <cfelse>
        <cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
            <cfset attributes.finish_date=''>
        <cfelse>
        <cfset attributes.finish_date = date_add('d',1,now())>
        </cfif>
    </cfif>
    <cfif isdefined('attributes.start_date_order') and isdate(attributes.start_date_order)>
        <cf_date tarih='attributes.start_date_order'>
    <cfelse>
        <cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
            <cfset attributes.start_date_order=''>
        <cfelse>
            <cfset attributes.start_date_order=wrk_get_today()>
        </cfif>
    </cfif>	
    <cfif isdefined('attributes.finish_date_order') and isdate(attributes.finish_date_order)>
        <cf_date tarih='attributes.finish_date_order'>
    <cfelse>
        <cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
            <cfset attributes.finish_date_order=''>
        <cfelse>
        <cfset attributes.finish_date_order = date_add('d',1,now())>
        </cfif>
    </cfif>
    <cfparam name="attributes.sales_partner_id" default="">
    <cfparam name="attributes.sales_partner" default="">
    <cfparam name="attributes.order_employee_id" default="">
    <cfparam name="attributes.order_employee" default="">
    <cfparam name="attributes.consumer_id" default="">
    <cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.member_type" default="">
    <cfparam name="attributes.member_name" default="">
    <cfparam name="attributes.position_code" default="">
    <cfparam name="attributes.position_name" default="">
    <cfquery name="GET_PRIORITIES" datasource="#DSN#">
        SELECT
            PRIORITY_ID,
            PRIORITY
        FROM
            SETUP_PRIORITY
        ORDER BY
            PRIORITY_ID
    </cfquery>
    <cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
        SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT
    </cfquery>
    <cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
        SELECT CONSCAT_ID,CONSCAT FROM CONSUMER_CAT ORDER BY HIERARCHY
    </cfquery>
    <cfquery name="get_tree_xml_amount" datasource="#dsn#">
        SELECT 
            PROPERTY_VALUE,
            PROPERTY_NAME
        FROM
            FUSEACTION_PROPERTY
        WHERE
            OUR_COMPANY_ID = #session.ep.company_id# AND
            FUSEACTION_NAME = 'prod.add_product_tree' AND
            PROPERTY_NAME = 'is_show_prod_amount'
    </cfquery>
    <cfif get_tree_xml_amount.recordcount>
        <cfset is_show_prod_amount = get_tree_xml_amount.PROPERTY_VALUE>
    <cfelse>
        <cfset is_show_prod_amount = 1>
    </cfif>
 
	  <cfif is_show_delivery_date eq 1>
        <cfset show_deliver_date = 1>
      <cfelse>
        <cfset show_deliver_date = 0>
      </cfif>
    <cfset order_priority_list = valuelist(get_priorities.priority_id)>
    <cfif isdefined("attributes.is_submitted")>
		<cfscript>
            get_order_action = createObject("component", "production_plan.cfc.get_orders");
            get_order_action.dsn3 = dsn3;
            get_order_action.dsn_alias = dsn_alias;
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
				show_deliver_date : '#IIf(IsDefined("show_deliver_date"),"show_deliver_date",DE(""))#'
            );
        </cfscript>
    <cfelse>
        <cfset get_orders.recordcount = 0>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default='#get_orders.recordcount#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfscript>wrkUrlStrings('url_str','durum_siparis','is_submitted','keyword','priority','date_filter','sales_partner_id','sales_partner','order_employee_id','order_employee','consumer_id','company_id','member_type','member_name','stock_id_','product_id_','product_name','is_group_page');</cfscript>
    <cfif isdate(attributes.start_date)>
        <cfset url_str = url_str & "&start_date=#dateformat(attributes.start_date,'dd/mm/yyyy')#">
    </cfif>
    <cfif isdate(attributes.finish_date)>
        <cfset url_str = url_str & "&finish_date=#dateformat(attributes.finish_date,'dd/mm/yyyy')#">
    </cfif>
    <cfif isdate(attributes.start_date)>
        <cfset url_str = url_str & "&start_date=#dateformat(attributes.start_date,'dd/mm/yyyy')#">
    </cfif>
    <cfif isdate(attributes.finish_date_order)>
        <cfset url_str = url_str & "&finish_date_order=#dateformat(attributes.finish_date_order,'dd/mm/yyyy')#">
    </cfif>
    <cfif isdate(attributes.start_date_order)>
        <cfset url_str = url_str & "&start_date_order=#dateformat(attributes.start_date_order,'dd/mm/yyyy')#">
    </cfif>
    <cfif  len(attributes.member_cat_type)>
        <cfset url_str = "#url_str#&member_cat_type=#attributes.member_cat_type#">
    </cfif>
    <cfif isDefined('attributes.project_id') and len(attributes.project_id)>
        <cfset url_str = '#url_str#&project_id=#attributes.project_id#'>
    </cfif>
    <cfif isDefined('attributes.project_head') and len(attributes.project_head)>
        <cfset url_str = '#url_str#&project_head=#attributes.project_head#'>
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
    <cfif len(attributes.category)>
        <cfset url_str ="#url_str#&category=#attributes.category#">
    </cfif>
    <cfif len(attributes.category_name)>
        <cfset url_str= "#url_str#&category_name=#attributes.category_name#">
    </cfif>
<cfelseif attributes.event is 'det'>
    <cf_xml_page_edit fuseact="prod.add_prod_order">
    <cfquery name="get_tree_xml_amount" datasource="#dsn#">
        SELECT 
            PROPERTY_VALUE,
            PROPERTY_NAME
        FROM
            FUSEACTION_PROPERTY
        WHERE
            OUR_COMPANY_ID = #session.ep.company_id# AND
            FUSEACTION_NAME = 'prod.add_product_tree' AND
            PROPERTY_NAME = 'is_show_prod_amount'
    </cfquery>
    <cfif get_tree_xml_amount.recordcount>
        <cfset is_show_prod_amount = get_tree_xml_amount.PROPERTY_VALUE>
    <cfelse>
        <cfset is_show_prod_amount = 1>
    </cfif>
    <cfinclude template="../production_plan/query/get_order_detail.cfm">
    
     <cfif len(order_detail.partner_id)>
        <cfquery name="GET_ORDERER" datasource="#DSN#">
            SELECT 
                 C.FULLNAME,
                 CP.COMPANY_PARTNER_NAME,
                 CP.COMPANY_PARTNER_SURNAME,
                 C.COMPANY_ID 
            FROM 
                COMPANY_PARTNER CP,
                COMPANY C 
            WHERE
                CP.PARTNER_ID = #order_detail.partner_id# AND
                CP.COMPANY_ID = C.COMPANY_ID
        </cfquery>
        <cfelseif len(order_detail.company_id)>
            <cfquery name="GET_ORDERER" datasource="#DSN#">
                SELECT 
                     C.FULLNAME,
                     C.COMPANY_ID 
                FROM 
                    COMPANY C 
                WHERE
                    C.COMPANY_ID = #order_detail.company_id#
            </cfquery>
        <cfelseif len(order_detail.consumer_id)>
            <cfquery name="GET_ORDERER" datasource="#DSN#">
                SELECT 
                    CONSUMER_NAME, 
                    CONSUMER_SURNAME 
                FROM 
                    CONSUMER
                WHERE
                    CONSUMER_ID = #order_detail.consumer_id#
            </cfquery>
     </cfif>
     <cfif len(order_detail.PRIORITY_ID)>
      <cfquery name="GET_PRIORITIES" datasource="#DSN#">
            SELECT PRIORITY FROM SETUP_PRIORITY WHERE PRIORITY_ID=#order_detail.PRIORITY_ID#
       </cfquery>
     </cfif>
     <cfif len(ORDER_DETAIL.SHIP_METHOD)>
        <cfquery name="get_ship_type" datasource="#DSN#">
            SELECT SHIP_METHOD FROM SHIP_METHOD WHERE SHIP_METHOD_ID=#ORDER_DETAIL.SHIP_METHOD#
        </cfquery>
    </cfif>
    <cfif GET_ORDERS_PRODUCTS.recordcount>
		<cfset order_product_id_list = ValueList(GET_ORDERS_PRODUCTS.PRODUCT_ID,',')>
        <cfset order_stock_id_list = ValueList(GET_ORDERS_PRODUCTS.STOCK_ID,',')>
        <cfset order_stock_id_list=listsort(order_stock_id_list,"numeric","ASC",",")>
        <cfset order_product_id_list=listsort(order_product_id_list,"numeric","ASC",",")>
        <cfquery name="_PRODUCT_TOTAL_STOCK_" datasource="#DSN2#">
            SELECT 
                PRODUCT_TOTAL_STOCK,PRODUCT_ID
            FROM 
                GET_PRODUCT_STOCK 
            WHERE 
              <cfif isdefined("order_product_id_list") and len(order_product_id_list)>
                PRODUCT_ID IN (#order_product_id_list#)
              <cfelse>
                PRODUCT_ID IS NULL
              </cfif>
        </cfquery>
        <cfset order_product_id_list = listsort(listdeleteduplicates(valuelist(_PRODUCT_TOTAL_STOCK_.PRODUCT_ID,',')),'numeric','ASC',',')>
        <cfquery name="_GET_STOCK_RESERVED_" datasource="#DSN3#">
            SELECT
                ISNULL(SUM(STOCK_ARTIR),0) AS ARTAN,
                ISNULL(SUM(STOCK_AZALT),0) AS AZALAN,
                STOCK_ID
            FROM
                GET_STOCK_RESERVED
            WHERE
                STOCK_ID IN (#order_stock_id_list#)
            GROUP BY STOCK_ID	
        </cfquery>
        <cfset order_stock_id_list = listsort(listdeleteduplicates(valuelist(_GET_STOCK_RESERVED_.STOCK_ID,',')),'numeric','ASC',',')>
    </cfif>
    <cfoutput query="GET_ORDERS_PRODUCTS">
		<cfset attributes.stock_id = STOCK_ID>
        <cfset attributes.product_id = PRODUCT_ID>
        <cfif len(_PRODUCT_TOTAL_STOCK_.PRODUCT_TOTAL_STOCK[listfind(order_product_id_list,GET_ORDERS_PRODUCTS.PRODUCT_ID,',')])>
            <cfset PRODUCT_STOCK = _PRODUCT_TOTAL_STOCK_.PRODUCT_TOTAL_STOCK[listfind(order_product_id_list,GET_ORDERS_PRODUCTS.PRODUCT_ID,',')]>
        <cfelse>
            <cfset PRODUCT_STOCK = 0 >
        </cfif>
        <cfif _GET_STOCK_RESERVED_.recordcount and len(_GET_STOCK_RESERVED_.ARTAN)>
            <cfif len(_GET_STOCK_RESERVED_.ARTAN[listfind(order_stock_id_list,GET_ORDERS_PRODUCTS.STOCK_ID,',')])>
                <cfset GET_STOCK_RESERVED_ARTAN = _GET_STOCK_RESERVED_.ARTAN[listfind(order_stock_id_list,GET_ORDERS_PRODUCTS.STOCK_ID,',')]>
            <cfelse>
                <cfset GET_STOCK_RESERVED_ARTAN = 0>	
            </cfif>
            <cfset PRODUCT_ARTAN = GET_STOCK_RESERVED_ARTAN >
            <cfset PRODUCT_STOCK = PRODUCT_STOCK + GET_STOCK_RESERVED_ARTAN>
        </cfif>
        <cfif _GET_STOCK_RESERVED_.recordcount and len(_GET_STOCK_RESERVED_.AZALAN)>
            <cfif len(_GET_STOCK_RESERVED_.AZALAN[listfind(order_stock_id_list,GET_ORDERS_PRODUCTS.STOCK_ID,',')])>
                <cfset GET_STOCK_RESERVED_AZALAN = _GET_STOCK_RESERVED_.AZALAN[listfind(order_stock_id_list,GET_ORDERS_PRODUCTS.STOCK_ID,',')] >
            <cfelse>
                <cfset GET_STOCK_RESERVED_AZALAN = 0 >
            </cfif>
            <cfset PRODUCT_AZALAN = GET_STOCK_RESERVED_AZALAN>
            <cfset PRODUCT_STOCK = PRODUCT_STOCK - GET_STOCK_RESERVED_AZALAN >
        </cfif>
        <cfquery name="GET_PRODUCTION_INFO" datasource="#DSN3#">
            SELECT
                SUM(PO.QUANTITY) QUANTITY
            FROM 
                PRODUCTION_ORDERS PO 
            WHERE 
                P_ORDER_ID IN(SELECT PRODUCTION_ORDER_ID FROM PRODUCTION_ORDERS_ROW WHERE ORDER_ROW_ID IN (#attributes.order_row_id#))
                AND PRODUCTION_LEVEL = 0
        </cfquery>
        <cfif GET_PRODUCTION_INFO.recordcount and len(GET_PRODUCTION_INFO.QUANTITY)>
            <cfset 'verilen_uretim_emri#currentrow#' = GET_PRODUCTION_INFO.QUANTITY>
        <cfelse>
            <cfset 'verilen_uretim_emri#currentrow#' =  0>
        </cfif>
        <cfif len(_PRODUCT_TOTAL_STOCK_.PRODUCT_TOTAL_STOCK[listfind(order_product_id_list,GET_ORDERS_PRODUCTS.PRODUCT_ID,',')]) and _PRODUCT_TOTAL_STOCK_.PRODUCT_TOTAL_STOCK[listfind(order_product_id_list,GET_ORDERS_PRODUCTS.PRODUCT_ID,',')] lt 0>
            <cfset gerekli_uretim_miktari = QUANTITY - _PRODUCT_TOTAL_STOCK_.PRODUCT_TOTAL_STOCK[listfind(order_product_id_list,GET_ORDERS_PRODUCTS.PRODUCT_ID,',')]>
        <cfelse>
            <cfset gerekli_uretim_miktari = QUANTITY >
        </cfif>
        <cfset gerekli_uretim_miktari = gerekli_uretim_miktari - Evaluate('verilen_uretim_emri#currentrow#')>
         
	</cfoutput>
</cfif>  

<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<script type="text/javascript">
	function get_tree(){
			if($("#stock_id_").val().length)
			{
				deneme = wrk_query("SELECT IS_PRODUCTION FROM STOCKS S WHERE S.STOCK_ID = " + $("#stock_id_").val(),"DSN3");
				console.log('SELECT IS_PRODUCTION FROM STOCKS S WHERE S.STOCK_ID = ' + $("#stock_id_").val());
				deneme2 = wrk_query("SELECT SPECT_MAIN_ID FROM PRODUCT_TREE PT WHERE PT.STOCK_ID = " + $("#stock_id_").val(),"DSN3");
				
				if(deneme.IS_PRODUCTION == 1 && (deneme2.recordcount == 0 || deneme2.SPECT_MAIN_ID == '') ){
					alert("Ürünü Üretildiği Halde Bir Ağacı Yok Görünüyor Üretilen Ürünü Ağaca Eklemek İçin Önce Ürünün Kendi Ağacını Oluşturmalısınız");
						$("#stock_id_").val('');
					$("#product_name").val('');
					return false;
				}
			}
		}
	
	function change_date_info()
	{
		if(document.getElementById('temp_hour').value == '' || document.getElementById('temp_hour').value > 23)
			document.getElementById('temp_hour').value = '00';
		if(document.getElementById('temp_min').value == '' || document.getElementById('temp_min').value > 59)
			document.getElementById('temp_min').value = '00';
		if(document.getElementById('temp_date').value!= '')
			for (i=0;i<document.getElementsByName('is_active').length;i++)
			{
				new_row_number = parseInt(<cfoutput>#attributes.startrow#</cfoutput>+i);
				document.getElementById('production_start_date_'+new_row_number).value = document.getElementById('temp_date').value;
				document.getElementById('production_start_h_'+new_row_number).value = parseFloat(document.getElementById('temp_hour').value);
				document.getElementById('production_start_m_'+new_row_number).value = parseFloat(document.getElementById('temp_min').value);
			}
	}
	function connectAjax(crtrow,prod_id,stock_id,order_amount,order_id,spect_main_id,optimum_ihtiyac){
		if(order_id==0) var order_id = document.getElementById('order_ids_'+crtrow).value;
		if(optimum_ihtiyac == undefined) optimum_ihtiyac = 1;
		if(order_amount == 0) order_amount=1;
		var bb = '<cfoutput>#request.self#?fuseaction=objects.emptypopup_ajax_product_stock_info&this_production_amount='+optimum_ihtiyac+'&tree_stock_status=1&is_show_prod_amount=#is_show_prod_amount#</cfoutput>&row_number='+crtrow+'&pid='+prod_id+'&sid='+ stock_id+'&amount='+ order_amount+'&order_id='+ order_id+'&spect_main_id='+spect_main_id;
		AjaxPageLoad(bb,'DISPLAY_ORDER_STOCK_INFO'+crtrow,1);
	}
	</script>
<cfelseif attributes.event is 'det'>
	<script type="text/javascript">
		function calculate_production_amounts(){
			var old_amount = filterNum(document.getElementById('product_amount_old').value,3);
			var production_amounts = document.getElementsByName('product_amount').length;
			var rate = parseFloat(old_amount/parseInt(document.getElementById('product_amount0').value));
			for (ii=0;ii<production_amounts;ii++){
				document.all.product_amount[ii].value = parseInt((filterNum(document.all.product_amount[ii].value,4))/(rate));
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'prod.tracking';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'production_plan/display/list_order.cfm';
	WOStruct['#attributes.fuseaction#']['list']['default'] = 1;	
	
	WOStruct['#attributes.fuseaction#']['det'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'prod.tracking';
	WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'production_plan/display/detail_order.cfm';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'production_plan/display/detail_order.cfm';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = '';
	WOStruct['#attributes.fuseaction#']['det']['parameters'] = '';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '';
	
	 if(attributes.event is 'det')
	{				
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['text'] = 'Sipariş Detay Sayfası';
		if (len(order_detail.IS_INSTALMENT) and order_detail.IS_INSTALMENT eq 1)	
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=sales.upd_fast_sale&order_id=#attributes.order_id#','list')";
		else
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=sales.list_order&event=upd&order_id=#attributes.order_id#','page')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons'] = structNew();	
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['print']['text'] = 'Yazdır';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.order_id#&print_type=73','list')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
