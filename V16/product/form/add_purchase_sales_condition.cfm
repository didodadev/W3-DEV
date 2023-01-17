<cfinclude template="../query/get_price_cats.cfm">
<cfquery name="GET_PRICE_MONEY" datasource="#DSN1#"><!--- para birimleri ürün stadnar fiyatı ile aynı olmalı --->
	SELECT
		MONEY 
	FROM 
		PRICE_STANDART
	WHERE
		PURCHASESALES = 0 AND
		PRICESTANDART_STATUS = 1 AND
		PRODUCT_ID = #attributes.pid#
</cfquery>
<cfquery name="GET_COMPANIES" datasource="#DSN1#">
	SELECT
		DISTINCT 
		POC.OUR_COMPANY_ID,
		OC.NICK_NAME
	FROM
		#dsn_alias#.OUR_COMPANY AS OC,
		PRODUCT_OUR_COMPANY AS POC
	WHERE
		POC.OUR_COMPANY_ID = OC.COMP_ID AND
		POC.OUR_COMPANY_ID <> #session.ep.company_id# AND
		POC.PRODUCT_ID = #attributes.pid#
	ORDER BY
		OC.NICK_NAME
</cfquery>
<cfinclude template="../query/get_paymethods.cfm">
<cfinclude template="../query/get_money.cfm">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='37043.Ürün Koşulları'></cfsavecontent>
<cf_popup_box title="#message# : #get_product_name(attributes.pid)#">
	<cfform name="form_basket" method="post" action="#request.self#?fuseaction=product.emptypopup_add_purchase_sales_condition">
	<input type="hidden" name="today" id="today" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">
	<input type="hidden" name="pid" id="pid" value="<cfoutput>#attributes.pid#</cfoutput>">
		<table>
			<tr>
				<td width="90"><cf_get_lang dictionary_id='57655.Baslangic Tarihi'>*</td>
				<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Baslangic Tarihi girmelisiniz'> !</cfsavecontent>
					<cfinput type="text" name="start_date" value="" maxlength="10" validate="#validate_style#" message="#message#" required="yes" style="width:65px;">
					<cf_wrk_date_image date_field="start_date">
				</td>
				<td valign="top" rowspan="3"><cf_get_lang dictionary_id='57574.Firma'></td>
				<td valign="top" rowspan="3">
					<select name="compid" id="compid" style="width:150px; height:75px;" multiple>
					<cfoutput query="get_companies">
						<option value="#our_company_id#" <cfif isdefined('attributes.compid') and listfind(attributes.compid,our_company_id,',')>selected</cfif>>#nick_name#</option>
					</cfoutput>
					</select>
				</td>
			</tr>
			<tr>
				<td valign="top"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></td>
				<td valign="top">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'>!</cfsavecontent>
					<cfinput type="text" name="finish_date" value="" maxlength="10" validate="#validate_style#" message="#message#" style="width:65px;">
					<cf_wrk_date_image date_field="finish_date">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='37069.Kosul Tipi'></td>
				<td><select name="purchase_sales" id="purchase_sales" style="width:150px;" onchange="change_money();gizle_goster(price_cat_row);">
						<option value="1"><cf_get_lang dictionary_id='58176.Alış'>
						<option value="2"><cf_get_lang dictionary_id='57448.Satış'>
					</select>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='57519.Cari Hesap'></td>
				<td><input type="hidden" name="company_id" id="company_id" value="">
					<input type="text" name="company_name" id="company_name" value="" style="width:150px;">
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&select_list=2&field_comp_name=form_basket.company_name&field_comp_id=form_basket.company_id','list');"><img src="/images/plus_thin.gif" border="0" title="" align="absmiddle"></a>
				</td>
				<td>Rebate(<cf_get_lang dictionary_id='57673.Tutar'>)</td>
				<td><input type="text" name="discount_cash" id="discount_cash" style="width:101px;" class="moneybox" value="" onKeyUp="return(FormatCurrency(this,event));">
					<input type="hidden" name="discount_cash_money" id="discount_cash_money" value="<cfoutput>#get_price_money.money#</cfoutput>" readonly style="width:45px;">
					<select name="discount_cash_money_" id="discount_cash_money_" style="width:45px;" disabled="disabled">
					<cfoutput query="get_money">
						<option value="#money#" <cfif get_price_money.money eq money>selected</cfif>>#money#</option>
					</cfoutput>
					</select>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='57641.İndirim'>1 %</td>
				<td width="175"><input type="text" name="discount1" id="discount1" style="width:150px;" class="moneybox" value="" maxlength="5" onKeyUp="return(FormatCurrency(this,event));"></td>
				<td>Back End Rebate(<cf_get_lang dictionary_id='57673.Tutar'>)</td>
				<td><input type="text" name="rebate_cash_1" id="rebate_cash_1" style="width:101px;" class="moneybox"  value="" onKeyUp="return(FormatCurrency(this,event));">
					<input type="hidden" name="rebate_cash_1_money" id="rebate_cash_1_money" style="width:45px;" value="<cfoutput>#get_price_money.money#</cfoutput>" readonly>
					<select name="rebate_cash_1_money_" id="rebate_cash_1_money_" style="width:45px;" disabled="disabled">
					<cfoutput query="get_money">
						<option value="#money#" <cfif get_price_money.money eq money>Selected</cfif>>#money#</option>
					</cfoutput>
					</select>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='57641.İndirim'>2 %</td>
				<td><input type="text" name="discount2" id="discount2" style="width:150px;" class="moneybox" value="" maxlength="5" onKeyUp="return(FormatCurrency(this,event));"></td>
				<td>Back End Rebate(<cf_get_lang dictionary_id='58456.Oran'>)%</td>
				<td><input type="text" name="rebate_rate" id="rebate_rate" style="width:150px;" class="moneybox"  value="" onKeyUp="return(FormatCurrency(this,event));"></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='57641.İndirim'>3 %</td>
				<td><input type="text" name="discount3" id="discount3" style="width:150px;" class="moneybox"   value="" maxlength="5" onKeyUp="return(FormatCurrency(this,event));"></td>
				<td><cf_get_lang dictionary_id='37660.Mal Fazlası'></td>
				<td><input type="text" name="extra_product_1" id="extra_product_1" style="width:73px;" class="moneybox"  value="" onKeyUp="return(FormatCurrency(this,event));">
					<input type="text" name="extra_product_2" id="extra_product_2" style="width:74px;" class="moneybox"  value="" onKeyUp="return(FormatCurrency(this,event));">
				</td>				
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='57641.İndirim'>4 %</td>
				<td><input type="text" name="discount4" id="discount4" style="width:150px;" class="moneybox" value="" maxlength="5" onKeyUp="return(FormatCurrency(this,event));"></td>
				<td><cf_get_lang dictionary_id='37741.Fiyat Koruma Süresi(Gün)'></td>
				<td><input type="text" name="PRICE_PROTECTION_DAY" id="PRICE_PROTECTION_DAY" class="moneybox" value="" onKeyUp="return(FormatCurrency(this,event,0));" style="width:150px;"></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='57641.İndirim'>5 %</td>
				<td> <input type="text" name="discount5" id="discount5" style="width:150px;" class="moneybox" value="" maxlength="5" onKeyUp="return(FormatCurrency(this,event));"></td>
				<td><cf_get_lang dictionary_id='37742.İade Süresi (Gün)'> / <cf_get_lang dictionary_id='58456.Oran'>(%)</td>
				<td>
					<input type="text" name="return_day" id="return_day" value="" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" style="width:73px;">
					<input type="text" name="return_rate" id="return_rate" value="" class="moneybox" onKeyUp="return(FormatCurrency(this,event));" style="width:74px;">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></td>
				<td><select name="paymethod_id" id="paymethod_id" style="width:150px;">
					<cfoutput query="get_paymethods">
						<option value="#paymethod_id#">#paymethod#</option>
					</cfoutput>
					</select>
				</td>
				<td><cf_get_lang dictionary_id='37072.Teslim Süresi'> (<cf_get_lang dictionary_id='57490.Gün'>)</td>
				<td><input type="text" name="delivery_dateno" id="delivery_dateno" value="" class="moneybox" onKeyUp="return(FormatCurrency(this,event,0));" style="width:150px;"></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id="58859.Süreç">*</td>
				<td><cf_workcube_process is_upd='0' process_cat_width='150px' is_detail='0'></td>
			</tr>
		</table>
		<tr id="price_cat_row" style="display:none">
			<td colspan="4">
		<table border="0" cellpadding="1" cellspacing="0" width="100%">
			<tr>
				<td colspan="5" class="txtboldblue"><cf_get_lang dictionary_id='37028.Fiyat Listeleri'></td>
			</tr>
			<cfparam name="attributes.mode" default="5">
			<cfset attributes.startrow=1>
			<cfset attributes.maxrows = get_price_cats.recordcount>
			<cfloop query="get_price_cats">
				<cfif ((currentrow mod attributes.mode is 1)) or (currentrow eq 1)>
					<tr height="22">
				</cfif>
				<td nowrap="nowrap"><cfoutput><input type="checkbox" name="PRICE_CATS_LIST" id="PRICE_CATS_LIST" value="#price_catid#">#price_cat#</cfoutput></td>
				<cfif ((currentrow mod attributes.mode is 0)) or (currentrow eq recordcount)>
					</tr>
				</cfif>                  
			</cfloop>
		</table>
			<cf_popup_box_footer>
				<cf_workcube_buttons type_format='1' is_upd='0' add_function='page_control()'>
			</cf_popup_box_footer>
	</cfform>
