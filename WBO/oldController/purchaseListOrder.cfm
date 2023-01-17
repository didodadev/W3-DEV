<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cf_get_lang_set module_name="purchase"><!--- sayfanin en altinda kapanisi var --->
    <cf_xml_page_edit fuseact ="purchase.list_order">
    <cfif session.ep.isBranchAuthorization>
        <cfset my_url_action = 'store.detail_order_purchase'>
    <cfelse>
        <cfset my_url_action = 'purchase.detail_order'>
    </cfif>
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.order_no" default="">
    <cfparam name="attributes.referance_no" default="">
    <cfparam name="attributes.order_status" default="">
    <cfparam name="attributes.currency_id" default="">
    <cfparam name="attributes.department_id" default="">
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
    <cfinclude template="../purchase/query/get_stores2.cfm">
    <cfif isdefined("attributes.form_varmi")>
        <cfset arama_yapilmali = 0>
        <cfscript>
        get_order_list_action = createObject("component", "purchase.cfc.get_order_list");
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
                module_name : '#IIf(IsDefined("fusebox.circuit"),"fusebox.circuit",DE(""))#'
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
    <cfif session.ep.isBranchAuthorization>
        <cfset url_action = 'store.list_purchase_order'>
    <cfelse>
        <cfset url_action = 'purchase.list_order'>
    </cfif>
    <cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
