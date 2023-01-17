<cfset recordnumber = 0>
<cfif IsDefined("attributes.id")>
	<cfinclude template="../query/get_catalog_promotion_products.cfm">
	<cfset recordnumber = GET_CATALOG_PRODUCT.RecordCount>
</cfif>
<cfinclude template="../../contract/query/get_moneys.cfm">
<cfinclude template="../../contract/query/get_units.cfm">

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="color-row" height="100%">
  <tr>
    <td valign="top">
      <table cellspacing="0" cellpadding="0" border="0" width="99%" align="center">
    	<input name="record_num" id="record_num" type="hidden" value="<cfoutput>#recordnumber#</cfoutput>">
        <tr class="color-border">
          <td>
            <table cellpadding="2" cellspacing="1" border="0" width="100%" name="table1" id="table1">
              <tr class="color-header" height="22">
                <td align="center">&nbsp;</td>
                <td class="form-title" nowrap>&nbsp;</td>
                <td class="form-title" nowrap>&nbsp;</td>
                <td class="form-title" nowrap>&nbsp;</td>
                <td colspan="2" align="center" nowrap class="form-title"><cf_get_lang dictionary_id='37227.standart'></td>
                <td class="form-title" nowrap>&nbsp;</td>
                <td colspan="5" nowrap class="form-title" align="center"><cf_get_lang dictionary_id='57641.iskont'></td>
                <td colspan="2" align="center" class="form-title"><cf_get_lang dictionary_id='58258.Maliyet'></td>
                <td colspan="2" align="center" nowrap class="form-title"><cf_get_lang dictionary_id='57639.kdv'></td>
                <td class="form-title" nowrap>&nbsp;</td>
                <td align="right" nowrap class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='37049.Aksiyon Fiyat'></td>
                <td class="form-title" nowrap>&nbsp;</td>
                <td class="form-title" nowrap>&nbsp;</td>
              </tr>
              <tr class="color-list" >
                <td width="15" align="center"><a href="javascript:if (document.all.startdate.value == '') {alert('Başlangıç tarihini giriniz !');} else windowopen('<cfoutput>#request.self#?fuseaction=product.popup_products&module_name=product&var_=#var_#&is_action=1&startdate='+document.all.startdate.value</cfoutput>,'page');"><img src="/images/plus_list.gif"  border="0"></a></td> 
				<td class="txtboldblue" nowrap><cf_get_lang dictionary_id='57629.Açıklama'></td>
                <td class="txtboldblue" nowrap width="30"><cf_get_lang dictionary_id='57636.Birim'></td>
                <td class="txtboldblue" nowrap width="50"><cf_get_lang dictionary_id='57489.Para Br'></td>
                <td width="70" align="right" nowrap class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='58176.alış'></td>
                <td width="70" align="right" nowrap class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='57448.satış'></td>
				<td class="txtboldblue" nowrap width="45"><cf_get_lang dictionary_id='37313.S Mrj'></td>
                <td class="txtboldblue" nowrap width="20" align="center">1</td>
                <td class="txtboldblue" nowrap width="20" align="center">2</td>
                <td class="txtboldblue" nowrap width="20" align="center">3</td>
                <td class="txtboldblue" nowrap width="20" align="center">4</td>
                <td class="txtboldblue" nowrap width="20" align="center">5</td>
                <td width="70" align="right" class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='58083.Net'></td>
                <td width="70" align="right" nowrap class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='58716.KDV li'></td>
                <td class="txtboldblue" nowrap width="30"><cf_get_lang dictionary_id='58176.alış'></td> 
				<td class="txtboldblue" nowrap width="30"><cf_get_lang dictionary_id='57448.satış'></td>
                <td class="txtboldblue" nowrap width="45"><cf_get_lang dictionary_id='37048.A Mrj'></td>
                <td width="75" align="right" nowrap class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='37365.KDV Dahil'></td>
                <td class="txtboldblue" nowrap width="30"><cf_get_lang dictionary_id='57640.Vade'></td>
                <td class="txtboldblue" nowrap width="60"><cf_get_lang dictionary_id='37110.Raf Tipi'></td>
              </tr>
			  <cfif IsDefined("attributes.id") and recordnumber>
			  	<cfoutput query="GET_CATALOG_PRODUCT">
					<cfquery name="GET_PRODUCT_NAME" datasource="#dsn3#">
						SELECT PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID = #PRODUCT_ID#
					</cfquery>
                  <input type="Hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
                  <input type="Hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#PRODUCT_ID#">
                  <input type="Hidden" name="unit_id#currentrow#" id="unit_id#currentrow#" value="#PRODUCT_UNIT_ID#">
                  <tr id="frm_row#currentrow#" height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
					<td align="center" width="15"><a style="cursor:pointer" onclick="if (confirm('Silmek istediğinize emin misiniz?')) sil(#currentrow#);"><img  src="images/delete_list.gif" border="0" title="Ürünü Sil"></a></td>
					<!--- if (confirm('Ürünü Silmek İstediğinizden Emin misiniz?'))  <cf_get_lang no='100.'>--->
					<td nowrap><input type="text" name="product_name#currentrow#" id="product_name#currentrow#" style="width:100px;" class="boxtext" value="#GET_PRODUCT_NAME.product_name#" readonly><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#','medium');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a></td>
                    <td><input type="Text" name="unit#currentrow#" id="unit#currentrow#" value="#UNIT#" style="width:100%;" class="boxtext" readonly></td>
                    <td><input type="text" name="money#currentrow#" id="money#currentrow#" value="#MONEY#" style="width:100%;" class="boxtext" readonly></td>
                    <td><input type="text" name="p_price#currentrow#" id="p_price#currentrow#" style="width:100%;" value="#TLFormat(PURCHASE_PRICE)#" class="box" readonly></td>
                    <td><input type="text" name="s_price#currentrow#" id="s_price#currentrow#" style="width:100%;" value="#TLFormat(SALES_PRICE)#" class="box" readonly></td>
                    <td><input type="text" name="profit_margin#currentrow#" id="profit_margin#currentrow#" style="width:45px;" value="#TLFormat(profit_margin)#" class="box" readonly></td>
					<td><input type="text" name="disc_ount1#currentrow#" id="disc_ount1#currentrow#" style="width:100%;" value="#TLFormat(DISCOUNT1)#" class="box" onBlur="discChanged(#currentrow#);" onkeyup="return(FormatCurrency(this,event));"></td>
                    <td><input type="text" name="disc_ount2#currentrow#" id="disc_ount2#currentrow#" style="width:100%;" value="#TLFormat(DISCOUNT2)#" class="box" onBlur="discChanged(#currentrow#);" onkeyup="return(FormatCurrency(this,event));"></td>
                    <td><input type="text" name="disc_ount3#currentrow#" id="disc_ount3#currentrow#" style="width:100%;" value="#TLFormat(DISCOUNT3)#" class="box" onBlur="discChanged(#currentrow#);" onkeyup="return(FormatCurrency(this,event));"></td>
                    <td><input type="text" name="disc_ount4#currentrow#" id="disc_ount4#currentrow#" style="width:100%;" value="#TLFormat(DISCOUNT4)#" class="box" onBlur="discChanged(#currentrow#);" onkeyup="return(FormatCurrency(this,event));"></td>
                    <td><input type="text" name="disc_ount5#currentrow#" id="disc_ount5#currentrow#" style="width:100%;" value="#TLFormat(DISCOUNT5)#" class="box" onBlur="discChanged(#currentrow#);" onkeyup="return(FormatCurrency(this,event));"></td>
					<td><input type="text" name="disc_ount6#currentrow#" id="disc_ount6#currentrow#" style="width:100%;" value="#TLFormat(DISCOUNT6)#" class="box" onBlur="discChanged_2(#currentrow#);" onkeyup="return(FormatCurrency(this,event));"></td>
                    <td><input type="text" name="disc_ount7#currentrow#" id="disc_ount7#currentrow#" style="width:100%;" value="#TLFormat(DISCOUNT7)#" class="box" onBlur="discChanged_2(#currentrow#);" onkeyup="return(FormatCurrency(this,event));"></td>
                    <td><input type="text" name="disc_ount8#currentrow#" id="disc_ount8#currentrow#" style="width:100%;" value="#TLFormat(DISCOUNT8)#" class="box" onBlur="discChanged_2(#currentrow#);" onkeyup="return(FormatCurrency(this,event));"></td>
                    <td><input type="text" name="disc_ount9#currentrow#" id="disc_ount9#currentrow#" style="width:100%;" value="#TLFormat(DISCOUNT9)#" class="box" onBlur="discChanged_2(#currentrow#);" onkeyup="return(FormatCurrency(this,event));"></td>
                    <td><input type="text" name="disc_ount10#currentrow#" id="disc_ount10#currentrow#" style="width:100%;" value="#TLFormat(DISCOUNT10)#" class="box" onBlur="discChanged_2(#currentrow#);" onkeyup="return(FormatCurrency(this,event));"></td>
                    <td><input type="text" name="row_nettotal#currentrow#" id="row_nettotal#currentrow#" style="width:70px;" value="#TLFormat(row_nettotal)#" class="box" readonly></td>
					<td><input type="text" name="row_lasttotal#currentrow#" id="row_lasttotal#currentrow#" style="width:70px;" value="#TLFormat(ROW_TOTAL)#" class="box" readonly></td>
                    <td><input type="text" name="row_nettotal_2#currentrow#" id="row_nettotal_2#currentrow#" style="width:70px;" value="#TLFormat(row_nettotal_2)#" class="box" readonly></td>
                    <td><input type="text" name="tax_purchase#currentrow#" id="tax_purchase#currentrow#" style="width:100%;" value="#TLFormat(tax_purchase)#" class="box" readonly></td>
                    <td><input type="text" name="tax#currentrow#" id="tax#currentrow#" style="width:100%;" value="#TLFormat(tax)#" class="box" readonly></td>
					<td><input type="text" name="action_profit_margin#currentrow#" id="action_profit_margin#currentrow#" style="width:100%;" value="#TLFormat(action_profit_margin)#" class="box" onBlur="actProfMargChanged(#currentrow#);" onkeyup="return(FormatCurrency(this,event));"></td>
                    <td><input type="text" name="action_price#currentrow#" id="action_price#currentrow#" style="width:100%;" value="#TLFormat(action_price)#" class="box" onBlur="actPriceChanged(#currentrow#);" onkeyup="return(FormatCurrency(this,event));"></td>
                    <td><input type="text" name="duedate#currentrow#" id="duedate#currentrow#" style="width:100%;" class="box" value="#duedate#"></td>
					<cfif len(shelf_id)>
						<cfquery name="GET_SHELF_NAME" datasource="#dsn#">
							SELECT SHELF_NAME FROM SHELF WHERE SHELF_MAIN_ID = #shelf_id#
						</cfquery>
					</cfif>
					<td nowrap><input  type="hidden"  name="shelf_id#currentrow#" id="shelf_id#currentrow#" value="#shelf_id#">
                    <input type="text" name="shelf_name#currentrow#" id="shelf_name#currentrow#" style="width:50px;" class="boxtext" value="<cfif len(shelf_id)>#GET_SHELF_NAME.SHELF_NAME#</cfif>"><a href="javascript://" onClick="getShelf(#currentrow#);"><img border="0" src="/images/plus_thin.gif" align="absmiddle" title="<cf_get_lang dictionary_id='37782.Raf Seç'>"></a></td>
                  </tr>
				</cfoutput>
			  </cfif>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>

