<cf_get_lang_set module_name="credit">
<cfif not IsDefined("attributes.event") or (IsDefined("attributes.event") and attributes.event eq 'add')>
	<cfquery name="GET_MONEY" datasource="#dsn#">
        SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1
    </cfquery>
    <cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.comp_name" default="">
    <cfparam name="attributes.partner_name" default="">

</cfif>
<cfif IsDefined("attributes.event") and attributes.event eq 'upd'>
	<cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.comp_name" default="">
    <cfparam name="attributes.partner_name" default="">
    
    <cfquery name="GET_BOND_ACTION" datasource="#dsn3#">
        SELECT * FROM STOCKBONDS_SALEPURCHASE WHERE ACTION_ID=#attributes.action_id#
    </cfquery>
    <cfquery name="GET_ACTION_MONEY" datasource="#dsn3#">
        SELECT MONEY_TYPE AS MONEY, * FROM STOCKBONDS_SALEPURCHASE_MONEY WHERE ACTION_ID=#attributes.action_id#
    </cfquery>
    <cfif not GET_ACTION_MONEY.recordcount>
        <cfquery name="GET_ACTION_MONEY" datasource="#dsn2#">
            SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY
        </cfquery>
    </cfif>
    <cfquery name="GET_STOCKBOND_ROWS" datasource="#dsn3#">
        SELECT
            SR.STOCKBOND_ROW_ID,
            SR.NOMINAL_VALUE,
            SR.OTHER_NOMINAL_VALUE,
            SR.PRICE,
            SR.OTHER_PRICE,
            SR.NET_TOTAL,
            SR.OTHER_MONEY_VALUE,
            SR.QUANTITY,
            SR.DESCRIPTION,
            S.STOCKBOND_TYPE,
            S.STOCKBOND_CODE,
            S.ROW_EXP_CENTER_ID,
            S.ROW_EXP_ITEM_ID,
            SR.DUE_DATE,
            S.STOCKBOND_ID,
             EXPENSE_CENTER.EXPENSE_ID, 
            EXPENSE_CENTER.EXPENSE_CODE, 
            EXPENSE_CENTER.EXPENSE,
            EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
            EXPENSE_ITEMS.EXPENSE_ITEM_ID,
            SETUP_STOCKBOND_TYPE.*
        FROM
            STOCKBONDS S
            LEFT JOIN STOCKBONDS_SALEPURCHASE_ROW SR ON S.STOCKBOND_ID = SR.STOCKBOND_ID
            LEFT JOIN #dsn_alias#.EXPENSE_CENTER ON EXPENSE_CENTER.EXPENSE_ID = S.ROW_EXP_CENTER_ID
            LEFT JOIN #dsn_alias#.EXPENSE_ITEMS ON EXPENSE_ITEMS.EXPENSE_ITEM_ID = S.ROW_EXP_ITEM_ID
            LEFT JOIN #dsn_alias#.SETUP_STOCKBOND_TYPE ON SETUP_STOCKBOND_TYPE.STOCKBOND_TYPE_ID = S.STOCKBOND_TYPE
        WHERE
            SR.SALES_PURCHASE_ID = #attributes.action_id# 
            
    </cfquery>
    <cfif len(get_bond_action.partner_id)>
        <cfquery name="GET_PARTNER" datasource="#dsn#">
            SELECT 
                PARTNER_ID,
                COMPANY_PARTNER_NAME,
                COMPANY_PARTNER_SURNAME
            FROM 
                COMPANY_PARTNER
            WHERE 
                PARTNER_ID= #get_bond_action.partner_id#
        </cfquery>
    </cfif>
</cfif>

<cfquery name="GET_STOCKBOND_TYPES" datasource="#dsn#">
	SELECT * FROM SETUP_STOCKBOND_TYPE
</cfquery>
<cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
	SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE IS_EXPENSE = 1 ORDER BY EXPENSE_ITEM_NAME
</cfquery>
<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
	SELECT EXPENSE_ID, EXPENSE_CODE, EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ACTIVE = 1 ORDER BY EXPENSE
