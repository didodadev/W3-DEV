<cf_get_lang_set module_name="invent">
<cf_xml_page_edit fuseact="invent.add_invent_purchase">
<cfparam name="attributes.sale" default="0" >
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
<cfquery name="KASA" datasource="#DSN2#">
    SELECT * FROM CASH WHERE CASH_ACC_CODE IS NOT NULL ORDER BY CASH_NAME
</cfquery>
 <cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS = <cfqueryparam value="#variable#" cfsqltype="cf_sql_smallint">
</cfquery>
<cfset attributes.kur_say = GET_MONEY.recordcount>
<cfquery name="GET_INVOICE_MONEY" datasource="#DSN#">
    SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS = <cfqueryparam value="1" cfsqltype="cf_sql_smallint">
</cfquery>
<cfquery name="GET_TAX" datasource="#DSN2#">
    SELECT * FROM SETUP_TAX ORDER BY TAX
</cfquery>
<cfquery name="GET_OTV" datasource="#DSN3#">
    SELECT TAX FROM SETUP_OTV WHERE PERIOD_ID = #session.ep.period_id# ORDER BY TAX
</cfquery>
<cfquery name="GET_EXPENSE_CENTER" datasource="#DSN2#">
    SELECT EXPENSE_ID,EXPENSE,EXPENSE_CODE FROM EXPENSE_CENTER ORDER BY EXPENSE
</cfquery>
    
