<cf_get_lang_set module_name="credit">
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
	function sil(sy)
	{
		var my_element=document.getElementById("row_kontrol"+sy);
		my_element.value=0;
		var my_element=document.getElementById("frm_row"+sy);
		my_element.style.display="none";
		toplam_hesapla();
	}
	function kontrol()
	{	 
		record_exist=0;
		if (!chk_process_cat('add_bond')) return false;
		if(!check_display_files('add_bond')) return false;
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
		<cfif not IsDefined("attributes.event") or (IsDefined("attributes.event") and attributes.event eq 'add')>
			if(document.getElementById("paper_no").value != "")
			{
				var get_paper_record = wrk_safe_query('get_paper_record','dsn3',0,document.getElementById("paper_no").value); 
				if(get_paper_record.recordcount)
				{ 
					alert("Girdiğiniz Belge No Kullanılıyor!");
					return false;
				}
			}
		<cfelse>
			if(document.getElementById("paper_no").value != "")
			{
				var get_paper_record = wrk_safe_query('get_paper_record','dsn3',0,document.getElementById("paper_no").value); 
				if(get_paper_record.recordcount>1)
				{ 
					alert("Girdiğiniz Belge No Kullanılıyor!");
					return false;
				}
			}
		</cfif>
		
		process=document.add_bond.process_cat.value;
		var get_process_cat = wrk_safe_query('ch_get_process_cat','dsn3',0,process);
		if(get_process_cat.IS_ACCOUNT ==1)
		{			
			if (document.getElementById("acc_id").value=="" || document.getElementById("acc_name").value=="")
			{ 
				alert("Muhasebe Kodu Giriniz!");
				return false;
			}
		}
		for(r=1;r<=document.getElementById("record_num").value;r++)
		{
			if(document.getElementById("row_kontrol"+r).value==1)
				{
					record_exist=1;
					if (document.getElementById("bond_type"+r).value == "")
					{ 
						alert ("<cf_get_lang no ='98.Lütfen Menkul Kıymet Tipi Seçiniz'>!");
						return false;
					}
					if (document.getElementById("bond_code"+r).value == "")
					{ 
						alert ("<cf_get_lang no ='99.Lütfen Menkul Kıymet Kodu Giriniz'>!");
						return false;
					}
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
					<cfif not IsDefined("attributes.event") or (IsDefined("attributes.event") and attributes.event eq 'add')>
						if ((document.getElementById("action_value"+r).value == "")||(document.getElementById("action_value"+r).value ==0))
						{ 
							alert ("<cf_get_lang no ='102.Lütfen Alış Değeri Giriniz'>!");
							return false;
						}
					<cfelse>
						if ((document.getElementById("purchase_value"+r).value == "")||(document.getElementById("purchase_value"+r).value ==0))
						{ 
							alert ("<cf_get_lang no ='102.Lütfen Alış Değeri Giriniz'>!");
							return false;
						}
					</cfif>
					
				}
		}
		if (record_exist == 0) 

		{
			alert("<cf_get_lang no ='103.Lütfen Satır Giriniz'>!");
			return false;
		}
		unformat_fields();
		return true;
	}
