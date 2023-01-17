<cfinclude template="../query/get_price_cats.cfm">
<cfinclude template="../query/get_paymethods.cfm">
<cfif attributes.type is 1>
  <cfinclude template="../query/get_purchase_prod_discount.cfm">
<cfelse>
  <cfinclude template="../query/get_sales_prod_discount.cfm">
</cfif>
<cfinclude template="../query/get_money.cfm">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='37043.Ürün Koşulları'></cfsavecontent>
<cf_popup_box title="#message#">
	<cfform name="form_basket" method="post" action="#request.self#?fuseaction=product.emptypopup_upd_purchase_sales_condition">
		<cfif attributes.type is 1>
			<cfset queryname = "GET_PURCHASE_PROD_DISCOUNT">
			<cfset discount_id = GET_PURCHASE_PROD_DISCOUNT.C_P_PROD_DISCOUNT_ID>
		<cfelse>
			<cfset queryname = "GET_SALES_PROD_DISCOUNT">
			<cfset discount_id = GET_SALES_PROD_DISCOUNT.C_S_PROD_DISCOUNT_ID>
		</cfif>
		<cfoutput query="#queryname#">
			<input type="hidden" name="discount_id"  id="discount_id" value="#discount_id#">
			<input type="hidden" name="pid" id="pid" value="#attributes.pid#">
			<table>
            <tr>
				<td width="90"><cf_get_lang dictionary_id='58053.Baslangic'> *</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Baslangic Tarihi Girmelisiniz'></cfsavecontent>
					<cfif len(start_date)>								
						<cfinput type="text" name="start_date" value="#dateformat(start_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#" required="yes" style="width:65px;">
					<cfelse>
						<cfinput type="text" name="start_date" value="" maxlength="10" validate="#validate_style#" message="#message#" required="yes" style="width:65px;">
					</cfif>
					<cf_wrk_date_image date_field="start_date">
				</td>
				<td valign="top" rowspan="3"></td>
				<td rowspan="3"></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='57700.Bitiş'></td>
				<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi girmelisiniz'> </cfsavecontent>
					<cfif len(finish_date)>								
						<cfinput type="text" name="finish_date" value="#dateformat(finish_date,dateformat_style)#" maxlength="10" message="#message#" style="width:65px;">
					<cfelse>
						<cfinput type="text" name="finish_date" value="" maxlength="10" validate="#validate_style#" message="#message#" style="width:65px;">
					</cfif>
					<cf_wrk_date_image date_field="finish_date">
				</td>
			</tr>
			<tr>
				<td width="60"><cf_get_lang dictionary_id='37069.Kosul Tipi'></td>
				<td class="">
					<input type="hidden" name="purchase_sales"  id="purchase_sales" value="#attributes.type#">
					<cfif attributes.type is 1><cf_get_lang dictionary_id='58176.Alış'></cfif>
					<cfif attributes.type is 2><cf_get_lang dictionary_id='57448.Satış'></cfif>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='57519.Cari Hesap'></td>
				<td><input type="hidden" name="company_id"  id="company_id" value="#company_id#">
					<cfset company_name= "">
					<cfif len(company_id)>
						<cfset attributes.company_id = company_id>
						<cfinclude template="../query/get_company_name.cfm">
						<cfif get_company_name.recordcount>
							<cfset company_name= get_company_name.nickname>
						</cfif>
					</cfif>
					<input type="text" name="company_name"  id="company_name" style="width:150px;" value="#company_name#">
					<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&select_list=2&field_comp_name=form_basket.company_name&field_comp_id=form_basket.company_id','project');"><img src="/images/plus_thin.gif" border="0" title="" align="absmiddle"></a>&nbsp;
				</td>
				<td>Rebate(<cf_get_lang dictionary_id ='57673.Tutar'>)</td>
				<td>
					<input type="text" name="discount_cash" id="discount_cash" style="width:100px;" class="moneybox" onKeyUp="return(FormatCurrency(this,event));" value="#tlformat(DISCOUNT_CASH)#">
					<select name="discount_cash_money" id="discount_cash_money" style="width:45px;" disabled>
						<cfif len(evaluate("#queryname#.DISCOUNT_CASH_MONEY"))>
							<cfloop query="get_money">
								<option value="#get_money.money#" <cfif evaluate("#queryname#.DISCOUNT_CASH_MONEY") eq get_money.money>Selected</cfif>>#get_money.money#
							</cfloop>
						<cfelse>
							<cfloop query="get_money">
								<option value="#get_money.money#" <cfif session.ep.money eq get_money.money>Selected</cfif>>#get_money.money#
							</cfloop>
						</cfif>
					</select>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='57641.İndirim'> 1 %</td>
				<td><input type="text" name="discount1" id="discount1" value="#TLFormat(discount1)#" style="width:75px;" class="moneybox" maxlength="5" onKeyup='return(FormatCurrency(this,event));'></td>
				<td><cf_get_lang dictionary_id='37755.Back End Rebate'> (<cf_get_lang dictionary_id='57673.Tutar'>)</td>
				<td>
					<input type="text" name="rebate_cash_1" id="rebate_cash_1" style="width:100px;" class="moneybox" onKeyUp="return(FormatCurrency(this,event));" value="#tlformat(REBATE_CASH_1)#">
					<select name="rebate_cash_1_money" id="rebate_cash_1_money" style="width:45px;" disabled>
						<cfif len(evaluate("#queryname#.REBATE_CASH_1_MONEY"))>
							<cfloop query="get_money">
								<option value="#get_money.money#" <cfif evaluate("#queryname#.REBATE_CASH_1_MONEY") eq get_money.money>Selected</cfif>>#get_money.money#
							</cfloop>
						<cfelse>
							<cfloop query="get_money">
								<option value="#get_money.money#" <cfif session.ep.money eq get_money.money>Selected</cfif>>#get_money.money#
							</cfloop>
						</cfif>
					</select>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='57641.İndirim'> 2 %</td>
				<td><input type="text" name="discount2" id="discount2" value="#TLFormat(discount2)#" style="width:75px;" class="moneybox" maxlength="5" onKeyup='return(FormatCurrency(this,event));'></td>
				<td><cf_get_lang dictionary_id='37755.Back End Rebate'>(<cf_get_lang dictionary_id ='58456.Oran'>)%</td>
				<td><input type="text" name="rebate_rate" id="rebate_rate" class="moneybox" value="#TLFormat(rebate_rate)#" onKeyUp="return(FormatCurrency(this,event));" style="width:101px;"></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='57641.İndirim'> 3 %</td>
				<td><input type="text" name="discount3" id="discount3" value="#TLFormat(discount3)#" style="width:75px;" class="moneybox" maxlength="5" onKeyup='return(FormatCurrency(this,event));'></td>
				<td><cf_get_lang dictionary_id ='37660.Mal Fazlası'></td>
				<td>
					<input type="text" name="extra_product_1" id="extra_product_1" style="width:73px;" class="moneybox"  value="#TLFormat(extra_product_1)#" onKeyUp="return(FormatCurrency(this,event));">
					<input type="text" name="extra_product_2" id="extra_product_2" style="width:73px;" class="moneybox"  value="#TLFormat(extra_product_2)#" onKeyUp="return(FormatCurrency(this,event));">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='57641.İndirim'> 4 %</td>
				<td><input type="text" name="discount4" id="discount4" value="#TLFormat(discount4)#" style="width:75px;" class="moneybox" maxlength="5" onKeyup='return(FormatCurrency(this,event));'></td>
				<td><cf_get_lang dictionary_id ='37741.Fiyat Koruma Süresi(Gün)'></td>
				<td><input type="text" name="PRICE_PROTECTION_DAY" id="PRICE_PROTECTION_DAY" style="width:150px;" class="moneybox" value="#TLFormat(PRICE_PROTECTION_DAY,0)#" onKeyUp="return(FormatCurrency(this,event,0));"></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='57641.İndirim'> 5 %</td>
				<td><input type="text" name="discount5" id="discount5" value="#TLFormat(discount5)#" style="width:75px;" class="moneybox" maxlength="5" onKeyup='return(FormatCurrency(this,event));'></td>
				<td><cf_get_lang dictionary_id ='37742.İade Süresi (Gün)'> /<cf_get_lang dictionary_id ='58456.Oran'>  (%)</td>
				<td><input type="text" name="RETURN_DAY" id="RETURN_DAY" value="#TLFormat(RETURN_DAY,0)#" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" style="width:73px;">
					<input type="text" name="return_rate" id="return_rate" value="#TLFormat(return_rate)#" class="moneybox" onKeyup='return(FormatCurrency(this,event));' style="width:73px;">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></td>
				<td>
					<cfset paymethodid = paymethod_id>
					<select name="paymethod_id" id="paymethod_id" style="width:140px;" class="moneybox">
						<cfloop query="get_paymethods">
						<option value="#get_paymethods.paymethod_id#"  <cfif paymethodid is get_paymethods.paymethod_id>selected</cfif>>#get_paymethods.paymethod#
						</cfloop>
					</select>
				</td>
				<td><cf_get_lang dictionary_id='37072.Teslim Süresi'> (<cf_get_lang dictionary_id='57490.Gün'>)</td>
				<td><input type="text" name="delivery_dateno" id="delivery_dateno" class="moneybox" value="#TLFormat(delivery_dateno,0)#" onKeyUp="return(FormatCurrency(this,event,0));" style="width:150px;"></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id="58859.Süreç">*</td>
				<td><cf_workcube_process is_upd='0' select_value='#process_stage#'  process_cat_width='140px' is_detail='1'></td>
			</tr>
		</table>
		<cfif attributes.type neq 1>	
        <table>
            <tr>
                <td class="txtbold"><cf_get_lang dictionary_id='37028.Fiyat Listeleri'></td>
            </tr>						
            <cfparam name="attributes.mode" default="5">  
            <cfset attributes.startrow=1>
            <cfset attributes.maxrows = get_price_cats.recordcount>
            <cfloop query="get_price_cats">
              <cfif ((currentrow mod attributes.mode is 1)) or (currentrow eq 1)>
                <tr>
              </cfif>
                    <td nowrap="nowrap"><input type="checkbox" name="PRICE_CATS_LIST" id="PRICE_CATS_LIST" value="#price_catid#"<cfif  ListFind(attributes.PRICE_CAT_ID_LIST,get_price_cats.price_catid,',')>checked</cfif>>#price_cat#</td>
              <cfif ((currentrow mod attributes.mode is 0)) or (currentrow eq recordcount)>
                </tr>
              </cfif>
            </cfloop>
        </table>
		</cfif>
   </cfoutput>
   <cf_popup_box_footer>
		<cfif isdefined("get_purchase_prod_discount.record_emp") and len(get_purchase_prod_discount.record_emp)>
            <cf_record_info query_name="get_purchase_prod_discount">
        <cfelse>
            <cf_record_info query_name="get_sales_prod_discount">
        </cfif>
        <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=product.emptypopup_del_purchase_sales_condition&purchase_sales=#attributes.type#&discount_id=#discount_id#&head=#company_name#' add_function='page_control()'>
	</cf_popup_box_footer>