<cfelseif (isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'multi'))>
    <cf_xml_page_edit fuseact="purchase.detail_order">
    <cf_get_lang_set module_name="purchase"><!--- sayfanin en altinda kapanisi var --->
    <cfif isdefined("attributes.active_company_id") and attributes.active_company_id neq session.ep.company_id>
        <script type="text/javascript">
            alert("<cf_get_lang no='405.İşlemin Şirketi İle Aktif Şirketiniz Farklı Çalıştığınız Şirketi Kontrol Ediniz'>!");
            window.location.href='<cfoutput>#request.self#?fuseaction=purchase.list_order</cfoutput>';
        </script>
        <cfabort>
    </cfif>
    <cfscript>
        if(isdefined("attributes.offer_id") and len(attributes.offer_id))
            session_basket_kur_ekle(process_type:1,table_type_id:4,to_table_type_id:3,action_id:attributes.offer_id);
        else if(isdefined("attributes.order_id") and len(attributes.order_id))
            session_basket_kur_ekle(process_type:1,table_type_id:3,action_id:attributes.order_id);
        else
            session_basket_kur_ekle(process_type:0);
    </cfscript>
    <!--- Toplu siparis ekranından gelen degerlerin siparise akrarilmasi icin eklendi. --->
    <cfparam name="attributes.publishdate" default="">
    <cfparam name="attributes.deliverdate" default="">
    <cfparam name="attributes.deliver_dept_name" default="">
    <cfparam name="attributes.deliver_dept_id" default="">
    <cfparam name="attributes.deliver_loc_id" default="">
    <cfparam name="attributes.branch_id" default="">
    <cfparam name="attributes.brand_id" default="">
    <cfparam name="attributes.cat_id" default="">
    <cfsavecontent variable="order"><cf_get_lang no='34.Siparişimiz'></cfsavecontent>
    <cfset attributes.subject = '#order#'>
    <cfset attributes.due_date = dateformat(now(),'dd/mm/yyyy')>
    <cfif isdefined('attributes.from_project_material')>
        <cfinclude template="../../sales/query/get_project_metarial.cfm"><!--- Proje Malzeme İhtiyaç Planından ekleme yapmak için. --->
        <cfif not isdefined('attributes.from_project_material_id')>
            <cfquery name="GET_PRO_MATERIAL_IDS" datasource="#DSN#"><!--- Eğer proje id'si geliyorsa bu projeye ait metarial id'lerini buluyoruz--->
                SELECT PRO_MATERIAL_ID FROM PRO_MATERIAL WHERE PROJECT_ID = #attributes.from_project_material#
            </cfquery>
            <cfif GET_PRO_MATERIAL_IDS.recordcount>
                <cfset attributes.from_project_material_id = ValueList(GET_PRO_MATERIAL_IDS.PRO_MATERIAL_ID,',')>
            </cfif>
        <cfelseif isdefined('attributes.from_project_material_id')>
            <cfquery name="GET_PRO_MATERIAL_IDS" datasource="#DSN#">
                SELECT WORK_ID FROM PRO_MATERIAL WHERE PRO_MATERIAL_ID = #attributes.from_project_material_id#
            </cfquery>
            <cfset attributes.work_id =GET_PRO_MATERIAL_IDS.WORK_ID>
        </cfif>
    <cfelseif isdefined("attributes.order_id") and len(attributes.order_id)><!--- Siparis Kopyalama --->
        <cfinclude template="../purchase/query/get_order_detail.cfm">
        <cfset attributes.subject=get_order_detail.order_head>
        <cfset attributes.order_detail=get_order_detail.order_detail>
        <cfset attributes.project_id =get_order_detail.project_id>
         <cfset attributes.work_id =get_order_detail.work_id> 
        <cfset ship_method = get_order_detail.ship_method>
        <cfif len(get_order_detail.paymethod)>
            <cfset attributes.paymethod_id = get_order_detail.paymethod>
        <cfelseif len(get_order_detail.card_paymethod_id)>
            <cfset attributes.card_paymethod_id = get_order_detail.card_paymethod_id>
        </cfif>
        <cfset attributes.order_date = DateFormat(get_order_detail.order_date,'dd/mm/yyyy')>
        <cfset attributes.deliverdate = DateFormat(get_order_detail.deliverdate,'dd/mm/yyyy')>
        <cfset attributes.publishdate = DateFormat(get_order_detail.publishdate,'dd/mm/yyyy')>
        <cfset attributes.due_date = DateFormat(get_order_detail.due_date,'dd/mm/yyyy')>
        <cfif len(get_order_detail.partner_id)>
            <cfset attributes.partner_id = get_order_detail.partner_id>
        <cfelse>
            <cfset attributes.partner_id = "">
        </cfif>
        <cfif len(get_order_detail.company_id)>
            <cfset attributes.company_id = get_order_detail.company_id>
        <cfelse>
            <cfset attributes.company_id = "">
        </cfif>
        <cfset attributes.priority_id = get_order_detail.priority_id>
        <cfset attributes.ship_method = get_order_detail.ship_method>
        <cfset attributes.ref_no = get_order_detail.ref_no>
        <cfset attributes.catalog_id = get_order_detail.catalog_id>
        <cfset attributes.reserved = get_order_detail.reserved>
        <cfset attributes.invisible = get_order_detail.invisible>
        <cfif len(get_order_detail.deliver_dept_id) and len(get_order_detail.location_id)>
            <cfset location_info_ = get_location_info(get_order_detail.deliver_dept_id,get_order_detail.location_id,1,1)>
            <cfset attributes.branch_id = listlast(location_info_,',')>
            <cfset attributes.deliver_loc_id = get_order_detail.location_id>
            <cfset attributes.deliver_dept_id = get_order_detail.deliver_dept_id>
            <cfset attributes.deliver_dept_name = listfirst(location_info_,',')>
        </cfif>
    <cfelseif (isdefined("attributes.offer_id") and len(attributes.offer_id)) or (isdefined("attributes.for_offer_id") and len(attributes.for_offer_id))><!--- Tekliften Sipearise Donusturme --->
        <cfif isdefined("attributes.for_offer_id")><cfset attributes.offer_id = attributes.for_offer_id></cfif>
        <cfinclude template="../query/get_offer_detail.cfm">
        <cfset attributes.subject=get_offer_detail.offer_head>
        <cfset attributes.order_detail=ReReplaceNoCase(get_offer_detail.offer_detail,"<[^>]*>","","ALL")>
        <cfset attributes.project_id =get_offer_detail.project_id>
        <cfset attributes.deliverdate = DateFormat(get_offer_detail.deliverdate,'dd/mm/yyyy')>
        <cfset attributes.work_id =get_offer_detail.work_id> 
        <cfset attributes.paymethod_id =get_offer_detail.paymethod>
        <cfset attributes.ship_method = get_offer_detail.ship_method>
        <cfset attributes.ref_no = get_offer_detail.ref_no>
        <cfif len(get_offer_detail.deliver_place) and len(get_offer_detail.location_id)>
            <cfset location_info_ = get_location_info(get_offer_detail.deliver_place,get_offer_detail.location_id,1,1)>
            <cfset attributes.branch_id = listlast(location_info_,',')>
            <cfset attributes.deliver_loc_id = get_offer_detail.location_id>
            <cfset attributes.deliver_dept_id = get_offer_detail.deliver_place>
            <cfset attributes.deliver_dept_name = listfirst(location_info_,',')>
        </cfif>
        <cfif len(get_offer_detail.partner_id)>
            <cfset attributes.partner_id = get_offer_detail.partner_id>
            <cfset attributes.company_id = get_offer_detail.company_id>
        <cfelseif listlen(get_offer_detail.offer_to_partner)>
            <cfset attributes.partner_id = listfirst(listdeleteduplicates(get_offer_detail.offer_to_partner))>
            <cfquery name="get_company_id" datasource="#dsn#">
                SELECT COMPANY_ID FROM COMPANY_PARTNER WHERE PARTNER_ID = #attributes.partner_id#
            </cfquery>
            <cfset attributes.company_id = get_company_id.company_id>
            <cfquery name="get_company_paymethod" datasource="#dsn#">
                SELECT PAYMETHOD_ID FROM COMPANY_CREDIT WHERE COMPANY_ID = #attributes.company_id#
            </cfquery>
            <cfif Len(get_company_paymethod.paymethod_id)>
                <cfset attributes.paymethod_id = get_company_paymethod.paymethod_id>
            </cfif>
        <cfelse>
            <cfset attributes.partner_id = "">
            <cfset attributes.company_id = "">
        </cfif>
        <cfset attributes.invisible = get_offer_detail.is_partner_zone>
    <cfelseif (isdefined('attributes.internaldemand_id') and len(attributes.internaldemand_id) and not isdefined("attributes.internaldemand_row_id")) or
              (isdefined('attributes.internaldemand_id') and len(attributes.internaldemand_id) and isdefined("attributes.internaldemand_row_id") and Listlen(ListDeleteDuplicates(attributes.internaldemand_id)) eq 1)><!--- ic talepten siparis olusturma, satır bazlı degil veya satir bazli tek talep --->
        <cfquery name="get_internaldemand_info" datasource="#dsn3#">
            SELECT 
                I.SUBJECT, 
                I.PROJECT_ID, 
                I.NOTES,
                I.WORK_ID,
                IR.PRO_MATERIAL_ID,
                I.INTERNAL_NUMBER
            FROM 
                INTERNALDEMAND I,
                INTERNALDEMAND_ROW IR
            WHERE 
                I.INTERNAL_ID = IR.I_ID AND
                INTERNAL_ID = #ListDeleteDuplicates(attributes.internaldemand_id)#
        </cfquery>
        <cfset attributes.subject=get_internaldemand_info.subject>
        <cfset attributes.order_detail=get_internaldemand_info.notes>
        <cfset attributes.project_id =get_internaldemand_info.project_id>
        <cfset attributes.ref_no = get_internaldemand_info.internal_number>
        <cfset attributes.work_id =get_internaldemand_info.work_id>
        <cfif isdefined('attributes.company_id') and len(attributes.company_id)>
            <cfquery name="get_company_paymethod" datasource="#dsn#">
                SELECT PAYMETHOD_ID FROM COMPANY_CREDIT WHERE COMPANY_ID = #attributes.company_id#
            </cfquery>
            <cfif Len(get_company_paymethod.paymethod_id)>
                <cfset attributes.paymethod_id = get_company_paymethod.paymethod_id>
            </cfif>
        </cfif> 
    <cfelseif not isdefined("attributes.order_id") and not isdefined("attributes.type") and not isdefined("attributes.related_order_id") and isdefined("attributes.project_id") and len(attributes.project_id)>
        <cfquery name="get_project_info" datasource="#dsn#">
            SELECT COMPANY_ID,PARTNER_ID,CONSUMER_ID FROM PRO_PROJECTS WHERE PROJECT_ID =#attributes.project_id#
        </cfquery>
        <cfif len(get_project_info.company_id) and len(get_project_info.partner_id)>
            <cfset attributes.company_id = get_project_info.company_id>
            <cfset attributes.partner_id = get_project_info.partner_id>
        </cfif>
    </cfif>
    <cfinclude template="../purchase/query/get_setup_priority.cfm">
    <cfif session.ep.isBranchAuthorization neq 1>
                <td><table align="right"><tr><cfinclude template="../sales/query/get_find_order_js.cfm"></tr></table></td>
            </cfif>
    <cfif fusebox.circuit eq "store">
		<cfset fuseact = "popup_add_order">
	<cfelse>
		<cfset fuseact = "emptypopup_add_order">
	</cfif>
     <cfset attributes.basket_id = 6>
	<cfif (isdefined('attributes.internaldemand_id') and len(attributes.internaldemand_id)) or isdefined('attributes.internaldemand_row_id')> <!--- ic talepden siparis ekleniyorsa --->
        <cfset attributes.id = attributes.internaldemand_id>
        <cfset attributes.basket_sub_id = 6>
    <cfelseif isdefined("attributes.offer_id") and len(attributes.offer_id)>
        <cfset attributes.offer_id = attributes.offer_id>
        <cfset add_order_from_offer_=1>
        <cfset attributes.basket_id = 5>
    <cfelseif isdefined("attributes.order_id") and len(attributes.order_id)>
        <cfset attributes.order_id = attributes.order_id>
        <cfset attributes.basket_sub_id = 6>
    <cfelseif isDefined("attributes.from_project_material_id") and Len(attributes.from_project_material_id)>
        <cfset attributes.basket_id = 4>
    <cfelseif not isdefined("attributes.type") and not isdefined("attributes.update_order") and not isdefined("attributes.file_format") and not isdefined("offer_row_check_info")>
        <cfset attributes.form_add = 1>
    <cfelseif isdefined("attributes.file_format")>
        <cfset attributes.basket_sub_id = 4>
    <cfelseif isdefined("attributes.type") and attributes.type is 'convert'>
        <cfset attributes.basket_id = 6>
        <cfset attributes.is_from_report = 1>
    </cfif>
