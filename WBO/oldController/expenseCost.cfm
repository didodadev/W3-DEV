<cf_xml_page_edit fuseact="objects.expense_cost">
<cf_get_lang_set module_name="objects">
<cfset taksit = lang_array.item[115]>
<cfset erteleme = lang_array.item[362]>
<cfset belget = lang_array.item[813]>
<cfset odeme = lang_array.item[817]>
<cfparam name="attributes.expense_paymethod_id" default="" >
<cfparam name="attributes.expense_id" default="" >
<cfif fusebox.circuit eq "store">
	<cfset modulename = "store">
<cfelse>
	<cfset modulename = "objects">
</cfif>
<cfquery name="get_document_type" datasource="#dsn#">
SELECT
    SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID,
    SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_NAME
FROM
    SETUP_DOCUMENT_TYPE,
    SETUP_DOCUMENT_TYPE_ROW
WHERE
    SETUP_DOCUMENT_TYPE_ROW.DOCUMENT_TYPE_ID =  SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID AND
    SETUP_DOCUMENT_TYPE_ROW.FUSEACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#fuseaction#%">
ORDER BY
    DOCUMENT_TYPE_NAME
</cfquery>
<cfquery name="kasa" datasource="#dsn2#">
SELECT
    CASH_ID,
    CASH_CURRENCY_ID,
    CASH_NAME,
    BRANCH_ID		
FROM
    CASH
WHERE
    CASH_ACC_CODE IS NOT NULL AND 
    CASH_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
