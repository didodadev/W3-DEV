<cf_get_lang_set module_name="invoice"><!--- sayfanin en altinda kapanisi var --->
<cfif not isdefined("attributes.event") or (isdefined("attributes.event") and listfindnocase('add,upd',attributes.event))>
	<cfif isdefined("attributes.event") and attributes.event is 'upd'>
        <cfif isnumeric(attributes.iid)>
			<cfinclude template="../invoice/query/get_purchase_det.cfm">
		<cfelse>
			<cfset get_sale_det.recordcount = 0>
		</cfif>
        <cfif not get_sale_det.recordcount>
			<cfset hata  = 11>
            <cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'>  <cf_get_lang_main no='587.Çalıştığınız Muhasebe Dönemine Ait Böyle Bir Fatura Bulunamadı'> !</cfsavecontent>
            <cfset hata_mesaj  = message>
            <cfinclude template="../dsp_hata.cfm">
            <cfabort>	
		<cfelse>	
            <cfset attributes.basket_id = 33>
            <cfinclude template="../invoice/query/get_session_cash.cfm">
            <cfinclude template="../invoice/query/get_inv_cancel_types.cfm">
            <cfscript>
                session_basket_kur_ekle(action_id=attributes.iid,table_type_id:1,process_type:1);
            </cfscript>
		</cfif>
    </cfif>
	<cfif  not isdefined("attributes.event") or  (isdefined("attributes.event") and attributes.event is 'add')>
		<cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
		<cfinclude template="../invoice/query/get_session_cash.cfm">
		<cfinclude template="../invoice/query/control_bill_no.cfm">
		<cfparam name="attributes.company_id" default="">
		<cfparam name="attributes.company" default="">
		<cfparam name="attributes.partner_name" default="">
		<cfparam name="attributes.partner_id" default="">
		<cfparam name="attributes.ref_no" default="">
		<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
            <cfset attributes.company_id = attributes.company_id>
            <cfset attributes.company = get_par_info(attributes.company_id,1,1,0)>
            <cfif len(attributes.partner_id)>
                <cfset attributes.partner_id = attributes.partner_id>
                <cfset attributes.partner_name = get_par_info(attributes.partner_id,0,-1,0)>
            <cfelse>
                <cfquery name="get_manager_partner" datasource="#dsn#">
                    SELECT MANAGER_PARTNER_ID FROM COMPANY WHERE COMPANY_ID = #attributes.company_id#
                </cfquery>
                <cfset attributes.partner_id = get_manager_partner.manager_partner_id>
                <cfset attributes.partner_name = get_par_info(get_manager_partner.manager_partner_id,0,-1,0)>
            </cfif>
        <cfelseif isdefined("attributes.project_id") and len(attributes.project_id)>
            <cfquery name="get_project_info" datasource="#dsn#">
                SELECT COMPANY_ID,PARTNER_ID,CONSUMER_ID FROM PRO_PROJECTS WHERE PROJECT_ID =#attributes.project_id#
            </cfquery>
            <cfif len(get_project_info.partner_id)>
                <cfset attributes.company_id = get_project_info.company_id>
                <cfset attributes.partner_id = get_project_info.partner_id>
                <cfset attributes.partner_name = get_par_info(get_project_info.partner_id,0,-1,0)>
                <cfset attributes.company =get_par_info(get_project_info.company_id,1,0,0)>
                <cfset attributes.member_account_code = GET_COMPANY_PERIOD(get_project_info.company_id)>
            <cfelseif len(get_project_info.consumer_id)>
                <cfset attributes.consumer_id = get_project_info.consumer_id>
                <cfset attributes.partner_name = get_cons_info(get_project_info.consumer_id,0,0)>
                <cfset attributes.company =get_cons_info(get_project_info.consumer_id,2,0)>
                <cfset attributes.member_account_code = GET_CONSUMER_PERIOD(get_project_info.consumer_id)>
            </cfif>
        </cfif>
        <cfset invoice_date = now()>
		<cfset invoice_number = "">
		<cfif isdefined("attributes.receiving_detail_id")>
            <cfquery name="GET_INV_DET" datasource="#DSN2#">
                SELECT ISSUE_DATE,EINVOICE_ID FROM EINVOICE_RECEIVING_DETAIL WHERE RECEIVING_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.receiving_detail_id#"> 
            </cfquery>
            <cfif get_inv_det.recordcount>
                <cfset invoice_date = get_inv_det.issue_date>
                <cfset serial_no = right(get_inv_det.einvoice_id,13)>
                <cfset serial_number = left(get_inv_det.einvoice_id,3)>
                <cfset invoice_number = "#serial_number#-#serial_no#">
                <script type="text/javascript">
                    try{
                        window.onload = function () { change_money_info('form_basket','invoice_date');}
                    }
                    catch(e){}
                </script>
            </cfif>
        </cfif>
    </cfif>
