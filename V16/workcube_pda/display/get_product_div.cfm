<cfsetting showdebugoutput="no">
<cf_date tarih='attributes.price_date'>
<cfquery name="GET_PRODUCT_INFO" datasource="#DSN3#">
	SELECT
		<cfif isdefined('attributes.offer_type_id') and attributes.offer_type_id is 0><!--- 1- satış --->
			PRICE.PRICE,
			PRICE.MONEY	,	
		<cfelseif isdefined('attributes.offer_type_id') and attributes.offer_type_id is 1><!--- 0-abonelik --->
			PRICE_STANDART.PRICE,
			PRICE_STANDART.MONEY,
		<cfelse>
			PRICE_STANDART.PRICE,
			PRICE_STANDART.MONEY,
		</cfif>
		STOCKS.PRODUCT_ID,
		STOCKS.PRODUCT_NAME,
		STOCKS.PRODUCT_CODE,
		STOCKS.BARCOD,
		STOCKS.PROPERTY,		
		STOCKS.STOCK_ID,
		STOCKS.TAX,
		STOCKS.MANUFACT_CODE,
		PU.ADD_UNIT,
		PU.PRODUCT_UNIT_ID,
		PU.MULTIPLIER
	FROM
		<cfif isdefined('attributes.offer_type_id') and attributes.offer_type_id is 0>
			PRICE,
		<cfelse>
			PRICE_STANDART,
		</cfif>
		STOCKS,
		PRODUCT_UNIT AS PU
	WHERE
		STOCKS.PRODUCT_STATUS = 1 AND
		STOCKS.STOCK_STATUS = 1 AND
		STOCKS.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
		STOCKS.PRODUCT_ID = PU.PRODUCT_ID AND
		PU.MAIN_UNIT = PU.ADD_UNIT AND		
		<cfif isdefined('attributes.offer_type_id') and attributes.offer_type_id is 0>
			STOCKS.PRODUCT_ID = PRICE.PRODUCT_ID AND
			ISNULL(PRICE.STOCK_ID,0)=0 AND
			ISNULL(PRICE.SPECT_VAR_ID,0)=0 AND
            <cfif isDefined('session.pda.offer_subs_price_cat_id')>
				PRICE.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.offer_subs_price_cat_id#"> AND
			</cfif>
            (
				PRICE.STARTDATE <= #attributes.price_date# AND
				(PRICE.FINISHDATE >= #attributes.price_date# OR PRICE.FINISHDATE IS NULL)
			)
		<cfelseif isdefined('attributes.offer_type_id') and attributes.offer_type_id is 1>
			STOCKS.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND
			PRICE_STANDART.PURCHASESALES = 1 AND
			PRICE_STANDART.PRICESTANDART_STATUS = 1 
		<cfelse>
			STOCKS.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND
			PRICE_STANDART.PURCHASESALES = 1 AND
			PRICE_STANDART.PRICESTANDART_STATUS = 1 
		</cfif>
		<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
			AND 
			(
				STOCKS.PRODUCT_NAME LIKE '<cfif Len(attributes.keyword) gt 3>%</cfif>#UrlDecode(attributes.keyword)#%' OR
				STOCKS.BARCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">
			)
		</cfif>
	ORDER BY
		STOCKS.PRODUCT_NAME, STOCKS.PROPERTY
</cfquery>
<cf_box title="Stoklar" body_style="overflow-y:scroll;height:100px;" call_function='gizle(products_div);'>
<table cellspacing="1" cellpadding="2" border="0" class="color-border" style="width:100%">
	<tr class="color-header" style="height:22px;">	
		<td class="form-title">Ürün</td>
		<td class="form-title" style="text-align:right">Fiyat</td>
        <td></td>
	</tr>
	<cfif get_product_info.recordcount>
		<cfoutput query="get_product_info">
			<cfquery name="GET_PRODUCT_CODE_2" datasource="#DSN3#">
				SELECT PRODUCT_CODE_2 FROM PRODUCT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
			</cfquery>
			<cfquery name="GET_PRODUCT_INFO_PLUS" datasource="#DSN3#">
				SELECT PROPERTY1 FROM PRODUCT_INFO_PLUS WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
			</cfquery>
			<cfif get_product_info_plus.recordcount><cfset property1=get_product_info_plus.property1><cfelse><cfset property1=''></cfif>
			<tr class="color-row">
                <td>#product_name# <cfif len(property)> #property#</cfif></td>
				<td style="text-align:right">#TLFormat(price)# #money#</td>
                <cfif isDefined("attributes.list") and attributes.list eq 1>
                	<td><a onClick="add_product_search('#attributes.div_name#','#stock_id#','#product_id#','#product_name# <cfif len(property)> #property#</cfif>','#price#','#money#','#add_unit#','#product_unit_id#');" style="cursor:hand;" title="Ürün Seç" class="tableyazi"><img src="/images/plus_list.gif" class="form_icon"></a></td>
                <cfelse>	
                    <td><a onClick="add_product(0,'#stock_id#','#product_id#','#product_name# <cfif len(property)> #property#</cfif>','#price#','#money#','#add_unit#','#product_unit_id#','#tax#','#manufact_code#','#get_product_code_2.product_code_2#','#property1#');<!---toplam_hesapla();--->" style="cursor:hand;" title="Ürün Seç" class="tableyazi"><img src="/images/plus_list.gif" class="form_icon"></td>
				</cfif>
			</tr>
		</cfoutput>
	<cfelse>
		<tr class="color-row" style="height:20px;">
			<td colspan="2">Kayıt Yok !</td>
		</tr>
	</cfif>
</table>
</cf_box>
<script language="javascript" type="text/javascript">
	function add_product_search(div_name,stock_id,product_id,product_name)
	{
		document.getElementById("product_id").value = product_id;
		document.getElementById("product_name").value = product_name;
		gizle(document.getElementById(div_name));
		return false;
	}
	function add_product(no,stock_id,product_id,product,price,other_money,unit,unit_id,tax,manufact_code,product_code_2,property1,type)
	{
		var no = document.getElementById('rows_').value;
		goster(mydiv);
		var price_other = price;
		var price_kdv  = wrk_round(price * (1+(tax/100)),2);
		no++;
		newRow = document.getElementById("mydiv").insertRow(document.getElementById("mydiv").rows.length);
		newRow.setAttribute("name","frm_row" + no);
		newRow.setAttribute("id","frm_row" + no);
		newRow.setAttribute("NAME","frm_row" + no);
		newRow.setAttribute("ID","frm_row" + no);
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div id="n_my_div' + no +'"><input  type="hidden" value="1" name="row_kontrol'+no+'" id="row_kontrol'+no+'" ><a href="javascript://" onclick="sil('+no+');"><img  src="images/delete_list.gif" border="0"></a><input type="hidden" name="stock_id' + no +'" id="stock_id' + no +'" value="'+stock_id+'"><input type="hidden" name="unit_id' + no +'" id="unit_id' + no +'" value="'+unit_id+'"><input type="hidden" name="tax' + no +'" id="tax' + no +'" value="'+tax+'"><input type="hidden" name="product_id' + no +'" id="product_id' + no +'" value="'+product_id+'"><input type="text" name="product_name' + no +'" id="product_name' + no +'" style="width:150px;" value="'+product+'"><input type="text" name="amount' + no +'" id="amount' + no +'" style="width:30px;" value="1" class="moneybox" onChange="FormatCurrency(this);" onKeyUp="FormatCurrency(this);"><input type="hidden" name="price' + no +'" id="price' + no +'" value="'+commaSplit(price)+'"><input type="hidden" name="price_kdv' + no +'" id="price_kdv' + no +'" value="'+commaSplit(price_kdv)+'"><input type="hidden" style="width:30px;" readonly="yes" name="other_money_' + no +'" id="other_money_' + no +'" value="'+other_money+'"><input type="text" name="unit' + no +'" id="unit' + no +'" value="'+unit+'" style="width:30px;" readonly="readonly"><input type="text" name="product_name_other' + no +'" id="product_name_other' + no +'" value="" style="width:50px;">';
		document.getElementById('rows_').value = parseInt(document.getElementById('rows_').value) + 1;
		<!---change_offer_type_head();
		goster(show_buttons);--->
		/*goster(mydiv);
		var price_other = price;
		var price_kdv  = wrk_round(price * (1+(tax/100)),2);
		var moneyArraylen=moneyArray.length;
		for(var mon_i=0; mon_i<moneyArraylen; mon_i++)
		{
			if(moneyArray[mon_i]==other_money)
			{
				price  = wrk_round(price*rate2Array[mon_i]/rate1Array[mon_i],2); 
				price_kdv  = wrk_round(price_kdv*rate2Array[mon_i]/rate1Array[mon_i],2); 
			}
			if(moneyArray[mon_i]=='USD')
			{
				price_other_usd  = wrk_round((price/rate2Array[mon_i])*rate1Array[mon_i],2); 
			}
		}
		no++;
		newRow = document.getElementById("mydiv").insertRow(document.getElementById("mydiv").rows.length);
		newRow.setAttribute("name","frm_row" + no);
		newRow.setAttribute("id","frm_row" + no);
		newRow.setAttribute("NAME","frm_row" + no);
		newRow.setAttribute("ID","frm_row" + no);
		newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div id="n_my_div' + no +'"><input  type="hidden" value="1" name="row_kontrol'+no+'" id="row_kontrol" ><a href="javascript://" onclick="sil('+no+');"><img  src="images/delete_list.gif" border="0"></a><input type="hidden" name="stock_id' + no +'" value="'+stock_id+'"><input type="hidden" name="unit' + no +'" value="'+unit+'"><input type="hidden" name="unit_id' + no +'" value="'+unit_id+'"><input type="hidden" name="tax' + no +'" value="'+tax+'"><input type="hidden" name="product_id' + no +'" value="'+product_id+'"><input type="text" style="width:150px;" name="product_name' + no +'" value="'+product+'"><input style="width:30px;" type="text" name="amount' + no +'" value="1" class="moneybox" onChange="FormatCurrency(this);toplam_hesapla();" onKeyUp="FormatCurrency(this);toplam_hesapla();"><input type="hidden" name="price' + no +'" id="price' + no +'" value="'+commaSplit(price)+'"><input type="hidden" name="price_kdv' + no +'" value="'+commaSplit(price_kdv)+'"><input type="hidden" name="price_other' + no +'" id="price_other' + no +'" value="'+commaSplit(price_other)+'" readonly="yes" style="width:50px;"><input type="hidden" name="price_other_usd' + no +'" value="'+commaSplit(price_other_usd)+'"><input type="text" style="width:30px;" readonly="yes" name="other_money_' + no +'" id="other_money_' + no +'" value="'+other_money+'"><input type="hidden" name="other_money_value_' + no +'" id="other_money_value_' + no +'" value="'+commaSplit(price_other)+'" style="width:50px;" readonly="yes"><input type="text" style="width:50px;" name="row_last_total' + no +'" value="'+commaSplit(price)+'" readonly><input type="hidden" style="width:50px;" name="row_last_total_usd' + no +'" value="'+commaSplit(price_other_usd)+'" readonly><input type="hidden" name="manufact_code' + no +'" value="'+manufact_code+'"><input type="hidden" name="iskonto_tutar' + no +'"><input type="hidden" name="product_code_2_' + no +'" value="'+product_code_2+'"><input type="hidden" name="property1_' + no +'" value="'+property1+'"></div>';
		
		/*var satir ='<div id="n_my_div' + no +'"><input  type="hidden" value="1" name="row_kontrol'+no+'" id="row_kontrol" ><a href="javascript://" onclick="sil('+no+');"><img  src="images/delete_list.gif" border="0"></a><input type="hidden" name="stock_id' + no +'" value="'+stock_id+'"><input type="hidden" name="unit' + no +'" value="'+unit+'"><input type="hidden" name="unit_id' + no +'" value="'+unit_id+'"><input type="hidden" name="tax' + no +'" value="'+tax+'"><input type="hidden" name="product_id' + no +'" value="'+product_id+'"><input type="text" style="width:150px;" name="product_name' + no +'" value="'+product+'"><input style="width:30px;" type="text" name="amount' + no +'" value="1" class="moneybox" onChange="FormatCurrency(this);toplam_hesapla();" onKeyUp="FormatCurrency(this);toplam_hesapla();"><input type="hidden" name="price' + no +'" value="'+commaSplit(price)+'"><input type="hidden" name="price_kdv' + no +'" value="'+commaSplit(price_kdv)+'"><input type="text" name="price_other' + no +'" value="'+commaSplit(price_other)+'" readonly="yes" style="width:50px;"><input type="hidden" name="price_other_usd' + no +'" value="'+commaSplit(price_other_usd)+'"><input type="text" style="width:30px;" readonly="yes"  name="other_money_' + no +'" value="'+other_money+'"><input type="hidden" name="other_money_value_' + no +'" value="'+commaSplit(price_other)+'" style="width:50px;" readonly="yes"><input type="hidden" style="width:50px;" name="row_last_total' + no +'" value="'+commaSplit(price)+'" readonly><input type="hidden" style="width:50px;" name="row_last_total_usd' + no +'" value="'+commaSplit(price_other_usd)+'" readonly><input type="hidden" name="manufact_code' + no +'" value="'+manufact_code+'"><input type="hidden" name="iskonto_tutar' + no +'"><input type="hidden" name="product_code_2_' + no +'" value="'+product_code_2+'"><input type="hidden" name="property1_' + no +'" value="'+property1+'"></div>';
		document.getElementById('mydiv').innerHTML = document.getElementById('mydiv').innerHTML + satir;*/
		//document.getElementById('row_count').value = parseInt(document.getElementById('row_count').value) + 1;
		<!---change_offer_type_head();
		goster(show_buttons);--->
		
	}
</script>
