﻿<cf_get_lang_set module_name="sales"><!--- sayfanin en altinda kapanisi var --->
<cf_xml_page_edit fuseact="objects.popup_add_spect_list"><!--- Bu spec'in ayarlarını çekmek için! --->
<cf_xml_page_edit fuseact="sales.form_add_order">
<cfif isnumeric(attributes.order_id)>
	<cfinclude template="../query/get_order_detail.cfm">
<cfelse>
	<cfset get_order_detail.recordcount = 0>
</cfif>
<cfquery name="orderControl_" datasource="#dsn3#"> <!--- aktif donemde siparisle ilgili irsaliye kaydı olup olmadığı kontrol edilir --->
	SELECT SHIP_ID,PERIOD_ID FROM ORDERS_SHIP WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
</cfquery>
<!--- İrsaliye kesilmişmi kesilmemiş mi kontrolü --->
	<!--- <cfquery name="orderControl" datasource="#dsn3_alias#">
		SELECT OS.ORDER_SHIP_ID, O.ORDER_NUMBER, OS.SHIP_ID, S.SHIP_NUMBER FROM ORDERS_SHIP AS OS LEFT OUTER JOIN ORDERS AS O ON OS.ORDER_ID = O.ORDER_ID LEFT OUTER JOIN #DSN2#.SHIP AS S ON OS.SHIP_ID = S.SHIP_ID WHERE OS.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
	</cfquery>
	<cfquery name="orderRowControl" datasource="#dsn3#">
		SELECT WRK_ROW_ID FROM ORDER_ROW WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
	</cfquery>
	<cfset order_wrk_row_ids = arrayNew(1)>
	<cfoutput query="orderRowControl">
		<cfscript>
			arrayAppend(order_wrk_row_ids,WRK_ROW_ID);
		</cfscript>
	</cfoutput>
	<cfset order_wrk_row_ids = ArrayToList(order_wrk_row_ids,",")>
	<cfquery name="shipRowControl" datasource="#dsn2#">
		SELECT WRK_ROW_RELATION_ID FROM SHIP_ROW WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#orderControl.SHIP_ID#"> AND WRK_ROW_RELATION_ID IN (<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#order_wrk_row_ids#" list="true">)
	</cfquery>
	<cfif orderRowControl.recordCount eq shipRowControl.recordCount>
		<cfset orderControlQuery.status = 1>
		<cfset orderControlQuery.SHIP_NUMBER = orderControl.SHIP_NUMBER>
	<cfelse>
		<cfset orderControlQuery.status = 0>
	</cfif> --->
<!---  --->
<cfset cmp = createObject("component","V16.settings.cfc.setupCountry") />
<cfset GET_COUNTRY_1 = cmp.getCountry()>
<cfquery name="GET_SALE_ZONES" datasource="#DSN#">
	SELECT SZ_ID,SZ_NAME FROM SALES_ZONES WHERE IS_ACTIVE=1 ORDER BY SZ_NAME