</cf_popup_box>
<script type="text/javascript">
	function change_money(control_type)
	{
		if(document.form_basket.purchase_sales.value == 1)
			var price_type=0;
		else
			var price_type=1;
		var get_query=wrk_query('SELECT MONEY FROM PRICE_STANDART WHERE PURCHASESALES = '+price_type+' AND PRICESTANDART_STATUS = 1 AND PRODUCT_ID = <cfoutput>#attributes.pid#</cfoutput>','dsn1');
		if(get_query.recordcount)
		{
			for(var inf_count_=0; inf_count_ < document.form_basket.rebate_cash_1_money_.options.length; inf_count_++)
				if(document.form_basket.rebate_cash_1_money_.options[inf_count_].value == get_query.MONEY)
					document.form_basket.rebate_cash_1_money_.selectedIndex=inf_count_;
					
			for(var count_a=0; count_a < document.form_basket.discount_cash_money_.options.length; count_a++)
				if(document.form_basket.discount_cash_money_.options[count_a].value == get_query.MONEY)
					document.form_basket.discount_cash_money_.selectedIndex=count_a;
			document.form_basket.rebate_cash_1_money.value=get_query.MONEY;
			document.form_basket.discount_cash_money.value=get_query.MONEY;
		}
	}
	
	function page_control()
	{
		var selected_price_cat = 0;
		for(i=0; i<form_basket.PRICE_CATS_LIST.length; i++)
		{
			if(document.form_basket.PRICE_CATS_LIST[i].checked)
				var selected_price_cat = 1;
		}
		
		if(selected_price_cat == 1 && (document.form_basket.company_id.value != '' && document.form_basket.company_name.value != '') && document.form_basket.purchase_sales.value == 2)
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