<script type="text/javascript">
	row_count=<cfoutput>#recordnumber#</cfoutput>;
	function sil(sy)
	{
		var my_element=eval("form_basket.row_kontrol"+sy);
		my_element.value=0;

		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";

		/*var my_element = eval('form_basket.frm_row' + sy);
		my_element.innerText="";*/		
	}
	function add_row(sirano,product_id,product_name,tax,tax_purchase,add_unit,product_unit_id,money,is_serial_no,discount1,discount2,discount3,discount4,discount5,discount6,discount7,discount8,discount9,discount10,del_date_no,p_price,s_price)
	{
			row_count++;
			var newRow;
			var newCell;
			
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
			newRow.className = 'color-row';
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);		
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);		

			document.getElementById('record_num').value=row_count;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<<<<<<<<<<<a style="cursor:pointer" onclick="if (confirm(\'Silmek istediğinize emin misiniz?\')) sil(' + row_count + ');"><img src="images/delete_list.gif" border="0" alt="Ürünü Sil"></a>';	
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol' + row_count + '" ><input  type="hidden" name="product_id' + row_count + '" value="' + product_id + '"><input  type="hidden"  name="unit_id'  + row_count + '"  value="' + product_unit_id + '"><input type="text" name="product_name' + row_count + '" style="width:100px;" class="boxtext" value="' + product_name + '"><a href="javascript://" onClick="pencere_ac(' + product_id + ');"><img border="0" src="/images/plus_thin.gif" align="absmiddle" alt="<cf_get_lang dictionary_id='57725.Ürün Seç'>"></a>';

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="unit' + row_count + '" style="width:100%;" class="boxtext" readonly value="' + add_unit + '">';

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="money' + row_count + '" style="width:100%;" class="boxtext" readonly value="' + money + '">';

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="p_price' + row_count + '"  value="' + commaSplit(f2(p_price)) + '" style="width:100%;" class="box" readonly="yes" onkeyup="return(FormatCurrency(this,event));">';/*onBlur="if (FormatCurrency(this,event)) {return true;} else {if (is_numeric(this,"Alış Fiyatı Sayısal Olmalıdır!")) {return false;}}" */

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="s_price' + row_count + '"  value="' + commaSplit(f2(s_price)) + '" style="width:100%;" class="box" readonly="yes" onkeyup="return(FormatCurrency(this,event));">';/*onBlur="if (FormatCurrency(this,event)) {return true;} else {if (is_numeric(this,"Satış Fiyatı Sayısal Olmalıdır!")) {return false;}}" */

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="profit_margin' + row_count + '"  style="width:100%;" class="box" readonly="yes" onkeyup="return(FormatCurrency(this,event));">';

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="disc_ount1' + row_count + '"  value="' + commaSplit(f2(discount1)) + '" style="width:100%;" class="box" onBlur="discChanged(' + row_count + ');" onkeyup="return(FormatCurrency(this,event));">';

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="disc_ount2' + row_count + '"  value="' + commaSplit(f2(discount2)) + '" style="width:100%;" class="box" onBlur="discChanged(' + row_count + ');" onkeyup="return(FormatCurrency(this,event));">';

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="disc_ount3' + row_count + '"  value="' + commaSplit(f2(discount3)) + '" style="width:100%;" class="box" onBlur="discChanged(' + row_count + ');" onkeyup="return(FormatCurrency(this,event));">';

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="disc_ount4' + row_count + '"  value="' + commaSplit(f2(discount4)) + '" style="width:100%;" class="box" onBlur="discChanged(' + row_count + ');" onkeyup="return(FormatCurrency(this,event));">';

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="disc_ount5' + row_count + '"  value="' + commaSplit(f2(discount5)) + '" style="width:100%;" class="box" onBlur="discChanged(' + row_count + ');" onkeyup="return(FormatCurrency(this,event));">';

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="disc_ount6' + row_count + '"  value="' + commaSplit(f2(discount6)) + '" style="width:100%;" class="box" onBlur="discChanged_2(' + row_count + ');" onkeyup="return(FormatCurrency(this,event));">';

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="disc_ount7' + row_count + '"  value="' + commaSplit(f2(discount7)) + '" style="width:100%;" class="box" onBlur="discChanged_2(' + row_count + ');" onkeyup="return(FormatCurrency(this,event));">';

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="disc_ount8' + row_count + '"  value="' + commaSplit(f2(discount8)) + '" style="width:100%;" class="box" onBlur="discChanged_2(' + row_count + ');" onkeyup="return(FormatCurrency(this,event));">';

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="disc_ount9' + row_count + '"  value="' + commaSplit(f2(discount9)) + '" style="width:100%;" class="box" onBlur="discChanged_2(' + row_count + ');" onkeyup="return(FormatCurrency(this,event));">';

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="disc_ount10' + row_count + '"  value="' + commaSplit(f2(discount10)) + '" style="width:100%;" class="box" onBlur="discChanged_2(' + row_count + ');" onkeyup="return(FormatCurrency(this,event));">';

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="row_nettotal' + row_count + '"  style="width:70px;" class="box" readonly="yes" onkeyup="return(FormatCurrency(this,event));">';

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="row_lasttotal' + row_count + '"  style="width:70px;" class="box" readonly="yes" onkeyup="return(FormatCurrency(this,event));">';

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="row_nettotal_2' + row_count + '"  style="width:70px;" class="box" readonly="yes" onkeyup="return(FormatCurrency(this,event));">';

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="tax_purchase' + row_count + '"  value="' + commaSplit(f2(tax_purchase)) + '" style="width:100%;" class="box" readonly="yes" onkeyup="return(FormatCurrency(this,event));">';

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="tax' + row_count + '"  value="' + commaSplit(f2(tax)) + '" style="width:100%;" class="box" readonly="yes" onkeyup="return(FormatCurrency(this,event));">';

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="action_profit_margin' + row_count + '"  value="0" style="width:100%;" class="box" onBlur="actProfMargChanged(' + row_count + ');" onkeyup="return(FormatCurrency(this,event));">';

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="action_price' + row_count + '"  style="width:100%;" class="box" onBlur="return(actPriceChanged(' + row_count + '));" onkeyup="return(FormatCurrency(this,event));">';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="duedate' + row_count + '"  value="0" style="width:100%;" class="box">';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input  type="hidden"  name="shelf_id' + row_count + '" ><input type="text" name="shelf_name' + row_count + '" style="width:50px;" class="boxtext" value=""><a href="javascript://" onClick="getShelf(' + row_count + ');"><img border="0" src="/images/plus_thin.gif" align="absmiddle" alt="<cf_get_lang dictionary_id='37782.Raf Seç'>"></a>';
			
			/*S. Marj hesaplaniyor */
			if (p_price == 0)
				var profit_margin = 0;
			else
				var profit_margin = Math.round(( (s_price - p_price) / p_price ) * 100 * 100) / 100;
			eval("form_basket.profit_margin"+row_count).value = commaSplit(f2(profit_margin));

			/*Net Maliyet hesaplaniyor */
			eval("form_basket.row_nettotal"+row_count).value = commaSplit(f2( Math.round((p_price/10000000000) * ( (100-discount1) * (100-discount2) * (100-discount3) * (100-discount4) * (100-discount5) ) * 100) / 100 ));
			/*KDV li maliyet hesaplaniyor*/
			eval("form_basket.row_lasttotal"+row_count).value = commaSplit(f2( Math.round( (f1(eval("form_basket.row_nettotal"+row_count).value) * (Number(f1(eval("form_basket.tax_purchase"+row_count).value))+100) ) /100 ) )) ;  
			/*Aksiyon Fiyat KDV Dahil hesaplaniyor*/
			eval("form_basket.action_price"+row_count).value = commaSplit(f2( Math.round ( ( (f1(eval("form_basket.row_nettotal"+row_count).value)*(Number(f1(eval("form_basket.action_profit_margin"+row_count).value)) + 100))*(Number(f1(eval("form_basket.tax"+row_count).value)) + 100) ) / 10000 ) ));

			/*Net Maliyet 2 hesaplaniyor (10 indirim de dahil maliyete !!!)*/
			eval("form_basket.row_nettotal_2"+row_count).value = commaSplit(f2( Math.round((p_price/100000000000000000000) * ( (100-discount1) * (100-discount2) * (100-discount3) * (100-discount4) * (100-discount5) * (100-discount6) * (100-discount7) * (100-discount8) * (100-discount9) * (100-discount10) ) * 100) / 100 ));
	}		
	function pencere_ac(no)
	{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_product&is_sub_category=1&pid='+no,'medium');
	}
	function getShelf(no)
	{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=product.popup_list_shelf&shelf_id=form_basket.shelf_id'+no+'&shelf_name=form_basket.shelf_name'+no,'medium');
	}
	
	function f1(fld)/*javascript diline çevir 123.123.123.123,12 -> 123123123123.12*/
	{
		var temp_str = fld.toString();
		while (temp_str.indexOf('.') >= 0)
			{
			yer = temp_str.indexOf('.');
			temp_str = temp_str.substr(0,yer) + '' + temp_str.substr(yer+1, temp_str.length-yer-1);
			}
		if (temp_str.indexOf(',') >= 0)
			{
			yer = temp_str.indexOf(',');
			temp_str = temp_str.substr(0,yer) + '.' + temp_str.substr(yer+1, temp_str.length-yer-1);
			}
		return temp_str;
	}
	
	function f2(fld)/* bizim dilimize çevirir 123123123123.12 -> 123123123123,12*/
	{
		var temp_str = fld.toString();
		if (temp_str.indexOf('.') >= 0)
			{
			yer = temp_str.indexOf('.');
			temp_str = temp_str.substr(0,yer) + ',' + temp_str.substr(yer+1, temp_str.length-yer-1);
			}
		return temp_str;
	}
	function discChanged(rowcnt)
	{
		indirim1 = f1(eval("form_basket.disc_ount1"+rowcnt).value); 
		indirim2 = f1(eval("form_basket.disc_ount2"+rowcnt).value);
		indirim3 = f1(eval("form_basket.disc_ount3"+rowcnt).value);
		indirim4 = f1(eval("form_basket.disc_ount4"+rowcnt).value);
		indirim5 = f1(eval("form_basket.disc_ount5"+rowcnt).value);
		if (indirim1 == '') {eval("form_basket.disc_ount1"+rowcnt).value=0;indirim1 = 0;}
		if (indirim2 == '') {eval("form_basket.disc_ount2"+rowcnt).value=0;indirim2 = 0;}
		if (indirim3 == '') {eval("form_basket.disc_ount3"+rowcnt).value=0;indirim3 = 0;}
		if (indirim4 == '') {eval("form_basket.disc_ount4"+rowcnt).value=0;indirim4 = 0;}
		if (indirim5 == '') {eval("form_basket.disc_ount5"+rowcnt).value=0;indirim5 = 0;}
		actProfMarg = f1(eval("form_basket.action_profit_margin"+rowcnt).value);
		if (actProfMarg == '') {eval("form_basket.action_profit_margin"+rowcnt).value=0;actProfMarg = 0;}

		/*Net Maliyet hesaplaniyor */
		eval("form_basket.row_nettotal"+rowcnt).value = commaSplit(f2( Math.round( (f1(eval("form_basket.p_price"+rowcnt).value)/10000000000) * ( (100-indirim1) * (100-indirim2) * (100-indirim3) * (100-indirim4) * (100-indirim5) ) ) ));
		/*KDV li maliyet hesaplaniyor*/
		eval("form_basket.row_lasttotal"+rowcnt).value = commaSplit(f2( Math.round( (f1(eval("form_basket.row_nettotal"+rowcnt).value) * (Number(f1(eval("form_basket.tax_purchase"+rowcnt).value))+100) ) /100 ) ));  
		/*Aksiyon Fiyat KDV Dahil hesaplaniyor*/
		eval("form_basket.action_price"+rowcnt).value = commaSplit(f2( Math.round ( ( (f1(eval("form_basket.row_nettotal"+rowcnt).value)*(Number(actProfMarg) + 100))*(Number(f1(eval("form_basket.tax"+rowcnt).value)) + 100) ) / 10000 ) ));
		
		return discChanged_2(rowcnt);
	}
	function actProfMargChanged(rowcnt)
	{
		actProfMarg = f1(eval("form_basket.action_profit_margin"+rowcnt).value);
		if (actProfMarg == '') {eval("form_basket.action_profit_margin"+rowcnt).value=0;actProfMarg = 0;}

		/*KDV li maliyet hesaplaniyor*/
		eval("form_basket.row_lasttotal"+rowcnt).value = commaSplit(f2( Math.round( (f1(eval("form_basket.row_nettotal"+rowcnt).value) * (Number(f1(eval("form_basket.tax_purchase"+rowcnt).value))+100) ) /100 ) ));  
		/*Aksiyon Fiyat KDV Dahil hesaplaniyor*/
		eval("form_basket.action_price"+rowcnt).value = commaSplit(f2( Math.round ( ( (f1(eval("form_basket.row_nettotal"+rowcnt).value)*(Number(actProfMarg) + 100))*(Number(f1(eval("form_basket.tax"+rowcnt).value)) + 100) ) / 10000 ) ));
	}
	function actPriceChanged(rowcnt)
	{
		actPrice = f1(eval("form_basket.action_price"+rowcnt).value);
		if (actPrice == '') {eval("form_basket.action_price"+rowcnt).value=0;actPrice = 0;}

		/*Aksiyon Fiyat KDV Dahil hesaplaniyor*/
		if (f1(eval("form_basket.row_nettotal"+rowcnt).value) != 0)
			eval("form_basket.action_profit_margin"+rowcnt).value = commaSplit(f2( Math.round( ((( ((actPrice*100)/(Number(f1(eval("form_basket.tax"+rowcnt).value)) + 100)) - f1(eval("form_basket.row_nettotal"+rowcnt).value))*100)/f1(eval("form_basket.row_nettotal"+rowcnt).value)) * 100 ) / 100 ));
		else
			eval("form_basket.action_profit_margin"+rowcnt).value = 0;
	}
	function discChanged_2(rowcnt)
	{
		indirim1 = f1(eval("form_basket.disc_ount1"+rowcnt).value); 
		indirim2 = f1(eval("form_basket.disc_ount2"+rowcnt).value);
		indirim3 = f1(eval("form_basket.disc_ount3"+rowcnt).value);
		indirim4 = f1(eval("form_basket.disc_ount4"+rowcnt).value);
		indirim5 = f1(eval("form_basket.disc_ount5"+rowcnt).value);
		indirim6 = f1(eval("form_basket.disc_ount6"+rowcnt).value); 
		indirim7 = f1(eval("form_basket.disc_ount7"+rowcnt).value);
		indirim8 = f1(eval("form_basket.disc_ount8"+rowcnt).value);
		indirim9 = f1(eval("form_basket.disc_ount9"+rowcnt).value);
		indirim10 = f1(eval("form_basket.disc_ount10"+rowcnt).value);
		if (indirim1 == '') {eval("form_basket.disc_ount1"+rowcnt).value=0;indirim1 = 0;}
		if (indirim2 == '') {eval("form_basket.disc_ount2"+rowcnt).value=0;indirim2 = 0;}
		if (indirim3 == '') {eval("form_basket.disc_ount3"+rowcnt).value=0;indirim3 = 0;}
		if (indirim4 == '') {eval("form_basket.disc_ount4"+rowcnt).value=0;indirim4 = 0;}
		if (indirim5 == '') {eval("form_basket.disc_ount5"+rowcnt).value=0;indirim5 = 0;}
		if (indirim6 == '') {eval("form_basket.disc_ount6"+rowcnt).value=0;indirim6 = 0;}
		if (indirim7 == '') {eval("form_basket.disc_ount7"+rowcnt).value=0;indirim7 = 0;}
		if (indirim8 == '') {eval("form_basket.disc_ount8"+rowcnt).value=0;indirim8 = 0;}
		if (indirim9 == '') {eval("form_basket.disc_ount9"+rowcnt).value=0;indirim9 = 0;}
		if (indirim10 == '') {eval("form_basket.disc_ount10"+rowcnt).value=0;indirim10 = 0;}
		actProfMarg = f1(eval("form_basket.action_profit_margin"+rowcnt).value);
		if (actProfMarg == '') {eval("form_basket.action_profit_margin"+rowcnt).value=0;actProfMarg = 0;}

		/*Net Maliyet 2 hesaplaniyor (10 indirim de dahil maliyete !!!)*/
		eval("form_basket.row_nettotal_2"+rowcnt).value = commaSplit(f2( Math.round( (f1(eval("form_basket.p_price"+rowcnt).value)/100000000000000000000) * ( (100-indirim1) * (100-indirim2) * (100-indirim3) * (100-indirim4) * (100-indirim5) * (100-indirim6) * (100-indirim7) * (100-indirim8) * (100-indirim9) * (100-indirim10) ) ) ));
		/*
		KDV li maliyet hesaplaniyor
		eval("form_basket.row_lasttotal"+rowcnt).value = commaSplit(f2( Math.round( (f1(eval("form_basket.row_nettotal"+rowcnt).value) * (Number(f1(eval("form_basket.tax_purchase"+rowcnt).value))+100) ) /100 ) ));  
		Aksiyon Fiyat KDV Dahil hesaplaniyor
		eval("form_basket.action_price"+rowcnt).value = commaSplit(f2( Math.round ( ( (f1(eval("form_basket.row_nettotal"+rowcnt).value)*(Number(actProfMarg) + 100))*(Number(f1(eval("form_basket.tax"+rowcnt).value)) + 100) ) / 10000 ) ));
		*/
	}
</script>