</cfquery>
<cfif not (get_order_detail.recordcount) or (isdefined("attributes.active_company") and attributes.active_company neq session.ep.company_id)>
	<br />
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'> <cf_get_lang_main no='588.Sirketinizde Böyle Bir Sipariş Bulunamadı'> !</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
	<cfscript>session_basket_kur_ekle(process_type:1,table_type_id:3,action_id:attributes.order_id);</cfscript> 
	<cfset modul_ = 'sales'>
	<cfset xfa.upd = "#modul_#.emptypopup_upd_order">
    <cfset xfa.del = "#modul_#.emptypopup_del_order">
	<cfinclude template="../query/get_priorities.cfm">
	<cfinclude template="../query/get_moneys.cfm">
	<cfinclude template="../query/get_commethod_cats.cfm">
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
	 <cfquery name="Get_Invoice_Control" datasource="#dsn3#">
		SELECT TOP 1 ODR.ORDER_ID FROM ORDER_ROW ODR, STOCKS S WHERE ODR.ORDER_ID = #get_order_detail.order_id# AND ODR.STOCK_ID = S.STOCK_ID AND ODR.ORDER_ROW_CURRENCY IN (-6,-7)
	</cfquery> 
	<cfif session.ep.isBranchAuthorization>
		<cfset attributes.basket_id = 38>
	<cfelse>	
		<cfset attributes.basket_id = 4>
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
	<cfoutput>
		<cfif len(get_order_detail.frm_branch_id)>
		<cfquery name="get_branch" datasource="#dsn#">
			SELECT BRANCH_NAME FROM BRANCH WHERE BRANCH_ID = #get_order_detail.frm_branch_id#<!--- FBS 20120906 bunu boyle yazan arkadas nedenini aciklayabilir mi? listede baska burda baska? IN (SELECT BRANCH_ID FROM DEPARTMENT WHERE DEPARTMENT_ID = #get_order_detail.deliver_dept_id#) --->
		</cfquery>
		</cfif>
		<cfset branch_name = len(get_order_detail.frm_branch_id) and x_branch_info eq 1 ? get_branch.branch_name :"">
	</cfoutput>
   <cfset pageHead = "#getlang('main','Satış Siparişleri',58207)#: #get_order_detail.order_number# / #branch_name#">
<cf_catalystHeader>
<cf_box>
	<div id="basket_main_div">
    <cfform name="form_basket">
    	<cf_basket_form id="detail_order">
			<input type="hidden" name="form_action_address" id="form_action_address" value="<cfoutput>#xfa.upd#</cfoutput>">
			<input type="hidden" name="is_auto_spec_create" id="is_auto_spec_create" value="<cfoutput>#is_auto_spec_create#</cfoutput>">
			<input type="hidden" name="is_spect_name_to_property" id="is_spect_name_to_property" value="<cfoutput>#is_spect_name_to_property#</cfoutput>">
			<input type="hidden" name="record_date" id="record_date" value="<cfoutput>#DateFormat(get_order_detail.record_date,dateformat_style)#</cfoutput>">
			<input type="hidden" name="x_required_dep" id="x_required_dep" value="<cfoutput>#x_required_dep#</cfoutput>">
			<input type="hidden" name="order_id" id="order_id" value="<cfoutput>#url.order_id#</cfoutput>">
			<input type="hidden" name="active_company" id="active_company" value="<cfoutput>#session.ep.company_id#</cfoutput>"> 
			<input type="hidden" name="search_process_date" id="search_process_date" value="deliverdate">
			<input type="hidden" name="search_process_date_paper" id="search_process_date_paper" value="order_date">
			<input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#get_order_detail.consumer_id#</cfoutput>">
			<input type="hidden" name="consumer_reference_code" id="consumer_reference_code" value="<cfoutput>#get_order_detail.consumer_reference_code#</cfoutput>">
			<input type="hidden" name="pro_material_id_list" id="pro_material_id_list" value="<cfoutput>#listdeleteduplicates(valuelist(GET_ORDER_DETAIL.ROW_PRO_MATERIAL_ID))#</cfoutput>">	
			<input type="hidden" name="frm_branch_id" id="frm_branch_id" value="<cfoutput>#get_order_detail.frm_branch_id#</cfoutput>"> 
			<input type="hidden" name="orders_payment_plan" id="orders_payment_plan" value="0">
			<cfif len(get_order_detail.company_id)>
				<input type="hidden" name="member_type" id="member_type" value="partner">
				<input type="hidden" name="member_id" id="member_id" value="<cfoutput>#get_order_detail.partner_id#</cfoutput>">
				<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_order_detail.company_id#</cfoutput>">			
			<cfif len(get_order_detail.partner_id)>
				<cfset member_name = get_par_info(get_order_detail.partner_id,0,-1,0)>
			<cfelse>
				<cfset member_name = "">
			</cfif>
			<cfset company_name = get_par_info(get_order_detail.company_id,1,0,0)>
			<cfelseif len(get_order_detail.consumer_id)>
				<input type="hidden" name="member_type" id="member_type" value="consumer">
				<input type="hidden" name="member_id" id="member_id" value="<cfoutput>#get_order_detail.consumer_id#</cfoutput>">
				<input type="hidden" name="company_id" id="company_id" value="">
				<cfset attributes.consumer_id = contact_id>
				<cfinclude template="../query/get_consumer_name.cfm">
				<cfset member_name = "#get_consumer_name.consumer_name# #get_consumer_name.consumer_surname#">
				<cfset company_name = get_consumer_name.COMPANY>
			</cfif>
            <input type="hidden" name="order_zone" id="order_zone" value="<cfif get_order_detail.order_zone>psv<cfelse>sa</cfif>">		  
            <cfinclude template="detail_order_sa_noeditor.cfm">
       </cf_basket_form>
       <input type="hidden" name="is_basket" id="is_basket" value="1">
       <cfinclude template="../../objects/display/basket.cfm">
	</cfform>
	</div>
