<cf_xml_page_edit fuseact="objects.income_cost">
<cf_get_lang_set module_name="objects">
<cfset tahsil = lang_array.item[1093]>
<cfset belget = lang_array.item[813]>
<cfparam name="attributes.expense_bank_id" default="" >
<cfif fusebox.circuit eq "store">
	<cfset modulename = "store">
<cfelse>
	<cfset modulename = "objects">
</cfif>
<cfquery name="GET_DOCUMENT_TYPE" datasource="#dsn#">
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
<cfquery name="KASA" datasource="#dsn2#">
	SELECT
		*
	FROM
		CASH
	WHERE
		CASH_ACC_CODE IS NOT NULL
	<cfif listgetat(attributes.fuseaction,1,'.') is 'store'>
		AND (BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">)
	</cfif>
	ORDER BY
		CASH_NAME
</cfquery>
<cfif isdefined("get_expense") and len(get_expense.paymethod_id)>
    <cfquery name="get_pay_meyhod" datasource="#dsn#">
        SELECT PAYMETHOD FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_expense.paymethod_id#">
    </cfquery>
<cfelse>
	<cfset get_pay_meyhod.PAYMETHOD = "">
</cfif>
<cfif isdefined("attributes.expense_id") and len(attributes.expense_id)>
	<cfquery name="GET_EXPENSE" datasource="#dsn2#">
        SELECT 
            EIP.*
            <cfif IsDefined("attributes.event") and attributes.event eq 'upd'>
                ,SPC.INVOICE_TYPE_CODE
            </cfif>
        FROM 
            EXPENSE_ITEM_PLANS EIP
            <cfif IsDefined("attributes.event") and attributes.event eq 'upd'>
                ,#dsn3_alias#.SETUP_PROCESS_CAT SPC
            </cfif> 
        WHERE 
            <cfif IsDefined("attributes.event") and attributes.event eq 'upd'>
                EIP.PROCESS_CAT = SPC.PROCESS_CAT_ID AND
            </cfif>
            EIP.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
    </cfquery>
<!--- Gelir Fisi Kopyalama --->
	<cfquery name="get_rows" datasource="#dsn2#"><!--- Gelir Satirlari --->
        SELECT * FROM EXPENSE_ITEMS_ROWS WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#"> ORDER BY EXP_ITEM_ROWS_ID
    </cfquery>
<cfelse>
	<cfset get_rows.recordcount = 0>
</cfif>
<cfif not IsDefined("attributes.event") or (IsDefined("attributes.event") and attributes.event eq 'add')>
	<cfparam name="attributes.expense_employee" default="#session.ep.name# #session.ep.surname#">
    <cfparam name="attributes.expense_employee_id" default="#session.ep.userid#">
    <cfquery name="GET_ACTIVITY_TYPES" datasource="#dsn#">
        SELECT ACTIVITY_ID, ACTIVITY_NAME FROM SETUP_ACTIVITY ORDER BY ACTIVITY_NAME
    </cfquery>
    <cfif isdefined("attributes.expense_id") and len(attributes.expense_id)><!--- Gelir Fisi Kopyalama --->
        <cfquery name="get_money" datasource="#dsn2#">
            SELECT MONEY_TYPE AS MONEY,* FROM EXPENSE_ITEM_PLANS_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
        </cfquery>
        <cfif not get_money.recordcount>
            <cfquery name="get_money" datasource="#dsn#">
                SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
            </cfquery>
        </cfif>
    <cfelse>
        <cfquery name="GET_MONEY" datasource="#dsn#">
            SELECT *,0 AS IS_SELECTED FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.PERIOD_ID#"> AND MONEY_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> ORDER BY MONEY_ID
        </cfquery>
    </cfif>
    
    <cfif isdefined("get_expense")>
        <cfset expense_bank_id = get_expense.expense_cash_id>
        <cfset expense_branch_id = get_expense.branch_id>
    <cfelse>
        <cfset expense_bank_id = ''>
        <cfset expense_branch_id = ''>
    </cfif>
    <cfquery name="get_standart_process_money" datasource="#dsn#"><!--- muhasebe doneminden standart islem dövizini alıyor --->
        SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
    </cfquery>
    <script type="text/javascript">
		$( document ).ready(function() {
			<cfif isdefined("attributes.expense_id") and len(attributes.expense_id)>
				var row_count=<cfoutput>#get_rows.recordcount#</cfoutput>;
			<cfelse>
				var row_count=0;
			</cfif>
		});
		<cfoutput>
			function hesapla(field_name,satir,hesap_type,extra_type)
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
					if(document.getElementById("money_id"+satir) != undefined)
					{
						deger_money_id = document.getElementById("money_id"+satir);
						deger_money_id =  list_getat(deger_money_id.value,1,',');
						for(s=1;s<=document.getElementById("kur_say").value;s++)
						{
							money_deger =list_getat(document.all.rd_money[s-1].value,1,',');
							if(money_deger == deger_money_id)
							{
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
					if(hesap_type ==undefined)
					{
						if(deger_kdv_total != "" && deger_total != "") deger_kdv_total.value = ((parseFloat(deger_total.value) * parseFloat(deger_quantity.value)) * deger_tax_rate.value)/100;
						if(deger_otv_total != "" && deger_total != "") deger_otv_total.value = ((parseFloat(deger_total.value) * parseFloat(deger_quantity.value)) * deger_otv_rate.value)/100;
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
						
						if(deger_total != "" && deger_tax_rate != "") deger_total.value = ((parseFloat(deger_net_total.value)/parseFloat(deger_quantity.value))*100)/ (parseFloat(tax_rate_)+parseFloat(otv_rate_)+100);
						if(deger_kdv_total != "" && deger_total != "") deger_kdv_total.value = (parseFloat(deger_total.value * deger_quantity.value * deger_tax_rate.value))/100;
						if(deger_otv_total != "" && deger_total != "") deger_otv_total.value = (parseFloat(deger_total.value * deger_quantity.value * deger_otv_rate.value))/100;
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
				}
				if(extra_type == 2 || extra_type == undefined)
					toplam_hesapla(extra_type);
			}
			function toplam_hesapla(type)
			{
				var toplam_dongu_1 = 0;//tutar genel toplam
				var toplam_dongu_2 = 0;// kdv genel toplam
				var toplam_dongu_3 = 0;// kdvli genel toplam
				var toplam_dongu_4 = 0;// ötv genel toplam
				if(type != 2)
					doviz_hesapla();
				for(r=1; r<= document.getElementById("record_num").value;r++)
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
					
						if(deger_total != "") deger_total.value = filterNum(deger_total.value,'#xml_satir_number#');
						if(deger_quantity != "") deger_quantity.value = filterNum(deger_quantity.value,'#xml_satir_number#');
						if(deger_kdv_total != "") deger_kdv_total.value = filterNum(deger_kdv_total.value,'#xml_satir_number#');
						
						if(document.getElementById("tax_rate"+r) != undefined && document.getElementById("kdv_total"+r) != undefined)
						{
							if(document.getElementById("tevkifat_oran") != undefined && document.getElementById("tevkifat_oran").value != "" && document.getElementById("tevkifat_box").checked == true && document.getElementById("expense_cost_type").value != 122)
							{//tevkifat hesaplamaları
								
								beyan_tutar = beyan_tutar + wrk_round(deger_kdv_total.value*filterNum(document.getElementById("tevkifat_oran").value)/100);
								if(new_taxArray.length != 0)
									for (var m=0; m < new_taxArray.length; m++)
									{	
										var tax_flag = false;
										if(new_taxArray[m] == deger_tax_rate.value){
											tax_flag = true;
											taxBeyanArray[m] += wrk_round(deger_kdv_total.value - (deger_kdv_total.value*(filterNum(document.getElementById("tevkifat_oran").value)/100)));
											taxTevkifatArray[m] += wrk_round(deger_kdv_total.value*(filterNum(document.getElementById("tevkifat_oran").value)/100));
											break;
										}
									}
								if(!tax_flag){
									new_taxArray[new_taxArray.length] = deger_tax_rate.value;
									taxBeyanArray[taxBeyanArray.length] = wrk_round(deger_kdv_total.value - (deger_kdv_total.value*(filterNum(document.getElementById("tevkifat_oran").value)/100)));
									taxTevkifatArray[taxTevkifatArray.length] = wrk_round(deger_kdv_total.value*(filterNum(document.getElementById("tevkifat_oran").value)/100));
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
				if(type == undefined || parseFloat(document.getElementById("stopaj_yuzde").value) == 0)
					stopaj_ = wrk_round((toplam_dongu_1 * parseFloat(document.getElementById("stopaj_yuzde").value) / 100),'#xml_genel_number#');
				else
					stopaj_ = filterNum(document.getElementById("stopaj").value);
					
				document.getElementById("stopaj_yuzde").value = commaSplit(parseFloat(document.getElementById("stopaj_yuzde").value));
				document.getElementById("stopaj").value = commaSplit(stopaj_,'#xml_genel_number#');
				
				toplam_dongu_3 = toplam_dongu_3-parseFloat(stopaj_);	
				
				document.getElementById("total_amount").value = commaSplit(toplam_dongu_1,'#xml_genel_number#');
				document.getElementById("kdv_total_amount").value = commaSplit(toplam_dongu_2,'#xml_genel_number#');
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
						if(document.add_costplan.rd_money[s-1].checked == true)
						{
							deger_diger_para = document.getElementById("rd_money");
							form_txt_rate2_ = document.getElementById("txt_rate2_"+s);
						}
					}
				else 
					for(s=1;s<=document.getElementById("kur_say").value;s++)
					{
						if(document.add_costplan.rd_money[s-1] != undefined && document.add_costplan.rd_money[s-1].checked == true)
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
				document.getElementById("other_net_total_amount").value = commaSplit(toplam_dongu_3 * parseFloat(deger_money_id_3) / (parseFloat(filterNum(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#'),'#session.ep.our_company_info.rate_round_num#')),'#xml_genel_number#');
				document.getElementById("tl_value1").value = deger_money_id_1;
				document.getElementById("tl_value2").value = deger_money_id_1;
				document.getElementById("tl_value3").value = deger_money_id_1;
				//form_txt_rate2_.value = commaSplit(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#');
			}
			function doviz_hesapla(type)
			{ 
				for(k=1;k<=document.getElementById("record_num").value;k++)
				{		
					if(document.getElementById("money_id"+k) != undefined)
						deger_money_id = document.getElementById("money_id"+k);
					{
						deger_money_id =  list_getat(deger_money_id.value,1,',');
						for (var t=1; t<=document.getElementById("kur_say").value; t++)
						{
							money_deger =list_getat(document.add_costplan.rd_money[t-1].value,1,',');
							if(money_deger == deger_money_id)	
							{						
								rate2_value = filterNum(document.getElementById("txt_rate2_"+t).value,'#session.ep.our_company_info.rate_round_num#')/filterNum(document.getElementById("txt_rate1_"+t).value,'#session.ep.our_company_info.rate_round_num#');
								document.getElementById("other_net_total"+k).value = commaSplit(filterNum(document.getElementById("net_total"+k).value,'#xml_satir_number#')/rate2_value,'#xml_satir_number#');
							}
						}
					}
				}
			}
		</cfoutput>
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
			if(document.getElementById("ch_company").value == "" &&  document.getElementById("ch_partner").value == "" && document.getElementById("cash").checked == false && document.getElementById("bank").checked == false)
			{
				alert("<cf_get_lang no='1065.Cari, kasa veya banka işleminden birini seçiniz'>!");
				return false;
			}
			if(document.getElementById("bank").checked == true)
			{		
				if(!acc_control()) return false;
			}
			if (!chk_process_cat('add_costplan')) return false;
			if (!check_display_files('add_costplan')) return false;
			if (!chk_period(document.getElementById("expense_date"),"<cf_get_lang_main no ='280.İşlem'>")) return false;
			if(document.getElementById("expense_date").value == "")
			{
				alert("<cf_get_lang no='1064.Lütfen Harcama Tarihi Giriniz'>!");
				return false;
			}
			if(document.getElementById("expense_employee").value == "")
			{
				alert("<cf_get_lang no='1096.Lütfen Tahsil Eden Giriniz'>!");
				return false;
			}
			<cfif (session.ep.our_company_info.is_efatura eq 1) > //MCP tarafından #75351 numaralı iş için eklendi.e-Fatura kullanıyorsa gösterilecek 
				if(document.getElementById('ch_company_id') != undefined && document.getElementById('ch_company_id').value != '')
				{
					var comp_id =document.getElementById('ch_company_id').value;
                    $.ajax({
			        		url: '/V16/objects/cfc/einvoice.cfc?method=get_efatura_info',
			               	type : "get",
					        async: false,
					        data : {company_id :comp_id },
					        success: function(read_data) {
					        	data_ = jQuery.parseJSON(read_data.replace('//',''));
						        if(data_.DATA.length != 0)
						        {
					        		
					            $.each(data_.DATA,function(i){
					                
					                //query deki alan sırasına göre datalarınızı alabilir ve daha sonra istediğiniz kontrolü yapabilirsiniz
					                get_efatura_info= data_.DATA[i][0];
					               
					                
					            });

			        			}
						    }
						});	
					
					if(get_efatura_info == 1)															   
					{
						if(document.getElementById('ship_address_id').value =='' || document.getElementById('adres').value =='')
						{
							alert('Cari Şube Boş Geçilemez');
							return false;
						}
					}
				}
			</cfif>
			<cfif isdefined('x_select_project') and x_select_project eq 2> //xmlde muhasebe icin proje secimi zorunlu ise
					if(document.getElementById("project_head").value=='' || document.getElementById("project_id").value=='')
					{
						alert('Proje Seçiniz');
						return false;
					} 
				</cfif>
			record_exist=0;//Row_kontrol değeri 1 olan yani silinmemiş satırların varlığını kontrol ediyor
			for(r=1;r<=document.getElementById("record_num").value;r++)
			{
				deger_row_kontrol = document.getElementById("row_kontrol"+r);
				if(document.getElementById("expense_center_id"+r) != undefined) deger_expense_center_id = document.getElementById("expense_center_id"+r).value; else deger_expense_center_id ="";
				if(document.getElementById("expense_center_name"+r) != undefined) deger_expense_center_name = document.getElementById("expense_center_name"+r).value; else deger_expense_center_name ="";		
				if(document.getElementById("expense_item_id"+r) != undefined) deger_expense_item_id = document.getElementById("expense_item_id"+r).value; else deger_expense_item_id = "";
				if(document.getElementById("expense_item_name"+r) != undefined) deger_expense_item_name = document.getElementById("expense_item_name"+r).value; else deger_expense_item_name = "";		
				if(document.getElementById("row_detail"+r) != undefined) deger_row_detail = document.getElementById("row_detail"+r); else deger_row_detail = "";
				if(document.getElementById("authorized"+r) != undefined) harcama_yapan = document.getElementById("authorized"+r); else harcama_yapan="";
				if(document.getElementById("company"+r) != undefined) harcama_yapan_firma = document.getElementById("company"+r); else harcama_yapan_firma="";
				deger_total = document.getElementById("total"+r);
				
				<cfif x_is_project_priority eq 1>
					deger_project = document.getElementById("project_id"+r);
					deger_project_name = document.getElementById("project"+r);
					deger_product_id = document.getElementById("product_id"+r);
					deger_product_name = document.getElementById("product_name"+r);
				</cfif>
				
				
				if(deger_row_kontrol.value == 1)
				{
					record_exist=1;
					<cfif x_is_project_priority eq 1>
						if (deger_product_id.value == "" || deger_product_name.value == "")
						{ 
							alert ("<cf_get_lang_main no='313.Ürün Seçiniz'>");
							return false;
						}
						
						var get_urun_kalem = wrk_safe_query("obj_get_urun_kalem","dsn3","1", deger_product_id.value);
						var urun_record_ = get_urun_kalem.recordcount;
						if(urun_record_<1)
						{
							alert("<cf_get_lang no='1877.Ürün Gider Kalemi Bulunamadı'>");
							return false;
						}
						else
						{
							document.getElementById("expense_item_id"+r).value = get_urun_kalem.EXPENSE_ITEM_ID;
						}
								
						if (urun_record_==1 && document.getElementById("expense_item_id"+r).value == '')		
						{
							alert("<cf_get_lang no='1874.Seçmiş Olduğunuz Ürün Dağıtıma Tabidir Başka Bir Ürün Seçmeniz Gerekir'>!");
							return false;
						}
						if (deger_project.value == "" || deger_project_name.value == "")
						{ 
							alert ("<cf_get_lang_main no='1385.Proje Seçiniz'>");
							return false;
						}
						var get_proje_merkez = wrk_safe_query("obj_get_proje_merkez","dsn","1", deger_project.value);
						var proje_record_ = get_proje_merkez.recordcount;
						if(proje_record_<1 || get_proje_merkez.EXPENSE_CODE =='' || get_proje_merkez.EXPENSE_CODE==undefined)
						{
							alert("<cf_get_lang no='1875.Proje Masraf Merkezi Bulunamadı'>");
							return false;
						}
						else
						{
							var get_code = wrk_safe_query("obj_get_code","dsn2","1",get_proje_merkez.EXPENSE_CODE);
							document.getElementById("expense_center_id"+r).value = get_code.EXPENSE_ID;
						}			
					</cfif>
					<cfif x_is_project_priority eq 0>
						if (deger_expense_center_id == "" || deger_expense_center_name == "")
						{ 
							alert ("<cf_get_lang no='1098.Lütfen Gelir Merkezi Seçiniz'>");
							return false;
						}	
						if (deger_expense_item_id == "" || deger_expense_item_name == "")
						{ 
							alert ("<cf_get_lang no='1099.Lütfen Gelir Kalemi Seçiniz'>");
							return false;
						}	
					</cfif>	
					
					if (deger_row_detail == "")
					{ 
						alert ("<cf_get_lang no='1073.Lütfen Açıklama Giriniz'>");
						return false;
					}	
					if (deger_total.value == "")
					{ 
						alert ("<cf_get_lang_main no='1738.Lütfen Tutar Giriniz'>");
						return false;
					}	
					if (deger_total.value == 0)
					{ 
						alert ("<cf_get_lang_main no='1738.Lütfen Tutar Giriniz'>");
						return false;
					}
					if(harcama_yapan=="" && harcama_yapan_firma=="")
					{
						if(document.getElementById("member_type"+r) != undefined) document.getElementById("member_type"+r).value="";
						if(document.getElementById("company_id"+r) != undefined) document.getElementById("company_id"+r).value="";
						if(document.getElementById("member_id"+r) != undefined) document.getElementById("member_id"+r).value="";
						if(document.getElementById("company"+r) != undefined) document.getElementById("company"+r).value="";
					}
					//Muhasebe hesabı alt hesaplar gelirken üst hesapların yazılamaması kontrolü
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
					alert("<cf_get_lang no='1097.Lütfen Gelir Fişine Satır Ekleyiniz'> !");
					return false;
				}
			change_due_date();
			unformat_fields();
			return true;
		}
		
		$( document ).ready(function() {
		    toplam_hesapla();
		});
		
		<cfoutput>
			function other_calc(row_info,type_info)
			{
				if(row_info != undefined)
				{
					if(document.getElementById("row_kontrol"+row_info).value==1)
					{
						deger_money_id = list_getat(document.getElementById("money_id"+row_info).value,1,',');
						for(kk=1; kk<= document.getElementById("kur_say").value;kk++)
						{
							money_deger =list_getat(document.all.rd_money[kk-1].value,1,',');
							if(money_deger == deger_money_id)
							{
								deger_diger_para_satir = document.all.rd_money[kk-1];
								form_value_rate_satir = document.getElementById("txt_rate2_"+kk);
							}
						}
						//document.getElementById("other_net_total"+row_info).value = filterNum(document.getElementById("other_net_total"+row_info).value,'#xml_satir_number#');
						document.getElementById("net_total"+row_info).value = filterNum(document.getElementById("other_net_total"+row_info).value,'#xml_satir_number#')*filterNum(form_value_rate_satir.value,'#session.ep.our_company_info.rate_round_num#');
						//document.getElementById("other_net_total"+row_info).value = commaSplit(document.getElementById("other_net_total"+row_info).value,'#xml_satir_number#');
						document.getElementById("net_total"+row_info).value = commaSplit(document.getElementById("net_total"+row_info).value,'#xml_satir_number#');
					}
					if(type_info==undefined)
						hesapla('other_net_total',row_info,2);
					else
						hesapla('other_net_total',row_info,2,type_info);
				}
				else
				{
					for(yy=1; yy<= document.getElementById("record_num").value;yy++)
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
</cfif>

<cfif IsDefined("attributes.event") and attributes.event eq 'upd'>
	<cfquery name="GET_MONEY" datasource="#dsn#">
        SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">	ORDER BY MONEY_ID
    </cfquery>
    <cfquery name="GET_EXPENSE_MONEY" datasource="#dsn2#"><!--- expense money kayıtları --->
        SELECT MONEY_TYPE AS MONEY,* FROM EXPENSE_ITEM_PLANS_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
    </cfquery>
    <cfif not GET_EXPENSE_MONEY.recordcount>
        <cfquery name="GET_EXPENSE_MONEY" datasource="#DSN#">
            SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS=<cfqueryparam cfsqltype="cf_sql_smallint" value="1"> ORDER BY MONEY_ID
        </cfquery>
    </cfif>
   
     
    <cfquery name="CHK_SEND_INV" datasource="#dsn2#">
        SELECT COUNT(*) COUNT FROM EINVOICE_SENDING_DETAIL WHERE  ACTION_ID = #attributes.expense_id# AND ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE = 1
    </cfquery> 
    <cfquery name="CHK_SEND_ARC" datasource="#dsn2#">
        SELECT COUNT(*) COUNT FROM EARCHIVE_SENDING_DETAIL WHERE  ACTION_ID = #attributes.expense_id# AND ACTION_TYPE = 'EXPENSE_ITEM_PLANS' AND STATUS_CODE = 1
    </cfquery> 
    <cfif GET_EXPENSE.RECORDCOUNT eq 0>
        <script type="text/javascript">
            alert("<cf_get_lang no ='1369.Gelir Fişi Yok veya Silinmiş'>");
            history.go(-1);
        </script>
        <cfabort>
    </cfif>
    <cfif len(get_expense.ch_company_id) and get_expense.ch_company_id neq 0>
        <cfquery name="get_expense_COMP" datasource="#DSN#">
            SELECT 
                COMPANY_ID,
                COMPANYCAT_ID,
                TAXOFFICE,
                TAXNO,
                COMPANY_ADDRESS,
                COUNTY,
                CITY,
                COUNTRY,
                FULLNAME,
                COMPANY_TELCODE,
                COMPANY_TEL1,
                COMPANY_FAX,
                COMPANY_ADDRESS,
                COMPANY_EMAIL,
                MEMBER_CODE,
                IMS_CODE_ID,
                USE_EFATURA,
                EFATURA_DATE
            FROM
                COMPANY
            WHERE 
                COMPANY.COMPANY_ID = #get_expense.ch_company_id#
        </cfquery>
    <cfelseif len(get_expense.ch_consumer_id)>
        <cfquery name="GET_CONS_NAME" datasource="#DSN#">
            SELECT 
                CONSUMER_ID,
                CONSUMER_CAT_ID,
                COMPANY,
                MEMBER_CODE,
                TC_IDENTY_NO,
                CONSUMER_NAME,
                CONSUMER_SURNAME,
                CONSUMER_WORKTELCODE,
                CONSUMER_WORKTEL,
                CONSUMER_FAX,
                CONSUMER_EMAIL,
                MOBIL_CODE,
                MOBILTEL,
                TAX_ADRESS,
                TAX_CITY_ID,
                TAX_COUNTY_ID,
                TAX_COUNTRY_ID,
                TAX_NO,
                TAX_OFFICE,
                VOCATION_TYPE_ID,
                IMS_CODE_ID,
                USE_EFATURA,
                EFATURA_DATE
            FROM 
                CONSUMER
            WHERE 
                CONSUMER_ID = #get_expense.ch_consumer_id#
        </cfquery>		
	</cfif>
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
	<script type="text/javascript">
        $( document ).ready(function() {
            if(document.getElementById("cash").checked == true && document.getElementById("kasa") != undefined && document.getElementById("kasa").value != "")
                var branch_id_ = document.getElementById('kasa').value.split(';')[2];
            else
                var branch_id_ = '<cfoutput>#ListGetAt(session.ep.user_location,2,"-")#</cfoutput>';
              console.log(branch_id_);
            document.getElementById("branch_id_").value = branch_id_;
            // Odeme plani icin sube bilgisi
            row_count=<cfoutput>#get_rows.recordcount#</cfoutput>;
            change_due_date();
        });
        // Odeme plani icin sube bilgisi
        
        function  auto_project(no)
        {
            AutoComplete_Create('project'+no,'PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id'+no ,'','3','200');
        }
        
        
        <cfoutput>
        function hesapla(field_name,satir,hesap_type,extra_type)
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
                if(document.getElementById("money_id"+satir) != undefined)
                {
                    deger_money_id = document.getElementById("money_id"+satir);
                    deger_money_id =  list_getat(deger_money_id.value,1,',');
                    for(s=1;s<=document.getElementById("kur_say").value;s++)
                    {
                        money_deger =list_getat(document.add_costplan.rd_money[s-1].value,1,',');
                        if(money_deger == deger_money_id)
                        {
                            deger_diger_para_satir = document.add_costplan.rd_money[s-1];
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
                if(hesap_type ==undefined)
                {
                    if(deger_otv_total != "" && deger_total != "") deger_otv_total.value = ((parseFloat(deger_total.value) * parseFloat(deger_quantity.value)) * deger_otv_rate.value)/100;
                    if(deger_kdv_total != "" && deger_total != "") deger_kdv_total.value = ((parseFloat(deger_total.value) * parseFloat(deger_quantity.value)) * deger_tax_rate.value)/100;
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
                    if(deger_total != "" && deger_tax_rate != "") deger_total.value = ((parseFloat(deger_net_total.value)/parseFloat(deger_quantity.value))*100)/ (parseFloat(tax_rate_)+parseFloat(otv_rate_)+100);
                    if(deger_kdv_total != "" && deger_total != "") deger_kdv_total.value = (parseFloat(deger_total.value * deger_quantity.value * deger_tax_rate.value))/100;
                    if(deger_otv_total != "" && deger_total != "") deger_otv_total.value = (parseFloat(deger_total.value * deger_quantity.value * deger_otv_rate.value))/100;
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
            }
            if(extra_type == 2 || extra_type == undefined)
                toplam_hesapla(extra_type);
        }
        function toplam_hesapla(type)
        {
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
                
                    if(deger_total != "") deger_total.value = filterNum(deger_total.value,'#xml_satir_number#');
                    if(deger_quantity != "") deger_quantity.value = filterNum(deger_quantity.value,'#xml_satir_number#');
                    if(deger_kdv_total != "") deger_kdv_total.value = filterNum(deger_kdv_total.value,'#xml_satir_number#');
                    
                    if(document.getElementById("tax_rate"+r) != undefined && document.getElementById("kdv_total"+r) != undefined)
                    {
                        if(document.getElementById("tevkifat_oran") != undefined && document.getElementById("tevkifat_oran").value != "" && document.getElementById("tevkifat_box").checked == true && document.getElementById("expense_cost_type").value != 122)
                        {//tevkifat hesaplamaları
                            
                            beyan_tutar = beyan_tutar + wrk_round(deger_kdv_total.value*filterNum(document.getElementById("tevkifat_oran").value)/100);
                            if(new_taxArray.length != 0)
                                for (var m=0; m < new_taxArray.length; m++)
                                {	
                                    var tax_flag = false;
                                    if(new_taxArray[m] == deger_tax_rate.value){
                                        tax_flag = true;
                                        taxBeyanArray[m] += wrk_round(deger_kdv_total.value - (deger_kdv_total.value*(filterNum(document.getElementById("tevkifat_oran").value)/100)));
                                        taxTevkifatArray[m] += wrk_round(deger_kdv_total.value*(filterNum(document.getElementById("tevkifat_oran").value)/100));
                                        break;
                                    }
                                }
                            if(!tax_flag){
                                new_taxArray[new_taxArray.length] = deger_tax_rate.value;
                                taxBeyanArray[taxBeyanArray.length] = wrk_round(deger_kdv_total.value - (deger_kdv_total.value*(filterNum(document.getElementById("tevkifat_oran").value)/100)));
                                taxTevkifatArray[taxTevkifatArray.length] = wrk_round(deger_kdv_total.value*(filterNum(document.getElementById("tevkifat_oran").value)/100));
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
            if(type == undefined || parseFloat(document.getElementById("stopaj_yuzde").value) == 0)
                stopaj_ = wrk_round((toplam_dongu_1 * parseFloat(document.getElementById("stopaj_yuzde").value) / 100),'#xml_genel_number#');
            else
                stopaj_ = filterNum(document.getElementById("stopaj").value);
            document.getElementById("stopaj_yuzde").value = commaSplit(parseFloat(document.getElementById("stopaj_yuzde").value));
            document.getElementById("stopaj").value = commaSplit(stopaj_,'#xml_genel_number#');
            
            toplam_dongu_3 = toplam_dongu_3-parseFloat(stopaj_);
            
            document.getElementById("total_amount").value = commaSplit(toplam_dongu_1,'#xml_genel_number#');
            document.getElementById("kdv_total_amount").value = commaSplit(toplam_dongu_2,'#xml_genel_number#');
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
                    if(document.add_costplan.rd_money[s-1].checked == true)
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
            document.getElementById("other_net_total_amount").value = commaSplit(toplam_dongu_3 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#')),'#xml_genel_number#');
        
            document.getElementById("tl_value1").value = deger_money_id_1;
            document.getElementById("tl_value2").value = deger_money_id_1;
            document.getElementById("tl_value3").value = deger_money_id_1;
            form_txt_rate2_.value = commaSplit(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#');
        }
        function doviz_hesapla(type)
        {
            for(k=1; k<= document.getElementById("record_num").value;k++)
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
                        }
                    }
                }
            }
        }
        </cfoutput>
        function del_kontrol()
        {
            if (!control_account_process(<cfoutput>'#attributes.expense_id#','#get_expense.action_type#'</cfoutput>)) return false;
            <cfif session.ep.our_company_info.is_efatura and isdefined("chk_send_inv") and chk_send_inv.count>
                if(1 == 1)
                {
                    alert("Fatura ile İlişkili e-Fatura Olduğu için Silinemez !");
                    return false;
                }
            </cfif>
            <cfif session.ep.our_company_info.is_earchive and isdefined("chk_send_arc") and chk_send_arc.count>
                if(1 == 1)
                {
                    alert("Fatura e-Arşiv Sistemine Gönderildiği İçin Silinemez !");
                    return false;
                }
            </cfif>
            if (!chk_period(document.getElementById("expense_date"),"<cf_get_lang_main no ='280.İşlem'>")) return false;
            if (!check_display_files('add_costplan')) return false;
            else return true;
        }
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
            if (!control_account_process(<cfoutput>'#attributes.expense_id#','#get_expense.action_type#'</cfoutput>)) return false;
            if (document.getElementById("ch_company").value == "" &&  document.getElementById("ch_partner").value == "" && document.getElementById("cash").checked == false && document.getElementById("bank").checked == false)
            {
                alert("<cf_get_lang no ='1060.Cari kasa veya banka işleminden birini şeçiniz'>!");
                return false;
            }
            if (!chk_process_cat('add_costplan')) return false;
            if (!check_display_files('add_costplan')) return false;
            if (!chk_period(document.getElementById("expense_date"),"<cf_get_lang_main no ='280.İşlem'>")) return false;
            <cfif session.ep.our_company_info.is_efatura>
                <cfif isdefined("xml_upd_einvoice") and xml_upd_einvoice eq 0 and isdefined("chk_send_inv") and chk_send_inv.count>
                    if(1 == 1)
                    {
                        alert("e-Faturası Oluşturulmuş Gelir Fişini Güncelleyemezsiniz !");
                        return false;
                    }
                    else
                    {
                        if(confirm("e-Faturası Oluşturulmuş Faturayı Güncellemek İstiyor musunuz !") == true);
                        else
                        return false;
                    }
                <cfelseif isdefined("chk_send_inv") and chk_send_inv.count>	
                    if(confirm("e-Faturası Oluşturulmuş Gelir Fişini Güncellemek İstiyor musunuz !") == true);
                    else
                    return false;
                </cfif>
            </cfif>
            <cfif isdefined('x_select_project') and x_select_project eq 2> //xmlde muhasebe icin proje secimi zorunlu ise
                if(document.getElementById("project_head").value=='' || document.getElementById("project_id").value=='')
                {
                    alert('Proje Seçiniz');
                    return false;
                } 
            </cfif>
            <cfif session.ep.our_company_info.is_earchive>
                <cfif xml_upd_earchive eq 0 and isdefined("chk_send_arc") and chk_send_arc.count>
                    if(1 == 1)
                    {
                        alert("e-Arşiv Faturası Oluşturulmuş Gelir Fişini Güncelleyemezsiniz !");
                        return false;
                    }
                    else
                    {
                        if(confirm("e-Arşiv Faturası Oluşturulmuş Faturayı Güncellemek İstiyor musunuz !") == true);
                        else
                        return false;
                    }
                <cfelseif isdefined("chk_send_arc") and chk_send_arc.count>	
                    if(confirm("e-Arşiv Faturası Oluşturulmuş Gelir Fişini Güncellemek İstiyor musunuz !") == true);
                    else
                    return false;
                </cfif>
            </cfif>
            //Odeme Plani Guncelleme Kontrolleri
            if (document.getElementById("cari_action_type_").value == 5 && "<cfoutput>#get_expense.paymethod_id#</cfoutput>" != "")
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
            <cfif (session.ep.our_company_info.is_efatura eq 1) ><!--- MCP tarafından #75351 numaralı iş için eklendi.e-Fatura kullanıyorsa gösterilecek --->
                if(document.getElementById('ch_company_id') != undefined && document.getElementById('ch_company_id').value != '')
                {
                	var comp_id =document.getElementById('ch_company_id').value;
                    $.ajax({
			        		url: '/V16/objects/cfc/einvoice.cfc?method=get_efatura_info',
			               	type : "get",
					        async: false,
					        data : {company_id :comp_id },
					        success: function(read_data) {
					        	data_ = jQuery.parseJSON(read_data.replace('//',''));
						        if(data_.DATA.length != 0)
						        {
					        		
					            $.each(data_.DATA,function(i){
					                
					                //query deki alan sırasına göre datalarınızı alabilir ve daha sonra istediğiniz kontrolü yapabilirsiniz
					                get_efatura_info= data_.DATA[i][0];
					               
					                
					            });

			        			}
						    }
						});	
                    if(get_efatura_info == 1)															   
                    {
                        if(document.getElementById('ship_address_id').value =='' || document.getElementById('adres').value =='')
                        {
                            alert('Cari Şube Boş Geçilemez');
                            return false;
                        }
                    }
                }
            </cfif>
            if(document.getElementById("expense_date").value == "")
            {
                alert("<cf_get_lang no='1064.Lütfen Harcama Tarihi Giriniz'>!");
                return false;
            }
            if(document.getElementById("expense_employee").value == "")
            {
                alert("<cf_get_lang no='1096.Lütfen Tahsil Eden Giriniz'> !");
                return false;
            }
            record_exist=0;//Row_kontrol değeri 1 olan yani silinmemiş satırların varlığını kontrol ediyor
            for(r=1;r<=document.getElementById("record_num").value;r++)
            {
                deger_row_kontrol = document.getElementById("row_kontrol"+r);
                if(document.getElementById("expense_center_id"+r) != undefined) deger_expense_center_id = document.getElementById("expense_center_id"+r).value; else deger_expense_center_id ="";
                if(document.getElementById("expense_center_name"+r) != undefined) deger_expense_center_name = document.getElementById("expense_center_name"+r).value; else deger_expense_center_name ="";		
                if(document.getElementById("expense_item_id"+r) != undefined) deger_expense_item_id = document.getElementById("expense_item_id"+r).value; else deger_expense_item_id = "";
                if(document.getElementById("expense_item_name"+r) != undefined) deger_expense_item_name = document.getElementById("expense_item_name"+r).value; else deger_expense_item_name = "";					
                if(document.getElementById("row_detail"+r) != undefined) deger_row_detail = document.getElementById("row_detail"+r); else deger_row_detail = "";
                if(document.getElementById("authorized"+r) != undefined) harcama_yapan = document.getElementById("authorized"+r); else harcama_yapan="";
                if(document.getElementById("company"+r) != undefined) harcama_yapan_firma = document.getElementById("company"+r); else harcama_yapan_firma="";
                deger_total = document.getElementById("total"+r);
                
                <cfif x_is_project_priority eq 1>
                    deger_project = document.getElementById("project_id"+r);
                    deger_project_name = document.getElementById("project"+r);
                    deger_product_id = document.getElementById("product_id"+r);
                    deger_product_name = document.getElementById("product_name"+r);
                </cfif>
                
                if(deger_row_kontrol.value == 1)
                {
                    record_exist=1;
                    
                    <cfif x_is_project_priority eq 1>
                        if (deger_product_id.value == "" || deger_product_name.value == "")
                            { 
                                alert ("<cf_get_lang_main no='313.Ürün Seçiniz'>!");
                                return false;
                            }
        
                        var get_urun_kalem = wrk_safe_query("obj_get_urun_kalem","dsn3","1",deger_product_id.value);
                        var urun_record_ = get_urun_kalem.recordcount;
                            if(urun_record_<1)
                                {
                                alert('<cf_get_lang no="1877.Ürün Gider Kalemi Bulunamadı">!');
                                return false;
                                }
                            else
                                {
                                document.getElementById("expense_item_id"+r).value = get_urun_kalem.EXPENSE_ITEM_ID;
                                }
                                
                        if (urun_record_==1 && document.getElementById("expense_item_id"+r).value == '')		
                            {
                                alert('<cf_get_lang no="1874.Seçmiş Olduğunuz Ürün Dağıtıma Tabidir Başka Bir Ürün Seçmeniz Gerekir">!');
                                return false;
                            }
                                
                        if (deger_project.value == "" || deger_project_name.value == "")
                            { 
                                alert ("<cf_get_lang_main no='1385.Proje Seçiniz!'>");
                                return false;
                            }
                        var get_proje_merkez = wrk_safe_query("obj_get_proje_merkez","dsn","1",deger_project.value);
                        var proje_record_ = get_proje_merkez.recordcount;
                            if(proje_record_<1 || get_proje_merkez.EXPENSE_CODE =='' || get_proje_merkez.EXPENSE_CODE==undefined)
                                {
                                alert('<cf_get_lang no="1875.Proje Masraf Merkezi Bulunamadı">!');
                                return false;
                                }
                            else
                                {
                                var get_code = wrk_safe_query("obj_get_code","dsn2","1",get_proje_merkez.EXPENSE_CODE );
                                document.getElementById("expense_center_id"+r).value = get_code.EXPENSE_ID;
                                }			
                    </cfif>
                    
                    <cfif x_is_project_priority eq 0>
                    if (deger_expense_center_id == "" || deger_expense_center_name == "")
                    { 
                        alert ("<cf_get_lang no='1098.Lütfen Gelir Merkezi Seçiniz'>  !");
                        return false;
                    }	
                    if (deger_expense_item_id == "" || deger_expense_item_name == "")
                    { 
                        alert ("<cf_get_lang no='1099.Lütfen Gelir Kalemi Seçiniz'> !");
                        return false;
                    }	
                    </cfif>
                    if (deger_row_detail == "")
                    { 
                        alert ("<cf_get_lang no='1073.Lütfen Açıklama Giriniz'>!");
                        return false;
                    }	
                    if (deger_total.value == "")
                    { 
                        alert ("<cf_get_lang_main no='1738.Lütfen Tutar Giriniz'>  !");
                        return false;
                    }	
                    if (deger_total.value == 0)
                    { 
                        alert ("<cf_get_lang_main no='1738.Lütfen Tutar Giriniz'>  !");
                        deger_total.value = commaSplit(deger_total.value);
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
                    alert("<cf_get_lang no='1097.Lütfen Gelir Fişine Satır Ekleyiniz'> !");
                    return false;
                }
                unformat_fields();
            change_due_date();
        return true;
        }
        
        
        
        function open_process_row()
        {
            document.getElementById('open_process').style.display ='';
            AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=cost.emptypopup_form_add_cost_rows&type=2','open_process',1);
        }
        <cfoutput>
            function other_calc(row_info,type_info)
            {
                if(row_info != undefined)
                {
                    if(document.getElementById("row_kontrol"+row_info).value==1)
                    {
                        deger_money_id = list_getat(document.getElementById("money_id"+row_info).value,1,',');
                        for(kk=1;kk<=document.getElementById("kur_say").value;kk++)
                        {
                            money_deger =list_getat(document.all.rd_money[kk-1].value,1,',');
                            if(money_deger == deger_money_id)
                            {
                                deger_diger_para_satir = document.all.rd_money[kk-1];
                                form_value_rate_satir = document.getElementById("txt_rate2_" + kk);
                            }
                        }
                        document.getElementById("other_net_total"+row_info).value = filterNum(document.getElementById("other_net_total"+row_info).value,'#xml_satir_number#');
                        document.getElementById("net_total"+row_info).value = document.getElementById("other_net_total"+row_info).value*filterNum(form_value_rate_satir.value,'#session.ep.our_company_info.rate_round_num#');
                        document.getElementById("other_net_total"+row_info).value = commaSplit(document.getElementById("other_net_total"+row_info).value,'#xml_satir_number#');
                        document.getElementById("net_total"+row_info).value = commaSplit(document.getElementById("net_total"+row_info).value,'#xml_satir_number#');
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
        </cfoutput>
        
        function enterControl(e,objeName,ObjeRowNumber,hesapType)
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
	function kontrol_et()
	{
		if(row_count ==0) return false;
		else return true;
	}
	function banka_kontrol()
	{
		if (document.getElementById("bank")) 
		{	
			document.getElementById("bank").checked = false;
			document.getElementById("banka1").style.display='none';
			document.getElementById("banka2").style.display='none';
		}
		if (document.getElementById("cash")) 
		{
			document.getElementById("cash").checked = false;
			document.getElementById("kasa1").style.display='none';
			document.getElementById("kasa2").style.display='none';
		}
		return true;
	}
	function unformat_fields()
	{
		<cfoutput>
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
			document.getElementById("total_amount").value = filterNum(document.getElementById("total_amount").value,'#xml_genel_number#');
			document.getElementById("kdv_total_amount").value = filterNum(document.getElementById("kdv_total_amount").value,'#xml_genel_number#');
			document.getElementById("net_total_amount").value = filterNum(document.getElementById("net_total_amount").value,'#xml_genel_number#');
			document.getElementById("other_total_amount").value = filterNum(document.getElementById("other_total_amount").value,'#xml_genel_number#');
			document.getElementById("other_kdv_total_amount").value = filterNum(document.getElementById("other_kdv_total_amount").value,'#xml_genel_number#');
			document.getElementById("other_net_total_amount").value = filterNum(document.getElementById("other_net_total_amount").value,'#xml_genel_number#');
			for(s=1;s<=document.getElementById("kur_say").value;s++)
			{
				document.getElementById("txt_rate2_" + s).value = filterNum(document.getElementById("txt_rate2_" + s).value,'#session.ep.our_company_info.rate_round_num#');
				document.getElementById("txt_rate1_" + s).value = filterNum(document.getElementById("txt_rate1_" + s).value,'#session.ep.our_company_info.rate_round_num#');
			}
			<!--- 90886 IDLI IS KAPSAMINDA KAPATILDI --->
	<!---		<cfif not (browserdetect() contains 'MSIE') or (browserdetect() contains 'MSIE' and browserdetect() contains '9')>
				for(i=1;i<=document.all.record_num.value-row_count_ilk;i++)
				{
					var satir_ = i + row_count_ilk;
					document.add_costplan.appendChild(document.getElementById("row_kontrol" + satir_));
					document.add_costplan.appendChild(document.getElementById("row_detail" + satir_));
					document.add_costplan.appendChild(document.getElementById("expense_center_id" + satir_));
					document.add_costplan.appendChild(document.getElementById("expense_center_name" + satir_));
					document.add_costplan.appendChild(document.getElementById("expense_item_id" + satir_));
					document.add_costplan.appendChild(document.getElementById("expense_item_name" + satir_));
					document.add_costplan.appendChild(document.getElementById("account_code" + satir_));
					if(document.getElementById("expense_date" + satir_) != undefined)
						document.add_costplan.appendChild(document.getElementById("expense_date" + satir_));
					if(document.getElementById("project_id" + satir_) != undefined && document.getElementById("project" + satir_) != undefined)
					{
						document.add_costplan.appendChild(document.getElementById("project_id" + satir_));
						document.add_costplan.appendChild(document.getElementById("project" + satir_));
					}
					if(document.getElementById("product_id" + satir_) != undefined && document.getElementById("product_name" + satir_) != undefined)
					{
						document.add_costplan.appendChild(document.getElementById("product_id" + satir_));
						document.add_costplan.appendChild(document.getElementById("stock_id" + satir_));
						document.add_costplan.appendChild(document.getElementById("product_name" + satir_));
					}
					if(document.getElementById("stock_unit" + satir_) != undefined)
					{
						document.add_costplan.appendChild(document.getElementById("stock_unit" + satir_));
						document.add_costplan.appendChild(document.getElementById("stock_unit_id" + satir_));
					}
					if(document.getElementById("quantity" + satir_) != undefined)	document.add_costplan.appendChild(document.getElementById("quantity" + satir_));
					if(document.getElementById("total" + satir_) != undefined)	document.add_costplan.appendChild(document.getElementById("total" + satir_));
					if(document.getElementById("tax_rate" + satir_) != undefined)	document.add_costplan.appendChild(document.getElementById("tax_rate" + satir_));
					if(document.getElementById("otv_rate" + satir_) != undefined)	document.add_costplan.appendChild(document.getElementById("otv_rate" + satir_));
					if(document.getElementById("kdv_total" + satir_) != undefined)	document.add_costplan.appendChild(document.getElementById("kdv_total" + satir_));
					if(document.getElementById("otv_total" + satir_) != undefined)	document.add_costplan.appendChild(document.getElementById("otv_total" + satir_));
					if(document.getElementById("net_total" + satir_) != undefined)	document.add_costplan.appendChild(document.getElementById("net_total" + satir_));
					if(document.getElementById("money_id" + satir_) != undefined)	document.add_costplan.appendChild(document.getElementById("money_id" + satir_));
					if(document.getElementById("other_net_total" + satir_) != undefined)	document.add_costplan.appendChild(document.getElementById("other_net_total" + satir_));
					if(document.getElementById("activity_type" + satir_) != undefined)
						document.add_costplan.appendChild(document.getElementById("activity_type" + satir_));
					if(document.getElementById("subscription_id" + satir_) != undefined && document.getElementById("subscription_name" + satir_) != undefined)
					{
						document.add_costplan.appendChild(document.getElementById("subscription_id" + satir_));
						document.add_costplan.appendChild(document.getElementById("subscription_name" + satir_));
					}
					document.add_costplan.appendChild(document.getElementById("member_type" + satir_));
					document.add_costplan.appendChild(document.getElementById("member_id" + satir_));
					document.add_costplan.appendChild(document.getElementById("company_id" + satir_));
					document.add_costplan.appendChild(document.getElementById("authorized" + satir_));
					document.add_costplan.appendChild(document.getElementById("company" + satir_));
					if(document.getElementById("asset_id" + satir_) != undefined && document.getElementById("asset" + satir_) != undefined)
					{
						document.add_costplan.appendChild(document.getElementById("asset_id" + satir_));
						document.add_costplan.appendChild(document.getElementById("asset" + satir_));
					}
					if(document.getElementById("workgroup_id" + satir_) != undefined)
						document.add_costplan.appendChild(document.getElementById("workgroup_id" + satir_));
					if(document.getElementById("work_id" + satir_) != undefined && document.getElementById("work_head" + satir_) != undefined)
					{
						document.add_costplan.appendChild(document.getElementById("work_id" + satir_));
						document.add_costplan.appendChild(document.getElementById("work_head" + satir_));
					}
					if(document.getElementById("opp_id" + satir_) != undefined && document.getElementById("opp_head" + satir_) != undefined)
					{
						document.add_costplan.appendChild(document.getElementById("opp_id" + satir_));
						document.add_costplan.appendChild(document.getElementById("opp_head" + satir_));
					}
				}
			</cfif>--->
		</cfoutput>
	}
	function change_due_date(type)
	{
		if (type==1)
		{
			document.getElementById("basket_due_value").value = datediff(document.getElementById("expense_date").value,document.getElementById("basket_due_value_date_").value,0);
		}
		else
		{
			if(isNumber(document.getElementById("basket_due_value"))!= false && (document.getElementById("basket_due_value").value != 0))
				document.getElementById("basket_due_value_date_").value = date_add('d',+document.getElementById("basket_due_value").value,document.getElementById("expense_date").value);
			else
				document.getElementById("basket_due_value_date_").value = document.getElementById("expense_date").value;
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
</script>
<cfif IsDefined("attributes.event") and attributes.event eq 'upd'>
	<cfset attributes.expense_bank_id = get_expense.expense_cash_id>
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
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'cost.add_income_cost';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'objects/form/add_income_cost.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'objects/query/add_income_cost.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'cost.add_income_cost&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('income_cost','income_cost_bask')";
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'cost.add_income_cost';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'objects/form/add_income_cost.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'objects/query/upd_income_cost.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'cost.add_income_cost&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'expense_id=##attributes.expense_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.expense_id##';
	WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('income_cost','income_cost_bask')";
	
	if(IsDefined("attributes.event") and (attributes.event is 'upd' or attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'cost.add_income_cost';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'objects/query/del_collacted_expense_cost.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'objects/query/del_collacted_expense_cost.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'cost.add_income_cost';
	}
	
	if(IsDefined("attributes.event") && attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1966]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['customTag'] = '<cf_get_workcube_related_acts period_id="#session.ep.period_id#" company_id="#session.ep.company_id#" asset_cat_id="-17" module_id="49" action_section="EXPENSE_ID" action_id="#attributes.expense_id#">';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[1040]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=#modulename#.popup_list_order_account_cards&expense_id=#attributes.expense_id#&is_income=1','page','add_process')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = 'Ek Bilgi';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#attributes.expense_id#&type_id=-17','page','add_process')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['text'] = 'Uyarılar';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=cost.upd_income_cost&action_name=expense_id&action_id=#attributes.expense_id#','page','add_process')";
		
		/*if(((GET_EXPENSE.INVOICE_TYPE_CODE eq 'SATIS' OR GET_EXPENSE.INVOICE_TYPE_CODE eq 'IADE') and (len(get_expense.ch_company_id) and get_expense_comp.use_efatura eq 1 and datediff('d',get_expense_comp.efatura_date,get_expense.expense_date) gte 0) or (len(get_expense.ch_consumer_id) and get_cons_name.use_efatura eq 1 and datediff('d',get_cons_name.efatura_date,get_expense.expense_date) gte 0)))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['text'] = 'Uyarılar';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['customTag'] = '<cf_wrk_efatura_display action_id="#attributes.expense_id#" action_type="EXPENSE_ITEM_PLANS" action_date="#get_expense.expense_date#">';
		}
		else
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['text'] = 'Uyarılar';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['customTag'] = '<cf_wrk_earchive_display action_id="#attributes.expense_id#" action_type="EXPENSE_ITEM_PLANS" action_date="#get_expense.expense_date#">';
		}
		if(len(get_expense.paymethod_id) and not listfindnocase(denied_pages,'objects.popup_payment_with_voucher'))
		{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['text'] = 'Uyarılar';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['onClick'] = '#request.self#?fuseaction=objects.popup_payment_with_voucher&is_purchase_=0&payment_process_id=#attributes.expense_id#&str_table=EXPENSE_ITEM_PLANS&branch_id='+ branch_id;
		
		}*/
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=cost.add_income_cost";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = '#request.self#?fuseaction=cost.add_income_cost&expense_id=#attributes.expense_id#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#expense_id#&print_type=230','page')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	} 
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'incomeCost';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'EXPENSE_ITEM_PLANS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-1','item-4','item-6','item-7']";
</cfscript>
