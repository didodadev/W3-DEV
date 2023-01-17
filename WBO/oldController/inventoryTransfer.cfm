<cf_get_lang_set module_name="invent">
<cfif not IsDefined("attributes.event") or attributes.event eq 'add'>
	<cfquery name="GET_MONEY" datasource="#dsn#">
        SELECT 
            MONEY_ID, 
            MONEY, 
            RATE1, 
            RATE2, 
            MONEY_STATUS, 
            PERIOD_ID, 
            COMPANY_ID, 
            RECORD_DATE, 
            RECORD_EMP, 
            RECORD_IP, 
            UPDATE_DATE, 
            UPDATE_EMP, 
            UPDATE_IP 
        FROM 
            SETUP_MONEY 
        WHERE 
            PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1
    </cfquery>
    <cfquery name="KASA" datasource="#dsn2#">
        SELECT 
            CASH_NAME, 
            CASH_ACC_CODE, 
            RECORD_EMP, 
            RECORD_IP, 
            RECORD_DATE, 
            UPDATE_EMP, 
            UPDATE_IP, 
            UPDATE_DATE 
        FROM 
            CASH 
        WHERE 
            CASH_ACC_CODE IS NOT NULL ORDER BY CASH_NAME
    </cfquery>
    <cfquery name="GET_TAX" datasource="#dsn2#">
        SELECT 
            TAX, 
            DETAIL, 
            RECORD_DATE, 
            RECORD_EMP, 
            RECORD_IP, 
            UPDATE_DATE, 
            UPDATE_EMP, 
            UPDATE_IP
        FROM 
            SETUP_TAX 
        ORDER BY 
            TAX
    </cfquery>
    <cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
        SELECT EXPENSE_ID,EXPENSE,EXPENSE_CODE FROM EXPENSE_CENTER ORDER BY EXPENSE
    </cfquery>
	<cfquery name="get_standart_process_money" datasource="#dsn#"><!--- muhasebe doneminden standart islem dövizini alıyor --->
        SELECT 
            PERIOD_ID, 
            PERIOD, 
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
	record_exist=0;//Row_kontrol değeri 1 olan yani silinmemiş satırların varlığını kontrol ediyor
	function kontrol()
	{
		debugger;
		if (!chk_process_cat('inventoryTransfer')) return false;	
		if(!check_display_files('inventoryTransfer')) return false;
		for(r=1; r<=document.getElementById("record_num").value; r++)
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
				if (document.getElementById("entry_date"+r).value == "")
				{ 
					alert ("<cf_get_lang no='47.Lütfen Giriş Tarihi Giriniz'> !");
					return false;
				}
				if ((document.getElementById("period_invent_value"+r).value == "")||(document.getElementById("period_invent_value"+r).value ==0))
				{ 
					alert ("<cf_get_lang no='46.Lütfen Dönembaşı Değeri Giriniz'> !");
					return false;
				}
				if ((document.getElementById("amortization_rate"+r).value == "")||(document.getElementById("amortization_rate"+r).value <0))
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
		if (filterNum(deger_amortization_rate.value) >100)
		{ 
			alert ("<cf_get_lang no='67.Amortisman Oranı 100den Büyük Olamaz'> !");
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
		for(r=1; r<=document.getElementById("record_num").value ;r++)
		{
			document.getElementById("row_total"+r).value = filterNum(document.getElementById("row_total"+r).value);
			document.getElementById("period_invent_value"+r).value = filterNum(document.getElementById("period_invent_value"+r).value);

			document.getElementById("period_amort_value"+r).value = filterNum(document.getElementById("period_amort_value"+r).value);
			document.getElementById("partial_amort_value"+r).value = filterNum(document.getElementById("partial_amort_value"+r).value);
			document.getElementById("row_other_total"+r).value = filterNum(document.getElementById("row_other_total"+r).value);
			document.getElementById("amortization_rate"+r).value = filterNum(document.getElementById("amortization_rate"+r).value);
			document.getElementById("quantity"+r).value = filterNum(document.getElementById("quantity"+r).value);
			document.getElementById("inventory_duration"+r).value = filterNum(document.getElementById("inventory_duration"+r).value);
		}
		document.getElementById("total_amount").value = filterNum(document.getElementById("total_amount").value);
		document.getElementById("other_net_total_amount").value = filterNum(document.getElementById("other_net_total_amount").value);
		for(s=1; s<=document.getElementById("deger_get_money").value; s++)
		{
			document.getElementById("value_rate2"+ s).value = filterNum(document.getElementById("value_rate2" + s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
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
			deger_last_value = document.getElementById("period_invent_value"+satir);//Dönem sonu değeri
			deger_amortization = document.getElementById("period_amort_value"+satir);//Dönem sonu amostismanı
			deger_other_net_total = document.getElementById("row_other_total"+satir);//dovizli tutar kdv dahil
			if(deger_total.value == "") deger_total.value = 0;
			if(deger_amortization.value == "") deger_amortization.value = 0;
			if(deger_other_net_total.value == "") deger_other_net_total.value = 0;
			deger_money_id = document.getElementById("money_id"+satir);
			deger_money_id_ilk = list_getat(deger_money_id.value,2,',');
			deger_money_id_son = list_getat(deger_money_id.value,3,',');
			deger_total.value = filterNum(deger_total.value);
			deger_last_value.value = filterNum(deger_last_value.value);
			deger_amortization.value = filterNum(deger_amortization.value);
			deger_other_net_total.value = filterNum(deger_other_net_total.value);
			deger_total.value = parseFloat(deger_last_value.value) - parseFloat(deger_amortization.value);
			toplam_dongu_0 = parseFloat(deger_total.value);
			deger_other_net_total.value = ((parseFloat(deger_total.value)) * parseFloat(deger_money_id_ilk) / (parseFloat(deger_money_id_son)));
			deger_total.value = commaSplit(deger_total.value);
			deger_last_value.value = commaSplit(deger_last_value.value);
			deger_amortization.value = commaSplit(deger_amortization.value);
			deger_other_net_total.value = commaSplit(deger_other_net_total.value);
		}
			toplam_hesapla();
	}
	function toplam_hesapla()
	{
		var toplam_dongu_1 = 0;//tutar genel toplam
		var toplam_dongu_3 = 0;// kdvli genel toplam
		for(r=1; r<=document.getElementById("record_num").value; r++)
		{
			if(document.getElementById("row_kontrol"+r).value==1)
			{
				deger_total = document.getElementById("row_total"+r);//tutar
				deger_miktar = document.getElementById("quantity"+r);//miktar
				deger_money_id = document.getElementById("money_id"+r);
				deger_money_id_ilk = list_getat(deger_money_id.value,1,',');
				for(s=1; s<=document.getElementById("deger_get_money").value; s++)
					{
						if(list_getat(document.all.rd_money[s-1].value,1,',') == deger_money_id_ilk)
						{
							satir_rate2= document.getElementById("value_rate2"+s).value;
						}
					}
				satir_rate2= filterNum(satir_rate2,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				deger_money_id = document.getElementById("money_id"+r);
				deger_money_id_son = list_getat(deger_money_id.value,3,',');
				deger_total.value = filterNum(deger_total.value);
				toplam_dongu_1 = toplam_dongu_1 + parseFloat(deger_total.value * deger_miktar.value);
				toplam_dongu_3 = toplam_dongu_3 + (parseFloat(deger_total.value * deger_miktar.value));
				deger_total.value = commaSplit(deger_total.value);
			}
		}
			
		document.getElementById("total_amount").value = commaSplit(toplam_dongu_1);
		for(s=1; s<=document.getElementById("deger_get_money").value; s++)
		{
			form_value_rate2 = document.getElementById("value_rate2"+s);
			if(form_value_rate2.value == "")
				form_value_rate2.value = 1;
		}
		if(document.getElementById("deger_get_money").value == 1)
			for(s=1; s<=document.getElementById("deger_get_money").value; s++)
			{
				if(document.getElementById("rd_money").checked == true)
				{
					deger_diger_para = document.getElementById("rd_money");
					form_value_rate2 = document.getElementById("value_rate2"+s);
				}
			}
		else 
			for(s=1; s<=document.getElementById("deger_get_money").value; s++)
			{
				if(document.all.rd_money[s-1].checked == true)
				{
					deger_diger_para = document.all.rd_money[s-1];
					form_value_rate2 = document.getElementById("value_rate2"+s);
				}
			}
		deger_money_id_1 = list_getat(deger_diger_para.value,1,',');
		deger_money_id_3 = list_getat(deger_diger_para.value,3,',');
		form_value_rate2.value = filterNum(form_value_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("other_net_total_amount").value = commaSplit(toplam_dongu_3 * parseFloat(deger_money_id_3) / (parseFloat(form_value_rate2.value)));
	
		document.getElementById("tl_value3").value = deger_money_id_1;
		form_value_rate2.value = commaSplit(form_value_rate2.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	}
	function add_row(inventory_cat_id,inventory_cat,invent_no,invent_name,entry_date,quantity,period_invent_value,period_amort_value,partial_amort_value,row_total,row_other_total,money_id_,inventory_duration,amortization_rate,amortization_method,amortization_type,account_id,account_code,expense_center_id,expense_item_id,expense_item_name,period,debt_account_id,debt_account_code,claim_account_id,claim_account_code)
	{
		if (inventory_cat_id == undefined) inventory_cat_id ="";
		if (inventory_cat == undefined) inventory_cat ="";
		if (invent_no == undefined) invent_no ="";
		if (invent_name == undefined) invent_name ="";
		if (entry_date == undefined) entry_date ="";
		if (quantity == undefined) quantity = 1;
		if (partial_amort_value == undefined) partial_amort_value = 0;
		if (period_invent_value == undefined) period_invent_value = 0;
		if (period_amort_value == undefined) period_amort_value = 0;
		if (row_total == undefined) row_total = 0;
		if (row_other_total == undefined) row_other_total = 0;
		if (money_id_ == undefined) money_id_ ="";
		if (inventory_duration == undefined) inventory_duration ="";
		if (amortization_rate == undefined) amortization_rate ="";
		if (amortization_method == undefined) amortization_method ="";
		if (amortization_type == undefined) amortization_type ="";
		if (account_id == undefined) account_id ="";
		if (account_code == undefined) account_code ="";
		if (expense_center_id == undefined) expense_center_id ="";
		if (expense_item_id == undefined) expense_item_id ="";
		if (expense_item_name == undefined) expense_item_name = "";
		if (period == undefined) period = 12;
		if (debt_account_id == undefined) debt_account_id ="";
		if (debt_account_code == undefined) debt_account_code ="";
		if (claim_account_id == undefined) claim_account_id ="";
		if (claim_account_code == undefined) claim_account_code ="";

		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);		
		document.getElementById("record_num").value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" id="row_kontrol' + row_count +'" value="1" name="row_kontrol' + row_count +'" ><a href="javascript://" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0"></a><a style="cursor:pointer" onclick="copy_row('+row_count+');" title="<cf_get_lang_main no="1560.Satır Kopyala">"><img  src="images/copy_list.gif" border="0"></a> ';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" id="inventory_cat_id' + row_count +'" name="inventory_cat_id' + row_count +'" value="'+inventory_cat_id+'"><input type="text" style="width:138px;" id="inventory_cat' + row_count +'" name="inventory_cat' + row_count +'" value="'+inventory_cat+'" class="boxtext"><a href="javascript://" onClick="open_inventory_cat_list('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="invent_no' + row_count +'" name="invent_no' + row_count +'" value="'+invent_no+'" style="width:100%;" class="boxtext">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="invent_name' + row_count +'" name="invent_name' + row_count +'" value="'+invent_name+'" style="width:230px;" class="boxtext" maxlength="100">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("id","entry_date" + row_count + "_td");
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" id="entry_date' + row_count +'" name="entry_date' + row_count +'" class="text" maxlength="10" style="width:65px;" value="'+entry_date+'">';
		wrk_date_image('entry_date' + row_count);
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="quantity' + row_count +'" name="quantity' + row_count +'" style="width:100%;" class="box" value="'+quantity+'" onBlur="hesapla(' + row_count +');" onkeyup="return(FormatCurrency(this,event));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="period_invent_value' + row_count +'" name="period_invent_value' + row_count +'" value="'+period_invent_value+'" onkeyup="return(FormatCurrency(this,event));" onBlur="hesapla(' + row_count +');" style="width:100%;" class="box">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="period_amort_value' + row_count +'" name="period_amort_value' + row_count +'" value="'+period_amort_value+'" onkeyup="return(FormatCurrency(this,event));" onBlur="hesapla(' + row_count +');" style="width:100%;" class="box">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="partial_amort_value' + row_count +'" name="partial_amort_value' + row_count +'" value="'+partial_amort_value+'" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="row_total' + row_count +'" name="row_total' + row_count +'" value="'+row_total+'" onkeyup="return(FormatCurrency(this,event));" onBlur="hesapla(' + row_count +');" style="width:100%;" class="box" readonly>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="row_other_total' + row_count +'" name="row_other_total' + row_count +'" value="'+row_other_total+'" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" readonly>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		a = '<select id="money_id' + row_count +'" name="money_id' + row_count  +'" style="width:100%;" class="boxtext" onChange="hesapla('+ row_count +');">';
		<cfoutput query="get_money">
			if('#money#,#rate1#,#rate2#' == money_id_)
				a += '<option value="#money#,#rate1#,#rate2#" selected>#money#</option>';
			else
				a += '<option value="#money#,#rate1#,#rate2#">#money#</option>';
		</cfoutput>
		newCell.innerHTML =a+ '</select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="inventory_duration' + row_count +'" name="inventory_duration' + row_count +'" style="width:100%;" value="'+inventory_duration+'" class="box" onkeyup="return(FormatCurrency(this,event));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="amortization_rate' + row_count +'" name="amortization_rate' + row_count +'" style="width:100%;" value="'+amortization_rate+'" class="box" onblur="return(amortisman_kontrol(' + row_count +'));" onkeyup="return(FormatCurrency(this,event));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select id="amortization_method'+ row_count +'" name="amortization_method'+ row_count +'" style="width:165px;" class="box"><option value="0"><cf_get_lang_main no="1624.Azalan Bakiye Üzerinden"></option><option value="1"><cf_get_lang_main no="1625.Sabit Miktar Üzeriden"></option><option value="2"><cf_get_lang_main no="1626.Hızlandırılmış Azalan Bakiye"></option><option value="3"><cf_get_lang_main no="1627.Hızlandırılmış Sabit Değer"></option></select>';
		if(amortization_method != '')
			document.getElementById('amortization_method'+ row_count).value = amortization_method;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select id="amortization_type'+ row_count +'" name="amortization_type'+ row_count +'" style="width:185px;" class="box"><option value="1">Kıst Amortismana Tabi</option><option value="2" selected>Kıst Amortismana Tabi Değil</option>></select>';
		if(amortization_type != '')
			document.getElementById('amortization_type'+ row_count).value = amortization_type;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input  type="hidden" id="account_id' + row_count +'" name="account_id' + row_count +'" value="'+account_id+'"><input type="text" style="width:100px;" id="account_code' + row_count +'" name="account_code' + row_count +'" value="'+account_code+'" class="boxtext"><a href="javascript://" onClick="pencere_ac_acc('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		b = '<select id="expense_center_id' + row_count +'" name="expense_center_id' + row_count  +'" style="width:155px;" class="boxtext"><option value=""><cf_get_lang_main no="823.Masraf/Gelir Merkezi"></option>';
		<cfoutput query="GET_EXPENSE_CENTER">
			if('#EXPENSE_ID#' == expense_center_id)
				b += '<option value="#EXPENSE_ID#" selected>#EXPENSE#</option>';
			else
				b += '<option value="#EXPENSE_ID#">#EXPENSE#</option>';
		</cfoutput>
		newCell.innerHTML =b+ '</select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input  type="hidden" id="expense_item_id' + row_count +'" name="expense_item_id' + row_count +'" value="'+expense_item_id+'"><input type="text" readonly="yes" style="width:120px;" id="expense_item_name' + row_count +'" name="expense_item_name' + row_count +'" value="'+expense_item_name+'" class="boxtext"><a href="javascript://"><img src="/images/plus_thin.gif" onclick="pencere_ac_exp('+ row_count +');" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="period' + row_count +'" name="period' + row_count +'" style="width:100%;" class="box" value="'+period+'" onblur="return(period_kontrol(' + row_count +'));" onkeyup="return(FormatCurrency(this,event,0));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input  type="hidden" id="debt_account_id' + row_count +'" name="debt_account_id' + row_count +'" value="'+debt_account_id+'"><input type="text" id="debt_account_code' + row_count +'"  name="debt_account_code' + row_count +'" value="'+debt_account_code+'" class="boxtext" style="width:190px;"><a href="javascript://" onClick="pencere_ac_acc2('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input  type="hidden" id="claim_account_id' + row_count +'" name="claim_account_id' + row_count +'" value="'+claim_account_id+'"><input type="text" id="claim_account_code' + row_count +'" name="claim_account_code' + row_count +'" value="'+claim_account_code+'" class="boxtext" style="width:200px;"><a href="javascript://" onClick="pencere_ac_acc1('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
	}
	
	function copy_row(no_info)
	{
		if (document.getElementById("inventory_cat_id" + no_info) == undefined) inventory_cat_id =""; else inventory_cat_id = document.getElementById("inventory_cat_id" + no_info).value;
		if (document.getElementById("inventory_cat" + no_info) == undefined) inventory_cat =""; else inventory_cat = document.getElementById("inventory_cat" + no_info).value;
		if (document.getElementById("invent_no" + no_info) == undefined) invent_no =""; else invent_no = document.getElementById("invent_no" + no_info).value;
		if (document.getElementById("invent_name" + no_info) == undefined) invent_name =""; else invent_name = document.getElementById("invent_name" + no_info).value;
		if (document.getElementById("entry_date" + no_info) == undefined) entry_date =""; else entry_date = document.getElementById("entry_date" + no_info).value;
		if (document.getElementById("quantity" + no_info) == undefined) quantity =""; else quantity = document.getElementById("quantity" + no_info).value;
		if (document.getElementById("period_invent_value" + no_info) == undefined) period_invent_value =""; else period_invent_value = document.getElementById("period_invent_value" + no_info).value;
		if (document.getElementById("period_amort_value" + no_info) == undefined) period_amort_value =""; else period_amort_value = document.getElementById("period_amort_value" + no_info).value;
		if (document.getElementById("partial_amort_value" + no_info) == undefined) partial_amort_value =""; else partial_amort_value = document.getElementById("partial_amort_value" + no_info).value;
		if (document.getElementById("row_total" + no_info) == undefined) row_total =""; else row_total = document.getElementById("row_total" + no_info).value;
		if (document.getElementById("row_other_total" + no_info) == undefined) row_other_total =""; else row_other_total = document.getElementById("row_other_total" + no_info).value;
		if (document.getElementById("money_id" + no_info) == undefined) money_id =""; else money_id = document.getElementById("money_id" + no_info).value;
		if (document.getElementById("inventory_duration" + no_info) == undefined) inventory_duration =""; else inventory_duration = document.getElementById("inventory_duration" + no_info).value;
		if (document.getElementById("amortization_rate" + no_info) == undefined) amortization_rate =""; else amortization_rate = document.getElementById("amortization_rate" + no_info).value;
		if (document.getElementById("amortization_method" + no_info) == undefined) amortization_method =""; else amortization_method = document.getElementById("amortization_method" + no_info).value;
		if (document.getElementById("amortization_type" + no_info) == undefined) amortization_type =""; else amortization_type = document.getElementById("amortization_type" + no_info).value;
		if (document.getElementById("account_id" + no_info) == undefined) account_id =""; else account_id = document.getElementById("account_id" + no_info).value;
		if (document.getElementById("account_code" + no_info) == undefined) account_code =""; else account_code = document.getElementById("account_code" + no_info).value;
		if (document.getElementById("expense_center_id" + no_info) == undefined) expense_center_id =""; else expense_center_id = document.getElementById("expense_center_id" + no_info).value;
		if (document.getElementById("expense_item_id" + no_info) == undefined) expense_item_id =""; else expense_item_id = document.getElementById("expense_item_id" + no_info).value;
		if (document.getElementById("expense_item_name" + no_info) == undefined) expense_item_name =""; else expense_item_name = document.getElementById("expense_item_name" + no_info).value;
		if (document.getElementById("period" + no_info) == undefined) period =""; else period = document.getElementById("period" + no_info).value;
		if (document.getElementById("debt_account_id" + no_info) == undefined) debt_account_id =""; else debt_account_id = document.getElementById("debt_account_id" + no_info).value;
		if (document.getElementById("debt_account_code" + no_info) == undefined) debt_account_code =""; else debt_account_code = document.getElementById("debt_account_code" + no_info).value;
		if (document.getElementById("claim_account_id" + no_info) == undefined) claim_account_id =""; else claim_account_id = document.getElementById("claim_account_id" + no_info).value;
		if (document.getElementById("claim_account_code" + no_info) == undefined) claim_account_code =""; else claim_account_code = document.getElementById("claim_account_code" + no_info).value;
		
		add_row(inventory_cat_id,inventory_cat,invent_no,invent_name,entry_date,quantity, period_invent_value,period_amort_value,partial_amort_value,row_total,row_other_total,money_id,inventory_duration,amortization_rate,amortization_method,amortization_type,account_id,account_code,expense_center_id,expense_item_id,expense_item_name,period,debt_account_id,debt_account_code,claim_account_id,claim_account_code);
		toplam_hesapla();
	}
	
	function pencere_ac_acc(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=account_id' + no +'&field_name=account_code' + no +'','list');
	}
	function pencere_ac_acc1(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=claim_account_id' + no +'&field_name=claim_account_code' + no +'','list');
	}
	function pencere_ac_acc2(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=debt_account_id' + no +'&field_name=debt_account_code' + no +'','list');
	}
	function pencere_ac_exp(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=expense_item_id' + no +'&field_name=expense_item_name' + no +'&field_account_no=debt_account_code' + no +'&field_account_no2=debt_account_id' + no +'','list');
	}
	function open_inventory_cat_list(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_inventory_cat&field_id=inventory_cat_id' + no +'&field_name=inventory_cat' + no +'&field_amortization_rate=amortization_rate' + no +'&field_inventory_duration=inventory_duration' + no +'','list');
	}
	function ayarla_gizle_goster()
	{
		if(document.getElementById("cash").checked)
			kasa_sec.style.display='';
		else
			kasa_sec.style.display='none';
	}
</script>
</cfif>

<cfif  IsDefined("attributes.event") and attributes.event eq 'det'>
<!---<cf_xml_page_edit fuseaction="invent.detail_invent"> --->
	<cfquery name="GET_AMORTIZATION" datasource="#DSN3#">
        SELECT
            INVENTORY_AMORTIZATON.*,
            INVENTORY_AMORTIZATION_MAIN.*,
            INVENTORY.AMOUNT,
            INVENTORY.LAST_INVENTORY_VALUE,
            EMPLOYEES.EMPLOYEE_NAME,
            EMPLOYEES.EMPLOYEE_SURNAME,
            EMPLOYEES.EMPLOYEE_ID
        FROM
            INVENTORY_AMORTIZATON
            LEFT JOIN INVENTORY_AMORTIZATION_MAIN ON INVENTORY_AMORTIZATION_MAIN.INV_AMORT_MAIN_ID=INVENTORY_AMORTIZATON.INV_AMORT_MAIN_ID
            LEFT JOIN INVENTORY ON INVENTORY_AMORTIZATON.INVENTORY_ID = INVENTORY.INVENTORY_ID
            LEFT JOIN #dsn_alias#.EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = INVENTORY_AMORTIZATION_MAIN.RECORD_EMP
        WHERE
            INVENTORY_AMORTIZATON.INVENTORY_ID = #attributes.inventory_id# 
        ORDER BY 
            INVENTORY_AMORTIZATION_MAIN.ACTION_DATE
    </cfquery>
    <cfquery name="get_inventory_history" datasource="#dsn3#">
        SELECT
            INVENTORY_HISTORY_ID,
            INVENTORY_ID,
            ACTION_TYPE,
            ACTION_ID,
            ACTION_DATE,
            EXPENSE_CENTER_ID,
            EXPENSE_ITEM_ID,
            CLAIM_ACCOUNT_CODE,
            DEBT_ACCOUNT_CODE,
            ACCOUNT_CODE,
            INVENTORY_DURATION,
            AMORTIZATION_RATE,
            PROJECT_ID,
            RECORD_EMP,
            RECORD_DATE
        FROM
            INVENTORY_HISTORY
        WHERE
            INVENTORY_ID = #attributes.inventory_id#
        ORDER BY 
            ACTION_DATE DESC,
            INVENTORY_HISTORY_ID DESC
    </cfquery>
    <cfquery name="get_invoice" datasource="#dsn2#">
        SELECT * FROM INVOICE_ROW WHERE INVENTORY_ID = #attributes.inventory_id#
    </cfquery>
    <cfquery name="get_periods" datasource="#dsn#">
        SELECT * FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #session.ep.company_id# ORDER BY PERIOD_YEAR DESC
    </cfquery>
    <cfset count_ = 0>
    <cfquery name="get_inventory" datasource="#dsn2#">
        <cfloop query="get_periods">
            <cfset count_ = count_ + 1>
            SELECT
                '#get_periods.PERIOD_ID#' AS RELATED_PERIOD_ID,
                '#get_periods.PERIOD_YEAR#' AS RELATED_PERIOD_YEAR,
                IR.ACTION_DATE,
                I.INVENTORY_ID,
                I.ENTRY_DATE,
                IR.PAPER_NO,
                I.INVENTORY_NUMBER,
                SFR.AMOUNT QUANTITY,
                I.INVENTORY_NAME,
                PTR.PROCESS_CAT,
                SFR.PRICE AMOUNT,
                SF.FIS_TYPE,
                SF.FIS_ID,
                SF.FIS_NUMBER,
                SF.RELATED_INVOICE_ID,
                SF.RELATED_SHIP_ID,
                (SELECT INVOICE.INVOICE_NUMBER FROM #dsn#_#get_periods.period_year#_#session.ep.company_id#.INVOICE WHERE INVOICE.INVOICE_ID = SF.RELATED_INVOICE_ID) AS RELATED_INVOICE_NUMBER,
                (SELECT SHIP.SHIP_NUMBER FROM #dsn#_#get_periods.period_year#_#session.ep.company_id#.SHIP WHERE SHIP.SHIP_ID = SF.RELATED_SHIP_ID) AS RELATED_SHIP_NUMBER,
                (SELECT PTR2.PROCESS_CAT FROM #dsn#_#get_periods.period_year#_#session.ep.company_id#.SHIP,#dsn3_alias#.SETUP_PROCESS_CAT PTR2 WHERE SHIP.SHIP_ID = SF.RELATED_SHIP_ID AND SHIP.PROCESS_CAT = PTR2.PROCESS_CAT_ID) AS RELATED_PROCESS_CAT
            FROM
                #dsn3_alias#.INVENTORY I,
                #dsn3_alias#.INVENTORY_ROW IR,
                #dsn3_alias#.STOCKS S,
                #dsn3_alias#.SETUP_PROCESS_CAT PTR,
                #dsn#_#get_periods.period_year#_#session.ep.company_id#.STOCK_FIS SF,
                #dsn#_#get_periods.period_year#_#session.ep.company_id#.STOCK_FIS_ROW SFR
            WHERE
                PTR.PROCESS_CAT_ID = SF.PROCESS_CAT AND
                I.INVENTORY_ID = IR.INVENTORY_ID AND
                IR.ACTION_ID =  SF.FIS_ID AND
                SFR.FIS_ID =  SF.FIS_ID AND
                SFR.STOCK_ID = S.STOCK_ID AND
                SFR.INVENTORY_ID = I.INVENTORY_ID AND
                IR.PERIOD_ID = #get_periods.period_id# AND
                I.INVENTORY_ID = #attributes.inventory_id# AND
                SF.FIS_TYPE <> 1181
            UNION ALL
            SELECT
                '#get_periods.PERIOD_ID#' AS RELATED_PERIOD_ID,
                '#get_periods.PERIOD_YEAR#' AS RELATED_PERIOD_YEAR,
                IR.ACTION_DATE,
                I.INVENTORY_ID,
                I.ENTRY_DATE,
                IR.PAPER_NO,
                I.INVENTORY_NUMBER,
                SFR.AMOUNT QUANTITY,
                I.INVENTORY_NAME,
                PTR.PROCESS_CAT,
                SFR.PRICE AMOUNT,
                SF.INVOICE_CAT FIS_TYPE,
                SF.INVOICE_ID FIS_ID,
                SF.INVOICE_NUMBER FIS_NUMBER,
                '' RELATED_INVOICE_ID,
                '' RELATED_SHIP_ID,
                '' AS RELATED_SHIP_NUMBER,
                '' AS RELATED_INVOICE_NUMBER,
                '' AS RELATED_PROCESS_CAT
            FROM
                #dsn3_alias#.INVENTORY I,
                #dsn3_alias#.INVENTORY_ROW IR,
                #dsn3_alias#.SETUP_PROCESS_CAT PTR,
                #dsn#_#get_periods.period_year#_#session.ep.company_id#.INVOICE SF,
                #dsn#_#get_periods.period_year#_#session.ep.company_id#.INVOICE_ROW SFR
            WHERE
                PTR.PROCESS_CAT_ID = SF.PROCESS_CAT AND
                I.INVENTORY_ID = IR.INVENTORY_ID AND
                IR.ACTION_ID =  SF.INVOICE_ID AND
                SFR.INVOICE_ID =  SF.INVOICE_ID AND
                SFR.INVENTORY_ID = I.INVENTORY_ID AND
                IR.PERIOD_ID = #get_periods.period_id# AND
                I.INVENTORY_ID = #attributes.inventory_id# 
            <cfif get_periods.recordcount neq count_>UNION ALL</cfif>
        </cfloop>
    </cfquery>
    <cfquery name="get_asset_type" datasource="#dsn#">
        SELECT 
            ASSET_P_CAT.IT_ASSET,
            ASSET_P_CAT.MOTORIZED_VEHICLE,		
            ASSET_P.INVENTORY_NUMBER
        FROM 
            ASSET_P,
            ASSET_P_CAT
        WHERE
            ASSET_P.INVENTORY_NUMBER ='#get_inventory.inventory_number#' AND	
            ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID
        ORDER BY 
            ASSET_P.ASSETP_ID 
    </cfquery>
    <cfquery name="GET_INVENT" datasource="#DSN3#">
        SELECT * FROM INVENTORY WHERE INVENTORY_ID = #attributes.inventory_id#
    </cfquery>
    
    <cfif  GET_INVENT.recordcount>
    <cfif len(get_invent.subscription_id)>
    	<cfquery name="GET_SYSTEM_NO" datasource="#DSN3#">
            SELECT SUBSCRIPTION_NO FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID= #get_invent.subscription_id#
        </cfquery></cfif>
        <cfquery name="GET_SETUP_INVENTORY_CATS" datasource="#DSN3#">
            SELECT * FROM SETUP_INVENTORY_CAT
        </cfquery>
        <cfquery name="get_invent_actions" datasource="#dsn3#">
            SELECT 
                SUM(TO_AMOUNT) AS TOTAL
            FROM 
                RELATION_ROW 
            WHERE 
                TO_TABLE = 'INVENTORY_ROW' AND 
                FROM_TABLE = 'SHIP_ROW' AND
                TO_WRK_ROW_ID LIKE '#attributes.inventory_id#-%'
        </cfquery>
        <cfif len(get_inventory.FIS_ID)>
            <cfquery name="get_comp" datasource="#dsn2#">
                SELECT COMPANY_ID,PARTNER_ID,CONSUMER_ID FROM #dsn#_#get_inventory.related_period_year#_#session.ep.company_id#.INVOICE WHERE INVOICE_ID = #get_inventory.FIS_ID#
            </cfquery>
        </cfif>
    </cfif>
    <cfquery name="GET_ACCOUNT_NAME" datasource="#DSN2#">
        SELECT
            ACCOUNT_NAME,
            ACCOUNT_CODE
            FROM
            ACCOUNT_PLAN
        WHERE
            ACCOUNT_CODE = '#get_invent.account_id#'
    </cfquery>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'invent.add_collacted_inventory';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'inventory/form/add_collacted_inventory.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'inventory/query/add_collacted_inventory.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'invent.add_collacted_inventory&event=det';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('collacted_inventory','collacted_inventory_bask');";
	
	WOStruct['#attributes.fuseaction#']['det'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'invent.add_collacted_inventory';
	WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'inventory/display/detail_invent.cfm';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'inventory/display/detail_invent.cfm';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'invent.add_collacted_inventory&event=upd';
	WOStruct['#attributes.fuseaction#']['det']['parameters'] = 'inventory_id=##attributes.inventory_id##';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.inventory_id##';
	
	
	
	if( IsDefined("attributes.event") and (attributes.event is 'del' or attributes.event is 'det'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=invent.emptypopup_del_invent';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'inventory/query/del_invent.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'inventory/query/del_invent.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'invent.add_collacted_inventory&event=add';
	}
	
	if( IsDefined("attributes.event") && attributes.event is 'det')
	{
		 if (len(get_inventory.FIS_ID))
		 {
		 	get_comp.COMPANY_ID = get_comp.COMPANY_ID;
	        get_comp.CONSUMER_ID = get_comp.CONSUMER_ID;
	        get_comp.PARTNER_ID = get_comp.PARTNER_ID;
		 }
		 else
		 {
		 	get_comp.COMPANY_ID = "";
	        get_comp.CONSUMER_ID = "";
	        get_comp.PARTNER_ID = "";
		 }
		       
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['text'] = '#lang_array_main.item[345]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=invent.detail_invent&action_name=inventory_id&action_id=#attributes.inventory_id#','list')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][1]['text'] = '#lang_array.item[45]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][1]['onClick']  = "windowopen('#request.self#?fuseaction=invent.popup_add_inventory_stock_to_asset&inventory_id=#attributes.inventory_id#&invoice_date=#get_invent.entry_date#&company_id=#get_comp.company_id#&consumer_id=#get_comp.consumer_id#&partner_id=#get_comp.partner_id#','norm_horizontal','popup_add_inventory_stock_to_asset')";
		
		if (get_invent.to_asset eq 1)
			{ 
				if(get_module_user(40)  && fusebox.circuit is 'assetcare')
				{
					if (get_asset_type.motorized_vehicle is 0  &&  get_asset_type.it_asset is 0)
					{
						tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][2]['text'] = '#lang_array.item[41]#';
						tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][2]['href'] = "#request.self#?fuseaction=assetcare.list_assetp&keyword=#get_invent.inventory_number#&form_submitted=1";
					}
					else if(get_asset_type.motorized_vehicle is 0  &&  get_asset_type.it_asset is 0)
					{
						tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][2]['text'] = '#lang_array.item[43]#';
						tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][2]['href'] = "";
					}
					else if(get_asset_type.motorized_vehicle is 1  && (get_asset_type.it_asset is 0 || get_asset_type.it_asset is 1))
					{
						tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][2]['text'] = '#lang_array.item[43]#';
						tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][2]['href'] = "#request.self#?fuseaction=assetcare.list_vehicles&keyword=#get_invent.inventory_number#&form_submitted=1";
					}
				}
			}
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['print']['text'] = '#lang_array_main.item[62]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.inventory_id#&print_type=350','page')";
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'inventoryTransfer';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'INVENTORY';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-1']"; 
</cfscript>