<cfelseif (isdefined("attributes.event") and attributes.event is 'upd')>  
    <cf_xml_page_edit fuseact="purchase.detail_order">
    <cf_get_lang_set module_name="purchase"><!--- sayfanin en altinda kapanisi var --->
    <cfif isnumeric(attributes.order_id)>
        <cfinclude template="../purchase/query/get_order_detail.cfm">
    <cfelse>
        <cfset get_order_detail.recordcount = 0>
    </cfif>
    <cfquery name="get_orders_ship" datasource="#dsn3#">
        SELECT * FROM ORDERS_SHIP WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_detail.order_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
    </cfquery>
    <cfquery name="GET_ORDERS_INVOICE" datasource="#dsn3#">
        SELECT ORDER_ID FROM ORDERS_INVOICE WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_detail.order_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
    </cfquery>
    <cfquery name="Get_Invoice_Control" datasource="#dsn3#">
        SELECT TOP 1 ODR.ORDER_ID FROM ORDER_ROW ODR, STOCKS S WHERE ODR.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_detail.order_id#"> AND ODR.STOCK_ID = S.STOCK_ID AND ODR.ORDER_ROW_CURRENCY IN (-6,-7)
    </cfquery>
    <cfquery name="get_ship_result" datasource="#dsn2#">
        SELECT SHIP_ID,SHIP_RESULT_ID FROM SHIP_RESULT_ROW WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_detail.order_id#">
    </cfquery>
	<cfif not get_order_detail.recordcount or (isdefined("attributes.active_company") and attributes.active_company neq session.ep.company_id)>
        <cfset hata  = 11>
        <cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'> <cf_get_lang_main no='588.Sirketinizde Böyle Bir Sipariş Bulunamadı'> !</cfsavecontent>
        <cfset hata_mesaj  = message>
        <cfinclude template="../../dsp_hata.cfm">
    <cfelse>
        <cfset attributes.basket_id = 6>
        <cfscript>session_basket_kur_ekle(process_type:1,table_type_id:3,action_id:attributes.order_id);</cfscript>
        <cfinclude template="../purchase/query/get_setup_priority.cfm">
    </cfif>
