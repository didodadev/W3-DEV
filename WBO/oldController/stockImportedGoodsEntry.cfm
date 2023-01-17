<cf_get_lang_set module_name="stock">
<cfif not isdefined("attributes.event") or attributes.event is 'add'>
	<cf_xml_page_edit fuseact="stock.add_stock_in_from_customs">
	<cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
    <cfparam name="attributes.ship_date" default="#dateformat(now(),'dd/mm/yyyy')#">
    <cfquery name="GET_NAME_OF_DEP" datasource="#dsn#">
        SELECT
            SL.PRIORITY,SL.LOCATION_ID,
            D.DEPARTMENT_HEAD,SL.DEPARTMENT_ID,D.BRANCH_ID
        FROM
            DEPARTMENT D,
            STOCKS_LOCATION SL
        WHERE
            SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND	
            D.DEPARTMENT_ID = #listgetat(session.ep.user_location, 1, '-')# AND 
            IS_STORE <> 2 AND
            SL.PRIORITY=1					
    </cfquery>
    <cfset txt_department_name=get_name_of_dep.department_head>
    <cfset attributes.basket_id = 49>			
    <cfset attributes.form_add = 1 >
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cf_xml_page_edit fuseact="stock.add_stock_in_from_customs">
    <cfscript>session_basket_kur_ekle(action_id=attributes.ship_id,table_type_id:2,process_type:1);</cfscript>
	<cfset attributes.UPD_ID = URL.SHIP_ID >
    <cfset attributes.cat ="" >
    <cfinclude template="../stock/query/get_upd_stock_in_from_customs.cfm">
    <cfif not get_upd_purchase.recordcount>
        <cfset hata  = 11>
        <cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'> <cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</cfsavecontent>
        <cfset hata_mesaj  = message>
        <cfinclude template="../dsp_hata.cfm">
        <cfabort>
    </cfif>
    <cfset attributes.basket_id = 49>
	<cfif len(get_upd_purchase.project_id)>
        <cfquery name="GET_PROJECT" datasource="#dsn#">
        	SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #get_upd_purchase.project_id#
        </cfquery>
	</cfif>
    <cfif len(get_upd_purchase.SHIP_METHOD)>
		<cfset attributes.ship_method_id=get_upd_purchase.SHIP_METHOD>
        <cfinclude template="../stock/query/get_ship_method.cfm">
    </cfif>