<cfif  not IsDefined("attributes.event") or attributes.event eq 'add' >
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
	<cfif isdefined('attributes.company_id') and len(attributes.company_id) >
        <cfquery name="get_manager_partner" datasource="#dsn#">
            SELECT MANAGER_PARTNER_ID FROM COMPANY WHERE COMPANY_ID = #attributes.company_id#
        </cfquery>
    </cfif>
    <cfquery name="GET_SALE_DET" datasource="#dsn2#">
        SELECT 
            ACC_DEPARTMENT_ID
        FROM
            INVOICE
        WHERE
            INVOICE_CAT <> 67 AND
            INVOICE_CAT <> 69
    </cfquery>
    <cfif isdefined("attributes.receiving_detail_id")>
		<!--- Gelen e-fatura sayfasindaki xml degerleri aliniyor. --->
        <cf_xml_page_edit fuseact="objects.popup_dsp_efatura_detail">
        <cfquery name="GET_INV_DET" datasource="#DSN2#">
            SELECT ISSUE_DATE,EINVOICE_ID FROM EINVOICE_RECEIVING_DETAIL WHERE RECEIVING_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.receiving_detail_id#"> 
        </cfquery>
    </cfif>
    <cfif session.ep.our_company_info.is_efatura eq 1 >
        <cfquery name="get_credit_info" datasource="#dsn3#">
            SELECT CREDITCARD_ID,INSTALLMENT_NUMBER,DELAY_INFO FROM CREDIT_CARD_BANK_EXPENSE WHERE  ACTION_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
        </cfquery>
    </cfif>
    
    <script type="text/javascript">
	record_exist=0;//Row_kontrol değeri 1 olan yani silinmemiş satırların varlığını kontrol ediyor
	function add_adress()
	{
		if(!(document.getElementById('company_id').value=="") || !(document.getElementById('consumer_id').value=="") || !(document.getElementById('employee_id').value==""))
		{
			if(document.getElementById('company_id').value!="")
			{
				str_adrlink = '&field_long_adres=inventPurchase.adres&field_adress_id=inventPurchase.ship_address_id&is_compname_readonly=1';
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(inventPurchase.comp_name.value)+''+ str_adrlink , 'list');
				return true;
			}
			else
			{
				str_adrlink = '&field_long_adres=inventPurchase.adres&field_adress_id=inventPurchase.ship_address_id&is_compname_readonly=1';
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(inventPurchase.partner_name.value)+''+ str_adrlink , 'list');
				return true;
			}
		}
		else
		{
			alert('Cari Hesap Seçmelisiniz');
			return false;
		}
	}
	function kontrol()
	{
		if(!chk_process_cat('inventPurchase')) return false;
		if(!check_display_files('inventPurchase')) return false;
		if(inventPurchase.department_id.value=="")
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='1351.Depo'>");
			return false;
		}
		<cfif xml_is_department eq 2>
			if( document.all.acc_department_id.options[document.all.acc_department_id.selectedIndex].value=="")
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='160.Departman'>");
				return false;
			} 
		</cfif>
		<cfif xml_project_require eq 1>
			if(document.getElementById("project_id") != undefined && document.getElementById("project_id").value == "" && document.getElementById("project_head").value == "")
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='4.Proje'>");
				return false;
			} 
		</cfif>
		if(document.getElementById("comp_name").value == ""  && document.getElementById("consumer_id").value == "" && document.getElementById("emp_id").value == "")
		{ 
			alert ("<cf_get_lang no='8.Cari Hesap Seçmelisiniz'>!");
			return false;
		}
		   
		process=document.getElementById("process_cat").value;
		var get_process_cat = wrk_safe_query('acc_process_cat','dsn3',0,process);
		if(get_process_cat.IS_ACCOUNT ==1)
		{
			if (document.getElementById("comp_name").value != "" && document.getElementById("member_code").value=="")
			{ 
				alert("<cf_get_lang no='19.Seçtiğiniz Üyenin Muhasebe Kodu Seçilmemiş'>!");
				return false;
			}
		}
		if(document.getElementById("credit").checked == true)
		{		
			if(document.getElementById("credit_card_info").value == '')
			{
				alert("Lütfen Kredi Kartı Seçiniz");
				return false;
			}
		}
		
		for(r=1;r<=row_count;r++)
		{
			if(document.getElementById("row_kontrol"+r).value == 1)
			{
				record_exist=1;
				if (document.getElementById("invent_no"+r).value == "")
				{ 
					alert ("<cf_get_lang no='88.Lütfen Demirbaş No Giriniz'>!");
					return false;
				}
				if (document.getElementById("invent_name"+r).value == "")
				{ 
					alert ("<cf_get_lang no='93.Lütfen Açıklama Giriniz'> !");
					return false;
				}
				if ((document.getElementById("row_total"+r).value == "")||(document.getElementById("row_total"+r).value ==0))
				{ 
					alert ("<cf_get_lang_main no='1738.Lütfen Tutar Giriniz '>!");
					return false;
				}
				if ((document.getElementById("amortization_rate"+r).value == "")||(document.getElementById("amortization_rate"+r).value < 0))
				{ 
					alert ("<cf_get_lang no='95.Lütfen Amortisman Oranı Giriniz'> !");
					return false;
				}
				if (document.getElementById("account_id"+r).value == "")
				{ 
					alert ("<cf_get_lang no='96.Lütfen Muhasebe Kodu Seçiniz'>!");
					return false;
				}
			}
		}
		change_paper_duedate('invoice_date');
		if(!chk_period(inventPurchase.invoice_date,"İşlem")) return false;
		if (record_exist == 0) 
		{
			alert("<cf_get_lang no='90.Lütfen Demirbaş Giriniz'>!");
			return false;
		}
		unformat_fields();
		return true;
	}
	
	function amortisman_kontrol(x)
	{
		deger_amortization_rate = document.getElementById("amortization_rate"+x);
		if(filterNum(deger_amortization_rate.value) >100)
		{ 
			alert ("<cf_get_lang no='67.Amortisman Oranı 100 den Büyük Olamaz'> !");
			deger_amortization_rate.value = 0;
			return false;
		}
		return true;
	}
	
	function period_kontrol(no)
	{
		deger = document.getElementById("period"+no);
		if ((filterNum(deger.value) <1) || (deger.value==""))
		{ 
			alert ("<cf_get_lang no='66.Hesaplama Dönemi 1 den Küçük Olamaz'>!");
			deger.value =1;
			return false;
		}
		return true;
	}
	
	function unformat_fields()
	{
		for(r=1;r<=row_count;r++)
		{
			deger_total = document.getElementById("row_total"+r);
			deger_total2 = document.getElementById("row_total2"+r);
			deger_kdv_total= document.getElementById("kdv_total"+r);
			deger_otv_total= document.getElementById("otv_total"+r);
			deger_net_total = document.getElementById("net_total"+r);
			deger_other_net_total = document.getElementById("row_other_total"+r);
			deger_amortization_rate = document.getElementById("amortization_rate"+r);
			deger_miktar= document.getElementById("quantity"+r);
			temp_inventory_duration= document.getElementById("inventory_duration"+r);
			
			deger_miktar.value = filterNum(deger_miktar.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_total.value = filterNum(deger_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_total2.value = filterNum(deger_total2.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_kdv_total.value = filterNum(deger_kdv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_otv_total.value = filterNum(deger_otv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_net_total.value = filterNum(deger_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_other_net_total.value = filterNum(deger_other_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_amortization_rate.value = filterNum(deger_amortization_rate.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			temp_inventory_duration.value=filterNum(temp_inventory_duration.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		}
		document.getElementById("total_amount").value = filterNum(document.getElementById("total_amount").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("kdv_total_amount").value = filterNum(document.getElementById("kdv_total_amount").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>); 
		document.getElementById("otv_total_amount").value = filterNum(document.getElementById("otv_total_amount").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>); 
		document.getElementById("net_total_amount").value = filterNum(document.getElementById("net_total_amount").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("other_total_amount").value = filterNum(document.getElementById("other_total_amount").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("other_kdv_total_amount").value = filterNum(document.getElementById("other_kdv_total_amount").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>); 
		document.getElementById("other_otv_total_amount").value = filterNum(document.getElementById("other_otv_total_amount").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>); 
		document.getElementById("other_net_total_amount").value = filterNum(document.getElementById("other_net_total_amount").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("net_total_discount").value = filterNum(document.getElementById("net_total_discount").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("tevkifat_oran").value = filterNum(document.getElementById("tevkifat_oran").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("stopaj_yuzde").value = filterNum(document.getElementById("stopaj_yuzde").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("stopaj").value = filterNum(document.getElementById("stopaj").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		for(s=1;s<=document.getElementById("kur_say").value;s++)
		{
			document.getElementById("txt_rate2_" + s).value = filterNum(document.getElementById("txt_rate2_" + s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			document.getElementById("txt_rate1_" + s).value = filterNum(document.getElementById("txt_rate1_" + s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
	}
	
	row_count=0;
	function sil(sy)
	{
		var my_element=document.getElementById("row_kontrol"+sy);
		my_element.value=0;
		var my_element=document.getElementById("frm_row"+sy);
		my_element.style.display="none";
		toplam_hesapla();
	}
	
	function hesapla(satir,hesap_type)
	{ 
		var toplam_dongu_0 = 0;//satir toplam
		if(document.getElementById("row_kontrol"+satir).value==1)
		{
			deger_total = document.getElementById("row_total"+satir);//tutar
			deger_total2 = document.getElementById("row_total2"+satir);//dövizli tutar
			deger_miktar = document.getElementById("quantity"+satir);//miktar
			deger_kdv_total= document.getElementById("kdv_total"+satir);//kdv tutarı
			deger_otv_total= document.getElementById("otv_total"+satir);//otv tutarı
			deger_net_total = document.getElementById("net_total"+satir);//kdvli tutar
			deger_tax_rate = document.getElementById("tax_rate"+satir);//kdv oranı
			deger_otv_rate = document.getElementById("otv_rate"+satir);//otv oranı
			deger_other_net_total = document.getElementById("row_other_total"+satir);//dovizli tutar kdv dahil
			if(deger_total.value == "") deger_total.value = 0;
			if(deger_kdv_total.value == "") deger_kdv_total.value = 0;
			if(deger_net_total.value == "") deger_net_total.value = 0;
			deger_money_id = document.getElementById("money_id"+satir);
			deger_money_id_ilk = list_getat(deger_money_id.value,2,',');
			deger_money_id_son = list_getat(deger_money_id.value,3,',');
			deger_total.value = filterNum(deger_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_total2.value = filterNum(deger_total2.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_kdv_total.value = filterNum(deger_kdv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_otv_total.value = filterNum(deger_otv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_net_total.value = filterNum(deger_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_other_net_total.value = filterNum(deger_other_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_miktar.value = filterNum(deger_miktar.value,0);
			for(s=1;s<=inventPurchase.kur_say.value;s++)
			{
				if(list_getat(document.inventPurchase.rd_money[s-1].value,1,',') == list_getat(deger_money_id.value,1,','))
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
		var toplam_dongu_4 = 0;// fatura alti indirim
		var toplam_dongu_5 = 0;// ötv genel toplam
		var beyan_tutar = 0;
		var tevkifat_info = "";
		var beyan_tutar_info = "";
		var new_taxArray = new Array(0);
		var taxBeyanArray = new Array(0);
		var taxTevkifatArray = new Array(0);
		for(r=1;r<=row_count;r++)
		{
			if(document.getElementById("row_kontrol"+r).value==1)
			{
				toplam_dongu_4 = toplam_dongu_4 + (parseFloat(filterNum(document.getElementById("row_total"+r).value)) * parseFloat(filterNum(document.getElementById("quantity"+r).value)));
			}
		}			
		deger_discount_value = filterNum(document.getElementById('net_total_discount').value,8);
		genel_indirim_yuzdesi = commaSplit((parseFloat(deger_discount_value) / parseFloat(toplam_dongu_4)).toFixed(8),8);		
		genel_indirim_yuzdesi = filterNum(genel_indirim_yuzdesi,8);
		genel_indirim_yuzdesi = wrk_round(genel_indirim_yuzdesi,8);
		
		for(r=1;r<=row_count;r++)
		{
			if(document.getElementById("row_kontrol"+r).value==1)
			{
				deger_total = document.getElementById("row_total"+r);//tutar
				deger_total2 = document.getElementById("row_total2"+r);//dövizli tutar
				deger_miktar = document.getElementById("quantity"+r);//miktar
				deger_kdv_total= document.getElementById("kdv_total"+r);//kdv tutarı
				deger_otv_total= document.getElementById("otv_total"+r);//ötv tutarı
				deger_net_total = document.getElementById("net_total"+r);//kdvli tutar
				deger_tax_rate = document.getElementById("tax_rate"+r);//kdv oranı
				deger_other_net_total = document.getElementById("row_other_total"+r);//dovizli tutar kdv dahil
				deger_money_id = document.getElementById("money_id"+r);
				deger_money_id_ilk = list_getat(deger_money_id.value,1,',');
				
				for(s=1;s<=document.getElementById("kur_say").value;s++)
				{
					if(list_getat(document.all.rd_money[s-1].value,1,',') == deger_money_id_ilk)
					{
						satir_rate2= document.getElementById("txt_rate2_"+s).value;
					}
				}
				satir_rate2= filterNum(satir_rate2,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				deger_money_id_son = list_getat(deger_money_id.value,3,',');
				deger_total.value = filterNum(deger_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_total2.value = filterNum(deger_total2.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_kdv_total.value = filterNum(deger_kdv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_otv_total.value = filterNum(deger_otv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				toplam_dongu_2 = toplam_dongu_2 + parseFloat(deger_kdv_total.value)- parseFloat(deger_kdv_total.value)*parseFloat(genel_indirim_yuzdesi);
				toplam_dongu_5 = toplam_dongu_5 + parseFloat(deger_otv_total.value);
				deger_indirim_kdv = parseFloat(deger_kdv_total.value)- parseFloat(deger_kdv_total.value)*parseFloat(genel_indirim_yuzdesi);
				toplam_dongu_3 = (toplam_dongu_3 + ((parseFloat(deger_total.value)- (parseFloat(deger_total.value)*parseFloat(genel_indirim_yuzdesi)))) * filterNum(document.getElementById("quantity"+r).value));
				toplam_dongu_3 = toplam_dongu_3 + parseFloat(deger_kdv_total.value)- parseFloat(deger_kdv_total.value)*parseFloat(genel_indirim_yuzdesi);
				toplam_dongu_3 = toplam_dongu_3 + parseFloat(deger_otv_total.value);
				if(document.getElementById("tevkifat_oran") != undefined && document.getElementById("tevkifat_oran").value != "" && document.getElementById("tevkifat_box").checked == true)
				{//tevkifat hesaplamaları
					beyan_tutar = beyan_tutar + wrk_round(deger_indirim_kdv*filterNum(document.getElementById("tevkifat_oran").value));
					if(new_taxArray.length != 0)
						for (var m=0; m < new_taxArray.length; m++)
						{	
							var tax_flag = false;
							if(new_taxArray[m] == deger_tax_rate.value){
								tax_flag = true;
								taxBeyanArray[m] += wrk_round(deger_indirim_kdv - (deger_indirim_kdv*(filterNum(document.getElementById("tevkifat_oran").value))));
								taxTevkifatArray[m] += wrk_round(deger_indirim_kdv*(filterNum(document.getElementById("tevkifat_oran").value)));
								break;
							}
						}
					if(!tax_flag){
						new_taxArray[new_taxArray.length] = deger_tax_rate.value;
						taxBeyanArray[taxBeyanArray.length] = wrk_round(deger_indirim_kdv - (deger_indirim_kdv*(filterNum(document.getElementById("tevkifat_oran").value))));
						taxTevkifatArray[taxTevkifatArray.length] = wrk_round(deger_indirim_kdv*(filterNum(document.getElementById("tevkifat_oran").value)));
					}
				}
				deger_net_total.value = filterNum(deger_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_other_net_total.value = filterNum(deger_other_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				toplam_dongu_1 = toplam_dongu_1 + parseFloat(deger_total.value * deger_miktar.value);
				deger_other_net_total.value = ((parseFloat(deger_total.value * deger_miktar.value) + parseFloat(deger_kdv_total.value) + parseFloat(deger_otv_total.value)) / (parseFloat(satir_rate2)));
				
				deger_net_total.value = commaSplit(deger_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_total.value = commaSplit(deger_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_total2.value = commaSplit(deger_total2.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_kdv_total.value = commaSplit(deger_kdv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_otv_total.value = commaSplit(deger_otv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_other_net_total.value = commaSplit(deger_other_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			}
		}
		if(document.getElementById("tevkifat_oran") != undefined && document.getElementById("tevkifat_oran").value != "" && document.getElementById("tevkifat_box").checked == true)
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
		document.getElementById("total_amount").value = commaSplit(toplam_dongu_1,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("kdv_total_amount").value = commaSplit(toplam_dongu_2,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("otv_total_amount").value = commaSplit(toplam_dongu_5,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("net_total_amount").value = commaSplit(toplam_dongu_3,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		for(s=1;s<=document.getElementById("kur_say").value;s++)
		{
			form_txt_rate2_ = document.getElementById("txt_rate2_"+s);
			if(form_txt_rate2_.value == "")
				form_txt_rate2_.value = 1;
		}
		if(document.getElementById("kur_say").value == 1)
			for(s=1;s<=document.getElementById("kur_say").value;s++)
			{
				if(document.getElementById("rd_money").checked == true)
				{
					deger_diger_para = document.getElementById("rd_money");
					form_txt_rate2_ = document.getElementById("txt_rate2_"+s);
				}
			}
		else 
			for(s=1;s<=document.getElementById("kur_say").value;s++)
			{
				if(document.all.rd_money[s-1].checked == true)
				{
					deger_diger_para = document.all.rd_money[s-1];
					form_txt_rate2_ = document.getElementById("txt_rate2_"+s);
				}
			}
		deger_money_id_1 = list_getat(deger_diger_para.value,1,',');
		deger_money_id_3 = list_getat(deger_diger_para.value,3,',');
		form_txt_rate2_.value = filterNum(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("other_total_amount").value = commaSplit(toplam_dongu_1 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("other_kdv_total_amount").value = commaSplit(toplam_dongu_2 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("other_otv_total_amount").value = commaSplit(toplam_dongu_5 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("other_net_total_amount").value = commaSplit(toplam_dongu_3 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("other_net_total_discount").value = commaSplit(deger_discount_value* parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("net_total_discount").value = commaSplit(deger_discount_value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		
		document.getElementById("tl_value1").value = deger_money_id_1;
		document.getElementById("tl_value2").value = deger_money_id_1;	//kdv
		document.getElementById("tl_value5").value = deger_money_id_1;	//otv
		document.getElementById("tl_value3").value = deger_money_id_1;
		document.getElementById("tl_value4").value = deger_money_id_1;
		
		form_txt_rate2_.value = commaSplit(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	}
	
	function add_row(inventory_cat_id,inventory_cat,invent_no,invent_name,quantity,row_total,row_total2,tax_rate,otv_rate,kdv_total,otv_total,net_total,row_other_total,money_id,inventory_duration,amortization_rate,amortization_method,amortization_type,account_id,account_code,expense_center_id,expense_center_name,expense_item_id,expense_item_name,period,debt_account_id,debt_account_code,claim_account_id,claim_account_code,product_id,stock_id,product_name,stock_unit_id,stock_unit)
	{
		if (inventory_cat_id == undefined) inventory_cat_id ="";
		if (inventory_cat == undefined) inventory_cat ="";
		if (invent_no == undefined) invent_no ="";
		if (invent_name == undefined) invent_name ="";
		if (quantity == undefined) quantity = 1;
		if (row_total == undefined) row_total = 0;
		if (row_total2 == undefined) row_total2 = 0;
		if (tax_rate == undefined) tax_rate ="";
		if (otv_rate == undefined) otv_rate ="";
		if (kdv_total == undefined) kdv_total = 0;
		if (otv_total == undefined) otv_total = 0;
		if (net_total == undefined) net_total = 0;
		if (row_other_total == undefined) row_other_total = 0;
		if (money_id == undefined) money_id ="";
		if (inventory_duration == undefined) inventory_duration ="";
		if (amortization_rate == undefined) amortization_rate ="";
		if (amortization_method == undefined) amortization_method ="";
		if (amortization_type == undefined) amortization_type ="";
		if (account_id == undefined) account_id ="";
		if (account_code == undefined) account_code ="";
		if (expense_center_id == undefined) expense_center_id ="";
		if (expense_center_name == undefined) expense_center_name ="";
		if (expense_item_id == undefined) expense_item_id ="";
		if (expense_item_name == undefined) expense_item_name ="";
		if (period == undefined) period = 12;
		if (debt_account_id == undefined) debt_account_id ="";
		if (debt_account_code == undefined) debt_account_code ="";
		if (claim_account_id == undefined) claim_account_id ="";
		if (claim_account_code == undefined) claim_account_code ="";
		if (product_id == undefined) product_id ="";
		if (stock_id == undefined) stock_id ="";
		if (product_name == undefined) product_name ="";
		if (stock_unit_id == undefined) stock_unit_id ="";
		if (stock_unit == undefined) stock_unit ="";
	
		row_count++;
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
		newCell.setAttribute("nowrap","nowrap");
		x = '<input type="hidden" value="WRK'+row_count+ js_create_unique_id() + row_count+'" name="wrk_row_id' + row_count +'" id="wrk_row_id' + row_count +'"><input  type="hidden" value="" id="wrk_row_relation_id' + row_count +'" name="wrk_row_relation_id' + row_count +'">';
		newCell.innerHTML = x + '<input  type="hidden" value="1" id="row_kontrol' + row_count +'" name="row_kontrol' + row_count +'"><a style="cursor:pointer" onclick="copy_row('+row_count+');" title="<cf_get_lang_main no="1560.Satır Kopyala">"><img  src="images/copy_list.gif" border="0"></a><a href="javascript://" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input  type="hidden" id="inventory_cat_id' + row_count +'" name="inventory_cat_id' + row_count +'" value="' + inventory_cat_id +'"><input type="text" style="width:132px;" id="inventory_cat' + row_count +'" name="inventory_cat' + row_count +'" value="' + inventory_cat +'" class="boxtext"><a href="javascript://" onClick="open_inventory_cat_list('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="invent_no' + row_count +'" name="invent_no' + row_count +'" value="' + invent_no +'" style="width:100%;" class="boxtext" maxlength="50">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="invent_name' + row_count +'" name="invent_name' + row_count +'" value="' + invent_name +'" style="width:100px;" class="boxtext" maxlength="100">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="quantity' + row_count +'" name="quantity' + row_count +'" value="' + quantity +'" style="width:100%;" class="box" onBlur="hesapla(' + row_count +');" onkeyup="return(FormatCurrency(this,event));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="row_total' + row_count +'" name="row_total' + row_count +'" value="' + row_total +'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" onBlur="hesapla(' + row_count +');" style="width:100%;" class="box">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="row_total2' + row_count +'" name="row_total2' + row_count +'" value="' + row_total2 +'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" onBlur="hesapla(' + row_count +',1);" style="width:100%;" class="box">';
		//kdv orani
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		a = '<select id="tax_rate'+ row_count +'" name="tax_rate'+ row_count +'" style="width:100%;" onChange="hesapla('+ row_count +');" class="box">';
			<cfoutput query="get_tax">
				if('#tax#' == tax_rate)
					a += '<option value="#tax#" selected>#tax#</option>';
				else
					a += '<option value="#tax#">#tax#</option>';
			</cfoutput>
		newCell.innerHTML = a+ '</select>';
		//otv orani
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		x = '<select id="otv_rate'+ row_count +'" name="otv_rate'+ row_count +'" style="width:100%;" onChange="hesapla('+ row_count +');" class="box">';
			<cfoutput query="get_otv">
				if('#tax#' == otv_rate)
					x += '<option value="#tax#" selected>#tax#</option>';
				else
					x += '<option value="#tax#">#tax#</option>';
			</cfoutput>
		newCell.innerHTML = x+ '</select>';
		//kdv total
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="kdv_total' + row_count +'" name="kdv_total' + row_count +'" value="' + kdv_total +'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" style="width:60px;" onBlur="hesapla(' + row_count +',1);" class="box">';
		//otv total
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="otv_total' + row_count +'" name="otv_total' + row_count +'" value="' + otv_total +'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" style="width:60px;" onBlur="hesapla(' + row_count +',1);" class="box">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="net_total' + row_count +'" name="net_total' + row_count +'" value="' + net_total +'" style="width:100%;" class="box" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" onblur="hesapla(' + row_count +',3);">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="row_other_total' + row_count +'" name="row_other_total' + row_count +'" value="' + row_other_total +'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" style="width:100%;" class="box" onblur="hesapla(' + row_count +',4);">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		b = '<select id="money_id' + row_count  +'" name="money_id' + row_count  +'" style="width:100%;" class="boxtext" onChange="hesapla('+ row_count +');">';
			<cfoutput query="GET_INVOICE_MONEY">
				if('#money#,#rate1#,#rate2#' == money_id)
					b += '<option value="#money#,#rate1#,#rate2#" selected>#money#</option>';
				else
					b += '<option value="#money#,#rate1#,#rate2#">#money#</option>';
			</cfoutput>
		newCell.innerHTML = b+ '</select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="inventory_duration' + row_count +'" name="inventory_duration' + row_count +'" value="' + inventory_duration +'" style="width:100%;" class="box" onkeyup="return(FormatCurrency(this,event));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="amortization_rate' + row_count +'" name="amortization_rate' + row_count +'" value="' + amortization_rate +'" style="width:100%;" class="box" onblur="return(amortisman_kontrol(' + row_count +'));" onkeyup="return(FormatCurrency(this,event));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<select id="amortization_method'+ row_count +'" name="amortization_method'+ row_count +'" style="width:165px;" class="box"><option value="0" ><cf_get_lang_main no="1624.Azalan Bakiye Üzerinden"></option><option value="1" ><cf_get_lang_main no="1625.Sabit Miktar Üzeriden"></option><option value="2" ><cf_get_lang_main no="1626.Hızlandırılmış Azalan Bakiye"></option><option value="3"><cf_get_lang_main no="1627.Hızlandırılmış Sabit Değer"></option></select>';
		if(amortization_method != '')
			document.getElementById('amortization_method'+ row_count).value = amortization_method;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select id="amortization_type'+ row_count +'" name="amortization_type'+ row_count +'" style="width:185px;" class="box"><option value="1">Kıst Amortismana Tabi</option><option value="2" selected>Kıst Amortismana Tabi Değil</option>></select>';
		if(amortization_type != '')
			document.getElementById('amortization_type'+ row_count).value = amortization_type;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" id="account_id' + row_count +'" name="account_id' + row_count +'" value="' + account_id +'"><input type="text" style="width:110px;" id="account_code' + row_count +'" name="account_code' + row_count +'" value="' + account_code +'" class="boxtext" onFocus="autocomp_account('+row_count+');"><a href="javascript://"><a href="javascript://" onClick="pencere_ac_acc('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML ='<input type="hidden" name="expense_center_id' + row_count +'" value="'+expense_center_id+'" id="expense_center_id' + row_count +'"><input type="text" id="expense_center_name' + row_count +'" name="expense_center_name' + row_count +'" onFocus="exp_center('+row_count+');" value="'+expense_center_name+'" style="width:150px;" class="boxtext"><a href="javascript://" onClick="pencere_ac_exp_center('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" id="expense_item_id' + row_count +'" name="expense_item_id' + row_count +'" value="' + expense_item_id +'"><input type="text" style="width:120px;" id="expense_item_name' + row_count +'" name="expense_item_name' + row_count +'" value="' + expense_item_name +'" class="boxtext" onFocus="exp_item('+row_count+');"><a href="javascript://"><img src="/images/plus_thin.gif" onclick="pencere_ac_exp('+ row_count +');" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="period' + row_count +'" name="period' + row_count +'" value="' + period +'" style="width:100%;" class="box" onblur="return(period_kontrol(' + row_count +'));" onkeyup="return(FormatCurrency(this,event,0));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" id="debt_account_id' + row_count +'" name="debt_account_id' + row_count +'" value="' + debt_account_id +'"><input type="text" id="debt_account_code' + row_count +'" name="debt_account_code' + row_count +'" value="' + debt_account_code +'" style="width:185px;" class="boxtext" onFocus="autocomp_debt_account('+row_count+');"> <a href="javascript://" onClick="pencere_ac_acc2('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" id="claim_account_id' + row_count +'" name="claim_account_id' + row_count +'" value="' + claim_account_id +'"><input type="text" id="claim_account_code' + row_count +'" name="claim_account_code' + row_count +'" value="' + claim_account_code +'" style="width:201px;" class="boxtext" onFocus="autocomp_claim_account('+row_count+');"><a href="javascript://" onClick="pencere_ac_acc1('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input  type="hidden" id="product_id' + row_count +'" name="product_id' + row_count +'" value="' + product_id +'"><input  type="hidden" id="stock_id' + row_count +'" name="stock_id' + row_count +'" value="' + stock_id +'"><input type="text" id="product_name' + row_count +'" name="product_name' + row_count +'" value="' + product_name +'" style="width:90px;" class="boxtext" maxlength="75" onFocus="AutoComplete_Create(\'product_name' + row_count +'\',\'PRODUCT_NAME\',\'PRODUCT_NAME,STOCK_CODE\',\'get_product_autocomplete\',\'0\',\'PRODUCT_ID,STOCK_ID,MAIN_UNIT,PRODUCT_UNIT_ID\',\'product_id' + row_count +',stock_id' + row_count +',stock_unit' + row_count  +',stock_unit_id' + row_count  +'\',\'inventPurchase\',1,\'\',\'\');"><a href="javascript://" onClick=""><a href="javascript://" onClick=" windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&product_id=product_id" + row_count + "&field_id=stock_id" + row_count + "&field_unit_name=stock_unit" + row_count + "&field_main_unit=stock_unit_id" + row_count + "&field_name=product_name" + row_count + "','list');"+'"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" id="stock_unit_id' + row_count +'" name="stock_unit_id' + row_count +'" value="' + stock_unit_id +'"><input type="text" id="stock_unit' + row_count +'" name="stock_unit' + row_count +'" value="' + stock_unit +'" style="width:100%;" class="boxtext">';
	}
	
	function copy_row(no_info)
	{
		if (document.getElementById("inventory_cat_id" + no_info) == undefined) inventory_cat_id =""; else inventory_cat_id = document.getElementById("inventory_cat_id" + no_info).value;
		if (document.getElementById("inventory_cat" + no_info) == undefined) inventory_cat =""; else inventory_cat = document.getElementById("inventory_cat" + no_info).value;
		if (document.getElementById("invent_no" + no_info) == undefined) invent_no =""; else invent_no = document.getElementById("invent_no" + no_info).value;
		if (document.getElementById("invent_name" + no_info) == undefined) invent_name =""; else invent_name = document.getElementById("invent_name" + no_info).value;
		if (document.getElementById("quantity" + no_info) == undefined) quantity =""; else quantity = document.getElementById("quantity" + no_info).value;
		if (document.getElementById("row_total" + no_info) == undefined) row_total =""; else row_total = document.getElementById("row_total" + no_info).value;
		if (document.getElementById("row_total2" + no_info) == undefined) row_total2 =""; else row_total2 = document.getElementById("row_total2" + no_info).value;
		if (document.getElementById("tax_rate" + no_info) == undefined) tax_rate =""; else tax_rate = document.getElementById("tax_rate" + no_info).value;
		if (document.getElementById("otv_rate" + no_info) == undefined) otv_rate =""; else otv_rate = document.getElementById("otv_rate" + no_info).value;
		if (document.getElementById("kdv_total" + no_info) == undefined) kdv_total =""; else kdv_total = document.getElementById("kdv_total" + no_info).value;
		if (document.getElementById("otv_total" + no_info) == undefined) otv_total =""; else otv_total = document.getElementById("otv_total" + no_info).value;
		if (document.getElementById("net_total" + no_info) == undefined) net_total =""; else net_total =  document.getElementById("net_total" + no_info).value;
		if (document.getElementById("row_other_total" + no_info) == undefined) row_other_total =""; else row_other_total = document.getElementById("row_other_total" + no_info).value;
		if (document.getElementById("money_id" + no_info) == undefined) money_id =""; else money_id = document.getElementById("money_id" + no_info).value;
		if (document.getElementById("inventory_duration" + no_info) == undefined) inventory_duration =""; else inventory_duration = document.getElementById("inventory_duration" + no_info).value;
		if (document.getElementById("amortization_rate" + no_info) == undefined) amortization_rate =""; else amortization_rate = document.getElementById("amortization_rate" + no_info).value;
		if (document.getElementById("amortization_method" + no_info) == undefined) amortization_method =""; else amortization_method = document.getElementById("amortization_method" + no_info).value;
		if (document.getElementById("amortization_type" + no_info) == undefined) amortization_type =""; else amortization_type = document.getElementById("amortization_type" + no_info).value;
		if (document.getElementById("account_id" + no_info) == undefined) account_id =""; else account_id =  document.getElementById("account_id" + no_info).value;
		if (document.getElementById("account_code" + no_info) == undefined) account_code =""; else account_code = document.getElementById("account_code" + no_info).value;
		if (document.getElementById("expense_center_id" + no_info) == undefined) expense_center_id =""; else expense_center_id = document.getElementById("expense_center_id" + no_info).value;
		if (document.getElementById("expense_center_name" + no_info) == undefined) expense_center_name =""; else expense_center_name = document.getElementById("expense_center_name" + no_info).value;
		if (document.getElementById("expense_item_id" + no_info) == undefined) expense_item_id =""; else expense_item_id = document.getElementById("expense_item_id" + no_info).value;
		if (document.getElementById("expense_item_name" + no_info) == undefined) expense_item_name =""; else expense_item_name = document.getElementById("expense_item_name" + no_info).value;
		if (document.getElementById("period" + no_info) == undefined) period =""; else period = document.getElementById("period" + no_info).value;
		if (document.getElementById("debt_account_id" + no_info) == undefined) debt_account_id =""; else debt_account_id = document.getElementById("debt_account_id" + no_info).value;
		if (document.getElementById("debt_account_code" + no_info) == undefined) debt_account_code =""; else debt_account_code = document.getElementById("debt_account_code" + no_info).value;
		if (document.getElementById("claim_account_id" + no_info) == undefined) claim_account_id =""; else claim_account_id = document.getElementById("claim_account_id" + no_info).value;
		if (document.getElementById("claim_account_code" + no_info) == undefined) claim_account_code =""; else claim_account_code = document.getElementById("claim_account_code" + no_info).value;
		if (document.getElementById("product_id" + no_info) == undefined) product_id =""; else product_id = document.getElementById("product_id" + no_info).value;
		if (document.getElementById("stock_id" + no_info) == undefined) stock_id =""; else stock_id = document.getElementById("stock_id" + no_info).value;
		if (document.getElementById("product_name" + no_info) == undefined) product_name =""; else product_name = document.getElementById("product_name" + no_info).value;
		if (document.getElementById("stock_unit_id" + no_info) == undefined) stock_unit_id =""; else stock_unit_id = document.getElementById("stock_unit_id" + no_info).value;
		if (document.getElementById("stock_unit" + no_info) == undefined) stock_unit =""; else stock_unit = document.getElementById("stock_unit" + no_info).value;
		
		add_row(inventory_cat_id,inventory_cat,invent_no,invent_name,quantity,row_total,row_total2,tax_rate,otv_rate,kdv_total,otv_total,net_total,row_other_total,money_id,inventory_duration,amortization_rate,amortization_method,amortization_type,account_id,account_code,expense_center_id,expense_center_name,expense_item_id,expense_item_name,period,debt_account_id,debt_account_code,claim_account_id,claim_account_code,product_id,stock_id,product_name,stock_unit_id,stock_unit);
		hesapla(row_count);
	}
	/* masraf merkezi popup */
	function pencere_ac_exp_center(no)
	{ 
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=inventPurchase.expense_center_id' + no +'&field_name=inventPurchase.expense_center_name' + no,'list');
	}
	/* masraf merkezi autocomplete */
	function exp_center(no)
	{
		AutoComplete_Create("expense_center_name" + no,"EXPENSE,EXPENSE_CODE","EXPENSE,EXPENSE_CODE","get_expense_center","","EXPENSE_ID","expense_center_id"+no,"",3);
	}
	/* gider kalemi autocomplete */
	function exp_item(no)
	{
		AutoComplete_Create("expense_item_name" + no,"EXPENSE_ITEM_NAME","EXPENSE_ITEM_NAME","get_expense_item","","EXPENSE_ITEM_ID,ACCOUNT_CODE,ACCOUNT_CODE","expense_item_id"+no+",debt_account_code"+no+",debt_account_id"+no,"",3);
	}
	function autocomp_account(no)
	{
		AutoComplete_Create("account_code"+no,"ACCOUNT_CODE,ACCOUNT_NAME","ACCOUNT_CODE,ACCOUNT_NAME","get_account_code","0","ACCOUNT_CODE","account_id"+no,"",3);
	}
	function autocomp_debt_account(no)
	{
		AutoComplete_Create("debt_account_code"+no,"ACCOUNT_CODE,ACCOUNT_NAME","ACCOUNT_CODE,ACCOUNT_NAME","get_account_code","0","ACCOUNT_CODE","debt_account_id"+no,"",3);
	}
	function autocomp_claim_account(no)
	{
		AutoComplete_Create("claim_account_code"+no,"ACCOUNT_CODE,ACCOUNT_NAME","ACCOUNT_CODE,ACCOUNT_NAME","get_account_code","0","ACCOUNT_CODE","claim_account_id"+no,"",3);
	}
	function pencere_ac_acc(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=account_id' + no +'&field_name=account_code' + no +'','list');
	}
	function pencere_ac_acc1(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=claim_account_id' + no +'&field_name=claim_account_code' + no +'','list');
	}
	function clear_()
	{
		if(document.getElementById('employee').value=='')
		{
			document.getElementById('employee_id').value='';
		}
	}
	function pencere_ac_acc2(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=debt_account_id' + no +'&field_name=debt_account_code' + no +'','list');
	}
	
	function pencere_ac_exp(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=expense_item_id' + no +'&field_name=expense_item_name' + no +'&field_account_no=debt_account_id' + no +'&field_account_no2=debt_account_code' + no +'','list');
	}
	function open_inventory_cat_list(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_inventory_cat&field_id=inventory_cat_id' + no +'&field_name=inventory_cat' + no +'&field_amortization_rate=amortization_rate' + no +'&field_inventory_duration=inventory_duration' + no +'','list');
	}
	
	function ayarla_gizle_goster(id)
	{ 
		if(id==1)
		{
			if(document.getElementById("cash").checked == true)
			{
				if (document.getElementById("credit")) 
				{
					document.getElementById("credit").checked = false;
					document.getElementById("credit2").style.display='none';
				}
				document.getElementById("kasa2").style.display='';
			}
			else
			{
				document.getElementById("kasa2").style.display='none';
			}
		}
		else if(id==2)
		{
			if(document.getElementById("credit").checked == true)
			{
				if (document.getElementById("cash")) 
				{
					document.getElementById("cash").checked = false;
					document.getElementById("kasa2").style.display='none';
				}
				document.getElementById("credit2").style.display='';
			}
			else
			{
				document.getElementById("credit2").style.display='none';
			}
		}
	}
	
	function change_paper_duedate(field_name,type,is_row_parse) 
	{
		paper_date_=eval('document.all.invoice_date.value');
		if(type!=undefined && type==1)
			document.getElementById("basket_due_value").value = datediff(paper_date_,document.getElementById("basket_due_value_date_").value,0);
		else
		{
			if(isNumber(document.getElementById("basket_due_value"))!= false && (document.getElementById("basket_due_value").value != 0))
				document.getElementById("basket_due_value_date_").value = date_add('d',+document.getElementById("basket_due_value").value,paper_date_);
			else
			{
				document.getElementById("basket_due_value_date_").value =paper_date_;
				if(document.getElementById("basket_due_value").value == '')
					document.getElementById("basket_due_value").value = datediff(paper_date_,document.getElementById("basket_due_value_date_").value,0);
			}
		}
	}
</script>
</cfif>
<cfif IsDefined("attributes.event") and attributes.event eq 'upd' >
	<cfquery name="get_expense" datasource="#dsn2#">
        SELECT
            EIP.*,
            D.BRANCH_ID
        FROM
            INVOICE EIP
            JOIN #dsn_alias#.DEPARTMENT D ON EIP.DEPARTMENT_ID = D.DEPARTMENT_ID
        WHERE
            EIP.INVOICE_ID = <cfif IsDefined('attributes.invoice_id') and len(attributes.invoice_id)>#attributes.invoice_id#<cfelse>#attributes.ship_id#</cfif>
            <cfif listgetat(attributes.fuseaction,1,'.') is 'store'>
                AND D.BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#
            </cfif>
    </cfquery>
	<cfif isDefined("attributes.ship_id")>
        <cfquery name="GET_SHIP" datasource="#DSN2#">
            SELECT SHIP_NUMBER,INVOICE_ID FROM INVOICE_SHIPS WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id#"> AND SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
        </cfquery>
        <cfset attributes.invoice_id = get_ship.invoice_id>
    <cfelse>
        <cfquery name="GET_SHIP" datasource="#DSN2#">
            SELECT SHIP_NUMBER FROM INVOICE_SHIPS WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#">
        </cfquery>
    </cfif>
   
	<cfif isdefined("attributes.invoice_id") and len(attributes.invoice_id)>
        <cfquery name="GET_PURCHASE_MONEY" datasource="#DSN2#">
            SELECT RATE2,MONEY_TYPE FROM INVOICE_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND IS_SELECTED = <cfqueryparam value="1" cfsqltype="cf_sql_smallint">
        </cfquery>
    <cfelse>
        <cfset GET_PURCHASE_MONEY.recordcount = 0>
    </cfif>
	<cfif not GET_PURCHASE_MONEY.recordcount>
        <cfquery name="GET_PURCHASE_MONEY" datasource="#DSN#">
            SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS = <cfqueryparam value="#variable#" cfsqltype="cf_sql_smallint">
        </cfquery>
    </cfif>
	<cfif isdefined("attributes.invoice_id") and len(attributes.invoice_id)>
        <cfquery name="GET_INVOICE" datasource="#DSN2#">
            SELECT 
                INVOICE.*
            FROM 
                INVOICE
            WHERE 
                INVOICE.INVOICE_CAT NOT IN (67,69) AND 
                INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#">
        </cfquery>
        <cfquery name="get_efatura_det" datasource="#dsn2#">
            SELECT 
                RECEIVING_DETAIL_ID
            FROM
                EINVOICE_RECEIVING_DETAIL
            WHERE
                INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#">
            ORDER BY
                RECEIVING_DETAIL_ID DESC
        </cfquery>
    <cfelse>
        <cfset GET_INVOICE.recordcount = 0>
    </cfif>
    <cfif isdefined("attributes.invoice_id") and len(attributes.invoice_id)>
	<cfquery name="GET_INVOICE_MONEY" datasource="#DSN2#">
		SELECT MONEY_TYPE AS MONEY,* FROM INVOICE_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#">
	</cfquery>
    <cfelse>
        <cfset GET_INVOICE_MONEY.recordcount = 0>
    </cfif>
    <cfif not GET_INVOICE_MONEY.recordcount>
        <cfquery name="GET_INVOICE_MONEY" datasource="#DSN#">
            SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS = <cfqueryparam value="#variable#" cfsqltype="cf_sql_smallint">
        </cfquery>
    </cfif>
    
    <cfquery name="GET_INVENTORY_CATS" datasource="#DSN3#">
        SELECT * FROM SETUP_INVENTORY_CAT ORDER BY INVENTORY_CAT_ID
    </cfquery>
    <cfset inventory_cat_list=valuelist(get_inventory_cats.inventory_cat_id)>
    <cfquery name="GET_ACCOUNTS" datasource="#DSN3#">
        SELECT ACCOUNT_ID,ACCOUNT_CURRENCY_ID,ACCOUNT_NAME FROM ACCOUNTS ORDER BY ACCOUNT_NAME
    </cfquery>
    
    <cfquery name="GET_AMORTIZATION_COUNT" datasource="#DSN3#">
        SELECT 
            COUNT(IA.AMORTIZATION_ID) AS AMORTIZATION_COUNT
        FROM 
            INVENTORY I,
            INVENTORY_ROW IR,
            INVENTORY_AMORTIZATON IA
        WHERE 
            I.INVENTORY_ID = IR.INVENTORY_ID
            AND IA.INVENTORY_ID = IR.INVENTORY_ID
            AND IR.PERIOD_ID = #session.ep.period_id#
            AND IR.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#">
            AND IR.PROCESS_TYPE = 65
    </cfquery>
    <cfquery name="GET_SALE_COUNT" datasource="#DSN3#">
        SELECT 
            COUNT(IR2.INVENTORY_ROW_ID) AS SALE_COUNT
        FROM 
            INVENTORY I,
            INVENTORY_ROW IR,
            INVENTORY_ROW IR2
        WHERE 
            I.INVENTORY_ID = IR.INVENTORY_ID
            AND I.INVENTORY_ID = IR2.INVENTORY_ID
            AND IR.PERIOD_ID = #session.ep.period_id#
            AND IR.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#">
            AND IR.PROCESS_TYPE = 65
            AND IR2.PROCESS_TYPE = 66
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
    <cfif len(get_invoice.pay_method)>
        <cfquery name="get_paymethod" datasource="#DSN#">
            SELECT * FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice.PAY_METHOD#">
        </cfquery>
    <cfelseif len(get_invoice.card_paymethod_id)>
        <cfquery name="get_card_paymethod" datasource="#dsn3#">
            SELECT CARD_NO,COMMISSION_MULTIPLIER FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice.card_paymethod_id#">
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
    <cfif isdefined("get_expense") and get_expense.is_credit eq 1>
        <cfquery name="get_credit_info" datasource="#dsn3#">
            SELECT
                CREDITCARD_ID,
                INSTALLMENT_NUMBER,
                DELAY_INFO,
                SUM(CLOSED_AMOUNT) CLOSED_AMOUNT
            FROM
            (
                SELECT
                    CREDIT_CARD_BANK_EXPENSE.CREDITCARD_ID,
                    CREDIT_CARD_BANK_EXPENSE.INSTALLMENT_NUMBER,
                    CREDIT_CARD_BANK_EXPENSE.DELAY_INFO,
                    ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM CREDIT_CARD_BANK_EXPENSE_RELATIONS WHERE CREDIT_CARD_BANK_EXPENSE_RELATIONS.CC_BANK_EXPENSE_ROWS_ID = CREDIT_CARD_BANK_EXPENSE_ROWS.CC_BANK_EXPENSE_ROWS_ID),0) CLOSED_AMOUNT
                FROM
                    CREDIT_CARD_BANK_EXPENSE,
                    CREDIT_CARD_BANK_EXPENSE_ROWS
                WHERE
                    EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_expense.invoice_id#">
                    AND ACTION_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
                    AND CREDIT_CARD_BANK_EXPENSE_ROWS.CREDITCARD_EXPENSE_ID = CREDIT_CARD_BANK_EXPENSE.CREDITCARD_EXPENSE_ID
            ) T1
            GROUP BY
                CREDITCARD_ID,
                INSTALLMENT_NUMBER,
                DELAY_INFO
    	</cfquery>
    </cfif>
    <cfquery name="GET_ROWS" datasource="#dsn2#">
        SELECT
            (SELECT COUNT(IA.AMORTIZATION_ID) FROM #dsn3_alias#.INVENTORY_AMORTIZATON IA WHERE IA.INVENTORY_ID = INVENTORY.INVENTORY_ID) AMORT_COUNT,
            * ,
            EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
            EXPENSE_ITEMS.ACCOUNT_CODE,
            EXPENSE_CENTER.*
        FROM
            INVOICE_ROW
            LEFT JOIN #dsn3_alias#.INVENTORY ON INVENTORY.INVENTORY_ID = INVOICE_ROW.INVENTORY_ID
            LEFT JOIN #dsn2_alias#.EXPENSE_ITEMS ON EXPENSE_ITEMS.EXPENSE_ITEM_ID = INVENTORY.EXPENSE_ITEM_ID
            LEFT JOIN #dsn2_alias#.EXPENSE_CENTER ON EXPENSE_CENTER.EXPENSE_ID =  INVENTORY.EXPENSE_CENTER_ID
        WHERE
            INVOICE_ROW.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> 
            
        ORDER BY
            INVENTORY.INVENTORY_ID
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
				str_adrlink = '&field_long_adres=inventPurchase.adres&field_adress_id=inventPurchase.ship_address_id&is_compname_readonly=1';
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(inventPurchase.comp_name.value)+''+ str_adrlink , 'list');
				return true;
			}
			else
			{
				str_adrlink = '&field_long_adres=inventPurchase.adres&field_adress_id=inventPurchase.ship_address_id&is_compname_readonly=1';
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(inventPurchase.partner_name.value)+''+ str_adrlink , 'list');
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
		if(!paper_control(inventPurchase.serial_no,'INVOICE',false,<cfoutput>'#attributes.invoice_id#','#get_invoice.serial_no#'</cfoutput>,inventPurchase.company_id.value,inventPurchase.consumer_id.value,'','',1,inventPurchase.serial_number)) return false;
		if(!chk_process_cat('inventPurchase')) return false;
		if(!chk_period(inventPurchase.invoice_date,"İşlem")) return false;
		if(!check_display_files('inventPurchase')) return false;
		if(inventPurchase.department_id.value=="")
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='1351.Depo'>");
			return false;
		}
		
		
		<cfif xml_is_department eq 2>
			if( document.inventPurchase.acc_department_id.options[document.inventPurchase.acc_department_id.selectedIndex].value=="")
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='160.Departman'>");
				return false;
			} 
		</cfif>
		<cfif xml_project_require eq 1>
			if(document.getElementById("project_id") != undefined && document.getElementById("project_id").value == "" && document.getElementById("project_head").value == "")
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='4.Proje'>");
				return false;
			} 
		</cfif>
		if(document.getElementById('comp_name').value == ""  && document.getElementById('consumer_id').value == ""  && document.getElementById('emp_id').value == "")
		{ 
			alert ("<cf_get_lang no='8.Cari Hesap Seçmelisiniz'>!");
			return false;
		}
		
		//Odeme Plani Guncelleme Kontrolleri
		if (document.getElementById('invoice_cari_action_type').value == 5 && document.getElementById('paymethod_id').value != "")
		{
			if (confirm("<cf_get_lang_main no='1663.Güncellediğiniz Belgenin Ödeme Planı Yeniden Oluşturulacaktır'>!"))
				document.getElementById('invoice_payment_plan').value = 1;
			else
			{
				document.getElementById('invoice_payment_plan').value = 0;
				<cfif xml_control_payment_plan_status eq 1>
					return false;
				</cfif>
			}
		}
		if(document.getElementById("credit").checked == true)
		{		
			if(document.getElementById("credit_card_info").value == '')
			{
				alert("Lütfen Kredi Kartı Seçiniz");
				return false;
			}
		}
		
		record_exist=0;//Row_kontrol değeri 1 olan yani silinmemiş satırların varlığını kontrol ediyor
		for(r=1;r<=inventPurchase.record_num.value;r++)
		{
			if(document.getElementById("row_kontrol"+r).value == 1)
			{
				record_exist=1;
				if (document.getElementById("invent_no"+r).value == "")
				{ 
					alert ("<cf_get_lang no='88.Lütfen Demirbaş No Giriniz'>!");
					return false;
				}
				if (document.getElementById("invent_name"+r).value == "")
				{ 
					alert ("<cf_get_lang no='93.Lütfen Açıklama Giriniz'>  !");
					return false;
				}
				if ((document.getElementById("row_total"+r).value == "")||(document.getElementById("row_total"+r).value ==0))
				{ 
					alert ("<cf_get_lang_main no='1738.Lütfen Tutar Giriniz '>!");
					return false;
				}
				if ((document.getElementById("amortization_rate"+r).value == "")||(document.getElementById("amortization_rate"+r).value < 0))
				{ 
					alert ("<cf_get_lang no='95.Lütfen Amortisman Oranı Giriniz'> !");
					return false;
				}
				if (document.getElementById("account_id"+r).value == "")
				{ 
					alert ("<cf_get_lang no='96.Lütfen Muhasebe Kodu Seçiniz'>");
					return false;
				}
				document.getElementById("amortization_method"+r).disabled = false;
				document.getElementById("amortization_type"+r).disabled = false;
			}
		}
		change_paper_duedate('invoice_date');
		if (record_exist == 0) 
			{
				alert("<cf_get_lang no='90.Lütfen Demirbaş Giriniz'>!");
				return false;
			}
			unformat_fields();
			return true;
	}
	
	/* delete function */
	function kontrol_2()
	{
		<cfif session.ep.our_company_info.is_efatura and isdefined("get_efatura_det") and get_efatura_det.recordcount>
			alert("Fatura ile İlişkili e-Fatura Olduğu için Silinemez !");
			return false;
		</cfif>
		if (!check_display_files('inventPurchase')) return false;
		return true;
	}
	
	function amortisman_kontrol(x)
	{
		deger_amortization_rate = document.getElementById("amortization_rate"+x);
		if (filterNum(deger_amortization_rate.value) >100)
		{ 
			alert ("<cf_get_lang no='67.Amortisman Oranı 100 den Büyük Olamaz'>!");
			deger_amortization_rate.value = 0;
			return false;
		}
		return true;
	}
	function period_kontrol(no)
	{
		deger = document.getElementById("period"+no);
		if ((filterNum(deger.value) <1) || (deger.value==""))
		{ 
			alert ("<cf_get_lang no='66.Hesaplama Dönemi 1 den Küçük Olamaz'>!");
			deger.value =1;
			return false;
		}
		return true;
	}
	function  period_kontrol1(no)
	{
		deger1= document.getElementById("hd_period"+no);
		deger = document.getElementById("period"+no);
		if ((filterNum(deger.value) <1) || (deger.value==""))
		{ 
			alert ("<cf_get_lang no='66.Hesaplama Dönemi 1 den Küçük Olamaz'>!");
			deger.value=deger1.value;
			return false;
		}
		return true;
	}
	function unformat_fields()
	{
		for(r=1;r<=inventPurchase.record_num.value;r++)
		{
			deger_total = document.getElementById("row_total"+r);
			deger_total2 = document.getElementById("row_total2"+r);
			deger_kdv_total= document.getElementById("kdv_total"+r);
			deger_otv_total= document.getElementById("otv_total"+r);
			deger_net_total = document.getElementById("net_total"+r);
			deger_other_net_total = document.getElementById("row_other_total"+r);
			deger_amortization_rate = document.getElementById("amortization_rate"+r);
			deger_miktar= document.getElementById("quantity"+r);
			temp_inventory_duration= document.getElementById("inventory_duration"+r);
			
			deger_miktar.value = filterNum(deger_miktar.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_total.value = filterNum(deger_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_total2.value = filterNum(deger_total2.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_kdv_total.value = filterNum(deger_kdv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_otv_total.value = filterNum(deger_otv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_net_total.value = filterNum(deger_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_other_net_total.value = filterNum(deger_other_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_amortization_rate.value = filterNum(deger_amortization_rate.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			temp_inventory_duration.value=filterNum(temp_inventory_duration.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		}
		document.getElementById('total_amount').value = filterNum(document.getElementById('total_amount').value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById('kdv_total_amount').value = filterNum(document.getElementById('kdv_total_amount').value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("otv_total_amount").value = filterNum(document.getElementById("otv_total_amount").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>); 
		document.getElementById('net_total_amount').value = filterNum(document.getElementById('net_total_amount').value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById('other_total_amount').value = filterNum(document.getElementById('other_total_amount').value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById('other_kdv_total_amount').value = filterNum(document.getElementById('other_kdv_total_amount').value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("other_otv_total_amount").value = filterNum(document.getElementById("other_otv_total_amount").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>); 
		document.getElementById('other_net_total_amount').value = filterNum(document.getElementById('other_net_total_amount').value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById('net_total_discount').value = filterNum(document.getElementById('net_total_discount').value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById('tevkifat_oran').value = filterNum(document.getElementById('tevkifat_oran').value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("stopaj_yuzde").value = filterNum(document.getElementById("stopaj_yuzde").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("stopaj").value = filterNum(document.getElementById("stopaj").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		for(s=1;s<=inventPurchase.kur_say.value;s++)
		{
			eval('inventPurchase.txt_rate2_' + s).value = filterNum(eval('inventPurchase.txt_rate2_' + s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			eval('inventPurchase.txt_rate1_' + s).value = filterNum(eval('inventPurchase.txt_rate1_' + s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
	}
	row_count=<cfoutput>#get_rows.recordcount#</cfoutput>;
	function sil(sy)
	{
		var my_element=eval("inventPurchase.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
		toplam_hesapla();
	}
	function hesapla(satir,hesap_type)
	{
		var toplam_dongu_0 = 0;//satir toplam
		if(document.getElementById("row_kontrol"+satir).value==1)
		{
			deger_total = document.getElementById("row_total"+satir);//tutar
			deger_miktar = document.getElementById("quantity"+satir);//miktar
			deger_kdv_total= document.getElementById("kdv_total"+satir);//kdv tutarı
			deger_otv_total= document.getElementById("otv_total"+satir);//otv tutarı
			deger_net_total = document.getElementById("net_total"+satir);//kdvli tutar
			deger_tax_rate = document.getElementById("tax_rate"+satir);//kdv oranı
			deger_otv_rate = document.getElementById("otv_rate"+satir);//otv oranı
			deger_other_net_total = document.getElementById("row_other_total"+satir);//dovizli tutar kdv dahil
			if(deger_total.value == "") deger_total.value = 0;
			if(deger_kdv_total.value == "") deger_kdv_total.value = 0;
			if(deger_net_total.value == "") deger_net_total.value = 0;
			deger_money_id = document.getElementById("money_id"+satir);
			deger_money_id_ilk = list_getat(deger_money_id.value,2,',');
			deger_money_id_son = list_getat(deger_money_id.value,3,',');
			deger_total.value = filterNum(deger_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_kdv_total.value = filterNum(deger_kdv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_net_total.value = filterNum(deger_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_other_net_total.value = filterNum(deger_other_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_miktar.value = filterNum(deger_miktar.value,0); 
			if(hesap_type ==undefined)
			{
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
			}
			toplam_dongu_0 = (parseFloat(deger_total.value)*deger_miktar.value) + parseFloat(deger_kdv_total.value);
			deger_other_net_total.value = ((parseFloat(deger_total.value) + parseFloat(deger_kdv_total.value)) * parseFloat(deger_money_id_ilk) / (parseFloat(deger_money_id_son)));
			deger_net_total.value = commaSplit(toplam_dongu_0,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_total.value = commaSplit(deger_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
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
		for(r=1;r<=inventPurchase.record_num.value;r++)
		{
			if(document.getElementById("row_kontrol"+r).value==1)
			{
				toplam_dongu_4 = toplam_dongu_4 + (parseFloat(filterNum(document.getElementById("row_total"+r).value) * filterNum(document.getElementById("quantity"+r).value)));
			}
		}			
		deger_discount_value = filterNum(document.getElementById('net_total_discount').value);
		genel_indirim_yuzdesi = commaSplit(parseFloat(deger_discount_value) / parseFloat(toplam_dongu_4),8);
		genel_indirim_yuzdesi = filterNum(genel_indirim_yuzdesi,8);
		genel_indirim_yuzdesi = wrk_round(genel_indirim_yuzdesi,8);

		for(r=1;r<=inventPurchase.record_num.value;r++)
		{
			if(document.getElementById("row_kontrol"+r).value==1)
			{
				deger_total = document.getElementById("row_total"+r);//tutar
				deger_miktar = document.getElementById("quantity"+r);//miktar
				deger_kdv_total= document.getElementById("kdv_total"+r);//kdv tutarı
				deger_otv_total= document.getElementById("otv_total"+r);//ötv tutarı
				deger_net_total = document.getElementById("net_total"+r);//kdvli tutar
				deger_tax_rate = document.getElementById("tax_rate"+r);//kdv oranı
				deger_other_net_total = document.getElementById("row_other_total"+r);//dovizli tutar kdv dahil
				deger_money_id = document.getElementById("money_id"+r);
				deger_money_id_ilk = list_getat(deger_money_id.value,1,',');
				for(s=1;s<=inventPurchase.kur_say.value;s++)
				{ 
					if(list_getat(document.inventPurchase.rd_money[s-1].value,1,',') == deger_money_id_ilk)
					{
						satir_rate2= document.getElementById("txt_rate2_"+s).value;
					}
				}
				satir_rate2= filterNum(satir_rate2,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				deger_money_id_son = list_getat(deger_money_id.value,3,',');
				deger_total.value = filterNum(deger_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_kdv_total.value = filterNum(deger_kdv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_otv_total.value = filterNum(deger_otv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				toplam_dongu_2 = toplam_dongu_2 + parseFloat(deger_kdv_total.value)- parseFloat(deger_kdv_total.value*genel_indirim_yuzdesi);
				toplam_dongu_5 = toplam_dongu_5 + parseFloat(deger_otv_total.value);
				deger_indirim_kdv = parseFloat(deger_kdv_total.value)- parseFloat(deger_kdv_total.value*genel_indirim_yuzdesi);
				toplam_dongu_3 = toplam_dongu_3 + ((parseFloat(deger_total.value)- (parseFloat(deger_total.value)*genel_indirim_yuzdesi)) * filterNum(document.getElementById("quantity"+r).value));
				toplam_dongu_3 = toplam_dongu_3 + parseFloat(deger_kdv_total.value)- parseFloat(deger_kdv_total.value*genel_indirim_yuzdesi);
				toplam_dongu_3 = toplam_dongu_3 + parseFloat(deger_otv_total.value);
				
				if(document.getElementById('tevkifat_oran') != undefined && document.getElementById('tevkifat_oran').value != "" && inventPurchase.tevkifat_box.checked == true)
				{//tevkifat hesaplamaları
					beyan_tutar = beyan_tutar + wrk_round(deger_indirim_kdv*filterNum(document.getElementById('tevkifat_oran').value));
					if(new_taxArray.length != 0)
						for (var m=0; m < new_taxArray.length; m++)
						{	
							var tax_flag = false;
							if(new_taxArray[m] == deger_tax_rate.value){
								tax_flag = true;
								taxBeyanArray[m] += wrk_round(deger_indirim_kdv - (deger_indirim_kdv*(filterNum(document.getElementById('tevkifat_oran').value))));
								taxTevkifatArray[m] += wrk_round(deger_indirim_kdv*(filterNum(document.getElementById('tevkifat_oran').value)));
								break;
							}
						}
					if(!tax_flag){
						new_taxArray[new_taxArray.length] = deger_tax_rate.value;
						taxBeyanArray[taxBeyanArray.length] = wrk_round(deger_indirim_kdv - (deger_indirim_kdv*(filterNum(document.getElementById('tevkifat_oran').value))));
						taxTevkifatArray[taxTevkifatArray.length] = wrk_round(deger_indirim_kdv*(filterNum(document.getElementById('tevkifat_oran').value)));
					}
				}
				deger_net_total.value = filterNum(deger_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_other_net_total.value = filterNum(deger_other_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				toplam_dongu_1 = toplam_dongu_1 + parseFloat(deger_total.value * deger_miktar.value);
				deger_other_net_total.value = ((parseFloat(deger_total.value * deger_miktar.value) + parseFloat(deger_kdv_total.value)) / (parseFloat(satir_rate2)));
				
				deger_net_total.value = commaSplit(deger_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_total.value = commaSplit(deger_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_kdv_total.value = commaSplit(deger_kdv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_otv_total.value = commaSplit(deger_otv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_other_net_total.value = commaSplit(deger_other_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			}
		}
		if(document.getElementById('tevkifat_oran') != undefined && document.getElementById('tevkifat_oran').value != "" && inventPurchase.tevkifat_box.checked == true)
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
		else if(parseFloat(document.getElementById("stopaj_yuzde").value) == 0)
			stopaj_ = 0;
		else
			stopaj_ = filterNum(document.getElementById("stopaj").value);
		document.getElementById("stopaj_yuzde").value = commaSplit(parseFloat(document.getElementById("stopaj_yuzde").value));
		document.getElementById("stopaj").value = commaSplit(stopaj_,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		toplam_dongu_3 = toplam_dongu_3-parseFloat(stopaj_);
		//stopajlar hesaplandi
		document.getElementById('total_amount').value = commaSplit(toplam_dongu_1,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById('kdv_total_amount').value = commaSplit(toplam_dongu_2,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById('otv_total_amount').value = commaSplit(toplam_dongu_5,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById('net_total_amount').value = commaSplit(toplam_dongu_3,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		for(s=1;s<=inventPurchase.kur_say.value;s++)
		{
			form_txt_rate2_ = document.getElementById("txt_rate2_"+s);
			if(form_txt_rate2_.value == "")
				form_txt_rate2_.value = 1;
		}
		if(inventPurchase.kur_say.value == 1)
			for(s=1;s<=inventPurchase.kur_say.value;s++)
			{
				if(document.getElementById('rd_money').checked == true)
				{
					deger_diger_para = document.getElementById('rd_money');
					form_txt_rate2_ = document.getElementById("txt_rate2_"+s);
				}
			}
		else 
			for(s=1;s<=inventPurchase.kur_say.value;s++)
			{
				if(document.inventPurchase.rd_money[s-1].checked == true)
				{
					deger_diger_para = document.inventPurchase.rd_money[s-1];
					form_txt_rate2_ = document.getElementById("txt_rate2_"+s);
				}
			}
		deger_money_id_1 = list_getat(deger_diger_para.value,1,',');
		deger_money_id_3 = list_getat(deger_diger_para.value,3,',');
		form_txt_rate2_.value = filterNum(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById('other_total_amount').value = commaSplit(toplam_dongu_1 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById('other_kdv_total_amount').value = commaSplit(toplam_dongu_2 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById('other_otv_total_amount').value = commaSplit(toplam_dongu_5 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById('other_net_total_amount').value = commaSplit(toplam_dongu_3 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById('other_net_total_discount').value = commaSplit(parseFloat(deger_discount_value)* parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById('net_total_discount').value = commaSplit(parseFloat(deger_discount_value),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		
		document.getElementById('tl_value1').value = deger_money_id_1;
		document.getElementById('tl_value2').value = deger_money_id_1;	//kdv
		document.getElementById('tl_value5').value = deger_money_id_1;	//otv
		document.getElementById('tl_value3').value = deger_money_id_1;
		document.getElementById('tl_value4').value = deger_money_id_1;
		form_txt_rate2_.value = commaSplit(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	}
	
	function add_row(inventory_cat_id,inventory_cat,invent_no,invent_name,quantity,row_total,row_total2,tax_rate,otv_rate,kdv_total,otv_total,net_total,row_other_total,money_id,inventory_duration,amortization_rate,amortization_method,amortization_type,account_id,account_code,expense_center_id,expense_center_name,expense_item_id,expense_item_name,period,debt_account_id,debt_account_code,claim_account_id,claim_account_code,product_id,stock_id,product_name,stock_unit_id,stock_unit)
	{
		if (inventory_cat_id == undefined) inventory_cat_id ="";
		if (inventory_cat == undefined) inventory_cat ="";
		if (invent_no == undefined) invent_no ="";
		if (invent_name == undefined) invent_name ="";
		if (quantity == undefined) quantity = 1;
		if (row_total == undefined) row_total = 0;
		if (row_total2 == undefined) row_total2 = 0;
		if (tax_rate == undefined) tax_rate ="";
		if (otv_rate == undefined) otv_rate ="";
		if (kdv_total == undefined) kdv_total = 0;
		if (otv_total == undefined) otv_total = 0;
		if (net_total == undefined) net_total = 0;
		if (row_other_total == undefined) row_other_total = 0;
		if (money_id == undefined) money_id ="";
		if (inventory_duration == undefined) inventory_duration ="";
		if (amortization_rate == undefined) amortization_rate ="";
		if (amortization_method == undefined) amortization_method ="";
		if (amortization_type == undefined) amortization_type ="";
		if (account_id == undefined) account_id ="";
		if (account_code == undefined) account_code ="";
		if (expense_center_id == undefined) expense_center_id ="";
		if (expense_center_name == undefined) expense_center_name ="";
		if (expense_item_id == undefined) expense_item_id ="";
		if (expense_item_name == undefined) expense_item_name ="";
		if (period == undefined) period = 12;
		if (debt_account_id == undefined) debt_account_id ="";
		if (debt_account_code == undefined) debt_account_code ="";
		if (claim_account_id == undefined) claim_account_id ="";
		if (claim_account_code == undefined) claim_account_code ="";
		if (product_id == undefined) product_id ="";
		if (stock_id == undefined) stock_id ="";
		if (product_name == undefined) product_name ="";
		if (stock_unit_id == undefined) stock_unit_id ="";
		if (stock_unit == undefined) stock_unit ="";
		
		row_count++;
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
		newCell.setAttribute("nowrap","nowrap");
		x = '<input  type="hidden" value="WRK'+row_count+ js_create_unique_id() + row_count+'" name="wrk_row_id' + row_count +'" id="wrk_row_id' + row_count +'"><input  type="hidden" value="" name="wrk_row_relation_id' + row_count +'" id="wrk_row_relation_id' + row_count +'">';
		newCell.innerHTML = x + '<input  type="hidden" value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><a href="javascript://" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0"></a><a style="cursor:pointer" onclick="copy_row('+row_count+');" title="<cf_get_lang_main no="1560.Satır Kopyala">"><img  src="images/copy_list.gif" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input  type="hidden" name="inventory_cat_id' + row_count +'" id="inventory_cat_id' + row_count +'" value="' + inventory_cat_id +'"><input type="text" name="inventory_cat' + row_count +'" id="inventory_cat' + row_count +'" value="' + inventory_cat +'" class="boxtext" style="width:128px;" >'
							+' '+'<a href="javascript://" onClick="open_inventory_cat_list('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" name="invent_id' + row_count +'" id="invent_id' + row_count +'" value=""><input type="text" name="invent_no' + row_count +'" id="invent_no' + row_count +'" value="' + invent_no +'" style="width:100%;" class="boxtext" maxlength="50">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="invent_name' + row_count +'" id="invent_name' + row_count +'" value="' + invent_name +'" style="width:100%;" class="boxtext" maxlength="100">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="quantity' + row_count +'" id="quantity' + row_count +'" style="width:100%;" class="box" value="' + quantity +'" onBlur="hesapla(' + row_count +');" onkeyup="return(FormatCurrency(this,event));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="row_total' + row_count +'" id="row_total' + row_count +'" value="' + row_total +'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" onBlur="hesapla(' + row_count +');" style="width:100%;" class="box">';
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="row_total2' + row_count +'" id="row_total2' + row_count +'" value="' + row_total2 +'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" onBlur="hesapla(' + row_count +',1);" style="width:100%;" class="box">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		a = '<select id="tax_rate'+ row_count +'" name="tax_rate'+ row_count +'" style="width:100%;" onChange="hesapla('+ row_count +');" class="box">';
			<cfoutput query="get_tax">
				if('#tax#' == tax_rate)
					a += '<option value="#tax#" selected>#tax#</option>';
				else
					a += '<option value="#tax#">#tax#</option>';
			</cfoutput>
		newCell.innerHTML = a+ '</select>';
		//otv orani
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		x = '<select id="otv_rate'+ row_count +'" name="otv_rate'+ row_count +'" style="width:100%;" onChange="hesapla('+ row_count +');" class="box">';
			<cfoutput query="get_otv">
				if('#tax#' == otv_rate)
					x += '<option value="#tax#" selected>#tax#</option>';
				else
					x += '<option value="#tax#">#tax#</option>';
			</cfoutput>
		newCell.innerHTML = x+ '</select>';
		//kdv total
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="kdv_total' + row_count +'" id="kdv_total' + row_count +'" value="' + kdv_total +'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" style="width:100%;" onBlur="hesapla(' + row_count +',1);" class="box">';
		//otv total
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" id="otv_total' + row_count +'" name="otv_total' + row_count +'" value="' + otv_total +'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" style="width:100%;" onBlur="hesapla(' + row_count +',1);" class="box">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="net_total' + row_count +'" id="net_total' + row_count +'" value="' + net_total +'" style="width:100%;" class="box" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" onblur="hesapla(' + row_count +',3);">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");


		newCell.innerHTML = '<input type="text" name="row_other_total' + row_count +'" id="row_other_total' + row_count +'" value="' + row_other_total +'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" style="width:100%;" class="box" onblur="hesapla(' + row_count +',4);">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		b = '<select id="money_id' + row_count  +'" name="money_id' + row_count  +'" style="width:100%;" class="boxtext" onChange="hesapla('+ row_count +');">';
			<cfoutput query="GET_INVOICE_MONEY">
				if('#money#,#rate1#,#rate2#' == money_id)
					b += '<option value="#money#,#rate1#,#rate2#" selected>#money#</option>';
				else
					b += '<option value="#money#,#rate1#,#rate2#">#money#</option>';
			</cfoutput>
		newCell.innerHTML = b+ '</select>';		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="inventory_duration' + row_count +'" id="inventory_duration' + row_count +'" style="width:100%;" value="' + inventory_duration +'" class="box" onkeyup="return(FormatCurrency(this,event));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="amortization_rate' + row_count +'" id="amortization_rate' + row_count +'" style="width:100%;" value="' + amortization_rate +'" class="box" onblur="return(amortisman_kontrol(' + row_count +'));" onkeyup="return(FormatCurrency(this,event));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<select id="amortization_method'+ row_count +'" name="amortization_method'+ row_count +'" style="width:165px;" class="box"><option value="0" ><cf_get_lang_main no="1624.Azalan Bakiye Üzerinden"></option><option value="1" ><cf_get_lang_main no="1625.Sabit Miktar Üzeriden"></option><option value="2" ><cf_get_lang_main no="1626.Hızlandırılmış Azalan Bakiye"></option><option value="3"><cf_get_lang_main no="1627.Hızlandırılmış Sabit Değer"></option></select>';
		if(amortization_method != '')
			document.getElementById('amortization_method'+ row_count).value = amortization_method;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select id="amortization_type'+ row_count +'" name="amortization_type'+ row_count +'" style="width:185px;" class="box"><option value="1">Kıst Amortismana Tabi</option><option value="2" selected>Kıst Amortismana Tabi Değil</option>></select>';
		if(amortization_type != '')
			document.getElementById('amortization_type'+ row_count).value = amortization_type;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" id="account_id' + row_count +'" name="account_id' + row_count +'" value="' + account_id +'"><input type="text" style="width:110px;" id="account_code' + row_count +'" name="account_code' + row_count +'" value="' + account_code +'" class="boxtext" onFocus="autocomp_account('+row_count+');"><a href="javascript://"><a href="javascript://" onClick="pencere_ac_acc('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML ='<input type="hidden" name="expense_center_id' + row_count +'" value="'+expense_center_id+'" id="expense_center_id' + row_count +'"><input type="text" id="expense_center_name' + row_count +'" name="expense_center_name' + row_count +'" onFocus="exp_center('+row_count+');" value="'+expense_center_name+'" style="width:150px;" class="boxtext"><a href="javascript://" onClick="pencere_ac_exp_center('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" id="expense_item_id' + row_count +'" name="expense_item_id' + row_count +'" value="' + expense_item_id +'"><input type="text" style="width:120px;" id="expense_item_name' + row_count +'" name="expense_item_name' + row_count +'" onFocus="exp_item('+row_count+');" value="' + expense_item_name +'" class="boxtext"><a href="javascript://"><img src="/images/plus_thin.gif" onclick="pencere_ac_exp('+ row_count +');" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="period' + row_count +'" name="period' + row_count +'" value="' + period +'" class="box" onblur="return(period_kontrol(' + row_count +'));" onkeyup="return(FormatCurrency(this,event,0));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" id="debt_account_id' + row_count +'" name="debt_account_id' + row_count +'" value="' + debt_account_id +'"><input type="text" id="debt_account_code' + row_count +'" name="debt_account_code' + row_count +'" value="' + debt_account_code +'" style="width:185px;" class="boxtext" onFocus="autocomp_debt_account('+row_count+');"> <a href="javascript://" onClick="pencere_ac_acc2('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" id="claim_account_id' + row_count +'" name="claim_account_id' + row_count +'" value="' + claim_account_id +'"><input type="text" id="claim_account_code' + row_count +'" name="claim_account_code' + row_count +'" value="' + claim_account_code +'" style="width:201px;" class="boxtext" onFocus="autocomp_claim_account('+row_count+');"><a href="javascript://" onClick="pencere_ac_acc1('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input  type="hidden" id="product_id' + row_count +'" name="product_id' + row_count +'" value="' + product_id +'"><input  type="hidden" id="stock_id' + row_count +'" name="stock_id' + row_count +'" value="' + stock_id +'"><input type="text" id="product_name' + row_count +'" name="product_name' + row_count +'" value="' + product_name +'" class="boxtext" maxlength="75" onFocus="AutoComplete_Create(\'product_name' + row_count +'\',\'PRODUCT_NAME\',\'PRODUCT_NAME,STOCK_CODE\',\'get_product_autocomplete\',\'0\',\'PRODUCT_ID,STOCK_ID,MAIN_UNIT,PRODUCT_UNIT_ID\',\'product_id' + row_count +',stock_id' + row_count +',stock_unit' + row_count  +',stock_unit_id' + row_count  +'\',\'inventPurchase\',1,\'\',\'\');"><a href="javascript://" onClick=""><a href="javascript://" onClick=" windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&product_id=product_id" + row_count + "&field_id=stock_id" + row_count + "&field_unit_name=stock_unit" + row_count + "&field_main_unit=stock_unit_id" + row_count + "&field_name=product_name" + row_count + "','list');"+'"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" id="stock_unit_id' + row_count +'" name="stock_unit_id' + row_count +'" value="' + stock_unit_id +'"><input type="text" id="stock_unit' + row_count +'" name="stock_unit' + row_count +'" value="' + stock_unit +'" style="width:100%;" class="boxtext">';
	}
	function copy_row(no_info)
	{
		if (document.getElementById("inventory_cat_id" + no_info) == undefined) inventory_cat_id =""; else inventory_cat_id = document.getElementById("inventory_cat_id" + no_info).value;
		if (document.getElementById("inventory_cat" + no_info) == undefined) inventory_cat =""; else inventory_cat = document.getElementById("inventory_cat" + no_info).value;
		if (document.getElementById("invent_no" + no_info) == undefined) invent_no =""; else invent_no = document.getElementById("invent_no" + no_info).value;
		if (document.getElementById("invent_name" + no_info) == undefined) invent_name =""; else invent_name = document.getElementById("invent_name" + no_info).value;
		if (document.getElementById("quantity" + no_info) == undefined) quantity =""; else quantity = document.getElementById("quantity" + no_info).value;
		if (document.getElementById("row_total" + no_info) == undefined) row_total =""; else row_total = document.getElementById("row_total" + no_info).value;
		if (document.getElementById("row_total2" + no_info) == undefined) row_total2 =""; else row_total2 = document.getElementById("row_total2" + no_info).value;
		if (document.getElementById("tax_rate" + no_info) == undefined) tax_rate =""; else tax_rate = document.getElementById("tax_rate" + no_info).value;
		if (document.getElementById("otv_rate" + no_info) == undefined) otv_rate =""; else otv_rate = document.getElementById("otv_rate" + no_info).value;
		if (document.getElementById("kdv_total" + no_info) == undefined) kdv_total =""; else kdv_total = document.getElementById("kdv_total" + no_info).value;
		if (document.getElementById("otv_total" + no_info) == undefined) otv_total =""; else otv_total = document.getElementById("otv_total" + no_info).value;
		if (document.getElementById("net_total" + no_info) == undefined) net_total =""; else net_total =  document.getElementById("net_total" + no_info).value;
		if (document.getElementById("row_other_total" + no_info) == undefined) row_other_total =""; else row_other_total = document.getElementById("row_other_total" + no_info).value;
		if (document.getElementById("money_id" + no_info) == undefined) money_id =""; else money_id = document.getElementById("money_id" + no_info).value;
		if (document.getElementById("inventory_duration" + no_info) == undefined) inventory_duration =""; else inventory_duration = document.getElementById("inventory_duration" + no_info).value;
		if (document.getElementById("amortization_rate" + no_info) == undefined) amortization_rate =""; else amortization_rate = document.getElementById("amortization_rate" + no_info).value;
		if (document.getElementById("amortization_method" + no_info) == undefined) amortization_method =""; else amortization_method = document.getElementById("amortization_method" + no_info).value;
		if (document.getElementById("amortization_type" + no_info) == undefined) amortization_type =""; else amortization_type = document.getElementById("amortization_type" + no_info).value;
		if (document.getElementById("account_id" + no_info) == undefined) account_id =""; else account_id =  document.getElementById("account_id" + no_info).value;
		if (document.getElementById("account_code" + no_info) == undefined) account_code =""; else account_code = document.getElementById("account_code" + no_info).value;
		if (document.getElementById("expense_center_id" + no_info) == undefined) expense_center_id =""; else expense_center_id = document.getElementById("expense_center_id" + no_info).value;
		if (document.getElementById("expense_center_name" + no_info) == undefined) expense_center_name =""; else expense_center_name = document.getElementById("expense_center_name" + no_info).value;
		if (document.getElementById("expense_item_id" + no_info) == undefined) expense_item_id =""; else expense_item_id = document.getElementById("expense_item_id" + no_info).value;
		if (document.getElementById("expense_item_name" + no_info) == undefined) expense_item_name =""; else expense_item_name = document.getElementById("expense_item_name" + no_info).value;
		if (document.getElementById("period" + no_info) == undefined) period =""; else period = document.getElementById("period" + no_info).value;
		if (document.getElementById("debt_account_id" + no_info) == undefined) debt_account_id =""; else debt_account_id = document.getElementById("debt_account_id" + no_info).value;
		if (document.getElementById("debt_account_code" + no_info) == undefined) debt_account_code =""; else debt_account_code = document.getElementById("debt_account_code" + no_info).value;
		if (document.getElementById("claim_account_id" + no_info) == undefined) claim_account_id =""; else claim_account_id = document.getElementById("claim_account_id" + no_info).value;
		if (document.getElementById("claim_account_code" + no_info) == undefined) claim_account_code =""; else claim_account_code = document.getElementById("claim_account_code" + no_info).value;
		if (document.getElementById("product_id" + no_info) == undefined) product_id =""; else product_id = document.getElementById("product_id" + no_info).value;
		if (document.getElementById("stock_id" + no_info) == undefined) stock_id =""; else stock_id = document.getElementById("stock_id" + no_info).value;
		if (document.getElementById("product_name" + no_info) == undefined) product_name =""; else product_name = document.getElementById("product_name" + no_info).value;
		if (document.getElementById("stock_unit_id" + no_info) == undefined) stock_unit_id =""; else stock_unit_id = document.getElementById("stock_unit_id" + no_info).value;
		if (document.getElementById("stock_unit" + no_info) == undefined) stock_unit =""; else stock_unit = document.getElementById("stock_unit" + no_info).value;
		
		add_row(inventory_cat_id,inventory_cat,invent_no,invent_name,quantity,row_total,row_total2,tax_rate,otv_rate,kdv_total,otv_total,net_total,row_other_total,money_id,inventory_duration,amortization_rate,amortization_method,amortization_type,account_id,account_code,expense_center_id,expense_center_name,expense_item_id,expense_item_name,period,debt_account_id,debt_account_code,claim_account_id,claim_account_code,product_id,stock_id,product_name,stock_unit_id,stock_unit);
		hesapla(row_count);
	}
	/* masraf merkezi popup */
	function pencere_ac_exp_center(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=inventPurchase.expense_center_id' + no +'&field_name=inventPurchase.expense_center_name' + no,'list');
	}
	/* masraf merkezi autocomplete */
	function exp_center(no)
	{
		AutoComplete_Create("expense_center_name" + no,"EXPENSE,EXPENSE_CODE","EXPENSE,EXPENSE_CODE","get_expense_center","","EXPENSE_ID","expense_center_id"+no,"",3);
	}
	/* gider kalemi autocomplete */
	function exp_item(no)
	{
		AutoComplete_Create("expense_item_name" + no,"EXPENSE_ITEM_NAME","EXPENSE_ITEM_NAME","get_expense_item","","EXPENSE_ITEM_ID,ACCOUNT_CODE,ACCOUNT_CODE","expense_item_id"+no+",debt_account_code"+no+",debt_account_id"+no,"",3);
	}
	function autocomp_account(no)
	{
		AutoComplete_Create("account_code"+no,"ACCOUNT_CODE,ACCOUNT_NAME","ACCOUNT_CODE,ACCOUNT_NAME","get_account_code","0","ACCOUNT_CODE","account_id"+no,"",3);
	}
	function autocomp_debt_account(no)
	{
		AutoComplete_Create("debt_account_code"+no,"ACCOUNT_CODE,ACCOUNT_NAME","ACCOUNT_CODE,ACCOUNT_NAME","get_account_code","0","ACCOUNT_CODE","debt_account_id"+no,"",3);
	}
	function autocomp_claim_account(no)
	{
		AutoComplete_Create("claim_account_code"+no,"ACCOUNT_CODE,ACCOUNT_NAME","ACCOUNT_CODE,ACCOUNT_NAME","get_account_code","0","ACCOUNT_CODE","claim_account_id"+no,"",3);
	}
	function pencere_ac_acc(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=inventPurchase.account_id' + no +'&field_name=inventPurchase.account_code' + no +'','list');
	}
	function pencere_ac_acc1(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=inventPurchase.claim_account_id' + no +'&field_name=inventPurchase.claim_account_code' + no +'','list');
	}
	function pencere_ac_acc2(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=inventPurchase.debt_account_id' + no +'&field_name=inventPurchase.debt_account_code' + no +'','list');
	}
	function pencere_ac_exp(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=inventPurchase.expense_item_id' + no +'&field_name=inventPurchase.expense_item_name' + no +'&field_account_no=inventPurchase.debt_account_id' + no +'&field_account_no2=inventPurchase.debt_account_code' + no +'','list');
	}
	function pencere_ac_stock(no)
	{
			if(inventPurchase.branch_id.value == '')
			{
				alert("<cf_get_lang_main no='311.Önce depo seçmelisiniz'>!");
				return false;
			}
			if(inventPurchase.company_id.value.length==0)
			{ 
				alert("<cf_get_lang_main no='303.Önce Üye Seçiniz'>!");
				return false;
			}
			if(inventPurchase.company_id!=undefined && inventPurchase.company_id.value.length)
				windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_products&company_id='+inventPurchase.company_id.value+'&int_basket_id=1&is_sale_product=0&update_product_row_id=0</cfoutput>','list');
	}
	function clear_()
	{
		if(document.getElementById('employee').value=='')
		{
			document.getElementById('employee_id').value='';
		}
	}
	function open_inventory_cat_list(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_inventory_cat&field_id=inventPurchase.inventory_cat_id' + no +'&field_name=inventPurchase.inventory_cat' + no +'&field_amortization_rate=inventPurchase.amortization_rate' + no +'&field_inventory_duration=inventPurchase.inventory_duration' + no +'','list');
	}
	function ayarla_gizle_goster(id)
	{ 
		debugger;
		if(id==1)
		{
			if(document.getElementById("cash").checked == true)
			{
				if (document.getElementById("credit")) 
				{
					document.getElementById("credit").checked = false;
					document.getElementById("credit2").style.display='none';
				}
				document.getElementById("kasa2").style.display='';
			}
			else
			{
				document.getElementById("kasa2").style.display='none';
			}
		}
		else if(id==2)
		{
			if(document.getElementById("credit").checked == true)
			{
				if (document.getElementById("cash")) 
				{
					document.getElementById("cash").checked = false;
					document.getElementById("kasa2").style.display='none';
				}
				document.getElementById("credit2").style.display='';
			}
			else
			{
				document.getElementById("credit2").style.display='none';
			}
		}
	}
	function change_paper_duedate(field_name,type,is_row_parse) 
	{
		paper_date_=eval('document.inventPurchase.invoice_date.value');
		if(type!=undefined && type==1)
			document.getElementById('basket_due_value').value = datediff(paper_date_,document.getElementById('basket_due_value_date_').value,0);
		else
		{
			if(isNumber(document.getElementById('basket_due_value'))!= false && (document.getElementById('basket_due_value').value != 0))
				document.getElementById('basket_due_value_date_').value = date_add('d',+document.getElementById('basket_due_value').value,paper_date_);
			else
			{
				document.getElementById('basket_due_value_date_').value = paper_date_;
				if(document.getElementById('basket_due_value').value == '')
					document.getElementById('basket_due_value').value = datediff(paper_date_,document.getElementById('basket_due_value_date_').value,0);
			}
		}
	}
</script>
<cfelse>
	<cfset attributes.invoice_id = "">
	<cfset GET_INVOICE.recordcount = 0>
</cfif>
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
		<cfset attributes.paymethod = get_paymethod.paymethod>
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
	<cfset attributes.project_head = get_project.project_head>
	<cfset attributes.SHIP_ADDRESS_ID = GET_INVOICE.SHIP_ADDRESS_ID>
	<cfset attributes.SHIP_ADDRESS = GET_INVOICE.SHIP_ADDRESS>
	<cfset attributes.kasa_id = get_invoice.kasa_id>
	<cfif isdefined("get_expense") and get_expense.is_credit eq 1>
		<cfset attributes.INSTALLMENT_NUMBER = get_credit_info.INSTALLMENT_NUMBER>
		<cfset attributes.CREDITCARD_ID = get_credit_info.CREDITCARD_ID>
		<cfset attributes.DELAY_INFO = get_credit_info.DELAY_INFO>
		<cfset attributes.closed_amount = get_credit_info.closed_amount>
	</cfif>
	<cfset attributes.AMORTIZATION_COUNT = GET_AMORTIZATION_COUNT.AMORTIZATION_COUNT>
	<cfset attributes.SALE_COUNT = GET_SALE_COUNT.SALE_COUNT>
	<cfset attributes.upd_status = get_invoice.upd_status>
	<cfset attributes.recordcount = get_rows.recordcount>
	<cfparam name="attributes.kur_say" default="GET_INVOICE_MONEY.recordcount">
	<cfset attributes.RATE2 = GET_PURCHASE_MONEY.RATE2>
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
<script type="text/javascript" >
	function pencere_ac_cari()
	{
		windowopen('index.cfm?fuseaction=objects.popup_list_pars&is_cari_action=1&select_list=1,2,3&field_name=inventPurchase.partner_name&field_partner=inventPurchase.partner_id&field_adress_id=inventPurchase.ship_address_id&field_long_address=inventPurchase.adres&field_comp_name=inventPurchase.comp_name&field_comp_id=inventPurchase.company_id&field_consumer=inventPurchase.consumer_id&field_emp_id=inventPurchase.emp_id&field_paymethod_id=inventPurchase.paymethod_id&field_paymethod=inventPurchase.paymethod&field_basket_due_value=inventPurchase.basket_due_value&call_function=change_paper_duedate()','list');
	}
	function auto_complate_satin()
	{
		AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'3\',\'0\',\'0\',\'0\',\'\',\'\',\'\',\'\'','EMPLOYEE_ID','employee_id','','3','130');
	}
	function pencere_ac_satin()
	{
		windowopen('index.cfm?fuseaction=objects.popup_list_positions&field_emp_id=inventPurchase.employee_id&field_name=inventPurchase.employee&select_list=1,9','list');
	}
	
	function pencere_ac_proje()
	{
		windowopen('index.cfm?fuseaction=objects.popup_list_projects&project_id=inventPurchase.project_id&project_head=inventPurchase.project_head','list');
	}
	function auto_complate_proje()
	{
		AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','150');
	}
	
	function pencere_ac_odemeYontemi()
	{
		windowopen('index.cfm?fuseaction=objects.popup_paymethods&field_id=inventPurchase.paymethod_id&field_dueday=inventPurchase.basket_due_value&function_name=change_paper_duedate&field_name=inventPurchase.paymethod#card_link#','list');
	}
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'invent.add_invent_purchase';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'inventory/form/add_invent_purchase.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'inventory/query/add_invent_purchase.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'invent.add_invent_purchase&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('upd_cost','upd_cost_bask')";
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'invent.add_invent_purchase';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'inventory/form/add_invent_purchase.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'inventory/query/upd_invent_purchase.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'invent.add_invent_purchase&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'invoice_id=##attributes.invoice_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.invoice_id##';
	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1966]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['customTag'] = '<cf_get_workcube_related_acts period_id="#session.ep.period_id#" company_id="#session.ep.company_id#" asset_cat_id="-22" module_id="20" action_section="INVOICE_ID" action_id="#attributes.invoice_id#">';
		if( isdefined("get_efatura_det") and get_efatura_det.recordcount)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[345]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_dsp_efatura_detail&receiving_detail_id=#get_efatura_det.receiving_detail_id#&type=1','page','add_process')";
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[1040]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_account_cards&invoice_id=#attributes.invoice_id#','page','add_process')";
		if(len(get_invoice.pay_method) and not listfindnocase(denied_pages,'objects.popup_payment_with_voucher'))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array.item[14]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_payment_with_voucher&is_purchase_=1&payment_process_id=#attributes.invoice_id#&str_table=INVOICE&branch_id='+document.inventPurchase.branch_id.value','page','add_process')";
		}
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = 'Ekle';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=invent.add_invent_purchase";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_type=#GET_INVOICE.invoice_cat#&iid=#attributes.invoice_id#&print_type=350','page')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	if( isdefined("attributes.event") and (attributes.event is 'del' or attributes.event is 'upd'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'invent.add_invent_purchase&event=del&invoice_id=#attributes.invoice_id#&head=#get_invoice.invoice_number#&old_process_type=#get_invoice.invoice_cat#&head=#get_invoice.invoice_number#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'inventory/query/del_purchase_sale_invent.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'inventory/query/del_purchase_sale_invent.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'invent.list_actions';
		WOStruct['#attributes.fuseaction#']['del']['extraParams'] = 'invoice_id';
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'inventPurchase';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'INVOICE';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-1','item-2','item-4','item-7','item-8','item-9']";
</cfscript>