</cfif>
<script type="text/javascript">
//Event : list
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	$( document ).ready(function() {
		document.getElementById('keyword').focus();
	});
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
				(form.start_date.value.lenght == 0 || form.finish_date.value.lenght == 0)
			  )
			{
				alert("<cf_get_lang_main no='1538.En az bir alanda filtre etmelisiniz'> !");
				return false;
			}
			else return true;
		<cfelse>	
			return true;
		</cfif>
	}
<cfelseif (isdefined("attributes.event") and attributes.event is 'add')>
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
				windowopen('#request.self#?fuseaction=objects.popup_list_basket_contract&company_id='+document.form_basket.company_id.value,'page');
			else if(document.form_basket.consumer_id.value != '')
				windowopen('#request.self#?fuseaction=objects.popup_list_basket_contract&consumer_id='+document.form_basket.consumer_id.value,'page');
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
	$( document ).ready(function() {
		show_member_button();
	})
<cfelseif (isdefined("attributes.event") and attributes.event is 'upd')>
	function openVoucher()
		{
			windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_payment_with_voucher&is_purchase_=1&payment_process_id=#attributes.order_id#&str_table=ORDERS&rate_round_num='+window.basket.hidden_values.basket_rate_round_number_+'&round_number='+window.basket.hidden_values.basket_total_round_number_.value+'&branch_id='+document.form_basket.branch_id.value</cfoutput>,'page','detail_order');		
		}
	<cfif not get_order_detail.recordcount or (isdefined("attributes.active_company") and attributes.active_company neq session.ep.company_id)><cfelse>
		$( document ).ready(function() {
			<cfif isdefined("xml_delivery_date_calculated") and xml_delivery_date_calculated eq 1>
				change_paper_duedate('deliverdate');
			<cfelse>
				change_paper_duedate('order_date');
			</cfif>
		})
	</cfif>