</cf_box>	
<!--- Toplu sevkiyat guncelleme ekranini acmak adina yapidi BK 20081219 --->
<form name="submit_multi_packetship" method="post" action="<cfoutput>#request.self#?fuseaction=stock.form_upd_multi_packetship</cfoutput>">
	<input type="hidden" name="main_ship_fis_no" id="main_ship_fis_no" value="">
</form>
<script type="text/javascript">
	function goto_page(main_ship_fis_no)
	{
		document.getElementById('main_ship_fis_no').value = main_ship_fis_no;
		document.submit_multi_packetship.submit();
	}
	function kontrol()
	{
		var order_reserved = wrk_query("SELECT RESERVED FROM ORDERS WHERE ORDER_ID =<cfoutput>#attributes.order_id#</cfoutput>","dsn3");
		var is_reserved_ = order_reserved.RESERVED;
		var case_reserved = $("#basket_main_div #reserved").length != 0 && $("#basket_main_div #reserved").is(":checked");
		if(is_reserved_ == 0 && case_reserved == true)
		{
			<cfif len(orderControl_.recordcount) and orderControl_.recordcount neq 0>
				alert("<cf_get_lang dictionary_id='61260.Stok rezerve işlemini yeniden yapmak için önce irsaliye bağlantılarını kaldırmalısınız. Rezerve işlemini yaptıktan sonra İrsaliye ve sipariş ilişkisini tekrar kurabilirsiniz'>!");
				return false;
			</cfif>
		}
		var get_is_no_sale=wrk_query("SELECT NO_SALE FROM STOCKS_LOCATION WHERE DEPARTMENT_ID ="+document.getElementById('deliver_dept_id').value+" AND LOCATION_ID ="+document.getElementById('deliver_loc_id').value,"dsn");
		if(get_is_no_sale.recordcount)
		{
			var is_sale_=get_is_no_sale.NO_SALE;
			if(is_sale_==1)
			{
				alert("<cfoutput>#getlang('stock',223)#</cfoutput>!");
				return false;
			}
		}
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
						console.log('burafda');
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
			if( window.basketManager !== undefined ){ 
				if("<cfoutput>#get_order_detail.paymethod#</cfoutput>" != document.form_basket.paymethod_id.value){
					if(confirm("Belgedeki Ödeme Yöntemi Değiştirilmiştir.\nÖdeme Planının Silinmesini Onaylıyor Musunuz?"))
						document.getElementById("orders_payment_plan").value = 1;
					else
						return false;
				}			
				else if("<cfoutput>#wrk_round(get_order_detail.other_money_value,2)#</cfoutput>" != parseFloat(wrk_round((basketManagerObject.basketFooter.basket_net_total() /(basketManagerObject.basketFooter.basket_rate1()*basketManagerObject.basketFooter.basket_rate2())),2)))
				//else if(parseFloat(wrk_round(control_payment_plan.OTHER_MONEY_TOTAL,2)) != parseFloat(wrk_round((document.all.basket_net_total.value/(document.all.basket_rate1.value*document.all.basket_rate2.value)),2)))
				{
					alert("Belgedeki Tutar Değiştirilmiştir.\nLütfen Oluşturulmuş Ödeme Planını Güncelleyiniz!");
					return false;
				}
			}else{
				if("<cfoutput>#get_order_detail.paymethod#</cfoutput>" != document.form_basket.paymethod_id.value){
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
		control_due_date('basket_due_value_date_',document.getElementById('paymethod_id').value);
		return (process_cat_control() && saveForm());
	} 
	$(document).ready(function(){
		<cfif isdefined("xml_sales_delivery_date_calculated") and xml_sales_delivery_date_calculated eq 1>
			if (typeof change_paper_duedate == 'function')
			change_paper_duedate('deliverdate');
		<cfelse>
			if (typeof change_paper_duedate == 'function')
			change_paper_duedate('order_date');
		</cfif>
		});	
	function openVoucher()
	{
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_payment_with_voucher&is_purchase_=0&payment_process_id=#attributes.order_id#&str_table=ORDERS&rate_round_num='+window.basket.hidden_values.basket_rate_round_number_+'&round_number='+window.basket.hidden_values.basket_total_round_number_+'&branch_id='+document.form_basket.branch_id.value</cfoutput>);		
	}	

	function openmodal(){
		if(!(form_basket.company_id.value == "" ) || !(form_basket.consumer_id.value == "" )){
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.basket_in_basket_choose&company_id='+form_basket.company_id.value+'&consumer_id='+form_basket.consumer_id.value+'&member_type='+form_basket.member_type.value+'&member_name='+form_basket.company.value+'&order_id_listesi=<cfoutput>#attributes.order_id#</cfoutput>&order_id_form=<cfoutput>#get_order_detail.order_number#</cfoutput>')
		}
		else{
			alert("<cf_get_lang no='254.Cari Hesap Secmelisiniz'>");
			return false;
		}
	}

	function changemodal(){
		show_hide('sepet_box_2');
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.basket_in_basket&company_id='+$("#company_id").val()+'&consumer_id='+$("#consumer_id").val()+'&member_type='+$("#member_type").val()+'&member_name='+$("#company").val()+'&order_id_listesi=<cfoutput>#attributes.order_id#</cfoutput>&order_id_form=<cfoutput>#get_order_detail.order_number#</cfoutput>', 'warning_modal');
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
				if(form_basket.ship_address_county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.ship_address_county_id&field_id=form_basket.deliver_comp_id'<cfif session.ep.isBranchAuthorization>+'&is_store_module='+1</cfif>;
				openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&select_list=1'+ str_adrlink);
				document.getElementById('deliver_cons_id').value = '';
				return true;
			}
			else
			{
				str_adrlink = '&field_long_adres=form_basket.ship_address&field_adress_id=form_basket.ship_address_id';
				str_adrlink = str_adrlink+'&consumer_id='+form_basket.consumer_id.value+'&member_type='+form_basket.member_type.value+'&member_name='+encodeURIComponent(form_basket.partner_name.value)+'';
				if(form_basket.ship_address_city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.ship_address_city_id';
				if(form_basket.ship_address_county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.ship_address_county_id&field_id=form_basket.deliver_cons_id'<cfif session.ep.isBranchAuthorization>+'&is_store_module='+1</cfif>;
				openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&select_list=2'+ str_adrlink);
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
	function orderControl(orderNumber) {
		alert("<cf_get_lang dictionary_id="51191.Bu sipariş daha önce irsaliyeye bağlanmmış">");
		window.location.href = "<cfoutput>#request.self#</cfoutput>?fuseaction=invoice.list_purchase&keyword=" + orderNumber + "&form_varmi=1&is_post=1";
		return false;
	}
	
	</script>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