</cfif>
<script type="text/javascript">
<cfif not isdefined("attributes.event") or attributes.event is 'add'>
	$(document).ready(function(){
		irs_tip_sec();
		});
	function control_depo()
	{
		if(!chk_process_cat('form_basket')) return false;
		if (!check_display_files('form_basket')) return false;
		if(!chk_period(document.form_basket.ship_date,'İşlem')) return false;
		if(!chk_period(document.form_basket.deliver_date_frm,'İşlem')) return false;
		if(!chck_zero_stock()) return false;
		if(form_basket.txt_departman_.value=="" || form_basket.department_id.value=="")
		{
		   alert("<cf_get_lang no ='425.Çıkış Deposu Seçiniz'>!");
		   return false;
		}
		if(form_basket.department_in_txt.value==""||form_basket.department_in_id.value=="")
		{
		    alert("<cf_get_lang no ='424.Giriş Deposu Seçiniz'>!");
			return false;
		}
		<!---Satır bazında seri girilmesi zorunluluğu kontrolü --->
		<cfif isdefined("xml_serialno_control") and (xml_serialno_control eq 1)>
			if(form_basket.product_id != undefined && form_basket.product_id.length != undefined && form_basket.product_id.length >1)
			{
				var bsk_rowCount_ = form_basket.product_id.length;
				prod_name_list = '';
				for(var str_i_r=0; str_i_r < bsk_rowCount_; str_i_r++)
				{
					if(document.form_basket.product_id[str_i_r].value != '')
					{
						wrk_row_id_ = document.form_basket.wrk_row_id[str_i_r].value;
						amount_ = filterNum(document.form_basket.amount[str_i_r].value);
						product_serial_control = wrk_safe_query("chk_product_serial1",'dsn3',0, document.form_basket.product_id[str_i_r].value);
						str1_ = "SELECT SERIAL_NO FROM SERVICE_GUARANTY_NEW WHERE WRK_ROW_ID = '"+ wrk_row_id_ +"'";
						var get_serial_control = wrk_query(str1_,'dsn3');
						if(product_serial_control.IS_SERIAL_NO=='1'&&get_serial_control.recordcount!=amount_)
						{
							prod_name_list = prod_name_list + eval(str_i_r +1) + '.Satır : ' + document.form_basket.product_name[str_i_r].value + '\n';
						}
					}
				}
				if(prod_name_list!='')
				{
					alert(prod_name_list +" Adlı Ürünler İçin Seri Numarası Girmelisiniz!");
					return false;
				}
			}
			else if(document.all.product_id != undefined && document.all.product_id.value != '')
			{
				prod_id_ = document.all.product_id.value;
				wrk_row_id_ = document.all.wrk_row_id.value;
				amount_ = filterNum(document.all.amount.value);
				product_serial_control_ = wrk_safe_query("chk_product_serial1",'dsn3',0,prod_id_);
				str1_ = "SELECT SERIAL_NO FROM SERVICE_GUARANTY_NEW WHERE WRK_ROW_ID = '"+ wrk_row_id_ +"'";
				get_serial_control_ = wrk_query(str1_,'dsn3');
				if(product_serial_control_.IS_SERIAL_NO == 1 && get_serial_control_.recordcount != amount_)
				{
					alert( '1.Satır : ' +document.all.product_name.value +" Adlı Ürün İçin Seri Numarası Girmelisiniz!");
					return false;
				}
			}
		
		</cfif>
		<!---Satır bazında seri girilmesi zorunluluğu kontrolü --->
		if(form_basket.department_in_id.value == form_basket.department_id.value && form_basket.location_in_id.value == form_basket.location_id.value){
			alert("<cf_get_lang no='174.Giriş ve Çıkış Depoları Aynı Olamaz'>!");
			return false;
		}
		else{
			saveForm();
			return false;	
		}			
	}
	function irs_tip_sec()
	{
		max_sel = form_basket.process_cat.options.length;
		for(my_i=0;my_i<=max_sel;my_i++)
		{
			deger = form_basket.process_cat.options[my_i].value;
			if(deger!="")
			{
				var fis_no = eval("form_basket.ct_process_type_" + deger );
				if(fis_no.value == 811)
				{
					form_basket.process_cat.options[my_i].selected = true;
					my_i = max_sel + 1;
				}
			}
		}
	}
	function chck_zero_stock()
	{ 
		if(check_stock_action('form_basket'))
		{
			var basket_zero_stock_status = wrk_safe_query('inv_basket_zero_stock_status','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
			if(basket_zero_stock_status.IS_SELECTED != 1)//<!--- basket sablonunda sıfır stok ile calıs secilmemisse zero_stock kontrolu yapılır --->
			{
				var temp_process_cat = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
				var temp_process_type = eval("document.form_basket.ct_process_type_" + temp_process_cat);
				if(!zero_stock_control(form_basket.department_id.value,form_basket.location_id.value,0,temp_process_type.value,0)) return false;
			}
		}
		return true;
	}
	
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>		
	function depo_control()
	{
		if(!chk_process_cat('form_basket')) return false;
		if(!chk_period(document.form_basket.ship_date,'İşlem')) return false;
		if(!chk_period(document.form_basket.deliver_date_frm,'İşlem')) return false;
		if(!check_display_files('form_basket')) return false;
		if(!chck_zero_stock()) return false;
		if(form_basket.txt_departman_.value=="" || form_basket.department_id.value=="")
		{
		   alert("<cf_get_lang no ='425.Çıkış Deposu Seçiniz'>!");
		   return false;
		}
		if(form_basket.department_in_txt.value==""||form_basket.department_in_id.value=="")
		{
		    alert("<cf_get_lang no ='424.Giriş Deposu Seçiniz'>!");
			return false;
		}
		if(form_basket.department_in_id.value == form_basket.department_id.value && form_basket.location_in_id.value == form_basket.location_id.value){
			alert("<cf_get_lang no='174.Giriş ve Çıkış Depoları Aynı Olamaz'>");
			return false;
		}
		if(form_basket.is_delivered.checked && form_basket.deliver_get.value == '' )
		{
			alert("<cf_get_lang no ='559.Teslim Alanı Seçmelisiniz'> !");
			return false;
		}
		saveForm();
		return false;	
	}
	function kontrol2()
	{
		if(!chk_process_cat('form_basket')) return false;
		if(!chk_period(document.form_basket.ship_date,'İşlem')) return false;
		if(!chk_period(document.form_basket.deliver_date_frm,'İşlem')) return false;
		if(!check_display_files('form_basket')) return false;
		if(!chck_zero_stock(1)) return false; //sadece silme işleminden cagrılırken 1 gönderiliyor
		form_basket.del_ship.value =1;
		return true;
	}
	function chck_zero_stock(is_del)
	{ 
		if(check_stock_action('form_basket'))
		{
			var basket_zero_stock_status = wrk_safe_query('fin_basket_zero_stock_status','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
			var deliver_status = wrk_safe_query("stk_new_sql_ship",'dsn2',0,<cfoutput>#attributes.ship_id#</cfoutput>);
			var temp_process_cat = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
			var temp_process_type = eval("document.form_basket.ct_process_type_" + temp_process_cat);
			if(document.form_basket.is_delivered.checked == true) is_deliver_ = 1; else is_deliver_ = 0;
			// giriş depo kontrolleri
			if(basket_zero_stock_status.IS_SELECTED != 1 && (document.form_basket.is_delivered.checked == true || (document.form_basket.is_delivered.checked == false && deliver_status.IS_DELIVERED == 1) || (document.form_basket.is_delivered.checked == true && deliver_status.IS_DELIVERED == 0) || (document.form_basket.is_delivered.checked == true && deliver_status.IS_DELIVERED == 1)))
				if(!zero_stock_control(form_basket.department_in_id.value,form_basket.location_in_id.value,form_basket.upd_id.value,temp_process_type.value,0,is_del,1,is_deliver_)) return false;
			//çıkış depo kontrolleri
			if(basket_zero_stock_status.IS_SELECTED != 1)
				if(!zero_stock_control(form_basket.department_id.value,form_basket.location_id.value,form_basket.upd_id.value,temp_process_type.value,0,is_del,0)) return false;
		}
		return true;
	}
</cfif>
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'stock.add_stock_in_from_customs';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'stock/form/add_stock_in_from_customs.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'stock/query/add_stock_in_from_customs.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'stock.add_stock_in_from_customs&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['js'] = 'gizle_goster_basket(add_stock_in)';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'stock.add_stock_in_from_customs';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'stock/form/upd_stock_in_from_customs.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'stock/query/upd_stock_in_from_customs.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'stock.add_stock_in_from_customs&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'ship_id=##attributes.ship_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.ship_id##';
	WOStruct['#attributes.fuseaction#']['upd']['js'] = 'gizle_goster_basket(custom_ship)';
          
	if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'stock.add_stock_in_from_customs';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'stock/form/upd_stock_in_from_customs.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'stock/query/upd_stock_in_from_customs.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_purchase';
		WOStruct['#attributes.fuseaction#']['del']['extraParams'] = 'active_period&upd_id&old_process_type&ship_number&cat&del_ship';
	}	 
	    
	if(isdefined("attributes.event") and attributes.event is 'upd')    
	{

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array.item[358]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_cost&id=#url.ship_id#&page_type=4&basket_id=#attributes.basket_id#','page_horizantal')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[345]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=stock.upd_stock_in_from_customs&action_name=ship_id&action_id=#attributes.ship_id#','list')";
		i = 1;
		if(session.ep.our_company_info.GUARANTY_FOLLOWUP)
		{
			i = i + 1;
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array_main.item[305]#/#lang_array_main.item[306]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=stock.list_serial_operations&is_filtre=1&belge_no=#get_upd_purchase.ship_number#&process_cat_id=#get_upd_purchase.ship_type#&process_id=#attributes.UPD_ID#";
		}
		if(get_module_user(22))
		{
			i = i + 1;
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array_main.item[1040]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.ship_id#&process_cat='+form_basket.old_process_type.value,'page','upd_bill')";
		}
		
			
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=stock.add_stock_in_from_customs&event=add";
		if(fuseaction contains 'service')
			url_str = '#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.ship_id#&print_type=30&keyword=service';
		else
			url_str = '#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.ship_id#&print_type=30';
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#url_str#','page','workcube_print')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);

	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'stockImportedGoodsEntry';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'SHIP';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-process_cat','item-ship_number','item-ship_date','item-department_in_id','item-department_id']";
	
</cfscript>