</cfif>
<cfif isdefined("attributes.event") and listfindnocase('add,upd',attributes.event)>
	function add_adress()
	{
		if(!(form_basket.company_id.value=='') || !(form_basket.consumer_id.value==''))
		{
			if(form_basket.company_id.value!='')
			{
				str_adrlink = '&field_long_adres=form_basket.ship_address&field_adress_id=form_basket.ship_address_id';
				if(form_basket.ship_address_city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.ship_address_city_id';
				if(form_basket.ship_address_county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.ship_address_county_id&field_id=form_basket.deliver_comp_id'<cfif fusebox.circuit eq "store">+'&is_store_module='+1</cfif>;
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&select_list=1&keyword='+encodeURIComponent(form_basket.company.value)+''+ str_adrlink , 'list');
				document.getElementById('deliver_cons_id').value = '';
				return true;
			}
			else
			{
				str_adrlink = '&field_long_adres=form_basket.ship_address&field_adress_id=form_basket.ship_address_id';
				if(form_basket.ship_address_city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.ship_address_city_id';
				if(form_basket.ship_address_county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.ship_address_county_id&field_id=form_basket.deliver_cons_id'<cfif fusebox.circuit eq "store">+'&is_store_module='+1</cfif>;
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&select_list=2&keyword='+encodeURIComponent(form_basket.partner_name.value)+''+ str_adrlink , 'list');
				document.getElementById('deliver_comp_id').value = '';
				return true;
			}
		}
		else
		{
			alert("<cf_get_lang no='171.Şirket Seçmelisiniz'> !");
			return false;
		}
	}
		function kontrol()
	{
		<cfif attributes.event is 'add'>
		if(document.form_basket.partner_id.value == "" && document.form_basket.company_id.value == "" && document.form_basket.consumer_id.value == "")
		{
			alert("<cf_get_lang no='171.Şirket Seçmelisiniz'> !");
			return false;
		}
		<cfelseif attributes.event is 'upd'>
		//Odeme Plani Guncelleme Kontrolleri
		var control_payment_plan= wrk_safe_query('prch_ctrl_pym_plan','dsn3',0,<cfoutput>#attributes.ORDER_ID#</cfoutput>);
		if(control_payment_plan.recordcount)
		{
			if (!confirm("<cf_get_lang no='50.Güncellediğiniz Sipariş İçin Oluşturulmuş Ödeme Planı Silinecektir'>!")) return false;
		}
		</cfif>
		if (!date_check(form_basket.order_date,form_basket.deliverdate,"Sipariş Teslim Tarihi, Sipariş Tarihinden Önce Olamaz !"))
			return false;
		<cfif isdefined("xml_delivery_date_calculated") and xml_delivery_date_calculated eq 1>
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
	}
</cfif>
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'purchase.list_order';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'purchase/display/list_order.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'purchase.list_order';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'purchase/form/add_order.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'purchase/query/add_order.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'purchase.list_order&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_basket(add_order);";
	
	WOStruct['#attributes.fuseaction#']['multi'] = structNew();
	WOStruct['#attributes.fuseaction#']['multi']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['multi']['fuseaction'] = 'purchase.list_order';
	WOStruct['#attributes.fuseaction#']['multi']['filePath'] = 'purchase/form/add_order.cfm';
	WOStruct['#attributes.fuseaction#']['multi']['queryPath'] = 'purchase/query/add_order.cfm';
	WOStruct['#attributes.fuseaction#']['multi']['nextEvent'] = 'purchase.list_order&event=upd';
	WOStruct['#attributes.fuseaction#']['multi']['js'] = "javascript:gizle_goster_basket(add_order);";
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'purchase.list_order';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'purchase/form/detail_order.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'purchase/query/upd_order.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'purchase.list_order&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'camp_id=##attributes.order_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##get_order_detail.order_number##';
	WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_basket(detail_order);";
	
	
	if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=purchase.emptypopup_del_order&order_id=#order_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'purchase/query/del_order.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'purchase/query/del_order.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'purchase.list_order';
	}
		
		
	// Tab Menus //
	tabMenuStruct = StructNew();
	tabMenuStruct['#attributes.fuseaction#'] = structNew();
	tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
	//Add//
	if(isdefined("attributes.event") and attributes.event is 'add')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'] = structNew();
		
		 if (session.ep.isBranchAuthorization neq 1)
		 {
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['text'] = 'PHL';//PHL
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['href'] = "#request.self#?fuseaction=objects.add_order_from_file&from_where=1";
		 }
		 else
		 {
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['text'] = 'PHL';//PHL
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['href'] = "#request.self#?fuseaction=objects.add_order_from_file&from_where=2";
		 }
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	// Upd //	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		i = 0;
		if(session.ep.isBranchAuthorization neq 1)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[200]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=credit.add_credit_contract&order_no=#get_order_detail.order_number#";
			i = i + 1;
		}

		if(get_ship_result.recordcount and fusebox.circuit is not 'store')
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[201]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=stock.form_upd_packetship&ship_result_id=#get_ship_result.ship_result_id#";
			i = i + 1;
		}
		else if (session.ep.isBranchAuthorization neq 1)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[201]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=stock.popup_add_packetship&order_id=#attributes.order_id#&is_type=2','list');";
			i = i + 1;
		}
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array_main.item[398]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#attributes.order_id#&type_id=-12','list');";
		i = i + 1;
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array_main.item[61]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_history&order_id=#url.ORDER_ID#&portal_type=employee','project')";
		i = i + 1;

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array_main.item[345]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_page_warnings&action=purchase.detail_order&action_name=order_id&action_id=#attributes.order_id#&relation_papers_type=ORDER_ID</cfoutput>','list');";
		i = i + 1;

		if(get_order_detail.IS_PROCESSED is not "1")
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[133]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_stock&order_id=#attributes.order_id#','horizantal');";
			i = i + 1;
		}		
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[83]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_receive_rate&order_id=#attributes.order_id#&is_purchase=1','white_board');";
		i = i + 1;
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[27]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_basket_contract&order_id=#attributes.order_id#&company_id=#get_order_detail.company_id#&consumer_id=#get_order_detail.consumer_id#','longpage');";

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[197]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_cost&id=#attributes.order_id#&page_type=2&basket_id=#attributes.basket_id#</cfoutput>','wide');";
		
		if(session.ep.isBranchAuthorization neq 1)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array_main.item[156]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=purchase.popup_list_pluses_order&order_id=#attributes.order_id#','medium');";
			i = i + 1;
		}
		if(len(get_order_detail.company_id))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array_main.item[172]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_order_detail.company_id#','medium');";
			i = i + 1;
		}
		else if(len(get_order_detail.consumer_id))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array_main.item[172]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_order_detail.consumer_id#','medium');";
			i = i + 1;
		}
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array_main.item[2593]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=purchase.add_order_product_all_criteria&active_company_id=#session.ep.company_id#&from_purchase_order=1&order_id=#url.order_id#";
		i = i + 1;
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[203]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=purchase.emptypopup_export_order_excel&order_id=#attributes.order_id#";

		if(Get_Invoice_Control.recordcount)
		{
			if(session.ep.isBranchAuthorization eq 1)
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[202]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=store.add_purchase_invoice_from_order&order_id=#attributes.order_id#&is_rate_extra_cost_to_incoice=#x_is_rate_extra_cost_convert_to_incoice#";
				i = i + 1;
			}
			else
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[202]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=invoice.add_purchase_invoice_from_order&order_id=#attributes.order_id#&is_rate_extra_cost_to_incoice=#x_is_rate_extra_cost_convert_to_incoice#";
				i = i + 1;
			}
		}
		
		if(len(get_order_detail.paymethod))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[230]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "openVoucher();";
			i = i + 1;
		}
		if(session.ep.isBranchAuthorization eq 1)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[1577]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_orders_purchase";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		}
		else
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[1577]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=purchase.list_order&event=add";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		}
		if(session.ep.isBranchAuthorization eq 1)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[1578]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = '#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_orders_purchase&order_id=#url.order_id#&active_company_id=#session.ep.company_id#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
		}
		else
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[1578]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = '#request.self#?fuseaction=purchase.list_order&event=add&order_id=#url.order_id#&active_company_id=#session.ep.company_id#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] =  '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] ="windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.order_id#&print_type=91','page');";


		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'purchaseListOrder';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'ORDERS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
</cfscript>
