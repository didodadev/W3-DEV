<cf_get_lang_set module_name="sales">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cf_xml_page_edit fuseact ="sales.list_order" default_value="1">
    <cfparam name="attributes.product_name" default="">
    <cfparam name="attributes.product_id" default="">
    <cfparam name="attributes.short_code_id" default="">
    <cfparam name="attributes.short_code_name" default="">
    <cfparam name="attributes.prod_cat" default="">
    <cfparam name="attributes.start_date" default="">
    <cfparam name="attributes.finish_date" default="">
    <cfparam name="attributes.order_employee" default="">
    <cfparam name="attributes.order_employee_id" default="">
    <cfparam name="attributes.sales_member_name" default="">
    <cfparam name="attributes.sales_member_id" default="">
    <cfparam name="attributes.sales_member_type" default="">
    <cfparam name="attributes.order_stage" default="">
    <cfparam name="attributes.sale_add_option" default="">
    <cfparam name="attributes.sales_departments" default="">
    <cfif xml_listing_type eq 1>
    	<cfparam name="attributes.listing_type" default="2">
    <cfelse>
   		<cfparam name="attributes.listing_type" default="">
    </cfif>
    <cfparam name="attributes.quantity" default="">
    <cfparam name="attributes.unit" default="">
    <cfparam name="attributes.project_id" default="">
    <cfparam name="attributes.project_head" default="">
    <cfparam name="attributes.subscription_id" default="">
    <cfparam name="attributes.subscription_no" default="">
    <cfparam name="attributes.brand_id" default="">
    <cfparam name="attributes.brand_name" default="">
    <cfparam name="attributes.sort_type" default="4">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.keyword_orderno" default="">
    <cfparam name="attributes.branch_id" default="">
    <cfparam name="attributes.zone_id" default="">
    <cfparam name="attributes.sales_county" default="">
    <cfparam name="attributes.record_emp_id" default="">
    <cfparam name="attributes.record_cons_id" default="">
    <cfparam name="attributes.record_part_id" default="">
    <cfparam name="attributes.record_name" default="">
    <cfparam name="attributes.card_paymethod_id" default="">
    <cfparam name="attributes.paymethod_id" default="">
    <cfparam name="attributes.paymethod" default="">
    <cfparam name="attributes.irsaliye_fatura" default="">
    <cfparam name="attributes.use_efatura" default="">
    
    <cfif listlen(attributes.fuseaction,'.') eq 2 and listgetat(attributes.fuseaction,2,'.') is 'list_order_instalment'>
        <cfset attributes.is_instalment = 1>
    </cfif>
    <cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
        <cf_date tarih="attributes.start_date">
    <cfelse>
        <cfif session.ep.our_company_info.unconditional_list>
            <cfset attributes.start_date=''>
        <cfelse>
            <cfset attributes.start_date = wrk_get_today()>
        </cfif>
    </cfif>
    <cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
        <cf_date tarih="attributes.finish_date">
    <cfelse>
        <cfif session.ep.our_company_info.unconditional_list>
            <cfset attributes.finish_date=''>
        <cfelse>
            <cfset attributes.finish_date = date_add('ww',1,attributes.start_date)>
        </cfif>
    </cfif>
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'> 
    <cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >
    
    <cfif isdefined("attributes.form_varmi")>
        <cfset arama_yapilmali = 0>
        <cfscript>
        get_order_list_action = createObject("component", "sales.cfc.get_order_list");
        get_order_list_action.dsn3 = dsn3;
        get_order_list_action.dsn_alias = dsn_alias;
        get_order_list = get_order_list_action.get_order_list_fnc
            (
                listing_type : '#IIf(IsDefined("attributes.listing_type"),"attributes.listing_type",DE(""))#',
                sort_type : '#IIf(IsDefined("attributes.sort_type"),"attributes.sort_type",DE("4"))#',
                x_control_ims : '#IIf(IsDefined("x_control_ims"),"x_control_ims",DE("0"))#',
                x_show_special_definition : '#IIf(IsDefined("x_show_special_definition"),"x_show_special_definition",DE("0"))#',
                x_multiple_filters : '#IIf(IsDefined("x_multiple_filters"),"x_multiple_filters",DE("0"))#',
                x_show_other_money_value : '#IIf(IsDefined("x_show_other_money_value"),"x_show_other_money_value",DE("0"))#',
                prod_cat : '#IIf(IsDefined("attributes.prod_cat"),"attributes.prod_cat",DE(""))#',
                product_name : '#IIf(IsDefined("attributes.product_name"),"attributes.product_name",DE(""))#',
                product_id : '#IIf(IsDefined("attributes.product_id"),"attributes.product_id",DE(""))#',
                currency_id : '#IIf(IsDefined("attributes.currency_id"),"attributes.currency_id",DE(""))#',
                employee_id : '#IIf(IsDefined("attributes.employee_id"),"attributes.employee_id",DE(""))#',
                employee_name : '#IIf(IsDefined("attributes.employee"),"attributes.employee",DE(""))#',
                order_employee_id : '#IIf(IsDefined("attributes.order_employee_id"),"attributes.order_employee_id",DE(""))#',
                order_employee : '#IIf(IsDefined("attributes.order_employee"),"attributes.order_employee",DE(""))#',
                brand_name : '#IIf(IsDefined("attributes.brand_name"),"attributes.brand_name",DE(""))#',
                brand_id : '#IIf(IsDefined("attributes.brand_id"),"attributes.brand_id",DE(""))#',
                short_code_name : '#IIf(IsDefined("attributes.short_code_name"),"attributes.short_code_name",DE(""))#',
                short_code_id : '#IIf(IsDefined("attributes.short_code_id"),"attributes.short_code_id",DE(""))#',
                sales_departments : '#IIf(IsDefined("attributes.sales_departments"),"attributes.sales_departments",DE(""))#',
                status : '#IIf(IsDefined("attributes.status"),"attributes.status",DE(""))#',
                subscription_no : '#IIf(IsDefined("attributes.subscription_no"),"attributes.subscription_no",DE(""))#',
                subscription_id : '#IIf(IsDefined("attributes.subscription_id"),"attributes.subscription_id",DE(""))#',
                priority : '#IIf(IsDefined("attributes.priority"),"attributes.priority",DE(""))#',
                keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(""))#',
                keyword_orderno : '#IIf(IsDefined("attributes.keyword_orderno"),"attributes.keyword_orderno",DE(""))#',
                member_type : '#IIf(IsDefined("attributes.member_type"),"attributes.member_type",DE(""))#',
                member_name : '#IIf(IsDefined("attributes.member_name"),"attributes.member_name",DE(""))#',
                company_id : '#IIf(IsDefined("attributes.company_id"),"attributes.company_id",DE(""))#',
                consumer_id : '#IIf(IsDefined("attributes.consumer_id"),"attributes.consumer_id",DE(""))#',
                sales_member_type : '#IIf(IsDefined("attributes.sales_member_type"),"attributes.sales_member_type",DE(""))#',
                sales_member_name : '#IIf(IsDefined("attributes.sales_member_name"),"attributes.sales_member_name",DE(""))#',
                sales_member_id : '#IIf(IsDefined("attributes.sales_member_id"),"attributes.sales_member_id",DE(""))#',
                start_date : '#IIf(IsDefined("attributes.start_date"),"attributes.start_date",DE(""))#',
                finish_date : '#IIf(IsDefined("attributes.finish_date"),"attributes.finish_date",DE(""))#',
                order_stage : '#IIf(IsDefined("attributes.order_stage"),"attributes.order_stage",DE(""))#',
                sales_county : '#IIf(IsDefined("attributes.sales_county"),"attributes.sales_county",DE(""))#',
                sale_add_option : '#IIf(IsDefined("attributes.sale_add_option"),"attributes.sale_add_option",DE(""))#',
                branch_id : '#IIf(IsDefined("attributes.branch_id"),"attributes.branch_id",DE(""))#',
                zone_id : '#IIf(IsDefined("attributes.zone_id"),"attributes.zone_id",DE(""))#',
                record_emp_id : '#IIf(IsDefined("attributes.record_emp_id"),"attributes.record_emp_id",DE(""))#',
                record_cons_id : '#IIf(IsDefined("attributes.record_cons_id"),"attributes.record_cons_id",DE(""))#',
                record_part_id : '#IIf(IsDefined("attributes.record_part_id"),"attributes.record_part_id",DE(""))#',
                record_name : '#IIf(IsDefined("attributes.record_name"),"attributes.record_name",DE(""))#',
                project_head : '#IIf(IsDefined("attributes.project_head"),"attributes.project_head",DE(""))#',
                project_id : '#IIf(IsDefined("attributes.project_id"),"attributes.project_id",DE(""))#',
                module_name : '#fusebox.circuit#',
                is_instalment : '#IIf(IsDefined("attributes.is_instalment"),"attributes.is_instalment",DE("0"))#',
                card_paymethod_id : '#attributes.card_paymethod_id#',
                paymethod_id : '#attributes.paymethod_id#',
                paymethod : '#attributes.paymethod#',
                startrow : '#attributes.startrow#',
                maxrows : '#attributes.maxrows#',
                dsn2_alias : '#dsn2_alias#',
                irsaliye_fatura : '#IIf(IsDefined("attributes.irsaliye_fatura"),"attributes.irsaliye_fatura",DE(""))#',
                related_orders : '#IIf(IsDefined("attributes.related_orders"),"attributes.related_orders",DE(""))#',
                use_efatura : '#IIf(IsDefined("attributes.use_efatura"),"attributes.use_efatura",DE(""))#'
            );
        </cfscript>
    <cfelse>
        <cfset arama_yapilmali = 1>
        <cfset get_order_list.recordcount = 0>
    </cfif>
    <cfscript>
        if (isdefined("attributes.keyword")) url_str = "keyword=#attributes.keyword#"; else attributes.keyword = "";
        if (isdefined("attributes.keyword_orderno")) url_str = "#url_str#&keyword_orderno=#attributes.keyword_orderno#"; else attributes.keyword_orderno = "";
        if (isdefined("attributes.currency_id")) url_str = "#url_str#&currency_id=#attributes.currency_id#"; else attributes.currency_id = "";
        if (isdefined("attributes.status"))	url_str = "#url_str#&status=#attributes.status#"; else attributes.status = 1;
    </cfscript>
    <cfinclude template="../sales/query/get_priorities.cfm">
    <cfif isdefined("get_order_list.query_count")>
        <cfparam name="attributes.totalrecords" default="#get_order_list.query_count#">
    <cfelse>
        <cfparam name="attributes.totalrecords" default="#get_order_list.recordcount#">
    </cfif>
    
    <cfquery name="get_process_type" datasource="#DSN#">
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
            <cfif listlen(attributes.fuseaction,'.') eq 2 and listgetat(attributes.fuseaction,2,'.') is 'list_order_instalment'>
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listfirst(attributes.fuseaction,'.')#.list_order_instalment%">
            <cfelse>
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listfirst(attributes.fuseaction,'.')#.list_order%">
                AND PT.FACTION NOT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listfirst(attributes.fuseaction,'.')#.list_order_instalment%">
            </cfif>
        ORDER BY
            PT.PROCESS_NAME,
            PTR.LINE_NUMBER
    </cfquery>
    <cfquery name="get_department_name" datasource="#DSN#">
        SELECT 
            SL.LOCATION_ID,
            SL.COMMENT,
            D.DEPARTMENT_ID,
            D.DEPARTMENT_HEAD,
            D.BRANCH_ID
        FROM
            STOCKS_LOCATION SL,
            DEPARTMENT D
        WHERE 
            SL.DEPARTMENT_ID = D.DEPARTMENT_ID
            AND D.BRANCH_ID IN (SELECT BRANCH_ID FROM BRANCH WHERE COMPANY_ID = #session.ep.company_id#)
        ORDER BY
            D.DEPARTMENT_HEAD,
            SL.COMMENT
    </cfquery>
    <cfquery name="get_branch" datasource="#dsn#">
        SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE COMPANY_ID = #session.ep.company_id# ORDER BY BRANCH_NAME
    </cfquery>
    <cfif isdefined("attributes.is_instalment")>
        <cfsavecontent variable="head"><cf_get_lang_main no='796.Taksitli Satislar'></cfsavecontent>
    <cfelse>
        <cfsavecontent variable="head"><cf_get_lang no='6.siparisler'></cfsavecontent>
    </cfif>
<cfelseif (isdefined("attributes.event") and attributes.event is 'add')>
    <cfparam name="attributes.consumer_reference_code" default="">
    <cfparam name="attributes.partner_reference_code" default="">
   <cf_xml_page_edit fuseact ="objects.popup_add_spect_list" default_value="1">
    <cf_xml_page_edit fuseact ="sales.form_add_order">
    <!--- Bu spec'in ayarlarını çekmek için! --->
    <cfif fuseaction contains 'store.'>
        <cfset modul_ = "store">
    <cfelse>
        <cfset modul_ = "sales">
    </cfif>
    <cfset xfa.add = '#modul_#.emptypopup_add_order'>
    <cfscript>
        if(isdefined("attributes.order_id") and len(attributes.order_id))
            session_basket_kur_ekle(process_type:1,table_type_id:3,action_id:attributes.ORDER_ID);
        else if(isDefined("attributes.offer_id") and len(attributes.offer_id))
            session_basket_kur_ekle(process_type:1,table_type_id:4,to_table_type_id:3,action_id:attributes.offer_id);
        else
            session_basket_kur_ekle(process_type:0);
    </cfscript>
    <cfif xml_country eq 1>
        <cfset cmp = createObject("component","settings.cfc.setupCountry") />
        <cfset GET_COUNTRY_1 = cmp.getCountry()>
        <cfquery name="GET_SALE_ZONES" datasource="#DSN#">
            SELECT SZ_ID,SZ_NAME FROM SALES_ZONES WHERE IS_ACTIVE=1 ORDER BY SZ_NAME
        </cfquery>
    </cfif>
    
    <cfparam name="attributes.deliver_dept_name" default="">
    <cfparam name="attributes.deliver_dept_id" default="">
    <cfparam name="attributes.deliver_loc_id" default="">
    <cfparam name="attributes.branch_id" default="">
    <cfparam name="attributes.country_id1" default="">
    <cfparam name="attributes.sales_zone_id" default="">
    
    <cfinclude template="../sales/query/get_priorities.cfm">
    <cfinclude template="../sales/query/get_moneys.cfm">
    <cfinclude template="../sales/query/get_commethod_cats.cfm">
    <cfset attributes.order_head = "Siparişiniz">
    <cfif not isdefined("attributes.order_date")>
        <cfset attributes.order_date = DateFormat(now(),'dd/mm/yyyy')>
        <cfset attributes.ship_date = DateFormat(now(),'dd/mm/yyyy')>
        <cfset attributes.deliverdate = DateFormat(now(),'dd/mm/yyyy')>
    <cfelse>
        <cfset attributes.order_date = attributes.order_date>
        <cfset attributes.ship_date = attributes.order_date>
        <cfset attributes.deliverdate = attributes.order_date>
    </cfif>
    <cfset attributes.ref_company_id = "">
    <cfset attributes.ref_member_type = "">
    <cfset attributes.ref_member_id = "">
    <cfif not (isdefined("attributes.order_employee_id") and Len(attributes.order_employee_id))>
        <cfset attributes.order_employee_id = session.ep.userid>
    </cfif>
    <cfparam name="attributes.basket_due_value_date_" default= "#DateFormat(now(),'dd/mm/yyyy')#">
    <cfif isDefined("attributes.subscription_id")><!--- sistemden sipariş ekleme ekranı için --->
        <cfinclude template="../sales/query/get_subsciption_contract.cfm">
        <cfset attributes.order_head = "SİSTEM #get_subscription.subscription_no#&nbsp;#get_subscription.subscription_type#&nbsp;#montage_emp_#">
        <cfif isDefined("xml_is_invoice_member")><!--- sistemden fatura şirketine sipariş oluştursn xml i seçili oldgunda --->
             <cfset attributes.company_id = get_subscription.invoice_company_id> 
            <cfset attributes.partner_id = get_subscription.invoice_partner_id>
            <cfset attributes.consumer_id = get_subscription.invoice_consumer_id>
        <cfelse>
             <cfset attributes.company_id = get_subscription.company_id> 
            <cfset attributes.partner_id = get_subscription.partner_id>
            <cfset attributes.consumer_id = get_subscription.consumer_id>
        </cfif>
        <cfset attributes.deliver_comp_id = get_subscription.company_id>
        <cfset attributes.deliver_cons_id = get_subscription.consumer_id>
        <cfif len(get_subscription.ref_partner_id)>
            <cfset attributes.ref_company_id = get_subscription.ref_company_id>
            <cfset attributes.ref_member_type = "partner">
            <cfset attributes.ref_member_id = get_subscription.ref_partner_id>
            <cfset attributes.ref_company = get_par_info(get_subscription.ref_company_id,1,0,0)>
            <cfset attributes.ref_member = get_par_info(get_subscription.ref_partner_id,0,-1,0)>
        <cfelseif len(get_subscription.ref_consumer_id)>
            <cfset attributes.ref_company_id = get_subscription.ref_company_id>
            <cfset attributes.ref_member_type = "consumer">
            <cfset attributes.ref_member_id = get_subscription.ref_consumer_id>
            <cfset attributes.ref_company = get_cons_info(get_subscription.ref_consumer_id,2,0)>
            <cfset attributes.ref_member = get_cons_info(get_subscription.ref_consumer_id,0,0,0)>
        </cfif>
        <cfif len(get_subscription.sales_partner_id)>
            <cfset attributes.sales_member_id = get_subscription.sales_partner_id>
            <cfset attributes.sales_member_type = "partner">
            <cfset attributes.sales_member = get_par_info(get_subscription.sales_partner_id,0,-1,0)>
        <cfelseif len(get_subscription.sales_consumer_id)>
            <cfset attributes.sales_member_id = get_subscription.sales_consumer_id>
            <cfset attributes.sales_member_type = "consumer">
            <cfset attributes.sales_member = get_cons_info(get_subscription.sales_consumer_id,1,0)>	
        </cfif>
        <cfset attributes.ship_city_id = get_subscription.ship_city_id>
        <cfset attributes.ship_address_county_id = get_subscription.ship_county_id>
        <cfset attributes.ship_address = get_subscription.ship_address>
        <cfset attributes.ship_address_id_ = ''>
    <cfelseif isdefined('attributes.from_project_material')><!--- Proje Malzeme İhtiyaç Planından ekleme yapmak için. --->
        <cfinclude template="../sales/query/get_project_metarial.cfm">
        <cfif not isdefined('attributes.from_project_material_id')>
            <cfquery name="GET_PRO_MATERIAL_IDS" datasource="#DSN#"><!--- Eğer proje id'si geliyorsa bu projeye ait metarial id'lerini buluyoruz--->
                SELECT PRO_MATERIAL_ID FROM PRO_MATERIAL WHERE PROJECT_ID = #attributes.from_project_material#
            </cfquery>
            <cfif GET_PRO_MATERIAL_IDS.recordcount>
                <cfset attributes.from_project_material_id = ValueList(GET_PRO_MATERIAL_IDS.PRO_MATERIAL_ID,',')>
            </cfif>
        </cfif>
    <cfelseif isdefined("attributes.order_id") and len(attributes.order_id) and not isdefined("attributes.upd_order")><!--- Siparis Kopyalama --->
        <cfinclude template="../sales/query/get_order_detail.cfm">
        <cfset attributes.order_head = get_order_detail.order_head>
        <cfset attributes.order_detail = get_order_detail.order_detail>
         <cfset attributes.company_id = get_order_detail.company_id> 
        <cfset attributes.partner_id = get_order_detail.partner_id>
        <cfset attributes.consumer_id = get_order_detail.consumer_id>
        <cfset attributes.order_date = DateFormat(get_order_detail.order_date,'dd/mm/yyyy')>
        <cfset attributes.ship_date = DateFormat(get_order_detail.ship_date,'dd/mm/yyyy')>
        <cfset attributes.deliverdate = DateFormat(get_order_detail.deliverdate,'dd/mm/yyyy')>
        <cfset attributes.priority_id = get_order_detail.priority_id>
        <cfset attributes.paymethod_id = get_order_detail.paymethod>
        <cfset attributes.card_paymethod_id = get_order_detail.card_paymethod_id>
        <cfif len(get_order_detail.ref_partner_id)>
            <cfset attributes.ref_company_id = get_order_detail.ref_company_id>
            <cfset attributes.ref_member_type = "partner">
            <cfset attributes.ref_member_id = get_order_detail.ref_partner_id>
            <cfset attributes.ref_company = get_par_info(get_order_detail.ref_company_id,1,0,0)>
            <cfset attributes.ref_member = get_par_info(get_order_detail.ref_partner_id,0,-1,0)>
        <cfelseif len(get_order_detail.ref_consumer_id)>
            <cfset attributes.ref_company_id = get_order_detail.ref_company_id>
            <cfset attributes.ref_member_type = "consumer">
            <cfset attributes.ref_member_id = get_order_detail.ref_consumer_id>
            <cfset attributes.ref_company = get_cons_info(get_order_detail.ref_consumer_id,2,0)>
            <cfset attributes.ref_member = get_cons_info(get_order_detail.ref_consumer_id,0,0,0)>
        </cfif>
        <cfset attributes.partner_reference_code = get_order_detail.partner_reference_code>
        <cfset attributes.consumer_reference_code = get_order_detail.consumer_reference_code>
        <cfset attributes.order_employee_id = get_order_detail.order_employee_id>
        <cfif len(get_order_detail.due_date) and len(get_order_detail.order_date)>
            <cfset attributes.basket_due_value = datediff('d',get_order_detail.order_date,get_order_detail.due_date)>
        </cfif>
        <cfset attributes.basket_due_value_date_ = DateFormat(get_order_detail.due_date,'dd/mm/yyyy')>
        <cfif len(get_order_detail.sales_partner_id)>
            <cfset attributes.sales_member_id = get_order_detail.sales_partner_id>
            <cfset attributes.sales_member_type = "partner">
            <cfset attributes.sales_member = get_par_info(get_order_detail.sales_partner_id,0,-1,0)>
        <cfelseif len(get_order_detail.sales_consumer_id)>
            <cfset attributes.sales_member_id = get_order_detail.sales_consumer_id>
            <cfset attributes.sales_member_type = "consumer">
            <cfset attributes.sales_member = get_cons_info(get_order_detail.sales_consumer_id,1,0)>	
        </cfif>
        <cfset attributes.ship_method_id = get_order_detail.ship_method>
        <cfset attributes.commethod_id = get_order_detail.commethod_id>
        <cfset attributes.project_id = get_order_detail.project_id>
        <cfset attributes.offer_id = get_order_detail.offer_id>
        <cfset attributes.reserved = get_order_detail.reserved>
        <cfset attributes.sales_add_option_id = get_order_detail.sales_add_option_id>
        <cfset attributes.ref_no = get_order_detail.ref_no>
        <cfset attributes.ship_city_id = get_order_detail.city_id>
        <cfset attributes.ship_address_county_id = get_order_detail.county_id>
        <cfset attributes.ship_address = get_order_detail.ship_address>
        <cfset attributes.ship_address_id_ = get_order_detail.ship_address_id>
        <cfset attributes.country_id1=get_order_detail.country_id>
        <cfset attributes.sales_zone_id=get_order_detail.zone_id>
        <cfif len(get_order_detail.deliver_dept_id) and len(get_order_detail.location_id)>
            <cfset location_info_ = get_location_info(get_order_detail.deliver_dept_id,get_order_detail.location_id,1,1)>
            <cfset attributes.branch_id = listlast(location_info_,',')>
            <cfset attributes.deliver_loc_id = get_order_detail.location_id>
            <cfset attributes.deliver_dept_id = get_order_detail.deliver_dept_id>
            <cfset attributes.deliver_dept_name = listfirst(location_info_,',')>
        </cfif>
        <cfset attributes.deliver_comp_id = get_order_detail.deliver_comp_id>
        <cfset attributes.deliver_cons_id = get_order_detail.deliver_cons_id>
        <cfset attributes.related_subs_id = get_order_detail.subscription_id><!--- ayrı bir değişkenle takip edildi çünkü sistemden sipariş oluşturma ile karışıyordu yoksa --->
    <cfelseif not isdefined("attributes.order_id") and isdefined("attributes.project_id") and len(attributes.project_id) and not isdefined("attributes.upd_order")>
        <cfquery name="get_project" datasource="#dsn#">
            SELECT COMPANY_ID,PARTNER_ID,CONSUMER_ID,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID = #attributes.project_id#
        </cfquery>
        <cfset attributes.company_id = get_project.company_id>
        <cfset attributes.partner_id = get_project.partner_id>
        <cfset attributes.consumer_id = get_project.consumer_id>
    <cfelseif isDefined("offer_row_check_info") and Len(offer_row_check_info)><!--- Satir Bazinda Teklif - Siparise Donusturme --->
        <cfif isDefined("attributes.company_id") and Len(attributes.company_id)>
            <cfquery name="get_partner" datasource="#dsn#">
                SELECT MANAGER_PARTNER_ID FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
            </cfquery>
            <cfset attributes.partner_id = get_partner.manager_partner_id>
        </cfif>
    <cfelseif isDefined("attributes.offer_id") and Len(attributes.offer_id)><!--- Belge Bazinda --->
        <cfinclude template="../sales/query/get_offer.cfm">
        <cfset attributes.order_head = get_offer.offer_head>
        <cfset attributes.order_detail = get_offer.offer_detail>
        <cfif ListLen(ListSort(ListDeleteDuplicates(ValueList(get_offer.partner_id)),"numeric","asc",",")) eq 1>
            <cfset attributes.company_id = get_offer.company_id> 
            <cfset attributes.partner_id = get_offer.partner_id>
        <cfelse>
            <cfset attributes.company_id = ""> 
            <cfset attributes.partner_id = "">
        </cfif>
        <cfif ListLen(ListSort(ListDeleteDuplicates(ValueList(get_offer.consumer_id)),"numeric","asc",",")) eq 1>
            <cfset attributes.consumer_id = get_offer.consumer_id>
        <cfelse>
            <cfset attributes.consumer_id = "">
        </cfif>
        <cfset attributes.ship_date = DateFormat(get_offer.ship_date,'dd/mm/yyyy')>
        <cfset attributes.deliverdate = DateFormat(get_offer.deliverdate,'dd/mm/yyyy')>
        <cfset attributes.priority_id = get_offer.priority_id>
        <cfset attributes.paymethod_id = get_offer.paymethod>
        <cfset attributes.commethod_id = get_offer.commethod_id>
        <cfset attributes.card_paymethod_id = get_offer.card_paymethod_id>
        <cfset attributes.country_id1=get_offer.country_id>
        <cfset attributes.sales_zone_id=get_offer.sz_id>
        <cfif len(get_offer.ref_partner_id)>
            <cfset attributes.ref_company_id = get_offer.ref_company_id>
            <cfset attributes.ref_member_type = "partner">
            <cfset attributes.ref_member_id = get_offer.ref_partner_id>
            <cfset attributes.ref_company = get_par_info(get_offer.ref_company_id,1,0,0)>
            <cfset attributes.ref_member = get_par_info(get_offer.ref_partner_id,0,-1,0)>
        <cfelseif len(get_offer.ref_consumer_id)>
            <cfset attributes.ref_company_id = get_offer.ref_company_id>
            <cfset attributes.ref_member_type = "consumer">
            <cfset attributes.ref_member_id = get_offer.ref_consumer_id>
            <cfset attributes.ref_company = get_cons_info(get_offer.ref_consumer_id,2,0)>
            <cfset attributes.ref_member = get_cons_info(get_offer.ref_consumer_id,0,0,0)>
        </cfif>
        <cfset attributes.order_employee_id = get_offer.sales_emp_id>
        <cfset attributes.basket_due_value_date_ = attributes.basket_due_value_date_>
        <cfif len(get_offer.sales_partner_id)>
            <cfset attributes.sales_member_id = get_offer.sales_partner_id>
            <cfset attributes.sales_member_type = "partner">
            <cfset attributes.sales_member = get_par_info(get_offer.sales_partner_id,0,-1,0)>
        <cfelseif len(get_offer.sales_consumer_id)>
            <cfset attributes.sales_member_id = get_offer.sales_consumer_id>
            <cfset attributes.sales_member_type = "consumer">
            <cfset attributes.sales_member = get_cons_info(get_offer.sales_consumer_id,1,0)>	
        </cfif>
        <cfset attributes.ship_method_id = get_offer.ship_method>
        <cfset attributes.commethod_id = get_offer.commethod_id>
        <cfset attributes.project_id = get_offer.project_id>
        <cfset attributes.offer_id = get_offer.offer_id>
        <cfset attributes.sales_add_option_id = get_offer.sales_add_option_id>
        <cfset attributes.ref_no = get_offer.ref_no>
        <cfset attributes.ship_city_id = get_offer.city_id>
        <cfset attributes.ship_address_county_id = get_offer.county_id>
        <cfset attributes.ship_address = get_offer.ship_address>
        <cfset attributes.ship_address_id_ = get_offer.ship_address_id>
    <cfelseif isdefined("attributes.upd_order")>
        <cfinclude template="add_all_of_product_order.cfm">
        <cfif len(attributes.related_order_id) and len(attributes.related_order_no)>
            <cfset attributes.ref_no = attributes.related_order_no>
            <cfset attributes.order_id = attributes.related_order_id>
            <cfinclude template="../sales/query/get_order_detail.cfm">
        </cfif>
    </cfif>
<cfelseif (isdefined("attributes.event") and attributes.event is 'upd')>  
        <cf_xml_page_edit fuseact="objects.popup_add_spect_list"><!--- Bu spec'in ayarlarını çekmek için! --->
        <cf_xml_page_edit fuseact="sales.form_add_order">
        <cfif isnumeric(attributes.order_id)>
            <cfinclude template="../sales/query/get_order_detail.cfm">
        <cfelse>
            <cfset get_order_detail.recordcount = 0>
        </cfif>
        <cfif xml_country eq 1>
            <cfset cmp = createObject("component","settings.cfc.setupCountry") />
            <cfset GET_COUNTRY_1 = cmp.getCountry()>
            <cfquery name="GET_SALE_ZONES" datasource="#DSN#">
                SELECT SZ_ID,SZ_NAME FROM SALES_ZONES WHERE IS_ACTIVE=1 ORDER BY SZ_NAME
            </cfquery>
        </cfif>
    <cfif not (get_order_detail.recordcount) or (isdefined("attributes.active_company") and attributes.active_company neq session.ep.company_id)>
        <br />
        <cfset hata  = 11>
        <cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'> <cf_get_lang_main no='588.Sirketinizde Böyle Bir Sipariş Bulunamadı'> !</cfsavecontent>
        <cfset hata_mesaj  = message>
        <cfinclude template="../dsp_hata.cfm">
    <cfelse>
        <cfscript>session_basket_kur_ekle(process_type:1,table_type_id:3,action_id:attributes.order_id);</cfscript> 
        <cfif fuseaction contains 'store.'>
            <cfset modul_ = 'store'>
       <cfelse>
            <cfset modul_ = 'sales'>
        </cfif>
        <cfset xfa.upd = "#modul_#.emptypopup_upd_order">
        <cfset xfa.del = "#modul_#.emptypopup_del_order">
        <cfinclude template="../sales/query/get_priorities.cfm">
        <cfinclude template="../sales/query/get_moneys.cfm">
        <cfinclude template="../sales/query/get_commethod_cats.cfm">
        <cfif len(get_order_detail.partner_id)>
            <cfset contact_id = get_order_detail.partner_id>
            <cfset contact_type = "p">
        <cfelseif len(get_order_detail.company_id)>
            <cfset contact_id = get_order_detail.company_id>
            <cfset contact_type = "comp">
        <cfelseif len(get_order_detail.consumer_id)>
            <cfset contact_id = get_order_detail.consumer_id>
            <cfset contact_type = "c">
        <cfelse>
            <script type="text/javascript">
                alert("<cf_get_lang no='325.Şirket Seçilmemiş'> !");
                history.back();
            </script>
            <cfabort>
        </cfif>
        <!--- <cfquery name="Get_Invoice_Control" datasource="#dsn3#">
            SELECT TOP 1 ODR.ORDER_ID FROM ORDER_ROW ODR, STOCKS S WHERE ODR.ORDER_ID = #get_order_detail.order_id# AND ODR.STOCK_ID = S.STOCK_ID AND ODR.ORDER_ROW_CURRENCY IN (-6,-7)
        </cfquery> --->
    	<cfif listgetat(attributes.fuseaction,1,'.') is 'store'>
            <cfset attributes.basket_id = 38>
        <cfelse>	
            <cfset attributes.basket_id = 4>
        </cfif>
        <cfif session.ep.isBranchAuthorization >
            <cfinclude template="../sales/query/get_find_order_js.cfm">
        </cfif>
        <cfif x_mng_entegrasyon eq 1><!--- Dore MNG entegrasyonu --->
								<cfinclude template="../display/list_mng_entegrasyon.cfm">
							</cfif>                        
		<cfquery name="GET_SHIP_RESULT" datasource="#DSN2#">
								SELECT
									SHIP_ID,
									SHIP_FIS_NO,
									SHIP_RESULT_ID,
									OZEL_KOD_2,	
									MAIN_SHIP_FIS_NO
								FROM
									GET_SHIP_RESULT
								WHERE
									IS_TYPE = 'ORDER' AND
									SHIP_ID = #get_order_detail.order_id#
								UNION
								SELECT
									SHIP_ID,
									SHIP_FIS_NO,
									SHIP_RESULT_ID,
									OZEL_KOD_2,		
									MAIN_SHIP_FIS_NO							
								FROM
									GET_SHIP_RESULT
								WHERE
									IS_TYPE = 'SHIP' AND
									SHIP_ID IN(SELECT SHIP_ID FROM #dsn3_alias#.ORDERS_SHIP WHERE ORDER_ID = #get_order_detail.order_id# AND PERIOD_ID = #session.ep.period_id#)								
							</cfquery>
        </cfif> 
        <cfif session.ep.our_company_info.workcube_sector is 'it' and get_order_detail.is_processed eq 1>
			<cfif get_ship_result.ozel_kod_2 eq 'UPS'>
            <!--- BK 20070521 UPS Kargo linki icin duzenlendi Sirket akis parametrelerindeki Kargo Musteri Kodu --->
            <cfquery name="GET_OUR_COMPANY_INFO" datasource="#DSN#">
                SELECT CARGO_CUSTOMER_CODE FROM OUR_COMPANY_INFO WHERE COMP_ID = #session.ep.company_id#
            </cfquery>
            <cfset date1 = get_order_detail.order_date>
            <cfset date2 = date_add('d',15,get_order_detail.order_date)>
            <cfset g1 = dateformat(date1,"dd")>
            <cfset a1 = dateformat(date1,"mm")>
            <cfset y1 = dateformat(date1,"yyyy")>
            <cfset g2 = dateformat(date2,"dd")>
            <cfset a2 = dateformat(date2,"mm")>
            <cfset y2 = dateformat(date2,"yyyy")>
        	</cfif>
        </cfif>
</cfif>

<script type="text/javascript">
//Event : list
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	$( document ).ready(function() {
		document.getElementById('keyword').focus();
	});
	<cfif x_select_row_print eq 1 and attributes.listing_type eq 1>
		function send_print_()
		{
			<cfif not get_order_list.recordcount>
				alert("<cf_get_lang no='83.Yazdirilacak Belge Bulunamadi! Toplu Print Yapamazsiniz'>!");
				return false;
			<cfelseif get_order_list.recordcount eq 1>
				if(document.send_print_page.print_islem_id.checked == false)
				{
					alert("<cf_get_lang no='83.Yazdirilacak Belge Bulunamadi! Toplu Print Yapamazsiniz'>!");
					return false;
				}
				else
				{
					ship_list_ = document.send_print_page.print_islem_id.value;
				}
			<cfelseif get_order_list.recordcount gt 1>
				ship_list_ = "";
				for (i=0; i < document.send_print_page.print_islem_id.length; i++)
				{
					if(document.send_print_page.print_islem_id[i].checked == true)
						{
						ship_list_ = ship_list_ + document.send_print_page.print_islem_id[i].value + ',';
						}	
				}
				if(ship_list_.length == 0)
					{
					alert("<cf_get_lang no='83.Yazdirilacak Belge Bulunamadi! Toplu Print Yapamazsiniz'>!");
					return false;
					}																							
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_print_files&print_type=73&iid='+ship_list_,'page');
			<cfelse>
					alert("<cf_get_lang no='83.Yazdirilacak Belge Bulunamadi! Toplu Print Yapamazsiniz'>!");
					return false;
				</cfif>
		}
	</cfif>
	function input_control()
	{
		if( !date_check(document.getElementById('start_date'), document.getElementById('finish_date'), "<cf_get_lang_main no='1450.Baslangi Tarihi Bitis Tarihinden Byk Olamaz'>!") )
			return false;

		<cfif not session.ep.our_company_info.unconditional_list>
			if(document.getElementById('keyword').value.length == 0 && document.getElementById('keyword_orderno').value.length == 0 && (document.getElementById('employee_id').value.length == 0 || document.getElementById('employee').value.length == 0) &&
				(document.getElementById('member_name').value.length == 0 || (document.getElementById('company_id').value.length == 0 && document.getElementById('consumer_id').value.length == 0)) && 
				(document.getElementById('sales_member_id').value.length == 0 || document.getElementById('sales_member_name').value.length == 0)&&
				(document.getElementById('order_employee_id').value.length == 0 || document.getElementById('order_employee').value.length == 0) && (document.getElementById('start_date').value.length ==0) && (document.getElementById('finish_date').value.length ==0) )
				{
					alert("<cf_get_lang_main no='1538.En az bir alanda filtre etmelisiniz'>!");
					return false;
				}
			else return true;
		<cfelse>
			return true;
		</cfif>
	}
	
	function connectAjax(crtrow,prod_id,stock_id,unit_,order_amount)
	{
		var bb = '<cfoutput>#request.self#?fuseaction=objects.emptypopup_ajax_product_stock_info&sales=1</cfoutput>&pid='+prod_id+'&sid='+ stock_id+'&amount='+ order_amount;
		AjaxPageLoad(bb,'DISPLAY_ORDER_STOCK_INFO'+crtrow,1);
	}
<cfelseif (isdefined("attributes.event") and attributes.event is 'upd')>
		function goto_page(main_ship_fis_no)
		{
			document.getElementById('main_ship_fis_no').value = main_ship_fis_no;
			document.submit_multi_packetship.submit();
		}
		function upd_kontrol()
		{
			if(form_basket.company_id.value.length == 0 && form_basket.consumer_id.value.length == 0)
			{
				alert("<cf_get_lang no='254.Cari Hesap Secmelisiniz'>");
				return false;
			}
			if((form_basket.order_employee_id.value.length == 0) || (form_basket.order_employee.value.length == 0))
			{
				alert("<cf_get_lang no='101.satış çalışan'> !");
				return false;
			}
			if (form_basket.deliverdate.value.length == 0)
			{
				alert("<cf_get_lang no='185.Teslim Tarihi Girmelisiniz'> !");
				return false;
			}	
			x = (500 - document.form_basket.ship_address.value.length);
			if ( x < 0 )
			{ 
				alert ("<cf_get_lang no='2.Sevk Adresi'><cf_get_lang_main no='798.Alanindaki fazla karakter sayısı'>"+ ((-1) * x));
				return false;
			}
			<cfif xml_camp_id eq 2>
				if( document.form_basket.camp_id.value == '' || document.form_basket.camp_name.value == '')
				{
					alert("<cf_get_lang no ='642.Lütfen Kampanya Seçiniz'>!");
					return false;
				}
			</cfif>
			if (!date_check(document.form_basket.order_date,document.form_basket.deliverdate,"Sipariş Teslim Tarihi, Sipariş Tarihinden Önce Olamaz !"))
				return false;
			if(document.form_basket.ship_date.value)
				if (!date_check(document.form_basket.order_date,document.form_basket.ship_date,"Sipariş Sevk Tarihi, Sipariş Tarihinden Önce Olamaz !"))
					return false;
			
			if(document.form_basket.order_status.checked==true)
			{
				<cfif xml_reserved_stock_control eq 1>
					if (form_basket.reserved.checked == true)
					{
						//sıfır stok
						var basket_zero_stock_status = wrk_safe_query('sls_bsk_z_stk_stt','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
						if(basket_zero_stock_status.IS_SELECTED != 1)//<!--- basket sablonlarında sıfır stok ile calıs secilmemisse zero_stock kontrolu yapılıyor --->
						{
							if(!zero_stock_control('','',form_basket.order_id.value,'',1)) return false;
						}
					}
				<cfelse>
					//sıfır stok
					var basket_zero_stock_status = wrk_safe_query('sls_bsk_z_stk_stt','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
					if(basket_zero_stock_status.IS_SELECTED != 1)//<!--- basket sablonlarında sıfır stok ile calıs secilmemisse zero_stock kontrolu yapılıyor --->
					{
						if(!zero_stock_control('','',form_basket.order_id.value,'',1)) return false;
					}
				</cfif>
			}
			
			//Odeme Plani Guncelleme Kontrolleri
			var control_payment_plan= wrk_safe_query('sls_control_payment_plan','dsn3',0,<cfoutput>#attributes.ORDER_ID#</cfoutput>);
			if(control_payment_plan.recordcount)
			{
				if("<cfoutput>#get_order_detail.paymethod#</cfoutput>" != document.form_basket.paymethod_id.value)
				{
					if(confirm("Belgedeki Ödeme Yöntemi Değiştirilmiştir.\nÖdeme Planının Silinmesini Onaylıyor Musunuz?"))
						document.getElementById("orders_payment_plan").value = 1;
					else
						return false;
				}		
				else if("<cfoutput>#wrk_round(get_order_detail.other_money_value,2)#</cfoutput>" != parseFloat(wrk_round((document.all.basket_net_total.value/(document.all.basket_rate1.value*document.all.basket_rate2.value)),2)))
				//else if(parseFloat(wrk_round(control_payment_plan.OTHER_MONEY_TOTAL,2)) != parseFloat(wrk_round((document.all.basket_net_total.value/(document.all.basket_rate1.value*document.all.basket_rate2.value)),2)))
				{
					alert("Belgedeki Tutar Değiştirilmiştir.\nLütfen Oluşturulmuş Ödeme Planını Güncelleyiniz!");
					return false;
				}
			}
			else
				document.getElementById("orders_payment_plan").value = 0;
		
			<cfif isdefined("xml_sales_delivery_date_calculated") and xml_sales_delivery_date_calculated eq 1>
				change_paper_duedate('deliverdate');
			<cfelse>
				change_paper_duedate('order_date');
			</cfif>
			<cfif isdefined("xml_upd_row_project") and xml_upd_row_project eq 1>
				project_field_name = 'project_head';
			<cfelse>
				project_field_name = '';
			</cfif>
			<cfif isdefined('x_apply_deliverdate_to_rows') and x_apply_deliverdate_to_rows eq 1>
				date_field_name = 'deliverdate';
			<cfelse>
				date_field_name = '';
			</cfif>
			apply_deliver_date(date_field_name,project_field_name);
			return (process_cat_control() && saveForm());
			<cfif isdefined("xml_sales_delivery_date_calculated") and xml_sales_delivery_date_calculated eq 1>
				change_paper_duedate('deliverdate');
			<cfelse>
				change_paper_duedate('order_date');
			</cfif>
		} 
			
		function add_adress()
		{
			if(!(form_basket.company_id.value=='') || !(form_basket.consumer_id.value==''))
			{
				if(form_basket.company_id.value!='')
				{
					str_adrlink = '&field_long_adres=form_basket.ship_address&field_adress_id=form_basket.ship_address_id';
					str_adrlink = str_adrlink+'&company_id='+form_basket.company_id.value+'&member_type='+form_basket.member_type.value+'&member_name='+encodeURIComponent(form_basket.company.value)+'';
					if(form_basket.ship_address_city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.ship_address_city_id';
					if(form_basket.ship_address_county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.ship_address_county_id&field_id=form_basket.deliver_comp_id'<cfif fusebox.circuit eq "store">+'&is_store_module='+1</cfif>;
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&select_list=1'+ str_adrlink , 'list');
					document.getElementById('deliver_cons_id').value = '';
					return true;
				}
				else
				{
					str_adrlink = '&field_long_adres=form_basket.ship_address&field_adress_id=form_basket.ship_address_id';
					str_adrlink = str_adrlink+'&consumer_id='+form_basket.consumer_id.value+'&member_type='+form_basket.member_type.value+'&member_name='+encodeURIComponent(form_basket.partner_name.value)+'';
					if(form_basket.ship_address_city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.ship_address_city_id';
					if(form_basket.ship_address_county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.ship_address_county_id&field_id=form_basket.deliver_cons_id'<cfif fusebox.circuit eq "store">+'&is_store_module='+1</cfif>;
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&select_list=2'+ str_adrlink , 'list');
					document.getElementById('deliver_comp_id').value = '';
					return true;
				}
			}
			else
			{
				alert("<cf_get_lang no='254.Cari Hesap Secmelisiniz'>");
				return false;
			}
		}
<cfelseif (isdefined("attributes.event") and attributes.event is 'add')>
	$(document).ready(function(){
		show_member_button();
	})
	function open_member_page()
	{
		<cfoutput>
			if(document.form_basket.company_id.value != '')
				windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id='+document.form_basket.company_id.value,'medium');
			else if(document.form_basket.consumer_id.value != '')
				windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id='+document.form_basket.consumer_id.value,'medium');
		</cfoutput>
	}
	function open_contract_page()
	{
		<cfoutput>
			if(document.form_basket.company_id.value != '')
				windowopen('#request.self#?fuseaction=objects.popup_list_basket_contract&company_id='+document.form_basket.company_id.value,'wwide1');
			else if(document.form_basket.consumer_id.value != '')
				windowopen('#request.self#?fuseaction=objects.popup_list_basket_contract&consumer_id='+document.form_basket.consumer_id.value,'wwide1');
		</cfoutput>
	}
	function show_member_button()
	{
		if(document.form_basket.company_id.value != '' || document.form_basket.consumer_id.value != '')
		{
			member_page.style.display = '';
			member_page_1.style.display = '';
		}
		else
		{
			member_page.style.display = 'none';
			member_page_1.style.display = 'none';
		}
	}
	
	function add_kontrol()
	{
		if(form_basket.order_head.value == "")
		{
			alert("<cf_get_lang_main no='647.Başlık Girmelisiniz'> !");	
			return false;
		}
		if(form_basket.company_id.value == "" && form_basket.consumer_id.value == "")
		{
			alert("<cf_get_lang no='254.Cari Hesap Seçmelisiniz'> !");	
			return false;
		}
		if ((form_basket.order_employee_id.value.length == 0) || (form_basket.order_employee.value.length == 0))
		{
			alert("<cf_get_lang no='101.satış çalışan'> !");
			return false;
		}
		if (form_basket.deliverdate.value.length == 0)
		{
			alert("<cf_get_lang no='185.Teslim Tarihi Girmelisiniz'> !");
			return false;
		}
		<cfif xml_camp_id eq 2>
			if( document.form_basket.camp_id.value == '' || document.form_basket.camp_name.value == '')
			{
				alert("<cf_get_lang no ='642.Lütfen Kampanya Seçiniz'>!");
				return false;
			}
		</cfif>
		if (!date_check(form_basket.order_date,form_basket.deliverdate,"Sipariş Teslim Tarihi, Sipariş Tarihinden Önce Olamaz !"))
			return false;
		if(document.form_basket.ship_date.value != '')
			if (!date_check(document.form_basket.order_date,document.form_basket.ship_date,"Sipariş Sevk Tarihi, Sipariş Tarihinden Önce Olamaz !"))
				return false;
		<!---<cfif xml_reserved_stock_control eq 1>
			if (form_basket.reserved.checked == true)
			{
				//sıfır stok
				var basket_zero_stock_status = wrk_safe_query('sls_bsk_z_stk_stt','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
				if(basket_zero_stock_status.IS_SELECTED != 1)//<!--- basket sablonlarında sıfır stok ile calıs secilmemisse zero_stock kontrolu yapılıyor --->
				{
					if(!zero_stock_control('','',0,'',1)) return false;
				}
			}
		<cfelse>
			//sıfır stok
			var basket_zero_stock_status = wrk_safe_query('sls_bsk_z_stk_stt','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
			if(basket_zero_stock_status.IS_SELECTED != 1)//<!--- basket sablonlarında sıfır stok ile calıs secilmemisse zero_stock kontrolu yapılıyor --->
			{
				if(!zero_stock_control('','',0,'',1)) return false;
			}
		</cfif>--->
		<cfif isdefined("xml_sales_delivery_date_calculated") and xml_sales_delivery_date_calculated eq 1>
				change_paper_duedate('deliverdate');
			<cfelse>
				change_paper_duedate('order_date');
			</cfif>
		<cfif isdefined("xml_upd_row_project") and xml_upd_row_project eq 1>
			project_field_name = 'project_head';
		<cfelse>
			project_field_name = '';
		</cfif>
		<cfif isdefined('x_apply_deliverdate_to_rows') and x_apply_deliverdate_to_rows eq 1>
			date_field_name = 'deliverdate';
		<cfelse>
			date_field_name = '';
		</cfif>
		apply_deliver_date(date_field_name,project_field_name);
		return (process_cat_control() && saveForm());
		return true;
	}
	
	function add_adress()
	{
		if(!(form_basket.company_id.value=="") || !(form_basket.consumer_id.value==""))
		{
			if(form_basket.company_id.value!="")
				{
					str_adrlink = '&field_long_adres=form_basket.ship_address&field_adress_id=form_basket.ship_address_id';
					str_adrlink = str_adrlink+'&company_id='+form_basket.company_id.value+'&member_type=partner&member_name='+encodeURIComponent(form_basket.company.value)+'';
	//				str_adrlink = str_adrlink+'&company_id='+form_basket.company_id.value+'&member_type='+form_basket.member_type.value+'&member_name='+encodeURIComponent(form_basket.company.value)+'';
					if(form_basket.ship_address_city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.ship_address_city_id';
					if(form_basket.ship_address_county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.ship_address_county_id&field_id=form_basket.deliver_comp_id'<cfif fusebox.circuit eq "store">+'&is_store_module='+1</cfif>;
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&select_list=1'+ str_adrlink , 'list');
					document.getElementById('deliver_cons_id').value = '';
					return true;
				}
			else
				{
					str_adrlink = '&field_long_adres=form_basket.ship_address&field_adress_id=form_basket.ship_address_id'; 
					str_adrlink = str_adrlink+'&consumer_id='+form_basket.consumer_id.value+'&member_type=consumer&member_name='+encodeURIComponent(form_basket.member_name.value)+'';
					//str_adrlink = str_adrlink+'&consumer_id='+form_basket.consumer_id.value+'&member_type='+form_basket.member_type.value+'&member_name='+encodeURIComponent(form_basket.member_name.value)+'';
					if(form_basket.ship_address_city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.ship_address_city_id';
					if(form_basket.ship_address_county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.ship_address_county_id&field_id=form_basket.deliver_cons_id'<cfif fusebox.circuit eq "store">+'&is_store_module='+1</cfif>;
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&select_list=2'+ str_adrlink , 'list');
					document.getElementById('deliver_comp_id').value = '';
					return true;
				}
		}
		else
		{
			alert("<cf_get_lang no='254.Cari Hesap Secmelisiniz'>");
			return false;
		}
	}
</cfif>
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['systemObject'] = structNew();
	WOStruct['#attributes.fuseaction#']['systemObject']['processStage'] = true;

	if(isdefined("attributes.event") and attributes.event is 'upd')
		WOStruct['#attributes.fuseaction#']['systemObject']['processStageSelected'] = '#get_order_detail.order_stage#';
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'sales.list_order';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'sales/display/list_order.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'sales.list_order';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'sales/form/add_order.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'sales/query/add_order.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'sales.list_order&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_basket(detail_inv_menu);";

	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'sales.list_order';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'sales/form/detail_order.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'sales/query/upd_order.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'sales.list_order&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'order_id=##attributes.order_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.order_id##';
	WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_basket(detail_order);";

	if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
	{
		//WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#xfa.del#&order_id=#order_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'sales/query/del_order.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'sales/query/del_order.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'sales.list_order';
	}
	
	//Add//
	if(isdefined("attributes.event") and attributes.event is 'add')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'] = structNew();
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['text'] = 'PHL';//PHL
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['href'] = "#request.self#?fuseaction=objects.add_order_from_file&from_where=4";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][1]['text'] = '#lang_array.item[256]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][1]['onClick'] = "open_member_page();";

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][2]['text'] = '#lang_array.item[607]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][2]['onClick'] = "open_contract_page();";

		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	// Upd //	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		if(get_ship_result.recordcount and  session.ep.isBranchAuthorization neq 1)
		{
			if(not len(get_ship_result.main_ship_fis_no))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array.item[364]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['href'] = "#request.self#?fuseaction=stock.form_upd_packetship&ship_result_id=#get_ship_result.ship_result_id#";
			}
			else
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array.item[596]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "goto_page('#get_ship_result.main_ship_fis_no#')";
			}
		 }
		 else if(session.ep.isBranchAuthorization neq 1)
		 {
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array.item[365]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=stock.popup_add_packetship&order_id=#attributes.order_id#&is_type=2','list');";
		 }
		 
		if(len(get_order_detail.offer_id) and session.ep.isBranchAuthorization neq 1)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[133]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['href'] = "#request.self#?fuseaction=sales.detail_offer_tv&offer_id=#get_order_detail.offer_id#";
		}	
		else
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['href'] = "";	
		}
		if(session.ep.isBranchAuthorization neq 1)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '#lang_array.item[366]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['href'] = "#request.self#?fuseaction=credit.add_credit_contract&order_no=#get_order_detail.order_number#";
		}	
		else
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['href'] = "";	
		}
//		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '#lang_array_main.item[398]#';
//		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#get_order_detail.order_id#&type_id=-7','list');";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['text'] = '#lang_array.item[47]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_history&order_id=#url.ORDER_ID#&portal_type=employee','project')";

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['text'] = '#lang_array_main.item[345]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=#listgetat(attributes.fuseaction,1,'.')#.detail_order&action_name=order_id&action_id=#get_order_detail.order_id#&relation_papers_type=ORDER_ID','list');";

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['text'] = '#lang_array.item[65]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_receive_rate&order_id=#attributes.order_id#&is_sale=1','wide');";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][6]['text'] = '#lang_array.item[607]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][6]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_basket_contract&order_id=#attributes.order_id#&company_id=#get_order_detail.company_id#&consumer_id=#get_order_detail.consumer_id#','page');";

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][7]['text'] = '#lang_array.item[145]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][7]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_stock&order_id=#attributes.order_id#','wide');";

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][8]['text'] = '#lang_array.item[368]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][8]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_cost&id=#url.order_id#&page_type=2&basket_id=#attributes.basket_id#','page_horizantal');";
		i = 9;
		if(len(get_order_detail.paymethod) and not listfindnocase(denied_pages,'objects.popup_payment_with_voucher'))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[306]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_payment_with_voucher&is_purchase_=0&payment_process_id=#attributes.order_id#&str_table=ORDERS&rate_round_num='+document.form_basket.basket_rate_round_number_.value+'&round_number='+document.form_basket.basket_total_round_number_.value+'&branch_id='+document.form_basket.branch_id.value,'page','detail_order');";
			i = i + 1;
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_pursuits_documents_plus&action_id=#attributes.order_id#&pursuit_type=is_sale_order','medium');";
		i = i + 1;
		if(IsDefined("get_order_detail.company_id") and len(get_order_detail.company_id))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array_main.item[45]# Ek Bilgi';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_order_detail.company_id#','medium');";
			i = i + 1;
		}
		else if(IsDefined("get_order_detail.consumer_id") and len(get_order_detail.consumer_id))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array_main.item[45]# Müşteri Ek Bilgi';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_order_detail.consumer_id#','medium');";
			i = i + 1;
		}
		if(fuseaction contains 'store.')
		{
			fuse_ = "store";
		}
		else
		{
			fuse_ = "invoice";
		}	
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[373]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=#fuse_#.add_sale_invoice_from_order&order_id=#attributes.order_id#";
		i = i + 1;
		
		if(session.ep.our_company_info.workcube_sector is 'it' and get_order_detail.is_processed eq 1)
		{
			if(get_ship_result.ozel_kod_2 eq 'YURTICI KARGO')
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[369]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_cargo_information&cargo_type=1&order_number=#get_order_detail.order_number#','horizantal','popup_cargo_information');";
				i = i + 1;
			}
			else if( get_ship_result.ozel_kod_2 eq 'UPS')
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[370]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('http://www.ups.com.tr/PMusteriRefSorguSonuc.asp?musterikodu=#get_our_company_info.cargo_customer_code#&referansNo=#get_ship_result.ship_fis_no#&g1=#g1#&a1=#a1#&y1=#y1#&g2=#g2#&a2=#a2#&y2=#y2#','horizantal','popup_cargo_information');";
				i = i + 1;
			}
		}

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[371]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_order&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[1578]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = '#request.self#?fuseaction=sales.list_order&event=add&order_id=#url.order_id#&active_company_id=#session.ep.company_id#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] =  '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] ="windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#url.order_id#&print_type=73','page');";


		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'listOrder';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'ORDERS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-order_head','item-company_id','item-order_date']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
	
	WOStruct['#attributes.fuseaction#']['print'] = structNew();
	WOStruct['#attributes.fuseaction#']['print']['cfcName'] = 'listOrderPrint';
	WOStruct['#attributes.fuseaction#']['print']['identity'] = 'order_id';
</cfscript>