</cfform>
</cf_popup_box>
<script type="text/javascript">
	function page_control()
	{
		var selected_price_cat = 0;
		<cfif attributes.type neq 1>
			for(i=0; i<form_basket.PRICE_CATS_LIST.length; i++)
			{
				if(document.form_basket.PRICE_CATS_LIST[i].checked)
				{
					var selected_price_cat = 1;
				}
			}
		</cfif>
		
		if(selected_price_cat == 1 && (document.form_basket.company_id.value != '' && document.form_basket.company_name.value != ''))
		{
			alert("<cf_get_lang dictionary_id ='37743.Aynı Anda Hem Cari Hemde Fiyat Listesi Seçili Olamaz'>!");
			return false;
		}
		
		if ( (form_basket.start_date.value != "") && (form_basket.finish_date.value != "") )
			if(!date_check(form_basket.start_date,form_basket.finish_date,"<cf_get_lang dictionary_id='58862.Baslangic Tarihi Bitis Tarihinden Buyuk Olamaz'> !"))
				return false;
		//Deger kontrolleri
		if(filterNum(form_basket.discount1.value) > 100 || filterNum(form_basket.discount1.value) < 0){alert("<cf_get_lang dictionary_id ='37744.İskonto 0 ile 100 arasında olmalıdır'>!");return false;}
		if(filterNum(form_basket.discount2.value) > 100 || filterNum(form_basket.discount2.value) < 0){alert("<cf_get_lang dictionary_id ='37744.İskonto 0 ile 100 arasında olmalıdır'>!");return false;}
		if(filterNum(form_basket.discount3.value) > 100 || filterNum(form_basket.discount3.value) < 0){alert("<cf_get_lang dictionary_id ='37744.İskonto 0 ile 100 arasında olmalıdır'>!");return false;}
		if(filterNum(form_basket.discount4.value) > 100 || filterNum(form_basket.discount4.value) < 0){alert("<cf_get_lang dictionary_id ='37744.İskonto 0 ile 100 arasında olmalıdır'>!");return false;}
		if(filterNum(form_basket.discount5.value) > 100 || filterNum(form_basket.discount5.value) < 0){alert("<cf_get_lang dictionary_id ='37744.İskonto 0 ile 100 arasında olmalıdır'>!");return false;}
		if(filterNum(form_basket.return_rate.value) > 100 || filterNum(form_basket.return_rate.value) < 0){alert("<cf_get_lang dictionary_id ='37745.İade oranı 0 ile 100 arasında olmalıdır'>!");return false;}
		if(filterNum(form_basket.rebate_rate.value) > 100 || filterNum(form_basket.rebate_rate.value) < 0){alert("<cf_get_lang dictionary_id ='37746.Back End Rebate oranı 0 ile 100 arasında olmalıdır'>!");return false;}
		return process_cat_control();
	}	
</script>