</cfquery>
<script type="text/javascript">
	<cfif IsDefined("attributes.event") and attributes.event eq 'upd'>
		row_count=<cfoutput>#get_stockbond_rows.recordcount#</cfoutput>;
		satir_say=<cfoutput>#get_stockbond_rows.recordcount#</cfoutput>;
	<cfelse>
		row_count=0;
		satir_say=0;
	</cfif>
	
	function sil(sy)
	{
		var my_element = document.getElementById("row_kontrol"+sy);
		my_element.value = 0;
		var my_element = document.getElementById("frm_row"+sy);
		my_element.style.display="none";
		toplam_hesapla();
		satir_say--;
	}
	function gonder(stockbond_id,bond_type,bond_code,detail,quantity,nominal_value,other_nominal_value,sale_value,other_sale_value,total_sale,other_total_sale,due_date,expense_center_name,expense_item_name)
	{
		row_count++;
		satir_say++;
		var newRow;
		var newCell;
		var temp_quantity=quantity.replace('.',',');
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);	
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);				
		newRow.className = 'color-row';
		document.getElementById("record_num").value = row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="hidden"  value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><a style="cursor:pointer" onclick="sil(' + row_count + ');"  ><img  src="images/delete_list.gif" alt="Sil" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="stockbond_id' + row_count +'" id="stockbond_id' + row_count +'" value="'+ stockbond_id +'"><input type="hidden" name="stockbond_row_id' + row_count +'" id="stockbond_row_id' + row_count +'" value="0"><input type="text" name="bond_type' + row_count  +'" id="bond_type' + row_count  +'" style="width:100%;" class="boxtext" value="'+bond_type+'">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="bond_code' + row_count  +'" id="bond_code' + row_count  +'"  value="'+ bond_code +'" style="width:100%;" class="boxtext" readonly="yes">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="row_detail' + row_count  +'" id="row_detail' + row_count  +'" style="width:100%;" class="boxtext" value="'+detail+'">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title = document.getElementById("row_detail"+satir_say).value;	
		newCell.innerHTML = '<input type="text" name="nominal_value' + row_count  +'" id="nominal_value' + row_count  +'" style="width:100%;" value="'+nominal_value+'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" onBlur="hesapla('+row_count+');" class="box">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title = document.getElementById("row_detail"+satir_say).value;	
		newCell.innerHTML = '<input type="text" name="other_nominal_value' + row_count  +'" id="other_nominal_value' + row_count  +'" style="width:100%;" value="'+other_nominal_value+'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" class="box" readonly="yes">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title = document.getElementById("row_detail"+satir_say).value;	
		newCell.innerHTML = '<input type="text" name="sale_value' + row_count  +'" id="sale_value' + row_count  +'" style="width:100%;" value="'+sale_value+'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" onBlur="hesapla('+row_count+');" class="box">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title = document.getElementById("row_detail"+satir_say).value;	
		newCell.innerHTML = '<input type="text" name="other_sale_value' + row_count  +'" id="other_sale_value' + row_count  +'" style="width:100%;" value="'+other_sale_value+'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" class="box" readonly="yes">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title = document.getElementById("row_detail"+satir_say).value;	
		newCell.innerHTML = '<input type="text" name="quantity' + row_count  +'" id="quantity' + row_count  +'" style="width:100%;" class="box" value="'+temp_quantity+'" onBlur="hesapla('+row_count+');" onkeyup="return(FormatCurrency(this,event,4));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title = document.getElementById("row_detail"+satir_say).value;	
		newCell.innerHTML = '<input type="text" name="total_sale' + row_count  +'" id="total_sale' + row_count  +'" style="width:100%;" value="'+total_sale+'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" onBlur="hesapla('+row_count+');" readonly="yes" class="box">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title = document.getElementById("row_detail"+satir_say).value;	
		newCell.innerHTML = '<input type="text" name="other_total_sale' + row_count  +'" id="other_total_sale' + row_count  +'" style="width:100%;" value="'+other_total_sale+'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" class="box" readonly="yes">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap', 'nowrap');
		newCell.title = document.getElementById("row_detail"+satir_say).value;	
		newCell.innerHTML = '<input type="text" name="expense_center_id' + row_count  +'" id="expense_center_id' + row_count  +'" style="width:120px;" class="boxtext" value="'+expense_center_name+'" readonly="yes">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap', 'nowrap');
		newCell.title = document.getElementById("row_detail"+satir_say).value;	
		newCell.innerHTML = '<input type="text" name="expense_item_id' + row_count  +'" id="expense_item_id' + row_count  +'" style="width:120px;" class="boxtext" value="'+expense_item_name+'" readonly="yes">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap', 'nowrap');
		newCell.title = document.getElementById("row_detail"+satir_say).value;	
		
		newCell.setAttribute("id","due_date" + row_count + "_td");
		newCell.innerHTML = '<input type="text" name="due_date' + row_count +'" id="due_date' + row_count +'" class="text" maxlength="10" style="width:70px;" value="'+due_date+'">';
		wrk_date_image('due_date' + row_count);
		
		toplam_hesapla();
	}
	
	function hesapla(row_no)
	{
		sale_value = document.getElementById("sale_value"+row_no);
		nominal_value = document.getElementById("nominal_value"+row_no);
		quantity = document.getElementById("quantity"+row_no);
		if(sale_value.value  == " ") sale_value.value  = 0;
		if(nominal_value.value  == " ") nominal_value.value  = 0;
		if(quantity.value  == " ") quantity.value  = 1;
		for (var i=1; i<=document.getElementById("deger_get_money").value; i++)
		{		
			if(document.add_bond.rd_money[i-1].checked == true)
			{
				form_value_rate2 = filterNum(document.getElementById("value_rate2"+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/filterNum(document.getElementById("txt_rate1_"+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				document.getElementById("other_total_sale"+row_no).value = commaSplit(filterNum(document.getElementById("total_sale"+row_no).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/form_value_rate2,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				document.getElementById("other_sale_value"+row_no).value = commaSplit(filterNum(document.getElementById("sale_value"+row_no).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/form_value_rate2,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				document.getElementById("other_nominal_value"+row_no).value = commaSplit(filterNum(document.getElementById("nominal_value"+row_no).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/form_value_rate2,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			}
		}
		toplam_hesapla();
	}
	function toplam_hesapla()
	{
		var total_amount = 0;
		var other_total_amount = 0;
	
		var nominal_total_amount = 0;
		var other_nominal_total_amount = 0;
		for(j=1;j<=document.getElementById("record_num").value;j++)
		{		
			if(document.getElementById("row_kontrol"+j).value==1)
			{
				document.getElementById("total_sale"+j).value = commaSplit(parseFloat(filterNum(document.getElementById("sale_value"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'))*parseFloat(filterNum(document.getElementById("quantity"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				document.getElementById("other_total_sale"+j).value = commaSplit(parseFloat(filterNum(document.getElementById("other_sale_value"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'))*parseFloat(filterNum(document.getElementById("quantity"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				total_amount += parseFloat(filterNum(document.getElementById("total_sale"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'));
				other_total_amount += parseFloat(filterNum(document.getElementById("other_total_sale"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'));
				nominal_total_amount += parseFloat(filterNum(document.getElementById("nominal_value"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'))*parseFloat(filterNum(document.getElementById("quantity"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'));
				other_nominal_total_amount += parseFloat(filterNum(document.getElementById("other_nominal_value"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'))*parseFloat(filterNum(document.getElementById("quantity"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'));
			}
		}
		com_rate = filterNum(document.getElementById("com_rate").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("action_value").value = commaSplit(total_amount,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("sale_other").value = commaSplit(other_total_amount,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("com_ytl").value =commaSplit(filterNum(document.getElementById("action_value").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')*com_rate/100,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("com_other").value =commaSplit(filterNum(document.getElementById("sale_other").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')*com_rate/100,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("total_income").value =commaSplit(total_amount-nominal_total_amount,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("total_income_other").value =commaSplit(other_total_amount-other_nominal_total_amount,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("nominal_total_amount").value =commaSplit(nominal_total_amount,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("other_nominal_total_amount").value =commaSplit(other_nominal_total_amount,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	}
	function doviz_hesapla()
	{
		for (var t=1; t<=document.getElementById("deger_get_money").value; t++)
		{		
			if(document.add_bond.rd_money[t-1].checked == true)
			{
				for(k=1;k<=document.getElementById("record_num").value;k++)
				{		
					rate2_value = filterNum(document.getElementById("value_rate2"+t).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/filterNum(document.getElementById("txt_rate1_"+t).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
					document.getElementById("other_nominal_value"+k).value = commaSplit(filterNum(document.getElementById("nominal_value"+k).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/rate2_value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
					document.getElementById("other_sale_value"+k).value = commaSplit(filterNum(document.getElementById("sale_value"+k).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/rate2_value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
					document.getElementById("other_total_sale"+k).value = commaSplit(filterNum(document.getElementById("total_sale"+k).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/rate2_value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
					document.getElementById("sale_other").value = commaSplit(filterNum(document.getElementById("action_value").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/rate2_value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				}
				document.getElementById("other_money_info").value = document.add_bond.rd_money[t-1].value;
				document.getElementById("other_money_info1").value = document.add_bond.rd_money[t-1].value;
				document.getElementById("other_money_info2").value = document.add_bond.rd_money[t-1].value;
			}
		}
		toplam_hesapla();
	}
	function total_doviz_hesapla()
	{
		for (var t=1; t<=document.getElementById("deger_get_money").value; t++)
		{		
			if(document.add_bond.rd_money[t-1].checked == true)
			{
				rate2_value = filterNum(document.getElementById("value_rate2"+t).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/filterNum(document.getElementById("txt_rate1_"+t).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				document.getElementById("com_other").value = commaSplit(filterNum(document.getElementById("com_ytl").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/rate2_value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				document.getElementById("com_ytl").value = commaSplit(filterNum(document.getElementById("com_ytl").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				document.getElementById("total_income_other").value = commaSplit(filterNum(document.getElementById("total_income").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/rate2_value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				document.getElementById("total_income").value = commaSplit(filterNum(document.getElementById("total_income").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			}
		}
	}
	function kontrol()
	{	
		var record_exist=0;
		<cfif IsDefined("attributes.event") and attributes.event eq 'upd'>
			if (!chk_process_cat('upd_bond')) return false;
			if (!check_display_files('upd_bond')) return false;
		<cfelse>
			if (!chk_process_cat('add_bond')) return false;
			if (!check_display_files('add_bond')) return false;
		</cfif>
		
		if(document.getElementById("comp_name").value == "" && document.getElementById("account_id").value == "")			
		{
			alert("Cari ya da Banka Seçeneklerinden En Az Birini Seçmelisiniz");
			return false;
		}
		if(document.getElementById("comp_name").value != "" && document.getElementById("account_id").value != "")			
		{
			alert("Cari ve Banka Birlikte Seçilemez");
			return false;
		}
		if(document.getElementById("paper_no").value=="")
		{
			alert("<cf_get_lang_main no ='1144.Belge No Girmelisiniz'>!");
			return false;
		}
		if(document.getElementById("paper_no").value != "")
		{
			var get_paper_record = wrk_safe_query('get_paper_record','dsn3',0,document.getElementById("paper_no").value); 
			<cfif IsDefined("attributes.event") and attributes.event eq 'upd'>
				if(get_paper_record.recordcount > 1)
			<cfelse>
				if(get_paper_record.recordcount)
			</cfif>
			
			{ 
				alert("Girdiğiniz Belge No Kullanılıyor!");
				return false;
			}
		}
		
		
		
		var list = "";
		for(r=1;r<=document.getElementById("record_num").value;r++)
		{
			if(document.getElementById("row_kontrol"+r).value==1)
				{
					record_exist=1;
					if (document.getElementById("row_detail"+r).value == "")
					{ 
						alert ("<cf_get_lang no ='100.Lütfen Açıklama Giriniz'>!");
						return false;
					}
					if ((document.getElementById("nominal_value"+r).value == "")||(document.getElementById("nominal_value"+r).value ==0))
					{ 
						alert ("<cf_get_lang no ='101.Lütfen Nominal Değer Giriniz'>!");
						return false;
					}
					if ((document.getElementById("sale_value"+r).value == "")||(document.getElementById("sale_value"+r).value ==0))
					{ 
						alert ("<cf_get_lang no ='107.Lütfen Satış Değeri Giriniz'>!");
						return false;
					}
					if (document.getElementById("quantity"+r).value != '')
					{
						var listParam =document.getElementById("stockbond_id"+r).value+"*"+document.getElementById("stockbond_row_id"+r).value;
						var get_quantity = wrk_safe_query('get_stockbond_quantity','dsn3',0,listParam); 
						
						if(parseFloat(document.getElementById("quantity"+r).value) > parseFloat(get_quantity.NET_QUANTITY))
						{
							var list = list+'\n'+document.getElementById("bond_code"+r).value+'-'+document.getElementById("row_detail"+r).value;
						}					
					}
				}
		}
		if(list != '')
		{
			alert("Aşağıdaki Menkul Kıymetlerin Satış Miktarları Alış Miktarlarından Fazladır. Lütfen Kontrol Ediniz!\n"+list)				
			return false;
		}	
		if (record_exist == 0) 
		{
			alert("<cf_get_lang no ='103.Lütfen Satır Giriniz'>!");
			return false;
		}
		unformat_fields();
		return true;
	}
	function unformat_fields()
	{
		for(rm=1;rm<=document.getElementById("record_num").value;rm++)
		{
			document.getElementById("nominal_value"+rm).value =  filterNum(document.getElementById("nominal_value"+rm).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			document.getElementById("sale_value"+rm).value =  filterNum(document.getElementById("sale_value"+rm).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			document.getElementById("total_sale"+rm).value =  filterNum(document.getElementById("total_sale"+rm).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			document.getElementById("other_nominal_value"+rm).value =  filterNum(document.getElementById("other_nominal_value"+rm).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			document.getElementById("other_sale_value"+rm).value =  filterNum(document.getElementById("other_sale_value"+rm).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			document.getElementById("quantity"+rm).value =  filterNum(document.getElementById("quantity"+rm).value,'4');
			document.getElementById("other_total_sale"+rm).value =  filterNum(document.getElementById("other_total_sale"+rm).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
	
		document.getElementById("action_value").value = filterNum(document.getElementById("action_value").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("sale_other").value = filterNum(document.getElementById("sale_other").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("com_rate").value = filterNum(document.getElementById("com_rate").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("com_ytl").value = filterNum(document.getElementById("com_ytl").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("com_other").value = filterNum(document.getElementById("com_other").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("total_income").value = filterNum(document.getElementById("total_income").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("total_income_other").value = filterNum(document.getElementById("total_income_other").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("nominal_total_amount").value = filterNum(document.getElementById("nominal_total_amount").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("other_nominal_total_amount").value = filterNum(document.getElementById("other_nominal_total_amount").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		for(st=1;st<=document.getElementById("deger_get_money").value;st++)
		{
			document.getElementById("value_rate2"+st).value = filterNum(document.getElementById("value_rate2"+ st).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
	}
	function f_add_bond()
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_stockbonds&field_id=add_bond.stockbond_id','wide');
	}
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
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'credit.add_stockbond_sale';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'credit/form/add_stockbond_sale.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'credit/query/add_stockbond_sale.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'credit.add_stockbond_sale&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('add_stockbond','add_stockbond_bask')";
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'credit.add_stockbond_sale';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'credit/form/upd_stockbond_sale.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'credit/query/upd_stockbond_sale.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'credit.add_stockbond_sale&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'action_id=##attributes.action_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.action_id##';
	WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('add_stockbond','add_stockbond_bask')";
	
	if(IsDefined("attributes.event") && attributes.event is 'upd')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'credit.emptypopup_del_stockbond_purchase&action_id=#attributes.action_id#&old_process_type=#get_bond_action.process_type#&bank_action_id=#get_bond_action.bank_action_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'credit/query/del_stockbond_purchase.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'credit/query/del_stockbond_purchase.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'credit.add_stockbond_purchase';
	}

	 if(IsDefined("attributes.event") && attributes.event is 'upd')
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1966]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['customTag'] = '<cf_get_workcube_related_acts period_id="#session.ep.period_id#" company_id="#session.ep.company_id#" asset_cat_id="-17" module_id="51" action_section="ACTION_ID" action_id="#attributes.action_id#">';
		if( get_module_user(22))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[1040]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.action_id#&process_cat=#get_bond_action.process_type#','page','add_process')";
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=credit.add_stockbond_sale";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>

