<cf_get_lang_set module_name="invent">
<cf_xml_page_edit fuseact="invent.add_invent_sale">
<cfparam name="attributes.sale" default="1" >
<cfparam name="attributes.invoice_id" default="" >
<cfparam name="attributes.cari_action_type" default="">
<cfparam name="attributes.process_cat" default="">
<cfparam name="attributes.invoice_date" default="#now()#">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department_location" default="">
<cfparam name="attributes.note" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.acc_type_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.partner_id" default="">
<cfparam name="attributes.serial_number" default="">
<cfparam name="attributes.serial_no" default="">
<cfparam name="attributes.card_paymethod_id" default="">
<cfparam name="attributes.commission_rate" default="">
<cfparam name="attributes.pay_method" default="">
<cfparam name="attributes.paymethod" default="">
<cfparam name="attributes.PARTNER_ID" default="">
<cfparam name="attributes.COMPANY_PARTNER_NAME" default="">
<cfparam name="attributes.COMPANY_PARTNER_SURNAME" default="">
<cfparam name="attributes.SHIP_NUMBER" default="">
<cfparam name="attributes.due_date" default="#now()#">
<cfparam name="attributes.sale_emp" default="">
<cfparam name="attributes.ACC_DEPARTMENT_ID" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.SHIP_ADDRESS_ID" default="">
<cfparam name="attributes.SHIP_ADDRESS" default="">
<cfparam name="attributes.kasa_id" default="">
<cfparam name="attributes.INSTALLMENT_NUMBER" default="">
<cfparam name="attributes.CREDITCARD_ID" default="">
<cfparam name="attributes.DELAY_INFO" default="">
<cfparam name="attributes.closed_amount" default="">
<cfparam name="attributes.AMORTIZATION_COUNT" default="">
<cfparam name="attributes.SALE_COUNT" default="">
<cfparam name="attributes.upd_status" default="">
<cfparam name="attributes.recordcount" default="1">
<cfparam name="attributes.RATE2" default="">
<cfparam name="attributes.GROSSTOTAL" default="0">
<cfparam name="attributes.TAXTOTAL" default="0">
<cfparam name="attributes.OTV_TOTAL" default="0">
<cfparam name="attributes.stopaj_oran" default="">
<cfparam name="attributes.stopaj" default="">
<cfparam name="attributes.sa_discount" default="">
<cfparam name="attributes.NETTOTAL" default="0">
<cfparam name="attributes.OTHER_MONEY_VALUE" default="">
<cfparam name="attributes.tevkifat_id" default="">
<cfparam name="attributes.tevkifat_oran" default="">
<cfparam name="attributes.tevkifat" default="">
<cfparam name="attributes.INSTALLMENT_NUMBER" default="">
<cfparam name="attributes.action_id" default="">
<cfparam name="attributes.other_money" default="">
<cfparam name="attributes.STOPAJ_RATE_ID " default="">
<cfparam name="attributes.kur_say" default="">
<cfset variable = '1'>
<cfset variable1 = '67'>
<cfset variable2 = '69'>
<cfquery name="KASA" datasource="#dsn2#">
		SELECT * FROM CASH WHERE CASH_ACC_CODE IS NOT NULL ORDER BY CASH_NAME
	</cfquery>
	<cfquery name="GET_MONEY" datasource="#dsn#">
		SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = <cfqueryparam value="#variable#" cfsqltype="cf_sql_smallint">
	</cfquery>
	<cfset attributes.kur_say = GET_MONEY.recordcount>
<cfquery name="GET_INVOICE_MONEY" datasource="#DSN#">
    SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS = <cfqueryparam value="1" cfsqltype="cf_sql_smallint">
</cfquery>
	<cfquery name="GET_TAX" datasource="#dsn2#">
		SELECT * FROM SETUP_TAX ORDER BY TAX
	</cfquery>
	<cfquery name="GET_OTV" datasource="#DSN3#">
		SELECT TAX FROM SETUP_OTV WHERE PERIOD_ID = #session.ep.period_id# ORDER BY TAX
	</cfquery>
    <cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
		SELECT EXPENSE_ID,EXPENSE,EXPENSE_CODE FROM EXPENSE_CENTER ORDER BY EXPENSE
	</cfquery>
    <cfquery name="GET_STANDART_PROCESS_MONEY" datasource="#DSN#">
		SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = #session.ep.period_id#
	</cfquery>
	<cfif IsQuery(get_standart_process_money) and len(get_standart_process_money.standart_process_money)>
		<cfset selected_money = get_standart_process_money.standart_process_money>
	<cfelseif len(session.ep.money2)>
		<cfset selected_money = session.ep.money2>
	<cfelse>
		<cfset selected_money = session.ep.money>
	</cfif>
	<cfset attributes.other_money = selected_money>
