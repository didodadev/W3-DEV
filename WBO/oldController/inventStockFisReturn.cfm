<cfparam name="attributes.process_cat" default="" >
<cfparam name="attributes.ref_no" default="" >
<cfparam name="attributes.employee_id" default="#session.ep.userid#" >
<cfparam name="attributes.project_id" default="" >
<cfparam name="attributes.project_head" default="" >
<cfparam name="attributes.subscription_id" default="" >
<cfparam name="attributes.SUBSCRIPTION_NO" default="" >
<cfparam name="attributes.FIS_DETAIL" default="" >
<cf_get_lang_set module_name="invent">
<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1
</cfquery>
<cfquery name="GET_TAX" datasource="#dsn2#">
	SELECT * FROM SETUP_TAX ORDER BY TAX
</cfquery>
<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
	SELECT EXPENSE_ID,EXPENSE,EXPENSE_CODE FROM EXPENSE_CENTER ORDER BY EXPENSE
</cfquery>

<cfif not IsDefined("attributes.event") or attributes.event eq 'add'>
	 <cfquery name="get_standart_process_money" datasource="#dsn#"><!--- muhasebe doneminden standart islem dövizini alıyor --->
        SELECT 
            PERIOD_ID, 
            PERIOD, 
            OTHER_MONEY, 
            STANDART_PROCESS_MONEY, 
            RECORD_DATE, 
            RECORD_IP, 
            RECORD_EMP, 
            UPDATE_DATE, 
            UPDATE_IP, 
            UPDATE_EMP, 
            PROCESS_DATE 
        FROM 
            SETUP_PERIOD 
        WHERE 
            PERIOD_ID = #session.ep.period_id#
    </cfquery>
    <script type="text/javascript">
	record_exist=0;
	function kontrol()
	{
		if (!chk_process_cat('add_invent')) return false;
		if(!check_display_files('add_invent')) return false;
		if(add_invent.department_id.value=="")
		{
			alert("<cf_get_lang no='91.Departman Seçiniz'>!");
			return false;
		}
		//change_paper_duedate('invoice_date');
		for(r=1;r<=add_invent.record_num.value;r++)
		{
			if(eval("document.add_invent.row_kontrol"+r).value == 1)
			{
				record_exist=1;
				if (eval("document.add_invent.invent_no"+r).value == "")
				{ 
					alert ("<cf_get_lang no='88.Lütfen Demirbaş No Giriniz'>!");
					return false;
				}
				if (eval("document.add_invent.invent_name"+r).value == "")
				{ 
					alert ("<cf_get_lang no='93.Lütfen Açıklama Giriniz'> !");
					return false;
				}
				if ((eval("document.add_invent.row_total"+r).value == "")||(eval("document.add_invent.row_total"+r).value ==0))
				{ 
					alert ("<cf_get_lang_main no='1738.Lütfen Tutar Giriniz '>!");
					return false;
				}
				if ((eval("document.add_invent.amortization_rate"+r).value == "")||(eval("document.add_invent.amortization_rate"+r).value ==0))
				{ 
					alert ("<cf_get_lang no='95.Lütfen Amortisman Oranı Giriniz'> !");
					return false;
				}
				if (eval("document.add_invent.account_code"+r).value == "")
				{ 
					alert ("<cf_get_lang no='96.Lütfen Muhasebe Kodu Seçiniz'>");
					return false;
				}
				if (eval("document.add_invent.last_diff_value"+r).value != 0 && filterNum(eval("document.add_invent.last_diff_value"+r).value) > 0 && eval("document.add_invent.budget_account_code"+r).value == "")
				{ 
					alert ("<cf_get_lang no='65.Lütfen Gelir/Gider Farkı İçin Muhasebe Kodu Seçiniz'>!");
					return false;
				}
				if (eval("document.add_invent.last_diff_value"+r).value != 0 && filterNum(eval("document.add_invent.last_diff_value"+r).value) > 0 && eval("document.add_invent.amort_account_code"+r).value == "")
				{ 
					alert ("<cf_get_lang no='64.Lütfen Amortisman Karşılık Muhasebe Kodu Seçiniz'>!");
					return false;
				}
				if (eval("document.add_invent.stock_id"+r).value == '' || eval("document.add_invent.product_name"+r).value == '')
				{
					alert ("<cf_get_lang_main no='313.Ürün Seçiniz'> !");
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
		for(r=1;r<=add_invent.record_num.value;r++)
		{
			deger_total = eval("document.add_invent.row_total"+r);
			deger_kdv_total= eval("document.add_invent.kdv_total"+r);
			deger_net_total = eval("document.add_invent.net_total"+r);
			deger_other_net_total = eval("document.add_invent.row_other_total"+r);
			deger_amortization_rate = eval("document.add_invent.amortization_rate"+r);
			last_diff_value = eval("document.add_invent.last_diff_value"+r);
			last_inventory_value = eval("document.add_invent.last_inventory_value"+r);
			total_first_value = eval("document.add_invent.total_first_value"+r);
			unit_first_value = eval("document.add_invent.unit_first_value"+r);
			
			deger_total.value = filterNum(deger_total.value);
			deger_kdv_total.value = filterNum(deger_kdv_total.value);
			deger_net_total.value = filterNum(deger_net_total.value);
			deger_other_net_total.value = filterNum(deger_other_net_total.value);
			deger_amortization_rate.value = filterNum(deger_amortization_rate.value);
			last_diff_value.value = filterNum(last_diff_value.value);
			last_inventory_value.value = filterNum(last_inventory_value.value);
			total_first_value.value = filterNum(total_first_value.value);
			unit_first_value.value = filterNum(unit_first_value.value);
		}
	
		document.add_invent.total_amount.value = filterNum(document.add_invent.total_amount.value);
		document.add_invent.kdv_total_amount.value = filterNum(document.add_invent.kdv_total_amount.value);
		document.add_invent.net_total_amount.value = filterNum(document.add_invent.net_total_amount.value);
		document.add_invent.other_total_amount.value = filterNum(document.add_invent.other_total_amount.value);
		document.add_invent.other_kdv_total_amount.value = filterNum(document.add_invent.other_kdv_total_amount.value);
		document.add_invent.other_net_total_amount.value = filterNum(document.add_invent.other_net_total_amount.value);
		
		for(s=1;s<=add_invent.kur_say.value;s++)
		{
			eval('add_invent.txt_rate2_' + s).value = filterNum(eval('add_invent.txt_rate2_' + s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			eval('add_invent.txt_rate1_' + s).value = filterNum(eval('add_invent.txt_rate1_' + s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
	}
	row_count=0;
	satir_say=0;
	function sil(sy)
	{
		var my_element=eval("add_invent.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
		toplam_hesapla();
		satir_say--;
	}
	function hesapla(satir,hesap_type)
	{
		var toplam_dongu_0 = 0;//satir toplam
		if(eval("document.add_invent.row_kontrol"+satir).value==1)
		{
			deger_total = eval("document.add_invent.row_total"+satir);//tutar
			deger_miktar = eval("document.add_invent.quantity"+satir);//miktar
			deger_kdv_total= eval("document.add_invent.kdv_total"+satir);//kdv tutarı
			deger_net_total = eval("document.add_invent.net_total"+satir);//kdvli tutar
			deger_tax_rate = eval("document.add_invent.tax_rate"+satir);//kdv oranı
			deger_last_value = eval("document.add_invent.last_inventory_value"+satir);//Son değer
			deger_other_net_total = eval("document.add_invent.row_other_total"+satir);//dovizli tutar kdv dahil
			deger_diff_value = eval("document.add_invent.last_diff_value"+satir);//Fark
			deger_first_value = eval("document.add_invent.total_first_value"+satir);//İlk değer
			deger_last_unit_value = eval("document.add_invent.unit_last_value"+satir);//Son değer birim
			deger_first_unit_value = eval("document.add_invent.unit_first_value"+satir);//İlk değer birim
			if(deger_total.value == "") deger_total.value = 0;
			if(deger_kdv_total.value == "") deger_kdv_total.value = 0;
			if(deger_net_total.value == "") deger_net_total.value = 0;
			deger_money_id = eval("document.add_invent.money_id"+satir);
			deger_money_id_ilk = list_getat(deger_money_id.value,2,',');
			deger_money_id_son = list_getat(deger_money_id.value,3,',');
			deger_miktar.value = filterNum(deger_miktar.value,0);
			deger_total.value = filterNum(deger_total.value);
			deger_kdv_total.value = filterNum(deger_kdv_total.value);
			deger_net_total.value = filterNum(deger_net_total.value);
			deger_other_net_total.value = filterNum(deger_other_net_total.value);
			deger_diff_value.value = filterNum(deger_diff_value.value);
			deger_last_unit_value.value = filterNum(deger_last_unit_value.value);
			deger_first_unit_value.value = filterNum(deger_first_unit_value.value);
			deger_first_value.value = filterNum(deger_first_value.value);
			if(hesap_type ==undefined)
			{
				deger_kdv_total.value = (parseFloat(deger_total.value) * deger_miktar.value * deger_tax_rate.value)/100;
			}else if(hesap_type == 2)
			{
				deger_total.value = ((parseFloat(deger_net_total.value)*100)/ (parseFloat(deger_tax_rate.value)+100))/deger_miktar.value;
				deger_kdv_total.value = (parseFloat(deger_total.value * deger_miktar.value * deger_tax_rate.value))/100;
			}
			toplam_dongu_0 = (parseFloat(deger_total.value)*deger_miktar.value) + parseFloat(deger_kdv_total.value);
			deger_other_net_total.value = ((parseFloat(deger_total.value) + parseFloat(deger_kdv_total.value)) * parseFloat(deger_money_id_ilk) / (parseFloat(deger_money_id_son)));
			deger_net_total.value = commaSplit(toplam_dongu_0);
			deger_kdv_total.value = commaSplit(deger_kdv_total.value);
			deger_other_net_total.value = commaSplit(deger_other_net_total.value);
			deger_last_value.value = filterNum(deger_last_value.value);
			deger_last_value.value =  parseFloat(deger_last_unit_value.value * deger_miktar.value);
			deger_first_value.value =  parseFloat(deger_first_unit_value.value * deger_miktar.value);
			deger_diff_value.value = parseFloat((deger_total.value * deger_miktar.value)  - deger_last_value.value);
			deger_diff_value.value = commaSplit(deger_diff_value.value);
			deger_last_value.value = commaSplit(deger_last_value.value);
			deger_last_unit_value.value = commaSplit(deger_last_unit_value.value);
			deger_first_value.value = commaSplit(deger_first_value.value);
			deger_first_unit_value.value = commaSplit(deger_first_unit_value.value);
			deger_total.value = commaSplit(deger_total.value);
		}
		toplam_hesapla();
	}
	function toplam_hesapla()
	{
		var toplam_dongu_1 = 0;//tutar genel toplam
		var toplam_dongu_2 = 0;// kdv genel toplam
		var toplam_dongu_3 = 0;// kdvli genel toplam
		var toplam_dongu_4 = 0;// kdvli genel toplam
		var beyan_tutar = 0;
		var tevkifat_info = "";
		var beyan_tutar_info = "";
		var new_taxArray = new Array(0);
		var taxBeyanArray = new Array(0);
		var taxTevkifatArray = new Array(0);
		for(r=1;r<=add_invent.record_num.value;r++)
		{
			if(eval("document.add_invent.row_kontrol"+r).value==1)
			{
				toplam_dongu_4 = toplam_dongu_4 + (parseFloat(filterNum(eval("document.add_invent.row_total"+r).value) * filterNum(eval("document.add_invent.quantity"+r).value)));
			}
		}			
		genel_indirim_yuzdesi = commaSplit(parseFloat(document.add_invent.net_total_discount.value) / parseFloat(toplam_dongu_4),8);
		genel_indirim_yuzdesi = filterNum(genel_indirim_yuzdesi,8);
		genel_indirim_yuzdesi = wrk_round(genel_indirim_yuzdesi,2);
		deger_discount_value = document.add_invent.net_total_discount.value;
		deger_discount_value = filterNum(deger_discount_value,4);
	
		for(r=1;r<=add_invent.record_num.value;r++)
		{
			if(eval("document.add_invent.row_kontrol"+r).value==1)
			{
				deger_total = eval("document.add_invent.row_total"+r);//tutar
				deger_miktar = eval("document.add_invent.quantity"+r);//miktar
				deger_kdv_total= eval("document.add_invent.kdv_total"+r);//kdv tutarı
				deger_net_total = eval("document.add_invent.net_total"+r);//kdvli tutar
				deger_tax_rate = eval("document.add_invent.tax_rate"+r);//kdv oranı
				deger_other_net_total = eval("document.add_invent.row_other_total"+r);//dovizli tutar kdv dahil
				deger_money_id = eval("document.add_invent.money_id"+r);
				deger_money_id_ilk = list_getat(deger_money_id.value,1,',');
				for(s=1;s<=add_invent.kur_say.value;s++)
					{
						if(list_getat(document.add_invent.rd_money[s-1].value,1,',') == deger_money_id_ilk)
						{
							satir_rate2= eval("document.add_invent.txt_rate2_"+s).value;
						}
					}
				satir_rate2= filterNum(satir_rate2,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');			
				deger_total.value = filterNum(deger_total.value);
				deger_kdv_total.value = filterNum(deger_kdv_total.value);
				deger_net_total.value = filterNum(deger_net_total.value);
				deger_other_net_total.value = filterNum(deger_other_net_total.value);
				toplam_dongu_1 = toplam_dongu_1 + parseFloat(deger_total.value * deger_miktar.value);
				deger_other_net_total.value = ((parseFloat(deger_total.value * deger_miktar.value) + parseFloat(deger_kdv_total.value)) / (parseFloat(satir_rate2)));
				toplam_dongu_2 = toplam_dongu_2 + parseFloat(deger_kdv_total.value)- parseFloat(deger_kdv_total.value*genel_indirim_yuzdesi);
				deger_indirim_kdv = parseFloat(deger_kdv_total.value)- parseFloat(deger_kdv_total.value*genel_indirim_yuzdesi);
				toplam_dongu_3 = toplam_dongu_3 + ((parseFloat(deger_total.value)- (parseFloat(deger_total.value)*genel_indirim_yuzdesi)) * filterNum(eval("document.add_invent.quantity"+r).value));
				toplam_dongu_3 = toplam_dongu_3 + parseFloat(deger_kdv_total.value)- parseFloat(deger_kdv_total.value*genel_indirim_yuzdesi);
				
				if(document.add_invent.tevkifat_oran != undefined && document.add_invent.tevkifat_oran.value != "" && add_invent.tevkifat_box.checked == true)
				{//tevkifat hesaplamaları
					beyan_tutar = beyan_tutar + wrk_round(deger_indirim_kdv*filterNum(document.add_invent.tevkifat_oran.value)/100);
					if(new_taxArray.length != 0)
						for (var m=0; m < new_taxArray.length; m++)
						{	
							var tax_flag = false;
							if(new_taxArray[m] == deger_tax_rate.value){
								tax_flag = true;
								taxBeyanArray[m] += wrk_round(deger_indirim_kdv - (deger_indirim_kdv*(filterNum(document.add_invent.tevkifat_oran.value)/100)));
								taxTevkifatArray[m] += wrk_round(deger_indirim_kdv*(filterNum(document.add_invent.tevkifat_oran.value)/100));
								break;
							}
						}
					if(!tax_flag){
						new_taxArray[new_taxArray.length] = deger_tax_rate.value;
						taxBeyanArray[taxBeyanArray.length] = wrk_round(deger_indirim_kdv - (deger_indirim_kdv*(filterNum(document.add_invent.tevkifat_oran.value)/100)));
						taxTevkifatArray[taxTevkifatArray.length] = wrk_round(deger_indirim_kdv*(filterNum(document.add_invent.tevkifat_oran.value)/100));
					}
				}
				deger_net_total.value = commaSplit(deger_net_total.value);
				deger_total.value = commaSplit(deger_total.value);
				deger_kdv_total.value = commaSplit(deger_kdv_total.value);
				deger_other_net_total.value = commaSplit(deger_other_net_total.value);
			}
		}	
		if(document.add_invent.tevkifat_oran != undefined && document.add_invent.tevkifat_oran.value != "" && add_invent.tevkifat_box.checked == true)
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
		
		document.add_invent.total_amount.value = commaSplit(toplam_dongu_1);
		document.add_invent.kdv_total_amount.value = commaSplit(toplam_dongu_2); 
		document.add_invent.net_total_amount.value = commaSplit(toplam_dongu_3);
		for(s=1;s<=add_invent.kur_say.value;s++)
		{
			form_txt_rate2_ = eval("document.add_invent.txt_rate2_"+s);
			if(form_txt_rate2_.value == "")
				form_txt_rate2_.value = 1;
		}
		if(add_invent.kur_say.value == 1)
			for(s=1;s<=add_invent.kur_say.value;s++)
			{
				if(document.add_invent.rd_money.checked == true)
				{
					deger_diger_para = document.add_invent.rd_money;
					form_txt_rate2_ = eval("document.add_invent.txt_rate2_"+s);
				}
			}
		else 
			for(s=1;s<=add_invent.kur_say.value;s++)
			{
				if(document.add_invent.rd_money[s-1].checked == true)
				{
					deger_diger_para = document.add_invent.rd_money[s-1];
					form_txt_rate2_ = eval("document.add_invent.txt_rate2_"+s);
				}
			}
		deger_money_id_1 = list_getat(deger_diger_para.value,1,',');
		deger_money_id_3 = list_getat(deger_diger_para.value,3,',');
		form_txt_rate2_.value = filterNum(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.add_invent.other_total_amount.value = commaSplit(toplam_dongu_1 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)));
		document.add_invent.other_kdv_total_amount.value = commaSplit(toplam_dongu_2 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value))); 
		document.add_invent.other_net_total_amount.value = commaSplit(toplam_dongu_3 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)));
		document.add_invent.other_net_total_discount.value = commaSplit(deger_discount_value* parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)));
		document.add_invent.net_total_discount.value = commaSplit(deger_discount_value);
		document.add_invent.tl_value1.value = deger_money_id_1;
		document.add_invent.tl_value2.value = deger_money_id_1;
		document.add_invent.tl_value3.value = deger_money_id_1;
		document.add_invent.tl_value4.value = deger_money_id_1;
		form_txt_rate2_.value = commaSplit(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	}
	function gonder(invent_id,invent_name,invent_no,quantity,acc_id,amort_rate,amortizaton_method,unit_last_value,last_inventory_value,unit_first_value,total_first_value,last_diff_value,expense_center_id,expense_center_name,budget_item_id,budget_item_name,debt_account_id,claim_account_id,product_id,product_name,stock_unit_id,stock_id,stock_unit)
	{
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
		document.add_invent.record_num.value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		x = '<input  type="hidden" value="WRK'+row_count+ js_create_unique_id() + row_count+'" name="wrk_row_id' + row_count +'"><input  type="hidden" value="" name="wrk_row_relation_id' + row_count +'">';
		newCell.innerHTML = x + '<input  type="hidden" value="1" name="row_kontrol' + row_count +'" ><a href="javascript://" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="invent_id' + row_count +'" value="'+ invent_id +'" readonly><input type="text" name="invent_no' + row_count +'" style="width:100%;" class="boxtext" value="'+ invent_no +'" maxlength="50">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" readonly name="invent_name' + row_count +'" style="width:100px;" class="boxtext" value="'+ invent_name +'" maxlength="100">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("add_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<input type="text" name="quantity' + row_count +'" style="width:100%;" class="box" value="'+ quantity +'" onBlur="hesapla(' + row_count +');" onkeyup="return(FormatCurrency(this,event));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("add_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<input type="text" name="row_total' + row_count +'" value="' + unit_last_value + '" onkeyup="return(FormatCurrency(this,event));" onBlur="hesapla(' + row_count +');" style="width:100%;" class="box">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("add_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<select name="tax_rate'+ row_count +'" style="width:100%;" onChange="hesapla('+ row_count +');" class="box"><cfoutput query="get_tax"><option value="#tax#">#tax#</option></cfoutput></select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("add_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<input type="text" name="kdv_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event));" style="width:60px;" onBlur="hesapla(' + row_count +',1);" class="box">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("add_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<input type="text" name="net_total' + row_count +'" value="0" class="box" readonly>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("add_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<input type="text" name="row_other_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" readonly>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("add_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<select name="money_id' + row_count  +'" style="width:100%;" class="boxtext" onChange="hesapla('+ row_count +');"><cfoutput query="get_money"><option value="#money#,#rate1#,#rate2#" <cfif money eq session.ep.money>selected</cfif>>#money#</option></cfoutput></select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("add_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<input type="text" name="amortization_rate' + row_count +'" value="'+ amort_rate +'" style="width:100%;" class="box" onkeyup="return(FormatCurrency(this,event));" readonly="yes">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("add_invent.invent_name"+satir_say).value;	
		if(amortizaton_method == 0)
			newCell.innerHTML = '<input type="text" readonly name="amortization_method'+ row_count +'" style="width:165px;" class="boxtext" value="<cf_get_lang_main no="1624.Azalan Bakiye Üzerinden">">';
		else if(amortizaton_method == 1)
			newCell.innerHTML = '<input type="text" readonly name="amortization_method'+ row_count +'" style="width:165px;" class="boxtext" value="<cf_get_lang_main no="1625.Sabit Miktar Üzeriden">">';
		else if(amortizaton_method == 2)
			newCell.innerHTML = '<input type="text" readonly name="amortization_method'+ row_count +'" style="width:165px;" class="boxtext" value="<cf_get_lang_main no="1626.Hızlandırılmış Azalan Bakiye">">';	
		else
			newCell.innerHTML = '<input type="text" readonly name="amortization_method'+ row_count +'" style="width:165px;" class="boxtext" value="<cf_get_lang_main no="1627.Hızlandırılmış Sabit Değer">">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("add_invent.invent_name"+satir_say).value;
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input  type="hidden" name="account_id' + row_count +'" id="account_id' + row_count +'" value="'+ acc_id +'"><input type="text" name="account_code' + row_count +'" id="account_code' + row_count +'" value="'+ acc_id +'" class="boxtext" onFocus="autocomp_account('+row_count+');"><a href="javascript://"onclick="pencere_ac_acc('+ row_count +');" ><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("add_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<input type="hidden" name="unit_last_value' + row_count +'" value="'+ unit_last_value +'"><input type="hidden" name="unit_first_value' + row_count +'" value="'+ unit_first_value +'"><input type="hidden" name="total_first_value' + row_count +'" value="'+ total_first_value +'"><input type="text" name="last_inventory_value' + row_count +'" value="'+ last_inventory_value +'" style="width:100%;" class="box" onkeyup="return(FormatCurrency(this,event));" readonly="yes">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("add_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<input type="text" name="last_diff_value' + row_count +'" value="'+last_diff_value+'" style="width:100%;" class="box" onkeyup="return(FormatCurrency(this,event));" readonly="yes">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML ='<input type="hidden" name="expense_center_id' + row_count +'" value="'+expense_center_id+'" id="expense_center_id' + row_count +'"><input type="text" id="expense_center_name' + row_count +'" name="expense_center_name' + row_count +'" onFocus="exp_center('+row_count+');" value="'+expense_center_name+'" style="width:150px;" class="boxtext"><a href="javascript://" onClick="pencere_ac_exp_center('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.title=eval("add_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<input  type="hidden" name="budget_item_id' + row_count +'" id="budget_item_id' + row_count +'" value='+budget_item_id+'><input type="text" style="width:115px;" name="budget_item_name' + row_count +'" id="budget_item_name' + row_count +'" class="boxtext" value="'+budget_item_name+'" onFocus="exp_item('+row_count+');"><a href="javascript://"><img src="/images/plus_thin.gif" onclick="pencere_ac_exp('+ row_count +');" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.title=eval("add_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<input  type="hidden" name="budget_account_id' + row_count +'" id="budget_account_id' + row_count +'" value="'+debt_account_id+'"><input type="text" name="budget_account_code' + row_count +'" id="budget_account_code' + row_count +'"  value="'+debt_account_id+'" class="boxtext" style="width:155px;" onFocus="autocomp_budget_account('+row_count+');"><a href="javascript://"onclick="pencere_ac_acc_1('+ row_count +');" ><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.title=eval("add_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<input  type="hidden" name="amort_account_id' + row_count +'" id="amort_account_id' + row_count +'" value="'+claim_account_id+'"><input type="text" name="amort_account_code' + row_count +'" id="amort_account_code' + row_count +'" value="'+claim_account_id+'" class="boxtext" style="width:205px;" onFocus="autocomp_amort_account('+row_count+');"><a href="javascript://"onclick="pencere_ac_acc_2('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.title=eval("add_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<input  type="hidden" name="product_id' + row_count +'" value="'+product_id+'"><input type="hidden" name="stock_id' + row_count +'" value="'+stock_id+'"><input type="text" name="product_name' + row_count +'"  value="'+product_name+'" class="boxtext" style="width:110px;">'
		newCell.innerHTML += ' ' + '<a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&product_id=add_invent.product_id" + row_count + "&field_id=add_invent.stock_id" + row_count + "&field_unit_name=add_invent.stock_unit" + row_count + "&field_main_unit=add_invent.stock_unit_id" + row_count + "&field_name=add_invent.product_name" + row_count + "','list');"+'"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("add_invent.invent_name"+satir_say).value;
		newCell.innerHTML = '<input type="hidden" name="stock_unit_id' + row_count +'" value="'+stock_unit_id+'" ><input type="text" name="stock_unit' + row_count +'" style="width:100%;" value="'+stock_unit+'" class="boxtext">';
		hesapla(row_count);
	}
	/* masraf merkezi popup */
	function pencere_ac_exp_center(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=add_invent.expense_center_id' + no +'&field_name=add_invent.expense_center_name' + no,'list');
	}
	/* masraf merkezi autocomplete */
	function exp_center(no)
	{
		AutoComplete_Create("expense_center_name" + no,"EXPENSE,EXPENSE_CODE","EXPENSE,EXPENSE_CODE","get_expense_center","","EXPENSE_ID","expense_center_id"+no,"",3);
	}
	/* gider kalemi autocomplete */
	function exp_item(no)
	{
		AutoComplete_Create("budget_item_name" + no,"EXPENSE_ITEM_NAME","EXPENSE_ITEM_NAME","get_expense_item","","EXPENSE_ITEM_ID,ACCOUNT_CODE,ACCOUNT_CODE","budget_item_id"+no+",budget_account_code"+no+",budget_account_id"+no,"",3);
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
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_invent.account_id' + no +'&field_name=add_invent.account_code' + no +'','list');
	}
	function pencere_ac_acc_1(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_invent.budget_account_id' + no +'&field_name=add_invent.budget_account_code' + no +'','list');
	}
	function pencere_ac_acc_2(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_invent.amort_account_id' + no +'&field_name=add_invent.amort_account_code' + no +'','list');
	}
	function pencere_ac_exp(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=add_invent.budget_item_id' + no +'&field_name=add_invent.budget_item_name' + no +'&field_account_no=add_invent.budget_account_code' + no +'&field_account_no2=add_invent.budget_account_id' + no +'','list');
	}
	function ayarla_gizle_goster()
	{
		if(add_invent.cash.checked)
			kasa_sec.style.display='';
		else
			kasa_sec.style.display='none';
	}
	function f_add_invent()
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_inventory&field_id=add_invent.invent_id','wide');
	}
</script>
</cfif>

<cfif  IsDefined("attributes.event") and attributes.event eq 'upd'>
	<cfquery name="GET_FIS_DET" datasource="#dsn2#">
        SELECT * FROM STOCK_FIS WHERE FIS_ID = #attributes.fis_id#
    </cfquery>
    <cfif not GET_FIS_DET.recordcount>
        <br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Fatura Bulunmamaktadır'>!</font>
        <cfexit method="exittemplate">
    </cfif>
    <cfquery name="GET_STOCK_FIS_MONEY" datasource="#dsn2#">
        SELECT MONEY_TYPE AS MONEY,* FROM STOCK_FIS_MONEY WHERE ACTION_ID = #attributes.fis_id#
    </cfquery>
    <cfquery name="GET_STOCK_MONEY" datasource="#dsn2#">
        SELECT RATE2,RATE1,MONEY_TYPE FROM STOCK_FIS_MONEY WHERE ACTION_ID = #attributes.fis_id# AND IS_SELECTED=1
    </cfquery>
    <cfif not GET_STOCK_FIS_MONEY.recordcount>
        <cfquery name="GET_INVOICE_MONEY" datasource="#DSN#">
            SELECT MONEY,RATE2,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS=1
        </cfquery>
    </cfif>
    
    <cfquery name="GET_ACCOUNTS" datasource="#dsn3#">
        SELECT ACCOUNT_ID,ACCOUNT_CURRENCY_ID,ACCOUNT_NAME FROM ACCOUNTS ORDER BY ACCOUNT_NAME
    </cfquery>
    
    <cfquery name="GET_INVENTORY_CATS" datasource="#dsn3#">
        SELECT * FROM SETUP_INVENTORY_CAT ORDER BY INVENTORY_CAT_ID
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
            AND IR.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.fis_id#">
            AND IR.PROCESS_TYPE = 1182
            AND PERIOD_ID = #session.ep.period_id#
    </cfquery>
    <cfif len(get_fis_det.project_id)>
        <cfquery name="GET_PROJECT" datasource="#dsn#">
            SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #get_fis_det.project_id#
        </cfquery>
    </cfif>
    <cfif session.ep.our_company_info.subscription_contract eq 1>
		<cfif len(get_fis_det.subscription_id)>
            <cfquery name="GET_SUBS_INFO" datasource="#dsn3#">
                SELECT * FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = #get_fis_det.subscription_id#
            </cfquery>
        </cfif>
	</cfif>
    <cfif  len(get_fis_det.RELATED_SHIP_ID)>
    	 <cfquery name="get_related_ship" datasource="#dsn2#">
            SELECT SHIP_NUMBER FROM SHIP WHERE SHIP_ID = #get_fis_det.RELATED_SHIP_ID#
        </cfquery>
    </cfif>
    <cfquery name="GET_ROWS" datasource="#dsn2#">
        SELECT
            STOCK_FIS_ROW.*,
            INVENTORY.*,
            S.PRODUCT_ID,
            S.PRODUCT_NAME,
            STOCK_FIS_ROW.AMOUNT STOCK_QUANTITY,
            INVENTORY.AMOUNT INVENT_AMOUNT,
            EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
            EXPENSE_ITEMS.ACCOUNT_CODE,
            EXPENSE_CENTER.*
        FROM
            STOCK_FIS_ROW
            LEFT JOIN #dsn3_alias#.STOCKS S ON STOCK_FIS_ROW.STOCK_ID = S.STOCK_ID 
            LEFT JOIN #dsn3_alias#.INVENTORY INVENTORY ON INVENTORY.INVENTORY_ID = STOCK_FIS_ROW.INVENTORY_ID
            LEFT JOIN #dsn_alias#.EXPENSE_ITEMS  ON EXPENSE_ITEMS.EXPENSE_ITEM_ID = INVENTORY.EXPENSE_ITEM_ID
            LEFT JOIN #dsn_alias#.EXPENSE_CENTER ON EXPENSE_CENTER.EXPENSE_ID = INVENTORY.SALE_EXPENSE_CENTER_ID
        WHERE
            STOCK_FIS_ROW.FIS_ID = #attributes.fis_id# 
            
    </cfquery>
    <script type="text/javascript">
	function kontrol()
	{
		if (!chk_process_cat('add_invent')) return false;
		if(!check_display_files('add_invent')) return false;
		if(add_invent.department_id.value=="" || add_invent.department_name.value=="")
		{
			alert("<cf_get_lang no='91.Departman Seçiniz'>!");
			return false;
		}
		record_exist=0;
		for(r=1;r<=add_invent.record_num.value;r++)
		{
			if(eval("document.add_invent.row_kontrol"+r).value == 1)
			{
				record_exist=1;
				if (eval("document.add_invent.invent_no"+r).value == "")
				{ 
					alert ("<cf_get_lang no='88.Lütfen Demirbaş No Giriniz'>!");
					return false;
				}
				if (eval("document.add_invent.invent_name"+r).value == "")
				{ 
					alert ("<cf_get_lang no='93.Lütfen Açıklama Giriniz'>  !");
					return false;
				}
				if ((eval("document.add_invent.row_total"+r).value == "")||(eval("document.add_invent.row_total"+r).value ==0))
				{ 
					alert ("<cf_get_lang_main no='1738.Lütfen Tutar Giriniz '>!");
					return false;
				}
				if ((eval("document.add_invent.amortization_rate"+r).value == "")||(eval("document.add_invent.amortization_rate"+r).value ==0))
				{ 
					alert ("<cf_get_lang no='95.Lütfen Amortisman Oranı Giriniz'> !");
					return false;
				}
				if (eval("document.add_invent.account_code"+r).value == "")
				{ 
					alert ("<cf_get_lang no='96.Lütfen Muhasebe Kodu Seçiniz'>");
					return false;
				}
				if (eval("document.add_invent.last_diff_value"+r).value != 0 && filterNum(eval("document.add_invent.last_diff_value"+r).value) > 0 && eval("document.add_invent.budget_account_code"+r).value == "")
				{ 
					alert ("<cf_get_lang no='65.Lütfen Gelir/Gider Farkı İçin Muhasebe Kodu Seçiniz'>!");
					return false;
				}
				if (eval("document.add_invent.last_diff_value"+r).value != 0 && filterNum(eval("document.add_invent.last_diff_value"+r).value) > 0 && eval("document.add_invent.amort_account_code"+r).value == "")
				{ 
					alert ("<cf_get_lang no='64.Lütfen Amortisman Karşılık Muhasebe Kodu Seçiniz'>!");
					return false;
				}
				if (eval("document.add_invent.stock_id"+r).value == '' || eval("document.add_invent.product_name"+r).value == '')
				{
					alert ("<cf_get_lang_main no='313.Ürün Seçiniz'> !");
					return false;
				}
				var listParam = eval("document.add_invent.invent_id"+r).value;
				var get_invent_amortization = wrk_safe_query("get_inventory_amort_number","dsn3",0,listParam);
				if(get_invent_amortization.recordcount)
				{
					if(datediff(date_format(get_invent_amortization.RECORD_DATE,'dd/mm/yyyy'),document.add_invent.start_date.value,0) <= 0)
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
		unformat_fields();
		return true;
	}
	function unformat_fields()
	{
		for(r=1;r<=add_invent.record_num.value;r++)
		{
			deger_total = eval("document.add_invent.row_total"+r);
			deger_kdv_total= eval("document.add_invent.kdv_total"+r);
			deger_net_total = eval("document.add_invent.net_total"+r);
			deger_other_net_total = eval("document.add_invent.row_other_total"+r);
			deger_amortization_rate = eval("document.add_invent.amortization_rate"+r);
			last_diff_value = eval("document.add_invent.last_diff_value"+r);
			last_inventory_value = eval("document.add_invent.last_inventory_value"+r);
			total_first_value = eval("document.add_invent.total_first_value"+r);
			unit_first_value = eval("document.add_invent.unit_first_value"+r);
			
			deger_total.value = filterNum(deger_total.value);
			deger_kdv_total.value = filterNum(deger_kdv_total.value);
			deger_net_total.value = filterNum(deger_net_total.value);
			deger_other_net_total.value = filterNum(deger_other_net_total.value);
			deger_amortization_rate.value = filterNum(deger_amortization_rate.value);
			last_diff_value.value = filterNum(last_diff_value.value);
			last_inventory_value.value = filterNum(last_inventory_value.value);
			total_first_value.value = filterNum(total_first_value.value);
			unit_first_value.value = filterNum(unit_first_value.value);
		}
	
		document.add_invent.total_amount.value = filterNum(document.add_invent.total_amount.value);
		document.add_invent.kdv_total_amount.value = filterNum(document.add_invent.kdv_total_amount.value);
		document.add_invent.net_total_amount.value = filterNum(document.add_invent.net_total_amount.value);
		document.add_invent.other_total_amount.value = filterNum(document.add_invent.other_total_amount.value);
		document.add_invent.other_kdv_total_amount.value = filterNum(document.add_invent.other_kdv_total_amount.value);
		document.add_invent.other_net_total_amount.value = filterNum(document.add_invent.other_net_total_amount.value);
		
		for(s=1;s<=add_invent.kur_say.value;s++)
		{
			eval('add_invent.txt_rate2_' + s).value = filterNum(eval('add_invent.txt_rate2_' + s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			eval('add_invent.txt_rate1_' + s).value = filterNum(eval('add_invent.txt_rate1_' + s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
	}
	row_count=<cfoutput>#get_rows.recordcount#</cfoutput>;
	satir_say=<cfoutput>#get_rows.recordcount#</cfoutput>;
	function sil(sy)
	{
		var my_element=eval("add_invent.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
		toplam_hesapla();
		satir_say--;
	}
	function hesapla(satir,hesap_type)
	{
		var toplam_dongu_0 = 0;//satir toplam
		if(eval("document.add_invent.row_kontrol"+satir).value==1)
		{
			deger_total = eval("document.add_invent.row_total"+satir);//tutar
			deger_miktar = eval("document.add_invent.quantity"+satir);//miktar
			deger_kdv_total= eval("document.add_invent.kdv_total"+satir);//kdv tutarı
			deger_net_total = eval("document.add_invent.net_total"+satir);//kdvli tutar
			deger_tax_rate = eval("document.add_invent.tax_rate"+satir);//kdv oranı
			deger_last_value = eval("document.add_invent.last_inventory_value"+satir);//Son değer
			deger_other_net_total = eval("document.add_invent.row_other_total"+satir);//dovizli tutar kdv dahil
			deger_diff_value = eval("document.add_invent.last_diff_value"+satir);//Fark
			deger_first_value = eval("document.add_invent.total_first_value"+satir);//İlk değer
			deger_last_unit_value = eval("document.add_invent.unit_last_value"+satir);//Son değer birim
			deger_first_unit_value = eval("document.add_invent.unit_first_value"+satir);//İlk değer birim
			if(deger_total.value == "") deger_total.value = 0;
			if(deger_kdv_total.value == "") deger_kdv_total.value = 0;
			if(deger_net_total.value == "") deger_net_total.value = 0;
			deger_money_id = eval("document.add_invent.money_id"+satir);
			deger_money_id_ilk = list_getat(deger_money_id.value,2,',');
			deger_money_id_son = list_getat(deger_money_id.value,3,',');
			deger_miktar.value = filterNum(deger_miktar.value,0);
			deger_total.value = filterNum(deger_total.value);
			deger_kdv_total.value = filterNum(deger_kdv_total.value);
			deger_net_total.value = filterNum(deger_net_total.value);
			deger_other_net_total.value = filterNum(deger_other_net_total.value);
			deger_diff_value.value = filterNum(deger_diff_value.value);
			deger_last_unit_value.value = filterNum(deger_last_unit_value.value);
			deger_first_unit_value.value = filterNum(deger_first_unit_value.value);
			deger_first_value.value = filterNum(deger_first_value.value);
			if(hesap_type ==undefined)
			{
				deger_kdv_total.value = (parseFloat(deger_total.value) * deger_miktar.value * deger_tax_rate.value)/100;
			}else if(hesap_type == 2)
			{
				deger_total.value = ((parseFloat(deger_net_total.value)*100)/ (parseFloat(deger_tax_rate.value)+100))/deger_miktar.value;
				deger_kdv_total.value = (parseFloat(deger_total.value * deger_miktar.value * deger_tax_rate.value))/100;
			}
			toplam_dongu_0 = (parseFloat(deger_total.value)*deger_miktar.value) + parseFloat(deger_kdv_total.value);
			deger_other_net_total.value = ((parseFloat(deger_total.value) + parseFloat(deger_kdv_total.value)) * parseFloat(deger_money_id_ilk) / (parseFloat(deger_money_id_son)));
			deger_net_total.value = commaSplit(toplam_dongu_0);
			deger_kdv_total.value = commaSplit(deger_kdv_total.value);
			deger_other_net_total.value = commaSplit(deger_other_net_total.value);
			deger_last_value.value = filterNum(deger_last_value.value);
			deger_last_value.value =  parseFloat(deger_last_unit_value.value * deger_miktar.value);
			deger_first_value.value =  parseFloat(deger_first_unit_value.value * deger_miktar.value);
			deger_diff_value.value = parseFloat((deger_total.value * deger_miktar.value)  - deger_last_value.value);
			deger_diff_value.value = commaSplit(deger_diff_value.value);
			deger_last_value.value = commaSplit(deger_last_value.value);
			deger_last_unit_value.value = commaSplit(deger_last_unit_value.value);
			deger_first_value.value = commaSplit(deger_first_value.value);
			deger_first_unit_value.value = commaSplit(deger_first_unit_value.value);
			deger_total.value = commaSplit(deger_total.value);
		}
		toplam_hesapla();
	}
	function toplam_hesapla()
	{
		var toplam_dongu_1 = 0;//tutar genel toplam
		var toplam_dongu_2 = 0;// kdv genel toplam
		var toplam_dongu_3 = 0;// kdvli genel toplam
		for(r=1;r<=add_invent.record_num.value;r++)
		{
			if(eval("document.add_invent.row_kontrol"+r).value==1)
			{
				deger_total = eval("document.add_invent.row_total"+r);//tutar
				deger_miktar = eval("document.add_invent.quantity"+r);//miktar
				deger_kdv_total= eval("document.add_invent.kdv_total"+r);//kdv tutarı
				deger_net_total = eval("document.add_invent.net_total"+r);//kdvli tutar
				deger_tax_rate = eval("document.add_invent.tax_rate"+r);//kdv oranı
				deger_other_net_total = eval("document.add_invent.row_other_total"+r);//dovizli tutar kdv dahil
				deger_money_id = eval("document.add_invent.money_id"+r);
				deger_money_id_ilk = list_getat(deger_money_id.value,1,',');
				for(s=1;s<=add_invent.kur_say.value;s++)
					{
						if(list_getat(document.add_invent.rd_money[s-1].value,1,',') == deger_money_id_ilk)
						{
							satir_rate2= eval("document.add_invent.txt_rate2_"+s).value;
						}
					}
				satir_rate2= filterNum(satir_rate2,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');			
				deger_total.value = filterNum(deger_total.value);
				deger_kdv_total.value = filterNum(deger_kdv_total.value);
				deger_net_total.value = filterNum(deger_net_total.value);
				deger_other_net_total.value = filterNum(deger_other_net_total.value);
				toplam_dongu_1 = toplam_dongu_1 + parseFloat(deger_total.value * deger_miktar.value);
				toplam_dongu_2 = toplam_dongu_2 + parseFloat(deger_kdv_total.value);
				toplam_dongu_3 = toplam_dongu_3 + (parseFloat(deger_total.value * deger_miktar.value) + parseFloat(deger_kdv_total.value));
				deger_other_net_total.value = ((parseFloat(deger_total.value * deger_miktar.value) + parseFloat(deger_kdv_total.value)) / (parseFloat(satir_rate2)));
				deger_net_total.value = commaSplit(deger_net_total.value);
				deger_total.value = commaSplit(deger_total.value);
				deger_kdv_total.value = commaSplit(deger_kdv_total.value);
				deger_other_net_total.value = commaSplit(deger_other_net_total.value);
			}
		}
			
		document.add_invent.total_amount.value = commaSplit(toplam_dongu_1);
		document.add_invent.kdv_total_amount.value = commaSplit(toplam_dongu_2);
		document.add_invent.net_total_amount.value = commaSplit(toplam_dongu_3);
		for(s=1;s<=add_invent.kur_say.value;s++)
		{
			form_txt_rate2_ = eval("document.add_invent.txt_rate2_"+s);
			if(form_txt_rate2_.value == "")
				form_txt_rate2_.value = 1;
		}
		if(add_invent.kur_say.value == 1)
			for(s=1;s<=add_invent.kur_say.value;s++)
			{
				if(document.add_invent.rd_money.checked == true)
				{
					deger_diger_para = document.add_invent.rd_money;
					form_txt_rate2_ = eval("document.add_invent.txt_rate2_"+s);
				}
			}
		else 
			for(s=1;s<=add_invent.kur_say.value;s++)
			{
				if(document.add_invent.rd_money[s-1].checked == true)
				{
					deger_diger_para = document.add_invent.rd_money[s-1];
					form_txt_rate2_ = eval("document.add_invent.txt_rate2_"+s);
				}
			}
		deger_money_id_1 = list_getat(deger_diger_para.value,1,',');
		//deger_money_id_2 = list_getat(deger_diger_para.value,2,',');
		deger_money_id_3 = list_getat(deger_diger_para.value,3,',');
		form_txt_rate2_.value = filterNum(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.add_invent.other_total_amount.value = commaSplit(toplam_dongu_1 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)));
		document.add_invent.other_kdv_total_amount.value = commaSplit(toplam_dongu_2 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)));
		document.add_invent.other_net_total_amount.value = commaSplit(toplam_dongu_3 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)));
	
		document.add_invent.tl_value1.value = deger_money_id_1;
		document.add_invent.tl_value2.value = deger_money_id_1;
		document.add_invent.tl_value3.value = deger_money_id_1;
		form_txt_rate2_.value = commaSplit(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	}
	function gonder(invent_id,invent_name,invent_no,quantity,acc_id,amort_rate,amortizaton_method,unit_last_value,last_inventory_value,unit_first_value,total_first_value,last_diff_value,expense_center_id,expense_center_name,budget_item_id,budget_item_name,debt_account_id,claim_account_id,product_id,product_name,stock_unit_id,stock_id,stock_unit)
	{
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
		document.add_invent.record_num.value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		x = '<input  type="hidden" value="WRK'+row_count+ js_create_unique_id() + row_count+'" name="wrk_row_id' + row_count +'"><input  type="hidden" value="" name="wrk_row_relation_id' + row_count +'">';
		newCell.innerHTML = x + '<input  type="hidden" value="1" name="row_kontrol' + row_count +'" ><a href="javascript://" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="invent_id' + row_count +'" value="'+ invent_id +'" readonly><input type="text" name="invent_no' + row_count +'" style="width:100%;" class="boxtext" value="'+ invent_no +'">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="invent_name' + row_count +'" style="width:100%;"  readonly class="boxtext" value="'+ invent_name +'" maxlength="100">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("add_invent.invent_name"+satir_say).value;
		newCell.innerHTML = '<input type="text" name="quantity' + row_count +'" style="width:100%;" class="box" value="'+ quantity +'" onBlur="hesapla(' + row_count +');" onkeyup="return(FormatCurrency(this,event));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("add_invent.invent_name"+satir_say).value;
		newCell.innerHTML = '<input type="text" name="row_total' + row_count +'" value="' + unit_last_value + '" onkeyup="return(FormatCurrency(this,event));" onBlur="hesapla(' + row_count +');" style="width:100%;" class="box">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("add_invent.invent_name"+satir_say).value;
		newCell.innerHTML = '<select name="tax_rate'+ row_count +'" style="width:100%;" onChange="hesapla('+ row_count +');" class="box"><cfoutput query="get_tax"><option value="#tax#">#tax#</option></cfoutput></select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("add_invent.invent_name"+satir_say).value;
		newCell.innerHTML = '<input type="text" name="kdv_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" onBlur="hesapla(' + row_count +',1);" class="box">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("add_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<input type="text" name="net_total' + row_count +'" value="0" class="box" readonly>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("add_invent.invent_name"+satir_say).value;
		newCell.innerHTML = '<input type="text" name="row_other_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" readonly>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("add_invent.invent_name"+satir_say).value;
		newCell.innerHTML = '<select name="money_id' + row_count  +'" style="width:100%;" class="boxtext" onChange="hesapla('+ row_count +');"><cfoutput query="get_money"><option value="#money#,#rate1#,#rate2#" <cfif money eq session.ep.money>selected</cfif>>#money#</option></cfoutput></select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("add_invent.invent_name"+satir_say).value;
		newCell.innerHTML = '<input type="text" readonly="yes" name="amortization_rate' + row_count +'" value="'+ amort_rate +'" style="width:100%;" class="box" onkeyup="return(FormatCurrency(this,event));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("add_invent.invent_name"+satir_say).value;
		if(amortizaton_method == 0)
			newCell.innerHTML = '<input type="text" readonly name="amortization_method'+ row_count +'" style="width:165px;" class="box" value="<cf_get_lang_main no='1624.Azalan Bakiye Üzerinden'>">';
		else if(amortizaton_method == 1)
			newCell.innerHTML = '<input type="text" readonlyname="amortization_method'+ row_count +'" style="width:165px;" class="box" value="<cf_get_lang_main no='1625.Sabit Miktar Üzeriden'>">';
		else if(amortizaton_method == 2)
			newCell.innerHTML = '<input type="text" readonly name="amortization_method'+ row_count +'" style="width:165px;" class="box" value="<cf_get_lang_main no='1626.Hızlandırılmış Azalan Bakiye'>">';	
		else
			newCell.innerHTML = '<input type="text" readonly name="amortization_method'+ row_count +'" style="width:165px;" class="box" value="<cf_get_lang_main no='1627.Hızlandırılmış Sabit Değer'>">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("add_invent.invent_name"+satir_say).value;
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input  type="hidden" readonly name="account_id' + row_count +'"  value="'+ acc_id +'"><input type="text" readonly style="width:115px;"  name="account_code' + row_count +'"  value="'+ acc_id +'" class="boxtext" ><a href="javascript://" onclick="pencere_ac_acc('+ row_count +');" ><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("add_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<input type="hidden" name="unit_first_value' + row_count +'" value="'+ unit_first_value +'"><input type="hidden" name="total_first_value' + row_count +'" value="'+ total_first_value +'"><input type="hidden" name="unit_last_value' + row_count +'" value="'+ unit_last_value +'"><input type="text" name="last_inventory_value' + row_count +'" value="'+ last_inventory_value +'" style="width:100%;" class="box" onkeyup="return(FormatCurrency(this,event));" readonly="yes">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("add_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<input type="text" name="last_diff_value' + row_count +'" value="'+last_diff_value+'" style="width:100%;" class="box" onkeyup="return(FormatCurrency(this,event));" readonly="yes">';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.title=eval("add_invent.invent_name"+satir_say).value;	
		newCell.innerHTML ='<input type="hidden" name="expense_center_id' + row_count +'" value="'+expense_center_id+'" id="expense_center_id' + row_count +'"><input type="text" id="expense_center_name' + row_count +'" name="expense_center_name' + row_count +'" onFocus="exp_center('+row_count+');" value="'+expense_center_name+'" style="width:150px;" class="boxtext"><a href="javascript://" onClick="pencere_ac_exp_center('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.title=eval("add_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<input  type="hidden" name="budget_item_id' + row_count +'" id="budget_item_id' + row_count +'" value='+budget_item_id+'><input type="text" style="width:118px;" name="budget_item_name' + row_count +'" id="budget_item_name' + row_count +'" class="boxtext" value="'+budget_item_name+'" onFocus="exp_item('+row_count+');"><a href="javascript://"><img src="/images/plus_thin.gif" onclick="pencere_ac_exp('+ row_count +');" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.title=eval("add_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<input  type="hidden" name="budget_account_id' + row_count +'" id="budget_account_id' + row_count +'" value="'+debt_account_id+'"><input type="text" name="budget_account_code' + row_count +'" id="budget_account_code' + row_count +'" value="'+debt_account_id+'" class="boxtext" style="width:158px;" onFocus="autocomp_budget_account('+row_count+');"><a href="javascript://"onclick="pencere_ac_acc_1('+ row_count +');" ><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.title=eval("add_invent.invent_name"+satir_say).value;	
		newCell.innerHTML = '<input  type="hidden" name="amort_account_id' + row_count +'" id="amort_account_id' + row_count +'" value="'+claim_account_id+'"><input type="text" name="amort_account_code' + row_count +'" id="amort_account_code' + row_count +'" value="'+claim_account_id+'" class="boxtext" style="width:205px;" onFocus="autocomp_amort_account('+row_count+');"> <a href="javascript://"onclick="pencere_ac_acc_2('+ row_count +');" ><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.title=eval("add_invent.invent_name"+satir_say).value;
		newCell.innerHTML = '<input  type="hidden" name="product_id' + row_count +'" value="'+product_id+'"><input  type="hidden" value="'+stock_id+'" name="stock_id' + row_count +'" ><input type="text" name="product_name' + row_count +'" class="boxtext" style="width:110px;" value="'+product_name+'">'
							+' '+'<a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&product_id=add_invent.product_id" + row_count + "&field_id=add_invent.stock_id" + row_count + "&field_unit_name=add_invent.stock_unit" + row_count + "&field_main_unit=add_invent.stock_unit_id" + row_count + "&field_name=add_invent.product_name" + row_count + "','list');"+'"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=eval("add_invent.invent_name"+satir_say).value;
		newCell.innerHTML = '<input type="hidden" name="stock_unit_id' + row_count +'" value="'+stock_unit_id+'"><input type="text" name="stock_unit' + row_count +'" value="'+stock_unit+'" style="width:100%;" class="boxtext">';
		hesapla(row_count);
	}
	/* masraf merkezi popup */
	function pencere_ac_exp_center(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=add_invent.expense_center_id' + no +'&field_name=add_invent.expense_center_name' + no,'list');
	}
	/* masraf merkezi autocomplete */
	function exp_center(no)
	{
		AutoComplete_Create("expense_center_name" + no,"EXPENSE,EXPENSE_CODE","EXPENSE,EXPENSE_CODE","get_expense_center","","EXPENSE_ID","expense_center_id"+no,"",3);
	}
	/* gider kalemi autocomplete */
	function exp_item(no)
	{
		AutoComplete_Create("budget_item_name" + no,"EXPENSE_ITEM_NAME","EXPENSE_ITEM_NAME","get_expense_item","","EXPENSE_ITEM_ID,ACCOUNT_CODE,ACCOUNT_CODE","budget_item_id"+no+",budget_account_code"+no+",budget_account_id"+no,"",3);
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
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_invent.account_id' + no +'&field_name=add_invent.account_code' + no +'','list');
	}
	function pencere_ac_acc_1(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_invent.budget_account_id' + no +'&field_name=add_invent.budget_account_code' + no +'','list');
	}
	function pencere_ac_acc_2(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_invent.amort_account_id' + no +'&field_name=add_invent.amort_account_code' + no +'','list');
	}
	function pencere_ac_exp(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=add_invent.budget_item_id' + no +'&field_name=add_invent.budget_item_name' + no +'&field_account_no=add_invent.budget_account_code' + no +'&field_account_no2=add_invent.budget_account_id' + no +'','list');
	}
	function ayarla_gizle_goster()
	{
		if(add_invent.cash.checked)
			kasa_sec.style.display='';
		else
			kasa_sec.style.display='none';
	}
	function f_add_invent()
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_inventory&field_id=add_invent.invent_id','wide');
	}
</script>
</cfif>
<cfif isdefined('attributes.fis_id') and len(attributes.fis_id)>
	<cfset attributes.process_cat = GET_FIS_DET.process_cat >
	<cfset attributes.ref_no = get_fis_det.ref_no>
	<cfset attributes.employee_id = get_fis_det.employee_id >
	<cfset attributes.project_id =get_fis_det.project_id >
	<cfif len(attributes.project_id)>
		<cfset attributes.project_head = get_project.project_head >
	</cfif>
	<cfset attributes.subscription_id =get_fis_det.subscription_id >
	<cfif len(attributes.subscription_id)>
		<cfset attributes.SUBSCRIPTION_NO = GET_SUBS_INFO.SUBSCRIPTION_NO >
	</cfif>
	
	<cfset attributes.FIS_DETAIL = get_fis_det.FIS_DETAIL >
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'invent.add_invent_stock_fis_return';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'inventory/form/add_invent_stock_fis_return.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'inventory/query/add_invent_stock_fis_return.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'invent.add_invent_stock_fis_return&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('invent_stock_fis_return','invent_stock_fis_return_bask')";
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'invent.add_invent_stock_fis_return';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'inventory/form/add_invent_stock_fis_return.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'inventory/query/upd_invent_stock_fis_return.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'invent.add_invent_stock_fis_return&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'fis_id=##attributes.fis_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.fis_id##';
	WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('invent_stock_fis_return','invent_stock_fis_return_bask')";
	
	if(isdefined("attributes.event") and (attributes.event is 'upd' or attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'invent.emptypopup_del_invent_stock_fis&fis_id=#attributes.fis_id#&head=#get_fis_det.fis_number#&old_process_type=#get_fis_det.fis_type#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'inventory/query/del_invent_stock_fis.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'inventory/query/del_invent_stock_fis.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'invent.add_invent_stock_fis_return';
	}
	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1040]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.fis_id#&process_cat='+add_invent.old_process_type.value,'page','add_process')";
		if(session.ep.our_company_info.guaranty_followup)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[305]#-#lang_array_main.item[306]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=stock.list_serial_operations&is_filtre=1&belge_no=#get_fis_det.fis_number#&process_cat_id=#get_fis_det.fis_type#&process_id=#attributes.fis_id#','page','add_process')";
		}
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = 'Ekle';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=invent.add_invent_stock_fis_return";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'inventStockFisReturn';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'STOCK_FIS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-1','item-2','item-4','item-5','item-7']"; 
</cfscript>
