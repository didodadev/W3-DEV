<cf_get_lang_set module_name="stock">
<cfif (isdefined("attributes.event") and attributes.event is 'add') or not isdefined("attributes.event")>
	<cfscript>
        if(isDefined("attributes.dispatch_ship_id") and Len(attributes.dispatch_ship_id))
            session_basket_kur_ekle(action_id=attributes.dispatch_ship_id,table_type_id:10,process_type:1);
        else if(isdefined('attributes.is_ship_copy') and isdefined('attributes.ship_id') and len(attributes.ship_id))
            session_basket_kur_ekle(action_id=attributes.ship_id,table_type_id:2,process_type:1);
        else
            session_basket_kur_ekle(process_type:0);
    </cfscript>
    <cfif isdefined("attributes.department_id") and isdefined("attributes.location_id") and len(attributes.department_id) and len(attributes.location_id)>
        <cfset txt_department_name =get_location_info(attributes.department_id,attributes.location_id)>
    </cfif>
    <cfif isdefined("attributes.department_in_id") and isdefined("attributes.location_in_id") and len(attributes.department_in_id) and len(attributes.location_in_id)>
        <cfset attributes.department_in_txt =get_location_info(attributes.department_in_id,attributes.location_in_id)>
    </cfif>
    <cfif (isdefined('attributes.is_ship_copy') or isdefined('attributes.from_sale_ship')) and isdefined('attributes.ship_id') and len(attributes.ship_id)><!--- from_sale_ship: konsinye satış irsaliyesinden depo sevk irsaliyesi olusturulurken gonderiliyor --->
        <cfquery name="GET_UPD_PURCHASE" datasource="#DSN2#">
            SELECT * FROM SHIP WHERE SHIP_ID = #attributes.ship_id#
        </cfquery>
        <cfscript>
            attributes.ref_no = get_upd_purchase.ref_no;
            attributes.pj_id = get_upd_purchase.project_id;
            attributes.ship_method_id = get_upd_purchase.ship_method;
            if(len(attributes.ship_method_id))
            {
                include('get_ship_method.cfm','\stock\query');
                attributes.ship_method_txt_ =GET_SHIP_METHOD.SHIP_METHOD;
            }
            attributes.department_id = get_upd_purchase.deliver_store_id;
            attributes.location_id = get_upd_purchase.location;
            txt_department_name =get_location_info(get_upd_purchase.deliver_store_id,get_upd_purchase.location);
            attributes.department_in_id = get_upd_purchase.department_in;
            attributes.location_in_id = get_upd_purchase.location_in;
            attributes.department_in_txt=get_location_info(get_upd_purchase.department_in,get_upd_purchase.location_in);
            attributes.deliver_date = get_upd_purchase.deliver_date;
            attributes.ship_detail	=get_upd_purchase.ship_detail;
        </cfscript>
    <cfelseif isdefined('attributes.internal_row_info')>
        <cfscript>
            internald_row_amount_list ="";
            internald_row_id_list ="";
            internaldemand_id_list ="";
            for(ind_i=1; ind_i lte listlen(attributes.internal_row_info); ind_i=ind_i+1)
            {
                temp_row_info_ = listgetat(attributes.internal_row_info,ind_i);
                if(isdefined('add_stock_amount_#replace(temp_row_info_,";","_")#') and len(evaluate('add_stock_amount_#replace(temp_row_info_,";","_")#')) )
                {
                    internald_row_amount_list = listappend(internald_row_amount_list,filterNum(evaluate('add_stock_amount_#replace(temp_row_info_,";","_")#'),4));
                    internald_row_id_list = listappend(internald_row_id_list,listlast(temp_row_info_,';'));
                    if(not listfind(internaldemand_id_list,listfirst(temp_row_info_,';')))
                        internaldemand_id_list = listappend(internaldemand_id_list,listfirst(temp_row_info_,';'));
                }
            }
        </cfscript>
        <cfquery name="get_internaldemand_info" datasource="#dsn3#">
                SELECT PROJECT_ID,PROJECT_ID_OUT,WORK_ID FROM INTERNALDEMAND WHERE INTERNAL_ID IN (#internaldemand_id_list#)
        </cfquery>
    
        <cfscript>
            if(ListLen(ListDeleteDuplicates(ValueList(get_internaldemand_info.project_id,',')),',') eq 1)
                attributes.project_id = ListDeleteDuplicates(ValueList(get_internaldemand_info.project_id,','));
            else
                attributes.project_id = "";
                
            if(ListLen(ListDeleteDuplicates(ValueList(get_internaldemand_info.project_id_out,',')),',') eq 1)
                attributes.pj_id = ListDeleteDuplicates(ValueList(get_internaldemand_info.project_id_out,','));
            else
                attributes.pj_id = "";	
    
            if(ListLen(ListDeleteDuplicates(ValueList(get_internaldemand_info.work_id,',')),',') eq 1)
                attributes.work_id = ListDeleteDuplicates(ValueList(get_internaldemand_info.work_id,','));
            else
                attributes.work_id = "";
        </cfscript>
    <cfelseif isdefined("attributes.dispatch_ship_id") and len(attributes.dispatch_ship_id)>
        <cfquery name="GET_UPD_PURCHASE" datasource="#DSN2#">
            SELECT * FROM SHIP_INTERNAL WHERE DISPATCH_SHIP_ID = #attributes.dispatch_ship_id#
        </cfquery>
        <cfscript>
            attributes.ref_no = "";
            attributes.pj_id = "";
            attributes.ship_method_id = get_upd_purchase.ship_method;
            if(len(attributes.ship_method_id))
            {
                include('get_ship_method.cfm','\stock\query');
                attributes.ship_method_txt_ =GET_SHIP_METHOD.SHIP_METHOD;
            }
            attributes.department_id = get_upd_purchase.department_out;
            attributes.location_id = get_upd_purchase.location_out;
            txt_department_name =get_location_info(get_upd_purchase.department_out,get_upd_purchase.location_out);
            attributes.department_in_id = get_upd_purchase.department_in;
            attributes.location_in_id = get_upd_purchase.location_in;
            attributes.department_in_txt=get_location_info(get_upd_purchase.department_in,get_upd_purchase.location_in);
            attributes.deliver_date = get_upd_purchase.deliver_date;
            attributes.ship_detail	=get_upd_purchase.detail;
        </cfscript>
    </cfif>
    <cfif isdefined('attributes.is_from_report')><!--- isbak için yapılan üretim sevk özel raporundan gelen değerler için kullanılıyor. silmeyiniz. hgul 20130108 --->
		<cfif isDefined("form.department_out")><cfset attributes.department_id = form.department_out></cfif>
        <cfif isDefined("form.department_out")><cfset attributes.location_id = form.location_out></cfif>
        <cfif isDefined("form.department_out")><cfset attributes.department_in_id = form.department_in></cfif>
        <cfif isDefined("form.department_out")><cfset attributes.location_in_id = form.location_in></cfif>
        <cfif isDefined("form.department_out")><cfset attributes.txt_department_name = get_location_info(attributes.department_id,attributes.location_id)></cfif>
        <cfif isDefined("form.department_out")><cfset attributes.department_in_txt = get_location_info(attributes.department_in_id,attributes.location_in_id)></cfif>
        <cfif isDefined("form.department_out")><cfset attributes.ref_no = form.convert_p_order_no></cfif> 
    </cfif>
    <cfparam name="attributes.ship_date" default="#dateformat(now(),'dd/mm/yyyy')#">
    <cf_papers paper_type="ship">
	   <cfif isdefined("attributes.dispatch_ship_id") and len(attributes.dispatch_ship_id)>
        <cfset attributes.basket_id = 31>
        <cfset attributes.basket_sub_id = 44>
    </cfif>
    <cfif isdefined('attributes.internal_row_info') or isdefined('from_sale_ship')><!--- iç talepler listesinden olusturulacaksa --->
        <cfset attributes.basket_related_action = 1> 
    </cfif>
    <cfif session.ep.isBranchAuthorization eq 1><!--- subeden cagırılıyorsa sube basket sablonunu kullansın--->
        <cfset attributes.basket_id = 32> 
    <cfelse>
        <cfset attributes.basket_id = 31>
    </cfif>
    <cfif isdefined('attributes.service_ids') and len(attributes.service_ids)> <!--- servis modulunden cagırılıyorsa --->
        <cfset attributes.basket_id = 48>
    </cfif>
    <cfif not isdefined('attributes.type') and not isdefined('attributes.is_from_report') and not (isdefined('attributes.is_ship_copy') and isdefined('attributes.ship_id') and len(attributes.ship_id)) and not isdefined("attributes.dispatch_ship_id") and not (isdefined('attributes.service_ids') and len(attributes.service_ids))>
        <cfif not isdefined("attributes.file_format")>
            <cfset attributes.form_add = 1>
        <cfelse>
            <cfset attributes.basket_sub_id = 41>
        </cfif>		
    </cfif>
	<cfif not (isdefined('txt_department_name') and len(txt_department_name))>
        <cfset search_dep_id = listgetat(session.ep.user_location,1,'-')>
        <cfinclude template="../stock/query/get_dep_names_for_inv.cfm">
        <cfinclude template="../stock/query/get_default_location.cfm">
        <cfif get_loc.recordcount and get_name_of_dep.recordcount>
            <cfset txt_department_name = get_name_of_dep.department_head&'-'&get_loc.comment>
            <cfset attributes.department_id = search_dep_id>
            <cfset attributes.location_id = get_loc.location_id>
        <cfelse>
            <cfset txt_department_name = ''>
        </cfif>
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
    <cf_xml_page_edit fuseact="stock.upd_ship_dispatch">
    <cfif session.ep.isBranchAuthorization eq 1>
        <cfset attributes.basket_id = 32> 
    <cfelse>
        <cfset attributes.basket_id = 31>
    </cfif>
    <cfif isnumeric(attributes.ship_id)>
        <cfscript>session_basket_kur_ekle(action_id=attributes.ship_id,table_type_id:2,process_type:1);</cfscript>
        <cfset attributes.upd_id = url.ship_id>
        <cfset attributes.cat = "">
        <cfset attributes.head = "">
        <cfinclude template="../stock/query/get_upd_purchase.cfm">
    <cfelse>
        <cfset get_upd_purchase.recordcount = 0>
    </cfif>
    <cfif not get_upd_purchase.recordcount>
        <cfset hata  = 11>
        <cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'> <cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</cfsavecontent>
        <cfset hata_mesaj  = message>
        <cfinclude template="../dsp_hata.cfm">
    	<cfabort>
    </cfif>
	<cfif len(get_upd_purchase.ship_method)>
        <cfset attributes.ship_method_id = get_upd_purchase.ship_method>
        <cfinclude template="../stock/query/get_ship_method.cfm">
    </cfif>
</cfif>
<script type="text/javascript">
<cfif (isdefined("attributes.event") and attributes.event is 'add') or not isdefined("attributes.event")>
	function control_depo()
	{
	
		if(!chk_period(form_basket.ship_date,"İşlem")) return false;
		if(!chk_process_cat('form_basket')) return false;
		if (!check_display_files('form_basket')) return false;
		if(form_basket.txt_departman_.value=="" || form_basket.department_id.value == "")
		{
			alert("<cf_get_lang no ='425.Çıkış Deposu Seçiniz'>!");
			return false;
		}
		if(form_basket.department_in_txt.value=="" || form_basket.department_in_id.value == "")
		{
			alert("<cf_get_lang no ='424.Giriş Deposu Seçiniz'>!");
			return false;
		}
		<cfif isdefined("xml_select_same_dept") and xml_select_same_dept eq 0>
			if(form_basket.department_in_id.value == form_basket.department_id.value && form_basket.location_id.value == form_basket.location_in_id.value)
			{
				alert("<cf_get_lang no ='445.Giriş ve Çıkış Depoda Aynı Lokasyon Seçilemez'>!");
				return false;
			}
		</cfif>
		
		if(datediff(document.getElementById('deliver_date_frm').value,document.getElementById('ship_date').value)>0)
		{
			alert("Fiili Sevk Tarihi, Belge Tarihinden Önce Olamaz!");
			return false;
		}
		
		if(check_stock_action('form_basket'))
		{
			var basket_zero_stock_status = wrk_safe_query('inv_basket_zero_stock_status','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
			if(basket_zero_stock_status.IS_SELECTED != 1)
			{
				var temp_process_cat = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
				var temp_process_type = eval("document.form_basket.ct_process_type_" + temp_process_cat);
				if(!zero_stock_control(form_basket.department_id.value,form_basket.location_id.value,0,temp_process_type.value)) return false;
			}
		}
	
		if(form_basket.ship_number.value == "")
		{
			alert("<cf_get_lang no='374.Lütfen Belge No Giriniz'>!");
			return false;
		}
	
		else
		{
			var BELGE_NO_CONTROL = wrk_safe_query('stk_belge_no_control','dsn2',0,form_basket.ship_number.value);
			if(BELGE_NO_CONTROL.recordcount)
			{
				alert("<cf_get_lang_main no='710.Girdiğiniz Belge No Kullanılıyor'>!");
				return false;
			}	
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
		<cfif isdefined("xml_upd_row_project") and xml_upd_row_project eq 1>
			project_field_name = 'project_head_in';
			project_field_id = 'project_id_in';
			apply_deliver_date('',project_field_name,project_field_id);
		</cfif>
		saveForm();
		return false;
	}
	function irs_tip_sec()
	{
		max_sel = form_basket.process_cat.options.length;
		for(my_i=0;my_i<=max_sel;my_i++)
		{
			if(form_basket.process_cat.options[my_i]!=undefined)
			{
				deger = form_basket.process_cat.options[my_i].value;
				if(deger!="")
				{
					var fis_no = eval("form_basket.ct_process_type_" + deger );
					if(fis_no.value == 81)
					{
						form_basket.process_cat.options[my_i].selected = true;
						my_i = max_sel + 1;
					}
				}
			}
		}
	}
	//irs_tip_sec(); ne işe yaradığını anlayamadım selected özelliğini kullanmamaı engellediği için kapatıyorum PY 
	function change_deliver_date()
	{//eklemede,irsaliye tarihi değiştiğinde fiili sevk tarihi de değişir
		document.form_basket.deliver_date_frm.value = document.form_basket.ship_date.value;
	}
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	function depo_control()
	{	
		
		if(!chk_period(form_basket.ship_date,"İşlem")) return false;
		if(!chk_process_cat('form_basket')) return false;
		if(!check_display_files('form_basket')) return false;
		if(form_basket.is_delivered.checked)
		{
			if(form_basket.department_in_id.value == "" )
			{
				alert("<cf_get_lang no='138.Teslim Edilecek Depo Bilgisini Seçiniz'>");
				return false;
			}				
			// Xml den gelen parametre secilmis ise 
			<cfif xml_deliver_required eq 1>
				if(form_basket.deliver_get.value == "" )
				{
					alert("<cf_get_lang no='111.Teslim Alan Girmelisiniz'> !");
					return false;
				}
			</cfif>		
		}
		if(form_basket.txt_departman_.value=="" || form_basket.department_id.value == "")
		{
			alert("<cf_get_lang no ='425.Çıkış Deposu Seçiniz'>!");
			return false;
		}
		if(form_basket.department_in_txt.value=="" || form_basket.department_in_id.value == "")
		{
			alert("<cf_get_lang no ='424.Giriş Deposu Seçiniz'>!");
			return false;
		}
		<cfif isdefined("xml_select_same_dept") and xml_select_same_dept eq 0>
			if((form_basket.department_in_id.value == form_basket.department_id.value) && (form_basket.location_in_id.value == form_basket.location_id.value) )
			{
				alert("Giriş ve Çıkış Depoda Aynı Lokasyon Seçilemez!");
				return false;
			}
		</cfif>
		if(check_stock_action('form_basket'))
		{
			var basket_zero_stock_status = wrk_safe_query('fin_basket_zero_stock_status','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
			var deliver_status = wrk_safe_query("stk_new_sql_ship",'dsn2',0,<cfoutput>#attributes.ship_id#</cfoutput>);
			if(document.form_basket.is_delivered.checked == true) is_deliver_ = 1; else is_deliver_ = 0;
			var temp_process_cat = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
			var temp_process_type = eval("document.form_basket.ct_process_type_" + temp_process_cat);
			// giriş depo kontrolleri
			if(basket_zero_stock_status.IS_SELECTED != 1 && ((document.form_basket.is_delivered.checked == false && deliver_status.IS_DELIVERED == 1) || (document.form_basket.is_delivered.checked == true && deliver_status.IS_DELIVERED == 0) || (document.form_basket.is_delivered.checked == true && deliver_status.IS_DELIVERED == 1)))
				if(!zero_stock_control(form_basket.department_in_id.value,form_basket.location_in_id.value,form_basket.upd_id.value,temp_process_type.value,0,0,1,is_deliver_)) return false;
			//cikis depo kontrolleri
			if(basket_zero_stock_status.IS_SELECTED != 1)
				if(!zero_stock_control(form_basket.department_id.value,form_basket.location_id.value,form_basket.upd_id.value,temp_process_type.value)) return false;
		}
		<cfif isdefined("xml_upd_row_project") and xml_upd_row_project eq 1>
			project_field_name = 'project_head_in';
			project_field_id = 'project_id_in';
			apply_deliver_date('',project_field_name,project_field_id);
		</cfif>
		
		saveForm();
		return false;	
	}
	function kontrol2()
	{
		if(!chk_process_cat('form_basket')) return false;
		if(!check_display_files('form_basket')) return false;
		if(!chk_period(form_basket.ship_date,"İşlem")) return false;
		form_basket.del_ship.value =1;
		if(check_stock_action('form_basket'))
		{
			var basket_zero_stock_status = wrk_safe_query('inv_basket_zero_stock_status','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
			if(basket_zero_stock_status.IS_SELECTED != 1)
			{
				var temp_process_cat = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
				var temp_process_type = eval("document.form_basket.ct_process_type_" + temp_process_cat);
				if(!zero_stock_control(form_basket.department_in_id.value,form_basket.location_in_id.value,form_basket.upd_id.value,temp_process_type.value,0,1,1)) return false;
			}
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
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.add_ship_dispatch';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'stock/form/add_dispatch_ship.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'stock/query/add_dispatch_ship.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.add_ship_dispatch&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['default'] = 1;
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_basket(dispatch_ship)";
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.add_ship_dispatch';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'stock/form/upd_dispatch_ship.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'stock/query/upd_dispatch_ship.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.add_ship_dispatch&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'ship_id=##attributes.ship_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.ship_id##';
	WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_basket(d_ship)";
	
	if(attributes.event is 'add' or not isdefined('attributes.event'))
	{
		/*<cfinclude template="../query/get_find_ship_js.cfm">*/
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['text'] = '#lang_array.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_ship_from_file&from_where=1";
	
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);

	}
	
	if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_dispatch_sale&ship_id=#attributes.ship_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'stock/query/upd_dispatch_ship.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'stock/query/upd_dispatch_ship.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_purchase';
		WOStruct['#attributes.fuseaction#']['del']['extraParams'] = 'active_period&process_cat&upd_id&old_process_type&del_ship&ship_number';
	}
	
	if(attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		/*<cfinclude template="../query/get_find_ship_js.cfm">*/
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1966]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['customTag'] = '<cf_get_workcube_related_acts period_id="#session.ep.period_id#" company_id="#session.ep.company_id#" asset_cat_id="-24" module_id="13" action_section="SHIP_ID" action_id="#attributes.ship_id#">';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[345]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=#listgetat(attributes.fuseaction,1,'.')#.upd_ship_dispatch&action_name=ship_id&action_id=#attributes.ship_id#&relation_papers_type=dispatch_ship','list')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '#lang_array_main.item[61]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_ship_history&ship_id=#attributes.ship_id#','project','popup_list_ship_history')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['text'] = '#lang_array.item[358]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_cost&id=#url.ship_id#&page_type=5&basket_id=#attributes.basket_id#','work')";
		if(fusebox.circuit eq "store")
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['text'] = '#lang_array_main.item[1040]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['onClick'] = "windowopen('#request.self#?fuseaction=store.popup_list_card_rows&action_id=#attributes.ship_id#&process_cat='+form_basket.old_process_type.value,'page')";
		}
		else
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['text'] = '#lang_array_main.item[1040]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.ship_id#&process_cat='+form_basket.old_process_type.value,'page')";

		}
		if(session.ep.our_company_info.guaranty_followup)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['text'] = '#lang_array_main.item[305]#-#lang_array_main.item[306]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_serial_operations&is_filtre=1&belge_no=#get_upd_purchase.ship_number#&process_cat_id=#get_upd_purchase.ship_type#&process_id=#attributes.UPD_ID#";
		}

	
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_ship_dispatch&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_ship_dispatch&ship_id=#attributes.ship_id#&is_ship_copy=1&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.ship_id#&print_type=30','page')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);

	}
	
	if(attributes.event is 'upd' or attributes.event is 'del')
	{
/*		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_dispatch_sale&upd_id=#url.ship_id#&event=del&active_period=17';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'stock/query/upd_dispatch_ship.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'stock/query/upd_dispatch_ship.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_purchase';
*/	}

	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'stockShipDispatch';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'SHIP';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-ship_date','item-process_cat','item-txt_departman_','item-department_in_txt','item-ship_number','item-project_head']";
</cfscript>