</cfif>

<script type="text/javascript">
	<cfif not IsDefined("attributes.event") or (isdefined("attributes.event") and attributes.event is 'add')>
			function kontrol()
			{
				if (!paper_control(document.form_basket.invoice_number,'INVOICE',false,0,'',document.form_basket.company_id.value,document.form_basket.consumer_id.value)) return false;
				if (!chk_period(form_basket.invoice_date,"İşlem")) return false;
				if (document.form_basket.company.value == ""  && document.form_basket.consumer_id.value == "")
				{ 
					alert ("<cf_get_lang no='181.Cari Hesap Seçmelisiniz'>!");
					return false;
				}
				if(form_basket.deliver_get.value==""){
					alert("<cf_get_lang no='283.Teslim Alan Seçiniz'>!");
					return false;			
				}		
				if(!chk_process_cat('form_basket')) return false;
				if(!check_display_files('form_basket')) return false;
				var int_cat_type = form_basket.process_cat.options[form_basket.process_cat.selectedIndex].value;
				if(int_cat_type == 64 || int_cat_type == 690)
				{
					if(form_basket.department_id.value=="")
					{
						alert("<cf_get_lang no='282.Depo Seçiniz'>!");
						return false;
					}
				}
				/* if (!check_accounts('form_basket')) return false;*/ /*process_cat eklenince açılacak*/
				/*if (!check_product_accounts()) return false;*/ /*process_cat eklenince açılacak*/
				change_paper_duedate('invoice_date');
				saveForm();
				return false;
			}
			function ayarla_gizle_goster()
			{
				if(form_basket.cash != undefined && form_basket.cash.checked)
				{
					not_2.style.display='';
				}
				else
				{
					not_2.style.display='none';
				}
			}		
	</cfif>
	<cfif IsDefined("attributes.event") and attributes.event is 'upd'>
		function cagir_tarih()
			{	
				if(!paper_control(document.form_basket.invoice_number,'INVOICE',false,<cfoutput>#attributes.iid#,'#get_sale_det.invoice_number#'</cfoutput>,document.form_basket.company_id.value,document.form_basket.consumer_id.value)) return false;
				var is_invoice_cost = true;
				if(document.form_basket.is_cost.value==0) is_invoice_cost = false;
				if (is_invoice_cost && !confirm("<cf_get_lang no ='269.Güncellediğiniz Faturanın Masraf- Gelir Dağıtımı Yapılmış Devam Ederseniz Bu Dağıtım Silinecektir'>!")) return false;
				var int_cat_type = form_basket.process_cat.options[form_basket.process_cat.selectedIndex].value;
				if (!chk_process_cat('form_basket')) return false;
				if(!check_display_files('form_basket')) return false;
				if(int_cat_type == 64 || int_cat_type == 690)
				if(form_basket.department_id.value=="" || form_basket.department_name.value=="")
				{
					alert("<cf_get_lang no='282.Lütfen Depo Seçiniz'>!");
					return false;
				}
				if(form_basket.deliver_get.value=="")
				{
					alert("<cf_get_lang no='283.Teslim Alan Seçiniz'>!");
					return false;			
				}		
				if (!chk_period(form_basket.invoice_date,"İşlem")) return false;
				change_paper_duedate('invoice_date');	
				<cfif not get_module_power_user(20)>
					var process_info = wrk_safe_query('inv_process_info','dsn3',0,form_basket.old_process_cat_id.value);
					var listParam = "<cfoutput>#attributes.iid#</cfoutput>" + "*" + form_basket.old_process_type.value ;
					var closed_info = wrk_safe_query("inv_closed_info",'dsn2',0,listParam);
					if(closed_info.recordcount)
						if((process_info.IS_PAYMETHOD_BASED_CARI == 1 && document.form_basket.old_pay_method.value != document.form_basket.paymethod_id.value) || document.form_basket.old_net_total.value != filterNum(document.all.basket_net_total.value) || (closed_info.COMPANY_ID != '' && closed_info.COMPANY_ID != form_basket.company_id.value) || (closed_info.CONSUMER_ID != '' && closed_info.CONSUMER_ID != form_basket.consumer_id.value) || (form_basket.old_process_type.value != eval("document.form_basket.ct_process_type_" + int_cat_type).value))
						{
							alert("<cf_get_lang no='403.Belge Kapama Talep veya Emir Girilen Belgenin Tutarı Carisi Ödeme Yöntemi veya İşlem Tipi Değiştirilemez'>!");
							return false;
						}
				</cfif>
				return (control_account_process(<cfoutput>'#attributes.iid#','#get_sale_det.invoice_cat#'</cfoutput>) && saveForm()); 
			}
			function kontrol2()
			{
				control_account_process(<cfoutput>'#attributes.iid#','#get_sale_det.invoice_cat#'</cfoutput>); 
				<cfif session.ep.our_company_info.is_efatura and isdefined("get_efatura_det") and get_efatura_det.recordcount>
					alert("Fatura ile İlişkili e-Fatura Olduğu için Silinemez !");
					return false;
				</cfif>
				if (!chk_process_cat('form_basket')) return false;
				if(!check_display_files('form_basket')) return false;
				if (!chk_period(form_basket.invoice_date,"İşlem")) return false;
				form_basket.del_invoice_id.value = <cfoutput>#attributes.iid#</cfoutput>;
				return true;	
			}	
	</cfif>		
</script>



<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	
	if(not isdefined("attributes.event"))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'invoice.form_add_bill_other';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'invoice/display/add_bill_other.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'invoice/query/add_invoice_other.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'invoice.form_add_bill_other&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_basket(add_bill_other)";
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'invoice.detail_invoice_other';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'invoice/display/upd_bill_other.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'invoice/query/upd_invoice_other.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'invoice.form_add_bill_other&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'iid=##attributes.iid##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.iid##';
	WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_basket(upd_other_bill)";
	
	if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'invoice.emptypopup_upd_bill_other&invoice_id=#attributes.iid#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'invoice/query/upd_invoice_other.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'invoice/query/upd_invoice_other.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = '#fusebox.circuit#.list_bill';
		WOStruct['#attributes.fuseaction#']['del']['extraParams'] = 'active_period&old_process_type&del_invoice_id&invoice_number';
	}
	
	
	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array.item[258]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onclick'] = "windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_invoice_orders&invoice_id=#url.iid#','list')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array.item[217]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_cost&id=#url.iid#&page_type=1&basket_id=#attributes.basket_id#','wide')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '#lang_array.item[264]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_upd_expensecenter_invoice&id=#url.iid#','horizantal')";
				
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['text'] = '#lang_array_main.item[1339]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['onclick'] = "windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_get_contract_comparison&iid=#url.iid#','horizantal')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['text'] = '#lang_array_main.item[2577]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_account_cards&invoice_id=#attributes.iid#','page','upd_bill')";
		
		if(session.ep.our_company_info.GUARANTY_FOLLOWUP and get_sale_det.INVOICE_CAT eq 690)
		{	
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['text'] = '#lang_array_main.item[2594]#';
			if(fusebox.circuit is 'store')
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['href'] = "#request.self#?fuseaction=store.list_serial_operations&is_filtre=1&invoice_number=#get_sale_det.invoice_number#";
			else
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['href'] = "#request.self#?fuseaction=stock.list_serial_operations&is_filtre=1&invoice_number=#get_sale_det.invoice_number#";
		}		
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[261]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_bill_other";		
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#url.iid#&print_type=10&action_type=#GET_SALE_DET.invoice_cat#','page')";		
						
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
		WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'invoiceBillOther';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'INVOICE';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-invoice_number','item-company','item-partner_name','item-deliver_get','item-location_id']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
</cfscript>