<cfif not IsDefined("attributes.event") or attributes.event eq 'add'>
	<cfquery name="GET_SALE_DET" datasource="#dsn2#">
        SELECT 
            ACC_DEPARTMENT_ID
        FROM
            INVOICE
        WHERE
            INVOICE_CAT <> 67 AND
            INVOICE_CAT <> 69
    </cfquery>
    <cfquery name="get_einvoice_type" datasource="#DSN#" maxrows="1"><!---MCP tarafından #75351 numaralı iş için E-Fatura Kullanıp Kullanmadığı Kontrolü İçin kullanılacak. --->
         SELECT * FROM OUR_COMPANY_INFO WHERE COMP_ID = #session.ep.company_id#
    </cfquery>
    <cfquery name="get_standart_process_money" datasource="#dsn#"><!--- muhasebe doneminden standart islem dövizini alıyor --->
        SELECT 
            PERIOD_ID, 
            OUR_COMPANY_ID, 
            OTHER_MONEY, 
            STANDART_PROCESS_MONEY, 
            RECORD_DATE, 
            RECORD_IP, 
            RECORD_EMP, 
            UPDATE_DATE, 
            UPDATE_IP,
            UPDATE_EMP
        FROM 
            SETUP_PERIOD 
        WHERE 
            PERIOD_ID = #session.ep.period_id#
    </cfquery>
    <script type="text/javascript">
	record_exist=0;
	function add_adress()
	{
		if(!(document.getElementById('company_id').value=="") || !(document.getElementById('consumer_id').value=="") || !(document.getElementById('employee_id').value==""))
		{
			if(document.getElementById('company_id').value!="")
			{
				str_adrlink = '&field_long_adres=inventSale.adres&field_adress_id=inventSale.ship_address_id&is_compname_readonly=1';
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(inventSale.comp_name.value)+''+ str_adrlink , 'list');
				return true;
			}
			else
			{
				str_adrlink = '&field_long_adres=inventSale.adres&field_adress_id=inventSale.ship_address_id&is_compname_readonly=1';
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(inventSale.partner_name.value)+''+ str_adrlink , 'list');
				return true;
			}
		}
		else
		{
			alert('Cari Hesap Seçmelisiniz');
			return false;
		}
		return true;
	}
	function kontrol()
	{ 
		if(!paper_control(inventSale.serial_no,'INVOICE',true,'','','','','','',1,inventSale.serial_number)) return false;
		if(!chk_period(inventSale.invoice_date,"İşlem")) return false;
		if (!chk_process_cat('inventSale')) return false;
		if(!check_display_files('inventSale')) return false;
		if(document.all.department_id.value=="")
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='1351.Depo'>");
			return false;
		}
		<cfif xml_is_department eq 2>
			if(document.all.acc_department_id.options[document.all.acc_department_id.selectedIndex].value=="")
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='160.Departman'>");
				return false;
			} 
		</cfif>
		if(document.all.comp_name.value == "" && document.all.consumer_id.value == "" && document.all.emp_id.value == "")
		{ 
			alert ("<cf_get_lang_main no='782.Cari Hesap Seçmelisiniz'>!");
			return false;
		}
		   <cfif session.ep.our_company_info.IS_EFATURA eq 1 ><!--- MCP tarafından #75351 numaralı iş için eklendi.e-Fatura kullanıyorsa gösterilecek --->
		 	   url_= '/V16/inventory/cfc/inventSale.cfc?method=get_company_method';
              
              $.ajax({
                  type: "get",
                  url: url_,
                  data: {company_id: document.getElementById('company_id').value},
                  cache: false,
                  async: false,
                  success: function(read_data){
                      data_ = jQuery.parseJSON(read_data.replace('//',''));
                      if(data_.DATA.length != 0)
                      {
                          $.each(data_.DATA,function(i){
                              get_efatura_info=data_.DATA[i][0];                        
                              });
                      }
                  }
            });            

				if(get_efatura_info.USE_EFATURA == 1)															   
				{
					if(document.getElementById('ship_address_id').value =='' || document.getElementById('adres').value =='')
					{
						alert('Sevk Adresi Boş Geçilemez');
						return false;
					}
				}
		</cfif>
		process=document.all.process_cat.value;
		var get_process_cat = wrk_safe_query('acc_process_cat','dsn3',0,process);
		if(get_process_cat.IS_ACCOUNT ==1)
		{ 
			if (document.all.comp_name.value != "" && document.all.member_code.value=="")
			{ 
				alert("<cf_get_lang no='19.Seçtiğiniz Üyenin Muhasebe Kodu Seçilmemiş'>!");
				return false;
			}
		}	
		change_paper_duedate('invoice_date');
		for(r=1;r<=document.all.record_num.value;r++)
		{
			if(eval("document.all.row_kontrol"+r).value == 1)
			{
			record_exist=1;
				if (eval("document.all.invent_no"+r).value == "")
				{ 
					alert ("<cf_get_lang no='88.Lütfen Demirbaş No Giriniz'>!");
					return false;
				}
				if (eval("document.all.invent_name"+r).value == "")
				{ 
					alert ("<cf_get_lang no='93.Lütfen Açıklama Giriniz'> !");
					return false;
				}
				if ((eval("document.all.row_total"+r).value == ""))
				{ 
					alert ("<cf_get_lang_main no='1738.Lütfen Tutar Giriniz '>!");
					return false;
				}
				if ((eval("document.all.amortization_rate"+r).value == "")||(eval("document.all.amortization_rate"+r).value ==0))
				{ 
					alert ("<cf_get_lang no='95.Lütfen Amortisman Oranı Giriniz'> !");
					return false;
				}
				if (eval("document.all.account_code"+r).value == "")
				{ 
					alert ("<cf_get_lang no='96.Lütfen Muhasebe Kodu Seçiniz'>");
					return false;
				}
				if (eval("document.all.last_diff_value"+r).value != 0 && filterNum(eval("document.all.last_diff_value"+r).value) > 0 && eval("document.all.budget_account_code"+r).value == "")
				{ 
					alert ("<cf_get_lang no='65.Lütfen Gelir/Gider Farkı İçin Muhasebe Kodu Seçiniz'>!");
					return false;
				}
				if (eval("document.all.last_diff_value"+r).value != 0 && filterNum(eval("document.all.last_diff_value"+r).value) > 0 && eval("document.all.amort_account_code"+r).value == "")
				{ 
					alert ("<cf_get_lang no='64.Lütfen Amortisman Karşılık Muhasebe Kodu Seçiniz'>!");
					return false;
				}
			}
		}
		if (record_exist == 0) 
			{
				alert("<cf_get_lang no='90.Lütfen Demirbaş Giriniz'>!");
				return false;
			}
			unformat_fields();
			return true;
		}
	function unformat_fields()
	{
		for(r=1;r<=document.all.record_num.value;r++)
		{
			deger_total = eval("document.all.row_total"+r);
			deger_total2 = eval("document.all.row_total2"+r);
			deger_kdv_total= eval("document.all.kdv_total"+r);
			deger_otv_total= document.getElementById("otv_total"+r);
			deger_net_total = eval("document.all.net_total"+r);
			deger_other_net_total = eval("document.all.row_other_total"+r);
			deger_amortization_rate = eval("document.all.amortization_rate"+r);
			deger_unit_last= eval("document.all.unit_last_value"+r);
			total_deger_unit_last= eval("document.all.last_inventory_value"+r);
			deger_last_value= eval("document.all.last_diff_value"+r);
			deger_unit_first= eval("document.all.unit_first_value"+r);
			total_deger_unit_first= eval("document.all.total_first_value"+r);
			
			deger_total.value = filterNum(deger_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_total2.value = filterNum(deger_total2.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_kdv_total.value = filterNum(deger_kdv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_otv_total.value = filterNum(deger_otv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_net_total.value = filterNum(deger_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_other_net_total.value = filterNum(deger_other_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_amortization_rate.value = filterNum(deger_amortization_rate.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_unit_last.value = filterNum(deger_unit_last.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_last_value.value = filterNum(deger_last_value.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			total_deger_unit_last.value = filterNum(total_deger_unit_last.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_unit_first.value = filterNum(deger_unit_first.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			total_deger_unit_first.value = filterNum(total_deger_unit_first.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		}
		document.getElementById("total_amount").value = filterNum(document.getElementById("total_amount").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.all.kdv_total_amount.value = filterNum(document.all.kdv_total_amount.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("otv_total_amount").value = filterNum(document.getElementById("otv_total_amount").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>); 
		document.all.net_total_amount.value = filterNum(document.all.net_total_amount.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.all.other_total_amount.value = filterNum(document.all.other_total_amount.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.all.other_kdv_total_amount.value = filterNum(document.all.other_kdv_total_amount.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>); 
		document.getElementById("other_otv_total_amount").value = filterNum(document.getElementById("other_otv_total_amount").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>); 
		document.all.other_net_total_amount.value = filterNum(document.all.other_net_total_amount.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.all.net_total_discount.value = filterNum(document.all.net_total_discount.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.all.tevkifat_oran.value = filterNum(document.all.tevkifat_oran.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("stopaj_yuzde").value = filterNum(document.getElementById("stopaj_yuzde").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("stopaj").value = filterNum(document.getElementById("stopaj").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		for(s=1;s<=document.all.kur_say.value;s++)
		{
			eval('document.all.txt_rate2_' + s).value = filterNum(eval('document.all.txt_rate2_' + s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			eval('document.all.txt_rate1_' + s).value = filterNum(eval('document.all.txt_rate1_' + s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
	}
	row_count=0;
	satir_say=0;
	function sil(sy)
	{
		var my_element=document.getElementById("row_kontrol"+sy);
		my_element.value=0;
		var my_element=document.getElementById("frm_row"+sy);
		my_element.style.display="none";
		toplam_hesapla();
		satir_say--;
	}
	function clear_()
	{
		if(document.getElementById('employee').value=='')
		{
			document.getElementById('employee_id').value='';
		}
	}
	function hesapla(satir,hesap_type)
	{
		var toplam_dongu_0 = 0;//satir toplam
		if(eval("document.all.row_kontrol"+satir).value==1)
		{
			deger_total = eval("document.all.row_total"+satir);//tutar
			deger_total2 = eval("document.all.row_total2"+satir);//dövizli tutar
			deger_miktar = eval("document.all.quantity"+satir);//miktar
			deger_kdv_total= eval("document.all.kdv_total"+satir);//kdv tutarı
			deger_otv_total= document.getElementById("otv_total"+satir);//otv tutarı
			deger_net_total = eval("document.all.net_total"+satir);//kdvli tutar
			deger_tax_rate = eval("document.all.tax_rate"+satir);//kdv oranı
			deger_otv_rate = document.getElementById("otv_rate"+satir);//otv oranı
			deger_other_net_total = eval("document.all.row_other_total"+satir);//dovizli tutar kdv dahil
			deger_last_value = eval("document.all.last_inventory_value"+satir);//Son değer
			deger_last_unit_value = eval("document.all.unit_last_value"+satir);//Son değer birim
			deger_first_value = eval("document.all.total_first_value"+satir);//İlk değer
			deger_first_unit_value = eval("document.all.unit_first_value"+satir);//İlk değer birim
			deger_diff_value = eval("document.all.last_diff_value"+satir);//Fark
			if(deger_total.value == "") deger_total.value = 0;
			if(deger_kdv_total.value == "") deger_kdv_total.value = 0;
			if(deger_net_total.value == "") deger_net_total.value = 0;
			deger_money_id = eval("document.all.money_id"+satir);
			deger_money_id_ilk = list_getat(deger_money_id.value,2,',');
			deger_money_id_son = list_getat(deger_money_id.value,3,',');
			deger_total.value = filterNum(deger_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_total2.value = filterNum(deger_total2.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_kdv_total.value = filterNum(deger_kdv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_otv_total.value = filterNum(deger_otv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_net_total.value = filterNum(deger_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_other_net_total.value = filterNum(deger_other_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_miktar.value = filterNum(deger_miktar.value,0);
			deger_last_value.value = filterNum(deger_last_value.value);
			deger_last_unit_value.value = filterNum(deger_last_unit_value.value);
			deger_first_value.value = filterNum(deger_first_value.value);
			deger_first_unit_value.value = filterNum(deger_first_unit_value.value);
			deger_diff_value.value = filterNum(deger_diff_value.value);
			
			for(s=1;s<=inventSale.kur_say.value;s++)
			{
				if(list_getat(document.inventSale.rd_money[s-1].value,1,',') == list_getat(deger_money_id.value,1,','))
				{
                    satir_rate2 = filterNum(document.getElementById("txt_rate2_"+s).value,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>);
                    satir_rate1 = filterNum(document.getElementById("txt_rate1_"+s).value,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>);
				}
			}
			
			if(hesap_type ==undefined)
			{
				deger_total2.value = parseFloat(deger_total.value)*(parseFloat(satir_rate1)/parseFloat(satir_rate2));
				deger_otv_total.value = (parseFloat(deger_total.value) * deger_miktar.value * deger_otv_rate.value)/100;
				<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>  
					deger_kdv_total.value = ((parseFloat(deger_total.value) * parseFloat(deger_miktar.value)) * deger_tax_rate.value)/100;
				<cfelse>
					deger_kdv_total.value = ((parseFloat(deger_total.value* deger_miktar.value)+parseFloat(deger_otv_total.value)) * deger_tax_rate.value)/100;
				</cfif>
			}
			else if(hesap_type == 1)
			{
				deger_total.value = parseFloat(deger_total2.value)*(parseFloat(satir_rate2)/parseFloat(satir_rate1));
				deger_otv_total.value = (parseFloat(deger_total.value) * deger_miktar.value * deger_otv_rate.value)/100;
				<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>  
					deger_kdv_total.value = ((parseFloat(deger_total.value) * parseFloat(deger_miktar.value)) * deger_tax_rate.value)/100;
				<cfelse>
					deger_kdv_total.value = ((parseFloat(deger_total.value* deger_miktar.value)+parseFloat(deger_otv_total.value)) * deger_tax_rate.value)/100;
				</cfif>
			}
			else if(hesap_type == 2)
			{
				<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>  
					deger_total.value = ((parseFloat(deger_net_total.value)/parseFloat(deger_miktar.value))*100)/ (parseFloat(deger_tax_rate.value)+parseFloat(otv_rate_)+100);
					deger_kdv_total.value = (parseFloat(deger_total.value * deger_miktar.value * deger_tax_rate.value))/100;
					deger_otv_total.value = (parseFloat(deger_total.value * deger_miktar.value * deger_otv_rate.value))/100;
				<cfelse>
					deger_total.value = ((parseFloat(deger_net_total.value)*100)/ (parseFloat(deger_tax_rate.value)+100))/deger_miktar.value;
					deger_otv_total.value = (parseFloat(deger_total.value * deger_miktar.value * deger_otv_rate.value))/100;
					deger_kdv_total.value = ((parseFloat(deger_total.value * deger_miktar.value)+parseFloat(deger_otv_total.value)) * deger_tax_rate.value)/100;
				</cfif>
					deger_total2.value = parseFloat(deger_total.value)*(parseFloat(satir_rate1)/parseFloat(satir_rate2));
			}
			else if(hesap_type == 3)
			{
				<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>
					deger_kdv_total.value = (parseFloat(deger_net_total.value * deger_tax_rate.value))/(100 + parseFloat(deger_tax_rate.value)+ parseFloat(deger_otv_rate.value));
					deger_otv_total.value = (parseFloat(deger_net_total.value * deger_otv_rate.value))/(100 + parseFloat(deger_tax_rate.value)+ parseFloat(deger_otv_rate.value));
				<cfelse>
					deger_kdv_total.value = (parseFloat(deger_net_total.value * deger_tax_rate.value))/(100 + parseFloat(deger_tax_rate.value));
					deger_otv_total.value = (parseFloat((deger_net_total.value - deger_kdv_total.value) * deger_otv_rate.value))/(100 + parseFloat(deger_otv_rate.value));
				</cfif>
					deger_total.value = parseFloat(deger_net_total.value - deger_kdv_total.value);
					deger_total.value = parseFloat(deger_total.value - deger_otv_total.value);
					deger_total.value = (deger_total.value/deger_miktar.value);
					deger_total2.value = parseFloat(deger_total.value)*(parseFloat(satir_rate1)/parseFloat(satir_rate2));
			}
			else if(hesap_type == 4)
			{
				for(s=1;s<=inventSale.kur_say.value;s++)
				{
					if(list_getat(document.inventSale.rd_money[s-1].value,1,',') == list_getat(deger_money_id.value,1,','))
					{
						satir_rate2 = filterNum(document.getElementById("txt_rate2_"+s).value);
						satir_rate1 = document.getElementById("txt_rate1_"+s).value;
					}
				}
				deger_net_total.value = parseFloat(deger_other_net_total.value) * (parseFloat(satir_rate2)/parseFloat(satir_rate1));
				
				<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>
					deger_kdv_total.value = (parseFloat(deger_net_total.value * deger_tax_rate.value))/(100 + parseFloat(deger_tax_rate.value)+ parseFloat(deger_otv_rate.value));
					deger_otv_total.value = (parseFloat(deger_net_total.value * deger_otv_rate.value))/(100 + parseFloat(deger_tax_rate.value)+ parseFloat(deger_otv_rate.value));
				<cfelse>
					deger_kdv_total.value = (parseFloat(deger_net_total.value * deger_tax_rate.value))/(100 + parseFloat(deger_tax_rate.value));
					deger_otv_total.value = (parseFloat((deger_net_total.value - deger_kdv_total.value) * deger_otv_rate.value))/(100 + parseFloat(deger_otv_rate.value));
				</cfif>
					deger_total.value = parseFloat(deger_net_total.value - deger_kdv_total.value);
					deger_total.value = parseFloat(deger_total.value - deger_otv_total.value);
					deger_total.value = (deger_total.value/deger_miktar.value);
					deger_total2.value = parseFloat(deger_total.value)*(parseFloat(satir_rate1)/parseFloat(satir_rate2));
			}
            toplam_dongu_0 = (parseFloat(deger_total.value)*deger_miktar.value) + parseFloat(deger_kdv_total.value) + parseFloat(deger_otv_total.value);
            deger_other_net_total.value = ((parseFloat(deger_total.value) + parseFloat(deger_kdv_total.value) + parseFloat(deger_otv_total.value)) * parseFloat(deger_money_id_ilk) / (parseFloat(deger_money_id_son)));
			deger_net_total.value = commaSplit(toplam_dongu_0,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_last_value.value =  parseFloat(deger_last_unit_value.value * deger_miktar.value);
			deger_first_value.value =  parseFloat(deger_first_unit_value.value * deger_miktar.value);
			deger_diff_value.value = parseFloat((deger_total.value * deger_miktar.value)  - deger_last_value.value);
			deger_diff_value.value = commaSplit(deger_diff_value.value);
			deger_last_value.value = commaSplit(deger_last_value.value);
			deger_last_unit_value.value = commaSplit(deger_last_unit_value.value);
			deger_first_value.value = commaSplit(deger_first_value.value);
			deger_first_unit_value.value = commaSplit(deger_first_unit_value.value);
			deger_total.value = commaSplit(deger_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_total2.value = commaSplit(deger_total2.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_kdv_total.value = commaSplit(deger_kdv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_otv_total.value = commaSplit(deger_otv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_other_net_total.value = commaSplit(deger_other_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		}
		toplam_hesapla();
	}
	function calc_stopaj()
	{
		if((parseFloat(document.getElementById("stopaj_yuzde").value) < 0) || (parseFloat(document.getElementById("stopaj_yuzde").value) > 99.99))
		{
			alert('Stopaj Oranı !');
			document.getElementById("stopaj_yuzde").value = 0;
		}
		toplam_hesapla(0);
	}
	function toplam_hesapla(type)
	{
		var toplam_dongu_1 = 0;//tutar genel toplam
		var toplam_dongu_2 = 0;// kdv genel toplam
		var toplam_dongu_3 = 0;// kdvli genel toplam
		var toplam_dongu_4 = 0;// kdvli genel toplam
		var toplam_dongu_5 = 0;// ötv genel toplam
		var beyan_tutar = 0;
		var tevkifat_info = "";
		var beyan_tutar_info = "";
		var new_taxArray = new Array(0);
		var taxBeyanArray = new Array(0);
		var taxTevkifatArray = new Array(0);
		for(r=1;r<=document.all.record_num.value;r++)
		{
			if(eval("document.all.row_kontrol"+r).value==1)
			{
				toplam_dongu_4 = toplam_dongu_4 + (parseFloat(filterNum(eval("document.all.row_total"+r).value) * filterNum(eval("document.all.quantity"+r).value)));
			}
		}			
		genel_indirim_yuzdesi = commaSplit(parseFloat(document.all.net_total_discount.value) / parseFloat(toplam_dongu_4),8);
		genel_indirim_yuzdesi = filterNum(genel_indirim_yuzdesi,8);
		genel_indirim_yuzdesi = wrk_round(genel_indirim_yuzdesi,2);
		deger_discount_value = document.all.net_total_discount.value;
		deger_discount_value = filterNum(deger_discount_value,4);
	
		for(r=1;r<=document.all.record_num.value;r++)
		{
			if(eval("document.all.row_kontrol"+r).value==1)
			{
				deger_total = eval("document.all.row_total"+r);//tutar
				deger_total2 = eval("document.all.row_total2"+r);//dövizli tutar
				deger_miktar = eval("document.all.quantity"+r);//miktar
				deger_kdv_total= eval("document.all.kdv_total"+r);//kdv tutarı
				deger_otv_total= document.getElementById("otv_total"+r);//ötv tutarı
				deger_net_total = eval("document.all.net_total"+r);//kdvli tutar
				deger_tax_rate = eval("document.all.tax_rate"+r);//kdv oranı
				deger_other_net_total = eval("document.all.row_other_total"+r);//dovizli tutar kdv dahil
				deger_money_id = eval("document.all.money_id"+r);
				deger_money_id_ilk = list_getat(deger_money_id.value,1,',');
				for(s=1;s<=document.all.kur_say.value;s++)
					{
						if(list_getat(document.all.rd_money[s-1].value,1,',') == deger_money_id_ilk)
						{
							satir_rate2= eval("document.all.txt_rate2_"+s).value;
						}
					}
				satir_rate2= filterNum(satir_rate2,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');	
				deger_miktar.value = filterNum(deger_miktar.value,0);		
				deger_total.value = filterNum(deger_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_total2.value = filterNum(deger_total2.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_kdv_total.value = filterNum(deger_kdv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_otv_total.value = filterNum(deger_otv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_net_total.value = filterNum(deger_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_other_net_total.value = filterNum(deger_other_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				toplam_dongu_1 = toplam_dongu_1 + parseFloat(deger_total.value * deger_miktar.value);
                deger_other_net_total.value = ((parseFloat(deger_total.value * deger_miktar.value) + parseFloat(deger_kdv_total.value) + parseFloat(deger_otv_total.value)) / (parseFloat(satir_rate2)));
				toplam_dongu_2 = toplam_dongu_2 + parseFloat(deger_kdv_total.value)- parseFloat(deger_kdv_total.value*genel_indirim_yuzdesi);
				toplam_dongu_5 = toplam_dongu_5 + parseFloat(deger_otv_total.value);
				deger_indirim_kdv = parseFloat(deger_kdv_total.value)- parseFloat(deger_kdv_total.value*genel_indirim_yuzdesi);
				toplam_dongu_3 = toplam_dongu_3 + ((parseFloat(deger_total.value)- (parseFloat(deger_total.value)*genel_indirim_yuzdesi)) * deger_miktar.value);
				toplam_dongu_3 = toplam_dongu_3 + parseFloat(deger_kdv_total.value)- parseFloat(deger_kdv_total.value*genel_indirim_yuzdesi);
				toplam_dongu_3 = toplam_dongu_3 + parseFloat(deger_otv_total.value);
				
				if(document.all.tevkifat_oran != undefined && document.all.tevkifat_oran.value != "" && document.all.tevkifat_box.checked == true)
				{//tevkifat hesaplamaları
					beyan_tutar = beyan_tutar + wrk_round(deger_indirim_kdv*filterNum(document.all.tevkifat_oran.value));
					if(new_taxArray.length != 0)
						for (var m=0; m < new_taxArray.length; m++)
						{	
							var tax_flag = false;
							if(new_taxArray[m] == deger_tax_rate.value){
								tax_flag = true;
								taxBeyanArray[m] += wrk_round(deger_indirim_kdv - (deger_indirim_kdv*(filterNum(document.all.tevkifat_oran.value))));
								taxTevkifatArray[m] += wrk_round(deger_indirim_kdv*(filterNum(document.all.tevkifat_oran.value)));
								break;
							}
						}
					if(!tax_flag){
						new_taxArray[new_taxArray.length] = deger_tax_rate.value;
						taxBeyanArray[taxBeyanArray.length] = wrk_round(deger_indirim_kdv - (deger_indirim_kdv*(filterNum(document.all.tevkifat_oran.value))));
						taxTevkifatArray[taxTevkifatArray.length] = wrk_round(deger_indirim_kdv*(filterNum(document.all.tevkifat_oran.value)));
					}
				}
				deger_net_total.value = commaSplit(deger_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_total.value = commaSplit(deger_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_total2.value = commaSplit(deger_total2.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_kdv_total.value = commaSplit(deger_kdv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_otv_total.value = commaSplit(deger_otv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_other_net_total.value = commaSplit(deger_other_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			}
		}	
		if(document.all.tevkifat_oran != undefined && document.all.tevkifat_oran.value != "" && document.all.tevkifat_box.checked == true)
		{	//tevkifat hesaplamaları
			toplam_dongu_3 = toplam_dongu_3 - toplam_dongu_2 + beyan_tutar;
			toplam_dongu_2 = beyan_tutar;
			tevkifat_text.style.fontWeight = 'bold';
			tevkifat_text.innerHTML = '';
			beyan_text.style.fontWeight = 'bold';
			beyan_text.innerHTML = '';
			for (var tt=0; tt < new_taxArray.length; tt++)
			{
				tevkifat_text.innerHTML += '% ' + new_taxArray[tt] + ' : ' + commaSplit(taxBeyanArray[tt],4) + ' ';
				beyan_text.innerHTML += '% ' + new_taxArray[tt] + ' : ' + commaSplit(taxTevkifatArray[tt],4) + ' ';
			}
		}	
		if(type == undefined || parseFloat(document.getElementById("stopaj_yuzde").value) != 0)
			stopaj_ = wrk_round((toplam_dongu_1 * parseFloat(document.getElementById("stopaj_yuzde").value) / 100),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		else
			stopaj_ = filterNum(document.getElementById("stopaj").value);
		document.getElementById("stopaj_yuzde").value = commaSplit(parseFloat(document.getElementById("stopaj_yuzde").value));
		document.getElementById("stopaj").value = commaSplit(stopaj_,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		toplam_dongu_3 = toplam_dongu_3-parseFloat(stopaj_);
		//stopajlar hesaplandi
		document.all.total_amount.value = commaSplit(toplam_dongu_1,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.all.kdv_total_amount.value = commaSplit(toplam_dongu_2,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("otv_total_amount").value = commaSplit(toplam_dongu_5,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>); 
		document.all.net_total_amount.value = commaSplit(toplam_dongu_3,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		for(s=1;s<=document.all.kur_say.value;s++)
		{
			form_txt_rate2_ = eval("document.all.txt_rate2_"+s);
			if(form_txt_rate2_.value == "")
				form_txt_rate2_.value = 1;
		}
		if(document.all.kur_say.value == 1)
			for(s=1;s<=document.all.kur_say.value;s++)
			{
				if(document.all.rd_money.checked == true)
				{
					deger_diger_para = document.all.rd_money;
					form_txt_rate2_ = eval("document.all.txt_rate2_"+s);
				}
			}
		else 
			for(s=1;s<=document.all.kur_say.value;s++)
			{
				if(document.all.rd_money[s-1].checked == true)
				{
					deger_diger_para = document.all.rd_money[s-1];
					form_txt_rate2_ = eval("document.all.txt_rate2_"+s);
				}
			}
		deger_money_id_1 = list_getat(deger_diger_para.value,1,',');
		deger_money_id_3 = list_getat(deger_diger_para.value,3,',');
		form_txt_rate2_.value = filterNum(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.all.other_total_amount.value = commaSplit(toplam_dongu_1 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.all.other_kdv_total_amount.value = commaSplit(toplam_dongu_2 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>); 
		document.getElementById("other_otv_total_amount").value = commaSplit(toplam_dongu_5 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.all.other_net_total_amount.value = commaSplit(toplam_dongu_3 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.all.other_net_total_discount.value = commaSplit(deger_discount_value* parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.all.net_total_discount.value = commaSplit(deger_discount_value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
	
		document.all.tl_value1.value = deger_money_id_1;
		document.all.tl_value2.value = deger_money_id_1;				//kdv
		document.getElementById("tl_value5").value = deger_money_id_1;	//otv
		document.all.tl_value3.value = deger_money_id_1;
		document.all.tl_value4.value = deger_money_id_1;
		form_txt_rate2_.value = commaSplit(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	}
	function gonder(invent_id,invent_name,invent_no,quantity,acc_id,amort_rate,amortizaton_method,unit_last_value,last_inventory_value,unit_first_value,total_first_value,last_diff_value,expense_center_id,expense_center_name,budget_item_id,budget_item_name,debt_account_id,claim_account_id,product_id,product_name,product_unit_id,stock_id,product_unit)
	{
		if(invent_name.indexOf('"') > -1)
			invent_name = invent_name.replace(/"/g,'');
		if(invent_name.indexOf("'") > -1)
			invent_name = invent_name.replace(/'/g,'');
		row_count++;
		satir_say++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);		
		newRow.className = 'color-row';
		document.getElementById("record_num").value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		x = '<input type="hidden" value="WRK'+row_count+ js_create_unique_id() + row_count+'" id="wrk_row_id' + row_count +'" name="wrk_row_id' + row_count +'"><input  type="hidden" value="" id="wrk_row_relation_id' + row_count +'" name="wrk_row_relation_id' + row_count +'">';
		newCell.innerHTML = x + '<input  type="hidden" value="1" id="row_kontrol' + row_count +'" name="row_kontrol' + row_count +'" ><a href="javascript://" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" id="invent_id' + row_count +'" name="invent_id' + row_count +'" value="'+ invent_id +'" readonly><input type="text" id="invent_no' + row_count +'" name="invent_no' + row_count +'" style="width:100%;" class="boxtext" value="'+ invent_no +'" maxlength="50">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" readonly id="invent_name' + row_count +'" name="invent_name' + row_count +'" style="width:100px;" class="boxtext" value="'+ invent_name + '" maxlength="100">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=document.getElementById("invent_name"+satir_say).value;	
		newCell.innerHTML = '<input type="text" id="quantity' + row_count +'" name="quantity' + row_count +'" style="width:100%;" class="box" value="'+ quantity +'" onBlur="hesapla(' + row_count +');" onkeyup="return(FormatCurrency(this,event));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=document.getElementById("invent_name"+satir_say).value;	
		newCell.innerHTML = '<input type="text" id="row_total' + row_count +'" name="row_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" onBlur="hesapla(' + row_count +');" style="width:100%;" class="box">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=document.getElementById("invent_name"+satir_say).value;	
		newCell.innerHTML = '<input type="text" id="row_total2' + row_count +'" name="row_total2' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" onBlur="hesapla(' + row_count +',1);" style="width:100%;" class="box">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=document.getElementById("invent_name"+satir_say).value;
		newCell.innerHTML = '<select id="tax_rate'+ row_count +'" name="tax_rate'+ row_count +'" style="width:100%;" onChange="hesapla('+ row_count +');" class="box"><cfoutput query="get_tax"><option value="#tax#">#tax#</option></cfoutput></select>';
		//otv orani
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<select id="otv_rate'+ row_count +'" name="otv_rate'+ row_count +'" style="width:100%;" onChange="hesapla('+ row_count +');" class="box"><cfoutput query="get_otv"><option value="#tax#">#tax#</option></cfoutput></select>';
		//kdv total
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=document.getElementById("invent_name"+satir_say).value;	
		newCell.innerHTML = '<input type="text" id="kdv_total' + row_count +'" name="kdv_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" style="width:60px;" onBlur="hesapla(' + row_count +',1);" class="box">';
		//otv total
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=document.getElementById("invent_name"+satir_say).value;	
		newCell.innerHTML = '<input type="text" id="otv_total' + row_count +'" name="otv_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" style="width:60px;" onBlur="hesapla(' + row_count +',1);" class="box">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=document.getElementById("invent_name"+satir_say).value;	
        newCell.innerHTML = '<input type="text" id="net_total' + row_count +'" name="net_total' + row_count +'" value="0" style="width:100%;" class="box" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" onblur="hesapla(' + row_count +',3);">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=document.getElementById("invent_name"+satir_say).value;	
        newCell.innerHTML = '<input type="text" id="row_other_total' + row_count +'" name="row_other_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" style="width:100%;" class="box" onblur="hesapla(' + row_count +',4);">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=document.getElementById("invent_name"+satir_say).value;	
		newCell.innerHTML = '<select id="money_id' + row_count  +'" name="money_id' + row_count  +'" style="width:100%;" class="boxtext" onChange="hesapla('+ row_count +');"><cfoutput query="get_money"><option value="#money#,#rate1#,#rate2#" <cfif money eq session.ep.money>selected</cfif>>#money#</option></cfoutput></select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=document.getElementById("invent_name"+satir_say).value;	
		newCell.innerHTML = '<input type="text" id="amortization_rate' + row_count +'" name="amortization_rate' + row_count +'" value="'+ amort_rate +'" style="width:100%;" class="box" onkeyup="return(FormatCurrency(this,event));" readonly="yes">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=document.getElementById("invent_name"+satir_say).value;
		if(amortizaton_method == 0)
			newCell.innerHTML = '<input type="text" id="amortization_method'+ row_count +'" readonly name="amortization_method'+ row_count +'" style="width:165px;" class="boxtext" value="<cf_get_lang_main no="1624.Azalan Bakiye Üzerinden">">';
		else if(amortizaton_method == 1)
			newCell.innerHTML = '<input type="text" id="amortization_method'+ row_count +'" readonly name="amortization_method'+ row_count +'" style="width:165px;" class="boxtext" value="<cf_get_lang_main no="1625.Sabit Miktar Üzeriden">">';
		else if(amortizaton_method == 2)
			newCell.innerHTML = '<input type="text" id="amortization_method'+ row_count +'" readonly name="amortization_method'+ row_count +'" style="width:165px;" class="boxtext" value="<cf_get_lang_main no="1626.Hızlandırılmış Azalan Bakiye">">';	
		else
			newCell.innerHTML = '<input type="text" readonly name="amortization_method'+ row_count +'" style="width:165px;" class="boxtext" value="<cf_get_lang_main no="1627.Hızlandırılmış Sabit Değer">">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=document.getElementById("invent_name"+satir_say).value;
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input  type="hidden" id="account_id' + row_count +'" name="account_id' + row_count +'"  value="'+ acc_id +'"><input type="text" name="account_code' + row_count +'"  id="account_code' + row_count +'" value="'+ acc_id +'" class="boxtext" onFocus="autocomp_account('+row_count+');"><a href="javascript://"onclick="pencere_ac_acc('+ row_count +');" ><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=document.getElementById("invent_name"+satir_say).value;	
		newCell.innerHTML = '<input type="hidden" id="unit_last_value' + row_count +'" name="unit_last_value' + row_count +'" value="'+ unit_last_value +'"><input type="hidden" name="unit_first_value' + row_count +'" value="'+ unit_first_value +'"><input type="hidden" id="total_first_value' + row_count +'" name="total_first_value' + row_count +'" value="'+ total_first_value +'"><input type="text" id="last_inventory_value' + row_count +'" name="last_inventory_value' + row_count +'" value="'+ last_inventory_value +'" style="width:100%;" class="box" onkeyup="return(FormatCurrency(this,event));" readonly="yes">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=document.getElementById("invent_name"+satir_say).value;	
		newCell.innerHTML = '<input type="text" id="last_diff_value' + row_count +'" name="last_diff_value' + row_count +'" value="'+last_diff_value+'" style="width:100%;" class="box" onkeyup="return(FormatCurrency(this,event));" readonly="yes">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.title=document.getElementById("invent_name"+satir_say).value;	
		newCell.innerHTML ='<input type="hidden" name="expense_center_id' + row_count +'" value="'+expense_center_id+'" id="expense_center_id' + row_count +'"><input type="text" id="expense_center_name' + row_count +'" name="expense_center_name' + row_count +'" onFocus="exp_center('+row_count+');" value="'+expense_center_name+'" style="width:150px;" class="boxtext"><a href="javascript://" onClick="pencere_ac_exp_center('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=document.getElementById("invent_name"+satir_say).value;	
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input  type="hidden" name="budget_item_id' + row_count +'" id="budget_item_id' + row_count +'" value='+budget_item_id+'><input type="text" style="width:115px;" name="budget_item_name' + row_count +'" id="budget_item_name' + row_count +'" class="boxtext" value="'+budget_item_name+'" onFocus="exp_item('+row_count+');"><a href="javascript://"><img src="/images/plus_thin.gif" onclick="pencere_ac_exp('+ row_count +');" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=document.getElementById("invent_name"+satir_say).value;
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input  type="hidden" name="budget_account_id' + row_count +'" id="budget_account_id' + row_count +'" value="'+debt_account_id+'"><input type="text" name="budget_account_code' + row_count +'" id="budget_account_code' + row_count +'"  value="'+debt_account_id+'" class="boxtext" style="width:155px;" onFocus="autocomp_budget_account('+row_count+');"><a href="javascript://"onclick="pencere_ac_acc_1('+ row_count +');" ><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=document.getElementById("invent_name"+satir_say).value;
		newCell.setAttribute("nowrap","nowrap");	
		newCell.innerHTML = '<input  type="hidden" name="amort_account_id' + row_count +'" id="amort_account_id' + row_count +'" value="'+claim_account_id+'"><input type="text" name="amort_account_code' + row_count +'" id="amort_account_code' + row_count +'"  value="'+claim_account_id+'" class="boxtext" style="width:205px;" onFocus="autocomp_amort_account('+row_count+');"><a href="javascript://"onclick="pencere_ac_acc_2('+ row_count +');" ><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=document.getElementById("invent_name"+satir_say).value;
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input  type="hidden" id="product_id' + row_count +'" name="product_id' + row_count +'" value="'+product_id+'"><input id="stock_id' + row_count +'" type="hidden" name="stock_id' + row_count +'" value="'+stock_id+'"><input type="text" id="product_name' + row_count +'" name="product_name' + row_count +'" class="boxtext" value="'+product_name+'" onFocus="AutoComplete_Create(\'product_name' + row_count +'\',\'PRODUCT_NAME\',\'PRODUCT_NAME,STOCK_CODE\',\'get_product_autocomplete\',\'0\',\'PRODUCT_ID,STOCK_ID,MAIN_UNIT,PRODUCT_UNIT_ID\',\'product_id' + row_count +',stock_id' + row_count +',stock_unit' + row_count  +',stock_unit_id' + row_count  +'\',\'inventSale\',1,\'\',\'\');">'
							+'<a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&product_id=product_id" + row_count + "&field_id=stock_id" + row_count + "&field_unit_name=stock_unit" + row_count + "&field_main_unit=stock_unit_id" + row_count + "&field_name=product_name" + row_count + "','list');"+'"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=document.getElementById("invent_name"+satir_say).value;
		newCell.innerHTML = '<input type="hidden" id="stock_unit_id' + row_count +'" name="stock_unit_id' + row_count +'" value="'+product_unit_id+'"><input type="text" name="stock_unit' + row_count +'" id="stock_unit' + row_count +'" style="width:100%;" class="boxtext">';
	}
	/* masraf merkezi popup */
	function pencere_ac_exp_center(no)
	{ 
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=inventSale.expense_center_id' + no +'&field_name=inventSale.expense_center_name' + no,'list');
	}
	/* masraf merkezi autocomplete */
	function exp_center(no)
	{
		AutoComplete_Create("expense_center_name" + no,"EXPENSE,EXPENSE_CODE","EXPENSE,EXPENSE_CODE","get_expense_center","","EXPENSE_ID","expense_center_id"+no,"",3);
	}
	/* gider kalemi autocomplete */
	function exp_item(no)
	{
		AutoComplete_Create("budget_item_name" + no,"EXPENSE_ITEM_NAME","EXPENSE_ITEM_NAME","get_expense_item","","EXPENSE_ITEM_ID,ACCOUNT_CODE","budget_item_id"+no+",budget_account_code"+no,"",3);
	}
	function autocomp_account(no)
	{
		AutoComplete_Create("account_code"+no,"ACCOUNT_CODE,ACCOUNT_NAME","ACCOUNT_CODE,ACCOUNT_NAME","get_account_code","0","ACCOUNT_CODE","account_id"+no,"",3);
	}
	function autocomp_budget_account(no)
	{
		AutoComplete_Create("budget_account_code"+no,"ACCOUNT_CODE,ACCOUNT_NAME","ACCOUNT_CODE,ACCOUNT_NAME","get_account_code","0","ACCOUNT_CODE","budget_account_id"+no,"",3);
	}
	function autocomp_amort_account(no)
	{
		AutoComplete_Create("amort_account_code"+no,"ACCOUNT_CODE,ACCOUNT_NAME","ACCOUNT_CODE,ACCOUNT_NAME","get_account_code","0","ACCOUNT_CODE","amort_account_id"+no,"",3);
	}
	function pencere_ac_acc(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=account_id' + no +'&field_name=account_code' + no +'','list');
	}
	function pencere_ac_acc_1(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=budget_account_id' + no +'&field_name=budget_account_code' + no +'','list');
	}
	function pencere_ac_acc_2(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=amort_account_id' + no +'&field_name=amort_account_code' + no +'','list');
	}
	function pencere_ac_exp(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=budget_item_id' + no +'&field_name=budget_item_name' + no +'&field_account_no=budget_account_code' + no +'&field_account_no2=budget_account_id' + no +'','list');
	}
	function pencere_ac_stock(no)
	{
		if(document.all.branch_id.value == '')
		{
			alert("<cf_get_lang_main no='311.Önce depo seçmelisiniz'>!");
			return false;
		}
		if(document.all.company_id.value.length==0)
		{ 
			alert("<cf_get_lang_main no='303.Önce Üye Seçiniz'>!");
			return false;
		}
		if(document.all.company_id!=undefined && document.all.company_id.value.length)
			windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_products&company_id='+document.all.company_id.value+'&int_basket_id=1&is_sale_product=0&update_product_row_id=0</cfoutput>','list');
	}
	function ayarla_gizle_goster()
	{
		if(document.all.cash.checked)
			kasa2.style.display='';
		else
			kasa2.style.display='none';
	}
	
	function f_add_invent()
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_inventory&field_id=invent_id&is_sale=1','wide');
	}
	
	function change_paper_duedate(field_name,type,is_row_parse) 
	{
		paper_date_=eval('document.all.invoice_date.value');
		if(type!=undefined && type==1)
			document.all.basket_due_value.value = datediff(paper_date_,document.all.basket_due_value_date_.value,0);
		else
		{
			if(isNumber(document.all.basket_due_value)!= false && (document.all.basket_due_value.value != 0))
				document.all.basket_due_value_date_.value = date_add('d',+document.all.basket_due_value.value,paper_date_);
			else
			{
				document.all.basket_due_value_date_.value =paper_date_;
				if(document.all.basket_due_value.value == '')
					document.all.basket_due_value.value = datediff(paper_date_,document.all.basket_due_value_date_.value,0);
			}
		}
	}
	function change_acc_all()
	{
		var loopcount=document.getElementById('record_num').value;	
		if(loopcount>0)
		{
			for(var i=1;i<=loopcount;++i)
			{
				document.getElementById('account_id'+i).value = document.getElementById('account_id_all').value;
				document.getElementById('account_code'+i).value = document.getElementById('account_code_all').value;
			}
		}
	}
	function change_budget_acc_all()
	{
		var loopcount=document.getElementById('record_num').value;	
		if(loopcount>0)
		{
			for(var i=1;i<=loopcount;++i)
			{
				document.getElementById('budget_account_id'+i).value = document.getElementById('budget_account_id_all').value;
				document.getElementById('budget_account_code'+i).value = document.getElementById('budget_account_code_all').value;
			}
		}
	}
	function change_exp_all()
	{
		var loopcount=document.getElementById('record_num').value;	
		if(loopcount>0)
		{
			for(var i=1;i<=loopcount;++i)
			{
				document.getElementById('budget_item_id'+i).value = document.getElementById('budget_item_id_all').value;
				document.getElementById('budget_item_name'+i).value = document.getElementById('budget_item_name_all').value;
				document.getElementById('budget_account_id'+i).value = document.getElementById('budget_account_id_all').value;
				document.getElementById('budget_account_code'+i).value = document.getElementById('budget_account_code_all').value;
			}
		}
	}
	function change_amort_all()
	{
		var loopcount=document.getElementById('record_num').value;	
		if(loopcount>0)
		{
			for(var i=1;i<=loopcount;++i)
			{
				document.getElementById('amort_account_id'+i).value = document.getElementById('amort_account_id_all').value;
				document.getElementById('amort_account_code'+i).value = document.getElementById('amort_account_code_all').value;
			}
		}
	}
	function change_expense_center()
	{
		var loopcount=document.getElementById('record_num').value;
		if(loopcount>0)
		{
			for(var i=1;i<=loopcount;++i)
			{
				document.getElementById('expense_center_id'+i).value = document.getElementById('expense_center_id_all').value;
				document.getElementById('expense_center_name'+i).value = document.getElementById('main_exp_center_name_all').value;
			}
		}
	}
</script>
</cfif>

<cfif  IsDefined("attributes.event") and attributes.event eq 'upd'>
	<cfif isDefined("attributes.ship_id")>
		<cfquery name="GET_SHIP" datasource="#dsn2#">
            SELECT SHIP_NUMBER,INVOICE_ID FROM INVOICE_SHIPS WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id#"> AND SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> 
        </cfquery>
        <cfset attributes.invoice_id = GET_SHIP.INVOICE_ID>
    <cfelse>
        <cfquery name="GET_SHIP" datasource="#dsn2#">
            SELECT SHIP_NUMBER FROM INVOICE_SHIPS WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> 
        </cfquery>
    </cfif>
    <cfif GET_SHIP.recordcount neq 0>
    	<cfquery name="GET_SALE_MONEY" datasource="#dsn2#">
            SELECT RATE2,MONEY_TYPE FROM INVOICE_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND IS_SELECTED=<cfqueryparam value="#variable#" cfsqltype="cf_sql_smallint">
        </cfquery>
        <cfif not GET_SALE_MONEY.recordcount>
            <cfquery name="GET_SALE_MONEY" datasource="#DSN#">
                SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS=<cfqueryparam value="#variable#" cfsqltype="cf_sql_smallint">
            </cfquery>
        </cfif>
        <cfquery name="GET_INVOICE" datasource="#dsn2#">
            SELECT 
                INVOICE.*,
                CASE
                    WHEN COMPANY.COMPANY_ID IS NOT NULL THEN COMPANY.USE_EFATURA
                    WHEN CONSUMER.CONSUMER_ID IS NOT NULL THEN CONSUMER.USE_EFATURA
                END AS 
                    USE_EFATURA,
                SPC.INVOICE_TYPE_CODE
            FROM 
                INVOICE
                    LEFT JOIN #dsn_alias#.COMPANY ON COMPANY.COMPANY_ID = INVOICE.COMPANY_ID AND COMPANY.USE_EFATURA = 1 AND COMPANY.EFATURA_DATE <= INVOICE.INVOICE_DATE
                    LEFT JOIN #dsn_alias#.CONSUMER ON CONSUMER.CONSUMER_ID = INVOICE.CONSUMER_ID AND CONSUMER.USE_EFATURA = 1 AND CONSUMER.EFATURA_DATE <= INVOICE.INVOICE_DATE,
                #dsn3_alias#.SETUP_PROCESS_CAT SPC 
            WHERE
                INVOICE.PROCESS_CAT = SPC.PROCESS_CAT_ID AND
                INVOICE.INVOICE_CAT <> <cfqueryparam value="#variable1#" cfsqltype="cf_sql_smallint"> AND 
                INVOICE.INVOICE_CAT <> <cfqueryparam value="#variable2#" cfsqltype="cf_sql_smallint"> AND 
                INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#">
        </cfquery>
        <cfquery name="GET_INVOICE_MONEY" datasource="#dsn2#">
            SELECT MONEY_TYPE AS MONEY,* FROM INVOICE_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#">
        </cfquery>
        <cfif not GET_INVOICE_MONEY.recordcount>
            <cfquery name="GET_INVOICE_MONEY" datasource="#DSN#">
                SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS=<cfqueryparam value="#variable#" cfsqltype="cf_sql_smallint">
            </cfquery>
        </cfif>
        
        <cfquery name="GET_ACCOUNTS" datasource="#dsn3#">
            SELECT ACCOUNT_ID,ACCOUNT_CURRENCY_ID,ACCOUNT_NAME FROM ACCOUNTS ORDER BY ACCOUNT_NAME
        </cfquery>
        
        <cfquery name="GET_SALE_DET" datasource="#dsn2#">
            SELECT 
                ACC_DEPARTMENT_ID
            FROM
                INVOICE
            WHERE
                INVOICE_CAT <> 67 AND
                INVOICE_CAT <> 69
        </cfquery>
        <cfquery name="get_einvoice_type" datasource="#DSN#" maxrows="1"><!---MCP tarafından #75351 numaralı iş için E-Fatura Kullanıp Kullanmadığı Kontrolü İçin kullanılacak. --->
             SELECT * FROM OUR_COMPANY_INFO WHERE COMP_ID = #session.ep.company_id#
        </cfquery>
        <cfquery name="PAPER_CLOSED_CONTROL" datasource="#DSN2#">
            SELECT 
                ACTION_ID 
            FROM 
                CARI_CLOSED_ROW 
            WHERE 
            <cfif fuseaction contains 'invoice'>
                ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#">
            <cfelseif fuseaction contains 'invent'>
                ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#">
            <cfelseif fuseaction contains 'cost'>
                ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">   
            </cfif>
        </cfquery>
    </cfif>
    <cfif len(get_invoice.pay_method)>
        <cfquery name="get_paymethod" datasource="#DSN#">
            SELECT * FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = #get_invoice.PAY_METHOD#
        </cfquery>
    <cfelseif len(get_invoice.card_paymethod_id)>
        <cfquery name="get_card_paymethod" datasource="#dsn3#">
            SELECT CARD_NO,COMMISSION_MULTIPLIER FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID=#get_invoice.card_paymethod_id#
        </cfquery>
    </cfif>
    <cfif len(get_invoice.PARTNER_ID)>
        <cfquery name="GET_SALE_DET_CONS" datasource="#dsn#">
            SELECT 
                PARTNER_ID,
                COMPANY_PARTNER_NAME,
                COMPANY_PARTNER_SURNAME
            FROM 
                COMPANY_PARTNER
            WHERE 
                PARTNER_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice.PARTNER_ID#">
        </cfquery>
    </cfif>
    <cfif len(get_invoice.project_id)>
        <cfquery name="GET_PROJECT" datasource="#dsn#">
            SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice.project_id#">
        </cfquery>
    </cfif>
    <cfquery name="GET_ROWS" datasource="#dsn2#">
        SELECT DISTINCT
        	(SELECT COUNT(IA.AMORTIZATION_ID) FROM #dsn3_alias#.INVENTORY_AMORTIZATON IA WHERE IA.INVENTORY_ID = INVENTORY.INVENTORY_ID) AMORT_COUNT,
            INVOICE_ROW.NETTOTAL,
            INVOICE_ROW.GROSSTOTAL,
            INVOICE_ROW.PRICE,
            INVOICE_ROW.PRICE_OTHER,
            INVOICE_ROW.TAX,
            INVOICE_ROW.OTV_ORAN,
            INVOICE_ROW.TAXTOTAL,
            INVOICE_ROW.OTVTOTAL,
            INVOICE_ROW.OTHER_MONEY_VALUE,
            INVOICE_ROW.OTHER_MONEY_GROSS_TOTAL,
            INVOICE_ROW.OTHER_MONEY,
            INVOICE_ROW.PRODUCT_ID,
            INVOICE_ROW.STOCK_ID,
            INVOICE_ROW.NAME_PRODUCT,
            INVOICE_ROW.UNIT_ID,
            INVOICE_ROW.UNIT,
            INVENTORY.*,
            INVENTORY_ROW.STOCK_OUT,
            INVENTORY_ROW.INVENTORY_ROW_ID,
            INVOICE_ROW.WRK_ROW_ID,
            EXPENSE_CENTER.*,
            EXPENSE_ITEMS.*
        FROM
            INVOICE_ROW
            LEFT JOIN #dsn3_alias#.INVENTORY INVENTORY ON INVENTORY.INVENTORY_ID = INVOICE_ROW.INVENTORY_ID
            LEFT JOIN #dsn3_alias#.INVENTORY_ROW ON INVENTORY_ROW.INVENTORY_ID = INVENTORY.INVENTORY_ID
            LEFT JOIN #dsn2_alias#.EXPENSE_CENTER ON  EXPENSE_CENTER.EXPENSE_ID =  INVENTORY.EXPENSE_CENTER_ID
            LEFT JOIN #dsn2_alias#.EXPENSE_ITEMS ON EXPENSE_ITEMS.EXPENSE_ITEM_ID = INVENTORY.EXPENSE_ITEM_ID
        WHERE
            INVOICE_ROW.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND
            INVENTORY_ROW.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND
            INVENTORY_ROW.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
        ORDER BY
            INVENTORY_ROW.INVENTORY_ROW_ID
    </cfquery>
    <script type="text/javascript">
		<cfif get_invoice.tevkifat eq 1>//tevkifat hesapları için sayfa yüklenrken çağrılıyor
			toplam_hesapla();
		</cfif>
		function add_adress()
		{
			if(!(document.getElementById('company_id').value=="") || !(document.getElementById('consumer_id').value=="") || !(document.getElementById('employee_id').value==""))
			{
				if(document.getElementById('company_id').value!="")
				{
					str_adrlink = '&field_long_adres=inventSale.adres&field_adress_id=inventSale.ship_address_id&is_compname_readonly=1';
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(inventSale.comp_name.value)+''+ str_adrlink , 'list');
					return true;
				}
				else
				{
					str_adrlink = '&field_long_adres=inventSale.adres&field_adress_id=inventSale.ship_address_id&is_compname_readonly=1';
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(inventSale.partner_name.value)+''+ str_adrlink , 'list');
					return true;
				}
			}
			else
			{
				alert("<cf_get_lang no='181.Cari Hesap Seçmelisiniz'>");
				return false;
			}
		}
		function kontrol()
		{
			<cfif session.ep.our_company_info.is_efatura>
				var chk_efatura = wrk_safe_query("chk_efatura_count",'dsn2',0,'<cfoutput>#attributes.invoice_id#</cfoutput>');
				if(chk_efatura.recordcount > 0)
				{
				<cfif xml_upd_einvoice eq 0>
					alert("e-Faturası Oluşturulmuş Faturayı Güncelleyemezsiniz!");
					return false;
				<cfelse>		
					if(confirm("e-Faturası Oluşturulmuş Faturayı Güncellemek İstiyor musunuz!") == true);
					else
					return false;
				</cfif>
				}
			</cfif>	
			if (!chk_process_cat('inventSale')) return false;
			if(!chk_period(inventSale.invoice_date,"İşlem")) return false;
			if(!paper_control(document.inventSale.serial_no,'INVOICE',true,<cfoutput>'#attributes.invoice_id#','#get_invoice.serial_no#'</cfoutput>,'','','','','',inventSale.serial_number)) return false;
			if(!check_display_files('inventSale')) return false;
			if(inventSale.department_id.value=="")
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='1351.Depo'>");
				return false;
			}
			 <cfif session.ep.our_company_info.IS_EFATURA eq 1 ><!--- MCP tarafından #75351 numaralı iş için eklendi.e-Fatura kullanıyorsa gösterilecek --->
		 	 url_= '/V16/inventory/cfc/inventSale.cfc?method=get_company_method';
              
              $.ajax({
                  type: "get",
                  url: url_,
                  data: {company_id: document.getElementById('company_id').value},
                  cache: false,
                  async: false,
                  success: function(read_data){
                      data_ = jQuery.parseJSON(read_data.replace('//',''));
                      if(data_.DATA.length != 0)
                      {
                          $.each(data_.DATA,function(i){
                              get_efatura_info=data_.DATA[i][0];                        
                              });
                      }
                  }
            });            
				if(get_efatura_info.USE_EFATURA == 1)															   
				{
					if(document.getElementById('ship_address_id').value =='' || document.getElementById('adres').value =='')
					{
						alert('Sevk Adresi Boş Geçilemez');
						return false;
					}
				}
			</cfif>
			<cfif xml_is_department eq 2>
				if( document.inventSale.acc_department_id.options[document.inventSale.acc_department_id.selectedIndex].value=="")
				{
					alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='160.Departman'>");
					return false;
				} 
			</cfif>
			if(document.inventSale.comp_name.value == ""  && document.inventSale.consumer_id.value == "" && document.inventSale.emp_id.value == "")
			{ 
				alert ("<cf_get_lang no='8.Cari Hesap Seçmelisiniz'>!");
				return false;
			}
			//Odeme Plani Guncelleme Kontrolleri
			if (document.inventSale.invoice_cari_action_type.value == 5 && document.inventSale.paymethod_id.value != "")
			{
				if (confirm("<cf_get_lang_main no='1663.Güncellediğiniz Belgenin Ödeme Planı Yeniden Oluşturulacaktır'> !"))
					document.inventSale.invoice_payment_plan.value = 1;
				else
					document.inventSale.invoice_payment_plan.value = 0;
					<cfif xml_control_payment_plan_status eq 1>
						return false;
					</cfif>
			}
			record_exist=0;
			for(r=1;r<=inventSale.record_num.value;r++)
			{
				if(eval("document.inventSale.row_kontrol"+r).value == 1)
				{
					record_exist=1;
					if (eval("document.inventSale.invent_no"+r).value == "")
					{ 
						alert ("<cf_get_lang no='88.Lütfen Demirbaş No Giriniz'>!");
						return false;
					}
					if (eval("document.inventSale.invent_name"+r).value == "")
					{ 
						alert ("<cf_get_lang no='93.Lütfen Açıklama Giriniz'>  !");
						return false;
					}
					if ((eval("document.inventSale.row_total"+r).value == ""))
					{ 
						alert ("<cf_get_lang_main no='1738.Lütfen Tutar Giriniz '>!");
						return false;
					}
					if (eval("document.inventSale.account_code"+r).value == "")
					{ 
						alert ("<cf_get_lang no='96.Lütfen Muhasebe Kodu Seçiniz'>");
						return false;
					}
					if (eval("document.inventSale.last_diff_value"+r).value != 0 && filterNum(eval("document.inventSale.last_diff_value"+r).value) > 0 && eval("document.inventSale.budget_account_code"+r).value == "")
					{ 
						alert ("<cf_get_lang no='65.Lütfen Gelir/Gider Farkı İçin Muhasebe Kodu Seçiniz'>!");
						return false;
					}
					if (eval("document.inventSale.last_diff_value"+r).value != 0 && filterNum(eval("document.inventSale.last_diff_value"+r).value) > 0 && eval("document.inventSale.amort_account_code"+r).value == "")
					{ 
						alert ("<cf_get_lang no='64.Lütfen Amortisman Karşılık Muhasebe Kodu Seçiniz'>!");
						return false;
					}
					var listParam = eval("document.inventSale.invent_id"+r).value;
					var get_invent_amortization = wrk_safe_query("get_inventory_amort_number","dsn3",0,listParam);
					if(get_invent_amortization.recordcount)
					{
						if(datediff(date_format(get_invent_amortization.RECORD_DATE,'dd/mm/yyyy'),document.inventSale.invoice_date.value,0) <= 0)
						{
							alert("Değerlemesi Yapılan Demirbaş Bulunmaktadır! Satır: "+r);
							return false;
						}
					}
				}
			}
			if (record_exist == 0) 
				{
					alert("<cf_get_lang no='90.Lütfen Demirbaş Giriniz'>!");
					return false;
				}
			change_paper_duedate('invoice_date');
			unformat_fields();
			return true;
		}
		function unformat_fields()
		{
			for(r=1;r<=inventSale.record_num.value;r++)
			{
				deger_total = eval("document.all.row_total"+r);
				deger_total2 = eval("document.all.row_total2"+r);
				deger_kdv_total= eval("document.all.kdv_total"+r);
				deger_otv_total= document.getElementById("otv_total"+r);
				deger_net_total = eval("document.all.net_total"+r);
				deger_other_net_total = eval("document.all.row_other_total"+r);
				deger_amortization_rate = eval("document.all.amortization_rate"+r);
				deger_unit_last= eval("document.all.unit_last_value"+r);
				total_deger_unit_last= eval("document.all.last_inventory_value"+r);
				deger_last_value= eval("document.all.last_diff_value"+r);
				deger_unit_first= eval("document.all.unit_first_value"+r);
				total_deger_unit_first= eval("document.all.total_first_value"+r);
				
				deger_total.value = filterNum(deger_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_total2.value = filterNum(deger_total2.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_kdv_total.value = filterNum(deger_kdv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_otv_total.value = filterNum(deger_otv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_net_total.value = filterNum(deger_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_other_net_total.value = filterNum(deger_other_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_amortization_rate.value = filterNum(deger_amortization_rate.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_unit_last.value = filterNum(deger_unit_last.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_last_value.value = filterNum(deger_last_value.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				total_deger_unit_last.value = filterNum(total_deger_unit_last.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_unit_first.value = filterNum(deger_unit_first.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				total_deger_unit_first.value = filterNum(total_deger_unit_first.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			}
			document.inventSale.total_amount.value = filterNum(document.inventSale.total_amount.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			document.inventSale.kdv_total_amount.value = filterNum(document.inventSale.kdv_total_amount.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>); 
			document.getElementById("otv_total_amount").value = filterNum(document.getElementById("otv_total_amount").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>); 
			document.inventSale.net_total_amount.value = filterNum(document.inventSale.net_total_amount.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			document.inventSale.other_total_amount.value = filterNum(document.inventSale.other_total_amount.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			document.inventSale.other_kdv_total_amount.value = filterNum(document.inventSale.other_kdv_total_amount.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>); 
			document.getElementById("other_otv_total_amount").value = filterNum(document.getElementById("other_otv_total_amount").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>); 
			document.inventSale.other_net_total_amount.value = filterNum(document.inventSale.other_net_total_amount.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			document.inventSale.net_total_discount.value = filterNum(document.inventSale.net_total_discount.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			document.inventSale.tevkifat_oran.value = filterNum(document.inventSale.tevkifat_oran.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			document.getElementById("stopaj_yuzde").value = filterNum(document.getElementById("stopaj_yuzde").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			document.getElementById("stopaj").value = filterNum(document.getElementById("stopaj").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			for(s=1;s<=inventSale.kur_say.value;s++)
			{
				eval('inventSale.txt_rate2_' + s).value = filterNum(eval('inventSale.txt_rate2_' + s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				eval('inventSale.txt_rate1_' + s).value = filterNum(eval('inventSale.txt_rate1_' + s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			}
		}
		row_count=<cfoutput>#get_rows.recordcount#</cfoutput>;
		satir_say=<cfoutput>#get_rows.recordcount#</cfoutput>;
		function sil(sy)
		{
			var my_element=eval("inventSale.row_kontrol"+sy);
			my_element.value=0;
			var my_element=eval("frm_row"+sy);
			my_element.style.display="none";
			toplam_hesapla();
			satir_say--;
		}
		function hesapla(satir,hesap_type)
		{
			var toplam_dongu_0 = 0;//satir toplam
			if(eval("document.inventSale.row_kontrol"+satir).value==1)
			{
				deger_total = eval("document.inventSale.row_total"+satir);//tutar
				deger_total2 = eval("document.inventSale.row_total2"+satir);//dövizli tutar
				deger_miktar = eval("document.inventSale.quantity"+satir);//miktar
				deger_kdv_total= eval("document.inventSale.kdv_total"+satir);//kdv tutarı
				deger_otv_total= document.getElementById("otv_total"+satir);//otv tutarı
				deger_net_total = eval("document.inventSale.net_total"+satir);//kdvli tutar
				deger_tax_rate = eval("document.inventSale.tax_rate"+satir);//kdv oranı
				deger_otv_rate = document.getElementById("otv_rate"+satir);//otv oranı
				deger_other_net_total = eval("document.inventSale.row_other_total"+satir);//dovizli tutar kdv dahil
				deger_first_value = eval("document.inventSale.total_first_value"+satir);//İlk değer
				deger_first_unit_value = eval("document.inventSale.unit_first_value"+satir);//İlk değer birim
				deger_last_value = eval("document.inventSale.last_inventory_value"+satir);//Son değer
				deger_last_unit_value = eval("document.inventSale.unit_last_value"+satir);//Son değer birim
				deger_diff_value = eval("document.inventSale.last_diff_value"+satir);//Fark
				if(deger_total.value == "") deger_total.value = 0;
				if(deger_total2.value == "") deger_total2.value = 0;
				if(deger_kdv_total.value == "") deger_kdv_total.value = 0;
				if(deger_net_total.value == "") deger_net_total.value = 0;
				deger_money_id = eval("document.inventSale.money_id"+satir);
				deger_money_id_ilk = list_getat(deger_money_id.value,2,',');
				deger_money_id_son = list_getat(deger_money_id.value,3,',');
				deger_total.value = filterNum(deger_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_total2.value = filterNum(deger_total2.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_kdv_total.value = filterNum(deger_kdv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_otv_total.value = filterNum(deger_otv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_net_total.value = filterNum(deger_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_other_net_total.value = filterNum(deger_other_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_miktar.value = filterNum(deger_miktar.value,0);
				deger_last_value.value = filterNum(deger_last_value.value);
				deger_last_unit_value.value = filterNum(deger_last_unit_value.value);
				deger_first_value.value = filterNum(deger_first_value.value);
				deger_first_unit_value.value = filterNum(deger_first_unit_value.value,8);
				deger_diff_value.value = filterNum(deger_diff_value.value);
				
				for(s=1;s<=inventSale.kur_say.value;s++)
				{
					if(list_getat(document.inventSale.rd_money[s-1].value,1,',') == list_getat(deger_money_id.value,1,','))
					{
						satir_rate2 = filterNum(document.getElementById("txt_rate2_"+s).value,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>);
						satir_rate1 = filterNum(document.getElementById("txt_rate1_"+s).value,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>);
					}
				}
				
				if(hesap_type == undefined)
				{
					deger_total2.value = parseFloat(deger_total.value)*(parseFloat(satir_rate1)/parseFloat(satir_rate2));
					deger_otv_total.value = (parseFloat(deger_total.value) * deger_miktar.value * deger_otv_rate.value)/100;
					<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>  
						deger_kdv_total.value = ((parseFloat(deger_total.value) * parseFloat(deger_miktar.value)) * deger_tax_rate.value)/100;
					<cfelse>
						deger_kdv_total.value = ((parseFloat(deger_total.value* deger_miktar.value)+parseFloat(deger_otv_total.value)) * deger_tax_rate.value)/100;
					</cfif>
				}
				else if(hesap_type == 1)
				{
					deger_total.value = parseFloat(deger_total2.value)*(parseFloat(satir_rate2)/parseFloat(satir_rate1));
					deger_otv_total.value = (parseFloat(deger_total.value) * deger_miktar.value * deger_otv_rate.value)/100;
					<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>  
						deger_kdv_total.value = ((parseFloat(deger_total.value) * parseFloat(deger_miktar.value)) * deger_tax_rate.value)/100;
					<cfelse>
						deger_kdv_total.value = ((parseFloat(deger_total.value* deger_miktar.value)+parseFloat(deger_otv_total.value)) * deger_tax_rate.value)/100;
					</cfif>
				}
				else if(hesap_type == 2)
				{
					<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>  
						deger_total.value = ((parseFloat(deger_net_total.value)/parseFloat(deger_miktar.value))*100)/ (parseFloat(deger_tax_rate.value)+parseFloat(otv_rate_)+100);
						deger_kdv_total.value = (parseFloat(deger_total.value * deger_miktar.value * deger_tax_rate.value))/100;
						deger_otv_total.value = (parseFloat(deger_total.value * deger_miktar.value * deger_otv_rate.value))/100;
					<cfelse>
						deger_total.value = ((parseFloat(deger_net_total.value)*100)/ (parseFloat(deger_tax_rate.value)+100))/deger_miktar.value;
						deger_otv_total.value = (parseFloat(deger_total.value * deger_miktar.value * deger_otv_rate.value))/100;
						deger_kdv_total.value = ((parseFloat(deger_total.value * deger_miktar.value)+parseFloat(deger_otv_total.value)) * deger_tax_rate.value)/100;
					</cfif>
						deger_total2.value = parseFloat(deger_total.value)*(parseFloat(satir_rate1)/parseFloat(satir_rate2));
				}
				else if(hesap_type == 3)
				{
					<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>
						deger_kdv_total.value = (parseFloat(deger_net_total.value * deger_tax_rate.value))/(100 + parseFloat(deger_tax_rate.value)+ parseFloat(deger_otv_rate.value));
						deger_otv_total.value = (parseFloat(deger_net_total.value * deger_otv_rate.value))/(100 + parseFloat(deger_tax_rate.value)+ parseFloat(deger_otv_rate.value));
					<cfelse>
						deger_kdv_total.value = (parseFloat(deger_net_total.value * deger_tax_rate.value))/(100 + parseFloat(deger_tax_rate.value));
						deger_otv_total.value = (parseFloat((deger_net_total.value - deger_kdv_total.value) * deger_otv_rate.value))/(100 + parseFloat(deger_otv_rate.value));
					</cfif>
						deger_total.value = parseFloat(deger_net_total.value - deger_kdv_total.value);
						deger_total.value = parseFloat(deger_total.value - deger_otv_total.value);
						deger_total.value = (deger_total.value/deger_miktar.value);
						deger_total2.value = parseFloat(deger_total.value)*(parseFloat(satir_rate1)/parseFloat(satir_rate2));
				}
				else if(hesap_type == 4)
				{
					for(s=1;s<=inventSale.kur_say.value;s++)
					{
						if(list_getat(document.inventSale.rd_money[s-1].value,1,',') == list_getat(deger_money_id.value,1,','))
						{
							satir_rate2 = filterNum(document.getElementById("txt_rate2_"+s).value);
							satir_rate1 = document.getElementById("txt_rate1_"+s).value;
						}
					}
					deger_net_total.value = parseFloat(deger_other_net_total.value) * (parseFloat(satir_rate2)/parseFloat(satir_rate1));
					
					<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>
						deger_kdv_total.value = (parseFloat(deger_net_total.value * deger_tax_rate.value))/(100 + parseFloat(deger_tax_rate.value)+ parseFloat(deger_otv_rate.value));
						deger_otv_total.value = (parseFloat(deger_net_total.value * deger_otv_rate.value))/(100 + parseFloat(deger_tax_rate.value)+ parseFloat(deger_otv_rate.value));
					<cfelse>
						deger_kdv_total.value = (parseFloat(deger_net_total.value * deger_tax_rate.value))/(100 + parseFloat(deger_tax_rate.value));
						deger_otv_total.value = (parseFloat((deger_net_total.value - deger_kdv_total.value) * deger_otv_rate.value))/(100 + parseFloat(deger_otv_rate.value));
					</cfif>
						deger_total.value = parseFloat(deger_net_total.value - deger_kdv_total.value);
						deger_total.value = parseFloat(deger_total.value - deger_otv_total.value);
						deger_total.value = (deger_total.value/deger_miktar.value);
						deger_total2.value = parseFloat(deger_total.value)*(parseFloat(satir_rate1)/parseFloat(satir_rate2));
				}
				toplam_dongu_0 = (parseFloat(deger_total.value)*deger_miktar.value) + parseFloat(deger_kdv_total.value) + parseFloat(deger_otv_total.value);
				deger_other_net_total.value = ((parseFloat(deger_total.value) + parseFloat(deger_kdv_total.value) + parseFloat(deger_otv_total.value)) * parseFloat(deger_money_id_ilk) / (parseFloat(deger_money_id_son)));
				deger_net_total.value = commaSplit(toplam_dongu_0,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_last_value.value =  parseFloat(deger_last_unit_value.value * deger_miktar.value);
				deger_first_value.value =  parseFloat(deger_first_unit_value.value * deger_miktar.value);
				deger_diff_value.value = parseFloat((deger_total.value * deger_miktar.value)  - deger_last_value.value);
				deger_diff_value.value = commaSplit(deger_diff_value.value);
				deger_last_value.value = commaSplit(deger_last_value.value);
				deger_last_unit_value.value = commaSplit(deger_last_unit_value.value);
				deger_first_value.value = commaSplit(deger_first_value.value);
				deger_first_unit_value.value = commaSplit(deger_first_unit_value.value,8);
				deger_total.value = commaSplit(deger_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_total2.value = commaSplit(deger_total2.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_kdv_total.value = commaSplit(deger_kdv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_otv_total.value = commaSplit(deger_otv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_other_net_total.value = commaSplit(deger_other_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			}
			toplam_hesapla();
		}
		function calc_stopaj()
		{
			if((parseFloat(document.getElementById("stopaj_yuzde").value) < 0) || (parseFloat(document.getElementById("stopaj_yuzde").value) > 99.99))
			{
				alert('Stopaj Oranı !');
				document.getElementById("stopaj_yuzde").value = 0;
			}
			toplam_hesapla(0);
		}
		function toplam_hesapla(type)
		{
			var toplam_dongu_1 = 0;//tutar genel toplam
			var toplam_dongu_2 = 0;// kdv genel toplam
			var toplam_dongu_3 = 0;// kdvli genel toplam
			var toplam_dongu_4 = 0;// kdvli genel toplam
			var toplam_dongu_5 = 0;// ötv genel toplam
			var beyan_tutar = 0;
			var tevkifat_info = "";
			var beyan_tutar_info = "";
			var new_taxArray = new Array(0);
			var taxBeyanArray = new Array(0);
			var taxTevkifatArray = new Array(0);
			for(r=1;r<=inventSale.record_num.value;r++)
			{
				if(eval("document.inventSale.row_kontrol"+r).value==1)
				{
					toplam_dongu_4 = toplam_dongu_4 + (parseFloat(filterNum(eval("document.inventSale.row_total"+r).value) * filterNum(eval("document.inventSale.quantity"+r).value)));
				}
			}			
			genel_indirim_yuzdesi = commaSplit(parseFloat(filterNum(document.inventSale.net_total_discount.value),8) / parseFloat(toplam_dongu_4),8);
			genel_indirim_yuzdesi = filterNum(genel_indirim_yuzdesi,8);
			genel_indirim_yuzdesi = wrk_round(genel_indirim_yuzdesi,2);
			deger_discount_value = document.inventSale.net_total_discount.value;
			deger_discount_value = filterNum(deger_discount_value,4);
			for(r=1;r<=inventSale.record_num.value;r++)
			{
				if(eval("document.inventSale.row_kontrol"+r).value==1)
				{
					deger_total = eval("document.inventSale.row_total"+r);//tutar
					deger_total2 = eval("document.inventSale.row_total2"+r);//dövizli tutar
					deger_miktar = eval("document.inventSale.quantity"+r);//miktar
					deger_kdv_total= eval("document.inventSale.kdv_total"+r);//kdv tutarı
					deger_otv_total= document.getElementById("otv_total"+r);//ötv tutarı
					deger_net_total = eval("document.inventSale.net_total"+r);//kdvli tutar
					deger_tax_rate = eval("document.inventSale.tax_rate"+r);//kdv oranı
					deger_other_net_total = eval("document.inventSale.row_other_total"+r);//dovizli tutar kdv dahil
					deger_money_id = eval("document.inventSale.money_id"+r);
					deger_money_id_ilk = list_getat(deger_money_id.value,1,',');
					for(s=1;s<=inventSale.kur_say.value;s++)
						{
							if(list_getat(document.inventSale.rd_money[s-1].value,1,',') == deger_money_id_ilk)
							{
								satir_rate2= eval("document.inventSale.txt_rate2_"+s).value;
							}
						}
					deger_miktar.value = filterNum(deger_miktar.value,0);//miktar
					satir_rate2= filterNum(satir_rate2,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');			
					deger_total.value = filterNum(deger_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
					deger_total2.value = filterNum(deger_total2.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
					deger_kdv_total.value = filterNum(deger_kdv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
					deger_otv_total.value = filterNum(deger_otv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
					deger_net_total.value = filterNum(deger_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
					deger_other_net_total.value = filterNum(deger_other_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
					toplam_dongu_1 = toplam_dongu_1 + parseFloat(deger_total.value * deger_miktar.value);
	                deger_other_net_total.value = ((parseFloat(deger_total.value * deger_miktar.value) + parseFloat(deger_kdv_total.value) + parseFloat(deger_otv_total.value)) / (parseFloat(satir_rate2)));
					toplam_dongu_2 = toplam_dongu_2 + parseFloat(deger_kdv_total.value)- parseFloat(deger_kdv_total.value*genel_indirim_yuzdesi);
					toplam_dongu_5 = toplam_dongu_5 + parseFloat(deger_otv_total.value);
					deger_indirim_kdv = parseFloat(deger_kdv_total.value)- parseFloat(deger_kdv_total.value*genel_indirim_yuzdesi);
					toplam_dongu_3 = toplam_dongu_3 + ((parseFloat(deger_total.value)- (parseFloat(deger_total.value)*genel_indirim_yuzdesi)) * deger_miktar.value);
					toplam_dongu_3 = toplam_dongu_3 + parseFloat(deger_kdv_total.value)- parseFloat(deger_kdv_total.value*genel_indirim_yuzdesi);
					toplam_dongu_3 = toplam_dongu_3 + parseFloat(deger_otv_total.value);
					
					if(document.inventSale.tevkifat_oran != undefined && document.inventSale.tevkifat_oran.value != "" && inventSale.tevkifat_box.checked == true)
					{//tevkifat hesaplamaları
						beyan_tutar = beyan_tutar + wrk_round(deger_indirim_kdv*filterNum(document.inventSale.tevkifat_oran.value));
						if(new_taxArray.length != 0)
							for (var m=0; m < new_taxArray.length; m++)
							{	
								var tax_flag = false;
								if(new_taxArray[m] == deger_tax_rate.value){
									tax_flag = true;
									taxBeyanArray[m] += wrk_round(deger_indirim_kdv - (deger_indirim_kdv*(filterNum(document.inventSale.tevkifat_oran.value))));
									taxTevkifatArray[m] += wrk_round(deger_indirim_kdv*(filterNum(document.inventSale.tevkifat_oran.value)));
									break;
								}
							}
						if(!tax_flag){
							new_taxArray[new_taxArray.length] = deger_tax_rate.value;
							taxBeyanArray[taxBeyanArray.length] = wrk_round(deger_indirim_kdv - (deger_indirim_kdv*(filterNum(document.inventSale.tevkifat_oran.value))));
							taxTevkifatArray[taxTevkifatArray.length] = wrk_round(deger_indirim_kdv*(filterNum(document.inventSale.tevkifat_oran.value)));
						}
					}
					deger_net_total.value = commaSplit(deger_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
					deger_total.value = commaSplit(deger_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
					deger_total2.value = commaSplit(deger_total2.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
					deger_kdv_total.value = commaSplit(deger_kdv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
					deger_otv_total.value = commaSplit(deger_otv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
					deger_other_net_total.value = commaSplit(deger_other_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				}
			}	
			if(document.inventSale.tevkifat_oran != undefined && document.inventSale.tevkifat_oran.value != "" && inventSale.tevkifat_box.checked == true)
			{//tevkifat hesaplamaları
				toplam_dongu_3 = toplam_dongu_3 - toplam_dongu_2 + beyan_tutar;
				toplam_dongu_2 = beyan_tutar;
				tevkifat_text.style.fontWeight = 'bold';
				tevkifat_text.innerHTML = '';
				beyan_text.style.fontWeight = 'bold';
				beyan_text.innerHTML = '';
				for (var tt=0; tt < new_taxArray.length; tt++)
				{
					tevkifat_text.innerHTML += '% ' + new_taxArray[tt] + ' : ' + commaSplit(taxBeyanArray[tt],4) + ' ';
					beyan_text.innerHTML += '% ' + new_taxArray[tt] + ' : ' + commaSplit(taxTevkifatArray[tt],4) + ' ';
				}
		 	}	
			if(type == undefined || parseFloat(document.getElementById("stopaj_yuzde").value) != 0)
				stopaj_ = wrk_round((toplam_dongu_1 * parseFloat(document.getElementById("stopaj_yuzde").value) / 100),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			else
				stopaj_ = filterNum(document.getElementById("stopaj").value);
			document.getElementById("stopaj_yuzde").value = commaSplit(parseFloat(document.getElementById("stopaj_yuzde").value));
			document.getElementById("stopaj").value = commaSplit(stopaj_,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			toplam_dongu_3 = toplam_dongu_3-parseFloat(stopaj_);
			//stopajlar hesaplandi
			document.inventSale.total_amount.value = commaSplit(toplam_dongu_1,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			document.inventSale.kdv_total_amount.value = commaSplit(toplam_dongu_2,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>); 
			document.getElementById('otv_total_amount').value = commaSplit(toplam_dongu_5,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			document.inventSale.net_total_amount.value = commaSplit(toplam_dongu_3,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			for(s=1;s<=inventSale.kur_say.value;s++)
			{
				form_txt_rate2_ = eval("document.inventSale.txt_rate2_"+s);
				if(form_txt_rate2_.value == "")
					form_txt_rate2_.value = 1;
			}
			if(inventSale.kur_say.value == 1)
				for(s=1;s<=inventSale.kur_say.value;s++)
				{
					if(document.inventSale.rd_money.checked == true)
					{
						deger_diger_para = document.inventSale.rd_money;
						form_txt_rate2_ = eval("document.inventSale.txt_rate2_"+s);
					}
				}
			else 
				for(s=1;s<=inventSale.kur_say.value;s++)
				{
					if(document.inventSale.rd_money[s-1].checked == true)
					{
						deger_diger_para = document.inventSale.rd_money[s-1];
						form_txt_rate2_ = eval("document.inventSale.txt_rate2_"+s);
					}
				}
			deger_money_id_1 = list_getat(deger_diger_para.value,1,',');
			deger_money_id_3 = list_getat(deger_diger_para.value,3,',');
			form_txt_rate2_.value = filterNum(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			document.inventSale.other_total_amount.value = commaSplit(toplam_dongu_1 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			document.inventSale.other_kdv_total_amount.value = commaSplit(toplam_dongu_2 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>); 
			document.getElementById('other_otv_total_amount').value = commaSplit(toplam_dongu_5 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			document.inventSale.other_net_total_amount.value = commaSplit(toplam_dongu_3 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			document.inventSale.other_net_total_discount.value = commaSplit(deger_discount_value* parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			document.inventSale.net_total_discount.value = commaSplit(deger_discount_value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			
			document.inventSale.tl_value1.value = deger_money_id_1;
			document.inventSale.tl_value2.value = deger_money_id_1;			//kdv
			document.getElementById('tl_value5').value = deger_money_id_1;	//otv
			document.inventSale.tl_value3.value = deger_money_id_1;
			document.inventSale.tl_value4.value = deger_money_id_1;
			form_txt_rate2_.value = commaSplit(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
		function gonder(invent_id,invent_name,invent_no,quantity,acc_id,amort_rate,amortizaton_method,unit_last_value,last_inventory_value,unit_first_value,total_first_value,last_diff_value,expense_center_id,expense_center_name,budget_item_id,budget_item_name,debt_account_id,claim_account_id)
		{
			if(invent_name.indexOf('"') > -1)
				invent_name = invent_name.replace(/"/g,'');
			if(invent_name.indexOf("'") > -1)
				invent_name = invent_name.replace(/'/g,'');
			row_count++;
			satir_say++;
			var newRow;
			var newCell;
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);		
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);		
			newRow.className = 'color-row';
			document.inventSale.record_num.value=row_count;
			newCell = newRow.insertCell(newRow.cells.length);
			x = '<input  type="hidden" value="WRK'+row_count+ js_create_unique_id() + row_count+'" name="wrk_row_id' + row_count +'"><input  type="hidden" value="" name="wrk_row_relation_id' + row_count +'">';
			newCell.innerHTML = x + '<input  type="hidden" value="1" name="row_kontrol' + row_count +'" ><a href="javascript://" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" name="invent_id' + row_count +'" value="'+ invent_id +'" readonly><input type="text" name="invent_no' + row_count +'" style="width:100%;" class="boxtext" value="'+ invent_no +'">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="invent_name' + row_count +'" style="width:100%;"  readonly class="boxtext" value="'+ invent_name +'" maxlength="100">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.title=eval("inventSale.invent_name"+satir_say).value;
			newCell.innerHTML = '<input type="text" name="quantity' + row_count +'" style="width:100%;" class="box" value="'+ quantity +'" onBlur="hesapla(' + row_count +');" onkeyup="return(FormatCurrency(this,event));">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.title=eval("inventSale.invent_name"+satir_say).value;
			newCell.innerHTML = '<input type="text" name="row_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" onBlur="hesapla(' + row_count +');" style="width:100%;" class="box">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.title=eval("inventSale.invent_name"+satir_say).value;
			newCell.innerHTML = '<input type="text" name="row_total2' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" onBlur="hesapla(' + row_count +',1);" style="width:100%;" class="box">';
			//kdv orani
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.title=eval("inventSale.invent_name"+satir_say).value;
			newCell.innerHTML = '<select name="tax_rate'+ row_count +'" style="width:100%;" onChange="hesapla('+ row_count +');" class="box"><cfoutput query="get_tax"><option value="#tax#">#tax#</option></cfoutput></select>';
			//otv orani
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.title=eval("inventSale.invent_name"+satir_say).value;
			newCell.innerHTML = '<select name="otv_rate'+ row_count +'" id="otv_rate'+ row_count +'" style="width:100%;" onChange="hesapla('+ row_count +');" class="box"><cfoutput query="get_otv"><option value="#tax#">#tax#</option></cfoutput></select>';
			//kdv total
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.title=eval("inventSale.invent_name"+satir_say).value;
			newCell.innerHTML = '<input type="text" name="kdv_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" style="width:100%;" onBlur="hesapla(' + row_count +',1);" class="box">';
			//otv total
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.title=eval("inventSale.invent_name"+satir_say).value;
			newCell.innerHTML = '<input type="text" name="otv_total' + row_count +'" id="otv_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" style="width:100%;" onBlur="hesapla(' + row_count +',1);" class="box">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.title=eval("inventSale.invent_name"+satir_say).value;	
	        newCell.innerHTML = '<input type="text" name="net_total' + row_count +'" id="net_total' + row_count +'" value="0" style="width:100%;" class="box" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" onblur="hesapla(' + row_count +',3);">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.title=eval("inventSale.invent_name"+satir_say).value;
	        newCell.innerHTML = '<input type="text" name="row_other_total' + row_count +'" id="row_other_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" style="width:100%;" class="box" onblur="hesapla(' + row_count +',4);">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.title=eval("inventSale.invent_name"+satir_say).value;
			newCell.innerHTML = '<select name="money_id' + row_count  +'" style="width:100%;" class="boxtext" onChange="hesapla('+ row_count +');"><cfoutput query="get_money"><option value="#money#,#rate1#,#rate2#" <cfif money eq session.ep.money>selected</cfif>>#money#</option></cfoutput></select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.title=eval("inventSale.invent_name"+satir_say).value;
			newCell.innerHTML = '<input type="text" readonly="yes" name="amortization_rate' + row_count +'" value="'+ amort_rate +'" style="width:100%;" class="box" onkeyup="return(FormatCurrency(this,event));">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.title=eval("inventSale.invent_name"+satir_say).value;
			if(amortizaton_method == 0)
				newCell.innerHTML = '<input type="text" readonly name="amortization_method'+ row_count +'" style="width:165px;" class="box" value="<cf_get_lang_main no='1624.Azalan Bakiye Üzerinden'>">';
			else if(amortizaton_method == 1)
				newCell.innerHTML = '<input type="text" readonlyname="amortization_method'+ row_count +'" style="width:165px;" class="box" value="<cf_get_lang_main no='1625.Sabit Miktar Üzeriden'>">';
			else if(amortizaton_method == 2)
				newCell.innerHTML = '<input type="text" readonly name="amortization_method'+ row_count +'" style="width:165px;" class="box" value="<cf_get_lang_main no='1626.Hızlandırılmış Azalan Bakiye'>">';	
			else
				newCell.innerHTML = '<input type="text" readonly name="amortization_method'+ row_count +'" style="width:165px;" class="box" value="<cf_get_lang_main no='1627.Hızlandırılmış Sabit Değer'>">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.title=eval("inventSale.invent_name"+satir_say).value;
			newCell.innerHTML = '<input  type="hidden" readonly name="account_id' + row_count +'" id="account_id' + row_count +'"  value="'+ acc_id +'"><input type="text" style="width:120px;" name="account_code' + row_count +'" id="account_code' + row_count +'" value="'+ acc_id +'" class="boxtext" onFocus="autocomp_account('+row_count+');"><a href="javascript://" onclick="pencere_ac_acc('+ row_count +');" ><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.title=eval("inventSale.invent_name"+satir_say).value;	
			newCell.innerHTML = '<input type="hidden" name="unit_first_value' + row_count +'" value="'+ unit_first_value +'"><input type="hidden" name="total_first_value' + row_count +'" value="'+ total_first_value +'"><input type="hidden" name="unit_last_value' + row_count +'" value="'+ unit_last_value +'"><input type="text" name="last_inventory_value' + row_count +'" value="'+ last_inventory_value +'" style="width:100%;" class="box" onkeyup="return(FormatCurrency(this,event));" readonly="yes">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.title=eval("inventSale.invent_name"+satir_say).value;	
			newCell.innerHTML = '<input type="text" name="last_diff_value' + row_count +'" value="'+last_diff_value+'" style="width:100%;" class="box" onkeyup="return(FormatCurrency(this,event));" readonly="yes">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.title=eval("inventSale.invent_name"+satir_say).value;	
			newCell.innerHTML ='<input type="hidden" name="expense_center_id' + row_count +'" value="'+expense_center_id+'" id="expense_center_id' + row_count +'"><input type="text" id="expense_center_name' + row_count +'" name="expense_center_name' + row_count +'" onFocus="exp_center('+row_count+');" value="'+expense_center_name+'" style="width:150px;" class="boxtext"><a href="javascript://" onClick="pencere_ac_exp_center('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.title=eval("inventSale.invent_name"+satir_say).value;	
			newCell.innerHTML = '<input  type="hidden" name="budget_item_id' + row_count +'" id="budget_item_id' + row_count +'" value='+budget_item_id+'><input type="text" style="width:118px;" name="budget_item_name' + row_count +'" id="budget_item_name' + row_count +'" class="boxtext" value="'+budget_item_name+'" onFocus="exp_item('+row_count+');"><a href="javascript://"><img src="/images/plus_thin.gif" onclick="pencere_ac_exp('+ row_count +');" align="absmiddle" border="0"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.title=eval("inventSale.invent_name"+satir_say).value;	
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input  type="hidden" name="budget_account_id' + row_count +'" id="budget_account_id' + row_count +'" value="'+debt_account_id+'"><input type="text" name="budget_account_code' + row_count +'" id="budget_account_code' + row_count +'" value="'+debt_account_id+'" class="boxtext" style="width:158px;" onFocus="autocomp_budget_account('+row_count+');"><a href="javascript://"onclick="pencere_ac_acc_1('+ row_count +');" ><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.title=eval("inventSale.invent_name"+satir_say).value;	
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input  type="hidden" name="amort_account_id' + row_count +'" id="amort_account_id' + row_count +'" value="'+claim_account_id+'"><input type="text" name="amort_account_code' + row_count +'" id="amort_account_code' + row_count +'"  value="'+claim_account_id+'" class="boxtext" style="width:205px;" onFocus="autocomp_amort_account('+row_count+');"> <a href="javascript://"onclick="pencere_ac_acc_2('+ row_count +');" ><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.title=eval("inventSale.invent_name"+satir_say).value;
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input  type="hidden" name="product_id' + row_count +'" id="product_id' + row_count +'"><input  type="hidden" name="stock_id' + row_count +'" id="stock_id' + row_count +'"><input type="text" name="product_name' + row_count +'" id="product_name' + row_count +'" class="boxtext" onFocus="AutoComplete_Create(\'product_name' + row_count +'\',\'PRODUCT_NAME\',\'PRODUCT_NAME,STOCK_CODE\',\'get_product_autocomplete\',\'0\',\'PRODUCT_ID,STOCK_ID,MAIN_UNIT,PRODUCT_UNIT_ID\',\'product_id' + row_count +',stock_id' + row_count +',stock_unit' + row_count  +',stock_unit_id' + row_count  +'\',\'inventSale\',1,\'\',\'\');">'
								+' '+'<a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&product_id=inventSale.product_id" + row_count + "&field_id=inventSale.stock_id" + row_count + "&field_unit_name=inventSale.stock_unit" + row_count + "&field_main_unit=inventSale.stock_unit_id" + row_count + "&field_name=inventSale.product_name" + row_count + "','list');"+'"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.title=eval("inventSale.invent_name"+satir_say).value;
			newCell.innerHTML = '<input type="hidden" name="stock_unit_id' + row_count +'" id="stock_unit_id' + row_count +'"><input type="text" name="stock_unit' + row_count +'" id="stock_unit' + row_count +'" style="width:100%;" class="boxtext">';
		}
		/* masraf merkezi popup */
		function pencere_ac_exp_center(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=inventSale.expense_center_id' + no +'&field_name=inventSale.expense_center_name' + no,'list');
		}
		/* masraf merkezi autocomplete */
		function exp_center(no)
		{
			AutoComplete_Create("expense_center_name" + no,"EXPENSE,EXPENSE_CODE","EXPENSE,EXPENSE_CODE","get_expense_center","","EXPENSE_ID","expense_center_id"+no,"",3);
		}
		/* gider kalemi autocomplete */
		function exp_item(no)
		{
			AutoComplete_Create("budget_item_name" + no,"EXPENSE_ITEM_NAME","EXPENSE_ITEM_NAME","get_expense_item","","EXPENSE_ITEM_ID,ACCOUNT_CODE","budget_item_id"+no+",budget_account_code"+no,"",3);
		}
		function autocomp_account(no)
		{
			AutoComplete_Create("account_code"+no,"ACCOUNT_CODE,ACCOUNT_NAME","ACCOUNT_CODE,ACCOUNT_NAME","get_account_code","0","ACCOUNT_CODE","account_id"+no,"",3);
		}
		function autocomp_budget_account(no)
		{
			AutoComplete_Create("budget_account_code"+no,"ACCOUNT_CODE,ACCOUNT_NAME","ACCOUNT_CODE,ACCOUNT_NAME","get_account_code","0","ACCOUNT_CODE","budget_account_id"+no,"",3);
		}
		function autocomp_amort_account(no)
		{
			AutoComplete_Create("amort_account_code"+no,"ACCOUNT_CODE,ACCOUNT_NAME","ACCOUNT_CODE,ACCOUNT_NAME","get_account_code","0","ACCOUNT_CODE","amort_account_id"+no,"",3);
		}
		function pencere_ac_acc(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=inventSale.account_id' + no +'&field_name=inventSale.account_code' + no +'','list');
		}
		function pencere_ac_acc_1(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=inventSale.budget_account_id' + no +'&field_name=inventSale.budget_account_code' + no +'','list');
		}
		function pencere_ac_acc_2(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=inventSale.amort_account_id' + no +'&field_name=inventSale.amort_account_code' + no +'','list');
		}
		function pencere_ac_exp(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=inventSale.budget_item_id' + no +'&field_name=inventSale.budget_item_name' + no +'&field_account_no=inventSale.budget_account_code' + no +'&field_account_no2=inventSale.budget_account_id' + no +'','list');
		}
		function pencere_ac_stock(no)
		{
				if(inventSale.branch_id.value == '')
				{
					alert("<cf_get_lang_main no='311.Önce depo seçmelisiniz'>!");
					return false;
				}
				if(inventSale.company_id.value.length==0)
				{ 
					alert("<cf_get_lang_main no='303.Önce Üye Seçiniz'>!");
					return false;
				}
				if(inventSale.company_id!=undefined && inventSale.company_id.value.length)
					windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_products&company_id='+inventSale.company_id.value+'&int_basket_id=1&is_sale_product=0&update_product_row_id=0</cfoutput>','list');
		}
		function ayarla_gizle_goster()
		{
			if(inventSale.cash.checked)
				kasa2.style.display='';
			else
				kasa2.style.display='none';
		}
		function f_inventSale()
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_inventory&field_id=inventSale.invent_id&is_sale=1','wide');
		}
		function change_paper_duedate(field_name,type,is_row_parse) 
		{
			paper_date_=eval('document.inventSale.invoice_date.value');
			if(type!=undefined && type==1)
				document.inventSale.basket_due_value.value = datediff(paper_date_,document.inventSale.basket_due_value_date_.value,0);
			else
			{
				if(isNumber(document.inventSale.basket_due_value)!= false && (document.inventSale.basket_due_value.value != 0))
					document.inventSale.basket_due_value_date_.value = date_add('d',+document.inventSale.basket_due_value.value,paper_date_);
				else
				{
					document.inventSale.basket_due_value_date_.value =paper_date_;
					if(document.inventSale.basket_due_value.value == '')
						document.inventSale.basket_due_value.value = datediff(paper_date_,document.inventSale.basket_due_value_date_.value,0);
				}
			}
		}
		function change_acc_all()
		{
			var loopcount=document.getElementById('record_num').value;	
			if(loopcount>0)
			{
				for(var i=1;i<=loopcount;++i)
				{
					document.getElementById('account_id'+i).value = document.getElementById('account_id_all').value;
					document.getElementById('account_code'+i).value = document.getElementById('account_code_all').value;
				}
			}
		}
		function change_budget_acc_all()
		{
			var loopcount=document.getElementById('record_num').value;	
			if(loopcount>0)
			{
				for(var i=1;i<=loopcount;++i)
				{
					document.getElementById('budget_account_id'+i).value = document.getElementById('budget_account_id_all').value;
					document.getElementById('budget_account_code'+i).value = document.getElementById('budget_account_code_all').value;
				}
			}
		}
		function change_exp_all()
		{
			var loopcount=document.getElementById('record_num').value;
			if(loopcount>0)
			{
				for(var i=1;i<=loopcount;++i)
				{
					document.getElementById('budget_item_id'+i).value = document.getElementById('budget_item_id_all').value;
					document.getElementById('budget_item_name'+i).value = document.getElementById('budget_item_name_all').value;
					document.getElementById('budget_account_id'+i).value = document.getElementById('budget_account_id_all').value;
					document.getElementById('budget_account_code'+i).value = document.getElementById('budget_account_code_all').value;
				}
			}
		}
		function change_amort_all()
		{
			var loopcount=document.getElementById('record_num').value;	
			if(loopcount>0)
			{
				for(var i=1;i<=loopcount;++i)
				{
					document.getElementById('amort_account_id'+i).value = document.getElementById('amort_account_id_all').value;
					document.getElementById('amort_account_code'+i).value = document.getElementById('amort_account_code_all').value;
				}
			}
		}
		function clear_()
		{
			if(document.getElementById('employee').value=='')
			{
				document.getElementById('employee_id').value='';
			}
		}
		function change_expense_center()
		{
			var loopcount=document.getElementById('record_num').value;
			if(loopcount>0)
			{
				for(var i=1;i<=loopcount;++i)
				{

					document.getElementById('expense_center_id'+i).value = document.getElementById('expense_center_id_all').value;
					document.getElementById('expense_center_name'+i).value = document.getElementById('main_exp_center_name_all').value;
				}
			}
		}
		function kontrol2()
		{
			<cfif session.ep.our_company_info.is_efatura>
				var chk_efatura = wrk_safe_query("chk_efatura_count",'dsn2',0,'<cfoutput>#attributes.invoice_id#</cfoutput>');
				if(chk_efatura.recordcount > 0)
				{
					alert("Fatura ile İlişkili e-Fatura Olduğu için Silinemez !");
					return false;
				}	
			</cfif>
			return true;
		}
	</script>
</cfif>
<script type="text/javascript" >
	function pencere_ac_cari()
	{
		windowopen('index.cfm?fuseaction=objects.popup_list_pars&field_member_account_code=inventSale.member_code&is_cari_action=1&select_list=1,2,3&field_name=inventSale.partner_name&field_partner=inventSale.partner_id&field_comp_name=inventSale.comp_name&field_comp_id=inventSale.company_id&field_consumer=inventSale.consumer_id&field_emp_id=inventSale.emp_id&field_revmethod_id=inventSale.paymethod_id&field_revmethod=inventSale.paymethod&field_basket_due_value_rev=inventSale.basket_due_value&field_adress_id=inventSale.ship_address_id&field_long_address=inventSale.adres&call_function=change_paper_duedate()','list');
	}
	function auto_complate_satin()
	{
		AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'3\',\'0\',\'0\',\'0\',\'\',\'\',\'\',\'\'','EMPLOYEE_ID','employee_id','','3','130');
	}
	function pencere_ac_satin()
	{
		windowopen('index.cfm?fuseaction=objects.popup_list_positions&field_emp_id=inventSale.employee_id&field_name=inventSale.employee&select_list=1,9','list');
	}
	
	function pencere_ac_proje()
	{
		windowopen('index.cfm?fuseaction=objects.popup_list_projects&project_id=inventSale.project_id&project_head=inventSale.project_head','list');
	}
	function auto_complate_proje()
	{
		AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','150');
	}
	
	function pencere_ac_odemeYontemi()
	{
		windowopen('index.cfm?fuseaction=objects.popup_paymethods&field_id=inventSale.paymethod_id&field_dueday=inventSale.basket_due_value&function_name=change_paper_duedate&field_name=inventSale.paymethod#card_link#','list');
	}
</script>
<cfif isdefined('attributes.event') and attributes.event eq 'upd' >
	<cfset attributes.cari_action_type = get_invoice.cari_action_type>
	<cfset attributes.process_cat = get_invoice.process_cat>
	<cfset attributes.invoice_date = get_invoice.invoice_date>
	<cfset attributes.department_id = get_invoice.department_id>
	<cfset attributes.department_location = get_invoice.department_location>
	<cfset attributes.note = get_invoice.note>
	<cfset attributes.employee_id = get_invoice.employee_id>
	<cfset attributes.acc_type_id = get_invoice.acc_type_id>
	<cfset attributes.consumer_id = get_invoice.consumer_id>
	<cfset attributes.company_id = get_invoice.company_id>
	<cfset attributes.partner_id = get_invoice.partner_id>
	<cfset attributes.serial_number = get_invoice.serial_number>
	<cfset attributes.serial_no = get_invoice.serial_no>
	<cfset attributes.card_paymethod_id = get_invoice.card_paymethod_id>
	<cfif len(get_invoice.pay_method)>
		<cfset attributes.commission_rate = "">
		<cfset attributes.paymethod = get_invoice.pay_method>
	<cfelseif len(get_invoice.card_paymethod_id)>
		<cfset attributes.commission_rate = get_card_paymethod.commission_multiplier>
		<cfset attributes.paymethod = get_card_paymethod.card_no>
	<cfelse>
		<cfset attributes.commission_rate = "">
		<cfset attributes.paymethod = "">
	</cfif>
	<cfset attributes.pay_method = get_invoice.card_paymethod_id>
	<cfset attributes.PARTNER_ID = get_invoice.PARTNER_ID>
	<cfset attributes.COMPANY_PARTNER_NAME = GET_SALE_DET_CONS.COMPANY_PARTNER_NAME>
	<cfset attributes.COMPANY_PARTNER_SURNAME = GET_SALE_DET_CONS.COMPANY_PARTNER_SURNAME>
	<cfset attributes.SHIP_NUMBER = GET_SHIP.SHIP_NUMBER>
	<cfset attributes.due_date = get_invoice.due_date>
	<cfset attributes.sale_emp = get_invoice.sale_emp>
	<cfset attributes.ACC_DEPARTMENT_ID = get_invoice.ACC_DEPARTMENT_ID>
	<cfset attributes.project_id = get_invoice.project_id>
	<cfif len(attributes.project_id)>
		<cfset attributes.project_head = get_project.project_head>
	</cfif>
	<cfset attributes.SHIP_ADDRESS_ID = GET_INVOICE.SHIP_ADDRESS_ID>
	<cfset attributes.SHIP_ADDRESS = GET_INVOICE.SHIP_ADDRESS>
	<cfset attributes.kasa_id = get_invoice.kasa_id>
	<cfif isdefined("get_expense") and get_expense.is_credit eq 1>
		<cfset attributes.INSTALLMENT_NUMBER = get_credit_info.INSTALLMENT_NUMBER>
		<cfset attributes.CREDITCARD_ID = get_credit_info.CREDITCARD_ID>
		<cfset attributes.DELAY_INFO = get_credit_info.DELAY_INFO>
		<cfset attributes.closed_amount = get_credit_info.closed_amount>
	</cfif>
	<cfset attributes.upd_status = get_invoice.upd_status>
	<cfset attributes.recordcount = get_rows.recordcount>
	<cfparam name="attributes.kur_say" default="GET_INVOICE_MONEY.recordcount">
	<cfset attributes.RATE2 = GET_INVOICE_MONEY.RATE2>
	<cfset attributes.GROSSTOTAL = get_invoice.GROSSTOTAL>
	<cfset attributes.TAXTOTAL = get_invoice.TAXTOTAL>
	<cfset attributes.OTV_TOTAL = get_invoice.OTV_TOTAL>
	<cfset attributes.stopaj_oran = get_invoice.stopaj_oran>
	<cfset attributes.stopaj = get_invoice.stopaj>
	<cfset attributes.sa_discount = get_invoice.SA_DISCOUNT>
	<cfset attributes.NETTOTAL = get_invoice.NETTOTAL>
	<cfset attributes.OTHER_MONEY_VALUE = get_invoice.OTHER_MONEY_VALUE>
	<cfset attributes.tevkifat_id = get_invoice.tevkifat_id>
	<cfset attributes.tevkifat_oran = get_invoice.tevkifat_oran>
	<cfset attributes.tevkifat = get_invoice.tevkifat>
	<cfset attributes.action_id = paper_closed_control.action_id>
	<cfset attributes.other_money = get_invoice.other_money>
	<cfset nattributes.STOPAJ_RATE_ID  = get_invoice.stopaj_rate_id>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'invent.add_invent_sale';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'inventory/form/add_invent_purchase.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'inventory/query/add_invent_sale.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'invent.add_invent_sale&event=upd';
	
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'invent.add_invent_sale';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'inventory/form/add_invent_purchase.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'inventory/query/upd_invent_sale.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'invent.add_invent_sale&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'invoice_id=##attributes.invoice_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.invoice_id##';
	
	if(isdefined("attributes.event") and (attributes.event is 'upd' or attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'invent.add_invent_sale&event=del&invoice_id=#attributes.invoice_id#&head=#get_invoice.invoice_number#&old_process_type=#get_invoice.invoice_cat#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'inventory/query/del_purchase_sale_invent.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'inventory/query/del_purchase_sale_invent.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'invent.add_invent_sale';
	}
	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1966]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['customTag'] = '<cf_get_workcube_related_acts period_id="#session.ep.period_id#" company_id="#session.ep.company_id#" asset_cat_id="-22" module_id="20" action_section="INVOICE_ID" action_id="#attributes.invoice_id#">';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[345]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=invent.inventSale_sale&action_name=invoice_id&action_id=#attributes.invoice_id#','page','add_process')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '#lang_array_main.item[1040]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_account_cards&invoice_id=#attributes.invoice_id#','page','add_process')";
		if(len(get_invoice.pay_method) and not listfindnocase(denied_pages,'objects.popup_payment_with_voucher'))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['text'] = '#lang_array.item[14]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_payment_with_voucher&is_purchase_=0&payment_process_id=#attributes.invoice_id#&str_table=INVOICE&branch_id=document.inventSale.branch_id.value','page','add_process')";
		}
		/*
		if(GET_INVOICE.INVOICE_TYPE_CODE eq 'SATIS' and GET_INVOICE.use_efatura eq 1)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['text'] = 'e-fatura';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['customTag'] = '<cf_wrk_efatura_display action_id="#attributes.invoice_id#" action_type="INVOICE" action_date="#get_invoice.invoice_date#">';
		}
		*/
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = 'Ekle';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=invent.add_invent_sale";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_type=#GET_INVOICE.invoice_cat#&iid=#attributes.invoice_id#&print_type=350','page')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'inventSale';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'INVOICE';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-1','item-2','item-4','item-7','item-8','item-9']";
	/*
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'finance.list_creditcard';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'finance/form/add_creditcard.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'finance/query/add_creditcard.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'finance.list_creditcard&event=upd';
	
	if(IsDefined("attributes.event") && attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=finance.list_creditcard&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	} */
</cfscript>