<cfif listgetat(attributes.fuseaction,1,'.') is 'store'>
    AND (BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">)
</cfif>
ORDER BY
    CASH_NAME
</cfquery>
<cfif not IsDefined("attributes.event") or (IsDefined("attributes.event") and attributes.event eq 'add')>
	<cfif is_default_employee eq 1>
        <cfparam name="attributes.expense_employee" default="#session.ep.name# #session.ep.surname#">
        <cfparam name="attributes.expense_employee_id" default="#session.ep.userid#">
    </cfif>
    <cfquery name="KONTROL" datasource="#DSN2#">
        SELECT * FROM BILLS
    </cfquery>
    <cfif not kontrol.recordcount>
        <font color="##FF0000">
            <a href="<cfoutput>#request.self#?fuseaction=account.bill_no</cfoutput>" class="tableyazi"><cf_get_lang_main no='1616.Lütfen Muhasebe Fiş numaralarını Düzenleyiniz'></a>
        </font>
        <cfabort>
    </cfif>
    <cfif isdefined("attributes.expense_id") and len(attributes.expense_id)><!--- Masraf kopyalama --->
        <cfquery name="get_money" datasource="#dsn2#">
            SELECT MONEY_TYPE AS MONEY,* FROM EXPENSE_ITEM_PLANS_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#"> ORDER BY MONEY
        </cfquery>
        <cfif not get_money.recordcount>
            <cfquery name="get_money" datasource="#dsn#">
                SELECT 0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> ORDER BY MONEY
            </cfquery>
        </cfif>
	<cfelseif isdefined("attributes.request_id") and len(attributes.request_id)><!--- Harcama Talebinden Donusturme --->
        <cfquery name="get_project" datasource="#dsn2#">
                SELECT PROJECT_ID FROM EXPENSE_ITEM_PLAN_REQUESTS WHERE EXPENSE_ID = #attributes.request_id#
        </cfquery>
        <cfquery name="get_money" datasource="#dsn2#">
            SELECT MONEY_TYPE AS MONEY,* FROM EXPENSE_ITEM_PLAN_REQUESTS_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.request_id#"> ORDER BY MONEY
        </cfquery>
        <cfif not get_money.recordcount>
            <cfquery name="get_money" datasource="#dsn#">
                SELECT 0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> ORDER BY MONEY
            </cfquery>
        </cfif>
    <cfelse>
        <cfquery name="get_money" datasource="#dsn2#">
            SELECT *,0 AS IS_SELECTED FROM SETUP_MONEY WHERE MONEY_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> ORDER BY MONEY
        </cfquery>
    </cfif>
    <cfif isdefined("attributes.expense_id") and len(attributes.expense_id)><!--- Masraf Kopyalama --->
        <cfquery name="get_expense" datasource="#dsn2#">
            SELECT
                PAPER_TYPE,
                DETAIL,
                SYSTEM_RELATION,
                CH_COMPANY_ID,
                CH_CONSUMER_ID,
                CH_EMPLOYEE_ID,
                CH_PARTNER_ID,
                ACC_TYPE_ID,
                DEPARTMENT_ID,
                LOCATION_ID,
                EXPENSE_CASH_ID,
                PAYMETHOD_ID,
                EXPENSE_DATE,
                DUE_DATE,
                EMP_ID,
                ACC_TYPE_ID_EXP,
                IS_CASH,
                IS_BANK,
                TEVKIFAT,
                TEVKIFAT_ORAN,
                TEVKIFAT_ID,
                BRANCH_ID,
                PROJECT_ID,
                ROUND_MONEY,
                IS_CREDITCARD,
                EXPENSE_ID,
                STOPAJ,
                ISNULL(STOPAJ_ORAN,0) STOPAJ_ORAN,
                ISNULL(STOPAJ_RATE_ID,0) STOPAJ_RATE_ID,
                ACC_DEPARTMENT_ID,
                TAX_CODE,
                SHIP_ADDRESS_ID,
                SHIP_ADDRESS
            FROM
                EXPENSE_ITEM_PLANS
            WHERE
                EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
        </cfquery>
    <cfelseif isdefined("attributes.request_id") and len(attributes.request_id)><!--- Harcama Talebinden Donusturme --->
        <cfquery name="get_expense" datasource="#dsn2#">
            SELECT
                PAPER_TYPE,
                DETAIL,
                ISNULL(SYSTEM_RELATION,PAPER_NO) SYSTEM_RELATION,
                SALES_COMPANY_ID CH_COMPANY_ID,
                SALES_CONSUMER_ID CH_CONSUMER_ID,
                '' CH_EMPLOYEE_ID,
                SALES_PARTNER_ID CH_PARTNER_ID,
                '' ACC_TYPE_ID,
                '' DEPARTMENT_ID,
                '' LOCATION_ID,
                EXPENSE_CASH_ID,
                PAYMETHOD_ID,
                EXPENSE_DATE,
                DUE_DATE,
                EMP_ID,
                ACC_TYPE_ID ACC_TYPE_ID_EXP,
                IS_CASH,
                IS_BANK,
                '' TEVKIFAT,
                '' TEVKIFAT_ORAN,
                '' TEVKIFAT_ID,
                BRANCH_ID,
                0 ROUND_MONEY,
                0 IS_CREDITCARD,
                '' EXPENSE_ID,
                0 STOPAJ,
                0 STOPAJ_ORAN,
                0 STOPAJ_RATE_ID,
                '' ACC_DEPARTMENT_ID,
                '' TAX_CODE,
                ''SHIP_ADDRESS_ID,
                ''SHIP_ADDRESS
            FROM
                EXPENSE_ITEM_PLAN_REQUESTS
            WHERE
                EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.request_id#">
        </cfquery>
    </cfif>
    <cfif isdefined("GET_EXPENSE") and GET_EXPENSE.RECORDCOUNT eq 0>
        <script type="text/javascript">
            alert("<cf_get_lang no='1872.Masraf Fişi Yok veya Silinmiş'>");
            history.go(-1);
        </script>
        <cfabort>
    </cfif>
    <cfif isdefined("attributes.credit_contract_id") and len(attributes.credit_contract_id)>
        <cfquery name="get_credit" datasource="#dsn3#">
            SELECT COMPANY_ID,PARTNER_ID FROM CREDIT_CONTRACT WHERE CREDIT_CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.credit_contract_id#">
        </cfquery>
       <cfquery name="get_project" datasource="#dsn3#">
            SELECT PROJECT_ID FROM CREDIT_CONTRACT WHERE CREDIT_CONTRACT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.credit_contract_id#">
        </cfquery>
    </cfif>
    <cfif isdefined("get_expense")>
        <cfset expense_bank_id = get_expense.expense_cash_id>
        <cfset expense_branch_id = get_expense.branch_id>
        <cfset expense_paymethod_id = get_expense.paymethod_id>
        <cfset expense_due_date = get_expense.due_date>
    <cfelse>
        <cfset expense_bank_id = ''>
        <cfset expense_branch_id = ''>
        <cfset expense_paymethod_id = ''>
        <cfset expense_due_date = ''>
    </cfif>
    <cf_papers paper_type="expense_cost">
    <cfset invoice_date = now()>
    <cfif isdefined("attributes.receiving_detail_id")>
        <!--- Gelen e-fatura sayfasindaki xml degerleri aliniyor. --->
        <cf_xml_page_edit fuseact="objects.popup_dsp_efatura_detail">
        <cfquery name="GET_INV_DET" datasource="#DSN2#">
            SELECT ISSUE_DATE,EINVOICE_ID FROM EINVOICE_RECEIVING_DETAIL WHERE RECEIVING_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.receiving_detail_id#">
        </cfquery>
        <cfif isdefined("attributes.company_id") and len(attributes.company_id)>
            <cfquery name="GET_PAYMETHOD" datasource="#DSN#">
                SELECT PAYMETHOD_ID FROM COMPANY_CREDIT WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.COMPANY_ID#">
            </cfquery>
            <cfset expense_paymethod_id = get_paymethod.paymethod_id>
        </cfif>
        <cfif get_inv_det.recordcount>
            <cfset invoice_date = get_inv_det.issue_date>
            <cfif xml_separate_serial_number>
                <cfset paper_number = right(get_inv_det.einvoice_id,13)>
                <cfset paper_code = left(get_inv_det.einvoice_id,3)>
            <cfelse>
                <cfset paper_number = get_inv_det.einvoice_id>
                <cfset paper_code = ''>            
            </cfif>          
            <script type="text/javascript">
                try{
                    window.onload = function () { change_money_info('add_costplan','expense_date');}
                }
                catch(e){}
            </script>
        </cfif>
    </cfif>
    <cfif len(expense_paymethod_id)>
        <cfquery name="get_pay_meyhod" datasource="#dsn#">
            SELECT PAYMETHOD,DUE_DAY FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#expense_paymethod_id#">
        </cfquery>
        <cfif isdefined("attributes.receiving_detail_id")>
            <cfset expense_due_date = get_pay_meyhod.DUE_DAY>
        </cfif>
    </cfif>
    <cfquery name="get_standart_process_money" datasource="#dsn#"><!--- muhasebe doneminden standart islem dövizini alıyor --->
        SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
    </cfquery>
    <script type="text/javascript">
		$( document ).ready(function() {
			row_count_ilk = row_count;
			for(yy=1;yy<=document.getElementById("record_num").value;yy++)
			{	
				if(document.getElementById("row_kontrol"+yy).value==1)
				{
					other_calc(yy,1);
				}
			}
			toplam_hesapla();
			document.getElementById('expense_cost_file').style.marginLeft=screen.width-360;
		});
		function open_file()
		{
			document.getElementById("expense_cost_file").style.display='';
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.popup_add_expense_cost_file<cfif isdefined("attributes.expense_id")>&expense_id=#attributes.expense_id#</cfif></cfoutput>','expense_cost_file',1);
			return false;
		}
		<cfoutput>
			function hesapla(field_name,satir,hesap_type,extra_type)
			{
				if(field_name != '' && field_name != 'product_id' && field_name != 'product_name')
				{
					var input_name_ = field_name+satir;
					field_changed_value = filterNum(document.getElementById(input_name_).value,'#xml_satir_number#');
				}
				else
					field_changed_value = '-1';
				if(field_changed_value == '-1' || document.getElementById("control_field_value") == undefined || (document.getElementById("control_field_value") != undefined && field_changed_value != document.getElementById("control_field_value").value))
				{
					var toplam_dongu_0 = 0;//satir toplam
					if(document.getElementById("row_kontrol"+satir).value==1)
					{
						if(document.getElementById("total"+satir) != undefined) deger_total = document.getElementById("total"+satir); else deger_total="";//tutar
						if(document.getElementById("quantity"+satir) != undefined) deger_quantity = document.getElementById("quantity"+satir); else deger_quantity="";//miktar
						if(document.getElementById("kdv_total"+satir) != undefined) deger_kdv_total= document.getElementById("kdv_total"+satir); else deger_kdv_total="";//kdv tutarı
						if(document.getElementById("otv_total"+satir) != undefined) deger_otv_total= document.getElementById("otv_total"+satir); else deger_otv_total="";//ötv tutarı
						if(document.getElementById("net_total"+satir) != undefined) deger_net_total = document.getElementById("net_total"+satir); else deger_net_total="";//kdvli tutar
						if(document.getElementById("tax_rate"+satir) != undefined) deger_tax_rate = document.getElementById("tax_rate"+satir); else deger_tax_rate="";//kdv oranı
						if(document.getElementById("otv_rate"+satir) != undefined) deger_otv_rate = document.getElementById("otv_rate"+satir); else deger_otv_rate="";//ötv oranı
						if(document.getElementById("other_net_total"+satir) != undefined) deger_other_net_total = document.getElementById("other_net_total"+satir); else deger_other_net_total="";//dovizli tutar kdv dahil
						if(document.getElementById("other_net_total_kdvsiz"+satir) != undefined) deger_other_net_total_kdvsiz = document.getElementById("other_net_total_kdvsiz"+satir); else deger_other_net_total_kdvsiz="";//dovizli tutar kdv hariç
						
						if(document.getElementById("money_id"+satir) != undefined)
						{
							deger_money_id = document.getElementById("money_id"+satir);
							deger_money_id =  list_getat(deger_money_id.value,1,',');
							for(s=1; s<=document.getElementById("kur_say").value; s++)
							{
								if(document.getElementById("kur_say").value == 1)
									money_deger =list_getat(document.all.rd_money.value,1,',');
								else
									money_deger =list_getat(document.all.rd_money[s-1].value,1,',');
								if(money_deger == deger_money_id)
								{
									if(document.getElementById("kur_say").value == 1)
										deger_diger_para_satir = document.all.rd_money;
									else	
										deger_diger_para_satir = document.all.rd_money[s-1];
									form_value_rate_satir = document.getElementById("txt_rate2_"+s);
								}
							}
							deger_para_satir = list_getat(deger_diger_para_satir.value,3,',');
						}
						else
						{
							deger_money_id="";
							deger_para_satir="";
							form_value_rate_satir="";
						}
						if(deger_total != "") deger_total.value = filterNum(deger_total.value,'#xml_satir_number#');
						if(deger_quantity != "") deger_quantity.value = filterNum(deger_quantity.value,'#xml_satir_number#'); else deger_quantity.value = 1;
						if(deger_kdv_total != "") deger_kdv_total.value = filterNum(deger_kdv_total.value,'#xml_satir_number#');
						if(deger_otv_total != "") deger_otv_total.value = filterNum(deger_otv_total.value,'#xml_satir_number#');
						if(deger_net_total != "") deger_net_total.value = filterNum(deger_net_total.value,'#xml_satir_number#');
						if(deger_other_net_total != "") deger_other_net_total.value = filterNum(deger_other_net_total.value,'#xml_satir_number#');
						if(deger_other_net_total_kdvsiz != "") deger_other_net_total_kdvsiz.value = filterNum(deger_other_net_total_kdvsiz.value,'#xml_satir_number#');
						
						if(hesap_type == undefined)
						{
							if(deger_otv_total != "" && deger_total != "") 
							{
								if(deger_otv_rate.value == undefined)
									deger_otv_total.value = (parseFloat(deger_total.value * deger_quantity.value * 0))/100;
								else
									deger_otv_total.value = (parseFloat(deger_total.value * deger_quantity.value * deger_otv_rate.value))/100;	
							}
							<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>  
								if(deger_kdv_total != "" && deger_total != "") 
								{
									if(deger_tax_rate.value == undefined)
										deger_kdv_total.value = ((parseFloat(deger_total.value) * parseFloat(deger_quantity.value)) * 0)/100;
									else
										deger_kdv_total.value = ((parseFloat(deger_total.value) * parseFloat(deger_quantity.value)) * deger_tax_rate.value)/100;
								}
							<cfelse>
								if(deger_kdv_total != "" && deger_total != "") 
								{
									if(deger_tax_rate.value == undefined)
										deger_kdv_total.value = ((parseFloat(deger_total.value * deger_quantity.value)+parseFloat(deger_otv_total.value)) * 0)/100;
									else
										deger_kdv_total.value = ((parseFloat(deger_total.value * deger_quantity.value)+parseFloat(deger_otv_total.value)) * deger_tax_rate.value)/100;	
								}
							</cfif>
						}
						else if(hesap_type == 2)
						{
							if(deger_otv_rate.value == undefined)
								otv_rate_ = 0;
							else 
								otv_rate_ = deger_otv_rate.value;
						
							if(deger_tax_rate != undefined && deger_tax_rate.value == '')
								tax_rate_ = 0;
							else
								tax_rate_ = deger_tax_rate.value;
								
							<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>  
								if(deger_total != "" && deger_tax_rate != "") deger_total.value = ((parseFloat(deger_net_total.value)/parseFloat(deger_quantity.value))*100)/ (parseFloat(tax_rate_)+parseFloat(otv_rate_)+100);
								if(deger_kdv_total != "" && deger_total != "") 
								{
									if(deger_tax_rate.value == undefined)
										deger_kdv_total.value = (parseFloat(deger_total.value * deger_quantity.value * 0))/100;
									else
										deger_kdv_total.value = (parseFloat(deger_total.value * deger_quantity.value * deger_tax_rate.value))/100;
								}
								if(deger_otv_total != "" && deger_total != "") 
								{
									if(deger_otv_rate.value == undefined)
										deger_otv_total.value = (parseFloat(deger_total.value * deger_quantity.value * 0))/100;
									else
										deger_otv_total.value = (parseFloat(deger_total.value * deger_quantity.value * deger_otv_rate.value))/100;
								}
							<cfelse>
								if(deger_total != "" && deger_tax_rate != "") 
									deger_total.value = ((parseFloat(deger_net_total.value)/parseFloat(deger_quantity.value))/((parseFloat(tax_rate_)+100)/100))/((parseFloat(otv_rate_)+100)/100);
								if(deger_otv_total != "" && deger_total != "") 
								{
									if(deger_otv_rate.value == undefined)
										deger_otv_total.value = (parseFloat(deger_total.value * deger_quantity.value *0))/100;
									else
										deger_otv_total.value = (parseFloat(deger_total.value * deger_quantity.value * deger_otv_rate.value))/100;
								}
								if(deger_kdv_total != "" && deger_total != "") 
								{
									if(deger_tax_rate.value == undefined)
										deger_kdv_total.value = ((parseFloat(deger_total.value * deger_quantity.value)+parseFloat(deger_otv_total.value)) * 0)/100;
									else
										deger_kdv_total.value = ((parseFloat(deger_total.value * deger_quantity.value)+parseFloat(deger_otv_total.value)) * deger_tax_rate.value)/100;
								}
							</cfif>
						}
						toplam_dongu_0 = parseFloat(deger_total.value * deger_quantity.value);
						if(deger_kdv_total != "") toplam_dongu_0 = toplam_dongu_0 + parseFloat(deger_kdv_total.value);
						if(deger_otv_total != "") toplam_dongu_0 = toplam_dongu_0 + parseFloat(deger_otv_total.value);
						if(extra_type != 2)
							if(deger_other_net_total != "") deger_other_net_total.value = ((toplam_dongu_0) * parseFloat(deger_para_satir) / (parseFloat(form_value_rate_satir.value)));
						if(deger_net_total != "") deger_net_total.value = commaSplit(toplam_dongu_0,'#xml_satir_number#');
						if(deger_total != "") deger_total.value = commaSplit(deger_total.value,'#xml_satir_number#');
						if(deger_quantity != "") deger_quantity.value = commaSplit(deger_quantity.value,'#xml_satir_number#');
						if(deger_kdv_total != "") deger_kdv_total.value = commaSplit(deger_kdv_total.value,'#xml_satir_number#');
						if(deger_otv_total != "") deger_otv_total.value = commaSplit(deger_otv_total.value,'#xml_satir_number#');
						if(deger_other_net_total != "") deger_other_net_total.value = commaSplit(deger_other_net_total.value,'#xml_satir_number#');
						if(deger_other_net_total_kdvsiz != "") deger_other_net_total_kdvsiz.value = commaSplit(deger_other_net_total_kdvsiz.value,'#xml_satir_number#');
					}
					<cfif fuseaction contains "assetcare"> <!--- sadece assetcare modulunde spec secilebildigi icin eklendi --->
						delete_spec(satir);
					</cfif>
					if(extra_type == 2 || extra_type == undefined)
						toplam_hesapla(extra_type);
				}
			}
			function toplam_hesapla(type)
			{
				var toplam_dongu_1 = 0;//tutar genel toplam
				var toplam_dongu_2 = 0;// kdv genel toplam
				var toplam_dongu_3 = 0;// kdvli genel toplam
				var toplam_dongu_4 = 0;// ötv genel toplam
				if(document.getElementById("expense_cost_type").value != 122)
				{
					var beyan_tutar = 0;
					var tevkifat_info = "";
					var beyan_tutar_info = "";
					var new_taxArray = new Array(0);
					var taxBeyanArray = new Array(0);
					var taxTevkifatArray = new Array(0);
				}
				if(type != 2)
					doviz_hesapla();
				for(r=1;r<=document.getElementById("record_num").value;r++)
				{
					if(document.getElementById("row_kontrol"+r).value==1)
					{
						if(document.getElementById("total"+r) != undefined) deger_total = document.getElementById("total"+r); else deger_total="";//tutar
						if(document.getElementById("quantity"+r) != undefined) deger_quantity = document.getElementById("quantity"+r); else deger_quantity="";//miktar
						if(document.getElementById("kdv_total"+r) != undefined) deger_kdv_total= document.getElementById("kdv_total"+r); else deger_kdv_total="";//kdv tutarı
						if(document.getElementById("otv_total"+r) != undefined) deger_otv_total= document.getElementById("otv_total"+r); else deger_otv_total="";//ötv tutarı
						if(document.getElementById("net_total"+r) != undefined) deger_net_total = document.getElementById("net_total"+r); else deger_net_total="";//kdvli tutar
						if(document.getElementById("tax_rate"+r) != undefined) deger_tax_rate = document.getElementById("tax_rate"+r); else deger_tax_rate="";//kdv oranı
						if(document.getElementById("otv_rate"+r) != undefined) deger_otv_rate = document.getElementById("otv_rate"+r); else deger_otv_rate="";//ötv oranı
						if(document.getElementById("other_net_total"+r) != undefined) deger_other_net_total = document.getElementById("other_net_total"+r); else deger_other_net_total="";//dovizli tutar kdv dahil
						if(document.getElementById("other_net_total_kdvsiz"+r) != undefined) deger_other_net_total_kdvsiz = document.getElementById("other_net_total_kdvsiz"+r); else deger_other_net_total_kdvsiz="";//dovizli tutar kdv hariç
					
						if(deger_total != "") deger_total.value = filterNum(deger_total.value,'#xml_satir_number#');
						if(deger_quantity != "") deger_quantity.value = filterNum(deger_quantity.value,'#xml_satir_number#');
						if(deger_kdv_total != "") deger_kdv_total.value = filterNum(deger_kdv_total.value,'#xml_satir_number#');
						
						if(document.getElementById("tax_rate"+r) != undefined && document.getElementById("kdv_total"+r) != undefined)
						{
							if(document.getElementById("tevkifat_oran") != undefined && document.getElementById("tevkifat_oran").value != "" && document.getElementById("tevkifat_box").checked == true && document.getElementById("expense_cost_type").value != 122)
							{//tevkifat hesaplamaları
								
								beyan_tutar = beyan_tutar + wrk_round(deger_kdv_total.value*filterNum(document.getElementById("tevkifat_oran").value,8));
								if(new_taxArray.length != 0)
									for (var m=0; m < new_taxArray.length; m++)
									{	
										var tax_flag = false;
										if(new_taxArray[m] == deger_tax_rate.value){
											tax_flag = true;
											taxBeyanArray[m] += wrk_round(deger_kdv_total.value - (deger_kdv_total.value*(filterNum(document.getElementById("tevkifat_oran").value,8))));
											taxTevkifatArray[m] += wrk_round(deger_kdv_total.value*(filterNum(document.getElementById("tevkifat_oran").value,8)));
											break;
										}
									}
								if(!tax_flag){
									new_taxArray[new_taxArray.length] = deger_tax_rate.value;
									taxBeyanArray[taxBeyanArray.length] = wrk_round(deger_kdv_total.value - (deger_kdv_total.value*(filterNum(document.getElementById("tevkifat_oran").value,8))));
									taxTevkifatArray[taxTevkifatArray.length] = wrk_round(deger_kdv_total.value*(filterNum(document.getElementById("tevkifat_oran").value,8)));
								}
							}
						}
						if(deger_otv_total != "") deger_otv_total.value = filterNum(deger_otv_total.value,'#xml_satir_number#');
						if(deger_net_total != "") deger_net_total.value = filterNum(deger_net_total.value,'#xml_satir_number#');
						if(deger_total != "") toplam_dongu_1 = toplam_dongu_1 + parseFloat(deger_total.value * deger_quantity.value);
						if(deger_kdv_total != "") toplam_dongu_2 = toplam_dongu_2 + parseFloat(deger_kdv_total.value);
						if(deger_otv_total != "") toplam_dongu_4 = toplam_dongu_4 + parseFloat(deger_otv_total.value);
						if(deger_total != "") toplam_dongu_3 = toplam_dongu_3 + (parseFloat(deger_total.value * deger_quantity.value));
						if(deger_kdv_total != "") toplam_dongu_3 = toplam_dongu_3 + parseFloat(deger_kdv_total.value);
						if(deger_otv_total != "") toplam_dongu_3 = toplam_dongu_3 + parseFloat(deger_otv_total.value);
						if(deger_net_total != "") deger_net_total.value = commaSplit(deger_net_total.value,'#xml_satir_number#');
						if(deger_total != "") deger_total.value = commaSplit(deger_total.value,'#xml_satir_number#');
						if(deger_quantity != "") deger_quantity.value = commaSplit(deger_quantity.value,'#xml_satir_number#');
						if(deger_kdv_total != "") deger_kdv_total.value = commaSplit(deger_kdv_total.value,'#xml_satir_number#');
						if(deger_otv_total != "") deger_otv_total.value = commaSplit(deger_otv_total.value,'#xml_satir_number#');
						<cfif ListFind(ListDeleteDuplicates(xml_order_list_rows),6)>
						if(document.getElementById("product_id"+r) != undefined && document.getElementById("product_id"+r) != '')
								view_product_info(r);
						</cfif>
					}
				}
				if(document.getElementById("tevkifat_oran") != undefined && document.getElementById("tevkifat_oran").value != "" && document.getElementById("tevkifat_box").checked == true && document.getElementById("expense_cost_type").value != 122)
				{//tevkifat hesaplamaları
					toplam_dongu_3 = toplam_dongu_3 - toplam_dongu_2 + beyan_tutar;
					toplam_dongu_2 = beyan_tutar;
					tevkifat_text.style.fontWeight = 'bold';
					tevkifat_text.innerHTML = '';
					beyan_text.style.fontWeight = 'bold';
					beyan_text.innerHTML = '';
					for (var tt=0; tt < new_taxArray.length; tt++)
					{
						tevkifat_text.innerHTML += '% ' + new_taxArray[tt] + ' : ' + commaSplit(taxBeyanArray[tt],'#xml_genel_number#') + ' ';
						beyan_text.innerHTML += '% ' + new_taxArray[tt] + ' : ' + commaSplit(taxTevkifatArray[tt],'#xml_genel_number#') + ' ';
					}
				}
				if(type == undefined || parseFloat(document.getElementById("stopaj_yuzde").value) == 0)
					stopaj_ = wrk_round((toplam_dongu_1 * parseFloat(document.getElementById("stopaj_yuzde").value) / 100),'#xml_genel_number#');
				else
					stopaj_ = filterNum(document.getElementById("stopaj").value);
				document.getElementById("stopaj_yuzde").value = commaSplit(parseFloat(document.getElementById("stopaj_yuzde").value));
				document.getElementById("stopaj").value = commaSplit(stopaj_,'#xml_genel_number#');
				if(document.getElementById("yuvarlama").value != '')
				{
					toplam_dongu_3 = toplam_dongu_3 + parseFloat(filterNum(document.getElementById("yuvarlama").value,'#xml_genel_number#'));
					document.getElementById("yuvarlama").value = commaSplit(filterNum(document.getElementById("yuvarlama").value),'#xml_genel_number#');
				}
				toplam_dongu_3 = toplam_dongu_3-parseFloat(stopaj_);
				document.getElementById("total_amount").value = commaSplit(toplam_dongu_1,'#xml_genel_number#');
				document.getElementById("kdv_total_amount").value = commaSplit(toplam_dongu_2,'#xml_genel_number#');
				document.getElementById("otv_total_amount").value = commaSplit(toplam_dongu_4,'#xml_genel_number#');
				document.getElementById("net_total_amount").value = commaSplit(toplam_dongu_3,'#xml_genel_number#');
				for(s=1;s<=document.getElementById("kur_say").value;s++)
				{
					form_txt_rate2_ = document.getElementById("txt_rate2_"+s);
					if(form_txt_rate2_.value == "")
						form_txt_rate2_.value = 1;
				}
				if(document.getElementById("kur_say").value == 1)
					for(s=1;s<=document.getElementById("kur_say").value;s++)
					{
						if(document.add_costplan.rd_money.checked == true)
						{
							deger_diger_para = document.getElementById("rd_money");
							form_txt_rate2_ = document.getElementById("txt_rate2_"+s);
						}
					}
				else 
					for(s=1;s<=document.getElementById("kur_say").value;s++)
					{
						if(document.add_costplan.rd_money[s-1].checked == true)
						{
							deger_diger_para = document.add_costplan.rd_money[s-1];
							form_txt_rate2_ = document.getElementById("txt_rate2_"+s);
						}
					}
				deger_money_id_1 = list_getat(deger_diger_para.value,1,',');
				deger_money_id_2 = list_getat(deger_diger_para.value,2,',');
				deger_money_id_3 = list_getat(deger_diger_para.value,3,',');
				//form_txt_rate2_.value = filterNum(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#');
				document.getElementById("other_total_amount").value = commaSplit(toplam_dongu_1 * parseFloat(deger_money_id_3) / (parseFloat(filterNum(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#'),'#session.ep.our_company_info.rate_round_num#')),'#xml_genel_number#');
				document.getElementById("other_kdv_total_amount").value = commaSplit(toplam_dongu_2 * parseFloat(deger_money_id_3) / (parseFloat(filterNum(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#'),'#session.ep.our_company_info.rate_round_num#')),'#xml_genel_number#');
				document.getElementById("other_otv_total_amount").value = commaSplit(toplam_dongu_4 * parseFloat(deger_money_id_3) / (parseFloat(filterNum(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#'),'#session.ep.our_company_info.rate_round_num#')),'#xml_genel_number#');
				document.getElementById("other_net_total_amount").value = commaSplit(toplam_dongu_3 * parseFloat(deger_money_id_3) / (parseFloat(filterNum(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#'),'#session.ep.our_company_info.rate_round_num#')),'#xml_genel_number#');
			
				document.getElementById("tl_value1").value = deger_money_id_1;
				document.getElementById("tl_value2").value = deger_money_id_1;
				document.getElementById("tl_value3").value = deger_money_id_1;
				document.getElementById("tl_value4").value = deger_money_id_1;
				//form_txt_rate2_.value = commaSplit(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#');
			}
			function doviz_hesapla(type)
			{
				for(k=1;k<=document.getElementById("record_num").value;k++)
				{		
					if(document.getElementById("money_id"+k) != undefined)
					{
						deger_money_id = document.getElementById("money_id"+k);
						deger_money_id =  list_getat(deger_money_id.value,1,',');
						for (var t=1; t<=document.getElementById("kur_say").value; t++)
						{
							money_deger =list_getat(document.add_costplan.rd_money[t-1].value,1,',');
							if(money_deger == deger_money_id)	
							{
								rate2_value = filterNum(document.getElementById("txt_rate2_"+t).value,'#session.ep.our_company_info.rate_round_num#')/filterNum(document.getElementById("txt_rate1_"+t).value,'#session.ep.our_company_info.rate_round_num#');
								document.getElementById("other_net_total"+k).value = commaSplit(filterNum(document.getElementById("net_total"+k).value,'#xml_satir_number#')/rate2_value,'#xml_satir_number#');
								document.getElementById("other_net_total_kdvsiz"+k).value = commaSplit(filterNum(document.getElementById("total"+k).value,'#xml_satir_number#')/rate2_value,'#xml_satir_number#');
							}
						}
					}
				}
			}
			function kontrol()
			{  debugger;
				<cfif xml_upd_row_project eq 1>
					for(i=1; i<row_count+1; i++){
						if(document.getElementById("project_id"+i).value == "" || document.getElementById("project"+i).value == "")
						{
							document.getElementById("project_id"+i).value = document.getElementById("project_id").value;
							document.getElementById("project"+i).value = document.getElementById("project_head").value;
						<cfif xml_upd_row_expense_center eq 1>
							if(document.getElementById("project_id"+i).value != "" || document.getElementById("project"+i).value != "")
							{
								var xxx = document.getElementById("project_id"+i).value;
								var get_expense_center = wrk_safe_query('obj_get_project_related_expense','dsn2',0,xxx);
								document.getElementById("expense_center_id"+i).value = get_expense_center.EXPENSE_ID;
								document.getElementById("expense_center_name"+i).value = get_expense_center.EXPENSE;
							}
						</cfif>
						}
					}
				</cfif>
				var beyan_tutar = 0;
				var tevkifat_info = "";
				var beyan_tutar_info = "";
				var new_taxArray = new Array(0);
				var taxBeyanArray = new Array(0);
				var taxTevkifatArray = new Array(0);
				if(document.getElementById("ch_member_type").value == 'partner')
				{
					var ch_comp_id = document.getElementById("ch_company_id").value;
					var ch_cons_id = '';
				}
				else if(document.getElementById("ch_member_type").value == 'consumer')
				{
					var ch_comp_id = '';
					var ch_cons_id = document.getElementById("ch_partner_id").value;
				}
				 
				if(!chk_period(document.getElementById("expense_date"),"İşlem")) return false;
				if(!chk_process_cat('add_costplan')) return false;
				if(!check_display_files('add_costplan')) return false;
				<cfif isdefined('xml_acc_department_info') and xml_acc_department_info eq 2> //xmlde muhasebe icin departman secimi zorunlu ise
					if(document.getElementById("acc_department_id").options[document.getElementById("acc_department_id").selectedIndex].value=='')
					{
						alert('Departman Seçiniz');
						return false;
					} 
				</cfif>
				<cfif isdefined('x_select_project') and x_select_project eq 2> //xmlde muhasebe icin proje secimi zorunlu ise
					if(document.getElementById("project_head").value=='' || document.getElementById("project_id").value=='')
					{
						alert('Proje Seçiniz');
						return false;
					} 
				</cfif>
				if(document.getElementById("expense_date").value == "")
				{
					alert("<cf_get_lang no='1064.Lütfen Harcama Tarihi Giriniz'>");
					return false;
				}
				if(document.getElementById("expense_cost_type").value == 120)
				{	
					if(	document.getElementById("budget_plan_id").value == "" && 
						(document.getElementById("credit_contract_id").value == "" || document.getElementById("credit_contract_id").value != "") && 
						((document.getElementById("ch_company_id").value != "" && document.getElementById("ch_company").value == "") || (document.getElementById("ch_company").value == "" && document.getElementById("ch_partner").value == "")) &&
						//((document.getElementById("ch_company_id").value != "" && document.getElementById("ch_company").value == "") || (document.getElementById("ch_partner").value == "")) &&
						(document.getElementById("cash") == undefined || document.getElementById("cash").checked == false) && 
						document.getElementById("bank").checked == false && document.getElementById("credit").checked == false )
					{
						alert("<cf_get_lang no ='1364.Cari Hesap Banka Kasa Seçeneklerinden Birini Seçmelisiniz'>");
						return false;
					}
				}
				if(document.getElementById("bank").checked == true)
				{		
					if(!acc_control()) return false;
				}
				if(document.getElementById("credit").checked == true)
				{		
					if(document.getElementById("credit_card_info").value == '')
					{
						alert("<cf_get_lang no='269.Lütfen Kredi Kartı Seçiniz'>");
						return false;
					}
				}
				var otv_list = "";
				for(r=1;r<=document.getElementById("record_num").value;r++)
				{
					deger_row_kontrol = document.getElementById("row_kontrol"+r).value;
					deger_total = document.getElementById("total"+r);
					if(document.getElementById("row_detail"+r) != undefined) deger_row_detail = document.getElementById("row_detail"+r); else deger_row_detail = "";
					<cfif ListFind(ListDeleteDuplicates(xml_order_list_rows),24) and x_is_required_physical_asset eq 1>
						deger_asset = document.getElementById("asset"+r);
					</cfif>
					<cfif x_is_project_priority eq 1>
						deger_project = document.getElementById("project_id"+r);
						deger_project_name = document.getElementById("project"+r);
						deger_product_id = eval('document.getElementById("product_id' + r +'")');
						deger_product_name = eval('document.getElementById("product_name' + r +'")');
					</cfif>
					deger_quantity = document.getElementById("quantity"+r);
					if(document.getElementById("authorized"+r) != undefined) harcama_yapan = document.getElementById("authorized"+r); else harcama_yapan="";
					if(document.getElementById("company"+r) != undefined) harcama_yapan_firma = document.getElementById("company"+r); else harcama_yapan_firma="";
					if(deger_row_kontrol == 1)
					{
						record_exist=1;
						if (document.getElementById("expense_date"+r)!= undefined && document.getElementById("expense_date"+r).value == "")
						{ 
							alert ("<cf_get_lang_main no='810.Lütfen Tarih giriniz'>");
							return false;
						}
						<cfif ListFind(ListDeleteDuplicates(xml_order_list_rows),6)>
							if(document.getElementById("product_id"+r) != undefined && document.getElementById("product_id"+r).value !="" && document.getElementById("product_name"+r).value != "" && (document.getElementById("department_id").value == "" || document.getElementById("department_name").value == ""))
							{ 
								alert ("<cf_get_lang no='852.Depo Girmelisiniz'>");
								return false;
							}
						</cfif>
						if(document.getElementById("row_detail"+r) != undefined && document.getElementById("row_detail"+r).value == "")
						{ 
							alert ("<cf_get_lang no='1073.Lütfen Açıklama Giriniz'> !");
							return false;
						}	
						if (deger_total.value == "" || deger_total.value == 0)
						{ 
							alert ("<cf_get_lang_main no='1738.Lütfen Tutar Giriniz'>");
							return false;
						}	
						<cfif ListFind(ListDeleteDuplicates(xml_order_list_rows),24) and x_is_required_physical_asset eq 1>
							if (deger_asset.value == "")
							{ 
								alert ("<cf_get_lang_main no='1423.Lütfen Fiziki Varlık Giriniz'>");
								return false;
							}	
						</cfif>
						if(document.getElementById("tax_rate"+r) != undefined && document.getElementById("kdv_total"+r) != undefined)
						{
							if(document.getElementById("tevkifat_oran") != undefined && document.getElementById("tevkifat_oran").value != "" && document.getElementById("tevkifat_box").checked == true && document.getElementById("expense_cost_type").value != 122)
							{//tevkifat hesaplamaları
								if(new_taxArray.length != 0)
									for (var m=0; m < new_taxArray.length; m++)
									{	
										var tax_flag = false;
										if(new_taxArray[m] == document.getElementById("tax_rate"+r).value){
											tax_flag = true;
											taxBeyanArray[m] += wrk_round(filterNum(document.getElementById("kdv_total"+r).value,'#xml_satir_number#') - (filterNum(document.getElementById("kdv_total"+r).value,'#xml_satir_number#')*(filterNum(document.getElementById("tevkifat_oran").value,8))));
											taxTevkifatArray[m] += wrk_round(filterNum(document.getElementById("kdv_total"+r).value,'#xml_satir_number#')*(filterNum(document.getElementById("tevkifat_oran").value,8)));
											break;
										}
									}
								if(!tax_flag){
									new_taxArray[new_taxArray.length] = document.getElementById("tax_rate"+r).value;
									taxBeyanArray[taxBeyanArray.length] = wrk_round(filterNum(document.getElementById("kdv_total"+r).value,'#xml_satir_number#') - (filterNum(document.getElementById("kdv_total"+r).value,'#xml_satir_number#')*(filterNum(document.getElementById("tevkifat_oran").value,8))));
									taxTevkifatArray[taxTevkifatArray.length] = wrk_round(filterNum(document.getElementById("kdv_total"+r).value,'#xml_satir_number#')*(filterNum(document.getElementById("tevkifat_oran").value,8)));
								}
							}
						}
						if(document.getElementById("otv_rate"+r) != undefined && document.getElementById("otv_rate"+r).value > 0 && !list_find(otv_list,document.getElementById("otv_rate"+r).value))
							otv_list+= document.getElementById("otv_rate"+r).value+',';
						
						<cfif x_is_project_priority eq 1>
							if ((deger_product_id != undefined && deger_product_id.value == "") || (deger_product_name != undefined && deger_product_name.value == ""))
							{ 
								alert ("<cf_get_lang_main no='313.Ürün Seçiniz'>!");
								return false;
							}
		
							if(deger_product_id != undefined)
							{					
								var get_urun_kalem = wrk_safe_query("obj_get_urun_kalem","dsn3","1",deger_product_id.value);
								var urun_record_ = get_urun_kalem.recordcount;											
								if(urun_record_<1)
								{
									<cfif fuseaction contains "assetcare">
									alert("Bu ürün için bakım fişi eklenemez.");
									</cfif>
									return false;
								}
								else
								{							
									document.getElementById("expense_item_id"+r).value = get_urun_kalem.EXPENSE_ITEM_ID;
									document.getElementById("expense_item_name"+r).value = "<cf_get_lang_main no='1139.Gider Kalemi'>";
								}
							}
									
							if (deger_project.value == "" || deger_project_name.value == "")
							{ 
								alert ("<cf_get_lang_main no='1385.Proje Seçiniz'>!");
								return false;
							}
							var get_proje_merkez = wrk_safe_query("obj_get_proje_merkez","dsn","1",deger_project.value);
							var proje_record_ = get_proje_merkez.recordcount;
							if(proje_record_<1 || get_proje_merkez.EXPENSE_CODE =='' || get_proje_merkez.EXPENSE_CODE==undefined)
							{
								alert("<cf_get_lang no='1875.Proje Masraf Merkezi Bulunamadı'>!");
								return false;
							}
							else
							{
								var get_code = wrk_safe_query("obj_get_code","dsn2","1",get_proje_merkez.EXPENSE_CODE);
								if(get_code.recordcount > 0 && get_code.EXPENSE_ID != undefined && get_code.EXPENSE_ID != '')
									document.getElementById("expense_center_id"+r).value = get_code.EXPENSE_ID;
								else
									document.getElementById("expense_center_id"+r).value = "";
								document.getElementById("expense_center_name"+r).value = "<cf_get_lang_main no='1048.Masraf Merkezi'>";
							}			
						</cfif>			
						if (document.getElementById("expense_center_id"+r).value == "" || document.getElementById("expense_center_name"+r).value == "")
						{
							alert ("<cf_get_lang no='1069.Lütfen Masraf Merkezi Seçiniz '>!");
							return false;
						}
						if((eval('document.getElementById("expense_item_id' + r + '")') == undefined && eval('document.getElementById("expense_item_id' + r + '")').value == "") || (eval('document.getElementById("expense_item_name' + r + '")') == undefined && eval('document.getElementById("expense_item_name' + r + '")').value == ""))
						{ 
							alert ("<cf_get_lang no='1071.Lütfen Gider Kalemi Seçiniz'> !");
							return false; 
						}	
						
						if(harcama_yapan=="" && harcama_yapan_firma=="")
						{
							if(document.getElementById("member_type"+r) != undefined) document.getElementById("member_type"+r).value="";
							if(document.getElementById("company_id"+r) != undefined) document.getElementById("company_id"+r).value="";
							if(document.getElementById("member_id"+r) != undefined) document.getElementById("member_id"+r).value="";
							if(document.getElementById("company"+r) != undefined) document.getElementById("company"+r).value="";
						}
						<!---Muhasebe hesabı alt hesaplar gelirken üst hesapların yazılamaması kontrolü--->
						var action_account_code = document.getElementById("account_code"+r).value;
						if(action_account_code != "")
						{ 
							if(WrkAccountControl(action_account_code,r+'.Satır: Muhasebe Hesabı Hesap Planında Tanımlı Değildir!') == 0)
							return false;
						}
					}
				}
				if (record_exist == 0) 
				{
					alert("<cf_get_lang no='1068.Lütfen Masraf Fişine Satır Ekleyiniz'> !");
					return false;
				}
				change_due_date();
				otv_list = otv_list.substr(0,otv_list.length-1);
				if(otv_list != "")
				{
		
					var otv_control = wrk_safe_query("obj_otv_control",'dsn3',0,otv_list);
					if(otv_control.recordcount != list_len(otv_list))
					{
						alert("<cf_get_lang no ='1365.Seçtiğiniz ÖTV Değerlerinin İçinde Tanımlı Olmayan ÖTV ler var'> !");
						return false;
					}	
				}
				if(document.getElementById("tevkifat_oran") != undefined && document.getElementById("tevkifat_oran").value != "" && document.getElementById("tevkifat_box").checked == true && document.getElementById("expense_cost_type").value != 122)
				{
					for (var tt=0; tt < new_taxArray.length; tt++)
					{
						document.getElementById("hidden_fields").innerHTML += '<input type="hidden" id="basket_tax_'+tt+'" name="basket_tax_'+tt+'" value="'+new_taxArray[tt]+'">';
						document.getElementById("hidden_fields").innerHTML += '<input type="hidden" id="basket_tax_value_'+tt+'" name="basket_tax_value_'+tt+'" value="'+taxBeyanArray[tt]+'">';
						document.getElementById("hidden_fields").innerHTML += '<input type="hidden" id="tevkifat_tutar_'+tt+'" name="tevkifat_tutar_'+tt+'" value="'+taxTevkifatArray[tt]+'">';
					}
				}
				if(document.getElementById("expense_cost_type").value == 122 && check_stock_action('add_costplan'))//üründe sıfır stok kontrolü
				{
					var temp_process_cat = document.getElementById("process_cat").options[document.getElementById("process_cat").selectedIndex].value;
					var temp_process_type = document.getElementById("ct_process_type_" + temp_process_cat);
					if(document.getElementById("department_id") != undefined && document.getElementById("department_id").value != "" && document.getElementById("location_id") != undefined && document.getElementById("location_id").value != "")
						if(!zero_stock_control(document.getElementById("department_id").value,document.getElementById("location_id").value,0,temp_process_type.value)) return false;
				}
				return unformat_fields();
				return true;	
			}
					
			function other_calc(row_info,type_info)
			{
				if(row_info != undefined)
				{
					if(document.getElementById("row_kontrol"+row_info).value==1)
					{
						deger_money_id = list_getat(document.getElementById("money_id"+row_info).value,1,',');
						for(kk=1;kk<=document.getElementById("kur_say").value;kk++)
						{
							money_deger =list_getat(document.add_costplan.rd_money[kk-1].value,1,',');
							if(money_deger == deger_money_id)
							{
								deger_diger_para_satir = document.add_costplan.rd_money[kk-1];
								form_value_rate_satir = document.getElementById("txt_rate2_"+kk);
							}
						}
						//if(document.getElementById("other_net_total"+row_info) != undefined) document.getElementById("other_net_total"+row_info).value = filterNum(document.getElementById("other_net_total"+row_info).value,'#xml_satir_number#');
						if(document.getElementById("net_total"+row_info) != undefined) document.getElementById("net_total"+row_info).value = filterNum(document.getElementById("other_net_total"+row_info).value,'#xml_satir_number#')*filterNum(form_value_rate_satir.value,'#session.ep.our_company_info.rate_round_num#');
								if(document.getElementById("otv_rate"+row_info) != undefined) 
									var otv_rate = document.getElementById("otv_rate"+row_info).value;
								else
									var otv_rate = 0;
								<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>
									var tax_multiplier = 100/(100+ + otv_rate + +filterNum(document.getElementById("tax_rate"+row_info).value,'#xml_satir_number#'));
								<cfelse>
									var tax_multiplier = (100/(100+ + otv_rate )*100/(100+ +filterNum(document.getElementById("tax_rate"+row_info).value,'#xml_satir_number#')));
								</cfif>
						if(document.getElementById("other_net_total_kdvsiz"+row_info) != undefined) document.getElementById("other_net_total_kdvsiz"+row_info).value = document.getElementById("other_net_total"+row_info).value*tax_multiplier;
						//if(document.getElementById("other_net_total"+row_info) != undefined ) document.getElementById("other_net_total"+row_info).value = commaSplit(document.getElementById("other_net_total"+row_info).value,'#xml_satir_number#');
						if(document.getElementById("net_total"+row_info) != undefined) document.getElementById("net_total"+row_info).value = commaSplit(document.getElementById("net_total"+row_info).value,'#xml_satir_number#');
						if(document.getElementById("other_net_total_kdvsiz"+row_info) != undefined) document.getElementById("other_net_total_kdvsiz"+row_info).value = commaSplit(document.getElementById("other_net_total_kdvsiz"+row_info).value,'#xml_satir_number#');
					}
					if(type_info==undefined)
						hesapla('other_net_total',row_info,2);
					else
						hesapla('other_net_total',row_info,2,type_info);
				}
				else
				{
					for(yy=1;yy<=document.getElementById("record_num").value;yy++)
					{	
						if(document.getElementById("row_kontrol"+yy).value==1)
						{
							other_calc(yy,1);
						}
					}
					toplam_hesapla();
				}
			}
			function other_calc_kdvsiz(row_info,type_info)
			{
				if(row_info != undefined)
				{
					if(document.getElementById("row_kontrol"+row_info).value==1)
					{
						if(document.getElementById("money_id"+row_info) != undefined)
						{
							deger_money_id = list_getat(document.getElementById("money_id"+row_info).value,1,',');
							for(kk=1;kk<=document.getElementById("kur_say").value;kk++)
							{
								money_deger =list_getat(document.add_costplan.rd_money[kk-1].value,1,',');
								if(money_deger == deger_money_id)
								{
									deger_diger_para_satir = document.add_costplan.rd_money[kk-1];
									form_value_rate_satir = document.getElementById("txt_rate2_"+kk);
								}
							}
							if(document.getElementById("other_net_total_kdvsiz"+row_info) != undefined) document.getElementById("other_net_total_kdvsiz"+row_info).value = filterNum(document.getElementById("other_net_total_kdvsiz"+row_info).value,'#xml_satir_number#');
								if(document.getElementById("otv_rate"+row_info) != undefined) 
									var otv_rate = document.getElementById("otv_rate"+row_info).value;
								else
									var otv_rate = 0;
								<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>
									var tax_multiplier = 100/(100+ + otv_rate + +filterNum(document.getElementById("tax_rate"+row_info).value,'#xml_satir_number#'));
								<cfelse>
									var tax_multiplier = (100/(100+ + otv_rate )*100/(100+ +filterNum(document.getElementById("tax_rate"+row_info).value,'#xml_satir_number#')));
								</cfif>
							if(document.getElementById("other_net_total"+row_info) != undefined) document.getElementById("other_net_total"+row_info).value = document.getElementById("other_net_total_kdvsiz"+row_info).value/tax_multiplier;
							if(document.getElementById("net_total"+row_info) != undefined) document.getElementById("net_total"+row_info).value = document.getElementById("other_net_total"+row_info).value*filterNum(form_value_rate_satir.value,'#session.ep.our_company_info.rate_round_num#');
							if(document.getElementById("net_total"+row_info) != undefined) document.getElementById("net_total"+row_info).value = commaSplit(document.getElementById("net_total"+row_info).value,'#xml_satir_number#');
							if(document.getElementById("other_net_total"+row_info) != undefined) document.getElementById("other_net_total"+row_info).value = commaSplit(document.getElementById("other_net_total"+row_info).value,'#xml_satir_number#');
							if(document.getElementById("other_net_total_kdvsiz"+row_info) != undefined) document.getElementById("other_net_total_kdvsiz"+row_info).value = commaSplit(document.getElementById("other_net_total_kdvsiz"+row_info).value,'#xml_satir_number#');
						}
					}
					if(type_info==undefined)
						hesapla('other_net_total_kdvsiz',row_info,2);
					else
						hesapla('other_net_total_kdvsiz',row_info,2,type_info);
				}
				else
				{
					for(yy=1;yy<=document.getElementById("record_num").value;yy++)
					{
						if(document.getElementById("row_kontrol"+yy).value==1)
						{
							other_calc(yy,1);
						}
					}
					toplam_hesapla();
				}
			}
			
		</cfoutput>
	</script>
</cfif>

<cfif IsDefined("attributes.event") and attributes.event eq 'upd'>
	<cfquery name="get_expense" datasource="#dsn2#">
        SELECT
            EIP.*
        FROM
            EXPENSE_ITEM_PLANS EIP
    
        WHERE
            EIP.EXPENSE_ID = #attributes.expense_id#
            <cfif listgetat(attributes.fuseaction,1,'.') is 'store'>
                AND BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#
            </cfif>
    </cfquery>
    <cfquery name="get_efatura_det" datasource="#dsn2#">
        SELECT
            RECEIVING_DETAIL_ID
        FROM
            EINVOICE_RECEIVING_DETAIL
        WHERE
            EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
        ORDER BY
            RECEIVING_DETAIL_ID DESC
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
	<cfif not (get_expense.recordcount) or (isdefined("attributes.active_period") and attributes.active_period neq session.ep.period_id)>
		<cfset hata  = 11>
		<cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'>!</cfsavecontent>
		<cfset hata_mesaj  = message>
		<cfinclude template="../dsp_hata.cfm">
		<cfabort>
	<cfelse>
        <cfquery name="GET_MONEY" datasource="#dsn2#">
            SELECT * FROM SETUP_MONEY WHERE MONEY_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> ORDER BY MONEY_ID
        </cfquery>
        <cfquery name="GET_EXPENSE_MONEY" datasource="#dsn2#">
            SELECT MONEY_TYPE AS MONEY,* FROM EXPENSE_ITEM_PLANS_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#"> ORDER BY ACTION_ID
        </cfquery>
        <cfif not GET_EXPENSE_MONEY.recordcount>
            <cfquery name="GET_EXPENSE_MONEY" datasource="#DSN#">
                SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
            </cfquery>
        </cfif>
    </cfif>
    <cfif len(get_expense.paymethod_id)>
        <cfquery name="get_pay_meyhod" datasource="#dsn#">
            SELECT PAYMETHOD FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_expense.paymethod_id#">
        </cfquery>
    </cfif>
    <cfif isdefined("get_expense") and get_expense.is_creditcard eq 1>
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
                    EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_expense.expense_id#">
                    AND ACTION_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
                    AND CREDIT_CARD_BANK_EXPENSE_ROWS.CREDITCARD_EXPENSE_ID = CREDIT_CARD_BANK_EXPENSE.CREDITCARD_EXPENSE_ID
            ) T1
            GROUP BY
                CREDITCARD_ID,
                INSTALLMENT_NUMBER,
                DELAY_INFO
        </cfquery>
        <cfset ins_info = get_credit_info.INSTALLMENT_NUMBER>
        <cfset credit_info = get_credit_info.CREDITCARD_ID>
        <cfset delay_info = get_credit_info.DELAY_INFO>
        <cfif get_credit_info.closed_amount gt 0>
            <cfset kontrol_update = 1>
        <cfelse>
            <cfset kontrol_update = 0>
        </cfif>
    <cfelse>
        <cfset ins_info = ''>
        <cfset credit_info = ''>
        <cfset delay_info = ''>
        <cfset kontrol_update = 0>
    </cfif>
    <script type="text/javascript">
		$( document ).ready(function() {
			<cfif get_expense.tevkifat eq 1>//tevkifat hesapları için sayfa yüklenrken çağrılıyor
				toplam_hesapla();
			</cfif>
			record_exist=0;
			change_due_date();
			toplam_hesapla(2);
		});
		function send_popup_voucher()
		{
			if(document.getElementById("branch_id_") != undefined)
				branch_ = document.getElementById("branch_id_").value;
			else
				branch_ = '<cfoutput>#Listgetat(session.ep.user_location,2,"-")#</cfoutput>';
			windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_payment_with_voucher&is_purchase_=1&payment_process_id=#attributes.expense_id#</cfoutput>&str_table=EXPENSE_ITEM_PLANS&branch_id='+branch_,'list','popup_payment_with_voucher');
		}
		function del_kontrol()
		{
			if(!control_account_process(<cfoutput>'#attributes.expense_id#','#get_expense.action_type#'</cfoutput>)) return false;
			<cfif session.ep.our_company_info.is_efatura and isdefined("get_efatura_det") and get_efatura_det.recordcount>
				alert("Fatura ile İlişkili e-Fatura Olduğu için Silinemez !");
				return false;
			</cfif>
			var control_credit_card = wrk_safe_query("obj_ctrl_cd","dsn3",1,<cfoutput>#get_expense.expense_id#</cfoutput>);
			if(control_credit_card.recordcount > 0 && control_credit_card.CLOSED_AMOUNT > 0)
			{
				alert("Kredi Kartı Ödemesi Yapıldığı İçin,Ödeme İşlemini Geri Almadan İşlemi Silemezsiniz!");
				return false;
			}
			else
			{
				if(!chk_period(document.getElementById("expense_date"),"İşlem")) return false;
				if(!check_display_files('add_costplan')) return false;
			}
			return true;
		}
		<cfoutput>
			function hesapla(field_name,satir,hesap_type,extra_type)
			{
				if(field_name != '' && field_name != 'product_id' && field_name != 'product_name')
				{
					var input_name_ = field_name+satir;
					field_changed_value = filterNum(document.getElementById(input_name_).value,'#xml_satir_number#');
				}
				else
					field_changed_value = '-1';
				if(field_changed_value == '-1' || document.getElementById("control_field_value") == undefined || (document.getElementById("control_field_value") != undefined && field_changed_value != document.getElementById("control_field_value").value))
				{
					var toplam_dongu_0 = 0;//satir toplam
					if(document.getElementById("row_kontrol"+satir).value==1)
					{
						if(document.getElementById("total"+satir) != undefined) deger_total = document.getElementById("total"+satir); else deger_total="";//tutar
						if(document.getElementById("quantity"+satir) != undefined) deger_quantity = document.getElementById("quantity"+satir); else deger_quantity="";//miktar
						if(document.getElementById("kdv_total"+satir) != undefined) deger_kdv_total= document.getElementById("kdv_total"+satir); else deger_kdv_total="";//kdv tutarı
						if(document.getElementById("otv_total"+satir) != undefined) deger_otv_total= document.getElementById("otv_total"+satir); else deger_otv_total="";//ötv tutarı
						if(document.getElementById("net_total"+satir) != undefined) deger_net_total = document.getElementById("net_total"+satir); else deger_net_total="";//kdvli tutar
						if(document.getElementById("tax_rate"+satir) != undefined) deger_tax_rate = document.getElementById("tax_rate"+satir); else deger_tax_rate="";//kdv oranı
						if(document.getElementById("otv_rate"+satir) != undefined) deger_otv_rate = document.getElementById("otv_rate"+satir); else deger_otv_rate=0;//ötv oranı
						if(document.getElementById("other_net_total"+satir) != undefined) deger_other_net_total = document.getElementById("other_net_total"+satir); else deger_other_net_total="";//dovizli tutar kdv dahil
						if(document.getElementById("other_net_total_kdvsiz"+satir) != undefined) deger_other_net_total_kdvsiz = document.getElementById("other_net_total_kdvsiz"+satir); else deger_other_net_total_kdvsiz="";//dovizli tutar kdv hariç
						if(document.getElementById("money_id"+satir) != undefined)
						{
							deger_money_id = document.getElementById("money_id"+satir);
							deger_money_id =  list_getat(deger_money_id.value,1,',');
							for(s=1;s<=document.getElementById("kur_say").value;s++)
							{
								if(document.getElementById("kur_say").value == 1)
									money_deger =list_getat(document.all.rd_money.value,1,',');
								else
									money_deger =list_getat(document.all.rd_money[s-1].value,1,',');
								if(money_deger == deger_money_id)
								{
									if(document.getElementById("kur_say").value == 1)
										deger_diger_para_satir = document.all.rd_money;
									else
										deger_diger_para_satir = document.all.rd_money[s-1];
									form_value_rate_satir = document.getElementById("txt_rate2_"+s);
								}
							}
							deger_para_satir = list_getat(deger_diger_para_satir.value,3,',');
						}
						else
						{
							deger_money_id="";
							deger_para_satir="";
							form_value_rate_satir="";
						}
						if(deger_total != "") deger_total.value = filterNum(deger_total.value,'#xml_satir_number#');
						if(deger_quantity != "") deger_quantity.value = filterNum(deger_quantity.value,'#xml_satir_number#'); else deger_quantity.value = 1;
						if(deger_kdv_total != "") deger_kdv_total.value = filterNum(deger_kdv_total.value,'#xml_satir_number#');
						if(deger_otv_total != "") deger_otv_total.value = filterNum(deger_otv_total.value,'#xml_satir_number#'); else deger_otv_total.value = 0;
						if(deger_net_total != "") deger_net_total.value = filterNum(deger_net_total.value,'#xml_satir_number#');
						if(deger_other_net_total != "") deger_other_net_total.value = filterNum(deger_other_net_total.value,'#xml_satir_number#');
						if(deger_other_net_total_kdvsiz != "") deger_other_net_total_kdvsiz.value = filterNum(deger_other_net_total_kdvsiz.value,'#xml_satir_number#');
						if(hesap_type ==undefined)
						{
							if(deger_otv_total != "" && deger_total != "")
							{
								if(deger_otv_rate.value == undefined)
									deger_otv_total.value = (parseFloat(deger_total.value * deger_quantity.value * 0))/100;
								else
									deger_otv_total.value = (parseFloat(deger_total.value * deger_quantity.value * deger_otv_rate.value))/100;
							}
							<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>
								if(deger_kdv_total != "" && deger_total != "")
								{
									if(deger_tax_rate.value == undefined)
										deger_kdv_total.value = ((parseFloat(deger_total.value) * parseFloat(deger_quantity.value)) * 0)/100;
									else
										deger_kdv_total.value = ((parseFloat(deger_total.value) * parseFloat(deger_quantity.value)) * deger_tax_rate.value)/100;
								}
							<cfelse>
								if(deger_kdv_total != "" && deger_total != "")
								{
									if(deger_tax_rate.value == undefined)
										deger_kdv_total.value = ((parseFloat(deger_total.value * deger_quantity.value)+parseFloat(deger_otv_total.value)) * 0)/100;
									else
										deger_kdv_total.value = ((parseFloat(deger_total.value * deger_quantity.value)+parseFloat(deger_otv_total.value)) * deger_tax_rate.value)/100;
								}
							</cfif>
						}
						else if(hesap_type == 2)
						{
							if(deger_otv_rate.value == undefined)
								otv_rate_ = 0;
							else
								otv_rate_ = deger_otv_rate.value;
	
							if(deger_tax_rate != undefined && deger_tax_rate.value == '')
								tax_rate_ = 0;
							else
								tax_rate_ = deger_tax_rate.value;
							<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>
								if(deger_total != "" && deger_tax_rate != "") deger_total.value = ((parseFloat(deger_net_total.value)/parseFloat(deger_quantity.value))*100)/ (parseFloat(tax_rate_)+parseFloat(otv_rate_)+100);
								if(deger_kdv_total != "" && deger_total != "")
								{
									if(deger_tax_rate.value == undefined)
										deger_kdv_total.value = (parseFloat(deger_total.value * deger_quantity.value * 0))/100;
									else
										deger_kdv_total.value = (parseFloat(deger_total.value * deger_quantity.value * deger_tax_rate.value))/100;
								}
								if(deger_otv_total != "" && deger_total != "")
								{
									if(deger_otv_rate.value == undefined)
										deger_otv_total.value = (parseFloat(deger_total.value * deger_quantity.value * 0))/100;
									else
										deger_otv_total.value = (parseFloat(deger_total.value * deger_quantity.value * deger_otv_rate.value))/100;
								}
							<cfelse>
								if(deger_total != "" && deger_tax_rate != "")
									deger_total.value = ((parseFloat(deger_net_total.value)/parseFloat(deger_quantity.value))/((parseFloat(tax_rate_)+100)/100))/((parseFloat(otv_rate_)+100)/100);
								if(deger_otv_total != "" && deger_total != "")
								{
									if(deger_otv_rate.value == undefined)
										deger_otv_total.value = (parseFloat(deger_total.value * deger_quantity.value *0))/100;
									else
										deger_otv_total.value = (parseFloat(deger_total.value * deger_quantity.value * deger_otv_rate.value))/100;
								}
								if(deger_kdv_total != "" && deger_total != "")
								{
									if(deger_tax_rate.value == undefined)
										deger_kdv_total.value = ((parseFloat(deger_total.value * deger_quantity.value)+parseFloat(deger_otv_total.value)) * 0)/100;
									else
										deger_kdv_total.value = ((parseFloat(deger_total.value * deger_quantity.value)+parseFloat(deger_otv_total.value)) * deger_tax_rate.value)/100;
								}
							</cfif>
						}
						toplam_dongu_0 = parseFloat(deger_total.value * deger_quantity.value);
						if(deger_kdv_total != "") toplam_dongu_0 = toplam_dongu_0 + parseFloat(deger_kdv_total.value);
						if(deger_otv_total != "") toplam_dongu_0 = toplam_dongu_0 + parseFloat(deger_otv_total.value);
						if(extra_type != 2)
							if(deger_other_net_total != "") deger_other_net_total.value = ((toplam_dongu_0) * parseFloat(deger_para_satir) / (parseFloat(form_value_rate_satir.value)));
						if(deger_net_total != "") deger_net_total.value = commaSplit(toplam_dongu_0,'#xml_satir_number#');
						if(deger_total != "") deger_total.value = commaSplit(deger_total.value,'#xml_satir_number#');
						if(deger_quantity != "") deger_quantity.value = commaSplit(deger_quantity.value,'#xml_satir_number#');
						if(deger_kdv_total != "") deger_kdv_total.value = commaSplit(deger_kdv_total.value,'#xml_satir_number#');
						if(deger_otv_total != "") deger_otv_total.value = commaSplit(deger_otv_total.value,'#xml_satir_number#');
						if(deger_other_net_total != "") deger_other_net_total.value = commaSplit(deger_other_net_total.value,'#xml_satir_number#');
						if(deger_other_net_total_kdvsiz != "") deger_other_net_total_kdvsiz.value = commaSplit(deger_other_net_total_kdvsiz.value,'#xml_satir_number#');
					}
					<cfif fuseaction contains "assetcare"> <!--- sadece assetcare modulunde spec secilebildigi icin eklendi --->
						delete_spec(satir);
					</cfif>
					if(extra_type == 2 || extra_type == undefined)
						toplam_hesapla(extra_type);
				}
			}
			function toplam_hesapla(type)
			{
				if(document.getElementById("expense_cost_type").value != 122)
				{
					var beyan_tutar = 0;
					var tevkifat_info = "";
					var beyan_tutar_info = "";
					var new_taxArray = new Array(0);
					var taxBeyanArray = new Array(0);
					var taxTevkifatArray = new Array(0);
				}
				var toplam_dongu_1 = 0;//tutar genel toplam
				var toplam_dongu_2 = 0;// kdv genel toplam
				var toplam_dongu_3 = 0;// kdvli genel toplam
				var toplam_dongu_4 = 0;// ötv genel toplam
				if(type != 2)
					doviz_hesapla();
				for(r=1;r<=document.getElementById("record_num").value;r++)
				{
					if(document.getElementById("row_kontrol"+r).value==1)
					{
						if(document.getElementById("total"+r) != undefined) deger_total = document.getElementById("total"+r); else deger_total="";//tutar
						if(document.getElementById("quantity"+r) != undefined) deger_quantity = document.getElementById("quantity"+r); else deger_quantity="";//miktar
						if(document.getElementById("kdv_total"+r) != undefined) deger_kdv_total= document.getElementById("kdv_total"+r); else deger_kdv_total="";//kdv tutarı
						if(document.getElementById("otv_total"+r) != undefined) deger_otv_total= document.getElementById("otv_total"+r); else deger_otv_total="";//ötv tutarı
						if(document.getElementById("net_total"+r) != undefined) deger_net_total = document.getElementById("net_total"+r); else deger_net_total="";//kdvli tutar
						if(document.getElementById("tax_rate"+r) != undefined) deger_tax_rate = document.getElementById("tax_rate"+r); else deger_tax_rate="";//kdv oranı
						if(document.getElementById("otv_rate"+r) != undefined) deger_otv_rate = document.getElementById("otv_rate"+r); else deger_otv_rate="";//ötv oranı
						if(document.getElementById("other_net_total"+r) != undefined) deger_other_net_total = document.getElementById("other_net_total"+r); else deger_other_net_total="";//dovizli tutar kdv dahil
						if(document.getElementById("other_net_total_kdvsiz"+r) != undefined) deger_other_net_total_kdvsiz = document.getElementById("other_net_total_kdvsiz"+r); else deger_other_net_total_kdvsiz="";//dovizli tutar kdv dahil
	
						if(deger_total != "") deger_total.value = filterNum(deger_total.value,'#xml_satir_number#');
						if(deger_quantity != "") deger_quantity.value = filterNum(deger_quantity.value,'#xml_satir_number#');
						if(deger_kdv_total != "") deger_kdv_total.value = filterNum(deger_kdv_total.value,'#xml_satir_number#');
	
						if(document.getElementById("tax_rate"+r) != undefined && document.getElementById("kdv_total"+r) != undefined)
						{
							if(document.getElementById("tevkifat_oran") != undefined && document.getElementById("tevkifat_oran").value != "" && document.getElementById("tevkifat_box").checked == true && document.getElementById("expense_cost_type").value != 122)
							{//tevkifat hesaplamaları
								beyan_tutar = beyan_tutar + wrk_round(deger_kdv_total.value*filterNum(document.getElementById("tevkifat_oran").value,8));
								if(new_taxArray.length != 0)
									for (var m=0; m < new_taxArray.length; m++)
									{
										var tax_flag = false;
										if(new_taxArray[m] == deger_tax_rate.value){
											tax_flag = true;
											taxBeyanArray[m] += wrk_round(deger_kdv_total.value - (deger_kdv_total.value*(filterNum(document.getElementById("tevkifat_oran").value,8))));
											taxTevkifatArray[m] += wrk_round(deger_kdv_total.value*(filterNum(document.getElementById("tevkifat_oran").value,8)));
											break;
										}
									}
								if(!tax_flag){
									new_taxArray[new_taxArray.length] = deger_tax_rate.value;
									taxBeyanArray[taxBeyanArray.length] = wrk_round(deger_kdv_total.value - (deger_kdv_total.value*(filterNum(document.getElementById("tevkifat_oran").value,8))));
									taxTevkifatArray[taxTevkifatArray.length] = wrk_round(deger_kdv_total.value*(filterNum(document.getElementById("tevkifat_oran").value,8)));
								}
							}
						}
						if(deger_otv_total != "") deger_otv_total.value = filterNum(deger_otv_total.value,'#xml_satir_number#');
						if(deger_net_total != "") deger_net_total.value = filterNum(deger_net_total.value,'#xml_satir_number#');
						if(deger_total != "") toplam_dongu_1 = toplam_dongu_1 + parseFloat(deger_total.value * deger_quantity.value);
						if(deger_kdv_total != "") toplam_dongu_2 = toplam_dongu_2 + parseFloat(deger_kdv_total.value);
						if(deger_otv_total != "") toplam_dongu_4 = toplam_dongu_4 + parseFloat(deger_otv_total.value);
						if(deger_total != "") toplam_dongu_3 = toplam_dongu_3 + (parseFloat(deger_total.value * deger_quantity.value));
						if(deger_kdv_total != "") toplam_dongu_3 = toplam_dongu_3 + parseFloat(deger_kdv_total.value);
						if(deger_otv_total != "") toplam_dongu_3 = toplam_dongu_3 + parseFloat(deger_otv_total.value);
						if(deger_net_total != "") deger_net_total.value = commaSplit(deger_net_total.value,'#xml_satir_number#');
						if(deger_total != "") deger_total.value = commaSplit(deger_total.value,'#xml_satir_number#');
						if(deger_quantity != "") deger_quantity.value = commaSplit(deger_quantity.value,'#xml_satir_number#');
						if(deger_kdv_total != "") deger_kdv_total.value = commaSplit(deger_kdv_total.value,'#xml_satir_number#');
						if(deger_otv_total != "") deger_otv_total.value = commaSplit(deger_otv_total.value,'#xml_satir_number#');
						<cfif ListFind(ListDeleteDuplicates(xml_order_list_rows),6)>
						if(document.getElementById("product_id"+r) != undefined && document.getElementById("product_id"+r) != '')
								view_product_info(r);
						</cfif>
					}
				}
				if(document.getElementById("tevkifat_oran") != undefined && document.getElementById("tevkifat_oran").value != "" && document.getElementById("tevkifat_box").checked == true && document.getElementById("expense_cost_type").value != 122)
				{//tevkifat hesaplamaları
					toplam_dongu_3 = toplam_dongu_3 - toplam_dongu_2 + beyan_tutar;
					toplam_dongu_2 = beyan_tutar;
					tevkifat_text.style.fontWeight = 'bold';
					tevkifat_text.innerHTML = '';
					beyan_text.style.fontWeight = 'bold';
					beyan_text.innerHTML = '';
					for (var tt=0; tt < new_taxArray.length; tt++)
					{
						tevkifat_text.innerHTML += '% ' + new_taxArray[tt] + ' : ' + commaSplit(taxBeyanArray[tt],'#xml_genel_number#') + ' ';
						beyan_text.innerHTML += '% ' + new_taxArray[tt] + ' : ' + commaSplit(taxTevkifatArray[tt],'#xml_genel_number#') + ' ';
					}
				}
				if(type == undefined || parseFloat(document.getElementById("stopaj_yuzde").value) == 0)
					stopaj_ = wrk_round((toplam_dongu_1 * parseFloat(document.getElementById("stopaj_yuzde").value) / 100),'#xml_genel_number#');
				else
					stopaj_ = filterNum(document.getElementById("stopaj").value);
				document.getElementById("stopaj_yuzde").value = commaSplit(parseFloat(document.getElementById("stopaj_yuzde").value));
				document.getElementById("stopaj").value = commaSplit(stopaj_,'#xml_genel_number#');
				if(document.getElementById("yuvarlama").value != '')
				{
					toplam_dongu_3 = toplam_dongu_3 + parseFloat(filterNum(document.getElementById("yuvarlama").value,'#xml_genel_number#'));
					document.getElementById("yuvarlama").value = commaSplit(filterNum(document.getElementById("yuvarlama").value),'#xml_genel_number#');
				}
				toplam_dongu_3 = toplam_dongu_3-parseFloat(stopaj_);
				document.getElementById("total_amount").value = commaSplit(toplam_dongu_1,'#xml_genel_number#');
				document.getElementById("kdv_total_amount").value = commaSplit(toplam_dongu_2,'#xml_genel_number#');
				document.getElementById("otv_total_amount").value = commaSplit(toplam_dongu_4,'#xml_genel_number#');
				document.getElementById("net_total_amount").value = commaSplit(toplam_dongu_3,'#xml_genel_number#');
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
						if(document.add_costplan.rd_money[s-1].checked == true)
						{
							deger_diger_para = document.add_costplan.rd_money[s-1];
							form_txt_rate2_ = document.getElementById("txt_rate2_"+s);
						}
					}
				deger_money_id_1 = list_getat(deger_diger_para.value,1,',');
				deger_money_id_2 = list_getat(deger_diger_para.value,2,',');
				deger_money_id_3 = list_getat(deger_diger_para.value,3,',');
				form_txt_rate2_.value = filterNum(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#');
				document.getElementById("other_total_amount").value = commaSplit(toplam_dongu_1 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#')),'#xml_genel_number#');
				document.getElementById("other_kdv_total_amount").value = commaSplit(toplam_dongu_2 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#')),'#xml_genel_number#');
				document.getElementById("other_otv_total_amount").value = commaSplit(toplam_dongu_4 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#')),'#xml_genel_number#');
				document.getElementById("other_net_total_amount").value = commaSplit(toplam_dongu_3 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#')),'#xml_genel_number#');
	
				document.getElementById("tl_value1").value = deger_money_id_1;
				document.getElementById("tl_value2").value = deger_money_id_1;
				document.getElementById("tl_value3").value = deger_money_id_1;
				document.getElementById("tl_value4").value = deger_money_id_1;
				form_txt_rate2_.value = commaSplit(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#');
			}
			function doviz_hesapla()
			{
				for(k=1;k<=document.getElementById("record_num").value;k++)
				{
					if(document.getElementById("money_id"+k) != undefined)
					{
						deger_money_id = document.getElementById("money_id"+k);
						deger_money_id =  list_getat(deger_money_id.value,1,',');
						if(document.getElementById("kur_say").value == 1)
						{
							money_deger =list_getat(document.getElementById("rd_money").value,1,',');
							if(money_deger == deger_money_id)
							{
								for (var t=1; t<=document.getElementById("kur_say").value; t++)
								{
									rate2_value = filterNum(document.getElementById("txt_rate2_"+t).value,'#session.ep.our_company_info.rate_round_num#')/filterNum(document.getElementById("txt_rate1_"+t).value,'#session.ep.our_company_info.rate_round_num#');
									document.getElementById("other_net_total"+k).value = commaSplit(filterNum(document.getElementById("net_total"+k).value,'#xml_satir_number#')/rate2_value,'#xml_satir_number#');
									document.getElementById("other_net_total_kdvsiz"+k).value = commaSplit(filterNum(document.getElementById("total"+k).value,'#xml_satir_number#')/rate2_value,'#xml_satir_number#');
								}
							}
						}
						else
						{
							for (var t=1; t<=document.getElementById("kur_say").value; t++)
							{
								money_deger =list_getat(document.add_costplan.rd_money[t-1].value,1,',');
								if(money_deger == deger_money_id)
								{
									rate2_value = filterNum(document.getElementById("txt_rate2_"+t).value,'#session.ep.our_company_info.rate_round_num#')/filterNum(document.getElementById("txt_rate1_"+t).value,'#session.ep.our_company_info.rate_round_num#');
									document.getElementById("other_net_total"+k).value = commaSplit(filterNum(document.getElementById("net_total"+k).value,'#xml_satir_number#')/rate2_value,'#xml_satir_number#');
									document.getElementById("other_net_total_kdvsiz"+k).value = commaSplit(filterNum(document.getElementById("total"+k).value,'#xml_satir_number#')/rate2_value,'#xml_satir_number#');
								}
							}
						}
					}
				}
			}
			//Row_kontrol değeri 1 olan yani silinmemiş satırların varlığını kontrol ediyor
			function kontrol()
			{
				<cfif xml_upd_row_project eq 1>
					for(i=1; i<row_count+1; i++){
						if(document.getElementById("project_id"+i).value == "" || document.getElementById("project"+i).value == "")
						{
							document.getElementById("project_id"+i).value = document.getElementById("project_id").value;
							document.getElementById("project"+i).value = document.getElementById("project_head").value;
						<cfif xml_upd_row_expense_center eq 1>
							if(document.getElementById("project_id"+i).value != "" || document.getElementById("project"+i).value != "")
							{
								var xxx = document.getElementById("project_id"+i).value;
								var get_expense_center = wrk_safe_query('obj_get_project_related_expense','dsn2',0,xxx);
								document.getElementById("expense_center_id"+i).value = get_expense_center.EXPENSE_ID;
								document.getElementById("expense_center_name"+i).value = get_expense_center.EXPENSE;
							}
						</cfif>
						}
					}
				</cfif>
				var beyan_tutar = 0;
				var tevkifat_info = "";
				var beyan_tutar_info = "";
				var new_taxArray = new Array(0);
				var taxBeyanArray = new Array(0);
				var taxTevkifatArray = new Array(0);
				if (!control_account_process(<cfoutput>'#attributes.expense_id#','#get_expense.action_type#'</cfoutput>)) return false;
				if (!chk_period(document.getElementById("expense_date"),"İşlem")) return false;
				if (!chk_process_cat('add_costplan')) return false;
				if (!check_display_files('add_costplan')) return false;
				//eger sube xml'i acik degilse boş deger atar.
				<cfif x_select_branch eq 0>
					if(document.getElementById("branch_id_") != undefined)
						document.getElementById("branch_id_").value = '';
				</cfif>
				//Odeme Plani Guncelleme Kontrolleri
				if (document.getElementById("cari_action_type_").value == 5 && document.getElementById("old_pay_method").value != "")
				{
					if (confirm("<cf_get_lang_main no='1663.Güncellediğiniz Belgenin Ödeme Planı Yeniden Oluşturulacaktır'>!"))
						document.getElementById("invoice_payment_plan").value = 1;
					else
					{
						document.getElementById("invoice_payment_plan").value = 0;
						<cfif xml_control_payment_plan_status eq 1>
							return false;
						</cfif>
					}
				}
				var process_info = wrk_safe_query('obj_process_info','dsn3',0,document.getElementById("old_process_cat_id").value);
				var listParam = "<cfoutput>#attributes.expense_id#</cfoutput>" + "*" + document.getElementById("old_process_type").value;
				var closed_info = wrk_safe_query("obj_closed_info",'dsn2',0,listParam);
				var temp_process_cat = document.getElementById("process_cat").options[document.getElementById("process_cat").selectedIndex].value;
				
				if(closed_info.recordcount)
					if((document.getElementById("old_pay_method").value != document.getElementById("paymethod").value) || (commaSplit(document.getElementById("old_net_total").value,2) != commaSplit(filterNum(document.getElementById("net_total_amount").value),2)) || (closed_info.COMPANY_ID != '' && closed_info.COMPANY_ID != document.getElementById("ch_company_id").value) || (closed_info.CONSUMER_ID != '' && closed_info.CONSUMER_ID != document.getElementById("ch_partner_id").value) || (document.getElementById("old_process_type").value != document.getElementById("ct_process_type_" + temp_process_cat).value))
					{
						alert("Belge Kapama,Talep veya Emir Girilen Belgenin Tutarı,Carisi,Ödeme Yöntemi veya İşlem Tipi Değiştirilemez!");
						return false;
					}
					if(document.getElementById("ch_member_type").value == 'partner')
					{
						var ch_comp_id = document.getElementById("ch_company_id").value;
						var ch_cons_id = '';
					}
					else if(document.getElementById("ch_member_type").value == 'consumer')
					{
						var ch_comp_id = '';
						var ch_cons_id = document.getElementById("ch_partner_id").value;
					}
					/* Kullanilmiyorsa kaldirilsin fbs 20120510
					var listParam = document.getElementById("expense_id").value + "*" + document.getElementById("serial_no").value;
					var BELGE_NO_CONTROL = wrk_safe_query("obj_BELGE_NO_CONTROL_2",'dsn2',0,listParam);
					*/
				<cfif isdefined('xml_acc_department_info') and xml_acc_department_info eq 2> //xmlde muhasebe icin departman secimi zorunlu ise
					if( document.getElementById("acc_department_id").options[document.getElementById("acc_department_id").selectedIndex].value=='')
					{
						alert('Departman Seçiniz !');
						return false;
					}
				</cfif>
				<cfif isdefined('x_select_project') and x_select_project eq 2> //xmlde muhasebe icin proje secimi zorunlu ise
					if(document.getElementById("project_head").value=='' || document.getElementById("project_id").value=='')
					{
						alert('Proje Seçiniz');
						return false;
					} 
				</cfif>
				if(document.getElementById("expense_date").value == "")
				{
					alert("<cf_get_lang no='1064.Lütfen Harcama Tarihi Giriniz '>!");
					return false;
				}
				/*if(document.getElementById("budget_plan_id").value != "" && (document.getElementById("ch_company").value != "" || document.getElementById("ch_partner").value != "" || document.getElementById("cash").checked == true || document.getElementById("bank").checked == true || document.getElementById("credit").checked == true))
				{
					alert("<cf_get_lang no ='1362.Gider Planlamada Cari Hesap Banka veya Kasa Seçemezsiniz '>!");
					return false;
				}
				if(document.getElementById("credit_contract_id").value != "" && (document.getElementById("cash").checked == true || document.getElementById("bank").checked == true || document.getElementById("credit").checked == true))
				{
					alert("<cf_get_lang no ='1363.Finansal Kiralama Sözleşmesi İçin Banka veya Kasa Seçemezsiniz'> !");
					return false;
				}*/
				if(document.getElementById("expense_cost_type").value == 120)
				{
					if(document.getElementById("budget_plan_id").value == "" &&
					(document.getElementById("credit_contract_id").value == "" || (document.getElementById("credit_contract_id").value != "" && document.getElementById("is_interest").value == "")) &&
					((document.getElementById("ch_company_id").value != "" && document.getElementById("ch_company").value == "") || (document.getElementById("ch_company").value == "" && document.getElementById("ch_partner").value == "")) &&
					(document.getElementById("cash") == undefined || document.getElementById("cash").checked == false) &&
					document.getElementById("bank").checked == false && document.getElementById("credit").checked == false)
					{
						alert("<cf_get_lang no ='1364.Cari Hesap Banka Kasa Seçeneklerinden Birini Seçmelisiniz'> !");
						return false;
					}
				}
				if(document.getElementById("bank").checked == true)
				{
					if(!acc_control()) return false;
				}
				if(document.getElementById("credit").checked == true)
				{
					if(document.getElementById("credit_card_info").value == '')
					{
						alert("<cf_get_lang no='269.Lütfen Kredi Kartı Seçiniz'> !");
						return false;
					}
				}
				var otv_list = "";
				for(r=1;r<=document.getElementById("record_num").value;r++)
				{
					deger_row_kontrol = document.getElementById("row_kontrol"+r);
					if(document.getElementById("row_detail"+r) != undefined) deger_row_detail = document.getElementById("row_detail"+r); else deger_row_detail = "";
	
					<cfif x_is_project_priority eq 1>
						deger_project = document.getElementById("project_id"+r);
						deger_project_name = document.getElementById("project"+r);
						deger_product_id = eval('document.getElementById("product_id' + r +'")');
						deger_product_name = eval('document.getElementById("product_name' + r +'")');
					</cfif>
	
					<cfif ListFind(ListDeleteDuplicates(xml_order_list_rows),24) and x_is_required_physical_asset eq 1>
						deger_asset = document.getElementById("asset"+r);
					</cfif>
					deger_total = document.getElementById("total"+r);
					if(document.getElementById("authorized"+r) != undefined) harcama_yapan = document.getElementById("authorized"+r); else harcama_yapan="";
					if(document.getElementById("company"+r) != undefined) harcama_yapan_firma = document.getElementById("company"+r); else harcama_yapan_firma="";
					if(deger_row_kontrol.value == 1)
					{
						record_exist=1;
						if (document.getElementById("expense_date"+r)!= undefined && document.getElementById("expense_date"+r).value == "")
						{
							alert ("<cf_get_lang_main no='810.Lütfen Tarih giriniz'>  !");
							return false;
						}
						if (deger_row_detail.value == "")
						{
							alert ("<cf_get_lang no='1073.Lütfen Açıklama Giriniz '>!");
							return false;
						}
						<cfif ListFind(ListDeleteDuplicates(xml_order_list_rows),24) and x_is_required_physical_asset eq 1>
							if (deger_asset.value == "")
							{
								alert ("<cf_get_lang_main no='1423.Lütfen Fiziki Varlık Giriniz'>!");
								return false;
							}
						</cfif>
						if (deger_total.value == "")
						{
							alert ("<cf_get_lang_main no='1738.Lütfen Tutar Giriniz '>!");
							return false;
						}
						if (deger_total.value == 0)
						{
							alert ("<cf_get_lang_main no='1738.Lütfen Tutar Giriniz'>");
							deger_total.value = commaSplit(deger_total.value,'#xml_satir_number#');
							return false;
						}
						if(harcama_yapan=="" && harcama_yapan_firma=="")
						{
							if(document.getElementById("member_type"+r) != undefined) document.getElementById("member_type"+r).value="";
							if(document.getElementById("company_id"+r) != undefined) document.getElementById("company_id"+r).value="";
							if(document.getElementById("member_id"+r) != undefined) document.getElementById("member_id"+r).value="";
							if(document.getElementById("company"+r) != undefined) document.getElementById("company"+r).value="";
						}
						<!---Muhasebe hesabı alt hesaplar gelirken üst hesapların yazılamaması kontrolü--->
						var action_account_code = document.getElementById("account_code"+r).value;
						if(action_account_code != "")
						{
								if(WrkAccountControl(action_account_code,r+'.Satır: Muhasebe Hesabı Hesap Planında Tanımlı Değildir!') == 0)
								return false;
						}
						<cfif ListFind(ListDeleteDuplicates(xml_order_list_rows),6)>
							if(document.getElementById("product_id"+r).value !="" && document.getElementById("product_name"+r).value != "" && (document.getElementById("department_id").value == "" || document.getElementById("department_name").value == ""))
							{
								alert ("<cf_get_lang no='852.Depo Girmelisiniz'> !");
								return false;
							}
						</cfif>
	
						if(document.getElementById("otv_rate"+r) != undefined && document.getElementById("otv_rate"+r).value > 0 && !list_find(otv_list,document.getElementById("otv_rate"+r).value))
							otv_list+= document.getElementById("otv_rate"+r).value+',';
	
						<cfif x_is_project_priority eq 1>
							if ((deger_product_id != undefined && deger_product_id.value == "") || (deger_product_name != undefined && deger_product_name.value == ""))
							{
								alert("Ürün Seçiniz!");
								return false;
							}
	
							if(deger_product_id != undefined)
							{
								var get_urun_kalem = wrk_safe_query("obj_get_urun_kalem","dsn3","1",deger_product_id.value);
								var urun_record_ = get_urun_kalem.recordcount;
								if(urun_record_<1)
								{
									alert('Ürün Gider Kalemi Bulunamadı!');
									return false;
								}
								else
								{
									document.getElementById("expense_item_id"+r).value = get_urun_kalem.EXPENSE_ITEM_ID;
									document.getElementById("expense_item_name"+r).value = 'Gider Kalemi';
								}
							}
	
							if (deger_project.value == "" || deger_project_name.value == "")
							{
								alert ("Proje Seçiniz!");
								return false;
							}
							var get_proje_merkez = wrk_safe_query("obj_get_proje_merkez","dsn","1",deger_project.value);
							var proje_record_ = get_proje_merkez.recordcount;
							if(proje_record_<1 || get_proje_merkez.EXPENSE_CODE =='' || get_proje_merkez.EXPENSE_CODE==undefined)
							{
								alert('Proje Masraf Merkezi Bulunamadı!');
								return false;
							}
							else
							{
								var get_code = wrk_safe_query("obj_get_code","dsn2","1",get_proje_merkez.EXPENSE_CODE);
								if(get_code.recordcount > 0 && get_code.EXPENSE_ID != undefined && get_code.EXPENSE_ID != '')
									document.getElementById("expense_center_id"+r).value = get_code.EXPENSE_ID;
								else
									document.getElementById("expense_center_id"+r).value = "";
								document.getElementById("expense_center_name"+r).value = 'Masraf Merkezi';
							}
						</cfif>
	
						if (document.getElementById("expense_center_id"+r).value == "" || document.getElementById("expense_center_name"+r).value == "")
						{
							alert ("<cf_get_lang no='1069.Lütfen Masraf Merkezi Seçiniz '>!");
							return false;
						}
	
						if (document.getElementById("expense_item_id"+r).value == "" || document.getElementById("expense_item_name"+r).value == "")
						{
							alert ("<cf_get_lang no='1071.Lütfen Gider Kalemi Seçiniz'> !");
							return false;
						}
						if(document.getElementById("tax_rate"+r) != undefined && document.getElementById("kdv_total"+r) != undefined)
						{
							if(document.getElementById("tevkifat_oran") != undefined && document.getElementById("tevkifat_oran").value != "" && document.getElementById("tevkifat_box").checked == true && document.getElementById("expense_cost_type").value != 122)
							{//tevkifat hesaplamaları
								if(new_taxArray.length != 0)
									for (var m=0; m < new_taxArray.length; m++)
									{
										var tax_flag = false;
										if(new_taxArray[m] == document.getElementById("tax_rate"+r).value){
											tax_flag = true;
											taxBeyanArray[m] += wrk_round(filterNum(document.getElementById("kdv_total"+r).value,'#xml_satir_number#') - (filterNum(document.getElementById("kdv_total"+r).value,'#xml_satir_number#')*(filterNum(document.getElementById("tevkifat_oran").value,8))));
											taxTevkifatArray[m] += wrk_round(filterNum(document.getElementById("kdv_total"+r).value,'#xml_satir_number#')*(filterNum(document.getElementById("tevkifat_oran").value,8)));
											break;
										}
									}
								if(!tax_flag){
									new_taxArray[new_taxArray.length] = document.getElementById("tax_rate"+r).value;
									taxBeyanArray[taxBeyanArray.length] = wrk_round(filterNum(document.getElementById("kdv_total"+r).value,'#xml_satir_number#') - (filterNum(document.getElementById("kdv_total"+r).value,'#xml_satir_number#')*(filterNum(document.getElementById("tevkifat_oran").value,8))));
									taxTevkifatArray[taxTevkifatArray.length] = wrk_round(filterNum(document.getElementById("kdv_total"+r).value,'#xml_satir_number#')*(filterNum(document.getElementById("tevkifat_oran").value,8)));
								}
							}
						}
					}
				}
				if (record_exist == 0)
				{
					alert("<cf_get_lang no='1068.Lütfen Masraf Fişine Satır Ekleyiniz'> !");
					return false;
				}
				otv_list = otv_list.substr(0,otv_list.length-1);
				if(otv_list != "")
				{
					var otv_control = wrk_safe_query("obj_otv_control",'dsn3',0,otv_list);
					if(otv_control.recordcount != list_len(otv_list))
					{
						alert("<cf_get_lang no ='1365.Seçtiğiniz ÖTV Değerlerinin İçinde Tanımlı Olmayan ÖTV ler var'> !");
						return false;
					}
				}
				change_due_date();
				if(document.getElementById("expense_cost_type").value == 122 && check_stock_action('add_costplan'))//üründe sıfır stok kontrolü
				{
					var temp_process_cat = document.getElementById("process_cat").options[document.getElementById("process_cat").selectedIndex].value;
					var temp_process_type = document.getElementById("ct_process_type_" + temp_process_cat);
					if(document.getElementById("department_id") != undefined && document.getElementById("department_id").value != "" && document.getElementById("location_id") != undefined && document.getElementById("location_id").value != "")
						if(!zero_stock_control(document.getElementById("department_id").value,document.getElementById("location_id").value,document.getElementById("expense_id").value,temp_process_type.value)) return false;
				}
				var control_credit_card = wrk_safe_query("obj_ctrl_cd","dsn3",1,<cfoutput>#get_expense.expense_id#</cfoutput>);
				if(control_credit_card.recordcount > 0 && control_credit_card.CLOSED_AMOUNT > 0)
				{
					alert("Kredi Kartı Ödemesi Yapıldığı İçin,Ödeme İşlemini Geri Almadan İşlemi Güncelleyemezsiniz!");
					return false;
				}
				if(document.getElementById("tevkifat_oran") != undefined && document.getElementById("tevkifat_oran").value != "" && document.getElementById("tevkifat_box").checked == true && document.getElementById("expense_cost_type").value != 122)
				{
					for (var tt=0; tt < new_taxArray.length; tt++)
					{
						document.getElementById("hidden_fields").innerHTML += '<input type="hidden" id="basket_tax_'+tt+'" name="basket_tax_'+tt+'" value="'+new_taxArray[tt]+'">';
						document.getElementById("hidden_fields").innerHTML += '<input type="hidden" id="basket_tax_value_'+tt+'" name="basket_tax_value_'+tt+'" value="'+taxBeyanArray[tt]+'">';
						document.getElementById("hidden_fields").innerHTML += '<input type="hidden" id="tevkifat_tutar_'+tt+'" name="tevkifat_tutar_'+tt+'" value="'+taxTevkifatArray[tt]+'">';
					}
				}
				return unformat_fields();
				return true;
			}
			function other_calc(row_info,type_info)
			{
				if(row_info != undefined)
				{
					if(document.getElementById("row_kontrol"+row_info).value==1)
					{
						if(document.getElementById("money_id"+row_info) != undefined)
						{
							deger_money_id = list_getat(document.getElementById("money_id"+row_info).value,1,',');
							for(kk=1;kk<=document.getElementById("kur_say").value;kk++)
							{
								money_deger =list_getat(document.add_costplan.rd_money[kk-1].value,1,',');
								if(money_deger == deger_money_id)
								{
									deger_diger_para_satir = document.add_costplan.rd_money[kk-1];
									form_value_rate_satir = document.getElementById("txt_rate2_"+kk);
								}
							}
							if(document.getElementById("other_net_total"+row_info) != undefined) document.getElementById("other_net_total"+row_info).value = filterNum(document.getElementById("other_net_total"+row_info).value,'#xml_satir_number#');
							if(document.getElementById("net_total"+row_info) != undefined) document.getElementById("net_total"+row_info).value = document.getElementById("other_net_total"+row_info).value*filterNum(form_value_rate_satir.value,'#session.ep.our_company_info.rate_round_num#');
							if(document.getElementById("otv_rate"+row_info) != undefined) 
								var otv_rate = document.getElementById("otv_rate"+row_info).value;
							else
								var otv_rate = 0;
							<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>
								var tax_multiplier = 100/(100+ + otv_rate + +filterNum(document.getElementById("tax_rate"+row_info).value,'#xml_satir_number#'));
							<cfelse>
								var tax_multiplier = (100/(100+ + otv_rate )*100/(100+ +filterNum(document.getElementById("tax_rate"+row_info).value,'#xml_satir_number#')));
							</cfif>
							if(document.getElementById("other_net_total_kdvsiz"+row_info) != undefined) document.getElementById("other_net_total_kdvsiz"+row_info).value = document.getElementById("other_net_total"+row_info).value*tax_multiplier;
							if(document.getElementById("other_net_total"+row_info) != undefined ) document.getElementById("other_net_total"+row_info).value = commaSplit(document.getElementById("other_net_total"+row_info).value,'#xml_satir_number#');
							if(document.getElementById("net_total"+row_info) != undefined) document.getElementById("net_total"+row_info).value = commaSplit(document.getElementById("net_total"+row_info).value,'#xml_satir_number#');
							if(document.getElementById("other_net_total_kdvsiz"+row_info) != undefined) document.getElementById("other_net_total_kdvsiz"+row_info).value = commaSplit(document.getElementById("other_net_total_kdvsiz"+row_info).value,'#xml_satir_number#');
						}
					}
					if(type_info==undefined)
						hesapla('other_net_total',row_info,2);
					else
						hesapla('other_net_total',row_info,2,type_info);
				}
				else
				{
					for(yy=1;yy<=document.getElementById("record_num").value;yy++)
					{
						if(document.getElementById("row_kontrol"+yy).value==1)
						{
							other_calc(yy,1);
						}
					}
					toplam_hesapla();
				}
			}
			function other_calc_kdvsiz(row_info,type_info)
			{
				if(row_info != undefined)
				{
					if(document.getElementById("row_kontrol"+row_info).value==1)
					{
						if(document.getElementById("money_id"+row_info) != undefined)
						{
							deger_money_id = list_getat(document.getElementById("money_id"+row_info).value,1,',');
							for(kk=1;kk<=document.getElementById("kur_say").value;kk++)
							{
								money_deger =list_getat(document.add_costplan.rd_money[kk-1].value,1,',');
								if(money_deger == deger_money_id)
								{
									deger_diger_para_satir = document.add_costplan.rd_money[kk-1];
									form_value_rate_satir = document.getElementById("txt_rate2_"+kk);
								}
							}
							if(document.getElementById("other_net_total_kdvsiz"+row_info) != undefined) document.getElementById("other_net_total_kdvsiz"+row_info).value = filterNum(document.getElementById("other_net_total_kdvsiz"+row_info).value,'#xml_satir_number#');
							if(document.getElementById("otv_rate"+row_info) != undefined) 
								var otv_rate = document.getElementById("otv_rate"+row_info).value;
							else
								var otv_rate = 0;
							<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>
								var tax_multiplier = 100/(100+ + otv_rate + +filterNum(document.getElementById("tax_rate"+row_info).value,'#xml_satir_number#'));
							<cfelse>
								var tax_multiplier = (100/(100+ + otv_rate )*100/(100+ +filterNum(document.getElementById("tax_rate"+row_info).value,'#xml_satir_number#')));
							</cfif>
							if(document.getElementById("other_net_total"+row_info) != undefined) document.getElementById("other_net_total"+row_info).value = document.getElementById("other_net_total_kdvsiz"+row_info).value/tax_multiplier;
							if(document.getElementById("net_total"+row_info) != undefined) document.getElementById("net_total"+row_info).value = document.getElementById("other_net_total"+row_info).value*filterNum(form_value_rate_satir.value,'#session.ep.our_company_info.rate_round_num#');
							if(document.getElementById("net_total"+row_info) != undefined) document.getElementById("net_total"+row_info).value = commaSplit(document.getElementById("net_total"+row_info).value,'#xml_satir_number#');
							if(document.getElementById("other_net_total"+row_info) != undefined) document.getElementById("other_net_total"+row_info).value = commaSplit(document.getElementById("other_net_total"+row_info).value,'#xml_satir_number#');
							if(document.getElementById("other_net_total_kdvsiz"+row_info) != undefined) document.getElementById("other_net_total_kdvsiz"+row_info).value = commaSplit(document.getElementById("other_net_total_kdvsiz"+row_info).value,'#xml_satir_number#');
						}
					}
					if(type_info==undefined)
						hesapla('other_net_total_kdvsiz',row_info,2);
					else
						hesapla('other_net_total_kdvsiz',row_info,2,type_info);
				}
				else
				{
					for(yy=1;yy<=document.getElementById("record_num").value;yy++)
					{
						if(document.getElementById("row_kontrol"+yy).value==1)
						{
							other_calc(yy,1);
						}
					}
					toplam_hesapla();
				}
			}
		</cfoutput>
	</script>
</cfif>
<script type="text/javascript">
		function add_adress()
		{
			if(document.getElementById("ch_company_id").value=="" || document.getElementsByName("ch_consumer_id").value=="" || document.getElementById("ch_company").value=="")
			{
				alert('Cari Hesap Seçmelisiniz');
				return false;
			}
			else
			{
				if(document.getElementsByName("ch_company_id").value!="")
				{

					str_adrlink = '&field_long_adres=add_costplan.adres&field_adress_id=add_costplan.ship_address_id&is_compname_readonly=1';
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(add_costplan.ch_company.value)+''+ str_adrlink , 'list');
					return true;
				}
				else
				{
					str_adrlink = '&field_long_adres=add_costplan.adres&field_adress_id=add_costplan.ship_address_id&is_compname_readonly=1';
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(add_costplan.ch_partner.value)+''+ str_adrlink , 'list');
					return true;
				}
			}
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
		function unformat_fields()
		{
			for(r=1;r<=document.getElementById("record_num").value;r++)
			{
				if(document.getElementById("total"+r) != undefined) deger_total = document.getElementById("total"+r); else deger_total="";
				if(document.getElementById("quantity"+r) != undefined) deger_quantity = document.getElementById("quantity"+r); else deger_quantity="";
				if(document.getElementById("kdv_total"+r) != undefined) deger_kdv_total= document.getElementById("kdv_total"+r); else deger_kdv_total="";
				if(document.getElementById("otv_total"+r) != undefined) deger_otv_total= document.getElementById("otv_total"+r); else deger_otv_total="";
				if(document.getElementById("net_total"+r) != undefined) deger_net_total = document.getElementById("net_total"+r); else deger_net_total="";
				if(document.getElementById("other_net_total"+r) != undefined) deger_other_net_total = document.getElementById("other_net_total"+r); else deger_other_net_total="";
				
				if(deger_total != "") deger_total.value = filterNum(deger_total.value,'#xml_satir_number#');
				if(deger_quantity != "") deger_quantity.value = filterNum(deger_quantity.value,'#xml_satir_number#');
				if(deger_kdv_total != "") deger_kdv_total.value = filterNum(deger_kdv_total.value,'#xml_satir_number#');
				if(deger_otv_total != "") deger_otv_total.value = filterNum(deger_otv_total.value,'#xml_satir_number#');
				if(deger_net_total != "") deger_net_total.value = filterNum(deger_net_total.value,'#xml_satir_number#');
				if(deger_other_net_total != "") deger_other_net_total.value = filterNum(deger_other_net_total.value,'#xml_satir_number#');
			}
			document.getElementById("stopaj_yuzde").value = filterNum(document.getElementById("stopaj_yuzde").value,'#xml_genel_number#');
			document.getElementById("stopaj").value = filterNum(document.getElementById("stopaj").value,'#xml_genel_number#');
			document.getElementById("yuvarlama").value = filterNum(document.getElementById("yuvarlama").value,'#xml_genel_number#');
			document.getElementById("total_amount").value = filterNum(document.getElementById("total_amount").value,'#xml_genel_number#');
			document.getElementById("kdv_total_amount").value = filterNum(document.getElementById("kdv_total_amount").value,'#xml_genel_number#');
			document.getElementById("otv_total_amount").value = filterNum(document.getElementById("otv_total_amount").value,'#xml_genel_number#');
			document.getElementById("net_total_amount").value = filterNum(document.getElementById("net_total_amount").value,'#xml_genel_number#');
			document.getElementById("other_total_amount").value = filterNum(document.getElementById("other_total_amount").value,'#xml_genel_number#');
			document.getElementById("other_kdv_total_amount").value = filterNum(document.getElementById("other_kdv_total_amount").value,'#xml_genel_number#');
			document.getElementById("other_otv_total_amount").value = filterNum(document.getElementById("other_otv_total_amount").value,'#xml_genel_number#');
			document.getElementById("other_net_total_amount").value = filterNum(document.getElementById("other_net_total_amount").value,'#xml_genel_number#');
			<cfif not IsDefined("attributes.event") or (IsDefined("attributes.event") and attributes.event eq 'add')>
				<cfif not fuseaction contains "assetcare">
					if(document.getElementById("tevkifat_oran") != undefined)	document.getElementById("tevkifat_oran").value = filterNum(document.getElementById("tevkifat_oran").value,8);
				</cfif>
			<cfelse>
				if(document.getElementById("expense_cost_type").value != 122)
				document.getElementById("tevkifat_oran").value = filterNum(document.getElementById("tevkifat_oran").value,8);
			</cfif>
			for(s=1;s<=document.getElementById("kur_say").value;s++)
			{
				document.getElementById("txt_rate2_" + s).value = filterNum(document.getElementById("txt_rate2_" + s).value,'#session.ep.our_company_info.rate_round_num#');
				document.getElementById("txt_rate1_" + s).value = filterNum(document.getElementById("txt_rate1_" + s).value,'#session.ep.our_company_info.rate_round_num#');
			}
			return true;
		}
		function change_due_date(type)
		{
			if (type==1)
				document.getElementById("basket_due_value").value = datediff(document.getElementById("expense_date").value,document.getElementById("basket_due_value_date_").value,0);
			else
			{
				if(isNumber(document.getElementById("basket_due_value"))!= false && (document.getElementById("basket_due_value").value != 0))
					document.getElementById("basket_due_value_date_").value = date_add('d',+document.getElementById("basket_due_value").value,document.getElementById("expense_date").value);
				else
					document.getElementById("basket_due_value_date_").value = document.getElementById("expense_date").value;
			}
		}
		function enterControl(e,objeName,ObjeRowNumber,hesapType)//Basket alanlarının içindeyken enter tuşuna basıldığında hesapla fonksiyonunu çağırmıyordu. Bu nedenle eklendi.
		{
			if(e.keyCode == 13)
			{	
				if(hesapType == undefined)
				{
					hesapla(objeName,ObjeRowNumber);
				}
				else
				{
					hesapla(objeName,ObjeRowNumber,hesapType);
				}
			}
		}
</script>
<cfif isdefined("attributes.event") and  attributes.event eq 'upd'>
	<cfif len(get_expense.paymethod_id)>
		<cfset attributes.expense_paymethod_id = get_expense.paymethod_id>
	</cfif>
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
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'cost.form_add_expense_cost';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'objects/form/form_add_expense_cost.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'objects/query/add_collacted_expense_cost.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'cost.form_add_expense_cost&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('add_cost','list_plan_rows_cost_div')";
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'cost.form_add_expense_cost';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'objects/form/form_add_expense_cost.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'objects/query/upd_collacted_expense_cost.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'cost.form_add_expense_cost&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'expense_id=##attributes.expense_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.expense_id##';
	
	if(attributes.event is 'add')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['text'] = '#lang_array_main.item[1114]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['onClick'] = "openBox('#request.self#?fuseaction=objects.popup_add_collacted_from_file&type=2',this)";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	if(IsDefined("attributes.event") and (attributes.event is 'upd' or attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'cost.form_add_expense_cost';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'objects/query/del_collacted_expense_cost.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'objects/query/del_collacted_expense_cost.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'cost.form_add_expense_cost';
	}
	
	
	if(IsDefined("attributes.event") && attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1966]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['customTag'] = '<cf_get_workcube_related_acts period_id="#session.ep.period_id#" company_id="#session.ep.company_id#" asset_cat_id="-17" module_id="49" action_section="EXPENSE_ID" action_id="#attributes.expense_id#">';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[1040]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=#modulename#.popup_list_order_account_cards&expense_id=#attributes.expense_id#','page','add_process')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = 'Ek Bilgi';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#attributes.expense_id#&type_id=-17','page','add_process')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['text'] = 'Uyarılar';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=cost.form_upd_expense_cost&action_name=expense_id&action_id=#attributes.expense_id#','page','add_process')";
		
		if(get_efatura_det.recordcount)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['text'] = 'Uyarılar';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_dsp_efatura_detail&receiving_detail_id=#get_efatura_det.receiving_detail_id#&type=1','page','add_process')";
		}
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=cost.form_add_expense_cost";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = '#request.self#?fuseaction=cost.form_add_expense_cost&expense_id=#attributes.expense_id#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#expense_id#&print_type=230','page')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	} 
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'expenseCost';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'EXPENSE_ITEM_PLANS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-1','item-4','item-6','item-7']";
</cfscript>