</script>
<cfif not IsDefined("attributes.event") or (IsDefined("attributes.event") and attributes.event eq 'add')>
	<cfquery name="GET_MONEY" datasource="#dsn#">
        SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1
    </cfquery>
    <cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.comp_name" default="">
    <cfparam name="attributes.partner_name" default="">

	<script type="text/javascript">
	row_count=0;
	
	function add_row()
	{
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);	
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);		
		newRow.className = 'color-row';
		document.getElementById("record_num").value = row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" ><a style="cursor:pointer" onclick="sil(' + row_count + ');"  ><img  src="images/delete_list.gif" border="0" alt=<cf_get_lang_main no='51.Sil'>></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="bond_type' + row_count  +'" id="bond_type' + row_count  +'" style="width:130px;" class="boxtext"><option value=""><cf_get_lang no ="83.Menkul Kıymet Tipi"></option><cfoutput query="get_stockbond_types"><option value="#stockbond_type_id#">#stockbond_type#</option></cfoutput></select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="bond_code' + row_count  +'" id="bond_code' + row_count  +'" style="width:100%;" class="boxtext" maxlength="50">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="row_detail' + row_count  +'" id="row_detail' + row_count  +'" style="width:100%;" class="boxtext" maxlength="200">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="nominal_value' + row_count  +'" id="nominal_value' + row_count  +'" style="width:100%;" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" onBlur="hesapla('+row_count+');" class="box" value="0">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="other_nominal_value' + row_count  +'" id="other_nominal_value' + row_count  +'" style="width:100%;" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" class="box" readonly="yes" value="0">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="action_value' + row_count  +'" id="action_value' + row_count  +'" style="width:100%;" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" onBlur="hesapla('+row_count+');" class="box" value="0">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="other_action_value' + row_count  +'" id="other_action_value' + row_count  +'" style="width:100%;" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" class="box" readonly="yes" value="0">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="quantity' + row_count  +'" id="quantity' + row_count  +'" style="width:100%;" class="box" value="1" onBlur="if(this.value.length==0 || filterNum(this.value)==0) this.value = \'1\'; hesapla('+row_count+');" onkeyup="return(FormatCurrency(this,event,4));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="total_purchase' + row_count  +'" id="total_purchase' + row_count  +'" style="width:100%;" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" onBlur="hesapla('+row_count+');" class="box" value="0" readonly="yes">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap', 'nowrap');
		newCell.innerHTML = '<input type="text" name="other_total_purchase' + row_count  +'" id="other_total_purchase' + row_count  +'" style="width:100%;" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" class="box" readonly="yes"  value="0">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap', 'nowrap');
		newCell.innerHTML = '<select name="expense_center_id' + row_count  +'" id="expense_center_id' + row_count  +'" style="width:120px;" class="boxtext"><option value="">Masraf Merkezi</option><cfoutput query="get_expense_center"><option value="#expense_id#">#expense#</option></cfoutput></select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap', 'nowrap');
		newCell.innerHTML = '<select name="expense_item_id' + row_count  +'" id="expense_item_id' + row_count  +'" style="width:120px;" class="boxtext"><option value=""><cf_get_lang_main no ="822.Bütçe Kalemi"></option><cfoutput query="get_expense_item"><option value="#expense_item_id#">#expense_item_name#</option></cfoutput></select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap', 'nowrap');
		newCell.setAttribute("id","due_date" + row_count + "_td");
		newCell.innerHTML = '<input type="text" name="due_date' + row_count +'" id="due_date' + row_count +'" class="text" maxlength="10" style="width:70px;" value="">';
		wrk_date_image('due_date' + row_count);
		
		toplam_hesapla();
	}
	function hesapla(row_no)
	{
		action_value = document.getElementById("action_value"+row_no);
		nominal_value= document.getElementById("nominal_value"+row_no);
		quantity= document.getElementById("quantity"+row_no);
		if(action_value.value  == " ") action_value.value  = 0;
		if(nominal_value.value  == " ") nominal_value.value  = 0;
		if(quantity.value  == " ") quantity.value  = 1;
		for (var i=1; i<= document.getElementById("deger_get_money").value; i++)
		{	
			if(document.add_bond.rd_money[i-1].checked == true)
			{	
				form_value_rate2 = filterNum(document.getElementById("value_rate2"+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/filterNum(document.getElementById("txt_rate1_"+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				document.getElementById("other_total_purchase"+row_no).value = commaSplit(filterNum(document.getElementById("total_purchase"+row_no).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/ (parseFloat(form_value_rate2)),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				document.getElementById("other_action_value"+row_no).value = commaSplit(filterNum(document.getElementById("action_value"+row_no).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/(parseFloat(form_value_rate2)),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				document.getElementById("other_nominal_value"+row_no).value = commaSplit(filterNum(document.getElementById("nominal_value"+row_no).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/(parseFloat(form_value_rate2)),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			}
		}
		toplam_hesapla();
	}
	function toplam_hesapla()
	{
		var total_amount = 0;
		var other_total_amount = 0;
		for(j=1;j<=document.getElementById("record_num").value;j++)
		{		
			if(document.getElementById("row_kontrol"+j).value==1)
			{
				document.getElementById("total_purchase"+j).value = commaSplit(parseFloat(filterNum(document.getElementById("action_value"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'))*parseFloat(filterNum(document.getElementById("quantity"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				document.getElementById("other_total_purchase"+j).value = commaSplit(parseFloat(filterNum(document.getElementById("other_action_value"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'))*parseFloat(filterNum(document.getElementById("quantity"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				total_amount += parseFloat(filterNum(document.getElementById("total_purchase"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'));
				other_total_amount += parseFloat(filterNum(document.getElementById("other_total_purchase"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'));
			}
		}
		com_rate = filterNum(document.getElementById("com_rate").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("action_value").value = commaSplit(total_amount,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("purchase_other").value = commaSplit(other_total_amount,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("com_ytl").value =commaSplit(filterNum(document.getElementById("action_value").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')*com_rate/100,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("com_other").value =commaSplit(filterNum(document.getElementById("purchase_other").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')*com_rate/100,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
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
					document.getElementById("other_action_value"+k).value = commaSplit(filterNum(document.getElementById("action_value"+k).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/rate2_value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
					document.getElementById("other_total_purchase"+k).value = commaSplit(filterNum(document.getElementById("total_purchase"+k).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/rate2_value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
					document.getElementById("purchase_other").value = commaSplit(filterNum(document.getElementById("action_value").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/rate2_value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				}
				document.getElementById("other_money_info").value = document.add_bond.rd_money[t-1].value;
				document.getElementById("other_money_info1").value = document.add_bond.rd_money[t-1].value;
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
			}
		}
	}
	
	function unformat_fields()
	{
		for(rm=1;rm<=document.getElementById("record_num").value;rm++)
		{
			document.getElementById("nominal_value"+rm).value =  filterNum(document.getElementById("nominal_value"+rm).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			document.getElementById("action_value"+rm).value =  filterNum(document.getElementById("action_value"+rm).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			document.getElementById("total_purchase"+rm).value =  filterNum(document.getElementById("total_purchase"+rm).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			document.getElementById("other_nominal_value"+rm).value =  filterNum(document.getElementById("other_nominal_value"+rm).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			document.getElementById("other_action_value"+rm).value =  filterNum(document.getElementById("other_action_value"+rm).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			document.getElementById("quantity"+rm).value =  filterNum(document.getElementById("quantity"+rm).value,'4'); <!--- miktar alanı yeniden formatlanıyor.  --->
			document.getElementById("other_total_purchase"+rm).value =  filterNum(document.getElementById("other_total_purchase"+rm).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
		document.getElementById("action_value").value = filterNum(document.getElementById("action_value").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("purchase_other").value = filterNum(document.getElementById("purchase_other").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("com_rate").value = filterNum(document.getElementById("com_rate").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("com_ytl").value = filterNum(document.getElementById("com_ytl").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("com_other").value = filterNum(document.getElementById("com_other").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		for(st=1;st<=document.getElementById("deger_get_money").value;st++)
		{
			document.getElementById("value_rate2" + st).value = filterNum(document.getElementById("value_rate2" + st).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
	}
</script>
</cfif>

<cfif IsDefined("attributes.event") and attributes.event eq 'upd'>
	<cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.comp_name" default="">
    <cfparam name="attributes.partner_name" default="">
    <cfquery name="GET_BOND_ACTION" datasource="#dsn3#">
        SELECT * FROM STOCKBONDS_SALEPURCHASE WHERE ACTION_ID=#attributes.action_id#
    </cfquery>
    <cfquery name="GET_ACTION_MONEY" datasource="#dsn3#">
        SELECT MONEY_TYPE AS MONEY, * FROM STOCKBONDS_SALEPURCHASE_MONEY WHERE ACTION_ID = #attributes.action_id#
    </cfquery>
    <cfif not GET_ACTION_MONEY.recordcount>
        <cfquery name="GET_ACTION_MONEY" datasource="#dsn2#">
            SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY
        </cfquery>
    </cfif>
    <cfquery name="GET_STOCKBOND_ROWS" datasource="#dsn3#">
        SELECT
            * ,
            EXPENSE_CENTER.EXPENSE_ID, 
            EXPENSE_CENTER.EXPENSE_CODE, 
            EXPENSE_CENTER.EXPENSE,
            EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
            EXPENSE_ITEMS.EXPENSE_ITEM_ID,
            SETUP_STOCKBOND_TYPE.*
        FROM
            STOCKBONDS
            LEFT JOIN STOCKBONDS_SALEPURCHASE_ROW ON STOCKBONDS.STOCKBOND_ID = STOCKBONDS_SALEPURCHASE_ROW.STOCKBOND_ID
            LEFT JOIN #dsn_alias#.EXPENSE_CENTER ON EXPENSE_CENTER.EXPENSE_ID = STOCKBONDS.ROW_EXP_CENTER_ID
            LEFT JOIN #dsn_alias#.EXPENSE_ITEMS ON EXPENSE_ITEMS.EXPENSE_ITEM_ID = STOCKBONDS.ROW_EXP_ITEM_ID
            LEFT JOIN #dsn_alias#.SETUP_STOCKBOND_TYPE ON SETUP_STOCKBOND_TYPE.STOCKBOND_TYPE_ID = STOCKBONDS.STOCKBOND_TYPE
        WHERE
            STOCKBONDS_SALEPURCHASE_ROW.SALES_PURCHASE_ID = #attributes.action_id# 
            
    </cfquery>
    	<cfif len(get_bond_action.company_id)>
            <cfquery name="GET_COMP" datasource="#dsn#">
                SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID=#get_bond_action.company_id#
            </cfquery>
        </cfif>
        
        <cfif len(get_bond_action.employee_id)>
            <cfquery name="GET_EMP" datasource="#dsn#">
                SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID=#get_bond_action.employee_id#
            </cfquery>
        </cfif>
        
        <cfif len(get_bond_action.partner_id) and len(get_bond_action.company_id)>
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
	<script type="text/javascript">
        row_count=<cfoutput>#get_stockbond_rows.recordcount#</cfoutput>;
    
        function add_row()
        {
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
            newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><a style="cursor:pointer" onclick="sil(' + row_count + ');"  ><img  src="images/delete_list.gif" alt="Sil" border="0" alt=<cf_get_lang_main no='51.Sil'>></a>';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<select name="bond_type' + row_count  +'" id="bond_type' + row_count  +'" style="width:130px;" class="boxtext"><option value=""><cf_get_lang no ="83.Menkul Kıymet Tipi"></option><cfoutput query="get_stockbond_types"><option value="#stockbond_type_id#">#stockbond_type#</option></cfoutput></select>';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="hidden" name="stockbond_id' + row_count +'" id="stockbond_id' + row_count +'" value=""><input type="text" name="bond_code' + row_count +'" id="bond_code' + row_count +'" style="width:100%;" class="boxtext" maxlength="50">';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="row_detail' + row_count +'" id="row_detail' + row_count +'" style="width:100%;" class="boxtext" maxlength="200">';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="nominal_value' + row_count +'" id="nominal_value' + row_count +'" style="width:100%;" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" onBlur="hesapla('+row_count+');" class="box" value="0">';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="other_nominal_value' + row_count +'" id="other_nominal_value' + row_count +'" style="width:100%;" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" class="box" readonly="yes" value="0">';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="purchase_value' + row_count +'" id="purchase_value' + row_count +'" style="width:100%;" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" onBlur="hesapla('+row_count+');" class="box" value="0">';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="other_purchase_value' + row_count +'" id="other_purchase_value' + row_count +'" style="width:100%;" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" class="box" readonly="yes" value="0">';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="quantity' + row_count +'" id="quantity' + row_count +'" style="width:100%;" class="box" value="1" onBlur="if(this.value.length==0 || filterNum(this.value)==0) this.value = \'1\'; hesapla('+row_count+');" onkeyup="return(FormatCurrency(this,event,4));">';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="total_purchase' + row_count +'" id="total_purchase' + row_count +'" style="width:100%;" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" onBlur="hesapla('+row_count+');" class="box" value="0" readonly="yes">';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<input type="text" name="other_total_purchase' + row_count +'" id="other_total_purchase' + row_count +'" style="width:100%;" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" class="box" readonly="yes"  value="0">';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<select name="expense_center_id' + row_count +'" id="expense_center_id' + row_count +'" style="width:120px;" class="boxtext"><option value="">Masraf Merkezi</option><cfoutput query="get_expense_center"><option value="#expense_id#">#expense#</option></cfoutput></select>';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.innerHTML = '<select name="expense_item_id' + row_count +'" id="expense_item_id' + row_count +'" style="width:120px;" class="boxtext"><option value=""><cf_get_lang_main no ="822.Bütçe Kalemi"></option><cfoutput query="get_expense_item"><option value="#expense_item_id#">#expense_item_name#</option></cfoutput></select>';
            newCell = newRow.insertCell(newRow.cells.length);
            newCell.setAttribute("nowrap","nowrap");
            newCell.setAttribute("id","due_date" + row_count + "_td");
            newCell.innerHTML = '<input type="text" name="due_date' + row_count +'" id="due_date' + row_count +'" class="text" maxlength="10" style="width:70px;" value="">';
            wrk_date_image('due_date' + row_count);
            
            toplam_hesapla();
        }
        function hesapla(row_no)
        {
            purchase_value = document.getElementById("purchase_value"+row_no);
            nominal_value= document.getElementById("nominal_value"+row_no);
            quantity= document.getElementById("quantity"+row_no);
            if(purchase_value.value  == " ") purchase_value.value  = 0;
            if(nominal_value.value  == " ") nominal_value.value  = 0;
            if(quantity.value  == " ") quantity.value  = 1;
            for (var i=1; i<=document.getElementById("deger_get_money").value; i++)
            {		
                if(document.add_bond.rd_money[i-1].checked == true)
                {
                    form_value_rate2 = filterNum(document.getElementById("value_rate2"+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/filterNum(document.getElementById("txt_rate1_"+i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
                    document.getElementById("other_total_purchase"+row_no).value = commaSplit(filterNum(document.getElementById("total_purchase"+row_no).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/(parseFloat(form_value_rate2)),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
                    document.getElementById("other_purchase_value"+row_no).value = commaSplit(filterNum(document.getElementById("purchase_value"+row_no).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/(parseFloat(form_value_rate2)),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
                    document.getElementById("other_nominal_value"+row_no).value = commaSplit(filterNum(document.getElementById("nominal_value"+row_no).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/(parseFloat(form_value_rate2)),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
                }
            }
            toplam_hesapla();
        }
        function toplam_hesapla()
        {
            var total_amount = 0;
            var other_total_amount = 0;
            for(j=1;j<=document.getElementById("record_num").value;j++)
            {		
                if(document.getElementById("row_kontrol"+j).value==1)
                {
                    document.getElementById("total_purchase"+j).value = commaSplit(parseFloat(filterNum(document.getElementById("purchase_value"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'))*parseFloat(filterNum(document.getElementById("quantity"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
                    document.getElementById("other_total_purchase"+j).value = commaSplit(parseFloat(filterNum(document.getElementById("other_purchase_value"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'))*parseFloat(filterNum(document.getElementById("quantity"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')),'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
                    total_amount += parseFloat(filterNum(document.getElementById("total_purchase"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'));
                    other_total_amount += parseFloat(filterNum(document.getElementById("other_total_purchase"+j).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>'));
                }
            }
            com_rate = filterNum(document.getElementById("com_rate").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
            document.getElementById("action_value").value = commaSplit(total_amount,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
            document.getElementById("purchase_other").value = commaSplit(other_total_amount,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
            document.getElementById("com_ytl").value =commaSplit(filterNum(document.getElementById("action_value").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')*com_rate/100,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
            document.getElementById("com_other").value =commaSplit(filterNum(document.getElementById("purchase_other").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')*com_rate/100,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
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
                        document.getElementById("other_purchase_value"+k).value = commaSplit(filterNum(document.getElementById("purchase_value"+k).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/rate2_value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
                        document.getElementById("other_total_purchase"+k).value = commaSplit(filterNum(document.getElementById("total_purchase"+k).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/rate2_value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
                        document.getElementById("purchase_other").value = commaSplit(filterNum(document.getElementById("action_value").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/rate2_value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
                    }
                    document.getElementById("other_money_info").value = document.add_bond.rd_money[t-1].value;
                    document.getElementById("other_money_info1").value = document.add_bond.rd_money[t-1].value;
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
                }
            }
        }
        function unformat_fields()
        {
            for(rm=1;rm<=document.getElementById("record_num").value;rm++)
            {
                document.getElementById("nominal_value"+rm).value =  filterNum(document.getElementById("nominal_value"+rm).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
                document.getElementById("purchase_value"+rm).value =  filterNum(document.getElementById("purchase_value"+rm).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
                document.getElementById("total_purchase"+rm).value =  filterNum(document.getElementById("total_purchase"+rm).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
                document.getElementById("other_nominal_value"+rm).value =  filterNum(document.getElementById("other_nominal_value"+rm).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
                document.getElementById("other_purchase_value"+rm).value =  filterNum(document.getElementById("other_purchase_value"+rm).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
                document.getElementById("quantity"+rm).value =  filterNum(document.getElementById("quantity"+rm).value,'4'); <!--- miktar alanı yeniden formatlanıyor.  --->
                document.getElementById("other_total_purchase"+rm).value =  filterNum(document.getElementById("other_total_purchase"+rm).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
            }
            document.getElementById("action_value").value = filterNum(document.getElementById("action_value").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
            document.getElementById("purchase_other").value = filterNum(document.getElementById("purchase_other").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
            document.getElementById("com_rate").value = filterNum(document.getElementById("com_rate").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
            document.getElementById("com_ytl").value = filterNum(document.getElementById("com_ytl").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
            document.getElementById("com_other").value = filterNum(document.getElementById("com_other").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
            for(st=1;st<=document.getElementById("deger_get_money").value;st++)
            {
                document.getElementById("value_rate2"+ st).value = filterNum(document.getElementById("value_rate2"+ st).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
            }
        }
    </script>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'credit.add_stockbond_purchase';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'credit/form/add_stockbond_purchase.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'credit/query/add_stockbond_purchase.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'credit.add_stockbond_purchase&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('add_stockbond','add_stockbond_bask')";
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'credit.add_stockbond_purchase';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'credit/form/upd_stockbond_purchase.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'credit/query/upd_stockbond_purchase.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'credit.add_stockbond_purchase&event=upd';
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
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=credit.add_stockbond_purchase";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>

