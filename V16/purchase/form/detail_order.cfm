<cf_xml_page_edit fuseact="purchase.detail_order">
<cf_get_lang_set module_name="purchase"><!--- sayfanin en altinda kapanisi var --->
<cfif isnumeric(attributes.order_id)>
	<cfinclude template="../query/get_order_detail.cfm">
<cfelse>
	<cfset get_order_detail.recordcount = 0>
</cfif>
<cfif not get_order_detail.recordcount or (isdefined("attributes.active_company") and attributes.active_company neq session.ep.company_id)>
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57997.Şube Yetkiniz Uygun Değil'> <cf_get_lang dictionary_id='57998.Veya'> <cf_get_lang dictionary_id='58000.Sirketinizde Böyle Bir Sipariş Bulunamadı'> !</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
	<cfset attributes.basket_id = 6>
	<cfscript>session_basket_kur_ekle(process_type:1,table_type_id:3,action_id:attributes.order_id);</cfscript>
	<cfinclude template="../query/get_setup_priority.cfm">
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
    <cfset pageHead = "#getlang('main',2211)#: #get_order_detail.order_number#">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<div id="basket_main_div">
			<cfform name="form_basket" >
				<cf_basket_form id="detail_order">
					<cfoutput>
						<input type="hidden" name="form_action_address" id="form_action_address" value="#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_order_purchase">
						<cfif session.ep.isBranchAuthorization>
							<input type="hidden" name="is_store" id="is_store" value="1" />
						</cfif>
						<input type="hidden" name="active_company" id="active_company" value="#session.ep.company_id#">
						<input type="hidden" name="search_process_date" id="search_process_date" value="deliverdate">		
						<input type="hidden" name="order_id" id="order_id" value="#url.order_id#">
						<input type="hidden" name="internaldemand_id_list" id="internaldemand_id_list" value="#listdeleteduplicates(valuelist(GET_ORDER_DETAIL.ROW_INTERNALDEMAND_ID))#">	
						<input type="hidden" name="pro_material_id_list" id="pro_material_id_list" value="#listdeleteduplicates(valuelist(GET_ORDER_DETAIL.ROW_PRO_MATERIAL_ID))#">
					</cfoutput>
					<cfinclude template="detail_order_noeditor.cfm">
				</cf_basket_form>
				<cfset attributes.ORDER_ID = url.ORDER_ID>
				<cfinclude template="../../objects/display/basket.cfm">
			</cfform>
		</div>
	</cf_box>
</div>
</cfif>
<script type="text/javascript">
function kontrol()
{
	//Odeme Plani Guncelleme Kontrolleri
	var control_payment_plan= wrk_safe_query('prch_ctrl_pym_plan','dsn3',0,<cfoutput>#attributes.ORDER_ID#</cfoutput>);
	if(control_payment_plan.recordcount)
	{
		if (!confirm("<cf_get_lang dictionary_id='38537.Güncellediğiniz Sipariş İçin Oluşturulmuş Ödeme Planı Silinecektir'>!")) return false;
	}
	if(document.form_basket.deliverdate.value != "" && document.form_basket.order_date.value != "")
		{
			if (!date_check(form_basket.order_date,form_basket.deliverdate,"Sipariş Teslim Tarihi, Sipariş Tarihinden Önce Olamaz !"))
				return false;
		}
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
function openVoucher()
	{
		windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_payment_with_voucher&is_purchase_=1&payment_process_id=#attributes.order_id#&str_table=ORDERS&rate_round_num='+window.basket.hidden_values.basket_rate_round_number_+'&round_number='+window.basket.hidden_values.basket_total_round_number_+'&branch_id='+document.form_basket.branch_id.value</cfoutput>,'page','detail_order');		
	}
function add_adress()
{
	if(!(form_basket.company_id.value=='') || !(form_basket.consumer_id.value==''))
	{
		if(form_basket.company_id.value!='')
		{
			str_adrlink = '&field_long_adres=form_basket.ship_address&field_adress_id=form_basket.ship_address_id';
			if(form_basket.ship_address_city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.ship_address_city_id';
			if(form_basket.ship_address_county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.ship_address_county_id&field_id=form_basket.deliver_comp_id'<cfif session.ep.isBranchAuthorization>+'&is_store_module='+1</cfif>;
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&select_list=1&keyword='+encodeURIComponent(form_basket.company.value)+''+ str_adrlink);
			document.getElementById('deliver_cons_id').value = '';
			return true;
		}
		else
		{
			str_adrlink = '&field_long_adres=form_basket.ship_address&field_adress_id=form_basket.ship_address_id';
			if(form_basket.ship_address_city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.ship_address_city_id';
			if(form_basket.ship_address_county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.ship_address_county_id&field_id=form_basket.deliver_cons_id'<cfif session.ep.isBranchAuthorization>+'&is_store_module='+1</cfif>;
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&select_list=2&keyword='+encodeURIComponent(form_basket.partner_name.value)+''+ str_adrlink);
			document.getElementById('deliver_comp_id').value = '';
			return true;
		}
	}
	else
	{
		alert("<cf_get_lang dictionary_id='38658.Şirket Seçmelisiniz'> !");
		return false;
	}
}
<cfif not get_order_detail.recordcount or (isdefined("attributes.active_company") and attributes.active_company neq session.ep.company_id)><cfelse>
	<cfif isdefined("xml_delivery_date_calculated") and xml_delivery_date_calculated eq 1>
		change_paper_duedate('deliverdate');
	<cfelse>
		change_paper_duedate('order_date');
	</cfif>
</cfif>
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
