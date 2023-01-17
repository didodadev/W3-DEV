	<cf_xml_page_edit fuseact="stock.list_purchase">
    <cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
    <cfparam name="is_show_detail_search" default="1">
    <cfsetting showdebugoutput="yes">
    <cfparam name="attributes.lot_no" default="">
    <cfparam name="attributes.belge_no" default="">
    <cfparam name="attributes.cat" default="">
    <cfparam name="attributes.invoice_action" default=''>
    <cfparam name="attributes.oby" default=1>
    <cfparam name="attributes.company" default="">
    <cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.consumer_id" default="">
    <cfparam name="attributes.employee_id" default="">
    <cfparam name="attributes.company_id_2" default="">
    <cfparam name="attributes.consumer_id_2" default="">
    <cfparam name="attributes.employee_id_2" default="">
    <cfparam name="attributes.partner_id_2" default="">
    <cfparam name="attributes.record_date" default="">
    <cfparam name="attributes.product_name" default="">
    <cfparam name="attributes.stock_id" default="">
    <cfparam name="attributes.product_cat_code" default="-2">
    <cfparam name="attributes.product_cat_name" default="">
    <cfparam name="attributes.department_id" default="">
    <cfparam name="attributes.location_id" default="">
    <cfparam name="attributes.location_name" default="">
    <cfparam name="attributes.department_out" default="">
    <cfparam name="attributes.location_out" default="">
    <cfparam name="attributes.location_out_name" default="">
    <cfparam name="attributes.delivered" default=''>
    <cfparam name="attributes.listing_type" default="1">
    <cfparam name="attributes.project_id" default="">
    <cfparam name="attributes.project_head" default="">
    <cfparam name="attributes.project_id_in" default="">
    <cfparam name="attributes.project_head_in" default="">
    <cfparam name="attributes.subscription_id" default="">
    <cfparam name="attributes.subscription_no" default="">
    <cfparam name="attributes.member_name" default="">
    <cfparam name="attributes.work_id" default="">
    <cfparam name="attributes.work_head" default="">
    <cfparam name="attributes.disp_ship_state" default="">
    <cfparam name="attributes.record_emp_id" default="">
    <cfparam name="attributes.record_name" default="">
    <cfparam name="attributes.row_department_id" default="">
    <cfparam name="attributes.row_location_name" default="">
    <cfparam name="attributes.row_location_id" default="">
    <cfparam name="attributes.row_project_id" default="">
    <cfparam name="attributes.row_project_head" default="">
    <cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
        SELECT 
            D.DEPARTMENT_HEAD,
            SL.DEPARTMENT_ID,
            SL.LOCATION_ID,
            SL.STATUS,
            SL.COMMENT
        FROM 
            STOCKS_LOCATION SL,
            DEPARTMENT D,
            BRANCH B
        WHERE
            D.IS_STORE <>2 AND
            SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND
            D.DEPARTMENT_STATUS = 1 AND
            D.BRANCH_ID = B.BRANCH_ID AND
            B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
        <cfif fusebox.circuit is "store">
            AND B.BRANCH_ID = #listgetat(session.ep.user_location, 2, '-')#
        </cfif>
        <cfif isDefined("get_offer_detail.deliver_place") and len(get_offer_detail.deliver_place)>
            AND D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_offer_detail.deliver_place#">
        </cfif>
        <cfif isDefined("get_order_detail.ship_address") and len(get_order_detail.ship_address) and isnumeric(get_order_detail.ship_address)>
            AND D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_detail.ship_address#">
        </cfif>
        ORDER BY
            D.DEPARTMENT_HEAD,
            COMMENT
    </cfquery>
    <cfif xml_list_cancel_stock eq 1><!--- xml den parametre almakta --->
        <cfset attributes.iptal_stocks = 1>
    <cfelseif xml_list_cancel_stock eq 0>
        <cfset attributes.iptal_stocks = 0>
    <cfelse>
        <cfset attributes.iptal_stocks = ''>
    </cfif>
    <cfif isdefined("attributes.date2") and isdate(attributes.date2)>
        <cf_date tarih="attributes.date2">
    <cfelse>
        <cfif session.ep.our_company_info.unconditional_list>
            <cfset attributes.date2 = ''>
        <cfelse>
            <cfset attributes.date2 = wrk_get_today()>
        </cfif>
    </cfif>
    <cfif isdefined("attributes.date1") and isdate(attributes.date1)>
        <cf_date tarih="attributes.date1">
    <cfelse>
        <cfif session.ep.our_company_info.unconditional_list>
            <cfset attributes.date1 = ''>
            <cfelse>
        <cfset attributes.date1 = date_add('ww',-1,attributes.date2)>
        </cfif>
    </cfif>
    <cfif isdate(attributes.record_date)>
        <cf_date tarih="attributes.record_date">
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>
    <cfif isdefined("attributes.is_form_submitted")>
        <cfscript>
            get_ship_fis_action = createObject("component", "stock.cfc.get_purchases");
            get_ship_fis_action.dsn = dsn;
            get_ship_fis_action.dsn2 = dsn2;
            get_ship_fis_action.dsn_alias = dsn_alias;
            get_ship_fis_action.dsn1_alias = dsn1_alias;
            get_ship_fis_action.dsn3_alias = dsn3_alias;
            get_ship_fis = get_ship_fis_action.GET_SHIP_FIS_fnc
                (
                    cat : '#IIf(IsDefined("attributes.cat"),"attributes.cat",DE(""))#',
                    consumer_id : '#IIf(IsDefined("attributes.consumer_id"),"attributes.consumer_id",DE(""))#',
                    company_id : '#IIf(IsDefined("attributes.company_id"),"attributes.company_id",DE(""))#',
                    invoice_action : '#IIf(IsDefined("attributes.invoice_action"),"attributes.invoice_action",DE(""))#',
                    listing_type : '#IIf(IsDefined("attributes.listing_type"),"attributes.listing_type",DE(""))#',
                    record_date : '#IIf(IsDefined("attributes.record_date"),"attributes.record_date",DE(""))#',
                    date1 : '#IIf(IsDefined("attributes.date1"),"attributes.date1",DE(""))#',
                    date2 : '#IIf(IsDefined("attributes.date2"),"attributes.date2",DE(""))#',
                    department_id : '#IIf(IsDefined("attributes.department_id"),"attributes.department_id",DE(""))#',
                    department_out : '#IIf(IsDefined("attributes.department_out"),"attributes.department_out",DE(""))#',
                    location_id : '#IIf(IsDefined("attributes.location_id"),"attributes.location_id",DE(""))#',
                    location_out : '#IIf(IsDefined("attributes.location_out"),"attributes.location_out",DE(""))#',
                    module_name : '#fusebox.circuit#',
                    belge_no : '#IIf(IsDefined("attributes.belge_no"),"attributes.belge_no",DE(""))#',
                    project_id : '#IIf(IsDefined("attributes.project_id") and len(attributes.project_head),"attributes.project_id",DE(""))#',
                    project_id_in : '#IIf(IsDefined("attributes.project_id_in") and len(attributes.project_head_in),"attributes.project_id_in",DE(""))#',
                    subscription_id : '#IIf(IsDefined("attributes.subscription_id"),"attributes.subscription_id",DE(""))#',
                    subscription_no : '#IIf(IsDefined("attributes.subscription_no"),"attributes.subscription_no",DE(""))#',
                    employee_id : '#IIf(IsDefined("attributes.employee_id"),"attributes.employee_id",DE(""))#',
                    iptal_stocks : '#IIf(IsDefined("attributes.iptal_stocks"),"attributes.iptal_stocks",DE(""))#',
                    stock_id : '#IIf(IsDefined("attributes.stock_id"),"attributes.stock_id",DE(""))#',
                    product_name : '#IIf(IsDefined("attributes.product_name"),"attributes.product_name",DE(""))#',
                    product_cat_code : '#IIf(IsDefined("attributes.product_cat_code"),"attributes.product_cat_code",DE(""))#',
                    product_cat_name : '#IIf(IsDefined("attributes.product_cat_name"),"attributes.product_cat_name",DE(""))#',
                    delivered : '#IIf(IsDefined("attributes.delivered"),"attributes.delivered",DE(""))#',
                    deliver_emp : '#IIf(IsDefined("attributes.deliver_emp"),"attributes.deliver_emp",DE(""))#',
                    deliver_emp_id : '#IIf(IsDefined("attributes.deliver_emp_id"),"attributes.deliver_emp_id",DE(""))#',
                    company_id_2 : '#IIf(IsDefined("attributes.company_id_2"),"attributes.company_id_2",DE(""))#',
                    member_name : '#IIf(IsDefined("attributes.member_name"),"attributes.member_name",DE(""))#',
                    consumer_id_2 : '#IIf(IsDefined("attributes.consumer_id_2"),"attributes.consumer_id_2",DE(""))#',
                    employee_id_2 : '#IIf(IsDefined("attributes.employee_id_2"),"attributes.employee_id_2",DE(""))#',
                    partner_id_2 : '#IIf(IsDefined("attributes.partner_id_2"),"attributes.partner_id_2",DE(""))#',
                    lot_no : '#IIf(IsDefined("attributes.lot_no"),"attributes.lot_no",DE(""))#',
                    oby : '#IIf(IsDefined("attributes.oby"),"attributes.oby",DE(""))#',
                    work_id : '#IIf(len(attributes.work_head) and len("attributes.work_id"),"attributes.work_id",DE(""))#',
                    startrow : '#IIf(len(attributes.startrow) and len("attributes.startrow"),"attributes.startrow",DE(""))#',
                    maxrows :  '#IIf(len(attributes.maxrows) and len("attributes.maxrows"),"attributes.maxrows",DE(""))#',
                    disp_ship_state : '#IIf(IsDefined("attributes.disp_ship_state"),"attributes.disp_ship_state",DE(""))#',
                    record_emp_id : '#IIf(IsDefined("attributes.record_emp_id"),"attributes.record_emp_id",DE(""))#',
                    record_name : '#IIf(IsDefined("attributes.record_name"),"attributes.record_name",DE(""))#',
                    row_department_id : '#IIf(IsDefined("attributes.row_department_id"),"attributes.row_department_id",DE(""))#',
                    row_location_id : '#IIf(IsDefined("attributes.row_location_id"),"attributes.row_location_id",DE(""))#',
                    xml_department_filter : '#IIf(IsDefined("xml_department_filter"),"xml_department_filter",DE(""))#',
                    xml_project_filter : '#IIf(IsDefined("xml_project_filter"),"xml_project_filter",DE(""))#',
                    row_project_id : '#IIf(IsDefined("attributes.row_project_id"),"attributes.row_project_id",DE(""))#',
                    row_project_head : '#IIf(IsDefined("attributes.row_project_head"),"attributes.row_project_head",DE(""))#',
					x_show_process_cat : '#IIf(IsDefined("x_show_process_cat"),"x_show_process_cat",DE(""))#',
					xml_show_invoice : '#IIf(IsDefined("xml_show_invoice"),"xml_show_invoice",DE(""))#'
					
             );
        </cfscript> 
    <cfelse>
        <cfset get_ship_fis.recordcount = 0>
    </cfif>
    <cfset islem_tipi = '78,81,82,83,112,113,114,811,761,70,71,72,73,74,75,76,77,79,80,84,85,86,88,110,111,115,116,118,1182,119,140,141,811,1131'>
    <cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
        SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (#islem_tipi#) ORDER BY PROCESS_TYPE
    </cfquery>
    <cfset stock_fis_ = 0>
    <cfif get_ship_fis.recordcount>
        <cfparam name="attributes.totalrecords" default='#get_ship_fis.query_count#'>
    <cfelse>
        <cfparam name="attributes.totalrecords" default='0'>
    </cfif>

<script type="text/javascript">
/*
$(function( ){
	//document.getElementById('').focus();
	$('[name="belge_no"]')[0].focus();


});
*/


function send_print()
{
	<cfif not get_ship_fis.recordcount>
		alert('Yazdırılacak İşlem Bulunamadı! Toplu Print Yapamazsınız!');
		return false;
	<cfelseif get_ship_fis.recordcount eq 1>
		if(document.form_send_print.print_islem_id.checked == false)
		{
			alert('Yazdırılacak İşlem Bulunamadı! Toplu Print Yapamazsınız!');
			return false;
		}
		else
		{
			ship_list_ = document.form_send_print.print_islem_id.value;
		}
	<cfelseif get_ship_fis.recordcount gt 1>
		ship_list_ = "";
		for (i=0; i < document.form_send_print.print_islem_id.length; i++)
		{
			if(document.form_send_print.print_islem_id[i].checked == true)
				{
				ship_list_ = ship_list_ + document.form_send_print.print_islem_id[i].value + ',';
				}	
		}
		if(ship_list_.length == 0)
			{
			alert('Yazdırılacak İşlem Bulunamadı! Toplu Print Yapamazsınız!');
			return false;
			}
	</cfif>
	<cfif stock_fis_ eq 1>
		alert("Bu İşlemde Fişleri Basamazsınız !");
		return false;
	<cfelse>
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_print_files&print_type=30&action_row_id='+ship_list_,'page');
	</cfif>
}
function input_control()
{
	<cfif not session.ep.our_company_info.unconditional_list>
		if(frm_search.date1.value.length == 0 && frm_search.date2.value.length == 0 && frm_search.belge_no.value.length == 0 && frm_search.cat.value.length == 0 && frm_search.department_id.value.length == 0 &&
		  (frm_search.stock_id.value.length == 0 || frm_search.product_name.value.length == 0) && (frm_search.company_id.value.length == 0 || frm_search.company.value.length == 0) )
		{
			alert("<cf_get_lang_main no='1538.En Az Bir Alanda Filtre Etmelisiniz'> !");
			return false;
		}
		else
			return true;
	<cfelse>
		/*if(document.frm_search.member_name.value.length==0)
			document.frm_search.deliver_emp_id.value=='';	*/
		return true;
	</cfif>	
}
function cat_control()
{//mal alım irsaliyeleri ve satır bazında çekildiğinde filtre görülür.
	if (list_getat(document.getElementById("cat").value,1,'-') == 76 && document.getElementById('listing_type').value == 2)
	{
		disp_ship_state_.style.display = '';
	}
	else
	{
		disp_ship_state_.style.display = 'none';
	}
	if (document.getElementById('listing_type').value == 2)
	{
		row_dept.style.display = '';
		row_project.style.display = '';
		var x=document.getElementById("oby");
		var option=document.createElement("option");
		option.text="Stok Kodu Bazında Artan";
		option.value="5";
		try
		  {
		  // for IE earlier than version 8
		  x.add(option,x.options[null]);
		  }
		catch (e)
		  {
		  x.add(option,null);
		  }
		var x=document.getElementById("oby");
		var option=document.createElement("option");
		option.text="Stok Kodu Bazında Azalan";
		option.value="6";
		try
		  {
		  // for IE earlier than version 8
		  x.add(option,x.options[null]);
		  }
		catch (e)
		  {
		  x.add(option,null);
		  }
	}
	else
	{
		row_dept.style.display = 'none';
		row_project.style.display = 'none';
		if (document.getElementById('stock_asc') != undefined)
			document.getElementById('oby').removeChild(document.getElementById('stock_asc'));
		if (document.getElementById('stock_desc') != undefined)
			document.getElementById('oby').removeChild(document.getElementById('stock_desc'));
	}
}
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'stock.list_purchase';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'stock/display/list_purchase.cfm';
	WOStruct['#attributes.fuseaction#']['list']['default'] = 1;
</cfscript>
