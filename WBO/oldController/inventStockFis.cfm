<cf_get_lang_set module_name="invent">
<cfparam name="attributes.process_cat" default="" >
<cfparam name="attributes.ref_no" default="" >
<cfparam name="attributes.employee_id" default="#session.ep.userid#" >
<cfparam name="attributes.project_id" default="" >
<cfparam name="attributes.project_head" default="" >
<cfparam name="attributes.subscription_id" default="" >
<cfparam name="attributes.SUBSCRIPTION_NO" default="" >
<cfparam name="attributes.FIS_DETAIL" default="" >
<cfparam name="attributes.related_invoice_id" default="" >
<cfparam name="attributes.related_invoice_number" default="" >
<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1
</cfquery>
<cfquery name="GET_TAX" datasource="#dsn2#">
	SELECT * FROM SETUP_TAX ORDER BY TAX
</cfquery>
<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
	SELECT EXPENSE_ID,EXPENSE,EXPENSE_CODE FROM EXPENSE_CENTER ORDER BY EXPENSE
</cfquery>
<cfquery name="GET_INVENTORY_CATS" datasource="#dsn3#">
	SELECT * FROM SETUP_INVENTORY_CAT ORDER BY INVENTORY_CAT_ID
</cfquery>

<cfif  IsDefined("attributes.event") and attributes.event eq 'upd'>
	<cfquery name="GET_FIS_DET" datasource="#dsn2#">
        SELECT * FROM STOCK_FIS WHERE FIS_ID = #attributes.fis_id#
    </cfquery>
    <cfquery name="GET_STOCK_FIS_MONEY" datasource="#dsn2#">
        SELECT MONEY_TYPE AS MONEY,* FROM STOCK_FIS_MONEY WHERE ACTION_ID = #attributes.fis_id#
    </cfquery>
    <cfquery name="GET_STOCK_MONEY" datasource="#dsn2#">
        SELECT RATE2,MONEY_TYPE FROM STOCK_FIS_MONEY WHERE ACTION_ID = #attributes.fis_id# AND IS_SELECTED=1
    </cfquery>
    <cfif not GET_STOCK_FIS_MONEY.recordcount>
        <cfquery name="GET_INVOICE_MONEY" datasource="#DSN#">
            SELECT MONEY,RATE2,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS=1
        </cfquery>
    </cfif>
    
    <cfquery name="GET_ACCOUNTS" datasource="#dsn3#">
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
            AND IR.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.fis_id#">
            AND IR.PROCESS_TYPE = 118
            AND PERIOD_ID = #session.ep.period_id#
    </cfquery>
    <cfif session.ep.our_company_info.project_followup eq 1>
    	<cfif len(get_fis_det.project_id)>
            <cfquery name="GET_PROJECT" datasource="#dsn#">
                SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #get_fis_det.project_id#
            </cfquery>
        </cfif>
    </cfif>
    <cfif len(get_fis_det.related_invoice_id)>
        <cfquery name="get_invoice" datasource="#dsn2#">
            SELECT INVOICE_ID,INVOICE_NUMBER FROM INVOICE WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_fis_det.related_invoice_id#">
        </cfquery>
    </cfif>
    <cfif session.ep.our_company_info.subscription_contract eq 1>
		<cfif len(get_fis_det.subscription_id)>
            <cfquery name="GET_SUBS_INFO" datasource="#dsn3#">
                SELECT SUBSCRIPTION_NO FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = #get_fis_det.subscription_id#
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
            (SELECT ISNULL(SUM(IA.AMORTIZATION_ID),0) FROM #dsn3_alias#.INVENTORY_AMORTIZATON IA WHERE IA.INVENTORY_ID = INVENTORY.INVENTORY_ID) AMORT_COUNT,
            SR.* ,
            INVENTORY.*,
            S.PRODUCT_ID,
            EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
            EXPENSE_ITEMS.ACCOUNT_CODE,
            EXPENSE_CENTER.*,
            P.PRODUCT_NAME
        FROM
            STOCK_FIS_ROW SR
            LEFT JOIN #dsn3_alias#.STOCKS S ON SR.STOCK_ID = S.STOCK_ID
            LEFT JOIN #dsn3_alias#.INVENTORY INVENTORY ON INVENTORY.INVENTORY_ID = SR.INVENTORY_ID
            LEFT JOIN #dsn2_alias#.EXPENSE_ITEMS ON EXPENSE_ITEMS.EXPENSE_ITEM_ID = INVENTORY.EXPENSE_ITEM_ID
            LEFT JOIN #dsn2_alias#.EXPENSE_CENTER ON EXPENSE_CENTER.EXPENSE_ID = INVENTORY.EXPENSE_CENTER_ID
            LEFT JOIN #dsn1_alias#.PRODUCT P ON P.PRODUCT_ID = S.PRODUCT_ID
        WHERE
            SR.FIS_ID = #attributes.fis_id# 
    </cfquery>
    <cfset net_toplam = 0>
    <cfset gross_toplam = 0>
    <cfset tax_toplam = 0>
    <cfset doviz_topla=0>
    <cfset doviz_kdv_topla=0>
    <cfset item_id_list=''>
	<cfset exp_center_id_list=''>
    <cfset stok_id_list=''>
    <script type="text/javascript">
	function kontrol()
	{
		if(!chk_process_cat('add_invent_stock_fis')) return false;
		if(!check_display_files('add_invent_stock_fis')) return false;
		if(add_invent_stock_fis.department_id_2.value=="" || add_invent_stock_fis.department_name_2.value=="")
		{
			alert("<cf_get_lang_main no='1631.Çıkış Depo'>!");
			return false;
		}
		if(document.add_invent_stock_fis.department_name.value == "")
		{
			document.add_invent_stock_fis.department_id.value = "";
			document.add_invent_stock_fis.location_id.value = "";
		}
		
		record_exist=0;//Row_kontrol değeri 1 olan yani silinmemiş satırların varlığını kontrol ediyor
		for(r=1;r<=add_invent_stock_fis.record_num.value;r++)
		{
			if(eval("document.add_invent_stock_fis.row_kontrol"+r).value == 1)
			{
				record_exist=1;
				if (eval("document.add_invent_stock_fis.invent_no"+r).value == "")
				{ 
					alert ("<cf_get_lang no='88.Lütfen Demirbaş No Giriniz'>!");
					return false;
				}
				if (eval("document.add_invent_stock_fis.invent_name"+r).value == "")
				{ 
					alert ("<cf_get_lang no='93.Lütfen Açıklama Giriniz'>!");
					return false;
				}
				if ((eval("document.add_invent_stock_fis.row_total"+r).value == "")||(eval("document.add_invent_stock_fis.row_total"+r).value ==0))
				{ 
					alert ("<cf_get_lang_main no='1738.Lütfen Tutar Giriniz '>!");
					return false;
				}
				if ((eval("document.add_invent_stock_fis.amortization_rate"+r).value == "")||(eval("document.add_invent_stock_fis.amortization_rate"+r).value < 0))
				{ 
					alert ("<cf_get_lang no='95.Lütfen Amortisman Oranı Giriniz'> !");
					return false;
				}
				if (eval("document.add_invent_stock_fis.account_id"+r).value == "")
				{ 
					alert ("<cf_get_lang no='96.Lütfen Muhasebe Kodu Seçiniz'>!");
					return false;
				}
				if(document.getElementById('is_related_project') == undefined)
				{
					if (eval("document.add_invent_stock_fis.stock_id"+r).value == "")
					{ 
						alert ("<cf_get_lang_main no='313.Lütfen Ürün Seçiniz'>!");
						return false;
					}
				}
				eval("document.add_invent_stock_fis.amortization_method"+r).disabled = false;
				eval("document.add_invent_stock_fis.amortization_type"+r).disabled = false;
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
	/* delete function */
	function kontrol_2()
	{
			debugger;
		if (!check_display_files('add_invent_stock_fis')) return false;
		return true;
	}
	function amortisman_kontrol(x)
	{
		deger_amortization_rate = eval("document.add_invent_stock_fis.amortization_rate"+x);
	
		if (filterNum(deger_amortization_rate.value) >100)
		{ 
			alert ("Amortisman Oranı 100'den Büyük Olamaz !");
			deger_amortization_rate.value = 0;
			return false;
		}
		return true;
	}
	function period_kontrol(no)
	{
		deger = eval("document.add_invent_stock_fis.period"+no);
		if ((filterNum(deger.value) <1) || (deger.value==""))
		{ 
			alert ("Hesaplama Dönemi 1 'den Küçük Olamaz!");
			deger.value =1;
			return false;
		}
		return true;
	}
	
	function unformat_fields()
	{
		for(r=1;r<=add_invent_stock_fis.record_num.value;r++)
		{
			deger_total = eval("document.add_invent_stock_fis.row_total"+r);
			deger_kdv_total= eval("document.add_invent_stock_fis.kdv_total"+r);
			deger_net_total = eval("document.add_invent_stock_fis.net_total"+r);
			deger_other_net_total = eval("document.add_invent_stock_fis.row_other_total"+r);
			deger_amortization_rate = eval("document.add_invent_stock_fis.amortization_rate"+r);
			temp_inventory_duration= eval("document.add_invent_stock_fis.inventory_duration"+r);
			
			deger_total.value = filterNum(deger_total.value);
			deger_kdv_total.value = filterNum(deger_kdv_total.value);
			deger_net_total.value = filterNum(deger_net_total.value);
			deger_other_net_total.value = filterNum(deger_other_net_total.value);
			deger_amortization_rate.value = filterNum(deger_amortization_rate.value);
			temp_inventory_duration.value=filterNum(temp_inventory_duration.value);
		}
		document.add_invent_stock_fis.total_amount.value = filterNum(document.add_invent_stock_fis.total_amount.value);
		document.add_invent_stock_fis.kdv_total_amount.value = filterNum(document.add_invent_stock_fis.kdv_total_amount.value);
		document.add_invent_stock_fis.net_total_amount.value = filterNum(document.add_invent_stock_fis.net_total_amount.value);
		document.add_invent_stock_fis.other_total_amount.value = filterNum(document.add_invent_stock_fis.other_total_amount.value);
		document.add_invent_stock_fis.other_kdv_total_amount.value = filterNum(document.add_invent_stock_fis.other_kdv_total_amount.value);
		document.add_invent_stock_fis.other_net_total_amount.value = filterNum(document.add_invent_stock_fis.other_net_total_amount.value);
		for(s=1;s<=add_invent_stock_fis.kur_say.value;s++)
		{
			eval('add_invent_stock_fis.txt_rate2_' + s).value = filterNum(eval('add_invent_stock_fis.txt_rate2_' + s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			eval('add_invent_stock_fis.txt_rate1_' + s).value = filterNum(eval('add_invent_stock_fis.txt_rate1_' + s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
	}
	row_count=<cfoutput>#get_rows.recordcount#</cfoutput>;
	function sil(sy)
	{
		var my_element=eval("add_invent_stock_fis.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
		toplam_hesapla();
	}
	function hesapla(satir,hesap_type)
	{
		var toplam_dongu_0 = 0;//satir toplam
		if(eval("document.add_invent_stock_fis.row_kontrol"+satir).value==1)
		{
			deger_total = eval("document.add_invent_stock_fis.row_total"+satir);//tutar
			deger_miktar = eval("document.add_invent_stock_fis.quantity"+satir);//miktar
			deger_kdv_total= eval("document.add_invent_stock_fis.kdv_total"+satir);//kdv tutarı
			deger_net_total = eval("document.add_invent_stock_fis.net_total"+satir);//kdvli tutar
			deger_tax_rate = eval("document.add_invent_stock_fis.tax_rate"+satir);//kdv oranı
			deger_other_net_total = eval("document.add_invent_stock_fis.row_other_total"+satir);//dovizli tutar kdv dahil
			if(deger_total.value == "") deger_total.value = 0;
			if(deger_kdv_total.value == "") deger_kdv_total.value = 0;
			if(deger_net_total.value == "") deger_net_total.value = 0;
			deger_money_id = eval("document.add_invent_stock_fis.money_id"+satir);
			deger_money_id_ilk = list_getat(deger_money_id.value,2,',');
			deger_money_id_son = list_getat(deger_money_id.value,3,',');
			deger_total.value = filterNum(deger_total.value);
			deger_kdv_total.value = filterNum(deger_kdv_total.value);
			deger_net_total.value = filterNum(deger_net_total.value);
			deger_other_net_total.value = filterNum(deger_other_net_total.value);
			deger_miktar.value = filterNum(deger_miktar.value,0);
			
			if(hesap_type ==undefined)
			{
				deger_kdv_total.value = (parseFloat(deger_total.value) * deger_miktar.value * deger_tax_rate.value)/100;
			}else if(hesap_type == 2)
			{
				deger_total.value = ((parseFloat(deger_net_total.value)*100)/ (parseFloat(deger_tax_rate.value)+100))/deger_miktar.value;
				deger_kdv_total.value = (parseFloat(deger_total.value * deger_miktar.value * deger_tax_rate.value))/100;
			}
			toplam_dongu_0 = parseFloat(deger_total.value) + parseFloat(deger_kdv_total.value);
			deger_other_net_total.value = ((parseFloat(deger_total.value) + parseFloat(deger_kdv_total.value)) * parseFloat(deger_money_id_ilk) / (parseFloat(deger_money_id_son)));
			deger_net_total.value = commaSplit(toplam_dongu_0);
			deger_total.value = commaSplit(deger_total.value);
			deger_kdv_total.value = commaSplit(deger_kdv_total.value);
			deger_other_net_total.value = commaSplit(deger_other_net_total.value);
		}
			toplam_hesapla();
	}
	function toplam_hesapla()
	{
		var toplam_dongu_1 = 0;//tutar genel toplam
		var toplam_dongu_2 = 0;// kdv genel toplam
		var toplam_dongu_3 = 0;// kdvli genel toplam
		for(r=1;r<=add_invent_stock_fis.record_num.value;r++)
		{
			if(eval("document.add_invent_stock_fis.row_kontrol"+r).value==1)
			{
				deger_total = eval("document.add_invent_stock_fis.row_total"+r);//tutar
				deger_miktar = eval("document.add_invent_stock_fis.quantity"+r);//miktar
				deger_kdv_total= eval("document.add_invent_stock_fis.kdv_total"+r);//kdv tutarı
				deger_net_total = eval("document.add_invent_stock_fis.net_total"+r);//kdvli tutar
				deger_tax_rate = eval("document.add_invent_stock_fis.tax_rate"+r);//kdv oranı
				deger_other_net_total = eval("document.add_invent_stock_fis.row_other_total"+r);//dovizli tutar kdv dahil
				deger_money_id = eval("document.add_invent_stock_fis.money_id"+r);
				deger_money_id_ilk = list_getat(deger_money_id.value,1,',');
				for(s=1;s<=add_invent_stock_fis.kur_say.value;s++)
					{
						if(list_getat(document.add_invent_stock_fis.rd_money[s-1].value,1,',') == deger_money_id_ilk)
						{
							satir_rate2= eval("document.add_invent_stock_fis.txt_rate2_"+s).value;
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
			
		document.add_invent_stock_fis.total_amount.value = commaSplit(toplam_dongu_1);
		document.add_invent_stock_fis.kdv_total_amount.value = commaSplit(toplam_dongu_2);
		document.add_invent_stock_fis.net_total_amount.value = commaSplit(toplam_dongu_3);
		for(s=1;s<=add_invent_stock_fis.kur_say.value;s++)
		{
			form_txt_rate2_ = eval("document.add_invent_stock_fis.txt_rate2_"+s);
			if(form_txt_rate2_.value == "")
				form_txt_rate2_.value = 1;
		}
		if(add_invent_stock_fis.kur_say.value == 1)
			for(s=1;s<=add_invent_stock_fis.kur_say.value;s++)
			{
				if(document.add_invent_stock_fis.rd_money.checked == true)
				{
					deger_diger_para = document.add_invent_stock_fis.rd_money;
					form_txt_rate2_ = eval("document.add_invent_stock_fis.txt_rate2_"+s);
				}
			}
		else 
			for(s=1;s<=add_invent_stock_fis.kur_say.value;s++)
			{
				if(document.add_invent_stock_fis.rd_money[s-1].checked == true)
				{
					deger_diger_para = document.add_invent_stock_fis.rd_money[s-1];
					form_txt_rate2_ = eval("document.add_invent_stock_fis.txt_rate2_"+s);
				}
			}
		deger_money_id_1 = list_getat(deger_diger_para.value,1,',');
		deger_money_id_3 = list_getat(deger_diger_para.value,3,',');
		form_txt_rate2_.value = filterNum(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.add_invent_stock_fis.other_total_amount.value = commaSplit(toplam_dongu_1 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)));
		document.add_invent_stock_fis.other_kdv_total_amount.value = commaSplit(toplam_dongu_2 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)));
		document.add_invent_stock_fis.other_net_total_amount.value = commaSplit(toplam_dongu_3 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)));
	
		document.add_invent_stock_fis.tl_value1.value = deger_money_id_1;
		document.add_invent_stock_fis.tl_value2.value = deger_money_id_1;
		document.add_invent_stock_fis.tl_value3.value = deger_money_id_1;
		form_txt_rate2_.value = commaSplit(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	}
	function add_row(inventory_cat_id,inventory_cat,invent_id,invent_no,invent_name,quantity,net_total,row_total,tax_rate,kdv_total,net_total,row_other_total,money_id,inventory_duration,amortization_rate,amortization_method,amortization_type,account_id,account_code,expense_center_id,expense_center_name,expense_item_id,expense_item_name,period,debt_account_id,debt_account_code,claim_account_id,claim_account_code,product_id,stock_id,product_name,stock_unit_id,stock_unit)
	{
		if (inventory_cat_id == undefined) inventory_cat_id ="";
		if (inventory_cat == undefined) inventory_cat ="";
		if (invent_id == undefined) invent_id ="";
		if (invent_no == undefined) invent_no ="";
		if (invent_name == undefined) invent_name ="";
		if (quantity == undefined) quantity = 1;
		if (net_total == undefined) net_total ="";
		if (tax_rate == undefined) tax_rate ="";
		if (kdv_total == undefined) kdv_total = 0;
		if (net_total == undefined) net_total = 0;
		if (row_total == undefined) row_total = 0;
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
		document.add_invent_stock_fis.record_num.value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		x = '<input  type="hidden" value="WRK'+row_count+ js_create_unique_id() + row_count+'" name="wrk_row_id' + row_count +'"><input  type="hidden" value="" name="wrk_row_relation_id' + row_count +'">';
		newCell.innerHTML = x + '<input  type="hidden" value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><a style="cursor:pointer" onclick="copy_row('+row_count+');" title="<cf_get_lang_main no="1560.Satır Kopyala">"><img src="images/copy_list.gif" border="0"></a><a href="javascript://" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="hidden" name="inventory_cat_id' + row_count +'" id="inventory_cat_id' + row_count +'" value="' + inventory_cat_id +'"><input type="text" style="width:125px;" name="inventory_cat' + row_count +'" id="inventory_cat' + row_count +'" value="' + inventory_cat +'" class="boxtext">'
							+' '+'<a href="javascript://" onClick="open_inventory_cat_list('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="invent_id' + row_count +'" id="invent_id' + row_count +'" value="' + invent_id +'"><input type="text" name="invent_no' + row_count +'" id="invent_no' + row_count +'" value="' + invent_no +'" style="width:100%;" class="boxtext" maxlength="50">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="invent_name' + row_count +'" id="invent_name' + row_count +'" value="' + invent_name +'" style="width:100%;" class="boxtext" maxlength="100">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="quantity' + row_count +'" id="quantity' + row_count +'" value="' + quantity +'" style="width:100%;" class="box" value="1" onBlur="hesapla(' + row_count +');" onkeyup="return(FormatCurrency(this,event));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="net_total' + row_count +'" id="net_total' + row_count +'" value="' + net_total +'"><input type="text" name="row_total' + row_count +'" id="row_total' + row_count +'" value="' + row_total +'" onkeyup="return(FormatCurrency(this,event));" onBlur="hesapla(' + row_count +');" style="width:100%;" class="box">';
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
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="kdv_total' + row_count +'" id="kdv_total' + row_count +'" value="' + kdv_total +'" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" onBlur="hesapla(' + row_count +',1);" class="box">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="row_other_total' + row_count +'" id="row_other_total' + row_count +'" value="' + row_other_total +'" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" readonly>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		b = '<select id="money_id' + row_count  +'" name="money_id' + row_count  +'" style="width:100%;" class="boxtext" onChange="hesapla('+ row_count +');">';
			<cfoutput query="get_money">
				if('#money#,#rate1#,#rate2#' == money_id)
					b += '<option value="#money#,#rate1#,#rate2#" selected>#money#</option>';
				else
					b += '<option value="#money#,#rate1#,#rate2#">#money#</option>';
			</cfoutput>
		newCell.innerHTML = b+ '</select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="inventory_duration' + row_count +'" name="inventory_duration' + row_count +'" value="' + inventory_duration +'" style="width:100%;" value="" class="box" onkeyup="return(FormatCurrency(this,event));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="amortization_rate' + row_count +'" name="amortization_rate' + row_count +'" value="' + amortization_rate +'" style="width:100%;" class="box" onblur="return(amortisman_kontrol(' + row_count +'));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="amortization_method'+ row_count +'" id="amortization_method'+ row_count +'" style="width:165px;" class="box"><option value="0"><cf_get_lang_main no='1624.Azalan Bakiye Üzerinden'></option><option value="1"><cf_get_lang_main no='1625.Sabit Miktar Üzeriden'></option><option value="2"><cf_get_lang_main no='1626.Hızlandırılmış Azalan Bakiye'></option><option value="3"><cf_get_lang_main no='1627.Hızlandırılmış Sabit Değer'></option></select>';
		if(amortization_method != '')
			document.getElementById('amortization_method'+ row_count).value = amortization_method;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select id="amortization_type'+ row_count +'" name="amortization_type'+ row_count +'" style="width:185px;" class="box"><option value="1">Kıst Amortismana Tabi</option><option value="2" selected>Kıst Amortismana Tabi Değil</option>></select>';
		if(amortization_type != '')
			document.getElementById('amortization_type'+ row_count).value = amortization_type;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="hidden" id="account_id' + row_count +'" name="account_id' + row_count +'" value="' + account_id +'"><input type="text" style="width:115px;" id="account_code' + row_count +'" name="account_code' + row_count +'" value="' + account_code +'" class="boxtext" onFocus="autocomp_account('+row_count+');"><a href="javascript://" onclick="pencere_ac_acc('+ row_count +');" ><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML ='<input type="hidden" name="expense_center_id' + row_count +'" value="'+expense_center_id+'" id="expense_center_id' + row_count +'"><input type="text" id="expense_center_name' + row_count +'" name="expense_center_name' + row_count +'" onFocus="exp_center('+row_count+');" value="'+expense_center_name+'" style="width:150px;" class="boxtext"><a href="javascript://" onClick="pencere_ac_exp_center('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input  type="hidden" id="expense_item_id' + row_count +'" name="expense_item_id' + row_count +'" value="' + expense_item_id +'"><input type="text" name="expense_item_name' + row_count +'" id="expense_item_name' + row_count +'" value="' + expense_item_name +'" onFocus="exp_item('+row_count+');" style="width:120px;" class="boxtext"> <a href="javascript://"><img src="/images/plus_thin.gif" onclick="pencere_ac_exp('+ row_count +');" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" id="period' + row_count +'" name="period' + row_count +'" value="' + period +'" style="width:100%;" class="box" onblur="return(period_kontrol(' + row_count +'));" onkeyup="return(FormatCurrency(this,event,0));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input  type="hidden" id="debt_account_id' + row_count +'" name="debt_account_id' + row_count +'" value="' + debt_account_id +'"><input type="text" name="debt_account_code' + row_count +'" id="debt_account_code' + row_count +'" value="' + debt_account_code +'" style="width:187px;" class="boxtext" onFocus="autocomp_debt_account('+row_count+');"><a href="javascript://" onclick="pencere_ac_acc2('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input  type="hidden" id="claim_account_id' + row_count +'" name="claim_account_id' + row_count +'" value="' + claim_account_id +'"><input type="text" name="claim_account_code' + row_count +'" id="claim_account_code' + row_count +'" value="' + claim_account_code +'" style="width:200px;" class="boxtext" onFocus="autocomp_claim_account('+row_count+');"><a href="javascript://" onclick="pencere_ac_acc1('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input  type="hidden" id="product_id' + row_count +'" name="product_id' + row_count +'" value="' + product_id +'"><input type="hidden" name="stock_id' + row_count +'" id="stock_id' + row_count +'" value="' + stock_id +'"><input type="text" style="width:113px;" id="product_name' + row_count +'" name="product_name' + row_count +'" value="' + product_name +'" class="boxtext">'
							+'<a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&product_id=add_invent_stock_fis.product_id" + row_count + "&field_id=add_invent_stock_fis.stock_id" + row_count + "&field_unit_name=add_invent_stock_fis.stock_unit" + row_count + "&field_main_unit=add_invent_stock_fis.stock_unit_id" + row_count + "&field_name=add_invent_stock_fis.product_name" + row_count + "','list');"+'"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" id="stock_unit_id' + row_count +'" name="stock_unit_id' + row_count +'" value="' + stock_unit_id +'"><input type="text" id="stock_unit' + row_count +'" name="stock_unit' + row_count +'" value="' + stock_unit +'" style="width:100%;" class="boxtext">';
	}
	function copy_row(no_info)
	{
		if (document.getElementById("inventory_cat_id" + no_info) == undefined) inventory_cat_id =""; else inventory_cat_id = document.getElementById("inventory_cat_id" + no_info).value;
		if (document.getElementById("inventory_cat" + no_info) == undefined) inventory_cat =""; else inventory_cat = document.getElementById("inventory_cat" + no_info).value;
		invent_id = "";
		if (document.getElementById("invent_no" + no_info) == undefined) invent_no =""; else invent_no = document.getElementById("invent_no" + no_info).value;
		if (document.getElementById("invent_name" + no_info) == undefined) invent_name =""; else invent_name = document.getElementById("invent_name" + no_info).value;
		if (document.getElementById("quantity" + no_info) == undefined) quantity =""; else quantity = document.getElementById("quantity" + no_info).value;
		if (document.getElementById("net_total" + no_info) == undefined) net_total =""; else net_total = document.getElementById("net_total" + no_info).value;
		if (document.getElementById("tax_rate" + no_info) == undefined) tax_rate =""; else tax_rate = document.getElementById("tax_rate" + no_info).value;
		if (document.getElementById("kdv_total" + no_info) == undefined) kdv_total =""; else kdv_total = document.getElementById("kdv_total" + no_info).value;
		if (document.getElementById("net_total" + no_info) == undefined) net_total =""; else net_total =  document.getElementById("net_total" + no_info).value;
		if (document.getElementById("row_total" + no_info) == undefined) row_total =""; else row_total =  document.getElementById("row_total" + no_info).value;
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
		
		add_row(inventory_cat_id,inventory_cat,invent_id,invent_no,invent_name,quantity,net_total,row_total,tax_rate,kdv_total,net_total,row_other_total,money_id,inventory_duration,amortization_rate,amortization_method,amortization_type,account_id,account_code,expense_center_id,expense_center_name,expense_item_id,expense_item_name,period,debt_account_id,debt_account_code,claim_account_id,claim_account_code,product_id,stock_id,product_name,stock_unit_id,stock_unit);
	}
	/* masraf merkezi popup */
	function pencere_ac_exp_center(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=add_invent_stock_fis.expense_center_id' + no +'&field_name=add_invent_stock_fis.expense_center_name' + no,'list');
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
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_invent_stock_fis.account_id' + no +'&field_name=add_invent_stock_fis.account_code' + no +'','list');
	}
	function pencere_ac_acc1(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_invent_stock_fis.claim_account_id' + no +'&field_name=add_invent_stock_fis.claim_account_code' + no +'','list');
	}
	function pencere_ac_acc2(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_invent_stock_fis.debt_account_id' + no +'&field_name=add_invent_stock_fis.debt_account_code' + no +'','list');
	}
	function pencere_ac_exp(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=add_invent_stock_fis.expense_item_id' + no +'&field_name=add_invent_stock_fis.expense_item_name' + no +'&field_account_no=add_invent_stock_fis.debt_account_code' + no +'&field_account_no2=add_invent_stock_fis.debt_account_id' + no +'','list');
	}
	function open_inventory_cat_list(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_inventory_cat&field_id=add_invent_stock_fis.inventory_cat_id' + no +'&field_name=add_invent_stock_fis.inventory_cat' + no +'&field_amortization_rate=add_invent_stock_fis.amortization_rate' + no +'&field_inventory_duration=add_invent_stock_fis.inventory_duration' + no +'','list');
	}
	function ayarla_gizle_goster()
	{
		if(add_invent_stock_fis.cash.checked)
			kasa_sec.style.display='';
		else
			kasa_sec.style.display='none';
	}
</script>
</cfif>

<cfif not IsDefined("attributes.event") or attributes.event eq 'add'>
	<cfif isdefined("attributes.project_id") and len(attributes.project_id)>
        <cfquery name="get_project_periods" datasource="#dsn3#">
            SELECT
                INVENTORY_CAT_ID,
                INVENTORY_CODE,
                AMORTIZATION_METHOD_ID,
                AMORTIZATION_TYPE_ID,
                AMORTIZATION_EXP_CENTER_ID,
                AMORTIZATION_EXP_ITEM_ID,
                AMORTIZATION_CODE,
                EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
                EXPENSE_ITEMS.ACCOUNT_CODE,
                EXPENSE_CENTER.*
            FROM 
                PROJECT_PERIOD
                LEFT JOIN #dsn_alias#.EXPENSE_ITEMS ON EXPENSE_ITEMS.EXPENSE_ITEM_ID = PROJECT_PERIOD.AMORTIZATION_EXP_ITEM_ID
                LEFT JOIN #dsn_alias#.EXPENSE_CENTER ON EXPENSE_CENTER.EXPENSE_ID = PROJECT_PERIOD.AMORTIZATION_EXP_CENTER_ID
            WHERE
                PROJECT_ID = #attributes.project_id#
                AND PERIOD_ID = #session.ep.period_id#
        </cfquery>
        <cfquery name="get_project_inf" datasource="#dsn#">
            SELECT 
                PROJECT_HEAD,
                PROJECT_NUMBER
            FROM
                PRO_PROJECTS
            WHERE
                PROJECT_ID = #attributes.project_id#
        </cfquery>
	</cfif>
		 <cfquery name="get_standart_process_money" datasource="#dsn#"><!--- muhasebe doneminden standart islem dövizini alıyor --->
            SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = #session.ep.period_id#
        </cfquery>
        <cfquery name="GET_ROWS" datasource="#dsn2#">
        SELECT
            (SELECT ISNULL(SUM(IA.AMORTIZATION_ID),0) FROM #dsn3_alias#.INVENTORY_AMORTIZATON IA WHERE IA.INVENTORY_ID = INVENTORY.INVENTORY_ID) AMORT_COUNT,
            SR.* ,
            INVENTORY.*,
            S.PRODUCT_ID,
            EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
            EXPENSE_ITEMS.ACCOUNT_CODE,
            EXPENSE_CENTER.*,
            P.PRODUCT_NAME
        FROM
            STOCK_FIS_ROW SR
            LEFT JOIN #dsn3_alias#.STOCKS S ON SR.STOCK_ID = S.STOCK_ID
            LEFT JOIN #dsn3_alias#.INVENTORY INVENTORY ON INVENTORY.INVENTORY_ID = SR.INVENTORY_ID
            LEFT JOIN #dsn_alias#.EXPENSE_ITEMS ON EXPENSE_ITEMS.EXPENSE_ITEM_ID = INVENTORY.EXPENSE_ITEM_ID
            LEFT JOIN #dsn_alias#.EXPENSE_CENTER ON EXPENSE_CENTER.EXPENSE_ID = INVENTORY.EXPENSE_CENTER_ID
            LEFT JOIN #dsn1_alias#.PRODUCT P ON P.PRODUCT_ID = S.PRODUCT_ID
        WHERE
            SR.FIS_ID = 0 
     </cfquery>
    <cfset GET_ROWS.recordcount = 0>
        <script type="text/javascript">
	function kontrol()
	{
		if (!chk_process_cat('add_invent_stock_fis')) return false;
		if(!check_display_files('add_invent_stock_fis')) return false;
		if(add_invent_stock_fis.department_id_2.value=="" || add_invent_stock_fis.department_name_2.value=="")
		{
			alert("<cf_get_lang_main no='1631.Çıkış Depo'>!");
			return false;
		}
		record_exist=0;//Row_kontrol değeri 1 olan yani silinmemiş satırların varlığını kontrol ediyor
		for(r=1;r<=add_invent_stock_fis.record_num.value;r++)
		{
			if(eval("document.add_invent_stock_fis.row_kontrol"+r).value == 1)
			{
				record_exist=1;
				if (eval("document.add_invent_stock_fis.invent_no"+r).value == "")
				{ 
					alert ("<cf_get_lang no='88.Lütfen Demirbaş No Giriniz'>!");
					return false;
				}
				if (eval("document.add_invent_stock_fis.invent_name"+r).value == "")
				{ 
					alert ("<cf_get_lang no='93.Lütfen Açıklama Giriniz'>!");
					return false;
				}
				if ((eval("document.add_invent_stock_fis.row_total"+r).value == "")||(eval("document.add_invent_stock_fis.row_total"+r).value ==0))
				{ 
					alert ("<cf_get_lang_main no='1738.Lütfen Tutar Giriniz '>!");
					return false;
				}
				if ((eval("document.add_invent_stock_fis.amortization_rate"+r).value == "")||(eval("document.add_invent_stock_fis.amortization_rate"+r).value < 0))
				{ 
					alert ("<cf_get_lang no='95.Lütfen Amortisman Oranı Giriniz'> !");
					return false;
				}
				if (eval("document.add_invent_stock_fis.account_code"+r).value == "")
				{ 
					alert ("<cf_get_lang no='96.Lütfen Muhasebe Kodu Seçiniz'>!");
					return false;
				}
				if(document.getElementById('is_related_project') == undefined)
				{
					if (eval("document.add_invent_stock_fis.product_id"+r).value == "" || eval("document.add_invent_stock_fis.stock_id"+r).value == "")
					{ 
						alert ("<cf_get_lang_main no='313.Lütfen Ürün Seçiniz'>!");
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
	function amortisman_kontrol(x)
	{
		deger_amortization_rate = eval("document.add_invent_stock_fis.amortization_rate"+x);
	
		if (filterNum(deger_amortization_rate.value) >100)
		{ 
			alert ("<cf_get_lang no ='231.Amortisman Oranı 100 den Büyük Olamaz'> !");
			deger_amortization_rate.value = 0;
			return false;
		}
		return true;
	}
	function period_kontrol(no)
	{
		deger = eval("document.add_invent_stock_fis.period"+no);
		if ((filterNum(deger.value) <1) || (deger.value==""))
		{ 
			alert ("<cf_get_lang no ='230.Hesaplama Dönemi 1 den Küçük Olamaz'>!");
			deger.value =1;
			return false;
		}
		return true;
	}
	function unformat_fields()
	{
		for(r=1;r<=add_invent_stock_fis.record_num.value;r++)
		{
			deger_total = eval("document.add_invent_stock_fis.row_total"+r);
			deger_kdv_total= eval("document.add_invent_stock_fis.kdv_total"+r);
			deger_net_total = eval("document.add_invent_stock_fis.net_total"+r);
			deger_other_net_total = eval("document.add_invent_stock_fis.row_other_total"+r);
			deger_amortization_rate = eval("document.add_invent_stock_fis.amortization_rate"+r);
			temp_inventory_duration= eval("document.add_invent_stock_fis.inventory_duration"+r);
			
			deger_total.value = filterNum(deger_total.value);
			deger_kdv_total.value = filterNum(deger_kdv_total.value);
			deger_net_total.value = filterNum(deger_net_total.value);
			deger_other_net_total.value = filterNum(deger_other_net_total.value);
			deger_amortization_rate.value = filterNum(deger_amortization_rate.value);
			temp_inventory_duration.value=filterNum(temp_inventory_duration.value);
		}
		document.add_invent_stock_fis.total_amount.value = filterNum(document.add_invent_stock_fis.total_amount.value);
		document.add_invent_stock_fis.kdv_total_amount.value = filterNum(document.add_invent_stock_fis.kdv_total_amount.value); 
		document.add_invent_stock_fis.net_total_amount.value = filterNum(document.add_invent_stock_fis.net_total_amount.value);
		document.add_invent_stock_fis.other_total_amount.value = filterNum(document.add_invent_stock_fis.other_total_amount.value);
		document.add_invent_stock_fis.other_kdv_total_amount.value = filterNum(document.add_invent_stock_fis.other_kdv_total_amount.value); 
		document.add_invent_stock_fis.other_net_total_amount.value = filterNum(document.add_invent_stock_fis.other_net_total_amount.value);
		for(s=1;s<=add_invent_stock_fis.kur_say.value;s++)
		{
			eval('add_invent_stock_fis.txt_rate2_' + s).value = filterNum(eval('add_invent_stock_fis.txt_rate2_' + s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			eval('add_invent_stock_fis.txt_rate1_' + s).value = filterNum(eval('add_invent_stock_fis.txt_rate1_' + s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
	}
	row_count=0;
	function sil(sy)
	{
		var my_element=eval("add_invent_stock_fis.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
		toplam_hesapla();
	}
	function hesapla(satir,hesap_type)
	{
		var toplam_dongu_0 = 0;//satir toplam
		if(eval("document.add_invent_stock_fis.row_kontrol"+satir).value==1)
		{
			deger_total = eval("document.add_invent_stock_fis.row_total"+satir);//tutar
			deger_miktar = eval("document.add_invent_stock_fis.quantity"+satir);//miktar
			deger_kdv_total= eval("document.add_invent_stock_fis.kdv_total"+satir);//kdv tutarı
			deger_net_total = eval("document.add_invent_stock_fis.net_total"+satir);//kdvli tutar
			deger_tax_rate = eval("document.add_invent_stock_fis.tax_rate"+satir);//kdv oranı
			deger_other_net_total = eval("document.add_invent_stock_fis.row_other_total"+satir);//dovizli tutar kdv dahil
			if(deger_total.value == "") deger_total.value = 0;
			if(deger_kdv_total.value == "") deger_kdv_total.value = 0;
			if(deger_net_total.value == "") deger_net_total.value = 0;
			deger_money_id = eval("document.add_invent_stock_fis.money_id"+satir);
			deger_money_id_ilk = list_getat(deger_money_id.value,2,',');
			deger_money_id_son = list_getat(deger_money_id.value,3,',');
			deger_total.value = filterNum(deger_total.value);
			deger_kdv_total.value = filterNum(deger_kdv_total.value);
			deger_net_total.value = filterNum(deger_net_total.value);
			deger_other_net_total.value = filterNum(deger_other_net_total.value);
			deger_miktar.value = filterNum(deger_miktar.value,0);
			if(hesap_type ==undefined)
			{
				deger_kdv_total.value = (parseFloat(deger_total.value) * deger_miktar.value * deger_tax_rate.value)/100;
			}else if(hesap_type == 2)
			{
				deger_total.value = ((parseFloat(deger_net_total.value)*100)/ (parseFloat(deger_tax_rate.value)+100))/deger_miktar.value;
				deger_kdv_total.value = (parseFloat(deger_total.value * deger_miktar.value * deger_tax_rate.value))/100;
			}
			toplam_dongu_0 = parseFloat(deger_total.value) + parseFloat(deger_kdv_total.value);
			deger_other_net_total.value = ((parseFloat(deger_total.value) + parseFloat(deger_kdv_total.value)) * parseFloat(deger_money_id_ilk) / (parseFloat(deger_money_id_son)));
			deger_net_total.value = commaSplit(toplam_dongu_0);
			deger_total.value = commaSplit(deger_total.value);
			deger_kdv_total.value = commaSplit(deger_kdv_total.value);
			deger_other_net_total.value = commaSplit(deger_other_net_total.value);
		}
			toplam_hesapla();
	}
	function toplam_hesapla()
	{
		var toplam_dongu_1 = 0;//tutar genel toplam
		var toplam_dongu_2 = 0;// kdv genel toplam
		var toplam_dongu_3 = 0;// kdvli genel toplam
		for(r=1;r<=add_invent_stock_fis.record_num.value;r++)
		{
			if(eval("document.add_invent_stock_fis.row_kontrol"+r).value==1)
			{
				deger_total = eval("document.add_invent_stock_fis.row_total"+r);//tutar
				deger_miktar = eval("document.add_invent_stock_fis.quantity"+r);//miktar
				deger_kdv_total= eval("document.add_invent_stock_fis.kdv_total"+r);//kdv tutarı
				deger_net_total = eval("document.add_invent_stock_fis.net_total"+r);//kdvli tutar
				deger_tax_rate = eval("document.add_invent_stock_fis.tax_rate"+r);//kdv oranı
				deger_other_net_total = eval("document.add_invent_stock_fis.row_other_total"+r);//dovizli tutar kdv dahil
				deger_money_id = eval("document.add_invent_stock_fis.money_id"+r);
				deger_money_id_ilk = list_getat(deger_money_id.value,1,',');
				for(s=1;s<=add_invent_stock_fis.kur_say.value;s++)
					{
						if(list_getat(document.add_invent_stock_fis.rd_money[s-1].value,1,',') == deger_money_id_ilk)
						{
							satir_rate2= eval("document.add_invent_stock_fis.txt_rate2_"+s).value;
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
		document.add_invent_stock_fis.total_amount.value = commaSplit(toplam_dongu_1);
		document.add_invent_stock_fis.kdv_total_amount.value = commaSplit(toplam_dongu_2);
		document.add_invent_stock_fis.net_total_amount.value = commaSplit(toplam_dongu_3);
		for(s=1;s<=add_invent_stock_fis.kur_say.value;s++)
		{
			form_txt_rate2_ = eval("document.add_invent_stock_fis.txt_rate2_"+s);
			if(form_txt_rate2_.value == "")
				form_txt_rate2_.value = 1;
		}
		if(add_invent_stock_fis.kur_say.value == 1)
			for(s=1;s<=add_invent_stock_fis.kur_say.value;s++)
			{
				if(document.add_invent_stock_fis.rd_money.checked == true)
				{
					deger_diger_para = document.add_invent_stock_fis.rd_money;
					form_txt_rate2_ = eval("document.add_invent_stock_fis.txt_rate2_"+s);
				}
			}
		else 
			for(s=1;s<=add_invent_stock_fis.kur_say.value;s++)
			{
				if(document.add_invent_stock_fis.rd_money[s-1].checked == true)
				{
					deger_diger_para = document.add_invent_stock_fis.rd_money[s-1];
					form_txt_rate2_ = eval("document.add_invent_stock_fis.txt_rate2_"+s);
				}
			}
		deger_money_id_1 = list_getat(deger_diger_para.value,1,',');
		deger_money_id_3 = list_getat(deger_diger_para.value,3,',');
		form_txt_rate2_.value = filterNum(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.add_invent_stock_fis.other_total_amount.value = commaSplit(toplam_dongu_1 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)));
		document.add_invent_stock_fis.other_kdv_total_amount.value = commaSplit(toplam_dongu_2 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)));
		document.add_invent_stock_fis.other_net_total_amount.value = commaSplit(toplam_dongu_3 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)));
	
		document.add_invent_stock_fis.tl_value1.value = deger_money_id_1;
		document.add_invent_stock_fis.tl_value2.value = deger_money_id_1;
		document.add_invent_stock_fis.tl_value3.value = deger_money_id_1;
		form_txt_rate2_.value = commaSplit(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	}
	
	function add_row(inventory_cat_id,inventory_cat,invent_no,invent_name,quantity,net_total,row_total,tax_rate,kdv_total,net_total,row_other_total,money_id,inventory_duration,amortization_rate,amortization_method,amortization_type,account_id,account_code,expense_center_id,expense_center_name,expense_item_id,expense_item_name,period,debt_account_id,debt_account_code,claim_account_id,claim_account_code,product_id,stock_id,product_name,stock_unit_id,stock_unit)
	{
		if (inventory_cat_id == undefined) inventory_cat_id ="";
		if (inventory_cat == undefined) inventory_cat ="";
		if (invent_no == undefined) invent_no ="";
		if (invent_name == undefined) invent_name ="";
		if (quantity == undefined) quantity = 1;
		if (net_total == undefined) net_total ="";
		if (tax_rate == undefined) tax_rate ="";
		if (kdv_total == undefined) kdv_total = 0;
		if (net_total == undefined) net_total = 0;
		if (row_total == undefined) row_total = 0;
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
		document.add_invent_stock_fis.record_num.value=row_count;
		newCell = newRow.insertCell();
		newCell.setAttribute("nowrap","nowrap");
		x = '<input  type="hidden" value="WRK'+row_count+ js_create_unique_id() + row_count+'" name="wrk_row_id' + row_count +'" id="wrk_row_id' + row_count +'"><input type="hidden" name="wrk_row_relation_id' + row_count +'" id="wrk_row_relation_id' + row_count +'" value="">';
		newCell.innerHTML = x + '<input type="hidden" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" value="1"><a style="cursor:pointer" onclick="copy_row('+row_count+');" title="<cf_get_lang_main no="1560.Satır Kopyala">"><img src="images/copy_list.gif" border="0"></a><a href="javascript://" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input  type="hidden" name="inventory_cat_id' + row_count +'" id="inventory_cat_id' + row_count +'" value="' + inventory_cat_id +'"><input type="text" style="width:125px;" name="inventory_cat' + row_count +'" id="inventory_cat' + row_count +'" value="' + inventory_cat +'" class="boxtext"><a href="javascript://"><a href="javascript://" onClick="open_inventory_cat_list('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="invent_no' + row_count +'" id="invent_no' + row_count +'" value="' + invent_no +'" style="width:100%;" class="boxtext" maxlength="50">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="invent_name' + row_count +'" id="invent_name' + row_count +'" value="' + invent_name +'" style="width:100px;" class="boxtext" maxlength="100">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="quantity' + row_count +'" id="quantity' + row_count +'" value="' + quantity +'" style="width:100%;" class="box" value="1" onBlur="hesapla(' + row_count +');" onkeyup="return(FormatCurrency(this,event));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="net_total' + row_count +'" id="net_total' + row_count +'" value="' + net_total +'"><input type="text" name="row_total' + row_count +'" id="row_total' + row_count +'" value="' + row_total +'" onkeyup="return(FormatCurrency(this,event));" onBlur="hesapla(' + row_count +');" style="width:100%;" class="box">';
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
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="kdv_total' + row_count +'" id="kdv_total' + row_count +'" value="' + kdv_total +'" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" onBlur="hesapla(' + row_count +',1);" class="box">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="row_other_total' + row_count +'" id="row_other_total' + row_count +'" value="' + row_other_total +'" onkeyup="return(FormatCurrency(this,event));" style="width:100%;" class="box" readonly>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		b = '<select id="money_id' + row_count  +'" name="money_id' + row_count  +'" style="width:100%;" class="boxtext" onChange="hesapla('+ row_count +');">';
			<cfoutput query="get_money">
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
		newCell.innerHTML = '<select name="amortization_method'+ row_count +'" id="amortization_method'+ row_count +'" style="width:165px;" class="box"><option value="0"><cf_get_lang_main no="1624.Azalan Bakiye Üzerinden"></option><option value="1"><cf_get_lang_main no="1625.Sabit Miktar Üzeriden"></option><option value="2"><cf_get_lang_main no="1626.Hızlandırılmış Azalan Bakiye"></option><option value="3"><cf_get_lang_main no="1627.Hızlandırılmış Sabit Değer"></option></select>';
		if(amortization_method != '')
			document.getElementById('amortization_method'+ row_count).value = amortization_method;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select id="amortization_type'+ row_count +'" name="amortization_type'+ row_count +'" style="width:185px;" class="box"><option value="1">Kıst Amortismana Tabi</option><option value="2" selected>Kıst Amortismana Tabi Değil</option>></select>';
		if(amortization_type != '')
			document.getElementById('amortization_type'+ row_count).value = amortization_type;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" id="account_id' + row_count +'" name="account_id' + row_count +'" value="' + account_id +'"><input type="text" id="account_code' + row_count +'" name="account_code' + row_count +'" value="' + account_code +'" class="boxtext" onFocus="autocomp_account('+row_count+');"><a href="javascript://" onclick="pencere_ac_acc('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML ='<input type="hidden" name="expense_center_id' + row_count +'" value="'+expense_center_id+'" id="expense_center_id' + row_count +'"><input type="text" id="expense_center_name' + row_count +'" name="expense_center_name' + row_count +'" onFocus="exp_center('+row_count+');" value="'+expense_center_name+'" style="width:150px;" class="boxtext"><a href="javascript://" onClick="pencere_ac_exp_center('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" id="expense_item_id' + row_count +'" name="expense_item_id' + row_count +'" value="' + expense_item_id +'"><input type="text" style="width:120px;" name="expense_item_name' + row_count +'" id="expense_item_name' + row_count +'" value="' + expense_item_name +'" class="boxtext" onFocus="exp_item('+row_count+');"><a href="javascript://"><img src="/images/plus_thin.gif" onclick="pencere_ac_exp('+ row_count +');" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="period' + row_count +'" name="period' + row_count +'" value="' + period +'" style="width:100%;" class="box" value="12" onblur="return(period_kontrol(' + row_count +'));" onkeyup="return(FormatCurrency(this,event,0));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input  type="hidden" id="debt_account_id' + row_count +'" name="debt_account_id' + row_count +'" value="' + debt_account_id +'"><input type="text" name="debt_account_code' + row_count +'" id="debt_account_code' + row_count +'" value="' + debt_account_code +'" style="width:190px;" class="boxtext" onFocus="autocomp_debt_account('+row_count+');"> <a href="javascript://" onClick="pencere_ac_acc2('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input  type="hidden" id="claim_account_id' + row_count +'" name="claim_account_id' + row_count +'" value="' + claim_account_id +'"><input type="text" name="claim_account_code' + row_count +'" id="claim_account_code' + row_count +'" value="' + claim_account_code +'" style="width:198px;" class="boxtext" onFocus="autocomp_claim_account('+row_count+');"><a href="javascript://" onClick="pencere_ac_acc1('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input  type="hidden" id="product_id' + row_count +'" name="product_id' + row_count +'" value="' + product_id +'"><input type="hidden" name="stock_id' + row_count +'" id="stock_id' + row_count +'" value="' + stock_id +'"><input type="text" id="product_name' + row_count +'" name="product_name' + row_count +'" value="' + product_name +'" class="boxtext">'
							+'<a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&product_id=add_invent_stock_fis.product_id" + row_count + "&field_id=add_invent_stock_fis.stock_id" + row_count + "&field_unit_name=add_invent_stock_fis.stock_unit" + row_count + "&field_main_unit=add_invent_stock_fis.stock_unit_id" + row_count + "&field_name=add_invent_stock_fis.product_name" + row_count + "','list');"+'"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>';
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
		if (document.getElementById("net_total" + no_info) == undefined) net_total =""; else net_total = document.getElementById("net_total" + no_info).value;
		if (document.getElementById("tax_rate" + no_info) == undefined) tax_rate =""; else tax_rate = document.getElementById("tax_rate" + no_info).value;
		if (document.getElementById("kdv_total" + no_info) == undefined) kdv_total =""; else kdv_total = document.getElementById("kdv_total" + no_info).value;
		if (document.getElementById("net_total" + no_info) == undefined) net_total =""; else net_total =  document.getElementById("net_total" + no_info).value;
		if (document.getElementById("row_total" + no_info) == undefined) row_total =""; else row_total =  document.getElementById("row_total" + no_info).value;
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
		
		add_row(inventory_cat_id,inventory_cat,invent_no,invent_name,quantity,net_total,row_total,tax_rate,kdv_total,net_total,row_other_total,money_id,inventory_duration,amortization_rate,amortization_method,amortization_type,account_id,account_code,expense_center_id,expense_center_name,expense_item_id,expense_item_name,period,debt_account_id,debt_account_code,claim_account_id,claim_account_code,product_id,stock_id,product_name,stock_unit_id,stock_unit);
	}
	/* masraf merkezi popup */
	function pencere_ac_exp_center(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=add_invent_stock_fis.expense_center_id' + no +'&field_name=add_invent_stock_fis.expense_center_name' + no,'list');
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
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_invent_stock_fis.account_id' + no +'&field_name=add_invent_stock_fis.account_code' + no +'','list');
	}
	function pencere_ac_acc1(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_invent_stock_fis.claim_account_id' + no +'&field_name=add_invent_stock_fis.claim_account_code' + no +'','list');
	}
	function pencere_ac_acc2(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_invent_stock_fis.debt_account_id' + no +'&field_name=add_invent_stock_fis.debt_account_code' + no +'','list');
	}
	function pencere_ac_exp(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=add_invent_stock_fis.expense_item_id' + no +'&field_name=add_invent_stock_fis.expense_item_name' + no +'&field_account_no=add_invent_stock_fis.debt_account_code' + no +'&field_account_no2=add_invent_stock_fis.debt_account_id' + no +'','list');
	}
	function open_inventory_cat_list(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_inventory_cat&field_id=add_invent_stock_fis.inventory_cat_id' + no +'&field_name=add_invent_stock_fis.inventory_cat' + no +'&field_amortization_rate=add_invent_stock_fis.amortization_rate' + no +'&field_inventory_duration=add_invent_stock_fis.inventory_duration' + no +'','list');
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
	<cfset attributes.related_invoice_id = get_fis_det.related_invoice_id >
	<cfif len(attributes.related_invoice_id)>
		<cfset attributes.related_invoice_number = get_invoice.invoice_number >
	</cfif>
	
</cfif>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'invent.add_invent_stock_fis';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'inventory/form/add_invent_stock_fis.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'inventory/query/add_invent_stock_fis.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'invent.add_invent_stock_fis&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('invent_stock_fis','invent_stock_fis_bask')";
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'invent.add_invent_stock_fis';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'inventory/form/add_invent_stock_fis.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'inventory/query/upd_invent_stock_fis.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'invent.add_invent_stock_fis&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'fis_id=##attributes.fis_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.fis_id##';
	WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('invent_stock_fis','invent_stock_fis_bask')";
	
	if(isdefined("attributes.event") and (attributes.event is 'upd' or attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'invent.add_invent_stock_fis&event=del&fis_id=#attributes.fis_id#&head=#get_fis_det.fis_number#&old_process_type=#get_fis_det.fis_type#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'inventory/query/del_invent_stock_fis.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'inventory/query/del_invent_stock_fis.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'invent.add_invent_stock_fis';
	}
	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1040]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.fis_id#&process_cat=add_invent_stock_fis.old_process_type.value','page','add_process')";
		if(session.ep.our_company_info.guaranty_followup)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[305]#-#lang_array_main.item[306]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=stock.list_serial_operations&is_filtre=1&belge_no=#get_fis_det.fis_number#&process_cat_id=#get_fis_det.fis_type#&process_id=#attributes.fis_id#','page','add_process')";
		}
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = 'Ekle';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=invent.add_invent_stock_fis";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
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
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'inventStockFis';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'STOCK_FIS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item1','item2','item4','item6','item7']"; 
</cfscript>
