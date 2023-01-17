<cf_get_lang_set module_name="product">
<cfif isdefined('attributes.get_company_id') and len(attributes.get_company_id)>
	<cfquery name="GET_COMPANY_NAME" datasource="#DSN#">
		SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID = #attributes.get_company_id#
	</cfquery>
	<cfset attributes.get_company = get_company_name.fullname>
</cfif>
<cfparam name="attributes.paymethod_id" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.pos_code" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.hierarchy_code" default="">
<cfparam name="attributes.product_catid" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.price_cats_lists" default="">
<cfparam name="attributes.price_cats_list" default="">
<cfparam name="attributes.price_cat_list" default="">
<cfparam name="attributes.purchase_sales" default="2">
<cfparam name="attributes.get_company_id" default="">
<cfparam name="attributes.rec_date" default="">
<cfparam name="attributes.brands" default="">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.brand_name" default="">
<cfparam name="attributes.cond_company_id" default="">
<cfparam name="attributes.cond_company_name" default="">
<cfparam name="attributes.is_active" default="-2">
<cfparam name="attributes.price_cat" default="-2">
<cfinclude template="../product/query/get_price_cats.cfm">
<cfif len(attributes.rec_date)>
	<cf_date tarih='attributes.rec_date'>
</cfif>
<cfif (isdefined("attributes.event") and attributes.event is "add_row") or not isdefined("attributes.event")>
	<cfquery name="GET_PAYMETHOD_TYPE" datasource="#DSN#">
        SELECT 
            SP.PAYMETHOD_ID,
            SP.PAYMETHOD 
        FROM 
            SETUP_PAYMETHOD SP,
            SETUP_PAYMETHOD_OUR_COMPANY SPOC
        WHERE 
            SP.PAYMETHOD_STATUS = 1
            AND SP.PAYMETHOD_ID = SPOC.PAYMETHOD_ID 
            AND SPOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
        ORDER BY 
            SP.PAYMETHOD
    </cfquery> 
    <cfquery name="GET_PRODUCT" datasource="#DSN3#">
      SELECT 
          PRODUCT_NAME, 
          RECORD_DATE, 
          PRODUCT_CODE,
          PRODUCT_ID,
          TAX,
          TAX_PURCHASE
      FROM 
          PRODUCT 
          LEFT JOIN #dsn_alias#.EMPLOYEE_POSITIONS ON PRODUCT.PRODUCT_MANAGER = EMPLOYEE_POSITIONS.POSITION_CODE
      WHERE 
          PRODUCT_STATUS = 1
          <cfif Len(attributes.cond_company_id) and Len(attributes.cond_company_name)>
            <cfif attributes.purchase_sales eq 1>
            AND PRODUCT_ID IN (SELECT PRODUCT_ID FROM CONTRACT_PURCHASE_PROD_DISCOUNT WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cond_company_id#">)
            <cfelse>
            AND PRODUCT_ID IN (SELECT PRODUCT_ID FROM CONTRACT_SALES_PROD_DISCOUNT WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cond_company_id#">)
            </cfif>
          </cfif>
          <cfif isdefined('attributes.brand_id') and len(attributes.brand_name)>AND BRAND_ID = #attributes.brand_id#</cfif>
          <cfif len(attributes.product_cat) and len(attributes.product_catid) and len(attributes.hierarchy_code)>AND PRODUCT_CODE LIKE '#attributes.hierarchy_code#.%'</cfif>
          <cfif len(attributes.employee) and len(attributes.pos_code)>AND EMPLOYEE_ID = #attributes.pos_code#</cfif>
          <cfif isdefined("attributes.get_company") and len(attributes.get_company) and isdefined("attributes.get_company_id") and len(attributes.get_company_id)>AND COMPANY_ID = #attributes.get_company_id#</cfif>
          <cfif len(attributes.rec_date)>AND RECORD_DATE >= #attributes.rec_date#</cfif>
          <cfif len(attributes.product_name)>AND PRODUCT_NAME LIKE '<cfif len(attributes.product_name) gt 2>%</cfif>#attributes.product_name#%'</cfif>
    </cfquery>
    <cfif get_product.recordcount>
		<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
            <cfset attributes.startrow=1>
            <cfset attributes.maxrows = get_product.recordcount>
        </cfif>
        <cfset product_id_list=listsort(valuelist(get_product.product_id),"numeric","ASC",",")>
        <cfquery name="GET_DISCOUNT_PURCHASE_ALL" datasource="#DSN3#">
            SELECT 
                DISCOUNT1, 
                DISCOUNT2, 
                DISCOUNT3,
                DISCOUNT4,
                DISCOUNT5,
                PAYMETHOD_ID,
                RECORD_DATE,
                START_DATE,
                PRODUCT_ID,
            <cfif isdefined('all_conditions')>
                EXTRA_PRODUCT_1,
                EXTRA_PRODUCT_2,
                REBATE_CASH_1,
                REBATE_CASH_1_MONEY,
                RETURN_DAY,
                RETURN_RATE,
                PRICE_PROTECTION_DAY,
                REBATE_RATE,
            </cfif> 
                DISCOUNT_CASH,
                DISCOUNT_CASH_MONEY
            FROM 
                CONTRACT_PURCHASE_PROD_DISCOUNT 
            WHERE
                <cfif Len(attributes.cond_company_id) and Len(attributes.cond_company_name)>
                    COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cond_company_id#"> AND
                </cfif>
                PRODUCT_ID IN (#product_id_list#)
        </cfquery>
        <cfquery name="GET_DISCOUNT_SALES_ALL" datasource="#DSN3#">
            SELECT 
                CSPD.DISCOUNT1, 
                CSPD.DISCOUNT2, 
                CSPD.DISCOUNT3, 
                CSPD.DISCOUNT4,
                CSPD.DISCOUNT5, 
                CSPD.PAYMETHOD_ID,
                CSPD.RECORD_DATE,
                CSPD.START_DATE,
                CSPD.PRODUCT_ID,
            <cfif isdefined('all_conditions')>
                CSPD.EXTRA_PRODUCT_1,
                CSPD.EXTRA_PRODUCT_2,
                CSPD.REBATE_CASH_1,
                CSPD.REBATE_CASH_1_MONEY,
                CSPD.RETURN_DAY,
                CSPD.RETURN_RATE,
                CSPD.PRICE_PROTECTION_DAY,
                CSPD.REBATE_RATE,
            </cfif> 
                CSPD.DISCOUNT_CASH,
                CSPD.DISCOUNT_CASH_MONEY
            FROM 
                CONTRACT_SALES_PROD_DISCOUNT CSPD,
                CONTRACT_SALES_PROD_PRICE_LIST CSPP
            WHERE
                CSPD.C_S_PROD_DISCOUNT_ID = CSPP.C_S_PROD_DISCOUNT_ID AND
                CSPP.PRICE_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_active#"> AND
                <cfif Len(attributes.cond_company_id) and Len(attributes.cond_company_name)>
                    CSPD.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cond_company_id#"> AND
                </cfif>
                CSPD.PRODUCT_ID IN (#product_id_list#)
        </cfquery>
        <cfquery name="GET_PRODUCT_PRICE_ALL" datasource="#DSN3#">
            SELECT
                MONEY,
                PRICE,
                PURCHASESALES,
                PRODUCT_ID
            FROM
                PRICE_STANDART
            WHERE
                PRODUCT_ID IN (#product_id_list#) AND
                PRICESTANDART_STATUS = 1
                <cfif attributes.purchase_sales eq 1>AND PURCHASESALES = 0
                <cfelseif attributes.purchase_sales eq 2>AND PURCHASESALES = 1</cfif>
          </cfquery>
    </cfif>      
</cfif>

<script type="text/javascript">
	<cfif isdefined("get_product")>
		function hesap_kontrol(j)
		{
			alan1 = eval('add_p_s_discount.discount1'+j);
			alan2 = eval('add_p_s_discount.discount2'+j);
			alan3 = eval('add_p_s_discount.discount3'+j);
			alan4 = eval('add_p_s_discount.discount4'+j);
			alan5 = eval('add_p_s_discount.discount5'+j);
			
			price_amount = eval('add_p_s_discount.price_amount'+j);
			iskontolu = eval('add_p_s_discount.toplam_tutar_iskontolu'+j);
			kdvli = eval('add_p_s_discount.tax_deger'+j);
			kdvli2 = eval('add_p_s_discount.toplam_tutat_iskontolu_kdvli'+j);
	
			alan1_value = filterNum(alan1.value);
			alan2_value = filterNum(alan2.value);
			alan3_value = filterNum(alan3.value);
			alan4_value = filterNum(alan4.value);
			alan5_value = filterNum(alan5.value);
	
			if (alan1_value > 100) {alert("<cf_get_lang no='934.İskonto 1 1 ile 100 Arasında Olmalıdır'> !");alan1.value=0; return false;}
			if (alan2_value > 100) {alert("<cf_get_lang no='935.İskonto 2 1 ile 100 Arasında Olmalıdır'> !");alan2.value=0; return false;}
			if (alan3_value > 100) {alert("<cf_get_lang no='936.İskonto 3 1 ile 100 Arasında Olmalıdır'> !");alan3.value=0; return false;}
			if (alan4_value > 100) {alert("<cf_get_lang no='937.İskonto 4 1 ile 100 Arasında Olmalıdır'> !");alan4.value=0; return false;}
			if (alan5_value > 100) {alert("<cf_get_lang no='938.İskonto 5 1 ile 100 Arasında Olmalıdır'> !");alan5.value=0; return false;}
			deger_toplanmasi_gereken = filterNum(price_amount.value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
			if (alan1_value) deger_toplanmasi_gereken = parseFloat(deger_toplanmasi_gereken) * ((100-parseFloat(alan1_value))/100);
			if (alan2_value) deger_toplanmasi_gereken = parseFloat(deger_toplanmasi_gereken) * ((100-parseFloat(alan2_value))/100);
			if (alan3_value) deger_toplanmasi_gereken = parseFloat(deger_toplanmasi_gereken) * ((100-parseFloat(alan3_value))/100);
			if (alan4_value) deger_toplanmasi_gereken = parseFloat(deger_toplanmasi_gereken) * ((100-parseFloat(alan4_value))/100);
			if (alan5_value) deger_toplanmasi_gereken = parseFloat(deger_toplanmasi_gereken) * ((100-parseFloat(alan5_value))/100);	
			iskontolu.value = commaSplit(deger_toplanmasi_gereken,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
			kdvli2.value = commaSplit(parseFloat(deger_toplanmasi_gereken) * ((100+parseFloat(kdvli.value))/100),<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
			<cfif isdefined('attributes.all_conditions')>
				if (filterNum(eval('add_p_s_discount.rebate_rate_'+j).value) > 100 || filterNum(eval('add_p_s_discount.rebate_rate_'+j).value) < 0) {alert("<cf_get_lang_main no='1472.Back End Rabete Oranı 1 ile 100 Arasında Olmalıdır'> !");eval('add_p_s_discount.rebate_rate_'+j).value=0; return false;}
			</cfif>
		}
		
		function check_all(deger)
		{
			<cfif get_product.recordcount gt 1>
			for(i=0; i<add_p_s_discount.is_record_active.length; i++)
				add_p_s_discount.is_record_active[i].checked = deger;
			<cfelseif get_product.recordcount eq 1>
				add_p_s_discount.is_record_active.checked = deger;
			</cfif>
		}
		
		function all_paymethod(paymethod)
		{
			<cfif get_product.recordcount>
				<cfoutput query="get_product">
					document.getElementById('paymethod_type#product_id#').value =paymethod;
				 </cfoutput>
			</cfif>
		}
		
		function all_discount(disc_no)
		{	
			if (eval('document.add_p_s_discount.disc' + disc_no + '_all').value == "")
				eval('document.add_p_s_discount.disc' + disc_no + '_all').value = 0;
				discount_yeni= eval('document.add_p_s_discount.disc' + disc_no + '_all').value;
			if ((filterNum(discount_yeni) < 0) || (filterNum(discount_yeni)> 100))
				{
					alert("<cf_get_lang no='932.İskonto 1 ile 100 Arasında Olmalıdır'>!");
					return false;
				}
			<cfif get_product.recordcount>
			else
				<cfoutput query="get_product">
					{ 
					eval('document.add_p_s_discount.discount' + disc_no + #product_id#).value = eval('document.add_p_s_discount.disc' + disc_no + '_all').value;
					hesap_kontrol('#PRODUCT_ID#');
					}
				 </cfoutput>
			</cfif>
		}
		
		function gonder()
		{
			if(!CheckEurodate(add_p_s_discount.start_date.value,'Başlama Tarihi') || !add_p_s_discount.start_date.value.length) 
			{
				alert("<cf_get_lang_main no='59.Eksik veri'> : <cf_get_lang_main no='243.Başlama Tarihi'>");
				return false;
			}
			var toplam_checked=0;
			<cfif get_product.recordcount gt 1>
				for (jj=1; jj <= <cfoutput>#get_product.recordcount#</cfoutput>; jj++)
				{
					str_ = jj - 1;
					if (eval('add_p_s_discount.is_record_active['+str_+'].checked') == true)
					{
						toplam_checked=1;
						break;
					}
				}
			<cfelse>
				if(add_p_s_discount.is_record_active.checked == true)
					toplam_checked=1;
			</cfif>	
			if(toplam_checked==0)
			{
				alert("<cf_get_lang no='933.Lütfen En Az Bir Ürün Seçiniz'> !");
				return false;
			}
			
			<cfif get_product.recordcount gt 1>
			for (k=1; k <= <cfoutput>#get_product.recordcount#</cfoutput>; k++)
				{
					m = k - 1;
					if (eval('add_p_s_discount.is_record_active['+m+'].checked') == true)
					{
						n = add_p_s_discount.is_record_active_order[m].value;
						alan1 = eval('add_p_s_discount.discount1'+n);
						alan2 = eval('add_p_s_discount.discount2'+n);
						alan3 = eval('add_p_s_discount.discount3'+n);
						alan4 = eval('add_p_s_discount.discount4'+n);
						alan5 = eval('add_p_s_discount.discount5'+n);
						
						alan1.value = filterNum(alan1.value);
						alan2.value = filterNum(alan2.value);
						alan3.value = filterNum(alan3.value);
						alan4.value = filterNum(alan4.value);
						alan5.value = filterNum(alan5.value);
						eval('add_p_s_discount.discount_cash'+n).value = filterNum(eval('add_p_s_discount.discount_cash'+n).value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
						<cfif isdefined('attributes.all_conditions')>
							eval('add_p_s_discount.extra_product_1_'+n).value = filterNum(eval('add_p_s_discount.extra_product_1_'+n).value);
							eval('add_p_s_discount.extra_product_2_'+n).value = filterNum(eval('add_p_s_discount.extra_product_2_'+n).value);
							eval('add_p_s_discount.price_protection_day_'+n).value = filterNum(eval('add_p_s_discount.price_protection_day_'+n).value);
							eval('add_p_s_discount.rebate_cash_1_'+n).value = filterNum(eval('add_p_s_discount.rebate_cash_1_'+n).value);
							eval('add_p_s_discount.return_day_'+n).value = filterNum(eval('add_p_s_discount.return_day_'+n).value);
							eval('add_p_s_discount.return_rate_'+n).value = filterNum(eval('add_p_s_discount.return_rate_'+n).value);
							eval('add_p_s_discount.rebate_rate_'+n).value = filterNum(eval('add_p_s_discount.rebate_rate_'+n).value);
						</cfif>
					}
				}
			<cfelse>
			if (add_p_s_discount.is_record_active.checked == true)
			{
				n = add_p_s_discount.is_record_active_order.value;			
				alan1 = eval('add_p_s_discount.discount1'+n);
				alan2 = eval('add_p_s_discount.discount2'+n);
				alan3 = eval('add_p_s_discount.discount3'+n);
				alan4 = eval('add_p_s_discount.discount4'+n);
				alan5 = eval('add_p_s_discount.discount5'+n);
				alan1.value = filterNum(alan1.value);
				alan2.value = filterNum(alan2.value);
				alan3.value = filterNum(alan3.value);
				alan4.value = filterNum(alan4.value);
				alan5.value = filterNum(alan5.value);
				eval('add_p_s_discount.discount_cash'+n).value = filterNum(eval('add_p_s_discount.discount_cash'+n).value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
				<cfif isdefined('attributes.all_conditions')>
					eval('add_p_s_discount.extra_product_1_'+n).value = filterNum(eval('add_p_s_discount.extra_product_1_'+n).value);
					eval('add_p_s_discount.extra_product_2_'+n).value = filterNum(eval('add_p_s_discount.extra_product_2_'+n).value);
					eval('add_p_s_discount.price_protection_day_'+n).value = filterNum(eval('add_p_s_discount.price_protection_day_'+n).value);
					eval('add_p_s_discount.rebate_cash_1_'+n).value = filterNum(eval('add_p_s_discount.rebate_cash_1_'+n).value);
					eval('add_p_s_discount.return_day_'+n).value = filterNum(eval('add_p_s_discount.return_day_'+n).value);
					eval('add_p_s_discount.return_rate_'+n).value = filterNum(eval('add_p_s_discount.return_rate_'+n).value);
					eval('add_p_s_discount.rebate_rate_'+n).value = filterNum(eval('add_p_s_discount.rebate_rate_'+n).value);
				</cfif>
			}
			</cfif>
			var price_list='';
			for(kk=0;kk<document.search_product.price_cat_list.length; kk++)
			{
				if(search_product.price_cat_list[kk].selected && search_product.price_cat_list.options[kk].value.length!='')
				price_list = price_list + ',' + search_product.price_cat_list.options[kk].value;
			}
			if(price_list != '' && document.add_p_s_discount.company_id.value != '' && document.add_p_s_discount.company_name.value != '')
			{
				alert("<cf_get_lang no='732.Aynı Anda Hem Cari Hemde Fiyat Listesi Seçili Olamaz'> !");
				return false;
			}
			document.add_p_s_discount.price_cats_lists.value = price_list;
			<cfif not get_paymethod_type.recordcount>
				alert("<cf_get_lang dictionary_id='54516.Ödeme Yöntemi Tanımlamalısınız'>");
				return false;
			</cfif>
			return process_cat_control();
		}
	</cfif>
	function input_control()
	{
		is_ok = 0;
		if(search_product.product_cat.value.length == 0)
			search_product.product_catid.value = '';
		if(search_product.get_company.value.length == 0)
			search_product.get_company_id.value = '';
		if(search_product.employee.value.length == 0)
			search_product.pos_code.value = '';
		if(search_product.brand_name.value.length == 0)
			search_product.brand_id.value = '';
		if (search_product.product_catid.value != '')
			is_ok = 1;
		else if (search_product.get_company_id.value != '') 
			is_ok = 1;
		else if (search_product.brand_id.value != '')
			is_ok = 1;
		else if(search_product.pos_code.value != '')
			is_ok = 1;
		else if (search_product.product_name.value != '')
			is_ok = 1;
			
		if(is_ok != 1)
		{
			alert("<cf_get_lang_main no='1538.En az bir Arama kriteri seçilmelisiniz'>!");
			return false;
		}
		else
		{
			if(search_product.is_active.selectedIndex > 1)
			{
				search_product.rec_date.disabled = false;				
			}
			return true;
		}
	}
	
	function disablePRecDate()
	{
		if (search_product.is_active.selectedIndex > 1)		
		{
			
			search_product.rec_date.disabled = true;
		}
		else
			search_product.rec_date.disabled = false;
	}
</script>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	
	if(not isDefined("attributes.event"))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.conditions';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'product/form/product_conditions.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'product/query/add_conditions.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'product.conditions';
	
	if(isDefined("attributes.form_varmi"))
	{	
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['print']['onclick'] = "windowopen('#request.self#?fuseaction=product.popup_temp_conditions#page_code#<cfif isdefined('attributes.all_conditions')>&all_conditions=1</cfif>','page')";		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
